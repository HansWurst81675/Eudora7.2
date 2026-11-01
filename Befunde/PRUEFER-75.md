# PRÜFER-75 — Behebung E-184 nachgerechnet

Geprüft: `git log f3d2dcb9..HEAD -- Eudora71 tools Releases/1.0` im Baum `.wt/pruefer` (Zweig `wt/pruefer-20261101g`, abgezweigt von `origin/e184_imap_zusammenfassung`). Code-Änderung nur in `e23da6be` („[E-184](../Intern/BEFUNDE.md#e-184) behoben im Quellstand"); dazu `5b01a898` (Prüfserver `UID COPY`/`COPYUID`), `4593ab89` (Messfall rot) und Buchführung.

## Ergebnis vorweg

Die Behebung tut, was sie verspricht: Beim Verschieben innerhalb eines IMAP-Kontos mit einem Server, der neue UIDs meldet, wird die Zusammenfassung einer fremden Mail im Zielordner nicht mehr überschrieben. Der Messfall misst das ehrlich, und die Testsuite ist grün (355/355). Die Behebung ist aber enger als der Befund: derselbe Fehler — die Vorab-Kopie wird im Ziel unter der **alten** Nummer gesucht, obwohl Nummern nur je Ordner gelten — steckt unverändert im Verschieben **zwischen zwei Konten** und beim Verschieben einer nicht geladenen IMAP-Mail **in ein lokales Postfach** (neu: E-188). Ohne UIDPLUS — vermutlich Gregors Fall — bleibt die Vorab-Kopie mit der alten Nummer liegen und überlebt den Abgleich, wenn im Ziel eine fremde Mail dieselbe Nummer hat (neu: E-189). Die erste Hälfte von [E-184](../Intern/BEFUNDE.md#e-184), die falsche Zuordnung bei mehreren Mails in nicht aufsteigender Reihenfolge, ist nicht behoben. Keiner der Funde ist eine Verschlechterung durch die Behebung außer K4 (klein, vorübergehend). Nichts davon hält das nächste Paket auf.

## Was sich geändert hat

Gemessen (`git show --stat e23da6be`): `ImapToc.cpp` +23/−1, `summary.cpp` +1, `summary.h` +3, `tocdoc.cpp` +7, `tocdoc.h` +2, dazu `tools/imap-pruefserver.pl` +14 und Buchführung.

Bytes, gemessen je Datei an `e23da6be~1` und `e23da6be` (aus git gelesen): CRLF-Zahl unverändert (je 18), nur-LF wächst genau um die eingefügten Zeilen (22, 1, 3, 7, 2), keine Bytes über 127 vorher wie nachher. Keine Zerstörung.

## 1. Was die Behebung tut — nachgerechnet

Am Quelltext belegt:

* `tocdoc.cpp:3007-3008`: In `CTocDoc::Xfer`, Zweig `!ToOut`, bekommt die Vorab-Kopie `m_bE184Vorab = TRUE`, wenn Quelle **und** Ziel IMAP sind. Das gilt für jedes IMAP-Ziel, auch für ein anderes Konto (dazu K1).
* `ImapToc.cpp:1584-1586`: `ImapTransferSummaryData` sucht mit `bFindNew` nur noch über `E184FindeVorabKopie` (Merkzeichen **und** `GetHash() == lOldUID`) und löscht das Merkzeichen am Treffer.
* `ImapToc.cpp:1731-1744`: `E184FindeVorabKopie` ist eine wörtliche Abschrift von `E121FindeVorabKopie` mit dem anderen Merkzeichen.
* `summary.cpp:539`: im Konstruktor auf `FALSE`; `CSummary::Copy` (`summary.cpp:587-628`) fasst das Merkzeichen nicht an. Die Aussage „nicht von Copy übernommen" stimmt.
* [E-121](../Intern/BEFUNDE.md#e-121) und [E-184](../Intern/BEFUNDE.md#e-184) schließen sich aus: [E-121](../Intern/BEFUNDE.md#e-121) nur bei `!IsImapToc() && TargetToc->IsImapToc()` (`tocdoc.cpp:3015`), [E-184](../Intern/BEFUNDE.md#e-184) nur bei beiden IMAP (`:3007`). Keine Kopie trägt beide Merkzeichen.

**Wer ruft mit `bFindNew = true`?** (Frage b) Am Quelltext belegt: nur `CImapTransferMsgAction::DoPostProcessing` (`ImapActionQueue.cpp:1612-1616`). Die Unterklassen für „zwischen Konten" (`:2098`), „nach lokal" (`:2330`) und „von lokal" (`:2551`) überschreiben `DoPostProcessing` und rufen die Funktion nicht. Übrig bleibt `CImapSameServerTransferMsgAction`. Sie wird an genau zwei Stellen angelegt: in `ImapXferOnSameAccount` (`ImapToc.cpp:574`, einziger Aufrufer `ImapXfer` ← `CTocDoc::Xfer`, `tocdoc.cpp:3185`) und **beim Wiedereinlesen der gespeicherten Warteschlange** (`ImapActionQueue.cpp:324-331`, XML aus `actionqueue.dat`). Der zweite Weg kommt ohne markierte Kopie an — siehe K4.

## K1 — Neuer Befund E-188: Zwischen zwei Konten und nach lokal sucht Eudora die Vorab-Kopie weiterhin unter der alten Nummer

**Klartext.** Wer eine Mail von einem IMAP-Konto in einen Ordner eines **anderen** IMAP-Kontos verschiebt, oder eine noch nicht ganz geladene IMAP-Mail in ein **lokales** Postfach, bei dem sucht Eudora danach die eigene Vorab-Kopie im Ziel unter der Nummer, die die Mail im **Quellordner** hatte. Trägt dort schon eine andere Mail dieselbe Nummer und steht sie weiter oben in der Liste, wird deren Eintrag umgeschrieben. Das ist derselbe Fehler wie [E-184](../Intern/BEFUNDE.md#e-184), nur an zwei Stellen, die die Behebung nicht anfasst.

**Zwischen zwei Konten**, am Quelltext belegt: `ImapCopyMsgBetweenAccounts`, `ImapToc.cpp:1302`:

```
CSummary *pCopySum = pTargetToc->GetSummaryFromUID(pSum->GetHash());
if (pCopySum) pTargetToc->SubtractSum(pCopySum); ...
pCopySum->Copy(pSum); pTargetToc->AddSum(pCopySum);
```

`GetSummaryFromUID` (`:1746-1765`) liefert den ersten Eintrag mit dieser Nummer — wie in [E-184](../Intern/BEFUNDE.md#e-184) kann das die fremde Mail sein. Zwei Konten haben unabhängige Nummern, die in kleinen Ordnern beide bei 1 beginnen; eine Gleichheit ist hier eher wahrscheinlicher als innerhalb eines Kontos (Vermutung). Dazu: trifft die Suche die richtige, markierte Kopie, bleibt `m_bE184Vorab` an ihr stehen (`Copy` fasst es nicht an), denn auf diesem Weg löscht niemand das Merkzeichen. `CImapCrossServerTransferMsgAction::DoPostProcessing` (`ImapActionQueue.cpp:2098-2146`) stößt anders als die Basisklasse auch keinen Abgleich des Ziels an.

**IMAP nach lokal**, am Quelltext belegt: `ImapCopyMsgFromImapToLocal`, `ImapToc.cpp:1196-1205`. Läuft nur, wenn die Mail noch nicht ganz geladen war (`ImapActionQueue.cpp:2346`). Gesucht wird `GetSummaryFromUID(pSum->GetHash())` im **lokalen** Ziel. Lokale Postfächer enthalten aber Einträge, deren Kennung eine alte IMAP-Nummer ist: `CSummary::Copy` übernimmt `m_Hash` (`summary.cpp:612`), jede früher aus IMAP verschobene Mail behält dort ihre damalige Nummer. Hat eine früher verschobene Mail dieselbe Nummer (aus einem anderen Ordner oder Konto) und steht sie weiter oben, bekommt **ihr** Eintrag Offset und Länge der neuen Mail (`:1202-1222`). Folge (Vermutung, nicht gemessen): der alte Eintrag zeigt Kopf der alten und Text der neuen Mail, der Text der alten ist über die Liste nicht mehr erreichbar (die Bytes stehen noch in der `.mbx`), und die eigentliche Vorab-Kopie zeigt nur den ungeladenen Rumpf. Ein lokales Postfach gleicht sich nie mit einem Server ab; das bleibt so.

**Einordnung.** Original von QUALCOMM (dieselben Zeilen stehen im ersten Stand `567a5d87` der Datei, `:1186` und `:1292`), keine Regression. `befund-suchen.pl ImapCopyMsgFromImapToLocal`: kein Befund; `ImapCopyMsgBetweenAccounts`: nur [E-121](../Intern/BEFUNDE.md#e-121), dort geht es um den Weg von lokal nach IMAP. **Schwere:** wichtig (lokal: Text einer Mail über die Liste verloren). Hält das Paket nicht auf (alt).

**Nachstellen** (Vorschlag): zweites Konto am Prüfserver, oder für „nach lokal" ein lokales Postfach mit einer früher verschobenen Mail der Nummer 1, dann eine nicht geladene INBOX-Mail mit UID 1 dorthin verschieben und das `.toc` mit `TocLesen` aus `messen-e184.ps1` lesen.

**Behebung** (Vorschlag): an beiden Stellen `E184FindeVorabKopie` statt `GetSummaryFromUID`, das Merkzeichen auch für IMAP→lokal setzen (`tocdoc.cpp:3007`, Bedingung auf `IsImapToc()` allein) und am Treffer löschen.

## K2 — Neuer Befund E-189: Ohne neue UIDs vom Server überlebt die Vorab-Kopie den Abgleich, wenn im Ziel eine fremde Mail dieselbe Nummer hat

**Klartext.** Meldet der Server beim Kopieren keine neuen Nummern (kein UIDPLUS — laut [E-170](../Intern/BEFUNDE.md#e-170) vermutlich Gregors Server), bleibt die lokale Vorab-Kopie im Ziel mit der **alten** Nummer stehen. Der Abgleich danach entfernt sie nur, wenn es diese Nummer im Zielordner auf dem Server nicht gibt. Gibt es sie — als fremde Mail —, bleibt die Kopie stehen: ein Eintrag mit Betreff und Text der verschobenen Mail, der aber an die Nummer der fremden Mail gebunden ist. Die verschobene Mail erscheint zusätzlich ein zweites Mal mit ihrer richtigen neuen Nummer.

**Herleitung**, am Quelltext belegt:

1. Die Vorab-Kopie entsteht in `CTocDoc::Xfer` unabhängig davon, ob der Server UIDPLUS kann (`tocdoc.cpp:2992-3041`, keine Abfrage).
2. Ohne `COPYUID` bleibt `m_dwaNewUIDs` leer; die Schleife in `ImapTransferSummaryData` läuft nicht (`ImapToc.cpp:1563`, `i < iSize` mit `iSize = 0`). Kopie unverändert, Merkzeichen bleibt.
3. Der Abgleich legt die lokalen Nummern in eine `CUidMap` (`ImapMailbox.cpp:2218`, `GetCurrentUids` `:7537-7569`). `CUidMap` ist eine `std::map` mit eindeutigem Schlüssel (`ImapTypes.h:99`); `OrderedInsert` legt eine schon vorhandene Nummer nicht doppelt an (`ImapTypes.cpp:521-539`). Fremde Mail und Vorab-Kopie mit derselben Nummer werden **ein** Schlüssel.
4. Weil die Nummer auf dem Server existiert, steht sie nicht in der Liste der zu entfernenden (`ImapMailbox.cpp:2281-2296`). Die Kopie bleibt.

**Passt zur roten Messung** an 7.2.1.130 (`4593ab89`): nachher stand ein Eintrag `uid=1 "Pruefnachricht 1 …"` im Ziel, obwohl UID 1 auf dem Server die fremde Mail ist. Ob vor dem Lesen ein Abgleich lief, sagt der Commit nicht; als Beleg für Schritt 3-4 genügt es daher nicht (Vermutung).

**Folge** (Vermutung, nicht gemessen): Aktionen auf dem Eintrag gehen über `m_Hash` an den Server (vgl. `ImapToc.cpp:544-549` für Verschieben). Wer den doppelten Eintrag löscht, weil die Mail ja zweimal dasteht, löscht auf dem Server die **fremde** Mail. Bis zum Neuaufbau des Ordners bleibt der Eintrag stehen, denn er wird mit `Write` ins `.toc` geschrieben (`tocdoc.cpp:3140`).

**Einordnung.** Original, keine Regression; die Behebung von [E-184](../Intern/BEFUNDE.md#e-184) ändert diesen Weg nicht. Der Eintrag zu [E-184](../Intern/BEFUNDE.md#e-184) in `BEFUNDE.md` sagt *„Gregor muss nichts testen: sein Server meldet vermutlich keine neuen UIDs, dann läuft dieser Weg bei ihm gar nicht"* — für diesen Weg gilt das Gegenteil: er läuft gerade **ohne** UIDPLUS. `befund-suchen.pl GetCurrentUids`, `CUidMap`: kein Befund. **Schwere:** wichtig. Hält das Paket nicht auf (alt).

**Nachstellen:** `messen-e184.ps1` mit `--ohne-copyuid` am Prüfserver. Vorhersage: `fremd=1 kopie=1 eintraege=3`, davon ein Eintrag `uid=1` mit dem Betreff der verschobenen Mail. Ein grünes `eintraege=2` würde diesen Fund widerlegen.

## K3 — Die erste Hälfte von E-184 (Zuordnung nach Listenreihenfolge) ist nicht behoben

**Klartext.** Werden mehrere Mails auf einmal verschoben und ist die Liste nicht nach Nummer aufsteigend sortiert (zum Beispiel nach Datum absteigend), bekommen die Vorab-Kopien die neuen Nummern über Kreuz: der Eintrag mit Kopf und Text von Mail A ist danach an die Server-Nummer von Mail B gebunden. PRÜFER-71 hat das als „Erstens" zu [E-184](../Intern/BEFUNDE.md#e-184) gemeldet; die Behebung betrifft nur das „Zweitens".

Am Quelltext belegt:

* `ImapTransferSummaryData` paart die i-te alte mit der i-ten neuen Nummer (`ImapToc.cpp:1575-1576`).
* Die alte Liste folgt der Reihenfolge von `m_Sums` (`ImapToc.cpp:519-550`, `tocdoc.cpp:2669`), und `m_Sums` folgt der Sortierung der Ansicht: `CTocView::SortNow` schreibt die sortierte Folge zurück (`tocview.cpp:3943`, `SumList.SetAt`).
* Die neuen Nummern kommen aus dem Zielteil von `COPYUID`; den Quellteil liest Eudora nicht (`Imapdll/src/proto.cpp:2138-2150`). Server melden beide Teile in derselben Folge, üblich aufsteigend (RFC 4315; Vermutung über das Serververhalten).

Mit der Behebung findet `E184FindeVorabKopie(pTargetToc, a)` die richtige Kopie von A, setzt aber `m_Hash` auf die neue Nummer von B (`:1638`). Folgen wie in K2 (Vermutung). `E170LabelsNachtragen` schützt sich davor (`ImapActionQueue.cpp:1713-1720`, „reihenfolge-unsicher"); die Zuordnung der Zusammenfassungen nicht.

**Einordnung.** Original, keine Regression, schon gemeldet — aber der Eintrag zu [E-184](../Intern/BEFUNDE.md#e-184) nennt als Behebung nur das Merkzeichen. Wird [E-184](../Intern/BEFUNDE.md#e-184) nach Gregors Test als behoben geschlossen, fällt diese Hälfte still heraus. Entweder [E-184](../Intern/BEFUNDE.md#e-184) bleibt mit diesem Rest offen, oder sie bekommt eine eigene Kennung. **Schwere:** wichtig. Hält das Paket nicht auf. **Behebung** (Vorschlag): den Quellteil von `COPYUID` mitlesen und nach ihm paaren, oder mindestens die alte Liste vor dem Paaren aufsteigend ordnen wie in `E170Aufsteigend`.

## K4 — Nach einem Neustart mit gespeicherter Warteschlange entsteht eine zweite Zusammenfassung (Folge der Behebung, klein)

**Klartext.** Das Merkzeichen lebt nur im Speicher. Verschiebt jemand offline, beendet Eudora und startet neu, wird die Verschiebung aus `actionqueue.dat` nachgeholt. Die Vorab-Kopie steht dann zwar im `.toc` des Ziels, aber ohne Merkzeichen. `E184FindeVorabKopie` findet nichts, und `ImapTransferSummaryData` legt eine neue Zusammenfassung an. Bis 7.2.1.130 hat `GetSummaryFromUID` die unmarkierte Kopie wiederverwendet.

Am Quelltext belegt: Wiederherstellen `ImapActionQueue.cpp:324-331`; Kopie im `.toc`, weil `Xfer` das Ziel schreibt (`tocdoc.cpp:3140`); neue Zusammenfassung bei Fehlschlag `ImapToc.cpp:1588-1591`, `:1655`.

**Folge** (Vermutung): Ohne Nummerngleichheit entfernt der Abgleich danach die alte Kopie (`m_bIsLastOnMailbox`, `ImapActionQueue.cpp:1627-1629`) — der doppelte Eintrag ist nur kurz zu sehen. Mit Nummerngleichheit bleibt er stehen wie in K2. Dasselbe gilt, wenn das Ziel-Dokument zwischen dem Einreihen und dem Ausführen aus dem Speicher fällt und neu geladen wird (nicht nachgesehen, ob das bei einer offenen Aktion möglich ist). **Schwere:** klein. Hält das Paket nicht auf. **Behebung** (Vorschlag): wenn `E184FindeVorabKopie` nichts liefert, als Rückfall eine **unmarkierte** Zusammenfassung mit der alten Nummer nehmen, deren Betreff, Absender und Datum zur alten Zusammenfassung in der Quelle passen.

## K5 — Kein Quelltexttest für E-184

Gemessen: `cmd /c Eudora71\Tests\RunTests.cmd` in diesem Baum — **355 Tests, 355 bestanden** — und keiner nennt [E-184](../Intern/BEFUNDE.md#e-184) (`grep -rn E184 Eudora71/Tests`: kein Treffer). Einzige Wache ist der Prüfstandsfall, der ein Eudora-Fenster braucht. Eine Gegenprobe an der Testsuite war deshalb nicht sinnvoll: ein vorübergehendes Zurücksetzen der Behebung hätte nichts rot gemacht. Ein Quelltexttest nach dem Muster von `TestE170.cpp` wäre billig: in `ImapTransferSummaryData` kein `GetSummaryFromUID(lOldUID)` im Zweig `bFindNew`, in `Xfer` `SetE184Vorab(TRUE)` vor `AddSum(CopySum)`. **Schwere:** klein. Hält das Paket nicht auf.

## K6 — Buchführung zu E-184

* Der Eintrag nennt die beiden anderen Aufrufer als `ImapToc.cpp:2728`, `:3034`; heute stehen sie bei `:2750` und `:3056` (gemessen, `grep -n ImapTransferSummaryData`).
* *„Gregor muss nichts testen … dann läuft dieser Weg bei ihm gar nicht"* — siehe K2.

**Schwere:** klein. Hält das Paket nicht auf.

## Messfall und Prüfserver

**`tools/messen-e184.ps1`** misst, was er behauptet, für den Fall **eine Mail, ein Konto, Server mit COPYUID**. Am Skript belegt: es liest `Ablage.toc` direkt (218-Byte-Datensätze, `m_Hash` an 188) und verlangt `fremd=1 kopie=1 eintraege=2`. Die Zahl der Einträge ist der entscheidende Teil: würde die Kopie nicht gefunden (K4) oder nicht verbraucht (K2), stünden drei Einträge da, und der Fall wäre rot. Der Fall ist also nicht blind für „Weg nicht erreicht". Die Gegenprobe (rot an 7.2.1.130+955d50d4: `fremd=0 kopie=1 eintraege=2`) steht mit `.toc`-Auszug in `4593ab89`; selbst wiederholt habe ich sie nicht (Prüfstand für mich gesperrt). Nicht abgedeckt: mehrere Mails (K3), zwei Konten und nach lokal (K1), ohne COPYUID (K2), Neustart (K4).

**`tools/imap-pruefserver.pl`**, am Skript belegt:

* `UID COPY` vergibt im Ziel neue UIDs und meldet `COPYUID 1 <alt> <neu>` in der Reihenfolge der Quellliste — wie ein echter Server; `--ohne-copyuid` lässt die Angabe weg. Gut für K2.
* Die unaufgeforderte `* n EXISTS`-Meldung kommt vor der getaggten Antwort, wie RFC 3501 es verlangt. Da der Server nie etwas aus einer Liste entfernt (`EXPUNGE` wird nur mitgeschrieben, `:518-521`), meldet er nie eine kleinere Zahl über `EXISTS` — die RFC verbietet das.
* Kleinigkeit ohne Folgen für [E-184](../Intern/BEFUNDE.md#e-184): Bei einer Menge `*` setzt `$lo = $schluessel` (`COPY`-Zweig), damit passt **jede** Nachricht statt nur der höchsten. Eudora schickt ausgeschriebene UIDs, deshalb nur zur Kenntnis.

## Gegenvermutungen

* *(a) Das Merkzeichen wird überall gelöscht, wo die Vorab-Kopie endet.* **Widerlegt, am Quelltext belegt.** Gelöscht wird nur in `ImapToc.cpp:1586`. Es bleibt stehen: zwischen zwei Konten (K1), ohne COPYUID (K2), wenn `DoWork` scheitert (`m_dwaNewUIDs` leer, `ImapActionQueue.cpp:1940-1958`), bei Aktionen, die nie laufen. Abbruch mit Esc, Fehler beim Kopieren der Bytes und „Fenster lässt sich nicht schließen" brechen in `Xfer` **vor** dem Anlegen der Kopie ab (`tocdoc.cpp:2690`, `:2997-2998`, `:2808-2812`) — dort entsteht keine. Kopieren statt Verschieben läuft durch dieselbe Stelle und wird verbraucht. **Kann eine liegengebliebene markierte Kopie später getroffen werden?** Ja, wenn sie den Abgleich überlebt (nur bei Nummerngleichheit, K2) oder noch kein Abgleich lief (zwischen zwei Konten stößt keiner an, K1) und danach eine Mail mit derselben alten Nummer in dasselbe Ziel verschoben wird. Das ging mit `GetSummaryFromUID` genauso; die Behebung verschlechtert es nicht. Die Aussage im Kommentar *„Das Merkzeichen macht die Kopie eindeutig"* (`tocdoc.cpp:3006`) ist aber zu stark.
* *(b) Es gibt Wege nach `ImapTransferSummaryData(bFindNew=true)` ohne Kopie aus `Xfer`.* **Bestätigt für einen Weg:** die gespeicherte Warteschlange nach einem Neustart (K4). Sonst keiner (Abschnitt 1).
* *(c) Wechselwirkung mit [E-170](../Intern/BEFUNDE.md#e-170).* **Keine gefunden.** `E170LabelsNachtragen` sucht nach der **neuen** Nummer (`ImapActionQueue.cpp:1746`) und setzt nur, wo das Ziel noch kein Label hat; die Kopie hat es durch `Copy(pSumOld)` schon. Im Fall K4 übernimmt die neue Zusammenfassung das Label ebenfalls über `Copy(pSumOld)` (`ImapToc.cpp:1628`). **Wechselwirkung mit [E-121](../Intern/BEFUNDE.md#e-121):** keine, die Merkzeichen schließen sich aus (Abschnitt 1).
* *Die Schleife in `ImapTransferSummaryData` setzt `bFoundNew` nie zurück.* Am Quelltext belegt (`:1558`, `:1590`): fehlt in einer Liste die Kopie einer Mail, gelten alle **folgenden** gefundenen Kopien als neu — `AddSum` ein zweites Mal auf einen Eintrag, der schon in der Liste steht, und `Offset`/`Length` auf 0 (`:1644-1655`). Steht so im Original (`567a5d87`, `:1452`, `:1478`). Erreichbar nur, wenn in **einer** Aktion markierte und unmarkierte Kopien gemischt sind; einen solchen Weg habe ich nicht gefunden (im Fall K4 sind alle unmarkiert). Kein Fund, nur zur Kenntnis.
* *Der Fall ist grün, weil der Weg gar nicht erreicht wird.* Widerlegt durch `eintraege=2` (siehe Messfall).
* *Die neue Membervariable verschiebt die Lage von `CSummary` und bricht etwas, das nicht neu übersetzt wird.* Nicht gemessen. `CSummary::Write` schreibt Feld für Feld (218 Byte), nicht den Speicher am Stück; der Commit meldet einen vollständigen Release-Bau ohne Fehler (belegt nur durch den Commit).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 (E-188) | Zwischen zwei IMAP-Konten und bei nicht geladener Mail nach lokal sucht Eudora die Vorab-Kopie weiter unter der alten Nummer und kann einen fremden Eintrag umschreiben; lokal verliert eine früher verschobene Mail dabei ihren Text in der Liste. Original. | wichtig | nein |
| K2 (E-189) | Ohne neue UIDs vom Server bleibt die Vorab-Kopie mit der alten Nummer stehen, wenn eine fremde Mail im Ziel dieselbe hat; Löschen des Doppels träfe die fremde Mail auf dem Server (Vermutung). Original, betrifft vermutlich Gregors Server. | wichtig | nein |
| K3 | [E-184](../Intern/BEFUNDE.md#e-184) nur halb behoben: bei mehreren Mails und nicht aufsteigender Liste bekommen die Einträge die neuen Nummern über Kreuz. Original, schon von PRÜFER-71 gemeldet, nicht als offen geführt. | wichtig | nein |
| K4 | Nach Neustart mit gespeicherter Warteschlange fehlt das Merkzeichen; eine zweite Zusammenfassung entsteht, meist nur bis zum Abgleich. Folge der Behebung. | klein | nein |
| K5 | Kein Quelltexttest für [E-184](../Intern/BEFUNDE.md#e-184); einzige Wache ist der Prüfstandsfall. | klein | nein |
| K6 | Zeilennummern im Eintrag veraltet; „Gregor muss nichts testen" widerspricht K2. | klein | nein |
