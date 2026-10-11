//
// UnderTestResolveURL.h - Zugriff auf resolve_URL aus HTMLUtils.cpp
//
// Der eigentliche Code liegt in UnderTestResolveURL.cpp, das die von
// Extract.ps1 geschnittene Datei generated/htmlutils_resolveurl.inc einbindet.
// Hier steht kein abgeschriebener Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_RESOLVEURL_H
#define EUDORA_TESTS_UNDERTEST_RESOLVEURL_H

#include <stddef.h>

// Ruft resolve_URL auf. pszEin ist die Adresse, wie sie im src-Attribut
// steht; szAus nimmt auf, was Eudora daraus macht. nMaxLength geht
// unveraendert an resolve_URL weiter - die Laengenschranke gehoert mit
// geprueft, nicht nur der Normalfall.
void UTRU_ResolveURL(const char* pszEin, char* szAus, size_t nMaxLength);

// Dasselbe fuer unescape_url, die zweite Funktion in derselben Datei, die
// dieselbe Aufgabe loest - und sie richtig loest. Sie ist die Gegenprobe:
// wenn beide dasselbe liefern, ist resolve_URL in Ordnung.
void UTRU_UnescapeURL(const char* pszEin, char* szAus, size_t nAus);

#endif
