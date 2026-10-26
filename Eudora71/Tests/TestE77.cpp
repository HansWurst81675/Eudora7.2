//
// TestE77.cpp - werden IMAP-Postfachnamen mit Umlauten richtig angezeigt?
//
// Befund E-77: Gregor sah am 10.09.2026 "Entw&APw-rfe" und "Gel&APY-scht"
// statt "Entwuerfe" und "Geloescht" - so schickt GMX die Namen, im
// modifizierten UTF-7 aus RFC 3501, Abschnitt 5.1.3. Die Umkehrung gehoert
// dazu: wer einen Ordner mit Umlaut anlegt oder umbenennt, muss ihn dem
// Server wieder kodiert schicken, sonst entsteht dort ein falscher Name.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTestE77.h"
#include "Quelltext.h"

static void Hin(const char* szServer, const char* szAnzeige)
{
	char szAus[256];
	char szMsg[300];
	BOOL bOk = E77Utf7Dekodieren(szServer, szAus, sizeof(szAus));
	_snprintf(szMsg, sizeof(szMsg) - 1, "\"%s\" ergibt \"%s\", soll \"%s\"", szServer, bOk ? szAus : "(Fehler)", szAnzeige);
	szMsg[sizeof(szMsg) - 1] = 0;
	TT_CHECK_MSG(bOk && strcmp(szAus, szAnzeige) == 0, szMsg);
	BOOL bZur = E77Utf7Kodieren(szAnzeige, szAus, sizeof(szAus));
	_snprintf(szMsg, sizeof(szMsg) - 1, "zurueck: \"%s\" ergibt \"%s\", soll \"%s\"", szAnzeige, bZur ? szAus : "(Fehler)", szServer);
	szMsg[sizeof(szMsg) - 1] = 0;
	TT_CHECK_MSG(bZur && strcmp(szAus, szServer) == 0, szMsg);
}

void RunE77Tests(void)
{
	TT_Suite("E-77: IMAP-Postfachnamen in modifiziertem UTF-7");

	TT_BeginTest("E-77: Gregors Ordner von GMX, hin und zurueck");
	{
		Hin("Entw&APw-rfe", "Entw\xFCrfe");
		Hin("Gel&APY-scht", "Gel\xF6scht");
		Hin("&AMQ-pfel", "\xC4pfel");
		Hin("Stra&AN8-e", "Stra\xDF" "e");      // getrennt: \xDFe waere ein Hex-Escape
		Hin("Pr&APwA9g-fung", "Pr\xFC\xF6" "fung");
	}
	TT_EndTest();

	TT_BeginTest("E-77 Gegenrichtung: ASCII und & bleiben, Unbekanntes bleibt roh");
	{
		Hin("Spamverdacht", "Spamverdacht");
		Hin("Tom &- Jerry", "Tom & Jerry");
		char szAus[64];
		// Ein Zeichen ausserhalb von Windows-1252 (U+4E2D) laesst die
		// Dekodierung scheitern - der Aufrufer zeigt dann den rohen Namen.
		TT_CHECK_MSG(!E77Utf7Dekodieren("&Ti0-", szAus, sizeof(szAus)), "U+4E2D muss als nicht darstellbar scheitern");
		TT_CHECK_MSG(!E77Utf7Dekodieren("Entw&APw", szAus, sizeof(szAus)), "ein Abschnitt ohne \"-\" muss scheitern");
		TT_CHECK_MSG(!E77Utf7Kodieren("Entw\xFCrfe", szAus, 5), "zu kleiner Puffer muss scheitern");
	}
	TT_EndTest();
}

// E-77 Umbenennen (PRUEFER-49 K1, K2): der Server bekam beim Umbenennen den
// kodierten Namen, Eudora fuehrte den Ordner danach aber unter dem
// UNKODIERTEN weiter (UpdateAfterRename) und schickte ihn beim naechsten
// Zugriff - am Pruefstand gemessen: SELECT "Ablage-\xE4", vom Server
// abgelehnt. Beim Umbenennen von INBOX wurde gar nicht kodiert. Beide Stellen
// sitzen in Funktionen, die ohne Konto und Fenster nicht aufzurufen sind;
// geprueft wird deshalb der QUELLTEXT ohne Kommentare. Am Verhalten misst
// es tools\messen-e77-umbenennen.ps1 (Pruefstandsfall E-77d).
void RunE77QuelltextTests(const char* szEudoraDir)
{
	TT_Suite("E-77 Umbenennen: gefuehrter Name gleich Servername (Quelltext)");

	// Seit E-146 (26.10.2026) bildet UpdateAfterRename den Namen nicht mehr
	// selbst, sondern fuehrt den, den RenameMailbox an den Server schickt -
	// dessen Kodierung prueft K2 unten. Der Test haelt deshalb fest, dass es
	// bei dieser einen Quelle bleibt. Einzelheiten in TestE146.cpp.
	TT_BeginTest("E-77 K1: UpdateAfterRename fuehrt den Namen, der an den Server ging");
	{
		char* pCode = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\QCImapMailboxDirector.cpp");
		if (!pCode) { TT_Fail("QCImapMailboxDirector.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
		QT_LeerraumZusammen(pCode);
		char* pRumpf = QT_Abschnitt(pCode, "BOOL QCMailboxDirector::UpdateAfterRename (QCImapMailboxCommand",
										   "UpdateChildrenAfterRename (pImapCommand);");
		TT_CHECK_MSG(pRumpf != NULL, "UpdateAfterRename nicht gefunden");
		if (pRumpf)
		{
			TT_CHECK_MSG(QT_Enthaelt(pRumpf, "pImapCommand->SetImapName (pNewFullImapName);"),
						 "der gefuehrte Name ist nicht mehr der, der an den Server ging");
			TT_CHECK_MSG(!QT_Enthaelt(pRumpf, "pNewName;") && !QT_Enthaelt(pRumpf, "(pNewName)"),
						 "der getippte Name geht wieder in den IMAP-Namen");
			free(pRumpf);
		}
		free(pCode);
	}
	TT_EndTest();

	TT_BeginTest("E-77 K2: RenameMailbox kodiert an allen fuenf Stellen, INBOX eingeschlossen");
	{
		char* pCode = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapAccount.cpp");
		if (!pCode) { TT_Fail("ImapAccount.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
		char* pRumpf = QT_Abschnitt(pCode, "BOOL CImapAccount::RenameMailbox(", "BOOL CImapAccount::RenameMailboxOnServer(");
		TT_CHECK_MSG(pRumpf != NULL, "CImapAccount::RenameMailbox nicht gefunden");
		if (pRumpf)
		{
			TT_CHECK_MSG(QT_Zaehle(pRumpf, "E77ImapNameFuerServer(szNewImapName)") == 5,
						 "nicht alle fuenf Stellen (INBOX zweimal, ohne Trenner, oberste Ebene, Unterordner) kodieren");
			TT_CHECK_MSG(!QT_Enthaelt(pRumpf, "= szNewImapName;"),
						 "INBOX: der neue Name geht wieder roh an den Server");
			TT_CHECK_MSG(!QT_Enthaelt(pRumpf, "prefix + szNewImapName;"),
						 "INBOX mit Praefix: der neue Name geht wieder roh an den Server");
			free(pRumpf);
		}
		free(pCode);
	}
	TT_EndTest();
}
