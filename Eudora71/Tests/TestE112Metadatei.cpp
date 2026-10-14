//
// TestE112Metadatei.cpp - wird das Bild wirklich in der angegebenen Groesse
// GEZEICHNET?
//
// Befund E-112, zweiter Anlauf (13.10.2026). TestE112.cpp prueft die REGEL
// (E112Zielrechteck) - und die stimmt seit 7.2.0.76. Trotzdem lag bei Gregor
// an 1.0.76 und an 1.0.84 das Logo ueber dem Text: das richtige Rechteck kam
// beim Zeichnen nie an. Paige spielt die Metadatei als MM_TEXT ab, und die
// Metadatei selbst setzt MM_TEXT - gezeichnet wird, was in ihr steht.
//
// Deshalb misst dieser Test nicht die Regel, sondern das BILD: eine
// Metadatei aus einem echten DIB, abgespielt in einen Speicher-DC, und
// gezaehlt wird, wie gross die gemalte Flaeche ist.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>

#include "TinyTest.h"
#include "UnderTestE112.h"
#include "UnderTestE112Meta.h"

namespace
{
	// Ein einfarbig rotes 32-Bit-DIB, von oben nach unten.
	struct RotesBild
	{
		BITMAPINFO bmi;
		DWORD* pBits;
		long b, h;

		RotesBild(long nB, long nH) : pBits(NULL), b(nB), h(nH)
		{
			ZeroMemory(&bmi, sizeof(bmi));
			bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
			bmi.bmiHeader.biWidth = nB;
			bmi.bmiHeader.biHeight = nH;            // von unten nach oben, wie die Bilder aus SECImage
											// (ein negatives biHeight nimmt die WMF-Metadatei nicht auf: gemalt 0x0)
			bmi.bmiHeader.biPlanes = 1;
			bmi.bmiHeader.biBitCount = 32;
			bmi.bmiHeader.biCompression = BI_RGB;
			pBits = new DWORD[nB * nH];
			for (long i = 0; i < nB * nH; i++)
				pBits[i] = 0x00FF0000;           // B=0 G=0 R=255
		}
		~RotesBild() { delete [] pBits; }
	};

	// Spielt die Metadatei in eine weisse Flaeche und liefert die Ausdehnung
	// der roten Punkte. Abgespielt wird wie bei Paige: MM_TEXT, Ursprung 0,0.
	bool Ausmessen(HMETAFILE hmf, long nFlaeche, long* pB, long* pH)
	{
		*pB = *pH = 0;
		BITMAPINFO bmi;
		ZeroMemory(&bmi, sizeof(bmi));
		bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
		bmi.bmiHeader.biWidth = nFlaeche;
		bmi.bmiHeader.biHeight = -nFlaeche;
		bmi.bmiHeader.biPlanes = 1;
		bmi.bmiHeader.biBitCount = 32;
		bmi.bmiHeader.biCompression = BI_RGB;

		void* pv = NULL;
		HDC hdc = ::CreateCompatibleDC(NULL);
		HBITMAP hbm = ::CreateDIBSection(hdc, &bmi, DIB_RGB_COLORS, &pv, NULL, 0);
		if (!hdc || !hbm || !pv)
		{
			if (hbm) ::DeleteObject(hbm);
			if (hdc) ::DeleteDC(hdc);
			return false;
		}
		HGDIOBJ hAlt = ::SelectObject(hdc, hbm);
		DWORD* p = (DWORD*) pv;
		for (long i = 0; i < nFlaeche * nFlaeche; i++)
			p[i] = 0x00FFFFFF;

		::SetMapMode(hdc, MM_TEXT);
		::PlayMetaFile(hdc, hmf);
		::GdiFlush();

		long xMax = -1, yMax = -1;
		for (long y = 0; y < nFlaeche; y++)
			for (long x = 0; x < nFlaeche; x++)
				if ((p[y * nFlaeche + x] & 0x00FFFFFF) == 0x00FF0000)
				{
					if (x > xMax) xMax = x;
					if (y > yMax) yMax = y;
				}
		*pB = xMax + 1;
		*pH = yMax + 1;

		::SelectObject(hdc, hAlt);
		::DeleteObject(hbm);
		::DeleteDC(hdc);
		return true;
	}

