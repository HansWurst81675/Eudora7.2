//
// TestXlateTable.cpp - prueft die Uebersetzungstabelle pcXlateTable aus utils.cpp
//
// Die Erwartung wird ausschliesslich aus den Normen abgeleitet (siehe Spec.h):
// die Tabelle bildet eine UTF-8- bzw. ISO-8859-15-Bytefolge auf genau ein
// CP1252-Byte ab. Richtig ist eine Zeile genau dann, wenn der Unicode-Codepunkt
// der Quellfolge derselbe ist wie der Unicode-Codepunkt des Zielbytes in CP1252.
//
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "TinyTest.h"
#include "Spec.h"
#include "UnderTest.h"

#define SET_LATIN9	0
#define SET_UTF8	1

// Anzahl der CP1252-Bytes ab 0x80, die ueberhaupt einen Unicode-Codepunkt haben.
// 32 Positionen 0x80..0x9F minus die 5 unbelegten (81, 8D, 8F, 90, 9D) = 27,
// dazu 96 Positionen 0xA0..0xFF = 123. Genau so viele Zeilen braucht die Tabelle.
static int SpecRequiredRowCount(void)
{
	int iCount = 0;
	int b;
	for (b = 0x80; b <= 0xFF; ++b)
	{
		if (SpecCp1252ToUnicode((unsigned char)b) >= 0)
			++iCount;
	}
	return iCount;
}

// Liest eine Datei vollstaendig ein. Der Aufrufer gibt den Puffer frei.
static char* ReadWholeFile(const char* szPath, long* plSize)
{
	FILE* f = fopen(szPath, "rb");
	char* pBuf;
	long lSize;

	*plSize = 0;
	if (!f) return 0;

	fseek(f, 0, SEEK_END);
	lSize = ftell(f);
	fseek(f, 0, SEEK_SET);

	pBuf = (char*)malloc((size_t)lSize + 1);
	if (!pBuf) { fclose(f); return 0; }

	lSize = (long)fread(pBuf, 1, (size_t)lSize, f);
	pBuf[lSize] = 0;
	fclose(f);

	*plSize = lSize;
	return pBuf;
}

// ---------------------------------------------------------------------------

static void Test_Makrowerte(void)
{
	TT_BeginTest("utils.cpp: XLATE_CHARS / MAX_CHARS_TO_TRANS / MAX_CHARACTER_SETS");

	// XLATE_CHARS muss so gross sein, dass alle uebersetzbaren CP1252-Zeichen
	// hineinpassen.
	if (UT_XlateChars() != SpecRequiredRowCount())
	{
		TT_Fail("XLATE_CHARS ist %d, aus CP1252 abgeleitet noetig sind %d",
				UT_XlateChars(), SpecRequiredRowCount());
	}

	// Die laengste noetige UTF-8-Folge ist 3 Bytes (z.B. U+20AC EURO SIGN).
	if (UT_MaxCharsToTrans() < 3)
		TT_Fail("MAX_CHARS_TO_TRANS ist %d, noetig sind mindestens 3", UT_MaxCharsToTrans());

	// Zwei Zeichensaetze werden uebersetzt: ISO-8859-15 und UTF-8.
	if (UT_MaxCharacterSets() != 2)
		TT_Fail("MAX_CHARACTER_SETS ist %d, erwartet 2", UT_MaxCharacterSets());

	TT_EndTest();
}

static void Test_ResourceIdsPassenZuResourceH(const char* szEudoraDir)
{
	char szPath[1024];
	long lSize = 0;
	char* pBuf;
	const char* p;
	int iAscii = -1;
	int iUtf8  = -1;

	TT_BeginTest("utils.cpp: MAX_CHARACTER_SETS passt zu den IDs in resource.h");

	sprintf(szPath, "%s\\resource.h", szEudoraDir);
	pBuf = ReadWholeFile(szPath, &lSize);
	if (!pBuf)
	{
		TT_Fail("resource.h nicht lesbar: %s", szPath);
		TT_EndTest();
		return;
	}

	p = strstr(pBuf, "#define IDS_MIME_US_ASCII");
	if (p) iAscii = atoi(p + strlen("#define IDS_MIME_US_ASCII"));
	p = strstr(pBuf, "#define IDS_MIME_UTF_8");
	if (p) iUtf8 = atoi(p + strlen("#define IDS_MIME_UTF_8"));

	if (iAscii != UT_IdsMimeUsAscii())
		TT_Fail("IDS_MIME_US_ASCII: resource.h sagt %d, Test rechnet mit %d", iAscii, UT_IdsMimeUsAscii());
	if (iUtf8 != UT_IdsMimeUtf8())
		TT_Fail("IDS_MIME_UTF_8: resource.h sagt %d, Test rechnet mit %d", iUtf8, UT_IdsMimeUtf8());

	free(pBuf);
	TT_EndTest();
}

