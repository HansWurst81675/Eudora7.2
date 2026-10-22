//
// TestZeichenWege.cpp - die vier Befunde, an denen Umlaute verlorengingen
//
//   NP3-8  der IMAP-Empfang uebersetzte KEINEN einzigen Zeichensatz
//   NP3-9  der Rueckgabewert von ISOTranslate wurde an zwei Stellen verworfen
//   Z-2    die HTML-Zwischendatei sagte ihren Zeichensatz nirgends an
//   Z-2B   ein UTF-8-Zeichen wurde an der Stueckgrenze zerrissen
//
// Alle vier haben dasselbe Schadensbild beim Anwender - ein kaputter Umlaut -
// und vier verschiedene Ursachen an vier verschiedenen Stellen. Sie werden
// hier zusammen geprueft, damit niemand eine davon fuer die andere haelt.
//
// Alle Zeichen jenseits von ASCII stehen als Byte-Werte da, damit diese Datei
// in jeder Kodierung dasselbe bedeutet.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTest.h"
#include "UnderTest2047.h"
#include "UnderTestZ2.h"
#include "Quelltext.h"

// Zeichensatz-Indizes, wie FindMIMECharset sie liefert und ISOTranslate sie erwartet.
#define IDX_WINDOWS			0
#define IDX_US_ASCII		1
#define IDX_ISO_LATIN1		2
#define IDX_ISO_LATIN9		3
#define IDX_UTF_8			4

// Die Ressourcenkennungen der Zeichensatznamen (Eudora/resource.h:1807-1810).
#define RES_US_ASCII		3611
#define RES_ISO_LATIN1		3612
#define RES_ISO_LATIN9		3613
#define RES_UTF_8			3614

static const char* Hex(const unsigned char* p, long lLen)
{
	static char	szZeile[512];
	long		i;
	size_t		n = 0;

	szZeile[0] = 0;
	for (i = 0; i < lLen && n + 4 < sizeof(szZeile); ++i)
	{
		sprintf(szZeile + n, "%02X ", p[i]);
		n += 3;
	}
	return szZeile;
}

static void PruefeBytes(const char* szWas, const void* pIst, long lIst,
						const void* pSoll, long lSoll)
{
	if (lIst == lSoll && memcmp(pIst, pSoll, (size_t)lSoll) == 0)
		return;

	TT_Fail("%s stimmt nicht (%ld Bytes, erwartet %ld)", szWas, lIst, lSoll);
	TT_Note("  ist : %s", Hex((const unsigned char*)pIst, lIst > 0 ? lIst : 0));
	TT_Note("  soll: %s", Hex((const unsigned char*)pSoll, lSoll));
}

// ===========================================================================
// NP3-8 - der IMAP-Empfang uebersetzte keinen einzigen Zeichensatz
// ===========================================================================
//
// ImapDownload.cpp:4644 suchte den Zeichensatznamen mit
//
//     FindRStringIndexI(IDS_MIME_US_ASCII, IDS_MIME_ISO_LATIN9, ...)
//
// also im Bereich 3611 bis 3613 - IDS_MIME_UTF_8 ist 3614 und liegt DAHINTER.
// Ausserdem fehlte das "++iCharSet", mit dem FindMIMECharset die 0 fuer die
// Windows-Zeichensaetze freihaelt. Die Abfrage dahinter lautete "> 1".
//
// Die Tabelle aus BEFUNDE.md, Spalte "ImapDownload.cpp:4644":
//
//     windows-*     -1        us-ascii    0
//     iso-8859-1     1        iso-8859-15 2
//     utf-8         -1   <-- ausserhalb des Suchbereichs
//
// Es gab damit KEINEN Wert, bei dem der IMAP-Weg tatsaechlich uebersetzte.

struct Zeichensatzfall
{
	const char*	szName;
	int			iAlt;		// was der alte IMAP-Weg errechnete
	int			iNeu;		// was FindMIMECharset liefert
};

static const Zeichensatzfall s_aFaelle[] =
{
	{ "windows-1252",	-1,	IDX_WINDOWS		},
	{ "us-ascii",		 0,	IDX_US_ASCII	},
	{ "iso-8859-1",		 1,	IDX_ISO_LATIN1	},
	{ "iso-8859-15",	 2,	IDX_ISO_LATIN9	},
	{ "utf-8",			-1,	IDX_UTF_8		}
};

