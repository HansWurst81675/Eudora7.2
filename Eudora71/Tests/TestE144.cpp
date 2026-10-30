//
// TestE144.cpp - Regressionstest zu Befund E-144 (Quelltext)
//
// Ein Antwortentwurf, den man aus einem anderen Postfach nach Out
// zurueckschiebt, wird ueber CSummary::SendAgain(FALSE) neu angelegt. Dabei
// gingen In-Reply-To und References verloren (von Gregor am 23.10.2026 an
// Paket 1.0.122 bestaetigt). Die Behebung uebernimmt beide Kopfzeilen nur auf
// diesem Weg (DisplayIt FALSE); "Send Again" aus dem Menue bleibt wie im
// Original.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE144Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-144 (Quelltext): ein nach Out zurueckgeschobener Antwortentwurf behaelt In-Reply-To und References");
	char* pText = QT_LiesNurCode(szEudoraDir, "summary.cpp");
	if (!pText)
	{
		TT_Fail("summary.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "CCompMessageDoc* CSummary::SendAgain ( BOOL DisplayIt", "else { BOOL gotReject = FALSE;");
	TT_CHECK_MSG(pFn != NULL, "CSummary::SendAgain (Zweig IsComp) nicht gefunden - der Test passt nicht mehr zur Stelle");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if (!DisplayIt) { NewDoc->SetHeaderLine(HEADER_IN_REPLY_TO, CompDoc->GetHeaderLine(HEADER_IN_REPLY_TO)); NewDoc->SetHeaderLine(HEADER_REFERENCES, CompDoc->GetHeaderLine(HEADER_REFERENCES)); }"),
					 "SendAgain uebernimmt beim Zurueckschieben nach Out In-Reply-To und References nicht mehr (E-144)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}
