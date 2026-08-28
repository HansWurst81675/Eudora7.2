// OTShim.cpp - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1, Stufe 0
//
// Zu OTShim.h. Enthaelt nur das, was nicht in den Header passt:
// IMPLEMENT_DYNAMIC und die Message-Map von SECTipOfDay sowie die wenigen
// nicht inline abbildbaren Methoden.
//
// SECStatusBar und SECLoadSysColorBitmap brauchen hier nichts - der eine ist
// ein typedef, der andere eine inline-Funktion.
//
// UEBERSETZUNG: die Datei bindet <afxwin.h> selbst ein und benutzt Eudoras
// vorkompilierten Header nicht. Beim Einhaengen in Eudora.vcxproj daher fuer
// diese Datei "Vorkompilierte Header: Nicht verwenden" (/Y-) setzen.
//
// Kodierung: reines ASCII, kein BOM.

#include <afxwin.h>

#include "OTShim.h"


/////////////////////////////////////////////////////////////////////////////
// SECTipOfDay
//
// Stub gemaess OTShim/PLAN.md, Stufe 0. Zur Begruendung und zur Liste der
// abgedeckten Aufrufstellen siehe den Kommentarblock in OTShim.h.
//
// DECLARE_DYNAMIC/IMPLEMENT_DYNAMIC wie im Original (SECTOD.H:43). Eudora
// benutzt RUNTIME_CLASS(SECTipOfDay) zwar nirgends, aber es kostet nichts und
// haelt die Oberflaeche deckungsgleich.

IMPLEMENT_DYNAMIC(SECTipOfDay, CDialog)

// Die Map bleibt leer. Das Original hat hier OnNextTip, OnPreviousTips,
// OnPaint und OnShowButtonChanged (SECTOD.H:95-98); ohne Dialogfenster
// erreicht keine dieser Nachrichten die Klasse.
//
// Gebraucht wird der Eintrag trotzdem, denn TipOfDayDlg.cpp:13 schreibt
//     BEGIN_MESSAGE_MAP(QCTipOfDayDlg, SECTipOfDay)
// und das Makro nimmt die Adresse von SECTipOfDay::GetThisMessageMap.

BEGIN_MESSAGE_MAP(SECTipOfDay, CDialog)
END_MESSAGE_MAP()


// Signatur exakt wie SECTOD.H:47-51.
//
// Der Basisaufruf geht an den parameterlosen CDialog-Konstruktor. Der laesst
// m_lpszTemplateName auf NULL - genau richtig, weil dieser Stub kein Fenster
// erzeugt (DoModal ist ueberschrieben). Waere hier eine Vorlagen-ID noetig,
// muesste sie aus SECRES.RC kommen, die Eudora nicht einbindet.
SECTipOfDay::SECTipOfDay
(
	const TCHAR * lpszTipFileName,
	const TCHAR * didYouKnow,
	int nTip			/* = 1 */,
	BOOL bShowAtStart	/* = 1 */,
	CWnd* pParent		/* = NULL */
) :
	CDialog()
{
	m_bShowState     = bShowAtStart;
	m_nCurrentTip    = nTip;
	m_nTipsInFile    = 0;
	m_lpTipFileName  = lpszTipFileName;

	// ACHTUNG, kein Fehler im Stub, sondern eine Eigenheit der Aufrufstelle:
	// TipOfDayDlg.cpp:28 uebergibt (const TCHAR *) CRString(IDS_DID_YOU_KNOW),
	// also den Zeiger auf ein temporaeres CRString-Objekt. Der Zeiger ist
	// bereits ungueltig, sobald der Konstruktor zurueckkehrt. Das Original
	// muss die Zeichenkette daher kopiert haben - vermutlich in
	// SetLeadInText, das als einzige der Setz-Methoden in SECTOD.H:61 nicht
	// inline steht. Dieser Stub liest m_lpLeadInText nirgends, deshalb ist
	// die Ablage hier gefahrlos. Wer den Dialog spaeter echt nachbaut, muss
	// an dieser Stelle kopieren, nicht zeigen.
	m_lpLeadInText   = const_cast<TCHAR *>(didYouKnow);

	m_pTipFont       = NULL;
	m_pLeadInFont    = NULL;
	m_nIconID        = 0;
	m_szCurrentTip[0] = _T('\0');
	m_rectTip.SetRectEmpty();

	// CDialog() setzt m_pParentWnd auf NULL; den uebergebenen Eltern-Zeiger
	// nachtragen, damit ein spaeterer echter Nachbau ihn vorfindet.
	// eudora.cpp:253 uebergibt ihn nicht, also ist er dort ohnehin NULL.
	m_pParentWnd = pParent;
}


SECTipOfDay::~SECTipOfDay()
{
	// Nichts freizugeben: der Stub besitzt keine der gemerkten Zeiger.
	// m_pTipFont und m_pLeadInFont gehoeren QCTipOfDayDlg (TipOfDayDlg.h:24-25,
	// zwei CFont-Felder), m_lpTipFileName gehoert eudora.cpp:248-251.
}


// SECTOD.H:52. Von Eudora nicht aufgerufen (geprueft: kein Treffer auf
// SECTipOfDay::Create oder dlg.Create in Eudora/*.cpp). Der Rumpf meldet
// Misserfolg, statt stillschweigend ein halbes Fenster vorzutaeuschen.
BOOL SECTipOfDay::Create()
{
	ASSERT(FALSE);	// Stufe 0 kennt keinen modeless Tip-Dialog
	return FALSE;
}


// SECTOD.H:67. Wird im Stub nie erreicht, weil DoModal kein Fenster anlegt
// und damit auch kein WM_INITDIALOG entsteht. Muss aber existieren, denn
// TipOfDayDlg.cpp:44 ruft SECTipOfDay::OnInitDialog() qualifiziert auf - das
// waere sonst ein Linkerfehler.
BOOL SECTipOfDay::OnInitDialog()
{
	return CDialog::OnInitDialog();
}


// Nicht in SECTOD.H - siehe Begruendung im Kommentarblock von OTShim.h.
//
// Rueckgabe IDOK gemaess PLAN.md, Stufe 0. eudora.cpp:254 wertet den Wert
// nicht aus; entscheidend ist nur, dass GetShowAtStartup und GetCurrentTip
// danach die Werte liefern, die eudora.cpp:256-257 in die INI schreibt.
INT_PTR SECTipOfDay::DoModal()
{
	return IDOK;
}


