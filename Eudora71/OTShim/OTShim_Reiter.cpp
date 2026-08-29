// OTShim_Reiter.cpp - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1,
//                     Registerkarten-Familie
//
// Zu OTShim_Reiter.h. Die Begruendung jeder Entscheidung - warum die Familie
// nicht entfallen kann, warum eigengezeichnet statt CTabCtrl, welche
// Aufrufstellen in Eudora abgedeckt sind - steht im Kopf jenes Headers und
// wird hier nicht wiederholt.
//
// WAS ECHT UMGESETZT IST
//   Die gesamte Listenpflege (Einfuegen, Loeschen, Suchen, Umbenennen,
//   Symbole, aktiver Reiter), die Anordnung, das Zeichnen, der
//   Fensterwechsel und die Nachrichtenkette TCM_TABSEL. Ohne das bliebe jede
//   Wazoo-Leiste leer.
//
// WAS RUMPF GEBLIEBEN IST (jeweils an Ort und Stelle begruendet)
//   SECTabWndBase::CreateScrollBarCtrl, ::SetScrollStyle
//       Bildlaufleisten gibt es nur in der 2D-Familie (tabwnd.h:83,
//       SECTabWnd::GetScrollBar). SEC3DTabWnd hat keine; Eudora ruft beides
//       nie auf.
//   SECTabWndBase::ActivateTab(CWnd*, int)
//       Die zweistellige Fassung waehlt im Original einen von mehreren
//       Bereichen. SEC3DTabWnd hat nur einen. Eudora ruft nur die
//       einstelligen Fassungen auf.
//   SECTabControlBase::SetTabIcon
//       SECTab hat kein Symbolfeld (tabctrlb.h:39-45); erst SEC3DTab hat
//       m_hIcon (tabctrl3.h:56). Die Basisfassung kann also nichts tun.
//   SECTabControlBase::RecalcLayout, ::ScrollToTab
//       Die Basis kennt keine Reiterrechtecke - die stehen erst in SEC3DTab.
//
// UEBERSETZUNG: die Datei bindet <afxwin.h> selbst ein und benutzt Eudoras
// vorkompilierten Header nicht. Beim Einhaengen in Eudora.vcxproj daher fuer
// diese Datei "Vorkompilierte Header: Nicht verwenden" (/Y-) setzen - genau
// wie fuer OTShim.cpp und OTShim_Bild.cpp. Der Suchpfad muss
// ..\OT501\Include enthalten (steht dort bereits).
//
// Kodierung: reines ASCII, kein BOM.

#include <afxwin.h>

#include "OTShim_Reiter.h"


/////////////////////////////////////////////////////////////////////////////
// Kleine gemeinsame Hilfen

// Rand innerhalb eines Reiters bis zum Inhalt
#define REITER_RAND_X	4
#define REITER_RAND_Y	3
// Abstand zwischen Symbol und Beschriftung
#define REITER_LUECKE	4


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// SECTab
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNAMIC(SECTab, CObject)

SECTab::SECTab()
{
	m_nWidth = 0;
	m_nHeight = 0;
	m_bSelected = FALSE;
	m_pClient = NULL;
	m_hMenu = 0;
	m_pExtra = NULL;
}

SECTab::~SECTab()
{
	// Weder m_pClient noch m_hMenu noch m_pExtra gehoeren dem Reiter.
	// Eudora reicht ein CWazooWnd herein und zerstoert es selbst
	// (WazooBar.cpp:1218-1220).
}

#ifdef _DEBUG
void SECTab::AssertValid() const
{
	CObject::AssertValid();
}

void SECTab::Dump(CDumpContext& dc) const
{
	CObject::Dump(dc);
	dc << "m_csLabel = " << m_csLabel << "\n";
	dc << "m_bSelected = " << m_bSelected << "\n";
}
#endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// SECTabControlBase
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNAMIC(SECTabControlBase, CWnd)

BEGIN_MESSAGE_MAP(SECTabControlBase, CWnd)
	//{{AFX_MSG_MAP(SECTabControlBase)
	ON_WM_DESTROY()
	ON_WM_SETCURSOR()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


SECTabControlBase::SECTabControlBase()
{
	m_pTabArray = new CObArray;
	m_nActiveTab = -1;
	m_bActiveTab = FALSE;
	m_hcurArrow = NULL;
}

SECTabControlBase::~SECTabControlBase()
{
	if (m_pTabArray != NULL)
	{
		// Loeschen ueber den CObject-Zeiger: ~SECTab ist wie im Original
		// geschuetzt (tabctrlb.h:51), CObject::~CObject dagegen oeffentlich
		// und virtuell. Die Zugriffspruefung greift damit an CObject, die
		// Ausfuehrung landet trotzdem bei ~SECTab.
		for (int i = 0; i < m_pTabArray->GetSize(); i++)
		{
			CObject* pObj = m_pTabArray->GetAt(i);
			delete pObj;
		}
		m_pTabArray->RemoveAll();
		delete m_pTabArray;
		m_pTabArray = NULL;
	}
}


/////////////////////////////////////////////////////////////////////////////
// Erzeugen

BOOL SECTabControlBase::Create(DWORD dwStyle, const RECT& rect, CWnd* pParentWnd, UINT nID)
{
	ASSERT(pParentWnd != NULL);
	if (pParentWnd == NULL)
		return FALSE;

	Initialize(dwStyle);

	// WS_CHILD wird hier ergaenzt, nicht vorausgesetzt: Eudora uebergibt nur
	// WS_VISIBLE und die Anordnungsbits
	// (QC3DTabWnd.cpp:526  m_pTabCtrl->Create(WS_VISIBLE | m_dwTabCtrlStyle, ...)).
	// CS_DBLCLKS ist noetig, damit WM_LBUTTONDBLCLK ueberhaupt entsteht
	// (tabctrl3.h:162 verlangt einen Handler dafuer).
	LPCTSTR lpszClass = ::AfxRegisterWndClass(CS_DBLCLKS, m_hcurArrow, NULL, NULL);

	if (!CWnd::Create(lpszClass, NULL,
					  dwStyle | WS_CHILD | WS_CLIPSIBLINGS,
					  rect, pParentWnd, nID))
		return FALSE;

	RecalcLayout();
	return TRUE;
}

void SECTabControlBase::Initialize(DWORD /*dwStyle*/)
{
	if (m_hcurArrow == NULL)
		m_hcurArrow = ::LoadCursor(NULL, IDC_ARROW);
}

SECTab* SECTabControlBase::CreateNewTab() const
{
	return new SECTab;
}

void SECTabControlBase::RecalcLayout()
{
	// RUMPF mit Absicht: die Basis kennt keine Reiterrechtecke. m_rect
	// existiert erst in SEC3DTab (tabctrl3.h:55), die Anordnung deshalb erst
	// in SEC3DTabControl::RecalcLayout.
}


/////////////////////////////////////////////////////////////////////////////
// Listenpflege

SECTab* SECTabControlBase::InsertTab(int nIndex, LPCTSTR lpszLabel,
									 CObject* pClient, HMENU hMenu, void* pExtra)
{
	ASSERT(m_pTabArray != NULL);

	const int nCount = GetTabCount();
	if (nIndex < 0 || nIndex > nCount)
		nIndex = nCount;

	SECTab* pTab = CreateNewTab();
	if (pTab == NULL)
		return NULL;

	if (lpszLabel != NULL)
		pTab->m_csLabel = lpszLabel;
	pTab->m_pClient = pClient;
	pTab->m_hMenu = hMenu;
	pTab->m_pExtra = pExtra;

	m_pTabArray->InsertAt(nIndex, (CObject*) pTab);

	// Der erste Reiter wird aktiv, ohne dass ein Wechsel gemeldet wird -
	// sonst bekaeme CWazooBar schon beim Aufbau der Leiste einen
	// Reiterwechsel und wuerde die Wazoos vorzeitig anstossen. Wird spaeter
	// vor dem aktiven Reiter eingefuegt, verschiebt sich dessen Index, ohne
	// dass ein Wechsel stattgefunden haette.
	if (m_nActiveTab < 0)
		SetActiveTabQuiet(nIndex);
	else if (nIndex <= m_nActiveTab)
		SetActiveTabQuiet(m_nActiveTab + 1);
	else
		SetActiveTabQuiet(m_nActiveTab);

	RecalcLayout();
	if (GetSafeHwnd() != NULL)
		Invalidate();

	return pTab;
}

SECTab* SECTabControlBase::AddTab(LPCTSTR lpszLabel, CObject* pClient,
								  HMENU hMenu, void* pExtra)
{
	return SECTabControlBase::InsertTab(GetTabCount(), lpszLabel, pClient, hMenu, pExtra);
}

void SECTabControlBase::DeleteTab(int nTab)
{
	if (!TabExists(nTab))
		return;

	CObject* pObj = m_pTabArray->GetAt(nTab);
	m_pTabArray->RemoveAt(nTab);
	delete pObj;			// siehe Erlaeuterung im Destruktor

	const int nCount = GetTabCount();
	if (nCount == 0)
		SetActiveTabQuiet(-1);
	else if (nTab < m_nActiveTab)
		SetActiveTabQuiet(m_nActiveTab - 1);
	else if (nTab == m_nActiveTab)
		SetActiveTabQuiet(nTab < nCount ? nTab : nCount - 1);
	else
		SetActiveTabQuiet(m_nActiveTab);

	RecalcLayout();
	if (GetSafeHwnd() != NULL)
		Invalidate();
}

void SECTabControlBase::RenameTab(int nTab, LPCTSTR lpszLabel)
{
	SECTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL)
		return;

	pTab->m_csLabel = (lpszLabel != NULL) ? lpszLabel : _T("");
	RecalcLayout();
	if (GetSafeHwnd() != NULL)
		Invalidate();
}


/////////////////////////////////////////////////////////////////////////////
// Aktiver Reiter und Auswahl

