// OTShim_Reiter.h - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1,
//                   Registerkarten-Familie
//
// Ersetzt vier Originalheader aus OT501/Include:
//
//     tabctrlb.h   SECTab, SECTabControlBase, TCM_*, TCS_TABS_ON_*
//     tabwndb.h    SECTabWndBase, SEC_IDW_*, GetParentTabWnd
//     tabctrl3.h   SEC3DTab, SEC3DTabControl, SEC3DTAB_*
//     tabwnd3.h    SEC3DTabWnd
//
// NICHT ersetzt werden tabctrl.h (SECTabControl) und tabwnd.h (SECTabWnd,
// SEC2DTabWnd). Eudora benutzt die beiden 2D-Klassen nirgends; ihre Header
// enthalten aber die TWS_*-Konstanten, die QC3DTabWnd.cpp:418-471 auswertet.
// Diese Datei bindet sie deshalb im Original ein (siehe unten) statt die
// Konstanten zu verdoppeln. Die 2D-Klassen bleiben damit reine
// Deklarationen ohne Rumpf - das bindet nicht, weil sie nirgends erzeugt
// werden.
//
//
// WARUM DIESE FAMILIE NICHT ENTFALLEN KANN
//
// PLAN.md, Abschnitt "Der Weg zum ersten startenden Eudora.exe", haelt die
// Registerkartenleiste fuer verzichtbar, weil m_bWorkbookMode sie zur
// Laufzeit abschalte. Das trifft auf den MDI-Streifen von SECWorkbook zu,
// nicht aber auf diese Klassen. SEC3DTabWnd/SEC3DTabControl sind das
// Registerkarten-Steuerelement INNERHALB jeder Wazoo-Leiste:
//
//     Eudora/WazooBar.h:137     QC3DTabWnd m_wndTab;   (Feld von CWazooBar)
//     Eudora/QC3DTabWnd.h:74    class QC3DTabWnd : public SEC3DTabWnd
//     Eudora/QC3DTabWnd.h:14    class QC3DTabControl : public SEC3DTabControl
//
// m_bWorkbookMode schaltet davon nichts ab. Mit leeren Ruempfen bliebe jede
// Wazoo-Leiste leer - Mailboxes, Nicknames, Filters, Directory Services,
// Link History, Task Status. Die Listenpflege ist deshalb hier echt
// umgesetzt; Ruempfe sind einzeln als solche gekennzeichnet und begruendet.
//
//
// VOLLSTAENDIGE LISTE DER AUFRUFSTELLEN IN EUDORA
//
// Auf QC3DTabWnd (also SEC3DTabWnd/SECTabWndBase), Feld CWazooBar::m_wndTab:
//     Create(CWnd*)                       WazooBar.cpp:1163, AdWazooBar.cpp:361
//     InsertTab(CWnd*,int,LPCTSTR)        WazooBar.cpp:157, 270, 282
//     AddTab(CWnd*,LPCTSTR)               WazooBar.cpp:165, 287
//     SetTabIcon(int,HICON)               WazooBar.cpp:177, 300
//     RemoveTab(CWnd*)                    WazooBar.cpp:202
//     TabExists(CWnd*)                    WazooBar.cpp:200
//     FindTab(const CWnd*,int&)           WazooBar.cpp:175, 251, 298, 1749
//     GetTabCount()                       WazooBar.cpp 19x, u.a. 142, 458, 1470
//     GetTabInfo(int,...,CWnd*&,void*&)   WazooBar.cpp:336, 427, 487, 810,
//                                         1205, 1497
//     GetActiveTab(int&)                  WazooBar.cpp:341, 833, 933
//     GetActiveTab(CWnd*&)                WazooBar.cpp:384, 1289, 1312, 1388
//     ActivateTab(int)                    WazooBar.cpp:347, 408
//     ActivateTab(CWnd*)                  WazooBar.cpp:1364
//     ScrollToTab(int)                    WazooBar.cpp:409
//     ScrollToTab(CWnd*)                  WazooBar.cpp:1365
//     GetTabStyle()/SetTabStyle()         QC3DTabWnd.cpp:431, 434, 459
//     RecalcLayout()                      QC3DTabWnd.cpp:539 (Ueberschreibung)
//     CreateTabCtrl(DWORD,UINT)           QC3DTabWnd.cpp:522 (Ueberschreibung)
//     OnPaint()                           QC3DTabWnd.cpp:616 (ruft Basis)
//     m_pTabCtrl, m_pActiveWnd,           QC3DTabWnd.cpp:493, 560-580, 597
//       m_cxTabCtrl, m_cyTabCtrl,
//       m_dwTabCtrlStyle
//
// Auf QC3DTabControl (also SEC3DTabControl/SECTabControlBase):
//     Create(DWORD,const RECT&,CWnd*,UINT)  QC3DTabWnd.cpp:526
//     GetTabCount()                         QC3DTabWnd.cpp:57, 150, 483
//     GetTabPtr(int) -> SEC3DTab::m_hIcon   QC3DTabWnd.cpp:58
//     GetTabInfo(int,...,CObject*&,HMENU&,void*&)
//                                           QC3DTabWnd.cpp:89, 115, 229
//     GetActiveTab(int&)                    QC3DTabWnd.cpp:79
//     ActivateTab(int)                      QC3DTabWnd.cpp:131 (Ueberschreibung)
//     TabHit(int,CPoint&)                   QC3DTabWnd.cpp:152, 391
//     OnLButtonDown                         QC3DTabWnd.cpp:143 (ruft Basis)
//     OnLButtonUp/OnMouseMove               QC3DTabWnd.cpp:173, 196 - das sind
//                                           KEINE SEC-Methoden, sondern
//                                           CWnd::OnLButtonUp/OnMouseMove
//                                           (Kategorie A nach PLAN.md). Sie
//                                           werden hier bewusst NICHT
//                                           deklariert, sonst wuerden sie die
//                                           geerbten verdecken.
//
// Die Registerkartennachricht TCM_TABSEL wird an zwei Stellen ausgewertet:
//     WazooBar.cpp:51    ON_MESSAGE(TCM_TABSEL, OnTabSelect)  (CWazooBar)
//     workbook.cpp:646   ON_MESSAGE(TCM_TABSEL, OnTabSelect)  (QCWorkbook)
// Das Steuerelement schickt sie an sein Elternfenster (das SEC3DTabWnd),
// dieses reicht sie an sein Elternfenster (die Wazoo-Leiste) weiter. Nur so
// erreicht sie CWazooBar::OnTabSelect. Siehe SECTabWndBase::OnTabSelect.
//
//
// TECHNIKWAHL: EIGENZEICHNUNG AUF CWnd, NICHT MFCs CTabCtrl
//
// Fuer die Zeichenarbeit gibt es - anders als bei SECStdBtn::DrawFace - keine
// Vorlage im Repo. Geprueft wurde, ob das gemeine Windows-Steuerelement
// SysTabControl32 (MFC: CTabCtrl) als Unterbau taugt. Vier Befunde sprechen
// dagegen:
//
//  1. Die Stilbits kollidieren. tabctrlb.h:68-71 belegt 0x0010/0x0020/0x0040/
//     0x0080 mit TCS_TABS_ON_BOTTOM/TOP/LEFT/RIGHT. commctrl.h belegt
//     dieselben Bits mit TCS_FORCEICONLEFT/FORCELABELLEFT/HOTTRACK/VERTICAL.
//     Eudora reicht den Stil ungefiltert durch:
//         QC3DTabWnd.cpp:526  m_pTabCtrl->Create(WS_VISIBLE | m_dwTabCtrlStyle, ...)
//     Ein echtes SysTabControl32 bekaeme damit vier falsche Stile gesetzt.
//  2. Die Datenhaltung waere doppelt. tabctrlb.h:130 schreibt einen CObArray
//     aus SECTab vor, und Eudora greift darauf durch: QC3DTabWnd.cpp:58 liest
//     SEC3DTab::m_hIcon ueber GetTabPtr, QC3DTabWnd.cpp:152 fragt TabHit auf
//     dem gespeicherten SEC3DTab::m_rect. Beides muesste neben den
//     TCITEM-Daten des Steuerelements gepflegt werden.
//  3. Die vier Anordnungen links/rechts/oben/unten bildet CTabCtrl nicht ab.
//     TCS_VERTICAL kennt nur links, und Eudora bietet alle vier an
//     (WazooBar.cpp:1430-1460, Menue "Tab Location").
//  4. Symbole muessten ueber eine CImageList laufen, waehrend die
//     Schnittstelle rohe HICON verlangt (tabctrl3.h:103).
//
// Eigenzeichnung auf einem CWnd ist damit nicht nur naeher am Original,
// sondern schlicht weniger Code. Das Aussehen entspricht dem Original nicht
// und muss es laut Auftrag auch nicht; es ist ein flacher 3D-Reiterstreifen
// mit Symbol und Beschriftung.
//
//
// EINBINDUNG
//   Diese Datei darf nicht gemeinsam mit tabctrlb.h, tabwndb.h, tabctrl3.h
//   oder tabwnd3.h uebersetzt werden. Sie setzt deren Einbindungswaechter
//   __TABCTRLB_H__, __TABWNDB_H__, __TABCTRL3_H__ und __TABWND3_H__ selbst,
//   damit ein spaeteres #include "secall.h" (SECALL.H:153-180) die vier
//   Dateien ueberspringt. In OTShimAll.h gehoert sie deshalb VOR die Zeile
//   #include "secall.h".
//
//   Der Suchpfad muss OT501/Include enthalten (wegen tabctrl.h/tabwnd.h).
//
//
// WAS IN OTShimAll.h ZU TUN IST
//
//   1. #include "OTShim_Reiter.h" VOR #include "secall.h" aufnehmen.
//      Die Datei ist von OTShim.h, OTShim_Bild.h und
//      OTShim_Werkzeugleiste.h unabhaengig; die Reihenfolge unter den
//      Shim-Headern ist beliebig.
//   2. Es sind KEINE zusaetzlichen Waechterzeilen noetig. Diese Datei setzt
//      alle vier Waechter selbst:
//          __TABCTRLB_H__   nach SECTabControlBase
//          __TABWNDB_H__    nach SECTabWndBase
//          __TABCTRL3_H__   nach SEC3DTabControl
//          __TABWND3_H__    nach SEC3DTabWnd
//      __TABCTRL_H__ und __TABWND_H__ setzen die Originale selbst, weil
//      diese Datei sie einbindet.
//   3. In Eudora.vcxproj muss OTShim_Reiter.cpp mit
//      <PrecompiledHeader>NotUsing</PrecompiledHeader> aufgenommen werden,
//      wie OTShim.cpp und OTShim_Bild.cpp.
//
//
// STAND (Was echt ist, was Rumpf blieb)
//
//   ECHT UMGESETZT: die vollstaendige Listenpflege (InsertTab, AddTab,
//   DeleteTab, RemoveTab, RenameTab, FindTab, TabExists, GetTabCount,
//   GetTabInfo, GetActiveTab, ActivateTab, SelectTab, ClearSelection,
//   SetTabIcon, EnableTab/IsTabEnabled), die Anordnung samt Bildlauf
//   (RecalcLayout, SetTabPos, ScrollToTab, TabHit, GetTabRect,
//   GetLabelWidth), das gesamte Zeichnen (DrawTab, DrawTabTop/Bottom/
//   Left/Right, DrawInterior, DrawDisabled, rgbFill, VLine3D, HLine3D),
//   der Fensterwechsel und die Nachrichtenkette TCM_TABSEL vom
//   Steuerelement ueber SECTabWndBase zur Wazoo-Leiste.
//
//   RUMPF GEBLIEBEN (jeweils an Ort und Stelle in der .cpp begruendet):
//       SECTabWndBase::CreateScrollBarCtrl, ::SetScrollStyle
//           Bildlaufleisten gibt es nur in der 2D-Familie (tabwnd.h:83).
//       SECTabWndBase::ActivateTab(CWnd*, int)
//           Der zweite Parameter waehlt einen von mehreren Bereichen, die
//           es nur in SECTabWnd gibt; faellt auf die einstellige Fassung
//           zurueck.
//       SECTabControlBase::SetTabIcon (alle drei)
//           SECTab hat kein Symbolfeld; erst SEC3DTab hat m_hIcon.
//       SECTabControlBase::RecalcLayout, ::ScrollToTab
//           Die Basis kennt keine Reiterrechtecke.
//   Keiner dieser Ruempfe hat einen Aufrufer in Eudora.
//
//
// WAS AUS SICHT DIESER FAMILIE NOCH FEHLT
//
//   - GEMESSEN 29.08.2026 mit cl 14.38.33130 (/W3 /MD /D_AFXDLL): OTShim_Reiter.cpp uebersetzt warnungsfrei; ein Bindetest, der alle vier Klassen erzeugt und jede oeffentliche Methode anfasst, bindet ohne offene Verweise; Waechtertest bestanden (die vier Originalheader sind danach wirkungslos, tabctrl.h und tabwnd.h uebersetzen gegen die Ersatzklassen).
//   - Gegen Eudora selbst ist noch nicht uebersetzt worden; das geht erst, wenn Stufe 3 (OTShim_Werkzeugleiste) steht, weil CWazooBar von
//     SECControlBar erbt und QC3DTabWnd.cpp SECDockBar mitzieht.
//   - Die Kurzhinweise haengen an der MFC-eigenen Verwaltung
//     (EnableToolTips + OnToolHitTest). Ob MFC sie fuer ein freistehendes
//     Kindfenster ohne Rahmenfenster wirklich weiterleitet, ist ungeprueft.
//     Faellt es aus, fehlt nur der Kurzhinweis, sonst nichts.
//   - Das Aussehen ist bewusst einfach gehalten (Rechteck mit 3D-Kanten
//     statt Trapez). Das Original ist nicht rekonstruierbar - von OT501
//     liegt ausser secaux.cpp keine Implementierung vor.
//
// Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

