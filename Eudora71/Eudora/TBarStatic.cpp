//
// TBarStatic.cpp -- Ersatz fuer die fehlende Implementierung von
//                   CTBarStaticBtn.
//
// Die Datei fehlt in der Quelltextfreigabe des Computer History Museum; nur
// TBarStatic.h ist vorhanden. Eudora.vcxproj listet TBarStatic.cpp weiterhin
// (ClCompile, Zeile 537), also bricht der Build ohne diese Datei mit C1083 ab.
//
// WAS CTBarStaticBtn IM ORIGINAL TUT
//   Ein CStatic, das sich gleichzeitig als Knopf einer Stingray-Werkzeugleiste
//   ausgibt (Mehrfachvererbung CStatic + SECWndBtn). Die Werkzeugleiste legt es
//   ueber ihre Knopftabelle an; die Klasse erzeugt dafuer das Fenster, meldet
//   ihre Groesse an die Leiste zurueck und reicht Mausereignisse zuerst an
//   SECWndBtn weiter, damit Verschieben und Groessenaenderung im
//   Anpassen-Modus funktionieren.
//
//   Verwendet wird die Klasse tatsaechlich, entgegen der Annahme, sie sei
//   ungenutzt:
//     ReadMessageFrame.cpp:184  STATIC_BUTTON( ID_TOW_TRUCK, ... )
//     ReadMessageFrame.cpp:185  STATIC_BUTTON( ID_SUBJECT_STATIC, ... )
//   Beide Makros stehen in der Knopftabelle der Werkzeugleiste des
//   Nachrichtenfensters (TBarStatic.h:68 definiert STATIC_BUTTON ueber
//   WND_BUTTON auf BUTTON_CLASS(CTBarStaticBtn)). Zusaetzlich holt
//   ReadMessageFrame.cpp:423-425 den Knopf per GetDlgItem und ruft
//   SetWindowText und AdjustSize.
//
// WAS DIESER DUMMY STATTDESSEN TUT
//   Er baut so viel, wie ohne die Implementierung von SECWndBtn moeglich ist:
//   Fenstererzeugung und Weiterleitung an die Basisklasse. Alles, was ohne die
//   Innensicht von SECWndBtn nicht rekonstruierbar ist, ist als solches
//   benannt statt still leergeraeumt.
//
//   Keine Hinweismeldung: der Knopf ist zwar sichtbar, aber er ist kein
//   Bedienelement mit eigener Funktion, sondern die Beschriftung neben dem
//   Betreff-Feld. Es gibt hier nichts, was der Anwender ausloest und was
//   ausbleiben koennte.
//
// GELINKT WIRD HIER NOCH NICHT
//   SECWndBtn und SECStdBtn sind in OT501 nur als Header vorhanden
//   (OT501/Include/tbtnwnd.h bzw. tbtnstd.h); unter OT501/Src liegt keine
//   Implementierung. Diese Datei muss deshalb vorerst nur uebersetzen. Die
//   Aufrufe an SECWndBtn::... sind bewusst stehengeblieben, damit die Klasse
//   vollstaendig funktioniert, sobald die OT501-Ersatzschicht steht.
//

#include "stdafx.h"
#include "TBarStatic.h"

//
// Noetig wegen DECLARE_BUTTON(CTBarStaticBtn) in TBarStatic.h:14. Das Makro
// (OT501/Include/tbtnstd.h:195) deklariert das statische Klassenobjekt
// classCTBarStaticBtn, GetButtonClass() und CreateButton(); IMPLEMENT_BUTTON
// definiert sie. Ohne diese Zeile fehlt der Werkzeugleiste die Fabrikfunktion,
// mit der sie den Knopf aus der Knopftabelle heraus anlegt.
// Vorbild: TBarCombo.cpp:5.
//
IMPLEMENT_BUTTON(CTBarStaticBtn);


//
// Die Nachrichtentabelle gehoert an den CWnd-Zweig der Mehrfachvererbung,
// also an CStatic. SECWndBtn ist kein CCmdTarget und kann keine
// Fensternachrichten empfangen.
//
// ON_WM_PAINT fehlt hier mit Absicht, siehe Kommentar bei OnPaint().
//
BEGIN_MESSAGE_MAP(CTBarStaticBtn, CStatic)
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
// SECWndBtn::GetWnd ist rein virtuell (tbtnwnd.h:116) und liefert laut
// Kommentar dort "pointer to our CWnd". Eindeutig: der einzige CWnd-Zweig
// dieser Klasse ist CStatic.
//
CWnd* CTBarStaticBtn::GetWnd()
{
	return this;
}


