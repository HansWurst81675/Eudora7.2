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
// VERWALTUNG DER VORMERKUNGEN (PRUEFER-89 K1, K2, K4). Wann vorgemerkt wird,
// welche Vormerkung zu welchem Abgleich gehoert, wann sie verfaellt und wann
// sie verworfen wird, steht ebenfalls hier - als reine Entscheidungen; die
// Speicherung (CString, CPtrArray) bleibt in EuImap/src/ImapToc.cpp:
//   - vorgemerkt wird nur nach GELUNGENER Uebertragung (E170WegWaehlen) und
//     nur, wenn im Ziel noch keine gleich aussehende Mail steht
//     (E170Vormerkbar);
//   - eine Vormerkung gehoert zu ihrem Ziel ueber Zeiger UND Pfad
//     (E170GehoertZu);
//   - die Nachbearbeitung, die den Abgleich des Ziels anstoesst, macht die
//     Vormerkungen dieses Ziels "angestossen" und startet die Frist neu
//     (E170Anstossen);
//   - am Ende des naechsten Abgleichs dieses Ziels wird jede angestossene
//     Vormerkung ohne Treffer verworfen (E170AbgleichEnde) - sie wartet nicht
//     mehr fuenf Minuten auf eine gleich aussehende fremde Mail (K1);
//   - die Frist (E170_FRIST_MS) bleibt als Rueckfall fuer Vormerkungen, deren
//     Abgleich nie kommt.
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

// ---------------------------------------------------------------------------
// Weg nach der Uebertragung (CImapTransferMsgAction::E170LabelsNachtragen)
// ---------------------------------------------------------------------------
enum E170Weg
{
	E170_WEG_KEIN_ZIEL = 0,
	E170_WEG_FEHLGESCHLAGEN,	// PRUEFER-89 K1: COPY gescheitert - keine Kopie, nichts vormerken
	E170_WEG_VORMERKEN,			// gelungen, aber keine neuen UIDs (kein UIDPLUS)
	E170_WEG_ANZAHL,			// neue UIDs, Anzahl passt nicht
	E170_WEG_REIHENFOLGE,		// PRUEFER-71 K1: alte Liste nicht aufsteigend
	E170_WEG_ZUORDNEN			// UIDPLUS: paarweise ueber die UIDs
};

inline E170Weg E170WegWaehlen(bool bZiel, bool bGelungen, int nNeu, int nAlt, int nLabels, bool bAltAufsteigend)
{
	if (!bZiel)
		return E170_WEG_KEIN_ZIEL;
	if (!bGelungen)
		return E170_WEG_FEHLGESCHLAGEN;
	if (nNeu == 0)
		return E170_WEG_VORMERKEN;
	if (nNeu != nAlt || nLabels != nAlt)
		return E170_WEG_ANZAHL;
	if (!bAltAufsteigend)
		return E170_WEG_REIHENFOLGE;
	return E170_WEG_ZUORDNEN;
}

// Der Grund in der Logzeile "E-170 Labels beim Verschieben im Konto"
// (tools/messen-e184.ps1 liest ihn als log-grund).
inline const char* E170WegGrund(E170Weg w)
{
	switch (w)
	{
	case E170_WEG_KEIN_ZIEL:		return "kein-ziel";
	case E170_WEG_FEHLGESCHLAGEN:	return "fehlgeschlagen";
	case E170_WEG_VORMERKEN:		return "keine-neuen-uids";
	case E170_WEG_ANZAHL:			return "anzahl-passt-nicht";
	case E170_WEG_REIHENFOLGE:		return "reihenfolge-unsicher";
	default:						return "ok";
	}
}

// ---------------------------------------------------------------------------
// Vormerken (E170LabelsVormerken)
// ---------------------------------------------------------------------------
enum
{
	E170_VM_JA = 0,
	E170_VM_OHNE_LABEL,		// Mail ohne Label - nichts mitzunehmen
	E170_VM_SCHON_DA		// im Ziel steht schon eine gleich aussehende Mail
};

// Steht im Ziel schon eine Zusammenfassung mit diesen Merkmalen (eine
// stehengebliebene Vorab-Kopie, die Kopie schon von einem Abgleich geholt,
// oder eine gleich aussehende fremde Mail), nicht vormerken: sonst koennte
// spaeter eine fremde neue Mail die einzige passende sein.
inline int E170Vormerkbar(int nLabel, const E170Merkmale& mQuelle,
						  const E170Merkmale* pZiel, int nZiel)
{
	if (nLabel == 0)
		return E170_VM_OHNE_LABEL;
	for (int k = 0; k < nZiel; k++)
	{
		if (E170MerkmaleGleich(mQuelle, pZiel[k]))
			return E170_VM_SCHON_DA;
	}
	return E170_VM_JA;
}

// ---------------------------------------------------------------------------
// Verwaltung: Ziel, Anstoss, Frist, Verwerfen
// ---------------------------------------------------------------------------
struct E170Eintrag
{
	const void*		pZiel;			// nur verglichen, nie dereferenziert
	const char*		szZiel;			// Pfad des Ziels (GetMBFileName)
	E170Merkmale	m;
	unsigned long	dwSeit;			// GetTickCount beim Vormerken bzw. beim Anstoss
	bool			bAngestossen;	// der Abgleich des Ziels ist angestossen
};

