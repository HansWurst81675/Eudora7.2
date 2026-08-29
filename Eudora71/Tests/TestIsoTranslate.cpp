//
// TestIsoTranslate.cpp - Verhaltenstests fuer ISOTranslate() aus utils.cpp
//
// Erwartet wird das, was die Norm verlangt: ISOTranslate wandelt einen Text vom
// angegebenen Zeichensatz nach CP1252. Jedes Eingabezeichen muss unabhaengig von
// seinen Nachbarn in genau das CP1252-Byte uebersetzt werden, das denselben
// Unicode-Codepunkt hat. Zeichen ohne CP1252-Entsprechung bleiben unveraendert.
//
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "Spec.h"
#include "UnderTest.h"

// Zeichensatz-Indizes, wie ISOTranslate sie erwartet
// (siehe lex822.cpp: 0 Windows, 1 US-ASCII, 2 ISO-8859-1, 3 ISO-8859-15, 4 UTF-8).
#define IDX_WINDOWS		0
#define IDX_US_ASCII	1
#define IDX_LATIN1		2
#define IDX_LATIN9		3
#define IDX_UTF8		4

// Ruft ISOTranslate auf einer Kopie der Eingabe auf.
// Liefert die Rueckgabe der Funktion, das Ergebnis steht in pOut.
static long Run(const unsigned char* pIn, long lLen, unsigned int uIdx,
				unsigned char* pOut, long lOutCapacity)
{
	long lRet;
	memset(pOut, 0, (size_t)lOutCapacity);
	memcpy(pOut, pIn, (size_t)lLen);
	pOut[lLen] = 0;
	lRet = UT_ISOTranslate((char*)pOut, lLen, uIdx);
	return lRet;
}

// Gibt eine Bytefolge als Hex aus, fuer Fehlermeldungen.
// Reihum vier Puffer, damit mehrere Hex()-Aufrufe in EINEM printf sich nicht
// gegenseitig ueberschreiben.
static const char* Hex(const unsigned char* p, long lLen)
{
	static char aszBuf[4][256];
	static int  iSlot = 0;
	char* szBuf = aszBuf[iSlot];
	long i;
	int iPos = 0;

	iSlot = (iSlot + 1) & 3;
	szBuf[0] = 0;
	for (i = 0; i < lLen && iPos < 240; ++i)
		iPos += sprintf(szBuf + iPos, "%02X ", p[i]);
	if (iPos > 0) szBuf[iPos - 1] = 0;
	return szBuf;
}

// ---------------------------------------------------------------------------

static void Test_KeineUebersetzungBeiIndexBis2(void)
{
	// Windows, US-ASCII und ISO-8859-1 brauchen keine Uebersetzung.
	static const unsigned char szIn[] = { 0xC3, 0xA4, 0xE2, 0x82, 0xAC, 0x41, 0x00 };
	unsigned char szOut[64];
	unsigned int u;

	TT_BeginTest("ISOTranslate: Index 0/1/2 laesst den Text unveraendert");

	for (u = IDX_WINDOWS; u <= IDX_LATIN1; ++u)
	{
		long lRet = Run(szIn, 6, u, szOut, sizeof(szOut));
		if (lRet != 6 || memcmp(szOut, szIn, 6) != 0)
			TT_Fail("Index %u: erwartet unveraendert (%s), erhalten %s (Rueckgabe %ld)",
					u, Hex(szIn, 6), Hex(szOut, lRet > 0 ? lRet : 0), lRet);
	}
	TT_EndTest();
}

static void Test_AsciiUnveraendert(void)
{
	static const char szIn[] = "Hello, World! 0123456789 <>&%$@";
	unsigned char szOut[128];
	long lLen = (long)strlen(szIn);
	long lRet;

	TT_BeginTest("ISOTranslate: reiner ASCII-Text bleibt unveraendert");

	lRet = Run((const unsigned char*)szIn, lLen, IDX_UTF8, szOut, sizeof(szOut));
	if (lRet != lLen || memcmp(szOut, szIn, (size_t)lLen) != 0)
		TT_Fail("erwartet \"%s\", erhalten \"%s\"", szIn, (const char*)szOut);

	TT_EndTest();
}

// Uebersetzt ein einzelnes Zeichen und prueft gegen das CP1252-Byte.
// Liefert 1, wenn es stimmt.
static int CheckSingle(long lCp, int bReport)
{
	unsigned char szUtf8[8];
	unsigned char szOut[32];
	int iLen = SpecUtf8Encode(lCp, szUtf8);
	long lRet;
	unsigned char byExpected = 0;
	int b;

	// Erwartetes CP1252-Byte zu diesem Codepunkt suchen.
	for (b = 0x80; b <= 0xFF; ++b)
	{
		if (SpecCp1252ToUnicode((unsigned char)b) == lCp) { byExpected = (unsigned char)b; break; }
	}
	if (byExpected == 0) return 1;	// kein CP1252-Zeichen, hier nicht geprueft

	lRet = Run(szUtf8, iLen, IDX_UTF8, szOut, sizeof(szOut));

	if (lRet == 1 && szOut[0] == byExpected)
		return 1;

	if (bReport)
		TT_Fail("U+%04lX (UTF-8 %s) -> erwartet CP1252 0x%02X, erhalten %s",
				lCp, Hex(szUtf8, iLen), byExpected, Hex(szOut, lRet > 0 ? lRet : 0));
	return 0;
}

