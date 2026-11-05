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

	char* pT = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	char* pP = pT ? QT_Abschnitt(pT, "BOOL CTridentView::Print(", "void CTridentView::SetFont(") : 0;
	if (!pP)
	{
		TT_Fail("CTridentView::Print nicht gefunden - ungeprueft ist nicht gruen");
		if (pT) free(pT);
		TT_EndTest();
		return;
	}

	const long lSchalter = QT_Stelle(pP, "if (GetIniShort(IDS_INI_PRINT_BACKGROUND))");
	const long lSetzen   = QT_Stelle(pP, "RegSetValueEx(hkIEPageSetup, \"Print_Background\", NULL, REG_SZ, (LPBYTE)\"yes\", 4)");
	const long lDruck    = QT_Stelle(pP, "ExecCommandOnNullSet( uCmd, NULL, NULL, bDialog );");
	const long lZurueck  = QT_Stelle(pP, "if (bSetBackground && RegOpenKeyEx(");
	const long lAlt      = QT_Stelle(pP, "RegSetValueEx(hkIEPageSetup, \"Print_Background\", NULL, BackgroundValueType, OldBackground, OldBackgroundLen)");
	const long lLoeschen = QT_Stelle(pP, "RegDeleteValue(hkIEPageSetup, \"Print_Background\")");

	TT_CHECK_MSG(QT_Zaehle(pP, "GetIniShort(IDS_INI_PRINT_BACKGROUND)") == 1,
				 "Print fragt PrintBackground nicht (genau einmal) ab");
	TT_CHECK_MSG(lSchalter >= 0 && lSetzen > lSchalter && lSetzen < lDruck,
				 "Print_Background=yes wird nicht hinter dem Schalter und vor dem Druck gesetzt (E-169)");
	TT_CHECK_MSG(QT_Zaehle(pP, "(LPBYTE)\"yes\"") == 1,
				 "Print_Background wird an mehr als einer Stelle auf yes gesetzt");
	TT_CHECK_MSG(lZurueck > lDruck && lAlt > lZurueck && lLoeschen > lZurueck,
				 "Print_Background wird nach dem Druck nicht wiederhergestellt - alter Wert bzw. Loeschen fehlt (E-169)");
	// Ein Wert, der nicht in den Puffer passt, darf nicht angefasst werden -
	// sonst stuende danach ein abgeschnittener oder gar kein Wert da.
	TT_CHECK_MSG(QT_Enthaelt(pP, "if (lAbfrage == ERROR_SUCCESS || lAbfrage == ERROR_FILE_NOT_FOUND)"),
				 "Print setzt Print_Background auch, wenn der alte Wert nicht gelesen werden konnte");

	free(pP);
	free(pT);
	TT_EndTest();
}

void RunE169Tests(const char* szEudoraDir)
{
	Test_E169_Schalter(szEudoraDir);
	Test_E169_Druck(szEudoraDir);
}
