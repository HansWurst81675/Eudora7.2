//
// TestE57E58E75.cpp - Regressionstests zu E-57, E-58 und E-75
//
// E-57: QCWorkbook::IsTabLabelTruncated legte bei jeder Mausbewegung ueber
//       dem Registerkartenstreifen einen CPaintDC an - ausserhalb von
//       WM_PAINT validiert das das Fenster und verschluckt Neuzeichnen.
//       Seither ein CClientDC (nur zum Messen).
// E-58: ein Klick rechts in den Registerkartenstreifen oeffnete den Browser.
//       Die Treffpruefung fuer das (nie gezeichnete) Logo fragte nur nach x.
//       Seither meldet CalcLogoTopLeft bei einer Trefferfrage nie "getroffen".
// E-75: Strg+J filterte nicht, sondern verschob nach Junk. Ohne manuelle
//       Filter stand im else-Zweig CTRL_J_JUNK; seither CTRL_J_FILTER, und
//       Junk bekommt Strg+J nur auf die ausdrueckliche Frage hin.
//
// Gesichert wird die STELLE (Quelltext.h, nur Code).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static char* Abschnitt(const char* szEudoraDir, const char* szDatei, const char* szVon, const char* szBis)
{
	char* pText = QT_LiesNurCode(szEudoraDir, szDatei);
	if (!pText)
	{
		TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", szDatei);
		return NULL;
	}
	char* pAb = QT_Abschnitt(pText, szVon, szBis);
	if (!pAb)
		TT_Fail("%s: '%s' nicht gefunden - der Test passt nicht mehr zur Stelle", szDatei, szVon);
	free(pText);
	return pAb;
}

void RunE57E58E75Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-57 (Quelltext): IsTabLabelTruncated misst mit CClientDC, nicht mit CPaintDC");
	char* p = Abschnitt(szEudoraDir, "workbook.cpp", "BOOL QCWorkbook::IsTabLabelTruncated(", "return retval;");
	if (p)
	{
		TT_CHECK_MSG(QT_Enthaelt(p, "CClientDC dc(this);"), "IsTabLabelTruncated legt keinen CClientDC mehr an");
		TT_CHECK_MSG(!QT_Enthaelt(p, "CPaintDC"), "IsTabLabelTruncated legt wieder einen CPaintDC an - ausserhalb von WM_PAINT verschluckt das Neuzeichnen (E-57)");
		free(p);
	}
	TT_EndTest();

	TT_BeginTest("E-58 (Quelltext): ein Klick in den Registerkartenstreifen trifft nie das (ungezeichnete) Logo");
	p = Abschnitt(szEudoraDir, "workbook.cpp", "BOOL QCWorkbook::CalcLogoTopLeft(", "BOOL QCWorkbook::OnSetCursor(");
	if (p)
	{
		const long lFrueh = QT_Stelle(p, "if (pIntersectPoint != NULL) return FALSE;");
		const long lTreff = QT_Stelle(p, "pIntersectPoint->x >= nLeftEdge");
		TT_CHECK_MSG(lFrueh >= 0, "CalcLogoTopLeft kehrt bei einer Trefferfrage nicht mehr sofort mit FALSE zurueck - der rechte Rand oeffnet wieder den Browser (E-58)");
		TT_CHECK_MSG(lTreff < 0 || lTreff > lFrueh, "die alte Treffpruefung (nur x) steht vor der fruehen Rueckkehr");
		free(p);
	}
	TT_EndTest();

	TT_BeginTest("E-75 (Quelltext): ohne Rueckfrage bekommt Strg+J das Filtern, nicht Junk");
	p = Abschnitt(szEudoraDir, "mainfrm.cpp", "void CMainFrame::InitJunkMenus()", "SetIniShort(IDS_INI_WHO_GETS_CTRL_J, sCtrlJ);");
	if (p)
	{
		TT_CHECK_MSG(QT_Zaehle(p, "sCtrlJ = CTRL_J_JUNK;") == 1, "CTRL_J_JUNK wird nicht genau einmal gesetzt - es gehoert nur in den Zweig nach der ausdruecklichen Frage");
		TT_CHECK_MSG(QT_Enthaelt(p, "if (iResult == IDOK) { sCtrlJ = CTRL_J_JUNK; }"), "CTRL_J_JUNK steht nicht mehr allein hinter der Zustimmung im Dialog");
		TT_CHECK_MSG(QT_Enthaelt(p, "} else { sCtrlJ = CTRL_J_FILTER; } } SetIniShort(IDS_INI_WHO_GETS_CTRL_J, sCtrlJ);"),
					 "ohne manuelle Filter bekommt Strg+J nicht mehr das Filtern (E-75)");
		free(p);
	}
	TT_EndTest();
}
