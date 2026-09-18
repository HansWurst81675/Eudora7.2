//
// TestE112.cpp - welches Rechteck bekommt ein Bild?
//
// Befund E-112, gemessen am 18.09.2026 an Gregors Nachricht: die Bilder
// erschienen im Verfassenfenster in Originalgroesse statt in der angegebenen.
// Das WhatsApp-Symbol ist als 35x35 ausgezeichnet, die Datei hat 330x327.
//
// DIE VORGESCHICHTE GEHOERT IN DIE TESTS, nicht nur in den Befund. E-106 hat
// dasselbe Problem andersherum geloest: das Symptom war "Bild liegt ueber dem
// Text", und ich habe die ZEILE VERGROESSERT statt das BILD ZU VERKLEINERN.
// Das funktionierte, solange E-110 offen war und kaum ein Bild lud. Kaum
// luden sie, fuellte eines das halbe Fenster.
//
// Deshalb pruefen diese Tests BEIDE Richtungen gegeneinander:
//   - mit Groessenangabe  -> die Angabe gewinnt          (E-112)
//   - ohne Groessenangabe -> die Datei gewinnt           (E-103)
// Wer nur die erste prueft, repariert E-112 und bricht E-103.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>

#include "TinyTest.h"
#include "UnderTestE112.h"

void RunE112Tests(void)
{
	long b = -1, h = -1;

	TT_Suite("E-112: das Zielrechteck eines Bildes");

	// ------------------------------------------------------------- (1)
	// Der Anlassfall, Zahlen aus Gregors Protokoll vom 18.09.2026.
	TT_BeginTest("E-112: Datei groesser als angegeben - die ANGABE gewinnt");
	{
		E112Zielrechteck(35, 35, 330, 327, &b, &h);
		TT_CHECK_MSG(b == 35 && h == 35,
			"Das WhatsApp-Symbol ist als 35x35 ausgezeichnet und bleibt 35x35");

		E112Zielrechteck(540, 240, 1294, 575, &b, &h);
		TT_CHECK_MSG(b == 540 && h == 240, "Spendenbanner: angegeben 540x240");

		E112Zielrechteck(600, 146, 1772, 433, &b, &h);
		TT_CHECK_MSG(b == 600 && h == 146, "Totalitarismus-Watch: angegeben 600x146");

		// Die Gegenrichtung ausdruecklich: GENAU das stand vor der Behebung da.
		E112Zielrechteck(35, 35, 330, 327, &b, &h);
		TT_CHECK_MSG(!(b == 330 && h == 327),
			"330x327 war die Fassung vom 18.09.2026 - das halbe Fenster voll");
		TT_Note("35x35 angegeben, 330x327 in der Datei -> Rahmen %ldx%ld", b, h);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	// E-103 darf dabei nicht brechen. Ohne Angabe reservierte Paige eine
	// Textzeile von 13 Punkten fuer ein Bild von 60 - der Text lag darunter.
	TT_BeginTest("E-103 bleibt: ohne Angabe gewinnt die Datei");
	{
		E112Zielrechteck(0, 0, 405, 120, &b, &h);
		TT_CHECK_MSG(b == 405 && h == 120,
			"Ohne jede Angabe muss die echte Dateigroesse gelten - das ist E-103");

		E112Zielrechteck(0, 0, 79, 64, &b, &h);
		TT_CHECK_MSG(b == 79 && h == 64, "Zahlen aus dem Protokoll zu 1.0.67");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	// Die halbe Angabe. In Gregors Protokoll kommt sie oft vor: attr=150x0,
	// attr=56x0, attr=110x0. Sie wird wie KEINE Angabe behandelt - was eine
	// Seitenverhaeltnis-Rechnung daraus machen soll, ist nicht gemessen, und
	// Raten hat bei E-106 schon einmal gereicht.
	TT_BeginTest("E-112: halbe Angabe zaehlt wie keine - die Datei gewinnt");
	{
		E112Zielrechteck(150, 0, 300, 86, &b, &h);
		TT_CHECK_MSG(b == 300 && h == 86, "Nur Breite angegeben: die Datei gilt");

		E112Zielrechteck(0, 52, 400, 104, &b, &h);
		TT_CHECK_MSG(b == 400 && h == 104, "Nur Hoehe angegeben: die Datei gilt");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	// Die Angabe gewinnt AUCH, wenn die Datei kleiner ist. Sonst entstuende
	// eine zweite Regel ("nur verkleinern, nie vergroessern") - genau die
	// stand in E-106 und war die falsche.
	TT_BeginTest("E-112: die Angabe gewinnt auch bei kleinerer Datei");
	{
		E112Zielrechteck(200, 100, 50, 25, &b, &h);
		TT_CHECK_MSG(b == 200 && h == 100,
			"Ein kleines Bild wird auf die angegebene Groesse gestreckt");

		E112Zielrechteck(120, 60, 120, 60, &b, &h);
		TT_CHECK_MSG(b == 120 && h == 60, "Gleich gross bleibt gleich gross");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	// Wenn nichts bekannt ist, wird nichts behauptet. Der Aufrufer prueft auf
	// > 0 und laesst das Embed dann unangetastet - ein Rechteck von 0x0 waere
	// ein unsichtbares Bild.
	TT_BeginTest("E-112: nichts bekannt - 0x0, der Aufrufer laesst alles stehen");
	{
		E112Zielrechteck(0, 0, 0, 0, &b, &h);
		TT_CHECK_MSG(b == 0 && h == 0, "Ohne jede Zahl wird nichts entschieden");

		E112Zielrechteck(0, 0, 100, 0, &b, &h);
		TT_CHECK_MSG(b == 0 && h == 0, "Eine halbe Dateigroesse ist keine Groesse");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	// Negative Werte kommen aus einem short, der ueberlaufen ist. Sie duerfen
	// nicht als gueltige Angabe durchgehen.
	TT_BeginTest("E-112: negative Masse zaehlen nicht als Angabe");
	{
		E112Zielrechteck(-1, 40, 200, 80, &b, &h);
		TT_CHECK_MSG(b == 200 && h == 80, "Eine negative Breite ist keine Angabe");

		E112Zielrechteck(100, 50, -5, -5, &b, &h);
		TT_CHECK_MSG(b == 100 && h == 50,
			"Negative Dateimasse aendern an der gueltigen Angabe nichts");

		E112Zielrechteck(-1, -1, -1, -1, &b, &h);
		TT_CHECK_MSG(b == 0 && h == 0, "Nur Unsinn ergibt 0x0");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (7)
	// Ein Nullzeiger darf die Funktion nicht umbringen. Sie wird aus dem
	// Ladeweg gerufen, und dort ist in diesem Projekt schon zweimal etwas
	// abgestuerzt (E-107, E-108).
	TT_BeginTest("E-112: Nullzeiger stuerzt nicht ab");
	{
		E112Zielrechteck(35, 35, 330, 327, NULL, NULL);
		E112Zielrechteck(35, 35, 330, 327, &b, NULL);
		TT_CHECK_MSG(true, "Kein Absturz bei fehlenden Ausgabezeigern");
	}
	TT_EndTest();
}
