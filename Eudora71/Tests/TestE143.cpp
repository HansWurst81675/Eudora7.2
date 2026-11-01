//
// TestE143.cpp - Befund E-143: ein Filter mit Ziel Out zeigte je Nachricht
// einen modalen Hinweis, und der automatische Abruf blieb daran stehen.
//
// Gregors Entscheidung vom 01.11.2026: "Out nicht anbieten" - im Transfer-
// Menue einer Postfachauswahl fuer einen Filter ist Out ausgegraut; dazu
// (Gregor: "zusaetzlich eine zeile im log") werden bestehende Filter mit Ziel
// Out ohne Dialog uebergangen und mit einer Zeile im Log gemeldet.
//
// Geprueft am Quelltext: Menue, Schaltflaeche, beide Aufrufer, beide
// Filterwege. Fehlt ein Glied, kommt Out wieder ins Menue oder der Abruf
// bleibt wieder am Dialog stehen.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void PruefeImAbschnitt(const char* pText, const char* szVon, const char* szBis, const char* szSoll, const char* szWas)
{
	char* pFn = QT_Abschnitt(pText, szVon, szBis);
	if (!pFn)
	{
		TT_Fail("%s: Abschnitt nicht gefunden - ungeprueft ist nicht gruen (E-143)", szWas);
		return;
	}
	if (!QT_Enthaelt(pFn, szSoll))
		TT_Fail("%s fehlt (E-143)", szWas);
	free(pFn);
}