void SECTabControlBase::SetActiveTabQuiet(int nTab)
{
	const int nCount = GetTabCount();
	if (nTab < 0 || nTab >= nCount)
	{
		m_nActiveTab = -1;
		m_bActiveTab = FALSE;
	}
	else
	{
		m_nActiveTab = nTab;
		m_bActiveTab = TRUE;
	}

	// Die Auswahlmarke folgt dem aktiven Reiter. Eudora wertet sie an einer
	// Stelle aus: CWazooBar::QCTabHitTest liefert sie zurueck
	// (WazooBar.cpp:487), und CWazooBar::OnTimer aktiviert einen Reiter beim
	// Ueberfahren nur, wenn er NICHT ausgewaehlt ist (WazooBar.cpp:1360).
	// Waere m_bSelected von m_nActiveTab entkoppelt, wuerde der bereits
	// obenauf liegende Reiter im Sekundentakt erneut aktiviert.
	for (int i = 0; i < nCount; i++)
	{
		SECTab* pTab = GetTabPtr(i);
		if (pTab != NULL)
			pTab->m_bSelected = (i == m_nActiveTab);
	}
}

void SECTabControlBase::ActivateTab(int nTab)
{
	if (!TabExists(nTab))
		return;

	// Untaetig, wenn der Reiter schon obenauf liegt. Eudora verlaesst sich
	// ausdruecklich darauf und gleicht es selbst aus:
	//     WazooBar.cpp:350-360  "In the SEC stuff, the ActivateTab() call
	//     doesn't do anything if the tab is ALREADY active"
	if (m_bActiveTab && m_nActiveTab == nTab)
		return;

	const int nAlt = m_nActiveTab;
	SetActiveTabQuiet(nTab);

	if (nAlt >= 0)
		InvalidateTab(nAlt);
	InvalidateTab(nTab);

	OnActivateTab(nTab);
}

void SECTabControlBase::OnActivateTab(int nTab)
{
	// Der Reiterwechsel geht als TCM_TABSEL an das Elternfenster. Dort
	// haengt SECTabWndBase::OnTabSelect, das den Fensterwechsel vornimmt und
	// die Nachricht an die Wazoo-Leiste weiterreicht - nur so erreicht sie
	// CWazooBar::OnTabSelect (WazooBar.cpp:51).
	CWnd* pParent = GetParent();
	if (pParent != NULL && ::IsWindow(pParent->GetSafeHwnd()))
		pParent->SendMessage(TCM_TABSEL, (WPARAM) nTab, 0);
}

void SECTabControlBase::SelectTab(int nTab)
{
	SECTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL)
		return;

	pTab->m_bSelected = TRUE;
	InvalidateTab(nTab);
}

void SECTabControlBase::ClearSelection()
{
	const int nCount = GetTabCount();
	for (int i = 0; i < nCount; i++)
	{
		SECTab* pTab = GetTabPtr(i);
		if (pTab != NULL)
			pTab->m_bSelected = FALSE;
	}

	if (GetSafeHwnd() != NULL)
		Invalidate();

	CWnd* pParent = GetParent();
	if (pParent != NULL && ::IsWindow(pParent->GetSafeHwnd()))
		pParent->SendMessage(TCM_TABSELCLR, 0, 0);
}

void SECTabControlBase::ScrollToTab(int /*nTab*/)
{
	// RUMPF mit Absicht: ohne Reiterrechtecke laesst sich nichts in den
	// Sichtbereich holen. SEC3DTabControl::ScrollToTab setzt es um.
}

void SECTabControlBase::InvalidateTab(int /*nTab*/)
{
	// Die Basis kennt das Rechteck des einzelnen Reiters nicht, also wird
	// das ganze Fenster neu gezeichnet. SEC3DTabControl schraenkt es ein.
	if (GetSafeHwnd() != NULL)
		Invalidate();
}


/////////////////////////////////////////////////////////////////////////////
// Symbole

void SECTabControlBase::SetTabIcon(int /*nIndex*/, HICON /*hIcon*/)
{
	// RUMPF mit Absicht: SECTab hat kein Symbolfeld (tabctrlb.h:39-45).
	// Erst SEC3DTab bringt m_hIcon mit (tabctrl3.h:56), und
	// SEC3DTabControl ueberschreibt diese Methode entsprechend.
}

void SECTabControlBase::SetTabIcon(int /*nIndex*/, UINT /*nIDIcon*/)
{
}

void SECTabControlBase::SetTabIcon(int /*nIndex*/, LPCTSTR /*lpszResourceName*/)
{
}


/////////////////////////////////////////////////////////////////////////////
// Abfragen

int SECTabControlBase::GetTabCount() const
{
	return (m_pTabArray != NULL) ? (int) m_pTabArray->GetSize() : 0;
}

BOOL SECTabControlBase::TabExists(int nTab) const
{
	return (nTab >= 0 && nTab < GetTabCount());
}

BOOL SECTabControlBase::TabExists(CObject* pClient) const
{
	int nTab = -1;
	return FindTab(pClient, nTab);
}

BOOL SECTabControlBase::FindTab(const CObject* const pClient, int& nTab) const
{
	nTab = -1;
	if (pClient == NULL)
		return FALSE;

	const int nCount = GetTabCount();
	for (int i = 0; i < nCount; i++)
	{
		SECTab* pTab = GetTabPtr(i);
		if (pTab != NULL && pTab->m_pClient == pClient)
		{
			nTab = i;
			return TRUE;
		}
	}
	return FALSE;
}

BOOL SECTabControlBase::GetActiveTab(int& nTab) const
{
	nTab = m_nActiveTab;
	return (m_bActiveTab && m_nActiveTab >= 0 && m_nActiveTab < GetTabCount());
}

BOOL SECTabControlBase::GetTabInfo(int nTab, LPCTSTR& lpszLabel, BOOL& bSelected,
								   CObject*& pClient, HMENU& hMenu, void*& pExtra) const
{
	SECTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL)
		return FALSE;

	// Der Zeiger zeigt in den Puffer des CString im Reiter und bleibt
	// gueltig, solange der Reiter lebt. Eudora haelt ihn nie ueber den
	// Aufruf hinaus (WazooBar.cpp:336, 427, 487, 810, 1205, 1497).
	lpszLabel = (LPCTSTR) pTab->m_csLabel;
	bSelected = pTab->m_bSelected;
	pClient = pTab->m_pClient;
	hMenu = pTab->m_hMenu;
	pExtra = pTab->m_pExtra;
	return TRUE;
}

SECTab& SECTabControlBase::GetTab(int nTab) const
{
	SECTab* pTab = GetTabPtr(nTab);
	ASSERT(pTab != NULL);
	return *pTab;
}

SECTab* SECTabControlBase::GetTabPtr(int nTab) const
{
	if (!TabExists(nTab))
		return NULL;
	return (SECTab*) m_pTabArray->GetAt(nTab);
}


/////////////////////////////////////////////////////////////////////////////
// Nachrichten

void SECTabControlBase::OnDestroy()
{
	DestroyGDIObjects();

	if (m_pTabArray != NULL)
	{
		for (int i = 0; i < m_pTabArray->GetSize(); i++)
		{
			CObject* pObj = m_pTabArray->GetAt(i);
			delete pObj;
		}
		m_pTabArray->RemoveAll();
	}
	SetActiveTabQuiet(-1);

	CWnd::OnDestroy();
}

BOOL SECTabControlBase::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if (m_hcurArrow != NULL && nHitTest == HTCLIENT)
	{
		::SetCursor(m_hcurArrow);
		return TRUE;
	}
	return CWnd::OnSetCursor(pWnd, nHitTest, message);
}

#ifdef _DEBUG
void SECTabControlBase::AssertValid() const
{
	CWnd::AssertValid();
	ASSERT(m_pTabArray != NULL);
}

void SECTabControlBase::Dump(CDumpContext& dc) const
{
	CWnd::Dump(dc);
	dc << "m_nActiveTab = " << m_nActiveTab << "\n";
	dc << "Reiter = " << GetTabCount() << "\n";
}
#endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// SEC3DTab
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNAMIC(SEC3DTab, SECTab)

SEC3DTab::SEC3DTab()
{
	m_rect.SetRectEmpty();
	m_hIcon = NULL;
	m_bEnabled = TRUE;
}

SEC3DTab::~SEC3DTab()
{
	// m_hIcon gehoert dem Aufrufer. Eudora reicht
	// CWazooWnd::GetTabIconHandle herein (WazooBar.cpp:177, 300) und
	// verwaltet das Symbol selbst - hier darf nichts zerstoert werden.
}

#ifdef _DEBUG
void SEC3DTab::AssertValid() const
{
	SECTab::AssertValid();
}

void SEC3DTab::Dump(CDumpContext& dc) const
{
	SECTab::Dump(dc);
	dc << "m_bEnabled = " << m_bEnabled << "\n";
}
#endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// SEC3DTabControl
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNAMIC(SEC3DTabControl, SECTabControlBase)

BEGIN_MESSAGE_MAP(SEC3DTabControl, SECTabControlBase)
	//{{AFX_MSG_MAP(SEC3DTabControl)
	ON_WM_DESTROY()
	ON_WM_PAINT()
	ON_WM_ERASEBKGND()
	ON_WM_LBUTTONDOWN()
	ON_WM_SIZE()
	ON_WM_LBUTTONDBLCLK()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


SEC3DTabControl::SEC3DTabControl()
{
	m_bShowTabLabels = TRUE;
#ifdef WIN32
	// Bleibt NULL. Die Kurzhinweise laufen ueber die MFC-eigene
	// Verwaltung (EnableToolTips + OnToolHitTest), die kein eigenes
	// CToolTipCtrl braucht. Das Feld steht nur da, weil tabctrl3.h:130 es
	// vorschreibt und abgeleitete Klassen es sehen koennten.
	m_pToolTip = NULL;
#endif
	m_rgbText[SEC3DTAB_INACTIVE] = ::GetSysColor(COLOR_BTNTEXT);
	m_rgbText[SEC3DTAB_ACTIVE] = ::GetSysColor(COLOR_BTNTEXT);

	m_dwTabStyle = TCS_TABS_ON_BOTTOM;
	m_nScrollOffset = 0;
	m_nRowExtent = 20;
	m_nStripExtent = 22;
}

