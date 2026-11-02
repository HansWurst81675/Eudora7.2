// TestE133.cpp - Regressionstests zu Befund E-133 und E-209.
//
// E-133: Zeigte HKCU\Software\Qualcomm\Eudora\CommandLine\Current auf ein
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
// PRUEFER-87 K5: der erste Stand dieses Tests blieb gruen, wenn Yes und No
// vertauscht, die Klammer in E133InBefehlszeile entfernt, der Ordnername
// geaendert oder die Registryberichtigung durch ein zweites
// "bE133Gewaehlt = false;" unterdrueckt war. Jetzt: Zuordnung je Zweig,
// Ordnername, Zahl der Zuweisungen am Quelltext; die Klammer als echter
// Aufruf von E133InBefehlszeile mit Rueckweg durch E132AufrufZerlegen.
//
// E-209 (PRUEFER-87 K3): RegisterCommandLine schrieb die Befehlszeile
// ungeklammert. Mit Leerzeichen im Pfad (Laufwerk ohne 8.3-Kurznamen) trennte
// der naechste Start mitten im Pfad. E209BefehlszeileBauen klammert, was ein
// Leerzeichen enthaelt; geprueft als echter Aufruf mit Rueckweg.
//
// Gemessen am laufenden Programm wird E-133 im Pruefstand (Faelle
// E-133p/E-133q, tools/messen-e133.ps1).

#include <afx.h>
#include <string.h>
#include <tchar.h>

#include "TinyTest.h"
#include "Quelltext.h"
#include "UnderTestE132.h"

