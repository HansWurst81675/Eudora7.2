//
// TestE221.cpp - Befund E-221: der Betreff verlor in der Postfachliste seine
// ersten sieben Zeichen, wenn die Kopfzeile direkt hinter "Subject:"
// gefaltet war.
//
// Zwei Haelften, beide mit der ECHTEN Funktion (Extract.ps1 schneidet sie bei
// jedem Bau, UnderTestE221.cpp):
//
//   SENDEN - Encode2047 (sendmail.cpp). Die Pruefung, ob ein Wort noch auf
//   die Zeile passt, rechnet mit ">", die Pruefung, ob umbrochen wird, rechnete
//   mit ">=". Ein Stueck, das die Zeile GENAU fuellte, wurde erst angenommen
//   und dann umbrochen - beim ersten Stueck direkt hinter "Subject: ". Am
//   herausgezogenen Original gemessen: 201 von 1025 Betreffs mit Umlauten.
//
//   EMPFANGEN - CSummary::Build (summary.cpp) liest bei leerer erster Zeile
//   die Folgezeile, schnitt aber auch dort die 8 Zeichen von "Subject:" ab.
//   Jetzt E221BetreffAnfang; der Quelltextteil prueft, dass Build sie ruft.
//
// Die Betreffs sind erfunden.
//
#include <afx.h>
#include <stdlib.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

CString UTE221_Encode2047(const char* szText, int nLineLimit, int nCharsOnLine);
char* UTE221_BetreffAnfang(char* szZeile, BOOL bFortsetzung);

static CString Sichtbar(const CString& sz)
{
	CString szAus;
	for (int i = 0; i < sz.GetLength(); i++)
	{
		const unsigned char c = (unsigned char) sz[i];
		if (c == '\r')
			szAus += "\\r";
		else if (c == '\n')
			szAus += "\\n";
		else if (c < 0x20 || c >= 0x7F)
		{
			CString szHex;
			szHex.Format("\\x%02X", c);
			szAus += szHex;
		}
		else
			szAus += (char) c;
	}
	return szAus;
}

// Wie SendNormalHeader: "Subject:" (8) + 1, dann das Leerzeichen hinter dem
// Doppelpunkt (+1), Grenze SMTPRecipientWrap = 72 (EudoraRes.rc).
static void Senden(const char* szBetreff, const char* szSoll, const char* szWas)
{
	const CString szIst = UTE221_Encode2047(szBetreff, 72, 10);
	if (szIst.Left(2) == "\r\n")
		TT_Fail("%s: Encode2047 faltet direkt hinter \"Subject: \" - [%s] (E-221)", szWas, (LPCTSTR) Sichtbar(szIst));
	if (szSoll && szIst != szSoll)
		TT_Fail("%s: Encode2047 lieferte [%s], erwartet [%s] (E-221)", szWas, (LPCTSTR) Sichtbar(szIst), (LPCTSTR) Sichtbar(CString(szSoll)));
}

static void Test_E221_Senden()
{
	TT_BeginTest("E-221 (Funktion): Encode2047 faltet einen Betreff mit Umlauten nicht direkt hinter dem Doppelpunkt");

	// Das erste kodierte Stueck fuellt die Zeile genau (10 + 62 = 72). Vorher:
	// "\r\n =?...test_mit...?=\r\n =?..._=E4u=DFern?=" - erste Zeile leer.
	Senden("test mit kopfzeile - \xF6" "fter \xFC" "ber gr\xF6\xDF" "e \xE4u\xDF" "ern",
		   "=?iso-8859-1?Q?test_mit_kopfzeile_-_=F6fter_=FCber_gr=F6=DFe?=\r\n =?iso-8859-1?Q?_=E4u=DFern?=",
		   "Zeile genau voll");

	// Ein Stueck, das NICHT genau fuellt - war schon immer richtig, muss es bleiben.
	Senden("probe mit kopfzeile - \xF6" "fter \xFC" "ber gr\xF6\xDF" "e \xE4u\xDF" "ern",
		   "=?iso-8859-1?Q?probe_mit_kopfzeile_-_=F6fter_=FCber_?=\r\n =?iso-8859-1?Q?gr=F6=DFe?= =?iso-8859-1?Q?_=E4u=DFern?=",
		   "Zeile nicht voll");

	// Kurz: eine Zeile, kein Umbruch (Positivprobe, wie Gregors "Re: test mit Umlauten").
	Senden("Re: kurz mit Umlauten \xE4\xF6\xFC", "=?iso-8859-1?Q?Re:_kurz_mit_Umlauten_=E4=F6=FC?=", "kurz");

	// Lang: muss weiter umbrechen - die Behebung darf das Falten nicht abstellen.
	{
		const CString szIst = UTE221_Encode2047("eine sehr lange probe mit kopfzeile - \xF6" "fter \xFC" "ber gr\xF6\xDF" "e \xE4u\xDF"
												"ern und noch viel mehr text dahinter f\xFC" "r zwei zeilen", 72, 10);
		int nZeilen = 1, nLaengste = 0, nAnfang = 0;
		for (int i = 0; i <= szIst.GetLength(); i++)
		{
			if (i == szIst.GetLength() || szIst[i] == '\r')
			{
				const int nLaenge = (i - nAnfang) + (nZeilen == 1 ? 9 : 0);	// erste Zeile mit "Subject: "
				if (nLaenge > nLaengste)
					nLaengste = nLaenge;
				if (i < szIst.GetLength())
				{
					nZeilen++;
					nAnfang = i + 2;
				}
			}
		}
		TT_CHECK_MSG(szIst.Left(2) != "\r\n", "langer Betreff: erste Zeile leer (E-221)");
		TT_CHECK_MSG(nZeilen >= 3, "langer Betreff wird nicht mehr umbrochen (E-221)");
		TT_CHECK_MSG(nLaengste <= 78, "langer Betreff: eine Zeile ist laenger als 78 Zeichen (RFC 5322 2.1.1)");
		TT_Note("langer Betreff: %d Zeilen, laengste %d Zeichen", nZeilen, nLaengste);
	}

	TT_EndTest();
}

