//
// TBarBmpCombo.cpp -- Ersatz fuer die fehlende Implementierung von
//                     CTBarBitmapComboBtn.
//
// Die Datei fehlt in der Quelltextfreigabe des Computer History Museum; nur
// TBarBmpCombo.h ist vorhanden. Eudora.vcxproj listet TBarBmpCombo.cpp
// weiterhin (ClCompile, Zeile 532), also bricht der Build ohne diese Datei mit
// C1083 ab.
//
// WAS CTBarBitmapComboBtn IM ORIGINAL TUT
//   Ein CBitmapCombo -- das Kombinationsfeld mit Sinnbild pro Eintrag aus
//   bmpcombo.h -- das sich gleichzeitig als Knopf einer Stingray-
//   Werkzeugleiste ausgibt (Mehrfachvererbung CBitmapCombo + SECWndBtn). Die
//   Leiste legt es ueber ihre Knopftabelle an; die Klasse erzeugt das Fenster,
//   klinkt sich in das Kind-Eingabefeld des Kombinationsfeldes ein, meldet
//   ihre Groesse zurueck und reicht Mausereignisse zuerst an SECWndBtn weiter.
//
//   Auch diese Klasse wird tatsaechlich benutzt, entgegen der Annahme, sie sei
//   ungenutzt:
//     CompMessageFrame.cpp:153  BMPCOMBO_BUTTON( ID_PRIORITY,  ... )
//     CompMessageFrame.cpp:154  BMPCOMBO_BUTTON( ID_SIGNATURE, ... )
//     CompMessageFrame.cpp:155  BMPCOMBO_BUTTON( ID_ENCODING,  ... )
//     ReadMessageFrame.cpp:188  BMPCOMBO_BUTTON( ID_PRIORITY,  ... )
//   Das sind die Auswahlfelder fuer Dringlichkeit, Signatur und Kodierung in
//   der Werkzeugleiste des Verfassen-Fensters. TBarBmpCombo.h:71 definiert
//   BMPCOMBO_BUTTON ueber WND_BUTTON auf BUTTON_CLASS(CTBarBitmapComboBtn).
//
// WAS DIESER DUMMY STATTDESSEN TUT
//   Er baut so viel, wie ohne die Implementierung von SECWndBtn moeglich ist.
//   Fenstererzeugung, Einklinken des Kind-Eingabefeldes und Schriftwahl sind
//   Zeile fuer Zeile von der erhaltenen Schwesterklasse CTBarComboBtn
//   (TBarCombo.cpp) uebernommen -- diese ist der naechste Verwandte im
//   Quelltext und benutzt dieselben Bausteine (SECComboBtnEdit m_edit,
//   CFont m_font). Alles, was ohne die Innensicht von SECWndBtn nicht
//   rekonstruierbar ist, ist als solches benannt statt still leergeraeumt.
//
//   Keine Hinweismeldung: die Auswahlfelder werden von den Rahmenfenstern
//   gefuellt und ausgewertet (z.B. ReadMessageFrame.cpp:434-441 fuer die
//   Dringlichkeit). Es faellt hier keine Funktion aus, die zu melden waere.
//
// GELINKT WIRD HIER NOCH NICHT
//   SECWndBtn und SECStdBtn sind in OT501 nur als Header vorhanden
//   (OT501/Include/tbtnwnd.h bzw. tbtnstd.h); unter OT501/Src liegt keine
//   Implementierung. Diese Datei muss deshalb vorerst nur uebersetzen.
//

#include "stdafx.h"
#include "TBarBmpCombo.h"

// WINDOWSX.H hat ein Makro SubclassWindow, das mit CWnd::SubclassWindow
// kollidiert. Gleiche Stelle und gleicher Grund wie in TBarCombo.cpp:9-11.
#undef SubclassWindow

//
// Noetig wegen DECLARE_BUTTON(CTBarBitmapComboBtn) in TBarBmpCombo.h:16.
// Siehe OT501/Include/tbtnstd.h:195 und das Vorbild TBarCombo.cpp:5.
//
IMPLEMENT_BUTTON(CTBarBitmapComboBtn);


