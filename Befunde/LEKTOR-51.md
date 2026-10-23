# <a id="lektor-51"></a>LEKTOR-51 — Bestandsprüfung am 23.10.2026

**Auftrag.** Gregor am 22.10.2026: *„prüfer und lektor immer wieder einsetzen —
nicht vergessen!"* Die Rollenschranke meldete LEKTOR als fällig: seit seinem
letzten Bericht (`acf4dd2`) hatten sich 25 Dateien in seinem Bereich geändert.

**Maßstab von außen**, nicht Dokument gegen Dokument
([einigkeit-ist-kein-beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)):
`Eudora71/Version.h`, `VERSION`, `git tag`, `git log --diff-filter=A`,
`Eudora71/Eudora/utils.cpp`, die ausgelieferten `Eudora.exe`.

**Umfang.** 29 Dateien. Pflicht waren die 25 geänderten; dazu vier
**unveränderte**, die `tools/doku-pruefen.pl` als veraltet meldet
(`Doku/HINTERGRUND.md`, `MELDUNGEN-VON-AUSSEN.md`, `Testdaten/README.md`,
`tools/pruefdaten/LIESMICH.md`) — genau der Fall aus
[review-sieht-nur-den-diff](../Arbeitsweise/review-sieht-nur-den-diff.md): die
veraltete, unveränderte Datei steht in keinem Diff.

**Ergebnis: 22 Funde** — 9 falsch, 8 veraltet, 5 unvollständig.

---

## Der schwerste Fund

### <a id="l-51.1"></a>L-51.1 — Emoji **verschwinden**, sie werden nicht zu `?`

