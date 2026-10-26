# <a id="lektor-77"></a>LEKTOR-77 — Kurzprüfung der Berichtigungen zu LEKTOR-76 vor dem PR des Testpakets 7.2.0.124, Zweig `0.123_ergebnisse`, 26.10.2026

**Auftrag.** Kurzprüfung vor dem PR: (1) ob [L-76.1](LEKTOR-76.md#l-76.1)
bis [L-76.3](LEKTOR-76.md#l-76.3) erledigt sind; (2) ob die geänderten
Stellen mit ihren Quellen stimmen — die Ergänzungen in `ZIEL.md` zu den
Kriterien 1, 3, 5, 7, 8 gegen die Testdefinitionen und die Ergebnistabelle in
`Intern/TESTPLAN.md`, die Klammer an [E-157](../Intern/BEFUNDE.md#e-157)
gegen `Befunde/PRUEFER-59.md:20-32`, die Zeile *Rollenschranke* in
`Releases/PAKETE.md` 1.0.124. Geändert seit
[LEKTOR-76](LEKTOR-76.md#lektor-76) (`469cf36`) sind `6e3df0ff`
(Entscheidung 11 in `Intern/WEITERMACHEN.md`) und `950ced8e` (die
Berichtigungen), zusammen 4 Dateien, 10 Zeilen hinein, 9 heraus (gemessen:
`git diff --stat 469cf36..HEAD`). Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `950ced8e`. Den übrigen Bestand habe ich nicht
erneut gelesen.

**Ergebnis vorweg.** **3 Funde** (0 falsch, 3 unklar). Alle drei Funde aus
[LEKTOR-76](LEKTOR-76.md#lektor-76) sind erledigt. Die Klammer an
[E-157](../Intern/BEFUNDE.md#e-157) gibt PRÜFER-59 jetzt wörtlich wieder.
Die neuen Sätze *„an 7.2.0.123 von Gregor erneut bestätigt“* stimmen für die
Kriterien 1, 5 und 7. Bei **3** und **8** deckt der jeweilige K-Test nur
einen Teil des Kriteriums ([L-77.1](#l-77.1), [L-77.2](#l-77.2)); und die
Zusammenfassung unter der Tabelle zählt Kriterium **0** als an 7.2.0.123
belegt, obwohl die Zeile 0 selbst — richtig — nur den Test vom 06.09.2026
nennt ([L-77.3](#l-77.3)). Keiner der Funde hält den PR auf; das Urteil
*erfüllt* bleibt in allen drei Fällen durch die älteren Tests gedeckt.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-76

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-76.1](LEKTOR-76.md#l-76.1) | `PAKETE.md` 1.0.124: *„der Rest danach“* war falsch | **erledigt** | `Releases/PAKETE.md:171` jetzt *„vor dem Schnüren eingearbeitet sind die vier „falsch“-Funde ([L-74.1](LEKTOR-74.md#l-74.1) bis [L-74.4](LEKTOR-74.md#l-74.4)) und die Funde zu [E-158](../Intern/BEFUNDE.md#e-158) und [E-159](../Intern/BEFUNDE.md#e-159); fällig blieb der CHRONIST, der nur Lehren betrifft“* (belegt). Der Halbsatz ist gestrichen, der Rest des Satzes stimmt mit der Commit-Reihenfolge aus [L-76.1](LEKTOR-76.md#l-76.1) überein. Dass drei Funde aus [LEKTOR-74](LEKTOR-74.md#lektor-74) offen sind, sagt die Zeile nicht mehr — sie behauptet es aber auch nicht mehr als erledigt; kein Fund |
| [L-76.2](LEKTOR-76.md#l-76.2) | Klammer an [E-157](../Intern/BEFUNDE.md#e-157) mit „2 Registry-Werte“ ohne Quelle | **erledigt** | `Intern/BEFUNDE.md:383` jetzt *„(nach dem vollen Prüfstandslauf an diesem Bau, `1bd0fe96`, zeigten `CommandLine\Current` auf Gregors 1.0.123 und `LaunchManager\PathCount` unverändert `0x219`, und es gab kein Absturzereignis — gelesen von [PRÜFER-59] …)“* (belegt). Gegen `Befunde/PRUEFER-59.md:23-25` (*„Im Prüfstandslauf an 7.2.0.124 (`1bd0fe96`, 12:24 bis 12:31) … (gemessen: kein Ereignis 1000 nach 10:05)“*) und `:29-32` (*„Nach diesem Lauf zeigen `CommandLine\Current` auf Gregors 1.0.123 und `LaunchManager\PathCount` unverändert 0x219“*) deckungsgleich (belegt). *„Nach diesem Lauf“* meint dort den Lauf, in dem E-119e grün wurde; das ist `1bd0fe96` (gemessen: Commit-Betreff *„Pruefstand 7.2.0.124: 36 Faelle, 36 bestanden (E-119e jetzt gruen …)“*). Die Zahl „2“ ist weg (gemessen: `git diff 469cf36..HEAD`) |
| [L-76.3](LEKTOR-76.md#l-76.3) | `ZIEL.md:87-88` „neu messen“ und „neu gemessen“ in einem Satz; Tabelle nur bei 2, 4, 6 mit 7.2.0.123 | **erledigt** | `ZIEL.md:87-88` jetzt *„die Tabelle der Kriterien neu messen — geschehen: Gregor am 26.10.2026 an 7.2.0.123, [Ergebnistabelle](Intern/TESTPLAN.md#ergebnis-7-2-0-123) —, dann Gregors Test aller neun Kriterien an einem frischen Paket“* (belegt); der Anker steht an `Intern/TESTPLAN.md:118` (belegt). Die Zeilen 1, 3, 5, 7, 8 (`ZIEL.md:197, 200, 202, 204, 205`) nennen jetzt 7.2.0.123 mit Verweis auf die Ergebnistabelle (belegt). Zur Deckung der einzelnen Zeilen [L-77.1](#l-77.1) bis [L-77.3](#l-77.3) |

Entscheidung 11 (`Intern/WEITERMACHEN.md:144`, *„**kein** Hinweis in der
README für Anwender von `v1.0.120` … *„eine solche meldung brauchen wir
nicht.“*“*, belegt) beantwortet die README-Frage aus
[LEKTOR-76](LEKTOR-76.md#lektor-76); sie steht unten nicht mehr.

## Die neuen Sätze in ZIEL.md gegen den jeweiligen K-Test

| Kriterium (`ZIEL.md`) | K-Test (`TESTPLAN.md`, Definition) | Ergebnis (`TESTPLAN.md`) | deckt? |
|---|---|---|---|
| 1 startet, Hauptfenster (`:197`) | K0/K1 `:89` *„`Eudora starten.cmd` doppelklicken \| Hauptfenster, Titelzeile …“* | `:126` **ja**, Titelzeile aus Gregors Bild | **ja** (belegt) |
| 3 einrichten, verbinden, abrufen (`:200`) | K3 `:91` *„bei GMX und bei freenet Mail abrufen“* | `:128` **ja, mit Bemerkung** | **teilweise** — [L-77.1](#l-77.1) |
| 5 schreiben und abschicken (`:202`) | K5 `:93` *„eine Mail an dich selbst schreiben und senden \| kommt an“* | `:130` **ja**, der Befund dort betrifft K6 | **ja** (belegt) |
| 7 *File → Exit* (`:204`) | K7 `:95` *„*File → Exit* \| Eudora schließt sauber“* | `:132` **ja**, `Logging shutdown` | **ja** (belegt); Alt-F4 und das Kreuz stehen in `:204` unter *„Zuerst“*, also beim alten Test |
| 8 offene Fenster sichtbar und auswählbar (`:205`) | K8 `:96` *„zwei Postfächer öffnen, Menü *Window*“* | `:133` **ja** | **teilweise** — [L-77.2](#l-77.2) |

---

## <a id="l-77.1"></a>L-77.1 — unklar: Kriterium 3 heißt „an 7.2.0.123 erneut bestätigt“, K3 hat aber nur den Abruf mit übernommenen Konten geprüft, und die Bemerkung zum hängenden freenet-Abruf fehlt

* `ZIEL.md:200` (belegt): Kriterium *„Ein Mailkonto lässt sich einrichten,
  verbinden und Mail abrufen“* — *„**erfüllt** — an 7.2.0.123 von Gregor
  erneut bestätigt ([TESTPLAN K3], GMX über IMAP, freenet über POP)“*.
* `Intern/TESTPLAN.md:73-75` (belegt): vor dem Test *„Der Inhalt von
  `…\Eudora72-1.0.122-release\Mailverzeichnis` in
  `…\Eudora72-1.0.123-release\Mailverzeichnis` kopieren“*; `:69-71` den
  Assistenten für ein neues Konto *„mit *Abbrechen* schließen“*. K3
  (`:91`) prüft *„bei GMX und bei freenet Mail abrufen“*. **Eingerichtet**
  wurde an 7.2.0.123 kein Konto.
* `Intern/TESTPLAN.md:128` (belegt): K3 **„ja, mit Bemerkung“** — *„der
  erste Versuch zu `194.97.208.37:995` hing über eine Minute ohne jede
  Protokollzeile, bis Gregor ihn stoppte; … Ursache des Hängens nicht
  gemessen“*. Die neue Zeile in `ZIEL.md:200` übernimmt nur das *ja*.

Wer `ZIEL.md` liest, hält alle drei Teile des Kriteriums für an 7.2.0.123
bestätigt und den Abruf für störungsfrei. **Was zu tun wäre:** etwa *„an
7.2.0.123 von Gregor erneut bestätigt: Verbinden und Abruf (GMX über IMAP,
freenet über POP; ein freenet-Versuch hing über eine Minute, [TESTPLAN K3]);
Einrichten zuletzt …“*.

## <a id="l-77.2"></a>L-77.2 — unklar: Kriterium 8 heißt „an 7.2.0.123 erneut bestätigt“, K8 hat nur das Menü *Window* geprüft, nicht die Registerkartenleiste, die laut ZIEL zu Kriterium 8 gehört

* `ZIEL.md:205` (belegt): *„**erfüllt** — an 7.2.0.123 von Gregor erneut
  bestätigt ([TESTPLAN K8]). Zuerst: … das Menü *Window* listet sie auf …,
  und die **Registerkartenleiste am unteren Fensterrand** ist da (Anforderung
  **A-3** …)“*.
* `ZIEL.md:426` (belegt), zu A-3: *„Das ist der noch fehlende Teil von
  **Kriterium 8**. Mit A-3 ist es ganz erfüllt.“*
* `Intern/TESTPLAN.md:96` (belegt): K8 *„zwei Postfächer öffnen, Menü
  *Window* \| beide stehen dort und lassen sich wählen“* — von der Leiste
  steht dort nichts; `:133` *„Gregor: „K8: PASSED““*.

An 7.2.0.123 bestätigt ist also die Hälfte über das Menü; die Leiste trägt
weiter die Bestätigung an 1.0.84. Ob Gregor beim K8-Test die Leiste
mitbenutzt hat, steht nirgends (Vermutung: wahrscheinlich, sie ist ständig
sichtbar). **Was zu tun wäre:** *„an 7.2.0.123 von Gregor erneut bestätigt
über das Menü *Window* ([TESTPLAN K8])“*, oder die Leiste in die
K8-Definition für den nächsten Test aufnehmen.

## <a id="l-77.3"></a>L-77.3 — unklar: die Zusammenfassung unter der Kriterientabelle zählt Kriterium 0 als an 7.2.0.123 belegt; die Zeile 0 und der Maßstab für Kriterium 0 sagen etwas anderes

* `ZIEL.md:207-208` (belegt): *„**Neun Kriterien, Stand nach Gregors Test an
  7.2.0.123** ([Ergebnistabelle]): sieben sind belegt (0, 1, 2, 3, 5, 7,
  8)“*.
* `ZIEL.md:196` (belegt), Zeile 0: nennt nur Gregors Test vom 06.09.2026 an
  `Eudora72-1.0.10-release.zip` *„auf einem Rechner **ohne Visual
  Studio**“* — von `950ced8e` zu Recht **nicht** um 7.2.0.123 ergänzt.
* `ZIEL.md:266-268` (belegt), Maßstab: *„**Das ZIP auf einem Rechner ohne
  Visual Studio auspacken und starten**“*. K0/K1 (`TESTPLAN.md:89`) ist
  *„`Eudora starten.cmd` doppelklicken“* auf Gregors Arbeitsrechner; dass
  dort kein Visual Studio installiert ist, steht nirgends (Vermutung: es ist
  dort installiert, der Bau läuft auf diesem Rechner).

Die Zeile 0 und die Zusammenfassung zwei Zeilen darunter sagen damit
Verschiedenes über dieselbe Messung. `:207` ist nicht in `950ced8e`
geändert; ich nenne es, weil der Auftrag fragt, ob der K-Test das Kriterium
deckt, und weil die Paketzusammensetzung sich mit 7.2.0.124
([E-156](../Intern/BEFUNDE.md#e-156)) geändert hat — für 7.2.0.124 gibt es
zu Kriterium 0 nur die Werkzeugprüfung `paket-pruefen.ps1`
(`Releases/PAKETE.md:170`, belegt). **Was zu tun wäre:** in `:208` *„sechs
sind belegt (1, 2, 3, 5, 7, 8); 0 zuletzt an 1.0.10 auf einem Rechner ohne
Visual Studio“* — oder Gregor sagt, ob das Release 7.2.1.N den Test ohne
Visual Studio noch einmal braucht (gehört zu
[L-74.10](LEKTOR-74.md#l-74.10)).

---

## Geprüft, kein Fund

* `Intern/BEFUNDE.md:383` gegen `Befunde/PRUEFER-59.md:20-32`: Commit,
  `CommandLine\Current`, `PathCount 0x219`, kein Ereignis 1000 —
  übereinstimmend (belegt; Einzelheiten in der Tabelle oben).
* `Releases/PAKETE.md:171` gegen die Commit-Reihenfolge aus
  [L-76.1](LEKTOR-76.md#l-76.1): stimmt (belegt).
* `Intern/WEITERMACHEN.md:144` (Entscheidung 11): Verweise auf
  `BEFUNDE.md#e-156` und `../Befunde/LEKTOR-73.md` bis `LEKTOR-75.md` aus
  `Intern/` stimmen (belegt).
* Kriterien 1, 5, 7: der K-Test deckt das Kriterium (Tabelle oben).

## Nicht geprüft

* Alles außerhalb der zehn in `469cf36..950ced8e` geänderten Zeilen, außer
  den oben genannten Gegenstellen.
* Der Rest aus [L-75.2](LEKTOR-75.md#l-75.2): die erzeugten Listen
  `CHANGELOG.md:28` und `Intern/WEITERMACHEN.md:368` zeigen weiter nur
  *„26.10.2026 an 7.2.0.124“* (gemessen: `grep -n E-157`) — nicht neu
  bewertet.
* Mechanische Prüfungen (`doku-pruefen.pl`, `offene-befunde.pl`) — die
  Commits ändern keine Kennung und keine Fassungsnummer.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)): genügt dein Ergebnis an 7.2.0.123 plus
  der Kurztest T1–T5 an 7.2.0.124, oder willst du am Paket 7.2.1.N noch
  einmal alle neun Kriterien durchgehen — und dazu gehört die Frage aus
  [L-77.3](#l-77.3): Kriterium 0 (*„läuft ohne Nachinstallieren“*) ist
  zuletzt am 06.09.2026 an 1.0.10 auf einem Rechner ohne Visual Studio
  geprüft; seither hat sich mit 7.2.0.124 die Zusammensetzung des Pakets
  geändert.
