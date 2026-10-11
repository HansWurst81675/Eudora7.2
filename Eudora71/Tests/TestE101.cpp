//
// TestE101.cpp - was "Speichern unter" in die Datei schreibt
//
// Befund E-101. Geprueft wird E101SpeicherfassungAufbereiten aus
// msgutils.cpp, ueber UnderTestE101.cpp aus dem Produktivcode geschnitten.
//
// Der Anlass: Gregor hat am 17.09.2026 eine weitergeleitete Nachricht
// gesichert und die Datei geoeffnet. Darin standen vier Kopfzeilen, danach
// Eudoras interner Marker <x-html> und roher HTML-Text. Keine
// Content-Type-Zeile, kein Zeichensatz. Sein Urteil: "datei gespeichert,
// aber unbrauchbar".
//
// Jeder Test faehrt beide Richtungen: es genuegt nicht zu zeigen, dass die
// Kopfzeilen ERGAENZT werden - sie duerfen auch nicht ergaenzt werden,
// wenn die Nachricht schon eine Content-Type-Zeile mitbringt. Eine Pruefung,
// die nur in eine Richtung misst, geht stumm durch
// (Arbeitsweise/gegenprobe-umdrehen.md).
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE101.h"

//
// Eine selbst verfasste Nachricht, so wie sie in Out.mbx liegt. Nachgebaut
// nach Gregors Datei "Fw Ihr Doctolib Verifizierungscode.eml" (5716 Byte):
// vier Kopfzeilen, Leerzeile, <x-html>, HTML. Das \xFC ist das Byte, das
// dort im Wort "gueltig" steht - gemessen, nicht angenommen.
//
static const char* const kSelbstVerfasst =
	"From: gregor.czempik@web.de\r\n"
	"To: markus.bakus@gmx.de\r\n"
	"Subject: Fw: Ihr Doctolib Verifizierungscode\r\n"
	"Date: Mon, 14 Sep 2026 10:52:45 +0000\r\n"
	"\r\n"
	"<x-html>\r\n"
	"<html><body><p>Dieser Code ist nur 10 Minuten g\xFCltig.</p></body></html>\r\n"
	"</x-html>\r\n";

//
// Eine empfangene Nachricht: sie bringt ihre echten Kopfzeilen aus dem
// Postfach mit. Daran darf nichts geaendert werden.
//
static const char* const kEmpfangen =
	"From: no-reply@doctolib.de\r\n"
	"To: gregor.czempik@web.de\r\n"
	"Subject: Ihr Doctolib Verifizierungscode\r\n"
	"MIME-Version: 1.0\r\n"
	"Content-Type: text/html; charset=UTF-8\r\n"
	"\r\n"
	"<html><body><p>Verifizierungscode</p></body></html>\r\n";

//
// Reiner Text ohne Marker und ohne Hochbyte - us-ascii.
//
static const char* const kNurText =
	"From: a@example.invalid\r\n"
	"To: b@example.invalid\r\n"
	"Subject: ohne alles\r\n"
	"\r\n"
	"Guten Tag.\r\n";

//
// Der Stolperstein: im Rumpf einer weitergeleiteten Nachricht steht das
// Wort "Content-Type:" als ZITIERTER Kopf der urspruenglichen Nachricht.
// Wer ohne Zeilenanker im Kopfbereich sucht, findet den und ergaenzt
// nichts - die Datei bliebe unbrauchbar.
//
static const char* const kZitatImRumpf =
	"From: gregor@example.invalid\r\n"
	"To: markus@example.invalid\r\n"
	"Subject: Fw: Rundbrief\r\n"
	"\r\n"
	"<x-html>\r\n"
	"<html><body><pre>\r\n"
	"Content-Type: text/html; charset=UTF-8\r\n"
	"</pre></body></html>\r\n"
	"</x-html>\r\n";

static bool Hat(const CString& s, const char* p)
{
	return s.Find(p) >= 0;
}

