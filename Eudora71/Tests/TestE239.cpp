//
// TestE239.cpp - Befund E-239: Absturz beim Beenden, wenn waehrend des
// Beendens ein zweiter Schliesswunsch kommt.
//
// CMainFrame::OnClose lief in der Schleife eines modalen Dialogs (Hinweis nach
// dem Abruf): CloseDown, dann CFrameWnd::OnClose (HideApplication,
// CloseAllDocuments - g_Nicknames wird NULL). Ein zweites WM_CLOSE lief
// erneut durch CloseDown und stuerzte an g_Nicknames->CanCloseFrame ab
// (gemessen 05.11.2026, Pruefstand C:\Temp\E239, Bau 7.2.2.135: exit-close 3
// von 3). Ohne zweites WM_CLOSE blieb ein Prozess ohne Fenster: MFC zerstoert
// das aufgeschobene Fenster nur, wenn es aktiviert ist (olelock.cpp).
//
// Behebung: Beenden aufschieben, solange ein modaler Dialog das Hauptfenster
// sperrt; Merker ab CloseDown == TRUE gegen jedes weitere CloseDown; Zeitgeber
// fuer ein aufgeschobenes DestroyWindow; g_Nicknames in CloseDown pruefen.
//
// PRUEFER-102 K1: die erste Fassung dieses Tests pruefte nur, WO die if-Zeilen
// stehen - sechs von sieben Gegenproben (fehlendes return, KillTimer,
// Ruecksetzen des Wartemerkers, return (TRUE), umgedrehtes IsWindowVisible)
// blieben gruen. Jetzt wird jeder Schutz als ganzer Block verlangt: fehlt oder
// kippt eine einzige wirksame Anweisung darin, wird der Test rot. Geprueft am
// Quelltext (Kommentare entfernt, Leerraum zusammengezogen); das Verhalten
// misst der Pruefstand (E-239p, "E239 URTEIL gruen").
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

// Die Bloecke, wie QT_LiesNurCode sie liefert.

// OnClose: das Beenden laeuft schon - ignorieren und ZURUECKKEHREN (G6).
static const char* s_szMerkerOnClose =
	"if (m_bE239BeendenLaeuft) { PutDebugLog(DEBUG_MASK_MISC, \"E-239 Beenden laeuft schon: weiteres Schliessen ignoriert\"); return; }";

// OnClose: modaler Dialog offen - einmal vormerken, Zeitgeber, ZURUECKKEHREN (G3, G7).
static const char* s_szAufschub =
	"if (!IsWindowEnabled()) { if (!m_bE239SchliessenWartet) { PutDebugLog(DEBUG_MASK_MISC, \"E-239 Beenden aufgeschoben: ein modaler Dialog ist offen\"); m_bE239SchliessenWartet = TRUE; SetTimer(E239_SCHLIESSEN_TIMER_ID, 500, NULL); } return; }";

// OnTimer: nachholen - Zeitgeber AUS, Wartemerker ZURUECK, ein WM_CLOSE (G1, G2).
static const char* s_szNachholen =
	"case E239_SCHLIESSEN_TIMER_ID: if (IsWindowEnabled()) { KillTimer(E239_SCHLIESSEN_TIMER_ID); m_bE239SchliessenWartet = FALSE; PutDebugLog(DEBUG_MASK_MISC, \"E-239 Beenden nachgeholt: der modale Dialog ist zu\"); PostMessage(WM_CLOSE); } return;";

// OnTimer: aufgeschobenes DestroyWindow nachholen.
static const char* s_szZerstoeren =
	"case E239_ZERSTOEREN_TIMER_ID: if (IsWindowEnabled() && AfxOleCanExitApp()) { KillTimer(E239_ZERSTOEREN_TIMER_ID); PutDebugLog(DEBUG_MASK_MISC, \"E-239 Beenden: aufgeschobenes DestroyWindow nachgeholt\"); DestroyWindow(); }";

// OnClose nach CFrameWnd::OnClose: SICHTBAR -> Merker zurueck, VERSTECKT -> Zeitgeber (G4).
static const char* s_szNachFrameClose =
	"if (::IsWindow(m_hWnd)) { if (IsWindowVisible()) { PutDebugLog(DEBUG_MASK_MISC, \"E-239 Beenden: Fenster steht noch sichtbar, Merker zurueckgesetzt\"); m_bE239BeendenLaeuft = FALSE; } else { PutDebugLog(DEBUG_MASK_MISC, \"E-239 Beenden: DestroyWindow aufgeschoben (OLE), Zeitgeber gestellt\"); SetTimer(E239_ZERSTOEREN_TIMER_ID, 500, NULL); } }";

// OnQueryEndSession: das Beenden laeuft schon - zustimmen, ohne CloseDown (G5).
static const char* s_szMerkerEndSession =
	"if (m_bE239BeendenLaeuft) { PutDebugLog(DEBUG_MASK_MISC, \"E-239 Beenden laeuft schon: WM_QUERYENDSESSION ohne zweites CloseDown beantwortet\"); return (TRUE); } if (!CloseDown()) return (FALSE);";

