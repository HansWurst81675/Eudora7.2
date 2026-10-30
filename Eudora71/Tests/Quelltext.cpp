//
// Quelltext.cpp - siehe Quelltext.h
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Quelltext.h"

char* QT_Lesen(const char* szEudoraDir, const char* szRelPfad)
{
	char	szPfad[1024];
	FILE*	f;
	long	lSize;
	char*	pBuf;

	if (!szEudoraDir || !szRelPfad)
		return 0;

	_snprintf(szPfad, sizeof(szPfad) - 1, "%s\\%s", szEudoraDir, szRelPfad);
	szPfad[sizeof(szPfad) - 1] = 0;

	f = fopen(szPfad, "rb");
	if (!f)
		return 0;

	fseek(f, 0, SEEK_END);
	lSize = ftell(f);
	fseek(f, 0, SEEK_SET);

	if (lSize < 0)
	{
		fclose(f);
		return 0;
	}

	pBuf = (char*)malloc((size_t)lSize + 1);
	if (!pBuf)
	{
		fclose(f);
		return 0;
	}

	lSize = (long)fread(pBuf, 1, (size_t)lSize, f);
	pBuf[lSize] = 0;
	fclose(f);

	return pBuf;
}

void QT_KommentareRaus(char* pText)
{
	char*	p = pText;

	if (!pText)
		return;

	while (*p)
	{
		if (*p == '"' || *p == '\'')
		{
			// Zeichenkette oder Zeichenliteral ueberspringen. Darin ist ein
			// doppelter Schraegstrich kein Kommentar - sonst verschwaende
			// die halbe Datei an einer Adresse wie "http://www.eudora.com".
			//
			// ACHTUNG, hier stand am 22.10.2026 ein Dauerlauf: der Kommentar
			// an der Zeile mit dem maskierten Zeichen endete auf einen
			// Rueckstrich. Ein Rueckstrich am Zeilenende ist eine
			// Fortsetzungszeile - AUCH in einem Zeilenkommentar. Damit
			// verschluckte der Kommentar das naechste "++p;", der Zeiger
			// blieb stehen und die Testsammlung lief nicht mehr durch.
			// In einem Kommentar also nie einen Rueckstrich ans Zeilenende.
			const char	chEnde = *p;

			++p;
			while (*p && *p != chEnde)
			{
				// Ein maskiertes Zeichen zaehlt doppelt.
				if (*p == '\\' && p[1])
					++p;
				++p;
			}
			if (*p)
				++p;
			continue;
		}

		if (p[0] == '/' && p[1] == '/')
		{
			while (*p && *p != '\n')
				*p++ = ' ';
			continue;
		}

		if (p[0] == '/' && p[1] == '*')
		{
			*p++ = ' ';
			*p++ = ' ';
			while (*p && !(p[0] == '*' && p[1] == '/'))
			{
				if (*p != '\n')
					*p = ' ';
				++p;
			}
			if (*p)
			{
				*p++ = ' ';
				if (*p)
					*p++ = ' ';
			}
			continue;
		}

		++p;
	}
}

