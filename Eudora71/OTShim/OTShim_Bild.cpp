// OTShim_Bild.cpp - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1,
//                   Stufe 4 (Bilder)
//
// Zu OTShim_Bild.h. Die Begruendung jeder Entscheidung - Technikwahl,
// einheitliche DIB-Form, Speicherverwaltung, Liste der Aufrufstellen - steht
// im Kopf jenes Headers und wird hier nicht wiederholt.
//
// UEBERSETZUNG: die Datei bindet <afxwin.h> selbst ein und benutzt Eudoras
// vorkompilierten Header nicht. Beim Einhaengen in Eudora.vcxproj daher fuer
// diese Datei "Vorkompilierte Header: Nicht verwenden" (/Y-) setzen - genau
// wie fuer OTShim.cpp.
//
// BINDEN: gdiplus.lib wird unten ueber #pragma comment(lib, ...) angefordert,
// die Projektdatei muss also nicht angefasst werden.
//
// Kodierung: reines ASCII, kein BOM.

#include <afxwin.h>

// GlobalAllocPtr/GlobalFreePtr. VERBINDLICH, nicht austauschbar: QCPng
// belegt m_lpBMI und m_lpSrcBits selbst mit GlobalAllocPtr (QCGraphics.cpp:
// 484, 493); freigegeben wird beides hier.
#include <windowsx.h>

// CreateStreamOnHGlobal / GetHGlobalFromStream
#include <objbase.h>

// gdiplus.h braucht min und max. Sind die Makros aus windef.h vorhanden
// (Regelfall, solange NOMINMAX nicht gesetzt ist), stoert das Folgende
// nicht - "using std::min;" ohne Klammern loest ein funktionsartiges Makro
// nicht aus. Ist NOMINMAX doch einmal gesetzt, greift diese Zeile.
#include <algorithm>
using std::min;
using std::max;

#include <objidl.h>
#include <gdiplus.h>
#pragma comment(lib, "gdiplus.lib")

#include "OTShim_Bild.h"


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL A - HILFSMITTEL, DIE NUR IN DIESER DATEI GELTEN
//
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
// GDI+ starten
//
// GDI+ verlangt GdiplusStartup vor der ersten Benutzung und GdiplusShutdown
// danach. Es gibt hier keinen Ort, an dem sich das an den Programmstart
// haengen liesse, ohne OTShim.cpp oder Eudoras eigene Quellen anzufassen -
// und beides ist fuer diese Stufe ausgeschlossen.
//
// Deshalb ein blockstatisches Objekt: es wird beim ersten Bild angelegt und
// beim Programmende wieder abgeraeumt. Seit C++11 ist die Anlage eines
// solchen Objekts vom Uebersetzer gegen gleichzeitige Zugriffe aus mehreren
// Ausfuehrungsstraengen abgesichert ("magic statics", in MSVC ab 2015
// vorhanden und in Visual Studio 2022 an) - das ist wichtig, weil Eudora
// Bilder auch ausserhalb des Hauptstrangs laedt.
//
// GdiplusShutdown darf laut Schnittstellenbeschreibung nicht aus DllMain
// heraus aufgerufen werden. Hier entsteht der Aufruf im Aufraeumteil eines
// Programms (Eudora.exe), nicht in einer DLL-Entladung.

namespace
{
	class OTShimGdiPlusStart
	{
	public:
		OTShimGdiPlusStart() : m_token(0), m_bBereit(FALSE)
		{
			Gdiplus::GdiplusStartupInput eingabe;
			m_bBereit = (Gdiplus::GdiplusStartup(&m_token, &eingabe, NULL) == Gdiplus::Ok);
			ASSERT(m_bBereit);
		}

		~OTShimGdiPlusStart()
		{
			if (m_bBereit)
				Gdiplus::GdiplusShutdown(m_token);
		}

		BOOL Bereit() const { return m_bBereit; }

	private:
		ULONG_PTR	m_token;
		BOOL		m_bBereit;
	};
}

static BOOL OTShimGdiPlusBereit()
{
	static OTShimGdiPlusStart start;
	return start.Bereit();
}


/////////////////////////////////////////////////////////////////////////////
// Kodierer suchen
//
// GDI+ kennt seine Kodierer nur ueber eine Liste, die zur Laufzeit abgefragt
// wird. Gesucht wird ueber den MIME-Typ ("image/jpeg", "image/bmp"), weil das
// die einzige Angabe ist, die die Beschreibung als stabil zusichert.

static BOOL OTShimKodiererSuchen(LPCWSTR lpszMimeTyp, CLSID* pClsid)
{
	ASSERT(lpszMimeTyp != NULL && pClsid != NULL);

	UINT nAnzahl = 0;
	UINT nBytes  = 0;

	if (Gdiplus::GetImageEncodersSize(&nAnzahl, &nBytes) != Gdiplus::Ok)
		return FALSE;
	if (nAnzahl == 0 || nBytes == 0)
		return FALSE;

	BYTE* pPuffer = new BYTE[nBytes];
	Gdiplus::ImageCodecInfo* pInfo = reinterpret_cast<Gdiplus::ImageCodecInfo*>(pPuffer);

	BOOL bGefunden = FALSE;

	if (Gdiplus::GetImageEncoders(nAnzahl, nBytes, pInfo) == Gdiplus::Ok)
	{
		for (UINT i = 0; i < nAnzahl; i++)
		{
			if (pInfo[i].MimeType != NULL && wcscmp(pInfo[i].MimeType, lpszMimeTyp) == 0)
			{
				*pClsid = pInfo[i].Clsid;
				bGefunden = TRUE;
				break;
			}
		}
	}

	delete [] pPuffer;
	return bGefunden;
}


/////////////////////////////////////////////////////////////////////////////
// CFile <-> IStream
//
// GDI+ nimmt Dateinamen oder IStream entgegen, aber keine CFile. Eudora
// reicht an DoLoadImage/DoSaveImage jedoch eine CFile durch (so schreibt es
// secimage.h:126,127 vor), und mindestens eine Aufrufstelle - der Weg ueber
// SECImage::SaveImage(CFile*) - hat gar keinen Dateinamen mehr. Deshalb der
// Umweg ueber einen Speicherstrom.
//
// Der Preis ist, dass das Bild einmal vollstaendig im Speicher liegt. Bei den
// Bildern, um die es geht - Werbebanner, Vorschaubilder von 32x34 Punkten,
// Emoticons, Werkzeugleistensymbole - faellt das nicht ins Gewicht.

static IStream* OTShimStromAusDatei(CFile* pFile)
{
	ASSERT(pFile != NULL);

	ULONGLONG ullLaenge = 0;
	ULONGLONG ullPos    = 0;

	try
	{
		ullLaenge = pFile->GetLength();
		ullPos    = pFile->GetPosition();
	}
	catch (CFileException* e)
	{
		e->Delete();
		return NULL;
	}

	if (ullPos >= ullLaenge)
		return NULL;

	ULONGLONG ullRest = ullLaenge - ullPos;

	// Ueber 2 GB kann kein Bild sein, das Eudora anzeigt; die Umrechnung nach
	// UINT waere dann ausserdem nicht mehr verlustfrei.
	if (ullRest > 0x7FFFFFFF)
		return NULL;

	HGLOBAL hSpeicher = ::GlobalAlloc(GMEM_MOVEABLE, static_cast<SIZE_T>(ullRest));
	if (hSpeicher == NULL)
		return NULL;

	LPVOID pZiel = ::GlobalLock(hSpeicher);
	if (pZiel == NULL)
	{
		::GlobalFree(hSpeicher);
		return NULL;
	}

	UINT nGelesen = 0;
	try
	{
		nGelesen = pFile->Read(pZiel, static_cast<UINT>(ullRest));
	}
	catch (CFileException* e)
	{
		e->Delete();
		nGelesen = 0;
	}
	::GlobalUnlock(hSpeicher);

	if (nGelesen != static_cast<UINT>(ullRest))
	{
		::GlobalFree(hSpeicher);
		return NULL;
	}

	IStream* pStrom = NULL;
	// TRUE: der Strom uebernimmt den Speicherblock und gibt ihn bei Release
	// wieder frei.
	if (FAILED(::CreateStreamOnHGlobal(hSpeicher, TRUE, &pStrom)))
	{
		::GlobalFree(hSpeicher);
		return NULL;
	}

	return pStrom;
}


