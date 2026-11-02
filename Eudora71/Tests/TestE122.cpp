// TestE122.cpp - Regressionstest zu Befund E-122 (Quelltext).
//
// Das Eingangsdatum einer in einen IMAP-Ordner hochgeladenen Nachricht war um
// die Zeitzone verschoben: CImapAppend gab CSummary::m_Seconds an
// append_date, und das ist fuer eine Nachricht mit Date:-Kopf UTC minus die
// Ortszone (GetTimeMT liest die Felder mit mktime als Ortszeit). Behebung:
// CImapAppend::ReformatHeader berechnet beim Lesen des Date:-Kopfs das echte
// UTC (E122DatumAlsUtc: _mkgmtime statt mktime, dann die Absenderzone ab)
// und setzt m_Seconds damit.
//
// Gegenprobe beim Bau: einen der beiden Aufrufe von E122DatumAusKopf
// entfernen -> Test rot.

#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E122_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-122 (Quelltext): ReformatHeader setzt das IMAP-Eingangsdatum aus dem Date:-Kopf als echtes UTC");
	char* pText = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapAppend.cpp");
	if (!pText)
	{
		TT_Fail("EuImap\\src\\ImapAppend.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pHilfe = QT_Abschnitt(pText, "static long E122DatumAlsUtc(", "void CImapAppend::E122DatumAusKopf(");
	TT_CHECK_MSG(pHilfe != NULL, "E122DatumAlsUtc nicht gefunden");
	if (pHilfe)
	{
		TT_CHECK_MSG(QT_Enthaelt(pHilfe, "_mkgmtime( &Felder )"), "die Felder werden nicht mehr als UTC gelesen (E-122)");
		TT_CHECK_MSG(QT_Enthaelt(pHilfe, "FormatDateMT( pszWert, lUtc, nZoneMinuten );"), "die Zone des Absenders wird nicht mehr abgezogen (E-122)");
		TT_CHECK_MSG(!QT_Enthaelt(pHilfe, "mktime("), "E122DatumAlsUtc benutzt mktime - das liest die Felder als Ortszeit (E-122)");
		free(pHilfe);
	}

	char* pFn = QT_Abschnitt(pText, "BOOL CImapAppend::ReformatHeader ()", "BOOL CImapAppend::ReformatBody ()");
	TT_CHECK_MSG(pFn != NULL, "CImapAppend::ReformatHeader nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Zaehle(pFn, "bDateHeaderFound = TRUE;") == 2, "ReformatHeader erkennt den Date:-Kopf nicht mehr an genau zwei Stellen - Test anpassen");
		TT_CHECK_MSG(QT_Zaehle(pFn, "E122DatumAusKopf( t, (int) len );") == 2, "nicht jede Stelle, die den Date:-Kopf erkennt, setzt das Eingangsdatum daraus (E-122)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

void RunE122Tests(const char* szEudoraDir)
{
	Test_E122_Stelle(szEudoraDir);
}
