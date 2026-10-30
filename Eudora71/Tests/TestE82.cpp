//
// TestE82.cpp - Regressionstest zu E-82 (Zertifikatspruefung)
//
// E-82, behoben in 7.2.0.48, von Gregor am 11.09.2026 bestaetigt: der
// Verifikations-Callback behandelte X509_V_ERR_CERT_UNTRUSTED (27) und
// X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE (21) als Erfolg - "iOK = 1"
// heisst fuer OpenSSL "Zertifikat in Ordnung", ohne Fehlercode, ohne
// Warnung. Eine Kette, die sich nicht verifizieren liess, wurde angenommen.
//
// Seit der Behebung haengen beide Codes am Zweig fuer
// X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY: iOK bleibt 0,
// IDS_CERTERR_CHAINNOTTRUSTED wird gesetzt, die Verbindung abgelehnt.
//
// Der Callback braucht einen echten X509_STORE_CTX mit QCSSLReference und
// ConnectionInfo im ex_data - der Pruefstand liest deshalb die STELLE
// (Quelltext.h). Rot wird er, wenn einer der beiden Codes wieder einen
// eigenen Zweig bekommt, wenn im Fehlerzweig iOK gesetzt wird oder wenn
// iOK anders als ueber den Zertifikatsspeicher des Anwenders auf 1 kommt.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE82Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-82 (Quelltext): unpruefbare Zertifikatskette (Fehler 21, 27) wird abgelehnt, nicht angenommen");
	char* pText = QT_LiesNurCode(szEudoraDir, "..\\QCSSL\\src\\qccertificate.cpp");
	if (!pText)
	{
		TT_Fail("qccertificate.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pCb = QT_Abschnitt(pText, "int QCCertificateUtils::CertificateCallback(", "int QCCertificateUtils::CertIsInStore(");
	TT_CHECK_MSG(pCb != NULL, "CertificateCallback nicht gefunden");
	if (pCb)
	{
		// Die drei Faelle stehen untereinander und landen im selben Zweig.
		TT_CHECK_MSG(QT_Enthaelt(pCb,
			"case X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY: case X509_V_ERR_CERT_UNTRUSTED: case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE: "
			"if (pInfo->m_Outcome.m_ErrorCode == 0) { pInfo->m_Outcome.m_ErrorCode = IDS_CERTERR_CHAINNOTTRUSTED; } "
			"pInfo->m_Outcome.AddErrors(IDS_CERTERR_CHAINNOTTRUSTED);"),
			"Fehler 21 und 27 haengen nicht mehr am Zweig 'Kette nicht vertrauenswuerdig' (IDS_CERTERR_CHAINNOTTRUSTED)");

		// Jeder Code genau einmal - ein zweiter, eigener Zweig waere der alte Stand.
		TT_CHECK_MSG(QT_Zaehle(pCb, "case X509_V_ERR_CERT_UNTRUSTED:") == 1, "X509_V_ERR_CERT_UNTRUSTED steht nicht genau einmal im Callback");
		TT_CHECK_MSG(QT_Zaehle(pCb, "case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE:") == 1, "X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE steht nicht genau einmal im Callback");

		// Im ganzen Fehler-switch darf iOK nicht gesetzt werden.
		char* pSwitch = QT_Abschnitt(pCb, "switch(X509_STORE_CTX_get_error(pX509StoreCtx))", "pNewCertData = DEBUG_NEW CertData();");
		TT_CHECK_MSG(pSwitch != NULL, "der Fehler-switch im Callback ist nicht zu finden");
		if (pSwitch)
		{
			TT_CHECK_MSG(!QT_Enthaelt(pSwitch, "iOK ="), "im Fehler-switch wird iOK gesetzt - so wurde E-82 einst eine unpruefbare Kette angenommen");
			free(pSwitch);
		}

		// iOK = 1 nur an einer Stelle: das Zertifikat steht im Speicher des Anwenders.
		TT_CHECK_MSG(QT_Zaehle(pCb, "iOK = 1;") == 1, "iOK = 1 steht nicht genau einmal im Callback");
		TT_CHECK_MSG(QT_Enthaelt(pCb, "if (bInStore) { iOK = 1; lErrors = 0; }"), "iOK = 1 steht nicht mehr allein hinter der Pruefung des Anwender-Zertifikatsspeichers");
		free(pCb);
	}

	free(pText);
	TT_EndTest();
}
