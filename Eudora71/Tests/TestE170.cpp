//
// TestE170.cpp - Befund E-170: das Label einer Mail ging verloren, wenn man
// sie innerhalb eines IMAP-Kontos in einen anderen Ordner verschob.
//
// Gregors Entscheidung vom 01.11.2026: "Label mitnehmen". ImapXferOnSameAccount
// merkt beim Einreihen das Label je alter UID; die Nachbearbeitung der
// Uebertragung setzt es auf die neue Zusammenfassung im Ziel.
//
// Geprueft am Quelltext (die Wege haengen an CTocDoc, Server und Warteschlange
// und lassen sich ohne Programm nicht aufrufen): jede der vier Stellen muss
// dastehen, sonst ist die Kette unterbrochen und das Label geht wieder still
// verloren.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"
#include "..\EuImap\src\E170Zuordnung.h"

// E-170 ohne UIDPLUS: die Zuordnung selbst, im Verhalten. Gemessen am
// 02.11.2026 (tools/messen-e170o.ps1): ohne COPYUID kam die Kopie an
// 7.2.1.128 und 7.2.1.131 ohne Label an.
static E170Merkmale M(long l, const char* v, const char* b) { E170Merkmale m; m.lSekunden = l; m.szVon = v; m.szBetreff = b; return m; }

static void Test_E170_Zuordnung()
{
	TT_BeginTest("E-170 ohne UIDPLUS: Zuordnung nach Datum, Absender, Betreff - nur eindeutig, nie auf eine fremde Mail");
	int z[4];

	// 1. Die Kopie steht als dritte neue Zusammenfassung da (UID 1 -> 1 passt nicht zufaellig).
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Pruefnachricht 1"), M(100, "Pruefserver", "Pruefnachricht 2"), M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 1, k, 3, z);
		TT_CHECK_MSG(z[0] == 2, "die Kopie wird nicht ueber den Betreff gefunden, obwohl Datum und Absender bei allen gleich sind");
	}
	// 2. Eine fremde neue Mail taucht gleichzeitig auf, mit anderem Betreff: Label nur auf die Kopie.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Fremd", "Fremde neue Nachricht"), M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 1, k, 2, z);
		TT_CHECK_MSG(z[0] == 1, "neben einer fremden neuen Mail wird die Kopie nicht oder falsch zugeordnet");
	}
	// 3. Die fremde sieht genau gleich aus: lieber kein Label als ein falsches (E-184).
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Pruefnachricht 3"), M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 1, k, 2, z);
		TT_CHECK_MSG(z[0] == E170_MEHRDEUTIG, "zwei gleich aussehende neue Mails: es wird trotzdem eine gewaehlt - womoeglich die fremde");
	}
	// 4. Die Kopie ist (noch) nicht dabei, nur eine fremde: nichts.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(100, "Fremd", "Fremde neue Nachricht") };
		E170Zuordnen(v, 1, k, 1, z);
		TT_CHECK_MSG(z[0] == E170_KEIN_TREFFER, "ohne passende Kopie wird trotzdem zugeordnet");
	}
	// 5. Ein Merkmal weicht ab (Datum, Absender) oder fehlt: kein Treffer.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale k[] = { M(101, "Pruefserver", "Pruefnachricht 3"), M(100, "Anderer", "Pruefnachricht 3"), M(100, "Pruefserver", NULL) };
		E170Zuordnen(v, 1, k, 3, z);
		TT_CHECK_MSG(z[0] == E170_KEIN_TREFFER, "eine Mail mit anderem Datum, anderem Absender oder ohne Betreff gilt als Kopie");
	}
	// 6. Zwei gleich aussehende Mails verschoben, nur eine Kopie da: beide mehrdeutig.
	{
		E170Merkmale v[] = { M(100, "Pruefserver", "Gleich"), M(100, "Pruefserver", "Gleich") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Gleich") };
		E170Zuordnen(v, 2, k, 1, z);
		TT_CHECK_MSG(z[0] == E170_MEHRDEUTIG && z[1] == E170_MEHRDEUTIG, "eine Kopie wird zwei gleich aussehenden Vormerkungen gegeben");
	}
	// 7. Mehrere Mails, Ziel in anderer Folge: jede bekommt ihre eigene.
	{
		E170Merkmale v[] = { M(300, "Pruefserver", "Pruefnachricht 3"), M(200, "Pruefserver", "Pruefnachricht 2"), M(100, "Pruefserver", "Pruefnachricht 1") };
		E170Merkmale k[] = { M(100, "Pruefserver", "Pruefnachricht 1"), M(200, "Pruefserver", "Pruefnachricht 2"), M(300, "Pruefserver", "Pruefnachricht 3") };
		E170Zuordnen(v, 3, k, 3, z);
		TT_CHECK_MSG(z[0] == 2 && z[1] == 1 && z[2] == 0, "mehrere Mails werden nach Position statt nach Merkmalen zugeordnet");
	}
	TT_EndTest();
}

