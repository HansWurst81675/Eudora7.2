# <a id="lektor-36"></a>LEKTOR-36 — Doku nach 7.2.0.96 (E-118 bestätigt, E-121 Teile 1 bis 6)

Lauf am 15.10.2026 auf `wt/lektor` (`9840ee35`, gleich `e-118_HTML_header`; `origin/main`
mit PR #97 ist enthalten). Anlass: seit [LEKTOR-35](LEKTOR-35.md#lektor-35) (`4b289d5`) sind
[E-118](../Intern/BEFUNDE.md#e-118) Teil 1 (an 1.0.89) und Teil 2 (an 1.0.90) von Gregor bestätigt,
[E-121](../Intern/BEFUNDE.md#e-121) hat sechs weitere Anläufe gegen die Doppelanzeige bekommen
(7.2.0.91 bis 7.2.0.96, Pakete 1.0.91 bis 1.0.96), Teil 6 ist an 1.0.96 bestätigt, der
Befund bleibt offen wegen N1–N3. Neuestes Tag: `v1.0.87`.

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Arbeitsweise/` = 120 Dateien, davon
41 außerhalb von `Befunde/` gelesen; aus `Befunde/` die Berichte der Runde
(`PRUEFER-27.md` bis `PRUEFER-29.md`) und alle 79 über `befunde-verlinken.pl --anker`.
Dazu eine eigene Suche nach toten Dateilinks über alle 120 (nur Treffer in
Codespannen, also Beispiele, keine echten). **Maßstab:** `Eudora71/Version.h` = 7.2.0.96,
`VERSION` = 1.0.96, `git tag` = `v1.0.87`, Urteile in `BEFUNDE.md`, Commit-Nachrichten
`8008f96e` bis `9840ee35`.

`perl tools/doku-pruefen.pl`: kein Widerspruch; zur Kenntnis vier Dateien ohne 7.2.0.96
([L-36.7](#l-36.7), [L-36.14](#l-36.14)). `perl tools/offene-befunde.pl` vor dem Lauf:
**ZU VIEL [E-118](../Intern/BEFUNDE.md#e-118)** ([L-36.1](#l-36.1)), danach 32/32.

## Berichtigt

### <a id="l-36.1"></a>L-36.1 — E-118 stand noch in der offenen Liste

`BEFUNDE.md:285` beginnt jetzt mit *„**BESTÄTIGT von Gregor am 14.10.2026 an 1.0.90 (Teil 2)**“*,
Teil 1 ist an 1.0.89 bestätigt; `offene-befunde.pl` meldete [E-118](../Intern/BEFUNDE.md#e-118) als zu viel in
`WEITERMACHEN.md`. Neu gesetzt mit `-schreiben`, dann `befunde-verlinken.pl --verlinken`
(der Linkverlust aus [L-35.8](LEKTOR-35.md#l-35.8) trat wieder auf und wurde wieder
so behoben). 32 offen laut `BEFUNDE.md`, 32 in `WEITERMACHEN.md`.

### <a id="l-36.2"></a>L-36.2 — README: E-118 Teil 2 „noch nicht bestätigt“, E-121 ohne die Teile 1 bis 6

| Stelle | stand | jetzt | Beleg |
|---|---|---|---|
| `README.md:179` | *„… von Gregor am 14.10.2026 an 1.0.89 bestätigt)“* | *„Teil 1 … an 1.0.89 bestätigt, Teil 2 am 14.10.2026 an 1.0.90)“* | `BEFUNDE.md:285`, `94c4f06b` |
| `README.md:182` | *„das holt 7.2.0.90 nach (… von Gregor noch nicht bestätigt)“* | *„… von Gregor am 14.10.2026 an 1.0.90 bestätigt“* | ebenda |
| `README.md:185` | *„Behebung in 7.2.0.90 eingebaut, … noch nicht ausgeliefert)“* | dazu *„gegen die Doppelanzeige danach sechs Anläufe bis 7.2.0.96, der letzte an 1.0.96 von Gregor bestätigt; Restfälle N1–N3 offen“* | `BEFUNDE.md:288` (*„Sechster Teil … bestätigt“*), `9840ee35` |

### <a id="l-36.3"></a>L-36.3 — „Teil 2 noch nicht bestätigt“ an fünf weiteren Stellen

| Stelle | stand | jetzt |
|---|---|---|
| `ZIEL.md:21` | **widersprach sich in derselben Zelle:** *„Teil 2 … an 1.0.90 bestätigt; … Teil 2, eingebettete Bilder, eingebaut in 7.2.0.90, noch nicht bestätigt“* | der veraltete Schluss gestrichen |
| `AUFGABEN.md:416` | *„Teil 2 (eingebettete Bilder) eingebaut in 7.2.0.90, noch nicht bestätigt“* | *„… von Gregor am 14.10.2026 an 1.0.90 bestätigt“* |
| `CHANGELOG.md:17` (*Noch offen*) | nur Teil 1 an 1.0.89 | dazu Teil 2 an 1.0.90 |
| `Testdaten/README.md:36` | `e118-eingebettetes-bild.eml`: *„eingebaut in 7.2.0.90, am IMAP-Prüfserver gemessen“* | dazu Teil 2 bestätigt, [E-121](../Intern/BEFUNDE.md#e-121) bis 7.2.0.96 nachgebessert |
| `TESTPLAN.md:1` | *„offen: C5 … ([E-118](../Intern/BEFUNDE.md#e-118), [E-105](../Intern/BEFUNDE.md#e-105))“*, 1.0.96 *„in Arbeit“* | offen nur noch [E-105](../Intern/BEFUNDE.md#e-105); 1.0.96 bestätigt |

Beleg wie [L-36.2](#l-36.2). Die Zeile [E-118](../Intern/BEFUNDE.md#e-118) in `ZIEL.md` bleibt unter den Maßstabsfehlern
stehen: veröffentlicht ist die Behebung nicht (`v1.0.87`).

### <a id="l-36.4"></a>L-36.4 — E-121 stand bei 7.2.0.90; in *Noch offen* fehlten E-121 und E-122

| Stelle | stand | jetzt |
|---|---|---|
| `ZIEL.md:20` | *„(**eingebaut in 7.2.0.90**)“* | dazu sechs Anläufe gegen die Doppelanzeige bis 7.2.0.96, an 1.0.96 bestätigt, N1–N3 offen |
| `CHANGELOG.md`, *Noch offen (Stand 15.10.2026)* | keine Zeile zu [E-121](../Intern/BEFUNDE.md#e-121) (Datenverlust!) und [E-122](../Intern/BEFUNDE.md#e-122) | zwei Zeilen, Wortlaut aus `BEFUNDE.md:288-289` |
| `tools/ZWEIGE.md:101` | Zweck des Zweigs endet bei 7.2.0.90 | dazu 7.2.0.91 bis 7.2.0.96 |

### <a id="l-36.5"></a>L-36.5 — Gregors Tests an 1.0.89 bis 1.0.96 fehlten in zwei Übersichten

* `WEITERMACHEN.md:38`, *Zuletzt von Gregor bestätigt*: begann mit *„**1.0.87 am 14.10.2026**“*.
  Jetzt eine eigene Zeile davor: 1.0.96 ([E-121](../Intern/BEFUNDE.md#e-121) Teil 6, Zitat aus `BEFUNDE.md:288`), 1.0.90 und
  1.0.89 ([E-118](../Intern/BEFUNDE.md#e-118)); die alte Zeile heißt *„Davor von Gregor bestätigt“*. Eigene Zeile, weil
  `pruefe-befundurteile.pl` zeilenweise liest: das [E-115](../Intern/BEFUNDE.md#e-115)-Zitat *„tritt bisher nicht mehr auf“* in
  derselben Zelle hätte [E-121](../Intern/BEFUNDE.md#e-121) als erledigt ausgegeben (der Haken wies ab).
* `WEITERMACHEN.md:123`, *„Stand 14.10.2026 abends – hier weitermachen“*: Schritt (1)
  (Doppelanzeige beheben, 1.0.91 an Gregor) ist erledigt. Nachtrag angefügt; Schritt (2) nennt
  jetzt auch PRÜFER ([L-36.8](#l-36.8)).
* `Releases/PAKETE.md`: 1.0.96 hatte eine Zeile *„Bei Gregor“*, 1.0.90 bis 1.0.95 keine.
  Je eine Zeile *„Gregors Test“* eingesetzt, Inhalt aus `WEITERMACHEN.md:13-18` und den
  Commits `eeff5b26`, `94c4f06b`, `41ad7aa9`.

### <a id="l-36.6"></a>L-36.6 — `WERKZEUGE.md` kannte die neuen Schalter nicht

* `tools/imap-pruefserver.pl:80-81` hat `--ohne-appenduid` (seit `7b95567a`) und
  `--fremde-uid <n>` (seit `9578a1bf`, legt vorab eine fremde Nachricht mit dieser UID ins
  Postfach `Ablage`, `:165-178`; `UID FETCH` nach UID, `:341`). `tools/WERKZEUGE.md:127` nannte
  nur `--ablage`, `--gruss-verzoegerung`, `--append-ablehnen`. Ergänzt.
* `tools/e118-serie.ps1:1` hat `-OhneAppendUid`, `-FremdeUid`, `-ZielBehalten` und die
  Parameter `-Eml`, `-Anzahl`, `-Kennung`, `-Verzeichnis`; `WERKZEUGE.md:128` nannte nur
  `-AppendAblehnen`, `-GrussVerzoegerung`, `-OhneZielFenster`. Ergänzt.
* **`tools/TESTLAEUFE.md`** beschreibt keine Schalter und soll es nicht: es ist das Protokoll
  von `testlauf.ps1` (Kopfzeile). Dort ist nichts nachzutragen.
* `WERKZEUGE.md:3`: *„der Quellstand ist inzwischen 7.2.0.73“* war **inhaltlich falsch**
  (7.2.0.96). Berichtigt; *„zuletzt geprüft gegen 7.2.0.70“* bleibt, denn eine vollständige
  Prüfung aller Zeilen gegen `tools/` war nicht Teil dieses Laufs.

### <a id="l-36.7"></a>L-36.7 — `Testdaten/README.md`: „zuletzt benutzt mit 1.0.72“

`Testdaten/README.md:5` stand *„Zuletzt benutzt wurden sie mit **Paket 1.0.72**“* – die
`e118-*.eml` sind seit dem 14.10.2026 am Prüfstand im Einsatz, zuletzt am 15.10.2026 an
7.2.0.96 (Läufe `k96a` bis `k96d`, siehe [L-36.11](#l-36.11)). Inhaltlich falsch, nicht nur ein
Kopfdatum; berichtigt.

## Offen — mit Ermessen, nicht berichtigt

### <a id="l-36.8"></a>L-36.8 — PRÜFER hat 7.2.0.91 bis 7.2.0.96 nicht gesehen

`perl tools/rollen-faellig.pl`: **PRÜFER fällig** seit `a550a7d` (PRÜFER-29, 7.2.0.90), 7
Dateien, darunter `ImapActionQueue.cpp`, `ImapToc.cpp`, `summary.cpp`. Die sechs Commits
`8008f96e`, `83337910`, `7b95567a`, `3731980c`, `31afea0d`, `9578a1bf` ändern den Weg, auf
dem [E-121](../Intern/BEFUNDE.md#e-121) Daten verlor – darunter `ImapMergeTmpMbx`, das *„beim Abgleich einen Eintrag mit
derselben UID“* entfernt (`BEFUNDE.md:288`, vierter Teil), und das Merkzeichen der Vorab-Kopie.
[PRÜFER-29](PRUEFER-29.md) stellte unter *„Frage: Kollision lokale Kennung ↔ echte IMAP-UID“*
die Klasse, an der 1.0.95 scheiterte, und urteilte *„Folge nur Leck“* – betrachtet war nur
der Schutz der Bilddateien, nicht die Suche nach der Vorab-Kopie, die an 1.0.95 die fremde
Mail traf (kein Verlust, aber ein Weg, den kein PRÜFER gelesen hat). Vor dem PR
`e-118_HTML_header` → `main` den PRÜFER laufen lassen
(`Arbeitsweise/kein-paket-mit-offenem-datenverlust.md`). **CHRONIST** ebenfalls fällig (29 Dateien).

### <a id="l-36.9"></a>L-36.9 — E-121: das Urteil sagt „noch nicht bestätigt“, WEITERMACHEN „bestätigt“

`BEFUNDE.md:288` beginnt *„**DATENVERLUST. Offen, Behebung eingebaut in 7.2.0.90 …, von Gregor
noch nicht bestätigt.**“*; weiter hinten in derselben Zelle steht *„**Sechster Teil, eingebaut in
7.2.0.96 (15.10.2026), bestätigt**“*, und `WEITERMACHEN.md:123` sagt *„der Kern von [E-121](../Intern/BEFUNDE.md#e-121) [ist] von
Gregor bestätigt“*. Das Urteil „offen“ stimmt (N1–N3), der erste Satz aber nicht mehr: er nennt
7.2.0.90 als Stand und verneint eine Bestätigung, die es gibt. Vorschlag für den Anfang:
*„**DATENVERLUST. Offen wegen N1–N3. Kern (7.2.0.90) und Doppelanzeige (Teile 1–6, bis
7.2.0.96) von Gregor an 1.0.96 bestätigt (15.10.2026), nicht veröffentlicht.**“*
`offene-befunde.pl` liest nur das erste Fettwort – mit *„Offen“* darin bleibt der Befund in
der Liste. Außerdem zu prüfen: ob N1 (*„saubere Lösung: eindeutige Nachrichtenkennung“*) durch
das Merkzeichen aus 7.2.0.96 schon teilweise erledigt ist; im Befund steht dazu nichts.
Wortlaut im Befund, deshalb nicht selbst umgeschrieben.

### <a id="l-36.10"></a>L-36.10 — `e118-serie.ps1`: feste Freigabe vom Vortag, fester Repo-Pfad

`tools/e118-serie.ps1:31` übergibt `testlauf.ps1` immer *„Gregor am 14.10.2026: 'ich mache gar
nichts, du testest.' - [E-118](../Intern/BEFUNDE.md#e-118) $Kennung Lauf $i“*. In `tools/TESTLAEUFE.md` stützen sich damit
alle Läufe vom 15.10.2026 (`gp90`, `d92`, `d93`, `d93b`, `k95`, `k96…`) auf eine Freigabe
vom Vortag und heißen *„[E-118](../Intern/BEFUNDE.md#e-118)“*, obwohl sie [E-121](../Intern/BEFUNDE.md#e-121) messen. Ob Gregors Satz vom 14.10. auch für
den 15.10. galt, steht nirgends. Dazu `:3` `$repo = 'C:\Users\Gregor\Documents\github\Eudora7.2'`:
aus einem Arbeitsbaum gestartet, laufen Prüfserver und `testlauf.ps1` aus dem Hauptbaum,
nicht aus dem eigenen (`$PSScriptRoot` wird nur für `messen-e118.ps1` benutzt). Werkzeug
nicht geändert (außerhalb der LEKTOR-Rolle); Vorschlag: `-Freigabe` als Pflichtparameter,
`$repo` aus `$PSScriptRoot\..`.

### <a id="l-36.11"></a>L-36.11 — Messbeleg für 1.0.95/1.0.96 liegt nur uncommittet im Hauptbaum

`Releases/PAKETE.md`, 1.0.96: *„Prüfstand mit `--fremde-uid`: an 1.0.95 Gregors Fehler
nachgestellt, an 1.0.96 grün“*. Die zugehörigen Zeilen `k95`, `k95b`, `k96a` bis `k96d`
(15.10.2026, 13:18 bis 13:28) stehen **nicht** im committeten `tools/TESTLAEUFE.md`, nur als
Änderung im Hauptbaum (`git status`: ` M tools/TESTLAEUFE.md`). Dort fehlt bei `k96b` die
Schliesszeit (Ende nicht gemessen). Ebenfalls uncommittet im Hauptbaum: fünf DLLs unter
`Eudora71/Bin/Release/`. Am 15.10.2026 mussten von 23 committeten Läufen **9** abgeschossen
werden (Fortsetzung von [L-35.9](LEKTOR-35.md#l-35.9)); wo das Beenden hängt, steht weiter nirgends.

### <a id="l-36.12"></a>L-36.12 — TESTPLAN hat keinen Abschnitt für 1.0.90 bis 1.0.96

Vorschlag [L-35.11](LEKTOR-35.md#l-35.11) (C6 für 1.0.90) ist nicht umgesetzt; inzwischen hat Gregor
sieben Pakete geprüft, deren Ergebnisse nur in `BEFUNDE.md`, `WEITERMACHEN.md` und
`Releases/PAKETE.md` stehen. C5 trägt weiter [E-105](../Intern/BEFUNDE.md#e-105) an 1.0.89 als offen – ob Gregor es an einem
der späteren Pakete geprüft hat, steht nirgends. Vorschlag: C6 mit je einer Zeile
[E-118](../Intern/BEFUNDE.md#e-118) Teil 2 (✅ 1.0.90), [E-121](../Intern/BEFUNDE.md#e-121) (✅ 1.0.96), [E-105](../Intern/BEFUNDE.md#e-105) (☐, auf 1.0.96 verschieben).

### <a id="l-36.13"></a>L-36.13 — E-121 und E-122 fehlen in AUFGABEN, E-122 in README

`AUFGABEN.md` nennt [E-121](../Intern/BEFUNDE.md#e-121) und [E-122](../Intern/BEFUNDE.md#e-122) nur in der Kopfzeile (`:3`), in keiner Aufgabenzeile –
die Restfälle N1–N3 haben damit keine Aufgabe. `README.md`, *bekannte Fehler*, führt [E-122](../Intern/BEFUNDE.md#e-122)
(Eingangsdatum im IMAP-Ordner um die Zeitzone verschoben, steckt auch in `v1.0.87`) nicht.
Beides ist eine Einordnung, keine mechanische Berichtigung.

### <a id="l-36.14"></a>L-36.14 — die übrigen Hinweise von `doku-pruefen.pl`

* `tools/ZWEIGE.md` (höchste Fassung vorher 7.2.0.90): nach [L-36.4](#l-36.4) nennt die Zeile 7.2.0.96;
  die übrigen Fassungen sind Geschichte einzelner Zweige, keine Standangabe.
* `tools/pruefdaten/LIESMICH.md` (7.2.0.83): nennt nur, an welcher Fassung die AN-Prüfdaten
  gemessen wurden (`:13`, `:46`); keine Aussage über den heutigen Stand. Nur Kopfdatum-Fall,
  nichts zu ändern.
* `Testdaten/README.md`, `tools/WERKZEUGE.md`: waren inhaltlich falsch, siehe [L-36.6](#l-36.6), [L-36.7](#l-36.7).

### <a id="l-36.15"></a>L-36.15 — was aus LEKTOR-35 geworden ist

[L-35.6](LEKTOR-35.md#l-35.6) erledigt (`Befunde/PRUEFER-27.md` liegt auf dem Zweig, Merge
`a4d9a545`); [L-35.7](LEKTOR-35.md#l-35.7) erledigt (PRÜFER-28, PRÜFER-29), für die Teile danach
wieder offen ([L-36.8](#l-36.8)); [L-35.10](LEKTOR-35.md#l-35.10) erledigt (`ae034b16`); [L-35.12](LEKTOR-35.md#l-35.12) erledigt
(`8481695a`). Offen: [L-35.8](LEKTOR-35.md#l-35.8) (Werkzeug unverändert, trat wieder auf),
[L-35.9](LEKTOR-35.md#l-35.9) (siehe [L-36.11](#l-36.11)), [L-35.11](LEKTOR-35.md#l-35.11) (siehe [L-36.12](#l-36.12)).
