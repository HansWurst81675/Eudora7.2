# <a id="lektor-156"></a>LEKTOR-156 (06.11.2026) — Zweig `e151_pruefstand_klon` nach af53e155: Prüfstand aus dem Klon, „Dauer je Fassung“, Merge von `main`

**Umfang:** der Zweig gegen `origin/main` (`git diff --stat origin/main HEAD`: 422 Dateien, davon die Vorlagen unter `Testdaten/pruefstand/`, die neuen Werkzeuge und `Doku/PRUEFSTAND.md`, `README.md`, `Doku/MITARBEITEN.md`, `Intern/TESTPLAN.md`, `Intern/BEFUNDE.md`, `tools/WERKZEUGE.md`). Dazu der Bestand der MDs auf den Prüfstand hin und der Merge `af53e155`. Der Zweig `wt/lektor-20261106d` steht auf `af53e155`, gleich `origin/e151_pruefstand_klon` (gemessen). Gebaut und gestartet habe ich nichts, unter `C:\Temp` nichts angefasst.

**Urteil:** Die Anleitung ist gut gegliedert. Sie ist ohne Projektwissen lesbar, und alle Meldungen aus der Fehlerbildtabelle gibt es wirklich im Code (gemessen, `grep` über `pruefstand-lauf.ps1` und `pruefserver-aufraeumen.ps1`). Die Tabelle „Dauer je Fassung“ stimmt Zeile für Zeile mit der Git-Geschichte von `Intern/pruefstand-dauer.txt` und den Baukennungen in `tools/TESTLAEUFE.md` (gemessen). Beim Merge von `main` ist nichts verloren gegangen. **Er hat aber sechs neue Fälle in die Fallliste gebracht, für die das Repo keine Vorlage hat.** In einem fremden Klon werden `E-169p/r/b/h/s` (Druckvorschau mit Hintergründen) und `E-239p` (kein Absturz beim Beenden) still übersprungen. Doku, Testplan und Befund sagen dagegen „genau drei übersprungen“. Gregors Testschritt 4 aus `test-e-151` kann so nicht bestehen. Sechs Funde; [L-156.1](#l-156.1) hält den PR auf.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„gepruefte Dateien 58“*, *„Kein Widerspruch gefunden.“*, 23 Hinweise „nennt weder … 7.2.2.136“ (Altbestand, wie in [LEKTOR-155](LEKTOR-155.md#lektor-155)).
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 59“*, *„davon aktuell gemessen 13“*, *„59 offene Befunde, in beiden Listen gleich.“* `git status` danach leer.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“*, weiter *„E-5->[E-6](../Intern/BEFUNDE.md#e-6)/[E-8](../Intern/BEFUNDE.md#e-8) E-6->[E-8](../Intern/BEFUNDE.md#e-8)“* ([L-153.7](LEKTOR-153.md#l-153.7)).
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen“*.
* Zusätzlich `perl tools/pruefe-feste-pfade.pl` (gemessen): *„75 Pruefstand-Skripte, kein fester Benutzerpfad, keine alte Pfadschranke.“*

## Funde aus LEKTOR-155 — heutiger Stand

Alle vier betrafen den Zweig `paket_7_2_2_136`, der inzwischen als #228 auf `main` liegt (`32d5634e`). Dieser Zweig hat sie mit dem Merge übernommen und nichts daran geändert. Das ist erwartet, sie gehören nicht in den E-151-PR.

| Fund | Stand | Stelle (heute) |
|---|---|---|
| [L-155.1](LEKTOR-155.md#l-155.1) [E-239](../Intern/BEFUNDE.md#e-239) „K3 steht aus“ neben „K3 lief grün“ | **offen** | `Intern/BEFUNDE.md:406` *„[K3](../Befunde/PRUEFER-102.md#k3) — steht aus: neu bauen nach dem Commit und `E-239p` am Bau mit Commit-K…“* (gemessen) |
| [L-155.2](LEKTOR-155.md#l-155.2) [E-236](../Intern/BEFUNDE.md#e-236) „Vorschlag, nicht umgesetzt: abschalten oder …“ | **offen** | `Intern/BEFUNDE.md:407` *„Vorschlag, nicht umgesetzt:** den Update-Hinweis abschalten oder auf die GitHub-Release-Seite zeigen lasse…“* (gemessen) |
| [L-155.3](LEKTOR-155.md#l-155.3) Prüfbericht 110/109, unsauberer Baum | **offen** | `Releases/PRUEFBERICHT.md:6` *„**Arbeitsbaum nicht sauber** (4 Dateien)“*, `:16` *„Pruefstand, 110 Faelle“*, `:25` *„Pruefstand (Oberflaeche) \| 109 \| 109 \| 0“* (gemessen) |
| [L-155.4](LEKTOR-155.md#l-155.4) bewusst offen Gelassenes | **offen** | `grep -c E-242 README.md` → 0; `Doku/FAQ.md:513` *„Der Druck auf Papier ist noch nicht gemessen. Seit 7.2.2.136.“*; `tools/testplan-voraussetzungen.pl:33` mit dem Pfad der VM-Freigabe; in `Intern/LEKTORAT.md` fehlen weiter die „Eingearbeitet“-Zeilen zu [LEKTOR-152](LEKTOR-152.md#lektor-152) bis -155 (alles gemessen) |

## Funde

### <a id="l-156.1"></a>L-156.1 — Sechs Fälle aus `main` haben keine Vorlage: im Klon still übersprungen, Doku und Testplan sagen „drei“

**Gewicht: mittel — hält den PR auf.** `tools/pruefstand-faelle.txt` nennt 49 Prüfverzeichnisse, `Testdaten/pruefstand/` hat 46 (gemessen, `comm` der beiden Listen). Ohne Vorlage sind `E169`, `E169B` und `E239`. Sie kamen mit dem Merge von `main` (`af53e155`). Ihre Fälle sind `E-169p`, `E-169r`, `E-169b`, `E-169h`, `E-169s` (`pruefstand-faelle.txt:321-325`) und `E-239p` (`:528`).

`pruefstand-einrichten.ps1:143-145` trägt für ein Verzeichnis ohne Vorlage jeden seiner Fälle als *„keine Vorlage Testdaten\pruefstand\…“* in die Liste des nicht Einrichtbaren ein. `pruefstand-lauf.ps1:138-151` zählt sie im Lauf über den Starter als `[UEBR]` (belegt). In einem frischen Klon ergibt das **neun** übersprungene Fälle statt drei. Ausgerechnet die beiden Behebungen des letzten Releases wären dabei, und der Lauf meldet trotzdem *„ERGEBNIS: alle Faelle bestanden“* (belegt, `pruefstand-starten.ps1:148`, Rückgabe 0 ohne `[FEHL]`).

Die Commit-Nachricht von `af53e155` nennt *„Pruefstand am Bau 7.2.2.136: E-239p gruen, E-169p/r/b/h/s 5/5“*. Laut `Intern/pruefstand-buch.tsv` liefen diese Fälle in `C:\Temp\E169`, `C:\Temp\E169B` und `C:\Temp\E239`, also in den gewachsenen Prüfständen der Entwicklermaschine, nicht aus einer Vorlage (gemessen).

Was dagegen steht:

* `Doku/PRUEFSTAND.md:203` *„Heute der S/MIME-Fall `E-222w` und die beiden Junk-Fälle `E-166a`/`E-166b`.“*; `:193-195` das Beispiel *„Uebersprungen … 3“*.
* `Intern/TESTPLAN.md:45` (Schritt 4 von `test-e-151`): bestanden, wenn *„`Ergebnis: 100 Faelle, 100 bestanden, 0 fehlgeschlagen` und genau drei `[UEBR]` (`E-166a`, `E-166b`, `E-222w`)“*. Es kämen 100 Fälle heraus, aber nur zufällig: 109 minus 9 statt früher 103 minus 3. Dazu kämen **neun** `[UEBR]`. Gregors Schritt wäre rot, ohne dass am Prüfstand etwas kaputt ist (belegt).
* `tools/WERKZEUGE.md:140` *„Nicht Einrichtbares (heute `E-222w`, `E-166a`, `E-166b` …)“*.
* `Intern/BEFUNDE.md:450` ([E-151](../Intern/BEFUNDE.md#e-151)) *„erwartet: alle grün bis auf die übersprungenen“*: der Satz stimmt zwar, aber nur weil die sechs Fälle nicht laufen.

Mit Vorlagen allein ist es nicht getan. `E169B` braucht `e169-schalter.txt` mit `1` im Prüfverzeichnis selbst (`tools/messen-e169.ps1:36` *„-Vorbereiten aus <Pruefstand>\e169-schalter.txt (0 oder 1), sonst 0“*). Der Einrichter kopiert aber nur `Mailverzeichnis` (`pruefstand-einrichten.ps1:178-180`). Ohne die Datei liefen `E-169b`/`E-169h` mit Schalter 0 und wären rot (belegt). Dazu eine Vermutung: *File → Print Preview* braucht unter MFC einen eingerichteten Drucker. Auf einer frischen VM ohne Drucker könnte `E-169p` deshalb scheitern. Gemessen ist das nicht.

Eine Schranke, die zu jedem Verzeichnis der Fallliste eine Vorlage verlangt, gibt es nicht. Deshalb kam der Merge grün durch (gemessen: `pruefe-feste-pfade.pl` grün, Hooks liefen beim Commit).

**Vorschlag:** `pruefstand-vorlage-erfassen.ps1` für `E169`, `E169B` und `E239` laufen lassen. Den Einrichter `e169-schalter.txt` (oder allgemein Dateien neben `Mailverzeichnis`) aus der Vorlage mitnehmen lassen. In `pruefe-feste-pfade.pl` oder einer eigenen Schranke prüfen: jedes Verzeichnis aus `pruefstand-faelle.txt` hat `Testdaten/pruefstand/<Name>/Mailverzeichnis/Eudora.ini`, sonst rot. Gegentest am Stand `af53e155`, wo die Schranke 3 Funde melden muss. Geht das nicht mehr in diesen PR, dann mindestens PRUEFSTAND:203, TESTPLAN:45, WERKZEUGE:140 und [E-151](../Intern/BEFUNDE.md#e-151) auf „neun, davon sechs ohne Vorlage“ berichtigen.

### <a id="l-156.2"></a>L-156.2 — Der Bildserver von E-169 (Port 18169) fehlt im Aufräumen und in der Portliste

**Gewicht: gering bis mittel.** `tools/messen-e169.ps1:100` startet `tools\e169-bildserver.pl` auf Port 18169. `pruefserver-aufraeumen.ps1:36` kennt nur *„'anhang-pruefdaten.pl', 'imap-pruefserver.pl', 'smtp-pruefserver.pl'“*, `:39` nur die Ports *„11110, 1143, 1144, 1025“* (gemessen). Bricht ein Lauf während [E-169](../Intern/BEFUNDE.md#e-169) ab, bleibt der Bildserver stehen. Weder der nächste Start noch das Aufräumen nach dem Lauf beenden ihn (belegt). Erst der nächste E-169-Lauf beendet ihn über seine PID-Datei (`messen-e169.ps1:99`, belegt). Gregor wollte am 05.11.2026 genau das nicht (`Intern/WEITERMACHEN.md:207`: *„beim absturz muß er aufgeräumt werden, so daß nicht bei 3x starten auch 3 mail server im hintergrund laufen“*). Auch `Doku/PRUEFSTAND.md:38` und `:117-119` (freie Ports) nennen 18169 nicht. Heute fällt das im Klon nicht auf, weil [E-169](../Intern/BEFUNDE.md#e-169) dort übersprungen wird ([L-156.1](#l-156.1)). Mit den Vorlagen fiele es auf. **Vorschlag:** `e169-bildserver.pl` in `PruefServerSkripte` und 18169 in `PruefPorts` aufnehmen, die Doku an beiden Stellen nachziehen.

### <a id="l-156.3"></a>L-156.3 — „Dauer je Fassung“: Werte richtig, Spanne und Begleitsätze nicht

**Gewicht: gering.** Alle zehn Zeilen von `Doku/PRUEFSTAND.md:72-81` stimmen mit `git log -- Intern/pruefstand-dauer.txt` überein, zum Beispiel 444 s = 7 min 24 s (`efc9cfd4`), 4852 s = 80 min 52 s (`132ed74e`) und 5476 s = 91 min 16 s (`50cc41f0`). Die Fassungen stimmen mit den Baukennungen in TESTLAEUFE, etwa *„Eudora 7.2.2.133+7818338c“* um 17:5x am 04.11. (alles gemessen). Die Klonprobe-Zeile belegt `Intern/BEFUNDE.md:450` (*„Lauf 76 min 57 s“*). Nicht ganz stimmen:

* `:67-68` *„Die Dauer wächst mit der Zahl der Fälle und der Eudora-Starts, nicht mit der Fassung.“* Die Tabelle widerlegt das selbst: 7.2.2.134 nach 7.2.2.135 sind 102 → 103 Fälle und 64 → 64 Starts, aber 67 min 12 s → 80 min 52 s (gemessen, `:78-79`).
* `:67` *„ältere Läufe ohne eindeutige Fassung fehlen“*: `edbafe7d` (*„Pruefstand und Pruefbericht 7.2.0.123 … 35 Pruefstand“*, 334 s) und `1bd0fe96` (*„Pruefstand 7.2.0.124: 36 Faelle“*, 397 s) nennen die Fassung eindeutig (gemessen). Fehlen dürfen sie, aber nicht mit dieser Begründung.
* `:81` *„Testpaket, Release-Kandidat“* für 7.2.2.136. Seit `81794a92` ist es Release (`tools/RELEASES.md`, letzte Zeile *„v7.2.2.136 … veroeffentlicht“*), die anderen Zeilen schreiben dann „Release“.
* Die Spanne *„60 bis 91 min“* (`:8`, `:17`, `:30`, `:54`, `:91`, `:120`, `README.md:112`) mischt Läufe mit 96 und mit 110 Fällen. Die untere Grenze (59 min 50 s, 96 Fälle) ist für den heutigen Bestand von 109 Fällen kein Messwert mehr. Ehrlicher wäre *„zuletzt 91 min (110 Fälle)“*, so wie es der Starter selbst aus `pruefstand-dauer.txt` liest.
* `Doku/MITARBEITEN.md:101` *„— rund eine Stunde.“* steht gegen „60 bis 91 min“ an allen anderen Stellen.

**Vorschlag:** den Satz `:67-68` streichen oder auf „wächst vor allem mit der Zahl der Fälle“ abschwächen, die Begründung für die fehlenden Läufe berichtigen, 7.2.2.136 als „Release“ führen, die Spanne auf den letzten Lauf stellen.

### <a id="l-156.4"></a>L-156.4 — Für einen Fremden fehlen drei Voraussetzungen

**Gewicht: gering.** Ausgeführt habe ich die Anleitung nicht (Auftrag). Gelesen gegen Starter und Einrichter:

* **Perl nur am festen Ort.** `pruefstand-starten.ps1:69` und die Messskripte (z. B. `messen-e13.ps1:74`, `messen-e169.ps1:93`) erwarten `C:\Program Files\Git\usr\bin\perl.exe`. Wer Git für Windows nur für sich selbst installiert (Ziel `%LOCALAPPDATA%\Programs\Git`), bekommt *„Perl fehlt: … - Git fuer Windows installieren“*, obwohl Git installiert ist (belegt, `:70`). `Doku/PRUEFSTAND.md:110-111` nennt den Pfad nur in Klammern, nicht als Bedingung.
* **Größe des Klons.** `:40` und `:122-124` sagen *„Internet nur beim ersten Lauf (Download des Release-ZIPs)“* und *„rund 9 MB“*. Der größere Download ist das Klonen. Das lokale Repo hat `size-pack: 220.33 MiB` (gemessen). Wie viel ein frischer Klon von GitHub tatsächlich lädt, ist eine Vermutung, wahrscheinlich in dieser Größe.
* **Gegenprobe ohne Anleitung.** `:216-218` *„denselben Fall mit dem unveränderten Stand bauen und fahren“*. Wie man an den unveränderten Stand kommt, steht nicht da: `git stash` oder ein zweiter Klon, dann `-Bau <ordner>`. Der Schalter `-Bau` (`:186`) gäbe es her.

Dazu: `:97` *„Der Prüfstand prüft nicht: Drucken“*. Seit dem Merge prüft er mit [E-169](../Intern/BEFUNDE.md#e-169) die Druckvorschau (nicht das Papier). **Vorschlag:** „Git für Windows im Standardpfad (`C:\Program Files\Git`)“ als Voraussetzung, „Klon rund 200 MB“ in „Voraussetzungen in Kürze“, ein Satz zur Gegenprobe mit `-Bau`, „Druck auf Papier“ statt „Drucken“.

### <a id="l-156.5"></a>L-156.5 — Stand im Zweig: „Wartet auf Merge“ schon gemergt, E-151 „nie gemessen“

**Gewicht: gering.**

* `Intern/WEITERMACHEN.md:10-11` *„**Wartet auf Merge:** `paket_7_2_2_136` … vor dem PR läuft der LEKTOR.“* Der Zweig ist als #228 gemergt (`32d5634e`, gemessen) und hat diese Zeile mitgebracht.
* `CHANGELOG.md:57` und `Intern/WEITERMACHEN.md:129` führen [E-151](../Intern/BEFUNDE.md#e-151) als *„**nie gemessen**“*. Dabei ist [E-151](../Intern/BEFUNDE.md#e-151) *„am laufenden Programm gemessen an einem frischen `git clone`“* (`Intern/BEFUNDE.md:450`, Klonprobe 05.11.2026). Der Zeile fehlt die Marke `**Zuletzt gemessen: … an 7.2.2.135**` (gemessen: `grep -c "Zuletzt gemessen"` über die Zeile → 0), die `offene-befunde.pl:210` liest.
* `tools/pruefstand-einrichten.ps1:42-44` (Kommentar) *„Wurzel ist C:\Temp: … Eine andere Wurzel waere ein eigener Schritt.“* Der Code darunter erlaubt seit Schritt 2 jede Wurzel unter `C:\Temp` (`:59`, `:67`, gemessen). Das ist keine MD, wer den Prüfstand erweitert, liest es aber.

**Vorschlag:** die Zeile in WEITERMACHEN streichen, in [E-151](../Intern/BEFUNDE.md#e-151) die Marke „Zuletzt gemessen: 05.11.2026 an 7.2.2.135“ setzen (dann `offene-befunde.pl --schreiben`), den Kommentar auf die heutige Regel bringen.

### <a id="l-156.6"></a>L-156.6 — Der Merge `af53e155`: nichts verloren

**Gewicht: kein Mangel, zur Nachprüfbarkeit.** Für jede MD-, TXT- und TSV-Datei, die seit dem gemeinsamen Vorfahren `0dfce844` auf einer Seite geändert wurde, habe ich die hinzugefügten Zeilen gegen `HEAD` gelegt (gemessen). Was fehlt, ist absichtlich ersetzt: die alte Spanne *„60 bis 81 Minuten“* und *„gut eine Stunde“* (README, TESTPLAN), die E-151-Zeile von `main` (durch die des Zweigs), `pruefstand-ergebnis.txt` und die Buchzeilen von [E-169](../Intern/BEFUNDE.md#e-169)/[E-239](../Intern/BEFUNDE.md#e-239), die durch spätere Läufe von 13:41 und 13:46 ersetzt sind. `tools/TESTLAEUFE.md`: keine Zeile des Zweigs und keine von `main` fehlt (gemessen, `comm` der sortierten Zeilen → 0 und 0). Die Commit-Nachricht stimmt.

## Hält etwas den PR `e151_pruefstand_klon` → `main` auf?

**Ja, [L-156.1](#l-156.1).** Der Zweck von [E-151](../Intern/BEFUNDE.md#e-151) ist, dass der Prüfstand aus jedem Klon läuft. Nach dem Merge laufen dort aber ausgerechnet die Fälle der beiden letzten Behebungen nicht, und das Ergebnis heißt trotzdem „alle Fälle bestanden“. Gregors Testschritt `test-e-151` Nr. 4 kann mit „genau drei `[UEBR]`“ nicht bestehen. Mindestens Doku, Testplan, WERKZEUGE und [E-151](../Intern/BEFUNDE.md#e-151) müssen das sagen, besser liegen die drei Vorlagen samt `e169-schalter.txt` im PR. [L-156.2](#l-156.2) sollte mit, sobald [E-169](../Intern/BEFUNDE.md#e-169) im Klon wirklich läuft. [L-156.3](#l-156.3) bis [L-156.5](#l-156.5) sind Text und können folgen.

## Was nur Gregor entscheiden kann

Nichts Neues.
