//
// TestE141.cpp - Regressionstest zu Befund E-141 (Quelltext)
//
// CTocDoc::Xfer rief ImapXfer auch mit leerer Liste: in
//   IsImapToc() || (TargetToc && TargetToc->IsImapToc()) && sumlist.GetCount() > 0
// bindet && staerker als ||, eine IMAP-Quelle reichte allein. Eine Uebertragung
// aus einem IMAP-Ordner nach Out fuellt sumlist nie - heraus kamen Fehlmeldung,
// Offline-Dialog, Serververbindung und ein EXPUNGE, ohne dass etwas bewegt wurde.
// Zweitens verliess "return pCopySum;" Xfer, ohne die Sperre bXferActive zu loesen.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE141Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-141 (Quelltext): ImapXfer laeuft nur mit gefuellter Liste, und Xfer gibt seine Sperre immer frei");
	char* pText = QT_LiesNurCode(szEudoraDir, "tocdoc.cpp");
	if (!pText)
	{
		TT_Fail("tocdoc.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	TT_CHECK_MSG(QT_Enthaelt(pText, "( (IsImapToc() || (TargetToc && TargetToc->IsImapToc())) && sumlist.GetCount() > 0 ) )"),
				 "die Anzahlpruefung vor ImapXfer gilt nicht mehr fuer beide Seiten (E-141)");
	TT_CHECK_MSG(!QT_Enthaelt(pText, "( IsImapToc() || (TargetToc && TargetToc->IsImapToc()) && sumlist.GetCount() > 0 )"),
				 "die alte Bedingung steht wieder da - eine IMAP-Quelle laeuft mit leerer Liste in ImapXfer (E-141)");
	TT_CHECK_MSG(QT_Enthaelt(pText, "if (pCopySum) { bXferActive = FALSE; return pCopySum; }"),
				 "Xfer verlaesst den IMAP-Zweig mit pCopySum, ohne bXferActive freizugeben (E-141)");
	free(pText);
	TT_EndTest();
}
