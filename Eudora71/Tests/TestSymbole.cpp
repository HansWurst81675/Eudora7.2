//
// TestSymbole.cpp - Befund E-30: Werkzeugleistensymbole und gesperrte Knoepfe
//
// DIE BEOBACHTUNG (Gregor, Fassung 7.2.0.10, Rechner ohne Visual Studio):
// Im Hauptfenster sind alle Symbole der Werkzeugleiste zu sehen. Sobald das
// Fenster "Find Messages" vorne ist, stehen an mehreren Stellen der Leiste
// LEERE GRAUE FLAECHEN - und zwar genau dort, wo der Knopf in diesem
// Zusammenhang nicht anwendbar, also GESPERRT ist.
//
// DIE URSACHE (gemessen, nicht vermutet):
//
//   1. CBitmap::LoadMappedBitmap ruft comctl32!CreateMappedBitmap
//      (atlmfc/include/afxwin1.inl:193). Diese Funktion setzt NUR die
//      Farbtabelle einer Bitmap um. Eine Bitmap mit mehr als 8 Bit
//      Farbtiefe hat keine Farbtabelle und bleibt daher unveraendert.
//
//   2. Die Bitmaps der HAUPTwerkzeugleiste (res\icons\tbar16.bmp und
//      Geschwister) sind 24 Bit mit dem Hintergrund 192,192,192. Die
//      Bitmaps der Fensterleisten (res\icons\RTB1.bmp) sind 8 Bit.
//
//   3. GetSysColor(COLOR_BTNFACE) ist auf heutigem Windows 240,240,240.
//      Damit traegt jedes Symbol der Hauptleiste seinen eigenen, um 48
//      Stufen dunkleren Hintergrund mit sich.
//
//   4. SECStdBtn::CreateMask (OTShim_Werkzeugleiste.cpp) baut die Maske des
//      gesperrten Knopfes, indem es den Knopfpuffer nach EINFARBIG kopiert
//      und dabei clrBtnFace als Hintergrundfarbe setzt: was diese Farbe hat,
//      wird 1, alles Uebrige 0. Stimmt der Bildhintergrund nicht mit
//      clrBtnFace ueberein, wird das GANZE Bildrechteck zu 0 - und
//      SECStdBtn::DrawDisabled malt seinen Pinsel genau dort, wo die Maske 0
//      ist. Der gesperrte Knopf wird zur einheitlichen grauen Flaeche.
//
// Unter VC6 fiel das nicht auf: dort war COLOR_BTNFACE selbst 192,192,192.
//
// WAS HIER GEPRUEFT WIRD
//
//   A  OTShimDibFarbeErsetzen - die neue Umsetzung fuer sich, ohne GDI:
//      trifft sie genau die richtigen Punkte, laesst sie alles andere in
//      Ruhe, weist sie Formate ab, die sie nicht beherrscht, und laeuft sie
//      nicht aus dem Puffer?
//
//   B  DER PRODUKTIVE LADEWEG. SECLoadToolBarResource wird mit einer echten
//      24-Bit-Leiste (tbar16.bmp) aufgerufen; danach muss der Hintergrund
//      der geladenen Bitmap COLOR_BTNFACE sein. DAS IST DIE SCHRANKE GEGEN
//      DEN RUECKFALL - ohne die Behebung liefert dieser Test 192,192,192.
//
//   C  Dasselbe mit einer 8-Bit-Leiste (RTB1.bmp): der alte, erprobte Weg
//      ueber comctl32 muss weiter funktionieren.
//
//   D  Die Ursachenkette selbst, mit GDI und ohne Fenster: dieselbe Folge
//      aus Maske und Praegung wie in SECStdBtn, einmal mit passendem und
//      einmal mit unpassendem Bildhintergrund. Der Test zeigt, dass der
//      unpassende Hintergrund tatsaechlich eine EINHEITLICHE Flaeche ergibt
//      und der passende ein gepraegtes Symbol. Dieser Test ist eine
//      Beschreibung des Mechanismus, KEINE Schranke - er ist auch vor der
//      Behebung gruen.
//
#include <afxwin.h>
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "TestRes.h"
#include "OTShim_Werkzeugleiste.h"


