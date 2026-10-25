//
// TestSpeicherfehler.cpp - Regressionstests fuer drei behobene Speicherfehler
// (E-18, E-20, E-31), alle als kritisch eingestuft.
//
// Angelegt am 24.10.2026 im Zweig fehlende_regression_tests_implementieren:
// Gregor hat den Rueckstand an Regressionstests angeordnet. E-20 wird seit
// 25.10.2026 aufgerufen (UnderTestE20.cpp, PRUEFER-50 K1). Die anderen Fehler
// sitzen an Stellen, die ohne Fenster nicht aufzurufen sind (ein
// Kopfzeilenfenster, eine Paige-Kopfdatei). Geprueft wird
// deshalb der QUELLTEXT ohne Kommentare - und jeder Fall ist gegengetestet:
// mit dem alten Stand wird er rot (Messung in der Commit-Nachricht).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"
#include "UnderTestE20.h"

// E-20: CListCtrlEx::InsertArr legte das neue Feld mit [nLen + 1] an,
// schrieb aber bis pTemp[nIdx] - und nIdx kann groesser sein als nLen
// (Gregor am 05.09.2026, als eine zweite Persoenlichkeit entstand).
//
// Seit 25.10.2026 (PRUEFER-50 K1) wird die Funktion AUFGERUFEN, nicht ihr
// Quelltext gelesen: der Quelltexttest blieb gruen mit dem alten Ueberlauf
// in anderer Schreibweise. Der Aufruf laeuft ueber UnderTestE20.cpp, das
// jedes Feld mit einem Schutzstreifen anlegt.
static void E20_Pruefe(const char* szFall, const unsigned int* pVorher, unsigned int nVorher,
					   unsigned int nDefault, unsigned int nIdx,
					   const unsigned int* pSoll, unsigned int nSoll)
{
	E20Ergebnis Erg;
	const bool bAuswertbar = E20Einfuegen(pVorher, nVorher, nDefault, nIdx, &Erg);
	TT_CHECK_MSG(bAuswertbar, szFall);
	if (!bAuswertbar)
		return;
	TT_CHECK_MSG(Erg.bStreifenHeil, "InsertArr schreibt hinter das Ende des neuen Feldes");
	TT_CHECK_MSG(Erg.nLen * sizeof(unsigned int) <= Erg.nAngefordert,
				 "nLen ist groesser als das angelegte Feld");
	TT_CHECK_MSG(Erg.nLen == nSoll, "nLen nach dem Einfuegen stimmt nicht");
	if (Erg.nLen == nSoll)
		for (unsigned int k = 0; k < nSoll; k++)
			TT_CHECK_MSG(Erg.aWerte[k] == pSoll[k],
						 "falscher Eintrag nach dem Einfuegen (0xABABABAB: hinter dem alten Feld gelesen)");
}

static void Test_E20(void)
{
	TT_BeginTest("E-20: InsertArr hinter dem Ende (nIdx > nLen) bleibt im Feld");
	const unsigned int aVorher[] = { 7, 8 };
	const unsigned int aSoll[]   = { 7, 8, 9, 9, 9, 9 };
	E20_Pruefe("Einfuegen an Index 5 bei Laenge 2 nicht auswertbar", aVorher, 2, 9, 5, aSoll, 6);
	TT_EndTest();

	TT_BeginTest("E-20: InsertArr in der Mitte und am Ende verschiebt richtig");
	const unsigned int aMitteVorher[] = { 1, 2, 3 };
	const unsigned int aMitteSoll[]   = { 1, 0, 2, 3 };
	E20_Pruefe("Einfuegen in der Mitte nicht auswertbar", aMitteVorher, 3, 0, 1, aMitteSoll, 4);
	const unsigned int aEndeSoll[]    = { 1, 2, 3, 4 };
	E20_Pruefe("Einfuegen am Ende nicht auswertbar", aMitteVorher, 3, 4, 3, aEndeSoll, 4);
	TT_EndTest();

	// Die zweite E-20-Behebung sitzt im Bildlisten-Block von NotifyInsertedCol
	// (PRUEFER-52 K2: auf den Originalstand gesetzt, blieb alles gruen).
	TT_BeginTest("E-20: NotifyInsertedCol hinter dem Feldende bleibt in allen vier Feldern");
	unsigned int aLaengen[4] = { 0, 0, 0, 0 };
	bool bHeil = false, bAusnahme = false;
	E20SpalteEinfuegen(1, 3, aLaengen, &bHeil, &bAusnahme);
	TT_CHECK_MSG(!bAusnahme, "NotifyInsertedCol wirft");
	TT_CHECK_MSG(bHeil, "NotifyInsertedCol schreibt hinter das Ende eines Spaltenfeldes");
	TT_CHECK_MSG(aLaengen[0] == 4 && aLaengen[1] == 4 && aLaengen[2] == 4 && aLaengen[3] == 4,
				 "nach dem Einfuegen an Spalte 3 haben die Felder nicht die Laenge 4");
	TT_EndTest();
}

