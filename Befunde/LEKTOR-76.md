# <a id="lektor-76"></a>LEKTOR-76 — Nachprüfung der Berichtigungen zu LEKTOR-75 vor dem PR des Testpakets 7.2.0.124, Zweig `0.123_ergebnisse`, 26.10.2026

**Auftrag.** Sehr kurze Nachprüfung: (1) ob [L-75.1](LEKTOR-75.md#l-75.1)
bis [L-75.6](LEKTOR-75.md#l-75.6) erledigt sind; (2) ob eine der
geänderten Stellen etwas sagt, das nicht stimmt oder einer anderen Stelle
widerspricht — gegen `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`,
`Releases/PAKETE.md` und `Befunde/PRUEFER-59.md`; besonders die neue Klammer
an der Marke von [E-157](../Intern/BEFUNDE.md#e-157) und die Zeile
*Rollenschranke* in `PAKETE.md` 1.0.124. Geändert seit
[LEKTOR-75](LEKTOR-75.md#lektor-75) ist genau ein Commit, `e6de8a5a`
(6 Dateien, 8 Zeilen, gemessen mit `git show --stat`). Gemessen im
Arbeitsbaum `Eudora7.2-wt-lektor` auf `e6de8a5a`. Den übrigen Bestand habe
ich nicht erneut gelesen.

**Ergebnis vorweg.** **3 Funde** (1 falsch, 2 unklar). Alle sechs Funde aus
[LEKTOR-75](LEKTOR-75.md#lektor-75) sind an ihrer Stelle berichtigt; bei
[L-75.2](LEKTOR-75.md#l-75.2) bleibt ein Rest in den erzeugten Listen. Falsch
ist der neue Halbsatz *„der Rest danach“* in `PAKETE.md:171`: nach dem
Schnüren ist von [LEKTOR-74](LEKTOR-74.md#lektor-74) nichts mehr eingearbeitet
worden, drei Funde sind weiter offen ([L-76.1](#l-76.1)). Die neue Klammer an
[E-157](../Intern/BEFUNDE.md#e-157) stimmt in der Sache mit PRÜFER-59 überein,
nennt aber eine Zahl („2 Registry-Werte“), die weder dort noch sonst im Repo
steht ([L-76.2](#l-76.2)). Keiner der Funde hält den PR auf.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-75

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-75.1](LEKTOR-75.md#l-75.1) | „HIER WEITERMACHEN“ nannte Einarbeiten und Schnüren als Nächstes | **erledigt** | `Intern/WEITERMACHEN.md:145` *„Testpaket 7.2.0.124 ist geschnürt ([PAKETE](../Releases/PAKETE.md), `C:\Users\Gregor\Eudora72-1.0.124-release`). **Als Nächstes:** PR an Gregor, sein Kurztest (TESTPLAN T1–T5), dann Release 7.2.1.N nach Entscheidung 10.“* (belegt); der Verweis `../Releases/PAKETE.md` aus `Intern/` stimmt |
| [L-75.2](LEKTOR-75.md#l-75.2) | Marke an [E-157](../Intern/BEFUNDE.md#e-157) „zuletzt gemessen an 7.2.0.124“ ohne genannte Messung | **erledigt im Eintrag, Rest in den Listen** | `Intern/BEFUNDE.md:383` jetzt *„**Zuletzt gemessen: 26.10.2026 an 7.2.0.124** (der volle Prüfstandslauf an diesem Bau setzte 2 Registry-Werte zurück, … die Absturzzählung für Gregors Paketverzeichnis 1.0.124 folgt nach seinem Kurztest)“* (belegt). Die erzeugten Listen `CHANGELOG.md:28` und `Intern/WEITERMACHEN.md:367` zeigen weiter nur *„26.10.2026 an 7.2.0.124“* neben *„für 7.2.0.124 muss sie null sein“* (belegt) — die Klammer steht hinter der Marke und erreicht die Liste nicht. Zur Klammer selbst [L-76.2](#l-76.2) |
| [L-75.3](LEKTOR-75.md#l-75.3) | `ZIEL.md` Zeile 2a „offen“, Absatz „Vor dem Release“ „von 7.2.0.55“ | **erledigt, neuer Satz unklar** | `ZIEL.md:199` *„2a \| *zu Kriterium 2*“* (belegt); `:87-88` jetzt *„die Tabelle der Kriterien neu messen (von Gregor am 26.10.2026 an 7.2.0.123 neu gemessen, siehe Tabelle)“* (belegt) — dazu [L-76.3](#l-76.3) |
| [L-75.4](LEKTOR-75.md#l-75.4) | CHANGELOG Kriterium 4 ohne den Absturz an 7.2.0.123 | **erledigt** | `CHANGELOG.md:78` *„…; an 7.2.0.123 ein Absturz durch Debug-Fassungen im Paket ([E-156](../Intern/BEFUNDE.md#e-156)), für 7.2.0.124 behoben (Stand in [ZIEL.md])“* (belegt); passt zu `ZIEL.md:201`, das Kriterium 4 ebenfalls *fast* nennt |
| [L-75.5](LEKTOR-75.md#l-75.5) | `PAKETE.md` 1.0.124: „[LEKTOR-74](LEKTOR-74.md#lektor-74) und PRÜFER-59 … eingearbeitet“ sagte zu viel | **erledigt, neuer Halbsatz falsch** | `Releases/PAKETE.md:171` (belegt) — siehe [L-76.1](#l-76.1) |
| [L-75.6](LEKTOR-75.md#l-75.6) | TESTPLAN N1 „behoben für 7.2.0.124“ gegen BEFUNDE „am Programm noch nicht gemessen“ | **erledigt** | `Intern/TESTPLAN.md:134` *„die Behebung ist in 7.2.0.124 eingebaut, am Programm noch nicht gemessen (Kurztest T1)“* (belegt); deckt sich mit `BEFUNDE.md:395` |

Aus [LEKTOR-74](LEKTOR-74.md#lektor-74) weiter offen (nicht Auftrag dieses
Laufs, nur nachgesehen): [L-74.8](LEKTOR-74.md#l-74.8) — `Intern/PORTIERUNG.md:44`
und `tools/WERKZEUGE.md:3` nennen weiter 7.2.0.122 (belegt);
[L-74.12](LEKTOR-74.md#l-74.12) — `perl tools/pruefe-regressionstest.pl`
meldet weiter *„OHNE jede Pruefung 22“* (gemessen);
[L-74.6](LEKTOR-74.md#l-74.6) — PRÜFER-59 K2 und K3 stehen weiter nicht in
`BEFUNDE.md` (gemessen: `grep -o 'PRUEFER-59 K[0-9, ]*'` → nur K1, K4, K7,
K9 als Anfang einer Verweisliste).

---

## <a id="l-76.1"></a>L-76.1 — falsch: `PAKETE.md` 1.0.124 sagt, der Rest der Funde sei nach dem Schnüren eingearbeitet worden — nach 13:10 ist von LEKTOR-74 nichts mehr eingearbeitet, drei Funde sind offen

* `Releases/PAKETE.md:171` (belegt): *„[[LEKTOR-74](LEKTOR-74.md#lektor-74)] und [PRÜFER-59] waren
  gelaufen; vor dem Schnüren eingearbeitet sind die vier „falsch“-Funde
  ([L-74.1](LEKTOR-74.md#l-74.1) bis [L-74.4](LEKTOR-74.md#l-74.4)) und die Funde zu [E-158](../Intern/BEFUNDE.md#e-158) und [E-159](../Intern/BEFUNDE.md#e-159), der Rest danach“*.
* Reihenfolge der Commits (gemessen, `git log --date=format:%H:%M`):
  `31a9b110` 12:51 ([E-159](../Intern/BEFUNDE.md#e-159)), `c146e9c5` 12:55
  ([E-158](../Intern/BEFUNDE.md#e-158)), `abf96d75` 13:09
  (*„[LEKTOR-74](LEKTOR-74.md#lektor-74) eingearbeitet“*), `3ca94aaf` 13:12 (Paket), danach nur
  `1a3a2854` ([LEKTOR-75](LEKTOR-75.md#lektor-75)) und `e6de8a5a` ([L-75.1](LEKTOR-75.md#l-75.1) bis [L-75.6](LEKTOR-75.md#l-75.6)). Der erste Teil
  des Satzes stimmt also.
* Nach dem Schnüren ist kein Fund aus [LEKTOR-74](LEKTOR-74.md#lektor-74)
  mehr eingearbeitet worden; offen sind weiter
  [L-74.8](LEKTOR-74.md#l-74.8), [L-74.10](LEKTOR-74.md#l-74.10),
  [L-74.12](LEKTOR-74.md#l-74.12) und von PRÜFER-59 K2 und K3 (Belege in der
  Zeile unter der Tabelle oben). Dazu sagt der Satz zu wenig über die Zeit
  davor: `abf96d75` (13:09) hat auch [L-74.5](LEKTOR-74.md#l-74.5),
  [L-74.7](LEKTOR-74.md#l-74.7) und Teile von [L-74.6](LEKTOR-74.md#l-74.6),
  [L-74.9](LEKTOR-74.md#l-74.9), [L-74.11](LEKTOR-74.md#l-74.11) vor dem
  Schnüren erledigt (laut Tabelle in [LEKTOR-75](LEKTOR-75.md#lektor-75)).

Wer `PAKETE.md` als Nachweis liest, hält die Restfunde für erledigt — genau
das sollte [L-75.5](LEKTOR-75.md#l-75.5) verhindern. Gemeint war
wahrscheinlich *„der Rest folgt“* (Vermutung). **Was zu tun wäre:** *„…, der
Rest steht offen in [LEKTOR-76](../Befunde/LEKTOR-76.md#lektor-76)“* oder
*„… der Rest folgt nach dem Kurztest“*.

## <a id="l-76.2"></a>L-76.2 — unklar: die neue Klammer an E-157 nennt „2 Registry-Werte zurückgesetzt“ und schreibt das PRÜFER-59 zu; PRÜFER-59 hat zwei Werte gelesen, nicht gezählt, und die Zahl steht nirgends im Repo

[E-157](../Intern/BEFUNDE.md#e-157): die Prüfstandsläufe haben Gregors
Windows-Registry verändert und Abstürze nicht bemerkt.

* `Intern/BEFUNDE.md:383` (belegt): *„(der volle Prüfstandslauf an diesem
  Bau setzte 2 Registry-Werte zurück, danach standen `CommandLine` und
  `LaunchManager` wieder auf Gregors Stand — von [PRÜFER-59] nachgelesen; …)“*.
* `Befunde/PRUEFER-59.md:30-32` (belegt): *„Nach diesem Lauf zeigen
  `CommandLine\Current` auf Gregors 1.0.123 und `LaunchManager\PathCount`
  unverändert 0x219 (gemessen, nur gelesen). Das Zurücksetzen aus [[E-157](../Intern/BEFUNDE.md#e-157)]
  hat also gewirkt.“* Das deckt *„wieder auf Gregors Stand“* für diese zwei
  Werte, nicht für den ganzen Schlüssel `LaunchManager`.
* Einen Abschnitt *„Positiv gemessen“* hat `PRUEFER-59.md` nicht (gemessen:
  `grep -n -i positiv` → 0 Treffer); die Bestätigung steht im Nachtrag unter
  *Ergebnis vorweg* (`:27-32`).
* *„2 Registry-Werte“* (gemessen: `grep -rn` über alle `.md`, `.txt`,
  `.tsv` → nur `BEFUNDE.md:383`). `tools/pruefstand-lauf.ps1:175` schreibt
  die Zahl nur auf die Konsole (*„Registry (CommandLine, LaunchManager): {0}
  Wert(e) … zurueckgesetzt“*); weder `Intern/pruefstand-ergebnis.txt` noch
  `tools/TESTLAEUFE.md` aus `1bd0fe96` enthalten sie (gemessen: `git show
  1bd0fe96`). Woher die 2 stammt, ist nicht belegt (Vermutung: Konsolenausgabe
  des Laufs 12:24–12:31).
* PRÜFER-59 nennt für denselben Lauf auch die Absturzseite: *„Im
  Prüfstandslauf an 7.2.0.124 (`1bd0fe96`, 12:24 bis 12:31) kam derselbe
  Fall ohne Absturz durch (gemessen: kein Ereignis 1000 nach 10:05)“*
  (`:23-25`, belegt). Das fehlt in der Klammer, obwohl die Überschrift von
  [E-157](../Intern/BEFUNDE.md#e-157) beide Teile nennt.

In der Sache widerspricht die Klammer PRÜFER-59 nicht. **Was zu tun wäre:**
die Zahl streichen oder ihre Quelle nennen; *„`CommandLine\Current` und
`LaunchManager\PathCount` wieder auf Gregors Stand, kein Absturz (Ereignis
1000) — PRÜFER-59 nachgelesen“*.

## <a id="l-76.3"></a>L-76.3 — unklar: `ZIEL.md:87-88` verlangt „die Tabelle der Kriterien neu messen“ und sagt in der Klammer, sie sei neu gemessen; die Tabelle zeigt nur bei 2, 4 und 6 das Ergebnis an 7.2.0.123

* `ZIEL.md:87-88` (belegt): *„**Vor dem Release:** die Tabelle der Kriterien
  neu messen (von Gregor am 26.10.2026 an 7.2.0.123 neu gemessen, siehe
  Tabelle), dann Gregors Test aller neun Kriterien an einem frischen Paket“*.
* `Intern/TESTPLAN.md:126-133`, Ergebnis 7.2.0.123 (belegt): Zeilen K0/K1 bis
  K8 — die Messung aller Kriterien an 7.2.0.123 ist also gemacht.
* `ZIEL.md:196-205` (belegt): Kriterium 0 nennt weiter Gregors Test vom
  06.09.2026 an 1.0.10, 1 *„mehrfach gestartet“*, 3 POP3 und IMAP vom
  September, 5 den 07.09.2026, 7 den 08.09.2026, 8 den 09.09.2026; nur 2, 4
  und 6 nennen 7.2.0.123. *„siehe Tabelle“* führt also für sechs Kriterien
  zu den alten Urteilen.

Der Satz liest sich als „noch zu tun“ und „schon getan“ zugleich. **Was zu
tun wäre:** etwa *„Die Kriterien sind von Gregor am 26.10.2026 an 7.2.0.123
gemessen ([TESTPLAN](Intern/TESTPLAN.md#ergebnis-7-2-0-123)); vor der Marke
…“* — der Rest des Satzes (*„Gregors Test aller neun Kriterien an einem
frischen Paket“*) hängt an seiner Antwort zu
[L-74.10](LEKTOR-74.md#l-74.10).

---

## Geprüft, kein Fund

* `CHANGELOG.md:78` gegen `ZIEL.md:201` und `BEFUNDE.md` zu
  [E-156](../Intern/BEFUNDE.md#e-156): *fast*, Absturz an 7.2.0.123, behoben
  für 7.2.0.124 — übereinstimmend (belegt).
* `TESTPLAN.md:134` gegen `BEFUNDE.md:395` ([E-137](../Intern/BEFUNDE.md#e-137)):
  beide *„eingebaut, am Programm noch nicht gemessen“* (belegt).
* `WEITERMACHEN.md:145` gegen `PAKETE.md:159-171`: Testverzeichnis und
  *„geschnürt“* übereinstimmend (belegt).
* `ZIEL.md:199` (2a): Spaltenbeschriftung passt jetzt zu `:198` (belegt).

## Nicht geprüft

* Alles außerhalb der acht in `e6de8a5a` geänderten Zeilen, außer den oben
  genannten Gegenstellen.
* Das Paket 1.0.124 selbst — seit [LEKTOR-75](LEKTOR-75.md#lektor-75)
  (`3ca94aaf`) ist unter `Eudora71/`, `tools/` und `Releases/*.zip` nichts
  geändert (gemessen: `git show --stat e6de8a5a` nennt nur sechs `.md`).
* Mechanische Prüfungen (`doku-pruefen.pl`, `offene-befunde.pl`) — der
  Commit ändert keine Kennung und keine Fassungsnummer.

## Was nur Gregor entscheiden kann

Aus [LEKTOR-75](LEKTOR-75.md#lektor-75) weiter offen:

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)): genügt dein Ergebnis an 7.2.0.123 plus
  der Kurztest T1–T5 an 7.2.0.124, oder willst du am Paket 7.2.1.N noch
  einmal alle neun Kriterien durchgehen?
* **Ein Satz in der README für Anwender von `v1.0.120`** zu
  [E-156](../Intern/BEFUNDE.md#e-156) (das veröffentlichte Paket enthält die
  sechs Testfassungen, mit denen Eudora gelegentlich abstürzt), oder genügt
  das kommende Release? (`README.md:138` nennt [E-156](../Intern/BEFUNDE.md#e-156) nur in der Liste der
  Testpakete, belegt)
