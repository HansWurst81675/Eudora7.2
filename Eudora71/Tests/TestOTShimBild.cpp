//
// TestOTShimBild.cpp - prueft die Rechen- und Speicherwege von OTShim_Bild
//
// Die Ersatzschicht ist rund 18000 Zeilen gross und war zum Zeitpunkt dieser
// Tests nie ausgefuehrt worden - sie uebersetzte und band, mehr nicht. Dieser
// Abschnitt bringt den Teil zum Laufen, der ohne Fenster und ohne
// Nachrichtenschleife auskommt:
//
//   - die drei Rechenmethoden CalcBytesPerLine, CalcPadding, LastByte
//   - das Makro PADWIDTH, gegen das QCPng::LoadImage rechnet
//   - NumBytes, NumColors
//   - den DIB-Aufbau in OTShimDibAnlegen (Feldsatz und BITMAPINFOHEADER)
//   - CopyImage/ConvertImage
//   - den vollstaendigen Rundlauf SaveImage -> LoadImage ueber CMemFile,
//     also den von Hand geschriebenen BMP-Ausgang gegen den GDI+-Eingang
//   - dass die als Rumpf gekennzeichneten Methoden sich auch melden
//
// WAS HIER NICHT GEPRUEFT WIRD und warum, steht am Ende der Datei.
//
// Die Erwartungswerte sind gemessen, nicht geraten: die Tabellen enthalten
// von Hand nachgerechnete Werte, und die Sweeps daneben pruefen die
// Zusicherungen, die aus dem DIB-Format folgen (Zeilenlaenge ist ein
// Vielfaches von 4, sie ist nie kuerzer als die Nutzdaten, und sie ist die
// kleinste solche Laenge).
//
#include <afxwin.h>
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "OTShimProbe.h"
#include "OTShim_Bild.h"


/////////////////////////////////////////////////////////////////////////////
// Zugang zu den geschuetzten Bausteinen
//
// OTShimDibAnlegen und OTShimDibFreigeben sind geschuetzt (OTShim_Bild.h,
// Abschnitt "Zugaben dieser Schicht"). Genau so greift auch Eudora darauf zu
// - QCPng und QCImage sind abgeleitete Klassen. Diese Ableitung tut nichts
// weiter, als die beiden Methoden erreichbar zu machen; sie aendert kein
// Verhalten.

class ProbeDib : public SECDib
{
public:
	BOOL Anlegen(DWORD dwBreite, DWORD dwHoehe) { return OTShimDibAnlegen(dwBreite, dwHoehe); }
	void Freigeben()                            { OTShimDibFreigeben(); }
};


// Setzt einen Bildpunkt im DIB. Der DIB liegt von unten nach oben, y wird
// hier von OBEN gezaehlt - so, wie die Rauchprobe des Schichtautors es tat.
static void PunktSetzen(SECImage& bild, DWORD x, DWORD y, BYTE r, BYTE g, BYTE b)
{
	BYTE* p = bild.m_lpSrcBits + (bild.m_dwHeight - 1 - y) * bild.m_dwPadWidth + x * 3;
	p[0] = b;	// im DIB steht Blau zuerst
	p[1] = g;
	p[2] = r;
}

static COLORREF PunktLesen(SECImage& bild, DWORD x, DWORD y)
{
	const BYTE* p = bild.m_lpSrcBits + (bild.m_dwHeight - 1 - y) * bild.m_dwPadWidth + x * 3;
	return RGB(p[2], p[1], p[0]);
}

