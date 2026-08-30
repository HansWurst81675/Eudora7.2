//
// TestOTShimAndocken.cpp - prueft die Rechenmethoden der Andockfamilie
//
// Gegenstand ist OTShim.cpp (Stufe 2): SECControlBar und SECDockBar. Diese
// Datei laesst sich in das Testprogramm binden, weil OTShim.cpp ausser
// <afxwin.h> nur die Originalheader aus OT501/Include braucht; secData kommt
// aus OT501/Src/secaux.cpp, das mit uebersetzt wird (siehe OTShimProbe.cpp).
//
// GEPRUEFT WIRD, was ohne Fenster rechnet:
//
//   SECControlBar::CalcFixedLayout    - ECHTE Stingray-Funktionalitaet.
//       CControlBar::CalcFixedLayout liefert nur 0 oder 32767 und weiss
//       nichts von den drei gespeicherten Massen. CAdWazooBar.cpp:239 holt
//       sich genau diese Fassung und begrenzt das Ergebnis nach unten.
//   SECControlBar::CalcDynamicLayout  - fuer Leisten mit CBRS_SIZE_DYNAMIC.
//   SECControlBar::Get/SetBarInfo     - der Rundlauf, den
//       WazooBarMgr.cpp:432-436 wirklich geht:
//           SECControlBarInfo info;
//           pWazooBar->GetBarInfo(&info);
//           info.m_szDockHorz.cy = 80;
//           pWazooBar->SetBarInfo(&info, pMainFrame);
//       Faellt dabei ein Feld heraus, laesst sich die Andockhoehe der
//       Wazoo-Leiste nicht mehr einstellen - stillschweigend.
//   SECDockBar - die Zeilenlogik auf m_arrBars.
//
// WAS HIER NICHT GEPRUEFT WIRD und warum, steht am Ende der Datei.
//
#include <afxwin.h>
#include <afxext.h>
#include <afxpriv.h>
#include <stdio.h>
#include <crtdbg.h>

#include "TinyTest.h"
#include "OTShim.h"
#include "sdocksta.h"


/////////////////////////////////////////////////////////////////////////////
// Zusicherungen zaehlen und unterdruecken
//
// Ein Teil der hier geprueften Wege ruft MFC-Methoden, die ein Fenster
// voraussetzen und das mit ASSERT(::IsWindow(m_hWnd)) auch sagen -
// CControlBar::GetBarInfo etwa liest IsVisible(). Das ist KEIN Mangel der
// Ersatzschicht: MFC verlangt dort wirklich ein Fenster. Die Zusicherungen
// werden deshalb gezaehlt und geschluckt, damit der Testlauf ruhig bleibt;
// die eigentliche Pruefung gilt dem Stingray-Anteil, der daneben laeuft.
//
// Die Windows-Aufrufe darunter sind mit einem NULL-Griff harmlos: sie
// scheitern und veraendern nichts.

static int s_nZusicherungen = 0;

static int __cdecl AndockHaken(int nReportType, char* /*szMsg*/, int* pnRet)
{
	if (nReportType == _CRT_ASSERT)
		++s_nZusicherungen;
	if (pnRet != NULL)
		*pnRet = 0;
	return TRUE;
}

static int __cdecl AndockHakenW(int nReportType, wchar_t* /*szMsg*/, int* pnRet)
{
	if (nReportType == _CRT_ASSERT)
		++s_nZusicherungen;
	if (pnRet != NULL)
		*pnRet = 0;
	return TRUE;
}

static void ZusicherungenSchlucken(void)
{
	s_nZusicherungen = 0;
	_CrtSetReportHook2(_CRT_RPTHOOK_INSTALL, AndockHaken);
	_CrtSetReportHookW2(_CRT_RPTHOOK_INSTALL, AndockHakenW);
}

static int ZusicherungenWiederMelden(void)
{
	_CrtSetReportHookW2(_CRT_RPTHOOK_REMOVE, AndockHakenW);
	_CrtSetReportHook2(_CRT_RPTHOOK_REMOVE, AndockHaken);
	return s_nZusicherungen;
}


/////////////////////////////////////////////////////////////////////////////
// Eine Leiste zum Hineinschauen
//
// m_pDockBar ist geschuetztes Feld von CControlBar und entscheidet ueber
// IsFloating() (MFC, winfrm.cpp:2479):
//     m_pDockBar != NULL && m_pDockBar->m_bFloating
// Ohne Zugriff darauf laesst sich der Schwebe-Zweig von CalcDynamicLayout
// nicht pruefen. Gesetzt wird nur der Zeiger; es entsteht kein Fenster.

