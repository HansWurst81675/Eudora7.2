//
// UnderTestE69.h - Zugriff auf die beiden Regeln aus Befund E-69, P3
//
// Der Code liegt in UnderTestE69.cpp, das die von Extract.ps1 geschnittenen
// Dateien generated/filtersd_e69.inc und generated/taskerror_e69.inc
// einbindet. Hier steht kein abgeschriebener Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_E69_H
#define EUDORA_TESTS_UNDERTEST_E69_H

#include <windows.h>

// --- A: wer bekommt einen eigenen Eintrag in "Task Errors"? ---------------
//
// Die Struktur selbst kommt aus filtersd.cpp. Die Testdatei legt sie an und
// ruft LaufBeginn / Melden / LaufEnde.
struct CE69Sammlung;

void  UTE69_LaufBeginn(void* pSammlung);
bool  UTE69_Melden(void* pSammlung);
int   UTE69_LaufEnde(void* pSammlung);
void* UTE69_Neu(void);
void  UTE69_Frei(void* pSammlung);

// --- B: darf dieser Fehler piepen und das Fenster nach vorn holen? -------
bool E69LautErlaubt(DWORD dwJetzt, DWORD* pdwLetzte, DWORD dwFenster);

#endif
