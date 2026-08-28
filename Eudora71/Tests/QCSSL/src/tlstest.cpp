//
//	tlstest.cpp
//
//	Komponententest fuer die TLS-Schicht von Eudora (QCSSL), Weg (a):
//	Der Test linkt direkt gegen die statischen OpenSSL-3.5.8-Bibliotheken unter
//	Eudora71/OpenSSL3/lib und bildet die Kontexteinstellungen aus
//	Eudora71/QCSSL/src/QCSSLContext.cpp und den Verify-Rueckruf aus
//	Eudora71/QCSSL/src/qccertificate.cpp nach.
//
//	Damit wird gemessen, was die OpenSSL-Konfiguration von QCSSL tatsaechlich
//	tut - unabhaengig davon, ob QCSSL.dll gerade gebaut werden kann.
//
//	Drei Betriebsarten:
//
//	  tlstest gen <verzeichnis>
//	      Erzeugt eine Test-CA, vier Serverzertifikate und rootcerts.p7b.
//
//	  tlstest servers <verzeichnis>
//	      Startet lokale TLS-Server auf den Ports 14431..14438 und laeuft,
//	      bis der Vorgang beendet wird. Gibt "READY" aus, sobald alle Ports
//	      lauschen.
//
//	  tlstest client <verzeichnis> [--local] [--badssl] [--sni] [--minproto tls1]
//	      Fuehrt die Messungen durch.
//
//	Es werden ausschliesslich TLS-Handshakes durchgefuehrt. Es werden keine
//	Nutzdaten uebertragen und keine Anmeldedaten verwendet.
//

#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <wincrypt.h>
#include <process.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <openssl/ssl.h>
#include <openssl/err.h>
#include <openssl/x509.h>
#include <openssl/x509v3.h>
#include <openssl/pem.h>
#include <openssl/evp.h>
#include <openssl/rand.h>

//	crypt32.h definiert X509_NAME als Makro - das kollidiert mit OpenSSL.
//	Deshalb wird wincrypt.h vor den OpenSSL-Headern eingebunden und die
//	stoerenden Makros werden hier entfernt.
#ifdef X509_NAME
#undef X509_NAME
#endif
#ifdef X509_EXTENSIONS
#undef X509_EXTENSIONS
#endif
#ifdef PKCS7_SIGNER_INFO
#undef PKCS7_SIGNER_INFO
#endif
#ifdef OCSP_RESPONSE
#undef OCSP_RESPONSE
#endif
#ifdef OCSP_REQUEST
#undef OCSP_REQUEST
#endif

// ---------------------------------------------------------------------------
//	Kleine Helfer
// ---------------------------------------------------------------------------

static void Trenner(const char *szTitel)
{
	printf("\n============================================================\n");
	printf("%s\n", szTitel);
	printf("============================================================\n");
}

static void OpenSSLFehlerAusgeben(const char *szWas)
{
	unsigned long ulErr = 0;
	char szBuf[256];
	while ((ulErr = ERR_get_error()) != 0)
	{
		ERR_error_string_n(ulErr, szBuf, sizeof(szBuf));
		printf("    %s: %s\n", szWas, szBuf);
	}
}

// ---------------------------------------------------------------------------
//	Teil 1: Zertifikate erzeugen
// ---------------------------------------------------------------------------

