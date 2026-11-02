// TestE133.cpp - Regressionstest zu Befund E-133 (Quelltext).
//
// Zeigte HKCU\Software\Qualcomm\Eudora\CommandLine\Current auf ein
// Mailverzeichnis, das es nicht mehr gibt, beendete sich Eudora beim
// Doppelklick mit zwei Fehlermeldungen: StartEudoraWithDefaultLocation gab
// das Verzeichnis ungeprueft an GetDirs, CheckMailDirectory scheiterte an
// FileExistsMT (fileutil.cpp:374), InitInstance gab FALSE zurueck.
//
// Behebung (02.11.2026): VOR GetDirs prueft E133VerzeichnisFehlt das
// Verzeichnis; fehlt es, fragt Eudora - anderen Ordner waehlen
// (SHBrowseForFolder), den Ordner neben dem Programm nehmen, oder abbrechen -
// und schreibt nach der Wahl mit RegisterCommandLine den neuen Ort zurueck.
//
// Gemessen am laufenden Programm wird es im Pruefstand (Fall E-133p,
// tools/messen-e133.ps1). Hier steht nur, dass die Stelle nicht still
// wieder verschwindet.
//
// Gegenprobe beim Bau: EudoraTests.exe gegen den Quellstand vor der Behebung
// (origin/main 456c95e1) -> rot.

#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E133_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-133 (Quelltext): fehlt das gespeicherte Mailverzeichnis, fragt Eudora statt sich zu beenden");
	char* pText = QT_LiesNurCode(szEudoraDir, "eudora.cpp");
	if (!pText)
	{
		TT_Fail("eudora.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pFn = QT_Abschnitt(pText, "BOOL CEudoraApp::StartEudoraWithDefaultLocation()",
								   "BOOL CEudoraApp::ProcessAttachmentWEI(");
	TT_CHECK_MSG(pFn != NULL, "CEudoraApp::StartEudoraWithDefaultLocation nicht gefunden");
	if (pFn)
	{
		// Die Pruefung muss VOR GetDirs stehen - danach ist Eudora schon
		// mit zwei Fehlermeldungen ausgestiegen.
		const long lPruefung = QT_Stelle(pFn, "if (!bFremd && E133VerzeichnisFehlt(szVerzeichnis))");
		const long lGetDirs  = QT_Stelle(pFn, "if (err || !GetDirs(buf))");
		TT_CHECK_MSG(lPruefung >= 0, "StartEudoraWithDefaultLocation prueft nicht mehr, ob das Verzeichnis aus der Registry existiert (E-133)");
		TT_CHECK_MSG(lGetDirs >= 0, "der Aufruf GetDirs(buf) ist nicht mehr da - Test anpassen");
		TT_CHECK_MSG(lPruefung < 0 || lGetDirs < 0 || lPruefung < lGetDirs,
			"die E-133-Pruefung steht HINTER GetDirs - dann kommt sie zu spaet");

		char* pFrage = QT_Abschnitt(pFn, "if (!bFremd && E133VerzeichnisFehlt(szVerzeichnis))",
										 "if (err || !GetDirs(buf))");
		TT_CHECK_MSG(pFrage != NULL, "der E-133-Block vor GetDirs ist nicht abzugrenzen");
		if (pFrage)
		{
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "does not exist any more"), "die Rueckfrage nennt nicht mehr, dass das Verzeichnis fehlt (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "MB_YESNOCANCEL | MB_ICONWARNING | MB_DEFBUTTON2"), "die Rueckfrage hat nicht mehr drei Antworten mit \"No\" als Vorgabe (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "if (E133OrdnerWaehlen(szGewaehlt))"), "\"Yes\" oeffnet keine Ordnerauswahl mehr (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "szGewaehlt = szNeben;"), "\"No\" nimmt nicht mehr den Ordner neben dem Programm (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "E133InBefehlszeile(szGewaehlt, buf,"), "die Wahl kommt nicht mehr in buf an - GetDirs nimmt dann wieder das fehlende Verzeichnis (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "bE133Gewaehlt = true;"), "die Wahl wird nicht mehr vermerkt - dann wird die Registry nicht berichtigt (E-133)");
			TT_CHECK_MSG(QT_Zaehle(pFrage, "return FALSE;") == 1, "der E-133-Block hat nicht genau einen Ausstieg (Abbrechen) - Test anpassen");
			free(pFrage);
		}

		char* pDanach = QT_Abschnitt(pFn, "if (err || !GetDirs(buf))", "MailDirHerkunft = pHerkunft;");
		TT_CHECK_MSG(pDanach != NULL, "der Teil hinter GetDirs ist nicht abzugrenzen");
		if (pDanach)
		{
			TT_CHECK_MSG(QT_Enthaelt(pDanach, "if (bE133Gewaehlt)"), "nach der Wahl wird nichts mehr getan (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pDanach, "RegisterCommandLine(NULL);"), "die Registry wird nach der Wahl nicht mehr berichtigt - dann fragt Eudora bei jedem Start mit Anhang wieder (E-133)");
			free(pDanach);
		}
		free(pFn);
	}

	char* pPruef = QT_Abschnitt(pText, "static bool E133VerzeichnisFehlt(", "static CString E133NebenProgramm(");
	TT_CHECK_MSG(pPruef != NULL, "E133VerzeichnisFehlt nicht gefunden");
	if (pPruef)
	{
		TT_CHECK_MSG(QT_Enthaelt(pPruef, "return !FileExistsMT(szPfad);"), "E133VerzeichnisFehlt fragt nicht mehr das Dateisystem (E-133)");
		free(pPruef);
	}

	char* pWahl = QT_Abschnitt(pText, "static bool E133OrdnerWaehlen(", "static void E133InBefehlszeile(");
	TT_CHECK_MSG(pWahl != NULL, "E133OrdnerWaehlen nicht gefunden");
	if (pWahl)
	{
		TT_CHECK_MSG(QT_Enthaelt(pWahl, "::SHBrowseForFolder(&bi)"), "E133OrdnerWaehlen zeigt keine Ordnerauswahl mehr (E-133)");
		TT_CHECK_MSG(QT_Enthaelt(pWahl, "BIF_RETURNONLYFSDIRS"), "die Ordnerauswahl laesst Nicht-Dateisystem-Ziele zu (E-133)");
		TT_CHECK_MSG(QT_Enthaelt(pWahl, "::CoTaskMemFree(pidl);"), "die Ordnerauswahl gibt ihre ITEMIDLIST nicht mehr frei");
		free(pWahl);
	}

	free(pText);
	TT_EndTest();
}

void RunE133Tests(const char* szEudoraDir)
{
	Test_E133_Stelle(szEudoraDir);
}