// Die echten Funktionen aus eudora.cpp, von Extract.ps1 geschnitten.
#include "generated/eudora_e209.inc"
#include "generated/eudora_e133_klammer.inc"

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

		// PRUEFER-87 K5 (G4): genau zwei Zuweisungen - die Vorbelegung mit
		// false und das true hinter der Wahl. Eine dritte kann die
		// Registryberichtigung still abschalten.
		TT_CHECK_MSG(QT_Zaehle(pFn, "bE133Gewaehlt =") == 2,
			"bE133Gewaehlt wird nicht genau zweimal gesetzt (Vorbelegung, Wahl) - eine weitere Zuweisung kann die Registryberichtigung abschalten (E-133, PRUEFER-87 K5)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "bool bE133Gewaehlt = false;"), "bE133Gewaehlt ist nicht mehr mit false vorbelegt (E-133)");

		char* pFrage = QT_Abschnitt(pFn, "if (!bFremd && E133VerzeichnisFehlt(szVerzeichnis))",
										 "if (err || !GetDirs(buf))");
		TT_CHECK_MSG(pFrage != NULL, "der E-133-Block vor GetDirs ist nicht abzugrenzen");
		if (pFrage)
		{
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "does not exist any more"), "die Rueckfrage nennt nicht mehr, dass das Verzeichnis fehlt (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "Yes\\tchoose another mail folder"), "der Text ordnet \"Yes\" nicht mehr der Ordnerauswahl zu (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "No\\tuse the folder next to this program"), "der Text ordnet \"No\" nicht mehr dem Ordner neben dem Programm zu (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "MB_YESNOCANCEL | MB_ICONWARNING | MB_DEFBUTTON2"), "die Rueckfrage hat nicht mehr drei Antworten mit \"No\" als Vorgabe (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "E133InBefehlszeile(szGewaehlt, buf,"), "die Wahl kommt nicht mehr in buf an - GetDirs nimmt dann wieder das fehlende Verzeichnis (E-133)");
			TT_CHECK_MSG(QT_Enthaelt(pFrage, "bE133Gewaehlt = true;"), "die Wahl wird nicht mehr vermerkt - dann wird die Registry nicht berichtigt (E-133)");
			TT_CHECK_MSG(QT_Zaehle(pFrage, "return FALSE;") == 1, "der E-133-Block hat nicht genau einen Ausstieg (Abbrechen) - Test anpassen");

			// PRUEFER-87 K5 (G1): was hinter IDYES steht, muss die
			// Ordnerauswahl sein, was hinter IDNO steht, der Ordner neben dem
			// Programm. Nur das Vorkommen zu pruefen liess die Vertauschung durch.
			char* pJa = QT_Abschnitt(pFrage, "if (nWahl == IDYES)", "if (nWahl == IDNO)");
			TT_CHECK_MSG(pJa != NULL, "die Zweige \"if (nWahl == IDYES)\" und danach \"if (nWahl == IDNO)\" sind nicht mehr da - vertauscht? (E-133, PRUEFER-87 K5)");
			if (pJa)
			{
				TT_CHECK_MSG(QT_Enthaelt(pJa, "if (E133OrdnerWaehlen(szGewaehlt))"), "\"Yes\" oeffnet keine Ordnerauswahl mehr (E-133, PRUEFER-87 K5)");
				TT_CHECK_MSG(!QT_Enthaelt(pJa, "szGewaehlt = szNeben;"), "\"Yes\" nimmt den Ordner neben dem Programm (E-133, PRUEFER-87 K5)");
				free(pJa);
			}
			char* pNein = QT_Abschnitt(pFrage, "if (nWahl == IDNO)", "E132SpurMerken(\"E-133 Antwort: abgebrochen\");");
			TT_CHECK_MSG(pNein != NULL, "der Zweig \"if (nWahl == IDNO)\" vor dem Abbruch ist nicht abzugrenzen (E-133)");
			if (pNein)
			{
				TT_CHECK_MSG(QT_Enthaelt(pNein, "szGewaehlt = szNeben;"), "\"No\" nimmt nicht mehr den Ordner neben dem Programm (E-133, PRUEFER-87 K5)");
				TT_CHECK_MSG(!QT_Enthaelt(pNein, "E133OrdnerWaehlen("), "\"No\" oeffnet die Ordnerauswahl (E-133, PRUEFER-87 K5)");
				free(pNein);
			}
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

		// E-209: der Leser der Registryzeile muss ein geklammertes Programm
		// ueberspringen koennen - sonst nuetzt die Klammer beim Schreiben nichts.
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if (*cmdLine == '\"')") && QT_Enthaelt(pFn, "c = strchr(cmdLine + 1, '\"');"),
			"StartEudoraWithDefaultLocation ueberspringt kein geklammertes Programm mehr - dann passt E209BefehlszeileBauen nicht mehr zum Leser (E-209)");

		// PRUEFER-87 N1: der Leser muss so viel aufnehmen, wie
		// RegisterCommandLine schreibt (val), und nach einer gescheiterten
		// ersten Abfrage buflen neu setzen - sonst meldet die HKCR-Abfrage
		// die NOETIGE Laenge aus ERROR_MORE_DATA als Puffergroesse.
		TT_CHECK_MSG(QT_Enthaelt(pFn, "TCHAR cmdLine[3 * MAX_PATH + 10];"), "cmdLine ist kleiner als die Zeile, die RegisterCommandLine schreibt (E-209, PRUEFER-87 N1)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "TCHAR buf[3 * MAX_PATH + 10];"), "buf ist kleiner als cmdLine - strcpy(buf, c) kopiert den Rest von cmdLine (PRUEFER-87 N1)");
		{
			const long lVorbelegt = QT_Stelle(pFn, "cmdLine[0] = 0;");
			const long lErste     = QT_Stelle(pFn, "RegQueryValueEx(hkResult,buf, NULL, &dwType, (unsigned char*)cmdLine, &buflen);");
			// gesucht HINTER der ersten Abfrage - vor ihr steht dieselbe
			// Zuweisung in der Deklaration von buflen
			const char* pNach     = (lErste >= 0) ? pFn + lErste : pFn;
			const long lNeu       = QT_Stelle(pNach, "buflen = sizeof(cmdLine) - sizeof(TCHAR);");
			const long lZweite    = QT_Stelle(pNach, "RegQueryValueEx(hkResult,NULL, NULL, &dwType, (unsigned char*)cmdLine, &buflen);");
			TT_CHECK_MSG(lVorbelegt >= 0 && lErste >= 0 && lVorbelegt < lErste, "cmdLine ist vor der ersten Registryabfrage nicht vorbelegt - ohne Wert wird Stapelinhalt gelesen (E-208, PRUEFER-87 N1)");
			TT_CHECK_MSG(lErste >= 0 && lNeu >= 0 && lZweite >= 0 && lNeu < lZweite,
				"buflen wird zwischen den beiden Registryabfragen nicht neu gesetzt - nach ERROR_MORE_DATA darf die zweite ueber cmdLine hinaus schreiben (PRUEFER-87 N1)");
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

	// PRUEFER-87 K5 (G2): der Ordner neben dem Programm heisst in unseren
	// Paketen "Mailverzeichnis" (tools/paket-bauen.ps1).
	char* pNeben = QT_Abschnitt(pText, "static CString E133NebenProgramm(", "static bool E133OrdnerWaehlen(");
	TT_CHECK_MSG(pNeben != NULL, "E133NebenProgramm nicht gefunden");
	if (pNeben)
	{
		TT_CHECK_MSG(QT_Enthaelt(pNeben, "szUnter += \"\\\\Mailverzeichnis\";"), "E133NebenProgramm sucht nicht mehr \"Mailverzeichnis\" neben der EXE - so heisst der Ordner in unseren Paketen (E-133, PRUEFER-87 K5)");
		TT_CHECK_MSG(QT_Enthaelt(pNeben, "CRString(IDS_EUDORA_INI_NAME)"), "E133NebenProgramm prueft nicht mehr auf eine Eudora.ini im Mailverzeichnis (E-133)");
		free(pNeben);
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

	// E-209: RegisterCommandLine baut die Zeile ueber E209BefehlszeileBauen.
	char* pReg = QT_Abschnitt(pText, "BOOL CEudoraApp::RegisterCommandLine(", "return ( (BOOL)err );");
	TT_CHECK_MSG(pReg != NULL, "CEudoraApp::RegisterCommandLine nicht gefunden");
	if (pReg)
	{
		TT_CHECK_MSG(QT_Enthaelt(pReg, "E209BefehlszeileBauen(app, eDir, iniPath, val, sizeof(val));"), "RegisterCommandLine baut die Registryzeile nicht mehr ueber E209BefehlszeileBauen - Pfade mit Leerzeichen kommen ungeklammert hinein (E-209)");
		TT_CHECK_MSG(!QT_Enthaelt(pReg, "sprintf(val"), "RegisterCommandLine schreibt die Zeile wieder mit sprintf, ungeklammert (E-209)");
		free(pReg);
	}

	free(pText);
	TT_EndTest();
}

// PRUEFER-87 K5 (G3): E133InBefehlszeile echt aufrufen. Ein Ordner mit
// Leerzeichen muss nach GetDirs' Trennregel (E132AufrufZerlegen) als EIN
// Pfad zurueckkommen.
static void Test_E133_Klammer(void)
{
	TT_BeginTest("E-133: der gewaehlte Ordner mit Leerzeichen kommt als EIN Pfad bei GetDirs an");
	{
		const CString szOrdner("C:\\Program Files\\Eudora 7\\Mailverzeichnis");
		TCHAR buf[MAX_PATH + 1];
		E133InBefehlszeile(szOrdner, buf, sizeof(buf) / sizeof(TCHAR));
		TT_CHECK_MSG(_tcscmp(buf, _T("\"C:\\Program Files\\Eudora 7\\Mailverzeichnis\"")) == 0,
			"E133InBefehlszeile klammert den gewaehlten Ordner nicht mehr (E-133, PRUEFER-87 K5)");

		TCHAR szDir[MAX_PATH + 1], szIni[MAX_PATH + 1];
		E132AufrufZerlegen(buf, szDir, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(_tcscmp(szDir, szOrdner) == 0, "nach der Trennung wie in GetDirs ist der Ordner nicht mehr ganz (E-133)");
		TT_CHECK_MSG(szIni[0] == 0, "nach der Trennung bleibt ein Rest als INI-Pfad - der Ordner wurde zerteilt (E-133)");
	}
	TT_EndTest();
}

// Wie StartEudoraWithDefaultLocation das Programm abschneidet (eudora.cpp,
// "if (*cmdLine == '\"')"). Der Quelltexttest oben haelt fest, dass die
// Stelle noch so aussieht.
static void E209ProgrammAbschneiden(LPCTSTR pZeile, LPTSTR pRest, size_t nRest)
{
	pRest[0] = 0;
	LPCTSTR c = (*pZeile == '"') ? _tcschr(pZeile + 1, '"') : _tcschr(pZeile, ' ');
	if (!c)
		return;
	c++;
	while (*c == ' ')
		c++;
	_tcsncpy(pRest, c, nRest - 1);
	pRest[nRest - 1] = 0;
}

static void Test_E209(void)
{
	TT_BeginTest("E-209: ohne Leerzeichen bleibt die Registryzeile Byte fuer Byte wie vorher");
	{
		TCHAR z[3 * MAX_PATH + 10];
		E209BefehlszeileBauen(_T("C:\\EUDORA~1\\Eudora.exe"), _T("C:\\EUDORA~1\\MAILVE~1"),
							  _T("C:\\EUDORA~1\\MAILVE~1\\Eudora.ini"), z, sizeof(z) / sizeof(TCHAR));
		TT_CHECK_MSG(_tcscmp(z, _T("C:\\EUDORA~1\\Eudora.exe C:\\EUDORA~1\\MAILVE~1 C:\\EUDORA~1\\MAILVE~1\\Eudora.ini")) == 0,
			"ohne Leerzeichen weicht die Zeile vom alten \"%s %s %s\" ab - fremde Leser (Hermes, EudoraBk, MAPI) bekaemen etwas Neues");

		E209BefehlszeileBauen(_T("A.exe"), _T("C:\\M"), _T(""), z, sizeof(z) / sizeof(TCHAR));
		TT_CHECK_MSG(_tcscmp(z, _T("A.exe C:\\M ")) == 0, "ohne INI-Pfad weicht die Zeile vom alten \"%s %s %s\" ab");
	}
	TT_EndTest();

	TT_BeginTest("E-209: mit Leerzeichen geklammert, und der Leser bekommt Verzeichnis und INI ganz zurueck");
	{
		TCHAR z[3 * MAX_PATH + 10];
		E209BefehlszeileBauen(_T("C:\\Program Files\\Eudora\\Eudora.exe"), _T("D:\\Mail Daten"),
							  _T("D:\\Mail Daten\\Eudora.ini"), z, sizeof(z) / sizeof(TCHAR));
		TT_CHECK_MSG(_tcscmp(z, _T("\"C:\\Program Files\\Eudora\\Eudora.exe\" \"D:\\Mail Daten\" \"D:\\Mail Daten\\Eudora.ini\"")) == 0,
			"Teile mit Leerzeichen sind nicht geklammert (E-209)");

		TCHAR szRest[3 * MAX_PATH + 10], szDir[MAX_PATH + 1], szIni[MAX_PATH + 1];
		E209ProgrammAbschneiden(z, szRest, sizeof(szRest) / sizeof(TCHAR));
		E132AufrufZerlegen(szRest, szDir, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(_tcscmp(szDir, _T("D:\\Mail Daten")) == 0, "der naechste Start findet das Verzeichnis nicht ganz wieder (E-209)");
		TT_CHECK_MSG(_tcscmp(szIni, _T("D:\\Mail Daten\\Eudora.ini")) == 0, "der naechste Start findet die INI nicht ganz wieder (E-209)");

		// Nur das Programm mit Leerzeichen: der Rest bleibt ungeklammert.
		E209BefehlszeileBauen(_T("C:\\Program Files\\Eudora.exe"), _T("C:\\M"), _T("C:\\M\\Eudora.ini"), z, sizeof(z) / sizeof(TCHAR));
		TT_CHECK_MSG(_tcscmp(z, _T("\"C:\\Program Files\\Eudora.exe\" C:\\M C:\\M\\Eudora.ini")) == 0,
			"nur das Programm hat ein Leerzeichen - geklammert werden darf nur das Programm (E-209)");
		E209ProgrammAbschneiden(z, szRest, sizeof(szRest) / sizeof(TCHAR));
		E132AufrufZerlegen(szRest, szDir, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(_tcscmp(szDir, _T("C:\\M")) == 0, "hinter einem geklammerten Programm wird das Verzeichnis nicht mehr gefunden (E-209)");

		// Nur die INI mit Leerzeichen: Verzeichnis UND INI geklammert, sonst
		// endet die Zeile auf '"' und GetDirs trennt gar nicht.
		E209BefehlszeileBauen(_T("C:\\E.exe"), _T("C:\\M"), _T("C:\\M\\Mein Eudora.ini"), z, sizeof(z) / sizeof(TCHAR));
		E209ProgrammAbschneiden(z, szRest, sizeof(szRest) / sizeof(TCHAR));
		E132AufrufZerlegen(szRest, szDir, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(_tcscmp(szDir, _T("C:\\M")) == 0 && _tcscmp(szIni, _T("C:\\M\\Mein Eudora.ini")) == 0,
			"hat nur die INI ein Leerzeichen, zerfaellt die Zeile beim Lesen (E-209)");

		// PRUEFER-87 N6 (GE2): Verzeichnis UND INI werden zusammen geklammert,
		// wenn nur die INI ein Leerzeichen hat. Der Grund ist die naechste
		// Pruefung: Verzeichnis ungeklammert, INI geklammert endet auf '"',
		// und dann trennt GetDirs (und E132AufrufZerlegen) gar nicht.
		E209BefehlszeileBauen(_T("C:\\E.exe"), _T("C:\\M"), _T("C:\\M\\Mein Eudora.ini"), z, sizeof(z) / sizeof(TCHAR));
		TT_CHECK_MSG(_tcscmp(z, _T("C:\\E.exe \"C:\\M\" \"C:\\M\\Mein Eudora.ini\"")) == 0,
			"hat nur die INI ein Leerzeichen, werden Verzeichnis und INI nicht zusammen geklammert (E-209, PRUEFER-87 N6)");
		E132AufrufZerlegen(_T("C:\\M \"C:\\M\\Mein Eudora.ini\""), szDir, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(_tcscmp(szDir, _T("C:\\M")) != 0,
			"Verzeichnis ungeklammert, INI geklammert wird doch getrennt - dann ist das gemeinsame Klammern unnoetig, Test anpassen (PRUEFER-87 N6)");

		// Der Fehler selbst, als Beleg: ungeklammert zerfaellt die Zeile.
		E132AufrufZerlegen(_T("D:\\Mail Daten D:\\Mail Daten\\Eudora.ini"), szDir, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(_tcscmp(szDir, _T("D:\\Mail Daten")) != 0, "ungeklammert kommt das Verzeichnis ganz an - dann gaebe es E-209 nicht, Test anpassen");
	}
	TT_EndTest();

	TT_BeginTest("E-209: ein zu kleiner Puffer wird abgeschlossen, nicht ueberschrieben");
	{
		TCHAR z[8];
		z[7] = 'X';
		E209BefehlszeileBauen(_T("C:\\Program Files\\Eudora.exe"), _T("C:\\M"), _T("C:\\M\\Eudora.ini"), z, 7);
		TT_CHECK_MSG(_tcslen(z) < 7, "die Zeile ist nicht innerhalb des Puffers abgeschlossen (E-209)");
		TT_CHECK_MSG(z[7] == 'X', "hinter dem Puffer wurde geschrieben (E-209)");
	}
	TT_EndTest();
}

void RunE133Tests(const char* szEudoraDir)
{
	Test_E133_Stelle(szEudoraDir);
	Test_E133_Klammer();
	Test_E209();
}
