//
// UnderTest2047.h - Zugriff auf den Kopfzeilenpfad des POP-Empfangs
//
// Der eigentliche Code liegt in UnderTest2047.cpp, das die von Extract.ps1 erzeugten
// .inc-Dateien einbindet. Die Testdateien sehen nur diese schmale Schnittstelle.
//
#ifndef EUDORA_TESTS_UNDERTEST2047_H
#define EUDORA_TESTS_UNDERTEST2047_H

// --- aus mime.cpp --------------------------------------------------------

// Bildet einen MIME-Zeichensatznamen auf den Index ab, den ISOTranslate erwartet:
// 0 = windows-*, 1 = us-ascii, 2 = iso-8859-1, 3 = iso-8859-15, 4 = utf-8, -1 = unbekannt.
int UT_FindMIMECharset(const char* szCharset);

// Der nachgebildete Ressourcensucher, gegen den FindMIMECharset rechnet. Nur da,
// damit ein Test die Verschiebung um eins zwischen beiden zeigen kann.
int UT_FindRStringIndexI(unsigned int uStart, unsigned int uEnd, const char* szText);

// --- aus lex822.cpp ------------------------------------------------------

// Dekodiert den Inhalt EINES kodierten Worts nach RFC 2047 und uebersetzt ihn in
// den Windows-Zeichensatz. chEncoding ist 'B' oder 'Q'. Liefert 1 bei Erfolg.
int UT_Translate2047(char* pText, const char* szCharset, char chEncoding);

// Ersetzt in einer ganzen Kopfzeile alle kodierten Woerter "=?...?=" durch Klartext.
// piLen ist Ein- und Ausgabe. Liefert 1, wenn mindestens ein Wort ersetzt wurde.
int UT_Fix2047(char* pChars, int* piLen);

// Die beiden Dekodierer, die Translate2047 benutzt.
void UT_PseudoQP(char* pText);		// Q-Kodierung, an Ort und Stelle
int  UT_DecodeB64String(char* pText);	// B-Kodierung, an Ort und Stelle; 0 = fehlerfrei

// --- Ressourcenkennungen -------------------------------------------------
int UT_IdsMimeIsoLatin1(void);
int UT_IdsMimeIsoLatin9(void);

#endif