// SECTOD.H:61. Einzige nicht inline deklarierte Setz-Methode des Originals.
// Von Eudora nicht aufgerufen; nur der Vollstaendigkeit halber vorhanden.
// Zum Kopieren statt Zeigen siehe den Hinweis im Konstruktor.
void SECTipOfDay::SetLeadInText(const TCHAR * lpNewLeadInText)
{
	m_lpLeadInText = const_cast<TCHAR *>(lpNewLeadInText);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// STUFE 1 - MDI-FENSTERGERUEST
//
// Zur Begruendung jeder einzelnen Entscheidung siehe den Abschnitt "Stufe 1"
// in OTShim.h. Hier steht nur, was nicht in den Header passt.
//
// UEBERSETZUNG: dieser Abschnitt braucht OT501/Include im Suchpfad
// (swinfrm.h, sbardock.h - eingebunden von OTShim.h). Eudora.vcxproj fuehrt
// ..\OT501\Include bereits.


/////////////////////////////////////////////////////////////////////////////
// Sammelmeldung

void OTShimNichtUmgesetzt(BOOL& rbBereitsGemeldet, LPCTSTR lpszWas)
{
	if (rbBereitsGemeldet)
		return;

	rbBereitsGemeldet = TRUE;

	CString strMeldung;
	strMeldung.Format(
		_T("Diese Funktion steht in dieser Fassung nicht zur Verfuegung:\n\n")
		_T("    %s\n\n")
		_T("Der Ersatz fuer das Stingray Objective Toolkit ist bis Stufe 1 ")
		_T("(MDI-Fenstergeruest ohne Registerkarten) umgesetzt. Alles Weitere ")
		_T("folgt in spaeteren Stufen.\n\n")
		_T("Diese Meldung erscheint nur einmal je Sitzung."),
		lpszWas);

	::AfxMessageBox(strMeldung, MB_OK | MB_ICONINFORMATION);
}


/////////////////////////////////////////////////////////////////////////////
// SECMDIFrameWnd

IMPLEMENT_DYNCREATE(SECMDIFrameWnd, CMDIFrameWnd)

// Die Tabelle ist Feld fuer Feld dieselbe wie CFrameWnd::dwDockBarMap
// (winfrm2.cpp:18-24 aus MSVC 14.38.33130). Sie muss es auch sein:
// CMainFrame::EnableDocking (mainfrm.cpp:2156-2173) legt anhand dieser
// Tabelle eigene QCDockBar-Objekte an und ruft danach diese Klasse auf, die
// ihrerseits CFrameWnd::EnableDocking benutzt. Kaemen unterschiedliche
// Kennungen heraus, entstuenden acht statt vier Andockleisten.
const DWORD SECMDIFrameWnd::dwSECDockBarMap[4][2] =
{
	{ AFX_IDW_DOCKBAR_TOP,      CBRS_TOP    },
	{ AFX_IDW_DOCKBAR_BOTTOM,   CBRS_BOTTOM },
	{ AFX_IDW_DOCKBAR_LEFT,     CBRS_LEFT   },
	{ AFX_IDW_DOCKBAR_RIGHT,    CBRS_RIGHT  },
};

// Die Tabelle bleibt leer. Das Original haengt hier seine Farbverlauf-
// Titelzeile ein (OnNcActivate, OnNcPaint, OnGetText, OnSetText,
// OnActivateApp). Ohne diese Zeichnerei ist der richtige Zustand genau der
// von CMDIFrameWnd: jede Nachricht faellt an die Basistabelle durch. Die
// Behandler bleiben trotzdem als Funktionen bestehen, weil Eudora sie
// qualifiziert aufruft (mainfrm.cpp:1580, 8734).
BEGIN_MESSAGE_MAP(SECMDIFrameWnd, CMDIFrameWnd)
END_MESSAGE_MAP()


SECMDIFrameWnd::SECMDIFrameWnd()
{
	m_prevLayout.SetRectEmpty();

	// Vorgabe gemaess workbook.cpp:667. QCWorkbook prueft diesen Wert im
	// Konstruktor mit ASSERT und ersetzt ihn danach durch
	// RUNTIME_CLASS(QCControlBarWorksheet). Wird er hier nicht gesetzt,
	// schlaegt die Zusicherung sofort beim Start an.
	m_pFloatingMDIChildClass = RUNTIME_CLASS(SECControlBarWorksheet);

	m_ptDefaultMDIPos = CPoint(0, 0);
	m_pActiveDockableFrame = NULL;
	m_pControlBarManager = NULL;

	m_uiTextAlign = acLeft;
	m_bNullGetText = FALSE;
	m_bHandleCaption = FALSE;	// bleibt aus - es wird nichts selbst gemalt

	m_bIsWin95orAbove = FALSE;
	GetWindowsVersion();
}

SECMDIFrameWnd::~SECMDIFrameWnd()
{
	// m_pControlBarManager gehoert dem Anwender der Klasse: Eudora legt ihn
	// als QCToolBarManager an und raeumt ihn selbst ab.
}

#ifdef _DEBUG
void SECMDIFrameWnd::AssertValid() const
	{ CMDIFrameWnd::AssertValid(); }
void SECMDIFrameWnd::Dump(CDumpContext& dc) const
	{ CMDIFrameWnd::Dump(dc); }
#endif


void SECMDIFrameWnd::GetWindowsVersion()
{
	// Das Feld unterschied im Original Win32s/Win3.1 von Win95 aufwaerts.
	// Auf einem Ziel, das MFC 14 traegt, ist die Antwort immer dieselbe.
	m_bIsWin95orAbove = TRUE;
}


// Kategorie A: reicht an MFC durch. CMainFrame::EnableDocking
// (mainfrm.cpp:2156) legt vorher seine QCDockBar-Objekte an;
// CFrameWnd::EnableDocking (winfrm2.cpp:46) ueberspringt Kennungen, zu denen
// schon eine Leiste existiert, und legt nur die fehlenden an.
void SECMDIFrameWnd::EnableDocking(DWORD dwDockStyle)
{
	CMDIFrameWnd::EnableDocking(dwDockStyle);
}


// STUFE 2. Die Zusatzangaben nCol, nRow, fPctWidth und nHeight sind echte
// Stingray-Funktionalitaet (prozentuale Zeilenbreiten in SECDockBar), die MFC
// nicht kennt. Hier bleibt davon das Andocken an der gewuenschten Seite
// uebrig - das Ergebnis ist eine brauchbare, aber nicht spaltengenaue
// Anordnung. Eine Meldung gibt es dafuer bewusst nicht: die Aufrufe kommen
// beim Start (mainfrm.cpp:965, WazooBarMgr.cpp:242,366,375,425) und die
// Leisten erscheinen ja, nur eben an einfacher berechneter Stelle.
void SECMDIFrameWnd::DockControlBarEx(CControlBar* pBar, UINT nDockBarID,
	int /*nCol*/, int /*nRow*/, float /*fPctWidth*/, int /*nHeight*/)
{
	CMDIFrameWnd::DockControlBar(pBar, nDockBarID, NULL);
}


void SECMDIFrameWnd::FloatControlBar(CControlBar* pBar, CPoint point, DWORD dwStyle)
{
	CMDIFrameWnd::FloatControlBar(pBar, point, dwStyle);
}

void SECMDIFrameWnd::DockControlBar(CControlBar* pBar, UINT nDockBarID, LPCRECT lpRect)
{
	CMDIFrameWnd::DockControlBar(pBar, nDockBarID, lpRect);
}

void SECMDIFrameWnd::DockControlBar(CControlBar* pBar, CDockBar* pDockBar, LPCRECT lpRect)
{
	CMDIFrameWnd::DockControlBar(pBar, pDockBar, lpRect);
}

void SECMDIFrameWnd::ReDockControlBar(CControlBar* pBar, CDockBar* pDockBar, LPCRECT lpRect)
{
	CMDIFrameWnd::ReDockControlBar(pBar, pDockBar, lpRect);
}

void SECMDIFrameWnd::ShowControlBar(CControlBar* pBar, BOOL bShow, BOOL bDelay)
{
	CMDIFrameWnd::ShowControlBar(pBar, bShow, bDelay);
}


// STUFE 2. Eine Leiste als eigenstaendiges MDI-Kindfenster schweben lassen
// setzt SECControlBarWorksheet mit einer eingebauten SECDockBar voraus.
// Erreichbar ist das ueber das Kontextmenue der Leisten (ID_SEC_MDIFLOAT,
// SECRES.H:191), also ueber die Oberflaeche - deshalb die Meldung.
// Ersatzverhalten: normal schweben lassen, damit die Leiste nicht verschwindet.
void SECMDIFrameWnd::FloatControlBarInMDIChild(CControlBar* pBar, CPoint point, DWORD dwStyle)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Eine Werkzeug- oder Wazoo-Leiste als eigenes Fenster innerhalb des ")
		_T("Hauptfensters ablegen. Die Leiste schwebt statt dessen frei."));

	CMDIFrameWnd::FloatControlBar(pBar, point, dwStyle);
}

