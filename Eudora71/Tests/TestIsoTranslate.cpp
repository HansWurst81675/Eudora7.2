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

// ---------------------------------------------------------------------------
// Ab hier: Faelle, die das reine Tabellenverfahren nicht konnte.
//
// pcXlateTable bildet eine UTF-8-Bytefolge auf EIN CP1252-Byte ab, und
// MAX_CHARS_TO_TRANS ist 3. Ein Emoji ist vier Byte lang und war damit
// prinzipiell nicht abbildbar; alles ohne CP1252-Entsprechung - kyrillisch,
// griechisch, chinesisch, polnisch - blieb als rohe UTF-8-Bytes stehen und
// erschien als Zeichensalat. Die Tests hier belegen, dass das vorbei ist.
//
// Die Erwartungswerte fuer die Ersatztabelle der Codepage (U+0142 -> 'l' und so
// weiter) sind gemessen, nicht geraten: sie stammen aus einem Lauf gegen den
// Windows-Wandler und stehen hier, damit eine spaetere Aenderung auffaellt.
// ---------------------------------------------------------------------------

// Uebersetzt einen einzelnen Codepunkt und liefert die Ergebnislaenge;
// das Ergebnis steht in pOut.
static long TranslateCp(long lCp, unsigned char* pOut, long lOutCapacity)
{
	unsigned char szUtf8[8];
	int iLen = SpecUtf8Encode(lCp, szUtf8);
	if (iLen == 0) return -1;
	return Run(szUtf8, iLen, IDX_UTF8, pOut, lOutCapacity);
}

static void Test_EmojiWirdZuFragezeichen(void)
{
	// U+1F600 GRINNING FACE, UTF-8 F0 9F 98 80. Vier Byte - von der Tabelle
	// prinzipiell nicht erreichbar, weil MAX_CHARS_TO_TRANS 3 ist. Frueher
	// blieben alle vier Bytes stehen und wurden als vier CP1252-Zeichen
	// angezeigt: der Zeichensalat.
	//
	// Gemessen: der Wandler liefert ZWEI Fragezeichen, nicht eines. Ein Zeichen
	// ausserhalb der BMP ist in UTF-16 ein Ersatzzeichenpaar, und
	// WideCharToMultiByte setzt fuer jede der beiden Haelften ein Ersatzzeichen.
	// Zwei Fragezeichen statt vier Salatzeichen - das ist der Gewinn.
	static const unsigned char szExpected[] = { '?', '?' };
	unsigned char szOut[32];
	long lRet;

	TT_BeginTest("ISOTranslate: ein Emoji (vier Byte) wird zu Fragezeichen statt zu Bytesalat");

	lRet = TranslateCp(0x1F600, szOut, sizeof(szOut));

	if (lRet != (long)sizeof(szExpected) || memcmp(szOut, szExpected, sizeof(szExpected)) != 0)
		TT_Fail("U+1F600 (F0 9F 98 80) -> erwartet %s, erhalten %ld Bytes: %s",
				Hex(szExpected, (long)sizeof(szExpected)), lRet, Hex(szOut, lRet > 0 ? lRet : 0));

	TT_EndTest();
}

static void Test_KyrillischUndHebraeisch(void)
{
	// Zwei Byte in UTF-8, ohne CP1252-Entsprechung und ohne nahen Verwandten.
	// Frueher blieben beide Bytes stehen und wurden als zwei CP1252-Zeichen
	// angezeigt.
	static const long alCp[] = { 0x0416, 0x0439, 0x044F, 0x05D0, 0x05EA, -1 };
	unsigned char szOut[32];
	int i;

	TT_BeginTest("ISOTranslate: kyrillisch und hebraeisch werden zu '?'");

	for (i = 0; alCp[i] >= 0; ++i)
	{
		long lRet = TranslateCp(alCp[i], szOut, sizeof(szOut));
		if (lRet != 1 || szOut[0] != '?')
			TT_Fail("U+%04lX -> erwartet 1 Byte '?', erhalten %ld Bytes: %s",
					alCp[i], lRet, Hex(szOut, lRet > 0 ? lRet : 0));
	}
	TT_EndTest();
}