static BOOL OTShimStromInDatei(IStream* pStrom, CFile* pFile)
{
	ASSERT(pStrom != NULL && pFile != NULL);

	STATSTG zustand;
	::ZeroMemory(&zustand, sizeof(zustand));
	if (FAILED(pStrom->Stat(&zustand, STATFLAG_NONAME)))
		return FALSE;

	if (zustand.cbSize.QuadPart == 0 || zustand.cbSize.QuadPart > 0x7FFFFFFF)
		return FALSE;

	HGLOBAL hSpeicher = NULL;
	if (FAILED(::GetHGlobalFromStream(pStrom, &hSpeicher)) || hSpeicher == NULL)
		return FALSE;

	LPVOID pQuelle = ::GlobalLock(hSpeicher);
	if (pQuelle == NULL)
		return FALSE;

	BOOL bErfolg = TRUE;
	try
	{
		pFile->Write(pQuelle, static_cast<UINT>(zustand.cbSize.QuadPart));
	}
	catch (CFileException* e)
	{
		e->Delete();
		bErfolg = FALSE;
	}

	::GlobalUnlock(hSpeicher);
	return bErfolg;
}


/////////////////////////////////////////////////////////////////////////////
// Alphaueberlagerung
//
// Wortgleich zu QCGraphics.cpp:293-300 (alpha_composite), damit ein ueber
// diese Schicht geladenes PNG genauso aussieht wie eines, das QCPng::LoadImage
// selbst einliest.
//
// EINE BEWUSSTE ABWEICHUNG: QCPng ueberlagert teildurchsichtige Punkte gegen
// Schwarz (QCGraphics.cpp:538-540 uebergeben 0 als Hintergrund), obwohl es
// vollstaendig durchsichtige Punkte gegen m_crTransparent setzt
// (QCGraphics.cpp:531-534). Hier wird durchgaengig gegen m_crTransparent
// ueberlagert - das ist offensichtlich das Gemeinte und erzeugt keinen
// dunklen Saum um die Bildkanten.

