//
// UnderTestE20.cpp - bindet die Spaltenfelder von CListCtrlEx aus ListCtrlEx.cpp ein
//
// Die .inc-Dateien werden bei jedem Build von Extract.ps1 frisch geschnitten.
// Hier steht deshalb bewusst kein abgeschriebener Code.
//
// WARUM DAS SO GEPRUEFT WIRD: Befund E-20, PRUEFER-50 K1. Der fruehere Test
// las den Quelltext und blieb gruen, als PRUEFER den alten Ueberlauf in einer
// anderen Schreibweise wieder einbaute (293 von 293 gruen). Jetzt wird die
// Funktion aufgerufen. Seit 25.10.2026 ebenso DeleteArr und NotifyDeletedCol
// (Befund E-150, PRUEFER-52 K1: das Gegenstueck beim Loeschen).
//
// DEBUG_NEW leitet jede Feldanlage auf den operator new[] unten um: er merkt
// sich jedes angelegte Feld mit seiner Groesse und fuellt es samt einem
// Streifen dahinter mit 0xAB. Wer hinter das Feldende schreibt, veraendert
// den Streifen, statt fremden Speicher zu treffen; wer hinter dem Ende des
// alten Feldes liest, holt 0xABABABAB in das neue.
//
// Uebersetzt wird diese Datei wie Eudora.vcxproj mit
// ForceConformanceInForLoopScope=false (Einstellung je Datei in
// Tests.vcxproj): die Funktionen benutzen die Laufvariable der ersten
// Schleife in der zweiten weiter.
//
#include <string.h>
#include <new>

#include "UnderTestE20.h"

static const size_t E20_STREIFEN = 64;

struct E20Marke {};

// Jede Anlage mit Groesse - damit nach NotifyDeletedCol alle vier Felder
// geprueft werden koennen, nicht nur das zuletzt angelegte.
struct E20Anlage { unsigned char* p; size_t n; };
static E20Anlage s_aAnlagen[64];
static int       s_nAnlagen = 0;

static void E20Vergessen(void)
{
	s_nAnlagen = 0;
}

static const E20Anlage* E20Finde(const void* p)
{
	for (int k = s_nAnlagen - 1; k >= 0; k--)
		if (s_aAnlagen[k].p == p)
			return &s_aAnlagen[k];
	return NULL;
}

static bool E20StreifenHeil(const void* p)
{
	const E20Anlage* pA = E20Finde(p);
	if (!pA)
		return false;
	for (size_t b = pA->n; b < pA->n + E20_STREIFEN; b++)
		if (pA->p[b] != 0xAB)
			return false;
	return true;
}

void* operator new[](size_t n, E20Marke)
{
	unsigned char* p = static_cast<unsigned char*>(::operator new[](n + E20_STREIFEN));
	memset(p, 0xAB, n + E20_STREIFEN);
	if (s_nAnlagen < (int)(sizeof(s_aAnlagen) / sizeof(s_aAnlagen[0])))
	{
		s_aAnlagen[s_nAnlagen].p = p;
		s_aAnlagen[s_nAnlagen].n = n;
		s_nAnlagen++;
	}
	return p;
}

void operator delete[](void* p, E20Marke)
{
	::operator delete[](p);
}

static const E20Marke s_Marke = E20Marke();
#define DEBUG_NEW new(s_Marke)

class CImageList;

class CListCtrlEx
{
public:
	void InsertArr(unsigned int *& pArr, unsigned int &nLen, unsigned int nDefault, unsigned int nIdx);
	void DeleteArr(unsigned int *& pArr, unsigned int &nLen, unsigned int nIdx);
	void NotifyDeletedCol(unsigned int nCol);
	void NotifyInsertedCol(unsigned int nCol);

	unsigned int *m_DispTypeArr;
	unsigned int m_DispTypeArrLen;
	unsigned int m_ImageHeightArrLen;
	unsigned int * m_ImageHeightArr;
	unsigned int m_ImageWidthArrLen;
	unsigned int * m_ImageWidthArr;
	CImageList ** m_DispImageListArr;
	unsigned int m_DispImageListArrLen;
};

#include "generated/listctrlex_konst.inc"
#include "generated/listctrlex_e20.inc"
#include "generated/listctrlex_e150.inc"
#include "generated/listctrlex_e150b.inc"
#include "generated/listctrlex_e20b.inc"

static unsigned int* E20Feld(const unsigned int* pWerte, unsigned int nLen)
{
	unsigned int* pArr = DEBUG_NEW unsigned int[nLen];
	for (unsigned int k = 0; k < nLen; k++)
		pArr[k] = pWerte ? pWerte[k] : 0;
	return pArr;
}

