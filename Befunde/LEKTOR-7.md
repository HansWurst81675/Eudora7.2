# LEKTOR-7 — zwölfter Durchgang (L-12), 13.09.2026

Gemessen an Quellstand **7.2.0.51** / Paket **1.0.51**. Geprüft wurde der
**Bestand**, nicht der Diff: `git ls-files "*.md"` lieferte **125** Dateien,
nicht die 47 aus L-8.

Anlass war **E-85** (Umlaute über IMAP), an diesem Tag in drei Schritten
behoben. Der Durchgang hat dabei einen Befund gefunden, der wichtiger ist als
alle Textstellen zusammen: **die Doku beschrieb E-85 durchgehend im falschen
Zustand — erst als offen, obwohl behoben; dann als behoben, obwohl eine
Regression offen war; dann als regressionsbehaftet, obwohl die auch schon
geschlossen war.** Dreimal derselbe Mangel innerhalb von zwei Stunden.

---

## 1. Was geändert wurde

| Commit | Datei | Was falsch war |
|---|---|---|
| `b686c32` | `AUFGABEN.md` | Stand-Zeile nannte 7.2.0.50 / 1.0.50, der Baum stand auf 7.2.0.51 / 1.0.51. `pruefe-stand-md.pl` ging von 1 auf 0 |
| `6e4fca9` | `ZIEL.md` | Kriterium 2 führte E-85 als *„noch nicht behoben"*, obwohl vier Commits im Zweig es beheben. Stand-Zeile auf 7.2.0.51 nachgezogen |
| `48c1ee2` | `BEFUNDE.md` | E-85 Punkt **(0)** — der schwerwiegendste — stand im Präsens da, als wäre er offen; nur (1) und (2) trugen „behoben in 7.2.0.51" |
| `65a131e` | `WEITERMACHEN.md` | die Einstiegsdatei sagte *„Noch kein Befundeintrag geschrieben, noch kein Zweig angelegt"*. Beides war da |
| `ae764b3` | `ZIEL.md`, `PORTIERUNG.md` | *„Beiden fehlt dasselbe"* stimmte nach `ed4a345` nicht mehr — Kriterium 2 zählt seither drei Punkte. Dazu drei Nebenbefunde in `PORTIERUNG.md`, die den IMAP-Weg als offen führten |
| `20f4820` | `BEFUNDE.md`, `ZIEL.md`, `WEITERMACHEN.md` | die Doku sagte „behoben" und verschwieg die von PRUEFER belegte Regression |
| `6875756` | `tools/WERKZEUGE.md` | **sieben von 82 Werkzeugen fehlten** in der Übersicht |
| `2bbc573` | `ZIEL.md`, `WEITERMACHEN.md` | **meine eigene Berichtigung** hatte fünf Fehlalarme in `pruefe-befundurteile.pl` ausgelöst |
| `f65f526` | `BEFUNDE.md`, `ZIEL.md`, `WEITERMACHEN.md` | die Regression war inzwischen behoben, die Doku führte sie noch als offen |

### Die Zeilenangaben, gegen die geprüft wurde

Jede Aussage über E-85 wurde am Quelltext nachgemessen, nicht aus einer
Commit-Nachricht übernommen:

| Stelle | Inhalt |
|---|---|
| `ImapDownload.cpp:4671` | `iCharsetIdx = FindMIMECharset(params->value)` |
| `ImapDownload.cpp:4688` | `if (iCharsetIdx > 2)` |
| `ImapDownload.cpp:4705` | `LONG lUebersetzt = ISOTranslateChunk(...)` |
| `utils.cpp:1269` | `LONG ISOTranslateChunk(char** ppBuf, ...)` |
| `utils.h:93` | dieselbe Signatur |
| `resource.h:1809/1810` | `IDS_MIME_ISO_LATIN9` = 3613, `IDS_MIME_UTF_8` = 3614 |
| `mime.cpp:382` | `FindMIMECharset` |
| `utils.cpp:1443` | `szBuf[lSize] = 0` — die Regression |
| `utils.cpp:1308-1310`, `:1393-1395` | ihre Behebung (Byte retten und zurückschreiben) |

