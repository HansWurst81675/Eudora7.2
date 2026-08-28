// OTShim.h - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1, Stufe 0
//
// Von OT501 liegen nur die Header unter Eudora71/OT501/Include vor; die
// Implementierung fehlt in der Freigabe (einzige Ausnahme: secaux.cpp).
// Diese Datei bildet die drei Elemente nach, die laut OTShim/PLAN.md
// "Stufe 0 - die geschenkten Klassen" ausmachen:
//
//   SECStatusBar            -> typedef auf CStatusBar
//   SECTipOfDay             -> Stub auf CDialog
//   SECLoadSysColorBitmap   -> CBitmap::LoadMappedBitmap
//
// Jede Abbildung ist unten an der Stingray-Headerzeile UND an der
// Eudora-Aufrufstelle belegt. Stufe 1 bis 4 (Workbook/MDI, Andockfamilie,
// Werkzeugleisten, Bilder) sind hier bewusst NICHT enthalten.
//
// EINBINDUNG
//   Diese Datei ersetzt Teile von OT501/Include - sie darf NICHT gemeinsam
//   mit den Originalheadern sbarstat.h, SECTOD.H und SECBTNS.H uebersetzt
//   werden, sonst gibt es doppelte Klassendefinitionen bzw. C2572
//   (Standardargument von SECLoadSysColorBitmap zweimal deklariert).
//   Eudora zieht alle SEC-Header ueber eine einzige Zeile herein:
//   Eudora/stdafx.h:52  #include "secall.h"
//   Dort ist spaeter der Umschaltpunkt. Diese Datei aendert nichts daran.
//
// Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

#ifndef __OTSHIM_H__
#define __OTSHIM_H__

#include <afxwin.h>		// CDialog, CBitmap, CWnd, CFont
#include <afxext.h>		// CControlBar, CStatusBar


/////////////////////////////////////////////////////////////////////////////
// 1. SECStatusBar
//
// BEFUND: sbarstat.h:43 deklariert
//
//     class SECStatusBar : public SECControlBar
//
// und ist ansonsten eine Kopie von CStatusBar aus afxext.h:269. Stingray
// selbst zieht diesen Schluss bereits: fuer Nicht-WIN32-Ziele steht in
// sbarstat.h:140 wortwoertlich
//
//     #define SECStatusBar CStatusBar
//
// (PLAN.md nennt dafuer 44 und 139 - beide Angaben sind um eine Zeile
// verschoben, der Inhalt stimmt.)
//
// Der Vergleich Member fuer Member gegen afxext.h aus MSVC 14.38.33130
// ergibt - alle afxext.h-Zeilen beziehen sich auf diese Fassung:
//
//   Stingray sbarstat.h            MFC afxext.h CStatusBar      Bewertung
//   ---------------------------    -------------------------    ---------
//   SECStatusBar()                 CStatusBar()                 gleich
//   BOOL Create(CWnd*,DWORD,UINT)  dito, aber virtual           s. (a)
//   -                              virtual BOOL CreateEx(...)   MFC-Zugabe
//   SetIndicators                  SetIndicators                gleich
//   -                              SetBorders x2                s. (b)
//   CommandToIndex/GetItemID/      identisch                    gleich
//     GetItemRect
//   GetPaneText x2, SetPaneText,   identisch                    gleich
//     Get/SetPaneInfo,
//     Get/SetPaneStyle
//   GetStatusBarCtrl()             identisch (derselbe          gleich
//                                  this-Cast-Trick)
//   virtual DrawItem               identisch                    gleich
//   CalcFixedLayout,               identisch                    gleich
//     PreCreateWindow,
//     AllocElements,
//     CalcInsideRect,
//     OnBarStyleChange,
//     OnUpdateCmdUI
//   _DEBUG: AssertValid, Dump,     identisch (beide lassen      gleich
//     EnableDocking                EnableDocking assertieren)
//   m_nMinHeight, _GetPanePtr,     identisch                    gleich
//     UpdateAllPanes,
//     OnChildNotify
//   OnNcHitTest -> UINT            OnNcHitTest -> LRESULT       s. (c)
//   OnSetText/OnGetText/           typisierte Handler           s. (c)
//     OnGetTextLength (WPARAM,
//     LPARAM)
//   OnNcCalcSize, OnNcPaint,       identisch                    gleich
//     OnPaint, OnSize,
//     OnWindowPosChanging,
//     OnSetMinHeight
//   SBPS_* Konstanten              identisch                    gleich
//
//   (a) SECStatusBar::Create ist nicht virtuell, CStatusBar::Create ist es.
//       Signatur und Standardargumente stimmen ueberein. Folge fuer Eudora:
//       CStatusBarEx::Create (statbar.h:20) wird zur echten Ueberschreibung
//       statt zur Verdeckung. Der einzige Aufruf geht ueber den konkreten
//       Typ (mainfrm.cpp:1657  m_wndStatusBar.Create(this)), also aendert
//       sich nichts.
//   (b) SetBorders steht bei Stingray eine Ebene tiefer: SECControlBar erbt
//       von CControlBar (sbarcore.h:118), und dort liegt SetBorders
//       (afxext.h:151-152). Ueber CStatusBar -> CControlBar (afxext.h:131)
//       ist es genauso erreichbar.
//   (c) Reine Implementierungsdetails der Message-Map, protected, von Eudora
//       nirgends aufgerufen.
//
// AUFRUFSTELLEN IN EUDORA (statbar.h:13  class CStatusBarEx : public
// SECStatusBar). Alle qualifizierten Aufrufe sind Kategorie A im Sinne von
// PLAN.md - geerbte MFC-Methoden, keine Stingray-Funktionalitaet:
//
//   statbar.cpp:73   BEGIN_MESSAGE_MAP(CStatusBarEx, SECStatusBar)
//   statbar.cpp:170  SECStatusBar::Create          -> CStatusBar
//   statbar.cpp:220  SECStatusBar::OnBarStyleChange-> CStatusBar
//   statbar.cpp:248  SECStatusBar::WindowProc      -> CControlBar (afxext.h:222)
//   statbar.cpp:714  SECStatusBar::OnTimer         -> CControlBar (afxext.h:242)
//   statbar.cpp:732  SECStatusBar::OnDestroy       -> CControlBar (afxext.h:244)
//   statbar.cpp:773  SECStatusBar::OnSize          -> CStatusBar
//   statbar.cpp:794  SECStatusBar::OnActivate      -> auskommentiert
//   statbar.cpp:871  SECStatusBar::OnEraseBkgnd    -> CWnd
//   statbar.cpp:889  SECStatusBar::OnLButtonDown   -> CControlBar (afxext.h:252)
//   statbar.cpp:897  SECStatusBar::OnLButtonDblClk -> CControlBar (afxext.h:253)
//   statbar.cpp:905  SECStatusBar::OnRButtonDown   -> CWnd
//
// Alles Weitere, was CStatusBarEx benutzt, ist ebenfalls reines MFC:
// SetIndicators, Get/SetPaneInfo, GetStatusBarCtrl, GetItemRect, SetBarStyle,
// ModifyStyle, EnableToolTips. Auch die Stellen ausserhalb von statbar.cpp
// fassen die Leiste nur als CControlBar an:
//   mainfrm.cpp:6556  ShowControlBar(&m_wndStatusBar, ...)
//   mainfrm.cpp:2967  SetPaneText / :6988 GetItemRect / :5589 IsVisible
//   QComApplication.cpp:292,308  Get/SetPaneText
// Der SEC-Leistenverwalter (SECControlBarManager) beruehrt die Statusleiste
// nirgends; SECStatusBar taucht ausserhalb von statbar.cpp/.h nicht auf.
//
// ERGEBNIS: der typedef stimmt. Keine abweichende Methode gefunden.
//
// EINSCHRAENKUNG: ein typedef ist kein Klassenname. RUNTIME_CLASS(SECStatusBar)
// und eine Vorwaertsdeklaration "class SECStatusBar;" waeren damit nicht mehr
// moeglich. Eudora braucht beides nicht.

