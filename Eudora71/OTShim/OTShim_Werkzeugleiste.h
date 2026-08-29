// OTShim_Werkzeugleiste.h - Ersatzschicht fuer Stingray Objective Toolkit
//                           5.0.1, Stufe 3: Werkzeugleisten und Knoepfe
//
// Zu OTShim/PLAN.md, Abschnitt "Stufe 3 - Werkzeugleisten und Knoepfe".
//
// Diese Datei ersetzt sieben Originalheader aus OT501/Include:
//
//     tbtnstd.h   SECBtnDrawData, SECStdBtn, SECButtonClass, SECBtnMapEntry
//                 und die Knopftabellen-Makros
//     tbtnwnd.h   SECWndBtn
//     tbtn2prt.h  SECTwoPartBtn
//     tbtncmbo.h  SECComboBtnEdit, SECComboBtn
//     tbarcust.h  SECCustomToolBar, SECCustomToolBarInfoEx,
//                 SECLoadToolBarResource
//     tbarmgr.h   SECToolBarManager, wmSECNotifyMsg, wmSECToolBarWndNotify
//     tbarpage.h  SECToolBarSheet, SECToolBarCmdPage, SECCustomizeToolBar,
//                 SECConvertDialogUnitsToPixels
//     tbartrck.h  SECToolBarRectTracker
//
// Die Klassen- und Feldsaetze sind Zeile fuer Zeile aus diesen Headern
// uebernommen; sie sind laut Auftrag verbindlich. Abweichungen sind einzeln
// begruendet und mit "ABWEICHUNG" gekennzeichnet.
//
// WAS TATSAECHLICH ZU REKONSTRUIEREN WAR
//   Von OT501 liegt keine Implementierung vor (Ausnahme: secaux.cpp mit
//   secData). Fuer die schwierigste Methode - SECStdBtn::DrawFace - gibt es
//   aber eine Vorlage im Repo: TBarSendButton.cpp:71-160 repliziert die
//   Original-Logik samt secData-Farben und SEC_TBBS_RAISED vollstaendig,
//   weil Eudora sie ueberschreibt. Dasselbe Geruest steht ein zweites Mal,
//   auskommentiert, in MoodMailStatic.cpp:53-120. Der Zeichencode unten ist
//   daher abgelesen, nicht geraten. Alles Uebrige ist aus den Erwartungen
//   der Aufrufer rekonstruiert.
//
// ABGRENZUNG NACH UNTEN (Stufe 2, Agent LEISTE)
//   SECCustomToolBar erbt von SECControlBar, SECToolBarManager von
//   SECControlBarManager, SECCustomToolBarInfoEx von SECControlBarInfoEx.
//   Diese drei Basisklassen gehoeren zur Andockfamilie und damit zu Stufe 2.
//   Bis dahin kommen ihre Deklarationen aus den Originalheadern
//   sbarcore.h / sbarmgr.h / sdocksta.h; der Suchpfad muss OT501/Include
//   enthalten.
//
// EINBINDUNG
//   Wie OTShim.h darf diese Datei nicht gemeinsam mit den ersetzten
//   Originalen uebersetzt werden. Am Ende werden deren Includewaechter
//   gesetzt, damit ein spaeteres #include "secall.h" sie ueberspringt
//   (SECALL.H:371-403).
//
// Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue.

#ifndef __OTSHIM_WERKZEUGLEISTE_H__
#define __OTSHIM_WERKZEUGLEISTE_H__

#if defined(__TBTNSTD_H__) || defined(__TBTNWND_H__) || \
	defined(__TBTN2PRT_H__) || defined(__TBTNCMBO_H__) || \
	defined(__TBARCUST_H__) || defined(__TBARMGR_H__) || \
	defined(__TBARPAGE_H__) || defined(__TBARTRCK_H__)
#error OTShim_Werkzeugleiste.h ersetzt tbtnstd/tbtnwnd/tbtn2prt/tbtncmbo/tbarcust/tbarmgr/tbarpage/tbartrck - diese duerfen vorher nicht eingebunden sein.
#endif

#include <afxwin.h>			// CWnd, CDC, CBitmap, CBrush, CFont
#include <afxext.h>			// CControlBar, TBBS_*, CRectTracker
#include <afxdlgs.h>		// CPropertySheet, CPropertyPage
#include <afxtempl.h>		// CTypedPtrArray

// CDockState und CControlBarInfo sind Basisklassen von SECDockState bzw.
// SECControlBarInfo (sdocksta.h:39, 86) und stehen nur in afxpriv.h. Die
// Originalheader binden das nicht selbst ein, sondern verlassen sich auf die
// Reihenfolge in secall.h; hier steht es ausdruecklich da, damit die Datei
// fuer sich uebersetzbar bleibt. Dieselbe Stelle wie OTShim.h:386-388.
#ifndef __AFXPRIV_H__
#include <afxpriv.h>
#endif

#ifndef __SECAUX_H__
#include "secaux.h"			// SEC_AUX_DATA (secData, secaux.cpp:23)
#endif

#include "SafetyPal.h"		// CPaletteDC - Datenmember von SECBtnDrawData

#ifndef __SECRES_H__
#include "secres.h"			// IDD_TOOLBAR_CUSTOMIZE, IDS_TOOLBAR_CUSTOMIZE
#endif

#ifndef __SBARCORE_H__
#include "sbarcore.h"		// SECControlBar (Stufe 2)
#endif

#ifndef __SBARMGR_H__
#include "sbarmgr.h"		// SECControlBarManager (Stufe 2)
#endif

#ifndef __SDOCKSTA_H__
#include "sdocksta.h"		// SECControlBarInfo, SECControlBarInfoEx (Stufe 2)
#endif


// Vorwaertsdeklarationen
class SECCustomToolBar;
class SECToolBarManager;
class SECCustomizeToolBar;
class SECStdBtn;
class SECComboBtn;
struct SECButtonClass;
struct SECBtnMapEntry;
struct SECBtnDrawData;


// Sammelmeldung fuer alles, was ein Anwender ueber die Oberflaeche ausloesen
// kann, das aber in dieser Stufe nicht umgesetzt ist. Jede Fundstelle bringt
// ihr eigenes statisches Flag mit, meldet sich also hoechstens einmal je
// Sitzung.
//
// ZUSAMMENFUEHRUNG: OTShim.cpp:154 hat dieselbe Funktion unter dem Namen
// OTShimNichtUmgesetzt. Beim Zusammenlegen der Dateien bleibt eine von beiden
// uebrig; die Meldungstexte unterscheiden sich nur in der Stufenangabe.
void OTShimWzlNichtUmgesetzt(BOOL& rbBereitsGemeldet, LPCTSTR lpszWas);


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 1. tbtnstd.h - Zeichenpuffer, Knopfbasis, Knopftabellen
//
///////////////////////////////////////////////////////////////////////////////

// tbtnstd.h:40-41. Vorgabemasse eines Bildes in der Werkzeugleistenbitmap.
#define SEC_TOOLBAR_IMAGE_WIDTH		16
#define SEC_TOOLBAR_IMAGE_HEIGHT	15


///////////////////////////////////////////////////////////////////////////////
// SECBtnDrawData  (Original: tbtnstd.h:46)
//
// Der Zeichenpuffer, den sich alle Knoepfe einer Sitzung teilen. Er haelt
// drei Geraetekontexte:
//
//   m_bmpDC   die Werkzeugleistenbitmap (alle Knopfbilder nebeneinander)
//   m_drawDC  ein Zwischenpuffer in Groesse EINES Knopfes; dorthin malt
//             DrawFace, von dort geht ein einziges BitBlt auf den Bildschirm
//   m_monoDC  eine einfarbige Maske, mit der gesperrte und angekreuzte
//             Knoepfe ueberzeichnet werden
//
// BELEGT DURCH DIE AUFRUFER:
//   TBarSendButton.cpp:89   data.m_drawDC.FillSolidRect(...)   Ziel ist m_drawDC
//   TBarSendButton.cpp:158  data.m_drawDC.BitBlt(..., &data.m_bmpDC,
//                             nRealImage * GetImgWidth(), 0, SRCCOPY)
//                           -> m_bmpDC haelt die Leistenbitmap, die Bilder
//                              liegen waagerecht aneinander
//   EmoticonToolbarButton.cpp:93-96  malt VOR SECTwoPartBtn::DrawButton in
//                           data.m_bmpDC hinein -> m_bmpDC ist beim Aufruf
//                           von DrawButton bereits eingerichtet, PreDrawButton
//                           laeuft also vor der Knopfschleife, nicht je Knopf.
//
// Die Felder sind wortgleich aus tbtnstd.h:46-74 uebernommen.

