//
// OTShimAll.h - Sammelkopfdatei der OT501-Ersatzschicht
//
// Tritt in stdafx.h an die Stelle von "secall.h". Die Reihenfolge ist wichtig:
// die Shim-Header setzen die Einbindungswaechter der Stingray-Originale, damit
// secall.h die ersetzten Header anschliessend ueberspringt. Alles, was nicht
// ersetzt ist, kommt weiterhin im Original aus OT501/Include.
//
#ifndef __OTSHIMALL_H__
#define __OTSHIMALL_H__

// Stufe 0-2: Workbook, MDI, Statusleiste, Andockfamilie.
// Muss zuerst kommen - die spaeteren Stufen bauen auf SECControlBar und
// SECControlBarManager auf.
#include "OTShim.h"

// Stufe 3: Werkzeugleisten, Knoepfe, Anpassungsdialog.
// Enthaelt ausserdem CSafetyPalette und CPaletteDC: SafetyPal.h deklariert beide,
// eine Implementierung gibt es in der Freigabe nirgends, und SECBtnDrawData haelt
// drei CPaletteDC als Wertfelder. Fachlich gehoeren sie nicht hierher - sie stehen
// hier, weil Stufe 3 sonst nicht bindbar war.
#include "OTShim_Werkzeugleiste.h"

// Registerkarten der Wazoo-Leisten. Setzt __TABCTRLB_H__, __TABWNDB_H__,
// __TABCTRL3_H__, __TABWND3_H__ selbst; tabctrl.h/tabwnd.h bleiben im Original,
// weil sie die TWS_*-Konstanten liefern.
#include "OTShim_Reiter.h"

// SECDateTimeCtrl auf MFCs CDateTimeCtrl. Setzt __SECDATET_H__, __DTCTRL_H__ und
// __DTGADGET_H__ selbst.
#include "OTShim_Palette.h"

// Stufe 4: SECImage, SECDib, SECJpeg ueber GDI+.
#include "OTShim_Bild.h"

//
// Waechter, die die Shim-Header selbst nicht setzen. Ohne sie zieht secall.h das
// Stingray-Original nach, und der Uebersetzer sieht zwei Definitionen derselben
// Klasse:
//
//   sbarstat.h -> SECStatusBar (in OTShim.h ein typedef auf CStatusBar)
//   sectod.h   -> SECTipOfDay  (in OTShim.h nachgebaut)
//   secbtns.h  -> SECLoadSysColorBitmap; das Original deklariert das
//                 Standardargument ein zweites Mal (C2572). Stufe 3 ersetzt die
//                 Knopfklassen, also darf das Original weichen.
//
#ifndef __SBARSTAT_H__
#define __SBARSTAT_H__
#endif
#ifndef __SECTOD_H__
#define __SECTOD_H__
#endif
// #ifndef __SECBTNS_H__  -- NICHT setzen: secbtns.h liefert SECBitmapButton, das Stufe 3 nicht ersetzt (sonst 102 Fehler)
// #define __SECBTNS_H__
// #endif

#include "secall.h"        // der Rest im Original

#endif // __OTSHIMALL_H__