typedef CStatusBar SECStatusBar;


/////////////////////////////////////////////////////////////////////////////
// 2. SECTipOfDay
//
// Original: SECTOD.H:41-99  class SECTipOfDay : public CDialog
//
// Der Dialog laedt Zeilen aus einer Textdatei (hier eudora.tip) und zeigt sie
// nacheinander an. Eudora leitet davon QCTipOfDayDlg ab (TipOfDayDlg.h:4).
// Einziger Einstiegspunkt ist CEudoraApp::OnTipOfTheDay (eudora.cpp:241-258):
//
//     QCTipOfDayDlg dlg(strTipFilename, ++nCurrentTip, nShowTipOfTheDay);
//     dlg.DoModal();
//     ::SetIniShort(IDS_INI_SHOW_TIP_OF_THE_DAY,   short(dlg.GetShowAtStartup()));
//     ::SetIniShort(IDS_INI_CURRENT_TIP_OF_THE_DAY, short(dlg.GetCurrentTip()));
//
// Es haengt nichts am Rueckgabewert von DoModal. Wichtig ist nur, dass die
// beiden Getter nach dem Aufruf plausible Werte liefern, denn sie werden
// unbesehen in die INI zurueckgeschrieben.
//
// WARUM STUB UND NICHT NACHBAU: die Dialogvorlage liegt in SECRES.RC, nicht
// in Eudoras Ressourcen - die Steuerelement-IDs IDC_TOD_OK_BUTTON (10940) bis
// IDC_TOD_GROUPBOX (10945) sind ausschliesslich in SECRES.H:45-50 definiert.
// Ohne Vorlage kann DoModal keinen Dialog erzeugen. Deshalb ueberschreibt der
// Stub DoModal und gibt IDOK zurueck, ohne ein Fenster anzulegen. Damit laeuft
// QCTipOfDayDlg::OnInitDialog gar nicht erst an, und dessen GetDlgItem-Aufrufe
// auf IDC_TOD_* (TipOfDayDlg.cpp:49,60) koennen nicht fehlschlagen.
//
// WAS EUDORA TATSAECHLICH BENUTZT (und was daher abgedeckt sein muss):
//   TipOfDayDlg.cpp:28   Konstruktor mit 5 Argumenten
//   TipOfDayDlg.cpp:13   BEGIN_MESSAGE_MAP(QCTipOfDayDlg, SECTipOfDay)
//                        -> braucht eine echte Klasse mit Message-Map
//   TipOfDayDlg.cpp:44   SECTipOfDay::OnInitDialog()
//   TipOfDayDlg.cpp:68   SetTipIcon(IDR_COMPMESS)
//   TipOfDayDlg.cpp:85   SetLeadInFont(&m_fontLeadIn)
//   TipOfDayDlg.cpp:89   SetTipFont(&m_fontTip)
//   eudora.cpp:254       DoModal()
//   eudora.cpp:256       GetShowAtStartup()
//   eudora.cpp:257       GetCurrentTip()
// Mehr nicht. GetCurrentFileName, SetCurrentTip, SetLeadInText und OnHelp sind
// nur der Vollstaendigkeit halber da, damit die Oberflaeche zu SECTOD.H passt.

#ifndef _MAX_TIP
#define _MAX_TIP 512			// wie SECTOD.H:39
#endif

class SECTipOfDay : public CDialog
{
	DECLARE_DYNAMIC(SECTipOfDay)

// Konstruktion
public:
	// Signatur exakt wie SECTOD.H:47-51. Der Konstruktor merkt sich die Werte,
	// mehr passiert im Stub nicht.
	SECTipOfDay(const TCHAR * lpszTipFileName,
		const TCHAR * didYouKnow,
		int nTip = 1,
		BOOL bShowAtStart = 1,
		CWnd* pParent = NULL);

	// SECTOD.H:52. Von Eudora nicht aufgerufen; verdeckt wie im Original die
	// beiden CDialog::Create-Ueberladungen.
	virtual BOOL Create();

// Operationen (SECTOD.H:55-64)
//
// Einzige Abweichung: die vier Abfragen sind hier const, im Original nicht.
// Beide Aufrufstellen (eudora.cpp:256-257) arbeiten auf einem nicht-const
// Objekt, das const stoert dort also nicht und macht die Absicht deutlicher.
public:
	// eudora.cpp:257 schreibt das Ergebnis in IDS_INI_CURRENT_TIP_OF_THE_DAY.
	// Der Stub liefert den uebergebenen Wert unveraendert zurueck; das
	// Original haette ihn nur veraendert, wenn der Anwender im Dialog
	// blaettert. UNGEPRUEFT: ob das Original beim Ueberlauf ueber die
	// Zeilenzahl der .tip-Datei auf 1 zuruecksetzt, laesst sich ohne die
	// Implementierung nicht sagen. Die INI-Zahl waechst dadurch bei jedem
	// Aufruf des Menuepunkts um eins (eudora.cpp:253  ++nCurrentTip).
	int      GetCurrentTip() const      { return m_nCurrentTip; }
	LPCTSTR  GetCurrentFileName() const { return m_lpTipFileName; }

	// eudora.cpp:256 schreibt das Ergebnis in IDS_INI_SHOW_TIP_OF_THE_DAY.
	// Ohne Dialog bleibt der Wert so, wie er aus der INI kam - die Einstellung
	// geht also nicht verloren.
	BOOL     GetShowAtStartup() const   { return m_bShowState; }

	void     SetCurrentTip(int nNewTip) { m_nCurrentTip = nNewTip; }