struct SECBtnDrawData
{
	CPaletteDC m_monoDC;			// einfarbiger Kontext fuers Zeichnen
	CPaletteDC m_bmpDC;				// Kontext mit der Leistenbitmap
	CPaletteDC m_drawDC;			// Zwischenpuffer fuer einen Knopf
	CBrush m_ditherBrush;			// Schachbrettpinsel fuer angekreuzte und
									// unbestimmte Knoepfe

	SECBtnDrawData();
	~SECBtnDrawData();

	// Aufgerufen, wenn sich die Systemfarben aendern.
	void SysColorChange();

	// Vor- und Nachbereitung der Knopfschleife.
	BOOL PreDrawButton(CDC& dc, HBITMAP hBmp, int nMaxBtnWidth,
					   SECCustomToolBar* pToolBar);
	void PostDrawButton();

protected:
	HBRUSH CreateDitherBrush();

	// Von PreDrawButton/PostDrawButton benutzte Felder
	CBitmap  m_bmpDraw;
	CBitmap* m_pOldBmpDraw;
	CBitmap  m_bmpMono;
	CBitmap* m_pOldBmpMono;
	HGDIOBJ  m_hOldBmp;

	// ABWEICHUNG (Zugabe): Groesse des Zwischenpuffers. DrawButton muss
	// wissen, wie viel Platz es hat - sonst malt ein ungewoehnlich hoher
	// Knopf (etwa ein Kombinationsfeld mit m_nHeight 150) ueber den Puffer
	// hinaus. Im Original war das vermutlich implizit ueber den Aufrufer
	// geregelt; hier steht es ausdruecklich da.
public:
	int m_cxBuf;
	int m_cyBuf;
	BOOL m_bReady;					// TRUE zwischen PreDrawButton und
									// PostDrawButton
};


///////////////////////////////////////////////////////////////////////////////
// SECStdBtn  (Original: tbtnstd.h:79)
//
// WICHTIG (PLAN.md, Stufe 3): SECStdBtn ist WEDER CObject NOCH CWnd. Es ist
// ein reines Zeichenobjekt in einem CPtrArray der Leiste. Ein Umbau auf
// CMFCToolBarButton scheidet aus - er braeche die m_ulData-Zugriffe an rund
// 20 Stellen in QCCustomToolBar.cpp und QCChildToolBar.cpp.
//
// Eudora leitet direkt davon ab:
//   TBarSendButton      (TBarSendButton.h:11)
//   CMoodMailStatic     (MoodMailStatic.h:13)
//   CTBarMenuButton     (TBarMenuButton.h:14)
// und mittelbar ueber SECTwoPartBtn und SECWndBtn sechs weitere Klassen.

class SECStdBtn
{
// Konstruktion
public:
	SECStdBtn();

// Attribute
public:
	enum InformCode			// Kennungen fuer InformBtn
	{
		IBase   = 0x0000,
		Styles  = IBase + 1	// Knopfstile hinzunehmen/entfernen
	};

	struct StyleChange		// Nutzlast fuer InformCode::Styles
	{
		DWORD dwAdd;		// hinzuzunehmende Stilbits
		DWORD dwRemove;		// zu entfernende Stilbits
	};

	UINT m_nID;				// Befehlskennung des Knopfes
	UINT m_nImage;			// Platz des Bildes in der Leistenbitmap
	UINT m_nStyle;			// Knopfstile (TBBS_*, SEC_TBBS_*)
	int  m_x;				// x im Client-Bereich der Elternleiste
	int  m_y;				// y im Client-Bereich der Elternleiste
	int  m_cx;				// Breite
	int  m_cy;				// Hoehe

	ULONG	m_ulData;		// Zusatzangabe. Eudora legt hier die urspruengliche
							// Befehlskennung eines angepassten Knopfes ab
							// (QCCustomToolBar.cpp:303, 696, 780, 1206 u.a.)

// Operationen
public:
	void SetToolBar(SECCustomToolBar* pToolBar);
	void GetBtnRect(CRect& rect) const;

	virtual void SetMode(BOOL bVertical);
	virtual void SetPos(int x, int y);
	virtual void Invalidate(BOOL bErase = FALSE) const;

// Ueberschreibbares
public:
	virtual void Init(SECCustomToolBar* pToolBar, const UINT* pData);

	virtual void DrawButton(CDC& dc, SECBtnDrawData& data);

	virtual BOOL BtnPressDown(CPoint point);
	virtual void BtnPressMouseMove(CPoint point);
	virtual void BtnPressCancel();
	virtual UINT BtnPressUp(CPoint point);

	virtual void BarStyleChanged(DWORD dwStyle);

	// tbtnstd.h:145. Nicht CWnd::OnToolHitTest - dies ist SECStdBtns eigene
	// virtuelle Funktion. TBarSendButton.cpp:192 ueberschreibt sie.
	virtual int  OnToolHitTest(CPoint point, TOOLINFO* pTI) const;

	virtual void InformBtn(UINT nCode, void* pData);

	// Wird gerufen, wenn sich die Leistenbitmap geaendert hat.
	// TBarSendButton.cpp:26 und MoodMailStatic.cpp:32 ueberschreiben das.
	virtual void AdjustSize();

	// Zustandsablage beim Sichern/Laden einer Leiste.
	// QCCustomToolBar.cpp:358 ruft GetBtnInfo auf.
	virtual void GetBtnInfo(BYTE* nSize, LPBYTE* ppInfo) const;
	virtual void SetBtnInfo(BYTE nSize, const LPBYTE pInfo);

protected:
	// Zeichnen. DrawFace ist das Kernstueck; die Vorlage dafuer ist
	// TBarSendButton.cpp:71-160.
	virtual void DrawFace(SECBtnDrawData& data, BOOL bForce, int& x, int& y,
						  int& nWidth, int& nHeight, int nImgWidth = -1);
	virtual void DrawDisabled(SECBtnDrawData& data, int x, int y, int nWidth,
							  int nHeight);
	virtual void DrawChecked(SECBtnDrawData& data, int x, int y, int nWidth,
							 int nHeight);
	virtual void DrawIndeterminate(SECBtnDrawData& data, int x, int y,
								   int nWidth, int nHeight);
	virtual void DrawConfigFocus(SECBtnDrawData& data);

// Umsetzung
public:
	virtual ~SECStdBtn();

protected:
	void CreateMask(SECBtnDrawData& data, int x, int y, int nWidth, int nHeight);

protected:
	SECCustomToolBar* m_pToolBar;			// meine Elternleiste

public:
	// Erzeugungshilfen. tbtnstd.h:185-187 deklariert sie fuer SECStdBtn von
	// Hand statt ueber DECLARE_BUTTON; das bleibt so.
	virtual SECButtonClass* GetButtonClass() const;
	static const AFX_DATA SECButtonClass classSECStdBtn;
	static SECStdBtn* PASCAL CreateButton();
};


