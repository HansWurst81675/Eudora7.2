//
// UnderTestE88.cpp - bindet die E-88-Entscheidung aus msgutils.cpp ein
//
// Die .inc-Dateien werden bei jedem Build von Extract.ps1 frisch aus
// Eudora71/Eudora/msgutils.cpp und Eudora71/Eudora/utils.cpp geschnitten.
// Hier steht deshalb bewusst kein abgeschriebener Code, nur die Umgebung,
// die der geschnittene Code zum Uebersetzen braucht.
//
// Warum das ueberhaupt geprueft wird: E88OriginalEinsetzen entscheidet, ob
// die Original-Fassung einer Nachricht hinausgeht oder die Fassung aus dem
// Verfassen-Editor. Eine falsche Entscheidung sieht vor dem Absenden
// niemand - das Verfassenfenster zeigt in beiden Faellen dasselbe.
//
#include <afx.h>
#include <afxwin.h>
#include <string.h>

#include "UnderTestE88.h"

// ---------------------------------------------------------------- Umgebung

// Aus Eudora71/Eudora/utils.h. Die Zahlenwerte muessen dieselben sein wie
// dort; TestE88 prueft das nicht zur Laufzeit, weil utils.h hier nicht
// eingebunden werden kann - dafuer stehen sie unmittelbar nebeneinander.
#define IS_ASCII	0
#define IS_FLOWED	1
#define IS_RICH		2
#define IS_HTML		3

// Aus Eudora71/Eudora/resource.h - nur die eine Nummer, die der
// geschnittene Code benutzt.
#define IDS_INI_FORWARD_ORIGINAL_HTML 11151

// Aus DebugNewHelpers.h. Im Testprogramm gibt es keine
// Speicherbuchfuehrung, also das schlichte new.
#define DEBUG_NEW_NOTHROW new

// --- Attrappe: der INI-Schalter -----------------------------------------
static int	g_nSchalter = 1;

void UTE88_SetSchalter(int nWert)
{
	g_nSchalter = nWert;
}

static short GetIniShort(UINT nID)
{
	return (nID == IDS_INI_FORWARD_ORIGINAL_HTML) ? (short) g_nSchalter : (short) 0;
}

// --- Attrappe: Text2Html -------------------------------------------------
//
// Der Produktivcode maskiert hier zusaetzlich Umlaute, erkennt Adressen und
// setzt Zeilenumbrueche. Fuer die Entscheidung, die hier geprueft wird,
// zaehlt allein, dass aus Text HTML wird und die drei gefaehrlichen Zeichen
// maskiert sind. Was Text2Html sonst noch tut, gehoert nicht zu E-88.
//
static CString Text2Html(LPCTSTR szSource, BOOL, BOOL)
{
	CString		szOut;

	for (const char* p = szSource; p && *p; ++p)
	{
		if (*p == '<')			szOut += "&lt;";
		else if (*p == '>')		szOut += "&gt;";
		else if (*p == '&')		szOut += "&amp;";
		else					szOut += *p;
	}

	return szOut;
}

// ------------------------------------------------------------- IsFancy
// Geschnitten aus utils.cpp, nicht abgeschrieben.
#include "generated/utils_isfancy.inc"

// ------------------------------------------------------- die zwei Funktionen
#include "generated/msgutils_e88.inc"

// --------------------------------------------------------- Schnittstelle
#line 80 "UnderTestE88.cpp"

bool UTE88_OriginalEinsetzen(const char* pszOriginalHtml,
							 const char* pszEditorText,
							 char cAntwortTyp,
							 CString& out_szNeuerRumpf,
							 CString& out_szSpur)
{
	return E88OriginalEinsetzen(pszOriginalHtml, pszEditorText, cAntwortTyp,
								out_szNeuerRumpf, out_szSpur);
}
