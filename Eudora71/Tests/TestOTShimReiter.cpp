//
// TestOTShimReiter.cpp - prueft die Listenpflege der Registerkarten-Familie
//
// Geprueft wird SECTabControlBase und die Erweiterung SEC3DTabControl. Beide
// Klassen erben von CWnd, brauchen fuer die Listenpflege aber KEIN Fenster:
// jede Stelle, die zeichnet oder eine Nachricht schickt, ist mit
// GetSafeHwnd() != NULL bzw. ::IsWindow(...) abgesichert. Genau das macht
// diesen Teil pruefbar, und dieser Testabschnitt schreibt es zugleich fest -
// verschwindet eine dieser Absicherungen, faellt hier etwas um.
//
// WARUM DIESE FAMILIE WICHTIG IST: SEC3DTabWnd/SEC3DTabControl ist das
// Registerkarten-Steuerelement INNERHALB jeder Wazoo-Leiste (WazooBar.h:137).
// Ohne die Listenpflege bliebe jede Wazoo-Leiste leer - Mailboxes, Nicknames,
// Filters, Directory Services, Link History, Task Status.
//
// Die Erwartungen stammen aus zwei Quellen, nicht aus dem Bauchgefuehl:
//   - dem Kommentarkopf von OTShim_Reiter.h, der die Zusicherungen nennt,
//     auf die Eudora sich verlaesst (vor allem: ActivateTab ist untaetig,
//     wenn der Reiter schon obenauf liegt - WazooBar.cpp:350-360)
//   - der Aufrufliste ebendort, die zu jeder Methode die Zeilen in Eudora
//     nennt
//
// WAS HIER NICHT GEPRUEFT WIRD und warum, steht am Ende der Datei.
//
#include <afxwin.h>
#include <stdio.h>
#include <crtdbg.h>

#include "TinyTest.h"
#include "OTShim_Reiter.h"


/////////////////////////////////////////////////////////////////////////////
// Zusicherungen zaehlen
//
// MFC prueft in fast jeder CWnd-Methode mit ASSERT(::IsWindow(m_hWnd)), ob
// das Objekt ueberhaupt ein Fenster hat. Im Debugbau von Eudora wuerde eine
// solche Zusicherung ein Meldungsfenster aufmachen. Ein Test kann das
// messen, statt es nur auf stderr durchrauschen zu lassen: der Berichtshaken
// der Laufzeitbibliothek sieht jede Zusicherung, bevor sie irgendwo
// ausgegeben wird.
//
// Der Haken meldet "erledigt" (Rueckgabe TRUE) und setzt den Rueckgabewert
// auf 0 - damit wird weder ausgegeben noch angehalten, und der Testlauf
// bleibt ruhig.

static int s_nZusicherungen = 0;

static int __cdecl ZusicherungsHaken(int nReportType, char* /*szMsg*/, int* pnRet)
{
	if (nReportType == _CRT_ASSERT)
		++s_nZusicherungen;
	if (pnRet != NULL)
		*pnRet = 0;
	return TRUE;
}

static int __cdecl ZusicherungsHakenW(int nReportType, wchar_t* /*szMsg*/, int* pnRet)
{
	if (nReportType == _CRT_ASSERT)
		++s_nZusicherungen;
	if (pnRet != NULL)
		*pnRet = 0;
	return TRUE;
}

// Beide Fassungen werden gesetzt, weil nicht festgelegt ist, ob MFC die
// Meldung schmal oder breit absetzt.
static void ZaehlerStarten(void)
{
	s_nZusicherungen = 0;
	_CrtSetReportHook2(_CRT_RPTHOOK_INSTALL, ZusicherungsHaken);
	_CrtSetReportHookW2(_CRT_RPTHOOK_INSTALL, ZusicherungsHakenW);
}

static int ZaehlerBeenden(void)
{
	_CrtSetReportHookW2(_CRT_RPTHOOK_REMOVE, ZusicherungsHakenW);
	_CrtSetReportHook2(_CRT_RPTHOOK_REMOVE, ZusicherungsHaken);
	return s_nZusicherungen;
}


/////////////////////////////////////////////////////////////////////////////
// Ein Steuerelement zum Hineinschauen
//
// Zwei Dinge braucht der Test, die von aussen nicht erreichbar sind:
//   - GetTabPtr (geschuetzt), um an m_hIcon und m_rect eines SEC3DTab zu
//     kommen; genau so greift auch QC3DTabControl darauf zu
//     (QC3DTabWnd.cpp:58)
//   - eine Moeglichkeit zu zaehlen, wie oft ein Reiterwechsel GEMELDET wird.
//     Das ist der Kern der Zusicherung, auf die Eudora sich verlaesst.
//
// OnActivateTab ruft die Basisfassung ausdruecklich mit auf. Das ist kein
// Beiwerk: SEC3DTabControl::OnActivateTab ruft ScrollToTab und schickt
// TCM_TABSEL an das Elternfenster. Dass diese ganze Kette ohne Fenster
// folgenlos durchlaeuft, ist selbst eine Zusicherung, die geprueft gehoert.

class ProbeTabControl : public SEC3DTabControl
{
public:
	int m_nMeldungen;			// wie oft OnActivateTab gerufen wurde
	int m_nLetzterReiter;		// mit welchem Index zuletzt

	ProbeTabControl() : m_nMeldungen(0), m_nLetzterReiter(-1) {}

	virtual void OnActivateTab(int nTab)
	{
		++m_nMeldungen;
		m_nLetzterReiter = nTab;
		SEC3DTabControl::OnActivateTab(nTab);
	}

	void Zuruecksetzen()          { m_nMeldungen = 0; m_nLetzterReiter = -1; }
	SEC3DTab* Zeiger(int nTab)    { return GetTabPtr(nTab); }

