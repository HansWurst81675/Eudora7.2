//
// TestE239.cpp - Befund E-239: Absturz beim Beenden, wenn waehrend des
// Beendens ein zweiter Schliesswunsch kommt.
//
// CMainFrame::OnClose ruft CloseDown und danach CFrameWnd::OnClose
// (HideApplication, CloseAllDocuments - g_Nicknames wird NULL). Faehrt dabei
// ein modaler Hinweis eine eigene Botschaftsschleife (~CPOPSession ->
// NotifyMailCheckResults) und kommt darin ein zweites WM_CLOSE, lief OnClose
// erneut durch CloseDown, und g_Nicknames->CanCloseFrame stuerzte mit NULL ab
// (gemessen 05.11.2026 von MESSER, Pruefstand C:\Temp\E239, Bau 7.2.2.135:
// exit-close 3 von 3 Abstuerzen). Jetzt: ein Merker ab CloseDown == TRUE,
// jedes weitere WM_CLOSE und WM_QUERYENDSESSION wird ignoriert; CloseDown
// prueft g_Nicknames selbst.
//
// Geprueft am Quelltext; das Verhalten misst der Pruefstand (E-239p).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E239_Wiedereintritt(const char* szEudoraDir)
{
	TT_BeginTest("E-239: ein zweites WM_CLOSE waehrend des Beendens laeuft nicht erneut durch CloseDown");

	char* pT = QT_LiesNurCode(szEudoraDir, "mainfrm.cpp");
	if (!pT)
	{
		TT_Fail("mainfrm.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pC = QT_Abschnitt(pT, "void CMainFrame::OnClose()", "BOOL CMainFrame::CloseDown()");
	if (!pC)
		TT_Fail("OnClose nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		long lAbfrage = QT_Stelle(pC, "if (m_bE239BeendenLaeuft) {");
		long lCloseDown = QT_Stelle(pC, "if (!CloseDown())");
		long lSetzen = QT_Stelle(pC, "m_bE239BeendenLaeuft = TRUE;");
		long lHide = QT_Stelle(pC, "QCWorkbook::OnClose();");
		TT_CHECK_MSG(lAbfrage >= 0 && lCloseDown > lAbfrage,
					 "OnClose fragt den Merker nicht vor CloseDown ab - ein zweites WM_CLOSE laeuft erneut hinein (E-239)");
		TT_CHECK_MSG(lSetzen > lCloseDown && lHide > lSetzen,
					 "der Merker wird nicht zwischen CloseDown und CFrameWnd::OnClose gesetzt (E-239)");
		TT_CHECK_MSG(QT_Enthaelt(pC, "if (::IsWindow(m_hWnd)) {") &&
					 QT_Enthaelt(pC, "m_bE239BeendenLaeuft = FALSE;"),
					 "bleibt das Fenster stehen, sperrt der Merker jedes spaetere Beenden (E-239)");
		// Bei gesperrtem Hauptfenster (modaler Dialog offen) wird das Beenden
		// aufgeschoben und nachgeholt, statt in der Schleife des Dialogs zu
		// laufen (gemessen 05.11.2026: sonst blieb ein Prozess ohne Fenster).
		long lGesperrt = QT_Stelle(pC, "if (!IsWindowEnabled()) {");
		TT_CHECK_MSG(lGesperrt >= 0 && lCloseDown > lGesperrt,
					 "OnClose beendet auch bei offenem modalem Dialog - das Beenden laeuft in dessen Schleife (E-239)");
		char* pN = QT_Abschnitt(pT, "case E239_SCHLIESSEN_TIMER_ID:", "case E239_ZERSTOEREN_TIMER_ID:");
		TT_CHECK_MSG(pN && QT_Enthaelt(pN, "if (IsWindowEnabled()) {") && QT_Enthaelt(pN, "PostMessage(WM_CLOSE);"),
					 "das aufgeschobene Beenden wird nicht nachgeholt (E-239)");
		if (pN) free(pN);
		// Versteckt und nicht zerstoert (OLE hat DestroyWindow aufgeschoben,
		// das Fenster war beim Nachholen gesperrt): ein Zeitgeber holt es nach,
		// sonst bleibt ein Prozess ohne Fenster (gemessen 05.11.2026).
		TT_CHECK_MSG(QT_Enthaelt(pC, "SetTimer(E239_ZERSTOEREN_TIMER_ID, 500, NULL);"),
					 "nach aufgeschobenem DestroyWindow stellt OnClose keinen Zeitgeber - versteckter Prozess bleibt (E-239)");
		char* pZ = QT_Abschnitt(pT, "case E239_ZERSTOEREN_TIMER_ID:", "case E123_WARTE_TIMER_ID:");
		TT_CHECK_MSG(pZ && QT_Enthaelt(pZ, "if (IsWindowEnabled() && AfxOleCanExitApp()) {") && QT_Enthaelt(pZ, "DestroyWindow();"),
					 "OnTimer holt das aufgeschobene DestroyWindow nicht nach (E-239)");
		if (pZ) free(pZ);
		free(pC);
	}

	char* pQ = QT_Abschnitt(pT, "BOOL CMainFrame::OnQueryEndSession()", "return (QCWorkbook::OnQueryEndSession());");
	if (!pQ)
		TT_Fail("OnQueryEndSession nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		long lAbfrage = QT_Stelle(pQ, "if (m_bE239BeendenLaeuft) {");
		long lCloseDown = QT_Stelle(pQ, "if (!CloseDown())");
		TT_CHECK_MSG(lAbfrage >= 0 && lCloseDown > lAbfrage,
					 "OnQueryEndSession geht waehrend des Beendens erneut durch CloseDown (E-239)");
		free(pQ);
	}

	char* pD = QT_Abschnitt(pT, "BOOL CMainFrame::CloseDown()", "QuerySendQueuedMessages()");
	if (!pD)
		TT_Fail("CloseDown nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pD, "if (g_Nicknames && ! g_Nicknames->CanCloseFrame(NULL))") &&
					 QT_Zaehle(pD, "g_Nicknames->") == 1,
					 "CloseDown ruft g_Nicknames->CanCloseFrame ohne Pruefung auf NULL - im Release-Bau tut ASSERT nichts (E-239)");
		free(pD);
	}

	free(pT);
	TT_EndTest();
}

void RunE239Tests(const char* szEudoraDir)
{
	Test_E239_Wiedereintritt(szEudoraDir);
}
