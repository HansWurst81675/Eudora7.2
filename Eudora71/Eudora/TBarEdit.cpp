//
// TBarEdit.cpp -- Ersatz fuer die fehlende Implementierung von CTBarEditBtn.
//
// Die Datei fehlt in der Quelltextfreigabe des Computer History Museum; nur
// TBarEdit.h ist vorhanden. Eudora.vcxproj listet TBarEdit.cpp weiterhin
// (ClCompile, Zeile 534), also bricht der Build ohne diese Datei mit C1083 ab.
//
// WAS CTBarEditBtn IM ORIGINAL TUT
//   Ein CEdit, das sich gleichzeitig als Knopf einer Stingray-Werkzeugleiste
//   ausgibt (Mehrfachvererbung CEdit + SECWndBtn). Die Leiste legt es ueber
//   ihre Knopftabelle an; die Klasse erzeugt das Fenster, meldet ihre Groesse
//   zurueck, reicht Mausereignisse zuerst an SECWndBtn weiter und behandelt
//   die Zwischenablage-Befehle selbst.
//
//   Auch diese Klasse wird tatsaechlich benutzt, entgegen der Annahme, sie sei
//   ungenutzt:
//     ReadMessageFrame.cpp:186  EDIT_BUTTON( ID_SUBJECT, IDC_SUBJECT, ... )
//   Das ist das Betreff-Eingabefeld in der Werkzeugleiste des
//   Nachrichtenfensters. TBarEdit.h:74 definiert EDIT_BUTTON ueber WND_BUTTON
//   auf BUTTON_CLASS(CTBarEditBtn).
//
// WAS DIESER DUMMY STATTDESSEN TUT
//   Er baut so viel, wie ohne die Implementierung von SECWndBtn moeglich ist.
//   Die Zwischenablage-Befehle sind vollstaendig ausgefuehrt -- sie brauchen
//   nichts aus OT501, sondern nur CEdit. Alles, was ohne die Innensicht von
//   SECWndBtn nicht rekonstruierbar ist, ist als solches benannt statt still
//   leergeraeumt.
//
//   Keine Hinweismeldung noetig: was der Anwender an diesem Feld tut --
//   tippen, ausschneiden, kopieren, einfuegen -- funktioniert hier
//   vollstaendig. Es faellt keine Funktion aus, die zu melden waere.
//
// GELINKT WIRD HIER NOCH NICHT
//   SECWndBtn und SECStdBtn sind in OT501 nur als Header vorhanden
//   (OT501/Include/tbtnwnd.h bzw. tbtnstd.h); unter OT501/Src liegt keine
//   Implementierung. Diese Datei muss deshalb vorerst nur uebersetzen.
//

#include "stdafx.h"
#include "TBarEdit.h"

//
// Noetig wegen DECLARE_BUTTON(CTBarEditBtn) in TBarEdit.h:14. Siehe
// OT501/Include/tbtnstd.h:195 und das Vorbild TBarCombo.cpp:5.
//
IMPLEMENT_BUTTON(CTBarEditBtn);


//
// Die Nachrichtentabelle gehoert an den CWnd-Zweig der Mehrfachvererbung,
// also an CEdit. SECWndBtn ist kein CCmdTarget.
//
// ON_WM_PAINT fehlt hier mit Absicht, siehe Kommentar bei OnPaint().
//
BEGIN_MESSAGE_MAP(CTBarEditBtn, CEdit)
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_RBUTTONDOWN()
	ON_WM_RBUTTONUP()
	ON_WM_RBUTTONDBLCLK()
	ON_WM_SETCURSOR()
	ON_COMMAND(ID_EDIT_CUT, OnCut)
	ON_UPDATE_COMMAND_UI(ID_EDIT_CUT, OnUpdateCut)
	ON_COMMAND(ID_EDIT_COPY, OnCopy)
	ON_UPDATE_COMMAND_UI(ID_EDIT_COPY, OnUpdateCopy)
	ON_COMMAND(ID_EDIT_PASTE, OnPaste)
	ON_UPDATE_COMMAND_UI(ID_EDIT_PASTE, OnUpdatePaste)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Anbindung an die Werkzeugleiste