	// GEMESSEN beim ersten Uebersetzungsversuch: TabHit, GetTabRect und
	// GetLabelWidth sind geschuetzt, nicht oeffentlich (OTShim_Reiter.h:
	// 621, 624, 625) - anders als die Aufrufliste im Kommentarkopf vermuten
	// laesst, die QC3DTabWnd.cpp:152 als Aufrufstelle von TabHit nennt. Der
	// Widerspruch ist keiner: QC3DTabControl ist selbst eine abgeleitete
	// Klasse und kommt so heran. Der Test macht es genauso.
	BOOL RufeTabHit(int nTab, CPoint& pt) const     { return TabHit(nTab, pt); }
	void RufeGetTabRect(int nTab, CRect& rc) const  { GetTabRect(nTab, rc); }
	int  RufeGetLabelWidth(int nTab)                { return GetLabelWidth(nTab); }
};


// Ein Platzhalter fuer das Objekt, das an einem Reiter haengt. In Eudora ist
// das ein CWazooWnd; hier genuegt irgendein CObject, weil die Listenpflege
// den Zeiger nur vergleicht und weiterreicht.
class ProbeKlient : public CObject
{
public:
	int m_nNummer;
	ProbeKlient(int n = 0) : m_nNummer(n) {}
};


// Liest die Beschriftung eines Reiters. Liefert NULL, wenn es den Reiter
// nicht gibt.
static const char* Beschriftung(SECTabControlBase& ctrl, int nTab)
{
	LPCTSTR lpszLabel = NULL;
	BOOL bSelected = FALSE;
	CObject* pClient = NULL;
	HMENU hMenu = 0;
	void* pExtra = NULL;

	if (!ctrl.GetTabInfo(nTab, lpszLabel, bSelected, pClient, hMenu, pExtra))
		return NULL;
	return lpszLabel;
}

static BOOL IstAusgewaehlt(SECTabControlBase& ctrl, int nTab)
{
	LPCTSTR lpszLabel = NULL;
	BOOL bSelected = FALSE;
	CObject* pClient = NULL;
	HMENU hMenu = 0;
	void* pExtra = NULL;

	if (!ctrl.GetTabInfo(nTab, lpszLabel, bSelected, pClient, hMenu, pExtra))
		return FALSE;
	return bSelected;
}

// Vergleicht die Beschriftungen der ganzen Liste mit einer erwarteten Folge.
static void ReihenfolgePruefen(SECTabControlBase& ctrl, const char* szErwartet[], int nAnzahl)
{
	int i;

	if (ctrl.GetTabCount() != nAnzahl)
	{
		TT_Fail("GetTabCount = %d, erwartet %d", ctrl.GetTabCount(), nAnzahl);
		return;
	}
	for (i = 0; i < nAnzahl; ++i)
	{
		const char* szIst = Beschriftung(ctrl, i);
		if (szIst == NULL || strcmp(szIst, szErwartet[i]) != 0)
			TT_Fail("Reiter %d heisst \"%s\", erwartet \"%s\"",
					i, (szIst != NULL) ? szIst : "(kein Reiter)", szErwartet[i]);
	}
}


/////////////////////////////////////////////////////////////////////////////
// 1. AddTab und GetTabCount

