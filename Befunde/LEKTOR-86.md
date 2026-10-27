# <a id="lektor-86"></a>LEKTOR-86 — Kurzprüfung vor dem PR des Zweigs `0.125_ergebnisse` nach `main`: Berichtigungen zu LEKTOR-85, Korrektur PRÜFER-62 K1/K2, Fassung 7.2.0.127 / Paket 1.0.127, 27.10.2026

**Auftrag.** Kurzprüfung vor dem PR. Umfang: die Commits seit
[LEKTOR-85](LEKTOR-85.md) (`git log 634414a0..HEAD`: `12210622` [LEKTOR-85](LEKTOR-85.md#lektor-85)
eingearbeitet, `9c88d1c2` Behebung PRÜFER-62 K1/K2, `ea3ebcbd`
Fassungssprung 7.2.0.127 / 1.0.127, `46f4a5f5` Prüfstand 39/39,
`ce5cda3e` Paket 1.0.127 geschnürt), dazu ob [L-85.1](LEKTOR-85.md#l-85.1)
bis .4, .6 und [L-84.9](LEKTOR-84.md#l-84.9) richtig angekommen sind.
Schwerpunkte: kann Gregor den Kurztest V1–V6 an
`C:\Users\Gregor\Eudora72-1.0.127-release` ohne Rückfrage fahren; steht
irgendwo noch 1.0.126 als das zu testende Paket; stimmen Fassung, Paket und
Testzahlen in README, ZIEL, WEITERMACHEN, AUFGABEN, CHANGELOG, PAKETE,
PRUEFBERICHT überein; erklärt etwas [E-137](../Intern/BEFUNDE.md#e-137)
(Strg+W nach einem Klick auf die Filterleiste schließt die Mail statt der
Leiste) oder [E-160](../Intern/BEFUNDE.md#e-160) (Windows-Meldung „kein
E-Mail-Programm zugeordnet“ beim Anlegen einer Persönlichkeit) für behoben
oder bestätigt. Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf
`ce5cda3e`; `origin/0.125_ergebnisse` steht auf `f606cb06`, der nur
`tools/AGENTEN-LAUFEN.md` ändert (gemessen, `git log`).

**Ergebnis vorweg.** **7 Funde: 2 falsch, 4 veraltet, 1 unklar.**
[L-85.1](LEKTOR-85.md#l-85.1) bis .4, .6, .7 und [L-84.9](LEKTOR-84.md#l-84.9)
sind erledigt. **Nirgends wird [E-137](../Intern/BEFUNDE.md#e-137) oder [E-160](../Intern/BEFUNDE.md#e-160) als behoben oder bestätigt
ausgegeben**; nur die Korrektur K1 innerhalb von [E-137](../Intern/BEFUNDE.md#e-137) heißt an drei
Stellen „behoben“, obwohl sie am Programm nicht gemessen ist
([L-86.5](#l-86.5)). **Der Kurztest V1–V6 ist ohne Rückfrage ausführbar**
([unten](#kurztest)). Die zwei falschen Stellen: `Releases/PAKETE.md:173`
sagt, beim Schnüren von 1.0.127 sei nur der CHRONIST fällig gewesen — der
PRÜFER war es auch, die K1-Korrektur in `mainfrm.cpp` hat niemand
gegengelesen ([L-86.1](#l-86.1)); `Intern/WEITERMACHEN.md:121`
(Entscheidung 2) nennt als zu prüfendes Paket noch *„an 1.0.126 zu prüfen
(V1–V3)“* ([L-86.2](#l-86.2)). **Vor dem PR zu berichtigen: [L-86.1](#l-86.1) bis
[L-86.4](#l-86.4)**, [L-86.5](#l-86.5) im selben Commit empfohlen.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-85 und L-84.9

| Fund | was passierte | Stand heute | Beleg |
|---|---|---|---|
| [L-85.1](LEKTOR-85.md#l-85.1) | E-137-Kopf sagte „am Programm noch nicht gemessen“, Messdatum 26.10. an 7.2.0.125 | **erledigt**; durch den neuen Prüfstandslauf an 1.0.127 schon wieder einen Bau zurück → [L-86.4](#l-86.4) | `Intern/BEFUNDE.md:396` Kopf *„am Prüfstand gemessen (Fälle E-137a bis E-137c, rot an 1.0.125, grün an 1.0.126) — mit Fensterbotschaften statt echtem Mausklick und Strg+W, vor dem Postfach In statt einer geöffneten Mail, ohne den angedockten Fall V3. Gregors Test steht aus.“*; *„Zuletzt gemessen: 27.10.2026 an 7.2.0.126“* |
| [L-85.2](LEKTOR-85.md#l-85.2) | ZIEL meldete für [E-160](../Intern/BEFUNDE.md#e-160) „wer ?“, „nicht aufgeschrieben“ | **erledigt**, Rest in `ZIEL.md:77` → [L-86.3](#l-86.3) | `ZIEL.md:52` *„\| \*\*[E-160](../Intern/BEFUNDE.md#e-160)\*\* \| Gregor \| Gregors Prüfung an Paket 1.0.127 (TESTPLAN V4): \*Tools → Personalities\* …“*; `Intern/BEFUNDE.md:381` *„\*\*Wie zu pruefen:\*\* \*\*GREGOR\*\* — TESTPLAN V4“* |
| [L-85.3](LEKTOR-85.md#l-85.3) | README/AUFGABEN „vierter Teil“ | **erledigt** | `README.md:101` *„Testpaket mit dem fünften Anlauf zu [[E-137](../Intern/BEFUNDE.md#e-137)]“*; `Intern/AUFGABEN.md:3` *„fünften Anlauf zu [[E-137](../Intern/BEFUNDE.md#e-137)] samt Korrektur aus PRÜFER-62 K1“* |
| [L-85.4](LEKTOR-85.md#l-85.4) | [E-137](../Intern/BEFUNDE.md#e-137) nicht im Maßstab | **erledigt** | `ZIEL.md:53` (erzeugt) und `:78`; gemessen: `ziel-stand.pl` → *„25 von 27 erfüllt, 2 offen“* |
| [L-85.5](LEKTOR-85.md#l-85.5) | fünfter Anlauf von keinem PRÜFER gelesen | **erledigt** durch [PRÜFER-62](PRUEFER-62.md) (`53e7a718`); dessen Korrektur selbst ist wieder ungelesen → [L-86.1](#l-86.1) | gemessen: `rollen-faellig.pl` → *„PRUEFER ist faellig: seit seinem Bericht (53e7a71) haben sich 4 Datei(en) … geaendert - Eudora71/Eudora/mainfrm.cpp, Eudora71/Eudora/mainfrm.h, Eudora71/Tests/TestE137.cpp und 1 weitere.“* |
| [L-85.6](LEKTOR-85.md#l-85.6) | WEITERMACHEN: „danach PR“, Kopfdatum, „Quellstand davor“ | **erledigt** | `Intern/WEITERMACHEN.md:3` *„Stand 27.10.2026.“*; `:10` beginnt *„7.2.0.125 (Paket 1.0.125, 26.10.2026, Kurztest U1 nicht bestanden); 7.2.0.124 …“*; `:135` *„Als Nächstes: PR — Gregor merged; Gregors Kurztest V1–V6“* |
| [L-85.7](LEKTOR-85.md#l-85.7) | PRUEFBERICHT: Dauer für 36 Fälle | **erledigt** (voller Lauf) | `Releases/PRUEFBERICHT.md:16` *„Pruefstand, 39 Faelle, 12 Eudora-Starts \| 6 min 31 s \| voller Lauf, Ende 2026-10-27 14:20:45“* |
| [L-84.9](LEKTOR-84.md#l-84.9) | PAKETE vermerkte Gregors Test an 1.0.124/1.0.125 nicht | **erledigt** | `Releases/PAKETE.md:212` (1.0.124) *„Von Gregor am 26.10.2026 im Kurztest geprüft: T1 im zweiten Durchgang, T2, T3 und T5 bestanden, T4 und T6 nicht“*; Abschnitt 1.0.125 *„Von Gregor am 26.10.2026 im Kurztest geprüft: U1 nicht bestanden, U2 bis U4 nicht getestet“* |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | was sie **nicht** sieht |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Quellstand 7.2.0.127, Paketnummer 1.0.127 … gepruefte Dateien 47 … Kein Widerspruch gefunden.“* Zur Kenntnis u. a. *„tools/ZWEIGE.md … hoechste genannte Fassung: 7.2.0.126“* | eine Zeile, die 1.0.127 **und** 1.0.126 nennt ([L-86.2](#l-86.2), [L-86.3](#l-86.3)) |
| `perl tools/offene-befunde.pl` | *„42 offene Befunde, in beiden Listen gleich.“* rc=0 | dass das Messdatum von [E-137](../Intern/BEFUNDE.md#e-137) einen Bau zurück ist ([L-86.4](#l-86.4)) |
| `perl tools/pruefe-regressionstest.pl` | *„OHNE jede Pruefung 22 <- Rueckstand“*; *„Kein neues "behoben" ohne Regressionstest.“* | — |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 25 von 27 erfüllt, 2 offen - ZIEL.md ist auf dem Stand.“* | die handgeschriebenen Zeilen `ZIEL.md:77-78` ([L-86.3](#l-86.3)) |
| `perl tools/pruefe-befundurteile.pl` | *„Kein Dokument erklaert einen offenen Befund fuer erledigt“* rc=0 | „behoben“ für einen Teilfund (K1) innerhalb eines offenen Befunds ([L-86.5](#l-86.5)) |
| `perl tools/rollen-faellig.pl` | LEKTOR, **PRÜFER** (`mainfrm.cpp`, `mainfrm.h`, `TestE137.cpp` und 1 weitere) und CHRONIST fällig | — ([L-86.1](#l-86.1)) |

---

## <a id="l-86.1"></a>L-86.1 — falsch: PAKETE sagt für 1.0.127 „fällig blieb der CHRONIST“ — der PRÜFER war ebenfalls fällig, die K1-Korrektur ist ungelesen

**Was passiert:** wer den Paketeintrag liest, hält den Code in 1.0.127 für
gegengelesen. Die Korrektur zu PRÜFER-62 K1 (Strg+W nach Doppelklick auf
ein Postfach in *Mailboxes* hätte die Leiste versteckt) ändert
`CMainFrame::OnCommand` und `OnActivateApp` — also wieder den Weg, den jedes
Strg+W nimmt — und hat außer Unit-Test und Prüfstand niemand gelesen.

* **Belegt**, `Releases/PAKETE.md:173`: *„Rollenschranke \| gebaut mit
  `-RollenSindGelaufen`: PRÜFER-62 und [LEKTOR-85](LEKTOR-85.md#lektor-85) waren gelaufen und
  eingearbeitet; danach nur die Behebung von PRÜFER-62 K1/K2 und der
  Versionssprung; fällig blieb der CHRONIST, der nur Lehren betrifft“*.
* **Gemessen**, `perl tools/rollen-faellig.pl` auf `ce5cda3e` (dem
  Paket-Commit): *„PRUEFER ist faellig: seit seinem Bericht (53e7a71) haben
  sich 4 Datei(en) in seinem Bereich geaendert - Eudora71/Eudora/mainfrm.cpp,
  Eudora71/Eudora/mainfrm.h, Eudora71/Tests/TestE137.cpp und 1 weitere.“*
  `9c88d1c2` (die Korrektur) liegt vor `ea3ebcbd` (Bau) — der PRÜFER war also
  schon beim Schnüren fällig (gemessen, `git merge-base --is-ancestor`).
* Beim Vorgänger stand es richtig: `Releases/PAKETE.md:189` (1.0.126)
  *„Danach kam der fünfte Anlauf zu [E-137](../Intern/BEFUNDE.md#e-137) — \*\*von keinem PRÜFER
  gegengelesen\*\*“*.
* **Gemessen**, `origin/0.125_ergebnisse:tools/AGENTEN-LAUFEN.md`:
  *„PRUEFER \| 2026-10-27 14:26 \| PRUEFER-63.md: Aenderungen seit 53e7a718
  gegen die Quelle“* — der Lauf ist angestoßen.

**Was zu tun wäre:** `:173` wie bei 1.0.126 offen sagen, etwa *„danach die
Behebung von PRÜFER-62 K1/K2 (`mainfrm.cpp`) — **von keinem PRÜFER
gegengelesen**, PRÜFER-63 läuft; Unit-Test 314/314 und Prüfstand 39/39 am
selben Bau“*. **Vor dem PR.** Ob der PR auf PRÜFER-63 wartet, entscheidet
der Hauptagent.

## <a id="l-86.2"></a>L-86.2 — falsch: Entscheidung 2 in WEITERMACHEN nennt „an 1.0.126 zu prüfen (V1–V3)“

**Was passiert:** genau die Aussage, die nirgends mehr stehen soll: 1.0.126
als das zu testende Paket, ohne die Gegenprobe V6.

* **Belegt**, `Intern/WEITERMACHEN.md:121`: *„2. \*\*Vor 7.2.1 beheben:\*\*
  [[E-137](../Intern/BEFUNDE.md#e-137)] — … an 1.0.125 nicht bestanden (U1), fünfter Anlauf eingebaut, an
  1.0.126 zu prüfen (V1–V3)“*.
* **Belegt**, Gegenstück: `Intern/TESTPLAN.md:3-5` *„Das Paket 1.0.126 bitte
  \*\*nicht\*\* testen“*; `Intern/WEITERMACHEN.md:135` *„neue Fassung
  \*\*7.2.0.127 / 1.0.127\*\* statt 1.0.126“*.
* **Gemessen:** `grep -n -E '1\.0\.126|7\.2\.0\.126'` über README,
  README.en, ZIEL, WEITERMACHEN, AUFGABEN, CHANGELOG, PAKETE, PRUEFBERICHT,
  TESTPLAN, `Doku/*.md`, `tools/WERKZEUGE.md` — jede Fundstelle gelesen;
  als **zu testendes** Paket nennen 1.0.126 nur diese Zeile und
  `ZIEL.md:77-78` ([L-86.3](#l-86.3)). Alle übrigen sagen *„nie getestet,
  ersetzt“* oder sind Geschichte.

**Was zu tun wäre:** *„… fünfter Anlauf eingebaut, mit Korrektur aus
PRÜFER-62 K1 an 1.0.127 zu prüfen (V1–V3, Gegenprobe V6)“*. **Vor dem PR.**

## <a id="l-86.3"></a>L-86.3 — veraltet: `ZIEL.md:77-78` — E-160 „*Persona* → *Neu*“, „kommt mit 7.2.0.126“; E-137 „fünfter Anlauf in 7.2.0.126 … TESTPLAN V1–V3“ ohne K1 und V6

**Was passiert:** der Maßstab für 7.2.1 nennt in seinen handgeschriebenen
Zeilen das nie getestete 7.2.0.126 als Träger beider Behebungen, den alten
Menüweg aus [L-85.2](LEKTOR-85.md#l-85.2) und für [E-137](../Intern/BEFUNDE.md#e-137) nur V1–V3; der
erzeugte Block darüber (`:52-53`) sagt richtig 1.0.127 und V6.

* **Belegt**, `ZIEL.md:77`: *„beim Anlegen einer Persönlichkeit (\*Persona\*
  → \*Neu\*) … (\*\*Behebung eingebaut\*\*, kommt mit 7.2.0.126; Unit-Test rot
  ohne und grün mit, am Programm noch nicht gemessen — TESTPLAN V4)“*.
* **Belegt**, `ZIEL.md:78`: *„fünfter Anlauf in 7.2.0.126, am Prüfstand rot
  an 1.0.125 und grün an 1.0.126 — TESTPLAN V1–V3)“*.
* **Belegt**, Gegenstück: `ZIEL.md:53` *„Gregors Prüfung an 1.0.127 (TESTPLAN
  V1–V3, Gegenprobe V6)“*; `Intern/TESTPLAN.md:27` V4 *„Tools →
  Personalities … → New...“*.

**Was zu tun wäre:** `:77` *„(\*Tools → Personalities\*, Rechtsklick →
\*New...\*) … kommt mit 7.2.0.127“*; `:78` *„fünfter Anlauf in 7.2.0.126,
korrigiert in 7.2.0.127 (PRÜFER-62 K1); am Prüfstand rot an 1.0.125, grün an
1.0.126 und 1.0.127 — TESTPLAN V1–V3 und V6“*. **Vor dem PR** — `ZIEL.md`
ist der Maßstab, auf den README verweist.

## <a id="l-86.4"></a>L-86.4 — veraltet: E-137 „Zuletzt gemessen: 27.10.2026 an 7.2.0.126“, Kopf „grün an 1.0.126“ — der Prüfstand lief seither an 7.2.0.127 grün

**Was passiert:** das Urteil verschweigt, dass die Fälle E-137a–c auch mit
der K1-Korrektur grün sind — also die Korrektur V1/V2 nicht gebrochen hat.
Die erzeugten Listen tragen das alte Datum weiter.

* **Belegt**, `Intern/BEFUNDE.md:396`: *„grün an 1.0.126“* (Kopf);
  *„\*\*Zuletzt gemessen: 27.10.2026 an 7.2.0.126\*\*“*.
* **Gemessen**, `Intern/pruefstand-buch.tsv`: *„E-137a ok 2026-10-27
  14:20:45 C:\Temp\E137 Eudora 7.2.0.127 / Paket 1.0.127+ea3ebcbd“*, ebenso
  `E-137b`, `E-137c` (*„zuletzt-angeklickte-leiste=ja“*).
* **Folge, belegt:** `CHANGELOG.md:40` und `Intern/WEITERMACHEN.md:371`
  (erzeugt) *„27.10.2026 an 7.2.0.126“*.

**Was zu tun wäre:** Kopf *„grün an 1.0.126 und 1.0.127“*, *„Zuletzt
gemessen: 27.10.2026 an 7.2.0.127 (Prüfstand)“*, dann
`perl tools/offene-befunde.pl -schreiben`. **Vor dem PR** (eine Zeile und
der Erzeuger).

## <a id="l-86.5"></a>L-86.5 — unklar: die K1-Korrektur heißt „behoben“ und „schließt wieder das Postfach“, ist aber am Programm nicht gemessen

**Was passiert:** [E-137](../Intern/BEFUNDE.md#e-137) selbst bleibt überall offen, aber die Korrektur
seiner Nebenwirkung wird an drei Stellen als Tatsache gemeldet. Dass sie
greift, zeigt erst Gregors V6; Unit-Test und Prüfstand fahren die
Gegenrichtung nicht ([PRÜFER-62](PRUEFER-62.md) K3, Messtabelle `:296` *„die
Gegenrichtung: ob Strg+W ein Fenster \*\*schließt\*\*, wenn es soll“* — kein
Fall).

* **Belegt**, `Intern/BEFUNDE.md:396`: *„\*\*K1 — Nebenwirkung des fünften
  Anlaufs, behoben am selben Tag:\*\*“* — im selben Eintrag weiter hinten
  *„Am Programm ist K1 noch nicht gemessen.“*
* **Belegt**, `Intern/WEITERMACHEN.md:135`: *„PRÜFER-62 K1 (Strg+W nach
  Doppelklick auf ein Postfach in \*Mailboxes\* versteckte die Leiste)
  behoben“*.
* **Belegt**, `CHANGELOG.md:106-108`: *„Strg+W nach einem Doppelklick auf ein
  Postfach in \*Mailboxes\* schließt wieder das Postfach. In 7.2.0.126 hätte
  es die Leiste \*Mailboxes\* versteckt“* — PRÜFER-62 selbst sagt
  *„Logik am Quelltext belegt, Fokuslage Vermutung“* (`Befunde/PRUEFER-62.md:208`)
  und *„vermutlich“* (`:30`).
* Kein Werkzeug sieht das: `pruefe-befundurteile.pl` prüft nur das Urteil
  ganzer Befunde (gemessen rc=0).

**Was zu tun wäre:** *„korrigiert am selben Tag, am Programm nicht gemessen
(Gegenprobe V6)“*; im CHANGELOG *„soll wieder das Postfach schließen“* wie
schon bei [E-160](../Intern/BEFUNDE.md#e-160) ([L-84.8](LEKTOR-84.md#l-84.8)). Hindert den PR nicht,
im selben Commit wie [L-86.4](#l-86.4) empfohlen.

## <a id="l-86.6"></a>L-86.6 — veraltet: TESTPLAN — U-Ergebnisse „gehen in V… an 7.2.0.126 auf“, Rückmelderegel nur für V1–V3

**Was passiert:** Kleinigkeiten im Testplan; Gregor kann trotzdem ohne
Rückfrage testen.

* **Belegt**, `Intern/TESTPLAN.md:45` *„Kurztest 7.2.0.125 — überholt durch
  7.2.0.126“*; `:67-69` *„nicht getestet, geht in V2 an 7.2.0.126 auf“* (V3,
  V5 ebenso) — die V-Schritte laufen an 7.2.0.127.
* **Belegt**, `:31` *„Geht V1, V2 oder V3 schief, genügt mir die Nummer und
  \*nein\*“* — für V6, das dieselbe Logzeile `E-137 Strg-W angekommen` (jetzt
  mit `mdi-gewechselt=`) auswertet, steht nichts; die Form „Nummer und
  nein“ kennt Gregor aus allen Kurztests (Vermutung, dass er sie überträgt).

**Was zu tun wäre:** `7.2.0.126` → `7.2.0.127` an den vier Stellen; `:31`
*„V1, V2, V3 oder V6“*. Hindert den PR nicht.

## <a id="l-86.7"></a>L-86.7 — veraltet: `tools/ZWEIGE.md:175` — Zweig `0.125_ergebnisse` mit „vierter Anlauf“, „Testpaket 7.2.0.126“, „*Persona → Neu*“

* **Belegt**, `tools/ZWEIGE.md:175`: *„vierter Anlauf zu [[E-137](../Intern/BEFUNDE.md#e-137)] … [[E-160](../Intern/BEFUNDE.md#e-160)]
  (Windows-Meldung bei \*Persona → Neu\*); Testpaket 7.2.0.126“*. In
  [L-85.3](LEKTOR-85.md#l-85.3) als geschichtlich (Zweck bei Vereinbarung)
  durchgelassen; mit dem Fassungssprung trägt der Zweig aber 7.2.0.127, und
  `doku-pruefen.pl` meldet die Datei zur Kenntnis (*„hoechste genannte
  Fassung: 7.2.0.126“*).

**Was zu tun wäre:** ein Nachsatz *„; ersetzt durch Testpaket 7.2.0.127
(fünfter Anlauf mit Korrektur PRÜFER-62 K1)“*. Hindert den PR nicht.

---

## <a id="kurztest"></a>Kann Gregor V1–V6 an 1.0.127 ohne Rückfrage fahren?

**Ja** (belegt).

* Kopf und Vorbereitung `Intern/TESTPLAN.md:1-20`: *„Das Paket 1.0.126 bitte
  \*\*nicht\*\* testen“*; Ordner `C:\Users\Gregor\Eudora72-1.0.127-release`,
  Daten aus `…-1.0.125-release\Mailverzeichnis` ohne `eudora.log`, Start
  nur über `Eudora starten.cmd`, Titelzeile *„7.2.0.127“* und *„Paket
  1.0.127“* — gleich mit `Releases/PAKETE.md:168` (*„neben seinem 1.0.125
  und dem nie getesteten 1.0.126 … Gregor kopiert seine Daten aus 1.0.125
  hinein“*) und `Eudora71/Version.h:11` `EUDORA_VERSION4 127`, `VERSION`
  `1.0.127` (gemessen).
* V1–V5 wortgleich mit den in [LEKTOR-84](LEKTOR-84.md#lektor-84)/-85 geprüften Schritten; V5 nennt
  jetzt `Eudora72-1.0.127-release`.
* **V6 neu:** *„die Leiste \*Mailboxes\* öffnen (\*Tools → Mailboxes\*),
  dort ein lokales Postfach (etwa `Trash`) \*\*doppelklicken\*\*, gleich danach
  \*\*Strg+W\*\*“*. Menüweg belegt am Original:
  `Eudora71/Eudora/EudoraRes.rc:5805` `POPUP "&Tools"`, `:5810`
  `MENUITEM "&Mailboxes", ID_WINDOW_MAILBOXES`. Erwartung (*„das eben
  geöffnete Postfach geht zu, die Leiste \*Mailboxes\* bleibt stehen“*)
  entspricht PRÜFER-62 K1 (`Befunde/PRUEFER-62.md:29-32`).
* Rückmeldung: siehe [L-86.6](#l-86.6) (V6 nicht genannt) — kein Hindernis.
* Nicht geprüft: ob das Verzeichnis bei Gregor tatsächlich so liegt — sein
  Testverzeichnis fasst dieser Auftrag nicht an; `PAKETE.md:169` nennt ZIP
  und SHA-256 `fe72349f…`.

## <a id="keine-falsche-bestaetigung"></a>Wird E-137 oder E-160 irgendwo als behoben oder bestätigt ausgegeben?

**Nein** (gemessen: `grep -n -i -E '(e-137|e-160|K1).{0,200}(behoben|bestätigt|erledigt)'`
über README, README.en, ZIEL, CHANGELOG, WEITERMACHEN, AUFGABEN, TESTPLAN,
PAKETE, WERKZEUGE, `Doku/*.md`, jede Fundstelle gelesen;
`pruefe-befundurteile.pl` rc=0). Die Treffer sind *„angedockt an 1.0.123 und
1.0.124 von Gregor bestätigt“* (frühere Teile, `ZIEL.md:78`,
`WEITERMACHEN.md:121`) und *„K1 … behoben“* ([L-86.5](#l-86.5)). Beide
Urteile beginnen mit **offen** (`Intern/BEFUNDE.md:381`, `:396`);
`CHANGELOG.md:103` *„Testpaket, noch nicht getestet“*; `PAKETE.md:161`
*„nicht veröffentlicht“*; [E-160](../Intern/BEFUNDE.md#e-160) *„am Programm noch nicht gemessen“*
(`CHANGELOG.md:140`, `ZIEL.md:77`).

## Stand je Datei (Fassung, Paket, Testzahlen)

| Datei | Fassung / Paket | Testzahlen | Urteil |
|---|---|---|---|
| `README.md:101,138` | 7.2.0.127 / 1.0.127; „7.2.0.123 bis 7.2.0.127“ | — | stimmt |
| `ZIEL.md:52-53,77-78,177` | 7.2.0.127 / 1.0.127 (`:177`, erzeugter Block); `:77-78` 7.2.0.126 | — | [L-86.3](#l-86.3) |
| `Intern/WEITERMACHEN.md:3,9-12,121,135,371` | 7.2.0.127 / 1.0.127; `:121` „an 1.0.126 zu prüfen“ | 39/39 (`:135`) | [L-86.2](#l-86.2), [L-86.4](#l-86.4), [L-86.5](#l-86.5) |
| `Intern/AUFGABEN.md:3` | 7.2.0.127 / 1.0.127 | — | stimmt |
| `CHANGELOG.md:40,101-142` | 7.2.0.127 / 1.0.127, 7.2.0.126 „nie getestet, ersetzt“ | 314, Gegenproben 313 (`:142`, unter 7.2.0.126) | [L-86.4](#l-86.4), [L-86.5](#l-86.5) |
| `Releases/PAKETE.md:159-175` | 1.0.127, 27.10. 14:23, Bau `+ea3ebcbd` | 314 / 19 / 39 | [L-86.1](#l-86.1) |
| `Releases/PRUEFBERICHT.md:1-25` | 7.2.0.127 / 1.0.127, Bau `ea3ebcbd`, Commit `46f4a5f5` | 314 / 19 / 39, BESTANDEN | stimmt |
| `Intern/TESTPLAN.md:1-41` | 7.2.0.127 / 1.0.127 | — | stimmt; [L-86.6](#l-86.6) |
| `Doku/MITARBEITEN.md:63` | Beispiel `1.0.127` | — | stimmt |
| `Intern/BEFUNDE.md:381,396` | 1.0.127 | 314/314 | [L-86.4](#l-86.4), [L-86.5](#l-86.5) |

Gemessen: kein Dokument nennt für 7.2.0.127 eine andere Testzahl als
314 / 19 / 39 (`PRUEFBERICHT.md:23-25`, `PAKETE.md:171`,
`WEITERMACHEN.md:135`, `BEFUNDE.md:396` *„Unit-Tests 314/314“*).

## Vor dem PR zu berichtigen

| Fund | Stelle | Schwere |
|---|---|---|
| [L-86.1](#l-86.1) | `Releases/PAKETE.md:173` — PRÜFER war fällig, K1-Korrektur ungelesen | falsch |
| [L-86.2](#l-86.2) | `Intern/WEITERMACHEN.md:121` — „an 1.0.126 zu prüfen“ | falsch |
| [L-86.3](#l-86.3) | `ZIEL.md:77-78` — 7.2.0.126, *Persona → Neu*, V6 fehlt | veraltet |
| [L-86.4](#l-86.4) | `Intern/BEFUNDE.md:396` Messdatum, dann `offene-befunde.pl -schreiben` | veraltet |
| [L-86.5](#l-86.5) | im selben Commit empfohlen | unklar |

[L-86.6](#l-86.6) und [L-86.7](#l-86.7) hindern den PR nicht.

## Nicht geprüft

* Der Quelltext der K1-Korrektur (`mainfrm.cpp`) — Sache von PRÜFER-63.
* Die übrigen `.md` des Bestands nur auf `1.0.126`/`7.2.0.126`,
  `vierte[nr] (Teil|Anlauf)` und `behoben|bestätigt` neben [E-137](../Intern/BEFUNDE.md#e-137)/[E-160](../Intern/BEFUNDE.md#e-160)
  durchsucht; Treffer außerhalb der Tabelle oben sind geschichtlich.
* Gregors Testverzeichnis und das ZIP (liegen außerhalb dieses Arbeitsbaums).

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) — ob ein frischer Test aller neun
  Kriterien nötig ist oder die Kurztests T, U, V reichen. Unverändert offen.
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)) — ob
  der Start auf einem Rechner ohne Visual Studio vor 7.2.1 noch einmal
  geprüft werden soll; zuletzt am 06.09.2026 an Paket 1.0.10.
