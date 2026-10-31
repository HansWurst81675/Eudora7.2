//
// TestE140.cpp - Regressionstest zu E-140
//
// E-140: "Speichern unter" aus dem NACHRICHTENFENSTER und aus dem
//        VERFASSEN-FENSTER schrieb eine Textdatei ohne MIME-Version, ohne
//        Content-Type und ohne Zeichensatz. Nur der Weg aus der
//        Postfachliste (tocview.cpp) lief ueber E101SpeicherfassungAufbereiten.
//        Gemessen am 31.10.2026 an 7.2.1.128 (tools/messen-e140.ps1):
//        liste ct=1, lesen ct=0, verfassen ct=0. Nach der Behebung alle drei
//        ct=1 charset=windows-1252, Rumpf byte-gleich lang.
//
// Beide Wege haengen an Dokument, Ansicht und Datei - der Pruefstand liest
// deshalb die STELLE (Quelltext.h, nur Code). Den Kern selbst prueft
// TestE101.cpp.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E140_Lesen(const char* szEudoraDir)
{
	TT_BeginTest("E-140 (Quelltext): Speichern unter aus dem Nachrichtenfenster schreibt Text nur ueber E140TextFuerDatei");
	char* pText = QT_LiesNurCode(szEudoraDir, "ReadMessageDoc.cpp");
	if (!pText)
	{
		TT_Fail("ReadMessageDoc.cpp nicht lesbar - ungeprueft ist nicht gruen");
		return;
	}
	char* pFn = QT_Abschnitt(pText, "BOOL CReadMessageDoc::SaveAsFile(", "void CReadMessageDoc::OnUpdateMessageServer(");
	TT_CHECK_MSG(pFn != NULL, "CReadMessageDoc::SaveAsFile nicht gefunden");
	if (pFn)
	{
		// Drei Put-Aufrufe: HTML (bleibt ohne Kopfzeilen), Text mit und
		// ohne "Absaetze raten" - die beiden Textwege muessen durch den Kern.
		TT_CHECK_MSG(QT_Zaehle(pFn, "pFile->Put(") == 3, "SaveAsFile hat nicht mehr genau drei Put-Aufrufe - Test anpassen, jeden neuen Textweg ueber E140TextFuerDatei fuehren");
		TT_CHECK_MSG(QT_Zaehle(pFn, "pFile->Put( (LPCTSTR) E140TextFuerDatei( CopyText,") == 1, "Text mit 'Absaetze raten' geht ohne Zeichensatzangabe hinaus (E-140)");
		TT_CHECK_MSG(QT_Zaehle(pFn, "pFile->Put( (LPCTSTR) E140TextFuerDatei( msg,") == 1, "Text ohne 'Absaetze raten' geht ohne Zeichensatzangabe hinaus (E-140)");
		free(pFn);
	}
	free(pText);
}

static void Test_E140_Verfassen(const char* szEudoraDir)
{
	TT_BeginTest("E-140 (Quelltext): Speichern unter aus dem Verfassen-Fenster schreibt Text nur ueber E140TextFuerDatei");
	char* pText = QT_LiesNurCode(szEudoraDir, "compmsgd.cpp");
	if (!pText)
	{
		TT_Fail("compmsgd.cpp nicht lesbar - ungeprueft ist nicht gruen");
		return;
	}
	char* pFn = QT_Abschnitt(pText, "BOOL CCompMessageDoc::SaveAsFile(", "void CCompMessageDoc::OnUpdateFileSaveAs(");
	TT_CHECK_MSG(pFn != NULL, "CCompMessageDoc::SaveAsFile nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Zaehle(pFn, "pFile->Put( (LPCTSTR) E140TextFuerDatei( CopyText,") == 1, "Text mit 'Absaetze raten' geht ohne Zeichensatzangabe hinaus (E-140)");

		// Ohne "Absaetze raten" teilen sich Text und HTML das letzte Put.
		// Die Ergaenzung muss deshalb im Textzweig stehen: NACH
		// GetMessageAsText und VOR dem gemeinsamen Put - im HTML-Zweig
		// wuerde sie eine .htm-Datei mit Kopfzeilen beginnen lassen.
		const long lText = QT_Stelle(pFn, "view->GetMessageAsText(");
		const long lE140 = QT_Stelle(pFn, "msg = E140TextFuerDatei( msg,");
		const long lPut  = QT_Stelle(pFn, "if ( FAILED( pFile->Put( msg ) ) )");
		TT_CHECK_MSG(QT_Zaehle(pFn, "msg = E140TextFuerDatei( msg,") == 1, "Text ohne 'Absaetze raten' geht ohne Zeichensatzangabe hinaus (E-140)");
		TT_CHECK_MSG(lText >= 0 && lE140 > lText && lPut > lE140, "E140TextFuerDatei steht nicht im Textzweig zwischen GetMessageAsText und dem letzten Put (E-140)");
		free(pFn);
	}
	free(pText);
}

static void Test_E140_Kern(const char* szEudoraDir)
{
	TT_BeginTest("E-140 (Quelltext): E140TextFuerDatei ruft den Kern aus E-101 und gibt dessen Ergebnis zurueck");
	char* pText = QT_LiesNurCode(szEudoraDir, "msgutils.cpp");
	if (!pText)
	{
		TT_Fail("msgutils.cpp nicht lesbar - ungeprueft ist nicht gruen");
		return;
	}
	char* pFn = QT_Abschnitt(pText, "CString E140TextFuerDatei(", "return CString( pszText ? pszText : \"\" ); }");
	TT_CHECK_MSG(pFn != NULL, "E140TextFuerDatei nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "E101SpeicherfassungAufbereiten( pszText,"), "E140TextFuerDatei ruft den Kern nicht mehr (E-140)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if ( bOk ) return szDatei;"), "E140TextFuerDatei gibt das Ergebnis des Kerns nicht zurueck (E-140)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "PutDebugLog( DEBUG_MASK_DIALOG,"), "E140TextFuerDatei schreibt keine Spur ins Protokoll (E-140)");
		free(pFn);
	}
	free(pText);
}

void RunE140Tests(const char* szEudoraDir)
{
	Test_E140_Lesen(szEudoraDir);
	Test_E140_Verfassen(szEudoraDir);
	Test_E140_Kern(szEudoraDir);
}