//
// SECWndBtn::GetWnd ist rein virtuell (tbtnwnd.h:116), Kommentar dort:
// "Returns pointer to our CWnd". Eindeutig der CEdit-Zweig.
//
CWnd* CTBarEditBtn::GetWnd()
{
	return this;
}


//
// Aufbau uebernommen von CTBarComboBtn::CreateWnd (TBarCombo.cpp:13-40).
// dwStyle wird unveraendert durchgereicht; ReadMessageFrame.cpp:186 setzt
// WS_CHILD | WS_BORDER | ES_AUTOHSCROLL bereits in der Knopftabelle.
//
BOOL CTBarEditBtn::CreateWnd(CWnd* pParentWnd, DWORD dwStyle, CRect& rect, int nID)
{
	BOOL bRes = CEdit::Create(dwStyle, rect, pParentWnd, nID);
	ASSERT(bRes);
	if (bRes)
	{
		OnFontCreateAndSet();
		AdjustSize();		// Groesse an die Leiste zurueckmelden
	}

	return bRes;
}


//
// Leerer Rumpf mit Absicht, und zwar belegt: TBarEdit.h:52 fuehrt das
// Schriftobjekt nur auskommentiert ("//	CFont m_font;"). Die Klasse besitzt
// also gar keine eigene Schrift, anders als CTBarComboBtn (TBarCombo.cpp:43),
// wo m_font existiert und gesetzt wird. Das Original hat hier folglich nichts
// erzeugt; das Feld uebernimmt die Schrift der Werkzeugleiste.
//
void CTBarEditBtn::OnFontCreateAndSet()
{
}


//
// Weiterleitung an die Basis. Die eigentliche Rechnung sitzt in
// SECStdBtn/SECWndBtn und arbeitet auf deren geschuetzten Feldern m_nSize,
// m_nMinSize, m_nHeight, m_nRealHeight (tbtnwnd.h:129-133); ihre Bedeutung im
// Zusammenspiel mit der Leiste ist aus den Headern allein nicht zu
// rekonstruieren.
//
// Anders als bei CTBarStaticBtn ruft hier kein Eudora-Quelltext AdjustSize
// von aussen -- der einzige Aufruf steht oben in CreateWnd.
//
void CTBarEditBtn::AdjustSize()
{
	SECWndBtn::AdjustSize();
}


//
// Weiterleitung an die Basis. SetMode wird laut TBarEdit.h:32 gerufen, wenn
// die Leiste senkrecht angedockt wird; SECWndBtn haelt dafuer m_bWndVisible
// (tbtnwnd.h:129). Was die abgeleitete Klasse zusaetzlich getan hat, ist aus
// dem Header nicht zu belegen.
//
void CTBarEditBtn::SetMode(BOOL bVertical)
{
	SECWndBtn::SetMode(bVertical);
}


//
// Weiterleitung an die Basis.
//
// Das Original hat hier vermutlich die Eingabetaste abgefangen und ueber
// SECWndBtn::SendNotify die Meldung Entered an die Leiste geschickt
// (TBarEdit.h:22-25). Nicht nachgebaut, weil niemand sie auswertet: eine Suche
// ueber Eudora/ und OT501/Include/ findet wmSECToolBarWndNotify und Entered
// ausschliesslich in den Deklarationen selbst, in keinem Empfaenger. Ein
// nachgebautes PreTranslateMessage wuerde die Eingabetaste im Betreff-Feld nur
// schlucken, ohne dass irgendwo etwas passiert.
//
BOOL CTBarEditBtn::PreTranslateMessage(MSG* pMsg)
{
	return CEdit::PreTranslateMessage(pMsg);
}


/////////////////////////////////////////////////////////////////////////////
// Nachrichtenbehandlung

