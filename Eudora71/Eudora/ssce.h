//
// ssce.h — Ersatz fuer den Header der Sentry Spelling Checker Engine
//          (Wintertree Software), den Eudora zur Rechtschreibpruefung nutzt.
//
// Der Original-Header ist nicht Teil der Quelltextfreigabe des Computer History
// Museum. Die Bibliothek selbst liegt als Lib/Debug/SSCEWD32.LIB bei und
// exportiert 22 Funktionen (SSCE_OpenSession, SSCE_CheckBlock, SSCE_Suggest ...).
// Ebenfalls fehlt spell.cpp, die Implementierung von CSpell.
//
// ACHTUNG — die Zahlenwerte unten sind PLATZHALTER, nicht die echten Werte der
// Sentry-Engine. Sie sind nur so gewaehlt, dass sie strukturell passen:
// Optionen als Bitflags, Ergebnisse und Fehler als unterscheidbare Codes.
// Solange die Rechtschreibpruefung deaktiviert ist (siehe spell.cpp), werden
// sie nie an die Bibliothek weitergereicht und sind damit unschaedlich.
//
// Wer die Rechtschreibpruefung wiederbeleben will, muss diese Werte gegen die
// Dokumentation der Sentry-Engine pruefen und ersetzen. Vorher nicht scharf
// schalten — falsche Optionsbits wuerden die Engine still falsch steuern.
//
#ifndef _SSCE_H_
#define _SSCE_H_

// --- Basistypen -----------------------------------------------------------

typedef short           S16;
typedef unsigned short  U16;
typedef long            S32;
typedef unsigned long   U32;

typedef char            SpellCheck_CHAR;

// Aufrufkonvention der Engine. Die Deklarationen in SpellDialog.h benutzen
// CALLBACK (= __stdcall) fuer die Funktionszeiger; das hier passt dazu.
#define SpellCheck_C    __stdcall
#define SpellCheck_R
#define SpellCheck_S

// --- Groessen -------------------------------------------------------------

#define SpellCheck_MAX_WORD_SZ          64
#define SpellCheck_AUTO_SEARCH_DEPTH    0

// --- Optionen (Bitflags) --------------------------------------------------

#define SpellCheck_IGNORE_ALL_CAPS_WORD_OPT     0x00000001L
#define SpellCheck_IGNORE_CAPPED_WORD_OPT       0x00000002L
#define SpellCheck_IGNORE_MIXED_CASE_OPT        0x00000004L
#define SpellCheck_IGNORE_MIXED_DIGITS_OPT      0x00000008L
#define SpellCheck_REPORT_DOUBLED_WORD_OPT      0x00000010L
#define SpellCheck_REPORT_MIXED_CASE_OPT        0x00000020L
#define SpellCheck_REPORT_SPELLING_OPT          0x00000040L
#define SpellCheck_SPLIT_CONTRACTED_WORDS_OPT   0x00000080L
#define SpellCheck_SUGGEST_PHONETIC_OPT         0x00000100L
#define SpellCheck_SUGGEST_SPLIT_WORDS_OPT      0x00000200L
#define SpellCheck_SUGGEST_TYPOGRAPHICAL_OPT    0x00000400L

// --- Ergebniscodes --------------------------------------------------------

#define SpellCheck_OK_RSLT                  0
#define SpellCheck_END_OF_BLOCK_RSLT        1
#define SpellCheck_MISSPELLED_WORD_RSLT     2
#define SpellCheck_DOUBLED_WORD_RSLT        3
#define SpellCheck_MIXED_CASE_WORD_RSLT     4
#define SpellCheck_UNCAPPED_WORD_RSLT       5
#define SpellCheck_CHANGE_WORD_RSLT         6
#define SpellCheck_SUGGEST_WORD_RSLT        7

// --- Fehlercodes ----------------------------------------------------------

#define SpellCheck_OUT_OF_MEMORY_ERR        (-1)
#define SpellCheck_BAD_BLOCK_ID_ERR         (-2)
#define SpellCheck_TOO_MANY_SESSIONS_ERR    (-3)

// --- Woerterbuchtypen -----------------------------------------------------

#define SpellCheck_IGNORE_LEX_TYPE          1
#define SpellCheck_CHANGE_LEX_TYPE          2
#define SpellCheck_SUGGEST_LEX_TYPE         3

#endif // _SSCE_H_
