// OTShim_Bild.h - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1, Stufe 4
//
// Ersetzt die drei Originalheader
//
//     OT501/Include/secimage.h   SECImage  (abstrakte Basis aller Bildklassen)
//     OT501/Include/SECDIB.H     SECDib    (Windows-Bitmap)
//     OT501/Include/SECJPEG.H    SECJpeg   (JPEG) - samt eingebettetem libjpeg
//
// Eudora leitet davon drei Klassen ab (QCGraphics.h:36,42,51):
//
//     QCJpeg  : SECJpeg      QCPng : SECDib      QCImage : SECDib
//
// Diese Datei gehoert zu Stufe 4 aus OTShim/PLAN.md. Sie ist eigenstaendig:
// sie schreibt nichts in OTShim.h/OTShim.cpp (Stufe 0/1) und wird beim
// Zusammenfuehren neben diese gehaengt.
//
// Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.
//
//
// ===========================================================================
// TECHNIKWAHL: GDI+ - und warum nicht CImage und nicht WIC
// ===========================================================================
//
// Zu entscheiden war, womit BMP und JPEG dekodiert und kodiert werden. Drei
// Kandidaten standen zur Wahl; die Bewertung richtet sich danach, was Eudora
// wirklich braucht (siehe die Aufrufliste weiter unten).
//
//   (1) ATL CImage (atlimage.h)   - PLAN.md, Stufe 4, schlaegt das vor.
//       Dafuer:  kuerzester Code, kuemmert sich selbst um den GDI+-Start.
//       Dagegen: ZWEI harte Gruende.
//         a) CImage kennt keinen Qualitaetsparameter. SECJpeg hat aber
//            m_nQuality (SECJPEG.H:862), und QCJpeg::DoSaveImage
//            (QCGraphics.cpp:276-280) setzt ihn ausdruecklich auf 200, bevor
//            es an die Basisklasse weiterreicht. Mit CImage waere dieser
//            einzige echte Eingriff, den Eudora in die JPEG-Ausgabe macht,
//            wirkungslos - der Aufruf, der laut INVENTAR.md ueberhaupt der
//            einzige belegte Aufruf dieser Familie ist.
//         b) Eudora fuehrt unter Eudora/atlimage.h eine EIGENE, veraltete
//            Kopie von atlimage.h (1648 Zeilen gegen 2091 der Fassung aus
//            MSVC 14.38.33130). QCGraphics.cpp:27 bindet sie mit
//            #include "atlimage.h" ein, also die Kopie. Wuerde diese Datei
//            <atlimage.h> einbinden, kaeme die SDK-Fassung - zwei
//            verschiedene Definitionen derselben Klasse ATL::CImage in einem
//            Programm, beide mit demselben Waechter __ATLIMAGE_H__. Das ist
//            ein ODR-Verstoss; welche Fassung der Binder nimmt, ist offen.
//
//   (2) GDI+ unmittelbar (gdiplus.h)   - GEWAEHLT.
//       CImage ist ohnehin nur eine duenne Huelle um GDI+. Ohne die Huelle
//       ist der Code hier rund 40 Zeilen laenger, dafuer entfaellt (b) ganz
//       und (a) wird ueber Gdiplus::EncoderParameters/EncoderQuality
//       loesbar. GDI+ liegt seit Windows XP im System, deckt BMP, JPEG, GIF,
//       PNG und TIFF ab und ist damit breiter als das, was Stingray konnte.
//       Der Start wird ueber ein blockstatisches Objekt erledigt (siehe
//       OTShim_Bild.cpp), also beim ersten Bild und nicht beim Programmstart.
//
//   (3) WIC (wincodec.h)
//       Der modernere Weg, und ohne globalen Startvorgang. Er kostet hier
//       aber deutlich mehr Code (Factory, Decoder, Frame, FormatConverter,
//       Encoder, Stream - jeweils mit COM-Zeigerpflege) und bringt fuer
//       diesen Zweck keinen Vorteil: es werden BMP und JPEG gelesen und
//       geschrieben, mehr nicht. Verworfen.
//
// WAS GDI+ NICHT ERSETZT: die Schnittstelle. Fuenf Stellen in Eudora greifen
// roh auf die Datenfelder m_lpSrcBits/m_lpBMI zu und reichen sie unmittelbar
// an ::StretchDIBits weiter:
//     mainfrm.cpp:5683, 6158, 6185
//     LinkHistoryManager.cpp:1238
//     QCToolBarManager.cpp:428, 441, 454, 576, 589
//     QCGraphics.cpp:127 (MetafileFromImage)
// Die Felder bleiben deshalb genau so erhalten, wie secimage.h sie
// deklariert, und werden ueber ::GetDIBits bzw. Gdiplus::Bitmap::LockBits
// gefuellt.
//
//
// ===========================================================================
// EINE EINZIGE DIB-FORM
// ===========================================================================
//
// Alles, was diese Schicht erzeugt, ist ein DIB mit
//
//     24 Bit je Bildpunkt, BI_RGB, unkomprimiert,
//     biHeight > 0 (also von unten nach oben), Zeilen auf 4 Byte aufgefuellt,
//     keine Farbtabelle (m_wColors == 0, m_lpRGB == NULL)
//
// BELEG, dass das die richtige Wahl ist: QCPng::LoadImage (QCGraphics.cpp:
// 479-491) baut sich genau diese Form selbst zusammen - 24 Bit, BI_RGB,
// biHeight positiv, m_wColors = 0 - und alle oben genannten
// ::StretchDIBits-Aufrufe uebergeben DIB_RGB_COLORS. Eine Farbtabelle wuerde
// dort niemand auswerten. Damit werden ausserdem CopyImage und ConvertImage
// zur selben Sache (siehe dort).
//
// SPEICHERVERWALTUNG - VERBINDLICH: m_lpBMI und m_lpSrcBits werden mit
// GlobalAllocPtr(GHND, ...) belegt und mit GlobalFreePtr freigegeben (beides
// windowsx.h). Das ist keine Geschmacksfrage: QCPng::LoadImage belegt beide
// Felder selbst mit GlobalAllocPtr (QCGraphics.cpp:484, 493) und gibt sie
// nie frei - das muss der Destruktor dieser Klasse tun. Mit new[]/delete[]
// oder malloc/free waere das ein Fehler auf dem Halde.
//
//
// ===========================================================================
// WAS EUDORA TATSAECHLICH BENUTZT
// ===========================================================================
//
// Ableitungen und Ueberschreibungen:
//   QCGraphics.h:36-40   QCJpeg : SECJpeg, ueberschreibt DoSaveImage
//   QCGraphics.h:42-49   QCPng  : SECDib,  ueberschreibt beide LoadImage
//   QCGraphics.h:51-58   QCImage: SECDib,  ueberschreibt beide LoadImage
//
// Aufrufe aus den abgeleiteten Klassen heraus:
//   QCGraphics.cpp:279   SECJpeg::DoSaveImage(pFile)   <- der einzige
//                        Eintrag der Bildfamilie in INVENTAR.md
//   QCGraphics.cpp:331   PreLoadImage()   (QCPng::LoadImage)
//   QCGraphics.cpp:574   PreLoadImage()   (QCImage::LoadImage)
//   QCGraphics.cpp:624   PostLoadImage()  (QCImage::LoadImage)
//   QCGraphics.cpp:615   CreateFromBitmap(CDC*, CBitmap*)
//   QCGraphics.cpp:366ff m_dwWidth, m_dwHeight, m_nSrcBitsPerPixel,
//                        m_dwPadWidth, m_wColors, m_nBitPlanes, m_lpBMI,
//                        m_lpSrcBits, m_crTransparent, PADWIDTH
//
// Aufrufe von aussen:
//   QCGraphics.cpp:95    LoadImage(LPCTSTR) ueber SECImage*
//   QCGraphics.cpp:226   CreateFromBitmap  (CreateJpegFromIcon)
//   QCGraphics.cpp:233   ConvertImage(SECImage*)
//   QCGraphics.cpp:234   SaveImage(LPCTSTR)
//   QCGraphics.cpp:258   CreateFromBitmap  (CreateJpegFromBitmap)
//   QCGraphics.cpp:262f  ConvertImage / SaveImage
//   QCGraphics.cpp:127   m_dwWidth/m_dwHeight/m_lpSrcBits/m_lpBMI
//   EmoticonMenu.cpp:58  MakeBitmap(CDC*)
//   EmoticonMenu.cpp:70f dwGetWidth(), dwGetHeight()
//   EmoticonMenu.cpp:80  GetTransparentColor()
//   LinkHistoryManager.cpp:602   MakeBitmap(CDC*)
//   LinkHistoryManager.cpp:1237f dwGetWidth/dwGetHeight/m_lpSrcBits/m_lpBMI
//   LinkHistoryManager.cpp:1244  new SECDib  (SECDib ist konkret!)
//   LinkHistoryManager.cpp:1249  CreateFromBitmap
//   LinkHistoryManager.cpp:1250  SaveImage(LPCTSTR)   -> schreibt .bmp
//   QCToolBarManager.cpp:419,567 SECDib auf dem Stapel
//   QCToolBarManager.cpp:421,434,447,569,582  CreateFromBitmap
//   mainfrm.cpp:5646f    dwGetWidth/dwGetHeight
//   mainfrm.cpp:5683,6158,6185  m_lpSrcBits/m_lpBMI
//
// Alles Uebrige aus secimage.h ist Kategorie C im Sinne von PLAN.md: es wird
// von Eudora nie aufgerufen. Es bleibt trotzdem deklariert und definiert
// (Regel "Dummy statt Weglassen"), und wo ein Dummy nichts tut, meldet er
// sich beim ersten Aufruf einmal je Sitzung ueber OTShimNichtUmgesetzt.
//
// BlitToDevice (QCGraphics.h:21) ist im ganzen Baum nur deklariert, nirgends
// definiert und nirgends aufgerufen - kein Handlungsbedarf.
//
//
// ===========================================================================
// EINBINDUNG
// ===========================================================================
//
// Diese Datei ersetzt secimage.h, SECDIB.H und SECJPEG.H und darf NICHT
// gemeinsam mit ihnen uebersetzt werden. Am Ende setzt sie deren Waechter
// __SECIMAGE_H__, __SECDIB_H__ und __SECJPEG_H__, damit ein spaeteres
//     #include "secall.h"          (Eudora/stdafx.h:52)
// die Originale ueberspringt (SECALL.H:79, 84, 94).
//
// ACHTUNG, ZWEITER WEG: QCGraphics.h:5-6 bindet "SecImage.h" und "SecJpeg.h"
// unmittelbar ein, also nicht ueber secall.h. Da stdafx.h (vorkompilierter
// Header) vor QCGraphics.h an die Reihe kommt, sind die Waechter dann schon
// gesetzt und beide Zeilen laufen ins Leere. Beim Zusammenfuehren muss
// OTShim_Bild.h daher an derselben Stelle stehen wie OTShim.h.
//
// NICHT ERSETZT werden SECGIF.H, SECPCX.H, SECTARGA.H und SECTIFF.H. Alle
// vier leiten zwar von SECImage ab (SECGIF.H:124, SECPCX.H:60,
// SECTARGA.H:165, SECTIFF.H:65), benutzen aber sonst nichts aus secimage.h -
// geprueft ueber alle vier Dateien. Sie uebersetzen also weiterhin, sofern
// SECImage vorher deklariert ist, und das leistet diese Datei. Eudora
// benutzt keine der vier.
//
// LoadImage IST EIN MAKRO. winuser.h macht daraus LoadImageA (MBCS-Bau).
// Aus SECImage::LoadImage wird also ueberall SECImage::LoadImageA - auch in
// secimage.h, auch in QCGraphics.h/.cpp und auch hier. Solange alle
// Uebersetzungseinheiten windows.h vor dieser Datei sehen, ist das
// durchgaengig und harmlos; es ist der Zustand, in dem Eudora 7.1 gebaut
// wurde. Deshalb wird hier NICHT entmakrot.

