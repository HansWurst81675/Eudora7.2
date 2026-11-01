//
// UnderTestE179.cpp - die echte E179ZeichenAusNummer aus html2text.cpp,
// bei jedem Bau frisch von Extract.ps1 geschnitten (Befund E-179).
//
#include <afx.h>
#include <afxwin.h>
#include <ctype.h>
#include <string.h>

// --------------------------------------------------------- die Funktion
#include "generated/html2text_e179.inc"

// --------------------------------------------------------- Schnittstelle
CString UTE179_ZeichenAusNummer(const char* szText, unsigned long ulTotalLength, unsigned long& ulVerbraucht)
{
	ULONG ul = 0;
	CString sz = E179ZeichenAusNummer(szText, ulTotalLength, ul);
	ulVerbraucht = ul;
	return sz;
}
