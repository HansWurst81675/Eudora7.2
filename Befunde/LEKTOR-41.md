# <a id="lektor-41"></a>LEKTOR-41 — Doku nach 7.2.0.102 bis 7.2.0.106 (E-123, E-69) und Gregors Urteil zu E-121

Lauf am 17.10.2026 auf `wt/lektor`, Stand `d3314ddd` (= `e-123-beenden-warten`). Anlass: seit
[LEKTOR-40](LEKTOR-40.md#lektor-40) (`5986765`) sind 7.2.0.103 und 7.2.0.104 ([E-123](../BEFUNDE.md#e-123) nach [PRÜFER-34](PRUEFER-34.md) und
[PRÜFER-35](PRUEFER-35.md)), der nie ausgelieferte Zwischenbau 7.2.0.105 und 7.2.0.106 ([E-69](../BEFUNDE.md#e-69): eine
übersprungene Filternachricht steht in *Task Errors*) dazugekommen; dazu Gregor am 17.10.2026
im Chat: *„ja, e-121 behoben“*.

**Auftrag diesmal: nur melden, nichts ändern.** Alle Funde unten stehen deshalb unter *Offen*;
geändert ist nur diese Datei und der Eintrag in `LEKTORAT.md`.

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Arbeitsweise/` = 132 Dateien (133 mit diesem
Bericht), davon 42 außerhalb von `Befunde/`. Alle 42 durchsucht nach Stand- und Release-Aussagen
(*veröffentlicht ist*, *Latest*, *zuletzt veröffentlicht*, `7.2.0.10x`, `1.0.10x`) und nach
[E-121](../BEFUNDE.md#e-121), [E-123](../BEFUNDE.md#e-123), [E-69](../BEFUNDE.md#e-69). Ganz gelesen: README *Auf einen Blick* (`:36-96`) und die
E-121-Zeile unter *Was es nicht kann* (`:253-267`), ZIEL *Maßstab für 7.2.1.0* (`:10-38`) und
`:47`, der Kopf von `WEITERMACHEN.md` (`:1-44`) und der Block *Der nächste Schritt* (`:130`), CHANGELOG
*Noch offen* und die Abschnitte 7.2.0.101 bis 7.2.0.106 (`:80-106`), `Releases/PAKETE.md:1-40` und
`:159-205`, `Releases/1.0.106/TESTEN.txt`, `Releases/1.0.101/RELEASE-NOTIZEN.md`, `FILTER.md:714-726`.
**Maßstab:** `Eudora71/Version.h` = 7.2.0.106, `VERSION` = 1.0.106, `git tag` höchstes = `v1.0.101`,
Statuszeilen `BEFUNDE.md:237` ([E-69](../BEFUNDE.md#e-69)), `:288` ([E-121](../BEFUNDE.md#e-121)), `:290` ([E-123](../BEFUNDE.md#e-123)), der Quelltext
`Eudora71/Eudora/mainfrm.cpp:1964-1987` (Beenden-Warten), `filtersd.cpp:2555-2562` und
`TocFrame.cpp:2397-2409` (Filterschleife), `git diff 5986765 HEAD -- tools/`.

`perl tools/doku-pruefen.pl`: kein Widerspruch, fünf Hinweise *zur Kenntnis* (bewertet in
[L-41.10](#l-41.10)). `perl tools/offene-befunde.pl`: 33 offen, 33 in `WEITERMACHEN.md`.
`perl tools/pruefe-release-buchfuehrung.pl`: grün – zu Unrecht, siehe [L-41.2](#l-41.2).
`perl tools/rollen-faellig.pl`: PRÜFER und CHRONIST fällig ([L-41.11](#l-41.11)).

## Offen — nur gemeldet

### <a id="l-41.1"></a>L-41.1 — E-121: Gregors „behoben“ steht nirgends, der Befund gilt überall als offen (hoch)

Gregor am 17.10.2026 (Chat): *„ja, e-121 behoben“*. `git grep -i "e-121 behoben"` über alle MDs:
**kein Treffer** – das Urteil steht nur im Chat. Fundstellen, die [E-121](../BEFUNDE.md#e-121) als offen führen:

| Stelle | steht dort | richtig wäre (Quelle: Gregor 17.10.2026) |
|---|---|---|
| `BEFUNDE.md:288`, Urteilsfeld, erster Fettdruck | *„DATENVERLUST. Offen, Behebung eingebaut in 7.2.0.90 (Zweig `e-118_HTML_header`), am IMAP-Prüfserver in drei Fällen gemessen, von Gregor noch nicht bestätigt.“* | behoben, von Gregor bestätigt am 17.10.2026 an 1.0.101, ausgeliefert mit `v1.0.101`; schon [L-37.8](LEKTOR-37.md#l-37.8) bemängelte den ersten Satz. **Daran hängt alles Weitere:** `offene-befunde.pl` liest nur diesen Fettdruck |
| `WEITERMACHEN.md:307`, Liste der offenen Befunde | Zeile [E-121](../BEFUNDE.md#e-121) | fällt heraus, sobald `:288` berichtigt ist und `perl tools/offene-befunde.pl -schreiben` läuft |
| `CHANGELOG.md:16`, *Noch offen* | *„**Offen.** Behebung eingebaut in 7.2.0.90 …“* und *„Der Befund bleibt offen (Urteil in `BEFUNDE.md` …)“* | behoben, bestätigt an 1.0.101; die Zeile gehört aus *Noch offen* heraus |
| `WEITERMACHEN.md:130`, Nachtrag [LEKTOR-40](LEKTOR-40.md#lektor-40) | *„[E-121](../BEFUNDE.md#e-121) bleibt offen) – eine Entscheidung Gregors zwischen A und B steht nirgends“* | Gregors *„ja, e-121 behoben“* ist die Entscheidung für Weg A aus [L-38.4](LEKTOR-38.md#l-38.4) (*„[E-121](../BEFUNDE.md#e-121) schließen, Restfälle abtrennen“*) |
| `ZIEL.md:20`, Maßstab 7.2.1.0 | Aufzählung der Teile bis *„an 1.0.101 von Gregor bestätigt, veröffentlicht als `v1.0.101`“*, aber kein Urteil | dazu *„behoben, von Gregor am 17.10.2026 bestätigt“* – sonst bleibt offen, ob die Zeile für 7.2.1.0 erfüllt ist |
| `README.md:253-267`, *Was es nicht kann* | ganzer Absatz [E-121](../BEFUNDE.md#e-121) *„… kann spurlos verschwinden … Selten, aber still“* | gehört zu dem, was behoben ist |
| `WEITERMACHEN.md:44`, Eintrag 1.0.96 | *„der Befund bleibt offen wegen N1–N3“* | Fassungsgeschichte, darf so bleiben |
| `Testdaten/README.md:37` | *„**[E-121](../BEFUNDE.md#e-121)** bis 7.2.0.96 nachgebessert“* | bis 7.2.0.101 nachgebessert, behoben (niedrig) |

**Folge für die Restfälle (Gregors Entscheidung nötig):** `README.md:78` (*„Selten, vermutet: … gesendete
Mail … nur im lokalen Papierkorb“*, [PRÜFER-33](PRUEFER-33.md) Q1) und `README.md:80` (*„War der IMAP-Ordner
seit dem Start noch nie geöffnet …“*) verweisen auf [E-121](../BEFUNDE.md#e-121). Ist [E-121](../BEFUNDE.md#e-121) behoben, zeigen zwei
bekannte Fehler – einer davon mit möglichem Verlust einer gesendeten Mail – auf einen geschlossenen
Befund. Ebenso der Vorsatz `README.md:69` und `Releases/1.0.101/RELEASE-NOTIZEN.md:28-32` (veröffentlicht,
dort nur Verweis). Nach Weg A brauchen beide eine eigene Kennung, bevor `:288` umgestellt wird –
sonst fällt Q1 aus `WEITERMACHEN.md` heraus, ohne irgendwo offen zu stehen. Weiter ohne Eintrag
(aus [L-40.8](LEKTOR-40.md#l-40.8)): [PRÜFER-31](PRUEFER-31.md) F2, F5–F7, [PRÜFER-32](PRUEFER-32.md) N4.

### <a id="l-41.2"></a>L-41.2 — `v1.0.87` noch als „veröffentlicht ist“ in ZIEL und AUFGABEN (hoch)

| Stelle | steht dort | richtig |
|---|---|---|
| `ZIEL.md:47` | *„veröffentlicht ist 7.2.0.87 / Paket 1.0.87 als `v1.0.87` am 14.10.2026, auf GitHub als *Latest*“* | `v1.0.101` (17.10.2026, *Latest*; `git tag`, `WEITERMACHEN.md:43`). Derselbe Satz nennt vorher *„7.2.0.101, veröffentlicht als `v1.0.101`“* – er widerspricht sich selbst |
| `AUFGABEN.md:3` | *„**veröffentlicht ist `v1.0.87`** am 14.10.2026“* | `v1.0.101`; `AUFGABEN.md:124` sagt es richtig (*„**Veröffentlicht ist `v1.0.101`**“*) |

Warum keine Schranke anschlug: `pruefe-release-buchfuehrung.pl` verlangt, dass ein führendes Dokument
`v1.0.101` **kennt**; beide Absätze nennen `v1.0.101` auch – als Vorgeschichte. Dass ein älteres Release
im selben Absatz als *„veröffentlicht ist“* steht, prüft sie nicht (Vorschlag: Muster
*veröffentlicht ist …* / *Latest* gegen das höchste Tag, unabhängig davon, was der Absatz sonst nennt).

### <a id="l-41.3"></a>L-41.3 — E-123 und andere neue Befunde fehlen im Maßstab 7.2.1.0 (mittel)

`ZIEL.md:18-31` (Tabelle) und `:33-34` (*„Ausdrücklich nicht Voraussetzung“*): [E-123](../BEFUNDE.md#e-123) steht **in
keiner von beiden**. Ebenso [E-122](../BEFUNDE.md#e-122), [E-124](../BEFUNDE.md#e-124), [E-125](../BEFUNDE.md#e-125). Bei [E-123](../BEFUNDE.md#e-123) wiegt das
schwerer: es ist aus [E-121](../BEFUNDE.md#e-121) abgetrennt (`BEFUNDE.md:290`, *„dort N2/N3“*), und [E-121](../BEFUNDE.md#e-121) ist
Maßstab (*„Post wird verfälscht“*). Ob die abgetrennten Bildverluste nach einem Absturz für 7.2.1.0
behoben sein müssen, ist eine Entscheidung Gregors; die Tabelle stammt vom 14.10.2026, alle vier Befunde
sind später entstanden. Zusätzlich:

* `ZIEL.md:22`, [E-69](../BEFUNDE.md#e-69): *„Filterlauf bricht im Release lautlos ab, meldet Erfolg“* ohne Stand. Richtig nach
  `BEFUNDE.md:237`: *„behoben in 7.2.0.106 … von Gregor noch nicht bestätigt“*. Vorbild ist die Zeile
  [E-105](../BEFUNDE.md#e-105) (`:24`, *„eingebaut in 7.2.0.88“*).

### <a id="l-41.4"></a>L-41.4 — E-123: „höchstens 90 Sekunden“ und „7.2.0.102“ stimmen für die nächste Fassung nicht (mittel)

| Stelle | steht dort | richtig |
|---|---|---|
| `README.md:79`, *Was hilft* | *„Ab der nächsten Fassung (7.2.0.102, noch nicht veröffentlicht) wartet Eudora beim Beenden selbst, höchstens 90 Sekunden“* | 7.2.0.102 kann für immer warten ([PRÜFER-35](PRUEFER-35.md), `CHANGELOG.md:90`); gemeint ist 7.2.0.104 und jünger. Und nach `mainfrm.cpp:1975-1977` gelten 90 s nur, wenn kein Hochladen läuft und kein Dialog offen ist; sonst wird bis zu **5 Minuten** gewartet (`dwVergangen > 300000`). `Releases/1.0.106/TESTEN.txt` sagt Gregor richtig *„nach spaetestens 5 Minuten“* |
| `CHANGELOG.md:19`, *Noch offen* | *„Teilbehebung eingebaut in 7.2.0.102 … höchstens 90 s“* | wie `BEFUNDE.md:290`: abgesichert in 7.2.0.103 ([PRÜFER-34](PRUEFER-34.md)) und 7.2.0.104 ([PRÜFER-35](PRUEFER-35.md)), Obergrenze 5 Minuten |

`WEITERMACHEN.md:9` nennt *„(höchstens 90 s)“* nur in der Geschichte zu 7.2.0.102 und danach richtig
*„nach 5 Minuten wird in jedem Fall beendet“* – in Ordnung. Die README-Spalte ist Gregors Tabelle:
**Wortlaut bitte prüfen**.

### <a id="l-41.5"></a>L-41.5 — E-69: README beschreibt mehr Schaden, als der Quelltext hergibt; Stand 7.2.0.106 fehlt (mittel)

* `README.md:75`: *„nichts geht verloren – aber die **übrigen Nachrichten bleiben ungefiltert** liegen“*.
  Am Quelltext: das `break` (`filtersd.cpp:2561`) verlässt nur die Regelschleife **dieser** Nachricht;
  `CFiltersDoc::FilterMsg` kehrt zurück, und die Schleife über die Auswahl (`TocFrame.cpp:2397-2409`)
  macht mit der nächsten Nachricht weiter. `CHANGELOG.md:82` sagt entsprechend *„übersprang eine
  Nachricht“*. Richtig wäre: *diese eine Nachricht bleibt ungefiltert liegen*. Nachgerechnet habe ich
  nur den Weg *Special → Filter Messages*; für den Abruf (`pop.cpp:999`) ist es nach
  `BEFUNDE.md:237` dasselbe, von mir nicht nachgelesen. Gilt auch für `v1.0.101`.
  Dazu fehlt in der Zeile, analog zu [E-123](../BEFUNDE.md#e-123) (`:79`): *ab 7.2.0.106 (nicht veröffentlicht) steht die
  Nachricht in Task Errors*. **Gregors Tabelle, Wortlaut bitte prüfen.**
* `CHANGELOG.md:44`, *Noch offen*, [E-69](../BEFUNDE.md#e-69): *„die drei Abbruchstellen protokollieren jetzt, statt nur zu
  assertieren“* – Stand vor 7.2.0.106. Richtig nach `CHANGELOG.md:82`/`BEFUNDE.md:237`: *behoben in
  7.2.0.106, fünf Stellen melden in Task Errors, am Prüfstand gemessen, von Gregor noch nicht bestätigt*.
* `FILTER.md:722`: [E-69](../BEFUNDE.md#e-69) unter *„sind **offen**“* ohne 7.2.0.106. Dazu der Kopf `FILTER.md:3-4`
  *„Der Quellstand ist inzwischen **7.2.0.73 / 1.0.73**“* (niedrig, alt).

### <a id="l-41.6"></a>L-41.6 — WEITERMACHEN: der Block „Der nächste Schritt“ steht bei 7.2.0.102 (mittel)

`WEITERMACHEN.md:130` (*„HIER WEITERMACHEN (gilt vor allen Blöcken darunter)“*) endet mit dem Nachtrag
aus [LEKTOR-40](LEKTOR-40.md#lektor-40): *„7.2.0.102 …, Paket 1.0.102 bei Gregor“*. Es fehlen 7.2.0.103/104 ([PRÜFER-34](PRUEFER-34.md),
[PRÜFER-35](PRUEFER-35.md)), 7.2.0.106 ([E-69](../BEFUNDE.md#e-69)), Paket 1.0.106 bei Gregor (`:12`, *„testet erst am nächsten
Testtag“*) und Gregors Urteil zu [E-121](../BEFUNDE.md#e-121) ([L-41.1](#l-41.1)). Paket 1.0.102 ist laut
`Releases/PAKETE.md:185` *„ersetzt durch 1.0.103, Testverzeichnis entfernt, nie getestet“*. Die Kopftabelle
(`:9`, `:12`) ist aktuell – nur der Block, der *vor allen* gelten soll, nicht. Weiter (aus [L-40.8](LEKTOR-40.md#l-40.8)):
zwei Zeilen *Quellstand davor* (`:10`, `:11`).

### <a id="l-41.7"></a>L-41.7 — TESTPLAN: 1.0.104 „zum Test bei Gregor“ (niedrig)

`TESTPLAN.md:1`: *„davor **Paket 1.0.104 ([E-123](../BEFUNDE.md#e-123) Beenden wartet) zum Test bei Gregor;**“*. Richtig nach
`Releases/PAKETE.md:169`: *„ersetzt durch 1.0.106, Testverzeichnis entfernt, nie getestet“*. Die
Prüfschritte zu 1.0.106 stehen nur in `Releases/1.0.106/TESTEN.txt`; einen TESTPLAN-Abschnitt ab 1.0.90
gibt es weiter nicht ([L-37.14](LEKTOR-37.md#l-37.14)).

### <a id="l-41.8"></a>L-41.8 — WERKZEUGE: zwei neue Messskripte ohne Eintrag (mittel)

`git diff --stat 5986765 HEAD -- tools/`: neu `tools/messen-e69.ps1` und `tools/messen-e123-doppelt.ps1`,
geändert `tools/pruefe-befund-verbreitung.pl` (Umlaut vor der Kennung, Selbsttest 2b). Abgleich
jedes `tools/*.ps1` und `tools/*.pl` gegen `tools/WERKZEUGE.md`: **genau diese zwei** fehlen.
`messen-e69.ps1` gehört unter *Nicht in der Tabelle* (`:134-145`) neben `messen-e123.ps1`: läuft unter
`testlauf.ps1 -MessenSkript`, öffnet *In*, wählt alles aus, sperrt `In.mbx` von außen und löst
*Special → Filter Messages* aus; gemessen wird `E-69 Filter uebersprungen`. `messen-e123-doppelt.ps1`:
wie `messen-e123.ps1`, beendet aber selbst über *File → Exit*, danach kommt das zweite Schließen
([PRÜFER-34](PRUEFER-34.md) S1). Der Kopf `:3` sagt *„der Quellstand ist inzwischen 7.2.0.102“* – jetzt 7.2.0.106.
Nebenbei `tools/messen-e69.ps1:7` *„Seit 7.2.0.105 steht dafuer ein Eintrag“* – 7.2.0.105 wurde nie
ausgeliefert, ausgeliefert ist es ab 7.2.0.106 (niedrig).

### <a id="l-41.9"></a>L-41.9 — ZWEIGE: der laufende Zweig steht bei 7.2.0.102 (niedrig)

`tools/ZWEIGE.md:101`, `e-123-beenden-warten`: *„Darauf 7.2.0.102 (`f09362f0`, Paket 1.0.102 bei Gregor, nicht
veröffentlicht)“*. Es fehlen 7.2.0.103 (`916df7c7`), 7.2.0.104 (`a4cae066`) und 7.2.0.106 (`d3314ddd`, [E-69](../BEFUNDE.md#e-69)),
und 1.0.102 liegt nicht mehr bei Gregor. Der Zweck nennt nur [E-123](../BEFUNDE.md#e-123); dass [E-69](../BEFUNDE.md#e-69) auf diesem Zweig
liegt, steht in der Zeile nicht – ob Gregor dem zugestimmt hat, ist in `ZWEIGE.md` nicht belegt.

### <a id="l-41.10"></a>L-41.10 — die fünf Hinweise „zur Kenntnis“ aus `doku-pruefen.pl`

| Datei | soll den Quellstand nennen? | Begründung |
|---|---|---|
| `Releases/1.0.101/RELEASE-NOTIZEN.md` | **nein** | veröffentlichter Text zu genau 7.2.0.101; ein späterer Stand wäre falsch |
| `Testdaten/README.md` | **nein** | der Kopf (`:3`) sagt selbst *„haengen an keiner Programmfassung“*; nur `:6`/`:37` sind zu [E-121](../BEFUNDE.md#e-121) veraltet ([L-41.1](#l-41.1)) |
| `tools/WERKZEUGE.md` | **ja** | hat eine eigene Standzeile (`:3`), die jetzt falsch ist ([L-41.8](#l-41.8)) |
| `tools/ZWEIGE.md` | **ja, in der Zeile des laufenden Zweigs** | [L-41.9](#l-41.9); nicht als Kopfangabe, siehe [L-15.5](LEKTOR-15.md#l-15.5) |
| `tools/pruefdaten/LIESMICH.md` | **nein** | Messtabelle zu [AN-1](../BEFUNDE.md#an-1) mit den Fassungen, an denen gemessen wurde (7.2.0.78 bis 7.2.0.83) |

Vorschlag: die drei *nein* in eine Ausnahmeliste von `doku-pruefen.pl`, damit der Hinweis nicht bei
jedem Lauf wieder erscheint und die zwei echten übertönt.

### <a id="l-41.11"></a>L-41.11 — PRÜFER für 7.2.0.104 und 7.2.0.106 fällig, CHRONIST fällig

`perl tools/rollen-faellig.pl`: PRÜFER fällig seit `6b52c61` (PRÜFER-35 = 7.2.0.103), sechs Dateien, darunter
`ImapAccountMgr.cpp`, `ImapActionQueue.cpp`, `TaskErrorMT.h`. Damit liegt Paket 1.0.106 bei Gregor, ohne dass
die Korrekturen aus 7.2.0.104 (Zähler `CE123HochladenZaehler`, 5-Minuten-Grenze) und [E-69](../BEFUNDE.md#e-69) nachgerechnet
sind. CHRONIST fällig seit `11bf2c1` (25 Dateien) – schon in [L-40.5](LEKTOR-40.md#l-40.5) gemeldet.

### <a id="l-41.12"></a>L-41.12 — was aus LEKTOR-40 geworden ist

| Punkt | Stand |
|---|---|
| [L-40.1](LEKTOR-40.md#l-40.1) [E-123](../BEFUNDE.md#e-123) fällt aus der Liste | **erledigt**: `BEFUNDE.md:290` beginnt *„**Offen; Teilbehebung …**“*, `offene-befunde.pl` 33/33 |
| [L-40.5](LEKTOR-40.md#l-40.5) PRÜFER/CHRONIST für 7.2.0.102 | PRÜFER mit [PRÜFER-34](PRUEFER-34.md) und [PRÜFER-35](PRUEFER-35.md) gelaufen; CHRONIST weiter fällig ([L-41.11](#l-41.11)) |
| [L-40.6](LEKTOR-40.md#l-40.6) Kürzel in der CHANGELOG-Zeile [E-121](../BEFUNDE.md#e-121) | **offen** (`CHANGELOG.md:16`: *F1*, *N1*, *F3–F9*, *Q1*); erledigt sich, wenn die Zeile nach [L-41.1](#l-41.1) aus *Noch offen* geht |
| [L-40.7](LEKTOR-40.md#l-40.7) Release-Notizen ohne Vorbehalt in der Überschrift | unverändert, Gregors Entscheidung |
| [L-38.5](LEKTOR-38.md#l-38.5) [E-78](../BEFUNDE.md#e-78) in der README-Tabelle, [E-124](../BEFUNDE.md#e-124) ohne Verweis auf [E-123](../BEFUNDE.md#e-123) | **offen** (`grep -c E-78 README.md` = 0) |
| [L-37.8](LEKTOR-37.md#l-37.8) erster Satz des E-121-Urteils | **offen**, jetzt mit Gregors Urteil dagegen ([L-41.1](#l-41.1)) |
| [L-37.10](LEKTOR-37.md#l-37.10) AUFGABEN ohne Zeilen für [E-122](../BEFUNDE.md#e-122) bis [E-125](../BEFUNDE.md#e-125) | **offen** (nur der Kopf `:3` nennt [E-123](../BEFUNDE.md#e-123)) |
| [L-37.13](LEKTOR-37.md#l-37.13) DLLs im Hauptbaum | **offen**: ` M` an `DirServ.dll`, `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` (Git-Stand zu Sitzungsbeginn) |
| [L-37.14](LEKTOR-37.md#l-37.14) TESTPLAN ohne Abschnitt ab 1.0.90 | **offen** ([L-41.7](#l-41.7)) |
