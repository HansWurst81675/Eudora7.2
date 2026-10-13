# <a id="lektor-17"></a>LEKTOR-17 — Dokumentation nach dem Merge von AN-2 (bis `c4988b3`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Eingearbeitet** in `an1-endungen`: [L-17.6](#l-17.6) (CHANGELOG-Kopf [AN-1](../BEFUNDE.md#an-1)/[AN-2](../BEFUNDE.md#an-2)), die B5-Überschrift aus [L-17.4](#l-17.4), 1.0.82 in PAKETE als gebaut ([L-17.3](#l-17.3)). ~~**Offen:** der Rest von [L-17.1](#l-17.1) bis [L-17.8](#l-17.8) und die offenen L-16-Funde.~~ **Stand 12.10.2026: eingearbeitet in [LEKTOR-20](LEKTOR-20.md)**, bis auf [L-17.8](#l-17.8) (Werkzeug) und die dort als offen genannten Reste.


Lauf am 12.10.2026, nur lesend. Ich habe keine Datei im Repo geändert, keinen git-Befehl mit Schreibwirkung abgesetzt, nichts gebaut und nichts gestartet.
Zusätzlich gelesen habe ich `C:\Temp\AN3` und `C:\Temp\AN4` (`Mailverzeichnis\attach`, `Mailverzeichnis\eudora.log`).

## Umfang