//	Erzeugt ein X509-Zertifikat.
//	pIssuerCert == NULL bedeutet: selbstsigniert.
static X509 *ZertifikatErzeugen(EVP_PKEY *pKey,
								const char *szCN,
								X509 *pIssuerCert,
								EVP_PKEY *pIssuerKey,
								long lNotBeforeSek,
								long lNotAfterSek,
								bool bIstCA)
{
	X509 *pX509 = X509_new();
	if (!pX509)
	{
		return NULL;
	}

	//	Version 3 (der Wert 2 steht fuer v3).
	X509_set_version(pX509, 2);

	unsigned char acSerial[8];
	RAND_bytes(acSerial, sizeof(acSerial));
	acSerial[0] &= 0x7F;
	BIGNUM *pBN = BN_bin2bn(acSerial, sizeof(acSerial), NULL);
	BN_to_ASN1_INTEGER(pBN, X509_get_serialNumber(pX509));
	BN_free(pBN);

	X509_gmtime_adj(X509_getm_notBefore(pX509), lNotBeforeSek);
	X509_gmtime_adj(X509_getm_notAfter(pX509), lNotAfterSek);

	X509_set_pubkey(pX509, pKey);

	X509_NAME *pName = X509_get_subject_name(pX509);
	X509_NAME_add_entry_by_txt(pName, "O", MBSTRING_ASC,
							   (const unsigned char*)"Eudora QCSSL Testlauf", -1, -1, 0);
	X509_NAME_add_entry_by_txt(pName, "CN", MBSTRING_ASC,
							   (const unsigned char*)szCN, -1, -1, 0);

	if (pIssuerCert)
	{
		X509_set_issuer_name(pX509, X509_get_subject_name(pIssuerCert));
	}
	else
	{
		X509_set_issuer_name(pX509, pName);
	}

	X509V3_CTX ctx;
	X509V3_set_ctx_nodb(&ctx);
	X509V3_set_ctx(&ctx, pIssuerCert ? pIssuerCert : pX509, pX509, NULL, NULL, 0);

	X509_EXTENSION *pExt = NULL;

	if (bIstCA)
	{
		pExt = X509V3_EXT_conf_nid(NULL, &ctx, NID_basic_constraints, "critical,CA:TRUE");
		if (pExt) { X509_add_ext(pX509, pExt, -1); X509_EXTENSION_free(pExt); }
		pExt = X509V3_EXT_conf_nid(NULL, &ctx, NID_key_usage, "critical,keyCertSign,cRLSign");
		if (pExt) { X509_add_ext(pX509, pExt, -1); X509_EXTENSION_free(pExt); }
	}
	else
	{
		pExt = X509V3_EXT_conf_nid(NULL, &ctx, NID_basic_constraints, "critical,CA:FALSE");
		if (pExt) { X509_add_ext(pX509, pExt, -1); X509_EXTENSION_free(pExt); }
		pExt = X509V3_EXT_conf_nid(NULL, &ctx, NID_ext_key_usage, "serverAuth");
		if (pExt) { X509_add_ext(pX509, pExt, -1); X509_EXTENSION_free(pExt); }

		//	Der subjectAltName wird gesetzt, weil moderne Bibliotheken den
		//	CommonName gar nicht mehr auswerten. QCSSL prueft dagegen nur den
		//	CommonName - beide Felder tragen hier denselben Namen.
		char szSAN[256];
		_snprintf_s(szSAN, sizeof(szSAN), _TRUNCATE, "DNS:%s", szCN);
		pExt = X509V3_EXT_conf_nid(NULL, &ctx, NID_subject_alt_name, szSAN);
		if (pExt) { X509_add_ext(pX509, pExt, -1); X509_EXTENSION_free(pExt); }
	}

	pExt = X509V3_EXT_conf_nid(NULL, &ctx, NID_subject_key_identifier, "hash");
	if (pExt) { X509_add_ext(pX509, pExt, -1); X509_EXTENSION_free(pExt); }

	if (!X509_sign(pX509, pIssuerKey ? pIssuerKey : pKey, EVP_sha256()))
	{
		OpenSSLFehlerAusgeben("X509_sign");
		X509_free(pX509);
		return NULL;
	}

	return pX509;
}

static bool PemSchreiben(const char *szPfad, X509 *pX509, EVP_PKEY *pKey)
{
	FILE *pFile = NULL;
	if (fopen_s(&pFile, szPfad, "wb") != 0 || !pFile)
	{
		printf("    FEHLER: kann %s nicht schreiben\n", szPfad);
		return false;
	}
	if (pX509) PEM_write_X509(pFile, pX509);
	if (pKey)  PEM_write_PrivateKey(pFile, pKey, NULL, NULL, 0, NULL, NULL);
	fclose(pFile);
	return true;
}

//	Schreibt eine PKCS#7-Datei mit genau einem Zertifikat - dasselbe Format,
//	das QCSSL als rootcerts.p7b erwartet (CertificateStore::LoadFromFile()
//	oeffnet die Datei ueber CERT_STORE_PROV_FILENAME_A).
static bool P7bSchreiben(const char *szPfad, X509 *pX509)
{
	unsigned char *pcDer = NULL;
	int iLen = i2d_X509(pX509, &pcDer);
	if (iLen <= 0)
	{
		return false;
	}

	HCERTSTORE hStore = CertOpenStore(CERT_STORE_PROV_MEMORY,
									  X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
									  0, CERT_STORE_CREATE_NEW_FLAG, NULL);
	if (!hStore)
	{
		OPENSSL_free(pcDer);
		return false;
	}

	BOOL bOk = CertAddEncodedCertificateToStore(hStore, X509_ASN_ENCODING,
												pcDer, (DWORD)iLen,
												CERT_STORE_ADD_ALWAYS, NULL);
	if (bOk)
	{
		bOk = CertSaveStore(hStore,
							X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
							CERT_STORE_SAVE_AS_PKCS7,
							CERT_STORE_SAVE_TO_FILENAME_A,
							(void*)szPfad, 0);
	}

	CertCloseStore(hStore, 0);
	OPENSSL_free(pcDer);
	return bOk ? true : false;
}

