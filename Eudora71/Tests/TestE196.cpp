//
// TestE196.cpp - Regressionstests zu E-196 und E-195
//
// E-196: "Speichern unter" als .htm aus dem Nachrichten- und aus dem
//        Verfassen-Fenster schrieb keine Zeichensatzangabe - die Bytes sind
//        windows-1252, ein Browser, der UTF-8 annimmt, zeigt Ersatzzeichen.
//        Gemessen am 02.11.2026 an 7.2.1.131 (tools/messen-e194.ps1):
//        htm-meta=0 in beiden Fenstern, mit und ohne Kopfzeilen.
//        Geprueft wird E196HtmlZeichensatz selbst (aus msgutils.cpp
//        geschnitten) und die STELLE in beiden SaveAsFile (Quelltext.h).
//
// E-195: der Dialog bot "Rtf Files (*.rtf)" an und lieferte Klartext; kein
//        Speicherweg wertet .rtf aus (ReadMessageDoc.cpp und compmsgd.cpp
//        unterscheiden nur .htm/.html). Geprueft wird der Filtertext
//        IDS_TXT_HTML_FILE_FILTER in EudoraRes.rc.
//
#include <afx.h>
#include <afxwin.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"
#include "UnderTestE101.h"

static bool Hat(const CString& s, const char* p)
{
	return s.Find(p) >= 0;
}

static const char kMeta[] =
	"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\">";

static void Test_E196_Paige()
{
	TT_BeginTest("E-196: Verfassen-Fenster (<html><body>) bekommt <head> mit Zeichensatz");
	// So begann Gregors Datei vom 01.11.2026 (175 Byte): \xE4 und \x80 im Text.
	const char* const kIn = "<html>\r\n<body>\r\nPreis 5 \x80, \xE4\xF6\xFC<br>\r\n</body>\r\n</html>\r\n";
	CString szDatei, szSpur;
	const bool bOk = UTE196_HtmlZeichensatz(kIn, szDatei, szSpur);
	TT_CHECK_MSG(bOk, "keine Aenderung gemeldet (E-196)");
	CString szErwartet = CString("<html>\r\n<head>") + kMeta + "</head>\r\n<body>\r\nPreis 5 \x80, \xE4\xF6\xFC<br>\r\n</body>\r\n</html>\r\n";
	if (szDatei != szErwartet) TT_Fail("unerwartet: [%s]", (LPCTSTR) szDatei);
	TT_CHECK_MSG(Hat(szSpur, "meta=eingefuegt") && Hat(szSpur, "ort=html"), "Spur passt nicht");
	TT_EndTest();
}

static void Test_E196_OhneHtml()
{
	TT_BeginTest("E-196: Nachrichtenfenster (nur Rumpf-HTML, Kopfzeilen davor) - Angabe ganz vorn");
	const char* const kIn = "<SPAN class=\"EUDORAHEADER\">From: x</SPAN>\r\n<DIV>Gr\xFC\xDF" "e</DIV>";
	CString szDatei, szSpur;
	UTE196_HtmlZeichensatz(kIn, szDatei, szSpur);
	CString szErwartet = CString(kMeta) + "\r\n" + kIn;
	if (szDatei != szErwartet) TT_Fail("unerwartet: [%s]", (LPCTSTR) szDatei);
	TT_CHECK_MSG(Hat(szSpur, "ort=anfang"), "Spur nennt den Ort nicht");

	// Text vor <html> (Verfassen-Fenster mit Kopfzeilen): nicht hinter
	// <html>, sondern vorn - sonst kaeme die Angabe nach dem Text.
	const char* const kIn2 = "<div>Date: x</div>\r\n<html>\r\n<body>\xE4</body></html>";
	CString szD2, szS2;
	UTE196_HtmlZeichensatz(kIn2, szD2, szS2);
	TT_CHECK_MSG(szD2.Find(kMeta) == 0, "Angabe steht nicht ganz vorn");
	TT_EndTest();
}

