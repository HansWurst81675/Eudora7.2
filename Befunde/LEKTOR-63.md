# <a id="lektor-63"></a>LEKTOR-63 — Kurzlauf „keine Lügen auf main": Commits seit 900a2312, 25.10.2026

**Auftrag.** Gregor fragte: *„was ist aus 'keine luegen auf main' geworden?"*
Geprüft sind nur die Commits `900a2312..35051ed8` auf `RC1_vorbereiten`:
`e6c23c93` (Entscheidungen in `WEITERMACHEN.md`), `da0590b2` (TESTPLAN M1,
[E-132](../Intern/BEFUNDE.md#e-132)), `9a4cc0e1` (E-100-INI nach dem Beenden), `414c456f` (CHANGELOG-Kopf,
Stand-Köpfe, Testzahl), `35051ed8` (Prüfbericht neu). Dazu gezielt im
ganzen Bestand: E-132-Schritt 5, „ohne Paket", „277 Tests",
„7.2.0.123 veröffentlichen".

**Ergebnis vorweg.** Die Berichtigungen des Zweigs stimmen in jeder
geprüften Angabe — der neue TESTPLAN-Text zu [E-132](../Intern/BEFUNDE.md#e-132) deckt sich Zeile für
Zeile mit `eudora.cpp`, die PR-Nummern im CHANGELOG stimmen, kein Stand-Kopf
behauptet etwas Falsches. **Falsch ist genau eine Aussage, und zwar eine,
die der Zweig selbst überholt hat:** der neue Block in `WEITERMACHEN.md`
nennt die E-100-INI-Messung noch als blind und als ersten nächsten Schritt,
obwohl `9a4cc0e1` sie eine halbe Stunde später behoben hat
([L-63.1](#l-63.1)). **6 Funde: 1 falsch, 2 ungenau, 3 Hinweise.** Keine
neue Frage an Gregor.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

## Was geprüft wurde und stimmt

- **TESTPLAN M1, [E-132](../Intern/BEFUNDE.md#e-132)** (belegt, `Eudora71/Eudora/eudora.cpp`): Dialog
  `MB_YESNOCANCEL | MB_ICONWARNING | MB_DEFBUTTON2` (`:4231`) — also Knöpfe
  Yes/No/Cancel, **No** vorgewählt, wie `Intern/TESTPLAN.md:550-551`. Text
  *„Eudora found an existing mail folder that belongs to another
  installation"* (`:4215-4216`) = Schritt 1. Cancel wird nicht gemerkt und
  endet (`:4234-4236`, `:4252-4256`) = Schritt 3. No schreibt
  `E132Abgelehnt=<Verzeichnis>` (`:4239-4242`) in die `DEudora.ini`
  (`:4180`); Spur `fremd=%d` (`:4171`) und `eigenes gewaehlt=` (`:4350`) =
  Schritt 4. Der nächste Start liest den Merker (`:4190-4194`) und schreibt
  `gemerkte Antwort Nein` (`:4205-4206`), fragt also nicht mehr — die
  Begründung für das Ende nach Schritt 4 (`TESTPLAN.md:555`) stimmt.
  „Den früheren Schritt 5 gibt es **so** nicht" ist richtig eingeschränkt:
  der Dialog selbst nennt den Weg zurück (Zeile in `DEudora.ini` löschen,
  `:4222-4224`).
- **Keine alten Knopfbeschriftungen mehr in der Doku** (gemessen,
  `grep -rn "Vorhandenes benutzen\|Eigenes anlegen"` über alle `.md`
  außer `Befunde/` und `Arbeitsweise/`): kein Treffer. Nur der
  Quelltextkommentar `eudora.cpp:4084` sagt noch *„Eigenes anlegen"
  (MB_DEFBUTTON2)* — ein Kommentar, keine Aussage an den Anwender.
- **CHANGELOG-Kopf „Seit 7.2.0.122"** (gemessen, `git log --merges --oneline
  origin/main`): #157 = `df4f0ac1` `e-116-bildbreite-px`, gemergt
  2026-10-23 23:10; #174 = `d28929ea` `agenten-befunde-25-10b`, gemergt
  2026-10-25 19:04. In #174 stecken `1e85186c` ([E-150](../Intern/BEFUNDE.md#e-150) behoben) und
  `9a4a4f90` (Regressionstests [E-51](../Intern/BEFUNDE.md#e-51), [E-97](../Intern/BEFUNDE.md#e-97), [E-100](../Intern/BEFUNDE.md#e-100), [E-99](../Intern/BEFUNDE.md#e-99), [E-67](../Intern/BEFUNDE.md#e-67)) — so nennt es
  auch `WEITERMACHEN.md:132`. [E-148](../Intern/BEFUNDE.md#e-148) kam mit #171 (`492878c6`).
- **„301 Tests, 301 bestanden"** (belegt, `Releases/PRUEFBERICHT.md`
  Abschnitt 1, *„Alle 301 Unit-Tests einzeln"*). Die TESTPLAN-Angabe
  „auf `796369bb`" (`TESTPLAN.md:251`) ist haltbar, obwohl die Unit-Tests
  gegen `414c456f*` liefen: zwischen `796369bb` und `414c456f` ist unter
  `Eudora71/` nichts geändert (gemessen, `git diff --stat`).
- **Stand-Köpfe** (gemessen, `perl tools/pruefe-stand-md.pl`: *„Kein
  Stand-Kopf hinkt hinterher"*; gelesen): `AUFGABEN.md:3`,
  `TESTPLAN.md:1`, `WEITERMACHEN.md:3`, `PAKETE.md:6`,
  `DEFENDER-FEHLALARM.md:3` behaupten nichts Falsches; `TESTBERICHT-E125.md`
  erklärt sich als abgeschlossen und verweist weiter.
- **„7.2.0.123 ist nur Testpaket, veröffentlicht wird 7.2.1.\<n\>"**
  (`WEITERMACHEN.md:134`, `CHANGELOG.md:98-105`) deckt sich mit
  `ZIEL.md:38-40` und `ZIEL.md:81` (belegt).
- **„277 Tests"** (gemessen, `grep -rn`): alle verbliebenen Stellen
  (`CHANGELOG.md:177,220`, `README.md:99`, `AUFGABEN.md:3`,
  `WEITERMACHEN.md:9`, `PAKETE.md:164`) beziehen sich ausdrücklich auf
  Paket 1.0.122 / [E-125](../Intern/BEFUNDE.md#e-125) — für diesen Stand richtig.
- **„ohne Paket"** (gemessen): außerhalb `Befunde/` und `Arbeitsweise/`
  kein Treffer mehr.
- **PRUEFBERICHT, [E-100](../Intern/BEFUNDE.md#e-100)** (belegt): Zeile `ok | 2026-10-25 19:09:48`, Bau
  `1.0.122+796369bb`; die Messung ist das geänderte `tools/messen-e97.ps1`
  aus `9a4cc0e1`, das Eudora erst beendet und dann liest (`:261-280`). Der
  Kopf nennt ehrlich *„Arbeitsbaum nicht sauber (2 Dateien)"* und
  `414c456f*`.
- **Mechanisch** (gemessen): `perl tools/doku-pruefen.pl` — *„Kein
  Widerspruch gefunden."*; `perl tools/pruefe-tabellenzeilen.pl` — *„313
  Dateien, keine gebrochene Tabellenzeile."*

## <a id="l-63.1"></a>L-63.1 — falsch: `WEITERMACHEN.md` nennt die E-100-INI-Messung noch blind

`Intern/WEITERMACHEN.md:140` (aus `e6c23c93`, 19:06):

> *„**Reihenfolge:** zuerst PRÜFER-53 K4 (der Prüfbericht führt den
> INI-Teil von [E-100](../Intern/BEFUNDE.md#e-100) als geprüft, gelesen wird aber vor dem Schreiben), dann
> 2.–4. …"*

Seit `9a4cc0e1` (19:10) stimmt der Klammersatz nicht mehr: `messen-e97.ps1`
schickt `WM_CLOSE`, wartet auf das Prozessende und liest erst dann
(`tools/messen-e97.ps1:261-280`, belegt); der Prüfbericht trägt den neuen
Lauf um 19:09:48 (`Releases/PRUEFBERICHT.md`, Zeile [E-100](../Intern/BEFUNDE.md#e-100), belegt). Der
Commit `414c456f` hat in `WEITERMACHEN.md` nur den Stand-Kopf angefasst
(gemessen, `git show 414c456f -- Intern/WEITERMACHEN.md`). Wer dort
einsteigt, fängt mit einer erledigten Arbeit an.

**Berichtigung:** K4 als erledigt markieren (*„erledigt mit `9a4cc0e1`,
Prüfbericht 19:09:48"*), Reihenfolge beginnt mit 2.

## <a id="l-63.2"></a>L-63.2 — ungenau: der E-150-Eintrag im CHANGELOG sagt mehr, als gemessen ist

`CHANGELOG.md:107-113`: *„wurde eine Spalte dahinter gelöscht, **schrieb
Eudora** 4 Byte hinter das Feld (**Original von QUALCOMM**, …)"*. Der Befund
selbst sagt vorsichtiger: *„am Ausschnitt gemessen …, **im laufenden
Programm nicht nachgestellt; Quelltext original von QUALCOMM, Verhalten am
Original nicht gemessen**"* (`Intern/BEFUNDE.md:381`, belegt). Die
Herleitung aus dem Quelltext ist belegt; dass Eudora es *tat*, ist nicht
beobachtet. Nach der Lehre `original-ist-eine-messung` ist „Original von
QUALCOMM" eine Aussage über Verhalten.

**Berichtigung:** *„… schreibt Eudora nach dem Quelltext 4 Byte hinter das
Feld (Quelltext von QUALCOMM; im laufenden Programm nicht nachgestellt) …"*.

## <a id="l-63.3"></a>L-63.3 — ungenau: „Behoben ab 7.2.0.123" verspricht der Öffentlichkeit eine Fassung, die es nie zum Herunterladen gibt

`README.md:147` (*„**Behoben ab 7.2.0.123**"*), `:232` (*„Was behoben ist
(ab 7.2.0.123)"*), `:239`. Seit Gregors Entscheidung ist 7.2.0.123 nur ein
Testpaket (`ZIEL.md:38-40`, `WEITERMACHEN.md:134`, belegt). Technisch
steckt die Behebung in diesem Bau — nicht falsch —, aber ein Leser der
öffentlichen README sucht eine Fassung 7.2.0.123 vergeblich.

**Berichtigung:** *„Behoben ab dem Release 7.2.1.\<n\> (auf `main` seit
PR #171)"*.

## <a id="l-63.4"></a>L-63.4 — Hinweis: `ini=ok` auch, wenn keiner der beiden Schlüssel in der INI steht

`tools/messen-e97.ps1:271-276` (belegt): `$iniOk = 'ok'` wird gesetzt, und
nur eine Zeile `IncludeHeaders=`/`GuessParagraphs=` mit einem Wert außer
0/1 macht daraus `falsch`. Fehlen beide Zeilen, meldet das Skript `ok`.
**Vermutung:** schreibt Eudora beim Beenden einen Wert, der der Vorgabe
gleicht, nicht in die Datei, dann misst „ini=ok" in diesem Fall nichts
(Lehre `ausbleiben-ist-kein-befund`). Für den PRÜFER: verlangen, dass
mindestens eine der beiden Zeilen gefunden wurde, sonst `ungemessen`.

## <a id="l-63.5"></a>L-63.5 — Hinweis: Entscheidungsnotiz zu E-148 trägt oben noch die überholte Fassung

`Arbeitsweise/entscheidung-e148-release-7-2-0-123.md:15` (*„Offen bleibt
die Tag-Frage `v7.2.1.<n>` oder `v1.0.<n>`"*) und `:17` (*„wird beim
Veroeffentlichen von 7.2.0.123 erledigt"*). Beides ist durch den Nachtrag
`:19` in derselben Datei und durch `ZIEL.md:81` (Marke `v7.2.1.<n>`)
überholt. Nicht falsch, weil die Datei sich selbst berichtigt — aber wer
nur `How to apply` liest, handelt nach der alten Fassung. Spiegel des
Gedächtnisses; zu berichtigen ist die Quelle beim Hauptagenten.

## <a id="l-63.6"></a>L-63.6 — Hinweis: unter dem neuen Kopf „Stand 25.10.2026" steht die Quellstand-Zeile vom 23.10.

`Intern/WEITERMACHEN.md:9`: *„Quellstand 7.2.0.122 …, Zweig
`e-14-gemessen-und-rollen` — [E-125](../Intern/BEFUNDE.md#e-125) …"*. Für den Quellstand richtig, aber
die Zeile schweigt über alles, was seither auf `main` liegt ([E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113),
[E-116](../Intern/BEFUNDE.md#e-116), [E-119](../Intern/BEFUNDE.md#e-119), [E-130](../Intern/BEFUNDE.md#e-130), [E-148](../Intern/BEFUNDE.md#e-148), [E-150](../Intern/BEFUNDE.md#e-150)), während `AUFGABEN.md:3` es nennt
(belegt). Unvollständig, nicht falsch.

## Antwort auf die Frage „steht auf main noch etwas nachweislich Falsches?"

Nach diesem Zweig: **eine Stelle** — `WEITERMACHEN.md:140`
([L-63.1](#l-63.1)), vom Zweig selbst überholt. Gesucht wurde nach
E-132-Schritt 5, „ohne Paket", „277 Tests" und „7.2.0.123
veröffentlichen"; dort ist nichts mehr falsch. Ungenau bleiben der
E-150-Wortlaut im CHANGELOG ([L-63.2](#l-63.2)) und „ab 7.2.0.123" in der
README ([L-63.3](#l-63.3)).
