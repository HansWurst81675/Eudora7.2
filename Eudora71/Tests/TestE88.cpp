//
// TestE88.cpp - die Entscheidung "Original oder Editor" vor dem Absenden
//
// Befund E-88. Geprueft wird E88OriginalEinsetzen aus msgutils.cpp, ueber
// UnderTestE88.cpp aus dem Produktivcode geschnitten.
//
// Jeder Test faehrt den echten Fehler UND den erlaubten Fall: es genuegt
// nicht zu zeigen, dass das Original eingesetzt WIRD - es muss auch
// unterbleiben, sobald der Anwender im Zitat etwas geaendert hat. Eine
// Pruefung, die nur in eine Richtung misst, geht stumm durch.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE88.h"

//
// Ein Original, wie QuoteText es baut: vollstaendiges <x-html>, darin ein
// Kasten ueber CSS - genau das, was Paige nicht kennt.
//
static const char* const kOriginal =
	"<x-html><html><body>"
	"<div style=\"background-color:#f0f0f0;border:1px solid #ccc;padding:12px\">"
	"<img src=\"cid:logo\" style=\"width:320px;height:80px\">"
	"<p>Guten Tag, hier ist der Rundbrief vom Mittwoch.</p>"
	"<p>Mit freundlichen Gruessen, die Redaktion</p>"
	"</div></body></html></x-html>";

//
// Dieselbe Nachricht, nachdem Paige sie gelesen und wieder ausgegeben hat:
// die style-Angaben sind fort, die Absaetze sind geblieben. So kommt sie
// heute beim Empfaenger an.
//
static const char* const kEditorUnveraendert =
	"<x-html><html><body>"
	"<div><img src=\"cid:logo\">"
	"<p>Guten Tag, hier ist der Rundbrief vom Mittwoch.</p>"
	"<p>Mit freundlichen Gruessen, die Redaktion</p>"
	"</div></body></html></x-html>";

static bool EnthaeltStil(const CString& s)
{
	return s.Find("background-color") >= 0;
}

