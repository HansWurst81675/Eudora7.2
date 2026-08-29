// OTShim_Palette.cpp - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1
//
// Umsetzung zu OTShim_Palette.h: SECDateTimeCtrl auf MFC CDateTimeCtrl.
// Begruendung der Technikwahl und die vollstaendige Aufrufliste stehen im
// Kopf von OTShim_Palette.h.
//
// Die Farbtafelschicht (CSafetyPalette, CPaletteDC) steht NICHT hier, sondern
// in OTShim_Werkzeugleiste.cpp - siehe den Abschnitt "ZUM DATEINAMEN" im
// Header.
//
// Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue. Zeilenenden CRLF.
//
// UEBERSETZEN: wie OTShim.cpp und OTShim_Bild.cpp ohne vorkompilierten
// Kopf (/Y-). Die Datei bindet ihre Kopfdateien selbst ein und haengt nicht
// an Eudoras stdafx.h.
//
// Eudora.vcxproj:67 gibt WINVER=0x0410 auf der Befehlszeile mit. MFC 14.38
// bricht damit ab: afxv_w32.h:36 sagt "MFC does not support WINVER less than
// 0x0501". Eudoras stdafx.h faengt das ab (stdafx.h:20-29), diese Datei
// benutzt stdafx.h aber nicht und muss es daher selbst tun - gemessen, nicht
// vermutet: ohne die folgenden neun Zeilen bricht cl.exe mit C1189 ab.
#ifdef WINVER
#undef WINVER
#endif
#define WINVER 0x0501
#ifdef _WIN32_WINNT
#undef _WIN32_WINNT
#endif
#define _WIN32_WINNT 0x0501

#include <afxwin.h>
#include <afxdisp.h>		// COleDateTime
#include <afxdtctl.h>		// CDateTimeCtrl
#include <commctrl.h>		// DTS_*, DTM_GETIDEALSIZE

#include "OTShim_Palette.h"


/////////////////////////////////////////////////////////////////////////////
// SECDateTimeCtrl

IMPLEMENT_DYNAMIC(SECDateTimeCtrl, CDateTimeCtrl)

BEGIN_MESSAGE_MAP(SECDateTimeCtrl, CDateTimeCtrl)
	// Das gemeine Steuerelement meldet eine Aenderung als DTN_DATETIMECHANGE
	// an den Vater; MFC spiegelt sie an das Element zurueck. Damit sieht
	// OnChanged dieselben Ereignisse wie im Original.
	ON_NOTIFY_REFLECT(DTN_DATETIMECHANGE, &SECDateTimeCtrl::OnDateTimeChange)
END_MESSAGE_MAP()


SECDateTimeCtrl::SECDateTimeCtrl()
{
	m_datetime    = COleDateTime::GetCurrentTime();
	m_validMode   = NoValidation;
	m_formatType  = ShortDate;
	m_nState      = 0;
	m_nNoEdit     = 0;
	m_bFastInput  = TRUE;
	m_cNull       = _T('_');

	m_datetimeMin.SetStatus(COleDateTime::null);
	m_datetimeMax.SetStatus(COleDateTime::null);
}

SECDateTimeCtrl::~SECDateTimeCtrl()
{
	// CWnd::~CWnd raeumt das Fenster ab. Eigener Besitz besteht nicht: das
	// Original gab hier seine Gadget-Liste und den Aufklappkalender frei,
	// beides uebernimmt jetzt das gemeine Steuerelement selbst.
}


/////////////////////////////////////////////////////////////////////////////
// Anlegen

BOOL SECDateTimeCtrl::Create(DWORD dwStyle, const RECT& rect, CWnd* pParentWnd,
							 UINT nID, CCreateContext* /*pContext*/)
{
	// pContext ist im Original durchgereicht, aber ein Fenster dieser Art
	// braucht keinen Erzeugungszusammenhang. CDateTimeCtrl::Create kennt den
	// Parameter deshalb gar nicht.
	if (!CDateTimeCtrl::Create(dwStyle, rect, pParentWnd, nID))
		return FALSE;

	ApplyFormat();
	CDateTimeCtrl::SetTime(m_datetime);
	return TRUE;
}