static void Test_QuelldateiIstCp1252(const char* szEudoraDir)
{
	char szPath[1024];
	long lSize = 0;
	char* pBuf;
	long i;
	int iHighLiterals = 0;
	int iFragezeichen = 0;

	TT_BeginTest("utils.cpp: die Zeichenliterale der Tabelle sind CP1252-Bytes >= 0x80");

	sprintf(szPath, "%s\\utils.cpp", szEudoraDir);
	pBuf = ReadWholeFile(szPath, &lSize);
	if (!pBuf)
	{
		TT_Fail("utils.cpp nicht lesbar: %s", szPath);
		TT_EndTest();
		return;
	}

	// Gezaehlt wird das Muster (UCHAR)'X' mit genau einem Byte X.
	for (i = 0; i + 10 < lSize; ++i)
	{
		if (memcmp(pBuf + i, "(UCHAR)'", 8) == 0 && pBuf[i + 9] == '\'')
		{
			unsigned char by = (unsigned char)pBuf[i + 8];
			if (by >= 0x80) ++iHighLiterals;
			if (by == '?')  ++iFragezeichen;
		}
	}

	// Die 27 CP1252-Sonderzeichen der UTF-8-Zeile stehen als Zeichenliteral in
	// der Quelle, die 8 der Latin-9-Zeile ebenfalls: zusammen 35.
	if (iHighLiterals != 35)
		TT_Fail("erwartet 35 Zeichenliterale mit Byte >= 0x80, gefunden %d", iHighLiterals);
	if (iFragezeichen != 0)
		TT_Fail("%d Literale sind '?' - die Quelldatei wurde vermutlich falsch umkodiert", iFragezeichen);

	free(pBuf);
	TT_EndTest();
}

static void Test_Utf8ZeileKeineLuecke(void)
{
	int i;
	TT_BeginTest("UTF-8-Zeile: alle 123 Eintraege belegt (ISOTranslate bricht sonst ab)");

	// ISOTranslate bricht bei der ersten Zeile mit Quellbyte 0 ab. Eine Luecke
	// wuerde alle nachfolgenden Eintraege wirkungslos machen.
	for (i = 0; i < UT_XlateChars(); ++i)
	{
		const unsigned char* pRow = UT_XlateRow(SET_UTF8, i);
		if (!pRow || pRow[0] == 0)
		{
			TT_Fail("Eintrag %d ist leer - Eintraege %d..%d werden nie benutzt",
					i, i, UT_XlateChars() - 1);
			break;
		}
	}
	TT_EndTest();
}

static void Test_Utf8ZeileFormAllerEintraege(void)
{
	int i;
	TT_BeginTest("UTF-8-Zeile: jede Quellfolge ist gueltiges, nullterminiertes UTF-8");

	for (i = 0; i < UT_XlateChars(); ++i)
	{
		const unsigned char* pRow = UT_XlateRow(SET_UTF8, i);
		int iLen = 0;
		long lCp;
		int iStrLen;

		if (!pRow || pRow[0] == 0) continue;

		// Das Byte an Position MAX_CHARS_TO_TRANS muss 0 sein, sonst ist die
		// Zeile nicht als C-Zeichenkette verwendbar (ISOTranslate castet sie
		// genau dazu).
		if (pRow[UT_MaxCharsToTrans()] != 0)
			TT_Fail("Eintrag %d: Abschluss-Byte ist 0x%02X statt 0x00", i, pRow[UT_MaxCharsToTrans()]);

		iStrLen = (int)strlen((const char*)pRow);
		lCp = SpecUtf8Decode(pRow, &iLen);
		if (lCp < 0)
			TT_Fail("Eintrag %d: %02X %02X %02X ist kein gueltiges UTF-8",
					i, pRow[0], pRow[1], pRow[2]);
		else if (iLen != iStrLen)
			TT_Fail("Eintrag %d: UTF-8-Folge ist %d Bytes lang, die Zeile enthaelt aber %d Bytes",
					i, iLen, iStrLen);
	}
	TT_EndTest();
}

