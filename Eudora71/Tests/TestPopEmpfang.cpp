//
// TestPopEmpfang.cpp - der Empfangspfad von POP3, soweit er ohne Netz pruefbar ist
//
// Gegenstand ist die Strecke, die eine abgerufene Nachricht nach dem Netz nimmt:
//
//   POPSession::FetchMessageToSpool      Rohtext in die Spool-Datei
//   CPOP::WriteMessageToMBX_             pop.cpp:656
//     HeaderDesc::Read                   header.cpp:77
//       Fix2047 / Translate2047          lex822.cpp:554 / :514   <- hier geprueft
//     MIMEState::Init -> Reader::ReadIt  mime.cpp:109
//       FindMIMECharset                  mime.cpp:382            <- hier geprueft
//       ISOTranslate                     utils.cpp:1162          <- hier geprueft
//
// Netz, Sockets und SSL kommen darin nicht vor. Die Zeichenketten unten sind genau
// das, was der Server auf der Leitung schickt.
//
// Alle Zeichen jenseits von ASCII stehen als \x-Folge da, damit diese Datei in jeder
// Kodierung dasselbe bedeutet. Die Nutzdaten sind UTF-8, das Ergebnis ist CP1252.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTest.h"
#include "UnderTest2047.h"

// Zeichensatz-Indizes, wie FindMIMECharset sie liefert und ISOTranslate sie erwartet.
#define IDX_WINDOWS			0
#define IDX_US_ASCII		1
#define IDX_ISO_LATIN1		2
#define IDX_ISO_LATIN9		3
#define IDX_UTF_8			4

// ---------------------------------------------------------------------------
// Hilfsmittel
// ---------------------------------------------------------------------------

// Gibt einen Puffer als Bytefolge aus, damit ein Fehlschlag lesbar ist.
static void NoteBytes(const char* szWas, const char* pBuf, int iLen)
{
	char	szZeile[512];
	int		i;
	size_t	n;

	strncpy(szZeile, szWas, sizeof(szZeile) - 1);
	szZeile[sizeof(szZeile) - 1] = 0;
	n = strlen(szZeile);

	for (i = 0; i < iLen && n + 4 < sizeof(szZeile); ++i)
	{
		sprintf(szZeile + n, " %02X", (unsigned char)pBuf[i]);
		n += 3;
	}

	TT_Note("%s (%d Byte)%s", szWas, iLen, szZeile + strlen(szWas));
}

// Vergleicht einen Puffer mit einer erwarteten Bytefolge.
static void PruefeBytes(const char* szWas, const char* pIst, int iIstLen,
						const char* pSoll, int iSollLen)
{
	if (iIstLen == iSollLen && memcmp(pIst, pSoll, (size_t)iSollLen) == 0)
		return;

	TT_Fail("%s stimmt nicht", szWas);
	NoteBytes("  ist ", pIst, iIstLen);
	NoteBytes("  soll", pSoll, iSollLen);
}

// Laesst Fix2047 auf einer Kopie laufen und vergleicht mit der Erwartung.
// Fix2047 arbeitet an Ort und Stelle und braucht Platz fuer die Nullterminierung,
// die Translate2047 ueber ISOTranslate anhaengt.
static void PruefeKopfzeile(const char* szWas, const char* szEingabe, const char* szErwartet)
{
	char	szPuffer[2048];
	int		iLen = (int)strlen(szEingabe);

	memset(szPuffer, 0, sizeof(szPuffer));
	memcpy(szPuffer, szEingabe, (size_t)iLen);

	UT_Fix2047(szPuffer, &iLen);

	PruefeBytes(szWas, szPuffer, (int)strlen(szPuffer),
				szErwartet, (int)strlen(szErwartet));

	// Fix2047 fuehrt len mit. Wer sich darauf verlaesst, muss dieselbe Laenge sehen
	// wie strlen - sonst haengt am Ende der Kopfzeile Muell.
	if (iLen != (int)strlen(szPuffer))
	{
		TT_Fail("%s: Fix2047 meldet len=%d, strlen sagt %d",
				szWas, iLen, (int)strlen(szPuffer));
	}
}

