# <a id="lektor-78"></a>LEKTOR-78 — Kurzprüfung der Berichtigungen zu LEKTOR-77 vor dem PR des Testpakets 7.2.0.124, Zweig `0.123_ergebnisse`, 26.10.2026

**Auftrag.** Kurzprüfung vor dem PR: (1) ob [L-77.1](LEKTOR-77.md#l-77.1)
bis [L-77.3](LEKTOR-77.md#l-77.3) erledigt sind; (2) ob die drei geänderten
Stellen in `ZIEL.md` mit `Intern/TESTPLAN.md` (Vorbereitung, Definition und
Ergebnis von K3 und K8) und mit `ZIEL.md` selbst (Zeile 0, Maßstab für
Kriterium 0) stimmen und ob eine neue Formulierung einer anderen Stelle
widerspricht. Geändert seit [LEKTOR-77](LEKTOR-77.md#lektor-77)
(`28deabd`) ist nur `678e8475`: `ZIEL.md`, 3 Zeilen hinein, 3 heraus
(gemessen: `git diff --stat 28deabd 678e8475`). Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `678e8475`. Den übrigen Bestand habe ich nicht
erneut gelesen.

**Ergebnis vorweg.** **1 Fund** (1 falsch). Alle drei Funde aus
[LEKTOR-77](LEKTOR-77.md#lektor-77) sind erledigt, und die drei neuen
Formulierungen stimmen mit `TESTPLAN.md` und mit `ZIEL.md` selbst. Falsch
ist eine **andere** Stelle, die der neuen Zusammenfassung unter der
Kriterientabelle widerspricht: `Intern/WEITERMACHEN.md:65-82` führt die
Kriterien weiter mit dem Stand von vor dem Test an 7.2.0.123 — Kriterium 6
*erfüllt*, Kriterium 2 *fast* ([L-78.1](#l-78.1)). Der Fund ist in zwei
Minuten zu beheben; ob er den PR aufhält, entscheidet, wer den PR stellt.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-77

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-77.1](LEKTOR-77.md#l-77.1) | Kriterium 3 „an 7.2.0.123 erneut bestätigt“, K3 prüfte nur den Abruf mit übernommenen Konten; der hängende freenet-Versuch fehlte | **erledigt** | `ZIEL.md:200` jetzt *„an 7.2.0.123 hat Gregor den **Abruf** erneut bestätigt, mit den aus 1.0.122 übernommenen Konten ([TESTPLAN K3]: GMX über IMAP sofort, freenet über POP erst im zweiten Versuch; ein Konto neu eingerichtet wurde dort nicht)“* (belegt). Gegen `Intern/TESTPLAN.md:73-75` (Mailverzeichnis aus 1.0.122 kopieren), `:69-71` (Kontoassistent *„mit *Abbrechen* schließen“*), `:91` (K3 *„bei GMX und bei freenet Mail abrufen“*) und `:128` (*„GMX über IMAP sofort; freenet über POP: der erste Versuch … hing über eine Minute …; der zweite … kam in 19 s durch“*): deckungsgleich (belegt). Dass der erste Versuch **über eine Minute hing**, sagt *„erst im zweiten Versuch“* nicht ausdrücklich; der Verweis auf K3 führt dorthin — kein Fund |
| [L-77.2](LEKTOR-77.md#l-77.2) | Kriterium 8 „an 7.2.0.123 erneut bestätigt“, K8 prüfte nur das Menü *Window* | **erledigt** | `ZIEL.md:205` jetzt *„an 7.2.0.123 hat Gregor das Menü *Window* erneut bestätigt ([TESTPLAN K8]; die Registerkartenleiste war dort nicht Teil des Tests)“* (belegt). Gegen `Intern/TESTPLAN.md:96` (K8 *„zwei Postfächer öffnen, Menü *Window*“*) und `:133` (*„K8: PASSED“*): deckungsgleich (belegt). Kein Widerspruch zu `ZIEL.md:426` und `:451` (*„Damit ist **Kriterium 8** ganz erfüllt“*) — die Leiste trägt weiter die Bestätigung vom 09.09.2026 und an 1.0.84, die `:205` unter *„Zuerst“* nennt (belegt) |
| [L-77.3](LEKTOR-77.md#l-77.3) | Zusammenfassung zählte Kriterium 0 als an 7.2.0.123 belegt | **erledigt** | `ZIEL.md:207-208` jetzt *„sieben sind belegt (0, 1, 2, 3, 5, 7, 8; Kriterium 0 weiter durch den Test vom 06.09.2026 auf einem Rechner ohne Visual Studio); 4 und 6 bestanden dort nicht“* (belegt). Stimmt mit Zeile 0 (`:196`, *„am 06.09.2026 auf einem Rechner **ohne Visual Studio**“*) und mit dem Maßstab (`:268-270`, *„Das ZIP auf einem Rechner ohne Visual Studio auspacken und starten … **Erbracht am 06.09.2026**“*) überein (belegt). *„weiter“* behauptet, der Test an 1.0.10 gelte noch für das neu zusammengesetzte Paket 7.2.0.124 ([E-156](../Intern/BEFUNDE.md#e-156)) — das ist die offene Frage unten, kein neuer Fund |

## <a id="l-78.1"></a>L-78.1 — falsch: `Intern/WEITERMACHEN.md` führt die Kriterien mit dem Stand von vor dem Test an 7.2.0.123 und widerspricht der berichtigten Zusammenfassung in `ZIEL.md`

* `ZIEL.md:207-209` (belegt), seit `678e8475`: *„**Neun Kriterien, Stand
  nach Gregors Test an 7.2.0.123** …: sieben sind belegt (0, 1, 2, 3, 5, 7,
  8; …); 4 und 6 bestanden dort nicht. Beide sind für 7.2.0.124 behoben,
  Gregors Kurztest bestätigt sie (T5 und T3).“*
* `Intern/WEITERMACHEN.md:65-67` (belegt): *„**Neun Kriterien: sieben sind
  belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast erfüllt (2, 4).** Die Tabelle
  dazu steht in [ZIEL.md] und ist die Quelle.“*
* `Intern/WEITERMACHEN.md:75` (belegt): Kriterium 6 *„**erfüllt**
  (07.09.2026, von Gregor bestätigt)“* — an 7.2.0.123 **nein**
  (`Intern/TESTPLAN.md:131`, [E-158](../Intern/BEFUNDE.md#e-158), belegt).
* `Intern/WEITERMACHEN.md:73` und `:79-82` (belegt): Kriterium 4 *„Offen
  bleibt die Meldung beim Anzeigen mancher Nachrichten“*, *„Beiden noch nicht
  erfüllten Kriterien fehlt dasselbe: die Meldung „Encountered an improper
  argument“ … **neu zu messen**“* — gemessen ist sie: K2 *„keine meldung“*
  (`Intern/TESTPLAN.md:127`, belegt); der Absturz an 7.2.0.123, der
  Kriterium 4 dort scheitern ließ (`:129`), fehlt.

Gemessen: die Zeilen 65-82 sind seit `c28cde84` (22.10.2026) unverändert
(`git log -L65,66:Intern/WEITERMACHEN.md`). [L-61.1](LEKTOR-61.md#l-61.1)
nannte sie schon, damals gleichlautend mit `ZIEL.md`; seit `ZIEL.md`
berichtigt ist, widersprechen sie ihm. Nach Gregors Regel vom 26.10.2026
heißt ein Widerspruch zwischen `.md` *falsch*. Die anderen Stellen, die einen
Stand je Kriterium nennen, stimmen (gemessen: `grep -n Kriteri README.md
CHANGELOG.md`; `CHANGELOG.md:76-84` verweist für 2, 4, 6 auf `ZIEL.md` und
nennt K6 an 7.2.0.123 *nicht bestanden*).

**Was zu tun wäre:** `Intern/WEITERMACHEN.md:65-82` durch einen Satz mit
Verweis auf [ZIEL.md](../ZIEL.md) ersetzen — die Datei sagt selbst, dass
`ZIEL.md` die Quelle ist, und die Regel *„eine Stelle, dann verlinken“*
verlangt es. Eine zweite Tabelle von Hand ist genau die Doppelung, die hier
veraltet ist.

---

## Geprüft, kein Fund

* `ZIEL.md:200` gegen `Intern/TESTPLAN.md:69-75, 91, 128` (Tabelle oben).
* `ZIEL.md:205` gegen `Intern/TESTPLAN.md:96, 133` und `ZIEL.md:426, 451`.
* `ZIEL.md:207-208` gegen `ZIEL.md:196` und `:266-270`.
* Ob eine andere Stelle Kriterium 3 oder 8 als an 7.2.0.123 vollständig
  bestätigt nennt (gemessen: `grep -rn "erneut bestätigt"` ausserhalb von
  `Befunde/` und `Intern/LEKTORAT.md` trifft nur `ZIEL.md:197-205`).

## Nicht geprüft

* Alles außerhalb der drei in `28deabd..678e8475` geänderten Zeilen, außer
  den oben genannten Gegenstellen.
* Ob die Zeilen unter *„Zuerst“* in `ZIEL.md:200` das **Einrichten** eines
  Kontos belegen — sie nennen Port, TLS und Gregors Bestätigung, nicht das
  Einrichten; das ist Bestand von vor `678e8475`.
* Mechanische Prüfungen (`doku-pruefen.pl`, `offene-befunde.pl`) — der
  Commit ändert keine Kennung und keine Fassungsnummer.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)): genügt dein Ergebnis an 7.2.0.123 plus
  der Kurztest T1–T5 an 7.2.0.124, oder willst du am Paket 7.2.1.N noch
  einmal alle neun Kriterien durchgehen — und dazu die Frage aus
  [L-77.3](LEKTOR-77.md#l-77.3): Kriterium 0 (*„läuft ohne
  Nachinstallieren“*) ist zuletzt am 06.09.2026 an 1.0.10 auf einem Rechner
  ohne Visual Studio geprüft; seither hat sich mit 7.2.0.124 die
  Zusammensetzung des Pakets geändert. Muss der Test ohne Visual Studio
  wiederholt werden?