#ifndef __OTSHIM_BILD_H__
#define __OTSHIM_BILD_H__

#include <afxwin.h>			// CObject, CFile, CArchive, CDC, CBitmap, CPalette

#if defined(__SECIMAGE_H__) || defined(__SECDIB_H__) || defined(__SECJPEG_H__)
#error OTShim_Bild.h ersetzt secimage.h, SECDIB.H und SECJPEG.H - diese duerfen vorher nicht eingebunden sein.
#endif


// Sammelmeldung fuer alles, was erst eine spaetere Stufe umsetzt. Definiert
// in OTShim.cpp (Stufe 1); hier nur erneut deklariert, damit diese Datei fuer
// sich uebersetzbar bleibt. Eine wortgleiche Zweitdeklaration ist zulaessig,
// sie kollidiert also nicht mit der in OTShim.h.
// Jede Fundstelle bringt ihr eigenes statisches Flag mit und meldet sich
// hoechstens einmal je Sitzung.
void OTShimNichtUmgesetzt(BOOL& rbBereitsGemeldet, LPCTSTR lpszWas);


/////////////////////////////////////////////////////////////////////////////
// 1. SECImage  (Original: secimage.h:45)
//
// Abstrakte Basis. Der Feldsatz ist Feld fuer Feld und in derselben
// Reihenfolge uebernommen - jedes oeffentliche Feld ist eine Schnittstelle,
// die Eudora oder eine der vier nicht ersetzten Schwesterklassen anfassen
// koennte.
//
// ABWEICHUNG VOM ORIGINAL (die einzige an der Klassendefinition):
// DECLARE_DYNAMIC ist hinzugekommen. Das Original hat kein Laufzeitklassen-
// Makro, weshalb SECDib und SECJpeg ihr IMPLEMENT_SERIAL auf CObject haetten
// beziehen muessen - RUNTIME_CLASS(SECImage) haette es sonst nicht gegeben.
// DECLARE_DYNAMIC legt nur ein statisches Feld und eine virtuelle Methode an,
// die CObject ohnehin schon hat; Groesse und Aufbau der Objekte aendern sich
// nicht. Eudora benutzt RUNTIME_CLASS(SECImage) nirgends.

