//
// UnderTest2047.cpp - bindet den Kopfzeilenpfad des POP-Empfangs ein
//
// Eigene Uebersetzungseinheit, weil Base64.cpp und hexbin.cpp beide Dateikonstanten
// namens FAIL und SKIP anlegen. In UnderTest.cpp steht die hexbin-Tabelle, hier die
// Base64-Tabelle; getrennt uebersetzt stoeren sie einander nicht.
//
// Wie in UnderTest.cpp steht hier kein abgeschriebener Produktivcode. Die .inc-Dateien
// schneidet Extract.ps1 bei jedem Build frisch aus
//   Eudora71/Eudora/Decode.h, Base64.h, Base64.cpp, mime.cpp und lex822.cpp.
//
#include <afx.h>
#include <afxwin.h>
#include <string.h>
#include <stdlib.h>

#include "UnderTest2047.h"

// Aus Eudora71/Eudora/resource.h. FindMIMECharset rechnet gegen diese Kennungen.
// TestXlateTable prueft zur Laufzeit, dass sie noch mit resource.h uebereinstimmen.
#define IDS_MIME_US_ASCII		3611
#define IDS_MIME_ISO_LATIN1		3612
#define IDS_MIME_ISO_LATIN9		3613
#define IDS_MIME_UTF_8			3614

// ISOTranslate wird von Translate2047 gerufen. Definiert ist es in UnderTest.cpp,
// das utils_isotranslate.inc einbindet; hier reicht die Deklaration aus utils.h.
LONG ISOTranslate(LPTSTR szBuf, LONG lSize, UINT iCharsetIdx);

//
// Ersatz fuer FindRStringIndexI() aus rs.cpp.
//
// Das Original laedt die Zeichenketten StartNum..EndNum aus der Ressourcentabelle
// und liefert den NULLBASIERTEN Abstand des ersten Treffers, sonst -1. Der Vergleich
// laeuft bei len < 0 ueber stricmp, also auf Gleichheit ohne Beachtung der
// Gross-/Kleinschreibung.
//
// Der Ressourcenteil ist hier nachgebildet, weil eine Ressourcen-DLL im Test nicht
// zur Verfuegung steht. Die Zeichenketten stammen woertlich aus
// Eudora71/Eudora/EudoraRes.rc, Zeilen 9385 bis 9388:
//
//     IDS_MIME_US_ASCII       "us-ascii"
//     IDS_MIME_ISO_LATIN1     "iso-8859-1"
//     IDS_MIME_ISO_LATIN9     "iso-8859-15"
//     IDS_MIME_UTF_8          "utf-8"
//
// Geprueft wird also die Rechnung in FindMIMECharset, nicht das Laden der Ressourcen.
//
static const char* RessourcenText(UINT uId)
{
	switch (uId)
	{
	case IDS_MIME_US_ASCII:		return "us-ascii";
	case IDS_MIME_ISO_LATIN1:	return "iso-8859-1";
	case IDS_MIME_ISO_LATIN9:	return "iso-8859-15";
	case IDS_MIME_UTF_8:		return "utf-8";
	default:					return "";
	}
}

int FindRStringIndexI(UINT StartNum, UINT EndNum, const char* String, int len /*= -1*/)
{
	int i;

	if (!String)
		return -1;

	for (i = 0; StartNum <= EndNum; ++i, ++StartNum)
	{
		const char* szRes = RessourcenText(StartNum);

		if (len < 0)
		{
			if (!_stricmp(szRes, String))
				return i;
		}
		else if (len > 0)
		{
			if (!_strnicmp(szRes, String, (size_t)len))
				return i;
		}
		else
		{
			if (!_strnicmp(szRes, String, strlen(szRes)))
				return i;
		}
	}

	return -1;
}

// ------------------------------------------------------------------ Decode.h
#include "generated/decode_klasse.inc"

// ------------------------------------------------------------------ Base64.h
#include "generated/base64_klasse.inc"

// ---------------------------------------------------------------- Base64.cpp
#include "generated/base64_table.inc"
#include "generated/base64_decoder.inc"

// ------------------------------------------------------------------ mime.cpp
#include "generated/mime_findcharset.inc"
#include "generated/mime_hextostring.inc"

// ---------------------------------------------------------------- lex822.cpp
#include "generated/lex822_2047.inc"

// --------------------------------------------------------------- Schnittstelle
#line 106 "UnderTest2047.cpp"

int UT_FindMIMECharset(const char* szCharset)
{
	return FindMIMECharset(szCharset);
}

int UT_FindRStringIndexI(unsigned int uStart, unsigned int uEnd, const char* szText)
{
	return FindRStringIndexI(uStart, uEnd, szText, -1);
}

int UT_Translate2047(char* pText, const char* szCharset, char chEncoding)
{
	return Translate2047(pText, szCharset, chEncoding) ? 1 : 0;
}

int UT_Fix2047(char* pChars, int* piLen)
{
	return Fix2047(pChars, *piLen) ? 1 : 0;
}

void UT_PseudoQP(char* pText)
{
	PseudoQP(pText);
}

int UT_DecodeB64String(char* pText)
{
	return DecodeB64String(pText);
}

int UT_IdsMimeIsoLatin1(void)	{ return IDS_MIME_ISO_LATIN1; }
int UT_IdsMimeIsoLatin9(void)	{ return IDS_MIME_ISO_LATIN9; }
