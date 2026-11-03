//
// TestE128.cpp - Regressionstests zu E-128
//
// E-128: eine gespeicherte Nachricht hiess .txt und enthielt HTML - der
//        Anwender erfuhr es nicht. Der Dialog "Speichern unter" bot auf allen
//        Wegen immer "txt" an (IDS_TEXT_EXTENSION), gleich was danach in der
//        Datei stand. Gregor am 20.10.2026 an 1.0.120: "allerdings fehlt der
//        hinweis fuer den benutzer, dass es keine TXT datei ist!"; am
//        03.11.2026 auf den Vorschlag "Endung aus dem Inhalt ableiten": "ja".
//
// Geprueft wird:
//   - E128DateiMitKopf / E128Vorgabeendung / E128FilterIndex selbst (aus
//     msgutils.cpp geschnitten, generated/msgutils_e128.inc);
//   - die Kette mit der ECHTEN Aufbereitung E101SpeicherfassungAufbereiten:
//     eine HTML-Nachricht ohne Kopfzeilen bekommt dort einen MIME-Kopf -
//     und damit .eml, nicht .txt;
//   - die Dateitypen in EudoraRes.rc gegen E128FilterIndex;
//   - die STELLEN in tocview.cpp, saveas.cpp, ReadMessageDoc.cpp und
//     compmsgd.cpp (Quelltext.h): die Vorgabe geht wirklich in den Dialog.
//
#include <afx.h>
#include <afxwin.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"
#include "UnderTestE101.h"

static const char kTocFilter[] =
	"Text Files (*.txt)|*.txt|Mail Files (*.eml)|*.eml|HTML Files (*.htm)|*.htm|All Files (*.*)|*.*||";
static const char kMsgFilter[] =
	"Text Files (*.txt)|*.txt|HTML Files (*.htm)|*.htm|All Files (*.*)|*.*||";

static void Test_E128_Vorgabeendung()
{
	TT_BeginTest("E-128: Vorgabeendung je Weg und Inhalt");

	// Postfachliste: der Inhalt haengt nicht an der Endung.
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(true, 1, true,  false), "eml") == 0, "eine Nachricht mit Kopf -> eml");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(true, 1, true,  true ), "eml") == 0, "eine HTML-Nachricht mit Kopf -> eml");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(true, 1, false, false), "txt") == 0, "eine Nachricht ohne Kopf -> txt");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(true, 2, true,  false), "txt") == 0, "zwei Nachrichten in einer Datei sind keine .eml");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(true, 0, true,  false), "txt") == 0, "keine Auswahl -> txt");

	// Fenster: der Inhalt folgt der Endung.
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(false, 1, false, true ), "htm") == 0, "HTML-Nachricht im Fenster -> htm");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(false, 1, true,  true ), "htm") == 0, "HTML-Nachricht im Fenster, Kopf egal -> htm");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(false, 1, true,  false), "txt") == 0, "Textnachricht im Fenster -> txt");
	TT_EndTest();
}

static void Test_E128_DateiMitKopf()
{
	TT_BeginTest("E-128: Kopf vorn - mit Kopfzeilen immer, ohne nur, wenn E-101 einen ergaenzt hat");
	TT_CHECK_MSG(UTE128_DateiMitKopf(true, "From: a\r\n\r\nx", "From: a\r\n\r\nx"), "mit Kopfzeilen");
	TT_CHECK_MSG(UTE128_DateiMitKopf(false, "<html>x</html>", "MIME-Version: 1.0\r\nContent-Type: text/html\r\n\r\n<html>x</html>"),
				 "ohne Kopfzeilen, MIME-Kopf ergaenzt");
	TT_CHECK_MSG(!UTE128_DateiMitKopf(false, "Hallo Welt\r\n", "Hallo Welt\r\n"), "reiner Text bleibt ohne Kopf");
	TT_CHECK_MSG(!UTE128_DateiMitKopf(false, "Hinweis: morgen\r\n", "Hinweis: morgen\r\n"),
				 "ein Rumpf, der wie eine Kopfzeile aussieht, ist keine");
	TT_CHECK_MSG(!UTE128_DateiMitKopf(false, "MIME-Version: 1.0 steht im Text\r\n", "MIME-Version: 1.0 steht im Text\r\n"),
				 "stand es schon vorher da, hat E-101 nichts ergaenzt");
	TT_CHECK_MSG(!UTE128_DateiMitKopf(false, NULL, NULL), "nichts -> kein Kopf");
	TT_EndTest();
}