SEC3DTabControl::~SEC3DTabControl()
{
	SEC3DTabControl::DestroyGDIObjects();
}


/////////////////////////////////////////////////////////////////////////////
// Aufbau

void SEC3DTabControl::Initialize(DWORD dwStyle)
{
	SECTabControlBase::Initialize(dwStyle);

	// Die Anordnung wird als eigenes Feld gefuehrt, nicht als Fensterstil.
	// Grund: tabctrlb.h:68-71 belegt 0x0010 bis 0x0080, und genau diese
	// Bits sind in commctrl.h mit TCS_FORCEICONLEFT, TCS_FORCELABELLEFT,
	// TCS_HOTTRACK und TCS_VERTICAL belegt. Beim Fenster sind sie
	// klassenspezifisch und damit bedeutungslos, aber sie ueber GetStyle()
	// zurueckzulesen waere trotzdem heikel, sobald jemand ModifyStyle mit
	// echten Steuerelementstilen aufruft.
	m_dwTabStyle = dwStyle & TCS_TAB_ORIENTATIONS;
	if (m_dwTabStyle == 0)
		m_dwTabStyle = TCS_TABS_ON_BOTTOM;

	InitializeFonts(dwStyle);

	DestroyGDIObjects();		// Stifte und Pinsel neu, Schriften bleiben
	m_pens[SEC3DTAB_INACTIVE].CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_3DDKSHADOW));
	m_pens[SEC3DTAB_ACTIVE].CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_3DDKSHADOW));
	m_penShadow.CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_BTNSHADOW));
	m_penWhite.CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_BTNHIGHLIGHT));
	m_brushes[SEC3DTAB_INACTIVE].CreateSolidBrush(::GetSysColor(COLOR_BTNFACE));
	m_brushes[SEC3DTAB_ACTIVE].CreateSolidBrush(::GetSysColor(COLOR_BTNHIGHLIGHT));
	m_rgbText[SEC3DTAB_INACTIVE] = ::GetSysColor(COLOR_BTNTEXT);
	m_rgbText[SEC3DTAB_ACTIVE] = ::GetSysColor(COLOR_BTNTEXT);

	// Kurzhinweise: sobald die Beschriftung nicht mehr passt, zeigen die
	// Reiter nur noch Symbole. OnToolHitTest liefert dann den Text.
	EnableToolTips(TRUE);
}

void SEC3DTabControl::InitializeFonts(DWORD /*dwStyle*/)
{
	LOGFONT lf;
	::ZeroMemory(&lf, sizeof(lf));

	NONCLIENTMETRICS ncm;
	::ZeroMemory(&ncm, sizeof(ncm));
	ncm.cbSize = sizeof(NONCLIENTMETRICS);
	if (::SystemParametersInfo(SPI_GETNONCLIENTMETRICS, sizeof(NONCLIENTMETRICS), &ncm, 0))
	{
		lf = ncm.lfMessageFont;
	}
	else
	{
		// Rueckfall, falls SPI_GETNONCLIENTMETRICS scheitert (kommt bei
		// abweichender Strukturgroesse zwischen SDK und System vor).
		CFont* pFont = CFont::FromHandle((HFONT) ::GetStockObject(DEFAULT_GUI_FONT));
		if (pFont == NULL || pFont->GetLogFont(&lf) == 0)
			return;
	}

	if (m_fonts[SEC3DTAB_INACTIVE].GetSafeHandle() != NULL)
		m_fonts[SEC3DTAB_INACTIVE].DeleteObject();
	m_fonts[SEC3DTAB_INACTIVE].CreateFontIndirect(&lf);

	// Der aktive Reiter wird fett gesetzt - das ist der einzige Unterschied,
	// der ohne Farbwahl auch bei hohem Kontrast erkennbar bleibt.
	lf.lfWeight = FW_BOLD;
	if (m_fonts[SEC3DTAB_ACTIVE].GetSafeHandle() != NULL)
		m_fonts[SEC3DTAB_ACTIVE].DeleteObject();
	m_fonts[SEC3DTAB_ACTIVE].CreateFontIndirect(&lf);
}

void SEC3DTabControl::DestroyGDIObjects()
{
	for (int i = 0; i < 2; i++)
	{
		if (m_pens[i].GetSafeHandle() != NULL)
			m_pens[i].DeleteObject();
		if (m_brushes[i].GetSafeHandle() != NULL)
			m_brushes[i].DeleteObject();
	}
	if (m_penShadow.GetSafeHandle() != NULL)
		m_penShadow.DeleteObject();
	if (m_penWhite.GetSafeHandle() != NULL)
		m_penWhite.DeleteObject();

	// Die Schriften bleiben absichtlich stehen: DestroyGDIObjects wird auch
	// bei einem Farbwechsel gerufen, und die Schrift haengt nicht an den
	// Systemfarben. InitializeFonts loescht sie selbst, bevor es neu anlegt.
}

SECTab* SEC3DTabControl::CreateNewTab() const
{
	return new SEC3DTab;
}


/////////////////////////////////////////////////////////////////////////////
// Anordnung

void SEC3DTabControl::RecalcLayout()
{
	if (GetSafeHwnd() == NULL)
		return;

	const int nCount = GetTabCount();
	CRect rcClient;
	GetClientRect(rcClient);

	CClientDC dc(this);
	CFont* pAltFont = dc.SelectObject(&m_fonts[SEC3DTAB_ACTIVE]);
	TEXTMETRIC tm;
	::ZeroMemory(&tm, sizeof(tm));
	dc.GetTextMetrics(&tm);

	const int cxIcon = ::GetSystemMetrics(SM_CXSMICON);
	const int cyIcon = ::GetSystemMetrics(SM_CYSMICON);
	const int cyText = tm.tmHeight;
	m_nRowExtent = ((cyText > cyIcon) ? cyText : cyIcon) + 2 * REITER_RAND_Y + 2;

	const BOOL bWaagerecht = IstWaagerecht();

	// Zwei Durchgaenge: erst mit Beschriftung, und wenn die Reiter dann
	// nicht nebeneinander passen, ein zweiter nur mit Symbolen. Bei
	// senkrechter Anordnung entfaellt das - dort steht fuer jeden Reiter
	// eine eigene Zeile zur Verfuegung.
	m_bShowTabLabels = TRUE;
	int nSumme = 2;
	int nMaxBreite = 0;

	for (int nDurchgang = 0; nDurchgang < 2; nDurchgang++)
	{
		nSumme = 2;
		nMaxBreite = 0;

		for (int i = 0; i < nCount; i++)
		{
			SEC3DTab* pTab = GetTabPtr(i);
			if (pTab == NULL)
				continue;

			int cx = 2 * REITER_RAND_X;
			if (pTab->m_hIcon != NULL)
				cx += cxIcon;
			if (m_bShowTabLabels && !pTab->m_csLabel.IsEmpty())
			{
				if (pTab->m_hIcon != NULL)
					cx += REITER_LUECKE;
				CSize sz = dc.GetTextExtent(pTab->m_csLabel);
				cx += sz.cx;
			}

			pTab->m_nWidth = cx;
			pTab->m_nHeight = m_nRowExtent;

			nSumme += cx + 1;
			if (cx > nMaxBreite)
				nMaxBreite = cx;
		}

		if (!bWaagerecht)
			break;
		if (!m_bShowTabLabels)
			break;
		if (rcClient.Width() <= 0 || nSumme <= rcClient.Width())
			break;

		m_bShowTabLabels = FALSE;
	}

	// Dicke, die der Streifen braucht. SEC3DTabWnd::RecalcLayout fragt sie
	// ueber OTShimStreifenDicke ab.
	if (bWaagerecht)
		m_nStripExtent = m_nRowExtent + 2;
	else
		m_nStripExtent = nMaxBreite + 4;
	if (m_nStripExtent < 8)
		m_nStripExtent = 8;

	// Verschiebung begrenzen, bevor die Rechtecke gesetzt werden.
	const int nSicht = bWaagerecht ? rcClient.Width() : rcClient.Height();
	const int nBedarf = bWaagerecht ? nSumme : (nCount * (m_nRowExtent + 1) + 2);
	int nMaxOffset = nBedarf - nSicht;
	if (nMaxOffset < 0)
		nMaxOffset = 0;
	if (m_nScrollOffset > nMaxOffset)
		m_nScrollOffset = nMaxOffset;
	if (m_nScrollOffset < 0)
		m_nScrollOffset = 0;

	int nPos = 2 - m_nScrollOffset;
	for (int j = 0; j < nCount; j++)
	{
		SEC3DTab* pTab = GetTabPtr(j);
		if (pTab == NULL)
			continue;

		if (bWaagerecht)
		{
			SetTabPos(j, nPos, 0, m_dwTabStyle);
			nPos += pTab->m_nWidth + 1;
		}
		else
		{
			SetTabPos(j, 0, nPos, m_dwTabStyle);
			nPos += pTab->m_nHeight + 1;
		}
	}

	dc.SelectObject(pAltFont);
}

void SEC3DTabControl::SetTabPos(int nTab, int x, int y, DWORD dwStyle)
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL || GetSafeHwnd() == NULL)
		return;

	CRect rcClient;
	GetClientRect(rcClient);

	if ((dwStyle & (TCS_TABS_ON_LEFT | TCS_TABS_ON_RIGHT)) == 0)
	{
		// waagerecht: der Reiter fuellt die Hoehe des Streifens
		pTab->m_rect.SetRect(x, y, x + pTab->m_nWidth, y + rcClient.Height());
	}
	else
	{
		// senkrecht: der Reiter fuellt die Breite des Streifens
		pTab->m_rect.SetRect(x, y, x + rcClient.Width(), y + pTab->m_nHeight);
	}
}

int SEC3DTabControl::OTShimStreifenDicke() const
{
	return m_nStripExtent;
}

