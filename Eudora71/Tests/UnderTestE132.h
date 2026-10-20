//
// UnderTestE132.h - Zugriff auf die Entscheidung aus Befund E-132
//
// Der Code liegt in UnderTestE132.cpp, das die von Extract.ps1 geschnittene
// Datei generated/eudora_e132.inc einbindet.
//
#ifndef EUDORA_TESTS_UNDERTEST_E132_H
#define EUDORA_TESTS_UNDERTEST_E132_H

#include <windows.h>
#include <tchar.h>

bool E132IstFremdesVerzeichnis(LPCTSTR pKandidat, LPCTSTR pEigenes, bool bHatEigeneIni);

// Die Registry nennt eine ganze Befehlszeile. Ohne diese Trennung lief die
// Pruefung oben gegen einen Pfad aus zwei Pfaden und blieb stumm (E-132).
void E132AufrufZerlegen(LPCTSTR pAufruf, LPTSTR pVerzeichnis, size_t nVerzeichnis,
						LPTSTR pIni, size_t nIni);

#endif
