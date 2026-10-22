//
// TestStartWege.cpp - drei Befunde aus dem Programmstart
//
//   E-11  ReleaseBuffer ohne GetBuffer in eudora.cpp - Absturz bei jeder
//         frischen Installation
//   E-12  "Eudora.exe Mailverzeichnis" hielt das Verzeichnis fuer den Namen
//         der Ini-Datei - Kontodaten wurden weder gelesen noch geschrieben
//   E-17  der Kontoassistent startete bei jedem Start, obwohl ein Konto
//         eingerichtet war
//
// WAS HIER WIE GEPRUEFT WIRD, und das gehoert in den Testnamen und nicht ins
// Kleingedruckte:
//
//   * E-11 wird als VERHALTEN geprueft. Die Behebung ist CString::Truncate
//     statt ReleaseBuffer(n), und dass das den Unterschied macht, laesst
//     sich an MFC selbst zeigen: Truncate loest den geteilten Puffer, die
//     zweite Kopie bleibt heil.
//   * E-12 und E-17 sitzen mitten in GetDirs bzw. InitInstance, zwischen
//     Registry, Ressourcen und Fenstern. Sie lassen sich nicht herausloesen
//     und aufrufen. Geprueft wird deshalb zweierlei: die STELLE im Quelltext
//     (steht die Behebung noch da, ist der alte Stand weg?) und die
//     Windows-Tatsachen, auf denen die Behebung beruht - gemessen, nicht
//     behauptet. Der Rest steht im Testplan und wird von Hand gefahren.
//
#include <afx.h>
#include <afxwin.h>
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

// ---------------------------------------------------------------------------
// Ein eigenes Spielverzeichnis unter %TEMP%. Es wird am Ende wieder geraeumt;
// angefasst wird nichts ausserhalb.
// ---------------------------------------------------------------------------

static int SpielverzeichnisAnlegen(char* szAus, size_t nAus, const char* szKennung)
{
	char	szTemp[MAX_PATH + 1];
	DWORD	dwLen = ::GetTempPathA(sizeof(szTemp), szTemp);

	if (dwLen == 0 || dwLen >= sizeof(szTemp))
		return 0;

	_snprintf(szAus, nAus - 1, "%sEudoraTests-%s-%lu", szTemp, szKennung,
			  (unsigned long)::GetCurrentProcessId());
	szAus[nAus - 1] = 0;

	if (::CreateDirectoryA(szAus, NULL))
		return 1;

	// Ein Rest aus einem frueheren Lauf ist kein Grund abzubrechen.
	return (::GetLastError() == ERROR_ALREADY_EXISTS) ? 1 : 0;
}

static int DateiSchreiben(const char* szPfad, const char* szInhalt)
{
	FILE*	f = fopen(szPfad, "wb");

	if (!f)
		return 0;
	fputs(szInhalt, f);
	fclose(f);
	return 1;
}

// ===========================================================================
// E-11 - ReleaseBuffer ohne GetBuffer
// ===========================================================================
//
// eudora.cpp:3371 (alter Stand):
//
//     int i = RegMailto.Find('\\');
//     if (i >= 0)
//         RegMailto.ReleaseBuffer(i);
//
// RegMailto ist eine CRString, also aus einer Ressource geladen. Unter VC6
// war ReleaseBuffer(n) ohne vorangehendes GetBuffer gutmuetig: CString hielt
// einen eigenen Puffer, und ReleaseBuffer setzte die Laenge. Unter MFC 14 ist
// CString ein CStringT mit Referenzzaehlung - ReleaseBuffer(n) ist ein
// SetLength(n) OHNE Fork und schreibt in die gemeinsame Verwaltung. Gregors
// eudora.log endete in beiden Sitzungen drei Zeilen danach.

