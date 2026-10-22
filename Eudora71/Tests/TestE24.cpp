//
// TestE24.cpp - Befund E-24: unter "Recent" stand "In" zweimal
//
// Gregor am 05.09.2026 zur Fassung 7.2.0.10: "2x in unter recent". Im
// Postfachbaum links stand unter dem Ordner "Recent" der Eintrag "In"
// zweimal, beide mit demselben Symbol - gleich nach dem ersten Start mit
// einem frischen Mailverzeichnis. Seine Eudora.ini hatte gar keinen
// Abschnitt [Recent Mailboxes]; der Doppeleintrag entstand allein aus dem
// Programmablauf.
//
// DER ALTE STAND, Schritt fuer Schritt (Befunde/POSTFACH.md):
//
//   1. BuildRecentMailboxesList findet [Recent Mailboxes] leer und legt
//      einen Ersatzeintrag "In.mbx" ab - als Zeiger in eine TEMPORAERE
//      CString, die am Ende der Anweisung weg ist.
//   2. Eudora oeffnet "In". UpdateRecentMailboxList bekommt denselben Namen,
//      aber aus einem ANDEREN Puffer.
//   3. Verglichen wurde ueber den ZEIGER: "steht schon drin" ergab nein,
//      std::list::remove entfernte nichts, push_front legte nach.
//   4. Zwei Eintraege in der Liste, zwei "In" im Baum.
//
// DIE GEGENPROBE, die jeder Testfall hier faehrt: die beiden verglichenen
// Zeichenketten liegen IMMER in verschiedenen Puffern. Ein Zeigervergleich
// liefert bei jedem einzelnen Fall unten "ungleich" - der alte Stand faellt
// also an allen um.
//
// Geprueft wird die Listenarbeit allein. Der Baum selbst braucht ein
// Fenster und steht im Testplan.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <string.h>
#include <list>

#include "TinyTest.h"
#include "UnderTestE24.h"
#include "Quelltext.h"

// Die Namen, die Eudora wirklich benutzt: IDS_IN_MBOX_FILENAME +
// IDS_MAILBOX_EXTENSION ergibt "In.mbx".
static char	s_szErsatz[]	= "In.mbx";		// aus BuildRecentMailboxesList
static char	s_szGeoeffnet[]	= "In.mbx";		// aus CTocView::OnInitialUpdate
static char	s_szGross[]		= "IN.MBX";		// dieselbe Datei, andere Schreibweise
static char	s_szOut[]		= "Out.mbx";
static char	s_szIn2[]		= "In2.mbx";
static char	s_szTrash[]		= "Trash.mbx";

// Vergleicht den Inhalt der Liste Eintrag fuer Eintrag mit einer Erwartung.
static void PruefeListe(const char* szWas, const std::list<LPCTSTR>& theList,
						const char* const* paszSoll, int iSoll)
{
	int											i = 0;
	std::list<LPCTSTR>::const_iterator			it;

	if ((int)theList.size() != iSoll)
	{
		TT_Fail("%s: Liste hat %d Eintraege, erwartet %d", szWas, (int)theList.size(), iSoll);
		for (it = theList.begin(); it != theList.end(); ++it)
			TT_Note("  drin: \"%s\"", *it ? *it : "(0)");
		return;
	}

	for (it = theList.begin(); it != theList.end(); ++it, ++i)
	{
		const char* pIst = *it;
		if (!pIst || strcmp(pIst, paszSoll[i]) != 0)
		{
			TT_Fail("%s: Eintrag %d ist \"%s\", erwartet \"%s\"",
					szWas, i, pIst ? pIst : "(0)", paszSoll[i]);
		}
	}
}