class SECImage : public CObject
{
	DECLARE_DYNAMIC(SECImage)

// Konstruktion
public:
	SECImage();
	// Von Eudora nicht benutzt. Merkt sich nur den Namen; geladen wird erst
	// bei LoadImage. UNGEPRUEFT: ob das Original hier bereits laedt, ist ohne
	// die Implementierung nicht feststellbar. Es wird hier nicht geladen,
	// weil ein Konstruktor keinen Fehler melden kann.
	SECImage(LPCTSTR lpszFileName);

// Attribute
public:
	// EmoticonMenu.cpp:70,71; mainfrm.cpp:5646,5647;
	// LinkHistoryManager.cpp:1237
	DWORD dwGetWidth();
	DWORD dwGetHeight();

	// Von Eudora nicht aufgerufen. Legt m_pPalette aus der Farbtabelle an.
	// Da diese Schicht ausschliesslich 24-Bit-DIBs erzeugt, gibt es nie eine
	// Farbtabelle - der Rueckgabewert ist daher praktisch immer FALSE.
	BOOL CreatePalette();

	// QUALCOMM-Zusatz im Original (secimage.h:60-63), Kommentar "// QC".
	// EmoticonMenu.cpp:80 uebergibt das Ergebnis an CImageList::Add als
	// Maskenfarbe.
	COLORREF		GetTransparentColor() const { return m_crTransparent; }
	void			SetTransparentColor(COLORREF in_crTransparent) { m_crTransparent = in_crTransparent; }