static void Test_Latin1EinzelzeichenA0BisFF(void)
{
	long lCp;
	TT_BeginTest("ISOTranslate: U+00A0..U+00FF werden je auf ein Latin-1-Byte abgebildet");

	for (lCp = 0xA0; lCp <= 0xFF; ++lCp)
		CheckSingle(lCp, 1);

	TT_EndTest();
}

static void Test_Cp1252SonderzeichenEinzeln(void)
{
	int b;
	TT_BeginTest("ISOTranslate: die 27 CP1252-Sonderzeichen 0x80..0x9F werden uebersetzt");

	for (b = 0x80; b <= 0x9F; ++b)
	{
		long lCp = SpecCp1252ToUnicode((unsigned char)b);
		if (lCp < 0) continue;		// in CP1252 unbelegt
		CheckSingle(lCp, 1);
	}
	TT_EndTest();
}

static void Test_DeutscherBeispieltext(void)
{
	// "Gruesse aus Muenchen: Aepfel, Oel, Uebung, Strasse - 20 EUR."
	// mit echten Umlauten, scharfem s und Eurozeichen.
	static const long alText[] =
	{
		'G','r',0x00FC,0x00DF,'e',' ','a','u','s',' ','M',0x00FC,'n','c','h','e','n',':',' ',
		0x00C4,'p','f','e','l',',',' ',0x00D6,'l',',',' ',0x00DC,'b','u','n','g',',',' ',
		'S','t','r','a',0x00DF,'e',' ','-',' ','2','0',' ',0x20AC,'.',
		-1
	};
	static const unsigned char szExpected[] =
	{
		'G','r',0xFC,0xDF,'e',' ','a','u','s',' ','M',0xFC,'n','c','h','e','n',':',' ',
		0xC4,'p','f','e','l',',',' ',0xD6,'l',',',' ',0xDC,'b','u','n','g',',',' ',
		'S','t','r','a',0xDF,'e',' ','-',' ','2','0',' ',0x80,'.'
	};
	unsigned char szIn[256];
	unsigned char szOut[256];
	long lInLen = 0;
	long lRet;
	int i;

	TT_BeginTest("ISOTranslate: deutscher Beispieltext mit Umlauten, scharfem s und Euro");

	for (i = 0; alText[i] >= 0; ++i)
		lInLen += SpecUtf8Encode(alText[i], szIn + lInLen);

	lRet = Run(szIn, lInLen, IDX_UTF8, szOut, sizeof(szOut));

	if (lRet != (long)sizeof(szExpected) || memcmp(szOut, szExpected, sizeof(szExpected)) != 0)
	{
		TT_Fail("erwartet %ld Bytes: %s", (long)sizeof(szExpected), Hex(szExpected, (long)sizeof(szExpected)));
		TT_Note("erhalten %ld Bytes: %s", lRet, Hex(szOut, lRet > 0 ? lRet : 0));
	}
	TT_EndTest();
}

static void Test_ZeichenSindVoneinanderUnabhaengig(void)
{
	// Kern der Norm: die Uebersetzung eines Zeichens darf nicht davon abhaengen,
	// welches Zeichen daneben steht. Geprueft werden alle Paare aus den
	// Codepunkten, die einzeln nachweislich richtig uebersetzt werden - so
	// stammt jede Abweichung hier wirklich aus der Reihenfolge der Ersetzungen
	// und nicht aus einem falschen Tabelleneintrag.
	long alGood[160];
	int iGood = 0;
	int b, i, j;
	int iPairsChecked = 0;
	int iPairsBroken = 0;

	TT_BeginTest("ISOTranslate: Zeichen werden unabhaengig von ihren Nachbarn uebersetzt");

	for (b = 0x80; b <= 0xFF; ++b)
	{
		long lCp = SpecCp1252ToUnicode((unsigned char)b);
		if (lCp < 0) continue;
		if (CheckSingle(lCp, 0))
			alGood[iGood++] = lCp;
	}

	for (i = 0; i < iGood; ++i)
	{
		for (j = 0; j < iGood; ++j)
		{
			unsigned char szIn[16];
			unsigned char szOut[32];
			unsigned char szExpected[4];
			long lInLen = 0;
			long lRet;
			int k;

			lInLen += SpecUtf8Encode(alGood[i], szIn + lInLen);
			lInLen += SpecUtf8Encode(alGood[j], szIn + lInLen);

			for (k = 0x80; k <= 0xFF; ++k)
			{
				if (SpecCp1252ToUnicode((unsigned char)k) == alGood[i]) szExpected[0] = (unsigned char)k;
				if (SpecCp1252ToUnicode((unsigned char)k) == alGood[j]) szExpected[1] = (unsigned char)k;
			}

			++iPairsChecked;
			lRet = Run(szIn, lInLen, IDX_UTF8, szOut, sizeof(szOut));

			if (lRet != 2 || szOut[0] != szExpected[0] || szOut[1] != szExpected[1])
			{
				++iPairsBroken;
				TT_Fail("U+%04lX U+%04lX (UTF-8 %s) -> erwartet %02X %02X, erhalten %s",
						alGood[i], alGood[j], Hex(szIn, lInLen),
						szExpected[0], szExpected[1], Hex(szOut, lRet > 0 ? lRet : 0));
			}
		}
	}

	if (iPairsBroken > 0)
		TT_Note("%d von %d geprueften Zeichenpaaren werden falsch uebersetzt", iPairsBroken, iPairsChecked);

	TT_EndTest();
}

