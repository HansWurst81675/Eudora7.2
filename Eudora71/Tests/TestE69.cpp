//
// TestE69.cpp - Befund E-69, P3 aus PRUEFER-36: die Meldungsflut
//
// Bis zum 19.10.2026 legte Eudora bei JEDER uebersprungenen Nachricht einen
// eigenen Eintrag in "Task Errors" an. Jeder Eintrag piept
// (MessageBeep, TaskErrorView.cpp) und holt das Fenster nach vorn
// (TaskErrorBringToFront, Vorgabe 1). Bei einem IMAP-Postfach mit 500
// angerissenen Nachrichten und nicht erreichbarem Server: 500 Eintraege,
// 500 Pieptoene, 500 Fenstersprunge - und nichts davon kann man wegklicken.
//
// Gregor am 19.10.2026, auf die Frage nach einem Kaestchen im Dialog:
// "ich dachte, es waere eine grosse meldung in der dialogbox, aehnlich wie
// die meldung, dass man neue mails hat". Es gibt keine - es piept nur.
// Deshalb zwei Regeln:
//
//   A  an der Quelle zusammenfassen: der ERSTE Fall eines Laufs bekommt
//      einen eigenen Eintrag, der Rest wird gezaehlt und am Ende zu EINEM
//      zusammengefasst.
//   B  den Schwall abfangen: piepen und nach vorn holen hoechstens einmal
//      je Zeitfenster - unabhaengig davon, woher die Fehler kommen.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>

#include "TinyTest.h"
#include "UnderTestE69.h"

