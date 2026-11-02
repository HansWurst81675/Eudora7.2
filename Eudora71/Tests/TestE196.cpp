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
// E-207: "Speichern unter" aus dem Signaturfenster schrieb eine LEERE Datei
//        und setzte das Geaendert-Kennzeichen zurueck - die Aenderungen
//        gingen beim Schliessen ohne Frage verloren. CSignatureDoc::Serialize
//        rief CPaigeEdtView::Serialize, die seit dem Original auskommentiert
//        ist (landet in CObject::Serialize). Gemessen am 02.11.2026 an
//        7.2.1.131 (tools/messen-e207.ps1): txt=leer htm=leer frage=0.
//        Geprueft wird die STELLE in signatur.cpp (Quelltext.h).
//
#include <afx.h>
#include <afxwin.h>
#include <ctype.h>
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
	//
	// PRUEFER-86 K2/N1: das Textdatei- und das Signaturfenster behalten
	// "Rtf Files" (IDS_TXT_HTML_FILE_FILTER) wie im Original. Echtes RTF
	// schreibt nur das Textdateifenster (TextFileView.cpp); das
	// Signaturfenster schreibt Text bzw. HTML (E-207). Die Speicherdialoge
	// fuer Nachrichten (compmsgd.cpp, saveas.cpp) nehmen
	// IDS_MSG_SAVEAS_FILE_FILTER ohne .rtf.
	//
	TT_BeginTest("E-195 (Quelltext): Speicherdialog fuer Nachrichten ohne .rtf, Textdatei/Signatur mit");
	char* pRc = QT_LiesNurCode(szEudoraDir, "EudoraRes.rc");
	if (!pRc)
	{
		TT_Fail("EudoraRes.rc nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pMsg = QT_Abschnitt(pRc, "IDS_MSG_SAVEAS_FILE_FILTER \"", "||\"");
	TT_CHECK_MSG(pMsg != NULL, "IDS_MSG_SAVEAS_FILE_FILTER nicht gefunden");
	if (pMsg)
	{
		TT_CHECK_MSG(!QT_Enthaelt(pMsg, "rtf") && !QT_Enthaelt(pMsg, "Rtf"), "der Speicherdialog fuer Nachrichten bietet wieder .rtf an - kein Nachrichtenweg schreibt RTF (E-195)");
		TT_CHECK_MSG(QT_Enthaelt(pMsg, "Text Files (*.txt)|*.txt|"), "Text Files fehlt");
		TT_CHECK_MSG(QT_Enthaelt(pMsg, "HTML Files (*.htm)|*.htm|"), "HTML Files fehlt");
		free(pMsg);
	}
	char* pTxt = QT_Abschnitt(pRc, "IDS_TXT_HTML_FILE_FILTER \"", "||\"");
	TT_CHECK_MSG(pTxt != NULL, "IDS_TXT_HTML_FILE_FILTER nicht gefunden");
	if (pTxt)
	{
		TT_CHECK_MSG(QT_Enthaelt(pTxt, "Rtf Files (*.rtf)|*.rtf|"), "Textdatei-/Signaturfenster ohne .rtf - das Textdateifenster schreibt echtes RTF (PRUEFER-86 K2)");
		free(pTxt);
	}
	free(pRc);

	// Wer welchen Filter nimmt.
	struct { const char* szDatei; const char* szSoll; } kWege[] = {
		{ "compmsgd.cpp", "CRString( IDS_MSG_SAVEAS_FILE_FILTER )" },
		{ "saveas.cpp",   "CRString Filter(IDS_MSG_SAVEAS_FILE_FILTER);" },
		{ "textfile.cpp", "CRString(IDS_TXT_HTML_FILE_FILTER)" },
		{ "signatur.cpp", "CRString(IDS_TXT_HTML_FILE_FILTER)" },
	};
	for (int i = 0; i < (int)(sizeof(kWege) / sizeof(kWege[0])); i++)
	{
		char* p = QT_LiesNurCode(szEudoraDir, kWege[i].szDatei);
		if (!p) { TT_Fail("%s nicht lesbar", kWege[i].szDatei); continue; }
		if (!QT_Enthaelt(p, kWege[i].szSoll))
			TT_Fail("%s nimmt nicht %s (E-195)", kWege[i].szDatei, kWege[i].szSoll);
		free(p);
	}
	char* pCm = QT_LiesNurCode(szEudoraDir, "compmsgd.cpp");
	if (pCm)
	{
		TT_CHECK_MSG(!QT_Enthaelt(pCm, "IDS_TXT_HTML_FILE_FILTER"), "das Verfassen-Fenster nimmt wieder den Filter mit .rtf (E-195)");
		free(pCm);
	}
	TT_EndTest();
}

