# <a id="pruefer-78"></a>PRUEFER-78 - Prüfung seit 3921f6de (E-184 Rest K3, Haken gegen Eudora-Starts, auftrag-rolle.pl)

## Ergebnis vorweg

Die Behebung von [E-184](../Intern/BEFUNDE.md#e-184) Rest K3 ist für den Weg, für den sie gebaut wurde, richtig: Verschiebt man mehrere Mails innerhalb eines IMAP-Kontos und ist die Liste nicht nach Nummer aufsteigend sortiert, bekommt jetzt jede Mail im Zielordner ihre eigene neue Nummer. Quell- und Zielmenge bleiben auch bei mehreren COPY-Abschnitten parallel, und meldet der Server nichts Brauchbares, fällt alles sauber auf [E-189](../Intern/BEFUNDE.md#e-189) zurück. Es gibt aber drei andere Wege, die mehrere Mails auf dem Server kopieren und weiter nach Listenposition zuordnen: Papierkorb, Junk und Filter. Dort stehen die Einträge weiter über Kreuz, und durch das neue Zurücksetzen jetzt bei allen verschobenen Mails statt bei einer (K1, wichtig, Original). Der neue Haken gegen direkte Eudora-Starts lässt zehn von vierzehn naheliegenden Startformen durch, darunter `cmd //c` aus Git Bash und `powershell -Command "& '…'"` (K5, gemessen). Die rote Gegenprobe zu E-184m hat in Wahrheit einen anderen Fehler gemessen als den behobenen (K7). Kein Fund hält das nächste Paket auf. Testsuite: 357/357 (gemessen).

## Geprüft

Umfang aus `git log 3921f6de..HEAD -- Eudora71 tools Releases/1.0` (gemessen): 2fd14adc ([E-184](../Intern/BEFUNDE.md#e-184) K3), c4e883a9 (tools/haken-eudora-start.pl), 8c620666 (tools/auftrag-rolle.pl), 21bc5272 (nur Buchführung in tools/TESTLAEUFE.md, tools/ZWEIGE.md - nicht inhaltlich geprüft).

### 1. Die Kette der Quellmenge

Am Quelltext belegt, Glied für Glied:

- `CImapSameServerTransferMsgAction::DoWork` gibt `&m_dwaQuellUIDs` an `XferMessagesOnServer` (ImapActionQueue.cpp:1948-1953), das an `CopyMessages` (ImapMailbox.cpp:3164), das an `UIDCopy` (ImapConnection.cpp:1061), das je Abschnitt an `CProtocol::Copy` (ImapStream.cpp:1821), das an `StoreUIDPLUSResponses` (proto.cpp:2032).
- `StoreUIDPLUSResponses` liest bei `[COPYUID` beide Mengen mit `E184UidMengeLesen` und hängt sie nur gemeinsam und nur bei gleicher Anzahl an (proto.cpp:2158-2167).
- `DoPostProcessing` gibt dieselbe Menge an `ImapTransferSummaryData` (ImapActionQueue.cpp:1612-1617); dort sucht `j` die alte UID in der Quellmenge und nimmt die neue UID an derselben Stelle (ImapToc.cpp:1586-1599).
- Alle neuen Parameter haben die Vorgabe `NULL`; die übrigen Aufrufer laufen unverändert über `UIDStringToUIDs` (proto.cpp:2171).

### Gegenvermutungen aus dem Auftrag

**(a) Mehrere COPY-Abschnitte (`MAX_UIDS_PER_COMMAND` = 60, ImapStream.cpp:74).** Bleiben parallel. Jeder Abschnitt hängt an beide Felder entweder gleich viel oder nichts an (proto.cpp:2163-2167). `VerifyUIDValidity` leert die Felder nicht - das Leeren ist seit QUALCOMM auskommentiert (proto.cpp, `AccuZap` in `VerifyUIDValidity`). Die Suche über `j` läuft über das ganze Feld, die Reihenfolge der Abschnitte spielt keine Rolle. Am Quelltext belegt. Scheitert ein späterer Abschnitt, bleiben die früheren stehen; das war vorher genauso.

**(b) Server ohne Quellmenge oder mit abweichender Zählung.** Ohne `COPYUID`, mit ungleicher Anzahl oder mit verdorbener Menge kommt nichts an. Dann ist `iSize` = 0, die Schleife läuft nicht, und `E189VorabKopienEntfernen` räumt die Vorab-Kopien weg (ImapActionQueue.cpp:1624). Am Quelltext belegt. Eine Lücke bleibt, wenn der Server nur einen Teil kopiert meldet, siehe K2.

**(c) Bricht das Zurücksetzen von `pSumNew` die Aufrufer ohne `bFindNew`?** Nein, es repariert sie, aber es macht K1 sichtbarer. Bisher bekamen Papierkorb (ImapToc.cpp:2828), Junk (ImapToc.cpp:3134) und Filter (ImapFiltersd.cpp:1304) bei mehreren Mails **eine** neue Zusammenfassung. `AddSum` hängte dieselbe Zusammenfassung N-mal an `m_Sums` an: Ab dem zweiten Durchlauf war `pSumNew` nicht NULL und `bFoundNew` schon `false`, und `InternalAddSum` prüft nicht auf Doppelte (`m_Sums.AddTail`, tocdoc.cpp:1444). So steht es seit QUALCOMM da (567a5d87, ImapToc.cpp:1457-1480). Jetzt bekommt jede Mail ihre eigene. Den Rückgabewert verwendet keiner der vier Aufrufer (grep), dass er im `continue`-Fall jetzt NULL sein kann, schadet also nicht. Am Quelltext belegt. Dass das N-fache Anhängen beim Schließen doppelt freigegeben hätte, ist Vermutung.

**(d) [E-170](../Intern/BEFUNDE.md#e-170), `E170LabelsNachtragen`.** Die Zuordnung ist weiter sicher, sie setzt kein Label auf eine falsche Mail: Sie sortiert alt und neu aufsteigend und gibt bei nicht aufsteigender alter Liste mit `reihenfolge-unsicher` auf (ImapActionQueue.cpp:1719-1728). Sie nutzt die neue Quellmenge aber nicht, und ihr Kommentar ist überholt, siehe K4.

**(e) `ucase(reply->text)` und `strncmp "[COPYUID"`.** `ucase` wandelt an Ort und Stelle um (misc.cpp:32-43). Die Abfrage in proto.cpp:2127 läuft also vor der neuen in proto.cpp:2158, und die sieht schon Großbuchstaben; Groß- und Kleinschreibung des Servers spielt keine Rolle. `Append` ruft ohne Quellmenge (proto.cpp:2092) und landet im unveränderten Zweig `UIDStringToUIDs`. Der APPENDUID-Weg ist also unverändert. Am Quelltext belegt. Nebenbei, alt und unverändert: `s = reply->text + 9` passt nur zu `[COPYUID `; bei `[APPENDUID ` bekommt `VerifyUIDValidity` den Rest „D". Das ist folgenlos, weil die Funktion nur speichert.

### 2. Der Mengenleser `UidMenge.h`

- Listen, Bereiche, fallende Bereiche, Ablehnung von `*`, `0`, Komma am Rand und überlangen Bereichen: in TestE184.cpp im Verhalten abgedeckt (gemessen, grün).
- Überlauf: siehe K3 (gemessen).

### 3. Prüfserver und `tools/messen-e184m.ps1`

- Prüfserver: COPY jetzt in aufsteigender UID-Folge (tools/imap-pruefserver.pl, `sort … keys %gewaehlt_pos`). Die Antwort ist immer eine **Liste** (`join(',', …)`, imap-pruefserver.pl:537), nie ein Bereich. Bei HEADER-Abfragen kommt der Kopf jetzt mit Leerzeile und unter dem verlangten Abschnittsnamen, bei Abfragen nur nach FLAGS/UID/SIZE nur diese Felder. Das ist plausibel und RFC-näher; der HEADER.FIELDS-Abschnitt liefert allerdings weiter den ganzen Kopf, nicht nur die verlangten Felder (harmlos). Am Skript belegt.
- `messen-e184m.ps1` misst, was es behauptet: drei Einträge, jeder mit dem Betreff seiner eigenen UID. Es zählt `richtig`, `falsch` und `eintraege` aus `Ablage.toc`; ein fehlender oder doppelter Eintrag macht den Fall rot (am Skript belegt, messen-e184.ps1 Zeilen nach „E184M ERGEBNIS"). Die Grünmessung ist damit belastbar. Was die rote Gegenprobe gemessen hat, steht in K7.

### 4. `tools/haken-eudora-start.pl`

Selbsttest 23/23 (gemessen). Eigene Gegenprobe mit 14 weiteren Befehlen über stdin wie im Haken-Betrieb, siehe K5.

### 5. `tools/auftrag-rolle.pl`

Die neue Zeile liest `origin/<basis>:Intern/BEFUNDE.md` mit und hängt sie an. Schlägt `git show` fehl, landet die Fehlermeldung im Text; sie enthält keine `<a id="e-…">` und schadet nicht (am Quelltext belegt). Daneben, alt: siehe K6.

## Funde

### K1 - Papierkorb, Junk und Filter ordnen weiter nach Listenposition zu (wichtig, Original; Vorschlag: E-192)

**Klartext.** Mehrere Mails in den IMAP-Papierkorb oder nach Junk verschieben, in einer Liste, die nicht aufsteigend nach Nummer sortiert ist (etwa nach Datum): Im Ziel tragen die Einträge Betreff und Absender der einen Mail, laden aber den Text der anderen. Das ist der Fehler aus PRUEFER-75 K3, nur auf den drei Wegen, die die Behebung nicht erreicht.

Am Quelltext belegt:

- `ImapMoveMsgsToTrash` baut die Liste in Ansichtsreihenfolge (`GetSel(i - iDeleted)`, ImapToc.cpp:2780-2791), ebenso `ImapChangeMsgsJunkStatus` (ImapToc.cpp:2961, 3006ff.). Beide und der Filterweg (ImapFiltersd.cpp:1285, 1304) rufen `XferMessagesOnServer` und `ImapTransferSummaryData` **ohne** Quellmenge. Dann ist `bNachQuelle` falsch, und es gilt `ElementAt(i)` (ImapToc.cpp:1602).
- `ImapAppendSumList` übernimmt beim späteren Abgleich eine vorhandene Zusammenfassung mit passender UID unverändert (ImapMailbox.cpp:4997-5000). Der falsche Kopf bleibt also stehen.
- Durch das Zurücksetzen aus (c) bekommt jetzt **jede** verschobene Mail einen solchen Eintrag. Vorher war es eine Zusammenfassung, mehrfach eingehängt; die übrigen holte der Abgleich frisch vom Server. Es wird also nicht mehr Daten falsch als vorher, aber mehr Zeilen zeigen es. Ob man im Papierkorb nach dem Betreff löscht oder in Junk „kein Junk" wählt: getroffen wird die Mail mit der Server-Nummer, also die andere (Vermutung über die Folge).
- Woher die Liste im Filterweg ihre Reihenfolge hat, habe ich nicht verfolgt.

**Einordnung.** Original von QUALCOMM, keine Regression. Der Eintrag zu [E-184](../Intern/BEFUNDE.md#e-184) sagt „behoben, auch für mehrere Mails"; das gilt nur für das Verschieben über die Warteschlange. **Schwere:** wichtig. Hält das Paket nicht auf (gleiche Einstufung wie PRUEFER-75 K3). **Behebung** (Vorschlag): `MoveMsgsToTrash` und `MoveMsgsToOrFromJunk` um denselben optionalen Parameter erweitern, im Filterweg ein `CDWordArray` dazunehmen und alle drei an `ImapTransferSummaryData` weitergeben. Das ist dieselbe Kette, nur drei Aufrufer mehr. Prüfstandsfall nach dem Muster von E-184m mit „Löschen" statt „Transfer".

### K2 - Meldet der Server nur einen Teil als kopiert, bleiben spätere Mails ohne Zuordnung (klein)

Die Schleife in `ImapTransferSummaryData` endet nach `iSize` alten UIDs (ImapToc.cpp:1568). `iSize` ist die Zahl der **neuen** UIDs. Im Quellmodus zählt aber jede übersprungene alte UID mit (ImapToc.cpp:1595-1596). Beispiel: Liste „3,2,1", der Server kopiert nur 3 und 1 (2 wurde inzwischen anderswo gelöscht) und meldet `[COPYUID v 1,3 10,11]`. Dann bekommt 3 die 11, 2 wird übersprungen, und die Schleife endet, bevor 1 drankommt. Die Vorab-Kopie von 1 bleibt markiert, [E-189](../Intern/BEFUNDE.md#e-189) entfernt sie, und der Abgleich holt die Mail neu vom Server. Lokale Daten wie Label und Status gehen verloren, und [E-170](../Intern/BEFUNDE.md#e-170) gibt mit „anzahl-passt-nicht" auf. Am Quelltext belegt; wie oft Server nur einen Teil kopieren, ist Vermutung (selten). **Behebung** (Vorschlag): Im Quellmodus bis zum Ende der alten Liste laufen, dabei den letzten Eintrag nicht wiederholen. `strLocalUIDList` bleibt nach dem letzten Komma auf dem letzten Wert stehen, ImapToc.cpp:1574-1583. **Hält das Paket nicht auf.**

### K3 - Der Mengenleser lässt zehnstellige Zahlen über 4294967295 überlaufen (gering)

Gemessen, mit drei vorübergehend in TestE184.cpp eingefügten Prüfungen (danach byte-genau zurückgestellt, `cmp` gleich):

- `E184UidMengeLesen("4294967297")` liefert 1 und hängt die UID **1** an (Überlauf).
- `"9999999999:9999999998"` liefert 2 UIDs statt eines Fehlers.
- `"4294967295"` liefert 1, richtig.

Die Grenze `nZiffern > 10` (UidMenge.h:42, :54) fängt elf Stellen ab, aber nicht zehnstellige Werte über 2^32-1. Erreichbar nur mit einem verdorbenen Server, und ein Fehlzuordnung entsteht nur, wenn beide Mengen trotzdem gleich lang sind. **Behebung** (Vorschlag): vor `ulVon * 10 + d` prüfen, ob `ulVon > (0xFFFFFFFFUL - d) / 10`, und dann -1 liefern. Den Fall in die Liste `boese[]` aufnehmen. **Hält das Paket nicht auf.**

### K4 - E-170 nutzt die Quellmenge nicht, der Kommentar ist überholt (klein)

ImapActionQueue.cpp:1723 sagt: „ImapTransferSummaryData ordnet in Listenreihenfolge zu". Mit Quellmenge stimmt das nicht mehr (ImapToc.cpp:1586ff.). Die Funktion ist weiter sicher (siehe (d)). Bei nicht aufsteigender Liste und gleichzeitigem automatischem Löschen (die alte Zusammenfassung ist dann schon fort) gehen Labels aber weiter verloren, obwohl die genaue Zuordnung jetzt in `m_dwaQuellUIDs` bereitläge. Zudem paart [E-170](../Intern/BEFUNDE.md#e-170) sortiert, `ImapTransferSummaryData` dagegen genau. Bei einem Server, der nicht in der Folge der alten UIDs vergibt, würden die beiden verschieden zuordnen (Vermutung, übliche Server vergeben aufsteigend). **Behebung** (Vorschlag): In `E170LabelsNachtragen` bei gleich langer `m_dwaQuellUIDs` über sie paaren und den Kommentar berichtigen. **Hält das Paket nicht auf.**

### K5 - Der Haken gegen Eudora-Starts lässt zehn von vierzehn Startformen durch (mittel, Werkzeug)

Gemessen, jeder Befehl als JSON über stdin an `tools/haken-eudora-start.pl` (Prüfskript im Scratchpad, nicht im Repo):

| Befehl (Pfad gekürzt auf `…\Eudora.exe`) | Haken |
|---|---|
| `cmd //c "C:\…\Eudora.exe"` (Schreibweise aus Git Bash) | durch |
| `cmd //c C:\…\Eudora.exe` | durch |
| `powershell -NoProfile -Command "& 'C:\…\Eudora.exe'"` | durch |
| `bash -c "/c/…/Eudora.exe"` | durch |
| `(cd /c/Temp/E184 && ./Eudora.exe)` | durch |
| `{ /c/…/Eudora.exe; }` | durch |
| `if true; then /c/…/Eudora.exe; fi` | durch |
| `timeout 5 /c/…/Eudora.exe` | durch |
| `explorer.exe C:\…\Eudora.exe` | durch |
| `$e="C:\…\Eudora.exe"; & $e` | durch |
| `/c/…/Eudora.exe &` | abgewiesen |
| `/c/…/Eudora.exe 2>/dev/null` | abgewiesen |
| `"C:\…\Eudora.exe"` (in PowerShell nur eine Zeichenkette) | abgewiesen (Fehlalarm, harmlos) |
| `echo x > /c/…/Eudora.exe.txt` | durch (richtig) |

Ursachen am Quelltext: `cmd` überspringt nur Schalter der Form `/c` (`m{^/[a-z]$}`), nicht `//c`. Befehle in Anführungszeichen hinter `-Command` oder `-c` werden absichtlich nicht zerlegt. `(`, `{`, `then`, `do` und `timeout` stehen nicht in der Liste der Vorwörter, und ein `)` am Wortende verhindert den Treffer auf `eudora\.exe$`. Die ersten beiden Formen sind in diesem Projekt die wahrscheinlichsten Ausrutscher (Git Bash braucht `//c`). Der Haken gibt nicht vor, Variablen aufzulösen; die letzte Zeile ist kein Mangel. **Behebung** (Vorschlag): `//c` wie `/c` behandeln. Bei `powershell|pwsh … -Command|-c` und `bash|sh -c` den Inhalt der Zeichenkette erneut durch `eudora_aufruf` schicken. `(`, `{`, `then`, `do`, `else`, `timeout <n>` überspringen und `)` am Wortende abschneiden. Die Fälle in den Selbsttest aufnehmen. **Hält das Paket nicht auf.**

### K6 - auftrag-rolle.pl sieht Kennungen in den Berichten der Rollenzweige nicht (klein, Werkzeug, älter als 8c620666)

Im Block „Freie E-Kennungen" werden die Zweignamen aus `git branch -r` ohne Abschneiden der führenden Leerzeichen an `git grep` gegeben (tools/auftrag-rolle.pl, `split /\n/, $zweige` ohne `s/^\s+//`; nur die Schleife darüber für die Berichtsnummer schneidet ab). Gemessen in diesem Baum, gleicher Aufruf: 25 Zweige, für den ersten liefert `git grep` `fatal: unable to resolve revision:   origin/wt/chronist-20261101`. Mit abgeschnittenem Namen kommen 6137 Treffer. Folge: Eine Kennung, die nur im Bericht eines noch nicht gemergten Rollenzweigs steht, gilt als frei. Die Probe im Commit (E-190/E-191 erkannt) ging gut, weil PRUEFER-76/-77 schon im Arbeitsbaum lagen. **Behebung:** `(my $z = $_) =~ s/^\s+//` vor dem `git grep`. **Hält das Paket nicht auf.**

### K7 - Die rote Gegenprobe zu E-184m hat den alten Mengenleser gemessen, nicht die Zuordnung nach Listenposition (klein, Messgüte)

`richtig=2 falsch=1` am Bau 6e9a43ba (tools/pruefstand-faelle.txt:260, BEFUNDE [E-184](../Intern/BEFUNDE.md#e-184)) kann eine reine Zuordnung nach Listenposition nicht erzeugen. Eine Vertauschung von drei Einträgen hat 0, 1 oder 3 Fixpunkte, nie 2. Mit Liste 3,2,1 wären `richtig=1 falsch=2` zu erwarten. Die Erklärung steht im Quelltext: Der Prüfserver antwortet mit **Listen** (`[COPYUID 1 1,2,3 1,2,3]`, imap-pruefserver.pl:537). Der alte Leser `UIDStringToUIDs` versteht nur `x` und `x:y` und macht aus „1,2,3" per `atoi` nur die 1 (proto.cpp:80-112). Also bekam nur die erste Mail der Liste (alte UID 3) die neue UID 1 (falsch). Die beiden anderen Vorab-Kopien blieben markiert, [E-189](../Intern/BEFUNDE.md#e-189) entfernte sie, und der Abgleich holte UID 2 und 3 richtig vom Server: `richtig=2 falsch=1`, `eintraege=3`. Am Quelltext belegt, die Rechnung ist eine Folgerung.

Folgen:

- Die Grünmessung bleibt gültig (sie verlangt drei richtige Einträge).
- Der rote Lauf zeigt immerhin, dass die Liste mit 3 begann; das Sortieren nach Datum hat also gegriffen.
- Der eigentliche K3-Mechanismus (Zuordnung über `i` bei funktionierendem Leser) war am Prüfstand aber nie rot. Echte Server wie Dovecot melden zusammenhängende UIDs als Bereich (`1:3`), den der alte Leser versteht. Genau dort trat K3 auf, und diesen Fall stellt der Prüfserver nicht nach.
- Die Beschreibung im Commit und in BEFUNDE („Bau 6e9a43ba (ohne K3): richtig=2 falsch=1") ordnet das Rot dem falschen Mechanismus zu.

**Behebung** (Vorschlag): Prüfserver-Schalter `--copyuid-bereiche` (zusammenhängende UIDs als `a:b`), damit E-184m am alten Bau `richtig=1 falsch=2` zeigt. Außerdem in messen-e184.ps1 die Anfragezeile `UID COPY 3,2,1` im Serverprotokoll verlangen, sonst wäre ein nicht gegriffenes Sortieren ein blindes Grün. **Hält das Paket nicht auf.**

## Messung

- Testsuite im Baum `.wt/pruefer` (`perl tools/pruefe-tests-gruen.pl`): 357 Tests, 357 bestanden (gemessen, 01.11.2026, vor und nach der Gegenprobe).
- Gegenprobe K3: drei Prüfungen vorübergehend in `Eudora71/Tests/TestE184.cpp` eingefügt → 356/357, rot genau mit den beiden Überlauffällen. Datei danach aus der Sicherung zurückkopiert, `cmp` gleich, `git status` leer.
- Nebenbefund zur Gegenprobe: Das Zurückkopieren mit `cp -p` behielt den alten Zeitstempel. MSBuild übersetzte TestE184.cpp danach nicht neu, und der nächste Lauf meldete weiter 356/357 mit dem alten Programm. Erst nach `touch` kam 357/357 (gemessen). Wer an der Quelle eine Gegenprobe zurückstellt, darf den Zeitstempel nicht mitkopieren, sonst misst der nächste Lauf noch das alte Programm.
- Haken: Selbsttest 23/23. Eigene 14 Fälle wie in K5 (gemessen).
- auftrag-rolle.pl: `git grep` mit und ohne führende Leerzeichen, wie in K6 (gemessen).
- Kein Eudora-Bau, kein Eudora-Start, kein Prüfstand, kein Lesen unter `C:\Temp` (Auftrag). Das Serverprotokoll des roten Laufs habe ich deshalb nicht gesehen; K7 ist am Quelltext hergeleitet.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Papierkorb, Junk und Filter ordnen mehrere Mails weiter nach Listenposition zu: Einträge über Kreuz, jetzt bei allen verschobenen Mails (Original; Vorschlag [E-192](../Intern/BEFUNDE.md#e-192)) | wichtig | nein |
| K2 | Meldet der Server nur einen Teil als kopiert, bleiben spätere Mails der Liste ohne Zuordnung und verlieren ihre lokalen Daten | klein | nein |
| K3 | Mengenleser: zehnstellige Werte über 4294967295 laufen über (gemessen) | gering | nein |
| K4 | [E-170](../Intern/BEFUNDE.md#e-170) nutzt die Quellmenge nicht, Kommentar überholt; Labels bei nicht aufsteigender Liste und automatischem Löschen weiter verloren | klein | nein |
| K5 | Haken gegen Eudora-Starts lässt 10 von 14 Startformen durch, darunter `cmd //c` und `powershell -Command` (gemessen) | mittel (Werkzeug) | nein |
| K6 | auftrag-rolle.pl sucht Kennungen in Rollenzweigen mit falschen Zweignamen, findet nichts (gemessen) | klein (Werkzeug) | nein |
| K7 | Rote Gegenprobe E-184m hat den alten Mengenleser gemessen, nicht die Zuordnung nach Listenposition; Prüfserver kennt keine Bereichsantwort | klein (Messgüte) | nein |
