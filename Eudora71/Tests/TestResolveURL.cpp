//
// TestResolveURL.cpp - Befund E-110: resolve_URL warf Prozent-Sequenzen weg
//
// Der Fehler, gemessen am 18.09.2026 an Gregors Nachricht: im %-Zweig von
// resolve_URL wurde das entschluesselte Zeichen nach *output geschrieben,
// output aber nicht weitergerueckt. Das naechste Zeichen ueberschrieb es - das
// Zeichen war also nicht falsch, sondern weg.
//
//   ei%20Beispiel%20Bild.png  ->  eiBeispielBild.png
//
// Der Server antwortete darauf mit 404, Eudora legte die Fehlerseite ab,
// erkannte sie richtigerweise nicht als Bild und zeichnete einen grauen
// Kasten. Zehn von zwanzig Bildern.
//
// DIE GEGENPROBE STEHT IN DERSELBEN DATEI: unescape_url, zwanzig Zeilen
// darunter, loest dieselbe Aufgabe und loeste sie schon immer richtig. Wo
// beide dasselbe liefern, ist resolve_URL in Ordnung. Das ist ein besserer
// Massstab als eine von mir erdachte Erwartung, weil er aus dem Programm
// selbst kommt (Arbeitsweise/einigkeit-ist-kein-beweis.md sagt: der Massstab
// gehoert von aussen - hier ist "aussen" die Funktion, die es kann).
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestResolveURL.h"

static void Loese(const char* pszEin, char* szAus, size_t nAus)
{
	memset(szAus, 0, nAus);
	UTRU_ResolveURL(pszEin, szAus, nAus);
}