static void Test_NP3_8_AlterStandUebersetztNie(void)
{
	// "Gr" + u-Umlaut + scharfes s + "e" in UTF-8, sieben Bytes.
	static const unsigned char	szUtf8[]  = { 'G','r',0xC3,0xBC,0xC3,0x9F,'e' };
	// Dasselbe Wort in ISO-8859-15 (dort sind Umlaute wie in Latin-1).
	static const unsigned char	szLatin9[] = { 'G','r',0xFC,0xDF,'e' };
	unsigned int				u;

	TT_BeginTest("NP3-8: der alte IMAP-Weg uebersetzte KEINEN einzigen Zeichensatz");

	for (u = 0; u < sizeof(s_aFaelle) / sizeof(s_aFaelle[0]); ++u)
	{
		const Zeichensatzfall*	pF = &s_aFaelle[u];
		int						iAlt;
		unsigned char			szArbeit[32];
		long					lRaus;

		// 1. Die Zahl aus BEFUNDE.md nachgerechnet: derselbe Aufruf, denselben
		//    Bereich 3611..3613 wie ImapDownload.cpp vor der Behebung.
		iAlt = UT_FindRStringIndexI(RES_US_ASCII, RES_ISO_LATIN9, pF->szName);
		if (iAlt != pF->iAlt)
			TT_Fail("%s: alter IMAP-Index erwartet %d, erhalten %d", pF->szName, pF->iAlt, iAlt);

		// 2. Und was dabei herauskam. Die alte Abfrage lautete "> 1"; nur
		//    iso-8859-15 kam ueberhaupt bis zu ISOTranslate, und dort wird
		//    die 2 als "Latin-1, nichts zu tun" gelesen.
		memcpy(szArbeit, szUtf8, sizeof(szUtf8));
		szArbeit[sizeof(szUtf8)] = 0;
		lRaus = (long)sizeof(szUtf8);

		if (iAlt > 1)
			lRaus = UT_ISOTranslate((char*)szArbeit, (long)sizeof(szUtf8), (unsigned)iAlt);

		PruefeBytes(pF->szName, szArbeit, lRaus, szUtf8, (long)sizeof(szUtf8));
	}

	// Und derselbe Satz fuer ISO-8859-15-Bytes: das Eurozeichen 0xA4 muesste
	// 0x80 werden. Mit dem alten Index 2 bleibt es 0xA4.
	{
		unsigned char	szArbeit[32];
		long			lRaus;

		memcpy(szArbeit, szLatin9, sizeof(szLatin9));
		szArbeit[sizeof(szLatin9)] = 0;
		lRaus = UT_ISOTranslate((char*)szArbeit, (long)sizeof(szLatin9), 2);
		PruefeBytes("iso-8859-15 mit dem alten Index 2", szArbeit, lRaus,
					szLatin9, (long)sizeof(szLatin9));
	}

	TT_EndTest();
}

