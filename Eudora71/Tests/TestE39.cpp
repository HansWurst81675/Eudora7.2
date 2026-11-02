// TestE39.cpp - Regressionstest zu Befund E-39 (Quelltext).
//
// CPersonality::Remove (persona.cpp) loeschte den Abschnitt
// [Persona-<Name>], liess m_Current aber auf der geloeschten
// Persoenlichkeit stehen. FlushINIFile schreibt SavePassword und
// SavePasswordText in den Abschnitt der AKTUELLEN Persoenlichkeit
// (rs.cpp) - beim naechsten Umschalten oder beim Beenden entstand der
// geloeschte Abschnitt wieder. Gemessen am 02.11.2026 am Pruefstand
// C:\Temp\E39 (tools\messen-e39.ps1, Fall E-39p): abschnitt-wieder=1
// schluessel=SavePasswordText.
//
// Behebung: war die geloeschte die aktuelle, nimmt Remove ihre beiden
// Kennwortschluessel ungeschrieben aus dem Zwischenspeicher, schaltet mit
// SetCurrent(NULL) auf <Dominant> um und vergisst ihr Kennwort im Speicher.
// Die Reihenfolge zaehlt: erst aus dem Zwischenspeicher nehmen, dann
// umschalten - SetCurrent schreibt sonst genau diese Schluessel in den
// geloeschten Abschnitt.
//
// Gegenprobe beim Bau: die Zeile "SetCurrent( NULL );" in Remove
// entfernen -> genau Test_E39_Remove wird rot.

#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E39_Remove(const char* szEudoraDir)
{
	TT_BeginTest("E-39 (Quelltext): CPersonality::Remove schaltet von der geloeschten aktuellen Persoenlichkeit auf <Dominant>");
	char* pText = QT_LiesNurCode(szEudoraDir, "persona.cpp");
	if (!pText)
	{
		TT_Fail("persona.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "BOOL CPersonality::Remove( const char* Name )", "CString CPersonality::GetIniKeyName(");
	TT_CHECK_MSG(pFn != NULL, "CPersonality::Remove nicht gefunden");
	if (pFn)
	{
		const char* pLoesch = strstr(pFn, "WritePrivateProfileString(PersonaID, NULL, NULL, INIPath);");
		const char* pVergl  = strstr(pFn, "m_Current.CompareNoCase( PersonaID ) == 0");
		const char* pCache1 = strstr(pFn, "RemoveIniFromCache( IDS_INI_SAVE_PASSWORD );");
		const char* pCache2 = strstr(pFn, "RemoveIniFromCache( IDS_INI_SAVE_PASSWORD_TEXT );");
		const char* pUmsch  = strstr(pFn, "SetCurrent( NULL );");
		const char* pVergiss = strstr(pFn, "m_Passwords.RemoveKey( PersonaID );");
		TT_CHECK_MSG(pLoesch != NULL, "Remove loescht den Abschnitt nicht mehr wie erwartet - Test anpassen");
		TT_CHECK_MSG(pVergl != NULL, "Remove prueft nicht, ob die geloeschte Persoenlichkeit die aktuelle war (E-39)");
		TT_CHECK_MSG(pUmsch != NULL, "Remove schaltet nicht auf <Dominant> um - der geloeschte Abschnitt entsteht beim naechsten FlushINIFile wieder (E-39)");
		TT_CHECK_MSG(pCache1 != NULL && pCache2 != NULL, "Remove nimmt SavePassword/SavePasswordText nicht aus dem Zwischenspeicher - SetCurrent schreibt sie in den geloeschten Abschnitt (E-39)");
		TT_CHECK_MSG(pVergiss != NULL, "Remove vergisst das Kennwort der geloeschten Persoenlichkeit im Speicher nicht (E-39)");
		if (pCache1 && pCache2 && pUmsch)
			TT_CHECK_MSG(pCache1 < pUmsch && pCache2 < pUmsch, "die Kennwortschluessel werden erst NACH dem Umschalten aus dem Zwischenspeicher genommen - zu spaet, SetCurrent hat sie schon geschrieben (E-39)");
		if (pLoesch && pUmsch)
			TT_CHECK_MSG(pLoesch < pUmsch, "umgeschaltet wird vor dem Loeschen des Abschnitts - Reihenfolge pruefen (E-39)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static void Test_E39_FlushSchreibtInAktuelle(const char* szEudoraDir)
{
	TT_BeginTest("E-39 (Quelltext): FlushINIFile schreibt die Kennwortschluessel weiter in die aktuelle Persoenlichkeit");
	char* pText = QT_LiesNurCode(szEudoraDir, "rs.cpp");
	if (!pText)
	{
		TT_Fail("rs.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	// Die Annahme, auf der die Behebung steht: nur diese beiden Schluessel
	// gehen in den Abschnitt der aktuellen Persoenlichkeit. Kaeme ein
	// dritter dazu, muesste Remove auch ihn aus dem Zwischenspeicher nehmen.
	TT_CHECK_MSG(QT_Enthaelt(pText, "if ( StringNum == IDS_INI_SAVE_PASSWORD || StringNum == IDS_INI_SAVE_PASSWORD_TEXT )"),
		"FlushINIFile schreibt andere Schluessel in die aktuelle Persoenlichkeit als SavePassword/SavePasswordText - CPersonality::Remove (E-39) anpassen");
	free(pText);
	TT_EndTest();
}

void RunE39Tests(const char* szEudoraDir)
{
	Test_E39_Remove(szEudoraDir);
	Test_E39_FlushSchreibtInAktuelle(szEudoraDir);
}
