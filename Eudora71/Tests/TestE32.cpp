//
// TestE32.cpp - Regressionstest zu E-32 (pField ungeprueft dereferenziert)
//
// E-32: die modale Meldung "An unhandled exception has occurred" beim
// Verfassen. Die Ursachenbehauptung ist widerlegt (P-3, aufgeklaert hat die
// Meldung E-34), der dabei gefundene Code-Mangel ist aber echt und behoben
// (060a4bf): CHeaderView::OnKillFocusRecipient dereferenzierte pField,
// obwohl GetDlgItem NULL liefert, solange das Kopfzeilenfeld noch nicht
// existiert - die Abfrage drei Zeilen darueber rechnet selbst damit.
//
// Gesichert wird die STELLE (Quelltext.h): vor dem ersten ungeschuetzten
// Zugriff auf pField steht "if (!pField) return;".
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE32Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-32 (Quelltext): OnKillFocusRecipient greift ohne Kopfzeilenfeld nicht auf pField zu");
	char* pText = QT_LiesNurCode(szEudoraDir, "headervw.cpp");
	if (!pText)
	{
		TT_Fail("headervw.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pFn = QT_Abschnitt(pText, "void CHeaderView::OnKillFocusRecipient(UINT nID)", "void CHeaderView::OnKillFocusHeader()");
	TT_CHECK_MSG(pFn != NULL, "CHeaderView::OnKillFocusRecipient nicht gefunden");
	if (pFn)
	{
		const long lHolen    = QT_Stelle(pFn, "CHeaderField* pField = (CHeaderField*)GetDlgItem(nID);");
		const long lGeschuetzt = QT_Stelle(pFn, "if (pField && pField->m_ACListBox) pField->m_ACListBox->KillACListBox();");
		const long lWache    = QT_Stelle(pFn, "if (!pField) return;");
		TT_CHECK_MSG(lHolen >= 0, "pField wird nicht mehr ueber GetDlgItem geholt - der Test passt nicht mehr zur Funktion");
		TT_CHECK_MSG(lWache > lHolen, "die Wache 'if (!pField) return;' fehlt oder steht vor GetDlgItem");

		// Jeder Zugriff "pField->" vor der Wache muss der geschuetzte sein.
		if (lWache > 0)
		{
			int iVorher = 0;
			const char* p = pFn;
			while ((p = strstr(p, "pField->")) != NULL && (p - pFn) < lWache)
			{
				const long l = (long) (p - pFn);
				if (lGeschuetzt < 0 || l < lGeschuetzt || l > lGeschuetzt + 80)
					iVorher++;
				p += 8;
			}
			if (iVorher)
				TT_Fail("%d ungeschuetzte(r) Zugriff(e) auf pField vor der Wache - der Mangel aus E-32", iVorher);

			// Und dahinter kommt der Zugriff, den die Wache schuetzt.
			TT_CHECK_MSG(QT_Stelle(pFn, "pField->IsKindOf(RUNTIME_CLASS(CHeaderField))") > lWache,
						 "der Zugriff pField->IsKindOf steht nicht hinter der Wache");
		}
		free(pFn);
	}

	free(pText);
	TT_EndTest();
}