**Gewicht: falsch.** `README.md:160` und `Intern/BEFUNDE.md` ([E-90](../Intern/BEFUNDE.md#e-90)).

Beide sagten, Emoji in Betreffzeilen erschienen als `?`. Der Befundeintrag
beschrieb dazu die Kette *„`WideCharToMultiByte` setzt dafür ein
Fragezeichen"* — **mit der Marke „Zuletzt belegt am Quelltext: 22.10.2026".**

**Selbst nachgemessen an `Eudora71/Eudora/utils.cpp`:** zwischen den beiden
Aufrufen, die der Eintrag nennt, steht seit 7.2.0.59 eine Filterschleife
(`:1570-1596`), die er nicht erwähnt. `:1582` lautet
`if (w >= 0xD800 && w <= 0xDFFF) continue;` — jedes Surrogat, also **jedes
Emoji**, wird gestrichen, **bevor** `WideCharToMultiByte` (`:1607`) überhaupt
läuft. Bestand ein Text nur aus solchen Zeichen, kommt er leer heraus
(`:1617-1623`, `bGanzGefiltert`).

**Warum das zählt.** Es stand so in der Datei, die Anwender lesen, und die
Quelltextmessung vom Vortag hat den falschen Stand **bestätigt**, weil sie die
Funktion las, in der der Filter steht, und ihn nicht nannte. Ein frisches
*„Zuletzt belegt am Quelltext"* ist kein Beweis.

Berichtigt in `README.md` und im E-90-Eintrag, mit dem ehrlichen Zusatz: **am
laufenden Programm ist das seit 7.2.0.59 nie nachgemessen worden.**

> **Nebenbefund:** `Doku/HINTERGRUND.md:34` ist die **einzige** Stelle im Repo,
> die es richtig sagt — ausgerechnet die Datei, die das Werkzeug als veraltet
> meldet. Dort nichts geändert.

---

## Geschlossene Befunde, die anderswo offen weiterstanden

### <a id="l-51.2"></a>L-51.2 — E-114 an drei Stellen offen
**Gewicht: falsch.** `Doku/ANWENDER.md:75-78`, `README.md:164`,
`Intern/AUFGABEN.md:414`. `Intern/BEFUNDE.md` führt [E-114](../Intern/BEFUNDE.md#e-114) seit dem 23.10.2026
als erledigt; `offene-befunde.pl` hat ihn aus den **erzeugten** Tabellen
entfernt, die drei handgepflegten Stellen blieben stehen. Alle drei berichtigt.

### <a id="l-51.3"></a>L-51.3 — E-127 in den bekannten Fehlern der README
**Gewicht: veraltet.** `README.md:153`. Umgeschrieben statt gestrichen: der
Hinweis gilt weiter für `v1.0.120`, mit dem Zusatz, dass es am 23.10.2026 in
zwei Läufen nicht mehr auftrat und die Ursache nie gefunden wurde.

### <a id="l-51.5"></a>L-51.5 — E-125 sagte im selben Feld „noch nicht gebaut" und „gebaut"
**Gewicht: falsch.** `Intern/BEFUNDE.md`. Wer von oben las, hörte vor der
Berichtigung auf. Die erste Hälfte verweist jetzt nach unten.

### <a id="l-51.6"></a>L-51.6 — E-124 „wartet auf Microsoft" an vier Stellen
**Gewicht: falsch.** `Intern/BEFUNDE.md` (Feld *Was noch fehlt*),
`Doku/ANWENDER.md:200-202`, `Arbeitsweise/stand-22-10-2026-abend.md`,
`Arbeitsweise/nur-offene-entscheidungen-auf-gregors-liste.md`.

Im **selben** Befund steht 20 Zeilen weiter die Messung vom 23.10.2026: der
Vorgang ist **abgewiesen**, *„rejected due to too many files"*. Das Feld *Was
noch fehlt* ist genau das, aus dem `offene-befunde.pl` die Tabellen erzeugt —
der widerlegte Satz wanderte also weiter. **Kein Werkzeugfehler, die Quelle
war falsch.**

Dazu erteilte `ANWENDER.md:200-202` dem Anwender eine Anweisung, an der wir
selbst gescheitert sind
([erst-pruefen-dann-anweisen](../Arbeitsweise/erst-pruefen-dann-anweisen.md)).
Ergänzt um: **nur die beanstandete Datei hochladen, kein ZIP.**

---

## Zahlen, die nicht stimmten

### <a id="l-51.8"></a>L-51.8 — „seit 7.2.0.106 sind keine Werkzeuge dazugekommen" — es sind 22
**Gewicht: falsch.** `tools/WERKZEUGE.md:3`. Selbst nachgezählt:
`git log --diff-filter=A --name-only fd890f3..HEAD -- tools/` nennt **22** neue
Werkzeuge. Die ursprüngliche Messung hatte `git diff --stat` benutzt, das
Neuanlagen nicht als solche ausweist. **Die Tabelle selbst ist vollständig**
(139 Dateien, keine Fehlstelle) — falsch war nur die Kopfzeile, und genau die
hält jemanden davon ab nachzusehen
([werkzeug-vor-eigenbau](../Arbeitsweise/werkzeug-vor-eigenbau.md)).

### <a id="l-51.9"></a>L-51.9 — `v1.0.117` als *Latest*
**Gewicht: falsch.** `Releases/PAKETE.md:20`. `git tag --sort=-v:refname` nennt
`v1.0.120`; dieselbe Datei sagt an drei anderen Stellen das Richtige.

### <a id="l-51.16"></a>L-51.16 — 243 Tests statt 277
**Gewicht: veraltet.** `Intern/TESTPLAN.md:242`. **Zum dritten Mal veraltet.**
Berichtigt und mit dem Vermerk versehen, dass diese Zahl aus
`tools/pruefbericht.pl` erzeugt gehört
([liste-aus-einer-quelle](../Arbeitsweise/liste-aus-einer-quelle.md)).

### <a id="l-51.20"></a>L-51.20 / <a id="l-51.22"></a>L-51.22 — `Testdaten/README.md`
**Gewicht: unvollständig / veraltet.** Die Einleitung nannte 7 Befunde, das
Verzeichnis trägt 11. Und der Zusammenbau-Befehl mit `Testdaten/e1*.eml` trifft
heute **neun** Dateien, während die Messung daneben von dreien spricht. Beides
berichtigt und datiert.

### <a id="l-51.21"></a>L-51.21 — „Alle fuenf Dateien stammen aus echten Nachrichten"
**Gewicht: falsch — und es ist eine Datenschutzaussage.**
`Testdaten/README.md:106`. Das Verzeichnis enthält elf Dateien; sechs davon
sagen in der Tabelle derselben Datei ausdrücklich *„eigens gebaut"*. Der Satz
steht unter der Überschrift *Herkunft* und wird als Aussage über das **ganze**
Verzeichnis gelesen. Auf „fünf der elf" berichtigt.

---

## Der Maßstab und das Gedächtnis

### <a id="l-51.10"></a>L-51.10 / <a id="l-51.11"></a>L-51.11 — `ZIEL.md`
**Gewicht: veraltet.** [E-111](../Intern/BEFUNDE.md#e-111) stand ohne „behoben", [E-105](../Intern/BEFUNDE.md#e-105) mit „eingebaut",
obwohl Gregor es am 22.10.2026 bestätigt hat. Der **erzeugte** Block darüber
führte beide folgerichtig nicht mehr — die handgepflegte Gruppentabelle
darunter schon. Beide Zeilen nachgezogen.

### <a id="l-51.12"></a>L-51.12 — `Doku/ANWENDER.md:41`
**Gewicht: falsch.** Zweierlei: [E-105](../Intern/BEFUNDE.md#e-105) ist von Gregor bestätigt, und der
Download ist `v1.0.120`, nicht `v1.0.87`.

### <a id="l-51.7"></a>L-51.7 — sieben Lehren fehlten im Gedächtnis
**Gewicht: unvollständig.** `Arbeitsweise/MEMORY.md` führte 110 Einträge bei
120 Dateien. Es fehlten `aussenwirkung-ist-der-massstab`,
`liste-aus-einer-quelle`, `einstufung-ist-keine-auskunft`,
`gemergt-heisst-nicht-auf-main`, `rueckfrage-ist-keine-messung`,
`CHRONIST-2026-10-22` und `CHRONIST-2026-10-12`.

**Warum das zählt:** `MEMORY.md` ist das Verzeichnis, das zu Sitzungsbeginn
geladen wird. Die fünf Lehren des CHRONIST-Laufs vom 22.10.2026 hat **keine
Sitzung je zu sehen bekommen** — eine Lehre, die nur Text ist
([lehren-anwenden-nicht-nur-schreiben](../Arbeitsweise/lehren-anwenden-nicht-nur-schreiben.md)).
Alle sieben eingetragen, im Gedächtnis **und** im Repo; Gegenprobe gefahren,
es fehlt keine mehr.

### <a id="l-51.14"></a>L-51.14 / <a id="l-51.15"></a>L-51.15 — `Intern/WEITERMACHEN.md`
**Gewicht: falsch / veraltet.** Die Quellstandzeile nannte einen Zweig vom
22.10., und *„Offen: Fehlalarm bei Microsoft melden (Gregor)"* stand seit dem
20.10. fälschlich auf Gregors Liste — genau der Fehler aus
[nur-offene-entscheidungen-auf-gregors-liste](../Arbeitsweise/nur-offene-entscheidungen-auf-gregors-liste.md).

### <a id="l-51.18"></a>L-51.18 — der Arbeitszweig fehlte in `tools/ZWEIGE.md`
**Gewicht: unvollständig.** `pruefe-branch.pl` **hat gemeldet** — und niemand
hat eingetragen. Nachgetragen.

---

## Die Fassungsfrage

### <a id="l-51.4"></a>L-51.4 — eine Nummer für zwei Bauten
**Gewicht: unvollständig.** `CHANGELOG.md:3-4` sagt selbst: *„Jede Nummer
gehört genau einem Bau."* Der E-125-Bau vom 23.10.2026 änderte `tocdoc.cpp`,
`EudoraRes.rc` und `resource.h`, **ohne** Versionssprung — 7.2.0.121 hätte
damit zwei verschiedene Quellstände beschrieben.

**Entschieden und umgesetzt:** Quellstand auf **7.2.0.122** / `VERSION`
**1.0.122** gehoben, [E-125](../Intern/BEFUNDE.md#e-125) bekommt einen eigenen CHANGELOG-Abschnitt, die
Standzeilen in `README.md`, `Intern/AUFGABEN.md`, `Intern/WEITERMACHEN.md` und
`Releases/PAKETE.md` nennen die neue Nummer. Das ist kein Widerspruch zu
[nummer-erst-beim-schnueren](../Arbeitsweise/nummer-erst-beim-schnueren.md):
dort geht es um das **Ankündigen** einer Paketnummer vor dem ZIP, und der
Abschnitt trägt wie seine Vorgänger den Vermerk *„nur übersetzt, nicht
geschnürt"*.

### <a id="l-51.13"></a>L-51.13 / <a id="l-51.19"></a>L-51.19 / <a id="l-51.17"></a>L-51.17
*Der nächste Schritt* in `WEITERMACHEN.md` stand auf 7.2.0.115, `PORTIERUNG.md`
hatte keinen Block für die neue Fassung, und `Releases/PRUEFBERICHT.md` ist
vier Commits alt und kennt [E-125](../Intern/BEFUNDE.md#e-125) nicht. Der Prüfbericht wird **erzeugt** — er
gehört nach einem sauberen Lauf neu gesetzt, nicht von Hand geändert.

---

## Geprüft und in Ordnung — ausdrücklich

* **`Doku/HINTERGRUND.md`**, **`MELDUNGEN-VON-AUSSEN.md`**,
  **`tools/pruefdaten/LIESMICH.md`** — vom Werkzeug als veraltet gemeldet,
  **inhaltlich nichts Falsches**. Ihre Fassungsangaben sind Messdaten mit
  Datum, keine Standaussagen. Keine Änderung.
* **`Releases/DEFENDER-FEHLALARM.md`** — trägt den Stand vom 23.10.2026
  vollständig; es ist die Quelle, gegen die [L-51.6](#l-51.6) gemessen wurde.
* **Die erzeugten Blöcke** in `CHANGELOG.md`, `WEITERMACHEN.md` und `ZIEL.md`
  sind in sich richtig.
* **`Befunde/LEKTOR-*.md`, `PRUEFER-*.md`** — datierte Prüfberichte. Sie waren
  beim Schreiben richtig und werden **nicht** rückwirkend umgeschrieben.
* **Die veröffentlichten `RELEASE-NOTIZEN.md`** — historischer Wortlaut, nicht
  geändert, auch wo er inzwischen überholt ist.

## Nicht geprüft — und warum

* **`Intern/BEFUNDE.md` als Ganzes** (8767 Zeilen). Gezielt gelesen wurden
  [E-90](../Intern/BEFUNDE.md#e-90), [E-105](../Intern/BEFUNDE.md#e-105), [E-111](../Intern/BEFUNDE.md#e-111), [E-114](../Intern/BEFUNDE.md#e-114), [E-124](../Intern/BEFUNDE.md#e-124), [E-125](../Intern/BEFUNDE.md#e-125), [E-127](../Intern/BEFUNDE.md#e-127), [E-128](../Intern/BEFUNDE.md#e-128). Die übrigen rund 126
  Kennungen sind **nicht** gegen den Quelltext gehalten. [L-51.1](#l-51.1) zeigt, dass
  auch ein Eintrag mit frischer Quelltextmarke falsch sein kann.
* **`Releases/PAKETE.md`** (1609 Zeilen), **`Intern/PORTIERUNG.md`** (1199),
  **`CHANGELOG.md`** (6033) — jeweils Kopf und die jüngsten Abschnitte.
* **Das laufende Programm.** Nichts gestartet (CLAUDE.md Abschnitt 4). [L-51.1](#l-51.1)
  ist am Quelltext gemessen, nicht am Bildschirm.
