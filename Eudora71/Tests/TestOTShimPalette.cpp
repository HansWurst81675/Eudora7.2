//
// TestOTShimPalette.cpp - prueft SECDateTimeCtrl aus OTShim_Palette
//
// SECDateTimeCtrl ersetzt Stingrays selbst gebautes Datum-/Zeitfeld durch das
// gemeine Steuerelement SysDateTimePick32 (MFC: CDateTimeCtrl). Alles, was
// das Original in eigenen Bausteinen gefuehrt hat, liegt jetzt in Feldern der
// Klasse - und genau diese Felder sind ohne Fenster pruefbar.
//
// DER WICHTIGSTE FALL: der Autor puffert die Formatzeichenkette, weil
// SetFormat VOR der Fenstererzeugung gerufen wird. Die Aufrufstelle steht in
// SearchView.cpp:1565/1566 - erst SetFormat, dann AttachDateTimeCtrl. Ohne
// den Puffer ginge das Format verloren, und das Suchfenster zeigte das
// falsche Datumsformat. Dass der Puffer greift, laesst sich ohne Fenster
// pruefen: SetFormat muss die Zeichenkette merken, GetFormat sie
// zurueckgeben, und ApplyFormat muss ohne Fenster folgenlos bleiben.
//
// WAS HIER NICHT GEPRUEFT WIRD und warum, steht am Ende der Datei.
//
#include <afxwin.h>
#include <stdio.h>

#include "TinyTest.h"
#include "OTShim_Palette.h"


// Vergleicht eine CString-Ausgabe mit einer erwarteten Zeichenkette.
static void ZeichenketteVergleichen(const CString& strIst, const char* szSoll, const char* szWas)
{
	if (strcmp((LPCTSTR) strIst, szSoll) != 0)
		TT_Fail("%s ist \"%s\", erwartet \"%s\"", szWas, (LPCTSTR) strIst, szSoll);
}


/////////////////////////////////////////////////////////////////////////////
// 1. Vorgabewerte