#ifndef __OTSHIM_REITER_H__
#define __OTSHIM_REITER_H__

#include <afxwin.h>

#if defined(__TABCTRLB_H__) || defined(__TABWNDB_H__) || \
    defined(__TABCTRL3_H__) || defined(__TABWND3_H__)
#error OTShim_Reiter.h ersetzt tabctrlb.h, tabwndb.h, tabctrl3.h und tabwnd3.h - diese duerfen vorher nicht eingebunden sein.
#endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// 1. SECTab und SECTabControlBase   (Original: tabctrlb.h)
//
/////////////////////////////////////////////////////////////////////////////

// Registerkartennachrichten, wortgleich tabctrlb.h:63-65
#define TCM_TABSEL		(WM_USER+1000)
#define TCM_TABDBLCLK		(WM_USER+1001)
#define TCM_TABSELCLR		(WM_USER+1002)

// Registerkartenstile, wortgleich tabctrlb.h:68-72. Wertgleich mit den
// TWS_*-Stilen des Fensters (tabwnd.h:42-47); QC3DTabWnd.cpp verlaesst sich
// darauf und mischt beide Schreibweisen (dort :432 gegen :560).
#define TCS_TABS_ON_BOTTOM	0x0010
#define TCS_TABS_ON_TOP		0x0020
#define TCS_TABS_ON_LEFT	0x0040
#define TCS_TABS_ON_RIGHT	0x0080
#define TCS_TAB_ORIENTATIONS 0x00f0


