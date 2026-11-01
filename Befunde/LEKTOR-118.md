# <a id="lektor-118"></a>LEKTOR-118 — Bestand vor dem PR, Zweig e184_imap_zusammenfassung (01.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-117](LEKTOR-117.md#lektor-117).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261101h`, Stand `e23da6be`.

## Kurz

Die sechs Funde aus [LEKTOR-117](LEKTOR-117.md#lektor-117) sind erledigt. Beim Rest von [L-117.3](LEKTOR-117.md#l-117.3) (falsches Datum
des ersten Endlos-Ersetzers) habe ich die letzten zwei Stellen selbst berichtigt.
Die Buchführung zu [E-184](../Intern/BEFUNDE.md#e-184) (beim Verschieben im IMAP-Konto wurde die Zusammenfassung
einer fremden Mail mit gleicher Nummer überschrieben) stimmt in der Sache. Der
Befund ist nach Commit-Nachricht, TESTLAEUFE, Prüfstandsdatei, CHANGELOG und
BEFUNDE gemessen: rot an 7.2.1.130, grün mit der Behebung. Die erzeugten Listen
in CHANGELOG und WEITERMACHEN zeigten trotzdem **„nie gemessen“**, weil im
Urteil die Marke fehlte ([L-118.1](#l-118.1)). Alle vier Werkzeuge waren grün.

Neun Funde, keiner am Programm. **Sechs davon habe ich im selben Commit
berichtigt** (Auftrag des Hauptagenten, Lehre vom 27.10.). Drei bleiben stehen:
Der Kopf von `tools/messen-e184.ps1` sagt weiter „Nie gemessen“ ([L-118.5](#l-118.5)); die
Datei ist nicht für mich freigegeben. [E-184](../Intern/BEFUNDE.md#e-184) fehlt unter „Bekannte Fehler“ der
README ([L-118.8](#l-118.8)); das ist eine Inhaltsfrage an den Hauptagenten. Und meine Zählung
aus [L-117.5](LEKTOR-117.md#l-117.5) war falsch ([L-118.9](#l-118.9)); die Zahl in der README stimmt mit diesem
Bericht wieder.

## Funde aus LEKTOR-117

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-117.1](LEKTOR-117.md#l-117.1) TESTPLAN-Kopf nannte als letzten Test den 29.10. | erledigt | `Intern/TESTPLAN.md:1` *„zuletzt getestet am 31.10.2026 das Testpaket 7.2.1.129: [E-139](../Intern/BEFUNDE.md#e-139) bestanden, [E-165](../Intern/BEFUNDE.md#e-165) bestätigt; davor am 29.10.2026 das Release 7…“* |
| [L-117.2](LEKTOR-117.md#l-117.2) ZIEL.md nannte als Stand „Quellstand 7.2.1.128“ | erledigt | `ZIEL.md:191` *„**Stand 01.11.2026.** Quellstand **7.2.1.130** (`VERSION` gleich; Testpaket, geschnürt am 01.11.2026, nicht veröffentlicht …“* |
| [L-117.3](LEKTOR-117.md#l-117.3) Ersetzer mit Selbsttest; Datum des ersten Endlosfalls | **erledigt, Rest von mir** | Werkzeug besteht (`tools/ersetze-text.pl`, in diesem Lauf benutzt: 8 Paare, je 1 Treffer). Datum berichtigt vom CHRONIST in `Arbeitsweise/CHRONIST-2026-11-01b.md:34` (*„Fall 38 am 29.10. (hier stand bis zum 01.11. abends „30.10.“ …)“*). Offen waren noch `tools/WERKZEUGE.md:20` und `tools/ersetze-text.pl:27` (*„30.10. und 01.11.2026“*): **beide berichtigt im selben Commit** ([L-118.6](#l-118.6)) |
| [L-117.4](LEKTOR-117.md#l-117.4) PAKETE-Kopf „Nummern bis 7.2.1.128“ | erledigt | `Releases/PAKETE.md:6` *„Nummern bis 7.2.1.130 verzeichnet“* |
| [L-117.5](LEKTOR-117.md#l-117.5) README zählte 112 Prüfberichte, 109 Lehren | erledigt; **meine Zählung damals falsch** | `README.md:98` *„189 LEKTOR- und PRÜFER-Berichte“*, `:99` *„124 Lehren“*. Siehe [L-118.9](#l-118.9) |
| [L-117.6](LEKTOR-117.md#l-117.6) AUFGABEN „Nummer 7.2.1.130 vergeben“ | erledigt | `Intern/AUFGABEN.md:8` *„Am 01.11.2026 Testpaket 7.2.1.130 geschnürt (wie 7.2.1.129 nicht veröffentlicht)“* |

Die „Zur Kenntnis“ aus [LEKTOR-117](LEKTOR-117.md#lektor-117) ist erledigt (gemessen):
`Arbeitsweise/stand-01-11-2026.md:45` lautet jetzt *„Prüfstandslauf (Nachtrag:
gefahren 15:35-15:44, 46/46, siehe unten)“*.

## Was seit 29c0d443 dazukam

Gelesen habe ich `git log --stat 29c0d443..HEAD`: fünf Commits, darunter ein
Merge von `main` (#196). Dazu alle geänderten Zeilen außerhalb von `Eudora71/`
und den Quelltext-Diff zu [E-184](../Intern/BEFUNDE.md#e-184) (`ImapToc.cpp`, `tocdoc.cpp`, `summary.h/.cpp`,
`tocdoc.h`), aber nur, um die Doku daran zu halten. Den Code beurteilt der PRÜFER.

| Angabe | Stellen | Ergebnis |
|---|---|---|
| Ursache: Vorab-Kopie aus `CTocDoc::Xfer` mit alter UID, PRÜFER-71-Annahme widerlegt | `Intern/BEFUNDE.md:399` (Absatz „Ursache, gemessen …“, durchgestrichener Satz mit *„Widerlegt am 01.11.2026“*); Commit `e23da6be` | stimmt mit dem Code: `tocdoc.cpp:3008` *„CopySum->SetE184Vorab(TRUE);“* unter `IsImapToc() && TargetToc->IsImapToc()`, `ImapToc.cpp:1584` *„pSumNew = E184FindeVorabKopie(pTargetToc, lOldUID);“* (gemessen) |
| „Die beiden anderen Aufrufer rufen ohne `bFindNew`“ | `Intern/BEFUNDE.md:399` | `ImapToc.cpp:2750` *„ImapTransferSummaryData(sUidlist, pTargetToc, &dwaNewUIDs);“*, `:3056` mit vier Argumenten, keines davon `bFindNew` (gemessen). Die Zeilennummern im Befund waren alt: [L-118.2](#l-118.2) |
| rot an 7.2.1.130, grün mit Behebung „zweimal“ | `Intern/BEFUNDE.md:399`; `CHANGELOG.md:110`; Commits `4593ab89`, `e23da6be` | `tools/TESTLAEUFE.md`: vier Starts mit Bau `955d50d4*` (17:26, 17:31, 17:33, 17:43) und drei mit `4593ab89*` (17:41, 17:45, 17:46), gemessen. Laut Commit-Nachricht zeigte ein Lauf mit Behebung `kopie=0`, weil der Prüfserver noch kein `EXISTS` meldete; zwei grüne bleiben (belegt an der Commit-Nachricht, Protokolle unter `C:\Temp\E184` nicht gelesen) |
| Tests 355/355, 0 Fehler | `CHANGELOG.md:108`; Commit `e23da6be` | 355 wie bei 7.2.1.130 (`Releases/PAKETE.md:192`): ein Unit-Test zu [E-184](../Intern/BEFUNDE.md#e-184) ist nicht dazugekommen, als Regressionstest dient der Prüfstandsfall (belegt). `pruefe-regressionstest.pl` meldet nichts |
| Prüfstandsfall [`E-184`](../Intern/BEFUNDE.md#e-184) | `tools/pruefstand-faelle.txt` (neuer Block nach [`E-146`](../Intern/BEFUNDE.md#e-146)) | erwartet *„E184 ERGEBNIS fremd=1 kopie=1 eintraege=2“*, Skript `tools\messen-e184.ps1`, Zeitschranke 20 s, Skript wartet `$Warten = 15` (gemessen). Die Zahl 46 in PAKETE/PRUEFBERICHT gehört zu 7.2.1.130 und bleibt richtig |
| Prüfserver `UID COPY`, `COPYUID`, `--ohne-copyuid`, `* n EXISTS` | `tools/imap-pruefserver.pl` (Diff); `tools/WERKZEUGE.md:179`; `CHANGELOG.md:111` | COPY und `--ohne-copyuid` standen in WERKZEUGE, `EXISTS` nicht: [L-118.4](#l-118.4) |
| CHANGELOG „Im Quellstand, noch in keinem Paket“ | `CHANGELOG.md:106-113` | in der Sache wie BEFUNDE und Commit (gemessen). `doku-pruefen.pl` meldet keinen Widerspruch |
| ZWEIGE-Zeile | `tools/ZWEIGE.md:204` | Plan des Zweigs, kein Stand. Stimmt |

## Funde

### <a id="l-118.1"></a>L-118.1 — E-184 steht in den erzeugten Listen als „nie gemessen“

**Gewicht: mittel.** Die Spalte „zuletzt gemessen“ soll zeigen, wie glaubwürdig
ein Urteil ist. Hier stand bei einem gemessenen Befund das Gegenteil. (gemessen)

**Berichtigt im selben Commit:** In `Intern/BEFUNDE.md:399` steht hinter
*„Original von QUALCOMM, keine Regression.**“* jetzt *„**Zuletzt gemessen:
01.11.2026 an 7.2.1.130** (rot am Paketbau `955d50d4`; grün am Quellstand mit
der Behebung, Bau `4593ab89*`)“*. Danach habe ich `perl tools/offene-befunde.pl
-schreiben` laufen lassen: `CHANGELOG.md:30` und `Intern/WEITERMACHEN.md:78`
zeigen jetzt *„01.11.2026 an 7.2.1.130“*. Die Zählung ging von *„aktuell
gemessen 2 … NIE gemessen 14“* auf *„3 … 13“*.

Vorher: `CHANGELOG.md:30` und `Intern/WEITERMACHEN.md:78` *„**nie gemessen**“*,
obwohl der Urteilskopf *„am Prüfstand gemessen: rot an 7.2.1.130, grün mit der
Behebung“* sagte. `offene-befunde.pl` zählt mit Absicht nur die ausdrückliche
Marke `**Zuletzt gemessen: <Datum> an <Fassung>**` (`tools/offene-befunde.pl:200-214`).
Die fehlte.

### <a id="l-118.2"></a>L-118.2 — E-184 nennt für die zwei anderen Aufrufer die Zeilen vor der Behebung

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** `Intern/BEFUNDE.md:399` *„(`ImapToc.cpp:2750`, `:3056`; vor der Behebung `:2728`, `:3034`)“*.

Die Behebung fügt in `ImapToc.cpp` 22 Zeilen vor den beiden Aufrufen ein. Im
Befund stand weiter *„`ImapToc.cpp:2728`, `:3034`“*. Gemessen:
`git show 29c0d443:…ImapToc.cpp` → 2728 und 3034, heute → 2750 und 3056.
`:1538ff` für die Funktion selbst stimmt weiter (`ImapToc.cpp:1538`).

### <a id="l-118.3"></a>L-118.3 — Der „Kurz“-Satz zu E-184 erklärte noch die widerlegte Ursache

**Gewicht: Kleinkram.** Der „Kurz“-Satz ist das, was Gregor liest. (gemessen)

**Berichtigt im selben Commit:** *„und es sucht seine eigene Vorab-Kopie im Ziel unter der ALTEN Nummer — die Nummern gelten aber je Ordner“*.

Vorher stand dort *„und es sucht die vorhandene Zusammenfassung im Ziel unter
der ALTEN Nummer“*. Das legte nahe, die Suche unter der alten Nummer sei der
Fehler. Derselbe Eintrag sagt aber, die Suche *„war also gewollt, sie sollte
diese Kopie finden“*, und streicht den Satz, der das Gegenteil annahm.

### <a id="l-118.4"></a>L-118.4 — WERKZEUGE: Prüfserver ohne `EXISTS`, `messen-e184.ps1` ohne das grüne Ergebnis

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** `tools/WERKZEUGE.md:179` ergänzt um *„Dazu
meldet er wie ein echter Server eine geänderte Nachrichtenzahl im gewählten
Postfach unaufgefordert mit `* n EXISTS` (RFC 3501 7.3.1) — ohne das erfuhr
Eudora beim Abgleich des Ziels nie von der neuen UID“*; `:139` ergänzt um *„mit
der Behebung (01.11.2026, Quellstand) `fremd=1 kopie=1 eintraege=2`“*.

`e23da6be` hat dem Prüfserver die unaufgeforderte `* n EXISTS`-Meldung
beigebracht (Diff von `tools/imap-pruefserver.pl`, Block *„[E-184](../Intern/BEFUNDE.md#e-184): wie ein echter
Server (RFC 3501 7.3.1)“*). Nach `CHANGELOG.md:111` ist sie die Bedingung für
einen grünen Lauf. In der Werkzeugliste stand nur COPY.

**Nicht berichtigt** (keine `.md`, nicht freigegeben): Der Kopfkommentar von
`tools/imap-pruefserver.pl` beschreibt COPY (*„COPY / UID COPY (seit
01.11.2026, Befund [E-184](../Intern/BEFUNDE.md#e-184))“*), nennt `EXISTS` aber nur im Code-Block, nicht im Kopf.

### <a id="l-118.5"></a>L-118.5 — Kopf von `tools/messen-e184.ps1`: „Nie gemessen“, Begründung aus der widerlegten Annahme

**Gewicht: Kleinkram.** (gemessen) **Nicht berichtigt**, weil kein `.md` und nicht freigegeben.

`tools/messen-e184.ps1:7-12`: *„WARUM ES DAS GIBT. [PRUEFER-71](PRUEFER-71.md#pruefer-71) fand am
Quelltext: … sucht … die Zusammenfassung im ZIELordner unter der ALTEN UID …
traegt eine fremde Mail im Ziel dieselbe Nummer, wird ihr Eintrag mit den Daten
der verschobenen ueberschrieben. Nie gemessen.“* Das Skript hat den Befund
inzwischen gemessen. Die Ursache steht heute anders da: die Vorab-Kopie aus
`CTocDoc::Xfer` mit der alten UID, die Suche fand zuerst die fremde Mail
(`Intern/BEFUNDE.md:399`).

**Vorschlag:** „Nie gemessen.“ ersetzen durch „Gemessen am 01.11.2026: rot an
7.2.1.130 (fremd=0), grün mit der Behebung. Ursache anders als [PRUEFER-71](PRUEFER-71.md#pruefer-71)
annahm, siehe [E-184](../Intern/BEFUNDE.md#e-184) in Intern/BEFUNDE.md.“ (reines ASCII).

### <a id="l-118.6"></a>L-118.6 — Datum des ersten Endlos-Ersetzers in WERKZEUGE und im Skriptkopf

**Gewicht: Kleinkram.** Bekannt seit [L-117.3](LEKTOR-117.md#l-117.3) und dem CHRONIST-Bericht vom 01.11. abends. (gemessen)

**Berichtigt im selben Commit** (vom Hauptagenten freigegeben):
`tools/WERKZEUGE.md:20` *„(29.10. und 01.11.2026, [Fälle 38 und 40] …“*,
`tools/ersetze-text.pl:27` *„weitersuchte (29.10. und“*. Der Skriptkopf bleibt
reines ASCII (gemessen nach dem Schreiben: `>127 0`, `nur-LF 212` wie vorher).

Beleg für den 29.10.: `Arbeitsweise/text-nicht-durch-schichten-schicken.md:546`
*„| 38 | 29.10. 21:55:39 |“*.

### <a id="l-118.7"></a>L-118.7 — WEITERMACHEN-Kopf: die Behebung von E-184 fehlte

**Gewicht: Kleinkram.** (gemessen)

**Berichtigt im selben Commit:** Hinter *„erzeugte Stufentabelle.“* in
`Intern/WEITERMACHEN.md:3` steht jetzt *„Seit dem Merge von #196 im Quellstand,
noch in keinem Paket: die Behebung von [E-184](../Intern/BEFUNDE.md#e-184), der Befund bleibt bis zum Paket
offen (Zweig `e184_imap_zusammenfassung`; am Prüfstand rot an 7.2.1.130, grün
mit der Behebung).“* (Das Wort „behoben“ weist `pruefe-befundurteile.pl` zu
Recht ab, solange BEFUNDE den Befund offen führt.)

Der Kopf nannte zu [E-184](../Intern/BEFUNDE.md#e-184) nur *„[[E-184](../Intern/BEFUNDE.md#e-184)] neu“* im Absatz zu 7.2.1.130. Die
Behebung stand in CHANGELOG (`:106-113`) und BEFUNDE, im Einstieg nach einem
Neustart aber nicht.

### <a id="l-118.8"></a>L-118.8 — README: E-184 fehlt unter „Bekannte Fehler“

**Gewicht: mittel.** Der Fehler steckt im veröffentlichten Release 7.2.1.128
und im Testpaket 7.2.1.130. (gemessen: `grep -c E-184 README.md` → 0) **Nicht
berichtigt**, weil das eine neue Tabellenzeile mit Inhalt wäre, keine kurze
Berichtigung.

Was der Anwender sieht, steht im Befund (`Intern/BEFUNDE.md:399`): Nach dem
Verschieben im IMAP-Konto trägt eine fremde Mail im Zielordner Betreff und
Absender der verschobenen. Auf dem Server geht nichts verloren. Stufe
*wichtig*. Der verwandte Fall [E-170](../Intern/BEFUNDE.md#e-170) (Label geht beim Verschieben im Konto verloren)
steht in der README (`README.md:166`). Eine Regel, dass jeder offene
*wichtige* Befund dort steht, gibt es nicht: [E-176](../Intern/BEFUNDE.md#e-176) (Lesen aus freigegebenem
Speicher beim Schließen einer verworfenen Nachricht, *wichtig*) fehlt dort
ebenfalls (gemessen).

**Vorschlag:** eine Zeile neben [E-170](../Intern/BEFUNDE.md#e-170). Was passiert: „Nach dem Verschieben
zwischen Ordnern desselben IMAP-Kontos zeigt eine andere Mail im Zielordner
Betreff und Absender der verschobenen – nur, wenn der Server die neuen Nummern
meldet (UIDPLUS) und dort zufällig eine Mail mit derselben Nummer liegt“. Was
verloren gehen kann: „nichts auf dem Server; die Anzeige der fremden Mail ist
falsch“. Was hilft: „Ordner neu vom Server laden; im Quellstand behoben“.

### <a id="l-118.9"></a>L-118.9 — Meine Zählung in L-117.5 war falsch; die README-Zahl stimmt jetzt zufällig

**Gewicht: Kleinkram, eigener Fehler.** (gemessen)

In [L-117.5](LEKTOR-117.md#l-117.5) schrieb ich *„`LEKTOR-<n>` 117 und `PRUEFER-<n>` 72“*. Die
Nummern beginnen aber bei [`LEKTOR-2`](LEKTOR-2.md#lektor-2) und `PRUEFER-3`, ohne Lücken bis 117 bzw.
74. Am Stand `e23da6be` gibt es also 116 LEKTOR- und 72 PRÜFER-Berichte, zusammen
188 (gemessen: `git ls-files Befunde | grep -cE '/LEKTOR-[0-9]+\.md$'` → 116,
für PRÜFER → 72). Als ich zählte, existierten [LEKTOR-117](LEKTOR-117.md#lektor-117) und PRÜFER-74 noch
nicht; die README-Zahl 189 war damals um drei zu hoch. Mit diesem Bericht
([LEKTOR-118](#lektor-118)) sind es 189: `README.md:98` stimmt, aber nur zufällig. **Nicht
geändert.** Die 124 Lehren stimmen weiter (gemessen).

**Vorschlag** (wie schon in [L-117.5](LEKTOR-117.md#l-117.5)): die Zahl streichen oder aus einem Werkzeug
erzeugen.

## Zur Kenntnis, außerhalb des Prüfumfangs (`Arbeitsweise/`)

- `Arbeitsweise/stand-01-11-2026.md:3` (und die Zeile dazu in
  `Arbeitsweise/README.md`): *„neuer Zweig e184_imap_zusammenfassung
  (Pruefserver COPY, dann Messung)“*. Der letzte Absatz (`:47`) endet beim
  Anlegen des Zweigs. Nachstellung (`4593ab89`) und Behebung (`e23da6be`)
  stehen dort nicht (gemessen). Wer nach einem Neustart zuerst diese Notiz
  liest, würde [E-184](../Intern/BEFUNDE.md#e-184) noch nachstellen wollen.
- [CHRONIST-2026-11-01c](../Arbeitsweise/CHRONIST-2026-11-01c.md) stimmt in den Stellen, die ich nachgeprüft
  habe. Die Commits auf `e184_imap_zusammenfassung` bis 17:18 sind zwei
  (`6bff482a`, `5b01a898`), gemessen mit `git log`. Die Rückmeldung zu
  [L-117.3](LEKTOR-117.md#l-117.3) nennt dieselben zwei Stellen, die ich jetzt berichtigt habe ([L-118.6](#l-118.6)).
- Der Nachtrag in `Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md`
  (17:23, `Eudora.exe --version`) passt zur Zeile in `tools/TESTLAEUFE.md` vom
  01.11.2026 17:23 (*„ohne Freigabe-Werkzeug, versehentlich“*), gemessen.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen, vor und nach den Berichtigungen):

```
  Paketnummer                  7.2.1.130
  gepruefte Dateien            50
  Kein Widerspruch gefunden.
```

„Zur Kenntnis“: dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-117](LEKTOR-117.md#lektor-117), alle
alt oder zum Nachschlagen (`Doku/ANWENDER.md`, `Intern/PORTIERUNG.md` bis
7.2.1.128, Release-Notizen älterer Fassungen).

`perl tools/offene-befunde.pl` (gemessen), vorher:

```
    offen laut Intern/BEFUNDE.md  44
      davon aktuell gemessen       2  (ab Nummer 125)
      davon veraltet gemessen     28
      davon NIE gemessen          14
    in Intern/WEITERMACHEN.md     44
  44 offene Befunde, in beiden Listen gleich.
```

Nachher (nach [L-118.1](#l-118.1), mit `-schreiben`): *„aktuell gemessen 3 … NIE gemessen 13“*,
44 in beiden Listen. Das Werkzeug sah [L-118.1](#l-118.1) nicht als Mangel. Es meldet eine
Marke nur, wenn sie angefangen und falsch geschrieben ist; eine ganz fehlende
Marke meldet es nicht.

`perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne
Regressionstest.“* [E-184](../Intern/BEFUNDE.md#e-184) ist „offen“ (Behebung im Quellstand), also nicht
betroffen.

`perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

Nichts Neues.