static inline BYTE OTShimUeberlagern(BYTE bVorne, BYTE bAlpha, BYTE bHinten)
{
	int nTemp = bVorne * bAlpha + bHinten * (255 - bAlpha) + 128;
	return static_cast<BYTE>((nTemp + (nTemp >> 8)) >> 8);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL B - SECImage
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNAMIC(SECImage, CObject)


/////////////////////////////////////////////////////////////////////////////
// Konstruktion und Zerstoerung

SECImage::SECImage()
{
	m_nSrcBitsPerPixel	= 0;
	m_nBitPlanes		= 1;
	m_bIsPadded			= FALSE;
	m_dwPadWidth		= 0;
	m_dwWidth			= 0;
	m_dwHeight			= 0;
	m_wColors			= 0;
	m_lpszFileName		= NULL;
	m_pPalette			= NULL;
	m_pFile				= NULL;
	m_lpSrcBits			= NULL;
	m_lpBMI				= NULL;
	m_lpRGB				= NULL;
	m_bUseHalftone		= FALSE;
	m_nBitHolder		= 0;
	m_dwBitCount		= 0;
	m_dwError			= 0;
	m_bSwapOnWrite		= FALSE;	// Vorgabe laut secimage.h:88-89

	m_dwCacheMax		= 0;
	m_dwCacheSize		= 0;
	m_dwCachePos		= 0;
	m_lpCache			= NULL;

	// Farbtiefe des Bildschirms merken. Das Original fuehrt die beiden Felder
	// ebenfalls (secimage.h:66,73); ausgewertet werden sie nur noch von der
	// auskommentierten Farbreduktion in QCGraphics.cpp:424.
	m_nSysBitsPerPixel	= 24;
	m_wSysColors		= 0;

	HDC hdcBildschirm = ::GetDC(NULL);
	if (hdcBildschirm != NULL)
	{
		m_nSysBitsPerPixel = ::GetDeviceCaps(hdcBildschirm, BITSPIXEL) *
							 ::GetDeviceCaps(hdcBildschirm, PLANES);
		if (m_nSysBitsPerPixel > 0 && m_nSysBitsPerPixel <= 8)
			m_wSysColors = static_cast<WORD>(1 << m_nSysBitsPerPixel);
		::ReleaseDC(NULL, hdcBildschirm);
	}

	// UNGEPRUEFT: welchen Vorgabewert das Original hier setzt, ist nicht
	// feststellbar - m_crTransparent ist ein QUALCOMM-Zusatz (secimage.h:141)
	// ohne Umsetzung in der Freigabe. Gewaehlt ist COLOR_3DFACE, weil genau
	// das die Vorgabe der beiden Klassen ist, die den Wert wirklich setzen:
	// QCPng (QCGraphics.h:45) und QCImage (QCGraphics.h:54) fuehren beide
	//     int in_nSystemTransparencySysColor = COLOR_3DFACE
	// als Standardargument. Wirksam wird der Wert nur, wenn ein .bmp oder
	// .jpg ueber EmoticonMenu.cpp:80 in eine CImageList wandert - fuer alle
	// anderen Formate ueberschreibt der QC-Konstruktor ihn ohnehin.
	m_crTransparent		= ::GetSysColor(COLOR_3DFACE);
}


// secimage.h:51. Von Eudora nicht benutzt.
//
// Weiterleitender Konstruktor (C++11): der Anfangszustand steht genau einmal,
// naemlich oben. Ein Hilfsobjekt ginge hier ohnehin nicht - SECImage ist
// abstrakt (secimage.h:126,127 sind rein virtuell).
SECImage::SECImage(LPCTSTR lpszFileName) : SECImage()
{
	// Wie im Original wird der Zeiger gemerkt, nicht die Zeichenkette kopiert
	// (secimage.h:74 fuehrt LPCTSTR, nicht CString). Wer diesen Konstruktor
	// benutzt, muss die Zeichenkette also am Leben halten. Eudora benutzt ihn
	// nirgends.
	m_lpszFileName		= lpszFileName;
}


SECImage::~SECImage()
{
	OTShimDibFreigeben();
	FreeCache();

	if (m_pPalette != NULL)
	{
		delete m_pPalette;
		m_pPalette = NULL;
	}

	// m_pFile wird NICHT geloescht: die CFile gehoert stets dem Aufrufer
	// (QCGraphics.cpp:95 uebergibt einen Dateinamen, SECImage oeffnet die
	// Datei selbst und schliesst sie noch in derselben Methode).
	m_pFile = NULL;
}


/////////////////////////////////////////////////////////////////////////////
// Zugaben dieser Schicht - Verwaltung des DIB

void SECImage::OTShimDibFreigeben()
{
	if (m_lpSrcBits != NULL)
	{
		GlobalFreePtr(m_lpSrcBits);
		m_lpSrcBits = NULL;
	}

	if (m_lpBMI != NULL)
	{
		GlobalFreePtr(m_lpBMI);
		m_lpBMI = NULL;
	}

	// m_lpRGB zeigt immer nur in m_lpBMI->bmiColors hinein und ist nie ein
	// eigener Speicherblock - hier also nur nachziehen, nicht freigeben.
	m_lpRGB			= NULL;

	m_dwWidth		= 0;
	m_dwHeight		= 0;
	m_dwPadWidth	= 0;
	m_wColors		= 0;
	m_bIsPadded		= FALSE;
	m_nBitHolder	= 0;
	m_dwBitCount	= 0;
}


BOOL SECImage::OTShimDibAnlegen(DWORD dwWidth, DWORD dwHeight)
{
	OTShimDibFreigeben();

	if (dwWidth == 0 || dwHeight == 0)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	// 24 Bit heisst 3 Byte je Punkt; die Zeilenlaenge wird auf ein Vielfaches
	// von 4 Byte aufgerundet. Der Ueberlaufschutz greift bei Bildern jenseits
	// von rund 700 Millionen Punkten - unerreichbar fuer das, was Eudora
	// anzeigt, aber ohne Pruefung waere die Rechnung stillschweigend falsch.
	if (dwWidth > 0x0000FFFF || dwHeight > 0x0000FFFF)
	{
		m_dwError = ERROR_ARITHMETIC_OVERFLOW;
		return FALSE;
	}

	m_dwWidth			= dwWidth;
	m_dwHeight			= dwHeight;
	m_nSrcBitsPerPixel	= 24;
	m_nBitPlanes		= 1;
	m_wColors			= 0;
	m_bIsPadded			= TRUE;
	m_dwPadWidth		= CalcBytesPerLine(24, dwWidth);

	DWORD dwDatenBytes = m_dwPadWidth * m_dwHeight;

	// sizeof(BITMAPINFO) statt sizeof(BITMAPINFOHEADER): der Aufbau enthaelt
	// bereits einen RGBQUAD, und ::GetDIBits schreibt dort auch dann hinein,
	// wenn es keine Farbtabelle gibt. QCPng belegt an dieser Stelle nur
	// sizeof(BITMAPINFOHEADER) (QCGraphics.cpp:484) und liegt damit vier Byte
	// zu knapp; das wird hier nicht nachgemacht.
	m_lpBMI = static_cast<LPBITMAPINFO>(GlobalAllocPtr(GHND, sizeof(BITMAPINFO)));
	if (m_lpBMI == NULL)
	{
		m_dwError = ERROR_NOT_ENOUGH_MEMORY;
		OTShimDibFreigeben();
		return FALSE;
	}

	m_lpBMI->bmiHeader.biSize			= sizeof(BITMAPINFOHEADER);
	m_lpBMI->bmiHeader.biWidth			= static_cast<LONG>(m_dwWidth);
	m_lpBMI->bmiHeader.biHeight			= static_cast<LONG>(m_dwHeight);	// positiv = von unten nach oben
	m_lpBMI->bmiHeader.biPlanes			= 1;
	m_lpBMI->bmiHeader.biBitCount		= 24;
	m_lpBMI->bmiHeader.biCompression	= BI_RGB;
	m_lpBMI->bmiHeader.biSizeImage		= dwDatenBytes;
	m_lpBMI->bmiHeader.biXPelsPerMeter	= 0;
	m_lpBMI->bmiHeader.biYPelsPerMeter	= 0;
	m_lpBMI->bmiHeader.biClrUsed		= 0;
	m_lpBMI->bmiHeader.biClrImportant	= 0;

	m_lpSrcBits = static_cast<LPBYTE>(GlobalAllocPtr(GHND, dwDatenBytes));
	if (m_lpSrcBits == NULL)
	{
		m_dwError = ERROR_NOT_ENOUGH_MEMORY;
		OTShimDibFreigeben();
		return FALSE;
	}

	m_dwError = 0;
	return TRUE;
}


BOOL SECImage::OTShimLadenUeberGdiPlus(CFile* pFile)
{
	if (pFile == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	if (!OTShimGdiPlusBereit())
	{
		m_dwError = ERROR_NOT_READY;
		return FALSE;
	}

	IStream* pStrom = OTShimStromAusDatei(pFile);
	if (pStrom == NULL)
	{
		m_dwError = ERROR_READ_FAULT;
		return FALSE;
	}

	BOOL bErfolg = FALSE;

	{
		// Eigener Block: das Bild muss vor dem Release des Stroms zerstoert
		// sein, denn GDI+ liest bei manchen Formaten erst beim Zugriff nach.
		Gdiplus::Bitmap bild(pStrom, FALSE);

		if (bild.GetLastStatus() == Gdiplus::Ok)
		{
			UINT nBreite = bild.GetWidth();
			UINT nHoehe  = bild.GetHeight();

			if (nBreite > 0 && nHoehe > 0)
			{
				// Hat das Bild einen Alphakanal, wird er gegen
				// m_crTransparent verrechnet; sonst reicht der kurze Weg.
				BOOL bMitAlpha = Gdiplus::IsAlphaPixelFormat(bild.GetPixelFormat());

				Gdiplus::PixelFormat format = bMitAlpha ? PixelFormat32bppARGB
														: PixelFormat24bppRGB;
				Gdiplus::Rect bereich(0, 0, static_cast<INT>(nBreite), static_cast<INT>(nHoehe));
				Gdiplus::BitmapData daten;
				::ZeroMemory(&daten, sizeof(daten));

				if (bild.LockBits(&bereich, Gdiplus::ImageLockModeRead, format, &daten) == Gdiplus::Ok)
				{
					if (OTShimDibAnlegen(nBreite, nHoehe))
					{
						const BYTE bHintenB = GetBValue(m_crTransparent);
						const BYTE bHintenG = GetGValue(m_crTransparent);
						const BYTE bHintenR = GetRValue(m_crTransparent);

						for (UINT y = 0; y < nHoehe; y++)
						{
							// GDI+ liefert die Zeilen von oben nach unten, ein
							// DIB mit positivem biHeight erwartet sie von
							// unten nach oben - deshalb die Umkehrung.
							const BYTE* pQuelle = static_cast<const BYTE*>(daten.Scan0) +
												  static_cast<INT_PTR>(y) * daten.Stride;
							BYTE* pZiel = m_lpSrcBits +
										  static_cast<INT_PTR>(nHoehe - 1 - y) *
										  static_cast<INT_PTR>(m_dwPadWidth);

							if (!bMitAlpha)
							{
								// PixelFormat24bppRGB liegt bereits als
								// B,G,R vor - dieselbe Reihenfolge wie im DIB.
								::CopyMemory(pZiel, pQuelle, nBreite * 3);
							}
							else
							{
								for (UINT x = 0; x < nBreite; x++)
								{
									BYTE b = *pQuelle++;
									BYTE g = *pQuelle++;
									BYTE r = *pQuelle++;
									BYTE a = *pQuelle++;

									if (a == 255)
									{
										*pZiel++ = b;
										*pZiel++ = g;
										*pZiel++ = r;
									}
									else
									{
										*pZiel++ = OTShimUeberlagern(b, a, bHintenB);
										*pZiel++ = OTShimUeberlagern(g, a, bHintenG);
										*pZiel++ = OTShimUeberlagern(r, a, bHintenR);
									}
								}
							}
						}

						bErfolg = TRUE;
					}

					bild.UnlockBits(&daten);
				}
				else
				{
					m_dwError = ERROR_INVALID_DATA;
				}
			}
			else
			{
				m_dwError = ERROR_INVALID_DATA;
			}
		}
		else
		{
			// Kein von GDI+ erkanntes Bildformat, beschaedigte Datei oder
			// abgeschnittene Daten.
			m_dwError = ERROR_INVALID_DATA;
		}
	}

	pStrom->Release();

	if (bErfolg)
		m_dwError = 0;

	return bErfolg;
}


BOOL SECImage::OTShimSpeichernUeberGdiPlus(CFile* pFile, LPCWSTR lpszMimeTyp, long nQualitaet)
{
	if (pFile == NULL || m_lpBMI == NULL || m_lpSrcBits == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	if (!OTShimGdiPlusBereit())
	{
		m_dwError = ERROR_NOT_READY;
		return FALSE;
	}

	CLSID kodierer;
	if (!OTShimKodiererSuchen(lpszMimeTyp, &kodierer))
	{
		// Ohne Kodierer laesst sich nichts schreiben. Das kann nur eintreten,
		// wenn GDI+ auf dem Rechner beschnitten ist - fuer BMP und JPEG
		// gehoeren die Kodierer zum Lieferumfang.
		m_dwError = ERROR_NOT_SUPPORTED;
		return FALSE;
	}

	IStream* pStrom = NULL;
	if (FAILED(::CreateStreamOnHGlobal(NULL, TRUE, &pStrom)))
	{
		m_dwError = ERROR_NOT_ENOUGH_MEMORY;
		return FALSE;
	}

	BOOL bErfolg = FALSE;

	{
		// FromBITMAPINFO legt keine Kopie an, sondern arbeitet auf
		// m_lpSrcBits. Der Puffer muss also bis zum Ende dieses Blocks stehen
		// bleiben - er tut es, er gehoert dem Objekt.
		Gdiplus::Bitmap* pBild = Gdiplus::Bitmap::FromBITMAPINFO(m_lpBMI, m_lpSrcBits);

		if (pBild != NULL && pBild->GetLastStatus() == Gdiplus::Ok)
		{
			Gdiplus::Status ergebnis;

			if (nQualitaet >= 0)
			{
				ULONG ulQualitaet = static_cast<ULONG>(nQualitaet);

				Gdiplus::EncoderParameters parameter;
				parameter.Count = 1;
				parameter.Parameter[0].Guid           = Gdiplus::EncoderQuality;
				parameter.Parameter[0].Type           = Gdiplus::EncoderParameterValueTypeLong;
				parameter.Parameter[0].NumberOfValues = 1;
				parameter.Parameter[0].Value          = &ulQualitaet;

				ergebnis = pBild->Save(pStrom, &kodierer, &parameter);
			}
			else
			{
				ergebnis = pBild->Save(pStrom, &kodierer, NULL);
			}

			if (ergebnis == Gdiplus::Ok)
				bErfolg = OTShimStromInDatei(pStrom, pFile);
			else
				m_dwError = ERROR_WRITE_FAULT;
		}
		else
		{
			m_dwError = ERROR_INVALID_DATA;
		}

		delete pBild;
	}

	pStrom->Release();

	if (bErfolg)
		m_dwError = 0;

	return bErfolg;
}


/////////////////////////////////////////////////////////////////////////////
// Attribute

DWORD SECImage::dwGetWidth()
{
	return m_dwWidth;
}


DWORD SECImage::dwGetHeight()
{
	return m_dwHeight;
}


// Von Eudora nicht aufgerufen. Da diese Schicht ausschliesslich 24-Bit-DIBs
// ohne Farbtabelle erzeugt, gibt es nichts anzulegen - der Rueckgabewert ist
// dann FALSE. Der Zweig fuer den Fall MIT Farbtabelle ist trotzdem
// ausgeschrieben, damit die Methode kein blosser Platzhalter ist: sollte eine
// spaetere Stufe wieder Bilder mit Farbtabelle erzeugen, stimmt sie sofort.
BOOL SECImage::CreatePalette()
{
	if (m_pPalette != NULL)
	{
		delete m_pPalette;
		m_pPalette = NULL;
	}

	if (m_lpBMI == NULL || m_wColors == 0)
		return FALSE;

	DWORD dwBytes = sizeof(LOGPALETTE) + (m_wColors - 1) * sizeof(PALETTEENTRY);
	LPLOGPALETTE pLog = reinterpret_cast<LPLOGPALETTE>(new BYTE[dwBytes]);

	pLog->palVersion    = 0x300;
	pLog->palNumEntries = m_wColors;

	for (WORD i = 0; i < m_wColors; i++)
	{
		pLog->palPalEntry[i].peRed   = m_lpBMI->bmiColors[i].rgbRed;
		pLog->palPalEntry[i].peGreen = m_lpBMI->bmiColors[i].rgbGreen;
		pLog->palPalEntry[i].peBlue  = m_lpBMI->bmiColors[i].rgbBlue;
		pLog->palPalEntry[i].peFlags = 0;
	}

	m_pPalette = new CPalette;
	BOOL bErfolg = m_pPalette->CreatePalette(pLog);

	delete [] reinterpret_cast<BYTE*>(pLog);

	if (!bErfolg)
	{
		delete m_pPalette;
		m_pPalette = NULL;
	}

	return bErfolg;
}


/////////////////////////////////////////////////////////////////////////////
// Operationen

// Von Eudora nicht aufgerufen, aber Grundlage von ConvertImage.
BOOL SECImage::CopyImage(SECImage *pSrc)
{
	ASSERT(pSrc != NULL);
	if (pSrc == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}
	if (pSrc == this)
		return TRUE;

	OTShimDibFreigeben();

	if (pSrc->m_lpBMI == NULL || pSrc->m_lpSrcBits == NULL)
	{
		// Leere Quelle: das Ziel ist danach ebenfalls leer. Kein Fehler.
		m_crTransparent = pSrc->m_crTransparent;
		return TRUE;
	}

	if (!OTShimDibAnlegen(pSrc->m_dwWidth, pSrc->m_dwHeight))
		return FALSE;

	// Beide Seiten haben denselben Aufbau (24 Bit, BI_RGB, aufgefuellt), die
	// Zeilenlaengen sind also gleich. Kopiert wird trotzdem zeilenweise und
	// mit der kleineren der beiden Laengen: brachte die Quelle doch einmal
	// eine andere Farbtiefe mit - etwa aus einer der vier nicht ersetzten
	// Schwesterklassen -, waere ein Blockkopieren ein Schreiben ueber den
	// Puffer hinaus.
	DWORD dwZeile = min(m_dwPadWidth, pSrc->m_dwPadWidth);
	ASSERT(m_dwPadWidth == pSrc->m_dwPadWidth);

	for (DWORD y = 0; y < m_dwHeight; y++)
	{
		::CopyMemory(m_lpSrcBits + static_cast<INT_PTR>(y) * static_cast<INT_PTR>(m_dwPadWidth),
					 pSrc->m_lpSrcBits + static_cast<INT_PTR>(y) * static_cast<INT_PTR>(pSrc->m_dwPadWidth),
					 dwZeile);
	}

	m_crTransparent = pSrc->m_crTransparent;
	m_bUseHalftone  = pSrc->m_bUseHalftone;
	m_bSwapOnWrite  = pSrc->m_bSwapOnWrite;

	return TRUE;
}


// QCGraphics.cpp:233 (Jpeg.ConvertImage(&Dib)) und :262.
//
// Im Original rechnete diese Methode zwischen Farbtiefen und Farbtabellen um -
// deshalb der eigene Name neben CopyImage. In dieser Schicht liegt jedes Bild
// bereits als 24-Bit-DIB ohne Farbtabelle vor (siehe OTShim_Bild.h,
// "EINE EINZIGE DIB-FORM"), es gibt also nichts umzurechnen. Das ist kein
// Dummy: das Ergebnis ist genau das, was der Aufrufer erwartet, naemlich ein
// SECJpeg, das anschliessend die Bilddaten des uebergebenen SECDib enthaelt
// und mit SaveImage als JPEG geschrieben werden kann.
BOOL SECImage::ConvertImage(SECImage *pSrc)
{
	return CopyImage(pSrc);
}


// Von Eudora nicht aufgerufen.
CBitmap *SECImage::MakeBitmap(CDC *pDC, const TCHAR *lpszFileName)
{
	if (!LoadImage(lpszFileName))
		return NULL;

	return MakeBitmap(pDC);
}


// EmoticonMenu.cpp:58, LinkHistoryManager.cpp:602.
// Der Aufrufer uebernimmt das Ergebnis und loescht es selbst
// (EmoticonMenu.cpp:113, LinkHistoryManager.cpp:608).
CBitmap *SECImage::MakeBitmap(CDC *pDC)
{
	if (m_lpBMI == NULL || m_lpSrcBits == NULL)
		return NULL;

	HDC hdc      = (pDC != NULL) ? pDC->GetSafeHdc() : NULL;
	HDC hdcEigen = NULL;

	if (hdc == NULL)
	{
		hdcEigen = ::CreateCompatibleDC(NULL);
		hdc = hdcEigen;
	}
	if (hdc == NULL)
		return NULL;

	HBITMAP hBitmap = ::CreateDIBitmap(hdc, &m_lpBMI->bmiHeader, CBM_INIT,
									   m_lpSrcBits, m_lpBMI, DIB_RGB_COLORS);

	if (hdcEigen != NULL)
		::DeleteDC(hdcEigen);

	if (hBitmap == NULL)
	{
		m_dwError = ::GetLastError();
		return NULL;
	}

	CBitmap* pBitmap = new CBitmap;
	pBitmap->Attach(hBitmap);
	return pBitmap;
}


/////////////////////////////////////////////////////////////////////////////
// Laden und Speichern
//
// Der Ablauf ist der des Originals (secimage.h:99-102 zusammen mit den
// Overridables :120-127):
//     LoadImage -> PreLoadImage -> DoLoadImage -> PostLoadImage
//     SaveImage -> PreSaveImage -> DoSaveImage -> PostSaveImage
// QCPng::LoadImage und QCImage::LoadImage bestaetigen ihn: beide rufen
// PreLoadImage selbst auf (QCGraphics.cpp:331, 574) und QCImage danach
// PostLoadImage (:624), weil sie DoLoadImage ueberspringen.

BOOL SECImage::LoadImage(CFile* pFile)
{
	if (pFile == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	if (!PreLoadImage())
		return FALSE;

	m_pFile = pFile;
	BOOL bErfolg = DoLoadImage(pFile);
	m_pFile = NULL;

	if (bErfolg)
		bErfolg = PostLoadImage();

	return bErfolg;
}


// QCGraphics.cpp:95 ruft das ueber SECImage* auf - fuer .bmp landet es bei
// dieser Fassung (QCPng und QCImage haben eigene).
BOOL SECImage::LoadImage(LPCTSTR lpszFileName)
{
	if (lpszFileName == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	if (!PreLoadImage())
		return FALSE;

	CFile			datei;
	CFileException	fehler;

	if (!datei.Open(lpszFileName, CFile::modeRead | CFile::shareDenyWrite, &fehler))
	{
		m_dwError = fehler.m_lOsError;
		return FALSE;
	}

	m_lpszFileName = lpszFileName;
	m_pFile        = &datei;

	BOOL bErfolg = FALSE;
	try
	{
		bErfolg = DoLoadImage(&datei);
	}
	catch (CFileException* e)
	{
		// QCGraphics.cpp:97-100 faengt CFileException um LoadImage herum
		// selbst ab, das Original hat also durchgelassen. Hier wird die
		// Ausnahme trotzdem abgefangen und in FALSE umgesetzt: der Aufrufer
		// wertet FALSE ohnehin aus (:101), und so kann kein halb geladenes
		// Objekt an einer Stelle auftauchen, die nicht mit Ausnahmen rechnet.
		m_dwError = e->m_lOsError;
		e->Delete();
		bErfolg = FALSE;
	}

	m_pFile = NULL;
	datei.Close();

	if (bErfolg)
		bErfolg = PostLoadImage();

	return bErfolg;
}


BOOL SECImage::SaveImage(CFile* pFile)
{
	if (pFile == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	if (!PreSaveImage())
		return FALSE;

	m_pFile = pFile;
	BOOL bErfolg = DoSaveImage(pFile);
	m_pFile = NULL;

	if (bErfolg)
		bErfolg = PostSaveImage();

	return bErfolg;
}


// QCGraphics.cpp:234 und :263 (JPEG), LinkHistoryManager.cpp:1250 (BMP).
BOOL SECImage::SaveImage(LPCTSTR lpszFileName)
{
	if (lpszFileName == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	if (!PreSaveImage())
		return FALSE;

	CFile			datei;
	CFileException	fehler;

	if (!datei.Open(lpszFileName,
					CFile::modeCreate | CFile::modeWrite | CFile::shareExclusive,
					&fehler))
	{
		m_dwError = fehler.m_lOsError;
		return FALSE;
	}

	m_pFile = &datei;

	BOOL bErfolg = FALSE;
	try
	{
		bErfolg = DoSaveImage(&datei);
	}
	catch (CFileException* e)
	{
		m_dwError = e->m_lOsError;
		e->Delete();
		bErfolg = FALSE;
	}

	m_pFile = NULL;
	datei.Close();

	if (bErfolg)
		bErfolg = PostSaveImage();

	return bErfolg;
}


/////////////////////////////////////////////////////////////////////////////
// Bildbearbeitung
//
// Die folgenden fuenf Methoden ruft Eudora nirgends auf - weder ueber
// SECImage noch ueber QCImage, QCPng oder QCJpeg. Geprueft ueber alle .cpp
// und .h unter Eudora/. Sie bleiben nach der Regel "Dummy statt Weglassen"
// erhalten und melden sich beim ersten Aufruf einmal je Sitzung, damit ein
// spaeterer Aufruf nicht still nichts tut.
//
// Nachbauen liesse sich jede von ihnen ohne Weiteres (es sind
// Umkopiervorgaenge auf einem 24-Bit-DIB). Das geschieht nicht, weil ohne
// Aufrufstelle auch kein Pruefstein da waere - eine ungenutzte, ungepruefte
// Umsetzung waere schlechter als ein Dummy, der sich meldet.

BOOL SECImage::FlipHorz()
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Ein Bild waagerecht spiegeln (Stingray SECImage::FlipHorz)."));
	return FALSE;
}


BOOL SECImage::FlipVert()
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Ein Bild senkrecht spiegeln (Stingray SECImage::FlipVert)."));
	return FALSE;
}


BOOL SECImage::Rotate90(BOOL /*bClockwise*/)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Ein Bild um 90 Grad drehen (Stingray SECImage::Rotate90)."));
	return FALSE;
}


void SECImage::ContrastImage(short /*nSharpen*/)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Den Kontrast eines Bildes veraendern (Stingray ")
		_T("SECImage::ContrastImage)."));
}


BOOL SECImage::Crop(long /*nLeft*/, long /*nTop*/, long /*nWidth*/, long /*nHeight*/)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Einen Ausschnitt aus einem Bild herausloesen (Stingray ")
		_T("SECImage::Crop)."));
	return FALSE;
}


DWORD SECImage::NumBytes()
{
	if (m_lpBMI == NULL)
		return 0;

	return m_lpBMI->bmiHeader.biSizeImage;
}


WORD SECImage::NumColors()
{
	return m_wColors;
}


// Duenne Huelle um ::StretchDIBits, wie sie das Original anbietet
// (secimage.h:113-115). Eudora ruft ueberall unmittelbar ::StretchDIBits auf
// und benutzt diese Fassung nirgends; sie ist trotzdem echt umgesetzt, weil
// sie nichts weiter tut, als durchzureichen.
int SECImage::StretchDIBits(CDC *pDC, int XDest, int YDest, int cxDest, int cyDest,
	int XSrc, int YSrc, int cxSrc, int cySrc, const void FAR* lpvBits,
	LPBITMAPINFO lpbmi, UINT fuColorUse, DWORD fdwRop)
{
	if (pDC == NULL || pDC->GetSafeHdc() == NULL)
		return GDI_ERROR;

	return ::StretchDIBits(pDC->GetSafeHdc(), XDest, YDest, cxDest, cyDest,
						   XSrc, YSrc, cxSrc, cySrc, lpvBits, lpbmi,
						   fuColorUse, fdwRop);
}


/////////////////////////////////////////////////////////////////////////////
// CreateFromBitmap
//
// Zur Begruendung der beiden Vorkehrungen (Mehrfachaufruf, ausgewaehlte
// Quellbitmap) siehe den Kommentar an der Deklaration in OTShim_Bild.h.

BOOL SECImage::CreateFromBitmap(CDC *pDC, CBitmap *pSrcBitmap)
{
	// Das Original assertiert hier ebenfalls, prueft aber laut
	// QCGraphics.cpp:252-253 nicht auf NULL ("CreateFromBitmap asserts but
	// doesn't bother checking for NULL before calling a CBitmap method").
	// Hier wird beides getan.
	ASSERT(pSrcBitmap != NULL);
	if (pSrcBitmap == NULL || pSrcBitmap->GetSafeHandle() == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	BITMAP bm;
	::ZeroMemory(&bm, sizeof(bm));
	if (pSrcBitmap->GetBitmap(&bm) == 0 || bm.bmWidth <= 0 || bm.bmHeight <= 0)
	{
		m_dwError = ERROR_INVALID_DATA;
		return FALSE;
	}

	HDC hdc      = (pDC != NULL) ? pDC->GetSafeHdc() : NULL;
	HDC hdcEigen = NULL;

	if (hdc == NULL)
	{
		hdcEigen = ::CreateCompatibleDC(NULL);
		hdc = hdcEigen;
	}
	if (hdc == NULL)
	{
		m_dwError = ERROR_NOT_ENOUGH_MEMORY;
		return FALSE;
	}

	HBITMAP hQuelle = static_cast<HBITMAP>(pSrcBitmap->GetSafeHandle());

	// Ist die Quellbitmap in eben diesem DC ausgewaehlt, muss die Auswahl
	// zuerst geloest werden - ::GetDIBits darf sonst nicht angewandt werden.
	// Als Platzhalter dient eine 1x1-Bitmap; ein Stock-Objekt fuer Bitmaps
	// gibt es nicht.
	HBITMAP hPlatzhalter	= NULL;
	BOOL    bWarAusgewaehlt	= (::GetCurrentObject(hdc, OBJ_BITMAP) == static_cast<HGDIOBJ>(hQuelle));

	if (bWarAusgewaehlt)
	{
		hPlatzhalter = ::CreateBitmap(1, 1, 1, 1, NULL);
		if (hPlatzhalter != NULL)
			::SelectObject(hdc, hPlatzhalter);
		else
			bWarAusgewaehlt = FALSE;	// dann eben der Versuch ohne Loesen
	}

	// Legt den DIB neu an und gibt dabei den vorherigen frei - das ist die
	// Vorkehrung gegen das Leck beim Mehrfachaufruf.
	BOOL bErfolg = OTShimDibAnlegen(static_cast<DWORD>(bm.bmWidth),
									static_cast<DWORD>(bm.bmHeight));

	if (bErfolg)
	{
		int nZeilen = ::GetDIBits(hdc, hQuelle, 0, static_cast<UINT>(bm.bmHeight),
								  m_lpSrcBits, m_lpBMI, DIB_RGB_COLORS);

		if (nZeilen == 0)
		{
			m_dwError = ::GetLastError();
			OTShimDibFreigeben();
			bErfolg = FALSE;
		}
		else
		{
			// ::GetDIBits schreibt biSizeImage selbst; auf jeden Fall
			// nachziehen, damit m_dwPadWidth und der Kopf zusammenpassen.
			m_lpBMI->bmiHeader.biSizeImage = m_dwPadWidth * m_dwHeight;
			m_dwError = 0;
		}
	}

	if (bWarAusgewaehlt)
	{
		::SelectObject(hdc, hQuelle);
		if (hPlatzhalter != NULL)
			::DeleteObject(hPlatzhalter);
	}

	if (hdcEigen != NULL)
		::DeleteDC(hdcEigen);

	return bErfolg;
}


/////////////////////////////////////////////////////////////////////////////
// Ueberschreibbares

// QCGraphics.cpp:331 (QCPng, Rueckgabewert nicht ausgewertet) und
// QCGraphics.cpp:574 (QCImage, Rueckgabewert ausgewertet).
//
// Wichtig: die Puffer eines vorherigen Ladevorgangs muessen hier weg.
// QCPng::LoadImage belegt m_lpBMI und m_lpSrcBits gleich darauf neu
// (QCGraphics.cpp:484, 493), ohne selbst freizugeben - ohne diese Zeile
// leckte jedes zweite Laden auf demselben Objekt.
BOOL SECImage::PreLoadImage()
{
	OTShimDibFreigeben();

	if (m_pPalette != NULL)
	{
		delete m_pPalette;
		m_pPalette = NULL;
	}

	m_dwError = 0;
	return TRUE;
}


// QCGraphics.cpp:624 (QCImage). Im Original vermutlich der Ort der
// Farbreduktion; hier ist nach dem Laden nichts mehr zu tun.
BOOL SECImage::PostLoadImage()
{
	return (m_lpBMI != NULL && m_lpSrcBits != NULL);
}


// Von Eudora nicht aufgerufen; nur ueber SaveImage erreichbar.
BOOL SECImage::PreSaveImage()
{
	m_dwError = 0;
	return (m_lpBMI != NULL && m_lpSrcBits != NULL);
}


BOOL SECImage::PostSaveImage()
{
	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// Rechenmethoden
//
// Alle drei sind oeffentlich (secimage.h:145-147), werden von Eudora aber
// nicht aufgerufen. Sie sind trotzdem echt umgesetzt, weil ihre Bedeutung
// eindeutig ist.

// "calculate padding width" (secimage.h:145). Der Name des zugehoerigen
// Feldes - m_dwPadWidth - und dessen Belegung in QCGraphics.cpp:482
//     m_dwPadWidth = PADWIDTH((m_dwWidth * m_nSrcBitsPerPixel) / 8);
// belegen, dass damit die AUFGEFUELLTE Zeilenlaenge gemeint ist und nicht die
// Zahl der Fuellbytes. Deshalb dasselbe Ergebnis wie CalcBytesPerLine.
DWORD SECImage::CalcPadding(DWORD dwBitsPerPixel, DWORD dwPixels)
{
	return CalcBytesPerLine(dwBitsPerPixel, dwPixels);
}


// UNGEPRUEFT: dass damit die Zahl der Bytes bis zum letzten Bildpunkt einer
// Zeile gemeint ist - also die Zeilenlaenge OHNE Fuellbytes -, ist aus dem
// Namen erschlossen; der Header sagt nichts dazu und es gibt keine
// Aufrufstelle.
DWORD SECImage::LastByte(DWORD dwBitsPerPixel, DWORD dwPixels)
{
	return (dwPixels * dwBitsPerPixel + 7) / 8;
}


DWORD SECImage::CalcBytesPerLine(DWORD dwBitsPerPixel, DWORD dwWidth)
{
	// DIB-Zeilen liegen auf 4-Byte-Grenzen. Dieselbe Rechnung wie das Makro
	// PADWIDTH, nur ohne den Umweg ueber die Byte-Zahl.
	return ((dwWidth * dwBitsPerPixel + 31) & ~31UL) / 8;
}


// Die Bilddaten dieser Schicht sind IMMER aufgefuellt - OTShimDibAnlegen
// rechnet die Zeilenlaenge ueber CalcBytesPerLine aus, GDI+ und ::GetDIBits
// liefern nichts anderes. PadBits hat deshalb nichts zu tun und meldet
// Erfolg. UnPadBits wuerde die Daten dagegen in eine Form bringen, die kein
// Aufrufer dieser Schicht verarbeiten kann (::StretchDIBits verlangt
// aufgefuellte Zeilen) - deshalb dort ein Dummy mit Meldung.
BOOL SECImage::PadBits()
{
	ASSERT(m_lpSrcBits == NULL || m_bIsPadded);
	return TRUE;
}


BOOL SECImage::UnPadBits()
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Bilddaten ohne Zeilenauffuellung ablegen (Stingray ")
		_T("SECImage::UnPadBits). Die Ersatzschicht arbeitet ")
		_T("ausschliesslich mit aufgefuellten Zeilen."));
	return FALSE;
}


/////////////////////////////////////////////////////////////////////////////
// Dateicache
//
// Der Cache des Originals ist ein Puffer, mit dem dessen handgeschriebene
// Formatleser haeppchenweise durch die Datei gingen. Diese Schicht liest und
// schreibt in einem Stueck ueber einen Speicherstrom und braucht ihn nicht.
// Alle sechs Methoden sind geschuetzt und haben ausserhalb der ersetzten
// Formatleser nie einen Aufrufer gehabt - auch die vier nicht ersetzten
// Schwesterklassen SECGif, SECPcx, SECTarga und SECTiff bauen Eudora nicht
// mit. Sie bleiben als Dummy erhalten.

BOOL SECImage::InitCache(DWORD /*dwBytes*/, WORD /*wMode*/)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Der haeppchenweise Dateipuffer der Stingray-Bildklassen ")
		_T("(SECImage::InitCache). Die Ersatzschicht liest und schreibt ")
		_T("Bilder in einem Stueck."));
	return FALSE;
}


DWORD SECImage::LoadCache()
{
	return 0;		// nie ein Cache vorhanden - siehe InitCache
}


DWORD SECImage::GetCache(void* /*pBuf*/, DWORD /*dwBytes*/)
{
	return 0;		// nie ein Cache vorhanden - siehe InitCache
}


DWORD SECImage::PutCache(void* /*pBuf*/, DWORD /*dwBytes*/)
{
	return 0;		// nie ein Cache vorhanden - siehe InitCache
}


void SECImage::FlushCache()
{
	// Nichts zu tun: es gibt keinen Cache, der geschrieben werden muesste.
}


void SECImage::FreeCache()
{
	// m_lpCache ist in dieser Schicht immer NULL. Die Freigabe steht
	// trotzdem hier, damit der Destruktor vollstaendig ist, falls eine
	// spaetere Stufe den Cache doch nachruestet.
	if (m_lpCache != NULL)
	{
		GlobalFreePtr(m_lpCache);
		m_lpCache = NULL;
	}

	m_dwCacheMax  = 0;
	m_dwCacheSize = 0;
	m_dwCachePos  = 0;
}


// Zwischenformat, in dem das Original ein beliebiges SECImage ueber
// CArchive abgelegt hat (secimage.h:158). Ohne Serialize ohne Aufgabe; siehe
// dort.
BOOL SECImage::SECLoadDib(CFile* /*pFile*/)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Ein Bild aus dem Stingray-Zwischenformat lesen ")
		_T("(SECImage::SECLoadDib)."));
	return FALSE;
}


