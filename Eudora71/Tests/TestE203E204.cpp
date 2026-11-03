// TestE203E204.cpp - Regressionstests zu den Befunden E-203, E-204, E-210
// und E-211 (Quelltext).
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
// Pruefstand C:\Temp\E203-alt: war-aktuell=1 nach der Meldung. Behebung:
// jeder Ausgang nach dem Umschalten schaltet zurueck.
//
// E-210: ChangePassword kopierte das POP-Konto (aus GetIniString, bis 511
// Zeichen) mit strcpy in Username[128] (PRUEFER-88 K5). Jetzt gilt ein zu
// langes Konto als unbrauchbar, mit Meldung und Zurueckschalten.
//
// E-211: NewCompDocument (compmsgd.cpp) schaltet auf die Persoenlichkeit der
// neuen Nachricht um und kehrte ohne Zurueckschalten zurueck, wenn das
// Dokument nicht angelegt werden konnte (PRUEFER-88 K4).
//
// PRUEFER-88 K2: einzelne Zeilen vor einem "return" genuegen nicht - mit
// "if (0)" davor, einem neu zugewiesenen OrgPersona oder einem fruehen
// Ausstieg vor dem E-39-Block in Remove blieben die Tests gruen. Verlangt
// werden deshalb ganze Bloecke, die Zahl der Ausgaenge und die Zahl der
// Zuweisungen.
//
// Gegenproben beim Bau (je rot genau der zugehoerige Test): E-204-Block unter
// "if ( bWarAktuell )", "Compare" statt "CompareNoCase", "if ( Name[0] ==
// 'E' ) return TRUE;" vor dem E-39-Block; in ChangePassword "if (0)" vor ein
// Zurueckschalten, "OrgPersona = NewPersona;" vor ein Zurueckschalten, eine
// Zurueckschalt-Zeile entfernt; die Laengenpruefung entfernt; in
// NewCompDocument das Zurueckschalten im Fehlerzweig entfernt.

#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

// Zaehlt die Ausgaenge ("return") in [pVon, pBis).
static int ZaehleReturn(const char* pVon, const char* pBis)
{
	int n = 0;
	for (const char* p = strstr(pVon, "return"); p && p < pBis; p = strstr(p + 6, "return"))
		n++;
	return n;
}

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
		TT_CHECK_MSG(QT_Zaehle(pFn, "m_Passwords.GetStartPosition()") == 1,
			"Remove durchlaeuft m_Passwords nicht genau einmal (E-204)");
		// PRUEFER-88 K2 (G5): vor dem E-39-Block stehen genau die beiden
		// bekannten Ausgaenge - laufende Aufgaben, Name nicht gefunden. Ein
		// weiterer Ausstieg liesse das Kennwort stehen.
		const char* pBlock = strstr(pFn, "const BOOL bWarAktuell");
		TT_CHECK_MSG(pBlock != NULL, "der E-39-Block in Remove fehlt - Test anpassen");
		if (pBlock)
		{
			TT_CHECK_MSG(ZaehleReturn(pFn, pBlock) == 2,
				"Remove hat vor dem E-39/E-204-Block nicht genau die zwei bekannten Ausgaenge - ein weiterer ueberspringt das Vergessen des Kennworts (E-204)");
			TT_CHECK_MSG(QT_Enthaelt(pFn, "AfxMessageBox( CRString(IDS_CANT_REMOVE_PERSONA)); return FALSE; }")
				&& QT_Enthaelt(pFn, "if ( Entry[ 0 ] == '\\0' ) return FALSE; }"),
				"die beiden bekannten Ausgaenge vor dem E-39-Block in Remove stehen nicht mehr wie erwartet - Test anpassen (E-204)");
		}
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static char* LiesChangePassword(const char* szEudoraDir, char** ppText)
{
	*ppText = QT_LiesNurCode(szEudoraDir, "password.cpp");
	if (!*ppText)
		return NULL;
	return QT_Abschnitt(*ppText, "BOOL ChangePassword()", "CString EncodePassword(");
}

