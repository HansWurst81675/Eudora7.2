//
// TestE23.cpp - Regressionstest zu E-23 (POP3 nur ueber Port 110)
//
// E-23, Befunde/PORT.md: drei Loecher, durch die ein verschluesselt
// gemeinter Abruf oder Versand still im KLARTEXT auf dem gewoehnlichen Port
// landete. Port 995 mit TLS 1.3 ist seit dem 06.09.2026 gemessen.
//
//   1. POPSession.cpp: "Alternate Port" ohne SSLPOPAlternatePort in der Ini
//      (Wert 0) - Open schlug den Dienstnamen "pop3" nach und nahm 110.
//   2. SMTPSession.cpp: dasselbe beim Versand, 25 statt 465.
//   3. QCWorkerSocket.cpp, Network::SetSSLMode: fehlte qcssl.dll, kehrte es
//      ohne m_bSSLMode zurueck, und der Aufrufer redete im Klartext weiter.
//
// Alle drei Stellen haengen an Netz, Einstellungen und DLL-Laden - der
// Pruefstand liest deshalb die STELLE (Quelltext.h).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void PruefeAbschnitt(const char* szEudoraDir, const char* szDatei, const char* szVon, const char* szBis,
							const char* szMuss, const char* szDanach, const char* szMeldung)
{
	char* pText = QT_LiesNurCode(szEudoraDir, szDatei);
	if (!pText)
	{
		TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", szDatei);
		return;
	}
	char* pAb = QT_Abschnitt(pText, szVon, szBis);
	if (!pAb)
		TT_Fail("%s: Abschnitt '%s' nicht gefunden", szDatei, szVon);
	else
	{
		const long lMuss = QT_Stelle(pAb, szMuss);
		if (lMuss < 0)
			TT_Fail("%s: %s", szDatei, szMeldung);
		else if (szDanach && QT_Stelle(pAb, szDanach) < lMuss)
			TT_Fail("%s: '%s' steht nicht hinter der Berichtigung - %s", szDatei, szDanach, szMeldung);
		free(pAb);
	}
	free(pText);
}

void RunE23Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-23 (Quelltext): verschluesselter Abruf und Versand fallen nicht still auf 110 bzw. 25 zurueck");

	PruefeAbschnitt(szEudoraDir, "POPSession.cpp",
		"else if(m_Settings->m_SSLSettings.GetSSLReceiveUsage() == QCSSLSettings::SSLUseAlternatePort)",
		"char Server[128];",
		"DefaultPort = 995; if (idPopPort == 0) idPopPort = DefaultPort;",
		NULL,
		"Port 0 bei 'Alternate Port' wird nicht mehr auf 995 gesetzt - Open landet ueber den Dienstnamen auf 110");

	PruefeAbschnitt(szEudoraDir, "SMTPSession.cpp",
		"if(m_Settings->m_SSLSettings.GetSSLSendUsage() == SSLSettings::SSLUseAlternatePort)",
		"Status = m_pNetConnection->Open(Server, IDS_SMTP_SERVICE, port, 465);",
		"if (port == 0) port = 465;",
		"Status = m_pNetConnection->Open(Server, IDS_SMTP_SERVICE, port, 465);",
		"Port 0 bei 'Alternate Port' wird nicht mehr auf 465 gesetzt - Open landet ueber den Dienstnamen auf 25");

	PruefeAbschnitt(szEudoraDir, "..\\QCSocket\\src\\QCWorkerSocket.cpp",
		"void Network::SetSSLMode(",
		"g_fnQCSSLBeginSession = (FPNQCSSLBeginSession)GetProcAddress(",
		"if(!g_QCSSLDll) { m_bSSLMode = bVal; return; }",
		NULL,
		"fehlt qcssl.dll, bleibt m_bSSLMode falsch - der Aufrufer spricht im Klartext auf dem TLS-Port weiter");

	TT_EndTest();
}
