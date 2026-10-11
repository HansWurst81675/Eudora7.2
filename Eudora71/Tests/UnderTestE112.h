//
// UnderTestE112.h - Zugriff auf E112Zielrechteck aus PgEmbeddedImage.cpp
//
// Der Code liegt in UnderTestE112.cpp, das die von Extract.ps1 geschnittene
// Datei generated/pgembedded_e112.inc einbindet. Hier steht kein
// abgeschriebener Produktivcode - nur die Deklaration, damit der Test die
// Funktion aufrufen kann.
//
#ifndef EUDORA_TESTS_UNDERTEST_E112_H
#define EUDORA_TESTS_UNDERTEST_E112_H

void E112Zielrechteck(long nAttrBreite, long nAttrHoehe,
					  long nEchtBreite, long nEchtHoehe,
					  long* pnRahmenBreite, long* pnRahmenHoehe);

#endif