static void Test_NP3_8_NeuerStandUebersetzt(void)
{
	static const unsigned char	szUtf8Ein[]  = { 'G','r',0xC3,0xBC,0xC3,0x9F,'e' };
	static const unsigned char	szUtf8Soll[] = { 'G','r',0xFC,0xDF,'e' };
	static const unsigned char	szL9Ein[]    = { 0xA4,' ','5' };		// Euro in Latin-9
	static const unsigned char	szL9Soll[]   = { 0x80,' ','5' };		// Euro in CP1252
	unsigned int				u;
	unsigned char				szArbeit[32];
	long						lRaus;

	TT_BeginTest("NP3-8: mit FindMIMECharset rechnet IMAP auf derselben Skala wie POP");

	// Erst die Skala selbst - jede Zeile der Tabelle aus BEFUNDE.md.
	for (u = 0; u < sizeof(s_aFaelle) / sizeof(s_aFaelle[0]); ++u)
	{
		const Zeichensatzfall*	pF = &s_aFaelle[u];
		const int				iNeu = UT_FindMIMECharset(pF->szName);

		if (iNeu != pF->iNeu)
			TT_Fail("%s: neuer Index erwartet %d, erhalten %d", pF->szName, pF->iNeu, iNeu);
	}

	// utf-8 ist 4, die Abfrage lautet jetzt "> 2" - also wird uebersetzt.
	TT_CHECK(UT_FindMIMECharset("utf-8") > 2);
	memcpy(szArbeit, szUtf8Ein, sizeof(szUtf8Ein));
	szArbeit[sizeof(szUtf8Ein)] = 0;
	lRaus = UT_ISOTranslate((char*)szArbeit, (long)sizeof(szUtf8Ein),
							(unsigned)UT_FindMIMECharset("utf-8"));
	PruefeBytes("utf-8 ueber FindMIMECharset", szArbeit, lRaus,
				szUtf8Soll, (long)sizeof(szUtf8Soll));

	// iso-8859-15 ist 3 und wird ebenfalls uebersetzt.
	TT_CHECK(UT_FindMIMECharset("iso-8859-15") > 2);
	memcpy(szArbeit, szL9Ein, sizeof(szL9Ein));
	szArbeit[sizeof(szL9Ein)] = 0;
	lRaus = UT_ISOTranslate((char*)szArbeit, (long)sizeof(szL9Ein),
							(unsigned)UT_FindMIMECharset("iso-8859-15"));
	PruefeBytes("iso-8859-15 ueber FindMIMECharset", szArbeit, lRaus,
				szL9Soll, (long)sizeof(szL9Soll));

	TT_EndTest();
}

static void Test_NP3_8_GegenprobeUnberuehrt(void)
{
	// Die Gegenprobe in die andere Richtung: eine Behebung, nach der auf
	// einmal ALLES uebersetzt wird, waere ebenso falsch. us-ascii,
	// iso-8859-1 und die Windows-Zeichensaetze liegen bei 1, 2 und 0, die
	// Abfrage "> 2" laesst sie gar nicht erst bis ISOTranslate - und selbst
	// wenn, muessen die Bytes unveraendert bleiben.
	static const unsigned char	szEin[] = { 'G','r',0xFC,0xDF,'e',' ',0x80 };
	static const int			aIdx[]  = { IDX_WINDOWS, IDX_US_ASCII, IDX_ISO_LATIN1 };
	unsigned int				u;

	TT_BeginTest("NP3-8 Gegenprobe: us-ascii, Latin-1 und windows-* bleiben unberuehrt");

	for (u = 0; u < sizeof(aIdx) / sizeof(aIdx[0]); ++u)
	{
		unsigned char	szArbeit[32];
		long			lRaus;

		TT_CHECK_MSG(!(aIdx[u] > 2), "dieser Index darf die Abfrage nicht passieren");

		memcpy(szArbeit, szEin, sizeof(szEin));
		szArbeit[sizeof(szEin)] = 0;
		lRaus = UT_ISOTranslate((char*)szArbeit, (long)sizeof(szEin), (unsigned)aIdx[u]);
		PruefeBytes("unveraendert", szArbeit, lRaus, szEin, (long)sizeof(szEin));
	}

	// Ein unbekannter Zeichensatz liefert -1 und darf nicht aus Versehen
	// als "groesser 2" durchgehen.
	TT_CHECK(UT_FindMIMECharset("koi8-r") == -1);
	TT_CHECK(!(UT_FindMIMECharset("koi8-r") > 2));

	TT_EndTest();
}

static void Test_NP3_8_DieStelleSelbst(const char* szEudoraDir)
{
	// Die Rechnung oben gilt fuer die Funktionen. Dass der IMAP-Weg sie
	// auch BENUTZT, steht nicht in einer pruefbaren Funktion, sondern
	// mitten in ImapDownload::WriteMessageToMBX_. Also wird die Stelle
	// selbst gelesen - nur der Code, ohne Kommentare: der alte, falsche
	// Aufruf steht dort woertlich in der Begruendung der Behebung
	// (Arbeitsweise/schranke-liest-nur-code.md).
	char*	pCode = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapDownload.cpp");

	TT_BeginTest("NP3-8: ImapDownload.cpp rechnet mit der Skala von FindMIMECharset");

	if (!pCode)
	{
		TT_Fail("EuImap\\src\\ImapDownload.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	TT_CHECK_MSG(QT_Enthaelt(pCode, "FindMIMECharset"),
				 "der IMAP-Weg muss FindMIMECharset rufen");
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "FindRStringIndexI"),
				 "der alte Bereichsaufruf 3611..3613 darf nicht zurueckkommen");
	TT_CHECK_MSG(QT_Enthaelt(pCode, "iCharsetIdx > 2"),
				 "die Abfrage muss auf der Skala von FindMIMECharset stehen");
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "iCharsetIdx > 1"),
				 "die alte Abfrage \"> 1\" darf nicht zurueckkommen");

	free(pCode);
	TT_EndTest();
}

