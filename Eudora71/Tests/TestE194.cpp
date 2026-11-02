//
// TestE194.cpp - Regressionstest zu E-194
//
// E-194: "Speichern unter" aus der Postfachliste schrieb bei einer Mail im
//        Format format=flowed Eudoras interne Klammern <x-flowed> und
//        </x-flowed> in die Textdatei. Der Kern E101SpeicherfassungAufbereiten
//        (msgutils.cpp) nahm nur eine <x-html>-Huelle ab. Gemessen am
//        02.11.2026 an 7.2.1.131 (tools/messen-e194.ps1, Pruefnachricht
//        Testdaten/e194-flowed-umlaute.eml ueber POP): liste-xflowed=2, mit
//        Kopfzeilen auch aus dem Nachrichtenfenster lesen-xflowed=2.
//
// Geprueft wird der Kern selbst, aus dem Produktivcode geschnitten
// (UnderTestE101.cpp). Jeder Fall faehrt die Gegenrichtung mit: was nicht
// die Huelle ist, bleibt stehen (P-18, P-19 aus E-101).
//
#include <afx.h>
#include <afxwin.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE101.h"

static bool Hat(const CString& s, const char* p)
{
	return s.Find(p) >= 0;
}

static int Zaehle(const CString& s, const char* p)
{
	int n = 0;
	int i = 0;
	const int nLen = (int) strlen(p);
	while ((i = s.Find(p, i)) >= 0)
	{
		n++;
		i += nLen;
	}
	return n;
}

//
// Der Rumpf, wie er nach dem POP-Empfang in In.mbx liegt (gemessen an
// C:\Temp\E194\Mailverzeichnis\In.mbx, 02.11.2026): ohne Kopfzeilen holt
// tocview.cpp ihn mit FindBody, die Klammern stehen auf eigenen Zeilen,
// \x80 ist das Euro-Zeichen nach der Uebersetzung aus UTF-8.
//
static const char* const kFlowedRumpf =
	"<x-flowed>\r\n"
	"E-194 Pruefnachricht im Format format=flowed. Dieser Absatz ist so lang, \r\n"
	"dass er umbrochen wurde: Gr\xFC\xDF" "e aus M\xFCnchen, Preis 5 \x80, \r\n"
	"\xE4\xF6\xFC.\r\n"
	"\r\n"
	"> Zitat, ebenfalls \r\n"
	"> umbrochen.\r\n"
	"</x-flowed>\r\n";

static void Test_E194_OhneKopf()
{
	TT_BeginTest("E-194: <x-flowed> verlaesst das Haus nicht (Postfachliste, ohne Kopfzeilen)");
	CString szDatei, szSpur;
	const bool bOk = UTE101_SpeicherfassungAufbereiten(kFlowedRumpf, false, szDatei, szSpur);
	TT_CHECK_MSG(bOk, "der Kern meldet keine Aenderung");
	TT_CHECK_MSG(!Hat(szDatei, "x-flowed"), "eine Klammer <x-flowed>/</x-flowed> steht noch in der Datei (E-194)");
	TT_CHECK_MSG(Hat(szDatei, "Content-Type: text/plain; charset=\"windows-1252\"; format=flowed\r\n"),
				 "Content-Type traegt nicht text/plain mit windows-1252 und format=flowed (E-194)");
	// Gegenprobe: der Text bleibt Zeile fuer Zeile - die weichen Umbrueche
	// (Leerzeichen am Ende) sind genau das, was format=flowed beschreibt.
	TT_CHECK_MSG(Hat(szDatei, "\r\n\r\nE-194 Pruefnachricht im Format format=flowed. Dieser Absatz ist so lang, \r\ndass er"),
				 "der Rumpf beginnt nicht direkt hinter dem Kopf oder der weiche Umbruch ist weg");
	TT_CHECK_MSG(Hat(szDatei, "> Zitat, ebenfalls \r\n> umbrochen.\r\n"), "das Zitat ist veraendert");
	if (!(Hat(szSpur, "huelle=x-flowed"))) TT_Fail("die Spur nennt die Huelle nicht: %s", (LPCTSTR) szSpur);
	TT_CHECK_MSG(Hat(szSpur, "rumpf-vorher=") && szDatei.GetLength() > 0, "keine Laengen in der Spur");
	TT_EndTest();
}