static int BefehlGen(const char *szDir)
{
	Trenner("Testzertifikate erzeugen");

	char szPfad[MAX_PATH];

	EVP_PKEY *pCaKey = EVP_RSA_gen(2048);
	if (!pCaKey)
	{
		printf("FEHLER: CA-Schluessel konnte nicht erzeugt werden\n");
		return 1;
	}
	X509 *pCa = ZertifikatErzeugen(pCaKey, "Eudora QCSSL Test CA", NULL, NULL,
								   -3600, 3600L * 24 * 365, true);
	if (!pCa)
	{
		printf("FEHLER: CA-Zertifikat konnte nicht erzeugt werden\n");
		return 1;
	}

	_snprintf_s(szPfad, sizeof(szPfad), _TRUNCATE, "%s\\ca.pem", szDir);
	PemSchreiben(szPfad, pCa, pCaKey);
	printf("  ca.pem                 CN=Eudora QCSSL Test CA\n");

	_snprintf_s(szPfad, sizeof(szPfad), _TRUNCATE, "%s\\rootcerts.p7b", szDir);
	if (P7bSchreiben(szPfad, pCa))
	{
		printf("  rootcerts.p7b          enthaelt die Test-CA\n");
	}
	else
	{
		printf("  rootcerts.p7b          FEHLER beim Schreiben\n");
	}

	//	usercerts.p7b: leer, aber vorhanden. QCSSL laedt die Datei ebenfalls.
	_snprintf_s(szPfad, sizeof(szPfad), _TRUNCATE, "%s\\usercerts.p7b", szDir);
	{
		HCERTSTORE hLeer = CertOpenStore(CERT_STORE_PROV_MEMORY,
										 X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
										 0, CERT_STORE_CREATE_NEW_FLAG, NULL);
		if (hLeer)
		{
			CertSaveStore(hLeer, X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
						  CERT_STORE_SAVE_AS_PKCS7, CERT_STORE_SAVE_TO_FILENAME_A,
						  (void*)szPfad, 0);
			CertCloseStore(hLeer, 0);
			printf("  usercerts.p7b          leer\n");
		}
	}

	struct
	{
		const char	*szDatei;
		const char	*szCN;
		bool		 bVonCA;
		long		 lNotBefore;
		long		 lNotAfter;
		const char	*szZweck;
	} aFaelle[] =
	{
		{ "srv_ok.pem",		    "localhost",		 true,  -3600,              3600L * 24 * 90,  "gueltig, von der Test-CA signiert" },
		{ "srv_expired.pem",	"localhost",		 true,  -3600L * 24 * 400, -3600L * 24 * 30, "abgelaufen" },
		{ "srv_wronghost.pem",  "falsch.example.com", true,  -3600,              3600L * 24 * 90,  "falscher Hostname" },
		{ "srv_selfsigned.pem", "localhost",		 false, -3600,              3600L * 24 * 90,  "selbstsigniert" }
	};

	for (int i = 0; i < (int)(sizeof(aFaelle) / sizeof(aFaelle[0])); i++)
	{
		EVP_PKEY *pKey = EVP_RSA_gen(2048);
		if (!pKey)
		{
			printf("FEHLER: Schluessel fuer %s\n", aFaelle[i].szDatei);
			continue;
		}
		X509 *pX509 = ZertifikatErzeugen(pKey, aFaelle[i].szCN,
										 aFaelle[i].bVonCA ? pCa : NULL,
										 aFaelle[i].bVonCA ? pCaKey : NULL,
										 aFaelle[i].lNotBefore,
										 aFaelle[i].lNotAfter,
										 false);
		if (!pX509)
		{
			printf("FEHLER: Zertifikat fuer %s\n", aFaelle[i].szDatei);
			EVP_PKEY_free(pKey);
			continue;
		}
		_snprintf_s(szPfad, sizeof(szPfad), _TRUNCATE, "%s\\%s", szDir, aFaelle[i].szDatei);
		PemSchreiben(szPfad, pX509, pKey);
		printf("  %-22s CN=%-22s %s\n", aFaelle[i].szDatei, aFaelle[i].szCN, aFaelle[i].szZweck);
		X509_free(pX509);
		EVP_PKEY_free(pKey);
	}

	X509_free(pCa);
	EVP_PKEY_free(pCaKey);
	return 0;
}

// ---------------------------------------------------------------------------
//	Teil 2: Lokale Testserver
// ---------------------------------------------------------------------------

struct ServerFall
{
	unsigned short	 usPort;
	const char		*szZertDatei;
	int				 iMinProto;		//	0 = nicht setzen
	int				 iMaxProto;		//	0 = nicht setzen
	const char		*szBeschreibung;
};

static ServerFall g_aServerFaelle[] =
{
	{ 14431, "srv_ok.pem",		   0,             0,             "gueltiges Zertifikat, freie Versionswahl" },
	{ 14432, "srv_expired.pem",	   0,             0,             "abgelaufenes Zertifikat" },
	{ 14433, "srv_wronghost.pem",  0,             0,             "Zertifikat auf falschen Hostnamen" },
	{ 14434, "srv_selfsigned.pem", 0,             0,             "selbstsigniertes Zertifikat" },
	{ 14435, "srv_ok.pem",		   TLS1_VERSION,  TLS1_VERSION,  "Server nur TLS 1.0" },
	{ 14436, "srv_ok.pem",		   TLS1_1_VERSION,TLS1_1_VERSION,"Server nur TLS 1.1" },
	{ 14437, "srv_ok.pem",		   TLS1_2_VERSION,TLS1_2_VERSION,"Server nur TLS 1.2" },
	{ 14438, "srv_ok.pem",		   TLS1_3_VERSION,TLS1_3_VERSION,"Server nur TLS 1.3" }
};

