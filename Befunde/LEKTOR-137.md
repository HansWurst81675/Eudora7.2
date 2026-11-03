# <a id="lektor-137"></a>LEKTOR-137 — Zweig e128_endung_aus_inhalt vor dem PR, nach 4eb93716 (03.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-136](LEKTOR-136.md#lektor-136).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261103b`, abgezweigt von `origin/e128_endung_aus_inhalt`, Stand `4eb93716`. Eigen gegen `origin/main` (gemessen, `git log --stat origin/main..HEAD`): `23b31352` ([E-128](../Intern/BEFUNDE.md#e-128) Zwischenstand), `c2402a4c` ([E-128](../Intern/BEFUNDE.md#e-128) am Prüfstand, [E-213](../Intern/BEFUNDE.md#e-213)), `ed9e178c`/`0245c085` (PRÜFER-90), `78705ea5` (Merge #211-#213), `4eb93716` (PRÜFER-90 eingearbeitet, [E-214](../Intern/BEFUNDE.md#e-214)). Nichts gebaut, nichts gestartet, keine Prüfstände angefasst.

## Kurz

[E-128](../Intern/BEFUNDE.md#e-128) (gespeicherte Nachricht heißt `.txt`, enthält aber HTML) ist an Code, Test und Eintrag stimmig: der Filter der Postfachliste bietet *HTML Files* nicht mehr an (`EudoraRes.rc:8553`), der IMAP-Schutz steht in `tocview.cpp:3096`. **Nicht überall nachgezogen** ist Gregors Entscheidung zu K3: eine Textmail **mit Umlauten** bekommt aus der Postfachliste `.eml`. Der TESTPLAN verlangt in Schritt 3 für „eine reine Textmail“ `.txt` — Gregor wird mit einer deutschen Mail testen und einen Fehlschlag sehen, der keiner ist. Ebenso schreiben der Kurz-Satz von [E-128](../Intern/BEFUNDE.md#e-128), README und FUNKTIONEN „reiner Text → `.txt`“; nur das CHANGELOG nennt die Umlaute. WEITERMACHEN nennt PRÜFER-90 „wird eingearbeitet“ und die gemergten Zweige `e133_…`/`e203_…` als laufend. Sechs Funde, keiner am Programmcode.

## Mechanisch (Ausgaben, kein Urteil)

- `perl tools/doku-pruefen.pl`: nur die bekannten Hinweise *„nennt weder den Quellstand 7.2.1.131 noch die Paketnummer“* (u. a. `Doku/ANWENDER.md`, `Doku/HINTERGRUND.md`, alte Release-Notizen) — Archiv bzw. bewusst älter, kein neuer Fund.
- `perl tools/offene-befunde.pl`: *„60 offene Befunde, in beiden Listen gleich.“*
- `perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne Regressionstest.“* — trifft für [E-214](../Intern/BEFUNDE.md#e-214) (`Test_E214_Vorgabeendung`); [E-213](../Intern/BEFUNDE.md#e-213) ist ein Werkzeugfehler, Gegenprobe im Eintrag.
- `perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen“*.

## Funde aus LEKTOR-136 — heutiger Stand

| Fund | Stand | Stelle (gemessen, dieser Zweig) |
|---|---|---|
| [L-136.1](LEKTOR-136.md#l-136.1) [E-189](../Intern/BEFUNDE.md#e-189) „vermutlich Gregors Server“ | **erledigt** | `grep -c 'vermutlich Gregors Server' Intern/BEFUNDE.md` → 0 |
| [L-136.2](LEKTOR-136.md#l-136.2)/[L-136.10](LEKTOR-136.md#l-136.10) Klasse in der E-170-Spur | **erledigt** ([L-136.10](LEKTOR-136.md#l-136.10) hatte [L-136.2](LEKTOR-136.md#l-136.2) berichtigt) | — |
| [L-136.3](LEKTOR-136.md#l-136.3) README/FAQ „Label bleibt“ | **erledigt** | `README.md:167` *„mitgenommen wird es meistens … an einem solchen Server ging es trotzdem einmal verloren (29.10.2026, Ursache offen)“*; `Doku/FAQ.md:217-218` *„bleibt das Label meistens … am 29.10.2026 einmal verloren“* |
| [L-136.4](LEKTOR-136.md#l-136.4) TESTPLAN [E-170](../Intern/BEFUNDE.md#e-170) | **erledigt** | `Intern/TESTPLAN.md:350` *„Erledigt am 03.11.2026: das Label bleibt …“* |
| [L-136.5](LEKTOR-136.md#l-136.5)/[L-136.12](LEKTOR-136.md#l-136.12) WEITERMACHEN laufend | **erledigt für `messungen_…`, dieselbe Klasse neu** | [L-137.3](#l-137.3) |
| [L-136.6](LEKTOR-136.md#l-136.6)–[L-136.8](LEKTOR-136.md#l-136.8) Sperre, Startzeilen, Konflikte | **erledigt durch die Merges #212/#213** | doppelte Startzeilen hier 64 = `origin/main` 64; `grep -c E204-GEGENTEST tools/TESTLAEUFE.md` → 0 |
| [L-136.9](LEKTOR-136.md#l-136.9) Berichtszahl README | **offen** | [L-137.5](#l-137.5) |
| [L-136.11](LEKTOR-136.md#l-136.11)/[L-136.13](LEKTOR-136.md#l-136.13) Release-Notizen | **erledigt** | `Releases/7.2.1.131/RELEASE-NOTIZEN.md:45` *„— auch an einem Server, der die Nummern meldet, ging es am …“* |
| ältere ([L-129.1](LEKTOR-129.md#l-129.1): Schranke „zuletzt veröffentlicht“ fehlt, u. a.) | **nicht nachgemessen** | — |

## Funde

### <a id="l-137.1"></a>L-137.1 — Textmail mit Umlauten: Gregors „.eml bleibt“ fehlt im TESTPLAN, im Kurz-Satz von E-128, in README und FUNKTIONEN

**Gewicht: mittel.** Schritt 3 des Testplans erwartet für eine Textmail `.txt`; jede gewöhnliche deutsche Textmail bekommt aber `.eml` (so von Gregor am 03.11.2026 entschieden). Gregor meldet dann einen Fehlschlag, der gewollt ist. (gemessen an den Texten)

- `Intern/BEFUNDE.md:391` (K3): *„eine Textmail **mit Umlauten** bekommt aus der Postfachliste `.eml`, weil [E-101](../Intern/BEFUNDE.md#e-101) einen Zeichensatz-Kopf davorsetzt — Gregor am 03.11.2026: *„.eml (Recommended)“*, bleibt so“*. `CHANGELOG.md:126` gibt das richtig wieder: *„`.eml`, wenn die Datei einen Kopf trägt (Kopfzeilen, HTML, Umlaute), sonst `.txt`“*.
- Dagegen `Intern/TESTPLAN.md:487-488` *„Eine **reine Textmail** aus der Postfachliste speichern: gewählt ist **Text Files (*.txt)**.“* — kein Wort zu Umlauten im Abschnitt (`sed -n 474,495p | grep -ci umlaut` → 0).
- `Intern/BEFUNDE.md:391`, Kurz: *„Aus der Postfachliste wird eine HTML-Mail als `.eml` gespeichert …, reiner Text als `.txt`“*.
- `README.md:163` *„aus der Postfachliste `.eml` für eine HTML-Mail“*; `Doku/FUNKTIONEN.md:85` *„aus der Postfachliste `.eml` (HTML, oder mit Kopfzeilen) bzw. `.txt`“*.
- Der Prüfstandsfall `E-128t` nutzt `Testdaten/e128-text-ascii.eml` — gemessen ist nur der ASCII-Fall; der Umlaut-Fall ist am Quelltext belegt (PRÜFER-90 K3, von mir nicht nachgemessen).

**Vorschlag:** TESTPLAN Schritt 3: *„eine Textmail **ohne** Umlaute → *Text Files*; mit Umlauten → *Mail Files (*.eml)*, so gewollt“*; Kurz-Satz, README und FUNKTIONEN wie `CHANGELOG.md:126` (*„Kopfzeilen, HTML oder Umlaute → `.eml`“*).

### <a id="l-137.2"></a>L-137.2 — E-128: „Gregor muss nichts tun“ neben „Was noch fehlt: Gregors Blick“

**Gewicht: Kleinkram.** (gemessen am Text)

- `Intern/BEFUNDE.md:391` Kurz endet *„Gregor muss nichts tun.“*; derselbe Eintrag: *„**Was noch fehlt:** Gregors Blick am Paket 7.2.2.132 ([TESTPLAN](TESTPLAN.md#e-128-naechstes))“*; `CHANGELOG.md:65` übernimmt das.

**Vorschlag:** *„Gregor muss jetzt nichts tun; mit 7.2.2.132 drei Schritte im TESTPLAN.“*

### <a id="l-137.3"></a>L-137.3 — WEITERMACHEN: PRÜFER-90 „wird eingearbeitet“, gemergte Zweige als laufend

**Gewicht: Kleinkram, Klasse von [L-128.2](LEKTOR-128.md#l-128.2) (eine Schranke gegen „läuft“ nach dem Merge fehlt) zum dreizehnten Mal.** (gemessen)

- `Intern/WEITERMACHEN.md:3` *„PRÜFER-90 wird eingearbeitet“* — erledigt in `4eb93716` (*„[PRUEFER-90](PRUEFER-90.md#pruefer-90) in e128 eingearbeitet: K1, K2, K5; K6 = [E-214](../Intern/BEFUNDE.md#e-214) …“*); `Befunde/PRUEFER-90.md:186-199` *„## Eingearbeitet … Unit-Tests danach 402/402“*. [E-214](../Intern/BEFUNDE.md#e-214) (sechs Dialoge bekamen ihre Vorgabeendung als freigegebenes Objekt) fehlt im Kopf.
- Dieselbe Zeile: *„Gemergt am 03.11.2026: … #212 (`e133_mailverzeichnis_fehlt`), #213 (`e203_e204_persona_kennwort`)“* und weiter hinten *„Laufend: `e128_endung_aus_inhalt` …, `e170_label_ohne_uidplus`, `e133_mailverzeichnis_fehlt`, `e203_e204_persona_kennwort`.“*

**Vorschlag:** Kopf „PRÜFER-90 eingearbeitet, [E-214](../Intern/BEFUNDE.md#e-214) behoben“; aus *Laufend* die beiden gemergten Zweige streichen.

### <a id="l-137.4"></a>L-137.4 — ZWEIGE nennt für `e128_…` nur E-128

**Gewicht: Kleinkram** (Klasse [L-135.9](LEKTOR-135.md#l-135.9)). (gemessen)

- `tools/ZWEIGE.md:217` *„[E-128](…): die Vorgabeendung im Dialog *Speichern unter* aus dem Inhalt (Postfachliste `.eml`/`.txt`, Fenster `.htm`/`.txt`) …“* — [E-213](../Intern/BEFUNDE.md#e-213) (`testlauf.ps1` brach bei einem Fehler des Messskripts ab, Eudora blieb offen), [E-214](../Intern/BEFUNDE.md#e-214) und PRÜFER-90 fehlen.

**Vorschlag:** Zeile um [E-213](../Intern/BEFUNDE.md#e-213), [E-214](../Intern/BEFUNDE.md#e-214) und PRÜFER-90 ergänzen.

### <a id="l-137.5"></a>L-137.5 — Berichtszahl in der README

**Gewicht: Kleinkram** (Fortschreibung [L-136.9](LEKTOR-136.md#l-136.9)). (gemessen)

- `README.md:98` *„(219 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“*; `ls Befunde/LEKTOR-*.md Befunde/PRUEFER-*.md | wc -l` → 224 vor diesem Bericht, mit ihm 225.

**Vorschlag:** wie [L-136.9](LEKTOR-136.md#l-136.9) — erzeugen lassen oder nach dem letzten Merge setzen.

### <a id="l-137.6"></a>L-137.6 — Der IMAP-Weg von E-128 ist weder am Prüfstand noch im TESTPLAN

**Gewicht: Kleinkram.** (gemessen an den Texten)

- `Intern/BEFUNDE.md:391` *„der IMAP-Schutz (K2) ist am Prüfstand nicht gemessen (die Fälle holen über POP)“*; Code `Eudora71/Eudora/tocview.cpp:3096` *„pSumE128->IsNotIMAPDownloadedAtAll()“*.
- `Intern/TESTPLAN.md:476` *„**Ort: lokal**“* — kein Schritt für eine noch nicht geholte IMAP-Nachricht (erwartet: kein *„online gehen?“* vor dem Dialog).

**Vorschlag:** ein Prüfstandsfall über den IMAP-Prüfserver oder ein vierter TESTPLAN-Schritt *„Ort: IMAP, offline“*; sonst geht K2 unbestätigt ins Paket.

## Bestand außerhalb des Schwerpunkts

- `tools/WERKZEUGE.md:3`, `:128`, `:154`: `messen-e128` und die E-213-Änderung an `testlauf.ps1` sind genannt (gelesen, trifft).
- `CHANGELOG.md:122-128` *„## Im Quellstand, noch in keinem Paket … nur übersetzt, für 7.2.2.132“* mit [E-128](../Intern/BEFUNDE.md#e-128), [E-214](../Intern/BEFUNDE.md#e-214), [E-213](../Intern/BEFUNDE.md#e-213) — trifft.
- `Befunde/PRUEFER-90.md:186-199` *Eingearbeitet*: K1 gegen `EudoraRes.rc:8553` *„Text Files (*.txt)|*.txt|Mail Files (*.eml)|*.eml|All Files (*.*)|*.*||“* — trifft; K2 gegen `tocview.cpp:3096` — trifft; K6 sechs Dateien gegen `git log --stat 4eb93716` (`SearchDoc.cpp`, `compmsgd.cpp`, `eudora.cpp`, `nickview.cpp`, `signatur.cpp`, `textfile.cpp`) — trifft (gemessen).
- Die übrigen MD-Dateien ohne `Arbeitsweise/` und `Befunde/` nur über `doku-pruefen.pl` und gezielte Suche nach [E-128](../Intern/BEFUNDE.md#e-128)/[E-213](../Intern/BEFUNDE.md#e-213)/[E-214](../Intern/BEFUNDE.md#e-214) und den Zweignamen geprüft, nicht einzeln gelesen.

## Was nur Gregor entscheiden kann

Nichts Neues. Beide Produktfragen zu [E-128](../Intern/BEFUNDE.md#e-128) hat Gregor am 03.11.2026 entschieden (Vorschlag „ja“; Textmail mit Umlauten bleibt `.eml`); [L-137.1](#l-137.1) zieht nur die Doku nach.

## Nachtrag 1 (03.11.2026, nach 38dc8775)

`origin/e128_endung_aus_inhalt` in `wt/lektor-20261103b` gemergt (Spitze `38dc8775` *„[LEKTOR-137](#lektor-137) eingearbeitet ([L-137.1](#l-137.1) bis .4, .6) …“*). Gemessen mit `grep`/`sed` am Stand nach dem Merge.

| Fund | Stand | Stelle |
|---|---|---|
| [L-137.1](#l-137.1) Umlaut-Textmail → `.eml` | **erledigt** | `Intern/TESTPLAN.md:487-490` *„Eine **Textmail ohne Umlaute** … **Text Files (*.txt)**. Eine Textmail **mit** Umlauten bekommt **Mail Files (*.eml)** — so gewollt“*; `Intern/BEFUNDE.md:391` Kurz *„Text ohne Umlaute als `.txt`, Text mit Umlauten als `.eml`“*; `README.md:163` und `Doku/FUNKTIONEN.md:85` *„(Kopfzeilen, HTML oder Umlaute)“* |
| [L-137.2](#l-137.2) „Gregor muss nichts tun“ | **erledigt** | `Intern/BEFUNDE.md:391` *„Gregor testet es am Paket 7.2.2.132 (siehe *Was noch fehlt*)“* |
| [L-137.3](#l-137.3) WEITERMACHEN | **erledigt** | `Intern/WEITERMACHEN.md:3` *„PRÜFER-90 … eingearbeitet“*, *„Laufend: `e170_label_ohne_uidplus`, `about_dialog_github` …“*; die ältere Liste mit `e133_…`/`e203_…` steht weiter hinten in derselben Zeile unter *„Davor, ebenfalls 03.11.2026“* — als Rückblick gekennzeichnet, kein Fehler |
| [L-137.4](#l-137.4) ZWEIGE | **erledigt** | `tools/ZWEIGE.md:217` nennt jetzt [E-213](../Intern/BEFUNDE.md#e-213) und [E-214](../Intern/BEFUNDE.md#e-214) |
| [L-137.5](#l-137.5) Berichtszahl | **offen** (vereinbart: nach dem letzten Merge) | `README.md:98` *„219 … gezählt am 02.11.2026“*; gezählt 225 |
| [L-137.6](#l-137.6) IMAP-Weg | **erledigt im TESTPLAN, am Prüfstand weiter ungemessen** | `Intern/TESTPLAN.md:491-494` *„**Ort: IMAP, offline** (freiwillig) … Bestanden, wenn **vor** dem Dialog keine Frage „online gehen?“ kommt. Am Prüfstand ist dieser Weg nicht gemessen.“* |

Kein neuer Fund. Was nur Gregor entscheiden kann: weiter nichts.
