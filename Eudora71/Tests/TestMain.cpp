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

#include "TinyTest.h"

void RunXlateTableTests(const char* szEudoraDir);
void RunIsoTranslateTests(void);
void RunHexBinTableTests(void);
void RunPopEmpfangTests(const char* szEudoraDir);

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
	RunPopEmpfangTests(szEudoraDir);

	iFailed = TT_Summary();
	return iFailed;
}