void SEC3DTabControl::ScrollToTab(int nTab)
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL || GetSafeHwnd() == NULL)
		return;

	CRect rcClient;
	GetClientRect(rcClient);

	int nStart, nEnde, nSicht;
	if (IstWaagerecht())
	{
		nStart = pTab->m_rect.left;
		nEnde = pTab->m_rect.right;
		nSicht = rcClient.Width();
	}
	else
	{
		nStart = pTab->m_rect.top;
		nEnde = pTab->m_rect.bottom;
		nSicht = rcClient.Height();
	}

	const int nAlt = m_nScrollOffset;
	if (nEnde > nSicht)
		m_nScrollOffset += (nEnde - nSicht) + 2;
	else if (nStart < 0)
		m_nScrollOffset += nStart - 2;

	if (m_nScrollOffset != nAlt)
	{
		RecalcLayout();		// begrenzt die Verschiebung
		Invalidate();
	}
}

void SEC3DTabControl::OnActivateTab(int nTab)
{
	ScrollToTab(nTab);
	SECTabControlBase::OnActivateTab(nTab);
}

void SEC3DTabControl::InvalidateTab(int nTab)
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL || GetSafeHwnd() == NULL)
		return;

	CRect rc(pTab->m_rect);
	rc.InflateRect(1, 1);
	InvalidateRect(rc);
}


/////////////////////////////////////////////////////////////////////////////
// Symbole, Sperren, Stil

void SEC3DTabControl::SetTabIcon(int nIndex, HICON hIcon)
{
	SEC3DTab* pTab = GetTabPtr(nIndex);
	if (pTab == NULL)
		return;

	pTab->m_hIcon = hIcon;		// gehoert dem Aufrufer, siehe ~SEC3DTab
	RecalcLayout();
	InvalidateTab(nIndex);
}

void SEC3DTabControl::SetTabIcon(int nIndex, UINT nIDIcon)
{
	SEC3DTabControl::SetTabIcon(nIndex, ::LoadIcon(::AfxGetResourceHandle(), MAKEINTRESOURCE(nIDIcon)));
}

void SEC3DTabControl::SetTabIcon(int nIndex, LPCTSTR lpszResourceName)
{
	SEC3DTabControl::SetTabIcon(nIndex, ::LoadIcon(::AfxGetResourceHandle(), lpszResourceName));
}

void SEC3DTabControl::EnableTab(int nIndex, BOOL bEnable)
{
	SEC3DTab* pTab = GetTabPtr(nIndex);
	if (pTab == NULL)
		return;

	if (pTab->m_bEnabled != bEnable)
	{
		pTab->m_bEnabled = bEnable;
		InvalidateTab(nIndex);
	}
}

BOOL SEC3DTabControl::IsTabEnabled(int nIndex)
{
	SEC3DTab* pTab = GetTabPtr(nIndex);
	return (pTab != NULL) ? pTab->m_bEnabled : FALSE;
}

#ifdef WIN32
BOOL SEC3DTabControl::ModifyStyle(DWORD dwRemove, DWORD dwAdd, UINT nFlags)
{
	// ACHTUNG beim Aufrufen: CWnd::ModifyStyle ist nicht virtuell. Ueber
	// einen SECTabControlBase* landet man in CWnd, nicht hier. Wer die
	// Anordnung umstellen will, muss auf SEC3DTabControl herunterwandeln -
	// so macht es SEC3DTabWnd::SetTabStyle.
	m_dwTabStyle &= ~(dwRemove & TCS_TAB_ORIENTATIONS);
	m_dwTabStyle |= (dwAdd & TCS_TAB_ORIENTATIONS);
	if ((m_dwTabStyle & TCS_TAB_ORIENTATIONS) == 0)
		m_dwTabStyle = TCS_TABS_ON_BOTTOM;

	BOOL bResult = CWnd::ModifyStyle(dwRemove, dwAdd, nFlags);

	if (GetSafeHwnd() != NULL)
	{
		m_nScrollOffset = 0;
		RecalcLayout();
		Invalidate();
	}
	return bResult;
}
#endif

BOOL SEC3DTabControl::SetFontTab(CFont* pFont, int nTabType, BOOL bRedraw)
{
	if (pFont == NULL || nTabType < 0 || nTabType > 1)
		return FALSE;

	LOGFONT lf;
	::ZeroMemory(&lf, sizeof(lf));
	if (pFont->GetLogFont(&lf) == 0)
		return FALSE;

	if (m_fonts[nTabType].GetSafeHandle() != NULL)
		m_fonts[nTabType].DeleteObject();
	if (!m_fonts[nTabType].CreateFontIndirect(&lf))
		return FALSE;

	if (bRedraw && GetSafeHwnd() != NULL)
	{
		RecalcLayout();
		Invalidate();
	}
	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// Abfragen

BOOL SEC3DTabControl::TabHit(int nTab, CPoint& point) const
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL)
		return FALSE;
	return pTab->m_rect.PtInRect(point);
}

SEC3DTab& SEC3DTabControl::GetTab(int nTab)
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	ASSERT(pTab != NULL);
	return *pTab;
}

SEC3DTab* SEC3DTabControl::GetTabPtr(int nTab) const
{
	// Das Feld enthaelt ausschliesslich SEC3DTab, weil CreateNewTab nur
	// solche erzeugt. QC3DTabControl::QCGetIcon (QC3DTabWnd.cpp:58) greift
	// darueber auf m_hIcon zu.
	return (SEC3DTab*) SECTabControlBase::GetTabPtr(nTab);
}

void SEC3DTabControl::GetTabRect(int nTab, CRect& tabRect) const
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	if (pTab != NULL)
		tabRect = pTab->m_rect;
	else
		tabRect.SetRectEmpty();
}

int SEC3DTabControl::GetLabelWidth(int nTab)
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	if (pTab == NULL || GetSafeHwnd() == NULL)
		return 0;

	CClientDC dc(this);
	CFont* pAlt = dc.SelectObject(&m_fonts[pTab->m_bSelected ? SEC3DTAB_ACTIVE : SEC3DTAB_INACTIVE]);
	CSize sz = dc.GetTextExtent(pTab->m_csLabel);
	dc.SelectObject(pAlt);
	return sz.cx;
}

#ifdef WIN32
int SEC3DTabControl::OnToolHitTest(CPoint point, TOOLINFO* pTI) const
{
	// Kurzhinweis mit der Beschriftung. Gebraucht wird er vor allem, wenn
	// die Beschriftung wegen Platzmangels ausgeblendet ist
	// (m_bShowTabLabels == FALSE); dann sieht man nur noch das Symbol.
	const int nCount = GetTabCount();
	for (int i = 0; i < nCount; i++)
	{
		SEC3DTab* pTab = GetTabPtr(i);
		if (pTab == NULL || pTab->m_csLabel.IsEmpty())
			continue;
		if (!pTab->m_rect.PtInRect(point))
			continue;

		if (pTI != NULL)
		{
			pTI->hwnd = m_hWnd;
			pTI->uId = (UINT_PTR) i;
			pTI->rect = pTab->m_rect;
			pTI->lpszText = _tcsdup(pTab->m_csLabel);	// MFC gibt ihn frei
			pTI->uFlags &= ~TTF_IDISHWND;
		}
		return i;
	}
	return -1;
}
#endif


/////////////////////////////////////////////////////////////////////////////
// Zeichnen
//
// Das Aussehen entspricht dem Original nicht und muss es laut Auftrag auch
// nicht. Umgesetzt ist ein flacher 3D-Reiter: Fuellung, helle Kante zur
// Lichtquelle hin, dunkle Kante gegenueber, und an der dem Inhalt
// zugewandten Seite hat der aktive Reiter gar keine Kante, damit er mit dem
// Inhaltsbereich verschmilzt.

void SEC3DTabControl::rgbFill(CDC* pDC, int x, int y, int cx, int cy, COLORREF rgb)
{
	if (pDC == NULL || cx <= 0 || cy <= 0)
		return;
	pDC->FillSolidRect(x, y, cx, cy, rgb);
}

void SEC3DTabControl::ZeichneRahmen(CDC* pDC, SEC3DTab* pTab, int nOffeneSeite)
{
	if (pDC == NULL || pTab == NULL)
		return;

	const BOOL bAktiv = pTab->m_bSelected;
	CRect rc(pTab->m_rect);
	if (rc.IsRectEmpty())
		return;

	rgbFill(pDC, rc.left, rc.top, rc.Width(), rc.Height(),
			::GetSysColor(bAktiv ? COLOR_BTNHIGHLIGHT : COLOR_BTNFACE));

	const COLORREF rgbHell = ::GetSysColor(COLOR_BTNHIGHLIGHT);
	const COLORREF rgbDunkel = ::GetSysColor(COLOR_BTNSHADOW);

	// Kante nur setzen, wenn die Seite nicht die offene ist oder der Reiter
	// nicht aktiv ist.
	if (!(bAktiv && nOffeneSeite == SEITE_OBEN))
		rgbFill(pDC, rc.left, rc.top, rc.Width(), 1, rgbHell);
	if (!(bAktiv && nOffeneSeite == SEITE_LINKS))
		rgbFill(pDC, rc.left, rc.top, 1, rc.Height(), rgbHell);
	if (!(bAktiv && nOffeneSeite == SEITE_UNTEN))
		rgbFill(pDC, rc.left, rc.bottom - 1, rc.Width(), 1, rgbDunkel);
	if (!(bAktiv && nOffeneSeite == SEITE_RECHTS))
		rgbFill(pDC, rc.right - 1, rc.top, 1, rc.Height(), rgbDunkel);
}

void SEC3DTabControl::DrawTabTop(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle)
{
	// Streifen liegt oben, der Inhalt darunter: offene Seite ist unten.
	ZeichneRahmen(pDC, pTab, SEITE_UNTEN);
	DrawInterior(pDC, pTab, dwStyle);
}

void SEC3DTabControl::DrawTabBottom(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle)
{
	ZeichneRahmen(pDC, pTab, SEITE_OBEN);
	DrawInterior(pDC, pTab, dwStyle);
}

void SEC3DTabControl::DrawTabLeft(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle)
{
	ZeichneRahmen(pDC, pTab, SEITE_RECHTS);
	DrawInterior(pDC, pTab, dwStyle);
}

