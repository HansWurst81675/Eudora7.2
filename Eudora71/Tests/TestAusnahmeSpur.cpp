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
	free(pKopf);
	TT_EndTest();

	// E-154 (PRUEFER-58 K1): eine Ausnahme ausserhalb einer Fensterbotschaft
	// (Leerlauf, PreTranslateMessage, Nachbearbeitung von Aufgaben) kommt in
	// CEudoraApp::Run an, nicht in ProcessWndProcException. Eudora endet dann
	// ohne Meldung; beide catch-Zweige muessen eine Zeile schreiben, bevor sie
	// die Ausnahme verwerfen.
	TT_BeginTest("ZIEL 4 / E-154: Ausnahmen ausserhalb von Fensterbotschaften landen im eudora.log");
	char* pRun = QT_Abschnitt(pCode, "int CEudoraApp::Run()", "void CEudoraApp::SaveStdProfileSettings()");
	TT_CHECK_MSG(pRun != NULL, "CEudoraApp::Run nicht gefunden");
	if (pRun)
	{
		const long lMfc = QT_Stelle(pRun, "catch (CException * pException) {");
		const long lStd = QT_Stelle(pRun, "catch (std::exception & exception) {");
		TT_CHECK_MSG(lMfc >= 0 && lStd > lMfc, "die beiden catch-Zweige sind nicht mehr da");
		if (lMfc >= 0 && lStd > lMfc)
		{
			char* pMfc = pRun + lMfc;
			const long lLogMfc = QT_Stelle(pMfc, "PutDebugLog(DEBUG_MASK_MISC, szSpur);");
			const long lDel    = QT_Stelle(pMfc, "pException->Delete();");
			TT_CHECK_MSG(lLogMfc >= 0 && lDel > lLogMfc && lLogMfc < (lStd - lMfc),
						 "CException-Zweig: keine Protokollzeile vor dem Verwerfen");
			TT_CHECK_MSG(QT_Zaehle(pRun, "\"Ausnahme ausserhalb einer Fensterbotschaft (ZIEL 4), Eudora endet:") == 2,
						 "nicht beide catch-Zweige schreiben den Protokolltext");
			TT_CHECK_MSG(QT_Stelle(pRun + lStd, "PutDebugLog(DEBUG_MASK_MISC, szSpur);") >= 0,
						 "std::exception-Zweig: keine Protokollzeile");
		}
		free(pRun);
	}
	free(pCode);
	TT_EndTest();
}
