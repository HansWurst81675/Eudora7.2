//
// TestE113.cpp - wird ein Bild, das breiter ist als der Textbereich, auf
// dessen Breite verkleinert - und zwar seitenverhaeltnistreu?
//
// Befund E-113: Bilder, die breiter sind als das Fenster, liefen rechts
// hinaus. Gregor am 18.09.2026: "ok, erst A, dann B" - A ist der Deckel beim
// Laden. Gemessen am 24.10.2026 am Pruefstand: ein Banner 985x378 wurde im
// Verfassen-Fenster (771 breit) mit gemalt=985x378 gezeichnet.
//
// Die Gegenrichtung gehoert dazu: was hineinpasst, bleibt unveraendert, und
// ohne bekannte Grenze (0) wird nichts angefasst.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE113.h"

static void Fall(long nMax, long nB, long nH, long nSollB, long nSollH)
{
	long b = nB, h = nH;
	char szMsg[200];
	E113Deckeln(nMax, &b, &h);
	_snprintf(szMsg, sizeof(szMsg) - 1, "%ldx%ld bei Grenze %ld ergibt %ldx%ld, soll %ldx%ld",
		nB, nH, nMax, b, h, nSollB, nSollH);
	szMsg[sizeof(szMsg) - 1] = 0;
	TT_CHECK_MSG(b == nSollB && h == nSollH, szMsg);
	TT_Note("%ldx%ld -> %ldx%ld (Grenze %ld)", nB, nH, b, h, nMax);
}

void RunE113Tests(void)
{
	TT_Suite("E-113: Bilder auf die Breite des Textbereichs deckeln");

	// ------------------------------------------------------------- (1)
	TT_BeginTest("E-113: zu breites Bild wird seitenverhaeltnistreu verkleinert");
	{
		Fall(700, 985, 378, 700, 269);   // der Banner aus Testdaten/e113-breites-bild.eml
		Fall(700, 900, 345, 700, 268);
		Fall(500, 1000, 1, 500, 1);      // Hoehe bleibt mindestens 1
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	TT_BeginTest("E-113 Gegenrichtung: was passt, bleibt; ohne Grenze nichts");
	{
		Fall(700, 100, 99, 100, 99);
		Fall(700, 700, 300, 700, 300);   // genau so breit wie der Platz
		Fall(0, 985, 378, 985, 378);     // Grenze unbekannt
		Fall(-5, 985, 378, 985, 378);
		Fall(700, 0, 0, 0, 0);           // kein Rechteck
	}
	TT_EndTest();
}
