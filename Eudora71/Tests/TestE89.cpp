//
// TestE89.cpp - die Bilder im Verfassenfenster
//
// Befund E-89. Geprueft wird E89BilderMessbarMachen aus msgutils.cpp, ueber
// UnderTestE89.cpp aus dem Produktivcode geschnitten.
//
// Die Umschrift sitzt zwischen zwei Fehlerarten, die man beide erst am
// laufenden Programm saehe: schreibt sie zu wenig um, liegen die Bilder
// wieder ueber dem Text (Gregor an 1.0.56: "da ist alles durcheinander,
// man kann ja nichts lesen"). Schreibt sie zu viel um, verliert die
// Nachricht Angaben, die der Absender gemeint hat - und im schlimmsten
// Fall den Weg zurueck zum Original aus E-88.
//
// Darum faehrt jede Gruppe beide Richtungen. Der wichtigste Test ist
// deshalb nicht einer der Positivfaelle, sondern die Gegenprobe: eine
// Nachricht ohne ein einziges <img> muss Byte fuer Byte unveraendert
// durchkommen.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE89.h"
#include "UnderTestE88.h"

//
// Kleiner Helfer: die Umschrift laufen lassen und dabei nachmessen, dass
// der Eingangstext selbst unberuehrt bleibt. Das ist keine Formsache -
// genau daran haengt, dass das aufgehobene Original aus E-88 heil bleibt:
// summary.cpp gibt derselben Zeichenkette einmal an die Umschrift und
// einmal an CCompMessageDoc::m_szE88OriginalHTML.
//
static bool Umschreiben(const char* pszEin, CString& out_szAus, CString& out_szSpur)
{
	CString		szSicherung(pszEin);
	bool		bGeaendert = UTE89_BilderMessbarMachen(pszEin, out_szAus, out_szSpur);

	TT_CHECK_MSG(szSicherung == CString(pszEin),
				 "Der Eingangstext wurde veraendert - damit waere das Original aus E-88 hin");

	return bGeaendert;
}

//
// Ein Original, wie QuoteText es baut: die Groessen stehen nur im CSS.
// Genau diese Sorte Bild liegt bei Gregor ueber der Ueberschrift.
//
// Das zweite Bild steht mit Absicht MITTEN im Text und nicht am Anfang.
// Nur so laesst sich die Gegenprobe (10b) ueberhaupt fahren: ein
// Platzhalter ganz vorn sieht fuer E88OriginalEinsetzen aus wie ein Satz,
// den der Anwender selbst davorgeschrieben hat, und faellt nicht auf.
//
static const char* const kOriginalMitCss =
	"<x-html><html><body>"
	"<div style=\"background-color:#f0f0f0;border:1px solid #ccc;padding:12px\">"
	"<img src=\"cid:logo\" style=\"width:320px;height:80px\">"
	"<p>Guten Tag, hier ist der Rundbrief vom Mittwoch.</p>"
	"<img src=\"cid:foto\" style=\"width:480px;height:270px\">"
	"<p>Mit freundlichen Gruessen, die Redaktion</p>"
	"</div></body></html></x-html>";

