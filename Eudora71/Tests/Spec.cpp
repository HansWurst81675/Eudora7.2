//
// Spec.cpp - Referenzdaten aus den Normen
//
#include <string.h>
#include "Spec.h"

// CP1252, Bereich 0x80..0x9F. Alles ab 0xA0 stimmt mit Latin-1 ueberein,
// die Positionen mit -1 sind in CP1252 nicht belegt.
// Quelle: Unicode-Consortium, MAPPINGS/VENDORS/MICSFT/WINDOWS/CP1252.TXT
static const long s_alCp1252Upper[32] =
{
	/* 80 */ 0x20AC,	/* 81 */ -1,		/* 82 */ 0x201A,	/* 83 */ 0x0192,
	/* 84 */ 0x201E,	/* 85 */ 0x2026,	/* 86 */ 0x2020,	/* 87 */ 0x2021,
	/* 88 */ 0x02C6,	/* 89 */ 0x2030,	/* 8A */ 0x0160,	/* 8B */ 0x2039,
	/* 8C */ 0x0152,	/* 8D */ -1,		/* 8E */ 0x017D,	/* 8F */ -1,
	/* 90 */ -1,		/* 91 */ 0x2018,	/* 92 */ 0x2019,	/* 93 */ 0x201C,
	/* 94 */ 0x201D,	/* 95 */ 0x2022,	/* 96 */ 0x2013,	/* 97 */ 0x2014,
	/* 98 */ 0x02DC,	/* 99 */ 0x2122,	/* 9A */ 0x0161,	/* 9B */ 0x203A,
	/* 9C */ 0x0153,	/* 9D */ -1,		/* 9E */ 0x017E,	/* 9F */ 0x0178
};

long SpecCp1252ToUnicode(unsigned char byValue)
{
	if (byValue < 0x80)
	{
		// ASCII, deckungsgleich.
		return (long)byValue;
	}
	if (byValue < 0xA0)
	{
		return s_alCp1252Upper[byValue - 0x80];
	}
	// 0xA0..0xFF ist in CP1252 identisch mit Latin-1.
	return (long)byValue;
}

long SpecLatin9ToUnicode(unsigned char byValue)
{
	// ISO-8859-15 weicht von ISO-8859-1 an genau acht Positionen ab.
	switch (byValue)
	{
	case 0xA4:	return 0x20AC;	// EURO SIGN
	case 0xA6:	return 0x0160;	// LATIN CAPITAL LETTER S WITH CARON
	case 0xA8:	return 0x0161;	// LATIN SMALL LETTER S WITH CARON
	case 0xB4:	return 0x017D;	// LATIN CAPITAL LETTER Z WITH CARON
	case 0xB8:	return 0x017E;	// LATIN SMALL LETTER Z WITH CARON
	case 0xBC:	return 0x0152;	// LATIN CAPITAL LIGATURE OE
	case 0xBD:	return 0x0153;	// LATIN SMALL LIGATURE OE
	case 0xBE:	return 0x0178;	// LATIN CAPITAL LETTER Y WITH DIAERESIS
	default:	break;
	}
	return (long)byValue;
}

int SpecUtf8Encode(long lCodepoint, unsigned char* pOut)
{
	int iLen = 0;

	if (lCodepoint < 0 || lCodepoint > 0x10FFFF)			return 0;
	if (lCodepoint >= 0xD800 && lCodepoint <= 0xDFFF)		return 0;

	if (lCodepoint < 0x80)
	{
		pOut[0] = (unsigned char)lCodepoint;
		iLen = 1;
	}
	else if (lCodepoint < 0x800)
	{
		pOut[0] = (unsigned char)(0xC0 | (lCodepoint >> 6));
		pOut[1] = (unsigned char)(0x80 | (lCodepoint & 0x3F));
		iLen = 2;
	}
	else if (lCodepoint < 0x10000)
	{
		pOut[0] = (unsigned char)(0xE0 | (lCodepoint >> 12));
		pOut[1] = (unsigned char)(0x80 | ((lCodepoint >> 6) & 0x3F));
		pOut[2] = (unsigned char)(0x80 | (lCodepoint & 0x3F));
		iLen = 3;
	}
	else
	{
		pOut[0] = (unsigned char)(0xF0 | (lCodepoint >> 18));
		pOut[1] = (unsigned char)(0x80 | ((lCodepoint >> 12) & 0x3F));
		pOut[2] = (unsigned char)(0x80 | ((lCodepoint >> 6) & 0x3F));
		pOut[3] = (unsigned char)(0x80 | (lCodepoint & 0x3F));
		iLen = 4;
	}

	pOut[iLen] = 0;
	return iLen;
}

long SpecUtf8Decode(const unsigned char* pIn, int* piLen)
{
	unsigned char by0 = pIn[0];
	long lCp = -1;
	int iNeed = 0;
	int i;

	*piLen = 0;

	if (by0 < 0x80)					{ iNeed = 0; lCp = by0; }
	else if ((by0 & 0xE0) == 0xC0)	{ iNeed = 1; lCp = by0 & 0x1F; }
	else if ((by0 & 0xF0) == 0xE0)	{ iNeed = 2; lCp = by0 & 0x0F; }
	else if ((by0 & 0xF8) == 0xF0)	{ iNeed = 3; lCp = by0 & 0x07; }
	else							{ return -1; }	// Folgebyte oder unerlaubtes Praefix

	for (i = 1; i <= iNeed; ++i)
	{
		if ((pIn[i] & 0xC0) != 0x80)	return -1;
		lCp = (lCp << 6) | (pIn[i] & 0x3F);
	}

	// Ueberlange Kodierungen sind nach RFC 3629 verboten.
	if (iNeed == 1 && lCp < 0x80)		return -1;
	if (iNeed == 2 && lCp < 0x800)		return -1;
	if (iNeed == 3 && lCp < 0x10000)	return -1;
	if (lCp >= 0xD800 && lCp <= 0xDFFF)	return -1;
	if (lCp > 0x10FFFF)					return -1;

	*piLen = iNeed + 1;
	return lCp;
}

const char* SpecBinHexAlphabet(void)
{
	// 64 Zeichen, Index == 6-Bit-Wert. Aus der BinHex-4.0-Beschreibung.
	static const char szAlphabet[] =
		"!\"#$%&'()*+,-"		// 13
		"012345689"				//  9  -> 22   (die 7 fehlt absichtlich)
		"@ABCDEFGHIJKLMN"		// 15  -> 37   (kein O)
		"PQRSTUV"				//  7  -> 44   (kein W)
		"XYZ["					//  4  -> 48
		"`abcdefhijklmpqr";		// 16  -> 64   (kein g, kein n/o)
	return szAlphabet;
}