// E-150: das Gegenstueck beim Loeschen (PRUEFER-52 K1). Im Fenster "Task
// Status" koennen die Spaltenfelder kuerzer sein als die Zahl der Spalten;
// wird eine Spalte dahinter geloescht, schrieben DeleteArr und der
// Bildlisten-Block in NotifyDeletedCol hinter das neue Feld. Eine Spalte
// ohne Eintrag hat nichts zu loeschen - das Feld bleibt, wie es ist.
static void E150_Pruefe(const char* szFall, const unsigned int* pVorher, unsigned int nVorher,
						unsigned int nIdx, const unsigned int* pSoll, unsigned int nSoll)
{
	E20Ergebnis Erg;
	const bool bAuswertbar = E150Loeschen(pVorher, nVorher, nIdx, &Erg);
	TT_CHECK_MSG(bAuswertbar, szFall);
	if (!bAuswertbar)
		return;
	TT_CHECK_MSG(!Erg.bAusnahme, "DeleteArr wirft (nLen - 1 vorzeichenlos riesig)");
	if (Erg.bAusnahme)
		return;
	TT_CHECK_MSG(Erg.bStreifenHeil, "DeleteArr schreibt hinter das Ende des Feldes");
	TT_CHECK_MSG(Erg.nLen == nSoll, "nLen nach dem Loeschen stimmt nicht");
	if (Erg.nLen == nSoll)
		for (unsigned int k = 0; k < nSoll; k++)
			TT_CHECK_MSG(Erg.aWerte[k] == pSoll[k], "falscher Eintrag nach dem Loeschen");
}

// E-99 (Datenverlust): wer einen Antwortentwurf sicherte und danach sendete,
// verlor seinen getippten Text. HasChanged() heisst "seit dem letzten
// Sichern getippt"; beim zweiten Durchlauf durch ExportMessage kam FALSE an,
// und das aufgehobene Original ueberschrieb den Text. Die Behebung ist ein
// Merker am Verfassendokument, der EINRASTET. ExportMessage ist zu gross zum
// Herausschneiden - geprueft wird deshalb der Code ohne Kommentare, an den
// drei Stellen, die zusammen das Einrasten ausmachen.
static void Test_E99(const char* szEudoraDir)
{
	TT_BeginTest("E-99: der Merker 'Anwender hat getippt' rastet ein und wird uebergeben");
	char* pPg = QT_LiesNurCode(szEudoraDir, "PgMsgView.cpp");
	char* pCd = QT_LiesNurCode(szEudoraDir, "compmsgd.cpp");
	if (!pPg || !pCd)
	{
		TT_Fail("PgMsgView.cpp oder compmsgd.cpp nicht lesbar - ungeprueft ist nicht gruen");
		free(pPg); free(pCd); TT_EndTest(); return;
	}
	QT_LeerraumZusammen(pPg);
	QT_LeerraumZusammen(pCd);
	const long lSetzen = QT_Stelle(pPg, "if ( HasChanged() ) pComp->m_bE88AnwenderHatGetippt = TRUE;");
	const long lAufruf = QT_Stelle(pPg, "E88OriginalEinsetzen(");
	TT_CHECK_MSG(lSetzen >= 0, "der Merker wird nicht mehr aus HasChanged() gesetzt");
	TT_CHECK_MSG(lAufruf >= 0, "der Aufruf E88OriginalEinsetzen ist nicht zu finden");
	TT_CHECK_MSG(lSetzen < lAufruf, "der Merker wird erst NACH E88OriginalEinsetzen gesetzt");
	TT_CHECK_MSG(QT_Enthaelt(pPg, "pComp->m_ResponseType, pComp->m_bE88AnwenderHatGetippt,"),
				 "E88OriginalEinsetzen bekommt nicht den eingerasteten Merker (etwa wieder HasChanged())");
	// Einrasten heisst: nur der Konstruktor setzt ihn zurueck.
	TT_CHECK_MSG(QT_Zaehle(pPg, "m_bE88AnwenderHatGetippt = FALSE") == 0,
				 "ExportMessage setzt den Merker zurueck - er rastet nicht mehr ein");
	TT_CHECK_MSG(QT_Zaehle(pCd, "m_bE88AnwenderHatGetippt = FALSE") == 1,
				 "der Merker wird im Verfassendokument nicht genau einmal (im Konstruktor) vorbelegt");
	free(pPg);
	free(pCd);
	TT_EndTest();
}

