//
// TestE136.cpp - Regressionstest zu E-136
//
// E-136: ein Zeichen, das richtig auf dem Bildschirm stand, wurde beim
//        Speichern zerstoert - aus einem Emoji wurden "??". Das HTML kommt aus
//        der Anzeige als UTF-16 und wurde mit "CString = BSTR" in die Codepage
//        umgewandelt. E136HtmlAusBstr (TridentView.cpp) schreibt jetzt, was
//        die Codepage nicht kennt, als numerische Entitaet.
//
// Geprueft wird die echte Funktion (von Extract.ps1 geschnitten) und die
// Stelle: beide Wege - Strg-S (SaveInfo) und GetAllHTML - laufen ueber sie.
// Die Erwartungen fuer Euro und Umlaute gelten fuer die Codepage 1252 (Gregors
// Windows); unter einer anderen Codepage wird der Fall uebersprungen.
//
#include <afx.h>
#include <windows.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

CString UTE136_HtmlAusBstr(const wchar_t* pwText);

//
// Zaehlt szSuche in pText, nachdem aus BEIDEN jeder Leerraum entfernt ist.
// PRUEFER-70 K1 (01.11.2026): "szMsg=cbstr;" ohne Leerzeichen machte
// Speichern unter wieder verlustbehaftet, und QT_Zaehle mit "szMsg = cbstr;"
// sah es nicht - alle Tests blieben gruen.
//
static char* OhneLeerraum(const char* p)
{
	char* pNeu = (char*) malloc(strlen(p) + 1);
	char* q = pNeu;
	if (!pNeu)
		return NULL;
	for (; *p; p++)
		if (*p != ' ' && *p != '\t' && *p != '\r' && *p != '\n')
			*q++ = *p;
	*q = '\0';
	return pNeu;
}

static int ZaehleOhneLeerraum(const char* pText, const char* szSuche)
{
	char* pT = OhneLeerraum(pText);
	char* pS = OhneLeerraum(szSuche);
	int n = -1;					// -1 = Speicher fehlt, ist nie "0 gefunden"
	if (pT && pS && *pS)
	{
		const size_t nLen = strlen(pS);
		n = 0;
		for (const char* p = strstr(pT, pS); p; p = strstr(p + nLen, pS))
			n++;
	}
	free(pT);
	free(pS);
	return n;
}

// Abschnitt von szVon bis szBis; szBis == NULL heisst: bis zum Dateiende.
static char* AbschnittBis(const char* pText, const char* szVon, const char* szBis)
{
	if (szBis)
		return QT_Abschnitt(pText, szVon, szBis);
	const char* p = strstr(pText, szVon);
	if (!p)
		return NULL;
	char* pNeu = (char*) malloc(strlen(p) + 1);
	if (pNeu)
		strcpy(pNeu, p);
	return pNeu;
}

static void Pruefe(const wchar_t* pw, const char* szSoll, const char* szWas)
{
	const CString	szIst = UTE136_HtmlAusBstr(pw);
	if (szIst != szSoll)
		TT_Fail("%s: erwartet [%s], bekommen [%s] (E-136)", szWas, szSoll, (LPCTSTR) szIst);
}

static void Test_E136_Funktion()
{
	TT_BeginTest("E-136: Zeichen ausserhalb der Codepage werden zur Entitaet, nicht zu '?'");
	Pruefe(L"<li>Vierbyte-Zeichen: \xD83D\xDD25</li>", "<li>Vierbyte-Zeichen: &#128293;</li>", "Emoji (Ersatzpaar)");
	Pruefe(L"Kyrillisch: \x0416", "Kyrillisch: &#1046;", "Kyrillisch");
	Pruefe(L"", "", "leer");
	Pruefe(L"\xD83D", "&#55357;", "einzelne Ersatzhaelfte bleibt als Zahl erhalten");
	if (::GetACP() == 1252)
	{
		Pruefe(L"Gr\x00FC\x00DF\x0065 \x20AC", "Gr\xFC\xDF" "e \x80", "Umlaute und Euro bleiben Bytes (Codepage 1252)");
		Pruefe(L"\x00FC\xD83D\xDD25\x00E4", "\xFC&#128293;\xE4", "gemischt: Bytes und Entitaet nebeneinander");
		Pruefe(L"\x0100", "&#256;", "kein 'aehnliches' Ersatzzeichen (WC_NO_BEST_FIT_CHARS)");
	}
	TT_EndTest();
}

