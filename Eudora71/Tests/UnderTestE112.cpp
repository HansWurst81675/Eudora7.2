//
// UnderTestE112.cpp - bindet E112Zielrechteck aus PgEmbeddedImage.cpp ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch geschnitten. Hier
// steht deshalb bewusst kein abgeschriebener Code.
//
// Die Funktion ist absichtlich frei von Paige-Typen: sie nimmt vier Zahlen und
// liefert zwei. Das ist die Lehre aus E-106 - dort stand dieselbe Entscheidung
// mitten im Ladeweg zwischen embed_ref, UseMemory und pgInvalEmbedRef, war
// deshalb nur an Gregors Rechner messbar, und dass sie falsch herum war, kam
// erst zwei Befunde spaeter heraus.
//
#include "UnderTestE112.h"

// --------------------------------------------------------- die Funktion
#include "generated/pgembedded_e112.inc"
