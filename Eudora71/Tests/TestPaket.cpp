//
// TestPaket.cpp - Regressionstests zu S-1, S-8 und E-156 (Paket startet nicht / Debug im Paket)
//
// S-1:   Paket 1.0.1 startete nicht, MSVCR71D.dll fehlte - eine Debug-Laufzeit,
//        die weder im Paket lag noch zu Windows gehoert.
// S-8:   Paket 1.0.2 startete mit 0xc000007b - eine Datei hatte die falsche
//        Architektur bzw. zog eine Debug-Laufzeit nach.
// E-156: in jedem Paket seit August lagen sechs Debug-Fassungen (drei mit
//        Endung .eif, drei mit statisch eingebauter Debug-Laufzeit); Eudora
//        stuerzte in ucrtbased.dll ab. paket-pruefen.ps1 las nur .exe/.dll und
//        nur Importe.
//
// Gesichert wird, was diese Fehler heute abfaengt: tools/paket-pruefen.ps1
// (laeuft an jedem Paket, Ergebnis in Releases/PAKETE.md) und Schritt 8 von
// tools/paket-bauen.ps1. Das Debug-Muster wird aus BEIDEN Skripten gelesen
// und hier AUSGEFUEHRT (std::regex, ohne Gross-/Kleinschreibung wie (?i) in
// PowerShell) - gegen die Dateinamen und Zeichenketten der echten Faelle.
// Der Rest ist eine Pruefung der STELLE (Quelltext.h).
//
#include <afx.h>
#include <string.h>
#include <string>
#include <regex>

#include "TinyTest.h"
#include "Quelltext.h"

// Holt das Muster aus "$debugMuster = '(?i)...'" und baut daraus eine
// std::regex. Rueckgabe false, wenn es nicht zu finden oder nicht zu
// uebersetzen ist.
static bool HoleDebugMuster(const char* pSkript, std::regex& rx, std::string& strMuster)
{
	const char* szAnfang = "$debugMuster = '(?i)";
	const char* p = strstr(pSkript, szAnfang);
	if (!p) return false;
	p += strlen(szAnfang);
	const char* pEnde = strchr(p, '\'');
	if (!pEnde) return false;
	strMuster.assign(p, pEnde - p);
	try
	{
		rx = std::regex(strMuster, std::regex::ECMAScript | std::regex::icase);
	}
	catch (...)
	{
		return false;
	}
	return true;
}

static void PruefeMuster(const char* szSkript, const char* pSkript)
{
	std::regex rx;
	std::string strMuster;
	if (!HoleDebugMuster(pSkript, rx, strMuster))
	{
		TT_Fail("%s: $debugMuster nicht gefunden oder nicht uebersetzbar", szSkript);
		return;
	}

	// Muss erkannt werden: die echten Faelle.
	static const char* aDebug[] = {
		"MSVCR71D.dll",		// S-1
		"ucrtbased.dll",	// E-156, Absturzmodul
		"VCRUNTIME140D.dll", "MSVCP140D.dll", "mfc140d.dll", "mfc140ud.dll",	// E-156, NSImport.eif
		"_CrtDbgReport", "dbgheap.c",	// E-156, statisch eingebaut (EuShlExt.dll, EudoraNS.dll, swEudora.exe)
	};
	for (int i = 0; i < (int) (sizeof(aDebug) / sizeof(aDebug[0])); i++)
		if (!std::regex_search(aDebug[i], rx))
			TT_Fail("%s: das Debug-Muster erkennt %s nicht", szSkript, aDebug[i]);

	// Darf NICHT anschlagen: die Release-Laufzeiten, die im Paket liegen.
	static const char* aRelease[] = {
		"MSVCR71.dll", "msvcrt.dll", "ucrtbase.dll", "VCRUNTIME140.dll",
		"MSVCP140.dll", "mfc140.dll", "mfc140u.dll", "MFC71.DLL", "Paige32.dll",
	};
	for (int i = 0; i < (int) (sizeof(aRelease) / sizeof(aRelease[0])); i++)
		if (std::regex_search(aRelease[i], rx))
			TT_Fail("%s: das Debug-Muster haelt die Release-Datei %s fuer Debug", szSkript, aRelease[i]);
}

