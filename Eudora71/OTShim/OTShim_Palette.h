// OTShim_Palette.h - Ersatzschicht fuer Stingray Objective Toolkit 5.0.1
//
// Ersetzt den Originalheader
//
//     OT501/Include/DTCtrl.h    SECDateTimeCtrl  (Datums-/Zeiteingabefeld)
//
// und setzt nebenbei den Waechter von
//
//     OT501/Include/DTGadget.h  SECDTGadget & Co.
//
// weil das nur die Anzeigebausteine des Originalfeldes sind: Eudora nennt
// keinen davon (geprueft mit einer Volltextsuche ueber Eudora71/Eudora ueber
// SECDTGadget, SECDTN_, SECDTID_ und SEC_DTS_ - einziger Treffer ist
// SEC_DTS_CALENDAR in SearchView.cpp:1566).
//
// Kodierung: reines ASCII, kein BOM. Umlaute als ae/oe/ue. Zeilenenden CRLF
// wie in den uebrigen OTShim-Dateien.
//
//
// ===========================================================================
// ZUM DATEINAMEN
// ===========================================================================
//
// Der Auftrag sah fuer diese Datei zwei Themen vor: die Farbtafelschicht aus
// SafetyPal.h (CSafetyPalette, CPaletteDC) und SECDateTimeCtrl. Die
// Farbtafelschicht steht NICHT hier. Der Agent KNOPF musste sie fuer Stufe 3
// mitliefern - SECBtnDrawData haelt drei CPaletteDC als Wertfelder
// (tbtnstd.h:48-50) und QCCustomToolBar, QCChildToolBar und
// QCCustomizeToolBar je eine CSafetyPalette -, sie steht deshalb seit Commit
// 91716bb in OTShim_Werkzeugleiste.cpp (Zeilen 94-275). Eine zweite Fassung
// hier waere ein Bindefehler. Der Dateiname bleibt trotzdem, damit die
// Verweise in PLAN.md und in den Auftragsunterlagen weiter stimmen.
//
//
// ===========================================================================
// TECHNIKWAHL: MFC CDateTimeCtrl
// ===========================================================================
//
// SECDateTimeCtrl ist ein von Grund auf selbstgebautes Eingabefeld: es zerlegt
// eine Formatzeichenkette in "Gadgets" (Stunde, Minute, Tagesname, Jahr ...),
// legt sie nebeneinander, faengt Tastatur und Maus ab und blendet bei Bedarf
// SECPopupCalendar ein. Stingray hat das 1997 gebaut, weil Windows damals
// nichts Vergleichbares mitbrachte.
//
// Seit Internet Explorer 3 bringt COMCTL32 die Fensterklasse SysDateTimePick32
// mit, MFC huellt sie in CDateTimeCtrl (afxdtctl.h). Sie kann genau das, was
// Eudora braucht:
//
//   - eine Formatzeichenkette in derselben Schreibweise (DTM_SETFORMAT nimmt
//     "MMMM d, yyyy" woertlich an - das ist die Zeichenkette hinter
//     IDS_SEARCH_DATE_CTRL_DISPLAY_FORMAT, SearchView.cpp:1565),
//   - einen aufklappbaren Monatskalender (Vorgabe, entspricht
//     SEC_DTS_CALENDAR),
//   - wahlweise ein Drehfeld statt des Kalenders (DTS_UPDOWN, entspricht
//     SEC_DTS_UPDOWN),
//   - Lesen und Setzen ueber COleDateTime.
//
// Deshalb ist SECDateTimeCtrl hier von CDateTimeCtrl abgeleitet und nicht,
// wie im Original, unmittelbar von CWnd. Das ist mit den Aufrufstellen
// vertraeglich: SearchView.cpp:2017 und :2137 reichen &m_DateTimeCtrl[nIdx]
// als CWnd* weiter, und CDateTimeCtrl ist ein CWnd.
//
//
// ===========================================================================
// WAS EUDORA WIRKLICH AUFRUFT
// ===========================================================================
//
// Volltextsuche ueber Eudora71/Eudora nach m_DateTimeCtrl und SECDateTimeCtrl.
// Das Feld liegt als Wertfeld-Array in SearchView.h:388, es gibt keine zweite
// Verwendung im Baum:
//
//   SearchView.h:388     SECDateTimeCtrl m_DateTimeCtrl[MAX_CONTROLS_CRITERIA]
//                        -> Standardbaumeister und Zerstoerer
//   SearchView.cpp:1565  SetFormat("MMMM d, yyyy")
//   SearchView.cpp:1566  AttachDateTimeCtrl(uID, this, SEC_DTS_CALENDAR)
//   SearchView.cpp:1567  SetFont            (aus CWnd)
//   SearchView.cpp:1076  ShowWindow(SW_HIDE)   (aus CWnd)
//   SearchView.cpp:2230  ShowWindow(SW_SHOW / SW_HIDE)
//   SearchView.cpp:2017  &m_DateTimeCtrl[nIdx] als CWnd*
//   SearchView.cpp:2137  MoveControl(&m_DateTimeCtrl[nIdx], ...)
//   SearchView.cpp:2438  GetDateTime()
//   SearchView.cpp:5124  GetDateTime()
//   SearchView.cpp:5261  SetDateTime(TmpDate)
//
// Sechs eigene Symbole also: Baumeister, Zerstoerer, SetFormat,
// AttachDateTimeCtrl, GetDateTime, SetDateTime. Alles andere kommt aus CWnd
// beziehungsweise CDateTimeCtrl.
//
// EINE FALLE STECKT DARIN: SetFormat wird in Zeile 1565 aufgerufen, also EINE
// ZEILE BEVOR das Fenster ueberhaupt entsteht (Zeile 1566). CDateTimeCtrl::
// SetFormat verschickt DTM_SETFORMAT und prueft vorher mit ASSERT, dass ein
// Fenster da ist - der unveraenderte Durchgriff wuerde im Debugbau eine
// Behauptung ausloesen und im Auslieferungsbau wirkungslos bleiben. SetFormat
// merkt sich die Zeichenkette deshalb hier und traegt sie nach, sobald
// AttachDateTimeCtrl das Fenster angelegt hat.
//
// Der uebrige oeffentliche Umfang von SECDateTimeCtrl ist nach der Regel
// "Dummy statt Weglassen" vollstaendig vorhanden. Was sich sinnvoll auf
// CDateTimeCtrl abbilden liess, ist abgebildet (SetMinMax/GetMinMax auf
// SetRange/GetRange, SizeToContent auf DTM_GETIDEALSIZE); der Rest hat einen
// leeren Rumpf mit Begruendung in OTShim_Palette.cpp. Die geschuetzten
// Innereien des Originals (ParseDateTimeFormat, ChangeHour, LayoutGadgets,
// die eingebetteten Klassen SECDTGadgetArray und SECNull ...) sind NICHT
// nachgebaut: sie sind Bauteile des selbstgebauten Feldes, kein Teil der
// Schnittstelle, und niemand ausserhalb kann sie aufrufen.
//
#ifndef __OTSHIM_PALETTE_H__
#define __OTSHIM_PALETTE_H__

