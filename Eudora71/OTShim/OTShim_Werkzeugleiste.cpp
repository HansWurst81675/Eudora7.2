// OTShim_Werkzeugleiste.cpp - Ersatzschicht fuer Stingray Objective Toolkit
//                             5.0.1, Stufe 3: Werkzeugleisten und Knoepfe
//
// Zu OTShim_Werkzeugleiste.h. Die Begruendung jeder Abbildung steht dort;
// hier stehen nur die Ruempfe.
//
// UEBERSETZUNG: die Datei bindet <afxwin.h> selbst ein und benutzt Eudoras
// vorkompilierten Header nicht. Beim Einhaengen in Eudora.vcxproj daher fuer
// diese Datei "Vorkompilierte Header: Nicht verwenden" (/Y-) setzen - genau
// wie fuer OTShim.cpp.
//
// Kodierung: reines ASCII, kein BOM.

#include <afxwin.h>
#include <afxext.h>
#include <afxpriv.h>		// AfxFindResourceHandle

#include "OTShim_Werkzeugleiste.h"

// secaux.cpp:23 legt dieses Objekt an. Der Zeichencode liest es unmittelbar,
// genau wie Eudora es tut (TBarSendButton.cpp:74, MoodMailStatic.cpp:63,
// QCCustomizeToolBar.cpp:17).
extern SEC_AUX_DATA secData;


/////////////////////////////////////////////////////////////////////////////
// Sammelmeldung fuer Nichtumgesetztes
//
// Wortgleich zu OTShimNichtUmgesetzt (OTShim.cpp:154), nur mit der
// Stufenangabe dieser Datei. Beim Zusammenlegen bleibt eine von beiden.

