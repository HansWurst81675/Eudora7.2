# <a id="lektor-80"></a>LEKTOR-80 — Prüfung vor dem PR des Zweigs `0.123_ergebnisse` nach `main`: Kurztest an 7.2.0.124, E-137 dritter Teil, Nachtrag E-142, 26.10.2026

**Auftrag.** Kurzprüfung vor dem PR: (1) ob [L-79.1](LEKTOR-79.md#l-79.1)
bis [L-79.3](LEKTOR-79.md#l-79.3) erledigt sind; (2) ob die neuen Einträge
(Ergebnistabelle T1–T5 in `Intern/TESTPLAN.md`, [E-137](../Intern/BEFUNDE.md#e-137) dritter Teil, Nachtrag
[E-142](../Intern/BEFUNDE.md#e-142), Stand in `Intern/WEITERMACHEN.md`, Entscheidung 11, Lehre
`Arbeitsweise/nur-testplan-zaehlt.md`) untereinander und mit
`Intern/BEFUNDE.md` stimmen — besonders, ob eine Stelle nach T1 *„nein im
ersten Durchgang“* und T4 *„nein“* noch etwas behauptet, das nicht mehr
stimmt; (3) was nach dem Merge auf `main` falsch wäre. Lauf über
`caf337b..e119d6ab` (7 Commits), gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor`. `origin/main` hat nichts, was der Zweig nicht hat
(gemessen: `git log HEAD..origin/main` leer) — nach dem Merge gilt auf `main`
genau der Stand dieses Zweigs.

**Ergebnis vorweg.** **9 Funde** (1 falsch, 5 veraltet, 3 unklar).
[L-79.1](LEKTOR-79.md#l-79.1) und [L-79.2](LEKTOR-79.md#l-79.2) sind erledigt,
[L-79.3](LEKTOR-79.md#l-79.3) nicht (Doppelung, hält nicht auf). **Falsch:**
[E-137](../Intern/BEFUNDE.md#e-137) ist seit `0b0b50de` aus beiden erzeugten
Listen offener Befunde verschwunden, obwohl er offen ist — ein kursives Zitat
im fettgedruckten Urteil blendet ihn für `tools/offene-befunde.pl` aus, und
das Werkzeug meldet trotzdem *„in beiden Listen gleich“* ([L-80.1](#l-80.1)).
Das ginge so nach `main`. Die übrigen Funde: die Buchführung in `BEFUNDE.md`
ist dem Kurztest nicht nachgezogen — [E-119](../Intern/BEFUNDE.md#e-119) und [E-158](../Intern/BEFUNDE.md#e-158) (T2, T3 *ja*) warten
dort und in `ZIEL.md` noch auf Gregors Bestätigung, [E-137](../Intern/BEFUNDE.md#e-137) nennt den zweiten
Durchgang nicht, [E-142](../Intern/BEFUNDE.md#e-142) erwartet noch T4. Nirgends wird [E-137](../Intern/BEFUNDE.md#e-137) oder [E-142](../Intern/BEFUNDE.md#e-142) als
für 7.2.0.124 bestätigt oder behoben ausgegeben (gemessen, siehe
[unten](#keine-falsche-bestaetigung)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-79

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-79.1](LEKTOR-79.md#l-79.1) | zweite Kriterientabelle vom 09.09.2026 in `Intern/AUFGABEN.md:145-151` | **erledigt** | `Intern/AUFGABEN.md:145-146` jetzt *„Der Stand der Kriterien steht in [ZIEL.md]; hier stand bis zum 26.10.2026 eine Tabelle mit dem Stand vom 09.09.2026.“* (belegt, Commit `4113310f`) |
| [L-79.2](LEKTOR-79.md#l-79.2) | Linkziel sagte *„Wird nach deiner Rückmeldung ausgefüllt“* | **erledigt** | `Intern/TESTPLAN.md:120` *„Ausgefüllt am 26.10.2026 nach deiner Rückmeldung.“* (belegt) |
| [L-79.3](LEKTOR-79.md#l-79.3) | `Intern/WEITERMACHEN.md:67-68` wiederholt die Entstehung der Kriterien aus `ZIEL.md` | **nicht erledigt** | `Intern/WEITERMACHEN.md:66-68` unverändert *„Gregor hat am 06.09.2026 die zweite Stufe gesetzt, Kriterien 4 bis 6 …“* (belegt). Doppelung, hält den PR nicht auf |

## <a id="keine-falsche-bestaetigung"></a>Wird E-137 oder E-142 irgendwo als bestätigt oder behoben für 7.2.0.124 ausgegeben?

Nein (gemessen: `grep -n -E 'E-137|E-142|1\.0\.124|7\.2\.0\.124'` über
`ZIEL.md`, `README.md`, `CHANGELOG.md`, `Releases/PAKETE.md`,
`Intern/WEITERMACHEN.md`, `Intern/AUFGABEN.md`). `CHANGELOG.md:102` nennt
7.2.0.124 *„Testpaket, noch nicht bestätigt“*; `CHANGELOG.md:118-121`
beschreiben, was eingebaut ist, nicht was bestätigt ist; `ZIEL.md:78` nennt
für [E-142](../Intern/BEFUNDE.md#e-142) nur den vereinbarten Hinweis. Die Lücken liegen in der anderen
Richtung — Bestätigungen, die vorliegen, sind nicht nachgetragen ([L-80.2](#l-80.2) bis
[L-80.4](#l-80.4)) — und an zwei Stellen, die das Verhalten nach T4 nicht kennen
([L-80.5](#l-80.5)).

## <a id="l-80.1"></a>L-80.1 — falsch: E-137 fehlt in den erzeugten Listen offener Befunde in `CHANGELOG.md` und `Intern/WEITERMACHEN.md`

* **Gemessen:** `perl tools/offene-befunde.pl` meldet *„41 offene Befunde, in
  beiden Listen gleich.“* (rc=0). [E-137](../Intern/BEFUNDE.md#e-137) steht in keinem der beiden Blöcke
  (`CHANGELOG.md:23-69`, `Intern/WEITERMACHEN.md:349-395`); bis `caf337b`
  stand er in `CHANGELOG.md:39` (`git show caf337b:CHANGELOG.md`). Commit
  `0b0b50de` hat die Zeile in beiden Dateien entfernt
  (`git diff caf337b..HEAD`: `@@ -39 +38,0 @@` und `@@ -365 +364,0 @@`).
* **Belegt, warum:** das Urteil `Intern/BEFUNDE.md:395` beginnt jetzt
  *„\*\*offen — an Paket 1.0.124 von Gregor NICHT bestanden (26.10.2026,
  TESTPLAN T1: \*„FAILED: CTRL-W schließt nicht filter fenster“\*); …\*\*“* —
  das kursive Zitat steht **innerhalb** des Fettdrucks. `offene-befunde.pl`
  sucht Fettstellen mit `/\*\*([^*]+?)\*\*/` und nimmt die erste als Urteil
  (`tools/offene-befunde.pl`, `my $w = lc $fett_alle[0]`). Gemessen mit
  derselben Regel: erste erkannte Fettstelle ist jetzt *„schwebenden“* (aus
  *„Rand des \*\*schwebenden\*\* Fensters“*) — kein Offen-Wort, also kein
  offener Befund. Bei `caf337b` war es *„Eingebaut am 26.10.2026, am Programm
  noch nicht gemessen:“*, das traf das Offen-Wort *„nicht gemessen“*.
* Wirkung: die Liste *„was noch fehlt“* im CHANGELOG, die nach dem Merge auf
  `main` und später in die Release-Notizen geht, verschweigt einen Befund, der
  vor 7.2.1 behoben sein soll (Entscheidung vom 25.10.2026,
  `Intern/WEITERMACHEN.md:121`). Die Schranke im `pre-commit` hat es nicht
  bemerkt, weil sie BEFUNDE und Listen mit **derselben** Lesart vergleicht.

**Was zu tun wäre:** im Urteil von [E-137](../Intern/BEFUNDE.md#e-137) das kursive Zitat aus dem
Fettdruck nehmen (etwa Fettdruck vor *„(26.10.2026, …“* schließen), dann
`perl tools/offene-befunde.pl -schreiben`. Dazu, als Klasse: das Werkzeug
sollte einen Befund melden, dessen Urteilsspalte zwar Fettstellen hat, aber
weder Offen- noch Erledigt-Wort in der ersten — heute fällt er stumm heraus
(Vorschlag, nicht gebaut).

## <a id="l-80.2"></a>L-80.2 — veraltet: E-137 in `BEFUNDE.md` kennt den zweiten Durchgang von T1 nicht

* `Intern/BEFUNDE.md:395` (belegt): *„offen — an Paket 1.0.124 von Gregor
  NICHT bestanden …“*; vom zweiten Durchgang steht in der Zeile nichts. —
  `Intern/TESTPLAN.md:31`: *„**ja** im zweiten Durchgang, **nein** im ersten
  … Gregor „[E-137](../Intern/BEFUNDE.md#e-137), T1 PASSED“; Protokoll sechsmal `[E-137](../Intern/BEFUNDE.md#e-137) Strg-W: Wazoo-Leiste
  wird versteckt`“*. Commit `093be9e3` hat nur `TESTPLAN`, `WEITERMACHEN` und
  die Lehre geändert (gemessen, `git log --stat`).
* Dieselbe Zeile: *„**Zuletzt gemessen: 26.10.2026 an 7.2.0.123**“* — gemessen
  wurde zuletzt in Gregors `eudora.log` an 1.0.124 (Zeile selbst: *„Gemessen in
  Gregors `eudora.log` an 1.0.124“*).
* `Intern/WEITERMACHEN.md:121` (belegt): *„[E-137](../Intern/BEFUNDE.md#e-137) — erster Teil … bestätigt,
  zweiter Teil im Kurztest T1“* — T1 ist gelaufen; offen ist jetzt der dritte
  Teil (Klick auf Titelzeile und Rand).

**Was zu tun wäre:** im Urteil beide Durchgänge nennen (zweiter Teil an
1.0.124 bestätigt, dritter Teil eingebaut, ungemessen), *Zuletzt gemessen* auf
7.2.0.124; in `WEITERMACHEN:121` *„dritter Teil im nächsten Testpaket“*.

## <a id="l-80.3"></a>L-80.3 — veraltet: E-119 und E-158 warten in `BEFUNDE.md` und `ZIEL.md` noch auf Gregors Bestätigung, die T2 und T3 gegeben haben

* `Intern/TESTPLAN.md:32-33` (belegt): T2 **ja** (`laenge=201951`), T3
  **ja** (*„[E-158](../Intern/BEFUNDE.md#e-158): PASS“*).
* `Intern/BEFUNDE.md:365` ([E-119](../Intern/BEFUNDE.md#e-119), belegt): *„Gregor prüft im Testpaket
  7.2.0.124“*; *Was noch fehlt:* *„Gregors Bestätigung am Testpaket 7.2.0.124
  (TESTPLAN T2)“*. Daraus erzeugt `ZIEL.md:52`: **„Stand: 24 von 25 erfüllt,
  1 offen“** mit [E-119](../Intern/BEFUNDE.md#e-119) als einzigem offenem Punkt (gemessen: `perl
  tools/ziel-stand.pl` → *„24 von 25 erfüllt, 1 offen – ZIEL.md ist auf dem
  Stand“*); ebenso `CHANGELOG.md:47`, `Intern/WEITERMACHEN.md:373`.
  `ZIEL.md:71` *„von Gregor noch nicht bestätigt“*.
* `Intern/BEFUNDE.md:382` ([E-158](../Intern/BEFUNDE.md#e-158), belegt): *„am Programm nach der Behebung
  noch nicht gemessen“*; *Was noch fehlt:* *„… Gregors Bestätigung am
  Testpaket 7.2.0.124“*. `ZIEL.md:75` *„von Gregor im Testpaket zu
  bestätigen“*, `ZIEL.md:203` (Kriterium 6) *„Gregors Bestätigung im Kurztest
  T3“*.
* Folge: der Zähler in `ZIEL.md` zeigt nach dem Merge einen offenen Punkt, der
  erledigt ist — und der Maßstab für 7.2.1 sähe aus, als fehle noch etwas.
  Bei [E-158](../Intern/BEFUNDE.md#e-158) bleibt der Prüfstandsfall offen; das ist richtig so.

**Was zu tun wäre:** beide Urteile mit Gregors Ergebnis an 1.0.124
fortschreiben, `perl tools/ziel-stand.pl` und `offene-befunde.pl -schreiben`
neu setzen lassen, `ZIEL.md:71/75/203` nachziehen.

## <a id="l-80.4"></a>L-80.4 — veraltet: E-142 erwartet noch T4, und *„vor 7.2.1 nichts“* steht neben einer offenen Entscheidung

* `Intern/BEFUNDE.md:378` (belegt): *„seit 7.2.0.124 ist *No* vorgewählt,
  das prüft Gregor im Kurztest T4“* und weiter hinten *„Gregor prüft es im
  Testpaket 7.2.0.124“*. — T4 ist gelaufen (`Intern/TESTPLAN.md:34`,
  **nein**); die Rückfrage kam nicht, die Vorwahl *No* ist am Programm also
  **nicht** gemessen. Der Nachtrag in derselben Zeile sagt das, die beiden
  älteren Sätze stehen trotzdem.
* *Was noch fehlt:* *„vor 7.2.1 nichts — vereinbart ist der Hinweis, und der
  ist eingebaut“* — übernommen in `CHANGELOG.md:34` und
  `Intern/WEITERMACHEN.md:360`. Nach T4 liegt eine Entscheidung bei Gregor
  (`Intern/TESTPLAN.md:34` *„Ob das so bleiben soll oder die Entwurfsmarke
  erhalten werden muss, entscheidet Gregor“*); ob sie vor 7.2.1 fällt, steht
  nirgends.
* *Zuletzt gemessen: 26.10.2026 an 7.2.0.123* — gemessen wurde zuletzt an
  1.0.124 (Nachtrag T4).

**Was zu tun wäre:** die zwei Sätze *„prüft Gregor im Kurztest T4“* durch
das Ergebnis ersetzen; *Was noch fehlt* um die offene Entscheidung ergänzen;
*Zuletzt gemessen* auf 7.2.0.124.

## <a id="l-80.5"></a>L-80.5 — unklar: `README.md:172` sagt, ab 7.2.1 frage Eudora nach — in T4 kam keine Frage, sondern die Ablehnung

* `README.md:172` (belegt): *„Ab dem Release 7.2.1 fragt Eudora vorher nach
  und weist darauf hin“*.
* `Intern/TESTPLAN.md:34` (gemessen in Gregors Protokoll): nachdem der Entwurf
  aus *Gelöscht* vom Server neu geladen war, kam *„Messages can't be
  transferred to the Out mailbox“* (`E-125 Xfer nach Out abgelehnt`), keine
  Rückfrage. An 1.0.123 (TESTPLAN N3) kam sie — dort war die Nachricht nach
  der Vermutung im Nachtrag noch nicht neu geladen.
* Die README-Zeile stimmt also nur für einen Teil der Fälle; für den in T4
  gemessenen Weg entsteht gar keine leere Nachricht, weil nichts übertragen
  wird. Ebenso `CHANGELOG.md:121` *„die Rückfrage … wählt jetzt No vor“* —
  am Quelltext richtig, am Programm durch T4 nicht gezeigt.
* Unklar und nicht falsch, weil Gregor erst entscheidet, ob die Ablehnung
  so bleibt (siehe unten).

**Was zu tun wäre:** nach Gregors Entscheidung zu T4 die README-Zeile
anpassen (etwa *„… fragt Eudora vorher nach; ist der Entwurf inzwischen vom
Server neu geladen, lehnt Eudora das Verschieben ab“*).

## <a id="l-80.6"></a>L-80.6 — unklar: der dritte Teil von E-137 kommt mit Fassungsnummer 7.2.0.124 nach `main`, steht aber in keinem CHANGELOG-Abschnitt

* Gemessen: `Eudora71/Version.h:11` `EUDORA_VERSION4 124`, `VERSION`
  `1.0.124`. Commit `0b0b50de` (14:02) ändert `workbook.cpp`/`workbook.h` nach
  dem Schnüren von 1.0.124 (`Releases/PAKETE.md:161` *„Geschnürt am
  26.10.2026 um 13:10“*). Im `CHANGELOG.md` steht der dritte Teil nirgends
  (gemessen: `grep -n -i 'dritter Teil\|QCMiniDockFrameWnd\|schwebenden
  Leiste'` trifft nur alte Abschnitte); der Commit hat am CHANGELOG nur die
  erzeugte Zeile entfernt.
* `CHANGELOG.md:102` (belegt): *„Quellstand 7.2.0.124, Paket 1.0.124“* — nach
  dem Merge trägt `main` die Nummer 7.2.0.124 mit Code, der nicht im Paket
  1.0.124 ist. Unterscheidbar bleibt der Bau nur über die Kennung hinter dem
  `+` in der Titelzeile.
* Der Plan steht in `Intern/WEITERMACHEN.md:132`: *„danach Quellstand auf
  7.2.0.125 heben (erst dann gibt es diese Nummer)“* — nach der Regel
  *Nummer erst beim Schnüren* gewollt. Unklar ist nur, wo der Leser von
  `main` bis dahin erfährt, dass der Quellstand mehr enthält als das Paket.

**Was zu tun wäre:** im CHANGELOG unter 7.2.0.124 ein Satz *„Nach dem Paket
auf dem Zweig, kommt mit dem nächsten Testpaket: [E-137](../Intern/BEFUNDE.md#e-137) dritter Teil (Klick auf
Titelzeile oder Rand der schwebenden Leiste)“* — oder es bewusst so lassen;
das entscheidet, wer den PR stellt.

## <a id="l-80.7"></a>L-80.7 — veraltet: der Stand in `Intern/WEITERMACHEN.md:132` nennt T3 und T4 als noch zu fahren

* `Intern/WEITERMACHEN.md:132` (belegt): *„Stand 26.10.2026, 14:22 …
  **Als Nächstes:** Gregor fährt T3–T5 an 1.0.124“* — in derselben Zeile
  stehen schon *„T3 ja“* und *„T4 nein“*; die Ergebnisse kamen mit
  `541d14b3` (14:35) und `e119d6ab` (14:40) (gemessen, `git log
  --date=iso`). Die Uhrzeit 14:22 ist die von `a95c49bb`.
* Offen ist nur noch T5, und das zählt nach `Intern/TESTPLAN.md:25` *ich*
  (*„danach zähle ich im Windows-Ereignisprotokoll“*), nicht Gregor.

**Was zu tun wäre:** *„Als Nächstes: T5 auswerten (Ereignisprotokoll zählen);
Gregors Entscheidung zu T4; dann 7.2.0.125 …“*, Uhrzeit nachziehen.

## <a id="l-80.8"></a>L-80.8 — veraltet: `Releases/PAKETE.md:6` sagt, 1.0.124 folge noch

* `Releases/PAKETE.md:6` (belegt): *„geschnürt ist bis 1.0.123, 1.0.124
  folgt“* — `Releases/PAKETE.md:161`: *„Geschnürt am 26.10.2026 um 13:10 und
  als Testverzeichnis abgelegt“*, mit ZIP und SHA-256 (`:167`).
* Gemessen: der Satz stammt aus `8bdab960` (12:20), vor dem Schnüren; nicht
  aus dem Prüfumfang seit `caf337b`, geht aber mit dem PR nach `main`.

**Was zu tun wäre:** *„geschnürt ist bis 1.0.124“*.

## <a id="l-80.9"></a>L-80.9 — unklar: die neue Lehre nennt eine Schranke, die ihre Regel nicht prüft

* `Arbeitsweise/nur-testplan-zaehlt.md:17` (belegt): *„Schranke: keine – …
  Wirksam wird sie dadurch, dass Testschritte nur in Intern/TESTPLAN.md
  entstehen und pruefe-tabellenzeilen.pl dort jede Tabellenzeile prüft.“*
* `tools/pruefe-tabellenzeilen.pl:5` (belegt): *„steht jede
  Markdown-Tabellenzeile auf EINER Zeile?“* — das Werkzeug prüft das Format
  von Tabellenzeilen, nicht, ob eine Testanweisung im TESTPLAN steht oder nur
  im Chat. Der erste Halbsatz (*„Schranke: keine“*) ist ehrlich, der zweite
  liest sich wie eine Absicherung, die es nicht gibt.

**Was zu tun wäre:** den zweiten Satz streichen oder sagen, was
`pruefe-tabellenzeilen.pl` wirklich sichert (dass Gregors Testtabelle auf
GitHub lesbar bleibt).

---

## Geprüft ohne Fund

* **Entscheidung 11** (`Intern/WEITERMACHEN.md:130`, kein README-Hinweis zu
  den Debug-Fassungen für Anwender von `v1.0.120`): kein solcher Hinweis in
  `README.md` (gemessen, `grep -n -i 'v1.0.120.*Debug\|Hinweis.*v1.0.120'`
  ohne Treffer außerhalb von `Befunde/`).
* **Lehre** `nur-testplan-zaehlt`: in `Arbeitsweise/MEMORY.md` und der Tabelle
  in `Arbeitsweise/README.md` eingetragen; die verlinkten
  `chat-knapp-halten.md` und `testschritt-nennt-den-ort.md` gibt es
  (gemessen, `ls`).
* **TESTPLAN T1–T4** gegen `BEFUNDE.md`: Zitate und Protokollzeilen in
  `Intern/TESTPLAN.md:31,34` stimmen wörtlich mit `Intern/BEFUNDE.md:395`
  (dritter Teil) und `:378` (Nachtrag T4) überein (belegt).
* **Nach dem Merge** fällt die Kurztest-Tabelle nicht weg: `origin/main` hat
  `Intern/TESTPLAN.md` noch mit Kopf *„Quellstand 7.2.0.123“*, der Zweig
  ersetzt ihn; Commits, die `main` hat und der Zweig nicht, gibt es nicht
  (gemessen).

## Nicht geprüft

* Alles außerhalb von `caf337b..e119d6ab` außer den genannten Gegenstellen;
  der Quelltext von `0b0b50de` (`workbook.cpp`, `TestE137.cpp`) — das ist
  PRÜFER-Sache.
* Mechanische Prüfungen außer `offene-befunde.pl` und `ziel-stand.pl`.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)): genügt dein Ergebnis an 7.2.0.123 plus
  der Kurztest an 7.2.0.124 (und der Kurztest am nächsten Paket für den
  dritten Teil von [E-137](../Intern/BEFUNDE.md#e-137)), oder willst du am Paket 7.2.1.N noch einmal alle
  neun Kriterien durchgehen?
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)): zuletzt
  am 06.09.2026 an 1.0.10 geprüft; seit 7.2.0.124 ist die Zusammensetzung des
  Pakets anders. Muss der Test wiederholt werden?
* **T4:** soll ein Entwurf, der nach dem Verschieben in einen IMAP-Ordner von
  dort neu geladen wurde, wieder als Entwurf gelten (dann kommt die
  E-142-Rückfrage), oder bleibt es bei der Ablehnung *„Messages can't be
  transferred to the Out mailbox“*? Verloren geht in beiden Fällen nichts.
