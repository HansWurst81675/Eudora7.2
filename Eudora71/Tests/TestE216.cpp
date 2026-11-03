//
// TestE216.cpp - Befund E-216: Help -> About. Die Knoepfe ueberlappten
// ("Visit Web Site" lag ueber "Copy info"), die Zeile "Mail folder from"
// war abgeschnitten, und es fehlte ein Weg zum neuesten Release auf GitHub.
//
// Gregor am 03.11.2026 (Bild an 7.2.1.130): "hier ist die darstellung noch
// nicht sehr optimal. ausserdem moechte ich den link zum github repo ->
// latest release drin haben, damit man sich bei bedarf die neueste version
// von dort direkt runterladen kann."
//
// Geprueft am Quelltext (schwaecher als ein Aufruf, siehe Quelltext.h):
//   1. IDC_ABOUT_LATEST_RELEASE in resource.h, Nummer nur einmal vergeben,
//   2. IDD_ABOUTBOX: der Knopf "Latest Release", die Herkunftszeile
//      mindestens 20 DLU hoch und oberhalb der Knopfreihe, die fuenf Knoepfe
//      in der Ressource ohne Ueberlappung,
//   3. AboutDlg.cpp: Handler im MESSAGE_MAP, Adresse .../releases/latest,
//      ShellExecuteEx ohne eigenen Windows-Dialog mit Auswertung der
//      Rueckgabe, die gemeinsame Knopfreihe mit allen fuenf Knoepfen, im
//      Startbild alle versteckt, und der alte Einzelsatz der Knoepfe weg.
// Ob sich die Knoepfe AM BILDSCHIRM ueberdecken, entscheidet die Laufzeit
// (Breite aus dem Logo) - das misst tools/messen-about.ps1, Fall E-216p.
//
#include <afx.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "TinyTest.h"
#include "Quelltext.h"

static long E216_DefineWert(const char* pRh, const char* szName)
{
	const size_t n = strlen(szName);
	for (const char* p = strstr(pRh, "#define "); p; p = strstr(p + 1, "#define "))
	{
		const char* q = p + 8;
		while (*q == ' ' || *q == '\t') q++;
		if (strncmp(q, szName, n) == 0 && (q[n] == ' ' || q[n] == '\t'))
			return strtol(q + n, NULL, 0);
	}
	return -1;
}

static int E216_WertZaehlen(const char* pRh, long lWert)
{
	int nTreffer = 0;
	for (const char* p = strstr(pRh, "#define "); p; p = strstr(p + 1, "#define "))
	{
		const char* q = p + 8;
		while (*q == ' ' || *q == '\t') q++;
		if (strncmp(q, "_APS_", 5) == 0)
			continue;	// _APS_NEXT_CONTROL_VALUE ist keine Vergabe
		while (*q && *q != ' ' && *q != '\t' && *q != '\n' && *q != '\r') q++;
		while (*q == ' ' || *q == '\t') q++;
		if (!isdigit((unsigned char) *q))
			continue;
		char* pEnde = NULL;
		const long v = strtol(q, &pEnde, 0);
		if (pEnde && (*pEnde == '\n' || *pEnde == '\r' || *pEnde == ' ' || *pEnde == '\t' || *pEnde == '\0') && v == lWert)
			nTreffer++;
	}
	return nTreffer;
}

// Liest die vier Zahlen x,y,b,h hinter "<szKennung>," in einer Ressourcenzeile.
static int E216_Rechteck(const char* pDlg, const char* szKennung, long* pX, long* pY, long* pB, long* pH)
{
	char szSuche[128];
	sprintf(szSuche, ",%s,", szKennung);
	const char* p = strstr(pDlg, szSuche);
	if (!p)
		return 0;
	p += strlen(szSuche);
	long* aZiel[4] = { pX, pY, pB, pH };
	for (int i = 0; i < 4; i++)
	{
		while (*p == ' ') p++;
		if (!isdigit((unsigned char) *p))
			return 0;
		char* pEnde = NULL;
		*aZiel[i] = strtol(p, &pEnde, 10);
		p = pEnde;
		if (i < 3)
		{
			if (*p != ',')
				return 0;
			p++;
		}
	}
	return 1;
}

