//
// UnderTestE77.h - Zugriff auf die UTF-7-Funktionen aus EuImap/src/ImapMailbox.cpp
//
// Der Code liegt in UnderTestE77.cpp, das die von Extract.ps1 geschnittene
// Datei generated/imapmailbox_e77.inc einbindet. Hier steht nur die
// Deklaration.
//
#ifndef EUDORA_TESTS_UNDERTEST_E77_H
#define EUDORA_TESTS_UNDERTEST_E77_H

BOOL E77Utf7Dekodieren(const char* pIn, char* pOut, int nOut);
BOOL E77Utf7Kodieren(const char* pIn, char* pOut, int nOut);

#endif
