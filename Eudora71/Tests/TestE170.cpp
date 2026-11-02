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
#include "..\EuImap\src\E170Zuordnung.h"

// E-170 ohne UIDPLUS: die Zuordnung selbst, im Verhalten. Gemessen am
// 02.11.2026 (tools/messen-e170o.ps1): ohne COPYUID kam die Kopie an
// 7.2.1.128 und 7.2.1.131 ohne Label an.
static E170Merkmale M(long l, const char* v, const char* b) { E170Merkmale m; m.lSekunden = l; m.szVon = v; m.szBetreff = b; return m; }

static void Test_E170_Zuordnung()
{
	TT_BeginTest("E-170 ohne UIDPLUS: Zuordnung nach Datum, Absender, Betreff - nur eindeutig, nie auf eine fremde Mail");
	int z[4];

	// 1. Die Kopie steht als dritte neue Zusammenfassung da (UID 1 -> 1 passt nicht zufaellig).
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Pruefnachricht 1"), M(100, "Pruefserver", "Pruefnachricht 2"), M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 1, k, 3, z);
		TT_CHECK_MSG(z[0] == 2, "die Kopie wird nicht ueber den Betreff gefunden, obwohl Datum und Absender bei allen gleich sind");
	}
	// 2. Eine fremde neue Mail taucht gleichzeitig auf, mit anderem Betreff: Label nur auf die Kopie.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Fremd", "Fremde neue Nachricht"), M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 1, k, 2, z);
		TT_CHECK_MSG(z[0] == 1, "neben einer fremden neuen Mail wird die Kopie nicht oder falsch zugeordnet");
	}
	// 3. Die fremde sieht genau gleich aus: lieber kein Label als ein falsches (E-184).
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Pruefnachricht 3"), M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 1, k, 2, z);
		TT_CHECK_MSG(z[0] == E170_MEHRDEUTIG, "zwei gleich aussehende neue Mails: es wird trotzdem eine gewaehlt - womoeglich die fremde");
	}
	// 4. Die Kopie ist (noch) nicht dabei, nur eine fremde: nichts.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Fremd", "Fremde neue Nachricht") };
		E170Zuordnen(v, 1, k, 1, z);
		TT_CHECK_MSG(z[0] == E170_KEIN_TREFFER, "ohne passende Kopie wird trotzdem zugeordnet");
	}
	// 5. Ein Merkmal weicht ab (Datum, Absender) oder fehlt: kein Treffer.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(101, "Pruefserver", "Pruefnachricht 3"), M(100, "Anderer", "Pruefnachricht 3"), M(100, "Pruefserver", NULL) };
		E170Zuordnen(v, 1, k, 3, z);
		TT_CHECK_MSG(z[0] == E170_KEIN_TREFFER, "eine Mail mit anderem Datum, anderem Absender oder ohne Betreff gilt als Kopie");
	}
	// 6. Zwei gleich aussehende Mails verschoben, nur eine Kopie da: beide mehrdeutig.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Gleich"), M(100, "Pruefserver", "Gleich") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Gleich") };
		E170Zuordnen(v, 2, k, 1, z);
		TT_CHECK_MSG(z[0] == E170_MEHRDEUTIG && z[1] == E170_MEHRDEUTIG, "eine Kopie wird zwei gleich aussehenden Vormerkungen gegeben");
	}
	// 7. Mehrere Mails, Ziel in anderer Folge: jede bekommt ihre eigene.
	{
		E170Merkmale v[] = { M(300, "Pruefserver", "Pruefnachricht 3"), M(200, "Pruefserver", "Pruefnachricht 2"), M(100, "Pruefserver", "Pruefnachricht 1") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Pruefnachricht 1"), M(200, "Pruefserver", "Pruefnachricht 2"), M(300, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 3, k, 3, z);
		TT_CHECK_MSG(z[0] == 2 && z[1] == 1 && z[2] == 0, "mehrere Mails werden nach Position statt nach Merkmalen zugeordnet");
	}
	TT_EndTest();
}

