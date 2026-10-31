//
// UnderTestE136.cpp - bindet E136HtmlAusBstr aus TridentView.cpp ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch aus
// Eudora71/Eudora/TridentView.cpp geschnitten. Hier steht kein abgeschriebener
// Produktivcode.
//
#include <afx.h>
#include <afxwin.h>
#include <string.h>

// Aus debug.h - im Testprogramm schreibt OTShimProbe.cpp die Spur.
#ifndef DEBUG_MASK_DIALOG
#define DEBUG_MASK_DIALOG 0x08
#endif
void PutDebugLog(unsigned long dwMask, const char* szText, int iLen = -1);

// --------------------------------------------------------- die Funktion
#include "generated/tridentview_e136.inc"

// --------------------------------------------------------- Schnittstelle
CString UTE136_HtmlAusBstr(const wchar_t* pwText)
{
	return E136HtmlAusBstr(pwText);
}