	int m_nSrcBitsPerPixel;		// QCGraphics.cpp:366,481 - immer 24
	int m_nSysBitsPerPixel;		// QCGraphics.cpp:424 (auskommentiert)
	int m_nBitPlanes;			// QCGraphics.cpp:480 - immer 1
	BOOL m_bIsPadded;
	DWORD m_dwPadWidth;			// QCGraphics.cpp:482,500 - Bytes je Zeile
	DWORD m_dwWidth;			// QCGraphics.cpp:127,366,486
	DWORD m_dwHeight;			// QCGraphics.cpp:127,366,487
	WORD m_wColors;				// QCGraphics.cpp:479 - immer 0
	WORD m_wSysColors;
	LPCTSTR m_lpszFileName;
	CPalette *m_pPalette;
	CFile *m_pFile;
#ifdef WIN32
	LPBYTE m_lpSrcBits;			// mainfrm.cpp:5683,6158,6185 u.a.
#else
	BYTE huge * m_lpSrcBits;
#endif
	LPBITMAPINFO m_lpBMI;		// mainfrm.cpp:5684,6159,6186 u.a.
	LPRGBQUAD m_lpRGB;			// zeigt in m_lpBMI->bmiColors, nie eigenstaendig
	BOOL m_bUseHalftone;
	int m_nBitHolder;			// nur fuer NEXT_IMAGE_PIXEL
	DWORD m_dwBitCount;			// nur fuer NEXT_IMAGE_PIXEL
	DWORD m_dwError;			// letzter Fehler, GetLastError-artig
	BOOL m_bSwapOnWrite;

// Operationen
public:
	// Von Eudora nicht aufgerufen. Vollstaendige Kopie samt Bilddaten.
	BOOL CopyImage(SECImage *pSrc);

	// QCGraphics.cpp:233 (Jpeg.ConvertImage(&Dib)) und :262.
	// Im Original: Umrechnung zwischen Farbtiefen und Farbtabellen. Hier ist
	// jedes Bild bereits 24 Bit BI_RGB, es bleibt also nichts umzurechnen -
	// ConvertImage ist deshalb dasselbe wie CopyImage. Das ist kein Dummy,
	// sondern das richtige Ergebnis fuer diese Datenform.
	BOOL ConvertImage(SECImage *pSrc);

	// Beide liefern ein frisch angelegtes CBitmap; der Aufrufer loescht es
	// (EmoticonMenu.cpp:113, LinkHistoryManager.cpp:608).
	CBitmap *MakeBitmap(CDC *pDC, const TCHAR *lpszFileName);
	CBitmap *MakeBitmap(CDC *pDC);		// EmoticonMenu.cpp:58, LHM:602

