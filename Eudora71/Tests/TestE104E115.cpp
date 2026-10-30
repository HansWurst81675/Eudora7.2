//
// TestE104E115.cpp - Regressionstests zu E-104 und E-115
//
// E-104: die Kopfzeilen einer gespeicherten Nachricht klebten zusammen
//        ("From: ... <...> Subject: ..."). UnwrapText lief ueber den GANZEN
//        Text, also auch ueber die Kopfzeilen, und fuegte sie zu einer Zeile.
//        Seither laeuft es nur ueber den Rumpf (FindBody), an drei Stellen:
//        compmsgd.cpp und zweimal ReadMessageDoc.cpp.
// E-115: Ctrl+F (Find Messages) brachte "Encountered an improper argument".
//        CMBoxTreeCtrlCheck::FindCheck sprang mit GetNextSiblingItem ueber
//        den Ordner "Recent" - der ist der LETZTE Eintrag, hItem wurde NULL,
//        und GetItemData(NULL) warf unter MFC 14.
//
// Beide Stellen haengen an Dokument, Datei bzw. Baumsteuerelement - der
// Pruefstand liest deshalb die STELLE (Quelltext.h, nur Code).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E104(const char* szEudoraDir)
{
	TT_BeginTest("E-104 (Quelltext): UnwrapText laeuft beim Speichern nur ueber den Rumpf, nie ueber die Kopfzeilen");
	static const char* aDateien[] = { "compmsgd.cpp", "ReadMessageDoc.cpp" };
	static const int   aErwartet[] = { 1, 2 };
	for (int i = 0; i < 2; i++)
	{
		char* pText = QT_LiesNurCode(szEudoraDir, aDateien[i]);
		if (!pText)
		{
			TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", aDateien[i]);
			continue;
		}
		const int iGanz  = QT_Zaehle(pText, "::UnwrapText( CopyText )") + QT_Zaehle(pText, "::UnwrapText(CopyText)");
		const int iRumpf = QT_Zaehle(pText, "? (char*) ::FindBody( CopyText ) : CopyText;");
		if (iGanz)
			TT_Fail("%s: UnwrapText laeuft %d-mal ueber den ganzen Text samt Kopfzeilen (E-104)", aDateien[i], iGanz);
		if (iRumpf != aErwartet[i])
			TT_Fail("%s: %d statt %d Stellen suchen den Rumpf mit FindBody, bevor UnwrapText laeuft", aDateien[i], iRumpf, aErwartet[i]);
		free(pText);
	}
	TT_EndTest();
}

static void Test_E115(const char* szEudoraDir)
{
	TT_BeginTest("E-115 (Quelltext): FindCheck springt ueber den Ordner Recent, ohne auf NULL zuzugreifen");
	char* pText = QT_LiesNurCode(szEudoraDir, "MBoxTreeCtrlCheck.cpp");
	if (!pText)
	{
		TT_Fail("MBoxTreeCtrlCheck.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "HTREEITEM CMBoxTreeCtrlCheck::FindCheck(", "return (NULL); }");
	TT_CHECK_MSG(pFn != NULL, "CMBoxTreeCtrlCheck::FindCheck nicht gefunden");
	if (pFn)
	{
		const long lSprung = QT_Stelle(pFn, "if (hItem == m_hRecentFolderItem) { hItem = GetNextTraversalItem(hItem, false); if (!hItem) break; }");
		const long lDaten  = QT_Stelle(pFn, "GetItemData(hItem);");
		TT_CHECK_MSG(lSprung >= 0, "der Sprung ueber Recent fragt nicht mehr auf NULL ab, bevor GetItemData kommt (E-115)");
		TT_CHECK_MSG(lSprung >= 0 && lDaten > lSprung, "GetItemData steht vor dem Sprung ueber Recent");
		TT_CHECK_MSG(!QT_Enthaelt(pFn, "GetNextSiblingItem(hItem)"), "FindCheck springt wieder mit GetNextSiblingItem - nach Recent gibt es keinen Geschwisterknoten (E-115)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

void RunE104E115Tests(const char* szEudoraDir)
{
	Test_E104(szEudoraDir);
	Test_E115(szEudoraDir);
}
