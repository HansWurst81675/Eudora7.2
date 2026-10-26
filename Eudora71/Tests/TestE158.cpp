//
// TestE158.cpp - Regressionstest zu Befund E-158
//
// Gregor am Testpaket 7.2.0.123 (26.10.2026): beim Weiterleiten einer
// TEXTmail stand am Ende der Nachricht sichtbar "</x-html>". Gemessen an der
// angekommenen Nachricht: der Rumpf trug eine doppelte <x-html>-Huelle.
// QuoteText baut seit E-87 auch fuer Textmails einen HTML-Rumpf mit
// doppelter Huelle; der Editor schluckt die innere, das von E-88
// aufgehobene Original nicht - und E-88 schickte dieses Original
// unveraendert hinaus ("E-88 vor dem Absenden: Fassung=ORIGINAL
// (unveraendert) ... OrigBytes=845").
//
// E-88 ist fuer HTML-Mails gedacht. Seitdem zaehlt in
// CSummary::ComposeMessage auch, ob die Ausgangsnachricht HTML ist.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE158Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-158: Weiterleiten einer Textmail haengt kein </x-html> an (E-88 nur bei HTML-Mails)");
	char* pCode = QT_LiesNurCode(szEudoraDir, "summary.cpp");
	if (!pCode) { TT_Fail("summary.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	QT_LeerraumZusammen(pCode);
	TT_CHECK_MSG(QT_Enthaelt(pCode, "const bool bE88Merken = ( !pszStationery && Body && GetIniShort(IDS_INI_FORWARD_ORIGINAL_HTML) && IsHTML() && (::IsFancy(Body) == IS_HTML) );"),
				 "E-88 merkt das Original wieder auch bei Textmails - deren Rumpf traegt eine doppelte <x-html>-Huelle");
	free(pCode);
	TT_EndTest();
}