	// Ab hier No-Op: ohne Fenster gibt es nichts zu zeichnen. Die Werte werden
	// trotzdem abgelegt, damit ein spaeterer echter Nachbau sie vorfindet.
	// Aufrufstellen: TipOfDayDlg.cpp:68 (SetTipIcon), :85 (SetLeadInFont),
	// :89 (SetTipFont).
	void     SetTipIcon(UINT nNewIconID)      { m_nIconID = nNewIconID; }
	void     SetLeadInText(const TCHAR * lpNewLeadInText);
	void     SetLeadInFont(CFont * pNewLeadInFont) { m_pLeadInFont = pNewLeadInFont; }
	void     SetTipFont(CFont * pNewTipFont)       { m_pTipFont = pNewTipFont; }

// Ueberschreibbares
public:
	virtual void OnHelp() { return; }	// SECTOD.H:66, im Original ebenfalls leer

	// SECTOD.H:67 deklariert "virtual int OnInitDialog()", CDialog deklariert
	// BOOL. Unter MSVC ist BOOL ein int, beide Deklarationen bezeichnen also
	// dieselbe virtuelle Funktion. Hier wird CDialog gefolgt, damit die Kette
	// CDialog -> SECTipOfDay -> QCTipOfDayDlg (TipOfDayDlg.h:20) sauber bleibt.
	virtual BOOL OnInitDialog();

	// Nicht in SECTOD.H - der Stub kommt ohne Dialogvorlage aus und muss
	// deshalb verhindern, dass CDialog::DoModal auf eine leere Vorlage laeuft.
	// Rueckgabe IDOK gemaess PLAN.md, Stufe 0. Aufrufstelle eudora.cpp:254
	// wertet den Wert nicht aus.
	virtual INT_PTR DoModal();

// Implementierung (Feldsatz wortgleich zu SECTOD.H:70-82)
protected:
	BOOL          m_bShowState;
	int           m_nCurrentTip;
	int           m_nTipsInFile;
	const TCHAR * m_lpTipFileName;
	TCHAR         m_szCurrentTip[_MAX_TIP];
	CRect         m_rectTip;