// PRUEFER-89 K2: die Verwaltung der Vormerkungen im Verhalten - Weg nach der
// Uebertragung, Vormerken, Ziel, Frist, Anstoss, Verwerfen. Vorher stand nur
// die Zuordnung selbst im Test; Zielpruefung, Frist und Verwerfen abgeschaltet
// blieb alles gruen (PRUEFER-89 G1-G4, G6).
static E170Eintrag E(const void* pZ, const char* szZ, long l, const char* v, const char* b, unsigned long dwSeit, bool bAn)
{
	E170Eintrag e;
	e.pZiel = pZ;
	e.szZiel = szZ;
	e.m = M(l, v, b);
	e.dwSeit = dwSeit;
	e.bAngestossen = bAn;
	return e;
}

static void Test_E170_Verwaltung()
{
	TT_BeginTest("E-170 ohne UIDPLUS: Verwaltung der Vormerkungen - nur nach gelungenem COPY, nur fuer ihr Ziel, Frist, Verwerfen nach dem Abgleich (PRUEFER-89)");
	static int s_A, s_B;	// zwei Ziele: nur die Adressen zaehlen
	const void* pA = &s_A;
	const void* pB = &s_B;
	const unsigned long F = E170_FRIST_MS;

	// 1. Weg nach der Uebertragung (K1): gescheitertes COPY merkt nichts vor - auch mit UIDPLUS.
	TT_CHECK_MSG(E170WegWaehlen(true, false, 0, 1, 1, true) == E170_WEG_FEHLGESCHLAGEN,
				 "gescheitertes COPY ohne neue UIDs wird vorgemerkt - eine spaeter eintreffende gleich aussehende Mail bekaeme das Label (PRUEFER-89 K1)");
	TT_CHECK_MSG(E170WegWaehlen(true, false, 1, 1, 1, true) == E170_WEG_FEHLGESCHLAGEN,
				 "gescheitertes COPY wird wie ein gelungenes behandelt (PRUEFER-89 K1)");
	TT_CHECK_MSG(strcmp(E170WegGrund(E170_WEG_FEHLGESCHLAGEN), "fehlgeschlagen") == 0,
				 "ein gescheitertes COPY meldet im Protokoll nicht grund=fehlgeschlagen (PRUEFER-89 K1: vorher keine-neuen-uids)");
	TT_CHECK_MSG(E170WegWaehlen(true, true, 0, 1, 1, true) == E170_WEG_VORMERKEN &&
				 strcmp(E170WegGrund(E170_WEG_VORMERKEN), "keine-neuen-uids") == 0,
				 "gelungenes COPY ohne neue UIDs wird nicht mehr vorgemerkt (E-170 ohne UIDPLUS)");
	TT_CHECK_MSG(E170WegWaehlen(false, true, 0, 1, 1, true) == E170_WEG_KEIN_ZIEL, "ohne Ziel wird trotzdem etwas versucht");
	TT_CHECK_MSG(E170WegWaehlen(true, true, 2, 1, 1, true) == E170_WEG_ANZAHL &&
				 E170WegWaehlen(true, true, 1, 1, 2, true) == E170_WEG_ANZAHL &&
				 strcmp(E170WegGrund(E170_WEG_ANZAHL), "anzahl-passt-nicht") == 0,
				 "bei ungleicher Anzahl wird zugeordnet - Gefahr: Label auf der falschen Mail (E-170)");
	TT_CHECK_MSG(E170WegWaehlen(true, true, 2, 2, 2, false) == E170_WEG_REIHENFOLGE &&
				 strcmp(E170WegGrund(E170_WEG_REIHENFOLGE), "reihenfolge-unsicher") == 0,
				 "bei nicht aufsteigender alter Liste wird zugeordnet (E-170, PRUEFER-71 K1)");
	TT_CHECK_MSG(E170WegWaehlen(true, true, 2, 2, 2, true) == E170_WEG_ZUORDNEN, "mit UIDPLUS wird nicht mehr ueber die UIDs zugeordnet (E-170)");

	// 2. Vormerken: nur mit Label, nicht wenn im Ziel schon eine gleich aussehende steht.
	{
		E170Merkmale q = M(100, "Pruefserver", "Pruefnachricht 3");
		E170Merkmale zLeer[1] = { M(0, "", "") };
		E170Merkmale zDa[] = { M(100, "Pruefserver", "Pruefnachricht 1"), M(100, "Pruefserver", "Pruefnachricht 3") };
		E170Merkmale zAnders[] = { M(101, "Pruefserver", "Pruefnachricht 3") };
		TT_CHECK_MSG(E170Vormerkbar(6, q, zLeer, 0) == E170_VM_JA, "eine Mail mit Label wird bei leerem Ziel nicht vorgemerkt (E-170 ohne UIDPLUS)");
		TT_CHECK_MSG(E170Vormerkbar(6, q, zAnders, 1) == E170_VM_JA, "eine anders aussehende Mail im Ziel verhindert das Vormerken");
		TT_CHECK_MSG(E170Vormerkbar(0, q, zLeer, 0) == E170_VM_OHNE_LABEL, "eine Mail ohne Label wird vorgemerkt");
		TT_CHECK_MSG(E170Vormerkbar(6, q, zDa, 2) == E170_VM_SCHON_DA,
					 "steht im Ziel schon eine gleich aussehende Mail, wird trotzdem vorgemerkt - spaeter koennte eine fremde die einzige passende sein");
	}

	// 3. Ziel (G1): Zeiger UND Pfad; Gross-/Kleinschreibung des Pfads egal.
	{
		E170Eintrag e = E(pA, "C:\\Post\\Ablage.mbx", 100, "P", "S", 0, false);
		TT_CHECK_MSG(E170GehoertZu(e, pA, "c:\\post\\ablage.mbx"), "die eigene Vormerkung wird ihrem Ziel nicht zugerechnet");
		TT_CHECK_MSG(!E170GehoertZu(e, pB, "C:\\Post\\Ablage.mbx"), "eine Vormerkung gilt fuer ein anderes Postfach (Zeiger) (PRUEFER-89 G1)");
		TT_CHECK_MSG(!E170GehoertZu(e, pA, "C:\\Post\\Anderes.mbx"), "ein wiederverwendeter Zeiger fuer ein anderes Postfach reicht (Pfad) (PRUEFER-89 G1)");
		TT_CHECK_MSG(!E170GehoertZu(e, pA, NULL), "ohne Pfad wird zugerechnet");

		E170Eintrag v[] = { e };
		E170Merkmale k[] = { M(100, "P", "S") };
		int a[1];
		E170AbgleichEntscheiden(v, 1, pB, "C:\\Post\\Ablage.mbx", k, 1, 10, F, a);
		TT_CHECK_MSG(a[0] == E170_AKT_BLEIBT, "eine passende Mail in einem ANDEREN Postfach bekommt das Label (PRUEFER-89 G1)");
		E170AbgleichEntscheiden(v, 1, pA, "C:\\Post\\Ablage.mbx", k, 1, 10, F, a);
		TT_CHECK_MSG(a[0] == 0, "die Kopie im eigenen Ziel wird nicht zugeordnet");
		TT_CHECK_MSG(E170NachAktionVerwerfen(a[0]), "eine zugeordnete Vormerkung bleibt stehen - sie koennte eine zweite Mail beschriften (PRUEFER-89 G4)");
	}

	// 4. Frist (G2): abgelaufen wird verworfen, in jedem Ziel; Ueberlauf von GetTickCount.
	{
		E170Eintrag v[] = { E(pA, "a", 100, "P", "S", 1000, false), E(pB, "b", 100, "P", "S", 1000, false) };
		E170Merkmale k[] = { M(100, "P", "S") };
		int a[2];
		E170AbgleichEntscheiden(v, 2, pA, "a", k, 1, 1000 + F + 1, F, a);
		TT_CHECK_MSG(a[0] == E170_AKT_VERFALLEN, "eine abgelaufene Vormerkung beschriftet noch eine Mail (PRUEFER-89 G2)");
		TT_CHECK_MSG(a[1] == E170_AKT_VERFALLEN, "eine abgelaufene Vormerkung eines anderen Ziels bleibt ewig stehen (PRUEFER-89 G2)");
		TT_CHECK_MSG(E170NachAktionVerwerfen(E170_AKT_VERFALLEN), "eine verfallene Vormerkung wird nicht verworfen (PRUEFER-89 G2)");
		E170AbgleichEntscheiden(v, 2, pA, "a", k, 1, 1000 + F, F, a);
		TT_CHECK_MSG(a[0] == 0 && a[1] == E170_AKT_BLEIBT, "eine Vormerkung verfaellt schon vor Ablauf der Frist");
		E170Eintrag w[] = { E(pA, "a", 100, "P", "S", 0xFFFFFF00UL, false) };
		E170AbgleichEntscheiden(w, 1, pA, "a", k, 1, 0x100UL, F, a);
		TT_CHECK_MSG(a[0] == 0, "nach dem Ueberlauf von GetTickCount gilt eine frische Vormerkung als abgelaufen");
	}

	// 5. Verwerfen (G3): mehrdeutig wird verworfen; kein Treffer bleibt bis zum Ende des Abgleichs.
	{
		E170Eintrag v[] = { E(pA, "a", 100, "P", "S", 0, true) };
		E170Merkmale kGleich[] = { M(100, "P", "S"), M(100, "P", "S") };
		E170Merkmale kFremd[] = { M(100, "Fremd", "Anders") };
		int a[1];
		E170AbgleichEntscheiden(v, 1, pA, "a", kGleich, 2, 10, F, a);
		TT_CHECK_MSG(a[0] == E170_AKT_MEHRDEUTIG && E170NachAktionVerwerfen(a[0]),
					 "eine mehrdeutige Vormerkung bleibt stehen - kommt eine der beiden spaeter allein wieder, bekaeme sie das Label (PRUEFER-89 G3)");
		E170AbgleichEntscheiden(v, 1, pA, "a", kFremd, 1, 10, F, a);
		TT_CHECK_MSG(a[0] == E170_AKT_BLEIBT && !E170NachAktionVerwerfen(a[0]),
					 "ohne Treffer im ersten Teil des Abgleichs wird verworfen - die Kopie kann im zweiten Teil stehen (ImapAppendSumList zweimal)");
		E170AbgleichEntscheiden(v, 1, pA, "a", kFremd, 0, 10, F, a);
		TT_CHECK_MSG(a[0] == E170_AKT_BLEIBT, "ohne neue Zusammenfassungen wird eine Vormerkung veraendert");
	}

	// 6. Anstoss und Ende des Abgleichs (K1, K4): nur das eigene Ziel, Frist ab dem Anstoss.
	{
		E170Eintrag v[] = { E(pA, "a", 100, "P", "S", 5, false), E(pB, "b", 100, "P", "S", 5, false), E(pA, "a", 200, "P", "T", 5, false) };
		bool w[3];
		TT_CHECK_MSG(E170AbgleichEnde(v, 3, pA, "a", w) == 0 && !w[0] && !w[2],
					 "eine Vormerkung, deren Abgleich noch nicht angestossen ist, wird schon verworfen");
		TT_CHECK_MSG(E170Anstossen(v, 3, pA, "a", 777) == 2, "der Anstoss trifft nicht genau die Vormerkungen des Ziels");
		TT_CHECK_MSG(v[0].bAngestossen && v[2].bAngestossen && !v[1].bAngestossen, "der Anstoss markiert ein fremdes Ziel oder das eigene nicht");
		TT_CHECK_MSG(v[0].dwSeit == 777 && v[1].dwSeit == 5, "die Frist laeuft nicht ab dem Anstoss (PRUEFER-89 K4)");
		TT_CHECK_MSG(E170AbgleichEnde(v, 3, pA, "a", w) == 2 && w[0] && w[2] && !w[1],
					 "nach dem Abgleich bleibt eine Vormerkung ohne Treffer stehen und wartet auf eine gleich aussehende fremde Mail (PRUEFER-89 K1)");
	}

	// 7. Der ganze Weg aus K1: COPY gelungen, Kopie im Abgleich nicht dabei,
	//    danach kommt eine gleich aussehende Mail - sie darf kein Label bekommen.
	{
		E170Eintrag v[] = { E(pA, "a", 100, "P", "S", 0, false) };
		E170Anstossen(v, 1, pA, "a", 50);
		E170Merkmale kOhne[] = { M(100, "Fremd", "Anders") };
		int a[1];
		bool w[1];
		E170AbgleichEntscheiden(v, 1, pA, "a", kOhne, 1, 60, F, a);
		const int nWeg = E170AbgleichEnde(v, 1, pA, "a", w);
		TT_CHECK_MSG(a[0] == E170_AKT_BLEIBT && nWeg == 1 && w[0],
					 "eine Vormerkung ohne Treffer ueberlebt den angestossenen Abgleich - die naechste gleich aussehende Mail bekaeme das Label (PRUEFER-89 K1)");
	}
	TT_EndTest();
}