static void Test_AddTab(void)
{
	ProbeTabControl ctrl;
	ProbeKlient a(1), b(2), c(3);

	TT_BeginTest("SECTabControlBase::AddTab haengt hinten an, GetTabCount zaehlt mit");

	if (ctrl.GetTabCount() != 0)
		TT_Fail("frisches Steuerelement hat %d Reiter, erwartet 0", ctrl.GetTabCount());

	if (ctrl.AddTab(_T("Mailboxes"), &a) == NULL)	TT_Fail("AddTab liefert NULL");
	if (ctrl.AddTab(_T("Nicknames"), &b) == NULL)	TT_Fail("AddTab liefert NULL");
	if (ctrl.AddTab(_T("Filters"),   &c) == NULL)	TT_Fail("AddTab liefert NULL");

	{
		const char* szSoll[] = { "Mailboxes", "Nicknames", "Filters" };
		ReihenfolgePruefen(ctrl, szSoll, 3);
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 2. InsertTab und die Behandlung des Index
//
// Die Umsetzung setzt einen Index ausserhalb des gueltigen Bereichs auf
// "hinten anhaengen". WazooBar.cpp:157, 270, 282 uebergibt einen Index, der
// aus einer Suche stammt und -1 sein kann.

static void Test_InsertTab_Index(void)
{
	ProbeTabControl ctrl;

	TT_BeginTest("SECTabControlBase::InsertTab: Index vorne, mittig, hinten und ausserhalb");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("C"));

	ctrl.InsertTab(1, _T("B"));				// mittendrin
	{
		const char* szSoll[] = { "A", "B", "C" };
		ReihenfolgePruefen(ctrl, szSoll, 3);
	}

	ctrl.InsertTab(0, _T("Start"));			// ganz vorne
	{
		const char* szSoll[] = { "Start", "A", "B", "C" };
		ReihenfolgePruefen(ctrl, szSoll, 4);
	}

	ctrl.InsertTab(4, _T("Ende"));			// genau hinter dem letzten
	{
		const char* szSoll[] = { "Start", "A", "B", "C", "Ende" };
		ReihenfolgePruefen(ctrl, szSoll, 5);
	}

	ctrl.InsertTab(-1, _T("Minus"));		// unterhalb des Bereichs
	ctrl.InsertTab(99, _T("Weit"));			// oberhalb des Bereichs
	{
		const char* szSoll[] = { "Start", "A", "B", "C", "Ende", "Minus", "Weit" };
		ReihenfolgePruefen(ctrl, szSoll, 7);
	}

	TT_EndTest();
}

static void Test_InsertTab_Angaben(void)
{
	ProbeTabControl ctrl;
	ProbeKlient klient(42);
	int nZusatz = 7;
	LPCTSTR lpszLabel = NULL;
	BOOL bSelected = FALSE;
	CObject* pClient = NULL;
	HMENU hMenu = 0;
	void* pExtra = NULL;

	TT_BeginTest("SECTabControlBase::GetTabInfo gibt alle fuenf Angaben zurueck");

	// hMenu ist hier eine reine Kennzahl - die Listenpflege reicht sie nur
	// durch und wertet sie nie aus.
	ctrl.InsertTab(0, _T("Reiter"), &klient, (HMENU) 0x1234, &nZusatz);

	if (!ctrl.GetTabInfo(0, lpszLabel, bSelected, pClient, hMenu, pExtra))
	{
		TT_Fail("GetTabInfo(0) liefert FALSE");
		TT_EndTest();
		return;
	}

	if (lpszLabel == NULL || strcmp(lpszLabel, "Reiter") != 0)
		TT_Fail("Beschriftung \"%s\", erwartet \"Reiter\"", (lpszLabel != NULL) ? lpszLabel : "(NULL)");
	if (pClient != (CObject*) &klient)
		TT_Fail("pClient zeigt nicht auf das uebergebene Objekt");
	if (hMenu != (HMENU) 0x1234)
		TT_Fail("hMenu = %p, erwartet 0x1234", (void*) hMenu);
	if (pExtra != (void*) &nZusatz)
		TT_Fail("pExtra zeigt nicht auf die uebergebene Zusatzangabe");

	// Ein ungueltiger Index liefert FALSE und laesst die Ausgaben in Ruhe.
	if (ctrl.GetTabInfo(1, lpszLabel, bSelected, pClient, hMenu, pExtra))
		TT_Fail("GetTabInfo(1) liefert TRUE, obwohl es nur einen Reiter gibt");
	if (ctrl.GetTabInfo(-1, lpszLabel, bSelected, pClient, hMenu, pExtra))
		TT_Fail("GetTabInfo(-1) liefert TRUE");

	TT_EndTest();
}

static void Test_InsertTab_OhneBeschriftung(void)
{
	ProbeTabControl ctrl;

	TT_BeginTest("SECTabControlBase: Beschriftung NULL beim Einfuegen und beim Umbenennen");

	// Beim Einfuegen wird eine NULL-Beschriftung uebergangen, der Reiter
	// bleibt leer beschriftet.
	ctrl.InsertTab(0, NULL);
	{
		const char* sz = Beschriftung(ctrl, 0);
		if (sz == NULL || sz[0] != 0)
			TT_Fail("Beschriftung nach InsertTab(0, NULL) ist \"%s\", erwartet leer",
					(sz != NULL) ? sz : "(kein Reiter)");
	}

	// Beim Umbenennen dagegen setzt NULL ausdruecklich auf leer zurueck.
	ctrl.RenameTab(0, _T("Etwas"));
	{
		const char* sz = Beschriftung(ctrl, 0);
		if (sz == NULL || strcmp(sz, "Etwas") != 0)
			TT_Fail("RenameTab hat nicht gewirkt: \"%s\"", (sz != NULL) ? sz : "(kein Reiter)");
	}
	ctrl.RenameTab(0, NULL);
	{
		const char* sz = Beschriftung(ctrl, 0);
		if (sz == NULL || sz[0] != 0)
			TT_Fail("Beschriftung nach RenameTab(0, NULL) ist \"%s\", erwartet leer",
					(sz != NULL) ? sz : "(kein Reiter)");
	}

	// Ein ungueltiger Index darf nichts tun und nicht abstuerzen.
	ctrl.RenameTab(5, _T("Egal"));
	ctrl.RenameTab(-1, _T("Egal"));
	if (ctrl.GetTabCount() != 1)
		TT_Fail("RenameTab mit ungueltigem Index hat die Liste veraendert: %d Reiter",
				ctrl.GetTabCount());

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 3. Der aktive Reiter beim Einfuegen
//
// OTShim_Reiter.cpp begruendet: der erste Reiter wird aktiv, OHNE dass ein
// Wechsel gemeldet wird - sonst bekaeme CWazooBar schon beim Aufbau der
// Leiste einen Reiterwechsel und wuerde die Wazoos vorzeitig anstossen.

static void Test_ErsterReiterWirdAktiv(void)
{
	ProbeTabControl ctrl;
	int nAktiv = -99;

	TT_BeginTest("SECTabControlBase: der erste Reiter wird aktiv, ohne Wechselmeldung");

	if (ctrl.GetActiveTab(nAktiv))
		TT_Fail("GetActiveTab auf leerem Steuerelement liefert TRUE");

	ctrl.Zuruecksetzen();
	ctrl.AddTab(_T("Erster"));

	if (!ctrl.GetActiveTab(nAktiv))
		TT_Fail("nach dem ersten AddTab liefert GetActiveTab FALSE");
	else if (nAktiv != 0)
		TT_Fail("aktiver Reiter ist %d, erwartet 0", nAktiv);

	if (ctrl.m_nMeldungen != 0)
		TT_Fail("beim Aufbau der Liste wurden %d Reiterwechsel gemeldet, erwartet 0",
				ctrl.m_nMeldungen);

	// Auch die weiteren Reiter duerfen keinen Wechsel ausloesen.
	ctrl.AddTab(_T("Zweiter"));
	ctrl.AddTab(_T("Dritter"));
	if (ctrl.m_nMeldungen != 0)
		TT_Fail("nach drei AddTab wurden %d Reiterwechsel gemeldet, erwartet 0",
				ctrl.m_nMeldungen);
	if (ctrl.GetActiveTab(nAktiv) && nAktiv != 0)
		TT_Fail("aktiver Reiter ist nach drei AddTab %d, erwartet weiterhin 0", nAktiv);

	TT_EndTest();
}

static void Test_EinfuegenVerschiebtAktiven(void)
{
	ProbeTabControl ctrl;
	int nAktiv = -99;

	TT_BeginTest("SECTabControlBase: Einfuegen vor dem aktiven Reiter verschiebt dessen Index");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));
	ctrl.AddTab(_T("C"));
	ctrl.ActivateTab(1);				// B liegt obenauf
	ctrl.Zuruecksetzen();

	// Davor einfuegen: derselbe Reiter, neuer Index.
	ctrl.InsertTab(0, _T("Neu"));
	if (!ctrl.GetActiveTab(nAktiv))
		TT_Fail("GetActiveTab liefert FALSE");
	else if (nAktiv != 2)
		TT_Fail("aktiver Index nach dem Einfuegen an 0 ist %d, erwartet 2", nAktiv);
	if (strcmp(Beschriftung(ctrl, nAktiv), "B") != 0)
		TT_Fail("obenauf liegt jetzt \"%s\", erwartet weiterhin \"B\"", Beschriftung(ctrl, nAktiv));
	if (ctrl.m_nMeldungen != 0)
		TT_Fail("das Verschieben hat %d Reiterwechsel gemeldet, erwartet 0", ctrl.m_nMeldungen);

	// Genau AUF den aktiven Index einfuegen schiebt ihn ebenfalls weiter.
	ctrl.InsertTab(2, _T("Dazwischen"));
	ctrl.GetActiveTab(nAktiv);
	if (nAktiv != 3)
		TT_Fail("aktiver Index nach dem Einfuegen an 2 ist %d, erwartet 3", nAktiv);

	// Dahinter einfuegen laesst den Index unveraendert.
	ctrl.InsertTab(ctrl.GetTabCount(), _T("Hinten"));
	ctrl.GetActiveTab(nAktiv);
	if (nAktiv != 3)
		TT_Fail("aktiver Index nach dem Anhaengen ist %d, erwartet weiterhin 3", nAktiv);
	if (ctrl.m_nMeldungen != 0)
		TT_Fail("insgesamt %d Reiterwechsel gemeldet, erwartet 0", ctrl.m_nMeldungen);

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 4. DeleteTab

static void Test_DeleteTab(void)
{
	ProbeTabControl ctrl;
	int nAktiv = -99;

	TT_BeginTest("SECTabControlBase::DeleteTab: Liste und aktiver Index");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));
	ctrl.AddTab(_T("C"));
	ctrl.AddTab(_T("D"));
	ctrl.ActivateTab(2);				// C liegt obenauf
	ctrl.Zuruecksetzen();

	// Vor dem aktiven loeschen: der Index rutscht um eins nach unten,
	// obenauf liegt weiterhin C.
	ctrl.DeleteTab(0);
	{
		const char* szSoll[] = { "B", "C", "D" };
		ReihenfolgePruefen(ctrl, szSoll, 3);
	}
	ctrl.GetActiveTab(nAktiv);
	if (nAktiv != 1)
		TT_Fail("aktiver Index nach DeleteTab(0) ist %d, erwartet 1", nAktiv);
	if (strcmp(Beschriftung(ctrl, nAktiv), "C") != 0)
		TT_Fail("obenauf liegt \"%s\", erwartet weiterhin \"C\"", Beschriftung(ctrl, nAktiv));

	// Hinter dem aktiven loeschen laesst den Index unveraendert.
	ctrl.DeleteTab(2);					// D
	ctrl.GetActiveTab(nAktiv);
	if (nAktiv != 1)
		TT_Fail("aktiver Index nach dem Loeschen dahinter ist %d, erwartet 1", nAktiv);

	// Den aktiven selbst loeschen, und er war der letzte: der neue letzte
	// rueckt nach.
	ctrl.DeleteTab(1);					// C, war aktiv und letzter
	{
		const char* szSoll[] = { "B" };
		ReihenfolgePruefen(ctrl, szSoll, 1);
	}
	ctrl.GetActiveTab(nAktiv);
	if (nAktiv != 0)
		TT_Fail("aktiver Index nach dem Loeschen des letzten ist %d, erwartet 0", nAktiv);

	// Den letzten ueberhaupt loeschen: es gibt keinen aktiven mehr.
	ctrl.DeleteTab(0);
	if (ctrl.GetTabCount() != 0)
		TT_Fail("Liste hat noch %d Reiter", ctrl.GetTabCount());
	if (ctrl.GetActiveTab(nAktiv))
		TT_Fail("GetActiveTab liefert TRUE, obwohl die Liste leer ist (Index %d)", nAktiv);

	// Kein einziger dieser Schritte darf einen Reiterwechsel melden - das
	// Loeschen ist keine Auswahl durch den Anwender.
	if (ctrl.m_nMeldungen != 0)
		TT_Fail("das Loeschen hat %d Reiterwechsel gemeldet, erwartet 0", ctrl.m_nMeldungen);

	// Ungueltige Indizes tun nichts.
	ctrl.DeleteTab(0);
	ctrl.DeleteTab(-1);
	if (ctrl.GetTabCount() != 0)
		TT_Fail("DeleteTab auf leerer Liste hat etwas veraendert");

	TT_EndTest();
}