void SEC3DTabControl::DrawTabRight(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle)
{
	ZeichneRahmen(pDC, pTab, SEITE_LINKS);
	DrawInterior(pDC, pTab, dwStyle);
}

void SEC3DTabControl::DrawInterior(CDC* pDC, SEC3DTab* pTab, DWORD /*dwStyle*/)
{
	if (pDC == NULL || pTab == NULL)
		return;

	CRect rc(pTab->m_rect);
	rc.DeflateRect(REITER_RAND_X, REITER_RAND_Y);
	if (rc.Width() <= 0 || rc.Height() <= 0)
		return;

	// Auf den Reiter zuschneiden, damit ein zu langer Text nicht in den
	// Nachbarn laeuft.
	int nGespeichert = pDC->SaveDC();
	pDC->IntersectClipRect(rc);

	int x = rc.left;
	if (pTab->m_hIcon != NULL)
	{
		const int cxIcon = ::GetSystemMetrics(SM_CXSMICON);
		const int cyIcon = ::GetSystemMetrics(SM_CYSMICON);
		::DrawIconEx(pDC->GetSafeHdc(), x, rc.top + (rc.Height() - cyIcon) / 2,
					 pTab->m_hIcon, cxIcon, cyIcon, 0, NULL, DI_NORMAL);
		x += cxIcon + REITER_LUECKE;
	}

	if (m_bShowTabLabels && !pTab->m_csLabel.IsEmpty())
	{
		const int nTyp = pTab->m_bSelected ? SEC3DTAB_ACTIVE : SEC3DTAB_INACTIVE;
		CFont* pAltFont = pDC->SelectObject(&m_fonts[nTyp]);
		const int nAltMode = pDC->SetBkMode(TRANSPARENT);
		const COLORREF rgbAlt = pDC->SetTextColor(m_rgbText[nTyp]);

		TEXTMETRIC tm;
		::ZeroMemory(&tm, sizeof(tm));
		pDC->GetTextMetrics(&tm);
		pDC->TextOut(x, rc.top + (rc.Height() - tm.tmHeight) / 2, pTab->m_csLabel);

		pDC->SetTextColor(rgbAlt);
		pDC->SetBkMode(nAltMode);
		pDC->SelectObject(pAltFont);
	}

	pDC->RestoreDC(nGespeichert);
}

void SEC3DTabControl::DrawDisabled(CDC* pDC, int nWidth, int nHeight)
{
	// Gesperrter Reiter: helles 50-Prozent-Raster darueber. Der Aufrufer
	// setzt den Ursprung vorher auf die linke obere Ecke des Reiters, weil
	// die Signatur (tabctrl3.h:152) keine Position mitbringt.
	//
	// Praktisch laeuft das nie an: EnableTab hat in Eudora keinen einzigen
	// Aufrufer (geprueft ueber Eudora/*.cpp und Eudora/*.h).
	if (pDC == NULL || nWidth <= 0 || nHeight <= 0)
		return;

	static const WORD wRaster[8] =
		{ 0x0055, 0x00aa, 0x0055, 0x00aa, 0x0055, 0x00aa, 0x0055, 0x00aa };

	CBitmap bmRaster;
	if (!bmRaster.CreateBitmap(8, 8, 1, 1, wRaster))
		return;
	CBrush brRaster;
	if (!brRaster.CreatePatternBrush(&bmRaster))
		return;

	// Einfarbige Muster werden beim Uebertragen so aufgeloest: gesetzte Bits
	// nehmen die Hintergrundfarbe, geloeschte die Textfarbe. Mit Schwarz als
	// Hintergrund und Weiss als Text laesst 0x00FA0089 (Ziel ODER Muster)
	// jede zweite Bildpunktreihe stehen und faerbt die andere weiss.
	const COLORREF rgbAltBk = pDC->SetBkColor(RGB(0, 0, 0));
	const COLORREF rgbAltTx = pDC->SetTextColor(RGB(255, 255, 255));
	CBrush* pAlt = pDC->SelectObject(&brRaster);
	pDC->PatBlt(0, 0, nWidth, nHeight, 0x00FA0089L);
	pDC->SelectObject(pAlt);
	pDC->SetTextColor(rgbAltTx);
	pDC->SetBkColor(rgbAltBk);
}

void SEC3DTabControl::DrawTab(CDC* pDC, int nTab)
{
	SEC3DTab* pTab = GetTabPtr(nTab);
	if (pDC == NULL || pTab == NULL || pTab->m_rect.IsRectEmpty())
		return;

	const DWORD dwStyle = m_dwTabStyle;
	if (dwStyle & TCS_TABS_ON_TOP)
		DrawTabTop(pDC, pTab, dwStyle);
	else if (dwStyle & TCS_TABS_ON_LEFT)
		DrawTabLeft(pDC, pTab, dwStyle);
	else if (dwStyle & TCS_TABS_ON_RIGHT)
		DrawTabRight(pDC, pTab, dwStyle);
	else
		DrawTabBottom(pDC, pTab, dwStyle);

	if (!pTab->m_bEnabled)
	{
		const CPoint ptAlt = pDC->SetViewportOrg(pTab->m_rect.left, pTab->m_rect.top);
		DrawDisabled(pDC, pTab->m_rect.Width(), pTab->m_rect.Height());
		pDC->SetViewportOrg(ptAlt);
	}
}


/////////////////////////////////////////////////////////////////////////////
// Nachrichten

void SEC3DTabControl::OnPaint()
{
	CPaintDC dc(this);

	CRect rcClient;
	GetClientRect(rcClient);
	rgbFill(&dc, rcClient.left, rcClient.top, rcClient.Width(), rcClient.Height(),
			::GetSysColor(COLOR_BTNFACE));

	// Der aktive Reiter kommt zuletzt, damit er ueber seinen Nachbarn liegt.
	const int nCount = GetTabCount();
	for (int i = 0; i < nCount; i++)
	{
		if (i != m_nActiveTab)
			DrawTab(&dc, i);
	}
	if (m_nActiveTab >= 0 && m_nActiveTab < nCount)
		DrawTab(&dc, m_nActiveTab);
}

BOOL SEC3DTabControl::OnEraseBkgnd(CDC* /*pDC*/)
{
	// OnPaint fuellt die gesamte Flaeche selbst; ein zweites Fuellen wuerde
	// nur flackern.
	return TRUE;
}

void SEC3DTabControl::OnSize(UINT nType, int cx, int cy)
{
	SECTabControlBase::OnSize(nType, cx, cy);
	RecalcLayout();
	if (GetSafeHwnd() != NULL)
		Invalidate();
}

void SEC3DTabControl::OnLButtonDown(UINT nFlags, CPoint point)
{
	// QC3DTabControl::OnLButtonDown ruft diese Fassung zuerst und macht
	// danach seinen eigenen Treffertest fuer das Ziehen und Ablegen
	// (QC3DTabWnd.cpp:143). Das Aktivieren muss also hier passieren.
	const int nCount = GetTabCount();
	for (int i = 0; i < nCount; i++)
	{
		SEC3DTab* pTab = GetTabPtr(i);
		if (pTab == NULL || !pTab->m_rect.PtInRect(point))
			continue;

		if (pTab->m_bEnabled)
			ActivateTab(i);		// virtuell -> QC3DTabControl::ActivateTab
		break;
	}

	SECTabControlBase::OnLButtonDown(nFlags, point);
}

void SEC3DTabControl::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	const int nCount = GetTabCount();
	for (int i = 0; i < nCount; i++)
	{
		SEC3DTab* pTab = GetTabPtr(i);
		if (pTab == NULL || !pTab->m_rect.PtInRect(point))
			continue;

		CWnd* pParent = GetParent();
		if (pParent != NULL && ::IsWindow(pParent->GetSafeHwnd()))
			pParent->SendMessage(TCM_TABDBLCLK, (WPARAM) i, 0);
		break;
	}

	SECTabControlBase::OnLButtonDblClk(nFlags, point);
}

void SEC3DTabControl::OnDestroy()
{
	SECTabControlBase::OnDestroy();
}

#ifdef _DEBUG
void SEC3DTabControl::AssertValid() const
{
	SECTabControlBase::AssertValid();
}

void SEC3DTabControl::Dump(CDumpContext& dc) const
{
	SECTabControlBase::Dump(dc);
	dc << "m_dwTabStyle = " << m_dwTabStyle << "\n";
	dc << "m_bShowTabLabels = " << m_bShowTabLabels << "\n";
}
#endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// SECTabWndBase
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNAMIC(SECTabWndBase, CWnd)

BEGIN_MESSAGE_MAP(SECTabWndBase, CWnd)
	//{{AFX_MSG_MAP(SECTabWndBase)
	ON_WM_DESTROY()
	ON_MESSAGE(TCM_TABSEL, &SECTabWndBase::OnTabSelect)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


SECTabWndBase::SECTabWndBase()
{
	m_pTabCtrl = NULL;
	m_pActiveWnd = NULL;
	m_pWndCreating = NULL;
}

SECTabWndBase::~SECTabWndBase()
{
	if (m_pTabCtrl != NULL)
	{
		delete m_pTabCtrl;
		m_pTabCtrl = NULL;
	}
}


/////////////////////////////////////////////////////////////////////////////
// Erzeugen

