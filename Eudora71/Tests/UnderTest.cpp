//
// UnderTest.cpp - bindet den unveraenderten Produktivcode ein
//
// Die .inc-Dateien werden bei jedem Build von Extract.ps1 frisch aus
// Eudora71/Eudora/utils.cpp und Eudora71/Eudora/hexbin.cpp geschnitten.
// Hier steht deshalb bewusst kein abgeschriebener Code, nur die Umgebung,
// die der geschnittene Code zum Uebersetzen braucht.
//
#include <afx.h>
#include <afxwin.h>
#include <string.h>

#include "UnderTest.h"

// Aus Eudora71/Eudora/resource.h. utils.cpp berechnet MAX_CHARACTER_SETS aus
// diesen beiden Werten. TestXlateTable prueft zur Laufzeit, dass sie noch mit
// resource.h uebereinstimmen - sonst waere die Tabellenform hier eine andere
// als im Produktivcode.
#define IDS_MIME_US_ASCII		3611
#define IDS_MIME_ISO_LATIN1		3612
#define IDS_MIME_ISO_LATIN9		3613
#define IDS_MIME_UTF_8			3614

// ------------------------------------------------------------------ utils.cpp
#include "generated/utils_table.inc"
#include "generated/utils_isotranslate.inc"

// ----------------------------------------------------------------- hexbin.cpp
#include "generated/hexbin_table.inc"

// --------------------------------------------------------------- Schnittstelle
#line 40 "UnderTest.cpp"

int UT_XlateChars(void)			{ return XLATE_CHARS; }
int UT_MaxCharsToTrans(void)	{ return MAX_CHARS_TO_TRANS; }
int UT_MaxCharacterSets(void)	{ return MAX_CHARACTER_SETS; }

const unsigned char* UT_XlateRow(int iSet, int iRow)
{
	if (iSet < 0 || iSet >= MAX_CHARACTER_SETS)	return 0;
	if (iRow < 0 || iRow >= XLATE_CHARS)		return 0;
	return pcXlateTable[iSet][iRow];
}

long UT_ISOTranslate(char* pBuf, long lSize, unsigned int uCharsetIdx)
{
	return ISOTranslate(pBuf, lSize, uCharsetIdx);
}

const unsigned char* UT_HexBinTable(void)	{ return HexBinTable; }

unsigned char UT_HexBinFail(void)		{ return FAIL; }
unsigned char UT_HexBinSkip(void)		{ return SKIP; }
unsigned char UT_HexBinDone(void)		{ return DONE; }
unsigned char UT_HexBinRunChar(void)	{ return RUNCHAR; }

int UT_IdsMimeUsAscii(void)	{ return IDS_MIME_US_ASCII; }
int UT_IdsMimeUtf8(void)	{ return IDS_MIME_UTF_8; }
