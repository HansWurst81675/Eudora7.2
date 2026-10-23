//
// TestE125.cpp - Befund E-125: Ziehen nach "Out" legte eine neue Nachricht an
//                und meldete im selben Zug, es sei nichts uebertragen worden
//
// WAS GREGOR SAH, an 1.0.100 am 16.10.2026: "mail aus OUTBOX in Out
// verschoben, danach steht was kurioses in Out (siehe screenshot)" - Betreff
// "test 20261016a<br>", "Cc: <br>", "Bcc: <br>", Absender "br". Dazu der
// Dialog "No messages were transferred!".
//
// WAS AN 7.2.0.120 DAVON UEBRIG WAR, von ihm selbst gefahren am 23.10.2026:
// die <br>-Marken in den Kopfzeilen NICHT mehr - der Kopfblock der neuen
// Nachricht in Out.mbx war sauber. Die andere Haelfte schon: Eudora legte
// ueber Sum->SendAgain eine NEUE Nachricht an (OutToc->AddSum) und meldete
// gleich danach IDS_ERR_IMAP_NO_MSGS_XFERRED. Der Anwender bekam also beides -
// eine Nachricht, die er nicht wollte, und die Auskunft, es sei nichts
// geschehen.
//
// GREGORS ENTSCHEIDUNG vom 17.10.2026 auf die Frage, ob der Weg wie im
// Original eine neue Nachricht zum erneuten Senden anlegen (A) oder abgelehnt
// werden soll mit dem Hinweis auf Message > Send Again (B): "B".
//
// WAS HIER WIE GEPRUEFT WIRD. Die Stelle sitzt mitten in CTocDoc::Xfer,
// zwischen Postfachdateien, Fenstern und einem modalen Dialog; sie laesst sich
// nicht herausloesen und aufrufen. Geprueft wird deshalb die STELLE im
// Quelltext und die Ressource, die sie braucht - das ist schwaecher als ein
// Aufruf und steht so auch im Testnamen. Es ist aber kein Papier: nimmt jemand
// die Ablehnung zurueck oder weitet sie auf verfasste Nachrichten aus, wird
// der Test rot.
//
// DIE GEGENPROBE, die der Testfall mitfaehrt: nicht nur, ob die Ablehnung
// dasteht, sondern auch, ob sie am RICHTIGEN Fall haengt. Eine Bedingung
// "if (ToOut)" allein wuerde auch das Einreihen einer verfassten Nachricht
// abweisen - das waere eine neue Fehlfunktion an derselben Stelle. Der
// Testfall faellt in diesem Fall um.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

//
// 1. Die Stelle in CTocDoc::Xfer.
//
static void Test_E125_DieStelle(const char* szEudoraDir)
{
	char*	pCode = QT_LiesNurCode(szEudoraDir, "tocdoc.cpp");

	TT_BeginTest("E-125: Ziehen einer empfangenen Nachricht nach Out wird abgelehnt (Stelle im Quelltext)");

	if (!pCode)
	{
		TT_Fail("tocdoc.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	// Der alte Stand ist weg: es wird nicht mehr gefragt, ob trotzdem
	// uebertragen werden soll.
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "AlertDialog(IDD_STRIP_HEADERS)"),
				 "die alte Rueckfrage IDD_STRIP_HEADERS ist zurueck - "
				 "damit legt Eudora wieder eine neue Nachricht an");
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "StripHeaders"),
				 "der Merker StripHeaders ist zurueck - er gehoerte allein zur alten Rueckfrage");

	// Der neue Stand steht da.
	TT_CHECK_MSG(QT_Enthaelt(pCode, "if (ToOut && !Sum->IsComp()) {"),
				 "die Ablehnung haengt nicht mehr an (ToOut && !Sum->IsComp())");
	TT_CHECK_MSG(QT_Enthaelt(pCode, "AlertDialog(IDD_XFER_TO_OUT_REFUSED);"),
				 "der Hinweis auf Message > Send Again wird nicht mehr gezeigt");

	// GEGENPROBE zum Umfang: eine VERFASSTE Nachricht nach Out zu ziehen
	// heisst, sie zum Senden einzureihen. Das muss erlaubt bleiben. Eine
	// Bedingung ohne !Sum->IsComp() waere eine neue Fehlfunktion.
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "if (ToOut) {"),
				 "die Ablehnung trifft jetzt AUCH verfasste Nachrichten - "
				 "damit laesst sich nichts mehr zum Senden einreihen");

	// Die Spurmarke, an der sich der Weg im Protokoll wiederfinden laesst.
	TT_CHECK_MSG(QT_Enthaelt(pCode, "E-125 Xfer nach Out abgelehnt:"),
				 "die Spurmarke fehlt - ohne sie ist der Weg im Protokoll nicht zu sehen");

	free(pCode);
	TT_EndTest();
}

//
// 2. Die Ressource, auf die die Stelle sich stuetzt. Ohne sie uebersetzt
//    zwar alles, aber der Dialog kommt zur Laufzeit nicht hoch.
//
static void Test_E125_DieRessource(const char* szEudoraDir)
{
	char*	pKopf   = QT_Lesen(szEudoraDir, "resource.h");
	char*	pRes    = QT_Lesen(szEudoraDir, "EudoraRes.rc");
	char*	pDialog = NULL;

	TT_BeginTest("E-125: der Hinweisdialog ist eine Ressource und keine Frage");

	if (!pKopf || !pRes)
	{
		TT_Fail("resource.h oder EudoraRes.rc nicht lesbar - ungeprueft ist nicht gruen");
		free(pKopf);
		free(pRes);
		TT_EndTest();
		return;
	}

	TT_CHECK_MSG(QT_Enthaelt(pKopf, "#define IDD_XFER_TO_OUT_REFUSED"),
				 "die Kennung fehlt in resource.h");
	TT_CHECK_MSG(QT_Enthaelt(pRes, "IDD_XFER_TO_OUT_REFUSED DIALOGEX"),
				 "der Dialog fehlt in EudoraRes.rc");

	pDialog = QT_Abschnitt(pRes, "IDD_XFER_TO_OUT_REFUSED DIALOGEX", "END");
	TT_CHECK_MSG(pDialog != 0, "der Dialogblock laesst sich nicht herausschneiden");
	if (pDialog)
	{
		// Der Anwender muss erfahren, was er STATTDESSEN tun kann. Ohne
		// diesen Satz ist die Ablehnung nur eine Sackgasse.
		TT_CHECK_MSG(QT_Enthaelt(pDialog, "Send Again"),
					 "der Hinweis auf Message > Send Again fehlt im Dialogtext");

		// Und es ist eine MITTEILUNG, keine Frage: ein zweiter Knopf
		// waere wieder ein "trotzdem" und damit der alte Weg.
		TT_CHECK_MSG(QT_Enthaelt(pDialog, "IDOK"), "der Dialog hat keinen Knopf");
		TT_CHECK_MSG(!QT_Enthaelt(pDialog, "IDCANCEL"),
					 "der Dialog hat einen zweiten Knopf - damit ist er wieder eine Frage");

		free(pDialog);
	}

	free(pKopf);
	free(pRes);
	TT_EndTest();
}

void RunE125Tests(const char* szEudoraDir)
{
	TT_Suite("E-125: Ziehen nach Out wird abgelehnt statt eine neue Nachricht anzulegen");

	Test_E125_DieStelle(szEudoraDir);
	Test_E125_DieRessource(szEudoraDir);
}