static const int g_iAnzahlServerFaelle = (int)(sizeof(g_aServerFaelle) / sizeof(g_aServerFaelle[0]));

struct ServerThreadDaten
{
	ServerFall	 fall;
	char		 szDir[MAX_PATH];
	SOCKET		 sockListen;
};

static unsigned __stdcall ServerThread(void *pArg)
{
	ServerThreadDaten *pDaten = (ServerThreadDaten*)pArg;

	char szZert[MAX_PATH];
	_snprintf_s(szZert, sizeof(szZert), _TRUNCATE, "%s\\%s", pDaten->szDir, pDaten->fall.szZertDatei);

	SSL_CTX *pCtx = SSL_CTX_new(TLS_server_method());
	if (!pCtx)
	{
		return 1;
	}

	//	Nur auf der SERVERSEITE wird die Sicherheitsstufe abgesenkt, damit
	//	TLS 1.0/1.1 ueberhaupt angeboten werden koennen. Der Client behaelt
	//	die Vorgaben, weil genau die gemessen werden sollen.
	SSL_CTX_set_security_level(pCtx, 0);
	SSL_CTX_set_cipher_list(pCtx, "ALL:@SECLEVEL=0");

	if (pDaten->fall.iMinProto) SSL_CTX_set_min_proto_version(pCtx, pDaten->fall.iMinProto);
	if (pDaten->fall.iMaxProto) SSL_CTX_set_max_proto_version(pCtx, pDaten->fall.iMaxProto);

	if (SSL_CTX_use_certificate_file(pCtx, szZert, SSL_FILETYPE_PEM) != 1 ||
		SSL_CTX_use_PrivateKey_file(pCtx, szZert, SSL_FILETYPE_PEM) != 1)
	{
		printf("Serverfehler Port %u: Zertifikat %s nicht ladbar\n",
			   pDaten->fall.usPort, szZert);
		SSL_CTX_free(pCtx);
		return 1;
	}

	for (;;)
	{
		sockaddr_in addr;
		int iLen = sizeof(addr);
		SOCKET s = accept(pDaten->sockListen, (sockaddr*)&addr, &iLen);
		if (s == INVALID_SOCKET)
		{
			break;
		}

		SSL *pSSL = SSL_new(pCtx);
		if (pSSL)
		{
			SSL_set_fd(pSSL, (int)s);
			SSL_accept(pSSL);
			SSL_shutdown(pSSL);
			SSL_free(pSSL);
		}
		closesocket(s);
	}

	SSL_CTX_free(pCtx);
	return 0;
}

static int BefehlServers(const char *szDir)
{
	for (int i = 0; i < g_iAnzahlServerFaelle; i++)
	{
		SOCKET s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if (s == INVALID_SOCKET)
		{
			printf("FEHLER: socket() fuer Port %u\n", g_aServerFaelle[i].usPort);
			return 1;
		}
		BOOL bWieder = TRUE;
		setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (const char*)&bWieder, sizeof(bWieder));

		sockaddr_in addr;
		memset(&addr, 0, sizeof(addr));
		addr.sin_family = AF_INET;
		addr.sin_port = htons(g_aServerFaelle[i].usPort);
		addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

		if (bind(s, (sockaddr*)&addr, sizeof(addr)) != 0 || listen(s, 8) != 0)
		{
			printf("FEHLER: Port %u belegt (WSA %d)\n", g_aServerFaelle[i].usPort, WSAGetLastError());
			closesocket(s);
			return 1;
		}

		ServerThreadDaten *pDaten = new ServerThreadDaten;
		pDaten->fall = g_aServerFaelle[i];
		strcpy_s(pDaten->szDir, sizeof(pDaten->szDir), szDir);
		pDaten->sockListen = s;

		_beginthreadex(NULL, 0, ServerThread, pDaten, 0, NULL);
		printf("  Port %u  %s\n", g_aServerFaelle[i].usPort, g_aServerFaelle[i].szBeschreibung);
	}

	printf("READY\n");
	fflush(stdout);

	for (;;)
	{
		Sleep(1000);
	}
}

// ---------------------------------------------------------------------------
//	Teil 3: Client - Nachbildung der Einstellungen aus QCSSLContext.cpp
// ---------------------------------------------------------------------------

//	Beobachtungen aus dem Verify-Rueckruf. Der Client laeuft einfaedig,
//	deshalb reicht eine globale Struktur.
struct Beobachtung
{
	int		 iAufrufe;
	int		 iFehlerCodes[16];
	int		 iAnzahlFehler;
	bool	 bRueckrufHatUeberschrieben;	//	iOK 0 -> 1
	char	 szLeafCN[256];
	bool	 bNameGeprueft;
	bool	 bNamePasst;
	char	 szServerName[256];
};

static Beobachtung g_beob;

static void BeobachtungZuruecksetzen(const char *szServerName)
{
	memset(&g_beob, 0, sizeof(g_beob));
	strcpy_s(g_beob.szServerName, sizeof(g_beob.szServerName), szServerName);
}

