//
// TestMain.cpp - Einsprungpunkt des Testprogramms
//
// Konsolenanwendung. Rueckgabewert = Anzahl der fehlgeschlagenen Tests,
// damit ein Aufrufer (Skript, CI) das Ergebnis auswerten kann.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <string.h>
#include <crtdbg.h>

#include "TinyTest.h"

void RunXlateTableTests(const char* szEudoraDir);
void RunIsoTranslateTests(void);
void RunHexBinTableTests(void);
void RunOTShimBildTests(void);
void RunOTShimReiterTests(void);
void RunOTShimPaletteTests(void);
void RunOTShimAndockenTests(void);
void RunPopEmpfangTests(const char* szEudoraDir);
void RunSymboleTests(void);
void RunE88Tests(void);
void RunE89Tests(void);
void RunE101Tests(void);
void RunResolveURLTests(void);
void RunE112Tests(void);
void RunE69Tests(void);
void RunE131Tests(void);
void RunE132Tests(void);
void RunE112MetadateiTests(void);
void RunE105Tests(void);
void RunE116Tests(void);
void RunE118Tests(void);
void RunE24Tests(const char* szEudoraDir);
void RunZeichenWegeTests(const char* szEudoraDir);
void RunStartWegeTests(const char* szEudoraDir);
void RunE125Tests(const char* szEudoraDir);
void RunE130Tests(const char* szEudoraDir);
void RunE113Tests(void);
void RunE77Tests(void);
void RunSpeicherfehlerTests(const char* szEudoraDir);
void RunE137Tests(const char* szEudoraDir);
void RunAusnahmeSpurTests(const char* szEudoraDir);
void RunE142Tests(const char* szEudoraDir);
void RunRootCertsLogTests(const char* szEudoraDir);
void RunE146Tests(const char* szEudoraDir);
void RunE119Tests(const char* szEudoraDir);
void RunE77QuelltextTests(const char* szEudoraDir);
void RunStartfehlerTests(const char* szEudoraDir);
void RunE148Tests(const char* szEudoraDir);

//
// Ermittelt Eudora71\Eudora aus dem Ablageort des Testprogramms.
// Das Programm liegt in Eudora71\Tests\Build\<Konfiguration>\, das
// Quellverzeichnis also drei Ebenen darueber neben Tests.
//
static void GuessEudoraDir(const char* szExePath, char* szOut, size_t nOut)
{
	char szDir[1024];
	char* p;
	int i;

	strncpy(szDir, szExePath, sizeof(szDir) - 1);
	szDir[sizeof(szDir) - 1] = 0;

	// Dateiname und drei Verzeichnisebenen abschneiden -> Eudora71\Tests\..
	for (i = 0; i < 4; ++i)
	{
		p = strrchr(szDir, '\\');
		if (!p) p = strrchr(szDir, '/');
		if (!p) { szDir[0] = 0; break; }
		*p = 0;
	}

	if (szDir[0])
		_snprintf(szOut, nOut - 1, "%s\\Eudora", szDir);
	else
		_snprintf(szOut, nOut - 1, "..\\Eudora");
	szOut[nOut - 1] = 0;
}

int main(int argc, char* argv[])
{
	char szEudoraDir[1024];
	int iFailed;

	// KEIN Testlauf darf ein Fenster oeffnen. Eine fehlgeschlagene
	// Zusicherung aus MFC oder der Laufzeitbibliothek wuerde sonst einen
	// modalen Dialog aufmachen und den Lauf anhalten - in einem
	// Agentenlauf oder auf einem Bauserver haengt das Programm dann bis
	// zum Zeitlimit. Alles geht statt dessen nach stderr.
	// Die Ausgabe wird nicht gepuffert. Bleibt ein Test haengen, steht
	// damit im Protokoll, WELCHER es war - mit Blockpufferung fehlen die
	// letzten Zeilen bis zur 4-KB-Grenze, und die Suche beginnt bei null
	// (gemessen am 22.10.2026).
	setvbuf(stdout, NULL, _IONBF, 0);

	_CrtSetReportMode(_CRT_ASSERT, _CRTDBG_MODE_FILE);
	_CrtSetReportFile(_CRT_ASSERT, _CRTDBG_FILE_STDERR);
	_CrtSetReportMode(_CRT_ERROR,  _CRTDBG_MODE_FILE);
	_CrtSetReportFile(_CRT_ERROR,  _CRTDBG_FILE_STDERR);
	_CrtSetReportMode(_CRT_WARN,   _CRTDBG_MODE_FILE);
	_CrtSetReportFile(_CRT_WARN,   _CRTDBG_FILE_STDERR);
	_set_abort_behavior(0, _WRITE_ABORT_MSG | _CALL_REPORTFAULT);
	::SetErrorMode(SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX);

	if (argc > 1)
	{
		strncpy(szEudoraDir, argv[1], sizeof(szEudoraDir) - 1);
		szEudoraDir[sizeof(szEudoraDir) - 1] = 0;
	}
	else
	{
		GuessEudoraDir(argv[0], szEudoraDir, sizeof(szEudoraDir));
	}

	// MFC braucht diese Initialisierung, bevor CString benutzt wird.
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		fprintf(stderr, "AfxWinInit fehlgeschlagen\n");
		return 100;
	}

	printf("Eudora 7.1 - Testlauf fuer die pruefbaren Inseln\n");
	printf("Quellverzeichnis: %s\n", szEudoraDir);

	RunXlateTableTests(szEudoraDir);
	RunIsoTranslateTests();
	RunHexBinTableTests();
	RunOTShimBildTests();
	RunOTShimReiterTests();
	RunOTShimPaletteTests();
	RunOTShimAndockenTests();
	RunPopEmpfangTests(szEudoraDir);
	RunSymboleTests();
	RunE88Tests();
	RunE89Tests();
	RunE101Tests();
	RunResolveURLTests();
	RunE112Tests();
	RunE69Tests();
	RunE131Tests();
	RunE132Tests();
	RunE112MetadateiTests();
	RunE105Tests();
	RunE116Tests();
	RunE113Tests();
	RunE77Tests();
	RunE118Tests();
	RunE24Tests(szEudoraDir);
	RunZeichenWegeTests(szEudoraDir);
	RunStartWegeTests(szEudoraDir);
	RunE125Tests(szEudoraDir);
	RunE130Tests(szEudoraDir);
	RunSpeicherfehlerTests(szEudoraDir);
	RunE137Tests(szEudoraDir);
	RunAusnahmeSpurTests(szEudoraDir);
	RunE142Tests(szEudoraDir);
	RunRootCertsLogTests(szEudoraDir);
	RunE146Tests(szEudoraDir);
	RunE119Tests(szEudoraDir);
	RunE77QuelltextTests(szEudoraDir);
	RunStartfehlerTests(szEudoraDir);
	RunE148Tests(szEudoraDir);

	iFailed = TT_Summary();
	return iFailed;
}
