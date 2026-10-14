//
// UnderTestE118.h - Zugriff auf E118Huelle/E118Achtbit aus EuImap/src/ImapAppend.cpp
//
// Der Code liegt in UnderTestE118.cpp, das die von Extract.ps1 geschnittene
// Datei generated/imapappend_e118.inc einbindet.
//
#ifndef EUDORA_TESTS_UNDERTEST_E118_H
#define EUDORA_TESTS_UNDERTEST_E118_H

int E118Huelle(const char* p, long nLaenge, long* pnAnfang, long* pnEnde);
int E118Achtbit(const char* p, long nLaenge);
int E118Verweis(const char* pHtml, long nLaenge, unsigned long ulHash, int bCid,
                unsigned long (*pfHash)(const char*), char* szAus, int nAus);

#endif
