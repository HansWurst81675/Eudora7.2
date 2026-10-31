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
		return;
	}
	TT_CHECK_MSG(QT_Enthaelt(pR, "szBody = E136HtmlAusBstr( (BSTR) cbstr );"), "SaveInfo (Strg-S) wandelt wieder mit 'CString = BSTR' - Emoji werden zu '??' (E-136)");
	TT_CHECK_MSG(!QT_Enthaelt(pR, "szBody = cbstr;"), "SaveInfo hat wieder eine verlustbehaftete Zuweisung (E-136)");
	TT_CHECK_MSG(QT_Enthaelt(pV, "szHTML = E136HtmlAusBstr( (BSTR) cbstrText );"), "GetAllHTML wandelt wieder mit 'CString = BSTR' (E-136)");
	free(pR);
	free(pV);
}

void RunE136Tests(const char* szEudoraDir)
{
	Test_E136_Funktion();
	Test_E136_Stelle(szEudoraDir);
}