static void Empfangen(const char* szZeile, BOOL bFortsetzung, const char* szSoll, const char* szWas)
{
	char szPuffer[256];
	memset(szPuffer, 0, sizeof(szPuffer));
	strcpy(szPuffer, szZeile);
	const char* pIst = UTE221_BetreffAnfang(szPuffer, bFortsetzung);
	if (strcmp(pIst, szSoll) != 0)
		TT_Fail("%s: Betreff beginnt bei [%s], erwartet [%s] (E-221)", szWas, pIst, szSoll);
}

static void Test_E221_Empfangen()
{
	TT_BeginTest("E-221 (Funktion): E221BetreffAnfang - Betreff einer Folgezeile beginnt am Zeilenanfang");
	// Die erste Zeile: hinter "Subject:" (den Leerraum nimmt Build mit TrimWhitespaceMT).
	Empfangen("Subject: Re: kurz", FALSE, " Re: kurz", "erste Zeile");
	Empfangen("Subject:", FALSE, "", "erste Zeile leer");
	// Die Folgezeile: vorher "t mit kopfzeile" - Leerzeichen plus 7 Zeichen fehlten.
	Empfangen(" test mit kopfzeile", TRUE, " test mit kopfzeile", "Folgezeile mit Leerzeichen");
	Empfangen("\tprobe einer zeile", TRUE, "\tprobe einer zeile", "Folgezeile mit Tabulator");
	Empfangen(" kurz", TRUE, " kurz", "Folgezeile kuerzer als 8 Zeichen (vorher hinter dem Ende gelesen)");
	TT_EndTest();
}

// Extrakt ist nicht das Programm: ruft Build die gepruefte Funktion, und
// rechnet Encode2047 noch mit der alten Grenze?
static void Test_E221_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-221 (Quelltext): CSummary::Build nimmt E221BetreffAnfang, Encode2047 bricht erst bei '>' um");
	char* pSum = QT_LiesNurCode(szEudoraDir, "summary.cpp");
	if (!pSum)
		TT_Fail("summary.cpp nicht lesbar - ungeprueft ist nicht gruen");
	else
	{
		char* pFn = QT_Abschnitt(pSum, "int CSummary::Build(", "int CSummary::Read(");
		if (!pFn)
			TT_Fail("CSummary::Build nicht gefunden - ungeprueft ist nicht gruen (E-221)");
		else
		{
			const int nAufruf = QT_Zaehle(pFn, "E221BetreffAnfang(sBuffer, bInSubject)");
			const int nAlt = QT_Zaehle(pFn, "SetSubject(sBuffer + 8)");
			TT_CHECK_MSG(nAufruf == 1, "CSummary::Build ruft E221BetreffAnfang(sBuffer, bInSubject) nicht (genau einmal) auf (E-221)");
			TT_CHECK_MSG(nAlt == 0, "CSummary::Build setzt den Betreff wieder fest ab sBuffer + 8 - Folgezeilen verlieren 7 Zeichen (E-221)");
			TT_Note("Build: E221BetreffAnfang %d-mal (soll 1), 'SetSubject(sBuffer + 8)' %d-mal (soll 0)", nAufruf, nAlt);
			free(pFn);
		}
		free(pSum);
	}
	char* pSend = QT_LiesNurCode(szEudoraDir, "sendmail.cpp");
	if (!pSend)
		TT_Fail("sendmail.cpp nicht lesbar - ungeprueft ist nicht gruen");
	else
	{
		char* pFn = QT_Abschnitt(pSend, "CString Encode2047(", "int SendAddressHeader(");
		if (!pFn)
			TT_Fail("Encode2047 nicht gefunden - ungeprueft ist nicht gruen (E-221)");
		else
		{
			const int nAlt = QT_Zaehle(pFn, ">= lineLimit");
			TT_CHECK_MSG(nAlt == 0, "Encode2047 bricht wieder bei '>= lineLimit' um - Faltung direkt hinter 'Subject: ' (E-221)");
			free(pFn);
		}
		free(pSend);
	}
	TT_EndTest();
}

void RunE221Tests(const char* szEudoraDir)
{
	Test_E221_Senden();
	Test_E221_Empfangen();
	Test_E221_Stelle(szEudoraDir);
}
