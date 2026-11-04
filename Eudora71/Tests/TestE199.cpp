//
// TestE199.cpp - Befund E-199: Festbreite im Bearbeiten-Modus schreibt "t;"
// sichtbar in den Text.
//
// WrapTag und SplitTagOff (Eudora/TridentReadMessageView.cpp) wandeln ihre
// Platzhalter-Tags mit Text2Html und schnitten danach blind zwei Zeichen ab
// ("// strip \r\n"). Text2Html haengt "\r\n" aber nur an, wenn die Zeile auf
// \r endet; der Platzhalter hat keins. Abgeschnitten wurde "t;" von "&gt;",
// die Suche fand den Platzhalter ohne diese zwei Zeichen, und "t;" blieb im
// Dokument stehen (gemessen 02.11. und 04.11.2026, Fall E-178p mit
// Wirkprobe: "<LI><TT>t;Vierbyte...", "<LI>t; <BR>"). Jetzt wird nur
// abgeschnitten, wenn der Text wirklich auf "\r\n" endet.
//
// Geprueft am Quelltext - die Wege haengen an Trident (MSHTML) und lassen
// sich ohne Programm nicht aufrufen. Das Verhalten misst der Pruefstand
// (E-178p, "E178 MUELL anzahl=0").
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E199_Abschneiden(const char* szEudoraDir)
{
	TT_BeginTest("E-199: WrapTag/SplitTagOff schneiden \"\\r\\n\" nur ab, wenn es da ist");

	char* pT = QT_LiesNurCode(szEudoraDir, "TridentReadMessageView.cpp");
	if (!pT)
	{
		TT_Fail("TridentReadMessageView.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	const char* szPruefung = ".Right(2) == \"\\r\\n\")";
	const char* szSchnitt  = ".GetLength() - 2 );";

	char* pSplit = QT_Abschnitt(pT, "BOOL CTridentReadMessageView::SplitTagOff(", "void CTridentReadMessageView::OnUpdateSize(");
	long  lWrap  = QT_Stelle(pT, "BOOL CTridentReadMessageView::WrapTag(");
	if (!pSplit || lWrap < 0)
		TT_Fail("SplitTagOff oder WrapTag nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		// SplitTagOff: vier Platzhalter (Delete-Ende, Delete-Anfang, On, Off).
		TT_CHECK_MSG(QT_Zaehle(pSplit, szSchnitt) == 4 && QT_Zaehle(pSplit, szPruefung) == 4,
					 "SplitTagOff schneidet wieder blind zwei Zeichen ab - \"t;\" bleibt im Text (E-199)");
		// WrapTag (die letzte Funktion der Datei): zwei Platzhalter (On, Off).
		const char* pWrap = pT + lWrap;
		TT_CHECK_MSG(QT_Zaehle(pWrap, szSchnitt) == 2 && QT_Zaehle(pWrap, szPruefung) == 2,
					 "WrapTag schneidet wieder blind zwei Zeichen ab - \"t;\" bleibt im Text (E-199)");
		// Jede Pruefung steht unmittelbar vor ihrem Schnitt (Kommentare sind weg,
		// Leerraum ist zusammengezogen): "if (x.Right(2) == "\r\n") x = x.Left(".
		TT_CHECK_MSG(QT_Zaehle(pT, ".Right(2) == \"\\r\\n\") szTemp") == 6,
					 "die Pruefung auf \"\\r\\n\" steht nicht unmittelbar vor dem Abschneiden (E-199)");
	}
	if (pSplit) free(pSplit);

	free(pT);
	TT_EndTest();
}

void RunE199Tests(const char* szEudoraDir)
{
	Test_E199_Abschneiden(szEudoraDir);
}