static void Test_DeleteTab_AktiverInDerMitte(void)
{
	ProbeTabControl ctrl;
	int nAktiv = -99;

	TT_BeginTest("SECTabControlBase::DeleteTab: der aktive Reiter mittendrin");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));
	ctrl.AddTab(_T("C"));
	ctrl.ActivateTab(1);				// B
	ctrl.Zuruecksetzen();

	ctrl.DeleteTab(1);					// den aktiven selbst
	{
		const char* szSoll[] = { "A", "C" };
		ReihenfolgePruefen(ctrl, szSoll, 2);
	}
	// Derselbe Index gilt weiter, dort steht jetzt C.
	ctrl.GetActiveTab(nAktiv);
	if (nAktiv != 1)
		TT_Fail("aktiver Index ist %d, erwartet 1", nAktiv);
	else if (strcmp(Beschriftung(ctrl, nAktiv), "C") != 0)
		TT_Fail("obenauf liegt \"%s\", erwartet \"C\"", Beschriftung(ctrl, nAktiv));

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 5. FindTab und TabExists
//
// FindTab ist die meistgenutzte Abfrage: WazooBar.cpp:175, 251, 298, 1749.

static void Test_FindTab(void)
{
	ProbeTabControl ctrl;
	ProbeKlient a(1), b(2), c(3), fremd(4);
	int nTab = -99;

	TT_BeginTest("SECTabControlBase::FindTab und TabExists");

	ctrl.AddTab(_T("A"), &a);
	ctrl.AddTab(_T("B"), &b);
	ctrl.AddTab(_T("C"), &c);

	if (!ctrl.FindTab(&b, nTab))	TT_Fail("FindTab findet den zweiten Reiter nicht");
	else if (nTab != 1)				TT_Fail("FindTab liefert Index %d, erwartet 1", nTab);

	if (!ctrl.FindTab(&a, nTab) || nTab != 0)	TT_Fail("FindTab(A) liefert Index %d, erwartet 0", nTab);
	if (!ctrl.FindTab(&c, nTab) || nTab != 2)	TT_Fail("FindTab(C) liefert Index %d, erwartet 2", nTab);

	// Ein unbekanntes Objekt: FALSE, und nTab wird auf -1 gesetzt.
	nTab = 99;
	if (ctrl.FindTab(&fremd, nTab))	TT_Fail("FindTab findet ein Objekt, das nicht in der Liste ist");
	if (nTab != -1)					TT_Fail("FindTab setzt nTab auf %d, erwartet -1", nTab);

	// NULL ist kein gueltiges Objekt - sonst faende FindTab jeden Reiter, der
	// ohne Objekt eingefuegt wurde.
	nTab = 99;
	if (ctrl.FindTab(NULL, nTab))	TT_Fail("FindTab(NULL) liefert TRUE");
	if (nTab != -1)					TT_Fail("FindTab(NULL) setzt nTab auf %d, erwartet -1", nTab);

	// Das ist keine Spitzfindigkeit: ohne diese Absicherung faende
	// FindTab(NULL) den folgenden Reiter.
	ctrl.AddTab(_T("Ohne Objekt"));
	nTab = 99;
	if (ctrl.FindTab(NULL, nTab))
		TT_Fail("FindTab(NULL) findet einen Reiter ohne Objekt (Index %d)", nTab);

	if (!ctrl.TabExists(&a))		TT_Fail("TabExists(A) liefert FALSE");
	if (ctrl.TabExists(&fremd))		TT_Fail("TabExists(fremd) liefert TRUE");

	if (!ctrl.TabExists(0))			TT_Fail("TabExists(0) liefert FALSE");
	if (!ctrl.TabExists(3))			TT_Fail("TabExists(3) liefert FALSE");
	if (ctrl.TabExists(4))			TT_Fail("TabExists(4) liefert TRUE bei 4 Reitern");
	if (ctrl.TabExists(-1))			TT_Fail("TabExists(-1) liefert TRUE");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 6. ActivateTab
//
// DIE Zusicherung dieser Familie. OTShim_Reiter.cpp zitiert dazu den
// Kommentar aus Eudora:
//     WazooBar.cpp:350-360  "In the SEC stuff, the ActivateTab() call
//     doesn't do anything if the tab is ALREADY active"
// Sie ist zugleich das, was den Ringlauf aufloest: SECTabWndBase::ActivateTab
// reicht IMMER weiter, die Basisfassung darunter ist untaetig - sonst liefe
// ActivateTab -> TCM_TABSEL -> OnTabSelect -> ActivateTab im Kreis.

static void Test_ActivateTab(void)
{
	ProbeTabControl ctrl;
	int nAktiv = -99;

	TT_BeginTest("SECTabControlBase::ActivateTab meldet den Wechsel genau einmal");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));
	ctrl.AddTab(_T("C"));
	ctrl.Zuruecksetzen();

	ctrl.ActivateTab(2);
	if (ctrl.m_nMeldungen != 1)
		TT_Fail("ActivateTab(2) hat %d Wechsel gemeldet, erwartet 1", ctrl.m_nMeldungen);
	if (ctrl.m_nLetzterReiter != 2)
		TT_Fail("gemeldet wurde Reiter %d, erwartet 2", ctrl.m_nLetzterReiter);
	if (!ctrl.GetActiveTab(nAktiv) || nAktiv != 2)
		TT_Fail("aktiver Reiter ist %d, erwartet 2", nAktiv);

	TT_EndTest();
}

