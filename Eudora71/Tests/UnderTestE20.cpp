//
// UnderTestE20.cpp - bindet CListCtrlEx::InsertArr aus ListCtrlEx.cpp ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch geschnitten.
// Hier steht deshalb bewusst kein abgeschriebener Code.
//
// WARUM DAS SO GEPRUEFT WIRD: Befund E-20, PRUEFER-50 K1. Der fruehere Test
// las den Quelltext und blieb gruen, als PRUEFER den alten Ueberlauf in einer
// anderen Schreibweise wieder einbaute (293 von 293 gruen). Jetzt wird die
// Funktion aufgerufen.
//
// DEBUG_NEW leitet jede Feldanlage auf den operator new[] unten um: er merkt
// sich die angeforderte Groesse und fuellt das Feld samt einem Streifen
// dahinter mit 0xAB. Wer hinter das Feldende schreibt, veraendert den
// Streifen, statt fremden Speicher zu treffen; wer hinter dem Ende des alten
// Feldes liest, holt 0xABABABAB in das neue.
//
// Uebersetzt wird diese Datei wie Eudora.vcxproj mit
// ForceConformanceInForLoopScope=false (Einstellung je Datei in
// Tests.vcxproj): InsertArr benutzt die Laufvariable der ersten Schleife in
// der zweiten weiter.
//
#include <string.h>
#include <new>

#include "UnderTestE20.h"

static const size_t E20_STREIFEN = 64;

struct E20Marke {};
static size_t         s_nAngefordert = 0;
static unsigned char* s_pZuletzt     = NULL;

void* operator new[](size_t n, E20Marke)
{
	unsigned char* p = static_cast<unsigned char*>(::operator new[](n + E20_STREIFEN));
	memset(p, 0xAB, n + E20_STREIFEN);
	s_nAngefordert = n;
	s_pZuletzt = p;
	return p;
}

void operator delete[](void* p, E20Marke)
{
	::operator delete[](p);
}

static const E20Marke s_Marke = E20Marke();
#define DEBUG_NEW new(s_Marke)

class CListCtrlEx
{
public:
	void InsertArr(unsigned int *& pArr, unsigned int &nLen, unsigned int nDefault, unsigned int nIdx);
};

#include "generated/listctrlex_e20.inc"

bool E20Einfuegen(const unsigned int* pWerte, unsigned int nLen, unsigned int nDefault,
				  unsigned int nIdx, E20Ergebnis* pErg)
{
	memset(pErg, 0, sizeof(*pErg));

	unsigned int* pArr = DEBUG_NEW unsigned int[nLen];
	for (unsigned int k = 0; k < nLen; k++)
		pArr[k] = pWerte[k];

	CListCtrlEx Liste;
	unsigned int nNeuLen = nLen;
	Liste.InsertArr(pArr, nNeuLen, nDefault, nIdx);

	// Das neue Feld ist die letzte Anlage, und pArr zeigt darauf.
	if (reinterpret_cast<unsigned char*>(pArr) != s_pZuletzt)
	{
		delete[] pArr;
		return false;
	}
	pErg->nLen = nNeuLen;
	pErg->nAngefordert = s_nAngefordert;
	pErg->bStreifenHeil = true;
	for (size_t b = s_nAngefordert; b < s_nAngefordert + E20_STREIFEN; b++)
		if (s_pZuletzt[b] != 0xAB)
			pErg->bStreifenHeil = false;

	const bool bPasst = nNeuLen <= sizeof(pErg->aWerte) / sizeof(pErg->aWerte[0])
					 && nNeuLen * sizeof(unsigned int) <= s_nAngefordert;
	if (bPasst)
		for (unsigned int k = 0; k < nNeuLen; k++)
			pErg->aWerte[k] = pArr[k];

	delete[] pArr;
	return true;
}
