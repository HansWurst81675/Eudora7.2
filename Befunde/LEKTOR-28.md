# <a id="lektor-28"></a>LEKTOR-28 — Die Dokumentation zum Quellstand 7.2.0.85

Lauf am 13.10.2026 auf `wt/lektor`, vor einem Paket 1.0.85. Vorher
`origin/e-112-skalierung` gemergt (vorgespult auf `c294594`), mitten im Lauf
noch einmal (vorgespult auf `ac8f030`, F1 neu) und `origin/wt/chronist`
(`6786226`, Merge `9a28ae9`, siehe [L-28.8](#l-28.8)). Umfang: `git ls-files '*.md'`,
**193** Dateien, davon **105** außerhalb von `Arbeitsweise/`, gegen den **Bestand**
gelesen, nicht gegen den Diff. Die Berichte unter `Befunde/` (auch
`PRUEFER-22.md`) sind Fahrtenbuch ihres Tages und bleiben, wie sie sind.

Maßstab sind die Urteilszeilen in `BEFUNDE.md` und die Commits des Zweigs:
[E-112](../BEFUNDE.md#e-112) behoben in 7.2.0.85 (`a36c47f`) und an `a36c47f` am laufenden Programm
gemessen (`7892194`, `C:\Temp\E112-1085`, Titelzeile `1.0.85+a36c47f*`), mit ihm
[E-103](../BEFUNDE.md#e-103); PRÜFER-22 F1 und F2 danach eingebaut; [E-116](../BEFUNDE.md#e-116) neu und offen; nichts
davon von Gregor bestätigt, nichts ausgeliefert.

Mechanisch vorher: `offene-befunde.pl` (30/30), `doku-pruefen.pl`,
`pruefe-stand-md.pl`, `pruefe-befundurteile.pl` und `pruefe-befund-verbreitung.pl`
**alle grün** — während sieben Dateien 7.2.0.85 falsch oder gar nicht
beschrieben. **Gefunden hat die Mängel keine Schranke.** Zwei Meldungen kamen
erst durch meine Berichtigungen ([L-28.9](#l-28.9)).

## Mängel

### <a id="l-28.1"></a>L-28.1 — die Messung am laufenden Programm war nirgends nachgetragen

`7892194` hat [E-112](../BEFUNDE.md#e-112) und [E-103](../BEFUNDE.md#e-103) an 7.2.0.85 gemessen und `BEFUNDE.md` nachgezogen.
Stehen geblieben waren:

| Datei | Belegzitat | geändert |
|---|---|---|
| `CHANGELOG.md`, 7.2.0.85 | *„**Testsuite 193/193.** Am laufenden Programm noch nicht gemessen.“* | Messung mit Spurmarken, danach F1, F2, [E-116](../BEFUNDE.md#e-116) |
| `CHANGELOG.md`, *Noch offen* | [E-112](../BEFUNDE.md#e-112) *„**Wieder offen.** Der Versuch in 7.2.0.76 wirkt nicht …“* | *behoben in 7.2.0.85, nicht ausgeliefert, nicht bestätigt*; der alte Befund als Lage von `v1.0.84` |
| `WEITERMACHEN.md`, *Paketnummer* | *„Testsuite 193/193, am laufenden Programm noch nicht gemessen“*; *„**Nächster Schritt: [E-112](../BEFUNDE.md#e-112).**“* | neu gefasst |
| `Releases/PAKETE.md`, 1.0.85 | Überschrift *„nicht gebaut“*; *Nicht gemessen: am laufenden Programm* | *kein Paket*; Messung an `a36c47f` unter *Gemessen* |

### <a id="l-28.2"></a>L-28.2 — der Quellstand hieß an drei Stellen noch 7.2.0.84

`WEITERMACHEN.md`, Zeile *Quellstand*: *„7.2.0.84 (`Eudora71/Version.h`)“* —
Damals, zum Zeitpunkt dieses Berichts, stand `Version.h` auf 7.2.0.85 und die Zeile *Paketnummer* direkt darunter auf 1.0.85.
`ZIEL.md`, Stand-Kopf: *„**Quellstand ist jetzt 7.2.0.84 / Paket 1.0.84**“*.
`PORTIERUNG.md`: der jüngste Stand-Kasten war vom 12.10.2026 (7.2.0.84).
**Geändert (3 Stellen):** 7.2.0.85 in Arbeit vorangestellt, 7.2.0.84 als zuletzt
veröffentlicht; in `PORTIERUNG.md` ein Kasten vom 13.10.2026 über dem alten.
`doku-pruefen.pl` meldete zu `PORTIERUNG.md` und `ZIEL.md` nur *zur Kenntnis*.

### <a id="l-28.3"></a>L-28.3 — E-103 „noch nicht beurteilt“, nachdem Gregor es widerlegt hatte

`ZIEL.md`: *„**Noch nicht von ihm beurteilt** sind [E-100](../BEFUNDE.md#e-100) (7.2.0.65), **[E-103](../BEFUNDE.md#e-103)**
(7.2.0.67) und [E-104](../BEFUNDE.md#e-104)“* — `BEFUNDE.md` führt seit `a74a1ff` *„WIEDER OFFEN — an
1.0.84 von Gregor widerlegt (13.10.2026)“*. `README.md` zählt [E-103](../BEFUNDE.md#e-103) unter *Seit
`v1.0.72` im Download enthalten* nur als behoben. `AUFGABEN.md` (*Durchgefallen*)
und `WEITERMACHEN.md` (*Gregors Test an 1.0.84*) nannten [E-112](../BEFUNDE.md#e-112), nicht [E-103](../BEFUNDE.md#e-103).
**Geändert (4 Stellen)**, jeweils mit *seither in 7.2.0.85 behoben, nicht
ausgeliefert*. In `WEITERMACHEN.md` die Zeile *DURCHGEFALLEN an 1.0.84 — [E-103](../BEFUNDE.md#e-103)*
mit dem neuen Stand davor; der Wortlaut von 1.0.84 bleibt als solcher stehen.

### <a id="l-28.4"></a>L-28.4 — `AUFGABEN.md` und `README.md`: E-112 nur als „wieder offen“

`AUFGABEN.md`: Überschrift *„**Am 18.09.2026 behoben: [E-110](../BEFUNDE.md#e-110) und [E-112](../BEFUNDE.md#e-112).**“* —
[L-27.3](LEKTOR-27.md#l-27.3) hatte den Absatz darunter berichtigt, die Überschrift nicht;
Stand-Kopf und Absatz kannten die Behebung in 7.2.0.85 nicht. `README.md`:
*„**Dabei wurde [E-112](../BEFUNDE.md#e-112) sichtbar** (**wieder offen**)“* ohne 7.2.0.85.
**Geändert:** `AUFGABEN.md` 4 Stellen (Stand-Kopf, Stand-Kasten, Überschrift,
Absatz), `README.md` 2 Stellen. In `README.md` bleibt *wieder offen* stehen,
denn der Download `v1.0.84` hat den Fehler; dahinter steht jetzt die Behebung
als *nicht ausgeliefert*.

### <a id="l-28.5"></a>L-28.5 — `WEITERMACHEN.md`, *Der nächste Schritt*: Punkt 3 schon erledigt

*„**3. [E-112](../BEFUNDE.md#e-112) messen, BEVOR wieder etwas gebaut wird.** Die eine offene Frage:
`draw_meta_file` … **Ungemessen ist:** …“* — gemessen und gebaut in `a36c47f`.
Punkt 4 (*„Wer Gregor vor der Behebung ein Paket gibt, muss das wissen.“*) sagte
nicht, ab wann es nicht mehr gilt. **Geändert:** Punkt 3 mit *erledigt* und der
gemessenen Ursache, der alte Wortlaut als *Bisher* darunter; Punkt 4 um *„Diese
Lage hat jedes Paket bis einschließlich `v1.0.84`“* ergänzt.

### <a id="l-28.6"></a>L-28.6 — die Messung lief vor F1 und F2, und das stand nirgends

Die Laufmessung (`7892194`) hat `a36c47f` gemessen; F1 (`dae6727`) und F2
(`c294594`) kamen danach. Gemessen an der Titelzeile in `tools/TESTLAEUFE.md`
(`1.0.85+a36c47f*`) und den Zeitstempeln: `C:\Temp\E112-1085\Eudora.exe`
11:09:27, `dae6727` 11:21:51, `c294594` 11:29:25. `BEFUNDE.md` ([E-112](../BEFUNDE.md#e-112)) schrieb
*„BEHOBEN IN 7.2.0.85, am laufenden Programm gemessen“* über eine Zelle, in der
F1 als *„in `dae6727` behoben“* und F2 als eingebaut stand. Wer das liest, hält
alle drei für gemessen. **Geändert:** in `BEFUNDE.md` ([E-112](../BEFUNDE.md#e-112) und [E-103](../BEFUNDE.md#e-103)),
`CHANGELOG.md`, `WEITERMACHEN.md`, `Releases/PAKETE.md`, `ZIEL.md`, `AUFGABEN.md`
und `PORTIERUNG.md` steht jetzt, dass die Messung an `a36c47f` war und F1/F2 am
laufenden Programm nicht als wirksam gemessen sind. In `BEFUNDE.md` ([E-103](../BEFUNDE.md#e-103)): F2
ändert die Regel für eine halbe Angabe, nicht den Fall ganz ohne Angabe.

### <a id="l-28.7"></a>L-28.7 — F1 stand als Änderung an `PGEMBED.C` da, die nichts bewirkt

Nachtrag des Auftraggebers mitten im Lauf, belegt durch `ac8f030`: *„Die
Aenderung aus dae6727 an PGEMBED.C war wirkungslos: Paige32.dll wird nicht aus
dem Quelltext gebaut (nur Paige32.vcproj, nicht in Eudora.sln). Am laufenden
Programm gemessen: dasselbe Logo als 70x70 kam weiter als 35x35, das Banner mit
width=150 als 250x96“*. F1 sitzt jetzt in `PGHTMIMP.CPP` (`pgNewImageRecord` mit
`check_to` 0), *„Noch nicht gebaut.“* Dass `Paige32` nicht aus dem Quelltext
entsteht, steht in `BEFUNDE.md` schon seit Langem (Tabelle der Module:
*„Paige32 | **nein** — `Eudora71/PaigeDLL` enthaelt nur Makefiles …“*).

Falsch waren: `BEFUNDE.md` [E-112](../BEFUNDE.md#e-112) *„F1 … ist in `dae6727` behoben“*, und meine
eigenen Einträge aus diesem Lauf in `CHANGELOG.md`, `Releases/PAKETE.md` und
`WEITERMACHEN.md` (*„F1 (`dae6727`, `PGEMBED.C`: gleiche URL nur bei gleicher
Größenangabe teilen)“*). **Geändert (5 Stellen):** `dae6727` als wirkungslos und
zurückgenommen, F1 jetzt in `PGHTMIMP.CPP`, *noch nicht gebaut, nicht gemessen*.
**Nachtrag, nach dem Merge von `11b6a3a`:** auch F2 aus `c294594` war am
Ladeweg wirkungslos — gemessen an `ac8f030`, *„<img width=150> kam als
angegeben=0x0 und wurde in Dateigroesse 985x378 gemalt - embed->width/height ist
bei halber Angabe an dieser Stelle noch 0“*. Meine erste Lesart (F2 sei nur
hinter dem Teilen aus F1 verdeckt) war falsch und ist berichtigt; F2 sitzt jetzt
in `PgEmbeddedImage.cpp` (`11b6a3a`), noch nicht gebaut. Nachgezogen in
`BEFUNDE.md`, `CHANGELOG.md`, `WEITERMACHEN.md`, `Releases/PAKETE.md` (5 Stellen). **Ausdrücklich nichts** zu F1 als
*gemessen* eingetragen — die Messung des neuen Baus läuft beim Auftraggeber.
`Befunde/PRUEFER-22.md` nennt `PGEMBED.C:1828-1846` als **Ort der Ursache**; das
stimmt und bleibt stehen.

### <a id="l-28.8"></a>L-28.8 — E-116 fehlte unter *Noch offen*, die Prüfnachricht im Verzeichnis

[E-116](../BEFUNDE.md#e-116) stand nur in `BEFUNDE.md` und in der erzeugten Liste in
`WEITERMACHEN.md`. **Nachgetragen:** `CHANGELOG.md` *Noch offen* (eigene Zeile,
Wortlaut aus der Urteilszeile), `AUFGABEN.md` *Was sonst noch offen ist*,
Stand-Köpfe in `ZIEL.md` und `PORTIERUNG.md`, `README.md` (*erst mit dieser
Behebung sichtbar*), `Releases/PAKETE.md`, `tools/ZWEIGE.md` (Zweck von
`e-112-skalierung` um F1, F2, [E-116](../BEFUNDE.md#e-116) ergänzt).

`Testdaten/README.md` führte `e112-bilder-groesser-als-angegeben.eml` (seit
`7892194`) nicht. **Zeile ergänzt**, gemessen: 112 CRLF, 0 nackte LF, 0 Bytes ≥
0x80, fünf `<img>`; `pruefe-testdaten-anonym.pl` grün (6 Dateien). Die Zeile zu
`e103-bild-ohne-groessenangabe.eml` nennt jetzt auch den Rückfall an 1.0.84 und
7.2.0.85. Nicht nachgetragen: die Tabelle *gemessen vor und nach der
Anonymisierung* — die Datei ist gebaut, nicht anonymisiert.

### <a id="l-28.9"></a>L-28.9 — zwei Schranken meldeten erst an meinen Berichtigungen, eine davon zu Unrecht

* `doku-pruefen.pl`: *„ZIEL.md:17 nennt Paketnummer 1.0.84 als Stand, VERSION
  sagt 1.0.85“* — an meinem Satz *„Zuletzt veröffentlicht ist 7.2.0.84 / Paket
  1.0.84“*. Das Werkzeug nimmt das Wort *Zuletzt veröffentlicht* als Auslöser
  und verlangt danach die Nummer aus `VERSION`. Das stimmt nur, solange nichts in
  Arbeit ist; zwischen zwei Paketen ist es ein **Fehlalarm**. Umformuliert
  (*„Die letzte Veröffentlichung ist …“*). **Werkzeug nicht geändert, nur
  gemeldet.**
* `pruefe-befundurteile.pl`: *„WEITERMACHEN.md:10 nennt [E-116](../BEFUNDE.md#e-116) als 'behoben'“* —
  zu Recht, im Sinne der Schranke: in derselben Zelle steht *behoben* zu [E-112](../BEFUNDE.md#e-112).
  [E-116](../BEFUNDE.md#e-116) trägt dort jetzt *offen*.

Und wieder: nach dem ersten Lauf von `offene-befunde.pl`, `doku-pruefen.pl`,
`pruefe-befundurteile.pl` und `pruefe-befund-verbreitung.pl` waren alle grün,
während [L-28.1](#l-28.1) bis [L-28.8](#l-28.8) offen lagen. Keine dieser Schranken vergleicht eine
Aussage über die Messung mit dem Commit, an dem sie gemacht wurde.

### <a id="l-28.10"></a>L-28.10 — [L-27.13](LEKTOR-27.md#l-27.13) zweimal in einem Lauf

**Zu Beginn:** in `wt/lektor` lagen 11 geänderte und 1 neue Datei unter
`Arbeitsweise/` (Spiegelkopien). Gegen `origin/e-112-skalierung` mit `cmp`:
**10 byte-gleich** (`LEHREN-AUS-DEM-CHAT.md`, `chat-knapp-halten.md`,
`doku-parallel-nicht-hinterher.md`, `erlaubnis-nicht-hineinlesen.md`,
`erst-pruefen-dann-anweisen.md`, `nichts-auf-gregors-bildschirm-starten.md`,
`review-sieht-nur-den-diff.md`, `testdaten-muessen-durchkommen.md`,
`text-nicht-durch-schichten-schicken.md`, neu `CHRONIST-2026-10-13.md`),
**2 verschieden**: `MEMORY.md` und `README.md` — beiden fehlte gegenüber dem
Zweig genau **eine** Zeile (`fehlerbild-ist-ein-messfenster`), sie waren also
eine ältere Spiegelung. Die neun geänderten byte-gleichen mit `git checkout --`
zurückgesetzt. Der Merge brach danach ab: die **unversionierte**
`CHRONIST-2026-10-13.md` und die zwei verschiedenen hätten überschrieben werden
müssen. Nichts verworfen: die drei mit `git stash push -u` gesichert
(`stash@{0}`, *„[LEKTOR-28](#lektor-28): Spiegelreste vor Merge e-112“*), dann gemergt. Die
Sicherung liegt noch; ihr Inhalt ist eine Teilmenge des Gemergten bzw.
byte-gleich (`CHRONIST-2026-10-13.md`, mit `cmp` gegen `stash@{0}^3`).

**Mitten im Lauf:** der erste Commit wies ab — `lehren-schranken.pl`:
*„Arbeitsweise/commit-auf-einmal-pruefen.md nennt tools/commit-bereit.pl - die
Datei gibt es nicht“*. Der CHRONIST hatte um 11:35 gleichzeitig zwei neue Lehren
und ein neues Werkzeug geschrieben; der `pre-commit` spiegelte die Lehren
hierher, das Werkzeug lag nur in `Eudora7.2-wt-chronist`. Sieben Dateien,
alle byte-gleich mit `origin/wt/chronist` (`6786226`). Gelöst ohne Haken zu
umgehen: die vier geänderten zurückgesetzt, die drei neuen in den Notizordner
verschoben (danach mit `cmp` gegen die gemergten gleich), meine Änderungen mit
`git stash` gesichert, `origin/e-112-skalierung` vorgespult, `origin/wt/chronist`
gemergt (`9a28ae9`), Sicherung zurückgeholt. **Folge:** `wt/lektor` enthält
`6786226`. Das war nicht Teil des Auftrags; ohne es ließ sich nicht committen.

**Die Klasse besteht weiter:** jeder CHRONIST-Lauf blockiert die Commits aller
anderen Arbeitsbäume, bis sein Zweig dort gemergt ist. Nicht behoben —
`lehren-spiegeln.pl` liest das gemeinsame Gedächtnis, und was dort stehen
darf, ist keine Entscheidung eines Arbeitsbaums.

## Was nicht berichtigt ist

* **`TESTPLAN.md`** hat keinen Prüfschritt für 1.0.85 ([E-112](../BEFUNDE.md#e-112), F1, F2). Das ist
  eine Anleitung an Gregor; sie schreibt, wer das Paket schnürt, nachdem F1 und
  F2 gemessen sind.
* `Befunde/PRUEFER-22.md` und die übrigen Berichte: Fahrtenbuch.
* `doku-pruefen.pl` *zur Kenntnis*: `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`,
  `tools/pruefdaten/LIESMICH.md` nennen 7.2.0.85 nicht — keine trägt einen
  Stand-Kopf, der es verlangte.
* Der Fehlalarm in `doku-pruefen.pl` ([L-28.9](#l-28.9)) und die Spiegelung
  ([L-28.10](#l-28.10)).
* Weiter offen aus [LEKTOR-27](LEKTOR-27.md#lektor-27): vier doppelte Werkzeugzeilen in
  `tools/WERKZEUGE.md`, der Widerspruch im Abschnitt 1.0.29 von
  `Releases/PAKETE.md`, der veraltete eingerichtete `pre-commit`.

## Werkzeuge nachher

`offene-befunde.pl` 30/30, *„Die Liste deckt die offenen Befunde.“*;
`doku-pruefen.pl` *„Kein Widerspruch gefunden.“*; `pruefe-stand-md.pl` *„Kein
Stand-Kopf hinkt hinterher.“*; `pruefe-befundurteile.pl` *„Kein Dokument
erklaert einen offenen Befund fuer erledigt“*; `pruefe-befund-verbreitung.pl`
grün; `befunde-verlinken.pl --verlinken` *„Jede Kennung ist ein Link“*.
`BEFUNDE.md`: 8631 Zeilen, 128 und 233 Abschnitte (Kopfzeile nachgezogen).