//
// Waechter der ersetzten Stingray-Originale. Muessen VOR secall.h stehen.
//
// Zu __SECDATET_H__: DTCtrl.h traegt diesen Waechter, secall.h:436 fragt aber
// __DTCTRL_H__ ab - zwei verschiedene Namen fuer dieselbe Datei, ein Fehler im
// Original. Deshalb werden beide gesetzt; einer allein wuerde zwar auch
// reichen, aber nur, solange niemand den anderen Weg benutzt.
//
#ifndef __SECDATET_H__
#define __SECDATET_H__
#endif
#ifndef __DTCTRL_H__
#define __DTCTRL_H__
#endif
#ifndef __DTGADGET_H__
#define __DTGADGET_H__
#endif

#include <afxdisp.h>		// COleDateTime
#include <afxdtctl.h>		// CDateTimeCtrl

/////////////////////////////////////////////////////////////////////////////
// Werte aus DTCtrl.h, unveraendert uebernommen
//

// SECDateTimeCtrl styles
#define SEC_DTS_CALENDAR	0x0001L
#define SEC_DTS_UPDOWN		0x0002L

// SECDateTimeCtrl notifications
#define SECDTN_CHANGED		0x0100

// SECDateTimeCtrl Gadget IDs (bit settings)
#define SECDTID_12HOUR		0x0001
#define SECDTID_24HOUR		0x0002
#define SECDTID_MINUTE		0x0004
#define SECDTID_SECOND		0x0008
#define SECDTID_AMPM		0x0010
#define SECDTID_DAYNO		0x0020
#define SECDTID_DAYNAME		0x0040
#define SECDTID_MONTHNO		0x0080
#define SECDTID_MONTHNAME	0x0100
#define SECDTID_YEAR2		0x0200
#define SECDTID_YEAR4		0x0400
#define SECDTID_CALDROPDOWN	0x4000
#define SECDTID_SPINNER		0x8000
#define SECDTID_ALL			0xffff