///////////////////////////////////////////////////////////////////////////////
// Erzeugungshilfen und Knopftabellen  (Original: tbtnstd.h:193-241)
//
// Wortgleich uebernommen. Eudora benutzt jedes dieser Makros:
//   IMPLEMENT_BUTTON  TBarSendButton.cpp:16, MoodMailStatic.cpp:13,
//                     TBarMenuButton.cpp:12, TBarCombo.cpp:5,
//                     ColorToolbarButton.cpp:41, EmoticonToolbarButton.cpp:44,
//                     TBarStatic.cpp:57, TBarEdit.cpp, TBarBmpCombo.cpp:58
//   BEGIN/END_BUTTON_MAP, STD_BUTTON  mainfrm.cpp:280, CompMessageFrame.cpp:125,
//                     ReadMessageFrame.cpp:164, PgDocumentFrame.cpp:94

#define BUTTON_CLASS(class_name) ((SECButtonClass*)(&class_name::class##class_name))

#define DECLARE_BUTTON(class_name) \
public: \
	static const AFX_DATA SECButtonClass class##class_name; \
	virtual SECButtonClass* GetButtonClass() const; \
	static SECStdBtn* PASCAL CreateButton();

#define IMPLEMENT_BUTTON(class_name) \
	SECStdBtn* PASCAL class_name::CreateButton() \
		{ return new class_name; } \
	const AFX_DATADEF SECButtonClass class_name::class##class_name = { \
		class_name::CreateButton }; \
	SECButtonClass* class_name::GetButtonClass() const \
		{ return BUTTON_CLASS(class_name); } \

struct SECButtonClass
{
// Attribute
	SECStdBtn* (PASCAL* m_pfnCreateButton)();

// Operationen
	SECStdBtn* CreateButton();
};

#define BTNMAP_DATA_ELEMENTS	5
struct SECBtnMapEntry
{
	SECButtonClass* m_pBtnClass;					// Klasse dieses Knopfes
	UINT            m_nID;							// Befehlskennung
	UINT	 	    m_nStyle;						// Stil
	UINT            m_nData[BTNMAP_DATA_ELEMENTS];	// knopfeigene Angaben
};

#define BEGIN_BUTTON_MAP(name) \
	static const SECBtnMapEntry name[] = {

#define STD_BUTTON(id, style) \
	{BUTTON_CLASS(SECStdBtn), id, style|TBBS_BUTTON, 0, 0, 0, 0, 0},

#define END_BUTTON_MAP() \
	{NULL, 0, 0, 0, 0, 0, 0, 0} \
	};


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 2. tbtnwnd.h - SECWndBtn
//
///////////////////////////////////////////////////////////////////////////////

// tbtnwnd.h:38. Breite des Anfasspunkts am rechten Rand, an dem sich ein
// Fensterknopf in der Breite ziehen laesst.
#define SEC_WNDBTN_RESIZE_WIDTH		3

///////////////////////////////////////////////////////////////////////////////
// SECWndBtn  (Original: tbtnwnd.h:43)
//
// Ein Knopf, der in Wahrheit ein echtes Kindfenster ist - Kombinationsfeld,
// Eingabefeld, Beschriftung. Die Mehrfachvererbung CWnd-Zweig + SECWndBtn
// muss erhalten bleiben; Eudora hat vier solche Klassen:
//   CTBarBitmapComboBtn : CBitmapCombo, SECWndBtn   (TBarBmpCombo.h:14)
//   CTBarEditBtn        : CEdit,        SECWndBtn   (TBarEdit.h:12)
//   CTBarStaticBtn      : CStatic,      SECWndBtn   (TBarStatic.h:12)
//   SECComboBtn         : CComboBox,    SECWndBtn   (tbtncmbo.h:73)
//
// Die drei erstgenannten Implementierungen fehlten in der CHM-Freigabe und
// sind bereits als TBarBmpCombo.cpp, TBarEdit.cpp und TBarStatic.cpp
// nachgebaut. Sie rufen genau die hier deklarierten Methoden auf, in dieser
// Rollenverteilung:
//   TBarStatic.cpp:201  if(!SECWndBtn::LButtonDown(...)) CStatic::OnLButtonDown(...)
//                       -> Rueckgabe TRUE heisst "die Leiste hat das Ereignis
//                          fuer sich beansprucht"
//   TBarStatic.cpp:243  if(SECWndBtn::SetCursor()) return TRUE;
//   TBarStatic.cpp:155  AdjustSize leitet an die Basis weiter

class SECWndBtn : public SECStdBtn
{
// Konstruktion
public:
	SECWndBtn();

// Attribute
public:
	enum NotifyCodes		// Meldungen ueber wmSECToolBarWndNotify
	{
		NBase   = 0x0100,
		WndInit = NBase + 1	// CWnd erzeugt und braucht Einrichtung
	};

	enum InformCode
	{
		IBase   = 0x0100,
		WndMsg  = IBase + 1	// Nachricht an das CWnd weiterreichen
	};

// Operationen
public:
	virtual void SetMode(BOOL bVertical);
	virtual void SetPos(int x, int y);
	virtual void Invalidate(BOOL bErase = FALSE) const;

	// Das CWnd reicht Mausereignisse zuerst hierher.
	virtual BOOL LButtonDown(UINT nFlags, CPoint point);
	BOOL LButtonUp(UINT nFlags, CPoint point);
	BOOL LButtonDblClk(UINT nFlags, CPoint point);
	BOOL RButtonDown(UINT nFlags, CPoint point);
	BOOL RButtonUp(UINT nFlags, CPoint point);
	BOOL RButtonDblClk(UINT nFlags, CPoint point);
	BOOL SetCursor();

protected:
	void PrePaint();
	void PostPaint();
	void ForwardMessage(UINT nMessage, WPARAM wParam = 0, LPARAM lParam = 0);

	void SendNotify(UINT nCode);

// Ueberschreibbares
public:
	virtual void Init(SECCustomToolBar* pToolBar, const UINT* pData);
	virtual void DrawButton(CDC& dc, SECBtnDrawData& data);
	virtual int  OnToolHitTest(CPoint point, TOOLINFO* pTI) const;
	virtual void InformBtn(UINT nCode, void* pData);
	virtual void GetBtnInfo(BYTE* nSize, LPBYTE* ppInfo) const;
	virtual void SetBtnInfo(BYTE nSize, const LPBYTE pInfo);
	virtual void AdjustSize();

protected:
	virtual CWnd* GetWnd() = 0;			// Zeiger auf mein CWnd
	virtual BOOL CreateWnd(CWnd* pParentWnd, DWORD dwStyle, CRect& rect,
						   int nID) = 0;

// Umsetzung
public:
	virtual ~SECWndBtn() {}

protected:
	static HCURSOR hCurHorzDrag;// gemeinsamer Zeiger beim Breitenziehen
	BOOL  m_bWndVisible;		// CWnd sichtbar (nicht senkrecht angedockt)
	int   m_nSize;				// Breite des CWnd
	int   m_nMinSize;			// Mindestbreite des CWnd
	int   m_nHeight;			// gewuenschte Hoehe des CWnd
	int   m_nRealHeight;		// tatsaechliche Hoehe des CWnd
};

// tbtnwnd.h:137-140
#define WND_BUTTON(class, id, wndId, style, wndStyle, wndDefWidth, \
				   wndMinWidth, wndHeight) \
	{class, id, style|TBBS_BUTTON, wndId, wndStyle, MAKELONG(wndDefWidth, \
     wndMinWidth), wndHeight, 0},


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 3. tbtn2prt.h - SECTwoPartBtn
//
///////////////////////////////////////////////////////////////////////////////

// tbtn2prt.h:44-49
#define SEC_TOOLBAR_TWOPART_WIDTH	34
#define SEC_TOOLBAR_TWOPART_DWIDTH	11

#define SEC_TBBS_PRESSED2 (MAKELONG(0, 0x0400))		// zweiter Teil gedrueckt
#define SEC_TBBS_TRACKING2 (MAKELONG(0, 0x0800))	// zweiter Teil verfolgt

#define TWOPART_BUTTON(id, id2, style, dispatchID) \
	{BUTTON_CLASS(SECTwoPartBtn), id, style|TBBS_BUTTON, id2, dispatchID, 0, \
	 0, 0},

