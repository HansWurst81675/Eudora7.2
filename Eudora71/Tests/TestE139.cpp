//
// TestE139.cpp - Regressionstest zu E-139
//
// E-139: die Meldung "Rechtschreibpruefung nicht verfuegbar" kam nach JEDEM
//        Programmstart wieder. ZeigeHinweisEinmal (spell.cpp) zeigte sie mit
//        AfxMessageBox, gemerkt wurde nur in einem statischen Merker, der
//        einen Lauf lebt. Gregor am 23.10.2026: es braucht ein Kaestchen,
//        "um nicht bei jeder gelegenheit daran erinnert zu werden".
//        Jetzt NoteDialog mit dem INI-Schalter WarnSpellUnavailable
//        (Vorgabe 1); das Kaestchen setzt ihn auf 0.
//
// Der Dialog haengt am Fenster - der Pruefstand liest die STELLE
// (Quelltext.h, nur Code) und die Ressource.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E139_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-139 (Quelltext): der Rechtschreibhinweis ist dauerhaft abschaltbar (NoteDialog, WarnSpellUnavailable)");
	char* pText = QT_LiesNurCode(szEudoraDir, "spell.cpp");
	if (!pText)
	{
		TT_Fail("spell.cpp nicht lesbar - ungeprueft ist nicht gruen");
		return;
	}
	char* pFn = QT_Abschnitt(pText, "static void ZeigeHinweisEinmal()", "NoteDialog(IDS_INI_WARN_SPELL_UNAVAILABLE, IDS_SPELL_NICHT_VORHANDEN); }");
	TT_CHECK_MSG(pFn != NULL, "ZeigeHinweisEinmal endet nicht mehr mit NoteDialog(IDS_INI_WARN_SPELL_UNAVAILABLE, ...) - die Meldung hat kein Kaestchen (E-139)");
	if (pFn)
	{
		const long lAbfrage = QT_Stelle(pFn, "if (!GetIniShort(IDS_INI_WARN_SPELL_UNAVAILABLE)) {");
		const long lDialog  = QT_Stelle(pFn, "NoteDialog(IDS_INI_WARN_SPELL_UNAVAILABLE,");
		TT_CHECK_MSG(lAbfrage >= 0 && lAbfrage < lDialog, "der Schalter wird vor NoteDialog nicht abgefragt - abgeschaltet kaeme die Meldung trotzdem (E-139)");
		TT_CHECK_MSG(QT_Zaehle(pFn, "return;") == 2, "ZeigeHinweisEinmal hat nicht genau zwei Ausstiege (Merker, Schalter) (E-139)");
		free(pFn);
	}
	TT_CHECK_MSG(!QT_Enthaelt(pText, "AfxMessageBox("), "spell.cpp zeigt wieder eine AfxMessageBox ohne Kaestchen (E-139)");
	free(pText);
}

static void Test_E139_Ressource(const char* szEudoraDir)
{
	TT_BeginTest("E-139 (Ressource): WarnSpellUnavailable hat die Vorgabe 1 und liegt im Bereich der INI-Schalter");
	char* pRc = QT_LiesNurCode(szEudoraDir, "EudoraRes.rc");
	char* pH  = QT_LiesNurCode(szEudoraDir, "resource.h");
	if (!pRc || !pH)
	{
		TT_Fail("EudoraRes.rc oder resource.h nicht lesbar - ungeprueft ist nicht gruen");
		if (pRc) free(pRc);
		if (pH) free(pH);
		return;
	}
	TT_CHECK_MSG(QT_Enthaelt(pRc, "IDS_INI_WARN_SPELL_UNAVAILABLE \"WarnSpellUnavailable\n1\""), "WarnSpellUnavailable fehlt oder hat nicht die Vorgabe 1 - dann kaeme die Meldung nie (E-139)");
	TT_CHECK_MSG(QT_Enthaelt(pRc, "IDS_SPELL_NICHT_VORHANDEN \""), "der Meldungstext IDS_SPELL_NICHT_VORHANDEN fehlt (E-139)");
	TT_CHECK_MSG(QT_Enthaelt(pH, "#define IDS_INI_WARN_SPELL_UNAVAILABLE 11152"), "IDS_INI_WARN_SPELL_UNAVAILABLE ist nicht 11152 (Bereich 11100-11999, [Settings]) (E-139)");
	free(pRc);
	free(pH);
}

void RunE139Tests(const char* szEudoraDir)
{
	Test_E139_Stelle(szEudoraDir);
	Test_E139_Ressource(szEudoraDir);
}