static void Test_DebugImPaket(const char* szEudoraDir)
{
	TT_BeginTest("E-156/S-1: das Debug-Muster aus paket-pruefen.ps1 und paket-bauen.ps1 erkennt die echten Faelle (ausgefuehrt)");
	char* pPruefen = QT_Lesen(szEudoraDir, "..\\..\\tools\\paket-pruefen.ps1");
	char* pBauen   = QT_Lesen(szEudoraDir, "..\\..\\tools\\paket-bauen.ps1");
	if (!pPruefen || !pBauen)
	{
		TT_Fail("paket-pruefen.ps1 oder paket-bauen.ps1 nicht lesbar - ungeprueft ist nicht gruen");
		free(pPruefen); free(pBauen); TT_EndTest(); return;
	}
	PruefeMuster("paket-pruefen.ps1", pPruefen);
	PruefeMuster("paket-bauen.ps1", pBauen);

	QT_LeerraumZusammen(pPruefen);
	QT_LeerraumZusammen(pBauen);

	// paket-pruefen: JEDE Datei mit MZ-Kopf, gleich welche Endung (die .eif aus E-156),
	// und ein Treffer ist ein FEHLER.
	char* pScan = QT_Abschnitt(pPruefen, "$debugMuster = '", "if ($debugDateien -eq 0)");
	TT_CHECK_MSG(pScan != NULL, "paket-pruefen.ps1: die Suche nach Debug-Fassungen ist nicht zu finden");
	if (pScan)
	{
		TT_CHECK_MSG(QT_Enthaelt(pScan, "foreach ($f in @(Get-ChildItem -LiteralPath $Paket -Recurse -File |"),
					 "paket-pruefen.ps1: die Debug-Suche geht nicht mehr ueber jede Datei des Pakets");
		TT_CHECK_MSG(!QT_Enthaelt(pScan, "$binaer"), "paket-pruefen.ps1: die Debug-Suche nimmt wieder nur die Endungsliste $binaer - .eif faellt durch (E-156)");
		TT_CHECK_MSG(QT_Enthaelt(pScan, "if ($kopf[0] -ne 0x4D -or $kopf[1] -ne 0x5A) { continue }"), "paket-pruefen.ps1: ausfuehrbar wird nicht mehr am MZ-Kopf erkannt");
		TT_CHECK_MSG(QT_Enthaelt(pScan, "Melde-Fehler (\"{0} ist eine Debug-Fassung"), "paket-pruefen.ps1: eine Debug-Fassung ist kein FEHLER mehr");
		free(pScan);
	}

	// paket-bauen Schritt 8: im Release-Bau jede MZ-Datei aus Bin\Release, Abbruch bei Debug.
	char* pSchritt8 = QT_Abschnitt(pBauen, "if ($Bauart -eq 'Release') { Write-Host '' Write-Host '8. ", "keine Debug-Laufzeit\" -f $ersetzt, $gleich)");
	TT_CHECK_MSG(pSchritt8 != NULL, "paket-bauen.ps1: Schritt 8 (jede ausfuehrbare Datei aus dem Release-Bau) nicht gefunden");
	if (pSchritt8)
	{
		TT_CHECK_MSG(QT_Enthaelt(pSchritt8, "if ($kopf[0] -ne 0x4D -or $kopf[1] -ne 0x5A) { continue }"), "paket-bauen.ps1: Schritt 8 erkennt ausfuehrbare Dateien nicht mehr am MZ-Kopf");
		TT_CHECK_MSG(QT_Enthaelt(pSchritt8, "throw (\"ABBRUCH: {0} ist ausfuehrbar, hat aber kein Gegenstueck"), "paket-bauen.ps1: eine Datei ohne Gegenstueck im Release-Bau bleibt stehen statt abzubrechen");
		TT_CHECK_MSG(QT_Enthaelt(pSchritt8, "throw (\"ABBRUCH: {0} enthaelt Debug-Laufzeit"), "paket-bauen.ps1: eine Debug-Laufzeit bricht den Paketbau nicht mehr ab");
		free(pSchritt8);
	}

	free(pPruefen);
	free(pBauen);
	TT_EndTest();
}

