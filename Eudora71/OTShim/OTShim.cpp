// OTShim.cpp - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1, Stufen 0 bis 2
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
		_T("Die Ersatzschicht fuer das Stingray Objective Toolkit bildet die ")
		_T("benutzten Klassen nach, aber nicht jede Funktion darin. Was hier ")
		_T("fehlt, ist Beiwerk - Eudora bleibt bedienbar.\n\n")   
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


// Von den vier Zusatzangaben des Originals sind jetzt alle vier ausgewertet:
//   nCol/nRow   Spalte und Zeile in der Andockleiste. MFC kennt das nicht:
//               CDockBar::DockControlBar haengt eine Leiste ohne Rechteck
//               IMMER als eigene Zeile ans Ende (bardock.cpp:165-172).
//               Deshalb wird der Eintrag danach mit
//               SECDockBar::MoveControlBarToPosition an die verlangte Stelle
//               geschoben. Ohne das stand jede Wazoo-Leiste in einer eigenen
//               Zeile, und die prozentualen Breiten kamen nie zum Tragen.
//   fPctWidth   Anteil an der Zeilenbreite. Wird abgelegt und in
//               SECDockBar::AssignRowExtents angewandt; SECDockBar::NormalizeRow
//               normiert die Summe einer Zeile auf 1.0 (DockBar.cpp:264-293).
//   nHeight     Ausdehnung quer zur Andockleiste. Sie landet in m_szDockHorz.cy
//               bzw. m_szDockVert.cx, und genau daraus rechnet
//               SECControlBar::CalcFixedLayout. Ohne das waeren die
//               Wazoo-Leisten beim ersten Start unbrauchbar
//               (WazooBarMgr.cpp:242 uebergibt 180, der Kommentar bei :425
//               nennt den Wert ausdruecklich "the WIDTH when docked
//               vertically").
// Aufrufer: mainfrm.cpp:966, WazooBarMgr.cpp:253, 377, 386, 436,
// AdWazooBar.cpp:176, 212.
void SECMDIFrameWnd::DockControlBarEx(CControlBar* pBar, UINT nDockBarID,
	int nCol, int nRow, float fPctWidth, int nHeight)
{
	SECControlBar* pSECBar = DYNAMIC_DOWNCAST(SECControlBar, pBar);
	if (pSECBar != NULL)
	{
		pSECBar->m_fPctWidth = fPctWidth;
		pSECBar->m_fDockedPctWidth = fPctWidth;

		if (nHeight > 0)
		{
			pSECBar->m_szDockHorz.cy = nHeight;
			pSECBar->m_szDockVert.cx = nHeight;
		}
	}

	CMDIFrameWnd::DockControlBar(pBar, nDockBarID, NULL);

	// Erst NACH dem Andocken steht fest, in welcher SECDockBar die Leiste
	// gelandet ist. Ist es keine SECDockBar, bleibt es beim MFC-Verhalten.
	SECDockBar* pDockBar = (pBar != NULL)
						   ? DYNAMIC_DOWNCAST(SECDockBar, pBar->m_pDockBar)
						   : NULL;
	if (pDockBar != NULL)
		pDockBar->MoveControlBarToPosition(pBar, nCol, nRow);
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


// STUFE 2 OFFEN: eine Leiste als eigenes MDI-Kindfenster schweben lassen
// (Kommando ID_SEC_MDIFLOAT, SECRES.H:191).
//
// WARUM NICHT UMGESETZT: dazu muesste die Leiste aus der Andockleiste des
// Hauptfensters in die SECDockBar eines SECControlBarWorksheet umziehen,
// waehrend ihr m_pDockSite weiterhin auf das Hauptfenster zeigt. MFC hat
// dafuer kein Gegenstueck und setzt an mehreren Stellen das Gegenteil voraus
// (winfrm2.cpp:206 "ASSERT(pBar->m_pDockSite == this)").
//
// BEWUSST OHNE MELDUNG UND OHNE ERSATZHANDLUNG: der Weg wird beim Start
// durchlaufen - WazooBarMgr.cpp:243 fuer jede neu erzeugte Wazoo-Leiste und
// :381 fuer die zweite Gruppe. Ein Meldungsfenster beim Start waere
// unbrauchbar. "Statt dessen frei schweben lassen" waere es ebenso: Eudora
// startete dann mit mehreren losen Fenstern. Die Leiste bleibt deshalb
// einfach dort, wo DockControlBarEx sie unmittelbar davor hingesetzt hat -
// angedockt am Rand des Hauptfensters.
void SECMDIFrameWnd::FloatControlBarInMDIChild(CControlBar* pBar, CPoint /*point*/,
	DWORD /*dwStyle*/)
{
	TRACE1("OTShim: FloatControlBarInMDIChild - Stufe 2 offen, Leiste %p bleibt angedockt\n",
		pBar);
}

// Im Original: an der zuletzt gemerkten Stelle wieder schweben lassen. Der
// gemerkte Ort steckt in SECControlBar (Stufe 2), also wird hier die
// uebergebene Stelle benutzt. Von Eudora nicht aufgerufen.
void SECMDIFrameWnd::ReFloatControlBar(CControlBar* pBar, CPoint point, DWORD dwStyle)
{
	CMDIFrameWnd::FloatControlBar(pBar, point, dwStyle);
}

// STUFE 2 OFFEN, aus demselben Grund wie FloatControlBarInMDIChild - dort
// steht die ausfuehrliche Begruendung. Von Eudora nicht direkt aufgerufen;
// der einzige Weg hierher fuehrt ueber FloatControlBarInMDIChild, das nichts
// mehr tut.
// UNGEPRUEFT: ob das Original bei Misserfolg NULL liefert oder assertiert.
CMDIChildWnd* SECMDIFrameWnd::CreateFloatingMDIChild(DWORD /*dwStyle*/, CControlBar* /*pBar*/)
{
	TRACE0("OTShim: SECMDIFrameWnd::CreateFloatingMDIChild - Stufe 2 offen\n");
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


// m_wndDockBar mit bMDIChild == TRUE anlegen (sbardock.h:53-55): daran
// erkennt SECControlBar::IsMDIChild eine Leiste, die als MDI-Kindfenster
// schwebt. m_bAutoDelete aus - das Feld gehoert dem Worksheet, nicht dem
// Rahmenwerk; genauso haelt es CMiniDockFrameWnd (bardock.cpp:800).
SECControlBarWorksheet::SECControlBarWorksheet() :
	m_wndDockBar(FALSE, TRUE)
{
	m_wndDockBar.m_bAutoDelete = FALSE;
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


// Hier legt das Original die eingebaute Andockleiste m_wndDockBar an und
// haengt die schwebende Leiste hinein. Seit Stufe 2 gibt es SECDockBar, die
// Leiste wird also wirklich erzeugt - QCControlBarWorksheet liest gleich
// danach m_wndDockBar.m_dwStyle (workbook.cpp:371, 457).
//
// ERREICHT WIRD DIESE FASSUNG DERZEIT NICHT: der einzige Erzeugungsweg fuer
// ein SECControlBarWorksheet ist CreateFloatingMDIChild, und das liefert in
// dieser Stufe NULL. Der Rumpf steht trotzdem vollstaendig hier, damit beim
// Nachruesten des MDI-Schwebens nur dort noch etwas fehlt.
//
// Die Anmeldung beim Workbook geschieht wie bei jedem Worksheet, damit
// m_worksheets auch diesen Erzeugungsweg erfasst.
BOOL SECControlBarWorksheet::OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext)
{
	if (m_wndDockBar.GetSafeHwnd() == NULL)
	{
		// UNGEPRUEFT: die Kennung, die das Original vergibt. Gewaehlt ist
		// AFX_IDW_DOCKBAR_TOP, weil die Leiste den ganzen Innenbereich des
		// MDI-Kindfensters fuellen soll und CBRS_ALIGN_TOP die waagerechte
		// Ausrichtung ergibt. AFX_IDW_DOCKBAR_FLOAT scheidet aus - danach
		// sucht CFrameWnd::FloatControlBar (winfrm2.cpp:202), und dieses
		// Fenster ist kein Schweberahmen.
		if (!m_wndDockBar.Create(this, WS_CHILD | WS_VISIBLE | CBRS_ALIGN_TOP,
				AFX_IDW_DOCKBAR_TOP))
		{
			return FALSE;
		}
	}

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


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// STUFE 2 - ANDOCKFAMILIE
//
// Zur Begruendung jeder einzelnen Entscheidung siehe den Abschnitt "Stufe 2"
// in OTShim.h. Hier steht nur, was nicht in den Header passt.
//
// UEBERSETZUNG: dieser Abschnitt braucht zusaetzlich zwei Originalheader aus
// OT501/Include, die NICHT ersetzt sind - secres.h (die drei Kommandokennungen)
// und sdocksta.h (SECControlBarInfo, nur ueber Zeiger benutzt).

#ifndef ID_SEC_HIDE
#include "secres.h"			// ID_SEC_ALLOWDOCKING/-HIDE/-MDIFLOAT
#endif						// (SECRES.H:189-191)

#ifndef __SDOCKSTA_H__
#include "sdocksta.h"		// SECControlBarInfo (sdocksta.h:86)
#endif


/////////////////////////////////////////////////////////////////////////////
// SECGripperInfo
//
// Reiner Massesatz. Der Shim malt keinen Ziehgriff (siehe
// SECControlBar::DrawGripper), deshalb liest niemand diese Werte.
//
// UNGEPRUEFT: die Masse des Originals. Angesetzt sind die von MFC fuer seinen
// eigenen Griff benutzten (afximpl.h: AFX_CX_BORDER_GRIPPER 1, AFX_CX_GRIPPER
// 3), damit GetWidth/GetHeight etwas Plausibles liefern.

SECGripperInfo::SECGripperInfo()
{
	m_cxPad1   = 1;
	m_cxWidth1 = 1;
	m_cxPad2   = 1;
	m_cxWidth2 = 1;
	m_cxPad3   = 1;

	m_cyPad1   = 1;
	m_cyWidth1 = 1;
	m_cyPad2   = 1;
	m_cyWidth2 = 1;
	m_cyPad3   = 1;

	m_nGripperOffSidePadding = 1;
}

SECGripperInfo::~SECGripperInfo()
{
}

int SECGripperInfo::GetWidth()
{
	return m_cxPad1 + m_cxWidth1 + m_cxPad2 + m_cxWidth2 + m_cxPad3;
}

int SECGripperInfo::GetHeight()
{
	return m_cyPad1 + m_cyWidth1 + m_cyPad2 + m_cyWidth2 + m_cyPad3;
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar

IMPLEMENT_DYNCREATE(SECControlBar, CControlBar)

// mainfrm.cpp:1019 schaltet das Merkmal beim Start ab. Im Original steuerte es,
// ob SECDockBar Neuzeichnen-Anforderungen sammelt, statt sie sofort
// auszufuehren. Der Shim sammelt ohnehin nicht (SECDockBar::InvalidateBar),
// das Feld ist also nur noch Ablage. Vorgabe TRUE wie der Name nahelegt.
BOOL SECControlBar::m_bOptimizedRedrawEnabled = TRUE;

// Die drei SEC-Kommandos kommen per SendMessage(WM_COMMAND, ...) an die Leiste
// (WazooBarMgr.cpp:243, 381, 415, 442, 623; WazooWnd.cpp:471, 492, 513) und
// brauchen deshalb echte Eintraege. Die uebrigen Eintraege reichen an CControlBar
// durch; sie stehen hier, weil Eudora die Behandler qualifiziert aufruft
// (WazooBar.cpp:1226, 1238; SearchBar.cpp:1575).
BEGIN_MESSAGE_MAP(SECControlBar, CControlBar)
	ON_COMMAND(ID_SEC_HIDE, &SECControlBar::OnHide)
	ON_COMMAND(ID_SEC_ALLOWDOCKING, &SECControlBar::OnToggleAllowDocking)
	ON_COMMAND(ID_SEC_MDIFLOAT, &SECControlBar::OnFloatAsMDIChild)
	ON_WM_SIZE()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_CONTEXTMENU()
	ON_WM_DESTROY()
	ON_WM_ERASEBKGND()
END_MESSAGE_MAP()


// UNGEPRUEFT: die Vorgabemasse des Originals. (0,0) waere naheliegend, machte
// aber jede Leiste unsichtbar, die ihre Masse nicht selbst setzt - denn
// CalcFixedLayout liest genau diese Felder. CWazooBar hebt sie erst in
// LoadWazooConfigFromIni auf mindestens 20 an (WazooBar.cpp:560-565), also
// nach dem ersten Andocken. Deshalb hier ein brauchbarer Anfangswert; die
// wirklichen Masse setzt SECMDIFrameWnd::DockControlBarEx aus dem Argument
// nHeight (WazooBarMgr.cpp:242 uebergibt 180).
SECControlBar::SECControlBar()
{
	m_szDockHorz = CSize(200, 100);
	m_ptDockHorz = CPoint(0, 0);
	m_szDockVert = CSize(200, 100);
	m_szFloat    = CSize(200, 100);

	m_dwMRUDockingState = CBRS_ALIGN_ANY;
	m_fPctWidth       = (float)1.0;
	m_fDockedPctWidth = (float)1.0;
	m_dwExStyle       = 0;
	m_nRowExtent      = 0;

	m_rcBorderSpace.SetRectEmpty();
	m_pManager = NULL;

	m_rcGripperCloseButton.SetRectEmpty();
	m_bClickingGripperClose = FALSE;
	m_rcGripperExpandButton.SetRectEmpty();
	m_bClickingGripperExpand = FALSE;
	m_bGripperExpandEnabled = FALSE;
	m_bGripperExpandExpanding = FALSE;
	m_bGripperExpandHorz = TRUE;

	m_pArrLayoutInfo = NULL;
}


SECControlBar::~SECControlBar()
{
	DeleteLayoutInfo();
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Erzeugung
//
// ECHTE STINGRAY-FUNKTIONALITAET: CControlBar hat kein Create (afxext.h:132
// erklaert die Klasse ausdruecklich als abstrakt), jede MFC-Leiste bringt ihr
// eigenes mit. Diese Fassung ist an CDialogBar::Create (bardlg.cpp) und
// CToolBar::CreateEx (bartool.cpp) angelehnt.
//
// WICHTIG ZUR STILAUFTEILUNG: dwStyle enthaelt Leistenstile (CBRS_*) und
// Fensterstile (WS_*) im selben Wort - das ist der Punkt, ueber den sich
// WazooBar.cpp:82-93 beschwert. m_dwStyle bekommt nur den CBRS-Anteil, das
// Fenster nur den Rest. Beide Aufrufstellen filtern schon selbst mit
// "& CBRS_ALL" und tragen die WS-Bits danach mit ModifyStyle nach
// (WazooBar.cpp:104-106, SearchBar.cpp:584-586).

BOOL SECControlBar::Create(LPCTSTR lpszClassName, LPCTSTR lpszWindowName, UINT nID,
	DWORD dwStyle, DWORD dwExStyle, const RECT& rect, CWnd* pParentWnd,
	CCreateContext* pContext)
{
	ASSERT_VALID(pParentWnd);
	if (pParentWnd == NULL)
		return FALSE;

	m_dwStyle   = dwStyle & CBRS_ALL;
	m_dwExStyle = dwExStyle;

	// Ohne eigene Fensterklasse eine mit Doppelklickmeldung und
	// Systemfarbe-Hintergrund anlegen - dieselbe Wahl trifft CDialogBar.
	if (lpszClassName == NULL)
	{
		lpszClassName = ::AfxRegisterWndClass(CS_DBLCLKS,
			::LoadCursor(NULL, IDC_ARROW), (HBRUSH)(COLOR_BTNFACE + 1), NULL);
	}

	// WS_VISIBLE bewusst NICHT setzen: beide Aufrufstellen entscheiden
	// hinterher selbst darueber, und der Leistenverwalter blendet einen Teil
	// der Leisten direkt nach dem Anlegen wieder aus (WazooBarMgr.cpp:415).
	DWORD dwWndStyle = (dwStyle & ~CBRS_ALL)
		| WS_CHILD | WS_CLIPCHILDREN | WS_CLIPSIBLINGS;

	// CWnd::Create ruft PreCreateWindow und damit CControlBar::PreCreateWindow
	// (barcore.cpp:86) auf; die Randstile werden dort aus m_dwStyle abgeleitet,
	// weshalb m_dwStyle oben schon stehen muss. CControlBar::OnCreate
	// (barcore.cpp:554) meldet die Leiste danach beim Rahmen an - das setzt
	// m_pDockSite und ist die Voraussetzung fuers spaetere Andocken.
	return CWnd::Create(lpszClassName, lpszWindowName, dwWndStyle, rect,
		pParentWnd, nID, pContext);
}


// sbarcore.h:129. Bequemere Fassung; WazooBar.cpp:112 macht dasselbe.
BOOL SECControlBar::Create(CWnd* pParentWnd, LPCTSTR lpszWindowName, DWORD dwStyle,
	DWORD dwExStyle, UINT nID, CCreateContext* pContext)
{
	// Ueber die virtuelle Fassung, damit eine abgeleitete Klasse ihre eigene
	// zu sehen bekommt (CWazooBar tut genau das, WazooBar.cpp:94).
	return Create(NULL, lpszWindowName, nID, dwStyle, dwExStyle,
		CRect(0, 0, 0, 0), pParentWnd, pContext);
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Abfragen

// WazooBar.cpp:1246, 1270. Der Innenbereich ist der Client-Bereich abzueglich
// der Raender.
void SECControlBar::GetInsideRect(CRect& rectInside) const
{
	GetClientRect(&rectInside);
	CalcInsideRect(rectInside,
		(m_dwStyle & CBRS_ORIENT_HORZ) ? TRUE : FALSE,
		(m_dwStyle & CBRS_ORIENT_VERT) ? TRUE : FALSE);
}


// Genau dafuer traegt SECDockBar sein m_bMDIChild (sbardock.h:55, 126): eine
// Leiste schwebt als MDI-Kindfenster, wenn ihre Andockleiste zu einem
// SECControlBarWorksheet gehoert.
//
// FOLGE IN DIESER STUFE: da FloatControlBarInMDIChild nichts tut, gibt es
// keine solche Andockleiste, und die Antwort ist immer FALSE. Genau das ist
// das gewuenschte Verhalten - Eudora fragt an vielen Stellen ab und macht bei
// FALSE das Uebliche (WazooBar.cpp:652, 690, 864; WazooWnd.cpp:534).
BOOL SECControlBar::IsMDIChild() const
{
	SECDockBar* pDockBar = DYNAMIC_DOWNCAST(SECDockBar, m_pDockBar);
	return (pDockBar != NULL) && pDockBar->m_bMDIChild;
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Operationen

// Verdeckt CControlBar::EnableDocking (afxext.h:162). Der einzige Zusatz ist
// das Merken des Zustands fuer "Allow Docking" (WazooWnd.cpp:492).
void SECControlBar::EnableDocking(DWORD dwDockStyle)
{
	m_dwMRUDockingState = dwDockStyle;
	CControlBar::EnableDocking(dwDockStyle);
}


void SECControlBar::SetExBarStyle(DWORD dwExStyle, BOOL bAutoUpdate)
{
	DWORD dwOld = m_dwExStyle;
	m_dwExStyle = dwExStyle;

	if (!bAutoUpdate || dwOld == m_dwExStyle || GetSafeHwnd() == NULL)
		return;

	// Die erweiterten Stile aendern Raender und Zeichnung, also neu anordnen.
	Invalidate();
	if (m_pDockSite != NULL)
		m_pDockSite->RecalcLayout();
}


void SECControlBar::ModifyBarStyleEx(DWORD dwRemove, DWORD dwAdd, BOOL bAutoUpdate)
{
	SetExBarStyle((m_dwExStyle & ~dwRemove) | dwAdd, bAutoUpdate);
}


// SearchBar.cpp:1269 ruft diese Fassung auf, um die Toolbar-Fassung von
// SECCustomToolBar zu umgehen. Kategorie A: die Kurzhinweise verwaltet CWnd.
INT_PTR SECControlBar::OnToolHitTest(CPoint point, TOOLINFO* pTI) const
{
	return CControlBar::OnToolHitTest(point, pTI);
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Anordnung

// ECHTE STINGRAY-FUNKTIONALITAET. CControlBar::CalcFixedLayout liefert nur
// 0 oder 32767 (barcore.cpp:210-216) und weiss nichts von den drei
// gespeicherten Massen. Genau diese Fassung erwartet CAdWazooBar
// (AdWazooBar.cpp:239): sie holt sich das Ergebnis und begrenzt es nach unten.
CSize SECControlBar::CalcFixedLayout(BOOL bStretch, BOOL bHorz)
{
	CSize size;

	if (IsFloating())
		size = m_szFloat;
	else if (bHorz)
		size = m_szDockHorz;
	else
		size = m_szDockVert;

	// Nicht gesetzt: an MFC abgeben, damit wenigstens die Streckregel stimmt.
	if (size.cx <= 0 && size.cy <= 0)
		return CControlBar::CalcFixedLayout(bStretch, bHorz);

	// Streckung in Zeilenrichtung. Hat SECDockBar dieser Leiste fuer den
	// laufenden Anordnungsdurchlauf eine Zeilenlaenge zugeteilt, gilt die
	// statt der MFC-Streckmarke 32767. Ohne das belegte die erste Leiste
	// einer Zeile die ganze Zeile und jede weitere wurde von
	// CDockBar::CalcFixedLayout in eine neue Zeile umgebrochen
	// (bardock.cpp:441-447) - siehe SECDockBar::AssignRowExtents.
	if (bStretch)
	{
		if (bHorz)
			size.cx = (m_nRowExtent > 0) ? m_nRowExtent : 32767;
		else
			size.cy = (m_nRowExtent > 0) ? m_nRowExtent : 32767;
	}

	return size;
}


// Fuer Leisten mit CBRS_SIZE_DYNAMIC. CSearchBar bringt eine eigene Fassung
// mit (SearchBar.cpp:1340), CWazooBar nicht.
CSize SECControlBar::CalcDynamicLayout(int nLength, DWORD dwMode)
{
	if (dwMode & LM_HORZDOCK)
		return CalcFixedLayout(TRUE, TRUE);
	if (dwMode & LM_VERTDOCK)
		return CalcFixedLayout(TRUE, FALSE);

	// Schwebend zieht der Anwender an den Raendern; nLength ist die neue
	// Ausdehnung in Ziehrichtung.
	if (nLength > 0 && IsFloating())
	{
		CSize size = m_szFloat;
		if (dwMode & LM_LENGTHY)
			size.cy = max(nLength, 20);
		else
			size.cx = max(nLength, 20);

		if (dwMode & LM_COMMIT)
			m_szFloat = size;

		return size;
	}

	return CalcFixedLayout((dwMode & LM_STRETCH) != 0, (dwMode & LM_HORZ) != 0);
}


// Drei Argumente wie im Original (sbarcore.h:200). Damit ist die zweistellige
// virtuelle CControlBar::CalcInsideRect verdeckt; MFC-interne Aufrufe gehen
// weiter an die Basisfassung, was richtig ist.
//
// UNGEPRUEFT: was bVert im Original bewirkt. Die einzige Aufrufstelle
// (QCCustomToolBar.cpp:162) uebergibt die beiden Ausrichtungsbits einzeln,
// also genau die Angabe, die CControlBar::CalcInsideRect schon aus m_dwStyle
// zieht (barcore.cpp:1151-1184). Der zweite Wert bleibt deshalb unbenutzt.
void SECControlBar::CalcInsideRect(CRect& rect, BOOL bHorz, BOOL /*bVert*/) const
{
	CControlBar::CalcInsideRect(rect, bHorz);
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Zeichnen
//
// Kategorie A bis auf den Ziehgriff: CControlBar zeichnet Raender und
// Hintergrund selbst.

void SECControlBar::DoPaint(CDC* pDC)
{
	CControlBar::DoPaint(pDC);
}

void SECControlBar::DrawBorders(CDC* pDC, CRect& rect)
{
	CControlBar::DrawBorders(pDC, rect);
}

void SECControlBar::EraseNonClient()
{
	CControlBar::EraseNonClient();
}


// ZIEHGRIFF - BEWUSST NICHT NACHGEBAUT.
//
// Der Griff ist der schmale Streifen am linken bzw. oberen Rand einer
// angedockten Leiste, mit dem man sie loszieht, dazu wahlweise ein Schliess-
// und ein Aufklappknopf (CBRS_EX_GRIPPER, -_CLOSE, -_EXPAND). Eudora schaltet
// ihn nur ein, wenn die Einstellung "Cool Bars" gesetzt ist
// (SearchBar.cpp:571-572).
//
// GRUND: es geht ohne. Losziehen geht auch am Leistenhintergrund
// (CControlBar::OnLButtonDown, barcore.cpp), Schliessen ueber das
// Kontextmenue ("Hide"), Aufklappen ist eine reine Bequemlichkeit. Ein
// nachgemalter Griff dagegen muesste in CalcInsideRect, DoPaint,
// OnLButtonDown/-Up, OnMouseMove und OnToolHitTest zusammenpassen - viel
// Zeichencode fuer nichts, was nicht anders erreichbar waere.
//
// FOLGE: die Leisten sehen ohne Griff aus wie MFC-Leisten. AdjustInsideRect-
// ForGripper haelt keinen Platz frei, also entsteht auch keine Luecke.

void SECControlBar::AdjustInsideRectForGripper(CRect& /*rect*/, BOOL /*bHorz*/)
{
}

void SECControlBar::DrawGripper(CDC* /*pDC*/, CRect& /*rect*/)
{
}

void SECControlBar::DrawGripperCloseButton(CDC* /*pDC*/, CRect& /*rect*/, BOOL /*bHorz*/)
{
}

void SECControlBar::DrawGripperCloseButtonDepressed(CDC* /*pDC*/)
{
}

void SECControlBar::DrawGripperCloseButtonRaised(CDC* /*pDC*/)
{
}

void SECControlBar::DrawGripperExpandButton(CDC* /*pDC*/, CRect& /*rect*/, BOOL /*bHorz*/)
{
}

void SECControlBar::DrawGripperExpandButtonDepressed(CDC* /*pDC*/)
{
}

void SECControlBar::DrawGripperExpandButtonRaised(CDC* /*pDC*/)
{
}

void SECControlBar::SetGripperExpandButtonState(BOOL bHorz)
{
	// Die beiden Felder bleiben gepflegt, damit ein spaeterer Nachbau des
	// Griffs sie vorfindet.
	m_bGripperExpandHorz = bHorz;
	m_bGripperExpandExpanding = !m_bGripperExpandExpanding;
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Zustand sichern und zuruecklesen
//
// WazooBarMgr.cpp:432-436 benutzt das Paar, um allein die Andockhoehe zu
// aendern:
//     SECControlBarInfo info;
//     pWazooBar->GetBarInfo(&info);
//     info.m_szDockHorz.cy = 80;
//     pWazooBar->SetBarInfo(&info, pMainFrame);
// Der Weg muss also verlustfrei hin und zurueck fuehren.

void SECControlBar::GetBarInfo(SECControlBarInfo* pInfo)
{
	ASSERT(pInfo != NULL);
	if (pInfo == NULL)
		return;

	// Der MFC-Anteil (Kennung, Sichtbarkeit, Lage, Andockkontext)
	CControlBar::GetBarInfo(pInfo);

	// Der Stingray-Anteil (sdocksta.h:94-108)
	pInfo->m_szDockHorz        = m_szDockHorz;
	pInfo->m_ptDockHorz        = m_ptDockHorz;
	pInfo->m_szDockVert        = m_szDockVert;
	pInfo->m_szFloat           = m_szFloat;
	pInfo->m_dwMRUDockingState = m_dwMRUDockingState;
	pInfo->m_dwDockStyle       = m_dwDockStyle;
	pInfo->m_fPctWidth         = m_fPctWidth;
	pInfo->m_dwStyle           = m_dwStyle;
	pInfo->m_dwExStyle         = m_dwExStyle;
	pInfo->m_bMDIChild         = IsMDIChild();
	pInfo->m_bPreviouslyFloating = IsFloating();

	// Zuletzt bekommt die abgeleitete Klasse ihre Gelegenheit
	// (SearchBar.cpp:1162, QCCustomToolBar.cpp:334).
	GetBarInfoEx(pInfo);
}


void SECControlBar::SetBarInfo(SECControlBarInfo* pInfo, CFrameWnd* pFrameWnd)
{
	ASSERT(pInfo != NULL);
	if (pInfo == NULL)
		return;

	m_szDockHorz        = pInfo->m_szDockHorz;
	m_ptDockHorz        = pInfo->m_ptDockHorz;
	m_szDockVert        = pInfo->m_szDockVert;
	m_szFloat           = pInfo->m_szFloat;
	m_dwMRUDockingState = pInfo->m_dwMRUDockingState;
	m_fPctWidth         = pInfo->m_fPctWidth;
	m_dwExStyle         = pInfo->m_dwExStyle;

	// m_dwStyle und m_dwDockStyle bewusst NICHT zurueckgeschrieben: beide
	// haengen am tatsaechlichen Fensterzustand, den CControlBar::SetBarInfo
	// gleich anfasst. Sie aus einer moeglicherweise alten Aufzeichnung zu
	// ueberschreiben, brachte die Leiste und ihre Andockleiste auseinander.

	CControlBar::SetBarInfo(pInfo, pFrameWnd);

	SetBarInfoEx(pInfo, pFrameWnd);

	// Kein RecalcLayout: die einzige Aufrufstelle ordnet unmittelbar danach
	// ohnehin neu an (WazooBarMgr.cpp ruft SetDefaultDockState im Block, und
	// mainfrm.cpp:5661 zieht nach). Ein Neuanordnen mitten in der
	// Startreihenfolge waere nur eine Fehlerquelle.
}


// Die beiden sind im Original leer und ausschliesslich zum Ueberschreiben da.
// SearchBar.cpp:1165 und :1192 rufen sie ausdruecklich auf, um die Fassung von
// SECCustomToolBar zu ueberspringen; QCCustomToolBar.cpp:334 erweitert sie.
void SECControlBar::GetBarInfoEx(SECControlBarInfo* /*pInfo*/)
{
}

void SECControlBar::SetBarInfoEx(SECControlBarInfo* /*pInfo*/, CFrameWnd* /*pFrameWnd*/)
{
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Meldungen an die Leiste
//
// Keine Befehle, sondern Mitteilungen des Rahmenwerks ueber einen bereits
// vollzogenen Wechsel. Im Original leer; CWazooBar haengt sich an zwei davon
// (WazooBar.cpp:1544, 1577) und ruft anschliessend diese Fassungen auf,
// QC3DTabWnd.cpp:284 loest OnBarFloat von aussen aus.
//
// STUFE 2 OFFEN: der Shim loest sie nicht selbst aus - dazu muesste er das
// Andocken und Losloesen selbst in der Hand haben, was hier MFC tut.
// Aufgerufen werden sie also nur ueber die genannte Stelle in QC3DTabWnd.

void SECControlBar::OnBarDock()
{
}

void SECControlBar::OnBarFloat()
{
}

void SECControlBar::OnBarMDIFloat()
{
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Kontextmenue
//
// Der Einstieg ist WM_CONTEXTMENU auf der Leiste selbst. Eudora baut fuer die
// Wazoo-Fenster ein eigenes Menue (WazooWnd.cpp:88-183) und haengt dieselben
// drei Kennungen an; diese Fassung greift also nur, wenn der Anwender neben
// die Wazoo-Flaeche trifft.

void SECControlBar::OnContextMenu(CWnd* /*pWnd*/, CPoint point)
{
	// Ohne den Stil gehoert das Menue nicht der Leiste (sbarcore.h:52).
	if ((m_dwExStyle & CBRS_EX_STDCONTEXTMENU) == 0)
	{
		Default();
		return;
	}

	CMenu menu;
	if (!menu.CreatePopupMenu())
		return;

	// Die Beschriftungen stehen in SECRES.RC:412-414 ("Allow Docking",
	// "Hide", "Float In Main Window"). Eudora bindet die Datei mit ein
	// (EudoraRes.rc:11712), die Zeichenketten sind also zur Laufzeit da.
	CString strItem;

	if (strItem.LoadString(ID_SEC_ALLOWDOCKING))
	{
		UINT nFlags = MF_STRING;
		if (m_dwDockStyle & CBRS_ALIGN_ANY)
			nFlags |= MF_CHECKED;
		menu.AppendMenu(nFlags, ID_SEC_ALLOWDOCKING, strItem);
	}

	if (strItem.LoadString(ID_SEC_HIDE))
		menu.AppendMenu(MF_STRING, ID_SEC_HIDE, strItem);

	// "Float In Main Window" nur, wenn die Leiste das ueberhaupt darf. Ohne
	// die Umsetzung von FloatControlBarInMDIChild taete der Punkt nichts;
	// weggelassen ist ehrlicher als ein Menuepunkt ohne Wirkung.
	if ((m_dwExStyle & CBRS_EX_ALLOW_MDI_FLOAT) &&
		strItem.LoadString(ID_SEC_MDIFLOAT))
	{
		menu.AppendMenu(MF_SEPARATOR);
		UINT nFlags = MF_STRING;
		if (IsMDIChild())
			nFlags |= MF_CHECKED;
		menu.AppendMenu(nFlags, ID_SEC_MDIFLOAT, strItem);
	}

	// CWazooBar (WazooBar.cpp:1075) und CAdWazooBar (AdWazooBar.cpp:297)
	// nehmen hier Punkte weg bzw. hinzu.
	OnExtendContextMenu(&menu);

	if (menu.GetMenuItemCount() > 0)
		menu.TrackPopupMenu(TPM_LEFTALIGN | TPM_RIGHTBUTTON, point.x, point.y, this);
}


// Im Original leer, nur zum Ueberschreiben.
void SECControlBar::OnExtendContextMenu(CMenu* /*pMenu*/)
{
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - die drei SEC-Kommandos

// ID_SEC_HIDE. Reichlich benutzt und deshalb wirklich umgesetzt:
// WazooBarMgr.cpp:415, 442, 623 blenden Leisten beim Start aus,
// WazooWnd.cpp:513 auf Wunsch des Anwenders.
void SECControlBar::OnHide()
{
	CFrameWnd* pFrame = GetDockingFrame();
	if (pFrame == NULL)
		return;

	pFrame->ShowControlBar(this, FALSE, FALSE);
}


// ID_SEC_ALLOWDOCKING. Erreichbar ueber das Kontextmenue (WazooWnd.cpp:492);
// den Hakenzustand liest Eudora selbst aus m_dwDockStyle (WazooWnd.cpp:163).
void SECControlBar::OnToggleAllowDocking()
{
	if (m_dwDockStyle & CBRS_ALIGN_ANY)
	{
		// Andocken abschalten. Der bisherige Zustand wird gemerkt - genau
		// dafuer ist m_dwMRUDockingState da (sbarcore.h:141).
		m_dwMRUDockingState = m_dwDockStyle;
		m_dwDockStyle &= ~CBRS_ALIGN_ANY;

		// Eine gerade angedockte Leiste muss dabei losgeloest werden, sonst
		// bliebe sie an einem Platz stehen, den sie laut Einstellung nicht
		// mehr haben darf.
		if (!IsFloating() && m_pDockSite != NULL)
		{
			CRect rect;
			GetWindowRect(&rect);
			m_pDockSite->FloatControlBar(this, rect.TopLeft(), CBRS_ALIGN_TOP);
		}
	}
	else
	{
		m_dwDockStyle = m_dwMRUDockingState;
	}
}


// ID_SEC_MDIFLOAT. CWazooBar faengt das Kommando vorher ab und ruft diese
// Fassung von Hand auf (WazooBar.cpp:1418), um danach den Fenstertitel
// nachzuziehen.
//
// STUFE 2 OFFEN - die Begruendung steht bei
// SECMDIFrameWnd::FloatControlBarInMDIChild.
void SECControlBar::OnFloatAsMDIChild()
{
	SECMDIFrameWnd* pFrame = DYNAMIC_DOWNCAST(SECMDIFrameWnd, GetDockingFrame());
	if (pFrame == NULL)
		return;

	CRect rect;
	GetWindowRect(&rect);

	pFrame->FloatControlBarInMDIChild(this, rect.TopLeft(),
		m_dwStyle & CBRS_ALIGN_ANY);
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Zwischenspeicher der Kinderlage
//
// Im Original merkt sich die Leiste vor einem Ziehvorgang Fenster und Lage
// aller Kinder, um beim Loslassen nicht alles neu berechnen zu muessen. Ohne
// die prozentualen Zeilenbreiten gibt es diesen Vorgang nicht; das Feld wird
// nie angelegt. DeleteLayoutInfo bleibt trotzdem vollstaendig, damit ein
// spaeterer Nachbau nur InitLayoutInfo fuellen muss.

void SECControlBar::InitLayoutInfo()
{
	DeleteLayoutInfo();
}


void SECControlBar::DeleteLayoutInfo()
{
	if (m_pArrLayoutInfo == NULL)
		return;

	for (int i = 0; i < m_pArrLayoutInfo->GetSize(); i++)
		delete (LayoutInfo*) m_pArrLayoutInfo->GetAt(i);

	m_pArrLayoutInfo->RemoveAll();
	delete m_pArrLayoutInfo;
	m_pArrLayoutInfo = NULL;
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBar - Nachrichten
//
// Alle Kategorie A. Sie stehen nur deshalb hier, weil Eudora sie qualifiziert
// aufruft und ein Weglassen einen Linkerfehler gaebe.

// WazooBar.cpp:1238, SearchBar.cpp:1575
void SECControlBar::OnSize(UINT nType, int cx, int cy)
{
	CControlBar::OnSize(nType, cx, cy);
}

// CControlBar::OnLButtonDown startet das Ziehen ueber m_pDockContext
// (barcore.cpp) - genau das soll passieren.
void SECControlBar::OnLButtonDown(UINT nFlags, CPoint pt)
{
	CControlBar::OnLButtonDown(nFlags, pt);
}

void SECControlBar::OnLButtonUp(UINT nFlags, CPoint pt)
{
	CControlBar::OnLButtonUp(nFlags, pt);
}

// Doppelklick schaltet zwischen angedockt und schwebend um (CControlBar).
void SECControlBar::OnLButtonDblClk(UINT nFlags, CPoint pt)
{
	CControlBar::OnLButtonDblClk(nFlags, pt);
}

// WazooBar.cpp:1226
void SECControlBar::OnDestroy()
{
	DeleteLayoutInfo();
	CControlBar::OnDestroy();
}

BOOL SECControlBar::OnEraseBkgnd(CDC* pDC)
{
	return CControlBar::OnEraseBkgnd(pDC);
}


// In CControlBar rein virtuell (afxext.h:166), muss also besetzt werden.
//
// BEWUSST LEER: eine SECControlBar enthaelt Fenster, keine Knopfleiste. Fuer
// Fenster erledigt MFC die Aktualisierung ueber deren eigene Nachrichtenwege.
// Dass das die Absicht ist, sagt CSearchBar selbst - sie ueberschreibt die
// Fassung von SECCustomToolBar und ruft diese hier auf, mit der Begruendung,
// sie wolle "mostly just the functionality of being an SECControlBar"
// (SearchBar.cpp:1230-1246). CWazooBar bringt eine eigene mit (WazooBar.h:76).
void SECControlBar::OnUpdateCmdUI(CFrameWnd* /*pTarget*/, BOOL /*bDisableIfNoHndler*/)
{
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
// SECDockBar

IMPLEMENT_DYNAMIC(SECDockBar, CDockBar)

// UNGEPRUEFT: der Wert des Originals. FALSE bedeutet: keine zusaetzliche
// vertiefte Kante zum MDI-Bereich hin. Eudora fragt das Feld nirgends ab.
BOOL SECDockBar::m_bBorderClientEdge = FALSE;

// UNGEPRUEFT: die Masse des Originals. 4 Pixel entsprechen der ueblichen
// Breite eines Ziehbalkens (halbe Fensterrahmenbreite). Weil in dieser Stufe
// nie ein Splitter angelegt wird, hat der Wert keine Wirkung.
const int SECDockBar::Splitter::cx = 4;
const int SECDockBar::Splitter::cy = 4;

const int SECDockBar::ClientEdge::cx = 2;
const int SECDockBar::ClientEdge::cy = 2;

BEGIN_MESSAGE_MAP(SECDockBar, CDockBar)
	ON_WM_CREATE()
	ON_WM_SETCURSOR()
	ON_WM_MOUSEMOVE()
	ON_WM_LBUTTONDOWN()
	ON_WM_DESTROY()
	ON_MESSAGE(WM_SIZEPARENT, &SECDockBar::OnSizeParent)
END_MESSAGE_MAP()


SECDockBar::SECDockBar(BOOL bFloating, BOOL bMDIChild) :
	CDockBar(bFloating)
{
	m_bMDIChild = bMDIChild;

	m_pLayout = NULL;
	m_pBarDocked = NULL;
	m_bProcessingDelayedInvalidates = FALSE;
	m_bOptimizeNextRedraw = FALSE;

	// UNGEPRUEFT: der Anfangswert des Originals. Er ist die untere Schranke
	// fuer den Anteil einer Leiste an ihrer Zeile; DockBar.cpp:72 vergleicht
	// dagegen. Ohne prozentuale Breiten wird er nie fortgeschrieben.
	m_fAdjustedMinPctWidth = (float)0.0;
}


SECDockBar::~SECDockBar()
{
	DeleteAllSplitters();
	DeleteAllEdges();
	m_arrInvalidBars.RemoveAll();
}


#ifdef _DEBUG
void SECDockBar::AssertValid() const
	{ CDockBar::AssertValid(); }
void SECDockBar::Dump(CDumpContext& dc) const
	{ CDockBar::Dump(dc); }
#endif


/////////////////////////////////////////////////////////////////////////////
// SECDockBar - Zeilen
//
// AUFBAU VON m_arrBars (CDockBar, afxpriv.h:627): ein Feld aus Zeigern auf
// CControlBar, in dem NULL das Ende einer Zeile markiert. Eintraege mit einem
// Wert <= 0xffff sind Platzhalter fuer noch nicht erzeugte Leisten;
// GetDockedControlBar liefert dafuer NULL (bardock.cpp). Eudora wertet den
// Aufbau selbst genauso aus (DockBar.cpp:117-138, 237-258).

// DockBar.cpp:59 und :92 rufen das in einem VERIFY auf - die Fassung MUSS
// also TRUE liefern, wenn pBar zu dieser Andockleiste gehoert.
BOOL SECDockBar::GetControlBarRow(CPtrList& rowList, SECControlBar* pBar)
{
	rowList.RemoveAll();

	if (pBar == NULL)
		return FALSE;

	int nSize = (int) m_arrBars.GetSize();
	int nFound = -1;
	int i;

	for (i = 0; i < nSize; i++)
	{
		if (m_arrBars[i] == (void*) pBar)
		{
			nFound = i;
			break;
		}
	}

	if (nFound < 0)
		return FALSE;

	// Zeilenanfang suchen: rueckwaerts bis vor die naechste NULL-Marke.
	int nStart = nFound;
	while (nStart > 0 && m_arrBars[nStart - 1] != NULL)
		nStart--;

	// Vorwaerts bis zur naechsten NULL-Marke einsammeln.
	for (i = nStart; i < nSize && m_arrBars[i] != NULL; i++)
	{
		CControlBar* pRowBar = GetDockedControlBar(i);
		if (pRowBar != NULL)
			rowList.AddTail(pRowBar);
	}

	return TRUE;
}


// DockBar.cpp:86 ruft diese Fassung auf, wenn Eudora nicht im Werbemodus
// laeuft. "Allein in der Zeile" heisst: keine andere sichtbare Leiste.
BOOL SECDockBar::IsOnlyControlBarInRow(SECControlBar* pBar)
{
	CPtrList rowList;
	if (!GetControlBarRow(rowList, pBar))
		return FALSE;

	POSITION pos = rowList.GetHeadPosition();
	while (pos != NULL)
	{
		CControlBar* pOther = (CControlBar*) rowList.GetNext(pos);
		if (pOther != (CControlBar*) pBar && pOther->IsVisible())
			return FALSE;
	}

	return TRUE;
}


// DockBar.cpp:75. Im Original: hat die Leiste den groesstmoeglichen Anteil an
// ihrer Zeile?
//
// STUFE 2 OFFEN. Ohne prozentuale Zeilenbreiten gibt es kein Maximum, das
// unter 100 Prozent laege. Die einzige Lage, in der eine Leiste hier
// zweifelsfrei "am Anschlag" ist, ist die, in der sie ihre Zeile allein hat -
// also genau IsOnlyControlBarInRow.
BOOL SECDockBar::IsControlBarAtMaxWidthInRow(SECControlBar* pBar)
{
	return IsOnlyControlBarInRow(pBar);
}


// STUFE 2 OFFEN: die prozentualen Zeilenbreiten. Die einzige Aufrufstelle
// waere SECDockBar selbst.
void SECDockBar::SetControlBarWidthsInRow(SECControlBar* /*pBar*/, USHORT /*uOperationType*/)
{
}


// DockBar.cpp:225 ruft diese Fassung auf und rechnet danach die Breite der
// Werbeleiste heraus.
//
// Im Original verteilt NormalizeRow die Zeilenbreite anhand von m_fPctWidth
// auf die Leisten einer Zeile. Genau darauf setzt QCDockBar::NormalizeRow auf:
// es ruft diese Fassung zuerst und rechnet DANACH die Breite der Werbeleiste
// aus den bereits normierten Anteilen heraus (DockBar.cpp:225-296). Diese
// Fassung normiert deshalb die Summe der Anteile einer Zeile auf 1.0;
// angewandt werden sie in SECDockBar::AssignRowExtents.
//
// Nicht normiert wird, wenn die Summe schon nahe 1.0 liegt - sonst wanderten
// die Werte bei jedem Durchlauf durch die Rundung.
void SECDockBar::NormalizeRow(int nPos, CControlBar* /*pBarDocked*/,
	int& nBarsBidirectional, int& nBarsUnidirectional)
{
	nBarsBidirectional = 0;
	nBarsUnidirectional = 0;

	int nSize = (int) m_arrBars.GetSize();
	if (nPos < 0 || nPos >= nSize)
		return;

	int nStart = nPos;
	while (nStart > 0 && m_arrBars[nStart - 1] != NULL)
		nStart--;

	CPtrArray arrRow;
	float fSum = (float)0.0;
	int i;

	for (i = nStart; i < nSize && m_arrBars[i] != NULL; i++)
	{
		SECControlBar* pBar = DYNAMIC_DOWNCAST(SECControlBar, GetDockedControlBar(i));
		if (pBar == NULL)
			continue;

		// CBRS_EX_UNIDIRECTIONAL: die Leiste laesst sich nur in einer
		// Richtung groesser ziehen (sbarcore.h:54).
		if (pBar->GetExBarStyle() & CBRS_EX_UNIDIRECTIONAL)
			nBarsUnidirectional++;
		else
			nBarsBidirectional++;

		arrRow.Add(pBar);
		if (pBar->m_fPctWidth > (float)0.0)
			fSum += pBar->m_fPctWidth;
	}

	int nBars = (int) arrRow.GetSize();
	if (nBars <= 0)
		return;

	if (fSum > (float)0.0 &&
		(fSum < (float)0.999 || fSum > (float)1.001))
	{
		for (i = 0; i < nBars; i++)
		{
			SECControlBar* pBar = (SECControlBar*) arrRow[i];
			if (pBar->m_fPctWidth > (float)0.0)
				pBar->m_fPctWidth /= fSum;
			else
				pBar->m_fPctWidth = (float)0.0;
		}
	}
	else if (fSum <= (float)0.0)
	{
		// Keine brauchbaren Anteile - gleichmaessig aufteilen.
		for (i = 0; i < nBars; i++)
			((SECControlBar*) arrRow[i])->m_fPctWidth = (float)1.0 / nBars;
	}
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar - Abfragen

// workbook.cpp:373, 459, 563, 619. Der Rueckgabewert wird dort auf CWazooBar
// heruntergecastet und darf NULL sein.
SECControlBar* SECDockBar::GetFirstControlBar()
{
	for (int i = 0; i < m_arrBars.GetSize(); i++)
	{
		SECControlBar* pBar = DYNAMIC_DOWNCAST(SECControlBar, GetDockedControlBar(i));
		if (pBar != NULL)
			return pBar;
	}

	return NULL;
}


// Zugabe des Shims (siehe OTShim.h). SECMDIFrameWnd braucht die erste Leiste
// unabhaengig von ihrem Typ, um die MFC-Fassungen von OnNcLButtonDown und
// OnNcLButtonDblClk nachzubilden (bardock.cpp:886-889).
CControlBar* SECDockBar::GetFirstDockedBar() const
{
	for (int i = 0; i < m_arrBars.GetSize(); i++)
	{
		CControlBar* pBar = GetDockedControlBar(i);
		if (pBar != NULL)
			return pBar;
	}

	return NULL;
}


BOOL SECDockBar::IsNewBar(CControlBar* pBarToTest) const
{
	if (pBarToTest == NULL)
		return FALSE;

	for (int i = 0; i < m_arrBars.GetSize(); i++)
	{
		if (m_arrBars[i] == (void*) pBarToTest)
			return FALSE;
	}

	return TRUE;
}


// UNGEPRUEFT: die genaue Bedeutung im Original. Gelesen als "steht
// pBarToTest noch nicht in der Zeile, die bei nCurrentRow beginnt". Von
// Eudora nicht aufgerufen.
BOOL SECDockBar::BarIsNewToThisRow(CControlBar* pBarToTest, int nCurrentRow) const
{
	if (pBarToTest == NULL)
		return FALSE;

	int nSize = (int) m_arrBars.GetSize();
	if (nCurrentRow < 0 || nCurrentRow >= nSize)
		return TRUE;

	int nStart = nCurrentRow;
	while (nStart > 0 && m_arrBars[nStart - 1] != NULL)
		nStart--;

	for (int i = nStart; i < nSize && m_arrBars[i] != NULL; i++)
	{
		if (m_arrBars[i] == (void*) pBarToTest)
			return FALSE;
	}

	return TRUE;
}


// Hoehe der Zeile, in der nPos liegt: das Maximum der Leistenhoehen.
int SECDockBar::GetRowHeight(int nPos) const
{
	int nSize = (int) m_arrBars.GetSize();
	if (nPos < 0 || nPos >= nSize)
		return 0;

	int nStart = nPos;
	while (nStart > 0 && m_arrBars[nStart - 1] != NULL)
		nStart--;

	BOOL bHorz = (m_dwStyle & CBRS_ORIENT_HORZ) ? TRUE : FALSE;
	int nHeight = 0;

	for (int i = nStart; i < nSize && m_arrBars[i] != NULL; i++)
	{
		CControlBar* pBar = GetDockedControlBar(i);
		if (pBar == NULL || !pBar->IsVisible())
			continue;

		CRect rect;
		pBar->GetWindowRect(&rect);
		int n = bHorz ? rect.Height() : rect.Width();
		if (n > nHeight)
			nHeight = n;
	}

	return nHeight;
}


// Die vier laufen innerhalb einer Zeile weiter bzw. zurueck. Von Eudora nicht
// aufgerufen; im Original Hilfsmittel der Splitterberechnung.
CControlBar* SECDockBar::NextBarThisRow(int nPos)
{
	int nSize = (int) m_arrBars.GetSize();
	for (int i = nPos + 1; i < nSize && m_arrBars[i] != NULL; i++)
	{
		CControlBar* pBar = GetDockedControlBar(i);
		if (pBar != NULL)
			return pBar;
	}
	return NULL;
}

CControlBar* SECDockBar::NextVisibleBarThisRow(int nPos)
{
	int nSize = (int) m_arrBars.GetSize();
	for (int i = nPos + 1; i < nSize && m_arrBars[i] != NULL; i++)
	{
		CControlBar* pBar = GetDockedControlBar(i);
		if (pBar != NULL && pBar->IsVisible())
			return pBar;
	}
	return NULL;
}

CControlBar* SECDockBar::PrevBarThisRow(int nPos)
{
	for (int i = nPos - 1; i >= 0 && m_arrBars[i] != NULL; i--)
	{
		CControlBar* pBar = GetDockedControlBar(i);
		if (pBar != NULL)
			return pBar;
	}
	return NULL;
}

CControlBar* SECDockBar::PrevVisibleBarThisRow(int nPos)
{
	for (int i = nPos - 1; i >= 0 && m_arrBars[i] != NULL; i--)
	{
		CControlBar* pBar = GetDockedControlBar(i);
		if (pBar != NULL && pBar->IsVisible())
			return pBar;
	}
	return NULL;
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar - Zustand sichern und zuruecklesen
//
// Verdecken CDockBar::Get/SetBarInfo (afxpriv.h:622-623). Eine Andockleiste
// hat keine SEC-eigenen Angaben; die Zusatzfelder von SECControlBarInfo
// gehoeren der einzelnen Leiste. Deshalb reines Durchreichen - der Aufruf
// darf nur nicht bei CControlBarInfo* haengenbleiben.

void SECDockBar::GetBarInfo(SECControlBarInfo* pInfo)
{
	CDockBar::GetBarInfo(pInfo);
}

void SECDockBar::SetBarInfo(SECControlBarInfo* pInfo, CFrameWnd* pFrameWnd)
{
	CDockBar::SetBarInfo(pInfo, pFrameWnd);
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar - Andocken
//
// Alles Kategorie A: CDockBar kann andocken, umdocken und entfernen. Was der
// Shim nicht kann, ist die spaltengenaue Einordnung.

void SECDockBar::DockControlBar(CControlBar* pBar, LPCRECT lpRect)
{
	NormalizeBarArray();				// E-4
	CDockBar::DockControlBar(pBar, lpRect);
}


// STUFE 2 OFFEN: nCol und nRow. Der Weg dorthin ist
// SECMDIFrameWnd::DockControlBarEx; dort steht die ausfuehrliche Begruendung.
// CDockBar ordnet die Leiste anhand ihres Fensterrechtecks ein.
void SECDockBar::DockControlBar(CControlBar* pBar, int /*nCol*/, int /*nRow*/)
{
	CDockBar::DockControlBar(pBar, NULL);
}


void SECDockBar::ReDockControlBar(CControlBar* pBar, LPCRECT lpRect)
{
	CDockBar::ReDockControlBar(pBar, lpRect);
}


// Das Original unterscheidet nach _MFC_VER (sbardock.h:215-219); MFC 14 liegt
// weit ueber 0x0420, es gilt also die dreistellige Fassung. MFC nimmt den
// dritten Wert als int entgegen (afxpriv.h:608).
BOOL SECDockBar::RemoveControlBar(CControlBar* pBar, int nPosExclude, BOOL bAddPlaceHolder)
{
	if (pBar == NULL)
		return FALSE;

	// BEFUND E-4. CDockBar::RemoveControlBar (bardock.cpp:302-334) setzt
	// zweierlei voraus:
	//
	//   1. Die Leiste steht an einer Stelle GROESSER 0 in m_arrBars. Sonst
	//      wirft ENSURE(nPos > 0) eine CInvalidArgException - im Release-Bau
	//      das Meldungsfenster "Encountered an improper argument".
	//   2. Hinter der entfernten Stelle steht noch ein Eintrag: MFC liest
	//      m_arrBars[nPos] UNMITTELBAR NACH m_arrBars.RemoveAt(nPos)
	//      (bardock.cpp:321-322 und :328-329, ebenso RemovePlaceHolder
	//      bardock.cpp:297). Das geht nur gut, solange das Feld mit einer
	//      NULL-Marke endet - sonst greift CPtrArray::ElementAt daneben
	//      (Zusicherung afxcoll.inl:213 im Debug-Bau, dieselbe Ausnahme im
	//      Release-Bau).
	//
	// Beides wird hier hergestellt bzw. geprueft, bevor MFC uebernimmt.
	NormalizeBarArray();

	if (FindBar(pBar, nPosExclude) <= 0)
		return FALSE;

	return CDockBar::RemoveControlBar(pBar, nPosExclude, bAddPlaceHolder ? 1 : 0);
}


// STUFE 2 OFFEN: Spalte und Zeile. Siehe DockControlBar oben.
int SECDockBar::Insert(CControlBar* pBarIns, int /*nInsCol*/, int /*nInsRow*/)
{
	CRect rect(0, 0, 0, 0);
	if (pBarIns != NULL && pBarIns->GetSafeHwnd() != NULL)
		pBarIns->GetWindowRect(&rect);

	return CDockBar::Insert(pBarIns, rect, rect.CenterPoint());
}


int SECDockBar::Insert(CControlBar* pBar, CRect rect, CPoint ptMid)
{
	return CDockBar::Insert(pBar, rect, ptMid);
}


// STUFE 2 OFFEN. Im Original sagt die Fassung vorher, an welche Stelle eine
// gezogene Leiste fallen wuerde, um den Ziehrahmen dort einzublenden. Ohne
// eigene Ziehlogik gibt es niemanden, der danach fragt. -1 heisst "unbekannt".
int SECDockBar::PredictInsertPosition(CControlBar* /*pBarIns*/, CRect /*rect*/, CPoint /*ptMid*/)
{
	return -1;
}


// NICHT im Original in dieser Form, aber die Stelle, an der das Original die
// prozentualen Zeilenbreiten anwendet.
//
// WARUM HIER: CDockBar::OnSizeParent reicht die Arbeit an
// CControlBar::OnSizeParent weiter, und die ruft CalcFixedLayout auf. Die
// eigentliche Anordnung der Leisten steckt in CDockBar::CalcFixedLayout
// (bardock.cpp:360-545); die fragt jede Leiste ueber CalcDynamicLayout nach
// ihrer Wunschgroesse. SECControlBar::CalcFixedLayout lieferte dort in
// Zeilenrichtung 32767. Folge: die erste Leiste einer Zeile belegte die ganze
// Zeile, und fuer jede weitere schob bardock.cpp:441-447 eine NULL-Marke in
// m_arrBars - jede Leiste bekam eine eigene Zeile. Genau das ergab die
// uebereinanderliegenden Bereiche.
//
// AssignRowExtents setzt vorher je Leiste eine echte Laenge; danach wird die
// Zuteilung wieder zurueckgenommen, damit ein CalcFixedLayout ausserhalb des
// Anordnungsdurchlaufs (etwa aus CAdWazooBar, AdWazooBar.cpp:239) dieselbe
// Antwort bekommt wie bisher.
CSize SECDockBar::CalcFixedLayout(BOOL bStretch, BOOL bHorz)
{
	// E-4: CDockBar::CalcFixedLayout schiebt selbst NULL-Marken in m_arrBars
	// (bardock.cpp:445 und :488). Weil diese Fassung bei JEDEM
	// Anordnungsdurchlauf laeuft, ist sie die Stelle, an der der Aufbau
	// laufend geradegezogen wird - auch fuer die Entfernwege, die MFC
	// unmittelbar auf CDockBar aufruft und die diese Schicht nicht sieht.
	NormalizeBarArray();

	AssignRowExtents(bHorz);
	CSize size = CDockBar::CalcFixedLayout(bStretch, bHorz);
	ClearRowExtents();
	return size;
}


void SECDockBar::ClearRowExtents()
{
	for (int i = 0; i < m_arrBars.GetSize(); i++)
	{
		SECControlBar* pBar = DYNAMIC_DOWNCAST(SECControlBar, GetDockedControlBar(i));
		if (pBar != NULL)
			pBar->m_nRowExtent = 0;
	}
}


void SECDockBar::AssignRowExtents(BOOL bHorz)
{
	ClearRowExtents();

	// Eine schwebende Andockleiste hat genau eine Leiste und keine Zeile, die
	// sich aufteilen liesse.
	if (m_bFloating)
		return;

	// Die verfuegbare Laenge wird genau so ermittelt wie in
	// CDockBar::CalcFixedLayout (bardock.cpp:366-380), damit beide Rechnungen
	// von derselben Zahl ausgehen.
	CSize sizeMax;
	if (!m_rectLayout.IsRectEmpty())
	{
		CRect rect = m_rectLayout;
		CalcInsideRect(rect, bHorz);
		sizeMax = rect.Size();
	}
	else
	{
		CFrameWnd* pFrame = GetDockingFrame();
		if (pFrame == NULL || pFrame->GetSafeHwnd() == NULL)
			return;

		CRect rectFrame;
		pFrame->GetClientRect(&rectFrame);
		sizeMax = rectFrame.Size();
	}

	int nAvail = bHorz ? sizeMax.cx : sizeMax.cy;
	if (nAvail <= 0)
		return;

	// AUFBAU VON m_arrBars: NULL beendet eine Zeile. Die fuehrende NULL aus
	// dem Konstruktor (bardock.cpp:36) beendet eine leere Zeile vor Zeile 0.
	int nSize = (int) m_arrBars.GetSize();
	int nStart = 0;

	while (nStart < nSize)
	{
		int nEnd = nStart;
		while (nEnd < nSize && m_arrBars[nEnd] != NULL)
			nEnd++;

		DistributeRow(nStart, nEnd, nAvail);

		nStart = nEnd + 1;
	}
}


// Verteilt nAvail auf die sichtbaren SECControlBars zwischen nStart
// (einschliesslich) und nEnd (ausschliesslich).
void SECDockBar::DistributeRow(int nStart, int nEnd, int nAvail)
{
	CPtrArray arrRow;
	float fSum = (float)0.0;
	int i;

	for (i = nStart; i < nEnd; i++)
	{
		SECControlBar* pBar = DYNAMIC_DOWNCAST(SECControlBar, GetDockedControlBar(i));
		if (pBar == NULL || !pBar->IsVisible())
			continue;

		arrRow.Add(pBar);
		if (pBar->m_fPctWidth > (float)0.0)
			fSum += pBar->m_fPctWidth;
	}

	int nBars = (int) arrRow.GetSize();
	if (nBars <= 0)
		return;

	// Untere Schranke je Leiste, damit keine ganz verschwindet. Der Wert ist
	// die uebliche Breite eines Ziehbalkens mal vier - UNGEPRUEFT, das
	// Original nennt keinen.
	// Ist die Zeile dafuer zu kurz, wird die Schranke fallengelassen; das
	// prueft nBoundsFit.
	const int nMin = 4 * Splitter::cx;
	const BOOL nBoundsFit = (nAvail >= nBars * nMin);

	int nRest = nAvail;
	for (i = 0; i < nBars; i++)
	{
		SECControlBar* pBar = (SECControlBar*) arrRow[i];
		int nExtent;

		if (i == nBars - 1)
		{
			// Der Rest, damit sich Rundungsfehler nicht aufsummieren.
			nExtent = nRest;
		}
		else
		{
			float fPct = (fSum > (float)0.0 && pBar->m_fPctWidth > (float)0.0)
						 ? (pBar->m_fPctWidth / fSum)
						 : ((float)1.0 / nBars);
			nExtent = (int)(nAvail * fPct + (float)0.5);

			// Genug fuer die noch folgenden Leisten uebriglassen.
			int nReserve = (nBars - 1 - i) * nMin;
			if (nBoundsFit && nExtent > nRest - nReserve)
				nExtent = nRest - nReserve;
			if (nBoundsFit && nExtent < nMin)
				nExtent = nMin;
		}

		if (nExtent < 1)
			nExtent = 1;

		pBar->m_nRowExtent = nExtent;
		nRest -= nExtent;
		if (nRest < 0)
			nRest = 0;
	}
}


// NICHT im Original. BEFUND E-4: Eudora stuerzte beim Beenden ab.
//
// CDockBar sichert zwei Eigenschaften von m_arrBars zu und prueft sie in
// CDockBar::AssertValid (bardock.cpp:746-748):
//
//     m_arrBars[0]                  == NULL   fuehrende Marke
//     m_arrBars[GetUpperBound()]    == NULL   abschliessende Marke
//
// Die Abbauwege beim Beenden verlassen sich darauf, ohne es zu pruefen:
// CDockBar::RemoveControlBar und CDockBar::RemovePlaceHolder lesen
// m_arrBars[nPos] unmittelbar NACH m_arrBars.RemoveAt(nPos) (bardock.cpp:297,
// :321-322, :328-329). Fehlt die abschliessende Marke, ist dieser Index um
// eins zu gross: im Debug-Bau die Zusicherung in CPtrArray::ElementAt
// (afxcoll.inl:213), im Release-Bau AfxThrowInvalidArgException, also das
// Meldungsfenster "Encountered an improper argument".
//
// MoveControlBarToPosition ist die einzige Stelle im ganzen Bau, die
// m_arrBars von Hand umbaut. Diese Fassung zieht den Aufbau danach wieder
// gerade, statt sich darauf zu verlassen, dass jeder Zweig ihn von selbst
// einhaelt. Leere Zeilen - zwei NULL-Marken hintereinander - fallen dabei
// ebenfalls weg; MFC erzeugt sie nie, und CDockBar::Insert (bardock.cpp:695-734)
// rechnet nicht mit ihnen.
void SECDockBar::NormalizeBarArray()
{
	// 1. fuehrende Marke
	if (m_arrBars.GetSize() == 0)
	{
		m_arrBars.Add(NULL);
		return;
	}

	if (m_arrBars[0] != NULL)
		m_arrBars.InsertAt(0, (void*) NULL);

	// 2. keine zwei Marken hintereinander (leere Zeile)
	for (int i = (int) m_arrBars.GetSize() - 1; i > 0; i--)
	{
		if (m_arrBars[i] == NULL && m_arrBars[i - 1] == NULL)
			m_arrBars.RemoveAt(i);
	}

	// 3. abschliessende Marke
	int nSize = (int) m_arrBars.GetSize();
	if (m_arrBars[nSize - 1] != NULL)
		m_arrBars.Add(NULL);
}


// NICHT im Original. Schiebt den Eintrag von pBar in m_arrBars an die Stelle,
// die SECMDIFrameWnd::DockControlBarEx verlangt. Begruendung siehe OTShim.h.
void SECDockBar::MoveControlBarToPosition(CControlBar* pBar, int nCol, int nRow)
{
	if (pBar == NULL || nCol < 0 || nRow < 0)
		return;

	// E-4: erst den Aufbau geradeziehen, dann darin rechnen. Sonst haengt
	// die Zeilenzaehlung weiter unten davon ab, ob ein anderer Weg eine
	// leere Zeile oder eine fehlende Marke hinterlassen hat.
	NormalizeBarArray();

	int nSize = (int) m_arrBars.GetSize();
	int nOld = -1;
	int i;

	for (i = 0; i < nSize; i++)
	{
		if (m_arrBars[i] == (void*) pBar)
		{
			nOld = i;
			break;
		}
	}

	if (nOld < 0)
		return;

	// Eintrag herausnehmen. Wird die Zeile dadurch leer, faellt auch ihre
	// Endemarke weg - sonst blieben leere Zeilen stehen.
	BOOL bRowBecomesEmpty = (nOld == 0 || m_arrBars[nOld - 1] == NULL) &&
							(nOld + 1 >= nSize || m_arrBars[nOld + 1] == NULL);

	m_arrBars.RemoveAt(nOld);
	if (bRowBecomesEmpty && nOld < m_arrBars.GetSize() &&
		m_arrBars[nOld] == NULL)
	{
		m_arrBars.RemoveAt(nOld);
	}

	// Anfang der Zielzeile suchen: Zeile nRow beginnt hinter der
	// (nRow+1)-ten NULL-Marke.
	nSize = (int) m_arrBars.GetSize();
	int nNullsToSkip = nRow + 1;
	int nSeen = 0;
	int nRowStart = -1;

	for (i = 0; i < nSize; i++)
	{
		if (m_arrBars[i] == NULL)
		{
			nSeen++;
			if (nSeen == nNullsToSkip)
			{
				nRowStart = i + 1;
				break;
			}
		}
	}

	if (nRowStart < 0)
	{
		// So viele Zeilen gibt es nicht - dann bleibt es bei einer eigenen
		// Zeile am Ende, also genau beim bisherigen Verhalten.
		m_arrBars.Add(pBar);
		m_arrBars.Add(NULL);
		NormalizeBarArray();				// E-4
		return;
	}

	int nRowEnd = nRowStart;
	while (nRowEnd < nSize && m_arrBars[nRowEnd] != NULL)
		nRowEnd++;

	int nIns = nRowStart + nCol;
	if (nIns > nRowEnd)
		nIns = nRowEnd;

	m_arrBars.InsertAt(nIns, (void*) pBar);

	// m_arrBars muss mit einer NULL-Marke anfangen UND enden, sonst greifen
	// die Abbauwege beim Beenden daneben (E-4).
	NormalizeBarArray();
}


// STUFE 2 OFFEN, wie PredictInsertPosition: das ist der Rahmen, den das
// Original waehrend des Ziehens zeichnet. MFC macht das in CDockContext.
CRect SECDockBar::CalcDockingLayout(CControlBar* /*pBarToDock*/, CRect& rectBar,
	CPoint /*pt*/, int& nPosDockingRow, CRect& /*prevFocusRect*/, CPoint& /*prevPt*/)
{
	nPosDockingRow = -1;
	return rectBar;
}


// STUFE 2 OFFEN: die Zeilenhoehe ergibt sich hier aus CalcFixedLayout der
// einzelnen Leisten, nicht aus einem gespeicherten Wert. Von Eudora nicht
// aufgerufen.
void SECDockBar::SetRowHeight(int /*nPos*/, int /*nRowHeight*/)
{
}

void SECDockBar::AdjustRowHeight(int /*nPos*/, int /*nWidth*/)
{
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar - Neuzeichnen
//
// Im Original sammelt die Andockleiste Neuzeichnen-Wuensche in
// m_arrInvalidBars und arbeitet sie erst am Ende eines Ziehvorgangs ab
// (m_bOptimizedRedrawEnabled, mainfrm.cpp:1019 schaltet das ab). Ohne eigene
// Ziehlogik gibt es nichts zu sammeln: hier wird sofort fuer ungueltig
// erklaert. Das Feld bleibt und wird leer gehalten.

void SECDockBar::InvalidateBar(CControlBar* pBar)
{
	if (pBar == NULL || pBar->GetSafeHwnd() == NULL)
		return;

	pBar->Invalidate();
}


void SECDockBar::InvalidateBar(int nPos)
{
	if (nPos < 0 || nPos >= m_arrBars.GetSize())
		return;

	InvalidateBar(GetDockedControlBar(nPos));
}


// Alle Leisten der Zeile, in der nPosRow liegt.
void SECDockBar::InvalidateToRow(int nPosRow)
{
	int nSize = (int) m_arrBars.GetSize();
	if (nPosRow < 0 || nPosRow >= nSize)
		return;

	int nStart = nPosRow;
	while (nStart > 0 && m_arrBars[nStart - 1] != NULL)
		nStart--;

	for (int i = nStart; i < nSize && m_arrBars[i] != NULL; i++)
		InvalidateBar(i);
}


// Aufgerufen, wenn eine Leiste ein- oder ausgeblendet wurde. Die uebrigen
// Leisten der Zeile muessen dann neu gezeichnet werden, weil sie den frei
// gewordenen Platz uebernehmen.
void SECDockBar::OnBarHideShow(CControlBar* pBar)
{
	if (pBar == NULL)
		return;

	for (int i = 0; i < m_arrBars.GetSize(); i++)
	{
		if (m_arrBars[i] == (void*) pBar)
		{
			InvalidateToRow(i);
			return;
		}
	}
}


void SECDockBar::ProcessDelayedInvalidates()
{
	if (m_bProcessingDelayedInvalidates)
		return;

	m_bProcessingDelayedInvalidates = TRUE;

	for (int i = 0; i < m_arrInvalidBars.GetSize(); i++)
		InvalidateBar((CControlBar*) m_arrInvalidBars[i]);

	m_arrInvalidBars.RemoveAll();
	m_bProcessingDelayedInvalidates = FALSE;
}


// STUFE 2 OFFEN. Im Original zeichnet die Fassung die Werkzeugleisten einer
// Zeile neu, wenn sich deren Breite geaendert hat. Hier ist es dasselbe wie
// InvalidateToRow.
void SECDockBar::InvalidateCustomToolBarsInRow(SECControlBar* pBar)
{
	OnBarHideShow(pBar);
}


void SECDockBar::DoPaint(CDC* pDC)
{
	CDockBar::DoPaint(pDC);

	// Beide Felder bleiben in dieser Stufe leer - AddSplitter und
	// AddClientEdge werden nie aufgerufen. Die Schleifen stehen trotzdem hier,
	// damit ein spaeterer Nachbau nur die beiden Erzeuger fuellen muss.
	int i;
	for (i = 0; i < m_arrEdges.GetSize(); i++)
	{
		ClientEdge* pEdge = (ClientEdge*) m_arrEdges[i];
		if (pEdge != NULL && pEdge->m_bInUse)
			pEdge->Draw(pDC);
	}

	for (i = 0; i < m_arrSplitters.GetSize(); i++)
	{
		Splitter* pSplitter = (Splitter*) m_arrSplitters[i];
		if (pSplitter != NULL && pSplitter->m_bInUse)
			pSplitter->Draw(pDC);
	}
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar - Splitter und Innenkanten
//
// Die Verwaltung ist vollstaendig umgesetzt, weil sie billig ist und die
// Klasse sonst in sich unstimmig waere. Was fehlt, ist der Erzeuger: nichts im
// Shim ruft AddSplitter oder AddClientEdge auf, weil die prozentualen
// Zeilenbreiten fehlen, aus denen sich die Lage der Trennstriche ergaebe.
// m_arrSplitters und m_arrEdges bleiben daher leer, HitTest liefert NULL, und
// QCDockBar::CalcTrackingLimits (DockBar.cpp:149) wird nie erreicht.

void SECDockBar::AddSplitter(Splitter::Type type, Splitter::Orientation orientation,
	int x1, int y1, int x2, int y2, int nPos)
{
	CRect rect(x1, y1, x2, y2);

	// Wiederverwenden statt neu anlegen - dafuer sind BeginRecycleSplitters
	// und m_bInUse da.
	for (int i = 0; i < m_arrSplitters.GetSize(); i++)
	{
		Splitter* pOld = (Splitter*) m_arrSplitters[i];
		if (pOld == NULL || pOld->m_bInUse)
			continue;

		pOld->m_type        = type;
		pOld->m_orientation = orientation;
		pOld->m_rect        = rect;
		pOld->m_nPos        = nPos;
		pOld->m_bInUse      = TRUE;
		return;
	}

	Splitter* pNew = new Splitter(type, orientation, rect);
	pNew->m_nPos   = nPos;
	pNew->m_bInUse = TRUE;
	m_arrSplitters.Add(pNew);
}


void SECDockBar::DeleteAllSplitters()
{
	for (int i = 0; i < m_arrSplitters.GetSize(); i++)
		delete (Splitter*) m_arrSplitters[i];

	m_arrSplitters.RemoveAll();
}


void SECDockBar::BeginRecycleSplitters()
{
	for (int i = 0; i < m_arrSplitters.GetSize(); i++)
	{
		Splitter* pSplitter = (Splitter*) m_arrSplitters[i];
		if (pSplitter != NULL)
			pSplitter->m_bInUse = FALSE;
	}
}


void SECDockBar::EndRecycleSplitters()
{
	// Rueckwaerts, damit das Entfernen die noch offenen Plaetze nicht
	// verschiebt.
	for (int i = (int) m_arrSplitters.GetSize() - 1; i >= 0; i--)
	{
		Splitter* pSplitter = (Splitter*) m_arrSplitters[i];
		if (pSplitter != NULL && pSplitter->m_bInUse)
			continue;

		delete pSplitter;
		m_arrSplitters.RemoveAt(i);
	}
}


void SECDockBar::AddClientEdge(ClientEdge::Orientation orientation,
	int x1, int y1, int x2, int y2)
{
	CRect rect(x1, y1, x2, y2);

	for (int i = 0; i < m_arrEdges.GetSize(); i++)
	{
		ClientEdge* pOld = (ClientEdge*) m_arrEdges[i];
		if (pOld == NULL || pOld->m_bInUse)
			continue;

		pOld->m_orientation = orientation;
		pOld->m_rect        = rect;
		pOld->m_bInUse      = TRUE;
		return;
	}

	ClientEdge* pNew = new ClientEdge(orientation, rect);
	pNew->m_bInUse = TRUE;
	m_arrEdges.Add(pNew);
}


void SECDockBar::DeleteAllEdges()
{
	for (int i = 0; i < m_arrEdges.GetSize(); i++)
		delete (ClientEdge*) m_arrEdges[i];

	m_arrEdges.RemoveAll();
}


void SECDockBar::BeginRecycleEdges()
{
	for (int i = 0; i < m_arrEdges.GetSize(); i++)
	{
		ClientEdge* pEdge = (ClientEdge*) m_arrEdges[i];
		if (pEdge != NULL)
			pEdge->m_bInUse = FALSE;
	}
}


void SECDockBar::EndRecycleEdges()
{
	for (int i = (int) m_arrEdges.GetSize() - 1; i >= 0; i--)
	{
		ClientEdge* pEdge = (ClientEdge*) m_arrEdges[i];
		if (pEdge != NULL && pEdge->m_bInUse)
			continue;

		delete pEdge;
		m_arrEdges.RemoveAt(i);
	}
}


SECDockBar::Splitter* SECDockBar::HitTest(CPoint pt)
{
	for (int i = 0; i < m_arrSplitters.GetSize(); i++)
	{
		Splitter* pSplitter = (Splitter*) m_arrSplitters[i];
		if (pSplitter != NULL && pSplitter->m_bInUse &&
			pSplitter->m_rect.PtInRect(pt))
		{
			return pSplitter;
		}
	}

	return NULL;
}


// DockBar.cpp:149 (QCDockBar) verfeinert die Grenzen anschliessend, damit die
// Werbeleiste nicht unter ihre Mindestgroesse gezogen wird. Diese Fassung
// liefert die aeussere Schranke: den Client-Bereich der Andockleiste.
void SECDockBar::CalcTrackingLimits(Splitter* pSplitter)
{
	if (pSplitter == NULL)
		return;

	CRect rect;
	GetClientRect(&rect);

	if (pSplitter->m_orientation == Splitter::Vertical)
	{
		pSplitter->m_nMin = rect.left;
		pSplitter->m_nMax = rect.right;
	}
	else
	{
		pSplitter->m_nMin = rect.top;
		pSplitter->m_nMax = rect.bottom;
	}
}


void SECDockBar::StartTracking(Splitter* pSplit, CPoint pt)
{
	if (pSplit == NULL)
		return;

	// Die virtuelle Fassung, damit QCDockBar seine Grenzen setzen kann.
	CalcTrackingLimits(pSplit);

	int nDelta = pSplit->Track(this, pt, this);
	if (nDelta != 0)
		OnSplitterMoved(pSplit, nDelta);
}


// STUFE 2 OFFEN: hier verteilte das Original die Zeilenbreite neu
// (m_fPctWidth der beiden angrenzenden Leisten). Ohne Splitter wird die
// Fassung nie erreicht.
void SECDockBar::OnSplitterMoved(Splitter* /*pSplitter*/, int /*nDelta*/)
{
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar::Splitter

SECDockBar::Splitter::Splitter(Type type, Orientation orientation, const RECT & rect)
{
	m_type        = type;
	m_orientation = orientation;
	m_rect        = rect;
	m_nPos        = -1;
	m_bInUse      = FALSE;
	m_nMin        = 0;
	m_nMax        = 0;

	m_rectLast.SetRectEmpty();
	m_sizeLast   = CSize(0, 0);
	m_bErase     = FALSE;
	m_bFinalErase = FALSE;
}


void SECDockBar::Splitter::Draw(CDC *pDC)
{
	if (pDC == NULL)
		return;

	// Ein Trennstrich sieht aus wie ein Stueck Leistenhintergrund. Erst wenn
	// er wirklich benutzt wird, lohnt sich mehr.
	pDC->FillSolidRect(m_rect, ::GetSysColor(COLOR_BTNFACE));
}


// Der invertierte Ziehrahmen. Zweimal auf dieselbe Stelle gezeichnet hebt er
// sich wieder auf - deshalb der Halbtonpinsel mit PATINVERT, genau wie
// CDockContext::DrawFocusRect es macht.
void SECDockBar::Splitter::DrawTrackerRect(LPCRECT lpRect,
	CWnd* pWndClipTo, CDC* pDC, CWnd* /*pWnd*/)
{
	if (lpRect == NULL || pDC == NULL)
		return;

	CRect rect(lpRect);
	if (pWndClipTo != NULL)
		pWndClipTo->ScreenToClient(&rect);

	CBrush* pBrush = CDC::GetHalftoneBrush();
	if (pBrush == NULL)
		return;

	HBRUSH hOldBrush = (HBRUSH) ::SelectObject(pDC->GetSafeHdc(), pBrush->GetSafeHandle());
	pDC->PatBlt(rect.left, rect.top, rect.Width(), rect.Height(), PATINVERT);
	if (hOldBrush != NULL)
		::SelectObject(pDC->GetSafeHdc(), hOldBrush);
}


// STUFE 2 OFFEN. Im Original laeuft hier die Mausschleife, bis der Anwender
// loslaesst, und der Rueckgabewert ist die zurueckgelegte Strecke.
// Aufgerufen wird die Fassung nur aus StartTracking, und dorthin fuehrt nur
// ein Treffer auf einen Splitter - den es in dieser Stufe nicht gibt.
// 0 heisst "nicht verschoben", der Aufrufer laesst dann alles, wie es ist.
int SECDockBar::Splitter::Track(CWnd* /*pWnd*/, CPoint /*point*/, CWnd* /*pWndClipTo*/)
{
	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar::ClientEdge

SECDockBar::ClientEdge::ClientEdge(Orientation orientation, const RECT & rect)
{
	m_orientation = orientation;
	m_rect        = rect;
	m_bInUse      = FALSE;
}


void SECDockBar::ClientEdge::Draw(CDC *pDC)
{
	if (pDC == NULL)
		return;

	// Vertiefte Kante wie am Rand eines Client-Bereichs.
	pDC->Draw3dRect(m_rect,
		::GetSysColor(COLOR_BTNSHADOW), ::GetSysColor(COLOR_BTNHIGHLIGHT));
}


/////////////////////////////////////////////////////////////////////////////
// SECDockBar - Nachrichten

int SECDockBar::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	return CDockBar::OnCreate(lpCreateStruct);
}


// Ueber einem Splitter der Doppelpfeil, sonst der uebliche Zeiger. Weil es
// keine Splitter gibt, faellt die Fassung immer durch.
BOOL SECDockBar::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if (m_arrSplitters.GetSize() > 0)
	{
		CPoint pt;
		if (::GetCursorPos(&pt))
		{
			ScreenToClient(&pt);
			Splitter* pSplitter = HitTest(pt);
			if (pSplitter != NULL)
			{
				LPCTSTR lpszCursor = (pSplitter->m_orientation == Splitter::Vertical)
					? IDC_SIZEWE : IDC_SIZENS;
				::SetCursor(::LoadCursor(NULL, lpszCursor));
				return TRUE;
			}
		}
	}

	return CDockBar::OnSetCursor(pWnd, nHitTest, message);
}


void SECDockBar::OnMouseMove(UINT nFlags, CPoint point)
{
	CDockBar::OnMouseMove(nFlags, point);
}


void SECDockBar::OnLButtonDown(UINT nFlags, CPoint point)
{
	Splitter* pSplitter = HitTest(point);
	if (pSplitter != NULL)
	{
		StartTracking(pSplitter, point);
		return;
	}

	CDockBar::OnLButtonDown(nFlags, point);
}


void SECDockBar::OnDestroy()
{
	DeleteAllSplitters();
	DeleteAllEdges();
	m_arrInvalidBars.RemoveAll();

	CDockBar::OnDestroy();
}


// WM_SIZEPARENT ist der Anordnungsdurchlauf des Rahmens (afxpriv.h). Hier
// wuerde das Original die prozentualen Breiten anwenden und danach die
// Splitter neu setzen. Kategorie A - CDockBar ordnet die Leisten selbst an.
LRESULT SECDockBar::OnSizeParent(WPARAM wParam, LPARAM lParam)
{
	return CDockBar::OnSizeParent(wParam, lParam);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
// SECMiniDockFrameWnd

IMPLEMENT_DYNCREATE(SECMiniDockFrameWnd, CMiniDockFrameWnd)

BEGIN_MESSAGE_MAP(SECMiniDockFrameWnd, CMiniDockFrameWnd)
	ON_WM_CLOSE()
	ON_WM_NCLBUTTONDOWN()
	ON_WM_NCLBUTTONDBLCLK()
	ON_WM_PARENTNOTIFY()
END_MESSAGE_MAP()


// m_wndSECDockBar schwebt (erstes Argument TRUE) und ist kein MDI-Kind.
// m_bAutoDelete aus: das Feld gehoert dem Rahmen, nicht dem Rahmenwerk -
// genauso haelt es CMiniDockFrameWnd mit m_wndDockBar (bardock.cpp:798-801).
SECMiniDockFrameWnd::SECMiniDockFrameWnd() :
	m_wndSECDockBar(TRUE, FALSE)
{
	m_wndSECDockBar.m_bAutoDelete = FALSE;
}


// Wortgetreue Nachbildung von CMiniDockFrameWnd::Create (bardock.cpp:803-856)
// mit einem einzigen Unterschied: erzeugt wird m_wndSECDockBar statt
// m_wndDockBar. Die Kennung bleibt AFX_IDW_DOCKBAR_FLOAT, denn danach sucht
// CFrameWnd::FloatControlBar (winfrm2.cpp:202).
BOOL SECMiniDockFrameWnd::Create(CWnd* pParent, DWORD dwBarStyle)
{
	// Verhindert Flackern waehrend der Erzeugung; RecalcLayout laeuft erst,
	// wenn etwas angedockt ist.
	m_bInRecalcLayout = TRUE;

	DWORD dwStyle = WS_POPUP | WS_CAPTION | WS_SYSMENU | MFS_MOVEFRAME |
		MFS_4THICKFRAME | MFS_SYNCACTIVE | MFS_BLOCKSYSMENU |
		FWS_SNAPTOBARS;

	if (dwBarStyle & CBRS_SIZE_DYNAMIC)
		dwStyle &= ~MFS_MOVEFRAME;

	if (!CMiniFrameWnd::CreateEx(0, NULL, _T(""), dwStyle,
			CFrameWnd::rectDefault, pParent))
	{
		m_bInRecalcLayout = FALSE;
		return FALSE;
	}

	dwStyle = (dwBarStyle & (CBRS_ALIGN_LEFT | CBRS_ALIGN_RIGHT)) ?
		CBRS_ALIGN_LEFT : CBRS_ALIGN_TOP;
	dwStyle |= dwBarStyle & CBRS_FLOAT_MULTI;

	// Systemmenue zurechtstutzen und "Close" in "Hide" umbenennen.
	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		pSysMenu->DeleteMenu(SC_SIZE, MF_BYCOMMAND);
		pSysMenu->DeleteMenu(SC_MINIMIZE, MF_BYCOMMAND);
		pSysMenu->DeleteMenu(SC_MAXIMIZE, MF_BYCOMMAND);
		pSysMenu->DeleteMenu(SC_RESTORE, MF_BYCOMMAND);

		CString strHide;
		if (strHide.LoadString(AFX_IDS_HIDE))
		{
			pSysMenu->DeleteMenu(SC_CLOSE, MF_BYCOMMAND);
			pSysMenu->AppendMenu(MF_STRING | MF_ENABLED, SC_CLOSE, strHide);
		}
	}

	// Zuerst mit dem Hauptrahmen als Elternfenster anlegen - so will es MFC,
	// weil CControlBar::OnCreate sich beim Rahmen anmeldet.
	if (!m_wndSECDockBar.Create(pParent, WS_CHILD | WS_VISIBLE | dwStyle,
			AFX_IDW_DOCKBAR_FLOAT))
	{
		m_bInRecalcLayout = FALSE;
		return FALSE;
	}

	m_wndSECDockBar.SetParent(this);
	m_bInRecalcLayout = FALSE;

	return TRUE;
}


// Wie CMiniDockFrameWnd::RecalcLayout (bardock.cpp:858-869), nur auf
// m_wndSECDockBar. QCMiniDockFrameWnd ersetzt die Fassung vollstaendig
// (workbook.cpp:539) und laesst den Titelabgleich weg, weil CWazooBar den
// Titel selbst setzt.
void SECMiniDockFrameWnd::RecalcLayout(BOOL bNotify)
{
	if (m_bInRecalcLayout)
		return;

	CMiniFrameWnd::RecalcLayout(bNotify);

	TCHAR szTitle[_MAX_PATH];
	szTitle[0] = _T('\0');
	if (m_wndSECDockBar.GetSafeHwnd() != NULL)
		m_wndSECDockBar.GetWindowText(szTitle, _countof(szTitle));

	::AfxSetWindowText(m_hWnd, szTitle);
}


// Zugabe des Originals (sbardock.h:253): anordnen UND an eine bestimmte
// Stelle setzen, in einem Zug. Im Original ruft SECDockContext das waehrend
// des Ziehens auf. Der Rumpf ist der von QCMiniDockFrameWnd
// (workbook.cpp:574-620) ohne dessen Titelbehandlung - Eudora hat ihn dort
// abgeschrieben, es ist also der Rumpf des Originals.
void SECMiniDockFrameWnd::RecalcLayout(CPoint point, BOOL bNotify)
{
	if (m_bInRecalcLayout)
		return;

	m_bInRecalcLayout = TRUE;

	// Angesammelte Anordnungswuensche mitnehmen.
	if (m_nIdleFlags & idleNotify)
		bNotify = TRUE;
	m_nIdleFlags &= ~(idleLayout | idleNotify);
	UNREFERENCED_PARAMETER(bNotify);

	if (GetStyle() & FWS_SNAPTOBARS)
	{
		CRect rect(0, 0, 32767, 32767);
		RepositionBars(0, 0xffff, AFX_IDW_PANE_FIRST, reposQuery,
			&rect, &rect, FALSE);
		RepositionBars(0, 0xffff, AFX_IDW_PANE_FIRST, reposExtra,
			&m_rectBorder, &rect, TRUE);
		CalcWindowRect(&rect);
		SetWindowPos(NULL, point.x, point.y, rect.Width(), rect.Height(),
			SWP_NOACTIVATE | SWP_NOZORDER);
	}
	else
	{
		RepositionBars(0, 0xffff, AFX_IDW_PANE_FIRST, reposExtra, &m_rectBorder);
	}

	m_bInRecalcLayout = FALSE;
}


// bardock.cpp:871-874. Schliessen heisst hier ausblenden, nicht zerstoeren.
void SECMiniDockFrameWnd::OnClose()
{
	m_wndSECDockBar.ShowAll(FALSE);
}


// bardock.cpp:876-918. Ziehen an der Titelzeile bzw. am Rahmen wird an den
// Andockkontext der ersten Leiste weitergereicht.
//
// ABWEICHUNG VOM ORIGINAL-MFC: dort steht ENSURE_VALID(pBar) und
// ENSURE(pBar->m_pDockContext != NULL) - eine leere schwebende Andockleiste
// gilt als unmoeglich. Hier wird geprueft statt zugesichert, denn der Shim
// kann nicht ausschliessen, dass ein Aufruf ohne Leiste ankommt; in dem Fall
// bleibt es beim gewoehnlichen Fensterverhalten.
void SECMiniDockFrameWnd::OnNcLButtonDown(UINT nHitTest, CPoint point)
{
	if (nHitTest == HTCAPTION)
	{
		ActivateTopParent();

		if ((m_wndSECDockBar.m_dwStyle & CBRS_FLOAT_MULTI) == 0)
		{
			CControlBar* pBar = m_wndSECDockBar.GetFirstDockedBar();
			if (pBar != NULL && pBar->m_pDockContext != NULL)
			{
				pBar->m_pDockContext->StartDrag(point);
				return;
			}
		}
	}
	else if (nHitTest >= HTSIZEFIRST && nHitTest <= HTSIZELAST)
	{
		ActivateTopParent();

		CControlBar* pBar = m_wndSECDockBar.GetFirstDockedBar();
		if (pBar != NULL && pBar->m_pDockContext != NULL)
		{
			// Leisten mit CBRS_SIZE_DYNAMIC duerfen kein CBRS_FLOAT_MULTI
			// haben (bardock.cpp:913).
			ASSERT((m_wndSECDockBar.m_dwStyle & CBRS_FLOAT_MULTI) == 0);
			pBar->m_pDockContext->StartResize(nHitTest, point);
			return;
		}
	}

	CMiniFrameWnd::OnNcLButtonDown(nHitTest, point);
}


// bardock.cpp:920-943. Doppelklick auf die Titelzeile dockt wieder an.
void SECMiniDockFrameWnd::OnNcLButtonDblClk(UINT nHitTest, CPoint point)
{
	if (nHitTest == HTCAPTION)
	{
		ActivateTopParent();

		if ((m_wndSECDockBar.m_dwStyle & CBRS_FLOAT_MULTI) == 0)
		{
			CControlBar* pBar = m_wndSECDockBar.GetFirstDockedBar();
			if (pBar != NULL && pBar->m_pDockContext != NULL)
			{
				pBar->m_pDockContext->ToggleDocking();
				return;
			}
		}
	}

	CMiniFrameWnd::OnNcLButtonDblClk(nHitTest, point);
}


// sbardock.h:260. In CMiniDockFrameWnd nicht ueberschrieben; das Original
// braucht die Nachricht, um das Verschwinden der letzten Leiste zu bemerken.
// Hier reicht das Durchreichen - CDockBar blendet den Rahmen selbst aus,
// sobald er leer ist (bardock.cpp).
void SECMiniDockFrameWnd::OnParentNotify(UINT message, LPARAM lParam)
{
	CMiniDockFrameWnd::OnParentNotify(message, lParam);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// STUFE 2b - DER REST DER ANDOCKFAMILIE
//
// PLAN.md nennt unter "Stufe 2 - Andockfamilie" nur SECControlBar, SECDockBar
// und SECMiniDockFrameWnd. Beim Messen der offenen Linkersymbole zeigte sich,
// dass fuenf weitere Klassen derselben Familie fehlen; ohne sie linkt
// Eudora.exe nicht:
//
//     swinfrm.h    SECFrameWnd            QCCustomizeToolBar.cpp:267-268
//     sdocksta.h   SECDockState           mainfrm.cpp:832, 934
//                  SECControlBarInfo      WazooBarMgr.cpp:432
//                  SECControlBarInfoEx    Oberflaeche von SECControlBarInfo
//     sbarmgr.h    SECControlBarManager   QCToolbarCmdPage.cpp:86,
//                                         QCToolBarManager.cpp:1378
//     sdockcnt.h   SECDockContext         QCChildToolBar.cpp:43
//
// ANDERES VORGEHEN ALS OBEN: diese fuenf Klassen bekommen KEINEN Ersatzheader.
// Ihre Originalheader uebersetzen unter MFC 14 fehlerfrei (nachgemessen: eine
// Probe, die secall.h einbindet, laeuft durch) - es fehlt allein die
// Umsetzung, die in der CHM-Freigabe nicht enthalten ist. Deshalb stehen hier
// nur die Rumpfdefinitionen zu den vorhandenen Deklarationen. Das hat zwei
// Vorteile: keine zweite Stelle, an der eine Deklaration gepflegt werden muss,
// und keine Absprache mit der Werkzeugleistenschicht noetig, deren
// SECToolBarManager von SECControlBarManager erbt.
//
// JEDE VIRTUELLE METHODE MUSS DEFINIERT SEIN, auch die von Eudora nie
// gerufenen: der Uebersetzer legt die Methodentabelle in der Uebersetzungs-
// einheit ab, die die erste nicht-inline virtuelle Methode definiert, und
// diese Tabelle verweist auf alle uebrigen.

#ifndef __SBARMGR_H__
#include "sbarmgr.h"		// SECControlBarManager (sbarmgr.h:41)
#endif

#ifndef __SDOCKCNT_H__
#include "sdockcnt.h"		// SECDockContext (sdockcnt.h:46)
#endif


/////////////////////////////////////////////////////////////////////////////
// SECFrameWnd  (Original: swinfrm.h:47)
//
// Das Gegenstueck zu SECMDIFrameWnd fuer Rahmen ohne MDI. Eudoras Hauptfenster
// ist ein SECMDIFrameWnd, die Klasse wird also nie erzeugt - gebraucht wird
// sie an genau einer Stelle, und zwar als Fallunterscheidung:
//
//     QCCustomizeToolBar.cpp:265  if (pFrameWnd->IsKindOf(RUNTIME_CLASS(SECMDIFrameWnd)))
//                          :267  else if (pFrameWnd->IsKindOf(RUNTIME_CLASS(SECFrameWnd)))
//                          :268      ((SECFrameWnd*)pFrameWnd)->FloatControlBar(pToolBar, pt);
//
// Der zweite Zweig wird nie genommen. Trotzdem muessen RUNTIME_CLASS und
// FloatControlBar vorhanden sein, sonst linkt QCCustomizeToolBar.obj nicht.
//
// Die Rumpfe entsprechen Methode fuer Methode denen von SECMDIFrameWnd weiter
// oben; dort steht auch die jeweilige Begruendung. Hier ist nur die Basis
// CFrameWnd statt CMDIFrameWnd.

IMPLEMENT_DYNCREATE(SECFrameWnd, CFrameWnd)

// Wortgleich zu SECMDIFrameWnd::dwSECDockBarMap und zu CFrameWnd::dwDockBarMap
// (winfrm2.cpp:18-24). Muss uebereinstimmen, sonst entstuenden doppelte
// Andockleisten.
const DWORD SECFrameWnd::dwSECDockBarMap[4][2] =
{
	{ AFX_IDW_DOCKBAR_TOP,      CBRS_TOP    },
	{ AFX_IDW_DOCKBAR_BOTTOM,   CBRS_BOTTOM },
	{ AFX_IDW_DOCKBAR_LEFT,     CBRS_LEFT   },
	{ AFX_IDW_DOCKBAR_RIGHT,    CBRS_RIGHT  },
};

// Leer aus demselben Grund wie bei SECMDIFrameWnd: das Original haengt hier
// seine Farbverlauf-Titelzeile ein, die der Shim nicht nachbaut. Jede
// Nachricht faellt an CFrameWnd durch.
BEGIN_MESSAGE_MAP(SECFrameWnd, CFrameWnd)
END_MESSAGE_MAP()


SECFrameWnd::SECFrameWnd()
{
	m_prevLayout.SetRectEmpty();

	m_uiTextAlign = acLeft;
	m_bNullGetText = FALSE;
	m_bHandleCaption = FALSE;	// keine selbstgemalte Titelzeile
	m_bActive = FALSE;

	m_pControlBarManager = NULL;

	m_bIsWin95orAbove = FALSE;
	GetWindowsVersion();
}

SECFrameWnd::~SECFrameWnd()
{
	// m_pControlBarManager gehoert dem Anwender der Klasse.
}

#ifdef _DEBUG
void SECFrameWnd::AssertValid() const
	{ CFrameWnd::AssertValid(); }
void SECFrameWnd::Dump(CDumpContext& dc) const
	{ CFrameWnd::Dump(dc); }
#endif

void SECFrameWnd::GetWindowsVersion()
{
	m_bIsWin95orAbove = TRUE;
}

void SECFrameWnd::EnableDocking(DWORD dwDockStyle)
{
	CFrameWnd::EnableDocking(dwDockStyle);
}

void SECFrameWnd::FloatControlBar(CControlBar* pBar, CPoint point, DWORD dwStyle)
{
	CFrameWnd::FloatControlBar(pBar, point, dwStyle);
}

// Wie SECMDIFrameWnd::DockControlBarEx - dort steht die Begruendung zu
// nCol/nRow/fPctWidth/nHeight.
void SECFrameWnd::DockControlBarEx(CControlBar* pBar, UINT nDockBarID,
	int /*nCol*/, int /*nRow*/, float fPctWidth, int nHeight)
{
	SECControlBar* pSECBar = DYNAMIC_DOWNCAST(SECControlBar, pBar);
	if (pSECBar != NULL)
	{
		pSECBar->m_fPctWidth = fPctWidth;
		pSECBar->m_fDockedPctWidth = fPctWidth;

		if (nHeight > 0)
		{
			pSECBar->m_szDockHorz.cy = nHeight;
			pSECBar->m_szDockVert.cx = nHeight;
		}
	}

	CFrameWnd::DockControlBar(pBar, nDockBarID, NULL);
}

void SECFrameWnd::DockControlBar(CControlBar* pBar, UINT nDockBarID, LPCRECT lpRect)
{
	CFrameWnd::DockControlBar(pBar, nDockBarID, lpRect);
}

void SECFrameWnd::DockControlBar(CControlBar* pBar, CDockBar* pDockBar, LPCRECT lpRect)
{
	CFrameWnd::DockControlBar(pBar, pDockBar, lpRect);
}

void SECFrameWnd::ReDockControlBar(CControlBar* pBar, CDockBar* pDockBar, LPCRECT lpRect)
{
	CFrameWnd::ReDockControlBar(pBar, pDockBar, lpRect);
}

void SECFrameWnd::ShowControlBar(CControlBar* pBar, BOOL bShow, BOOL bDelay)
{
	CFrameWnd::ShowControlBar(pBar, bShow, bDelay);
}

void SECFrameWnd::LoadBarState(LPCTSTR lpszProfileName)
{
	CFrameWnd::LoadBarState(lpszProfileName);
}

void SECFrameWnd::SaveBarState(LPCTSTR lpszProfileName) const
{
	CFrameWnd::SaveBarState(lpszProfileName);
}

// SECDockState erbt von CDockState (sdocksta.h:39), der Zustand laesst sich
// also weiterreichen. Was dabei verlorengeht, sind die SEC-Zusatzangaben je
// Leiste - siehe die Anmerkung bei SECControlBarInfo weiter unten.
void SECFrameWnd::SetDockState(SECDockState& state)
{
	CFrameWnd::SetDockState(state);
}

void SECFrameWnd::GetDockState(SECDockState& state) const
{
	CFrameWnd::GetDockState(state);
}

SECControlBarManager* SECFrameWnd::GetControlBarManager() const
{
	return m_pControlBarManager;
}

void SECFrameWnd::SetControlBarManager(SECControlBarManager* pManager)
{
	m_pControlBarManager = pManager;
}

BOOL SECFrameWnd::EnableCustomCaption(BOOL bEnable, BOOL /*bRedraw*/)
{
	BOOL bWar = m_bHandleCaption;
	m_bHandleCaption = bEnable;
	return bWar;
}

void SECFrameWnd::ForceCaptionRedraw(BOOL /*bImmediate*/)
{
}

void SECFrameWnd::SetCaptionTextAlign(AlignCaption ac, BOOL /*bRedraw*/)
{
	m_uiTextAlign = (UINT)ac;
}

void SECFrameWnd::OnSetPreviewMode(BOOL bPreview, CPrintPreviewState* pState)
{
	CFrameWnd::OnSetPreviewMode(bPreview, pState);
}

void SECFrameWnd::OnSysColorChange()
{
	CFrameWnd::OnSysColorChange();
}

void SECFrameWnd::RecalcLayout(BOOL bNotify)
{
	CFrameWnd::RecalcLayout(bNotify);
}

// ACHTUNG, kein Ueberschreiben: CFrameWnd deklariert OnUpdateFrameMenu mit
// einem Argument (afxwin.h:4283), die dreistellige Fassung gibt es erst in
// CMDIChildWnd (afxwin.h:4488). Diese hier ist also eine eigene virtuelle
// Funktion, die das Original zusaetzlich eingefuehrt hat.
void SECFrameWnd::OnUpdateFrameMenu(BOOL /*bActive*/, CWnd* /*pActivateWnd*/,
	HMENU hMenuAlt)
{
	CFrameWnd::OnUpdateFrameMenu(hMenuAlt);
}

void SECFrameWnd::OnNcPaint()
{
	CFrameWnd::OnNcPaint();
}

// Einziger Rumpf mit Inhalt: m_bActive wird von GetActiveState() nach aussen
// gereicht (swinfrm.h:56), muss also stimmen.
void SECFrameWnd::OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized)
{
	m_bActive = (nState != WA_INACTIVE);
	CFrameWnd::OnActivate(nState, pWndOther, bMinimized);
}

void SECFrameWnd::OnNcLButtonDown(UINT nHitTest, CPoint point)
{
	CFrameWnd::OnNcLButtonDown(nHitTest, point);
}

void SECFrameWnd::OnNcMButtonDown(UINT nHitTest, CPoint point)
{
	CFrameWnd::OnNcMButtonDown(nHitTest, point);
}

void SECFrameWnd::OnNcRButtonDown(UINT nHitTest, CPoint point)
{
	CFrameWnd::OnNcRButtonDown(nHitTest, point);
}

BOOL SECFrameWnd::OnNcActivate(BOOL bActive)
{
	return CFrameWnd::OnNcActivate(bActive);
}

// Farbverlauf-Titelzeile, steht in keiner Nachrichtentabelle.
LRESULT SECFrameWnd::OnGetText(WPARAM /*wParam*/, LPARAM /*lParam*/)
{
	return 0;
}

LRESULT SECFrameWnd::OnSetText(WPARAM /*wParam*/, LPARAM /*lParam*/)
{
	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBarInfoEx  (Original: sdocksta.h:68)
//
// Ablage fuer Zusatzangaben, die eine abgeleitete Leiste ueber die von
// SECControlBarInfo hinaus sichern will. Eudora leitet SECCustomToolBarInfoEx
// davon ab (Werkzeugleistenschicht) und legt sie in
// SECControlBarInfo::m_pBarInfoEx ab (QCToolBarManager.cpp:1357).
//
// STUFE 2 OFFEN: das Sichern selbst. Siehe die Anmerkung bei
// SECControlBarInfo::SaveState.

IMPLEMENT_DYNCREATE(SECControlBarInfoEx, CObject)

SECControlBarInfoEx::SECControlBarInfoEx()
{
}

void SECControlBarInfoEx::Serialize(CArchive& /*ar*/, SECDockState* /*pDockState*/)
{
}

BOOL SECControlBarInfoEx::LoadState(LPCTSTR /*lpszSection*/, SECDockState* /*pDockState*/)
{
	return FALSE;
}

BOOL SECControlBarInfoEx::SaveState(LPCTSTR /*lpszSection*/)
{
	return FALSE;
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBarInfo  (Original: sdocksta.h:86)
//
// Der aufgezeichnete Zustand einer einzelnen Leiste. Erbt von
// CControlBarInfo (afxpriv.h:557) und legt die SEC-Zusatzfelder daneben.
// WazooBarMgr.cpp:432 legt ein Objekt auf dem Stapel an und benutzt es als
// Zwischenspeicher fuer SECControlBar::Get/SetBarInfo - das ist der einzige
// Weg, auf dem Eudora die Klasse anfasst, und er funktioniert vollstaendig.
//
// STUFE 2 OFFEN: das Sichern in die INI. Der Grund liegt in MFC, nicht hier -
// CDockState::SaveState ruft pInfo->SaveState(...) ueber einen
// CControlBarInfo* und NICHT virtuell auf (dockstat.cpp), und CDockState::
// LoadState legt CControlBarInfo-Objekte an, keine SECControlBarInfo. Die
// SEC-Zusatzfelder kaemen also gar nicht erst in die Hand dieser Klasse.
// FOLGE: ueber SetDockState wird der MFC-Anteil des Leistenzustands
// wiederhergestellt (Sichtbarkeit, Andockleiste, Lage), nicht aber
// m_szDockHorz/-Vert, m_fPctWidth und die erweiterten Stile.

SECControlBarInfo::SECControlBarInfo()
{
	m_szDockHorz = CSize(0, 0);
	m_ptDockHorz = CPoint(0, 0);
	m_szDockVert = CSize(0, 0);
	m_szFloat    = CSize(0, 0);

	m_dwMRUDockingState = 0;
	m_dwDockStyle       = 0;
	m_fPctWidth         = (float)1.0;
	m_dwStyle           = 0;
	m_dwExStyle         = 0;

	m_bPreviouslyFloating = FALSE;
	m_bMDIChild           = FALSE;

	m_pBarInfoEx          = NULL;
	m_dwBarTypeID         = 0;
	m_pControlBarManager  = NULL;
}


SECControlBarInfo::SECControlBarInfo(SECControlBarManager* pControlBarManager)
{
	m_szDockHorz = CSize(0, 0);
	m_ptDockHorz = CPoint(0, 0);
	m_szDockVert = CSize(0, 0);
	m_szFloat    = CSize(0, 0);

	m_dwMRUDockingState = 0;
	m_dwDockStyle       = 0;
	m_fPctWidth         = (float)1.0;
	m_dwStyle           = 0;
	m_dwExStyle         = 0;

	m_bPreviouslyFloating = FALSE;
	m_bMDIChild           = FALSE;

	m_pBarInfoEx          = NULL;
	m_dwBarTypeID         = 0;
	m_pControlBarManager  = pControlBarManager;
}


SECControlBarInfo::~SECControlBarInfo()
{
	// m_pBarInfoEx gehoert diesem Objekt: QCToolBarManager legt es an und
	// haengt es ein (QCToolBarManager.cpp:1357 liest es, die Zusatzschicht
	// erzeugt es ueber CreateControlBarInfoEx).
	delete m_pBarInfoEx;
	m_pBarInfoEx = NULL;
}


void SECControlBarInfo::Serialize(CArchive& ar, SECDockState* pDockState)
{
	// Der MFC-Anteil. CControlBarInfo::Serialize nimmt einen CDockState*
	// entgegen (afxpriv.h:581); SECDockState erbt davon.
	CControlBarInfo::Serialize(ar, pDockState);

	// Der SEC-Anteil wird bewusst NICHT mitgeschrieben: das Format muesste
	// dann zum Original passen, und das ist ohne dessen Umsetzung nicht
	// feststellbar. Eine eigene Erweiterung wuerde eine Datei erzeugen, die
	// ein spaeterer echter Nachbau nicht mehr lesen kann.
}


BOOL SECControlBarInfo::LoadState(LPCTSTR lpszProfileName, int nIndex,
	SECDockState* pDockState)
{
	return CControlBarInfo::LoadState(lpszProfileName, nIndex, pDockState);
}


BOOL SECControlBarInfo::SaveState(LPCTSTR lpszProfileName, int nIndex)
{
	return CControlBarInfo::SaveState(lpszProfileName, nIndex);
}


/////////////////////////////////////////////////////////////////////////////
// SECDockState  (Original: sdocksta.h:39)
//
// Die Sammlung aller Leistenzustaende. Eudora benutzt sie an zwei Stellen:
//     mainfrm.cpp:832  SECDockState state(m_pControlBarManager);
//     mainfrm.cpp:833  state.LoadState(...)
//     mainfrm.cpp:934  SetDockState(state)
//
// Erbt von CDockState (afxadv.h:164), das Laden und Setzen laeuft also
// wirklich. Was fehlt, sind die SEC-Zusatzangaben je Leiste - siehe
// SECControlBarInfo.

IMPLEMENT_SERIAL(SECDockState, CDockState, 1)

SECDockState::SECDockState()
{
	m_pControlBarManager = NULL;
}

SECDockState::SECDockState(SECControlBarManager* pControlBarManager)
{
	m_pControlBarManager = pControlBarManager;
}

SECDockState::~SECDockState()
{
	// CDockState::~CDockState raeumt m_arrBarInfo ab.
}

void SECDockState::Serialize(CArchive& ar)
{
	CDockState::Serialize(ar);
}

void SECDockState::SaveState(LPCTSTR lpszProfileName)
{
	CDockState::SaveState(lpszProfileName);
}

void SECDockState::LoadState(LPCTSTR lpszProfileName)
{
	CDockState::LoadState(lpszProfileName);
}

// Verdeckt CDockState::Clear (afxadv.h:177), das dasselbe tut.
void SECDockState::Clear()
{
	CDockState::Clear();
}

// UNGEPRUEFT: was das Original hier genau aufraeumt. Der Name und die Lage
// legen nahe: Eintraege zu Leisten wegwerfen, die es nicht mehr gibt. Von
// Eudora nicht aufgerufen - mainfrm.cpp benutzt nur den Konstruktor,
// LoadState und SetDockState. CDockState kommt mit unbekannten Kennungen
// selbst zurecht (es sucht die Leiste ueber GetDlgItem und laesst den Eintrag
// aus, wenn nichts gefunden wird), deshalb ist hier nichts zu tun.
void SECDockState::CleanUpControlBarState()
{
}


/////////////////////////////////////////////////////////////////////////////
// SECControlBarManager  (Original: sbarmgr.h:41)
//
// Der Leistenverwalter. Eudora leitet QCToolBarManager davon ab (ueber
// SECToolBarManager, Werkzeugleistenschicht) und hat den Sicherungsteil
// laengst selbst uebernommen: QCLoadState und QCSaveState ersetzen LoadState
// und SaveState (PLAN.md, Stufe 3).
//
// Wirklich gebraucht sind nur zwei Dinge:
//     GetFrameWnd            QCToolbarCmdPage.cpp:86
//     DynCreateControlBar    QCToolBarManager.cpp:1378 - als Standardzweig
//                            eines switch, der alle Eudora-eigenen Typen
//                            schon vorher abgefangen hat. NULL ist dort die
//                            richtige Antwort: "diesen Leistentyp kenne ich
//                            nicht".

IMPLEMENT_DYNAMIC(SECControlBarManager, CCmdTarget)

BEGIN_MESSAGE_MAP(SECControlBarManager, CCmdTarget)
END_MESSAGE_MAP()


SECControlBarManager::SECControlBarManager()
{
	m_pFrameWnd = NULL;
}

SECControlBarManager::SECControlBarManager(CFrameWnd* pFrameWnd)
{
	m_pFrameWnd = pFrameWnd;
}

SECControlBarManager::~SECControlBarManager()
{
	// Der Rahmen gehoert dem Verwalter nicht.
}

CFrameWnd* SECControlBarManager::GetFrameWnd() const
{
	return m_pFrameWnd;
}


// STUFE 2 OFFEN. Eudora ruft die beiden nie auf (PLAN.md: alle Treffer im
// Inventar stammen aus Kommentaren); QCToolBarManager hat mit QCLoadState und
// QCSaveState eigene Fassungen. Sie bleiben als Rumpf stehen, weil sie
// virtuell sind und deshalb in der Methodentabelle auftauchen.
void SECControlBarManager::LoadState(LPCTSTR /*lpszProfileName*/)
{
	TRACE0("OTShim: SECControlBarManager::LoadState - Stufe 2 offen\n");
}

void SECControlBarManager::SaveState(LPCTSTR /*lpszProfileName*/) const
{
	TRACE0("OTShim: SECControlBarManager::SaveState - Stufe 2 offen\n");
}


// Im Original die Stelle, an der ein Verwalter sagt, unter welcher Kennung er
// einen Leistentyp aufzeichnet. QCToolBarManager ueberschreibt das mit seinen
// eigenen CBT_-Werten; 0 heisst "kein besonderer Typ".
DWORD SECControlBarManager::GetBarTypeID(CControlBar* /*pBar*/) const
{
	return 0;
}

// NULL heisst: dieser Leistentyp braucht keine Zusatzangaben.
SECControlBarInfoEx* SECControlBarManager::CreateControlBarInfoEx(
	SECControlBarInfo* /*pBarInfo*/) const
{
	return NULL;
}

// Standardzweig von QCToolBarManager::DynCreateControlBar
// (QCToolBarManager.cpp:1378): alle Eudora-eigenen Typen sind vorher
// abgefangen, hier bleibt nur "unbekannt".
CControlBar* SECControlBarManager::DynCreateControlBar(SECControlBarInfo* /*pBarInfo*/)
{
	return NULL;
}


/////////////////////////////////////////////////////////////////////////////
// SECDockContext  (Original: sdockcnt.h:46)
//
// Der Ziehvorgang einer Leiste. MFC hat mit CDockContext (afxpriv.h:489) das
// vollstaendige Gegenstueck; das Original erweitert es um das Umschalten in
// ein MDI-Kindfenster.
//
// EUDORA BENUTZT DIE KLASSE AN GENAU EINER STELLE: QCChildToolBar.cpp:43
// leitet CDontFloatDockContext davon ab und macht StartDrag leer, damit sich
// die Werkzeugleiste eines Kindfensters nicht abziehen laesst. Gebraucht
// werden davon der Konstruktor, der Destruktor und die drei virtuellen
// Methoden aus der Methodentabelle.
//
// ACHTUNG: die Klasse legt niemand an. CControlBar erzeugt seinen Kontext
// selbst als CDockContext (winfrm2.cpp), und QCChildToolBar ersetzt ihn durch
// sein CDontFloatDockContext. Der Shim hat also keinen Anlass, hier mehr zu
// tun als durchzureichen.

SECDockContext::SECDockContext(CControlBar* pBar) :
	CDockContext(pBar)
{
	m_rectFocus.SetRectEmpty();
	m_ptStartDrag = CPoint(0, 0);
	m_ptPrev      = CPoint(0, 0);
	m_nPosDockingRow = -1;
	m_bPreviouslyFloating = FALSE;
}


SECDockContext::~SECDockContext()
{
}


// Doppelklick auf die Titelzeile: zwischen angedockt und schwebend umschalten.
void SECDockContext::ToggleDocking()
{
	CDockContext::ToggleDocking();
}


// STUFE 2 OFFEN: zwischen schwebend und "eigenes MDI-Kindfenster" umschalten.
// Die Begruendung steht bei SECMDIFrameWnd::FloatControlBarInMDIChild. Der
// Weg dorthin ist derselbe, deshalb auch hier keine Meldung.
void SECDockContext::ToggleMDIFloat()
{
	TRACE0("OTShim: SECDockContext::ToggleMDIFloat - Stufe 2 offen\n");
}


void SECDockContext::StartDrag(CPoint pt)
{
	m_ptStartDrag = pt;
	m_ptPrev      = pt;
	CDockContext::StartDrag(pt);
}

void SECDockContext::Move(CPoint pt)
{
	m_ptPrev = pt;
	CDockContext::Move(pt);
}

void SECDockContext::EndDrag()
{
	CDockContext::EndDrag();
}

void SECDockContext::StartResize(int nHitTest, CPoint pt)
{
	m_ptStartDrag = pt;
	m_ptPrev      = pt;
	CDockContext::StartResize(nHitTest, pt);
}

void SECDockContext::Stretch(CPoint pt)
{
	m_ptPrev = pt;
	CDockContext::Stretch(pt);
}

void SECDockContext::EndResize()
{
	CDockContext::EndResize();
}

void SECDockContext::CancelLoop()
{
	CDockContext::CancelLoop();
}

BOOL SECDockContext::Track()
{
	return CDockContext::Track();
}

// Der gestrichelte Rahmen waehrend des Ziehens. m_rectFocus des Originals
// bleibt ungepflegt - CDockContext fuehrt mit m_rectLast sein eigenes.
void SECDockContext::DrawFocusRect(BOOL bRemoveRect)
{
	CDockContext::DrawFocusRect(bRemoveRect);
}

DWORD SECDockContext::CanDock()
{
	return CDockContext::CanDock();
}