static void Test_E196_Head()
{
	TT_BeginTest("E-196: vorhandenes <head> - Angabe direkt dahinter; <header> ist kein <head>");
	const char* const kIn = "<!DOCTYPE html>\r\n<html><head><title>T</title></head><body><header>k</header>\xE4</body></html>";
	CString szDatei, szSpur;
	UTE196_HtmlZeichensatz(kIn, szDatei, szSpur);
	TT_CHECK_MSG(Hat(szDatei, CString("<html><head>\r\n") + kMeta + "<title>T</title>"), "Angabe steht nicht hinter <head>");
	TT_CHECK_MSG(szDatei.Find("<!DOCTYPE html>") == 0, "DOCTYPE steht nicht mehr vorn");
	TT_CHECK_MSG(Hat(szSpur, "ort=head"), "Spur nennt head nicht");

	const char* const kIn2 = "<!DOCTYPE html>\r\n<header>k</header>";
	CString szD2, szS2;
	UTE196_HtmlZeichensatz(kIn2, szD2, szS2);
	TT_CHECK_MSG(szD2 == CString("<!DOCTYPE html>\r\n") + kMeta + "\r\n<header>k</header>", "Angabe nicht hinter dem DOCTYPE");
	TT_EndTest();
}

static void Test_E196_Vorhanden()
{
	TT_BeginTest("E-196: vorhandene Angabe - falsche umgeschrieben, richtige unangetastet");
	const char* const kFalsch = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body>\xE4</body></html>";
	CString szDatei, szSpur;
	const bool bOk = UTE196_HtmlZeichensatz(kFalsch, szDatei, szSpur);
	TT_CHECK_MSG(bOk, "falsche Angabe nicht umgeschrieben");
	TT_CHECK_MSG(Hat(szDatei, "content=\"text/html; charset=windows-1252\"></head>"), "Angabe nicht auf windows-1252");
	TT_CHECK_MSG(!Hat(szDatei, "UTF-8") && szDatei.Find("<meta", szDatei.Find("<meta") + 1) < 0, "UTF-8 steht noch da oder eine zweite Angabe wurde eingefuegt");
	TT_CHECK_MSG(Hat(szSpur, "meta=umgeschrieben") && Hat(szSpur, "alt=utf-8"), "Spur passt nicht");

	const char* const kHtml5 = "<meta charset=\"iso-8859-1\"><p>\xE4</p>";
	CString szD3, szS3;
	UTE196_HtmlZeichensatz(kHtml5, szD3, szS3);
	TT_CHECK_MSG(szD3 == "<meta charset=\"windows-1252\"><p>\xE4</p>", "HTML5-Angabe nicht umgeschrieben");

	// Gegenprobe: richtige Angabe - nichts zu tun.
	const char* const kRichtig = "<html><head><meta charset=windows-1252></head><body>\xE4</body></html>";
	CString szD2, szS2;
	const bool bOk2 = UTE196_HtmlZeichensatz(kRichtig, szD2, szS2);
	TT_CHECK_MSG(!bOk2 && szD2.IsEmpty(), "richtige Angabe wurde angefasst");
	TT_CHECK_MSG(Hat(szS2, "meta=passt"), "Spur meldet nicht 'passt'");
	TT_EndTest();
}

static void Test_E196_Entitaeten()
{
	TT_BeginTest("E-196 / E-136: Entitaeten (Emoji) bleiben, wie sie sind");
	const char* const kIn = "<DIV>Feuer &#128293; und &#1046;</DIV>";
	CString szDatei, szSpur;
	UTE196_HtmlZeichensatz(kIn, szDatei, szSpur);
	TT_CHECK_MSG(Hat(szDatei, "Feuer &#128293; und &#1046;</DIV>"), "Entitaeten veraendert (E-136)");
	TT_EndTest();
}

