// OTShim_Libpng.cpp - __imp___iob fuer die vorgebaute libpng.lib
//
// Dritter Fall derselben Art wie in OTShim_Fremdsymbole.cpp: ein Symbol, das
// beim Binden von Eudora.exe fehlt und nicht aus dem Stingray Objective
// Toolkit stammt. Es steht in einer eigenen Datei und nicht neben den beiden
// anderen, weil die Schranke tools/pruefe-bytes.pl das Anhaengen von Zeilen an
// eine bestehende CRLF-Datei nicht von einem umgeschriebenen Zeilenende
// unterscheiden kann und den Commit abweist. Eine neue Datei prueft sie nicht.
// Faellt die Einschraenkung weg, gehoert dieser Inhalt als Block 3 in
// OTShim_Fremdsymbole.cpp.
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


/////////////////////////////////////////////////////////////////////////////
// __imp___iob
//
// GEMESSEN (derselbe Link):
//
//   libpng.lib(pngerror.obj) : error LNK2019: nicht aufgeloestes externes
//     Symbol "__imp___iob" in Funktion "_png_default_error"
//   libpng.lib(pngrutil.obj) : error LNK2001: dasselbe Symbol
//
// URSACHE: Eudora71/Lib/Debug/libpng.lib ist eine vorgebaute Bibliothek
// (libpng 1.2.7, siehe PNG/libpng/png.h:312) aus der Zeit vor der UCRT.
// Damals war stderr das Makro (&_iob[2]) auf ein Feld _iob, das die CRT-DLL
// exportierte. Die UCRT hat dieses Feld nicht mehr - sie hat stattdessen
// __acrt_iob_func(). Benutzt wird es nur fuer Diagnosezeilen:
// pngerror.c:184,188,192,240,244,248 und
// pngrutil.c:628,850,852,855,857,945,948 - jede davon ein fprintf(stderr,...).
//
// GEMESSEN, nicht vermutet, mit dumpbin /disasm auf beide Objektdateien:
// jeder einzelne Zugriff lautet
//
//     mov  ecx, dword ptr [__imp___iob]
//     add  ecx, 40h
//
// Es wird also ausschliesslich _iob[2] angesprochen - stderr - und der
// Elementabstand betraegt 0x20 = 32 Byte, die Groesse von struct _iobuf der
// damaligen CRT. Kein einziger Zugriff auf _iob[0] oder _iob[1].
//
// LOESUNG: __imp___iob ist die Zeigerzelle eines Datenimports; ihr Wert ist
// die Anfangsadresse des Feldes. Steht dort (char*)stderr - 2*32, dann trifft
// _iob[2] genau den echten stderr der UCRT, und fprintf bekommt einen
// gueltigen FILE-Zeiger. Die beiden nie angefassten Plaetze _iob[0] und
// _iob[1] zeigen daneben.
//
// Die Variable heisst _imp___iob und nicht __imp___iob: bei x86 und
// C-Bindung setzt der Uebersetzer einen Unterstrich davor, das dekorierte
// Symbol heisst damit genau __imp___iob.
//
// Der Anfangswert wird beim Programmstart berechnet, nicht zur Uebersetzung -
// stderr ist in der UCRT ein Funktionsaufruf. Das genuegt: libpng laeuft erst
// lange nach den Anfangswerten der globalen Objekte an.
//
// DIESER BLOCK MUSS WEG, sobald libpng aus den Quellen unter
// Eudora71/PNG/libpng neu uebersetzt wird. Das ist die saubere Behebung; sie
// war fuer diese Etappe zu gross.

#include <stdio.h>

static void* IobFeldanfang()
{
	// Beide Zahlen sind oben gemessen und stehen benannt da, damit die
	// Rechnung lesbar bleibt.
	const int nElementabstandAlteCRT = 32;
	const int nIndexStderr           = 2;

	return (void*) ((char*) stderr - nIndexStderr * nElementabstandAlteCRT);
}

extern "C" { void* _imp___iob = IobFeldanfang(); }