static void Test_E170_OhneUidplus_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-170 ohne UIDPLUS (Quelltext): Merkmale gemerkt, am Ziel vorgemerkt, nach dem Abgleich gesetzt, Verwaltung aus E170Zuordnung.h");
	char* pToc = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pQ   = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
	char* pMb  = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapMailbox.cpp");
	char* pCh  = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapChecker.cpp");
	char* pApp0 = QT_LiesNurCode(szEudoraDir, "eudora.cpp");
	if (!pToc || !pQ || !pMb || !pCh || !pApp0)
	{
		TT_Fail("ImapToc.cpp, ImapActionQueue.cpp, ImapMailbox.cpp, ImapChecker.cpp oder eudora.cpp nicht lesbar - ungeprueft ist nicht gruen");
		if (pToc) free(pToc);
		if (pQ) free(pQ);
		if (pMb) free(pMb);
		if (pCh) free(pCh);
		if (pApp0) free(pApp0);
		TT_EndTest();
		return;
	}

	char* pXfer = QT_Abschnitt(pToc, "CSummary* CTocDoc::ImapXferOnSameAccount(", "CSummary* CTocDoc::ImapXferBetweenAccounts(");
	if (!pXfer)
		TT_Fail("ImapXferOnSameAccount nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pXfer, "dwaE170Sekunden.Add((DWORD) pSum->m_Seconds);") &&
					 QT_Enthaelt(pXfer, "saE170Von.Add(CString(pSum->m_From));") &&
					 QT_Enthaelt(pXfer, "saE170Betreff.Add(CString(pSum->m_Subject));"),
					 "ImapXferOnSameAccount merkt Datum, Absender oder Betreff nicht mehr (E-170 ohne UIDPLUS)");
		const long lBetreff = QT_Stelle(pXfer, "pTransferAction->m_saE170Betreff.Copy(saE170Betreff);");
		TT_CHECK_MSG(lBetreff >= 0 && lBetreff < QT_Stelle(pXfer, "pAccount->QueueAction(pTransferAction);"),
					 "die Merkmale gehen nicht VOR dem Einreihen an die Uebertragung (E-170 ohne UIDPLUS)");
		free(pXfer);
	}

	char* pNach = QT_Abschnitt(pQ, "void CImapTransferMsgAction::E170LabelsNachtragen()", "void CImapTransferMsgAction::SetDestAccountID(");
	if (!pNach)
		TT_Fail("E170LabelsNachtragen nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		// PRUEFER-89 K1: der Weg haengt am Zustand der Uebertragung
		TT_CHECK_MSG(QT_Enthaelt(pNach, "const E170Weg weg = E170WegWaehlen(m_pDestTocDoc != NULL, m_iState == kActionStateSucceeded, nNeu, nAlt, (int) m_dwaE170Labels.GetSize(), E170Aufsteigend_Ist(m_dwaE170AlteUIDs) != FALSE); const char *szGrund = E170WegGrund(weg);"),
					 "E170LabelsNachtragen waehlt den Weg nicht ueber E170WegWaehlen mit dem Zustand der Uebertragung - ein gescheitertes COPY wuerde vorgemerkt (PRUEFER-89 K1)");
		TT_CHECK_MSG(QT_Enthaelt(pNach, "if (weg == E170_WEG_VORMERKEN) { nVorgemerkt = E170LabelsVormerken(m_pDestTocDoc, m_dwaE170Labels, m_dwaE170Sekunden, m_saE170Von, m_saE170Betreff, &nSchonDa); } else if (weg == E170_WEG_ZUORDNEN) {"),
					 "ohne neue UIDs werden die Labels nicht mehr (oder auf einem anderen Weg) am Ziel vorgemerkt (E-170 ohne UIDPLUS)");
		TT_CHECK_MSG(QT_Zaehle(pNach, "E170LabelsVormerken(") == 1, "E170LabelsVormerken wird in E170LabelsNachtragen ein zweites Mal gerufen (PRUEFER-89 K1)");
		free(pNach);
	}
	char* pPost = QT_Abschnitt(pQ, "void CImapTransferMsgAction::DoPostProcessing()", "void CImapTransferMsgAction::E170LabelsNachtragen()");
	if (!pPost)
		TT_Fail("CImapTransferMsgAction::DoPostProcessing nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		const long lAn = QT_Stelle(pPost, "E170AbgleichAngestossen(m_pDestTocDoc);");
		const long lSync = QT_Stelle(pPost, "m_pDestTocDoc->m_pImapMailbox->DoManualResync(m_pDestTocDoc, TRUE, FALSE, FALSE);");
		TT_CHECK_MSG(lAn >= 0 && lSync > lAn && QT_Enthaelt(pPost, "{ E170AbgleichAngestossen(m_pDestTocDoc); m_pDestTocDoc->m_pImapMailbox->DoManualResync("),
					 "die Nachbearbeitung stoesst die Vormerkungen nicht unmittelbar vor dem Abgleich an (PRUEFER-89 K1, K4)");
		TT_CHECK_MSG(QT_Stelle(pPost, "E170LabelsNachtragen();") >= 0 && QT_Stelle(pPost, "E170LabelsNachtragen();") < lAn,
					 "die Vormerkungen werden erst nach dem Anstoss angelegt - sie wuerden nie verworfen (PRUEFER-89 K1)");
		free(pPost);
	}
	char* pCopy = QT_Abschnitt(pQ, "void CImapTransferMsgAction::Copy(CImapAction *pImapAction)", "bool CImapTransferMsgAction::UsesMailbox(");
	if (pCopy)
	{
		TT_CHECK_MSG(QT_Enthaelt(pCopy, "m_saE170Betreff.Copy(pQuelle->m_saE170Betreff);") && QT_Enthaelt(pCopy, "m_dwaE170Sekunden.Copy(pQuelle->m_dwaE170Sekunden);"),
					 "eine kopierte Uebertragung verliert die gemerkten Merkmale (E-170 ohne UIDPLUS)");
		free(pCopy);
	}
	else
		TT_Fail("CImapTransferMsgAction::Copy nicht gefunden - ungeprueft ist nicht gruen (E-170)");

	char* pVor = QT_Abschnitt(pToc, "int E170LabelsVormerken(", "void E170AbgleichAngestossen(");
	char* pAbg = QT_Abschnitt(pToc, "void E170NachAbgleich(", "void E170AbgleichFertig(");
	char* pFer = QT_Abschnitt(pToc, "void E170AbgleichFertig(", "CSummary *CTocDoc::GetSummaryFromUID(");
	if (!pVor || !pAbg || !pFer)
		TT_Fail("E170LabelsVormerken, E170NachAbgleich oder E170AbgleichFertig nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		// PRUEFER-89 G6: ein frueher Ausstieg am Anfang fiel nicht auf
		TT_CHECK_MSG(QT_Enthaelt(pVor, "int* pnSchonDa) { int nVorgemerkt = 0; int nSchonDa = 0; const int n = (int) dwaLabels.GetSize(); if (pZiel && n > 0 &&") &&
					 QT_Zaehle(pVor, "return") == 1,
					 "E170LabelsVormerken steigt frueh aus oder hat einen zweiten Ausgang - es wird nie vorgemerkt (PRUEFER-89 G6)");
		TT_CHECK_MSG(QT_Enthaelt(pVor, "const int nArt = E170Vormerkbar((int) dwaLabels.GetAt(i), mQuelle, pZielM, nZiel); if (nArt == E170_VM_SCHON_DA) nSchonDa++; if (nArt != E170_VM_JA) continue;"),
					 "E170LabelsVormerken entscheidet nicht ueber E170Vormerkbar - es merkt auch vor, wenn im Ziel schon eine gleich aussehende Mail steht (E-170 ohne UIDPLUS)");
		TT_CHECK_MSG(QT_Enthaelt(pVor, "p->e.pZiel = pZiel; p->e.szZiel = p->strZiel;") && QT_Enthaelt(pVor, "p->e.bAngestossen = false; s_aE170Vormerkungen.Add(p);"),
					 "eine neue Vormerkung traegt ihr Ziel nicht oder gilt schon als angestossen (PRUEFER-89 K1)");
		TT_CHECK_MSG(QT_Enthaelt(pAbg, "E170AbgleichEntscheiden(pE, nE, pToc, strZiel, pKand, nKand, ::GetTickCount(), E170_FRIST_MS, pnAkt);"),
					 "E170NachAbgleich entscheidet nicht ueber E170AbgleichEntscheiden mit der Frist E170_FRIST_MS (PRUEFER-89 G1, G2)");
		TT_CHECK_MSG(QT_Enthaelt(pAbg, "pbWeg[i] = E170NachAktionVerwerfen(pnAkt[i]);") && QT_Zaehle(pAbg, "pbWeg[i] =") == 1,
					 "E170NachAbgleich verwirft nicht nach E170NachAktionVerwerfen (PRUEFER-89 G3, G4)");
		TT_CHECK_MSG(QT_Enthaelt(pAbg, "if (pnAkt[i] >= 0) { CSummary *pSum = (CSummary *) aNeu.GetAt(pnAkt[i]); if (pSum->GetLabel() == 0) { pSum->SetLabel(p->nLabel);"),
					 "E170NachAbgleich setzt ohne eindeutige Zuordnung oder ueberschreibt ein Label (E-170 ohne UIDPLUS)");
		TT_CHECK_MSG(QT_Enthaelt(pAbg, "E170Verwerfen(pbWeg, pbVerfallen, \"frist\");"),
					 "E170NachAbgleich entfernt die verworfenen Vormerkungen nicht oder meldet den Verfall nicht (PRUEFER-89 K4)");
		TT_CHECK_MSG(QT_Enthaelt(pFer, "if (E170AbgleichEnde(pE, nE, pToc, strZiel, pbWeg) > 0) E170Verwerfen(pbWeg, pbWeg, \"ohne-treffer-im-abgleich\");"),
					 "E170AbgleichFertig verwirft die angestossenen Vormerkungen ohne Treffer nicht (PRUEFER-89 K1)");
		TT_CHECK_MSG(QT_Enthaelt(pToc, "szSpur.Format(\"E-170 Vormerkung verworfen: verfallen=%d grund=%s ziel=\\\"%s\\\"\""),
					 "beim Verwerfen fehlt die Logzeile 'E-170 Vormerkung verworfen: verfallen=' (PRUEFER-89 K4)");
		TT_CHECK_MSG(QT_Enthaelt(pToc, "void E170VormerkungenFreigeben() { for (int i = 0; i < (int) s_aE170Vormerkungen.GetSize(); i++) delete (E170Vormerkung *) s_aE170Vormerkungen.GetAt(i); s_aE170Vormerkungen.RemoveAll(); }"),
					 "E170VormerkungenFreigeben gibt die Vormerkungen nicht frei (PRUEFER-89 K5)");
	}
	if (pVor) free(pVor);
	if (pAbg) free(pAbg);
	if (pFer) free(pFer);

	char* pApp = QT_Abschnitt(pMb, "BOOL CImapMailbox::ImapAppendSumList (", "UpdateOldSummaries");
	if (!pApp)
		TT_Fail("ImapAppendSumList nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pApp, "pTocDoc->AddSum(pSum); aE170Neu.Add(pSum);"),
					 "ImapAppendSumList sammelt die neu angelegten Zusammenfassungen nicht mehr (E-170 ohne UIDPLUS)");
		const long lAbg = QT_Stelle(pApp, "E170NachAbgleich(pTocDoc, aE170Neu);");
		TT_CHECK_MSG(lAbg >= 0 && lAbg < QT_Stelle(pApp, "pTocDoc->SaveModified();"),
					 "ImapAppendSumList setzt die vorgemerkten Labels nicht vor dem Speichern (E-170 ohne UIDPLUS)");
		free(pApp);
	}
	TT_CHECK_MSG(QT_Enthaelt(pMb, "ImapAppendSumList (pTocDoc, &SumList, &RefSumList); E170AbgleichFertig(pTocDoc);"),
				 "DoFetchNewMessages beendet die angestossenen Vormerkungen nicht (PRUEFER-89 K1)");

	char* pMerge = QT_Abschnitt(pCh, "HRESULT CImapChecker::DoMergeNewTocs()", "void CImapChecker::ShowPostProcessProgress(");
	if (!pMerge)
		TT_Fail("CImapChecker::DoMergeNewTocs nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		const long lFertig = QT_Stelle(pMerge, "E170AbgleichFertig(m_pTocDoc);");
		TT_CHECK_MSG(lFertig >= 0 && lFertig > QT_Stelle(pMerge, "bResult = PostProcessSummaries();") &&
					 QT_Zaehle(pMerge, "E170AbgleichFertig(") == 1,
					 "DoMergeNewTocs beendet die angestossenen Vormerkungen nicht nach dem Abgleich (PRUEFER-89 K1)");
		free(pMerge);
	}

	char* pExit = QT_Abschnitt(pApp0, "int CEudoraApp::ExitInstance()", "return (CWinApp::ExitInstance());");
	if (!pExit)
		TT_Fail("CEudoraApp::ExitInstance nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pExit, "E170VormerkungenFreigeben();"), "ExitInstance gibt die Vormerkungen nicht frei (PRUEFER-89 K5)");
		free(pExit);
	}

	free(pToc);
	free(pQ);
	free(pMb);
	free(pCh);
	free(pApp0);
	TT_EndTest();
}

