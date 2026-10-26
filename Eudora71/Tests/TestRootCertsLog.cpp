//
// TestRootCertsLog.cpp - Regressionstest zur Logzeile fuer rootcerts.p7b
//
// Gregor am 25.10.2026: "zeile im log, ja" - eudora.log nennt, aus welchem
// Verzeichnis die Liste der Wurzelzertifikate geladen wurde (seit E-148
// wichtig: eine eigene rootcerts.p7b im Mailverzeichnis hat Vorrang).
//
// Die Zeile liest die Wahl, die QCSSL selbst getroffen hat: nach
// QCSSLBeginSession steht in m_RootCertStoreDir das gewaehlte Verzeichnis
// statt der beiden Kandidaten. Geprueft wird deshalb beides - dass die
// Zeile nach dem Sitzungsaufbau geschrieben wird, und dass QCSSL das
// gewaehlte Verzeichnis wirklich zurueckschreibt. Faellt das zweite weg,
// waere die Zeile still: sie sieht dann immer "\r\n" und schweigt.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunRootCertsLogTests(const char* szEudoraDir)
{
	TT_BeginTest("rootcerts.p7b: eudora.log nennt das Verzeichnis, aus dem QCSSL die Liste geladen hat");
	char* pSock = QT_LiesNurCode(szEudoraDir, "..\\QCSocket\\src\\QCWorkerSocket.cpp");
	char* pSsl  = QT_LiesNurCode(szEudoraDir, "..\\QCSSL\\src\\QCSSLContext.cpp");
	if (!pSock || !pSsl)
	{
		TT_Fail("QCWorkerSocket.cpp oder QCSSLContext.cpp nicht lesbar - ungeprueft ist nicht gruen");
		free(pSock); free(pSsl); TT_EndTest(); return;
	}
	QT_LeerraumZusammen(pSock);
	QT_LeerraumZusammen(pSsl);

	char* pFn = QT_Abschnitt(pSock, "static void ProtokolliereRootCertsVerzeichnis(", "bool QCWorkerSocket::InitializeQCSSL()");
	TT_CHECK_MSG(pFn != NULL, "ProtokolliereRootCertsVerzeichnis nicht gefunden");
	if (pFn)
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "pRef->m_CertificateInfo.m_RootCertStoreDir"), "die Zeile liest nicht das Verzeichnis, das QCSSL gewaehlt hat");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "szDir.Find(\"\\r\\n\") >= 0) return;"), "ohne Wahl durch QCSSL (noch beide Kandidaten) wuerde Unsinn protokolliert");
		const long lText = QT_Stelle(pFn, "\"rootcerts.p7b geladen aus: %s (%s)\"");
		const long lLog  = QT_Stelle(pFn, "PutDebugLog(DEBUG_MASK_MISC, szSpur);");
		TT_CHECK_MSG(lText >= 0 && lLog > lText, "der Protokolltext 'rootcerts.p7b geladen aus:' wird nicht geschrieben");
		free(pFn);
	}

	char* pInit = QT_Abschnitt(pSock, "bool QCWorkerSocket::InitializeQCSSL()", "CTaskInfoMT *pTaskInfo");
	TT_CHECK_MSG(pInit != NULL, "InitializeQCSSL nicht gefunden");
	if (pInit)
	{
		const long lBegin = QT_Stelle(pInit, "bSuccess = g_fnQCSSLBeginSession(m_pSSLReference);");
		const long lRuf   = QT_Stelle(pInit, "ProtokolliereRootCertsVerzeichnis(m_pSSLReference);");
		TT_CHECK_MSG(lBegin >= 0 && lRuf > lBegin, "die Zeile wird nicht NACH dem Sitzungsaufbau geschrieben - vorher hat QCSSL noch nicht gewaehlt");
		free(pInit);
	}

	char* pWahl = QT_Abschnitt(pSsl, "void ChooseCertFileDirectory(", "void ChooseCertFileDirectories(");
	TT_CHECK_MSG(pWahl != NULL, "ChooseCertFileDirectory nicht gefunden");
	if (pWahl)
	{
		TT_CHECK_MSG(QT_Enthaelt(pWahl, "strDirectory = strDir1;") && QT_Enthaelt(pWahl, "strDirectory = strDir2;"),
					 "QCSSL schreibt das gewaehlte Verzeichnis nicht mehr zurueck - die Logzeile wuerde schweigen");
		free(pWahl);
	}

	free(pSock);
	free(pSsl);
	TT_EndTest();
}