static void Test_Vorgaben(void)
{
	SECDateTimeCtrl ctrl;
	SECDateTimeCtrl::FormatType art = SECDateTimeCtrl::LongDate;
	CString strFormat;
	COleDateTime dtMin, dtMax;

	TT_BeginTest("SECDateTimeCtrl: Vorgabewerte eines frisch angelegten Feldes");

	ctrl.GetFormat(art);
	if (art != SECDateTimeCtrl::ShortDate)
		TT_Fail("Formatart ist %d, erwartet ShortDate (%d)", (int) art, (int) SECDateTimeCtrl::ShortDate);

	ctrl.GetFormat(strFormat);
	if (!strFormat.IsEmpty())
		TT_Fail("die eigene Formatzeichenkette ist \"%s\", erwartet leer", (LPCTSTR) strFormat);

	if (ctrl.GetMinMax(dtMin, dtMax) != SECDateTimeCtrl::NoValidation)
		TT_Fail("die Pruefart ist nicht NoValidation");
	if (dtMin.GetStatus() != COleDateTime::null)
		TT_Fail("der untere Rand des Pruefbereichs ist belegt, erwartet leer");
	if (dtMax.GetStatus() != COleDateTime::null)
		TT_Fail("der obere Rand des Pruefbereichs ist belegt, erwartet leer");

	if (ctrl.IsModified())			TT_Fail("ein frisches Feld gilt als geaendert");
	if (!ctrl.IsFastEntryEnabled())	TT_Fail("die Schnelleingabe ist aus, erwartet an");
	if (ctrl.GetNoEdit() != 0)		TT_Fail("GetNoEdit = %d, erwartet 0", ctrl.GetNoEdit());
	if (ctrl.GetNullChar() != _T('_'))
		TT_Fail("das Fuellzeichen ist '%c', erwartet '_'", ctrl.GetNullChar());
	if (ctrl.IsEditing())			TT_Fail("IsEditing liefert TRUE (das Feld kennt diesen Zustand nicht mehr)");

	// Ein frisches Feld traegt die aktuelle Zeit. Der genaue Wert ist nicht
	// pruefbar, wohl aber, dass es ueberhaupt ein gueltiger Wert ist.
	if (ctrl.GetDateTime().GetStatus() != COleDateTime::valid)
		TT_Fail("der Anfangswert ist kein gueltiges Datum");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 2. Die gepufferte Formatzeichenkette
//
// Der Kern dieser Klasse. SearchView.cpp ruft
//     m_DateCtrl.SetFormat(...);              // Zeile 1565 - noch kein Fenster
//     m_DateCtrl.AttachDateTimeCtrl(...);     // Zeile 1566 - jetzt entsteht es
// Waere die Zeichenkette nicht gemerkt, koennte AttachDateTimeCtrl sie nicht
// nachtragen.

static void Test_FormatGemerkt(void)
{
	SECDateTimeCtrl ctrl;
	SECDateTimeCtrl::FormatType art = SECDateTimeCtrl::ShortDate;
	CString strFormat;

	TT_BeginTest("SECDateTimeCtrl::SetFormat merkt die Zeichenkette auch ohne Fenster");

	// Ohne Fenster darf der Aufruf nicht scheitern und nicht abstuerzen -
	// ApplyFormat prueft ::IsWindow und kehrt zurueck.
	ctrl.SetFormat(_T("yyyy'-'MM'-'dd"));

	ctrl.GetFormat(art);
	if (art != SECDateTimeCtrl::Custom)
		TT_Fail("die Formatart ist %d, erwartet Custom (%d)", (int) art, (int) SECDateTimeCtrl::Custom);

	ctrl.GetFormat(strFormat);
	ZeichenketteVergleichen(strFormat, "yyyy'-'MM'-'dd", "die gemerkte Formatzeichenkette");

	// Ein zweites Setzen ueberschreibt.
	ctrl.SetFormat(_T("dd'.'MM'.'yyyy"));
	ctrl.GetFormat(strFormat);
	ZeichenketteVergleichen(strFormat, "dd'.'MM'.'yyyy", "die zweite Formatzeichenkette");

	// NULL bedeutet: leere Zeichenkette, Art bleibt Custom.
	ctrl.SetFormat((LPCTSTR) NULL);
	ctrl.GetFormat(strFormat);
	if (!strFormat.IsEmpty())
		TT_Fail("nach SetFormat(NULL) ist die Zeichenkette \"%s\", erwartet leer",
				(LPCTSTR) strFormat);
	ctrl.GetFormat(art);
	if (art != SECDateTimeCtrl::Custom)
		TT_Fail("nach SetFormat(NULL) ist die Formatart %d, erwartet Custom", (int) art);

	TT_EndTest();
}

static void Test_FormatArten(void)
{
	SECDateTimeCtrl ctrl;
	SECDateTimeCtrl::FormatType art = SECDateTimeCtrl::Custom;
	CString strFormat;

	TT_BeginTest("SECDateTimeCtrl::SetFormat: die vier Formatarten und ihre Zeichenketten");

	// Time und LongDate setzen eine feste Zeichenkette. Die Werte sind aus
	// der Umsetzung abgelesen, nicht erfunden - sie stehen dort woertlich.
	ctrl.SetFormat(SECDateTimeCtrl::Time);
	ctrl.GetFormat(art);
	if (art != SECDateTimeCtrl::Time)	TT_Fail("Formatart nach SetFormat(Time) ist %d", (int) art);
	ctrl.GetFormat(strFormat);
	ZeichenketteVergleichen(strFormat, "HH':'mm':'ss", "die Zeichenkette fuer Time");

	ctrl.SetFormat(SECDateTimeCtrl::LongDate);
	ctrl.GetFormat(art);
	if (art != SECDateTimeCtrl::LongDate)	TT_Fail("Formatart nach SetFormat(LongDate) ist %d", (int) art);
	ctrl.GetFormat(strFormat);
	ZeichenketteVergleichen(strFormat, "dddd',' MMMM dd',' yyyy", "die Zeichenkette fuer LongDate");

	// ShortDate loescht die eigene Zeichenkette - dann bestimmt das Stilbit
	// des Steuerelements die Anzeige (DTS_SHORTDATEFORMAT).
	ctrl.SetFormat(SECDateTimeCtrl::ShortDate);
	ctrl.GetFormat(art);
	if (art != SECDateTimeCtrl::ShortDate)	TT_Fail("Formatart nach SetFormat(ShortDate) ist %d", (int) art);
	ctrl.GetFormat(strFormat);
	if (!strFormat.IsEmpty())
		TT_Fail("ShortDate hat die Zeichenkette \"%s\" stehen lassen, erwartet leer",
				(LPCTSTR) strFormat);

	// Custom laesst die vorhandene Zeichenkette ausdruecklich stehen: sie
	// wurde ueber die andere Ueberladung gesetzt.
	ctrl.SetFormat(_T("HH':'mm"));
	ctrl.SetFormat(SECDateTimeCtrl::Custom);
	ctrl.GetFormat(strFormat);
	ZeichenketteVergleichen(strFormat, "HH':'mm", "die Zeichenkette nach SetFormat(Custom)");
	ctrl.GetFormat(art);
	if (art != SECDateTimeCtrl::Custom)	TT_Fail("Formatart nach SetFormat(Custom) ist %d", (int) art);

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 3. Pruefbereich und Validate

static void Test_MinMax(void)
{
	SECDateTimeCtrl ctrl;
	COleDateTime dtVon(2020, 1, 1, 0, 0, 0);
	COleDateTime dtBis(2020, 12, 31, 23, 59, 59);
	COleDateTime dtRaus, dtRein;

	TT_BeginTest("SECDateTimeCtrl::SetMinMax und GetMinMax: Rundlauf");

	if (!ctrl.SetMinMax(dtVon, dtBis, SECDateTimeCtrl::DateValidation))
		TT_Fail("SetMinMax liefert FALSE");

	if (ctrl.GetMinMax(dtRaus, dtRein) != SECDateTimeCtrl::DateValidation)
		TT_Fail("GetMinMax liefert die falsche Pruefart");
	if (dtRaus != dtVon)	TT_Fail("der untere Rand kam nicht unveraendert zurueck");
	if (dtRein != dtBis)	TT_Fail("der obere Rand kam nicht unveraendert zurueck");

	// Ein verdrehter Bereich wird abgewiesen und aendert nichts.
	if (ctrl.SetMinMax(dtBis, dtVon))
		TT_Fail("SetMinMax nimmt einen Bereich an, dessen Anfang hinter dem Ende liegt");
	ctrl.GetMinMax(dtRaus, dtRein);
	if (dtRaus != dtVon || dtRein != dtBis)
		TT_Fail("der abgewiesene Aufruf hat den Bereich trotzdem veraendert");

	TT_EndTest();
}

static void Test_Validate(void)
{
	SECDateTimeCtrl ctrl;
	COleDateTime dtVon(2020, 1, 1, 0, 0, 0);
	COleDateTime dtBis(2020, 12, 31, 23, 59, 59);
	COleDateTime dtDrin(2020, 6, 15, 12, 0, 0);
	COleDateTime dtDavor(2019, 6, 15, 12, 0, 0);
	COleDateTime dtDanach(2021, 6, 15, 12, 0, 0);
	COleDateTime dtUngueltig;

	TT_BeginTest("SECDateTimeCtrl::Validate prueft nur, wenn eine Pruefart gesetzt ist");

	dtUngueltig.SetStatus(COleDateTime::invalid);

	// Ohne Pruefart geht alles durch - auch ein ungueltiger Wert.
	if (!ctrl.Validate(dtDavor))		TT_Fail("ohne Pruefart wird ein Wert abgewiesen");
	if (!ctrl.Validate(dtUngueltig))	TT_Fail("ohne Pruefart wird ein ungueltiger Wert abgewiesen");

	ctrl.SetMinMax(dtVon, dtBis, SECDateTimeCtrl::DateTimeValidation);

	if (!ctrl.Validate(dtDrin))		TT_Fail("ein Wert im Bereich wird abgewiesen");
	if (!ctrl.Validate(dtVon))		TT_Fail("der untere Rand selbst wird abgewiesen");
	if (!ctrl.Validate(dtBis))		TT_Fail("der obere Rand selbst wird abgewiesen");
	if (ctrl.Validate(dtDavor))		TT_Fail("ein Wert vor dem Bereich wird angenommen");
	if (ctrl.Validate(dtDanach))	TT_Fail("ein Wert hinter dem Bereich wird angenommen");
	if (ctrl.Validate(dtUngueltig))	TT_Fail("ein ungueltiger Wert wird angenommen");

	TT_EndTest();
}

static void Test_SetDateTime(void)
{
	SECDateTimeCtrl ctrl;
	COleDateTime dtVon(2020, 1, 1, 0, 0, 0);
	COleDateTime dtBis(2020, 12, 31, 23, 59, 59);
	COleDateTime dtDrin(2020, 6, 15, 12, 30, 45);
	COleDateTime dtDraussen(2021, 6, 15, 12, 0, 0);

	TT_BeginTest("SECDateTimeCtrl::SetDateTime nimmt nur an, was Validate durchlaesst");

	ctrl.SetMinMax(dtVon, dtBis, SECDateTimeCtrl::DateTimeValidation);

	if (!ctrl.SetDateTime(dtDrin))
		TT_Fail("ein Wert im Bereich wird abgewiesen");
	if (ctrl.GetDateTime() != dtDrin)
		TT_Fail("der gesetzte Wert kam nicht zurueck");

	if (ctrl.SetDateTime(dtDraussen))
		TT_Fail("ein Wert ausserhalb des Bereichs wird angenommen");
	if (ctrl.GetDateTime() != dtDrin)
		TT_Fail("der abgewiesene Wert wurde trotzdem uebernommen");

	TT_EndTest();
}

static void Test_SetDateUndSetTime(void)
{
	SECDateTimeCtrl ctrl;
	COleDateTime dtAusgang(2020, 6, 15, 12, 30, 45);
	COleDateTime dtNeuesDatum(1999, 12, 24, 3, 4, 5);	// die Uhrzeit darin zaehlt nicht
	COleDateTime dtNeueZeit(2050, 1, 1, 23, 59, 58);	// das Datum darin zaehlt nicht

	TT_BeginTest("SECDateTimeCtrl::SetDate und SetTime aendern nur ihre Haelfte");

	if (!ctrl.SetDateTime(dtAusgang))
	{
		TT_Fail("SetDateTime liefert FALSE");
		TT_EndTest();
		return;
	}

	if (!ctrl.SetDate(dtNeuesDatum))
		TT_Fail("SetDate liefert FALSE");
	{
		COleDateTime dt = ctrl.GetDateTime();
		if (dt.GetYear() != 1999 || dt.GetMonth() != 12 || dt.GetDay() != 24)
			TT_Fail("SetDate hat das Datum nicht uebernommen: %d-%d-%d",
					dt.GetYear(), dt.GetMonth(), dt.GetDay());
		if (dt.GetHour() != 12 || dt.GetMinute() != 30 || dt.GetSecond() != 45)
			TT_Fail("SetDate hat die Uhrzeit veraendert: %d:%d:%d",
					dt.GetHour(), dt.GetMinute(), dt.GetSecond());
	}

	if (!ctrl.SetTime(dtNeueZeit))
		TT_Fail("SetTime liefert FALSE");
	{
		COleDateTime dt = ctrl.GetDateTime();
		if (dt.GetHour() != 23 || dt.GetMinute() != 59 || dt.GetSecond() != 58)
			TT_Fail("SetTime hat die Uhrzeit nicht uebernommen: %d:%d:%d",
					dt.GetHour(), dt.GetMinute(), dt.GetSecond());
		if (dt.GetYear() != 1999 || dt.GetMonth() != 12 || dt.GetDay() != 24)
			TT_Fail("SetTime hat das Datum veraendert: %d-%d-%d",
					dt.GetYear(), dt.GetMonth(), dt.GetDay());
	}

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 4. Aenderungsmerker

static void Test_Aenderungsmerker(void)
{
	SECDateTimeCtrl ctrl;
	BOOL bDatum = FALSE, bZeit = FALSE;

	TT_BeginTest("SECDateTimeCtrl::SetModified/IsModified: beide Haelften einzeln");

	ctrl.SetModified(TRUE);
	if (!ctrl.IsModified())	TT_Fail("nach SetModified(TRUE) meldet IsModified FALSE");
	ctrl.IsModified(bDatum, bZeit);
	if (!bDatum || !bZeit)	TT_Fail("SetModified(TRUE) hat nicht beide Haelften gesetzt");

	ctrl.SetModified(FALSE);
	if (ctrl.IsModified())	TT_Fail("nach SetModified(FALSE) meldet IsModified TRUE");
	ctrl.IsModified(bDatum, bZeit);
	if (bDatum || bZeit)	TT_Fail("SetModified(FALSE) hat nicht beide Haelften geloescht");

	// Die zweistellige Fassung setzt Datum und Zeit getrennt.
	ctrl.SetModified(TRUE, FALSE);
	ctrl.IsModified(bDatum, bZeit);
	if (!bDatum)			TT_Fail("SetModified(TRUE, FALSE): der Datumsmerker ist nicht gesetzt");
	if (bZeit)				TT_Fail("SetModified(TRUE, FALSE): der Zeitmerker ist gesetzt");
	if (!ctrl.IsModified())	TT_Fail("eine gesetzte Haelfte genuegt IsModified nicht");

	ctrl.SetModified(FALSE, TRUE);
	ctrl.IsModified(bDatum, bZeit);
	if (bDatum)				TT_Fail("SetModified(FALSE, TRUE): der Datumsmerker ist gesetzt");
	if (!bZeit)				TT_Fail("SetModified(FALSE, TRUE): der Zeitmerker ist nicht gesetzt");

	TT_EndTest();
}

static void Test_MerkerOhneWirkung(void)
{
	SECDateTimeCtrl ctrl;

	// Diese drei fuehrt die Schicht nur noch mit, ohne dass sie wirken - das
	// gemeine Steuerelement kennt die Eigenheiten des selbst gebauten Feldes
	// nicht. Sie muessen aber sauber hin und zurueck gehen; Eudora ruft
	// keine davon.
	TT_BeginTest("SECDateTimeCtrl: Schnelleingabe, gesperrte Felder und Fuellzeichen gehen hin und zurueck");

	ctrl.EnableFastEntry(FALSE);
	if (ctrl.IsFastEntryEnabled())	TT_Fail("EnableFastEntry(FALSE) hat nicht gewirkt");
	ctrl.EnableFastEntry(TRUE);
	if (!ctrl.IsFastEntryEnabled())	TT_Fail("EnableFastEntry(TRUE) hat nicht gewirkt");

	ctrl.SetNoEdit(SECDateTimeCtrl::FixedDate);
	if (ctrl.GetNoEdit() != SECDateTimeCtrl::FixedDate)
		TT_Fail("GetNoEdit = %d, erwartet FixedDate (%d)",
				ctrl.GetNoEdit(), (int) SECDateTimeCtrl::FixedDate);

	// FixedDate ist die Summe der drei Datumsbits.
	if (SECDateTimeCtrl::FixedDate !=
		(SECDateTimeCtrl::FixedYear | SECDateTimeCtrl::FixedMonth | SECDateTimeCtrl::FixedDay))
		TT_Fail("FixedDate ist nicht die Summe aus FixedYear, FixedMonth und FixedDay");

	// FixedTime ist es NICHT - und das ist Absicht dieser Schicht.
	//
	// GEMESSEN: der erste Lauf dieses Tests erwartete die Summe aus
	// FixedHour, FixedMinute und FixedSecond (0x0038) und schlug fehl.
	// Nachgesehen in OT501/Include/DTCtrl.h:114-118: dort steht
	//     FixedHour   = 0x0008
	//     FixedMinute = 0x0010
	//     FixedSecond = 0x0020
	//     FixedTime   = 0x0030      // The time is non-editable
	// FixedTime laesst die Stunde also aus. Das ist ein Fehler im
	// Stingray-Original, nicht in der Ersatzschicht - die hat den Wert
	// woertlich uebernommen, und genau das ist hier richtig: die Konstante
	// gehoert zur Schnittstelle, ein "verbesserter" Wert wuerde
	// abweichendes Verhalten erzeugen. Eudora wertet SetNoEdit ohnehin
	// nirgends aus.
	//
	// Der Test schreibt den uebernommenen Wert fest, damit ein spaeteres
	// Geradeziehen als Aenderung sichtbar wird.
	if (SECDateTimeCtrl::FixedTime != 0x0030)
		TT_Fail("FixedTime = 0x%04X, erwartet 0x0030 (woertlich aus DTCtrl.h:118)",
				(int) SECDateTimeCtrl::FixedTime);
	if ((SECDateTimeCtrl::FixedTime & SECDateTimeCtrl::FixedHour) != 0)
		TT_Fail("FixedTime enthaelt FixedHour - das Original tut das nicht");

	ctrl.SetNull(_T('#'));
	if (ctrl.GetNullChar() != _T('#'))
		TT_Fail("das Fuellzeichen ist '%c', erwartet '#'", ctrl.GetNullChar());

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 5. Die freien Hilfsfunktionen aus DTCtrl.h
//
// SECTmFromOleDate und SECSetOleDateTime ruft Eudora nirgends auf; sie sind
// trotzdem echt umgesetzt, weil ein Rumpf hier stillschweigend falsche Werte
// liefern wuerde. Genau das laesst sich hier nachrechnen.

static void Test_SECSetOleDateTime(void)
{
	COleDateTime dt;

	TT_BeginTest("SECSetOleDateTime setzt den Wert und meldet Fehler");

	if (!SECSetOleDateTime(dt, 2020, 6, 15, 12, 30, 45))
		TT_Fail("ein gueltiges Datum wird abgewiesen");
	if (dt.GetYear() != 2020 || dt.GetMonth() != 6 || dt.GetDay() != 15 ||
		dt.GetHour() != 12 || dt.GetMinute() != 30 || dt.GetSecond() != 45)
		TT_Fail("der gesetzte Wert stimmt nicht: %d-%02d-%02d %02d:%02d:%02d",
				dt.GetYear(), dt.GetMonth(), dt.GetDay(),
				dt.GetHour(), dt.GetMinute(), dt.GetSecond());

	// Der 30. Februar gibt es nicht.
	if (SECSetOleDateTime(dt, 2020, 2, 30, 0, 0, 0))
		TT_Fail("der 30. Februar wird angenommen");

	// Ein Schalttag dagegen schon.
	if (!SECSetOleDateTime(dt, 2020, 2, 29, 0, 0, 0))
		TT_Fail("der 29. Februar 2020 wird abgewiesen");
	// 2100 ist kein Schaltjahr (durch 100 teilbar, nicht durch 400).
	if (SECSetOleDateTime(dt, 2100, 2, 29, 0, 0, 0))
		TT_Fail("der 29. Februar 2100 wird angenommen");

	if (SECSetOleDateTime(dt, 2020, 13, 1, 0, 0, 0))
		TT_Fail("der 13. Monat wird angenommen");
	if (SECSetOleDateTime(dt, 2020, 1, 1, 24, 0, 0))
		TT_Fail("die Stunde 24 wird angenommen");

	TT_EndTest();
}

static void Test_SECTmFromOleDate(void)
{
	COleDateTime dt(2020, 6, 15, 12, 30, 45);	// ein Montag
	struct tm zeit;

	TT_BeginTest("SECTmFromOleDate rechnet in die Felder von struct tm um");

	::memset(&zeit, 0xCC, sizeof(zeit));		// vorher mit Muell fuellen

	if (!SECTmFromOleDate(dt.m_dt, zeit))
	{
		TT_Fail("SECTmFromOleDate liefert FALSE");
		TT_EndTest();
		return;
	}

	// struct tm zaehlt Monate ab 0 und Jahre ab 1900 - das ist die eine
	// Stelle, an der ein Rumpf oder ein Vorzeichenfehler wirklich wehtaete.
	if (zeit.tm_year != 120)	TT_Fail("tm_year = %d, erwartet 120 (2020 - 1900)", zeit.tm_year);
	if (zeit.tm_mon != 5)		TT_Fail("tm_mon = %d, erwartet 5 (Juni, ab 0 gezaehlt)", zeit.tm_mon);
	if (zeit.tm_mday != 15)		TT_Fail("tm_mday = %d, erwartet 15", zeit.tm_mday);
	if (zeit.tm_hour != 12)		TT_Fail("tm_hour = %d, erwartet 12", zeit.tm_hour);
	if (zeit.tm_min != 30)		TT_Fail("tm_min = %d, erwartet 30", zeit.tm_min);
	if (zeit.tm_sec != 45)		TT_Fail("tm_sec = %d, erwartet 45", zeit.tm_sec);

	// Der 15.06.2020 war ein Montag; struct tm zaehlt den Sonntag als 0.
	if (zeit.tm_wday != 1)		TT_Fail("tm_wday = %d, erwartet 1 (Montag)", zeit.tm_wday);

	// Diese beiden setzt die Umsetzung ausdruecklich fest.
	if (zeit.tm_yday != 0)		TT_Fail("tm_yday = %d, erwartet 0 (wird nicht bestimmt)", zeit.tm_yday);
	if (zeit.tm_isdst != -1)	TT_Fail("tm_isdst = %d, erwartet -1 (unbekannt)", zeit.tm_isdst);

	// Ein Wert ausserhalb dessen, was die Umrechnung annimmt, muss FALSE
	// melden und darf nicht abstuerzen.
	if (SECTmFromOleDate(1.0e9, zeit))
		TT_Fail("ein unmoegliches Datum wird angenommen");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////
// 6. Ohne Fenster folgenlos
//
// Jede dieser Methoden fasst im Betrieb das Fenster an. Ohne Fenster muessen
// sie stillschweigend nichts tun - sonst waere schon der Aufbau des
// Suchfensters ein Absturz, weil SetFormat vor AttachDateTimeCtrl kommt.

static void Test_OhneFensterFolgenlos(void)
{
	SECDateTimeCtrl ctrl;
	CString strFormat;

	TT_BeginTest("SECDateTimeCtrl: die fensterbezogenen Wege sind ohne Fenster folgenlos");

	ctrl.SetFormat(_T("yyyy"));
	ctrl.SizeToContent();
	ctrl.InvalidateGadget((SECDTGadget*) NULL);
	ctrl.InvalidateGadget(0);
	ctrl.BringIntoView((SECDTGadget*) NULL);
	ctrl.BringIntoView(0);

	if (ctrl.GadgetFromPoint(CPoint(5, 5)) != -1)
		TT_Fail("GadgetFromPoint liefert %d, erwartet -1 (es gibt keine Bausteine mehr)",
				ctrl.GadgetFromPoint(CPoint(5, 5)));

	// AttachDateTimeCtrl ohne Elternfenster muss FALSE melden, nicht
	// versuchen, ein Fenster anzulegen.
	if (ctrl.AttachDateTimeCtrl(1234, NULL, 0))
		TT_Fail("AttachDateTimeCtrl(..., NULL, ...) liefert TRUE");

	// Nichts davon darf die gemerkte Formatzeichenkette angetastet haben.
	ctrl.GetFormat(strFormat);
	ZeichenketteVergleichen(strFormat, "yyyy", "die Formatzeichenkette danach");

	TT_EndTest();
}


/////////////////////////////////////////////////////////////////////////////

void RunOTShimPaletteTests(void)
{
	TT_Suite("OTShim_Palette - SECDateTimeCtrl");
	Test_Vorgaben();
	Test_FormatGemerkt();
	Test_FormatArten();
	Test_MinMax();
	Test_Validate();
	Test_SetDateTime();
	Test_SetDateUndSetTime();
	Test_Aenderungsmerker();
	Test_MerkerOhneWirkung();
	Test_SECSetOleDateTime();
	Test_SECTmFromOleDate();
	Test_OhneFensterFolgenlos();
}

//
// UNGEPRUEFT GEBLIEBEN - und warum
//
//   Create, CreateEx und AttachDateTimeCtrl mit einem echten Elternfenster
//       Das ist der Weg, den SearchView.cpp:1557-1566 wirklich nimmt, und
//       damit der einzige belegte Aufruf dieser Klasse. Er legt ein
//       SysDateTimePick32 an, sucht den Platzhalter ueber GetDlgItem und
//       zerstoert ihn - alles ohne Fenster nicht nachstellbar. Geprueft ist
//       nur, dass die Vorbereitung dafuer (die gepufferte
//       Formatzeichenkette) sitzt, und dass der Aufruf ohne Elternfenster
//       sauber FALSE meldet.
//
//   ApplyFormat gegen ein echtes Steuerelement
//       Ob DTM_SETFORMAT die Zeichenkette wirklich annimmt, sagt erst ein
//       angelegtes Fenster. Hier ist nur geprueft, dass die Zeichenkette bis
//       dahin erhalten bleibt.
//
//   SizeToContent (DTM_GETIDEALSIZE) und OnChanged/OnDateTimeChange
//       Brauchen ein Fenster bzw. eine Benachrichtigung des Steuerelements.
//       OnChanged faellt ausserdem unter denselben Befund wie P-1 in
//       BEFUNDE.md: es ruft GetParent(), ohne vorher das eigene Fenster zu
//       pruefen. Erreichbar ist es allerdings nur aus OnDateTimeChange
//       heraus, also stets mit Fenster - deshalb hier kein roter Test.
//