//
// Mausereignisse gehen laut tbtnwnd.h:75 ("CWnd passes messages here first.")
// zuerst an SECWndBtn. Die BOOL-Rueckgabe bedeutet "erledigt"; nur wenn die
// Leiste das Ereignis nicht beansprucht, bekommt es das Eingabefeld selbst.
//
void CTBarEditBtn::OnLButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDown(nFlags, point))
		CEdit::OnLButtonDown(nFlags, point);
}

void CTBarEditBtn::OnLButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonUp(nFlags, point))
		CEdit::OnLButtonUp(nFlags, point);
}

void CTBarEditBtn::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDblClk(nFlags, point))
		CEdit::OnLButtonDblClk(nFlags, point);
}

void CTBarEditBtn::OnRButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDown(nFlags, point))
		CEdit::OnRButtonDown(nFlags, point);
}

void CTBarEditBtn::OnRButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonUp(nFlags, point))
		CEdit::OnRButtonUp(nFlags, point);
}

void CTBarEditBtn::OnRButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDblClk(nFlags, point))
		CEdit::OnRButtonDblClk(nFlags, point);
}


//
// Zeigt im Anfasspunkt am rechten Rand den Waagerecht-Ziehen-Zeiger
// (SEC_WNDBTN_RESIZE_WIDTH, tbtnwnd.h:38). SECWndBtn::SetCursor meldet mit
// TRUE, dass es den Zeiger gesetzt hat; sonst bleibt es beim Textcursor des
// Eingabefeldes.
//
BOOL CTBarEditBtn::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if (SECWndBtn::SetCursor())
		return TRUE;

	return CEdit::OnSetCursor(pWnd, nHitTest, message);
}


/////////////////////////////////////////////////////////////////////////////
// Zwischenablage
//
// Vollstaendig ausgefuehrt, kein Rumpf: diese sechs Methoden brauchen nichts
// aus OT501, sondern nur CEdit. Sie haengen am Menue "Edit > Cut/Copy/Paste"
// und an den zugehoerigen Tastenkuerzeln, sind also unmittelbar am Anwender.
// Ein leerer Rumpf waere hier ein sichtbarer Fehler ohne Not.
//
// Das Feld braucht eigene Behandler, weil die Befehle sonst am Rahmenfenster
// haengenbleiben und in der Nachricht statt im Betreff-Feld wirken wuerden.
//

void CTBarEditBtn::OnCut()
{
	Cut();
}

void CTBarEditBtn::OnUpdateCut(CCmdUI* pCmdUI)
{
	int nStart = 0, nEnd = 0;
	GetSel(nStart, nEnd);
	pCmdUI->Enable(nStart != nEnd);
}

void CTBarEditBtn::OnCopy()
{
	Copy();
}

void CTBarEditBtn::OnUpdateCopy(CCmdUI* pCmdUI)
{
	int nStart = 0, nEnd = 0;
	GetSel(nStart, nEnd);
	pCmdUI->Enable(nStart != nEnd);
}

void CTBarEditBtn::OnPaste()
{
	Paste();
}

void CTBarEditBtn::OnUpdatePaste(CCmdUI* pCmdUI)
{
	pCmdUI->Enable(::IsClipboardFormatAvailable(CF_TEXT));
}


//
// LEER, UND DESHALB ABSICHTLICH NICHT IN DER NACHRICHTENTABELLE.
//
// Das Original umrahmt hier das Zeichnen mit SECWndBtn::PrePaint/PostPaint
// (tbtnwnd.h:85-86). Die genaue Reihenfolge ist ohne den OT501-Quelltext nicht
// zu rekonstruieren.
//
// Waere ON_WM_PAINT eingetragen und dieser Rumpf leer, bliebe das Betreff-Feld
// leer und der Anwender saehe seinen eigenen Text nicht -- ein Fehler, der
// nicht nach fehlender Implementierung aussieht. Ohne den Eintrag zeichnet
// MFC das Feld wie jedes andere CEdit; verloren geht nur die
// SEC-Zusatzdarstellung im Anpassen-Modus.
//
void CTBarEditBtn::OnPaint()
{
}