// Nur vorwaerts angekuendigt, damit die Signaturen von InvalidateGadget und
// BringIntoView unveraendert bleiben. Die Klasse selbst gibt es nicht mehr -
// beide Methoden haben deshalb einen leeren Rumpf, und niemand kann ihnen
// einen anderen Wert als NULL uebergeben.
class SECDTGadget;

/////////////////////////////////////////////////////////////////////////////
// SECDateTimeCtrl
//
class SECDateTimeCtrl : public CDateTimeCtrl
{
	DECLARE_DYNAMIC(SECDateTimeCtrl)

// Construction
public:
	SECDateTimeCtrl();
	virtual ~SECDateTimeCtrl();

	BOOL Create(DWORD dwStyle, const RECT& rect, CWnd* pParentWnd, UINT nID,
				CCreateContext* pContext = NULL);
	BOOL CreateEx(DWORD dwExStyle, DWORD dwStyle, const RECT& rect,
				  CWnd* pParentWnd, UINT nID, CCreateContext* pContext = NULL);

	// Legt das Feld an der Stelle des Platzhalterfeldes mit der Kennung uID an.
	BOOL AttachDateTimeCtrl( UINT uID, CWnd* pParent, DWORD dwDTStyles,
		                     DWORD dwWinStyles = WS_CHILD|WS_TABSTOP,
							 DWORD dwExStyle = WS_EX_CLIENTEDGE );

// Attributes
public:
	// Formatart wie in Get/SetFormat
	enum FormatType
	{
		Time,							// Ortsuebliche Zeitschreibweise
		ShortDate,						// Ortsuebliche kurze Datumsschreibweise
		LongDate,						// Ortsuebliche lange Datumsschreibweise
		Custom							// Eigene Formatzeichenkette
	};

	// Pruefarten wie in Get/SetMinMax
	enum ValidationMode
	{
		NoValidation,
		TimeValidation,
		DateValidation,
		DateTimeValidation
	};

	// Nicht bearbeitbare Felder wie in Get/SetNoEdit
	enum NoEdit
	{
		FixedYear   = 0x0001,
		FixedMonth  = 0x0002,
		FixedDay    = 0x0004,
		FixedHour   = 0x0008,
		FixedMinute = 0x0010,
		FixedSecond = 0x0020,
		FixedDate   = 0x0007,
		FixedTime   = 0x0030
	};

// Operations
public:
	// Neuzeichnen eines einzelnen Bausteins - es gibt keine Bausteine mehr.
	void InvalidateGadget(SECDTGadget* pGadget, BOOL bImmediateRedraw = FALSE);
	void InvalidateGadget(int nIndex, BOOL bImmediateRedraw = FALSE);

	// Baustein an einem Punkt - es gibt keine Bausteine mehr.
	int  GadgetFromPoint(CPoint point);