static void Test_E143_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-143 (Quelltext): Out wird einem Filter nicht angeboten, und ein Filter mit Ziel Out haelt nichts an");
	char* pMain = QT_LiesNurCode(szEudoraDir, "mainfrm.cpp");
	char* pCtl  = QT_LiesNurCode(szEudoraDir, "controls.cpp");
	char* pFv   = QT_LiesNurCode(szEudoraDir, "filtersv.cpp");
	char* pMf   = QT_LiesNurCode(szEudoraDir, "MakeFilter.cpp");
	char* pFd   = QT_LiesNurCode(szEudoraDir, "filtersd.cpp");
	if (!pMain || !pCtl || !pFv || !pMf || !pFd)
	{
		TT_Fail("eine der Quelldateien ist nicht lesbar - ungeprueft ist nicht gruen");
	}
	else
	{
		PruefeImAbschnitt(pMain, "void CMainFrame::OnUpdateDynamicCommand(", "if( theAction == CA_INSERT_RECIPIENT )",
						  "if (E143OutGesperrt(pCommand, theAction)) { pCmdUI->Enable(FALSE); }",
						  "OnUpdateDynamicCommand: Out ausgrauen waehrend einer Auswahl fuer einen Filter");
		PruefeImAbschnitt(pCtl, "BOOL CMailboxButton::SelectMailbox(", "theTransferMenu->TrackPopupMenu(",
						  "pMainFrame->SetE143OutSperren(m_bE143OhneOut);",
						  "SelectMailbox: Schalter vor dem Aufklappen weitergeben");
		PruefeImAbschnitt(pCtl, "theTransferMenu->TrackPopupMenu(", "if (cmdID)",
						  "pMainFrame->SetE143OutSperren(FALSE);",
						  "SelectMailbox: Schalter nach dem Aufklappen zuruecksetzen (sonst ist Out auch fuer den Anwender grau)");
		PruefeImAbschnitt(pFv, "void CFiltersViewRight::OnMailbox()", "SelectMailbox()",
						  "m_Mailbox[m_ActionIndex].m_bE143OhneOut = TRUE;",
						  "Filterfenster: Out nicht anbieten");
		// PRUEFER-71 K3: die Freigabe laeuft im Filterfenster ueber die
		// Schaltflaeche und bei Make Filter ueber das Postfachfenster - beide
		// muessen fragen, und nach der Wahl wird ein Out verworfen.
		PruefeImAbschnitt(pCtl, "void CMailboxButton::OnUpdateDynamicCommand(", "BOOL CMailboxButton::OnDynamicCommand(",
						  "if (CMainFrame::QCGetMainFrame()->E143OutGesperrt(pCommand, theAction)) { pCmdUI->Enable( FALSE ); return; }",
						  "CMailboxButton::OnUpdateDynamicCommand: Out ausgrauen");
		PruefeImAbschnitt(pCtl, "BOOL CMailboxButton::SelectMailbox(", "if (pCommand)",
						  "if (m_bE143OhneOut && CMainFrame::E143IstOut(pCommand)) { PutDebugLog(DEBUG_MASK_FILTERS, \"E-143 Postfachauswahl fuer einen Filter: Out verworfen\"); pCommand = NULL; }",
						  "SelectMailbox: ein trotzdem gewaehltes Out verwerfen (samt pCommand = NULL, PRUEFER-72 K3)");
		{
			// PRUEFER-72 K1: Make Filter aus dem geoeffneten Nachrichtenfenster
			char* pDoc = QT_LiesNurCode(szEudoraDir, "msgdoc.cpp");
			if (!pDoc)
				TT_Fail("msgdoc.cpp nicht lesbar - ungeprueft ist nicht gruen (E-143)");
			else
			{
				PruefeImAbschnitt(pDoc, "void CMessageDoc::OnUpdateDynamicCommand(", "pCmdUI->Enable( TRUE );",
								  "if (CMainFrame::QCGetMainFrame()->E143OutGesperrt(pCommand, theAction)) { pCmdUI->Enable( FALSE ); return; }",
								  "CMessageDoc::OnUpdateDynamicCommand: Out ausgrauen (Make Filter aus dem Nachrichtenfenster)");
				free(pDoc);
			}
		}
		{
			char* pToc = QT_LiesNurCode(szEudoraDir, "TocFrame.cpp");
			if (!pToc)
				TT_Fail("TocFrame.cpp nicht lesbar - ungeprueft ist nicht gruen (E-143)");
			else
			{
				PruefeImAbschnitt(pToc, "void CTocFrame::OnUpdateDynamicCommand(", "pCmdUI->Enable(m_pSumListBox->GetSelCount() > 0);",
								  "if (CMainFrame::QCGetMainFrame()->E143OutGesperrt(pCommand, theAction)) { pCmdUI->Enable(FALSE); return; }",
								  "CTocFrame::OnUpdateDynamicCommand: Out ausgrauen (Make Filter)");
				free(pToc);
			}
		}
		PruefeImAbschnitt(pMf, "void CMakeFilter::OnMailbox()", "SelectMailbox()",
						  "m_MailboxButton.m_bE143OhneOut = TRUE;",
						  "Make Filter: Out nicht anbieten");

		// Beide Filterwege uebergehen Out mit einer Zeile im Log, und das VOR Xfer.
		const char* aWege[][3] = {
			{ "int CFilter::Action(",     "int CFilter::ImapAction(", "POP-Weg (CFilter::Action)" },
			{ "int CFilter::ImapAction(", NULL,                       "IMAP-Weg (CFilter::ImapAction)" },
		};
		for (int i = 0; i < 2; i++)
		{
			const char* pVon = strstr(pFd, aWege[i][0]);
			if (!pVon)
			{
				TT_Fail("%s: nicht gefunden - ungeprueft ist nicht gruen (E-143)", aWege[i][2]);
				continue;
			}
			const char* pBis = aWege[i][1] ? strstr(pVon + 1, aWege[i][1]) : NULL;
			const size_t nLen = pBis ? (size_t)(pBis - pVon) : strlen(pVon);
			char* pFn = (char*) malloc(nLen + 1);
			if (!pFn) { TT_Fail("Speicher"); continue; }
			memcpy(pFn, pVon, nLen);
			pFn[nLen] = '\0';
			const long lOut  = QT_Stelle(pFn, "->m_Type == MBT_OUT)");
			// PRUEFER-71 G4: ohne das break dahinter kam der Dialog zurueck, und
			// der Test blieb gruen - darum Logzeile UND break gemeinsam suchen.
			const long lLog  = QT_Stelle(pFn, i == 0 ? "PutDebugLog(DEBUG_MASK_FILTERS, szE143); pDestToc = NULL; break;"
													 : "PutDebugLog(DEBUG_MASK_FILTERS, szE143); break;");
			const long lXfer = QT_Stelle(pFn, "->Xfer(");
			if (lOut < 0 || lLog < 0)
				TT_Fail("%s: Out wird nicht uebergangen oder nicht ins Log geschrieben (E-143)", aWege[i][2]);
			else if (lXfer >= 0 && lOut > lXfer)
				TT_Fail("%s: die Pruefung auf Out steht hinter Xfer - der Dialog kaeme trotzdem (E-143)", aWege[i][2]);
			free(pFn);
		}
	}
	free(pMain); free(pCtl); free(pFv); free(pMf); free(pFd);
	TT_EndTest();
}

void RunE143Tests(const char* szEudoraDir)
{
	Test_E143_Stelle(szEudoraDir);
}
