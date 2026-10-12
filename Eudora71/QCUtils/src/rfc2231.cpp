// RFC2231.CPP
//
// Lange und nicht-englische Parameterwerte in MIME-Kopfzeilen.
// Befund AN-1, fuenfter Teil. Siehe rfc2231.h.

#include "stdafx.h"

#include <string.h>
#include <stdio.h>

#include "rfc2231.h"


//	Lange Dateinamen werden heute praktisch immer nach RFC 2231
//	uebertragen, und dieser Baum kannte das nicht. Ein Absender darf
//	einen Parameterwert
//
//	  * in Stuecke zerlegen:   filename*0="Angebot Nr 4711 "
//	                           filename*1="fuer die Stadtwerke.pdf"
//	  * und/oder kodieren:     filename*=UTF-8''Angebot%20Nr.pdf
//	                           filename*0*=UTF-8''Angebot%20
//	                           filename*1*=Nr%204711.pdf
//
//	Vorher fand GetAttribute("filename") keines davon - es gab also gar
//	keinen Dateinamen, und mime.cpp nahm ersatzweise den BETREFF aus
//	subj[32], also 31 Zeichen ohne Endung.
//
//	RFC2231Entschluesseln ist absichtlich frei von MFC und Win32, damit
//	tools/rfc2231-pruefen.pl es woertlich herausziehen und mit g++ messen
//	kann. Dasselbe Muster wie tools/kopfzeile-pruefen.pl.

//	Ein Hexziffernpaar. -1, wenn eines der beiden keine Hexziffer ist.
static int RFC2231Hex(const char* s)
{
	int	hoch, nieder;

	if (!s || !s[0] || !s[1])
		return (-1);

	hoch  = (s[0] >= '0' && s[0] <= '9')? s[0] - '0' :
			(s[0] >= 'a' && s[0] <= 'f')? s[0] - 'a' + 10 :
			(s[0] >= 'A' && s[0] <= 'F')? s[0] - 'A' + 10 : -1;
	nieder= (s[1] >= '0' && s[1] <= '9')? s[1] - '0' :
			(s[1] >= 'a' && s[1] <= 'f')? s[1] - 'a' + 10 :
			(s[1] >= 'A' && s[1] <= 'F')? s[1] - 'A' + 10 : -1;

	if (hoch < 0 || nieder < 0)
		return (-1);

	return (hoch * 16 + nieder);
}

//	Loest ein einzelnes Stueck eines RFC-2231-Werts auf.
//
//	bKodiert	TRUE, wenn der Parametername auf * endete (filename*0*).
//				Nur dann stehen %XX fuer Bytes, und nur im ERSTEN Stueck
//				steht der Zeichensatz davor. Ohne * ist der Wert woertlich -
//				ein %20 bleibt dann ein %20 (RFC 2231 Abschnitt 4).
//	pZeichensatz  darf NULL sein. Wird nur beschrieben, wenn der Wert die
//				Form "zeichensatz'sprache'text" hat.
//
//	Rueckgabe: Laenge des Ergebnisses, oder -1 bei fehlenden Zeigern oder
//	wenn das Ergebnis nicht in pZiel passt. Bei -1 ist pZiel unbrauchbar.
int RFC2231Entschluesseln(const char* pWert, BOOL bKodiert,
						  char* pZiel, int nZiel,
						  char* pZeichensatz, int nZeichensatz)
{
	const char *	s;
	char *			d;
	char *			e;

	if (!pWert || !pZiel || nZiel < 1)
		return (-1);

	*pZiel = 0;
	if (pZeichensatz && nZeichensatz > 0)
		*pZeichensatz = 0;

	s = pWert;

	if (bKodiert)
	{
		//	"zeichensatz'sprache'text" - beide Anfuehrungsstriche muessen da
		//	sein, sonst ist es kein Vorspann, sondern schon der Text. Manche
		//	Absender lassen ihn im zweiten und folgenden Stueck weg; das ist
		//	nach RFC 2231 Abschnitt 4 auch richtig so.
		const char* erstes = strchr(s, '\'');
		const char* zweites = erstes? strchr(erstes + 1, '\'') : NULL;

		if (erstes && zweites)
		{
			if (pZeichensatz && nZeichensatz > 0)
			{
				int nLen = (int)(erstes - s);
				if (nLen > nZeichensatz - 1)
					nLen = nZeichensatz - 1;
				memcpy(pZeichensatz, s, (size_t)nLen);
				pZeichensatz[nLen] = 0;
			}
			s = zweites + 1;
		}
	}

	d = pZiel;
	e = pZiel + nZiel - 1;

	while (*s)
	{
		if (d >= e)
			return (-1);			// passt nicht - lieber nichts als die Haelfte

		if (bKodiert && *s == '%')
		{
			int nByte = RFC2231Hex(s + 1);
			if (nByte >= 0)
			{
				*d++ = (char)nByte;
				s += 3;
				continue;
			}
			//	Ein einzelnes % ohne gueltiges Paar dahinter: woertlich
			//	nehmen. Einen Dateinamen daran scheitern zu lassen waere
			//	schlimmer als ein Prozentzeichen im Namen.
		}

		*d++ = *s++;
	}

	*d = 0;
	return ((int)(d - pZiel));
}


