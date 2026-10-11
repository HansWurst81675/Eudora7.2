# LEKTOR-13 — `main` auf Unwahrheiten geprüft

**Stand 17.09.2026.** Zweig `wt/lektor-main-pruefung`, Grundlage `origin/main`
(`bc515e2`). Vorgänger: [LEKTOR-11.md](LEKTOR-11.md), [LEKTOR-12.md](LEKTOR-12.md).

Gregors Auftrag, wörtlich:

> *„inzwischen kann lektor und pruefer den main branch verifizieren, ob
> unwahrheiten oder alte infos drin stehen"*

**Das ist ein anderer Maßstab als sonst.** Sonst wird geprüft, ob die Doku zum
neuesten Stand *passt*. Hier wird geprüft, ob das, was dasteht, **wahr** ist —
und eine Aussage, die einmal stimmte und heute nicht mehr, ist die teuerste
Sorte, weil man ihr glaubt.

## Umfang

Der Umfang kommt aus der Quelle, nicht aus dem Kopf
([[pruefumfang-nicht-von-hand]]):

```
git ls-tree -r --name-only origin/main | grep '\.md$'   ->  151 Dateien
```

**151 Markdown-Dateien, alle 151 maschinell durchgesucht**, davon 14 von Hand
gegen den Quelltext, gegen GitHub und gegen das Dateisystem nachgemessen.