// CDateTimeCtrl kennt kein CreateEx; es hat nur Create, und das kennt keine
// erweiterten Stile.
//
// Der naheliegende Weg - CWnd::CreateEx mit DATETIMEPICK_CLASS, so wie
// CDateTimeCtrl::Create es intern tut (winctrl5.cpp:20-28) - scheidet aus:
// dort steht davor AfxDeferRegisterClass(AFX_WNDCOMMCTL_DATE_REG), und dieser
// Bezeichner ist bibliotheksintern (afximpl.h), also von hier aus nicht
// erreichbar. Ohne ihn ist nicht sichergestellt, dass die Fensterklasse des
// gemeinen Steuerelements schon angemeldet ist.
//
// Deshalb umgekehrt: erst regulaer anlegen lassen (dabei meldet MFC die
// Klasse an), dann den erweiterten Stil nachtragen. SWP_FRAMECHANGED sorgt
// dafuer, dass der Rahmen sofort neu vermessen wird.
BOOL SECDateTimeCtrl::CreateEx(DWORD dwExStyle, DWORD dwStyle, const RECT& rect,
							   CWnd* pParentWnd, UINT nID,
							   CCreateContext* /*pContext*/)
{
	if (!CDateTimeCtrl::Create(dwStyle, rect, pParentWnd, nID))
		return FALSE;

	if (dwExStyle != 0)
		ModifyStyleEx(0, dwExStyle, SWP_FRAMECHANGED);

	ApplyFormat();
	CDateTimeCtrl::SetTime(m_datetime);
	return TRUE;
}

