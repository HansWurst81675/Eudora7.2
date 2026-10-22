# <a id="lektor-40"></a>LEKTOR-40 — Doku nach Release v1.0.101 und 7.2.0.102 (in Arbeit)

Lauf am 17.10.2026 auf `wt/lektor`. Ausgangsstand laut Auftrag `f09362f0` (= `e-123-beenden-warten`);
auf `origin/e-123-beenden-warten` stand schon `3ea8cbc7` (*„[E-125](../Intern/BEFUNDE.md#e-125): Gregors Entscheidung B“*, nur
`BEFUNDE.md`) – `wt/lektor` per `merge --ff-only` darauf gezogen, damit der Lauf die Entscheidung
sieht. Anlass: seit [LEKTOR-39](LEKTOR-39.md#lektor-39) (`949997ea`) sind [PRÜFER-33](PRUEFER-33.md) gelaufen
(7.2.0.101 nachgerechnet, Q1 neu), Gregor hat 1.0.101 bestätigt, Release `v1.0.101` am 17.10.2026
(Marke auf `eec4e4e5` = PR #99, Doku-PR #100 `6734648b`), 7.2.0.102 auf `e-123-beenden-warten`
([E-123](../Intern/BEFUNDE.md#e-123) Teilbehebung: Beenden wartet), Gregors Entscheidung zu [E-125](../Intern/BEFUNDE.md#e-125).

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Arbeitsweise/` = 129 Dateien (130 mit diesem
Bericht), davon 42 außerhalb von `Befunde/`. Alle 42 über Stand- und Release-Aussagen gesucht
(*neuestes Release*, *zuletzt veröffentlicht*, *noch nicht ausgeliefert*, *nicht veröffentlicht*,
`7.2.0.10x`, `1.0.10x`) und über [E-121](../Intern/BEFUNDE.md#e-121), [E-123](../Intern/BEFUNDE.md#e-123), [E-125](../Intern/BEFUNDE.md#e-125); ganz gelesen die
seit `949997ea` geänderten Stellen, README *Auf einen Blick* und *Was es nicht kann* (Abschnitte
[E-105](../Intern/BEFUNDE.md#e-105) bis [E-83](../Intern/BEFUNDE.md#e-83)), CHANGELOG *Noch offen* und die Fassungsüberschriften, den Kopf von
`WEITERMACHEN.md`. Aus `Befunde/` neu `PRUEFER-33.md` (Urteil und Tabelle). **Maßstab:**
`Eudora71/Version.h` = 7.2.0.102, `VERSION` = 1.0.102, `git tag` höchstes = `v1.0.101` auf
`eec4e4e5`, `git ls-remote` (Zweige `e-118_HTML_header`, `e-121-mehrere-gesendete`,
`e-123-beenden-warten` auf `origin`), Statuszeilen `BEFUNDE.md:288` ([E-121](../Intern/BEFUNDE.md#e-121)), `:290` ([E-123](../Intern/BEFUNDE.md#e-123)),
`:292` ([E-125](../Intern/BEFUNDE.md#e-125)), `Releases/1.0.102/TESTEN.txt`, `git diff 949997ea HEAD -- tools/`.

`perl tools/doku-pruefen.pl`: kein Widerspruch. `perl tools/pruefe-release-buchfuehrung.pl`: alle
führenden Dokumente kennen `v1.0.101`. `perl tools/offene-befunde.pl`: 33 offen, 34 in
`WEITERMACHEN.md`, *ZU VIEL: [E-123](../Intern/BEFUNDE.md#e-123)* – siehe [L-40.1](#l-40.1).

## Berichtigt

### <a id="l-40.2"></a>L-40.2 — WERKZEUGE: neue Option, neue Parameter, neues Skript

`git diff 949997ea HEAD -- tools/`: `imap-pruefserver.pl` hat `--append-verzoegerung <s>`,
`e118-serie.ps1` die Parameter `-Messen`, `-SchliessSekunden`, `-AppendVerzoegerung`, neu ist
`tools/messen-e123.ps1`. Nichts davon stand in `tools/WERKZEUGE.md`. Eingetragen: Kopf auf 7.2.0.102,
die Option in der Zeile `imap-pruefserver.pl`, die drei Parameter in der Zeile `e118-serie.ps1`,
`messen-e123.ps1` unter *Nicht in der Tabelle* neben `messen-e67.ps1`. Wie in [L-39.3](LEKTOR-39.md#l-39.3): keine
Schranke meldet ein Werkzeug oder eine Option ohne Zeile.

### <a id="l-40.3"></a>L-40.3 — Release v1.0.101 stand an zehn Stellen noch als Zukunft da

| Stelle | stand | jetzt |
|---|---|---|
| `README.md`, *Was es nicht kann*, [E-105](../Intern/BEFUNDE.md#e-105), [E-118](../Intern/BEFUNDE.md#e-118), [E-121](../Intern/BEFUNDE.md#e-121), [E-83](../Intern/BEFUNDE.md#e-83) | *„noch nicht ausgeliefert“* (viermal); bei [E-121](../Intern/BEFUNDE.md#e-121) *„Paket 1.0.101 zum Test bei Gregor“* | *„ausgeliefert mit `v1.0.101`“*; [E-121](../Intern/BEFUNDE.md#e-121) *„an 1.0.101 von Gregor bestätigt (17.10.2026)“*. [E-105](../Intern/BEFUNDE.md#e-105) behält *„von Gregor noch nicht bestätigt“* |
| `README.md:133-137`, Absatz *Das neueste Release ist `v1.0.101`* | *„Verschieben in einen IMAP-Ordner verliert keine Mail mehr, auch gesendete“* – ohne die Einschränkung, die *Auf einen Blick* (`:57`, `:78`) seit `f66078b6` trägt | dazu *„bis auf einen seltenen, vermuteten Fall bei gesendeter Post (siehe Auf einen Blick)“* – derselbe Vorbehalt wie `:57`, kein neues Urteil |
| `CHANGELOG.md`, Überschriften 7.2.0.88 bis 7.2.0.100 (13 Stück) | *„nicht veröffentlicht“* | *„nicht einzeln veröffentlicht, enthalten in `v1.0.101`“* (die Überschrift 7.2.0.101 sagt selbst *„enthält 7.2.0.88 bis 7.2.0.101“*) |
| `CHANGELOG.md`, *Noch offen*, [E-118](../Intern/BEFUNDE.md#e-118) | *„noch nicht veröffentlicht“* | *„veröffentlicht mit `v1.0.101`“* |
| `CHANGELOG.md`, *Noch offen*, [E-121](../Intern/BEFUNDE.md#e-121) | endete bei *„Paket 1.0.101 zum Test bei Gregor“* | bestätigt, veröffentlicht als `v1.0.101`; dazu [PRÜFER-33](PRUEFER-33.md) Q1 in Klartext als offen |
| `ZIEL.md:20`, Maßstabszeile [E-121](../Intern/BEFUNDE.md#e-121) | *„Paket 1.0.101 zum Test bei Gregor“* | *„an 1.0.101 von Gregor bestätigt, veröffentlicht als `v1.0.101`“* |
| `Releases/PAKETE.md:6` und `:20` | *„zuletzt veröffentlicht 1.0.87“*, *„veröffentlicht ist inzwischen `v1.0.87`“* | `v1.0.101` (17.10.2026, 19:12 UTC, aus `WEITERMACHEN.md:43`), `v1.0.87` als *davor* |
| `WEITERMACHEN.md`, Zeile *Paket 1.0.101* | *„Ziel: Release v1.0.101“* | bestätigt und veröffentlicht |
| `tools/ZWEIGE.md`, `e-121-mehrere-gesendete` | *„Ziel jetzt Release v1.0.101“* | gemergt mit PR #99 (`eec4e4e5`, Marke `v1.0.101`), Doku mit PR #100 (`6734648b`); Zweig steht noch auf `origin` |
| `tools/ZWEIGE.md`, `e-123-beenden-warten` | nur Zweck | dazu 7.2.0.102 (`f09362f0`) und die [E-125](../Intern/BEFUNDE.md#e-125)-Entscheidung (`3ea8cbc7`) |

Urteile unverändert.

### <a id="l-40.4"></a>L-40.4 — E-123 und E-125: der neue Stand fehlte außerhalb von BEFUNDE.md

* `CHANGELOG.md`, *Noch offen*, [E-123](../Intern/BEFUNDE.md#e-123): stand *„Offen, Vermutung am Quelltext, ungemessen“* –
  `BEFUNDE.md:290` sagt seit `f09362f0` *„Teilbehebung eingebaut in 7.2.0.102 … Bleibt offen für
  Absturz, Defender, Stromausfall, erzwungenes Herunterfahren“*. Jetzt: *Offen; Teilbehebung
  eingebaut in 7.2.0.102 (nicht veröffentlicht)* mit diesen vier Restfällen.
* `README.md:79`, *Auf einen Blick*, Zeile [E-123](../Intern/BEFUNDE.md#e-123), Spalte *Was hilft*: die Abhilfe
  *„vor dem Beenden warten, bis das Verschieben fertig ist“* bleibt (sie gilt für den Download
  `v1.0.101`); dazu *„Ab der nächsten Fassung (7.2.0.102, noch nicht veröffentlicht) wartet Eudora
  beim Beenden selbst, höchstens 90 Sekunden; nach einem Absturz, Stromausfall oder erzwungenen
  Herunterfahren kann es weiter passieren“*. **Wortlaut bitte prüfen** – Gregors Tabelle.
* `CHANGELOG.md`, *Noch offen*, [E-125](../Intern/BEFUNDE.md#e-125): Gregors Entscheidung aus `BEFUNDE.md:292`
  (*„B“* – Ziehen nach `Out` wird abgelehnt mit Hinweis auf *Message → Send Again*, noch nicht
  gebaut) nachgetragen. Die README-Zeile (`:88`) bleibt, sie beschreibt das Verhalten von `v1.0.101`.
* `WEITERMACHEN.md`, Block *HIER WEITERMACHEN*: Nachtrag mit Release, 7.2.0.102, Paket 1.0.102 (Gregor
  testet am nächsten Testtag), [E-125](../Intern/BEFUNDE.md#e-125)-Entscheidung, fällige Rollen. Zu Punkt (2) dort
  ([L-39.1](LEKTOR-39.md#l-39.1)): die README trägt seit `f66078b6` die Zeile *„Selten, vermutet“* (Weg B) – eine
  Entscheidung Gregors zwischen A und B steht nirgends; so vermerkt.

## Offen — nur gemeldet

### <a id="l-40.1"></a>L-40.1 — E-123 fällt aus der Liste der offenen Befunde

`BEFUNDE.md:290` beginnt das Urteil mit **„Teilbehebung eingebaut in 7.2.0.102 (17.10.2026), Zweig
`e-123-beenden-warten`:“** – im ersten Fettdruck steht kein Urteilswort. `tools/offene-befunde.pl`
liest nur diesen Fettdruck (`:117`) und verlangt ein Wort aus `offen`, `in arbeit`,
`zurückgestellt`, `teilweise` (`:76`, `:130`); *Teilbehebung* trifft keines. Folge: das Werkzeug
meldet [E-123](../Intern/BEFUNDE.md#e-123) als **erledigt** (*ZU VIEL*), obwohl die Zeile *„Bleibt offen für Absturz,
Defender, Stromausfall …“* sagt. Wer jetzt `perl tools/offene-befunde.pl -schreiben` laufen lässt,
**nimmt [E-123](../Intern/BEFUNDE.md#e-123) aus `WEITERMACHEN.md` heraus.** Vorschlag (Urteilsfeld, deshalb nicht von mir
geändert): Fettdruck auf *„Offen, Teilbehebung eingebaut in 7.2.0.102 …“*. Dazu eine Lücke im
Werkzeug: ein Fettdruck ganz ohne Urteilswort fällt still heraus, statt gemeldet zu werden.

### <a id="l-40.5"></a>L-40.5 — PRÜFER und CHRONIST für 7.2.0.102 fällig

`perl tools/rollen-faellig.pl`: PRÜFER fällig (`ImapAccount*.cpp/.h`, `ImapActionQueue.cpp`,
`mainfrm.cpp`), CHRONIST fällig (20 Dateien seit `11bf2c1`). Besonders nachzurechnen, weil
`BEFUNDE.md:290` es selbst sagt: die Wiederholung bei belegter Verbindung ist *„nicht durchlaufen …
nur am Quelltext begründet“*; dazu der Nebenbefund *„Filter nach IMAP reiht bei langsamem Server
nichts ein“* (ohne eigene Kennung).

### <a id="l-40.6"></a>L-40.6 — Prüfer-Kürzel in anwendernahen Texten

Gesucht in `README.md`, `FILTER.md`, `TESTPLAN.md`, `Releases/1.0.102/TESTEN.txt`,
`Releases/1.0.101/RELEASE-NOTIZEN.md` nach `F1`…`F9`, `N1`…`N9`, `P1`…`P9`, `Q1`…`Q9`: nur
`TESTPLAN.md:1` *„PRÜFER-31 F1: zwei gesendete Mails auf einmal nach IMAP“* (mit Klartext). Die
CHANGELOG-Zeile [E-121](../Intern/BEFUNDE.md#e-121) trägt weiter *„PRÜFER-30 F1“*, *„N1“*, *„N2/N3“*, *„F3–F9“*, *„F2 …“*
([L-39.6](LEKTOR-39.md#l-39.6), unverändert; neu hinzugekommen nur *Q1* mit Klartext).

### <a id="l-40.7"></a>L-40.7 — Release-Notizen v1.0.101 ohne Vorbehalt in der Überschrift

`Releases/1.0.101/RELEASE-NOTIZEN.md:8` *„Verschieben in einen IMAP-Ordner verliert keine Mail mehr.“*;
die Einschränkung steht erst unter *Bekannte Fehler* (`:31`, *„Selten, vermutet“*). Das ist der
veröffentlichte Text – auf GitHub, nicht nur im Repo. Nicht geändert; ob die Release-Beschreibung
auf GitHub nachgezogen wird, entscheidet Gregor.

### <a id="l-40.8"></a>L-40.8 — was aus LEKTOR-39 geworden ist

| Punkt | Stand |
|---|---|
| [L-39.1](LEKTOR-39.md#l-39.1) *Auf einen Blick* gegen [E-121](../Intern/BEFUNDE.md#e-121) | **umgesetzt als Weg B** (`f66078b6`: Vorsatz *„Bis auf die mit Selten beginnende Zeile …“*, Zeile [PRÜFER-33](PRUEFER-33.md) Q1); PRÜFER-33 hat 7.2.0.101 nachgerechnet. Letzter Rest in `README.md:136` berichtigt ([L-40.3](#l-40.3)). Weiter ohne Eintrag: [PRÜFER-31](PRUEFER-31.md) F2, F5–F7, [PRÜFER-32](PRUEFER-32.md) N4 (PRÜFER-33: *„unverändert offen“*) |
| [L-39.6](LEKTOR-39.md#l-39.6) Kürzel in der CHANGELOG-Zeile [E-121](../Intern/BEFUNDE.md#e-121) | **offen** ([L-40.6](#l-40.6)) |
| [L-39.7](LEKTOR-39.md#l-39.7) Release v1.0.101 nachziehen | README-Kopf, PAKETE-Abschnitt, RELEASES, WEITERMACHEN mit PR #100 erledigt; die Reste in [L-40.3](#l-40.3) |
| [L-38.5](LEKTOR-38.md#l-38.5) übrige Tabellenzeilen | **offen**: [E-78](../Intern/BEFUNDE.md#e-78) fehlt in der README-Tabelle, [E-124](../Intern/BEFUNDE.md#e-124) ohne Querverweis auf [E-123](../Intern/BEFUNDE.md#e-123) |
| [L-37.8](LEKTOR-37.md#l-37.8) erster Satz des E-121-Urteils | **offen**: `BEFUNDE.md:288` beginnt weiter *„Offen, Behebung eingebaut in 7.2.0.90 … von Gregor noch nicht bestätigt“* |
| [L-37.10](LEKTOR-37.md#l-37.10) AUFGABEN ohne Zeilen für [E-122](../Intern/BEFUNDE.md#e-122) bis [E-125](../Intern/BEFUNDE.md#e-125) | **offen** (`grep -c 'E-12[2-5]' AUFGABEN.md`: nur der Kopf `:3` nennt [E-123](../Intern/BEFUNDE.md#e-123)) |
| [L-37.13](LEKTOR-37.md#l-37.13) DLLs im Hauptbaum | **offen**: der Hauptbaum zeigt weiter ` M` an `DirServ.dll`, `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` (Git-Stand zu Sitzungsbeginn) |
| [L-37.14](LEKTOR-37.md#l-37.14) TESTPLAN ohne Abschnitt ab 1.0.90 | **offen**; die Prüfschritte zu 1.0.102 stehen nur in `Releases/1.0.102/TESTEN.txt` |
| `WEITERMACHEN.md` | zwei Zeilen heißen *Quellstand davor* (`:10` und `:11`), beide über 7.2.0.101 – zusammenlegen, wenn der Kopf das nächste Mal neu geschrieben wird |