static void Test_Utf8ZeileZuordnungen(void)
{
	int i;
	TT_BeginTest("UTF-8-Zeile: Codepunkt der Quellfolge == Codepunkt des CP1252-Zielbytes");

	for (i = 0; i < UT_XlateChars(); ++i)
	{
		const unsigned char* pRow = UT_XlateRow(SET_UTF8, i);
		int iLen = 0;
		long lActual, lExpected;
		unsigned char byTarget;

		if (!pRow || pRow[0] == 0) continue;

		byTarget = pRow[UT_MaxCharsToTrans() + 1];
		lActual = SpecUtf8Decode(pRow, &iLen);
		if (lActual < 0) continue;	// schon im Formtest gemeldet

		lExpected = SpecCp1252ToUnicode(byTarget);
		if (lExpected < 0)
		{
			TT_Fail("Eintrag %2d: Ziel 0x%02X ist in CP1252 gar nicht belegt", i, byTarget);
			continue;
		}

		if (lActual != lExpected)
		{
			unsigned char szWant[8];
			SpecUtf8Encode(lExpected, szWant);
			TT_Fail("Eintrag %2d: Quelle %02X %02X %02X = U+%04lX, Ziel 0x%02X ist aber U+%04lX "
					"(richtig waere die Folge %02X %02X %02X)",
					i, pRow[0], pRow[1], pRow[2], lActual, byTarget, lExpected,
					szWant[0], szWant[1], szWant[2]);
		}
	}
	TT_EndTest();
}

static void Test_Utf8ZeileKeineDoppelten(void)
{
	int i, j;
	int aiTargetCount[256];

	TT_BeginTest("UTF-8-Zeile: keine doppelten Quellfolgen und keine doppelten Ziele");

	memset(aiTargetCount, 0, sizeof(aiTargetCount));

	for (i = 0; i < UT_XlateChars(); ++i)
	{
		const unsigned char* pRow = UT_XlateRow(SET_UTF8, i);
		if (!pRow || pRow[0] == 0) continue;

		aiTargetCount[pRow[UT_MaxCharsToTrans() + 1]]++;

		for (j = i + 1; j < UT_XlateChars(); ++j)
		{
			const unsigned char* pOther = UT_XlateRow(SET_UTF8, j);
			if (!pOther || pOther[0] == 0) continue;
			if (memcmp(pRow, pOther, (size_t)UT_MaxCharsToTrans() + 1) == 0)
				TT_Fail("Eintraege %d und %d haben dieselbe Quellfolge %02X %02X %02X",
						i, j, pRow[0], pRow[1], pRow[2]);
		}
	}

	for (i = 0; i < 256; ++i)
	{
		if (aiTargetCount[i] > 1)
			TT_Fail("Zielbyte 0x%02X kommt %dmal vor", i, aiTargetCount[i]);
	}

	TT_EndTest();
}

static void Test_Utf8ZeileVollstaendig(void)
{
	int i, b;
	int abSeen[256];

	TT_BeginTest("UTF-8-Zeile: alle 123 uebersetzbaren CP1252-Zeichen sind abgedeckt");

	memset(abSeen, 0, sizeof(abSeen));
	for (i = 0; i < UT_XlateChars(); ++i)
	{
		const unsigned char* pRow = UT_XlateRow(SET_UTF8, i);
		if (!pRow || pRow[0] == 0) continue;
		abSeen[pRow[UT_MaxCharsToTrans() + 1]] = 1;
	}

	for (b = 0x80; b <= 0xFF; ++b)
	{
		long lCp = SpecCp1252ToUnicode((unsigned char)b);
		if (lCp < 0)
		{
			if (abSeen[b])
				TT_Fail("Zielbyte 0x%02X ist in CP1252 unbelegt, wird aber erzeugt", b);
			continue;
		}
		if (!abSeen[b])
		{
			unsigned char szWant[8];
			SpecUtf8Encode(lCp, szWant);
			TT_Fail("CP1252 0x%02X (U+%04lX) fehlt: UTF-8 %02X %02X %02X wird nicht uebersetzt",
					b, lCp, szWant[0], szWant[1], szWant[2]);
		}
	}
	TT_EndTest();
}

