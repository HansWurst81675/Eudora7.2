//
// TestE193.cpp - Befund E-193: die Suche mit Umlauten oder Euro liefert
// widerspruechliche Ergebnisse.
//
// Der X1-Index (x1lib.dll) laesst das Euro-Zeichen weg, behandelt "ae" am
// Wortanfang wie "a" und findet mit "oeft" auch "oft" (gemessen 03.11.2026,
// tools/messen-e193.ps1). Die genaue Suche (SearchEngine) uebersah HTML-Mails,
// in denen der Umlaut als Entitaet steht (&auml;, &euro;). Behoben in zwei
// Schritten (Gregor 04.11.2026):
//   1. Weiche (SearchView.cpp): enthaelt ein Suchbegriff ein Byte ab 0x80,
//      nimmt Eudora die genaue Suche statt des Index;
//   2. die genaue Suche oeffnet dann HTML-Mails auch ohne rohen Treffer und
//      prueft den Text nach Html2Text (SearchEngine.cpp), und Html2Text kennt
//      &euro; (html2text.cpp).
//
// Geprueft am Quelltext; das Verhalten misst der Pruefstand (E-193w, E-193p).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E193_Suche(const char* szEudoraDir)
{
	TT_BeginTest("E-193: Suche mit Umlaut oder Euro nimmt die genaue Suche und liest HTML-Entitaeten");

	char* pV = QT_LiesNurCode(szEudoraDir, "SearchView.cpp");
	char* pS = QT_LiesNurCode(szEudoraDir, "..\\SearchEngine\\Src\\SearchEngine.cpp");
	char* pH = QT_LiesNurCode(szEudoraDir, "html2text.cpp");
	if (!pV || !pS || !pH)
	{
		TT_Fail("SearchView.cpp, SearchEngine.cpp oder html2text.cpp nicht lesbar - ungeprueft ist nicht gruen");
	}
	else
	{
		// 1. Weiche: nur ohne Umlaut der Index; X1-Abfrage bleibt beim Index.
		TT_CHECK_MSG(QT_Enthaelt(pV, "if ( ShouldUseIndexedSearch() && !bE193Genau )") &&
					 QT_Enthaelt(pV, "bool bE193Genau = ShouldUseIndexedSearch() && E193BrauchtGenaueSuche(m_MSC);"),
					 "DoSearch nimmt bei Umlaut oder Euro wieder den X1-Index (E-193)");
		TT_CHECK_MSG(QT_Enthaelt(pV, "verb == CRITERIA_TEXT_COMPARE_MATCHESX1QUERY") &&
					 QT_Enthaelt(pV, "(unsigned char) text[i] >= 0x80"),
					 "E193BrauchtGenaueSuche erkennt Umlaut/Euro oder die X1-Abfrage nicht mehr (E-193)");

		// 2. Genaue Suche: HTML-Mail auch ohne rohen Treffer oeffnen.
		TT_CHECK_MSG(QT_Enthaelt(pS, "if (!bOpenMessage && m_CorrectResults > 0 && pSum->IsHTML() && E193TextMitUmlaut(srchCriteria)) bOpenMessage = true;"),
					 "die genaue Suche oeffnet HTML-Mails mit Entitaeten nicht - &auml; wird nicht gefunden (E-193)");
		// 2b. ... und gibt das Postfach nicht nach der ersten Mail auf, nur weil der rohe Text
		//     nirgends passt (gemessen 04.11.2026: "Spaetzle" nur als Sp&auml;tzle fehlte).
		TT_CHECK_MSG(QT_Enthaelt(pS, "!m_pMSC->HasNegationSearch() && !bFoundMatches && !bE193Weiter)") &&
					 QT_Enthaelt(pS, "if (E193TextMitUmlaut(sc)) bE193Weiter = true;"),
					 "die genaue Suche bricht ein Postfach ohne rohen Treffer ab - ein Wort nur als Entitaet wird nie gefunden (E-193)");
		long lHilfe = QT_Stelle(pS, "bool E193TextMitUmlaut(SearchCriteria& Sct)");
		long lStart = QT_Stelle(pS, "bool SearchEngine::Start(");
		TT_CHECK_MSG(lHilfe >= 0 && lHilfe < lStart,
					 "E193TextMitUmlaut steht nicht vor SearchEngine::Start (E-193)");

		// 3. Html2Text kennt &euro;.
		TT_CHECK_MSG(QT_Enthaelt(pH, "strnicmp(szText, \"&euro\", 5) == 0)) { m_szDest += '\\x80';"),
					 "Html2Text uebersetzt &euro; nicht - das Euro-Zeichen fehlt in HTML-Mails (E-193)");
	}
	if (pV) free(pV);
	if (pS) free(pS);
	if (pH) free(pH);
	TT_EndTest();
}

void RunE193Tests(const char* szEudoraDir)
{
	Test_E193_Suche(szEudoraDir);
}
