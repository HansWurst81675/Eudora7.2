//
// Quelltext.h - liest Eudora-Quelldateien zur Laufzeit und sieht sich NUR den Code an
//
// WOFUER DAS DA IST. Nicht jede Behebung sitzt in einer Funktion, die man aus
// dem Produktivcode herausschneiden und einzeln aufrufen kann. Manche ist eine
// Zeile mitten in GetDirs, in InitInstance oder in WriteTempFile - umgeben von
// Registry, Ressourcen und Fenstern. Fuer diese Faelle prueft der Pruefstand
// die STELLE: steht die Behebung noch da, und ist der alte Stand wirklich weg?
//
// Das ist schwaecher als ein Aufruf der echten Funktion und wird im Testnamen
// auch so genannt. Es ist aber kein Papier: nimmt jemand die Behebung zurueck,
// wird der Test rot - und genau das soll ein Regressionstest leisten.
//
// WARUM NUR DER CODE. Arbeitsweise/schranke-liest-nur-code.md: in
// ImapDownload.cpp steht der ALTE, falsche Aufruf woertlich im Kommentar, der
// die Behebung begruendet. Eine Suche ueber den Rohtext wuerde ihn finden und
// die eigene Begruendung anschwaerzen. QT_LiesNurCode ersetzt deshalb jeden
// Kommentar durch Leerzeichen, bevor irgendetwas gesucht wird.
//
#ifndef EUDORA_TESTS_QUELLTEXT_H
#define EUDORA_TESTS_QUELLTEXT_H

// Liest eine Quelldatei. szRelPfad ist relativ zu Eudora71\Eudora, also etwa
// "utils.cpp" oder "..\\EuImap\\src\\ImapDownload.cpp".
// Rueckgabe: nullterminierter Puffer aus malloc, oder 0. Der Aufrufer gibt
// ihn mit free() frei.
char* QT_Lesen(const char* szEudoraDir, const char* szRelPfad);

// Wie QT_Lesen, aber alle Kommentare sind durch Leerzeichen ersetzt und
// anschliessend ist jeder Leerraum auf genau ein Leerzeichen zusammengezogen.
// Damit ist eine Suche unabhaengig davon, ob die Stelle mit Tabulatoren oder
// mit Leerzeichen eingerueckt ist und ob sie umbrochen wurde.
char* QT_LiesNurCode(const char* szEudoraDir, const char* szRelPfad);

// Entfernt Kommentare (// und /* */) aus einem Puffer an Ort und Stelle.
// Zeichenketten- und Zeichenliterale bleiben unangetastet - sonst wuerde
// "http://..." als Kommentaranfang gelesen.
void QT_KommentareRaus(char* pText);

// Leert jeden Block "#if 0" bis zum passenden #else, #elif oder #endif, an
// Ort und Stelle. PRUEFER-66 K3: stand die Behebung in "#if 0 ... #endif",
// blieben TestE72 und TestE82 gruen - in den Eudora-Quellen die uebliche Art,
// Code abzuschalten. QT_LiesNurCode ruft es nach QT_KommentareRaus auf.
void QT_IfNullRaus(char* pText);

// Zieht jeden Leerraum auf ein Leerzeichen zusammen, an Ort und Stelle.
void QT_LeerraumZusammen(char* pText);

int  QT_Enthaelt(const char* pText, const char* szSuche);
int  QT_Zaehle(const char* pText, const char* szSuche);
long QT_Stelle(const char* pText, const char* szSuche);		// -1 = nicht gefunden

// Schneidet einen Abschnitt heraus: von der Stelle, an der szVon steht, bis
// einschliesslich szBis. Rueckgabe aus malloc, oder 0, wenn eines von beiden
// fehlt oder in der falschen Reihenfolge steht.
char* QT_Abschnitt(const char* pText, const char* szVon, const char* szBis);

// Wird der Rueckgabewert JEDES Aufrufs von szAufruf verwendet? szAufruf
// schliesst die oeffnende Klammer ein, also "ISOTranslate(". Gezaehlt wird in
// *piGefunden, wie oft der Aufruf vorkommt. Rueckgabe 0, sobald ein Aufruf
// als blosse Anweisung dasteht - genau der Mangel aus NP3-9.
int QT_RueckgabeGenutzt(const char* pText, const char* szAufruf, int* piGefunden);

#endif
