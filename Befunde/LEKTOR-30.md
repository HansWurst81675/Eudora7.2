# <a id="lektor-30"></a>LEKTOR-30 — N1 und Gegenrichtung gemessen, Testsuite 195

Kurzer Lauf am 13.10.2026 auf `wt/lektor`, nach dem Merge von
`origin/e-112-skalierung` (vorgespult auf `f305f49`). Umfang: nur die Themen
seit [LEKTOR-29](LEKTOR-29.md#lektor-29), aber in **allen** MDs gegen den Bestand gesucht (`grep` über
`git ls-files '*.md'`, 198 Dateien, 108 außerhalb von `Arbeitsweise/`), nicht
gegen den Diff. Die Berichte unter `Befunde/` bleiben, wie sie sind.

Maßstab: `bf96856` (Gegenrichtung von N1 behoben, `msgutils.cpp:3668-3680`,
Test `TestE89.cpp` (4c), Testsuite 195/195), `f305f49` (N1 `600x230` und
Gegenrichtung `606x600` am laufenden Programm gemessen), die Prüfnachricht
`Testdaten/e112-bilder-groesser-als-angegeben.eml` (mit `grep` gezählt: sieben
`<img>`; gemessen 116 CRLF, 0 nackte LF, 0 Bytes ≥ 0x80) und die Quelle selbst.

## Mängel

### <a id="l-30.1"></a>L-30.1 — vier Stand-Absätze sagten weiter „N1 nicht gemessen“, „194/194“

`f305f49` zog die Einzelabschnitte nach, die Stand-Köpfe nicht.

| Datei | Belegzitat | geändert |
|---|---|---|
| `AUFGABEN.md`, Stand-Kopf | *„PRÜFER-23 N1 behoben und dort noch nicht gemessen, Testsuite 194/194“* | N1 und Gegenrichtung am Bau `bf96856` gemessen, 195/195 |
| `ZIEL.md`, Stand | *„Testsuite 194/194 … PRÜFER-23 N1 behoben, dort noch nicht gemessen“* | ebenso |
| `PORTIERUNG.md`, Stand 13.10. | *„Testsuite 194/194 … N1 eingebaut (Test grün), dort noch nicht gemessen“* | ebenso |
| `WEITERMACHEN.md`, *Der nächste Schritt* 3. | *„PRÜFER-23 N1 behoben (`9f5142b`), dort **noch nicht gemessen**“* | beide gemessen (`600x230`, `606x600`) |
| `README.md`, [E-110](../BEFUNDE.md#e-110)/[E-112](../BEFUNDE.md#e-112) | *„ist behoben, aber noch nicht gemessen“* | behoben und gemessen, Gegenrichtung genannt |

### <a id="l-30.2"></a>L-30.2 — `Releases/PAKETE.md` 1.0.85: Messwerte in der Zeile *Nicht gemessen*

Die Zeile *Gemessen* nannte *„Testsuite 194/194“* und nur `TestE89.cpp` (4b); die
Messungen an `bf96856` standen unter *Nicht gemessen*, die Gegenrichtung fehlte
unter *Inhalt*. Jetzt: 195/195 mit (4c) und die beiden Werte unter *Gemessen*,
die Gegenrichtung unter *Inhalt*, *Nicht gemessen* nur noch „kein Paket“ und die
offenen Punkte. `WEITERMACHEN.md` *Paketnummer*: *„(seit N1 194/194)“* um 195/195
ergänzt.

### <a id="l-30.3"></a>L-30.3 — `Testdaten/README.md`: sechs statt sieben `<img>`

Die Beschreibung zählte das Bild mit nur `height="900"` nicht mit, die Spalte
*Bytes* sagte *„Die sechs `<img>`-Angaben“* und *„114 CRLF“* (gemessen nach
`9f5142b`). Jetzt sieben, der Fall `height="900"` in der Beschreibung, 116 CRLF
nach `f305f49`.

### <a id="l-30.4"></a>L-30.4 — `BEFUNDE.md` E-112: Gegenrichtung im Präsens „ungemessen“

*„bei nur `height` über `E89_MAX_HOEHE` wird die Breite 0 weiter zu 1
(`msgutils.cpp:3668-3677`) … ungemessen“* — zwei Sätze nach der Meldung, sie sei
behoben und gemessen. Jetzt Vergangenheit, Zeilen vorher/jetzt (`:3668-3680`,
an der Quelle gelesen), Verweis nach oben.

## Nicht berichtigt

`CHANGELOG.md` 7.2.0.85, Absatz *„Danach, nach PRÜFER-23“*: *„Testsuite 194/194“*
steht dort als Stand nach N1 in der Abfolge, der Satz danach nennt 195/195 —
in sich stimmig, belassen.

## Nachgemessen

`offene-befunde.pl`: *„Die Liste deckt die offenen Befunde.“* `befunde-verlinken.pl
--verlinken`: *„Jede Kennung ist ein Link“*. `commit-bereit.pl`: zuerst 27 von 28
grün — `pruefe-befundurteile.pl` las in `PORTIERUNG.md` mein *„behoben“* im selben
Absatz wie [E-116](../BEFUNDE.md#e-116) als Urteil über [E-116](../BEFUNDE.md#e-116); umformuliert zu *„eingebaut“*, danach
28 von 28. Alle geänderten MDs: UTF-8 ohne BOM, nur LF, 0 U+FFFD.
