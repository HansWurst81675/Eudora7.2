//
// TestE220.cpp - Regressionstests zu E-220
//
// E-220: der Dateiname, den "Speichern unter" aus dem Betreff vorschlaegt,
//        verlor alle Umlaute (StripIllegalMT vergleicht  *szSrc > 127  mit
//        vorzeichenbehaftetem char), behielt zwei Leerzeichen, wo ein "|"
//        stand, und kam nur mit den 63 Zeichen der Zusammenfassung. Gregor am
//        03.11.2026 an 7.2.2.132: "dateinamen so vorgeben, dass man auf
//        speichern klicken kann, ohne den namen zu aendern."
//
// Geprueft wird:
//   - E220DateinameAusBetreff selbst (aus msgutils.cpp geschnitten,
//     generated/msgutils_e220.inc);
//   - die STELLEN in tocview.cpp, ReadMessageDoc.cpp, compmsgd.cpp und
//     saveas.cpp (Quelltext.h): der Vorschlag kommt aus E220DateinameVorschlag
//     und geht nicht mehr durch StripIllegalMT.
//
#include <afx.h>
#include <afxwin.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"
#include "UnderTestE101.h"

static bool Gleich(const char* pszBetreff, const char* pszSoll, size_t nZiel = 261)
{
	char	sz[400];
	memset(sz, 'X', sizeof(sz));
	UTE220_DateinameAusBetreff(pszBetreff, sz, nZiel);
	if (strcmp(sz, pszSoll) != 0)
	{
		TT_Note("E-220: [%s] -> [%s], erwartet [%s]", pszBetreff ? pszBetreff : "(NULL)", sz, pszSoll);
		return false;
	}
	return true;
}

static void Test_E220_Umlaute()
{
	TT_BeginTest("E-220: Umlaute bleiben, \"|\" wird ein Leerzeichen, kein doppeltes");

	// Ein Betreff, der mit einem Umlaut beginnt, mit "|" und Apostroph
	// (erfunden, mit denselben Eigenschaften wie in Gregors Meldung).
	TT_CHECK_MSG(Gleich("\xC4rger \xFC" "ber K\xFC" "ndigung | Testmail E-220 | R\xE4tseln um Lieferant d'Or",
						"\xC4rger \xFC" "ber K\xFC" "ndigung Testmail E-220 R\xE4tseln um Lieferant d'Or"),
				 "Umlaute und Apostroph bleiben, je ein Leerzeichen statt \" | \"");
	TT_CHECK_MSG(Gleich("Gr\xFC\xDF" "e aus M\xFC" "nchen", "Gr\xFC\xDF" "e aus M\xFC" "nchen"), "sz und ue bleiben");
	TT_CHECK_MSG(Gleich("Preis 5 \x80 \x93" "billig\x94", "Preis 5 \x80 \x93" "billig\x94"), "belegte windows-1252-Zeichen bleiben");
	TT_CHECK_MSG(Gleich("a\x81" "b\x8D" "c", "a b c"), "unbelegte windows-1252-Bytes werden eine Luecke wie jedes andere entfernte Zeichen");
	TT_EndTest();
}

static void Test_E220_Luecken()
{
	TT_BeginTest("E-220: verbotene Zeichen, Punkt und Leerraum werden genau ein Leerzeichen, an den Enden keines");
	TT_CHECK_MSG(Gleich("  a   b  ", "a b"), "Leerzeichen am Anfang, in der Mitte und am Ende");
	TT_CHECK_MSG(Gleich("Re: Termin?", "Re Termin"), "Doppelpunkt und Fragezeichen");
	TT_CHECK_MSG(Gleich("a/b\\c*d\"e<f>g|h", "a b c d e f g h"), "alle von Windows verbotenen Zeichen");
	TT_CHECK_MSG(Gleich("Version 7.2.", "Version 7 2"), "Punkt - am Ende keiner, Windows wuerde ihn abschneiden");
	TT_CHECK_MSG(Gleich("x\t\r\n y", "x y"), "Steuerzeichen");
	TT_CHECK_MSG(Gleich("\xA0" "a\xA0" "b\xA0", "a b"), "geschuetztes Leerzeichen");
	TT_CHECK_MSG(Gleich("$%'-_@~`!(){}^#&+,;=[]", "$%'-_@~`!(){}^#&+,;=[]"), "die Satzzeichen von StripIllegalMT bleiben");
	TT_CHECK_MSG(Gleich(":::", ""), "nur verbotene Zeichen -> leer");
	TT_CHECK_MSG(Gleich("", ""), "leerer Betreff -> leer");
	TT_CHECK_MSG(Gleich(NULL, ""), "NULL -> leer");
	TT_EndTest();
}

static void Test_E220_Laenge()
{
	TT_BeginTest("E-220: hoechstens 120 Zeichen, kein Leerzeichen am Schnitt, Puffer nie ueberschritten");

	char	szLang[300];
	char	szSoll[200];
	memset(szLang, 'a', 200); szLang[200] = 0;
	memset(szSoll, 'a', 120); szSoll[120] = 0;
	TT_CHECK_MSG(Gleich(szLang, szSoll), "200 Zeichen -> 120");

	// 119 Zeichen, dann eine Luecke: ein Leerzeichen an Stelle 120 haette
	// nur noch das Ende gebildet.
	memset(szLang, 'b', 119); strcpy(szLang + 119, " cdef");
	memset(szSoll, 'b', 119); szSoll[119] = 0;
	TT_CHECK_MSG(Gleich(szLang, szSoll), "kein Leerzeichen am Ende nach dem Schnitt");

	TT_CHECK_MSG(Gleich("abcdefg", "abcd", 5), "Puffer von 5 Byte: 4 Zeichen und die Null");

	char	sz[8];
	memset(sz, 'X', sizeof(sz));
	UTE220_DateinameAusBetreff("abcdefghijk", sz, 4);
	TT_CHECK_MSG(sz[3] == 0 && sz[4] == 'X', "hinter dem Puffer wird nichts geschrieben");
	TT_EndTest();
}