//
// Auch CreateWnd ist rein virtuell (tbtnwnd.h:119). Aufbau uebernommen von
// CTBarComboBtn::CreateWnd (TBarCombo.cpp:13-40), der einzigen erhaltenen
// Schwesterklasse.
//
// Beachte: dwStyle wird unveraendert durchgereicht, WS_CHILD wird NICHT
// ergaenzt. Beleg: ReadMessageFrame.cpp:184 uebergibt fuer den Abschlepp-Knopf
// nur SS_NOTIFY | SS_ICON | SS_CENTERIMAGE ohne WS_CHILD, und TBarCombo.cpp
// ergaenzt es fuer die Kombinationsfelder ebenfalls nicht. Die fehlenden
// Fensterstile setzt also SECWndBtn::Init, bevor CreateWnd gerufen wird.
//
BOOL CTBarStaticBtn::CreateWnd(CWnd* pParentWnd, DWORD dwStyle, CRect& rect, int nID)
{
	BOOL bRes = CStatic::Create(NULL, dwStyle, rect, pParentWnd, nID);
	ASSERT(bRes);
	if (bRes)
	{
		OnFontCreateAndSet();
		AdjustSize();		// Groesse an die Leiste zurueckmelden
	}

	return bRes;
}


//
// Leerer Rumpf mit Absicht, und zwar belegt: TBarStatic.h:52 fuehrt das
// Schriftobjekt nur auskommentiert ("//	CFont m_font;"). Die Klasse besitzt
// also gar keine eigene Schrift, anders als CTBarComboBtn (TBarCombo.cpp:43),
// wo m_font existiert und gesetzt wird. Das Original hat hier folglich nichts
// erzeugt; die Beschriftung uebernimmt die Schrift, die die Werkzeugleiste
// ihren Kindfenstern zuweist.
//
void CTBarStaticBtn::OnFontCreateAndSet()
{
}


//
// ACHTUNG -- HIER DARF KEIN LEERER RUMPF STEHEN.
//
// ReadMessageFrame.cpp:423-425 holt diesen Knopf per GetDlgItem, setzt mit
// SetWindowText die Betreff-Beschriftung und ruft danach AdjustSize. Genau
// dieser Aufruf teilt der Werkzeugleiste die neue Breite des Textes mit. Ein
// leerer AdjustSize wuerde uebersetzen, liefe fehlerfrei durch und wuerde
// trotzdem still das Layout der Leiste zerstoeren: die Beschriftung behielte
// die Breite aus der Knopftabelle (ReadMessageFrame.cpp:185: 70 Pixel Vorgabe,
// 30 Pixel Minimum) und wuerde je nach Sprache abgeschnitten oder liesse eine
// Luecke vor dem Betreff-Feld. Ein solcher Fehler ist im Betrieb kaum als
// fehlende Implementierung zu erkennen.
//
// Mehr als die Weiterleitung ist ohne OT501-Quelltext nicht moeglich: die
// eigentliche Rechnung sitzt in SECStdBtn/SECWndBtn und arbeitet auf deren
// geschuetzten Feldern m_nSize, m_nMinSize, m_nHeight und m_nRealHeight
// (tbtnwnd.h:129-133). Deren Bedeutung im Zusammenspiel mit der Leiste ist aus
// den Headern allein nicht zu rekonstruieren.
//
// Wer die OT501-Ersatzschicht schreibt: SECWndBtn::AdjustSize muss die Breite
// aus dem Fensterinhalt bestimmen, sonst bleibt der oben beschriebene
// Layoutfehler bestehen.
//
void CTBarStaticBtn::AdjustSize()
{
	SECWndBtn::AdjustSize();
}


//
// Weiterleitung an die Basis. SetMode wird laut TBarStatic.h:32 gerufen, wenn
// die Leiste senkrecht angedockt wird; SECWndBtn haelt dafuer das Feld
// m_bWndVisible (tbtnwnd.h:129). Was die abgeleitete Klasse im Original
// zusaetzlich getan hat -- vermutlich das Kindfenster ein- und ausblenden --
// ist aus dem Header nicht zu belegen und steht deshalb nicht hier drin.
//
void CTBarStaticBtn::SetMode(BOOL bVertical)
{
	SECWndBtn::SetMode(bVertical);
}