static void Test_ChinesischUndJapanisch(void)
{
	// Drei Byte in UTF-8, ohne CP1252-Entsprechung.
	static const long alCp[] = { 0x4E2D, 0x6587, 0x3042, 0xD55C, -1 };
	unsigned char szOut[32];
	int i;

	TT_BeginTest("ISOTranslate: chinesisch, japanisch und koreanisch werden zu '?'");

	for (i = 0; alCp[i] >= 0; ++i)
	{
		long lRet = TranslateCp(alCp[i], szOut, sizeof(szOut));
		if (lRet != 1 || szOut[0] != '?')
			TT_Fail("U+%04lX -> erwartet 1 Byte '?', erhalten %ld Bytes: %s",
					alCp[i], lRet, Hex(szOut, lRet > 0 ? lRet : 0));
	}
	TT_EndTest();
}

static void Test_NahenVerwandtenStattFragezeichen(void)
{
	// Diese Zeichen haben kein CP1252-Byte, aber einen nahen Verwandten. Der
	// Wandler wird mit dwFlags 0 aufgerufen und benutzt deshalb die
	// Ersatztabelle der Codepage: polnische, tschechische, tuerkische und sogar
	// griechische Post bleibt lesbar, statt zu Fragezeichen zu werden.
	// Alle Erwartungswerte sind gemessen.
	static const struct { long lCp; unsigned char byErwartet; const char* szName; } aFall[] =
	{
		{ 0x0141, (unsigned char)'L', "L mit Querstrich (polnisch)" },
		{ 0x0142, (unsigned char)'l', "l mit Querstrich (polnisch)" },
		{ 0x0104, (unsigned char)'A', "A mit Ogonek (polnisch)" },
		{ 0x0105, (unsigned char)'a', "a mit Ogonek (polnisch)" },
		{ 0x010D, (unsigned char)'c', "c mit Hatschek (tschechisch)" },
		{ 0x0159, (unsigned char)'r', "r mit Hatschek (tschechisch)" },
		{ 0x015F, (unsigned char)'s', "s mit Cedille (tuerkisch)" },
		{ 0x011F, (unsigned char)'g', "g mit Breve (tuerkisch)" },
		{ 0x03B1, (unsigned char)'a', "Alpha (griechisch)" },
		{ 0x03A9, (unsigned char)'O', "Omega (griechisch)" },
		{ 0,      0,                  0 }
	};
	unsigned char szOut[32];
	int i;

	TT_BeginTest("ISOTranslate: Zeichen ohne CP1252-Entsprechung bekommen den nahen Verwandten");

	for (i = 0; aFall[i].szName; ++i)
	{
		long lRet = TranslateCp(aFall[i].lCp, szOut, sizeof(szOut));
		if (lRet != 1 || szOut[0] != aFall[i].byErwartet)
			TT_Fail("U+%04lX (%s) -> erwartet 1 Byte '%c', erhalten %ld Bytes: %s",
					aFall[i].lCp, aFall[i].szName, aFall[i].byErwartet,
					lRet, Hex(szOut, lRet > 0 ? lRet : 0));
	}
	TT_EndTest();
}

static void Test_JedesZeichenWirdZuGenauEinemByte(void)
{
	// Der Kern des Gewinns: KEIN Zeichen bleibt mehr als rohe UTF-8-Bytefolge
	// stehen. Jeder Codepunkt der BMP muss zu genau einem Byte werden - egal ob
	// zum passenden CP1252-Byte, zu einem Verwandten oder zum Fragezeichen.
	// Frueher blieben zwei bis drei Bytes stehen, sobald es keine Tabellenzeile
	// gab: das war der Zeichensalat.
	long lCp;
	long lGeprueft = 0;
	long lFalsch   = 0;
	unsigned char szOut[32];

	TT_BeginTest("ISOTranslate: jedes BMP-Zeichen wird zu genau einem Byte, nie zu Bytesalat");

	for (lCp = 0x00A0; lCp <= 0xFFFD; ++lCp)
	{
		long lRet;

		if (lCp >= 0xD800 && lCp <= 0xDFFF) continue;	// Ersatzzeichenbereich
		if (lCp >= 0xFDD0 && lCp <= 0xFDEF) continue;	// Nichtzeichen
		if ((lCp & 0xFFFE) == 0xFFFE)       continue;	// Nichtzeichen

		++lGeprueft;
		lRet = TranslateCp(lCp, szOut, sizeof(szOut));

		if (lRet != 1)
		{
			if (lFalsch < 10)
				TT_Fail("U+%04lX -> erwartet genau 1 Byte, erhalten %ld: %s",
						lCp, lRet, Hex(szOut, lRet > 0 ? lRet : 0));
			++lFalsch;
		}
	}

	if (lFalsch > 0)
		TT_Note("%ld von %ld Codepunkten werden nicht zu genau einem Byte", lFalsch, lGeprueft);

	TT_EndTest();
}