static void Test_E11_TruncateLaesstDieGeteilteKopieHeil(void)
{
	// Der Registryschluessel, um den es geht: "mailto\\shell\\open\\command".
	// Gekuerzt werden soll er auf "mailto".
	static const char	szVoll[] = "mailto\\shell\\open\\command";

	CString		strEins(szVoll);
	CString		strZwei(strEins);		// MFC teilt hier den Puffer, kopiert nicht
	int			i;

	TT_BeginTest("E-11: Truncate kuerzt und laesst die geteilte Kopie heil");

	i = strEins.Find('\\');
	TT_CHECK_MSG(i == 6, "der erste Rueckstrich steht hinter \"mailto\"");

	strEins.Truncate(i);

	// 1. Gekuerzt wird richtig - Byte fuer Byte.
	TT_CHECK(strEins.GetLength() == 6);
	TT_CHECK_MSG(strcmp((LPCTSTR)strEins, "mailto") == 0, "gekuerzt auf \"mailto\"");

	// 2. UND DAS IST DIE GEGENPROBE: die zweite Kopie zeigte vor dem Kuerzen
	//    in denselben Puffer. ReleaseBuffer(6) haette ihn mitgekuerzt - genau
	//    das ist der Schaden aus E-11. Truncate loest ihn vorher.
	TT_CHECK_MSG(strZwei.GetLength() == (int)(sizeof(szVoll) - 1),
				 "die geteilte Kopie darf nicht mitgekuerzt werden");
	TT_CHECK_MSG(strcmp((LPCTSTR)strZwei, szVoll) == 0,
				 "die geteilte Kopie muss Byte fuer Byte dieselbe sein");

	// 3. Der Rand: kein Rueckstrich im Namen, dann wird nicht gekuerzt.
	{
		CString	strOhne("mailto");
		TT_CHECK(strOhne.Find('\\') < 0);
	}

	TT_EndTest();
}

// Zaehlt ReleaseBuffer-Aufrufe mit einer Laengenangabe. ReleaseBuffer() und
// ReleaseBuffer(-1) sind die zulaessigen Formen; jede andere Zahl kuerzt und
// ist damit die gefaehrliche Form aus R-1.
static int ZaehleReleaseBufferMitLaenge(const char* pCode)
{
	int			iZahl = 0;
	const char*	p = pCode;

	while ((p = strstr(p, "ReleaseBuffer(")) != 0)
	{
		const char*	pArg = p + strlen("ReleaseBuffer(");

		while (*pArg == ' ')
			++pArg;

		if (*pArg != ')' && !(pArg[0] == '-' && pArg[1] == '1' && (pArg[2] == ')' || pArg[2] == ' ')))
			++iZahl;

		p += strlen("ReleaseBuffer(");
	}
	return iZahl;
}

static void Test_E11_DieStelle(const char* szEudoraDir)
{
	char*	pCode = QT_LiesNurCode(szEudoraDir, "eudora.cpp");
	int		iRest;

	TT_BeginTest("E-11: RegMailto wird mit Truncate gekuerzt, nicht mit ReleaseBuffer");

	if (!pCode)
	{
		TT_Fail("eudora.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	TT_CHECK_MSG(QT_Enthaelt(pCode, "RegMailto.Truncate(i);"),
				 "die Behebung aus E-11 steht nicht mehr da");
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "RegMailto.ReleaseBuffer"),
				 "der alte Stand ist zurueckgekommen");

	// R-1 ist die Fehlerklasse hinter E-11 und ausdruecklich NOCH OFFEN:
	// 21 Stellen im ganzen Baum, davon zwei in eudora.cpp selbst
	// (RegClientsMail und EudoraOption, in derselben Funktion wie der
	// E-11-Absturz). Diese Schranke laesst nur die Richtung nach unten zu:
	// werden es mehr, ist eine neue dazugekommen.
	iRest = ZaehleReleaseBufferMitLaenge(pCode);
	TT_Note("eudora.cpp: noch %d ReleaseBuffer(<Laenge>) offen (R-1)", iRest);
	TT_CHECK_MSG(iRest <= 2, "in eudora.cpp ist eine neue ReleaseBuffer(<Laenge>)-Stelle dazugekommen");

	free(pCode);
	TT_EndTest();
}

// ===========================================================================
// E-12 - das Mailverzeichnis wurde fuer einen Ini-Dateinamen gehalten
// ===========================================================================
//
// Gregor startete mit "Eudora.exe Mailverzeichnis". Der Name hat keinen
// Rueckstrich und kein ':' an zweiter Stelle, also hielt GetDirs ihn fuer
// einen Ini-Dateinamen. INIPath wurde damit zu
// "...\Eudora72-1.0.4-release\Mailverzeichnis" - einem VERZEICHNIS. Jeder
// Lesezugriff lieferte danach die Vorgabe, jeder Schreibzugriff verpuffte,
// ohne eine einzige Fehlermeldung.