static void Test_ActivateTab_SchonAktiv(void)
{
	ProbeTabControl ctrl;

	TT_BeginTest("SECTabControlBase::ActivateTab ist untaetig, wenn der Reiter schon obenauf liegt");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));
	ctrl.ActivateTab(1);
	ctrl.Zuruecksetzen();

	// Genau dieser Fall: CWazooBar::OnTimer aktiviert beim Ueberfahren im
	// Sekundentakt. Ohne diese Absicherung wuerde der obenauf liegende
	// Reiter dabei immer wieder neu aktiviert.
	ctrl.ActivateTab(1);
	ctrl.ActivateTab(1);
	ctrl.ActivateTab(1);
	if (ctrl.m_nMeldungen != 0)
		TT_Fail("dreimal denselben Reiter aktiviert: %d Meldungen, erwartet 0",
				ctrl.m_nMeldungen);

	// Ein anderer Reiter meldet sich dagegen sofort.
	ctrl.ActivateTab(0);
	if (ctrl.m_nMeldungen != 1)
		TT_Fail("Wechsel auf einen anderen Reiter: %d Meldungen, erwartet 1",
				ctrl.m_nMeldungen);

	// Ungueltige Indizes melden nichts und aendern nichts.
	ctrl.Zuruecksetzen();
	ctrl.ActivateTab(2);
	ctrl.ActivateTab(-1);
	if (ctrl.m_nMeldungen != 0)
		TT_Fail("ActivateTab mit ungueltigem Index hat %d Meldungen abgesetzt, erwartet 0",
				ctrl.m_nMeldungen);
	{
		int nAktiv = -99;
		if (!ctrl.GetActiveTab(nAktiv) || nAktiv != 0)
			TT_Fail("der aktive Reiter hat sich auf %d geaendert, erwartet 0", nAktiv);
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 7. Die Auswahlmarke folgt dem aktiven Reiter
//
// SetActiveTabQuiet begruendet das ausfuehrlich: CWazooBar::OnTimer aktiviert
// einen Reiter beim Ueberfahren nur, wenn er NICHT ausgewaehlt ist
// (WazooBar.cpp:1360). Waere m_bSelected vom aktiven Reiter entkoppelt,
// wuerde der obenauf liegende Reiter im Sekundentakt erneut aktiviert.

static void Test_Auswahlmarke(void)
{
	ProbeTabControl ctrl;

	TT_BeginTest("SECTabControlBase: die Auswahlmarke folgt genau dem aktiven Reiter");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));
	ctrl.AddTab(_T("C"));

	// Nach dem Aufbau ist der erste Reiter aktiv - und nur der ausgewaehlt.
	if (!IstAusgewaehlt(ctrl, 0))	TT_Fail("Reiter 0 ist nicht ausgewaehlt, obwohl er obenauf liegt");
	if (IstAusgewaehlt(ctrl, 1))	TT_Fail("Reiter 1 ist ausgewaehlt, obwohl Reiter 0 obenauf liegt");
	if (IstAusgewaehlt(ctrl, 2))	TT_Fail("Reiter 2 ist ausgewaehlt, obwohl Reiter 0 obenauf liegt");

	ctrl.ActivateTab(2);
	if (IstAusgewaehlt(ctrl, 0))	TT_Fail("Reiter 0 ist nach dem Wechsel noch ausgewaehlt");
	if (!IstAusgewaehlt(ctrl, 2))	TT_Fail("Reiter 2 ist nach dem Wechsel nicht ausgewaehlt");

	// SelectTab setzt die Marke unabhaengig vom aktiven Reiter - so kann
	// mehr als ein Reiter ausgewaehlt sein.
	ctrl.SelectTab(0);
	if (!IstAusgewaehlt(ctrl, 0))	TT_Fail("SelectTab(0) hat nicht gewirkt");
	if (!IstAusgewaehlt(ctrl, 2))	TT_Fail("SelectTab(0) hat die Marke von Reiter 2 geloescht");

	// ClearSelection loescht alle Marken - auch die des aktiven Reiters.
	ctrl.ClearSelection();
	if (IstAusgewaehlt(ctrl, 0) || IstAusgewaehlt(ctrl, 1) || IstAusgewaehlt(ctrl, 2))
		TT_Fail("nach ClearSelection ist noch ein Reiter ausgewaehlt");

	// Der naechste Wechsel stellt sie wieder her.
	ctrl.ActivateTab(1);
	if (!IstAusgewaehlt(ctrl, 1))	TT_Fail("nach ClearSelection und ActivateTab(1) ist Reiter 1 nicht ausgewaehlt");

	// Ungueltige Indizes tun nichts.
	ctrl.SelectTab(9);
	ctrl.SelectTab(-1);

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 8. SEC3DTabControl - was ueber die Basis hinausgeht

