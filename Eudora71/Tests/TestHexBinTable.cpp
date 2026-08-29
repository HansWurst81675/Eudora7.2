//
// TestHexBinTable.cpp - prueft die Dekodiertabelle HexBinTable aus hexbin.cpp
//
// Erwartung aus der BinHex-4.0-Beschreibung: 64 Zeichen bilden das Alphabet,
// der Index im Alphabet ist der 6-Bit-Wert. ':' beendet den Datenteil, CR und
// LF werden ueberlesen, jedes andere Byte ist ein Fehler.
//
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "Spec.h"
#include "UnderTest.h"

static void Test_AlphabetWerte(void)
{
	const unsigned char* pTable = UT_HexBinTable();
	const char* szAlpha = SpecBinHexAlphabet();
	int i;

	TT_BeginTest("HexBinTable: die 64 Alphabetzeichen liefern ihren 6-Bit-Wert");

	if ((int)strlen(szAlpha) != 64)
	{
		TT_Fail("Referenzalphabet hat %d Zeichen statt 64", (int)strlen(szAlpha));
		TT_EndTest();
		return;
	}

	for (i = 0; i < 64; ++i)
	{
		unsigned char byChar = (unsigned char)szAlpha[i];
		if (pTable[byChar] != (unsigned char)i)
			TT_Fail("'%c' (0x%02X) liefert 0x%02X, erwartet 0x%02X",
					byChar, byChar, pTable[byChar], i);
	}
	TT_EndTest();
}

static void Test_Sondereintraege(void)
{
	const unsigned char* pTable = UT_HexBinTable();

	TT_BeginTest("HexBinTable: ':' beendet, CR und LF werden ueberlesen");

	if (pTable[':'] != UT_HexBinDone())
		TT_Fail("':' liefert 0x%02X, erwartet DONE (0x%02X)", pTable[':'], UT_HexBinDone());
	if (pTable['\r'] != UT_HexBinSkip())
		TT_Fail("CR liefert 0x%02X, erwartet SKIP (0x%02X)", pTable['\r'], UT_HexBinSkip());
	if (pTable['\n'] != UT_HexBinSkip())
		TT_Fail("LF liefert 0x%02X, erwartet SKIP (0x%02X)", pTable['\n'], UT_HexBinSkip());

	// Die Wiederholungsmarke 0x90 ist ein Datenwert, kein Tabelleneintrag -
	// sie darf mit keinem 6-Bit-Wert kollidieren.
	if (UT_HexBinRunChar() != 0x90)
		TT_Fail("RUNCHAR ist 0x%02X, erwartet 0x90", UT_HexBinRunChar());

	TT_EndTest();
}

static void Test_AllesAndereIstFehler(void)
{
	const unsigned char* pTable = UT_HexBinTable();
	const char* szAlpha = SpecBinHexAlphabet();
	int i;

	TT_BeginTest("HexBinTable: jedes Byte ausserhalb des Alphabets ist FAIL");

	for (i = 0; i < 256; ++i)
	{
		if (strchr(szAlpha, (char)i) && i != 0) continue;	// gehoert zum Alphabet
		if (i == ':' || i == '\r' || i == '\n') continue;	// Sonderfaelle

		if (pTable[i] != UT_HexBinFail())
			TT_Fail("Byte 0x%02X liefert 0x%02X, erwartet FAIL (0x%02X)",
					i, pTable[i], UT_HexBinFail());
	}
	TT_EndTest();
}

static void Test_JederWertGenauEinmal(void)
{
	const unsigned char* pTable = UT_HexBinTable();
	int aiCount[64];
	int i;

	TT_BeginTest("HexBinTable: jeder 6-Bit-Wert 0x00..0x3F kommt genau einmal vor");

	memset(aiCount, 0, sizeof(aiCount));
	for (i = 0; i < 256; ++i)
	{
		if (pTable[i] < 64) aiCount[pTable[i]]++;
	}
	for (i = 0; i < 64; ++i)
	{
		if (aiCount[i] != 1)
			TT_Fail("Wert 0x%02X kommt %dmal vor", i, aiCount[i]);
	}
	TT_EndTest();
}

void RunHexBinTableTests(void)
{
	TT_Suite("hexbin.cpp - BinHex-4.0-Dekodiertabelle");

	Test_AlphabetWerte();
	Test_Sondereintraege();
	Test_AllesAndereIstFehler();
	Test_JederWertGenauEinmal();
}
