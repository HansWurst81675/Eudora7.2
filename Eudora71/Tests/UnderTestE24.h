//
// UnderTestE24.h - Zugriff auf die Listenarbeit aus Befund E-24
//
// Der Code liegt in UnderTestE24.cpp, das die von Extract.ps1 geschnittene
// Datei generated/qcmailboxdirector_e24.inc einbindet. Abgeschrieben ist
// hier nichts.
//
#ifndef EUDORA_TESTS_UNDERTEST_E24_H
#define EUDORA_TESTS_UNDERTEST_E24_H

#include <windows.h>
#include <tchar.h>
#include <list>

// Vergleicht zwei Eintraege der Liste "zuletzt benutzte Postfaecher" nach
// ihrem INHALT. Vor E-24 wurden die Zeiger verglichen.
bool UT_RecentPathsEqual(LPCTSTR pszLeft, LPCTSTR pszRight);

// Steht dieses Postfach schon in der Liste?
bool UT_RecentListContains(const std::list<LPCTSTR>& theList, LPCTSTR pszPathname);

// Entfernt alle Eintraege, die auf dasselbe Postfach zeigen, und liefert
// zurueck, wie viele es waren. std::list::remove verglich hier die Zeiger
// und entfernte deshalb nichts.
size_t UT_RecentListRemove(std::list<LPCTSTR>& theList, LPCTSTR pszPathname);

#endif