static void Test_FehlendeLaufzeit(const char* szEudoraDir)
{
	TT_BeginTest("S-1 (Quelltext): eine DLL, die weder im Paket liegt noch zu Windows gehoert, ist ein FEHLER");
	char* pText = QT_Lesen(szEudoraDir, "..\\..\\tools\\paket-pruefen.ps1");
	if (!pText) { TT_Fail("paket-pruefen.ps1 nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	QT_LeerraumZusammen(pText);

	TT_CHECK_MSG(QT_Enthaelt(pText, "if ($windowsEigenNachschlag.ContainsKey($basis)) { return 'Windows' } return 'Fehlt' }"),
				 "Klassifiziere: was nicht im Paket und nicht in der Windows-Liste steht, gilt nicht mehr als 'Fehlt'");
	TT_CHECK_MSG(QT_Enthaelt(pText, "Melde-Fehler (\"$n fehlt im Paket und gehoert nicht zu Windows; der Lader braucht sie VOR dem ersten Befehl"),
				 "eine in der Startkette fehlende DLL ist kein FEHLER mehr");

	// Die Windows-Liste darf keine Visual-Studio-Laufzeit enthalten - sonst
	// gilt MSVCR71(D).dll als "bringt Windows mit" und das Urteil faellt zu guenstig aus.
	char* pListe = QT_Abschnitt(pText, "$windowsEigen = @(", "'gdiplus','oledlg','mfc42','mfc42u' )");
	TT_CHECK_MSG(pListe != NULL, "die Liste $windowsEigen ist nicht zu finden");
	if (pListe)
	{
		static const char* aNichtWindows[] = { "'msvcr71'", "'msvcr71d'", "'msvcp71'", "'mfc71'", "'msvcr100'", "'msvcr120'", "'vcruntime140'", "'ucrtbased'" };
		for (int i = 0; i < (int) (sizeof(aNichtWindows) / sizeof(aNichtWindows[0])); i++)
			if (QT_Enthaelt(pListe, aNichtWindows[i]))
				TT_Fail("$windowsEigen nennt %s - die kommt mit Visual Studio, nicht mit Windows", aNichtWindows[i]);
		free(pListe);
	}

	free(pText);
	TT_EndTest();
}

static void Test_Architektur(const char* szEudoraDir)
{
	TT_BeginTest("S-8 (Quelltext): eine Paketdatei, die nicht x86 ist, ist ein FEHLER (sonst 0xc000007b)");
	char* pText = QT_Lesen(szEudoraDir, "..\\..\\tools\\paket-pruefen.ps1");
	if (!pText) { TT_Fail("paket-pruefen.ps1 nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	QT_LeerraumZusammen(pText);

	TT_CHECK_MSG(QT_Enthaelt(pText, "0x014C { 'x86' }"), "der PE-Leser erkennt x86 (0x014C) nicht mehr");
	TT_CHECK_MSG(QT_Enthaelt(pText, "if ($pe.Arch -ne 'x86') { Melde-Fehler (\"{0} ist {1}, erwartet x86 - das gibt beim Start 0xc000007b\""),
				 "eine Datei mit falscher Architektur ist kein FEHLER mehr");

	free(pText);
	TT_EndTest();
}

void RunPaketTests(const char* szEudoraDir)
{
	Test_DebugImPaket(szEudoraDir);
	Test_FehlendeLaufzeit(szEudoraDir);
	Test_Architektur(szEudoraDir);
}