///////////////////////////////////////////////////////////////////////////////
// SECTwoPartBtn  (Original: tbtn2prt.h:56)
//
// Ein Knopf mit angehaengtem schmalen Aufklappteil. Eudora leitet zwei
// Klassen davon ab:
//   CColorToolbarButton  (ColorToolbarButton.h:31) - Textfarbe
//   EmoticonToolbarButton (EmoticonToolbarButton.h:33) - Emoticon
// Beide werten SEC_TBBS_PRESSED2 aus (ColorToolbarButton.cpp:86,
// EmoticonToolbarButton.cpp:113) und loeschen es zusammen mit
// SEC_TBBS_TRACKING2 wieder (:122 bzw. :152).

class SECTwoPartBtn : public SECStdBtn
{
// Konstruktion
public:
	SECTwoPartBtn();

// Attribute
public:
	BOOL m_bTwoPartMode;	// waagerecht ausgerichtet, also zweiteilig
	UINT m_nID2;			// Kennung des zweiten Teils
	UINT m_nDispatchID2;	// abgesetzter Befehl des zweiten Teils
	UINT m_nImage2;			// Bildplatz des zweiten Teils

// Operationen
public:
	virtual void SetMode(BOOL bVertical);

// Ueberschreibbares
public:
	virtual void AdjustSize();

protected:
	virtual void Init(SECCustomToolBar* pToolBar, const UINT* pData);
	virtual void DrawButton(CDC& dc, SECBtnDrawData& data);

	virtual BOOL BtnPressDown(CPoint point);
	virtual void BtnPressMouseMove(CPoint point);
	virtual void BtnPressCancel();
	virtual UINT BtnPressUp(CPoint point);

// Umsetzung
	DECLARE_BUTTON(SECTwoPartBtn)
};


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 4. tbtncmbo.h - SECComboBtnEdit und SECComboBtn
//
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// SECComboBtnEdit  (Original: tbtncmbo.h:43)
//
// Das unterklassierte Eingabefeld eines aufklappbaren Kombinationsfeldes.
// Ohne diese Klasse verschluckt das Kindfenster alle Mausereignisse, und der
// Knopf liesse sich im Anpassen-Modus weder verschieben noch in der Breite
// ziehen. TBarCombo.cpp:31 und TBarBmpCombo.cpp:118 tragen sich mit
// m_pCombo hier ein.

class SECComboBtnEdit : public CEdit
{
// Konstruktion
public:
	SECComboBtnEdit();

// Umsetzung
public:
	virtual ~SECComboBtnEdit() {}

public:
	SECWndBtn* m_pCombo;				// das Kombinationsfeld darueber

protected:
	DECLARE_MESSAGE_MAP()

	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnRButtonDblClk(UINT nFlags, CPoint point);
	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
};

///////////////////////////////////////////////////////////////////////////////
// SECComboBtn  (Original: tbtncmbo.h:73)
//
// PLAN.md, Stufe 3: "SECComboBtn erbt von CComboBox UND SECWndBtn - die
// Mehrfachvererbung muss erhalten bleiben (TBarCombo.cpp:19,30)." Genau dort
// ruft CTBarComboBtn::CreateWnd sowohl CComboBox::Create als auch
// m_edit.m_pCombo = (SECWndBtn*) this auf; die Umwandlung setzt beide
// Basisklassen voraus.

class SECComboBtn : public CComboBox, public SECWndBtn
{
	DECLARE_BUTTON(SECComboBtn);

// Konstruktion
public:
	SECComboBtn() {}

// Attribute
public:
	enum NotifyCodes
	{
		NBase   = 0x0200,
		Entered = NBase + 1	// Eingabetaste gedrueckt
	};

// Operationen
public:
	virtual void SetMode(BOOL bVertical);

// Ueberschreibbares
protected:
	virtual CWnd* GetWnd();
	virtual BOOL CreateWnd(CWnd* pParentWnd, DWORD dwStyle, CRect& rect, int nID);

	virtual BOOL PreTranslateMessage(MSG* pMsg);
	virtual void OnFontCreateAndSet();

// Umsetzung
public:
	virtual ~SECComboBtn() {}

	virtual void AdjustSize();

protected:
	SECComboBtnEdit m_edit;				// mein unterklassiertes Eingabefeld
	CFont m_font;						// TBarCombo.cpp:43 benutzt es

	DECLARE_MESSAGE_MAP()

	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnRButtonDblClk(UINT nFlags, CPoint point);
	afx_msg void OnPaint();
	afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
};

// tbtncmbo.h:130-133
#define COMBO_BUTTON(id, comboId, style, comboStyle, comboDefWidth, \
					 comboMinWidth, comboHeight) \
	WND_BUTTON(BUTTON_CLASS(SECComboBtn), id, comboId, style, comboStyle, \
		       comboDefWidth, comboMinWidth, comboHeight)


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 5. tbarcust.h - SECCustomToolBar
//
///////////////////////////////////////////////////////////////////////////////

// tbarcust.h:47-68
#define SEC_TOOLBAR_BTN_WIDTH       23
#define SEC_TOOLBAR_BTN_HEIGHT      22

#define SEPARATOR_HEIGHT  ((m_nSepWidth*2)/3)

#define SEC_TBBS_FOCUS (MAKELONG(0, 0x0100))		// Knopf hat Anpassen-Fokus
#define SEC_TBBS_RAISED (MAKELONG(0, 0x0200))		// Knopf ist angehoben

#define SEC_IDW_FIRST_USER_TOOLBAR		(AFX_IDW_TOOLBAR + 0x20)

#ifndef NUMELEMENTS
#define NUMELEMENTS(array) (sizeof(array)/sizeof(array[0]))
#endif

// Typkennung fuer SaveBarState/LoadBarState. QCToolBarManager.cpp:1341
// wertet sie in DynCreateControlBar aus.
#define CBT_SECCUSTOMTOOLBAR	14946

///////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar  (Original: tbarcust.h:73)
//
// Die anpassbare Werkzeugleiste. Eudora leitet vier Klassen davon ab:
//   QCCustomToolBar     (QCCustomToolBar.h:15)  - Hauptfenster und Anzeigen
//   QCChildToolBar      (QCChildToolBar.h:15)   - Dokumentfenster
//   CSearchBar          (SearchBar.h:112)       - Suchleiste
//   SECCustomizeToolBar (weiter unten)          - Vorrat im Anpassen-Dialog
//
// Der Feldsatz ist wortgleich uebernommen, weil Eudora direkt darauf zugreift:
//   m_btns        QCCustomToolBar.cpp:254,285,303,346,384,452,696,780,916,1206,
//                 1252-1256; QCChildToolBar.cpp:117,196,226,237
//   m_nDown       QCCustomToolBar.cpp:275,278
//   m_bAltDrag    QCCustomToolBar.cpp:305; QCChildToolBar.cpp:131
//   m_nBmpItems/m_pBmpItems  QCCustomToolBar.cpp:171-194,543-551,746-754,1190
//   m_szTbarDockHorz         QCChildToolBar.h:43 (INT Height())
//   m_nMaxBtnWidth           TBarSendButton.cpp:59

class SECCustomToolBar : public SECControlBar
{
// Konstruktion
public:
	SECCustomToolBar();

	BOOL Create(LPCTSTR lpszClassName, LPCTSTR lpszWindowName, UINT nID,
		DWORD dwStyle, DWORD dwExStyle, const RECT& rect, CWnd* pParentWnd = NULL,
		CCreateContext* pContext = NULL);

	BOOL Create(CWnd* pParentWnd, DWORD dwStyle = WS_VISIBLE | WS_CHILD |
				CBRS_TOP, UINT nID = AFX_IDW_TOOLBAR, LPCTSTR lpszTitle = NULL);