/////////////////////////////////////////////////////////////////////////////
// SECTab  (tabctrlb.h:33)
//
// Feldsatz unveraendert uebernommen. Der Destruktor bleibt wie im Original
// geschuetzt. Geloescht wird ein Reiter deshalb ueber den CObject-Zeiger aus
// dem CObArray: CObject hat einen oeffentlichen virtuellen Destruktor
// (afx.h), die Zugriffspruefung greift also an CObject und die Ausfuehrung
// landet trotzdem bei ~SECTab. Siehe SECTabControlBase::DeleteTab.

class SECTab : public CObject
{
	DECLARE_DYNAMIC(SECTab);

// Attribute
public:
	CString m_csLabel;
	int m_nWidth;
	int m_nHeight;
	BOOL m_bSelected;
	CObject* m_pClient;		// zugehoeriges Objekt; bei SECTabWndBase ein CWnd*
	HMENU m_hMenu;
	void* m_pExtra;			// freie Zusatzangabe des Aufrufers

	SECTab();

// Umsetzung
protected:
	~SECTab();

#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif
};


/////////////////////////////////////////////////////////////////////////////
// SECTabControlBase  (tabctrlb.h:74)
//
// Das nackte Reiterfenster ohne Zeichenverhalten: es fuehrt die Liste, kennt
// den aktiven Reiter und meldet Wechsel per TCM_TABSEL an sein
// Elternfenster. Alles Sichtbare steckt in SEC3DTabControl.