`git diff --name-only 4ec9dd1 HEAD -- '*.md'` ergibt **20 Dateien**:
AUFGABEN.md, Arbeitsweise/{LEHREN-AUS-DEM-CHAT, MEMORY, README, anzeige-ist-kein-zustand,
daueraufgaben-brauchen-einen-takt, erfolg-aus-anwendersicht, fertige-fassung-bereitstellen,
messung-muss-den-weg-treffen}.md, BEFUNDE.md, CHANGELOG.md, README.md, Releases/PAKETE.md,
WEITERMACHEN.md, ZIEL.md, tools/AGENTEN-LAUFEN.md, tools/TESTLAEUFE.md, tools/WERKZEUGE.md,
tools/ZWEIGE.md, tools/pruefdaten/LIESMICH.md.
Von Hand geprüft habe ich alle Dateien außer `Arbeitsweise/`. Dazu kommt PORTIERUNG.md, wie im Auftrag verlangt.
Die Schwerpunkte waren die Versionsnummern, der Messstand von [AN-1](../BEFUNDE.md#an-1) und der Rest aus [LEKTOR-16](LEKTOR-16.md#lektor-16).

## Der Maßstab, gemessen

| Frage | Messung | Ergebnis |
|---|---|---|
| Quellstand | `Eudora71/Version.h:14` | **7.2.0.82** |
| Paketnummer | `VERSION` | **1.0.82** |
| Lauf AN3 | Kopf `C:\Temp\AN3\Mailverzeichnis\eudora.log` | `Version 7.2.0.81`, `LogLevel 91295 (0x1649F)` |
| Lauf AN4 | Kopf `C:\Temp\AN4\...\eudora.log` | `Version 7.2.0.82`, `LogLevel 91295 (0x1649F)` |
| Anhänge AN3 = AN4 | `ls attach` | sechs Dateien, Längen 224 / 56 / 57 / 76 / 34 / 12, **alle mit `.pdf`**: `<220×A>.pdf`, `…Musterstadt 2025.pdf`, `…Musterstadt 20251.pdf`, `…Abrechnungszeitraum 2025.pdf`, `Pruefung AN-1 leerer Dateiname.pdf`, `Rechnung.pdf` |
| Marke 5 | `grep -a -c` | je **6** × „nach MIMEMap::SetExtension“, **0** × „kennt den Typ NICHT“ |
| `Exception.log` | `ls` | in keinem der beiden Verzeichnisse |
| Starts | `tools/TESTLAEUFE.md:86-88` | AN2 `1.0.80+ca8da5a*`, AN3 `1.0.81+123b218*`, AN4 `1.0.82+9113007*` — **alle drei mit Stern** |
| Maske | `QCUtils/public/inc/debug.h:44` | `DEBUG_MASK_ATTACH = 0x10000` |

**Ergebnis:** Die neuen Kernzeilen stimmen mit dem Bestand überein: CHANGELOG 7.2.0.82 (:71-85) und 7.2.0.81 (:87-124), BEFUNDE.md:177 und der neue Kasten :7869-7894, WEITERMACHEN:9-10, AUFGABEN:3 und der Kasten :452-462, PAKETE 1.0.82, 1.0.81 und 1.0.80-an1 sowie LIESMICH:13-20.
**Keine Stelle behauptet, [AN-2](../BEFUNDE.md#an-2) sei am laufenden Programm gemessen.** CHANGELOG.md:84-85 sagt ausdrücklich das Gegenteil.
Die Mängel sitzen wie bei L-16 in den **älteren Stellen**. Dazu kommt eine neue Klasse: AN-2-Doku, die für 7.2.0.80 stimmt, aber den Stand „mit 7.2.0.82 übersetzt“ nirgends trägt.

---

## Die Funde

### <a id="l-17.1"></a>L-17.1 — AN-2: fast überall „nicht übersetzt“, der Stand 7.2.0.82 fehlt

Für 7.2.0.80 ist „nicht übersetzt“ richtig. Ein Leser, der bei [AN-2](../BEFUNDE.md#an-2) einsteigt, erfährt aber nicht, dass 7.2.0.82 es enthält und übersetzt ist.
Ebenso wenig erfährt er, dass es trotzdem **nicht am Programm gemessen** ist.
Nur zwei Stellen nennen 7.2.0.82: CHANGELOG.md:73-85 (richtig und vollständig) und WEITERMACHEN.md:10.

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| AUFGABEN.md:641 | B6-Überschrift *„geändert in 7.2.0.80, **nicht übersetzt**“* | übersetzt in 7.2.0.82, Rebuild 0 Fehler, 185/185 | „geändert in 7.2.0.80, **übersetzt in 7.2.0.82**, am laufenden Programm nicht gemessen“ |
| AUFGABEN.md:655 | B6-Tabelle *„Nicht gemessen \| nichts ist übersetzt.“* | übersetzt (7.2.0.82) | „übersetzt in 7.2.0.82; dass es im Werbefenster wirkt, ist nicht belegt — der Prüfstand löst den Fall nicht aus“ |
| CHANGELOG.md:17 | „Noch offen“, [AN-2](../BEFUNDE.md#an-2): *„Anzeige behoben in 7.2.0.80, **nicht übersetzt**“* | wie oben | „behoben in 7.2.0.80, übersetzt mit 7.2.0.82, am Programm nicht gemessen“ |
| BEFUNDE.md:178 | AN-2-Zeile: *„Behebung eingespielt, **nicht übersetzt**“* | wie oben | ebenso |
| BEFUNDE.md:8494 | *„**Status: Ursache am Quelltext belegt, Behebung eingespielt, nicht übersetzt.**“* | wie oben | Status nachziehen. Bei :8554 *„Nichts ist übersetzt. Die Sitzung lief ohne Windows …“* „Stand 7.2.0.80; übersetzt mit 7.2.0.82“ dazuschreiben |
| README.md:161 | *„**Die Anzeige ist in 7.2.0.80 geändert, aber nicht übersetzt.**“* | wie oben | „… in 7.2.0.80 geändert, mit 7.2.0.82 übersetzt, am laufenden Programm noch nicht gesehen“ |
| ZIEL.md:17 | *„Quellstand ist jetzt **7.2.0.80** … [AN-1](../BEFUNDE.md#an-1) … und [AN-2](../BEFUNDE.md#an-2) …, **aber nicht übersetzt**“* | Quellstand 7.2.0.82, gebaut | siehe [L-17.3](#l-17.3) |
| Releases/PAKETE.md:209-213 | 1.0.80 ([AN-2](../BEFUNDE.md#an-2)): *„**übersetzt ist nichts**“* | für 1.0.80 richtig | „übersetzt erst als Teil von 7.2.0.82 (siehe 1.0.82)“ anhängen |
| WEITERMACHEN.md:10 | *„[AN-2](../BEFUNDE.md#an-2) … gemessen mit `tools/html-tags-pruefen.pl`, 30 Fälle; mit 7.2.0.82 zum ersten Mal übersetzt“* | richtig; „gemessen“ meint das Werkzeug | „… **am laufenden Programm nicht gemessen**“ ergänzen, wie in CHANGELOG.md:84-85 |

### <a id="l-17.2"></a>L-17.2 — „7.2.0.80“ ohne Zusatz „-an1“ für AN-1-Inhalte

Die Unterscheidung `7.2.0.80-an1` ist an den neuen Stellen eingeführt. Benachbarte Stellen sagen weiter schlicht „7.2.0.80“ und meinen [AN-1](../BEFUNDE.md#an-1).
Seit dem Merge heißt 7.2.0.80 aber [AN-2](../BEFUNDE.md#an-2). **Zwei davon sind falsche Verweise.**

| Datei:Zeile | Zitat | Vorschlag |
|---|---|---|
| AUFGABEN.md:462 | *„Einzelheiten in CHANGELOG.md, Abschnitt **7.2.0.80**.“* | **Falscher Verweis:** Der Abschnitt 7.2.0.80 ist jetzt [AN-2](../BEFUNDE.md#an-2). Richtig: „Abschnitte Messfassung 7.2.0.80-an1 und 7.2.0.81“ |
| Releases/PAKETE.md:197-198 | Messfassung 1.0.80-an1: *„Einzelheiten in CHANGELOG.md, Abschnitt **7.2.0.81**“* | **Falscher Verweis:** Die Einzelheiten stehen im Abschnitt „Messfassung 7.2.0.80-an1“ (CHANGELOG.md:126). Der Abschnitt 7.2.0.81 fasst sie nur in zwei Sätzen (:105-108) |
| CHANGELOG.md:153 | *„**Behoben in 7.2.0.80:** `AnhangNameKuerzen` …“* (im Abschnitt Messfassung 7.2.0.80-an1) | „Behoben in 7.2.0.80-an1“ |
| AUFGABEN.md:456 | *„das ist **B5.8**, behoben in 7.2.0.80 mit `AnhangNameKuerzen`“* | „7.2.0.80-an1“ |
| AUFGABEN.md:459 | *„**B5.9, gemessen an 7.2.0.80:**“* | „an 7.2.0.80-an1“ |
| Releases/PAKETE.md:180 | 1.0.81: *„weil 7.2.0.80 an diesem Tag gebaut und gemessen wurde“* | „7.2.0.80-an1“. Gebaut wurde nicht die AN-2-Fassung |
| tools/ZWEIGE.md:93 | `an1-endungen`: *„7.2.0.80 (`AnhangNameKuerzen` …) und 7.2.0.81“* | „7.2.0.80-an1“; dazu Merge und 7.2.0.82 (siehe [L-17.3](#l-17.3)) |

### <a id="l-17.3"></a>L-17.3 — Aktueller Stand nicht auf 7.2.0.82

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| ZIEL.md:17 | *„seitdem ist nichts gebaut … **Quellstand ist jetzt 7.2.0.80** … aber nicht übersetzt … Der letzte wirklich **gebaute** Stand ist **7.2.0.76**“* | Quellstand 7.2.0.82. Am 12.10. gebaut: 7.2.0.77, .78 (Gregor), .79, .80-an1, .81, .82 (`TESTLAEUFE.md:84-88`) | nachziehen. **[L-16.10](LEKTOR-16.md#l-16.10), offen**; doku-pruefen meldet ZIEL.md mit höchster Fassung 7.2.0.80 |
| README.md:149-151 | *„**Sechs davon sind in 7.2.0.79 geändert, aber nicht übersetzt** … offen bleibt, dass über IMAP keine Endung …“* | POP heil an 7.2.0.81 und 7.2.0.82 | „Über POP behoben und an 7.2.0.81/82 gemessen, alle sechs Prüffälle heil; IMAP ungemessen, [B5.7](../AUFGABEN.md#b5.7) offen“ (**[L-16.10](LEKTOR-16.md#l-16.10), offen**) |
| README.md:144 | *„**Sieben** getrennte Ursachen“* | BEFUNDE.md:177 sagt **zehn** | siehe [L-17.5](#l-17.5) |
| PORTIERUNG.md:43 | *„Stand 18.09.2026, Quellstand **7.2.0.73**, `VERSION` **1.0.73**“* | 7.2.0.82 | unverändert seit [LEKTOR-16](LEKTOR-16.md#lektor-16), doku-pruefen meldet es. Nachziehen oder deutlich als „Stand 18.09.“ markieren |
| tools/ZWEIGE.md:93 | `an1-endungen` endet bei 7.2.0.81 | Merge von `main` (`9113007`) und 7.2.0.82 liegen auf diesem Zweig | „am 12.10. `main` (PR #83) hineingemergt, Quellstand 7.2.0.82“. Damit entfällt auch der doku-pruefen-Hinweis |
| WEITERMACHEN.md:10 | *„alle sechs Prüffälle heil an **7.2.0.81** (`C:\Temp\AN3`)“* | AN4 an 7.2.0.82: ebenfalls alle sechs, 185/185 Tests | „… an 7.2.0.81 und 7.2.0.82 (`C:\Temp\AN4`), 185/185 Tests“ |
| BEFUNDE.md:177, Tabelle :7874-7878 | *„POP-Weg … heil an 7.2.0.81“* | AN4 bestätigt das an 7.2.0.82 | Tabellenzeile „7.2.0.82 (`C:\Temp\AN4`) \| alle sechs“ |
| Releases/PAKETE.md:158-162 | *„## 1.0.82 — **in Arbeit**“*, *„ZIP **existiert noch nicht**“* | gebaut (Rebuild 0), 185/185, gemessen in `C:\Temp\AN4` | „gebaut und gemessen, nicht geschnürt“, wie bei 1.0.81; Prüfverzeichnis `C:\Temp\AN4` nennen |
| WEITERMACHEN.md:106-114 | „Der nächste Schritt“ 1.: *„Er will `git apply` fahren … **[B5.0](../AUFGABEN.md#b5.0) bis B5.5** … Zwei Patches liegen bereit und sind **nicht angewandt**“* | Patches eingespielt und entfernt, [AN-1](../BEFUNDE.md#an-1) über POP heil | ersetzen durch „Gregor prüft 7.2.0.82 lokal; offen: IMAP-Weg (B5.6/[B5.7](../AUFGABEN.md#b5.7)), AN-2-Produktfrage (B6)“ (**[L-16.8](LEKTOR-16.md#l-16.8), offen**) |
| WEITERMACHEN.md:138-142 | *„**Was heute fertig wurde:** [E-110](../BEFUNDE.md#e-110) behoben …“* | das war der 18.09. | **[L-16.8](LEKTOR-16.md#l-16.8), offen** |
| WEITERMACHEN.md:27 | *„Zuletzt gebaut und veröffentlicht \| Quellstand 7.2.0.72 … gebaut am 17.09.2026“* | zuletzt **gebaut**: 7.2.0.82; zuletzt **veröffentlicht**: 7.2.0.72 | trennen (**[L-16.8](LEKTOR-16.md#l-16.8), offen**) |

### <a id="l-17.4"></a>L-17.4 — AUFGABEN.md B5: Kopf neu, Rumpf alt (L-16.4 fast ganz offen)

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| AUFGABEN.md:450 | Überschrift *„… — **7.2.0.79 gemessen: 4 von 6 heil; 7.2.0.80-an1: 5 von 6; **7.2.0.81: alle sechs heil****“* | Die Fettschrift ist verschachtelt (`**…**…****`). In GitHub-Markdown bricht das die Hervorhebung | „— **7.2.0.81 und 7.2.0.82: alle sechs heil** (zuvor 7.2.0.79: 4 von 6, 7.2.0.80-an1: 5 von 6)“ |
| AUFGABEN.md:468-470 | *„**Es ist nichts mit MSVC gebaut.** Alle drei Sitzungen dazu liefen ohne Windows …“* | widerspricht dem Kasten :452 sechzehn Zeilen darüber | streichen oder „bis 7.2.0.78“ |
| AUFGABEN.md:473 | *„**Sechs** getrennte Ursachen“* | Tabelle: sieben, BEFUNDE: zehn | siehe [L-17.5](#l-17.5) |
| AUFGABEN.md:491-502 | *„Stand der **sieben** Teile“*, Tabelle endet bei [B5.7](../AUFGABEN.md#b5.7) | **B5.8, B5.9 und B5.10** stehen nur im Kasten | drei Zeilen: B5.8 `AnhangNameKuerzen` (7.2.0.80-an1, gemessen Fall 03), B5.9 `GetMaps`/`pkcs10` (7.2.0.81, gemessen Fall 05), B5.10 Vorzeichen in `SetExtension` (7.2.0.81, PRUEFER-19; der Fall ist mit den Prüfdaten nicht auslösbar) |
| AUFGABEN.md:497 | B5.3 *„**behoben**“* | erst mit B5.8 für den Anwender wirksam | Zusatz ([L-16.4](LEKTOR-16.md#l-16.4)) |
| AUFGABEN.md:521-523 | *„… genau aus wie die drei Übersetzungsfehler, die am 12.10.2026 ungeklärt blieben“* | seither vier Rebuilds mit 0 Fehlern; die drei Fehler beschreibt keine MD | sagen, was aus ihnen wurde |
| AUFGABEN.md:541 | *„**Nicht gemessen:** nichts davon ist mit MSVC gebaut, nichts ist gestartet.“* | gebaut und gestartet (TESTLAEUFE.md:84-88) | berichtigen |
| AUFGABEN.md:545-555 | „Der nächste Schritt an einem Windows-Rechner“, 1. bauen … 5. Testfall | Schritte 1–4 sind erledigt. Schritt 5 (`TestPopEmpfang.cpp`) bleibt offen | „1–4 erledigt (7.2.0.79 bis .82); offen 5 und ein IMAP-Abruf“ |
| AUFGABEN.md:557-561 | Spalte `stand` *„gewollt, solange niemand bestätigt hat, dass die Behebung am laufenden Programm wirkt“* | am Programm gemessen; Gregors Bestätigung fehlt noch | vermerken |
| AUFGABEN.md:611 | *„**alle sechs heil** \| B5.1 bis B5.6 wirken am laufenden Programm“* | B5.6 betrifft nur IMAP, der Prüfstand ist POP. Gemessen sind B5.1–B5.3, B5.5, B5.8, B5.9 | berichtigen. LIESMICH.md:43-45 macht es schon richtig |
| AUFGABEN.md:636-638 | *„Alle sechs behobenen Teile … soweit ohne MSVC möglich, gemessen.“* | gebaut und gemessen | nachziehen |

Aus [L-16.4](LEKTOR-16.md#l-16.4) eingearbeitet sind nur AUFGABEN.md:578 („Elf Marken“) und :495 ([B5.0](../AUFGABEN.md#b5.0): elf Stellen, Messstand der Marken).

### <a id="l-17.5"></a>L-17.5 — Die Zahl der Ursachen: sechs, sieben oder zehn

| Stelle | Zahl |
|---|---|
| BEFUNDE.md:177 | **zehn** („Teile 1 bis 6 und 8 bis 10 behoben, [B5.7](../AUFGABEN.md#b5.7) offen“) |
| README.md:144 | **sieben** |
| AUFGABEN.md:491 | **sieben** Teile |
| AUFGABEN.md:473 | **sechs** |
| CHANGELOG.md:16 | „Sechs von **sieben**“ |
| Releases/PAKETE.md:231 | „sechs der **sieben**“ (für 1.0.79 als damaliger Stand vertretbar) |

**Vorschlag:** BEFUNDE.md:177 als Maßstab nehmen, also zehn Teile B5.1–B5.10. Teil 10 ist ein Folgefehler, den erst Teil 9 erreichbar gemacht hat. Das sollte einmal entschieden und dann überall gleich geschrieben werden.
Außerdem nennt BEFUNDE.md:7882 *„Teil 8 — **drei** Kappungen von hinten“*, zählt aber `strncpy` und `DeMacifyName32` auf. CHANGELOG.md:149 sagt *„**zwei** Stellen“*. Wenn die zweite Abschrift von DeMacifyName32 als dritte zählt, sollte das dort stehen.

### <a id="l-17.6"></a>L-17.6 — CHANGELOG.md: L-16.5 weitgehend offen

| Datei:Zeile | Zitat | Bestand | Vorschlag |
|---|---|---|---|
| CHANGELOG.md:16 | „Noch offen“, [AN-1](../BEFUNDE.md#an-1): *„**Sechs von sieben Ursachen geändert in 7.2.0.79 — nichts davon ist übersetzt oder am laufenden Programm bestätigt.** … Offen ist [B5.7](../AUFGABEN.md#b5.7) … und der Bau“* | POP heil an 7.2.0.81 und 7.2.0.82 | „POP-Weg an 7.2.0.81/82 heil, alle sechs Prüffälle; offen: [B5.7](../AUFGABEN.md#b5.7), IMAP ungemessen, Gregors Prüfung“ — **die gröbste Unwahrheit im Umfang, sie steht ganz oben** |
| CHANGELOG.md:212 | *„## 7.2.0.79 — … **nicht übersetzt**“* | übersetzt und gemessen am 12.10. (CHANGELOG.md:133) | Überschrift nachziehen |
| CHANGELOG.md:214-216 | *„**Hier ist nichts gebaut und nichts gestartet.**“* | wie oben | als „beim Einspielen“ kennzeichnen |
| CHANGELOG.md:233 | *„**Zehn Debug-Marken**“* | elf seit 7.2.0.80-an1 | im Abschnitt 7.2.0.81 oder 7.2.0.82 „jetzt elf Marken“ |
| CHANGELOG.md:158-161 | *„Die Ursache ist **nicht** geklärt; **ANHANG-Marke 11** … nennt jetzt jeden Ausstieg“* | geklärt in 7.2.0.81 (`pkcs10`); der Nullzeiger-Ausstieg bleibt stumm ([L-16.5](LEKTOR-16.md#l-16.5)) | Verweis „geklärt in 7.2.0.81“ |
| CHANGELOG.md:164-166 | *„## 7.2.0.80 — … ([AN-2](../BEFUNDE.md#an-2)), **nicht übersetzt**“* und *„Hier ist nichts gebaut“* | für 7.2.0.80 richtig | Verweis „übersetzt mit 7.2.0.82“ ([L-17.1](#l-17.1)) |

Eingearbeitet ist die `CheckName`-Formulierung (CHANGELOG.md:147-151).

### <a id="l-17.7"></a>L-17.7 — BEFUNDE.md AN-1: neuer Kasten oben, darunter der alte Stand (L-16.2 und L-16.3 offen)

Der Kasten :7869-7894 ist neu und stimmt mit AN3 überein. Er endet mit *„Ab hier unten folgt der ältere Stand.“* (:7894).
Das ist ein brauchbarer Ausweg. Folgende Stellen widersprechen aber weiterhin mitten im Text:

| Datei:Zeile | Zitat | Vorschlag |
|---|---|---|
| BEFUNDE.md:7898-7900 | *„**Stand 12.10.2026.** Die Teile 1 bis 6 sind im Quelltext … **Übersetzt ist nichts**“* | trägt dasselbe Datum wie der Kasten darüber und sagt das Gegenteil → „Stand vor dem ersten Bau (12.10., morgens)“ |
| BEFUNDE.md:8176 | `Token[0] = 0;` *„**Nicht angefasst** — kein Compiler.“* | „seit 7.2.0.79 drin (B5.2)“ |
| BEFUNDE.md:8290 | DeMacifyName32 *„**Nicht angefasst**, weil hier nicht gebaut werden kann.“* | ebenso (B5.4, B5.8) |
| BEFUNDE.md:8300 | *„Stand \| **im Quelltext seit 7.2.0.79.** Nicht übersetzt“* | „übersetzt, Fall 01/02 heil“ |
| BEFUNDE.md:8341-8360 | „Was noch offen ist“: Punkte 2, 3, 4, 5 | alle erledigt (B5.3, B5.5, B5.2, B5.4) |
| BEFUNDE.md:8370-8384 | Markentabelle mit 8 Zeilen, Zeilennummern Stand 7.2.0.76; *„Marken 1 bis 3 gibt es doppelt, einmal für IMAP“* | Marken 9 (IMAP), 10 und 11 ergänzen; IMAP hat 1–9; Zeilennummern nach [L-16.3](LEKTOR-16.md#l-16.3) |
| BEFUNDE.md:8433-8437 | Entscheidungstabelle *„alle sechs heil \| B5.1 bis B5.6 wirken“* | B5.6 ist IMAP (wie [L-17.4](#l-17.4)) |
| BEFUNDE.md:8480 | *„Nichts davon ist am laufenden Programm nachgesehen. Es gibt keinen Bau.“* | „bis 12.10.“ |

Die Zeilennummern-Tabelle aus **[L-16.3](LEKTOR-16.md#l-16.3)** gilt weiter. Ich habe sie nicht neu ausgemessen.
**Vermutung, nicht gemessen:** Durch 7.2.0.81 haben sich mindestens die `MIMEMap.cpp`-Zeilen weiter verschoben.

### <a id="l-17.8"></a>L-17.8 — `tools/offene-befunde.pl` weiter blind für AN-1, AN-2 und E-112 (L-16.1 offen)

`perl tools/offene-befunde.pl` meldet: *„offen laut BEFUNDE.md 16 / in WEITERMACHEN.md 16 — Die Liste deckt die offenen Befunde.“*
Der Code ist unverändert: `:72` führt weiterhin `'widerlegt'` in `@erledigt_wort`, und der Kennungsfilter lässt nur `E-` durch.
Damit fehlen jetzt **[AN-1](../BEFUNDE.md#an-1) und [AN-2](../BEFUNDE.md#an-2)** (beide laut BEFUNDE.md:177-178 offen) **und [E-112](../BEFUNDE.md#e-112)** (:279 „WIEDER OFFEN … widerlegt“).
Das ist der schwerste offene Fund: Die Schranke aus CLAUDE.md Schritt 1 sieht beide Befunde dieses Zweigs nicht.

### <a id="l-17.9"></a>L-17.9 — Kleinere

* **TESTLAEUFE.md:86-88**: Alle drei Bauten tragen einen Stern (`1.0.82+9113007*`), also ungesicherte Änderungen im Baum. Keine MD sagt, was der Stern bei 7.2.0.82 abdeckte. `git status` zeigt heute nur geänderte DLLs unter `Bin/Release`. Wenn es nur diese waren, genügt ein Satz in CHANGELOG 7.2.0.82. [L-16.5](LEKTOR-16.md#l-16.5) hatte denselben Punkt schon für 7.2.0.79.
* **LIESMICH.md:19**: Fall 04 heißt *„voller Name, `.pdf`“*. Gespeichert ist `…Musterstadt 20251.pdf`, weil der Name von Fall 02 schon belegt war. CHANGELOG.md:97 erklärt das, LIESMICH nicht; ein Halbsatz genügt. Davon abgesehen ist **[L-16.7](LEKTOR-16.md#l-16.7) eingearbeitet**: neue Spalten „bis 7.2.0.78“ und „ab 7.2.0.81“, Hinweis auf B5.6 und auf das „gemischte Bild“.
* **README.md:399-401**: Die LogLevel-Tabelle endet bei 32768, der Beleg lautet `debug.h:15-32`. `DEBUG_MASK_ATTACH = 0x10000` steht aber in `debug.h:44` ([L-16.10](LEKTOR-16.md#l-16.10), dritter Teil, offen).
* **LEKTORAT.md:1078** und **Befunde/LEKTOR-16.md:3** sagen *„Eingearbeitet ist bisher nur [L-16.9](LEKTOR-16.md#l-16.9)“* bzw. *„Die Funde sind noch nicht eingearbeitet“*. Tatsächlich sind auch [L-16.7](LEKTOR-16.md#l-16.7) sowie Teile von [L-16.2](LEKTOR-16.md#l-16.2) (Kasten), [L-16.4](LEKTOR-16.md#l-16.4) („Elf Marken“, [B5.0](../AUFGABEN.md#b5.0)), [L-16.5](LEKTOR-16.md#l-16.5) (CheckName) und [L-16.6](LEKTOR-16.md#l-16.6) (neue PAKETE-Abschnitte) eingearbeitet. Den Stand vermerken.
* **AUFGABEN.md:495 / CHANGELOG.md:235**: *„POP-Marken 1–8 … gemessen“*. Marke 8 hat in keinem dokumentierten Lauf geschrieben (L-16, Kleinere). Offen.
* **Releases/PAKETE.md:216, :231-233** (1.0.79): weiter *„nicht gebaut“*, *„sechs der sieben“*, *„Übersetzt ist nichts“* ([L-16.6](LEKTOR-16.md#l-16.6), offen). 7.2.0.79 ist in `C:\Temp\AN1` gebaut und gemessen.

---

## Offene Funde aus LEKTOR-16, mit aktueller Fundstelle

| L-16 | Stand | aktuelle Fundstelle |
|---|---|---|
| [L-16.1](LEKTOR-16.md#l-16.1) | **offen** | `tools/offene-befunde.pl:72` und Kennungsfilter; siehe [L-17.8](#l-17.8) |
| [L-16.2](LEKTOR-16.md#l-16.2) | teilweise (Kasten :7869) | BEFUNDE.md:7898-7900, :8176, :8290, :8300, :8341-8360, :8370-8384, :8433-8437, :8480 |
| [L-16.3](LEKTOR-16.md#l-16.3) | **offen** | BEFUNDE.md, Weg-Tabelle (um :8050) und Markentabelle :8374-8381 |
| [L-16.4](LEKTOR-16.md#l-16.4) | teilweise | AUFGABEN.md:468, :473, :491-502, :497, :521-523, :541, :545-555, :557-561, :611, :636-638 |
| [L-16.5](LEKTOR-16.md#l-16.5) | teilweise (CheckName) | CHANGELOG.md:16, :212, :214-216, :233, :158-161 |
| [L-16.6](LEKTOR-16.md#l-16.6) | teilweise | Releases/PAKETE.md:216, :231-233 |
| [L-16.7](LEKTOR-16.md#l-16.7) | **eingearbeitet** | Rest: LIESMICH.md:19 (Fall 04 `…20251`) |
| [L-16.8](LEKTOR-16.md#l-16.8) | **offen** | WEITERMACHEN.md:106-114, :138-142, :27 |
| [L-16.9](LEKTOR-16.md#l-16.9) | eingearbeitet | — |
| [L-16.10](LEKTOR-16.md#l-16.10) | **offen** | ZIEL.md:17, README.md:149-151, README.md:399-401 |

---

## Meldungen der Werkzeuge

`perl tools/doku-pruefen.pl`:

```
Quellstand 7.2.0.82 · Paketnummer 1.0.82 · Kriterien in ZIEL.md 9 ·
gepruefte Dateien 26 · Kennungen im Verzeichnis 111 · Abschnitte in BEFUNDE.md 14
Kein Widerspruch gefunden.
Zur Kenntnis (nennt weder 7.2.0.82 noch 1.0.82; hoechste genannte Fassung):
 - PORTIERUNG.md                 7.2.0.73
 - Testdaten/README.md           7.2.0.73
 - ZIEL.md                       7.2.0.80
 - tools/WERKZEUGE.md            7.2.0.73
 - tools/ZWEIGE.md               7.2.0.81
 - tools/pruefdaten/LIESMICH.md  7.2.0.81
```

`perl tools/pruefe-stand-md.pl`:

```
5 Datei(en) mit Stand-Kopf geprueft, Massstab 12.10.2026
LEKTORAT.md ist so neu wie der juengste Bericht des LEKTOR
LEKTORAT.md nennt alle 15 Berichte des LEKTOR
PRUEFBERICHT.md erklaert sich als abgeschlossen und verweist weiter
Kein Stand-Kopf hinkt hinterher.
```

Zusätzlich `perl tools/offene-befunde.pl`: *„16 / 16, Die Liste deckt die offenen Befunde“*. Das ist falsch, siehe [L-17.8](#l-17.8).

**Bewertung:** Beide Doku-Werkzeuge melden grün. Trotzdem steht ganz oben im CHANGELOG (:16) „nichts davon ist übersetzt“ für einen Befund, der an zwei Bauten heil gemessen ist.
Der Vorschlag aus [LEKTOR-16](LEKTOR-16.md#lektor-16) gilt weiter: Eine Fassung, zu der `TESTLAEUFE.md` einen Start verzeichnet, darf in keiner MD als „nicht übersetzt“ oder „nicht gebaut“ stehen.
Mit dieser Regel wären [L-17.3](#l-17.3), [L-17.6](#l-17.6), [L-17.7](#l-17.7) und PAKETE 1.0.79 mechanisch gefallen.
Für [AN-2](../BEFUNDE.md#an-2) ([L-17.1](#l-17.1)) bräuchte sie eine zweite Regel: Ein Befund, der in einer gebauten Fassung steckt, darf nicht nur „nicht übersetzt“ tragen.
**Vorsicht:** Die Regel braucht eine Ausnahme für Sätze, die ausdrücklich den Stand einer früheren Fassung beschreiben, sonst trifft sie die richtigen Sätze in CHANGELOG 7.2.0.80. Gegentest nötig (`schranke-gegentesten.md`).

---

## Zusammenfassung

Die Kernaussagen zum aktuellen Stand stimmen mit dem Bestand überein: 7.2.0.82/1.0.82, [AN-1](../BEFUNDE.md#an-1) über POP an 7.2.0.81 und 7.2.0.82 heil (sechs `.pdf`, 0 × „kennt den Typ NICHT“), [AN-2](../BEFUNDE.md#an-2) übersetzt, aber am Programm nicht gemessen.
Keine Stelle behauptet, [AN-2](../BEFUNDE.md#an-2) sei am Programm gemessen.
Die Mängel:

1. **[AN-2](../BEFUNDE.md#an-2) heißt an sieben Stellen nur „nicht übersetzt“.** Der Stand 7.2.0.82 fehlt dort ([L-17.1](#l-17.1)).
2. **„7.2.0.80“ ohne „-an1“** meint an sieben Stellen [AN-1](../BEFUNDE.md#an-1). Zwei davon verweisen dadurch auf den falschen CHANGELOG-Abschnitt: AUFGABEN.md:462 und PAKETE.md:198 ([L-17.2](#l-17.2)).
3. **ZIEL.md:17, README.md:149/161, CHANGELOG.md:16 und WEITERMACHEN „Der nächste Schritt“** sind auf dem Stand vor dem ersten Bau ([L-17.3](#l-17.3), [L-17.6](#l-17.6)).
4. Die Zahl der Ursachen lautet je nach Stelle sechs, sieben oder zehn ([L-17.5](#l-17.5)).
5. `offene-befunde.pl` sieht [AN-1](../BEFUNDE.md#an-1), [AN-2](../BEFUNDE.md#an-2) und [E-112](../BEFUNDE.md#e-112) weiter nicht ([L-17.8](#l-17.8)).
