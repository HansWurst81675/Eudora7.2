//
// Spec.h - Referenzdaten aus den Normen, unabhaengig vom Eudora-Code
//
// Alles hier ist aus der Spezifikation abgeleitet, NICHT aus dem getesteten Code:
//  - CP1252 nach Unicode: Unicode-Consortium-Zuordnungstabelle CP1252.TXT
//  - Latin-1 (ISO-8859-1) U+00A0..U+00FF: Codepunkt == Bytewert
//  - ISO-8859-15 (Latin-9): die acht Positionen, in denen es von Latin-1 abweicht
//  - UTF-8: RFC 3629
//  - BinHex 4.0: das 64-Zeichen-Alphabet aus RFC 1741 / Apple BinHex 4.0
//
#ifndef EUDORA_TESTS_SPEC_H
#define EUDORA_TESTS_SPEC_H

// Liefert den Unicode-Codepunkt zu einem CP1252-Byte, oder -1, wenn die
// Position in CP1252 nicht belegt ist (0x81, 0x8D, 0x8F, 0x90, 0x9D).
long SpecCp1252ToUnicode(unsigned char byValue);

// Liefert den Unicode-Codepunkt zu einem ISO-8859-15-Byte (>= 0xA0).
long SpecLatin9ToUnicode(unsigned char byValue);

// UTF-8 nach RFC 3629. pOut muss mindestens 5 Bytes fassen, wird
// nullterminiert. Rueckgabe: Anzahl der Bytes, 0 bei ungueltigem Codepunkt.
int SpecUtf8Encode(long lCodepoint, unsigned char* pOut);

// UTF-8 nach RFC 3629 dekodieren. *piLen erhaelt die verbrauchte Bytezahl.
// Rueckgabe: Codepunkt, oder -1 bei ungueltiger Folge (auch bei ueberlanger
// Kodierung oder Ersatzzeichenbereich D800..DFFF).
long SpecUtf8Decode(const unsigned char* pIn, int* piLen);

// Das BinHex-4.0-Alphabet, 64 Zeichen, Index == 6-Bit-Wert.
const char* SpecBinHexAlphabet(void);

#endif
