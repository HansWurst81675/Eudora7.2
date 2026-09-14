# LEKTOR-8 — L-13, der Stand auf 7.2.0.53 / 1.0.53

Gemessen an Quellstand **7.2.0.53** / Paket **1.0.53**, am **14.09.2026**,
Zweig `wt/lektor`. Umfang: **133 MD-Dateien** (`git ls-files "*.md"`), dazu
alle **88** Werkzeuge in `tools/`.

> **L-13 in einem Satz:** Drei Fassungen in vierundzwanzig Stunden haben die
> Dokumentation an neun Stellen stehenlassen — und zwei davon sagten das
> **Gegenteil** des Bestands, einmal sogar innerhalb derselben Datei.

---

## Der schwerste Fund: ZIEL.md widersprach sich selbst

Zeile 31 sagte richtig, E-85 sei *„seit 7.2.0.52 in Ordnung"* und **am
laufenden Programm belegt**. Zwölf Zeilen darunter stand:

> die Umlaute in per IMAP abgerufenen Nachrichten sind mit **E-85** in 7.2.0.51
> behoben, aber noch nicht von Gregor am laufenden Programm bestätigt.

Falsche Fassung, falscher Belegstand, **in derselben Datei**. Wer von oben
liest, bekommt die richtige Auskunft; wer die Zusammenfassung überfliegt — und
das tut man bei einer Zusammenfassung —, die falsche.

Dieselbe Aussage stand in **vier** weiteren Dateien, jeweils mit 7.2.0.51:
`BEFUNDE.md`, `WEITERMACHEN.md`, `PORTIERUNG.md` (zweimal) und `README.md`.

## Der zweite: BEFUNDE.md widersprach sich in einer einzigen Zeile

Das Urteil zu E-85 begann mit

> **Alle drei Mängel behoben in 7.2.0.51 — aber die Behebung hat eine
> Regression eingeführt, die noch offen ist**

und sagte im selben Absatz weiter unten

> **(3) neu eingeführt und in 7.2.0.51 gleich mitbehoben**

Beides zugleich kann nicht stimmen. Gemessen ist: es waren **vier** Mängel, der
entscheidende (Zeichensatz aus dem Top-Level-Kopf statt aus dem MIME-Teil) ist
erst in **7.2.0.52** behoben, und die Regression ist geschlossen.

## Zwei Befunde waren für die Prüfung unsichtbar

`tools/pruefe-befundurteile.pl` liest das Urteil aus dem **ersten Fettdruck bis
60 Zeichen** der dritten Spalte.

| Befund | erster Fettdruck | Folge |
|---|---|---|
| **E-85** | *„Alle drei Mängel behoben in 7.2.0.51 — aber die Behebung hat …"* | **106 Zeichen** — kein Treffer, Befund **nicht klassifiziert** |
| **E-86** | *„Verdacht am Quelltext, nicht bewiesen"* | enthält weder *offen* noch *behoben* — **nicht klassifiziert** |

Beide gingen also durch jede Gegenprüfung hindurch, ohne je gewogen zu werden.
Nach der Berichtigung: **65** Kennungen statt 63, **9** offen statt 8, **56**
behoben statt 55. Erst dadurch konnte `tools/offene-befunde.pl` überhaupt
merken, dass E-86 in `WEITERMACHEN.md` fehlte und E-83 dort zu viel war.

**Das ist der eigentliche Befund an diesem Tag:** eine Schranke, die ein
Zeichenlimit als Urteilsgrenze benutzt, schweigt bei genau den Zeilen, die zu
viel erklären — und zu viel erklärt man dort, wo man unsicher ist.

## Ein Satz brach seit Wochen mitten ab

`PORTIERUNG.md` endete einen Absatz mit

> **Veröffentlicht** ist bei GitHub `v1.0.50` (13.09.2026). Hier steht bewusst keine

und ging direkt in eine Tabelle über. In der ersten Fassung (`2902199`) hiess
der Satz vollständig *„Hier steht bewusst keine zweite Fassung dieser
Tabelle."* und stand als eigene Zeile; spätere Umbauten haben ihn in den Absatz
gezogen und das Ende verloren. Dazu fehlte die Leerzeile vor der Tabelle, ohne
die sie im Blockzitat nicht rendert. **Kein Werkzeug prüft auf abgebrochene
Sätze** — gefunden nur, weil ich die Zeile ganz gelesen habe.

## Zeilenangaben: acht von sechzehn waren falsch

Jede Angabe zu E-85, E-83 und E-86 ist gegen den Quelltext nachgemessen worden.

