//
// TestE176.cpp - Regressionstest zu Befund E-176 (Quelltext)
//
// Die Behebung von E-28 merkt sich die Zusammenfassung in
// CMessageFrame::m_pSumBackPtr. Wurde die Zusammenfassung vor dem Rahmen
// geloescht (neue Nachricht ohne Speichern geschlossen, oder ein Filter
// verschiebt die offene Nachricht), las OnDestroy aus freigegebenem Speicher.
// Gefunden von PRUEFER-67 K1. Jetzt meldet ~CSummary sich bei allen lebenden
// Rahmen ab.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE176Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-176 (Quelltext): eine geloeschte Zusammenfassung hinterlaesst keinen Rueckzeiger in einem Nachrichtenrahmen");
	char* pSum   = QT_LiesNurCode(szEudoraDir, "summary.cpp");
	char* pFrame = QT_LiesNurCode(szEudoraDir, "msgframe.cpp");
	if (!pSum || !pFrame)
	{
		TT_Fail("summary.cpp oder msgframe.cpp nicht lesbar - ungeprueft ist nicht gruen");
		free(pSum); free(pFrame); TT_EndTest(); return;
	}

	char* pDtor = QT_Abschnitt(pSum, "CSummary::~CSummary() {", "CMessageDoc* Doc = NULL;");
	TT_CHECK_MSG(pDtor && QT_Enthaelt(pDtor, "CMessageFrame::E176ZusammenfassungStirbt(this);"),
				 "~CSummary meldet sich nicht mehr bei den Nachrichtenrahmen ab - OnDestroy liest dann aus freigegebenem Speicher (E-176)");
	free(pDtor);

	char* pFn = QT_Abschnitt(pFrame, "void CMessageFrame::E176ZusammenfassungStirbt(CSummary* pSum) {", "void CMessageFrame::ActivateFrame(");
	TT_CHECK_MSG(pFn && QT_Enthaelt(pFn, "if (p->m_pSumBackPtr == pSum) p->m_pSumBackPtr = NULL;"),
				 "E176ZusammenfassungStirbt loescht den Rueckzeiger nicht mehr (E-176)");
	free(pFn);

	TT_CHECK_MSG(QT_Enthaelt(pFrame, "m_pE176Naechster = s_pE176Erster; s_pE176Erster = this;"),
				 "der Konstruktor traegt den Rahmen nicht mehr in die Kette ein - er bekaeme keine Abmeldung (E-176)");
	TT_CHECK_MSG(QT_Enthaelt(pFrame, "if (*pp == this) { *pp = m_pE176Naechster; break; }"),
				 "der Destruktor nimmt den Rahmen nicht mehr aus der Kette - die Abmeldung liefe ueber einen toten Rahmen (E-176)");

	free(pSum); free(pFrame);
	TT_EndTest();
}
