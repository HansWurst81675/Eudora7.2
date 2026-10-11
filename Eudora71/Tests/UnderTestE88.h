//
// UnderTestE88.h - Zugriff auf die E-88-Entscheidung aus msgutils.cpp
//
// Der eigentliche Code liegt in UnderTestE88.cpp, das die von Extract.ps1
// geschnittene Datei generated/msgutils_e88.inc einbindet. Hier steht kein
// abgeschriebener Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_E88_H
#define EUDORA_TESTS_UNDERTEST_E88_H

// CString kommt aus afx.h - die einbindenden .cpp-Dateien holen es vor
// dieser Datei herein. Eine Vorwaertsdeklaration geht nicht: CString ist
// ein typedef auf CStringT, keine Klasse.

// Stellt den Wert ein, den die Attrappe von GetIniShort fuer
// IDS_INI_FORWARD_ORIGINAL_HTML liefert. 1 = Schalter an.
void UTE88_SetSchalter(int nWert);

// Ruft E88OriginalEinsetzen auf. Rueckgabe wie dort: true heisst, der
// Rumpf wurde ersetzt.
bool UTE88_OriginalEinsetzen(const char* pszOriginalHtml,
							 const char* pszEditorText,
							 char cAntwortTyp,
							 bool bAnwenderHatGetippt,
							 CString& out_szNeuerRumpf,
							 CString& out_szSpur);

#endif
