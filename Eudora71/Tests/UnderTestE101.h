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

// Ruft E196HtmlZeichensatz auf (Befund E-196, aus derselben msgutils.cpp
// geschnitten, generated/msgutils_e196.inc). Rueckgabe wie dort.
bool UTE196_HtmlZeichensatz(const char* pszHtml,
							CString& out_szDatei,
							CString& out_szSpur);

// E-128: Vorgabeendung im Dialog "Speichern unter" (aus msgutils.cpp
// geschnitten, generated/msgutils_e128.inc). Rueckgaben wie dort.
bool UTE128_DateiMitKopf(bool bKopfzeilen, const char* pszVorher, const char* pszNachher);
const char* UTE128_Vorgabeendung(bool bPostfachliste, int nAnzahl, bool bDateiMitKopf, bool bHtml);
int UTE128_FilterIndex(const char* pszFilter, const char* pszEndung);

// E-220: Dateiname aus dem Betreff (aus msgutils.cpp geschnitten,
// generated/msgutils_e220.inc).
void UTE220_DateinameAusBetreff(const char* pszBetreff, char* pszZiel, size_t nZiel);

#endif
