//
// TestE142.cpp - Regressionstest zu Befund E-142
//
// Ein Entwurf aus einem IMAP-Ordner nach "Out" gezogen ergibt in Out eine
// leere Nachricht; das Original bleibt im IMAP-Ordner (Gregor am laufenden
// Programm, 23.10.2026). Vereinbart ist keine Behebung, sondern ein Hinweis
// (Gregor, 24.10.2026: "wir haben ausgemacht, dass es als hinweis kommt,
// dass bei dieser aktion mail inhalt verloren gehen kann, das sollte
// reichen.").
//
// Geprueft wird am Quelltext ohne Kommentare, in CTocDoc::Xfer:
//   - der Hinweis kommt bei Ziel Out UND IMAP-Quelle, einmal je Uebertragung;
//   - er steht hinter der E-125-Ablehnung und vor jeder Uebertragung;
//   - "Nein" bricht ab und haelt die IMAP-Nachbearbeitung an, sonst kaeme
//     dazu "No messages were transferred!";
//   - der Text steht in den Ressourcen.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE142Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-142: Hinweis beim Ziehen eines Entwurfs aus einem IMAP-Ordner nach Out");
	char* pCode = QT_LiesNurCode(szEudoraDir, "tocdoc.cpp");
	char* pRc = QT_Lesen(szEudoraDir, "EudoraRes.rc");
	if (!pCode || !pRc)
	{
		TT_Fail("tocdoc.cpp oder EudoraRes.rc nicht lesbar - ungeprueft ist nicht gruen");
		free(pCode); free(pRc); TT_EndTest(); return;
	}
	QT_LeerraumZusammen(pCode);

	char* pRumpf = QT_Abschnitt(pCode, "CSummary* CTocDoc::Xfer(", "#ifdef IMAP4 if ( !E125Abgelehnt");
	TT_CHECK_MSG(pRumpf != NULL, "CTocDoc::Xfer bis zur IMAP-Nachbearbeitung nicht gefunden");
	if (pRumpf)
	{
		const char* aBlock[] =
		{
			"if (ToOut && IsImapToc() && !E142Gefragt) {",
			"E142Gefragt = TRUE;",
			"const BOOL bWeiter = (YesNoDialogPlain(IDS_WARN_IMAP_DRAFT_TO_OUT) == IDOK);",
		};
		long lPos = 0;
		bool bFolge = true;
		for (size_t k = 0; k < sizeof(aBlock) / sizeof(aBlock[0]); k++)
		{
			const long l = QT_Stelle(pRumpf + lPos, aBlock[k]);
			if (l < 0 || (k > 0 && l > 1)) { bFolge = false; TT_Fail("fehlt oder getrennt: %s", aBlock[k]); break; }
			lPos += l + (long) strlen(aBlock[k]);
		}
		TT_CHECK_MSG(bFolge, "der Hinweis ist nicht mehr vollstaendig (siehe die Zeile davor)");

		const long lNein = QT_Stelle(pRumpf + lPos, "if (!bWeiter) { E142Abgebrochen = TRUE;");
		TT_CHECK_MSG(lNein >= 0, "\"Nein\" auf den Hinweis bricht nicht ab");
		if (lNein >= 0)
			TT_CHECK_MSG(QT_Stelle(pRumpf + lPos + lNein, "break;") >= 0, "\"Nein\" verlaesst die Schleife nicht");

		const long lE125   = QT_Stelle(pRumpf, "AlertDialog(IDD_XFER_TO_OUT_REFUSED);");
		const long lHinweis = QT_Stelle(pRumpf, "if (ToOut && IsImapToc() && !E142Gefragt) {");
		const long lXfer   = QT_Stelle(pRumpf, "CCompMessageDoc* comp = Sum->SendAgain(FALSE);");
		TT_CHECK_MSG(lE125 >= 0 && lHinweis > lE125, "der Hinweis steht nicht hinter der E-125-Ablehnung");
		TT_CHECK_MSG(lXfer >= 0 && lHinweis < lXfer, "der Hinweis kommt erst nach dem Anlegen der Kopie in Out");
		free(pRumpf);
	}

	TT_CHECK_MSG(QT_Enthaelt(pCode, "if ( !E125Abgelehnt && !E142Abgebrochen &&"),
				 "nach \"Nein\" laeuft die IMAP-Nachbearbeitung trotzdem - dann kaeme \"No messages were transferred!\"");
	TT_CHECK_MSG(QT_Enthaelt(pRc, "IDS_WARN_IMAP_DRAFT_TO_OUT"), "der Hinweistext fehlt in EudoraRes.rc");
	TT_CHECK_MSG(QT_Enthaelt(pRc, "may give an empty message in Out"), "der Hinweistext sagt nicht mehr, dass die Nachricht in Out leer sein kann");

	free(pCode);
	free(pRc);
	TT_EndTest();
}
