# <a id="lektor-96"></a>LEKTOR-96 — Bestand nach Gregors Test an 7.2.1.128, vor PR und Release; Form von Tabellen und Ankündigungen, 29.10.2026

**Auftrag.** Alle MD-Dateien (`git ls-files '*.md'` ohne `Arbeitsweise/`
und `Befunde/`, 62 Dateien) gegen den Bestand prüfen; was aus den Funden
von [LEKTOR-95](LEKTOR-95.md#lektor-95) wurde; ob ein Dokument noch sagt,
der Test an 7.2.1.128 stehe aus. Neu (Gregor 29.10.2026: *„hätte dem lektor
auffallen müssen“*): die **Form** prüfen — steht dort, wo ein Text eine
Tabelle, Liste oder Spalte ankündigt, wirklich diese Form, und rendert jede
Tabelle auf GitHub als Tabelle? Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `wt/lektor-20261029f` = `origin/release-7.2.1`
(`159d3955`, beim Start mit `merge-base --is-ancestor` geprüft, nichts
nachzuholen). Seit [LEKTOR-95](LEKTOR-95.md#lektor-95) (`33c5bd34`)
geändert (`git diff --name-only 33c5bd34 159d3955`: 25 Dateien, davon 17 MD): `cf6c3fee`, `88d36d01`, `4f0eda12`, `14a965dc`, `058dbd91`,
`6dc43e4d`, `beb3fc98`, `3da667da`, `26383220`, `159d3955`.
**Alle Zeilenangaben gelten für `159d3955`.** Nichts gebaut,
kein Eudora gestartet, kein Prüfstand.

**In diesem Bericht steht nichts aus Gregors Postfach.**

**Selbstmeldung vorweg.** Zum Nachprüfen von [L-95.4](LEKTOR-95.md#l-95.4)
habe ich `perl tools/ausliefern.pl --pruefen` laufen lassen. Das Werkzeug
liest die `Eudora.exe` in **jedem** `C:\Users\Gregor\Eudora72-*` — Gregors
Testverzeichnisse; `tools/WERKZEUGE.md:58` sagt *„nur mit seiner Zustimmung
aufrufen“*. Gelesen wurden nur Versionsangaben, nichts geschrieben oder
gestartet; trotzdem ohne Zustimmung. Dass die Anleitung, nach der ich
gehandelt habe, die Warnung nicht trägt, ist [L-96.9](#l-96.9).

**Ergebnis vorweg.** **9 Funde.** Von den 15 Funden aus
[LEKTOR-95](LEKTOR-95.md#lektor-95) sind 14 erledigt, 1 teilweise.

* **Der Test gilt in 8 Dateien an 12 Stellen noch als offen**
  ([L-96.1](#l-96.1)): README, ZIEL, PORTIERUNG, PAKETE, AUFGABEN, CHANGELOG
  sagen *„bei Gregor im Test“* bzw. *„ungetestet“*; WEITERMACHEN sagt in
  Zeile 7 *„Gregors Test ist durch“* und in Zeile 14 *„noch nicht von ihm
  bestätigt“*. Der CHANGELOG-Abschnitt ist laut PAKETE der Inhalt des
  Release.
* **GitHub schneidet 7 Tabellenzeilen ab** ([L-96.2](#l-96.2), an GitHubs
  eigenem Markdown-Dienst gemessen): ein `|` in einer Codespanne trennt in GFM
  die Zelle, alles dahinter fällt weg — bei [E-101](../Intern/BEFUNDE.md#e-101)
  rund 4000 Zeichen der Befundzeile, bei der Beschreibung von
  `pruefe-tabellenzeilen.pl` in WERKZEUGE 1450 von 1685 Zeichen. Die Schranke
  dafür ist blind, weil sie das Gegenteil annimmt ([L-96.3](#l-96.3)).
* **[E-173](../Intern/BEFUNDE.md#e-173)** (die Labels der Filteraktion *Make
  Label* sind manchmal ausgegraut, gefunden von Gregor an 7.2.1.128) steht
  nicht unter den bekannten Fehlern der README und nicht im
  CHANGELOG-Abschnitt des Release ([L-96.4](#l-96.4)) — ZIEL.md verlangt: was
  die README nicht nennt, muss gehen.
* **Punkt 4, die neue Brille:** 428 Tabellen gelesen; Kopf- und Trennzeile
  stimmen überall, keiner fehlt die Leerzeile davor, aber 7 Zeilen verlieren
  Text (oben). Von 42 Ankündigungen („Tabelle“ am Link, „Tabelle/Liste
  unten/oben“, „Spalte *X*“) trifft heute jede ihre Form; zwei weitere fand
  ich nur von Hand ([L-96.6](#l-96.6) über einen Zeilenumbruch,
  [L-96.7](#l-96.7) in umgekehrter Richtung). Am Stand vor `beb3fc98` findet
  dieselbe Messung **genau** die beiden Stellen, an denen Gregor die fehlende
  Tabelle sah. **Mechanisch prüfbar: ja**, Vorschlag [unten](#werkzeug).

Als **veröffentlicht** stellt keine Datei 7.2.1.128 dar (gemessen:
`git grep v7.2.1.128` nur in Zukunftsform, `gh release list` neueste
`v1.0.120`).

---

## Funde aus LEKTOR-95

| Fund | Was es war | Heute | Beleg (heutiger Stand) |
|---|---|---|---|
| [L-95.1](LEKTOR-95.md#l-95.1) | Titelzeile in der Anwenderdoku nach altem Schema | **erledigt** | `Doku/ANWENDER.md:101-104` *„`Eudora 7.2.1.128+640e1a0e 2026-10-29 12:36` … Fassungen bis 1.0.127 zeigen sie noch in der Form `Eudora 7.2.0.127 / Paket 1.0.127+…`“*; `:255-257`; `Intern/STARTUMGEBUNG.md:154-160`; `Doku/BAUEN.md:196` *„Fassung, Commit und Herkunftsverzeichnis“* |
| [L-95.2](LEKTOR-95.md#l-95.2) | CHANGELOG-Kopf erklärt `1.0.x` als Regel | **erledigt** | `CHANGELOG.md:3-7` *„**`7.2.0.N`** (Testpaket) bzw. **`7.2.1.N`** (Release) steht gleich in `Eudora71/Version.h` und `VERSION` … Bis 1.0.127 trug `VERSION` eine eigene Zählung“* |
| [L-95.3](LEKTOR-95.md#l-95.3) | ZIP- und Zweigname nach altem Muster | **erledigt** | `Intern/WEITERMACHEN.md:520` `-Zip Releases\Eudora72-<VERSION>-release.zip`; `tools/ZWEIGE.md:55-57` *„heißt `release-7.2.1` (Gregor am 29.10.2026 …)“* |
| [L-95.4](LEKTOR-95.md#l-95.4) | `ausliefern.pl --pruefen` brach an 7.2.1.128 ab | **erledigt** | gemessen: *„Eudora72-7.2.1.128-release 7.2.1.128 7.2.1.128+640e1a0e … Alle Auslieferungen eindeutig.“*, Rückgabe 0 — mit der Selbstmeldung oben und [L-96.9](#l-96.9) |
| [L-95.5](LEKTOR-95.md#l-95.5) | „seit 7.2.0.128“, MITARBEITEN widersprüchlich | **erledigt** | `git grep 7\.2\.0\.128`: nur noch `Intern/WEITERMACHEN.md:131`, `:136` im Satz *„kein Testpaket 7.2.0.128“* (gemessen); `Doku/MITARBEITEN.md:58` *„Eine Nummer an zwei Orten; bis 1.0.127 waren es zwei verschiedene“* |
| [L-95.6](LEKTOR-95.md#l-95.6) | PAKETE bestritt die Dateiversion der `Eudora.exe` | **erledigt** | `Releases/PAKETE.md:62` *„Gemessen am 29.10.2026: `Eudora.exe` 7.2.1.128 meldet `FileVersion` 7.2.1.128“*; `:101-105`. Rest ohne eigenen Fund: dieselbe Zeile `:62` heißt in der ersten Spalte weiter *„**Produktversion** `7.2.0.x`“* |
| [L-95.7](LEKTOR-95.md#l-95.7) | vier Stand-Köpfe veraltet | **erledigt** — zwei davon sind seit dem Test wieder veraltet → [L-96.1](#l-96.1) | `tools/WERKZEUGE.md:3` *„Stand 7.2.1.128 …“*; `Intern/EINSTELLUNGEN.md:3-7` sagt, welcher Teil am 29.10. nachgesehen ist; `Intern/PORTIERUNG.md:44`, `Releases/PAKETE.md:6` nennen 7.2.1.128 |
| [L-95.8](LEKTOR-95.md#l-95.8) | Gregors Bestätigung vom 29.10. nur in einer Commit-Nachricht | **erledigt** | `Intern/WEITERMACHEN.md:131` *„**Bestätigt und genauer gefasst am 29.10.2026** (Gregor: *„1. ja, 2. ja, 3. ja“* …) … **Umgestellt** in `a5febb70` (15 Werkzeuge) und nach [LEKTOR-95](LEKTOR-95.md#lektor-95) `ausliefern.pl`“* |
| [L-95.9](LEKTOR-95.md#l-95.9) | WEITERMACHEN-Einstieg nannte Erledigtes als nächsten Schritt | **erledigt** | `Intern/WEITERMACHEN.md:7` *„**Als Nächstes:** LEKTOR über den Zweig, PR `release-7.2.1`, nach Gregors Merge und Ja `v7.2.1.128` veröffentlichen“*; `:11` *„7.2.0.122 wurde als Paket 1.0.122 geschnürt“* |
| [L-95.10](LEKTOR-95.md#l-95.10) | [E-87](../Intern/BEFUNDE.md#e-87)/[E-88](../Intern/BEFUNDE.md#e-88) bestätigt, zwei Stellen sagten das Gegenteil | **erledigt** | `Intern/WEITERMACHEN.md:46` *„**BESTÄTIGT 29.10.2026 an 1.0.127**“*; `Intern/TESTPLAN.md:92-94` *„— bestanden an 1.0.127, am Release nicht mehr nötig … bestätigt hat es Gregor am 29.10.2026“* |
| [L-95.11](LEKTOR-95.md#l-95.11) | TESTPLAN „nur ein Schritt“ gegen ZIEL „alle neun Kriterien“ | **erledigt durch Gregors Entscheidung** | `ZIEL.md:96-101` *„**Für 7.2.1.128 von Gregor am 29.10.2026 entschieden:** kein eigener Durchgang der neun Kriterien“*; `Intern/TESTPLAN.md:13-16`; `übrigen Release-Test`: 0 Treffer (gemessen); `:120` *„Kurztest 7.2.0.127 — bestanden“* |
| [L-95.12](LEKTOR-95.md#l-95.12) | EINSTELLUNGEN-Abweichungen: Einleitung falsch, Zeilen verrutscht | **teilweise** — Einleitung und alle `EudoraRes.rc`-Zeilen stimmen; eine `mainfrm.cpp`-Angabe im selben Abschnitt steht ~490 Zeilen daneben → [L-96.5](#l-96.5) | `Intern/EINSTELLUNGEN.md:182-186` *„— **außer** `TabooHeaders` und `MessageStyleSheet` …“*; gemessen: `EudoraRes.rc:7685`, `7686`, `8152`, `8462`–`8464`, `8656`, `8689`, `10018`, `10461` tragen jeweils den genannten Schlüssel |
| [L-95.13](LEKTOR-95.md#l-95.13) | CHANGELOG nannte drei von neun Release-Texten, Prüfungen bis [LEKTOR-93](LEKTOR-93.md#lektor-93) | **erledigt** | `CHANGELOG.md:129` *„… dazu sechs ältere (`v1.0.2`, …, `v1.0.84`, Entscheidung 19 …)“*; `:130` *„[LEKTOR-90](LEKTOR-90.md#lektor-90) bis [LEKTOR-95](LEKTOR-95.md#lektor-95) eingearbeitet“* |
| [L-95.14](LEKTOR-95.md#l-95.14) | zwei gekürzte Betreffzeilen im Protokollauszug | **erledigt** | `CHANGELOG.md:4344-4345` enden auf `"<Betreff>"` (gemessen) |
| [L-95.15](LEKTOR-95.md#l-95.15) | vier Standzeilen sagten „noch nicht geschnürt“ | **erledigt** — die Nachfolgeaussage „im Test“ ist seit dem Test falsch → [L-96.1](#l-96.1) | `README.md:103`, `Intern/WEITERMACHEN.md:14`, `Intern/AUFGABEN.md:3`, `Releases/PAKETE.md:6` sagen *„geschnürt“* |

**Reste aus älteren Berichten** (gemessen):
[L-92.2](LEKTOR-92.md#l-92.2) — **offen und größer als gemeldet**:
`Intern/FILTER.md:228` nennt für *Make Label* weiter `filtersd.cpp:1151-1155`,
der Fall steht in `:1222`; dieselbe Spalte der Aktionstabelle liegt durchweg
60–70 Zeilen daneben (*None* `:1122` → `case ID_FLT_NONE` in `:1193`;
*Make Personality* `:1283` → `:1345`; *Make Subject* `:1314` → `:1376`;
*Make Status* `:1397` → `:1459`). [L-91.4](LEKTOR-91.md#l-91.4) —
**erledigt**, `Intern/TESTPLAN.md:84-89` *„**Kam sie schon in Schritt 1
nicht**, ist der Schritt **nicht prüfbar** … nicht als bestanden“* — und
genau so ist es an Gregors VM gekommen (`:55-57`). [L-91.7](LEKTOR-91.md#l-91.7)
— an den zwei Stellen, die ich nachgelesen habe, **erledigt**
(`Intern/FILTER.md:511` *„Fehlen die beiden Dateien, schlägt `LoadLibrary`
fehl“*, `:737` mit Bedingung); die übrigen zwei nicht nachgelesen.

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | Bewertung |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Quellstand 7.2.1.128 · Paketnummer 7.2.1.128 · Kriterien in ZIEL.md 9 · gepruefte Dateien 48 · Kennungen im Verzeichnis 162 … Kein Widerspruch gefunden.“*; *„Zur Kenntnis“* 16 Dateien ohne 7.2.1.128 | vergleicht Nummern, nicht Zustände: *„bei Gregor im Test“* neben dem Testergebnis ([L-96.1](#l-96.1)) sieht es nicht. Die Kenntnisliste ist gegen [LEKTOR-95](LEKTOR-95.md#lektor-95) von 20 auf 16 geschrumpft |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 46 … aktuell gemessen 5 … veraltet gemessen 26 … NIE gemessen 15 … 46 offene Befunde, in beiden Listen gleich.“* | +1 gegen [LEKTOR-95](LEKTOR-95.md#lektor-95) (45/14): [E-173](../Intern/BEFUNDE.md#e-173), neu und *„nie gemessen“* — stimmt |
| `perl tools/pruefe-regressionstest.pl` | *„Befunde insgesamt 219 … mit Testfall 74 … manuell im Testplan 2 … behoben und OHNE Testfall 67 … kritisch 73 … OHNE jede Pruefung 24 … Kein neues "behoben" ohne Regressionstest.“* | +1 Befund ([E-173](../Intern/BEFUNDE.md#e-173), nicht kritisch); die 24 kritischen ohne Prüfung sind dieselben wie in [LEKTOR-95](LEKTOR-95.md#lektor-95), nach Gregors Entscheidung vom 23.10. kein Release-Hindernis |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* | zählt die Kriterien, nicht die Standzeile `ZIEL.md:186`, die [L-96.1](#l-96.1) trifft |
| `perl tools/pruefe-tabellenzeilen.pl` (lief im Commit-Haken) | *„375 Dateien, keine gebrochene Tabellenzeile.“* | blind für [L-96.2](#l-96.2), siehe [L-96.3](#l-96.3) |

---

## Der Teststand von 7.2.1.128

### <a id="l-96.1"></a>L-96.1 — veraltet seit `6dc43e4d`: 12 Stellen in 8 Dateien sagen, Gregors Test an 7.2.1.128 stehe aus; WEITERMACHEN widerspricht sich selbst

**Was passiert:** Gregor hat 7.2.1.128 an der VM und auf dem Hauptrechner
getestet, [E-166](../Intern/BEFUNDE.md#e-166) (Konto-Eigenschaften
verlieren Einstellungen, die Junk-Frage kam wieder) ist bestanden.
Eingetragen wurde das im TESTPLAN, in der Befundzeile und im Einstieg von
WEITERMACHEN — die übrigen Standzeilen sagen weiter *„im Test“*. Wer die
README oder den CHANGELOG liest, hält die Fassung für ungeprüft; der
CHANGELOG-Abschnitt ist der Inhalt des Release (`Releases/PAKETE.md:195`
*„Inhalt: CHANGELOG.md, Abschnitt 7.2.1.128“*).

* **Gemessen**, Gegenstück: `Intern/TESTPLAN.md:23` *„Ergebnis 29.10.2026 an
  7.2.1.128: [E-166](../Intern/BEFUNDE.md#e-166) auf Gregors Hauptrechner — bestanden laut Protokoll“*;
  `Intern/WEITERMACHEN.md:7` *„**Gregors Test ist durch:** [E-166](../Intern/BEFUNDE.md#e-166) auf seinem
  Hauptrechner bestanden“*; `Intern/BEFUNDE.md:389` *„von Gregor am 29.10.2026
  an Paket 7.2.1.128 auf seinem Hauptrechner bestätigt“*. `git show --stat
  3da667da`: nur BEFUNDE und WEITERMACHEN, je eine Zeile.
* **Belegt**, widersprüchlich in einer Datei: `Intern/WEITERMACHEN.md:14`
  *„**7.2.1.128** … geschnürt am 29.10.2026, liegt bei Gregor, noch nicht von
  ihm bestätigt; Gregor testet sie als erstes Release, den E-166-Schritt
  zuerst“* — sieben Zeilen unter *„Gregors Test ist durch“*.
* **Belegt**, veraltet:
  `README.md:103` *„am 29.10.2026 geschnürt, bei Gregor im Test, noch nicht
  veröffentlicht“*;
  `ZIEL.md:186` *„geschnürt, bei Gregor im Test“*;
  `ZIEL.md:42-47` *„**Was an der Release-Fassung selbst noch geprüft wird:**
  die Behebung von [E-166](../Intern/BEFUNDE.md#e-166) … Erst danach wird veröffentlicht.“*;
  `Intern/PORTIERUNG.md:44` *„geschnürt, bei Gregor im Test“*;
  `Releases/PAKETE.md:6` *„bei Gregor im Test, noch nicht veröffentlicht“*;
  `Releases/PAKETE.md:183` *„Gregor testet sie, den E-166-Schritt zuerst“* —
  der Abschnitt 1.0.127 darunter (`:199`) zeigt, wie es nach dem Test heißt:
  *„Von Gregor am 27.10.2026 im Kurztest geprüft: V1 bis V6 bestanden“*;
  `Intern/AUFGABEN.md:3` *„Gregor testet es vor der Veröffentlichung“*;
  `CHANGELOG.md:109` *„Gregor testet diese Fassung vor der Veröffentlichung …;
  bis dahin ist sie **ungetestet**.“*; `CHANGELOG.md:113` *„Gregor prüft es an
  der Release-Fassung“*.
* **Belegt**, TESTPLAN selbst: `:3` *„**Jetzt zu testen: das Release
  7.2.1.128**“*; `:53` Überschrift *„(Gregors VM, Zwischenstand)“* mit `:55-57`
  *„Gregor prüft [E-166](../Intern/BEFUNDE.md#e-166) **später auf seinem Hauptrechner**; bis dahin keine
  Marke“* — der Hauptrechner-Abschnitt steht schon darüber.

**Was zu tun wäre:** die zwölf Stellen auf *„von Gregor am 29.10.2026
getestet ([E-166](../Intern/BEFUNDE.md#e-166) auf dem Hauptrechner bestanden, VM ohne Fehlerzeile), noch
nicht veröffentlicht“*, mit Verweis auf
[TESTPLAN](../Intern/TESTPLAN.md#ergebnis-e-166-hauptrechner); ZIEL:42-47 in
die Vergangenheit; TESTPLAN:3 auf *„Getestet“*, die VM-Überschrift ohne
*„Zwischenstand“* und den Satz *„bis dahin keine Marke“* mit Nachtrag. Ob
der Test schon **Gregors Ja zur Veröffentlichung** ist, steht nirgends — das
ist seine Frage ([unten](#gregor)).

### <a id="l-96.4"></a>L-96.4 — unvollständig: E-173 fehlt unter den bekannten Fehlern der README, im Release-Abschnitt des CHANGELOG und an der FAQ-Antwort, die den Weg beschreibt

**Was passiert:** Gregor fand an 7.2.1.128, dass die Labels der Filteraktion
*Make Label* beim Anlegen eines Filters einmal ausgegraut und nicht wählbar
waren ([E-173](../Intern/BEFUNDE.md#e-173); nach Löschen und Neuanlegen des
Filters ging es). Er hat entschieden: *nach dem Release*. Die vier anderen
neuen Befunde ([E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172)) stehen bis dahin unter „Bekannte Fehler“
(Entscheidung 16) — [E-173](../Intern/BEFUNDE.md#e-173) steht dort nicht. Die FAQ beschreibt genau diesen
Weg, ohne Hinweis.

* **Belegt**, Maßstab: `ZIEL.md:22-23` *„**Weitergabe ohne Einschränkung** —
  außer den Punkten, die die README ausdrücklich nennt. Was dort nicht steht,
  muss gehen.“*
* **Gemessen**: `grep E-173 README.md`: 0 Treffer; README nennt [E-166](../Intern/BEFUNDE.md#e-166), [E-169](../Intern/BEFUNDE.md#e-169)
  bis [E-172](../Intern/BEFUNDE.md#e-172) (`:163-167`). `CHANGELOG.md:115-121` *„**Neu bekannt, behandelt nach
  dem Release**“* listet [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172) und [E-168](../Intern/BEFUNDE.md#e-168), nicht [E-173](../Intern/BEFUNDE.md#e-173) ([E-173](../Intern/BEFUNDE.md#e-173) steht
  nur in der erzeugten Tabelle `:29`).
* **Belegt**, `Doku/FAQ.md:198` *„*Action:* **Make Label** → `Wichtig`“* in
  Frage 9; `Intern/BEFUNDE.md:383` *„Nachdem Gregor den Filter gelöscht und
  neu angelegt hatte, waren die Farben wieder da“*.
* **Belegt**, Entscheidung: `Intern/TESTPLAN.md:64-65` *„Labels im
  Filterfenster einmal ausgegraut → neuer Befund [E-173](../Intern/BEFUNDE.md#e-173), nach dem Release.“*;
  `Intern/WEITERMACHEN.md:7` zählt [E-173](../Intern/BEFUNDE.md#e-173) nicht zu den README-Einträgen.

**Was zu tun wäre:** eine README-Zeile unter „Bekannte Fehler“ (was
passiert, *nichts geht verloren*, Umgehung: Filter löschen und neu anlegen),
[E-173](../Intern/BEFUNDE.md#e-173) in die Liste `CHANGELOG.md:115-121`, ein Satz an FAQ 9.

### <a id="l-96.8"></a>L-96.8 — veraltet, vor dem Release wirksam: ZIEL.md sagt, das Veröffentlichungsskript kenne nur `v1.0.<n>`

**Was passiert:** der nächste Schritt ist `v7.2.1.128`. ZIEL.md kündigt an,
das Skript müsse vorher umgestellt werden — es ist umgestellt und kennt die
alte Form gar nicht mehr. Wer ZIEL liest, sucht eine Arbeit, die erledigt
ist.

* **Belegt**, `ZIEL.md:101` *„`release-veroeffentlichen.ps1` kennt bisher nur
  `v1.0.<n>` und wird vorher umgestellt ([L-53.16](LEKTOR-53.md#l-53.16)).“*
* **Belegt am Quelltext**, `tools/release-veroeffentlichen.ps1:65-66` *„ein
  Release ueberall gleich: 7.2.1.N in VERSION, Version.h, ZIP und Marke
  v7.2.1.N. Die alte Paketnummer 1.0.N gibt es nicht mehr.“*, `:176`
  `$marke = 'v' + $Fassung`; `CHANGELOG.md:140` zählt das Skript unter den
  umgestellten Werkzeugen.

**Was zu tun wäre:** `ZIEL.md:101` auf *„umgestellt am 29.10.2026
(`a5febb70`)“*.

### <a id="l-96.9"></a>L-96.9 — Anleitung ohne Warnung: PAKETE empfiehlt `ausliefern.pl --pruefen`, das Gregors Testverzeichnisse liest

**Was passiert:** `PAKETE.md` nennt den Befehl als den Weg, „beides
gegeneinander“ zu messen. Dass er dafür jede `Eudora.exe` in Gregors
Testverzeichnissen öffnet und deshalb nur mit seiner Zustimmung laufen darf,
steht nur in WERKZEUGE. Ich bin der Anleitung gefolgt und habe es ohne
Zustimmung getan (Selbstmeldung oben); [LEKTOR-95](LEKTOR-95.md#l-95.4)
ebenso.

* **Belegt**, `Releases/PAKETE.md:120` `perl tools/ausliefern.pl --pruefen
  # beides gegeneinander` — ohne Hinweis.
* **Belegt**, `tools/WERKZEUGE.md:58` *„**Liest dafür die `Eudora.exe` in jedem
  `%USERPROFILE%\Eudora72-*`** — das sind Gregors Testverzeichnisse; nur mit
  seiner Zustimmung aufrufen (CLAUDE.md, Abschnitt 4)“*.
* **Gemessen**: die Ausgabe nennt `Eudora72-1.0.127-release` und
  `Eudora72-7.2.1.128-release` mit ihren Kennungen — gelesen wurde dort.

**Was zu tun wäre:** an `PAKETE.md:120` dieselbe Warnung wie in WERKZEUGE,
oder dort `perl tools/pruefe-fassungsnummer.pl` empfehlen, das nur das Repo
liest. Ob das Werkzeug selbst eine Sperre braucht, ist Sache des
Hauptagenten.

---

## Punkt 4: die Form — Tabellen, Ankündigungen, Spalten

### Vorgehen

Gemessen mit einem Wegwerf-Skript im Scratchpad (nicht im Repo) über die 62
Dateien: (A) jede Tabelle nach GFM gelesen — Spaltenzahl von Kopf- und
Trennzeile, Datenzeilen mit mehr Zellen als der Kopf, ein `|` innerhalb einer
Codespanne ohne Rückstrich, Leerzeile vor der Tabelle; (B) jede Stelle, an
der ein Link im Linktext oder in den 60 Zeichen davor „Tabelle“ sagt: Anker
auflösen (eigene `<a id>` und GitHubs Überschriften-Kennung), im
Zielabschnitt nach einer Trennzeile suchen; (C) *„Tabelle/Liste/Checkliste
unten|oben|darunter|darüber“* ohne Link: in der genannten Richtung bis 300
Zeilen nach Tabelle bzw. Liste suchen; (D) *„Spalte *X*“*: hat die
gemeinte Tabelle den Kopf *X*? Was (A) als Verlust meldete, habe ich durch
GitHubs eigenen Markdown-Dienst (`gh api -X POST markdown`, `mode=gfm`)
gerendert — das ist die Messung, das Skript nur die Auswahl.

### Trefferzahlen

| Prüfung | geprüft | Treffer | davon echt |
|---|---|---|---|
| A1 Kopf- und Trennzeile ungleich | 428 Tabellen | 0 | 0 |
| A2 `\|` in Codespanne ohne Rückstrich | alle Zeilen der 428 Tabellen | 7 | **7** — alle 7 an GitHub gerendert abgeschnitten ([L-96.2](#l-96.2)) |
| A3 mehr Zellen als der Kopf, ohne Codespanne | dieselben | 0 | 0 |
| A4 keine Leerzeile vor der Tabelle | 428 | 0 | 0 |
| B Link mit „Tabelle“ → Zielabschnitt ohne Tabelle | 22 Links | 2 | 0 — beide zeigen auf einen Anker **in** einer Tabellenzeile (`BEFUNDE.md:5200` → `#s-7`, `LEKTORAT.md:114` → `#s-2`) |
| C „Tabelle/Liste … unten/oben“ ohne Link | 13 | 0 | 0 |
| D „Spalte *X*“ | 7 | 0 | 0 (FAQ 184/210 meinen die Spalte *Label* im Programm) |
| von Hand, beim Lesen | — | 2 | **2** — [L-96.6](#l-96.6) (über einen Zeilenumbruch), [L-96.7](#l-96.7) (umgekehrte Richtung: „Liste“, am Ziel Tabellen) |

**Gegenprobe am alten Stand** (gemessen): dieselbe Messung über die 62
Dateien aus `beb3fc98^` findet in B **4** Treffer — die beiden Fehlalarme
von heute und **`CHANGELOG.md:126`** *„Die Tabelle der abweichenden
Einstellungen ist zurück — in EINSTELLUNGEN.md“* sowie
**`Intern/WEITERMACHEN.md:7`** *„die Abweichungstabelle in
EINSTELLUNGEN.md“*: genau der Fall, den Gregor sah.
`pruefe-tabellenzeilen.pl` meldete damals wie heute nichts. Dieselbe Klasse
gab es schon einmal: `ZIEL.md:188` *„unter einer Überschrift, die eine
Tabelle ankündigt. Gregor dazu: „ist das eine tabelle?““* (22.10.2026) — das
jetzige ist das zweite Auftreten
([Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md)).

### <a id="l-96.2"></a>L-96.2 — GitHub schneidet 7 Tabellenzeilen ab: ein `|` in einer Codespanne trennt die Zelle

**Was passiert:** in GFM werden Tabellenzellen an jedem `|` getrennt,
**bevor** Codespannen erkannt werden; schützen kann nur ein Rückstrich
(`\|`). Hat eine Zeile dadurch mehr Zellen als der Kopf, lässt GitHub den
Überschuss **ohne Meldung** weg. Im Repo sieht der Text vollständig aus, auf
GitHub endet er mitten im Satz, meist mit einem einzelnen Backtick.

| Stelle | was die Zeile ist | auf GitHub sichtbar (Zeichen) | letzte sichtbare Worte |
|---|---|---|---|
| `Intern/BEFUNDE.md:348` | Befundzeile [E-101](../Intern/BEFUNDE.md#e-101) (Post wird beim Weiterleiten verfälscht) | 16019 von ca. 20110 | *„… und bCtErsetzt kann auf diesem Weg nie wahr werden — `“* |
| `Intern/BEFUNDE.md:371` | Befundzeile [E-125](../Intern/BEFUNDE.md#e-125) (Ziehen nach `Out` legte eine neue Nachricht an) | 5359 von ca. 8570 | *„Die Bedingung am Ende von CTocDoc::Xfer lautet `IsImapToc()“* |
| `Intern/BEFUNDE.md:403` | Befundzeile [E-138](../Intern/BEFUNDE.md#e-138) | 1852 von ca. 2689 | *„nachträglich `Get-ChildItem -Recurse“* — der Befehl, den der Leser abtippen soll, ist halbiert |
| `tools/WERKZEUGE.md:64` | `pruefe-fensterbau.pl` | 488 von ca. 638 | *„… oder mit &&, `“* |
| `tools/WERKZEUGE.md:85` | `pruefe-fenster-ziehen.pl` | 204 von ca. 736 | *„dwMode=0x0022 (`LM_LENGTHY“* |
| `tools/WERKZEUGE.md:125` | **`pruefe-tabellenzeilen.pl` selbst** | **233 von ca. 1685** | *„… weil ihr das führende `“* |
| `tools/ZWEIGE.md:148` | Zweig `rollen-faellig-ohne-binaerdateien` | 200 von ca. 757 | *„… war als `^(?:Eudora71/“* |

* **Gemessen**: je Kopf-, Trenn- und Datenzeile an `POST /markdown`
  (`mode=gfm`) geschickt; in allen 7 Fällen kommt das Zeilenende nicht an.
  Gegenprobe an zwei Nachbarzeilen ohne Pipe in Code (`BEFUNDE.md:347`,
  `WERKZEUGE.md:63`): Zeilenende kommt an.
* **Belegt**, Regel: GFM-Spezifikation, Abschnitt *Tables (extension)* —
  ein Pipe in einer Zelle, *„including inside other inline spans“*, muss mit
  Rückstrich geschützt werden; überzählige Zellen werden ignoriert.
* Die ungeschützten Pipes, gemessen: `if (!bHatContentType || bCtErsetzt)`
  ([E-101](../Intern/BEFUNDE.md#e-101)), `IsImapToc() || (TargetToc && …)` ([E-125](../Intern/BEFUNDE.md#e-125)),
  `Get-ChildItem -Recurse <Verzeichnis> | Unblock-File` ([E-138](../Intern/BEFUNDE.md#e-138)), `||`
  (WERKZEUGE:64), `LM_LENGTHY|LM_HORZ` und `LM_COMMIT|LM_HORZ` (:85), ein
  einzelnes `|` in Backticks (:125), `^(?:Eudora71/|tools/)` (ZWEIGE:148).
  Andere Zeilen derselben Dateien schreiben es richtig, etwa
  `WS_CHILD \| WS_VISIBLE` (BEFUNDE:195).

**Was zu tun wäre:** in den 7 Codespannen jedes `|` als `\|`. GitHub zeigt
in der Codespanne dann ein `|` (wie an `BEFUNDE.md:195`).

### <a id="l-96.3"></a>L-96.3 — Werkzeug: `pruefe-tabellenzeilen.pl` nimmt das Gegenteil von GFM an und ist dadurch für L-96.2 blind

**Was passiert:** die Schranke, die genau solche Tabellenschäden abfangen
soll, zählt Zellen so, als schütze eine Codespanne das Pipe. Ihr eigener
Selbsttest hält diese Annahme fest. Sie meldet deshalb *„keine gebrochene
Tabellenzeile“*, während GitHub sieben Zeilen abschneidet — darunter ihre
eigene Beschreibung.

* **Belegt am Quelltext**, `tools/pruefe-tabellenzeilen.pl:221-233`:
  Kommentar *„ein Pipe in einer Codespanne oder mit Rueckstrich davor trennt
  keine Zellen“*, `sub zellen` entfernt Codespannen vor dem Zählen;
  Selbsttest `:240` *„'Pipe in Codespanne zaehlt nicht', … 0“* — der Fall
  erwartet **keinen** Fund.
* **Gemessen**: Lauf im Commit-Haken dieses Berichts *„375 Dateien, keine
  gebrochene Tabellenzeile.“*; `--selbsttest` *„27 Faelle, 27 richtig“*.

### Was `pruefe-tabellenzeilen.pl` abdeckt und was nicht

**Deckt ab** (gelesen, `pruefe_text` `:96-219`, und am Selbsttest mit 27
Fällen): abgerissene Zeile ohne führendes `|` (die *lazy continuation*,
Anlass 22.10.2026); eine Zeile nur aus `|` mitten in der Tabelle; Leerzeile
mitten in der Tabelle, hinter der es ohne neue Trennzeile weitergeht; Kopf-
und Trennzeile mit verschiedener Spaltenzahl (seit 29.10.2026, Strg+J-Tabelle
in FILTER); Datenzeile mit mehr Zellen als der Kopf — **außer** wenn das
überzählige Pipe in einer Codespanne steht ([L-96.3](#l-96.3)). Liest alle
`.md` in Wurzel, `Befunde/`, `tools/`, `Arbeitsweise/`, `Releases/`,
`Intern/`, `Doku/` — nicht `Pruefung/`, `Testdaten/`, `Releases/*/`
(`Testdaten/README.md:33` hat es deshalb nie gesehen; die Tabelle ist heil,
gemessen).

**Deckt nicht ab:** (1) ein Pipe in einer Codespanne (falsche Annahme,
oben); (2) ob eine Tabelle dort steht, wo ein Text sie ankündigt — es prüft
Tabellen, die es gibt, nicht solche, die fehlen; (3) das Umgekehrte: eine
„Liste“, die eine Tabelle ist; (4) Datenzeilen mit **weniger** Zellen (GFM
füllt leer auf — richtig, dass es das nicht meldet); (5) eine Tabelle
direkt hinter Fließtext ohne Leerzeile — heute 0 Fälle.

### <a id="werkzeug"></a>Lässt sich das mechanisch prüfen? — ja; Vorschlag, nicht gebaut

1. **In `pruefe-tabellenzeilen.pl`: `zellen()` nach GFM** — nur `\|`
   schützt; Codespannen nicht vorher entfernen. Den Selbsttestfall *„Pipe in
   Codespanne zaehlt nicht“* umdrehen (soll 1, mit der echten Zeile aus
   WERKZEUGE:125 als Fall), einen Fall *„Pipe mit Rückstrich in
   Codespanne“* (soll 0) dazu. Wirkung heute: 7 Meldungen, alle echt.
2. **Neues Werkzeug, etwa `pruefe-angekuendigte-form.pl`:** jeder Link,
   dessen Text oder die 60 Zeichen davor — **auch über den Zeilenumbruch
   hinweg**, sonst fehlt [L-96.6](#l-96.6) — „Tabelle“ sagt, muss in seinem
   Zielabschnitt eine Trennzeile finden; dasselbe für „Tabelle/Liste
   unten/oben“ in Richtung bis zur nächsten gleichrangigen Überschrift.
   **Ausnahme**, sonst zwei Fehlalarme heute: ein Anker, der selbst in einer
   Tabellenzeile steht, gilt als getroffen. Gegenprobe ist schon gefahren:
   am Stand `beb3fc98^` 2 echte Treffer (Gregors Fall), heute 0.
   Zweite Lehre aus der Messung: das 60-Zeichen-Fenster ist zu grob — an
   diesem Bericht selbst meldet es zwei Fehlalarme, weil „Tabelle“ im
   Satz oder in der Zelle **davor** stand. Das Fenster gehört auf den Satz
   bzw. die Tabellenzelle des Links begrenzt.
3. **Nicht mechanisch** bleibt, ob eine Ankündigung inhaltlich passt
   (*„mit Wert hier, Wert im Original, Herkunft“* — gibt es die Spalte
   *Herkunft*?) und ob „Liste“ für eine Tabelle zu ungenau ist. Das bleibt
   Lesearbeit.
4. Die Messung an GitHubs Markdown-Dienst ist die genaueste, braucht aber
   Netz — für eine Schranke im Haken nicht geeignet, als Gegenprobe beim Bau
   des Werkzeugs schon.

Laut `Arbeitsweise/stand-29-10-2026.md` (vom Haken in diesen Arbeitsbaum
gespiegelt, nicht von mir committet) ist das Werkzeug für nach dem Release
vorgemerkt.

### <a id="l-96.6"></a>L-96.6 — angekündigte Form fehlt: der Prüfbericht verweist auf eine „Ergebnistabelle im Kopf von TESTPLAN je Kriterium“, die es dort nicht gibt; die Buchführung darunter endet am 23.10.

**Was passiert:** der Prüfbericht zu 7.2.1.128 sagt, wo Gregors eigene
Ergebnisse stehen: in einer Tabelle je Kriterium im Kopf des TESTPLAN. Im
Kopf stehen zwei Abschnitte mit Aufzählungspunkten; eine Tabelle je
Kriterium gab es zuletzt an 7.2.0.123, 280 Zeilen tiefer — für 7.2.1.128 hat
Gregor ausdrücklich keinen Durchgang je Kriterium gewollt. Die „ältere
Buchführung darunter“ endet am 23.10.2026. Der Satz kommt aus dem Werkzeug
und steht in jedem künftigen Prüfbericht wieder.

* **Belegt**, `Releases/PRUEFBERICHT.md:469-471` *„Gregors eigene Ergebnisse am
  Paket: die Ergebnistabelle im Kopf von TESTPLAN.md (je Kriterium und
  Pruefschritt, mit Paketnummer), aeltere in der Buchfuehrung darunter.“*;
  Quelle `tools/pruefbericht.pl:392`.
* **Gemessen**, `Intern/TESTPLAN.md:23-66`: zwei Ergebnisabschnitte, keine
  Trennzeile einer Tabelle; die Tabelle je Kriterium ist
  `#ergebnis-7-2-0-123` (`:302`).
* **Belegt**, `Intern/TESTPLAN.md:556` *„**Stand 23.10.2026: an 1.0.122 [E-125](../Intern/BEFUNDE.md#e-125)
  bestätigt**“* — Bestätigungen vom 26., 27. und 29.10. (7.2.0.123 bis 1.0.127,
  [E-87](../Intern/BEFUNDE.md#e-87)/[E-88](../Intern/BEFUNDE.md#e-88), [E-166](../Intern/BEFUNDE.md#e-166)) stehen dort nicht.
* Von meiner Messung **nicht** gefunden: *„Ergebnistabelle im Kopf von“* und
  der Link stehen auf verschiedenen Zeilen.

**Was zu tun wäre:** in `pruefbericht.pl:392` *„die Ergebnisabschnitte im
Kopf von TESTPLAN.md“*, ohne „je Kriterium“; die Buchführung nachziehen
oder ihren Kopf auf *„bis 23.10.2026; danach in den Ergebnisabschnitten“*.

### <a id="l-96.7"></a>L-96.7 — umgekehrte Richtung: drei Verweise nennen die beiden Abweichungstabellen „Liste“, der CHANGELOG eine Spalte, die es nicht gibt

**Was passiert:** seit `beb3fc98` stehen die Abweichungen als zwei Tabellen
da. Drei Verweise kündigen weiter eine Liste an; der CHANGELOG zählt
*„Herkunft“* unter den Spalten. Irreführend ist das kaum — eine Tabelle ist
auch eine Aufstellung —, aber es ist dieselbe Unschärfe, die Gregor in der
anderen Richtung beanstandet hat.

* **Belegt**, `README.md:49` *„— Liste mit Wert hier, Wert im Original und
  Begründung“*; `Intern/EINSTELLUNGEN.md:146-147` *„in der Liste [*Was hier
  anders eingestellt ist als im Original*](#abweichungen) weiter unten“*;
  `Doku/FAQ.md:362` *„Die vollständige Liste — Schlüssel, Wert hier, Wert im
  Original, woher die Abweichung kommt und **warum**“*.
* **Belegt**, `CHANGELOG.md:126` *„mit Wert hier, Wert im Original 7.1,
  Herkunft und Begründung“* gegen die Köpfe `Intern/EINSTELLUNGEN.md:200`,
  `:211` *„| Schlüssel | Abschnitt | hier | Original | warum |“* — die Herkunft
  ist die Teilung in zwei Tabellen (`:198`, `:209`), keine Spalte. Derselbe
  Absatz sagt es im letzten Satz richtig.

**Was zu tun wäre:** „Liste“ → „Tabellen“ an den drei Stellen; im CHANGELOG
*„in zwei Tabellen (DEudora.ini im Paket / Programm selbst) mit Wert hier,
Wert im Original und Begründung“*.

---

## Zeilenangaben

### <a id="l-96.5"></a>L-96.5 — verrutscht um ~490 Zeilen: die Strg+J-Belegung zeigt in EINSTELLUNGEN und FILTER auf eine Stelle, an der heute die gespeicherte Suche steht

**Was passiert:** die neue Abweichungstabelle (*„Nachgesehen am
29.10.2026“*) belegt die Strg+J-Abweichung mit `mainfrm.cpp:7937-7949`. Dort
steht heute das Öffnen der Suche; `InitJunkMenus` mit dem E-75-Zweig liegt
490 Zeilen tiefer. FILTER.md, auf das die Zeile verweist, hat dieselben
alten Zahlen, dazu `EudoraRes.rc`-Zeilen aus einem älteren Stand.

* **Gemessen**, `Eudora71/Eudora/mainfrm.cpp:7937-7941` *„ASSERT_KINDOF(
  SearchManager::SavedSearchCommand, pCommand ); … OnEditFindFindMsg();“*;
  `:8398` `void CMainFrame::InitJunkMenus()`, `:8427` *„// BEFUND [E-75](../Intern/BEFUNDE.md#e-75) (Gregor,
  10.09.2026): hier stand CTRL_J_JUNK.“*, `:8446` `sCtrlJ = CTRL_J_FILTER;`,
  `:8449` `SetIniShort(IDS_INI_WHO_GETS_CTRL_J, sCtrlJ);`.
* **Belegt**, `Intern/EINSTELLUNGEN.md:213` *„(`mainfrm.cpp:7937-7949`, [E-75](../Intern/BEFUNDE.md#e-75),
  FILTER.md)“*; `Intern/FILTER.md:159` *„`mainfrm.cpp:7911-7952`“*, `:163`
  *„`mainfrm.cpp:7937-7949`“*, `:167` *„`mainfrm.cpp:7976-7994`“*.
* **Gemessen**, FILTER daneben: `:157` *„`EudoraRes.rc:8734`“* —
  `CtrlJMapping` steht in `:8756`; `:160` *„`EudoraRes.rc:4717-4726`“* —
  `IDD_CTRL_J_FOR_JUNK DIALOGEX` beginnt in `:4735`.
* Ursache (Vermutung, nicht nachgezählt): die Einschübe zu [E-137](../Intern/BEFUNDE.md#e-137) vom 25. bis
  27.10. in `mainfrm.cpp` (`git log`: `ed0d53a2` bis `9c88d1c2`).

**Was zu tun wäre:** die fünf Angaben neu messen (`grep -n`); weil
`mainfrm.cpp` weiter wächst, an EINSTELLUNGEN:213 besser den
Funktionsnamen `CMainFrame::InitJunkMenus` statt der Zeilen.

---

## Geprüft ohne Fund

* **Nichts stellt 7.2.1.128 als veröffentlicht dar** (gemessen):
  `v7.2.1.128` kommt nur in `Intern/TESTPLAN.md:18`, `Intern/WEITERMACHEN.md:7`,
  `Releases/PAKETE.md:183` vor, jedes Mal in der Zukunftsform;
  `gh release list` und `git ls-remote --tags`: neueste Marke `v1.0.120`.
* **Die beiden neuen Abweichungstabellen** (`Intern/EINSTELLUNGEN.md:198-219`):
  Kopf und Trennzeile je 5 Spalten, A1–A4 ohne Treffer; die Werte
  `KeepHTMLInResponses`, `ForwardOriginalHTML` (`EudoraRes.rc:7685-7686`),
  `MessageStyleSheet` (`:8152`), `FloatCx` (`OTShim_Werkzeugleiste.cpp:4449`),
  `FilterMayDeleteFromServer` (`filtersd.cpp:1133-1135`) stimmen — bis auf
  [L-96.5](#l-96.5).
* **Gregors Entscheidungen seit [LEKTOR-95](LEKTOR-95.md#lektor-95)** stehen, wo sie hingehören: der
  Zweigname (`tools/ZWEIGE.md:55-57`), kein Durchgang der neun Kriterien
  (`ZIEL.md:96-101`, `Intern/TESTPLAN.md:13-16`).
* **PRUEFBERICHT-Kopf** (`Releases/PRUEFBERICHT.md:5-8`): *„`7.2.1.128` …
  `efc9cfd4` … BESTANDEN“* — passt zu `Releases/PAKETE.md:190`.
* **„Spalte *Vorgabe*“** (`Intern/EINSTELLUNGEN.md:153`) und die übrigen
  Spalten- und Richtungsangaben aus C und D: Form am Ziel vorhanden.

## Nicht geprüft

* Die 62 Dateien sind nicht Zeile für Zeile gelesen: ganz gelesen nur die
  Köpfe, die 7.2.1.128-Abschnitte und was die Messungen trafen; BEFUNDE,
  LEKTORAT und die Teile A–D des TESTPLAN nur über die Messungen.
* Die Formmessung kennt nur die Wörter *Tabelle, Liste, Checkliste,
  Aufzählung, Spalte* und Links auf einer Zeile ([L-96.6](#l-96.6) zeigt die
  Grenze).
* Die GitHub-Messung nur an den 7 gemeldeten und 2 Vergleichszeilen.
* Nichts am laufenden Programm, kein Bau, kein Prüfstand.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Ist dein Test an 7.2.1.128 dein Ja zur Veröffentlichung von
  `v7.2.1.128`?** [E-166](../Intern/BEFUNDE.md#e-166) (die Junk-Frage kam mehrmals, weil die
  Konto-Eigenschaften Einstellungen verloren) ist auf deinem Hauptrechner
  bestanden, an der VM gab es keine Fehlerzeile, die ausgegrauten Labels
  ([E-173](../Intern/BEFUNDE.md#e-173)) kommen nach dem Release. Der TESTPLAN
  sagt *„Erst mit deinem Ja wird es als `v7.2.1.128` veröffentlicht“*
  (`Intern/TESTPLAN.md:17-18`); ein Ja steht im Repo nirgends. Oder willst
  du vorher noch etwas prüfen?
* Unverändert offen: Kriterium 0 (das Paket läuft ohne Nachinstallieren)
  auf einem Rechner ohne Visual Studio ([L-77.3](LEKTOR-77.md#l-77.3)).
