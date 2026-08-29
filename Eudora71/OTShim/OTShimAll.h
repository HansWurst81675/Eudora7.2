//
// OTShimAll.h - Sammelkopfdatei der OT501-Ersatzschicht
//
// Tritt in stdafx.h an die Stelle von "secall.h". Die Reihenfolge ist wichtig:
// die Shim-Header setzen die Einbindungswaechter der Stingray-Originale
// (__SECWB_H__, __SBARCORE_H__, __SECDIB_H__ ...), damit secall.h die durch
// die Ersatzschicht abgedeckten Header anschliessend ueberspringt. Alles, was
// nicht ersetzt ist, kommt weiterhin im Original aus OT501/Include.
//
// Nur eine Zeile in stdafx.h zu aendern hat einen zweiten Grund: die Quellen
// haben gemischte Zeilenenden, und der pre-commit-Hook tools/pruefe-bytes.pl
// weist jede Aenderung der CR-Anzahl ab. Eine Sammeldatei kommt ohne
// eingefuegte Zeilen aus.
//
#ifndef __OTSHIMALL_H__
#define __OTSHIMALL_H__

#include "OTShim.h"        // Stufe 0-2: Workbook, MDI, Statusleiste, Andockfamilie
#include "OTShim_Bild.h"   // Stufe 4: SECImage, SECDib, SECJpeg ueber GDI+

//
// Waechter, die die Shim-Header selbst noch nicht setzen. Ohne sie zieht
// secall.h das Stingray-Original nach und der Uebersetzer sieht zwei
// Definitionen derselben Klasse:
//
//   sbarstat.h  -> SECStatusBar   (in OTShim.h als typedef auf CStatusBar)
//   sectod.h    -> SECTipOfDay    (in OTShim.h nachgebaut)
//   secbtns.h   -> SECLoadSysColorBitmap und die Knopfklassen
//
// Sobald die Shim-Header diese Waechter selbst setzen, koennen die Zeilen hier
// entfallen - sie schaden dann nicht, sind aber ueberfluessig.
//
#ifndef __SBARSTAT_H__
#define __SBARSTAT_H__
#endif
#ifndef __SECTOD_H__
#define __SECTOD_H__
#endif
// #ifndef __SECBTNS_H__  -- erst setzen, wenn Stufe 3 (Knoepfe) geliefert ist
// #define __SECBTNS_H__
// #endif

#include "secall.h"        // der Rest im Original

#endif // __OTSHIMALL_H__