	// QCPng und QCImage ueberschreiben beide LoadImage-Fassungen
	// (QCGraphics.h:47,48,56,57). Der Weg ist immer
	//     LoadImage -> PreLoadImage -> DoLoadImage -> PostLoadImage
	virtual BOOL LoadImage(CFile* pFile);
	virtual BOOL LoadImage(LPCTSTR lpszFileName);	// QCGraphics.cpp:95
	virtual BOOL SaveImage(CFile* pFile);
	virtual BOOL SaveImage(LPCTSTR lpszFileName);	// QCGraphics.cpp:234,263

// Operationen - Bildbearbeitung
public:
	// Diese fuenf ruft Eudora nirgends auf - weder ueber SECImage noch ueber
	// eine der drei abgeleiteten Klassen. Sie bleiben deklariert und melden
	// sich beim ersten Aufruf (Regel "Dummy statt Weglassen"), damit ein
	// spaeterer Aufruf nicht still ins Leere laeuft.
	BOOL FlipHorz();
	BOOL FlipVert();
	BOOL Rotate90(BOOL bClockwise=TRUE);
	void ContrastImage(short nSharpen);
	BOOL Crop(long nLeft, long nTop, long nWidth, long nHeight);

	DWORD NumBytes();		// Bytes der Bilddaten
	WORD NumColors();		// Eintraege der Farbtabelle

	// Duenne Huelle um ::StretchDIBits. Von Eudora nicht benutzt - dort steht
	// ueberall der unmittelbare ::StretchDIBits-Aufruf mit m_lpSrcBits.
	int StretchDIBits(CDC *pDC, int XDest, int YDest, int cxDest, int cyDest,
	int XSrc, int YSrc, int cxSrc, int cySrc, const void FAR* lpvBits,
	LPBITMAPINFO lpbmi, UINT fuColorUse, DWORD fdwRop);

	// Der meistbenutzte Einstieg: QCGraphics.cpp:226,258,615;
	// LinkHistoryManager.cpp:1249; QCToolBarManager.cpp:421,434,447,569,582.
	//
	// ZWEI DINGE, DIE DIE AUFRUFSTELLEN ERZWINGEN:
	//  (a) Mehrfachaufruf auf demselben Objekt. QCToolBarManager.cpp ruft die
	//      Methode dreimal (421, 434, 447) bzw. zweimal (569, 582) auf ein und
	//      demselben secDIB2/secDIB auf. Die alten Puffer muessen also vorher
	//      freigegeben werden, sonst leckt es bei jedem Werkzeugleistenaufbau.
	//      (So auch PLAN.md, Stufe 4.)
	//  (b) Die Quellbitmap ist an drei von fuenf Stellen im uebergebenen DC
	//      ausgewaehlt: QCToolBarManager.cpp:420/421, 433/434, 446/447 und
	//      QCGraphics.cpp:167/226 waehlen sie unmittelbar davor aus.
	//      ::GetDIBits darf laut Schnittstellenbeschreibung nicht auf eine
	//      ausgewaehlte Bitmap angewandt werden. Die Umsetzung loest die
	//      Auswahl deshalb vorher und stellt sie danach wieder her.
	//      UNGEPRUEFT, aber auffaellig: der Kommentar in
	//      QCToolBarManager.cpp:417 ("Some users see messed up toolbar
	//      buttons") beschreibt genau das Schadensbild, das (b) erzeugt.
	BOOL CreateFromBitmap(CDC *pDC, CBitmap *pSrcBitmap);

// Ueberschreibbares
protected:
	// PreLoadImage: QCGraphics.cpp:331 (QCPng), :574 (QCImage). Gibt die
	// Puffer eines vorherigen Ladevorgangs frei. QCImage wertet den
	// Rueckgabewert aus, QCPng nicht.
	virtual BOOL PreLoadImage();
	// PostLoadImage: QCGraphics.cpp:624 (QCImage).
	virtual BOOL PostLoadImage();
	virtual BOOL PreSaveImage();
	virtual BOOL PostSaveImage();

