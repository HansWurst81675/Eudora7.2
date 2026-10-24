//
// TestSpeicherfehler.cpp - Regressionstests fuer drei behobene Speicherfehler
// (E-18, E-20, E-31), alle als kritisch eingestuft.
//
// Angelegt am 24.10.2026 im Zweig fehlende_regression_tests_implementieren:
// Gregor hat den Rueckstand an Regressionstests angeordnet. Alle drei Fehler
// sitzen an Stellen, die ohne Fenster nicht aufzurufen sind (ein MFC-
// Listenfeld, ein Kopfzeilenfenster, eine Paige-Kopfdatei). Geprueft wird
// deshalb der QUELLTEXT ohne Kommentare - und jeder Fall ist gegengetestet:
// mit dem alten Stand wird er rot (Messung in der Commit-Nachricht).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

// E-20: CListCtrlEx::InsertArr legte das neue Feld mit [nLen + 1] an,
// schrieb aber bis pTemp[nIdx] - und nIdx kann groesser sein als nLen
// (Gregor am 05.09.2026, als eine zweite Persoenlichkeit entstand). Die
// Groesse muss das Maximum aus nIdx + 1 und nLen + 1 sein.
static void Test_E20(const char* szEudoraDir)
{
	TT_BeginTest("E-20: InsertArr legt das Feld gross genug fuer nIdx an");
	char* pCode = QT_LiesNurCode(szEudoraDir, "ListCtrlEx.cpp");
	if (!pCode) { TT_Fail("ListCtrlEx.cpp nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	char* pRumpf = QT_Abschnitt(pCode, "void CListCtrlEx::InsertArr(", "void CListCtrlEx::NotifyInsertedCol(");
	TT_CHECK_MSG(pRumpf != NULL, "CListCtrlEx::InsertArr nicht gefunden");
	if (pRumpf)
	{
		TT_CHECK_MSG(QT_Enthaelt(pRumpf, "((nIdx + 1) > (nLen + 1)) ? (nIdx + 1) : (nLen + 1)"),
					 "die Feldgroesse ist nicht mehr das Maximum aus nIdx + 1 und nLen + 1");
		TT_CHECK_MSG(!QT_Enthaelt(pRumpf, "unsigned int [nLen + 1]"),
					 "das Feld wird wieder mit [nLen + 1] angelegt - Schreiben hinter das Ende");
		free(pRumpf);
	}
	free(pCode);
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
	Test_E20(szEudoraDir);
	Test_E18(szEudoraDir);
	Test_E25(szEudoraDir);
	Test_E31(szEudoraDir);
}
