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
	// QCMiniDockFrameWnd, nicht die Leiste. Die erste Behebung sass nur in
	// OnMouseActivate und griff an 1.0.125 nicht (U1 FAILED). Jetzt holen
	// OnMouseActivate UND OnNcLButtonDown den Fokus ueber FokusInDieLeiste.
	TT_BeginTest("E-137: ein Klick auf Titelzeile oder Rand einer schwebenden Leiste gibt ihr den Tastaturfokus");
	char* pWb = QT_LiesNurCode(szEudoraDir, "workbook.cpp");
	char* pWbKopf = QT_LiesNurCode(szEudoraDir, "workbook.h");
	if (!pWb || !pWbKopf) { TT_Fail("workbook.cpp oder workbook.h nicht lesbar - ungeprueft ist nicht gruen"); free(pWb); free(pWbKopf); TT_EndTest(); return; }
	QT_LeerraumZusammen(pWb);
	QT_LeerraumZusammen(pWbKopf);
	char* pKlasse = QT_Abschnitt(pWbKopf, "class QCMiniDockFrameWnd : public SECMiniDockFrameWnd", "DECLARE_MESSAGE_MAP()");
	TT_CHECK_MSG(pKlasse && QT_Enthaelt(pKlasse, "afx_msg int OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest, UINT message);"),
				 "QCMiniDockFrameWnd deklariert OnMouseActivate nicht");
	TT_CHECK_MSG(pKlasse && QT_Enthaelt(pKlasse, "afx_msg void OnNcLButtonDown(UINT nHitTest, CPoint point);"),
				 "QCMiniDockFrameWnd deklariert OnNcLButtonDown nicht - ist der Rahmen schon aktiv, kaeme kein WM_MOUSEACTIVATE (PRUEFER-60 K6)");
	free(pKlasse);
	char* pMap = QT_Abschnitt(pWb, "BEGIN_MESSAGE_MAP(QCMiniDockFrameWnd, SECMiniDockFrameWnd)", "END_MESSAGE_MAP()");
	TT_CHECK_MSG(pMap && QT_Enthaelt(pMap, "ON_WM_MOUSEACTIVATE()"), "OnMouseActivate fehlt in der Message-Map von QCMiniDockFrameWnd");
	TT_CHECK_MSG(pMap && QT_Enthaelt(pMap, "ON_WM_NCLBUTTONDOWN()"), "OnNcLButtonDown fehlt in der Message-Map von QCMiniDockFrameWnd");
	free(pMap);
	char* pHilfe = QT_Abschnitt(pWb, "void QCMiniDockFrameWnd::FokusInDieLeiste(", "pWazooWnd->SetFocus(); }");
	TT_CHECK_MSG(pHilfe != NULL, "QCMiniDockFrameWnd::FokusInDieLeiste nicht gefunden");
	if (pHilfe)
	{
		const long lZone  = QT_Stelle(pHilfe, "if (nHitTest == HTCLIENT || nHitTest == HTCLOSE) return;");
		const long lSuche = QT_Stelle(pHilfe, "CWazooBar* pLeiste = DYNAMIC_DOWNCAST(CWazooBar, m_wndSECDockBar.GetFirstControlBar());");
		const long lSpur  = QT_Stelle(pHilfe, "PutDebugLog(DEBUG_MASK_MISC, strSpur);");
		const long lWenn  = QT_Stelle(pHilfe, "if (bSichtbar && !bFokusDrin && pWazooWnd && pWazooWnd->GetSafeHwnd())");
		TT_CHECK_MSG(lZone >= 0, "Klicks in die Leiste (HTCLIENT) und auf den Schliessknopf (HTCLOSE) sind nicht ausgenommen");
		TT_CHECK_MSG(lSuche > lZone, "die Leiste kommt nicht aus m_wndSECDockBar (PRUEFER-60 K1/K5)");
		TT_CHECK_MSG(lSpur > lSuche && lWenn > lSpur, "die Spur steht nicht VOR der Entscheidung - ein stiller Ausstieg waere wieder unsichtbar (U1 an 1.0.125)");
		free(pHilfe);
	}
	char* pAkt = QT_Abschnitt(pWb, "int QCMiniDockFrameWnd::OnMouseActivate(", "return nErgebnis; }");
	TT_CHECK_MSG(pAkt && QT_Enthaelt(pAkt, "FokusInDieLeiste(nHitTest, \"MouseActivate\");"), "OnMouseActivate ruft FokusInDieLeiste nicht");
	free(pAkt);
	char* pNc = QT_Abschnitt(pWb, "void QCMiniDockFrameWnd::OnNcLButtonDown(", "SECMiniDockFrameWnd::OnNcLButtonDown(nHitTest, point); }");
	TT_CHECK_MSG(pNc != NULL, "QCMiniDockFrameWnd::OnNcLButtonDown nicht gefunden");
	if (pNc)
	{
		const long lFokus = QT_Stelle(pNc, "FokusInDieLeiste(nHitTest, \"NcLButtonDown\");");
		const long lBasis = QT_Stelle(pNc, "SECMiniDockFrameWnd::OnNcLButtonDown(nHitTest, point);");
		TT_CHECK_MSG(lFokus >= 0 && lBasis > lFokus, "der Fokus wird nicht VOR der Zieh-/Groessenschleife der Basisklasse gesetzt");
		free(pNc);
	}
	free(pWb);
	free(pWbKopf);
	TT_EndTest();
}
