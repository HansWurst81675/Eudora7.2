//
// TestE188.cpp - Befund E-188: Verschieben in ein anderes IMAP-Konto oder
// aus IMAP in ein lokales Postfach.
//
// Bis 7.2.2.132 loeschten beide Wege die GANZE Liste in der Quelle, auch
// wenn das Hochladen abgelehnt wurde (Fall E-188a), der Text nicht zu holen
// war (E-188t, E-188f) oder das lokale Kopieren scheiterte. Gemessen am
// Pruefstand (tools/messen-e188*.ps1): die Mail stand danach auf keinem
// Server mehr ohne \Deleted. Jetzt wird nur geloescht, was angekommen ist;
// ohne Text wird zwischen Konten gar nicht erst hochgeladen.
//
// Geprueft am Quelltext - die Wege haengen an zwei Servern, der Warteschlange
// und CTocDoc und lassen sich ohne Programm nicht aufrufen. Das Verhalten
// misst der Pruefstand (E-188a/t/f).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E188_Loeschschranke(const char* szEudoraDir)
{
	TT_BeginTest("E-188: Quelle wird nur geloescht, wenn die Mail im Ziel angekommen ist");

	char* pQ = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
	if (!pQ)
	{
		TT_Fail("ImapActionQueue.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	// 1. Zwischen zwei Konten.
	char* pK = QT_Abschnitt(pQ, "void CImapCrossServerTransferMsgAction::DoPostProcessing()",
							"CImapToLocalTransferMsgAction::CImapToLocalTransferMsgAction(");
	if (!pK)
		TT_Fail("CImapCrossServerTransferMsgAction::DoPostProcessing nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		TT_CHECK_MSG(QT_Zaehle(pK, "DeleteMessagesFromServer(") == 1 &&
					 QT_Enthaelt(pK, "DeleteMessagesFromServer(strAngekommen,"),
					 "zwischen Konten wird nicht nur die Liste der angekommenen Mails geloescht (E-188a)");
		TT_CHECK_MSG(!QT_Enthaelt(pK, "DeleteMessagesFromServer(m_szMessageIDs,"),
					 "zwischen Konten wird wieder die ganze Liste geloescht (E-188a)");
		long lOhneText = QT_Stelle(pK, "!pSum->HasAttachment() && pSum->IsNotFullyIMAPDownloaded()");
		long lKopie    = QT_Stelle(pK, "m_pTocDoc->ImapCopyMsgBetweenAccounts(");
		TT_CHECK_MSG(lOhneText >= 0 && lKopie > lOhneText,
					 "zwischen Konten wird ohne geladenen Text hochgeladen - im Ziel nur der Kopf (E-188t)");
		TT_CHECK_MSG(QT_Enthaelt(pK, "if (!strAngekommen.IsEmpty())"),
					 "zwischen Konten wird auch geloescht, wenn nichts angekommen ist (E-188a)");
		free(pK);
	}

	// 2. Nach lokal.
	char* pL = QT_Abschnitt(pQ, "void CImapToLocalTransferMsgAction::DoPostProcessing()",
							"CImapFromLocalTransferMsgAction::CImapFromLocalTransferMsgAction(");
	if (!pL)
		TT_Fail("CImapToLocalTransferMsgAction::DoPostProcessing nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		TT_CHECK_MSG(QT_Zaehle(pL, "DeleteMessagesFromServer(") == 1 &&
					 QT_Enthaelt(pL, "DeleteMessagesFromServer(strAngekommen,"),
					 "nach lokal wird nicht nur die Liste der angekommenen Mails geloescht (E-188f)");
		TT_CHECK_MSG(QT_Enthaelt(pL, "if (m_pTocDoc->ImapCopyMsgFromImapToLocal("),
					 "nach lokal wird das Ergebnis des Kopierens nicht ausgewertet (E-188)");
		TT_CHECK_MSG(QT_Enthaelt(pL, "if (!strAngekommen.IsEmpty())"),
					 "nach lokal wird auch geloescht, wenn nichts angekommen ist (E-188f)");
		free(pL);
	}

	free(pQ);

	// 3. Der Downloader: ein verweigerter Rumpf darf nicht als "geladen" gelten
	// (E-188t/f: Server antwortet NO auf BODY.PEEK[1]; vorher blieb hResult vom
	// Kopfabruf S_OK, die Mail galt als vollstaendig geladen).
	char* pD = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapDownload.cpp");
	char* pDs = pD ? QT_Abschnitt(pD, "HRESULT CImapDownloader::DownloadSingleMessage (", "void CImapDownloader::CheckMoodScore(") : NULL;
	if (!pDs)
		TT_Fail("CImapDownloader::DownloadSingleMessage nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		long lKopf    = QT_Stelle(pDs, "hResult = m_pImap->UIDFetchHeaderFull (Uid, this);");
		long lRumpf   = QT_Stelle(pDs, "if ( DownloadSimpleBody (Uid, pBody, \"1\") )");
		long lFehler  = lRumpf >= 0 ? QT_Stelle(pDs + lRumpf, "hResult = E_FAIL;") : -1;
		long lFreigeb = lRumpf >= 0 ? QT_Stelle(pDs + lRumpf, "m_pImap->FreeBodyStructure") : -1;
		TT_CHECK_MSG(lKopf >= 0 && lRumpf > lKopf && lFehler >= 0 && lFehler < lFreigeb,
					 "ein gescheiterter einfacher Rumpf setzt hResult nicht auf E_FAIL - die Mail gilt als geladen (E-188t/f)");
		free(pDs);
	}
	if (pD) free(pD);

	TT_EndTest();
}

void RunE188Tests(const char* szEudoraDir)
{
	Test_E188_Loeschschranke(szEudoraDir);
}