void RunE88Tests(void)
{
	CString		szNeu, szSpur;
	bool		bErsetzt;

	TT_Suite("Befund E-88 - Original-HTML statt Editor-Fassung");

	// ------------------------------------------------------------------
	TT_BeginTest("E-88: unveraendert weitergeleitet - das Original geht hinaus");
	UTE88_SetSchalter(1);
	bErsetzt = UTE88_OriginalEinsetzen(kOriginal, kEditorUnveraendert, 4, true,
									   szNeu, szSpur);
	TT_CHECK(bErsetzt);
	TT_CHECK(EnthaeltStil(szNeu));
	TT_CHECK(szSpur.Find("Fassung=ORIGINAL") >= 0);
	TT_Note("%s", (LPCTSTR) szSpur);
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-88: ein Satz davor - Original bleibt, Zusatz kommt mit");
	{
		CString		szMitZusatz;
		szMitZusatz = "<x-html><html><body><p>Schau dir das mal an, Gregor.</p>";
		szMitZusatz += (kEditorUnveraendert + strlen("<x-html><html><body>"));

		UTE88_SetSchalter(1);
		bErsetzt = UTE88_OriginalEinsetzen(kOriginal, (LPCTSTR) szMitZusatz, 4, true,
										   szNeu, szSpur);
		TT_CHECK(bErsetzt);
		TT_CHECK(EnthaeltStil(szNeu));
		TT_CHECK(szNeu.Find("Schau dir das mal an") >= 0);
		// Der Zusatz muss VOR dem Zitat stehen, sonst liest es sich verkehrt.
		TT_CHECK(szNeu.Find("Schau dir das mal an") < szNeu.Find("Guten Tag"));
		TT_CHECK(szSpur.Find("ZusatzVor=0 ") < 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-88: eine Signatur dahinter - Original bleibt, Signatur kommt mit");
	{
		CString		szMitSig(kEditorUnveraendert);
		szMitSig.Replace("</x-html>", "<p>-- <br>Gregor</p></x-html>");

		UTE88_SetSchalter(1);
		bErsetzt = UTE88_OriginalEinsetzen(kOriginal, (LPCTSTR) szMitSig, 4, true,
										   szNeu, szSpur);
		TT_CHECK(bErsetzt);
		TT_CHECK(EnthaeltStil(szNeu));
		TT_CHECK(szNeu.Find("Gregor") >= 0);
		TT_CHECK(szNeu.Find("Guten Tag") < szNeu.Find("Gregor"));
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ---------------- die Gegenprobe: es muss auch UNTERBLEIBEN --------
	TT_BeginTest("E-88 Gegenprobe: im Zitat geaendert - die Editor-Fassung bleibt");
	{
		CString		szGeaendert(kEditorUnveraendert);
		szGeaendert.Replace("Rundbrief vom Mittwoch", "Rundbrief vom Donnerstag");

		UTE88_SetSchalter(1);
		bErsetzt = UTE88_OriginalEinsetzen(kOriginal, (LPCTSTR) szGeaendert, 4, true,
										   szNeu, szSpur);
		TT_CHECK_MSG(!bErsetzt, "Das Original haette NICHT eingesetzt werden duerfen - "
							    "die Aenderung des Anwenders waere verloren");
		TT_CHECK(szSpur.Find("Fassung=EDITOR") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-88 Gegenprobe: mitten im Zitat geloescht - Editor-Fassung bleibt");
	{
		CString		szGekuerzt(kEditorUnveraendert);
		szGekuerzt.Replace("<p>Guten Tag, hier ist der Rundbrief vom Mittwoch.</p>", "");

		UTE88_SetSchalter(1);
		bErsetzt = UTE88_OriginalEinsetzen(kOriginal, (LPCTSTR) szGekuerzt, 4, true,
										   szNeu, szSpur);
		TT_CHECK_MSG(!bErsetzt, "Geloeschtes waere wieder aufgetaucht");
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-88 Gegenprobe: ForwardOriginalHTML=0 schaltet wirklich ab");
	UTE88_SetSchalter(0);
	bErsetzt = UTE88_OriginalEinsetzen(kOriginal, kEditorUnveraendert, 4, true,
									   szNeu, szSpur);
	TT_CHECK_MSG(!bErsetzt, "Mit 0 muss das Verhalten von 7.2.0.55 gelten");
	TT_CHECK(szSpur.Find("Schalter aus") >= 0);
	TT_Note("%s", (LPCTSTR) szSpur);
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-88 Gegenprobe: kein Original gemerkt - Editor-Fassung bleibt");
	UTE88_SetSchalter(1);
	bErsetzt = UTE88_OriginalEinsetzen("", kEditorUnveraendert, 4, true, szNeu, szSpur);
	TT_CHECK(!bErsetzt);
	TT_CHECK(szSpur.Find("kein Original gemerkt") >= 0);
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-88 Gegenprobe: ein reiner Textrumpf wird nicht angefasst");
	UTE88_SetSchalter(1);
	bErsetzt = UTE88_OriginalEinsetzen(
		"Guten Tag, hier ist der Rundbrief vom Mittwoch. Mit freundlichen Gruessen",
		"Guten Tag, hier ist der Rundbrief vom Mittwoch. Mit freundlichen Gruessen",
		4, true, szNeu, szSpur);
	TT_CHECK_MSG(!bErsetzt, "Ohne HTML gibt es nichts zu retten");
	TT_CHECK(szSpur.Find("kein HTML") >= 0);
	TT_EndTest();

	// ------------------------------------------------------------------
	// Der Grund, warum der Vergleich auf Klartext laeuft und nicht auf den
	// Bytes: Paige schreibt Umlaute mal als Zeichen, mal als Entitaet, und
	// es bricht Zeilen anders um. Beides darf die Entscheidung nicht kippen.
	TT_BeginTest("E-88: andere Umbrueche und Entitaeten kippen die Entscheidung nicht");
	{
		CString		szAnders(kEditorUnveraendert);
		szAnders.Replace("Guten Tag, hier", "Guten\r\n   Tag,\thier");
		szAnders.Replace("Gruessen", "Gr&uuml;ssen");

		CString		szOrigUml(kOriginal);
		szOrigUml.Replace("Gruessen", "Gr\xfcssen");		// Latin-1 u-Umlaut

		UTE88_SetSchalter(1);
		bErsetzt = UTE88_OriginalEinsetzen((LPCTSTR) szOrigUml, (LPCTSTR) szAnders,
										   4, true, szNeu, szSpur);
		TT_CHECK_MSG(bErsetzt, "Ein anderer Zeilenumbruch ist keine Aenderung "
							   "des Anwenders");
		TT_CHECK(EnthaeltStil(szNeu));
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	// Die Spurmarke ist die einzige Sicherung des ganzen Umbaus. Sie muss
	// in JEDEM Fall geschrieben werden, auch wenn nichts ersetzt wurde.
	TT_BeginTest("E-88: die Spurmarke wird in jedem Fall geschrieben");
	{
		const char* const	rgFaelle[4] = { kOriginal, "", kOriginal, "" };
		const char* const	rgEditor[4] = { kEditorUnveraendert, kEditorUnveraendert,
											"", "" };
		int					i;

		for (i = 0; i < 4; ++i)
		{
			szSpur.Empty();
			UTE88_SetSchalter(i < 2 ? 1 : 0);
			UTE88_OriginalEinsetzen(rgFaelle[i], rgEditor[i], 4, true, szNeu, szSpur);

			TT_CHECK_MSG(szSpur.Find("E-88 vor dem Absenden") == 0,
						 "Ohne Spurmarke merkte niemand, was hinausgeht");
			TT_CHECK(szSpur.Find("Fassung=") > 0);
			TT_CHECK(szSpur.Find("OrigBytes=") > 0);
			TT_CHECK(szSpur.Find("EditorBytes=") > 0);
			TT_CHECK(szSpur.Find("Typ=") > 0);
		}
	}
	TT_EndTest();

	//
	// E-93: hat der Anwender nichts getippt, geht das Original hinaus - auch
	// wenn der Textvergleich scheitert.
	//
	// Gemessen an Gregors Lauf mit 1.0.58, beim Weiterleiten einer bereits
	// weitergeleiteten Nachricht:
	//
	//   Fassung=EDITOR (Anwender hat im Zitat geaendert)
	//   OrigBytes=105125 EditorBytes=17889 Fundstelle=-1
	//
	// Er hatte nichts geaendert. Hinaus gingen 17889 statt 105125 Byte.
	//
	TT_BeginTest("E-93: ohne Tastendruck geht das Original hinaus, auch ohne Fund");
	{
		// Eine Editorfassung, in der der Klartext des Originals NICHT als
		// ein Stueck steckt - so wie Paige sie bei verschachtelten Zitaten
		// liefert.
		const char* const	kEditorUmgebaut =
			"<x-html><html><body>Ganz anderer Text, der mit dem Original nichts "
			"gemein hat und lang genug ist, um den Vergleich scheitern zu lassen."
			"</body></html></x-html>";

		szSpur.Empty();
		UTE88_SetSchalter(1);
		bErsetzt = UTE88_OriginalEinsetzen(kOriginal, kEditorUmgebaut, 4,
										   false, szNeu, szSpur);

		TT_CHECK_MSG(bErsetzt,
					 "ohne Tastendruck darf die magere Editorfassung nicht hinausgehen");
		TT_CHECK(szSpur.Find("Fassung=ORIGINAL") >= 0);
		TT_CHECK(szSpur.Find("getippt=0") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();

	//
	// Die Gegenprobe, und sie ist die wichtigere: hat der Anwender getippt,
	// bleibt es bei der Editorfassung. Sonst verschluckt die neue Regel
	// genau das, was er geschrieben hat.
	//
	TT_BeginTest("E-93 Gegenprobe: MIT Tastendruck bleibt die Editorfassung");
	{
		const char* const	kEditorUmgebaut =
			"<x-html><html><body>Ganz anderer Text, der mit dem Original nichts "
			"gemein hat und lang genug ist, um den Vergleich scheitern zu lassen."
			"</body></html></x-html>";

		szSpur.Empty();
		UTE88_SetSchalter(1);
		bErsetzt = UTE88_OriginalEinsetzen(kOriginal, kEditorUmgebaut, 4,
										   true, szNeu, szSpur);

		TT_CHECK_MSG(!bErsetzt,
					 "was der Anwender geschrieben hat, darf nicht verschwinden");
		TT_CHECK(szSpur.Find("Fassung=EDITOR") >= 0);
		TT_CHECK(szSpur.Find("getippt=1") >= 0);
		TT_Note("%s", (LPCTSTR) szSpur);
	}
	TT_EndTest();
}
