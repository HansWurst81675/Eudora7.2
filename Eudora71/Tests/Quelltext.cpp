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

char* QT_LiesNurCode(const char* szEudoraDir, const char* szRelPfad)
{
	char*	pText;

	pText = QT_Lesen(szEudoraDir, szRelPfad);

	if (!pText)
		return 0;

	QT_KommentareRaus(pText);
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

			// '=' nimmt den Wert entgegen, '(' und ',' reichen ihn weiter,
			// 'n' aus "return" ebenfalls. Steht dort ';', '{' oder '}', ist
			// der Aufruf eine blosse Anweisung und der Wert faellt weg -
			// genau der Mangel aus NP3-9.
			if (chDavor == ';' || chDavor == '{' || chDavor == '}')
				iAllesGenutzt = 0;
		}

		p += nLen;
	}

	if (piGefunden)
		*piGefunden = iZahl;

	return (iZahl > 0) ? iAllesGenutzt : 0;
}