/////////////////////////////////////////////////////////////////////////////
// Serialize
//
// Das Original konnte Bilder ueber CArchive in ein Dokument schreiben. Eudora
// tut das nirgends: es gibt keinen einzigen Aufruf von Serialize auf einem
// SECImage, SECDib oder SECJpeg, und keine der drei abgeleiteten Klassen
// QCImage, QCPng, QCJpeg wird jemals in ein CArchive gegeben.
//
// Die Methode bleibt trotzdem - DECLARE_SERIAL verlangt sie, und ohne
// DECLARE_SERIAL fehlte SECDib und SECJpeg die Laufzeitklasse. Sie meldet
// sich beim ersten Aufruf, damit ein spaeterer Aufruf nicht stillschweigend
// ein leeres Bild ablegt.

void SECImage::Serialize(CArchive &ar)
{
	CObject::Serialize(ar);

	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Ein Bild ueber ein CArchive lesen oder schreiben ")
		_T("(SECImage::Serialize). Eudora benutzt diesen Weg nicht."));
}


#ifdef _DEBUG
void SECImage::AssertValid() const
{
	CObject::AssertValid();

	// Kopf und Daten gibt es nur zusammen.
	ASSERT((m_lpBMI == NULL) == (m_lpSrcBits == NULL));

	if (m_lpBMI != NULL)
	{
		ASSERT(m_dwWidth > 0 && m_dwHeight > 0);
		ASSERT(m_lpBMI->bmiHeader.biSize == sizeof(BITMAPINFOHEADER));
		// Alles, was diese Schicht erzeugt, ist 24 Bit von unten nach oben.
		ASSERT(m_lpBMI->bmiHeader.biBitCount == 24);
		ASSERT(m_lpBMI->bmiHeader.biHeight > 0);
		ASSERT(m_dwPadWidth >= m_dwWidth * 3);
	}
}
#endif //_DEBUG


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL C - SECDib
//
/////////////////////////////////////////////////////////////////////////////

