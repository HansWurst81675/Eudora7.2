// OTShim_Spur.cpp - Ersatz fuer die vier Ablaufverfolgungsfunktionen aus
//                   OT501/Include/TraceFile.h
//
// TraceFile.h deklariert unter _DEBUG vier freie Funktionen (Zeile 8-11):
//
//     void DMsg(LPCSTR s);
//     void TraceStart(void);
//     void TraceMsg(LPSTR string);
//     void GetTextFromFile(LPCSTR filename, CString& c);
//
// Im Nicht-Debug-Bau sind alle vier leere Makros (TraceFile.h:12-16), dann
// wird hier nichts gebraucht. Deshalb steht der gesamte Inhalt unter _DEBUG.
//
// WARUM DIESE DATEI: die Umsetzung fehlt in der Freigabe vollstaendig.
// Gemessen mit einer Volltextsuche ueber alle .c/.cpp/.h des Baums: die
// einzigen Treffer auf TraceStart sind die Deklaration (TraceFile.h:9) und
// der eine Aufruf (EudoraExe.cpp:44). Der Rumpf lag in OTA50D.LIB, die diese
// Ersatzschicht ersetzt.
//
// AUFRUFSTELLEN
//   TraceStart        EudoraExe.cpp:44, im Konstruktor von CEudoraModule,
//                     selbst noch einmal in #ifdef _DEBUG geklammert.
//   DMsg, TraceMsg, GetTextFromFile
//                     keine. Gemessen: kein einziger Aufruf im Baum. Sie
//                     stehen hier trotzdem mit Rumpf statt zu fehlen, damit
//                     die Oberflaeche der Kopfdatei vollstaendig bedient ist
//                     und ein spaeterer Aufruf nicht am Linker scheitert.
//
// UNGEPRUEFT: was das Original tat, ist nicht belegbar. Der Name legt eine
// Protokolldatei nahe, belegen laesst sich das nicht - es gibt weder eine
// Implementierung noch einen Kommentar dazu. Diese Fassung schreibt in die
// Debugausgabe (OutputDebugString). Das ist im Debugger sichtbar, legt keine
// Dateien an und hat keine Nebenwirkungen; falls der Originalzweck spaeter
// auftaucht, ist hier genau eine Stelle zu aendern.
//
// UEBERSETZUNG: bindet <afxwin.h> selbst ein und benutzt Eudoras
// vorkompilierten Kopf nicht - in Eudora.vcxproj daher mit
// PrecompiledHeader "NotUsing", wie die uebrigen OTShim-Dateien.
//
// Kodierung: reines ASCII, kein BOM. Zeilenenden CRLF.

#ifdef WINVER
#undef WINVER
#endif
#define WINVER 0x0501
#ifdef _WIN32_WINNT
#undef _WIN32_WINNT
#endif
#define _WIN32_WINNT 0x0501

#include <afxwin.h>

#ifdef _DEBUG

#include "TraceFile.h"


// Schreibt eine Zeile in die Debugausgabe. Ein NULL-Zeiger ist zulaessig -
// die Kopfdatei sagt nichts dazu, und ein Absturz in der Ablaufverfolgung
// waere das falsche Verhalten.
static void OTShimSpurZeile(LPCSTR lpsz)
{
	CStringA strZeile("Eudora-Spur: ");
	strZeile += (lpsz != NULL) ? lpsz : "(NULL)";
	strZeile += "\r\n";
	::OutputDebugStringA(strZeile);
}


void DMsg(LPCSTR s)
{
	OTShimSpurZeile(s);
}


void TraceMsg(LPSTR string)
{
	OTShimSpurZeile(string);
}


void TraceStart(void)
{
	// Einmal je Programmlauf. Der Aufruf steht im Konstruktor von
	// CEudoraModule, also vor allem anderen.
	OTShimSpurZeile("TraceStart - Ablaufverfolgung beginnt");
}


// Liest eine Datei vollstaendig als Text ein. Bei jedem Fehler bleibt c leer;
// die Kopfdatei kennt keinen Rueckgabewert, ueber den sich ein Fehler melden
// liesse.
void GetTextFromFile(LPCSTR filename, CString& c)
{
	c.Empty();

	if (filename == NULL)
		return;

	CFile datei;
	if (!datei.Open(CString(filename), CFile::modeRead | CFile::shareDenyNone))
		return;

	ULONGLONG ullLaenge = datei.GetLength();

	// Ablaufverfolgungsdateien sind klein. Alles darueber waere ein Irrtum
	// und soll nicht stillschweigend Hauptspeicher belegen.
	const ULONGLONG ullObergrenze = 1024 * 1024;
	if (ullLaenge == 0 || ullLaenge > ullObergrenze)
		return;

	UINT nLaenge = (UINT) ullLaenge;

	CStringA strRoh;
	char* pPuffer = strRoh.GetBuffer(nLaenge + 1);
	if (pPuffer == NULL)
		return;

	UINT nGelesen = datei.Read(pPuffer, nLaenge);
	pPuffer[nGelesen] = '\0';
	strRoh.ReleaseBuffer(nGelesen);

	c = CString(strRoh);
}

#endif // _DEBUG