void RunResolveURLTests(void)
{
	char szAus[1024];
	char szGegen[1024];

	TT_Suite("E-110: resolve_URL und die Prozent-Sequenzen");

	// ------------------------------------------------------------- (1)
	// Der Anlassfall, Byte fuer Byte aus Gregors Protokoll vom 18.09.2026.
	TT_BeginTest("E-110: %20 wird zum Leerzeichen, nicht weggeworfen");
	{
		Loese("https://absender.invalid/bilder/ei%20Beispiel%20Bild.png",
			  szAus, sizeof(szAus));

		TT_CHECK_MSG(strcmp(szAus,
			"https://absender.invalid/bilder/ei Beispiel Bild.png") == 0,
			"Aus %20 muss ein Leerzeichen werden");

		// Die Gegenrichtung ausdruecklich pruefen: genau DIESE Zeichenkette
		// stand im Protokoll, und genau sie gab es nicht auf dem Server.
		TT_CHECK_MSG(strcmp(szAus,
			"https://absender.invalid/bilder/eiBeispielBild.png") != 0,
			"Das ist die kaputte Fassung vom 18.09.2026 - der Server antwortete 404");

		TT_Note("%s", szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	// Der zweite Fall aus demselben Protokoll, mit Klammern im Namen.
	TT_BeginTest("E-110: mehrere %20 hintereinander, dazu Klammern");
	{
		Loese("https://absender.invalid/bilder/Bild%20A%20B%20(1).jpg",
			  szAus, sizeof(szAus));

		TT_CHECK_MSG(strcmp(szAus,
			"https://absender.invalid/bilder/Bild A B (1).jpg") == 0,
			"Drei Sequenzen in einer Adresse, alle drei muessen ankommen");
		TT_CHECK_MSG(strcmp(szAus,
			"https://absender.invalid/bilder/BildAB(1).jpg") != 0,
			"Die kaputte Fassung vom 18.09.2026");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	// Der Fehler traf JEDE Prozent-Sequenz, nicht nur %20. Ein Umlaut im
	// Dateinamen ist der Fall, der im Alltag am ehesten vorkommt - und er
	// besteht aus ZWEI Sequenzen, die beide ankommen muessen.
	TT_BeginTest("E-110: %C3%BC - der Fehler traf jede Sequenz, nicht nur %20");
	{
		Loese("https://beispiel.invalid/T%C3%BCr.png", szAus, sizeof(szAus));

		TT_CHECK_MSG(strlen(szAus) == strlen("https://beispiel.invalid/Tr.png") + 2,
			"Zwei Sequenzen ergeben zwei Bytes - die UTF-8-Folge fuer u-Umlaut");
		// "https://beispiel.invalid/" sind 25 Zeichen (Index 0..24), das 'T'
		// steht also auf 25 und die UTF-8-Folge auf 26 und 27. Beim ersten
		// Lauf stand hier 25/26 - der Test war falsch, nicht der Code, und er
		// hat es gemeldet. Deshalb steht die Rechnung jetzt hier.
		TT_CHECK_MSG(szAus[25] == 'T',
			"Vor der Sequenz muss das T stehen");
		TT_CHECK_MSG((unsigned char)szAus[26] == 0xC3 &&
					 (unsigned char)szAus[27] == 0xBC,
			"Beide Bytes muessen stehen, und in dieser Reihenfolge");
		TT_Note("%s", szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	// DIE GEGENPROBE AUS DEM PROGRAMM SELBST: unescape_url loest dieselbe
	// Aufgabe. Wo beide dasselbe liefern, stimmt resolve_URL.
	TT_BeginTest("E-110: resolve_URL liefert dasselbe wie unescape_url");
	{
		static const char* apszFaelle[] = {
			"https://beispiel.invalid/ei%20Beispiel%20Bild.png",
			"https://beispiel.invalid/Bild%20A%20B%20(1).jpg",
			"https://beispiel.invalid/T%C3%BCr.png",
			"https://beispiel.invalid/a%2Fb.png",
			"https://beispiel.invalid/klammer%28auf%29.png",
			"https://beispiel.invalid/ohne-sequenz.png"
		};
		int i;

		for (i = 0; i < (int)(sizeof(apszFaelle) / sizeof(apszFaelle[0])); i++)
		{
			Loese(apszFaelle[i], szAus, sizeof(szAus));
			UTRU_UnescapeURL(apszFaelle[i], szGegen, sizeof(szGegen));

			if (strcmp(szAus, szGegen) != 0)
				TT_Fail("Fall %d: resolve_URL '%s' gegen unescape_url '%s'",
						i, szAus, szGegen);
		}
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	// DER ERLAUBTE FALL. Eine Schranke, die den Normalfall bricht, waehrend
	// sie den Sonderfall repariert, ist keine Behebung
	// (Arbeitsweise/schranke-gegentesten.md). Die vierzehn Adressen, die am
	// 18.09.2026 durchkamen, trugen alle keine Prozent-Sequenz.
	TT_BeginTest("E-110: eine Adresse ohne Prozentzeichen bleibt unveraendert");
	{
		static const char* pszEin =
			"https://absender.invalid/bilder/bild-c_500x122px.jpg";

		Loese(pszEin, szAus, sizeof(szAus));

		TT_CHECK_MSG(strcmp(szAus, pszEin) == 0,
			"Ohne Prozentzeichen darf sich kein Byte aendern");
		TT_CHECK(strlen(szAus) == strlen(pszEin));
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	// Die Raender. Ein abgeschnittenes Prozentzeichen am Ende darf nicht
	// ueber das Ende der Zeichenkette hinauslesen - resolve_URL prueft das
	// mit zwei "if (!*input) break;", und die beiden bleiben mitgeprueft.
	TT_BeginTest("E-110: Prozentzeichen am Ende laeuft nicht ueber");
	{
		Loese("https://beispiel.invalid/datei%", szAus, sizeof(szAus));
		TT_CHECK_MSG(strncmp(szAus, "https://beispiel.invalid/datei", 30) == 0,
			"Was vor dem angefangenen Prozentzeichen steht, muss stehen bleiben");

		Loese("https://beispiel.invalid/datei%2", szAus, sizeof(szAus));
		TT_CHECK_MSG(strncmp(szAus, "https://beispiel.invalid/datei", 30) == 0,
			"Auch bei einer halben Sequenz");

		Loese("", szAus, sizeof(szAus));
		TT_CHECK_MSG(szAus[0] == 0, "Die leere Adresse bleibt leer");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (7)
	// Die Laengenschranke. Sie zaehlt output_size fuer BEIDE Zweige hoch -
	// das war vor der Behebung schon so, und genau deshalb passte die
	// gezaehlte Laenge nie zur geschriebenen. Jetzt muessen beide
	// uebereinstimmen, und nMaxLength muss eingehalten werden.
	TT_BeginTest("E-110: nMaxLength wird eingehalten, auch mit Sequenzen");
	{
		char szEng[16];

		memset(szEng, 'X', sizeof(szEng));
		UTRU_ResolveURL("ab%20cd%20ef%20gh%20ij", szEng, 8);

		TT_CHECK_MSG(strlen(szEng) <= 7,
			"Bei nMaxLength=8 duerfen hoechstens 7 Zeichen plus Null entstehen");
		TT_CHECK_MSG(szEng[8] == 'X',
			"Das Byte hinter der Schranke darf nicht angefasst sein");
		TT_Note("nMaxLength=8 ergab '%s' (%d Zeichen)", szEng, (int)strlen(szEng));
	}
	TT_EndTest();

	// ------------------------------------------------------------- (8)
	// BEFUND E-117 (13.10.2026, Gregors Protokoll zu 1.0.86): im src eines
	// Bildes steht laut HTML &amp; fuer &. Fuer Links uebersetzt Eudora das
	// (PGHTMIMP.CPP, Html2Text), fuer Bilder nicht - der Bilddienst bekam
	// "&amp;imgWidth=448" und lieferte ein 1x1-Pixel statt des Fotos.
	TT_BeginTest("E-117: &amp; im src wird zu & - sonst liefert der Bilddienst 1x1");
	{
		Loese("https://svcs.ebay.com/imageser/v1/image/x?a=1&amp;imgWidth=448&amp;imgHeight=448",
			  szAus, sizeof(szAus));
		TT_CHECK_MSG(strcmp(szAus,
			"https://svcs.ebay.com/imageser/v1/image/x?a=1&imgWidth=448&imgHeight=448") == 0,
			"Aus &amp; muss & werden");
		TT_CHECK_MSG(strstr(szAus, "&amp;") == NULL,
			"&amp; im Abruf war der Zustand bis 7.2.0.86 - Foto fehlt");

		// Ein einzelnes & ohne amp; bleibt, wie es ist.
		Loese("https://x.invalid/b?a=1&b=2", szAus, sizeof(szAus));
		TT_CHECK(strcmp(szAus, "https://x.invalid/b?a=1&b=2") == 0);
		TT_Note("%s", szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (9)
	// BEFUND E-111 (PRUEFER-18, 18.09.2026, behoben 22.10.2026): die
	// Laengenschranke prueft ERST NACH dem Schreiben und verglich mit "=="
	// statt ">=". output_size startet bei 1 und zaehlt je Durchlauf um 1 -
	// bei nMaxLength 0 oder 1 wurde "==" deshalb NIE wahr und die Schleife
	// schrieb bis zum Ende der QUELLE ueber das Zielfeld hinaus.
	//
	// Ausgeloest gesehen wurde es nie: alle heutigen Aufrufer uebergeben
	// sizeof() eines grossen Feldes. Dieser Test haelt den Fall fest,
	// damit der naechste Aufrufer mit kleinem Feld nicht hineinlaeuft.
	TT_BeginTest("E-111: entartete Feldgroessen schreiben nicht hinaus");
	{
		char szEng[32];

		// nMaxLength = 1: nur Platz fuer die abschliessende Null.
		memset(szEng, 'X', sizeof(szEng));
		UTRU_ResolveURL("abcdefghij", szEng, 1);
		TT_CHECK_MSG(szEng[0] == 0,
			"Bei nMaxLength=1 bleibt nur Platz fuer die Null");
		TT_CHECK_MSG(szEng[1] == 'X',
			"Byte 1 gehoert nicht mehr zum Feld - bis 7.2.0.120 wurde es beschrieben");
		TT_CHECK_MSG(szEng[9] == 'X',
			"Bis 7.2.0.120 lief die Schleife bis zum Quellende durch");

		// nMaxLength = 0: gar kein Platz, auch nicht fuer die Null.
		memset(szEng, 'X', sizeof(szEng));
		UTRU_ResolveURL("abcdefghij", szEng, 0);
		TT_CHECK_MSG(szEng[0] == 'X',
			"Bei nMaxLength=0 darf kein einziges Byte angefasst werden");

		// Gegenprobe: die normale Groesse verhaelt sich unveraendert.
		memset(szEng, 'X', sizeof(szEng));
		UTRU_ResolveURL("abcdefghij", szEng, 8);
		TT_CHECK_MSG(strcmp(szEng, "abcdefg") == 0,
			"nMaxLength=8 ergibt weiter 7 Zeichen plus Null");
		TT_CHECK_MSG(szEng[8] == 'X',
			"und fasst das Byte dahinter nicht an");
		TT_Note("nMaxLength=1 -> '%s', nMaxLength=8 -> '%s'", "", szEng);
	}
	TT_EndTest();
}