static void Test_3DTab_Erzeugung(void)
{
	ProbeTabControl ctrl;

	TT_BeginTest("SEC3DTabControl::CreateNewTab legt SEC3DTab an, nicht SECTab");

	ctrl.AddTab(_T("A"));

	{
		SEC3DTab* pTab = ctrl.Zeiger(0);
		if (pTab == NULL)
		{
			TT_Fail("GetTabPtr(0) liefert NULL");
			TT_EndTest();
			return;
		}
		// Das ist die Zusicherung, auf der QC3DTabWnd.cpp:58 aufsetzt: es
		// wandelt den Zeiger auf SEC3DTab herunter und liest m_hIcon.
		if (!pTab->IsKindOf(RUNTIME_CLASS(SEC3DTab)))
			TT_Fail("der angelegte Reiter ist kein SEC3DTab");

		// Vorgabewerte des frisch angelegten Reiters.
		if (pTab->m_hIcon != NULL)		TT_Fail("m_hIcon ist vorbelegt, erwartet NULL");
		if (!pTab->m_bEnabled)			TT_Fail("m_bEnabled ist FALSE, erwartet TRUE");
		if (!pTab->m_rect.IsRectEmpty())	TT_Fail("m_rect ist nicht leer");
	}

	if (ctrl.Zeiger(1) != NULL)		TT_Fail("GetTabPtr(1) liefert einen Zeiger bei einem Reiter");
	if (ctrl.Zeiger(-1) != NULL)	TT_Fail("GetTabPtr(-1) liefert einen Zeiger");

	TT_EndTest();
}

static void Test_3DTab_Symbol(void)
{
	ProbeTabControl ctrl;
	// Ein Symbolgriff, den niemand zeichnet - die Listenpflege reicht ihn
	// nur durch. Das Symbol gehoert laut ~SEC3DTab dem Aufrufer.
	HICON hSymbol = (HICON) 0xABCD;

	TT_BeginTest("SEC3DTabControl::SetTabIcon legt den Griff am Reiter ab");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));

	ctrl.SetTabIcon(1, hSymbol);
	if (ctrl.Zeiger(1) == NULL || ctrl.Zeiger(1)->m_hIcon != hSymbol)
		TT_Fail("m_hIcon des zweiten Reiters wurde nicht gesetzt");
	if (ctrl.Zeiger(0) != NULL && ctrl.Zeiger(0)->m_hIcon != NULL)
		TT_Fail("SetTabIcon(1, ...) hat auch den ersten Reiter veraendert");

	// Ungueltiger Index: nichts tun, nicht abstuerzen.
	ctrl.SetTabIcon(5, hSymbol);
	ctrl.SetTabIcon(-1, hSymbol);

	// Auf NULL zuruecksetzen muss ebenfalls gehen (WazooBar reicht das
	// Ergebnis von CWazooWnd::GetTabIconHandle durch, das NULL sein kann).
	ctrl.SetTabIcon(1, (HICON) NULL);
	if (ctrl.Zeiger(1) == NULL || ctrl.Zeiger(1)->m_hIcon != NULL)
		TT_Fail("m_hIcon liess sich nicht auf NULL zuruecksetzen");

	TT_EndTest();
}