// Im Original: an der zuletzt gemerkten Stelle wieder schweben lassen. Der
// gemerkte Ort steckt in SECControlBar (Stufe 2), also wird hier die
// uebergebene Stelle benutzt. Von Eudora nicht aufgerufen.
void SECMDIFrameWnd::ReFloatControlBar(CControlBar* pBar, CPoint point, DWORD dwStyle)
{
	CMDIFrameWnd::FloatControlBar(pBar, point, dwStyle);
}

// STUFE 2. Legt im Original ein Fenster der Klasse m_pFloatingMDIChildClass
// an (also QCControlBarWorksheet, workbook.cpp:668) und haengt pBar in dessen
// SECDockBar. Ohne die Andockfamilie geht das nicht.
// UNGEPRUEFT: ob das Original bei Misserfolg NULL liefert oder assertiert,
// ist nicht belegbar; Eudora ruft die Methode nirgends direkt auf.
CMDIChildWnd* SECMDIFrameWnd::CreateFloatingMDIChild(DWORD /*dwStyle*/, CControlBar* /*pBar*/)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Eine Leiste in ein eigenes Fenster innerhalb des Hauptfensters ")
		_T("verwandeln (Stingray CreateFloatingMDIChild)."));

	return NULL;
}


// Nur wegen der Vererbungskette: das Original merkte sich den zuletzt
// aktivierten andockbaren Rahmen, um dessen Titelzeile aktiv zu zeichnen.
// Ohne selbstgemalte Titelzeile bleibt davon nur das Merken.
void SECMDIFrameWnd::ActivateDockableFrame(SECFrameWnd* pFrameWnd)
{
	m_pActiveDockableFrame = pFrameWnd;
	OnActivateDockableFrame(pFrameWnd);
}

void SECMDIFrameWnd::OnActivateDockableFrame(SECFrameWnd* /*pFrame*/)
{
}

void SECMDIFrameWnd::OnUpdateFrameTitle(BOOL bAddToTitle)
{
	CMDIFrameWnd::OnUpdateFrameTitle(bAddToTitle);
}

CFrameWnd* SECMDIFrameWnd::GetActiveFrame()
{
	return CMDIFrameWnd::GetActiveFrame();
}


// Kategorie A. Das Original hat hier zusaetzlich seinen Leistenverwalter
// mitgeladen bzw. mitgeschrieben; Eudora hat diesen Teil laengst selbst
// uebernommen und in zwei Schritte zerlegt (mainfrm.cpp:826-934 mit
// SECDockState und QCToolBarManager::LoadState).
void SECMDIFrameWnd::LoadBarState(LPCTSTR lpszProfileName)
{
	CMDIFrameWnd::LoadBarState(lpszProfileName);
}

void SECMDIFrameWnd::SaveBarState(LPCTSTR lpszProfileName) const
{
	CMDIFrameWnd::SaveBarState(lpszProfileName);
}


// STUFE 2. SECDockState (sdocksta.h) gehoert zur Andockfamilie und ist hier
// nur vorwaerts deklariert (swinfrm.h:44); mit dem Objekt laesst sich noch
// nichts anfangen.
//
// FOLGE: die gespeicherten Leistenpositionen werden beim Start nicht
// wiederhergestellt (mainfrm.cpp:934). Die Leisten erscheinen dort, wo
// DockControlBar/DockControlBarEx sie hinsetzt. Bewusst ohne Meldung: der
// Aufruf kommt beim Start und nicht auf eine Handlung des Anwenders hin,
// eine Meldung bei jedem Start waere unbrauchbar.
void SECMDIFrameWnd::SetDockState(SECDockState& /*state*/)
{
	TRACE0("OTShim: SECMDIFrameWnd::SetDockState - Stufe 2, ohne Wirkung\n");
}

void SECMDIFrameWnd::GetDockState(SECDockState& /*state*/) const
{
	TRACE0("OTShim: SECMDIFrameWnd::GetDockState - Stufe 2, ohne Wirkung\n");
}


SECControlBarManager* SECMDIFrameWnd::GetControlBarManager() const
{
	return m_pControlBarManager;
}

void SECMDIFrameWnd::SetControlBarManager(SECControlBarManager* pManager)
{
	m_pControlBarManager = pManager;
}


// Titelzeile in Farbverlauf: bewusst nicht nachgebaut. Von Eudora nirgends
// aufgerufen (geprueft: kein Treffer auf EnableCustomCaption,
// SetCaptionTextAlign, ForceCaptionRedraw in Eudora71/Eudora). Der Wunsch
// wird gemerkt, gezeichnet wird nichts - deshalb auch keine Meldung, denn
// ueber die Oberflaeche ist nichts davon erreichbar.
BOOL SECMDIFrameWnd::EnableCustomCaption(BOOL bEnable, BOOL /*bRedraw*/)
{
	BOOL bWar = m_bHandleCaption;
	m_bHandleCaption = bEnable;
	return bWar;
}

void SECMDIFrameWnd::ForceCaptionRedraw()
{
}

