//
// TestE179.cpp - Befund E-179: die HTML-zu-Text-Umwandlung behielt von einer
// numerischen Zeichenangabe nur das unterste Byte.
//
// Geprueft wird die ECHTE E179ZeichenAusNummer aus html2text.cpp (von
// Extract.ps1 bei jedem Bau geschnitten, UnderTestE179.cpp). Vorher stand die
// Umwandlung inline in CHtml2Text::AddText als
//
//     m_szDest += ( char ) ( atoi( szTemp ) & 0xFF );
//
// Aus &#128293; (Emoji) wurde '%', aus &#1046; (Zhe) das Steuerzeichen 0x16,
// aus &#x1F525; ein Nullbyte (atoi("") = 0). Jetzt: was die Codepage kennt,
// wird zum Zeichen (&#8364; -> Euro 0x80); was nicht, bleibt als Angabe stehen,
// wie sie war - nichts geht verloren, nichts wird verfaelscht.
//
// Die Erwartungen gelten fuer die Codepage windows-1252 (wie der Rest der
// E-136-Tests).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

CString UTE179_ZeichenAusNummer(const char* szText, unsigned long ulTotalLength, unsigned long& ulVerbraucht);

static CString Sichtbar(const CString& sz)
{
	CString szAus;
	for (int i = 0; i < sz.GetLength(); i++)
	{
		const unsigned char c = (unsigned char) sz[i];
		if (c < 0x20 || c >= 0x7F)
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

static void Fall(const char* szEingabe, const char* szSoll, int nSollLaenge, unsigned long ulSollVerbraucht, const char* szWas)
{
	unsigned long ulVerbraucht = 0;
	const CString szIst = UTE179_ZeichenAusNummer(szEingabe, (unsigned long) strlen(szEingabe), ulVerbraucht);
	const CString szSollStr(szSoll, nSollLaenge);
	if (szIst != szSollStr)
		TT_Fail("%s: aus [%s] wurde [%s], erwartet [%s] (E-179)", szWas, szEingabe, (LPCTSTR) Sichtbar(szIst), (LPCTSTR) Sichtbar(szSollStr));
	if (ulVerbraucht != ulSollVerbraucht)
		TT_Fail("%s: %lu Zeichen verbraucht, erwartet %lu (E-179)", szWas, ulVerbraucht, ulSollVerbraucht);
}

static void Test_E179_Funktion()
{
	TT_BeginTest("E-179 (Funktion): numerische Zeichenangaben beim Umwandeln von HTML in Text");

	// Was schon immer ging, muss weiter gehen.
	Fall("&#65;",        "A",            1, 4, "ASCII");
	Fall("&#252;",       "\xFC",         1, 5, "Latin-1 (ue)");
	Fall("&#xFC;",       "\xFC",         1, 5, "hexadezimal, Latin-1");

	// Ueber 255, aber in windows-1252 vorhanden: zum Zeichen.
	Fall("&#8364;",      "\x80",         1, 6, "Euro (in windows-1252 0x80)");
	Fall("&#8211;",      "\x96",         1, 6, "Gedankenstrich (in windows-1252 0x96)");

	// Nicht darstellbar: die Angabe bleibt stehen, samt Semikolon.
	Fall("&#128293;",    "&#128293;",    9, 8, "Emoji - vorher '%'");
	Fall("&#1046;",      "&#1046;",      7, 6, "Zhe - vorher Steuerzeichen 0x16");
	Fall("&#x1F525;",    "&#x1F525;",    9, 8, "Emoji hexadezimal - vorher Nullbyte");
	Fall("&#128293 x",   "&#128293",     8, 8, "ohne Semikolon");

	// Keine gueltige Zahl: stehen lassen, nie ein Nullbyte.
	Fall("&#;",          "&#;",          3, 2, "ohne Ziffern");
	Fall("&#0;",         "&#0;",         4, 3, "Null");
	Fall("&#xD83D;",     "&#xD83D;",     8, 7, "halbes Ersatzpaar");
	Fall("&#99999999999;", "&#99999999999;", 14, 13, "zu gross");

	TT_EndTest();
}

// Extrakt ist nicht das Programm: ruft AddText die gepruefte Funktion
// wirklich auf, und steht dort keine Abschneide-Umwandlung mehr?
static void Test_E179_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-179 (Quelltext): CHtml2Text::AddText wandelt Zeichenangaben ueber E179ZeichenAusNummer");
	char* pText = QT_LiesNurCode(szEudoraDir, "html2text.cpp");
	if (!pText)
	{
		TT_Fail("html2text.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pFn = QT_Abschnitt(pText, "void CHtml2Text::AddText(", "void CHtml2Text::SetExcerptLevel(");
	if (!pFn)
		TT_Fail("CHtml2Text::AddText nicht gefunden - ungeprueft ist nicht gruen (E-179)");
	else
	{
		const int nAufruf = QT_Zaehle(pFn, "E179ZeichenAusNummer(");
		const int nAbschneiden = QT_Zaehle(pFn, "& 0xFF") + QT_Zaehle(pFn, "&0xFF");
		TT_CHECK_MSG(nAufruf == 1, "AddText ruft E179ZeichenAusNummer nicht (genau einmal) auf - der Test der Funktion prueft dann nicht das Programm (E-179)");
		TT_CHECK_MSG(nAbschneiden == 0, "AddText schneidet wieder auf das unterste Byte ab ('& 0xFF') - Emoji werden zu '%' (E-179)");
		TT_Note("AddText: E179ZeichenAusNummer %d-mal (soll 1), '& 0xFF' %d-mal (soll 0)", nAufruf, nAbschneiden);
		free(pFn);
	}
	free(pText);
	TT_EndTest();
}

void RunE179Tests(const char* szEudoraDir)
{
	Test_E179_Funktion();
	Test_E179_Stelle(szEudoraDir);
}