// ===========================================================================
// NP3-9 - der Rueckgabewert von ISOTranslate wurde verworfen
// ===========================================================================

static void Test_NP3_9_RueckgabeIstDieNeueLaenge(void)
{
	// TextReader.cpp:251 und ImapDownload.cpp:4662 riefen
	//
	//     ISOTranslate(buf, size, iCharsetIdx);
	//
	// und rechneten mit der ALTEN size weiter. Zwischen dem neuen Ende und
	// der alten Laenge liegen die unveraenderten Reste des Ausgangstextes -
	// und die wurden mitgeschrieben.
	static const unsigned char	szEin[]  = { 'G','r',0xC3,0xBC,0xC3,0x9F,'e' };	// 7 Bytes UTF-8
	static const unsigned char	szSoll[] = { 'G','r',0xFC,0xDF,'e' };			// 5 Bytes CP1252
	unsigned char				szPuffer[32];
	long						lNeu;

	TT_BeginTest("NP3-9: ISOTranslate liefert die NEUE Laenge, und sie ist kuerzer");

	memset(szPuffer, 'Z', sizeof(szPuffer));
	memcpy(szPuffer, szEin, sizeof(szEin));

	lNeu = UT_ISOTranslate((char*)szPuffer, (long)sizeof(szEin), IDX_UTF_8);

	// 1. Der Rueckgabewert ist die neue Laenge.
	TT_CHECK_MSG(lNeu == (long)sizeof(szSoll), "7 Bytes UTF-8 werden zu 5 Bytes CP1252");

	// 2. Wer ihn nimmt, bekommt genau den uebersetzten Text.
	PruefeBytes("mit dem Rueckgabewert", szPuffer, lNeu, szSoll, (long)sizeof(szSoll));

	// 3. Wer ihn verwirft, schreibt zwei Bytes zu viel - und das sind nicht
	//    etwa Nullen, sondern die Reste des Ausgangstextes. ISOTranslate
	//    setzt szBuf[lSize] = 0; alles dahinter bleibt stehen. Genau dieser
	//    Schwanz war NP3-9.
	{
		static const unsigned char	szSchwanz[] = { 'G','r',0xFC,0xDF,'e',0x00,'e' };

		TT_CHECK_MSG(lNeu < (long)sizeof(szEin),
					 "sonst gaebe es keinen Schwanz und der Test prueft nichts");
		PruefeBytes("mit der ALTEN Laenge - der Schaden aus NP3-9",
					szPuffer, (long)sizeof(szEin), szSchwanz, (long)sizeof(szSchwanz));
	}

	TT_EndTest();
}

static void Test_NP3_9_DieBeidenStellen(const char* szEudoraDir)
{
	// Die beiden Aufrufstellen. "Nicht betroffen" waren laut Befund
	// lex822.cpp:544 und ImapLex822.cpp:577 - die arbeiten ueber die
	// Nullterminierung und werden hier deshalb nicht verlangt.
	char*	pText = QT_LiesNurCode(szEudoraDir, "TextReader.cpp");
	char*	pImap = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapDownload.cpp");
	int		iGefunden = 0;

	TT_BeginTest("NP3-9: beide Aufrufstellen nehmen den Rueckgabewert entgegen");

	if (!pText || !pImap)
	{
		TT_Fail("TextReader.cpp oder ImapDownload.cpp nicht lesbar - ungeprueft ist nicht gruen");
		free(pText);
		free(pImap);
		TT_EndTest();
		return;
	}

	// TextReader.cpp: jeder Aufruf von ISOTranslate( muss seinen Wert abgeben.
	TT_CHECK_MSG(QT_RueckgabeGenutzt(pText, "ISOTranslate(", &iGefunden),
				 "TextReader.cpp: ISOTranslate steht als blosse Anweisung da");
	TT_CHECK_MSG(iGefunden >= 1, "TextReader.cpp ruft ISOTranslate gar nicht mehr?");
	TT_CHECK(QT_Enthaelt(pText, "size = ISOTranslate(buf, size, iCharsetIdx);"));

	// ImapDownload.cpp geht seit E-85 ueber ISOTranslateChunk. Auch dessen
	// Wert muss ankommen, und zwar in BEIDEN Laengen - outLen allein zu
	// setzen hiesse, inLen weiter mit der alten zu fuehren.
	iGefunden = 0;
	TT_CHECK_MSG(QT_RueckgabeGenutzt(pImap, "ISOTranslateChunk(", &iGefunden),
				 "ImapDownload.cpp: ISOTranslateChunk steht als blosse Anweisung da");
	TT_CHECK(iGefunden >= 1);
	TT_CHECK_MSG(QT_Enthaelt(pImap, "inLen = lUebersetzt;"), "inLen wird nachgezogen");
	TT_CHECK_MSG(QT_Enthaelt(pImap, "outLen = lUebersetzt;"), "outLen wird nachgezogen");

	free(pText);
	free(pImap);
	TT_EndTest();
}

