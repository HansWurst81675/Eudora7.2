//
// TinyTest.cpp - Umsetzung des winzigen Zusicherungs-Geruests
//
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

#include "TinyTest.h"

static int	s_iTests       = 0;		// Tests insgesamt
static int	s_iFailedTests = 0;		// davon fehlgeschlagen
static int	s_iChecksFailed= 0;		// Abweichungen im laufenden Test
static int	s_iPrinted     = 0;		// bereits ausgegebene Abweichungen im laufenden Test
static char	s_szCurrent[160] = {0};

// Mehr als so viele Abweichungen pro Test werden nicht einzeln ausgegeben.
// Ueber die Umgebungsvariable EUDORA_TESTS_MAX_DETAILS aenderbar.
static int MaxDetailsPerTest(void)
{
	static int s_iMax = -1;
	if (s_iMax < 0)
	{
		const char* szEnv = getenv("EUDORA_TESTS_MAX_DETAILS");
		s_iMax = (szEnv && *szEnv) ? atoi(szEnv) : 16;
		if (s_iMax < 1) s_iMax = 1;
	}
	return s_iMax;
}

void TT_Suite(const char* szName)
{
	printf("\n===============================================================\n");
	printf(" %s\n", szName);
	printf("===============================================================\n");
}

void TT_BeginTest(const char* szName)
{
	strncpy(s_szCurrent, szName, sizeof(s_szCurrent) - 1);
	s_szCurrent[sizeof(s_szCurrent) - 1] = '\0';
	s_iChecksFailed = 0;
	s_iPrinted = 0;
	++s_iTests;
}

void TT_EndTest(void)
{
	if (s_iChecksFailed == 0)
	{
		printf("[ok  ] %s\n", s_szCurrent);
	}
	else
	{
		++s_iFailedTests;
		printf("       ^-- FEHLGESCHLAGEN: %d Abweichung(en)\n", s_iChecksFailed);
	}
	s_szCurrent[0] = '\0';
}

void TT_Fail(const char* szFormat, ...)
{
	++s_iChecksFailed;
	if (s_iChecksFailed == 1)
	{
		printf("[FEHL] %s\n", s_szCurrent);
	}
	if (s_iPrinted < MaxDetailsPerTest())
	{
		va_list args;
		++s_iPrinted;
		printf("         ");
		va_start(args, szFormat);
		vprintf(szFormat, args);
		va_end(args);
		printf("\n");
	}
	else if (s_iPrinted == MaxDetailsPerTest())
	{
		++s_iPrinted;
		printf("         ... weitere Abweichungen unterdrueckt\n");
	}
}

void TT_Note(const char* szFormat, ...)
{
	va_list args;
	printf("         > ");
	va_start(args, szFormat);
	vprintf(szFormat, args);
	va_end(args);
	printf("\n");
}

int TT_Summary(void)
{
	printf("\n===============================================================\n");
	printf(" Ergebnis: %d Tests, %d bestanden, %d fehlgeschlagen\n",
		   s_iTests, s_iTests - s_iFailedTests, s_iFailedTests);
	printf("===============================================================\n");
	return s_iFailedTests;
}
