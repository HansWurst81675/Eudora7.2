# <a id="lektor-102"></a>LEKTOR-102 — Nachprüfung: LEKTOR-101 und Entscheidung 20 nach 4fd851fd

**Datum:** 30.10.2026 · **Geprüft:** Commit `4fd851fd` auf `weitermachen-aufraeumen`, im Projektordner selbst

**Auftrag.** Nachprüfung, kein voller Lauf: (1) sind die drei Funde aus
[LEKTOR-101](LEKTOR-101.md#lektor-101) erledigt, (2) steht außerhalb von
`Befunde/`, `Arbeitsweise/`, Archiven und alten Release-Notizen noch, dass
**künftige** Testpakete 7.2.0.N heißen — gegen Gregors Entscheidung 20
(`Intern/WEITERMACHEN.md:154`, ab dem Release 7.2.1.128 heißt jede Fassung
7.2.1.N, nächstes Paket 7.2.1.129), (3) passen die neuen Stand-Köpfe,
(4) die mechanischen Prüfungen. **Alle Zeilenangaben gelten für `4fd851fd`.**
Nichts gebaut, nichts gestartet. **In diesem Bericht steht nichts aus Gregors
Rechner oder Postfach.**

**Ergebnis vorweg.** Alle drei Funde aus [LEKTOR-101](LEKTOR-101.md#lektor-101) sind erledigt. Die
Stand-Köpfe stimmen. **2 neue Funde**, beide klein: ZIEL.md sagt im Präsens,
Zwischenstände seien Testpakete 7.2.0.N ([L-102.1](#l-102.1)), und drei
Werkzeugkommentare beschreiben das Schema vor Entscheidung 20, einer davon
verdreht ([L-102.2](#l-102.2)).

---

## Funde aus LEKTOR-101

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-101.1](LEKTOR-101.md#l-101.1) | ZIEL.md sagte oben, die Release-Notizen nennen den Rückstand an Regressionstests, unten das Gegenteil | **erledigt** | `ZIEL.md:37-38` *„Bei 7.2.1.128 fehlt dieser Satz in den Notizen“* direkt unter der Regel `:35-36`; passt zu `:112` (belegt). Ob die Notiz ergänzt wird, bleibt Gregors Frage unten |
| [L-101.2](LEKTOR-101.md#l-101.2) | AUFGABEN.md nannte zu [E-13](../Intern/BEFUNDE.md#e-13) (kein Fortschritt beim Mailabruf) den gelöschten Zweig | **erledigt** | `Intern/AUFGABEN.md:419` *„die Behebung steckt seit dem 05.09.2026 im Stand (`bd3959c2`), der Zweig `wt/fortschritt-arbeit` existiert nicht mehr“*, Spalte jetzt *„am laufenden Programm messen“* (belegt) |
| [L-101.3](LEKTOR-101.md#l-101.3) | Schranke ließ „nach Release 7.2.1“ ohne „dem“ durch | **erledigt** | `tools/pruefe-nach-dem-release.pl:97` Muster `(?:(?:dem\s+)?Release|…)`, neuer Selbsttestfall `:144`; gemessen *„19 von 19 Faellen richtig“*; `tools/WERKZEUGE.md:169` nennt 19 Fälle |

## Entscheidung 20 im Bestand (gesucht nach „7.2.0.N“, „7.2.0.<n>“, „Testpaket“)

Richtig nachgezogen (belegt): `Releases/PAKETE.md:50-52`,
`Doku/MITARBEITEN.md:66`, `CHANGELOG.md:4`, `Intern/WEITERMACHEN.md:144`
(Entscheidung 10 mit Verweis auf 20), `:37` (PRÜFER-65 K2 angepasst),
`tools/kennung-erzeugen.pl:123`, `tools/pruefe-aussenstand.pl:61`.
Vergangenheitsaussagen (README `:140`, TESTPLAN-Ergebnisse, PAKETE-Abschnitte
1.0.123–1.0.127, `Doku/ANWENDER.md:257` „bis 1.0.127“, `tools/ZWEIGE.md`) sind
richtig. Selbsttestfälle mit 7.2.0.128/7.2.0.129 in
`tools/pruefe-aussenstand.pl:148`, `tools/pruefe-fassungsnummer.pl:237` und
`tools/pruefe-release-buchfuehrung.pl:405` sind Testdaten, kein Fund.
`Releases/PAKETE.md:70` (*„sonst ginge ein Testbau 7.2.0.N als Release 7.2.1.N
durch“*) begründet eine Prüfung, die weiter gilt; kein Fund.

## Stand-Köpfe

| Datei | Kopf | Darunter | Urteil |
|---|---|---|---|
| `Releases/PAKETE.md:3` | *„Stand 30.10.2026 … geschnürt ist bis 7.2.1.128, seither nichts Neues“* | jüngster Abschnitt 7.2.1.128 | stimmt (belegt) |
| `Intern/TESTPLAN.md:1` | *„Stand 30.10.2026 (getestet am 29.10.2026 …; seither kein neues Testpaket)“* | Ergebnis [E-166](../Intern/BEFUNDE.md#e-166) vom 29.10. | stimmt (belegt) |
| `tools/WERKZEUGE.md:1` | *„Stand 7.2.1.128, 30.10.2026 (neu `pruefe-nach-dem-release` …)“* | Zeile `:169` vorhanden | stimmt (belegt) |
| `Releases/DEFENDER-FEHLALARM.md:1` | *„Stand 30.10.2026 … vom 25. bis zum 30.10.2026 nicht erneut abgefragt“* | Text unverändert | stimmt (belegt) |
| `Intern/AUFGABEN.md:3` | *„Stand 30.10.2026: nur noch zum Nachschlagen … bis dahin gilt der Text unten als Stand vom 29.10.2026“* | `:9` *„Stand 29.10.2026“* | stimmt, der Kopf erklärt den Abstand (belegt) |

## Mechanisch (zitiert, gemessen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 50 … Kein Widerspruch gefunden.“*; dazu die bekannten „Zur Kenntnis“-Zeilen (u. a. `Releases/ISSUE-102-*.md`, `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md` ohne 7.2.1.128), wie bei [LEKTOR-101](LEKTOR-101.md#lektor-101) |
| `perl tools/pruefe-nach-dem-release.pl --selbsttest` | *„19 von 19 Faellen richtig“* |
| `perl tools/pruefe-stand-md.pl` | *„6 Datei(en) mit Stand-Kopf geprueft, Massstab 30.10.2026 … Kein Stand-Kopf hinkt hinterher.“*, rc=0 |

## Neue Funde

### <a id="l-102.1"></a>L-102.1 — ZIEL.md nennt Testpakete im Präsens 7.2.0.N

**Was passiert:** Wer ZIEL.md liest, erfährt, Zwischenstände hießen 7.2.0.N und
erst das Release 7.2.1.N. Seit Entscheidung 20 heißt auch das nächste
Testpaket 7.2.1.129.

* **Belegt**, `ZIEL.md:39-41` *„Zwischenstände wie **7.2.0.123** sind
  Testpakete für Gregors lokalen Test, keine Releases; veröffentlicht wird
  erst 7.2.1.\<n\>“*.
* **Belegt**, gleichlautend `Intern/WEITERMACHEN.md:135` (Entscheidung 1:
  *„7.2.0.123 ist nur das Testpaket, veröffentlicht wird 7.2.1.\<n\>“*); dort
  als Wortlaut einer alten Entscheidung vertretbar, aber ohne Verweis auf 20.

`doku-pruefen.pl` meldet das nicht (gemessen). Vorschlag: in ZIEL.md auf die
Unterscheidung „getestet und freigegeben“ statt auf die Nummernform abstellen
und Entscheidung 20 verlinken.

### <a id="l-102.2"></a>L-102.2 — Drei Werkzeugkommentare beschreiben das alte Schema

* **Belegt**, `tools/offene-befunde.pl:193` *„7.2.0.N (Testpaket) und seit dem
  29.10.2026 auch 7.2.1.N (Release)“*.
* **Belegt**, `tools/pruefe-behoben-ausgeliefert.pl:129-130` *„7.2.0.NN
  (Testpaket) und seit dem 29.10.2026 7.2.1.NN (Release, Gregors
  Entscheidung 10 …)“*.
* **Belegt**, `tools/pruefe-fassungsnummer.pl:81-82` *„7.2.1.N, bis zum
  Release 7.2.1.128 fuer ein Testpaket 7.2.0.N (Entscheidung 20)“* — schreibt
  die alte Form Entscheidung 20 zu, die sie gerade abgeschafft hat; in
  `4fd851fd` geändert, aber verdreht.

Nur Kommentare; die Muster lesen `7\.2\.[01]` und tun das Richtige (belegt
an `offene-befunde.pl:195`). Niedrig.

## Nicht geprüft

* Inhaltlich nur die Zeilen, die `4fd851fd` geändert hat, und die Treffer der
  Suche; die neue Lehre `Arbeitsweise/keine-unverstaendlichen-abfragen.md`
  nicht.
* `release-veroeffentlichen.ps1` selbst (steht als Aufgabe in
  `Intern/WEITERMACHEN.md:37`).
* Nichts am laufenden Programm.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Weiter offen: `ZIEL.md:35-38` sagt
  jetzt ehrlich, dass er fehlt, und deine Anordnung vom 23.10. (*„für release
  dokumentieren wir, daß die fehlenden regression tests nachgeholt werden“*)
  ist damit noch nicht erfüllt. Ja heißt: Notiz auf GitHub ergänzen und
  `ZIEL.md:37-38` streichen.
