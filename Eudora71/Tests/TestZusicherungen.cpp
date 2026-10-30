//
// TestZusicherungen.cpp - Regressionstests zu E-15, E-19 und E-21
//
// Drei Zusicherungen aus dem Original von QUALCOMM, die auf einem NORMALEN
// Weg feuerten. Im Release-Bau ist ASSERT leer, deshalb fielen sie dort nie
// auf; im Debug-Bau stand bei Gregor am 05.09.2026 jedes Mal ein Dialog.
//
//   E-15  QCGetTaskStatusView: ASSERT(g_TaskStatusView != NULL), obwohl alle
//         drei Aufrufer ausdruecklich auf NULL abfragen.
//   E-19  CTocDoc::Read: ASSERT(0) im Zweig, der den Namen des In-Postfachs
//         REPARIERT - feuerte genau dann, wenn alles wie vorgesehen lief.
//   E-21  QCWorkerSocket::MessageWait: ASSERT(0) bei WSAEWOULDBLOCK (10035),
//         der normalen Antwort eines nicht blockierenden Sockets.
//
// Gesichert wird die STELLE (Quelltext.h, nur Code): die Zusicherung ist
// weg, und der Weg selbst ist unveraendert da.
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void PruefeOhneZusicherung(const char* szEudoraDir, const char* szTest, const char* szDatei,
								  const char* szVon, const char* szBis, const char* szWeg)
{
	TT_BeginTest(szTest);
	char* pText = QT_LiesNurCode(szEudoraDir, szDatei);
	if (!pText)
	{
		TT_Fail("%s nicht lesbar - ungeprueft ist nicht gruen", szDatei);
		TT_EndTest();
		return;
	}
	char* pAb = QT_Abschnitt(pText, szVon, szBis);
	if (!pAb)
		TT_Fail("%s: Abschnitt '%s' ... '%s' nicht gefunden - der Test passt nicht mehr zur Stelle", szDatei, szVon, szBis);
	else
	{
		// PRUEFER-67 K4: "ASSERT (" mit Leerzeichen und "_ASSERTE(" blieben
		// gruen. "ASSERT(" deckt _ASSERT( mit ab, "ASSERTE" ist ein eigenes
		// Wort. VERIFY( bleibt aussen vor: es wertet im Release-Bau aus.
		static const char* aZusicherung[] = { "ASSERT(", "ASSERT (", "ASSERTE(", "ASSERTE (" };
		for (int i = 0; i < 4; i++)
			if (QT_Enthaelt(pAb, aZusicherung[i]))
				TT_Fail("%s: im Abschnitt steht wieder eine Zusicherung ('%s') - sie feuert auf dem normalen Weg", szDatei, aZusicherung[i]);
		if (szWeg && !QT_Enthaelt(pAb, szWeg))
			TT_Fail("%s: '%s' fehlt im Abschnitt - der Weg selbst hat sich veraendert", szDatei, szWeg);
		free(pAb);
	}
	free(pText);
	TT_EndTest();
}

void RunZusicherungenTests(const char* szEudoraDir)
{
	PruefeOhneZusicherung(szEudoraDir,
		"E-15 (Quelltext): QCGetTaskStatusView sichert nicht zu, dass die Ansicht existiert",
		"TaskStatusView.cpp",
		"CTaskStatusView* QCGetTaskStatusView() {", "return g_TaskStatusView; }",
		NULL);

	PruefeOhneZusicherung(szEudoraDir,
		"E-19 (Quelltext): der Reparaturzweig fuer den Namen des In-Postfachs sichert nichts zu",
		"tocdoc.cpp",
		"m_Type = MBT_IN; if( Name().CompareNoCase( szInBoxName ) != 0 ) {", "needed_repair = TRUE; }",
		"Name() = szInBoxName; m_strTitle = szInBoxName;");

	PruefeOhneZusicherung(szEudoraDir,
		"E-21 (Quelltext): MessageWait sichert bei WSAEWOULDBLOCK nichts zu, sondern wartet weiter",
		"..\\QCSocket\\src\\QCWorkerSocket.cpp",
		"res = UNEXPECTED_CLOSE; break; } if(m_bEscapePressed) { res = -1; break; }", "else if (dwRes == WAIT_TIMEOUT)",
		NULL);
}