// Die STELLE: im HTML-Zweig beider SaveAsFile zwischen GetMessageAsHTML und Put.
static void Test_E196_Stelle(const char* szEudoraDir, const char* szDatei,
							 const char* szVon, const char* szBis, const char* szAufruf,
							 const char* szPut)
{
	char* pText = QT_LiesNurCode(szEudoraDir, szDatei);
	if (!pText)
	{
		TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", szDatei);
		return;
	}
	char* pFn = QT_Abschnitt(pText, szVon, szBis);
	if (!pFn)
		TT_Fail("%s nicht gefunden", szVon);
	else
	{
		const long lHtml = QT_Stelle(pFn, "view->GetMessageAsHTML(");
		const long lE196 = QT_Stelle(pFn, szAufruf);
		const long lPut  = QT_Stelle(pFn, szPut);
		TT_CHECK_MSG(QT_Zaehle(pFn, "E196HtmlFuerDatei(") == 1, "E196HtmlFuerDatei nicht genau einmal im SaveAsFile (E-196)");
		if (!(lHtml >= 0 && lE196 > lHtml && lPut > lE196))
			TT_Fail("%s: E196HtmlFuerDatei steht nicht zwischen GetMessageAsHTML und Put (%ld %ld %ld)", szDatei, lHtml, lE196, lPut);
		free(pFn);
	}
	free(pText);
}

static void Test_E196_Quelltext(const char* szEudoraDir)
{
	TT_BeginTest("E-196 (Quelltext): HTML-Zweig beider Fenster laeuft ueber E196HtmlFuerDatei");
	Test_E196_Stelle(szEudoraDir, "ReadMessageDoc.cpp",
					 "BOOL CReadMessageDoc::SaveAsFile(", "void CReadMessageDoc::OnUpdateMessageServer(",
					 "msg = E196HtmlFuerDatei( msg, \"Nachrichtenfenster\" );", "if ( pFile->Put( msg ) != S_OK )");
	Test_E196_Stelle(szEudoraDir, "compmsgd.cpp",
					 "BOOL CCompMessageDoc::SaveAsFile(", "void CCompMessageDoc::OnUpdateFileSaveAs(",
					 "msg = E196HtmlFuerDatei( msg, \"Verfassen-Fenster\" );", "if ( FAILED( pFile->Put( msg ) ) )");

	char* pMu = QT_LiesNurCode(szEudoraDir, "msgutils.cpp");
	char* pFn = pMu ? QT_Abschnitt(pMu, "CString E196HtmlFuerDatei(", "return CString( pszHtml ? pszHtml : \"\" ); }") : NULL;
	TT_CHECK_MSG(pFn != NULL, "E196HtmlFuerDatei nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "E196HtmlZeichensatz( pszHtml, szDatei, szSpur );"), "E196HtmlFuerDatei ruft den Kern nicht");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "PutDebugLog( DEBUG_MASK_DIALOG,"), "E196HtmlFuerDatei schreibt keine Spur (E-196)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if ( bOk ) return szDatei;"), "E196HtmlFuerDatei gibt das Ergebnis nicht zurueck");
		free(pFn);
	}
	if (pMu)
		free(pMu);
	TT_EndTest();
}

static void Test_E195_Filter(const char* szEudoraDir)
{
	TT_BeginTest("E-195 (Quelltext): IDS_TXT_HTML_FILE_FILTER bietet kein .rtf mehr an");
	char* pRc = QT_LiesNurCode(szEudoraDir, "EudoraRes.rc");
	if (!pRc)
	{
		TT_Fail("EudoraRes.rc nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pZeile = QT_Abschnitt(pRc, "IDS_TXT_HTML_FILE_FILTER \"", "||\"");
	TT_CHECK_MSG(pZeile != NULL, "IDS_TXT_HTML_FILE_FILTER nicht gefunden");
	if (pZeile)
	{
		TT_CHECK_MSG(!QT_Enthaelt(pZeile, "rtf") && !QT_Enthaelt(pZeile, "Rtf"), "der Speicherdialog bietet wieder .rtf an - kein Weg schreibt RTF (E-195)");
		// Gegenprobe: die beiden echten Typen stehen noch da.
		TT_CHECK_MSG(QT_Enthaelt(pZeile, "Text Files (*.txt)|*.txt|"), "Text Files fehlt");
		TT_CHECK_MSG(QT_Enthaelt(pZeile, "HTML Files (*.htm)|*.htm|"), "HTML Files fehlt");
		free(pZeile);
	}
	free(pRc);
	TT_EndTest();
}

void RunE196Tests(const char* szEudoraDir)
{
	Test_E196_Paige();
	Test_E196_OhneHtml();
	Test_E196_Head();
	Test_E196_Vorhanden();
	Test_E196_Entitaeten();
	Test_E196_Quelltext(szEudoraDir);
	Test_E195_Filter(szEudoraDir);
}
