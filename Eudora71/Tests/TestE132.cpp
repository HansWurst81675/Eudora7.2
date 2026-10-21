//
// TestE132.cpp - Befund E-132: das Mailverzeichnis einer fremden Installation
//
// Ein Doppelklick auf Eudora.exe uebernahm stillschweigend das Verzeichnis
// einer vorhandenen Eudora- oder Hermes-Installation: ist die Befehlszeile
// leer und liegt keine Eudora.ini neben der EXE, liest Eudora
// HKEY_CURRENT_USER\\Software\\Qualcomm\\Eudora\\CommandLine\\Current und schneidet
// den Datenordner aus der Befehlszeile heraus, mit der ein ANDERES Eudora
// zuletzt gestartet wurde (eudora.cpp:1036-1052 und :3700).
//
// Beide Bedingungen erfuellt unser Paket: die mitgelieferte Eudora.ini liegt
// in Mailverzeichnis\\, nicht neben der EXE.
//
// Gregors Anforderung vom 20.10.2026: eine vorhandene Installation nimmt
// keinen Schaden - gleich ob der Anwender absichtlich auf ihre Postfaecher
// zeigt oder sie sich kopiert hat.
//
// Geprueft wird hier die Entscheidung allein: ist das gefundene Verzeichnis
// fremd? Die Rueckfrage selbst steht daneben in eudora.cpp und braucht ein
// Fenster.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>

#include "TinyTest.h"
#include "UnderTestE132.h"