//	Setzt alle Stuecke zusammen. Siehe rfc2231.h.
//
//	Zwei Formen sind erlaubt und kommen beide vor:
//	  a) ein Stueck, kodiert:  filename*=UTF-8''Angebot%20Nr.pdf
//	  b) mehrere Stuecke:      filename*0=... filename*1=...
//	     je einzeln kodiert:   filename*0*=... filename*1*=...
//	Die Nummern fangen bei 0 an und sind lueckenlos (RFC 2231, 3); bei der
//	ersten Luecke ist Schluss. 100 Stuecke sind mehr, als ein Dateiname je
//	braucht, und begrenzen zugleich, was ein boeser Absender anrichten kann.
int RFC2231Zusammensetzen(const char* pName,
						  RFC2231Sucher pSuchen, void* pZusatz,
						  char* pZiel, int nZiel,
						  char* pZeichensatz, int nZeichensatz)
{
	char			szName[64];
	char			szStueck[1024];
	const char *	pWert;
	int				nGanz = 0;
	int				n;
	int				i;

	if (!pName || !*pName || !pSuchen || !pZiel || nZiel < 2)
		return (-1);
	if (strlen(pName) > sizeof(szName) - 8)
		return (-1);

	*pZiel = 0;
	if (pZeichensatz && nZeichensatz > 0)
		*pZeichensatz = 0;

	//	a) Ein einziges, kodiertes Stueck.
	_snprintf(szName, sizeof(szName) - 1, "%s*", pName);
	szName[sizeof(szName) - 1] = 0;
	pWert = pSuchen(pZusatz, szName);
	if (pWert)
		return (RFC2231Entschluesseln(pWert, TRUE, pZiel, nZiel,
									  pZeichensatz, nZeichensatz));

	//	b) Mehrere Stuecke.
	for (i = 0; i < 100; i++)
	{
		BOOL	bKodiert = TRUE;

		_snprintf(szName, sizeof(szName) - 1, "%s*%d*", pName, i);
		szName[sizeof(szName) - 1] = 0;
		pWert = pSuchen(pZusatz, szName);

		if (!pWert)
		{
			bKodiert = FALSE;
			_snprintf(szName, sizeof(szName) - 1, "%s*%d", pName, i);
			szName[sizeof(szName) - 1] = 0;
			pWert = pSuchen(pZusatz, szName);
		}

		if (!pWert)
			break;

		//	Der Zeichensatz steht nur im ersten Stueck.
		n = RFC2231Entschluesseln(pWert, bKodiert, szStueck, sizeof(szStueck),
								  (i == 0)? pZeichensatz : NULL,
								  (i == 0)? nZeichensatz : 0);
		if (n < 0)
			return (-1);
		if (nGanz + n > nZiel - 1)
			return (-1);

		memcpy(pZiel + nGanz, szStueck, (size_t)n);
		nGanz += n;
		pZiel[nGanz] = 0;
	}

	if (i == 0)
		return (-1);			// kein einziges Stueck gefunden

	return (nGanz);
}


//	Setzt einen UTF-8-Namen auf die ANSI-Kodepage um. Siehe rfc2231.h.
//	Was sich dort nicht abbilden laesst, wird zu einem Fragezeichen - das
//	ist immer noch besser als die rohen UTF-8-Bytes im Dateinamen.
void RFC2231ZeichensatzUmsetzen(const char* pZeichensatz, char* pName, int nName)
{
	WCHAR	szWeit[1024];
	char	szEng[1024];
	int		nWeit;

	if (!pZeichensatz || !*pZeichensatz || !pName || !*pName || nName < 1)
		return;

	if (stricmp(pZeichensatz, "utf-8") != 0 && stricmp(pZeichensatz, "utf8") != 0)
		return;

	nWeit = ::MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, pName, -1,
								  szWeit, sizeof(szWeit) / sizeof(szWeit[0]));
	if (nWeit <= 0)
		return;				// kein gueltiges UTF-8 - die Bytes lieber lassen

	if (::WideCharToMultiByte(CP_ACP, 0, szWeit, -1, szEng, sizeof(szEng),
							  NULL, NULL) <= 0)
		return;

	strncpy(pName, szEng, (size_t)nName - 1);
	pName[nName - 1] = 0;
}

void AnhangNameKuerzen(char* pZiel, int nMax, const char* pQuelle)
{
	if (!pZiel || nMax < 0)
		return;
	if (!pQuelle)
	{
		*pZiel = 0;
		return;
	}

	int nLaenge = (int)strlen(pQuelle);
	if (nLaenge <= nMax)
	{
		memmove(pZiel, pQuelle, (size_t)nLaenge + 1);
		return;
	}

	const char* pPunkt = strrchr(pQuelle, '.');
	int nEndung = pPunkt ? (int)strlen(pPunkt) : 0;
	if (nEndung < 2 || nEndung > 16 || nEndung >= nMax)
		nEndung = 0;

	//	Erst der Stamm, dann die Endung dahinter. Bei pZiel == pQuelle
	//	liegt die Endung immer HINTER der Stelle, an die sie kommt -
	//	memmove deckt beides.
	int nStamm = nMax - nEndung;
	memmove(pZiel, pQuelle, (size_t)nStamm);
	if (nEndung)
		memmove(pZiel + nStamm, pPunkt, (size_t)nEndung);
	pZiel[nMax] = 0;
}
