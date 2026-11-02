# <a id="lektor-123"></a>LEKTOR-123 — Nachtrag zu LEKTOR-122: Einarbeitung in 09c39785, Zweig test_1130_ergebnisse (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-122](LEKTOR-122.md#lektor-122).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102b`, Stand `09c39785`.
Umfang nach Auftrag eng: nur ob die acht Funde aus [LEKTOR-122](LEKTOR-122.md#lektor-122) richtig eingearbeitet sind (`git diff afe855a8..HEAD`, ein Commit, elf Dateien). Keine neue Vollrunde. Als eigener Bericht statt Nachtrag in [LEKTOR-122](LEKTOR-122.md#lektor-122), weil der Auftrag nur diese Datei und `Intern/LEKTORAT.md` zum Ändern freigibt.

## Kurz

Die Einarbeitung ist in der Sache richtig: [E-194](../Intern/BEFUNDE.md#e-194) (`<x-flowed>` in der gespeicherten Textdatei) nennt jetzt die Postfachliste als Weg, [E-140](../Intern/BEFUNDE.md#e-140) (Speichern unter aus Nachrichten- und Verfassen-Fenster ohne Zeichensatz) ist nur noch für das Verfassen-Fenster als bestätigt geführt, und im ganzen Stand steht kein Pfad, Betreff oder Dateiname aus Gregors Rechner mehr. Sechs Reste, keiner am Programm. Der wichtigste: [E-140](../Intern/BEFUNDE.md#e-140) nennt die Datei aus der Postfachliste „seine zweite Datei“, es war die erste ([L-123.1](#l-123.1)); der TESTPLAN sagt es richtig. Daneben nennt der TESTPLAN [E-194](../Intern/BEFUNDE.md#e-194) noch „in der Datei aus dem Nachrichtenfenster“ ([L-123.2](#l-123.2)), und die entfernten Namen stehen weiter in der Geschichte von `1c75f5c3`, die mit einem gewöhnlichen Merge auf `main` käme ([L-123.4](#l-123.4)). Nach Auftrag ist nichts berichtigt.

## Funde aus LEKTOR-122

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-122.1](LEKTOR-122.md#l-122.1) [E-140](../Intern/BEFUNDE.md#e-140) nur Verfassen-Fenster | **teilweise** | `Intern/BEFUNDE.md:429` *„für das **Verfassen-Fenster** von Gregor am 01.11.2026 an 7.2.1.130 bestätigt … das **Nachrichtenfenster** ist bei Gregor noch nicht belegt“*; `Intern/TESTPLAN.md:160-165` *„per **Doppelklick öffnen** … `E-140 speichern aus Nachrichtenfenster:`“*; `:175` *„nur Schritt 2 (Verfassen-Fenster)“*. Rest: „zweite Datei“, siehe [L-123.1](#l-123.1) |
| [L-122.2](LEKTOR-122.md#l-122.2) [E-194](../Intern/BEFUNDE.md#e-194) Ort Postfachliste | **teilweise** | `Intern/BEFUNDE.md:401` *„aus der **Postfachliste** schreibt `<x-flowed>`“*, *„`tocview.cpp:3118-3131`“* (gemessen: `GetFullMessage` `:3122`, `FindBody` `:3130`), *„entfernt nur eine `<x-html>`-Hülle“*. Rest: TESTPLAN, siehe [L-123.2](#l-123.2) |
| [L-122.3](LEKTOR-122.md#l-122.3) Daten aus Gregors Rechner | **im Stand erledigt, in der Geschichte nicht** | `git grep -F` an `HEAD` nach Freigabepfad, Betreff, Bildname, ZIP-Name: je 0 Treffer (gemessen). `Arbeitsweise/stand-01-11-2026.md:53` *„in seiner VM-Freigabe ab (Pfad steht nicht im Repo)“*. Rest siehe [L-123.4](#l-123.4) |
| [L-122.4](LEKTOR-122.md#l-122.4) [E-143](../Intern/BEFUNDE.md#e-143) nach Gregors Entscheidung | **teilweise** | Urteil `Intern/BEFUNDE.md:395` *„das Suchfenster hat Gregor am 02.11.2026 entschieden (ein Hinweis je Übertragung), eingebaut ist es noch nicht.“* und *„**Zuletzt gemessen: 02.11.2026 an 7.2.1.130**“*; `Intern/WEITERMACHEN.md:162` ergänzt. Rest: „Offen“ und „Was noch fehlt“, siehe [L-123.3](#l-123.3) |
| [L-122.5](LEKTOR-122.md#l-122.5) [E-195](../Intern/BEFUNDE.md#e-195) `saveas.cpp:92` | erledigt, Aufruferliste fehlt | `Intern/BEFUNDE.md:400` *„Die **Postfachliste** ist nicht betroffen: `CTocView::OnFileSaveAs` nimmt `IDS_TEXT_FILE_FILTER` (`tocview.cpp:3066-3070`)“* (gemessen: `:3070`). Siehe [L-123.6](#l-123.6) |
| [L-122.6](LEKTOR-122.md#l-122.6) WEITERMACHEN-Kopf | erledigt | `Intern/WEITERMACHEN.md:3` *„**Stand 02.11.2026 vormittags.** Gregors Test an 7.2.1.130 eingetragen …“* |
| [L-122.7](LEKTOR-122.md#l-122.7) README-Zahl | **teilweise** | `README.md:98` *„199 LEKTOR- und PRÜFER-Berichte“*, stimmt an `09c39785` (121 + 78, gemessen). Siehe [L-123.5](#l-123.5) |
| [L-122.8](LEKTOR-122.md#l-122.8) PRÜFER-79 | erledigt (anders als vorgeschlagen) | `Befunde/PRUEFER-79.md:5` *„Die beiden nächsten Kennungen waren zu diesem Zeitpunkt nicht verbraucht (seit 02.11.2026 vergeben: …)“*. Statt zurückgesetzt umformuliert; der Widerspruch ist weg |

Gregors Dateien (nur gelesen, Namen nicht übernommen): Dateizeiten gemessen, siehe [L-123.1](#l-123.1).

## Funde

### <a id="l-123.1"></a>L-123.1 — E-140: „seine zweite Datei kam aus der Postfachliste“ — es war die erste

**Gewicht: mittel.** Der Befund [E-140](../Intern/BEFUNDE.md#e-140) (Speichern unter aus Nachrichten- und Verfassen-Fenster ohne Zeichensatz) beschreibt Gregors Test jetzt richtig im Ergebnis, aber falsch in der Reihenfolge. (gemessen)

`Intern/BEFUNDE.md:429` *„seine zweite Datei kam aus der Postfachliste (Protokoll `E-101 speichern:` ohne Vorsatz …)“*. Dagegen `Intern/TESTPLAN.md:175` *„die erste Datei kam laut Protokoll aus der Postfachliste“*.

Gemessen an Gregors Ablage: Die Textdatei aus der Postfachliste (171 Byte) trägt 23:12:22, die drei Dateien aus dem Verfassen-Fenster 23:13:30, :38 und :46. Im Protokoll steht die Zeile ohne Vorsatz ebenso zuerst ([LEKTOR-122](LEKTOR-122.md#l-122.1): Zeitstempel 1.39 vor 2.47 und 3.02). Die Postfachliste war also die erste Speicherung. Wer nach „zweiter Datei“ sucht, greift zur Antwort als `.txt`, also zur Datei aus dem Verfassen-Fenster.

**Vorschlag:** „zweite“ durch „erste“ ersetzen, wie im TESTPLAN.

### <a id="l-123.2"></a>L-123.2 — TESTPLAN nennt E-194 weiter „in der Datei aus dem Nachrichtenfenster“

**Gewicht: mittel.** Derselbe Absatz widerspricht sich selbst. (gemessen)

`Intern/TESTPLAN.md:175`: vorn *„die erste Datei kam laut Protokoll aus der Postfachliste … nicht aus dem geöffneten Fenster“*, hinten unverändert *„[E-194](../Intern/BEFUNDE.md#e-194) (`<x-flowed>` in der Datei aus dem Nachrichtenfenster)“*. `09c39785` hat in diesem Absatz nur den Anfang geändert (`git diff afe855a8..HEAD -- Intern/TESTPLAN.md`). [E-194](../Intern/BEFUNDE.md#e-194) selbst (`Intern/BEFUNDE.md:401`) nennt die Postfachliste.

**Vorschlag:** „in der Datei aus der Postfachliste“.

### <a id="l-123.3"></a>L-123.3 — E-143: „Offen“ und „Was noch fehlt“ sagen weiter „nicht entschieden“ und „nicht gemessen“

**Gewicht: Kleinkram.** Das Urteil von [E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis je Nachricht aus Suchfenster und Filtern) ist auf dem neuen Stand, die beiden Sätze weiter hinten nicht. (gemessen)

`Intern/BEFUNDE.md:395`:

- unverändert *„**Offen:** das Suchfenster (zwanzig Treffer nach `Out` übertragen ergeben weiter zwanzig Hinweise) — nicht Teil der Entscheidung.“*, direkt vor *„**Gregors Entscheidung (02.11.2026, Chat):**“*;
- *„**Was noch fehlt:** die Messung am Programm mit dem Testpaket 7.2.1.130 ([TESTPLAN](../Intern/TESTPLAN.md#e-143-naechstes)); für das Suchfenster eine eigene Entscheidung (gefallen am 02.11.2026, siehe unten).“* Die Messung ist laut Urteil desselben Eintrags an allen drei Filterwegen gemacht, die Entscheidung gefallen. Offen sind der Einbau „ein Hinweis je Übertragung“ und das Übergehen eines alten Filters mit Ziel Out.

Die erzeugten Zeilen übernehmen das: `Intern/WEITERMACHEN.md:97` und `CHANGELOG.md:49` zeigen in der Spalte „gemessen“ jetzt *„02.11.2026 an 7.2.1.130“* und in der Spalte „was zu tun“ zugleich *„die Messung am Programm mit dem Testpaket 7.2.1.130“*.

**Vorschlag:** „Was noch fehlt“ auf „Einbau ein Hinweis je Übertragung im Suchfenster; Übergehen eines alten Filters mit Ziel Out“ setzen, „Offen … nicht Teil der Entscheidung“ streichen, Listen neu erzeugen.

### <a id="l-123.4"></a>L-123.4 — Die entfernten Daten aus Gregors Rechner stehen weiter in `1c75f5c3`

**Gewicht: mittel.** Im heutigen Stand ist nichts mehr davon zu finden ([L-122.3](LEKTOR-122.md#l-122.3) erledigt). In der Geschichte des Zweigs schon. (gemessen; Folge belegt)

`git show 1c75f5c3 | grep -c` nach Freigabepfad und Betreff: 5 Treffer (gemessen). `1c75f5c3` ist nicht auf `main` (`git merge-base --is-ancestor 1c75f5c3 origin/main` → nein). Die PRs werden bisher als Merge-Commit übernommen, nicht gequetscht: `origin/main` steht auf `99e77aa1` *„Merge pull request #198 …“* mit zwei Eltern (gemessen). Mit einem gewöhnlichen Merge kommt `1c75f5c3` samt Pfad und Dateinamen in die Geschichte von `main`, und dort bleibt es auch nach dem Berichtigen lesbar. [Gedächtnis ist öffentlich](../Arbeitsweise/gedaechtnis-ist-oeffentlich.md): *„Ein Pfad aus Gregors Rechner ist ein Name aus Gregors Rechner.“*

Der Inhalt bleibt harmlos (eine Testmail an sich selbst, der Ordnername der VM).

**Vorschlag:** Diesen PR gequetscht mergen (*Squash and merge*); dann erscheint nur der Endstand auf `main`. Wie gemergt wird, entscheidet Gregor, siehe unten.

### <a id="l-123.5"></a>L-123.5 — README: Zahl von Hand nachgezogen, Zähldatum nicht; mit diesem Bericht wieder veraltet

**Gewicht: Kleinkram.** (gemessen)

`README.md:98-99` *„199 LEKTOR- und PRÜFER-Berichte … beides am 01.11.2026 mit `git ls-files` gezählt“*. 199 stimmt an `09c39785` (121 LEKTOR + 78 PRÜFER), gezählt wurde aber am 02.11. Mit diesem Bericht sind es 200, zum siebten Mal veraltet. Der Vorschlag aus [L-120.6](LEKTOR-120.md#l-120.6), [L-121.4](LEKTOR-121.md#l-121.4) und [L-122.7](LEKTOR-122.md#l-122.7), die Zahl zu erzeugen oder zu streichen, ist nicht umgesetzt.

### <a id="l-123.6"></a>L-123.6 — E-195: die übrigen Aufrufer von `CSaveAs` fehlen

**Gewicht: Kleinkram.** (gemessen)

`Intern/BEFUNDE.md:400` nennt für `saveas.cpp:92` nur *„(`CSaveAs`, Speichern aus dem geöffneten Nachrichtenfenster)“*. `saveas.cpp:92` *„CRString Filter(IDS_TXT_HTML_FILE_FILTER);“* gilt für jeden `CSaveAs`: in `Eudora71/` außerdem `PgReadMsgView.cpp:620`, `Trnslate.cpp:1964`, `:2106`, `filtersd.cpp:2113` und `DirectoryServices/…/DSPrintEdit.cpp:102` (`git grep -n 'CSaveAs '`, gemessen). Wer `.rtf` aus dem Filter streicht, ändert es an allen diesen Stellen mit.

**Vorschlag:** die Aufrufer in den Eintrag schreiben.

## Zur Kenntnis

- `Intern/WEITERMACHEN.md:3` *„Danach Zweig `e177_filter_programm` (Testplan [E-178](../Intern/BEFUNDE.md#e-178) schon eindeutig gemacht, dann [E-177](../Intern/BEFUNDE.md#e-177))“*: Die Berichtigung des Testplans steht als `23e624af` nur auf `origin/e177_filter_programm`, nicht in diesem Zweig (`git merge-base --is-ancestor 23e624af HEAD` → nein). Hier zeigt `Intern/TESTPLAN.md:222` weiter *„**Vorher das Postfach sichern.**“* ohne Anleitung. Als Aussage über den anderen Zweig stimmt der Satz.
- Die neuen Verweise in BEFUNDE lauten `[LEKTOR-122](../Befunde/LEKTOR-122.md) L-122.1` ohne Sprungmarke `#l-122.1`. Sie führen an den Anfang des Berichts statt zum Fund.
- `ImapAppend.cpp:691` in [E-194](../Intern/BEFUNDE.md#e-194) (eine Zeile Versatz, aus [LEKTOR-122](LEKTOR-122.md#lektor-122) „Zur Kenntnis“) ist unverändert.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“*; „Zur Kenntnis“ dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-122](LEKTOR-122.md#lektor-122).

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  50
      davon aktuell gemessen       5  (ab Nummer 125)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     28
      davon NIE gemessen          17
    in Intern/WEITERMACHEN.md     50

  50 offene Befunde, in beiden Listen gleich.
```

Gegenüber [LEKTOR-122](LEKTOR-122.md#lektor-122) ist [E-143](../Intern/BEFUNDE.md#e-143) von „nie gemessen“ zu „aktuell gemessen“ gewandert (4 → 5, 18 → 17), wie dort vorgeschlagen.

`perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“*

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

- Den PR für `test_1130_ergebnisse` gequetscht mergen (*Squash and merge*), damit Freigabepfad und Dateinamen aus `1c75f5c3` nicht in die Geschichte von `main` kommen ([L-123.4](#l-123.4))? Bisher wurde mit Merge-Commit gemergt; gemergt wird nur von Gregor.

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Gegengelesen: `git diff 6aeac4cf..origin/test_1130_ergebnisse` (ein Commit `f4f9116f`, fünf Dateien), nach `tools/arbeitsbaum-angleichen.sh`. Alle sechs Funde sind erledigt (gemessen):

| Fund | Stand | Stelle |
|---|---|---|
| [L-123.1](#l-123.1) [E-140](../Intern/BEFUNDE.md#e-140) „zweite Datei“ | erledigt | `Intern/BEFUNDE.md:429` jetzt *„seine erste (23:12) Datei kam aus der Postfachliste“* |
| [L-123.2](#l-123.2) TESTPLAN zu [E-194](../Intern/BEFUNDE.md#e-194) | erledigt | `Intern/TESTPLAN.md:175` *„(`<x-flowed>` in der Datei aus der Postfachliste)“* |
| [L-123.3](#l-123.3) [E-143](../Intern/BEFUNDE.md#e-143) Restsätze | erledigt | `Intern/BEFUNDE.md:395` *„**Suchfenster:** … nicht Teil der Entscheidung vom 01.11.2026, entschieden am 02.11.2026“*, *„**Was noch fehlt:** der Filterteil ist am Programm gemessen … bis auf das Übergehen eines alten Out-Filters beim Abruf; das Suchfenster ist entschieden (ein Hinweis je Übertragung) und noch einzubauen.“*; die erzeugten Zeilen in `Intern/WEITERMACHEN.md` und `CHANGELOG.md` ziehen mit |
| [L-123.4](#l-123.4) Namen in `1c75f5c3` | erledigt durch Entscheidung | laut Hauptagent hat Gregor *Squash and merge* für diesen PR bestätigt (belegt nur durch die Nachricht des Hauptagenten); im Stand weiter 0 Treffer |
| [L-123.5](#l-123.5) README-Zahl | erledigt | `README.md:98-99` *„200 LEKTOR- und PRÜFER-Berichte … am 02.11.2026 mit `git ls-files` gezählt“*; 122 LEKTOR + 78 PRÜFER = 200 (gemessen) |
| [L-123.6](#l-123.6) [E-195](../Intern/BEFUNDE.md#e-195) Aufrufer | erledigt | `Intern/BEFUNDE.md:400` *„`ReadMessageDoc.cpp:597` und `PgReadMsgView.cpp:620`, außerdem `Trnslate.cpp:1964`/`:2106`; die Filteraktion `filtersd.cpp:2113` legt die Datei ohne Dialog an“* |

Zur Kenntnis, kein Fund: `DSPrintEdit.cpp:102` (Verzeichnisdienste) fehlt in der Aufruferliste von [E-195](../Intern/BEFUNDE.md#e-195). Das neue Zähldatum der README gilt auch für die *„124 Lehren“*. Mein Filter (`.md` unter `Arbeitsweise/` ohne `stand-`, `CHRONIST`, `entscheidung`, `README`) zählt 125. Ob der README-Filter derselbe ist, habe ich nicht geprüft (Vermutung: eine Lehre seit dem 01.11.).