| Datei | stand da | gemessen |
|---|---|---|
| `ImapDownload.cpp` `FindMIMECharset` | 4671 | **4742** |
| `ImapDownload.cpp` `iCharsetIdx > 2` | 4688 | **4785** |
| `ImapDownload.cpp` `ISOTranslateChunk` | 4705 | **4802** |
| `ImapDownload.cpp` Auswertung | 4705-4711 | **4802-4808** |
| `ImapDownload.cpp` `m_CurrentBodyType` | 2798, 3034, 3283 | **2837, 3074, 3324** |
| `utils.cpp` `szBuf[lSize] = 0` | 1443 | **1480** |
| `utils.cpp` Kommentar *TextReader::ReadIt* | 1440-1442 | **1474-1479** |
| `utils.cpp` Rückkehr bei `iCharsetIdx <= 2` | 1412-1415 | **1449-1452** |
| `WazooBar.cpp` `Create(...)` (NP3-1) | 1003 | **1004** |
| `OTShim_Bild.h` Kommentar (NP3-3) | 326-328 | **326-330** |

**Gestimmt haben:** `utils.cpp:1269`, `:1308-1310`, `:1393-1395`, `utils.h:93`,
`mime.cpp:382`, `exports.h:147`, `TridentView.cpp:1325-1352`,
`persona.cpp:565-566`.

Das Muster ist lesbar: berichtigt wurde, was **vor** der letzten Änderung
derselben Datei gemessen war; gestimmt hat, was danach gemessen wurde. Eine
Zeilenangabe altert mit der Datei, nicht mit dem Befund.

## Was E-83 betrifft

Kein Dokument führte den alten `m_pThread`-Verdacht noch als offen oder als
Ursache — `CHANGELOG.md` hatte ihn bereits als widerlegt eingetragen.
`README.md` und der erzeugte Block in `WEITERMACHEN.md` führten E-83 dagegen
noch als **offenen** Befund, und `WEITERMACHEN.md` nannte
`StartWorkerThread` mit `m_pThread == NULL` ausdrücklich als *„den offenen
Verdacht"*. Beides berichtigt.

**Bei der Gelegenheit eine eigene Behauptung widerlegt.** `BEFUNDE.md` sagte,
der Text *„Waiting in the task queue …"* werde *„nie überschrieben"*. Gemessen:
`SetMainText` wird in **acht** Dateien gerufen, der IMAP-Weg ist darunter
(`ImapChecker.cpp:398, 453, 497, 519, 582`). Richtig ist das Engere — **eine
liegengebliebene Aufgabe erreicht diese Stellen nicht mehr**. Ebenso berichtigt:
*„zwei Wochen in die falsche Richtung"* waren **drei Tage** (11.09. 11:00 bis
14.09. 05:21).

## ZIEL.md Kriterium 2a

Die Aufteilung passt, und **„neun Kriterien" bleibt richtig** — 2a ist als
offener Teil von Kriterium 2 ausgewiesen, kein zehntes Kriterium;
`doku-pruefen.pl` zählt weiter 9. **Nicht** mitgezogen war der Rest: drei
Dateien sagten weiterhin, den Kriterien 2 und 4 fehle *„dasselbe"*, und nannten
nur die Meldung *„Encountered an improper argument"* — E-86 fehlte überall.
Berichtigt in `ZIEL.md`, `PORTIERUNG.md` und `AUFGABEN.md`.

## Die zwölf offenen Befunde, einzeln nachgemessen

Alle zwölf sind **weiterhin offen**. Neu ist, dass das jetzt als Messung
dasteht und nicht als stehengebliebenes Urteil — mit Datum und Fundstelle in
jeder Zeile.

| Befund | nachgemessen am 14.09.2026 |
|---|---|
| NP2-2 | `OnSysColorChange` an drei Stellen unverändert |
| NP2-3 | `CPaletteDC::BitBltTransparent`, `OTShim_Werkzeugleiste.cpp:239` |
| NP3-1 | unverändert; **Fundstelle berichtigt** (`WazooBar.cpp:1004`) |
| NP3-2 | `OnToolHitTest` an **allen** zehn Stellen weiterhin `int` |
| NP3-3 | der falsche Kommentar unverändert, jetzt `:326-330` |
| R-1 | **neu ausgezählt**: 137 / 116 ok / 21 zu ändern — identisch mit dem 07.09.2026 |
| E-39 | alle drei Fundstellen stimmen, am laufenden Programm weiterhin unbestätigt |
| E-67 | Junk-Score-Verbenumrechnung in `filtersv.cpp` unverändert |
| E-71 | `filtersd.cpp:3857`, gerufen aus `msgdoc.cpp:796` — **bleibt zurückgestellt** |
| E-77 | in ganz `Eudora71/` **eine** UTF-7-Fundstelle, und die dekodiert nichts |
| E-78 | die zwei Spurmarken liegen unverändert in `mainfrm.cpp` und sind **noch nie ausgelesen** worden |
| **E-14** | **nicht entscheidbar** — nur am *zweiten* Start messbar. Steht jetzt als *„Stand ungeprüft seit dem 05.09.2026"* mit Messanleitung |