static void Test_E196_K7()
{
	TT_BeginTest("E-196 PRUEFER-86 K7: leere Angabe charset=\"\" und <head> im Kommentar");
	CString szD, szS;
	UTE196_HtmlZeichensatz("<meta charset=\"\"><p>\xE4</p>", szD, szS);
	if (szD != "<meta charset=\"windows-1252\"><p>\xE4</p>") TT_Fail("leere Angabe falsch gefuellt: [%s]", (LPCTSTR) szD);

	// Wert am Ende von content="..." ohne eigenes Anfuehrungszeichen.
	CString szD3, szS3;
	UTE196_HtmlZeichensatz("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=\"><p>x</p>", szD3, szS3);
	if (szD3 != "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\"><p>x</p>") TT_Fail("Angabe am Ende von content falsch: [%s]", (LPCTSTR) szD3);

	// PRUEFER-86 N3: dasselbe mit einem Attribut in Anfuehrungszeichen
	// dahinter. Erst hier steht ein Gegenstueck zum Ende von content - aber
	// HINTER dem Tag. Ohne die Schranke nGegen < nZu wuerde das Ende von
	// content uebersprungen und der Name dahinter gesetzt.
	CString szD4, szS4;
	UTE196_HtmlZeichensatz("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=\"><p class=\"x\">x</p>", szD4, szS4);
	if (szD4 != "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\"><p class=\"x\">x</p>") TT_Fail("Anfuehrungszeichen hinter dem Tag als Gegenstueck genommen (N3): [%s]", (LPCTSTR) szD4);

	CString szD2, szS2;
	UTE196_HtmlZeichensatz("<!-- <head> --><html><body>\xE4</body></html>", szD2, szS2);
	TT_CHECK_MSG(szD2.Find("<!-- <head> -->") == 0, "Kommentar veraendert");
	TT_CHECK_MSG(szD2.Find(kMeta) > (int) strlen("<!-- <head> -->"), "Angabe im Kommentar eingesetzt (K7)");
	TT_CHECK_MSG(Hat(szS2, "ort=html"), "Kommentar-<head> als Kopf genommen");
	TT_EndTest();
}

// Zwischen lVon und lBis steht nur Leerraum.
static bool NurLeerraum(const char* pText, long lVon, long lBis)
{
	for (long i = lVon; i < lBis; i++)
		if (!isspace((unsigned char) pText[i]))
			return false;
	return true;
}

