# <a id="lektor-82"></a>LEKTOR-82 — Kurzprüfung der Berichtigungen zu LEKTOR-81 vor dem PR des Zweigs `0.123_ergebnisse` nach `main`, 26.10.2026

**Auftrag.** Nur zweierlei: (1) ob [L-81.1](LEKTOR-81.md#l-81.1) bis
[L-81.10](LEKTOR-81.md#l-81.10) erledigt sind; (2) ob eine der geänderten
Stellen etwas Falsches oder Widersprüchliches sagt, gemessen an
`Intern/BEFUNDE.md`, `Intern/TESTPLAN.md` und `ZIEL.md`. Kein
Bestandsdurchgang. Lauf über `e6fedc9..aeb79aa4` (ein Commit, acht `.md`,
17 Zeilen), gemessen im Arbeitsbaum `Eudora7.2-wt-lektor`.
`git log HEAD..origin/main` ist leer (gemessen).

**Ergebnis vorweg.** **3 Funde** (0 falsch, 1 veraltet, 2 unklar).
[L-81.2](LEKTOR-81.md#l-81.2) bis [L-81.10](LEKTOR-81.md#l-81.10) sind erledigt, [L-81.1](LEKTOR-81.md#l-81.1) bis auf
eine Zeile im CHANGELOG ([L-82.3](#l-82.3)). Zwei der Berichtigungen haben
einen neuen Satz an einen alten gefügt, der jetzt etwas anderes behauptet,
als gemessen ist ([L-82.1](#l-82.1), [L-82.2](#l-82.2)). Nichts gibt etwas
als bestätigt aus, das nicht bestätigt ist; *„Kriterium 4 fast“* ist mit
dem offenen [E-159](../Intern/BEFUNDE.md#e-159) jetzt begründet.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-81

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-81.1](LEKTOR-81.md#l-81.1) | [E-156](../Intern/BEFUNDE.md#e-156) und Kriterium 4 warteten auf T5 | **teilweise** | `Intern/BEFUNDE.md:384` *„von Gregor am 26.10.2026 an Paket 1.0.124 bestätigt (TESTPLAN T5: 0 Abstürze im Ereignisprotokoll)“*, *Was noch fehlt: nichts*; `ZIEL.md:72` *„von Gregor am 26.10.2026 an Paket 1.0.124 bestätigt, TESTPLAN T5“*; `ZIEL.md:199` *„behoben für 7.2.0.124 und von Gregor bestätigt (Kurztest T5: 0 Abstürze). Offen bleibt [[E-159](../Intern/BEFUNDE.md#e-159)] …“*; `CHANGELOG.md:77` ebenso (belegt). `CHANGELOG.md:78` nicht → [L-82.3](#l-82.3) |
| [L-81.2](LEKTOR-81.md#l-81.2) | E-137-Urteil nannte Paket 1.0.125 nicht | **erledigt** | `Intern/BEFUNDE.md:395` *„nicht im Paket 1.0.124, aber im Paket 1.0.125 (TESTPLAN U1–U3) und am Programm noch nicht gemessen“* (belegt) |
| [L-81.3](LEKTOR-81.md#l-81.3) | [E-137](../Intern/BEFUNDE.md#e-137) *„angedockt und schwebend“* gegen U1–U3 | **erledigt** | `Intern/BEFUNDE.md:395` *Was noch fehlt*: *„Titelzeile und Rand der **schwebenden** Leiste (U1, U2) und … eine Beschriftung der **angedockten** Leiste (U3)“* — gleich `Intern/TESTPLAN.md:20-22`; der Satz *„Eine angedockte Leiste hat keine eigene Titelzeile und keinen eigenen Rand, ein Klick dort trifft die Leiste selbst“* passt zu [PRÜFER-59 K1](PRUEFER-59.md#k1) (Griff und Reiter laufen über `OnMouseActivate` der Leiste) (belegt) |
| [L-81.4](LEKTOR-81.md#l-81.4) | [E-142](../Intern/BEFUNDE.md#e-142) und Entscheidung 12: *Send Again* ungeprüft, T4 ausstehend | **erledigt**, aber neu unklar | `Intern/BEFUNDE.md:378` *„hat Gregor an 1.0.124 geprüft: nein, die Mail ist leer (T6; Entscheidung 13)“*; `Intern/WEITERMACHEN.md:131` *„Gregor hat es an 1.0.124 geprüft (T6): die Mail ist leer, die Bedingung ist **nicht** erfüllt“* (belegt). Der Ersatz für *„Gregor prüft es im Testpaket 7.2.0.124“* → [L-82.2](#l-82.2) |
| [L-81.5](LEKTOR-81.md#l-81.5) | TESTPLAN T4 *„entscheidet Gregor“* | **erledigt** | `Intern/TESTPLAN.md:61` *„Entschieden: Entscheidungen 12 und 13 … die Ablehnung bleibt, Entwürfe bleiben in `Out`“* — gleich `Intern/WEITERMACHEN.md:132` (belegt) |
| [L-81.6](LEKTOR-81.md#l-81.6) | [E-124](../Intern/BEFUNDE.md#e-124) *Zuletzt gemessen 23.10.* | **erledigt**, aber neu unklar | `Intern/BEFUNDE.md:370` *„Zuletzt gemessen: 26.10.2026 an 7.2.0.124“*; `perl tools/offene-befunde.pl` → *„41 offene Befunde, in beiden Listen gleich.“* rc=0, `CHANGELOG.md:45` und `Intern/WEITERMACHEN.md:374` tragen das neue Datum (gemessen). Der Satz dahinter → [L-82.1](#l-82.1) |
| [L-81.7](LEKTOR-81.md#l-81.7) | README *„beide Fassungen“* | **erledigt** | `README.md:137` *„unter diesen drei Fassungen“* (belegt) |
| [L-81.8](LEKTOR-81.md#l-81.8) | README kündigte E-119-Behebung für 7.2.0.124 an | **erledigt** | `README.md:164` *„die Behebung für große Bilder ist im Testpaket 7.2.0.124, von Gregor bestätigt, und kommt mit dem Release 7.2.1“* — stimmt mit `Intern/BEFUNDE.md:365` (belegt); andere Form als die Nachbarzeilen, inhaltlich richtig |
| [L-81.9](LEKTOR-81.md#l-81.9) | ANWENDER *„bisher“* keine Signatur | **erledigt** | `Doku/ANWENDER.md:224` *„die gibt es für dieses Projekt nicht und wird es nicht geben (das Projekt verdient kein Geld, Zertifikate kosten jährlich)“* — gleich Entscheidung 14 (belegt) |
| [L-81.10](LEKTOR-81.md#l-81.10) | PAKETE 1.0.124 *„T1–T5“* | **erledigt** | `Releases/PAKETE.md:178` *„TESTPLAN T1–T6“*, im Abschnitt 1.0.124 (`:175`); der Abschnitt 1.0.125 nennt `:162` *„U1–U4“* (belegt) |

## <a id="l-82.1"></a>L-82.1 — unklar: E-124 schreibt die Lesung der Microsoft-Vorgangsseite jetzt dem 26.10.2026 zu

* `Intern/BEFUNDE.md:370` (belegt): *„**Zuletzt gemessen: 26.10.2026 an
  7.2.0.124** — **aus der Vorgangsseite gelesen, und das Ergebnis dreht den
  Befund um: wir warten nicht auf Microsoft, sondern auf uns.** … Gregor hat
  sie am 22.10.2026 aus seinem Browser gespeichert.“*
* Die Messung vom 26.10.2026 ist eine andere: Gregors Bild aus
  *Windows-Sicherheit → Schutzverlauf* auf einem Windows-11-Rechner
  (dieselbe Zeile, *„Wieder aufgetreten am 26.10.2026 an Paket 1.0.124“*,
  belegt). Die Vorgangsseite ist seit dem 22.10.2026 nicht neu gelesen —
  dieselbe Zeile sagt *„Die neue Einreichung bei Microsoft steht weiter
  aus.“*
* Ersetzt wurde nur das Datum ([L-81.6](LEKTOR-81.md#l-81.6) hatte nur das
  Datum vorgeschlagen); der fette Halbsatz dahinter hing am alten Datum.
  Der Leser liest jetzt: am 26.10. sei die Vorgangsseite gelesen worden. Die
  Einzelaussagen stimmen, ihre Verbindung nicht.

**Was zu tun wäre:** *„Zuletzt gemessen: 26.10.2026 an 7.2.0.124
(Schutzverlauf, siehe „Wieder aufgetreten“ unten). Die Vorgangsseite zuletzt
gelesen am 22.10.2026 — das Ergebnis dreht den Befund um: …“*

## <a id="l-82.2"></a>L-82.2 — unklar: E-142 nennt die *No*-Vorwahl *„an 1.0.124 geprüft (T4, T6)“* — gesehen hat sie dort niemand

* `Intern/BEFUNDE.md:378` (belegt): *„seit demselben Tag wählt die
  Rückfrage **No** vor (`YesNoDialogPlainNeinVorgewaehlt`, `guiutils.cpp`;
  Regressionstest in `TestE142.cpp`, 310 Tests, 310 bestanden), an 1.0.124
  geprüft (T4, T6).“*
* `Intern/TESTPLAN.md:50` T4 erwartet *„die Rückfrage kommt, **No** ist
  vorgewählt“*; `:61` Ergebnis **nein** — *„statt der Rückfrage kam
  ‚Messages can't be transferred to the Out mailbox‘“* (belegt). Die
  Rückfrage erschien an 1.0.124 nicht, die Vorwahl war also nicht zu sehen.
* `Intern/TESTPLAN.md:52` T6 prüft *Send Again*, nicht die Rückfrage
  (belegt). Der Kurztest 7.2.0.125 (U1–U4, `:20-23`) enthält keinen Schritt
  dazu (gemessen).
* Der Urteilskopf derselben Zeile sagt es richtig (*„Kurztest T4 an
  1.0.124: die Rückfrage kam nicht“*). Der neue Halbsatz im Rumpf lässt
  dagegen lesen, die *No*-Vorwahl sei am Programm bestätigt. Am Programm
  gemessen ist sie nicht, nur im Unit-Test.

**Was zu tun wäre:** *„… 310 bestanden); am Programm noch nicht gesehen — in
T4 an 1.0.124 kam die Rückfrage nicht (Entwurf vorher vom Server neu
geladen).“*

## <a id="l-82.3"></a>L-82.3 — veraltet: CHANGELOG *Erreicht*, Kriterien 5 und 6, kennt T3 an 7.2.0.124 nicht

* `CHANGELOG.md:78` (belegt): *„**erfüllt** bis 7.2.0.122, Kriterium 6 an
  7.2.0.123 nicht bestanden ([[E-158](../Intern/BEFUNDE.md#e-158)], Stand in ZIEL.md)“*.
* `ZIEL.md:201` (belegt): Kriterium 6 *„**erfüllt** — an 7.2.0.124 von
  Gregor bestätigt (Kurztest T3)“*. Die Nachbarzeile `CHANGELOG.md:77`
  (Kriterium 4) ist mit T5 nachgezogen, `:78` nicht —
  [L-81.1](LEKTOR-81.md#l-81.1) hatte `:77-78` genannt.
* Die Doppelung der Kriterientabelle aus `ZIEL.md` bleibt (Vorschlag aus
  [L-81.1](LEKTOR-81.md#l-81.1), auf einen Verweis zu kürzen, nicht umgesetzt); daher dieser Rest.

**Was zu tun wäre:** *„… Kriterium 6 an 7.2.0.123 nicht bestanden, an
7.2.0.124 von Gregor bestätigt (Kurztest T3)“* — oder die Zeilen 77–78 durch
einen Verweis auf `ZIEL.md` ersetzen.

---

## Geprüft ohne Fund

* **Kriterium 4 überall gleich:** `ZIEL.md:199` und `CHANGELOG.md:77` sagen
  *fast* mit T5 bestätigt und [E-159](../Intern/BEFUNDE.md#e-159) offen;
  `Intern/BEFUNDE.md:381` führt [E-159](../Intern/BEFUNDE.md#e-159) als *„offen — gemessen am 26.10.2026,
  Ursache nicht bestimmt“*; `ZIEL.md:205-207` *„Gregors Kurztest bestätigt
  sie (T5 und T3)“* widerspricht dem nicht (belegt).
  `perl tools/ziel-stand.pl` → *„25 von 25 erfüllt, 0 offen“* (gemessen).
* **Entscheidungen 12 und 13** (`Intern/WEITERMACHEN.md:131-132`) gegen
  TESTPLAN T4/T6 und [E-142](../Intern/BEFUNDE.md#e-142): gleich (belegt).
* **Erzeugte Listen:** die E-137-Zeile in `CHANGELOG.md:39` und
  `Intern/WEITERMACHEN.md:368` gibt den neuen *Was noch fehlt*-Text wieder
  (belegt); `offene-befunde.pl` rc=0 (gemessen).

## Nach dem Merge auf `main`

Falsch wird nach dem Merge nichts. Nach `main` gingen die beiden schiefen
Verbindungen [L-82.1](#l-82.1) und [L-82.2](#l-82.2) und die alte Zeile
[L-82.3](#l-82.3).

## Nicht geprüft

* Alles außerhalb des Commits `aeb79aa4`.
* Mechanische Prüfungen außer `offene-befunde.pl` und `ziel-stand.pl`.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)).
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)).