void RunE132Tests(void)
{
	TT_Suite("E-132: fremdes Mailverzeichnis beim Start");

	const char *EIGEN = "C:\\Users\\Gregor\\Eudora72-1.0.113-release\\";

	// ------------------------------------------------------------- (1)
	// Der gemeldete Fall: die Registry zeigt auf eine andere Installation,
	// und dort steht bereits eine Einrichtung.
	TT_BeginTest("E-132: fremdes Verzeichnis mit eigener Einrichtung wird erkannt");
	{
		TT_CHECK_MSG(E132IstFremdesVerzeichnis("C:\\Programme\\Hermes\\", EIGEN, true),
			"anderer Ordner, hat Eudora.ini");
		TT_CHECK_MSG(E132IstFremdesVerzeichnis("D:\\Mail\\Eudora\\", EIGEN, true),
			"anderes Laufwerk");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	// Die Gegenprobe: unser eigenes Verzeichnis darf nicht als fremd gelten.
	// Ohne sie wuerde Eudora bei JEDEM Start fragen - eine Meldung, die
	// immer kommt, liest nach drei Tagen niemand mehr.
	TT_BeginTest("E-132 Gegenprobe: das eigene Verzeichnis gilt nicht als fremd");
	{
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis(EIGEN, EIGEN, true),
			"genau das Programmverzeichnis");
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Users\\Gregor\\Eudora72-1.0.113-release\\Mailverzeichnis\\", EIGEN, true),
			"darunter - so liegt es in unseren Paketen");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	// Gross- und Kleinschreibung spielt bei Windows-Pfaden keine Rolle.
	// Die Registry liefert oft eine andere Schreibweise als GetModuleFileName.
	TT_BeginTest("E-132: Schreibweise des Pfades aendert nichts");
	{
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("c:\\users\\gregor\\EUDORA72-1.0.113-RELEASE\\", EIGEN, true),
			"dasselbe Verzeichnis, andere Schreibweise");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	// Liegt dort keine Einrichtung, ist es auch keine fremde - dann gibt es
	// nichts zu beschaedigen und nichts zu fragen.
	TT_BeginTest("E-132: ohne Eudora.ini wird nicht gefragt");
	{
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Programme\\Hermes\\", EIGEN, false),
			"fremder Ordner, aber leer");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	// Die Raender: nichts gefunden, oder wir wissen nicht, wo wir selbst
	// liegen. Dann lieber nicht fragen als falsch fragen.
	TT_BeginTest("E-132: ohne Angaben wird nicht gefragt");
	{
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis(NULL, EIGEN, true), "kein Kandidat");
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("", EIGEN, true), "leerer Kandidat");
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Programme\\Hermes\\", NULL, true), "eigenes unbekannt");
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Programme\\Hermes\\", "", true), "eigenes leer");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	// DER EIGENTLICHE FUND vom 20.10.2026.
	//
	// Die Registry speichert nicht ein Verzeichnis, sondern den ganzen
	// Aufruf. Nach dem Abschneiden des Programmnamens stehen dort ZWEI
	// Pfade, durch ein Leerzeichen getrennt:
	//
	//   C:\Temp\E131\MAILVE~1 C:\Temp\E131\MAILVE~1\Eudora.ini
	//
	// Die erste Fassung der Rueckfrage haengte "\Eudora.ini" an diese ganze
	// Zeichenkette an. Diese Datei gibt es nie - also galt nie etwas als
	// fremd, und die Rueckfrage kam nicht. Eingebaut, aber stumm.
	TT_BeginTest("E-132: Befehlszeile aus der Registry wird zerlegt");
	{
		TCHAR szVerz[MAX_PATH + 1];
		TCHAR szIni[MAX_PATH + 1];

		E132AufrufZerlegen("C:\\Temp\\E131\\MAILVE~1 C:\\Temp\\E131\\MAILVE~1\\Eudora.ini",
						   szVerz, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(strcmp(szVerz, "C:\\Temp\\E131\\MAILVE~1") == 0, szVerz);
		TT_CHECK_MSG(strcmp(szIni, "C:\\Temp\\E131\\MAILVE~1\\Eudora.ini") == 0, szIni);

		// Lange Namen kommen in Anfuehrungszeichen - dieselbe Regel wie in
		// GetDirs() (fileutil.cpp:432).
		E132AufrufZerlegen("\"C:\\Mein Mail\" \"C:\\Mein Mail\\Eudora.ini\"",
						   szVerz, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(strcmp(szVerz, "C:\\Mein Mail") == 0, szVerz);
		TT_CHECK_MSG(strcmp(szIni, "C:\\Mein Mail\\Eudora.ini") == 0, szIni);

		// Nur ein Pfad, ohne INI-Angabe: dann bleibt der INI-Teil leer.
		E132AufrufZerlegen("C:\\Temp\\E131\\MAILVE~1",
						   szVerz, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(strcmp(szVerz, "C:\\Temp\\E131\\MAILVE~1") == 0, szVerz);
		TT_CHECK_MSG(szIni[0] == 0, "kein INI-Teil");

		// Leer und NULL duerfen nichts anstellen.
		E132AufrufZerlegen(NULL, szVerz, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(szVerz[0] == 0 && szIni[0] == 0, "NULL");
		E132AufrufZerlegen("", szVerz, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(szVerz[0] == 0 && szIni[0] == 0, "leer");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (7)
	// Beide Teile zusammen, so wie es in StartEudoraWithDefaultLocation
	// ablaeuft: zerlegen, dann entscheiden. Das ist der Weg, der am
	// 20.10.2026 stumm blieb.
	TT_BeginTest("E-132: zerlegt und entschieden - der gemeldete Fall");
	{
		TCHAR szVerz[MAX_PATH + 1];
		TCHAR szIni[MAX_PATH + 1];

		E132AufrufZerlegen("C:\\Temp\\E131\\MAILVE~1 C:\\Temp\\E131\\MAILVE~1\\Eudora.ini",
						   szVerz, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(E132IstFremdesVerzeichnis(szVerz, "C:\\Temp\\E132\\", true),
			"fremde Installation, Einrichtung vorhanden");

		// Gegenprobe: zeigt die Registry auf das eigene Paket, bleibt es still.
		E132AufrufZerlegen("C:\\Temp\\E132\\MAILVE~1 C:\\Temp\\E132\\MAILVE~1\\Eudora.ini",
						   szVerz, MAX_PATH + 1, szIni, MAX_PATH + 1);
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis(szVerz, "C:\\Temp\\E132\\", true),
			"eigenes Paket - keine Rueckfrage");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (8)
	// GREGORS LAUF VOM 21.10.2026. Er hat die Rueckfrage am gebauten
	// 1.0.114 ausgeloest, und im Fenster stand
	//
	//   C:\Users\Gregor\EUDORA~1.113\MAILVE~1
	//
	// Das ist die 8.3-Kurzform: Eudora schreibt sie so in die Registry
	// (GetShortPathName), waehrend ExecutableDir aus GetModuleFileName lang
	// ist. Der Praefixvergleich schlaegt dann fehl, und Eudora haelt sein
	// EIGENES Verzeichnis fuer fremd - bei jedem Doppelklick.
	//
	// Mein Pruefstand lag in C:\Temp\E132. Dieser Pfad ist zu kurz fuer
	// einen 8.3-Alias, deshalb ist der Fehler durch alle drei Messungen
	// gekommen. Ein zu bequemer Pruefstand misst den Fehler weg.
	//
	// Aufgeloest wird im Aufrufer (E132LangerPfad), damit diese Funktion
	// ohne Win32 bleibt. Hier wird geprueft, dass sie mit AUFGELOESTEN
	// Pfaden das Richtige tut - und mit unaufgeloesten das Falsche, denn
	// genau das war der Fehler.
	TT_BeginTest("E-132: Kurzform und Langform, der Fall vom 21.10.2026");
	{
		const char *LANG = "C:\\Users\\Gregor\\Eudora72-1.0.114-release\\";

		TT_CHECK_MSG(!E132IstFremdesVerzeichnis(
				"C:\\Users\\Gregor\\Eudora72-1.0.114-release\\Mailverzeichnis",
				LANG, true),
			"aufgeloest: das eigene Verzeichnis ist nicht fremd");

		// Der Fehlerstand, zum Festhalten: ohne Aufloesung meldet dieselbe
		// Funktion fremd - sie kann es nicht anders wissen.
		TT_CHECK_MSG(E132IstFremdesVerzeichnis(
				"C:\\Users\\Gregor\\EUDORA~1.114\\MAILVE~1", LANG, true),
			"unaufgeloest: die Kurzform sieht fremd aus - deshalb der Aufrufer");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (9)
	// Der umgekehrte Falschalarm, beim Aufraeumen des obigen gefunden:
	// "C:\Eudora2" faengt mit "C:\Eudora" an. Ohne Pruefung auf die Grenze
	// haelt die Entscheidung das zweite fuer ein Unterverzeichnis des
	// ersten und meldet "gehoert uns" - dann kaeme bei einem echten
	// Nachbarverzeichnis KEINE Rueckfrage, und genau davor soll sie
	// schuetzen.
	TT_BeginTest("E-132: der Praefix allein genuegt nicht");
	{
		TT_CHECK_MSG(E132IstFremdesVerzeichnis("C:\\Eudora2\\Mail", "C:\\Eudora", true),
			"C:\\Eudora2 ist NICHT unterhalb von C:\\Eudora");
		TT_CHECK_MSG(E132IstFremdesVerzeichnis("C:\\Eudora2\\Mail", "C:\\Eudora\\", true),
			"dasselbe mit abschliessendem Rueckstrich");

		// Die Gegenprobe: echte Unterverzeichnisse bleiben eigene.
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Eudora\\Mail", "C:\\Eudora", true),
			"echtes Unterverzeichnis");
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Eudora", "C:\\Eudora", true),
			"genau dasselbe Verzeichnis");
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Eudora\\Mail", "C:\\Eudora\\", true),
			"mit abschliessendem Rueckstrich");

		// PRUEFER-42 K6: DIE Form, fuer die PRUEFER-41 K13 geschrieben
		// wurde, stand in keinem Test - Kandidat OHNE, Eigenes MIT
		// Rueckstrich. Genau so liefern die beiden Seiten es:
		// RegisterCommandLine streicht den Rueckstrich vor dem Schreiben
		// (eudora.cpp:3681-3684), GetDirs haengt ihn an ExecutableDir an
		// (fileutil.cpp:435). Liegt das Mailverzeichnis IM
		// Programmverzeichnis - der gewoehnliche Eudora-Aufbau mit der
		// Eudora.ini neben der EXE -, dann sind beide Pfade dasselbe
		// Verzeichnis und unterscheiden sich NUR im Rueckstrich.
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Eudora", "C:\\Eudora\\", true),
			"Registry ohne Rueckstrich gegen ExecutableDir mit - dasselbe Verzeichnis");
		TT_CHECK_MSG(!E132IstFremdesVerzeichnis("C:\\Eudora\\", "C:\\Eudora", true),
			"und andersherum");
	}
	TT_EndTest();
}
