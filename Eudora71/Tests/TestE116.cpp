//
// TestE116.cpp - wird die Bildbreite aus <img width="..."> richtig gelesen?
//
// Befund E-116 (PRUEFER-22, F3): decimal_value_percent in PGHTMIMP.CPP
// pruefte nicht, ob ein Zeichen eine Ziffer ist. "digit &= 0x000F" machte
// aus "35px" die Zahl 3508 ('p' = 0x70 -> 0, 'x' = 0x78 -> 8) und aus "35.5"
// die Zahl 3645 ('.' = 0x2E -> 14). Seit E-112 wird das Bild auf diese
// Breite gezeichnet - eine Groessenangabe mit Einheit verzerrt das Bild.
//
// Die Gegenrichtung gehoert dazu: was vorher richtig war, muss richtig
// bleiben - reine Zahl, Prozent, Minus, und vor allem fuehrende Leerzeichen.
// " 35" ergab vorher zufaellig 35 (' ' & 0x0F = 0); eine Behebung, die nur
// an der ersten Nicht-Ziffer abbricht, haette daraus 0 gemacht.
//
// Die Werte kommen so an, wie GetNextToken sie liefert: ohne
// Anfuehrungszeichen, aber mit allem, was zwischen ihnen stand.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE116.h"

static void Fall(const char* szWert, long nMax, long nSoll)
{
	long nIst = E116DecimalValuePercent(szWert, nMax);
	char szMsg[160];
	_snprintf(szMsg, sizeof(szMsg) - 1, "width=\"%s\" (max %ld) ergibt %ld, soll %ld",
		szWert, nMax, nIst, nSoll);
	szMsg[sizeof(szMsg) - 1] = 0;
	TT_CHECK_MSG(nIst == nSoll, szMsg);
	TT_Note("width=\"%s\" -> %ld", szWert, nIst);
}

void RunE116Tests(void)
{
	TT_Suite("E-116: Bildbreite aus <img width=...> (decimal_value_percent)");

	// ------------------------------------------------------------- (1)
	TT_BeginTest("E-116: Einheit und Nachkommastelle beenden die Zahl");
	{
		Fall("35px", 400, 35);     // vorher 3508
		Fall("35.5", 400, 35);     // vorher 3645
		Fall("120 px", 400, 120);
		Fall("px", 400, 0);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	TT_BeginTest("E-116 Gegenrichtung: was vorher stimmte, stimmt weiter");
	{
		Fall("35", 400, 35);
		Fall("50%", 400, 200);
		Fall("100%", 600, 600);
		Fall("-5", 400, -5);
		Fall("", 400, 0);
		Fall("0", 400, 0);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	TT_BeginTest("E-116 Gegenrichtung: fuehrende Leerzeichen und Tabs werden uebersprungen");
	{
		Fall(" 35", 400, 35);      // vorher zufaellig richtig - darf nicht 0 werden
		Fall("\t35", 400, 35);
		Fall("  50%", 400, 200);
		Fall(" -5", 400, -5);      // das Vorzeichen steht hinter dem Leerzeichen
	}
	TT_EndTest();
}