static bool E20Auswerten(unsigned int* pArr, unsigned int nNeuLen, E20Ergebnis* pErg)
{
	const E20Anlage* pA = E20Finde(pArr);
	if (!pA)
		return false;
	pErg->nLen = nNeuLen;
	pErg->nAngefordert = pA->n;
	pErg->bStreifenHeil = E20StreifenHeil(pArr);
	const bool bPasst = nNeuLen <= sizeof(pErg->aWerte) / sizeof(pErg->aWerte[0])
					 && nNeuLen * sizeof(unsigned int) <= pA->n;
	if (bPasst)
		for (unsigned int k = 0; k < nNeuLen; k++)
			pErg->aWerte[k] = pArr[k];
	return true;
}

bool E20Einfuegen(const unsigned int* pWerte, unsigned int nLen, unsigned int nDefault,
				  unsigned int nIdx, E20Ergebnis* pErg)
{
	memset(pErg, 0, sizeof(*pErg));
	E20Vergessen();
	unsigned int* pArr = E20Feld(pWerte, nLen);

	CListCtrlEx Liste;
	unsigned int nNeuLen = nLen;
	Liste.InsertArr(pArr, nNeuLen, nDefault, nIdx);

	const bool bOk = E20Auswerten(pArr, nNeuLen, pErg);
	delete[] pArr;
	return bOk;
}

bool E150Loeschen(const unsigned int* pWerte, unsigned int nLen, unsigned int nIdx,
				  E20Ergebnis* pErg)
{
	memset(pErg, 0, sizeof(*pErg));
	E20Vergessen();
	unsigned int* pAlt = E20Feld(pWerte, nLen);
	unsigned int* pArr = pAlt;

	CListCtrlEx Liste;
	unsigned int nNeuLen = nLen;
	try
	{
		Liste.DeleteArr(pArr, nNeuLen, nIdx);
	}
	catch (...)
	{
		// nLen = 0: nLen - 1 ist vorzeichenlos 0xFFFFFFFF, new[] wirft.
		pErg->bAusnahme = true;
		delete[] pArr;
		return true;
	}

	// Auch das alte Feld darf nicht beschrieben worden sein, falls es bleibt.
	const bool bOk = E20Auswerten(pArr, nNeuLen, pErg);
	delete[] pArr;
	return bOk;
}

// Gemeinsamer Aufbau fuer NotifyInsertedCol (E-20, PRUEFER-52 K2: die zweite
// E-20-Behebung war von keinem Test bewacht) und NotifyDeletedCol (E-150).
static bool E20Spalte(bool bEinfuegen, unsigned int nLen, unsigned int nCol,
					  unsigned int* pLaengen, bool* pStreifenHeil, bool* pAusnahme);

bool E150SpalteLoeschen(unsigned int nLen, unsigned int nCol,
						unsigned int* pLaengen, bool* pStreifenHeil, bool* pAusnahme)
{
	return E20Spalte(false, nLen, nCol, pLaengen, pStreifenHeil, pAusnahme);
}

bool E20SpalteEinfuegen(unsigned int nLen, unsigned int nCol,
						unsigned int* pLaengen, bool* pStreifenHeil, bool* pAusnahme)
{
	return E20Spalte(true, nLen, nCol, pLaengen, pStreifenHeil, pAusnahme);
}

static bool E20Spalte(bool bEinfuegen, unsigned int nLen, unsigned int nCol,
					  unsigned int* pLaengen, bool* pStreifenHeil, bool* pAusnahme)
{
	E20Vergessen();
	*pAusnahme = false;

	CListCtrlEx Liste;
	Liste.m_DispTypeArr = E20Feld(NULL, nLen);      Liste.m_DispTypeArrLen = nLen;
	Liste.m_ImageHeightArr = E20Feld(NULL, nLen);   Liste.m_ImageHeightArrLen = nLen;
	Liste.m_ImageWidthArr = E20Feld(NULL, nLen);    Liste.m_ImageWidthArrLen = nLen;
	Liste.m_DispImageListArr = DEBUG_NEW CImageList*[nLen];
	for (unsigned int k = 0; k < nLen; k++)
		Liste.m_DispImageListArr[k] = NULL;
	Liste.m_DispImageListArrLen = nLen;

	try
	{
		if (bEinfuegen)
			Liste.NotifyInsertedCol(nCol);
		else
			Liste.NotifyDeletedCol(nCol);
	}
	catch (...)
	{
		*pAusnahme = true;
	}

	*pStreifenHeil = E20StreifenHeil(Liste.m_DispTypeArr)
				  && E20StreifenHeil(Liste.m_ImageHeightArr)
				  && E20StreifenHeil(Liste.m_ImageWidthArr)
				  && E20StreifenHeil(Liste.m_DispImageListArr);
	pLaengen[0] = Liste.m_DispTypeArrLen;
	pLaengen[1] = Liste.m_ImageHeightArrLen;
	pLaengen[2] = Liste.m_ImageWidthArrLen;
	pLaengen[3] = Liste.m_DispImageListArrLen;

	delete[] Liste.m_DispTypeArr;
	delete[] Liste.m_ImageHeightArr;
	delete[] Liste.m_ImageWidthArr;
	delete[] Liste.m_DispImageListArr;
	return true;
}
