# <a id="lektor-101"></a>LEKTOR-101 — Nachprüfung: LEKTOR-100 nach 2b3ff3a7

**Datum:** 30.10.2026 · **Geprüft:** Commit `2b3ff3a7` auf `weitermachen-aufraeumen` · **Arbeitsbaum:** `wt/lektor-20261030b`

**Auftrag.** Nachprüfung, kein voller Lauf: (1) sind die elf Funde aus
[LEKTOR-100](LEKTOR-100.md#lektor-100) erledigt, (2) hat `2b3ff3a7` in den
zehn geänderten Dateien etwas Neues kaputt gemacht, (3) die mechanischen
Prüfungen. **Alle Zeilenangaben gelten für `2b3ff3a7`.** Nichts gebaut,
nichts gestartet. **In diesem Bericht steht nichts aus Gregors Rechner oder
Postfach.**

**Ergebnis vorweg.** Neun der elf Funde sind erledigt, zwei teilweise.
Alle neuen Links und Anker treffen. **3 neue Funde**, alle klein: ZIEL.md
widerspricht sich jetzt selbst über die Release-Notizen
([L-101.1](#l-101.1)), AUFGABEN.md nennt zu [E-13](../Intern/BEFUNDE.md#e-13)
(kein Fortschritt beim Mailabruf) weiter den verschwundenen Zweig
([L-101.2](#l-101.2)), und die Schranke lässt „nach Release 7.2.1“ ohne
„dem“ durch ([L-101.3](#l-101.3)).

---

## Funde aus LEKTOR-100

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-100.1](LEKTOR-100.md#l-100.1) | Rückstand an Regressionstests in keiner Liste, ZIEL schickt ins Leere | **teilweise** | `Intern/WEITERMACHEN.md:33` *„**Zuerst, vor jedem neuen Thema:** den Rückstand an Regressionstests abarbeiten“*, `ZIEL.md:113-114` zeigt auf `#nach-dem-release` (gemessen). Aber `ZIEL.md:35-36` behauptet weiter, die Notizen nennen den Rückstand, siehe [L-101.1](#l-101.1) |
| [L-100.2](LEKTOR-100.md#l-100.2) | AUFGABEN.md als zweite Aufgabenliste | **erledigt** | `Intern/AUFGABEN.md:1-7` *„Aufgaben — zum Nachschlagen … bis dahin gilt der Text unten als Stand vom 29.10.2026“*; Prüfauftrag `Intern/WEITERMACHEN.md:60`; die Schranke liest ohne Argument beide Dateien (`tools/pruefe-nach-dem-release.pl:51-54`, gemessen) |
| [L-100.3](LEKTOR-100.md#l-100.3) | CHRONIST-Vorschläge vom 30.10. und 29.10. Punkt 6 fehlten | **erledigt** | `Intern/WEITERMACHEN.md:54-58`, je gegen `Arbeitsweise/CHRONIST-2026-10-30.md:65-68` gelesen (belegt) |
| [L-100.4](LEKTOR-100.md#l-100.4) | [L-96.6](LEKTOR-96.md#l-96.6), PRÜFER-64 K5/K6, PRÜFER-63 K2 fehlten | **erledigt** | `Intern/WEITERMACHEN.md:50-53`; die Überschriften `PRUEFER-64.md:278` (K5), `:303` (K6) und `PRUEFER-63.md:150` (K2) stimmen mit den Zeilen überein (belegt) |
| [L-100.5](LEKTOR-100.md#l-100.5) | `arbeitsbaum-frei.pl --belegen` und [E-13](../Intern/BEFUNDE.md#e-13) fehlten | **erledigt** | `Intern/WEITERMACHEN.md:59` mit Link auf `#kleinere-reste`; [E-13](../Intern/BEFUNDE.md#e-13) steht im erzeugten Block (`:112`, gemessen) |
| [L-100.6](LEKTOR-100.md#l-100.6) | Zeile „Betriebsart Pro“ machte aus „kein Handlungsbedarf“ eine Aufgabe | **erledigt** | „Betriebsart“ kommt in `Intern/WEITERMACHEN.md` nicht mehr vor (gemessen, 0 Treffer) |
| [L-100.7](LEKTOR-100.md#l-100.7) | falsche Quelle der MEMORY-Zeile | **erledigt** | `Intern/WEITERMACHEN.md:44` verweist auf *„Stand 29.10.2026, Nachtrag 21:55“* |
| [L-100.8](LEKTOR-100.md#l-100.8) | Release-Buchführung erkannte WEITERMACHEN nicht | **erledigt** | gemessen: *„5 Datei(en), 5 Standaussage(n)“* (bei [LEKTOR-100](LEKTOR-100.md#lektor-100): 4); `Intern/WEITERMACHEN.md:3` *„Zuletzt veröffentlicht: **`v7.2.1.128`**“* passt auf `tools/pruefe-release-buchfuehrung.pl:202` |
| [L-100.9](LEKTOR-100.md#l-100.9) | Schranke fing nur „nach dem Release“ | **teilweise** | *„18 von 18 Faellen richtig“* (gemessen); „nach 7.2.1“ wird abgewiesen. Die Grenzen stehen im Kopf (`:36-42`) und in `tools/WERKZEUGE.md:169`. Eine nahe Wendung geht noch durch, siehe [L-101.3](#l-101.3) |
| [L-100.10](LEKTOR-100.md#l-100.10) | [E-13](../Intern/BEFUNDE.md#e-13) fiel durch beide Listen | **erledigt** in BEFUNDE und WEITERMACHEN | `Intern/BEFUNDE.md:274` *„**offen, nicht gemessen — die Behebung steckt seit dem 05.09.2026 im Stand** (`bd3959c2` …)“*; `git merge-base --is-ancestor bd3959c2 HEAD` ergibt 0, Zweig `wt/fortschritt-arbeit` 0 Treffer (gemessen). Rest in AUFGABEN, siehe [L-101.2](#l-101.2) |
| [L-100.11](LEKTOR-100.md#l-100.11) | README und Lehre beschrieben den Stand vor dem Umbau | **erledigt** | `README.md:89` *„was zu tun ist: die eine Liste ‚Nach dem Release 7.2.1‘“*; `Arbeitsweise/eine-stelle-dann-verlinken.md:36` *„Schranke (vereinbart, gebaut am 30.10.2026 …)“* |

### Gegenprobe zu L-100.9 (gemessen)

Kopien von `Intern/WEITERMACHEN.md` und `Intern/AUFGABEN.md` im Scratchpad,
je ein Absatz unter einer neuen Überschrift angehängt; beide Dateien gaben
dasselbe Ergebnis:

| Angehängt | Rückgabe |
|---|---|
| *„Das Werkzeug X bauen wir erst nach 7.2.1.“* | 1, abgewiesen |
| *„Das Werkzeug X bauen wir nach dem Release.“* | 1, abgewiesen |
| `… bauen wir [später](#nach-dem-release).` | 0, durchgelassen (benannte Grenze) |
| *„… bauen wir später.“* | 0, durchgelassen (benannte Grenze) |
| *„… bauen wir nach Release 7.2.1.“* | **0, durchgelassen**, siehe [L-101.3](#l-101.3) |
| *„… kommt nach 7.2.1.128 dran.“* | 0, durchgelassen (gewollt, eine Fassung) |

Die unveränderten Dateien: Rückgabe 0.

## Mechanisch (zitiert)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 47 … in Intern/WEITERMACHEN.md 47 … 47 offene Befunde, in beiden Listen gleich.“* (bei [LEKTOR-100](LEKTOR-100.md#lektor-100): 46; dazu kam [E-13](../Intern/BEFUNDE.md#e-13)) |
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 50 … Kein Widerspruch gefunden.“*, dazu 15 Dateien „Zur Kenntnis“ (alte Release-Notizen und Archive, wie bei [LEKTOR-100](LEKTOR-100.md#lektor-100)) |
| `perl tools/pruefe-release-buchfuehrung.pl` | *„5 Datei(en), 5 Standaussage(n)“*, rc=0 |
| `perl tools/pruefe-nach-dem-release.pl --selbsttest` | *„18 von 18 Faellen richtig“*; ohne Schalter rc=0 |
| `perl tools/pruefe-regressionstest.pl` | *„behoben und OHNE Testfall 67“*, *„kritisch 73“*; deckt sich mit `Intern/WEITERMACHEN.md:33` |

**Links und Anker** in allen zehn geänderten Dateien: alle treffen
(gemessen mit einem Ankerprüfer im Scratchpad; Positivprobe: zwei absichtlich
falsche Anker, beide gemeldet). Das gilt auch für die neuen Anker
`WEITERMACHEN-bis-7.2.0.md#regressionstests` und `#kleinere-reste`, für
`PRUEFER-64.md#k5` und `#k6` und für `PRUEFER-63.md#k2`. Zwei Meldungen in
`tools/WERKZEUGE.md:95` und `:168` stehen in Codespannen und sind älter als
`2b3ff3a7`; kein Fund.

## Neue Funde

### <a id="l-101.1"></a>L-101.1 — ZIEL.md sagt an zwei Stellen Gegensätzliches über die Release-Notizen

**Was passiert:** Die Berichtigung zu [L-100.1](LEKTOR-100.md#l-100.1) hat den Satz im Abschnitt
„Regressionstests“ richtiggestellt, den gleichlautenden weiter oben nicht.
Wer ZIEL.md von oben liest, liest weiter, die Notizen nennen den Rückstand.

* **Belegt**, `ZIEL.md:35-36` *„die Release-Notizen nennen den Rückstand
  (siehe *Regressionstests* unten)“* (seit `48cd36fa`, unverändert).
* **Belegt**, `ZIEL.md:108-110` *„Die Release-Notizen zu 7.2.1.128 nennen den
  Rückstand **nicht**“*.
* **Am Rand, belegt:** `ZIEL.md:113-114` sagt, *„Umfang und Reihenfolge“*
  stehen in der Liste; die Listenzeile `Intern/WEITERMACHEN.md:33` sagt, *„die
  Reihenfolge von damals steht im Archiv“*. Beides zusammen stimmt, einzeln
  nicht ganz.

`doku-pruefen.pl` meldet das nicht (gemessen, kein Widerspruch). Was in
Punkt 4 stehen soll, hängt an Gregors Frage unten.

### <a id="l-101.2"></a>L-101.2 — AUFGABEN.md nennt zu E-13 weiter den Zweig, den es nicht gibt

* **Belegt**, `Intern/AUFGABEN.md:419` *„[E-13](../Intern/BEFUNDE.md#e-13) — kein Fortschritt beim
  Mailabruf; die Behebung liegt auf `wt/fortschritt-arbeit`, nicht in diesem
  Zweig“*, in der Spalte daneben eine Merge-Entscheidung.
* **Gemessen**: den Zweig gibt es weder lokal noch auf `origin`; `bd3959c2`
  ist Vorfahre von `HEAD`. `Intern/BEFUNDE.md:274` sagt das inzwischen richtig.

Der neue Kopf von AUFGABEN (`:3-7`) erklärt den Text zum Stand vom
29.10.2026. Am 29.10. war die Aussage aber auch schon falsch, und die Zeile
fordert eine Entscheidung, die es nicht mehr gibt. Erledigt sich, wenn der
Prüfauftrag `Intern/WEITERMACHEN.md:60` diese Tabelle abarbeitet.

### <a id="l-101.3"></a>L-101.3 — Die Schranke lässt „nach Release 7.2.1“ durch

**Gemessen** (Tabelle oben): *„Das Werkzeug X bauen wir nach Release
7.2.1.“* geht in beiden Dateien mit Rückgabe 0 durch. Die Grenzen im Kopf
(`tools/pruefe-nach-dem-release.pl:36-42`) nennen „später“ und „beim
nächsten Mal“, nicht diese Form; sie liegt näher an den geprüften Wendungen
als an den benannten Ausnahmen. Ein Fall für den Selbsttest. Niedrig: heute
steht die Form in keiner der beiden Dateien (die unveränderten Dateien gehen
durch).

## Nicht geprüft

* Inhaltlich nur die Zeilen, die `2b3ff3a7` geändert hat; der übrige Text
  der zehn Dateien nicht erneut.
* Ob die offenen Punkte in `Intern/AUFGABEN.md` noch gelten; das ist jetzt
  der Auftrag `Intern/WEITERMACHEN.md:60`.
* Nichts am laufenden Programm.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Noch offen: `2b3ff3a7` hat ZIEL.md
  an die Notizen angepasst (*„nennen den Rückstand **nicht**“*), nicht die
  Notizen an deine Anordnung vom 23.10. (*„für release dokumentieren wir,
  daß die fehlenden regression tests nachgeholt werden“*). Je nach Antwort
  wird `ZIEL.md:35-36` ([L-101.1](#l-101.1)) berichtigt oder die Notiz ergänzt.
