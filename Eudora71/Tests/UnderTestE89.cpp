//
// UnderTestE89.cpp - bindet die E-89-Umschrift aus msgutils.cpp ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch aus
// Eudora71/Eudora/msgutils.cpp geschnitten. Hier steht deshalb bewusst
// kein abgeschriebener Code, nur die Umgebung, die der geschnittene Code
// zum Uebersetzen braucht - und die ist bei E-89 fast leer: die vier
// Funktionen rechnen nur mit Zeichenketten, ohne INI, ohne Ressourcen,
// ohne Fenster.
//
// Warum das ueberhaupt geprueft wird: E89BilderMessbarMachen schreibt die
// Fassung um, die in den Verfassen-Editor geht. Schreibt sie zu viel um,
// gehen fremde Absichten verloren; schreibt sie zu wenig um, liegen die
// Bilder wieder ueber dem Text. Beides sieht man erst am laufenden
// Programm - und dort erst, wenn man die richtige Nachricht erwischt.
//
#include <afx.h>
#include <afxwin.h>
#include <string.h>

#include "UnderTestE89.h"

// Aus DebugNewHelpers.h. Im Testprogramm gibt es keine
// Speicherbuchfuehrung, also das schlichte new.
#define DEBUG_NEW_NOTHROW new

// ------------------------------------------------------- die vier Funktionen
#include "generated/msgutils_e89.inc"

// --------------------------------------------------------- Schnittstelle
#line 31 "UnderTestE89.cpp"

bool UTE89_BilderMessbarMachen(const char* pszHtml,
							   CString& out_szHtml,
							   CString& out_szSpur)
{
	return E89BilderMessbarMachen(pszHtml, out_szHtml, out_szSpur);
}

int UTE89_MaxBreite(void)		{ return E89_MAX_BREITE; }
int UTE89_MaxHoehe(void)		{ return E89_MAX_HOEHE; }
int UTE89_VorgabeBreite(void)	{ return E89_VORGABE_BREITE; }
int UTE89_VorgabeHoehe(void)	{ return E89_VORGABE_HOEHE; }
