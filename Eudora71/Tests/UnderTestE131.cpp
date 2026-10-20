//
// UnderTestE131.cpp - bindet die Entscheidung aus mainfrm.cpp ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch geschnitten.
// Hier steht deshalb bewusst kein abgeschriebener Code.
//
// WARUM DAS GEPRUEFT WIRD: Befund E-131. Eudora schrieb eine nie gesetzte
// Schwebeposition (INT_MIN) in die Eudora.ini; eine daneben installierte
// Hermes 7.1 stuerzte danach beim Start ab. Gemeldet von aussen, Issue #102,
// am 20.10.2026 am Pruefstand nachgestellt.
//
#include <windows.h>

#include "UnderTestE131.h"

#include "generated/mainfrm_e131.inc"
