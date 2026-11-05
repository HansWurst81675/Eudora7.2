//
// TestE222.cpp - Befund E-222: ein Klick auf das Symbol einer
// S/MIME-signierten Mail meldet "Plugin Error: %3C5335.0002%3E - Plugin no
// longer available", obwohl das Plugin geladen ist.
//
// Die Anzeige baut fuer den signierten Teil einen Verweis
// href="file://<pfad>.ems <5335.0002>" EUDORA=PLUGIN (msgutils.cpp). Beim
// Klick liefert Trident ihn prozentkodiert zurueck; CTridentView::
// DoSpecialAttachment (TridentView.cpp) wandelte nur %20 zurueck, und
// CTranslatorManager::InterpretFile (Trnslate.cpp) fand in "%3C5335.0002%3E"
// keine Kennung - moduleID und transID blieben dabei sogar unbelegt.
// Gemessen am 05.11.2026, Pruefstand C:\Temp\E222 mit geladenem SMIME.dll:
// am Bau 7.2.2.133 "kennung=kodiert", mit der Behebung laeuft das Plugin.
//
// Geprueft am Quelltext - der Weg haengt an Trident und am Plugin. Das
// Verhalten misst der Pruefstand (E-222p).
//
#include <afx.h>
#include <string.h>

#include "TinyTest.h"
#include "Quelltext.h"

static void Test_E222_KlammernZurueck(const char* szEudoraDir)
{
	TT_BeginTest("E-222: DoSpecialAttachment wandelt %3C und %3E im Plugin-Verweis zurueck");

	char* pT = QT_LiesNurCode(szEudoraDir, "TridentView.cpp");
	if (!pT)
	{
		TT_Fail("TridentView.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pF = QT_Abschnitt(pT, "BOOL CTridentView::DoSpecialAttachment(", "if (isOnDisplayPlugin)");
	if (!pF)
		TT_Fail("DoSpecialAttachment nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		// Vor der Weitergabe an das Plugin, gleich hinter %20, beide
		// Schreibweisen beider Klammern.
		TT_CHECK_MSG(QT_Enthaelt(pF,
					 "szHRef.Replace(\"%20\", \" \"); "
					 "szHRef.Replace(\"%3C\", \"<\"); szHRef.Replace(\"%3c\", \"<\"); "
					 "szHRef.Replace(\"%3E\", \">\"); szHRef.Replace(\"%3e\", \">\");"),
					 "die Plugin-Kennung kommt prozentkodiert beim Plugin an - \"Plugin no longer available\" (E-222)");
		free(pF);
	}
	free(pT);
	TT_EndTest();
}

static void Test_E222_KennungGeprueft(const char* szEudoraDir)
{
	TT_BeginTest("E-222: InterpretFile nimmt die Kennung nur, wenn sscanf beide Teile erkannt hat");

	char* pT = QT_LiesNurCode(szEudoraDir, "Trnslate.cpp");
	if (!pT)
	{
		TT_Fail("Trnslate.cpp nicht lesbar - ungeprueft ist nicht gruen");
		TT_EndTest();
		return;
	}

	char* pF = QT_Abschnitt(pT, "long CTranslatorManager::InterpretFile(", "if (mimeType.CreateMimeType(inFile))");
	if (!pF)
		TT_Fail("InterpretFile nicht gefunden - ungeprueft ist nicht gruen");
	else
	{
		TT_CHECK_MSG(QT_Enthaelt(pF,
					 "long moduleID = 0, transID = 0; "
					 "if (2 == sscanf( firstTrans, \"<%04ld.%04ld>\", &moduleID, &transID )) "
					 "trltor = GetTranslator(moduleID,transID);"),
					 "InterpretFile ruft GetTranslator mit unbelegter Kennung, wenn sscanf nichts erkennt (E-222)");
		free(pF);
	}
	free(pT);
	TT_EndTest();
}

void RunE222Tests(const char* szEudoraDir)
{
	Test_E222_KlammernZurueck(szEudoraDir);
	Test_E222_KennungGeprueft(szEudoraDir);
}
