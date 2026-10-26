//
// TestAusnahmeSpur.cpp - Regressionstest zur Spurmarke fuer ZIEL.md
// Kriterium 2 und 4 ("Encountered an improper argument")
//
// Eine Ausnahme, die aus einer Fensterbotschaft bis zu
// CWinApp::ProcessWndProcException durchschlaegt, zeigt die MFC als Meldung.
// Eudora schrieb sie nirgends mit - 0 Treffer in Gregors Protokollen bewiesen
// deshalb nichts (26.10.2026). Seitdem ueberschreibt CEudoraApp die Funktion,
// schreibt eine Zeile ins eudora.log und ruft danach die MFC-Fassung.
// Dieser Test haelt fest, dass die Spurmarke bleibt: verschwindet sie, wird
// der Pruefstandsfall ZIEL24 (darf "Ausnahme in Fensterbotschaft" nicht
// enthalten) lautlos gruen - er haette nichts mehr, das er sehen koennte.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunAusnahmeSpurTests(const char* szEudoraDir)
{
	TT_BeginTest("ZIEL 2/4: Ausnahmen aus Fensterbotschaften landen im eudora.log");
	char* pCode = QT_LiesNurCode(szEudoraDir, "eudora.cpp");
	char* pKopf = QT_LiesNurCode(szEudoraDir, "eudora.h");
	if (!pCode || !pKopf)
	{
		TT_Fail("eudora.cpp oder eudora.h nicht lesbar - ungeprueft ist nicht gruen");
		free(pCode); free(pKopf); TT_EndTest(); return;
	}
	QT_LeerraumZusammen(pCode);
	QT_LeerraumZusammen(pKopf);

	TT_CHECK_MSG(QT_Enthaelt(pKopf, "virtual LRESULT ProcessWndProcException(CException* e, const MSG* pMsg);"),
				 "CEudoraApp deklariert ProcessWndProcException nicht mehr");
	char* pRumpf = QT_Abschnitt(pCode, "LRESULT CEudoraApp::ProcessWndProcException(", "int CEudoraApp::ExitInstance()");
	TT_CHECK_MSG(pRumpf != NULL, "CEudoraApp::ProcessWndProcException nicht gefunden");
	if (pRumpf)
	{
		const long lSpur = QT_Stelle(pRumpf, "PutDebugLog(DEBUG_MASK_MISC, szSpur);");
		const long lText = QT_Stelle(pRumpf, "\"Ausnahme in Fensterbotschaft (ZIEL 2/4):");
		const long lMfc  = QT_Stelle(pRumpf, "return CWinApp::ProcessWndProcException(e, pMsg);");
		TT_CHECK_MSG(lText >= 0, "der Protokolltext 'Ausnahme in Fensterbotschaft (ZIEL 2/4):' fehlt - der Pruefstandsfall sucht genau ihn");
		TT_CHECK_MSG(lSpur > lText, "die Zeile wird nicht ins Protokoll geschrieben");
		TT_CHECK_MSG(lMfc > lSpur, "die MFC-Fassung wird nicht danach gerufen - die Meldung fiele weg");
		free(pRumpf);
	}
	free(pCode);
	free(pKopf);
	TT_EndTest();
}
