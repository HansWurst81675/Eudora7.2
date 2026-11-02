# <a id="lektor-122"></a>LEKTOR-122 — Bestand nach Gregors Test an 7.2.1.130, Zweig test_1130_ergebnisse nach 5411527d (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-121](LEKTOR-121.md#lektor-121).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102`, Stand `5411527d`.

## Kurz

Die vier Funde aus [LEKTOR-121](LEKTOR-121.md#lektor-121) sind erledigt, nur die README-Zahl der Prüfberichte ist zum sechsten Mal veraltet. Die neue Buchführung zu Gregors Test an 7.2.1.130 stimmt in den Bytes: alle vier abgelegten Dateien haben die beschriebene Größe und den beschriebenen Inhalt. **In einem Punkt zieht sie aber den falschen Schluss** ([L-122.1](#l-122.1)): Die erste Textdatei hat Gregor nicht aus dem geöffneten Nachrichtenfenster gespeichert, sondern aus der Postfachliste. Sein Protokoll hat dafür die Zeile des alten Weges von [E-101](../Intern/BEFUNDE.md#e-101), nicht die Zeile `E-140 speichern aus Nachrichtenfenster`, und das Nachrichtenfenster ging erst 56 Sekunden später auf. Damit ist [E-140](../Intern/BEFUNDE.md#e-140) (Speichern unter aus Nachrichten- und Verfassen-Fenster ohne Zeichensatz) bei Gregor nur für das Verfassen-Fenster bestätigt. Und [E-194](../Intern/BEFUNDE.md#e-194) (`<x-flowed>` steht in der gespeicherten Datei) sucht den Ort im falschen Code ([L-122.2](#l-122.2)). Dazu kommen Pfad, Betreff und Dateinamen aus Gregors Rechner in drei neuen Befundzeilen ([L-122.3](#l-122.3)), und [E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis je Nachricht aus Suchfenster und Filtern) widerspricht sich nach Gregors Entscheidung vom 02.11. ([L-122.4](#l-122.4)). Acht Funde, keiner am Programm. Nach Auftrag ist **keiner berichtigt**, nur dieser Bericht und `Intern/LEKTORAT.md` sind geändert. 50 Befunde offen (47 + [E-194](../Intern/BEFUNDE.md#e-194), [E-195](../Intern/BEFUNDE.md#e-195), [E-196](../Intern/BEFUNDE.md#e-196)).

## Funde aus LEKTOR-121

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-121.1](LEKTOR-121.md#l-121.1) Kopf `messen-e184m.ps1` | erledigt | `tools/messen-e184m.ps1:7` *„Bereiche "[COPYUID 1 1:3 1:3]"“*, `:10` *„E184M ERGEBNIS richtig=3 falsch=0 eintraege=3 anfrage=3,2,1 copyuid=1:3/1:3“*, `:11-12` *„rot am Bau 6e9a43ba (… richtig=1 falsch=2, anfrage=3,2,1), gruen mit der Behebung (Bau 83908112*)“* |
| [L-121.2](LEKTOR-121.md#l-121.2) jüngster Bau bei [E-184](../Intern/BEFUNDE.md#e-184) | erledigt | `Intern/BEFUNDE.md:406` *„zuletzt Bau `83908112*` mit dem Mengenleser für Bereiche“* |
| [L-121.3](LEKTOR-121.md#l-121.3) zwei K4 bei [E-184](../Intern/BEFUNDE.md#e-184) | erledigt | `Intern/BEFUNDE.md:406` *„nicht zu verwechseln mit K4 aus PRÜFER-75 weiter unten“*, *„**Was noch fehlt:** K4 aus PRÜFER-75 (…); PRÜFER-78 K2 (Teilkopie, klein)“* |
| [L-121.4](LEKTOR-121.md#l-121.4) README-Zahl | **wieder veraltet** | siehe [L-122.7](#l-122.7) |
| Nachtrag `ImapMoveMsgsToTrash` in [E-184](../Intern/BEFUNDE.md#e-184) | erledigt | `Intern/BEFUNDE.md:406` *„`CTocDoc::ImapMoveMsgsToTrash` und `CTocDoc::ImapChangeMsgsJunkStatus` in `ImapToc.cpp`“* |

## Was seit 46651f45 dazukam

Gelesen: `git log --stat 46651f45..HEAD`, sieben Commits. Im Prüfbereich (ohne `Arbeitsweise/` und `Befunde/`) geändert: `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `CHANGELOG.md`, `tools/ZWEIGE.md`; dazu `Befunde/PRUEFER-79.md` (siehe [L-122.8](#l-122.8)). Die übrigen 59 MD-Dateien sind seit [LEKTOR-121](LEKTOR-121.md#lektor-121) unverändert. Dort habe ich nur gesucht, ob sie über den Stand etwas sagen, das der Test vom 01./02.11. überholt hat (`git grep` nach Zweignamen, „im Test“, 7.2.1.130).

Gregors Dateien: vier gespeicherte Dateien, `eudora.log`, `eudora.log_v1`, `Eudora.ini`, ein Bildschirmfoto. Nur gelesen, Namen und Inhalte nicht übernommen.

| Angabe | Stelle | Ergebnis |
|---|---|---|
| Gregor testete an 7.2.1.130 | [E-140](../Intern/BEFUNDE.md#e-140), [E-143](../Intern/BEFUNDE.md#e-143) | stimmt: `eudora.log:18403` *„Version 7.2.1.130“*; Titelzeile im Bildschirmfoto *„Eudora 7.2.1.130+955d50d4*“* (gemessen) |
| `.htm` 175 Byte, `E4 FC F6 DF`, `80`, kein `<meta>`, kein `<head>` | `Intern/BEFUNDE.md:399` ([E-196](../Intern/BEFUNDE.md#e-196): `.htm` ohne Zeichensatzangabe) | stimmt (gemessen mit `od -c`): Datei beginnt mit `<html>\r\n<body>`, Umlaute `344 374 366 337`, Euro `200` |
| keine Protokollzeile für den `.htm`-Weg | ebd. | stimmt: zwischen `eudora.log:18347` (2.47) und `:18358` (3.02) steht keine Speicherzeile; die Dateizeiten liegen bei 23:13:30, :38, :46, also die `.htm` zwischen den beiden protokollierten (gemessen) |
| HTML-Zweig ohne `E140TextFuerDatei` | ebd. | stimmt: `compmsgd.cpp:3429-3430` *„view->GetMessageAsHTML(…); msg = Text2Html(dateMaybe, TRUE, FALSE) + msg;“*, `ReadMessageDoc.cpp:626` (gemessen) |
| `.rtf` und `.txt` je 179 Byte, gleich | `Intern/BEFUNDE.md:400` ([E-195](../Intern/BEFUNDE.md#e-195): `.rtf` liefert Klartext) | stimmt: `cmp` meldet keinen Unterschied (gemessen) |
| `IDS_TXT_HTML_FILE_FILTER` mit `.rtf` | ebd. | stimmt: `EudoraRes.rc:8541-8542`, benutzt in `compmsgd.cpp:3358` (gemessen); die Zuordnung von `saveas.cpp:92` stimmt nicht, siehe [L-122.5](#l-122.5) |
| Textdatei mit `<x-flowed>`, 171 Byte, `rumpf-vorher=65 rumpf-nachher=65 mime-ergaenzt=1` | `Intern/BEFUNDE.md:401` ([E-194](../Intern/BEFUNDE.md#e-194)) | Bytes und Werte stimmen (gemessen); der Weg stimmt nicht, siehe [L-122.1](#l-122.1) und [L-122.2](#l-122.2) |
| [E-143](../Intern/BEFUNDE.md#e-143): Out im *Make Filter*-Menü grau | `Intern/BEFUNDE.md:395`, `Intern/TESTPLAN.md:273` | stimmt am Bildschirmfoto: Out grau, In, Junk, Trash und die übrigen Postfächer schwarz (gemessen). Die Bestätigungen vom 02.11. (Filterfenster, geöffnete Nachricht, Hauptmenü) beruhen auf Bildschirmfotos im Chat; in den abgelegten Dateien sind sie nicht enthalten, `eudora.log` endet am 01.11. um 23:16 (belegt nur durch den Commit) |
| Gregors Entscheidung zum Suchfenster | `Intern/BEFUNDE.md:395` *„**Gregors Entscheidung (02.11.2026, Chat):** *„ja, ein hinweis reicht, richtig.“*“* | Wortlaut nicht nachprüfbar (Chat); als Entscheidung klar: Übertragung nach Out im Suchfenster bleibt erlaubt, ein Hinweis je Übertragung. Folgen siehe [L-122.4](#l-122.4) |
| ZWEIGE-Zeile `test_1130_ergebnisse` | `tools/ZWEIGE.md:206` *„Nur Dokumentation.“* | stimmt: `git diff --stat 99e77aa1..HEAD` nennt nur `.md`-Dateien (gemessen) |
| Begriffe aus `tools/anonym-begriffe.lokal` im Diff | — | 0 von 11 Begriffen getroffen, keine Mailadresse (gemessen). Das sagt nur „nach diesen Begriffen sauber“, siehe [L-122.3](#l-122.3) |

## Funde

### <a id="l-122.1"></a>L-122.1 — E-140 „aus dem Nachrichtenfenster bestätigt“: Gregor hat aus der Postfachliste gespeichert

**Gewicht: wichtig.** Der Befund [E-140](../Intern/BEFUNDE.md#e-140) (Speichern unter aus dem geöffneten Nachrichten- und dem Verfassen-Fenster schreibt ohne Zeichensatz) gilt als bei Gregor bestätigt. Der Weg über das Nachrichtenfenster ist bei ihm aber gar nicht gelaufen. (gemessen)

`Intern/BEFUNDE.md:429` ([E-140](../Intern/BEFUNDE.md#e-140)): *„von Gregor am 01.11.2026 an 7.2.1.130 bestätigt: beide `.txt`-Dateien (Nachrichten- und Verfassen-Fenster) tragen `MIME-Version`, `Content-Type: text/plain; charset="windows-1252"`“*. Ebenso `Intern/TESTPLAN.md:171`.

Gemessen an Gregors `eudora.log`:

- `:18258` (Zeitstempel 1.39) *„Dialog: "[E-101](../Intern/BEFUNDE.md#e-101) speichern: kopfzeilen=0 … bytes-vorher=65 nachher=169 rumpf-vorher=65 …"“*: **ohne** Vorsatz `E-140 speichern aus …`.
- `:18347` (2.47) und `:18358` (3.02) *„Dialog: "[E-140](../Intern/BEFUNDE.md#e-140) speichern aus Verfassen-Fenster: [E-101](../Intern/BEFUNDE.md#e-101) speichern: …"“*.
- `:18263`/`:18268` (2.35): das Nachrichtenfenster der Mail wird **erst jetzt** angelegt (`E-34 NewChildFrame`). Vorher steht nur die Vorschau im Postfachfenster (`:18248` `E-80 trident: … konzentriert=1`).

Die Zeitstempel passen zu den Dateien: Von 1.39 bis 2.47 sind es 68 s, von der ersten Textdatei (23:12:22) bis zur Antwort als `.txt` (23:13:30) ebenfalls 68 s.

Am Quelltext: Die Zeile ohne Vorsatz schreibt nur die Postfachliste, `tocview.cpp:3223` *„PutDebugLog( DEBUG_MASK_DIALOG, szSpurE101 );“* in `CTocView::OnFileSaveAs`. Das Nachrichtenfenster schreibt in beiden Textzweigen über `E140TextFuerDatei( …, "Nachrichtenfenster" )` (`ReadMessageDoc.cpp:654`, `:667`), und diese Funktion setzt immer `E-140 speichern aus %s:` davor (`msgutils.cpp:4661`). Eine Zeile `E-140 speichern aus Nachrichtenfenster` steht in Gregors Protokoll nicht (`grep` gemessen).

**Folge:** [E-140](../Intern/BEFUNDE.md#e-140) ist bei Gregor nur für das Verfassen-Fenster bestätigt. Für das Nachrichtenfenster gibt es nur die Prüfstandsmessung vom 31.10. Schritt 1 im TESTPLAN (`Intern/TESTPLAN.md:160-161` *„im lokalen *In* **öffnen**, *File → Save As*“*) hat das nicht verhindert: Wer die Nachricht in der Vorschau sieht, hält sie für geöffnet.

**Vorschlag:**

- In BEFUNDE und TESTPLAN „beide“ durch „Verfassen-Fenster bestätigt; die erste Datei kam aus der Postfachliste (Protokoll ohne `E-140 speichern aus Nachrichtenfenster`)“ ersetzen.
- Den TESTPLAN-Schritt mit „Doppelklick, eigenes Fenster“ und der erwarteten Protokollzeile ergänzen und beim nächsten Paket wiederholen.

### <a id="l-122.2"></a>L-122.2 — E-194 sucht den Ort im Nachrichtenfenster; die Klammern kommen aus der Postfachliste

**Gewicht: mittel.** Wer [E-194](../Intern/BEFUNDE.md#e-194) (`<x-flowed>` steht in der gespeicherten Datei) beheben will, sucht an der falschen Stelle. (Ort gemessen; Ursache belegt am Quelltext)

`Intern/BEFUNDE.md:401`: Titel *„*Speichern unter* aus dem geöffneten Nachrichtenfenster schreibt `<x-flowed>`“*, *„**Ort, noch nicht gemessen:** `CReadMessageDoc::SaveAsFile` (`ReadMessageDoc.cpp`) holt den Text über `GetMessageAsText` der Leseansicht — `PgReadMsgView.cpp:671` (Paige) oder `TridentReadMessageView.cpp:2946` (Trident)“*. `Intern/TESTPLAN.md:171` nennt [E-194](../Intern/BEFUNDE.md#e-194) ebenso *„in der Datei aus dem Nachrichtenfenster“*.

Nach [L-122.1](#l-122.1) stammt die Datei aus `CTocView::OnFileSaveAs`. Dort wird der Rumpf roh aus dem Postfach genommen: `tocview.cpp:3122` *„pDoc->GetFullMessage()“*, `:3130` *„FindBody(pszFullMessage)“*. Danach läuft er durch den Kern von [E-101](../Intern/BEFUNDE.md#e-101), `tocview.cpp:3186` *„E101SpeicherfassungAufbereiten“*. Der Kern entfernt nur `<x-html>` (`msgutils.cpp:4001` *„if ( szKlein.Left( 7 ) == "<x-html" )“*); `<x-flowed>` kommt in der Funktion nicht vor (`grep` gemessen). Gregors eigene Protokollzeile im Eintrag (`rumpf-vorher=65 … mime-ergaenzt=1`, ohne `E-140 speichern aus`) ist schon der Beleg.

Nach [CLAUDE.md](../CLAUDE.md) §2 gehört der Ort zu [E-101](../Intern/BEFUNDE.md#e-101): Derselbe Kern sollte Eudoras interne Markierung schon für `<x-html>` entfernen. `perl tools/befund-suchen.pl tocview.cpp` nennt [E-101](../Intern/BEFUNDE.md#e-101) und [E-104](../Intern/BEFUNDE.md#e-104). Ob das Nachrichtenfenster die Klammern **auch** durchlässt, ist offen (Vermutung: nein, weil es über die Ansicht geht).

**Vorschlag:** Den Ort in [E-194](../Intern/BEFUNDE.md#e-194) auf `tocview.cpp`/`E101SpeicherfassungAufbereiten` umschreiben und [E-101](../Intern/BEFUNDE.md#e-101) als Ursprung nennen. Die Paige- und Trident-Stellen nur als zweite, ungemessene Frage stehen lassen.

### <a id="l-122.3"></a>L-122.3 — Pfad, Betreff und Dateinamen aus Gregors Rechner in den neuen Befundzeilen

**Gewicht: mittel.** Das Repo ist öffentlich, und der Zweig ist gepusht. Auf `main` ist es noch nicht: `git merge-base --is-ancestor 1c75f5c3 origin/main` → nein (gemessen).

Seit `1c75f5c3` stehen im Repo (hier bewusst nicht wiederholt, gemessen mit `git grep`):

- `Intern/BEFUNDE.md:399` ([E-196](../Intern/BEFUNDE.md#e-196)): der volle Pfad des Freigabeordners der VM samt Name der Sicherung.
- `Intern/BEFUNDE.md:399`, `:400`, `:401` ([E-196](../Intern/BEFUNDE.md#e-196), [E-195](../Intern/BEFUNDE.md#e-195), [E-194](../Intern/BEFUNDE.md#e-194)): die Namen der vier gespeicherten Dateien. Sie sind aus dem Betreff gebildet, in `:401` steht der Betreff selbst.
- `Intern/BEFUNDE.md:395` ([E-143](../Intern/BEFUNDE.md#e-143)): der Dateiname des Bildschirmfotos.
- Außerhalb meines Prüfbereichs derselbe Pfad in `Arbeitsweise/stand-01-11-2026.md:53`.

Der Inhalt ist harmlos (eine Testmail an sich selbst), aber die Regel fragt nicht danach. [Gedächtnis ist öffentlich](../Arbeitsweise/gedaechtnis-ist-oeffentlich.md), Nachtrag 30.10.: *„Ein Pfad aus Gregors Rechner ist ein Name aus Gregors Rechner.“* Derselbe Pfad wurde am 30.10. schon einmal aus einer Lehre und aus [E-148](../Intern/BEFUNDE.md#e-148) entfernt. Die Begriffsliste `tools/anonym-begriffe.lokal` findet nichts davon (0 von 11, gemessen), denn sie sucht nicht nach Pfaden.

**Vorschlag:** Platzhalter wie *„Gregors Ablage zu 7.2.1.130“*, *„Datei 1 (171 Byte)“*, *„Antwort als `.txt`/`.htm`/`.rtf`“*, *„Bildschirmfoto vom 01.11.“*. Das vor dem Merge erledigen, dann kommt es nicht auf `main`.

### <a id="l-122.4"></a>L-122.4 — E-143 nach Gregors Entscheidung: drei Sätze sagen „nicht entschieden“, die Listen sagen „nie gemessen“

**Gewicht: mittel.** Der Eintrag [E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis je Nachricht aus Suchfenster und Filtern) sagt vorn und hinten das Gegenteil seiner neuen Mitte. (gemessen)

`Intern/BEFUNDE.md:395`:

- im Urteil *„das Suchfenster ist nicht entschieden.“*;
- weiter *„**Offen:** das Suchfenster … — nicht Teil der Entscheidung.“*;
- direkt danach seit `5411527d` *„**Gregors Entscheidung (02.11.2026, Chat):** *„ja, ein hinweis reicht, richtig.“*“*;
- am Ende *„**Was noch fehlt:** die Messung am Programm mit dem Testpaket 7.2.1.130 (…); für das Suchfenster eine eigene Entscheidung.“*

Beides in „Was noch fehlt“ ist erledigt. Offen sind der Einbau „ein Hinweis je Übertragung“ und das Übergehen eines alten Filters mit Ziel Out (`Intern/TESTPLAN.md:273` *„das Übergehen ist am Programm noch nicht gemessen“*).

Die erzeugten Zeilen übernehmen den alten Stand: `Intern/WEITERMACHEN.md:97` und `CHANGELOG.md:49` *„**nie gemessen** | die Messung am Programm mit dem Testpaket 7.2.1.130 …; für das Suchfenster eine eigene Entscheidung.“* „nie gemessen“ entsteht, weil im Urteil keine Marke `**Zuletzt gemessen: 02.11.2026 an 7.2.1.130**` steht (`tools/offene-befunde.pl:210`). Gemessen ist der Filterteil aber, an allen drei Wegen.

`Intern/WEITERMACHEN.md:162` (Entscheidung 24) endet weiter mit *„das Suchfenster ist nicht Teil der Entscheidung.“* Die Entscheidung vom 02.11. fehlt dort. Eine Entscheidungsdatei unter `Arbeitsweise/entscheidung-*` gibt es zu ihr auch nicht (`ls` gemessen).

**Vorschlag:**

- Urteil und „Was noch fehlt“ auf den neuen Stand bringen, mit Marke „Zuletzt gemessen“ (Filterteil).
- Die Listen mit `offene-befunde.pl -schreiben` neu erzeugen.
- Bei Entscheidung 24 einen Satz zum 02.11. ergänzen.

### <a id="l-122.5"></a>L-122.5 — E-195: `saveas.cpp:92` dient nicht der Postfachliste

**Gewicht: Kleinkram.** (gemessen)

`Intern/BEFUNDE.md:400` *„derselbe Text steht auch in `saveas.cpp:92` (`CSaveAs`, Speichern aus Nachrichtenfenster und Postfachliste)“*.

Die Postfachliste benutzt `CSaveAsDialog` mit `IDS_TEXT_FILE_FILTER` (`tocview.cpp:3066-3071`), und das ist `"Text Files (*.txt)|*.txt|All Files (*.*)|*.*|"` (`EudoraRes.rc:8531`), also ohne `.rtf`. `CSaveAs` benutzen `ReadMessageDoc.cpp:597` (Nachrichtenfenster), `PgReadMsgView.cpp:620`, `Trnslate.cpp:1964`, `:2106` und `filtersd.cpp:2113`.

**Vorschlag:** „Postfachliste“ durch die tatsächlichen Aufrufer ersetzen. Zum Streichen von `.rtf` gehören dann diese fünf Stellen.

### <a id="l-122.6"></a>L-122.6 — WEITERMACHEN-Kopf steht auf dem 01.11. abends

**Gewicht: Kleinkram.** (gemessen)

`Intern/WEITERMACHEN.md:3` *„**Stand 01.11.2026 abends.** Testpaket **7.2.1.130** bei Gregor im Test … Zweig `e184_mehrere_mails`: Rest von [E-184](../Intern/BEFUNDE.md#e-184) … im Quelltext berichtigt“*. Seither ist #198 gemergt (`99e77aa1`), und Gregors Ergebnisse sind eingetragen: [E-140](../Intern/BEFUNDE.md#e-140) und [E-143](../Intern/BEFUNDE.md#e-143) bestätigt, [E-194](../Intern/BEFUNDE.md#e-194) bis [E-196](../Intern/BEFUNDE.md#e-196) neu, Entscheidung zum Suchfenster. Der Kopf nennt keines davon. `1c75f5c3` und `5411527d` haben in WEITERMACHEN nur die erzeugten Tabellenzeilen geändert.

### <a id="l-122.7"></a>L-122.7 — README: Zahl der Prüfberichte zum sechsten Mal veraltet

**Gewicht: Kleinkram.** (gemessen)

`README.md:98` *„196 LEKTOR- und PRÜFER-Berichte“*. Am Stand `5411527d` sind es 120 + 78 = 198 (`git ls-files Befunde | grep -cE '/LEKTOR-[0-9]+\.md$'` bzw. `PRUEFER`), mit diesem Bericht 199. Vorschlag wie in [L-120.6](LEKTOR-120.md#l-120.6) und [L-121.4](LEKTOR-121.md#l-121.4): die Zahl erzeugen oder streichen.

### <a id="l-122.8"></a>L-122.8 — PRÜFER-79 nachträglich verlinkt: „E-194 und E-195 sind nicht verbraucht“ zeigt jetzt auf vergebene Einträge

**Gewicht: Kleinkram.** (gemessen)

`1c75f5c3` änderte `Befunde/PRUEFER-79.md:5` von `Die Kennungen E-194 und E-195 sind nicht verbraucht.` (ohne Verweise) zu *„Die Kennungen [E-194](…#e-194) und [E-195](…#e-195) sind nicht verbraucht.“* Das war vermutlich `befunde-verlinken.pl`. Der Satz war am 01.11. richtig. Mit Verweis auf die inzwischen vergebenen Einträge liest er sich wie ein Widerspruch, und ein abgeschlossener Prüfbericht ist ohne Anlass geändert. **Vorschlag:** die Zeile auf den alten Text zurücksetzen. Ob der Verlinker solche Sätze auslassen soll, entscheidet der Hauptagent.

## Zur Kenntnis

- `perl tools/doku-pruefen.pl` „Zur Kenntnis“: dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-121](LEKTOR-121.md#lektor-121) (u. a. `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md`).
- `CHANGELOG.md`, Abschnitt 7.2.1.130 (`:134`): kein Satz zu Gregors Ergebnissen. Die stehen in BEFUNDE und TESTPLAN, und die Tabelle oben ist erzeugt. Eine Frage der Form, kein Fund.
- `README.md:187` (Bekannte Fehler, [E-143](../Intern/BEFUNDE.md#e-143)) beschreibt das veröffentlichte 7.2.1.128 und stimmt dafür.
- Verweis in [E-194](../Intern/BEFUNDE.md#e-194) auf `ImapAppend.cpp:691` für PRÜFER-27 F3: In der Zeile steht heute `}`, `E118Huelle` beginnt in `:692`. Die Funktion ist gemeint, eine Zeile Versatz.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“*; „Zur Kenntnis“ wie oben.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  50
      davon aktuell gemessen       4  (ab Nummer 125)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     28
      davon NIE gemessen          18
    in Intern/WEITERMACHEN.md     50

  50 offene Befunde, in beiden Listen gleich.
```

Von 47 auf 50 durch [E-194](../Intern/BEFUNDE.md#e-194), [E-195](../Intern/BEFUNDE.md#e-195) und [E-196](../Intern/BEFUNDE.md#e-196), „nie gemessen“ von 15 auf 18 aus demselben Grund. Darunter zählt [E-143](../Intern/BEFUNDE.md#e-143), obwohl Gregor den Filterteil gemessen hat ([L-122.4](#l-122.4)).

`perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“* Die Einstufung ist mitgezählt: unkritisch 45, zusammen 231, wie die Stufentabelle `Intern/BEFUNDE.md:157ff`.

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

Nichts Neues. Ob [E-140](../Intern/BEFUNDE.md#e-140) für das Nachrichtenfenster ein eigener Testschritt im nächsten Paket wird ([L-122.1](#l-122.1)), ist Reihenfolge der Tests und liegt beim Hauptagenten.