	BOOL CreateEx(DWORD dwExStyle, CWnd* pParentWnd, DWORD dwStyle =
				WS_VISIBLE | WS_CHILD | CBRS_TOP, UINT nID = AFX_IDW_TOOLBAR,
				LPCTSTR lpszTitle = NULL);

	DECLARE_DYNCREATE(SECCustomToolBar)

// Attribute
public:
	enum BarNotifyCode				// Meldungen an den Verwalter
	{
		BarShow,					// Leiste wird gezeigt
		BarHide,					// Leiste wird verborgen
		BarCreate,					// Leiste wurde erzeugt
		BarDelete,					// Leiste wird geloescht
		BarDesChange				// Knopf mit Anpassen-Fokus gewechselt
	};

	// Beschreibt eine Umbruchstelle beim Zeilenumbruch der Leiste.
	struct Wrapped
	{
		int  m_nAfter;				// nach diesem Platz wird umgebrochen
		BOOL m_bAtSep;				// TRUE, wenn an einem Trenner
		int  m_nSize;				// waagerechte Ausdehnung dieser Zeile
	};
	virtual void GetInsideRect(CRect& rectInside) const;

// Operationen
public:
	virtual void GetBarInfoEx(SECControlBarInfo* pInfo);
	virtual void SetBarInfoEx(SECControlBarInfo* pInfo, CFrameWnd* pFrameWnd);

	void SetButtonStyle(int nIndex, UINT nStyle);
	UINT GetButtonStyle(int nIndex) const;

	virtual BOOL RemoveButton(int nIndex, BOOL bNoUpdate = FALSE, INT* pIndex = NULL );
	virtual void AddButton(int nIndex, int nID, BOOL bSeparator = FALSE,
				   BOOL bNoUpdate = FALSE);

	inline int GetBtnCount() const { return (int)m_btns.GetSize(); }
	inline BOOL InConfigMode() const { return m_bConfig; }
	inline BOOL InAltDragMode() const { return m_bAltDrag; }

	int CommandToIndex(UINT nID) const;
	UINT GetItemID(int nIndex) const;
	int GetCurBtn() const;
	int IDToBmpIndex(UINT nID);

	BOOL LoadToolBar(LPCTSTR lpszResourceName);
	BOOL LoadToolBar(UINT nIDResource);
	BOOL LoadBitmap(UINT nIDResource, const UINT* lpIDArray, int nIDCount);
	BOOL LoadBitmap(LPCTSTR lpszResourceName, const UINT* lpIDArray,
						   int nIDCount);
	void SetToolBarInfo(HBITMAP hBmp, UINT* pBmpItems, UINT nBmpItems,
						int nImgWidth, int nImgHeight);

	BOOL SetButtons(const UINT* lpIDArray, int nIDCount);

	void GetItemRect(int nIndex, LPRECT lpRect) const;

	void InformBtns(UINT nID, UINT nCode, void* pData, BOOL bPass = FALSE);

// Ueberschreibbares
public:
	virtual CSize CalcFixedLayout(BOOL bStretch, BOOL bHorz);
	virtual CSize CalcDynamicLayout( int nLength, DWORD dwMode );
	virtual void  OnUpdateCmdUI(CFrameWnd* pTarget, BOOL bDisableIfNoHndler);
	virtual void  OnBarStyleChange(DWORD dwOldStyle, DWORD dwNewStyle);

	// ABWEICHUNG: tbarcust.h:173 schreibt "virtual int". MFC 14 deklariert
	// CWnd::OnToolHitTest als "virtual INT_PTR" (afxwin.h:2429). Unter Win32
	// sind beide gleich; hier wird MFC gefolgt, damit die Ueberschreibung auch
	// bei einer 64-Bit-Portierung eine bleibt. Dieselbe Entscheidung wie bei
	// SECWorkbook::OnToolHitTest in OTShim.h. Eudora ueberschreibt diese
	// Fassung nirgends - die Treffer auf OnToolHitTest gehoeren zu
	// SECStdBtn::OnToolHitTest (TBarSendButton.cpp:192).
	virtual INT_PTR OnToolHitTest(CPoint point, TOOLINFO* pTI) const;

protected:
	virtual void  DoPaint(CDC* pDC);
	virtual void  DelayShow(BOOL bShow);

	virtual void  BalanceWrap(int nRow, Wrapped* pWrap);
	virtual BOOL  GetDragMode() const;
	virtual BOOL  AcceptDrop() const;

// Ueberschreibungen
	virtual void AdjustInsideRectForGripper(CRect& rect,BOOL bHorz);

// Umsetzung
public:
	virtual ~SECCustomToolBar();

	virtual void DrawBorders(CDC* pDC, CRect& rect);

	void EnableConfigMode(BOOL bEnable);

	inline BOOL CoolLookEnabled() const { return (m_dwExStyle & CBRS_EX_COOLBORDERS) ? TRUE : FALSE; }

	BOOL IsTransparent() const;

	inline int GetImgWidth() const { return m_nImgWidth; }
	inline int GetImgHeight() const { return m_nImgHeight; }
	inline int GetStdBtnWidth() const { return (m_nImgWidth + 7); }
	inline int GetStdBtnHeight() const { return (m_nImgHeight + 7); }
	inline int GetSepWidth() const { return ((m_nImgWidth + 8) / 3); }
	inline int GetSepHeight() const { return (m_nImgHeight + 7); }

	SECBtnDrawData& GetDrawData();
	void SetBitmap(HBITMAP hBmp);

protected:
	BOOL CanWrapRow(int nRowToWrap, int nMaxSize, int nRows, Wrapped* pWrap);
	int PerformWrap(int nLength, Wrapped* pWrap);
	CSize CalcSize(int nRows, Wrapped* pWrap);
	CSize SizeToolBar(int nLength, BOOL bVert);
	CSize CalcLayout(int nLength, DWORD dwMode);

	void NotifyManager(BarNotifyCode nCode);
	void InvalidateButton(int nIndex);
	int  ItemFromPoint(CPoint point, CRect& rect) const;
	void UpdateButton(int nIndex);
	void SetMode(BOOL bVertDock);
	void RemoveConfigFocus(BOOL bRedraw = FALSE);

	virtual BOOL DragButton(int nIndex, CPoint point);
	virtual void DropButton(CRect& dropRect, SECStdBtn* pDragBtn, BOOL bAdd);

	void FindRow(CRect& clientRect, CRect& dropRect, int& nRowStart,
				 int& nRowEnd);

	SECCustomToolBar* GetConfigFocus() const;
	void SetConfigFocus(SECCustomToolBar* pFocus);

	void RaiseButton();
	void NewToolBar(CPoint pt, const SECStdBtn& btn);
	BOOL SmallDrag(CRect& dropRect, int nRowStart, int nRowEnd, BOOL bAdd);

	virtual SECStdBtn* CreateButton(UINT nID, SECCustomToolBar* pToolBar = NULL);
	virtual SECStdBtn* CreateSeparator(SECCustomToolBar* pToolBar = NULL);

	SECCustomToolBar* ToolBarFromPoint(int x, int y);