void OTShimWzlNichtUmgesetzt(BOOL& rbBereitsGemeldet, LPCTSTR lpszWas)
{
	if (rbBereitsGemeldet)
		return;

	rbBereitsGemeldet = TRUE;

	CString strMeldung;
	strMeldung.Format(
		_T("Diese Funktion steht in dieser Fassung nicht zur Verfuegung:\n\n")
		_T("    %s\n\n")
		_T("Der Ersatz fuer das Stingray Objective Toolkit bildet die ")
		_T("Werkzeugleisten nach, aber nicht das Anpassen von Leisten und ")
		_T("nicht das Ziehen von Knoepfen.\n\n")
		_T("Diese Meldung erscheint nur einmal je Sitzung."),
		lpszWas);

	::AfxMessageBox(strMeldung, MB_OK | MB_ICONINFORMATION);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 0 - SafetyPal (CSafetyPalette, CPaletteDC)
//
// NICHT URSPRUENGLICH TEIL VON STUFE 3, ABER OHNE SIE GEHT ES NICHT.
//
// OT501/Include/SafetyPal.h deklariert CSafetyPalette und CPaletteDC. Eine
// zugehoerige SafetyPal.cpp gibt es im gesamten Baum nicht - weder unter
// OT501/Src (dort stehen von 186 erwarteten Quelldateien nur 67, siehe
// PLAN.md) noch unter Eudora/. OT501.vcxproj:297 fuehrt nur den Header.
//
// SECBtnDrawData hat drei CPaletteDC als Wertfelder (tbtnstd.h:48-50), und
// QCCustomToolBar, QCChildToolBar und QCCustomizeToolBar haben je ein
// CSafetyPalette (m_Palette). Ohne Rumpf fuer Konstruktor und Destruktor
// laesst sich Stufe 3 nicht binden. Ausserdem benutzen AdView.cpp,
// eudora.cpp, tocview.cpp, QCGraphics.cpp und LinkHistoryManager.cpp diese
// Klassen unabhaengig von den Werkzeugleisten.
//
// WAS DIE KLASSEN URSPRUENGLICH TATEN
//   Auf Bildschirmen mit 256 Farben teilt sich Windows die Farbtafel
//   zwischen allen Fenstern auf. Eine Anwendung, die viele Bilder anzeigt,
//   legt dafuer eine feste "sichere" Farbtafel an und meldet sie bei jedem
//   WM_QUERYNEWPALETTE und WM_PALETTECHANGED neu an. Genau das ist der
//   Zweck dieser beiden Klassen.
//
// WARUM HIER EIN LEERLAUF STEHT
//   Farbtafeln wirken nur auf Geraeten mit RC_PALETTE, also bei hoechstens
//   8 Bit Farbtiefe. Seit Windows Vista gibt es diesen Anzeigemodus nicht
//   mehr; jeder Bildschirm liefert mindestens 32 Bit. Die Anmeldung waere
//   also in jedem Fall ein Leerlauf. Ein echter Nachbau haette keinen
//   messbaren Anteil am Ergebnis, koennte aber Farben verfaelschen.
//
//   Deshalb: die Anmeldewege tun nichts, die reinen Zeichenwege
//   (CPaletteDC::CreateCDC, BitBlt, BitBltTransparent) arbeiten wirklich.
//   IsPaletteDevice fragt das Geraet ehrlich ab, damit ein spaeterer echter
//   Nachbau eine belastbare Weiche vorfindet.
//
// KEINE HINWEISMELDUNG: hier faellt keine vom Anwender ausloesbare Funktion
// aus. Auf heutigen Bildschirmen ist das Ergebnis dasselbe wie im Original.

PALETTEENTRY SafetyPaletteArray[256];
PALETTEENTRY MirrorPaletteArray[256];
HPALETTE ghPaletteSafety = NULL;
HPALETTE ghPaletteMirror = NULL;
bool gbSafetyPaletteReady = false;
bool gbMirrorPaletteReady = false;
bool gbUseMirrorPalette = false;
bool gbMirrorPaletteChanged = false;

// eudora.cpp meldet damit die Farbtafel aus einer Ressource an. Ohne
// Farbtafelgeraete gibt es nichts anzumelden.
bool SetSafetyPalette(int /*SafetyPaletteResource*/)
{
	return true;
}

bool SetMirrorPalette(void)
{
	return true;
}

void FreePalettes(void)
{
	// Es wurde nie eine Farbtafel angelegt.
}


CSafetyPalette::CSafetyPalette()
{
	m_LasthPalette = NULL;
	m_LastHDC = NULL;
	m_bCurrentPaletteIsSafetyPalette = false;
	m_bCurrentPaletteIsMirrorPalette = false;
	m_bMyPaletteSelected = false;
}

CSafetyPalette::~CSafetyPalette()
{
	Free();
}

void CSafetyPalette::Create(bool /*bUseMirrorPalette*/)
{
	// Nichts anzulegen - siehe Abschnittskommentar.
}

void CSafetyPalette::Free(void)
{
	Unselect();
}

void CSafetyPalette::Select(HDC hdc, bool /*bBackground*/)
{
	// Nur merken, welcher Kontext zuletzt gefragt hat; ausgewaehlt wird
	// nichts, weil GetPalette() NULL liefert.
	m_LastHDC = hdc;
}

void CSafetyPalette::Unselect(void)
{
	m_LastHDC = NULL;
	m_bMyPaletteSelected = false;
}

void CSafetyPalette::Realize(HDC /*hdc*/, int* pNumColors)
{
	// Kein Farbeintrag wurde umgesetzt.
	if (pNumColors != NULL)
		*pNumColors = 0;
}

HPALETTE CSafetyPalette::GetPalette(void)
{
	return NULL;
}

// Rueckgabe FALSE heisst "es hat sich nichts geaendert, kein Neuzeichnen
// noetig". QCCustomToolBar::OnMyQueryNewPalette wertet genau das aus.
bool CSafetyPalette::DoQueryNewPalette(CWnd* /*pThisWindow*/)
{
	return false;
}

void CSafetyPalette::DoPaletteChanged(CWnd* /*pThisWindow*/, CWnd* /*pFocusWindow*/)
{
}

void CSafetyPalette::DoSysColorChange(CWnd* /*pThisWindow*/)
{
}

// Als einzige Methode arbeitet diese wirklich: sie fragt das Geraet.
bool CSafetyPalette::IsPaletteDevice(HDC hdc)
{
	if (hdc == NULL)
		return false;

	return (::GetDeviceCaps(hdc, RASTERCAPS) & RC_PALETTE) != 0;
}


CPaletteDC::CPaletteDC()
{
	bSelected = false;
}

CPaletteDC::~CPaletteDC()
{
	// CDC::~CDC gibt einen selbst angelegten Kontext frei.
}

BOOL CPaletteDC::CreateCDC(void)
{
	// Bildschirmvertraeglicher Speicherkontext. NULL als Vorlage bedeutet
	// "wie der Bildschirm" - genau das, was die Aufrufer brauchen
	// (QCToolBarManager.cpp:402 legt so den Quell- und Zielkontext an).
	return CDC::CreateCompatibleDC(NULL);
}

BOOL CPaletteDC::CreateCompatibleDC(CDC* pDC)
{
	return CDC::CreateCompatibleDC(pDC);
}

void CPaletteDC::Realize(int* pNumColors)
{
	if (pNumColors != NULL)
		*pNumColors = 0;
}

BOOL CPaletteDC::BitBlt(int x, int y, int nWidth, int nHeight, CDC* pSrcDC,
						int xSrc, int ySrc, DWORD dwRop)
{
	return CDC::BitBlt(x, y, nWidth, nHeight, pSrcDC, xSrc, ySrc, dwRop);
}

// Kopiert und laesst dabei alle Bildpunkte der Farbe xcolor stehen.
// Nachgebaut ueber eine einfarbige Maske, weil ::TransparentBlt aus msimg32
// eine zusaetzliche Bindung waere und bei gekachelten Aufrufen bekannt
// langsam ist.
BOOL CPaletteDC::BitBltTransparent(int x, int y, int nWidth, int nHeight,
								   CDC* pSrcDC, int xSrc, int ySrc,
								   COLORREF xcolor)
{
	if (pSrcDC == NULL || nWidth <= 0 || nHeight <= 0)
		return FALSE;

	CDC dcMask;
	if (!dcMask.CreateCompatibleDC(pSrcDC))
		return FALSE;

	CBitmap bmMask;
	if (!bmMask.CreateBitmap(nWidth, nHeight, 1, 1, NULL))
		return FALSE;

	CBitmap* pOldMask = dcMask.SelectObject(&bmMask);

	// Farbe -> einfarbig: Bildpunkte in Hintergrundfarbe werden weiss (1),
	// alle uebrigen schwarz (0).
	COLORREF crOldBk = pSrcDC->SetBkColor(xcolor);
	dcMask.BitBlt(0, 0, nWidth, nHeight, pSrcDC, xSrc, ySrc, SRCCOPY);
	pSrcDC->SetBkColor(crOldBk);

	// Ziel dort loeschen, wo Farbe kommt; Quelle dort ausblenden, wo die
	// Maske gesetzt ist; beides verodern.
	CDC dcTmp;
	CBitmap bmTmp;
	if (dcTmp.CreateCompatibleDC(this) &&
		bmTmp.CreateCompatibleBitmap(this, nWidth, nHeight))
	{
		CBitmap* pOldTmp = dcTmp.SelectObject(&bmTmp);

		dcTmp.BitBlt(0, 0, nWidth, nHeight, pSrcDC, xSrc, ySrc, SRCCOPY);
		dcTmp.BitBlt(0, 0, nWidth, nHeight, &dcMask, 0, 0, 0x00220326L);	// DSna
		CDC::BitBlt(x, y, nWidth, nHeight, &dcMask, 0, 0, SRCAND);
		CDC::BitBlt(x, y, nWidth, nHeight, &dcTmp, 0, 0, SRCPAINT);

		dcTmp.SelectObject(pOldTmp);
	}

	dcMask.SelectObject(pOldMask);
	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 1 - SECBtnDrawData
//
/////////////////////////////////////////////////////////////////////////////

SECBtnDrawData::SECBtnDrawData()
{
	m_pOldBmpDraw = NULL;
	m_pOldBmpMono = NULL;
	m_hOldBmp     = NULL;
	m_cxBuf       = 0;
	m_cyBuf       = 0;
	m_bReady      = FALSE;
}

SECBtnDrawData::~SECBtnDrawData()
{
	PostDrawButton();
}

// Der Schachbrettpinsel fuer angekreuzte und unbestimmte Knoepfe: ein
// 8x8-Muster aus abwechselnd gesetzten Bildpunkten. Dieselbe Machart wie
// AfxGetDitherBrush in MFC (winctrl3.cpp), nur ohne dessen Zwischenspeicher.
HBRUSH SECBtnDrawData::CreateDitherBrush()
{
	WORD wPattern[8];
	for (int i = 0; i < 8; i++)
		wPattern[i] = (WORD)(0x5555 << (i & 1));

	CBitmap bmPattern;
	if (!bmPattern.CreateBitmap(8, 8, 1, 1, wPattern))
		return NULL;

	CBrush br;
	if (!br.CreatePatternBrush(&bmPattern))
		return NULL;

	return (HBRUSH)br.Detach();
}

// Systemfarben haben sich geaendert - der Pinsel selbst ist einfarbig und
// bleibt gueltig, aber ein zwischengespeicherter Zeichenpuffer nicht.
// SECToolBarManager::SysColorChange ruft das auf.
void SECBtnDrawData::SysColorChange()
{
	PostDrawButton();

	if (m_ditherBrush.GetSafeHandle() != NULL)
		m_ditherBrush.DeleteObject();
}

// Richtet die drei Kontexte ein. Laeuft einmal je Zeichenvorgang, VOR der
// Knopfschleife - belegt durch EmoticonToolbarButton.cpp:93-96, das in
// data.m_bmpDC hineinmalt, bevor SECTwoPartBtn::DrawButton laeuft.
BOOL SECBtnDrawData::PreDrawButton(CDC& dc, HBITMAP hBmp, int nMaxBtnWidth,
								   SECCustomToolBar* pToolBar)
{
	ASSERT(pToolBar != NULL);
	if (hBmp == NULL || pToolBar == NULL)
		return FALSE;

	if (m_bReady)
		// Verschachtelter Aufruf - das darf nicht vorkommen.
		PostDrawButton();

	int cx = max(nMaxBtnWidth, pToolBar->GetStdBtnWidth());
	int cy = pToolBar->GetStdBtnHeight();
	if (cx <= 0 || cy <= 0)
		return FALSE;

	// 1. Kontext mit der Leistenbitmap
	if (m_bmpDC.GetSafeHdc() == NULL && !m_bmpDC.CreateCompatibleDC(&dc))
		return FALSE;
	m_hOldBmp = ::SelectObject(m_bmpDC.GetSafeHdc(), hBmp);

	// 2. Zwischenpuffer in Groesse eines Knopfes
	if (m_drawDC.GetSafeHdc() == NULL && !m_drawDC.CreateCompatibleDC(&dc))
	{
		::SelectObject(m_bmpDC.GetSafeHdc(), m_hOldBmp);
		return FALSE;
	}

	if (m_bmpDraw.GetSafeHandle() == NULL || cx != m_cxBuf || cy != m_cyBuf)
	{
		if (m_bmpDraw.GetSafeHandle() != NULL)
			m_bmpDraw.DeleteObject();
		if (m_bmpMono.GetSafeHandle() != NULL)
			m_bmpMono.DeleteObject();

		if (!m_bmpDraw.CreateCompatibleBitmap(&dc, cx, cy) ||
			!m_bmpMono.CreateBitmap(cx, cy, 1, 1, NULL))
		{
			::SelectObject(m_bmpDC.GetSafeHdc(), m_hOldBmp);
			return FALSE;
		}

		m_cxBuf = cx;
		m_cyBuf = cy;
	}

	m_pOldBmpDraw = m_drawDC.SelectObject(&m_bmpDraw);

	// 3. einfarbige Maske
	if (m_monoDC.GetSafeHdc() == NULL && !m_monoDC.CreateCompatibleDC(NULL))
	{
		m_drawDC.SelectObject(m_pOldBmpDraw);
		m_pOldBmpDraw = NULL;
		::SelectObject(m_bmpDC.GetSafeHdc(), m_hOldBmp);
		return FALSE;
	}
	m_pOldBmpMono = m_monoDC.SelectObject(&m_bmpMono);

	if (m_ditherBrush.GetSafeHandle() == NULL)
	{
		HBRUSH hBrush = CreateDitherBrush();
		if (hBrush != NULL)
			m_ditherBrush.Attach(hBrush);
	}

	m_bReady = TRUE;
	return TRUE;
}

void SECBtnDrawData::PostDrawButton()
{
	if (!m_bReady)
		return;

	if (m_pOldBmpMono != NULL)
	{
		m_monoDC.SelectObject(m_pOldBmpMono);
		m_pOldBmpMono = NULL;
	}

	if (m_pOldBmpDraw != NULL)
	{
		m_drawDC.SelectObject(m_pOldBmpDraw);
		m_pOldBmpDraw = NULL;
	}

	if (m_hOldBmp != NULL && m_bmpDC.GetSafeHdc() != NULL)
	{
		::SelectObject(m_bmpDC.GetSafeHdc(), m_hOldBmp);
		m_hOldBmp = NULL;
	}

	m_bReady = FALSE;
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 2 - SECStdBtn
//
/////////////////////////////////////////////////////////////////////////////

// tbtnstd.h:185-187 deklariert die drei Erzeugungshilfen von Hand, aber in
// genau der Form, die IMPLEMENT_BUTTON definiert. Deshalb reicht das Makro.
IMPLEMENT_BUTTON(SECStdBtn)

SECStdBtn* SECButtonClass::CreateButton()
{
	ASSERT(m_pfnCreateButton != NULL);
	if (m_pfnCreateButton == NULL)
		return NULL;

	return (*m_pfnCreateButton)();
}


SECStdBtn::SECStdBtn()
{
	m_nID      = 0;
	m_nImage   = 0;
	m_nStyle   = TBBS_BUTTON;
	m_x        = 0;
	m_y        = 0;
	m_cx       = SEC_TOOLBAR_BTN_WIDTH;
	m_cy       = SEC_TOOLBAR_BTN_HEIGHT;
	m_ulData   = 0;
	m_pToolBar = NULL;
}

SECStdBtn::~SECStdBtn()
{
}

void SECStdBtn::SetToolBar(SECCustomToolBar* pToolBar)
{
	m_pToolBar = pToolBar;
}

void SECStdBtn::GetBtnRect(CRect& rect) const
{
	rect.SetRect(m_x, m_y, m_x + m_cx, m_y + m_cy);
}

// Der einfache Knopf hat waagerecht wie senkrecht dieselbe Gestalt. Erst
// SECTwoPartBtn und SECWndBtn haben hier wirklich etwas zu tun.
void SECStdBtn::SetMode(BOOL /*bVertical*/)
{
}

void SECStdBtn::SetPos(int x, int y)
{
	m_x = x;
	m_y = y;
}

void SECStdBtn::Invalidate(BOOL bErase) const
{
	if (m_pToolBar == NULL || m_pToolBar->GetSafeHwnd() == NULL)
		return;

	CRect rect;
	GetBtnRect(rect);
	m_pToolBar->InvalidateRect(rect, bErase);
}

// Wird von SECCustomToolBar::CreateButton unmittelbar nach dem Anlegen
// gerufen. pData zeigt auf SECBtnMapEntry::m_nData (fuenf Werte); der
// einfache Knopf wertet nichts davon aus - STD_BUTTON liefert nur Nullen
// (tbtnstd.h:235-236).
void SECStdBtn::Init(SECCustomToolBar* pToolBar, const UINT* /*pData*/)
{
	m_pToolBar = pToolBar;
	AdjustSize();
}

// Die Leistenbitmap hat sich geaendert - Groesse neu bestimmen.
// TBarSendButton.cpp:26-62 und MoodMailStatic.cpp:32 rufen diese Fassung
// zuerst auf und vergroessern danach m_cx.
void SECStdBtn::AdjustSize()
{
	if (m_pToolBar == NULL)
		return;

	if (m_nStyle & TBBS_SEPARATOR)
	{
		m_cx = m_pToolBar->GetSepWidth();
		m_cy = m_pToolBar->GetSepHeight();
	}
	else
	{
		m_cx = m_pToolBar->GetStdBtnWidth();
		m_cy = m_pToolBar->GetStdBtnHeight();
	}
}

// tbtnstd.h:156-157: Zustandsablage beim Sichern einer Leiste. Der einfache
// Knopf hat keinen eigenen Zustand - seine Kennung steht schon in
// SECCustomToolBarInfoEx::BtnInfo::m_nID.
//
// QCCustomToolBar.cpp:356-359 prueft ASSERT(pBtnInfo->m_pExtraInfo == NULL)
// VOR dem Aufruf und uebergibt danach die beiden Zeiger unbesehen weiter;
// wer hier etwas belegt, muss es also mit new[] tun, weil
// SECCustomToolBarInfoEx::BtnInfo::~BtnInfo es wieder freigibt.
void SECStdBtn::GetBtnInfo(BYTE* nSize, LPBYTE* ppInfo) const
{
	if (nSize != NULL)
		*nSize = 0;
	if (ppInfo != NULL)
		*ppInfo = NULL;
}

void SECStdBtn::SetBtnInfo(BYTE /*nSize*/, const LPBYTE /*pInfo*/)
{
}

// Die Leiste hat ihren Stil gewechselt (etwa CBRS_FLYBY). Der einfache Knopf
// zieht daraus keine Folgerung; die Fassung bleibt fuer die Vererbungskette.
void SECStdBtn::BarStyleChanged(DWORD /*dwStyle*/)
{
}

// tbtnstd.h:148. Einzige benutzte Kennung ist Styles.
void SECStdBtn::InformBtn(UINT nCode, void* pData)
{
	if (nCode != Styles || pData == NULL)
		return;

	StyleChange* pChange = (StyleChange*)pData;
	UINT nOld = m_nStyle;

	m_nStyle &= ~((UINT)pChange->dwRemove);
	m_nStyle |= (UINT)pChange->dwAdd;

	if (m_nStyle != nOld)
		Invalidate();
}

// Kurzhinweis. Die Rueckgabe ist die Treffernummer; TBarSendButton.cpp:207
// gibt m_nID zurueck, also ist das die verbindliche Bedeutung.
int SECStdBtn::OnToolHitTest(CPoint point, TOOLINFO* pTI) const
{
	CRect rect;
	GetBtnRect(rect);

	if (!rect.PtInRect(point))
		return -1;

	if (m_nStyle & TBBS_SEPARATOR)
		return -1;

	if (pTI != NULL)
	{
		pTI->uFlags      = 0;
		pTI->hwnd        = m_pToolBar ? m_pToolBar->GetSafeHwnd() : NULL;
		pTI->lpszText    = LPSTR_TEXTCALLBACK;
		pTI->rect        = rect;
		pTI->uId         = m_nID;
	}

	return (int)m_nID;
}


/////////////////////////////////////////////////////////////////////////////
// SECStdBtn - Maus

// Rueckgabe TRUE heisst "der Druck ist angenommen, der Knopf ist unten".
// CTBarMenuButton.cpp:37-40 prueft genau das und bricht bei FALSE ab.
BOOL SECStdBtn::BtnPressDown(CPoint point)
{
	if (m_nStyle & (TBBS_SEPARATOR | TBBS_DISABLED))
		return FALSE;

	CRect rect;
	GetBtnRect(rect);
	if (!rect.PtInRect(point))
		return FALSE;

	m_nStyle |= TBBS_PRESSED;
	m_nStyle &= ~SEC_TBBS_RAISED;
	Invalidate();

	return TRUE;
}

// Waehrend die Maustaste unten ist: der Knopf springt hoch, sobald der
// Zeiger den Knopf verlaesst, und wieder herunter, sobald er zurueckkehrt.
void SECStdBtn::BtnPressMouseMove(CPoint point)
{
	CRect rect;
	GetBtnRect(rect);

	UINT nOld = m_nStyle;
	if (rect.PtInRect(point))
		m_nStyle |= TBBS_PRESSED;
	else
		m_nStyle &= ~TBBS_PRESSED;

	if (m_nStyle != nOld)
		Invalidate();
}

void SECStdBtn::BtnPressCancel()
{
	if (m_nStyle & TBBS_PRESSED)
	{
		m_nStyle &= ~TBBS_PRESSED;
		Invalidate();
	}
}

// Rueckgabe ist die abzusetzende Befehlskennung oder 0. Die 0 kommt, wenn
// die Maustaste ausserhalb des Knopfes losgelassen wurde.
UINT SECStdBtn::BtnPressUp(CPoint point)
{
	BOOL bWasDown = (m_nStyle & TBBS_PRESSED) != 0;

	if (bWasDown)
	{
		m_nStyle &= ~TBBS_PRESSED;
		Invalidate();
	}

	CRect rect;
	GetBtnRect(rect);
	if (!rect.PtInRect(point))
		return 0;

	return m_nID;
}


/////////////////////////////////////////////////////////////////////////////
// SECStdBtn - Zeichnen
//
// DIE VORLAGE: TBarSendButton.cpp:71-160 ist eine vollstaendige Kopie der
// Original-Logik von DrawFace, weil Eudora sie ueberschreiben musste, um den
// Text "Send"/"Queue" hinzuzufuegen. Dieselbe Kopie steht ein zweites Mal,
// auskommentiert, in MoodMailStatic.cpp:63-120. Beide stimmen Zeile fuer
// Zeile ueberein - das ist der Grund, warum der Zeichencode hier abgelesen
// und nicht geraten ist.
//
// Aus der Vorlage folgt der ganze Vertrag:
//   - Ziel ist data.m_drawDC, ein Puffer in Groesse EINES Knopfes.
//   - x, y, nWidth, nHeight kommen als Referenz herein und beschreiben beim
//     Eintritt den ganzen Knopf; DrawFace zieht den Rahmen ab und gibt die
//     innere Flaeche zurueck. Belegt durch ColorToolbarButton.cpp:53-73, das
//     nach dem Basisaufruf mit den veraenderten x/y weiterrechnet.
//   - bForce == TRUE heisst "zeichne den Knopf oben und freigegeben,
//     unabhaengig vom Stil" (Kommentar TBarSendButton.cpp:75-76).
//   - nImgWidth == -1 heisst "volle Bildbreite".

void SECStdBtn::DrawFace(SECBtnDrawData& data, BOOL bForce, int& x, int& y,
						 int& nWidth, int& nHeight, int nImgWidth)
{
	if (m_pToolBar == NULL)
		return;

	if (nImgWidth == -1)
		nImgWidth = m_pToolBar->GetImgWidth();

	// Lage des Bildes ausrechnen
	int xImg = (m_pToolBar->GetStdBtnWidth() - nImgWidth - 1)/2 + x;
	int yImg = (nHeight - m_pToolBar->GetImgHeight())/2 + y;

	BOOL bCool = m_pToolBar->CoolLookEnabled();

	// Zuerst der Hintergrund
	data.m_drawDC.FillSolidRect(x, y, nWidth, nHeight, secData.clrBtnFace);

	// Dann die Raender
	if(m_nStyle & (TBBS_PRESSED | TBBS_CHECKED) && !bForce)
	{
		// Knopf ist unten
		data.m_drawDC.Draw3dRect(x, y, nWidth, nHeight,
								 bCool ? secData.clrBtnShadow :
								 		 secData.clrWindowFrame,
								 secData.clrBtnHilite);
		x++; y++; nWidth -= 2; nHeight -= 2;
		if(!bCool)
		{
			data.m_drawDC.Draw3dRect(x, y, nWidth, nHeight,
									 secData.clrBtnShadow,
									 secData.clrBtnFace);
		}

		x++; y++; nWidth -= 2; nHeight -= 2;

		// Bild versetzen, damit die Bewegung sichtbar wird.
		xImg++; yImg++;
	}
	else if(bCool && (m_nStyle & SEC_TBBS_RAISED) && !bForce)
	{
		data.m_drawDC.Draw3dRect(x, y, nWidth, nHeight, secData.clrBtnHilite,
					 			 secData.clrBtnShadow);
		x += 2; y += 2; nWidth -= 4; nHeight -= 4;
	}
	else if(bCool)
	{
		// Knopf ist oben
		x += 2; y += 2; nWidth -= 4; nHeight -= 4;
	}
	else
	{
		// Knopf ist oben
		data.m_drawDC.Draw3dRect(x, y, nWidth, nHeight, secData.clrBtnHilite,
								 secData.clrWindowFrame);
		x++; y++; nWidth -= 2; nHeight -= 2;
		data.m_drawDC.Draw3dRect(x, y, nWidth, nHeight, secData.clrBtnFace,
								 secData.clrBtnShadow);
		x++; y++; nWidth -= 2; nHeight -= 2;
	}

	// Und zuletzt das Bild. Bei nImgWidth == 0 faellt das BitBlt aus - so
	// verlangt es der zweite Teil eines SECTwoPartBtn, der statt eines
	// Bildes ein gezeichnetes Dreieck bekommt.
	if (nImgWidth > 0)
	{
		data.m_drawDC.BitBlt(xImg, yImg, nImgWidth, m_pToolBar->GetImgHeight(),
							 &data.m_bmpDC, m_nImage * m_pToolBar->GetImgWidth(),
							 0, SRCCOPY);
	}
}

// Erzeugt in data.m_monoDC eine einfarbige Maske der angegebenen Flaeche:
// alles, was die Knopffarbe hat, wird weiss (1), alles Uebrige - also das
// Bild - schwarz (0). Das ist die uebliche GDI-Regel beim Kopieren von
// Farbe nach Einfarbig: die Hintergrundfarbe des Quellkontextes wird zu 1.
void SECStdBtn::CreateMask(SECBtnDrawData& data, int x, int y, int nWidth,
						   int nHeight)
{
	COLORREF crOld = data.m_drawDC.SetBkColor(secData.clrBtnFace);
	data.m_monoDC.BitBlt(0, 0, nWidth, nHeight, &data.m_drawDC, x, y, SRCCOPY);
	data.m_drawDC.SetBkColor(crOld);
}

// Der gesperrte Knopf: das Bild wird zweimal einfarbig nachgezogen, hell
// nach unten rechts versetzt und dunkel an Ort und Stelle. Das ergibt den
// eingepraegten Eindruck, den Windows seit jeher fuer gesperrte
// Bedienelemente benutzt.
//
// Die Verknuepfungszahl 0x00B8074A (PSDPxax) malt den Pinsel genau dort, wo
// die Maske 0 ist. Sie steht auch in Eudoras eigenem Quelltext:
// EmoticonToolbarButton.cpp:40  const DWORD MAGICROP = 0xb8074a;
#define OTSHIM_ROP_MASKED_PATTERN	0x00B8074AL

void SECStdBtn::DrawDisabled(SECBtnDrawData& data, int x, int y, int nWidth,
							 int nHeight)
{
	if (nWidth <= 0 || nHeight <= 0)
		return;

	CreateMask(data, x, y, nWidth, nHeight);

	CBrush brHilite(secData.clrBtnHilite);
	CBrush brShadow(secData.clrBtnShadow);

	CBrush* pOld = data.m_drawDC.SelectObject(&brHilite);
	data.m_drawDC.BitBlt(x + 1, y + 1, nWidth, nHeight, &data.m_monoDC, 0, 0,
						 OTSHIM_ROP_MASKED_PATTERN);

	data.m_drawDC.SelectObject(&brShadow);
	data.m_drawDC.BitBlt(x, y, nWidth, nHeight, &data.m_monoDC, 0, 0,
						 OTSHIM_ROP_MASKED_PATTERN);

	data.m_drawDC.SelectObject(pOld);
}

// Angekreuzter Knopf: der HINTERGRUND bekommt das Schachbrettmuster, das
// Bild bleibt unangetastet. Deshalb wird die Maske umgedreht - so trifft
// dieselbe Verknuepfungszahl diesmal die Flaeche statt des Bildes.
void SECStdBtn::DrawChecked(SECBtnDrawData& data, int x, int y, int nWidth,
							int nHeight)
{
	if (nWidth <= 0 || nHeight <= 0)
		return;

	if (data.m_ditherBrush.GetSafeHandle() == NULL)
		return;

	CreateMask(data, x, y, nWidth, nHeight);
	data.m_monoDC.PatBlt(0, 0, nWidth, nHeight, DSTINVERT);

	COLORREF crOldText = data.m_drawDC.SetTextColor(secData.clrBtnHilite);
	COLORREF crOldBk   = data.m_drawDC.SetBkColor(secData.clrBtnFace);

	CBrush* pOld = data.m_drawDC.SelectObject(&data.m_ditherBrush);
	data.m_drawDC.BitBlt(x, y, nWidth, nHeight, &data.m_monoDC, 0, 0,
						 OTSHIM_ROP_MASKED_PATTERN);
	data.m_drawDC.SelectObject(pOld);

	data.m_drawDC.SetBkColor(crOldBk);
	data.m_drawDC.SetTextColor(crOldText);
}

// Der unbestimmte Zustand (TBBS_INDETERMINATE) sieht wie der angekreuzte
// aus, nur mit gesperrtem Bild darueber. Eudora benutzt ihn fuer die
// Auszeichnungsknoepfe bei gemischter Auswahl
// (CompMessageFrame.cpp:140-144  STD_BUTTON(..., TBBS_INDETERMINATE)).
void SECStdBtn::DrawIndeterminate(SECBtnDrawData& data, int x, int y,
								  int nWidth, int nHeight)
{
	DrawChecked(data, x, y, nWidth, nHeight);
	DrawDisabled(data, x, y, nWidth, nHeight);
}

// Der Knopf, der im Anpassen-Modus gerade ausgewaehlt ist, bekommt einen
// gestrichelten Rahmen - wie der Tastaturfokus in einem Dialog.
void SECStdBtn::DrawConfigFocus(SECBtnDrawData& data)
{
	CRect rect(0, 0, m_cx, m_cy);
	data.m_drawDC.DrawFocusRect(rect);
}

// Der ganze Knopf. Gemalt wird in den Zwischenpuffer, danach geht genau ein
// BitBlt auf den Bildschirm - deshalb flackert nichts.
void SECStdBtn::DrawButton(CDC& dc, SECBtnDrawData& data)
{
	if (m_pToolBar == NULL)
		return;

	if (m_nStyle & TBBS_HIDDEN)
		return;

	if (m_nStyle & TBBS_SEPARATOR)
	{
		// Der Trenner wird unmittelbar auf den Bildschirm gezeichnet: eine
		// eingelassene Linie in der Mitte. Bei senkrecht angedockter Leiste
		// liegt sie waagerecht.
		CRect rect;
		GetBtnRect(rect);

		if (rect.Width() > rect.Height())
			dc.Draw3dRect(rect.left, rect.top + rect.Height()/2 - 1,
						  rect.Width(), 2,
						  secData.clrBtnShadow, secData.clrBtnHilite);
		else
			dc.Draw3dRect(rect.left + rect.Width()/2 - 1, rect.top,
						  2, rect.Height(),
						  secData.clrBtnShadow, secData.clrBtnHilite);
		return;
	}

	// Puffer zu klein? Dann lieber gar nichts malen als darueber hinaus.
	if (m_cx > data.m_cxBuf || m_cy > data.m_cyBuf)
		return;

	int x = 0, y = 0;
	int nWidth = m_cx, nHeight = m_cy;

	DrawFace(data, FALSE, x, y, nWidth, nHeight);

	if (m_nStyle & TBBS_INDETERMINATE)
		DrawIndeterminate(data, x, y, nWidth, nHeight);
	else if (m_nStyle & TBBS_CHECKED)
		DrawChecked(data, x, y, nWidth, nHeight);

	if (m_nStyle & TBBS_DISABLED)
		DrawDisabled(data, x, y, nWidth, nHeight);

	if (m_nStyle & SEC_TBBS_FOCUS)
		DrawConfigFocus(data);

	dc.BitBlt(m_x, m_y, m_cx, m_cy, &data.m_drawDC, 0, 0, SRCCOPY);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 3 - SECWndBtn
//
// Ein Knopf, der in Wahrheit ein Kindfenster ist. Die Rollenverteilung ist
// durch die drei nachgebauten Eudora-Klassen belegt (TBarStatic.cpp,
// TBarEdit.cpp, TBarBmpCombo.cpp) und durch die einzige erhaltene
// Schwesterklasse CTBarComboBtn (TBarCombo.cpp):
//
//   CreateWnd  legt das Fenster an und ruft danach OnFontCreateAndSet und
//              AdjustSize (TBarCombo.cpp:33-36)
//   LButtonXxx bekommt jedes Mausereignis ZUERST; TRUE heisst "erledigt"
//              (TBarStatic.cpp:199-233)
//   SetCursor  TRUE heisst "ich habe den Zeiger gesetzt"
//              (TBarStatic.cpp:241-247)
//   AdjustSize meldet die Breite an die Leiste zurueck
//              (TBarStatic.cpp:130-156)
//
/////////////////////////////////////////////////////////////////////////////

HCURSOR SECWndBtn::hCurHorzDrag = NULL;

SECWndBtn::SECWndBtn()
{
	m_bWndVisible = TRUE;
	m_nSize       = 0;
	m_nMinSize    = 0;
	m_nHeight     = 0;
	m_nRealHeight = 0;

	if (hCurHorzDrag == NULL)
		hCurHorzDrag = ::LoadCursor(NULL, IDC_SIZEWE);
}

// pData ist SECBtnMapEntry::m_nData, gefuellt von WND_BUTTON
// (tbtnwnd.h:137-140):
//     pData[0]  Fensterkennung des Kindfensters
//     pData[1]  Fensterstil
//     pData[2]  MAKELONG(Vorgabebreite, Mindestbreite)
//     pData[3]  gewuenschte Hoehe
//     pData[4]  unbenutzt
// Beispiel: CompMessageFrame.cpp:153
//     BMPCOMBO_BUTTON( ID_PRIORITY, IDC_PRIORITY_COMBO, 0, CBS_DROPDOWN,
//                      150, 40, 150 )
void SECWndBtn::Init(SECCustomToolBar* pToolBar, const UINT* pData)
{
	m_pToolBar = pToolBar;

	int   nWndID   = 0;
	DWORD dwStyle  = 0;

	if (pData != NULL)
	{
		nWndID    = (int)pData[0];
		dwStyle   = (DWORD)pData[1];
		m_nSize   = (int)LOWORD(pData[2]);
		m_nMinSize= (int)HIWORD(pData[2]);
		m_nHeight = (int)pData[3];
	}

	if (m_nSize <= 0)
		m_nSize = pToolBar ? pToolBar->GetStdBtnWidth() : SEC_TOOLBAR_BTN_WIDTH;
	if (m_nMinSize <= 0)
		m_nMinSize = m_nSize;
	if (m_nHeight <= 0)
		m_nHeight = pToolBar ? pToolBar->GetStdBtnHeight() : SEC_TOOLBAR_BTN_HEIGHT;

	m_cx = m_nSize;
	m_cy = pToolBar ? pToolBar->GetStdBtnHeight() : SEC_TOOLBAR_BTN_HEIGHT;
	m_nRealHeight = m_nHeight;

	// WS_CHILD und WS_VISIBLE ergaenzt DIESE Fassung, nicht die abgeleitete.
	// Beleg: ReadMessageFrame.cpp:184 uebergibt fuer den Abschlepp-Knopf nur
	// SS_NOTIFY | SS_ICON | SS_CENTERIMAGE ohne WS_CHILD, und weder
	// TBarCombo.cpp:16-20 noch TBarStatic.cpp:105 ergaenzen es. Ohne WS_CHILD
	// entstuende ein ueberlappendes Fenster statt eines Kindfensters.
	CRect rect(0, 0, m_nSize, m_nHeight);
	if (CreateWnd(pToolBar, dwStyle | WS_CHILD | WS_VISIBLE, rect, nWndID))
	{
		// "CWnd has been created and needs initialisation" (tbtnwnd.h:54).
		SendNotify(WndInit);
	}

	AdjustSize();
}

// TBarStatic.cpp:130-151 haelt ausdruecklich fest, dass hier kein leerer
// Rumpf stehen darf: ReadMessageFrame.cpp:423-425 setzt den Text der
// Betreff-Beschriftung und ruft danach AdjustSize, damit die Leiste die neue
// Breite erfaehrt. Bliebe die Breite bei den 70 Bildpunkten aus der
// Knopftabelle (ReadMessageFrame.cpp:185), waere die Beschriftung je nach
// Sprache abgeschnitten - ein Fehler, der im Betrieb nicht nach fehlender
// Implementierung aussieht.
//
// REKONSTRUKTION, ausdruecklich als solche gekennzeichnet: die Breite aus
// dem Fensterinhalt zu bestimmen ist NUR bei Beschriftungen richtig. Ein
// Kombinationsfeld wuerde sonst auf die Breite des gerade gewaehlten
// Eintrags zusammenschnurren - CompMessageFrame.cpp:153 gibt ihm 150
// Bildpunkte, und die sollen bleiben. Deshalb die Weiche ueber die
// Fensterklasse.
void SECWndBtn::AdjustSize()
{
	if (m_pToolBar == NULL)
		return;

	m_cy = m_pToolBar->GetStdBtnHeight();
	m_nRealHeight = min(m_nHeight, m_cy);

	int nWanted = max(m_nSize, m_nMinSize);

	CWnd* pWnd = GetWnd();
	if (pWnd != NULL && pWnd->GetSafeHwnd() != NULL)
	{
		TCHAR szClass[32];
		szClass[0] = _T('\0');
		::GetClassName(pWnd->GetSafeHwnd(), szClass, 32);

		if (_tcsicmp(szClass, _T("Static")) == 0)
		{
			CString strText;
			pWnd->GetWindowText(strText);
			if (!strText.IsEmpty())
			{
				CDC* pDC = pWnd->GetDC();
				if (pDC != NULL)
				{
					CFont* pOldFont = NULL;
					CFont* pFont = pWnd->GetFont();
					if (pFont != NULL)
						pOldFont = pDC->SelectObject(pFont);

					CSize size = pDC->GetTextExtent(strText);

					if (pOldFont != NULL)
						pDC->SelectObject(pOldFont);
					pWnd->ReleaseDC(pDC);

					// vier Bildpunkte Luft, damit der Text nicht klebt
					nWanted = max(m_nMinSize, size.cx + 4);
				}
			}
		}

		pWnd->SetWindowPos(NULL, m_x, m_y + (m_cy - m_nRealHeight)/2,
						   nWanted, m_nHeight,
						   SWP_NOZORDER | SWP_NOACTIVATE);
	}

	m_nSize = nWanted;
	m_cx    = nWanted;

	if (m_pToolBar->m_nMaxBtnWidth < m_cx)
		m_pToolBar->m_nMaxBtnWidth = m_cx;
}

// Bei senkrecht angedockter Leiste ist fuer ein Kombinationsfeld kein Platz;
// das Original blendet das Kindfenster dann aus. tbtnwnd.h:129 haelt dafuer
// m_bWndVisible bereit.
void SECWndBtn::SetMode(BOOL bVertical)
{
	m_bWndVisible = !bVertical;

	CWnd* pWnd = GetWnd();
	if (pWnd != NULL && pWnd->GetSafeHwnd() != NULL)
		pWnd->ShowWindow(m_bWndVisible ? SW_SHOWNA : SW_HIDE);

	if (bVertical && m_pToolBar != NULL)
	{
		// Senkrecht bleibt nur ein Platzhalter in Knopfgroesse uebrig.
		m_cx = m_pToolBar->GetStdBtnWidth();
		m_cy = m_pToolBar->GetStdBtnHeight();
	}
	else
	{
		m_cx = m_nSize;
		if (m_pToolBar != NULL)
			m_cy = m_pToolBar->GetStdBtnHeight();
	}
}

void SECWndBtn::SetPos(int x, int y)
{
	SECStdBtn::SetPos(x, y);

	CWnd* pWnd = GetWnd();
	if (pWnd != NULL && pWnd->GetSafeHwnd() != NULL && m_bWndVisible)
	{
		pWnd->SetWindowPos(NULL, x, y + (m_cy - m_nRealHeight)/2,
						   m_cx, m_nHeight,
						   SWP_NOZORDER | SWP_NOACTIVATE);
	}
}

void SECWndBtn::Invalidate(BOOL bErase) const
{
	SECStdBtn::Invalidate(bErase);

	// GetWnd ist nicht const - das ist Vorgabe des Originals (tbtnwnd.h:116).
	CWnd* pWnd = const_cast<SECWndBtn*>(this)->GetWnd();
	if (pWnd != NULL && pWnd->GetSafeHwnd() != NULL)
		pWnd->Invalidate(bErase);
}

// Das Kindfenster verdeckt die Knopfflaeche vollstaendig, solange es sichtbar
// ist. Zu malen ist nur der Hintergrund darum herum - und bei senkrechter
// Andockung der Platzhalter.
void SECWndBtn::DrawButton(CDC& dc, SECBtnDrawData& data)
{
	if (m_bWndVisible)
	{
		CRect rect;
		GetBtnRect(rect);
		dc.FillSolidRect(rect, secData.clrBtnFace);
		return;
	}

	SECStdBtn::DrawButton(dc, data);
}

int SECWndBtn::OnToolHitTest(CPoint point, TOOLINFO* pTI) const
{
	// Solange das Kindfenster sichtbar ist, bekommt die Leiste die Maus gar
	// nicht zu sehen; ein Kurzhinweis waere unerreichbar.
	if (m_bWndVisible)
		return -1;

	return SECStdBtn::OnToolHitTest(point, pTI);
}

// tbtnwnd.h:60: WndMsg heisst "Nachricht an das CWnd weiterreichen".
void SECWndBtn::InformBtn(UINT nCode, void* pData)
{
	if (nCode == WndMsg && pData != NULL)
	{
		MSG* pMsg = (MSG*)pData;
		ForwardMessage(pMsg->message, pMsg->wParam, pMsg->lParam);
		return;
	}

	SECStdBtn::InformBtn(nCode, pData);
}

// Beim Sichern der Leiste merkt sich ein Fensterknopf seine Breite - sonst
// waere jede vom Anwender gezogene Breite nach dem Neustart wieder weg.
// Der Puffer wird mit new[] angelegt, weil
// SECCustomToolBarInfoEx::BtnInfo::~BtnInfo ihn mit delete[] freigibt.
void SECWndBtn::GetBtnInfo(BYTE* nSize, LPBYTE* ppInfo) const
{
	if (nSize == NULL || ppInfo == NULL)
		return;

	BYTE* pBuf = new BYTE[sizeof(int)];
	*((int*)pBuf) = m_nSize;

	*nSize  = (BYTE)sizeof(int);
	*ppInfo = pBuf;
}

void SECWndBtn::SetBtnInfo(BYTE nSize, const LPBYTE pInfo)
{
	if (pInfo == NULL || nSize != (BYTE)sizeof(int))
		return;

	int nNewSize = *((int*)pInfo);
	if (nNewSize >= m_nMinSize)
	{
		m_nSize = nNewSize;
		AdjustSize();
	}
}

// tbtnwnd.h:85-86. Im Original rahmen sie das Zeichnen des Kindfensters ein,
// damit im Anpassen-Modus der Auswahlrahmen sichtbar wird. Da der
// Anpassen-Modus in dieser Stufe nicht umgesetzt ist, gibt es nichts zu
// rahmen. TBarStatic.cpp:250-266 und TBarBmpCombo.cpp:256-269 haben aus
// demselben Grund ON_WM_PAINT bewusst NICHT eingetragen; solange das so
// bleibt, wird hier auch nichts gerufen.
void SECWndBtn::PrePaint()
{
}

void SECWndBtn::PostPaint()
{
}

void SECWndBtn::ForwardMessage(UINT nMessage, WPARAM wParam, LPARAM lParam)
{
	CWnd* pWnd = GetWnd();
	if (pWnd != NULL && pWnd->GetSafeHwnd() != NULL)
		pWnd->SendMessage(nMessage, wParam, lParam);
}

// tbtnwnd.h:90: "Pass on a notification to the toolbar owner".
void SECWndBtn::SendNotify(UINT nCode)
{
	if (m_pToolBar == NULL || m_pToolBar->GetSafeHwnd() == NULL)
		return;

	CWnd* pOwner = m_pToolBar->GetOwner();
	if (pOwner == NULL)
		pOwner = m_pToolBar->GetParent();

	if (pOwner != NULL)
		pOwner->SendMessage(wmSECToolBarWndNotify, (WPARAM)m_nID, (LPARAM)nCode);
}

/////////////////////////////////////////////////////////////////////////////
// SECWndBtn - Maus
//
// Die Rueckgabe TRUE bedeutet "die Leiste hat das Ereignis fuer sich
// beansprucht"; nur bei FALSE bekommt es das Kindfenster selbst
// (TBarStatic.cpp:193-203).
//
// In dieser Stufe beansprucht die Leiste nichts: das Verschieben von
// Knoepfen und das Ziehen der Breite gehoeren zum Anpassen-Modus, der laut
// Auftrag ein Dummy bleiben darf. Damit bleibt jedes Kombinationsfeld und
// jedes Eingabefeld voll bedienbar - das ist die Funktion, auf die es
// ankommt.

BOOL SECWndBtn::LButtonDown(UINT /*nFlags*/, CPoint /*point*/)
{
	return FALSE;
}

BOOL SECWndBtn::LButtonUp(UINT /*nFlags*/, CPoint /*point*/)
{
	return FALSE;
}

BOOL SECWndBtn::LButtonDblClk(UINT /*nFlags*/, CPoint /*point*/)
{
	return FALSE;
}

BOOL SECWndBtn::RButtonDown(UINT /*nFlags*/, CPoint /*point*/)
{
	return FALSE;
}

BOOL SECWndBtn::RButtonUp(UINT /*nFlags*/, CPoint /*point*/)
{
	return FALSE;
}

BOOL SECWndBtn::RButtonDblClk(UINT /*nFlags*/, CPoint /*point*/)
{
	return FALSE;
}

// Der Anfasspunkt am rechten Rand (SEC_WNDBTN_RESIZE_WIDTH, tbtnwnd.h:38)
// gehoert zum Anpassen-Modus. Ausserhalb davon setzt niemand den Zeiger.
BOOL SECWndBtn::SetCursor()
{
	if (m_pToolBar == NULL || !m_pToolBar->InConfigMode())
		return FALSE;

	CPoint pt;
	::GetCursorPos(&pt);
	m_pToolBar->ScreenToClient(&pt);

	if (pt.x < m_x + m_cx - SEC_WNDBTN_RESIZE_WIDTH || pt.x > m_x + m_cx)
		return FALSE;

	if (hCurHorzDrag == NULL)
		return FALSE;

	::SetCursor(hCurHorzDrag);
	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 4 - SECTwoPartBtn
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_BUTTON(SECTwoPartBtn)

SECTwoPartBtn::SECTwoPartBtn()
{
	m_bTwoPartMode = TRUE;
	m_nID2         = 0;
	m_nDispatchID2 = 0;
	m_nImage2      = 0;
}

// TWOPART_BUTTON(id, id2, style, dispatchID) fuellt m_nData mit
//     pData[0] = id2, pData[1] = dispatchID
// (tbtn2prt.h:52-54). Dieselbe Reihenfolge benutzen COLOR_BUTTON
// (ColorToolbarButton.h:28) und EMOTICON_BUTTON (EmoticonToolbarButton.h:28).
void SECTwoPartBtn::Init(SECCustomToolBar* pToolBar, const UINT* pData)
{
	m_pToolBar = pToolBar;

	if (pData != NULL)
	{
		m_nID2         = pData[0];
		m_nDispatchID2 = pData[1];
	}

	// Das Bild des zweiten Teils wird in dieser Fassung nicht aus der
	// Leistenbitmap geholt, sondern als Dreieck gezeichnet (siehe
	// DrawButton). m_nImage2 bleibt trotzdem gefuellt, damit ein spaeterer
	// echter Nachbau es vorfindet.
	if (pToolBar != NULL && m_nID2 != 0)
		m_nImage2 = (UINT)pToolBar->IDToBmpIndex(m_nID2);

	AdjustSize();
}

// Waagerecht ist der Knopf zweiteilig, senkrecht nicht - dort waere fuer den
// Aufklappteil kein Platz.
void SECTwoPartBtn::SetMode(BOOL bVertical)
{
	m_bTwoPartMode = !bVertical;
	AdjustSize();
}

void SECTwoPartBtn::AdjustSize()
{
	SECStdBtn::AdjustSize();

	if (m_pToolBar == NULL)
		return;

	if (m_bTwoPartMode)
	{
		// SEC_TOOLBAR_TWOPART_WIDTH (34) und SEC_TOOLBAR_TWOPART_DWIDTH (11)
		// aus tbtn2prt.h:44-45 gelten fuer 16 Bildpunkte breite Bilder:
		// 23 + 11 = 34. Hier wird mit der tatsaechlichen Bildbreite
		// gerechnet, damit die grossen Knoepfe (LARGE_TOOLBARS,
		// QCToolBarManager.cpp:335) ebenfalls stimmen.
		m_cx = m_pToolBar->GetStdBtnWidth() + SEC_TOOLBAR_TWOPART_DWIDTH;

		if (m_pToolBar->m_nMaxBtnWidth < m_cx)
			m_pToolBar->m_nMaxBtnWidth = m_cx;
	}
}

// Zwei Gesichter nebeneinander im selben Zwischenpuffer.
//
// WICHTIG fuer die abgeleiteten Klassen: der linke Teil bekommt die volle
// Bildbreite uebergeben, der rechte die 0. ColorToolbarButton.cpp:57 prueft
// "if (nImgWidth > 10)", um den linken Teil zu erkennen - mit -1 statt einer
// echten Breite wuerde die Farbflaeche nie gezeichnet.
void SECTwoPartBtn::DrawButton(CDC& dc, SECBtnDrawData& data)
{
	if (m_pToolBar == NULL || (m_nStyle & TBBS_HIDDEN))
		return;

	if (!m_bTwoPartMode)
	{
		SECStdBtn::DrawButton(dc, data);
		return;
	}

	if (m_cx > data.m_cxBuf || m_cy > data.m_cyBuf)
		return;

	int nMainWidth = m_cx - SEC_TOOLBAR_TWOPART_DWIDTH;

	// --- linker Teil: Bild und Zustand wie bei einem einfachen Knopf
	int x = 0, y = 0;
	int nWidth = nMainWidth, nHeight = m_cy;

	DrawFace(data, FALSE, x, y, nWidth, nHeight, m_pToolBar->GetImgWidth());

	if (m_nStyle & TBBS_INDETERMINATE)
		DrawIndeterminate(data, x, y, nWidth, nHeight);
	else if (m_nStyle & TBBS_CHECKED)
		DrawChecked(data, x, y, nWidth, nHeight);

	if (m_nStyle & TBBS_DISABLED)
		DrawDisabled(data, x, y, nWidth, nHeight);

	// --- rechter Teil: nur Rahmen, das Sinnbild ist ein Dreieck
	//
	// Der Druckzustand des rechten Teils steht in SEC_TBBS_PRESSED2
	// (tbtn2prt.h:48). DrawFace kennt nur TBBS_PRESSED, deshalb wird das Bit
	// fuer die Dauer des Aufrufs umgehaengt und danach zurueckgesetzt.
	UINT nSaved = m_nStyle;
	m_nStyle &= ~(TBBS_PRESSED | TBBS_CHECKED);
	if (nSaved & SEC_TBBS_PRESSED2)
		m_nStyle |= TBBS_PRESSED;

	int x2 = nMainWidth, y2 = 0;
	int nWidth2 = SEC_TOOLBAR_TWOPART_DWIDTH, nHeight2 = m_cy;

	DrawFace(data, FALSE, x2, y2, nWidth2, nHeight2, 0);

	m_nStyle = nSaved;

	// Das Aufklappdreieck. Im Original stand hier vermutlich ein eigenes
	// Bild aus der Leistenbitmap (m_nImage2); belegen laesst sich das nicht,
	// und ein 11 Bildpunkte breiter Ausschnitt eines 16 Punkte breiten
	// Sinnbilds saehe in jedem Fall abgeschnitten aus. Ein gezeichnetes
	// Dreieck ist die Darstellung, die Windows fuer Aufklappknoepfe seit
	// jeher benutzt.
	{
		int cxArrow = 5;
		int cyArrow = 3;
		int xa = x2 + (nWidth2 - cxArrow)/2;
		int ya = y2 + (nHeight2 - cyArrow)/2;

		COLORREF clr = (m_nStyle & TBBS_DISABLED) ? secData.clrBtnShadow
												  : secData.clrText;

		for (int i = 0; i < cyArrow; i++)
			data.m_drawDC.FillSolidRect(xa + i, ya + i, cxArrow - 2*i, 1, clr);
	}

	if (m_nStyle & SEC_TBBS_FOCUS)
		DrawConfigFocus(data);

	dc.BitBlt(m_x, m_y, m_cx, m_cy, &data.m_drawDC, 0, 0, SRCCOPY);
}

// Ein Druck auf den rechten Teil setzt SEC_TBBS_PRESSED2 und
// SEC_TBBS_TRACKING2. ColorToolbarButton.cpp:86 und
// EmoticonToolbarButton.cpp:113 pruefen danach genau dieses Bit, klappen ihr
// Menue auf und loeschen beide Bits wieder (:122 bzw. :152). Deshalb darf
// diese Fassung sie NICHT selbst wieder loeschen.
BOOL SECTwoPartBtn::BtnPressDown(CPoint point)
{
	if (m_nStyle & TBBS_DISABLED)
		return FALSE;

	CRect rect;
	GetBtnRect(rect);
	if (!rect.PtInRect(point))
		return FALSE;

	if (m_bTwoPartMode && point.x >= m_x + m_cx - SEC_TOOLBAR_TWOPART_DWIDTH)
	{
		m_nStyle |= (SEC_TBBS_PRESSED2 | SEC_TBBS_TRACKING2);
		Invalidate();
		return TRUE;
	}

	return SECStdBtn::BtnPressDown(point);
}

void SECTwoPartBtn::BtnPressMouseMove(CPoint point)
{
	if (m_nStyle & SEC_TBBS_TRACKING2)
	{
		UINT nOld = m_nStyle;
		CRect rect(m_x + m_cx - SEC_TOOLBAR_TWOPART_DWIDTH, m_y,
				   m_x + m_cx, m_y + m_cy);

		if (rect.PtInRect(point))
			m_nStyle |= SEC_TBBS_PRESSED2;
		else
			m_nStyle &= ~SEC_TBBS_PRESSED2;

		if (m_nStyle != nOld)
			Invalidate();

		return;
	}

	SECStdBtn::BtnPressMouseMove(point);
}

void SECTwoPartBtn::BtnPressCancel()
{
	if (m_nStyle & (SEC_TBBS_PRESSED2 | SEC_TBBS_TRACKING2))
	{
		m_nStyle &= ~(SEC_TBBS_PRESSED2 | SEC_TBBS_TRACKING2);
		Invalidate();
		return;
	}

	SECStdBtn::BtnPressCancel();
}

UINT SECTwoPartBtn::BtnPressUp(CPoint point)
{
	if (m_nStyle & SEC_TBBS_TRACKING2)
	{
		BOOL bInside = (m_nStyle & SEC_TBBS_PRESSED2) != 0;
		m_nStyle &= ~(SEC_TBBS_PRESSED2 | SEC_TBBS_TRACKING2);
		Invalidate();

		if (!bInside)
			return 0;

		// tbtn2prt.h:66: "Command ID dispatched for second part". Ist keiner
		// angegeben - COLOR_BUTTON und EMOTICON_BUTTON uebergeben dort NULL
		// (CompMessageFrame.cpp:162, 166) - wird die Kennung des zweiten
		// Teils selbst abgesetzt.
		return m_nDispatchID2 ? m_nDispatchID2 : m_nID2;
	}

	return SECStdBtn::BtnPressUp(point);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 5 - SECComboBtnEdit und SECComboBtn
//
/////////////////////////////////////////////////////////////////////////////

SECComboBtnEdit::SECComboBtnEdit()
{
	m_pCombo = NULL;
}

BEGIN_MESSAGE_MAP(SECComboBtnEdit, CEdit)
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_RBUTTONDOWN()
	ON_WM_RBUTTONUP()
	ON_WM_RBUTTONDBLCLK()
	ON_WM_SETCURSOR()
END_MESSAGE_MAP()

// Das Eingabefeld liegt IM Kombinationsfeld; seine Koordinaten sind daher
// gegenueber der Leiste verschoben. Vor der Weitergabe an den Knopf muss
// umgerechnet werden, sonst liegt jeder Treffertest daneben.
// Das Eingabefeld ist Kind des Kombinationsfeldes, das Kombinationsfeld Kind
// der Leiste - zwei Ebenen also.
static CPoint OTShimInLeiste(CWnd* pFrom, CPoint point)
{
	if (pFrom == NULL || pFrom->GetSafeHwnd() == NULL)
		return point;

	CWnd* pCombo = pFrom->GetParent();
	CWnd* pBar   = pCombo ? pCombo->GetParent() : NULL;
	if (pBar == NULL || pBar->GetSafeHwnd() == NULL)
		return point;

	CPoint pt(point);
	pFrom->ClientToScreen(&pt);
	pBar->ScreenToClient(&pt);
	return pt;
}

void SECComboBtnEdit::OnLButtonDown(UINT nFlags, CPoint point)
{
	if (m_pCombo == NULL ||
		!m_pCombo->LButtonDown(nFlags, OTShimInLeiste(this, point)))
		CEdit::OnLButtonDown(nFlags, point);
}

void SECComboBtnEdit::OnLButtonUp(UINT nFlags, CPoint point)
{
	if (m_pCombo == NULL ||
		!m_pCombo->LButtonUp(nFlags, OTShimInLeiste(this, point)))
		CEdit::OnLButtonUp(nFlags, point);
}

void SECComboBtnEdit::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	if (m_pCombo == NULL ||
		!m_pCombo->LButtonDblClk(nFlags, OTShimInLeiste(this, point)))
		CEdit::OnLButtonDblClk(nFlags, point);
}

void SECComboBtnEdit::OnRButtonDown(UINT nFlags, CPoint point)
{
	if (m_pCombo == NULL ||
		!m_pCombo->RButtonDown(nFlags, OTShimInLeiste(this, point)))
		CEdit::OnRButtonDown(nFlags, point);
}

void SECComboBtnEdit::OnRButtonUp(UINT nFlags, CPoint point)
{
	if (m_pCombo == NULL ||
		!m_pCombo->RButtonUp(nFlags, OTShimInLeiste(this, point)))
		CEdit::OnRButtonUp(nFlags, point);
}

void SECComboBtnEdit::OnRButtonDblClk(UINT nFlags, CPoint point)
{
	if (m_pCombo == NULL ||
		!m_pCombo->RButtonDblClk(nFlags, OTShimInLeiste(this, point)))
		CEdit::OnRButtonDblClk(nFlags, point);
}

BOOL SECComboBtnEdit::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if (m_pCombo != NULL && m_pCombo->SetCursor())
		return TRUE;

	return CEdit::OnSetCursor(pWnd, nHitTest, message);
}


/////////////////////////////////////////////////////////////////////////////
// SECComboBtn
//
// Mehrfachvererbung CComboBox + SECWndBtn. CTBarComboBtn (TBarCombo.cpp)
// ueberschreibt CreateWnd und OnFontCreateAndSet, alles Uebrige bleibt hier.

IMPLEMENT_BUTTON(SECComboBtn)

BEGIN_MESSAGE_MAP(SECComboBtn, CComboBox)
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_RBUTTONDOWN()
	ON_WM_RBUTTONUP()
	ON_WM_RBUTTONDBLCLK()
	ON_WM_SETCURSOR()
END_MESSAGE_MAP()

CWnd* SECComboBtn::GetWnd()
{
	return this;
}

// Wortgleich zu CTBarComboBtn::CreateWnd (TBarCombo.cpp:13-40). Die
// abgeleitete Klasse setzt dieselbe Fassung noch einmal, weil sie im
// Original ebenfalls dort stand; hier ist sie die Vorgabe fuer alle
// uebrigen Ableitungen.
BOOL SECComboBtn::CreateWnd(CWnd* pParentWnd, DWORD dwStyle, CRect& rect,
							int nID)
{
	if(!(dwStyle & (CBS_DROPDOWNLIST | CBS_DROPDOWN)))
		dwStyle |= CBS_DROPDOWNLIST;

	BOOL bRes = CComboBox::Create(dwStyle, rect, pParentWnd, nID);
	ASSERT(bRes);
	if(bRes)
	{
		if(dwStyle & CBS_DROPDOWN)
		{
			// Das Kind-Eingabefeld unterklassen, sonst verschluckt es alle
			// Mausereignisse.
			CWnd* pWnd = GetWindow(GW_CHILD);
			if(pWnd != NULL)
			{
				VERIFY(m_edit.SubclassWindow(pWnd->m_hWnd));
				m_edit.m_pCombo = (SECWndBtn*) this;
			}
		}

		OnFontCreateAndSet();
		AdjustSize();
	}

	return bRes;
}

// Wortgleich zu CTBarComboBtn::OnFontCreateAndSet (TBarCombo.cpp:43-52).
// Die Schrift bestimmt die Zeilenhoehe; ohne sie stimmt die Groesse in der
// Leiste nicht.
void SECComboBtn::OnFontCreateAndSet()
{
	m_font.CreateFont(8, 0, 0, 0, FW_NORMAL, 0, 0, 0,
					  DEFAULT_CHARSET, OUT_CHARACTER_PRECIS,
					  CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY,
					  DEFAULT_PITCH | FF_DONTCARE, _T("MS Sans Serif"));

	SetFont(&m_font, TRUE);
}

// tbtncmbo.h:86: die Meldung Entered geht an die Leiste, wenn der Anwender
// die Eingabetaste drueckt.
//
// NICHT NACHGEBAUT, und zwar belegt: eine Suche ueber Eudora/ und
// OT501/Include/ findet wmSECToolBarWndNotify und Entered ausschliesslich in
// den Deklarationen selbst, in keinem einzigen Empfaenger. Dieselbe
// Feststellung steht in TBarStatic.cpp:172-181 und TBarBmpCombo.cpp:178-187.
// Ein nachgebautes PreTranslateMessage wuerde die Eingabetaste nur
// schlucken, ohne dass irgendwo etwas geschieht.
BOOL SECComboBtn::PreTranslateMessage(MSG* pMsg)
{
	return CComboBox::PreTranslateMessage(pMsg);
}

// Ein Kombinationsfeld ist so hoch wie die Leiste; die Aufklappliste haengt
// darunter und wird von Windows selbst verwaltet. m_nHeight aus der
// Knopftabelle (150 bei CompMessageFrame.cpp:153) beschreibt die Hoehe
// EINSCHLIESSLICH der aufgeklappten Liste - deshalb darf sie nicht als
// Knopfhoehe durchschlagen.
void SECComboBtn::AdjustSize()
{
	// SECWndBtn::AdjustSize setzt das Fenster bereits auf die Breite aus der
	// Knopftabelle und auf die volle Hoehe m_nHeight; die Weiche ueber die
	// Fensterklasse dort sorgt dafuer, dass die Breite NICHT auf den
	// gewaehlten Eintrag zusammenschnurrt. Mehr ist hier nicht zu tun.
	SECWndBtn::AdjustSize();
}

void SECComboBtn::SetMode(BOOL bVertical)
{
	SECWndBtn::SetMode(bVertical);
}

void SECComboBtn::OnLButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDown(nFlags, point))
		CComboBox::OnLButtonDown(nFlags, point);
}

void SECComboBtn::OnLButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonUp(nFlags, point))
		CComboBox::OnLButtonUp(nFlags, point);
}

