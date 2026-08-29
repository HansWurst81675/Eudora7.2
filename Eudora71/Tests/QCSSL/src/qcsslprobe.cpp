//
//	qcsslprobe.cpp
//
//	Komponententest fuer die TLS-Schicht von Eudora (QCSSL), Weg (b):
//	Dieses Programm benutzt die ausgelieferte QCSSL.dll selbst. Es laedt die
//	DLL, baut eine QCSSLReference wie Eudora auf, stellt die Lese- und
//	Schreibrueckrufe ueber einen gewoehnlichen Winsock-Socket bereit und ruft
//	QCSSLBeginSession() auf. Danach wird ueber QCSSLGetConnectionInfo() das
//	ausgelesen, was auch Eudoras Dialog "Last SSL Info" anzeigt.
//
//	Gemessen wird damit der echte Produktivpfad, einschliesslich
//	SetSSLVersion(), SetCipherSuites(), SetupCertificates() und dem
//	Verify-Rueckruf QCCertificateUtils::CertificateCallback().
//
//	Voraussetzungen an den Bau: x86, MFC dynamisch, MBCS, /MD - identisch zu
//	QCSSL.vcxproj. Sonst passt die Speicherdarstellung von CString/CPtrList
//	ueber die DLL-Grenze hinweg nicht.
//
//	Aufruf:
//	  qcsslprobe <pfad-zu-QCSSL.dll> <zertverzeichnis> <host> <port>
//	             [<protokollversion>] [<fallname>]
//
//	<protokollversion> entspricht ProtocolInfo::m_ProtocolVersion:
//	  0 = automatisch (Untergrenze TLS 1.2), 3 = frueher TLSv1 (Untergrenze TLS 1.0)
//
//	Es werden ausschliesslich TLS-Handshakes durchgefuehrt, keine Nutzdaten.
//

#include <winsock2.h>
#include <ws2tcpip.h>

#include <afxwin.h>
#include <afxdisp.h>

#include <stdio.h>

#include "QCSSL.h"

// ---------------------------------------------------------------------------
//	Socket und Rueckrufe
// ---------------------------------------------------------------------------

static SOCKET	g_sock = INVALID_SOCKET;
static long		g_lBytesGelesen = 0;
static long		g_lBytesGeschrieben = 0;

//	QCSSLs BIO (ws_read in QCSSLContext.cpp) wertet einen Rueckgabewert
//	kleiner als die angeforderte Laenge als Fehler. Deshalb wird hier
//	blockierend gelesen, bis die volle Menge zusammen ist.
static long QCSSLReadCallback(void *pBio, int iCmd, const char *pcBuf, int iLen,
							  long lRef, long lRet)
{
	UNREFERENCED_PARAMETER(pBio);
	UNREFERENCED_PARAMETER(iCmd);
	UNREFERENCED_PARAMETER(lRef);
	UNREFERENCED_PARAMETER(lRet);

	char	*pcZiel = const_cast<char*>(pcBuf);
	int		 iGesamt = 0;

	while (iGesamt < iLen)
	{
		int iN = recv(g_sock, pcZiel + iGesamt, iLen - iGesamt, 0);
		if (iN <= 0)
		{
			break;
		}
		iGesamt += iN;
	}

	g_lBytesGelesen += iGesamt;
	return iGesamt;
}

static long QCSSLWriteCallback(void *pBio, int iCmd, const char *pcBuf, int iLen,
							   long lRef, long lRet)
{
	UNREFERENCED_PARAMETER(pBio);
	UNREFERENCED_PARAMETER(iCmd);
	UNREFERENCED_PARAMETER(lRef);
	UNREFERENCED_PARAMETER(lRet);

	int iGesamt = 0;
	while (iGesamt < iLen)
	{
		int iN = send(g_sock, pcBuf + iGesamt, iLen - iGesamt, 0);
		if (iN <= 0)
		{
			break;
		}
		iGesamt += iN;
	}

	g_lBytesGeschrieben += iGesamt;
	return iGesamt;
}

static bool UpdateProgressCallback(int nCode, const char *szMessage, void *pRef)
{
	UNREFERENCED_PARAMETER(nCode);
	UNREFERENCED_PARAMETER(szMessage);
	UNREFERENCED_PARAMETER(pRef);
	return true;
}

// ---------------------------------------------------------------------------

static SOCKET Verbinden(const char *szHost, unsigned short usPort, CString &strIP)
{
	char szPort[16];
	_snprintf_s(szPort, sizeof(szPort), _TRUNCATE, "%u", usPort);

	addrinfo hints;
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_INET;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;

	addrinfo *pRes = NULL;
	if (getaddrinfo(szHost, szPort, &hints, &pRes) != 0 || !pRes)
	{
		return INVALID_SOCKET;
	}

	char szIP[64];
	szIP[0] = '\0';
	sockaddr_in *pIn = (sockaddr_in*)pRes->ai_addr;
	inet_ntop(AF_INET, &pIn->sin_addr, szIP, sizeof(szIP));
	strIP = szIP;

	SOCKET s = socket(pRes->ai_family, pRes->ai_socktype, pRes->ai_protocol);
	if (s == INVALID_SOCKET)
	{
		freeaddrinfo(pRes);
		return INVALID_SOCKET;
	}

	DWORD dwTimeout = 8000;
	setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, (const char*)&dwTimeout, sizeof(dwTimeout));
	setsockopt(s, SOL_SOCKET, SO_SNDTIMEO, (const char*)&dwTimeout, sizeof(dwTimeout));

	if (connect(s, pRes->ai_addr, (int)pRes->ai_addrlen) != 0)
	{
		closesocket(s);
		freeaddrinfo(pRes);
		return INVALID_SOCKET;
	}

	freeaddrinfo(pRes);
	return s;
}