void SECMDIFrameWnd::SetCaptionTextAlign(AlignCaption ac, BOOL /*bRedraw*/)
{
	m_uiTextAlign = (UINT)ac;
}


void SECMDIFrameWnd::OnSetPreviewMode(BOOL bPreview, CPrintPreviewState* pState)
{
	CMDIFrameWnd::OnSetPreviewMode(bPreview, pState);
}

// mainfrm.cpp:1580
void SECMDIFrameWnd::OnSysColorChange()
{
	CMDIFrameWnd::OnSysColorChange();
}

// UNGEPRUEFT: die Nachricht, an der das Original haengt, ist nicht belegbar.
// Steht in keiner Nachrichtentabelle, wird also nie erreicht.
LRESULT SECMDIFrameWnd::OnExtendContextMenu(WPARAM /*wParam*/, LPARAM /*lParam*/)
{
	return 0;
}

void SECMDIFrameWnd::RecalcLayout(BOOL bNotify)
{
	CMDIFrameWnd::RecalcLayout(bNotify);
}

// mainfrm.cpp:3135
BOOL SECMDIFrameWnd::OnCmdMsg(UINT nID, int nCode, void* pExtra,
	AFX_CMDHANDLERINFO* pHandlerInfo)
{
	return CMDIFrameWnd::OnCmdMsg(nID, nCode, pExtra, pHandlerInfo);
}

void SECMDIFrameWnd::OnUpdateFrameMenu(HMENU hMenuAlt)
{
	CMDIFrameWnd::OnUpdateFrameMenu(hMenuAlt);
}

// mainfrm.cpp:3077
BOOL SECMDIFrameWnd::OnCommand(WPARAM wParam, LPARAM lParam)
{
	return CMDIFrameWnd::OnCommand(wParam, lParam);
}

// mainfrm.cpp:8734
BOOL SECMDIFrameWnd::OnNcActivate(BOOL bActive)
{
	return CMDIFrameWnd::OnNcActivate(bActive);
}

void SECMDIFrameWnd::OnNcPaint()
{
	CMDIFrameWnd::OnNcPaint();
}

void SECMDIFrameWnd::OnActivateApp(BOOL bActive, DWORD dwThreadID)
{
	CMDIFrameWnd::OnActivateApp(bActive, dwThreadID);
}

void SECMDIFrameWnd::OnParentNotify(UINT message, LPARAM lParam)
{
	CMDIFrameWnd::OnParentNotify(message, lParam);
}

// workbook.cpp:1901 ueber SECWorkbook::OnActivate
void SECMDIFrameWnd::OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized)
{
	CMDIFrameWnd::OnActivate(nState, pWndOther, bMinimized);
}

// Die drei gehoeren zur Farbverlauf-Titelzeile und stehen in keiner
// Nachrichtentabelle. WM_GETTEXT/WM_SETTEXT/WM_COMMANDHELP werden dadurch von
// den Tabellen der MFC-Basisklassen bedient - genau richtig.
LRESULT SECMDIFrameWnd::OnGetText(WPARAM /*wParam*/, LPARAM /*lParam*/)
{
	return 0;
}

LRESULT SECMDIFrameWnd::OnSetText(WPARAM /*wParam*/, LPARAM /*lParam*/)
{
	return 0;
}

LRESULT SECMDIFrameWnd::OnCommandHelp(WPARAM /*wParam*/, LPARAM /*lParam*/)
{
	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// SECMDIChildWnd
//
// Leere Zwischenklasse - siehe OTShim.h. Die Tabelle bleibt leer, damit
// Nachrichten unveraendert an CMDIChildWnd durchfallen.

IMPLEMENT_DYNCREATE(SECMDIChildWnd, CMDIChildWnd)

BEGIN_MESSAGE_MAP(SECMDIChildWnd, CMDIChildWnd)
END_MESSAGE_MAP()

SECMDIChildWnd::SECMDIChildWnd()
{
}

SECMDIChildWnd::~SECMDIChildWnd()
{
}

#ifdef _DEBUG
void SECMDIChildWnd::AssertValid() const
	{ CMDIChildWnd::AssertValid(); }
void SECMDIChildWnd::Dump(CDumpContext& dc) const
	{ CMDIChildWnd::Dump(dc); }
#endif

int SECMDIChildWnd::OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest, UINT message)
{
	return CMDIChildWnd::OnMouseActivate(pDesktopWnd, nHitTest, message);
}

void SECMDIChildWnd::OnChildActivate()
{
	CMDIChildWnd::OnChildActivate();
}


/////////////////////////////////////////////////////////////////////////////
// SECWorksheet

IMPLEMENT_DYNCREATE(SECWorksheet, SECMDIChildWnd)

BEGIN_MESSAGE_MAP(SECWorksheet, SECMDIChildWnd)
	ON_WM_MDIACTIVATE()
	ON_WM_DESTROY()
	ON_WM_SHOWWINDOW()
END_MESSAGE_MAP()


SECWorksheet::SECWorksheet()
{
	m_hIcon = NULL;
	m_nPosition = -1;
	m_bSelected = FALSE;
}

SECWorksheet::~SECWorksheet()
{
	// Abgemeldet wird in OnDestroy, solange GetMDIFrame() noch etwas liefert.
	// Bleibt ein Fenster ohne WM_DESTROY uebrig, faengt SECWorkbook das ab:
	// AddSheet/RemoveSheet/LookupSheet arbeiten rein ueber Zeigervergleich und
	// vertragen einen unbekannten Zeiger.
}

#ifdef _DEBUG
void SECWorksheet::AssertValid() const
	{ SECMDIChildWnd::AssertValid(); }
void SECWorksheet::Dump(CDumpContext& dc) const
	{ SECMDIChildWnd::Dump(dc); }
#endif


// mdichild.cpp:50 ruft QCWorksheet::LoadFrame und damit diese Fassung auf.
// Das ist der Weg, auf dem jedes Dokumentfenster von Eudora entsteht.
BOOL SECWorksheet::LoadFrame(UINT nIDResource, DWORD dwDefaultStyle,
	CWnd* pParentWnd, CCreateContext* pContext)
{
	if (!CMDIChildWnd::LoadFrame(nIDResource, dwDefaultStyle, pParentWnd, pContext))
		return FALSE;

	RegisterWithWorkbook();
	return TRUE;
}