	// Wie im Original rein virtuell - SECImage bleibt abstrakt.
	virtual BOOL DoSaveImage(CFile* pFile)=0;
	virtual BOOL DoLoadImage(CFile* pFile)=0;

// Umsetzung
protected:
	// Dateicache des Originals. Diese Schicht liest und schreibt in einem
	// Stueck ueber einen Speicherstrom und braucht ihn nicht; die Felder
	// bleiben, damit der Aufbau der Klasse stimmt, und sind stets 0/NULL.
	DWORD m_dwCacheMax;
	DWORD m_dwCacheSize;
	DWORD m_dwCachePos;
#ifdef WIN32
	LPBYTE m_lpCache;
#else
	BYTE huge *m_lpCache;
#endif
	// QUALCOMM-Zusatz. QCPng::QCPng und QCImage::QCImage schreiben das Feld
	// unmittelbar (QCGraphics.cpp:319,324,552,557), ebenso
	// QCPng::LoadImage (:392,394) - es muss geschuetzt bleiben, nicht privat.
	COLORREF	m_crTransparent;

public:
	// Von Eudora nicht aufgerufen. Die drei Rechenmethoden sind trotzdem
	// echt umgesetzt, weil sie eindeutig sind.
	DWORD CalcPadding(DWORD dwBitsPerPixel, DWORD dwPixels);
	DWORD LastByte(DWORD dwBitsPerPixel, DWORD dwPixels);
	DWORD CalcBytesPerLine(DWORD dwBitsPerPixel, DWORD dwWidth);
	// Die Daten liegen hier immer aufgefuellt vor (m_bIsPadded == TRUE),
	// deshalb sind beide No-Op. Siehe Umsetzung.
	BOOL PadBits();
	BOOL UnPadBits();

protected:
	// Cache-Hilfen des Originals. Ohne Cache ohne Aufgabe; siehe oben.
	BOOL InitCache(DWORD dwBytes, WORD wMode);
	DWORD LoadCache();
	DWORD GetCache(void *pBuf, DWORD dwBytes);
	DWORD PutCache(void *pBuf, DWORD dwBytes);
	void FlushCache();
	void FreeCache();
	// Zwischenformat des Originals fuer Serialize. Nicht umgesetzt.
	BOOL SECLoadDib(CFile *pFile);

// ---------------------------------------------------------------------------
// Zugaben dieser Schicht - im Original nicht vorhanden.
// Sie tragen das Namenspraefix OTShim, damit sofort sichtbar ist, dass sie
// nicht zur Stingray-Oberflaeche gehoeren. Alle geschuetzt, damit sie die
// Schnittstelle nach aussen nicht erweitern.
// ---------------------------------------------------------------------------
protected:
	// Gibt m_lpBMI/m_lpSrcBits frei (GlobalFreePtr) und setzt die
	// Geometriefelder zurueck.
	void OTShimDibFreigeben();
	// Legt einen leeren 24-Bit-DIB der angegebenen Groesse an.
	BOOL OTShimDibAnlegen(DWORD dwWidth, DWORD dwHeight);
	// Liest den gesamten Rest von pFile ueber GDI+ ein und legt das Ergebnis
	// als 24-Bit-DIB ab. Gemeinsame Grundlage von SECDib::DoLoadImage und
	// SECJpeg::DoLoadImage.
	BOOL OTShimLadenUeberGdiPlus(CFile* pFile);
	// Schreibt den aktuellen DIB ueber GDI+ in pFile. lpszMimeTyp waehlt den
	// Kodierer ("image/jpeg", "image/bmp", ...); nQualitaet wird nur bei
	// image/jpeg ausgewertet, -1 bedeutet "Vorgabe des Kodierers".
	BOOL OTShimSpeichernUeberGdiPlus(CFile* pFile, LPCWSTR lpszMimeTyp, long nQualitaet);

public:
	void Serialize(CArchive &ar);
	virtual ~SECImage();

#ifdef _DEBUG
	// Nicht virtuell deklariert wie im Original; ueberschreibt trotzdem
	// CObject::AssertValid, weil die Basis es virtuell deklariert.
	void AssertValid() const;
#endif //_DEBUG
};

// Makros wortgleich aus secimage.h:172-218 uebernommen. PADWIDTH wird von
// QCPng::LoadImage benutzt (QCGraphics.cpp:482), DIB_HEADER_MARKER von
// SECDib::DoSaveImage. NEXT_IMAGE_PIXEL braucht diese Schicht nicht mehr
// (es wandelt 1- und 4-Bit-Daten nach 8 Bit um, was hier GDI+ erledigt),
// bleibt aber erhalten: SECGIF.H, SECPCX.H, SECTARGA.H und SECTIFF.H sind
// nicht ersetzt und deren Quellen benutzen es.

#define PADWIDTH(x)	(((x)*8 + 31)  & (~31))/8
#define DIB_HEADER_MARKER	((WORD) ('M' << 8) | 'B')
#define SEC_READ_CACHE 0x01
#define SEC_WRITE_CACHE 0x02