// Bezugsklasse ist SECImage, nicht CObject - moeglich geworden durch das
// DECLARE_DYNAMIC, das SECImage in dieser Schicht bekommen hat (siehe
// OTShim_Bild.h, Abschnitt 1, "ABWEICHUNG VOM ORIGINAL").
//
// UNGEPRUEFT: die Fassungsnummer. Sie steht in jedem ueber CArchive
// abgelegten Bild und muesste beim Lesen alter Dateien uebereinstimmen.
// Eudora legt keine ab (siehe SECImage::Serialize), deshalb 1.
IMPLEMENT_SERIAL(SECDib, SECImage, 1)


SECDib::SECDib() : SECImage()
{
	m_lpbmfHdr = NULL;
}


SECDib::~SECDib()
{
	if (m_lpbmfHdr != NULL)
	{
		delete m_lpbmfHdr;
		m_lpbmfHdr = NULL;
	}
}


/////////////////////////////////////////////////////////////////////////////
// SECDib::DoLoadImage - ueber GDI+
//
// Der Weg ueber GDI+ nimmt auch BMP-Spielarten an, die eine Handumsetzung
// nicht koennte: RLE4- und RLE8-Verdichtung, 16 und 32 Bit mit Bitmasken,
// BITMAPV4- und BITMAPV5-Koepfe, den alten OS/2-Kopf. Herauskommt immer die
// eine DIB-Form dieser Schicht.