## Drei neue Schranken

| Werkzeug | was sie abweist | gegengetestet |
|---|---|---|
| `tools/pruefe-behoben-belegt.pl` | ein neues *„behoben"* ohne Angabe, **woran** es belegt ist | `--selbsttest` 10/10; `48c1ee2` **abgewiesen**, `26718ef` und `34eba35` **durch** |
| `tools/pruefe-anzeigetext.pl` | ein zitierter Oberflächentext ohne Herkunftsangabe | `--selbsttest` 7/7, darunter beide am Bestand gemessenen Fehlalarme |
| `tools/arbeitsbaum-angleichen.sh` | ein erster Auftragsschritt, der Commits verwerfen kann | `arbeitsbaum-angleichen-tests.sh`, **12/12** im Wegwerf-Repo |

**Beide Prüfschranken hat erst der Gegentest brauchbar gemacht.**
`pruefe-behoben-belegt.pl` hatte im ersten Entwurf zwei Fehler, die der
Selbsttest allein nicht zeigte:

1. **Die Verneinung steht *im* Fund, nicht davor.** *„von Gregor ist nichts
   davon am laufenden Programm bestätigt"* ist ein **vollständiger** Treffer
   des Musters. Wer nur das Umfeld davor prüft, lässt genau die Zeile durch, um
   derentwillen es die Schranke gibt.
2. **`charset=utf-8` sieht aus wie ein Messwert.** Der erste Entwurf nahm jeden
   Backtick-Ausdruck mit `=` als Beleg — und liess damit ausgerechnet `48c1ee2`
   durch, den historischen Fall. Ein Wert ist erst ein Messwert, wenn
   danebensteht, dass jemand ihn abgelesen hat.

## Gemessen, aber NICHT geändert

- **`Arbeitsweise/*.md` ist ein Spiegel, kein Bestand.**
  `tools/lehren-spiegeln.pl` schreibt die Dateien im `pre-commit` aus dem
  Sitzungsgedächtnis zurück und macht jede Berichtigung im Repo **lautlos**
  rückgängig. Drei gemessene Berichtigungen sind so verlorengegangen:
  *„9 Fälle"* → 10, *„`:186`"* → `:191`, *„11 Proben"* → 12. Die Messungen
  stehen (Selbsttests fahren 10 bzw. 7 Fälle, die Proben sind 12, und
  `SetMainText` steht in `QCTaskManager.cpp:191` — `:186` ist die Sperre).
  **Berichtigt werden muss die Quelle, nicht der Spiegel** — das gehört
  CHRONIST. Die Zahlen in `tools/WERKZEUGE.md` sind die gemessenen.
- **Vier Zitate ohne Herkunftsangabe bleiben im Bestand:** E-16, E-33, E-34
  (dreimal *„Encountered an improper argument"*) und E-47. Deshalb prüft
  `pruefe-anzeigetext.pl` nur den **Zuwachs**.
- **E-86** ist als offen eingetragen und um das ergänzt, was `CHANGELOG.md`
  schon gemessen hatte (nur das **Lesen** ist betroffen — selbst nachgemessen:
  `IDS_INI_READMESSAGE_STYLE_SHEET` kommt im ganzen Baum nur in
  `TridentView.cpp` vor). **Zu PRÜFERs laufender Arbeit steht nichts drin.**
- **QCSSL in `Releases/1.0/` hinkt weiter** — `release-pruefen.pl` weist
  unverändert ab. Nicht angefasst, weil es ein Bau ist und kein Lektorat.
- **`EINSTELLUNGEN.md`, `FILTER.md`, `tools/RELEASES.md`** nennen weder
  Quellstand noch Paketnummer. `doku-pruefen.pl` führt das als *„zur
  Kenntnis"*, nicht als Mangel — sie beschreiben Sachverhalte ohne
  Fassungsbezug. Bewusst so gelassen.

## Was diesmal nicht auffiel und beim nächsten Mal zuerst drankommt

Die beiden Widersprüche in `ZIEL.md` und `BEFUNDE.md` standen **innerhalb einer
Datei**. Kein Werkzeug prüft eine Datei gegen sich selbst — `doku-pruefen.pl`
hält Dateien **gegeneinander**. Eine Schranke, die in derselben Zeile zwei
verschiedene Fassungsnummern zu **einer** Kennung findet, hätte beide Fälle
gefunden und wäre billig.