/////////////////////////////////////////////////////////////////////////////
// Hilfsmittel

// Legt einen DIB im Speicher an: BITMAPINFOHEADER, dahinter die Punkte.
// Liefert die Gesamtgroesse; der Aufrufer gibt den Block mit delete[] frei.
static BYTE* DibAnlegen(LONG lBreite, LONG lHoehe, WORD wBits, DWORD& dwGroesse)
{
	const DWORD dwZeile = (((DWORD)lBreite * (wBits / 8)) + 3) & ~(DWORD)3;
	dwGroesse = sizeof(BITMAPINFOHEADER) + dwZeile * (DWORD)lHoehe;

	BYTE* p = new BYTE[dwGroesse];
	memset(p, 0, dwGroesse);

	BITMAPINFOHEADER* pKopf = (BITMAPINFOHEADER*)p;
	pKopf->biSize        = sizeof(BITMAPINFOHEADER);
	pKopf->biWidth       = lBreite;
	pKopf->biHeight      = lHoehe;
	pKopf->biPlanes      = 1;
	pKopf->biBitCount    = wBits;
	pKopf->biCompression = BI_RGB;
	pKopf->biSizeImage   = dwZeile * (DWORD)lHoehe;

	return p;
}

static BYTE* DibPunkt(BYTE* pDib, LONG x, LONG y)
{
	BITMAPINFOHEADER* pKopf = (BITMAPINFOHEADER*)pDib;
	const int   nBytes  = pKopf->biBitCount / 8;
	const DWORD dwZeile = (((DWORD)pKopf->biWidth * nBytes) + 3) & ~(DWORD)3;
	return pDib + pKopf->biSize + (DWORD)y * dwZeile + (DWORD)x * nBytes;
}

static void DibSetzen(BYTE* pDib, LONG x, LONG y, COLORREF cr)
{
	BYTE* q = DibPunkt(pDib, x, y);
	q[0] = GetBValue(cr);
	q[1] = GetGValue(cr);
	q[2] = GetRValue(cr);
}

static COLORREF DibLesen(BYTE* pDib, LONG x, LONG y)
{
	const BYTE* q = DibPunkt(pDib, x, y);
	return RGB(q[2], q[1], q[0]);
}

// Liest einen Punkt aus einer fertigen GDI-Bitmap (DDB).
static BOOL BitmapPunkt(CBitmap& bmp, int x, int y, COLORREF& crAus)
{
	BITMAP bm;
	if (!bmp.GetObject(sizeof(bm), &bm))
		return FALSE;
	if (x < 0 || y < 0 || x >= bm.bmWidth || y >= bm.bmHeight)
		return FALSE;

	struct { BITMAPINFOHEADER h; DWORD m[3]; } bi;
	memset(&bi, 0, sizeof(bi));
	bi.h.biSize        = sizeof(BITMAPINFOHEADER);
	bi.h.biWidth       = bm.bmWidth;
	bi.h.biHeight      = -bm.bmHeight;			// von oben nach unten
	bi.h.biPlanes      = 1;
	bi.h.biBitCount    = 32;
	bi.h.biCompression = BI_RGB;

	BYTE* pZeile = new BYTE[(size_t)bm.bmWidth * 4];
	HDC   hdc    = ::GetDC(NULL);
	BOOL  bOk    = FALSE;

	if (hdc != NULL)
	{
		if (::GetDIBits(hdc, (HBITMAP)bmp.GetSafeHandle(), y, 1, pZeile,
						(BITMAPINFO*)&bi, DIB_RGB_COLORS) != 0)
		{
			crAus = RGB(pZeile[x*4+2], pZeile[x*4+1], pZeile[x*4+0]);
			bOk = TRUE;
		}
		::ReleaseDC(NULL, hdc);
	}

	delete [] pZeile;
	return bOk;
}


