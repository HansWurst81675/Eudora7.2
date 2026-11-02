// TestE177.cpp - Regressionstest zu Befund E-177 (Quelltext).
//
// Die Filteraktion "Notify Application" mit dem Platzhalter %6 legt eine
// Datei an und uebergibt ihren Pfad an ein Programm (filtersd.cpp,
// CFilter::SetupCommandLine). Fuer empfangene Nachrichten schreibt sie ueber
// CReadMessageDoc::SaveAs - und das schrieb die Nachricht samt ORIGINAL-
// Kopfzeile: bei einer per POP empfangenen UTF-8-Mail "charset=utf-8" ueber
// einem Rumpf, den Eudora beim Empfang nach windows-1252 uebersetzt hatte.
// Gemessen am 02.11.2026 am Pruefstand C:\Temp\E177 (tools\messen-e177.ps1,
// Fall E-177p): falsche-angabe=1.
//
// Behebung: beide PutText-Aufrufe in CReadMessageDoc::SaveAs gehen durch
// E140TextFuerDatei, also durch denselben Kern wie "Speichern unter"
// (E-101, E-140), der eine falsche Angabe ersetzt und eine fehlende ergaenzt.
//
// Gegenprobe beim Bau: einen der beiden Aufrufe auf SA.PutText(Text)
// zuruecksetzen -> genau Test_E177_SaveAs wird rot.

#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E177_SaveAs(const char* szEudoraDir)
{
	TT_BeginTest("E-177 (Quelltext): CReadMessageDoc::SaveAs schreibt nur ueber E140TextFuerDatei");
	char* pText = QT_LiesNurCode(szEudoraDir, "ReadMessageDoc.cpp");
	if (!pText)
	{
		TT_Fail("ReadMessageDoc.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "BOOL CReadMessageDoc::SaveAs(CSaveAs& SA)", "void CReadMessageDoc::OnFileSaveAs(");
	TT_CHECK_MSG(pFn != NULL, "CReadMessageDoc::SaveAs nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Zaehle(pFn, "SA.PutText(") == 2, "SaveAs hat nicht mehr genau zwei PutText-Aufrufe - Test anpassen, jeden Weg ueber E140TextFuerDatei fuehren");
		TT_CHECK_MSG(QT_Zaehle(pFn, "SA.PutText( (LPCTSTR) E140TextFuerDatei( CopyText,") == 1, "Text mit 'Absaetze raten' geht mit der Original-Kopfzeile hinaus (E-177)");
		TT_CHECK_MSG(QT_Zaehle(pFn, "SA.PutText( (LPCTSTR) E140TextFuerDatei( Text,") == 1, "Text ohne 'Absaetze raten' geht mit der Original-Kopfzeile hinaus (E-177)");
		// PRUEFER-81 K5: der Kopfzeilen-Schalter muss dem Text folgen - mit
		// "true" fest verdrahtet setzte ein Weg ohne Kopfzeilen die
		// MIME-Zeilen mitten in den Text.
		TT_CHECK_MSG(QT_Zaehle(pFn, "( bKopfzeilen && !m_Sum->IsSubPart() ) ? true : false") == 2, "der Kopfzeilen-Schalter folgt nicht mehr bKopfzeilen/IsSubPart (E-177, PRUEFER-81 K5)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static void Test_E177_Filterweg(const char* szEudoraDir)
{
	TT_BeginTest("E-177 (Quelltext): die Filteraktion schreibt empfangene Nachrichten weiter ueber CReadMessageDoc::SaveAs");
	char* pText = QT_LiesNurCode(szEudoraDir, "filtersd.cpp");
	if (!pText)
	{
		TT_Fail("filtersd.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "CString CFilter::SetupCommandLine(", "CFilterList::~CFilterList()");
	TT_CHECK_MSG(pFn != NULL, "CFilter::SetupCommandLine nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "((CReadMessageDoc *)doc)->SaveAs(sa);"), "die Filteraktion schreibt nicht mehr ueber CReadMessageDoc::SaveAs - dann deckt der Test E-177 nicht mehr ab, Weg pruefen");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static void Test_E177_Utf8OhneBindestrich(const char* szEudoraDir)
{
	TT_BeginTest("E-177 (Quelltext): der Speicherkern haelt \"utf8\" ohne Bindestrich nicht fuer uebersetzt");
	char* pText = QT_LiesNurCode(szEudoraDir, "msgutils.cpp");
	if (!pText)
	{
		TT_Fail("msgutils.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	// PRUEFER-81 K1: FindMIMECharset kennt nur "utf-8"; eine Nachricht mit
	// "charset=utf8" liegt unuebersetzt im Postfach. Stand die Schreibweise
	// in der Liste der uebersetzten Angaben, wurde aus der richtigen Angabe
	// "windows-1252" ueber UTF-8-Bytes.
	TT_CHECK_MSG(QT_Zaehle(pText, "szCs == \"utf8\"") == 0, "\"utf8\" steht wieder in der Liste der uebersetzten Zeichensaetze (E-177, PRUEFER-81 K1)");
	TT_CHECK_MSG(QT_Zaehle(pText, "szCs == \"utf-8\"") >= 1, "\"utf-8\" fehlt in der Liste der uebersetzten Zeichensaetze - Test anpassen");
	free(pText);
	TT_EndTest();
}

void RunE177Tests(const char* szEudoraDir)
{
	Test_E177_SaveAs(szEudoraDir);
	Test_E177_Filterweg(szEudoraDir);
	Test_E177_Utf8OhneBindestrich(szEudoraDir);
}
