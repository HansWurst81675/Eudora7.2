//
// TestE105.cpp - werden Abschnitte mit style="display:none" ausgeblendet?
//
// Befund E-105: Newsletter schicken Desktop- und Handyfassung in derselben
// Mail und verstecken eine davon inline mit display:none. Eudora zeigte
// beide - jedes Bild, jeder Absatz doppelt. Gregor am 14.10.2026 an seinen
// echten Newslettern (freenet Autofahrer, Camper), dreimal an einem Tag.
//
// Die Puffer unten haben das Format, das ReadHTMLTag (PGHTMIMP.CPP) baut:
// Token durch ein Leerzeichen getrennt, "=" als eigenes Token, Werte samt
// Anfuehrungszeichen.
//
// Jeder Test prueft auch die Gegenrichtung: was SICHTBAR ist, muss sichtbar
// bleiben. Ein Filter, der zu viel verschluckt, loescht Gregors Post.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE105.h"

// Spielt eine Folge von Tags durch und zaehlt, wie viele durchkommen.
// Liefert in szDurch die durchgelassenen Tagnamen, durch "|" getrennt.
static void Abspielen(const char* const* aTags, char* szDurch, size_t nDurch, long* pnTiefe)
{
	char szTag[16] = "";
	int i;

	*pnTiefe = 0;
	szDurch[0] = 0;
	for (i = 0; aTags[i]; ++i) {
		if (!E105Schritt(aTags[i], szTag, pnTiefe)) {
			const char* p = aTags[i];
			char szName[32];
			int n = 0;
			while (*p && *p != ' ' && n < 31)
				szName[n++] = *p++;
			szName[n] = 0;
			if (szDurch[0])
				strncat(szDurch, "|", nDurch - strlen(szDurch) - 1);
			strncat(szDurch, szName, nDurch - strlen(szDurch) - 1);
		}
	}
}

