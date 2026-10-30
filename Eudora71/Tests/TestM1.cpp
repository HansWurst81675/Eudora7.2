//
// TestM1.cpp - Regressionstest zu M-1 (Menues liessen sich nicht oeffnen)
//
// M-1: der Rahmen lieferte immer HTERROR, weil m_bMainFrameEnabled in der
// Ersatzschicht mit TRUE begann - TRUE heisst "das Anpassen der Leisten
// laeuft", und dann ist die ganze Nichtklientenflaeche tot: Menueleiste,
// Titelzeile, Rahmenkanten. Seither ist der Ausgangswert FALSE, und
// RestoreMainFrame (aus ~SECToolBarCmdPage, beim Schliessen des
// Anpassen-Dialogs) setzt ihn wieder auf FALSE.
//
// Dieser Test RUFT die echten Funktionen aus OTShim_Werkzeugleiste.cpp auf
// (das Testprojekt baut die Datei mit). Ohne Rahmenfenster: Enable und
// Restore laufen dann nur ueber die leere Fensterliste.
//
#include <afxwin.h>
#include <stdio.h>
#include <string.h>

#include "TinyTest.h"
#include "TestRes.h"
#include "OTShim_Werkzeugleiste.h"

void RunM1Tests(void)
{
	TT_BeginTest("M-1: der Werkzeugleisten-Verwalter beginnt NICHT im Anpassen-Zustand und kehrt dorthin zurueck");
	{
		SECToolBarManager verwalter;
		TT_CHECK_MSG(verwalter.IsMainFrameEnabled() == FALSE,
					 "ein frischer SECToolBarManager meldet den Anpassen-Zustand - der Rahmen liefert dann HTERROR, die Menues sind tot (M-1)");

		verwalter.EnableMainFrame();		// Anpassen-Dialog oeffnet
		TT_CHECK_MSG(verwalter.IsMainFrameEnabled() == TRUE, "Gegenprobe: EnableMainFrame setzt den Anpassen-Zustand nicht");

		verwalter.RestoreMainFrame();		// Anpassen-Dialog schliesst
		TT_CHECK_MSG(verwalter.IsMainFrameEnabled() == FALSE,
					 "nach RestoreMainFrame bleibt der Anpassen-Zustand stehen - nach dem ersten Anpassen waeren die Menues tot (M-1)");
	}
	TT_EndTest();
}