#define NEXT_IMAGE_PIXEL(bDest, lpSrc) \
switch(m_nSrcBitsPerPixel) { \
case 1: \
		if (m_nBitHolder > 7) { \
			m_nBitHolder = 0; \
			lpSrc++; \
		} \
		if (m_bSwapOnWrite ==TRUE)\
			bDest = (BYTE)((*lpSrc >> (7-m_nBitHolder)) & (BYTE)0x01);\
		else\
			bDest = (BYTE)((*lpSrc >> m_nBitHolder) & (BYTE)0x01);\
		m_nBitHolder ++; \
		if (++m_dwBitCount >= m_dwWidth) { \
			m_dwBitCount = 0; \
			m_nBitHolder = 0; \
			lpSrc++; \
			} \
		break; \
case 4: \
		if (m_nBitHolder ==1) { \
			m_nBitHolder = 0; \
			bDest = (BYTE)(*lpSrc & (BYTE)0xf); \
			lpSrc++; \
			m_dwBitCount++; \
			if (m_dwBitCount >= m_dwWidth) \
				m_dwBitCount = 0; \
} \
		else {\
			bDest = (BYTE)(*lpSrc >> 4); \
			if (++m_dwBitCount >= m_dwWidth) { \
				lpSrc++; \
				m_dwBitCount = 0; \
				} \
			else \
				m_nBitHolder=1; \
} \
		bDest = (BYTE)(bDest & (BYTE)0x0f); \
		break; \
default : \
		bDest = *lpSrc++; \
}


/////////////////////////////////////////////////////////////////////////////
// 2. SECDib  (Original: SECDIB.H:35)
//
// Windows-Bitmap. Anders als bei den uebrigen Bildklassen ist SECDib eine
// KONKRETE Klasse, die Eudora selbst anlegt:
//     QCGraphics.cpp:80    pImage = new SECDib          (Format IF_BMP)
//     QCGraphics.cpp:225   SECDib Dib;                  (auf dem Stapel)
//     QCGraphics.cpp:255   pDib = new SECDib()
//     LinkHistoryManager.cpp:1244  new SECDib()
//     QCToolBarManager.cpp:419,567 auf dem Stapel
// Sie muss deshalb ohne Zutun funktionieren - Standardkonstruktor,
// CreateFromBitmap, SaveImage.
//
// LESEN und SCHREIBEN gehen absichtlich verschiedene Wege:
//   DoLoadImage  ueber GDI+. Das kostet nichts extra und nimmt auch
//                BMP-Spielarten an, die eine Handumsetzung nicht koennte
//                (RLE4/RLE8, 16 Bit mit Bitmasken, BITMAPV4/V5-Kopf,
//                OS/2-Kopf).
//   DoSaveImage  von Hand. Der DIB liegt bereits genau in der Form vor, die
//                eine .bmp-Datei verlangt; es sind drei Schreibvorgaenge
//                (Dateikopf, Informationskopf, Daten). Das ist kuerzer als
//                der Umweg ueber einen GDI+-Kodierer, byte-genau
//                vorhersagbar und braucht GDI+ ueberhaupt nicht.
//                Einzige Aufrufstelle: LinkHistoryManager.cpp:1250, das ein
//                Vorschaubild als .bmp ablegt.

class SECDib: public SECImage
{
	DECLARE_SERIAL(SECDib)

// Konstruktion
public:
	SECDib();

// Umsetzung
protected:
	// Der Dateikopf der zuletzt gelesenen oder geschriebenen .bmp-Datei.
	// Von Eudora nirgends gelesen. Wird belegt, sobald ein BMP-Dateikopf
	// wirklich vorlag, sonst NULL; der Destruktor gibt ihn frei.
	LPBITMAPFILEHEADER  m_lpbmfHdr;

	virtual BOOL DoSaveImage(CFile* pFile);
	virtual BOOL DoLoadImage(CFile* pFile);

public:
	void Serialize(CArchive& ar);
	virtual  ~SECDib();
#ifdef _DEBUG
	void AssertValid() const;
#endif
};