static void Test_NewsletterMitEmoji(void)
{
	// Der Fall, an dem der Fehler aufgefallen ist: ein deutscher Newsletter mit
	// typografischen Anfuehrungszeichen, Gedankenstrich, Eurozeichen, Umlauten
	// und einem Emoji. Vor der Umstellung liess das Emoji vier rohe Bytes im
	// Text stehen; jetzt bleibt der Rest der Zeile unbeschadet.
	static const long alText[] =
	{
		0x201E,'A','n','g','e','b','o','t',0x201C,' ',0x2013,' ',
		'j','e','t','z','t',' ','f',0x00FC,'r',' ','9',',','9','9',' ',0x20AC,
		' ', 0x1F600, ' ','G','r',0x00FC,0x00DF,'e',0x2019,
		-1
	};
	static const unsigned char szExpected[] =
	{
		0x84,'A','n','g','e','b','o','t',0x93,' ',0x96,' ',
		'j','e','t','z','t',' ','f',0xFC,'r',' ','9',',','9','9',' ',0x80,
		' ', '?','?', ' ','G','r',0xFC,0xDF,'e',0x92
	};
	unsigned char szIn[128];
	unsigned char szOut[128];
	long lInLen = 0;
	long lRet;
	int i;

	TT_BeginTest("ISOTranslate: deutscher Newsletter mit Anfuehrung, Gedankenstrich, Euro und Emoji");

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

static void Test_KaputtesUtf8BleibtStehen(void)
{
	// Post, die utf-8 behauptet und in Wahrheit CP1252-Bytes traegt, ist haeufig.
	// Solche Bytes duerfen NICHT zu Fragezeichen werden - sie werden ja richtig
	// angezeigt, wenn man sie in Ruhe laesst. Der Wandler laeuft deshalb mit
	// MB_ERR_INVALID_CHARS und faellt bei ungueltigem UTF-8 auf die Tabelle
	// zurueck, die alles Unbekannte unveraendert durchreicht.
	static const unsigned char szIn[] = { 'G','r',0xFC,0xDF,'e',' ','2','0',0x80 };
	unsigned char szOut[64];
	long lRet;

	TT_BeginTest("ISOTranslate: ungueltiges UTF-8 wird nicht zu Fragezeichen zerredet");

	lRet = Run(szIn, (long)sizeof(szIn), IDX_UTF8, szOut, sizeof(szOut));

	if (lRet != (long)sizeof(szIn) || memcmp(szOut, szIn, sizeof(szIn)) != 0)
		TT_Fail("erwartet unveraendert %s, erhalten %s",
				Hex(szIn, (long)sizeof(szIn)), Hex(szOut, lRet > 0 ? lRet : 0));

	TT_EndTest();
}

static void Test_AbgeschnittenesZeichenAmZeilenende(void)
{
	// TextReader liest zeilenweise in einen Puffer fester Groesse. Ist eine Zeile
	// laenger als der Puffer, wird mitten in einem Zeichen geschnitten. Der
	// Rueckfall auf die Tabelle muss dann wenigstens den vollstaendigen Teil
	// uebersetzen - genau wie vor der Umstellung.
	static const unsigned char szIn[]       = { 'a', 0xC3, 0xBC, 'b', 0xC3 };
	static const unsigned char szExpected[] = { 'a', 0xFC, 'b', 0xC3 };
	unsigned char szOut[64];
	long lRet;

	TT_BeginTest("ISOTranslate: bei abgeschnittenem Zeichen faellt die Tabelle ein");

	lRet = Run(szIn, (long)sizeof(szIn), IDX_UTF8, szOut, sizeof(szOut));

	if (lRet != (long)sizeof(szExpected) || memcmp(szOut, szExpected, sizeof(szExpected)) != 0)
		TT_Fail("Eingabe %s -> erwartet %s, erhalten %s",
				Hex(szIn, (long)sizeof(szIn)), Hex(szExpected, (long)sizeof(szExpected)),
				Hex(szOut, lRet > 0 ? lRet : 0));

	TT_EndTest();
}

static void Test_ErgebnisNieLaengerAlsEingabe(void)
{
	// ISOTranslate arbeitet an Ort und Stelle im Puffer des Aufrufers. Wuerde es
	// mehr Bytes schreiben als hereinkamen, waere das ein Speicherueberlauf.
	// Geprueft ueber die Laengen 1..8 mit einem Zeichen aus jedem Bereich.
	static const long alCp[] = { 'a', 0x00FC, 0x20AC, 0x0416, 0x4E2D, 0x1F600, -1 };
	unsigned char szIn[64];
	unsigned char szOut[128];
	int i, iWdh;

	TT_BeginTest("ISOTranslate: das Ergebnis ist nie laenger als die Eingabe");

	for (i = 0; alCp[i] >= 0; ++i)
	{
		for (iWdh = 1; iWdh <= 8; ++iWdh)
		{
			long lInLen = 0;
			long lRet;
			int k;

			for (k = 0; k < iWdh; ++k)
				lInLen += SpecUtf8Encode(alCp[i], szIn + lInLen);

			lRet = Run(szIn, lInLen, IDX_UTF8, szOut, sizeof(szOut));

			if (lRet < 0 || lRet > lInLen)
				TT_Fail("U+%04lX %d mal: Eingabe %ld Bytes, Ergebnis %ld Bytes",
						alCp[i], iWdh, lInLen, lRet);
		}
	}
	TT_EndTest();
}

static void Test_Latin9BehaeltCp1252Bytes(void)
{
	// Bewusste Entscheidung: ISO-8859-15 bleibt bei der Tabelle und laeuft NICHT
	// ueber Codepage 28605. Dort sind 0x80..0x9F C1-Steuerzeichen, in CP1252 sind
	// es druckbare Zeichen. Post, die iso-8859-15 behauptet und CP1252-Bytes
	// traegt, wuerde sonst zu Fragezeichen. Diese Bytes muessen stehen bleiben.
	int b;
	TT_BeginTest("ISOTranslate: ISO-8859-15 laesst die Bytes 0x80..0x9F unveraendert");

	for (b = 0x80; b <= 0x9F; ++b)
	{
		unsigned char szIn[4];
		unsigned char szOut[16];
		long lRet;

		szIn[0] = (unsigned char)b;
		lRet = Run(szIn, 1, IDX_LATIN9, szOut, sizeof(szOut));

		if (lRet != 1 || szOut[0] != (unsigned char)b)
			TT_Fail("ISO-8859-15 0x%02X -> erwartet unveraendert, erhalten %s",
					b, Hex(szOut, lRet > 0 ? lRet : 0));
	}
	TT_EndTest();
}

// ---------------------------------------------------------------------------
// ISOIncompleteUTF8Tail - der Uebergang zwischen zwei Lesestuecken
//
// TextReader::ReadIt uebersetzt den Nachrichtenrumpf stueckweise. Faellt eine
// Stueckgrenze mitten in ein UTF-8-Zeichen, ist keine der beiden Haelften
// gueltiges UTF-8; ISOTranslate laesst beide stehen und im Postfach landen die
// rohen Bytes. Genau ein Umlaut ist dann kaputt, alle anderen stimmen. Diese
// Funktion sagt dem Aufrufer, wie viele Bytes er zurueckhalten muss.

static void Test_AngefangenesZeichenWirdGezaehlt(void)
{
	// Jedes Mal wird ein Zeichen genau eine Stelle zu frueh abgeschnitten.
	static const unsigned char szEin2[]  = { 'f', 0xC3 };					// u-Umlaut, 1 von 2
	static const unsigned char szEin3a[] = { 'x', 0xE2 };					// Euro, 1 von 3
	static const unsigned char szEin3b[] = { 'x', 0xE2, 0x82 };				// Euro, 2 von 3
	static const unsigned char szEin4a[] = { 'x', 0xF0 };					// Emoji, 1 von 4
	static const unsigned char szEin4c[] = { 'x', 0xF0, 0x9F, 0x98 };		// Emoji, 3 von 4

	TT_BeginTest("ISOIncompleteUTF8Tail: angefangenes Zeichen wird gezaehlt");

	if (UT_ISOIncompleteUTF8Tail((const char*)szEin2, (long)sizeof(szEin2)) != 1)
		TT_Fail("C3 am Ende: erwartet 1, erhalten %ld",
				UT_ISOIncompleteUTF8Tail((const char*)szEin2, (long)sizeof(szEin2)));
	if (UT_ISOIncompleteUTF8Tail((const char*)szEin3a, (long)sizeof(szEin3a)) != 1)
		TT_Fail("E2 am Ende: erwartet 1, erhalten %ld",
				UT_ISOIncompleteUTF8Tail((const char*)szEin3a, (long)sizeof(szEin3a)));
	if (UT_ISOIncompleteUTF8Tail((const char*)szEin3b, (long)sizeof(szEin3b)) != 2)
		TT_Fail("E2 82 am Ende: erwartet 2, erhalten %ld",
				UT_ISOIncompleteUTF8Tail((const char*)szEin3b, (long)sizeof(szEin3b)));
	if (UT_ISOIncompleteUTF8Tail((const char*)szEin4a, (long)sizeof(szEin4a)) != 1)
		TT_Fail("F0 am Ende: erwartet 1, erhalten %ld",
				UT_ISOIncompleteUTF8Tail((const char*)szEin4a, (long)sizeof(szEin4a)));
	if (UT_ISOIncompleteUTF8Tail((const char*)szEin4c, (long)sizeof(szEin4c)) != 3)
		TT_Fail("F0 9F 98 am Ende: erwartet 3, erhalten %ld",
				UT_ISOIncompleteUTF8Tail((const char*)szEin4c, (long)sizeof(szEin4c)));

	TT_EndTest();
}

static void Test_VollstaendigesZeichenWirdNichtZurueckgehalten(void)
{
	// Ein ganzes Zeichen am Pufferende darf nicht aufgehalten werden, sonst
	// wandert bei jedem Stueck Text ins naechste und die Reihenfolge leidet.
	static const unsigned char szAscii[] = { 'a', 'b', 'c' };
	static const unsigned char sz2[]     = { 'f', 0xC3, 0xBC };				// u-Umlaut komplett
	static const unsigned char sz3[]     = { 'x', 0xE2, 0x82, 0xAC };		// Euro komplett
	static const unsigned char sz4[]     = { 'x', 0xF0, 0x9F, 0x98, 0x80 };	// Emoji komplett
	static const unsigned char szCp[]    = { 'f', 0xFC, 'r' };				// CP1252, kein UTF-8
	static const unsigned char szMuell[] = { 'a', 0x80 };					// Folgebyte ohne Kopf

	TT_BeginTest("ISOIncompleteUTF8Tail: vollstaendiges Zeichen wird nicht zurueckgehalten");

	if (UT_ISOIncompleteUTF8Tail((const char*)szAscii, (long)sizeof(szAscii)) != 0)
		TT_Fail("reines ASCII: erwartet 0");
	if (UT_ISOIncompleteUTF8Tail((const char*)sz2, (long)sizeof(sz2)) != 0)
		TT_Fail("C3 BC komplett: erwartet 0");
	if (UT_ISOIncompleteUTF8Tail((const char*)sz3, (long)sizeof(sz3)) != 0)
		TT_Fail("E2 82 AC komplett: erwartet 0");
	if (UT_ISOIncompleteUTF8Tail((const char*)sz4, (long)sizeof(sz4)) != 0)
		TT_Fail("F0 9F 98 80 komplett: erwartet 0");
	if (UT_ISOIncompleteUTF8Tail((const char*)szCp, (long)sizeof(szCp)) != 0)
		TT_Fail("CP1252-Byte FC: erwartet 0");
	if (UT_ISOIncompleteUTF8Tail((const char*)szMuell, (long)sizeof(szMuell)) != 0)
		TT_Fail("Folgebyte 80 ohne Kopf: erwartet 0");
	if (UT_ISOIncompleteUTF8Tail((const char*)szAscii, 0) != 0)
		TT_Fail("leerer Puffer: erwartet 0");
	if (UT_ISOIncompleteUTF8Tail(0, 5) != 0)
		TT_Fail("kein Puffer: erwartet 0");

	TT_EndTest();
}

static void Test_ZusammensetzenErgibtDenRichtigenText(void)
{
	// Der gemeldete Fall: "fuer" wird zwischen C3 und BC getrennt. Ohne
	// Zurueckhalten bleiben beide Bytes roh stehen ("f C3 BC r"), mit
	// Zurueckhalten kommt genau ein CP1252-Byte heraus ("f FC r").
	static const unsigned char szStueck1[] = { 'f', 0xC3 };
	static const unsigned char szStueck2[] = { 0xBC, 'r' };
	static const unsigned char szErwartet[] = { 'f', 0xFC, 'r' };
	unsigned char szPuffer[64];
	long lHalt, lLen, lRet;

	TT_BeginTest("ISOIncompleteUTF8Tail: getrenntes Zeichen wird ueber die Stueckgrenze heil");

	// Stueck 1: was uebrig bleibt, wird zurueckgehalten und uebersetzt.
	lHalt = UT_ISOIncompleteUTF8Tail((const char*)szStueck1, (long)sizeof(szStueck1));
	lLen  = (long)sizeof(szStueck1) - lHalt;
	memset(szPuffer, 0, sizeof(szPuffer));
	memcpy(szPuffer, szStueck1, (size_t)lLen);
	lRet = UT_ISOTranslate((char*)szPuffer, lLen, IDX_UTF8);

	// Stueck 2: das zurueckgehaltene Byte kommt vorne wieder dran.
	{
		unsigned char szNaechstes[64];
		long lNaechstesLen = lHalt + (long)sizeof(szStueck2);
		long lRet2;

		memset(szNaechstes, 0, sizeof(szNaechstes));
		memcpy(szNaechstes, szStueck1 + lLen, (size_t)lHalt);
		memcpy(szNaechstes + lHalt, szStueck2, sizeof(szStueck2));
		lRet2 = UT_ISOTranslate((char*)szNaechstes, lNaechstesLen, IDX_UTF8);

		memcpy(szPuffer + lRet, szNaechstes, (size_t)lRet2);
		lRet += lRet2;
	}

	if (lRet != (long)sizeof(szErwartet) || memcmp(szPuffer, szErwartet, sizeof(szErwartet)) != 0)
		TT_Fail("erwartet %s, erhalten %s",
				Hex(szErwartet, (long)sizeof(szErwartet)), Hex(szPuffer, lRet > 0 ? lRet : 0));

	TT_EndTest();
}

static void Test_UTF8IndexWirdErkannt(void)
{
	// TextReader haengt das Zurueckhalten an ISOIsUTF8Charset auf. Ein
	// Einzelbyte-Zeichensatz darf nie zurueckhalten.
	TT_BeginTest("ISOIsUTF8Charset: erkennt genau den UTF-8-Index");

	if (!UT_ISOIsUTF8Charset(IDX_UTF8))
		TT_Fail("Index %d ist UTF-8, wurde aber nicht erkannt", IDX_UTF8);
	if (UT_ISOIsUTF8Charset(IDX_WINDOWS) || UT_ISOIsUTF8Charset(IDX_US_ASCII) ||
		UT_ISOIsUTF8Charset(IDX_LATIN1)  || UT_ISOIsUTF8Charset(IDX_LATIN9))
		TT_Fail("ein Index ausser %d wurde faelschlich als UTF-8 erkannt", IDX_UTF8);

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

	// Was das Tabellenverfahren nicht konnte
	Test_EmojiWirdZuFragezeichen();
	Test_KyrillischUndHebraeisch();
	Test_ChinesischUndJapanisch();
	Test_NahenVerwandtenStattFragezeichen();
	Test_JedesZeichenWirdZuGenauEinemByte();
	Test_NewsletterMitEmoji();

	// Dass die Umstellung nichts kaputt macht
	Test_KaputtesUtf8BleibtStehen();
	Test_AbgeschnittenesZeichenAmZeilenende();
	Test_ErgebnisNieLaengerAlsEingabe();
	Test_Latin9BehaeltCp1252Bytes();

	// Der Uebergang zwischen zwei Lesestuecken
	Test_AngefangenesZeichenWirdGezaehlt();
	Test_VollstaendigesZeichenWirdNichtZurueckgehalten();
	Test_ZusammensetzenErgibtDenRichtigenText();
	Test_UTF8IndexWirdErkannt();
}
