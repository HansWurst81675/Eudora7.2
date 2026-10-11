//
// UnderTestE101.h - Zugriff auf die Speicher-Aufbereitung aus msgutils.cpp
//
// Der eigentliche Code liegt in UnderTestE101.cpp, das die von Extract.ps1
// geschnittene Datei generated/msgutils_e101.inc einbindet. Hier steht kein
// abgeschriebener Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_E101_H
#define EUDORA_TESTS_UNDERTEST_E101_H

// CString kommt aus afx.h - die einbindenden .cpp-Dateien holen es vor
// dieser Datei herein.

// Ruft E101SpeicherfassungAufbereiten auf. Rueckgabe wie dort: true heisst,
// die Datei wurde umgeschrieben und out_szDatei tritt an die Stelle des
// Eingangstextes.
bool UTE101_SpeicherfassungAufbereiten(const char* pszVoll,
									   bool bHatKopfzeilen,
									   CString& out_szDatei,
									   CString& out_szSpur);

#endif