//
// ---------------------------------------------------------------------
// Der Pruefsatz zu PRUEFER P-28: "ist jedes Byte der Eingabe, das nicht
// zum Tag gehoert, noch da?"
//
// Der Satz "enthaelt die Ausgabe X" - also Hat() - laesst genau den
// Schnitt durch, der bei P-28 den ganzen Rumpf gekostet hat. Die drei
// neuen Kopfzeilen kamen dazu, die Datei wurde GROESSER, jede Pruefung
// auf "MIME-Version" oder "Content-Type" blieb gruen - und der Rumpf war
// weg. Wer nur fragt, ob etwas DA ist, erfaehrt nie, was FEHLT.
//
// Gemessen wird deshalb Rumpf gegen Rumpf, byteweise. Aus dem Rumpf der
// EINGABE werden genau die Tags herausgeschnitten, die der Aufrufer
// nennt; dazu die Zeilenschaltung dahinter, aber nur dann, wenn hinter
// dem Tag nichts als Leerraum auf der Zeile stand. Was uebrig bleibt,
// MUSS Byte fuer Byte der Rumpf der Ausgabe sein - nicht "darin
// enthalten", sondern gleich. Eine andere Laenge ist ebenfalls eine
// Abweichung, sonst ginge ein abgeschnittener Rumpf als "der Anfang
// stimmt ja" durch.
// ---------------------------------------------------------------------
//

static CString RumpfVon(const CString& szDatei)
{
	const int	nTrenner = szDatei.Find("\r\n\r\n");

	return ( nTrenner < 0 ) ? CString("") : szDatei.Mid( nTrenner + 4 );
}

static CString OhneTags(const CString& szRumpf, const char* const* ppszTags,
						int nTags)
{
	CString		szRest = szRumpf;

	for ( int i = 0; i < nTags; i++ )
	{
		const int	nAb = szRest.Find( ppszTags[i] );

		if ( nAb < 0 )
			continue;

		int			nNach = nAb + (int) strlen( ppszTags[i] );
		int			nLeer = nNach;

		while ( nLeer < szRest.GetLength() &&
				( szRest[nLeer] == ' ' || szRest[nLeer] == '\t' ) )
			nLeer++;

		if ( nLeer >= szRest.GetLength() ||
			 szRest[nLeer] == '\r' || szRest[nLeer] == '\n' )
		{
			nNach = nLeer;

			if ( nNach < szRest.GetLength() && szRest[nNach] == '\r' )
				nNach++;
			if ( nNach < szRest.GetLength() && szRest[nNach] == '\n' )
				nNach++;
		}

		szRest = szRest.Left( nAb ) + szRest.Mid( nNach );
	}

	return szRest;
}

static void PruefeJedesByte(const char* pszEingabe, const CString& szAusgabe,
							const char* const* ppszTags, int nTags)
{
	const CString	szSoll = OhneTags( RumpfVon( CString( pszEingabe ) ),
									   ppszTags, nTags );
	const CString	szIst  = RumpfVon( szAusgabe );

	//
	// Die andere Haelfte des Satzes: das Tag selbst MUSS weg sein. Ohne
	// diese Frage wuerde eine Fassung bestehen, die gar nichts schneidet.
	//
	for ( int t = 0; t < nTags; t++ )
	{
		if ( szAusgabe.Find( ppszTags[t] ) >= 0 )
			TT_Fail("das Tag \"%s\" steht noch in der Datei", ppszTags[t]);
	}

	const int	nKurz = ( szSoll.GetLength() < szIst.GetLength() )
						  ? szSoll.GetLength() : szIst.GetLength();

	for ( int i = 0; i < nKurz; i++ )
	{
		if ( szSoll[i] != szIst[i] )
		{
			TT_Fail("DATENVERLUST: der Rumpf weicht ab Byte %d ab - "
					"soll 0x%02X, ist 0x%02X   (soll %d Byte, ist %d Byte)",
					i, (unsigned char) szSoll[i], (unsigned char) szIst[i],
					szSoll.GetLength(), szIst.GetLength());
			return;
		}
	}

	if ( szSoll.GetLength() != szIst.GetLength() )
		TT_Fail("DATENVERLUST: der Rumpf soll %d Byte haben, hat aber %d - "
				"ab Byte %d %s",
				szSoll.GetLength(), szIst.GetLength(), nKurz,
				( szIst.GetLength() < szSoll.GetLength() )
					? "fehlt alles Weitere" : "steht Ueberschuss");
}

