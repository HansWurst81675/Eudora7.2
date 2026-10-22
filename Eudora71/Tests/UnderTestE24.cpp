//
// UnderTestE24.cpp - bindet die Listenarbeit aus QCMailboxDirector.cpp ein
//
// WARUM DAS GEPRUEFT WIRD: Befund E-24. Im Postfachbaum stand unter "Recent"
// der Eintrag "In" zweimal, gleich nach dem ersten Start mit einem frischen
// Mailverzeichnis. s_RecentMailboxList ist ein std::list<LPCTSTR> und haelt
// ROHE ZEIGER; verglichen wurde ueber den Zeiger. Der Ersatzeintrag kam aber
// aus einer temporaeren CString und war mit keinem echten Eintrag
// zeigergleich - also fand die Pruefung "steht schon drin" nichts, und
// std::list::remove entfernte nichts. Danach standen zwei Eintraege in der
// Liste und zwei "In" im Baum.
//
// Die drei Funktionen haengen an nichts ausser <list> und stricmp. Sie sind
// deshalb ohne Fenster, ohne Ini und ohne Mailverzeichnis pruefbar.
//
#include <windows.h>
#include <tchar.h>
#include <string.h>
#include <list>

#include "UnderTestE24.h"

#include "generated/qcmailboxdirector_e24.inc"

// --------------------------------------------------------------- Schnittstelle
#line 30 "UnderTestE24.cpp"

bool UT_RecentPathsEqual(LPCTSTR pszLeft, LPCTSTR pszRight)
{
	return RecentPathsEqual(pszLeft, pszRight);
}

bool UT_RecentListContains(const std::list<LPCTSTR>& theList, LPCTSTR pszPathname)
{
	return RecentListContains(theList, pszPathname);
}

size_t UT_RecentListRemove(std::list<LPCTSTR>& theList, LPCTSTR pszPathname)
{
	return RecentListRemove(theList, pszPathname);
}