void SECComboBtn::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDblClk(nFlags, point))
		CComboBox::OnLButtonDblClk(nFlags, point);
}

void SECComboBtn::OnRButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDown(nFlags, point))
		CComboBox::OnRButtonDown(nFlags, point);
}

void SECComboBtn::OnRButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonUp(nFlags, point))
		CComboBox::OnRButtonUp(nFlags, point);
}

void SECComboBtn::OnRButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDblClk(nFlags, point))
		CComboBox::OnRButtonDblClk(nFlags, point);
}

// LEER, UND DESHALB ABSICHTLICH NICHT IN DER NACHRICHTENTABELLE.
// Genau wie CTBarStaticBtn::OnPaint (TBarStatic.cpp:250-269): waere
// ON_WM_PAINT eingetragen und dieser Rumpf leer, bliebe das Kombinationsfeld
// leer - ein Fehler, der nicht nach fehlender Implementierung aussieht. Ohne
// den Eintrag zeichnet CComboBox wie gewohnt.
void SECComboBtn::OnPaint()
{
}

BOOL SECComboBtn::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if (SECWndBtn::SetCursor())
		return TRUE;

	return CComboBox::OnSetCursor(pWnd, nHitTest, message);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 6 - SECCustomToolBar
//
/////////////////////////////////////////////////////////////////////////////

