// OTShim_Knopf.cpp - Ersatzumsetzung fuer SECOwnerDrawButton und
//                    SECBitmapButton aus OT501/Include/secbtns.h
//
// SONDERFALL IN DIESER ERSATZSCHICHT: hier wird der Stingray-Header NICHT
// ersetzt. secbtns.h bleibt im Original eingebunden, diese Datei liefert nur
// die fehlenden Ruempfe. Der Grund steht in OTShimAll.h: den Waechter
// __SECBTNS_H__ zu setzen ergibt gemessen 102 Uebersetzungsfehler, weil
// secbtns.h neben den Knopfklassen auch SECLoadSysColorBitmap deklariert und
// von secall.h an mehreren Stellen vorausgesetzt wird. Die Klassenerklaerungen
// bleiben also woertlich die von Stingray; nur der Code dahinter ist neu.
//
// WAS FEHLTE, gemessen am Link von Eudora.exe (Debug/x86, Commit 4ba2dd3):
//
//   ??0SECBitmapButton@@QAE@XZ   SECBitmapButton::SECBitmapButton()
//   ??1SECBitmapButton@@UAE@XZ   SECBitmapButton::~SECBitmapButton()
//
// Es sind nur zwei Symbole, aber mit ihnen kommt die virtuelle Tabelle beider
// Klassen - und die verlangt jede virtuelle Methode von SECOwnerDrawButton und
// SECBitmapButton. Deshalb steht hier die ganze Familie. SECWellButton,
// SECMenuButton, SECPopupColorWell und DDX_Color bleiben aus: Eudora benutzt
// sie nirgends (gemessen ueber alle .cpp und .h unter Eudora71/Eudora), und
// ohne Aufruf verlangt der Linker sie nicht.
//
// ALLE FUENF AUFRUFSTELLEN IN EUDORA sehen gleich aus:
//
//   nickpage.cpp:877                m_Swap.AttachButton(IDC_SWAPNAMES,
//                                       SECBitmapButton::Al_Center, IDB_SWAP, this)
//   PaymentAndRegistrationDlg.cpp:223-226  viermal dasselbe Muster mit
//                                       Al_Center und einer Bitmap-Ressource
//
// Es gibt also keinen Aufruf mit Beschriftung und keinen mit einer anderen
// Ausrichtung als Al_Center. Al_Center ist entsprechend die Ausrichtung, die
// hier vollstaendig ausgearbeitet ist; die vier anderen sind umgesetzt, aber
// UNGEPRUEFT - es gibt in Eudora keine Stelle, an der sie sichtbar wuerden.
//
// UNGEPRUEFT insgesamt: wie das Original aussah, ist nicht belegbar. Es gibt
// weder eine Implementierung noch ein Bild davon. Diese Fassung zeichnet einen
// gewoehnlichen Windows-Druckknopfrahmen (DrawFrameControl) und die Bitmap
// darauf. Das entspricht dem, was ein Anwender an dieser Stelle erwartet.
//
// UEBERSETZUNG: bindet <afxwin.h> selbst ein, benutzt Eudoras vorkompilierten
// Kopf nicht - in Eudora.vcxproj mit PrecompiledHeader "NotUsing".
//
// Kodierung: reines ASCII, kein BOM. Zeilenenden CRLF.

#ifdef WINVER
#undef WINVER
#endif
#define WINVER 0x0501
#ifdef _WIN32_WINNT
#undef _WIN32_WINNT
#endif
#define _WIN32_WINNT 0x0501

#include <afxwin.h>
#include <afxext.h>

#include "secbtns.h"


/////////////////////////////////////////////////////////////////////////////
// Hilfe fuer diese Uebersetzungseinheit
//
// Sie ist eine freie Funktion und keine Methode: secbtns.h bleibt woertlich
// der Header von Stingray, dort laesst sich nichts nachtragen.
//
// Inhaltlich dasselbe wie SECLoadSysColorBitmap (OTShim.h:306) - die Bitmap
// wird geladen und ihre Graustufen gegen die aktuellen Systemfarben getauscht.
// Hier steht es noch einmal, weil OTShim.h die gesamte Stufe 0-2 mitbringen
// wuerde und diese Datei davon nichts braucht.

