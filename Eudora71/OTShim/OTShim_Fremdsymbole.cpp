// OTShim_Fremdsymbole.cpp - Symbole, die beim Linken von Eudora.exe fehlen und
//                           NICHT aus dem Stingray Objective Toolkit stammen
//
// Diese Datei gehoert fachlich nicht zur OT501-Ersatzschicht. Sie liegt hier,
// weil sie denselben Zweck erfuellt - Eudora.exe zum Linken bringen - und weil
// es sonst keinen Ort dafuer gaebe. Jeder Block sagt, wann er wieder
// verschwinden kann.
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
// 1. ATL::CImage::s_cache und ATL::CImage::s_initGDIPlus
//
// GEMESSEN (Link von Eudora.exe, Debug/x86, Commit 78a9c10):
//
//   QCGraphics.obj : error LNK2001: nicht aufgeloestes externes Symbol
//     "private: static class ATL::CImage::CInitGDIPlus ATL::CImage::s_initGDIPlus"
//   QCGraphics.obj : error LNK2001: nicht aufgeloestes externes Symbol
//     "private: static class ATL::CImage::CDCCache ATL::CImage::s_cache"
//
// URSACHE: Eudora benutzt nicht den atlimage.h des Werkzeugkastens, sondern
// eine eigene Kopie unter Eudora/atlimage.h (eingebunden von QCGraphics.cpp:27,
// mit Anfuehrungszeichen, die Kopie gewinnt also). Diese Kopie stammt aus einer
// aelteren ATL: sie deklariert die beiden statischen Felder
// (atlimage.h:242 und :272), definiert sie aber nirgends. Die alte ATL hatte
// dafuer am Dateiende zwei Zeilen mit __declspec(selectany); in der Kopie
// fehlen sie. Der atlimage.h von v143 kennt beide Felder gar nicht mehr -
// dort ist die GDI+-Initialisierung anders geloest.
//
// WARUM HIER UND NICHT IM HEADER: Eudora/atlimage.h wird von einem anderen
// Agenten bearbeitet; ein Kommentar dort (atlimage.h:1537) kuendigt den Wechsel
// auf den SDK-eigenen atlimage.h an. Eine Aenderung im Header waere also
// doppelte Arbeit. Eine Definition in genau einer Uebersetzungseinheit tut
// dasselbe und ist an einer Stelle wieder zu entfernen.
//
// DIESER BLOCK MUSS WEG, sobald Eudora auf den atlimage.h des Werkzeugkastens
// wechselt - dann uebersetzt er nicht mehr, weil es die Felder nicht mehr gibt.
//
// Zugriffsschutz: s_cache und s_initGDIPlus sind private. Die Definition eines
// statischen Datenfeldes ausserhalb der Klasse unterliegt der Zugriffspruefung
// nicht (C++, [class.access]); das ist erlaubt und uebersetzt.

// Ausdruecklich mit Pfad: fuer #include "..." sucht der Uebersetzer zuerst im
// Verzeichnis der einbindenden Datei, also in OTShim - und dort liegt kein
// atlimage.h. Gemeint ist die Kopie neben den Eudora-Quellen.
#include "../Eudora/atlimage.h"

namespace ATL
{
	CImage::CDCCache     CImage::s_cache;
	CImage::CInitGDIPlus CImage::s_initGDIPlus;
}


/////////////////////////////////////////////////////////////////////////////
// 2. CVoiceText::Init und CVoiceText::Speak (SpeechSDK)
//
// GEMESSEN (derselbe Link):
//
//   TextToSpeech.obj : error LNK2019: nicht aufgeloestes externes Symbol
//     ?Init@CVoiceText@@QAEJPB_WPAUIVTxtNotifySinkW@@0KPAUVTSITEINFO@@@Z
//   TextToSpeech.obj : error LNK2019: nicht aufgeloestes externes Symbol
//     ?Speak@CVoiceText@@QAEJPB_WK0@Z
//
// URSACHE, gemessen mit dumpbin /SYMBOLS auf SpeechSDK/Lib/spchwrap.lib:
// die Bibliothek enthaelt beide Funktionen, aber unter anderem Namen -
//
//     ?Init@CVoiceText@@QAEJPBGPAUIVTxtNotifySinkW@@0KPAUVTSITEINFO@@@Z
//     ?Speak@CVoiceText@@QAEJPBGK0@Z
//
// "PBG" statt "PB_W": die Bibliothek wurde uebersetzt, als wchar_t noch ein
// typedef auf unsigned short war (heute /Zc:wchar_t-). Seit VS2005 ist wchar_t
// ein eigener Typ, deshalb dekoriert der Uebersetzer PB_W. Aufrufkonvention,
// Argumentanzahl und Bitbreite sind identisch - wchar_t und unsigned short
// sind auf Windows beide 16 Bit. Es unterscheidet sich nur der Name.
//
// WARUM NICHT /Zc:wchar_t- FUER DAS GANZE PROJEKT: dann passte Eudora nicht
// mehr zu MFC 14.38, das mit dem eingebauten wchar_t gebaut ist. Warum nicht
// nur fuer TextToSpeech.cpp: die Datei benutzt CString und andere MFC-Klassen,
// deren Namen dann ebenfalls anders dekoriert wuerden.
//
// LOESUNG: /alternatename bindet den gesuchten Namen an den vorhandenen.
// Der Linker benutzt das nur, wenn der erste Name sonst ungeloest bliebe.
//
// DIESER BLOCK MUSS WEG, sobald spchwrap.lib neu uebersetzt wird oder die
// Sprachausgabe auf SAPI 5 umgestellt ist.

#pragma comment(linker, "/alternatename:?Init@CVoiceText@@QAEJPB_WPAUIVTxtNotifySinkW@@0KPAUVTSITEINFO@@@Z=?Init@CVoiceText@@QAEJPBGPAUIVTxtNotifySinkW@@0KPAUVTSITEINFO@@@Z")
#pragma comment(linker, "/alternatename:?Speak@CVoiceText@@QAEJPB_WK0@Z=?Speak@CVoiceText@@QAEJPBGK0@Z")
