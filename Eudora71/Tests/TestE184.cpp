//
// TestE184.cpp - Befunde E-184 und E-189: Verschieben innerhalb eines
// IMAP-Kontos.
//
// E-184: nach dem Kopieren suchte Eudora die Vorab-Kopie im Ziel unter der
// alten UID und traf eine fremde Mail mit derselben Nummer (gemessen an
// 7.2.1.130, tools/messen-e184.ps1). Behoben ueber ein Merkzeichen an der
// Vorab-Kopie. Rest K3 (PRUEFER-75): bei mehreren Mails ordnete Eudora die
// neuen UIDs nach der Reihenfolge der eigenen Liste zu, die der Ansicht folgt;
// jetzt ueber die Quellmenge aus "[COPYUID v quelle ziel]" (RFC 4315).
// E-189: ohne COPYUID blieb die Vorab-Kopie mit der alten UID stehen - sie
// wird jetzt entfernt (gemessen, tools/messen-e189.ps1).
//
// Teil 1 ruft den Mengenleser selbst auf (Imapdll/src/UidMenge.h), Teil 2
// prueft die Kette am Quelltext - die Wege haengen an Server, Warteschlange
// und CTocDoc und lassen sich ohne Programm nicht aufrufen.
//
#include <afx.h>
#include <afxcoll.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"
#include "..\Imapdll\src\UidMenge.h"

static bool Gleich(const CDWordArray& a, const DWORD* soll, int n)
{
	if (a.GetSize() != n) return false;
	for (int i = 0; i < n; i++)
		if (a.GetAt(i) != soll[i]) return false;
	return true;
}

static void Lies(const char* sz, CDWordArray& aus, int& n)
{
	aus.RemoveAll();
	n = E184UidMengeLesen(sz, (int) strlen(sz), &aus);
}

static void Test_E184_Mengenleser()
{
	TT_BeginTest("E-184 K3: UID-Mengen aus COPYUID werden vollstaendig gelesen (Listen, Bereiche, fallend)");
	CDWordArray a; int n;

	{ static const DWORD s[] = {5};          Lies("5", a, n);        TT_CHECK_MSG(n == 1 && Gleich(a, s, 1), "\"5\" falsch gelesen"); }
	{ static const DWORD s[] = {2,3,4};      Lies("2:4", a, n);      TT_CHECK_MSG(n == 3 && Gleich(a, s, 3), "\"2:4\" falsch gelesen"); }
	{ static const DWORD s[] = {7,8,9};      Lies("9:7", a, n);      TT_CHECK_MSG(n == 3 && Gleich(a, s, 3), "\"9:7\" (fallend, RFC 3501) falsch gelesen"); }
	{ static const DWORD s[] = {2,5,9};      Lies("2,5,9", a, n);    TT_CHECK_MSG(n == 3 && Gleich(a, s, 3), "\"2,5,9\" falsch gelesen - der alte Leser verstand keine Listen"); }
	{ static const DWORD s[] = {10,11,12,15}; Lies("10:12,15", a, n); TT_CHECK_MSG(n == 4 && Gleich(a, s, 4), "\"10:12,15\" falsch gelesen"); }

	// Verdorbenes darf nichts anhaengen.
	const char* boese[] = { ",", "2,", ",2", "a", "0", "*", "3:", "2;5", "1:99999999", "12345678901",
							"4294967296", "4294967297", "4294967300", "1:4294967297" };	// PRUEFER-78 K3: Ueberlauf
	// PRUEFER-79 K4: "4294967296" liefe auf 0 und waere ohnehin abgewiesen -
	// "4294967300" liefe auf 4 und belegt die Pruefung wirklich (oben in "boese").
	{ static const DWORD s[] = {4294967295UL}; Lies("4294967295", a, n); TT_CHECK_MSG(n == 1 && Gleich(a, s, 1), "\"4294967295\" (groesste UID) falsch gelesen"); }
	{ static const DWORD s[] = {4294967294UL, 4294967295UL}; Lies("4294967294:4294967295", a, n); TT_CHECK_MSG(n == 2 && Gleich(a, s, 2), "Bereich an der Obergrenze falsch gelesen (Schleife darf nicht ueberlaufen)"); }
	for (int i = 0; i < (int) (sizeof(boese) / sizeof(boese[0])); i++)
	{
		a.RemoveAll(); a.Add(77);
		n = E184UidMengeLesen(boese[i], (int) strlen(boese[i]), &a);
		CString m; m.Format("\"%s\" muss abgewiesen werden und darf nichts anhaengen", boese[i]);
		TT_CHECK_MSG(n == -1 && a.GetSize() == 1 && a.GetAt(0) == 77, (LPCTSTR) m);
	}
	a.RemoveAll();
	TT_CHECK_MSG(E184UidMengeLesen("", 0, &a) == -1 && a.GetSize() == 0, "leere Menge muss abgewiesen werden");

	// Laengenangabe wird eingehalten (die Menge steht mitten in der Antwortzeile).
	{ static const DWORD s[] = {2,5}; const char* z = "2,5 10:11]"; a.RemoveAll(); n = E184UidMengeLesen(z, 3, &a); TT_CHECK_MSG(n == 2 && Gleich(a, s, 2), "Leser liest ueber die angegebene Laenge hinaus"); }

	// Der Fall aus K3: Ansicht absteigend (9,5,2), Server antwortet in UID-Folge.
	{
		CDWordArray q, z; int nq, nz;
		Lies("2,5,9", q, nq); Lies("10:12", z, nz);
		TT_CHECK_MSG(nq == 3 && nz == 3, "COPYUID-Beispiel nicht gelesen");
		if (nq == 3 && nz == 3)
		{
			// alte UID 9 (erste Zeile der Ansicht) gehoert zur neuen 12, nicht zur 10
			int j = 0; while (j < 3 && q.GetAt(j) != 9) j++;
			TT_CHECK_MSG(j == 2 && z.GetAt(j) == 12, "alte UID 9 wird nicht der neuen 12 zugeordnet (E-184 K3)");
		}
	}
	TT_EndTest();
}

