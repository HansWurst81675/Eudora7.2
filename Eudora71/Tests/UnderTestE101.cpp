//
// UnderTestE101.cpp - bindet die Speicher-Aufbereitung aus msgutils.cpp ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch aus
// Eudora71/Eudora/msgutils.cpp geschnitten. Hier steht deshalb bewusst kein
// abgeschriebener Code.
//
// Warum das ueberhaupt geprueft wird: E101SpeicherfassungAufbereiten
// entscheidet, was in der Datei steht, die der Anwender aus der Hand gibt.
// Schreibt sie zu wenig, ist die Datei fuer jedes andere Programm
// unbrauchbar - genau der Zustand, den Gregor am 17.09.2026 gemeldet hat.
// Schreibt sie zu viel, ueberschreibt sie die echten Kopfzeilen einer
// empfangenen Nachricht. Beides sieht man an der Datei erst, wenn man sie
// oeffnet - und dazu kommt im Alltag niemand.
//
#include <afx.h>
#include <afxwin.h>
#include <ctype.h>
#include <string.h>

#include "UnderTestE101.h"

// Aus DebugNewHelpers.h. Im Testprogramm gibt es keine Speicherbuchfuehrung.
#define DEBUG_NEW_NOTHROW new

// --------------------------------------------------------- die Funktion
#include "generated/msgutils_e101.inc"

// --------------------------------------------------------- E-196
#include "generated/msgutils_e196.inc"

// --------------------------------------------------------- E-128
#include "generated/msgutils_e128.inc"

// --------------------------------------------------------- Schnittstelle
#line 30 "UnderTestE101.cpp"

bool UTE101_SpeicherfassungAufbereiten(const char* pszVoll,
									   bool bHatKopfzeilen,
									   CString& out_szDatei,
									   CString& out_szSpur)
{
	return E101SpeicherfassungAufbereiten(pszVoll, bHatKopfzeilen,
										  out_szDatei, out_szSpur);
}

bool UTE196_HtmlZeichensatz(const char* pszHtml,
							CString& out_szDatei,
							CString& out_szSpur)
{
	return E196HtmlZeichensatz(pszHtml, out_szDatei, out_szSpur);
}

// E-128 (generated/msgutils_e128.inc)
bool UTE128_DateiMitKopf(bool bKopfzeilen, const char* pszVorher, const char* pszNachher)
{
	return E128DateiMitKopf(bKopfzeilen, pszVorher, pszNachher);
}

const char* UTE128_Vorgabeendung(bool bPostfachliste, int nAnzahl, bool bDateiMitKopf, bool bHtml)
{
	return E128Vorgabeendung(bPostfachliste, nAnzahl, bDateiMitKopf, bHtml);
}

int UTE128_FilterIndex(const char* pszFilter, const char* pszEndung)
{
	return E128FilterIndex(pszFilter, pszEndung);
}
