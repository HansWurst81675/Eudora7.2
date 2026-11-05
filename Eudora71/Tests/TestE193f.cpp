//
// TestE193f.cpp - Befund E-193, Rest nach Gregors Test an 7.2.2.133: Edit ->
// Find meldet "not found" fuer ein sichtbares Wort, wenn die Mail aus dem
// Ergebnis von Find Messages geoeffnet wurde.
//
// Das Oeffnen aus Find Messages markiert den Treffer schon (SearchView.cpp,
// DoFindFirst) und setzt in CTridentView ein Lesezeichen dahinter.
// CTridentView::DoFindNext (TridentView.cpp) suchte nur ab diesem
// Lesezeichen; stand das Wort nur einmal in der Mail, kam "not found"
// (gemessen 05.11.2026, Pruefstand C:\Temp\E193f, Bau 7.2.2.134: Runde
// suchweg-ohne f1..f12 alle 0, nur f14 mit dem Wort zweimal 1). Gregor
// 05.11.2026, Variante A: dann einmal von oben suchen, markieren und dorthin
// scrollen - DoFindFirst tut genau das.
//
// Geprueft am Quelltext; das Verhalten misst der Pruefstand (E-193fs).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E193f_UmbruchNachOben(const char* szEudoraDir)
{
	TT_BeginTest("E-193 Rest: DoFindNext sucht einmal von oben, wenn ab dem Lesezeichen nichts mehr kommt");

	char* pT = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	if (!pT)
	{
		TT_Fail("TridentView.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pF = QT_Abschnitt(pT, "BOOL CTridentView::DoFindNext(", "long CTridentView::FixupSource(");
	if (!pF)
		TT_Fail("DoFindNext nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		const char* szUmbruch = "return DoFindFirst( szSearch, bMatchCase, bWholeWord, bSelect );";
		// Drei Stellen: ohne Lesezeichen (Original), Lesezeichen ungueltig,
		// ab dem Lesezeichen nichts gefunden.
		TT_CHECK_MSG(QT_Zaehle(pF, szUmbruch) == 3,
					 "DoFindNext springt nicht in allen drei Faellen auf DoFindFirst - Edit -> Find meldet \"not found\" nach Oeffnen aus Find Messages (E-193)");
		TT_CHECK_MSG(QT_Enthaelt(pF, "if( !bReturn ) { return DoFindFirst( szSearch, bMatchCase, bWholeWord, bSelect ); } return bReturn; }"),
					 "nach erfolgloser Suche ab dem Lesezeichen wird nicht von oben gesucht (E-193)");
		TT_CHECK_MSG(QT_Enthaelt(pF, "pNextRange->Release(); return DoFindFirst( szSearch, bMatchCase, bWholeWord, bSelect ); }"),
					 "ein ungueltiges Lesezeichen endet weiter in \"not found\" statt in der Suche von oben (E-193)");
		free(pF);
	}

	// Kein Kreis: DoFindFirst darf DoFindNext nicht rufen, sonst liefe der
	// Umbruch endlos, wenn das Wort fehlt.
	char* pE = QT_Abschnitt(pT, "BOOL CTridentView::DoFindFirst(", "BOOL CTridentView::DoFindNext(");
	if (!pE)
		TT_Fail("DoFindFirst nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		TT_CHECK_MSG(QT_Zaehle(pE, "DoFindNext") == 1,
					 "DoFindFirst ruft DoFindNext - mit dem Umbruch aus E-193 ein Kreis");
		free(pE);
	}

	free(pT);
	TT_EndTest();
}

void RunE193fTests(const char* szEudoraDir)
{
	Test_E193f_UmbruchNachOben(szEudoraDir);
}
