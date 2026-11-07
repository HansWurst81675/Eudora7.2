//
// TestE169.cpp - Befund E-169: die Druckvorschau einer HTML-Mail zeigt keine
// Hintergruende - weder Farbflaechen (bgcolor, background-color) noch
// Hintergrundbilder (background, background-image).
//
// MSHTML druckt Hintergruende nur, wenn HKCU\Software\Microsoft\Internet
// Explorer\PageSetup "Print_Background" auf "yes" steht; ab Werk fehlt der
// Wert (gemessen am Pruefstand, Fall E-169p). Gregor 05.11.2026: schaltbar,
// Vorgabe aus. CTridentView::Print setzt den Wert bei PrintBackground=1 nur
// fuer diesen Druck und stellt ihn danach exakt wieder her - auch "nicht
// vorhanden" -, nach dem Muster von Kopf- und Fusszeile in derselben Funktion.
//
// Geprueft am Quelltext - der Weg haengt an MSHTML und an der Registry. Die
// Wirkung misst der Pruefstand (E-169p, E-169b).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E169_Schalter(const char* szEudoraDir)
{
	TT_BeginTest("E-169: INI-Schalter PrintBackground existiert, Vorgabe 0");

	char* pRc = QT_Lesen(szEudoraDir, "EudoraRes.rc");
	char* pRh = QT_Lesen(szEudoraDir, "resource.h");
	if (!pRc || !pRh)
		TT_Fail("EudoraRes.rc oder resource.h nicht lesbar - ungeprueft ist nicht gruen");
	else
	{
		TT_CHECK_MSG(QT_Zaehle(pRc, "IDS_INI_PRINT_BACKGROUND \"PrintBackground\\n0\"") == 1,
					 "PrintBackground fehlt in EudoraRes.rc oder hat nicht die Vorgabe 0 (Gregor: Vorgabe aus)");
		TT_CHECK_MSG(QT_Zaehle(pRh, "#define IDS_INI_PRINT_BACKGROUND") == 1,
					 "IDS_INI_PRINT_BACKGROUND fehlt in resource.h oder ist doppelt");
	}
	if (pRc) free(pRc);
	if (pRh) free(pRh);
	TT_EndTest();
}

static void Test_E169_Druck(const char* szEudoraDir)
{
	TT_BeginTest("E-169: Print setzt Print_Background nur mit dem Schalter und stellt ihn nach dem Druck wieder her");

	// Seit E-242 (07.11.2026) laufen Kopf, Fuss und Print_Background ueber
	// dieselben Helfer vor CTridentView::Print: E242Setzen merkt sich den
	// alten Wert, E242Zurueckstellen stellt ihn her (nach der Vorschau, beim
	// Druck nach 10 s ohne Dialog, spaetestens beim naechsten Druck/Beenden).
	char* pT = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	char* pP = pT ? QT_Abschnitt(pT, "BOOL CTridentView::Print(", "void CTridentView::SetFont(") : 0;
	char* pH = pT ? QT_Abschnitt(pT, "static void E242Setzen(", "BOOL CTridentView::Print(") : 0;
	if (!pP || !pH)
	{
		TT_Fail("CTridentView::Print oder die E242-Helfer nicht gefunden - ungeprueft ist nicht gruen");
		if (pP) free(pP);
		if (pH) free(pH);
		if (pT) free(pT);
		TT_EndTest();
		return;
	}

	const long lSchalter = QT_Stelle(pP, "if (GetIniShort(IDS_INI_PRINT_BACKGROUND))");
	const long lSetzen   = QT_Stelle(pP, "E242Setzen(hkIEPageSetup, \"Print_Background\", \"yes\", s_E242.Hintergrund);");
	const long lDruck    = QT_Stelle(pP, "ExecCommandOnNullSet( uCmd, NULL, NULL, bDialog );");
	const long lUhr      = QT_Stelle(pP, "s_E242.uUhr = ::SetTimer(NULL, 0, 250, E242Uhr);");

	TT_CHECK_MSG(QT_Zaehle(pP, "GetIniShort(IDS_INI_PRINT_BACKGROUND)") == 1,
				 "Print fragt PrintBackground nicht (genau einmal) ab");
	TT_CHECK_MSG(lSchalter >= 0 && lSetzen > lSchalter && lSetzen < lDruck,
				 "Print_Background=yes wird nicht hinter dem Schalter und vor dem Druck gesetzt (E-169)");
	TT_CHECK_MSG(QT_Zaehle(pP, "\"yes\"") == 1,
				 "Print_Background wird an mehr als einer Stelle auf yes gesetzt");
	TT_CHECK_MSG(lUhr > lDruck && QT_Enthaelt(pP, "E242Zurueckstellen(\"ohne Zeitgeber\");"),
				 "nach dem Druck wird die Rueckstellung weder angestossen noch ersatzweise sofort ausgefuehrt (E-169/E-242)");
	TT_CHECK_MSG(QT_Enthaelt(pH, "E242Herstellen(hk, s_E242.Hintergrund);"),
				 "E242Zurueckstellen stellt Print_Background nicht wieder her (E-169)");
	TT_CHECK_MSG(QT_Enthaelt(pH, "RegSetValueEx(hk, w.strName, NULL, w.dwTyp, w.abAlt, w.dwLaenge)") &&
				 QT_Enthaelt(pH, "RegDeleteValue(hk, w.strName)"),
				 "E242Herstellen stellt den alten Wert bzw. \"nicht vorhanden\" nicht her (E-169)");
	// Ein Wert, der nicht in den Puffer passt, darf nicht angefasst werden -
	// sonst stuende danach ein abgeschnittener oder gar kein Wert da.
	TT_CHECK_MSG(QT_Enthaelt(pH, "if (l != ERROR_SUCCESS && l != ERROR_FILE_NOT_FOUND)"),
				 "E242Setzen setzt einen Wert auch, wenn der alte nicht gelesen werden konnte");

	free(pH);
	free(pP);
	free(pT);
	TT_EndTest();
}