//	Nachbildung von QCCertificateUtils::PatternMatchHostName() /
//	CheckCertificateName() - allerdings ohne die Mozilla-Regexp-Variante, die im
//	Originalcode nur greift, wenn der CommonName ein Muster ist.
static bool NamePasstQCSSL(const char *szCertCN, const char *szServer)
{
	if (!szCertCN || !*szCertCN || !szServer || !*szServer)
	{
		return false;
	}

	char szCert[256];
	char szGiven[256];
	strcpy_s(szCert, sizeof(szCert), szCertCN);
	strcpy_s(szGiven, sizeof(szGiven), szServer);
	_strlwr_s(szCert, sizeof(szCert));
	_strlwr_s(szGiven, sizeof(szGiven));

	const char *szRel = strchr(szGiven, '.');
	if (szRel == NULL)
	{
		char *szDomainPart = strchr(szCert, ',');
		if (szDomainPart) *szDomainPart = '\0';
	}

	if (_stricmp(szCert, szGiven) == 0)
	{
		return true;
	}
	if (szRel && _stricmp(szRel, szCert) == 0)
	{
		return true;
	}
	return false;
}

//	Nachbildung von QCCertificateUtils::CertificateCallback().
//	Der Anteil, der die vom Benutzer bestaetigten Zertifikate durchlaesst
//	(CertIsInStore), entfaellt: der Benutzerspeicher ist im Test leer, genau
//	wie bei einer frischen Eudora-Installation.
static int VerifyRueckrufWieQCSSL(int iOK, X509_STORE_CTX *pStoreCtx)
{
	g_beob.iAufrufe++;

	X509 *pCur = X509_STORE_CTX_get_current_cert(pStoreCtx);
	if (!pCur)
	{
		return 0;
	}

	if (iOK == 0)
	{
		int iErr = X509_STORE_CTX_get_error(pStoreCtx);
		if (g_beob.iAnzahlFehler < 16)
		{
			g_beob.iFehlerCodes[g_beob.iAnzahlFehler++] = iErr;
		}

		switch (iErr)
		{
			case X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY:
			case X509_V_ERR_CERT_NOT_YET_VALID:
			case X509_V_ERR_CERT_HAS_EXPIRED:
			case X509_V_ERR_CRL_NOT_YET_VALID:
			case X509_V_ERR_CRL_HAS_EXPIRED:
			case X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT:
			case X509_V_ERR_SELF_SIGNED_CERT_IN_CHAIN:
				//	iOK bleibt 0 -> Handshake scheitert
				break;

			case X509_V_ERR_CERT_UNTRUSTED:
			case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE:
				//	Das Original setzt hier iOK = 1, laesst das Zertifikat also
				//	durch.
				iOK = 1;
				g_beob.bRueckrufHatUeberschrieben = true;
				break;

			default:
				//	Alle uebrigen Faelle: iOK bleibt 0.
				break;
		}
	}

	//	Namensvergleich wie im Original: er beeinflusst den Rueckgabewert NICHT.
	if (!g_beob.bNamePasst)
	{
		char *szOneline = X509_NAME_oneline(X509_get_subject_name(pCur), NULL, 0);
		char szCN[256];
		szCN[0] = '\0';
		if (szOneline)
		{
			const char *p = strstr(szOneline, "/CN=");
			if (p)
			{
				p += 4;
				const char *q = strchr(p, '/');
				size_t n = q ? (size_t)(q - p) : strlen(p);
				if (n >= sizeof(szCN)) n = sizeof(szCN) - 1;
				memcpy(szCN, p, n);
				szCN[n] = '\0';
			}
			OPENSSL_free(szOneline);
		}
		strcpy_s(g_beob.szLeafCN, sizeof(g_beob.szLeafCN), szCN);
		g_beob.bNameGeprueft = true;
		g_beob.bNamePasst = NamePasstQCSSL(szCN, g_beob.szServerName);
	}

	return iOK;
}

//	Nachbildung von SetupCertificates(): laedt rootcerts.p7b ueber dieselben
//	Windows-Aufrufe wie CertificateStore::LoadFromFile() /
//	AddCertificatesToContext() und legt die Zertifikate in den X509_STORE.
static int RootCertsLaden(SSL_CTX *pCtx, const char *szP7bPfad)
{
	HCERTSTORE hStore = CertOpenStore(CERT_STORE_PROV_FILENAME_A,
									  X509_ASN_ENCODING,
									  NULL, 0, szP7bPfad);
	if (!hStore)
	{
		return 0;
	}

	X509_STORE *pX509Store = SSL_CTX_get_cert_store(pCtx);
	int iGeladen = 0;

	PCCERT_CONTEXT pPrev = NULL;
	PCCERT_CONTEXT pCtxCert = NULL;
	while ((pCtxCert = CertEnumCertificatesInStore(hStore, pPrev)) != NULL)
	{
		const unsigned char *pcDer = pCtxCert->pbCertEncoded;
		X509 *pX509 = d2i_X509(NULL, &pcDer, pCtxCert->cbCertEncoded);
		if (pX509)
		{
			if (X509_STORE_add_cert(pX509Store, pX509) == 1)
			{
				iGeladen++;
			}
			X509_free(pX509);
		}
		pPrev = pCtxCert;
	}

	CertCloseStore(hStore, 0);
	return iGeladen;
}

