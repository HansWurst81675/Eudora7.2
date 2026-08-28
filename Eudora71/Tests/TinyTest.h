//
// TinyTest.h - winziges Zusicherungs-Geruest fuer die Eudora-Tests
//
// Absichtlich ohne jede Fremdbibliothek: eine Handvoll Zaehler, ein Makro und
// eine Zusammenfassung. Das Testprogramm ist eine gewoehnliche Konsolenanwendung
// und liefert die Anzahl der fehlgeschlagenen Tests als Rueckgabewert.
//
#ifndef EUDORA_TESTS_TINYTEST_H
#define EUDORA_TESTS_TINYTEST_H

// Beginnt einen neuen Testabschnitt (nur Ueberschrift).
void TT_Suite(const char* szName);

// Beginnt/beendet einen einzelnen Test. TT_EndTest gibt bestanden/fehlgeschlagen aus.
void TT_BeginTest(const char* szName);
void TT_EndTest(void);

// Meldet eine Abweichung im laufenden Test. printf-Format.
void TT_Fail(const char* szFormat, ...);

// Zusatzinformation, die nur bei einem fehlgeschlagenen Test mit ausgegeben wird.
void TT_Note(const char* szFormat, ...);

// Gesamtergebnis ausgeben, liefert die Anzahl fehlgeschlagener Tests.
int TT_Summary(void);

#define TT_CHECK(cond) \
	do { if (!(cond)) TT_Fail("Bedingung falsch: %s   (Zeile %d)", #cond, __LINE__); } while (0)

#define TT_CHECK_MSG(cond, msg) \
	do { if (!(cond)) TT_Fail("%s   (Zeile %d)", (msg), __LINE__); } while (0)

#endif
