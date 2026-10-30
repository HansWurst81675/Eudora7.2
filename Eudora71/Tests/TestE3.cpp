//
// TestE3.cpp - Regressionstest zu E-3 (TLS 1.3 mit der ausgelieferten QCSSL)
//
// E-3, 31.08.2026: Gregor las in Tools -> Last SSL Info ab, dass Eudora mit
// mx.freenet.de TLSv1.3 (TLS_AES_256_GCM_SHA384) ausgehandelt hat - der
// Beleg, dass die strengere Untergrenze aus M1 (TLS 1.2 fuer JEDE
// Einstellung, auch die Voreinstellung 3 = "frueher TLSv1") nichts
// verschlechtert hat.
//
// Zurueckkommen kann das auf zwei Wegen: eine Einstellung faellt wieder
// unter TLS 1.2, oder jemand deckelt die Obergrenze (set_max_proto_version,
// SSL_OP_NO_TLSv1_3) bzw. kehrt zu einer versionsgebundenen Methode zurueck.
// Beides prueft dieser Test an der STELLE (Quelltext.h) in allen
// Quelldateien von QCSSL.
//
// Gemessen am laufenden Code wird die Aushandlung in Tests\QCSSL
// (qcsslprobe.exe gegen die echte QCSSL.dll, messen.ps1) - das braucht
// eigene Testserver und laeuft nicht in dieser Suite.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE3Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-3 (Quelltext): QCSSL handelt bis TLS 1.3 aus, Untergrenze TLS 1.2 fuer jede Einstellung");

	char* pCtx = QT_LiesNurCode(szEudoraDir, "..\\QCSSL\\src\\QCSSLContext.cpp");
	if (!pCtx)
	{
		TT_Fail("QCSSLContext.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pFn = QT_Abschnitt(pCtx, "int iMinVersion = TLS1_2_VERSION;", "return pCtx;");
	TT_CHECK_MSG(pFn != NULL, "die Versionswahl in QCSSLContext.cpp ist nicht zu finden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "sslmethod = TLS_client_method();"), "QCSSL nimmt nicht mehr TLS_client_method() - eine versionsgebundene Methode deckelt TLS 1.3");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "SSL_CTX_set_min_proto_version(pCtx, iMinVersion)"), "die Untergrenze wird nicht mehr gesetzt");
		const int iZuweisungen = QT_Zaehle(pFn, "iMinVersion =");
		const int iTls12       = QT_Zaehle(pFn, "iMinVersion = TLS1_2_VERSION;");
		TT_CHECK_MSG(iZuweisungen >= 4, "weniger Zuweisungen an iMinVersion als erwartet - die Versionswahl hat sich veraendert");
		if (iZuweisungen != iTls12)
			TT_Fail("%d von %d Zuweisungen an iMinVersion sind nicht TLS1_2_VERSION - eine Einstellung faellt unter TLS 1.2 (M1)",
					iZuweisungen - iTls12, iZuweisungen);
		free(pFn);
	}
	free(pCtx);

	// Keine Obergrenze, nirgends in QCSSL.
	static const char* aDateien[] = {
		"ClientCertInfo.cpp", "QCSSLContext.cpp", "SSLConnectionManager.cpp", "cert.cpp", "certstore.cpp",
		"qccertificate.cpp", "qcrandom.cpp", "qcsessiondb.cpp", "qcthread.cpp", "regexp.cpp", "sslutils.cpp",
	};
	static const char* aDeckel[] = { "set_max_proto_version", "SSL_OP_NO_TLSv1_3", "TLSv1_2_client_method", "TLSv1_2_method" };
	for (int i = 0; i < (int) (sizeof(aDateien) / sizeof(aDateien[0])); i++)
	{
		char szPfad[MAX_PATH];
		strcpy_s(szPfad, sizeof(szPfad), "..\\QCSSL\\src\\");
		strcat_s(szPfad, sizeof(szPfad), aDateien[i]);
		char* pText = QT_LiesNurCode(szEudoraDir, szPfad);
		if (!pText)
		{
			TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", aDateien[i]);
			continue;
		}
		for (int j = 0; j < (int) (sizeof(aDeckel) / sizeof(aDeckel[0])); j++)
			if (QT_Enthaelt(pText, aDeckel[j]))
				TT_Fail("%s: %s deckelt die Protokollversion - TLS 1.3 waere nicht mehr aushandelbar (E-3)", aDateien[i], aDeckel[j]);
		free(pText);
	}

	TT_EndTest();
}