// Fuellt das Bild mit einem Muster, das jeden Punkt eindeutig kennzeichnet.
static void MusterFuellen(SECImage& bild)
{
	for (DWORD y = 0; y < bild.m_dwHeight; ++y)
	{
		for (DWORD x = 0; x < bild.m_dwWidth; ++x)
		{
			PunktSetzen(bild, x, y,
						(BYTE)(x * 17 + 3),
						(BYTE)(y * 29 + 7),
						(BYTE)((x + y) * 5 + 11));
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
// 1. CalcBytesPerLine

static void Test_CalcBytesPerLine_Tabelle(void)
{
	// Von Hand nachgerechnet aus ((Breite * Bit + 31) & ~31) / 8.
	// Jede Zeile: Bit je Punkt, Breite, erwartete Zeilenlaenge in Byte.
	static const DWORD adwFaelle[][3] =
	{
		{  1,   1,   4 },	// ein Bit  -> auf 32 Bit aufgefuellt
		{  1,  32,   4 },	// genau eine Vierergruppe voll
		{  1,  33,   8 },	// ein Bit darueber -> naechste Gruppe
		{  4,   3,   4 },
		{  4,   8,   4 },	// 32 Bit
		{  4,   9,   8 },
		{  8,   1,   4 },
		{  8,   4,   4 },
		{  8,   5,   8 },
		{ 16,   2,   4 },
		{ 16,   3,   8 },
		{ 24,   1,   4 },	// 3 Byte -> 4
		{ 24,   2,   8 },	// 6 Byte -> 8
		{ 24,   4,  12 },	// 12 Byte, schon passend
		{ 24,   7,  24 },	// 21 Byte -> 24
		{ 24, 100, 300 },
		{ 32,   1,   4 },
		{ 32,  10,  40 }
	};

	ProbeDib dib;
	int i;

	TT_BeginTest("SECImage::CalcBytesPerLine: nachgerechnete Werte");

	for (i = 0; i < (int)(sizeof(adwFaelle) / sizeof(adwFaelle[0])); ++i)
	{
		DWORD dwIst = dib.CalcBytesPerLine(adwFaelle[i][0], adwFaelle[i][1]);
		if (dwIst != adwFaelle[i][2])
			TT_Fail("CalcBytesPerLine(%lu, %lu) = %lu, erwartet %lu",
					adwFaelle[i][0], adwFaelle[i][1], dwIst, adwFaelle[i][2]);
	}

	TT_EndTest();
}

static void Test_CalcBytesPerLine_Zusicherungen(void)
{
	// Was aus dem DIB-Format folgt und fuer JEDE Breite gelten muss:
	//   (a) die Zeilenlaenge ist ein Vielfaches von 4 Byte
	//   (b) sie ist nie kuerzer als die reinen Nutzdaten
	//   (c) sie ist die KLEINSTE solche Laenge (weniger als 4 Byte Fuellung)
	static const DWORD adwBits[] = { 1, 2, 4, 8, 16, 24, 32 };
	ProbeDib dib;
	int i;
	DWORD dwBreite;

	TT_BeginTest("SECImage::CalcBytesPerLine: Vielfaches von 4, kleinste passende Laenge");

	for (i = 0; i < (int)(sizeof(adwBits) / sizeof(adwBits[0])); ++i)
	{
		for (dwBreite = 1; dwBreite <= 300; ++dwBreite)
		{
			DWORD dwBits  = adwBits[i];
			DWORD dwZeile = dib.CalcBytesPerLine(dwBits, dwBreite);
			DWORD dwNutz  = (dwBreite * dwBits + 7) / 8;

			if ((dwZeile % 4) != 0)
				TT_Fail("CalcBytesPerLine(%lu, %lu) = %lu ist kein Vielfaches von 4",
						dwBits, dwBreite, dwZeile);
			if (dwZeile < dwNutz)
				TT_Fail("CalcBytesPerLine(%lu, %lu) = %lu < Nutzdaten %lu",
						dwBits, dwBreite, dwZeile, dwNutz);
			if (dwZeile >= dwNutz && dwZeile - dwNutz >= 4)
				TT_Fail("CalcBytesPerLine(%lu, %lu) = %lu fuellt %lu Byte auf (hoechstens 3 erlaubt)",
						dwBits, dwBreite, dwZeile, dwZeile - dwNutz);
		}
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 2. CalcPadding
//
// OTShim_Bild.cpp begruendet ausfuehrlich, dass CalcPadding die AUFGEFUELLTE
// Zeilenlaenge liefert und nicht die Zahl der Fuellbytes - belegt ueber
// QCGraphics.cpp:482, wo m_dwPadWidth genau so belegt wird. Diese Zusicherung
// wird hier festgeschrieben: aendert jemand die eine Methode, faellt der Test.

static void Test_CalcPadding(void)
{
	static const DWORD adwBits[] = { 1, 4, 8, 16, 24, 32 };
	ProbeDib dib;
	int i;
	DWORD dwBreite;

	TT_BeginTest("SECImage::CalcPadding liefert dasselbe wie CalcBytesPerLine");

	for (i = 0; i < (int)(sizeof(adwBits) / sizeof(adwBits[0])); ++i)
	{
		for (dwBreite = 1; dwBreite <= 200; ++dwBreite)
		{
			DWORD dwA = dib.CalcPadding(adwBits[i], dwBreite);
			DWORD dwB = dib.CalcBytesPerLine(adwBits[i], dwBreite);
			if (dwA != dwB)
				TT_Fail("CalcPadding(%lu, %lu) = %lu, CalcBytesPerLine = %lu",
						adwBits[i], dwBreite, dwA, dwB);
		}
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 3. LastByte
//
// Die Umsetzung kennzeichnet die Bedeutung ausdruecklich als UNGEPRUEFT
// ("aus dem Namen erschlossen"). Der Test schreibt deshalb fest, was der Code
// TUT, nicht was das Original getan haben mag - damit ein spaeterer Beleg als
// Aenderung sichtbar wird und nicht stillschweigend einsickert.

static void Test_LastByte(void)
{
	static const DWORD adwFaelle[][3] =
	{
		{  1,   1,   1 },	// ein Punkt, ein angefangenes Byte
		{  1,   8,   1 },	// acht Punkte fuellen genau ein Byte
		{  1,   9,   2 },
		{  4,   2,   1 },
		{  4,   3,   2 },
		{  8,   5,   5 },
		{ 24,   1,   3 },
		{ 24,   7,  21 },	// 7 mal 3 Byte, ohne Auffuellung
		{ 24, 100, 300 },
		{ 32,  10,  40 }
	};

	ProbeDib dib;
	int i;
	DWORD dwBreite;

	TT_BeginTest("SECImage::LastByte: Zeilenlaenge OHNE Auffuellung");

	for (i = 0; i < (int)(sizeof(adwFaelle) / sizeof(adwFaelle[0])); ++i)
	{
		DWORD dwIst = dib.LastByte(adwFaelle[i][0], adwFaelle[i][1]);
		if (dwIst != adwFaelle[i][2])
			TT_Fail("LastByte(%lu, %lu) = %lu, erwartet %lu",
					adwFaelle[i][0], adwFaelle[i][1], dwIst, adwFaelle[i][2]);
	}

	// LastByte darf nie ueber die aufgefuellte Zeile hinausreichen.
	for (dwBreite = 1; dwBreite <= 300; ++dwBreite)
	{
		if (dib.LastByte(24, dwBreite) > dib.CalcBytesPerLine(24, dwBreite))
			TT_Fail("LastByte(24, %lu) = %lu > CalcBytesPerLine = %lu",
					dwBreite, dib.LastByte(24, dwBreite), dib.CalcBytesPerLine(24, dwBreite));
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 4. Das Makro PADWIDTH
//
// PADWIDTH nimmt eine BYTEZAHL entgegen, CalcBytesPerLine eine Punktzahl.
// QCGraphics.cpp:482 rechnet
//     m_dwPadWidth = PADWIDTH((m_dwWidth * m_nSrcBitsPerPixel) / 8);
// Beide Wege muessen bei durch 8 teilbarer Farbtiefe dasselbe ergeben, sonst
// bekaeme QCPng eine andere Zeilenlaenge als der Rest dieser Schicht.

static void Test_PadWidthMakro(void)
{
	static const DWORD adwBits[] = { 8, 16, 24, 32 };
	ProbeDib dib;
	int i;
	DWORD dwBreite;

	TT_BeginTest("PADWIDTH stimmt mit CalcBytesPerLine ueberein (der QCPng-Weg)");

	for (i = 0; i < (int)(sizeof(adwBits) / sizeof(adwBits[0])); ++i)
	{
		for (dwBreite = 1; dwBreite <= 200; ++dwBreite)
		{
			DWORD dwBytes = (dwBreite * adwBits[i]) / 8;
			DWORD dwMakro = PADWIDTH(dwBytes);
			DWORD dwFunk  = dib.CalcBytesPerLine(adwBits[i], dwBreite);
			if (dwMakro != dwFunk)
				TT_Fail("PADWIDTH(%lu) = %lu, CalcBytesPerLine(%lu, %lu) = %lu",
						dwBytes, dwMakro, adwBits[i], dwBreite, dwFunk);
		}
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 5. NumBytes und NumColors

static void Test_NumBytesNumColors(void)
{
	ProbeDib dib;

	TT_BeginTest("SECImage::NumBytes/NumColors: leeres Bild und angelegter DIB");

	// Frisch angelegtes Objekt: kein BITMAPINFO, also 0 Byte, 0 Farben.
	if (dib.NumBytes() != 0)
		TT_Fail("NumBytes() eines leeren Bildes = %lu, erwartet 0", dib.NumBytes());
	if (dib.NumColors() != 0)
		TT_Fail("NumColors() eines leeren Bildes = %u, erwartet 0", dib.NumColors());

	if (!dib.Anlegen(7, 5))
	{
		TT_Fail("OTShimDibAnlegen(7, 5) fehlgeschlagen, Fehler %lu", dib.m_dwError);
		TT_EndTest();
		return;
	}

	// 7 Punkte mal 3 Byte = 21, aufgefuellt 24; mal 5 Zeilen = 120 Byte.
	if (dib.NumBytes() != 120)
		TT_Fail("NumBytes() nach Anlegen(7, 5) = %lu, erwartet 120", dib.NumBytes());
	if (dib.NumBytes() != dib.m_dwPadWidth * dib.m_dwHeight)
		TT_Fail("NumBytes() = %lu passt nicht zu m_dwPadWidth * m_dwHeight = %lu",
				dib.NumBytes(), dib.m_dwPadWidth * dib.m_dwHeight);

	// Diese Schicht legt ausschliesslich 24-Bit-DIBs ohne Farbtabelle an.
	if (dib.NumColors() != 0)
		TT_Fail("NumColors() nach Anlegen = %u, erwartet 0", dib.NumColors());

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 6. Der Feldsatz nach OTShimDibAnlegen
//
// OTShim_Bild.h nennt die Form verbindlich: 24 Bit, BI_RGB, biHeight > 0,
// keine Farbtabelle. Fuenf Stellen in Eudora reichen m_lpBMI/m_lpSrcBits
// unmittelbar an ::StretchDIBits weiter - stimmt der Kopf nicht, zeichnet
// Eudora Muell.

static void Test_DibAnlegen(void)
{
	ProbeDib dib;

	TT_BeginTest("OTShimDibAnlegen: Feldsatz und BITMAPINFOHEADER");

	if (!dib.Anlegen(7, 5))
	{
		TT_Fail("OTShimDibAnlegen(7, 5) fehlgeschlagen, Fehler %lu", dib.m_dwError);
		TT_EndTest();
		return;
	}

	if (dib.dwGetWidth() != 7)			TT_Fail("dwGetWidth = %lu, erwartet 7", dib.dwGetWidth());
	if (dib.dwGetHeight() != 5)			TT_Fail("dwGetHeight = %lu, erwartet 5", dib.dwGetHeight());
	if (dib.m_nSrcBitsPerPixel != 24)	TT_Fail("m_nSrcBitsPerPixel = %d, erwartet 24", dib.m_nSrcBitsPerPixel);
	if (dib.m_nBitPlanes != 1)			TT_Fail("m_nBitPlanes = %d, erwartet 1", dib.m_nBitPlanes);
	if (!dib.m_bIsPadded)				TT_Fail("m_bIsPadded ist FALSE, erwartet TRUE");
	if (dib.m_dwPadWidth != 24)			TT_Fail("m_dwPadWidth = %lu, erwartet 24", dib.m_dwPadWidth);
	if (dib.m_wColors != 0)				TT_Fail("m_wColors = %u, erwartet 0", dib.m_wColors);
	if (dib.m_lpRGB != NULL)			TT_Fail("m_lpRGB ist belegt, erwartet NULL (keine Farbtabelle)");
	if (dib.m_dwError != 0)				TT_Fail("m_dwError = %lu, erwartet 0", dib.m_dwError);

	if (dib.m_lpBMI == NULL || dib.m_lpSrcBits == NULL)
	{
		TT_Fail("m_lpBMI oder m_lpSrcBits ist NULL");
		TT_EndTest();
		return;
	}

	{
		const BITMAPINFOHEADER& kopf = dib.m_lpBMI->bmiHeader;
		if (kopf.biSize != sizeof(BITMAPINFOHEADER))
			TT_Fail("biSize = %lu, erwartet %lu", kopf.biSize, (DWORD)sizeof(BITMAPINFOHEADER));
		if (kopf.biWidth != 7)				TT_Fail("biWidth = %ld, erwartet 7", kopf.biWidth);
		if (kopf.biHeight != 5)				TT_Fail("biHeight = %ld, erwartet 5 (positiv = von unten nach oben)", kopf.biHeight);
		if (kopf.biPlanes != 1)				TT_Fail("biPlanes = %u, erwartet 1", kopf.biPlanes);
		if (kopf.biBitCount != 24)			TT_Fail("biBitCount = %u, erwartet 24", kopf.biBitCount);
		if (kopf.biCompression != BI_RGB)	TT_Fail("biCompression = %lu, erwartet BI_RGB (%d)", kopf.biCompression, BI_RGB);
		if (kopf.biSizeImage != 120)		TT_Fail("biSizeImage = %lu, erwartet 120", kopf.biSizeImage);
		if (kopf.biClrUsed != 0)			TT_Fail("biClrUsed = %lu, erwartet 0", kopf.biClrUsed);
	}

	// GHND heisst mit Nullen vorbelegt - die Daten muessen leer beginnen.
	{
		DWORD i;
		DWORD dwNichtNull = 0;
		for (i = 0; i < 120; ++i)
			if (dib.m_lpSrcBits[i] != 0)
				++dwNichtNull;
		if (dwNichtNull != 0)
			TT_Fail("%lu von 120 Datenbytes sind nicht 0 (GlobalAllocPtr mit GHND verlangt Nullen)",
					dwNichtNull);
	}

	TT_EndTest();
}

static void Test_DibAnlegen_Randfaelle(void)
{
	ProbeDib dib;

	TT_BeginTest("OTShimDibAnlegen: Breite/Hoehe 0 und Ueberlaufschutz");

	if (dib.Anlegen(0, 5))
		TT_Fail("Anlegen(0, 5) liefert TRUE, erwartet FALSE");
	else if (dib.m_dwError != ERROR_INVALID_PARAMETER)
		TT_Fail("Anlegen(0, 5): m_dwError = %lu, erwartet ERROR_INVALID_PARAMETER (%d)",
				dib.m_dwError, ERROR_INVALID_PARAMETER);

	if (dib.Anlegen(5, 0))
		TT_Fail("Anlegen(5, 0) liefert TRUE, erwartet FALSE");

	// Die Grenze liegt laut Umsetzung bei 0xFFFF je Richtung.
	if (dib.Anlegen(0x10000, 1))
		TT_Fail("Anlegen(0x10000, 1) liefert TRUE, erwartet FALSE (Ueberlaufschutz)");
	else if (dib.m_dwError != ERROR_ARITHMETIC_OVERFLOW)
		TT_Fail("Anlegen(0x10000, 1): m_dwError = %lu, erwartet ERROR_ARITHMETIC_OVERFLOW (%d)",
				dib.m_dwError, ERROR_ARITHMETIC_OVERFLOW);

	// Ein fehlgeschlagenes Anlegen muss ein leeres Bild hinterlassen, nicht
	// ein halb belegtes.
	if (dib.m_lpBMI != NULL || dib.m_lpSrcBits != NULL)
		TT_Fail("nach fehlgeschlagenem Anlegen sind Puffer belegt");
	if (dib.dwGetWidth() != 0 || dib.dwGetHeight() != 0)
		TT_Fail("nach fehlgeschlagenem Anlegen: Masse %lux%lu, erwartet 0x0",
				dib.dwGetWidth(), dib.dwGetHeight());

	TT_EndTest();
}

static void Test_DibMehrfachAnlegen(void)
{
	ProbeDib dib;

	// QCToolBarManager.cpp ruft CreateFromBitmap dreimal auf demselben Objekt
	// auf. Der Weg darunter ist OTShimDibAnlegen, das vorher freigeben muss.
	TT_BeginTest("OTShimDibAnlegen mehrfach auf demselben Objekt");

	if (!dib.Anlegen(7, 5))		TT_Fail("erstes Anlegen(7, 5) fehlgeschlagen");
	if (!dib.Anlegen(3, 9))		TT_Fail("zweites Anlegen(3, 9) fehlgeschlagen");

	if (dib.dwGetWidth() != 3 || dib.dwGetHeight() != 9)
		TT_Fail("nach dem zweiten Anlegen: %lux%lu, erwartet 3x9",
				dib.dwGetWidth(), dib.dwGetHeight());
	// 3 mal 3 = 9 Byte, aufgefuellt auf 12.
	if (dib.m_dwPadWidth != 12)
		TT_Fail("m_dwPadWidth = %lu, erwartet 12", dib.m_dwPadWidth);
	if (dib.NumBytes() != 12 * 9)
		TT_Fail("NumBytes = %lu, erwartet %d", dib.NumBytes(), 12 * 9);

	dib.Freigeben();
	if (dib.m_lpBMI != NULL || dib.m_lpSrcBits != NULL)
		TT_Fail("OTShimDibFreigeben laesst Puffer stehen");
	if (dib.NumBytes() != 0)
		TT_Fail("NumBytes nach Freigeben = %lu, erwartet 0", dib.NumBytes());

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 7. CopyImage und ConvertImage
//
// QCGraphics.cpp:233 ruft Jpeg.ConvertImage(&Dib). ConvertImage ist in dieser
// Schicht dasselbe wie CopyImage, weil jedes Bild schon 24 Bit BI_RGB ist.

static void Test_CopyImage(void)
{
	ProbeDib quelle;
	ProbeDib ziel;

	TT_BeginTest("SECImage::CopyImage: Masse, Daten und Randfaelle");

	if (!quelle.Anlegen(7, 5))
	{
		TT_Fail("Anlegen der Quelle fehlgeschlagen");
		TT_EndTest();
		return;
	}
	MusterFuellen(quelle);
	quelle.SetTransparentColor(RGB(1, 2, 3));

	if (!ziel.CopyImage(&quelle))
	{
		TT_Fail("CopyImage liefert FALSE, Fehler %lu", ziel.m_dwError);
		TT_EndTest();
		return;
	}

	if (ziel.dwGetWidth() != 7 || ziel.dwGetHeight() != 5)
		TT_Fail("Masse nach CopyImage: %lux%lu, erwartet 7x5", ziel.dwGetWidth(), ziel.dwGetHeight());
	if (ziel.m_dwPadWidth != quelle.m_dwPadWidth)
		TT_Fail("m_dwPadWidth %lu statt %lu", ziel.m_dwPadWidth, quelle.m_dwPadWidth);
	if (ziel.m_lpSrcBits == quelle.m_lpSrcBits)
		TT_Fail("CopyImage teilt sich den Puffer mit der Quelle statt zu kopieren");
	if (ziel.m_lpSrcBits == NULL ||
		memcmp(ziel.m_lpSrcBits, quelle.m_lpSrcBits, quelle.m_dwPadWidth * quelle.m_dwHeight) != 0)
		TT_Fail("Bilddaten nach CopyImage nicht byte-gleich");
	if (ziel.GetTransparentColor() != RGB(1, 2, 3))
		TT_Fail("m_crTransparent wurde nicht mitkopiert");

	// Auf sich selbst kopieren muss stillschweigend gutgehen und darf die
	// Daten nicht wegwerfen.
	if (!quelle.CopyImage(&quelle))
		TT_Fail("CopyImage auf sich selbst liefert FALSE");
	if (quelle.m_lpSrcBits == NULL || quelle.dwGetWidth() != 7)
		TT_Fail("CopyImage auf sich selbst hat das Bild zerstoert");

	// Leere Quelle: kein Fehler, aber das Ziel ist danach leer.
	{
		ProbeDib leer;
		if (!ziel.CopyImage(&leer))
			TT_Fail("CopyImage von einer leeren Quelle liefert FALSE, erwartet TRUE");
		if (ziel.m_lpBMI != NULL || ziel.m_lpSrcBits != NULL)
			TT_Fail("nach CopyImage von einer leeren Quelle ist das Ziel nicht leer");
	}

	// ConvertImage ist laut Umsetzung dasselbe wie CopyImage.
	{
		ProbeDib gewandelt;
		if (!gewandelt.ConvertImage(&quelle))
			TT_Fail("ConvertImage liefert FALSE");
		else if (gewandelt.m_lpSrcBits == NULL ||
				 memcmp(gewandelt.m_lpSrcBits, quelle.m_lpSrcBits,
						quelle.m_dwPadWidth * quelle.m_dwHeight) != 0)
			TT_Fail("ConvertImage liefert andere Daten als CopyImage");
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 8. Rundlauf SaveImage -> LoadImage
//
// Das ist der einzige Test hier, der zwei verschiedene Wege gegeneinander
// stellt: SECDib::DoSaveImage schreibt den BMP von Hand (drei
// Schreibvorgaenge), SECDib::DoLoadImage liest ihn ueber GDI+ wieder ein.
// Stimmen die beiden nicht ueberein, faellt es hier auf und nicht erst,
// wenn LinkHistoryManager.cpp:1250 ein Vorschaubild ablegt.
//
// Gearbeitet wird ueber CMemFile - kein Zugriff auf die Platte, keine
// aufzuraeumenden Dateien.

static void Test_Rundlauf(DWORD dwBreite, DWORD dwHoehe)
{
	char szName[140];
	ProbeDib quelle;
	SECDib   zurueck;
	CMemFile datei;

	_snprintf(szName, sizeof(szName) - 1,
			  "SECDib %lux%lu: von Hand geschrieben, ueber GDI+ gelesen, byte-gleich",
			  dwBreite, dwHoehe);
	szName[sizeof(szName) - 1] = 0;
	TT_BeginTest(szName);

	if (!quelle.Anlegen(dwBreite, dwHoehe))
	{
		TT_Fail("Anlegen(%lu, %lu) fehlgeschlagen", dwBreite, dwHoehe);
		TT_EndTest();
		return;
	}
	MusterFuellen(quelle);

	if (!quelle.SaveImage(&datei))
	{
		TT_Fail("SaveImage liefert FALSE, Fehler %lu", quelle.m_dwError);
		TT_EndTest();
		return;
	}

	// Der Dateikopf muss stimmen, sonst nimmt kein Anzeigeprogramm die Datei an.
	{
		DWORD dwErwartet = (DWORD)(sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER))
						 + quelle.m_dwPadWidth * quelle.m_dwHeight;
		if ((DWORD)datei.GetLength() != dwErwartet)
			TT_Fail("Dateilaenge %lu, erwartet %lu", (DWORD)datei.GetLength(), dwErwartet);
	}

	datei.SeekToBegin();
	{
		BITMAPFILEHEADER kopf;
		datei.Read(&kopf, sizeof(kopf));
		if (kopf.bfType != DIB_HEADER_MARKER)
			TT_Fail("bfType = 0x%04X, erwartet die Marke BM (0x%04X)",
					kopf.bfType, DIB_HEADER_MARKER);
		if (kopf.bfOffBits != sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER))
			TT_Fail("bfOffBits = %lu, erwartet %lu (kein Farbtabellenplatz)",
					kopf.bfOffBits,
					(DWORD)(sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER)));
		if (kopf.bfSize != (DWORD)datei.GetLength())
			TT_Fail("bfSize = %lu, Dateilaenge = %lu", kopf.bfSize, (DWORD)datei.GetLength());
	}

	datei.SeekToBegin();
	if (!zurueck.LoadImage(&datei))
	{
		TT_Fail("LoadImage liefert FALSE, Fehler %lu", zurueck.m_dwError);
		TT_EndTest();
		return;
	}

	if (zurueck.dwGetWidth() != dwBreite || zurueck.dwGetHeight() != dwHoehe)
		TT_Fail("Masse nach dem Laden: %lux%lu, erwartet %lux%lu",
				zurueck.dwGetWidth(), zurueck.dwGetHeight(), dwBreite, dwHoehe);
	if (zurueck.m_nSrcBitsPerPixel != 24)
		TT_Fail("m_nSrcBitsPerPixel nach dem Laden = %d, erwartet 24", zurueck.m_nSrcBitsPerPixel);
	if (zurueck.m_dwPadWidth != quelle.m_dwPadWidth)
		TT_Fail("m_dwPadWidth nach dem Laden = %lu, erwartet %lu",
				zurueck.m_dwPadWidth, quelle.m_dwPadWidth);
	else if (zurueck.m_lpSrcBits == NULL ||
			 memcmp(zurueck.m_lpSrcBits, quelle.m_lpSrcBits,
					quelle.m_dwPadWidth * quelle.m_dwHeight) != 0)
		TT_Fail("Bilddaten nach dem Rundlauf nicht byte-gleich");

	// Stichprobe auf die Farbkanaele: waeren Rot und Blau auf beiden Seiten
	// gleich vertauscht, faellt das beim Byte-Vergleich oben nicht auf.
	if (zurueck.m_lpSrcBits != NULL && zurueck.dwGetHeight() == dwHoehe)
	{
		COLORREF crSoll = PunktLesen(quelle, 0, 0);
		COLORREF crIst  = PunktLesen(zurueck, 0, 0);
		if (crSoll != crIst)
			TT_Fail("Punkt (0,0): R=%d G=%d B=%d gelesen, gesetzt war R=%d G=%d B=%d",
					GetRValue(crIst), GetGValue(crIst), GetBValue(crIst),
					GetRValue(crSoll), GetGValue(crSoll), GetBValue(crSoll));
	}

	TT_EndTest();
}

static void Test_LeeresBildSpeichern(void)
{
	SECDib   leer;
	CMemFile datei;

	TT_BeginTest("SECImage::SaveImage auf einem leeren Bild liefert FALSE");

	// PreSaveImage verlangt m_lpBMI und m_lpSrcBits; ohne Bild darf nichts
	// geschrieben werden.
	if (leer.SaveImage(&datei))
		TT_Fail("SaveImage auf einem leeren Bild liefert TRUE");
	if (datei.GetLength() != 0)
		TT_Fail("es wurden %lu Byte geschrieben, erwartet 0", (DWORD)datei.GetLength());

	// NULL statt einer Datei ist ein Fehler, kein Absturz.
	if (leer.SaveImage((CFile*)NULL))
		TT_Fail("SaveImage(NULL) liefert TRUE");
	if (leer.LoadImage((CFile*)NULL))
		TT_Fail("LoadImage(NULL) liefert TRUE");

	TT_EndTest();
}

static void Test_UnsinnLaden(void)
{
	SECDib   dib;
	CMemFile datei;
	static const char szMuell[] = "Das ist kein Bild, sondern Text.";

	TT_BeginTest("SECDib::LoadImage auf Nichtbild-Daten liefert FALSE");

	datei.Write(szMuell, sizeof(szMuell) - 1);
	datei.SeekToBegin();

	if (dib.LoadImage(&datei))
		TT_Fail("LoadImage auf Textdaten liefert TRUE");
	if (dib.m_lpSrcBits != NULL)
		TT_Fail("nach dem fehlgeschlagenen Laden sind Bilddaten belegt");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 9. Die Ruempfe melden sich
//
// Projektregel "Dummy statt Weglassen": nicht umgesetzte Methoden haben einen
// Rumpf, der sich einmal je Sitzung meldet. Geprueft wird, dass die Meldung
// wirklich kommt und dass sie sich - wie im Original - nicht wiederholt.

static void Test_RuempfeMelden(void)
{
	SECDib dib;

	TT_BeginTest("SECImage: FlipHorz/FlipVert/Rotate90/Crop/UnPadBits melden sich");

	OTShimProbeZuruecksetzen();

	if (dib.FlipHorz())		TT_Fail("FlipHorz liefert TRUE, erwartet FALSE");
	if (OTShimProbeMeldungen() != 1)
		TT_Fail("FlipHorz hat %d Meldungen abgesetzt, erwartet 1", OTShimProbeMeldungen());

	// Zweiter Aufruf: das statische Merkzeichen der Fundstelle verhindert
	// eine zweite Meldung. Der Rueckgabewert bleibt FALSE.
	if (dib.FlipHorz())		TT_Fail("zweiter FlipHorz liefert TRUE");
	if (OTShimProbeMeldungen() != 1)
		TT_Fail("nach dem zweiten FlipHorz %d Meldungen, erwartet weiterhin 1",
				OTShimProbeMeldungen());

	if (dib.FlipVert())			TT_Fail("FlipVert liefert TRUE, erwartet FALSE");
	if (dib.Rotate90())			TT_Fail("Rotate90 liefert TRUE, erwartet FALSE");
	if (dib.Crop(0, 0, 1, 1))	TT_Fail("Crop liefert TRUE, erwartet FALSE");
	if (dib.UnPadBits())		TT_Fail("UnPadBits liefert TRUE, erwartet FALSE");

	// Jede Fundstelle bringt ihr eigenes Merkzeichen mit: fuenf verschiedene
	// Ruempfe, fuenf Meldungen.
	if (OTShimProbeMeldungen() != 5)
		TT_Fail("insgesamt %d Meldungen, erwartet 5 (je Fundstelle eine)",
				OTShimProbeMeldungen());

	// PadBits ist KEIN Rumpf - die Daten liegen hier immer aufgefuellt vor.
	if (!dib.PadBits())
		TT_Fail("PadBits liefert FALSE, erwartet TRUE");

	OTShimProbeZuruecksetzen();
	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////

void RunOTShimBildTests(void)
{
	TT_Suite("OTShim_Bild - Rechenmethoden von SECImage");
	Test_CalcBytesPerLine_Tabelle();
	Test_CalcBytesPerLine_Zusicherungen();
	Test_CalcPadding();
	Test_LastByte();
	Test_PadWidthMakro();
	Test_NumBytesNumColors();

	TT_Suite("OTShim_Bild - DIB anlegen, kopieren, speichern, laden");
	Test_DibAnlegen();
	Test_DibAnlegen_Randfaelle();
	Test_DibMehrfachAnlegen();
	Test_CopyImage();
	Test_Rundlauf(7, 5);		// Zeile muss aufgefuellt werden (21 -> 24)
	Test_Rundlauf(4, 3);		// Zeile passt genau (12 Byte)
	Test_Rundlauf(1, 1);		// kleinstes moegliches Bild
	Test_LeeresBildSpeichern();
	Test_UnsinnLaden();
	Test_RuempfeMelden();
}

//
// UNGEPRUEFT GEBLIEBEN - und warum
//
//   SECImage::CreateFromBitmap, MakeBitmap, StretchDIBits, CreatePalette
//       brauchen einen Geraetekontext und eine echte GDI-Bitmap. Der
//       Schichtautor hat sie mit einer Rauchprobe im Kritzelverzeichnis
//       geprueft (Bildschirm-DC, CreateCompatibleBitmap); hier bleiben sie
//       draussen, weil ein Testlauf ohne Sitzung sonst falschen Alarm gibt.
//       Der schwierige Teil von CreateFromBitmap - die Quellbitmap ist im
//       uebergebenen DC ausgewaehlt, ::GetDIBits darf das nicht - ist damit
//       weiterhin nur durch jene Rauchprobe belegt.
//
//   SECJpeg::DoSaveImage mit m_nQuality
//       Der einzige belegte Aufruf der ganzen Bildfamilie
//       (QCGraphics.cpp:279). Er laeuft ueber einen GDI+-Kodierer; das ginge
//       ohne Fenster, prueft dann aber nur, dass GDI+ ein JPEG schreibt -
//       nicht, dass der Qualitaetswert ankommt. Verlustbehaftete Daten
//       liessen sich nur ueber Schwellwerte pruefen, und ein Schwellwert,
//       den man nicht begruenden kann, ist kein Test.
//
//   Serialize
//       Verlangt ein CArchive ueber einer echten Datei und wird von Eudora
//       nirgends aufgerufen.
//