	// Anpassbare Werte
	TCHAR *       m_lpLeadInText;
	CFont *       m_pTipFont;
	CFont *       m_pLeadInFont;
	UINT          m_nIconID;

public:
	virtual ~SECTipOfDay();

	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// 3. SECLoadSysColorBitmap
//
// Original: SECBTNS.H:340
//
//     extern BOOL SECLoadSysColorBitmap(CBitmap& bmp, LPCTSTR lpszName,
//                                       bool bToolbar = false);
//
// Laedt eine Bitmap-Ressource und tauscht dabei die Graustufen gegen die
// aktuellen Systemfarben aus - genau das, was CBitmap::LoadMappedBitmap ueber
// die Comctl32-Funktion CreateMappedBitmap tut.
//
// AUFRUFSTELLEN (beide uebergeben MAKEINTRESOURCE und bToolbar == FALSE):
//   AdView.cpp:350
//     VERIFY(SECLoadSysColorBitmap(m_BlankTimeBitmap,
//                                  MAKEINTRESOURCE(IDB_AD_BLANK_TIME), FALSE));
//     Der Rueckgabewert steht in einem VERIFY, muss also im Erfolgsfall TRUE
//     sein. Der Aufrufer ruft davor selbst DeleteObject (AdView.cpp:349), weil
//     die Funktion bei jedem WM_SYSCOLORCHANGE erneut laeuft (AdView.cpp:355).
//   PaymentAndRegistrationDlg.cpp:210
//     SECLoadSysColorBitmap(bitmapMember, MAKEINTRESOURCE(nBitmapIDResource),
//                           FALSE);
//     Ergebnis geht an CButton::SetBitmap (Zeile 214).
//
// UNGEPRUEFT: was bToolbar im Original umschaltet, ist nicht belegbar - die
// Implementierung fehlt und der Header sagt nichts dazu. Vermutlich waehlt es
// zwischen zwei Farbtabellen. Da beide Aufrufstellen FALSE uebergeben, ist der
// Fall ohne Bedeutung; der Parameter wird hier ignoriert. Sollte Stufe 3
// (Werkzeugleisten) eine Stelle mit TRUE nachliefern, muss das nachgezogen
// werden.
//
// UNGEPRUEFT: LoadMappedBitmap benutzt die Standardfarbtabelle von
// CreateMappedBitmap (Dunkelgrau/Grau/Weiss auf COLOR_3DSHADOW/-FACE/
// -HIGHLIGHT). Ob Stingray zusaetzlich Schwarz auf COLOR_BTNTEXT abbildet,
// wie es MFCs internes AfxLoadSysColorBitmap tut, ist nicht feststellbar.

inline BOOL SECLoadSysColorBitmap(CBitmap& bmp, LPCTSTR lpszName,
                                  bool /*bToolbar*/ = false)
{
	// Beide Aufrufstellen benutzen MAKEINTRESOURCE, also eine als Zeiger
	// verpackte Zahl. CBitmap::LoadMappedBitmap nimmt nur eine UINT-ID
	// entgegen, deshalb hier zurueckverwandeln. Ein echter Ressourcenname
	// als Zeichenkette kaeme mit dieser Abbildung nicht durch - er kommt in
	// Eudora aber auch nicht vor.
	ASSERT(IS_INTRESOURCE(lpszName));
	if (!IS_INTRESOURCE(lpszName))
		return FALSE;

	// Bewusste Abweichung vom Header: vorhandenes Handle vorher freigeben.
	// LoadMappedBitmap ruft intern Attach, und Attach assertiert auf einem
	// belegten CBitmap. AdView.cpp:349 macht das schon selbst,
	// PaymentAndRegistrationDlg.cpp:210 nicht - dort ist es nur deshalb
	// unkritisch, weil jedes Ziel ein frisches Feld des Dialogs ist.
	if (bmp.GetSafeHandle() != NULL)
		bmp.DeleteObject();

	return bmp.LoadMappedBitmap(static_cast<UINT>(reinterpret_cast<UINT_PTR>(lpszName)));
}



/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// STUFE 1 - MDI-FENSTERGERUEST (OTShim/PLAN.md, "Stufe 1 - MDI ohne
// Registerkarten")
//
// Ersetzt die beiden Originalheader
//
//     OT501/Include/swinmdi.h   SECMDIFrameWnd, SECMDIChildWnd,
//                               SECControlBarMDIChildWnd
//     OT501/Include/SECWB.H     SECWorksheet, SECWorkbookClient,
//                               SECWorkbook, SECControlBarWorksheet
//
// GRUNDENTSCHEIDUNG: m_bWorkbookMode bleibt fest FALSE. Damit laeuft der
// gesamte selbstgemalte Registerkartenstreifen ("Auto-Wazoo") nie an. Jede
// Auswertung in Eudora steht hinter dieser Abfrage:
//     workbook.cpp:1065, 1101, 1185, 1741, 1851
//     mainfrm.cpp:8438, 8484, 8549, 8654
// Der Zustand ist von Qualcomm vorgesehen und ueber die Einstellungen
// erreichbar (settings.cpp:1055-1061 -> QCWorkbook::ShowMDITaskBar).
//
// DIE KLASSENKETTE BLEIBT VOLLSTAENDIG. Eudora springt an fuenf Stellen
// bewusst ueber eine Vererbungsebene hinweg; faellt eine Zwischenklasse weg,
// landet der Aufruf still bei der falschen Implementierung:
//     workbook.cpp:133   SECMDIChildWnd::OnMDIActivate  (aus QCWorksheet)
//     workbook.cpp:295   SECWorksheet::RecalcLayout     (aus QCControlBarWorksheet)
//     workbook.cpp:361   SECMDIChildWnd::OnMDIActivate  (aus QCControlBarWorksheet)
//     workbook.cpp:521   SECWorksheet::OnClose          (aus QCControlBarWorksheet)
//     workbook.cpp:1165  SECMDIFrameWnd::OnLButtonDown  (aus QCWorkbook)
// Alle fuenf Ziele sind Kategorie A im Sinne von PLAN.md - geerbte
// MFC-Methoden, die nur ueber die richtige Klasse erreichbar sein muessen:
//     SECMDIChildWnd::OnMDIActivate -> CMDIChildWnd::OnMDIActivate (afxwin.h:4502)
//     SECWorksheet::RecalcLayout    -> CFrameWnd::RecalcLayout
//     SECWorksheet::OnClose         -> CWnd::OnClose               (afxwin.h:2741)
//     SECMDIFrameWnd::OnLButtonDown -> CWnd::OnLButtonDown         (afxwin.h:2838)
// Deshalb werden diese vier hier NICHT deklariert - eine eigene Deklaration
// wuerde die geerbte Methode verdecken und das Verhalten aendern.
//
// EINBINDUNG
//   Wie die Originale braucht dieser Abschnitt afxpriv.h (wegen CDockBar),
//   swinfrm.h (SECFrameWnd, SECDockState, SECControlBarManager) und
//   sbardock.h (SECDockBar - Datenmember von SECControlBarWorksheet).
//   swinfrm.h und sbardock.h gehoeren zur Andockfamilie und damit zu Stufe 2;
//   bis dahin liefern die Originalheader unter OT501/Include die
//   Deklarationen. Der Suchpfad muss OT501/Include enthalten.
//
//   Am Ende dieses Abschnitts werden die Includewaechter __SWINMDI_H__ und
//   __SECWB_H__ der Originale gesetzt, damit ein spaeteres
//   #include "secall.h" die ersetzten Dateien ueberspringt (SECALL.H:131
//   zieht secwb.h herein, SECWB.H:19 wiederum swinmdi.h).

#if defined(__SWINMDI_H__) || defined(__SECWB_H__)
#error OTShim.h ersetzt swinmdi.h und SECWB.H - diese duerfen vorher nicht eingebunden sein.
#endif

#ifndef __AFXPRIV_H__
#include <afxpriv.h>		// CDockBar, wie sbardock.h:22
#endif

#ifndef __SWINFRM_H__
#include "swinfrm.h"		// SECFrameWnd; Vorwaertsdeklarationen
#endif						// SECDockState, SECControlBarManager (swinfrm.h:44-45)

#ifndef __SBARDOCK_H__
#include "sbardock.h"		// SECDockBar (sbardock.h:48), SECMiniDockFrameWnd
#endif


// Sammelmeldung fuer alles, was ein Anwender ueber die Oberflaeche ausloesen
// kann, das aber erst eine spaetere Stufe umsetzt. Jede Fundstelle bringt ihr
// eigenes statisches Flag mit, meldet sich also hoechstens einmal pro Sitzung.
void OTShimNichtUmgesetzt(BOOL& rbBereitsGemeldet, LPCTSTR lpszWas);


class SECWorkbook;
class SECWorksheet;


/////////////////////////////////////////////////////////////////////////////
// 4. SECMDIFrameWnd  (Original: swinmdi.h:53)
//
// Basis der gesamten Hauptfensterkette:
//     CMDIFrameWnd -> SECMDIFrameWnd -> SECWorkbook -> QCWorkbook
//                  -> CMainFrame (mainfrm.h:159)
//
// Der Feldsatz ist wortgleich uebernommen, weil Eudora zwei der geschuetzten
// Felder direkt liest:
//     mainfrm.cpp:832   SECDockState state(m_pControlBarManager);
//     mainfrm.cpp:2161  dwSECDockBarMap[i][1] ... :2163, :2168
// und eines schreibt:
//     workbook.cpp:667  ASSERT(m_pFloatingMDIChildClass == RUNTIME_CLASS(SECControlBarWorksheet));
//     workbook.cpp:668  m_pFloatingMDIChildClass = RUNTIME_CLASS(QCControlBarWorksheet);
// Der Konstruktor muss den geforderten Vorgabewert also wirklich setzen.

class SECMDIFrameWnd : public CMDIFrameWnd
{
	DECLARE_DYNCREATE(SECMDIFrameWnd)

protected:
	SECMDIFrameWnd();

// Attribute (swinmdi.h:61-72, Reihenfolge und Sichtbarkeit unveraendert)
protected:
	CRect m_prevLayout;					// nur Vererbungskette; SEC-Zeichencode
	CRuntimeClass* m_pFloatingMDIChildClass;	// workbook.cpp:667,668
	static const DWORD dwSECDockBarMap[4][2];	// mainfrm.cpp:2161,2163,2168
	CPoint m_ptDefaultMDIPos;			// nur Vererbungskette
	SECFrameWnd* m_pActiveDockableFrame;	// nur Vererbungskette
	SECControlBarManager* m_pControlBarManager;	// mainfrm.cpp:817,832

	// Farbverlauf-Titelzeile. Von Eudora nirgends benutzt; nur wegen der
	// Vererbungskette und der Vollstaendigkeit uebernommen.
	UINT m_uiTextAlign;
	BOOL m_bNullGetText;
	BOOL m_bHandleCaption;

// Operationen (swinmdi.h:75-123)
public:
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

	// mainfrm.cpp:2173  QCWorkbook::EnableDocking(dwDockStyle)
	// Nicht virtuell - genau wie CFrameWnd::EnableDocking (afxwin.h:4183) und
	// wie das Original. CMainFrame::EnableDocking (mainfrm.cpp:2156) verdeckt
	// beide und ruft diese Fassung ausdruecklich auf.
	void EnableDocking(DWORD dwDockStyle);

