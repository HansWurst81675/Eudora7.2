//
// TestE119.cpp - Regressionstest zu Befund E-119, zweiter Teil
//
// Ein Bild, das als data:-Adresse im HTML steckt, wird beim Antworten und
// Weiterleiten in eine Datei unter Embedded dekodiert (E119DataNachDatei,
// PGHTMIMP.CPP). Gregor am Testpaket 7.2.0.123 (26.10.2026): das Bild in der
// Antwort war eine gruene Flaeche mit Streifen. Gemessen: laenge=5343, 3990
// Byte JPEG ohne Endmarke. Ursache: GetNextToken zaehlt die Zeichen eines
// Attributwerts in arg_size, einem pg_short_t (16 Bit, CPUDEFS.H); ab 65536
// Zeichen laeuft die Zahl ueber. Seitdem misst ProcessAttributes die Laenge
// eines data:-Werts selbst und reicht diese weiter.
//
// Geprueft wird der Quelltext ohne Kommentare. Am Verhalten misst es der
// Pruefstandsfall E-119e (Testdaten/e119-grosses-data-bild.eml).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

void RunE119Tests(const char* szEudoraDir)
{
	TT_BeginTest("E-119: ein data:-Bild ueber 64 KB kommt mit seiner vollen Laenge an");
	char* pCode = QT_LiesNurCode(szEudoraDir, "PGHTMIMP.CPP");
	if (!pCode) { TT_Fail("PGHTMIMP.CPP nicht lesbar - ungeprueft ist nicht gruen"); TT_EndTest(); return; }
	QT_LeerraumZusammen(pCode);

	char* pRumpf = QT_Abschnitt(pCode, "void PaigeHTMLImportFilter::ProcessAttributes (", "void PaigeHTMLImportFilter::InsertTokenChar (");
	TT_CHECK_MSG(pRumpf != NULL, "ProcessAttributes nicht gefunden");
	if (pRumpf)
	{
		const long lMessen = QT_Stelle(pRumpf, "const char* pE119Ende = strchr((const char*)command, (int)cEnde);");
		const long lRuf    = QT_Stelle(pRumpf, "if (E119DataNachDatei((const char*)command, nE119Laenge, szE119Datei, sizeof(szE119Datei))) {");
		TT_CHECK_MSG(lMessen >= 0, "die Laenge des data:-Werts wird nicht selbst gemessen - arg_size laeuft ab 65536 ueber");
		TT_CHECK_MSG(lRuf > lMessen, "E119DataNachDatei bekommt nicht die selbst gemessene Laenge");
		TT_CHECK_MSG(!QT_Enthaelt(pRumpf, "E119DataNachDatei((const char*)command, (long)arg_size,"),
					 "E119DataNachDatei bekommt wieder den 16-Bit-Zaehler arg_size");
		free(pRumpf);
	}
	free(pCode);
	TT_EndTest();
}