IMPLEMENT_DYNCREATE(SECCustomToolBar, SECControlBar)

BEGIN_MESSAGE_MAP(SECCustomToolBar, SECControlBar)
	ON_WM_WINDOWPOSCHANGING()
	ON_WM_SHOWWINDOW()
	ON_WM_SYSCOLORCHANGE()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_MOUSEMOVE()
	ON_WM_CANCELMODE()
	ON_WM_MOUSEACTIVATE()
	ON_WM_DESTROY()
	ON_WM_TIMER()
END_MESSAGE_MAP()

// Kennung des Zeitgebers, mit dem der angehobene Knopf wieder abgesenkt
// wird, sobald der Zeiger die Leiste verlaesst. WM_MOUSELEAVE waere der
// heutige Weg; der Zeitgeber ist der, den die Leiste ohnehin schon hatte
// (tbarcust.h:369  afx_msg void OnTimer).
#define OTSHIM_TIMER_RAISED		0x5EC1

SECCustomToolBar::SECCustomToolBar()
{
	m_bOwnBitmap          = FALSE;
	m_nBmpItems           = 0;
	m_hBmp                = NULL;
	m_lpszResourceName    = NULL;
	m_pBmpItems           = NULL;
	m_nImgHeight          = SEC_TOOLBAR_IMAGE_HEIGHT;
	m_nImgWidth           = SEC_TOOLBAR_IMAGE_WIDTH;
	m_nSepWidth           = GetSepWidth();
	m_nDown               = -1;
	m_nRaised             = -1;
	m_bConfig             = FALSE;
	m_bAltDrag            = FALSE;
	m_pDrawData           = NULL;
	m_bVertical           = FALSE;
	m_bFloatSizeUnknown   = TRUE;
	m_bHorzDockSizeUnknown= TRUE;
	m_bVertDockSizeUnknown= TRUE;
	m_szTbarDockHorz      = CSize(0, 0);
	m_szTbarDockVert      = CSize(0, 0);
	m_szTbarFloat         = CSize(0, 0);
	m_nMaxBtnWidth        = GetStdBtnWidth();
}