static const char *OutcomeText(int iOutcome)
{
	switch (iOutcome)
	{
		case SSLOutcome::SSLUNKNOWN:	return "SSLUNKNOWN";
		case SSLOutcome::SSLFAILED:		return "SSLFAILED";
		case SSLOutcome::SSLSUCCEEDED:	return "SSLSUCCEEDED";
		case SSLOutcome::SSLREJECTED:	return "SSLREJECTED";
		default:						return "?";
	}
}

//	QCSSLBeginSession() laeuft in einer eigenen Funktion, weil __try/__except
//	nicht mit Funktionen zusammengeht, die C++-Objekte abbauen muessen.
static bool BeginSicher(FPNQCSSLBeginSession pfn, QCSSLReference *pRef, DWORD *pdwCode)
{
	__try
	{
		return pfn(pRef);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		*pdwCode = GetExceptionCode();
		return false;
	}
}

static void MehrzeiligAusgeben(const char *szEinzug, const CString &str)
{
	if (str.IsEmpty())
	{
		printf("%s(leer)\n", szEinzug);
		return;
	}
	CString s = str;
	s.Replace("\r\n", "\n");
	int iPos = 0;
	while (iPos < s.GetLength())
	{
		int iEnde = s.Find('\n', iPos);
		if (iEnde < 0) iEnde = s.GetLength();
		CString zeile = s.Mid(iPos, iEnde - iPos);
		zeile.TrimRight();
		if (!zeile.IsEmpty())
		{
			printf("%s%s\n", szEinzug, (LPCTSTR)zeile);
		}
		iPos = iEnde + 1;
	}
}