//	Nur fuer die Ursachenklaerung: -1 bedeutet "nicht anfassen" und entspricht
//	QCSSL. Ein Wert >= 0 setzt die OpenSSL-Sicherheitsstufe abweichend, um zu
//	messen, ob sie es ist, die TLS 1.0/1.1 verhindert.
static int g_iSecLevel = -1;

//	Nachbildung von SetSSLVersion() + SetCipherSuites().
static SSL_CTX *KontextWieQCSSL(int iMinVersion, const char *szP7bPfad, int *piRootCerts)
{
	//	SetSSLVersion(): TLS_client_method() und danach
	//	SSL_CTX_set_min_proto_version(). Es wird KEINE Obergrenze gesetzt.
	SSL_CTX *pCtx = SSL_CTX_new(TLS_client_method());
	if (!pCtx)
	{
		return NULL;
	}
	SSL_CTX_set_min_proto_version(pCtx, iMinVersion);

	if (g_iSecLevel >= 0)
	{
		SSL_CTX_set_security_level(pCtx, g_iSecLevel);
		SSL_CTX_set_cipher_list(pCtx, "ALL:@SECLEVEL=0");
	}

	//	SetCipherSuites(): setzt bewusst nichts - die Vorgaben von OpenSSL gelten.

	//	SetupCertificates()
	int iRoots = 0;
	if (szP7bPfad && *szP7bPfad)
	{
		iRoots = RootCertsLaden(pCtx, szP7bPfad);
	}
	if (piRootCerts) *piRootCerts = iRoots;

	//	Wie in BeginQCSSLSession()
	SSL_CTX_set_verify(pCtx, SSL_VERIFY_PEER, VerifyRueckrufWieQCSSL);

	return pCtx;
}

static SOCKET Verbinden(const char *szHost, unsigned short usPort)
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

	SOCKET s = socket(pRes->ai_family, pRes->ai_socktype, pRes->ai_protocol);
	if (s == INVALID_SOCKET)
	{
		freeaddrinfo(pRes);
		return INVALID_SOCKET;
	}

	//	Kurze Zeitlimits: der Test soll nicht haengen bleiben.
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

struct Ergebnis
{
	bool	 bVerbunden;
	bool	 bHandshakeOk;
	char	 szVersion[32];
	char	 szCipher[64];
	long	 lVerifyResult;
	char	 szFehler[256];
};

static void EinTest(const char *szTitel,
					const char *szHost,
					unsigned short usPort,
					int iMinVersion,
					const char *szP7bPfad,
					bool bSNI,
					Ergebnis *pErg)
{
	memset(pErg, 0, sizeof(Ergebnis));
	BeobachtungZuruecksetzen(szHost);
	ERR_clear_error();

	printf("\n--- %s\n", szTitel);
	printf("    Ziel: %s:%u   SNI: %s\n", szHost, usPort, bSNI ? "ja" : "nein (wie QCSSL)");

	int iRoots = 0;
	SSL_CTX *pCtx = KontextWieQCSSL(iMinVersion, szP7bPfad, &iRoots);
	if (!pCtx)
	{
		printf("    FEHLER: Kontext konnte nicht erzeugt werden\n");
		return;
	}

	SOCKET s = Verbinden(szHost, usPort);
	if (s == INVALID_SOCKET)
	{
		printf("    ERGEBNIS: TCP-Verbindung nicht moeglich (WSA %d)\n", WSAGetLastError());
		SSL_CTX_free(pCtx);
		return;
	}
	pErg->bVerbunden = true;

	SSL *pSSL = SSL_new(pCtx);
	SSL_set_fd(pSSL, (int)s);
	if (bSNI)
	{
		SSL_set_tlsext_host_name(pSSL, szHost);
	}
	SSL_set_connect_state(pSSL);

	int iRet = SSL_do_handshake(pSSL);
	if (iRet == 1)
	{
		pErg->bHandshakeOk = true;
	}
	else
	{
		int iErr = SSL_get_error(pSSL, iRet);
		unsigned long ulE = ERR_peek_error();
		char szBuf[200];
		szBuf[0] = '\0';
		if (ulE) ERR_error_string_n(ulE, szBuf, sizeof(szBuf));
		_snprintf_s(pErg->szFehler, sizeof(pErg->szFehler), _TRUNCATE,
					"SSL_get_error=%d  %s", iErr, szBuf);
	}

	const char *szVer = SSL_get_version(pSSL);
	strcpy_s(pErg->szVersion, sizeof(pErg->szVersion), szVer ? szVer : "-");
	const char *szCip = SSL_get_cipher(pSSL);
	strcpy_s(pErg->szCipher, sizeof(pErg->szCipher), szCip ? szCip : "-");
	pErg->lVerifyResult = SSL_get_verify_result(pSSL);

	printf("    Handshake:     %s\n", pErg->bHandshakeOk ? "ERFOLG" : "FEHLGESCHLAGEN");
	printf("    Protokoll:     %s\n", pErg->szVersion);
	printf("    Cipher:        %s\n", pErg->szCipher);
	printf("    Verify-Ergebnis: %ld (%s)\n", pErg->lVerifyResult,
		   X509_verify_cert_error_string(pErg->lVerifyResult));
	printf("    Rueckruf:      %d Aufrufe, Fehlercodes:", g_beob.iAufrufe);
	if (g_beob.iAnzahlFehler == 0)
	{
		printf(" keine");
	}
	for (int i = 0; i < g_beob.iAnzahlFehler; i++)
	{
		printf(" %d(%s)", g_beob.iFehlerCodes[i],
			   X509_verify_cert_error_string(g_beob.iFehlerCodes[i]));
	}
	printf("\n");
	if (g_beob.bRueckrufHatUeberschrieben)
	{
		printf("    ACHTUNG:       Rueckruf hat einen Fehler ueberschrieben (iOK 0 -> 1)\n");
	}
	printf("    Zertifikat-CN: %s\n", g_beob.szLeafCN[0] ? g_beob.szLeafCN : "(keines gesehen)");
	printf("    Namenspruefung nach QCSSL-Logik: %s\n",
		   !g_beob.bNameGeprueft ? "nicht durchgefuehrt" :
		   (g_beob.bNamePasst ? "passt" : "PASST NICHT"));
	if (!pErg->bHandshakeOk)
	{
		printf("    Fehlertext:    %s\n", pErg->szFehler);
	}

	SSL_free(pSSL);
	closesocket(s);
	SSL_CTX_free(pCtx);
}

