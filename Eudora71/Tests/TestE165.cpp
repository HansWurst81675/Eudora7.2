//
// TestE165.cpp - Regressionstest zu E-165
//
// E-165: die Vervollstaendigungsbox im To:-Feld war falsch bemessen. InitList
//        rechnete die Hoehe aus der SYSTEMschrift (CClientDC ohne die Schrift
//        der Liste) und einem pauschalen Rand; die Spaltenbreite zog eine feste
//        Bildlaufleiste von 17 Pixeln ab. Gemessen am 31.10.2026 mit zwei
//        Treffern: Box 100x40, eine Zeile passt hinein, senkrechte
//        Bildlaufleiste. Nach der Behebung 100x43, zwei Zeilen, keine Leiste.
//
// Die Box haengt an Fenstern - der Pruefstand liest die STELLE.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E165(const char* szEudoraDir)
{
	TT_BeginTest("E-165 (Quelltext): die Vervollstaendigungsbox misst Zeile und Rahmen, die Spalte die Systembreite der Bildlaufleiste");
	char* pText = QT_LiesNurCode(szEudoraDir, "AutoCompleteSearcher.cpp");
	if (!pText)
	{
		TT_Fail("AutoCompleteSearcher.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	// Beide Wege (Kurznamen und Verzeichnisdienst) rechnen ueber die Hilfsfunktion.
	TT_CHECK_MSG(QT_Zaehle(pText, "rct.bottom = rct.top + E165BoxHoehe(m_AutoCompList);") == 2, "InitList oder InitListDSDropDown rechnet die Hoehe nicht mehr ueber E165BoxHoehe (E-165)");
	TT_CHECK_MSG(QT_Zaehle(pText, "* (cyChar - 1) + 10") == 0, "die alte Hoehenrechnung aus der Systemschrift steht wieder da (E-165)");

	char* pFn = QT_Abschnitt(pText, "static int E165BoxHoehe(DropDownListBox* pBox)", "return nHoehe; }");
	TT_CHECK_MSG(pFn != NULL, "E165BoxHoehe nicht gefunden (E-165)");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "pListe->GetItemRect( 0, rZeile, LVIR_BOUNDS )"), "die Zeilenhoehe kommt nicht mehr aus der Liste selbst (E-165)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "dc.SelectObject( pListe->GetFont() )"), "der Rueckfall misst wieder ohne die Schrift der Liste (E-165)");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "rBoxAussen.Height() - rBoxInnen.Height()"), "der Rahmen der Box zaehlt nicht mehr mit (E-165)");
		free(pFn);
	}

	char* pMw = QT_Abschnitt(pText, "void DropDownListBox::MoveWindow(CRect rect)", "m_ListCtrl->SetColumn(0, &Column); }");
	TT_CHECK_MSG(pMw != NULL, "DropDownListBox::MoveWindow nicht gefunden (E-165)");
	if (pMw)
	{
		TT_CHECK_MSG(QT_Enthaelt(pMw, "::GetSystemMetrics(SM_CXVSCROLL)"), "die Spaltenbreite zieht nicht die Systembreite der Bildlaufleiste ab (E-165)");
		TT_CHECK_MSG(!QT_Enthaelt(pMw, "- 18;"), "die feste Bildlaufleiste von 17 Pixeln steht wieder da (E-165)");
		free(pMw);
	}
	free(pText);
	TT_EndTest();
}

void RunE165Tests(const char* szEudoraDir)
{
	Test_E165(szEudoraDir);
}
