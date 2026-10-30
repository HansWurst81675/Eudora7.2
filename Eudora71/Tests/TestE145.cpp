//
// TestE145.cpp - Regressionstest zu Befund E-145
//
// Base64Decoder::Decode indizierte g_Decode[*In] mit einem vorzeichenbehafteten
// char. Ein Byte ueber 127 (etwa 0xE4) ergab einen negativen Index und las bis
// zu 128 Byte vor der Tabelle; heraus kamen falsch dekodierte Bytes statt
// eines uebersprungenen ungueltigen Zeichens. Gefunden von PRUEFER-49 K11.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "UnderTest2047.h"

void RunE145Tests(void)
{
	TT_BeginTest("E-145: ein Byte ueber 127 im Base64-Text zaehlt als ungueltig und veraendert die Ausgabe nicht");
	char aAus[16];
	long lAus = 0;

	// Positivprobe: ohne Hochbyte kommt "A" heraus.
	memset(aAus, 0, sizeof(aAus));
	int iOhne = UT_Base64Dekodiere("QQ==", 4, aAus, lAus);
	TT_CHECK_MSG(iOhne == 0 && lAus == 1 && aAus[0] == 'A', "Positivprobe: \"QQ==\" ergibt nicht \"A\" - der Pruefling dekodiert gar nicht");

	// Der Fall aus dem Befund: "QQ\xE4==" - das Hochbyte ist ungueltig.
	memset(aAus, 0, sizeof(aAus));
	lAus = 0;
	int iMit = UT_Base64Dekodiere("QQ\xE4==", 5, aAus, lAus);
	TT_CHECK_MSG(iMit == 1, "das Byte 0xE4 zaehlt nicht als ungueltiges Zeichen (E-145)");
	TT_CHECK_MSG(lAus == 1 && aAus[0] == 'A', "mit dem Byte 0xE4 kommt nicht genau \"A\" heraus - es wurde mitdekodiert (E-145)");

	// Jedes Hochbyte 0x80..0xFF einzeln, mitten in einer gueltigen Gruppe.
	int iFalsch = 0;
	for (int b = 0x80; b <= 0xFF; b++)
	{
		char aEin[6] = { 'Q', 'Q', (char)b, '=', '=', 0 };
		memset(aAus, 0, sizeof(aAus));
		lAus = 0;
		int iU = UT_Base64Dekodiere(aEin, 5, aAus, lAus);
		if (iU != 1 || lAus != 1 || aAus[0] != 'A')
			iFalsch++;
	}
	if (iFalsch != 0)
		TT_Fail("%d von 128 Hochbytes werden nicht als ungueltig uebersprungen (E-145)", iFalsch);
	TT_EndTest();
}