/////////////////////////////////////////////////////////////////////////////
// 3. SECJpeg  (Original: SECJPEG.H:207)
//
// WAS HIER FEHLT UND WARUM: der Originalheader deklariert zwischen
// SECJPEG.H:210 und :828 die vollstaendige libjpeg-Fassung 6 als PRIVATE
// Methoden und Felder der Klasse - rund 600 Zeilen, die jpeglib.h,
// jinclude.h, jmemsys.h, jdhuff.h, jchuff.h und jdct.h voraussetzen und die
// Typen ODITHER_MATRIX, comp_savable_state, comp_working_state,
// COMP_JPEG_MARKER, cp_phuff_entropy_encoder und box mitbringen
// (SECJPEG.H:47-204).
//
// Nichts davon ist von aussen erreichbar - alles ist privat. Die zugehoerige
// Umsetzung liegt in den 46 libjpeg-Dateien unter OT501/Src/image/JPEG, die
// nicht mitgebaut werden. PLAN.md, Stufe 4, zieht daraus den Schluss:
// "Damit entfaellt das komplette eingebettete libjpeg". Dieser Abschnitt
// folgt dem. Es ist kein Weglassen im Sinne der Projektregel: weggefallen
// ist eine Umsetzung, keine Schnittstelle. Die oeffentliche und geschuetzte
// Oberflaeche von SECJpeg ist vollstaendig da.
//
// Die sechs Typedefs aus SECJPEG.H:47-204 entfallen mit. Geprueft: kein
// anderer Header unter OT501/Include und keine Eudora-Quelle benutzt sie;
// Treffer gibt es nur in den libjpeg-Headern selbst.
//
// EINZIGER BELEGTER AUFRUF DER GANZEN BILDFAMILIE (INVENTAR.md, Abschnitt 2):
//     QCGraphics.cpp:276-280
//         BOOL QCJpeg::DoSaveImage(CFile* pFile)
//         { m_nQuality = 200; return SECJpeg::DoSaveImage(pFile); }
// DoSaveImage muss deshalb geschuetzt (nicht privat) und virtuell bleiben
// und m_nQuality muss oeffentlich beschreibbar sein - beides wie im Original.

class SECJpeg: public SECImage
{
protected:
	DECLARE_SERIAL(SECJpeg)

	// ACHTUNG: DECLARE_SERIAL beginnt mit "public:" (afx.h, _DECLARE_DYNAMIC).
	// Ohne die folgende Zeile waeren die beiden Methoden oeffentlich - im
	// Original stehen sie unter "protected:" (SECJPEG.H:214).
protected:
	// SECJPEG.H:215,216 - beide geschuetzt und virtuell.
	virtual BOOL DoLoadImage(CFile* pFile);
	virtual BOOL DoSaveImage(CFile* pFile);

public:
	virtual void Serialize(CArchive& ar);
#ifndef WIN32
	BOOL SECQuantizeImage();
#endif

	// Konstruktion
	SECJpeg();
	SECJpeg(LPCTSTR lpszFileName);
	~SECJpeg();

	// Umsetzung
private:
#ifdef WIN32
	// Im Original die Schreibmarke, mit der der JPEG-Dekodierer m_lpSrcBits
	// zeilenweise fuellt, und ein Zwischenspeicher der Farbreduktion. Beide
	// privat, beide ohne den eingebetteten Dekodierer ohne Aufgabe. Sie
	// bleiben als Felder erhalten und stehen stets auf NULL.
	LPBYTE m_lpArrayPtr;
	short *cache;
#else
	BYTE huge *m_lpArrayPtr;
	short huge *cache;
#endif

public:
	// Farbreduktion auf Systeme mit weniger Farben. Ueberholt: GDI+ liefert
	// immer 24 Bit, und seit Windows XP gibt es keine 256-Farb-Bildschirme
	// mehr, auf denen Eudora liefe. Der Wert wird nirgends ausgewertet.
	BOOL m_bQuantize;
	LPBYTE m_lpQuant;

	// QCGraphics.cpp:278 setzt das Feld auf 200.
	//
	// UNGEPRUEFT: welchen Wertebereich Stingray erwartet hat, ist ohne die
	// Umsetzung nicht feststellbar; die 200 sprengen den libjpeg-Bereich
	// 0..100 ebenso wie den von GDI+. Die Absicht - "so gut wie moeglich" -
	// ist aber eindeutig. DoSaveImage begrenzt den Wert deshalb auf 0..100
	// und reicht ihn als Gdiplus::EncoderQuality weiter; aus 200 wird 100.
	long	m_nQuality;

	// Weichzeichnen vor dem Kodieren und die zwei Schalter der
	// Entropiekodierung. libjpeg konnte das, GDI+ bietet dafuer keinen
	// Parameter an. Die Felder bleiben, werden aber nicht ausgewertet;
	// Eudora setzt keines davon.
	long	m_nSmoothing;
	BOOL	m_bOptimizeEntropyCoding;
	BOOL	m_bArithmeticCoding;

#ifdef _DEBUG
	void AssertValid() const;
#endif
};


// Waechter der ersetzten Originalheader setzen (siehe Einbindungshinweis oben)
#define __SECIMAGE_H__
#define __SECDIB_H__
#define __SECJPEG_H__


#endif // __OTSHIM_BILD_H__