// Zugabe des Shims. Dass die Anmeldung vom Worksheet ausgeht, ist belegt:
// SECWorkbook fuehrt SECWorksheet als friend (SECWB.H:120) und haelt
// AddSheet/RemoveSheet geschuetzt (SECWB.H:179,180) - anders koennte das
// Worksheet sie nicht erreichen.
//
// UNGEPRUEFT: an welcher Stelle das Original die Anmeldung genau vornimmt.
// LoadFrame ist der einzige Erzeugungsweg, den Eudora selbst benutzt
// (mdichild.cpp:50); der zweite Weg, SECControlBarWorksheet ueber
// CreateFloatingMDIChild, ruft hier OnCreateClient auf und meldet sich dort an.
void SECWorksheet::RegisterWithWorkbook()
{
	SECWorkbook* pWorkbook = DYNAMIC_DOWNCAST(SECWorkbook, GetMDIFrame());
	if (pWorkbook == NULL)
		return;

	int nIndex = -1;
	if (!pWorkbook->LookupSheet(this, nIndex))
		pWorkbook->AddSheet(this);
}


// SECWB.H:74. workbook.cpp:133 und :361 umgehen diese Fassung ausdruecklich.
// Das Original hat hier die Registerkarte des ab- und die des angewaehlten
// Fensters fuer neu zu zeichnen erklaert - genau das, was Qualcomm durch
// eigenen Code ersetzt hat.
void SECWorksheet::OnMDIActivate(BOOL bActivate, CWnd* pActivateWnd, CWnd* pDeactivateWnd)
{
	CMDIChildWnd::OnMDIActivate(bActivate, pActivateWnd, pDeactivateWnd);
}


// SECWB.H:75. workbook.cpp:167  SECWorksheet::OnDestroy()
void SECWorksheet::OnDestroy()
{
	SECWorkbook* pWorkbook = DYNAMIC_DOWNCAST(SECWorkbook, GetMDIFrame());
	if (pWorkbook != NULL)
		pWorkbook->RemoveSheet(this);

	CMDIChildWnd::OnDestroy();
}


// SECWB.H:76. Ohne Registerkartenstreifen gibt es nichts nachzuziehen.
void SECWorksheet::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CMDIChildWnd::OnShowWindow(bShow, nStatus);
}


/////////////////////////////////////////////////////////////////////////////
// SECWorkbookClient

IMPLEMENT_DYNCREATE(SECWorkbookClient, CWnd)

BEGIN_MESSAGE_MAP(SECWorkbookClient, CWnd)
END_MESSAGE_MAP()


SECWorkbookClient::SECWorkbookClient()
{
	m_margins.SetRect(0, 0, 0, 0);
}

SECWorkbookClient::~SECWorkbookClient()
{
	// Sicherung: das Objekt haengt am MDICLIENT, das ihm nicht gehoert.
	// CWnd::~CWnd wuerde bei gesetztem m_hWnd DestroyWindow rufen
	// (wincore.cpp:798-807). SECWorkbook::OnDestroy loest die Verbindung
	// vorher; wird das Objekt auf anderem Weg abgeraeumt, faengt es diese
	// Zeile ab.
	if (m_hWnd != NULL)
		Detach();
}

#ifdef _DEBUG
void SECWorkbookClient::AssertValid() const
	{ CWnd::AssertValid(); }
void SECWorkbookClient::Dump(CDumpContext& dc) const
	{ CWnd::Dump(dc); }
#endif


// Reihenfolge der Argumente wie im Original (SECWB.H:96): left, right, top,
// bottom - CRect legt sie als left, top, right, bottom ab.
// workbook.cpp:729; mainfrm.cpp:5660, 5716
void SECWorkbookClient::SetMargins(int left, int right, int top, int bottom)
{
	m_margins.SetRect(left, top, right, bottom);

	// Der neue Rand wirkt erst beim naechsten Layoutdurchlauf. Alle drei
	// Aufrufstellen rufen danach selbst RecalcLayout, deshalb hier nichts.
}

void SECWorkbookClient::GetMargins(int& left, int& right, int& top, int& bottom)
{
	left   = m_margins.left;
	right  = m_margins.right;
	top    = m_margins.top;
	bottom = m_margins.bottom;
}


// Hier wirken die Raender. CWnd::RepositionBars ermittelt das
// "left over"-Fenster ueber CWnd::FromHandle und ruft darauf CalcWindowRect
// (wincore.cpp:3252-3266); weil das Objekt im permanenten Fensterverzeichnis
// steht, kommt diese Ueberschreibung zum Zug.
//
// Bei m_bWorkbookMode == FALSE setzt SetWorkbookMode keine Raender, das
// Rechteck bleibt also unveraendert und der MDI-Bereich fuellt den Rahmen.
// Eudora setzt trotzdem an zwei Stellen von sich aus Raender
// (mainfrm.cpp:5660, 5716, Sponsorenanzeige); die werden hier ehrlich
// beruecksichtigt.
void SECWorkbookClient::CalcWindowRect(LPRECT lpClientRect, UINT nAdjustType)
{
	CWnd::CalcWindowRect(lpClientRect, nAdjustType);

	lpClientRect->left   += m_margins.left;
	lpClientRect->top    += m_margins.top;
	lpClientRect->right  -= m_margins.right;
	lpClientRect->bottom -= m_margins.bottom;

	// Nicht ins Negative laufen lassen.
	if (lpClientRect->right < lpClientRect->left)
		lpClientRect->right = lpClientRect->left;
	if (lpClientRect->bottom < lpClientRect->top)
		lpClientRect->bottom = lpClientRect->top;
}


/////////////////////////////////////////////////////////////////////////////
// SECWorkbook

IMPLEMENT_DYNCREATE(SECWorkbook, SECMDIFrameWnd)

BEGIN_MESSAGE_MAP(SECWorkbook, SECMDIFrameWnd)
	ON_WM_ERASEBKGND()
	ON_WM_PAINT()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_DESTROY()
	// Die vier Kommandobehandler des Originals fehlen hier bewusst: es gibt
	// keine Kennungen dafuer. Siehe die Anmerkung in OTShim.h.
END_MESSAGE_MAP()


SECWorkbook::SECWorkbook()
{
	// VORGABE: Registerkartenbetrieb bleibt aus. Ohne ihn laeuft der gesamte
	// Zeichencode nie an - siehe den Abschnittskopf in OTShim.h.
	m_bWorkbookMode = FALSE;

	m_bShowIcons = TRUE;
	m_nScrollOffset = 0;
	m_pWBClient = NULL;
	m_pToolTips = NULL;

	// Ausgangswerte der Kartengeometrie. QCWorkbook ueberschreibt m_cxFold,
	// m_cxActive, m_cyActive und m_nMaxTabWidth sofort im eigenen Konstruktor
	// (workbook.cpp:663-666); die uebrigen bleiben so stehen. m_cyTab geht in
	// QCWorkbook::QCGetTaskBarRect ein (workbook.cpp:940), das aber nur im
	// Registerkartenbetrieb laeuft.
	m_cxTab = 100;
	m_cyTab = 20;
	m_cxFold = 8;
	m_cxActive = 2;
	m_cyActive = 2;
	m_nMaxTabWidth = 130;

	m_rectClientLast.SetRectEmpty();
}