static void Test_E136_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-136 (Quelltext): Strg-S und GetAllHTML wandeln ueber E136HtmlAusBstr");
	char* pR = QT_LiesNurCode(szEudoraDir, "TridentReadMessageView.cpp");
	char* pV = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	if (!pR || !pV)
	{
		TT_Fail("TridentReadMessageView.cpp oder TridentView.cpp nicht lesbar - ungeprueft ist nicht gruen");
		if (pR) free(pR);
		if (pV) free(pV);
		TT_EndTest();
		return;
	}
	TT_CHECK_MSG(QT_Enthaelt(pR, "szBody = E136HtmlAusBstr( (BSTR) cbstr );"), "SaveInfo (Strg-S) wandelt wieder mit 'CString = BSTR' - Emoji werden zu '??' (E-136)");
	TT_CHECK_MSG(!QT_Enthaelt(pR, "szBody = cbstr;"), "SaveInfo hat wieder eine verlustbehaftete Zuweisung (E-136)");
	TT_CHECK_MSG(QT_Enthaelt(pV, "szHTML = E136HtmlAusBstr( (BSTR) cbstrText );"), "GetAllHTML wandelt wieder mit 'CString = BSTR' (E-136)");
	// PRUEFER-68 K1: der zweite Speicherweg - Speichern unter als .htm ohne
	// Kopfzeilen laeuft ueber GetMessageBody(..., TRUE).
	TT_CHECK_MSG(QT_Enthaelt(pR, "if( bAsHTML ) szMsg = E136HtmlAusBstr( (BSTR) cbstr ); else szMsg = cbstr;"), "GetMessageBody wandelt HTML wieder mit 'CString = BSTR' - Speichern unter (.htm) macht Emoji zu '??' (E-136, PRUEFER-68 K1)");
	// PRUEFER-69 K1: die Zeile oben allein ist blind - eine wieder
	// eingesetzte "szMsg = cbstr;" DAHINTER ueberschrieb das Ergebnis, und
	// der Test blieb gruen. In GetMessageBody darf es genau EINE verlustbehaftete
	// Zuweisung geben (den else-Zweig fuer reinen Text).
	{
		char* pFn = QT_Abschnitt(pR, "BOOL CTridentReadMessageView::GetMessageBody(", "BOOL CTridentReadMessageView::GetMessageAsHTML(");
		TT_CHECK_MSG(pFn != NULL, "GetMessageBody nicht gefunden (E-136)");
		if (pFn)
		{
			const int nVerlust = ZaehleOhneLeerraum(pFn, "szMsg = cbstr;");	// PRUEFER-70 K1: jede Schreibweise
			TT_CHECK_MSG(nVerlust == 1, "GetMessageBody hat nicht genau eine Zuweisung 'szMsg = cbstr;' (nur der Text-Zweig darf sie haben) - eine zweite ueberschreibt die Entitaeten (E-136, PRUEFER-69 K1)");
			TT_Note("GetMessageBody: 'szMsg = cbstr;' %d-mal (soll 1)", nVerlust);
			free(pFn);
		}
	}
	// PRUEFER-70 K1, zweiter Teil: auch in SaveInfo (Strg-S) jede Schreibweise.
	{
		char* pFn = QT_Abschnitt(pR, "HRESULT CTridentReadMessageView::SaveInfo(", "void CTridentReadMessageView::FillBlockFormatCombo(");
		TT_CHECK_MSG(pFn != NULL, "SaveInfo nicht gefunden (E-136)");
		if (pFn)
		{
			const int nVerlust = ZaehleOhneLeerraum(pFn, "szBody = cbstr;");
			TT_CHECK_MSG(nVerlust == 0, "SaveInfo hat eine verlustbehaftete Zuweisung 'szBody=cbstr;' in irgendeiner Schreibweise (E-136, PRUEFER-70 K1)");
			free(pFn);
		}
	}
	free(pR);
	free(pV);
	TT_EndTest();
}