static void Test_E220_Geraetenamen()
{
	TT_BeginTest("E-220: ein Geraetename (CON, NUL, COM1 ...) wird nicht vorgeschlagen");
	TT_CHECK_MSG(Gleich("CON", "CON_"), "CON");
	TT_CHECK_MSG(Gleich("nul", "nul_"), "nul, klein");
	TT_CHECK_MSG(Gleich(" LPT1 ", "LPT1_"), "LPT1 mit Leerzeichen");
	TT_CHECK_MSG(Gleich("CONFIG", "CONFIG"), "CONFIG ist keiner");
	TT_CHECK_MSG(Gleich("COM10", "COM10"), "COM10 ist keiner");
	TT_EndTest();
}

static void Test_E220_Stelle(const char* szEudoraDir, const char* szDatei,
							 const char* szVon, const char* szBis,
							 const char* const* aSoll, int nSoll)
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
			TT_Fail("%s: fehlt [%s] (E-220)", szDatei, aSoll[i]);
	}
	if (QT_Enthaelt(pFn, "StripIllegalMT"))
		TT_Fail("%s: %s ruft wieder StripIllegalMT (E-220: Umlaute weg)", szDatei, szVon);
	free(pFn);
	free(p);
}

static void Test_E220_Quelltext(const char* szEudoraDir)
{
	TT_BeginTest("E-220 (Quelltext): alle drei Wege bilden den Vorschlag mit E220DateinameVorschlag");

	static const char* const kToc[] = {
		"*szName = 0;",
		"pSumE220 = pSummary;",
		"szE220Kopf = pszKopfEnde ? CString( pszVollE128, (int) ( pszKopfEnde - pszVollE128 ) + 4 ) : CString( pszVollE128 );",
		"E220DateinameVorschlag( szName, sizeof( szName ), pSumE220->m_Subject, szE220Kopf.IsEmpty() ? NULL : (LPCTSTR) szE220Kopf, \"Postfachliste\" );",
	};
	Test_E220_Stelle(szEudoraDir, "tocview.cpp", "void CTocView::OnFileSaveAs()", "void CTocView::OnEditCopy()",
					 kToc, (int)(sizeof(kToc) / sizeof(kToc[0])));

	static const char* const kRead[] = {
		"char * pszVollE220 = GetFullMessage();",
		"E220DateinameVorschlag( szNameE220, sizeof( szNameE220 ), m_Sum->m_Subject, pszVollE220, \"Nachrichtenfenster\" );",
		"SA.Start(szNameE220, TRUE, NULL, FALSE, pszE128, TRUE)",
	};
	Test_E220_Stelle(szEudoraDir, "ReadMessageDoc.cpp", "void CReadMessageDoc::OnFileSaveAs()", "BOOL CReadMessageDoc::SaveAsFile(",
					 kRead, (int)(sizeof(kRead) / sizeof(kRead[0])));

	static const char* const kComp[] = {
		"const char * pszBetreffE220 = GetHeaderLine( HEADER_SUBJECT );",
		"E220DateinameVorschlag( szName, sizeof( szName ), ( pszBetreffE220 && *pszBetreffE220 ) ? pszBetreffE220 : m_Sum->m_Subject, NULL, \"Verfassen-Fenster\" );",
	};
	Test_E220_Stelle(szEudoraDir, "compmsgd.cpp", "void CCompMessageDoc::OnFileSaveAs()", "BOOL CCompMessageDoc::SaveAsFile(",
					 kComp, (int)(sizeof(kComp) / sizeof(kComp[0])));

	// CSaveAs::Start: ein fertiger Name geht NICHT durch StripIllegalMT; die
	// anderen Aufrufer (Trnslate.cpp, filtersd.cpp) behalten den alten Weg.
	char* p = QT_LiesNurCode(szEudoraDir, "saveas.cpp");
	char* pFn = p ? QT_Abschnitt(p, "BOOL CSaveAs::Start(", "BOOL CSaveAs::CreateFile(") : NULL;
	if (!pFn)
		TT_Fail("saveas.cpp: CSaveAs::Start nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		long nFertig = QT_Stelle(pFn, "if (Filename && bNameFertig) { strncpy(Name, Filename, sizeof(Name) - 1); Name[sizeof(Name) - 1] = 0; } else if (Filename)");
		long nStrip  = QT_Stelle(pFn, "::StripIllegalMT(Name, EudoraDir);");
		TT_CHECK_MSG(nFertig >= 0, "saveas.cpp: Zweig fuer den fertigen Namen fehlt");
		TT_CHECK_MSG(nStrip > nFertig, "saveas.cpp: StripIllegalMT steht nicht mehr nur im alten Zweig");
		free(pFn);
	}
	if (p) free(p);

	char* h = QT_LiesNurCode(szEudoraDir, "saveas.h");
	TT_CHECK_MSG(h && QT_Enthaelt(h, "const char* pszVorgabeendung = NULL, BOOL bNameFertig = FALSE);"),
				 "saveas.h: bNameFertig mit Vorgabe FALSE");
	if (h) free(h);

	TT_EndTest();
}

void RunE220Tests(const char* szEudoraDir)
{
	Test_E220_Umlaute();
	Test_E220_Luecken();
	Test_E220_Laenge();
	Test_E220_Geraetenamen();
	Test_E220_Quelltext(szEudoraDir);
}