static void Test_E150(void)
{
	TT_BeginTest("E-150: DeleteArr in der Mitte und am Ende loescht richtig");
	const unsigned int aVier[] = { 10, 11, 12, 13 };
	const unsigned int aOhneEins[] = { 10, 12, 13 };
	E150_Pruefe("Loeschen in der Mitte nicht auswertbar", aVier, 4, 1, aOhneEins, 3);
	const unsigned int aOhneLetzte[] = { 10, 11, 12 };
	E150_Pruefe("Loeschen am Ende nicht auswertbar", aVier, 4, 3, aOhneLetzte, 3);
	TT_EndTest();

	TT_BeginTest("E-150: DeleteArr hinter dem Feldende laesst das Feld unberuehrt");
	const unsigned int aZwei[] = { 7, 8 };
	E150_Pruefe("Loeschen an Index 2 bei Laenge 2 nicht auswertbar", aZwei, 2, 2, aZwei, 2);
	E150_Pruefe("Loeschen an Index 3 bei Laenge 2 nicht auswertbar", aZwei, 2, 3, aZwei, 2);
	E150_Pruefe("Loeschen bei Laenge 0 nicht auswertbar", aZwei, 0, 0, aZwei, 0);
	TT_EndTest();

	TT_BeginTest("E-150: NotifyDeletedCol hinter dem Feldende (Task-Status-Weg)");
	// Der Weg aus PRUEFER-52 K1: Felder der Laenge 1, Spalte 1 wird geloescht.
	unsigned int aLaengen[4] = { 0, 0, 0, 0 };
	bool bHeil = false, bAusnahme = false;
	E150SpalteLoeschen(1, 1, aLaengen, &bHeil, &bAusnahme);
	TT_CHECK_MSG(!bAusnahme, "NotifyDeletedCol wirft");
	TT_CHECK_MSG(bHeil, "NotifyDeletedCol schreibt hinter das Ende eines Spaltenfeldes");
	TT_CHECK_MSG(aLaengen[0] == 1 && aLaengen[1] == 1 && aLaengen[2] == 1 && aLaengen[3] == 1,
				 "eine Spalte ohne Eintrag hat die Felder verkuerzt");
	// Gegenprobe: eine vorhandene Spalte wird weiter geloescht.
	E150SpalteLoeschen(3, 1, aLaengen, &bHeil, &bAusnahme);
	TT_CHECK_MSG(!bAusnahme && bHeil, "Loeschen einer vorhandenen Spalte beschaedigt ein Feld");
	TT_CHECK_MSG(aLaengen[0] == 2 && aLaengen[1] == 2 && aLaengen[2] == 2 && aLaengen[3] == 2,
				 "eine vorhandene Spalte wurde nicht aus allen vier Feldern geloescht");
	TT_EndTest();
}