SECWorkbook::~SECWorkbook()
{
	// Regelfall: OnDestroy hat schon aufgeraeumt. Diese Zeile faengt den Fall
	// ab, dass das Fenster nie erzeugt wurde.
	if (m_pWBClient != NULL)
	{
		if (m_pWBClient->GetSafeHwnd() != NULL)
			m_pWBClient->Detach();
		delete m_pWBClient;
		m_pWBClient = NULL;
	}

	m_worksheets.RemoveAll();

	m_fontTab.DeleteObject();
	m_penWhite.DeleteObject();
	m_penBlack.DeleteObject();
	m_penShadow.DeleteObject();
	m_penFace.DeleteObject();
}

#ifdef _DEBUG
void SECWorkbook::AssertValid() const
	{ SECMDIFrameWnd::AssertValid(); }
void SECWorkbook::Dump(CDumpContext& dc) const
	{ SECMDIFrameWnd::Dump(dc); }
#endif


// workbook.cpp:800 -> mainfrm.cpp:1285. Hier entsteht m_pWBClient.
//
// Zur Wahl von Attach statt SubclassWindow siehe den ausfuehrlichen Block bei
// SECWorkbookClient in OTShim.h. Kurz: mainfrm.cpp:1289 loest die Verbindung
// mit Detach - dem Gegenstueck von Attach - und subclasst danach selbst.
BOOL SECWorkbook::CreateClient(LPCREATESTRUCT lpCreateStruct, CMenu* pWindowMenu)
{
	if (!CMDIFrameWnd::CreateClient(lpCreateStruct, pWindowMenu))
		return FALSE;

	ASSERT(m_hWndMDIClient != NULL);
	if (m_hWndMDIClient == NULL)
		return FALSE;

	if (m_pWBClient == NULL)
		m_pWBClient = new SECWorkbookClient;

	if (m_pWBClient->GetSafeHwnd() == NULL)
		m_pWBClient->Attach(m_hWndMDIClient);

	ASSERT(m_pWBClient->GetSafeHwnd() == m_hWndMDIClient);

	// Zeichenwerkzeuge des Registerkartenstreifens. Sie werden in dieser
	// Stufe nie benutzt, muessen aber gueltig sein: QCWorkbook::OnDrawTab
	// waehlt m_penFace, m_penShadow und m_penBlack aus (workbook.cpp:1282,
	// 1287, 1293, 1315, 1326) und QCWorkbook::OnDrawTabIconAndLabel m_fontTab
	// (workbook.cpp:1374, 1549). Ein leeres CPen/CFont dort waere ein
	// Zusicherungsfehler.
	if (m_fontTab.GetSafeHandle() == NULL)
		m_fontTab.CreateStockObject(DEFAULT_GUI_FONT);
	if (m_penWhite.GetSafeHandle() == NULL)
		m_penWhite.CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_BTNHIGHLIGHT));
	if (m_penBlack.GetSafeHandle() == NULL)
		m_penBlack.CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_BTNTEXT));
	if (m_penShadow.GetSafeHandle() == NULL)
		m_penShadow.CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_BTNSHADOW));
	if (m_penFace.GetSafeHandle() == NULL)
		m_penFace.CreatePen(PS_SOLID, 1, ::GetSysColor(COLOR_BTNFACE));

	return TRUE;
}


void SECWorkbook::RecalcLayout(BOOL bNotify)
{
	// Im Original haette hier der Registerkartenstreifen seine Hoehe
	// nachgezogen (ueber m_rectClientLast und recalcTabWidth). Ohne Streifen
	// bleibt das gewoehnliche MDI-Layout.
	SECMDIFrameWnd::RecalcLayout(bNotify);
}


INT_PTR SECWorkbook::OnToolHitTest(CPoint point, TOOLINFO* pTI) const
{
	// Die Kurzhinweise der Registerkarten baut QCWorkbook selbst mit einem
	// eigenen Tooltip-Fenster (workbook.cpp:860-895, 1671-1730). m_pToolTips
	// des Originals bleibt ungenutzt.
	return CMDIFrameWnd::OnToolHitTest(point, pTI);
}


/////////////////////////////////////////////////////////////////////////////
// SECWorkbook - Listenpflege
//
// workbook.cpp:1227 und :1242 rufen diese Fassungen aus QCWorkbook auf und
// haengen nur ResetTaskBar an. Mehr als Listenpflege ist hier also nicht zu
// tun; die Zeichenarbeit des Originals entfaellt mit dem Streifen.

void SECWorkbook::AddSheet(SECWorksheet* pSheet)
{
	if (pSheet == NULL)
		return;

	int nIndex = -1;
	if (LookupSheet(pSheet, nIndex))
		return;						// schon drin

	pSheet->m_nPosition = (int) m_worksheets.Add(pSheet);
}


void SECWorkbook::RemoveSheet(SECWorksheet* pSheet)
{
	if (pSheet == NULL)
		return;

	int nIndex = -1;
	if (!LookupSheet(pSheet, nIndex))
		return;						// nicht (mehr) drin

	m_worksheets.RemoveAt(nIndex);
	pSheet->m_nPosition = -1;

	// Die Plaetze der nachfolgenden Karten ruecken auf.
	for (int i = nIndex; i < m_worksheets.GetSize(); i++)
	{
		SECWorksheet* pOther = (SECWorksheet*) m_worksheets.GetAt(i);
		if (pOther != NULL)
			pOther->m_nPosition = i;
	}
}


BOOL SECWorkbook::LookupSheet(SECWorksheet* pSheet, int& nIndex)
{
	for (int i = 0; i < m_worksheets.GetSize(); i++)
	{
		if (m_worksheets.GetAt(i) == (CObject*) pSheet)
		{
			nIndex = i;
			return TRUE;
		}
	}

	nIndex = -1;
	return FALSE;
}


// workbook.cpp:1047, 1632, 1703
SECWorksheet* SECWorkbook::GetWorksheet(int nSheet) const
{
	if (nSheet < 0 || nSheet >= m_worksheets.GetSize())
		return NULL;

	return (SECWorksheet*) m_worksheets.GetAt(nSheet);
}


// workbook.cpp:1628, 1701
int SECWorkbook::GetSheetCount() const
{
	return (int) m_worksheets.GetSize();
}


/////////////////////////////////////////////////////////////////////////////
// SECWorkbook - Registerkarten