// Fuenf Minuten - nur noch Rueckfall, siehe oben.
static const unsigned long E170_FRIST_MS = 5UL * 60UL * 1000UL;

// Ein wiederverwendeter Zeiger allein reicht nicht: Zeiger UND Pfad.
inline bool E170GehoertZu(const E170Eintrag& e, const void* pZiel, const char* szZiel)
{
	if (!e.szZiel || !szZiel)
		return false;
	return e.pZiel == pZiel && _stricmp(e.szZiel, szZiel) == 0;
}

// Vorzeichenlos: uebersteht den Ueberlauf von GetTickCount nach 49 Tagen.
inline bool E170Abgelaufen(const E170Eintrag& e, unsigned long dwJetzt, unsigned long dwFrist)
{
	return dwJetzt - e.dwSeit > dwFrist;
}

// Die Nachbearbeitung stoesst den Abgleich des Ziels an: jede Vormerkung
// dieses Ziels gilt ab jetzt als angestossen, die Frist laeuft ab jetzt
// (PRUEFER-89 K4: nicht ab dem Einreihen). Rueckgabe: Zahl der Eintraege.
inline int E170Anstossen(E170Eintrag* pE, int nE, const void* pZiel, const char* szZiel, unsigned long dwJetzt)
{
	int n = 0;
	for (int i = 0; i < nE; i++)
	{
		if (E170GehoertZu(pE[i], pZiel, szZiel))
		{
			pE[i].bAngestossen = true;
			pE[i].dwSeit = dwJetzt;
			n++;
		}
	}
	return n;
}

// Was mit einer Vormerkung in einem Abgleich geschieht (pnAktion[i]):
//   >= 0                   Index des Kandidaten: Label setzen, Eintrag verwerfen
//   E170_AKT_BLEIBT        anderes Ziel, oder kein Treffer (bis E170AbgleichEnde)
//   E170_AKT_VERFALLEN     Frist abgelaufen (jedes Ziel): verwerfen
//   E170_AKT_MEHRDEUTIG    nicht eindeutig: verwerfen
enum
{
	E170_AKT_BLEIBT     = -10,
	E170_AKT_VERFALLEN  = -11,
	E170_AKT_MEHRDEUTIG = -12
};

// Wird die Vormerkung nach dieser Aktion verworfen? Zugeordnet, mehrdeutig
// oder verfallen: ja. Nur "bleibt" wartet auf den Rest des Abgleichs.
inline bool E170NachAktionVerwerfen(int nAktion)
{
	return nAktion != E170_AKT_BLEIBT;
}

inline void E170AbgleichEntscheiden(const E170Eintrag* pE, int nE,
									const void* pZiel, const char* szZiel,
									const E170Merkmale* pKand, int nKand,
									unsigned long dwJetzt, unsigned long dwFrist,
									int* pnAktion)
{
	int nMeine = 0;
	for (int i = 0; i < nE; i++)
	{
		if (E170Abgelaufen(pE[i], dwJetzt, dwFrist))
			pnAktion[i] = E170_AKT_VERFALLEN;
		else
		{
			pnAktion[i] = E170_AKT_BLEIBT;
			if (E170GehoertZu(pE[i], pZiel, szZiel))
				nMeine++;
		}
	}
	if (nMeine == 0 || nKand <= 0)
		return;

	E170Merkmale* pVor = new E170Merkmale[nMeine];
	int* pnIndex = new int[nMeine];
	int* pnZu = new int[nMeine];
	int j = 0;
	for (int i = 0; i < nE; i++)
	{
		if (pnAktion[i] == E170_AKT_BLEIBT && E170GehoertZu(pE[i], pZiel, szZiel))
		{
			pVor[j] = pE[i].m;
			pnIndex[j] = i;
			j++;
		}
	}
	E170Zuordnen(pVor, nMeine, pKand, nKand, pnZu);
	for (j = 0; j < nMeine; j++)
	{
		if (pnZu[j] >= 0)
			pnAktion[pnIndex[j]] = pnZu[j];
		else if (pnZu[j] == E170_MEHRDEUTIG)
			pnAktion[pnIndex[j]] = E170_AKT_MEHRDEUTIG;
		// E170_KEIN_TREFFER: bleibt - die Kopie kann im zweiten Teil desselben
		// Abgleichs stehen (PostProcessSummaries ruft ImapAppendSumList zweimal)
	}
	delete [] pVor;
	delete [] pnIndex;
	delete [] pnZu;
}

// Am Ende eines Abgleichs von (pZiel, szZiel): pbVerwerfen[i] fuer jede
// angestossene Vormerkung dieses Ziels - die Kopie war nicht dabei, und eine
// spaeter eintreffende gleich aussehende Mail ist nicht die Kopie
// (PRUEFER-89 K1). Rueckgabe: Zahl der zu verwerfenden.
inline int E170AbgleichEnde(const E170Eintrag* pE, int nE, const void* pZiel, const char* szZiel, bool* pbVerwerfen)
{
	int n = 0;
	for (int i = 0; i < nE; i++)
	{
		pbVerwerfen[i] = pE[i].bAngestossen && E170GehoertZu(pE[i], pZiel, szZiel);
		if (pbVerwerfen[i])
			n++;
	}
	return n;
}

#endif // E170ZUORDNUNG_H