static BOOL LadeBitmapInSystemfarben(CBitmap& bmp, LPCTSTR lpszName)
{
	if (lpszName == NULL)
		return FALSE;

	// Beide Aufrufwege in Eudora benutzen MAKEINTRESOURCE, also eine als
	// Zeiger verpackte Zahl. LoadMappedBitmap nimmt nur eine UINT-Nummer.
	if (!IS_INTRESOURCE(lpszName))
	{
		ASSERT(FALSE);
		return FALSE;
	}

	// LoadMappedBitmap ruft intern Attach, und Attach assertiert auf einem
	// bereits belegten CBitmap. Beim Neuladen nach WM_SYSCOLORCHANGE ist es
	// belegt.
	if (bmp.GetSafeHandle() != NULL)
		bmp.DeleteObject();

	return bmp.LoadMappedBitmap((UINT)(UINT_PTR) lpszName);
}


/////////////////////////////////////////////////////////////////////////////
// SECOwnerDrawButton
//
// Der Rahmen der Familie. Er macht drei Dinge: einen vorhandenen Dialogknopf
// auf Selbstzeichnen umstellen, den Knopfrahmen zeichnen und das Zeichnen des
// Inhalts an die abgeleitete Klasse weiterreichen (DrawSpecific ist rein
// virtuell, secbtns.h:78).

IMPLEMENT_DYNAMIC(SECOwnerDrawButton, CButton)

BEGIN_MESSAGE_MAP(SECOwnerDrawButton, CButton)
	ON_WM_SYSCOLORCHANGE()
	ON_WM_KEYUP()
	ON_WM_LBUTTONUP()
END_MESSAGE_MAP()


SECOwnerDrawButton::SECOwnerDrawButton()
{
	// m_bWin4 ist das einzige Datenfeld der Klasse (secbtns.h:83). Im Original
	// unterschied es Windows 3.x von Windows 95 und bestimmte, ob der Rahmen
	// von Hand oder ueber DrawFrameControl gezeichnet wird. Auf dem Zielsystem
	// ist die Antwort immer TRUE.
	m_bWin4 = TRUE;
}


SECOwnerDrawButton::~SECOwnerDrawButton()
{
}


// Haengt sich an einen bereits vorhandenen Dialogknopf und schaltet ihn auf
// Selbstzeichnen um. Der Aufruf gehoert in OnInitDialog, wenn die Steuerelemente
// des Dialogs stehen.
BOOL SECOwnerDrawButton::AttachButton(int nCtlID, CWnd* pParentWnd)
{
	if (pParentWnd == NULL)
		return FALSE;

	if (GetSafeHwnd() != NULL)
	{
		// Zweimal anhaengen ist ein Fehler des Aufrufers, kein Grund
		// abzustuerzen.
		ASSERT(FALSE);
		return FALSE;
	}

	if (!SubclassDlgItem(nCtlID, pParentWnd))
		return FALSE;

	// Ohne BS_OWNERDRAW schickt Windows kein WM_DRAWITEM, und DrawItem liefe
	// nie an. Die Ressourcen von Eudora setzen das Bit nicht, deshalb hier.
	ModifyStyle(BS_TYPEMASK, BS_OWNERDRAW, SWP_FRAMECHANGED);

	return TRUE;
}


// Legt einen neuen Knopf an. In Eudora nicht aufgerufen (gemessen), aber
// deklariert - deshalb mit Rumpf statt fehlend.
BOOL SECOwnerDrawButton::Create(LPCTSTR lpszCaption, DWORD dwStyle,
								const RECT& rect, CWnd* pParentWnd, int nID)
{
	return CButton::Create(lpszCaption, dwStyle | BS_OWNERDRAW, rect,
						   pParentWnd, nID);
}


#ifdef _DEBUG
void SECOwnerDrawButton::Dump(CDumpContext& dc) const
{
	CButton::Dump(dc);
}


void SECOwnerDrawButton::AssertValid() const
{
	CButton::AssertValid();
}
#endif // _DEBUG


// Der Ablauf des Selbstzeichnens: Rahmen, Inhalt, Fokusrechteck. Die beiden
// mittleren Schritte sind rein virtuell und kommen aus der abgeleiteten Klasse.
void SECOwnerDrawButton::DrawItem(LPDRAWITEMSTRUCT lpDS)
{
	if (lpDS == NULL || lpDS->hDC == NULL)
		return;

	CDC* pDC = CDC::FromHandle(lpDS->hDC);
	if (pDC == NULL)
		return;

	// PreDrawButton/PostDrawButton umklammern im Original das Zeichnen in
	// einen Zwischenpuffer. Hier wird direkt gezeichnet; die beiden Haken
	// bleiben trotzdem erhalten, damit abgeleitete Klassen sie benutzen
	// koennen. In Eudora tut das keine.
	PreDrawButton(pDC, pDC);

	CRect rectInnen = DrawButton(pDC, lpDS);

	DrawSpecific(pDC, lpDS, rectInnen);

	if ((lpDS->itemState & ODS_FOCUS) != 0)
		DrawFocus(pDC, lpDS);

	PostDrawButton(pDC, pDC);
}


