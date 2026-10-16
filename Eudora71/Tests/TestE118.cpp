//
// TestE118.cpp - bekommt eine HTML-Mail beim Hochladen in einen IMAP-Ordner
// ihren Typ zurueck?
//
// Befund E-118: Gregor am 13.10.2026 an 1.0.86 - zwei weitergeleitete Mails,
// in einen IMAP-Ordner verschoben, zeigten dort <head></head><body ...> als
// Text. Eudora legt HTML lokal als <x-html> ... </x-html> ab; beim Hochladen
// gingen Huelle und Text ohne Content-Type an den Server.
//
// Geprueft wird die Erkennung der Huelle und des Zeichensatzbedarfs. Die
// Gegenrichtung gehoert dazu: ein Text OHNE Huelle bleibt unangetastet, sonst
// wird aus einer Textmail, die "<x-html>" nur zitiert, eine HTML-Mail.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE118.h"

// Ein einfacher, aber unterscheidender Hash statt HashMT (das liegt in QCUtils).
static unsigned long ZaehlHash(const char* s)
{
	unsigned long h = 5381;
	while (*s)
		h = h * 33 + (unsigned char)*s++;
	return h;
}

void RunE118Tests(void)
{
	long a = -1, e = -1;

	TT_Suite("E-118: HTML-Huelle beim Hochladen in einen IMAP-Ordner");

	// ------------------------------------------------------------- (1)
	TT_BeginTest("E-118: die Huelle einer empfangenen HTML-Mail wird erkannt und abgestreift");
	{
		const char* p = "<x-html>\r\n<html><body>Hallo</body></html>\r\n</x-html>\r\n";
		long n = (long)strlen(p);
		TT_CHECK_MSG(E118Huelle(p, n, &a, &e) == 1, "<x-html> am Anfang wird erkannt");
		TT_CHECK_MSG(e - a == (long)strlen("<html><body>Hallo</body></html>\r\n") &&
			strncmp(p + a, "<html><body>Hallo</body></html>\r\n", e - a) == 0,
			"der Inhalt ist genau das HTML zwischen den Markierungen");
		TT_Note("Anfang=%ld Ende=%ld", a, e);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	TT_BeginTest("E-118: Schreibweisen und Vorspann");
	{
		const char* p = "\r\n  <X-HTML>\n<p>x</p>\n</X-Html>";
		long n = (long)strlen(p);
		TT_CHECK(E118Huelle(p, n, &a, &e) == 1);
		TT_CHECK_MSG(strncmp(p + a, "<p>x</p>\n", e - a) == 0 && e - a == 9,
			"Grossschreibung, fuehrende Leerzeilen, nur LF");

		p = "<x-html><b>ohne Ende-Markierung</b>";
		n = (long)strlen(p);
		TT_CHECK_MSG(E118Huelle(p, n, &a, &e) == 1 && a == 8 && e == n,
			"fehlt </x-html>, gehoert der Rest zum Inhalt");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	TT_BeginTest("E-118 Gegenrichtung: Text ohne Huelle bleibt Text");
	{
		const char* p = "Hallo,\r\nim Text steht <x-html> nur als Zitat.\r\n";
		long n = (long)strlen(p);
		TT_CHECK_MSG(E118Huelle(p, n, &a, &e) == 0, "keine Huelle am Anfang - kein HTML");
		TT_CHECK_MSG(a == 0 && e == n, "der Bereich bleibt der ganze Text");

		TT_CHECK_MSG(E118Huelle("", 0, &a, &e) == 0 && a == 0 && e == 0, "leerer Text");
		TT_CHECK_MSG(E118Huelle("<x-htm", 6, &a, &e) == 0, "abgeschnittene Markierung");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	TT_BeginTest("E-118: Zeichensatz noetig, sobald ein Byte ueber 0x7F steht");
	{
		const char* pAscii = "Gruesse";
		const char szUmlaut[] = { 'G', (char)0xFC, 0 };    // "Gue" in Latin-1
		TT_CHECK_MSG(E118Achtbit(pAscii, (long)strlen(pAscii)) == 0, "reines ASCII: kein Zeichensatz");
		TT_CHECK_MSG(E118Achtbit(szUmlaut, 2) == 1, "ein Umlaut: Zeichensatz und 8bit");
		TT_CHECK_MSG(E118Achtbit(szUmlaut, 1) == 0, "nur der geprueft Bereich zaehlt");

		// Euro 0x80 gibt es in ISO-8859-1 nicht - dann windows-1252 (MESSSTAND).
		const char szEuro[] = { (char)0xFC, ' ', (char)0x80, 0 };
		TT_CHECK_MSG(E118Achtbit(szUmlaut, 2) == 1, "Umlaut allein: Art 1 (iso-8859-1 reicht)");
		TT_CHECK_MSG(E118Achtbit(szEuro, 3) == 2, "mit Euro-Zeichen: Art 2 (windows-1252)");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	// PRUEFER-27 F1: steht hinter </x-html> noch etwas, darf es nicht
	// verschwinden - die lokale Kopie ist nach dem Verschieben geloescht.
	TT_BeginTest("E-118: Text hinter der Huelle geht nicht verloren");
	{
		const char* p = "<x-html><p>a</p></x-html>\r\nFusszeile der Liste\r\n";
		long n = (long)strlen(p);
		TT_CHECK_MSG(E118Huelle(p, n, &a, &e) == 1 && e == n,
			"Fusszeile hinter </x-html>: der Bereich reicht bis zum Ende");
		TT_Note("Anfang=%ld Ende=%ld Laenge=%ld", a, e, n);

		p = "<x-html><p>a</p></x-html>\r\n \r\n";
		n = (long)strlen(p);
		TT_CHECK_MSG(E118Huelle(p, n, &a, &e) == 1 && strncmp(p + e, "</x-html>", 9) == 0,
			"nur Leerraum dahinter: die Markierung wird abgestreift");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	// Die SoftMaker-Mail: drei Bilder als cid:, Eudora kennt nur den Hash.
	TT_BeginTest("E-118: das eingebettete Bild findet seinen Verweis im HTML");
	{
		const char* pHtml = "<img src=\"cid:logo_softmaker-33ed702b.png\" alt=\"\">"
			"<td background='cid:bell.png'><img src=https://example.invalid/a.png >";
		long n = (long)strlen(pHtml);
		char szCid[256];

		TT_CHECK_MSG(E118Verweis(pHtml, n, ZaehlHash("logo_softmaker-33ed702b.png"), 1, ZaehlHash, szCid, sizeof(szCid)) == 1
			&& strcmp(szCid, "logo_softmaker-33ed702b.png") == 0, "cid in Anfuehrungszeichen");
		TT_CHECK_MSG(E118Verweis(pHtml, n, ZaehlHash("bell.png"), 1, ZaehlHash, szCid, sizeof(szCid)) == 1
			&& strcmp(szCid, "bell.png") == 0, "cid in background mit einfachen Anfuehrungszeichen");
		TT_CHECK_MSG(E118Verweis(pHtml, n, ZaehlHash("https://example.invalid/a.png"), 0, ZaehlHash, szCid, sizeof(szCid)) == 1
			&& strcmp(szCid, "https://example.invalid/a.png") == 0, "Content-Location ueber src ohne Anfuehrungszeichen");

		// Gegenrichtung: kein passender Verweis - kein erfundener Name.
		TT_CHECK_MSG(E118Verweis(pHtml, n, ZaehlHash("gibt-es-nicht.png"), 1, ZaehlHash, szCid, sizeof(szCid)) == 0
			&& szCid[0] == 0, "ohne Treffer bleibt szAus leer");
		TT_CHECK_MSG(E118Verweis(pHtml, n, ZaehlHash("cid:bell.png"), 0, ZaehlHash, szCid, sizeof(szCid)) == 0,
			"im Location-Modus zaehlt ein cid:-Verweis nicht");
	}
	TT_EndTest();
}
