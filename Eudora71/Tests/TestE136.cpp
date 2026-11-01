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
			const int nVerlust = QT_Zaehle(pFn, "szMsg = cbstr;");
			TT_CHECK_MSG(nVerlust == 1, "GetMessageBody hat nicht genau eine Zuweisung 'szMsg = cbstr;' (nur der Text-Zweig darf sie haben) - eine zweite ueberschreibt die Entitaeten (E-136, PRUEFER-69 K1)");
			TT_Note("GetMessageBody: 'szMsg = cbstr;' %d-mal (soll 1)", nVerlust);
			free(pFn);
		}
	}
	free(pR);
	free(pV);
	TT_EndTest();
}

void RunE136Tests(const char* szEudoraDir)
{
	Test_E136_Funktion();
	Test_E136_Stelle(szEudoraDir);
}