	// Baustein in den sichtbaren Bereich holen - dito.
	void BringIntoView(SECDTGadget* pGadget);
	void BringIntoView(int nIndex);

	// Formatzeichenkette setzen und lesen
	void SetFormat(FormatType format);
	void SetFormat(LPCTSTR lpszFormat);
	void GetFormat(FormatType& format) const;
	void GetFormat(CString& format) const;

	// Schnelleingabe (Weiterspringen, sobald ein Zahlenfeld voll ist)
	void EnableFastEntry(BOOL bEnable = TRUE);
	BOOL IsFastEntryEnabled() const;

	// Fenster auf die Breite des Inhalts bringen
	void SizeToContent();

	// Aenderungsmerker
	void SetModified(BOOL bModified);
	void SetModified(BOOL bDate, BOOL bTime);
	BOOL IsModified() const;
	void IsModified(BOOL& bDate, BOOL& bTime) const;

	// TRUE, solange der Anwender in einem Zahlenfeld tippt
	BOOL IsEditing() const;

	// Datum und Zeit setzen und lesen
	BOOL SetDateTime(const COleDateTime& datetime);
	BOOL SetDate(const COleDateTime& date);
	BOOL SetTime(const COleDateTime& time);
	const COleDateTime& GetDateTime() const;

	// Pruefbereich setzen und lesen
	BOOL SetMinMax(const COleDateTime& minDateTime,
				   const COleDateTime& maxDateTime,
				   ValidationMode mode = DateTimeValidation);
	ValidationMode GetMinMax(COleDateTime& minDateTime,
							 COleDateTime& maxDateTime) const;

	// Prueft einen Wert gegen den eingestellten Bereich
	BOOL Validate(const COleDateTime& datetime) const;

	// Bearbeitbare Felder
	int  GetNoEdit() const;
	void SetNoEdit(int nNoEdit);

	// Leerdatum
	void SetNull(TCHAR cNull = _T('_'));
	TCHAR GetNullChar() const { return m_cNull; }

// Overrides
	// Wird vor dem Uebernehmen eines neuen Wertes gerufen; FALSE bricht ab.
	virtual BOOL OnChanging(const COleDateTime& newDateTime);

	// Wird nach einer Aenderung gerufen; meldet SECDTN_CHANGED an den Vater.
	virtual void OnChanged();

// Implementation
protected:
	mutable COleDateTime m_datetime;	// zuletzt gelesener oder gesetzter Wert
	COleDateTime      m_datetimeMin;	// unterer Rand des Pruefbereichs
	COleDateTime      m_datetimeMax;	// oberer Rand des Pruefbereichs
	ValidationMode    m_validMode;		// Pruefart
	FormatType        m_formatType;		// Formatart
	CString           m_strCustomFormat;// eigene Formatzeichenkette
	int               m_nState;			// Aenderungsmerker (siehe unten)
	int               m_nNoEdit;		// nicht bearbeitbare Felder
	BOOL              m_bFastInput;		// TRUE bei Schnelleingabe
	TCHAR             m_cNull;			// Fuellzeichen fuer Leerdatum

	enum								// Bits in m_nState
	{
		DateModified = 0x0001,
		TimeModified = 0x0002,
		Editing      = 0x0004
	};

	// Traegt m_formatType/m_strCustomFormat am Fenster nach.
	void ApplyFormat();

	afx_msg void OnDateTimeChange(NMHDR* pNMHDR, LRESULT* pResult);

	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////
// Freie Hilfsfunktionen aus DTCtrl.h
//
extern BOOL SECTmFromOleDate(DATE dtSrc, struct tm& tmDest);

extern BOOL SECSetOleDateTime(COleDateTime& dt, int nYear, int nMonth,
							  int nDay, int nHour, int nMinute, int nSecond);


/////////////////////////////////////////////////////////////////////////////

#define ON_SECDTN_CHANGED(id, memberFxn) \
		ON_CONTROL(SECDTN_CHANGED, id, memberFxn)


#endif // __OTSHIM_PALETTE_H__