static void Test_E184_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-184/E-189 (Quelltext): Merkzeichen, Zuordnung ueber die Quellmenge, Entfernen ohne neue UID");
	char* pToc   = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pQ     = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
	char* pProto = QT_LiesNurCode(szEudoraDir, "..\\Imapdll\\src\\proto.cpp");
	char* pXfer  = QT_LiesNurCode(szEudoraDir, "tocdoc.cpp");
	if (!pToc || !pQ || !pProto || !pXfer)
	{
		TT_Fail("ImapToc.cpp, ImapActionQueue.cpp, proto.cpp oder tocdoc.cpp nicht lesbar - ungeprueft ist nicht gruen");
		if (pToc) free(pToc);
		if (pQ) free(pQ);
		if (pProto) free(pProto);
		if (pXfer) free(pXfer);
		TT_EndTest();
		return;
	}

	// 1. Die Vorab-Kopie wird von IMAP nach IMAP markiert (CTocDoc::Xfer).
	TT_CHECK_MSG(QT_Enthaelt(pXfer, "if (IsImapToc() && TargetToc->IsImapToc())") &&
				 QT_Enthaelt(pXfer, "CopySum->SetE184Vorab(TRUE);"),
				 "CTocDoc::Xfer markiert die Vorab-Kopie IMAP -> IMAP nicht mehr (E-184)");

	// 2. ImapTransferSummaryData: nur die markierte Kopie, Zuordnung ueber die Quellmenge.
	char* pTsd = QT_Abschnitt(pToc, "CSummary *CTocDoc::ImapTransferSummaryData(", "unsigned long E121NeueKennung(");
	if (!pTsd)
		TT_Fail("ImapTransferSummaryData nicht gefunden - ungeprueft ist nicht gruen (E-184)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pTsd, "pSumNew = E184FindeVorabKopie(pTargetToc, lOldUID);"),
					 "ImapTransferSummaryData sucht wieder irgendeine Zusammenfassung mit der alten UID (E-184)");
		TT_CHECK_MSG(!QT_Enthaelt(pTsd, "pSumNew = pTargetToc->GetSummaryFromUID(lOldUID);"),
					 "die alte Suche ueber GetSummaryFromUID(lOldUID) im Ziel steht wieder da (E-184)");
		TT_CHECK_MSG(QT_Enthaelt(pTsd, "lNewUID = pdwaNewUIDs->ElementAt(j);"),
					 "ImapTransferSummaryData ordnet nicht ueber die Quellmenge zu (E-184 K3)");
		// Im Schleifenkopf, nicht in der Deklaration davor (die heisst ebenfalls
		// "pSumNew = NULL;" - erster Stand dieses Tests fand sie und war rot).
		char* pKopf = QT_Abschnitt(pTsd, "while (!strUIDList.IsEmpty() && (i < iSize))", "lOldUID = atoi(strOldUID);");
		TT_CHECK_MSG(pKopf && QT_Enthaelt(pKopf, "pSumNew = NULL;") && QT_Enthaelt(pKopf, "bFoundNew = true;"),
					 "pSumNew/bFoundNew werden nicht je Durchlauf zurueckgesetzt - zweites AddSum nach einem Fehltreffer (E-184 K3)");
		if (pKopf) free(pKopf);
		free(pTsd);
	}

	// 3. Die Nachbearbeitung gibt die Quellmenge weiter und raeumt danach ab.
	char* pPost = QT_Abschnitt(pQ, "void CImapTransferMsgAction::DoPostProcessing()", "void CImapTransferMsgAction::SetDestAccountID(");
	if (!pPost)
		TT_Fail("CImapTransferMsgAction::DoPostProcessing nicht gefunden - ungeprueft ist nicht gruen (E-184/E-189)");
	else
	{
		const long lTsd = QT_Stelle(pPost, "ImapTransferSummaryData(");
		const long lQ   = QT_Stelle(pPost, "&m_dwaQuellUIDs);");
		const long lRm  = QT_Stelle(pPost, "E189VorabKopienEntfernen(m_pDestTocDoc, m_szMessageIDs);");
		TT_CHECK_MSG(lQ > lTsd && lTsd >= 0, "DoPostProcessing gibt die Quellmenge nicht an ImapTransferSummaryData (E-184 K3)");
		TT_CHECK_MSG(lRm > lTsd, "E189VorabKopienEntfernen fehlt oder laeuft vor ImapTransferSummaryData (E-189)");
		free(pPost);
	}
	TT_CHECK_MSG(QT_Enthaelt(pQ, "&m_dwaQuellUIDs);\t// E-184 K3\n") || QT_Enthaelt(pQ, "&m_dwaQuellUIDs);"),
				 "die Uebertragung holt die Quellmenge nicht vom Server (E-184 K3)");

	// 4. E-189: Entfernen fragt ein offenes Fenster erst (PRUEFER-76 K1).
	char* pRm = QT_Abschnitt(pToc, "void E189VorabKopienEntfernen(", "CSummary *CTocDoc::GetSummaryFromUID(");
	if (!pRm)
		TT_Fail("E189VorabKopienEntfernen nicht gefunden - ungeprueft ist nicht gruen (E-189)");
	else
	{
		TT_CHECK_MSG(QT_Stelle(pRm, "pSum->SetE184Vorab(FALSE);") >= 0 &&
					 QT_Stelle(pRm, "pSum->SetE184Vorab(FALSE);") < QT_Stelle(pRm, "CanCloseFrame(pFenster)"),
					 "Merkzeichen wird nicht vor der Fensterfrage geloescht - Endlosschleife (PRUEFER-76 K1)");
		TT_CHECK_MSG(QT_Stelle(pRm, "CanCloseFrame(pFenster)") >= 0 &&
					 QT_Stelle(pRm, "CanCloseFrame(pFenster)") < QT_Stelle(pRm, "pZiel->RemoveSum(pSum);"),
					 "E189VorabKopienEntfernen entfernt, ohne ein offenes Fenster zu fragen (PRUEFER-76 K1)");
		free(pRm);
	}

	// 5. proto.cpp: beide Mengen aus COPYUID, nur gemeinsam uebernommen.
	char* pStore = QT_Abschnitt(pProto, "void CProtocol::StoreUIDPLUSResponses(", "void CProtocol::VerifyUIDValidity(");
	if (!pStore)
		TT_Fail("StoreUIDPLUSResponses nicht gefunden - ungeprueft ist nicht gruen (E-184 K3)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pStore, "E184UidMengeLesen(pQuelle,") && QT_Enthaelt(pStore, "E184UidMengeLesen(s,"),
					 "StoreUIDPLUSResponses liest Quell- oder Zielmenge nicht mit dem vollstaendigen Leser (E-184 K3)");
		TT_CHECK_MSG(QT_Enthaelt(pStore, "if (nQ > 0 && nQ == nZ)"),
					 "StoreUIDPLUSResponses uebernimmt die Mengen auch bei ungleicher Anzahl (E-184 K3)");
		free(pStore);
	}

	free(pToc); free(pQ); free(pProto); free(pXfer);
	TT_EndTest();
}

void RunE184Tests(const char* szEudoraDir)
{
	Test_E184_Mengenleser();
	Test_E184_Stelle(szEudoraDir);
}