void SECOwnerDrawButton::PreDrawButton(CDC* /*pScreenDC*/, CDC* /*pMemDC*/)
{
}


void SECOwnerDrawButton::PostDrawButton(CDC* /*pScreenDC*/, CDC* /*pMemDC*/)
{
}


// Zeichnet den Knopfrahmen und liefert das Rechteck zurueck, in das der Inhalt
// gehoert - also den Rahmen abzueglich der Kantenbreite.
CRect SECOwnerDrawButton::DrawButton(CDC* pDC, LPDRAWITEMSTRUCT lpDS)
{
	CRect rect(lpDS->rcItem);

	UINT nZustand = DFCS_BUTTONPUSH;
	if ((lpDS->itemState & ODS_SELECTED) != 0)
		nZustand |= DFCS_PUSHED;
	if ((lpDS->itemState & ODS_DISABLED) != 0)
		nZustand |= DFCS_INACTIVE;

	pDC->DrawFrameControl(&rect, DFC_BUTTON, nZustand);

	rect.DeflateRect(::GetSystemMetrics(SM_CXEDGE) + 1,
					 ::GetSystemMetrics(SM_CYEDGE) + 1);

	return rect;
}


// Graut eine Flaeche aus. Wird von dieser Fassung nicht gebraucht - der
// ausgegraute Zustand entsteht in DrawSpecific ueber DrawState mit
// DSS_DISABLED, was mit den Systemfarben arbeitet und besser aussieht als ein
// Raster darueber. Der Haken bleibt, weil secbtns.h:74 ihn deklariert.
void SECOwnerDrawButton::DrawDisabled(CDC* /*pDC*/, int /*nWidth*/, int /*nHeight*/)
{
}


// Die Fassung mit DRAWITEMSTRUCT bestimmt nur das Rechteck und gibt an die
// rein virtuelle Fassung weiter (secbtns.h:75,76).
void SECOwnerDrawButton::DrawFocus(CDC* pDC, LPDRAWITEMSTRUCT lpDS)
{
	CRect rect(lpDS->rcItem);
	rect.DeflateRect(::GetSystemMetrics(SM_CXEDGE) + 2,
					 ::GetSystemMetrics(SM_CYEDGE) + 2);
	DrawFocus(pDC, rect);
}


void SECOwnerDrawButton::OnSysColorChange()
{
	CButton::OnSysColorChange();
	if (GetSafeHwnd() != NULL)
		Invalidate();
}


void SECOwnerDrawButton::OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	CButton::OnKeyUp(nChar, nRepCnt, nFlags);

	if (nChar == VK_SPACE || nChar == VK_RETURN)
		OnBnClicked();
}


void SECOwnerDrawButton::OnLButtonUp(UINT nFlags, CPoint point)
{
	CButton::OnLButtonUp(nFlags, point);

	CRect rect;
	GetClientRect(&rect);
	if (rect.PtInRect(point))
		OnBnClicked();
}


/////////////////////////////////////////////////////////////////////////////
// SECBitmapButton

IMPLEMENT_DYNAMIC(SECBitmapButton, SECOwnerDrawButton)

BEGIN_MESSAGE_MAP(SECBitmapButton, SECOwnerDrawButton)
	ON_WM_SYSCOLORCHANGE()
	ON_WM_SIZE()
END_MESSAGE_MAP()


SECBitmapButton::SECBitmapButton()
{
	m_lpszBmpName = NULL;
	m_indents = CSize(2, 2);
	m_alignment = Al_Center;
	m_bmpRect.SetRectEmpty();
	m_textRect.SetRectEmpty();
}


SECBitmapButton::~SECBitmapButton()
{
	// m_bmp ist ein CBitmap als Wertfeld; sein Destruktor gibt das Handle
	// selbst frei. m_lpszBmpName zeigt entweder auf MAKEINTRESOURCE - also
	// auf keinen Speicher - oder auf eine Zeichenkette des Aufrufers. In
	// beiden Faellen gehoert sie dieser Klasse nicht.
}


// Die in Eudora benutzte Fassung: vorhandener Dialogknopf, Bitmap als
// Ressourcennummer.
BOOL SECBitmapButton::AttachButton(int nCtlID, Alignment alignment, int nIDBmp,
								   CWnd* pParentWnd)
{
	return AttachButton(nCtlID, alignment, MAKEINTRESOURCE(nIDBmp), pParentWnd);
}


