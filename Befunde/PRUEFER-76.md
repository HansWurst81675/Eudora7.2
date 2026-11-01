# PRÜFER-76 — Behebung E-189 nachgerechnet (Kurzlauf vor dem PR)

Geprüft: `git log a25a600a..HEAD -- Eudora71 tools Releases/1.0` im Baum `.wt/pruefer` (Zweig `wt/pruefer-20261101h`, abgezweigt von `origin/e184_imap_zusammenfassung`). Code-Änderung nur in `8b5f8342` („[E-189](../Intern/BEFUNDE.md#e-189) behoben im Quellstand"): `E189VorabKopienEntfernen` in `EuImap/src/ImapToc.cpp`, Aufruf in `CImapTransferMsgAction::DoPostProcessing` (`ImapActionQueue.cpp`), Deklaration in `tocdoc.h`; dazu `tools/messen-e184.ps1` (erneutes Öffnen von „Ablage", Schalter `-OhneCopyuid`), neu `tools/messen-e189.ps1`, Kopf von `tools/imap-pruefserver.pl` und Buchführung.

## Ergebnis vorweg

Die Behebung tut im gemessenen Fall, was sie verspricht: Meldet der Server beim Kopieren keine neuen Nummern, nimmt Eudora seine eigene Vorab-Kopie im Zielordner wieder heraus, statt sie mit der alten Nummer neben einer fremden Mail stehen zu lassen. Die Testsuite ist grün (355/355), die Bytes der drei Quelldateien sind unversehrt. Die neuen Messfälle sind trennscharf: kein falscher Zustand, den ich durchgespielt habe, ergibt die grüne Zeile.

Vier Schwächen bleiben. Ist auf der Vorab-Kopie ein Nachrichtenfenster offen, dessen Inhalt geändert wurde, kann Eudora beim Schließen abstürzen, weil die Zusammenfassung schon gelöscht ist (K1, am Quelltext belegt, nicht gemessen). Das Merkzeichen gehört keiner bestimmten Übertragung; die neue Funktion entfernt deshalb auch Vorab-Kopien **anderer**, noch offener Übertragungen mit derselben alten Nummer (K2). Ohne neue Nummern vom Server ist die verschobene Mail nach der Behebung im Zielordner **gar nicht** zu sehen, bis Eudora den Ordner abgleicht — und ob es das von selbst tut, schwankt laut Commit (K3); das gehört in Gregors Testanweisung. Nach einem Neustart mit gespeicherter Warteschlange greift die Behebung nicht (K4). Dazu zwei Kleinigkeiten in Messung und Buchführung (K5, K6). Keiner der Funde hält das nächste Paket auf; K1 ist mit einer Zeile zu schließen und lohnt sich vorher.

Die Kennungen E-190 und E-191 habe ich nicht gebraucht: alle Funde gehören zu [E-189](../Intern/BEFUNDE.md#e-189) oder [E-184](../Intern/BEFUNDE.md#e-184).

## Was sich geändert hat

Gemessen (`git show --stat 8b5f8342`): `ImapActionQueue.cpp` +7, `ImapToc.cpp` +34, `tocdoc.h` +4, dazu Werkzeuge und Buchführung.

Bytes, gemessen je Datei an `8b5f8342~1` und `8b5f8342` (aus git gelesen): CRLF-Zahl unverändert (je 18), nur-LF wächst genau um die eingefügten Zeilen (7, 34, 4), keine Bytes über 127 vorher wie nachher. Keine Zerstörung.

Testsuite, gemessen in diesem Baum (`cmd /c Eudora71\Tests\RunTests.cmd`): **355 Tests, 355 bestanden**, Rückgabe 0. Kein Test nennt [E-189](../Intern/BEFUNDE.md#e-189) oder [E-184](../Intern/BEFUNDE.md#e-184) (`grep -rln "E189\|E184" Eudora71/Tests`: kein Treffer) — eine Gegenprobe an der Testsuite war daher nicht sinnvoll.

## 1. Was die Behebung tut — nachgerechnet

Am Quelltext belegt:

* `ImapActionQueue.cpp:1619-1624`: `E189VorabKopienEntfernen(m_pDestTocDoc, m_szMessageIDs)` steht nach dem `if (m_pTocDoc)`-Block mit `ImapTransferSummaryData` und **vor** `E170LabelsNachtragen` und dem Abgleich. Sie läuft also auch, wenn `m_pTocDoc` NULL wäre — das kann hier nicht vorkommen, `DoPreThreadAction` bricht dann vorher ab (`:1552-1556`) und setzt die Nachbearbeitung gar nicht (`SetPostProcFn` erst in `:1595`).
* `ImapToc.cpp:1749-1778`: zerlegt die Liste an Kommas, `strtoul` je Teil, und entfernt in einer `while`-Schleife **jede** markierte Kopie mit dieser Nummer (`E184FindeVorabKopie`, `:1731-1744`, sucht jedes Mal vom Kopf an). Die Liste ist eine reine Dezimalliste ohne Bereiche (`ImapXferOnSameAccount`, `ImapToc.cpp:540-549`) — das Zerlegen passt.
* Kopien, denen `ImapTransferSummaryData` eine neue Nummer gegeben hat, sind dort schon entmarkt (`ImapToc.cpp:1585-1586`); die neue Funktion trifft sie nicht. Mit UIDPLUS und vollständigem `COPYUID` ist sie also wirkungslos, wie beabsichtigt. Bei einem unvollständigen `COPYUID` (weniger neue als alte Nummern) läuft die Schleife in `ImapTransferSummaryData` nur `i < iSize` (`:1563`); die übrigen Kopien bleiben markiert und werden jetzt entfernt — richtig.
* Das Entfernen folgt dem Muster der E-121-Entfernung (`ImapToc.cpp:1497-1508`): Spurzeile, `SetDeleteEmbedded(FALSE)`, `InvalidateCachedPreviewSummary`, `SC_CLOSE` an ein offenes Fenster, `RemoveSum`.

## K1 — Offenes, geändertes Nachrichtenfenster auf der Vorab-Kopie: Absturz beim Schließen möglich

**Klartext.** Hat jemand die verschobene Mail im Zielordner geöffnet, bevor die Übertragung auf dem Server fertig ist — offline bis zur nächsten Verbindung ist das beliebig lange —, und den Inhalt geändert, dann schickt Eudora dem Fenster „Schließen" und löscht die Zusammenfassung **sofort**, ohne zu fragen, ob das Fenster sich schließen lässt. Beim Schließen fragt das Fenster dann „Änderungen speichern?". Wer „Abbrechen" wählt, bringt Eudora zum Absturz.

**Herleitung**, am Quelltext belegt:

1. `E189VorabKopienEntfernen` ruft `PostMessage(WM_SYSCOMMAND, SC_CLOSE)` und gleich danach `RemoveSum` (`ImapToc.cpp:1772-1775`). `PostMessage` kehrt sofort zurück; das Schließen läuft erst später.
2. `RemoveSum` löscht die Zusammenfassung (`tocdoc.cpp:1558-1590`, `delete Sum`). Der Destruktor setzt `m_Sum` des Dokuments auf NULL (`summary.cpp:574-580`) und räumt die Rückzeiger der Rahmen ab ([E-176](../Intern/BEFUNDE.md#e-176), `:562`). Ein hängender Zeiger bleibt also nicht — aber ein NULL.
3. Beim späteren Schließen läuft `CMessageDoc::SaveModified`. Ist das Dokument geändert (`IsModified() || WasTranslated()`, `msgdoc.cpp:1006`), fragt es; bei `IDCANCEL` steht `m_Sum->m_rrDialogOverride = false;` **ohne** NULL-Prüfung (`msgdoc.cpp:1028`) — Zugriff über NULL.
4. Die beiden Vorbilder prüfen vorher: `CTocDoc::Xfer` (`tocdoc.cpp:2805-2812`, `CanCloseFrame`, sonst Abbruch) und die E-121-Entfernung der **Quelle** (`ImapActionQueue.cpp:2650-2654`, „Laesst es sich nicht schliessen, bleibt die Quelle stehen"). Die E-121-Entfernung der **Vorab-Kopie** (`ImapToc.cpp:1503-1507`), nach der die neue Funktion gebaut ist, hat dieselbe Lücke — die Lücke ist also mit abgeschrieben.

**Vermutung, nicht gemessen:** ob ein empfangener IMAP-Text sich in Eudora so ändern lässt, dass `IsModified()` wahr wird, habe ich nicht nachgestellt; `WasTranslated()` (Übersetzer-Plugins) ist ein zweiter Weg. Bei „Ja" (`DoSave`) habe ich den weiteren Weg mit `m_Sum == NULL` nicht verfolgt.

**Einordnung.** Neu durch die Behebung (bisher blieb die Kopie stehen und wurde erst vom Abgleich entfernt — auf welchem Weg der Abgleich mit offenen Fenstern umgeht, habe ich nicht nachgesehen). Selten. **Schwere:** wichtig (Absturz), aber schwer zu erreichen. Hält das Paket nicht auf. **Behebung** (Vorschlag, eine Zeile wie in `ImapActionQueue.cpp:2650`): `if (pFenster && !pFenster->GetActiveDocument()->CanCloseFrame(pFenster)) { pSum->SetE184Vorab(FALSE); continue; }` — die Kopie bleibt dann stehen wie vor der Behebung, und das Merkzeichen muss weg, sonst läuft die `while`-Schleife endlos. Dieselbe Prüfung gehört in die E-121-Entfernung (`ImapToc.cpp:1503`).

## K2 — Das Merkzeichen gehört keiner Übertragung: die Funktion entfernt auch Vorab-Kopien anderer offener Übertragungen

**Klartext.** Die neue Funktion erkennt „ihre" Kopien nur an Merkzeichen und alter Nummer. Verschiebt jemand — offline, oder schneller als der Server antwortet — eine Mail mit Nummer 5 aus INBOX und eine andere mit Nummer 5 aus „Gesendet" in denselben Ordner, dann tragen beide Vorab-Kopien Merkzeichen und Nummer 5. Die erste Übertragung, die fertig wird, entfernt **beide**.

Am Quelltext belegt:

* Die Schleife `while ((pSum = E184FindeVorabKopie(pZiel, ulUid)) != NULL)` (`ImapToc.cpp:1764`) nimmt alles mit dieser Nummer, nicht nur eine Kopie je Listeneintrag.
* Das Merkzeichen entsteht für **jedes** IMAP-Ziel, auch für ein anderes Konto (`tocdoc.cpp:3007-3008`, Bedingung `IsImapToc() && TargetToc->IsImapToc()`), und wird auf dem Weg zwischen Konten nie gelöscht ([E-188](../Intern/BEFUNDE.md#e-188), PRÜFER-75 K1). Eine solche Kopie liegt markiert im Ziel, bis ein Abgleich sie ersetzt, und eine spätere Übertragung innerhalb eines Kontos mit derselben alten Nummer entfernt sie.

**Folge** (Vermutung, aus dem Quelltext abgeleitet, nicht gemessen):

* Zwei Übertragungen im selben Konto: die zweite findet ihre Kopie nicht mehr. Mit UIDPLUS legt `ImapTransferSummaryData` dann eine neue, nicht geladene Zusammenfassung an (`ImapToc.cpp:1588-1591`, `:1644-1655`), ohne UIDPLUS nichts. Die erste gleicht nicht ab, weil die zweite noch aussteht (`m_bIsLastOnMailbox`, `ImapActionQueue.cpp:1943`, `:1634`); die zweite gleicht ab und holt beide Mails. Der Endstand stimmt, dazwischen fehlt die Mail.
* Die Verwechslung selbst ist älter als diese Behebung: schon `ImapTransferSummaryData` nimmt bei zwei markierten Kopien mit Nummer 5 die erste in der Liste, also womöglich die der anderen Übertragung — die Kopie bekommt Betreff und Länge der eigenen Mail, behält aber Offset und Inhalt der fremden (`CSummary::Copy` übernimmt `m_Length`, nicht `m_Offset`, `summary.cpp:589`). Das ist ein weiterer Rest von [E-184](../Intern/BEFUNDE.md#e-184): *„Das Merkzeichen macht die Kopie eindeutig"* (`tocdoc.cpp:3006`) gilt nur innerhalb einer Übertragung.
* Zwischen Konten: `ImapCopyMsgBetweenAccounts` findet seine entfernte Kopie nicht mehr und nimmt per `GetSummaryFromUID` die fremde Mail oder legt eine neue an (`ImapToc.cpp:1302-1310`) — das ist [E-188](../Intern/BEFUNDE.md#e-188), nur häufiger getroffen.

**Schwere:** klein (vorübergehend, braucht gleiche alte Nummern aus zwei Quellen in einem Ziel). Hält das Paket nicht auf. **Behebung** (Vorschlag): das Merkzeichen als Zahl statt als Schalter führen — eine fortlaufende Kennung der Übertragung, die `ImapXferOnSameAccount` der Aktion mitgibt —, und in `E184FindeVorabKopie` nach Kennung **und** Nummer suchen. Zwischen Konten das Merkzeichen gar nicht setzen, solange [E-188](../Intern/BEFUNDE.md#e-188) offen ist.

## K3 — Ohne UIDPLUS hängt die Anzeige jetzt ganz am Abgleich, und der schwankt

**Klartext.** Ohne neue Nummern vom Server — vermutlich Gregors Fall — ist die verschobene Mail nach der Behebung im Zielordner **nicht** zu sehen, bis Eudora den Ordner mit dem Server abgleicht. Vorher stand sie dort, wenn auch unter der falschen Nummer. Der Commit sagt selbst: *„Ob Eudora nach dem Kopieren von selbst abgleicht, schwankt von Lauf zu Lauf"*; deshalb öffnen beide Messskripte „Ablage" ein zweites Mal.

Am Quelltext belegt:

* Abgeglichen wird nur, wenn diese Übertragung die letzte auf dem Zielordner ist (`ImapActionQueue.cpp:1634`), und dann **im Hintergrund** (`DoManualResync(…, bInForeGround=FALSE)` → `DoBackgroundResync`, `ImapMailbox.cpp:1134-1137`).
* Die Kopie wird **vorher** und unabhängig davon entfernt (`ImapActionQueue.cpp:1624`).
* Ist der `COPY` gescheitert, läuft die Nachbearbeitung trotzdem (`DoWork` gibt `S_OK` zurück, `:1958-1967`), und die Kopie geht ebenfalls weg. Das ist richtig — auf dem Server liegt nichts im Ziel —, und es ist dasselbe Ergebnis, das der Abgleich vorher auch hatte. Keine Verschlechterung.

**Gemessen** habe ich das Schwanken nicht (Prüfstand für mich gesperrt); es ist nur durch den Commit und den Kommentar in `messen-e184.ps1:351-354` belegt. Woher es kommt (Hintergrundabgleich noch nicht fertig, als das Skript las? Abgleich gar nicht angestoßen?), sagt der Commit nicht. Die Spurzeile `E-121 Ziel nach dem Abgleich: summen=…` (`ImapActionQueue.cpp:1639-1641`) steht nur im Zweig mit Abgleich; ihr Fehlen im Log eines schwankenden Laufs würde zeigen, dass gar nicht abgeglichen wurde.

**Schwere:** klein (die Mail ist auf dem Server, nichts geht verloren; nach erneutem Öffnen ist sie da). Hält das Paket nicht auf. **Aber:** Gregors Testanweisung zu [E-189](../Intern/BEFUNDE.md#e-189) sollte sagen, dass die Mail im Zielordner kurz fehlen kann und nach erneutem Öffnen des Ordners erscheinen muss — sonst meldet er das als neuen Fehler. Der Eintrag in `BEFUNDE.md` sagt nur *„der folgende Abgleich holt die Mail mit ihrer echten UID"*.

## K4 — Nach einem Neustart oder neu geladenem Ziel greift die Behebung nicht

**Klartext.** Wie bei [E-184](../Intern/BEFUNDE.md#e-184) (PRÜFER-75 K4) lebt das Merkzeichen nur im Speicher. Wird eine offline eingereihte Verschiebung erst nach einem Neustart ausgeführt, sind die Vorab-Kopien im `.toc` unmarkiert; `E189VorabKopienEntfernen` findet nichts, und ohne UIDPLUS steht die Kopie mit der alten Nummer wieder neben der fremden Mail — der Fall [E-189](../Intern/BEFUNDE.md#e-189) ungebremst.

Am Quelltext belegt: Wiederherstellen der Warteschlange `ImapActionQueue.cpp:324-331`; Merkzeichen nur im Konstruktor gesetzt und nicht geschrieben (`summary.cpp:539`, `CSummary::Write` schreibt Feld für Feld). Dasselbe gilt, wenn das Ziel-Dokument zwischen Einreihen und Ausführen aus dem Speicher fällt und `GetToc` es neu lädt (`ImapActionQueue.cpp:1565`); ob das bei offener Aktion möglich ist, habe ich nicht nachgesehen.

**Schwere:** klein (seltener Weg; kein Rückschritt gegenüber 7.2.1.130). Hält das Paket nicht auf. Gehört als Rest in den Eintrag zu [E-189](../Intern/BEFUNDE.md#e-189).

## K5 — Die Gegenprobe ist nicht festgehalten, und die Kernaussage von E-189 ist nicht gemessen

* `Intern/pruefstand-ergebnis.txt` (Stand `8b5f8342`) zeigt für die Gegenprobe an `955d50d4` nur `fehlt in messung` und als „gemeldet" die letzten vier Zeilen — die Zeilen der Hülle `testlauf.ps1` („Beende per WM_CLOSE …", „Protokolliert in …"), **nicht** die `E184 ERGEBNIS`-Zeile (gemessen; `tools/pruefstand-lauf.ps1:370`, `Select-Object -Last 4`). Welche Werte die Gegenprobe ergab, steht damit nirgends im Zweig; „beide rot" ist nur durch die Commit-Nachricht belegt. Rot kann auch „Messweg nicht erreicht" heißen. Werkzeugmangel: `pruefstand-lauf.ps1` sollte bei `fehlt in messung` die Zeile mit dem Präfix der erwarteten (`E184 ERGEBNIS`) zeigen, nicht die letzten vier.
* Die rote Messung **vor** der Behebung (`fremd=1 kopie-neu=0 kopie-mit-alter-uid=1 eintraege=2`, Eintrag [E-189](../Intern/BEFUNDE.md#e-189)) zeigt keinen Abgleich: UID 2 fehlte. Die Aussage *„der Abgleich räumt die Kopie nicht weg"* (`CUidMap` führt gleiche Nummern einmal; PRÜFER-75 K2, Schritte 3-4) ist also weiterhin nur am Quelltext belegt. Die Vorhersage aus PRÜFER-75 (`eintraege=3` mit Abgleich) wäre der passende rote Wert der Gegenprobe mit erneutem Öffnen — genau der fehlt.

**Schwere:** klein. Hält das Paket nicht auf.

## K6 — Buchführung

* Der Eintrag zu [E-184](../Intern/BEFUNDE.md#e-184) nennt die beiden anderen Aufrufer von `ImapTransferSummaryData` als `ImapToc.cpp:2750`, `:3056` — gesetzt im selben Commit, der vor ihnen 34 Zeilen einfügt. Heute stehen sie bei **`:2784`** und **`:3090`** (gemessen, `grep -n ImapTransferSummaryData`). Zeilennummern in `BEFUNDE.md` veralten bei jedem Einschub; besser die Funktion nennen (`ImapXferFromImapToImap`-Weg bzw. `ImapAppendSumList`-Weg o. ä.).
* [E-189](../Intern/BEFUNDE.md#e-189) steht auf **kritisch**, PRÜFER-75 K2 hatte **wichtig** vorgeschlagen. Die Begründung im Eintrag („solange die Löschvermutung nicht widerlegt ist") ist nachvollziehbar; nur zur Kenntnis.
* Kein Quelltexttest für [E-189](../Intern/BEFUNDE.md#e-189) (wie PRÜFER-75 K5 für [E-184](../Intern/BEFUNDE.md#e-184)). Billig nach dem Muster `TestE170.cpp`: in `CImapTransferMsgAction::DoPostProcessing` steht `E189VorabKopienEntfernen` nach `ImapTransferSummaryData` und vor `DoManualResync`.

**Schwere:** klein. Hält das Paket nicht auf.

## Messfälle: trennscharf?

**`tools/messen-e189.ps1`** ist eine Hülle um `messen-e184.ps1 -OhneCopyuid`; der Prüfserver bekommt `--ohne-copyuid` (`messen-e184.ps1:190`). Erwartet: `fremd=1 kopie-neu=1 kopie-mit-alter-uid=0 eintraege=2`. Durchgespielt (am Skript belegt, Werte aus dem Quelltext abgeleitet):

| Zustand | fremd | kopie-neu | alt | einträge | Ergebnis |
|---|---|---|---|---|---|
| ohne Behebung, ohne Abgleich (gemessen vor der Behebung) | 1 | 0 | 1 | 2 | rot |
| ohne Behebung, mit Abgleich (PRÜFER-75 K2) | 1 | 1 | 1 | 3 | rot |
| mit Behebung, ohne Abgleich (K3) | 1 | 0 | 0 | 1 | rot |
| mit Behebung, mit Abgleich | 1 | 1 | 0 | 2 | grün |
| fremde Mail überschrieben (E-184-Fehler) | 0 | … | … | … | rot |

Der Fall ist also nicht blind für „Weg nicht erreicht" und nicht für „Abgleich nicht gelaufen". Er ist aber auf das zweite Öffnen angewiesen: ohne es wäre er mit der Behebung rot, wenn Eudora von selbst nicht abgleicht — das ist ehrlich, denn genau das ist K3.

**`tools/messen-e184.ps1` mit erneutem Öffnen:** mit COPYUID bekommt die Kopie ihre neue Nummer schon in `ImapTransferSummaryData`; der Abgleich danach entfernt nichts und holt nichts. Das zweite Öffnen ändert den Sollwert nicht und macht keinen falschen Zustand grün: der Kernwert `fremd` hängt am überschriebenen Eintrag der fremden Mail, und dass ein Abgleich bei einer **vorhandenen** Nummer den Kopf neu holt und so die Überschreibung verdeckt, sieht der Quelltext nicht vor (Vermutung; Abgleich bestehender Nummern nur Flags — nicht im Einzelnen nachgelesen). Die rote Gegenprobe an `955d50d4` würde das bestätigen, ihr Wert ist aber nicht festgehalten (K5).

**`tools/imap-pruefserver.pl`:** nur der Kopf geändert (EXISTS-Beschreibung), passt zu PRÜFER-75.

## Gegenvermutungen

* *Kopieren statt Verschieben entfernt eine noch gebrauchte Kopie.* **Widerlegt, am Quelltext belegt.** Bei `m_bCopy` läuft derselbe Weg: die Vorab-Kopie im Ziel wird ohne neue Nummer entfernt, die Quelle bleibt unangetastet (sie wird nur bei `!bCopy` in `sumlistToMove` aufgenommen, `ImapToc.cpp:553-557`). Der Abgleich holt die Kopie vom Server. Gleich wie beim Verschieben, also K3.
* *COPY gescheitert.* **Kein Rückschritt** (K3, dritter Punkt): die Kopie ginge vorher beim Abgleich auch weg, außer bei Nummerngleichheit — und gerade dort ist das Entfernen richtig.
* *Mehrere Mails, teils mit neuer Nummer.* **Widerlegt:** zugeordnete Kopien sind entmarkt (`ImapToc.cpp:1586`), nur die übrigen gehen weg. Die Vertauschung bei nicht aufsteigender Liste (PRÜFER-75 K3) bleibt unberührt.
* *Gleichzeitige Übertragungen in dasselbe Ziel.* **Bestätigt** — K2.
* *Ziel-TOC nicht geladen, `m_pDestTocDoc` NULL.* **Widerlegt:** NULL bricht in `DoPreThreadAction` ab (`ImapActionQueue.cpp:1568-1572`), und die Funktion prüft selbst (`ImapToc.cpp:1751`). Neu geladenes Ziel ohne Merkzeichen: K4.
* *Offenes Nachrichtenfenster der Kopie.* **Bestätigt** — K1.
* *`RemoveSum` stürzt über Iterator, Ansicht oder Vorschau ab.* **Widerlegt, am Quelltext belegt.** `E184FindeVorabKopie` liefert einen Zeiger und hält keine Position; nach jedem `RemoveSum` sucht die Schleife neu vom Kopf (`ImapToc.cpp:1764`). `RemoveSum(CSummary*)` holt die Position per `Find` (`tocdoc.h:169-170`), `SubtractSum` nimmt den Eintrag aus der Liste der Ansicht (`DeleteString(Index)`, `tocdoc.cpp:1544-1553`) und die Vorschau wird vorher (`ImapToc.cpp:1771`) und in `SubtractSum` (`:1552`) entwertet. Rückzeiger in Rahmen räumt der Destruktor ab ([E-176](../Intern/BEFUNDE.md#e-176)). Die Nachbearbeitung läuft im Hauptfaden (wie `ImapTransferSummaryData` direkt davor, das ebenfalls `AddSum` ruft); `DoWork` im Nebenfaden fasst die Liste nicht an.
* *Endlosschleife in `while`.* **Widerlegt:** jeder Durchlauf entmarkt und entfernt den Treffer (`:1769`, `:1775`). Würde K1 mit `continue` ohne Entmarken behoben, entstünde eine — darum steht es im Vorschlag.
* *Eingebettete Bilder.* `SetDeleteEmbedded(FALSE)` (`:1770`): beim Kopieren teilen sich Quelle und Vorab-Kopie die Bilddateien (die Bytes werden mit `JJBlockMove` kopiert, `tocdoc.cpp:2997`); das Entfernen darf sie nicht löschen. Richtig. Beim Verschieben bleiben die Dateien damit liegen, bis die Quelle sie löscht — die Quelle trägt aber selbst `SetDeleteEmbedded(FALSE)` (`ImapToc.cpp:556`). Ob die Dateien dann verwaisen, habe ich nicht verfolgt; das galt vorher für die Quelle genauso. Kein Fund.
* *Labels ([E-170](../Intern/BEFUNDE.md#e-170)).* Ohne UIDPLUS gibt es keine Zuordnung, das Label geht verloren — vor der Behebung ebenso, sobald der Abgleich die Kopie ersetzte. Kein Rückschritt.

## Wiedergabe von PRÜFER-75 in `BEFUNDE.md`

Geprüft am Eintrag in `Intern/BEFUNDE.md` (Stand `8b5f8342`):

* [E-188](../Intern/BEFUNDE.md#e-188): richtig wiedergegeben — beide Stellen (`ImapToc.cpp:1302`, `:1196`, gemessen: stehen dort weiterhin), das stehende Merkzeichen, „nie gemessen", Original. Die Stufe „wichtig" stimmt mit K1 überein.
* [E-189](../Intern/BEFUNDE.md#e-189): richtig, mit Abweichung in der Stufe (K6) und der unbelegten Abgleich-Aussage (K5).
* [E-184](../Intern/BEFUNDE.md#e-184): K3 (Vertauschung bei mehreren Mails) und K4 (Neustart) sind als „nicht behoben" eingetragen, der Satz „Gregor muss nichts testen" ist durchgestrichen mit Verweis auf [E-189](../Intern/BEFUNDE.md#e-189) — beides wie gemeldet. Die Zeilennummern sind durch denselben Commit veraltet (K6).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Ist auf der Vorab-Kopie ein geändertes Nachrichtenfenster offen, löscht die Behebung die Zusammenfassung vor dem Schließen; „Abbrechen" beim Speichern-Dialog greift dann über NULL zu (`msgdoc.cpp:1028`). Neu durch die Behebung, nicht gemessen; eine Zeile `CanCloseFrame` wie in den Vorbildern schließt es. | wichtig (selten) | nein — billig vorher zu beheben |
| K2 | Das Merkzeichen gehört keiner Übertragung: gleiche alte Nummer aus zwei Quellen (oder eine liegengebliebene Kopie aus einem anderen Konto) im selben Ziel — die Funktion entfernt beide Kopien; dazu der ältere Rest von [E-184](../Intern/BEFUNDE.md#e-184) (Verwechslung zwischen den beiden). | klein | nein |
| K3 | Ohne UIDPLUS fehlt die verschobene Mail im Zielordner, bis abgeglichen wird; der Abgleich läuft nur für die letzte Übertragung, im Hintergrund, und schwankt laut Commit. Gehört in Gregors Testanweisung. | klein | nein |
| K4 | Nach Neustart mit gespeicherter Warteschlange (oder neu geladenem Ziel) fehlt das Merkzeichen; [E-189](../Intern/BEFUNDE.md#e-189) tritt dann unverändert auf. | klein | nein |
| K5 | Werte der roten Gegenprobe nirgends festgehalten (`pruefstand-lauf.ps1` zeigt die letzten vier Zeilen statt der ERGEBNIS-Zeile); „überlebt den Abgleich" weiter nur am Quelltext belegt. | klein | nein |
| K6 | Zeilennummern im E-184-Eintrag durch denselben Commit veraltet (`:2784`, `:3090`); Stufe [E-189](../Intern/BEFUNDE.md#e-189) kritisch statt wichtig (begründet); kein Quelltexttest für [E-189](../Intern/BEFUNDE.md#e-189). | klein | nein |