class SECTabControlBase : public CWnd
{
	DECLARE_DYNAMIC(SECTabControlBase);

// Konstruktion
public:
	SECTabControlBase();
	~SECTabControlBase();

// Ueberschreibbares
	virtual BOOL Create(DWORD dwStyle, const RECT& rect, CWnd* pParentWnd, UINT nID);
	virtual void Initialize(DWORD dwStyle);
	virtual SECTab* CreateNewTab() const;
	virtual void RecalcLayout();
	virtual void OnActivateTab(int nTab);
	virtual void DestroyGDIObjects(){ /* Platzhalter, gefuellt von SEC3DTabControl */ }

public:

// Operationen
	virtual SECTab* InsertTab(int nIndex,
							  LPCTSTR lpszLabel = NULL,
							  CObject *pClient = NULL,
							  HMENU hMenu = 0,
							  void* pExtra = NULL);
	virtual SECTab* AddTab(LPCTSTR lpszLabel = NULL,
						   CObject* pClient = NULL,
						   HMENU hMenu = 0,
						   void* pExtra = NULL);
	virtual void SetTabIcon(int nIndex, HICON hIcon);
	virtual void SetTabIcon(int nIndex, UINT nIDIcon);
	virtual void SetTabIcon(int nIndex, LPCTSTR lpszResourceName);
	virtual void DeleteTab(int nTab);
	virtual void RenameTab(int nTab, LPCTSTR lpszLabel);
	virtual void ActivateTab(int nTab);		// der Reiter, der obenauf liegt
	virtual void SelectTab(int nTab);
	virtual void ClearSelection();
	virtual void ScrollToTab(int nTab);
	virtual void InvalidateTab(int nTab);

// Abfragen
	int GetTabCount() const;
	BOOL GetTabInfo(int nTab, LPCTSTR& lpszLabel, BOOL& bSelected,
				CObject*& pClient, HMENU& hMenu, void*& pExtra) const;
	BOOL FindTab(const CObject* const pClient, int& nTab) const;
	BOOL GetActiveTab(int& nTab) const;
	BOOL TabExists(CObject* pClient) const;
	BOOL TabExists(int nTab) const;

// Umsetzung
protected:
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