BOOL SECBitmapButton::AttachButton(int nCtlID, Alignment alignment,
								   LPCTSTR lpszBmpName, CWnd* pParentWnd)
{
	m_alignment = alignment;
	m_lpszBmpName = lpszBmpName;

	if (!SECOwnerDrawButton::AttachButton(nCtlID, pParentWnd))
		return FALSE;

	if (!LadeBitmapInSystemfarben(m_bmp, m_lpszBmpName))
		return FALSE;

	CalcLayout();
	Invalidate();

	return TRUE;
}


BOOL SECBitmapButton::Create(LPCTSTR lpszCaption, DWORD dwStyle,
							 Alignment alignment, LPCTSTR lpszBmpName,
							 const CRect& rect, CWnd* pParentWnd, int nID)
{
	m_alignment = alignment;
	m_lpszBmpName = lpszBmpName;

	if (!SECOwnerDrawButton::Create(lpszCaption, dwStyle, rect, pParentWnd, nID))
		return FALSE;

	if (!LadeBitmapInSystemfarben(m_bmp, m_lpszBmpName))
		return FALSE;

	CalcLayout();

	return TRUE;
}


BOOL SECBitmapButton::Create(LPCTSTR lpszCaption, DWORD dwStyle,
							 Alignment alignment, int nIDBmp,
							 const CRect& rect, CWnd* pParentWnd, int nID)
{
	return Create(lpszCaption, dwStyle, alignment, MAKEINTRESOURCE(nIDBmp),
				  rect, pParentWnd, nID);
}


void SECBitmapButton::SetIndents(CSize sz)
{
	m_indents = sz;
	if (GetSafeHwnd() != NULL)
	{
		CalcLayout();
		Invalidate();
	}
}


CSize SECBitmapButton::GetIndents() const
{
	return m_indents;
}


// Zieht den Knopf auf die Groesse seines Inhalts zusammen. In Eudora nicht
// aufgerufen (gemessen), aber deklariert (secbtns.h:225).
void SECBitmapButton::SizeToContent()
{
	if (GetSafeHwnd() == NULL)
		return;

	CalcLayout();

	CRect rectInhalt = m_bmpRect;
	if (!m_textRect.IsRectEmpty())
		rectInhalt.UnionRect(&rectInhalt, &m_textRect);

	int cxRand = 2 * (::GetSystemMetrics(SM_CXEDGE) + 1 + m_indents.cx);
	int cyRand = 2 * (::GetSystemMetrics(SM_CYEDGE) + 1 + m_indents.cy);

	SetWindowPos(NULL, 0, 0,
				 rectInhalt.Width() + cxRand,
				 rectInhalt.Height() + cyRand,
				 SWP_NOMOVE | SWP_NOZORDER | SWP_NOACTIVATE);
}


// Berechnet m_bmpRect und m_textRect. Beide sind laut secbtns.h:252-253 an
// (0,0) ausgerichtet; DrawSpecific verschiebt sie in das Innenrechteck des
// Knopfes.
void SECBitmapButton::CalcLayout()
{
	m_bmpRect.SetRectEmpty();
	m_textRect.SetRectEmpty();

	CSize sizeBmp(0, 0);
	if (m_bmp.GetSafeHandle() != NULL)
	{
		BITMAP bm;
		::ZeroMemory(&bm, sizeof(bm));
		m_bmp.GetBitmap(&bm);
		sizeBmp.cx = bm.bmWidth;
		sizeBmp.cy = bm.bmHeight;
	}

	CString strText;
	if (GetSafeHwnd() != NULL)
		GetWindowText(strText);

	CSize sizeText(0, 0);
	if (!strText.IsEmpty() && m_alignment != Al_Center && GetSafeHwnd() != NULL)
	{
		CClientDC dc(this);
		CFont* pAlt = dc.SelectObject(GetFont());
		sizeText = dc.GetTextExtent(strText);
		dc.SelectObject(pAlt);
	}

	switch (m_alignment)
	{
	case Al_Left:
		m_bmpRect  = CRect(CPoint(0, 0), sizeBmp);
		m_textRect = CRect(CPoint(sizeBmp.cx + m_indents.cx, 0), sizeText);
		break;

	case Al_Right:
		m_textRect = CRect(CPoint(0, 0), sizeText);
		m_bmpRect  = CRect(CPoint(sizeText.cx + m_indents.cx, 0), sizeBmp);
		break;

	case Al_Top:
		m_bmpRect  = CRect(CPoint(0, 0), sizeBmp);
		m_textRect = CRect(CPoint(0, sizeBmp.cy + m_indents.cy), sizeText);
		break;

	case Al_Bottom:
		m_textRect = CRect(CPoint(0, 0), sizeText);
		m_bmpRect  = CRect(CPoint(0, sizeText.cy + m_indents.cy), sizeBmp);
		break;

	case Al_Center:
	default:
		// Bitmap mittig, keine Beschriftung (secbtns.h:198).
		m_bmpRect = CRect(CPoint(0, 0), sizeBmp);
		break;
	}
}


