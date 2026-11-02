//
// TestHilfeMenue.cpp - Hilfe-Menue (7.2.2): Help -> Keyboard Shortcuts und
// Help -> Settings Reference oeffnen je eine HTML-Seite im Standard-Browser.
//
// Gregor am 02.11.2026: "das dann einfach als HTML im default browser
// anzeigen". Die Seiten erzeugt tools/hilfe-html.pl, paket-bauen.ps1 legt sie
// nach Hilfe\ neben Eudora.exe.
//
// Geprueft am Quelltext (schwaecher als ein Aufruf, siehe Quelltext.h):
//   1. beide Kennungen in resource.h, jede Nummer nur einmal vergeben,
//   2. beide MENUITEMs im POPUP "&Help" von IDR_MAINFRAME, Beschleuniger-
//      buchstaben im Popup ohne Doppelung, Statuszeilentext vorhanden,
//   3. ON_COMMAND fuer beide im MESSAGE_MAP von CMainFrame,
//   4. der Handler bildet den Pfad breit (W) am Rueckstrich, prueft Datei,
//      Verzeichnis und leeren Ordner, bevor er ShellExecuteExW ruft, meldet
//      ihr Fehlen mit AfxMessageBox und return, ruft ShellExecuteExW ohne
//      eigenen Windows-Dialog und wertet die Rueckgabe aus (<= 32 -> genau
//      eine Meldung, eigene fuer SE_ERR_NOASSOC) - mit Logzeile in allen drei
//      Ausgaengen.
// Fehlt eines davon, zeigt das Menue nichts, stuerzt oder schweigt.
// Nachgeschaerft nach PRUEFER-84 K1/K4/K5: vorher blieb der Test gruen ohne
// return im Fehlt-Zweig, mit '/' als Trenner und ohne Verzeichnis- und
// Leer-Pruefung.
//
#include <afx.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "TinyTest.h"
#include "Quelltext.h"

// Nummer eines #define in resource.h (Rohtext), -1 wenn nicht da.
static long DefineWert(const char* pRh, const char* szName)
{
	const size_t n = strlen(szName);
	for (const char* p = strstr(pRh, "#define "); p; p = strstr(p + 1, "#define "))
	{
		const char* q = p + 8;
		while (*q == ' ' || *q == '\t') q++;
		if (strncmp(q, szName, n) == 0 && (q[n] == ' ' || q[n] == '\t'))
			return strtol(q + n, NULL, 0);
	}
	return -1;
}

// Wie oft wird die Zahl lWert als Wert eines #define in resource.h vergeben?
static int WertZaehlen(const char* pRh, long lWert)
{
	int nTreffer = 0;
	for (const char* p = strstr(pRh, "#define "); p; p = strstr(p + 1, "#define "))
	{
		const char* q = p + 8;
		while (*q == ' ' || *q == '\t') q++;
		while (*q && *q != ' ' && *q != '\t' && *q != '\n' && *q != '\r') q++;	// Name
		while (*q == ' ' || *q == '\t') q++;
		if (!isdigit((unsigned char) *q))
			continue;
		char* pEnde = NULL;
		const long v = strtol(q, &pEnde, 0);
		if (pEnde && (*pEnde == '\n' || *pEnde == '\r' || *pEnde == ' ' || *pEnde == '\t' || *pEnde == '\0') && v == lWert)
			nTreffer++;
	}
	return nTreffer;
}