// E-18: das Persoenlichkeitsmenue im Kopfzeilenfenster dereferenzierte pFld
// aus GetHeaderCtrl(HEADER_FROM) ohne Pruefung. Die Pruefung muss VOR dem
// ersten Zugriff stehen.
static void Test_E18(const char* szEudoraDir)
{
	TT_BeginTest("E-18: pFld wird vor dem Zugriff auf NULL geprueft");
	char* pCode = QT_LiesNurCode(szEudoraDir, "headervw.cpp");
	if (!pCode) { TT_Fail("headervw.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	const long lHolen   = QT_Stelle(pCode, "CHeaderField* pFld = GetHeaderCtrl(HEADER_FROM);");
	const long lPruefen = QT_Stelle(pCode, "if (pFld == NULL)");
	const long lZugriff = QT_Stelle(pCode, "pFld->GetLabelWindowRect(");
	TT_CHECK_MSG(lHolen >= 0, "die Stelle GetHeaderCtrl(HEADER_FROM) ist nicht zu finden");
	TT_CHECK_MSG(lZugriff >= 0, "der Zugriff pFld->GetLabelWindowRect ist nicht zu finden");
	TT_CHECK_MSG(lPruefen > lHolen && lPruefen < lZugriff,
				 "zwischen GetHeaderCtrl(HEADER_FROM) und pFld->GetLabelWindowRect steht keine Pruefung auf NULL");
	free(pCode);
	TT_EndTest();
}

// E-31: pg_time_t war time_t - unter VS2022 acht Byte statt vier. Damit lag
// jedes Feld hinter einem pg_time_t in allen Paige-Strukturen versetzt
// gegenueber der Paige32.dll von 2005. Der Typ muss fest 32 Bit breit sein.
static void Test_E31(const char* szEudoraDir)
{
	// E-27 (Strg-N beendet Eudora lautlos, 0xC00000FD in Paige32.dll) hat
	// genau diese Ursache - BEFUNDE.md: "Ursache gefunden und behoben: E-31".
	// Dieser Fall ist damit auch der Regressionstest zu E-27.
	TT_BeginTest("E-31 (Ursache von E-27): pg_time_t ist fest 32 Bit breit");
	char* pCode = QT_LiesNurCode(szEudoraDir, "..\\PaigeDLL\\PGHEADER\\CPUDEFS.H");
	if (!pCode) { TT_Fail("CPUDEFS.H nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	TT_CHECK_MSG(QT_Enthaelt(pCode, "typedef long pg_time_t;"),
				 "pg_time_t ist nicht mehr long - Paige-Strukturen verschieben sich gegenueber der DLL");
	TT_CHECK_MSG(!QT_Enthaelt(pCode, "typedef time_t pg_time_t;"),
				 "pg_time_t ist wieder time_t - unter VS2022 acht Byte breit");
	TT_CHECK_MSG(sizeof(long) == 4, "long ist auf diesem Bau nicht vier Byte breit");
	free(pCode);
	TT_EndTest();
}

// E-25: Absturz im Kontoassistenten beim Klick auf "Weiter" (0xC0000374,
// Heap beschaedigt). NSImportClass::LocateNetscapePrefsFile gab mit
// DeleteCharListTree(&FileList) den Listenknoten des AUFRUFERS frei, legte
// sich einen neuen an - FileList ist ein Zeiger nach Wert - und der Aufrufer
// LoadNSAccounts las danach freigegebenen Speicher und gab ihn ein zweites
// Mal frei. Die Behebung leert den Knoten des Aufrufers nur. Dazu im selben
// Befund: tempbuffer[128] nahm einen vollen Pfad auf.
static void Test_E25(const char* szEudoraDir)
{
	TT_BeginTest("E-25: LocateNetscapePrefsFile gibt den Knoten des Aufrufers nicht frei");
	char* pCode = QT_LiesNurCode(szEudoraDir, "..\\Importers\\NSImport\\NSImportClass.cpp");
	if (!pCode) { TT_Fail("NSImportClass.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	char* pRumpf = QT_Abschnitt(pCode, "BOOL NSImportClass::LocateNetscapePrefsFile(", "NSImportClass::GetFilesInDirectory(");
	TT_CHECK_MSG(pRumpf != NULL, "NSImportClass::LocateNetscapePrefsFile nicht gefunden");
	if (pRumpf)
	{
		TT_CHECK_MSG(!QT_Enthaelt(pRumpf, "DeleteCharListTree(&FileList);"),
					 "der Knoten des Aufrufers wird wieder freigegeben - Doppelfreigabe in LoadNSAccounts");
		// Mit fuehrendem Leerzeichen: "csPrefsFileList = DEBUG_NEW
		// CCharArrList;" steht zu Recht zweimal im Rumpf und enthaelt die
		// Zeichenkette sonst als Teilstueck (erster Lauf am 24.10.2026: rot
		// auf dem behobenen Stand).
		TT_CHECK_MSG(!QT_Enthaelt(pRumpf, " FileList = DEBUG_NEW CCharArrList;"),
					 "FileList wird wieder neu angelegt - der Aufrufer sieht den neuen Knoten nie");
		TT_CHECK_MSG(QT_Enthaelt(pRumpf, "DeleteCharListTree(&(FileList->pNext));"),
					 "der Knoten des Aufrufers wird nicht mehr geleert");
		free(pRumpf);
	}
	char* pLaden = QT_Abschnitt(pCode, "bool NSImportClass::LoadNSAccounts()", "LocateNetscapePrefsFile(csPrefsFileList);");
	TT_CHECK_MSG(pLaden != NULL && QT_Enthaelt(pLaden, "char tempbuffer[_MAX_PATH + _MAX_FNAME + _MAX_EXT];"),
				 "tempbuffer in LoadNSAccounts ist nicht mehr so gross wie ein voller Pfad");
	if (pLaden) free(pLaden);
	free(pCode);
	TT_EndTest();
}

void RunSpeicherfehlerTests(const char* szEudoraDir)
{
	TT_Suite("Speicherfehler E-18, E-20, E-25, E-31 (Regressionstests)");
	Test_E20();
	Test_E150();
	Test_E99(szEudoraDir);
	Test_E18(szEudoraDir);
	Test_E25(szEudoraDir);
	Test_E31(szEudoraDir);
}
