//
// TestStartfehler.cpp - Regressionstests fuer behobene Fehler beim Start,
// als kritisch eingestuft.
//
// Angelegt am 24.10.2026 im Zweig fehlende_regression_tests_implementieren
// (Block 2b). Die Fehler sitzen im Fensteraufbau beim Start und sind ohne
// laufendes Eudora nicht aufzurufen. Geprueft wird deshalb der QUELLTEXT
// ohne Kommentare und die Projektdatei - jeder Fall ist gegengetestet: mit
// dem alten Stand wird er rot (Messung in der Commit-Nachricht).
//
#include <afx.h>
#include <string.h>
#include <stdlib.h>

#include "TinyTest.h"
#include "Quelltext.h"

// S-2: Stapelueberlauf beim Start. CAdWazooWnd::OnCreate legt die Werbeflaeche
// mit CRect(0,0,0,0) an, und Paige rekursiert beim Zeilenumbruch auf Breite
// null, bis der Stapel voll ist (gemessen am 30.08.2026, rund 800 Rahmen).
// Behoben, indem die Werbeleiste in der Fassung fuer Firmenkunden gar nicht
// erst angelegt wird. Die Absicherung steht auf drei Fuessen, und jeder
// einzelne bringt den Absturz zurueck, wenn er wegfaellt:
//   1. WazooBarMgr.cpp legt CAdWazooBar nur an, wenn !IsBoxBuild()
//   2. IsBoxBuild() ist wahr, weil DEFAULT_SWM_MODE (2) ist
//   3. DEFAULT_SWM_MODE ist 2, weil BUILD_BOX_OR_SITE_R_VERSION in JEDER
//      Baukonfiguration von Eudora.vcxproj gesetzt ist
static void Test_S2(const char* szEudoraDir)
{
	TT_BeginTest("S-2: die Werbeleiste wird in unserem Bau nicht angelegt");

	char* pCode = QT_LiesNurCode(szEudoraDir, "WazooBarMgr.cpp");
	if (!pCode) { TT_Fail("WazooBarMgr.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	TT_CHECK_MSG(QT_Zaehle(pCode, "DEBUG_NEW CAdWazooBar(") == 1,
				 "CAdWazooBar wird nicht genau einmal angelegt - Stelle verschoben?");
	TT_CHECK_MSG(QT_Enthaelt(pCode, "if (!QCSharewareManager::IsBoxBuild()) { CAdWazooBar* pAWB = DEBUG_NEW CAdWazooBar(this);"),
				 "die Werbeleiste wird angelegt, ohne nach IsBoxBuild zu fragen - CRect(0,0,0,0) laesst Paige rekursieren");
	free(pCode);

	char* pKopf = QT_LiesNurCode(szEudoraDir, "QCSharewareManager.h");
	if (!pKopf) { TT_Fail("QCSharewareManager.h nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	TT_CHECK_MSG(QT_Enthaelt(pKopf, "#ifdef BUILD_BOX_OR_SITE_R_VERSION #define DEFAULT_SWM_MODE (2)"),
				 "BUILD_BOX_OR_SITE_R_VERSION setzt DEFAULT_SWM_MODE nicht mehr auf 2 - IsBoxBuild wird falsch");
	free(pKopf);

	char* pImpl = QT_LiesNurCode(szEudoraDir, "QCSharewareManager.cpp");
	if (!pImpl) { TT_Fail("QCSharewareManager.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	char* pRumpf = QT_Abschnitt(pImpl, "bool QCSharewareManager::IsBoxBuild()", "#endif");
	TT_CHECK_MSG(pRumpf != NULL && QT_Enthaelt(pRumpf, "#if DEFAULT_SWM_MODE == 2 return true;"),
				 "IsBoxBuild liefert nicht mehr true fuer DEFAULT_SWM_MODE 2");
	if (pRumpf) free(pRumpf);
	free(pImpl);

	// Die Projektdatei roh lesen: in XML gibt es keine C-Kommentare.
	char* pProj = QT_Lesen(szEudoraDir, "Eudora.vcxproj");
	if (!pProj) { TT_Fail("Eudora.vcxproj nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	int nKonfig = 0, nMitBox = 0;
	for (char* p = strstr(pProj, "<PreprocessorDefinitions>"); p; p = strstr(p + 1, "<PreprocessorDefinitions>"))
	{
		const char* pEnde = strstr(p, "</PreprocessorDefinitions>");
		if (!pEnde) break;
		// Nur die Uebersetzer-Abschnitte zaehlen (die mit _WINDOWS), nicht
		// Ressourcen- und MIDL-Abschnitte, die nur _DEBUG/NDEBUG tragen.
		const size_t n = (size_t)(pEnde - p);
		char* pZeile = (char*) malloc(n + 1);
		memcpy(pZeile, p, n); pZeile[n] = 0;
		if (strstr(pZeile, "_WINDOWS;"))
		{
			nKonfig++;
			if (strstr(pZeile, "BUILD_BOX_OR_SITE_R_VERSION;")) nMitBox++;
		}
		free(pZeile);
	}
	TT_CHECK_MSG(nKonfig >= 2, "weniger als zwei Baukonfigurationen gefunden - Projektdatei umgebaut?");
	TT_CHECK_MSG(nMitBox == nKonfig,
				 "nicht jede Baukonfiguration setzt BUILD_BOX_OR_SITE_R_VERSION - dort kommt die Werbeleiste zurueck");
	free(pProj);

	TT_EndTest();
}

void RunStartfehlerTests(const char* szEudoraDir)
{
	TT_Suite("Startfehler S-2 (Regressionstests)");
	Test_S2(szEudoraDir);
}