// Liest eine Datei vollstaendig ein. Der Aufrufer gibt den Puffer frei.
static char* DateiLesen(const char* szPfad, long* plSize)
{
	FILE* f = fopen(szPfad, "rb");
	char* pBuf;
	long  lSize;

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
// 1. Der Zeichensatzindex
// ---------------------------------------------------------------------------

static void Test_FindMIMECharset(void)
{
	TT_BeginTest("POP: FindMIMECharset liefert die Indizes, die ISOTranslate erwartet");

	// Die Zuordnung steht in mime.cpp:382 und in der Bedingung "iCharsetIdx > 2"
	// an beiden Aufrufstellen (TextReader.cpp:246, lex822.cpp:540).
	TT_CHECK(UT_FindMIMECharset("windows-1252")	== IDX_WINDOWS);
	TT_CHECK(UT_FindMIMECharset("Windows-1251")	== IDX_WINDOWS);
	TT_CHECK(UT_FindMIMECharset("us-ascii")		== IDX_US_ASCII);
	TT_CHECK(UT_FindMIMECharset("US-ASCII")		== IDX_US_ASCII);
	TT_CHECK(UT_FindMIMECharset("iso-8859-1")	== IDX_ISO_LATIN1);
	TT_CHECK(UT_FindMIMECharset("ISO-8859-1")	== IDX_ISO_LATIN1);
	TT_CHECK(UT_FindMIMECharset("iso-8859-15")	== IDX_ISO_LATIN9);
	TT_CHECK(UT_FindMIMECharset("utf-8")		== IDX_UTF_8);
	TT_CHECK(UT_FindMIMECharset("UTF-8")		== IDX_UTF_8);

	// Ein unbekannter Zeichensatz muss -1 liefern. Translate2047 steigt darauf
	// aus (lex822.cpp:520), TextReader laesst den Text unveraendert.
	TT_CHECK(UT_FindMIMECharset("koi8-r")		== -1);
	TT_CHECK(UT_FindMIMECharset("iso-2022-jp")	== -1);

	TT_EndTest();
}

static void Test_PopHatDieVerschiebungUmEins(void)
{
	TT_BeginTest("POP: der Index wird um eins verschoben - anders als im IMAP-Pfad");

	// Belegstelle fuer den bekannten IMAP-Fehler:
	//   EuImap/src/ImapDownload.cpp:4644 ruft FindRStringIndexI unmittelbar auf und
	//   gibt das Ergebnis ohne die Verschiebung an ISOTranslate weiter.
	// Der POP-Pfad geht ueber FindMIMECharset (mime.cpp:382), das den Wert um eins
	// hochzaehlt. Dieser Test haelt den Unterschied fest.
	const int iRohUtf8   = UT_FindRStringIndexI(3611, 3614, "utf-8");
	const int iRohLatin9 = UT_FindRStringIndexI(3611, 3614, "iso-8859-15");

	TT_CHECK(iRohUtf8   == 3);
	TT_CHECK(iRohLatin9 == 2);

	TT_CHECK(UT_FindMIMECharset("utf-8")       == iRohUtf8 + 1);
	TT_CHECK(UT_FindMIMECharset("iso-8859-15") == iRohLatin9 + 1);

	// Was der rohe Wert anrichtet, wenn man ihn wie im IMAP-Pfad durchreicht:
	//
	//  - 2 fuer iso-8859-15 ist "<= 2". ISOTranslate steigt sofort aus, der Text
	//    bleibt unuebersetzt.
	//  - 3 fuer utf-8 waehlt nach dem Abzug von 3 die Tabellenzeile 0 - das ist die
	//    ISO-8859-15-Tabelle. Der UTF-8-Text wird also nach der FALSCHEN Tabelle
	//    behandelt: aus dem Fortsetzungsbyte 0xBC wird 0x8C, der Text ist danach
	//    weder UTF-8 noch CP1252, sondern kaputt.
	{
		char szRoh[64];
		char szRichtig[64];
		char szLatin9Roh[64];
		long lRoh, lRichtig, lLatin9;

		// "Gr" + U+00FC + U+00DF + "e", in UTF-8 sieben Bytes.
		strcpy(szRoh,     "Gr\xC3\xBC\xC3\x9F" "e");
		strcpy(szRichtig, "Gr\xC3\xBC\xC3\x9F" "e");

		lRoh     = UT_ISOTranslate(szRoh,     (long)strlen(szRoh),     (unsigned)iRohUtf8);
		lRichtig = UT_ISOTranslate(szRichtig, (long)strlen(szRichtig), (unsigned)IDX_UTF_8);

		// Mit dem rohen Index greift die ISO-8859-15-Tabelle ins UTF-8: BC -> 8C.
		PruefeBytes("roher Index (wie IMAP)", szRoh, (int)lRoh,
					"Gr\xC3\x8C\xC3\x9F" "e", 7);

		// Mit dem Index aus FindMIMECharset wird richtig uebersetzt.
		PruefeBytes("Index aus FindMIMECharset", szRichtig, (int)lRichtig,
					"Gr\xFC\xDF" "e", 5);

		// Und ISO-8859-15 bliebe mit dem rohen Index ganz unuebersetzt:
		// 0xA4 ist dort das Eurozeichen und muesste 0x80 werden.
		strcpy(szLatin9Roh, "\xA4 5");
		lLatin9 = UT_ISOTranslate(szLatin9Roh, (long)strlen(szLatin9Roh), (unsigned)iRohLatin9);
		PruefeBytes("ISO-8859-15 mit rohem Index", szLatin9Roh, (int)lLatin9,
					"\xA4 5", 3);
	}

	TT_EndTest();
}

// ---------------------------------------------------------------------------
// 2. Kodierte Kopfzeilen nach RFC 2047 - Betreff und Absendername
// ---------------------------------------------------------------------------

static void Test_BetreffBase64Utf8(void)
{
	TT_BeginTest("POP: Betreff, Base64 ueber UTF-8 kodiert");

	// "Gr\xC3\xBC\xC3\x9Fe" (= "Gruesse" mit Umlaut und scharfem s) in Base64.
	PruefeKopfzeile("Betreff B/UTF-8",
					"=?UTF-8?B?R3LDvMOfZQ==?=",
					"Gr\xFC\xDF" "e");

	// Das Eurozeichen ist in UTF-8 drei Bytes (E2 82 AC) und in CP1252 eines (0x80).
	PruefeKopfzeile("Betreff B/UTF-8 mit Euro",
					"=?utf-8?B?4oKsIDUw?=",
					"\x80 50");

	TT_EndTest();
}

static void Test_BetreffQuotedPrintableUtf8(void)
{
	TT_BeginTest("POP: Betreff, Quoted-Printable ueber UTF-8 kodiert");

	PruefeKopfzeile("Betreff Q/UTF-8",
					"=?utf-8?Q?Gr=C3=BC=C3=9Fe?=",
					"Gr\xFC\xDF" "e");

	// In der Q-Kodierung steht der Unterstrich fuer das Leerzeichen (RFC 2047, 4.2).
	PruefeKopfzeile("Betreff Q/UTF-8 mit Unterstrich",
					"=?utf-8?Q?Sch=C3=B6ne_Gr=C3=BC=C3=9Fe?=",
					"Sch\xF6ne Gr\xFC\xDF" "e");

	TT_EndTest();
}

static void Test_BetreffLatin1(void)
{
	TT_BeginTest("POP: Betreff in ISO-8859-1 wird dekodiert, aber nicht uebersetzt");

	// Index 2: ISOTranslate laesst den Text unveraendert, weil Latin-1 und CP1252
	// sich im Bereich 0xA0..0xFF decken. 0xFC und 0xDF muessen unveraendert
	// durchkommen.
	PruefeKopfzeile("Betreff Q/ISO-8859-1",
					"=?iso-8859-1?Q?Gr=FC=DFe?=",
					"Gr\xFC\xDF" "e");

	PruefeKopfzeile("Betreff B/ISO-8859-1",
					"=?ISO-8859-1?B?R3L832U=?=",
					"Gr\xFC\xDF" "e");

	TT_EndTest();
}

static void Test_BetreffMitKlartextDrumherum(void)
{
	TT_BeginTest("POP: kodiertes Wort mitten in einer Kopfzeile");

	// So sieht die Zeile aus, die HeaderDesc::Read an Fix2047 gibt.
	PruefeKopfzeile("Betreff mit Klartext davor und dahinter",
					"Re: =?utf-8?Q?Gr=C3=BC=C3=9Fe?= aus Bremen",
					"Re: Gr\xFC\xDF" "e aus Bremen");

	// Eine Zeile ohne kodiertes Wort darf sich nicht veraendern.
	PruefeKopfzeile("Betreff ohne kodiertes Wort",
					"Willkommen bei freenet",
					"Willkommen bei freenet");

	TT_EndTest();
}

static void Test_ZweiKodierteWoerter(void)
{
	TT_BeginTest("POP: zwei aufeinanderfolgende kodierte Woerter");

	// RFC 2047, 6.2: zwischen zwei benachbarten kodierten Woertern faellt der
	// Zwischenraum weg. lex822.cpp:624-634 setzt genau das um.
	PruefeKopfzeile("zwei kodierte Woerter",
					"=?utf-8?Q?Gr=C3=BC=C3=9Fe?= =?utf-8?Q?_und_Dank?=",
					"Gr\xFC\xDF" "e und Dank");

	TT_EndTest();
}

static void Test_AbsendernameWirdWieDerBetreffBehandelt(void)
{
	TT_BeginTest("POP: der Absendername wird wie der Betreff behandelt");

	// header.cpp:77 gibt jede Kopfzeile durch denselben Lexer (lex822.cpp:777),
	// der Fix2047 aufruft. Fuer From gilt also dasselbe wie fuer Subject.
	// "J\xC3\xBCrgen Sch\xC3\xB6n" in Base64 ist "SsO8cmdlbiBTY2jDtm4=".
	PruefeKopfzeile("From mit kodiertem Anzeigenamen",
					"=?UTF-8?B?SsO8cmdlbiBTY2jDtm4=?= <juergen@example.org>",
					"J\xFCrgen Sch\xF6n <juergen@example.org>");

	// Die Adresse selbst ist immer ASCII und darf nicht angefasst werden.
	PruefeKopfzeile("From ohne Anzeigenamen",
					"postmaster@freenet.de",
					"postmaster@freenet.de");

	TT_EndTest();
}

static void Test_KaputteKodierteWoerter(void)
{
	TT_BeginTest("POP: unbrauchbare kodierte Woerter bleiben stehen");

	// Unbekannter Zeichensatz: Translate2047 steigt vor dem Dekodieren aus
	// (lex822.cpp:520). Die Zeile muss unveraendert stehenbleiben, damit der
	// Anwender wenigstens die Rohfassung sieht.
	PruefeKopfzeile("unbekannter Zeichensatz",
					"=?koi8-r?B?VGVzdA==?=",
					"=?koi8-r?B?VGVzdA==?=");

	// Unbekanntes Kodierverfahren (weder B noch Q).
	PruefeKopfzeile("unbekanntes Kodierverfahren",
					"=?utf-8?X?VGVzdA==?=",
					"=?utf-8?X?VGVzdA==?=");

	TT_EndTest();
}

// ---------------------------------------------------------------------------
// 3. Der Nachrichtentext
// ---------------------------------------------------------------------------

static void Test_NachrichtentextUtf8(void)
{
	TT_BeginTest("POP: Nachrichtentext in UTF-8 wird zeilenweise uebersetzt");

	// So kommt eine Zeile aus LineReader::ReadLine in TextReader::ReadIt an:
	// mit dem abschliessenden CRLF, und size ist die Anzahl der Bytes.
	const char	szEingang[]  = "Sch\xC3\xB6nen Gru\xC3\x9F, \xE2\x82\xAC 5\r\n";
	const char	szErwartet[] = "Sch\xF6nen Gru\xDF, \x80 5\r\n";
	char		szZeile[256];
	long		lSize;

	memset(szZeile, 0, sizeof(szZeile));
	lSize = (long)(sizeof(szEingang) - 1);
	memcpy(szZeile, szEingang, (size_t)lSize);

	lSize = UT_ISOTranslate(szZeile, lSize, IDX_UTF_8);

	// Drei Mehrbytefolgen (C3 B6, C3 9F, E2 82 AC) sparen 1 + 1 + 2 = 4 Bytes.
	PruefeBytes("uebersetzte Textzeile", szZeile, (int)lSize,
				szErwartet, (int)(sizeof(szErwartet) - 1));

	// Der Aufrufer erkennt am CRLF, ob die Zeile vollstaendig war
	// (TextReader.cpp:262). Das geht nur mit der NEUEN Laenge.
	TT_CHECK(lSize >= 2 && szZeile[lSize - 2] == '\r' && szZeile[lSize - 1] == '\n');

	TT_EndTest();
}

static void Test_TextReaderUebernimmtDieNeueLaenge(const char* szEudoraDir)
{
	TT_BeginTest("POP: TextReader::ReadIt uebernimmt die neue Laenge von ISOTranslate");

	// Waechtertest auf den Quelltext.
	//
	// ISOTranslate schreibt das Ergebnis in denselben Puffer zurueck und liefert
	// die NEUE, kuerzere Laenge. Wer den Rueckgabewert wegwirft, schreibt hinter
	// dem uebersetzten Text noch die Reste der alten Fassung in die Mailbox -
	// je uebersetztem Zeichen ein Byte. Bei deutscher Post ist das jede Zeile.
	//
	// Genau das stand hier bis zum Befund P-1. Damit es nicht zurueckkehrt,
	// prueft dieser Test die Aufrufstelle im Quelltext.
	char  szPfad[1024];
	char* pQuelle;
	long  lSize;

	sprintf(szPfad, "%s\\TextReader.cpp", szEudoraDir);

	pQuelle = DateiLesen(szPfad, &lSize);
	if (!pQuelle)
	{
		TT_Fail("TextReader.cpp nicht lesbar: %s", szPfad);
	}
	else
	{
		if (!strstr(pQuelle, "size = ISOTranslate(buf, size, iCharsetIdx);"))
		{
			TT_Fail("TextReader.cpp wirft den Rueckgabewert von ISOTranslate weg");
			TT_Note("erwartet: size = ISOTranslate(buf, size, iCharsetIdx);");
			TT_Note("Folge: hinter jedem uebersetzten Zeichen landet ein Restbyte");
			TT_Note("       der alten Fassung in In.mbx (Befund P-1).");
		}
		free(pQuelle);
	}

	TT_EndTest();
}

// ---------------------------------------------------------------------------

void RunPopEmpfangTests(const char* szEudoraDir)
{
	TT_Suite("POP-Empfang - Zeichensatz, Kopfzeilen, Nachrichtentext");

	Test_FindMIMECharset();
	Test_PopHatDieVerschiebungUmEins();
	Test_BetreffBase64Utf8();
	Test_BetreffQuotedPrintableUtf8();
	Test_BetreffLatin1();
	Test_BetreffMitKlartextDrumherum();
	Test_ZweiKodierteWoerter();
	Test_AbsendernameWirdWieDerBetreffBehandelt();
	Test_KaputteKodierteWoerter();
	Test_NachrichtentextUtf8();
	Test_TextReaderUebernimmtDieNeueLaenge(szEudoraDir);
}