BOOL SECDib::DoLoadImage(CFile* pFile)
{
	if (pFile == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	// Den Dateikopf abgreifen, bevor GDI+ die Daten bekommt. Das Feld
	// m_lpbmfHdr gehoert zur Oberflaeche von SECDib (SECDIB.H:45); Eudora
	// liest es nirgends, aber es soll nicht ohne Inhalt bleiben, wenn ein
	// echter BMP-Dateikopf vorlag.
	if (m_lpbmfHdr != NULL)
	{
		delete m_lpbmfHdr;
		m_lpbmfHdr = NULL;
	}

	try
	{
		ULONGLONG ullStart = pFile->GetPosition();

		BITMAPFILEHEADER kopf;
		if (pFile->Read(&kopf, sizeof(kopf)) == sizeof(kopf) &&
			kopf.bfType == DIB_HEADER_MARKER)
		{
			m_lpbmfHdr = new BITMAPFILEHEADER;
			*m_lpbmfHdr = kopf;
		}

		// In jedem Fall zurueckspulen - GDI+ braucht die Datei von vorn.
		pFile->Seek(static_cast<LONGLONG>(ullStart), CFile::begin);
	}
	catch (CFileException* e)
	{
		m_dwError = e->m_lOsError;
		e->Delete();
		return FALSE;
	}

	return OTShimLadenUeberGdiPlus(pFile);
}


/////////////////////////////////////////////////////////////////////////////
// SECDib::DoSaveImage - von Hand
//
// Hier wird bewusst NICHT ueber GDI+ gegangen. Der DIB liegt bereits genau in
// der Form vor, die eine .bmp-Datei verlangt - es sind drei Schreibvorgaenge.
// Das ist kuerzer als der Umweg ueber einen GDI+-Kodierer, byte-genau
// vorhersagbar (kein Kodierer entscheidet ueber Farbtiefe oder Verdichtung)
// und braucht GDI+ ueberhaupt nicht.
//
// Einzige Aufrufstelle: LinkHistoryManager.cpp:1250, wo ein Vorschaubild von
// 32x34 Punkten als .bmp neben der Verlaufsliste abgelegt wird.

BOOL SECDib::DoSaveImage(CFile* pFile)
{
	if (pFile == NULL || m_lpBMI == NULL || m_lpSrcBits == NULL)
	{
		m_dwError = ERROR_INVALID_PARAMETER;
		return FALSE;
	}

	DWORD dwFarbtabelle = m_wColors * sizeof(RGBQUAD);
	DWORD dwDaten       = m_dwPadWidth * m_dwHeight;

	BITMAPFILEHEADER kopf;
	::ZeroMemory(&kopf, sizeof(kopf));
	kopf.bfType    = DIB_HEADER_MARKER;			// 'BM'
	kopf.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + dwFarbtabelle;
	kopf.bfSize    = kopf.bfOffBits + dwDaten;

	try
	{
		pFile->Write(&kopf, sizeof(kopf));

		// biSizeImage sicherheitshalber nachziehen: ::GetDIBits darf den Wert
		// veraendert haben, und eine .bmp-Datei mit falschem biSizeImage
		// laesst sich von manchen Anzeigeprogrammen nicht oeffnen.
		m_lpBMI->bmiHeader.biSizeImage = dwDaten;

		pFile->Write(&m_lpBMI->bmiHeader, sizeof(BITMAPINFOHEADER));

		if (dwFarbtabelle > 0)
			pFile->Write(m_lpBMI->bmiColors, dwFarbtabelle);

		pFile->Write(m_lpSrcBits, dwDaten);
	}
	catch (CFileException* e)
	{
		m_dwError = e->m_lOsError;
		e->Delete();
		return FALSE;
	}

	// Den geschriebenen Dateikopf merken, damit m_lpbmfHdr zum Inhalt der
	// Datei passt.
	if (m_lpbmfHdr == NULL)
		m_lpbmfHdr = new BITMAPFILEHEADER;
	*m_lpbmfHdr = kopf;

	m_dwError = 0;
	return TRUE;
}


// Siehe SECImage::Serialize - von Eudora nicht benutzt.
void SECDib::Serialize(CArchive& ar)
{
	SECImage::Serialize(ar);
}


#ifdef _DEBUG
void SECDib::AssertValid() const
{
	SECImage::AssertValid();

	if (m_lpbmfHdr != NULL)
		ASSERT(m_lpbmfHdr->bfType == DIB_HEADER_MARKER);
}
#endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL D - SECJpeg
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_SERIAL(SECJpeg, SECImage, 1)


SECJpeg::SECJpeg() : SECImage()
{
	m_lpArrayPtr			= NULL;
	cache					= NULL;
	m_bQuantize				= FALSE;
	m_lpQuant				= NULL;

	// UNGEPRUEFT: die Vorgabe des Originals. 75 ist die Vorgabe von libjpeg
	// wie auch die von GDI+ und damit der Wert, bei dem sich die Ausgabe am
	// wenigsten von der frueheren unterscheidet. QCJpeg::DoSaveImage
	// (QCGraphics.cpp:278) ueberschreibt den Wert an der einzigen
	// Aufrufstelle ohnehin.
	m_nQuality				= 75;

	m_nSmoothing			= 0;
	m_bOptimizeEntropyCoding= FALSE;
	m_bArithmeticCoding		= FALSE;
}


SECJpeg::SECJpeg(LPCTSTR lpszFileName) : SECImage(lpszFileName)
{
	m_lpArrayPtr			= NULL;
	cache					= NULL;
	m_bQuantize				= FALSE;
	m_lpQuant				= NULL;
	m_nQuality				= 75;
	m_nSmoothing			= 0;
	m_bOptimizeEntropyCoding= FALSE;
	m_bArithmeticCoding		= FALSE;
}


SECJpeg::~SECJpeg()
{
	// m_lpArrayPtr und cache sind in dieser Schicht immer NULL: sie gehoerten
	// zum eingebetteten libjpeg, das hier entfaellt (siehe OTShim_Bild.h,
	// Abschnitt 3). m_lpQuant ebenso.
	ASSERT(m_lpArrayPtr == NULL);
	ASSERT(cache == NULL);
	ASSERT(m_lpQuant == NULL);
}


// Kein Eintrag in INVENTAR.md, aber ueber QCGraphics.cpp:81 erreichbar:
// bei Magiezahl 0xFFD8FF legt LoadImage ein QCJpeg an und ruft darauf
// LoadImage(LPCTSTR). QCJpeg ueberschreibt nur DoSaveImage, nicht
// DoLoadImage - der Aufruf landet also hier.
BOOL SECJpeg::DoLoadImage(CFile* pFile)
{
	return OTShimLadenUeberGdiPlus(pFile);
}


/////////////////////////////////////////////////////////////////////////////
// SECJpeg::DoSaveImage
//
// Der einzige Eintrag der Bildfamilie in INVENTAR.md. Aufgerufen aus
// QCGraphics.cpp:276-280:
//
//     BOOL QCJpeg::DoSaveImage(CFile* pFile)
//     {
//         m_nQuality = 200;
//         return SECJpeg::DoSaveImage(pFile);
//     }
//
// Auf diesem Weg schreibt Eudora JPEGs an zwei Stellen:
//     QCGraphics.cpp:234  CreateJpegFromIcon   (Symbol -> .jpg)
//     QCGraphics.cpp:263  CreateJpegFromBitmap (Bitmap -> .jpg)
//
// Zur Umrechnung von m_nQuality siehe die Anmerkung am Feld in
// OTShim_Bild.h: 200 sprengt sowohl den libjpeg- als auch den GDI+-Bereich
// 0..100; die Absicht "so gut wie moeglich" wird als 100 umgesetzt.
//
// NICHT UMGESETZT, weil GDI+ dafuer keinen Parameter anbietet: m_nSmoothing
// (Weichzeichnen vor dem Kodieren), m_bOptimizeEntropyCoding und
// m_bArithmeticCoding. Eudora setzt keines der drei Felder - geprueft ueber
// alle .cpp und .h unter Eudora/ -, sie bleiben also auf ihren Vorgaben und
// die Auslassung ist ohne Wirkung. Deshalb hier auch keine Meldung: sie
// wuerde bei jedem Speichern ausgeloest, ohne dass etwas fehlte.

BOOL SECJpeg::DoSaveImage(CFile* pFile)
{
	long nQualitaet = m_nQuality;

	if (nQualitaet < 0)
		nQualitaet = 0;
	if (nQualitaet > 100)
		nQualitaet = 100;

	return OTShimSpeichernUeberGdiPlus(pFile, L"image/jpeg", nQualitaet);
}


// Siehe SECImage::Serialize - von Eudora nicht benutzt.
void SECJpeg::Serialize(CArchive& ar)
{
	SECImage::Serialize(ar);
}


#ifdef _DEBUG
void SECJpeg::AssertValid() const
{
	SECImage::AssertValid();
}
#endif
