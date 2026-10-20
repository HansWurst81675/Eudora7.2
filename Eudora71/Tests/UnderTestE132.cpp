//
// UnderTestE132.cpp - bindet die Entscheidung aus eudora.cpp ein
//
// WARUM DAS GEPRUEFT WIRD: Befund E-132. Ein Doppelklick auf Eudora.exe
// uebernahm stillschweigend das Mailverzeichnis einer fremden Installation,
// gefunden ueber die Registry - und schrieb hinein. Gemeldet von aussen
// (Issue #102); danach startete die Eudora 7.1 des Melders nicht mehr.
//
#include <windows.h>
#include <tchar.h>

#include "UnderTestE132.h"

#include "generated/eudora_e132.inc"
#include "generated/eudora_e132_zerlegen.inc"
