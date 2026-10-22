//
// UnderTestZ2.cpp - bindet die Zeichensatz-Ansage aus TridentView.cpp ein
//
// WARUM DAS GEPRUEFT WIRD: Befund Z-2. In HTML-Nachrichten stand statt eines
// Umlauts ein Ersatzzeichen. Eudora schreibt den Rumpf in eine temporaere
// Datei und laesst MSHTML sie ueber einen Dateipfad laden - ohne BOM, ohne
// <meta charset>, ohne Codepage. MSHTML musste den Zeichensatz raten. Was
// dort steht, ist nach ISOTranslate immer Windows-1252; die Ansage sagt das
// jetzt auch. Wer sie auf "utf-8" aendert, macht 32 von 33 Zeichen kaputt
// (gemessen am 05.09.2026 an %TEMP%\eudA.htm: 33 Bytes ueber 0x7F, davon 32
// in CP1252).
//
// Die beiden Zeilen stehen als static const char in WriteTempFile. Sie
// werden geschnitten statt abgeschrieben, damit eine Aenderung an der
// Ansage hier auffaellt und nicht erst bei Gregor.
//
#include <windows.h>
#include <string.h>

#include "UnderTestZ2.h"

// Die geschnittene Region sind zwei Deklarationen, die in TridentView.cpp
// im Rumpf von WriteTempFile stehen. Hier liegen sie im Dateibereich; das
// "static" bleibt dabei richtig.
#include "generated/tridentview_z2.inc"

// --------------------------------------------------------------- Schnittstelle
#line 30 "UnderTestZ2.cpp"

const char* UT_Z2CharsetMeta(void)			{ return szCharsetMeta; }
int         UT_Z2CharsetMetaLaenge(void)	{ return (int)(sizeof(szCharsetMeta) - 1); }

const char* UT_Z2Kompatibilitaet(void)			{ return szKompatibilitaet; }
int         UT_Z2KompatibilitaetLaenge(void)	{ return (int)(sizeof(szKompatibilitaet) - 1); }