static void Test_E170_Stelle(const char* szEudoraDir)
{
	TT_BeginTest("E-170 (Quelltext): Label wird beim Verschieben im IMAP-Konto gemerkt und im Ziel gesetzt");
	char* pToc = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapToc.cpp");
	char* pQ   = QT_LiesNurCode(szEudoraDir, "..\\EuImap\\src\\ImapActionQueue.cpp");
	if (!pToc || !pQ)
	{
		TT_Fail("ImapToc.cpp oder ImapActionQueue.cpp nicht lesbar - ungeprueft ist nicht gruen");
		if (pToc) free(pToc);
		if (pQ) free(pQ);
		TT_EndTest();
		return;
	}

	// 1. Einreihen: Label je UID merken und an die Uebertragung geben
	char* pXfer = QT_Abschnitt(pToc, "CSummary* CTocDoc::ImapXferOnSameAccount(", "CSummary* CTocDoc::ImapXferBetweenAccounts(");
	if (!pXfer)
		TT_Fail("ImapXferOnSameAccount nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pXfer, "dwaE170Labels.Add((DWORD) pSum->GetLabel());"), "ImapXferOnSameAccount merkt das Label nicht mehr (E-170)");
		TT_CHECK_MSG(QT_Enthaelt(pXfer, "dwaE170AlteUIDs.Add(pSum->m_Hash);"), "ImapXferOnSameAccount merkt die alte UID nicht mehr (E-170)");
		TT_CHECK_MSG(QT_Stelle(pXfer, "pTransferAction->m_dwaE170Labels.Copy(dwaE170Labels);") >= 0 &&
					 QT_Stelle(pXfer, "pTransferAction->m_dwaE170Labels.Copy(dwaE170Labels);") < QT_Stelle(pXfer, "pAccount->QueueAction(pTransferAction);"),
					 "die gemerkten Labels gehen nicht VOR dem Einreihen an die Uebertragung (E-170)");
		free(pXfer);
	}

	// 2. Nachbearbeitung ruft das Nachtragen auf
	char* pPost = QT_Abschnitt(pQ, "void CImapTransferMsgAction::DoPostProcessing()", "void CImapTransferMsgAction::SetDestAccountID(");
	if (!pPost)
		TT_Fail("CImapTransferMsgAction::DoPostProcessing nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		const long lTransfer = QT_Stelle(pPost, "ImapTransferSummaryData(");
		const long lNach     = QT_Stelle(pPost, "E170LabelsNachtragen();");
		TT_CHECK_MSG(lNach >= 0, "DoPostProcessing traegt die Labels nicht mehr nach (E-170)");
		TT_CHECK_MSG(lNach < 0 || lTransfer < 0 || lNach > lTransfer, "E170LabelsNachtragen laeuft vor ImapTransferSummaryData - die neue Zusammenfassung steht dann noch nicht (E-170)");
		// 3. Die Zuordnung setzt nur, wo das Ziel noch kein Label hat, und nichts bei ungleicher Anzahl
		TT_CHECK_MSG(QT_Enthaelt(pPost, "if (pZiel && pZiel->GetLabel() == 0)"), "E170LabelsNachtragen ueberschreibt ein vorhandenes Label (E-170)");
		// Anzahl und Reihenfolge entscheidet E170WegWaehlen (E170Zuordnung.h), im Verhalten geprueft in Test_E170_Verwaltung
		TT_CHECK_MSG(QT_Enthaelt(pPost, "E170WegWaehlen("), "E170LabelsNachtragen waehlt den Weg nicht mehr ueber E170WegWaehlen - Anzahl und Reihenfolge ungeprueft (E-170, PRUEFER-71 K1)");
		// PRUEFER-72 K3: umgedreht ('<' statt '>=') liesse die Schranke genau
		// die gefaehrlichen Listen durch - darum den Rumpf woertlich pruefen.
		TT_CHECK_MSG(QT_Enthaelt(pQ, "static BOOL E170Aufsteigend_Ist(const CDWordArray &a) { for (int i = 1; i < a.GetSize(); i++) { if (a.GetAt(i - 1) >= a.GetAt(i)) return FALSE; } return TRUE; }"),
					 "E170Aufsteigend_Ist prueft nicht mehr 'streng aufsteigend' (E-170, PRUEFER-72 K3)");
		free(pPost);
	}

	// 4. Duplicate/Copy nimmt die Listen mit
	char* pCopy = QT_Abschnitt(pQ, "void CImapTransferMsgAction::Copy(CImapAction *pImapAction)", "bool CImapTransferMsgAction::UsesMailbox(");
	if (!pCopy)
		TT_Fail("CImapTransferMsgAction::Copy nicht gefunden - ungeprueft ist nicht gruen (E-170)");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pCopy, "m_dwaE170Labels.Copy(pQuelle->m_dwaE170Labels);"), "eine kopierte Uebertragung verliert die gemerkten Labels (E-170)");
		free(pCopy);
	}

	free(pToc);
	free(pQ);
	TT_EndTest();
}

void RunE170Tests(const char* szEudoraDir)
{
	Test_E170_Stelle(szEudoraDir);
	Test_E170_Zuordnung();
	Test_E170_Verwaltung();
	Test_E170_OhneUidplus_Stelle(szEudoraDir);
}