static void AngeboteneCiphersAusgeben(int iMinVersion)
{
	SSL_CTX *pCtx = SSL_CTX_new(TLS_client_method());
	SSL_CTX_set_min_proto_version(pCtx, iMinVersion);
	SSL *pSSL = SSL_new(pCtx);

	STACK_OF(SSL_CIPHER) *pStack = SSL_get1_supported_ciphers(pSSL);
	int iN = pStack ? sk_SSL_CIPHER_num(pStack) : 0;
	printf("  Anzahl angebotener Cipher Suites: %d\n", iN);
	for (int i = 0; i < iN; i++)
	{
		const SSL_CIPHER *pC = sk_SSL_CIPHER_value(pStack, i);
		printf("    %2d. %-32s %s  %d Bit\n", i + 1,
			   SSL_CIPHER_get_name(pC),
			   SSL_CIPHER_get_version(pC),
			   SSL_CIPHER_get_bits(pC, NULL));
	}
	if (pStack) sk_SSL_CIPHER_free(pStack);
	SSL_free(pSSL);
	SSL_CTX_free(pCtx);
}

static int BefehlClient(const char *szDir, bool bLokal, bool bBadssl, int iMinVersion)
{
	char szP7b[MAX_PATH];
	_snprintf_s(szP7b, sizeof(szP7b), _TRUNCATE, "%s\\rootcerts.p7b", szDir);

	Trenner("Ausgangslage");
	printf("  OpenSSL-Version zur Laufzeit: %s\n", OpenSSL_version(OPENSSL_VERSION));
	printf("  Untergrenze wie SetSSLVersion(): %s\n",
		   iMinVersion == TLS1_VERSION ? "TLS 1.0 (ProtocolVersion == 3)" : "TLS 1.2 (Normalfall)");
	{
		SSL_CTX *pTmp = SSL_CTX_new(TLS_client_method());
		int iRoots = RootCertsLaden(pTmp, szP7b);
		printf("  rootcerts.p7b: %s -> %d Zertifikat(e)\n", szP7b, iRoots);
		SSL_CTX_free(pTmp);
	}

	Trenner("Pruefpunkt 3: angebotene Cipher Suites");
	AngeboteneCiphersAusgeben(iMinVersion);

	Ergebnis erg;

	if (bLokal)
	{
		Trenner("Pruefpunkt 1: Verhalten bei ungueltigen Zertifikaten (lokale Server)");

		EinTest("1a  gueltiges Zertifikat, CA im Wurzelspeicher (Erwartung: ERFOLG)",
				"localhost", 14431, iMinVersion, szP7b, false, &erg);
		EinTest("1b  ABGELAUFENES Zertifikat (Erwartung: FEHLSCHLAG)",
				"localhost", 14432, iMinVersion, szP7b, false, &erg);
		EinTest("1c  Zertifikat auf FALSCHEN HOSTNAMEN (Erwartung: FEHLSCHLAG)",
				"localhost", 14433, iMinVersion, szP7b, false, &erg);
		EinTest("1d  SELBSTSIGNIERTES Zertifikat (Erwartung: FEHLSCHLAG)",
				"localhost", 14434, iMinVersion, szP7b, false, &erg);
		EinTest("1e  gueltiges Zertifikat, aber Wurzelspeicher LEER (Erwartung: FEHLSCHLAG)",
				"localhost", 14431, iMinVersion, "", false, &erg);

		Trenner("Pruefpunkt 2: Protokollaushandlung (lokale Server)");

		EinTest("2a  Server nur TLS 1.0 (Erwartung bei Untergrenze TLS 1.2: FEHLSCHLAG)",
				"localhost", 14435, iMinVersion, szP7b, false, &erg);
		EinTest("2b  Server nur TLS 1.1 (Erwartung bei Untergrenze TLS 1.2: FEHLSCHLAG)",
				"localhost", 14436, iMinVersion, szP7b, false, &erg);
		EinTest("2c  Server nur TLS 1.2 (Erwartung: ERFOLG)",
				"localhost", 14437, iMinVersion, szP7b, false, &erg);
		EinTest("2d  Server nur TLS 1.3 (Erwartung: ERFOLG mit TLS 1.3)",
				"localhost", 14438, iMinVersion, szP7b, false, &erg);
		EinTest("2e  Server freie Wahl (Erwartung: hoechste gemeinsame Version)",
				"localhost", 14431, iMinVersion, szP7b, false, &erg);
	}

	if (bBadssl)
	{
		Trenner("Gegenprobe im Netz: badssl.com");
		printf("  Hinweis: QCSSL setzt keinen SNI-Namen. badssl.com unterscheidet die\n");
		printf("  Endpunkte aber ueber SNI. Deshalb wird jeder Fall zweimal gemessen -\n");
		printf("  einmal ohne SNI (wie QCSSL) und einmal mit SNI.\n");

		struct { const char *szHost; unsigned short usPort; const char *szTitel; } aZiele[] =
		{
			{ "badssl.com",             443,  "gueltiges Zertifikat" },
			{ "self-signed.badssl.com", 443,  "selbstsigniert" },
			{ "expired.badssl.com",     443,  "abgelaufen" },
			{ "wrong.host.badssl.com",  443,  "falscher Hostname" },
			{ "untrusted-root.badssl.com", 443, "unbekannte Wurzel" },
			{ "tls-v1-0.badssl.com",    1010, "Server TLS 1.0" },
			{ "tls-v1-1.badssl.com",    1011, "Server TLS 1.1" },
			{ "tls-v1-2.badssl.com",    1012, "Server TLS 1.2" }
		};

		for (int i = 0; i < (int)(sizeof(aZiele) / sizeof(aZiele[0])); i++)
		{
			char szTitel[256];
			_snprintf_s(szTitel, sizeof(szTitel), _TRUNCATE, "%s - ohne SNI (wie QCSSL)", aZiele[i].szTitel);
			EinTest(szTitel, aZiele[i].szHost, aZiele[i].usPort, iMinVersion, szP7b, false, &erg);

			_snprintf_s(szTitel, sizeof(szTitel), _TRUNCATE, "%s - mit SNI (Vergleich)", aZiele[i].szTitel);
			EinTest(szTitel, aZiele[i].szHost, aZiele[i].usPort, iMinVersion, szP7b, true, &erg);
		}
	}

	return 0;
}