// workbook.cpp:980 ruft diese Fassung auf, verschiebt danach alle Punkte und
// greift auf pts[3], pts[4] und pts[5] zu; davor steht ASSERT(count > 5)
// (workbook.cpp:987). QCGetTabRect prueft ASSERT(count >= 5), liest pts[0]
// und pts[4] und gibt das Feld mit delete[] frei (workbook.cpp:754-757).
// Daraus folgt zwingend: mindestens sechs Punkte, angelegt mit new CPoint[].
//
// Die Reihenfolge der Punkte laesst sich aus QCWorkbook::OnDrawTab ablesen
// (workbook.cpp:1283-1301): pts[1]->pts[0]->pts[5] zeichnet die linke und
// obere Kante, pts[2]->pts[4]->pts[5] die untere und rechte. Also
//     0 = oben links     1 = links unten (vor der Schraege)
//     2 = unten links    3 = unten rechts (vor der Schraege)
//     4 = unten rechts   5 = oben rechts
//
// UNGEPRUEFT: die tatsaechlichen Koordinaten des Originals. Ohne
// Registerkartenstreifen gibt es keinen Bezugspunkt, an dem sie haengen
// koennten. Deshalb liefert diese Fassung sechs Nullpunkte: QCGetTabRect
// bildet daraus ein leeres Rechteck, und die einzige Stelle, die davon auch
// ohne Registerkartenbetrieb erreicht wird - InvalidateRect in
// QCWorksheet::OnMDIActivate (workbook.cpp:143) - erklaert damit nur ein paar
// Pixel in der linken oberen Ecke des Rahmens fuer ungueltig, die ohnehin vom
// MDI-Bereich verdeckt sind.
void SECWorkbook::GetTabPts(SECWorksheet* /*pSheet*/, CPoint*& pts, int& count)
{
	count = 6;
	pts = new CPoint[count];

	for (int i = 0; i < count; i++)
		pts[i] = CPoint(0, 0);
}


// workbook.cpp:1360, 1537, 1635. Der Zeiger muss den Aufruf ueberleben:
// workbook.cpp:1363 macht _tcsdup darauf. Deshalb die Ablage im Objekt.
const TCHAR* SECWorkbook::GetTabLabel(SECWorksheet* pSheet) const
{
	if (pSheet == NULL || pSheet->GetSafeHwnd() == NULL)
		return NULL;

	pSheet->GetWindowText(m_strTabLabelBuf);
	return (const TCHAR*) m_strTabLabelBuf;
}


// Von Eudora nicht aufgerufen; QCWorkbook hat mit IsTabLabelTruncated eine
// eigene Fassung (workbook.cpp:1528). Nur wegen der Oberflaechentreue da.
BOOL SECWorkbook::IsFullTabTextVisible(SECWorksheet* /*pSheet*/)
{
	return TRUE;
}


// Von Eudora nicht aufgerufen; QCWorkbook rechnet den Textbereich in
// GetIconAndTextPositions selbst aus (workbook.cpp:1569).
BOOL SECWorkbook::GetTextRect(CPoint* /*pts*/, int /*ciIconWidth*/, CRect& rectText)
{
	rectText.SetRectEmpty();
	return FALSE;
}


// Von Eudora nicht aufgerufen. Wird ueber GetTabPts berechnet, liefert also
// derzeit ein leeres Gebiet.
void SECWorkbook::GetTabRgn(SECWorksheet* pSheet, CRgn& rgn)
{
	CPoint* pts = NULL;
	int count = 0;
	GetTabPts(pSheet, pts, count);

	rgn.CreateRectRgn(pts[0].x, pts[0].y, pts[4].x, pts[4].y);

	delete [] pts;
}


// Von Eudora nicht aufgerufen; QCWorkbook benutzt QCUpdateTab und
// QCInvalidateAllTabs (workbook.cpp:767, 955). Ohne Streifen nichts zu tun.
void SECWorkbook::InvalidateTab(SECWorksheet* /*pSheet*/, BOOL /*bInvalidAfter*/)
{
}

void SECWorkbook::InvalidateAllTabs()
{
}


// QCWorkbook ueberschreibt das vollstaendig (workbook.cpp:999) und ruft die
// Basisfassung nicht auf. Erreichbar waere sie nur im Registerkartenbetrieb.
int SECWorkbook::recalcTabWidth()
{
	return m_nMaxTabWidth;
}


/////////////////////////////////////////////////////////////////////////////
// SECWorkbook - Zeichnen
//
// Alle drei sind No-Op. Bei m_bWorkbookMode == FALSE ruft SECWorkbook::OnPaint
// sie gar nicht erst auf; es gibt keinen Streifen, in den zu zeichnen waere.
// Sie muessen aber existieren und virtuell bleiben, weil QCWorkbook alle drei
// ueberschreibt (workbook.h:217-219) und CMainFrame::OnDrawBorder
// (mainfrm.cpp:5772) an QCWorkbook::OnDrawBorder weiterreicht.

void SECWorkbook::OnDrawTab(CDC* /*pDC*/, SECWorksheet* /*pSheet*/)
{
}

void SECWorkbook::OnDrawBorder(CDC* /*pDC*/)
{
}

void SECWorkbook::OnDrawTabIconAndLabel(CDC* /*pDC*/, SECWorksheet* /*pSheet*/)
{
}


/////////////////////////////////////////////////////////////////////////////
// SECWorkbook - Operationen

// workbook.cpp:722 aus QCWorkbook::ShowMDITaskBar. Erreichbar ueber
// mainfrm.cpp:1025 (Start, Wert aus IDS_INI_MDI_TASKBAR) und settings.cpp:1060
// (Umschalten in den Einstellungen).
//
// VORGABE: m_bWorkbookMode bleibt FALSE. QCWorkbook::ShowMDITaskBar fragt den
// Wert unmittelbar danach ab (workbook.cpp:723) und ueberspringt bei FALSE
// SetMargins, RecalcLayout und ResetTaskBar - der MDI-Bereich behaelt also
// die volle Hoehe.
void SECWorkbook::SetWorkbookMode(BOOL bEnabled)
{
	if (bEnabled)
	{
		static BOOL bGemeldet = FALSE;
		OTShimNichtUmgesetzt(bGemeldet,
			_T("Die Fensterleiste am unteren Rand des Hauptfensters ")
			_T("(\"Auto-Wazoo\", Einstellung \"MDI Task Bar\"). Die Fenster ")
			_T("bleiben ueber das Menue \"Window\" erreichbar."));
	}

	// Bewusst keine Zuweisung an m_bWorkbookMode.
	if (m_pWBClient != NULL)
		m_pWBClient->SetMargins(0, 0, 0, 0);
}


// Von Eudora nicht aufgerufen (im Original der Menuebefehl "Symbole auf den
// Registerkarten"). Ohne Streifen ohne Wirkung, aber auch ohne Weg dorthin -
// deshalb keine Meldung.
void SECWorkbook::SetShowIcons(BOOL bShowIcons)
{
	m_bShowIcons = bShowIcons;
}


// workbook.cpp:1355, 1582. QCControlBarWorksheet::QCSetIcon schreibt m_hIcon
// unter Umgehung dieser Methode direkt (workbook.cpp:276) - deshalb bleibt
// m_hIcon ein geschuetzter Datenmember ohne Setzer, und SECWorkbook ist
// friend von SECWorksheet (SECWB.H:38).
HICON SECWorkbook::GetTabIcon(SECWorksheet* pSheet) const
{
	if (pSheet == NULL)
		return NULL;

	return pSheet->m_hIcon;
}


