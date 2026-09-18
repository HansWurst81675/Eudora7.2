//
// UnderTestResolveURL.cpp - bindet resolve_URL aus HTMLUtils.cpp ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch aus
// Eudora71/Eudora/HTMLUtils.cpp geschnitten. Hier steht deshalb bewusst kein
// abgeschriebener Code - ein Test gegen eine Kopie misst die Kopie.
//
// WARUM DAS GEPRUEFT WIRD
//
// resolve_URL baut aus dem src-Attribut eines <img> die Adresse, unter der
// Eudora das Bild holt. Bis zum 18.09.2026 warf es jede Prozent-Sequenz WEG,
// statt sie zu entschluesseln: im %-Zweig wurde das entschluesselte Zeichen
// nach *output geschrieben, output aber nicht weitergerueckt, und das naechste
// Zeichen ueberschrieb es.
//
// Gemessen an Gregors Nachricht vom 18.09.2026:
//   en%20aktuellen%20Verlust.png  ->  enaktuellenVerlust.png   (404)
//   SVS%20NL%20FW%20(1).jpg       ->  SVSNLFW(1).jpg           (404)
// Zehn von zwanzig Bildern blieben deshalb graue Kaesten (Befund E-110).
//
// Das ist reine Zeichenkettenarbeit - Adresse rein, Adresse raus. Kein Paige,
// kein Netz, kein einziges Bild noetig. Genau die Sorte Fehler, die der
// Pruefstand haette finden koennen und nicht gefunden hat, weil diese Funktion
// nie unter Test stand.
//
#include <stddef.h>
#include <string.h>

#include "UnderTestResolveURL.h"

//
// Die Typen aus CPUDEFS.H. Der Eudora-Bau ist MBCS, also greift dort der
// #else-Zweig: pg_char ist ein unsigned char. Wuerde hier versehentlich der
// UNICODE-Zweig nachgebildet (pg_word), pruefte der Test eine andere
// Breitenrechnung als das Programm.
//
typedef unsigned short  pg_short_t;
typedef unsigned char   pg_char;
typedef pg_char*        pg_char_ptr;

// Vorwaertsdeklarationen: resolve_URL ruft translate_hex, unescape_url ruft
// x2c - beide stehen in der Datei weiter unten.
pg_short_t translate_hex(pg_char hex_char);
char x2c(char* what);

// --------------------------------------------------------- die Funktionen
#include "generated/htmlutils_resolveurl.inc"

// --------------------------------------------------------- Schnittstelle
#line 47 "UnderTestResolveURL.cpp"

void UTRU_ResolveURL(const char* pszEin, char* szAus, size_t nMaxLength)
{
	// resolve_URL nimmt einen nicht-konstanten Zeiger, liest die Quelle aber
	// nur. Die Kopie haelt den Test davon ab, seine eigene Eingabe zu
	// veraendern - sonst waere eine zweite Messung an derselben Zeichenkette
	// nicht mehr dieselbe Messung.
	char szKopie[1024];

	strncpy(szKopie, pszEin, sizeof(szKopie) - 1);
	szKopie[sizeof(szKopie) - 1] = 0;

	resolve_URL((pg_char_ptr)szKopie, (pg_char_ptr)szAus, nMaxLength);
}

void UTRU_UnescapeURL(const char* pszEin, char* szAus, size_t nAus)
{
	// unescape_url arbeitet IN PLACE - deshalb erst kopieren, dann rufen.
	strncpy(szAus, pszEin, nAus - 1);
	szAus[nAus - 1] = 0;

	unescape_url(szAus);
}
