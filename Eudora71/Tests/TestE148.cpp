//
// TestE148.cpp - liefert Eudora Wurzelzertifikate aus, denen nicht mehr zu
// trauen ist? (Befund E-148, kritisch)
//
// QCSSL prueft Serverzertifikate gegen eine eigene Datei rootcerts.p7b, nicht
// gegen Windows, und fragt keine Sperrlisten ab. Am 20.10.2026 wurden acht
// Zwischenzertifikate der Zertifizierungsstelle eMudhra mit Schluesseln von
// 3 bis 8 Bit bekannt; die ausgelieferte Liste enthielt vier eMudhra-Wurzeln
// darueber. Wer zwischen Eudora und dem Mailserver sitzt, haette Eudora damit
// einen gefaelschten Server vorspielen koennen.
//
// Geprueft wird die Datei, die der Paketbau ausliefert (Releases\1.0), mit
// DERSELBEN Systemfunktion, mit der Eudora sie laedt
// (CertOpenStore(CERT_STORE_PROV_FILENAME_A), certstore.cpp) - und dass
// paket-bauen.ps1 sie ueber die Grundlage legt, die noch die alte traegt.
//
#include <afx.h>
#include <wincrypt.h>
#include <string.h>
#include <stdio.h>

#include "TinyTest.h"
#include "Quelltext.h"

#pragma comment(lib, "crypt32.lib")

void RunE148Tests(const char* szEudoraDir)
{
	TT_Suite("E-148: keine kompromittierten Wurzelzertifikate im Paket");

	TT_BeginTest("E-148: Releases\\1.0\\rootcerts.p7b enthaelt keine eMudhra-Wurzel");
	{
		char szPfad[MAX_PATH * 2];
		_snprintf(szPfad, sizeof(szPfad) - 1, "%s\\..\\..\\Releases\\1.0\\rootcerts.p7b", szEudoraDir);
		szPfad[sizeof(szPfad) - 1] = 0;

		HCERTSTORE hStore = ::CertOpenStore(CERT_STORE_PROV_FILENAME_A, X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
											NULL, CERT_STORE_READONLY_FLAG, szPfad);
		if (!hStore) { TT_Fail("rootcerts.p7b laesst sich nicht oeffnen - ungeprueft ist nicht gruen"); TT_EndTest(); return; }

		int nGesamt = 0, nVerboten = 0;
		PCCERT_CONTEXT pCert = NULL;
		while ((pCert = ::CertEnumCertificatesInStore(hStore, pCert)) != NULL)
		{
			nGesamt++;
			char szOrg[256] = "";
			::CertGetNameStringA(pCert, CERT_NAME_ATTR_TYPE, 0, (void*)szOID_ORGANIZATION_NAME, szOrg, sizeof(szOrg));
			if (strstr(szOrg, "eMudhra"))
			{
				nVerboten++;
				char szName[256] = "";
				::CertGetNameStringA(pCert, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, NULL, szName, sizeof(szName));
				printf("         verboten: %s (%s)\n", szName, szOrg);
			}
		}
		::CertCloseStore(hStore, 0);

		// Positivprobe: eine leere oder kaputte Datei waere sonst gruen.
		TT_CHECK_MSG(nGesamt >= 100, "weniger als 100 Wurzeln gelesen - Datei leer oder falsch gelesen");
		TT_CHECK_MSG(nVerboten == 0, "eine eMudhra-Wurzel ist wieder in der ausgelieferten Liste");
	}
	TT_EndTest();

	TT_BeginTest("E-148: paket-bauen.ps1 legt rootcerts.p7b aus Releases\\1.0 ueber die Grundlage");
	{
		// Roh lesen: PowerShell-Kommentare beginnen mit #, nicht mit //.
		char* pSkript = QT_Lesen(szEudoraDir, "..\\..\\tools\\paket-bauen.ps1");
		if (!pSkript) { TT_Fail("paket-bauen.ps1 nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
		const char* szAufruf = "\nNimm (Join-Path $wurzel 'Releases\\1.0\\rootcerts.p7b') 'rootcerts.p7b'";
		TT_CHECK_MSG(QT_Enthaelt(pSkript, szAufruf),
					 "der Paketbau uebernimmt rootcerts.p7b nicht mehr - im Paket stuende die alte Liste der Grundlage");
		free(pSkript);
	}
	TT_EndTest();
}
