# <a id="lektor-39"></a>LEKTOR-39 — Doku nach 7.2.0.101 (1.0.101 bei Gregor, vor Release v1.0.101)

Lauf am 17.10.2026 auf `wt/lektor` (`04a33cca`, gleich `e-121-mehrere-gesendete`). Anlass: seit
[LEKTOR-38](LEKTOR-38.md#lektor-38) (`a5604ddf`) sind [PRÜFER-32](PRUEFER-32.md) gelaufen (7.2.0.100
nachgerechnet, zwei Wege zum Datenverlust: Vorab-Kopien ohne Auftrag werden von der nächsten
gesendeten Mail genommen, eine liegengebliebene Kopie wird mit einer Server-Nachricht verwechselt),
Gregors Test an 1.0.100, Gregors Entscheidung *„ok, morgen B, dann release“*, 7.2.0.101 (eigene
Kennung für gesendete Post, gescheiterte Vorab-Kopie wird entfernt), [E-67](../Intern/BEFUNDE.md#e-67) als
behoben geführt (Code seit 7.2.0.43, am 17.10.2026 gemessen) und [E-125](../Intern/BEFUNDE.md#e-125) neu.
Ziel: Release `v1.0.101` nach Gregors Test.

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Arbeitsweise/` = 126 Dateien (127 mit diesem
Bericht), davon 41 außerhalb von `Befunde/`. Alle 41 über Fassungsangaben (`7.2.0.100`, `1.0.100`,
`v1.0.87`) und über [E-67](../Intern/BEFUNDE.md#e-67), [E-121](../Intern/BEFUNDE.md#e-121), [E-125](../Intern/BEFUNDE.md#e-125) gesucht; ganz gelesen die
15 seit `a5604ddf` geänderten an den geänderten Stellen, dazu `FILTER.md` an allen E-67-Stellen und
die README-Abschnitte *Auf einen Blick* und *Was es nicht kann*. Aus `Befunde/` der neue Bericht
`PRUEFER-32.md` (Urteil und Tabelle), die übrigen über `befunde-verlinken.pl --anker`. **Maßstab:**
`Eudora71/Version.h` = 7.2.0.101, `VERSION` = 1.0.101, `git tag` = `v1.0.87`, Statuszeilen in
`BEFUNDE.md` ([E-67](../Intern/BEFUNDE.md#e-67) `:235`, [E-121](../Intern/BEFUNDE.md#e-121) `:288`, [E-125](../Intern/BEFUNDE.md#e-125) `:292`), `Befunde/PRUEFER-32.md`,
`Releases/1.0.101/TESTEN.txt`, `perl tools/rollen-faellig.pl`.

`perl tools/offene-befunde.pl`: 34/34, deckt ([E-67](../Intern/BEFUNDE.md#e-67) hinaus, [E-125](../Intern/BEFUNDE.md#e-125) hinein). `perl tools/doku-pruefen.pl`:
kein Widerspruch; zur Kenntnis `Testdaten/README.md` (7.2.0.96, nicht belegbar),
`tools/WERKZEUGE.md` (berichtigt in [L-39.3](#l-39.3)), `tools/ZWEIGE.md` (7.2.0.99, berichtigt in
[L-39.4](#l-39.4)), `tools/pruefdaten/LIESMICH.md` (Messfassung, nichts zu ändern).

## Berichtigt

### <a id="l-39.2"></a>L-39.2 — E-121 und E-125: 7.2.0.101 fehlte, E-125 stand nirgends für Anwender

| Stelle | stand | jetzt |
|---|---|---|
| `README.md`, *Auf einen Blick*, *Bekannte Fehler* | [E-125](../Intern/BEFUNDE.md#e-125) fehlte | neue Zeile: Nachricht aus einem IMAP-Ordner nach `Out` gezogen – neue Nachricht mit `<br>`; zweite Spalte *nichts – das Original bleibt; wer die neue Nachricht sendet, schickt sie mit kaputtem Empfänger*; Abhilfe *nicht nach `Out` ziehen, so entstandene Einträge nicht senden, sondern löschen*. Beleg `BEFUNDE.md:292` (*„Kein Datenverlust … Gefahr: wer die neuen Einträge sendet, schickt sie mit kaputtem Empfänger“*) und `Releases/1.0.101/TESTEN.txt` (*„Bitte NICHT: Mails aus der OUTBOX zurueck nach "Out" ziehen“*). **Wortlaut bitte prüfen** – Gregors Tabelle. |
| `README.md`, *Was es nicht kann*, [E-121](../Intern/BEFUNDE.md#e-121) | endete bei *„Paket 1.0.100 zum Test bei Gregor“*; dazu die Kürzel *N1*, *N2/N3*, *F1* ohne Klartext | 1.0.100 von Gregor getestet, dazu 7.2.0.101 mit [PRÜFER-32](PRUEFER-32.md); die Kürzel durch ihren Inhalt ersetzt (*entfernt wird nur noch die Nachricht, die tatsächlich verschoben wurde*; *der Verlust eingebetteter Bilder nach einem Neustart*) |
| `CHANGELOG.md`, *Noch offen*, [E-121](../Intern/BEFUNDE.md#e-121) | endete bei 7.2.0.100, *„Paket 1.0.100 zum Test bei Gregor“* | 1.0.100 getestet, dazu 7.2.0.101 |
| `CHANGELOG.md`, *Noch offen* | [E-125](../Intern/BEFUNDE.md#e-125) fehlte | neue Zeile aus `BEFUNDE.md:292` |
| `ZIEL.md:20`, Maßstabszeile [E-121](../Intern/BEFUNDE.md#e-121) | endete bei 7.2.0.100 | dazu 7.2.0.101 |
| `TESTPLAN.md:1` | 1.0.100 *„zum Test bei Gregor“*; *„gesendete Post und N1“* | von Gregor am 16.10.2026 getestet, kein Release wegen PRÜFER-32; N1 in Klartext |
| `Releases/PAKETE.md`, Abschnitt 1.0.100 | keine Zeile *Bei Gregor* (nur *„Sein Test: …“* als Vorhaben); Verweis `Befunde/PRUEFER-31.md` aus `Releases/` heraus kaputt | Zeile *Bei Gregor* aus `WEITERMACHEN.md:12`/`:128`; Verweis auf `../Befunde/` |
| `PORTIERUNG.md:44` | *„Stand 16.10.2026“* über 7.2.0.101 | 17.10.2026 (Commit `04a33cca` vom 17.10.) |
| `WEITERMACHEN.md:128`, Block *HIER WEITERMACHEN* | Stand 16.10. abends, Quellstand 7.2.0.100, Punkt (1) als Vorhaben, *„Angeboten: [E-67](../Intern/BEFUNDE.md#e-67) (zwei Zeichen) in einem der nächsten Zweige“* | Nachtrag: (1) eingebaut als 7.2.0.101, PRÜFER fehlt; (2) offen ([L-39.1](#l-39.1)); [E-67](../Intern/BEFUNDE.md#e-67) brauchte keinen Zweig; [E-125](../Intern/BEFUNDE.md#e-125) in der README-Tabelle |

Urteile unverändert.

### <a id="l-39.5"></a>L-39.5 — FILTER.md: zwei behobene Befunde standen als offen

* `FILTER.md:522-524`, Kasten *„Achtung bei der Regel «Junk Score» is less than N … ([E-67](../Intern/BEFUNDE.md#e-67), offen)“*
  – die Warnung an Anwender galt nicht mehr. Jetzt: Korrektur seit 7.2.0.43, am 17.10.2026 gemessen,
  von Gregor noch nicht bestätigt; eine `Filters.pce` aus älterer Fassung kann die verfälschte Regel
  schon enthalten (das sagt `BEFUNDE.md:235` mit *„der verfälschte Filter wird gespeichert“*).
* `FILTER.md`, Tabelle *Was hier zurzeit noch nicht stimmt* (*„Die folgenden Befunde … sind offen“*):
  [E-67](../Intern/BEFUNDE.md#e-67) und [E-76](../Intern/BEFUNDE.md#e-76) herausgenommen und in den Satz *Behoben, aber gut zu wissen*
  gestellt. [E-76](../Intern/BEFUNDE.md#e-76) ist laut `BEFUNDE.md:244` **seit 7.2.0.49 behoben und von Gregor am 11.09.2026
  bestätigt** – stand also gut fünf Wochen falsch.
* Nicht geändert: der Kopf von `FILTER.md` (*„Geprüft gegen 7.2.0.68 … gegen ihn ist diese Datei nicht
  erneut geprüft“*) – eine ganze Prüfung gegen 7.2.0.101 ist mehr als dieser Lauf.

### <a id="l-39.3"></a>L-39.3 — WERKZEUGE: Kopf und neues Werkzeug

`tools/WERKZEUGE.md:3` *„Quellstand inzwischen 7.2.0.100“* → 7.2.0.101. `git diff a5604ddf HEAD -- tools/`:
neu ist `tools/messen-e67.ps1` (Hilfsmittel zu [E-67](../Intern/BEFUNDE.md#e-67), öffnet über `befehl-schicken.ps1` das
Filterfenster unter `testlauf.ps1`). Eingetragen unter *Nicht in der Tabelle, weil Hilfsmittel für
einen einzelnen Befund*, neben `befehl-schicken.ps1`. Keine Schranke meldet ein Werkzeug ohne Zeile –
`doku-pruefen.pl` schwieg dazu.

### <a id="l-39.4"></a>L-39.4 — ZIEL und ZWEIGE

* `ZIEL.md:33`, *Ausdrücklich nicht Voraussetzung*: [E-67](../Intern/BEFUNDE.md#e-67) steht weiter in der Liste, jetzt mit
  *„(Korrektur seit 7.2.0.43, am 17.10.2026 gemessen)“* – das Wort „behoben“ in derselben Zeile wies der Haken ab (`pruefe-befundurteile.pl` liest es für alle Kennungen der Zeile). Herausnehmen wäre die sauberere Lösung –
  das ist Gregors Maßstab, deshalb nur vermerkt.
* `tools/ZWEIGE.md:101`, `e-121-mehrere-gesendete`: *„Ziel Release v1.0.100“* → Nachtrag: kein
  v1.0.100 wegen PRÜFER-32, 7.2.0.101 auf demselben Zweig, Ziel v1.0.101.

## Offen — nur gemeldet

### <a id="l-39.1"></a>L-39.1 — *Auf einen Blick* gegen E-121: Stand jetzt (Fortschreibung von L-38.4)

**Unverändert offen.** `README.md:55-58`: *„eine verschobene Nachricht kann nicht mehr verlorengehen“*;
`:49-52` (*Was geht*): *„die Nachricht verschwindet aus dem lokalen Postfach erst, wenn sie auf dem
Server steht“*; Vorsatz der Tabelle *„In keinem dieser Fälle geht eine Nachricht … verloren“*.
`BEFUNDE.md:288` dagegen weiter **„DATENVERLUST. Offen“**. Was sich seit [L-38.4](LEKTOR-38.md#l-38.4) geändert hat:

* Die beiden Datenverlust-Wege aus [PRÜFER-32](PRUEFER-32.md) (Vorab-Kopien ohne Auftrag; Verwechslung einer
  liegengebliebenen Kopie mit einer Server-Nachricht) sind in 7.2.0.101 **behoben am Quelltext**,
  am Prüfstand gemessen für das gescheiterte Hochladen und den Kollisionsfall – **nicht** für
  gesendete Post (am Prüfstand nicht nachstellbar, liegt bei Gregor laut `Releases/1.0.101/TESTEN.txt`).
* **Niemand hat 7.2.0.101 nachgerechnet:** `perl tools/rollen-faellig.pl` meldet PRÜFER fällig seit
  `01f4a2a` (`ImapToc.cpp`, `tocdoc.cpp`, `filtersv.cpp` und zwei weitere) und CHRONIST fällig.
  PRÜFER-32 hat das Release ausdrücklich an diese Wege geknüpft.
* Weiter ohne Eintrag und laut [PRÜFER-32](PRUEFER-32.md) *„unverändert offen, 7.2.0.100 berührt sie nicht“*:
  [PRÜFER-31](PRUEFER-31.md) F2 (ein hängendes Merkzeichen aus einem gescheiterten Verschieben – dann wird ein
  Namensvetter verschoben und die eigentliche Nachricht entfernt, obwohl sie nie auf dem Server ankam;
  Vermutung), F5–F7, und [PRÜFER-30](PRUEFER-30.md) F3–F9 (darunter F6, Vermutung). Ob die eigene Kennung aus
  7.2.0.101 F2 nebenbei mit schließt, sagt kein Bericht – das ist eine Frage an den nächsten PRÜFER.

Die zwei Wege bleiben Gregors Entscheidung (`WEITERMACHEN.md:128`: *„nach 1.0.101 erneut fragen“*):
A – [E-121](../Intern/BEFUNDE.md#e-121) nach PRÜFER und Gregors Test schließen und die Restfälle als eigenen Befund
abtrennen, dann stimmt die README; B – [E-121](../Intern/BEFUNDE.md#e-121) offen lassen, eine Tabellenzeile *„Restfälle beim
Verschieben nach IMAP (Vermutung am Quelltext, nie beobachtet)“* mit *die Nachricht* in der zweiten
Spalte und den Vorsatz einschränken. **Vor dem Release v1.0.101 muss eines davon geschehen**, sonst
verspricht die README mehr als der Befund.

### <a id="l-39.6"></a>L-39.6 — Prüfer-Kürzel in anwendernahen Texten

Gesucht in `README.md`, `FILTER.md`, `TESTPLAN.md`, `Releases/1.0.101/TESTEN.txt` nach `F1`…`F9`,
`N1`…`N9`, `P1`…`P9`, `L-x.y` ohne Klartext. Behoben: `README.md:244-246` (N1, N2/N3, F1, siehe
[L-39.2](#l-39.2)), `TESTPLAN.md:1` (N1). **Verbleibend, nur gemeldet:**

* `TESTPLAN.md:1` *„[PRÜFER-31] F1: zwei gesendete Mails auf einmal nach IMAP“* – mit Klartext dahinter,
  vertretbar.
* `README.md:177` *„Berichtigt am 17.09.2026 (LEKTOR, [L-13.1](LEKTOR-13.md#l-13.1))“* – Herkunftsvermerk, kein Inhalt.
* `CHANGELOG.md`, *Noch offen*, Zeile [E-121](../Intern/BEFUNDE.md#e-121): *„PRÜFER-30 F1“*, *„N1 eingebaut“*, *„N2/N3“*,
  *„F3–F9“*, *„F1 … F3, F4“*, *„F2 (hängendes Merkzeichen …)“*. Der CHANGELOG ist über die README
  verlinkt (*Was gefunden und behoben wurde*). Die Zeile ist inzwischen eine Kette aus neun Fassungen;
  sie neu zu schreiben ist mehr als eine mechanische Berichtigung – Vorschlag: auf drei Sätze kürzen
  (*Was geschah, was behoben ist, was offen ist*), Einzelheiten in den Fassungsabschnitten lassen.
* `TESTEN.txt` 1.0.101: frei von Kürzeln, nur [E-125](../Intern/BEFUNDE.md#e-125)/[E-67](../Intern/BEFUNDE.md#e-67) mit Klartext.

### <a id="l-39.7"></a>L-39.7 — was für Release v1.0.101 fehlt (nicht vorweggenommen)

Fortschreibung von [L-38.7](LEKTOR-38.md#l-38.7), jetzt für `v1.0.101`. **Vorbedingungen:** PRÜFER über 7.2.0.101,
Gregors Test der gesendeten Post an 1.0.101, Entscheidung zu [L-39.1](#l-39.1), Defender-Prüfung.

* **README:** *„Das neueste Release ist `v1.0.87`“* (`:130-138`, Datum, URL, Inhalt) → `v1.0.101` mit
  [E-105](../Intern/BEFUNDE.md#e-105), [E-118](../Intern/BEFUNDE.md#e-118) Teil 1 und 2, [E-121](../Intern/BEFUNDE.md#e-121), [E-83](../Intern/BEFUNDE.md#e-83) zweite Ursache. Die Stellen *„im Download `v1.0.87`
  offen … noch nicht ausgeliefert“* bei [E-105](../Intern/BEFUNDE.md#e-105) (`:228`), [E-118](../Intern/BEFUNDE.md#e-118) (`:237`), [E-121](../Intern/BEFUNDE.md#e-121) (`:242`) und
  [E-83](../Intern/BEFUNDE.md#e-83) (`:256-260`, *„noch nicht ausgeliefert“*). Defender-Abschnitt `:482-483` nennt `v1.0.87`,
  1.0.96, 1.0.97 und 1.0.99 als sauber – **1.0.100 und 1.0.101 nirgends** (auch nicht in CHANGELOG,
  PAKETE, WEITERMACHEN); das Release-ZIP muss durch `paket-pruefen.ps1`. *Auf einen Blick*:
  *„Neu gegenüber `v1.0.87`“* bleibt nach dem Release richtig, *„Stand Paket 1.0.101“* ebenso.
* **[E-105](../Intern/BEFUNDE.md#e-105) ginge weiter ohne Gregors Urteil hinaus** (seit [L-37.11](LEKTOR-37.md#l-37.11)); die README sagt es
  offen dazu.
* **Releases/PAKETE.md:** Kopf `:6` und `:20` (*„zuletzt veröffentlicht 1.0.87“*); Abschnitt 1.0.101 ohne
  Zeilen *Defender*, *Bei Gregor*, ZIP, SHA256, URL, *Freigabe* (Muster 1.0.87); 1.0.100 ohne *Defender*.
* **CHANGELOG:** Überschriften 7.2.0.88 bis 7.2.0.101 *„nicht veröffentlicht“* → *„enthalten in
  `v1.0.101`“* bzw. *„veröffentlicht als `v1.0.101`“*; *Noch offen*: [E-118](../Intern/BEFUNDE.md#e-118) *„noch nicht
  veröffentlicht“*, [E-121](../Intern/BEFUNDE.md#e-121) *„nicht veröffentlicht“* (zweimal).
* **tools/RELEASES.md:** neue Zeile `v1.0.101` mit Gregors Freigabe im Wortlaut (Muster `v1.0.83`).
* **Übrige Standköpfe:** `WEITERMACHEN.md` *Quellstand*, *Paketnummer*, *Zuletzt gebaut und
  veröffentlicht*, *Zuletzt von Gregor bestätigt*; `ZIEL.md:47` und die Maßstabszeilen
  [E-118](../Intern/BEFUNDE.md#e-118)/[E-121](../Intern/BEFUNDE.md#e-121); `AUFGABEN.md:3`; `PORTIERUNG.md:44`; `TESTPLAN.md:1`; `tools/ZWEIGE.md`
  (`e-121-mehrere-gesendete` nach Merge, `e-118_HTML_header` noch auf `origin`).
* **Nicht veröffentlichen:** 1.0.96, 1.0.98 (Defender), 1.0.99 (PRÜFER-31 F1), 1.0.100 (PRÜFER-32).

### <a id="l-39.8"></a>L-39.8 — was aus LEKTOR-38 geworden ist

| Punkt | Stand |
|---|---|
| [L-38.4](LEKTOR-38.md#l-38.4) README gegen [E-121](../Intern/BEFUNDE.md#e-121) | **offen**, fortgeschrieben als [L-39.1](#l-39.1) |
| [L-38.5](LEKTOR-38.md#l-38.5) übrige Tabellenzeilen | [E-67](../Intern/BEFUNDE.md#e-67) ist aus der Tabelle heraus und jetzt behoben – stimmt. **Weiter offen:** [E-47](../Intern/BEFUNDE.md#e-47)-Zeile ohne die Junk-Bewertung (Punktzahl immer 0); [E-78](../Intern/BEFUNDE.md#e-78) fehlt (`grep E-78 README.md`: 0); [E-124](../Intern/BEFUNDE.md#e-124) ohne Querverweis auf [E-123](../Intern/BEFUNDE.md#e-123) |
| [L-38.6](LEKTOR-38.md#l-38.6) PRÜFER/CHRONIST für 7.2.0.100 | PRÜFER erledigt ([PRÜFER-32](PRUEFER-32.md)); für 7.2.0.101 **PRÜFER und CHRONIST wieder fällig** |
| [L-38.7](LEKTOR-38.md#l-38.7) Release v1.0.100 | ersetzt durch [L-39.7](#l-39.7) (v1.0.101) |
| [L-37.8](LEKTOR-37.md#l-37.8) erster Satz des E-121-Urteils | **offen**: `BEFUNDE.md:288` beginnt weiter *„Offen, Behebung eingebaut in 7.2.0.90 … von Gregor noch nicht bestätigt“*; der neunte Teil ist mitten hineingesetzt |
| [L-37.9](LEKTOR-37.md#l-37.9) Datenverlust-Vermutungen ohne Eintrag | **offen** (PRÜFER-30 F6, PRÜFER-31 F2), siehe [L-39.1](#l-39.1) |
| [L-37.10](LEKTOR-37.md#l-37.10) AUFGABEN ohne Zeilen für [E-122](../Intern/BEFUNDE.md#e-122) bis [E-124](../Intern/BEFUNDE.md#e-124) | **offen**, dazu jetzt [E-125](../Intern/BEFUNDE.md#e-125) (`grep E-125 AUFGABEN.md`: 0) |
| [L-37.13](LEKTOR-37.md#l-37.13) DLLs im Hauptbaum | **offen**: `git status` im Hauptbaum zeigt weiter ` M` an `DirServ.dll`, `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll`, dazu jetzt ` M tools/AGENTEN-LAUFEN.md` – vor dem Paketbau des Release-ZIPs klären |
| [L-37.14](LEKTOR-37.md#l-37.14) TESTPLAN ohne Abschnitt ab 1.0.90 | **offen**: Teil C endet mit C5 (1.0.89); die Prüfschritte zu 1.0.100 und 1.0.101 stehen nur in `Releases/1.0.10x/TESTEN.txt` |