void RunE105Tests(void)
{
	char szTag[16];
	long nTiefe;
	char szDurch[512];

	TT_Suite("E-105: versteckte Abschnitte (display:none)");

	// ------------------------------------------------------------- (1)
	TT_BeginTest("E-105: die Handyfassung aus Gregors freenet-Newsletter wird verschluckt");
	{
		strcpy(szTag, ""); nTiefe = 0;
		TT_CHECK_MSG(E105Schritt("table class = \"mobile\" style = \"width: 100%; display: none; visibility: hidden; max-height: 0\" ", szTag, &nTiefe) == 1,
			"<table class=mobile style=...display: none...> wird verschluckt");
		TT_CHECK_MSG(nTiefe == 1 && strcmp(szTag, "table") == 0,
			"und oeffnet einen versteckten Bereich 'table'");
		TT_Note("nach dem Tag: Tiefe=%ld Tag=%s", nTiefe, szTag);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	TT_BeginTest("E-105 Gegenrichtung: die Desktopfassung bleibt sichtbar");
	{
		strcpy(szTag, ""); nTiefe = 0;
		TT_CHECK_MSG(E105Schritt("table class = \"desktop\" style = \"width: 100%; display: block\" ", szTag, &nTiefe) == 0,
			"display: block bleibt sichtbar");
		TT_CHECK_MSG(E105Schritt("table width = \"600\" ", szTag, &nTiefe) == 0,
			"ohne style bleibt sichtbar");
		TT_CHECK_MSG(E105Schritt("div style = \"mso-display: none; color: red\" ", szTag, &nTiefe) == 0,
			"mso-display ist nicht display");
		TT_CHECK_MSG(E105Schritt("div style = \"display: nonesuch\" ", szTag, &nTiefe) == 0,
			"none muss als Wort enden");
		TT_CHECK_MSG(E105Schritt("div title = \"display:none\" ", szTag, &nTiefe) == 0,
			"display:none in einem ANDEREN Attribut versteckt nichts");
		TT_CHECK_MSG(E105Schritt("div class = \"style\" ", szTag, &nTiefe) == 0,
			"ein Wert 'style' ist kein style-Attribut");
		TT_CHECK_MSG(nTiefe == 0, "kein versteckter Bereich offen");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	TT_BeginTest("E-105: Schreibweisen von display:none");
	{
		strcpy(szTag, ""); nTiefe = 0;
		TT_CHECK(E105Schritt("DIV STYLE = \"DISPLAY:NONE\" ", szTag, &nTiefe) == 1);
		TT_CHECK(nTiefe == 1 && strcmp(szTag, "div") == 0);

		strcpy(szTag, ""); nTiefe = 0;
		TT_CHECK_MSG(E105Schritt("div style = 'color:red;display :  none !important' ", szTag, &nTiefe) == 1,
			"einfache Anfuehrungszeichen, Leerzeichen um den Doppelpunkt, !important");

		strcpy(szTag, ""); nTiefe = 0;
		TT_CHECK_MSG(E105Schritt("span style = display:none ", szTag, &nTiefe) == 1,
			"Wert ohne Anfuehrungszeichen");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	TT_BeginTest("E-105: alles im versteckten Bereich, verschachtelt, danach wieder sichtbar");
	{
		static const char* const aTags[] = {
			"table class = \"desktop\" ",
			"/table ",
			"table class = \"mobile\" style = \"display: none\" ",
			"tr ", "td ", "table ", "tr ", "td ", "img src = \"a.png\" ",
			"/td ", "/tr ", "/table ",           // innere Tabelle zu - noch versteckt
			"/td ", "/tr ",
			"/table ",                            // die versteckte zu
			"p ", "/p ",
			0 };
		Abspielen(aTags, szDurch, sizeof(szDurch), &nTiefe);
		TT_CHECK_MSG(strcmp(szDurch, "table|/table|p|/p") == 0,
			"nur Desktoptabelle und der Absatz danach kommen durch");
		TT_CHECK_MSG(nTiefe == 0, "Bereich am Ende geschlossen");
		TT_Note("durchgelassen: %s", szDurch);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	TT_BeginTest("E-105: leere Elemente oeffnen keinen Bereich");
	{
		strcpy(szTag, ""); nTiefe = 0;
		TT_CHECK_MSG(E105Schritt("img src = \"spacer.gif\" style = \"display:none\" ", szTag, &nTiefe) == 1,
			"verstecktes Bild wird verschluckt");
		TT_CHECK_MSG(nTiefe == 0, "aber nur das Bild - img hat kein Ende-Tag");
		TT_CHECK_MSG(E105Schritt("div style = \"display:none\" / ", szTag, &nTiefe) == 1 && nTiefe == 0,
			"selbstschliessendes <div ... /> oeffnet keinen Bereich");
		TT_CHECK_MSG(E105Schritt("p ", szTag, &nTiefe) == 0, "der Text danach bleibt sichtbar");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	TT_BeginTest("E-105 Schutz: ein nie geschlossenes Element verschluckt nicht den Rest");
	{
		static const char* const aBody[] = {
			"div style = \"display:none\" ", "p ", "/p ",
			"/body ", "/html ", 0 };
		static const char* const aP[] = {
			"p style = \"display:none\" ", "span ", "/span ",
			"div ", "/div ",                     // Blockelement beendet das <p>
			0 };
		static const char* const aPInTd[] = {
			"td ", "p style = \"display:none\" ", "/td ",
			"td ", "/td ", 0 };
		static const char* const aPp[] = {
			"p style = \"display:none\" ",
			"p style = \"display:none\" ",       // naechstes <p> ist WIEDER versteckt
			"p ", 0 };

		Abspielen(aBody, szDurch, sizeof(szDurch), &nTiefe);
		TT_CHECK_MSG(strcmp(szDurch, "/body|/html") == 0, "</body> beendet jeden Bereich");
		TT_Note("ungeschlossenes div: %s", szDurch);

		Abspielen(aP, szDurch, sizeof(szDurch), &nTiefe);
		TT_CHECK_MSG(strcmp(szDurch, "div|/div") == 0, "<p> endet am naechsten Block, wie im Browser");
		TT_Note("ungeschlossenes p: %s", szDurch);

		Abspielen(aPInTd, szDurch, sizeof(szDurch), &nTiefe);
		TT_CHECK_MSG(strcmp(szDurch, "td|/td|td|/td") == 0, "<p> endet am Ende der Zelle");

		Abspielen(aPp, szDurch, sizeof(szDurch), &nTiefe);
		TT_CHECK_MSG(strcmp(szDurch, "p") == 0, "das zweite versteckte <p> bleibt versteckt");
		TT_Note("p p p: %s", szDurch);
	}
	TT_EndTest();
}