// ===========================================================================
// Z-2 - die HTML-Zwischendatei sagte ihren Zeichensatz nirgends an
// ===========================================================================

static void Test_Z2_AnsageIstWindows1252(void)
{
	static const char	szSoll[] =
		"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\">\r\n";
	const char*			szIst = UT_Z2CharsetMeta();

	TT_BeginTest("Z-2: die Zwischendatei sagt windows-1252 an, Byte fuer Byte");

	PruefeBytes("die Ansage", szIst, (long)UT_Z2CharsetMetaLaenge(),
				szSoll, (long)(sizeof(szSoll) - 1));

	// Warum nicht utf-8: in der gemessenen Zwischendatei (%TEMP%\eudA.htm,
	// 05.09.2026) standen 33 Bytes ueber 0x7F, davon 32 in CP1252. "utf-8"
	// wuerde 32 Zeichen kaputtmachen, um 1 zu retten.
	TT_CHECK_MSG(strstr(szIst, "windows-1252") != 0, "der Zeichensatz muss windows-1252 sein");
	TT_CHECK_MSG(strstr(szIst, "utf-8") == 0, "utf-8 waere fuer 32 von 33 Zeichen falsch");
	TT_CHECK_MSG(strstr(szIst, "Content-Type") != 0, "MSHTML liest die Angabe nur im Content-Type");

	TT_EndTest();
}

static void Test_Z2_ModusansageTraegtKeinenZeichensatz(void)
{
	const char*	szKomp = UT_Z2Kompatibilitaet();

	TT_BeginTest("Z-2 Gegenprobe: die Modusansage davor traegt keinen Zeichensatz");

	// Unmittelbar vor der Zeichensatz-Ansage steht die Modusansage
	// (IE=edge). Traegt sie ebenfalls ein charset, stuenden zwei
	// Zeichensatzangaben im Kopf und MSHTML naehme die erste.
	TT_CHECK(strstr(szKomp, "X-UA-Compatible") != 0);
	TT_CHECK_MSG(strstr(szKomp, "charset") == 0, "nur EINE Zeichensatzangabe im Kopf");
	TT_CHECK(UT_Z2KompatibilitaetLaenge() > 0);

	TT_EndTest();
}