//
// Test_E24_DieStellen - benutzt QCMailboxDirector.cpp die Funktionen auch?
//
// NACHGEZOGEN AM 22.10.2026 (PRUEFER, Fund 1). Bis dahin prueften alle
// sieben E-24-Faelle nur die drei geschnittenen Funktionen. Niemand prueft,
// ob QCMailboxDirector.cpp sie BENUTZT - als einziger der acht neuen
// Befunde hatte E-24 keinen Aufrufstellen-Test.
//
// PRUEFER hat gemessen, was das heisst: beide Aufrufstellen auf den alten
// Stand zurueckgedreht (RecentListRemove -> s_RecentMailboxList.remove,
// RecentListContains -> std::find), die Funktionen stehen gelassen. Der
// Extrakt blieb byte-identisch, und die Sammlung meldete 274 Tests, 274
// bestanden. Der Befund waere vollstaendig zurueck gewesen - zwei "In" im
// Postfachbaum - und der Pruefstand haette gruen gemeldet.
// (Arbeitsweise/extrakt-ist-nicht-das-programm.md)
//
static void Test_E24_DieStellen(const char* szEudoraDir)
{
	char*	pCode = QT_LiesNurCode(szEudoraDir, "QCMailboxDirector.cpp");

	TT_BeginTest("E-24: QCMailboxDirector.cpp benutzt die Vergleichsfunktionen");

	if (!pCode)
	{
		TT_Fail("QCMailboxDirector.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	TT_CHECK_MSG(QT_Enthaelt(pCode, "RecentListContains(s_RecentMailboxList"),
				 "die Abfrage \"steht schon drin\" muss ueber RecentListContains gehen");
	TT_CHECK_MSG(QT_Enthaelt(pCode, "RecentListRemove(s_RecentMailboxList"),
				 "das Entfernen muss ueber RecentListRemove gehen");

	// Die Gegenrichtung: der alte Stand darf nicht zurueckkommen. Beides
	// vergleicht ueber den ZEIGER und ist die Ursache des Befunds.
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "s_RecentMailboxList.remove("),
				 "std::list::remove vergleicht ueber den Zeiger - darf nicht zurueckkommen");
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "std::find(s_RecentMailboxList"),
				 "std::find vergleicht ueber den Zeiger - darf nicht zurueckkommen");

	free(pCode);
	TT_EndTest();
}

