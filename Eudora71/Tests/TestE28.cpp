//
// TestE28.cpp - Regressionstest zu E-28 (Doppelklick oeffnet keine Nachricht)
//
// E-28: ein Doppelklick oeffnete keine Nachricht, Suchtreffer liessen sich
// nicht anklicken. CSummary::m_FrameWnd zeigte nach dem Schliessen des
// Nachrichtenfensters weiter auf das zerstoerte Fenster; Display() hielt die
// Nachricht fuer offen und aktivierte nur den toten Zeiger.
//
// Drei Stellen sichern das heute:
//   1. CMessageFrame::ActivateFrame merkt sich die Zusammenfassung
//      (m_pSumBackPtr), damit OnDestroy sie auch ohne Dokument findet.
//   2. CMessageFrame::OnDestroy loescht m_FrameWnd, wenn er auf dieses
//      Fenster zeigt - ueber das Dokument UND ueber m_pSumBackPtr.
//   3. CSummary::Display verwirft einen m_FrameWnd, dessen Fenster nicht
//      mehr existiert.
//
// Gesichert wird die STELLE (Quelltext.h, nur Code).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE28Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-28 (Quelltext): ein geschlossenes Nachrichtenfenster bleibt nicht als offen in der Zusammenfassung stehen");

	char* pFrame = QT_LiesNurCode(szEudoraDir, "msgframe.cpp");
	char* pSum   = QT_LiesNurCode(szEudoraDir, "summary.cpp");
	if (!pFrame || !pSum)
	{
		TT_Fail("msgframe.cpp oder summary.cpp nicht lesbar - ungeprueft ist nicht gruen");
		free(pFrame); free(pSum); TT_EndTest(); return;
	}

	char* pAkt = QT_Abschnitt(pFrame, "void CMessageFrame::ActivateFrame(", "QCProtocol * CMessageFrame::GetProtocol(");
	TT_CHECK_MSG(pAkt && QT_Enthaelt(pAkt, "Sum->m_FrameWnd = this; m_pSumBackPtr = Sum;"),
				 "ActivateFrame merkt sich die Zusammenfassung nicht mehr in m_pSumBackPtr");
	free(pAkt);

	char* pZu = QT_Abschnitt(pFrame, "void CMessageFrame::OnDestroy()", "LRESULT CMessageFrame::WindowProc(");
	TT_CHECK_MSG(pZu != NULL, "CMessageFrame::OnDestroy nicht gefunden");
	if (pZu)
	{
		TT_CHECK_MSG(QT_Enthaelt(pZu, "if (Sum != NULL && Sum->m_FrameWnd == this) Sum->m_FrameWnd = NULL;"),
					 "OnDestroy loescht m_FrameWnd ueber das Dokument nicht mehr (E-28)");
		TT_CHECK_MSG(QT_Enthaelt(pZu, "m_pSumBackPtr->m_FrameWnd == this)") && QT_Enthaelt(pZu, "m_pSumBackPtr->m_FrameWnd = NULL;"),
					 "OnDestroy loescht m_FrameWnd ueber m_pSumBackPtr nicht mehr - ohne Dokument bleibt der tote Zeiger stehen (E-28)");
		free(pZu);
	}

	char* pDisp = QT_Abschnitt(pSum, "BOOL CSummary::Display()", "}");
	TT_CHECK_MSG(pDisp && QT_Enthaelt(pDisp, "if (m_FrameWnd && !::IsWindow(m_FrameWnd->GetSafeHwnd())) m_FrameWnd = NULL;"),
				 "CSummary::Display verwirft einen toten m_FrameWnd nicht mehr - Doppelklick aktiviert dann ein zerstoertes Fenster (E-28)");
	free(pDisp);

	free(pFrame);
	free(pSum);
	TT_EndTest();
}
