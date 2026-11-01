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

//
// Die Notizen des laufenden Tests, bis sein NAME feststeht.
//
// Vorher hat TT_Note sofort gedruckt, der Name aber erst in TT_EndTest -
// jede Notiz stand damit im Protokoll unter dem Test DAVOR. Aufgefallen ist
// es am 17.09.2026 an den neuen Rumpf-Werten aus P-38: unter
// "P-21: gemischter Trenner" stand "rumpf-vorher=74 rumpf-nachher=55", und
// diese 74 Byte gehoeren zu "P-28: Marker und Text auf derselben Zeile"
// (74 - 8 fuer <x-html> - 9 fuer </x-html> - 2 fuer die Zeilenschaltung = 55).
//
// Wer ein Protokoll liest, um einen Verlust zu finden, las also die
// Spurmarke des falschen Testfalls - und genau dafuer sind diese Werte da
// (Arbeitsweise/anzeige-ist-kein-zustand.md).
//
static char	s_szNotes[8192] = {0};
static int	s_iNotesLen = 0;

static void NotizenAusgeben(void)
{
	if (s_iNotesLen > 0)
	{
		fputs(s_szNotes, stdout);
		s_szNotes[0] = '\0';
		s_iNotesLen  = 0;
	}
}

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

//
// OFFENER TEST (01.11.2026). Am 31.10.2026 waren neun neue Tests ohne
// TT_EndTest - ein Rueckfall druckte [FEHL], aber ++s_iFailedTests steht nur
// in TT_EndTest, und Summe wie Rueckgabewert blieben gruen. Gefunden hat es
// erst der Pruefbericht (350 gemeldet, 342 Zeilen; PRUEFER-68 K6).
//
// Jetzt prueft das Geruest selbst: wer einen Test beginnt, solange der
// vorige noch offen ist, oder TT_Summary ruft, waehrend einer offen ist,
// bekommt diesen Test als FEHLGESCHLAGEN gezaehlt - gleich, ob er sonst
// bestanden haette. Ein Test, der sein Ende nicht meldet, ist nicht
// geprueft. Ebenso zaehlt eine Abweichung ausserhalb jedes Tests.
//
static int	s_bOffen = 0;

//
// GERUESTFEHLER (01.11.2026, PRUEFER-69 K2). Ein doppeltes TT_EndTest zaehlte
// einen roten Test ein zweites Mal (zwei rote ergaben 3) oder druckte nach
// einem gruenen eine namenlose [ok  ]-Zeile; eine Abweichung ausserhalb eines
// Tests senkte "bestanden" unter die Zahl der benannten gruenen Tests. Beides
// ist ein Fehler im Testcode, kein Test: es wird hier gezaehlt, nicht unter
// "fehlgeschlagen", und macht die Rueckgabe trotzdem rot.
//
static int	s_iGeruestfehler = 0;

static void OffenenTestAlsFehlerZaehlen(const char* szWo)
{
	if (!s_bOffen)
		return;
	++s_iFailedTests;
	if (s_iChecksFailed == 0)	// sonst hat TT_Fail die Zeile schon gedruckt
		printf("[FEHL] %s\n", s_szCurrent);
	printf("       ^-- FEHLGESCHLAGEN: ohne TT_EndTest verlassen (bemerkt in %s)"
		   " - %d Abweichung(en) bis dahin\n", szWo, s_iChecksFailed);
	NotizenAusgeben();
	s_szCurrent[0] = '\0';
	s_bOffen = 0;
}

void TT_BeginTest(const char* szName)
{
	OffenenTestAlsFehlerZaehlen("TT_BeginTest");
	s_bOffen = 1;
	strncpy(s_szCurrent, szName, sizeof(s_szCurrent) - 1);
	s_szCurrent[sizeof(s_szCurrent) - 1] = '\0';
	s_iChecksFailed = 0;
	s_iPrinted = 0;
	s_szNotes[0] = '\0';
	s_iNotesLen = 0;
	++s_iTests;
}

void TT_EndTest(void)
{
	if (!s_bOffen)
	{
		++s_iGeruestfehler;
		printf("[FEHL] (Geruest) TT_EndTest ohne offenen Test - doppeltes Ende? Letzter Test davor bleibt einmal gezaehlt\n");
		return;
	}
	if (s_iChecksFailed == 0)
	{
		printf("[ok  ] %s\n", s_szCurrent);
	}
	else
	{
		++s_iFailedTests;
		printf("       ^-- FEHLGESCHLAGEN: %d Abweichung(en)\n", s_iChecksFailed);
	}

	NotizenAusgeben();

	s_szCurrent[0] = '\0';
	s_bOffen = 0;
}

void TT_Fail(const char* szFormat, ...)
{
	if (!s_bOffen)
	{
		// Abweichung ausserhalb jedes Tests - kein TT_EndTest wird sie je
		// zaehlen, also hier.
		va_list args;
		++s_iGeruestfehler;
		printf("[FEHL] (Geruest, ausserhalb eines Tests) ");
		va_start(args, szFormat);
		vprintf(szFormat, args);
		va_end(args);
		printf("\n");
		return;
	}
	++s_iChecksFailed;
	if (s_iChecksFailed == 1)
	{
		printf("[FEHL] %s\n", s_szCurrent);

		//
		// Der Name steht jetzt da - also duerfen die Notizen heraus, und
		// zwar VOR den Abweichungen. Sie sind der Zusammenhang, in dem
		// die Abweichung zu lesen ist.
		//
		NotizenAusgeben();
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
	char		szZeile[1024];
	va_list		args;

	va_start(args, szFormat);
	_vsnprintf(szZeile, sizeof(szZeile) - 1, szFormat, args);
	va_end(args);
	szZeile[sizeof(szZeile) - 1] = '\0';

	//
	// Gesammelt statt gedruckt: ausgegeben wird erst, wenn der Testname
	// feststeht. Laeuft der Puffer voll, sagt die letzte Zeile das - eine
	// stillschweigend abgeschnittene Notiz waere schlimmer als gar keine.
	//
	const int	nFrei = (int) sizeof(s_szNotes) - s_iNotesLen - 1;
	const int	nWill = (int) strlen(szZeile) + 13;

	if (nFrei <= 0)
		return;

	if (nWill > nFrei)
	{
		_snprintf(s_szNotes + s_iNotesLen, nFrei, "         > ... weitere Notizen unterdrueckt\n");
		s_iNotesLen = (int) sizeof(s_szNotes) - 1;
		s_szNotes[s_iNotesLen] = '\0';
		return;
	}

	s_iNotesLen += _snprintf(s_szNotes + s_iNotesLen, nFrei, "         > %s\n", szZeile);
	s_szNotes[s_iNotesLen] = '\0';
}

int TT_Summary(void)
{
	OffenenTestAlsFehlerZaehlen("TT_Summary");
	printf("\n===============================================================\n");
	printf(" Ergebnis: %d Tests, %d bestanden, %d fehlgeschlagen\n",
		   s_iTests, s_iTests - s_iFailedTests, s_iFailedTests);
	printf("===============================================================\n");
	if (s_iGeruestfehler > 0)
	{
		printf(" Geruestfehler (Testcode, kein Test): %d - Rueckgabe deshalb nicht 0\n", s_iGeruestfehler);
		printf("===============================================================\n");
	}
	return s_iFailedTests + s_iGeruestfehler;
}