static void Test_E170_OhneUidplus_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-170 ohne UIDPLUS (Quelltext): Merkmale gemerkt, am Ziel vorgemerkt, nach dem Abgleich gesetzt");
	char* pToc = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pQ   = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
	char* pMb  = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapMailbox.cpp");
	if (!pToc || !pQ || !pMb)
	{
		TT_Fail("ImapToc.cpp, ImapActionQueue.cpp oder ImapMailbox.cpp nicht lesbar - ungeprueft ist nicht gruen");
		if (pToc) free(pToc);
		if (pQ) free(pQ);
		if (pMb) free(pMb);
		TT_EndTest();
		return;
	}

	char* pXfer = QT_Abschnitt(pToc, "CSummary* CTocDoc::ImapXferOnSameAccount(", "CSummary* CTocDoc::ImapXferBetweenAccounts(");
	if (!pXfer)
		TT_Fail("ImapXferOnSameAccount nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pXfer, "dwaE170Sekunden.Add((DWORD) pSum->m_Seconds);") &&
					 QT_Enthaelt(pXfer, "saE170Von.Add(CString(pSum->m_From));") &&
					 QT_Enthaelt(pXfer, "saE170Betreff.Add(CString(pSum->m_Subject));"),
					 "ImapXferOnSameAccount merkt Datum, Absender oder Betreff nicht mehr (E-170 ohne UIDPLUS)");
		const long lBetreff = QT_Stelle(pXfer, "pTransferAction->m_saE170Betreff.Copy(saE170Betreff);");
		TT_CHECK_MSG(lBetreff >= 0 && lBetreff < QT_Stelle(pXfer, "pAccount->QueueAction(pTransferAction);"),
					 "die Merkmale gehen nicht VOR dem Einreihen an die Uebertragung (E-170 ohne UIDPLUS)");
		free(pXfer);
	}

	char* pNach = QT_Abschnitt(pQ, "void CImapTransferMsgAction::E170LabelsNachtragen()", "void CImapTransferMsgAction::SetDestAccountID(");
	if (!pNach)
		TT_Fail("E170LabelsNachtragen nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pNach, "else if (nNeu == 0) { szGrund = \"keine-neuen-uids\"; nVorgemerkt = E170LabelsVormerken(m_pDestTocDoc, m_dwaE170Labels, m_dwaE170Sekunden, m_saE170Von, m_saE170Betreff, &nSchonDa); }"),
					 "ohne neue UIDs werden die Labels nicht mehr am Ziel vorgemerkt (E-170 ohne UIDPLUS)");
		free(pNach);
	}
	char* pCopy = QT_Abschnitt(pQ, "void CImapTransferMsgAction::Copy(CImapAction *pImapAction)", "bool CImapTransferMsgAction::UsesMailbox(");
	if (pCopy)
	{
		TT_CHECK_MSG(QT_Enthaelt(pCopy, "m_saE170Betreff.Copy(pQuelle->m_saE170Betreff);") && QT_Enthaelt(pCopy, "m_dwaE170Sekunden.Copy(pQuelle->m_dwaE170Sekunden);"),
					 "eine kopierte Uebertragung verliert die gemerkten Merkmale (E-170 ohne UIDPLUS)");
		free(pCopy);
	}
	else
		TT_Fail("CImapTransferMsgAction::Copy nicht gefunden - ungeprueft ist nicht gruen (E-170)");

	char* pVor = QT_Abschnitt(pToc, "int E170LabelsVormerken(", "void E170NachAbgleich(");
	char* pAbg = QT_Abschnitt(pToc, "void E170NachAbgleich(", "CSummary *CTocDoc::GetSummaryFromUID(");
	if (!pVor || !pAbg)
		TT_Fail("E170LabelsVormerken oder E170NachAbgleich nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pVor, "if (E170MerkmaleGleich(mQuelle, m)) bDa = TRUE;") && QT_Enthaelt(pVor, "if (bDa) { nSchonDa++; continue; }"),
					 "E170LabelsVormerken merkt auch vor, wenn im Ziel schon eine gleich aussehende Mail steht (E-170 ohne UIDPLUS)");
		TT_CHECK_MSG(QT_Enthaelt(pAbg, "E170Zuordnen(pVor, nVor, pKand, nKand, pnZu);"),
					 "E170NachAbgleich ordnet nicht ueber E170Zuordnen zu (E-170 ohne UIDPLUS)");
		TT_CHECK_MSG(QT_Enthaelt(pAbg, "if (pnZu[i] >= 0) { CSummary *pSum = (CSummary *) aNeu.GetAt(pnZu[i]); if (pSum->GetLabel() == 0) { pSum->SetLabel(p->nLabel);"),
					 "E170NachAbgleich setzt ohne eindeutige Zuordnung oder ueberschreibt ein Label (E-170 ohne UIDPLUS)");
	}
	if (pVor) free(pVor);
	if (pAbg) free(pAbg);

	char* pApp = QT_Abschnitt(pMb, "BOOL CImapMailbox::ImapAppendSumList (", "UpdateOldSummaries");
	if (!pApp)
		TT_Fail("ImapAppendSumList nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pApp, "pTocDoc->AddSum(pSum); aE170Neu.Add(pSum);"),
					 "ImapAppendSumList sammelt die neu angelegten Zusammenfassungen nicht mehr (E-170 ohne UIDPLUS)");
		const long lAbg = QT_Stelle(pApp, "E170NachAbgleich(pTocDoc, aE170Neu);");
		TT_CHECK_MSG(lAbg >= 0 && lAbg < QT_Stelle(pApp, "pTocDoc->SaveModified();"),
					 "ImapAppendSumList setzt die vorgemerkten Labels nicht vor dem Speichern (E-170 ohne UIDPLUS)");
		free(pApp);
	}

	free(pToc);
	free(pQ);
	free(pMb);
	TT_EndTest();
}

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
		// PRUEFER-72 K3: umgedreht ('<' statt '>=') liesse die Schranke genau
		// die gefaehrlichen Listen durch - darum den Rumpf woertlich pruefen.
		TT_CHECK_MSG(QT_Enthaelt(pQ, "static BOOL E170Aufsteigend_Ist(const CDWordArray &a) { for (int i = 1; i < a.GetSize(); i++) { if (a.GetAt(i - 1) >= a.GetAt(i)) return FALSE; } return TRUE; }"),
					 "E170Aufsteigend_Ist prueft nicht mehr 'streng aufsteigend' (E-170, PRUEFER-72 K3)");
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
	Test_E170_Zuordnung();
	Test_E170_OhneUidplus_Stelle(szEudoraDir);
}