	// Felder, wortgleich zu tbarcust.h:288-311
	BOOL                         m_bOwnBitmap;		// TRUE, wenn m_hBmp mir gehoert
	UINT                         m_nBmpItems;		// Anzahl Bilder in der Bitmap
	HBITMAP                      m_hBmp;			// die Leistenbitmap
	LPCTSTR                      m_lpszResourceName;// Kennung der Leistenbitmap
	UINT*                        m_pBmpItems;		// Befehl -> Bildplatz
	int                          m_nImgHeight;		// Hoehe eines Bildes
	int                          m_nImgWidth;		// Breite eines Bildes
	int							 m_nSepWidth;		// Breite eines Trenners
	int							 m_nDown;			// gedrueckt / Anpassen-Fokus
	int							 m_nRaised;			// angehobener Knopf ("Cool")
	BOOL						 m_bConfig;			// im Anpassen-Modus
	BOOL						 m_bAltDrag;		// Ziehen mit Alt-Taste
	SECBtnDrawData*				 m_pDrawData;		// Zeichenpuffer
	BOOL						 m_bVertical;		// senkrecht angedockt
	BOOL 						 m_bFloatSizeUnknown;
	BOOL						 m_bHorzDockSizeUnknown;
	BOOL						 m_bVertDockSizeUnknown;
	CSize						 m_szTbarDockHorz;	// eigene Kopie von m_szDockHorz
	CSize						 m_szTbarDockVert;	// eigene Kopie von m_szDockVert
	CSize						 m_szTbarFloat;		// eigene Kopie von m_szFloat

public:
	int                          m_nMaxBtnWidth;	// breitester Knopf

protected:
	// Feld aller meiner Knoepfe. Im Original ausdruecklich kein
	// CTypedPtrArray, "weil manche Unix-Compiler keine Templates koennen"
	// (tbarcust.h:319-321). Wortgleich uebernommen, weil QCCustomToolBar und
	// QCChildToolBar mit m_btns[i] darauf zugreifen.
	class SECBtnArray : public CPtrArray
	{
	public:
		SECStdBtn* GetAt(INT_PTR nIndex) const
			{ return (SECStdBtn*)CPtrArray::GetAt(nIndex); }
		SECStdBtn*& ElementAt(INT_PTR nIndex)
			{ return (SECStdBtn*&)CPtrArray::ElementAt(nIndex); }
		void SetAt(INT_PTR nIndex, SECStdBtn* ptr)
			{ CPtrArray::SetAt(nIndex, ptr); }

		void SetAtGrow(INT_PTR nIndex, SECStdBtn* newElement)
		   { CPtrArray::SetAtGrow(nIndex, newElement); }
		INT_PTR Add(SECStdBtn* newElement)
		   { return CPtrArray::Add(newElement); }
		INT_PTR Append(const SECBtnArray& src)
		   { return CPtrArray::Append(src); }
		void Copy(const SECBtnArray& src)
			{ CPtrArray::Copy(src); }

		void InsertAt(INT_PTR nIndex, SECStdBtn* newElement, INT_PTR nCount = 1)
			{ CPtrArray::InsertAt(nIndex, newElement, nCount); }
		void InsertAt(INT_PTR nStartIndex, SECBtnArray* pNewArray)
		   { CPtrArray::InsertAt(nStartIndex, pNewArray); }

		SECStdBtn* operator[](INT_PTR nIndex) const
			{ return (SECStdBtn*)CPtrArray::operator[](nIndex); }
		SECStdBtn*& operator[](INT_PTR nIndex)
			{ return (SECStdBtn*&)CPtrArray::operator[](nIndex); }
	} m_btns;

	DECLARE_MESSAGE_MAP()

	afx_msg void OnWindowPosChanging(LPWINDOWPOS lpWndPos);
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
	virtual afx_msg void OnSysColorChange();
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnCancelMode();
	afx_msg int  OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest, UINT message);

	// ABWEICHUNG: tbarcust.h:367 schreibt "afx_msg LONG OnNoDelayHide(UINT,
	// LONG)". Diese Signatur passt in MFC 14 in keinen Eintrag der
	// Nachrichtentabelle mehr (ON_REGISTERED_MESSAGE verlangt
	// LRESULT(WPARAM,LPARAM)). Die Deklaration bleibt unveraendert stehen,
	// damit die Oberflaeche stimmt; eingetragen wird sie nicht.
	afx_msg LONG OnNoDelayHide(UINT nID, LONG lParam);

	afx_msg void OnDestroy();
	afx_msg void OnTimer(UINT_PTR nIDEvent);	// ABWEICHUNG: UINT_PTR statt
												// UINT - ON_WM_TIMER verlangt
												// das in MFC 14. Derselbe
												// Fall wie statbar.h:71
												// (PLAN.md, "Was unabhaengig
												// vom Shim blockiert").

public:
	// QC CHANGE laut tbarcust.h:372: oeffentlich gemacht.
	void SetConfigFocus(int nBtn, BOOL bRedraw = FALSE);
};

/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBarInfoEx  (Original: tbarcust.h:381)
//
// Der gesicherte Zustand einer Leiste: Titel und Knopfliste.
// QCCustomToolBar.cpp:336-365 fuellt das Objekt, QCToolBarManager.cpp:1359
// liest es beim Wiederherstellen zurueck.

class SECCustomToolBarInfoEx : public SECControlBarInfoEx
{
	DECLARE_DYNCREATE(SECCustomToolBarInfoEx)

// Konstruktion
public:
	SECCustomToolBarInfoEx();

// Attribute
public:
	CString m_strBarName;		// Titel der Leiste

	struct BtnInfo
	{
		UINT  m_nID;			// Kennung des Knopfes
		BYTE  m_nSizeExtraInfo;	// Groesse der Zusatzangaben
		BYTE* m_pExtraInfo;		// Zeiger auf die Zusatzangaben

		BtnInfo() : m_nID(0), m_nSizeExtraInfo(0), m_pExtraInfo(NULL) {}
		~BtnInfo();
 	};

	CTypedPtrArray<CPtrArray, BtnInfo*> m_btnInfo;

// Operationen
public:
	virtual void Serialize(CArchive& ar, SECDockState* pDockState);
	virtual BOOL LoadState(LPCTSTR lpszSection, SECDockState* pDockState);
	virtual BOOL SaveState(LPCTSTR lpszSection);

// Umsetzung
public:
	virtual ~SECCustomToolBarInfoEx();
};


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 6. tbarmgr.h - SECToolBarManager
//
///////////////////////////////////////////////////////////////////////////////

// Angemeldete Fensternachrichten, die der Leistenverwalter weiterreicht.
// QCCustomizeSignaturesPage.cpp:110 und QCCustomizeStationeryPage.cpp:112
// tragen wmSECNotifyMsg in ihre Nachrichtentabelle ein.
extern const int wmSECNotifyMsg;			// Meldung einer Werkzeugleiste
extern const int wmSECToolBarWndNotify;		// Meldung eines SECWndBtn

///////////////////////////////////////////////////////////////////////////////
// SECToolBarManager  (Original: tbarmgr.h:57)
//
// Verwaltet alle Werkzeugleisten eines Rahmenfensters: die gemeinsame
// Bitmap, die Knopftabelle, den Anpassen-Modus und den gesicherten Zustand.
// Eudora leitet QCToolBarManagerWithBM davon ab (QCToolBarManager.h:12) und
// davon wiederum QCToolBarManager.
//
// KATEGORIE C laut PLAN.md, Stufe 3: EnableLargeBtns und LoadState werden von
// Eudora NIE aufgerufen - alle Treffer im Inventar stammen aus Kommentaren.
// Qualcomm hat beide durch QCEnableLargeBtns (QCToolBarManager.cpp:280-540)
// und QCLoadState (:1119-1169) ersetzt, weil EnableLargeBtns nicht virtuell
// ist. Beide bekommen hier trotzdem einen Rumpf ("Dummy statt Weglassen").
//
// GEBRAUCHT WERDEN dagegen (PLAN.md ausdruecklich): LargeBtnsEnabled()
// - QCToolBarManager.cpp:276 gibt m_bLargeBmp zurueck - und
// SetDefaultDockState(), QCToolBarManager.cpp:1168.

class SECToolBarManager : public SECControlBarManager
{
	DECLARE_DYNAMIC(SECToolBarManager)

// Konstruktion
public:
	SECToolBarManager();
	SECToolBarManager(CFrameWnd* pFrameWnd);

// Operationen
public:
	void DefineDefaultToolBar(UINT nID,
							  LPCTSTR lpszTitle,
							  UINT    nBtnCount,
							  UINT*   lpBtnIDs,
							  DWORD   dwAlignment   = CBRS_ALIGN_ANY,
							  UINT    nDockBarID    = AFX_IDW_DOCKBAR_TOP,
							  UINT    nDockNextToID = NULL,
							  BOOL    bDocked       = TRUE,
							  BOOL    bVisible      = TRUE);