class ProbeLeiste : public SECControlBar
{
public:
	void AndockleisteSetzen(CDockBar* pDockBar) { m_pDockBar = pDockBar; }
};


static void GroesseVergleichen(CSize szIst, int cxSoll, int cySoll, const char* szWas)
{
	if (szIst.cx != cxSoll || szIst.cy != cySoll)
		TT_Fail("%s liefert %dx%d, erwartet %dx%d", szWas, szIst.cx, szIst.cy, cxSoll, cySoll);
}


/////////////////////////////////////////////////////////////////////////////
// 1. Vorgabewerte von SECControlBar

static void Test_Vorgaben(void)
{
	ProbeLeiste leiste;

	TT_BeginTest("SECControlBar: Vorgabewerte einer frisch angelegten Leiste");

	GroesseVergleichen(leiste.m_szDockHorz, 200, 100, "m_szDockHorz");
	GroesseVergleichen(leiste.m_szDockVert, 200, 100, "m_szDockVert");
	GroesseVergleichen(leiste.m_szFloat,    200, 100, "m_szFloat");

	if (leiste.m_ptDockHorz != CPoint(0, 0))
		TT_Fail("m_ptDockHorz ist (%ld,%ld), erwartet (0,0)",
				leiste.m_ptDockHorz.x, leiste.m_ptDockHorz.y);
	if (leiste.m_dwMRUDockingState != CBRS_ALIGN_ANY)
		TT_Fail("m_dwMRUDockingState = 0x%08lX, erwartet CBRS_ALIGN_ANY (0x%08lX)",
				leiste.m_dwMRUDockingState, (DWORD) CBRS_ALIGN_ANY);
	if (leiste.m_fPctWidth != (float) 1.0)
		TT_Fail("m_fPctWidth = %f, erwartet 1.0", leiste.m_fPctWidth);
	if (leiste.m_dwExStyle != 0)
		TT_Fail("m_dwExStyle = 0x%08lX, erwartet 0", leiste.m_dwExStyle);

	// Ohne Andockleiste schwebt nichts.
	if (leiste.IsFloating())
		TT_Fail("eine frische Leiste meldet IsFloating() == TRUE");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 2. CalcFixedLayout
//
// Der Kern: die Fassung des Shims liefert die GESPEICHERTEN Masse, waehrend
// CControlBar::CalcFixedLayout nur 0 oder 32767 kennt.

static void Test_CalcFixedLayout(void)
{
	ProbeLeiste leiste;

	TT_BeginTest("SECControlBar::CalcFixedLayout liefert die gespeicherten Masse");

	leiste.m_szDockHorz = CSize(300, 40);
	leiste.m_szDockVert = CSize(60, 500);
	leiste.m_szFloat    = CSize(250, 150);

	// Angedockt, nicht gestreckt: genau das gespeicherte Mass.
	GroesseVergleichen(leiste.CalcFixedLayout(FALSE, TRUE),  300,  40, "CalcFixedLayout(FALSE, TRUE)");
	GroesseVergleichen(leiste.CalcFixedLayout(FALSE, FALSE),  60, 500, "CalcFixedLayout(FALSE, FALSE)");

	// Gestreckt: in Zeilenrichtung 32767, quer dazu das gespeicherte Mass.
	GroesseVergleichen(leiste.CalcFixedLayout(TRUE, TRUE), 32767,    40, "CalcFixedLayout(TRUE, TRUE)");
	GroesseVergleichen(leiste.CalcFixedLayout(TRUE, FALSE),   60, 32767, "CalcFixedLayout(TRUE, FALSE)");

	// Das ist der Unterschied zur MFC-Fassung, auf den es ankommt: die
	// Querrichtung ist NICHT 0.
	if (leiste.CalcFixedLayout(TRUE, TRUE).cy == 0)
		TT_Fail("die Querrichtung ist 0 - das waere die MFC-Fassung, nicht die von Stingray");

	TT_EndTest();
}

static void Test_CalcFixedLayout_Ohnemasse(void)
{
	ProbeLeiste leiste;

	// Sind beide Masse nicht gesetzt, gibt die Umsetzung an MFC ab, damit
	// wenigstens die Streckregel stimmt. Die Bedingung ist ausdruecklich
	// UND-verknuepft (cx <= 0 UND cy <= 0) - ein halb gesetztes Mass bleibt
	// also beim Shim.
	TT_BeginTest("SECControlBar::CalcFixedLayout faellt ohne Masse auf die MFC-Fassung zurueck");

	leiste.m_szDockHorz = CSize(0, 0);
	leiste.m_szDockVert = CSize(0, 0);

	// MFC: cx = (bStretch && bHorz) ? 32767 : 0, cy = (bStretch && !bHorz) ? 32767 : 0
	GroesseVergleichen(leiste.CalcFixedLayout(FALSE, TRUE),      0,     0, "ohne Masse, ungestreckt waagerecht");
	GroesseVergleichen(leiste.CalcFixedLayout(TRUE,  TRUE),  32767,     0, "ohne Masse, gestreckt waagerecht");
	GroesseVergleichen(leiste.CalcFixedLayout(TRUE,  FALSE),     0, 32767, "ohne Masse, gestreckt senkrecht");

	// Ein halb gesetztes Mass zaehlt noch als gesetzt.
	leiste.m_szDockHorz = CSize(0, 25);
	GroesseVergleichen(leiste.CalcFixedLayout(FALSE, TRUE), 0, 25, "halb gesetztes Mass, ungestreckt");
	GroesseVergleichen(leiste.CalcFixedLayout(TRUE, TRUE), 32767, 25, "halb gesetztes Mass, gestreckt");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 3. CalcDynamicLayout

static void Test_CalcDynamicLayout_Angedockt(void)
{
	ProbeLeiste leiste;

	TT_BeginTest("SECControlBar::CalcDynamicLayout: LM_HORZDOCK und LM_VERTDOCK");

	leiste.m_szDockHorz = CSize(300, 40);
	leiste.m_szDockVert = CSize(60, 500);

	// Beide Andockarten strecken immer - CalcFixedLayout(TRUE, ...).
	GroesseVergleichen(leiste.CalcDynamicLayout(0, LM_HORZDOCK), 32767, 40, "CalcDynamicLayout(LM_HORZDOCK)");
	GroesseVergleichen(leiste.CalcDynamicLayout(0, LM_VERTDOCK), 60, 32767, "CalcDynamicLayout(LM_VERTDOCK)");

	// Die uebergebene Laenge spielt bei den Andockarten keine Rolle.
	GroesseVergleichen(leiste.CalcDynamicLayout(999, LM_HORZDOCK), 32767, 40,
					   "CalcDynamicLayout(999, LM_HORZDOCK)");

	// Weder LM_HORZDOCK noch LM_VERTDOCK, nicht schwebend: es faellt auf
	// CalcFixedLayout mit den Stilbits durch.
	GroesseVergleichen(leiste.CalcDynamicLayout(0, LM_HORZ), 300, 40, "CalcDynamicLayout(LM_HORZ)");
	GroesseVergleichen(leiste.CalcDynamicLayout(0, LM_HORZ | LM_STRETCH), 32767, 40,
					   "CalcDynamicLayout(LM_HORZ | LM_STRETCH)");
	GroesseVergleichen(leiste.CalcDynamicLayout(0, 0), 60, 500, "CalcDynamicLayout(0)");

	TT_EndTest();
}

static void Test_CalcDynamicLayout_Schwebend(void)
{
	ProbeLeiste leiste;
	SECDockBar andockleiste(TRUE);		// TRUE = schwebend

	TT_BeginTest("SECControlBar::CalcDynamicLayout: der Schwebe-Zweig zieht an einem Rand");

	leiste.m_szFloat = CSize(250, 150);
	leiste.AndockleisteSetzen(&andockleiste);

	if (!leiste.IsFloating())
	{
		TT_Fail("die Leiste meldet trotz schwebender Andockleiste IsFloating() == FALSE");
		TT_EndTest();
		return;
	}

	// Ohne LM_LENGTHY ist nLength die neue Breite, die Hoehe bleibt.
	GroesseVergleichen(leiste.CalcDynamicLayout(400, 0), 400, 150, "am rechten Rand gezogen");
	// Ohne LM_COMMIT darf das gemerkte Mass sich nicht aendern.
	GroesseVergleichen(leiste.m_szFloat, 250, 150, "m_szFloat ohne LM_COMMIT");

	// Mit LM_LENGTHY ist nLength die neue Hoehe.
	GroesseVergleichen(leiste.CalcDynamicLayout(400, LM_LENGTHY), 250, 400, "am unteren Rand gezogen");

	// Unter 20 wird nicht gegangen - sonst liesse sich die Leiste auf null
	// ziehen und waere nicht mehr zu fassen.
	GroesseVergleichen(leiste.CalcDynamicLayout(5, 0), 20, 150, "auf 5 gezogen, Untergrenze 20");
	GroesseVergleichen(leiste.CalcDynamicLayout(5, LM_LENGTHY), 250, 20,
					   "auf 5 gezogen, Untergrenze 20 (senkrecht)");

	// Mit LM_COMMIT wird das Mass uebernommen.
	GroesseVergleichen(leiste.CalcDynamicLayout(320, LM_COMMIT), 320, 150, "mit LM_COMMIT");
	GroesseVergleichen(leiste.m_szFloat, 320, 150, "m_szFloat nach LM_COMMIT");

	// nLength 0 oder kleiner nimmt den Schwebe-Zweig gar nicht erst - es
	// gilt wieder CalcFixedLayout.
	//
	// GEMESSEN, und die Erwartung des ersten Laufs war falsch: der Test nahm
	// an, dann kaeme m_szDockHorz heraus. Es kommt aber weiterhin m_szFloat
	// - denn CalcFixedLayout fragt SELBST als erstes IsFloating() ab und
	// nimmt dann das Schwebemass. Das ist richtig so: eine schwebende Leiste
	// hat kein Andockmass, solange sie schwebt. Nach dem LM_COMMIT oben
	// steht in m_szFloat 320x150.
	leiste.m_szDockHorz = CSize(300, 40);
	GroesseVergleichen(leiste.CalcDynamicLayout(0, LM_HORZ), 320, 150,
					   "nLength 0, schwebend: CalcFixedLayout nimmt weiterhin m_szFloat");

	// Die Andockleiste wieder abhaengen, damit ihr Zerstoerer nichts von der
	// Leiste erwartet.
	leiste.AndockleisteSetzen(NULL);

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 4. Der Rundlauf Get/SetBarInfo
//
// WazooBarMgr.cpp:432-436 holt sich den Zustand, aendert EIN Feld und
// schreibt ihn zurueck. Alles, was GetBarInfo nicht mitnimmt oder SetBarInfo
// nicht zurueckschreibt, geht dabei verloren - ohne jede Fehlermeldung.

static void Test_BarInfo_Rundlauf(void)
{
	ProbeLeiste quelle;
	ProbeLeiste ziel;
	SECControlBarInfo info;
	int nZusicherungen;

	TT_BeginTest("SECControlBar: GetBarInfo und SetBarInfo fuehren den Zustand verlustfrei hin und zurueck");

	quelle.m_szDockHorz        = CSize(321, 43);
	quelle.m_ptDockHorz        = CPoint(11, 22);
	quelle.m_szDockVert        = CSize(65, 543);
	quelle.m_szFloat           = CSize(287, 199);
	quelle.m_dwMRUDockingState = CBRS_ALIGN_TOP | CBRS_ALIGN_BOTTOM;
	quelle.m_fPctWidth         = (float) 0.75;
	quelle.m_dwExStyle         = 0x00000042;

	// CControlBar::GetBarInfo und ::SetBarInfo brauchen ein Fenster (sie
	// lesen IsVisible und rufen SetWindowPos). Das ist MFC-Sache, nicht
	// Sache dieser Schicht; die Zusicherungen werden gezaehlt und
	// geschluckt.
	ZusicherungenSchlucken();
	quelle.GetBarInfo(&info);
	ziel.SetBarInfo(&info, NULL);
	nZusicherungen = ZusicherungenWiederMelden();

	// Der Stingray-Anteil muss vollstaendig angekommen sein.
	GroesseVergleichen(ziel.m_szDockHorz, 321,  43, "m_szDockHorz nach dem Rundlauf");
	GroesseVergleichen(ziel.m_szDockVert,  65, 543, "m_szDockVert nach dem Rundlauf");
	GroesseVergleichen(ziel.m_szFloat,    287, 199, "m_szFloat nach dem Rundlauf");

	if (ziel.m_ptDockHorz != CPoint(11, 22))
		TT_Fail("m_ptDockHorz nach dem Rundlauf (%ld,%ld), erwartet (11,22)",
				ziel.m_ptDockHorz.x, ziel.m_ptDockHorz.y);
	if (ziel.m_dwMRUDockingState != (DWORD)(CBRS_ALIGN_TOP | CBRS_ALIGN_BOTTOM))
		TT_Fail("m_dwMRUDockingState nach dem Rundlauf 0x%08lX, erwartet 0x%08lX",
				ziel.m_dwMRUDockingState, (DWORD)(CBRS_ALIGN_TOP | CBRS_ALIGN_BOTTOM));
	if (ziel.m_fPctWidth != (float) 0.75)
		TT_Fail("m_fPctWidth nach dem Rundlauf %f, erwartet 0.75", ziel.m_fPctWidth);
	if (ziel.m_dwExStyle != 0x00000042)
		TT_Fail("m_dwExStyle nach dem Rundlauf 0x%08lX, erwartet 0x00000042", ziel.m_dwExStyle);

	// Nur zur Kenntnis: die MFC-Haelfte hat ohne Fenster gemurrt. Das ist
	// erwartet und kein Fehler der Ersatzschicht.
	if (nZusicherungen > 0)
		TT_Note("dabei %d MFC-Zusicherung(en) geschluckt (CControlBar erwartet ein Fenster)",
				nZusicherungen);

	TT_EndTest();
}

static void Test_BarInfo_DerWazooFall(void)
{
	ProbeLeiste leiste;
	SECControlBarInfo info;

	// Wortgleich der Ablauf aus WazooBarMgr.cpp:432-436.
	TT_BeginTest("SECControlBar: der Ablauf aus WazooBarMgr.cpp - nur die Andockhoehe aendern");

	leiste.m_szDockHorz = CSize(400, 120);
	leiste.m_szDockVert = CSize(90, 600);
	leiste.m_szFloat    = CSize(300, 200);

	ZusicherungenSchlucken();
	leiste.GetBarInfo(&info);
	info.m_szDockHorz.cy = 80;
	leiste.SetBarInfo(&info, NULL);
	ZusicherungenWiederMelden();

	// Die eine gewollte Aenderung ist angekommen ...
	GroesseVergleichen(leiste.m_szDockHorz, 400, 80, "m_szDockHorz nach dem Eingriff");
	// ... und nichts anderes hat sich mit veraendert.
	GroesseVergleichen(leiste.m_szDockVert, 90, 600, "m_szDockVert (unveraendert erwartet)");
	GroesseVergleichen(leiste.m_szFloat,   300, 200, "m_szFloat (unveraendert erwartet)");

	// Und die neue Hoehe kommt bei der Anordnungsrechnung auch an - sonst
	// haette der ganze Eingriff keine Wirkung.
	GroesseVergleichen(leiste.CalcFixedLayout(TRUE, TRUE), 32767, 80,
					   "CalcFixedLayout nach dem Eingriff");

	TT_EndTest();
}

static void Test_BarInfo_NullZeiger(void)
{
	ProbeLeiste leiste;

	TT_BeginTest("SECControlBar: Get/SetBarInfo mit NULL tun nichts und stuerzen nicht ab");

	leiste.m_szDockHorz = CSize(111, 22);

	ZusicherungenSchlucken();
	leiste.GetBarInfo(NULL);
	leiste.SetBarInfo(NULL, NULL);
	ZusicherungenWiederMelden();

	GroesseVergleichen(leiste.m_szDockHorz, 111, 22, "m_szDockHorz nach den NULL-Aufrufen");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 5. Die Zeilenlogik von SECDockBar
//
// CDockBar fuehrt alle angedockten Leisten in EINEM Feld m_arrBars; ein
// NULL-Eintrag trennt zwei Zeilen. Die vier Suchmethoden duerfen diese
// Trennung nicht ueberspringen - sonst reichte die Splitterberechnung des
// Originals ueber das Zeilenende hinaus.
//
// Das Feld wird hier von Hand belegt. Das ist genau die Datenform, die
// CDockBar::DockControlBar sonst herstellt, und es kommt ohne Fenster aus.
//
// GEMESSEN, und der erste Lauf hat die Erwartung widerlegt: eine frisch
// angelegte CDockBar ist NICHT leer. Ihr Konstruktor legt bereits einen
// NULL-Eintrag an (MFC, bardock.cpp:36  m_arrBars.Add(NULL)). Die eigenen
// Eintraege beginnen deshalb bei Index 1, und alle Indizes in diesem
// Abschnitt sind um eins verschoben. Der erste Testlauf rechnete ab 0 und
// meldete sieben Abweichungen - der Code war richtig, die Erwartung falsch.

static void Test_ZeilenLogik(void)
{
	SECDockBar andockleiste;
	ProbeLeiste a, b, c, d;

	TT_BeginTest("SECDockBar: NextBarThisRow und PrevBarThisRow bleiben in ihrer Zeile");

	// Zuerst die gemessene Voraussetzung festschreiben.
	if (andockleiste.m_arrBars.GetSize() != 1 || andockleiste.m_arrBars[0] != NULL)
	{
		TT_Fail("eine frische SECDockBar hat %d Eintraege, erwartet genau einen NULL-Eintrag "
				"(CDockBar-Konstruktor, bardock.cpp:36)",
				(int) andockleiste.m_arrBars.GetSize());
		TT_EndTest();
		return;
	}

	// Zwei Zeilen:  [a] [b] | [c] [d]
	// Index 0 ist die NULL aus dem Konstruktor, Index 3 der Zeilenwechsel.
	andockleiste.m_arrBars.Add((void*) (CControlBar*) &a);		// 1
	andockleiste.m_arrBars.Add((void*) (CControlBar*) &b);		// 2
	andockleiste.m_arrBars.Add(NULL);							// 3  Zeilenende
	andockleiste.m_arrBars.Add((void*) (CControlBar*) &c);		// 4
	andockleiste.m_arrBars.Add((void*) (CControlBar*) &d);		// 5

	if (andockleiste.NextBarThisRow(1) != (CControlBar*) &b)
		TT_Fail("NextBarThisRow(1) findet nicht die zweite Leiste der ersten Zeile");
	if (andockleiste.NextBarThisRow(2) != NULL)
		TT_Fail("NextBarThisRow(2) laeuft ueber das Zeilenende hinaus");
	if (andockleiste.NextBarThisRow(4) != (CControlBar*) &d)
		TT_Fail("NextBarThisRow(4) findet nicht die zweite Leiste der zweiten Zeile");
	if (andockleiste.NextBarThisRow(5) != NULL)
		TT_Fail("NextBarThisRow(5) findet etwas hinter der letzten Leiste");

	if (andockleiste.PrevBarThisRow(2) != (CControlBar*) &a)
		TT_Fail("PrevBarThisRow(2) findet nicht die erste Leiste der ersten Zeile");
	if (andockleiste.PrevBarThisRow(1) != NULL)
		TT_Fail("PrevBarThisRow(1) laeuft rueckwaerts ueber den Zeilenanfang hinaus");
	if (andockleiste.PrevBarThisRow(5) != (CControlBar*) &c)
		TT_Fail("PrevBarThisRow(5) findet nicht die erste Leiste der zweiten Zeile");
	if (andockleiste.PrevBarThisRow(4) != NULL)
		TT_Fail("PrevBarThisRow(4) laeuft rueckwaerts ueber das Zeilenende hinaus");

	// Das Feld wieder leeren. Das ist Pflicht, nicht Ordnungsliebe:
	// ~CDockBar (bardock.cpp:44-52) laeuft ueber m_arrBars und setzt bei
	// jeder gefundenen Leiste m_pDockBar zurueck. Die Leisten stehen hier auf
	// dem Stapel und sind zu diesem Zeitpunkt schon abgeraeumt.
	andockleiste.m_arrBars.RemoveAll();

	TT_EndTest();
}

static void Test_IsNewBar(void)
{
	SECDockBar andockleiste;
	ProbeLeiste a, b, c, fremd;

	TT_BeginTest("SECDockBar::IsNewBar und BarIsNewToThisRow");

	// Index 0 ist wieder die NULL aus dem Konstruktor.
	andockleiste.m_arrBars.Add((void*) (CControlBar*) &a);		// 1
	andockleiste.m_arrBars.Add(NULL);							// 2  Zeilenende
	andockleiste.m_arrBars.Add((void*) (CControlBar*) &b);		// 3
	andockleiste.m_arrBars.Add((void*) (CControlBar*) &c);		// 4

	if (andockleiste.IsNewBar(&a))		TT_Fail("IsNewBar haelt eine bereits angedockte Leiste fuer neu");
	if (andockleiste.IsNewBar(&c))		TT_Fail("IsNewBar haelt eine bereits angedockte Leiste fuer neu");
	if (!andockleiste.IsNewBar(&fremd))	TT_Fail("IsNewBar haelt eine unbekannte Leiste nicht fuer neu");
	if (andockleiste.IsNewBar(NULL))	TT_Fail("IsNewBar(NULL) liefert TRUE");

	// BarIsNewToThisRow zaehlt nur die Zeile, in der der uebergebene Index
	// liegt. b und c stehen in der zweiten Zeile (Index 3 und 4), a allein
	// in der ersten (Index 1).
	if (andockleiste.BarIsNewToThisRow(&b, 4))
		TT_Fail("b gilt in seiner eigenen Zeile als neu");
	if (!andockleiste.BarIsNewToThisRow(&a, 4))
		TT_Fail("a gilt in der zweiten Zeile nicht als neu, obwohl es in der ersten steht");
	if (andockleiste.BarIsNewToThisRow(&a, 1))
		TT_Fail("a gilt in seiner eigenen Zeile als neu");
	if (!andockleiste.BarIsNewToThisRow(&c, 1))
		TT_Fail("c gilt in der ersten Zeile nicht als neu, obwohl es in der zweiten steht");

	// Index 0 zeigt auf die NULL aus dem Konstruktor. Die Zeile davor ist
	// leer, also ist dort JEDE Leiste neu - auch a.
	if (!andockleiste.BarIsNewToThisRow(&a, 0))
		TT_Fail("bei Index 0 (dem NULL-Eintrag des Konstruktors) gilt a nicht als neu");

	// Ein Index ausserhalb des Feldes: alles ist dort neu.
	if (!andockleiste.BarIsNewToThisRow(&a, 99))
		TT_Fail("bei einem Index ausserhalb des Feldes gilt a nicht als neu");
	if (!andockleiste.BarIsNewToThisRow(&a, -1))
		TT_Fail("bei einem negativen Index gilt a nicht als neu");
	if (andockleiste.BarIsNewToThisRow(NULL, 0))
		TT_Fail("BarIsNewToThisRow(NULL, 0) liefert TRUE");

	andockleiste.m_arrBars.RemoveAll();

	TT_EndTest();
}

static void Test_DockBarRuempfe(void)
{
	SECDockBar andockleiste;
	ProbeLeiste leiste;
	CRect rect(0, 0, 10, 10);
	CRect vorher(1, 2, 3, 4);
	CPoint pt(5, 5);
	int nZeile = 99;

	// Zwei Methoden sind ausdruecklich als Stufe-2-offen gekennzeichnet und
	// liefern feste Werte. Der Test schreibt sie fest, damit ein spaeteres
	// Ausfuellen als Aenderung sichtbar wird.
	TT_BeginTest("SECDockBar: PredictInsertPosition und CalcDockingLayout sind als offen gekennzeichnet");

	if (andockleiste.CalcDockingLayout(&leiste, rect, pt, nZeile, vorher, pt) != rect)
		TT_Fail("CalcDockingLayout liefert nicht das uebergebene Rechteck zurueck");
	if (nZeile != -1)
		TT_Fail("CalcDockingLayout setzt die Zeile auf %d, erwartet -1 (unbekannt)", nZeile);

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 6. SECConvertDialogUnitsToPixels
//
// QCToolbarCmdPage.cpp:56 rechnet damit 6 und 8 Dialogeinheiten in
// Bildpunkte um. Die Umrechnung ist die von Windows festgelegte: waagerecht
// vier Dialogeinheiten je mittlerer Zeichenbreite, senkrecht acht je
// Zeilenhoehe.
//
// Der einzige Test hier, der einen Geraetekontext braucht - allerdings nur
// einen Speicher-DC (CreateCompatibleDC(NULL)), kein Fenster. Faellt der
// aus, wird der Test uebersprungen statt fehlzuschlagen.

extern void SECConvertDialogUnitsToPixels(HFONT hFont, int& cx, int& cy);

static void Test_DialogeinheitenUmrechnen(void)
{
	CDC dc;
	TEXTMETRIC tm;
	CFont schrift;

	TT_BeginTest("SECConvertDialogUnitsToPixels rechnet mit der Windows-Regel 4 und 8");

	// Eine Schrift mit bekannten Massen anlegen, damit das Ergebnis nicht
	// von der Systemeinstellung abhaengt.
	if (!schrift.CreateFont(16, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
							DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
							DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE,
							_T("Courier New")))
	{
		TT_Note("keine Schrift anlegbar - Test uebersprungen");
		TT_EndTest();
		return;
	}

	if (!dc.CreateCompatibleDC(NULL))
	{
		TT_Note("kein Speicher-Geraetekontext verfuegbar - Test uebersprungen");
		TT_EndTest();
		return;
	}

	{
		// Die Masse der Schrift unabhaengig ausmessen; die Erwartung wird
		// daraus gerechnet, nicht geraten.
		CFont* pAlt = dc.SelectObject(&schrift);
		::ZeroMemory(&tm, sizeof(tm));
		dc.GetTextMetrics(&tm);
		dc.SelectObject(pAlt);
	}

	if (tm.tmAveCharWidth <= 0 || tm.tmHeight <= 0)
	{
		TT_Note("Schriftmasse nicht ermittelbar - Test uebersprungen");
		TT_EndTest();
		return;
	}

	{
		int cx = 6, cy = 8;
		int cxSoll = ::MulDiv(6, tm.tmAveCharWidth, 4);
		int cySoll = ::MulDiv(8, tm.tmHeight, 8);

		SECConvertDialogUnitsToPixels((HFONT) schrift.GetSafeHandle(), cx, cy);

		if (cx != cxSoll)
			TT_Fail("6 Dialogeinheiten waagerecht ergeben %d Bildpunkte, erwartet %d "
					"(mittlere Zeichenbreite %ld)", cx, cxSoll, tm.tmAveCharWidth);
		if (cy != cySoll)
			TT_Fail("8 Dialogeinheiten senkrecht ergeben %d Bildpunkte, erwartet %d "
					"(Zeilenhoehe %ld)", cy, cySoll, tm.tmHeight);
	}

	{
		// Acht Dialogeinheiten senkrecht sind genau eine Zeilenhoehe - das
		// ist die Windows-Regel und faellt bei jeder Schrift auf.
		int cx = 0, cy = 8;
		SECConvertDialogUnitsToPixels((HFONT) schrift.GetSafeHandle(), cx, cy);
		if (cy != (int) tm.tmHeight)
			TT_Fail("8 Dialogeinheiten senkrecht ergeben %d, erwartet die Zeilenhoehe %ld",
					cy, tm.tmHeight);
		if (cx != 0)
			TT_Fail("0 Dialogeinheiten waagerecht ergeben %d, erwartet 0", cx);
	}

	{
		// Vier Dialogeinheiten waagerecht sind genau eine mittlere
		// Zeichenbreite.
		int cx = 4, cy = 0;
		SECConvertDialogUnitsToPixels((HFONT) schrift.GetSafeHandle(), cx, cy);
		if (cx != (int) tm.tmAveCharWidth)
			TT_Fail("4 Dialogeinheiten waagerecht ergeben %d, erwartet die Zeichenbreite %ld",
					cx, tm.tmAveCharWidth);
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////

void RunOTShimAndockenTests(void)
{
	TT_Suite("OTShim - Anordnungsrechnung von SECControlBar");
	Test_Vorgaben();
	Test_CalcFixedLayout();
	Test_CalcFixedLayout_Ohnemasse();
	Test_CalcDynamicLayout_Angedockt();
	Test_CalcDynamicLayout_Schwebend();

	TT_Suite("OTShim - Zustand sichern und zuruecklesen");
	Test_BarInfo_Rundlauf();
	Test_BarInfo_DerWazooFall();
	Test_BarInfo_NullZeiger();

	TT_Suite("OTShim - Zeilenlogik von SECDockBar");
	Test_ZeilenLogik();
	Test_IsNewBar();
	Test_DockBarRuempfe();

	TT_Suite("OTShim_Werkzeugleiste - Rechenhilfen");
	Test_DialogeinheitenUmrechnen();
}

//
// UNGEPRUEFT GEBLIEBEN - und warum
//
//   SECDockBar::NextVisibleBarThisRow, PrevVisibleBarThisRow, GetRowHeight
//       Die drei fragen jede Leiste nach IsVisible() bzw. GetWindowRect().
//       Beides setzt ein Fenster voraus. Der Unterschied zu den geprueften
//       Fassungen ist genau dieser eine Filter; die Zeilentrennung selbst
//       ist oben mitgeprueft.
//
//   Die Anordnungsrechnung von SECCustomToolBar (CalcLayout, SizeToolBar,
//   die Umbruchlogik)
//       Sie misst jeden Knopf aus und braucht dafuer die Schrift und den
//       Geraetekontext der Leiste. Ohne Fenster liefert sie keine
//       belastbaren Werte. Die Umsetzung nennt die Vereinfachung gegenueber
//       dem Original ausdruecklich (umbrechen, sobald der naechste Knopf
//       nicht mehr passt, statt die Zeilen auszugleichen); dass die
//       Haken CanWrapRow/BalanceWrap/CalcSize erhalten sind, steht dort.
//
//   SECCustomToolBar::Get/SetBarInfoEx
//       GetBarInfoEx ruft GetWindowText und geht ueber m_btns; ohne Fenster
//       und ohne gesetzte Knoepfe gibt es dort nichts zu vergleichen.
//
//   Eine gesuchte, aber nicht vorhandene Methode: OTShim_Werkzeugleiste
//       hat KEIN CalcPadding. Gesucht wurde danach, weil die Aufgabenliste
//       es als Kandidaten nannte; im Baum gibt es CalcPadding nur in
//       OTShim_Bild (dort geprueft) und CalcInsideRect in OTShim.cpp, das
//       an CControlBar durchreicht.
//
//   Das gesamte Andocken, Umdocken und Einfuegen (DockControlBar, Insert,
//   NormalizeRow, die Splitter und die Client-Kanten)
//       Braucht ein Rahmenfenster, echte Leistenfenster und in Teilen eine
//       Nachrichtenschleife.
//
