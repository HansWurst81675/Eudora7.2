//
// TestE171.cpp - Regressionstest zu E-171
//
// E-171: "Search Mailfolder" (ebenso Search Mailbox / Search Eudora) aus dem
//        Rechtsklickmenue einer Mail OHNE markierten Text brachte "There has
//        been an internal error during the search". Die Aufrufer verlangen den
//        sofortigen Start, CSearchView::DoSearch findet kein Kriterium.
//        Jetzt startet OpenFindMessagesWindow (guiutils.cpp) ohne Suchtext
//        nicht. Gemessen am 31.10.2026: 7.2.1.128 fehlermeldung=1, Bau
//        e327d7ec fehlermeldung=0, Suchfenster in beiden Faellen offen.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E171(const char* szEudoraDir)
{
	TT_BeginTest("E-171 (Quelltext): OpenFindMessagesWindow startet ohne Suchtext keine Suche");
	char* pText = QT_LiesNurCode(szEudoraDir, "guiutils.cpp");
	if (!pText)
	{
		TT_Fail("guiutils.cpp nicht lesbar - ungeprueft ist nicht gruen");
		return;
	}
	char* pFn = QT_Abschnitt(pText, "void OpenFindMessagesWindow(", "LPARAM(pSearchView->m_BeginBtn.GetSafeHwnd()) ); } }");
	TT_CHECK_MSG(pFn != NULL, "OpenFindMessagesWindow nicht gefunden (E-171)");
	if (pFn)
	{
		const long lRiegel = QT_Stelle(pFn, "if ( bStartSearch && ( !szSearchPhrase || !*szSearchPhrase ) ) { bStartSearch = false;");
		const long lStart  = QT_Stelle(pFn, "if (bStartSearch)");
		TT_CHECK_MSG(lRiegel >= 0, "ohne Suchtext wird der Start nicht mehr abgeschaltet - die Meldung 'internal error' kommt wieder (E-171)");
		TT_CHECK_MSG(lRiegel >= 0 && lStart > lRiegel, "der Riegel steht nicht vor dem Start der Suche (E-171)");
		free(pFn);
	}
	free(pText);
}

void RunE171Tests(const char* szEudoraDir)
{
	Test_E171(szEudoraDir);
}