static void Test_E194_MitKopf()
{
	TT_BeginTest("E-194: mit Kopfzeilen - Original-Content-Type umbenannt, eigener mit format=flowed");
	CString szVoll =
		"From: Pruefung <absender@e194.invalid>\r\n"
		"Subject: Pruefung E-194\r\n"
		"MIME-Version: 1.0\r\n"
		"Content-Type: text/plain; charset=utf-8; format=flowed\r\n"
		"Content-Transfer-Encoding: 8bit\r\n"
		"\r\n";
	szVoll += kFlowedRumpf;
	CString szDatei, szSpur;
	UTE101_SpeicherfassungAufbereiten(szVoll, true, szDatei, szSpur);
	TT_CHECK_MSG(Zaehle(szDatei, "x-flowed") == 0, "Klammern stehen noch in der Datei (E-194)");
	TT_CHECK_MSG(Hat(szDatei, "X-Original-Content-Type: text/plain; charset=utf-8; format=flowed\r\n"), "die alte Angabe ist nicht erhalten");
	TT_CHECK_MSG(Hat(szDatei, "\r\nContent-Type: text/plain; charset=\"windows-1252\"; format=flowed\r\n"), "die neue Angabe nennt format=flowed nicht (E-194)");
	TT_CHECK_MSG(Zaehle(szDatei, "MIME-Version:") == 1, "MIME-Version doppelt");
	TT_EndTest();
}

static void Test_E194_AnhangDahinter()
{
	TT_BeginTest("E-194: </x-flowed> auf eigener Zeile vor einer Anhangszeile wird entfernt, mitten im Text nicht");
	const char* const kMitAnhang =
		"<x-flowed>\r\n"
		"Text \r\n"
		"weiter.\r\n"
		"</x-flowed>\r\n"
		"Attachment Converted: \"C:\\Mail\\Anhang.pdf\"\r\n";
	CString szDatei, szSpur;
	UTE101_SpeicherfassungAufbereiten(kMitAnhang, false, szDatei, szSpur);
	CString szErg = szDatei.IsEmpty() ? CString(kMitAnhang) : szDatei;
	TT_CHECK_MSG(!Hat(szErg, "x-flowed"), "eine Klammer steht noch in der Datei");
	TT_CHECK_MSG(Hat(szErg, "Text \r\nweiter.\r\nAttachment Converted: \"C:\\Mail\\Anhang.pdf\"\r\n"), "Text oder Anhangszeile veraendert");

	// Gegenprobe: ein zitiertes </x-flowed> MITTEN in einer Zeile ist Text.
	const char* const kZitat =
		"<x-flowed>\r\n"
		"Er schrieb </x-flowed> in die Zeile.\r\n"
		"Nachsatz\r\n";
	CString szD2, szS2;
	UTE101_SpeicherfassungAufbereiten(kZitat, false, szD2, szS2);
	CString szE2 = szD2.IsEmpty() ? CString(kZitat) : szD2;
	TT_CHECK_MSG(Hat(szE2, "Er schrieb </x-flowed> in die Zeile.\r\nNachsatz\r\n"), "zitierter Text verloren (P-19)");
	TT_CHECK_MSG(!Hat(szE2, "<x-flowed>\r\n"), "die oeffnende Klammer steht noch");

	// PRUEFER-86 K8: zitiertes </x-flowed> am ZeilenENDE (nicht am Anfang) -
	// prueft die Bedingung "Gegenstueck am Zeilenanfang".
	const char* const kZitatEnde =
		"<x-flowed>\r\n"
		"Er schrieb </x-flowed>\r\n"
		"Nachsatz\r\n";
	CString szD3, szS3;
	UTE101_SpeicherfassungAufbereiten(kZitatEnde, false, szD3, szS3);
	CString szE3 = szD3.IsEmpty() ? CString(kZitatEnde) : szD3;
	TT_CHECK_MSG(Hat(szE3, "Er schrieb </x-flowed>\r\nNachsatz\r\n"), "zitiertes </x-flowed> am Zeilenende entfernt (PRUEFER-86 K8)");
	TT_EndTest();
}

static void Test_E194_NurAscii()
{
	TT_BeginTest("E-194: reiner ASCII-Text - Klammern weg, aber kein erfundener Kopf");
	const char* const kAscii = "<x-flowed>\r\nGuten Tag, \r\nalles gut.\r\n</x-flowed>\r\n";
	CString szDatei, szSpur;
	const bool bOk = UTE101_SpeicherfassungAufbereiten(kAscii, false, szDatei, szSpur);
	TT_CHECK_MSG(bOk, "keine Aenderung gemeldet");
	if (!(szDatei == "Guten Tag, \r\nalles gut.\r\n")) TT_Fail("erwartet genau den Text ohne Klammern, bekommen [%s]", (LPCTSTR) szDatei);
	TT_EndTest();
}