//
// PRUEFER P-38: die Spurmarke muss den Schnitt am Rumpf zeigen koennen.
// Die Gesamtlaengen reichen dafuer nicht - sie WACHSEN durch die drei
// neuen Kopfzeilen auch dann, wenn der Rumpf ganz verschwindet. Bei P-28
// stand "bytes-vorher=104 nachher=128 geaendert=1" im Protokoll, und der
// Rumpf war null Byte lang.
//
// Geprueft werden die beiden Werte gegen die Bytes, nicht auf blosses
// Vorhandensein: rumpf-vorher gegen den Rumpf der Eingabe, rumpf-nachher
// gegen den der Ausgabe. Damit misst dieser Satz zugleich nach, dass die
// Funktion den Rumpf an derselben Stelle beginnen laesst wie der Leser.
//
static void PruefeRumpfMass(const CString& szSpur, const char* pszEingabe,
							const CString& szAusgabe)
{
	CString		szErwartet;

	szErwartet.Format("rumpf-vorher=%d rumpf-nachher=%d",
					  RumpfVon( CString( pszEingabe ) ).GetLength(),
					  RumpfVon( szAusgabe ).GetLength());

	if ( szSpur.Find( szErwartet ) < 0 )
		TT_Fail("die Spurmarke muss \"%s\" nennen - sie sagt: %s",
				(const char*) szErwartet, (const char*) szSpur);
}

