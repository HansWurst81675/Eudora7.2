//
// OTShimProbe.cpp - siehe OTShimProbe.h
//
#include <afxwin.h>
#include <string.h>

#include "OTShimProbe.h"

static int  s_iMeldungen = 0;
static char s_szLetzte[512] = { 0 };

//
// Ersatz fuer die Sammelmeldung aus OTShim.cpp:154.
//
// Wortgleiche Zweitdefinition der Signatur, die OTShim_Bild.h:196 und
// OTShim.h:1028 deklarieren. Der Rumpf unterscheidet sich bewusst: das
// Original zeigt ein AfxMessageBox, diese Fassung schreibt nur mit.
//
// Das Merkverhalten des Originals ist uebernommen - jede Fundstelle bringt
// ihr eigenes statisches Flag mit und meldet sich hoechstens einmal je Lauf.
// Ohne dieses Flag koennte ein Test nicht mehrfach hintereinander pruefen,
// dass sich ein Rumpf meldet; mit ihm ist das Verhalten dasselbe wie im
// laufenden Eudora, und die Tests muessen sich danach richten.
//
void OTShimNichtUmgesetzt(BOOL& rbBereitsGemeldet, LPCTSTR lpszWas)
{
	if (rbBereitsGemeldet)
		return;

	rbBereitsGemeldet = TRUE;
	++s_iMeldungen;

	strncpy(s_szLetzte, (lpszWas != NULL) ? lpszWas : "(NULL)", sizeof(s_szLetzte) - 1);
	s_szLetzte[sizeof(s_szLetzte) - 1] = '\0';
}

int OTShimProbeMeldungen(void)
{
	return s_iMeldungen;
}

const char* OTShimProbeLetzteMeldung(void)
{
	return s_szLetzte;
}

void OTShimProbeZuruecksetzen(void)
{
	s_iMeldungen = 0;
	s_szLetzte[0] = '\0';
}