static void Test_Z2_DieStellen(const char* szEudoraDir)
{
	char*	pTv  = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	char*	pMsg = QT_LiesNurCode(szEudoraDir, "msgutils.cpp");

	TT_BeginTest("Z-2: die Ansage steht vor dem Stylesheet, fremde Ansagen fliegen raus");

	if (!pTv || !pMsg)
	{
		TT_Fail("TridentView.cpp oder msgutils.cpp nicht lesbar - ungeprueft ist nicht gruen");
		free(pTv);
		free(pMsg);
		TT_EndTest();
		return;
	}

	// 1. Die Ansage muss in die Datei geschrieben werden, und zwar VOR dem
	//    Stylesheet. Steht sie dahinter, hat MSHTML schon Inhalt gesehen.
	{
		const long	lMeta  = QT_Stelle(pTv, "szCharsetMeta, sizeof(szCharsetMeta) - 1");
		const long	lStyle = QT_Stelle(pTv, "szStyleSheet, szStyleSheet.GetLength()");

		TT_CHECK_MSG(lMeta >= 0, "die Ansage wird nicht geschrieben");
		TT_CHECK_MSG(lStyle >= 0, "das Stylesheet wird nicht geschrieben");
		if (lMeta >= 0 && lStyle >= 0)
			TT_CHECK_MSG(lMeta < lStyle, "die Ansage muss VOR dem Stylesheet stehen");
	}

	// 2. Die Ansage gehoert NICHT in die Ressource des Stylesheets: eine
	//    vorhandene read.css ersetzt die Ressource, dann stuende sie nur
	//    manchmal in der Datei.
	TT_CHECK_MSG(QT_Enthaelt(pTv, "static const char szCharsetMeta[] ="),
				 "die Ansage steht als eigene Konstante in WriteTempFile");

	// 3. GetBodyAsHTML muss jede FREMDE Zeichensatzangabe aus dem Rumpf
	//    werfen - auch die HTML5-Kurzform <meta charset="utf-8">, der das
	//    http-equiv fehlt. Darum ueber die Zeichenkette "charset" und nicht
	//    ueber HasBadAttributeValue allein.
	TT_CHECK(QT_Enthaelt(pMsg, "bool bIsBadMeta = HasBadAttributeValue(TagContents, \"http-equiv\", \"refresh\") || ( TagContentsLower.Find(\"charset\") >= 0 );"));
	TT_CHECK_MSG(QT_Enthaelt(pMsg, "TagContentsLower.MakeLower();"),
				 "ohne MakeLower bliebe <META CHARSET=...> stehen");

	free(pTv);
	free(pMsg);
	TT_EndTest();
}

// ===========================================================================
// Z-2B - ein UTF-8-Zeichen zerrissen an der Stueckgrenze
// ===========================================================================
//
// Gregor am 05.09.2026, EIN Umlaut kaputt, alle anderen richtig:
//
//     "BestTV (U-TV) Android Player fAY&r LiveTV"     falsch
//     "Fritzbox als Werbe-Filter: So laeuft Blocken"  richtig
//
// In In.mbx stand an Offset 568472 roh "f C3 BC r". Die Ursache ist die
// Stelle im Bytestrom: TextReader liest stueckweise, und ein UTF-8-Zeichen
// ist 2 bis 4 Byte lang.

// Gregors Zeichenkette, roh wie sie vom Server kommt.
static const unsigned char s_szGregor[] =
{
	'B','e','s','t','T','V',' ','(','U','-','T','V',')',' ',
	'A','n','d','r','o','i','d',' ','P','l','a','y','e','r',' ','f',
	0xC3, 0xBC,
	'r',' ','L','i','v','e','T','V'
};
#define GREGOR_TRENNUNG		31		// genau zwischen C3 und BC

// Dasselbe nach CP1252: ein Byte 0xFC statt der zwei UTF-8-Bytes.
static const unsigned char s_szGregorSoll[] =
{
	'B','e','s','t','T','V',' ','(','U','-','T','V',')',' ',
	'A','n','d','r','o','i','d',' ','P','l','a','y','e','r',' ','f',
	0xFC,
	'r',' ','L','i','v','e','T','V'
};

// Faehrt den Strom in zwei Stuecken durch ISOTranslateChunk - so wie der
// Empfang es tut. Liefert die Zahl der geschriebenen Bytes.
static long ZweiStueckeMitUebertrag(const unsigned char* pEin, long lEin, long lTrennung,
									unsigned int uIdx, unsigned char* pAus, long lAusMax)
{
	char	szArbeit[256];
	char	szUebertrag[8];
	long	lUebertrag = 0;
	long	lGeschrieben = 0;
	int		iStueck;

	for (iStueck = 0; iStueck < 2; ++iStueck)
	{
		const long	lVon  = (iStueck == 0) ? 0 : lTrennung;
		const long	lDies = (iStueck == 0) ? lTrennung : (lEin - lTrennung);
		char*		pBuf  = szArbeit;
		long		lRaus;

		memset(szArbeit, 0, sizeof(szArbeit));
		memcpy(szArbeit, pEin + lVon, (size_t)lDies);

		lRaus = UT_ISOTranslateChunk(&pBuf, lDies, uIdx, szUebertrag, &lUebertrag);

		if (lRaus > 0 && lGeschrieben + lRaus <= lAusMax)
		{
			memcpy(pAus + lGeschrieben, pBuf, (size_t)lRaus);
			lGeschrieben += lRaus;
		}
	}
	return lGeschrieben;
}