SECCustomToolBar::~SECCustomToolBar()
{
	for (int i = 0; i < GetBtnCount(); i++)
		delete m_btns[i];
	m_btns.RemoveAll();

	if (m_bOwnBitmap && m_hBmp != NULL)
	{
		::DeleteObject(m_hBmp);
		m_hBmp = NULL;
	}

	// m_pDrawData zeigt auf den gemeinsamen Puffer des Verwalters, ausser
	// wenn diese Leiste keinen Verwalter hat und sich einen eigenen angelegt
	// hat. Nur dann gehoert er ihr.
	if (m_pDrawData != NULL && m_pManager == NULL)
	{
		delete m_pDrawData;
		m_pDrawData = NULL;
	}
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Erzeugung
//
// Alle drei Fassungen laufen auf SECControlBar::Create hinaus (sbarcore.h:126,
// Stufe 2). mainfrm.cpp:1726 benutzt CreateEx, QCCustomToolBar.cpp:1237
// reicht darauf durch.

BOOL SECCustomToolBar::Create(LPCTSTR lpszClassName, LPCTSTR lpszWindowName,
							  UINT nID, DWORD dwStyle, DWORD dwExStyle,
							  const RECT& rect, CWnd* pParentWnd,
							  CCreateContext* pContext)
{
	if (!SECControlBar::Create(lpszClassName, lpszWindowName, nID, dwStyle,
							   dwExStyle, rect, pParentWnd, pContext))
		return FALSE;

	NotifyManager(BarCreate);
	return TRUE;
}

BOOL SECCustomToolBar::Create(CWnd* pParentWnd, DWORD dwStyle, UINT nID,
							  LPCTSTR lpszTitle)
{
	return CreateEx(0L, pParentWnd, dwStyle, nID, lpszTitle);
}

BOOL SECCustomToolBar::CreateEx(DWORD dwExStyle, CWnd* pParentWnd,
								DWORD dwStyle, UINT nID, LPCTSTR lpszTitle)
{
	CRect rect(0, 0, 0, 0);
	return Create(NULL, lpszTitle, nID, dwStyle, dwExStyle, rect, pParentWnd,
				  NULL);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Bitmap und Bildzuordnung

// Der Verwalter reicht seine gemeinsame Bitmap hierher durch
// (SECToolBarManager::SetToolBarInfo). Die Leiste besitzt sie NICHT -
// m_bOwnBitmap bleibt FALSE, sonst gaebe die erste zerstoerte Leiste die
// Bitmap aller uebrigen frei.
void SECCustomToolBar::SetToolBarInfo(HBITMAP hBmp, UINT* pBmpItems,
									  UINT nBmpItems, int nImgWidth,
									  int nImgHeight)
{
	if (m_bOwnBitmap && m_hBmp != NULL && m_hBmp != hBmp)
		::DeleteObject(m_hBmp);

	m_bOwnBitmap = FALSE;
	m_hBmp       = hBmp;
	m_pBmpItems  = pBmpItems;
	m_nBmpItems  = nBmpItems;

	if (nImgWidth > 0)
		m_nImgWidth = nImgWidth;
	if (nImgHeight > 0)
		m_nImgHeight = nImgHeight;

	m_nSepWidth = GetSepWidth();

	// Die Knoepfe muessen ihre Bildplaetze und Groessen neu bestimmen -
	// beim Umschalten auf grosse Knoepfe aendert sich beides.
	m_nMaxBtnWidth = GetStdBtnWidth();
	for (int i = 0; i < GetBtnCount(); i++)
	{
		SECStdBtn* pBtn = m_btns[i];
		if (!(pBtn->m_nStyle & TBBS_SEPARATOR))
			pBtn->m_nImage = (UINT)IDToBmpIndex(pBtn->m_nID);
		pBtn->AdjustSize();
		if (m_nMaxBtnWidth < pBtn->m_cx)
			m_nMaxBtnWidth = pBtn->m_cx;
	}

	if (GetSafeHwnd() != NULL)
	{
		Invalidate();
		if (m_pDockSite != NULL)
			m_pDockSite->RecalcLayout();
	}
}

void SECCustomToolBar::SetBitmap(HBITMAP hBmp)
{
	SetToolBarInfo(hBmp, m_pBmpItems, m_nBmpItems, m_nImgWidth, m_nImgHeight);
}

// Befehlskennung -> Platz in der Leistenbitmap.
//
// UNGEPRUEFT: was das Original bei einer unbekannten Kennung liefert, ist
// nicht belegbar. Hier wird 0 zurueckgegeben - der Knopf zeigt dann das
// erste Bild statt eines leeren Flecks. QCCustomToolBar.cpp:1256 schreibt
// das Ergebnis unbesehen nach m_nImage, ein negativer Wert wuerde dort zu
// einem BitBlt ausserhalb der Bitmap fuehren.
int SECCustomToolBar::IDToBmpIndex(UINT nID)
{
	if (m_pBmpItems == NULL)
		return 0;

	for (UINT i = 0; i < m_nBmpItems; i++)
	{
		if (m_pBmpItems[i] == nID)
			return (int)i;
	}

	return 0;
}

// Laedt eine Werkzeugleistenressource in DIESE Leiste. Von Eudora nicht
// aufgerufen - dort geht alles ueber den Verwalter
// (QCToolBarManager.cpp:346) -, aber Bestandteil der Oberflaeche.
BOOL SECCustomToolBar::LoadToolBar(LPCTSTR lpszResourceName)
{
	CBitmap bmp;
	UINT*   pItems    = NULL;
	UINT    nItems    = 0;
	int     nWidth    = 0;
	int     nHeight   = 0;
	UINT    nBtnCount = 0;
	UINT*   pBtnArray = NULL;

	if (!SECLoadToolBarResource(lpszResourceName, bmp, pItems, nItems,
								nWidth, nHeight, &nBtnCount, &pBtnArray))
		return FALSE;

	if (m_bOwnBitmap && m_hBmp != NULL)
		::DeleteObject(m_hBmp);

	m_hBmp             = (HBITMAP)bmp.Detach();
	m_bOwnBitmap       = TRUE;
	m_lpszResourceName = lpszResourceName;

	// Die Zuordnungstabelle geht in den Besitz der Leiste ueber. Eine alte,
	// die vom Verwalter kam, gehoert nicht uns.
	m_pBmpItems  = pItems;
	m_nBmpItems  = nItems;
	m_nImgWidth  = nWidth;
	m_nImgHeight = nHeight;
	m_nSepWidth  = GetSepWidth();

	BOOL bRes = SetButtons(pBtnArray, (int)nBtnCount);

	delete [] pBtnArray;
	return bRes;
}

BOOL SECCustomToolBar::LoadToolBar(UINT nIDResource)
{
	return LoadToolBar(MAKEINTRESOURCE(nIDResource));
}

BOOL SECCustomToolBar::LoadBitmap(LPCTSTR lpszResourceName,
								  const UINT* lpIDArray, int nIDCount)
{
	CBitmap bmp;

	// Graustufen gegen die aktuellen Systemfarben tauschen - dasselbe, was
	// SECLoadSysColorBitmap (OTShim.h) fuer einzelne Bilder tut.
	BOOL bLoaded = FALSE;
	if (IS_INTRESOURCE(lpszResourceName))
		bLoaded = bmp.LoadMappedBitmap(
					(UINT)(UINT_PTR)(void*)lpszResourceName);
	else
		bLoaded = bmp.LoadBitmap(lpszResourceName);

	if (!bLoaded)
		return FALSE;

	BITMAP bm;
	if (!bmp.GetObject(sizeof(bm), &bm))
		return FALSE;

	if (m_bOwnBitmap && m_hBmp != NULL)
		::DeleteObject(m_hBmp);

	m_hBmp       = (HBITMAP)bmp.Detach();
	m_bOwnBitmap = TRUE;
	m_nImgHeight = bm.bmHeight;
	m_nImgWidth  = (nIDCount > 0) ? (int)(bm.bmWidth / nIDCount) : bm.bmWidth;
	m_nSepWidth  = GetSepWidth();

	UINT* pItems = new UINT[nIDCount > 0 ? nIDCount : 1];
	for (int i = 0; i < nIDCount; i++)
		pItems[i] = lpIDArray[i];

	m_pBmpItems = pItems;
	m_nBmpItems = (UINT)nIDCount;

	return SetButtons(lpIDArray, nIDCount);
}

BOOL SECCustomToolBar::LoadBitmap(UINT nIDResource, const UINT* lpIDArray,
								  int nIDCount)
{
	return LoadBitmap(MAKEINTRESOURCE(nIDResource), lpIDArray, nIDCount);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Knoepfe anlegen

// Sucht die Kennung in der Knopftabelle des Verwalters und legt einen Knopf
// der dort eingetragenen Klasse an. Steht sie nicht drin, wird ein einfacher
// SECStdBtn erzeugt.
//
// Das ist der Regelfall fuer das Hauptfenster: mainfrm.cpp:280-281 setzt
// eine LEERE Knopftabelle (BEGIN_BUTTON_MAP(btnMap) END_BUTTON_MAP()), also
// besteht die Hauptwerkzeugleiste ausschliesslich aus einfachen Knoepfen.
// Nur die Verfassen-, Lese- und Dokumentfenster haben gefuellte Tabellen
// (CompMessageFrame.cpp:125, ReadMessageFrame.cpp:164,
// PgDocumentFrame.cpp:94).
SECStdBtn* SECCustomToolBar::CreateButton(UINT nID, SECCustomToolBar* pToolBar)
{
	if (pToolBar == NULL)
		pToolBar = this;

	const SECBtnMapEntry* pEntry = NULL;
	if (m_pManager != NULL)
	{
		ASSERT_KINDOF(SECToolBarManager, m_pManager);
		const SECBtnMapEntry* pMap =
			((SECToolBarManager*)m_pManager)->GetButtonMap();

		// Das Tabellenende ist ein Eintrag mit m_pBtnClass == NULL
		// (END_BUTTON_MAP, tbtnstd.h:239-241).
		for (; pMap != NULL && pMap->m_pBtnClass != NULL; pMap++)
		{
			if (pMap->m_nID == nID)
			{
				pEntry = pMap;
				break;
			}
		}
	}

	SECStdBtn* pBtn = NULL;
	if (pEntry != NULL)
		pBtn = pEntry->m_pBtnClass->CreateButton();
	else
		pBtn = SECStdBtn::CreateButton();

	if (pBtn == NULL)
		return NULL;

	pBtn->m_nID    = nID;
	pBtn->m_nStyle = pEntry ? pEntry->m_nStyle : TBBS_BUTTON;
	pBtn->m_nImage = (UINT)pToolBar->IDToBmpIndex(nID);
	pBtn->SetToolBar(pToolBar);

	// Init bekommt m_nData; ohne Tabelleneintrag ein Feld aus lauter Nullen,
	// genau wie STD_BUTTON es liefert.
	static const UINT nNullData[BTNMAP_DATA_ELEMENTS] = { 0, 0, 0, 0, 0 };
	pBtn->Init(pToolBar, pEntry ? pEntry->m_nData : nNullData);

	if (pToolBar->m_nMaxBtnWidth < pBtn->m_cx)
		pToolBar->m_nMaxBtnWidth = pBtn->m_cx;

	return pBtn;
}

// QCCustomToolBar.cpp:1267-1272 ueberschreibt das und setzt danach m_ulData
// auf ID_SEPARATOR - der Rueckgabewert darf also nicht NULL sein.
SECStdBtn* SECCustomToolBar::CreateSeparator(SECCustomToolBar* pToolBar)
{
	if (pToolBar == NULL)
		pToolBar = this;

	SECStdBtn* pBtn = SECStdBtn::CreateButton();
	if (pBtn == NULL)
		return NULL;

	pBtn->m_nID    = ID_SEPARATOR;
	pBtn->m_nStyle = TBBS_SEPARATOR;
	pBtn->m_nImage = 0;
	pBtn->SetToolBar(pToolBar);
	pBtn->AdjustSize();

	return pBtn;
}

// mainfrm.cpp:1737, CompMessageFrame.cpp:481, ReadMessageFrame.cpp:374,
// QCToolbarCmdPage.cpp:89. ID_SEPARATOR (0) steht fuer einen Trenner.
BOOL SECCustomToolBar::SetButtons(const UINT* lpIDArray, int nIDCount)
{
	for (int i = 0; i < GetBtnCount(); i++)
		delete m_btns[i];
	m_btns.RemoveAll();

	m_nDown        = -1;
	m_nRaised      = -1;
	m_nMaxBtnWidth = GetStdBtnWidth();

	if (lpIDArray != NULL)
	{
		for (int i = 0; i < nIDCount; i++)
		{
			SECStdBtn* pBtn = (lpIDArray[i] == ID_SEPARATOR)
								? CreateSeparator(this)
								: CreateButton(lpIDArray[i], this);
			if (pBtn == NULL)
				return FALSE;

			m_btns.Add(pBtn);
		}
	}

	if (GetSafeHwnd() != NULL)
	{
		Invalidate();
		if (m_pDockSite != NULL)
			m_pDockSite->RecalcLayout();
	}

	return TRUE;
}

// QCCustomToolBar.cpp:321 ruft AddButton mit der berechneten Einfuegestelle.
void SECCustomToolBar::AddButton(int nIndex, int nID, BOOL bSeparator,
								 BOOL bNoUpdate)
{
	if (nIndex < 0)
		nIndex = 0;
	if (nIndex > GetBtnCount())
		nIndex = GetBtnCount();

	SECStdBtn* pBtn = bSeparator ? CreateSeparator(this)
								 : CreateButton((UINT)nID, this);
	if (pBtn == NULL)
		return;

	m_btns.InsertAt(nIndex, pBtn);

	// Der Anpassen-Fokus haengt am Platz, nicht am Knopf - er wandert mit.
	if (m_nDown >= nIndex)
		m_nDown++;

	if (!bNoUpdate && GetSafeHwnd() != NULL)
	{
		Invalidate();
		if (m_pDockSite != NULL)
			m_pDockSite->RecalcLayout();
	}
}

// pIndex, falls angegeben, wird mitgefuehrt: QCCustomToolBar.cpp:278 laesst
// sich damit die Einfuegestelle nachfuehren, wenn der entfernte Knopf davor
// lag.
BOOL SECCustomToolBar::RemoveButton(int nIndex, BOOL bNoUpdate, INT* pIndex)
{
	if (nIndex < 0 || nIndex >= GetBtnCount())
		return FALSE;

	delete m_btns[nIndex];
	m_btns.RemoveAt(nIndex);

	if (pIndex != NULL && *pIndex > nIndex)
		(*pIndex)--;

	if (m_nDown == nIndex)
		m_nDown = -1;
	else if (m_nDown > nIndex)
		m_nDown--;

	if (m_nRaised == nIndex)
		m_nRaised = -1;
	else if (m_nRaised > nIndex)
		m_nRaised--;

	if (!bNoUpdate && GetSafeHwnd() != NULL)
	{
		Invalidate();
		if (m_pDockSite != NULL)
			m_pDockSite->RecalcLayout();
	}

	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Abfragen

int SECCustomToolBar::CommandToIndex(UINT nID) const
{
	for (int i = 0; i < GetBtnCount(); i++)
	{
		if (m_btns[i]->m_nID == nID && !(m_btns[i]->m_nStyle & TBBS_SEPARATOR))
			return i;
	}

	return -1;
}

UINT SECCustomToolBar::GetItemID(int nIndex) const
{
	if (nIndex < 0 || nIndex >= GetBtnCount())
		return 0;

	return m_btns[nIndex]->m_nID;
}

// tbarcust.h:144: "Returns the index of the currently active button".
// QCCustomizeSignaturesPage.cpp:202 prueft auf -1.
int SECCustomToolBar::GetCurBtn() const
{
	return m_nDown;
}

void SECCustomToolBar::GetItemRect(int nIndex, LPRECT lpRect) const
{
	ASSERT(lpRect != NULL);
	if (lpRect == NULL)
		return;

	if (nIndex < 0 || nIndex >= GetBtnCount())
	{
		::SetRectEmpty(lpRect);
		return;
	}

	CRect rect;
	m_btns[nIndex]->GetBtnRect(rect);
	*lpRect = rect;
}

int SECCustomToolBar::ItemFromPoint(CPoint point, CRect& rect) const
{
	for (int i = 0; i < GetBtnCount(); i++)
	{
		CRect r;
		m_btns[i]->GetBtnRect(r);
		if (r.PtInRect(point))
		{
			rect = r;
			return i;
		}
	}

	rect.SetRectEmpty();
	return -1;
}

void SECCustomToolBar::InvalidateButton(int nIndex)
{
	if (nIndex < 0 || nIndex >= GetBtnCount())
		return;

	m_btns[nIndex]->Invalidate();
}

UINT SECCustomToolBar::GetButtonStyle(int nIndex) const
{
	if (nIndex < 0 || nIndex >= GetBtnCount())
		return 0;

	return m_btns[nIndex]->m_nStyle;
}

void SECCustomToolBar::SetButtonStyle(int nIndex, UINT nStyle)
{
	if (nIndex < 0 || nIndex >= GetBtnCount())
		return;

	SECStdBtn* pBtn = m_btns[nIndex];
	if (pBtn->m_nStyle == nStyle)
		return;

	BOOL bSizeChanged =
		(pBtn->m_nStyle & TBBS_SEPARATOR) != (nStyle & TBBS_SEPARATOR);

	pBtn->m_nStyle = nStyle;

	if (bSizeChanged)
		pBtn->AdjustSize();

	pBtn->Invalidate();
}

// tbarcust.h:165. bPass == TRUE heisst "auch an die uebrigen Leisten des
// Verwalters weiterreichen".
void SECCustomToolBar::InformBtns(UINT nID, UINT nCode, void* pData, BOOL bPass)
{
	for (int i = 0; i < GetBtnCount(); i++)
	{
		if (m_btns[i]->m_nID == nID)
			m_btns[i]->InformBtn(nCode, pData);
	}

	if (bPass && m_pManager != NULL)
	{
		ASSERT_KINDOF(SECToolBarManager, m_pManager);
		((SECToolBarManager*)m_pManager)->InformBtns(nID, nCode, pData);
	}
}

SECBtnDrawData& SECCustomToolBar::GetDrawData()
{
	if (m_pManager != NULL)
	{
		ASSERT_KINDOF(SECToolBarManager, m_pManager);
		return ((SECToolBarManager*)m_pManager)->GetDrawData();
	}

	// Ohne Verwalter braucht die Leiste einen eigenen Puffer. Der Destruktor
	// gibt genau diesen Fall wieder frei.
	if (m_pDrawData == NULL)
		m_pDrawData = new SECBtnDrawData;

	return *m_pDrawData;
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Zustand sichern und laden
//
// QCCustomToolBar.cpp:334-365 ueberschreibt GetBarInfoEx vollstaendig und
// filtert dabei die angepassten Knoepfe heraus. Diese Fassung ist die
// ungefilterte Vorgabe; sie wird von QCChildToolBar und CSearchBar benutzt.

void SECCustomToolBar::GetBarInfoEx(SECControlBarInfo* pInfo)
{
	if (pInfo == NULL)
		return;

	SECCustomToolBarInfoEx* pEx = new SECCustomToolBarInfoEx;

	GetWindowText(pEx->m_strBarName);

	for (int i = 0; i < GetBtnCount(); i++)
	{
		SECCustomToolBarInfoEx::BtnInfo* pBtnInfo =
			new SECCustomToolBarInfoEx::BtnInfo;

		pBtnInfo->m_nID = (m_btns[i]->m_nStyle & TBBS_SEPARATOR)
							? ID_SEPARATOR : m_btns[i]->m_nID;

		m_btns[i]->GetBtnInfo(&pBtnInfo->m_nSizeExtraInfo,
							  &pBtnInfo->m_pExtraInfo);

		pEx->m_btnInfo.Add(pBtnInfo);
	}

	pInfo->m_pBarInfoEx = pEx;
}

void SECCustomToolBar::SetBarInfoEx(SECControlBarInfo* pInfo,
									CFrameWnd* /*pFrameWnd*/)
{
	if (pInfo == NULL || pInfo->m_pBarInfoEx == NULL)
		return;

	if (!pInfo->m_pBarInfoEx->IsKindOf(RUNTIME_CLASS(SECCustomToolBarInfoEx)))
		return;

	SECCustomToolBarInfoEx* pEx =
		(SECCustomToolBarInfoEx*)pInfo->m_pBarInfoEx;

	if (!pEx->m_strBarName.IsEmpty() && GetSafeHwnd() != NULL)
		SetWindowText(pEx->m_strBarName);

	INT_PTR nCount = pEx->m_btnInfo.GetSize();
	if (nCount <= 0)
		return;

	UINT* pIDs = new UINT[nCount];
	for (INT_PTR i = 0; i < nCount; i++)
		pIDs[i] = pEx->m_btnInfo[i]->m_nID;

	SetButtons(pIDs, (int)nCount);
	delete [] pIDs;

	// Jetzt duerfen die Knoepfe ihren eigenen Zustand zurueckholen - bei
	// einem SECWndBtn ist das die gezogene Breite.
	for (INT_PTR i = 0; i < nCount && i < GetBtnCount(); i++)
	{
		m_btns[(int)i]->SetBtnInfo(pEx->m_btnInfo[i]->m_nSizeExtraInfo,
								   pEx->m_btnInfo[i]->m_pExtraInfo);
	}
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Anordnung der Knoepfe
//
// VEREINFACHUNG, ausdruecklich benannt: das Original bricht die Leiste mit
// CanWrapRow/PerformWrap/CalcSize/BalanceWrap so um, dass die Zeilen
// moeglichst gleich lang werden. Diese Fassung bricht schlicht um, sobald
// der naechste Knopf nicht mehr passt. Das Ergebnis ist eine benutzbare
// Leiste mit unter Umstaenden ungleich langen Zeilen; die vier genannten
// Methoden bleiben als Haken erhalten, damit SECCustomizeToolBar::BalanceWrap
// (tbarpage.h:157) und QCCustomizeToolBar weiter greifen koennen.

void SECCustomToolBar::SetMode(BOOL bVertDock)
{
	if (m_bVertical == bVertDock)
		return;

	m_bVertical = bVertDock;

	for (int i = 0; i < GetBtnCount(); i++)
		m_btns[i]->SetMode(bVertDock);
}

// Ordnet die Knoepfe an und liefert die benoetigte Groesse. nLength ist die
// verfuegbare Ausdehnung entlang der Hauptachse.
CSize SECCustomToolBar::SizeToolBar(int nLength, BOOL bVert)
{
	SetMode(bVert);

	if (nLength <= 0)
		nLength = 32767;

	int nMain  = 0;		// laufende Ausdehnung entlang der Hauptachse
	int nCross = 0;		// Beginn der laufenden Zeile quer dazu
	int nRowExtent = 0;	// Dicke der laufenden Zeile
	int nMaxMain = 0;	// laengste Zeile

	for (int i = 0; i < GetBtnCount(); i++)
	{
		SECStdBtn* pBtn = m_btns[i];
		pBtn->m_nStyle &= ~TBBS_WRAPPED;

		int cxMain  = bVert ? pBtn->m_cy : pBtn->m_cx;
		int cyCross = bVert ? pBtn->m_cx : pBtn->m_cy;

		if (nMain > 0 && nMain + cxMain > nLength)
		{
			// Umbruch. Der vorhergehende Knopf ist die Umbruchstelle.
			if (i > 0)
				m_btns[i-1]->m_nStyle |= TBBS_WRAPPED;

			nMaxMain   = max(nMaxMain, nMain);
			nCross    += nRowExtent;
			nMain      = 0;
			nRowExtent = 0;

			// Ein Trenner am Zeilenanfang waere ein Loch. Das Original
			// merkt sich das in Wrapped::m_bAtSep; hier wird der Trenner
			// einfach uebersprungen (Groesse 0 entlang der Hauptachse).
			if (pBtn->m_nStyle & TBBS_SEPARATOR)
			{
				pBtn->SetPos(bVert ? nCross : 0, bVert ? 0 : nCross);
				continue;
			}
		}

		if (bVert)
			pBtn->SetPos(nCross, nMain);
		else
			pBtn->SetPos(nMain, nCross);

		nMain     += cxMain;
		nRowExtent = max(nRowExtent, cyCross);
	}

	nMaxMain = max(nMaxMain, nMain);
	int nTotalCross = nCross + nRowExtent;

	if (GetBtnCount() == 0)
	{
		nMaxMain    = GetStdBtnWidth();
		nTotalCross = GetStdBtnHeight();
	}

	// Haken fuer die abgeleiteten Klassen. Die Fassung dieser Stufe wertet
	// pWrap nicht aus, deshalb NULL - SECCustomizeToolBar::BalanceWrap
	// prueft darauf.
	BalanceWrap(0, NULL);

	CSize size;
	if (bVert)
	{
		size.cx = nTotalCross;
		size.cy = nMaxMain;
	}
	else
	{
		size.cx = nMaxMain;
		size.cy = nTotalCross;
	}

	return size;
}

// Rechnet die Randbreiten der Leiste auf die reine Knopfflaeche auf.
static void OTShimRaenderAufschlagen(SECCustomToolBar* pBar, CSize& size,
									 BOOL bHorz)
{
	CRect rect;
	rect.SetRectEmpty();

	// SECControlBar::CalcInsideRect (sbarcore.h:200, Stufe 2) liefert die
	// Raender als negatives Rechteck - dieselbe Uebereinkunft wie bei
	// CControlBar::CalcInsideRect. QCCustomToolBar.cpp:160 benutzt genau
	// diese Fassung mit drei Argumenten.
	pBar->CalcInsideRect(rect, bHorz, !bHorz);

	size.cx -= rect.Width();
	size.cy -= rect.Height();
}

CSize SECCustomToolBar::CalcLayout(int nLength, DWORD dwMode)
{
	BOOL bHorz = (dwMode & LM_HORZ) != 0;
	if (dwMode & LM_HORZDOCK)
		bHorz = TRUE;
	if (dwMode & LM_VERTDOCK)
		bHorz = FALSE;

	CSize size = SizeToolBar((dwMode & LM_STRETCH) ? 32767 : nLength, !bHorz);
	OTShimRaenderAufschlagen(this, size, bHorz);

	// Die eigenen Kopien mitfuehren. QCChildToolBar.h:43 liest
	// m_szTbarDockHorz.cy als Hoehe der Leiste.
	if (dwMode & LM_HORZDOCK)
	{
		m_szTbarDockHorz = size;
		m_bHorzDockSizeUnknown = FALSE;
	}
	else if (dwMode & LM_VERTDOCK)
	{
		m_szTbarDockVert = size;
		m_bVertDockSizeUnknown = FALSE;
	}
	else
	{
		m_szTbarFloat = size;
		m_bFloatSizeUnknown = FALSE;
	}

	return size;
}

CSize SECCustomToolBar::CalcFixedLayout(BOOL bStretch, BOOL bHorz)
{
	DWORD dwMode = bHorz ? (LM_HORZ | LM_HORZDOCK) : LM_VERTDOCK;
	if (bStretch)
		dwMode |= LM_STRETCH;

	CSize size = CalcLayout(bStretch ? 32767 : 0, dwMode);

	// Eine angedockte, gestreckte Leiste belegt die ganze Zeile.
	if (bStretch)
	{
		if (bHorz)
			size.cx = 32767;
		else
			size.cy = 32767;
	}

	return size;
}

CSize SECCustomToolBar::CalcDynamicLayout(int nLength, DWORD dwMode)
{
	if (dwMode & LM_MRUWIDTH)
		nLength = (int)m_nMRUWidth;

	CSize size = CalcLayout(nLength, dwMode);

	if (dwMode & LM_COMMIT)
		m_nMRUWidth = (UINT)size.cx;

	return size;
}

// Haken. Diese Stufe bricht ohne Ausgleich um (siehe Abschnittskommentar),
// deshalb bleibt der Rumpf leer. SECCustomizeToolBar ueberschreibt ihn.
void SECCustomToolBar::BalanceWrap(int /*nRow*/, Wrapped* /*pWrap*/)
{
}

// Die drei Rechenhilfen des Originals fuer den Zeilenausgleich. Sie werden
// von dieser Fassung nicht gebraucht, bleiben aber vorhanden - "Dummy statt
// Weglassen" - und liefern brauchbare Werte, falls sie jemand aufruft.
BOOL SECCustomToolBar::CanWrapRow(int /*nRowToWrap*/, int /*nMaxSize*/,
								  int /*nRows*/, Wrapped* /*pWrap*/)
{
	return FALSE;
}

int SECCustomToolBar::PerformWrap(int nLength, Wrapped* /*pWrap*/)
{
	CSize size = SizeToolBar(nLength, m_bVertical);
	return m_bVertical ? size.cy : size.cx;
}

CSize SECCustomToolBar::CalcSize(int /*nRows*/, Wrapped* /*pWrap*/)
{
	return m_bVertical ? m_szTbarDockVert : m_szTbarDockHorz;
}

void SECCustomToolBar::GetInsideRect(CRect& rectInside) const
{
	// Im Original zieht diese Fassung zusaetzlich den Platz des Griffs ab.
	// Das erledigt in dieser Schicht SECControlBar (Stufe 2) ueber
	// AdjustInsideRectForGripper, deshalb genuegt die Weitergabe.
	SECControlBar::GetInsideRect(rectInside);
}

void SECCustomToolBar::AdjustInsideRectForGripper(CRect& rect, BOOL bHorz)
{
	SECControlBar::AdjustInsideRectForGripper(rect, bHorz);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Zeichnen

void SECCustomToolBar::DoPaint(CDC* pDC)
{
	ASSERT_VALID(this);
	ASSERT_VALID(pDC);

	// Raender und Griff macht die Basis (Stufe 2).
	SECControlBar::DoPaint(pDC);

	if (m_hBmp == NULL || GetBtnCount() == 0)
		return;

	SECBtnDrawData& data = GetDrawData();

	if (!data.PreDrawButton(*pDC, m_hBmp, m_nMaxBtnWidth, this))
		return;

	for (int i = 0; i < GetBtnCount(); i++)
		m_btns[i]->DrawButton(*pDC, data);

	data.PostDrawButton();
}

void SECCustomToolBar::DrawBorders(CDC* pDC, CRect& rect)
{
	SECControlBar::DrawBorders(pDC, rect);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Befehlszustand
//
// Nachbau von CToolBar::OnUpdateCmdUI (winctrl3.cpp): fuer jeden Knopf wird
// der Befehlszustand beim Rahmenfenster erfragt und in TBBS_DISABLED,
// TBBS_CHECKED und TBBS_INDETERMINATE uebersetzt. Ohne das bliebe jeder
// Knopf dauerhaft freigegeben und kein Ankreuzknopf wuerde je gedrueckt
// aussehen.

class SECToolBarCmdUI : public CCmdUI
{
public:
	virtual void Enable(BOOL bOn);
	virtual void SetCheck(int nCheck);
	virtual void SetText(LPCTSTR lpszText);
};

void SECToolBarCmdUI::Enable(BOOL bOn)
{
	m_bEnableChanged = TRUE;

	SECCustomToolBar* pToolBar = (SECCustomToolBar*)m_pOther;
	ASSERT(pToolBar != NULL);
	ASSERT_KINDOF(SECCustomToolBar, pToolBar);

	UINT nNewStyle = pToolBar->GetButtonStyle((int)m_nIndex) & ~TBBS_DISABLED;
	if (!bOn)
	{
		nNewStyle |= TBBS_DISABLED;
		// Ein gesperrter Knopf darf nicht gedrueckt aussehen.
		nNewStyle &= ~TBBS_PRESSED;
	}

	pToolBar->SetButtonStyle((int)m_nIndex, nNewStyle);
}

void SECToolBarCmdUI::SetCheck(int nCheck)
{
	ASSERT(nCheck >= 0 && nCheck <= 2);

	SECCustomToolBar* pToolBar = (SECCustomToolBar*)m_pOther;
	ASSERT(pToolBar != NULL);
	ASSERT_KINDOF(SECCustomToolBar, pToolBar);

	UINT nNewStyle = pToolBar->GetButtonStyle((int)m_nIndex) &
					 ~(TBBS_CHECKED | TBBS_INDETERMINATE);

	if (nCheck == 1)
		nNewStyle |= TBBS_CHECKED;
	else if (nCheck == 2)
		nNewStyle |= TBBS_INDETERMINATE;

	pToolBar->SetButtonStyle((int)m_nIndex, nNewStyle);
}

// Ein Knopf hat keinen Text. Die Fassung bleibt, weil CCmdUI::SetText rein
// virtuell benutzt wird, sobald ein Befehlsbehandler SetText aufruft.
void SECToolBarCmdUI::SetText(LPCTSTR /*lpszText*/)
{
}

void SECCustomToolBar::OnUpdateCmdUI(CFrameWnd* pTarget,
									 BOOL bDisableIfNoHndler)
{
	SECToolBarCmdUI state;
	state.m_pOther = this;
	state.m_nIndexMax = (UINT)GetBtnCount();

	for (state.m_nIndex = 0; state.m_nIndex < state.m_nIndexMax;
		 state.m_nIndex++)
	{
		SECStdBtn* pBtn = m_btns[(int)state.m_nIndex];
		if (pBtn->m_nStyle & TBBS_SEPARATOR)
			continue;

		state.m_nID = pBtn->m_nID;
		state.DoUpdate(pTarget, bDisableIfNoHndler);
	}
}

void SECCustomToolBar::OnBarStyleChange(DWORD dwOldStyle, DWORD dwNewStyle)
{
	SECControlBar::OnBarStyleChange(dwOldStyle, dwNewStyle);

	for (int i = 0; i < GetBtnCount(); i++)
		m_btns[i]->BarStyleChanged(dwNewStyle);
}

// Der Kurzhinweis kommt vom Knopf unter dem Zeiger. TBarSendButton.cpp:192
// setzt dort LPSTR_TEXTCALLBACK, QCCustomToolBar::OnNotify beantwortet die
// Rueckfrage (QCCustomToolBar.cpp:900-950).
INT_PTR SECCustomToolBar::OnToolHitTest(CPoint point, TOOLINFO* pTI) const
{
	for (int i = 0; i < GetBtnCount(); i++)
	{
		int nHit = m_btns[i]->OnToolHitTest(point, pTI);
		if (nHit != -1)
			return nHit;
	}

	return SECControlBar::OnToolHitTest(point, pTI);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Maus und Befehlsabsetzung

void SECCustomToolBar::UpdateButton(int nIndex)
{
	if (nIndex < 0 || nIndex >= GetBtnCount())
		return;

	UINT nID = m_btns[nIndex]->m_nID;
	if (nID == 0 || nID == (UINT)-1)
		return;

	CWnd* pOwner = GetOwner();
	if (pOwner == NULL)
		pOwner = GetParent();
	if (pOwner == NULL)
		return;

	// Der Verwalter merkt sich, dass gerade ein Leistenbefehl laeuft, und
	// wo der Knopf liegt. mainfrm.cpp fragt das ueber IsMainFrameEnabled
	// nicht ab, aber SECToolBarManager::IsToolBarCommand gehoert zur
	// Oberflaeche.
	CRect rect;
	m_btns[nIndex]->GetBtnRect(rect);
	ClientToScreen(&rect);

	SECToolBarManager* pMgr = NULL;
	if (m_pManager != NULL && m_pManager->IsKindOf(RUNTIME_CLASS(SECToolBarManager)))
		pMgr = (SECToolBarManager*)m_pManager;

	if (pMgr != NULL)
		pMgr->SetInToolBarCommand(TRUE, rect);

	pOwner->SendMessage(WM_COMMAND, (WPARAM)nID, (LPARAM)0);

	if (pMgr != NULL)
		pMgr->SetInToolBarCommand(FALSE, rect);
}

void SECCustomToolBar::OnLButtonDown(UINT nFlags, CPoint point)
{
	if (::GetCapture() == m_hWnd)
		return;

	CRect rect;
	int nIndex = ItemFromPoint(point, rect);

	if (nIndex < 0 || (m_btns[nIndex]->m_nStyle & TBBS_SEPARATOR))
	{
		// Kein Knopf getroffen - die Basis darf das Verschieben der Leiste
		// aufnehmen.
		SECControlBar::OnLButtonDown(nFlags, point);
		return;
	}

	// Ziehen im Anpassen-Modus oder mit Alt-Taste. DragButton meldet mit
	// FALSE, dass es nicht zustaendig ist.
	m_bAltDrag = (!m_bConfig && (::GetKeyState(VK_MENU) < 0));
	if (m_bConfig || m_bAltDrag)
	{
		if (DragButton(nIndex, point))
			return;

		m_bAltDrag = FALSE;
		return;
	}

	SECStdBtn* pBtn = m_btns[nIndex];
	if (pBtn->m_nStyle & TBBS_DISABLED)
		return;

	m_nDown = nIndex;
	SetCapture();

	if (!pBtn->BtnPressDown(point))
	{
		// Der Knopf hat den Druck nicht angenommen - etwa CTBarMenuButton,
		// wenn kein Menue haengt, oder ein zweiteiliger Knopf nach dem
		// Aufklappen (ColorToolbarButton.cpp:126 gibt FALSE zurueck, "act
		// like nothing ever happened").
		if (::GetCapture() == m_hWnd)
			::ReleaseCapture();
		m_nDown = -1;
		return;
	}

	UpdateWindow();
}

void SECCustomToolBar::OnMouseMove(UINT nFlags, CPoint point)
{
	if (::GetCapture() == m_hWnd && m_nDown >= 0 && m_nDown < GetBtnCount())
	{
		m_btns[m_nDown]->BtnPressMouseMove(point);
		return;
	}

	// "Cool"-Darstellung: der Knopf unter dem Zeiger hebt sich ab.
	if (CoolLookEnabled())
		RaiseButton();

	SECControlBar::OnMouseMove(nFlags, point);
}

void SECCustomToolBar::OnLButtonUp(UINT nFlags, CPoint point)
{
	if (::GetCapture() != m_hWnd || m_nDown < 0)
	{
		SECControlBar::OnLButtonUp(nFlags, point);
		return;
	}

	int nIndex = m_nDown;
	m_nDown = -1;
	::ReleaseCapture();

	if (nIndex >= GetBtnCount())
		return;

	UINT nCmd = m_btns[nIndex]->BtnPressUp(point);
	UpdateWindow();

	if (nCmd == 0)
		return;

	// Die Kennung kann von der des Knopfes abweichen: der zweite Teil eines
	// SECTwoPartBtn setzt m_nDispatchID2 ab (tbtn2prt.h:66).
	if (nCmd == m_btns[nIndex]->m_nID)
	{
		UpdateButton(nIndex);
	}
	else
	{
		CWnd* pOwner = GetOwner();
		if (pOwner == NULL)
			pOwner = GetParent();
		if (pOwner != NULL)
			pOwner->SendMessage(WM_COMMAND, (WPARAM)nCmd, (LPARAM)0);
	}
}

void SECCustomToolBar::OnCancelMode()
{
	SECControlBar::OnCancelMode();

	if (m_nDown >= 0 && m_nDown < GetBtnCount())
		m_btns[m_nDown]->BtnPressCancel();

	m_nDown = -1;

	if (::GetCapture() == m_hWnd)
		::ReleaseCapture();
}

// Ein Klick auf die Leiste darf das Rahmenfenster nicht aktivieren - sonst
// verliert das Dokumentfenster beim ersten Knopfdruck den Eingabefokus.
int SECCustomToolBar::OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest,
									  UINT message)
{
	int nResult = SECControlBar::OnMouseActivate(pDesktopWnd, nHitTest,
												 message);
	if (nResult == MA_ACTIVATE)
		nResult = MA_NOACTIVATE;
	else if (nResult == MA_ACTIVATEANDEAT)
		nResult = MA_NOACTIVATEANDEAT;

	return nResult;
}

// Hebt den Knopf unter dem Zeiger an und senkt den vorher angehobenen ab.
void SECCustomToolBar::RaiseButton()
{
	CPoint pt;
	::GetCursorPos(&pt);
	ScreenToClient(&pt);

	CRect rect;
	int nIndex = ItemFromPoint(pt, rect);

	if (nIndex >= 0 && (m_btns[nIndex]->m_nStyle &
						(TBBS_SEPARATOR | TBBS_DISABLED)))
		nIndex = -1;

	if (nIndex == m_nRaised)
		return;

	if (m_nRaised >= 0 && m_nRaised < GetBtnCount())
	{
		m_btns[m_nRaised]->m_nStyle &= ~SEC_TBBS_RAISED;
		m_btns[m_nRaised]->Invalidate();
	}

	m_nRaised = nIndex;

	if (m_nRaised >= 0)
	{
		m_btns[m_nRaised]->m_nStyle |= SEC_TBBS_RAISED;
		m_btns[m_nRaised]->Invalidate();

		// Der Zeiger kann die Leiste verlassen, ohne dass noch ein
		// WM_MOUSEMOVE kommt. Der Zeitgeber senkt den Knopf dann ab.
		SetTimer(OTSHIM_TIMER_RAISED, 150, NULL);
	}
	else
	{
		KillTimer(OTSHIM_TIMER_RAISED);
	}
}

void SECCustomToolBar::OnTimer(UINT_PTR nIDEvent)
{
	if (nIDEvent == OTSHIM_TIMER_RAISED)
	{
		CPoint pt;
		::GetCursorPos(&pt);

		CRect rect;
		GetWindowRect(rect);

		if (!rect.PtInRect(pt) || ::WindowFromPoint(pt) != m_hWnd)
		{
			if (m_nRaised >= 0 && m_nRaised < GetBtnCount())
			{
				m_btns[m_nRaised]->m_nStyle &= ~SEC_TBBS_RAISED;
				m_btns[m_nRaised]->Invalidate();
			}
			m_nRaised = -1;
			KillTimer(OTSHIM_TIMER_RAISED);
		}

		return;
	}

	SECControlBar::OnTimer(nIDEvent);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Nachrichtenbehandlung

void SECCustomToolBar::OnWindowPosChanging(LPWINDOWPOS lpWndPos)
{
	SECControlBar::OnWindowPosChanging(lpWndPos);
}

void SECCustomToolBar::OnShowWindow(BOOL bShow, UINT nStatus)
{
	SECControlBar::OnShowWindow(bShow, nStatus);
	NotifyManager(bShow ? BarShow : BarHide);
}

void SECCustomToolBar::OnSysColorChange()
{
	SECControlBar::OnSysColorChange();

	// secData haelt die zwischengespeicherten Systemfarben, die der ganze
	// Zeichencode liest (secaux.cpp:51-62).
	secData.UpdateSysColors();

	if (m_pManager != NULL &&
		m_pManager->IsKindOf(RUNTIME_CLASS(SECToolBarManager)))
		((SECToolBarManager*)m_pManager)->SysColorChange();

	Invalidate();
}

void SECCustomToolBar::OnDestroy()
{
	NotifyManager(BarDelete);

	KillTimer(OTSHIM_TIMER_RAISED);

	SECControlBar::OnDestroy();
}

void SECCustomToolBar::DelayShow(BOOL bShow)
{
	SECControlBar::DelayShow(bShow);
}

// tbarcust.h:367. Siehe die Anmerkung in der Kopfdatei: die Signatur passt
// in MFC 14 in keinen Eintrag der Nachrichtentabelle mehr, deshalb wird
// diese Fassung nie gerufen. Sie bleibt trotzdem stehen.
LONG SECCustomToolBar::OnNoDelayHide(UINT /*nID*/, LONG /*lParam*/)
{
	return 0L;
}

void SECCustomToolBar::NotifyManager(BarNotifyCode nCode)
{
	if (m_pManager == NULL || GetSafeHwnd() == NULL)
		return;

	if (!m_pManager->IsKindOf(RUNTIME_CLASS(SECToolBarManager)))
		return;

	((SECToolBarManager*)m_pManager)->BarNotify(GetDlgCtrlID(), nCode);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBar - Anpassen-Modus
//
// AUFTRAGSLAGE: "Der Anpassungsdialog fuer Werkzeugleisten darf ein Dummy
// bleiben." Der Modus selbst wird gefuehrt - EnableConfigMode, der Fokus und
// die Meldung BarDesChange arbeiten wirklich, weil die Anpassen-Seiten von
// Eudora sie auswerten (QCCustomizeSignaturesPage.cpp:196-212 fragt
// GetCurBtn ab). Nur das Ziehen von Knoepfen ist nicht umgesetzt.

void SECCustomToolBar::EnableConfigMode(BOOL bEnable)
{
	if (m_bConfig == bEnable)
		return;

	m_bConfig = bEnable;

	if (!bEnable)
		RemoveConfigFocus(TRUE);

	if (GetSafeHwnd() != NULL)
		Invalidate();
}

void SECCustomToolBar::SetConfigFocus(int nBtn, BOOL bRedraw)
{
	if (m_nDown >= 0 && m_nDown < GetBtnCount())
	{
		m_btns[m_nDown]->m_nStyle &= ~SEC_TBBS_FOCUS;
		if (bRedraw)
			m_btns[m_nDown]->Invalidate();
	}

	m_nDown = nBtn;

	if (m_nDown >= 0 && m_nDown < GetBtnCount())
	{
		m_btns[m_nDown]->m_nStyle |= SEC_TBBS_FOCUS;
		if (bRedraw)
			m_btns[m_nDown]->Invalidate();
	}

	// Diese Leiste hat jetzt den Anpassen-Fokus des Verwalters.
	SetConfigFocus(this);

	NotifyManager(BarDesChange);
}

void SECCustomToolBar::RemoveConfigFocus(BOOL bRedraw)
{
	SetConfigFocus(-1, bRedraw);
}

// tbarcust.h:183: "Returns TRUE if the default drag mode is add."
// QCChildToolBar.cpp und SECCustomizeToolBar ueberschreiben das.
BOOL SECCustomToolBar::GetDragMode() const
{
	return FALSE;
}

// tbarcust.h:186. QCCustomToolBar.cpp:145 reicht auf diese Fassung durch.
BOOL SECCustomToolBar::AcceptDrop() const
{
	return m_bConfig;
}

// NICHT UMGESETZT - und das meldet sich beim Anwender, statt still nichts zu
// tun. Das Ziehen eines Knopfes ist der Kern des Anpassen-Dialogs; wer im
// Anpassen-Modus an einem Knopf zieht und nichts geschieht, haelt das fuer
// einen Fehler.
BOOL SECCustomToolBar::DragButton(int /*nIndex*/, CPoint /*point*/)
{
	static BOOL bGemeldet = FALSE;
	OTShimWzlNichtUmgesetzt(bGemeldet,
		_T("Knoepfe einer Werkzeugleiste mit der Maus verschieben, ")
		_T("hinzufuegen oder entfernen."));

	return FALSE;
}

// Gegenstueck zu DragButton. Ohne Ziehen gibt es kein Ablegen; die Fassung
// bleibt, weil QCCustomToolBar.cpp:151 und QCChildToolBar sie ueberschreiben
// und die Vererbungskette durchgaengig sein muss.
void SECCustomToolBar::DropButton(CRect& /*dropRect*/,
								  SECStdBtn* /*pDragBtn*/, BOOL /*bAdd*/)
{
}

// Sucht die Zeile, ueber der abgelegt wurde. Wird nur aus DropButton heraus
// gebraucht und liefert deshalb die ganze Leiste als eine Zeile.
void SECCustomToolBar::FindRow(CRect& /*clientRect*/, CRect& /*dropRect*/,
							   int& nRowStart, int& nRowEnd)
{
	nRowStart = 0;
	nRowEnd   = GetBtnCount();
}

BOOL SECCustomToolBar::SmallDrag(CRect& /*dropRect*/, int /*nRowStart*/,
								 int /*nRowEnd*/, BOOL /*bAdd*/)
{
	return FALSE;
}

// Eine neue Leiste aus einem herausgezogenen Knopf. Ohne Ziehen unerreichbar;
// QCCustomizeToolBar.cpp:163 hat eine eigene Fassung mit anderer Signatur.
void SECCustomToolBar::NewToolBar(CPoint /*pt*/, const SECStdBtn& /*btn*/)
{
}

// Sucht die Leiste unter einem Bildschirmpunkt. QCCustomizeToolBar.cpp:89
// benutzt statt dessen SECToolBarManager::ToolBarUnderRect.
SECCustomToolBar* SECCustomToolBar::ToolBarFromPoint(int x, int y)
{
	CWnd* pWnd = CWnd::WindowFromPoint(CPoint(x, y));

	while (pWnd != NULL)
	{
		if (pWnd->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
			return (SECCustomToolBar*)pWnd;

		pWnd = pWnd->GetParent();
	}

	return NULL;
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomToolBarInfoEx

IMPLEMENT_DYNCREATE(SECCustomToolBarInfoEx, SECControlBarInfoEx)

SECCustomToolBarInfoEx::SECCustomToolBarInfoEx()
{
}

SECCustomToolBarInfoEx::~SECCustomToolBarInfoEx()
{
	for (INT_PTR i = 0; i < m_btnInfo.GetSize(); i++)
		delete m_btnInfo[i];

	m_btnInfo.RemoveAll();
}

// Der Puffer stammt aus SECStdBtn::GetBtnInfo und ist dort mit new[] angelegt
// (SECWndBtn::GetBtnInfo tut das wirklich, SECStdBtn liefert NULL).
SECCustomToolBarInfoEx::BtnInfo::~BtnInfo()
{
	delete [] m_pExtraInfo;
	m_pExtraInfo = NULL;
	m_nSizeExtraInfo = 0;
}

void SECCustomToolBarInfoEx::Serialize(CArchive& ar, SECDockState* pDockState)
{
	SECControlBarInfoEx::Serialize(ar, pDockState);

	if (ar.IsStoring())
	{
		ar << m_strBarName;
		ar << (DWORD)m_btnInfo.GetSize();

		for (INT_PTR i = 0; i < m_btnInfo.GetSize(); i++)
		{
			BtnInfo* pInfo = m_btnInfo[i];
			ar << (DWORD)pInfo->m_nID;
			ar << (BYTE)pInfo->m_nSizeExtraInfo;
			if (pInfo->m_nSizeExtraInfo > 0 && pInfo->m_pExtraInfo != NULL)
				ar.Write(pInfo->m_pExtraInfo, pInfo->m_nSizeExtraInfo);
		}
	}
	else
	{
		DWORD dwCount = 0;
		ar >> m_strBarName;
		ar >> dwCount;

		for (DWORD i = 0; i < dwCount; i++)
		{
			BtnInfo* pInfo = new BtnInfo;
			DWORD dwID = 0;
			BYTE  nSize = 0;

			ar >> dwID;
			ar >> nSize;

			pInfo->m_nID = (UINT)dwID;
			pInfo->m_nSizeExtraInfo = nSize;

			if (nSize > 0)
			{
				pInfo->m_pExtraInfo = new BYTE[nSize];
				ar.Read(pInfo->m_pExtraInfo, nSize);
			}

			m_btnInfo.Add(pInfo);
		}
	}
}

// Der Zustand einer Leiste steht in der INI-Datei, nicht in einem Archiv -
// Eudora sichert seine eigenen Zusatzangaben genauso
// (QCCustomToolBar::SaveCustomInfo, QCCustomToolBar.cpp:368-480).
//
// Aufbau des Eintrags: "Titel,Kennung1,Kennung2,..." unter dem Schluessel
// "Buttons" des uebergebenen Abschnitts.
BOOL SECCustomToolBarInfoEx::SaveState(LPCTSTR lpszSection)
{
	CWinApp* pApp = AfxGetApp();
	if (pApp == NULL || lpszSection == NULL)
		return FALSE;

	CString strValue = m_strBarName;
	for (INT_PTR i = 0; i < m_btnInfo.GetSize(); i++)
	{
		CString strID;
		strID.Format(_T(",%u"), m_btnInfo[i]->m_nID);
		strValue += strID;
	}

	return pApp->WriteProfileString(lpszSection, _T("Buttons"), strValue);
}

BOOL SECCustomToolBarInfoEx::LoadState(LPCTSTR lpszSection,
									   SECDockState* /*pDockState*/)
{
	CWinApp* pApp = AfxGetApp();
	if (pApp == NULL || lpszSection == NULL)
		return FALSE;

	CString strValue = pApp->GetProfileString(lpszSection, _T("Buttons"),
											  _T(""));
	if (strValue.IsEmpty())
		return FALSE;

	for (INT_PTR i = 0; i < m_btnInfo.GetSize(); i++)
		delete m_btnInfo[i];
	m_btnInfo.RemoveAll();

	int nPos = 0;
	m_strBarName = strValue.Tokenize(_T(","), nPos);

	while (nPos >= 0)
	{
		CString strID = strValue.Tokenize(_T(","), nPos);
		if (strID.IsEmpty())
			break;

		BtnInfo* pInfo = new BtnInfo;
		pInfo->m_nID = (UINT)_ttoi(strID);
		m_btnInfo.Add(pInfo);
	}

	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 7 - SECLoadToolBarResource und SECToolBarManager
//
/////////////////////////////////////////////////////////////////////////////

// Die angemeldeten Fensternachrichten. Die Namen sind die, unter denen sie
// im Original angemeldet wurden - sie muessen zwischen allen Beteiligten
// gleich lauten, sonst kommen die Meldungen nicht an. Belegt ist nur, DASS
// sie angemeldet sind (tbarmgr.h:54-55  extern const int ...).
//
// ABWEICHUNG: der genaue Zeichenkettenname des Originals ist nicht belegbar.
// Da beide Enden dieser Verbindung in dieser Schicht liegen bzw. in Eudora
// ueber denselben Bezeichner gehen (QCCustomizeSignaturesPage.cpp:110), ist
// der Name gleichgueltig - er muss nur eindeutig sein.
extern const int wmSECNotifyMsg =
	(int)::RegisterWindowMessage(_T("SECNotifyMsg"));
extern const int wmSECToolBarWndNotify =
	(int)::RegisterWindowMessage(_T("SECToolBarWndNotify"));

// tbarsdlg.h:229 deklariert diese dritte Nachricht. tbarsdlg.h wird von
// dieser Schicht NICHT ersetzt (SECToolBarsDlg braucht Eudora nicht), die
// Definition muss aber irgendwo stehen, weil SECToolBarCmdPage sie in seine
// Nachrichtentabelle eintraegt.
extern const int wmSECToolBarStyleChanging =
	(int)::RegisterWindowMessage(_T("SECToolBarStyleChanging"));


// Aufbau einer RT_TOOLBAR-Ressource. Wortgleich zu MFCs interner
// CToolBarData (winctrl3.cpp) - der Ressourcenaufbau ist ein Vertrag des
// Ressourcencompilers, kein MFC-Detail.
struct OTShimToolBarData
{
	WORD wVersion;
	WORD wWidth;
	WORD wHeight;
	WORD wItemCount;

	WORD* items()
		{ return (WORD*)(this + 1); }
};

// tbarcust.h:451. QCToolBarManager.cpp:346, 354, 360 ruft sie dreimal auf
// und setzt die drei Bitmaps danach zu einer zusammen; dabei wird
// ASSERT((int)nBmpItems == bmWidth / bmHeight) geprueft
// (QCToolBarManager.cpp:399-401). nBmpItems muss also die Anzahl der BILDER
// sein, nicht die Anzahl der Eintraege - Trenner haben kein Bild.
BOOL SECLoadToolBarResource(LPCTSTR lpszResourceName, CBitmap& bmp,
							UINT*& pBmpItems, UINT& nBmpItems,
							int& nImgWidth, int& nImgHeight,
							UINT* pBtnCount, UINT** ppBtnArray)
{
	HINSTANCE hInst = AfxFindResourceHandle(lpszResourceName, RT_TOOLBAR);
	HRSRC hRsrc = ::FindResource(hInst, lpszResourceName, RT_TOOLBAR);
	if (hRsrc == NULL)
		return FALSE;

	HGLOBAL hGlobal = ::LoadResource(hInst, hRsrc);
	if (hGlobal == NULL)
		return FALSE;

	OTShimToolBarData* pData = (OTShimToolBarData*)::LockResource(hGlobal);
	if (pData == NULL)
	{
		::FreeResource(hGlobal);
		return FALSE;
	}

	ASSERT(pData->wVersion == 1);

	int nWidth  = (int)pData->wWidth;
	int nHeight = (int)pData->wHeight;
	int nItems  = (int)pData->wItemCount;

	// Erst zaehlen, dann fuellen. ID_SEPARATOR ist 0.
	UINT nImages = 0;
	int i;
	for (i = 0; i < nItems; i++)
	{
		if (pData->items()[i] != 0)
			nImages++;
	}

	UINT* pIDs = new UINT[nImages > 0 ? nImages : 1];
	UINT j = 0;
	for (i = 0; i < nItems; i++)
	{
		if (pData->items()[i] != 0)
			pIDs[j++] = (UINT)pData->items()[i];
	}

	// Die vollstaendige Liste einschliesslich der Trenner, falls verlangt.
	if (pBtnCount != NULL)
		*pBtnCount = (UINT)nItems;

	if (ppBtnArray != NULL)
	{
		UINT* pAll = new UINT[nItems > 0 ? nItems : 1];
		for (i = 0; i < nItems; i++)
			pAll[i] = (UINT)pData->items()[i];
		*ppBtnArray = pAll;
	}

	::UnlockResource(hGlobal);
	::FreeResource(hGlobal);

	// Die Bitmap traegt dieselbe Kennung wie die Werkzeugleistenressource.
	// LoadMappedBitmap tauscht dabei die Graustufen gegen die aktuellen
	// Systemfarben - dasselbe, was SECLoadSysColorBitmap (OTShim.h) fuer
	// einzelne Bilder tut.
	if (bmp.GetSafeHandle() != NULL)
		bmp.DeleteObject();

	BOOL bLoaded;
	if (IS_INTRESOURCE(lpszResourceName))
		bLoaded = bmp.LoadMappedBitmap(
					(UINT)(UINT_PTR)(void*)lpszResourceName);
	else
		bLoaded = bmp.LoadBitmap(lpszResourceName);

	if (!bLoaded)
	{
		delete [] pIDs;
		if (ppBtnArray != NULL)
		{
			delete [] *ppBtnArray;
			*ppBtnArray = NULL;
		}
		return FALSE;
	}

	pBmpItems  = pIDs;
	nBmpItems  = nImages;
	nImgWidth  = nWidth;
	nImgHeight = nHeight;

	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarManager

IMPLEMENT_DYNAMIC(SECToolBarManager, SECControlBarManager)

BEGIN_MESSAGE_MAP(SECToolBarManager, SECControlBarManager)
END_MESSAGE_MAP()

SECToolBarManager::SECToolBarManager()
	: SECControlBarManager()
{
	m_pNoDropWnd        = NULL;
	m_bMainFrameEnabled = TRUE;
	m_bConfig           = FALSE;
	m_bToolTips         = TRUE;
	m_bFlyBy            = TRUE;
	m_bCoolLook         = TRUE;
	m_bLargeBmp         = FALSE;
	m_bInToolBarCommand = FALSE;
	m_pBtnMap           = NULL;
	m_pConfigFocus      = NULL;
	m_nBmpItems         = 0;
	m_lpszStdBmpName    = NULL;
	m_lpszLargeBmpName  = NULL;
	m_pBmpItems         = NULL;
	m_nImgHeight        = SEC_TOOLBAR_IMAGE_HEIGHT;
	m_nImgWidth         = SEC_TOOLBAR_IMAGE_WIDTH;
	m_btnRect.SetRectEmpty();

	// QCToolBarManager.cpp:260 ueberschreibt das gleich wieder mit
	// RUNTIME_CLASS(QCCustomToolBar).
	m_pToolBarClass     = RUNTIME_CLASS(SECCustomToolBar);
}

SECToolBarManager::SECToolBarManager(CFrameWnd* pFrameWnd)
	: SECControlBarManager(pFrameWnd)
{
	m_pNoDropWnd        = NULL;
	m_bMainFrameEnabled = TRUE;
	m_bConfig           = FALSE;
	m_bToolTips         = TRUE;
	m_bFlyBy            = TRUE;
	m_bCoolLook         = TRUE;
	m_bLargeBmp         = FALSE;
	m_bInToolBarCommand = FALSE;
	m_pBtnMap           = NULL;
	m_pConfigFocus      = NULL;
	m_nBmpItems         = 0;
	m_lpszStdBmpName    = NULL;
	m_lpszLargeBmpName  = NULL;
	m_pBmpItems         = NULL;
	m_nImgHeight        = SEC_TOOLBAR_IMAGE_HEIGHT;
	m_nImgWidth         = SEC_TOOLBAR_IMAGE_WIDTH;
	m_btnRect.SetRectEmpty();
	m_pToolBarClass     = RUNTIME_CLASS(SECCustomToolBar);
}

SECToolBarManager::~SECToolBarManager()
{
	// Die Vorgabeleisten gehoeren dem Verwalter.
	for (INT_PTR i = 0; i < m_defaultBars.GetSize(); i++)
		delete (SECDefaultToolBar*)m_defaultBars[i];
	m_defaultBars.RemoveAll();

	delete [] m_pBmpItems;
	m_pBmpItems = NULL;
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarManager - Bitmap und Knopftabelle

// tbarmgr.h:102. Laedt die gemeinsame Bitmap. QCToolBarManager::
// LoadToolBarResource (QCToolBarManager.cpp:268) hat eine eigene Fassung,
// die drei Ressourcen zusammensetzt; die hier ist die einfache.
BOOL SECToolBarManager::LoadToolBarResource(LPCTSTR lpszStdBmpName,
											LPCTSTR lpszLargeBmpName)
{
	m_lpszStdBmpName   = lpszStdBmpName;
	m_lpszLargeBmpName = lpszLargeBmpName;

	return ChangeBitmap();
}

// Laedt die zur aktuellen Knopfgroesse passende Bitmap.
BOOL SECToolBarManager::ChangeBitmap()
{
	LPCTSTR lpszName = (m_bLargeBmp && m_lpszLargeBmpName != NULL)
						? m_lpszLargeBmpName : m_lpszStdBmpName;
	if (lpszName == NULL)
		return FALSE;

	UINT* pOldItems = m_pBmpItems;

	UINT* pItems  = NULL;
	UINT  nItems  = 0;
	int   nWidth  = 0;
	int   nHeight = 0;

	if (!SECLoadToolBarResource(lpszName, m_bmp, pItems, nItems, nWidth,
								nHeight))
		return FALSE;

	m_pBmpItems  = pItems;
	m_nBmpItems  = nItems;
	m_nImgWidth  = nWidth;
	m_nImgHeight = nHeight;

	delete [] pOldItems;

	// Alle Leisten mit der neuen Bitmap versorgen.
	if (m_pFrameWnd != NULL)
	{
		POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
		while (pos != NULL)
		{
			CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
			if (pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
				SetToolBarInfo((SECCustomToolBar*)pBar);
		}
	}

	return TRUE;
}

// mainfrm.cpp:1734 und sechs weitere Stellen. Reicht Bitmap, Zuordnung und
// Bildmasse an eine Leiste durch.
void SECToolBarManager::SetToolBarInfo(SECCustomToolBar* pToolBar)
{
	if (pToolBar == NULL)
		return;

	pToolBar->SetToolBarInfo((HBITMAP)m_bmp.GetSafeHandle(), m_pBmpItems,
							 m_nBmpItems, m_nImgWidth, m_nImgHeight);
}

void SECToolBarManager::SetButtonMap(const SECBtnMapEntry* pMap)
{
	m_pBtnMap = pMap;
}

const SECBtnMapEntry* SECToolBarManager::GetButtonMap() const
{
	return m_pBtnMap;
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarManager - Einstellungen

void SECToolBarManager::EnableToolTips(BOOL bEnable)
{
	m_bToolTips = bEnable;
	ChangeBarStyle(bEnable, CBRS_TOOLTIPS);
}

void SECToolBarManager::EnableFlyBy(BOOL bEnable)
{
	m_bFlyBy = bEnable;
	ChangeBarStyle(bEnable, CBRS_FLYBY);
}

BOOL SECToolBarManager::ToolTipsEnabled() const
{
	return m_bToolTips;
}

BOOL SECToolBarManager::FlyByEnabled() const
{
	return m_bFlyBy;
}

void SECToolBarManager::EnableCoolLook(BOOL bEnable, DWORD dwExCoolLookStyles)
{
	m_bCoolLook = bEnable;
	ChangeExBarStyle(bEnable, dwExCoolLookStyles);
}

BOOL SECToolBarManager::CoolLookEnabled() const
{
	return m_bCoolLook;
}

// KATEGORIE C laut PLAN.md: Eudora ruft das nie auf, weil die Methode im
// Original nicht virtuell ist. QCToolBarManager::QCEnableLargeBtns
// (QCToolBarManager.cpp:280-540) ist die Ersatzfassung, die drei
// Bitmapressourcen zusammensetzt; sie setzt m_bLargeBmp und m_pBmpItems
// selbst. Diese Fassung tut das Naheliegende - "Dummy statt Weglassen" -,
// damit ein Aufruf nicht ins Leere laeuft.
void SECToolBarManager::EnableLargeBtns(BOOL bEnable)
{
	if (m_bLargeBmp == bEnable)
		return;

	m_bLargeBmp = bEnable;
	ChangeBitmap();
}

// GEBRAUCHT: QCToolBarManager.cpp:276 gibt genau diesen Wert weiter.
BOOL SECToolBarManager::LargeBtnsEnabled() const
{
	return m_bLargeBmp;
}

void SECToolBarManager::ChangeBarStyle(BOOL bAdd, DWORD dwStyle)
{
	if (m_pFrameWnd == NULL)
		return;

	POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
	while (pos != NULL)
	{
		CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
		if (!pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
			continue;

		DWORD dwBarStyle = pBar->GetBarStyle();
		if (bAdd)
			dwBarStyle |= dwStyle;
		else
			dwBarStyle &= ~dwStyle;

		pBar->SetBarStyle(dwBarStyle);
	}
}

void SECToolBarManager::ChangeExBarStyle(BOOL bAdd, DWORD dwExStyle)
{
	if (m_pFrameWnd == NULL)
		return;

	POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
	while (pos != NULL)
	{
		CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
		if (!pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
			continue;

		SECCustomToolBar* pToolBar = (SECCustomToolBar*)pBar;
		if (bAdd)
			pToolBar->ModifyBarStyleEx(0, dwExStyle, TRUE);
		else
			pToolBar->ModifyBarStyleEx(dwExStyle, 0, TRUE);
	}
}

// secData zwischenspeichert die Systemfarben fuer den gesamten Zeichencode.
void SECToolBarManager::SysColorChange()
{
	secData.UpdateSysColors();
	m_drawData.SysColorChange();
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarManager - Anpassen-Modus

void SECToolBarManager::EnableConfigMode(BOOL bEnable)
{
	m_bConfig = bEnable;

	if (m_pFrameWnd == NULL)
		return;

	POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
	while (pos != NULL)
	{
		CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
		if (pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
			((SECCustomToolBar*)pBar)->EnableConfigMode(bEnable);
	}
}

BOOL SECToolBarManager::InConfigMode() const
{
	return m_bConfig;
}

// mainfrm.cpp:2987, 8667, 8678, 8726, 8742. Eudora fragt damit ab, ob es
// gerade in den Anpassen-Dialog geraten ist; dort sperrt der Verwalter das
// Hauptfenster, laesst es aber weiterhin auf Mausereignisse antworten, damit
// Knoepfe daraus gezogen werden koennen.
BOOL SECToolBarManager::IsMainFrameEnabled()
{
	return m_bMainFrameEnabled;
}

// QCToolbarCmdPage.cpp:117 ruft das, damit die Knoepfe der Leisten des
// Hauptfensters waehrend des Anpassens ziehbar bleiben.
void SECToolBarManager::EnableMainFrame()
{
	if (m_bMainFrameEnabled)
		return;

	// Die in DisableMainFrame gesperrten Fenster wieder freigeben.
	for (INT_PTR i = 0; i < m_enabledList.GetSize(); i++)
	{
		HWND hWnd = (HWND)(UINT_PTR)m_enabledList[i];
		if (::IsWindow(hWnd))
			::EnableWindow(hWnd, TRUE);
	}

	m_enabledList.RemoveAll();
	m_bMainFrameEnabled = TRUE;
}

void SECToolBarManager::DisableMainFrame()
{
	if (!m_bMainFrameEnabled || m_pFrameWnd == NULL)
		return;

	m_enabledList.RemoveAll();

	CWnd* pChild = m_pFrameWnd->GetWindow(GW_CHILD);
	while (pChild != NULL)
	{
		if (pChild->IsWindowEnabled() &&
			!pChild->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
		{
			m_enabledList.Add((DWORD)(DWORD_PTR)pChild->GetSafeHwnd());
			pChild->EnableWindow(FALSE);
		}

		pChild = pChild->GetWindow(GW_HWNDNEXT);
	}

	m_bMainFrameEnabled = FALSE;
}

void SECToolBarManager::SetInToolBarCommand(BOOL bIn, CRect& rect)
{
	m_bInToolBarCommand = bIn;
	m_btnRect = rect;
}

BOOL SECToolBarManager::IsToolBarCommand(CRect& rect) const
{
	if (!m_bInToolBarCommand)
		return FALSE;

	rect = m_btnRect;
	return TRUE;
}

// QCCustomizeToolBar.cpp:121 holt sich damit das Rechteck, in dem keine
// Knoepfe abgelegt werden duerfen - der Anpassen-Dialog selbst.
void SECToolBarManager::SetNoDropWnd(CWnd* pWnd)
{
	m_pNoDropWnd = pWnd;
}

void SECToolBarManager::GetNoDropRect(CRect& rect) const
{
	rect.SetRectEmpty();

	if (m_pNoDropWnd != NULL && m_pNoDropWnd->GetSafeHwnd() != NULL)
		m_pNoDropWnd->GetWindowRect(rect);
}

// QCCustomizeToolBar.cpp:89. rect ist ein Bildschirmrechteck.
SECCustomToolBar* SECToolBarManager::ToolBarUnderRect(const CRect& rect) const
{
	if (m_pFrameWnd == NULL)
		return NULL;

	POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
	while (pos != NULL)
	{
		CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
		if (!pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
			continue;

		if (!pBar->IsWindowVisible())
			continue;

		CRect rectBar;
		pBar->GetWindowRect(rectBar);

		CRect rectSchnitt;
		if (rectSchnitt.IntersectRect(rectBar, rect))
			return (SECCustomToolBar*)pBar;
	}

	return NULL;
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarManager - Meldungen

// Empfaengerliste fuer die Leistenmeldungen. QCToolbarCmdPage und die
// uebrigen Anpassen-Seiten tragen sich nicht selbst ein, sondern binden
// wmSECNotifyMsg in ihre Nachrichtentabelle und bekommen die Meldung, weil
// sie Elternfenster der Vorratsleisten sind. AddNotify ist der zweite Weg.
void SECToolBarManager::AddNotify(CWnd* pWnd)
{
	if (pWnd == NULL)
		return;

	for (INT_PTR i = 0; i < m_notifyWnds.GetSize(); i++)
	{
		if (m_notifyWnds[i] == (void*)pWnd)
			return;
	}

	m_notifyWnds.Add(pWnd);
}

void SECToolBarManager::RemoveNotify(CWnd* pWnd)
{
	for (INT_PTR i = m_notifyWnds.GetSize() - 1; i >= 0; i--)
	{
		if (m_notifyWnds[i] == (void*)pWnd)
			m_notifyWnds.RemoveAt(i);
	}
}

void SECToolBarManager::BarNotify(int nID,
								  SECCustomToolBar::BarNotifyCode notify)
{
	for (INT_PTR i = 0; i < m_notifyWnds.GetSize(); i++)
	{
		CWnd* pWnd = (CWnd*)m_notifyWnds[i];
		if (pWnd != NULL && pWnd->GetSafeHwnd() != NULL)
			pWnd->SendMessage(wmSECNotifyMsg, (WPARAM)nID, (LPARAM)notify);
	}

	// Zusaetzlich das Rahmenfenster - dort haengen die Anpassen-Seiten.
	if (m_pFrameWnd != NULL && m_pFrameWnd->GetSafeHwnd() != NULL)
		m_pFrameWnd->SendMessage(wmSECNotifyMsg, (WPARAM)nID, (LPARAM)notify);
}

void SECToolBarManager::InformBtns(UINT nID, UINT nCode, void* pData)
{
	if (m_pFrameWnd == NULL)
		return;

	POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
	while (pos != NULL)
	{
		CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
		if (pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
			((SECCustomToolBar*)pBar)->InformBtns(nID, nCode, pData, FALSE);
	}
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarManager - Vorgabeleisten

void SECToolBarManager::DefineDefaultToolBar(UINT nID, LPCTSTR lpszTitle,
											 UINT nBtnCount, UINT* lpBtnIDs,
											 DWORD dwAlignment,
											 UINT nDockBarID,
											 UINT nDockNextToID,
											 BOOL bDocked, BOOL bVisible)
{
	SECDefaultToolBar* pBar = new SECDefaultToolBar;

	pBar->nID            = nID;
	pBar->lpszTitle      = lpszTitle;
	pBar->nBtnCount      = nBtnCount;
	pBar->lpBtnIDs       = lpBtnIDs;
	pBar->dwAlignment    = dwAlignment;
	pBar->nDockBarID     = nDockBarID;
	pBar->nDockNextToID  = nDockNextToID;
	pBar->bDocked        = bDocked;
	pBar->bVisible       = bVisible;

	m_defaultBars.Add(pBar);
}

BOOL SECToolBarManager::GetDefaultBtns(UINT nID, int& nCount, UINT*& lpBtnIDs)
{
	for (INT_PTR i = 0; i < m_defaultBars.GetSize(); i++)
	{
		SECDefaultToolBar* pBar = (SECDefaultToolBar*)m_defaultBars[i];
		if (pBar->nID == nID)
		{
			nCount   = (int)pBar->nBtnCount;
			lpBtnIDs = pBar->lpBtnIDs;
			return TRUE;
		}
	}

	nCount   = 0;
	lpBtnIDs = NULL;
	return FALSE;
}

// GEBRAUCHT: QCToolBarManager.cpp:1168 ruft das, wenn beim Laden keine
// einzige Leiste gefunden wurde - also beim allerersten Start und nach dem
// Loeschen des INI-Abschnitts. Ohne diese Fassung staende Eudora dann ohne
// Werkzeugleiste da.
void SECToolBarManager::SetDefaultDockState()
{
	if (m_pFrameWnd == NULL)
		return;

	for (INT_PTR i = 0; i < m_defaultBars.GetSize(); i++)
	{
		SECDefaultToolBar* pDef = (SECDefaultToolBar*)m_defaultBars[i];

		CControlBar* pBar = m_pFrameWnd->GetControlBar(pDef->nID);
		if (pBar == NULL)
			continue;

		if (pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
		{
			SECCustomToolBar* pToolBar = (SECCustomToolBar*)pBar;
			pToolBar->SetButtons(pDef->lpBtnIDs, (int)pDef->nBtnCount);
			pToolBar->EnableDocking(pDef->dwAlignment);
		}

		if (pDef->bDocked)
			m_pFrameWnd->DockControlBar(pBar, pDef->nDockBarID);

		m_pFrameWnd->ShowControlBar(pBar, pDef->bVisible, TRUE);
	}

	m_pFrameWnd->RecalcLayout();
}

// tbarmgr.h:99, "QC Change: made this virtual". QCToolBarManager.cpp:1244
// ueberschreibt mit einer breiteren Signatur; diese Fassung bleibt fuer die
// Vererbungskette und fuer Aufrufer, die nur den Titel uebergeben.
SECCustomToolBar* SECToolBarManager::CreateUserToolBar(LPCTSTR lpszTitle)
{
	if (m_pFrameWnd == NULL || m_pToolBarClass == NULL)
		return NULL;

	// Freie Kennung suchen - genauso wie QCToolBarManager.cpp:1254-1275.
	int nID = SEC_IDW_FIRST_USER_TOOLBAR;
	BOOL bFound = TRUE;
	while (bFound)
	{
		bFound = FALSE;
		POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
		while (pos != NULL)
		{
			CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
			if (pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)) &&
				pBar->GetDlgCtrlID() == nID)
			{
				nID++;
				bFound = TRUE;
				break;
			}
		}
	}

	if (nID >= (AFX_IDW_TOOLBAR + 0x100))
		return NULL;		// zu viele Leisten

	SECCustomToolBar* pToolBar =
		(SECCustomToolBar*)m_pToolBarClass->CreateObject();
	if (pToolBar == NULL)
		return NULL;

	ASSERT_KINDOF(SECCustomToolBar, pToolBar);
	pToolBar->SetManager(this);

	TCHAR szBuffer[128];
	if (lpszTitle == NULL)
		wsprintf(szBuffer, _T("ToolBar%d"),
				 nID - SEC_IDW_FIRST_USER_TOOLBAR + 1);
	else
		lstrcpy(szBuffer, lpszTitle);

	DWORD dwStyle   = WS_VISIBLE | WS_CHILD | CBRS_SIZE_DYNAMIC | CBRS_TOP;
	DWORD dwExStyle = 0L;
	if (m_bFlyBy)
		dwStyle |= CBRS_FLYBY;
	if (m_bToolTips)
		dwStyle |= CBRS_TOOLTIPS;
	if (m_bCoolLook)
		dwExStyle |= (CBRS_EX_COOLBORDERS | CBRS_EX_GRIPPER);

	pToolBar->CreateEx(dwExStyle, m_pFrameWnd, dwStyle, nID, szBuffer);

	SetToolBarInfo(pToolBar);
	pToolBar->EnableConfigMode(m_bConfig);
	pToolBar->EnableDocking(CBRS_ALIGN_ANY);
	pToolBar->m_bAutoDelete = TRUE;

	return pToolBar;
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarManager - Zustand sichern und laden

// INI-Abschnitt und Schluessel wortgleich zu QCToolBarManager::QCLoadState
// (QCToolBarManager.cpp:1125-1128), das den Rumpf dieser Methode
// nachbildet - dort steht der Kommentar "Had to add this here", weil die
// Namen im Original privat waren. Damit sind die Namen belegt.
static const TCHAR szToolBarManagerSection[] = _T("%s-ToolBarManager");
static const TCHAR szToolBarTips[]           = _T("ToolTips");
static const TCHAR szToolBarCoolLook[]       = _T("CoolLook");
static const TCHAR szToolBarLargeButtons[]   = _T("LargeButtons");

// KATEGORIE C laut PLAN.md: Eudora ruft diese Fassung nie auf.
// QCToolBarManager::QCLoadState (QCToolBarManager.cpp:1119-1169) ist die
// Ersatzfassung, weil EnableLargeBtns nicht virtuell ist. Der Rumpf hier ist
// deshalb Zeile fuer Zeile das, was QCLoadState nachbildet - "Dummy statt
// Weglassen", und diesmal ein belegter Dummy.
void SECToolBarManager::LoadState(LPCTSTR lpszProfileName)
{
	CWinApp* pApp = AfxGetApp();
	ASSERT(pApp != NULL);
	if (pApp == NULL || m_pFrameWnd == NULL)
		return;

	TCHAR szSection[256];
	wsprintf(szSection, szToolBarManagerSection, lpszProfileName);

	EnableToolTips((BOOL)pApp->GetProfileInt(szSection, szToolBarTips,
											 m_bToolTips));
	EnableCoolLook((BOOL)pApp->GetProfileInt(szSection, szToolBarCoolLook,
											 m_bCoolLook));
	EnableLargeBtns((BOOL)pApp->GetProfileInt(szSection,
											  szToolBarLargeButtons,
											  m_bLargeBmp));

	int nToolbars = 0;
	POSITION pos = m_pFrameWnd->m_listControlBars.GetHeadPosition();
	while (pos != NULL)
	{
		CControlBar* pBar = (CControlBar*)m_pFrameWnd->m_listControlBars.GetNext(pos);
		if (pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
		{
			((SECCustomToolBar*)pBar)->SetManager(this);
			nToolbars++;
		}
	}

	if (nToolbars == 0)
		SetDefaultDockState();
}

// GEBRAUCHT: QCToolBarManager::SaveState (QCToolBarManager.cpp:1205) ruft
// diese Fassung ausdruecklich auf, bevor es seine eigenen Zusatzangaben
// schreibt.
void SECToolBarManager::SaveState(LPCTSTR lpszProfileName) const
{
	CWinApp* pApp = AfxGetApp();
	ASSERT(pApp != NULL);
	if (pApp == NULL)
		return;

	TCHAR szSection[256];
	wsprintf(szSection, szToolBarManagerSection, lpszProfileName);

	pApp->WriteProfileInt(szSection, szToolBarTips, m_bToolTips);
	pApp->WriteProfileInt(szSection, szToolBarCoolLook, m_bCoolLook);
	pApp->WriteProfileInt(szSection, szToolBarLargeButtons, m_bLargeBmp);
}

// Typkennung fuer das Wiederherstellen. QCToolBarManager.cpp:1341 wertet
// CBT_SECCUSTOMTOOLBAR aus.
DWORD SECToolBarManager::GetBarTypeID(CControlBar* pBar) const
{
	if (pBar != NULL && pBar->IsKindOf(RUNTIME_CLASS(SECCustomToolBar)))
		return CBT_SECCUSTOMTOOLBAR;

	return SECControlBarManager::GetBarTypeID(pBar);
}

SECControlBarInfoEx* SECToolBarManager::CreateControlBarInfoEx(
										SECControlBarInfo* pBarInfo) const
{
	if (pBarInfo != NULL && pBarInfo->m_dwBarTypeID == CBT_SECCUSTOMTOOLBAR)
		return new SECCustomToolBarInfoEx;

	return SECControlBarManager::CreateControlBarInfoEx(pBarInfo);
}

// QCToolBarManager::DynCreateControlBar (QCToolBarManager.cpp:1326)
// ueberschreibt das vollstaendig und ruft fuer alle uebrigen Typkennungen
// SECControlBarManager::DynCreateControlBar - also nicht diese Fassung.
// Sie bleibt fuer die Vererbungskette und fuer Leisten ohne QC-Verwalter.
CControlBar* SECToolBarManager::DynCreateControlBar(SECControlBarInfo* pBarInfo)
{
	if (pBarInfo == NULL || pBarInfo->m_dwBarTypeID != CBT_SECCUSTOMTOOLBAR)
		return SECControlBarManager::DynCreateControlBar(pBarInfo);

	ASSERT(m_pToolBarClass != NULL);
	SECCustomToolBar* pToolBar =
		(SECCustomToolBar*)m_pToolBarClass->CreateObject();
	if (pToolBar == NULL)
		return NULL;

	ASSERT_KINDOF(SECCustomToolBar, pToolBar);

	pToolBar->SetManager(this);
	pToolBar->m_bAutoDelete = TRUE;

	DWORD dwStyle   = WS_VISIBLE | WS_CHILD | CBRS_TOP | CBRS_SIZE_DYNAMIC;
	DWORD dwExStyle = 0L;
	if (m_bFlyBy)
		dwStyle |= CBRS_FLYBY;
	if (m_bToolTips)
		dwStyle |= CBRS_TOOLTIPS;
	if (m_bCoolLook)
		dwExStyle = (CBRS_EX_COOLBORDERS | CBRS_EX_GRIPPER);

	LPCTSTR lpszTitle = NULL;
	if (pBarInfo->m_pBarInfoEx != NULL &&
		pBarInfo->m_pBarInfoEx->IsKindOf(RUNTIME_CLASS(SECCustomToolBarInfoEx)))
	{
		lpszTitle =
			((SECCustomToolBarInfoEx*)pBarInfo->m_pBarInfoEx)->m_strBarName;
	}

	VERIFY(pToolBar->CreateEx(dwExStyle, m_pFrameWnd, dwStyle,
							  pBarInfo->m_nBarID, lpszTitle));

	SetToolBarInfo(pToolBar);
	pToolBar->EnableDocking(CBRS_ALIGN_ANY);

	return pToolBar;
}

// tbarmgr.h:109. Der Dialog "Werkzeugleisten anzeigen" steht in tbarsdlg.h
// (SECToolBarsDlg), und diese Datei ersetzt tbarsdlg.h NICHT - Eudora ruft
// ExecViewToolBarsDlg nirgends auf (geprueft: kein Treffer in Eudora/*.cpp).
// Statt eines halben Dialogs steht hier eine Meldung, damit ein spaeterer
// Aufruf nicht still nichts tut.
int SECToolBarManager::ExecViewToolBarsDlg()
{
	static BOOL bGemeldet = FALSE;
	OTShimWzlNichtUmgesetzt(bGemeldet,
		_T("Der Dialog zum Ein- und Ausblenden von Werkzeugleisten."));

	return IDCANCEL;
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 8 - der Anpassen-Dialog
//
// AUFTRAGSLAGE: "Der Anpassungsdialog fuer Werkzeugleisten darf ein Dummy
// bleiben." Was hier steht, ist deshalb bewusst knapp - aber es ist kein
// leerer Rumpf: Eudora leitet sechs eigene Seiten von SECToolBarCmdPage ab
// und erledigt das Anlegen der Vorratsleisten selbst
// (QCToolbarCmdPage.cpp:43-102). Gebraucht wird von hier nur der Feldsatz,
// die Verwaltung der Knopfgruppen und die Weitergabe der Meldungen.
//
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// SECToolBarSheet
//
// QCToolBarManager.cpp:1042 legt eine Instanz auf dem Stapel an, haengt
// Eudoras eigene Seiten ein und ruft DoModal.

BEGIN_MESSAGE_MAP(SECToolBarSheet, CPropertySheet)
	ON_MESSAGE(WM_FLOATSTATUS, &SECToolBarSheet::OnFloatStatus)
	ON_WM_ACTIVATE()
END_MESSAGE_MAP()

BOOL SECToolBarSheet::OnInitDialog()
{
	BOOL bResult = CPropertySheet::OnInitDialog();

	// Das Original hat hier vermutlich den Anpassen-Modus eingeschaltet.
	// Das tun in Eudora die Seiten selbst (QCToolbarCmdPage.cpp:114), damit
	// es beim Blaettern zwischen den Seiten stimmt.
	return bResult;
}

// WM_FLOATSTATUS (afxpriv.h) meldet einer Leiste, dass ihr Rahmenfenster
// schwebt oder wieder angedockt hat. Das Eigenschaftsblatt reicht die
// Meldung an seine Kindfenster weiter, damit die Vorratsleisten sie sehen.
LRESULT SECToolBarSheet::OnFloatStatus(WPARAM wParam, LPARAM lParam)
{
	CWnd* pChild = GetWindow(GW_CHILD);
	while (pChild != NULL)
	{
		pChild->SendMessage(WM_FLOATSTATUS, wParam, lParam);
		pChild = pChild->GetWindow(GW_HWNDNEXT);
	}

	return 0;
}

// Beim Verlassen des Dialogs darf das Hauptfenster nicht gesperrt bleiben.
void SECToolBarSheet::OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized)
{
	CPropertySheet::OnActivate(nState, pWndOther, bMinimized);
}


/////////////////////////////////////////////////////////////////////////////
// SECToolBarCmdPage

IMPLEMENT_DYNCREATE(SECToolBarCmdPage, CPropertyPage)

BEGIN_MESSAGE_MAP(SECToolBarCmdPage, CPropertyPage)
	ON_LBN_SELCHANGE(IDC_TOOLBAR_LIST, &SECToolBarCmdPage::OnSelChange)
	// Siehe die Anmerkung in der Kopfdatei: die Signaturen des Originals
	// passen in MFC 14 in keinen Tabelleneintrag mehr, deshalb stehen hier
	// typrichtige Umsetzer.
	ON_REGISTERED_MESSAGE(wmSECNotifyMsg, &SECToolBarCmdPage::OnBarNotifyMsg)
	ON_REGISTERED_MESSAGE(wmSECToolBarStyleChanging,
						  &SECToolBarCmdPage::OnToolBarStyleChangingMsg)
END_MESSAGE_MAP()

SECToolBarCmdPage::SECToolBarCmdPage()
	: CPropertyPage(SECToolBarCmdPage::IDD)
{
	Initialize();
}

SECToolBarCmdPage::SECToolBarCmdPage(UINT nIDTemplate, UINT nIDCaption)
	: CPropertyPage(nIDTemplate, nIDCaption)
{
	Initialize();
}

SECToolBarCmdPage::SECToolBarCmdPage(LPCTSTR lpszTemplate, UINT nIDCaption)
	: CPropertyPage(lpszTemplate, nIDCaption)
{
	Initialize();
}

void SECToolBarCmdPage::Initialize()
{
	m_pManager = NULL;
	m_nCurSel  = -1;
}

SECToolBarCmdPage::~SECToolBarCmdPage()
{
	for (INT_PTR i = 0; i < m_btnGroups.GetSize(); i++)
		delete (SECBtnGroup*)m_btnGroups[i];

	m_btnGroups.RemoveAll();
}

// Die Vorratsleiste einer Gruppe gehoert der Gruppe. QCToolbarCmdPage.cpp:64
// legt sie mit DEBUG_NEW an und traegt sie in pGroup->pToolBar ein, ohne sie
// je selbst freizugeben - also muss es hier geschehen.
SECToolBarCmdPage::SECBtnGroup::~SECBtnGroup()
{
	if (pToolBar != NULL)
	{
		if (pToolBar->GetSafeHwnd() != NULL)
			pToolBar->DestroyWindow();

		delete pToolBar;
		pToolBar = NULL;
	}
}

void SECToolBarCmdPage::SetManager(SECToolBarManager* pManager)
{
	m_pManager = pManager;
}

// QCCustomizeGeneralPage, QCCustomizePluginsPage und die uebrigen Seiten
// rufen das, bevor der Dialog aufgeht.
void SECToolBarCmdPage::DefineBtnGroup(LPCTSTR lpszTitle, int nBtnCount,
									   UINT* lpBtnIDs)
{
	SECBtnGroup* pGroup = new SECBtnGroup;

	pGroup->lpszTitle = lpszTitle;
	pGroup->nBtnCount = (UINT)nBtnCount;
	pGroup->lpBtnIDs  = lpBtnIDs;

	m_btnGroups.Add(pGroup);
}

SECCustomToolBar* SECToolBarCmdPage::GetControlBar(UINT nID)
{
	for (INT_PTR i = 0; i < m_btnGroups.GetSize(); i++)
	{
		SECBtnGroup* pGroup = (SECBtnGroup*)m_btnGroups[i];
		if (pGroup->pToolBar != NULL &&
			pGroup->pToolBar->GetSafeHwnd() != NULL &&
			(UINT)pGroup->pToolBar->GetDlgCtrlID() == nID)
			return pGroup->pToolBar;
	}

	return NULL;
}

// Die Erklaerung zum gewaehlten Knopf. Eudora reicht auf diese Fassung
// durch (QCCustomizePluginsPage.cpp:162), wenn es keine eigene Erklaerung
// hat.
//
// Der Text kommt aus der Befehlszeichenkette mit derselben Kennung: MFC legt
// dort "Zeile fuer die Statusleiste\nKurzhinweis" ab. Genommen wird der
// Teil vor dem Zeilenumbruch, weil das die ausfuehrliche Fassung ist.
void SECToolBarCmdPage::SetDescription(int nID)
{
	CWnd* pDesc = GetDlgItem(IDC_TOOLBAR_DESCRIPTION);
	if (pDesc == NULL)
		return;

	CString strText;
	if (nID > 0 && strText.LoadString((UINT)nID))
	{
		int nPos = strText.Find(_T('\n'));
		if (nPos >= 0)
			strText = strText.Left(nPos);
	}
	else
	{
		strText.Empty();
	}

	pDesc->SetWindowText(strText);
}

BOOL SECToolBarCmdPage::OnInitDialog()
{
	// VEREINFACHT: das Original legt hier die Vorratsleisten aller
	// Knopfgruppen an. Eudora tut das durchweg selbst, weil es eigene
	// Dialogvorlagen benutzt - QCToolbarCmdPage::OnInitDialog
	// (QCToolbarCmdPage.cpp:43) ruft nicht einmal diese Fassung auf, sondern
	// unmittelbar CPropertyPage::OnInitDialog. Dasselbe gilt fuer die
	// fuenf uebrigen Seiten. Damit ist diese Fassung in Eudora unerreichbar;
	// sie bleibt fuer die Vererbungskette.
	BOOL bResult = CPropertyPage::OnInitDialog();

	// Die Gruppenliste fuellen, falls die Vorlage sie hat.
	CListBox* pList = (CListBox*)GetDlgItem(IDC_TOOLBAR_LIST);
	if (pList != NULL)
	{
		for (INT_PTR i = 0; i < m_btnGroups.GetSize(); i++)
		{
			SECBtnGroup* pGroup = (SECBtnGroup*)m_btnGroups[i];
			if (pGroup->lpszTitle != NULL)
				pList->AddString(pGroup->lpszTitle);
		}

		if (m_btnGroups.GetSize() > 0)
		{
			pList->SetCurSel(0);
			m_nCurSel = 0;
		}
	}

	return bResult;
}

void SECToolBarCmdPage::OnSelChange()
{
	CListBox* pList = (CListBox*)GetDlgItem(IDC_TOOLBAR_LIST);
	if (pList == NULL)
		return;

	int nIndex = pList->GetCurSel();
	if (nIndex == LB_ERR || nIndex == m_nCurSel)
		return;

	// Die bisher sichtbare Vorratsleiste verbergen, die neue zeigen.
	if (m_nCurSel >= 0 && m_nCurSel < m_btnGroups.GetSize())
	{
		SECBtnGroup* pOld = (SECBtnGroup*)m_btnGroups[m_nCurSel];
		if (pOld->pToolBar != NULL && pOld->pToolBar->GetSafeHwnd() != NULL)
			pOld->pToolBar->ShowWindow(SW_HIDE);
	}

	m_nCurSel = nIndex;

	if (m_nCurSel >= 0 && m_nCurSel < m_btnGroups.GetSize())
	{
		SECBtnGroup* pNew = (SECBtnGroup*)m_btnGroups[m_nCurSel];
		if (pNew->pToolBar != NULL && pNew->pToolBar->GetSafeHwnd() != NULL)
		{
			pNew->pToolBar->ShowWindow(SW_SHOWNA);
			pNew->pToolBar->EnableConfigMode(TRUE);
		}
	}

	SetDescription(0);
}

// Eine Vorratsleiste meldet ein Ereignis. QCCustomizeSignaturesPage.cpp:220
// und QCCustomizeStationeryPage.cpp:219 reichen auf diese Fassung durch,
// nachdem sie BarDesChange selbst beantwortet haben.
LONG SECToolBarCmdPage::OnBarNotify(UINT nID, LONG lParam)
{
	if (m_pManager == NULL)
		return 0L;

	SECCustomToolBar* pBar = GetControlBar(nID);
	if (pBar == NULL)
		return 0L;

	switch (lParam)
	{
	case SECCustomToolBar::BarDesChange:
		{
			// Der gewaehlte Knopf hat gewechselt - die Erklaerung nachziehen.
			int nBtn = pBar->GetCurBtn();
			SetDescription(nBtn >= 0 ? (int)pBar->GetItemID(nBtn) : 0);
		}
		break;

	default:
		break;
	}

	return 0L;
}

// wmSECToolBarStyleChanging (tbarsdlg.h:229) meldet, dass sich der Stil
// einer Leiste aendert - etwa beim Umschalten auf grosse Knoepfe. Fuer die
// Vorratsleisten dieser Seite ist nichts zu tun; sie holen sich ihre
// Bitmapangaben in OnSetActive ohnehin neu (QCToolbarCmdPage.cpp:123-131).
LONG SECToolBarCmdPage::OnToolBarStyleChanging(UINT /*nEvent*/, LONG /*lParam*/)
{
	return 0L;
}

LRESULT SECToolBarCmdPage::OnBarNotifyMsg(WPARAM wParam, LPARAM lParam)
{
	return (LRESULT)OnBarNotify((UINT)wParam, (LONG)lParam);
}

LRESULT SECToolBarCmdPage::OnToolBarStyleChangingMsg(WPARAM wParam,
													 LPARAM lParam)
{
	return (LRESULT)OnToolBarStyleChanging((UINT)wParam, (LONG)lParam);
}

// QCToolBarCmdPage::OnSetActive (QCToolbarCmdPage.cpp:105) ueberschreibt das
// vollstaendig und ruft diese Fassung NICHT auf; sie bleibt fuer die
// uebrigen Seiten und fuer die Vererbungskette.
BOOL SECToolBarCmdPage::OnSetActive()
{
	if (m_pManager != NULL)
	{
		m_pManager->EnableConfigMode(TRUE);
		m_pManager->EnableMainFrame();
		m_pManager->SetNoDropWnd(GetParent());
	}

	return CPropertyPage::OnSetActive();
}

BOOL SECToolBarCmdPage::OnKillActive()
{
	if (m_pManager != NULL)
		m_pManager->SetNoDropWnd(NULL);

	return CPropertyPage::OnKillActive();
}

// Setzt die Leisten auf ihre Vorgabeknoepfe zurueck.
void SECToolBarCmdPage::OnReset()
{
	CPropertyPage::OnReset();

	if (m_pManager != NULL)
		m_pManager->EnableConfigMode(FALSE);
}


/////////////////////////////////////////////////////////////////////////////
// SECCustomizeToolBar
//
// Die Vorratsleiste im Anpassen-Dialog. Sie gibt Knoepfe ab, nimmt aber
// keine an - das ist der ganze Unterschied zur gewoehnlichen Leiste
// (tbarpage.h:157-159).

IMPLEMENT_DYNAMIC(SECCustomizeToolBar, SECCustomToolBar)

SECCustomizeToolBar::SECCustomizeToolBar()
{
	// Eine Vorratsleiste ist immer im Anpassen-Modus.
	m_bConfig = TRUE;
}

// tbarpage.h:158: "Returns TRUE if the default drag mode is add." Aus der
// Vorratsleiste wird HINZUGEFUEGT, nicht verschoben - deshalb TRUE.
BOOL SECCustomizeToolBar::GetDragMode() const
{
	return TRUE;
}

// Eine Vorratsleiste nimmt keine abgelegten Knoepfe an.
BOOL SECCustomizeToolBar::AcceptDrop() const
{
	return FALSE;
}

// Im Original wird hier so umgebrochen, dass das Vorratsfeld moeglichst
// gleichmaessig gefuellt ist. Diese Stufe bricht ohne Ausgleich um (siehe
// SECCustomToolBar::SizeToolBar); der Rumpf bleibt leer und ist damit
// wirkungsgleich mit dem geerbten.
void SECCustomizeToolBar::BalanceWrap(int /*nRow*/, Wrapped* /*pWrap*/)
{
}

// QCToolbarCmdPage.cpp:95 ruft das, nachdem die Leiste auf die Groesse des
// Rahmens im Dialog gesetzt wurde: die Knoepfe sollen genau in dieses
// Rechteck umgebrochen werden.
void SECCustomizeToolBar::DoSize(CRect& rect)
{
	CSize size = SizeToolBar(rect.Width(), FALSE);

	SetWindowPos(NULL, rect.left, rect.top,
				 max(size.cx, rect.Width()), max(size.cy, rect.Height()),
				 SWP_NOZORDER | SWP_NOACTIVATE);

	Invalidate();
}


/////////////////////////////////////////////////////////////////////////////
// SECConvertDialogUnitsToPixels  (tbarpage.h:163)
//
// QCToolbarCmdPage.cpp:56 rechnet damit 6 und 8 Dialogeinheiten in
// Bildpunkte um, um einen Rahmen einzuruecken.
//
// Die Umrechnung ist die von Windows festgelegte: waagerecht vier
// Dialogeinheiten je mittlerer Zeichenbreite, senkrecht acht je Zeilenhoehe.

void SECConvertDialogUnitsToPixels(HFONT hFont, int& cx, int& cy)
{
	CDC dc;
	if (!dc.CreateCompatibleDC(NULL))
		return;

	HGDIOBJ hOldFont = NULL;
	if (hFont != NULL)
		hOldFont = ::SelectObject(dc.GetSafeHdc(), hFont);

	TEXTMETRIC tm;
	if (dc.GetTextMetrics(&tm))
	{
		cx = ::MulDiv(cx, tm.tmAveCharWidth, 4);
		cy = ::MulDiv(cy, tm.tmHeight, 8);
	}

	if (hOldFont != NULL)
		::SelectObject(dc.GetSafeHdc(), hOldFont);
}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//
// TEIL 9 - SECToolBarRectTracker  (Original: tbartrck.h:36)
//
// Der Rahmen, der beim Ziehen eines Knopfes mitwandert.
// QCCustomizeToolBar.cpp:71 legt eine Instanz auf dem Stapel an und ruft
// Track. Da das Ziehen von Knoepfen in dieser Stufe nicht umgesetzt ist
// (SECCustomToolBar::DragButton meldet sich und gibt FALSE zurueck), laeuft
// hier nichts an; die Klasse muss aber uebersetzen und binden.
//
/////////////////////////////////////////////////////////////////////////////

SECToolBarRectTracker::SECToolBarRectTracker()
	: CRectTracker()
{
}

// Gestrichelter Rahmen ohne Anfasser - so sieht das Ziehen eines Knopfes im
// Anpassen-Modus aus.
SECToolBarRectTracker::SECToolBarRectTracker(LPCRECT lpSrcRect)
	: CRectTracker(lpSrcRect, CRectTracker::dottedLine)
{
}

BOOL SECToolBarRectTracker::Track(CWnd* pWnd, CPoint point)
{
	return TrackHandle(pWnd, point);
}

// Ziehen nur waagerecht - dafuer wird die senkrechte Ausdehnung nach dem
// Ziehen wieder auf den Ausgangswert gesetzt.
BOOL SECToolBarRectTracker::HorzDrag(CWnd* pWnd, CPoint point)
{
	int nTop    = m_rect.top;
	int nBottom = m_rect.bottom;

	BOOL bRes = TrackHandle(pWnd, point);

	m_rect.top    = nTop;
	m_rect.bottom = nBottom;

	return bRes;
}

BOOL SECToolBarRectTracker::TrackHandle(CWnd* pWnd, CPoint point)
{
	// CRectTracker::Track uebernimmt das Einfangen der Maus und das
	// Nachziehen des Rahmens bis zum Loslassen.
	return CRectTracker::Track(pWnd, point, FALSE, NULL);
}

void SECToolBarRectTracker::DrawTrackerRect(LPCRECT lpRect, CWnd* pWndClipTo,
											CDC* pDC, CWnd* pWnd)
{
	CRectTracker::DrawTrackerRect(lpRect, pWndClipTo, pDC, pWnd);
}