BOOL SECTabWndBase::Create(LPCTSTR lpszClassName, LPCTSTR lpszWindowName,
						   DWORD dwStyle, const RECT& rect,
						   CWnd* pParentWnd, UINT nID, CCreateContext* pContext)
{
	ASSERT(pParentWnd != NULL);
	if (pParentWnd == NULL)
		return FALSE;

	if (lpszClassName == NULL)
		lpszClassName = ::AfxRegisterWndClass(0, ::LoadCursor(NULL, IDC_ARROW), NULL, NULL);

	// Die unteren 16 Bit gehoeren den TWS_*-Stilen (tabwnd.h:39-50) und den
	// TCS_TABS_ON_*-Stilen (tabctrlb.h:68-72). Fuer ein Fenster mit eigener
	// Klasse sind sie bedeutungslos, aber sie hier auszublenden haelt den
	// Fensterstil sauber. WS_CLIPCHILDREN ist Pflicht: sonst malt OnPaint
	// unter den Kindfenstern durch und es flackert.
	DWORD dwWndStyle = (dwStyle & 0xFFFF0000L) | WS_CHILD | WS_CLIPCHILDREN;

	if (!CWnd::Create(lpszClassName, lpszWindowName, dwWndStyle, rect, pParentWnd, nID, pContext))
		return FALSE;

	// Die Kennung ist fest: QC3DTabWnd::RecalcLayout sucht das
	// Steuerelement ueber GetDlgItem(SEC_IDW_TABCTRL) und laesst sich das
	// Ergebnis per ASSERT bestaetigen (QC3DTabWnd.cpp:597-598).
	if (!CreateTabCtrl(dwStyle, SEC_IDW_TABCTRL))
	{
		DestroyWindow();
		return FALSE;
	}

	RecalcLayout();
	return TRUE;
}

BOOL SECTabWndBase::Create(CWnd* pParentWnd, DWORD dwStyle, UINT nID)
{
	return Create(NULL, NULL, dwStyle, CRect(0, 0, 0, 0), pParentWnd, nID, NULL);
}

BOOL SECTabWndBase::CreateTabCtrl(DWORD dwStyle, UINT nID)
{
	// Grundfassung ohne Zeichenverhalten. SEC3DTabWnd ueberschreibt sie mit
	// SEC3DTabControl, QC3DTabWnd noch einmal mit QC3DTabControl
	// (QC3DTabWnd.cpp:522).
	m_pTabCtrl = new SECTabControlBase;
	if (!m_pTabCtrl->Create(WS_VISIBLE | dwStyle, CRect(0, 0, 0, 0), this, nID))
	{
		delete m_pTabCtrl;
		m_pTabCtrl = NULL;
		return FALSE;
	}
	return TRUE;
}

BOOL SECTabWndBase::CreateScrollBarCtrl(DWORD /*dwStyle*/, UINT /*nID*/)
{
	// RUMPF mit Absicht: Bildlaufleisten gibt es nur in der 2D-Familie
	// (tabwnd.h:83 SECTabWnd::GetScrollBar, tabwnd.h:113-116 die
	// zugehoerigen Felder). SEC3DTabWnd hat keine, und Eudora ruft die
	// Methode nirgends auf.
	return TRUE;
}

CWnd* SECTabWndBase::CreateView(CRuntimeClass* pViewClass, CCreateContext* pContext, UINT nID)
{
	if (pViewClass == NULL)
		return NULL;

	CWnd* pWnd = DYNAMIC_DOWNCAST(CWnd, pViewClass->CreateObject());
	if (pWnd == NULL)
		return NULL;

	if (nID == (UINT) -1)
		nID = SEC_IDW_TABCLIENT_FIRST + GetTabCount();

	CRect rc;
	GetInsideRect(rc);

	m_pWndCreating = pWnd;
	// Ohne WS_VISIBLE erzeugen: sichtbar wird erst der aktive Reiter.
	const BOOL bOK = pWnd->Create(NULL, NULL, SEC_WS_DEFAULT_TABCLIENT & ~WS_VISIBLE,
								  rc, this, nID, pContext);
	m_pWndCreating = NULL;

	if (!bOK)
	{
		delete pWnd;
		return NULL;
	}

	m_arrEigeneFenster.Add(pWnd);
	return pWnd;
}


/////////////////////////////////////////////////////////////////////////////
// Reiter einfuegen und entfernen

CWnd* SECTabWndBase::HoleInhaltsfenster(int nIndex) const
{
	if (m_pTabCtrl == NULL)
		return NULL;

	LPCTSTR lpszLabel = NULL;
	BOOL bSelected = FALSE;
	CObject* pClient = NULL;
	HMENU hMenu = 0;
	void* pExtra = NULL;

	if (!m_pTabCtrl->GetTabInfo(nIndex, lpszLabel, bSelected, pClient, hMenu, pExtra))
		return NULL;

	return DYNAMIC_DOWNCAST(CWnd, pClient);
}

SECTab* SECTabWndBase::InsertTab(CWnd* pWnd, int nIndex, LPCTSTR lpszLabel)
{
	ASSERT(pWnd != NULL);
	if (m_pTabCtrl == NULL || pWnd == NULL)
		return NULL;

	SECTab* pTab = m_pTabCtrl->InsertTab(nIndex, lpszLabel, (CObject*) pWnd);
	if (pTab == NULL)
		return NULL;

	// Das Fenster wird NICHT umgehaengt. Eudora macht das selbst, und zwar
	// erst nach dem Setzen des Symbols
	// (WazooBar.cpp:178-179  ModifyStyle(0, WS_CHILD); SetParent(&m_wndTab)).

	int nNeu = -1;
	if (!m_pTabCtrl->FindTab((CObject*) pWnd, nNeu))
		return pTab;

	if (m_pActiveWnd == NULL)
		ZeigeInhaltsfenster(nNeu);
	else
		pWnd->ShowWindow(SW_HIDE);

	RecalcLayout();
	return pTab;
}

SECTab* SECTabWndBase::InsertTab(CRuntimeClass* pViewClass, int nIndex,
								 LPCTSTR lpszLabel, CCreateContext* pContext, UINT nID)
{
	CWnd* pWnd = CreateView(pViewClass, pContext, nID);
	if (pWnd == NULL)
		return NULL;
	return SECTabWndBase::InsertTab(pWnd, nIndex, lpszLabel);
}

SECTab* SECTabWndBase::AddTab(CWnd* pWnd, LPCTSTR lpszLabel)
{
	return SECTabWndBase::InsertTab(pWnd, GetTabCount(), lpszLabel);
}

SECTab* SECTabWndBase::AddTab(CRuntimeClass* pViewClass, LPCTSTR lpszLabel,
							  CCreateContext* pContext, UINT nID)
{
	return SECTabWndBase::InsertTab(pViewClass, GetTabCount(), lpszLabel, pContext, nID);
}

void SECTabWndBase::RemoveTab(int nIndex)
{
	if (m_pTabCtrl == NULL || !m_pTabCtrl->TabExists(nIndex))
		return;

	CWnd* pWnd = HoleInhaltsfenster(nIndex);
	const BOOL bWarAktiv = (pWnd != NULL && pWnd == m_pActiveWnd);

	if (pWnd != NULL)
	{
		if (::IsWindow(pWnd->GetSafeHwnd()))
			pWnd->ShowWindow(SW_HIDE);

		// Nur selbst erzeugte Fenster werden zerstoert. Eudora uebergibt
		// fertige CWazooWnd und erwartet, dass sie den Aufruf ueberleben:
		//     WazooBar.cpp:202-206  RemoveTab(pWazooWnd);
		//                           ASSERT(::IsWindow(pWazooWnd->GetSafeHwnd()));
		//                           pWazooWnd->SetParent(::AfxGetMainWnd());
		for (int i = 0; i < m_arrEigeneFenster.GetSize(); i++)
		{
			if (m_arrEigeneFenster[i] == (void*) pWnd)
			{
				m_arrEigeneFenster.RemoveAt(i);
				if (::IsWindow(pWnd->GetSafeHwnd()))
					pWnd->DestroyWindow();
				// Kein delete: CView und CFrameWnd geben sich in
				// PostNcDestroy selbst frei. Ein schlichtes CWnd taete das
				// nicht - dieser Weg ist in Eudora aber unerreichbar, weil
				// CreateView nirgends benutzt wird.
				break;
			}
		}
	}

	if (bWarAktiv)
		m_pActiveWnd = NULL;

	m_pTabCtrl->DeleteTab(nIndex);

	if (bWarAktiv)
	{
		int nNeu = -1;
		if (m_pTabCtrl->GetActiveTab(nNeu))
			ZeigeInhaltsfenster(nNeu);
	}

	RecalcLayout();
}

void SECTabWndBase::RemoveTab(CWnd* pWnd)
{
	int nIndex = -1;
	if (FindTab(pWnd, nIndex))
		SECTabWndBase::RemoveTab(nIndex);
}

void SECTabWndBase::RenameTab(int nIndex, LPCTSTR lpszLabel)
{
	if (m_pTabCtrl != NULL)
		m_pTabCtrl->RenameTab(nIndex, lpszLabel);
}

void SECTabWndBase::RenameTab(CWnd* pWnd, LPCTSTR lpszLabel)
{
	int nIndex = -1;
	if (FindTab(pWnd, nIndex))
		SECTabWndBase::RenameTab(nIndex, lpszLabel);
}


/////////////////////////////////////////////////////////////////////////////
// Aktiver Reiter

void SECTabWndBase::ZeigeInhaltsfenster(int nIndex)
{
	CWnd* pWnd = HoleInhaltsfenster(nIndex);
	if (pWnd == NULL)
		return;

	if (m_pActiveWnd != NULL && m_pActiveWnd != pWnd &&
		::IsWindow(m_pActiveWnd->GetSafeHwnd()))
	{
		m_pActiveWnd->ShowWindow(SW_HIDE);
	}

	m_pActiveWnd = pWnd;
	RecalcLayout();

	if (::IsWindow(pWnd->GetSafeHwnd()))
		pWnd->ShowWindow(SW_SHOW);
}

void SECTabWndBase::ActivateTab(int nIndex)
{
	if (m_pTabCtrl == NULL || !m_pTabCtrl->TabExists(nIndex))
		return;

	ZeigeInhaltsfenster(nIndex);

	// Immer weiterreichen, auch wenn der Reiter schon obenauf liegt:
	// QC3DTabControl::ActivateTab meldet dem Wazoo in jedem Fall, dass es
	// gleich angezeigt wird (QC3DTabWnd.cpp:100-127, "Just In Time wazoo
	// display strategy"). Erst die Basisfassung darunter ist untaetig.
	m_pTabCtrl->ActivateTab(nIndex);
}

