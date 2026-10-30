//
// TestE60.cpp - Regressionstest zu E-60 (Trennbalken waehrend des Ziehens geloescht)
//
// E-60, behoben in 7.2.0.29, von Gregor an 1.0.84 bestaetigt, gefunden von
// PRUEFER-6: Splitter::Track verteilt fremde Nachrichten, eine davon kann
// einen Anordnungsdurchlauf ausloesen, und der lief durch
// BeginRecycleSplitters/EndRecycleSplitters - dort wurde genau der Balken
// geloescht, in dessen Track man sich noch befand. Benutzung nach dem
// Freigeben.
//
// Seither haelt die Marke m_bTracking den ziehenden Balken fest:
// BeginRecycleSplitters gibt ihn nicht frei, EndRecycleSplitters loescht
// ihn nicht, AddSplitter verwendet ihn nicht fuer einen anderen Platz.
//
// Dieser Test RUFT die echten Funktionen aus OTShim.cpp auf (das Testprojekt
// baut OTShim.cpp mit). Er stellt den Anordnungsdurchlauf nach, der mitten
// im Ziehen kommt: Begin, keinen Balken neu anlegen, End.
//
#include <afx.h>
#include <afxwin.h>
#include <afxext.h>

#include "TinyTest.h"
#include "OTShim.h"

void RunE60Tests(void)
{
	TT_BeginTest("E-60: ein Trennbalken, der gerade gezogen wird, ueberlebt einen Anordnungsdurchlauf");
	{
		SECDockBar andockleiste;
		andockleiste.AddSplitter(SECDockBar::Splitter::RowSplitter, SECDockBar::Splitter::Horizontal, 0, 0, 100, 4, 1);
		andockleiste.AddSplitter(SECDockBar::Splitter::RowSplitter, SECDockBar::Splitter::Horizontal, 0, 50, 100, 54, 2);
		if (andockleiste.m_arrSplitters.GetSize() != 2)
		{
			TT_Fail("Voraussetzung: nach zwei AddSplitter stehen %d Balken da, erwartet 2", (int) andockleiste.m_arrSplitters.GetSize());
			TT_EndTest();
			return;
		}

		SECDockBar::Splitter* pZieht = andockleiste.GetSplitter(0);
		SECDockBar::Splitter* pRuht  = andockleiste.GetSplitter(1);
		pZieht->m_bTracking = TRUE;			// so setzt es Splitter::Track

		// Der Anordnungsdurchlauf mitten im Ziehen: alles freigeben ...
		andockleiste.BeginRecycleSplitters();
		TT_CHECK_MSG(pZieht->m_bInUse == TRUE, "BeginRecycleSplitters hat den ziehenden Balken zur Wiederverwendung freigegeben");
		TT_CHECK_MSG(pRuht->m_bInUse == FALSE, "Gegenprobe: der ruhende Balken wurde NICHT freigegeben - der Durchlauf tut nichts mehr");

		// ... ein neuer Balken darf den ziehenden nicht umwidmen ...
		andockleiste.AddSplitter(SECDockBar::Splitter::BarSplitter, SECDockBar::Splitter::Vertical, 10, 0, 14, 40, 3);
		TT_CHECK_MSG(pZieht->m_nPos == 1 && pZieht->m_type == SECDockBar::Splitter::RowSplitter,
					 "AddSplitter hat den ziehenden Balken fuer einen anderen Platz umgewidmet");

		// ... und das Aufraeumen darf ihn nicht loeschen.
		andockleiste.EndRecycleSplitters();
		BOOL bNochDa = FALSE;
		for (int i = 0; i < andockleiste.m_arrSplitters.GetSize(); i++)
			if (andockleiste.GetSplitter(i) == pZieht)
				bNochDa = TRUE;
		TT_CHECK_MSG(bNochDa, "EndRecycleSplitters hat den ziehenden Balken geloescht - Track liefe auf freigegebenem Speicher (E-60)");
		if (andockleiste.m_arrSplitters.GetSize() != 2)
			TT_Fail("nach dem Durchlauf stehen %d Balken da, erwartet 2 (der ziehende und der umgewidmete ruhende)",
					(int) andockleiste.m_arrSplitters.GetSize());

		// Ende des Ziehens: jetzt darf er wieder aufgeraeumt werden.
		pZieht->m_bTracking = FALSE;
		andockleiste.BeginRecycleSplitters();
		andockleiste.EndRecycleSplitters();
		if (andockleiste.m_arrSplitters.GetSize() != 0)
			TT_Fail("Gegenprobe: nach dem Ziehen raeumt der Durchlauf nicht mehr auf (%d Balken uebrig)",
					(int) andockleiste.m_arrSplitters.GetSize());
	}
	TT_EndTest();

	// PRUEFER-66 K2: der Weg, den das Programm wirklich geht, ist OnSize ->
	// TrennbalkenNeuAnlegen -> DeleteAllSplitters. Auch der darf einen
	// ziehenden Balken nicht loeschen.
	TT_BeginTest("E-60: TrennbalkenNeuAnlegen (der Weg aus OnSize) loescht keinen Balken, der gerade gezogen wird");
	{
		struct Leiste : public SECDockBar { void Anordnen() { TrennbalkenNeuAnlegen(); } } andockleiste;
		andockleiste.AddSplitter(SECDockBar::Splitter::RowSplitter, SECDockBar::Splitter::Horizontal, 0, 0, 100, 4, 1);
		SECDockBar::Splitter* pZieht = andockleiste.GetSplitter(0);
		pZieht->m_bTracking = TRUE;
		andockleiste.Anordnen();
		if (andockleiste.m_arrSplitters.GetSize() != 1 || andockleiste.GetSplitter(0) != pZieht)
			TT_Fail("TrennbalkenNeuAnlegen hat den ziehenden Balken geloescht (%d Balken uebrig) - Track liefe auf freigegebenem Speicher",
					(int) andockleiste.m_arrSplitters.GetSize());

		pZieht->m_bTracking = FALSE;
		andockleiste.Anordnen();
		if (andockleiste.m_arrSplitters.GetSize() != 0)
			TT_Fail("Gegenprobe: ohne Ziehen raeumt TrennbalkenNeuAnlegen nicht mehr auf (%d Balken uebrig)",
					(int) andockleiste.m_arrSplitters.GetSize());
	}
	TT_EndTest();
}