// CloseDown: g_Nicknames vor dem Aufruf pruefen.
static const char* s_szNicknames =
	"if (g_Nicknames && ! g_Nicknames->CanCloseFrame(NULL)) return FALSE;";

static void Test_E239_Bloecke(const char* szEudoraDir)
{
	TT_BeginTest("E-239: jeder Schutz gegen das Beenden in der Schleife eines Dialogs steht vollstaendig da");

	char* pT = QT_LiesNurCode(szEudoraDir, "mainfrm.cpp");
	if (!pT)
	{
		TT_Fail("mainfrm.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pC = QT_Abschnitt(pT, "void CMainFrame::OnClose()", "BOOL CMainFrame::CloseDown()");
	char* pQ = QT_Abschnitt(pT, "BOOL CMainFrame::OnQueryEndSession()", "return (QCWorkbook::OnQueryEndSession());");
	char* pD = QT_Abschnitt(pT, "BOOL CMainFrame::CloseDown()", "QuerySendQueuedMessages()");
	char* pZ = QT_Abschnitt(pT, "void CMainFrame::OnTimer(", "case E123_WARTE_TIMER_ID:");

	if (!pC || !pQ || !pD || !pZ)
		TT_Fail("OnClose, OnQueryEndSession, CloseDown oder OnTimer nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		TT_CHECK_MSG(QT_Zaehle(pC, s_szMerkerOnClose) == 1,
					 "OnClose: ein weiteres WM_CLOSE waehrend des Beendens wird nicht vollstaendig abgewiesen (Merker + return) - der Absturzweg ist offen (E-239)");
		TT_CHECK_MSG(QT_Zaehle(pC, s_szAufschub) == 1,
					 "OnClose: bei offenem modalem Dialog wird nicht vollstaendig aufgeschoben (vormerken, Zeitgeber, return) - das Beenden laeuft in der Schleife des Dialogs (E-239)");
		TT_CHECK_MSG(QT_Zaehle(pZ, s_szNachholen) == 1,
					 "OnTimer: das aufgeschobene Beenden wird nicht vollstaendig nachgeholt (KillTimer, Wartemerker zurueck, ein WM_CLOSE) (E-239)");
		TT_CHECK_MSG(QT_Zaehle(pZ, s_szZerstoeren) == 1,
					 "OnTimer: das aufgeschobene DestroyWindow wird nicht nachgeholt - Prozess ohne Fenster (E-239)");
		TT_CHECK_MSG(QT_Zaehle(pC, s_szNachFrameClose) == 1,
					 "OnClose: nach CFrameWnd::OnClose werden sichtbar (Merker zurueck) und versteckt (Zeitgeber) nicht richtig unterschieden (E-239)");
		TT_CHECK_MSG(QT_Zaehle(pQ, s_szMerkerEndSession) == 1,
					 "OnQueryEndSession: waehrend des Beendens geht es erneut durch CloseDown (E-239)");
		TT_CHECK_MSG(QT_Zaehle(pD, s_szNicknames) == 1 && QT_Zaehle(pD, "g_Nicknames->") == 1,
					 "CloseDown ruft g_Nicknames->CanCloseFrame ohne Pruefung auf NULL - im Release-Bau tut ASSERT nichts (E-239)");

		// Reihenfolge in OnClose: Merker, dann Aufschub, dann CloseDown, dann
		// Merker setzen, dann CFrameWnd::OnClose, dann die Unterscheidung.
		long lMerker   = QT_Stelle(pC, s_szMerkerOnClose);
		long lAufschub = QT_Stelle(pC, s_szAufschub);
		long lClose    = QT_Stelle(pC, "if (!CloseDown())");
		long lSetzen   = QT_Stelle(pC, "m_bE239BeendenLaeuft = TRUE;");
		long lFrame    = QT_Stelle(pC, "QCWorkbook::OnClose();");
		long lNach     = QT_Stelle(pC, s_szNachFrameClose);
		TT_CHECK_MSG(lMerker >= 0 && lAufschub > lMerker && lClose > lAufschub &&
					 lSetzen > lClose && lFrame > lSetzen && lNach > lFrame,
					 "OnClose: Merker, Aufschub, CloseDown, Merker setzen, CFrameWnd::OnClose und Unterscheidung stehen nicht in dieser Reihenfolge (E-239)");
		TT_CHECK_MSG(QT_Zaehle(pC, "m_bE239BeendenLaeuft = TRUE;") == 1,
					 "OnClose setzt den Merker nicht genau einmal (E-239)");
	}

	if (pC) free(pC);
	if (pQ) free(pQ);
	if (pD) free(pD);
	if (pZ) free(pZ);
	free(pT);
	TT_EndTest();
}

void RunE239Tests(const char* szEudoraDir)
{
	Test_E239_Bloecke(szEudoraDir);
}
