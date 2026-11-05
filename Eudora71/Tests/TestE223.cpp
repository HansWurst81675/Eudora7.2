//
// TestE223.cpp - Befund E-223: "Remember password" wirkt erst beim zweiten
// Mal.
//
// CPOPSession::GetPOPPassword_ (Eudora/POPSession.cpp) las SavePass aus
// QCPOPSettings, das VOR dem Kennwortdialog angelegt wurde. Der Dialog
// (password.cpp, GetPassword) schreibt das Haekchen erst danach in die INI.
// Setzte der Anwender es zum ersten Mal, entschied GetPOPPassword_ mit dem
// alten Wert 0: das Kennwort wurde nicht gespeichert, und der naechste Start
// fragte noch einmal (gemessen 05.11.2026 am Pruefstand C:\Temp\E223, Bau
// 7.2.2.133: "E223 ERGEBNIS savepassword=1 ini-kennwort=0 beendet=1").
// Jetzt liest GetPOPPassword_ den Wert nach dem Dialog neu.
//
// Geprueft am Quelltext - der Weg haengt am Dialog und an der INI und laesst
// sich ohne Programm nicht aufrufen. Das Verhalten misst der Pruefstand
// (E-223p, "E223 ERGEBNIS savepassword=1 ini-kennwort=1 beendet=1").
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E223_NachDemDialogNeuLesen(const char* szEudoraDir)
{
	TT_BeginTest("E-223: GetPOPPassword_ liest SavePassword nach dem Kennwortdialog neu");

	char* pT = QT_LiesNurCode(szEudoraDir, "POPSession.cpp");
	if (!pT)
	{
		TT_Fail("POPSession.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pF = QT_Abschnitt(pT, "int CPOPSession::GetPOPPassword_()", "BOOL CPOPSession::ReconcileLists_(");
	if (!pF)
		TT_Fail("GetPOPPassword_ nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		// Unmittelbar nach dem Dialog, vor dem Schreiben des Kennworts, wird
		// SavePass neu gelesen (Kommentare sind weg, Leerraum zusammengezogen).
		TT_CHECK_MSG(QT_Enthaelt(pF,
					 "if (! ::GetPassword(::POPPassword)) return (-1); "
					 "SavePass = (GetIniShort(IDS_INI_SAVE_PASSWORD) != 0); "
					 "if (SavePass) SetIniString(IDS_INI_SAVE_PASSWORD_TEXT, ::EncodePassword(::POPPassword));"),
					 "SavePass wird nach dem Kennwortdialog nicht neu gelesen - das erste Haekchen speichert kein Kennwort (E-223)");
		// Das Speichern-oder-Loeschen danach benutzt denselben, neu gelesenen
		// Wert - nicht wieder den aus QCPOPSettings.
		TT_CHECK_MSG(QT_Zaehle(pF, "m_Settings->SavePass()") == 1,
					 "GetPOPPassword_ liest SavePass ein zweites Mal aus QCPOPSettings - der Wert stammt von vor dem Dialog (E-223)");
		TT_CHECK_MSG(QT_Enthaelt(pF, "if (SavePass && !pszPasswordText)") &&
					 QT_Enthaelt(pF, "else if (!SavePass && pszPasswordText)"),
					 "das Speichern oder Loeschen des Kennworts haengt nicht mehr an SavePass (E-223)");
		free(pF);
	}

	free(pT);
	TT_EndTest();
}

void RunE223Tests(const char* szEudoraDir)
{
	Test_E223_NachDemDialogNeuLesen(szEudoraDir);
}
