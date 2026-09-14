//
// UnderTestE89.h - Zugriff auf die E-89-Umschrift aus msgutils.cpp
//
// Der eigentliche Code liegt in UnderTestE89.cpp, das die von Extract.ps1
// geschnittene Datei generated/msgutils_e89.inc einbindet. Hier steht kein
// abgeschriebener Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_E89_H
#define EUDORA_TESTS_UNDERTEST_E89_H

// CString kommt aus afx.h - die einbindenden .cpp-Dateien holen es vor
// dieser Datei herein. Eine Vorwaertsdeklaration geht nicht: CString ist
// ein typedef auf CStringT, keine Klasse.

// Ruft E89BilderMessbarMachen auf. Rueckgabe wie dort: true heisst, die
// Fassung fuer den Editor wurde wirklich umgeschrieben.
bool UTE89_BilderMessbarMachen(const char* pszHtml,
							   CString& out_szHtml,
							   CString& out_szSpur);

// Die Deckel- und Vorgabewerte aus dem Produktivcode. Die Tests rechnen
// mit ihnen, statt die Zahlen noch einmal hinzuschreiben - sonst faellt
// eine Aenderung des Deckels im Test nicht auf.
int UTE89_MaxBreite(void);
int UTE89_MaxHoehe(void);
int UTE89_VorgabeBreite(void);
int UTE89_VorgabeHoehe(void);

#endif