static void Test_E194_Rich()
{
	TT_BeginTest("E-194: <x-rich> wird zu text/enriched");
	const char* const kRich = "<x-rich>\r\n<bold>Hallo</bold> Welt\r\n</x-rich>\r\n";
	CString szDatei, szSpur;
	UTE101_SpeicherfassungAufbereiten(kRich, false, szDatei, szSpur);
	TT_CHECK_MSG(!Hat(szDatei, "x-rich"), "Klammer <x-rich> steht noch in der Datei");
	if (!(Hat(szDatei, "Content-Type: text/enriched; charset=\"us-ascii\"\r\n"))) TT_Fail("kein text/enriched: [%s]", (LPCTSTR) szDatei);
	TT_CHECK_MSG(Hat(szDatei, "\r\n\r\n<bold>Hallo</bold> Welt\r\n"), "Rumpf veraendert");
	TT_EndTest();
}

static void Test_E194_KeinMarker()
{
	TT_BeginTest("E-194 Gegenprobe: <x-flowedx und <x-flowed mitten im Text sind keine Huelle; x-html bleibt wie bisher");
	const char* const kFalsch = "<x-flowedx>\r\nText\r\n</x-flowedx>\r\n";
	CString szDatei, szSpur;
	const bool bOk = UTE101_SpeicherfassungAufbereiten(kFalsch, false, szDatei, szSpur);
	TT_CHECK_MSG(!bOk, "ein fremdes Tag wurde als Huelle behandelt");
	if (!(Hat(szSpur, "huelle=-"))) TT_Fail("Spur nennt eine Huelle: %s", (LPCTSTR) szSpur);

	const char* const kHtml = "<x-html>\r\n<html><body>Hallo</body></html>\r\n</x-html>\r\n";
	CString szD2, szS2;
	UTE101_SpeicherfassungAufbereiten(kHtml, false, szD2, szS2);
	TT_CHECK_MSG(Hat(szD2, "Content-Type: text/html; charset=\"us-ascii\"\r\n"), "x-html ist nicht mehr text/html");
	TT_CHECK_MSG(!Hat(szD2, "format=flowed"), "x-html traegt format=flowed");
	if (!(Hat(szS2, "huelle=x-html"))) TT_Fail("Spur nennt x-html nicht: %s", (LPCTSTR) szS2);
	TT_EndTest();
}

static void Test_E194_RichtextDelsp()
{
	TT_BeginTest("E-194 PRUEFER-86 K5/K6: text/richtext bleibt richtext, delsp=yes bleibt erhalten");
	const char* const kRich =
		"From: a@e194.invalid\r\n"
		"Content-Type: text/richtext; charset=utf-8\r\n"
		"\r\n"
		"<x-rich>\r\nGr\xFC\xDF" "e<nl>\r\n</x-rich>\r\n";
	CString szD, szS;
	UTE101_SpeicherfassungAufbereiten(kRich, true, szD, szS);
	if (!Hat(szD, "\r\nContent-Type: text/richtext; charset=\"ISO-8859-1\"\r\n")) TT_Fail("richtext nicht erhalten: [%s]", (LPCTSTR) szD);
	TT_CHECK_MSG(!Hat(szD, "text/enriched"), "richtext als enriched ausgewiesen (K5)");

	const char* const kDelsp =
		"From: a@e194.invalid\r\n"
		"Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes\r\n"
		"\r\n"
		"<x-flowed>\r\nGr\xFC\xDF" "e aus M\xFC \r\nnchen\r\n</x-flowed>\r\n";
	CString szD2, szS2;
	UTE101_SpeicherfassungAufbereiten(kDelsp, true, szD2, szS2);
	if (!Hat(szD2, "\r\nContent-Type: text/plain; charset=\"ISO-8859-1\"; format=flowed; delsp=yes\r\n")) TT_Fail("delsp=yes fehlt: [%s]", (LPCTSTR) szD2);

	// Gegenprobe: ohne delsp in der alten Zeile auch keins in der neuen.
	const char* const kOhne =
		"From: a@e194.invalid\r\n"
		"Content-Type: text/plain; charset=utf-8; format=flowed\r\n"
		"\r\n"
		"<x-flowed>\r\n\xFC \r\nb\r\n</x-flowed>\r\n";
	CString szD3, szS3;
	UTE101_SpeicherfassungAufbereiten(kOhne, true, szD3, szS3);
	TT_CHECK_MSG(Hat(szD3, "; format=flowed\r\n") && !Hat(szD3, "Content-Type: text/plain; charset=\"ISO-8859-1\"; format=flowed; delsp"), "delsp erfunden");
	TT_EndTest();
}

void RunE194Tests()
{
	Test_E194_RichtextDelsp();
	Test_E194_OhneKopf();
	Test_E194_MitKopf();
	Test_E194_AnhangDahinter();
	Test_E194_NurAscii();
	Test_E194_Rich();
	Test_E194_KeinMarker();
}