	CObArray *m_pTabArray;
	int m_nActiveTab;
	BOOL m_bActiveTab;
	HCURSOR m_hcurArrow;

	SECTab& GetTab(int nTab) const;
	SECTab* GetTabPtr(int nTab) const;

	// ZUGABE der Ersatzschicht (im Original nicht vorhanden): setzt den
	// aktiven Reiter ohne OnActivateTab und ohne TCM_TABSEL. Gebraucht beim
	// Einfuegen und Loeschen, wo der Index sich verschiebt, ohne dass ein
	// Wechsel stattgefunden haette - sonst bekaeme CWazooBar bei jedem
	// Umsortieren einen falschen Reiterwechsel gemeldet.
	void SetActiveTabQuiet(int nTab);

	// Nachrichtenbehandlung
protected:
	//{{AFX_MSG(SECTabControlBase)
	afx_msg void OnDestroy();
	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP();
};

// Waechter des ersetzten Originalheaders setzen
#define __TABCTRLB_H__


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// 2. SECTabWndBase   (Original: tabwndb.h)
//
/////////////////////////////////////////////////////////////////////////////

// Fensterkennungen, wortgleich tabwndb.h:35-39
#define SEC_IDW_TABCTRL                 0xEA30
#define SEC_IDW_TABCLIENT_FIRST         0xEB00  // hoechstens 256 Reiter
#define SEC_IDW_TABCLIENT_LAST          0xEBff
#define SEC_IDW_HORZ_SCROLLBAR          0xEC00
#define SEC_IDW_VERT_SCROLLBAR          0xECff

// Vorgabestil der Reiterinhalte, wortgleich tabwndb.h:42
#define SEC_WS_DEFAULT_TABCLIENT	(WS_CHILD | WS_VISIBLE)

// Der Rahmen um den Inhaltsbereich, in Pixeln. ZUGABE der Ersatzschicht:
// SEC3DTabWnd::GetInsideRect und SEC3DTabWnd::OnPaint muessen denselben Wert
// benutzen, sonst zeichnet der eine ueber das, was der andere freihaelt.
// QC3DTabWnd::RecalcLayout rechnet fuer den Fall "Reiter versteckt" mit
// 4 Pixeln oben/unten und 6 bzw. 7 links/rechts (QC3DTabWnd.cpp:583-586);
// 3 liegt nahe genug, dass beide Faelle gleich aussehen.
#define OTSHIM_REITER_RAHMEN	3

class SECTabWndBase : public CWnd
{
	DECLARE_DYNAMIC(SECTabWndBase)

// Konstruktion
public:
	SECTabWndBase();
	virtual ~SECTabWndBase();

	virtual BOOL Create(LPCTSTR lpszClassName,
		LPCTSTR lpszWindowName, DWORD dwStyle,
		const RECT& rect,
		CWnd* pParentWnd, UINT nID,
		CCreateContext* pContext = NULL);

	virtual BOOL Create(CWnd* pParentWnd, DWORD dwStyle = WS_CHILD | WS_VISIBLE |
			WS_HSCROLL | WS_VSCROLL, UINT nID = AFX_IDW_PANE_FIRST);

protected:
	CWnd* CreateView(CRuntimeClass* pViewClass,
			 CCreateContext* pContext = NULL, UINT nID = -1);
	virtual BOOL CreateScrollBarCtrl(DWORD dwStyle, UINT nID);
	virtual BOOL CreateTabCtrl(DWORD dwStyle, UINT nID);

public:

// Operationen
	virtual SECTab* InsertTab(CWnd* pWnd,
							  int nIndex,
							  LPCTSTR lpszLabel);
	virtual SECTab* InsertTab(CRuntimeClass* pViewClass,
							  int nIndex,
							  LPCTSTR lpszLabel,
							  CCreateContext* pContext = NULL,
							  UINT nID = -1);
	virtual SECTab* AddTab(CWnd* pWnd,
						   LPCTSTR lpszLabel);
	virtual SECTab* AddTab(CRuntimeClass* pViewClass,
						   LPCTSTR lpszLabel,
						   CCreateContext* pContext = NULL,
						   UINT nID = -1);
	virtual void SetTabIcon(int nIndex, HICON hIcon);
	virtual void SetTabIcon(int nIndex, UINT nIDIcon);
	virtual void SetTabIcon(int nIndex, LPCTSTR lpszResourceName);
	virtual void SetScrollStyle(int nIndex, DWORD dwStyle);
	virtual void RemoveTab(CWnd* pWnd);
	virtual void RemoveTab(int nIndex);
	virtual void RenameTab(CWnd* pWnd, LPCTSTR lpszLabel);
	virtual void RenameTab(int nIndex, LPCTSTR lpszLabel);
	virtual void ActivateTab(CWnd* pWnd, int nIndex);
	virtual void ActivateTab(CWnd* pWnd);
	virtual void ActivateTab(int nIndex);
	virtual void ClearSelection();
	virtual void ScrollToTab(CWnd* pWnd);
	virtual void ScrollToTab(int nIndex);

// Abfragen
	int GetTabCount();
	BOOL GetTabInfo(int nIndex, LPCTSTR& lpszLabel, BOOL& bSelected, CWnd*& pWnd, void*& pExtra);
	BOOL FindTab(const CWnd* const pWnd, int& nTab) const;
	BOOL GetActiveTab(CWnd*& pWnd);
	BOOL GetActiveTab(int& nIndex);
	BOOL TabExists(CWnd* pClient);
	BOOL TabExists(int nTab);

// Umsetzung
protected:
	SECTabControlBase *m_pTabCtrl;
	CWnd* m_pActiveWnd;
	CWnd* m_pWndCreating;

