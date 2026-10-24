//
// TestE130.cpp - bleiben die mitgelieferten Fremd-DLLs von QUALCOMM im Original?
//
// Befund E-130: nach jedem Release-Bau waren DirServ, EudoraBk, ISock, Ldap
// und Ph veraendert, und im Paket lagen andere Fassungen als im Repo. Die
// Ursache war BinTools\BindExe.bat: der Nachbauschritt liess QUALCOMMs
// "bind -u" ueber ALLE DLLs in Bin\Release laufen, auch ueber die
// vorgebauten fremden. bind traegt ein Verzeichnis gebundener Importe ein
// (IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT) und schreibt Pruefsumme und
// Zeitstempel. PRUEFER-48 K1 fand dieselbe Spur an sieben weiteren DLLs.
//
// Gemessen am 24.10.2026: in allen zwoelf Originalen (Erstcommit 567a5d87)
// ist das Verzeichnis gebundener Importe LEER (Groesse 0), in den
// gebundenen Fassungen 48 bis 324 Byte gross. Das ist das Merkmal, an dem
// dieser Test erkennt, ob jemand sie wieder gebunden hat.
//
// Zwei Pruefungen, eine je Richtung:
//   (1) jede der zwoelf Fremd-DLLs in Bin\Release ist ungebunden
//   (2) BindExe.bat nennt keine von ihnen - sonst kommt der Fehler mit dem
//       naechsten Bau zurueck, auch wenn (1) heute gruen ist
//
#include <afx.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"

static const char* s_aFremd[] = {
	"DirServ.dll", "EudoraBk.dll", "ISock.dll", "Ldap.dll", "Ph.dll",
	"EuMemMgr.dll", "libeay32.dll", "libexpat.dll", "SPELL32.DLL",
	"ssleay32.dll", "LDAP32.DLL", "Paige32.dll",
};

static char* Lies(const char* szPfad, long* plSize)
{
	FILE* f = fopen(szPfad, "rb");
	char* pBuf;
	long  lSize;

	*plSize = 0;
	if (!f) return 0;
	fseek(f, 0, SEEK_END);
	lSize = ftell(f);
	fseek(f, 0, SEEK_SET);
	pBuf = (char*)malloc((size_t)lSize + 1);
	if (!pBuf) { fclose(f); return 0; }
	if (fread(pBuf, 1, (size_t)lSize, f) != (size_t)lSize) { free(pBuf); fclose(f); return 0; }
	fclose(f);
	pBuf[lSize] = 0;
	*plSize = lSize;
	return pBuf;
}

static unsigned long U32(const char* p)
{
	const unsigned char* u = (const unsigned char*)p;
	return u[0] | (u[1] << 8) | (u[2] << 16) | ((unsigned long)u[3] << 24);
}

// Groesse des Verzeichnisses gebundener Importe, -1 wenn keine PE-Datei.
static long GebundeneImporte(const char* pBuf, long lSize)
{
	unsigned long nPe;
	unsigned long nEintrag;
	if (lSize < 0x40 || pBuf[0] != 'M' || pBuf[1] != 'Z') return -1;
	nPe = U32(pBuf + 0x3C);
	// PE-Kennung (4) + Dateikopf (20) + optionaler Kopf bis zum
	// Datenverzeichnis (96, PE32) + Eintrag 11 * 8, davon das Groessenfeld
	nEintrag = nPe + 4 + 20 + 96 + 11 * 8 + 4;
	if ((long)(nEintrag + 4) > lSize) return -1;
	if (memcmp(pBuf + nPe, "PE\0\0", 4) != 0) return -1;
	return (long)U32(pBuf + nEintrag);
}

void RunE130Tests(const char* szEudoraDir)
{
	char szPfad[1200];
	int  i;

	TT_Suite("E-130: Fremd-DLLs bleiben ungebunden");

	// ------------------------------------------------------------- (1)
	TT_BeginTest("E-130: keine der zwoelf Fremd-DLLs in Bin\\Release ist gebunden");
	for (i = 0; i < (int)(sizeof(s_aFremd) / sizeof(s_aFremd[0])); ++i)
	{
		long  lSize = 0;
		char* pBuf;
		long  lGebunden;
		char  szMsg[300];

		_snprintf(szPfad, sizeof(szPfad) - 1, "%s\\..\\Bin\\Release\\%s", szEudoraDir, s_aFremd[i]);
		szPfad[sizeof(szPfad) - 1] = 0;
		pBuf = Lies(szPfad, &lSize);
		_snprintf(szMsg, sizeof(szMsg) - 1, "%s nicht lesbar (%s)", s_aFremd[i], szPfad);
		szMsg[sizeof(szMsg) - 1] = 0;
		TT_CHECK_MSG(pBuf != 0, szMsg);
		if (!pBuf) continue;

		lGebunden = GebundeneImporte(pBuf, lSize);
		free(pBuf);
		_snprintf(szMsg, sizeof(szMsg) - 1,
			"%s traegt ein Verzeichnis gebundener Importe (%ld Byte) - bind hat sie veraendert; "
			"Original aus 567a5d87 zurueckholen und BindExe.bat pruefen", s_aFremd[i], lGebunden);
		szMsg[sizeof(szMsg) - 1] = 0;
		TT_CHECK_MSG(lGebunden == 0, szMsg);
		TT_Note("%s: gebundene Importe %ld Byte", s_aFremd[i], lGebunden);
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	TT_BeginTest("E-130: BindExe.bat bindet keine Fremd-DLL");
	{
		long  lSize = 0;
		char* pBuf;

		_snprintf(szPfad, sizeof(szPfad) - 1, "%s\\..\\BinTools\\BindExe.bat", szEudoraDir);
		szPfad[sizeof(szPfad) - 1] = 0;
		pBuf = Lies(szPfad, &lSize);
		TT_CHECK_MSG(pBuf != 0, "BinTools\\BindExe.bat nicht lesbar");
		if (pBuf)
		{
			// Nur die Befehlszeile zaehlt, nicht die Kommentare (rem ...),
			// die die Fremd-DLLs gerade deshalb aufzaehlen.
			char* pZeile = pBuf;
			while (pZeile && *pZeile)
			{
				char* pEnde = strchr(pZeile, '\n');
				if (pEnde) *pEnde = 0;
				_strlwr(pZeile);
				if (strstr(pZeile, "bind ") && strncmp(pZeile, "rem", 3) != 0)
				{
					for (i = 0; i < (int)(sizeof(s_aFremd) / sizeof(s_aFremd[0])); ++i)
					{
						char szName[64];
						char szMsg[200];
						strncpy(szName, s_aFremd[i], sizeof(szName) - 1);
						szName[sizeof(szName) - 1] = 0;
						_strlwr(szName);
						_snprintf(szMsg, sizeof(szMsg) - 1, "BindExe.bat bindet wieder %s", s_aFremd[i]);
						szMsg[sizeof(szMsg) - 1] = 0;
						TT_CHECK_MSG(strstr(pZeile, szName) == 0, szMsg);
					}
				}
				pZeile = pEnde ? pEnde + 1 : 0;
			}
			free(pBuf);
		}
	}
	TT_EndTest();
}