//
// Weiterleitung an die Basis.
//
// Das Original hat hier vermutlich die Eingabetaste abgefangen und ueber
// SECWndBtn::SendNotify die Meldung Entered an die Leiste geschickt
// (TBarStatic.h:22-25). Das ist hier NICHT nachgebaut, weil es niemand
// auswertet: eine Suche ueber Eudora/ und OT501/Include/ findet
// wmSECToolBarWndNotify und Entered ausschliesslich in den Deklarationen
// selbst, in keinem einzigen Empfaenger. Ein nachgebautes PreTranslateMessage
// wuerde die Eingabetaste nur schlucken, ohne dass irgendwo etwas passiert.
//
BOOL CTBarStaticBtn::PreTranslateMessage(MSG* pMsg)
{
	return CStatic::PreTranslateMessage(pMsg);
}


/////////////////////////////////////////////////////////////////////////////
// Nachrichtenbehandlung

//
// Mausereignisse gehen laut tbtnwnd.h:75 ("CWnd passes messages here first.")
// zuerst an SECWndBtn. Die BOOL-Rueckgabe bedeutet "erledigt"; nur wenn die
// Leiste das Ereignis nicht fuer sich beansprucht -- also ausserhalb des
// Anpassen-Modus und ausserhalb des Anfasspunkts fuer die Breite -- bekommt
// es das Fenster selbst.
//
void CTBarStaticBtn::OnLButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDown(nFlags, point))
		CStatic::OnLButtonDown(nFlags, point);
}

void CTBarStaticBtn::OnLButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonUp(nFlags, point))
		CStatic::OnLButtonUp(nFlags, point);
}

void CTBarStaticBtn::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::LButtonDblClk(nFlags, point))
		CStatic::OnLButtonDblClk(nFlags, point);
}

void CTBarStaticBtn::OnRButtonDown(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDown(nFlags, point))
		CStatic::OnRButtonDown(nFlags, point);
}

void CTBarStaticBtn::OnRButtonUp(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonUp(nFlags, point))
		CStatic::OnRButtonUp(nFlags, point);
}

void CTBarStaticBtn::OnRButtonDblClk(UINT nFlags, CPoint point)
{
	if (!SECWndBtn::RButtonDblClk(nFlags, point))
		CStatic::OnRButtonDblClk(nFlags, point);
}


//
// Zeigt im Anfasspunkt am rechten Rand den Waagerecht-Ziehen-Zeiger
// (SEC_WNDBTN_RESIZE_WIDTH, tbtnwnd.h:38). SECWndBtn::SetCursor meldet mit
// TRUE, dass es den Zeiger gesetzt hat.
//
BOOL CTBarStaticBtn::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if (SECWndBtn::SetCursor())
		return TRUE;

	return CStatic::OnSetCursor(pWnd, nHitTest, message);
}


//
// LEER, UND DESHALB ABSICHTLICH NICHT IN DER NACHRICHTENTABELLE.
//
// Das Original umrahmt hier das Zeichnen des Fensters mit
// SECWndBtn::PrePaint/PostPaint (tbtnwnd.h:85-86) -- vermutlich, um den
// Rahmen im Anpassen-Modus zu zeichnen. Die genaue Reihenfolge ist ohne den
// OT501-Quelltext nicht zu rekonstruieren.
//
// Waere ON_WM_PAINT eingetragen und dieser Rumpf leer, bliebe die
// Beschriftung schlicht unsichtbar -- wieder ein Fehler, der nicht nach
// fehlender Implementierung aussieht. Ohne den Eintrag behandelt MFC WM_PAINT
// wie bei jedem anderen CStatic, die Beschriftung erscheint normal; verloren
// geht nur die SEC-Zusatzdarstellung im Anpassen-Modus.
//
// Wer die OT501-Ersatzschicht schreibt: hier ON_WM_PAINT ergaenzen, sobald
// PrePaint/PostPaint bekannt sind.
//
void CTBarStaticBtn::OnPaint()
{
}