	// ZUGABE der Ersatzschicht: die Fenster, die dieses Fenster SELBST
	// erzeugt hat (Weg ueber CreateView). Nur diese duerfen beim Entfernen
	// eines Reiters zerstoert werden. Eudora geht den anderen Weg - es
	// uebergibt fertige CWazooWnd - und zerstoert sie selbst
	// (WazooBar.cpp:1218-1220). Wuerde hier pauschal zerstoert, liefe
	// CWazooBar::OnDestroy auf freigegebenen Zeigern.
	CPtrArray m_arrEigeneFenster;

	virtual void GetInsideRect(CRect& rect) const;
	virtual void RecalcLayout();

	// ZUGABE der Ersatzschicht: Fensterwechsel ohne Rueckmeldung an das
	// Steuerelement. Trennt den sichtbaren Teil (altes Fenster verstecken,
	// neues zeigen) von der Reiterumschaltung und verhindert damit den
	// Ringlauf ActivateTab -> TCM_TABSEL -> OnTabSelect -> ActivateTab.
	void ZeigeInhaltsfenster(int nIndex);
	CWnd* HoleInhaltsfenster(int nIndex) const;

	// Nachrichtenbehandlung
protected:
	//{{AFX_MSG(SECTabWndBase)
	afx_msg void OnDestroy();
	afx_msg LRESULT OnTabSelect(WPARAM wParam, LPARAM lParam);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP();
};

// C-Funktion, wortgleich tabwndb.h:133
SECTabWndBase* GetParentTabWnd(const CWnd* const pWnd);

// Waechter des ersetzten Originalheaders setzen
#define __TABWNDB_H__


/////////////////////////////////////////////////////////////////////////////
// Die beiden 2D-Header im Original nachziehen.
//
// tabwnd.h liefert die TWS_*-Konstanten, die QC3DTabWnd.cpp:418-471 braucht,
// und zieht dabei tabctrl.h mit. Beide setzen ihre Waechter selbst, secall.h
// ueberspringt sie danach. Die darin deklarierten Klassen SECTabControl,
// SECTabWnd und SEC2DTabWnd bleiben ohne Rumpf - Eudora erzeugt sie nirgends
// (geprueft: kein Treffer in Eudora/*.cpp und Eudora/*.h), es entsteht also
// weder eine vtable noch ein offener Verweis beim Binden.

#ifndef __TABWND_H__
#include "tabwnd.h"
#endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// 3. SEC3DTab und SEC3DTabControl   (Original: tabctrl3.h)
//
/////////////////////////////////////////////////////////////////////////////

// Feldindizes der GDI-Objekte, wortgleich tabctrl3.h:40-41
#define SEC3DTAB_INACTIVE	0
#define SEC3DTAB_ACTIVE		1


/////////////////////////////////////////////////////////////////////////////
// SEC3DTab  (tabctrl3.h:46)
//
// m_rect und m_hIcon liest Eudora direkt (QC3DTabWnd.cpp:58 ueber GetTabPtr,
// :152 ueber TabHit). m_rect ist der Reiter in Clientkoordinaten des
// Steuerelements und wird von SEC3DTabControl::RecalcLayout gefuellt.
//
// Der HICON gehoert dem Aufrufer. Eudora reicht CWazooWnd::GetTabIconHandle
// herein (WazooBar.cpp:177); die Ersatzschicht zerstoert ihn deshalb nie.

class SEC3DTab : public SECTab
{
	DECLARE_DYNAMIC(SEC3DTab);

public:
	SEC3DTab();

// Attribute
public:
	CRect m_rect;
	HICON m_hIcon;
	BOOL m_bEnabled;

// Umsetzung
protected:
	~SEC3DTab();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif
};