// Das Original nahm ein bereits vorhandenes Steuerelement mit der Kennung uID
// als Platzhalter, uebernahm dessen Lage und trat an seine Stelle. Genau so
// benutzt es SearchView.cpp: dort wird in Zeile 1557-1561 ein CEdit als
// Platzhalter angelegt und in Zeile 1566 dieses Feld darauf gesetzt.
//
// Der Platzhalter dort ist eine oertliche Veraenderliche (CEdit TempEdit).
// Sein Zerstoerer wuerde das Fenster ohnehin am Ende der Funktion abraeumen;
// hier geschieht es sofort, damit nicht zwei Fenster mit derselben Kennung
// nebeneinander stehen. CWnd::DestroyWindow setzt m_hWnd auf NULL, der
// spaetere Zerstoerer von TempEdit findet also nichts mehr vor.
BOOL SECDateTimeCtrl::AttachDateTimeCtrl( UINT uID, CWnd* pParent,
										  DWORD dwDTStyles,
										  DWORD dwWinStyles /*= WS_CHILD|WS_TABSTOP*/,
										  DWORD dwExStyle /*= WS_EX_CLIENTEDGE*/ )
{
	if (pParent == NULL || !::IsWindow(pParent->GetSafeHwnd()))
		return FALSE;

	if (::IsWindow(GetSafeHwnd()))
		return TRUE;			// schon angelegt

	// Lage vom Platzhalter uebernehmen. Findet sich keiner, wird ein
	// bescheidener Vorgabewert benutzt - die endgueltige Lage setzt
	// CSearchView::MoveControl ohnehin bei jedem Groessenwechsel neu
	// (SearchView.cpp:2137).
	CRect rect(10, 10, 160, 34);

	CWnd* pPlaceholder = pParent->GetDlgItem(uID);
	if (pPlaceholder != NULL && ::IsWindow(pPlaceholder->GetSafeHwnd()))
	{
		pPlaceholder->GetWindowRect(rect);
		pParent->ScreenToClient(rect);
		pPlaceholder->DestroyWindow();
	}

	// SEC_DTS_UPDOWN -> Drehfeld; SEC_DTS_CALENDAR ist die Vorgabe des
	// gemeinen Steuerelements (aufklappbarer Monatskalender) und braucht
	// deshalb kein eigenes Stilbit.
	DWORD dwStyle = dwWinStyles;
	if (dwDTStyles & SEC_DTS_UPDOWN)
		dwStyle |= DTS_UPDOWN;

	// Ohne eigene Formatzeichenkette die kurze ortsuebliche Schreibweise.
	if (m_strCustomFormat.IsEmpty() && m_formatType == ShortDate)
		dwStyle |= DTS_SHORTDATEFORMAT;

	if (!CreateEx(dwExStyle, dwStyle, rect, pParent, uID))
		return FALSE;

	// Jetzt erst die vorgemerkte Formatzeichenkette nachtragen - SetFormat
	// wird eine Zeile vor AttachDateTimeCtrl gerufen, da gab es noch kein
	// Fenster (SearchView.cpp:1565/1566).
	ApplyFormat();
	CDateTimeCtrl::SetTime(m_datetime);

	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// Format

void SECDateTimeCtrl::ApplyFormat()
{
	if (!::IsWindow(GetSafeHwnd()))
		return;

	if (!m_strCustomFormat.IsEmpty())
	{
		CDateTimeCtrl::SetFormat(m_strCustomFormat);
		return;
	}

	// Ohne eigene Zeichenkette bestimmt das Stilbit die Anzeige; NULL an
	// DTM_SETFORMAT stellt auf die zum Stil gehoerende Vorgabe zurueck.
	CDateTimeCtrl::SetFormat(NULL);
}

void SECDateTimeCtrl::SetFormat(FormatType format)
{
	m_formatType = format;

	switch (format)
	{
	case Time:
		m_strCustomFormat = _T("HH':'mm':'ss");
		break;
	case ShortDate:
		m_strCustomFormat = _T("");			// Vorgabe des Steuerelements
		break;
	case LongDate:
		m_strCustomFormat = _T("dddd',' MMMM dd',' yyyy");
		break;
	case Custom:
		// Die Zeichenkette hat der Aufrufer schon ueber die andere
		// Ueberladung gesetzt; hier ist nichts zu tun.
		break;
	}

	ApplyFormat();
}

// Wird VOR dem Anlegen des Fensters gerufen (SearchView.cpp:1565). Deshalb
// nur merken; ApplyFormat traegt es nach.
void SECDateTimeCtrl::SetFormat(LPCTSTR lpszFormat)
{
	m_formatType      = Custom;
	m_strCustomFormat = (lpszFormat != NULL) ? lpszFormat : _T("");

	ApplyFormat();
}

void SECDateTimeCtrl::GetFormat(FormatType& format) const
{
	format = m_formatType;
}

void SECDateTimeCtrl::GetFormat(CString& format) const
{
	format = m_strCustomFormat;
}


/////////////////////////////////////////////////////////////////////////////
// Datum und Zeit

// Liefert eine Bezugnahme, wie im Original. Der gemerkte Wert wird vorher am
// Fenster aufgefrischt, damit Eingaben des Anwenders ankommen.
const COleDateTime& SECDateTimeCtrl::GetDateTime() const
{
	if (::IsWindow(GetSafeHwnd()))
	{
		COleDateTime dt;
		if (CDateTimeCtrl::GetTime(dt))
			m_datetime = dt;
	}

	return m_datetime;
}

BOOL SECDateTimeCtrl::SetDateTime(const COleDateTime& datetime)
{
	if (!Validate(datetime))
		return FALSE;

	if (!OnChanging(datetime))
		return FALSE;

	m_datetime = datetime;

	if (::IsWindow(GetSafeHwnd()))
	{
		if (!CDateTimeCtrl::SetTime(m_datetime))
			return FALSE;
	}

	return TRUE;
}

// Uebernimmt nur den Datumsteil und laesst die Uhrzeit stehen.
BOOL SECDateTimeCtrl::SetDate(const COleDateTime& date)
{
	COleDateTime dtCur = GetDateTime();

	COleDateTime dtNew;
	dtNew.SetDateTime(date.GetYear(), date.GetMonth(), date.GetDay(),
					  dtCur.GetHour(), dtCur.GetMinute(), dtCur.GetSecond());

	return SetDateTime(dtNew);
}

// Uebernimmt nur die Uhrzeit und laesst den Datumsteil stehen.
BOOL SECDateTimeCtrl::SetTime(const COleDateTime& time)
{
	COleDateTime dtCur = GetDateTime();

	COleDateTime dtNew;
	dtNew.SetDateTime(dtCur.GetYear(), dtCur.GetMonth(), dtCur.GetDay(),
					  time.GetHour(), time.GetMinute(), time.GetSecond());

	return SetDateTime(dtNew);
}


/////////////////////////////////////////////////////////////////////////////
// Pruefbereich

BOOL SECDateTimeCtrl::SetMinMax(const COleDateTime& minDateTime,
								const COleDateTime& maxDateTime,
								ValidationMode mode /*= DateTimeValidation*/)
{
	if (minDateTime > maxDateTime)
		return FALSE;

	m_datetimeMin = minDateTime;
	m_datetimeMax = maxDateTime;
	m_validMode   = mode;

	if (::IsWindow(GetSafeHwnd()))
		return CDateTimeCtrl::SetRange(&m_datetimeMin, &m_datetimeMax);

	return TRUE;
}

SECDateTimeCtrl::ValidationMode
SECDateTimeCtrl::GetMinMax(COleDateTime& minDateTime,
						   COleDateTime& maxDateTime) const
{
	minDateTime = m_datetimeMin;
	maxDateTime = m_datetimeMax;

	return m_validMode;
}

// Das Original prueft je nach Pruefart nur den Datums- oder nur den Zeitteil.
// Hier wird der ganze Wert verglichen, sobald ueberhaupt geprueft wird - der
// Unterschied faellt nur auf, wenn jemand TimeValidation mit einem Bereich
// ueber mehrere Tage benutzt. Eudora ruft SetMinMax nirgends auf, geprueft
// mit einer Volltextsuche ueber Eudora71/Eudora.
BOOL SECDateTimeCtrl::Validate(const COleDateTime& datetime) const
{
	if (m_validMode == NoValidation)
		return TRUE;

	if (datetime.GetStatus() != COleDateTime::valid)
		return FALSE;

	if (m_datetimeMin.GetStatus() == COleDateTime::valid &&
		datetime < m_datetimeMin)
		return FALSE;

	if (m_datetimeMax.GetStatus() == COleDateTime::valid &&
		datetime > m_datetimeMax)
		return FALSE;

	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// Zustandsmerker

void SECDateTimeCtrl::SetModified(BOOL bModified)
{
	if (bModified)
		m_nState |= (DateModified | TimeModified);
	else
		m_nState &= ~(DateModified | TimeModified);
}

void SECDateTimeCtrl::SetModified(BOOL bDate, BOOL bTime)
{
	if (bDate)
		m_nState |= DateModified;
	else
		m_nState &= ~DateModified;

	if (bTime)
		m_nState |= TimeModified;
	else
		m_nState &= ~TimeModified;
}

BOOL SECDateTimeCtrl::IsModified() const
{
	return (m_nState & (DateModified | TimeModified)) != 0;
}

void SECDateTimeCtrl::IsModified(BOOL& bDate, BOOL& bTime) const
{
	bDate = (m_nState & DateModified) != 0;
	bTime = (m_nState & TimeModified) != 0;
}

// Das Original meldete TRUE, solange der Anwender in einem seiner selbst
// gebauten Zahlenfelder tippte. Das gemeine Steuerelement fuehrt keinen
// solchen Zwischenzustand nach aussen; es gibt nichts zu melden.
BOOL SECDateTimeCtrl::IsEditing() const
{
	return FALSE;
}


/////////////////////////////////////////////////////////////////////////////
// Bausteine - im Original die selbst gezeichneten Teilfelder
//
// Alle vier Methoden haben einen leeren Rumpf: die Teilfelder gehoeren jetzt
// dem gemeinen Steuerelement, das sie selbst zeichnet, selbst umbricht und
// selbst in den sichtbaren Bereich holt. Eudora ruft keine davon (Volltext-
// suche ueber Eudora71/Eudora nach InvalidateGadget, GadgetFromPoint und
// BringIntoView: kein Treffer).

void SECDateTimeCtrl::InvalidateGadget(SECDTGadget* /*pGadget*/,
									   BOOL /*bImmediateRedraw*/)
{
}

void SECDateTimeCtrl::InvalidateGadget(int /*nIndex*/,
									   BOOL /*bImmediateRedraw*/)
{
}

int SECDateTimeCtrl::GadgetFromPoint(CPoint /*point*/)
{
	return -1;					// wie im Original: kein Baustein getroffen
}

void SECDateTimeCtrl::BringIntoView(SECDTGadget* /*pGadget*/)
{
}

void SECDateTimeCtrl::BringIntoView(int /*nIndex*/)
{
}


/////////////////////////////////////////////////////////////////////////////
// Einstellungen ohne Entsprechung im gemeinen Steuerelement
//
// Merker werden gefuehrt und wieder ausgegeben, wirken aber nicht: das
// Weiterspringen nach vollem Zahlenfeld, das Sperren einzelner Felder und die
// Anzeige eines Leerdatums waren Eigenheiten des selbst gebauten Feldes.
// SysDateTimePick32 springt von sich aus weiter, sperrt nichts und kennt den
// Leerzustand nur als Ankreuzfeld (DTS_SHOWNONE). Eudora ruft keine dieser
// Methoden.

void SECDateTimeCtrl::EnableFastEntry(BOOL bEnable /*= TRUE*/)
{
	m_bFastInput = bEnable;
}

BOOL SECDateTimeCtrl::IsFastEntryEnabled() const
{
	return m_bFastInput;
}

int SECDateTimeCtrl::GetNoEdit() const
{
	return m_nNoEdit;
}

void SECDateTimeCtrl::SetNoEdit(int nNoEdit)
{
	m_nNoEdit = nNoEdit;
}

void SECDateTimeCtrl::SetNull(TCHAR cNull /*= _T('_')*/)
{
	m_cNull = cNull;
}

// Das Original mass die Bausteine aus und passte die Fensterbreite an. Das
// gemeine Steuerelement beantwortet dieselbe Frage seit Windows Vista mit
// DTM_GETIDEALSIZE; faellt die Antwort aus, bleibt die Groesse wie sie ist.
//
// Die Fallunterscheidung ist noetig, weil commctrl.h DTM_GETIDEALSIZE hinter
// NTDDI_VERSION >= NTDDI_VISTA versteckt (commctrl.h:6761). Uebersetzt jemand
// gegen ein aelteres Ziel, bleibt die Methode ein Rumpf - dann ist das
// Verhalten dasselbe wie bei einer ausbleibenden Antwort.
void SECDateTimeCtrl::SizeToContent()
{
#ifdef DTM_GETIDEALSIZE
	if (!::IsWindow(GetSafeHwnd()))
		return;

	SIZE size = { 0, 0 };
	if (::SendMessage(GetSafeHwnd(), DTM_GETIDEALSIZE, 0, (LPARAM)&size) &&
		size.cx > 0 && size.cy > 0)
	{
		SetWindowPos(NULL, 0, 0, size.cx, size.cy,
					 SWP_NOMOVE | SWP_NOZORDER | SWP_NOACTIVATE);
	}
#endif
}


/////////////////////////////////////////////////////////////////////////////
// Benachrichtigungen

BOOL SECDateTimeCtrl::OnChanging(const COleDateTime& /*newDateTime*/)
{
	return TRUE;				// wie im Original: nichts einzuwenden
}

// Wie im Original: SECDTN_CHANGED als WM_COMMAND an den Vater. Eudora hoert
// darauf nirgends (Volltextsuche nach SECDTN_CHANGED und ON_SECDTN_CHANGED
// ueber Eudora71/Eudora: kein Treffer); der Weg bleibt trotzdem stehen, damit
// spaeterer Code ihn vorfindet.
void SECDateTimeCtrl::OnChanged()
{
	CWnd* pParent = GetParent();
	if (pParent == NULL || !::IsWindow(pParent->GetSafeHwnd()))
		return;

	pParent->SendMessage(WM_COMMAND,
						 MAKEWPARAM(GetDlgCtrlID(), SECDTN_CHANGED),
						 (LPARAM)GetSafeHwnd());
}

void SECDateTimeCtrl::OnDateTimeChange(NMHDR* /*pNMHDR*/, LRESULT* pResult)
{
	SetModified(TRUE);
	OnChanged();

	if (pResult != NULL)
		*pResult = 0;
}


/////////////////////////////////////////////////////////////////////////////
// Freie Hilfsfunktionen aus DTCtrl.h
//
// Eudora ruft beide nicht (Volltextsuche ueber Eudora71/Eudora nach
// SECTmFromOleDate und SECSetOleDateTime: kein Treffer). Sie sind trotzdem
// ausgefuehrt und nicht als Rumpf abgelegt, weil sie kurz sind und weil ein
// Rumpf hier stillschweigend falsche Werte liefern wuerde.

BOOL SECTmFromOleDate(DATE dtSrc, struct tm& tmDest)
{
	SYSTEMTIME st;
	if (!::VariantTimeToSystemTime(dtSrc, &st))
		return FALSE;

	::memset(&tmDest, 0, sizeof(tmDest));
	tmDest.tm_sec   = st.wSecond;
	tmDest.tm_min   = st.wMinute;
	tmDest.tm_hour  = st.wHour;
	tmDest.tm_mday  = st.wDay;
	tmDest.tm_mon   = st.wMonth - 1;		// tm zaehlt Monate ab 0
	tmDest.tm_year  = st.wYear - 1900;		// tm zaehlt Jahre ab 1900
	tmDest.tm_wday  = st.wDayOfWeek;
	tmDest.tm_yday  = 0;					// wird hier nicht bestimmt
	tmDest.tm_isdst = -1;					// unbekannt

	return TRUE;
}

BOOL SECSetOleDateTime(COleDateTime& dt, int nYear, int nMonth,
					   int nDay, int nHour, int nMinute, int nSecond)
{
	return dt.SetDateTime(nYear, nMonth, nDay, nHour, nMinute, nSecond) == 0;
}