static void Test_E12_VerzeichnisAlsIniLiefertNurVorgaben(void)
{
	char	szDir[MAX_PATH + 1];
	char	szIni[MAX_PATH + 1];
	char	szWert[256];
	DWORD	dwLen;

	TT_BeginTest("E-12: ein Verzeichnis als Ini-Pfad liefert jede Einstellung als Vorgabe");

	if (!SpielverzeichnisAnlegen(szDir, sizeof(szDir), "E12a"))
	{
		TT_Fail("Spielverzeichnis unter %%TEMP%% nicht anlegbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	_snprintf(szIni, sizeof(szIni) - 1, "%s\\Eudora.ini", szDir);
	szIni[sizeof(szIni) - 1] = 0;
	DateiSchreiben(szIni, "[Settings]\r\nRealName=hans wurst\r\n");

	// 1. Gegen die richtige Datei kommt der richtige Wert.
	memset(szWert, 0, sizeof(szWert));
	dwLen = ::GetPrivateProfileStringA("Settings", "RealName", "<VORGABE>",
									   szWert, sizeof(szWert), szIni);
	TT_CHECK_MSG(dwLen == 10, "\"hans wurst\" sind 10 Zeichen");
	TT_CHECK_MSG(strcmp(szWert, "hans wurst") == 0, "gegen die Datei kommt der echte Wert");

	// 2. Gegen das VERZEICHNIS - genau der Pfad, den Eudora errechnete -
	//    kommt wortlos die Vorgabe. Fuer Eudoras Kontofelder ist die
	//    Vorgabe die leere Zeichenkette: leerer Dialog, kein Mailabruf,
	//    keine Fehlermeldung.
	memset(szWert, 0, sizeof(szWert));
	::GetPrivateProfileStringA("Settings", "RealName", "<VORGABE>",
							   szWert, sizeof(szWert), szDir);
	TT_CHECK_MSG(strcmp(szWert, "<VORGABE>") == 0,
				 "gegen ein Verzeichnis liefert Windows wortlos die Vorgabe");

	memset(szWert, 0, sizeof(szWert));
	::GetPrivateProfileStringA("Settings", "RealName", "",
							   szWert, sizeof(szWert), szDir);
	TT_CHECK_MSG(szWert[0] == 0, "mit leerer Vorgabe kommt eine leere Zeichenkette");

	// 3. Und der Schreibzugriff verpufft.
	TT_CHECK_MSG(::WritePrivateProfileStringA("Settings", "RealName", "neu", szDir) == FALSE,
				 "in ein Verzeichnis laesst sich nichts schreiben");

	::DeleteFileA(szIni);
	::RemoveDirectoryA(szDir);
	TT_EndTest();
}

static void Test_E12_DateisystemUnterscheidetWasDerNameNichtHergibt(void)
{
	char	szDir[MAX_PATH + 1];
	char	szIni[MAX_PATH + 1];
	DWORD	dwAttr;

	TT_BeginTest("E-12: GetFileAttributes trennt Verzeichnis und Dateiname");

	if (!SpielverzeichnisAnlegen(szDir, sizeof(szDir), "E12b"))
	{
		TT_Fail("Spielverzeichnis unter %%TEMP%% nicht anlegbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	_snprintf(szIni, sizeof(szIni) - 1, "%s\\Eudora.ini", szDir);
	szIni[sizeof(szIni) - 1] = 0;
	DateiSchreiben(szIni, "[Settings]\r\n");

	// Das ist die Frage, die die Behebung jetzt stellt, BEVOR sie raet.
	dwAttr = ::GetFileAttributesA(szDir);
	TT_CHECK(dwAttr != INVALID_FILE_ATTRIBUTES);
	TT_CHECK_MSG((dwAttr & FILE_ATTRIBUTE_DIRECTORY) != 0, "ein Verzeichnis ist ein Verzeichnis");

	dwAttr = ::GetFileAttributesA(szIni);
	TT_CHECK(dwAttr != INVALID_FILE_ATTRIBUTES);
	TT_CHECK_MSG((dwAttr & FILE_ATTRIBUTE_DIRECTORY) == 0, "eine Ini-Datei ist keines");

	// Gegenprobe: was es nicht gibt, ist kein Verzeichnis - der Fall
	// "Argument ist wirklich ein Ini-Dateiname" bleibt damit erhalten.
	{
		char	szWeg[MAX_PATH + 1];
		_snprintf(szWeg, sizeof(szWeg) - 1, "%s\\gibtsnicht.ini", szDir);
		szWeg[sizeof(szWeg) - 1] = 0;
		TT_CHECK(::GetFileAttributesA(szWeg) == INVALID_FILE_ATTRIBUTES);
	}

	::DeleteFileA(szIni);
	::RemoveDirectoryA(szDir);
	TT_EndTest();
}

static void Test_E12_LaufwerksrelativerPfad(void)
{
	char	szLang[MAX_PATH + 1];
	char	szVoll[MAX_PATH + 1];
	char*	pDatei = NULL;
	DWORD	dwRet;

	TT_BeginTest("E-12: \"C:Name\" ist nicht absolut - GetLongPathName merkt das nicht");

	// Der zweite, verdeckte Teil von E-12. CheckMailDirectory baute aus
	// einem Pfad ohne Laufwerksbuchstaben "C:Mailverzeichnis" zusammen und
	// hielt ihn fuer absolut. Das ist er nicht: Windows loest ihn gegen das
	// aktuelle Verzeichnis von Laufwerk C auf. Ein einziger
	// Datei-Oeffnen-Dialog genuegt, und die Einstellungen werden ab da aus
	// einer anderen Datei gelesen und in eine andere geschrieben - lautlos.
	memset(szLang, 0, sizeof(szLang));
	dwRet = ::GetLongPathNameA("C:Mailverzeichnis", szLang, sizeof(szLang));
	if (dwRet > 0 && dwRet < sizeof(szLang))
	{
		TT_CHECK_MSG(strcmp(szLang, "C:Mailverzeichnis") == 0,
					 "GetLongPathName macht daraus nichts Absolutes");
	}
	else
	{
		// Auch das ist das gemessene Verhalten: es macht nichts daraus.
		TT_Note("GetLongPathName(\"C:Mailverzeichnis\") lieferte %lu", (unsigned long)dwRet);
	}

	// Und das ist das Mittel, das die Behebung einsetzt.
	memset(szVoll, 0, sizeof(szVoll));
	dwRet = ::GetFullPathNameA("C:Mailverzeichnis", sizeof(szVoll), szVoll, &pDatei);
	TT_CHECK(dwRet > 0 && dwRet < sizeof(szVoll));
	TT_CHECK_MSG(szVoll[0] != 0 && szVoll[1] == ':' && szVoll[2] == '\\',
				 "GetFullPathName liefert einen echten absoluten Pfad");
	TT_CHECK_MSG(strcmp(szVoll, "C:Mailverzeichnis") != 0,
				 "und er ist ein anderer als der laufwerksrelative");

	TT_EndTest();
}

static void Test_E12_DieStellen(const char* szEudoraDir)
{
	char*	pFile = QT_LiesNurCode(szEudoraDir, "fileutil.cpp");
	char*	pRs   = QT_LiesNurCode(szEudoraDir, "rs.cpp");
	char*	pIni  = NULL;

	TT_BeginTest("E-12: GetDirs fragt das Dateisystem, bevor es den Namen deutet");

	if (!pFile || !pRs)
	{
		TT_Fail("fileutil.cpp oder rs.cpp nicht lesbar - ungeprueft ist nicht gruen");
		free(pFile);
		free(pRs);
		TT_EndTest();
		return;
	}

	// 1. Der Kommandozeilenzweig - Gregors Fall.
	TT_CHECK_MSG(QT_Enthaelt(pFile, "if (!Ini && !bCmdLineIsDir && (!strchr(CmdLine, SLASH) && CmdLine[1] != ':'))"),
				 "die Ini-Vermutung muss hinter der Verzeichnisfrage stehen");

	// 2. Der Umgebungsvariablenzweig - derselbe Fehler, dieselbe Behebung.
	//    Arbeitsweise/fund-ganz-abhaken.md: nur eine Richtung zu beheben
	//    laesst die andere offen.
	TT_CHECK_MSG(QT_Enthaelt(pFile, "if (!bEnvIsDir && (!strchr(temp, SLASH) && temp[1] != ':'))"),
				 "der Weg ueber die Umgebungsvariable ist wieder ungeschuetzt");

	TT_CHECK_MSG(QT_Zaehle(pFile, "FILE_ATTRIBUTE_DIRECTORY") >= 2,
				 "beide Zweige muessen das Dateisystem fragen");

	// 3. Der laufwerksrelative Pfad, in beiden Dateien.
	TT_CHECK_MSG(QT_Enthaelt(pFile, "GetFullPathName"),
				 "CheckMailDirectory muss den Pfad wirklich aufloesen");

	pIni = QT_Abschnitt(pRs, "int SetupINIFilename(", "ConvertIni(");
	TT_CHECK_MSG(pIni != 0, "SetupINIFilename nicht gefunden");
	if (pIni)
	{
		TT_CHECK_MSG(QT_Enthaelt(pIni, "GetFullPathName"),
					 "SetupINIFilename haelt \"C:Name\\Eudora.ini\" sonst fuer absolut");
		free(pIni);
	}

	free(pFile);
	free(pRs);
	TT_EndTest();
}

// ===========================================================================
// E-17 - der Kontoassistent startete bei jedem Start
// ===========================================================================
//
// Gregor am 05.09.2026: "beim starten wird immer wieder der wizard
// gestartet, obwohl ich bereits ein konto eingerichtet habe." Die
// Startpruefung sah nur die dominante Persoenlichkeit, also [Settings]. Sein
// Konto stand in [Persona-hans wurst].

static void Test_E17_GregorsIniIstDieLage(void)
{
	// Die Datenprobe zu E-17: Gregors Ini, nachgebaut aus dem Auszug in
	// Befunde/PERSONA.md. Sie zeigt, WARUM die alte Pruefung scheiterte -
	// und sie ist zugleich die Eingabe fuer den Handtest im Testplan.
	//
	// Geprueft wird hier nicht Eudora, sondern die Lage. Der Code dazu
	// steht in AnyPersonalityHasAccount und haengt an g_Personalities; den
	// prueft der Test darunter an seiner Stelle.
	char	szDir[MAX_PATH + 1];
	char	szIni[MAX_PATH + 1];
	char	szWert[256];

	TT_BeginTest("E-17: in Gregors Ini ist [Settings] leer und das Konto benannt");

	if (!SpielverzeichnisAnlegen(szDir, sizeof(szDir), "E17"))
	{
		TT_Fail("Spielverzeichnis unter %%TEMP%% nicht anlegbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	_snprintf(szIni, sizeof(szIni) - 1, "%s\\Eudora.ini", szDir);
	szIni[sizeof(szIni) - 1] = 0;

	DateiSchreiben(szIni,
		"[Settings]\r\n"
		"POPAccount=\r\n"
		"RealName=\r\n"
		"ReturnAddress=\r\n"
		"\r\n"
		"[Personalities]\r\n"
		"Persona0=Persona-hans wurst\r\n"
		"\r\n"
		"[Persona-hans wurst]\r\n"
		"POPAccount=konto-freenet@gregor.invalid@mx.freenet.de\r\n"
		"RealName=konto-freenet@gregor.invalid\r\n"
		"ReturnAddress=konto-freenet@gregor.invalid\r\n");

	// 1. Was GetReturnAddress() sah: nichts.
	memset(szWert, 0, sizeof(szWert));
	::GetPrivateProfileStringA("Settings", "ReturnAddress", "", szWert, sizeof(szWert), szIni);
	TT_CHECK_MSG(szWert[0] == 0, "[Settings] ReturnAddress ist leer - daher der Assistent");

	memset(szWert, 0, sizeof(szWert));
	::GetPrivateProfileStringA("Settings", "POPAccount", "", szWert, sizeof(szWert), szIni);
	TT_CHECK_MSG(szWert[0] == 0, "[Settings] POPAccount ist ebenfalls leer");

	// 2. Was dort trotzdem steht: ein vollstaendiges Konto, eine Zeile
	//    tiefer. Genau danach muss die Startpruefung fragen.
	memset(szWert, 0, sizeof(szWert));
	::GetPrivateProfileStringA("Personalities", "Persona0", "", szWert, sizeof(szWert), szIni);
	TT_CHECK_MSG(strcmp(szWert, "Persona-hans wurst") == 0, "die benannte Persoenlichkeit ist eingetragen");

	memset(szWert, 0, sizeof(szWert));
	::GetPrivateProfileStringA("Persona-hans wurst", "ReturnAddress", "", szWert, sizeof(szWert), szIni);
	TT_CHECK_MSG(strcmp(szWert, "konto-freenet@gregor.invalid") == 0,
				 "das Konto steht in [Persona-hans wurst]");

	// 3. Gegenprobe: eine Ini ganz ohne Konto. Dort MUSS der Assistent
	//    kommen - eine Behebung, nach der er nie mehr erscheint, waere
	//    ebenso falsch. Eigene Datei, weil Windows die zuletzt gelesene
	//    Ini zwischenspeichert und unser Schreibzugriff daran vorbeigeht.
	{
		char	szLeer[MAX_PATH + 1];

		_snprintf(szLeer, sizeof(szLeer) - 1, "%s\\OhneKonto.ini", szDir);
		szLeer[sizeof(szLeer) - 1] = 0;
		DateiSchreiben(szLeer, "[Settings]\r\nReturnAddress=\r\n");

		memset(szWert, 0, sizeof(szWert));
		::GetPrivateProfileStringA("Personalities", "Persona0", "", szWert, sizeof(szWert), szLeer);
		TT_CHECK_MSG(szWert[0] == 0, "ohne Persoenlichkeiten gibt es nichts zu finden");

		memset(szWert, 0, sizeof(szWert));
		::GetPrivateProfileStringA("Settings", "ReturnAddress", "", szWert, sizeof(szWert), szLeer);
		TT_CHECK_MSG(szWert[0] == 0, "und [Settings] ist ebenfalls leer - der Assistent gehoert hierher");

		::DeleteFileA(szLeer);
	}

	::DeleteFileA(szIni);
	::RemoveDirectoryA(szDir);
	TT_EndTest();
}

static void Test_E17_DieStelle(const char* szEudoraDir)
{
	char*	pCode = QT_LiesNurCode(szEudoraDir, "eudora.cpp");
	char*	pFunk = NULL;

	TT_BeginTest("E-17: die Startpruefung fragt alle Persoenlichkeiten, nicht nur [Settings]");

	if (!pCode)
	{
		TT_Fail("eudora.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	// 1. Die alte Pruefung ist weg.
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "if (!ra || !*ra)"),
				 "die alte Pruefung auf die dominante Persoenlichkeit ist zurueck");

	// 2. Die neue steht da.
	TT_CHECK_MSG(QT_Enthaelt(pCode, "BOOL bHaveAccount = (ra && *ra) ? TRUE : AnyPersonalityHasAccount();"),
				 "die Startpruefung fragt nicht mehr nach benannten Persoenlichkeiten");
	TT_CHECK_MSG(QT_Enthaelt(pCode, "if (!bHaveAccount)"), "der Assistent haengt an bHaveAccount");

	// 3. Und der Tipp des Tages haengt an derselben Antwort. Haenge er
	//    weiter an ra allein, bliebe er fuer einen Anwender mit benannter
	//    Persoenlichkeit fuer immer aus.
	TT_CHECK_MSG(QT_Enthaelt(pCode, "if (bHaveAccount)"),
				 "der Tipp des Tages muss an derselben Antwort haengen");

	// 4. Die Funktion selbst: sie fragt beide Schluessel und laesst die
	//    dominante Persoenlichkeit aus, weil GetReturnAddress sie schon
	//    abgedeckt hat.
	pFunk = QT_Abschnitt(pCode, "static BOOL AnyPersonalityHasAccount()", "return FALSE; }");
	TT_CHECK_MSG(pFunk != 0, "AnyPersonalityHasAccount nicht gefunden");
	if (pFunk)
	{
		TT_CHECK(QT_Enthaelt(pFunk, "IDS_INI_PERSONA_RETURN_ADDR"));
		TT_CHECK(QT_Enthaelt(pFunk, "IDS_INI_PERSONA_POP_ACCOUNT"));
		TT_CHECK_MSG(QT_Enthaelt(pFunk, "g_Personalities.List()"),
					 "nur List() liest unmittelbar aus der Ini, ohne den Zwischenspeicher");
		TT_CHECK_MSG(QT_Enthaelt(pFunk, "IsDominant"),
					 "die dominante Persoenlichkeit wird uebersprungen");
		free(pFunk);
	}

	free(pCode);
	TT_EndTest();
}

// ===========================================================================

void RunStartWegeTests(const char* szEudoraDir)
{
	TT_Suite("E-11, E-12 und E-17: drei Befunde aus dem Programmstart");

	Test_E11_TruncateLaesstDieGeteilteKopieHeil();
	Test_E11_DieStelle(szEudoraDir);

	Test_E12_VerzeichnisAlsIniLiefertNurVorgaben();
	Test_E12_DateisystemUnterscheidetWasDerNameNichtHergibt();
	Test_E12_LaufwerksrelativerPfad();
	Test_E12_DieStellen(szEudoraDir);

	Test_E17_GregorsIniIstDieLage();
	Test_E17_DieStelle(szEudoraDir);
}