static void Test_E216_Kennung(const char* szEudoraDir)
{
	TT_BeginTest("E-216 (Quelltext): IDC_ABOUT_LATEST_RELEASE in resource.h, Nummer nur einmal");
	char* pRh = QT_Lesen(szEudoraDir, "resource.h");
	if (!pRh)
	{
		TT_Fail("resource.h nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	const long v = E216_DefineWert(pRh, "IDC_ABOUT_LATEST_RELEASE");
	if (v < 0)
		TT_Fail("IDC_ABOUT_LATEST_RELEASE fehlt in resource.h");
	else
	{
		const int n = E216_WertZaehlen(pRh, v);
		if (n != 1)
			TT_Fail("IDC_ABOUT_LATEST_RELEASE = %ld ist in resource.h %d-mal vergeben", v, n);
		const long lNaechste = E216_DefineWert(pRh, "_APS_NEXT_CONTROL_VALUE");
		TT_CHECK_MSG(lNaechste > v, "_APS_NEXT_CONTROL_VALUE nicht hinter der neuen Kennung - der Ressourceneditor vergaebe sie ein zweites Mal");
	}
	free(pRh);
	TT_EndTest();
}

static void Test_E216_Ressource(const char* szEudoraDir)
{
	TT_BeginTest("E-216 (Quelltext): IDD_ABOUTBOX - Knopf Latest Release, Herkunftszeile zweizeilig, Knoepfe ohne Ueberlappung");
	char* pRc = QT_Lesen(szEudoraDir, "EudoraRes.rc");
	if (!pRc)
	{
		TT_Fail("EudoraRes.rc nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pDlg = QT_Abschnitt(pRc, "IDD_ABOUTBOX DIALOGEX", "\nEND");
	if (!pDlg)
	{
		TT_Fail("IDD_ABOUTBOX DIALOGEX nicht gefunden - ungeprueft ist nicht gruen");
		free(pRc);
		TT_EndTest();
		return;
	}
	TT_CHECK_MSG(QT_Enthaelt(pDlg, "\"Latest Release\",IDC_ABOUT_LATEST_RELEASE,"), "Knopf \"Latest Release\" fehlt in IDD_ABOUTBOX");

	long x, y, b, h;
	long lKnopfOben = -1;
	static const char* aKnoepfe[] = { "IDOK", "IDC_HYPERLINK_BTN", "IDC_ABOUT_LATEST_RELEASE", "IDC_CREDITS", "IDC_ABOUT_COPY" };
	long aL[5], aR[5], aO[5], aU[5];
	int nDa = 0;
	for (int i = 0; i < 5; i++)
	{
		if (!E216_Rechteck(pDlg, aKnoepfe[i], &x, &y, &b, &h))
		{
			TT_Fail("Knopf %s nicht in IDD_ABOUTBOX", aKnoepfe[i]);
			continue;
		}
		aL[nDa] = x; aR[nDa] = x + b; aO[nDa] = y; aU[nDa] = y + h; nDa++;
		if (lKnopfOben < 0 || y < lKnopfOben)
			lKnopfOben = y;
	}
	for (int i = 0; i < nDa; i++)
		for (int j = i + 1; j < nDa; j++)
			if (aL[i] < aR[j] && aL[j] < aR[i] && aO[i] < aU[j] && aO[j] < aU[i])
				TT_Fail("zwei Knoepfe ueberlappen in der Ressource (Nr. %d und %d)", i + 1, j + 1);

	// Die Pfadzeilen von oben nach unten. "Log:" und "Mail folder from"
	// mindestens zwei Zeilen hoch (PRUEFER-91 K1: "Log:" ist mit LogLevel
	// aus der Vorgabe breiter als der Dialog). Keine Zeile darf in die
	// naechste ragen - die Ressource hatte schon im Original 9 DLU Abstand
	// bei 10 DLU Hoehe, also 1 DLU geduldet -, und die letzte nicht in die
	// Knopfreihe.
	static const char* aZeilen[] = { "IDC_ABOUT_DATA_DIRECTORY", "IDC_ABOUT_APP_DIRECTORY", "IDC_ABOUT_INI_PATH",
									 "IDC_ABOUT_DEFAULT_INI", "IDC_ABOUT_LOG_PATH", "IDC_ABOUT_MAILDIR_FROM" };
	long lUnterkante = -1;
	for (int i = 0; i < 6; i++)
	{
		if (!E216_Rechteck(pDlg, aZeilen[i], &x, &y, &b, &h))
		{
			TT_Fail("%s nicht in IDD_ABOUTBOX", aZeilen[i]);
			continue;
		}
		if (i >= 4 && h < 20)
			TT_Fail("%s ist niedriger als zwei Zeilen (20 DLU) - der Text wird abgeschnitten", aZeilen[i]);
		if (lUnterkante >= 0 && y + 1 < lUnterkante)
			TT_Fail("%s beginnt bei %ld, die Zeile darueber endet bei %ld - sie ueberdecken sich", aZeilen[i], y, lUnterkante);
		lUnterkante = y + h;
	}
	TT_CHECK_MSG(lKnopfOben < 0 || (lUnterkante >= 0 && lUnterkante <= lKnopfOben), "die letzte Pfadzeile reicht in die Knopfreihe");
	free(pDlg);
	free(pRc);
	TT_EndTest();
}

static void Test_E216_Code(const char* szEudoraDir)
{
	TT_BeginTest("E-216 (Quelltext): AboutDlg.cpp - Handler, Adresse releases/latest, gemeinsame Knopfreihe, alter Einzelsatz weg");
	char* pC = QT_LiesNurCode(szEudoraDir, "AboutDlg.cpp");
	if (!pC)
	{
		TT_Fail("AboutDlg.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}
	char* pMap = QT_Abschnitt(pC, "BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)", "END_MESSAGE_MAP()");
	TT_CHECK_MSG(pMap && QT_Enthaelt(pMap, "ON_BN_CLICKED(IDC_ABOUT_LATEST_RELEASE, OnClickedLatestRelease)"), "Knopf Latest Release hat keinen Handler im MESSAGE_MAP");
	if (pMap) free(pMap);

	TT_CHECK_MSG(QT_Enthaelt(pC, "\"https://github.com/HansWurst81675/Eudora7.2/releases/latest\""), "Adresse https://github.com/HansWurst81675/Eudora7.2/releases/latest fehlt");

	char* pFn = QT_Abschnitt(pC, "void CAboutDlg::OnClickedLatestRelease()", "\"About: Latest Release geoeffnet %s\"");
	if (!pFn)
		TT_Fail("CAboutDlg::OnClickedLatestRelease nicht gefunden");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pFn, "sei.lpFile = kLatestReleaseURL;"), "der Handler oeffnet nicht die Release-Adresse");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "sei.fMask = SEE_MASK_FLAG_NO_UI;"), "ohne SEE_MASK_FLAG_NO_UI zeigt Windows einen eigenen Dialog und danach Eudora noch einen");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "::ShellExecuteExA(&sei)"), "kein ShellExecuteEx - die Seite geht nicht an den Standard-Browser");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "const BOOL bGut = ::ShellExecuteExA(&sei);") && QT_Enthaelt(pFn, "if (!bGut) {"), "die Rueckgabe von ShellExecuteEx wird nicht ausgewertet");
		// PRUEFER-91 K4: hInstApp ist ohne SEE_MASK_NOCLOSEPROCESS kein
		// verlaesslicher Erfolgswert - er darf nicht ueber die Meldung entscheiden.
		TT_CHECK_MSG(!QT_Enthaelt(pFn, "nErgebnis <= 32"), "hInstApp entscheidet ueber Erfolg - bei einer https:-Adresse droht eine Meldung neben dem geoeffneten Browser (PRUEFER-91 K4)");
		TT_CHECK_MSG(QT_Zaehle(pFn, "AfxMessageBox(") == 1, "im Fehlerzweig nicht genau EINE Meldung");
		TT_CHECK_MSG(QT_Enthaelt(pFn, "AfxMessageBox(strMeldung, MB_OK | MB_ICONEXCLAMATION); return; }"), "Fehlerzweig endet nicht mit return - die Erfolgs-Logzeile kaeme trotzdem");
		free(pFn);
	}

	char* pInit = QT_Abschnitt(pC, "BOOL CAboutDlg::OnInitDialog()", "return TRUE;");
	if (!pInit)
		TT_Fail("CAboutDlg::OnInitDialog nicht gefunden");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pInit, "static const UINT nKnopfReihe[] = { IDOK, IDC_HYPERLINK_BTN, IDC_ABOUT_LATEST_RELEASE, IDC_CREDITS, IDC_ABOUT_COPY };"),
					 "die gemeinsame Knopfreihe nennt nicht alle fuenf Knoepfe");
		char* pSplash = QT_Abschnitt(pInit, "if (m_IsSplash) {", "else {");
		TT_CHECK_MSG(pSplash && QT_Enthaelt(pSplash, "CWnd* pKnopf = GetDlgItem(nKnopfReihe[i]); if (pKnopf) pKnopf->ShowWindow(SW_HIDE);"),
					 "im Startbild werden die Knoepfe der Reihe nicht versteckt");
		if (pSplash) free(pSplash);
		TT_CHECK_MSG(QT_Enthaelt(pInit, "GetClientRect(&rcClient); const int nPlatz = rcClient.Width();"), "die Knopfreihe rechnet nicht aus der Dialogbreite zur Laufzeit");
		TT_CHECK_MSG(QT_Enthaelt(pInit, "nBreite = (nPlatz - (nDa + 1) * kMindestAbstand) / nDa;"), "zu schmaler Dialog: die Knoepfe werden nicht schmaler - sie ueberdeckten sich wieder");
		// PRUEFER-91 K3 G1: jeder Knopf um Breite PLUS Abstand weiter. Mit
		// "x += nAbstand;" laegen alle fuenf uebereinander - der gemeldete Fehler.
		char* pReihe = QT_Abschnitt(pInit, "int x = (nPlatz - (nDa * nBreite + (nDa - 1) * nAbstand)) / 2;", "x += nBreite + nAbstand; }");
		TT_CHECK_MSG(pReihe && QT_Enthaelt(pReihe, "pKnopf[i]->SetWindowPos(NULL, x, nOben, nBreite, nHoehe, SWP_NOACTIVATE | SWP_NOREDRAW | SWP_NOZORDER);"),
					 "die Knoepfe werden nicht nebeneinander gesetzt (Start mittig, je Breite plus Abstand weiter) - sie ueberdeckten sich (PRUEFER-91 G1)");
		if (pReihe) free(pReihe);
		// PRUEFER-91 K3 G2: die Pfadzeilen werden verbreitert, und zwar VOR
		// dem Zentrieren (CenterControl rechnet mit der Breite).
		TT_CHECK_MSG(QT_Enthaelt(pInit, "static const UINT nPfadZeilen[] = { IDC_ABOUT_DATA_DIRECTORY, IDC_ABOUT_APP_DIRECTORY, IDC_ABOUT_INI_PATH, IDC_ABOUT_DEFAULT_INI, IDC_ABOUT_LOG_PATH, IDC_ABOUT_MAILDIR_FROM };"),
					 "die Liste der zu verbreiternden Pfadzeilen ist nicht vollstaendig");
		TT_CHECK_MSG(QT_Enthaelt(pInit, "const int nBreite = rcClient.Width() - 2 * (kInsetPixels + 4);"), "die Pfadzeilen bekommen nicht die Dialogbreite");
		TT_CHECK_MSG(QT_Enthaelt(pInit, "if (!pZeile || nBreite <= 0) continue; CRect rcZeile; pZeile->GetWindowRect(&rcZeile); ScreenToClient(&rcZeile); pZeile->SetWindowPos(NULL, 0, 0, nBreite, rcZeile.Height(),"),
					 "die Pfadzeilen werden nicht verbreitert - lange Pfade sind wieder abgeschnitten (PRUEFER-91 G2)");
		const long lBreiter = QT_Stelle(pInit, "pZeile->SetWindowPos(NULL, 0, 0, nBreite, rcZeile.Height(),");
		const long lZentriert = QT_Stelle(pInit, "CenterControl(GetDlgItem(IDC_ABOUT_LOG_PATH));");
		TT_CHECK_MSG(lBreiter >= 0 && lZentriert >= 0 && lBreiter < lZentriert, "die Pfadzeilen werden erst nach dem Zentrieren verbreitert - sie stuenden dann nicht mittig");
		// Der alte Einzelsatz: jeder Knopf fuer sich, Visit Web Site mittig.
		TT_CHECK_MSG(!QT_Enthaelt(pInit, "CenterControl(GetDlgItem(IDC_HYPERLINK_BTN));"), "Visit Web Site wird wieder fuer sich mittig gesetzt - lag am 03.11.2026 ueber Copy info");
		TT_CHECK_MSG(!QT_Enthaelt(pInit, "p_button->SetWindowPos(NULL, 40, rect.top,"), "Close wieder fest auf x=40 (alter Einzelsatz)");
		TT_CHECK_MSG(!QT_Enthaelt(pInit, "pCopy->SetWindowPos(NULL, rcOk.right + 10,"), "Copy info wieder rechts neben Close (alter Einzelsatz)");
		free(pInit);
	}
	free(pC);
	TT_EndTest();
}

void RunE216Tests(const char* szEudoraDir)
{
	Test_E216_Kennung(szEudoraDir);
	Test_E216_Ressource(szEudoraDir);
	Test_E216_Code(szEudoraDir);
}
