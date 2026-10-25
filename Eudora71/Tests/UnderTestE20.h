//
// UnderTestE20.h - Zugriff auf die Spaltenfelder von CListCtrlEx (Befunde E-20, E-150)
//
// Der Code liegt in UnderTestE20.cpp, das die von Extract.ps1 geschnittenen
// Dateien generated/listctrlex_e20.inc und listctrlex_e150.inc einbindet.
// Hier steht kein abgeschriebener Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_E20_H
#define EUDORA_TESTS_UNDERTEST_E20_H

#include <stddef.h>

struct E20Ergebnis
{
	unsigned int nLen;          // nLen nach dem Aufruf
	unsigned int aWerte[32];    // die ersten nLen Eintraege des Feldes danach
	size_t       nAngefordert;  // Bytes, die fuer das Feld danach angefordert wurden
	bool         bStreifenHeil; // der Schutzstreifen hinter jedem beteiligten Feld ist unberuehrt
	bool         bAusnahme;     // der Aufruf warf (etwa bad_alloc bei nLen - 1 = 0xFFFFFFFF)
};

// Legt ein Feld aus pWerte[0..nLen) an, ruft InsertArr(pArr, nLen, nDefault,
// nIdx) und beschreibt das Ergebnis. Liefert false, wenn der Aufruf nicht
// auswertbar war (Feld groesser als aWerte).
bool E20Einfuegen(const unsigned int* pWerte, unsigned int nLen, unsigned int nDefault,
				  unsigned int nIdx, E20Ergebnis* pErg);

// E-150: dasselbe fuer DeleteArr(pArr, nLen, nIdx).
bool E150Loeschen(const unsigned int* pWerte, unsigned int nLen, unsigned int nIdx,
				  E20Ergebnis* pErg);

// E-150: legt alle vier Spaltenfelder mit nLen Eintraegen an (die Bildliste
// mit NULL), ruft NotifyDeletedCol(nCol) und meldet, ob jeder Schutzstreifen
// heil blieb und welche Laengen die Felder danach haben.
bool E150SpalteLoeschen(unsigned int nLen, unsigned int nCol,
						unsigned int* pLaengen /* [4] */, bool* pStreifenHeil, bool* pAusnahme);

// E-20: dasselbe fuer NotifyInsertedCol(nCol) - die zweite E-20-Behebung.
bool E20SpalteEinfuegen(unsigned int nLen, unsigned int nCol,
						unsigned int* pLaengen /* [4] */, bool* pStreifenHeil, bool* pAusnahme);

#endif
