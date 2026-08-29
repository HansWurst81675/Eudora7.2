//
// UnderTest.h - Zugriff auf den aus dem Produktivcode geschnittenen Code
//
// Der eigentliche Code liegt in UnderTest.cpp, das die von Extract.ps1 erzeugten
// .inc-Dateien einbindet. Die Testdateien sehen nur diese schmale Schnittstelle
// und enthalten selbst keinen Produktivcode.
//
#ifndef EUDORA_TESTS_UNDERTEST_H
#define EUDORA_TESTS_UNDERTEST_H

// --- aus utils.cpp -------------------------------------------------------

// Die Makrowerte, so wie der Uebersetzer sie in utils.cpp sieht.
int UT_XlateChars(void);			// XLATE_CHARS
int UT_MaxCharsToTrans(void);		// MAX_CHARS_TO_TRANS
int UT_MaxCharacterSets(void);		// MAX_CHARACTER_SETS

// Zeigt auf eine Zeile der Uebersetzungstabelle: MAX_CHARS_TO_TRANS+2 Bytes.
// iSet 0 = ISO-8859-15, iSet 1 = UTF-8.
const unsigned char* UT_XlateRow(int iSet, int iRow);

// Ruft die Originalfunktion ISOTranslate auf.
long UT_ISOTranslate(char* pBuf, long lSize, unsigned int uCharsetIdx);

// --- aus hexbin.cpp ------------------------------------------------------

// Zeigt auf HexBinTable[256].
const unsigned char* UT_HexBinTable(void);

unsigned char UT_HexBinFail(void);		// FAIL
unsigned char UT_HexBinSkip(void);		// SKIP
unsigned char UT_HexBinDone(void);		// DONE
unsigned char UT_HexBinRunChar(void);	// RUNCHAR

// --- Ressourcenkennungen, gegen die MAX_CHARACTER_SETS gerechnet wird ----
int UT_IdsMimeUsAscii(void);
int UT_IdsMimeUtf8(void);

#endif