static void Test_E128_KetteMitE101()
{
	//
	// Der Fall aus Gregors Meldung: eine HTML-Nachricht aus der Postfachliste.
	// Gerechnet wird mit der echten Aufbereitung, nicht mit einer Annahme
	// darueber, was sie tut (Arbeitsweise/extrakt-ist-nicht-das-programm.md).
	//
	TT_BeginTest("E-128: Kette Postfachliste - HTML ohne Kopfzeilen ergibt .eml, Text ohne Kopfzeilen .txt");

	const char* const kHtml = "<x-html>\r\n<html><body>Gr\xFC\xDF" "e</body></html>\r\n</x-html>\r\n";
	CString szDatei, szSpur;
	bool bGeaendert = UTE101_SpeicherfassungAufbereiten(kHtml, false, szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	bool bKopf = UTE128_DateiMitKopf(false, kHtml, bGeaendert ? (const char*) szDatei : kHtml);
	TT_CHECK_MSG(bGeaendert && bKopf, "E-101 setzt vor HTML einen MIME-Kopf - die Datei ist eine Mail-Datei");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(true, 1, bKopf, false), "eml") == 0, "-> eml (bis 7.2.1.131: txt)");

	const char* const kText = "Hallo Welt, nur ASCII.\r\n";
	szDatei.Empty(); szSpur.Empty();
	bGeaendert = UTE101_SpeicherfassungAufbereiten(kText, false, szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	bKopf = UTE128_DateiMitKopf(false, kText, bGeaendert ? (const char*) szDatei : kText);
	TT_CHECK_MSG(!bKopf, "reiner ASCII-Text bekommt keinen Kopf");
	TT_CHECK_MSG(strcmp(UTE128_Vorgabeendung(true, 1, bKopf, false), "txt") == 0, "-> txt");

	const char* const kHoch = "Gr\xFC\xDF" "e ohne Auszeichnung\r\n";
	szDatei.Empty(); szSpur.Empty();
	bGeaendert = UTE101_SpeicherfassungAufbereiten(kHoch, false, szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	bKopf = UTE128_DateiMitKopf(false, kHoch, bGeaendert ? (const char*) szDatei : kHoch);
	TT_CHECK_MSG(bKopf, "Text mit Umlauten bekommt von E-101 einen Kopf (Zeichensatz) - also .eml");
	TT_EndTest();
}

static void Test_E128_FilterIndex()
{
	TT_BeginTest("E-128: Eintrag der Dateityp-Liste zur Endung");
	TT_CHECK_MSG(UTE128_FilterIndex(kTocFilter, "txt") == 1, "txt -> 1");
	TT_CHECK_MSG(UTE128_FilterIndex(kTocFilter, "eml") == 2, "eml -> 2");
	TT_CHECK_MSG(UTE128_FilterIndex(kTocFilter, "htm") == 3, "htm -> 3");
	TT_CHECK_MSG(UTE128_FilterIndex(kTocFilter, "HTM") == 3, "Gross/Klein egal");
	TT_CHECK_MSG(UTE128_FilterIndex(kTocFilter, "html") == 0, "html ist nicht htm");
	TT_CHECK_MSG(UTE128_FilterIndex(kTocFilter, "xyz") == 0, "unbekannt -> 0");
	TT_CHECK_MSG(UTE128_FilterIndex(kMsgFilter, "htm") == 2, "Nachrichtenfilter: htm -> 2");
	TT_CHECK_MSG(UTE128_FilterIndex(kMsgFilter, "eml") == 0, "Nachrichtenfilter hat kein eml");
	TT_CHECK_MSG(UTE128_FilterIndex("Text Files (*.txt)|*.txt|All Files (*.*)|*.*|", "txt") == 1, "Liste mit einfachem Schluss");
	TT_CHECK_MSG(UTE128_FilterIndex("HTML (*.htm;*.html)|*.htm;*.html|Text|*.txt||", "html") == 1, "mehrere Muster mit ;");
	TT_CHECK_MSG(UTE128_FilterIndex("HTML (*.htm;*.html)|*.htm;*.html|Text|*.txt||", "txt") == 2, "zweites Paar nach ;-Muster");
	TT_CHECK_MSG(UTE128_FilterIndex(NULL, "txt") == 0 && UTE128_FilterIndex(kTocFilter, NULL) == 0 && UTE128_FilterIndex(kTocFilter, "") == 0,
				 "leere Eingaben -> 0");
	TT_EndTest();
}

static void Test_E128_Ressourcen(const char* szEudoraDir)
{
	TT_BeginTest("E-128 (Quelltext): Dateitypen in EudoraRes.rc passen zu den Vorgaben");
	char* pRc = QT_LiesNurCode(szEudoraDir, "EudoraRes.rc");
	if (!pRc)
	{
		TT_Fail("EudoraRes.rc nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pToc = QT_Abschnitt(pRc, "IDS_TOC_SAVEAS_FILE_FILTER \"", "||\"");
	TT_CHECK_MSG(pToc != NULL, "IDS_TOC_SAVEAS_FILE_FILTER nicht gefunden");
	if (pToc)
	{
		const char* pText = strchr(pToc, '"');
		pText = pText ? pText + 1 : pToc;
		TT_CHECK_MSG(UTE128_FilterIndex(pText, "eml") > 0, "Postfachliste: kein Eintrag fuer .eml");
		TT_CHECK_MSG(UTE128_FilterIndex(pText, "txt") > 0, "Postfachliste: kein Eintrag fuer .txt");
		TT_CHECK_MSG(!QT_Enthaelt(pToc, "rtf") && !QT_Enthaelt(pToc, "Rtf"), "Postfachliste bietet .rtf an - kein Weg schreibt RTF (E-195)");
		free(pToc);
	}
	char* pMsg = QT_Abschnitt(pRc, "IDS_MSG_SAVEAS_FILE_FILTER \"", "||\"");
	TT_CHECK_MSG(pMsg != NULL, "IDS_MSG_SAVEAS_FILE_FILTER nicht gefunden");
	if (pMsg)
	{
		const char* pText = strchr(pMsg, '"');
		pText = pText ? pText + 1 : pMsg;
		TT_CHECK_MSG(UTE128_FilterIndex(pText, "htm") > 0, "Fenster: kein Eintrag fuer .htm - die Vorgabe htm liefe ins Leere");
		free(pMsg);
	}
	free(pRc);

	char* pH = QT_LiesNurCode(szEudoraDir, "resource.h");
	TT_CHECK_MSG(pH && QT_Enthaelt(pH, "#define IDS_TOC_SAVEAS_FILE_FILTER 3131"), "IDS_TOC_SAVEAS_FILE_FILTER fehlt in resource.h");
	if (pH)
	{
		TT_CHECK_MSG(QT_Zaehle(pH, " 3131 ") + QT_Zaehle(pH, " 3131\n") <= 1, "3131 ist doppelt vergeben");
		free(pH);
	}
	TT_EndTest();
}

static void Test_E128_Stelle(const char* szEudoraDir, const char* szDatei,
							 const char* szVon, const char* szBis,
							 const char* const* aSoll, int nSoll,
							 const char* szNicht)
{
	char* p = QT_LiesNurCode(szEudoraDir, szDatei);
	if (!p)
	{
		TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", szDatei);
		return;
	}
	char* pFn = QT_Abschnitt(p, szVon, szBis);
	if (!pFn)
	{
		TT_Fail("%s: Abschnitt %s nicht gefunden", szDatei, szVon);
		free(p);
		return;
	}
	for (int i = 0; i < nSoll; i++)
	{
		if (!QT_Enthaelt(pFn, aSoll[i]))
			TT_Fail("%s: fehlt [%s] (E-128)", szDatei, aSoll[i]);
	}
	if (szNicht && QT_Enthaelt(pFn, szNicht))
		TT_Fail("%s: steht wieder [%s] (E-128)", szDatei, szNicht);
	free(pFn);
	free(p);
}

static void Test_E128_Quelltext(const char* szEudoraDir)
{
	TT_BeginTest("E-128 (Quelltext): alle drei Wege geben die Vorgabe in den Dialog");

	static const char* const kToc[] = {
		"bE128MitKopf = E128DateiMitKopf( bKopfE128, pszTextE128, bGeaendertE128 ? (LPCTSTR) szDateiE128 : pszTextE128 );",
		"E101SpeicherfassungAufbereiten( pszTextE128, bKopfE128, szDateiE128, szSpurE128 );",
		"const char * pszE128Endung = E128Vorgabeendung( true, SelCount, bE128MitKopf, false );",
		"CRString szE128Filter( IDS_TOC_SAVEAS_FILE_FILTER );",
		"CSaveAsDialog theDlg( szName, TRUE, FALSE, pszE128Endung, szE128Filter, NULL );",
		"theDlg.m_ofn.nFilterIndex = E128FilterIndex( szE128Filter, pszE128Endung );",
		"E128GewaehltSchreiben( \"Postfachliste\", szPathName );",
	};
	Test_E128_Stelle(szEudoraDir, "tocview.cpp", "void CTocView::OnFileSaveAs()", "void CTocView::OnEditCopy()",
					 kToc, (int)(sizeof(kToc) / sizeof(kToc[0])), "CRString( IDS_TEXT_EXTENSION )");

	static const char* const kSaveAs[] = {
		"const char* Extension = pszVorgabeendung ? pszVorgabeendung : (const char*) ExtensionText;",
		"CSaveAsDialog theDlg(Name, IsMessage, Stationery, Extension, Filter, pParent);",
		"theDlg.m_ofn.nFilterIndex = E128FilterIndex(Filter, pszVorgabeendung);",
	};
	Test_E128_Stelle(szEudoraDir, "saveas.cpp", "BOOL CSaveAs::Start(", "BOOL CSaveAs::CreateFile(",
					 kSaveAs, (int)(sizeof(kSaveAs) / sizeof(kSaveAs[0])), NULL);

	static const char* const kRead[] = {
		"const char * pszE128 = E128Vorgabeendung( false, 1, false, bHtmlE128 );",
		"SA.Start(m_Sum->m_Subject, TRUE, NULL, FALSE, pszE128)",
		"E128GewaehltSchreiben( \"Nachrichtenfenster\", SA.GetPathName() );",
	};
	Test_E128_Stelle(szEudoraDir, "ReadMessageDoc.cpp", "void CReadMessageDoc::OnFileSaveAs()", "BOOL CReadMessageDoc::SaveAsFile(",
					 kRead, (int)(sizeof(kRead) / sizeof(kRead[0])), NULL);

	static const char* const kComp[] = {
		"const char * pszE128 = E128Vorgabeendung( false, 1, false, bHtmlE128 );",
		"CSaveAsDialog theDlg( szName, TRUE, FALSE, pszE128, CRString( IDS_MSG_SAVEAS_FILE_FILTER ), NULL );",
		"theDlg.m_ofn.nFilterIndex = E128FilterIndex( CRString( IDS_MSG_SAVEAS_FILE_FILTER ), pszE128 );",
		"E128GewaehltSchreiben( \"Verfassen-Fenster\", szPathName );",
	};
	Test_E128_Stelle(szEudoraDir, "compmsgd.cpp", "void CCompMessageDoc::OnFileSaveAs()", "BOOL CCompMessageDoc::SaveAsFile(",
					 kComp, (int)(sizeof(kComp) / sizeof(kComp[0])), "CRString( IDS_TEXT_EXTENSION )");

	TT_EndTest();
}

void RunE128Tests(const char* szEudoraDir)
{
	Test_E128_Vorgabeendung();
	Test_E128_DateiMitKopf();
	Test_E128_KetteMitE101();
	Test_E128_FilterIndex();
	Test_E128_Ressourcen(szEudoraDir);
	Test_E128_Quelltext(szEudoraDir);
}