// Dasselbe OHNE Uebertrag - so wie es vor der Behebung lief: jedes Stueck
// geht fuer sich durch ISOTranslate.
static long ZweiStueckeOhneUebertrag(const unsigned char* pEin, long lEin, long lTrennung,
									 unsigned int uIdx, unsigned char* pAus, long lAusMax)
{
	char	szArbeit[256];
	long	lGeschrieben = 0;
	int		iStueck;

	for (iStueck = 0; iStueck < 2; ++iStueck)
	{
		const long	lVon  = (iStueck == 0) ? 0 : lTrennung;
		const long	lDies = (iStueck == 0) ? lTrennung : (lEin - lTrennung);
		long		lRaus;

		memset(szArbeit, 0, sizeof(szArbeit));
		memcpy(szArbeit, pEin + lVon, (size_t)lDies);

		lRaus = UT_ISOTranslate(szArbeit, lDies, uIdx);

		if (lRaus > 0 && lGeschrieben + lRaus <= lAusMax)
		{
			memcpy(pAus + lGeschrieben, szArbeit, (size_t)lRaus);
			lGeschrieben += lRaus;
		}
	}
	return lGeschrieben;
}

static void Test_Z2B_GregorsZeichenkette(void)
{
	unsigned char	szAus[128];
	long			lAus;

	TT_BeginTest("Z-2B: Gregors Zeile kommt ueber die Stueckgrenze heil an");

	// Erst die Gegenprobe: so sah es vor der Behebung aus. Der Umlaut wird
	// an der Grenze zerrissen, keine Haelfte ist gueltiges UTF-8, die
	// Tabelle kennt nur vollstaendige Folgen - beide Bytes bleiben roh
	// stehen. Genau das stand in In.mbx an Offset 568472.
	memset(szAus, 0, sizeof(szAus));
	lAus = ZweiStueckeOhneUebertrag(s_szGregor, (long)sizeof(s_szGregor), GREGOR_TRENNUNG,
									IDX_UTF_8, szAus, (long)sizeof(szAus));
	PruefeBytes("ohne Uebertrag - der alte Stand", szAus, lAus,
				s_szGregor, (long)sizeof(s_szGregor));

	// Und jetzt mit dem Uebertrag: ein Byte 0xFC, wie im Rest der Nachricht.
	memset(szAus, 0, sizeof(szAus));
	lAus = ZweiStueckeMitUebertrag(s_szGregor, (long)sizeof(s_szGregor), GREGOR_TRENNUNG,
								   IDX_UTF_8, szAus, (long)sizeof(szAus));
	PruefeBytes("mit Uebertrag", szAus, lAus,
				s_szGregorSoll, (long)sizeof(s_szGregorSoll));

	TT_EndTest();
}

static void Test_Z2B_JedeTrennstelle(void)
{
	long	lTrenn;

	TT_BeginTest("Z-2B: das Ergebnis haengt nicht davon ab, wo das Stueck endet");

	// Der eigentliche Punkt des Befunds: dieselbe Nachricht darf nicht
	// davon abhaengen, an welcher Stelle der Leser sein Stueck beendet hat.
	// Geprueft wird JEDE moegliche Trennstelle, nicht nur die eine.
	for (lTrenn = 1; lTrenn < (long)sizeof(s_szGregor); ++lTrenn)
	{
		unsigned char	szAus[128];
		long			lAus;

		memset(szAus, 0, sizeof(szAus));
		lAus = ZweiStueckeMitUebertrag(s_szGregor, (long)sizeof(s_szGregor), lTrenn,
									   IDX_UTF_8, szAus, (long)sizeof(szAus));

		if (lAus != (long)sizeof(s_szGregorSoll) ||
			memcmp(szAus, s_szGregorSoll, sizeof(s_szGregorSoll)) != 0)
		{
			TT_Fail("Trennstelle %ld: falsches Ergebnis (%ld Bytes)", lTrenn, lAus);
			TT_Note("  ist : %s", Hex(szAus, lAus > 0 ? lAus : 0));
			TT_Note("  soll: %s", Hex(s_szGregorSoll, (long)sizeof(s_szGregorSoll)));
		}
	}

	TT_EndTest();
}