static void Test_Hilfe_Kennungen(const char* szEudoraDir)
{
	TT_BeginTest("Hilfe-Menue (Quelltext): Kennungen in resource.h, keine Nummer doppelt");
	char* pRh = QT_Lesen(szEudoraDir, "resource.h");
	if (!pRh)
	{
		TT_Fail("resource.h nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	const char* aIds[] = { "ID_HELP_KEYBOARD_SHORTCUTS", "ID_HELP_SETTINGS_REFERENCE" };
	for (int i = 0; i < 2; i++)
	{
		const long v = DefineWert(pRh, aIds[i]);
		if (v < 0)
			TT_Fail("%s fehlt in resource.h", aIds[i]);
		else
		{
			// Befehlsbereich unterhalb von QC_FIRST_COMMAND_ID (resource.h,
			// "DONT_USE_ANY_IDS_IN_THIS_RANGE" ab 0x81FF).
			TT_CHECK_MSG(v >= 0x8000 && v < 0x81FF, "Kennung ausserhalb des freien Befehlsbereichs 0x8000..0x81FE");
			const int n = WertZaehlen(pRh, v);
			if (n != 1)
				TT_Fail("%s = %ld ist in resource.h %d-mal vergeben (Doppelvergabe: falscher Handler oder falscher Statuszeilentext)", aIds[i], v, n);
		}
	}
	free(pRh);
	TT_EndTest();
}

static void Test_Hilfe_Menue(const char* szEudoraDir)
{
	TT_BeginTest("Hilfe-Menue (Quelltext): zwei Eintraege im Menue Help, Statuszeilentext, Beschleuniger eindeutig");
	char* pRc = QT_Lesen(szEudoraDir, "EudoraRes.rc");
	if (!pRc)
	{
		TT_Fail("EudoraRes.rc nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	// Das Hauptmenue, dort das Popup Help bis zum Ende des Menues.
	char* pMenue = QT_Abschnitt(pRc, "IDR_MAINFRAME MENU", "IDR_CONTEXT_POPUPS MENU");
	char* pHelp = pMenue ? QT_Abschnitt(pMenue, "POPUP \"&Help\"", "IDR_CONTEXT_POPUPS MENU") : NULL;
	if (!pHelp)
		TT_Fail("POPUP \"&Help\" in IDR_MAINFRAME nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		QT_LeerraumZusammen(pHelp);
		TT_CHECK_MSG(QT_Enthaelt(pHelp, "MENUITEM \"&Keyboard Shortcuts\", ID_HELP_KEYBOARD_SHORTCUTS"), "Menueeintrag Keyboard Shortcuts fehlt im Menue Help");
		TT_CHECK_MSG(QT_Enthaelt(pHelp, "MENUITEM \"Settings Re&ference\", ID_HELP_SETTINGS_REFERENCE"), "Menueeintrag Settings Reference fehlt im Menue Help");
		TT_CHECK_MSG(QT_Enthaelt(pHelp, "ID_TIP_OF_THE_DAY MENUITEM SEPARATOR MENUITEM \"&Keyboard Shortcuts\""), "Keyboard Shortcuts steht nicht als eigene Gruppe hinter Tip of the Day");

		// Beschleunigerbuchstaben: jedes "&x" (nicht "&&") im Popup hoechstens einmal.
		int aZahl[256] = { 0 };
		const char* pEnde = strstr(pHelp, " END");
		for (const char* p = pHelp; *p && (!pEnde || p < pEnde); p++)
		{
			if (*p != '&') continue;
			if (p[1] == '&') { p++; continue; }
			aZahl[(unsigned char) tolower((unsigned char) p[1])]++;
		}
		for (int c = 'a'; c <= 'z'; c++)
			if (aZahl[c] > 1)
				TT_Fail("Beschleuniger &%c im Menue Help %d-mal vergeben", c, aZahl[c]);
		free(pHelp);
	}
	if (pMenue) free(pMenue);

	char* pRcCode = QT_Lesen(szEudoraDir, "EudoraRes.rc");
	if (pRcCode)
	{
		QT_LeerraumZusammen(pRcCode);
		TT_CHECK_MSG(QT_Enthaelt(pRcCode, "ID_HELP_KEYBOARD_SHORTCUTS \"Shows all keyboard shortcuts in your web browser\\nKeyboard shortcuts\""), "STRINGTABLE: Statuszeilentext fuer Keyboard Shortcuts fehlt");
		TT_CHECK_MSG(QT_Enthaelt(pRcCode, "ID_HELP_SETTINGS_REFERENCE \"Shows Tools > Options and the Eudora.ini keys in your web browser\\nSettings reference\""), "STRINGTABLE: Statuszeilentext fuer Settings Reference fehlt");
		free(pRcCode);
	}
	free(pRc);
	TT_EndTest();
}

static void Test_Hilfe_Handler(const char* szEudoraDir)
{
	TT_BeginTest("Hilfe-Menue (Quelltext): Handler im MESSAGE_MAP, fehlende Datei gemeldet, ShellExecute-Rueckgabe geprueft");
	char* pMain = QT_LiesNurCode(szEudoraDir, "mainfrm.cpp");
	if (!pMain)
	{
		TT_Fail("mainfrm.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pMap = QT_Abschnitt(pMain, "BEGIN_MESSAGE_MAP(CMainFrame, QCWorkbook)", "END_MESSAGE_MAP()");
	TT_CHECK_MSG(pMap != NULL, "MESSAGE_MAP von CMainFrame nicht gefunden");
	if (pMap)
	{
		TT_CHECK_MSG(QT_Enthaelt(pMap, "ON_COMMAND(ID_HELP_KEYBOARD_SHORTCUTS, OnHelpKeyboardShortcuts)"), "ON_COMMAND fuer Keyboard Shortcuts fehlt - der Menueeintrag bliebe grau");
		TT_CHECK_MSG(QT_Enthaelt(pMap, "ON_COMMAND(ID_HELP_SETTINGS_REFERENCE, OnHelpSettingsReference)"), "ON_COMMAND fuer Settings Reference fehlt - der Menueeintrag bliebe grau");
		free(pMap);
	}
	// PRUEFER-84 K4: BEIDE Eintraege, nicht nur Keyboard Shortcuts.
	char* pK = QT_Abschnitt(pMain, "void CMainFrame::OnHelpKeyboardShortcuts()", "}");
	char* pS = QT_Abschnitt(pMain, "void CMainFrame::OnHelpSettingsReference()", "}");
	TT_CHECK_MSG(pK && QT_Enthaelt(pK, "HilfeSeiteOeffnen(\"Tastenkuerzel.html\");"), "Keyboard Shortcuts oeffnet nicht Tastenkuerzel.html");
	TT_CHECK_MSG(pS && QT_Enthaelt(pS, "HilfeSeiteOeffnen(\"Einstellungen.html\");"), "Settings Reference oeffnet nicht Einstellungen.html");
	if (pK) free(pK);
	if (pS) free(pS);

	char* pFn = QT_Abschnitt(pMain, "void CMainFrame::HilfeSeiteOeffnen(const char* szDatei)", "void CMainFrame::OnPaymentAndRegistration()");
	if (!pFn)
		TT_Fail("HilfeSeiteOeffnen nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		// Pfad: Ordner der laufenden EXE, breit und mit Platz fuer lange Pfade
		// (PRUEFER-84 K5), Trenner '\\' (K1: mit '/' blieb der Ordner leer und
		// jede Seite galt als fehlend - der Test blieb gruen).
		TT_CHECK_MSG(QT_Enthaelt(pFn, "::GetModuleFileNameW(NULL, strExe.GetBuffer(nPlatz), nPlatz)"), "der Pfad kommt nicht breit (W) aus dem Verzeichnis der laufenden Eudora.exe");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "const int iTrenner = strExe.ReverseFind(L'\\\\');"), "der Ordner wird nicht am Rueckstrich abgetrennt (K1)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "strOrdnerW + L\"Hilfe\\\\\" + CStringW(szDatei)"), "der Unterordner Hilfe fehlt im Pfad");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "::GetFileAttributesW(strPruefW)"), "die Datei wird nicht breit (W) geprueft");
		// PRUEFER-84 N1: die Teile dazwischen dem Wortlaut nach - vorher blieb
		// der Test gruen ohne Rueckstrich am Ordner (jede Seite "fehlt"), mit
		// Praefix an die Shell, ohne Laengenpruefung und mit verworfener
		// Rueckgabe von ShellExecuteExW.
		TT_CHECK_MSG(QT_Enthaelt(pFn, "strExe.ReleaseBuffer((nLen > 0 && nLen < nPlatz) ? (int) nLen : 0);"), "abgeschnittener oder leerer Modulpfad wird nicht verworfen (N1)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "strOrdnerW = strExe.Left(iTrenner + 1);"), "der Ordner verliert den Rueckstrich - jede Seite gilt als fehlend (N1)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if (strPfadW.GetLength() >= MAX_PATH && strPfadW.Left(4) != L\"\\\\\\\\?\\\\\")"), "Praefix fuer lange Pfade fehlt oder wird verdoppelt (N1/N3)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "strPruefW = L\"\\\\\\\\?\\\\UNC\\\\\" + strPfadW.Mid(2);"), "Netzpfad bekommt nicht \\\\?\\UNC\\ (N3)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "strPruefW = L\"\\\\\\\\?\\\\\" + strPfadW;"), "lokaler langer Pfad bekommt kein \\\\?\\ (N1)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "sei.lpFile = strPfadW;"), "die Shell bekommt nicht den Pfad ohne Praefix (N1)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "const BOOL bGeoeffnet = ::ShellExecuteExW(&sei); const DWORD dwWinFehler = bGeoeffnet ? 0 : ::GetLastError();"),
					 "die Rueckgabe von ShellExecuteExW oder GetLastError wird nicht sofort festgehalten (N1/N4)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if (!bGeoeffnet && nErgebnis > 32) nErgebnis = 0;"), "ein Fehlschlag ohne SE_ERR-Code gilt als Erfolg (N1)");
		// Ausstieg 1: Datei fehlt, Verzeichnis statt Datei, oder Ordner leer
		// -> Meldung, Logzeile, return - und erst DANACH ShellExecuteEx (K1).
		TT_CHECK_MSG(QT_Enthaelt(pFn, "if (strOrdnerW.IsEmpty() || dwAttr == INVALID_FILE_ATTRIBUTES || (dwAttr & FILE_ATTRIBUTE_DIRECTORY))"),
					 "die Pruefung auf fehlende Datei, Verzeichnis oder leeren Ordner ist unvollstaendig (K1)");
		const long lPruef = QT_Stelle(pFn, "dwAttr == INVALID_FILE_ATTRIBUTES");
		const long lShell = QT_Stelle(pFn, "::ShellExecuteExW(&sei)");
		TT_CHECK_MSG(lPruef >= 0, "keine Pruefung, ob die Hilfeseite existiert");
		TT_CHECK_MSG(lShell >= 0, "kein ShellExecuteExW - die Seite geht nicht an den Standard-Browser");
		if (lPruef >= 0 && lShell >= 0)
			TT_CHECK_MSG(lPruef < lShell, "die Pruefung auf die fehlende Datei steht hinter ShellExecuteEx");
		char* pFehlt = QT_Abschnitt(pFn, "dwAttr == INVALID_FILE_ATTRIBUTES", "SHELLEXECUTEINFOW sei;");
		TT_CHECK_MSG(pFehlt && QT_Enthaelt(pFehlt, "\"Hilfe: %s fehlt\""), "fehlende Datei: Logzeile 'Hilfe: <datei> fehlt' fehlt");
		TT_CHECK_MSG(pFehlt && QT_Enthaelt(pFehlt, "AfxMessageBox(strMeldung, MB_OK | MB_ICONEXCLAMATION); return; } SHELLEXECUTEINFOW sei;"),
					 "fehlende Datei: der Zweig endet nicht mit Meldung und return vor ShellExecuteEx - Durchfall, zweite Meldung (K1)");
		if (pFehlt) free(pFehlt);
		// Ausstieg 2: kein eigener Windows-Dialog, Rueckgabe <= 32 -> EINE
		// Meldung (eigene fuer SE_ERR_NOASSOC), Logzeile, return (K5).
		TT_CHECK_MSG(QT_Enthaelt(pFn, "sei.fMask = SEE_MASK_FLAG_NO_UI;"), "ohne SEE_MASK_FLAG_NO_UI zeigt Windows einen eigenen Dialog und danach Eudora noch einen (K5)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "sei.lpVerb = L\"open\";"), "Verb ist nicht \"open\"");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "INT_PTR nErgebnis = (INT_PTR) sei.hInstApp;"), "die Rueckgabe von ShellExecuteEx wird nicht festgehalten");
		char* pFehler = QT_Abschnitt(pFn, "if (nErgebnis <= 32)", "strLog.Format(\"Hilfe: %s geoeffnet\"");
		TT_CHECK_MSG(pFehler && QT_Enthaelt(pFehler, "\"Hilfe: %s fehler=%d winfehler=%lu\", szDatei, (int) nErgebnis, dwWinFehler);"), "ShellExecuteEx-Rueckgabe <= 32: Logzeile 'fehler=n winfehler=m' fehlt (N4)");
		TT_CHECK_MSG(pFehler && QT_Enthaelt(pFehler, "(LPCTSTR) strPfad, (int) nErgebnis, dwWinFehler);"), "die Meldung nennt den Systemfehler nicht (N4)");
		TT_CHECK_MSG(pFehler && QT_Enthaelt(pFehler, "if (nErgebnis == SE_ERR_NOASSOC)"), "keine eigene Meldung fuer 'keine Zuordnung fuer .html' (SE_ERR_NOASSOC, K5)");
		TT_CHECK_MSG(pFehler && QT_Zaehle(pFehler, "AfxMessageBox(") == 1, "im Fehlerzweig nicht genau EINE Meldung (K5)");
		TT_CHECK_MSG(pFehler && QT_Enthaelt(pFehler, "AfxMessageBox(strMeldung, MB_OK | MB_ICONEXCLAMATION); return; }"), "ShellExecuteEx-Fehlerzweig endet nicht mit return");
		if (pFehler) free(pFehler);
		// Ausstieg 3: Erfolg -> Logzeile.
		TT_CHECK_MSG(QT_Enthaelt(pFn, "\"Hilfe: %s geoeffnet\""), "Logzeile 'Hilfe: <datei> geoeffnet' fehlt");
		TT_CHECK_MSG(QT_Zaehle(pFn, "PutDebugLog(DEBUG_MASK_MISC, strLog);") == 3, "nicht genau drei Logzeilen (fehlt / fehler / geoeffnet)");
		TT_CHECK_MSG(!QT_Enthaelt(pFn, "ASSERT("), "ASSERT im Handler - im Release ist er nichts, der Schutz muss eine Abfrage sein");
		free(pFn);
	}
	free(pMain);
	TT_EndTest();
}

void RunHilfeMenueTests(const char* szEudoraDir)
{
	Test_Hilfe_Kennungen(szEudoraDir);
	Test_Hilfe_Menue(szEudoraDir);
	Test_Hilfe_Handler(szEudoraDir);
}