BOOL SECWorkbook::SetTabIcon(SECWorksheet* pSheet, HICON hIcon, BOOL /*bRedraw*/)
{
	if (pSheet == NULL)
		return FALSE;

	pSheet->m_hIcon = hIcon;
	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// SECWorkbook - Nachrichten

// mainfrm.cpp:1918
BOOL SECWorkbook::OnEraseBkgnd(CDC* pDC)
{
	return SECMDIFrameWnd::OnEraseBkgnd(pDC);
}


// mainfrm.cpp:1934. WICHTIG: die Fassung muss den ungueltigen Bereich
// abraeumen, sonst schickt Windows WM_PAINT endlos nach. CWnd::OnPaint ruft
// Default() und damit DefFrameProc, das BeginPaint/EndPaint erledigt.
//
// Im Original stuende hier der Streifen: OnDrawBorder, dann fuer jedes Sheet
// OnDrawTab und OnDrawTabIconAndLabel. Bei m_bWorkbookMode == FALSE faellt
// das komplett weg.
void SECWorkbook::OnPaint()
{
	SECMDIFrameWnd::OnPaint();
}


// workbook.cpp:1095 ersetzt diese Fassung vollstaendig und ruft statt dessen
// SECMDIFrameWnd::OnLButtonDown (workbook.cpp:1165), also CWnd::OnLButtonDown.
void SECWorkbook::OnLButtonDown(UINT nFlags, CPoint point)
{
	SECMDIFrameWnd::OnLButtonDown(nFlags, point);
}

void SECWorkbook::OnLButtonUp(UINT nFlags, CPoint point)
{
	SECMDIFrameWnd::OnLButtonUp(nFlags, point);
}


// Die vier Kommandobehandler haengen im Original an SEC-Menuebefehlen, zu
// denen es in SECRES.H keine Kennung gibt. Sie stehen in keiner
// Nachrichtentabelle und sind daher unerreichbar - definiert sind sie nur,
// damit die Klassenoberflaeche der Vorlage entspricht.
void SECWorkbook::OnViewWorkbook()
{
	SetWorkbookMode(!m_bWorkbookMode);
}

void SECWorkbook::OnUpdateViewWorkbook(CCmdUI* pCmdUI)
{
	if (pCmdUI != NULL)
		pCmdUI->SetCheck(m_bWorkbookMode);
}

void SECWorkbook::OnOptionsToggleIcons()
{
	SetShowIcons(!m_bShowIcons);
}

void SECWorkbook::OnUpdateOptionsToggleIcons(CCmdUI* pCmdUI)
{
	if (pCmdUI != NULL)
		pCmdUI->SetCheck(m_bShowIcons);
}


// mainfrm.cpp:3285  QCWorkbook::OnDestroy()
//
// Reihenfolge beachten: CMainFrame::OnDestroy hat unmittelbar davor sein
// eigenes SubclassWindow mit UnsubclassWindow geloest und das Objekt mit
// Attach wieder eingehaengt (mainfrm.cpp:3282-3283) - ausdruecklich damit die
// Basisklasse es hier abraeumen kann. Vor dem delete muss die Verbindung
// geloest werden, sonst wuerde CWnd::~CWnd das MDICLIENT-Fenster zerstoeren
// (wincore.cpp:798-807).
void SECWorkbook::OnDestroy()
{
	if (m_pWBClient != NULL)
	{
		if (m_pWBClient->GetSafeHwnd() != NULL)
			m_pWBClient->Detach();
		delete m_pWBClient;
		m_pWBClient = NULL;
	}

	m_worksheets.RemoveAll();

	SECMDIFrameWnd::OnDestroy();
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBarWorksheet

IMPLEMENT_DYNCREATE(SECControlBarWorksheet, SECWorksheet)

BEGIN_MESSAGE_MAP(SECControlBarWorksheet, SECWorksheet)
	ON_WM_SIZE()
	ON_WM_CLOSE()
	ON_WM_WINDOWPOSCHANGED()
	ON_WM_SHOWWINDOW()
END_MESSAGE_MAP()


SECControlBarWorksheet::SECControlBarWorksheet()
{
}

SECControlBarWorksheet::~SECControlBarWorksheet()
{
}


// workbook.cpp:287 (QCControlBarWorksheet::RecalcLayout) ueberspringt diese
// Fassung ausdruecklich zugunsten von SECWorksheet::RecalcLayout, weil das
// Original hier staendig den Fenstertitel neu gesetzt hat.
void SECControlBarWorksheet::RecalcLayout(BOOL bNotify)
{
	SECWorksheet::RecalcLayout(bNotify);
}


BOOL SECControlBarWorksheet::PreCreateWindow(CREATESTRUCT& cs)
{
	return SECWorksheet::PreCreateWindow(cs);
}


// STUFE 2. Hier legt das Original die eingebaute Andockleiste m_wndDockBar an
// und haengt die schwebende Leiste hinein. Ohne SECDockBar-Umsetzung geht das
// nicht; erreichbar ist der Weg ueber das Kontextmenue der Leisten
// (ID_SEC_MDIFLOAT, SECRES.H:191), deshalb die Meldung.
//
// Die Anmeldung beim Workbook geschieht trotzdem, damit m_worksheets auch
// diesen Erzeugungsweg erfasst.
BOOL SECControlBarWorksheet::OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext)
{
	static BOOL bGemeldet = FALSE;
	OTShimNichtUmgesetzt(bGemeldet,
		_T("Eine Leiste als eigenes Fenster im Hauptfenster ablegen. Das ")
		_T("Fenster entsteht ohne die eingebaute Andockleiste und bleibt leer."));

	RegisterWithWorkbook();

	return SECWorksheet::OnCreateClient(lpcs, pContext);
}


void SECControlBarWorksheet::OnSize(UINT nType, int cx, int cy)
{
	// Im Original wurde hier m_wndDockBar mitgezogen - Stufe 2.
	SECWorksheet::OnSize(nType, cx, cy);
}


// workbook.cpp:455 (QCControlBarWorksheet::OnClose) ersetzt diese Fassung und
// springt im Rest auf SECWorksheet::OnClose, also CFrameWnd::OnClose
// (workbook.cpp:521).
void SECControlBarWorksheet::OnClose()
{
	SECWorksheet::OnClose();
}


void SECControlBarWorksheet::OnWindowPosChanged(WINDOWPOS FAR* lpwndpos)
{
	SECWorksheet::OnWindowPosChanged(lpwndpos);
}


void SECControlBarWorksheet::OnShowWindow(BOOL bShow, UINT nStatus)
{
	SECWorksheet::OnShowWindow(bShow, nStatus);
}
