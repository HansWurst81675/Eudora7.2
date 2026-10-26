//
// TestE137.cpp - Regressionstest zu Befund E-137
//
// Strg-W (ID_FILE_CLOSE) mit dem Eingabeschwerpunkt in einer ANGEDOCKTEN
// Wazoo-Leiste (Adressbuch, Filter, ...) beendete ganz Eudora. Gregor am
// 25.10.2026: angedockt beendet es Eudora, schwebend schliesst es nur die
// Leiste; gewuenscht: "sollte z.b. nur das filter fenster geschlossen werden".
//
// Der Weg (PRUEFER-56 K1): CMainFrame::OnCommand gibt den Befehl an das
// Wazoo-Fenster, das an sein Dokument, und CDoc::OnFileClose schickt
// WM_CLOSE an den Rahmen der Ansicht - angedockt ist das das Hauptfenster.
// Die Behebung sitzt deshalb am ANFANG von CMainFrame::OnCommand, vor jeder
// Weitergabe. Die erste Fassung sass in OnCmdMsg und wurde nie erreicht -
// ihr Test war gruen, weil er nur die falsche Funktion las.
//
// Geprueft wird der Quelltext ohne Kommentare, mit ganzen Anweisungen statt
// einzelner Woerter (PRUEFER-56 K2: "!pFokusLeiste->IsWindowVisible()"
// enthielt den gesuchten Text, ein "if (0)" vor dem Verstecken blieb gruen).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE137Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-137: Strg-W in einer Wazoo-Leiste versteckt nur die Leiste, vor jeder Weitergabe");
	char* pCode = QT_LiesNurCode(szEudoraDir, "mainfrm.cpp");
	if (!pCode) { TT_Fail("mainfrm.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	QT_LeerraumZusammen(pCode);

	char* pRumpf = QT_Abschnitt(pCode, "BOOL CMainFrame::OnCommand(", "BOOL CMainFrame::OnCmdMsg(");
	TT_CHECK_MSG(pRumpf != NULL, "CMainFrame::OnCommand nicht gefunden");
	if (pRumpf)
	{
		// Der ganze Abfangblock, als eine Folge von Anweisungen. Jede
		// Abweichung - Bedingung verneint, Zweig ausgeschaltet, Schwerpunkt
		// weggelassen, return vergessen - zerreisst die Folge.
		const char* aBlock[] =
		{
			"if (wCommandID == ID_FILE_CLOSE) {",
			"CWazooBar* pFokusLeiste = m_WazooBarMgr.GetWazooBarWithFocus();",
			"if (pFokusLeiste && pFokusLeiste->GetSafeHwnd() && pFokusLeiste->IsWindowVisible()) {",
			"PutDebugLog(DEBUG_MASK_MISC, \"E-137 Strg-W: Wazoo-Leiste wird versteckt statt Eudora zu beenden\");",
			"pFokusLeiste->PostMessage(WM_COMMAND, ID_SEC_HIDE, 0);",
			"CMDIChildWnd* pAktiv = MDIGetActive();",
			"if (pAktiv && pAktiv->IsWindowVisible()) pAktiv->SetFocus();",
			"return TRUE;",
		};
		long lPos = 0;
		bool bFolge = true;
		for (size_t k = 0; k < sizeof(aBlock) / sizeof(aBlock[0]); k++)
		{
			const long l = QT_Stelle(pRumpf + lPos, aBlock[k]);
			if (l < 0) { bFolge = false; TT_Fail("fehlt oder getrennt: %s", aBlock[k]); break; }
			// Zwischen zwei Anweisungen darf nichts anderes stehen als ein Leerzeichen.
			if (k > 0 && l > 1) { bFolge = false; TT_Fail("fehlt oder getrennt: %s", aBlock[k]); break; }
			lPos += l + (long) strlen(aBlock[k]);
		}
		TT_CHECK_MSG(bFolge, "der Abfangblock fuer Strg-W ist nicht mehr vollstaendig und zusammenhaengend (siehe die Zeile davor)");

		const long lAbfangen = QT_Stelle(pRumpf, "if (wCommandID == ID_FILE_CLOSE) {");
		const long lWeiter   = QT_Stelle(pRumpf, "CWazooWnd* pWazooWnd = GetWazooWindowWithFocus();");
		TT_CHECK_MSG(lWeiter >= 0, "die Weitergabe an das Wazoo-Fenster ist nicht zu finden");
		TT_CHECK_MSG(lAbfangen >= 0 && lAbfangen < lWeiter,
					 "Strg-W wird erst NACH der Weitergabe an das Wazoo-Fenster abgefangen - dann schliesst CDoc::OnFileClose wieder das Hauptfenster");
		free(pRumpf);
	}
	free(pCode);
	TT_EndTest();

	// Zweiter Teil (Gregor am Testpaket 7.2.0.123): ein Klick auf eine
	// Beschriftung oder leere Flaeche einer Leiste liess den Tastaturfokus in
	// der Mail, und Strg+W schloss die Mail. Die Leiste holt sich den Fokus
	// jetzt in OnMouseActivate - aber nur, wenn er noch ausserhalb liegt.
	TT_BeginTest("E-137: ein Klick irgendwo in eine Wazoo-Leiste gibt ihr den Tastaturfokus");
	char* pBar = QT_LiesNurCode(szEudoraDir, "WazooBar.cpp");
	char* pKopf = QT_LiesNurCode(szEudoraDir, "WazooBar.h");
	if (!pBar || !pKopf) { TT_Fail("WazooBar.cpp oder WazooBar.h nicht lesbar - ungeprueft ist nicht gruen"); free(pBar); free(pKopf); TT_EndTest(); return; }
	QT_LeerraumZusammen(pBar);
	QT_LeerraumZusammen(pKopf);
	TT_CHECK_MSG(QT_Enthaelt(pKopf, "afx_msg int OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest, UINT message);"),
				 "CWazooBar deklariert OnMouseActivate nicht");
	TT_CHECK_MSG(QT_Enthaelt(pBar, "ON_WM_MOUSEACTIVATE()"), "OnMouseActivate steht nicht in der Message-Map - es liefe nie");
	char* pFn = QT_Abschnitt(pBar, "int CWazooBar::OnMouseActivate(", "return nErgebnis; }");
	TT_CHECK_MSG(pFn != NULL, "CWazooBar::OnMouseActivate nicht gefunden");
	if (pFn)
	{
		const long lBasis = QT_Stelle(pFn, "SECControlBar::OnMouseActivate(pDesktopWnd, nHitTest, message);");
		const long lWenn  = QT_Stelle(pFn, "if (!pFokus || !IsChild(pFokus)) {");
		const long lSetze = QT_Stelle(pFn, "pWazooWnd->SetFocus();");
		TT_CHECK_MSG(lBasis >= 0, "die Basisklasse wird nicht mehr gerufen - das Aktivieren der Leiste fiele weg");
		TT_CHECK_MSG(lWenn >= 0 && lSetze > lWenn,
					 "der Fokus wird nicht oder nicht nur dann gesetzt, wenn er ausserhalb der Leiste liegt");
		free(pFn);
	}
	free(pBar);
	free(pKopf);
	TT_EndTest();

	// Dritter Teil (Gregor am Testpaket 7.2.0.124, T1): ein Klick auf
	// Titelzeile oder Rand des SCHWEBENDEN Fensters trifft den kleinen Rahmen
	// QCMiniDockFrameWnd, nicht die Leiste - CWazooBar::OnMouseActivate sah
	// ihn nie, und Strg+W schloss wieder die Mail. Der Rahmen holt den Fokus
	// jetzt selbst in die Leiste, fuer jede Trefferzone ausser HTCLIENT.
	TT_BeginTest("E-137: ein Klick auf Titelzeile oder Rand einer schwebenden Leiste gibt ihr den Tastaturfokus");
	char* pWb = QT_LiesNurCode(szEudoraDir, "workbook.cpp");
	char* pWbKopf = QT_LiesNurCode(szEudoraDir, "workbook.h");
	if (!pWb || !pWbKopf) { TT_Fail("workbook.cpp oder workbook.h nicht lesbar - ungeprueft ist nicht gruen"); free(pWb); free(pWbKopf); TT_EndTest(); return; }
	QT_LeerraumZusammen(pWb);
	QT_LeerraumZusammen(pWbKopf);
	char* pKlasse = QT_Abschnitt(pWbKopf, "class QCMiniDockFrameWnd : public SECMiniDockFrameWnd", "DECLARE_MESSAGE_MAP()");
	TT_CHECK_MSG(pKlasse && QT_Enthaelt(pKlasse, "afx_msg int OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest, UINT message);"),
				 "QCMiniDockFrameWnd deklariert OnMouseActivate nicht");
	free(pKlasse);
	char* pMap = QT_Abschnitt(pWb, "BEGIN_MESSAGE_MAP(QCMiniDockFrameWnd, SECMiniDockFrameWnd)", "END_MESSAGE_MAP()");
	TT_CHECK_MSG(pMap && QT_Enthaelt(pMap, "ON_WM_MOUSEACTIVATE()"),
				 "OnMouseActivate steht nicht in der Message-Map von QCMiniDockFrameWnd - es liefe nie");
	free(pMap);
	char* pRahmen = QT_Abschnitt(pWb, "int QCMiniDockFrameWnd::OnMouseActivate(", "return nErgebnis; }");
	TT_CHECK_MSG(pRahmen != NULL, "QCMiniDockFrameWnd::OnMouseActivate nicht gefunden");
	if (pRahmen)
	{
		const long lBasis = QT_Stelle(pRahmen, "SECMiniDockFrameWnd::OnMouseActivate(pDesktopWnd, nHitTest, message);");
		const long lZone  = QT_Stelle(pRahmen, "if (nHitTest != HTCLIENT && nHitTest != HTCLOSE) {");
		const long lSuche = QT_Stelle(pRahmen, "CWazooBar* pLeiste = DYNAMIC_DOWNCAST(CWazooBar, m_wndSECDockBar.GetFirstControlBar());");
		const long lWenn  = QT_Stelle(pRahmen, "if (pLeiste && pLeiste->IsWindowVisible() && (!pFokus || !pLeiste->IsChild(pFokus))) {");
		const long lSetze = QT_Stelle(pRahmen, "pWazooWnd->SetFocus();");
		TT_CHECK_MSG(lBasis >= 0, "die Basisklasse wird nicht mehr gerufen - Ziehen und Aktivieren des Rahmens fielen weg");
		TT_CHECK_MSG(lZone > lBasis, "der Rahmen behandelt nicht gezielt Titelzeile und Rand (HTCLIENT bleibt bei CWazooBar, HTCLOSE ausgenommen - PRUEFER-60 K4)");
		TT_CHECK_MSG(lSuche > lZone, "der Rahmen holt die Leiste nicht aus m_wndSECDockBar (PRUEFER-60 K1/K5: eine eigene Suche blieb im Test gruen, auch wenn sie nie traf)");
		TT_CHECK_MSG(lWenn > lSuche && lSetze > lWenn,
					 "der Fokus wird nicht oder nicht nur dann gesetzt, wenn er ausserhalb der Leiste liegt");
		free(pRahmen);
	}
	free(pWb);
	free(pWbKopf);
	TT_EndTest();
}
