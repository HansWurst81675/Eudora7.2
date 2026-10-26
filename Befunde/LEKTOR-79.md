# <a id="lektor-79"></a>LEKTOR-79 — Kurzprüfung der Berichtigung zu LEKTOR-78 vor dem PR des Testpakets 7.2.0.124, Zweig `0.123_ergebnisse`, 26.10.2026

**Auftrag.** Kurzprüfung vor dem PR: (1) ob [L-78.1](LEKTOR-78.md#l-78.1)
erledigt ist; (2) ob die zwei neuen Absätze in `Intern/WEITERMACHEN.md` und
`Intern/AUFGABEN.md` stimmen (Links, Anker, Daten), ob beim Ersetzen
Information verloren ging, die nirgends sonst steht, und ob der umgebende Text
verständlich bleibt. Geändert seit [LEKTOR-78](LEKTOR-78.md#lektor-78)
(`6c4cfd7`) ist nur `50f073b7`: 6 Zeilen hinein, 26 heraus (gemessen:
`git diff --stat 6c4cfd7 50f073b7`). Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `50f073b7`. Den übrigen Bestand habe ich nicht
erneut gelesen.

**Ergebnis vorweg.** **3 Funde** (1 falsch, 1 veraltet, 1 Doppelung).
[L-78.1](LEKTOR-78.md#l-78.1) ist erledigt, die zwei neuen Absätze stimmen, und verloren gegangen ist
nichts. Falsch ist eine **zweite Kriterientabelle** in
`Intern/AUFGABEN.md:145-151`, die der Commit stehen ließ, obwohl seine
Nachricht sagt, der Kriterienstand in `AUFGABEN` sei durch den Verweis ersetzt:
sie nennt Kriterium 6 *erfüllt* und 4 *fast*, ohne Datum ([L-79.1](#l-79.1)).
In zwei Minuten zu beheben; ob er den PR aufhält, entscheidet, wer den PR
stellt.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Fund aus LEKTOR-78

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-78.1](LEKTOR-78.md#l-78.1) | `Intern/WEITERMACHEN.md:65-82` führte die Kriterien mit dem Stand von vor 7.2.0.123 | **erledigt** | `Intern/WEITERMACHEN.md:65-68` jetzt *„Der Stand der neun Kriterien steht an **einer** Stelle: in der Tabelle in [ZIEL.md], seit dem 26.10.2026 mit Gregors Ergebnis an 7.2.0.123 ([Ergebnistabelle])“* (belegt). Die Tabelle und der Satz *„neu zu messen“* sind weg (gemessen: `grep -rn 'sieben sind belegt\|zwei sind fast\|neu zu messen'` außerhalb von `Befunde/` und `LEKTORAT.md` trifft nur `ZIEL.md:207` und zwei historische Stellen in `CHANGELOG.md:6158`, `Releases/PAKETE.md:1273`) |

## Die zwei neuen Absätze

* **Links** (gemessen): `../ZIEL.md` aus `Intern/` trifft `ZIEL.md`;
  `TESTPLAN.md#ergebnis-7-2-0-123` trifft den Anker
  `Intern/TESTPLAN.md:118` (*„`<a id="ergebnis-7-2-0-123">` Ergebnis am
  Testpaket 7.2.0.123 — je Kriterium“*). Beide Absätze gleich gebaut
  (`Intern/WEITERMACHEN.md:65-67`, `Intern/AUFGABEN.md:21-22`).
* **Datum 26.10.2026** (belegt): die Ergebniszeilen in
  `Intern/TESTPLAN.md:126-135` tragen alle *„26.10.2026“*; `ZIEL.md:197-205`
  verweist je Kriterium auf diese Tabelle.
* **Daten der Entstehung** (belegt): `Intern/WEITERMACHEN.md:67-68` *„am
  06.09.2026 … Kriterien 4 bis 6; 7 kam am 07.09.2026 dazu, 8 am selben Tag“*
  stimmt mit `ZIEL.md:186-190` (*„4 bis 6 kamen am 06.09.2026 dazu,
  Kriterium 7 … am 07.09.2026 …, Kriterium 8 … am 07.09.2026“*).
* **Nichts verloren** (belegt): alles aus der gelöschten Tabelle steht in
  `ZIEL.md` — Strg-N fünfmal und [E-37](../Intern/BEFUNDE.md#e-37)/[E-38](../Intern/BEFUNDE.md#e-38)/[E-43](../Intern/BEFUNDE.md#e-43) (`:201`), 5 und 6 am
  07.09.2026 (`:202-203`), 7 mit *„schließen klappt jetzt.“* und allen drei
  Wegen (`:204`), 8 am 09.09.2026 mit A-3/[E-48](../Intern/BEFUNDE.md#e-48) (`:205`); die Herkunft von 7
  aus dem Urteil zu 1.0.18 steht in `:187-188`. Aus `AUFGABEN.md` fiel der
  Vermerk *„Bis zum 14.09.2026 stand hier ‚beiden fehlt dasselbe‘“* weg — er
  berichtigte nur den eigenen, jetzt gelöschten Satz; [E-86](../Intern/BEFUNDE.md#e-86) und [E-77](../Intern/BEFUNDE.md#e-77) stehen in
  `ZIEL.md:198`. Kein Fund.
* **Umgebender Text** (belegt): kein Verweis auf die gelöschte Tabelle
  (gemessen: `grep -n -i 'tabelle oben\|beiden noch\|fast erfüllt'` in beiden
  Dateien trifft nur `Intern/AUFGABEN.md:163`, *„Alle vierzehn der Tabelle
  unten“* — gemeint ist die Befundtabelle von Abschnitt 1). Das folgende
  *„Dazu …“* (`Intern/WEITERMACHEN.md:70`, `Intern/AUFGABEN.md:24`) liest
  sich hinter dem Verweis noch verständlich.

## <a id="l-79.1"></a>L-79.1 — falsch: `Intern/AUFGABEN.md:145-151` führt eine zweite Kriterientabelle mit dem Stand vom 09.09.2026

* `Intern/AUFGABEN.md:147` (belegt): Kriterium 4 *„*fast* — … Offen: die
  Meldung beim Anzeigen mancher Nachrichten“* — an 7.2.0.123 kam die Meldung
  nicht, gescheitert ist 4 an einem Absturz in `ucrtbased.dll`
  (`ZIEL.md:201`, `Intern/TESTPLAN.md:127-129`).
* `Intern/AUFGABEN.md:149` (belegt): Kriterium 6 *„**erfüllt** — Gregor am
  07.09.2026“* — `ZIEL.md:203` *„**fast** — an 7.2.0.123 nicht bestanden“*
  ([E-158](../Intern/BEFUNDE.md#e-158)).
* Die Tabelle hat weder Überschrift noch Datum; der Absatz darunter
  (`:153`) beginnt *„Was sich am 09.09.2026 geändert hat“*. Gemessen: zuletzt
  inhaltlich geändert in `46936e14` (09.09.2026), danach nur `4da8408a`
  (Links) — `git log -L145,151:Intern/AUFGABEN.md`.
* Die Commit-Nachricht von `50f073b7` sagt *„Kriterienstand in WEITERMACHEN
  und AUFGABEN durch Verweis auf ZIEL.md ersetzt (… eine Stelle)“* — in
  `AUFGABEN` ist es nicht eine Stelle. [LEKTOR-78](LEKTOR-78.md#lektor-78) hatte die anderen Stellen
  nur in `README.md` und `CHANGELOG.md` gesucht und diese Tabelle nicht
  gefunden.

**Was zu tun wäre:** `Intern/AUFGABEN.md:145-151` streichen (der Verweis in
`:21-22` deckt es ab) oder als *„Stand 09.09.2026“* kennzeichnen.

## <a id="l-79.2"></a>L-79.2 — veraltet: das Ziel des neuen Links sagt, es werde erst noch ausgefüllt

* `Intern/TESTPLAN.md:120-122` (belegt): *„Wird nach deiner Rückmeldung
  ausgefüllt. Ohne diese Tabelle gibt es kein Release 7.2.1 …“* — direkt
  darunter (`:124-135`) ist sie ausgefüllt, alle Zeilen 26.10.2026.
* Wer dem neuen Link aus `WEITERMACHEN` oder `AUFGABEN` folgt, landet auf
  diesem Satz.

**Was zu tun wäre:** *„Wird … ausgefüllt“* durch *„Ausgefüllt am
26.10.2026.“* ersetzen; der zweite Satz kann bleiben.

## <a id="l-79.3"></a>L-79.3 — Doppelung: `Intern/WEITERMACHEN.md:67-68` wiederholt die Entstehung der Kriterien aus `ZIEL.md:185-190`

* Der Satz *„Gregor hat am 06.09.2026 die zweite Stufe gesetzt, Kriterien
  4 bis 6; 7 kam am 07.09.2026 dazu, 8 am selben Tag“* ist richtig (oben),
  aber ein Rest des alten Absatzes und steht vollständiger in
  `ZIEL.md:185-190`. Nach der Regel *„eine Stelle, dann verlinken“* entbehrlich;
  hält den PR nicht auf.

---

## Nicht geprüft

* Alles außerhalb von `6c4cfd7..50f073b7`, außer den genannten Gegenstellen.
* `Intern/WEITERMACHEN.md:304-306` (*„… gilt die Meldung als verschwunden und
  Kriterium 2 und 4 als erfüllt“*) — Plantext *„war der Plan davor“*, Bestand.
* Mechanische Prüfungen (`doku-pruefen.pl`, `offene-befunde.pl`) — der Commit
  ändert keine Kennung und keine Fassungsnummer.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)): genügt dein Ergebnis an 7.2.0.123 plus
  der Kurztest T1–T5 an 7.2.0.124, oder willst du am Paket 7.2.1.N noch
  einmal alle neun Kriterien durchgehen — und dazu
  ([L-77.3](LEKTOR-77.md#l-77.3)): Kriterium 0 (*„läuft ohne
  Nachinstallieren“*) ist zuletzt am 06.09.2026 an 1.0.10 auf einem Rechner
  ohne Visual Studio geprüft; mit 7.2.0.124 hat sich die Zusammensetzung des
  Pakets geändert. Muss der Test ohne Visual Studio wiederholt werden?