static void Test_3DTab_Sperren(void)
{
	ProbeTabControl ctrl;

	TT_BeginTest("SEC3DTabControl::EnableTab und IsTabEnabled");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));

	if (!ctrl.IsTabEnabled(0))	TT_Fail("ein frisch angelegter Reiter ist gesperrt");
	if (!ctrl.IsTabEnabled(1))	TT_Fail("ein frisch angelegter Reiter ist gesperrt");

	ctrl.EnableTab(0, FALSE);
	if (ctrl.IsTabEnabled(0))	TT_Fail("EnableTab(0, FALSE) hat nicht gewirkt");
	if (!ctrl.IsTabEnabled(1))	TT_Fail("EnableTab(0, FALSE) hat auch Reiter 1 gesperrt");

	ctrl.EnableTab(0, TRUE);
	if (!ctrl.IsTabEnabled(0))	TT_Fail("EnableTab(0, TRUE) hat nicht gewirkt");

	// Ein Reiter, den es nicht gibt, gilt als gesperrt - so kann ein
	// Aufrufer nicht versehentlich auf einem NULL-Zeiger landen.
	if (ctrl.IsTabEnabled(7))	TT_Fail("IsTabEnabled(7) liefert TRUE bei zwei Reitern");
	if (ctrl.IsTabEnabled(-1))	TT_Fail("IsTabEnabled(-1) liefert TRUE");

	ctrl.EnableTab(7, FALSE);	// darf nichts tun
	ctrl.EnableTab(-1, FALSE);

	TT_EndTest();
}

static void Test_3DTab_Rechteck(void)
{
	ProbeTabControl ctrl;
	CRect rc(1, 2, 3, 4);

	TT_BeginTest("SEC3DTabControl::GetTabRect und TabHit arbeiten auf m_rect");

	ctrl.AddTab(_T("A"));

	// Ohne Fenster ordnet RecalcLayout nichts an, das Rechteck bleibt leer.
	ctrl.RufeGetTabRect(0, rc);
	if (!rc.IsRectEmpty())
		TT_Fail("GetTabRect(0) liefert ohne Fenster ein nicht leeres Rechteck");

	// Ein ungueltiger Index setzt das uebergebene Rechteck ausdruecklich auf
	// leer, statt es unangetastet zu lassen.
	rc.SetRect(1, 2, 3, 4);
	ctrl.RufeGetTabRect(9, rc);
	if (!rc.IsRectEmpty())
		TT_Fail("GetTabRect(9) hat das Rechteck nicht auf leer gesetzt");

	// TabHit rechnet gegen m_rect. Von Hand belegt, damit sich die Abfrage
	// ohne Anordnung pruefen laesst - QC3DTabWnd.cpp:152 fragt genau so.
	{
		SEC3DTab* pTab = ctrl.Zeiger(0);
		if (pTab == NULL)
		{
			TT_Fail("GetTabPtr(0) liefert NULL");
			TT_EndTest();
			return;
		}
		pTab->m_rect.SetRect(10, 20, 50, 40);

		CPoint ptDrin(30, 30);
		CPoint ptDraussen(5, 5);
		CPoint ptRandLinksOben(10, 20);		// gehoert dazu
		CPoint ptRandRechtsUnten(50, 40);	// gehoert NICHT dazu

		if (!ctrl.RufeTabHit(0, ptDrin))				TT_Fail("TabHit trifft einen Punkt mittendrin nicht");
		if (ctrl.RufeTabHit(0, ptDraussen))				TT_Fail("TabHit trifft einen Punkt ausserhalb");
		if (!ctrl.RufeTabHit(0, ptRandLinksOben))		TT_Fail("die linke obere Ecke gilt nicht als Treffer");
		if (ctrl.RufeTabHit(0, ptRandRechtsUnten))		TT_Fail("die rechte untere Ecke gilt als Treffer");

		ctrl.RufeGetTabRect(0, rc);
		if (rc != CRect(10, 20, 50, 40))
			TT_Fail("GetTabRect liefert (%ld,%ld,%ld,%ld), erwartet (10,20,50,40)",
					rc.left, rc.top, rc.right, rc.bottom);

		// Ein Reiter, den es nicht gibt, wird nie getroffen.
		if (ctrl.RufeTabHit(9, ptDrin))		TT_Fail("TabHit(9, ...) liefert TRUE");
	}

	TT_EndTest();
}

static void Test_3DTab_OhneFensterFolgenlos(void)
{
	ProbeTabControl ctrl;

	// Diese Methoden zeichnen oder blaettern. Ohne Fenster muessen sie
	// stillschweigend nichts tun - jede von ihnen ist eine Stelle, an der
	// ein fehlendes GetSafeHwnd() zu einem Absturz fuehren wuerde.
	TT_BeginTest("SEC3DTabControl: Zeichen- und Blaetterwege ohne Fenster sind folgenlos");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));
	ctrl.ActivateTab(1);

	ctrl.RecalcLayout();
	ctrl.ScrollToTab(0);
	ctrl.ScrollToTab(1);
	ctrl.ScrollToTab(9);
	ctrl.InvalidateTab(0);
	ctrl.InvalidateTab(9);

	if (ctrl.GetTabCount() != 2)
		TT_Fail("die Liste hat sich dabei veraendert: %d Reiter", ctrl.GetTabCount());
	if (ctrl.RufeGetLabelWidth(0) != 0)
		TT_Fail("GetLabelWidth liefert ohne Fenster %d, erwartet 0", ctrl.RufeGetLabelWidth(0));

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 9. BEFUND: zwei Stellen fassen das Fenster an, bevor sie es pruefen
//
// GEMESSEN. Beim ersten Lauf der Tests oben schrieb das Testprogramm zehn
// Zeilen auf stderr:
//
//     ...\ATLMFC\Include\afxwin2.inl(213) : Assertion failed!
//
// Zeile 213 ist CWnd::GetParent:
//     _AFXWIN_INLINE CWnd* CWnd::GetParent() const
//         { ASSERT(::IsWindow(m_hWnd)); return CWnd::FromHandle(::GetParent(m_hWnd)); }
//
// Die zehn Meldungen decken sich Stueck fuer Stueck mit den neun Aufrufen von
// ActivateTab und dem einen von ClearSelection in den Tests oben. Beide
// Methoden holen sich das Elternfenster, BEVOR sie pruefen, ob es das eigene
// Fenster ueberhaupt gibt:
//
//     OTShim_Reiter.cpp:330  SECTabControlBase::OnActivateTab
//     OTShim_Reiter.cpp:358  SECTabControlBase::ClearSelection
//         CWnd* pParent = GetParent();
//         if (pParent != NULL && ::IsWindow(pParent->GetSafeHwnd()))
//             pParent->SendMessage(...);
//
// Die Absicht ist erkennbar - "ohne gueltiges Elternfenster nichts tun" -,
// die Pruefung steht nur einen Schritt zu spaet. Ueberall sonst in derselben
// Datei steht zuerst  if (GetSafeHwnd() != NULL).
//
// IN EUDORA SELBST loest das nichts aus: das Steuerelement entsteht in
// SECTabWndBase::CreateTabCtrl unmittelbar mit einem Fenster, und
// CWazooBar ruft ActivateTab erst danach (WazooBar.cpp:347, 408, 1364). Der
// Befund ist also eine Haertungsluecke, kein belegter Absturz. Er bleibt
// trotzdem als roter Test stehen, weil er im Debugbau ein Meldungsfenster
// aufmachen wuerde, sobald der Weg doch einmal ohne Fenster genommen wird -
// und weil er sich mit zwei Zeilen schliessen laesst.
//
// REPARATUR NICHT HIER: OTShim_Reiter.cpp gehoert einem anderen Agenten.
// Eingetragen in BEFUNDE.md, Abschnitt "Gefunden durch PROBE".