	// AdWazooBar.cpp:176,212; mainfrm.cpp:965; WazooBarMgr.cpp:242,366,375,425
	virtual void DockControlBarEx(CControlBar* pBar, UINT nDockBarID = 0,
		int nCol = 0, int nRow = 0, float fPctWidth = (float)1.0, int nHeight = 150);

	// QUALCOMM-Aenderung im Original: virtuell gemacht.
	// mainfrm.cpp:6458 (CMainFrame::FloatControlBar, mainfrm.h:267);
	// QCCustomizeToolBar.cpp:266 ueber SECMDIFrameWnd*
	virtual void FloatControlBar(CControlBar* pBar, CPoint point, DWORD dwStyle = CBRS_ALIGN_TOP);

	// Verdeckt CFrameWnd::DockControlBar (afxwin.h:4184). Nur wegen der
	// Vererbungskette; Eudora ruft die Fassung mit CDockBar* auf (s. unten).
	void DockControlBar(CControlBar* pBar, UINT nDockBarID = 0,
		LPCRECT lpRect = NULL);
	void ReDockControlBar(CControlBar* pBar, CDockBar* pDockBar,
		LPCRECT lpRect = NULL);				// nur Vererbungskette

	// mainfrm.cpp:6499  QCWorkbook::ShowControlBar(pBar, bShow, bDelay)
	void ShowControlBar(CControlBar* pBar, BOOL bShow, BOOL bDelay);

	// Stufe 2: Leiste als eigenes MDI-Kindfenster schweben lassen
	// (Kommando ID_SEC_MDIFLOAT, SECRES.H:191). Von Eudora nicht direkt
	// aufgerufen, aber ueber das Kontextmenue der Leisten erreichbar.
	void FloatControlBarInMDIChild(CControlBar* pBar, CPoint point, DWORD dwStyle = CBRS_ALIGN_TOP);
	void ReFloatControlBar(CControlBar* pBar, CPoint point, DWORD dwStyle = CBRS_ALIGN_TOP);
	virtual CMDIChildWnd* CreateFloatingMDIChild(DWORD dwStyle, CControlBar* pBar = NULL);

	virtual void ActivateDockableFrame(SECFrameWnd* pFrameWnd);	// nur Vererbungskette
	virtual void OnActivateDockableFrame(SECFrameWnd* pFrame);	// nur Vererbungskette
	virtual void OnUpdateFrameTitle(BOOL bAddToTitle);			// nur Vererbungskette

	// workbook.cpp:1270,1371,1546,1750 ueber QCWorkbook; mainfrm.cpp:4394 u.a.
	virtual CFrameWnd* GetActiveFrame();

	// mainfrm.cpp:9566  LoadBarState(_T("ToolBar"))
	// mainfrm.cpp:2550,2769  QCWorkbook::SaveBarState(lpszProfileName)
	//                        (CMainFrame::SaveBarState, mainfrm.h:220, ist const)
	virtual void LoadBarState(LPCTSTR lpszProfileName);
	virtual void SaveBarState(LPCTSTR lpszProfileName) const;

	// mainfrm.cpp:934  SetDockState(state)
	virtual void SetDockState(SECDockState& state);
	virtual void GetDockState(SECDockState& state) const;		// nur Vererbungskette

	virtual SECControlBarManager* GetControlBarManager() const;
	virtual void SetControlBarManager(SECControlBarManager*);

	// Titelzeile: von Eudora nirgends aufgerufen, nur Oberflaechentreue.
	BOOL IsCustomCaptionEnabled() const
		{ return m_bHandleCaption; }
	BOOL EnableCustomCaption(BOOL bEnable, BOOL bRedraw = TRUE);
	void ForceCaptionRedraw();

	enum AlignCaption { acLeft, acCenter, acRight };
	AlignCaption GetCaptionTextAlign() const
		{ return (AlignCaption)m_uiTextAlign; }
	void SetCaptionTextAlign(AlignCaption ac, BOOL bRedraw = TRUE);

// Ueberschreibungen (swinmdi.h:127-129)
	virtual void OnSetPreviewMode(BOOL bPreview, CPrintPreviewState* pState);

// Nachrichtenbehandlung (swinmdi.h:132-134)
protected:
	// mainfrm.cpp:1580  QCWorkbook::OnSysColorChange()
	afx_msg void OnSysColorChange();
	// UNGEPRUEFT: an welche Nachricht das Original OnExtendContextMenu bindet,
	// ist weder aus swinmdi.h noch aus Eudora belegbar (SEC-eigene registrierte
	// Nachricht). Deklariert, aber nicht in die Nachrichtentabelle eingetragen.
	afx_msg LRESULT OnExtendContextMenu(WPARAM wParam, LPARAM lParam);

// Umsetzung (swinmdi.h:137-165)
protected:
	void GetWindowsVersion();
	BOOL m_bIsWin95orAbove;

	virtual ~SECMDIFrameWnd();

public:
	// mainfrm.cpp:892  DockControlBar(m_pSearchBar, static_cast<CDockBar*>(NULL), &rectSearchBar)
	void DockControlBar(CControlBar* pBar, CDockBar* pDockBar,
		LPCRECT lpRect = NULL);
	// mainfrm.cpp:5661,5717; workbook.cpp:734,963
	virtual void RecalcLayout(BOOL bNotify = TRUE);
	// mainfrm.cpp:3135  QCWorkbook::OnCmdMsg(...)
	virtual BOOL OnCmdMsg(UINT nID, int nCode, void* pExtra,
		AFX_CMDHANDLERINFO* pHandlerInfo);
	virtual void OnUpdateFrameMenu(HMENU hMenuAlt);		// nur Vererbungskette

protected:
	// mainfrm.cpp:3077  QCWorkbook::OnCommand(wParam, lParam)
	virtual BOOL OnCommand(WPARAM wParam, LPARAM lParam);

	// mainfrm.cpp:8734  QCWorkbook::OnNcActivate(bActive)
	afx_msg BOOL OnNcActivate(BOOL bActive);
	afx_msg void OnNcPaint();							// nur Vererbungskette
	afx_msg void OnActivateApp(BOOL bActive, DWORD dwThreadID);	// nur Vererbungskette
	afx_msg void OnParentNotify(UINT message, LPARAM lParam);	// nur Vererbungskette
	// workbook.cpp:1901  SECWorkbook::OnActivate(...) - SECWB.H deklariert
	// kein OnActivate, der Aufruf landet hier.
	afx_msg void OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized);

