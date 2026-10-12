//
// UnderTestImap2047.cpp - bindet den Kopfzeilenpfad des IMAP-Empfangs ein
//
// Gegenstueck zu UnderTest2047.cpp fuer EuImap/src/ImapLex822.cpp (Befund E-94).
// Eigene Uebersetzungseinheit, weil Translate2047, PseudoQP und DecodeB64String
// dort static sind und genauso heissen wie im POP-Weg.
//
// Wie dort steht hier kein abgeschriebener Produktivcode. imaplex822_2047.inc
// schneidet Extract.ps1 bei jedem Build frisch aus ImapLex822.cpp.
//
#include <afx.h>
#include <afxwin.h>
#include <string.h>
#include <stdlib.h>

#include "UnderTest2047.h"

// Die Helfer, die die IMAP-Kette ruft, sind in UnderTest2047.cpp bzw.
// UnderTest.cpp aus dem POP-Weg eingebunden und nicht static - hier reichen die
// Deklarationen.
int  FindMIMECharset(const char* charSet);					// mime.cpp
void HexToString(char* dest, const char* src, int Num);		// mime.cpp
LONG ISOTranslate(LPTSTR szBuf, LONG lSize, UINT iCharsetIdx);	// utils.cpp

// ------------------------------------------------------------------ Decode.h
#include "generated/decode_klasse.inc"

// ------------------------------------------------------------------ Base64.h
#include "generated/base64_klasse.inc"

// Vorab-Deklarationen wie am Anfang von ImapLex822.cpp.
static BOOL Translate2047(char* text, const char* charset, char encoding);
static void PseudoQP(char* text);
static int DecodeB64String(char* s);

// ------------------------------------------------- EuImap/src/ImapLex822.cpp
#include "generated/imaplex822_2047.inc"

// --------------------------------------------------------------- Schnittstelle
#line 42 "UnderTestImap2047.cpp"

int UT_ImapFix2047(char* pChars, int* piLen)
{
	return ImapFix2047(pChars, *piLen) ? 1 : 0;
}