static void Test_E203_ChangePasswordSchaltetZurueck(const char* szEudoraDir)
{
	TT_BeginTest("E-203 (Quelltext): ChangePassword schaltet auf jedem Ausgang nach dem Umschalten auf die vorige Persoenlichkeit zurueck");
	char* pText = NULL;
	char* pFn = LiesChangePassword(szEudoraDir, &pText);
	if (!pText)
	{
		TT_Fail("password.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
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
			TT_CHECK_MSG(nAusgaenge == 5, "ChangePassword hat hinter dem Umschalten nicht mehr fuenf Ausgaenge - Test anpassen (E-203, E-210)");
			TT_CHECK_MSG(nOhne == 0, "ein Ausgang von ChangePassword schaltet nicht auf die vorige Persoenlichkeit zurueck - die gewaehlte bleibt die aktuelle (E-203)");
		}
		// PRUEFER-88 K2 (G3): die Ausgaenge als ganze Bloecke - eine
		// Bedingung vor dem Zurueckschalten bricht sie auf.
		TT_CHECK_MSG(QT_Enthaelt(pFn,
			"ErrorDialog(IDS_ERR_NO_POP_ACCT); if ( bMultiple ) g_Personalities.SetCurrent( OrgPersona ); return (FALSE); }"),
			"der Ausgang 'kein POP-Konto' in ChangePassword schaltet nicht unbedingt zurueck (E-203)");
		TT_CHECK_MSG(QT_Enthaelt(pFn,
			"if (!At || !At[1]) { ErrorDialog(IDS_ERR_BAD_POP_ACCT, POPAccount); if ( bMultiple ) g_Personalities.SetCurrent( OrgPersona ); return (FALSE); }"),
			"der Ausgang 'Konto ohne @' in ChangePassword schaltet nicht unbedingt zurueck (E-203)");
		TT_CHECK_MSG(QT_Enthaelt(pFn,
			"ErrorDialog(IDS_PASS_ALERT_PASS_CHANGED); if ( bMultiple ) g_Personalities.SetCurrent( OrgPersona ); return (TRUE); }"),
			"der Erfolgsausgang in ChangePassword schaltet nicht unbedingt zurueck (E-203)");
		TT_CHECK_MSG(QT_Enthaelt(pFn,
			"ClosePass(); if ( bMultiple ) g_Personalities.SetCurrent( OrgPersona ); return (FALSE); }"),
			"der letzte Ausgang in ChangePassword schaltet nicht unbedingt zurueck (E-203)");
		// PRUEFER-88 K2 (G4): OrgPersona wird genau einmal zugewiesen - mit
		// der Persoenlichkeit, die vor dem Umschalten die aktuelle war.
		TT_CHECK_MSG(QT_Zaehle(pFn, "OrgPersona =") == 1 && QT_Enthaelt(pFn, "OrgPersona = g_Personalities.GetCurrent();"),
			"OrgPersona wird in ChangePassword nicht genau einmal mit der vorigen Persoenlichkeit belegt - das Zurueckschalten trifft dann die falsche (E-203)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static void Test_E210_ChangePasswordKontoLaenge(const char* szEudoraDir)
{
	TT_BeginTest("E-210 (Quelltext): ChangePassword kopiert das POP-Konto nur, wenn es in Username passt");
	char* pText = NULL;
	char* pFn = LiesChangePassword(szEudoraDir, &pText);
	if (!pText)
	{
		TT_Fail("password.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	TT_CHECK_MSG(pFn != NULL, "ChangePassword nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "char Username[128];"),
			"Username ist kein Feld fester Groesse mehr - sizeof(Username) in der Laengenpruefung waere falsch; Test anpassen (E-210)");
		TT_CHECK_MSG(QT_Enthaelt(pFn,
			"if (strlen(POPAccount) >= sizeof(Username)) { ErrorDialog(IDS_ERR_BAD_POP_ACCT, POPAccount); "
			"if ( bMultiple ) g_Personalities.SetCurrent( OrgPersona ); return (FALSE); } "
			"strcpy(Username, POPAccount);"),
			"vor strcpy(Username, POPAccount) steht die Laengenpruefung nicht - ein Konto ab 128 Zeichen laeuft ueber den Stapel (E-210)");
		TT_CHECK_MSG(QT_Zaehle(pFn, "strcpy(Username") == 1,
			"ChangePassword kopiert mehr als einmal nach Username - jede Kopie braucht die Laengenpruefung (E-210)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

static void Test_E211_NewCompDocumentSchaltetZurueck(const char* szEudoraDir)
{
	TT_BeginTest("E-211 (Quelltext): NewCompDocument schaltet auch zurueck, wenn das Dokument nicht angelegt werden kann");
	char* pText = QT_LiesNurCode(szEudoraDir, "compmsgd.cpp");
	if (!pText)
	{
		TT_Fail("compmsgd.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "CCompMessageDoc* NewCompDocument (", "CCompMessageDoc* NewCompDocumentWith(");
	TT_CHECK_MSG(pFn != NULL, "NewCompDocument nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "CString csCurPersona = g_Personalities.GetCurrent();"),
			"NewCompDocument merkt sich die vorige Persoenlichkeit nicht mehr wie erwartet - Test anpassen (E-211)");
		TT_CHECK_MSG(QT_Enthaelt(pFn,
			"else { #ifdef COMMERCIAL g_Personalities.SetCurrent( csCurPersona ); #endif return (NewCompDoc); }"),
			"der Fehlerzweig von NewCompDocument schaltet nicht auf die vorige Persoenlichkeit zurueck (E-211)");
		TT_CHECK_MSG(QT_Zaehle(pFn, "g_Personalities.SetCurrent( csCurPersona );") == 2,
			"NewCompDocument schaltet nicht genau an zwei Stellen zurueck (Fehlerzweig und Ende) - Test anpassen (E-211)");
		TT_CHECK_MSG(ZaehleReturn(pFn, pFn + strlen(pFn)) == 2,
			"NewCompDocument hat nicht mehr genau zwei Ausgaenge - jeder neue braucht das Zurueckschalten (E-211)");
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

void RunE203E204Tests(const char* szEudoraDir)
{
	Test_E204_RemoveVergisstImmer(szEudoraDir);
	Test_E203_ChangePasswordSchaltetZurueck(szEudoraDir);
	Test_E210_ChangePasswordKontoLaenge(szEudoraDir);
	Test_E211_NewCompDocumentSchaltetZurueck(szEudoraDir);
}