	// Die drei sind im Original die Farbverlauf-Titelzeile. Ohne diese
	// Zeichnerei haben sie nichts zu tun; sie bleiben deklariert, damit die
	// Oberflaeche stimmt, und stehen nicht in der Nachrichtentabelle.
	afx_msg LRESULT OnGetText(WPARAM wParam, LPARAM lParam);
	afx_msg LRESULT OnSetText(WPARAM wParam, LPARAM lParam);
	afx_msg LRESULT OnCommandHelp(WPARAM wParam, LPARAM lParam);

	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// 5. SECMDIChildWnd  (Original: swinmdi.h:171)
//
// Leere Zwischenklasse. Sie bleibt erhalten, weil workbook.cpp:133 und :361
// ausdruecklich SECMDIChildWnd::OnMDIActivate aufrufen, um SECWorksheets
// eigene Fassung zu ueberspringen. Wuerde man sie einsparen, liefe der Aufruf
// still in SECWorksheet::OnMDIActivate - also genau in das, was Qualcomm
// umgehen will.
//
// OnMDIActivate wird hier NICHT deklariert; der Aufruf soll bei
// CMDIChildWnd::OnMDIActivate (afxwin.h:4502) landen.

class SECMDIChildWnd : public CMDIChildWnd
{
	DECLARE_DYNCREATE(SECMDIChildWnd)

protected:
	SECMDIChildWnd();

public:
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:
	virtual ~SECMDIChildWnd();

	// swinmdi.h:199-200. Von Eudora nicht aufgerufen; im Original
	// Aktivierungslogik der andockbaren Rahmen. Reiche an die Basis durch.
	afx_msg int OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest, UINT message);
	afx_msg void OnChildActivate();

	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// 6. SECWorksheet  (Original: SECWB.H:36)
//
// Jedes Dokumentfenster von Eudora ist ein Worksheet:
//     CMDIChildWnd -> SECMDIChildWnd -> SECWorksheet -> QCWorksheet
//                  -> CMDIChild (mdichild.h:14)
//
// Der Worksheet meldet sich beim Workbook an und wieder ab. Dass SECWorkbook
// die Klasse als friend fuehrt (SECWB.H:120) und AddSheet/RemoveSheet dort
// geschuetzt sind (SECWB.H:179,180), belegt genau diese Richtung.

class SECWorksheet : public SECMDIChildWnd
{
	friend class SECWorkbook;
	DECLARE_DYNCREATE(SECWorksheet);

// Konstruktion
public:
	SECWorksheet();

	// Von QUALCOMM nachtraeglich eingefuegte Zugriffsmethoden (SECWB.H:45-51).
	// IsSelected:  workbook.cpp:1270, 1371, 1546
	// SetSelected: workbook.cpp:1109
	// GetPosition: von Eudora nicht aufgerufen
	BOOL IsSelected() const
		{ return m_bSelected; }
	void SetSelected(BOOL bSelected)
		{ m_bSelected = bSelected; }
	int GetPosition() const
		{ return m_nPosition; }

// Umsetzung
protected:
	// m_hIcon MUSS geschuetzter Datenmember bleiben und darf keinen Setzer
	// bekommen: QCControlBarWorksheet::QCSetIcon schreibt ihn direkt
	// (workbook.cpp:276).
	HICON	m_hIcon;
	int		m_nPosition;	// Platz im Feld m_worksheets, von AddSheet gesetzt
	BOOL	m_bSelected;	// Registerkarte gewaehlt, Rahmen noch nicht aktiv

	// workbook.cpp:135, 363, 494
	SECWorkbook* GetWorkbook();

	// mdichild.cpp:50  QCWorksheet::LoadFrame(...)
	virtual BOOL LoadFrame(UINT nIDResource, DWORD dwDefaultStyle,
		CWnd* pParentWnd, CCreateContext* pContext = NULL);

	// Zugabe des Shims, nicht im Original: gemeinsame Anmeldung beim Workbook
	// fuer LoadFrame und SECControlBarWorksheet::OnCreateClient.
	void RegisterWithWorkbook();

public:
	virtual ~SECWorksheet();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

// Nachrichtenbehandlung
protected:
	// SECWB.H:74. workbook.cpp:133 und :361 umgehen diese Fassung bewusst.
	afx_msg void OnMDIActivate(BOOL bActivate, CWnd* pActivateWnd, CWnd* pDeactivateWnd);
	// SECWB.H:75. workbook.cpp:167  SECWorksheet::OnDestroy()
	afx_msg void OnDestroy();
	// SECWB.H:76. Von Eudora nicht aufgerufen; im Original Anlass, die
	// Registerkarte neu zu zeichnen.
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);

	DECLARE_MESSAGE_MAP();
};

// SECWB.H:81-84 stellt diese Methode ausserhalb von _DEBUG inline. Hier steht
// sie immer inline; die Debugfassung des Originals hat nur zusaetzlich
// geprueft.
inline SECWorkbook* SECWorksheet::GetWorkbook()
	{ return (SECWorkbook*)GetMDIFrame(); }


/////////////////////////////////////////////////////////////////////////////
// 7. SECWorkbookClient  (Original: SECWB.H:86)
//
// Huelle um das MDICLIENT-Fenster. Ihr einziger Zweck ist SetMargins: sie
// haelt am Rand des MDI-Bereichs Platz frei, in den SECWorkbook seine
// Registerkarten malt.
//
// WIE DIE RAENDER WIRKEN: CWnd::RepositionBars sucht das "left over"-Fenster
// ueber CWnd::FromHandle und ruft darauf die virtuelle CalcWindowRect
// (wincore.cpp:3252-3266 aus MSVC 14.38.33130). Ein Objekt, das im
// permanenten Fensterverzeichnis steht, bekommt damit seine Ueberschreibung
// wirklich zu sehen. Genau deshalb muss das Objekt real am Fenster haengen.
//
// ATTACH, NICHT SUBCLASSWINDOW - Begruendung:
//   mainfrm.cpp:1287-1294 (CMainFrame::CreateClient) macht nach dem Aufruf
//   der Basisfassung
//       ASSERT_VALID(m_pWBClient);
//       ASSERT(m_pWBClient->GetSafeHwnd() == m_hWndMDIClient);
//       m_pWBClient->Detach();          <-- Gegenstueck zu Attach
//       delete m_pWBClient;
//       m_pWBClient = DEBUG_NEW QCWorkbookClient();
//       m_pWBClient->SubclassWindow(m_hWndMDIClient);
//   Haette die Basisfassung selbst SubclassWindow benutzt, waere das zweite
//   SubclassWindow ein Fehler: CWnd::SubclassWindow prueft
//       ASSERT(oldWndProc != AfxGetAfxWndProc());
//   (wincore.cpp:4962) - und genau das waere der Fall, weil Detach die
//   Fensterprozedur nicht zuruecksetzt. In der Debugfassung, die hier gebaut
//   wird, schlaegt das an; zur Laufzeit ergaebe sich ausserdem eine
//   Endlosschleife ueber CWnd::DefWindowProc -> AfxWndProc -> WindowProc.
//   mainfrm.cpp:3280-3283 passt dazu: Eudora loest sein eigenes
//   SubclassWindow mit UnsubclassWindow wieder und haengt danach mit Attach
//   wieder ein - also in genau den Zustand, den die Basisfassung erzeugt hat
//   und in dem sie das Objekt spaeter wieder abraeumt.
//   Damit sind alle vier Zusicherungen von Eudora erfuellt und die Vorgabe
//   "das Objekt haengt real am Fenster" ebenfalls.
//
// Eudora leitet QCWorkbookClient davon ab (mainfrm.cpp:333).