#ifdef _DEBUG
void SECBitmapButton::Dump(CDumpContext& dc) const
{
	SECOwnerDrawButton::Dump(dc);
}


void SECBitmapButton::AssertValid() const
{
	SECOwnerDrawButton::AssertValid();
}
#endif // _DEBUG


// Zeichnet Bitmap und - ausser bei Al_Center - die Beschriftung in das vom
// Rahmen freigelassene Rechteck.
void SECBitmapButton::DrawSpecific(CDC* pDC, LPDRAWITEMSTRUCT lpDS, CRect& rect)
{
	if (m_bmp.GetSafeHandle() == NULL)
		return;

	// Der gesamte Inhalt wird als Block mittig in rect gesetzt.
	CRect rectInhalt = m_bmpRect;
	if (!m_textRect.IsRectEmpty())
		rectInhalt.UnionRect(&rectInhalt, &m_textRect);

	CPoint ptVersatz(
		rect.left + (rect.Width()  - rectInhalt.Width())  / 2,
		rect.top  + (rect.Height() - rectInhalt.Height()) / 2);

	// Ein gedrueckter Knopf verschiebt seinen Inhalt um ein Pixel - so macht
	// es Windows bei gewoehnlichen Knoepfen auch.
	if ((lpDS->itemState & ODS_SELECTED) != 0)
		ptVersatz.Offset(1, 1);

	CRect rectBmp = m_bmpRect;
	rectBmp.OffsetRect(ptVersatz);

	BOOL bAus = ((lpDS->itemState & ODS_DISABLED) != 0);

	if (bAus)
	{
		// DSS_DISABLED zeichnet die Bitmap in den Systemfarben fuer
		// abgeschaltete Bedienelemente - dasselbe, was Windows mit der
		// Beschriftung eines abgeschalteten Knopfes tut.
		::DrawState(pDC->GetSafeHdc(), NULL, NULL,
					(LPARAM)(HBITMAP) m_bmp.GetSafeHandle(), 0,
					rectBmp.left, rectBmp.top,
					rectBmp.Width(), rectBmp.Height(),
					DST_BITMAP | DSS_DISABLED);
	}
	else
	{
		CDC dcSpeicher;
		if (dcSpeicher.CreateCompatibleDC(pDC))
		{
			CBitmap* pAlt = dcSpeicher.SelectObject(&m_bmp);
			pDC->BitBlt(rectBmp.left, rectBmp.top,
						rectBmp.Width(), rectBmp.Height(),
						&dcSpeicher, 0, 0, SRCCOPY);
			dcSpeicher.SelectObject(pAlt);
		}
	}

	if (m_alignment != Al_Center && !m_textRect.IsRectEmpty())
	{
		CString strText;
		GetWindowText(strText);
		if (!strText.IsEmpty())
		{
			CRect rectText = m_textRect;
			rectText.OffsetRect(ptVersatz);

			int nAltModus = pDC->SetBkMode(TRANSPARENT);
			COLORREF crAlt = pDC->SetTextColor(
				::GetSysColor(bAus ? COLOR_GRAYTEXT : COLOR_BTNTEXT));
			CFont* pAltFont = pDC->SelectObject(GetFont());

			pDC->DrawText(strText, &rectText,
						  DT_CENTER | DT_VCENTER | DT_SINGLELINE);

			pDC->SelectObject(pAltFont);
			pDC->SetTextColor(crAlt);
			pDC->SetBkMode(nAltModus);
		}
	}
}


void SECBitmapButton::DrawFocus(CDC* pDC, CRect& rect)
{
	pDC->DrawFocusRect(&rect);
}


void SECBitmapButton::OnSysColorChange()
{
	SECOwnerDrawButton::OnSysColorChange();

	// Die Bitmap ist an die Systemfarben angepasst geladen worden und muss
	// deshalb neu geladen werden. AdView.cpp:355 macht dasselbe von Hand.
	if (m_lpszBmpName != NULL)
	{
		LadeBitmapInSystemfarben(m_bmp, m_lpszBmpName);
		CalcLayout();
		Invalidate();
	}
}


void SECBitmapButton::OnSize(UINT nType, int cx, int cy)
{
	SECOwnerDrawButton::OnSize(nType, cx, cy);
	CalcLayout();
}

