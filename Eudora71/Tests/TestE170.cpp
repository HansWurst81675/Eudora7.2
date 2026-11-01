//
// TestE170.cpp - Befund E-170: das Label einer Mail ging verloren, wenn man
// sie innerhalb eines IMAP-Kontos in einen anderen Ordner verschob.
//
// Gregors Entscheidung vom 01.11.2026: "Label mitnehmen". ImapXferOnSameAccount
// merkt beim Einreihen das Label je alter UID; die Nachbearbeitung der
// Uebertragung setzt es auf die neue Zusammenfassung im Ziel.
//
// Geprueft am Quelltext (die Wege haengen an CTocDoc, Server und Warteschlange
// und lassen sich ohne Programm nicht aufrufen): jede der vier Stellen muss
// dastehen, sonst ist die Kette unterbrochen und das Label geht wieder still
// verloren.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E170_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-170 (Quelltext): Label wird beim Verschieben im IMAP-Konto gemerkt und im Ziel gesetzt");
	char* pToc = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pQ   = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
	if (!pToc || !pQ)
	{
		TT_Fail("ImapToc.cpp oder ImapActionQueue.cpp nicht lesbar - ungeprueft ist nicht gruen");
		if (pToc) free(pToc);
		if (pQ) free(pQ);
		TT_EndTest();
		return;
	}

	// 1. Einreihen: Label je UID merken und an die Uebertragung geben
	char* pXfer = QT_Abschnitt(pToc, "CSummary* CTocDoc::ImapXferOnSameAccount(", "CSummary* CTocDoc::ImapXferBetweenAccounts(");
	if (!pXfer)
		TT_Fail("ImapXferOnSameAccount nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pXfer, "dwaE170Labels.Add((DWORD) pSum->GetLabel());"), "ImapXferOnSameAccount merkt das Label nicht mehr (E-170)");
		TT_CHECK_MSG(QT_Enthaelt(pXfer, "dwaE170AlteUIDs.Add(pSum->m_Hash);"), "ImapXferOnSameAccount merkt die alte UID nicht mehr (E-170)");
		TT_CHECK_MSG(QT_Stelle(pXfer, "pTransferAction->m_dwaE170Labels.Copy(dwaE170Labels);") >= 0 &&
					 QT_Stelle(pXfer, "pTransferAction->m_dwaE170Labels.Copy(dwaE170Labels);") < QT_Stelle(pXfer, "pAccount->QueueAction(pTransferAction);"),
					 "die gemerkten Labels gehen nicht VOR dem Einreihen an die Uebertragung (E-170)");
		free(pXfer);
	}

	// 2. Nachbearbeitung ruft das Nachtragen auf
	char* pPost = QT_Abschnitt(pQ, "void CImapTransferMsgAction::DoPostProcessing()", "void CImapTransferMsgAction::SetDestAccountID(");
	if (!pPost)
		TT_Fail("CImapTransferMsgAction::DoPostProcessing nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		const long lTransfer = QT_Stelle(pPost, "ImapTransferSummaryData(");
		const long lNach     = QT_Stelle(pPost, "E170LabelsNachtragen();");
		TT_CHECK_MSG(lNach >= 0, "DoPostProcessing traegt die Labels nicht mehr nach (E-170)");
		TT_CHECK_MSG(lNach < 0 || lTransfer < 0 || lNach > lTransfer, "E170LabelsNachtragen laeuft vor ImapTransferSummaryData - die neue Zusammenfassung steht dann noch nicht (E-170)");
		// 3. Die Zuordnung setzt nur, wo das Ziel noch kein Label hat, und nichts bei ungleicher Anzahl
		TT_CHECK_MSG(QT_Enthaelt(pPost, "if (pZiel && pZiel->GetLabel() == 0)"), "E170LabelsNachtragen ueberschreibt ein vorhandenes Label (E-170)");
		TT_CHECK_MSG(QT_Enthaelt(pPost, "\"anzahl-passt-nicht\""), "E170LabelsNachtragen setzt auch bei ungleicher Anzahl - Gefahr: Label auf der falschen Mail (E-170)");
		// PRUEFER-71 K1: nur zuordnen, wenn die alten UIDs schon aufsteigend sind
		TT_CHECK_MSG(QT_Enthaelt(pPost, "else if (!E170Aufsteigend_Ist(m_dwaE170AlteUIDs)) { szGrund = \"reihenfolge-unsicher\"; }"),
					 "E170LabelsNachtragen ordnet auch bei nicht aufsteigender alter Liste zu - Label kaeme zusaetzlich auf eine falsche Mail (E-170, PRUEFER-71 K1)");
		free(pPost);
	}

	// 4. Duplicate/Copy nimmt die Listen mit
	char* pCopy = QT_Abschnitt(pQ, "void CImapTransferMsgAction::Copy(CImapAction *pImapAction)", "bool CImapTransferMsgAction::UsesMailbox(");
	if (!pCopy)
		TT_Fail("CImapTransferMsgAction::Copy nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pCopy, "m_dwaE170Labels.Copy(pQuelle->m_dwaE170Labels);"), "eine kopierte Uebertragung verliert die gemerkten Labels (E-170)");
		free(pCopy);
	}

	free(pToc);
	free(pQ);
	TT_EndTest();
}

void RunE170Tests(const char* szEudoraDir)
{
	Test_E170_Stelle(szEudoraDir);
}