static void Test_Befund_GetParentOhneFenster(void)
{
	ProbeTabControl ctrl;
	int nZusicherungen;

	TT_BeginTest("BEFUND: ActivateTab und ClearSelection fassen GetParent an, bevor sie das Fenster pruefen");

	ctrl.AddTab(_T("A"));
	ctrl.AddTab(_T("B"));

	ZaehlerStarten();
	ctrl.ActivateTab(1);		// -> OnActivateTab -> GetParent()
	ctrl.ClearSelection();		// -> GetParent()
	nZusicherungen = ZaehlerBeenden();

	if (nZusicherungen != 0)
		TT_Fail("%d MFC-Zusicherung(en) ausgeloest, erwartet 0 "
				"(GetParent vor der Fensterpruefung, OTShim_Reiter.cpp:330 und :358)",
				nZusicherungen);

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////

void RunOTShimReiterTests(void)
{
	TT_Suite("OTShim_Reiter - Listenpflege von SECTabControlBase");
	Test_AddTab();
	Test_InsertTab_Index();
	Test_InsertTab_Angaben();
	Test_InsertTab_OhneBeschriftung();
	Test_ErsterReiterWirdAktiv();
	Test_EinfuegenVerschiebtAktiven();
	Test_DeleteTab();
	Test_DeleteTab_AktiverInDerMitte();
	Test_FindTab();
	Test_ActivateTab();
	Test_ActivateTab_SchonAktiv();
	Test_Auswahlmarke();

	TT_Suite("OTShim_Reiter - SEC3DTabControl");
	Test_3DTab_Erzeugung();
	Test_3DTab_Symbol();
	Test_3DTab_Sperren();
	Test_3DTab_Rechteck();
	Test_3DTab_OhneFensterFolgenlos();

	TT_Suite("OTShim_Reiter - Befunde");
	Test_Befund_GetParentOhneFenster();
}

//
// UNGEPRUEFT GEBLIEBEN - und warum
//
//   SECTabWndBase und SEC3DTabWnd (die Fensterebene)
//       Das ist die Ebene, die Eudora wirklich anfasst - CWazooBar::m_wndTab
//       ist ein QC3DTabWnd. Sie ist hier nicht pruefbar, und zwar nicht aus
//       Bequemlichkeit: SECTabWndBase::InsertTab ruft im else-Zweig
//       pWnd->ShowWindow(SW_HIDE) OHNE vorherige ::IsWindow-Pruefung (anders
//       als ZeigeInhaltsfenster daneben, das sie hat). Mit einem
//       Inhaltsfenster ohne HWND laeuft der Test damit in eine
//       MFC-Zusicherung. In Eudora ist das kein Fehler - die CWazooWnd sind
//       vor dem Einfuegen angelegt (WazooBar.cpp:178-179 ruft unmittelbar
//       danach SetParent, was ein Fenster voraussetzt) -, aber es macht die
//       Ebene ohne echte Fenster unpruefbar. Ein Test dafuer muesste echte
//       Fenster anlegen und wieder abraeumen; das ist ausdruecklich nicht
//       Gegenstand dieses Testprogramms.
//
//   Der Ringlauf ActivateTab -> TCM_TABSEL -> OnTabSelect
//       Braucht zwei echte Fenster und eine Nachricht. Was sich davon ohne
//       Fenster pruefen laesst, ist der Baustein, der ihn aufloest: die
//       Basisfassung von ActivateTab ist untaetig, wenn der Reiter schon
//       obenauf liegt. Genau das prueft Test_ActivateTab_SchonAktiv.
//
//   Das gesamte Zeichnen (DrawTab, DrawTabTop/Bottom/Left/Right,
//   DrawInterior, DrawDisabled, VLine3D, HLine3D, OnPaint) und die
//   Anordnung in RecalcLayout
//       Brauchen einen Geraetekontext und ein Fenster mit Groesse. Geprueft
//       ist nur, dass sie ohne Fenster folgenlos bleiben.
//
//   SEC3DTabControl::ModifyStyle
//       Setzt m_dwTabStyle und faellt auf TCS_TABS_ON_BOTTOM zurueck, wenn
//       kein Anordnungsbit uebrigbleibt - das waere pruefbar. Die Methode
//       ruft danach aber CWnd::ModifyStyle, und das setzt ein Fenster
//       voraus. Ein Test dafuer wuerde bei jedem Lauf eine MFC-Zusicherung
//       auf stderr schreiben; der Erkenntnisgewinn wiegt das nicht auf.
//
//   Die Kurzhinweise (OnToolHitTest)
//       Haengen an der MFC-eigenen Verwaltung und sind schon im Kommentarkopf
//       von OTShim_Reiter.h als ungeprueft gekennzeichnet.
//
