# <a id="lektor-117"></a>LEKTOR-117 — Kurzlauf vor dem PR zu 7.2.1.130, Zweig paket_7_2_1_130 (01.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-116](LEKTOR-116.md#lektor-116).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261101g`, Stand `d2a85c89`.

## Kurz

Die drei Funde aus [LEKTOR-116](LEKTOR-116.md#lektor-116) sind eingearbeitet, einer davon nur teilweise
(gemessen). Die Buchführung zu 7.2.1.130 stimmt in sich: Pfad, ZIP-Größe,
SHA-256, Bau-Kennung, 355 Unit-Tests, 19 Schranken, 46 Prüfstandsfälle und 18
Eudora-Starts stehen in PAKETE, PRUEFBERICHT, den Prüfstandsdateien und
TESTLAEUFE gleich; Größe und SHA-256 des ZIP habe ich an der Datei
nachgemessen. Alle vier Werkzeuge grün, 44 offene Befunde in beiden Listen.
Sechs Funde, keiner am Programm; **alle sechs vom LEKTOR berichtigt im selben
Commit** (Auftrag des Hauptagenten, Lehre vom 27.10.). Die zwei wichtigsten: `ZIEL.md` nennt sich
selbst die Quelle für den Stand, sagt aber „Quellstand 7.2.1.128“ ([L-117.2](#l-117.2)); der
Kopf des TESTPLAN sagt, zuletzt getestet sei am 29.10. das Release 7.2.1.128,
obwohl Gregor am 31.10. an 7.2.1.129 getestet hat ([L-117.1](#l-117.1)).

## Funde aus LEKTOR-116

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-116.1](LEKTOR-116.md#l-116.1) Urteile zu [E-178](../Intern/BEFUNDE.md#e-178) (Emoji beim Formatieren), [E-170](../Intern/BEFUNDE.md#e-170) (Label beim Verschieben), [E-143](../Intern/BEFUNDE.md#e-143) (Out im Filter) sagten „mit dem nächsten Testpaket“ | **teilweise** | „Was noch fehlt“ ist berichtigt: `Intern/BEFUNDE.md:401` *„die Messung am Programm mit dem Testpaket 7.2.1.130“*, ebenso `:407`, `:395`; [E-179](../Intern/BEFUNDE.md#e-179) (Zeichenangaben in HTML-zu-Text) `:400` *„(die Behebung ist im Testpaket 7.2.1.130)“*. Die erzeugten Listen folgen: `CHANGELOG.md:31`, `:32`, `:37`, `:43`, `Intern/WEITERMACHEN.md:80`, `:81`, `:86`, `:92`. Der zweite Teil des Vorschlags, „in 7.2.1.130“ im Urteilskopf, ist nicht übernommen: `:401` beginnt weiter *„offen — Behebung im Quellstand (01.11.2026, Zweig `e178_bearbeiten_emoji`)“*, ebenso `:395`, `:400`, `:407`. Die Aussage stimmt weiter; kein neuer Fund |
| [L-116.2](LEKTOR-116.md#l-116.2) [E-136](../Intern/BEFUNDE.md#e-136) (Emoji beim Speichern zu `??`): README und BEFUNDE nannten den `.htm`-Weg in 7.2.1.130 nicht | erledigt | `README.md:182` *„in 7.2.1.129 geändert (Strg+S), in 7.2.1.130 auch *Speichern unter* als `.htm` (beides am Programm noch nicht nachgemessen)“*; `Intern/BEFUNDE.md:426` *„Der zweite Weg (*Speichern unter* als `.htm`) ist in 7.2.1.130.“*; erzeugt `CHANGELOG.md:46`, `Intern/WEITERMACHEN.md:95` *„Gregors Weg am Paket 7.2.1.129 oder 7.2.1.130“* |
| [L-116.3](LEKTOR-116.md#l-116.3) FAQ zu [E-170](../Intern/BEFUNDE.md#e-170) „kommt mit dem nächsten Paket“ | erledigt | `Doku/FAQ.md:208-209` *„im Quellstand berichtigt für Server, die die neuen Nummern der verschobenen Mails melden — im Testpaket 7.2.1.130“*. Der vorgeschlagene Zusatz „am Programm nicht gemessen“ fehlt; die README sagt ihn (`README.md:165`). Kein eigener Fund |

Aus der „Zur Kenntnis“ von [LEKTOR-116](LEKTOR-116.md#lektor-116) unverändert: `README.md:155` ([E-72](../Intern/BEFUNDE.md#e-72), verneinte Filterbedingung
trifft jede Nachricht) rät weiter *„solche Filter bis zum nächsten Paket
abschalten“* (gemessen). Für Leser des Releases 7.2.1.128 stimmt das sinngemäß
(Vermutung zur Absicht, wie damals).

## Buchführung zu 7.2.1.130

Gelesen: `git log --stat 50b08e86..HEAD` (`b5693332` Schnüren, `d2a85c89`
Prüfstandslauf) und alle geänderten Zeilen der beiden Commits außer den
erzeugten Testtabellen. Jede Zahl gegen die zweite Stelle gehalten:

| Angabe | Stellen | Ergebnis |
|---|---|---|
| Ablageort `C:\Users\Gregor\Eudora72-7.2.1.130-release` | `Releases/PAKETE.md:184`, `:188`; `CHANGELOG.md:108`; `Intern/TESTPLAN.md:1`; `Intern/WEITERMACHEN.md:3` | gleich (gemessen, `grep`) |
| ZIP 9.131.484 Byte, SHA-256 `570a53ae…d61460` | `Releases/PAKETE.md:189` | an der Datei nachgemessen: `ls -l` → `9131484 Nov 1 15:18`, `sha256sum` → `570a53ae92e0e9f8e96d95d4aa6a02522f97001b4b3e3cad607d1c0d01d61460` (gemessen, nur gelesen) |
| Geschnürt 15:18 | `Releases/PAKETE.md:184` | Zeitstempel des ZIP 15:18 (gemessen) |
| Bau `Eudora 7.2.1.130+955d50d4* 2026-11-01 15:15` | `Releases/PAKETE.md:190`; `Releases/PRUEFBERICHT.md:19`; alle 46 Zeilen `Releases/PRUEFBERICHT.md:457-502`; 15 der 18 Zeilen in `tools/TESTLAEUFE.md` vom 01.11. 15:35–15:44 | gleich (gemessen). Die drei Zeilen ohne Kennung (`EBILD`, `E119K`, `E97`) sind Fälle ohne Titelzeile im Protokoll, wie in früheren Läufen |
| 355 Unit-Tests, 19 Schranken, 46 Fälle | `Releases/PAKETE.md:192`; `Releases/PRUEFBERICHT.md:23-25`; `Intern/pruefstand-ergebnis.txt` *„faelle=46 bestanden=46 fehlgeschlagen=0“*; `Intern/pruefstand-buch.tsv` 46 Zeilen mit dem Bau oben | gleich (gemessen) |
| 18 Eudora-Starts, 15:35–15:44 | `Releases/PAKETE.md:192`; `Releases/PRUEFBERICHT.md:16` *„9 min 17 s … Ende 2026-11-01 15:44:24“*; `Intern/pruefstand-dauer.txt` *„sekunden 557 … starts 18“*; `tools/TESTLAEUFE.md` 18 neue Zeilen | gleich (gemessen; 557 s = 9 min 17 s) |
| Bericht im Paket *NICHT VOLLSTÄNDIG*, maßgeblich der im Repo | `Releases/PAKETE.md:192`, Commit `b5693332` *„-OhnePruefbericht“* | stimmig (belegt) |
| Kein Release, nur lokal | `Releases/PAKETE.md:184` *„nicht veröffentlicht“*, `:189` *„nicht auf GitHub“*; `CHANGELOG.md:108`; `Intern/WEITERMACHEN.md:3` | gleich (gemessen) |
| [CHRONIST-2026-11-01b](../Arbeitsweise/CHRONIST-2026-11-01b.md): *„Commits: 20 auf `paket_7_2_1_130` zwischen 12:27 und 15:20“* | `git log --since='2026-11-01 12:20' --until='2026-11-01 15:21' b5693332` | 20, von `26dfa116` 12:27:36 bis `b5693332` 15:20:51 (gemessen; mitgezählt sind die Commits des gemergten Zweigs) |

Gesucht nach überholten Paketzuständen über alle `git ls-files '*.md'` ohne
`Arbeitsweise/` und `Befunde/`: „noch nicht geschnürt“, „nur übersetzt“,
„vergeben ist 7.2.1.130“, „Prüfstandslauf offen“, „NICHT VOLLSTÄNDIG“,
„OhnePruefbericht“ (gemessen, `grep -rn`). Treffer außer `Intern/AUFGABEN.md:8`
([L-117.6](#l-117.6)) betreffen ältere Fassungen oder sind die richtige Erklärung in
`Releases/PAKETE.md:192`.

## Funde

### <a id="l-117.1"></a>L-117.1 — TESTPLAN-Kopf: „zuletzt getestet am 29.10.2026 das Release 7.2.1.128“

**Gewicht: Kleinkram**, aber in der ersten Zeile der Datei, die Gregor zum Testen liest. (gemessen)

**Berichtigt im selben Commit:** `Intern/TESTPLAN.md:1` *„zuletzt getestet am 31.10.2026 das Testpaket 7.2.1.129: [E-139](../Intern/BEFUNDE.md#e-139) bestanden, [E-165](../Intern/BEFUNDE.md#e-165) bestätigt; davor am 29.10.2026 das Release 7.2.1.128, [E-166](../Intern/BEFUNDE.md#e-166) bestanden“*.

`Intern/TESTPLAN.md:1`: *„Stand 01.11.2026 (zuletzt getestet am 29.10.2026 das
Release 7.2.1.128, [E-166](../Intern/BEFUNDE.md#e-166) bestanden)“*. In derselben Datei stehen zwei spätere
Tests Gregors an 7.2.1.129: `:149` *„Ergebnis 31.10.2026, Gregor an 7.2.1.129:
bestanden“* ([E-139](../Intern/BEFUNDE.md#e-139), Rechtschreibhinweis abschaltbar) und `:185` *„Ergebnis 31.10.2026,
Gregor an 7.2.1.129, mit zwei und drei Treffern: besser“* ([E-165](../Intern/BEFUNDE.md#e-165), Vervollständigungsbox).
Auch `Doku/FAQ.md:330` nennt Gregors Bestätigung *„am 31.10.2026 an 7.2.1.128
und an 7.2.1.129“*.

**Vorschlag:** „zuletzt getestet am 31.10.2026 das Testpaket 7.2.1.129 ([E-139](../Intern/BEFUNDE.md#e-139),
[E-165](../Intern/BEFUNDE.md#e-165)), davor am 29.10.2026 das Release 7.2.1.128“.

### <a id="l-117.2"></a>L-117.2 — ZIEL.md nennt als Stand „Quellstand 7.2.1.128“

**Gewicht: mittel** — die Datei erklärt sich selbst zur Quelle des Stands. (gemessen)

**Berichtigt im selben Commit:** `ZIEL.md:191` *„Stand 01.11.2026. Quellstand 7.2.1.130 (`VERSION` gleich; Testpaket, geschnürt am 01.11.2026, nicht veröffentlicht; davor 7.2.1.129 …). Veröffentlicht zuletzt 7.2.1.128 …“*; in `ZIEL.md:89` [E-143](../Intern/BEFUNDE.md#e-143) *„(Filterteil in 7.2.1.130 im Quelltext berichtigt, nicht gemessen)“* und [E-136](../Intern/BEFUNDE.md#e-136) *„(Strg+S in 7.2.1.129, Speichern unter als `.htm` in 7.2.1.130 geändert, nicht gemessen)“*.

`ZIEL.md:186-189`: *„Diese Tabelle ist die Quelle. `README.md`, `AUFGABEN.md`,
`WEITERMACHEN.md`, `CHANGELOG.md`, `PORTIERUNG.md` und `Releases/PAKETE.md`
verweisen hierher … Wer den Stand ändert, ändert ihn hier.“* Darunter
`ZIEL.md:191`: *„**Stand 29.10.2026.** Quellstand **7.2.1.128** (`VERSION`
gleich …)“*. Gemessen: `Eudora71/Version.h:14` *„EUDORA_BUILD_VERSION
"7.2.1.130"“*, `VERSION` *„7.2.1.130“*. Die Zeile stammt unverändert vom
29.10.2026 (`git blame`: `321b3599`) und hat damit auch 7.2.1.129 übersprungen.
`doku-pruefen.pl` meldet das nicht, weil `ZIEL.md:89` die Zahl 7.2.1.130
enthält.

Daneben, Kleinkram: in derselben Zeile `ZIEL.md:89` stehen [E-170](../Intern/BEFUNDE.md#e-170), [E-178](../Intern/BEFUNDE.md#e-178), [E-179](../Intern/BEFUNDE.md#e-179)
mit *„(in 7.2.1.130 im Quelltext berichtigt, nicht gemessen)“*, [E-143](../Intern/BEFUNDE.md#e-143) und
[E-136](../Intern/BEFUNDE.md#e-136) aber ohne Zusatz, obwohl der Filterteil von [E-143](../Intern/BEFUNDE.md#e-143) und der `.htm`-Weg von
[E-136](../Intern/BEFUNDE.md#e-136) ebenfalls in 7.2.1.130 sind (`Intern/BEFUNDE.md:395`, `:426`).

**Vorschlag:** `ZIEL.md:191` auf „Stand 01.11.2026. Quellstand 7.2.1.130
(Testpaket, geschnürt, nicht veröffentlicht); veröffentlicht zuletzt
7.2.1.128 …“; in `:89` [E-143](../Intern/BEFUNDE.md#e-143) „(Filterteil in 7.2.1.130)“ und [E-136](../Intern/BEFUNDE.md#e-136)
„(Strg+S in 7.2.1.129, `.htm` in 7.2.1.130)“.

### <a id="l-117.3"></a>L-117.3 — Der Ersetzer mit Selbsttest: zweites Auftreten steht nicht in der Aufgabenliste

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit, anders als vorgeschlagen:** `tools/ersetze-text.pl` gibt es seit `d64f4737` (Selbsttest 11/11, `tools/WERKZEUGE.md:20`). Die Zeile `Intern/WEITERMACHEN.md:58` ist darum **gestrichen**, nicht als erledigt markiert — die Tabelle sagt in `:28-29` *„Erledigtes wird gestrichen, nicht abgehakt — die Geschichte steht im Commit“*. Beide Endlosfälle (29.10.2026 21:55:39 und 01.11.2026 15:09:55) stehen in der Commit-Nachricht und hier. **Nicht berichtigt**, weil außerhalb meiner Dateien: das Datum „am 30.10.“ für Fall 38 in [CHRONIST-2026-11-01b](../Arbeitsweise/CHRONIST-2026-11-01b.md) Zeile 34; derselbe Datumsfehler steht auch in `tools/WERKZEUGE.md:20` und im Kopf von `tools/ersetze-text.pl` (*„30.10. und 01.11.2026“*, gemessen) — richtig ist 29.10.

[CHRONIST-2026-11-01b](../Arbeitsweise/CHRONIST-2026-11-01b.md) Zeile 34 und 38: der Ersetzer hing am 01.11. um 15:09
zum zweiten Mal endlos (der neue Text enthielt den alten), *„Werkzeug
`tools/ersetze-text.pl` mit Selbsttest ist fällig“*. Die einzige Stelle, an der
Aufgaben stehen (`Intern/WEITERMACHEN.md:15`), führt das Werkzeug in `:58`
nur mit dem ersten Fall: *„ein Ersetzungshelfer lief am 29.10.2026 endlos“*,
Verweis nur auf CHRONIST 30.10. Dass es jetzt zweimal geschah und das
Werkzeug nach [fehlerklassen-abstellen](../Arbeitsweise/fehlerklassen-abstellen.md) fällig ist, steht dort nicht. `tools/ersetze-text.pl` gibt
es nicht (`ls`: *„No such file or directory“*).

Im CHRONIST-Bericht selbst, Zeile 34: *„dieselbe Falle wie Fall 38 am 30.10.“*
— Fall 38 geschah am 29.10. um 21:55:39
(`Arbeitsweise/text-nicht-durch-schichten-schicken.md:546`); der 30.10. ist
das Datum des Nachtrags.

**Vorschlag:** `Intern/WEITERMACHEN.md:58` um „zweites Mal am 01.11.2026,
15:09“ und den Verweis auf CHRONIST-2026-11-01b ergänzen; im CHRONIST-Bericht
„am 29.10.“.

### <a id="l-117.4"></a>L-117.4 — PAKETE-Kopf: „Nummern bis 7.2.1.128 verzeichnet“

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** `Releases/PAKETE.md:6` *„Nummern bis 7.2.1.130 verzeichnet“*.

`Releases/PAKETE.md:6`: *„Stand 01.11.2026 (Nummern bis 7.2.1.128
verzeichnet, geschnürt ist bis 7.2.1.129 …, geschnürt ist auch 7.2.1.130
…“*. Eigene Abschnitte gibt es für `7.2.1.130` (`:182`) und `7.2.1.129`
(`:197`). Der Kopf warnt im selben Absatz, wer die nächste Nummer aus der Liste
ableite, greife daneben. Deshalb muss gerade hier die höchste verzeichnete
Nummer stimmen.

**Vorschlag:** „Nummern bis 7.2.1.130 verzeichnet“.

### <a id="l-117.5"></a>L-117.5 — README zählt weiter 112 Prüfberichte und 109 Lehren

**Gewicht: Kleinkram, Altlast.** (gemessen)

**Berichtigt im selben Commit:** `README.md:98-100` *„189 LEKTOR- und PRÜFER-Berichte … 124 Lehren aus Fehlern; beides am 01.11.2026 mit `git ls-files` gezählt, ohne Laufberichte, Stand-Notizen und Entscheidungen“*. Gezählt (gemessen): `git ls-files 'Befunde/*.md'` → 211, davon `LEKTOR-<n>` 117 und `PRUEFER-<n>` 72; `git ls-files 'Arbeitsweise/*.md'` ohne `CHRONIST-*`, `stand-*`, `entscheidung-*`, `MEMORY.md`, `README.md` → 124. Die Zahl veraltet mit jedem Lauf wieder.

`README.md:98`: *„Dazu `Befunde/` (112 Prüfberichte), `Arbeitsweise/` (109
Lehren aus Fehlern)“*. Gemessen: `git ls-files 'Befunde/*.md' | wc -l` → 209,
`git ls-files 'Arbeitsweise/*.md' | wc -l` → 175 (darin auch Laufberichte und
Stand-Notizen). Offen seit [L-56.10](LEKTOR-56.md#l-56.10) (22.10.2026), in [LEKTOR-57](LEKTOR-57.md) noch als offen
geführt, danach nicht mehr.

**Vorschlag:** die Zahlen streichen („Prüfberichte“, „Lehren aus Fehlern“)
oder aus einem Werkzeug erzeugen. Eine Handzahl veraltet mit jedem Lauf.

### <a id="l-117.6"></a>L-117.6 — AUFGABEN: „Nummer 7.2.1.130 vergeben“

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** `Intern/AUFGABEN.md:8` *„Am 01.11.2026 Testpaket 7.2.1.130 geschnürt (wie 7.2.1.129 nicht veröffentlicht)“*.

`Intern/AUFGABEN.md:8`: *„Am 01.11.2026 Nummer 7.2.1.130 vergeben: [[E-178](../Intern/BEFUNDE.md#e-178)] …
im Quelltext berichtigt, am Programm noch nicht gemessen.“* Das Paket ist
geschnürt (`Releases/PAKETE.md:184`). Die Datei ist nur noch zum Nachschlagen
(`:3`), der Satz aber ist ihr Nachtrag zum Stand.

**Vorschlag:** „Am 01.11.2026 7.2.1.130 geschnürt (nicht veröffentlicht): …“.

## Zur Kenntnis, außerhalb des Prüfumfangs (`Arbeitsweise/`)

`Arbeitsweise/stand-01-11-2026.md:45`, im selben Commit `d2a85c89` wie der
Prüfstandslauf geschrieben: *„Prüfstandslauf offen (braucht Gregors Ja
heute)“*. Der Lauf ist gefahren (15:35–15:44, `Releases/PAKETE.md:192`). Die
Beschreibung im Kopf (`:3`) und in `Arbeitsweise/README.md` sagt weiter
*„Stand 01.11.2026 14:10 - PR #195 … offen zum Merge … Frage an Gregor offen:
Testpaket 7.2.1.130 nach dem Merge?“*. Beides ist überholt (gemessen). Wer
nach einem Neustart diese Notiz zuerst liest, würde den Lauf noch einmal
anstoßen wollen.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen):

```
  Quellstand                   7.2.1.130
  Paketnummer                  7.2.1.130
  gepruefte Dateien            50
  Kein Widerspruch gefunden.
```

„Zur Kenntnis“: 18 Dateien ohne 7.2.1.130, darunter `Doku/ANWENDER.md` und
`Intern/PORTIERUNG.md` (höchste genannte Fassung 7.2.1.128). `ZIEL.md` steht
nicht darin, weil `:89` die Nummer nennt — [L-117.2](#l-117.2) bleibt dem Werkzeug verborgen.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  44
      davon aktuell gemessen       2  (ab Nummer 125)
      davon veraltet gemessen     28
      davon NIE gemessen          14
    in Intern/WEITERMACHEN.md     44

  44 offene Befunde, in beiden Listen gleich.
```

`perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne
Regressionstest.“* Rückstand unverändert: 8 kritische ohne jede Prüfung
(`E-122 E-123 E-124 E-126 E-129 E-172 E-133 E-39`).

`perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*
Das Werkzeug zählt die Kriterien, nicht die Standzeile `ZIEL.md:191`.

Die Werkzeuge sehen [L-117.1](#l-117.1) bis [L-117.6](#l-117.6) nicht. `doku-pruefen.pl` fragt je Datei, ob die
Nummer irgendwo vorkommt. Ob eine Standzeile die Nummer *als Stand* nennt,
prüft es nicht.

## Was nur Gregor entscheiden kann

Nichts Neues.