int main(int argc, char **argv)
{
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		printf("FEHLER: AfxWinInit fehlgeschlagen\n");
		return 1;
	}
	AfxOleInit();

	if (argc < 5)
	{
		printf("Aufruf: qcsslprobe <QCSSL.dll> <zertverzeichnis> <host> <port> "
			   "[protokollversion] [fallname]\n");
		return 2;
	}

	const char		*szDll		= argv[1];
	const char		*szCertDir	= argv[2];
	const char		*szHost		= argv[3];
	unsigned short	 usPort		= (unsigned short)atoi(argv[4]);
	int				 iProtoVer	= (argc > 5) ? atoi(argv[5]) : 0;
	const char		*szFall		= (argc > 6) ? argv[6] : "Fall";

	WSADATA wsa;
	WSAStartup(MAKEWORD(2, 2), &wsa);

	printf("\n--- %s\n", szFall);
	printf("    Ziel: %s:%u   ProtocolVersion=%d\n", szHost, usPort, iProtoVer);

	HMODULE hDll = ::LoadLibraryA(szDll);
	if (!hDll)
	{
		printf("    FEHLER: %s konnte nicht geladen werden (GetLastError %lu)\n",
			   szDll, ::GetLastError());
		return 1;
	}

	FPNQCSSLBeginSession		pfnBegin	= (FPNQCSSLBeginSession)::GetProcAddress(hDll, "QCSSLBeginSession");
	FPNQCSSLEndSession			pfnEnd		= (FPNQCSSLEndSession)::GetProcAddress(hDll, "QCSSLEndSession");
	FPNQCSSLGetConnectionInfo	pfnInfo		= (FPNQCSSLGetConnectionInfo)::GetProcAddress(hDll, "QCSSLGetConnectionInfo");

	if (!pfnBegin || !pfnInfo)
	{
		printf("    FEHLER: Ausfuhren aus QCSSL.dll nicht gefunden\n");
		return 1;
	}

	CString strIP;
	g_sock = Verbinden(szHost, usPort, strIP);
	if (g_sock == INVALID_SOCKET)
	{
		printf("    ERGEBNIS: TCP-Verbindung nicht moeglich (WSA %d)\n", WSAGetLastError());
		return 1;
	}

	//	Jeder Fall bekommt eine eigene Persona, damit sich die ConnectionInfo-
	//	Objekte nicht ueberlagern.
	CString strPersona;
	strPersona.Format("Test_%s_%u", szHost, usPort);

	QCSSLReference ref;
	ref.m_Persona = strPersona;
	ref.m_SSLLogSession = 0;

	//	ChooseCertFileDirectory() erwartet in diesem Feld zwei Verzeichnisse,
	//	getrennt durch "\r\n" (EudoraDir und ExecutableDir). Hier steht zweimal
	//	dasselbe Verzeichnis.
	CString strDirs;
	strDirs.Format("%s\r\n%s", szCertDir, szCertDir);
	ref.m_CertificateInfo.m_RootCertStoreDir = strDirs;
	ref.m_CertificateInfo.m_UserCertStoreDir = strDirs;
	ref.m_CertificateInfo.m_bIgnoreExpired = 0;

	ref.m_SessionResumptionInfo.m_bSessionResumption = false;
	ref.m_SessionResumptionInfo.m_ExpiryTime = 0;

	ref.m_ProtocolInfo.m_ProtocolName = "POP";
	ref.m_ProtocolInfo.m_ProtocolVersion = iProtoVer;
	ref.m_ProtocolInfo.m_CryptoGraphicStrength = 0;
	ref.m_ProtocolInfo.m_ServerName = szHost;
	ref.m_ProtocolInfo.m_IPAddress = strIP;
	ref.m_ProtocolInfo.m_Port = usPort;
	ref.m_ProtocolInfo.m_AllowSSL_2_0 = 0;
	ref.m_ProtocolInfo.m_MinEncryption = 0;
	ref.m_ProtocolInfo.m_MinKeyExchangeLength = 0;
	ref.m_ProtocolInfo.m_CipherSuite = 15;
	ref.m_ProtocolInfo.m_AllowRegExp = 1;

	ref.m_fnQCSSLReadCallback = QCSSLReadCallback;
	ref.m_fnQCSSLWriteCallback = QCSSLWriteCallback;
	ref.m_fnUpdateSSLProgressCallback = UpdateProgressCallback;

	ref.m_pSSL = NULL;
	ref.m_pIORef = NULL;
	ref.m_pConnectionManagerInfo = NULL;
	ref.m_pSurrenderRef = NULL;
	ref.m_pUpdateProgressRef = NULL;

	DWORD dwAusnahme = 0;
	bool bOk = BeginSicher(pfnBegin, &ref, &dwAusnahme);
	if (dwAusnahme != 0)
	{
		printf("    FEHLER: QCSSLBeginSession() hat eine Ausnahme ausgeloest (Code 0x%08lX)\n",
			   (unsigned long)dwAusnahme);
		closesocket(g_sock);
		return 1;
	}

	printf("    QCSSLBeginSession(): %s\n", bOk ? "true (Handshake erfolgreich)"
											     : "false (Handshake fehlgeschlagen)");
	printf("    Bytes gesendet/empfangen: %ld / %ld\n", g_lBytesGeschrieben, g_lBytesGelesen);

	ConnectionInfo *pInfo = pfnInfo((LPCTSTR)strPersona, "POP");
	if (!pInfo)
	{
		printf("    FEHLER: keine ConnectionInfo gefunden\n");
	}
	else
	{
		printf("    Protokoll (m_Version):   %s\n",
			   pInfo->m_Version.IsEmpty() ? "(leer)" : (LPCTSTR)pInfo->m_Version);
		printf("    Cipher (m_CipherName):   %s\n",
			   pInfo->m_CipherName.IsEmpty() ? "(leer)" : (LPCTSTR)pInfo->m_CipherName);
		printf("    Schluessellaenge:        %lu Bit\n", pInfo->m_CipherKeyBits);
		printf("    Outcome:                 %s\n", OutcomeText((int)pInfo->m_Outcome.m_Outcome));
		printf("    ErrorCode:               %ld\n", pInfo->m_Outcome.m_ErrorCode);
		printf("    m_bCertRejected:         %s\n", pInfo->m_Outcome.m_bCertRejected ? "true" : "false");
		printf("    Name geprueft / passt:   %s / %s\n",
			   pInfo->m_Outcome.m_bCheckedName ? "ja" : "nein",
			   pInfo->m_Outcome.m_bNameMatch ? "ja" : "NEIN");
		printf("    Fehlertexte:\n");
		MehrzeiligAusgeben("      ", pInfo->m_Outcome.m_Errors);
		printf("    Anmerkungen:\n");
		MehrzeiligAusgeben("      ", pInfo->m_Outcome.m_Comments);

		printf("    Gesehene Zertifikate: %d\n", (int)pInfo->m_CertDataList.GetCount());
		POSITION pos = pInfo->m_CertDataList.GetHeadPosition();
		while (pos != NULL)
		{
			CertData *pCert = (CertData*)pInfo->m_CertDataList.GetNext(pos);
			if (pCert)
			{
				printf("      CN=%-30s vertraut=%s\n",
					   (LPCTSTR)pCert->m_CommonName,
					   pCert->m_bTrusted ? "ja" : "nein");
			}
		}
	}

	if (pfnEnd && ref.m_pSSL)
	{
		pfnEnd(ref.m_pSSL);
	}
	closesocket(g_sock);
	g_sock = INVALID_SOCKET;

	//	Rueckgabewert: 0 wenn der Handshake gelang, sonst 3. So kann das
	//	aufrufende Skript Erwartungen pruefen.
	return bOk ? 0 : 3;
}