	// Angabe aus dem HTML, echte Dateigroesse -> gemalte Groesse.
	void Gezeichnet(long nAttrB, long nAttrH, long nEchtB, long nEchtH,
					long* pRegelB, long* pRegelH, long* pMalB, long* pMalH)
	{
		RotesBild bild(nEchtB, nEchtH);
		E112Zielrechteck(nAttrB, nAttrH, nEchtB, nEchtH, pRegelB, pRegelH);
		HMETAFILE hmf = E112MetadateiAusDIB(&bild.bmi, bild.pBits, nEchtB, nEchtH,
											*pRegelB, *pRegelH);
		*pMalB = *pMalH = 0;
		if (hmf)
		{
			Ausmessen(hmf, 400, pMalB, pMalH);
			::DeleteMetaFile(hmf);
		}
	}
}

void RunE112MetadateiTests(void)
{
	long rb, rh, mb, mh;

	TT_Suite("E-112: die Metadatei hat die Groesse, in der das Bild erscheinen soll");

	// ------------------------------------------------------------- (1)
	// Der Anlassfall, Zahlen aus Gregors Protokoll vom 18.09.2026.
	TT_BeginTest("E-112: angegeben 35x35, Datei 330x327 - gemalt werden 35x35");
	{
		Gezeichnet(35, 35, 330, 327, &rb, &rh, &mb, &mh);
		TT_Note("Regel %ldx%ld, gemalt %ldx%ld", rb, rh, mb, mh);
		TT_CHECK_MSG(mb == 35 && mh == 35,
			"Das WhatsApp-Symbol muss als 35x35 GEMALT werden, nicht nur so gerechnet");
		TT_CHECK_MSG(!(mb == 330 && mh == 327),
			"330x327 gemalt war der Zustand an 1.0.76 und 1.0.84 - Bild ueber dem Text");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	TT_BeginTest("E-112: angegeben 250x96, Datei 985x378 - gemalt werden 250x96");
	{
		Gezeichnet(250, 96, 985, 378, &rb, &rh, &mb, &mh);
		TT_Note("Regel %ldx%ld, gemalt %ldx%ld", rb, rh, mb, mh);
		TT_CHECK_MSG(mb == 250 && mh == 96, "angegeben 250x96 wird als 250x96 gemalt");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	// E-103 darf nicht brechen: ohne Angabe gilt die Datei.
	TT_BeginTest("E-103: ohne Groessenangabe wird die Datei in ihrer eigenen Groesse gemalt");
	{
		Gezeichnet(0, 0, 79, 64, &rb, &rh, &mb, &mh);
		TT_Note("Regel %ldx%ld, gemalt %ldx%ld", rb, rh, mb, mh);
		TT_CHECK_MSG(mb == 79 && mh == 64, "keine Angabe -> 79x64 wie die Datei");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	TT_BeginTest("E-112: nur die Breite angegeben - gemalt wird, was die Regel sagt");
	{
		Gezeichnet(150, 0, 300, 86, &rb, &rh, &mb, &mh);
		TT_Note("Regel %ldx%ld, gemalt %ldx%ld", rb, rh, mb, mh);
		TT_CHECK_MSG(mb == rb && mh == rh, "gemalte Groesse == Regel");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	TT_BeginTest("E-112: unbrauchbare Eingaben liefern keine Metadatei");
	{
		RotesBild bild(4, 4);
		TT_CHECK_MSG(E112MetadateiAusDIB(NULL, bild.pBits, 4, 4, 2, 2) == NULL, "ohne BITMAPINFO");
		TT_CHECK_MSG(E112MetadateiAusDIB(&bild.bmi, NULL, 4, 4, 2, 2) == NULL, "ohne Bildpunkte");
		TT_CHECK_MSG(E112MetadateiAusDIB(&bild.bmi, bild.pBits, 0, 4, 2, 2) == NULL, "Breite 0");
	}
	TT_EndTest();
}