/////////////////////////////////////////////////////////////////////////////
// SEC3DTabControl  (tabctrl3.h:72)
//
// Der zeichnende Teil. Waagerechte Anordnung (oben/unten): die Reiter liegen
// nebeneinander und fuellen die Hoehe des Steuerelements. Senkrechte
// Anordnung (links/rechts): die Reiter liegen untereinander und fuellen die
// Breite. Die Beschriftung bleibt in beiden Faellen waagerecht - gedrehte
// Schriften braeuchte man nur fuer ein Aussehen, das laut Auftrag nicht
// gefordert ist.

class SEC3DTabControl : public SECTabControlBase
{
	DECLARE_DYNAMIC(SEC3DTabControl);

// Konstruktion
public:
	SEC3DTabControl();
	~SEC3DTabControl();

// Ueberschreibungen
	virtual void Initialize(DWORD dwStyle);
	virtual SECTab* CreateNewTab() const;
	virtual void RecalcLayout();
	virtual void InitializeFonts(DWORD dwStyle);
	virtual void OnActivateTab(int nTab);
	virtual void DestroyGDIObjects();

#ifdef WIN32
	virtual int OnToolHitTest(CPoint point, TOOLINFO* pTI) const;
#endif

// Operationen

	// Schriftunterstuetzung
	BOOL SetFontActiveTab(CFont* pFont,BOOL bRedraw=TRUE)
		{ return SetFontTab(pFont,SEC3DTAB_ACTIVE,bRedraw); }
	BOOL SetFontInactiveTab(CFont* pFont,BOOL bRedraw=TRUE)
		{ return SetFontTab(pFont,SEC3DTAB_INACTIVE,bRedraw); }
	CFont* GetFontActiveTab() 				{ return &m_fonts[SEC3DTAB_ACTIVE]; }
	CFont* GetFontInactiveTab() 			{ return &m_fonts[SEC3DTAB_INACTIVE]; }
	virtual void ScrollToTab(int nTab);	// ABWEICHUNG: in tabctrl3.h nicht aufgefuehrt. Die Basisfassung kann nichts tun - sie kennt keine Reiterrechtecke -, also blieben WazooBar.cpp:409 und :1365 sonst wirkungslos.
	virtual void SetTabIcon(int nIndex, HICON hIcon);
	virtual void SetTabIcon(int nIndex, UINT nIDIcon);
	virtual void SetTabIcon(int nIndex, LPCTSTR lpszResourceName);
	virtual void InvalidateTab(int nTab);
	virtual void EnableTab(int nIndex, BOOL bEnable=TRUE);
	virtual BOOL IsTabEnabled(int nIndex);

#ifdef WIN32
	virtual BOOL ModifyStyle(DWORD dwRemove, DWORD dwAdd, UINT nFlags = 0);
#endif

	// ZUGABE der Ersatzschicht: die Dicke, die der Streifen braucht, damit
	// alle Reiter hineinpassen (Hoehe bei oben/unten, Breite bei
	// links/rechts). SEC3DTabWnd::RecalcLayout richtet sich danach.
	// Oeffentlich, weil SEC3DTabWnd nicht von dieser Klasse erbt.
	int OTShimStreifenDicke() const;

// Umsetzung
protected:
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

	// GDI-Objekte
	CFont m_fonts[2];
	CPen m_pens[2];
	CPen m_penShadow;
	CPen m_penWhite;
	CBrush m_brushes[2];
	COLORREF m_rgbText[2];
	int m_bShowTabLabels;	// Beschriftung anzeigen, weil alle Reiter passen
#ifdef WIN32
	CToolTipCtrl* m_pToolTip;
#endif
	virtual BOOL SetFontTab(CFont* pFont,int nTabType=SEC3DTAB_ACTIVE,BOOL bRedraw=TRUE);

// Abfragen
	BOOL TabHit(int nTab, CPoint& point) const;
	SEC3DTab& GetTab(int nTab);
	SEC3DTab* GetTabPtr(int nTab) const;
	virtual void GetTabRect(int nTab, CRect &tabRect) const;
	int GetLabelWidth(int nTab);

// Anordnung
	void SetTabPos(int nTab, int x, int y, DWORD dwStyle);

// Zeichnen
	virtual void DrawTab(CDC* pDC, int nTab);
	virtual void rgbFill(CDC* pDC,int x,int y,int cx,int cy, COLORREF rgb);
	virtual void DrawTabBottom(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle);
	virtual void DrawTabTop(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle);
	virtual void DrawTabLeft(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle);
	virtual void DrawTabRight(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle);
	virtual void DrawInterior(CDC* pDC, SEC3DTab* pTab, DWORD dwStyle);
	virtual void DrawDisabled(CDC* pDC, int nWidth, int nHeight);