void RunE69Tests(void)
{
	TT_Suite("E-69: die Meldungsflut in Task Errors");

	// ------------------------------------------------------------- (1)
	// Der Anlassfall: ein Lauf ueber viele Nachrichten, alle unlesbar.
	TT_BeginTest("E-69 A: 500 uebersprungene ergeben 1 Eintrag + 1 Sammeleintrag");
	{
		void* p = UTE69_Neu();
		int nEintraege = 0;
		int i;

		UTE69_LaufBeginn(p);
		for (i = 0; i < 500; i++)
			if (UTE69_Melden(p))
				nEintraege++;
		int nWeitere = UTE69_LaufEnde(p);

		TT_CHECK_MSG(nEintraege == 1, "Genau der erste Fall bekommt einen eigenen Eintrag");
		TT_CHECK_MSG(nWeitere == 499, "Die uebrigen 499 werden zu einem Sammeleintrag");
		TT_Note("500 uebersprungen -> %d Eintrag + Sammeleintrag ueber %d", nEintraege, nWeitere);
		UTE69_Frei(p);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	// Der haeufige Fall: genau EINE Nachricht ist unlesbar. Dann darf KEIN
	// Sammeleintrag entstehen - sonst stuende zweimal dasselbe da.
	TT_BeginTest("E-69 A: ein einziger Fall ergibt genau einen Eintrag");
	{
		void* p = UTE69_Neu();

		UTE69_LaufBeginn(p);
		TT_CHECK_MSG(UTE69_Melden(p), "Der erste Fall wird gemeldet");
		TT_CHECK_MSG(UTE69_LaufEnde(p) == 0, "Kein Sammeleintrag ueber null weitere");
		UTE69_Frei(p);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	// Ein Lauf ohne jeden Zwischenfall darf nichts melden.
	TT_BeginTest("E-69 A: ein Lauf ohne Zwischenfall meldet nichts");
	{
		void* p = UTE69_Neu();

		UTE69_LaufBeginn(p);
		TT_CHECK_MSG(UTE69_LaufEnde(p) == 0, "Nichts uebersprungen, nichts gemeldet");
		UTE69_Frei(p);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	// Zwei Laeufe nacheinander: der zweite faengt bei null an. Sonst bliebe
	// der erste Lauf stumm geschaltet.
	TT_BeginTest("E-69 A: der zweite Lauf faengt wieder bei null an");
	{
		void* p = UTE69_Neu();

		UTE69_LaufBeginn(p);
		UTE69_Melden(p);
		UTE69_Melden(p);
		TT_CHECK(UTE69_LaufEnde(p) == 1);

		UTE69_LaufBeginn(p);
		TT_CHECK_MSG(UTE69_Melden(p), "Im zweiten Lauf wird wieder voll gemeldet");
		TT_CHECK(UTE69_LaufEnde(p) == 0);
		UTE69_Frei(p);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	// Geschachtelte Klammern: nur die aeusserste zaehlt ab. Sonst entstuende
	// der Sammeleintrag mitten im Lauf.
	TT_BeginTest("E-69 A: geschachtelte Laeufe - nur der aeusserste zaehlt ab");
	{
		void* p = UTE69_Neu();

		UTE69_LaufBeginn(p);
		UTE69_Melden(p);
		UTE69_LaufBeginn(p);		// innen
		UTE69_Melden(p);
		UTE69_Melden(p);
		TT_CHECK_MSG(UTE69_LaufEnde(p) == 0, "Der innere Abbau meldet nichts");
		TT_CHECK_MSG(UTE69_LaufEnde(p) == 2, "Erst der aeussere fasst zusammen");
		UTE69_Frei(p);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	// OHNE Klammer: altes Verhalten, jeder Fall einzeln. Das ist die
	// Gegenprobe - eine Aufrufstelle ohne CE69Filterlauf darf nicht
	// schlechter dastehen als vor der Behebung, sondern genauso.
	TT_BeginTest("E-69 A Gegenprobe: ohne Klammer bleibt es beim alten Verhalten");
	{
		void* p = UTE69_Neu();

		TT_CHECK_MSG(UTE69_Melden(p), "Erster Fall ohne Klammer: Eintrag");
		TT_CHECK_MSG(UTE69_LaufEnde(p) == 0, "Ohne Klammer kein Sammeleintrag");
		UTE69_Frei(p);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (7)
	// B: die Zeitregel. Der erste ist immer laut.
	TT_BeginTest("E-69 B: der erste Fehler ist immer laut");
	{
		DWORD dwLetzte = 0;
		TT_CHECK_MSG(E69LautErlaubt(1000, &dwLetzte, 2000),
			"Ohne Vorgeschichte wird gepiept");
		TT_CHECK_MSG(dwLetzte == 1000, "Der Zeitpunkt wird gemerkt");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (8)
	// Der Schwall: innerhalb des Fensters bleibt es still.
	TT_BeginTest("E-69 B: im Fenster bleibt es still, danach wieder laut");
	{
		DWORD dwLetzte = 0;
		int i, nLaut = 0;

		// 500 Fehler in 100 ms Abstand, Fenster 2000 ms
		for (i = 0; i < 500; i++)
			if (E69LautErlaubt(10000 + i * 100, &dwLetzte, 2000))
				nLaut++;

		TT_CHECK_MSG(nLaut <= 26, "Aus 500 Pieptoenen werden hoechstens 26");
		TT_CHECK_MSG(nLaut >= 24, "Aber es verstummt nicht ganz");
		TT_Note("500 Fehler in 50 s, Fenster 2 s -> %d mal laut", nLaut);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (9)
	// Die Raender: Fenstergrenze genau getroffen, und der Ueberlauf von
	// GetTickCount nach 49,7 Tagen.
	TT_BeginTest("E-69 B: Fenstergrenze und Ueberlauf von GetTickCount");
	{
		DWORD dwLetzte = 0;

		E69LautErlaubt(5000, &dwLetzte, 2000);
		TT_CHECK_MSG(!E69LautErlaubt(6999, &dwLetzte, 2000), "1999 ms: noch still");
		TT_CHECK_MSG(E69LautErlaubt(7000, &dwLetzte, 2000), "2000 ms: wieder laut");

		// Ueberlauf: 0xFFFFFF00 -> 0x00000100 sind 512 ms, nicht 4 Milliarden.
		dwLetzte = 0xFFFFFF00;
		TT_CHECK_MSG(!E69LautErlaubt(0x00000100, &dwLetzte, 2000),
			"Ueber den Ueberlauf hinweg sind es 512 ms - still");

		// Und ein Nullzeiger darf nicht umbringen.
		TT_CHECK_MSG(E69LautErlaubt(1234, NULL, 2000), "Ohne Merker: laut, kein Absturz");
	}
	TT_EndTest();

	// ------------------------------------------------------------ (10)
	// PRUEFER-38, R1: DIESELBE Sammlung ueber mehrere Laeufe hinweg.
	//
	// In Eudora ist g_E69Sammlung eine GLOBALE Variable. Alle Tests oben
	// legen je ein frisches Objekt an und konnten deshalb nicht sehen, dass
	// LaufEnde() nichts zurueckgesetzt hat: nach dem ersten geklammerten
	// Lauf blieb bErstGemeldet auf true, und jeder spaetere Fall ausserhalb
	// einer Klammer bekam GAR KEINEN Eintrag mehr - E-69 war stumm, bis
	// Eudora neu startete.
	//
	// Neun gruene Tests, und der Fehler war trotzdem da. Ein Test, der
	// seinen Zustand nicht teilt, kann einen Zustandsfehler nicht sehen.
	TT_BeginTest("E-69 A / R1: nach einem Lauf meldet dieselbe Sammlung weiter");
	{
		void* p = UTE69_Neu();		// EIN Objekt fuer alles, wie in Eudora

		// Erster Lauf, geklammert, mit zwei Faellen.
		UTE69_LaufBeginn(p);
		TT_CHECK(UTE69_Melden(p));
		UTE69_Melden(p);
		TT_CHECK_MSG(UTE69_LaufEnde(p) == 1, "Erster Lauf: ein Sammeleintrag");

		// Danach ein Fall OHNE Klammer - er muss gemeldet werden.
		TT_CHECK_MSG(UTE69_Melden(p),
			"Nach dem Lauf muss der naechste Fall wieder einen Eintrag bekommen");

		// Und ein zweiter geklammerter Lauf faengt sauber an.
		UTE69_LaufBeginn(p);
		TT_CHECK_MSG(UTE69_Melden(p), "Zweiter Lauf: erster Fall wieder voll gemeldet");
		TT_CHECK(UTE69_LaufEnde(p) == 0);

		UTE69_Frei(p);
	}
	TT_EndTest();

	// ------------------------------------------------------------ (11)
	// Die Zahl im Sammeleintrag darf sich nicht ueber Laeufe hinweg
	// aufaddieren - sonst stuende nach dem dritten Lauf eine Zahl da, die
	// Faelle aus den ersten beiden mitzaehlt.
	TT_BeginTest("E-69 A / R1: die Zahl im Sammeleintrag addiert sich nicht auf");
	{
		void* p = UTE69_Neu();
		int i, k;

		for (k = 0; k < 3; k++)
		{
			UTE69_LaufBeginn(p);
			for (i = 0; i < 5; i++)
				UTE69_Melden(p);
			int nWeitere = UTE69_LaufEnde(p);
			TT_CHECK_MSG(nWeitere == 4, "Jeder Lauf meldet 4 weitere, nicht 4-9-14");
		}
		UTE69_Frei(p);
	}
	TT_EndTest();
}
