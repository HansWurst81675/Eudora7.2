//
// TestE160.cpp - Regressionstest zu Befund E-160
//
// Gregor am Testpaket 7.2.0.125 (26.10.2026): Persona -> Rechtsklick -> Neu
// zeigte die Windows-Meldung "Zum Ausfuehren der gewuenschten Aktion ist
// kein E-Mail-Programm zugeordnet". Gemessen: der Kontoassistent laedt die
// Importmodule, OLImport.eif lud Mapi32.dll und meldete sich an, obwohl
// kein Outlook-Profil in der Registry stand. Seitdem hoert
// OLImportClass::FindMainOLKey ohne Profil- und Identitaetsschluessel auf,
// BEVOR MAPI angefasst wird.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE160Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-160: ohne Outlook-Eintraege laedt der Kontoassistent kein MAPI");
	char* pCode = QT_LiesNurCode(szEudoraDir, "../Importers/OLImport/OLImportClass.cpp");
	if (!pCode) { TT_Fail("OLImportClass.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	QT_LeerraumZusammen(pCode);
	char* pFn = QT_Abschnitt(pCode, "bool OLImportClass::FindMainOLKey(bool bDisplayErrDialog)", "if(!MAPILogon(bDisplayErrDialog))");
	TT_CHECK_MSG(pFn != NULL, "FindMainOLKey oder sein MAPILogon nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if (!m_bProfileKey && !m_bIdentityKey) return false;"),
					 "FindMainOLKey meldet sich ohne Outlook-Eintrag bei MAPI an - Windows zeigt dann 'kein E-Mail-Programm zugeordnet'");
		free(pFn);
	}
	free(pCode);
	TT_EndTest();
}