static void Test_E207_Signatur(const char* szEudoraDir)
{
	TT_BeginTest("E-207 (Quelltext): Speichern unter im Signaturfenster schreibt den Inhalt");
	char* pText = QT_LiesNurCode(szEudoraDir, "signatur.cpp");
	if (!pText)
	{
		TT_Fail("signatur.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	// Im Code (Kommentare weg) darf der Aufruf ins Leere nirgends stehen.
	TT_CHECK_MSG(!QT_Enthaelt(pText, "CPaigeEdtView::Serialize"), "signatur.cpp ruft wieder CPaigeEdtView::Serialize - die ist auskommentiert, die Datei bleibt leer (E-207)");
	char* pSer = QT_Abschnitt(pText, "void CSignatureDoc::Serialize(", "SetModifiedFlag(FALSE);");
	TT_CHECK_MSG(pSer != NULL, "CSignatureDoc::Serialize nicht gefunden");
	if (pSer)
	{
		const long lSaveAs = QT_Stelle(pSer, "if (m_SaveAs)");
		const long lAufruf = QT_Stelle(pSer, "pView->E207SpeichernUnter(ar);");
		if (!(lSaveAs >= 0 && lAufruf > lSaveAs))
			TT_Fail("Speichern unter (m_SaveAs) ruft nicht E207SpeichernUnter (%ld %ld)", lSaveAs, lAufruf);
		free(pSer);
	}
	char* pFn = QT_Abschnitt(pText, "void CSignatureView::E207SpeichernUnter(", "void CSignatureView::Serialize(");
	TT_CHECK_MSG(pFn != NULL, "CSignatureView::E207SpeichernUnter nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "theTxr.ExportData( pDatei, format );"), "E207SpeichernUnter schreibt nichts (E-207)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "format = PgDataTranslator::kFmtText;"), "E207SpeichernUnter schreibt nicht Text als Vorgabe");
		//
		// PRUEFER-86 N5: die FOLGE als Ganzes - Bedingung .htm/.html, die
		// Zuweisung kFmtHtml als einzige Anweisung dahinter, dann sofort
		// ExportData. Nur "steht irgendwo in der Funktion" blieb gruen, als
		// hinter der Zuweisung wieder kFmtText gesetzt wurde (Gegenprobe J3).
		//
		const char* const kIf   = "if ( szEndung.CompareNoCase( CRString( IDS_HTM_EXTENSION ) ) == 0 ||";
		const char* const kOder = "szEndung.CompareNoCase( CRString( IDS_HTML_EXTENSION ) ) == 0 )";
		const char* const kZuw  = "format = PgDataTranslator::kFmtHtml;";
		const char* const kExp  = "theTxr.ExportData( pDatei, format );";
		const long lIf   = QT_Stelle(pFn, kIf);
		const long lOder = QT_Stelle(pFn, kOder);
		const long lZuw  = QT_Stelle(pFn, kZuw);
		const long lExp  = QT_Stelle(pFn, kExp);
		if (!(lIf >= 0 && lOder > lIf && lZuw > lOder && lExp > lZuw))
			TT_Fail("E207SpeichernUnter: Bedingung .htm/.html, HTML-Zuweisung und ExportData nicht in dieser Folge (%ld %ld %ld %ld)", lIf, lOder, lZuw, lExp);
		else
		{
			TT_CHECK_MSG(NurLeerraum(pFn, lIf + (long) strlen(kIf), lOder), "zwischen .htm- und .html-Bedingung steht etwas anderes (E-207, N5)");
			TT_CHECK_MSG(NurLeerraum(pFn, lOder + (long) strlen(kOder), lZuw), "die Bedingung .htm/.html steuert nicht die HTML-Zuweisung (E-207, N5)");
			TT_CHECK_MSG(NurLeerraum(pFn, lZuw + (long) strlen(kZuw), lExp), "zwischen HTML-Zuweisung und ExportData steht etwas - .htm koennte als Text hinausgehen (E-207, N5)");
		}
		TT_CHECK_MSG(QT_Zaehle(pFn, "format =") == 2, "E207SpeichernUnter setzt das Format nicht genau zweimal (Vorgabe Text, HTML bei .htm) (E-207, N5)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

void RunE196Tests(const char* szEudoraDir)
{
	Test_E196_Paige();
	Test_E196_OhneHtml();
	Test_E196_Head();
	Test_E196_Vorhanden();
	Test_E196_Entitaeten();
	Test_E196_K7();
	Test_E196_Quelltext(szEudoraDir);
	Test_E195_Filter(szEudoraDir);
	Test_E207_Signatur(szEudoraDir);
}