	// mainfrm.cpp:2987, 8667, 8678, 8726, 8742
	BOOL IsMainFrameEnabled();

	void EnableConfigMode(BOOL bEnable=TRUE);
	BOOL InConfigMode() const;

	BOOL IsToolBarCommand(CRect& rect) const;

	// QCCustomizeToolBar.cpp:89
	SECCustomToolBar* ToolBarUnderRect(const CRect& rect) const;

	BOOL GetDefaultBtns(UINT nID, int& nCount, UINT*& lpBtnIDs);

	// QC Change laut tbarmgr.h:97: virtuell gemacht.
	// QCToolBarManager.h:47 ueberschreibt mit einer breiteren Signatur.
	virtual SECCustomToolBar* CreateUserToolBar(LPCTSTR lpszTitle = NULL);

	BOOL LoadToolBarResource(LPCTSTR lpszStdBmpName,
							 LPCTSTR lpszLargeBmpName = NULL);

	// QCCustomizeToolBar.cpp:121
	void GetNoDropRect(CRect& rect) const;

	int ExecViewToolBarsDlg();

	void InformBtns(UINT nID, UINT nCode, void* pData);

	// mainfrm.cpp:1710-1720 fragt FlyByEnabled und ToolTipsEnabled ab
	void EnableToolTips(BOOL bEnable=TRUE);
	void EnableFlyBy(BOOL bEnable=TRUE);
	BOOL ToolTipsEnabled() const;
	BOOL FlyByEnabled() const;

	// KATEGORIE C - siehe Klassenkommentar
	void EnableLargeBtns(BOOL bEnable=TRUE);
	// GEBRAUCHT: QCToolBarManager.cpp:276
	BOOL LargeBtnsEnabled() const;

	void EnableCoolLook(BOOL bEnable=TRUE,
					DWORD dwExCoolLookStyles=CBRS_EX_COOLBORDERS|CBRS_EX_GRIPPER);
	BOOL CoolLookEnabled() const;

	// mainfrm.cpp:1734; QCToolBarManager.cpp:523, 621, 934, 1305, 1373;
	// QCToolbarCmdPage.cpp:81, 129
	void SetToolBarInfo(SECCustomToolBar* pToolBar);

	// mainfrm.cpp:1652; CompMessageFrame.cpp:446; ReadMessageFrame.cpp:300;
	// PgDocumentFrame.cpp:181
	void SetButtonMap(const SECBtnMapEntry* pMap);
	const SECBtnMapEntry* GetButtonMap() const;

	// KATEGORIE C (LoadState) bzw. gebraucht (SaveState,
	// QCToolBarManager.cpp:1205)
	virtual void LoadState(LPCTSTR lpszProfileName);
	virtual void SaveState(LPCTSTR lpszProfileName) const;

	// GEBRAUCHT: QCToolBarManager.cpp:1168
	virtual void SetDefaultDockState();

	virtual DWORD GetBarTypeID(CControlBar* pBar) const;
	virtual SECControlBarInfoEx* CreateControlBarInfoEx(SECControlBarInfo*) const;
	virtual CControlBar* DynCreateControlBar(SECControlBarInfo* pBarInfo);

// Umsetzung
public:
	virtual ~SECToolBarManager();

	// QCToolbarCmdPage.cpp:117
	void EnableMainFrame();
	void DisableMainFrame();

	void SetInToolBarCommand(BOOL bIn, CRect& rect);

	void BarNotify(int nID, SECCustomToolBar::BarNotifyCode notify);

	void AddNotify(CWnd* pWnd);
	void RemoveNotify(CWnd* pWnd);

	// QCToolbarCmdPage.cpp:120
	void SetNoDropWnd(CWnd* pWnd);

	SECCustomToolBar* GetConfigFocus() const { return m_pConfigFocus; }
	void SetConfigFocus(SECCustomToolBar* pFocus) { m_pConfigFocus = pFocus; }

	SECBtnDrawData& GetDrawData() { return m_drawData; }

	void SysColorChange();

	void ChangeBarStyle(BOOL bAdd, DWORD dwStyle);
	void ChangeExBarStyle(BOOL bAdd, DWORD dwExStyle);

protected:
	BOOL ChangeBitmap();

	struct SECDefaultToolBar			// Eintrag fuer eine Vorgabeleiste
	{
		UINT    nID;
		LPCTSTR lpszTitle;
		UINT    nBtnCount;
		UINT*   lpBtnIDs;
		DWORD   dwAlignment;
		UINT    nDockBarID;
		UINT    nDockNextToID;
		BOOL    bDocked;
		BOOL    bVisible;
	};

	CDWordArray m_enabledList;			// von DisableMainFrame gesperrte Fenster
	CPtrArray m_defaultBars;			// Vorgabeleisten
	CPtrArray m_notifyWnds;				// Empfaenger der Leistenmeldungen
	CWnd* m_pNoDropWnd;					// Fenster ohne Ablagemoeglichkeit
	BOOL m_bMainFrameEnabled;
	BOOL m_bConfig;						// im Anpassen-Modus
	BOOL m_bToolTips;
	BOOL m_bFlyBy;
	BOOL m_bCoolLook;
	BOOL m_bLargeBmp;					// QCToolBarManager.cpp:276, 315-318
	BOOL m_bInToolBarCommand;
	const SECBtnMapEntry* m_pBtnMap;	// Befehl -> Knopfklasse
	SECCustomToolBar* m_pConfigFocus;
	CRect m_btnRect;
	CBitmap m_bmp;						// QCToolBarManager.cpp:323, 346, 405 ...
	UINT m_nBmpItems;					// QCToolBarManager.cpp:321, 399, 482 ...
	LPCTSTR m_lpszStdBmpName;
	LPCTSTR m_lpszLargeBmpName;
	UINT* m_pBmpItems;					// QCToolBarManager.cpp:320, 346, 480 ...
	int m_nImgHeight;					// QCToolBarManager.cpp:346, 563, 679 ...
	int m_nImgWidth;
	SECBtnDrawData m_drawData;			// gemeinsamer Zeichenpuffer

public:
	CRuntimeClass* m_pToolBarClass;		// QCToolBarManager.cpp:260, 1291, 1339

protected:
    DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// Inline-Funktionen von SECCustomToolBar, die SECToolBarManager kennen
// muessen (im Original ebenfalls erst nach dem #include "tbarmgr.h",
// tbarcust.h:421-447).

inline SECCustomToolBar* SECCustomToolBar::GetConfigFocus() const
{
	if(m_pManager) {
		ASSERT_KINDOF(SECToolBarManager, m_pManager);
		return ((SECToolBarManager*)m_pManager)->GetConfigFocus();
	}

	return NULL;
}

inline void SECCustomToolBar::SetConfigFocus(SECCustomToolBar* pFocus)
{
	if(m_pManager) {
		ASSERT_KINDOF(SECToolBarManager, m_pManager);
		((SECToolBarManager*)m_pManager)->SetConfigFocus(pFocus);
	}
}

inline BOOL SECCustomToolBar::IsTransparent() const
{
	return (BOOL) ((m_dwExStyle & CBRS_EX_COOLBORDERS) &&
				   (m_dwExStyle & CBRS_EX_TRANSPARENT));
}


// tbarcust.h:451-455. Laedt eine Werkzeugleistenressource (RT_TOOLBAR) samt
// zugehoeriger Bitmap. QCToolBarManager.cpp:346, 354, 360 ruft sie dreimal
// auf und setzt die drei Bitmaps danach zu einer zusammen.
BOOL SECLoadToolBarResource(LPCTSTR lpszResourceName, CBitmap& bmp,
							UINT*& pBmpItems, UINT& nBmpItems,
							int& nImgWidth, int& nImgHeight,
							UINT* pBtnCount = NULL,
							UINT** ppBtnArray = NULL);


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 7. tbarpage.h - der Anpassen-Dialog
//
// PLAN.md, Auftragslage: "Der Anpassungsdialog fuer Werkzeugleisten darf ein
// Dummy bleiben." Die drei Klassen hier sind deshalb schlank gehalten. Sie
// sind aber KEINE leeren Huellen: Eudora leitet von SECToolBarCmdPage sechs
// eigene Seiten ab (QCToolBarCmdPage, QCCustomizeGeneralPage,
// QCCustomizePluginsPage, QCCustomizeSignaturesPage,
// QCCustomizeStationeryPage, QCMbxCustomizeToolbarPage) und greift dabei auf
// m_btnGroups, m_pManager, m_nCurSel und SECBtnGroup direkt zu.
//
///////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// SECToolBarSheet  (Original: tbarpage.h:44)
//
// QCToolBarManager.cpp:1042 legt eine Instanz auf dem Stapel an und ruft
// DoModal.

class SECToolBarSheet : public CPropertySheet
{
// Konstruktion
public:
	SECToolBarSheet(UINT nIDCaption = IDS_TOOLBAR_CUSTOMIZE,
					CWnd* pParentWnd = NULL, UINT iSelectPage = 0) :
				CPropertySheet(nIDCaption, pParentWnd, iSelectPage) {}