Alle acht Angaben aus dem bestehenden E-85-Eintrag stimmten. Die Zahlen 4645
und 4662 beschreiben den Zustand **vor** der Behebung; sie sind jetzt als
solche gekennzeichnet statt als Ist-Zustand.

---

## 2. Gemessen und NICHT geändert

### a) `pruefe-befundurteile.pl` meldet einen Altbefund, der bleibt

    ./ZIEL.md:31 nennt E-77 als 'behoben' - BEFUNDE.md fuehrt ihn OFFEN

**Gegengemessen an `origin/main` in einem eigenen Wegwerf-Baum: dieser Mangel
bestand schon vor diesem Durchgang.** Ursache ist strukturell: Kriterium 2 ist
**eine** Tabellenzeile, die erfüllte, offene und behobene Befunde zusammen
nennt — das Wort „behoben" gehört zu E-85, E-77 steht in derselben Zeile. Das
Werkzeug bietet als Freistellung das Wort „Berichtigung" an; es einzusetzen
wäre hier ein Kunstgriff, um die Schranke stumm zu stellen, kein Beleg.
**Zu lösen wäre es nur, indem Kriterium 2 in mehrere Zeilen zerfällt** — das
ist eine Entscheidung über den Aufbau von `ZIEL.md` und gehört Gregor.

### b) `tools/RELEASES.md` hat ein BOM und CRLF

Gemessen: `BOM=JA`, `CR=27`. Alle anderen 124 MD-Dateien sind BOM-frei mit
reinen LF. Die Datei wird von `tools/release-veroeffentlichen.ps1`
fortgeschrieben, und PowerShell schreibt so. **Nicht angefasst:** eine
Umstellung auf LF kann das anhängende Skript stören, und das ist ohne
Gegentest nicht zu entscheiden.

### c) `EINSTELLUNGEN.md` und `FILTER.md` — der Kopf fehlt, der Inhalt trägt

Auftragsfrage war, ob bei den Dateien ohne Stand-Kopf nur der Kopf fehlt oder
der Inhalt veraltet ist. Gemessen:

- **`FILTER.md`** (733 Zeilen, zuletzt 11.09.2026): trägt. Die Aussage zu den
  INI-Abschnitten ist seit E-79 berichtigt, und `doku-pruefen.pl` meldet
  ausdrücklich *„INI-Abschnitte: alle Angaben stimmen mit GetSectionID
  überein"*.
- **`EINSTELLUNGEN.md`** (229 Zeilen, zuletzt 13.09.2026): trägt. Abschnitt 4.6
  führt E-77 als offen — das stimmt mit `BEFUNDE.md` überein.
- **`tools/WERKZEUGE.md`**: **trug nicht.** Sieben Werkzeuge fehlten, siehe
  oben. Das war die einzige der vier Dateien mit einem Inhaltsmangel.

Keine der drei bekommt von mir einen Stand-Kopf: sie beschreiben Verhalten,
das sich nicht je Fassung ändert. `doku-pruefen.pl` führt sie deshalb unter
„Zur Kenntnis" und nicht als Mangel — das ist richtig so.

---

## 3. Befunde für andere

### L-12a — ein Zweig wurde unter dem laufenden Agenten umbenannt

`wt/lektor` war beim Start auf `82a6d6f` und hatte ein Gegenstück auf dem
Server. Beim ersten Commit wies `pruefe-branch.pl` ab: *„das Gegenstück
`@{u}` gibt es auf dem Server nicht mehr."* **Gemessen:** der Zweig war nicht
gelöscht, sondern in `fix-imap_utf8` **umbenannt** — `git ls-remote` zeigte ihn
auf demselben Commit `82a6d6f`. Es ging nichts verloren; die Schranke hat
richtig gemeldet und mit ihrer Meldung genau das verhindert, wovor sie warnt.

