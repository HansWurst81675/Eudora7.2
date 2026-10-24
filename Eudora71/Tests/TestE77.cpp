//
// TestE77.cpp - werden IMAP-Postfachnamen mit Umlauten richtig angezeigt?
//
// Befund E-77: Gregor sah am 10.09.2026 "Entw&APw-rfe" und "Gel&APY-scht"
// statt "Entwuerfe" und "Geloescht" - so schickt GMX die Namen, im
// modifizierten UTF-7 aus RFC 3501, Abschnitt 5.1.3. Die Umkehrung gehoert
// dazu: wer einen Ordner mit Umlaut anlegt oder umbenennt, muss ihn dem
// Server wieder kodiert schicken, sonst entsteht dort ein falscher Name.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE77.h"

static void Hin(const char* szServer, const char* szAnzeige)
{
	char szAus[256];
	char szMsg[300];
	BOOL bOk = E77Utf7Dekodieren(szServer, szAus, sizeof(szAus));
	_snprintf(szMsg, sizeof(szMsg) - 1, "\"%s\" ergibt \"%s\", soll \"%s\"", szServer, bOk ? szAus : "(Fehler)", szAnzeige);
	szMsg[sizeof(szMsg) - 1] = 0;
	TT_CHECK_MSG(bOk && strcmp(szAus, szAnzeige) == 0, szMsg);
	BOOL bZur = E77Utf7Kodieren(szAnzeige, szAus, sizeof(szAus));
	_snprintf(szMsg, sizeof(szMsg) - 1, "zurueck: \"%s\" ergibt \"%s\", soll \"%s\"", szAnzeige, bZur ? szAus : "(Fehler)", szServer);
	szMsg[sizeof(szMsg) - 1] = 0;
	TT_CHECK_MSG(bZur && strcmp(szAus, szServer) == 0, szMsg);
}

void RunE77Tests(void)
{
	TT_Suite("E-77: IMAP-Postfachnamen in modifiziertem UTF-7");

	TT_BeginTest("E-77: Gregors Ordner von GMX, hin und zurueck");
	{
		Hin("Entw&APw-rfe", "Entw\xFCrfe");
		Hin("Gel&APY-scht", "Gel\xF6scht");
		Hin("&AMQ-pfel", "\xC4pfel");
		Hin("Stra&AN8-e", "Stra\xDF" "e");      // getrennt: \xDFe waere ein Hex-Escape
		Hin("Pr&APwA9g-fung", "Pr\xFC\xF6" "fung");
	}
	TT_EndTest();

	TT_BeginTest("E-77 Gegenrichtung: ASCII und & bleiben, Unbekanntes bleibt roh");
	{
		Hin("Spamverdacht", "Spamverdacht");
		Hin("Tom &- Jerry", "Tom & Jerry");
		char szAus[64];
		// Ein Zeichen ausserhalb von Windows-1252 (U+4E2D) laesst die
		// Dekodierung scheitern - der Aufrufer zeigt dann den rohen Namen.
		TT_CHECK_MSG(!E77Utf7Dekodieren("&Ti0-", szAus, sizeof(szAus)), "U+4E2D muss als nicht darstellbar scheitern");
		TT_CHECK_MSG(!E77Utf7Dekodieren("Entw&APw", szAus, sizeof(szAus)), "ein Abschnitt ohne \"-\" muss scheitern");
		TT_CHECK_MSG(!E77Utf7Kodieren("Entw\xFCrfe", szAus, 5), "zu kleiner Puffer muss scheitern");
	}
	TT_EndTest();
}