void RunE101Tests(void)
{
	CString		szDatei, szSpur;
	bool		bGeaendert;

	TT_Suite("Befund E-101 - was Speichern unter in die Datei schreibt");

	// ------------------------------------------------------------------
	TT_BeginTest("E-101: selbst verfasst - Content-Type wird ergaenzt");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(kSelbstVerfasst, true,
												   szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(bGeaendert, "die Fassung muss umgeschrieben werden");
	TT_CHECK_MSG(Hat(szDatei, "MIME-Version: 1.0"),
			 "MIME-Version fehlt");
	TT_CHECK_MSG(Hat(szDatei, "Content-Type: text/html"),
			 "Content-Type: text/html fehlt");
	TT_CHECK_MSG(Hat(szDatei, "charset=\"ISO-8859-1\""),
			 "der Zeichensatz muss aus dem Hochbyte 0xFC folgen");
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101: der interne Marker <x-html> verlaesst das Haus nicht");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(kSelbstVerfasst, true,
												   szDatei, szSpur);
	TT_CHECK_MSG(bGeaendert, "die Fassung muss umgeschrieben werden");
	TT_CHECK_MSG(!Hat(szDatei, "<x-html"),
			 "der oeffnende Marker steht noch in der Datei");
	TT_CHECK_MSG(!Hat(szDatei, "</x-html>"),
			 "der schliessende Marker steht noch in der Datei");
	TT_CHECK_MSG(Hat(szDatei, "<html><body>"),
			 "der Rumpf selbst muss erhalten bleiben");
	TT_CHECK_MSG(Hat(szDatei, "g\xFCltig"),
			 "die Umlaut-Bytes muessen unveraendert durchgehen");

	//
	// Gegenprobe zum Pruefsatz selbst (Arbeitsweise/schranke-gegentesten.md):
	// er muss den Normalfall - Marker auf eigener Zeile - unbeanstandet
	// durchlassen. Eine Schranke, die immer anschlaegt, ist so wertlos wie
	// eine, die nie anschlaegt.
	//
	{
		const char* const	kTags[] = { "<x-html>", "</x-html>" };

		PruefeJedesByte(kSelbstVerfasst, szDatei, kTags, 2);
		PruefeRumpfMass(szSpur, kSelbstVerfasst, szDatei);
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	// Die Gegenprobe: dieselbe Funktion darf an einer empfangenen
	// Nachricht NICHTS aendern. Ohne diesen Test wuerde eine Fassung
	// durchgehen, die jeder Nachricht ihre Kopfzeilen ueberschreibt.
	TT_BeginTest("E-101 Gegenprobe: vorhandener Content-Type bleibt unangetastet");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(kEmpfangen, true,
												   szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(!bGeaendert, "an einer empfangenen Nachricht ist nichts zu tun");
	TT_CHECK_MSG(Hat(szSpur, "content-type-vorhanden=1"),
			 "die Spurmarke muss den Grund nennen");
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101: ohne Marker und ohne Hochbyte - text/plain, us-ascii");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(kNurText, true,
												   szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(bGeaendert, "auch hier fehlt der Content-Type");
	TT_CHECK_MSG(Hat(szDatei, "Content-Type: text/plain"),
			 "ohne <x-html> ist es text/plain");
	TT_CHECK_MSG(Hat(szDatei, "charset=\"us-ascii\""),
			 "ohne Hochbyte ist es us-ascii");
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101: zitiertes Content-Type im Rumpf taeuscht nicht");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(kZitatImRumpf, true,
												   szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(bGeaendert, "der Kopf hat keinen Content-Type, nur der Rumpf");
	TT_CHECK_MSG(Hat(szSpur, "content-type-vorhanden=0"),
			 "das Zitat im Rumpf darf nicht als Kopfzeile zaehlen");
	TT_CHECK_MSG(Hat(szDatei, "MIME-Version: 1.0"),
			 "die Kopfzeilen muessen trotzdem ergaenzt werden");
	TT_EndTest();

	// ------------------------------------------------------------------
	// ------------------------------------------------------------------
	// BEFUND E-101, zweiter Teil. Dieser Test hat frueher das Gegenteil verlangt:
	// "ohne Kopfzeilen wird auch keine erfunden". Der Grundsatz stimmt und
	// bleibt - ERFUNDEN wird nichts. Aber er galt auch dort, wo die Datei
	// dadurch unbrauchbar wurde.
	//
	// Gregor hat am 17.09.2026 mit 1.0.69 mehrere Nachrichten gespeichert.
	// Seine Spurmarke:
	//
	//   kopfzeilen=0 trenner=0 content-type-vorhanden=0
	//   bytes-vorher=102006 nachher=101985
	//   rumpf-vorher=102006 rumpf-nachher=101985
	//
	// nachher == rumpf-nachher heisst: NICHTS dazugekommen. Seine Datei
	// trug HTML ohne MIME-Version, ohne Content-Type, ohne Zeichensatz -
	// genau der Zustand, den er als "datei gespeichert, aber unbrauchbar"
	// gemeldet hatte. E-101 war also nur behoben, wenn "Kopfzeilen
	// einschliessen" AN war - und laut E-98 ist das Kaestchen auf
	// Windows 10 gar nicht anwaehlbar.
	// ------------------------------------------------------------------
	TT_BeginTest("E-101 zweiter Teil: ohne Kopfzeilen bekommt HTML trotzdem seinen Content-Type");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(
					"<x-html>\r\n<html><body>Hallo</body></html>\r\n</x-html>\r\n",
					false, szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(bGeaendert, "der Marker muss weg");
	TT_CHECK_MSG(!Hat(szDatei, "x-html"),
			 "kein Marker mehr in der Datei");
	TT_CHECK_MSG(Hat(szDatei, "Content-Type: text/html"),
			 "ohne Content-Type zeigt jeder Leser HTML-Quelltext");
	TT_CHECK_MSG(Hat(szDatei, "MIME-Version: 1.0"),
			 "MIME-Version gehoert dazu");
	TT_CHECK_MSG(Hat(szDatei, "<html><body>Hallo</body></html>"),
			 "der Rumpf selbst bleibt vollstaendig");
	TT_CHECK_MSG(Hat(szSpur, "mime-ergaenzt=1"),
			 "die Spurmarke muss sagen, dass sie ergaenzt hat");
	TT_CHECK_MSG(!Hat(szDatei, "From:"),
			 "die Kopfzeilen der NACHRICHT bleiben draussen - das war die Bitte");
	TT_EndTest();

	// ------------------------------------------------------------------
	// Die Gegenprobe, und sie ist die wichtigere: reiner us-ascii-Text
	// ohne Marker bekommt WEITERHIN NICHTS. Dort ist ohne Angabe nichts
	// misszuverstehen, und wer einen Textausschnitt sichert, will genau
	// die Zeichen und keine Kopfzeilen. Ohne diesen Test waere aus der
	// Behebung ein "jede Datei bekommt jetzt Kopfzeilen" geworden.
	// ------------------------------------------------------------------
	TT_BeginTest("E-101 Gegenprobe zum zweiten Teil: reiner ASCII-Text ohne Kopfzeilen bleibt unberuehrt");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(
					"Guten Tag. Nur Text, keine Umlaute.\r\n",
					false, szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(!Hat(szDatei, "Content-Type"),
			 "hier wird nichts erfunden - es gibt nichts zu erklaeren");
	TT_CHECK_MSG(!Hat(szDatei, "MIME-Version"),
			 "auch keine MIME-Version");
	TT_CHECK_MSG(Hat(szSpur, "mime-ergaenzt=0"),
			 "und die Spurmarke sagt es");
	TT_EndTest();

	// ------------------------------------------------------------------
	// Und der dritte Fall: KEIN HTML, aber ein Hochbyte. Ohne charset
	// wird aus dem 0xFC je nach Leser ein anderes Zeichen.
	// ------------------------------------------------------------------
	TT_BeginTest("E-101 zweiter Teil: Hochbyte ohne Kopfzeilen bekommt seinen Zeichensatz");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(
					"Das ist g\xFCltig.\r\n",
					false, szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(Hat(szDatei, "charset=\"ISO-8859-1\""),
			 "ohne charset wird aus 0xFC Buchstabensalat");
	TT_CHECK_MSG(Hat(szDatei, "Content-Type: text/plain"),
			 "ohne Marker ist es text/plain");
	TT_CHECK_MSG(Hat(szDatei, "g\xFCltig"),
			 "das Byte selbst bleibt unveraendert");
	TT_EndTest();

	// ------------------------------------------------------------------

	// ------------------------------------------------------------------
	// Die Faelle, die der PRUEFER am 17.09.2026 an der uebersetzten
	// Funktion gemessen hat (Befunde/PRUEFER-13.md). Vier davon haben
	// Inhalt verloren. Sie stehen hier, damit kein spaeterer Umbau sie
	// wieder aufmacht.
	// ------------------------------------------------------------------

	TT_BeginTest("E-101 P-18: <x-html mitten im Text ist kein Marker");
	{
		const char* const kMitten =
			"From: a@example.invalid\r\n"
			"Subject: Klartext\r\n"
			"\r\n"
			"Er schrieb <x-html in die Zeile. Du sagtest:\r\n"
			"> stimmt\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kMitten, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		// Der Rumpf muss VOLLSTAENDIG erhalten bleiben. Gemessen wurden
		// vorher 36 von 62 Byte Verlust.
		TT_CHECK_MSG(Hat(szDatei, "Er schrieb <x-html in die Zeile. Du sagtest:"),
					 "die Zeile des Anwenders wurde beschnitten");
		TT_CHECK_MSG(Hat(szDatei, "> stimmt"),
					 "die zitierte Zeile ist verschwunden");
		TT_CHECK_MSG(Hat(szSpur, "xhtml=0"),
					 "das ist kein Marker und darf nicht als einer zaehlen");
		TT_CHECK_MSG(Hat(szDatei, "Content-Type: text/plain"),
					 "eine Klartextnachricht ist nicht text/html");
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101 P-19: zitiertes </x-html> ist nicht das Gegenstueck");
	{
		const char* const kZweiEnden =
			"From: a@example.invalid\r\n"
			"Subject: Weiterleitung\r\n"
			"\r\n"
			"<x-html>\r\n"
			"<html><body>WICHTIGER NACHSATZ </x-html> ende</body></html>\r\n"
			"</x-html>\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kZweiEnden, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		TT_CHECK_MSG(Hat(szDatei, "WICHTIGER NACHSATZ"),
					 "der Nachsatz darf nicht verschwinden");
		TT_CHECK_MSG(Hat(szDatei, "ende"),
					 "der Text hinter dem Zitat darf nicht verschwinden");
		TT_CHECK_MSG(!Hat(szDatei, "\r\n</x-html>"),
					 "das ECHTE Gegenstueck am Ende muss weg sein");
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101 P-18: > im Attributwert laesst keinen Rest stehen");
	{
		const char* const kAttribut =
			"From: a@example.invalid\r\n"
			"\r\n"
			"<x-html content-base=\"http://host/a>b/\">\r\n"
			"<html><body>Inhalt</body></html>\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kAttribut, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		TT_CHECK_MSG(!Hat(szDatei, "b/\">"),
					 "der Rest des Markers steht noch in der Datei");
		TT_CHECK_MSG(Hat(szDatei, "<html><body>Inhalt"),
					 "der Rumpf muss erhalten bleiben");
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101 P-20: fuehrende Leerzeile geht nicht verloren");
	{
		const char* const kLeerVorn = "\r\n\r\nErste Rumpfzeile\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kLeerVorn, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		// 22 Byte rein. Es darf nichts fehlen - vorher kamen 18 heraus.
		const CString szErgebnis = bGeaendert ? szDatei : CString(kLeerVorn);
		TT_CHECK_MSG(szErgebnis.GetLength() >= 22,
					 "es sind Bytes verschwunden");
		TT_CHECK_MSG(Hat(szErgebnis, "Erste Rumpfzeile"),
					 "der Rumpf fehlt");
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101 P-22: ohne Leerzeile meldet die Spurmarke trenner=0");
	{
		const char* const kOhneTrenner =
			"From: a@example.invalid\r\n"
			"Subject: kein Trenner\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kOhneTrenner, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		TT_CHECK_MSG(Hat(szSpur, "trenner=0"),
					 "die Spurmarke muss sagen, dass kein Trenner gefunden wurde");
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101 P-21: gemischter Trenner laesst kein \r im Kopf stehen");
	{
		const char* const kGemischt =
			"From: a@example.invalid\r\n"
			"Subject: gemischter Trenner\r\n"
			"\n"
			"Rumpf\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kGemischt, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		TT_CHECK_MSG(!Hat(szDatei, "\r\r\n"),
					 "ein doppeltes \r steht in der Datei");
		TT_CHECK_MSG(Hat(szDatei, "Rumpf"),
					 "der Rumpf fehlt");
	}
	TT_EndTest();


	// ------------------------------------------------------------------
	// PRUEFER P-28, DATENVERLUST in main: die ganze erste Zeile wurde
	// entfernt, sobald sie auf > endete. Steht der Marker mit dem Text auf
	// derselben Zeile - und Eudoras eigener Quelltext sagt, dass er das tut
	// (msgutils.cpp:2374) -, war der komplette Rumpf weg. Die Datei wurde
	// dabei GROESSER, weil die Kopfzeilen dazukamen; deshalb faellt es
	// niemandem auf.
	// ------------------------------------------------------------------

	TT_BeginTest("E-101 P-28: Marker und Text auf derselben Zeile - Rumpf bleibt");
	{
		const char* const kEineZeile =
			"From: a@example.invalid\r\n"
			"Subject: alles auf einer Zeile\r\n"
			"\r\n"
			"<x-html><html><body>Der ganze Text der Nachricht.</body></html></x-html>\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kEineZeile, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		TT_CHECK_MSG(Hat(szDatei, "Der ganze Text der Nachricht."),
					 "DATENVERLUST: der Rumpf ist verschwunden");
		TT_CHECK_MSG(Hat(szDatei, "<html><body>"),
					 "die HTML-Huelle muss erhalten bleiben");
		TT_CHECK_MSG(!Hat(szDatei, "x-html"),
					 "der interne Marker muss weg sein - beide");

		//
		// Und jetzt der Satz, der den Schnitt nicht durchlaesst.
		//
		{
			const char* const	kTags[] = { "<x-html>", "</x-html>" };

			PruefeJedesByte(kEineZeile, szDatei, kTags, 2);
			PruefeRumpfMass(szSpur, kEineZeile, szDatei);
		}
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101 P-28: Marker ohne Gegenstueck, Text auf derselben Zeile");
	{
		const char* const kOhneEnde =
			"From: a@example.invalid\r\n"
			"\r\n"
			"<x-html><html><body>Text ohne schliessenden Marker</body></html>\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kOhneEnde, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		TT_CHECK_MSG(Hat(szDatei, "Text ohne schliessenden Marker"),
					 "DATENVERLUST: der Rumpf ist verschwunden");

		{
			const char* const	kTags[] = { "<x-html>" };

			PruefeJedesByte(kOhneEnde, szDatei, kTags, 1);
			PruefeRumpfMass(szSpur, kOhneEnde, szDatei);
		}
	}
	TT_EndTest();

	// ------------------------------------------------------------------
	TT_BeginTest("E-101 P-28: > im Attributwert beendet das Tag nicht");
	{
		const char* const kAttrGleicheZeile =
			"From: a@example.invalid\r\n"
			"\r\n"
			"<x-html content-base=\"http://host/a>b/\"><html>Inhalt</html>\r\n";
		bGeaendert = UTE101_SpeicherfassungAufbereiten(kAttrGleicheZeile, true,
													   szDatei, szSpur);
		TT_Note("%s", (const char*) szSpur);
		TT_CHECK_MSG(Hat(szDatei, "<html>Inhalt</html>"),
					 "der Rumpf hinter dem Tag muss vollstaendig bleiben");
		TT_CHECK_MSG(!Hat(szDatei, "b/\">"),
					 "der Rest des Tags steht noch in der Datei");

		{
			const char* const	kTags[] =
					{ "<x-html content-base=\"http://host/a>b/\">" };

			PruefeJedesByte(kAttrGleicheZeile, szDatei, kTags, 1);
			PruefeRumpfMass(szSpur, kAttrGleicheZeile, szDatei);
		}
	}
	TT_EndTest();

	TT_BeginTest("E-101: leere Eingabe aendert nichts und stuerzt nicht ab");
	bGeaendert = UTE101_SpeicherfassungAufbereiten("", true, szDatei, szSpur);
	TT_CHECK_MSG(!bGeaendert, "an nichts ist nichts zu tun");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(NULL, true, szDatei, szSpur);
	TT_CHECK_MSG(!bGeaendert, "auch ein Nullzeiger darf nicht stoeren");
	TT_EndTest();
}
