# <a id="lektor-103"></a>LEKTOR-103 — Bestätigung: LEKTOR-102 nach 9e7e1d0c

**Datum:** 30.10.2026 · **Geprüft:** Commit `9e7e1d0c` auf `weitermachen-aufraeumen`, im Projektordner selbst

**Auftrag.** Kurze Bestätigung, kein voller Lauf: sind die zwei Funde aus
[LEKTOR-102](LEKTOR-102.md#lektor-102) erledigt, und sind die mit `9e7e1d0c`
geänderten Stellen richtig gegen Gregors Entscheidung 20
(`Intern/WEITERMACHEN.md:154`). **Alle Zeilenangaben gelten für `9e7e1d0c`.**
Nichts gebaut, nichts gestartet. **In diesem Bericht steht nichts aus Gregors
Rechner oder Postfach.**

**Ergebnis vorweg.** Beide Funde sind erledigt. **Keine neuen Funde.**

## Funde aus LEKTOR-102

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-102.1](LEKTOR-102.md#l-102.1) | ZIEL.md sagte im Präsens, Testpakete hießen 7.2.0.N | **erledigt** | `ZIEL.md:40-44` *„Bis zum Release 7.2.1.128 hießen Testpakete 7.2.0.\<n\> (z. B. **7.2.0.123**), seither heißen sie wie das Release 7.2.1.\<n\> (Gregors Entscheidung 20 …)“*; Entscheidung 1 in `Intern/WEITERMACHEN.md:135` trägt jetzt *„(seit dem Release heißen auch Testpakete 7.2.1.\<n\>, Entscheidung 20)“* (belegt) |
| [L-102.2](LEKTOR-102.md#l-102.2) | Drei Werkzeugkommentare beschrieben das alte Schema, einer verdreht | **erledigt** | `tools/offene-befunde.pl:193-194` *„7.2.0.N (Testpaket bis zum Release 7.2.1.128) und 7.2.1.N (Release, seit dem 30.10.2026 auch Testpaket, Entscheidung 20)“*; `tools/pruefe-behoben-ausgeliefert.pl:129-131` gleichlautend mit *„Entscheidungen 10 und 20“*; `tools/pruefe-fassungsnummer.pl:81-83` *„bis zum Release 7.2.1.128 hiess ein Testpaket 7.2.0.N, seither heisst jede Fassung 7.2.1.N (Entscheidung 20)“* — nicht mehr verdreht (belegt) |

## Geänderte Stellen gegen Entscheidung 20

* Jede neue Aussage passt zu `Intern/WEITERMACHEN.md:154` (*„ab dem Release
  7.2.1.128 heißt jede neue Fassung 7.2.1.N — Testpaket wie Release … Ein
  Release ist damit ein Testpaket, das Gregor getestet und freigegeben hat“*).
  `ZIEL.md:40-41` *„veröffentlicht wird ein Stand erst nach seinem Test“* stellt
  genau darauf ab (belegt).
* Der neue Link `Intern/WEITERMACHEN.md#entscheidungen` in `ZIEL.md:44` trifft:
  `Intern/WEITERMACHEN.md:127` *„## \<a id="entscheidungen"\>\</a\>Geltende
  Entscheidungen“* (belegt).
* Das Datum „seit dem 30.10.2026“ in den Kommentaren entspricht dem Tag der
  Entscheidung (belegt).

## Mechanisch (zitiert, gemessen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 50 … Kein Widerspruch gefunden.“*; dazu die bekannten „Zur Kenntnis“-Zeilen wie bei [LEKTOR-102](LEKTOR-102.md#lektor-102) |

## Nicht geprüft

* Nur die fünf Dateien aus `9e7e1d0c`; kein erneuter Durchgang durch den Bestand.
* Nichts am laufenden Programm.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Weiter offen: `ZIEL.md:37-38` sagt,
  dass er fehlt, und deine Anordnung vom 23.10. (*„für release dokumentieren
  wir, daß die fehlenden regression tests nachgeholt werden“*) ist damit noch
  nicht erfüllt. Ja heißt: Notiz auf GitHub ergänzen und `ZIEL.md:37-38`
  streichen.