//
// BEFUND E-178: dieselbe verlustbehaftete Umwandlung wie E-136 in den
// Formatierbefehlen des Bearbeiten-Modus (ExpandTag, SplitTagOff, WrapTag,
// Link einfuegen) und in GetSelectedHTML (Antwort auf markierten Text). Aus
// jedem Emoji wurde schon auf dem Bildschirm "??", Strg-S speicherte es.
// Je Funktion: keine "= cbstr;" mehr (ohne Leerraum gezaehlt, also in jeder
// Schreibweise) und die erwartete Zahl E136HtmlAusBstr-Aufrufe.
//
static void Test_E178_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-178 (Quelltext): Formatierbefehle und markierter Text wandeln ueber E136HtmlAusBstr");
	char* pR = QT_LiesNurCode(szEudoraDir, "TridentReadMessageView.cpp");
	char* pV = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	if (!pR || !pV)
	{
		TT_Fail("TridentReadMessageView.cpp oder TridentView.cpp nicht lesbar - ungeprueft ist nicht gruen");
		if (pR) free(pR);
		if (pV) free(pV);
		TT_EndTest();
		return;
	}
	struct { const char* pText; const char* szVon; const char* szBis; const char* szVerlust; int nAufrufe; const char* szWas; } a[] =
	{
		{ pR, "void CTridentReadMessageView::OnEditInsertLink(", "void CTridentReadMessageView::OnUpdateEditInsertLink(", "= cbstr;", 1, "OnEditInsertLink (Link einfuegen)" },
		{ pR, "BOOL CTridentReadMessageView::ExpandTag(",        "BOOL CTridentReadMessageView::SplitTagOff(",            "= cbstr;", 3, "ExpandTag (Fett, Kursiv ... erweitern)" },
		{ pR, "BOOL CTridentReadMessageView::SplitTagOff(",      "void CTridentReadMessageView::OnUpdateSize(",           "= cbstr;", 3, "SplitTagOff (Formatierung abschalten)" },
		{ pR, "BOOL CTridentReadMessageView::WrapTag(",          NULL,                                                    "= cbstr;", 1, "WrapTag (Formatierung einschalten)" },
		{ pV, "BOOL CTridentView::GetSelectedHTML(",             "BOOL CTridentView::GetAllText(",                        "CString( cbstrText )", 1, "GetSelectedHTML (Antwort auf markierten Text)" },
	};
	for (size_t i = 0; i < sizeof(a) / sizeof(a[0]); i++)
	{
		char* pFn = AbschnittBis(a[i].pText, a[i].szVon, a[i].szBis);
		if (!pFn)
		{
			TT_Fail("%s: Funktion nicht gefunden - ungeprueft ist nicht gruen (E-178)", a[i].szWas);
			continue;
		}
		const int nVerlust = ZaehleOhneLeerraum(pFn, a[i].szVerlust);
		const int nNeu     = ZaehleOhneLeerraum(pFn, "E136HtmlAusBstr( (BSTR) ");
		if (nVerlust != 0)
			TT_Fail("%s: %d verlustbehaftete Zuweisung(en) '%s' - Emoji werden zu '??' (E-178)", a[i].szWas, nVerlust, a[i].szVerlust);
		if (nNeu != a[i].nAufrufe)
			TT_Fail("%s: %d Aufrufe von E136HtmlAusBstr, erwartet %d (E-178)", a[i].szWas, nNeu, a[i].nAufrufe);
		TT_Note("%s: verlustbehaftet %d, E136HtmlAusBstr %d (soll 0 / %d)", a[i].szWas, nVerlust, nNeu, a[i].nAufrufe);
		free(pFn);
	}
	free(pR);
	free(pV);
	TT_EndTest();
}

void RunE136Tests(const char* szEudoraDir)
{
	Test_E136_Funktion();
	Test_E136_Stelle(szEudoraDir);
	Test_E178_Stelle(szEudoraDir);
}
