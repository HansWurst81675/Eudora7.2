//
// TestE72.cpp - Regressionstest zu E-72 und E-64 (Filter, Datenverlust)
//
// E-72, behoben in 7.2.0.36, von Gregor am 10.09.2026 bestaetigt ("filter
// funktionieren"): die rechte Haelfte des Filterfensters schrieb beim
// Wegklicken ihren LEEREN Zustand in den gewaehlten Filter zurueck -
// Haekchen, Werte, Aktionsliste. Ein Filter mit geleertem Wert heisst
// "enthaelt nichts" und trifft jede Nachricht; mit "transfer" schob ein
// Filterlauf bei Gregor den ganzen Posteingang nach Junk (E-64).
//
// Zwei Sperren, beide hier geprueft:
//   1. CFiltersViewRight::DoDataExchange schreibt nur zurueck, was die
//      Ansicht wirklich geladen hat (m_pGeladen).
//   2. CFilter::MatchValue: ein leerer Suchwert passt auf NICHTS - fuer den
//      Fall, dass eine geleerte Regel schon in der Filters.pce steht.
//
// Beide Funktionen haengen an MFC-Ansicht, Filterliste und CSummary - der
// Pruefstand liest deshalb die STELLE (Quelltext.h).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_Zurueckschreiben(const char* szEudoraDir)
{
	TT_BeginTest("E-72 (Quelltext): das Filterfenster schreibt nur einen Filter zurueck, den es geladen hat");
	char* pText = QT_LiesNurCode(szEudoraDir, "filtersv.cpp");
	if (!pText)
	{
		TT_Fail("filtersv.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pCtor = QT_Abschnitt(pText, "CFiltersViewRight::CFiltersViewRight()", "}");
	TT_CHECK_MSG(pCtor != NULL && QT_Enthaelt(pCtor, "m_pGeladen = NULL;"), "der Konstruktor setzt m_pGeladen nicht auf NULL");
	free(pCtor);

	char* pDDX = QT_Abschnitt(pText, "void CFiltersViewRight::DoDataExchange(", "void CFiltersViewRight::DataEx(");
	TT_CHECK_MSG(pDDX != NULL, "CFiltersViewRight::DoDataExchange nicht gefunden");
	if (pDDX)
	{
		const long lGeladen = QT_Stelle(pDDX, "m_pGeladen = filt;");
		const long lSperre  = QT_Stelle(pDDX, "if (pDX->m_bSaveAndValidate == TRUE && filt && m_pGeladen != filt) {");
		const long lZurueck = QT_Stelle(pDDX, "if (pDX->m_bSaveAndValidate == TRUE && filt) {");
		TT_CHECK_MSG(lGeladen >= 0, "m_pGeladen wird beim Laden nicht mehr gesetzt");
		TT_CHECK_MSG(lSperre >= 0, "die Sperre 'm_pGeladen != filt' vor dem Zurueckschreiben fehlt");
		TT_CHECK_MSG(lSperre >= 0 && lZurueck > lSperre, "die Sperre steht nicht VOR dem Zurueckschreiben");
		if (lSperre >= 0 && lZurueck > lSperre)
		{
			char* pZwischen = QT_Abschnitt(pDDX + lSperre, "m_pGeladen != filt) {", "if (pDX->m_bSaveAndValidate == TRUE && filt) {");
			TT_CHECK_MSG(pZwischen != NULL && QT_Enthaelt(pZwischen, "return;"), "die Sperre kehrt nicht zurueck - geschrieben wird trotzdem");
			free(pZwischen);
		}
		free(pDDX);
	}

	free(pText);
	TT_EndTest();
}

static void Test_LeererWert(const char* szEudoraDir)
{
	TT_BeginTest("E-72/E-64 (Quelltext): ein Filter mit leerem Suchwert trifft keine Nachricht");
	char* pText = QT_LiesNurCode(szEudoraDir, "filtersd.cpp");
	if (!pText)
	{
		TT_Fail("filtersd.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pFn = QT_Abschnitt(pText, "BOOL CFilter::MatchValue(", "BOOL CFilter::MatchCondition(");
	TT_CHECK_MSG(pFn != NULL, "CFilter::MatchValue nicht gefunden");
	if (pFn)
	{
		const long lLeer    = QT_Stelle(pFn, "if (value.IsEmpty()) { return FALSE; }");
		const long lJunk    = QT_Stelle(pFn, "pSum->GetJunkScore() > iJunkScore");
		const long lVerglei = QT_Stelle(pFn, "szLowerCaseContents = Contents;");
		TT_CHECK_MSG(lLeer >= 0, "die Abfrage 'leerer Wert passt auf nichts' fehlt - ein geleerter Filter verschiebt den ganzen Posteingang");
		TT_CHECK_MSG(lLeer >= 0 && lVerglei > lLeer, "die Abfrage steht nicht vor dem Textvergleich");
		TT_CHECK_MSG(lJunk >= 0 && lLeer > lJunk, "die Abfrage steht vor den Junk-Score-Verben - die vergleichen Zahlen und haben keinen Text");
		free(pFn);
	}

	free(pText);
	TT_EndTest();
}

void RunE72Tests(const char* szEudoraDir)
{
	Test_Zurueckschreiben(szEudoraDir);
	Test_LeererWert(szEudoraDir);
}