// BEFUND E-242 (07.11.2026): Druck und Druckvorschau trugen MSHTMLs Kopf- und
// Fusszeile - unten den Pfad der Zwischendatei mit dem Windows-Anmeldenamen.
// Zwei Ursachen, beide am Pruefstand gemessen: die Werte wurden nur gesetzt,
// wenn sie schon in der Registry standen, und sofort nach Exec wieder
// hergestellt, waehrend die Vorschau sie erst danach liest. Die Wirkung misst
// der Pruefstand (E-242p, E-242r) - hier steht die Form am Quelltext fest.
static void Test_E242_KopfFuss(const char* szEudoraDir)
{
	TT_BeginTest("E-242: Kopf- und Fusszeile auch ohne vorhandenen Registrywert, Rueckstellung erst nach der Vorschau");

	char* pT = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	char* pP = pT ? QT_Abschnitt(pT, "BOOL CTridentView::Print(", "void CTridentView::SetFont(") : 0;
	char* pH = pT ? QT_Abschnitt(pT, "static void E242Setzen(", "BOOL CTridentView::Print(") : 0;
	char* pE = QT_LiesNurCode(szEudoraDir, "eudora.cpp");
	char* pX = pE ? QT_Abschnitt(pE, "int CEudoraApp::ExitInstance()", "return (CWinApp::ExitInstance());") : 0;
	if (!pP || !pH || !pX)
		TT_Fail("CTridentView::Print, die E242-Helfer oder CEudoraApp::ExitInstance nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		const long lAlt   = QT_Stelle(pP, "E242Zurueckstellen(\"neuer Druck\");");
		const long lKopf  = QT_Stelle(pP, "E242Setzen(hkIEPageSetup, HeaderValueName, Title, s_E242.Kopf);");
		const long lFuss  = QT_Stelle(pP, "E242Setzen(hkIEPageSetup, FooterValueName, NewFooter, s_E242.Fuss);");
		const long lDruck = QT_Stelle(pP, "ExecCommandOnNullSet( uCmd, NULL, NULL, bDialog );");

		TT_CHECK_MSG(lAlt >= 0 && lKopf > lAlt && lFuss > lAlt,
					 "eine noch offene Rueckstellung wird nicht vor dem Setzen erledigt - der eigene Wert gaelte sonst als \"alt\"");
		TT_CHECK_MSG(lKopf >= 0 && lFuss >= 0 && lKopf < lDruck && lFuss < lDruck,
					 "Kopf- und Fusszeile werden nicht vor dem Druckbefehl gesetzt");
		// Die alte Form setzte nur, wenn RegQueryValueEx Erfolg hatte - ab
		// Werk fehlen die Werte, dann kam nichts an.
		TT_CHECK_MSG(!QT_Enthaelt(pP, "if (RegQueryValueEx(hkIEPageSetup, HeaderValueName"),
					 "Print setzt die Kopfzeile wieder nur, wenn sie schon in der Registry steht");
		TT_CHECK_MSG(QT_Enthaelt(pH, "E242Herstellen(hk, s_E242.Kopf);") && QT_Enthaelt(pH, "E242Herstellen(hk, s_E242.Fuss);"),
					 "E242Zurueckstellen stellt Kopf- oder Fusszeile nicht wieder her");
		TT_CHECK_MSG(QT_Enthaelt(pH, "\"Internet Explorer_TridentDlgFrame\"") &&
					 QT_Enthaelt(pH, "E242Zurueckstellen(\"Vorschau geschlossen\");"),
					 "die Rueckstellung wartet nicht auf das Schliessen des Vorschaufensters");
		TT_CHECK_MSG(QT_Enthaelt(pX, "E242Zurueckstellen(\"Beenden\");"),
					 "ExitInstance stellt eine beim Beenden noch offene Rueckstellung nicht her");
	}
	if (pX) free(pX);
	if (pE) free(pE);
	if (pH) free(pH);
	if (pP) free(pP);
	if (pT) free(pT);
	TT_EndTest();
}

void RunE169Tests(const char* szEudoraDir)
{
	Test_E169_Schalter(szEudoraDir);
	Test_E169_Druck(szEudoraDir);
	Test_E242_KopfFuss(szEudoraDir);
}