/////////////////////////////////////////////////////////////////////////////
// A - OTShimDibFarbeErsetzen

static void TestFarbeErsetzen(void)
{
	TT_BeginTest("E-30: OTShimDibFarbeErsetzen trifft genau die gesuchte Farbe");
	{
		DWORD dwGroesse = 0;
		BYTE* pDib = DibAnlegen(5, 3, 24, dwGroesse);

		// Ganze Flaeche auf den Werkzeugleistenhintergrund, dann drei
		// Punkte mit anderen Farben hineinsetzen.
		for (LONG y = 0; y < 3; ++y)
			for (LONG x = 0; x < 5; ++x)
				DibSetzen(pDib, x, y, RGB(192, 192, 192));

		DibSetzen(pDib, 1, 1, RGB(0, 0, 0));
		DibSetzen(pDib, 2, 1, RGB(128, 128, 128));
		DibSetzen(pDib, 3, 1, RGB(255, 255, 255));

		long lAnzahl = OTShimDibFarbeErsetzen(pDib, dwGroesse,
											  RGB(192, 192, 192),
											  RGB(240, 240, 240));

		// 15 Punkte insgesamt, 3 davon andersfarbig -> 12 umgesetzt.
		TT_CHECK(lAnzahl == 12);

		TT_CHECK(DibLesen(pDib, 0, 0) == RGB(240, 240, 240));
		TT_CHECK(DibLesen(pDib, 4, 2) == RGB(240, 240, 240));

		// Die drei anderen Farben muessen unangetastet geblieben sein -
		// genau darum wird NUR der Hintergrund umgesetzt.
		TT_CHECK(DibLesen(pDib, 1, 1) == RGB(0, 0, 0));
		TT_CHECK(DibLesen(pDib, 2, 1) == RGB(128, 128, 128));
		TT_CHECK(DibLesen(pDib, 3, 1) == RGB(255, 255, 255));

		delete [] pDib;
	}
	TT_EndTest();

	TT_BeginTest("E-30: OTShimDibFarbeErsetzen kann auch 32 Bit");
	{
		DWORD dwGroesse = 0;
		BYTE* pDib = DibAnlegen(4, 2, 32, dwGroesse);
		for (LONG y = 0; y < 2; ++y)
			for (LONG x = 0; x < 4; ++x)
				DibSetzen(pDib, x, y, RGB(192, 192, 192));

		long lAnzahl = OTShimDibFarbeErsetzen(pDib, dwGroesse,
											  RGB(192, 192, 192),
											  RGB(1, 2, 3));
		TT_CHECK(lAnzahl == 8);
		TT_CHECK(DibLesen(pDib, 3, 1) == RGB(1, 2, 3));

		delete [] pDib;
	}
	TT_EndTest();

	TT_BeginTest("E-30: OTShimDibFarbeErsetzen weist ab, was es nicht kann");
	{
		// Bitmap MIT Farbtabelle: die kann comctl32 selbst, hier ist
		// nichts zu tun.
		DWORD dwGroesse = 0;
		BYTE* pDib = DibAnlegen(4, 2, 24, dwGroesse);
		((BITMAPINFOHEADER*)pDib)->biBitCount = 8;
		TT_CHECK(OTShimDibFarbeErsetzen(pDib, dwGroesse,
										RGB(192,192,192), RGB(0,0,0)) == -1);

		// Gepackt.
		((BITMAPINFOHEADER*)pDib)->biBitCount    = 24;
		((BITMAPINFOHEADER*)pDib)->biCompression = BI_RLE8;
		TT_CHECK(OTShimDibFarbeErsetzen(pDib, dwGroesse,
										RGB(192,192,192), RGB(0,0,0)) == -1);
		((BITMAPINFOHEADER*)pDib)->biCompression = BI_RGB;

		// Abgeschnittener Block: die Masse im Kopf passen nicht mehr zur
		// angegebenen Groesse. Ohne die Schranke liefe die Schleife aus dem
		// Puffer heraus.
		TT_CHECK(OTShimDibFarbeErsetzen(pDib, sizeof(BITMAPINFOHEADER) + 4,
										RGB(192,192,192), RGB(0,0,0)) == -1);

		// Nullzeiger und Zwergblock.
		TT_CHECK(OTShimDibFarbeErsetzen(NULL, dwGroesse,
										RGB(192,192,192), RGB(0,0,0)) == -1);
		TT_CHECK(OTShimDibFarbeErsetzen(pDib, 4,
										RGB(192,192,192), RGB(0,0,0)) == -1);

		delete [] pDib;
	}
	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// B und C - der produktive Ladeweg
//
// SECLoadToolBarResource ist die Funktion, ueber die Eudora seine
// Werkzeugleistenbitmaps holt (QCToolBarManager.cpp:346, 354, 360).

static void TestLadeweg(void)
{
	const COLORREF crKnopf = ::GetSysColor(COLOR_BTNFACE);
	const COLORREF crAlt   = RGB(192, 192, 192);

	TT_BeginTest("E-30: 24-Bit-Leiste bekommt beim Laden die Knopffarbe");
	{
		CBitmap bmp;
		UINT*   pItems  = NULL;
		UINT    nItems  = 0;
		int     nBreite = 0;
		int     nHoehe  = 0;

		BOOL bOk = SECLoadToolBarResource(MAKEINTRESOURCE(IDR_TESTLEISTE24),
										  bmp, pItems, nItems,
										  nBreite, nHoehe);
		TT_CHECK(bOk);

		if (bOk)
		{
			TT_CHECK(nBreite == 16 && nHoehe == 16);
			TT_CHECK(nItems  == 64);

			// Die linke obere Ecke von tbar16.bmp ist Hintergrund - gemessen:
			// 192,192,192 nimmt 44,8% der Flaeche ein und ist mit Abstand die
			// haeufigste Farbe.
			COLORREF crEcke = 0;
			TT_CHECK(BitmapPunkt(bmp, 0, 0, crEcke));

			TT_Note("Ecke = %d,%d,%d   COLOR_BTNFACE = %d,%d,%d",
					GetRValue(crEcke), GetGValue(crEcke), GetBValue(crEcke),
					GetRValue(crKnopf), GetGValue(crKnopf), GetBValue(crKnopf));

			// DIE SCHRANKE: ohne die Behebung steht hier 192,192,192,
			// waehrend der Knopf in COLOR_BTNFACE gemalt wird - und genau
			// diese Abweichung macht aus dem gesperrten Knopf eine leere
			// graue Flaeche.
			TT_CHECK_MSG(crEcke == crKnopf,
						 "Hintergrund der 24-Bit-Leiste ist nicht COLOR_BTNFACE "
						 "(Befund E-30)");

			// Wenn die Systemfarbe zufaellig die alte ist, sagt der Test
			// nichts aus - dann faellt der Fehler auch in der Anwendung
			// nicht auf. Das gehoert in die Ausgabe.
			if (crKnopf == crAlt)
				TT_Note("COLOR_BTNFACE ist selbst 192,192,192 - dieser Test "
						"kann den Fehler auf diesem Rechner nicht zeigen");
		}

		delete [] pItems;
	}
	TT_EndTest();

	TT_BeginTest("E-30: 8-Bit-Leiste geht weiter ueber comctl32");
	{
		CBitmap bmp;
		UINT*   pItems  = NULL;
		UINT    nItems  = 0;
		int     nBreite = 0;
		int     nHoehe  = 0;

		BOOL bOk = SECLoadToolBarResource(MAKEINTRESOURCE(IDR_TESTLEISTE8),
										  bmp, pItems, nItems,
										  nBreite, nHoehe);
		TT_CHECK(bOk);

		if (bOk)
		{
			TT_CHECK(nBreite == 17 && nHoehe == 17);
			TT_CHECK(nItems  == 30);

			COLORREF crEcke = 0;
			TT_CHECK(BitmapPunkt(bmp, 0, 0, crEcke));
			TT_Note("Ecke = %d,%d,%d", GetRValue(crEcke), GetGValue(crEcke),
					GetBValue(crEcke));
			TT_CHECK_MSG(crEcke == crKnopf,
						 "Hintergrund der 8-Bit-Leiste ist nicht COLOR_BTNFACE");
		}

		delete [] pItems;
	}
	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// D - die Ursachenkette
//
// Dieselbe Folge aus Maske und Praegung, die SECStdBtn::CreateMask und
// SECStdBtn::DrawDisabled ausfuehren, nur ohne Fenster und ohne Knopfobjekt.
// Der Test beschreibt den Mechanismus; er ist auch vor der Behebung gruen.

#define OTSHIM_ROP_MASKED_PATTERN	0x00B8074AL

// Malt einen Knopf von 16x16 mit der Knopffarbe crFlaeche, setzt in die Mitte
// ein 8x8 grosses "Symbol" mit dem Hintergrund crBildHintergrund und einem
// schwarzen Kreuz darin, und praegt es anschliessend wie ein gesperrter
// Knopf. Liefert die Zahl der Punkte, die danach NICHT mehr die Knopffarbe
// haben.
static int PraegungZaehlen(COLORREF crFlaeche, COLORREF crBildHintergrund,
						   int& nAnders)
{
	const int nSeite = 16;
	const int nBild  = 8;
	const int nRand  = (nSeite - nBild) / 2;

	HDC hdcBild = ::GetDC(NULL);
	CDC dcMal, dcMono;
	dcMal.CreateCompatibleDC(CDC::FromHandle(hdcBild));

	CBitmap bmpMal;
	bmpMal.CreateCompatibleBitmap(CDC::FromHandle(hdcBild), nSeite, nSeite);
	CBitmap* pAltMal = dcMal.SelectObject(&bmpMal);

	dcMono.CreateCompatibleDC(NULL);
	CBitmap bmpMono;
	bmpMono.CreateBitmap(nSeite, nSeite, 1, 1, NULL);
	CBitmap* pAltMono = dcMono.SelectObject(&bmpMono);

	// 1. DrawFace: Flaeche und Bild
	dcMal.FillSolidRect(0, 0, nSeite, nSeite, crFlaeche);
	dcMal.FillSolidRect(nRand, nRand, nBild, nBild, crBildHintergrund);
	for (int i = 0; i < nBild; ++i)
	{
		dcMal.SetPixel(nRand + i, nRand + nBild/2, RGB(0, 0, 0));
		dcMal.SetPixel(nRand + nBild/2, nRand + i, RGB(0, 0, 0));
	}

	// 2. CreateMask
	COLORREF crAltBk = dcMal.SetBkColor(crFlaeche);
	dcMono.BitBlt(0, 0, nSeite, nSeite, &dcMal, 0, 0, SRCCOPY);
	dcMal.SetBkColor(crAltBk);

	// Wieviele Punkte der Maske sind 0 (= "gehoert zum Bild")?
	int nSchwarz = 0;
	for (int y = 0; y < nSeite; ++y)
		for (int x = 0; x < nSeite; ++x)
			if (dcMono.GetPixel(x, y) == RGB(0, 0, 0))
				++nSchwarz;

	// 3. DrawDisabled
	COLORREF crAltText = dcMal.SetTextColor(0x00000000L);
	crAltBk = dcMal.SetBkColor(0x00FFFFFFL);

	CBrush brHell(::GetSysColor(COLOR_3DHILIGHT));
	CBrush brDunkel(::GetSysColor(COLOR_3DSHADOW));

	CBrush* pAltPinsel = dcMal.SelectObject(&brHell);
	dcMal.BitBlt(1, 1, nSeite, nSeite, &dcMono, 0, 0,
				 OTSHIM_ROP_MASKED_PATTERN);
	dcMal.SelectObject(&brDunkel);
	dcMal.BitBlt(0, 0, nSeite, nSeite, &dcMono, 0, 0,
				 OTSHIM_ROP_MASKED_PATTERN);
	dcMal.SelectObject(pAltPinsel);

	dcMal.SetBkColor(crAltBk);
	dcMal.SetTextColor(crAltText);

	// 4. Zaehlen, wieviel vom Knopf uebermalt wurde
	nAnders = 0;
	for (int y2 = 0; y2 < nSeite; ++y2)
		for (int x2 = 0; x2 < nSeite; ++x2)
			if (dcMal.GetPixel(x2, y2) != crFlaeche)
				++nAnders;

	dcMono.SelectObject(pAltMono);
	dcMal.SelectObject(pAltMal);
	::ReleaseDC(NULL, hdcBild);

	return nSchwarz;
}

static void TestUrsachenkette(void)
{
	const COLORREF crFlaeche = ::GetSysColor(COLOR_BTNFACE);

	TT_BeginTest("E-30: passender Bildhintergrund ergibt ein gepraegtes Symbol");
	{
		int nAnders   = 0;
		int nSchwarz  = PraegungZaehlen(crFlaeche, crFlaeche, nAnders);

		TT_Note("Maskenpunkte 0: %d von 256, uebermalt: %d", nSchwarz, nAnders);

		// Nur das Kreuz gehoert zum Bild: 8 + 8 - 1 = 15 Punkte.
		TT_CHECK_MSG(nSchwarz == 15,
					 "Maske traf nicht genau das Symbol");
		// Gepraegt wird das Kreuz zweimal, versetzt - deutlich weniger als
		// die halbe Knopfflaeche.
		TT_CHECK_MSG(nAnders > 0 && nAnders < 64,
					 "Praegung deckt nicht das Symbol, sondern eine Flaeche");
	}
	TT_EndTest();

	TT_BeginTest("E-30: unpassender Bildhintergrund ergibt eine leere Flaeche");
	{
		// Genau der Fall aus der Anwendung: das Bild bringt 192,192,192 mit,
		// der Knopf ist in COLOR_BTNFACE gemalt.
		const COLORREF crAlt = RGB(192, 192, 192);

		if (crFlaeche == crAlt)
		{
			TT_Note("COLOR_BTNFACE ist selbst 192,192,192 - dieser Rechner "
					"kann den Fehler nicht zeigen");
		}
		else
		{
			int nAnders  = 0;
			int nSchwarz = PraegungZaehlen(crFlaeche, crAlt, nAnders);

			TT_Note("Maskenpunkte 0: %d von 256, uebermalt: %d",
					nSchwarz, nAnders);

			// Das GANZE Bildrechteck (8x8 = 64) faellt in die Maske, nicht
			// nur das Kreuz. Das ist die leere graue Flaeche.
			TT_CHECK_MSG(nSchwarz == 64,
						 "erwartet war das ganze Bildrechteck in der Maske");
			TT_CHECK_MSG(nAnders >= 64,
						 "erwartet war eine uebermalte Flaeche, kein Symbol");
		}
	}
	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////

void RunSymboleTests(void)
{
	TT_Suite("Befund E-30 - Werkzeugleistensymbole und gesperrte Knoepfe");

	TestFarbeErsetzen();
	TestLadeweg();
	TestUrsachenkette();
}

//
// WAS HIER NICHT GEPRUEFT WIRD
//
//   Das tatsaechliche Aussehen auf dem Bildschirm. Ein Testlauf darf kein
//   Fenster oeffnen; geprueft wird deshalb der Farbwert der geladenen
//   Bitmap und die Maskenbildung, nicht das Bild im Fenster.
//
//   Die Symbole, die die Erweiterungen (Plugins) ueber
//   QCToolBarManager::CopyButtonImage in die Leiste kopieren. Sie kommen aus
//   einer CImageList und nicht aus einer Bitmapressource; ob ihr Hintergrund
//   passt, ist eine eigene Frage.
//
//   Die statische Pruefung der Ressourcen selbst - jeder Knopf ein Bild,
//   jede Bilddatei vorhanden, Breite durch Bildbreite teilbar - leistet
//   tools/pruefe-symbole.pl ohne Uebersetzer.
//