| Prüfung | Werkzeug | Umfang |
|---|---|---|
| Zeilenangaben hinter Dateiende | eigenes Skript | 2543 Angaben `Datei:Zeile` |
| Symbol steht am behaupteten Ort | eigenes Skript | dieselben 2543, ±15 Zeilen |
| Markdown-Verweise ins Leere | eigenes Skript | alle `[…](….md)` |
| Werkzeugverweise ins Leere | `ls` gegen Text | 99 Dateien in `tools/` |
| Veröffentlichte Releases | `gh release list`, `git ls-remote --tags` | 13 Releases |
| Paket- und Verzeichnisstand | Dateisystem | `Releases/`, `C:\Users\Gregor\` |
| Testzahl | **Lauf des Testprogramms** | 166 Tests |

## Die Liste: Behauptung — gemessener Befund — berichtigt

### L-13.1 — Fünf Dokumente behaupteten, veröffentlicht sei nur `v1.0.50` (**die schlimmste**)

| | |
|---|---|
| **Behauptung** | `WEITERMACHEN.md`: *„**Auf GitHub veröffentlicht ist weiterhin `v1.0.50`**; **1.0.51 bis 1.0.66 sind nicht freigegeben**"*. Wortgleich in `AUFGABEN.md`, `Releases/PAKETE.md` und `README.md`; `tools/RELEASES.md` — das Verzeichnis der Veröffentlichungen — endete bei `v1.0.50` |
| **Gemessen** | `gh release list`: **13 Releases, `v1.0.64` als *Latest*, 2026-09-17T10:23:08Z**. `git ls-remote --tags origin`: `refs/tags/v1.0.64` → `1d37623`. Das Release existiert seit dem Morgen desselben Tages |
| **Berichtigt** | **ja**, in allen fünf |

**Warum das die schlimmste ist.** `README.md` ist die öffentliche Eingangstür.
Dort stand nicht nur die falsche Fassungsnummer, sondern darunter eine
**Warnung an die Anwender**:

> *„Im Release `v1.0.50` beendet *File → Save As* Eudora sofort (E-97) … wer
> das veröffentlichte Paket benutzt, speichert Nachrichten bis dahin besser
> nicht."*

**Genau dieser Fehler ist in `v1.0.64` behoben** — dem Release, das seit dem
Morgen als *Latest* dasteht. Die Warnung hätte Anwender von einem Download
abgehalten, der den gewarnten Fehler nicht mehr hat, und sie auf einer Fassung
festgehalten, in der er noch steckt. Eine Unwahrheit, die **das Gegenteil**
ihrer Absicht bewirkt.

Dazu kommt: `tools/RELEASES.md` ist die Datei, deren einziger Zweck es ist,
jede Veröffentlichung samt Freigabe zu führen. Sie hat die eigene Aufgabe
verfehlt — und die Lehre [[release-erst-nach-gregors-test]] lässt sich an einem
Verzeichnis, das das Release nicht kennt, nicht nachhalten.

### L-13.2 — Der Eintrag zu **E-85** in `BEFUNDE.md` war an vier Stellen unwahr

| | |
|---|---|
| **Behauptung** | *„**Alle drei Mängel behoben in 7.2.0.51 — aber die Behebung hat eine Regression eingeführt, die noch offen ist**"*, und am Ende derselben Zelle: *„von Gregor ist nichts davon am laufenden Programm bestätigt"* |
| **Gemessen** | (1) Es waren **vier** Mängel — `ZIEL.md:31`, `WEITERMACHEN.md` und `CHANGELOG.md` sagen das übereinstimmend. (2) Der **entscheidende vierte fehlte in der Zelle ganz**: der Zeichensatz wurde aus `m_pHd->m_TLMime` (Top-Level) statt aus dem MIME-Teil gelesen; behoben erst in **7.2.0.52**, nicht 7.2.0.51 — `m_szCurrentCharset` steht in `ImapDownload.cpp:2837, 3074, 3324`, nachgeschlagen. (3) Die **Regression ist geschlossen**: `utils.cpp:1308-1310` und `:1393-1395` retten das Byte hinter dem Stück, am Quelltext gelesen — **dieselbe Zelle beschreibt diese Behebung weiter unten selbst**. (4) *„von Gregor nichts bestätigt"* ist seit 7.2.0.52 überholt: `uebersetzt=ja`, null unübersetzte UTF-8-Folgen |
| **Berichtigt** | **ja**, dazu sechs abgewanderte Zeilenangaben in derselben Zelle |

**Warum das schwer wiegt.** `BEFUNDE.md` ist die Datei, die `CLAUDE.md` an die
**erste Stelle jeder Sitzung** setzt — mit der Begründung E-85. Wer sie heute
liest, findet E-85 als Befund mit offener Regression, an der falschen Fassung,
ohne den Mangel, der den Fall überhaupt gelöst hat. Das ist dieselbe Falle wie
damals, nur andersherum: nicht ein übersehener Befund, sondern ein Befund, der
**falsch über sich selbst berichtet**. [[bestand-vor-neuer-suche]] hilft nur,
wenn der Bestand stimmt.

Die sechs berichtigten Zeilenangaben derselben Zelle:

| behauptet | gemessen |
|---|---|
| `ImapDownload.cpp:4671` | **4742** (`FindMIMECharset (szGewaehlt)`) |
| `ImapDownload.cpp:4688` | **4785** (`if (iCharsetIdx > 2)`) |
| `ImapDownload.cpp:4705` | **4802** (`ISOTranslateChunk(...)`) |
| `utils.cpp:1443` | **1480** (`szBuf[lSize] = 0;`) |
| `utils.cpp:1440-1442` | **1477-1479** (der Kommentar) |
| `utils.cpp:1412-1415` | **1449-1452** (`if (iCharsetIdx <= 2)`) |

### L-13.3 — `ZIEL.md`: sieben Fundstellen der Splitter-Umsetzung, alle abgewandert

| | |
|---|---|
| **Behauptung** | Tabelle zu Kriterium *„den linken Bereich breiter ziehen"*: `AddSplitter` in `OTShim.cpp:3038`, `HitTest` `:3159`, `StartTracking` `:3199`, `CalcTrackingLimits` `:3178`, `DrawTrackerRect` `:3255`, `DeleteAllSplitters` `:3066`, Klasse `Splitter` in `OTShim.h:724ff` |
| **Gemessen** | **Keine einzige stimmt.** Wirklich: 3683, 3808, 3974, 3835, 4249, 3711 und `OTShim.h:753`. Abstand 500 bis 1000 Zeilen. **Die Sache selbst ist wahr** — alle sieben sind umgesetzt, einzeln nachgeschlagen; falsch war nur der Ort |
| **Berichtigt** | **ja**, alle sieben |

### L-13.4 — `CHANGELOG.md`, Abschnitt 7.2.0.64: Paketstand überholt

| | |
|---|---|
| **Behauptung** | *„Ein Paket ist zu dieser Fassung **noch nicht geschnürt** — das letzte liegt als `Releases/Eudora72-1.0.63-release`"* |
| **Gemessen** | Beide Hälften falsch. `Releases/Eudora72-1.0.64-release.zip` liegt da (17.09., 12:01), das Release `v1.0.64` ist heraus, und das letzte Verzeichnis unter `Releases/` ist `Eudora72-1.0.65-release` |
| **Berichtigt** | **ja** |

### L-13.5 — Zwei Verweise ins Leere

| | |
|---|---|
| **Behauptung** | `Arbeitsweise/agenten-koordinieren.md:13` verweist auf `[AGENTEN.md](AGENTEN.md)`; `Befunde/LEKTOR-5.md:483` auf `[ZIEL.md](ZIEL.md)` |
| **Gemessen** | Beide Dateien liegen im Wurzelverzeichnis, die Verweise stehen in Unterverzeichnissen — sie lösen zu `Arbeitsweise/AGENTEN.md` und `Befunde/ZIEL.md` auf. Beide existieren nicht. Es sind die **einzigen zwei** unter allen `[…](….md)`-Verweisen der 151 Dateien |
| **Berichtigt** | **`agenten-koordinieren.md` ja** (lebende Anweisung). `LEKTOR-5.md` **nein** — datierter Bericht; ausgerechnet dessen Abschnitt L-9.11 heißt *„18 Verweise ins Leere"* |

### L-13.6 — 148 Fundstellen im Quelltext zeigen ins Leere (**Klasse, nicht Einzelfall**)

| | |
|---|---|
| **Behauptung** | Über alle 151 MDs stehen **2543** Angaben der Form `Datei.cpp:Zeile` |
| **Gemessen** | **Keine einzige** zeigt hinter das Dateiende — das wäre aufgefallen. Aber bei **148** steht das im selben Atemzug genannte Symbol nicht innerhalb von ±15 Zeilen um die behauptete Stelle. Verteilung: **80 in lebenden Dokumenten** (`BEFUNDE.md` 38, `CHANGELOG.md` 8, `ZIEL.md` 7, `FILTER.md` 7, `Eudora71/OTShim/BEFUND-ANSICHT.md` 7, `PORTIERUNG.md` 3, `ABRUF-PRUEFEN.md` 2, `Eudora71/OTShim/PLAN.md` 2, dazu je eine in `AUFGABEN.md`, `EINSTELLUNGEN.md`, `WEITERMACHEN.md`, `Pruefung/PRUEFUNG-KETTE.md` und zwei Lehren), **68 in datierten Berichten** (`Befunde/PRUEFER-*`, `Befunde/BEENDEN.md` u. a.) |
| **Berichtigt** | **teilweise: 13** — die sechs aus E-85 und die sieben aus `ZIEL.md`, also die, bei denen die Angabe eine **Handlungsanweisung** trägt. Die übrigen 135 stehen aufgeschrieben und unangetastet |

**Warum nicht alle.** Eine Zeilennummer in einem datierten Bericht ist ein
Zeitdokument und war am Tag der Messung richtig ([[review-sieht-nur-den-diff]]
gilt hier andersherum). Gefährlich ist sie nur dort, wo jemand ihr **folgen**
soll. Genau diese Unterscheidung kann ein Skript nicht treffen — deshalb der
Vorschlag unter *Schranken* weiter unten.

### L-13.7 — Drei Werkzeugverweise ohne Werkzeug

| | |
|---|---|
| **Behauptung** | `tools/rekursion-suchen.pl`, `tools/werkzeuge-angeschlossen.pl`, `tools/gibt-es-nicht.pl` |
| **Gemessen** | Keines liegt im Baum. **Alle drei sind harmlos**: `rekursion-suchen.pl` ist unter **PR-8** ausdrücklich als *gelöscht* geführt, `werkzeuge-angeschlossen.pl` ist in `werkzeug-vor-eigenbau.md` als **Vorschlag** bezeichnet, `gibt-es-nicht.pl` ist ein Beispiel |
| **Berichtigt** | **nein** — keine Unwahrheit |

### L-13.8 — Was **nicht** falsch war (gegengeprüft)

Der Auftrag nennt fünf Verdachtsfelder. Drei davon halten der Messung stand,
und das gehört genauso ins Protokoll wie die Funde:

| Verdacht | Gemessen | Urteil |
|---|---|---|
| **Testzahl 166 stimmt nicht** | Statisch gezählt: **164** `TT_BeginTest`-Aufrufe in den Testquellen — auf `main` wie auf `e103`. Sah nach einem Fehler um 2 aus. **Dann das Testprogramm laufen lassen: `Ergebnis: 166 Tests, 166 bestanden, 0 fehlgeschlagen`** | **Die Doku hat recht, meine Zählung war falsch.** Der Zähler steht in `TT_BeginTest`; zwei Aufrufe erreicht meine Textsuche nicht. [[pruefen-statt-vermuten]] — beinahe hätte ich eine richtige Zahl „berichtigt" |
| **`tools/WERKZEUGE.md` unvollständig** | 99 Dateien in `tools/` (ohne `.md`), **99 in der Übersicht**; umgekehrt **kein** Eintrag ohne Datei | **vollständig, in beide Richtungen** |
| **Gelöschte Testverzeichnisse** | 90 Nennungen von `Eudora72-1.0.<n>-release` in den MDs. Gregor hat `-1.0.53` bis `-1.0.64` gelöscht; geblieben sind `-1.0.65-release` und drei ZIPs | **Keine Anweisung zeigt auf ein gelöschtes Verzeichnis.** Alle Nennungen sind datierte Messprotokolle (*„Nachgemessen am 11.09.2026 in …"*) — Zeitdokumente, keine Wegbeschreibungen. `AUFGABEN.md` nennt `Releases/Eudora72-1.0.65-release` und das trifft zu |
| **Zahl der offenen Befunde** | 12 offen / 68 behoben / 100 Kennungen, `WEITERMACHEN.md` deckt alle 12 | **stimmt** |
| **Kriterien in `ZIEL.md`** | Neun, sieben belegt (0,1,3,5,6,7,8), zwei fast (2,4) — `WEITERMACHEN.md` sagt dasselbe | **widerspruchsfrei** |

## Die Schranken: welche stumm blieb

Alle acht angeordneten Schranken wurden gefahren. **Alle acht blieben still** —
auch die, die die Funde oben hätten sehen müssen.

| Schranke | Meldung | hätte sie L-13.1 / L-13.2 / L-13.6 sehen können? |
|---|---|---|
| `doku-pruefen.pl` | „Kein Widerspruch gefunden" | nein — prüft Fassungsnummern gegeneinander, nicht gegen GitHub |
| `pruefe-doku-takt.pl` | „Die Fassung ist beschrieben" | nein |
| `pruefe-stand-md.pl` | „Kein Stand-Kopf hinkt hinterher" | nein |
| `offene-befunde.pl` | „Die Liste deckt die offenen Befunde", 12 | **nein — und das ist der Befund, siehe unten** |
| `lehren-schranken.pl` | 70 Lehren, alle gedeckt | nein |
| `pruefe-befundurteile.pl` | 12 offen / 68 behoben | **nein — dieselbe Lücke** |
| `pruefe-behoben-belegt.pl` | **„geprueft (neu oder geaendert) 0"** | **nein — prüft nur den Zuwachs** |
| `pruefe-anzeigetext.pl` | **„gepruefte Zeilen 0"** | **nein — prüft nur den Zuwachs** |

### Befund S-1: `offen` im selben Fettdruck wie `behoben` fällt still hindurch

`offene-befunde.pl` und `pruefe-befundurteile.pl` lesen dieselbe Stelle: die
dritte Spalte, darin das **erste Fettgedruckte**. Und dort gilt:

```perl
# "behoben" schlaegt "offen" - eine Zeile "behoben ... war offen"
# beschreibt einen erledigten Befund.
next if grep { index($w, $_) >= 0 } @erledigt_wort;
```

Die Regel ist für **„behoben … war offen"** gedacht — Vergangenheit. Der
E-85-Eintrag sagte **„behoben … ist noch offen"** — Gegenwart. Beide Wörter
stehen im selben Fettdruck, `behoben` gewinnt, und die Aussage *„eine
Regression, die noch offen ist"* wurde **nie gezählt und nie gemeldet**.

**Gegengeprobt** ([[gegenprobe-umdrehen]]): vor und nach meiner Berichtigung
melden beide Werkzeuge unverändert **12 offen / 68 behoben**. Die Schranke hat
die Berichtigung so wenig bemerkt wie den Fehler.

*Vorschlag, nicht gebaut:* wenn im ersten Fettgedruckten **beide** Wortgruppen
vorkommen **und** das `offen` im Präsens steht (`ist noch offen`, `bleibt
offen`, `weiterhin offen`), ist das kein Urteil, sondern ein Widerspruch — und
gehört gemeldet statt aufgelöst.

### Befund S-2: zwei Schranken prüfen nur den Zuwachs, nicht den Bestand

`pruefe-behoben-belegt.pl` meldet **„geprueft (neu oder geaendert) 0"**,
`pruefe-anzeigetext.pl` **„gepruefte Zeilen 0"**. Beide sehen nur, was sich seit
dem letzten Commit geändert hat. Beim Auftrag *„prüfe den Bestand"* sind sie
damit **konstruktionsbedingt blind** — sie melden „alles in Ordnung" über eine
Menge von null Zeilen.

Das ist für `pruefe-anzeigetext.pl` bewusst so (im Bestand liegen vier alte
Zitate ohne Herkunft, dokumentiert). **Die Meldung sagt es aber nicht.**
*„Jeder zitierte Oberflaechentext nennt seine Herkunft"* über 0 geprüfte Zeilen
liest sich wie ein Freispruch. [[pruefstand-kann-blind-sein]]: ein kaputter und
ein grüner Prüfstand melden beide nichts.

*Vorschlag, nicht gebaut:* wer 0 Zeilen prüft, schreibt nicht den Erfolgssatz,
sondern **„nichts zu prüfen — der Bestand ist nicht abgedeckt"**.

### Befund S-3: keine Schranke prüft eine einzige Fundstelle

**2543 Angaben `Datei:Zeile` in den MDs, und kein Werkzeug sieht sie an.**
`befund-suchen.pl` *sucht* nach Orten, `pruefe-anzeigetext.pl` *verlangt* eine
Fundstelle — aber **keines misst, ob die genannte Stelle trifft**. Das ist die
größte unbewachte Fläche der Dokumentation; L-13.2, L-13.3 und L-13.6 stammen
alle daraus.

*Vorschlag, nicht gebaut:* `tools/fundstellen-pruefen.pl` — jede Angabe
`` `Symbol` … (`datei.cpp:NNN`) `` gegen den Quelltext halten (±15 Zeilen),
`Sandbox/` ausklammern, und **nur die lebenden Dokumente** hart abweisen;
datierte Berichte unter `Befunde/` nur zählen. Die Trennung ist nötig, sonst
schlägt die Schranke bei 68 Zeitdokumenten an, die richtig sind.

## Nicht berichtigt, bewusst

| Stelle | warum |
|---|---|
| 135 der 148 abgewanderten Fundstellen | datierte Berichte oder Stellen ohne Handlungsanweisung; siehe L-13.6 |
| `Befunde/LEKTOR-5.md:483` | datierter Bericht |
| `WEITERMACHEN.md:19`, `ImapDownload.cpp:2798, 3034, 3283` (wirklich 2837, 3074, 3324) | steht in einer Zeile, die selbst mit **„ERLEDIGT — Fassungsgeschichte, kein offener Punkt"** überschrieben ist. Der Inhalt darunter ist trotzdem in der Gegenwart geschrieben (*„Zu tun: …"*) und liest sich für jeden, der die Überschrift überspringt, wie eine offene Aufgabe. **Gregor sollte entscheiden, ob solche Zeilen nicht besser ganz verschwinden** |
| `EINSTELLUNGEN.md` (höchste Fassung 7.2.0.57), `FILTER.md`, `tools/WERKZEUGE.md` (7.2.0.13) | `doku-pruefen.pl` meldet sie als *„Zur Kenntnis"*. Kein Fehler, aber die drei Dateien sind seit 9 bzw. 53 Fassungen nicht gegen den Stand gehalten worden |

## Commits auf diesem Zweig

| | |
|---|---|
| `86b6eb6` | L-13.1 — `v1.0.64` in `tools/RELEASES.md` nachgetragen |
| `9932770` | L-13.1 — `README.md`, `WEITERMACHEN.md`, `AUFGABEN.md`, `Releases/PAKETE.md` |
| `90a5e34` | L-13.2 — der E-85-Eintrag in `BEFUNDE.md` |
| `0c4f228` | L-13.3/L-13.4 — `ZIEL.md`, `CHANGELOG.md`, `agenten-koordinieren.md` |

Nach jedem Schreibzugriff gemessen ([[zeilenenden-nach-jedem-schreibzugriff-messen]]):
**CR=0 in allen berührten Dateien**, Zeilenzahlen geprüft. In `BEFUNDE.md` hatte
ein Ersetzungslauf eine Leerzeile eingefügt (7838 → 7839); sie wurde entfernt,
die Tabelle steht wieder lückenlos von E-84 über E-85 zu E-86.

## Was daraus zu lernen war

**Eine Unwahrheit über den eigenen Auslieferungsstand ist gefährlicher als ein
Fehler im Programm.** Fünf Dokumente sagten, seit dem 13.09. sei nichts
hinausgegangen — während Anwender seit dem Morgen `v1.0.64` herunterluden. Der
Fehler steckte nicht in einem vergessenen Nebensatz, sondern in **jeder**
Datei, die die Frage überhaupt beantwortet, `tools/RELEASES.md` eingeschlossen,
deren einziger Zweck sie ist. Wenn eine Tatsache an fünf Stellen steht, wird
sie an fünf Stellen falsch — [[doku-parallel-nicht-hinterher]] greift nur, wenn
etwas den Anlass gibt, und **das Veröffentlichen war kein Anlass**, weil kein
Werkzeug es begleitet hat.

**Und einmal beinahe andersherum:** die Testzahl 166 sah nach einem Fehler um 2
aus, statisch gezählt, auf beiden Zweigen gleich — ein sauberer Messwert für
eine falsche Größe. Erst der **Lauf** hat es entschieden. Hätte ich die Zahl
„berichtigt", stünde jetzt eine Unwahrheit dort, wo die Wahrheit stand, und sie
trüge meinen Namen ([[pruefen-statt-vermuten]]).