**Aber sie nennt die Umbenennung nicht als Möglichkeit.** Ihr Text bietet nur
„gelöscht" an und rät zu `git rebase --onto origin/main`. Wer dem ungeprüft
folgt, baut sich aus einer harmlosen Umbenennung einen Rebase. Ein Blick in
`git ls-remote --heads origin` würde den Fall auseinanderhalten.

### L-12b — eine Lehre machte einen fremden Arbeitsbaum committierunfähig (X-8, zweite Auflage)

Das Gedächtnissystem legte `Arbeitsweise/pruefstand-kann-blind-sein.md` in
**meinen** Arbeitsbaum. Die Lehre nennt als Schranke `tools/pruefe-testbau.pl`
— ein Werkzeug, das es in `origin/main` und in `origin/fix-imap_utf8` nicht
gab, sondern allein in `wt/chronist`. Folge: `lehren-schranken.pl` wies jeden
Commit ab (*„nennt tools/pruefe-testbau.pl — die Datei gibt es nicht"*),
während der `pre-commit` gleichzeitig verlangte, die Datei mitzucommitten.
**Ein Patt, aus dem der Arbeitsbaum von allein nicht herauskam.**

Das ist **X-8 in neuer Gestalt**: dort war es ein Werkzeug ohne Lehre, hier
eine Lehre ohne Werkzeug. Die damalige Behebung — fehlende Werkzeuge
überspringen — greift in dieser Richtung nicht.

**Weder umgangen noch fremde Dateien kopiert** (`--no-verify` blieb ungenutzt):
aufgelöst durch `git merge origin/wt/chronist`, weil CHRONIST Lehre **und**
Werkzeug bereits committet und gepusht hatte (`d8b66c7`) und beide Zweige
ohnehin auf denselben Sammelzweig zulaufen. Ein Konflikt in
`erfolgsmeldung-aus-dem-ergebnis.md` — meine Seite leer, seine Seite mit
Inhalt — wurde zu seinen Gunsten aufgelöst; das Ergebnis ist byte-identisch
mit seiner Fassung.

**Vorschlag:** `lehren-schranken.pl` sollte ein genanntes Werkzeug, das im
**Arbeitsbaum** fehlt, aber in einem anderen Zweig desselben Repos liegt,
melden statt abzuweisen — dieselbe Unterscheidung, die X-8 eingeführt hat.

### L-12c — eine Berichtigung darf die Schranke nicht lauter machen

Nach `20f4820` meldete `pruefe-befundurteile.pl` **sechs** Mängel. Gegenprobe
gegen `origin/main` in einem Wegwerf-Baum: dort **einer**. Die fünf neuen
waren meine: das Wort **„wartet auf"** steht in der Auslöserliste des
Werkzeugs (Zeile 181), und ich hatte es in zwei Zeilen geschrieben, die noch
andere Befundkennungen nennen — E-7, E-24, E-28, E-30 und E-82 wurden dadurch
gemeldet, obwohl an ihnen nichts falsch war.

Behoben in `2bbc573` durch eine Formulierung ohne das Auslöserwort; **6 → 1**
nachgemessen. Ein Fehlalarm kostet so viel wie eine stumme Prüfung
([[schranke-gegentesten]]) — und eine Schranke, die auf die eigene Berichtigung
anschlägt, wird beim nächsten Mal überlesen.

### L-12d — dreimal derselbe Zustandsfehler an einem Tag

Der eigentliche Befund dieses Durchgangs, in seiner Abfolge:

| Zeit | Was die Doku sagte | Was war |
|---|---|---|
| Start | E-85 *„noch nicht behoben"* | vier Commits im Zweig hatten es behoben |
| nach `20f4820` | E-85 *„behoben"* | eine Regression war offen (PRUEFER-10) |
| nach `f65f526` | Regression *„vor dem Paket zu schließen"* | sie war seit `3092b33` behoben |

Dreimal stand die Doku still, während der Baum weiterlief — und zweimal davon
war **ich** derjenige, dessen Aussage binnen einer Stunde veraltete. Der Grund
ist jedes Mal derselbe: **die Doku wurde gegen den Stand geschrieben, den ich
beim Nachsehen vorfand, und nicht noch einmal gegen den Stand geprüft, den der
Zweig beim Commit hatte.** Zwischen beiden lagen fremde Merges.

**Was es abstellen würde:** vor jedem Doku-Commit `git fetch` und
`git log <meineBasis>..origin/<zweig>` — wenn dort etwas steht, das denselben
Befund anfasst, ist die eigene Aussage zu prüfen, bevor sie eingeht. Das ist
die Doku-Fassung von [[review-sieht-nur-den-diff]]: die unveränderte Datei
steht in keinem Diff, und der fremde Commit steht in keinem eigenen.

---

## 4. Schranken am Ende dieses Durchgangs

| Werkzeug | Rückgabe | Bemerkung |
|---|---|---|
| `tools/doku-pruefen.pl` | **0** | kein Widerspruch; vier Dateien ohne Stand-Angabe bleiben „zur Kenntnis" |
| `tools/pruefe-stand-md.pl` | **0** | zu Beginn 1 (AUFGABEN.md) |
| `tools/pruefe-bytes.pl` | **0** | nach jedem einzelnen Schreibzugriff gefahren |
| `tools/pruefe-befundurteile.pl` | **1** | der eine Altbefund aus 2a, älter als dieser Durchgang |

Alle Rückgabewerte **ohne Pipe** gemessen. Das ist keine Formalie:
`perl … | tail -n; echo $?` liefert den Rückgabewert von `tail`, und `tail`
gelingt immer — dieselbe Falle, die CHRONIST am selben Tag als dritten Fall in
[[erfolgsmeldung-aus-dem-ergebnis]] aufgeschrieben hat. Die ersten Messungen
dieses Durchgangs sind so entstanden und wurden wiederholt.

## Berichtigung, 13.09.2026 — meine Zählung der Werkzeuge war falsch

In der Commit-Nachricht zu `f768087` steht:

> Werkzeuge im Verzeichnis 84, in WERKZEUGE.md 72 — seine Zahl 82 zählte
> anders, die Lücke besteht also fort und ist größer als er sagt.

**Das stimmt nicht.** Nachgemessen mit dem richtigen Maßstab:

```
ls tools/*.pl tools/*.ps1 tools/*.sh        -> 84
Werkzeugnamen in WERKZEUGE.md, alle Formen  -> 84
```

Meine 72 kam aus `grep -c '^| `tools/'` — das zählt nur Tabellenzeilen, die
**mit** der Backtick-Form beginnen. Ein Werkzeug, das im Fließtext oder in einer
anderen Spalte genannt wird, fällt heraus. `pruefe-stand-md-tests.pl` schien
sogar dann noch zu fehlen, als ich alle Backtick-Formen zählte — es steht in der
Datei, nur ohne das `tools/`-Präfix.

**LEKTORs Zahl war richtig, meine war es nicht.** Der Fehler ist derselbe, vor
dem `Arbeitsweise/pruefumfang-nicht-von-hand.md` warnt: ein Maßstab, der enger
ist als die Sache, die er messen soll. Er fällt nicht auf, weil er eine Zahl
liefert — und eine Zahl sieht aus wie eine Messung.

Dass die falsche Zahl in einer **Commit-Nachricht** steht, macht es schlimmer:
die lässt sich nicht mehr ändern, sie geht mit nach `main`, und sie behauptet
dort etwas über die Arbeit eines anderen.
