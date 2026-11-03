//
// TestE192.cpp - Befund E-192: Papierkorb, Junk und Filter ordnen beim
// Verschieben mehrerer IMAP-Mails die neuen UIDs ueber die Quellmenge aus
// "[COPYUID v quelle ziel]" zu, nicht nach der Stelle in der eigenen Liste.
//
// Die Liste folgt der Sortierung der Ansicht, der Server nummeriert in
// UID-Folge. Ohne die Quellmenge trug im Papierkorb jede Mail den Kopf einer
// anderen (gemessen an 7.2.1.131, tools/messen-e192.ps1: richtig=1 falsch=2).
// Die Zuordnung selbst steht in ImapTransferSummaryData und ist seit E-184 K3
// da; hier fehlte nur das Durchreichen an drei Aufrufern.
//
// Dazu E-189 (LEKTOR-138 L-138.10): die beiden Logzeilen beim Entfernen einer
// Vorab-Kopie nennen keinen Ordnernamen mehr (Gregor 03.11.2026).
//
// Geprueft am Quelltext - die Wege haengen an Server, Fenster und CTocDoc.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E192_Aufrufer(const char* szEudoraDir)
{
	TT_BeginTest("E-192 (Quelltext): Papierkorb, Junk und Filter reichen die Quellmenge aus COPYUID durch");
	char* pToc = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pMbx = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapMailbox.cpp");
	char* pFlt = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapFiltersd.cpp");
	char* pHdr = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\public\\inc\\ImapMailbox.h");
	if (!pToc || !pMbx || !pFlt || !pHdr)
	{
		TT_Fail("ImapToc.cpp, ImapMailbox.cpp, ImapFiltersd.cpp oder ImapMailbox.h nicht lesbar - ungeprueft ist nicht gruen");
		if (pToc) free(pToc);
		if (pMbx) free(pMbx);
		if (pFlt) free(pFlt);
		if (pHdr) free(pHdr);
		TT_EndTest();
		return;
	}

	// 1. Papierkorb: CTocDoc::ImapMoveMsgsToTrash
	char* pTrash = QT_Abschnitt(pToc, "HRESULT CTocDoc::ImapMoveMsgsToTrash (", "HRESULT CTocDoc::ImapChangeMsgsJunkStatus(");
	if (!pTrash)
		TT_Fail("CTocDoc::ImapMoveMsgsToTrash nicht gefunden - ungeprueft ist nicht gruen (E-192)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pTrash, "&pTargetToc, &dwaQuellUIDs);"),
					 "ImapMoveMsgsToTrash holt die Quellmenge nicht vom Server (E-192)");
		TT_CHECK_MSG(QT_Enthaelt(pTrash, "ImapTransferSummaryData(sUidlist, pTargetToc, &dwaNewUIDs, NULL, false, &dwaQuellUIDs);"),
					 "ImapMoveMsgsToTrash ordnet die neuen UIDs wieder nach Listenposition zu (E-192)");
		free(pTrash);
	}

	// 2. Junk: CTocDoc::ImapChangeMsgsJunkStatus(CString&, ...)
	char* pJunk = QT_Abschnitt(pToc, "HRESULT CTocDoc::ImapChangeMsgsJunkStatus(CString &strUIDList,", "void CTocDoc::ImapRecheckMessageForJunk(");
	if (!pJunk)
		TT_Fail("CTocDoc::ImapChangeMsgsJunkStatus(CString&) nicht gefunden - ungeprueft ist nicht gruen (E-192)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pJunk, "&pTargetToc, &dwaQuellUIDs);"),
					 "ImapChangeMsgsJunkStatus holt die Quellmenge nicht vom Server (E-192)");
		TT_CHECK_MSG(QT_Enthaelt(pJunk, "ImapTransferSummaryData(strUIDList, pTargetToc, &dwaNewUIDs, pImapSum, false, &dwaQuellUIDs);"),
					 "ImapChangeMsgsJunkStatus ordnet die neuen UIDs wieder nach Listenposition zu (E-192)");
		free(pJunk);
	}

	// 3. Filter: ImapFiltersd.cpp
	TT_CHECK_MSG(QT_Enthaelt(pFlt, "XferMessagesOnServer(szUids, &dwaNewUIDs, szImapName, bCopy, FALSE, &dwaQuellUIDs)"),
				 "der IMAP-Filter holt die Quellmenge nicht vom Server (E-192)");
	TT_CHECK_MSG(QT_Enthaelt(pFlt, "ImapTransferSummaryData(strUIDs, pTargetToc, &dwaNewUIDs, NULL, false, &dwaQuellUIDs);"),
				 "der IMAP-Filter ordnet die neuen UIDs wieder nach Listenposition zu (E-192)");

	// 4. CImapMailbox: beide Wege reichen die Menge an XferMessagesOnServer weiter.
	TT_CHECK_MSG(QT_Zaehle(pHdr, "CDWordArray *pdwaQuellUIDs = NULL);") == 3,
				 "ImapMailbox.h: XferMessagesOnServer, MoveMsgsToTrash und MoveMsgsToOrFromJunk muessen je eine Quellmenge nehmen (E-184 K3, E-192)");
	char* pMt = QT_Abschnitt(pMbx, "HRESULT CImapMailbox::MoveMsgsToTrash(", "HRESULT CImapMailbox::MoveMsgsToOrFromJunk(");
	char* pMj = QT_Abschnitt(pMbx, "HRESULT CImapMailbox::MoveMsgsToOrFromJunk(", "BOOL CImapMailbox::ReadyToAutoExpunge()");
	TT_CHECK_MSG(pMt && QT_Enthaelt(pMt, "CDWordArray *pdwaQuellUIDs") && QT_Enthaelt(pMt, "pdwaQuellUIDs);"),
				 "CImapMailbox::MoveMsgsToTrash gibt die Quellmenge nicht an XferMessagesOnServer (E-192)");
	TT_CHECK_MSG(pMj && QT_Enthaelt(pMj, "CDWordArray *pdwaQuellUIDs") && QT_Enthaelt(pMj, "pdwaQuellUIDs);"),
				 "CImapMailbox::MoveMsgsToOrFromJunk gibt die Quellmenge nicht an XferMessagesOnServer (E-192)");
	if (pMt) free(pMt);
	if (pMj) free(pMj);

	free(pToc); free(pMbx); free(pFlt); free(pHdr);
	TT_EndTest();
}

