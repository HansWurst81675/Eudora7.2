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
	TT_BeginTest("E-101: ohne Kopfzeilen wird nur der Marker entfernt");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(
					"<x-html>\r\n<html><body>Hallo</body></html>\r\n</x-html>\r\n",
					false, szDatei, szSpur);
	TT_Note("%s", (const char*) szSpur);
	TT_CHECK_MSG(bGeaendert, "der Marker muss weg");
	TT_CHECK_MSG(!Hat(szDatei, "x-html"),
			 "kein Marker mehr in der Datei");
	TT_CHECK_MSG(!Hat(szDatei, "Content-Type"),
			 "ohne Kopfzeilen wird auch keine erfunden");
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

	TT_BeginTest("E-101: leere Eingabe aendert nichts und stuerzt nicht ab");
	bGeaendert = UTE101_SpeicherfassungAufbereiten("", true, szDatei, szSpur);
	TT_CHECK_MSG(!bGeaendert, "an nichts ist nichts zu tun");
	bGeaendert = UTE101_SpeicherfassungAufbereiten(NULL, true, szDatei, szSpur);
	TT_CHECK_MSG(!bGeaendert, "auch ein Nullzeiger darf nicht stoeren");
	TT_EndTest();
}
