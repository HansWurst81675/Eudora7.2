//
// UnderTestZ2.h - Zugriff auf die Zeichensatz-Ansage aus Befund Z-2
//
// Der Text der beiden <meta>-Zeilen, die CTridentView::WriteTempFile als
// erste Bytes in die Zwischendatei schreibt, wird von Extract.ps1 aus
// TridentView.cpp geschnitten (generated/tridentview_z2.inc). Hier steht
// nur der Zugriff darauf - abgeschrieben ist nichts.
//
#ifndef EUDORA_TESTS_UNDERTEST_Z2_H
#define EUDORA_TESTS_UNDERTEST_Z2_H

// Die Zeichensatz-Ansage. Ohne sie raet MSHTML den Zeichensatz aus dem
// Inhalt und macht aus jedem Umlaut ein U+FFFD (Befund Z-2 / E-2).
const char* UT_Z2CharsetMeta(void);
int         UT_Z2CharsetMetaLaenge(void);

// Die Modus-Ansage, die unmittelbar davor steht. Sie darf keine
// Zeichensatzangabe enthalten - sonst stuenden zwei im Kopf.
const char* UT_Z2Kompatibilitaet(void);
int         UT_Z2KompatibilitaetLaenge(void);

#endif
