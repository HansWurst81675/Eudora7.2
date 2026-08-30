//
// OTShimProbe.cpp - siehe OTShimProbe.h
//
#include <afxwin.h>
#include <string.h>

#include "OTShimProbe.h"

static int  s_iMeldungen = 0;
static char s_szLetzte[1024] = { 0 };


//
// Das Anwendungsobjekt des Testprogramms.
//
// Es dient einzig dazu, DoMessageBox zu ueberschreiben. AfxWinInit in
// TestMain.cpp findet es ueber AfxGetApp() und traegt Instanz und
// Befehlszeile ein; eine Nachrichtenschleife laeuft nie, InitInstance wird
// nie gerufen. Das ist der uebliche Aufbau einer MFC-Konsolenanwendung.
//
// AUFPASSEN: das Objekt muss vor main() entstehen, damit AfxGetApp() es
// waehrend AfxWinInit schon sieht. Deshalb steht es hier als globales
// Objekt und nicht in einer Funktion.
//
class CProbeApp : public CWinApp
{
public:
	virtual int DoMessageBox(LPCTSTR lpszPrompt, UINT nType, UINT nIDPrompt);
};

int CProbeApp::DoMessageBox(LPCTSTR lpszPrompt, UINT /*nType*/, UINT /*nIDPrompt*/)
{
	++s_iMeldungen;

	strncpy(s_szLetzte, (lpszPrompt != NULL) ? lpszPrompt : "(NULL)", sizeof(s_szLetzte) - 1);
	s_szLetzte[sizeof(s_szLetzte) - 1] = '\0';

	// IDOK, als haette der Anwender bestaetigt. Die Sammelmeldung aus
	// OTShim.cpp wertet den Rueckgabewert nicht aus; andere Meldungen
	// koennten es tun, und Bestaetigen ist der harmlosere Weg.
	return IDOK;
}

CProbeApp theProbeApp;


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


/////////////////////////////////////////////////////////////////////////////
// Fremdsymbol: SuperAssertionA
//
// GEMESSEN beim Einbinden von OT501/Src/secaux.cpp (das die Veraenderliche
// secData liefert, ohne die OTShim_Werkzeugleiste.cpp nicht bindet):
//
//   secaux.obj : error LNK2019: nicht aufgeloestes externes Symbol
//     "__imp__SuperAssertionA" in Funktion "SEC_AUX_DATA::SEC_AUX_DATA(void)"
//
// HERKUNFT: secaux.cpp bindet OT501/Src/stdafx.h ein, dieses qcassert.h
// (QCUtils), dieses BugslayerUtil.h (EuMemMgr). Damit wird ASSERT auf die
// Bugslayer-Fassung SUPERASSERT umgebogen, deren Rumpf in der DLL
// BugslayerUtil liegt. Eudora selbst bindet diese DLL ein; fuer ein
// Testprogramm waere das ein unverhaeltnismaessiger Rattenschwanz.
//
// LOESUNG: das Testprojekt setzt BUGSUTIL_DLLINTERFACE auf leer (BugslayerUtil.h
// erlaubt das ausdruecklich, Zeile 132-141). Aus dem Import wird damit eine
// gewoehnliche freie Funktion, die hier ihren Rumpf bekommt. FALSE heisst
// laut SuperAssert.h:46 "Zusicherung uebergehen" - genau richtig fuer einen
// unbeaufsichtigten Testlauf, der nicht anhalten darf.
//
// WICHTIG: das betrifft ausschliesslich dieses Testprojekt. Eudora.vcxproj
// wird nicht angefasst, und ausser secaux.cpp bindet keine hier uebersetzte
// Datei BugslayerUtil.h ein.
//
extern "C" BOOL SuperAssertionA(LPCSTR /*szType*/, LPCSTR /*szExpression*/,
								LPCSTR /*szFunction*/, LPCSTR /*szFile*/,
								int /*iLine*/, LPCSTR /*szEmail*/,
								DWORD64 /*dwStack*/, DWORD64 /*dwStackFrame*/,
								int* /*piFailCount*/, int* /*piIgnoreCount*/)
{
	return FALSE;
}