class SECWorkbookClient : public CWnd
{
	DECLARE_DYNCREATE(SECWorkbookClient);

// Konstruktion
public:
	SECWorkbookClient();

// Operationen
public:
	// workbook.cpp:729; mainfrm.cpp:5660, 5716
	void SetMargins(int left, int right, int top, int bottom);
	// Von Eudora nicht aufgerufen; Gegenstueck zu SetMargins.
	void GetMargins(int& left, int& right, int& top, int& bottom);

// Umsetzung
protected:
	CRect m_margins;	// Abstand zwischen Rahmenrand und MDI-Bereich
	virtual void CalcWindowRect(LPRECT lpClientRect, UINT nAdjustType);

public:
	virtual ~SECWorkbookClient();
#ifdef _DEBUG
	virtual void AssertValid() const;	// mainfrm.cpp:1287, 3280
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:
	DECLARE_MESSAGE_MAP();
};


/////////////////////////////////////////////////////////////////////////////
// 8. SECWorkbook  (Original: SECWB.H:118)
//
// Das Hauptfenster. Alle Attribute sind oeffentlich wie im Original - Eudora
// liest und schreibt sie direkt:
//     m_cxFold, m_cxActive, m_cyActive, m_nMaxTabWidth  workbook.cpp:663-666
//     m_bWorkbookMode      workbook.cpp:723,786,957,1065,1101,1185,1613,
//                          1741,1851,1693,926; mainfrm.cpp:8438,8484,8549,8654
//     m_pWBClient          workbook.cpp:728,729,928,934,935,1009,1426,1428,
//                          1693,1795,1799; mainfrm.cpp:1287-1294,3280-3283,
//                          5660,5716
//     m_worksheets         workbook.cpp:1044,1046,1445,1447,1765,1767,1821,
//                          1823,1856,1858
//     m_cyTab              workbook.cpp:940
//     m_rectClientLast     workbook.cpp:961
//     m_fontTab            workbook.cpp:1374,1549
//     m_penFace/-Shadow/-Black  workbook.cpp:1282,1287,1293,1315,1326

class SECWorkbook : public SECMDIFrameWnd
{
	friend class SECWorksheet;
	DECLARE_DYNCREATE(SECWorkbook);

// Konstruktion
public:
	SECWorkbook();

// Attribute
public:

	CObArray m_worksheets;		// Liste der Worksheets
	BOOL	m_bWorkbookMode;	// bleibt in dieser Stufe fest FALSE
	BOOL	m_bShowIcons;		// Symbole auf den Registerkarten?
	CFont	m_fontTab;			// Schrift der Registerbeschriftung
	int		m_nScrollOffset;	// Verschiebung des Registerstreifens
	SECWorkbookClient* m_pWBClient;	// der MDI-Bereich
	CPen	m_penWhite, m_penBlack, m_penShadow, m_penFace;
	int		m_cxTab;			// Breite einer Registerkarte
	int		m_cyTab;			// Hoehe einer Registerkarte
	int		m_cxFold;			// Breite der Abschraegung
	int		m_cxActive;			// Zusatzbreite der aktiven Karte
	int		m_cyActive;			// Zusatzhoehe der aktiven Karte
	int		m_nMaxTabWidth;
	CRect	m_rectClientLast;	// Hinweis fuers Neuzeichnen

// Umsetzung
protected:

	// Die vier sind geschuetzt und werden von Eudora nicht aufgerufen -
	// QCWorkbook hat mit QCGetTabRect und QCInvalidateAllTabs eigene
	// Fassungen (workbook.cpp:745, 955). Sie bleiben, damit die Oberflaeche
	// stimmt.
	void GetTabRgn(SECWorksheet* pSheet, CRgn& rgn);
	void InvalidateTab(SECWorksheet* pSheet, BOOL bInvalidAfter = FALSE);
	void InvalidateAllTabs();
	// "Made virtual! SD 12/22/99" im Original; QCWorkbook ueberschreibt es
	// vollstaendig (workbook.cpp:999).
	virtual int recalcTabWidth();
	inline int GetIconWidth() { return m_cyTab-8; }

// Ueberschreibungen
public:
	// workbook.cpp:800  SECWorkbook::CreateClient(...) aus QCWorkbook,
	// das wiederum mainfrm.cpp:1285 aufruft. Hier entsteht m_pWBClient.
	virtual BOOL CreateClient(LPCREATESTRUCT lpCreateStruct, CMenu* pWindowMenu);
	// workbook.cpp:734, 963; mainfrm.cpp:5661, 5717
	virtual void RecalcLayout(BOOL bNotify = TRUE);

	// SECWB.H:161-167, nur unter WIN32. Kurzhinweise der Registerkarten.
protected:
	CToolTipCtrl* m_pToolTips;
public:
	// Im Original "virtual int"; MFC 14 deklariert
	// CWnd::OnToolHitTest als "virtual INT_PTR" (afxwin.h:2429). Unter Win32
	// ist INT_PTR gleich int, beide Deklarationen bezeichnen dieselbe
	// virtuelle Funktion. Hier wird MFC gefolgt, damit die Ueberschreibung
	// auch bei einer spaeteren 64-Bit-Portierung eine bleibt. Von Eudora
	// nicht ueberschrieben und nicht aufgerufen.
	virtual INT_PTR OnToolHitTest(CPoint point, TOOLINFO* pTI) const;

public:
	~SECWorkbook();
#ifdef _DEBUG
	virtual void AssertValid() const;		// mainfrm.cpp:2820
	virtual void Dump(CDumpContext& dc) const;	// mainfrm.cpp:2825
#endif

// Ueberschreibbares
protected:

	// workbook.cpp:1227, 1242 - reine Listenpflege ueber m_worksheets
	virtual void AddSheet(SECWorksheet* pSheet);
	virtual void RemoveSheet(SECWorksheet* pSheet);
	virtual BOOL IsFullTabTextVisible(SECWorksheet* pSheet);	// nur Oberflaeche
	// workbook.cpp:980 - siehe die Anmerkungen bei der Umsetzung
	virtual void GetTabPts(SECWorksheet* pSheet, CPoint*& pts, int& count);
	// workbook.cpp:1360, 1537, 1635
	virtual const TCHAR* GetTabLabel(SECWorksheet* pSheet) const;
	virtual BOOL GetTextRect(CPoint* pts, int ciIconWidth, CRect& rectText);	// nur Oberflaeche