// ---------------------------------------------------------------------------

static void HilfeAusgeben(void)
{
	printf("Aufruf:\n");
	printf("  tlstest gen     <verzeichnis>\n");
	printf("  tlstest servers <verzeichnis>\n");
	printf("  tlstest client  <verzeichnis> [--local] [--badssl] [--minproto tls1]\n");
}

int main(int argc, char **argv)
{
	WSADATA wsa;
	WSAStartup(MAKEWORD(2, 2), &wsa);

	OPENSSL_init_ssl(OPENSSL_INIT_LOAD_SSL_STRINGS | OPENSSL_INIT_LOAD_CRYPTO_STRINGS, NULL);

	if (argc < 3)
	{
		HilfeAusgeben();
		return 2;
	}

	const char *szBefehl = argv[1];
	const char *szDir = argv[2];

	if (strcmp(szBefehl, "gen") == 0)
	{
		return BefehlGen(szDir);
	}
	if (strcmp(szBefehl, "servers") == 0)
	{
		return BefehlServers(szDir);
	}
	if (strcmp(szBefehl, "client") == 0)
	{
		bool bLokal = false;
		bool bBadssl = false;
		int iMinVersion = TLS1_2_VERSION;

		for (int i = 3; i < argc; i++)
		{
			if (strcmp(argv[i], "--local") == 0)  bLokal = true;
			else if (strcmp(argv[i], "--badssl") == 0) bBadssl = true;
			else if (strcmp(argv[i], "--minproto") == 0 && (i + 1) < argc)
			{
				i++;
				if (strcmp(argv[i], "tls1") == 0) iMinVersion = TLS1_VERSION;
			}
			else if (strcmp(argv[i], "--seclevel") == 0 && (i + 1) < argc)
			{
				i++;
				g_iSecLevel = atoi(argv[i]);
			}
		}
		if (!bLokal && !bBadssl)
		{
			bLokal = true;
		}
		return BefehlClient(szDir, bLokal, bBadssl, iMinVersion);
	}

	HilfeAusgeben();
	return 2;
}
