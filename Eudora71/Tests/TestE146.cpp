//
// TestE146.cpp - Regressionstest zu Befund E-146 (PRUEFER-50 K8, K9)
//
// K8: Nach dem Umbenennen eines IMAP-Ordners fuehrte Eudora ihn unter einem
// anderen Namen als der Server - ohne Trenner haengte ReverseFind('\0') den
// neuen Namen an den ganzen alten ("AblageAblage-..."), und bei INBOX fehlte
// das Praefix des Kontos. Ursache: der Name wurde zweimal gebildet, in
// CImapAccount::RenameMailbox fuer den Server und in UpdateAfterRename fuer
// Eudora. Jetzt gibt RenameMailbox seinen Namen zurueck, und
// UpdateAfterRename fuehrt genau diesen.
//
// K9: Lehnte der Server das Umbenennen ab, blieb Eudora lokal umbenannt.
// Jetzt liest CImapRenameMailboxAction::DoPostProcessing die Ordnerliste
// neu. Am Verhalten misst es der Pruefstandsfall E-146
// (tools\messen-e146.ps1, Pruefserver mit --rename-ablehnen).
//
// Geprueft wird der Quelltext ohne Kommentare, weil beide Stellen ohne Konto,
// Server und Fenster nicht aufzurufen sind.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE146Tests(const char* szEudoraDir)
{
	TT_Suite("E-146 Umbenennen: ein Name fuer Server und Eudora, Rueckweg bei Ablehnung");

	TT_BeginTest("E-146 K8: RenameMailbox gibt den Servernamen zurueck, UpdateAfterRename fuehrt ihn");
	{
		char* pAcc = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapAccount.cpp");
		char* pDir = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\QCImapMailboxDirector.cpp");
		if (!pAcc || !pDir)
		{
			TT_Fail("ImapAccount.cpp oder QCImapMailboxDirector.cpp nicht lesbar - ungeprueft ist nicht gruen");
			free(pAcc); free(pDir); TT_EndTest(); return;
		}
		QT_LeerraumZusammen(pAcc);
		QT_LeerraumZusammen(pDir);

		char* pRen = QT_Abschnitt(pAcc, "BOOL CImapAccount::RenameMailbox(", "BOOL CImapAccount::RenameMailboxOnServer(");
		TT_CHECK_MSG(pRen != NULL, "CImapAccount::RenameMailbox nicht gefunden");
		if (pRen)
		{
			const long lRueck = QT_Stelle(pRen, "if (pstrNeuerImapName) *pstrNeuerImapName = strNewFullImapName;");
			const long lQueue = QT_Stelle(pRen, "QueueAction(pRenameMailboxAction);");
			TT_CHECK_MSG(lRueck >= 0, "RenameMailbox gibt den Namen, den es an den Server schickt, nicht zurueck");
			// PRUEFER-58 K10: das Praefix bei INBOX zu streichen blieb gruen.
			TT_CHECK_MSG(QT_Enthaelt(pRen, "strNewFullImapName = prefix + E77ImapNameFuerServer(szNewImapName);"),
						 "INBOX: das Praefix des Kontos geht nicht mehr in den neuen Namen");
			TT_CHECK_MSG(lQueue >= 0 && QT_Stelle(pRen, "strNewFullImapName, strLogin,") >= 0,
						 "an den Server geht nicht mehr strNewFullImapName");
			free(pRen);
		}

		TT_CHECK_MSG(QT_Enthaelt(pDir, "bResult = pAccount->RenameMailbox ( pImapCommand, szNewName, szNewDirname, bOldMailboxStillExists, &pNewSibling, &strNeuerImapName );"),
					 "der Aufrufer holt sich den Servernamen nicht ab");
		TT_CHECK_MSG(QT_Enthaelt(pDir, "bResult = UpdateAfterRename (pImapCommand, szNewName, szNewDirname, strNeuerImapName);"),
					 "UpdateAfterRename bekommt den Servernamen nicht");

		char* pUpd = QT_Abschnitt(pDir, "BOOL QCMailboxDirector::UpdateAfterRename (", "UpdateChildrenAfterRename (pImapCommand);");
		TT_CHECK_MSG(pUpd != NULL, "UpdateAfterRename nicht gefunden");
		if (pUpd)
		{
			TT_CHECK_MSG(QT_Enthaelt(pUpd, "pImapCommand->SetImapName (pNewFullImapName);"),
						 "UpdateAfterRename fuehrt nicht den Namen, der an den Server ging");
			TT_CHECK_MSG(!QT_Enthaelt(pUpd, "ReverseFind"),
						 "UpdateAfterRename bildet den Namen wieder selbst - zweite Rechnung, ohne Trenner falsch");
			free(pUpd);
		}
		free(pAcc);
		free(pDir);
	}
	TT_EndTest();

	TT_BeginTest("E-146 K9: lehnt der Server ab, wird die Ordnerliste neu gelesen");
	{
		char* pQ = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
		if (!pQ) { TT_Fail("ImapActionQueue.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
		QT_LeerraumZusammen(pQ);

		char* pPre = QT_Abschnitt(pQ, "bool CImapRenameMailboxAction::DoPreThreadAction()", "HRESULT CImapRenameMailboxAction::DoWork()");
		TT_CHECK_MSG(pPre && QT_Enthaelt(pPre, "m_pTaskInfo->SetPostProcFn(strTitle, ::DoPostProcessing, this);"),
					 "die Nachbearbeitung im Hauptfaden wird nicht angemeldet - DoPostProcessing liefe nie");
		free(pPre);

		char* pWork = QT_Abschnitt(pQ, "HRESULT CImapRenameMailboxAction::DoWork()", "void CImapRenameMailboxAction::DoPostProcessing()");
		TT_CHECK_MSG(pWork && QT_Enthaelt(pWork, "m_iState = kActionStateFailed; m_bE146Fehlgeschlagen = true;"),
					 "ein Scheitern am Server wird nicht vermerkt");
		free(pWork);

		char* pPost = QT_Abschnitt(pQ, "void CImapRenameMailboxAction::DoPostProcessing()", "void CImapRenameMailboxAction::SetNewName(");
		TT_CHECK_MSG(pPost != NULL, "CImapRenameMailboxAction::DoPostProcessing nicht gefunden");
		if (pPost)
		{
			TT_CHECK_MSG(QT_Enthaelt(pPost, "if (!m_bE146Fehlgeschlagen || !m_pAccount) return;"),
					 "die Ordnerliste wuerde auch nach einem gelungenen Umbenennen neu gelesen");
			TT_CHECK_MSG(QT_Enthaelt(pPost, "DEBUG_NEW_NOTHROW CImapRefreshMailboxesAction(m_lAccountID, \"\",")
						 && QT_Enthaelt(pPost, "m_pAccount->QueueAction(pRefresh);"),
					 "nach der Ablehnung wird die Ordnerliste des Kontos nicht neu gelesen");
			free(pPost);
		}
		free(pQ);
	}
	TT_EndTest();
}