void RunE24Tests(const char* szEudoraDir)
{
	TT_Suite("E-24: unter \"Recent\" stand \"In\" zweimal");

	// ------------------------------------------------------------- (1)
	// Der Kern des Befunds: zwei Puffer, derselbe Inhalt. Genau das konnte
	// der alte Zeigervergleich nicht.
	TT_BeginTest("E-24: gleicher Inhalt in verschiedenen Puffern gilt als gleich");
	{
		// Ohne diese Zusicherung prueft der Test nichts: lieferte der
		// Uebersetzer hier denselben Puffer, waere auch ein Zeigervergleich
		// zufrieden und die Gegenprobe waere keine.
		TT_CHECK_MSG(s_szErsatz != s_szGeoeffnet, "die beiden Puffer muessen verschieden sein");

		TT_CHECK(UT_RecentPathsEqual(s_szErsatz, s_szGeoeffnet));
		TT_CHECK(UT_RecentPathsEqual(s_szErsatz, s_szGross));		// Windows unterscheidet nicht
		TT_CHECK(UT_RecentPathsEqual(s_szErsatz, s_szErsatz));		// derselbe Zeiger bleibt gleich
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	// Gegenprobe in die andere Richtung: verschiedene Postfaecher duerfen
	// NICHT zusammenfallen. Sonst verschwaende aus "Recent" ein Eintrag,
	// den der Anwender gerade benutzt hat.
	TT_BeginTest("E-24 Gegenprobe: verschiedene Postfaecher bleiben verschieden");
	{
		TT_CHECK(!UT_RecentPathsEqual(s_szErsatz, s_szOut));
		TT_CHECK(!UT_RecentPathsEqual(s_szErsatz, s_szIn2));	// kein Praefixvergleich
		TT_CHECK(!UT_RecentPathsEqual(s_szIn2, s_szErsatz));
		TT_CHECK(!UT_RecentPathsEqual(s_szErsatz, ""));
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	// Die Raender. Ein haengender Zeiger war der Ausloeser; ein Nullzeiger
	// darf den Vergleich nicht umwerfen.
	TT_BeginTest("E-24: Nullzeiger werfen den Vergleich nicht um");
	{
		TT_CHECK(!UT_RecentPathsEqual(0, s_szErsatz));
		TT_CHECK(!UT_RecentPathsEqual(s_szErsatz, 0));
		TT_CHECK(UT_RecentPathsEqual(0, 0));	// derselbe Zeiger
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	// Schritt 3 des Ablaufs: "steht schon drin?"
	TT_BeginTest("E-24: der Ersatzeintrag wird als derselbe erkannt");
	{
		std::list<LPCTSTR>	theList;

		theList.push_front(s_szErsatz);

		TT_CHECK_MSG(UT_RecentListContains(theList, s_szGeoeffnet),
					 "In.mbx aus einem anderen Puffer muss gefunden werden");
		TT_CHECK_MSG(UT_RecentListContains(theList, s_szGross),
					 "IN.MBX ist dasselbe Postfach");
		TT_CHECK_MSG(!UT_RecentListContains(theList, s_szOut),
					 "Out.mbx steht nicht drin");

		std::list<LPCTSTR>	leer;
		TT_CHECK(!UT_RecentListContains(leer, s_szErsatz));
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	// DER GEMELDETE FALL, Schritt fuer Schritt nachgefahren. Vor E-24 stand
	// die Liste danach auf ZWEI Eintraegen, und der Baum zeigte "In" zweimal.
	TT_BeginTest("E-24: frisches Mailverzeichnis - \"In\" steht danach genau einmal");
	{
		std::list<LPCTSTR>	theList;
		const char*			aszSoll[1];
		size_t				nWeg;

		// Schritt 1+2: [Recent Mailboxes] ist leer, der Ersatzeintrag kommt.
		theList.push_front(s_szErsatz);

		// Schritt 3: Eudora oeffnet "In", UpdateRecentMailboxList raeumt
		// vorher auf. Hier entfernte std::list::remove nichts.
		nWeg = UT_RecentListRemove(theList, s_szGeoeffnet);
		TT_CHECK_MSG(nWeg == 1, "der Ersatzeintrag muss entfernt werden");
		TT_CHECK_MSG(theList.empty(), "danach ist die Liste leer");

		// Schritt 4: und erst jetzt wird vorn angehaengt.
		theList.push_front(s_szGeoeffnet);

		aszSoll[0] = "In.mbx";
		PruefeListe("nach dem Oeffnen von In", theList, aszSoll, 1);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (6)
	// Punkt 3 der Behebung: eine bereits doppelte Ini heilt beim naechsten
	// Start von selbst. Also muessen ALLE gleichen Eintraege weg, nicht nur
	// der erste.
	TT_BeginTest("E-24: eine schon doppelte Liste wird vollstaendig geheilt");
	{
		std::list<LPCTSTR>	theList;
		const char*			aszSoll[2];
		size_t				nWeg;

		theList.push_back(s_szErsatz);		// "In.mbx"
		theList.push_back(s_szOut);			// "Out.mbx"
		theList.push_back(s_szGross);		// "IN.MBX" - derselbe wie der erste
		theList.push_back(s_szTrash);		// "Trash.mbx"

		nWeg = UT_RecentListRemove(theList, s_szGeoeffnet);
		TT_CHECK_MSG(nWeg == 2, "beide Schreibweisen von In muessen weg");

		aszSoll[0] = "Out.mbx";
		aszSoll[1] = "Trash.mbx";
		PruefeListe("nach dem Heilen", theList, aszSoll, 2);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (7)
	// Gegenprobe in die andere Richtung, und die ist hier die wichtigere:
	// ein Inhaltsvergleich, der zu viel trifft, raeumt die Liste leer.
	// Entfernt werden darf NUR das genannte Postfach, die Reihenfolge der
	// uebrigen bleibt.
	TT_BeginTest("E-24 Gegenprobe: ein fremdes Postfach laesst die Liste unberuehrt");
	{
		std::list<LPCTSTR>	theList;
		const char*			aszSoll[3];
		size_t				nWeg;

		theList.push_back(s_szErsatz);		// "In.mbx"
		theList.push_back(s_szOut);			// "Out.mbx"
		theList.push_back(s_szTrash);		// "Trash.mbx"

		nWeg = UT_RecentListRemove(theList, s_szIn2);
		TT_CHECK_MSG(nWeg == 0, "In2.mbx steht nicht drin, also faellt nichts weg");

		aszSoll[0] = "In.mbx";
		aszSoll[1] = "Out.mbx";
		aszSoll[2] = "Trash.mbx";
		PruefeListe("nach dem Fehlgriff", theList, aszSoll, 3);

		// Und einer aus der Mitte: nur dieser eine geht, die Reihenfolge
		// der beiden anderen bleibt stehen.
		nWeg = UT_RecentListRemove(theList, s_szOut);
		TT_CHECK(nWeg == 1);
		aszSoll[0] = "In.mbx";
		aszSoll[1] = "Trash.mbx";
		PruefeListe("nach dem Entfernen aus der Mitte", theList, aszSoll, 2);
	}
	TT_EndTest();

	// Die Aufrufstellen - siehe oben, PRUEFER Fund 1.
	Test_E24_DieStellen(szEudoraDir);
}
