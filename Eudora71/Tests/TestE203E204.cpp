// TestE203E204.cpp - Regressionstests zu den Befunden E-203 und E-204
// (Quelltext).
//
// E-204: CPersonality::Remove (persona.cpp) vergass das Kennwort im Speicher
// (m_Passwords["Persona-<Name>"]) nur, wenn die geloeschte Persoenlichkeit
// die aktuelle war. SavePassInfo legt es aber bei JEDEM Umschalten weg von
// einer Persoenlichkeit ab, auch bei der Mailpruefung ueber alle. Eine
// gleichnamige neue Persoenlichkeit derselben Sitzung erbte es, und Eudora
// schickte es ohne Rueckfrage an ihren Server. Gemessen am 02.11.2026 am
// Pruefstand C:\Temp\E204-alt (tools\messen-e204.ps1, Fall E-204p).
// Behebung: nach dem E-39-Block jeden Eintrag nehmen, dessen Schluessel ohne
// Ruecksicht auf die Schreibung gleich "Persona-<Name>" ist - unbedingt.
//
// E-203: ChangePassword (password.cpp) schaltete auf die im Dialog gewaehlte
// Persoenlichkeit um und kehrte bei fehlendem oder unbrauchbarem POP-Konto
// zurueck, ohne auf die vorige zurueckzuschalten. Gemessen am 02.11.2026 am
// Pruefstand C:\Temp\E39: war-aktuell=1 nach der Meldung. Behebung: jeder
// Ausgang nach dem Umschalten schaltet zurueck.
//
// Gegenproben beim Bau: den E-204-Block unter "if ( bWarAktuell )" stellen,
// "CompareNoCase" durch "Compare" ersetzen, oder in ChangePassword eine der
// beiden neuen Zeilen "g_Personalities.SetCurrent( OrgPersona );" entfernen
// -> genau der zugehoerige Test wird rot.

#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E204_RemoveVergisstImmer(const char* szEudoraDir)
{
	TT_BeginTest("E-204 (Quelltext): CPersonality::Remove vergisst das Kennwort jeder geloeschten Persoenlichkeit, auch der nicht aktuellen");
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
		// Der ganze Block, direkt hinter dem Ende des E-39-Zweigs - also
		// nicht unter if ( bWarAktuell ), und erst nach SetCurrent( NULL ).
		TT_CHECK_MSG(QT_Enthaelt(pFn,
			"SetCurrent( NULL ); "
			"m_Passwords.RemoveKey( PersonaID ); } "
			"{ CStringList listVergessen; CString strSchluessel, strWert; "
			"for ( POSITION pos = m_Passwords.GetStartPosition(); pos != NULL; ) { "
			"m_Passwords.GetNextAssoc( pos, strSchluessel, strWert ); "
			"if ( strSchluessel.CompareNoCase( PersonaID ) == 0 ) "
			"listVergessen.AddTail( strSchluessel ); } "
			"while ( ! listVergessen.IsEmpty() ) "
			"m_Passwords.RemoveKey( listVergessen.RemoveHead() ); }"),
			"Remove vergisst das Kennwort im Speicher nicht unbedingt und ohne Ruecksicht auf die Schreibung direkt nach dem E-39-Block - eine gleichnamige neue Persoenlichkeit erbt es (E-204)");
		// Genau eine Stelle nimmt Eintraege aus m_Passwords mit Schreibungs-
		// vergleich, und sie steht nicht in einer weiteren Bedingung.
		TT_CHECK_MSG(QT_Zaehle(pFn, "m_Passwords.GetStartPosition()") == 1,
			"Remove durchlaeuft m_Passwords nicht genau einmal (E-204)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static void Test_E203_ChangePasswordSchaltetZurueck(const char* szEudoraDir)
{
	TT_BeginTest("E-203 (Quelltext): ChangePassword schaltet auf jedem Ausgang nach dem Umschalten auf die vorige Persoenlichkeit zurueck");
	char* pText = QT_LiesNurCode(szEudoraDir, "password.cpp");
	if (!pText)
	{
		TT_Fail("password.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "BOOL ChangePassword()", "CString EncodePassword(");
	TT_CHECK_MSG(pFn != NULL, "ChangePassword nicht gefunden");
	if (pFn)
	{
		const char* pUmsch = strstr(pFn, "g_Personalities.SetCurrent( NewPersona );");
		TT_CHECK_MSG(pUmsch != NULL, "ChangePassword schaltet nicht mehr wie erwartet auf die gewaehlte Persoenlichkeit um - Test anpassen");
		if (pUmsch)
		{
			// Jedes "return" hinter dem Umschalten muss direkt nach dem
			// Zurueckschalten stehen.
			const char* szZurueck = "if ( bMultiple ) g_Personalities.SetCurrent( OrgPersona ); ";
			const size_t nZurueck = strlen(szZurueck);
			int nAusgaenge = 0, nOhne = 0;
			for (const char* p = strstr(pUmsch, "return"); p; p = strstr(p + 6, "return"))
			{
				nAusgaenge++;
				if ((size_t)(p - pFn) < nZurueck || strncmp(p - nZurueck, szZurueck, nZurueck) != 0)
					nOhne++;
			}
			TT_CHECK_MSG(nAusgaenge == 4, "ChangePassword hat hinter dem Umschalten nicht mehr vier Ausgaenge - Test anpassen (E-203)");
			TT_CHECK_MSG(nOhne == 0, "ein Ausgang von ChangePassword schaltet nicht auf die vorige Persoenlichkeit zurueck - die gewaehlte bleibt die aktuelle (E-203)");
		}
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

void RunE203E204Tests(const char* szEudoraDir)
{
	Test_E204_RemoveVergisstImmer(szEudoraDir);
	Test_E203_ChangePasswordSchaltetZurueck(szEudoraDir);
}