static void Test_Utf8ZeileLatin1Block(void)
{
	long lCp;
	TT_BeginTest("UTF-8-Zeile: Latin-1 U+00A0..U+00FF vollstaendig und wertgleich abgebildet");

	for (lCp = 0xA0; lCp <= 0xFF; ++lCp)
	{
		unsigned char szUtf8[8];
		int i;
		int iFound = -1;

		SpecUtf8Encode(lCp, szUtf8);

		for (i = 0; i < UT_XlateChars(); ++i)
		{
			const unsigned char* pRow = UT_XlateRow(SET_UTF8, i);
			if (!pRow || pRow[0] == 0) continue;
			if (strcmp((const char*)pRow, (const char*)szUtf8) == 0) { iFound = i; break; }
		}

		if (iFound < 0)
		{
			TT_Fail("U+%04lX (UTF-8 %02X %02X) fehlt in der Tabelle", lCp, szUtf8[0], szUtf8[1]);
		}
		else
		{
			// In CP1252 ist der Bereich A0..FF wertgleich mit Latin-1.
			unsigned char byTarget = UT_XlateRow(SET_UTF8, iFound)[UT_MaxCharsToTrans() + 1];
			if (byTarget != (unsigned char)lCp)
				TT_Fail("U+%04lX wird auf 0x%02X abgebildet, richtig waere 0x%02lX",
						lCp, byTarget, lCp);
		}
	}
	TT_EndTest();
}

static void Test_Latin9Zeile(void)
{
	int i, b;
	int iEntries = 0;
	int abCovered[256];

	TT_BeginTest("ISO-8859-15-Zeile: die acht Abweichungen zu Latin-1 sind korrekt und vollstaendig");

	memset(abCovered, 0, sizeof(abCovered));

	for (i = 0; i < UT_XlateChars(); ++i)
	{
		const unsigned char* pRow = UT_XlateRow(SET_LATIN9, i);
		unsigned char bySrc, byDst;
		long lCpSrc, lCpDst;

		if (!pRow || pRow[0] == 0) break;	// ISOTranslate bricht hier ebenfalls ab

		++iEntries;
		bySrc = pRow[0];
		byDst = pRow[UT_MaxCharsToTrans() + 1];

		if (pRow[1] != 0)
			TT_Fail("Eintrag %d: ISO-8859-15 ist eine Ein-Byte-Kodierung, Byte 2 ist aber 0x%02X", i, pRow[1]);

		abCovered[bySrc] = 1;

		lCpSrc = SpecLatin9ToUnicode(bySrc);
		lCpDst = SpecCp1252ToUnicode(byDst);
		if (lCpSrc != lCpDst)
			TT_Fail("Eintrag %d: 0x%02X ist in ISO-8859-15 U+%04lX, Ziel 0x%02X ist aber U+%04lX",
					i, bySrc, lCpSrc, byDst, lCpDst);
	}

	// Vollstaendigkeit: jedes Byte, in dem sich ISO-8859-15 und CP1252
	// unterscheiden, muss eine Zeile haben - und nur diese.
	for (b = 0xA0; b <= 0xFF; ++b)
	{
		int bDiffers = (SpecLatin9ToUnicode((unsigned char)b) != SpecCp1252ToUnicode((unsigned char)b));
		if (bDiffers && !abCovered[b])
			TT_Fail("ISO-8859-15 0x%02X (U+%04lX) fehlt in der Tabelle",
					b, SpecLatin9ToUnicode((unsigned char)b));
		if (!bDiffers && abCovered[b])
			TT_Fail("ISO-8859-15 0x%02X ist mit CP1252 wertgleich, wird aber trotzdem uebersetzt", b);
	}

	if (iEntries != 8)
		TT_Fail("erwartet 8 belegte Eintraege, gefunden %d", iEntries);

	TT_EndTest();
}

void RunXlateTableTests(const char* szEudoraDir)
{
	TT_Suite("utils.cpp - Uebersetzungstabelle pcXlateTable");

	Test_Makrowerte();
	Test_ResourceIdsPassenZuResourceH(szEudoraDir);
	Test_QuelldateiIstCp1252(szEudoraDir);
	Test_Utf8ZeileKeineLuecke();
	Test_Utf8ZeileFormAllerEintraege();
	Test_Utf8ZeileZuordnungen();
	Test_Utf8ZeileKeineDoppelten();
	Test_Utf8ZeileVollstaendig();
	Test_Utf8ZeileLatin1Block();
	Test_Latin9Zeile();
}