static void Test_Z2B_GegenprobeLatin1(void)
{
	// Gegenprobe in die andere Richtung. Eine Nachricht, die gar kein UTF-8
	// ist, darf durch den Uebertrag nicht angefasst werden - sonst waere aus
	// der Behebung "jetzt wird alles ueberschrieben" geworden. 0xFC ist in
	// CP1252 bereits der Umlaut und zugleich ein gueltiger UTF-8-Kopf: ein
	// Uebertrag wuerde ihn verschlucken.
	static const unsigned char	szEin[] = { 'f', 0xFC, 'r', ' ', 'd', 'i', 'c', 'h' };
	static const int			aIdx[]  = { IDX_WINDOWS, IDX_US_ASCII, IDX_ISO_LATIN1 };
	unsigned int				u;
	long						lTrenn;

	TT_BeginTest("Z-2B Gegenprobe: ohne UTF-8 bleibt jedes Byte stehen");

	for (u = 0; u < sizeof(aIdx) / sizeof(aIdx[0]); ++u)
	{
		for (lTrenn = 1; lTrenn < (long)sizeof(szEin); ++lTrenn)
		{
			unsigned char	szAus[64];
			long			lAus;

			memset(szAus, 0, sizeof(szAus));
			lAus = ZweiStueckeMitUebertrag(szEin, (long)sizeof(szEin), lTrenn,
										   (unsigned)aIdx[u], szAus, (long)sizeof(szAus));

			if (lAus != (long)sizeof(szEin) || memcmp(szAus, szEin, sizeof(szEin)) != 0)
			{
				TT_Fail("Index %d, Trennstelle %ld: Bytes veraendert", aIdx[u], lTrenn);
				TT_Note("  ist : %s", Hex(szAus, lAus > 0 ? lAus : 0));
				TT_Note("  soll: %s", Hex(szEin, (long)sizeof(szEin)));
			}
		}
	}

	TT_EndTest();
}

static void Test_Z2B_DieStelle(const char* szEudoraDir)
{
	char*	pText = QT_LiesNurCode(szEudoraDir, "TextReader.cpp");

	TT_BeginTest("Z-2B: TextReader haelt das angefangene Zeichen zurueck");

	if (!pText)
	{
		TT_Fail("TextReader.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	// Der Uebertrag selbst.
	TT_CHECK_MSG(QT_Enthaelt(pText, "ISOIncompleteUTF8Tail(buf, size)"),
				 "ohne das Zaehlen des Restes gibt es keinen Uebertrag");
	TT_CHECK_MSG(QT_Enthaelt(pText, "ISOIsUTF8Charset("),
				 "der Uebertrag darf nur bei UTF-8 laufen");

	// Und der Platz dafuer: drei Bytes weniger Lesepuffer, damit die
	// zurueckgehaltenen Bytes vor das naechste Stueck passen.
	TT_CHECK_MSG(QT_Enthaelt(pText, "bSize -= 3;"),
				 "ohne Platz vor dem Puffer kann der Uebertrag nicht eingesetzt werden");

	free(pText);
	TT_EndTest();
}

// ===========================================================================

void RunZeichenWegeTests(const char* szEudoraDir)
{
	TT_Suite("NP3-8, NP3-9, Z-2 und Z-2B: die vier Wege, auf denen Umlaute starben");

	Test_NP3_8_AlterStandUebersetztNie();
	Test_NP3_8_NeuerStandUebersetzt();
	Test_NP3_8_GegenprobeUnberuehrt();
	Test_NP3_8_DieStelleSelbst(szEudoraDir);

	Test_NP3_9_RueckgabeIstDieNeueLaenge();
	Test_NP3_9_DieBeidenStellen(szEudoraDir);

	Test_Z2_AnsageIstWindows1252();
	Test_Z2_ModusansageTraegtKeinenZeichensatz();
	Test_Z2_DieStellen(szEudoraDir);

	Test_Z2B_GregorsZeichenkette();
	Test_Z2B_JedeTrennstelle();
	Test_Z2B_GegenprobeLatin1();
	Test_Z2B_DieStelle(szEudoraDir);
}