	SECToolBarSheet(LPCTSTR pszCaption, CWnd* pParentWnd = NULL,
					UINT iSelectPage = 0) :
				CPropertySheet(pszCaption, pParentWnd, iSelectPage) {}

	virtual BOOL OnInitDialog();

protected:
	DECLARE_MESSAGE_MAP()

	afx_msg LRESULT OnFloatStatus(WPARAM, LPARAM);
	afx_msg void OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized);
};

/////////////////////////////////////////////////////////////////////////////
// SECToolBarCmdPage  (Original: tbarpage.h:76)

class SECToolBarCmdPage : public CPropertyPage
{
	DECLARE_DYNCREATE(SECToolBarCmdPage)

// Konstruktion
public:
	SECToolBarCmdPage();
	SECToolBarCmdPage(UINT nIDTemplate, UINT nIDCaption = 0);
	SECToolBarCmdPage(LPCTSTR lpszTemplate, UINT nIDCaption = 0);

protected:
	void Initialize();

// Attribute
public:
	enum { IDD = IDD_TOOLBAR_CUSTOMIZE };

// Operationen
public:
	void SetManager(SECToolBarManager* pManager);
	void DefineBtnGroup(LPCTSTR lpszTitle, int nBtnCount, UINT* lpBtnIDs);

// Ueberschreibbares
protected:
	virtual BOOL OnSetActive();
	virtual BOOL OnKillActive();
	virtual void OnReset();

// Umsetzung
public:
	~SECToolBarCmdPage();

protected:
	// "This has be 'virtualized' so the description id can be changed.
	//  This is a QUALCOMM change!!!" (tbarpage.h:109-111)
	// QCCustomizePluginsPage.cpp:139 ueberschreibt, :162 ruft die Basis.
	virtual void SetDescription(int nID);
	SECCustomToolBar* GetControlBar(UINT nID);

	// QCCustomizeGeneralPage.cpp:63, QCCustomizePluginsPage.cpp:201,216,223,
	// QCMbxCustomizeToolbarPage.cpp:185,227,241, QCToolbarCmdPage.cpp:63,109
	// greifen auf diese Struktur zu.
	struct SECBtnGroup
	{
		SECCustomizeToolBar* pToolBar;		// Leiste dieser Gruppe
		LPCTSTR lpszTitle;					// Titel der Gruppe
		UINT    nBtnCount;					// Anzahl Knoepfe
		UINT*   lpBtnIDs;					// Liste der Knopfkennungen

		SECBtnGroup() : pToolBar(NULL), lpszTitle(NULL), nBtnCount(0),
						lpBtnIDs(0) {}
		~SECBtnGroup();
	};

	CPtrArray          m_btnGroups;			// Feld der Knopfgruppen
	SECToolBarManager* m_pManager;			// mein Leistenverwalter
	int                m_nCurSel;			// gewaehlte Knopfgruppe

	DECLARE_MESSAGE_MAP()

	virtual BOOL OnInitDialog();
	afx_msg void OnSelChange();

	// ABWEICHUNG bei der Nachrichtentabelle, nicht bei der Signatur:
	// tbarpage.h:136-137 deklariert beide als LONG(UINT, LONG). Eudora ruft
	// OnBarNotify mit genau diesen Argumenten auf
	// (QCCustomizeSignaturesPage.cpp:220, QCCustomizeStationeryPage.cpp:219),
	// die Signatur bleibt also unveraendert. In MFC 14 passt sie aber in
	// keinen ON_REGISTERED_MESSAGE-Eintrag mehr; eingetragen wird deshalb ein
	// typrichtiger Umsetzer, siehe OnBarNotifyMsg unten.
	afx_msg LONG OnBarNotify(UINT nID, LONG lParam);
	afx_msg LONG OnToolBarStyleChanging(UINT nEvent, LONG lParam);

private:
	// Zugabe des Shims: typrichtige Eintraege der Nachrichtentabelle, die an
	// die beiden Fassungen oben weiterreichen.
	afx_msg LRESULT OnBarNotifyMsg(WPARAM wParam, LPARAM lParam);
	afx_msg LRESULT OnToolBarStyleChangingMsg(WPARAM wParam, LPARAM lParam);
};

/////////////////////////////////////////////////////////////////////////////
// SECCustomizeToolBar  (Original: tbarpage.h:143)
//
// Die Vorratsleiste im Anpassen-Dialog: sie gibt Knoepfe ab, nimmt aber
// keine an. QCCustomizeToolBar leitet davon ab (QCCustomizeToolBar.h:14).

class SECCustomizeToolBar : public SECCustomToolBar
{
// Konstruktion
public:
	SECCustomizeToolBar();

	DECLARE_DYNAMIC(SECCustomizeToolBar);

// Operationen
public:
	// QCToolbarCmdPage.cpp:95
	void DoSize(CRect& rect);

// Ueberschreibbares
protected:
	virtual void BalanceWrap(int nRow, Wrapped* pWrap);
	virtual BOOL GetDragMode() const;
	virtual BOOL AcceptDrop() const;
};

// tbarpage.h:163. QCToolbarCmdPage.cpp:56
extern void SECConvertDialogUnitsToPixels(HFONT hFont, int& cx, int& cy);


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
// 8. tbartrck.h - SECToolBarRectTracker
//
// QCCustomizeToolBar.cpp:71 legt eine Instanz auf dem Stapel an und ruft
// Track. Das ist der Rahmen, der beim Ziehen eines Knopfes mitwandert.
//
///////////////////////////////////////////////////////////////////////////////

class SECToolBarRectTracker : public CRectTracker
{
public:
// Konstruktion
	SECToolBarRectTracker(LPCRECT lpSrcRect);

// Operationen
	BOOL Track(CWnd* pWnd, CPoint point);
	BOOL HorzDrag(CWnd* pWnd, CPoint point);

	virtual void DrawTrackerRect(LPCRECT lpRect, CWnd* pWndClipTo, CDC* pDC,
								 CWnd* pWnd);

// Umsetzung
protected:
	BOOL TrackHandle(CWnd* pWnd, CPoint point);

private:
	SECToolBarRectTracker();
};


///////////////////////////////////////////////////////////////////////////////
// Waechter der ersetzten Originalheader setzen (siehe Einbindungshinweis oben)

#define __TBTNSTD_H__
#define __TBTNWND_H__
#define __TBTN2PRT_H__
#define __TBTNCMBO_H__
#define __TBARCUST_H__
#define __TBARMGR_H__
#define __TBARPAGE_H__
#define __TBARTRCK_H__


#endif // __OTSHIM_WERKZEUGLEISTE_H__
