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
		// PRUEFER-94 K5: ohne diese Zeile blieb der Test gruen - der Kern fuer E-188f.
		TT_CHECK_MSG(QT_Enthaelt(pL, "bAngekommen = false; if (!pSum->IsNotFullyIMAPDownloaded())"),
					 "nach lokal gilt eine Mail, deren Text nicht zu holen war, als angekommen (E-188f)");
		TT_CHECK_MSG(QT_Enthaelt(pL, "if (!strAngekommen.IsEmpty())"),
					 "nach lokal wird auch geloescht, wenn nichts angekommen ist (E-188f)");
		// PRUEFER-94 K2: inzwischen ganz geladen, aber im Ziel liegt noch die Vorab-Kopie.
		TT_CHECK_MSG(QT_Enthaelt(pL, "if (pSum->IsNotFullyIMAPDownloaded() || (m_pDestTocDoc && E184FindeVorabKopie(m_pDestTocDoc, pSum->GetHash())))"),
					 "nach lokal gilt eine erst spaeter ganz geladene Mail als angekommen, obwohl nur der Kopf kopiert ist (K2)");
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
		// PRUEFER-94 K1: mehrteilige Mail - ein fehlender Teil laesst "nicht geladen" stehen.
		TT_CHECK_MSG(QT_Enthaelt(pDs, "m_bE188TeilFehlt = FALSE;") &&
					 QT_Enthaelt(pDs, "if (m_bE188TeilFehlt) {") &&
					 QT_Enthaelt(pDs, "else pSum->m_Imflags &= ~IMFLAGS_NOT_DOWNLOADED;"),
					 "eine mehrteilige Mail mit fehlendem Teil gilt als geladen (E-188tm/fm)");
		free(pDs);
	}
	// K1: jede Abrufstelle eines Teils merkt sich das Scheitern.
	if (pD)
		TT_CHECK_MSG(QT_Zaehle(pD, "if (!bResult) m_bE188TeilFehlt = TRUE;") == 4,
					 "nicht jede Abrufstelle eines Teils merkt sich das Scheitern (E-188tm/fm)");
	if (pD) free(pD);

	// 4. Die Vorab-Kopie im Ziel wird ueber ihr Merkzeichen gesucht, nicht ueber
	// die Nummer (E-188k/l/d), und ohne Gegenstueck auf dem Server entfernt
	// (E-188a/t/u).
	char* pT = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pX = QT_LiesNurCode(szEudoraDir, "tocdoc.cpp");
	char* pQ2 = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
	if (!pT || !pX || !pQ2)
		TT_Fail("ImapToc.cpp, tocdoc.cpp oder ImapActionQueue.cpp nicht lesbar - ungeprueft ist nicht gruen");
	else
	{
		char* pLok = QT_Abschnitt(pT, "BOOL CTocDoc::ImapCopyMsgFromImapToLocal (", "BOOL CTocDoc::ImapCopyMsgBetweenAccounts (");
		char* pKon = QT_Abschnitt(pT, "BOOL CTocDoc::ImapCopyMsgBetweenAccounts (", "CSummary *CTocDoc::ImapTransferSummaryData(");
		if (!pLok || !pKon)
			TT_Fail("ImapCopyMsgFromImapToLocal oder ImapCopyMsgBetweenAccounts nicht gefunden - ungeprueft ist nicht gruen");
		else
		{
			TT_CHECK_MSG(QT_Enthaelt(pLok, "E184FindeVorabKopie(pTargetToc, pSum->GetHash())") &&
						 !QT_Enthaelt(pLok, "pTargetToc->GetSummaryFromUID(pSum->GetHash())"),
						 "nach lokal wird die Vorab-Kopie wieder ueber die Nummer gesucht - trifft eine fremde Mail (E-188l)");
			TT_CHECK_MSG(QT_Enthaelt(pKon, "E184FindeVorabKopie(pTargetToc, pSum->GetHash())") &&
						 !QT_Enthaelt(pKon, "pTargetToc->GetSummaryFromUID(pSum->GetHash())"),
						 "zwischen Konten wird die Vorab-Kopie wieder ueber die Nummer gesucht - ueberschreibt eine fremde Mail (E-188k)");
			long lCopy = QT_Stelle(pKon, "pCopySum->Copy(pSum);");
			long lNeu  = QT_Stelle(pKon, "pCopySum->m_Hash = NewUid;");
			long lAdd  = QT_Stelle(pKon, "pTargetToc->AddSum(pCopySum);");
			TT_CHECK_MSG(lCopy >= 0 && lNeu > lCopy && lAdd > lNeu,
						 "zwischen Konten behaelt die Kopie im Ziel die alte Nummer - der Abgleich holt sie ein zweites Mal (E-188k/d)");
			TT_CHECK_MSG(QT_Enthaelt(pKon, "pCopySum->m_Imflags = ulFlagsVorab;") &&
						 QT_Enthaelt(pKon, "pCopySum->m_Imflags &= ~IMFLAGS_DELETED;"),
						 "zwischen Konten erbt die Kopie im Ziel das Geloescht-Merkzeichen der Quelle - sie ist ausgeblendet (E-188d)");
		}
		if (pLok) free(pLok);
		if (pKon) free(pKon);

		TT_CHECK_MSG(QT_Enthaelt(pX, "else if (IsImapToc() && !TargetToc->IsImapToc() && Sum->IsNotFullyIMAPDownloaded())"),
					 "CTocDoc::Xfer markiert die Vorab-Kopie nach lokal nicht - die Suche findet sie nicht (E-188l)");

		char* pK2 = QT_Abschnitt(pQ2, "void CImapCrossServerTransferMsgAction::DoPostProcessing()",
								 "CImapToLocalTransferMsgAction::CImapToLocalTransferMsgAction(");
		if (!pK2)
			TT_Fail("CImapCrossServerTransferMsgAction::DoPostProcessing nicht gefunden - ungeprueft ist nicht gruen");
		else
		{
			TT_CHECK_MSG(QT_Enthaelt(pK2, "E189VorabKopienEntfernen(m_pDestTocDoc, szAlt);"),
						 "zwischen Konten bleibt die Vorab-Kopie ohne Gegenstueck im Ziel stehen (E-188a/t/u)");
			// PRUEFER-94 K5: "pCopySum = NULL;" traf die Deklaration - jetzt die Folge
			// im Schleifenrumpf (Kommentare sind weg, Leerraum ist zusammengezogen).
			long lReset = QT_Stelle(pK2, "bool bAngekommen = false; pCopySum = NULL;");
			long lAufruf = QT_Stelle(pK2, "m_pTocDoc->ImapCopyMsgBetweenAccounts(");
			TT_CHECK_MSG(lReset >= 0 && lReset < lAufruf,
						 "pCopySum wird nicht je Mail zurueckgesetzt - die Kopie der vorigen Mail gilt fuer die naechste");
			free(pK2);
		}
	}
	if (pT) free(pT);
	if (pX) free(pX);
	if (pQ2) free(pQ2);

	TT_EndTest();
}

void RunE188Tests(const char* szEudoraDir)
{
	Test_E188_Loeschschranke(szEudoraDir);
}
