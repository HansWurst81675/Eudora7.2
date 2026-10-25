//
// UnderTestE20.h - Zugriff auf CListCtrlEx::InsertArr (Befund E-20)
//
// Der Code liegt in UnderTestE20.cpp, das die von Extract.ps1 geschnittene
// Datei generated/listctrlex_e20.inc einbindet. Hier steht kein abgeschriebener
// Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_E20_H
#define EUDORA_TESTS_UNDERTEST_E20_H

#include <stddef.h>

struct E20Ergebnis
{
	unsigned int nLen;          // nLen nach InsertArr
	unsigned int aWerte[32];    // die ersten nLen Eintraege des neuen Feldes
	size_t       nAngefordert;  // Bytes, die InsertArr fuer das neue Feld anforderte
	bool         bStreifenHeil; // der Schutzstreifen hinter dem neuen Feld ist unberuehrt
};

// Legt ein Feld aus pWerte[0..nLen) an, ruft InsertArr(pArr, nLen, nDefault,
// nIdx) und beschreibt das Ergebnis. Liefert false, wenn der Aufruf nicht
// auswertbar war (Feld groesser als aWerte).
bool E20Einfuegen(const unsigned int* pWerte, unsigned int nLen, unsigned int nDefault,
				  unsigned int nIdx, E20Ergebnis* pErg);

#endif