void SECTabWndBase::ActivateTab(CWnd* pWnd)
{
	int nIndex = -1;
	if (FindTab(pWnd, nIndex))
		SECTabWndBase::ActivateTab(nIndex);
}

void SECTabWndBase::ActivateTab(CWnd* pWnd, int /*nIndex*/)
{
	// RUMPF, der auf die einstellige Fassung zurueckfaellt: der zweite
	// Parameter waehlt im Original einen von mehreren Anzeigebereichen, die
	// es nur in SECTabWnd gibt (tabwnd.h:80). SEC3DTabWnd hat genau einen.
	// Eudora ruft ausschliesslich die einstelligen Fassungen auf.
	SECTabWndBase::ActivateTab(pWnd);
}

void SECTabWndBase::ClearSelection()
{
	if (m_pTabCtrl != NULL)
		m_pTabCtrl->ClearSelection();
}

void SECTabWndBase::ScrollToTab(int nIndex)
{
	if (m_pTabCtrl != NULL)
		m_pTabCtrl->ScrollToTab(nIndex);
}

void SECTabWndBase::ScrollToTab(CWnd* pWnd)
{
	int nIndex = -1;
	if (FindTab(pWnd, nIndex))
		SECTabWndBase::ScrollToTab(nIndex);
}


/////////////////////////////////////////////////////////////////////////////
// Symbole und Bildlauf

void SECTabWndBase::SetTabIcon(int nIndex, HICON hIcon)
{
	if (m_pTabCtrl != NULL)
		m_pTabCtrl->SetTabIcon(nIndex, hIcon);
}

void SECTabWndBase::SetTabIcon(int nIndex, UINT nIDIcon)
{
	if (m_pTabCtrl != NULL)
		m_pTabCtrl->SetTabIcon(nIndex, nIDIcon);
}

void SECTabWndBase::SetTabIcon(int nIndex, LPCTSTR lpszResourceName)
{
	if (m_pTabCtrl != NULL)
		m_pTabCtrl->SetTabIcon(nIndex, lpszResourceName);
}

void SECTabWndBase::SetScrollStyle(int /*nIndex*/, DWORD /*dwStyle*/)
{
	// RUMPF mit Absicht, gleiche Begruendung wie CreateScrollBarCtrl:
	// SEC3DTabWnd hat keine Bildlaufleisten, Eudora ruft die Methode nie.
}


/////////////////////////////////////////////////////////////////////////////
// Abfragen

int SECTabWndBase::GetTabCount()
{
	return (m_pTabCtrl != NULL) ? m_pTabCtrl->GetTabCount() : 0;
}

BOOL SECTabWndBase::GetTabInfo(int nIndex, LPCTSTR& lpszLabel, BOOL& bSelected,
							   CWnd*& pWnd, void*& pExtra)
{
	if (m_pTabCtrl == NULL)
		return FALSE;

	CObject* pClient = NULL;
	HMENU hMenu = 0;
	if (!m_pTabCtrl->GetTabInfo(nIndex, lpszLabel, bSelected, pClient, hMenu, pExtra))
		return FALSE;

	pWnd = DYNAMIC_DOWNCAST(CWnd, pClient);
	return TRUE;
}

BOOL SECTabWndBase::FindTab(const CWnd* const pWnd, int& nTab) const
{
	nTab = -1;
	if (m_pTabCtrl == NULL)
		return FALSE;
	return m_pTabCtrl->FindTab((const CObject* const) pWnd, nTab);
}

BOOL SECTabWndBase::GetActiveTab(CWnd*& pWnd)
{
	pWnd = m_pActiveWnd;
	return (m_pActiveWnd != NULL);
}

BOOL SECTabWndBase::GetActiveTab(int& nIndex)
{
	nIndex = -1;
	if (m_pTabCtrl == NULL)
		return FALSE;
	return m_pTabCtrl->GetActiveTab(nIndex);
}

BOOL SECTabWndBase::TabExists(CWnd* pClient)
{
	int nTab = -1;
	return FindTab(pClient, nTab);
}

BOOL SECTabWndBase::TabExists(int nTab)
{
	return (m_pTabCtrl != NULL) ? m_pTabCtrl->TabExists(nTab) : FALSE;
}


/////////////////////////////////////////////////////////////////////////////
// Anordnung und Nachrichten

void SECTabWndBase::GetInsideRect(CRect& rect) const
{
	GetClientRect(rect);
}

void SECTabWndBase::RecalcLayout()
{
	// Grundfassung ohne Streifen: SEC3DTabWnd::RecalcLayout setzt es um,
	// QC3DTabWnd ueberschreibt es noch einmal fuer den Fall versteckter
	// Reiter (QC3DTabWnd.cpp:539).
}

void SECTabWndBase::OnDestroy()
{
	// Die Inhaltsfenster werden hier NICHT angefasst. Eudora zerstoert seine
	// CWazooWnd selbst in CWazooBar::OnDestroy (WazooBar.cpp:1218-1220), und
	// das laeuft VOR diesem Handler, weil das Elternfenster WM_DESTROY
	// zuerst bekommt. Ueber die Reiterliste zu gehen, hiesse hier auf
	// freigegebenen Zeigern zu arbeiten. Alles, was noch ein Kindfenster
	// ist, raeumt Windows ohnehin mit ab.
	m_arrEigeneFenster.RemoveAll();
	m_pActiveWnd = NULL;

	if (m_pTabCtrl != NULL)
	{
		if (::IsWindow(m_pTabCtrl->GetSafeHwnd()))
			m_pTabCtrl->DestroyWindow();
		delete m_pTabCtrl;
		m_pTabCtrl = NULL;
	}

	CWnd::OnDestroy();
}