static void Test_E189_OhneOrdnernamen(const char* szEudoraDir)
{
	TT_BeginTest("E-189 (Quelltext): Logzeilen beim Entfernen einer Vorab-Kopie ohne Ordnernamen");
	char* pToc = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pRm = pToc ? QT_Abschnitt(pToc, "void E189VorabKopienEntfernen(", "CSummary *CTocDoc::GetSummaryFromUID(") : 0;
	if (!pRm)
		TT_Fail("E189VorabKopienEntfernen nicht gefunden - ungeprueft ist nicht gruen (E-189)");
	else
	{
		// Positivprobe: beide Zeilen stehen noch da, sonst misst der Test nichts.
		TT_CHECK_MSG(QT_Zaehle(pRm, "\"E-189 Vorab-Kopie") == 2,
					 "die beiden E-189-Logzeilen fehlen - der Test misst sonst nichts");
		// Gregor, 03.11.2026: keine Ordnernamen ins Protokoll.
		TT_CHECK_MSG(QT_Zaehle(pRm, "ziel=") == 0 && QT_Zaehle(pRm, "->Name()") == 0,
					 "E-189-Logzeile nennt wieder den Ordnernamen (Gregor 03.11.2026: keine Ordnernamen ins Protokoll)");
		free(pRm);
	}
	if (pToc) free(pToc);
	TT_EndTest();
}

void RunE192Tests(const char* szEudoraDir)
{
	Test_E192_Aufrufer(szEudoraDir);
	Test_E189_OhneOrdnernamen(szEudoraDir);
}