//
// Die Nachrichtentabelle gehoert an den CWnd-Zweig der Mehrfachvererbung,
// also an CBitmapCombo. SECWndBtn ist kein CCmdTarget.
//
// ON_WM_PAINT fehlt hier mit Absicht, siehe Kommentar bei OnPaint().
//
BEGIN_MESSAGE_MAP(CTBarBitmapComboBtn, CBitmapCombo)
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_RBUTTONDOWN()
	ON_WM_RBUTTONUP()
	ON_WM_RBUTTONDBLCLK()
	ON_WM_SETCURSOR()
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Anbindung an die Werkzeugleiste

//
// SECWndBtn::GetWnd ist rein virtuell (tbtnwnd.h:116), Kommentar dort:
// "Returns pointer to our CWnd". Eindeutig der CBitmapCombo-Zweig.
//
CWnd* CTBarBitmapComboBtn::GetWnd()
{
	return this;
}


//
// Uebernommen von CTBarComboBtn::CreateWnd (TBarCombo.cpp:13-40); dort
// dasselbe Muster mit demselben Member SECComboBtnEdit m_edit. Einziger
// Unterschied: erzeugt wird das Sinnbild-Kombinationsfeld CBitmapCombo
// (bmpcombo.h:72) statt eines schlichten CComboBox.
//
// Das Kind-Eingabefeld eines aufklappbaren Kombinationsfeldes ist ein eigenes
// Fenster und wuerde die Mausereignisse sonst selbst verschlucken; deshalb
// klinkt sich m_edit dort ein und traegt in m_pCombo den Rueckweg zu diesem
// Knopf ein (SECComboBtnEdit, OT501/Include/tbtncmbo.h:43 und :55).
//
BOOL CTBarBitmapComboBtn::CreateWnd(CWnd* pParentWnd, DWORD dwStyle, CRect& rect, int nID)
{
	if (!(dwStyle & (CBS_DROPDOWNLIST | CBS_DROPDOWN)))
		dwStyle |= CBS_DROPDOWNLIST;

	BOOL bRes = CBitmapCombo::Create(dwStyle, rect, pParentWnd, nID);
	ASSERT(bRes);
	if (bRes)
	{
		if (dwStyle & CBS_DROPDOWN)
		{
			// Das Kind-Eingabefeld unterklassen.
			CWnd* pWnd = GetWindow(GW_CHILD);
			if (pWnd != NULL)
			{
				VERIFY(m_edit.SubclassWindow(pWnd->m_hWnd));
				m_edit.m_pCombo = (SECWndBtn*) this;
			}
		}

		OnFontCreateAndSet();
		AdjustSize();		// Groesse an die Leiste zurueckmelden
	}

	return bRes;
}


//
// Kein leerer Rumpf, weil hier -- anders als bei CTBarEditBtn und
// CTBarStaticBtn -- das Schriftobjekt tatsaechlich existiert
// (TBarBmpCombo.h:56: "CFont m_font;", nicht auskommentiert). Genau derselbe
// Fall wie bei CTBarComboBtn, deshalb Zeile fuer Zeile von dort uebernommen
// (TBarCombo.cpp:43 ff.). Die Schrift bestimmt die Zeilenhoehe des
// Kombinationsfeldes; ohne sie stimmt die Groesse in der Leiste nicht.
//
void CTBarBitmapComboBtn::OnFontCreateAndSet()
{
	m_font.CreateFont(8, 0, 0, 0, FW_NORMAL, 0, 0, 0,
					  DEFAULT_CHARSET, OUT_CHARACTER_PRECIS,
					  CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY,
					  DEFAULT_PITCH | FF_DONTCARE, _T("MS Sans Serif"));

	SetFont(&m_font, TRUE);
}


//
// Weiterleitung an die Basis. Die eigentliche Rechnung sitzt in
// SECStdBtn/SECWndBtn und arbeitet auf deren geschuetzten Feldern m_nSize,
// m_nMinSize, m_nHeight, m_nRealHeight (tbtnwnd.h:129-133); ihre Bedeutung im
// Zusammenspiel mit der Leiste ist aus den Headern allein nicht zu
// rekonstruieren.
//
// CTBarComboBtn kommt sogar ganz ohne eigene Fassung aus -- in TBarCombo.h:30
// ist AdjustSize auskommentiert, dort wirkt die Basisfassung unveraendert.
// Diese Weiterleitung ist also genau das, was die Schwesterklasse tut.
//
void CTBarBitmapComboBtn::AdjustSize()
{
	SECWndBtn::AdjustSize();
}


