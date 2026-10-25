//
// TestE137.cpp - Regressionstest zu Befund E-137
//
// Strg-W (ID_FILE_CLOSE) mit dem Eingabeschwerpunkt in einer ANGEDOCKTEN
// Wazoo-Leiste (Adressbuch, Filter, ...) beendete ganz Eudora. Gregor am
// 25.10.2026: angedockt beendet es Eudora, als eigenes Fenster schliesst es
// regulaer; gewuenscht: "sollte z.b. nur das filter fenster geschlossen
// werden".
//
// Die Behebung sitzt in CMainFrame::OnCmdMsg (mainfrm.cpp) und laesst sich
// nicht herausschneiden - geprueft wird deshalb der Quelltext ohne
// Kommentare, an den Punkten, die zusammen die Behebung ausmachen:
//   1. ID_FILE_CLOSE wird abgefangen, BEVOR der Befehl an das Wazoo-Fenster
//      oder an das aktive MDI-Fenster weitergereicht wird,
//   2. nur fuer eine Leiste, die KEIN MDI-Fenster ist (als MDI-Fenster
//      schliesst QCControlBarWorksheet::OnCmdMdiClose sie richtig),
//   3. die Leiste bekommt ID_SEC_HIDE - derselbe Weg wie Rechtsklick -> Hide,
//   4. und der Befehl gilt als erledigt (return TRUE), geht also nicht weiter.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE137Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-137: Strg-W in einer angedockten Wazoo-Leiste versteckt nur die Leiste");
	char* pCode = QT_LiesNurCode(szEudoraDir, "mainfrm.cpp");
	if (!pCode) { TT_Fail("mainfrm.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	QT_LeerraumZusammen(pCode);

	char* pRumpf = QT_Abschnitt(pCode, "BOOL CMainFrame::OnCmdMsg(", "CMDIChildWnd* pActiveChild = MDIGetActive();");
	TT_CHECK_MSG(pRumpf != NULL, "CMainFrame::OnCmdMsg nicht gefunden");
	if (pRumpf)
	{
		const long lAbfangen = QT_Stelle(pRumpf, "if (nID == ID_FILE_CLOSE");
		const long lWeiter   = QT_Stelle(pRumpf, "CWazooWnd* pWazooWnd = GetWazooWindowWithFocus();");
		const long lNurLeiste = QT_Stelle(pRumpf, "!pFokusLeiste->IsMDIChild()");
		const long lHide     = QT_Stelle(pRumpf, "pFokusLeiste->PostMessage(WM_COMMAND, ID_SEC_HIDE, 0);");

		TT_CHECK_MSG(lAbfangen >= 0, "ID_FILE_CLOSE wird in CMainFrame::OnCmdMsg nicht mehr abgefangen");
		TT_CHECK_MSG(lWeiter >= 0, "die Weitergabe an das Wazoo-Fenster ist nicht zu finden");
		TT_CHECK_MSG(lAbfangen >= 0 && lWeiter >= 0 && lAbfangen < lWeiter,
					 "ID_FILE_CLOSE wird erst NACH der Weitergabe abgefangen - dann laeuft er wieder durch");
		TT_CHECK_MSG(lNurLeiste > lAbfangen,
					 "es fehlt die Bedingung 'keine MDI-Leiste' - als MDI-Fenster schliesst OnCmdMdiClose richtig");
		TT_CHECK_MSG(lHide > lNurLeiste,
					 "die Leiste bekommt nicht ID_SEC_HIDE (der Weg von Rechtsklick -> Hide)");
		// return TRUE muss nach dem Verstecken stehen und VOR der Weitergabe
		// an das Wazoo-Fenster - sonst laeuft der Befehl dorthin weiter.
		const long lZurueck = (lHide >= 0) ? QT_Stelle(pRumpf + lHide, "return TRUE;") : -1;
		TT_CHECK_MSG(lZurueck >= 0 && lHide + lZurueck < lWeiter,
					 "nach ID_SEC_HIDE fehlt return TRUE vor der Weitergabe - der Befehl liefe weiter");
		free(pRumpf);
	}
	free(pCode);
	TT_EndTest();
}