	// ZUGABEN der Ersatzschicht
	DWORD m_dwTabStyle;		// Anordnung; im Original steckt sie im
							// Fensterstil, was mit den commctrl-Stilbits
							// kollidiert (siehe Kopf der Datei)
	int m_nScrollOffset;	// Verschiebung entlang der Anordnungsachse
	int m_nRowExtent;		// Dicke einer Reiterzeile in Pixeln
	int m_nStripExtent;		// Dicke, die der ganze Streifen braucht

	// Gemeinsamer Rumpf der vier DrawTabXxx: fuellt den Reiter und setzt die
	// 3D-Kanten. nOffeneSeite ist die dem Inhaltsbereich zugewandte Seite,
	// an der der aktive Reiter keine Kante bekommt, damit er mit dem Inhalt
	// verschmilzt.
	void ZeichneRahmen(CDC* pDC, SEC3DTab* pTab, int nOffeneSeite);
	enum { SEITE_OBEN = 0, SEITE_UNTEN, SEITE_LINKS, SEITE_RECHTS };

	BOOL IstWaagerecht() const
		{ return (m_dwTabStyle & (TCS_TABS_ON_LEFT | TCS_TABS_ON_RIGHT)) == 0; }

	// Nachrichtenbehandlung
protected:
	//{{AFX_MSG(SEC3DTabControl)
	afx_msg void OnDestroy();
	afx_msg void OnPaint();
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP();
};

// Waechter des ersetzten Originalheaders setzen
#define __TABCTRL3_H__


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// 4. SEC3DTabWnd   (Original: tabwnd3.h)
//
/////////////////////////////////////////////////////////////////////////////
//
// Der Rahmen um Streifen und Inhalt. Kinder sind das Steuerelement
// (Kennung SEC_IDW_TABCTRL, von QC3DTabWnd.cpp:597 ueber GetDlgItem gesucht)
// und die Inhaltsfenster; Eudora haengt seine CWazooWnd selbst hier ein
// (WazooBar.cpp:179  pWazooWnd->SetParent(&m_wndTab)).

class SEC3DTabWnd : public SECTabWndBase
{
	DECLARE_DYNCREATE(SEC3DTabWnd)

// Konstruktion
public:
	SEC3DTabWnd();
	virtual ~SEC3DTabWnd();

	// Ueberschreibt SECTabWndBase::Create(CWnd*,DWORD,UINT) - im Original
	// steht das Schluesselwort virtual hier nicht, die Methode ist es aber
	// geerbt. Eudora ruft sie mit den Vorgabewerten auf
	// (WazooBar.cpp:1163  m_wndTab.Create(this)).
	BOOL Create(CWnd* pParentWnd, DWORD dwStyle = WS_CHILD | WS_VISIBLE | TWS_TABS_ON_BOTTOM,
		UINT nID = AFX_IDW_PANE_FIRST);

protected:
	virtual BOOL CreateTabCtrl(DWORD dwStyle, UINT nID);

// Operationen
public:
	DWORD GetTabStyle() const { return m_dwTabCtrlStyle; }
	DWORD SetTabStyle(DWORD dwTabStyle);
	void EnableTab(CWnd* pWnd, BOOL bEnable = TRUE);
	void EnableTab(int nIndex, BOOL bEnable = TRUE);
	BOOL SetFontActiveTab(CFont* pFont,BOOL bRedraw=TRUE);
	BOOL SetFontInactiveTab(CFont* pFont,BOOL bRedraw=TRUE);
	CFont* GetFontActiveTab();
	CFont* GetFontInactiveTab();

// Attribute
	BOOL IsTabEnabled(CWnd* pWnd);
	BOOL IsTabEnabled(int nIndex);

// Umsetzung
private:
	void VLine3D(CDC* pDC, int x, int y, int nHeight);
	void HLine3D(CDC* pDC, int x, int y, int nWidth, BOOL bFlip = FALSE);

protected:
	int m_cyTabCtrl;
	int m_cxTabCtrl;
	DWORD m_dwTabCtrlStyle;

	void rgbFill(CDC* pDC,int x,int y,int cx,int cy, COLORREF rgb);
	void GetInsideRect(CRect& rect) const;
	virtual void RecalcLayout();

	// Nachrichtenbehandlung
protected:
	//{{AFX_MSG(SEC3DTabWnd)
	afx_msg void OnDestroy();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnPaint();
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg LRESULT OnTabSelect(WPARAM wParam, LPARAM lParam);
	afx_msg BOOL OnNcCreate(LPCREATESTRUCT lpcs);
	//}}AFX_MSG
	afx_msg void OnSysColorChange();
	DECLARE_MESSAGE_MAP();
};

// Waechter des ersetzten Originalheaders setzen
#define __TABWND3_H__


#endif // __OTSHIM_REITER_H__
