//
// E170Zuordnung.h - Befund E-170 ohne UIDPLUS: welche neu aufgetauchte
// Zusammenfassung im Zielordner ist die verschobene Mail?
//
// Meldet der Server beim Kopieren keine neuen UIDs (kein COPYUID, RFC 4315),
// kennt Eudora die Nummer der Kopie im Ziel nicht. Erst der folgende Abgleich
// holt sie als neue Zusammenfassung - ohne Label (gemessen 02.11.2026,
// tools/messen-e170o.ps1: kopie-mit-label=0 an 7.2.1.128 und 7.2.1.131).
//
// Zuordnung ueber Merkmale, die Quelle und Kopie gleich tragen, weil beide aus
// denselben Kopfzeilen derselben Nachricht entstehen: Datum (m_Seconds),
// Absender (m_From), Betreff (m_Subject). Alle drei muessen gleich sein.
//
// SICHERHEIT VOR VOLLSTAENDIGKEIT (E-184: lieber kein Label als ein falsches).
// Eine Vormerkung bekommt einen Kandidaten nur, wenn
//   - genau EIN Kandidat zu ihr passt, und
//   - dieser Kandidat zu KEINER anderen Vormerkung passt.
// Sonst E170_MEHRDEUTIG - dann wird nichts gesetzt. Eine fremde Mail mit
// anderem Betreff, Absender oder Datum passt nie; eine fremde, die in allen
// dreien gleich ist, macht die Zuordnung mehrdeutig, und das Label bleibt aus.
//
// Reines C++, ohne MFC - der Regressionstest ruft es selbst auf
// (Tests/TestE170.cpp).
//
// Kodierung: reines ASCII.
//
#ifndef E170ZUORDNUNG_H
#define E170ZUORDNUNG_H

#include <string.h>

struct E170Merkmale
{
	long		lSekunden;
	const char*	szVon;
	const char*	szBetreff;
};

enum
{
	E170_KEIN_TREFFER = -1,
	E170_MEHRDEUTIG   = -2
};

inline bool E170MerkmaleGleich(const E170Merkmale& a, const E170Merkmale& b)
{
	if (!a.szVon || !b.szVon || !a.szBetreff || !b.szBetreff)
		return false;
	return a.lSekunden == b.lSekunden &&
		   strcmp(a.szVon, b.szVon) == 0 &&
		   strcmp(a.szBetreff, b.szBetreff) == 0;
}

// pnZuordnung[i] fuer jede Vormerkung i: Index des Kandidaten,
// E170_KEIN_TREFFER oder E170_MEHRDEUTIG.
inline void E170Zuordnen(const E170Merkmale* pVor, int nVor,
						 const E170Merkmale* pKand, int nKand,
						 int* pnZuordnung)
{
	for (int i = 0; i < nVor; i++)
	{
		int nTreffer = 0;
		int kTreffer = -1;
		for (int k = 0; k < nKand; k++)
		{
			if (E170MerkmaleGleich(pVor[i], pKand[k]))
			{
				nTreffer++;
				kTreffer = k;
			}
		}
		if (nTreffer == 0)
		{
			pnZuordnung[i] = E170_KEIN_TREFFER;
			continue;
		}
		if (nTreffer > 1)
		{
			pnZuordnung[i] = E170_MEHRDEUTIG;
			continue;
		}
		// Der Kandidat darf zu keiner anderen Vormerkung passen - zwei gleich
		// aussehende Mails, verschoben, sind nicht auseinanderzuhalten.
		bool bAndere = false;
		for (int j = 0; j < nVor && !bAndere; j++)
		{
			if (j != i && E170MerkmaleGleich(pVor[j], pKand[kTreffer]))
				bAndere = true;
		}
		pnZuordnung[i] = bAndere ? E170_MEHRDEUTIG : kTreffer;
	}
}

#endif // E170ZUORDNUNG_H