	// Zeichen-Overridables. Bei m_bWorkbookMode == FALSE ruft OnPaint sie
	// nicht auf, es gibt also nichts zu zeichnen. Sie bleiben deklariert und
	// leer, weil QCWorkbook alle drei ueberschreibt (workbook.h:217-219) und
	// CMainFrame::OnDrawBorder (mainfrm.cpp:5772) an QCWorkbook::OnDrawBorder
	// weiterreicht - die Kette muss also durchgaengig sein.
	virtual void OnDrawTab(CDC* pDC, SECWorksheet* pSheet);
	virtual void OnDrawBorder(CDC* pDC);
	virtual void OnDrawTabIconAndLabel(CDC* pDC, SECWorksheet* pSheet);

// Operationen
public:

	// workbook.cpp:722  SetWorkbookMode(bShow) aus QCWorkbook::ShowMDITaskBar,
	// erreichbar ueber mainfrm.cpp:1025 (Start) und settings.cpp:1060
	// (Einstellung IDS_INI_MDI_TASKBAR).
	void SetWorkbookMode(BOOL bEnabled = TRUE);
	void SetShowIcons(BOOL bShowIcons = TRUE);		// von Eudora nicht aufgerufen
	// workbook.cpp:1355, 1582
	virtual HICON GetTabIcon(SECWorksheet* pSheet) const;
	virtual BOOL SetTabIcon(SECWorksheet* pSheet, HICON hIcon, BOOL bRedraw = TRUE);

// Abfragen
public:

	BOOL LookupSheet(SECWorksheet* pSheet, int& nIndex);	// nur Oberflaeche
	SECWorksheet* GetWorksheet(int nSheet) const;	// workbook.cpp:1047,1632,1703
	int GetSheetCount() const;						// workbook.cpp:1628,1701

// Nachrichtenbehandlung
protected:
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);	// mainfrm.cpp:1918
	afx_msg void OnPaint();					// mainfrm.cpp:1934
	// workbook.cpp:1095 ueberschreibt das vollstaendig und ruft statt dessen
	// SECMDIFrameWnd::OnLButtonDown auf (workbook.cpp:1165).
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);

	// UNGEPRUEFT: die vier Kommandobehandler des Originals haengen an
	// SEC-eigenen Menuebefehlen. In SECRES.H ist keine passende Kennung
	// enthalten (dort stehen nur ID_SEC_ALLOWDOCKING/-HIDE/-MDIFLOAT,
	// SECRES.H:189-191), und Eudoras Menues kennen die Befehle nicht. Sie
	// bleiben deklariert und definiert, stehen aber in keiner
	// Nachrichtentabelle und sind daher unerreichbar.
	afx_msg void OnViewWorkbook();
	afx_msg void OnUpdateViewWorkbook(CCmdUI* pCmdUI);
	afx_msg void OnOptionsToggleIcons();
	afx_msg void OnUpdateOptionsToggleIcons(CCmdUI* pCmdUI);

	// mainfrm.cpp:3285  QCWorkbook::OnDestroy() - raeumt m_pWBClient ab
	afx_msg void OnDestroy();

	DECLARE_MESSAGE_MAP();

	// Zugabe des Shims, nicht im Original: Ablage fuer den Rueckgabewert von
	// GetTabLabel. Die Methode ist const und muss einen Zeiger liefern, der
	// den Aufruf ueberlebt (workbook.cpp:1363  _tcsdup(pTabLabel)).
	mutable CString m_strTabLabelBuf;
};


/////////////////////////////////////////////////////////////////////////////
// 9. SECControlBarWorksheet  (Original: SECWB.H:223)
//
// Ein Worksheet, dessen Inhalt eine andockbare Leiste ist - so schwebt eine
// Wazoo-Leiste als eigenes MDI-Fenster. Eudora leitet QCControlBarWorksheet
// davon ab (workbook.h:86) und setzt sie als m_pFloatingMDIChildClass ein
// (workbook.cpp:668).
//
// m_wndDockBar ist ein Wertfeld vom Typ SECDockBar und wird von Eudora
// direkt angefasst:
//     workbook.cpp:371  m_wndDockBar.m_dwStyle & CBRS_FLOAT_MULTI
//     workbook.cpp:373  ((SECDockBar*)&m_wndDockBar)->GetFirstControlBar()
//     workbook.cpp:457, 459  dasselbe in OnClose
// SECDockBar gehoert zur Andockfamilie und damit zu Stufe 2; bis dahin kommt
// die Deklaration aus OT501/Include/sbardock.h.

class SECControlBarWorksheet : public SECWorksheet
{
	DECLARE_DYNCREATE(SECControlBarWorksheet)

// Konstruktion
protected:
	SECControlBarWorksheet();		// geschuetzt, fuer die dynamische Erzeugung

public:
	SECDockBar	m_wndDockBar;

// Ueberschreibungen
	// Nicht virtuell deklariert wie im Original, ueberschreibt aber
	// CFrameWnd::RecalcLayout. workbook.cpp:287 (QCControlBarWorksheet)
	// ueberspringt diese Fassung zugunsten von SECWorksheet::RecalcLayout.
	void RecalcLayout(BOOL bNotify = TRUE);

// Umsetzung
protected:
	virtual ~SECControlBarWorksheet();

	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	virtual BOOL OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext);

	// SECWB.H:255-258. workbook.cpp:455 (QCControlBarWorksheet::OnClose)
	// umgeht OnClose bewusst zugunsten von SECWorksheet::OnClose.
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnClose();
	afx_msg void OnWindowPosChanged(WINDOWPOS FAR* lpwndpos);
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);

	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// 10. SECControlBarMDIChildWnd  (Original: swinmdi.h:208)
//
// Das Gegenstueck zu SECControlBarWorksheet ausserhalb der Workbook-Kette.
// Weder Eudora noch die uebrigen OT501-Header benutzen die Klasse (einziger
// Treffer: ein Kommentar in sbardock.h:55). Sie wird hier nicht nachgebaut.
// Wird sie doch einmal gebraucht, ist sie eine wortgleiche Kopie von
// SECControlBarWorksheet mit SECMDIChildWnd als Basis.


// Rueckwaertsvertraeglichkeit, wie SECWB.H:264-266
#define SECDDIWorksheet SECWorksheet
#define SECDDIWorkbookClient SECWorkbookClient
#define SECDDIWorkbook SECWorkbook

// Waechter der ersetzten Originalheader setzen (siehe Einbindungshinweis oben)
#define __SWINMDI_H__
#define __SECWB_H__


#endif // __OTSHIM_H__
