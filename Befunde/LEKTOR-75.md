# <a id="lektor-75"></a>LEKTOR-75 — Nachprüfung vor dem PR des Testpakets 7.2.0.124, Zweig `0.123_ergebnisse`, 26.10.2026

**Auftrag.** Kurze Nachprüfung nach dem Einarbeiten von
[LEKTOR-74](LEKTOR-74.md#lektor-74) und dem Schnüren des Pakets 1.0.124:
(1) Stand jedes Fundes aus [LEKTOR-74](LEKTOR-74.md#lektor-74); (2) ob die Berichtigungen neue
Widersprüche erzeugt haben — gegen `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`
(Ergebnistabelle 7.2.0.123, Kurztest T1–T5) und `Releases/PAKETE.md`
Abschnitt 1.0.124; (3) die mechanischen Prüfungen. Geändert seit [LEKTOR-74](LEKTOR-74.md#lektor-74)
(`git log --stat 705d15b..HEAD`): `abf96d75` (Funde eingearbeitet, 8 Dateien)
und `3ca94aaf` (Paket geschnürt: `PAKETE.md`, `PRUEFBERICHT.md`,
`pruefbericht-tests.tsv`); dazu `c146e9c5` ([E-158](../Intern/BEFUNDE.md#e-158) gemessen, 12:55), der
zwischen der Messung von [LEKTOR-74](LEKTOR-74.md#lektor-74) auf `31a9b110` und dessen Commit lag.
Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf `3ca94aaf`. Den vollen
Bestand habe ich nicht erneut gelesen.

**Ergebnis vorweg.** **6 Funde** (0 falsch, 3 veraltet, 3 unklar). Die vier
Stellen, die [LEKTOR-74](LEKTOR-74.md#lektor-74) vor dem Schnüren berichtigt sehen wollte
([L-74.1](LEKTOR-74.md#l-74.1) bis [L-74.4](LEKTOR-74.md#l-74.4)), sind
erledigt; an `ZIEL.md` bleiben zwei Reste, die der neuen Tabelle
widersprechen ([L-75.3](#l-75.3)). **Das Paket 1.0.124 stimmt mit seinem
Eintrag:** Größe, Prüfsumme, Uhrzeit, Bau-Kennung und die Byte-Gleichheit von
`Eudora.exe` und `EudoraRes.dll` mit dem Bau habe ich nachgemessen.
[E-158](../Intern/BEFUNDE.md#e-158) (sichtbares `</x-html>` beim Weiterleiten)
ist jetzt wie von PRÜFER-59 verlangt an einer HTML-Weiterleitung gemessen, und
die Messung hat den richtigen Weg getroffen (im Protokoll des Prüfstands:
`Fassung=ORIGINAL`). Vor dem PR veraltet ist vor allem
`WEITERMACHEN.md:145`, das als Nächstes noch das Einarbeiten und das Schnüren
nennt ([L-75.1](#l-75.1)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-74

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-74.1](LEKTOR-74.md#l-74.1) | Kriterientabelle in `ZIEL.md` kannte Gregors Test an 7.2.0.123 nicht (K4 und K6 *nein*) | **erledigt, zwei Reste** | `ZIEL.md:198` Kriterium 2 *„**erfüllt** — seit Gregors Test an 7.2.0.123 auch die Meldung „Encountered an improper argument"“*; `:201` Kriterium 4 *„**An 7.2.0.123 nicht bestanden** ([TESTPLAN K4] …): Windows verzeichnete einen Absturz in `ucrtbased.dll` … behoben für 7.2.0.124, Gregors Bestätigung im Kurztest T5“*; `:203` Kriterium 6 *„**fast** — an 7.2.0.123 nicht bestanden … behoben für 7.2.0.124, Gregors Bestätigung im Kurztest T3“*; Absatz `:207-209` auf drei Zeilen mit Verweis gekürzt (alle belegt). Reste: Zeile 2a heißt weiter *offen*, und `:87-88` nennt die Urteile weiter „von 7.2.0.55“ — [L-75.3](#l-75.3); im CHANGELOG blieb die Zeile zu Kriterium 4 stehen — [L-75.4](#l-75.4) |
| [L-74.2](LEKTOR-74.md#l-74.2) | [E-148](../Intern/BEFUNDE.md#e-148) (eMudhra-Zertifikate) „mit Eudora gemessen“ und „nicht gemessen“ in einer Zeile | **erledigt** | `BEFUNDE.md:388` *„**Nicht gemessen:** dass Eudora einen Server mit eMudhra-Kette **ablehnt** — das ist eine Rechnung; die **Annahme** von GMX und freenet durch Eudora selbst ist seit Gregors Test an 1.0.123 gemessen (TESTPLAN K3)“*; `README.md:253-254` *„**Mit Eudora selbst** hat Gregor es am Testpaket 7.2.0.123 gemessen: Abruf ohne Zertifikatsfehler. Dass Eudora eine eMudhra-Kette ablehnt, bleibt eine Rechnung.“*; `ZIEL.md:76` *„mit Eudora selbst von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt, TESTPLAN K3“* (alle belegt) |
| [L-74.3](LEKTOR-74.md#l-74.3) | [E-142](../Intern/BEFUNDE.md#e-142) (Entwurf aus IMAP nach `Out` wird leer) „am Programm noch NICHT gemessen“ trotz N3; `WEITERMACHEN.md:134` ebenso für [E-137](../Intern/BEFUNDE.md#e-137) | **erledigt** | `BEFUNDE.md:378` *„**Hinweis eingebaut am 26.10.2026, von Gregor am Testpaket 7.2.0.123 gemessen (TESTPLAN N3); seit 7.2.0.124 ist *No* vorgewählt, das prüft Gregor im Kurztest T4**“*; `WEITERMACHEN.md:134` [E-137](../Intern/BEFUNDE.md#e-137) *„erster Teil von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt, zweiter Teil im Kurztest T1“*, [E-142](../Intern/BEFUNDE.md#e-142) *„(eingebaut am 26.10.2026, von Gregor an 1.0.123 gemessen, TESTPLAN N3)“* (belegt). Der alte Satz *„Gregor prüft im Testpaket 7.2.0.123“* ist weg (gemessen: `grep -c` → 0) |
| [L-74.4](LEKTOR-74.md#l-74.4) | fünf gemessene Befunde in den Listen „nie gemessen“ oder 22.10. | **erledigt, ein Rest unklar** | Marken in `BEFUNDE.md`: [E-119](../Intern/BEFUNDE.md#e-119) `:365`, [E-142](../Intern/BEFUNDE.md#e-142) `:378`, [E-159](../Intern/BEFUNDE.md#e-159) `:381`, [E-157](../Intern/BEFUNDE.md#e-157) `:383`, [E-137](../Intern/BEFUNDE.md#e-137) `:395` (belegt); Listen nachgezogen, `CHANGELOG.md:27-28`, `:34`, `:39`, `:48`; `perl tools/offene-befunde.pl` → *„davon NIE gemessen 10“* statt 14 (gemessen). Die Marke an [E-157](../Intern/BEFUNDE.md#e-157) sagt *„an 7.2.0.124“*, ohne dass der Eintrag eine Messung an 7.2.0.124 nennt — [L-75.2](#l-75.2) |
| [L-74.5](LEKTOR-74.md#l-74.5) | [E-158](../Intern/BEFUNDE.md#e-158) „behoben“, obwohl PRÜFER-59 vorher die Messung einer HTML-Weiterleitung verlangt | **erledigt** | `BEFUNDE.md:382` *„**Gemessen am 26.10.2026 um 12:54 am Bau 7.2.0.124 (Prüfstand `C:\Temp\E119K`, Fall `E-119d` …):** der Entwurf in `Out.mbx` trägt genau **eine** Hülle (`<x-html>` 1-mal, `</x-html>` 1-mal) … Nicht gemessen ist der Weg beim Absenden.“* (belegt, Commit `c146e9c5`). **Die Messung trifft den Weg** (gemessen, nur gelesen): `C:\Temp\E119K\Mailverzeichnis\eudora.log` enthält zweimal *„[E-87](../Intern/BEFUNDE.md#e-87) ComposeMessage: … IsHTML=1 … Typ=3“* und *„[E-88](../Intern/BEFUNDE.md#e-88) vor dem Absenden: Fassung=ORIGINAL (unveraendert) … OrigBytes=2524 EditorBytes=640 … getippt=0“* — das gespeicherte Original stammt also aus `QuoteText`, nicht aus dem Editor, der die innere Hülle schluckt; laut `PgMsgView.cpp:410-446` fällt die Wahl der Fassung auch beim Speichern. Dieser Nachweis steht nicht im Eintrag; ohne ihn sähe die Messung bei Fassung *Editor* immer eine Hülle. Vorschlag, kein Fund: die Zeile `Fassung=ORIGINAL` in `:382` nennen |
| [L-74.6](LEKTOR-74.md#l-74.6) | von PRÜFER-59 nur K5, K6, K11 im Bestand | **teilweise** | jetzt auch K1 (`BEFUNDE.md:395`, Nebenwirkung Fokus beim Klick auf einen Reiter), K4 (`:365`), K7 und K8 (`:384`), K9 und K10 (`:383`) (gemessen: `grep -o 'PRUEFER-59[^)]*)' Intern/BEFUNDE.md`). **Weiter nur im Bericht:** K2 (Hauptrahmen merkt sich eine Ansicht aus einer schwebenden Leiste als aktiv, `PRUEFER-59.md:536`) und K3 (ein `data:`-Bild ohne Anführungszeichen verliert die letzten 1–2 Byte, `:537`). Die zu weite Aussage *„Jetzt kommt jede Programmdatei aus dem fertigen Bau“* steht unverändert in `CHANGELOG.md:111-112`, die Grenze dazu jetzt in `BEFUNDE.md:384`; `TESTPLAN.md:146` *„seit 26.10.2026 im Prüfstand behoben“* ebenso, Grenze in `:383` |
| [L-74.7](LEKTOR-74.md#l-74.7) | CHANGELOG 7.2.0.123 „noch nicht bestätigt“, [E-137](../Intern/BEFUNDE.md#e-137) „noch nicht am Programm gemessen“ | **erledigt** | `CHANGELOG.md:128` Überschrift *„Strg+W in angedockter Leiste ([E-137](…)),“* ohne Zusatz; `:130` *„Testpaket, von Gregor am 26.10.2026 getestet ([Ergebnis](…))“* (belegt) |
| [L-74.8](LEKTOR-74.md#l-74.8) | `PORTIERUNG.md` und `WERKZEUGE.md` auf 7.2.0.122 | **offen** | `Intern/PORTIERUNG.md:44` *„**Stand 23.10.2026, Zweig `e-14-gemessen-und-rollen`:** Quellstand **7.2.0.122**“*; `tools/WERKZEUGE.md:3` *„**Stand 7.2.0.122 / Paket 1.0.122.**“* (belegt); nicht im Auftrag dieses Laufs genannt |
| [L-74.9](LEKTOR-74.md#l-74.9) | `PAKETE.md` 1.0.123 „keine Fehler“, [E-156](../Intern/BEFUNDE.md#e-156) sagt 6 FEHLER | **erledigt für 1.0.123, offen für 1.0.122** | `PAKETE.md:187` *„Das galt für die damalige Fassung des Werkzeugs; die Debug-Prüfung kam am 26.10.2026 mit [[E-156](../Intern/BEFUNDE.md#e-156)] dazu und meldet an diesem Paket 6 FEHLER“*; `:207` (1.0.122) unverändert *„keine Fehler, Kriterium 0 …“* (belegt). Laut [E-156](../Intern/BEFUNDE.md#e-156) lagen die Debug-Fassungen *„seit August“* im Paket (`BEFUNDE.md:384`), also auch in 1.0.122 (Vermutung, nicht am ZIP gemessen) |
| [L-74.10](LEKTOR-74.md#l-74.10) | `ZIEL.md` verlangt alle neun Kriterien an einem frischen Paket, geplant ist ein Kurztest | **offen, Frage an Gregor** | `ZIEL.md:87-89` unverändert; `TESTPLAN.md:11-12` *„alles andere hast du an 7.2.0.123 bestätigt“* unverändert, obwohl K4 und K6 dort *nein* waren (belegt) |
| [L-74.11](LEKTOR-74.md#l-74.11) | Gregors Ergebnis an 7.2.0.123 an drei Stellen gezählt | **teilweise** | `PAKETE.md:178` und `WEITERMACHEN.md:145` verweisen nur noch (belegt). `CHANGELOG.md:104-105` zählt weiter *„15 Punkte bestanden, drei nicht“* — stimmt mit der Tabelle (gemessen: 15 × *ja*, 3 × *nein* in `TESTPLAN.md:118ff.`) |
| [L-74.12](LEKTOR-74.md#l-74.12) | [E-156](../Intern/BEFUNDE.md#e-156) kritisch und behoben, Regressionsbilanz führt ihn „OHNE jede Prüfung“ | **offen** | `perl tools/pruefe-regressionstest.pl` (gemessen): *„OHNE jede Pruefung 22 … [E-129](../Intern/BEFUNDE.md#e-129) [E-156](../Intern/BEFUNDE.md#e-156) [E-136](../Intern/BEFUNDE.md#e-136)“* |

Aus [LEKTOR-73](LEKTOR-73.md#lektor-73) und [LEKTOR-72](LEKTOR-72.md#lektor-72)
weiter offen (alle belegt): `ZIEL.md:77` [E-146](../Intern/BEFUNDE.md#e-146)
(Umbenennen von IMAP-Ordnern) ohne Gregors Bestätigung (*„am Prüfstand erst
rot, dann grün“*), obwohl `BEFUNDE.md:389` sie aus N5 nennt
([L-73.2](LEKTOR-73.md#l-73.2)); `WEITERMACHEN.md:9` *„**Geschnürt als Paket
1.0.122**, von Gregor am 23.10.2026 geprüft“* in der Zeile *Quellstand
7.2.0.124* ([L-72.1](LEKTOR-72.md#l-72.1)); [E-146](../Intern/BEFUNDE.md#e-146)
beschreibt den alten Fehler zweimal ([L-72.4](LEKTOR-72.md#l-72.4); gemessen:
*„benannte man auf einem IMAP-Server ohne Ordnerhierarchie einen Ordner um“*
zweimal in `BEFUNDE.md:389`).

---

## <a id="l-75.1"></a>L-75.1 — veraltet: „HIER WEITERMACHEN“ nennt als Nächstes das Einarbeiten und das Schnüren, beides ist seit 13:12 erledigt

* `Intern/WEITERMACHEN.md:145` (belegt): *„**Als Nächstes:** LEKTOR- und
  PRÜFER-Funde einarbeiten, Testpaket 7.2.0.124 schnüren, PR an Gregor, sein
  Kurztest (TESTPLAN T1–T5), dann Release 7.2.1.N nach Entscheidung 10.“*
* `Releases/PAKETE.md:161` (belegt): *„**Geschnürt am 26.10.2026 um 13:10 und
  als Testverzeichnis abgelegt; nicht veröffentlicht.**“*; Commits `abf96d75`
  (13:09, *„[LEKTOR-74](LEKTOR-74.md#lektor-74) eingearbeitet“*) und `3ca94aaf` (13:12, *„Paket 1.0.124
  geschnuert“*) (gemessen: `git log`).
* `Intern/WEITERMACHEN.md:12`, Zeile *Paketnummer* (belegt): *„**1.0.124** …
  Testpaket … — Kurztest in [TESTPLAN.md]“*; dass das Paket geschnürt ist und
  in `C:\Users\Gregor\Eudora72-1.0.124-release` liegt, steht dort nicht.

Wer nach einer Unterbrechung bei *„HIER WEITERMACHEN“* einsteigt, beginnt mit
zwei erledigten Schritten. **Was zu tun wäre:** in `:145` die ersten beiden
Schritte streichen und auf [PAKETE 1.0.124](../Releases/PAKETE.md) verweisen.

## <a id="l-75.2"></a>L-75.2 — unklar: E-157 trägt „Zuletzt gemessen: 26.10.2026 an 7.2.0.124“, der Eintrag nennt keine Messung an 7.2.0.124 — in den Listen steht das neben „für 7.2.0.124 muss sie null sein“

[E-157](../Intern/BEFUNDE.md#e-157): die Prüfstandsläufe haben Gregors
Windows-Registry verändert und Abstürze nicht bemerkt.

* `BEFUNDE.md:383` (belegt): *„**Was noch fehlt:** nach jedem Testpaket
  dieselbe Zählung für Gregors Paketverzeichnis (für 7.2.0.124 muss sie null
  sein); ein Fall im Prüfstand, der einen echten Absturz rot sieht.
  **Zuletzt gemessen: 26.10.2026 an 7.2.0.124**“*.
* Gemessen ist laut Eintrag die **Gegenprobe** an einem eigenen Testschlüssel
  (`HKCU\Software\Eudora72Probe`) und die Absturzerkennung für `C:\Temp\E97`,
  `EBILD`, `E9` — an keinem genannten Bau (belegt, dieselbe Zeile).
* `CHANGELOG.md:28` und `WEITERMACHEN.md:367` (belegt) zeigen in einer Zeile
  *„26.10.2026 an 7.2.0.124“* und *„nach jedem Testpaket dieselbe Zählung für
  Gregors Paketverzeichnis (für 7.2.0.124 muss sie null sein)“*.

Gelesen wird das als: die Zählung für 7.2.0.124 ist gemacht. Sie kann es nicht
sein — Gregor hat 1.0.124 noch nicht gestartet (das Mailverzeichnis in
`C:\Users\Gregor\Eudora72-1.0.124-release` enthält nur `Eudora.ini`, gemessen
mit `ls`). Vermutung: gemeint ist der volle Prüfstandslauf am Bau 7.2.0.124
um 12:31, der mit dem neuen `pruefstand-lauf.ps1` lief. **Was zu tun wäre:**
im Eintrag einen Satz, was an 7.2.0.124 gemessen wurde (etwa *„Prüfstandslauf
12:31, 36 Fälle, Registry danach unverändert, 0 Abstürze“*, falls so
gemessen) — sonst die Marke auf das tatsächliche Messziel setzen.

## <a id="l-75.3"></a>L-75.3 — veraltet: in `ZIEL.md` heißt Zeile 2a weiter „offen zu Kriterium 2“ unter einem erfüllten Kriterium 2, und der Absatz „Vor dem Release“ nennt die Urteile weiter „von 7.2.0.55“

* `ZIEL.md:198` (belegt): Kriterium 2 *„**erfüllt** — seit Gregors Test an
  7.2.0.123 auch die Meldung „Encountered an improper argument" (Zeile 2a …)“*.
* `ZIEL.md:199` (belegt), Zeile darunter: *„2a \| *offen zu Kriterium 2* \|
  … Die Meldung … kam in Gregors Test an 7.2.0.123 nicht“* — die
  Spaltenbeschriftung widerspricht der Zeile darüber und ihrem eigenen Text.
* `ZIEL.md:87-88` (belegt): *„**Vor dem Release:** die Tabelle der Kriterien
  neu messen (ihre Urteile stammen von 7.2.0.55)“* — seit `abf96d75` stammen
  die Urteile zu 2, 4 und 6 von Gregors Test an 7.2.0.123 (`:198`, `:201`,
  `:203`).

**Was zu tun wäre:** `:199` *„zu Kriterium 2“* statt *„offen zu
Kriterium 2“*; in `:87-88` den Klammersatz auf den Stand bringen (Teil der
Frage an Gregor aus [L-74.10](LEKTOR-74.md#l-74.10), der Rest der Zeile bleibt
bis zu seiner Antwort).

## <a id="l-75.4"></a>L-75.4 — veraltet: der CHANGELOG-Abschnitt *Erreicht* nennt Kriterium 4 „fast“ ohne den Absturz an 7.2.0.123 — die Zeile zu Kriterium 6 direkt darunter wurde nachgezogen, diese nicht

* `CHANGELOG.md:78` (belegt): *„**Kriterium 4** (keine Abstürze) \| *fast* —
  Strg-N stürzt nicht mehr ab (fünfmal nachgemessen), das Beenden läuft sauber
  (Kriterium 7), und die Fehlerklasse hinter [E-34](../Intern/BEFUNDE.md#e-34)/[E-37](../Intern/BEFUNDE.md#e-37)/[E-43](../Intern/BEFUNDE.md#e-43) ist seit 7.2.0.24
  an der Wurzel weg“*.
* `CHANGELOG.md:79` (belegt): *„**Kriterien 5 und 6** … **erfüllt** bis
  7.2.0.122, Kriterium 6 an 7.2.0.123 nicht bestanden ([[E-158](../Intern/BEFUNDE.md#e-158)] …, Stand in
  [ZIEL.md])“*; `:77` Kriterium 2 verweist ebenso auf `ZIEL.md`.
* Dagegen `ZIEL.md:201` (belegt): *„**An 7.2.0.123 nicht bestanden** …
  Absturz in `ucrtbased.dll` … ([[E-156](../Intern/BEFUNDE.md#e-156)])“*.

Die Tabelle ist eine Doppelung der Kriterientabelle in `ZIEL.md`; nach
Gregors Regel vom 26.10. (eine Stelle, sonst verlinken) genügt je Zeile der
Verweis. **Was zu tun wäre:** `:78` wie `:77` und `:79` auf *„an 7.2.0.123
nicht bestanden ([[E-156](../Intern/BEFUNDE.md#e-156)]), Stand in [ZIEL.md]“* bringen.

## <a id="l-75.5"></a>L-75.5 — unklar: `PAKETE.md` 1.0.124 sagt „LEKTOR-74 und PRÜFER-59 waren gelaufen und eingearbeitet“ — eingearbeitet sind die vier Stellen vor dem Schnüren, nicht alle Funde

* `Releases/PAKETE.md:171` (belegt): *„gebaut mit `-RollenSindGelaufen`:
  [[LEKTOR-74](LEKTOR-74.md#lektor-74)] und [PRÜFER-59] waren gelaufen und eingearbeitet; fällig blieb
  der CHRONIST, der nur Lehren betrifft“*.
* Von [LEKTOR-74](LEKTOR-74.md#lektor-74) sind nach der Tabelle oben sechs erledigt, drei teilweise
  ([L-74.6](LEKTOR-74.md#l-74.6), [L-74.9](LEKTOR-74.md#l-74.9), [L-74.11](LEKTOR-74.md#l-74.11)), drei offen ([L-74.8](LEKTOR-74.md#l-74.8), [L-74.10](LEKTOR-74.md#l-74.10), [L-74.12](LEKTOR-74.md#l-74.12)); von
  PRÜFER-59 fehlen K2 und K3 im Bestand (gemessen, siehe Zeile [L-74.6](LEKTOR-74.md#l-74.6)).
* [LEKTOR-74](LEKTOR-74.md#lektor-74) hatte nur [L-74.1](LEKTOR-74.md#l-74.1) bis [L-74.4](LEKTOR-74.md#l-74.4) als *„vor dem Schnüren zu
  berichtigen“* eingestuft (`LEKTOR-74.md:17`); keiner der offenen Funde ist
  laut PRÜFER-59 oder [LEKTOR-74](LEKTOR-74.md#lektor-74) ein Grund, das Paket aufzuhalten (belegt,
  `PRUEFER-59.md:535-545`, Spalte *Hält das Paket auf?*: überall *nein*).

Die Schranke war also inhaltlich erfüllt; die Zeile sagt aber mehr. Wer
`PAKETE.md` als Nachweis liest, hält die Restfunde für erledigt. **Was zu tun
wäre:** *„eingearbeitet, soweit vor dem Schnüren verlangt ([L-74.1](LEKTOR-74.md#l-74.1) bis
[L-74.4](LEKTOR-74.md#l-74.4)); Rest siehe [[LEKTOR-75](#lektor-75)]“*.

## <a id="l-75.6"></a>L-75.6 — unklar: TESTPLAN nennt den zweiten Teil von E-137 „behoben für 7.2.0.124“, der Befund selbst „eingebaut, am Programm noch nicht gemessen“

[E-137](../Intern/BEFUNDE.md#e-137): Strg+W schloss bei einem Klick in die
Filterleiste das Mailfenster statt der Leiste.

* `Intern/TESTPLAN.md:134`, Zeile N1 (belegt, neu seit `abf96d75`): *„von
  Gregor nachgestellt: Mail auswählen, dann ins schwebende Filterfenster
  klicken, Strg+W schließt das Mailfenster — der zweite Teil von [[E-137](../Intern/BEFUNDE.md#e-137)],
  behoben für 7.2.0.124 (Kurztest T1)“*.
* `BEFUNDE.md:395` (belegt): *„**offen** — … mit einer Lücke, deren Behebung
  eingebaut, aber am Programm noch nicht gemessen ist; gilt als behoben, wenn
  Gregor es im Testpaket 7.2.0.124 sieht.“* und *„Am Prüfstand nicht
  nachzustellen: `WM_MOUSEACTIVATE` entsteht nur aus echter Mauseingabe.“*

Für [E-156](../Intern/BEFUNDE.md#e-156) und
[E-158](../Intern/BEFUNDE.md#e-158) sagen TESTPLAN (K4, K6) und BEFUNDE
beide *behoben*; nur bei [E-137](../Intern/BEFUNDE.md#e-137) geht die Ergebnistabelle über den Befund
hinaus — und gerade dieser Teil ist am Prüfstand nicht nachstellbar, T1 ist
die erste Messung überhaupt. **Was zu tun wäre:** in `:134` *„Behebung
eingebaut für 7.2.0.124, Gregors Prüfung im Kurztest T1“*.

---

## Geprüft, kein Fund

* **Paket 1.0.124** gegen `PAKETE.md:159-172` (alle gemessen, nur gelesen):
  `Releases/Eudora72-1.0.124-release.zip` im Hauptbaum 9.125.660 Byte, Zeit
  13:10:46, SHA-256 `a568d7b6a3ae7f13834d5e290fe4d2f47ad7620f0998d6bc9ca24a42cb44a3c1`
  — wie eingetragen; `Eudora.exe` im Testverzeichnis 3.027.968 Byte, SHA-256
  gleich `Eudora71/Bin/Release/Eudora.exe` (`b08ca8dc…`), `EudoraRes.dll`
  ebenso (`7f834f22…`); Kennung `1.0.124+8bdab960 2026-10-26 12:22` steht in
  `Eudora.exe`; seit `8bdab960` keine Änderung unter `Eudora71/`,
  `tools/paket-bauen.ps1`, `Releases/1.0/` (`git diff --stat` leer);
  `Mailverzeichnis` enthält nur `Eudora.ini` mit `LogLevel=58527`. 38 Dateien
  mit `.exe`, `.dll`, `.eif`, `.ocx` plus eine `.vxd` = die *„39 ausführbaren
  Dateien“* (`paket-pruefen.ps1:776-778` sucht *„jede ausführbare Datei, jede
  Endung“*); 6 ersetzt + 33 gleich = 39.
* **`PRUEFBERICHT.md`**: Kopf *„Commit `abf96d75` … Erstellt 2026-10-26 13:10
  … BESTANDEN“* (belegt) passt zu `PAKETE.md:169`. Die Zeile `E-119d` trägt
  12:54:15, alle übrigen Fälle 12:31:14 (`:434`), der Kopf *„voller Lauf, Ende
  2026-10-26 12:31:14“* — ein Nachlauf am selben Bau, kein Widerspruch.
* **Ergebnistabelle 7.2.0.123** (`TESTPLAN.md:118ff.`): 15 × *ja*, 3 × *nein*
  (K4, K6, N7), gezählt; N1 jetzt mit Gregors Nachstellung statt *„Ursache
  nicht gemessen“* ([L-73.6](LEKTOR-73.md#l-73.6) damit erledigt), passt zu `BEFUNDE.md:395`.
* **Kurztest T1–T5** (`TESTPLAN.md:21-25`) gegen BEFUNDE nach den
  Berichtigungen: T4 *„**No** ist vorgewählt“* passt zum neuen Kopf von [E-142](../Intern/BEFUNDE.md#e-142)
  (`:378`); T5 zu [E-156](../Intern/BEFUNDE.md#e-156) und [E-157](../Intern/BEFUNDE.md#e-157); T3 (Textmail) zu [E-158](../Intern/BEFUNDE.md#e-158) *„Was noch fehlt“*.
  Ergebnistabelle 7.2.0.124 (`:27-35`) leer. Die Vorbereitung (`:14-17`)
  überschreibt beim Kopieren die `Eudora.ini` des Pakets mit Gregors; dass
  seine den Schalter 32768 trägt, belegt K2 (Marken derselben Klasse im
  Protokoll, `TESTPLAN.md:127`).
* **Neue Stellen aus `abf96d75`** in `AUFGABEN.md:246-248` und
  `WEITERMACHEN.md:316` (*„Erledigt mit Gregors Test an 7.2.0.123 …“*):
  stimmen mit `ZIEL.md:198`.
* **[E-142](../Intern/BEFUNDE.md#e-142) im README** (`:172`) und unter *Bekannte Fehler* in `ZIEL.md:78`:
  unverändert richtig.

## Mechanisch

* `perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“*,
  dazu 16 Zeilen *„Zur Kenntnis: … nennt weder den Quellstand 7.2.0.124 noch
  die Paketnummer 1.0.124“*, darunter `Intern/PORTIERUNG.md` (*„höchste
  genannte Fassung: 7.2.0.122“*, [L-74.8](LEKTOR-74.md#l-74.8)). Blind für
  [L-75.1](#l-75.1) bis [L-75.6](#l-75.6) — es vergleicht Fassungsnummern, keine Aussagen.
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md
  42 … davon aktuell gemessen 32 … davon NIE gemessen 10 … 42 offene Befunde,
  in beiden Listen gleich.“* Die Zahl 32 enthält [E-157](../Intern/BEFUNDE.md#e-157) mit der Marke aus
  [L-75.2](#l-75.2).
* `perl tools/ziel-stand.pl` (gemessen): *„24 von 25 erfüllt, 1 offen -
  ZIEL.md ist auf dem Stand.“* — liest nur den erzeugten Block, nicht die
  Kriterientabelle ([L-75.3](#l-75.3)).
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„OHNE jede Pruefung
  22“*, darunter [E-156](../Intern/BEFUNDE.md#e-156) ([L-74.12](LEKTOR-74.md#l-74.12)).

## Nicht geprüft

* Der volle Bestand außerhalb der seit `705d15b` geänderten Stellen.
* Die zehn verbleibenden „nie gemessen“.
* Den Inhalt der ZIP-Datei Datei für Datei gegen das Testverzeichnis — nur
  Gesamtzahl (161 Dateien in beiden, gemessen mit `unzip -l` und `find`) und
  die beiden Hauptdateien.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10), weiter offen): genügt dein Ergebnis an
  7.2.0.123 plus der Kurztest T1–T5 an 7.2.0.124, oder willst du am Paket
  7.2.1.N noch einmal alle neun Kriterien durchgehen?
* **Ein Satz in der README für Anwender von `v1.0.120`** zu
  [E-156](../Intern/BEFUNDE.md#e-156) (das veröffentlichte Paket enthält die
  sechs Testfassungen, mit denen Eudora gelegentlich abstürzt), oder genügt
  das kommende Release? (aus [LEKTOR-73](LEKTOR-73.md#lektor-73), weiter
  offen)
