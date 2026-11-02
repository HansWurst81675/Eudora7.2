//
// TestE205.cpp - Regressionstest zu E-205
//
// E-205: "Speichern unter" aus dem Verfassen-Fenster mit Kopfzeilen schrieb
//        "Date: ... +6000", 59 Stunden in der Zukunft, und jedes weitere
//        Speichern lag 60 Stunden spaeter. Gemessen am 02.11.2026 an
//        7.2.1.131 (tools/messen-e205.ps1): neu1=59h neu2=119h zone=+6000.
//        Zwei Ursachen:
//          1. CCompMessageDoc::InitializeNew legte m_TimeZoneMinutes in
//             SEKUNDEN an ("-GetGMTOffset() * 60").
//          2. ComposeDate( buf, Sum ) schreibt die Zusammenfassung zurueck;
//             bei der ungueltigen Zone +6000 hob FormatDate das nicht auf.
//        Beide Speicherwege (compmsgd.cpp, tocview.cpp) lesen jetzt nur.
//
// Die Stellen haengen an Dokument und Zusammenfassung - geprueft wird die
// STELLE (Quelltext.h, nur Code). Am Programm misst der Fall E-205p.
//
#include <afx.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E205_Zone(const char* szEudoraDir)
{
	TT_BeginTest("E-205 (Quelltext): InitializeNew legt die Zone in Minuten an");
	char* pText = QT_LiesNurCode(szEudoraDir, "compmsgd.cpp");
	if (!pText)
	{
		TT_Fail("compmsgd.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "BOOL CCompMessageDoc::InitializeNew (", "BOOL CCompMessageDoc::OnNewDocument()");
	TT_CHECK_MSG(pFn != NULL, "CCompMessageDoc::InitializeNew nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "m_Sum->m_TimeZoneMinutes = -GetGMTOffset();"), "Zone nicht in Minuten (E-205)");
		TT_CHECK_MSG(!QT_Enthaelt(pFn, "m_Sum->m_TimeZoneMinutes = -GetGMTOffset() * 60;"), "Zone wieder in Sekunden - +6000 im Date: (E-205)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "m_Sum->m_Seconds = time(NULL) - m_Sum->m_TimeZoneMinutes * 60;"), "m_Seconds nicht mehr Zeit minus Zone in Sekunden");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static void Test_E205_NurLesen(const char* szEudoraDir)
{
	TT_BeginTest("E-205 (Quelltext): Speichern unter schreibt die Zusammenfassung nicht zurueck");
	struct { const char* szDatei; const char* szVon; const char* szBis; const char* szSoll; const char* szAlt; } kWege[] = {
		{ "compmsgd.cpp", "BOOL CCompMessageDoc::SaveAsFile(", "void CCompMessageDoc::OnUpdateFileSaveAs(",
		  "ComposeDate( dateMaybe, m_Sum->m_Seconds, m_Sum->m_TimeZoneMinutes );", "ComposeDate( dateMaybe, m_Sum )" },
		{ "tocview.cpp", "void CTocView::OnFileSaveAs()", "void CTocView::OnEditCopy()",
		  "ComposeDate( szDateMaybe, pSummary->m_Seconds, pSummary->m_TimeZoneMinutes );", "ComposeDate( szDateMaybe, pSummary )" },
	};
	for (int i = 0; i < (int)(sizeof(kWege) / sizeof(kWege[0])); i++)
	{
		char* pText = QT_LiesNurCode(szEudoraDir, kWege[i].szDatei);
		if (!pText) { TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", kWege[i].szDatei); continue; }
		char* pFn = QT_Abschnitt(pText, kWege[i].szVon, kWege[i].szBis);
		if (!pFn) TT_Fail("%s nicht gefunden", kWege[i].szVon);
		else
		{
			if (QT_Zaehle(pFn, kWege[i].szSoll) != 1)
				TT_Fail("%s: ComposeDate nicht genau einmal mit Werten statt Zusammenfassung (E-205)", kWege[i].szDatei);
			if (QT_Enthaelt(pFn, kWege[i].szAlt))
				TT_Fail("%s: ComposeDate schreibt wieder in die Zusammenfassung (E-205)", kWege[i].szDatei);
			free(pFn);
		}
		free(pText);
	}
	TT_EndTest();
}

void RunE205Tests(const char* szEudoraDir)
{
	Test_E205_Zone(szEudoraDir);
	Test_E205_NurLesen(szEudoraDir);
}
