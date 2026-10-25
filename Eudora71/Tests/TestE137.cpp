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
}