static void Test_ErsetzungFrisstNachbarzeichen(void)
{
	// Engster Fall des Reihenfolgeproblems, zum Festhalten:
	// "A-Tilde grossgeschrieben" gefolgt von "Copyright" ist UTF-8 C3 83 C2 A9.
	// Richtig waeren die zwei CP1252-Bytes C3 A9. ISOTranslate ersetzt aber
	// erst C2 A9 -> A9, dann C3 83 -> C3; dabei entsteht die Folge C3 A9, die
	// ein spaeterer Tabelleneintrag ein zweites Mal ersetzt. Aus zwei Zeichen
	// wird eines.
	static const unsigned char szIn[]       = { 0xC3, 0x83, 0xC2, 0xA9 };
	static const unsigned char szExpected[] = { 0xC3, 0xA9 };
	unsigned char szOut[32];
	long lRet;

	TT_BeginTest("ISOTranslate: eine Ersetzung darf das Ergebnis nicht erneut ersetzen");

	lRet = Run(szIn, 4, IDX_UTF8, szOut, sizeof(szOut));
	if (lRet != 2 || memcmp(szOut, szExpected, 2) != 0)
	{
		TT_Fail("Eingabe %s -> erwartet %s, erhalten %s",
				Hex(szIn, 4), Hex(szExpected, 2), Hex(szOut, lRet > 0 ? lRet : 0));
		TT_Note("das Ergebnis einer Ersetzung wird von einem spaeteren Tabelleneintrag "
				"noch einmal ersetzt");
	}
	TT_EndTest();
}

static void Test_Latin9Uebersetzung(void)
{
	int b;
	TT_BeginTest("ISOTranslate: ISO-8859-15 (Index 3) wird nach CP1252 uebersetzt");

	for (b = 0xA0; b <= 0xFF; ++b)
	{
		unsigned char szIn[4];
		unsigned char szOut[16];
		unsigned char byExpected = 0;
		long lCp = SpecLatin9ToUnicode((unsigned char)b);
		long lRet;
		int k;

		for (k = 0x80; k <= 0xFF; ++k)
			if (SpecCp1252ToUnicode((unsigned char)k) == lCp) { byExpected = (unsigned char)k; break; }

		if (byExpected == 0) continue;

		szIn[0] = (unsigned char)b;
		lRet = Run(szIn, 1, IDX_LATIN9, szOut, sizeof(szOut));

		if (lRet != 1 || szOut[0] != byExpected)
			TT_Fail("ISO-8859-15 0x%02X (U+%04lX) -> erwartet CP1252 0x%02X, erhalten %s",
					b, lCp, byExpected, Hex(szOut, lRet > 0 ? lRet : 0));
	}
	TT_EndTest();
}

static void Test_RueckgabewertIstLaenge(void)
{
	static const long alText[] = { 'a', 0x00FC, 'b', 0x20AC, 'c', -1 };
	unsigned char szIn[64];
	unsigned char szOut[64];
	long lInLen = 0;
	long lRet;
	int i;

	TT_BeginTest("ISOTranslate: Rueckgabewert ist die Laenge des Ergebnisses");

	for (i = 0; alText[i] >= 0; ++i)
		lInLen += SpecUtf8Encode(alText[i], szIn + lInLen);

	lRet = Run(szIn, lInLen, IDX_UTF8, szOut, sizeof(szOut));

	if (lRet != (long)strlen((const char*)szOut))
		TT_Fail("Rueckgabe %ld, tatsaechliche Laenge %ld", lRet, (long)strlen((const char*)szOut));
	if (lRet != 5)
		TT_Fail("erwartet 5 Bytes (a ue b Euro c), erhalten %ld: %s", lRet, Hex(szOut, lRet > 0 ? lRet : 0));

	TT_EndTest();
}

void RunIsoTranslateTests(void)
{
	TT_Suite("utils.cpp - Verhalten von ISOTranslate()");

	Test_KeineUebersetzungBeiIndexBis2();
	Test_AsciiUnveraendert();
	Test_Latin1EinzelzeichenA0BisFF();
	Test_Cp1252SonderzeichenEinzeln();
	Test_DeutscherBeispieltext();
	Test_ErsetzungFrisstNachbarzeichen();
	Test_ZeichenSindVoneinanderUnabhaengig();
	Test_Latin9Uebersetzung();
	Test_RueckgabewertIstLaenge();
}
