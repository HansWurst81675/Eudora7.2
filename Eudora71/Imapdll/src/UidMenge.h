// UidMenge.h - liest eine IMAP-UID-Menge (RFC 3501 "sequence-set") in eine
// CDWordArray: "5", "2:4", "9:7" (= 7,8,9), "2,5,9", "10:12,15".
//
// BEFUND E-184 (PRUEFER-75 K3, 01.11.2026). Eudora las aus der Antwort
// "[COPYUID <uidvalidity> <quellmenge> <zielmenge>]" nur die Zielmenge und
// ordnete die neuen UIDs nach der Reihenfolge der eigenen Liste zu. Die folgt
// der Sortierung der Ansicht; der Server nummeriert in UID-Reihenfolge. Bei
// mehreren Mails in nicht aufsteigender Ansicht bekamen die Zusammenfassungen
// im Ziel die neuen UIDs ueber Kreuz. RFC 4315: die n-te UID der Quellmenge
// gehoert zur n-ten der Zielmenge - dafuer muss die Quellmenge gelesen werden,
// und die ist meist eine Liste ("2,5,9"), die der alte Leser UIDStringToUIDs
// nicht verstand (nur "x" und "x:y").
//
// Eigene Datei, damit die Regressionstests (Tests/TestE184.cpp) genau diesen
// Code aufrufen koennen. Nur Kopfdatei, keine Abhaengigkeit ausser MFC.
// Kodierung: reines ASCII.
#ifndef EUDORA_UIDMENGE_H
#define EUDORA_UIDMENGE_H

#include <afxcoll.h>

// Liest szMenge[0 .. iLen-1]. Haengt die UIDs an pAus an (in der Reihenfolge
// der Menge, ein Bereich aufsteigend). Liefert die Zahl der angehaengten UIDs,
// -1 bei einem Fehler im Aufbau (dann ist pAus unveraendert). "*" ist in einer
// COPYUID-Antwort nicht erlaubt und gilt als Fehler. Hoechstens 100000 UIDs je
// Bereich - ein verdorbener Bereich darf keinen Speicher erschoepfen.
inline int E184UidMengeLesen(const char *szMenge, int iLen, CDWordArray *pAus)
{
	if (!szMenge || !pAus || iLen <= 0)
		return -1;

	CDWordArray dwaNeu;
	int i = 0;
	while (i < iLen)
	{
		unsigned long ulVon = 0, ulBis = 0;
		int nZiffern = 0;
		while (i < iLen && szMenge[i] >= '0' && szMenge[i] <= '9')
		{
			// PRUEFER-78 K3: ueber 4294967295 nicht ueberlaufen lassen
			// ("4294967297" wurde zu UID 1).
			if (ulVon > 429496729UL || (ulVon == 429496729UL && szMenge[i] > '5')) return -1;
			ulVon = ulVon * 10 + (unsigned long) (szMenge[i] - '0');
			i++; nZiffern++;
			if (nZiffern > 10) return -1;
		}
		if (nZiffern == 0 || ulVon == 0) return -1;
		ulBis = ulVon;
		if (i < iLen && szMenge[i] == ':')
		{
			i++;
			ulBis = 0; nZiffern = 0;
			while (i < iLen && szMenge[i] >= '0' && szMenge[i] <= '9')
			{
				if (ulBis > 429496729UL || (ulBis == 429496729UL && szMenge[i] > '5')) return -1;
				ulBis = ulBis * 10 + (unsigned long) (szMenge[i] - '0');
				i++; nZiffern++;
				if (nZiffern > 10) return -1;
			}
			if (nZiffern == 0 || ulBis == 0) return -1;
		}
		if (ulBis < ulVon) { unsigned long t = ulVon; ulVon = ulBis; ulBis = t; }
		if (ulBis - ulVon >= 100000UL) return -1;
		for (unsigned long u = ulVon; ; u++)
		{
			dwaNeu.Add((DWORD) u);
			if (u == ulBis) break;
		}
		if (i < iLen)
		{
			if (szMenge[i] != ',') return -1;
			i++;
			if (i >= iLen) return -1;		// Komma am Ende
		}
	}
	pAus->Append(dwaNeu);
	return (int) dwaNeu.GetSize();
}

#endif // EUDORA_UIDMENGE_H