void RunE89Tests(void)
{
	CString		szAus, szSpur;
	bool		bGeaendert;

	TT_Suite("Befund E-89 - lesbare Bilder im Verfassenfenster");

	// ------------------------------------------------------------- (1)
	TT_BeginTest("E-89: Groesse nur im CSS - width und height werden ergaenzt");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"cid:logo\" style=\"width:600px;height:150px\">"
			"<p>Text</p></body></html>", szAus, szSpur);

		TT_CHECK(bGeaendert);
		TT_CHECK(szAus.Find("width=\"600\"") >= 0);
		TT_CHECK(szAus.Find("height=\"150\"") >= 0);
		// Das style bleibt stehen: Paige sieht darueber hinweg, und was
		// wir nicht anfassen, koennen wir auch nicht verderben.
		TT_CHECK(szAus.Find("style=\"width:600px;height:150px\"") >= 0);
		TT_CHECK(szAus.Find("src=\"cid:logo\"") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	TT_BeginTest("E-89 Gegenprobe: width und height schon als Attribut - nichts wird angefasst");
	{
		const char* const	pszEin =
			"<html><body><img src=\"a.png\" width=\"120\" height=\"60\" alt=\"Logo\">"
			"<p>Text</p></body></html>";

		bGeaendert = Umschreiben(pszEin, szAus, szSpur);

		TT_CHECK_MSG(!bGeaendert, "Ein Bild mit eigener, brauchbarer Groesse darf nicht "
								  "umgeschrieben werden - das waere eine fremde Absicht");
		TT_CHECK(szAus.IsEmpty());
		TT_CHECK(szSpur.Find("unveraendert=1") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	TT_BeginTest("E-89: gar keine Groessenangabe - kleine Vorgabe, damit die Zeile stimmt");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"https://example.invalid/bild.jpg\" alt=\"Bild\">"
			"</body></html>", szAus, szSpur);

		// Bis zum 14.09.2026 wurde hier eine Vorgabe von 200x90 eingesetzt.
		// Auf Gregors Bild zu 1.0.57 erschien sie als leerer grauer Kasten
		// mitten im Text: Platz, der weggenommen wird, ohne dass etwas zu
		// sehen ist. Eine geratene Zahl ist schlechter als keine - Paige
		// kennt die wirkliche Groesse, sobald es die Datei geladen hat.
		TT_CHECK_MSG(bGeaendert,
					 "ohne Hoehe bleibt die Zeile textklein und der Text wird zugedeckt");
		TT_CHECK(szAus.Find("height=\"20\"") >= 0);
		TT_CHECK(szSpur.Find("ohne-Mass=1") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	TT_BeginTest("E-89: breiter als der Deckel - wird gestutzt, die Hoehe geht proportional mit");
	{
		CString		szB, szH;
		szB.Format("width=\"%d\"", UTE89_MaxBreite());
		szH.Format("height=\"%d\"", UTE89_MaxBreite() / 2);	// 1200 x 600 -> 600 x 300

		bGeaendert = Umschreiben(
			"<html><body><img src=\"kopf.png\" width=\"1200\" height=\"600\">"
			"</body></html>", szAus, szSpur);

		TT_CHECK(bGeaendert);
		TT_CHECK(szAus.Find(szB) >= 0);
		TT_CHECK_MSG(szAus.Find(szH) >= 0,
					 "Die Hoehe muss im selben Verhaeltnis mitgehen - sonst ist das Bild verzerrt");
		// Das alte width darf NICHT stehenbleiben: find_parameter nimmt
		// das erste, das es findet (PGHTMIMP.CPP:2019).
		TT_CHECK_MSG(szAus.Find("1200") < 0, "Das alte width=\"1200\" steht noch in der Markierung");
		TT_CHECK(szSpur.Find("gedeckelt=1") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	TT_BeginTest("E-89: width mitten im style zwischen anderen Eigenschaften");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"x.png\" "
			"style=\"border:1px solid #ccc;width:300px;margin:0\"></body></html>",
			szAus, szSpur);

		TT_CHECK(bGeaendert);
		TT_CHECK(szAus.Find("width=\"300\"") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5b)
	TT_BeginTest("E-89 Gegenprobe: max-width darf nicht als width durchgehen");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"x.png\" style=\"max-width:480px\"></body></html>",
			szAus, szSpur);

		TT_CHECK_MSG(szAus.Find("width=\"480\"") < 0,
					 "max-width ist eine Obergrenze, keine Breite - 480 waere geraten");
		TT_CHECK(szSpur.Find("ohne-Mass=1") >= 0);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	TT_BeginTest("E-89: Prozentbreite bleibt Prozent - Paige kann sie");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"x.png\" style=\"width:50%\"></body></html>",
			szAus, szSpur);

		TT_CHECK(bGeaendert);
		// decimal_value_percent rechnet Prozent gegen die Seitenbreite
		// (PGHTMIMP.CPP:2020) - das ist naeher am Gemeinten als jede Zahl.
		TT_CHECK(szAus.Find("width=\"50%\"") >= 0);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6b)
	TT_BeginTest("E-89 Gegenprobe: Prozenthoehe wird NICHT zur Pixelzahl");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"x.png\" style=\"height:50%\"></body></html>",
			szAus, szSpur);

		TT_CHECK_MSG(szAus.Find("height=\"50\"") < 0,
					 "aus einer Prozenthoehe darf keine Pixelzahl werden");
		// numeric_value liest bei der Hoehe nur die Zahl
		// (PGHTMIMP.CPP:2022) - aus "50%" wuerden 50 Bildpunkte.
		TT_CHECK_MSG(szAus.Find("height=\"50\"") < 0,
					 "Aus einer Prozenthoehe darf keine Pixelzahl werden");
		TT_CHECK(szSpur.Find("ohne-Mass=1") >= 0);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6c)
	TT_BeginTest("E-89 Gegenprobe: em und auto werden nicht als Pixel gelesen");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"a.png\" style=\"width:10em\">"
			"<img src=\"b.png\" style=\"width:auto\"></body></html>", szAus, szSpur);

		TT_CHECK_MSG(szAus.Find("width=\"10\"") < 0,
					 "10em ist nicht 10 Bildpunkte");
		TT_CHECK_MSG(szAus.Find("width=\"10\"") < 0, "10em ist nicht 10 Bildpunkte");
		TT_CHECK(szSpur.Find("ohne-Mass=2") >= 0);
		TT_CHECK(szSpur.Find("gesamt=2") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (7)
	TT_BeginTest("E-89: Grossschreibung und Leerraum im style");
	{
		bGeaendert = Umschreiben(
			"<html><body><IMG SRC=\"x.png\" STYLE=\"WIDTH : 600 PX\"></body></html>",
			szAus, szSpur);

		TT_CHECK(bGeaendert);
		TT_CHECK(szAus.Find("width=\"600\"") >= 0);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (8)
	TT_BeginTest("E-89: kaputtes HTML - kein Absturz, kein Lauf ueber das Ende");
	{
		const char* const	kKaputt[] = {
			"<img src=x style=\"width:",					// Anfuehrung nie geschlossen
			"<img",										// Markierung nie geschlossen
			"<img ",
			"<img src=\"a.png\" width=",				// Attribut ohne Wert
			"<img src=\"a.png\" style=\"width:;\">",	// leere Eigenschaft
			"<",
			"<i",
			"<imgx src=\"a.png\">",						// kein <img>
			"<image src=\"a.png\">",					// auch kein <img>
			""
		};

		for (int k = 0; k < (int)(sizeof(kKaputt) / sizeof(kKaputt[0])); k++)
		{
			CString		szE, szS;
			// Fuehrt einer dieser Faelle ueber das Pufferende, endet der
			// Testlauf hier - das ist die Aussage des Tests.
			UTE89_BilderMessbarMachen(kKaputt[k], szE, szS);
			TT_CHECK(!szS.IsEmpty());
		}

		// <imgx> und <image> duerfen gar nicht erst gezaehlt werden.
		UTE89_BilderMessbarMachen("<imgx src=\"a.png\"><image src=\"b.png\">", szAus, szSpur);
		TT_CHECK(szSpur.Find("gesamt=0") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (8b)
	TT_BeginTest("E-89: ein '>' im alt-Text beendet die Markierung nicht");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"a.png\" alt=\"a > b\" width=\"50\"></body></html>",
			szAus, szSpur);

		TT_CHECK(bGeaendert);
		TT_CHECK_MSG(szAus.Find("alt=\"a > b\"") >= 0,
					 "Der alt-Text wurde zerschnitten");
		TT_CHECK(szSpur.Find("gesamt=1") >= 0);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (9)
	TT_BeginTest("E-89 Gegenprobe: eine Nachricht ohne Bild kommt Byte fuer Byte durch");
	{
		const char* const	pszOhneBild =
			"<x-html><html><body><p>Hallo Gregor,</p>"
			"<p>hier steht kein einziges Bild, dafuer ein &lt;img&gt; als Text "
			"und eine Zeile mit &lt; und &gt; darin.</p>"
			"<table><tr><td>Betreff:</td><td>Rundbrief</td></tr></table>"
			"</body></html></x-html>";

		bGeaendert = Umschreiben(pszOhneBild, szAus, szSpur);

		TT_CHECK_MSG(!bGeaendert, "An einer Nachricht ohne Bild gibt es nichts umzuschreiben");
		TT_CHECK(szAus.IsEmpty());
		TT_CHECK(szSpur.Find("gesamt=0") >= 0);
		TT_CHECK(szSpur.Find("geaendert=0") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (10)
	TT_BeginTest("E-89 mit E-88: die Umschrift ist fuer den Vergleich unsichtbar");
	{
		CString		szEditor, szNeu, szSpur88;

		// So laeuft es im Programm: derselbe Rumpf geht einmal durch die
		// Umschrift in den Editor und wird einmal unveraendert als
		// Original gemerkt (summary.cpp).
		bGeaendert = Umschreiben(kOriginalMitCss, szEditor, szSpur);
		TT_CHECK(bGeaendert);
		TT_CHECK(szEditor.Find("width=\"320\"") >= 0);
		TT_CHECK(szEditor.Find("width=\"480\"") >= 0);
		TT_CHECK(szSpur.Find("gesamt=2") >= 0);

		// Und hier die Probe aufs Exempel: E88OriginalEinsetzen muss den
		// Klartext des Originals in der umgeschriebenen Fassung weiterhin
		// als ein Stueck wiederfinden. E88NurText wirft Markierungen weg -
		// deshalb darf ein zusaetzliches width= nichts ausmachen. Ein
		// eingefuegter Platzhalter "[Bild]" dagegen wuerde genau hier
		// scheitern; das ist der Grund, warum E-89 den Weg ueber die
		// Attribute geht und nicht den ueber den Platzhalter.
		UTE88_SetSchalter(1);
		bool	bErsetzt = UTE88_OriginalEinsetzen(kOriginalMitCss, (LPCTSTR) szEditor,
												    4, true, szNeu, szSpur88);

		TT_CHECK_MSG(bErsetzt, "E-89 hat E-88 den Weg zum Original verbaut");
		TT_CHECK(szSpur88.Find("Fassung=ORIGINAL") >= 0);
		// Was hinausgeht, ist das Original - mit CSS und ohne unsere
		// Attribute.
		TT_CHECK(szNeu.Find("background-color") >= 0);
		TT_CHECK_MSG(szNeu.Find("width=\"320\"") < 0,
					 "Die Editor-Attribute sind im Original gelandet");
		TT_Note("%s", (LPCTSTR) szSpur88);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (10b)
	TT_BeginTest("E-89 Gegenprobe zu (10): ein Platzhalter WUERDE E-88 zerreissen");
	{
		CString		szMitPlatzhalter(kOriginalMitCss);
		CString		szNeu, szSpur88;

		// Dasselbe Original, aber das Bild MITTEN im Zitat durch Text
		// ersetzt - der Weg, den E-89 ausdruecklich NICHT geht. Der Test
		// zeigt, dass die Begruendung traegt und nicht nur behauptet ist.
		szMitPlatzhalter.Replace("<img src=\"cid:foto\" style=\"width:480px;height:270px\">",
								 "[Bild]");

		UTE88_SetSchalter(1);
		bool	bErsetzt = UTE88_OriginalEinsetzen(kOriginalMitCss,
												   (LPCTSTR) szMitPlatzhalter,
												    4, true, szNeu, szSpur88);

		TT_CHECK_MSG(!bErsetzt, "Mit Platzhalter muesste der Vergleich scheitern - "
								"tut er es nicht, ist die Begruendung von E-89 falsch");
		TT_CHECK(szSpur88.Find("Fassung=EDITOR") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur88);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (11)
	TT_BeginTest("E-89: mehrere Bilder in einer Nachricht - jedes einzeln");
	{
		bGeaendert = Umschreiben(
			"<html><body>"
			"<img src=\"a.png\" width=\"100\" height=\"50\">"		// bleibt
			"<img src=\"b.png\" style=\"width:64px;height:64px\">"	// aus CSS
			"<img src=\"c.png\">"									// Vorgabe
			"<img src=\"d.png\" width=\"2000\" height=\"1000\">"	// Deckel
			"</body></html>", szAus, szSpur);

		TT_CHECK(bGeaendert);
		TT_CHECK(szSpur.Find("gesamt=4") >= 0);
		TT_CHECK(szSpur.Find("unveraendert=1") >= 0);
		TT_CHECK(szSpur.Find("aus-CSS=1") >= 0);
		TT_CHECK(szSpur.Find("ohne-Mass=1") >= 0);
		TT_CHECK(szSpur.Find("gedeckelt=1") >= 0);
		// Das unangetastete Bild muss wortgleich dastehen.
		TT_CHECK(szAus.Find("<img src=\"a.png\" width=\"100\" height=\"50\">") >= 0);
		TT_CHECK(szAus.Find("width=\"64\"") >= 0);
		TT_CHECK(szAus.Find("height=\"64\"") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (12)
	TT_BeginTest("E-89: das schliessende / einer XHTML-Markierung bleibt erhalten");
	{
		bGeaendert = Umschreiben(
			"<html><body><img src=\"x.png\" style=\"width:40px;height:40px\" /></body></html>",
			szAus, szSpur);

		TT_CHECK(bGeaendert);
		TT_CHECK(szAus.Find("width=\"40\"") >= 0);
		TT_CHECK_MSG(szAus.Find("/>") >= 0, "Die Markierung hat ihr schliessendes / verloren");
		TT_Note("%s", (LPCTSTR) szAus);
	}
	TT_EndTest();
}