LRESULT SECTabWndBase::OnTabSelect(WPARAM wParam, LPARAM lParam)
{
	const int nIndex = (int) (INT_PTR) wParam;

	// Erst der Fensterwechsel - und zwar OHNE Rueckmeldung an das
	// Steuerelement, sonst liefe ActivateTab -> TCM_TABSEL -> OnTabSelect
	// -> ActivateTab im Kreis.
	ZeigeInhaltsfenster(nIndex);

	// Dann weiter nach oben. Nur so erreicht die Nachricht
	// CWazooBar::OnTabSelect (WazooBar.cpp:51), das den Fenstertitel und das
	// Symbol des MDI-Kindes nachzieht.
	CWnd* pParent = GetParent();
	if (pParent != NULL && ::IsWindow(pParent->GetSafeHwnd()))
		pParent->SendMessage(TCM_TABSEL, wParam, lParam);

	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// GetParentTabWnd  (tabwndb.h:133)

SECTabWndBase* GetParentTabWnd(const CWnd* const pWnd)
{
	if (pWnd == NULL)
		return NULL;

	CWnd* pSuche = ((CWnd*) pWnd)->GetParent();
	while (pSuche != NULL)
	{
		SECTabWndBase* pTabWnd = DYNAMIC_DOWNCAST(SECTabWndBase, pSuche);
		if (pTabWnd != NULL)
			return pTabWnd;
		pSuche = pSuche->GetParent();
	}
	return NULL;
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// SEC3DTabWnd
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNCREATE(SEC3DTabWnd, SECTabWndBase)

BEGIN_MESSAGE_MAP(SEC3DTabWnd, SECTabWndBase)
	//{{AFX_MSG_MAP(SEC3DTabWnd)
	ON_WM_DESTROY()
	ON_WM_SIZE()
	ON_WM_PAINT()
	ON_WM_ERASEBKGND()
	ON_MESSAGE(TCM_TABSEL, &SEC3DTabWnd::OnTabSelect)
	ON_WM_NCCREATE()
	//}}AFX_MSG_MAP
	ON_WM_SYSCOLORCHANGE()
END_MESSAGE_MAP()


SEC3DTabWnd::SEC3DTabWnd()
{
	m_cyTabCtrl = 0;
	m_cxTabCtrl = 0;
	m_dwTabCtrlStyle = TCS_TABS_ON_BOTTOM;
}

SEC3DTabWnd::~SEC3DTabWnd()
{
}


/////////////////////////////////////////////////////////////////////////////
// Erzeugen

BOOL SEC3DTabWnd::Create(CWnd* pParentWnd, DWORD dwStyle, UINT nID)
{
	// m_dwTabCtrlStyle muss stehen, BEVOR CreateTabCtrl laeuft - Eudoras
	// Fassung liest es dort aus (QC3DTabWnd.cpp:526).
	m_dwTabCtrlStyle = dwStyle & TWS_TAB_ORIENTATIONS;
	if (m_dwTabCtrlStyle == 0)
		m_dwTabCtrlStyle = TWS_TABS_ON_BOTTOM;

	return SECTabWndBase::Create(pParentWnd, dwStyle, nID);
}

BOOL SEC3DTabWnd::CreateTabCtrl(DWORD /*dwStyle*/, UINT nID)
{
	m_pTabCtrl = new SEC3DTabControl;
	if (!m_pTabCtrl->Create(WS_VISIBLE | m_dwTabCtrlStyle, CRect(0, 0, 0, 0), this, nID))
	{
		delete m_pTabCtrl;
		m_pTabCtrl = NULL;
		return FALSE;
	}
	return TRUE;
}

BOOL SEC3DTabWnd::OnNcCreate(LPCREATESTRUCT lpcs)
{
	return CWnd::OnNcCreate(lpcs);
}


/////////////////////////////////////////////////////////////////////////////
// Stil, Schriften, Sperren

DWORD SEC3DTabWnd::SetTabStyle(DWORD dwTabStyle)
{
	const DWORD dwAlt = m_dwTabCtrlStyle;

	m_dwTabCtrlStyle = dwTabStyle;
	if ((m_dwTabCtrlStyle & TWS_TAB_ORIENTATIONS) == 0)
		m_dwTabCtrlStyle |= TWS_TABS_ON_BOTTOM;

	// Herunterwandeln ist Pflicht: CWnd::ModifyStyle ist nicht virtuell,
	// ueber einen SECTabControlBase* wuerde SEC3DTabControl::ModifyStyle
	// nicht erreicht.
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	if (pCtrl != NULL && ::IsWindow(pCtrl->GetSafeHwnd()))
	{
		pCtrl->ModifyStyle(TCS_TAB_ORIENTATIONS & ~m_dwTabCtrlStyle,
						   m_dwTabCtrlStyle & TCS_TAB_ORIENTATIONS);
	}

	if (GetSafeHwnd() != NULL)
	{
		RecalcLayout();
		Invalidate();
	}
	return dwAlt;
}

void SEC3DTabWnd::EnableTab(int nIndex, BOOL bEnable)
{
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	if (pCtrl != NULL)
		pCtrl->EnableTab(nIndex, bEnable);
}

void SEC3DTabWnd::EnableTab(CWnd* pWnd, BOOL bEnable)
{
	int nIndex = -1;
	if (FindTab(pWnd, nIndex))
		EnableTab(nIndex, bEnable);
}

BOOL SEC3DTabWnd::IsTabEnabled(int nIndex)
{
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	return (pCtrl != NULL) ? pCtrl->IsTabEnabled(nIndex) : FALSE;
}

BOOL SEC3DTabWnd::IsTabEnabled(CWnd* pWnd)
{
	int nIndex = -1;
	if (FindTab(pWnd, nIndex))
		return IsTabEnabled(nIndex);
	return FALSE;
}

BOOL SEC3DTabWnd::SetFontActiveTab(CFont* pFont, BOOL bRedraw)
{
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	return (pCtrl != NULL) ? pCtrl->SetFontActiveTab(pFont, bRedraw) : FALSE;
}

BOOL SEC3DTabWnd::SetFontInactiveTab(CFont* pFont, BOOL bRedraw)
{
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	return (pCtrl != NULL) ? pCtrl->SetFontInactiveTab(pFont, bRedraw) : FALSE;
}

CFont* SEC3DTabWnd::GetFontActiveTab()
{
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	return (pCtrl != NULL) ? pCtrl->GetFontActiveTab() : NULL;
}

CFont* SEC3DTabWnd::GetFontInactiveTab()
{
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	return (pCtrl != NULL) ? pCtrl->GetFontInactiveTab() : NULL;
}


/////////////////////////////////////////////////////////////////////////////
// Anordnung

void SEC3DTabWnd::GetInsideRect(CRect& rect) const
{
	GetClientRect(rect);

	if (m_dwTabCtrlStyle & TCS_TABS_ON_TOP)
		rect.top += m_cyTabCtrl;
	else if (m_dwTabCtrlStyle & TCS_TABS_ON_LEFT)
		rect.left += m_cxTabCtrl;
	else if (m_dwTabCtrlStyle & TCS_TABS_ON_RIGHT)
		rect.right -= m_cxTabCtrl;
	else
		rect.bottom -= m_cyTabCtrl;

	rect.DeflateRect(OTSHIM_REITER_RAHMEN, OTSHIM_REITER_RAHMEN);

	if (rect.right < rect.left)
		rect.right = rect.left;
	if (rect.bottom < rect.top)
		rect.bottom = rect.top;
}

void SEC3DTabWnd::RecalcLayout()
{
	if (GetSafeHwnd() == NULL || m_pTabCtrl == NULL ||
		!::IsWindow(m_pTabCtrl->GetSafeHwnd()))
	{
		return;
	}

	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	const int nDicke = (pCtrl != NULL) ? pCtrl->OTShimStreifenDicke() : 20;

	CRect rcClient;
	GetClientRect(rcClient);

	CRect rcStreifen(rcClient);
	if (m_dwTabCtrlStyle & TCS_TABS_ON_TOP)
	{
		m_cyTabCtrl = nDicke;
		m_cxTabCtrl = 0;
		rcStreifen.bottom = rcStreifen.top + nDicke;
	}
	else if (m_dwTabCtrlStyle & TCS_TABS_ON_LEFT)
	{
		m_cyTabCtrl = 0;
		m_cxTabCtrl = nDicke;
		rcStreifen.right = rcStreifen.left + nDicke;
	}
	else if (m_dwTabCtrlStyle & TCS_TABS_ON_RIGHT)
	{
		m_cyTabCtrl = 0;
		m_cxTabCtrl = nDicke;
		rcStreifen.left = rcStreifen.right - nDicke;
	}
	else
	{
		m_cyTabCtrl = nDicke;
		m_cxTabCtrl = 0;
		rcStreifen.top = rcStreifen.bottom - nDicke;
	}

	CRect rcInnen;
	GetInsideRect(rcInnen);

	HDWP hDWP = ::BeginDeferWindowPos(2);
	if (hDWP == NULL)
		return;

	hDWP = ::DeferWindowPos(hDWP, m_pTabCtrl->m_hWnd, NULL,
							rcStreifen.left, rcStreifen.top,
							rcStreifen.Width(), rcStreifen.Height(),
							SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOCOPYBITS);

	if (hDWP != NULL && m_pActiveWnd != NULL && ::IsWindow(m_pActiveWnd->GetSafeHwnd()))
	{
		hDWP = ::DeferWindowPos(hDWP, m_pActiveWnd->m_hWnd, NULL,
								rcInnen.left, rcInnen.top,
								rcInnen.Width(), rcInnen.Height(),
								SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOCOPYBITS);
	}

	if (hDWP != NULL)
		::EndDeferWindowPos(hDWP);
}


/////////////////////////////////////////////////////////////////////////////
// Zeichnen

void SEC3DTabWnd::rgbFill(CDC* pDC, int x, int y, int cx, int cy, COLORREF rgb)
{
	if (pDC == NULL || cx <= 0 || cy <= 0)
		return;
	pDC->FillSolidRect(x, y, cx, cy, rgb);
}

void SEC3DTabWnd::VLine3D(CDC* pDC, int x, int y, int nHeight)
{
	// senkrechte 3D-Kante: aussen Schatten, innen Licht
	rgbFill(pDC, x, y, 1, nHeight, ::GetSysColor(COLOR_BTNSHADOW));
	rgbFill(pDC, x + 1, y, 1, nHeight, ::GetSysColor(COLOR_BTNHIGHLIGHT));
}

void SEC3DTabWnd::HLine3D(CDC* pDC, int x, int y, int nWidth, BOOL bFlip)
{
	const COLORREF rgbAussen = ::GetSysColor(bFlip ? COLOR_BTNHIGHLIGHT : COLOR_BTNSHADOW);
	const COLORREF rgbInnen = ::GetSysColor(bFlip ? COLOR_BTNSHADOW : COLOR_BTNHIGHLIGHT);
	rgbFill(pDC, x, y, nWidth, 1, rgbAussen);
	rgbFill(pDC, x, y + 1, nWidth, 1, rgbInnen);
}

void SEC3DTabWnd::OnPaint()
{
	// QC3DTabWnd::OnPaint ruft diese Fassung nur, wenn m_Draw3DBorder
	// gesetzt ist, sonst Default() (QC3DTabWnd.cpp:614-620).
	CPaintDC dc(this);

	CRect rcClient;
	GetClientRect(rcClient);
	rgbFill(&dc, rcClient.left, rcClient.top, rcClient.Width(), rcClient.Height(),
			::GetSysColor(COLOR_BTNFACE));

	CRect rcInnen;
	GetInsideRect(rcInnen);
	CRect rcRahmen(rcInnen);
	rcRahmen.InflateRect(2, 2);
	if (rcRahmen.Width() < 4 || rcRahmen.Height() < 4)
		return;

	// vertiefter Rahmen: oben und links Schatten, unten und rechts Licht
	HLine3D(&dc, rcRahmen.left, rcRahmen.top, rcRahmen.Width(), FALSE);
	VLine3D(&dc, rcRahmen.left, rcRahmen.top, rcRahmen.Height());
	rgbFill(&dc, rcRahmen.left, rcRahmen.bottom - 2, rcRahmen.Width(), 1,
			::GetSysColor(COLOR_BTNSHADOW));
	rgbFill(&dc, rcRahmen.left, rcRahmen.bottom - 1, rcRahmen.Width(), 1,
			::GetSysColor(COLOR_BTNHIGHLIGHT));
	rgbFill(&dc, rcRahmen.right - 2, rcRahmen.top, 1, rcRahmen.Height(),
			::GetSysColor(COLOR_BTNSHADOW));
	rgbFill(&dc, rcRahmen.right - 1, rcRahmen.top, 1, rcRahmen.Height(),
			::GetSysColor(COLOR_BTNHIGHLIGHT));
}

BOOL SEC3DTabWnd::OnEraseBkgnd(CDC* /*pDC*/)
{
	return TRUE;		// OnPaint fuellt selbst
}


/////////////////////////////////////////////////////////////////////////////
// Nachrichten

void SEC3DTabWnd::OnSize(UINT nType, int cx, int cy)
{
	SECTabWndBase::OnSize(nType, cx, cy);

	if (nType == SIZE_MINIMIZED)
		return;

	RecalcLayout();		// virtuell -> QC3DTabWnd::RecalcLayout
}

void SEC3DTabWnd::OnSysColorChange()
{
	SECTabWndBase::OnSysColorChange();

	// Die Stifte und Pinsel des Steuerelements haengen an den Systemfarben
	// und muessen neu angelegt werden.
	SEC3DTabControl* pCtrl = DYNAMIC_DOWNCAST(SEC3DTabControl, m_pTabCtrl);
	if (pCtrl != NULL && ::IsWindow(pCtrl->GetSafeHwnd()))
	{
		pCtrl->Initialize(m_dwTabCtrlStyle);
		pCtrl->Invalidate();
	}

	if (GetSafeHwnd() != NULL)
		Invalidate();
}

LRESULT SEC3DTabWnd::OnTabSelect(WPARAM wParam, LPARAM lParam)
{
	// Beide Nachrichtentabellen tragen TCM_TABSEL. MFC bedient nur den
	// aeussersten Eintrag, also muss die Basisfassung hier von Hand kommen.
	return SECTabWndBase::OnTabSelect(wParam, lParam);
}

void SEC3DTabWnd::OnDestroy()
{
	SECTabWndBase::OnDestroy();
}
