//
// TestE86.cpp - Regressionstest zu E-86 (Newsletter auf weissem Grund)
//
// E-86, behoben in 7.2.0.55, am laufenden Programm gemessen: eine
// Newsletter-Mail stand in Eudora auf weissem Grund, das Logo in einem Kasten
// mit Rand. MSHTML renderte die Anzeigedatei im Kompatibilitaetsmodus von
// IE 7. Seither steht als ERSTE Zeile der Anzeigedatei
//     <meta http-equiv="X-UA-Compatible" content="IE=edge">
// - sie wirkt nur, wenn sie vor allem anderen im Kopf steht.
//
// Gesichert wird die STELLE (Quelltext.h, nur Code).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE86Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-86 (Quelltext): die Anzeigedatei verlangt den modernsten MSHTML-Modus, und zwar als erste Zeile");
	char* pText = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	if (!pText)
	{
		TT_Fail("TridentView.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	TT_CHECK_MSG(QT_Enthaelt(pText, "szKompatibilitaet[] = \"<meta http-equiv=\\\"X-UA-Compatible\\\" content=\\\"IE=edge\\\">\\r\\n\";"),
				 "die Zeile X-UA-Compatible IE=edge ist nicht mehr definiert - MSHTML faellt in den IE-7-Modus (E-86)");
	const long lKompat  = QT_Stelle(pText, "theFile.Write( szKompatibilitaet, sizeof(szKompatibilitaet) - 1 );");
	const long lCharset = QT_Stelle(pText, "theFile.Write( szCharsetMeta, sizeof(szCharsetMeta) - 1 );");
	const long lStil    = QT_Stelle(pText, "theFile.Write( szStyleSheet, szStyleSheet.GetLength() );");
	TT_CHECK_MSG(lKompat >= 0, "die Zeile X-UA-Compatible wird nicht mehr geschrieben (E-86)");
	TT_CHECK_MSG(lKompat >= 0 && lCharset > lKompat && lStil > lKompat,
				 "X-UA-Compatible steht nicht mehr VOR Zeichensatz und Stilvorlage - MSHTML beachtet es dann nicht");
	free(pText);
	TT_EndTest();
}
