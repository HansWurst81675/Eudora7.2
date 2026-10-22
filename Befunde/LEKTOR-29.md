# <a id="lektor-29"></a>LEKTOR-29 — F1/F2 gemessen, PRÜFER-23, Testsuite 194

Kurzer Lauf am 13.10.2026 auf `wt/lektor`, nach dem Merge von
`origin/e-112-skalierung` (vorgespult auf `9f5142b`). Umfang: nur die Themen,
die sich seit [LEKTOR-28](LEKTOR-28.md#lektor-28) geändert haben, aber in **allen** MDs gegen den
Bestand gesucht (`grep` über `git ls-files '*.md'`, 195 Dateien, 107 außerhalb
von `Arbeitsweise/`), nicht gegen den Diff. Die Berichte unter `Befunde/`
bleiben, wie sie sind.

Maßstab: `BEFUNDE.md` [E-112](../Intern/BEFUNDE.md#e-112) und `CHANGELOG.md` 7.2.0.85 (F1 und F2 am Bau
`11b6a3a` gemessen: `35x35`, `70x70`, `250x96`, `150x58`, `79x64`), der
Bericht [PRÜFER-23](PRUEFER-23.md) (Urteil auslieferbar, N1–N5), Commit `9f5142b`
(N1, `msgutils.cpp`, Test `TestE89.cpp` (4b), Testsuite 194/194, am laufenden
Programm nicht gemessen) und die Quelle selbst.

## Mängel

### <a id="l-29.1"></a>L-29.1 — F1/F2 standen in acht Dateien weiter als „nicht gebaut“/„nicht gemessen“

| Datei | Belegzitat | geändert |
|---|---|---|
| `WEITERMACHEN.md`, *Paketnummer* | *„`check_to` 0, noch nicht gebaut“*, *„jetzt `11b6a3a`, noch nicht gebaut) — **beide am laufenden Programm nicht als wirksam gemessen**“* | gemessen am Bau `11b6a3a` mit den fünf Werten, PRÜFER-23 und N1 |
| `WEITERMACHEN.md`, *Der nächste Schritt* 3. | *„PRÜFER-22 F1 und F2 danach eingebaut, dort **noch nicht gemessen**“* | am Bau `11b6a3a` gemessen; N1 noch nicht |
| `AUFGABEN.md`, Stand-Kopf und B-Abschnitt | *„F1 und F2 danach eingebaut und dort noch nicht gemessen“* (2×) | ebenso, dazu N1 |
| `ZIEL.md`, Stand | dasselbe, *„Testsuite 193/193“* | ebenso, 194/194 |
| `PORTIERUNG.md`, Stand 13.10. | dasselbe, *„Testsuite 193/193“* | ebenso, 194/194 |
| `README.md`, [E-110](../Intern/BEFUNDE.md#e-110)/[E-112](../Intern/BEFUNDE.md#e-112) | *„was danach noch eingebaut wurde (…), dort noch nicht“* | gemessen für zwei Größen und für nur die Breite; N1 behoben, ungemessen |
| `Releases/PAKETE.md`, 1.0.85 | *Inhalt* „noch nicht gebaut“ (2×); *Nicht gemessen* „F1 (`ac8f030`) und F2“ | Messung an `11b6a3a` unter *Gemessen*; N1 neu unter *Inhalt* und *Nicht gemessen* |
| `Testdaten/README.md`, E-112-Zeile | *„Fuer F1 und F2 erwartet 70x70 und 150x58 — **noch nicht am laufenden Programm gemessen**“* | gemessen; N1-Fall neu (siehe [L-29.3](#l-29.3)) |
| `CHANGELOG.md`, 7.2.0.85, Punkt F1 | *„**Noch nicht gebaut, nicht gemessen.**“* — der Absatz darunter sagt *gemessen* | auf den Absatz verwiesen; F2-Punkt um `11b6a3a` ergänzt |
| `CHANGELOG.md`, *Noch offen*, [E-112](../Intern/BEFUNDE.md#e-112) | *„am laufenden Programm **noch nicht** gemessen“* | gemessen an `11b6a3a`; N1 und Offenes |

`tools/ZWEIGE.md` und `TESTPLAN.md` sagen zu F1/F2 nichts Falsches, unverändert.

### <a id="l-29.2"></a>L-29.2 — PRÜFER-23 und N1 standen in keiner Datei außer dem Bericht

`grep "PRÜFER-23\|PRUEFER-23"` traf nur `Befunde/PRUEFER-23.md`; der Commit
`9f5142b` ändert Quelle, Test und Prüfnachricht, aber keine MD. **Nachgetragen**
in `BEFUNDE.md` [E-112](../Intern/BEFUNDE.md#e-112) (Urteil, N1 mit Datei:Zeile vor und nach der Behebung,
N2–N5 je ein Satz mit den Stellen aus PRÜFER-23), im `CHANGELOG.md` 7.2.0.85
(eigener Absatz, Testsuite 194/194) und in den Stand-Zeilen aus [L-29.1](#l-29.1).

### <a id="l-29.3"></a>L-29.3 — N1 ist nur zur Hälfte behoben

PRÜFER-23 N1 nennt zwei Richtungen: Breite über 600 ohne Höhe → `height="1"`
und, *„Gegenrichtung `:3663-3669`“*, Höhe über 600 ohne Breite → `width="1"`.
`9f5142b` umschließt nur die erste (`msgutils.cpp:3654-3666`, `if (nHoehe > 0)`).
Der Höhendeckel `msgutils.cpp:3668-3677` rechnet weiter
`nBreite = nBreite * 600 / nHoehe` und setzt 0 auf **1**; `nBreite <= 0` mit
`nHoehe > 0` läuft an `:3626-3645` vorbei bis dorthin. Aus `<img height="900">`
wird also weiter `width="1" height="600"`. **Aus der Quelle gelesen, nicht
gemessen, kein Test.** In `BEFUNDE.md`, `CHANGELOG.md`, `WEITERMACHEN.md`,
`AUFGABEN.md` und `Releases/PAKETE.md` als offen vermerkt; an der Quelle nichts
geändert.

### <a id="l-29.4"></a>L-29.4 — die Prüfnachricht hat ein sechstes Bild, die Beschreibung zählte fünf

`9f5142b` fügt `Testdaten/e112-bilder-groesser-als-angegeben.eml` das Banner
mit `width="1200"` hinzu. `Testdaten/README.md` sagte *„Die fuenf
`<img>`-Angaben“* und *„112 CRLF“*. Gemessen: 6 `<img>`, 114 CRLF, 0 nackte LF,
0 Bytes ≥ 0x80. Berichtigt, mit dem Erwartungswert für N1 (600×230 =
600·378/985, gerundet).

### <a id="l-29.5"></a>L-29.5 — `pruefe-befundurteile.pl` las „N1 behoben“ als „E-116 behoben“

Nach meiner Berichtigung in `PORTIERUNG.md` (*„PRÜFER-23 N1 behoben und dort
noch nicht gemessen; neu [[E-116](../Intern/BEFUNDE.md#e-116)]“*) meldete die Schranke *„PORTIERUNG.md:44
nennt [E-116](../Intern/BEFUNDE.md#e-116) als 'behoben'“*. Das Wort gehörte zu N1, nicht zu [E-116](../Intern/BEFUNDE.md#e-116); der Satz
ist umgestellt (*„N1 eingebaut (Test grün)“*). Ein Fehlalarm derselben Art wie
[L-28.9](LEKTOR-28.md#l-28.9) — die Schranke ordnet ein Urteilswort dem Absatz zu, nicht dem Satzglied.
Nur gemeldet.

### <a id="l-29.6"></a>L-29.6 — der Commit hing an Spiegelkopien eines laufenden CHRONIST

Der erste Commit wies ab: `lehren-spiegeln.pl` legte fünf Dateien unter
`Arbeitsweise/` ab (`MEMORY.md`, `erlaubnis-nicht-hineinlesen.md`,
`messung-muss-den-weg-treffen.md`, neu `CHRONIST-2026-10-13c.md`,
`quelle-muss-im-bau-stehen.md`). Mit `cmp`: gegen `origin/e-112-skalierung`
alle verschieden bzw. dort nicht vorhanden, gegen den Arbeitsbaum
`Eudora7.2-wt-chronist` alle **byte-gleich** — dort liegen sie gestaget, nicht
committet, zusammen mit `tools/wer-baut.pl`. Dritte Wiederholung von
[L-27.13](LEKTOR-27.md#l-27.13). Kurz darauf lag `78ec234` auf `origin/wt/chronist`, alle fünf
byte-gleich. Gelöst ohne Haken zu umgehen und ohne etwas zu verwerfen: alles mit
`git stash push -u` gesichert (*„[LEKTOR-29](#lektor-29): eigene Aenderungen und Spiegelreste
vor Merge wt/chronist“*), `origin/wt/chronist` gemergt (vorgespult auf
`78ec234`), meine elf Dateien aus der Sicherung zurückgeholt. Die Sicherung
liegt noch; ihre Spiegelkopien sind byte-gleich mit dem Gemergten. **Folge:**
`wt/lektor` enthält `78ec234`; das war nicht Teil des Auftrags.

## Nachgemessen

`offene-befunde.pl` 30/30. `commit-bereit.pl`: 27 von 28 grün, die eine Rote
aus [L-29.5](#l-29.5) nach der Umstellung grün. `befunde-verlinken.pl --verlinken`:
*„Jede Kennung ist ein Link“*. Alle geänderten MDs: UTF-8 ohne BOM, nur LF,
0 U+FFFD.