static int IstLeerraum(char ch)
{
	return (ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n' || ch == '\f' || ch == '\v');
}

void QT_LeerraumZusammen(char* pText)
{
	char*	pLesen  = pText;
	char*	pSchreiben = pText;

	if (!pText)
		return;

	while (*pLesen)
	{
		if (IstLeerraum(*pLesen))
		{
			while (IstLeerraum(*pLesen))
				++pLesen;
			*pSchreiben++ = ' ';
		}
		else
		{
			*pSchreiben++ = *pLesen++;
		}
	}
	*pSchreiben = 0;
}

// Liefert den Namen einer Praeprozessor-Anweisung am Zeilenanfang ("if",
// "ifdef", "endif" ...) in szName, oder 0, wenn die Zeile keine ist.
// *ppNachName zeigt hinter den Namen.
static int Direktive(const char* pZeile, char* szName, int nName, const char** ppNachName)
{
	const char*	p = pZeile;
	int			n = 0;

	while (*p == ' ' || *p == '\t')
		++p;
	if (*p != '#')
		return 0;
	++p;
	while (*p == ' ' || *p == '\t')
		++p;
	while (n < nName - 1 && *p >= 'a' && *p <= 'z')
		szName[n++] = *p++;
	szName[n] = 0;
	if (ppNachName)
		*ppNachName = p;
	return n > 0;
}

static char* NaechsteZeile(char* pZeile)
{
	char*	pEnde = strchr(pZeile, '\n');
	return pEnde ? pEnde + 1 : pZeile + strlen(pZeile);
}

static void ZeileLeeren(char* pZeile)
{
	for (char* q = pZeile; *q && *q != '\n'; ++q)
		*q = ' ';
}

void QT_IfNullRaus(char* pText)
{
	char*	pZeile = pText;
	char	szName[16];

	if (!pText)
		return;

	while (*pZeile)
	{
		const char*	pRest = 0;

		if (Direktive(pZeile, szName, sizeof(szName), &pRest) && strcmp(szName, "if") == 0)
		{
			while (*pRest == ' ' || *pRest == '\t')
				++pRest;
			const char	chNach = pRest[1];
			if (pRest[0] == '0' && !(chNach == '_' || chNach == 'x' || chNach == 'X' ||
									 (chNach >= '0' && chNach <= '9') ||
									 (chNach >= 'A' && chNach <= 'Z') ||
									 (chNach >= 'a' && chNach <= 'z')))
			{
				// Bis zum passenden #else, #elif oder #endif leeren. Ein
				// verschachteltes #if/#ifdef/#ifndef zaehlt mit. Hinter #else
				// oder #elif beginnt wieder lebender Code - das alleinstehende
				// #endif dahinter stoert keine Suche.
				int	iTiefe = 0;

				for (;;)
				{
					char*	pNaechste = NaechsteZeile(pZeile);
					int		bEnde = 0;

					if (Direktive(pZeile, szName, sizeof(szName), 0))
					{
						if (strncmp(szName, "if", 2) == 0)
							++iTiefe;
						else if (strcmp(szName, "endif") == 0)
							bEnde = (--iTiefe == 0);
						else if (iTiefe == 1 && (strcmp(szName, "else") == 0 || strcmp(szName, "elif") == 0))
							bEnde = 1;
					}
					ZeileLeeren(pZeile);
					pZeile = pNaechste;
					if (bEnde || !*pZeile)
						break;
				}
				continue;
			}
		}
		pZeile = NaechsteZeile(pZeile);
	}
}

char* QT_LiesNurCode(const char* szEudoraDir, const char* szRelPfad)
{
	char*	pText;

	pText = QT_Lesen(szEudoraDir, szRelPfad);

	if (!pText)
		return 0;

	QT_KommentareRaus(pText);
	QT_IfNullRaus(pText);
	QT_LeerraumZusammen(pText);
	return pText;
}

int QT_Enthaelt(const char* pText, const char* szSuche)
{
	if (!pText || !szSuche)
		return 0;
	return strstr(pText, szSuche) ? 1 : 0;
}

long QT_Stelle(const char* pText, const char* szSuche)
{
	const char*	p;

	if (!pText || !szSuche)
		return -1;
	p = strstr(pText, szSuche);
	return p ? (long)(p - pText) : -1L;
}

int QT_Zaehle(const char* pText, const char* szSuche)
{
	int			iZahl = 0;
	const char*	p = pText;
	size_t		nLen;

	if (!pText || !szSuche || !*szSuche)
		return 0;

	nLen = strlen(szSuche);
	while ((p = strstr(p, szSuche)) != 0)
	{
		++iZahl;
		p += nLen;
	}
	return iZahl;
}

char* QT_Abschnitt(const char* pText, const char* szVon, const char* szBis)
{
	const char*	pVon;
	const char*	pBis;
	size_t		nLen;
	char*		pAus;

	if (!pText || !szVon || !szBis)
		return 0;

	pVon = strstr(pText, szVon);
	if (!pVon)
		return 0;

	pBis = strstr(pVon, szBis);
	if (!pBis)
		return 0;

	pBis += strlen(szBis);
	nLen = (size_t)(pBis - pVon);

	pAus = (char*)malloc(nLen + 1);
	if (!pAus)
		return 0;

	memcpy(pAus, pVon, nLen);
	pAus[nLen] = 0;
	return pAus;
}

int QT_RueckgabeGenutzt(const char* pText, const char* szAufruf, int* piGefunden)
{
	const char*	p = pText;
	size_t		nLen;
	int			iZahl = 0;
	int			iAllesGenutzt = 1;

	if (piGefunden)
		*piGefunden = 0;

	if (!pText || !szAufruf || !*szAufruf)
		return 0;

	nLen = strlen(szAufruf);

	while ((p = strstr(p, szAufruf)) != 0)
	{
		const char*	pZurueck = p;

		// Ein Treffer mitten in einem laengeren Bezeichner zaehlt nicht:
		// "UT_ISOTranslate(" ist nicht "ISOTranslate(".
		if (pZurueck > pText)
		{
			const char	chDavor = pZurueck[-1];
			if (chDavor == '_' || chDavor == ':' ||
				(chDavor >= 'A' && chDavor <= 'Z') ||
				(chDavor >= 'a' && chDavor <= 'z') ||
				(chDavor >= '0' && chDavor <= '9'))
			{
				p += nLen;
				continue;
			}
		}

		++iZahl;

		// Rueckwaerts ueber den Leerraum vor dem Aufruf.
		while (pZurueck > pText && IstLeerraum(pZurueck[-1]))
			--pZurueck;

		if (pZurueck == pText)
		{
			iAllesGenutzt = 0;
		}
		else
		{
			const char	chDavor = pZurueck[-1];

			// UMGEDREHT AM 22.10.2026 (PRUEFER, Fund 2).
			//
			// Hier stand eine Liste der Anweisungsanfaenge: ';', '{', '}'.
			// Alles andere galt als "Wert genutzt". Damit kam ein
			// weggeworfener Rueckgabewert durch, sobald davor etwas anderes
			// stand - gemessen an
			//
			//     if (inLen > 0) ISOTranslateChunk(...);
			//
			// Dort steht ')' davor, der Wert faellt weg, und der Test
			// "NP3-9: beide Aufrufstellen nehmen den Rueckgabewert
			// entgegen" blieb bei 274/274 gruen. Dasselbe gilt fuer das 'e'
			// aus "else".
			//
			// Jetzt wird die KURZE Liste gefuehrt: was den Wert wirklich
			// entgegennimmt oder weiterreicht. Alles andere zaehlt als
			// weggeworfen. Eine unbekannte Umgebung macht den Test damit
			// ROT statt gruen - das ist die richtige Richtung fuer eine
			// Schranke.
			//
			//   =        Zuweisung, auch ==, <=, >=, != (alle nutzen ihn)
			//   ( ,      Argument eines anderen Aufrufs
			//   n        das 'n' aus "return"
			//   & | ! ?  : < > + - * / %   Teil eines Ausdrucks
			//
			// BEKANNTE GRENZE: eine Typumwandlung - (LONG)Aufruf(...) -
			// hat ebenfalls ')' davor und wuerde faelschlich als
			// weggeworfen gelten. Dann wird der Test rot und jemand sieht
			// hin; im Baum kommt es an den geprueften Stellen nicht vor.
			// DREI ZEICHEN HERAUSGENOMMEN (23.10.2026, PRUEFER).
			//
			// In der ersten Fassung standen hier auch ',' ':' und '>'. Alle
			// drei kommen in BEIDEN Lagen vor, und an einem einzelnen
			// Zeichen sind sie nicht zu unterscheiden:
			//
			//   >   a > Aufruf(x)        nutzt     ABER  p->Aufruf(x);  wirft weg
			//   :   c ? a : Aufruf()     nutzt     ABER  case 1: Aufruf(x);  wirft weg
			//   ,   f(a, Aufruf(x))      nutzt     ABER  a = 0, Aufruf(x);   wirft weg
			//
			// PRUEFER hat den Kommafall gemessen: mit
			// "lUebersetzt = 0, ISOTranslateChunk(...);" blieb NP3-9 gruen,
			// obwohl der Wert wegfaellt - genau der Schaden des Befunds.
			//
			// '>' laesst sich retten: '->' hat ein '-' davor, der Vergleich
			// nicht. ':' und ',' lassen sich nicht retten und fliegen raus.
			// Damit gelten die beiden NUTZENDEN Formen oben jetzt
			// faelschlich als weggeworfen - der Test wuerde dort ROT. Das
			// ist die gewollte Richtung (Arbeitsweise/schranke-gegentesten.md:
			// stumm und Fehlalarm kosten dasselbe, aber nur der Fehlalarm
			// faellt auf), und an den beiden Nadeln, auf die diese Funktion
			// angewandt wird, kommt keine der Formen vor: beide Aufrufe
			// stehen hinter '=' (TextReader.cpp:300, ImapDownload.cpp:4817).
			const char* const	szNutzt = "=(n&|!?<+*/%";

			int	bGenutzt = (strchr(szNutzt, chDavor) != NULL);

			// '-' nutzt (a - Aufruf()), '>' nutzt nur, wenn davor KEIN '-'
			// steht - sonst ist es ein verworfener Methodenaufruf.
			if (chDavor == '-')
				bGenutzt = 1;
			else if (chDavor == '>')
				bGenutzt = (pZurueck - 1 > pText) && (pZurueck[-2] != 0x2D);

			if (!bGenutzt)
				iAllesGenutzt = 0;
		}

		p += nLen;
	}

	if (piGefunden)
		*piGefunden = iZahl;

	return (iZahl > 0) ? iAllesGenutzt : 0;
}