//
// Weiterleitung an die Basis. SetMode wird laut TBarBmpCombo.h:34 gerufen,
// wenn die Leiste senkrecht angedockt wird; SECWndBtn haelt dafuer
// m_bWndVisible (tbtnwnd.h:129). Was die abgeleitete Klasse zusaetzlich getan
// hat, ist aus dem Header nicht zu belegen.
//
void CTBarBitmapComboBtn::SetMode(BOOL bVertical)
{
	SECWndBtn::SetMode(bVertical);
}


//
// Weiterleitung an die Basis.
//
// Das Original hat hier vermutlich die Eingabetaste abgefangen und ueber
// SECWndBtn::SendNotify die Meldung Entered an die Leiste geschickt
// (TBarBmpCombo.h:24-27). Nicht nachgebaut, weil niemand sie auswertet: eine
// Suche ueber Eudora/ und OT501/Include/ findet wmSECToolBarWndNotify und
// Entered ausschliesslich in den Deklarationen selbst, in keinem Empfaenger.
// CTBarComboBtn hat PreTranslateMessage aus demselben Grund gar nicht erst
// ueberschrieben (TBarCombo.h:21, auskommentiert).
//
BOOL CTBarBitmapComboBtn::PreTranslateMessage(MSG* pMsg)
{
	return CBitmapCombo::PreTranslateMessage(pMsg);
}


/////////////////////////////////////////////////////////////////////////////
// Nachrichtenbehandlung

//
// Mausereignisse gehen laut tbtnwnd.h:75 ("CWnd passes messages here first.")
// zuerst an SECWndBtn. Die BOOL-Rueckgabe bedeutet "erledigt"; nur wenn die
// Leiste das Ereignis nicht beansprucht, bekommt es das Kombinationsfeld
// selbst -- sonst liesse sich der Knopf im Anpassen-Modus nicht verschieben
// oder in der Breite ziehen.
//
void CTBarBitmapComboBtn::OnLButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDown(nFlags, point))
		CBitmapCombo::OnLButtonDown(nFlags, point);
}

void CTBarBitmapComboBtn::OnLButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonUp(nFlags, point))
		CBitmapCombo::OnLButtonUp(nFlags, point);
}

void CTBarBitmapComboBtn::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDblClk(nFlags, point))
		CBitmapCombo::OnLButtonDblClk(nFlags, point);
}

void CTBarBitmapComboBtn::OnRButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDown(nFlags, point))
		CBitmapCombo::OnRButtonDown(nFlags, point);
}

void CTBarBitmapComboBtn::OnRButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonUp(nFlags, point))
		CBitmapCombo::OnRButtonUp(nFlags, point);
}

void CTBarBitmapComboBtn::OnRButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDblClk(nFlags, point))
		CBitmapCombo::OnRButtonDblClk(nFlags, point);
}


//
// Zeigt im Anfasspunkt am rechten Rand den Waagerecht-Ziehen-Zeiger
// (SEC_WNDBTN_RESIZE_WIDTH, tbtnwnd.h:38). SECWndBtn::SetCursor meldet mit
// TRUE, dass es den Zeiger gesetzt hat.
//
BOOL CTBarBitmapComboBtn::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if (SECWndBtn::SetCursor())
		return TRUE;

	return CBitmapCombo::OnSetCursor(pWnd, nHitTest, message);
}


//
// LEER, UND DESHALB ABSICHTLICH NICHT IN DER NACHRICHTENTABELLE.
//
// Das Original umrahmt hier das Zeichnen mit SECWndBtn::PrePaint/PostPaint
// (tbtnwnd.h:85-86). Die genaue Reihenfolge ist ohne den OT501-Quelltext nicht
// zu rekonstruieren.
//
// Waere ON_WM_PAINT eingetragen und dieser Rumpf leer, bliebe das
// Auswahlfeld leer -- weder Dringlichkeitssinnbild noch Text waeren zu sehen,
// ein Fehler, der nicht nach fehlender Implementierung aussieht. Ohne den
// Eintrag zeichnet CBitmapCombo wie gewohnt ueber DrawItem
// (bmpcombo.h:70); verloren geht nur die SEC-Zusatzdarstellung im
// Anpassen-Modus.
//
void CTBarBitmapComboBtn::OnPaint()
{
}
