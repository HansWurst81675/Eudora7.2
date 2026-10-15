# PRÜFER-30 — E-121 Teile 4 bis 6 (7.2.0.94–7.2.0.96) nachgerechnet

Gegenstand: `git diff a550a7d9..9840ee35 -- Eudora71/`, also die Teile 4 bis 6 von
[E-121](../BEFUNDE.md#e-121): `ImapMergeTmpMbx` ersetzt einen Eintrag mit derselben UID
(7.2.0.94), Vorab-Kopie an Ort und Stelle aktualisieren (7.2.0.95), Merkzeichen
`CSummary::m_bE121Vorab` mit Suche `E121FindeVorabKopie` (7.2.0.96). Gelesen am Quelltext,
nichts gebaut, nichts gestartet. Zeilen beziehen sich auf den Stand `9840ee35`.

## Urteil

**Gregors Fall (Kennung fällt mit fremder Server-UID zusammen) ist geschlossen, aber 7.2.0.96
bringt einen Rückfall: Nachrichten mit Kennung 0 werden nie mehr hochgeladen (F1).** Das trifft
jedes Verschieben aus `Out` und gesendete Post in lokalen Ordnern. Aus `Out` landet die Nachricht
dabei still im lokalen Papierkorb statt im IMAP-Ordner — wird der Papierkorb geleert, ist sie weg.
Gregors Protokoll an 1.0.96 enthält keine Übertragung mit `id=0`; sein Test deckt den Fall nicht ab.
Der vierte Teil (`ImapMergeTmpMbx`) ist **toter Code** (F2), die gefragte Use-after-free-Lage
über ihn gibt es nicht. Für die Ursache von Teil 5 gibt es eine konkretere Gegenvermutung (F4),
die auch den noch verbliebenen `RemoveSum` im Weg ohne UIDPLUS betrifft (F3).

| Fund | Einstufung | Stand |
|---|---|---|
| F1 Kennung 0 wird nie hochgeladen (Rückfall 7.2.0.96) | **Datenverlust** (verzögert, über den lokalen Papierkorb) | belegt am Quelltext, nicht gemessen |
| F2 `ImapMergeTmpMbx` wird nie aufgerufen | kosmetisch (toter Code, falsche Angabe in BEFUNDE.md) | belegt |
| F3 `RemoveSum(pVorab)` ohne UIDPLUS: Zeilenindex und offenes Fenster | falsche Anzeige, möglicher Absturz | Vermutung |
| F4 Gegenvermutung zu Teil 5: Index zählt ausgeblendete gelöschte Nachrichten mit | falsche Anzeige, möglicher Absturz | Vermutung, Mechanik belegt |
| F5 Merkzeichen geht beim Neustart verloren | falsche Anzeige | Vermutung |
| F6 Vorab-Kopie trägt eine lokale Kennung, die als Server-UID gilt | **Datenverlust** (fremde Mail), alt | Vermutung, Weg nicht durchgerechnet |
| F7 Abgleich hält eine neue Server-Mail für die Vorab-Kopie | falsche Anzeige | Vermutung |
| F8 APPEND oder `RewriteMbxStub` scheitert: Vorab-Kopie bleibt markiert | falsche Anzeige, kein Verlust | belegt |
| F9 Aktualisierung an Ort und Stelle pflegt Platzzähler und Änderungsmerker nicht | kosmetisch | belegt |

## F1 — Kennung 0 wird nie hochgeladen (Rückfall 7.2.0.96) — Datenverlust, belegt am Quelltext

`EuImap/src/ImapActionQueue.cpp:2362` sucht wie bisher über
`GetSummaryFromUIDStringFromDestination` (das kürzt die Liste), `:2365` **überschreibt** das
Ergebnis mit `E121FindeVorabKopie(m_pDestTocDoc, strtoul(strId, …))`. Diese Suche gibt bei
Kennung 0 sofort `NULL` zurück (`EuImap/src/ImapToc.cpp:1631-1632`, `ulHash == 0`). Die Quelle
wird bei Kennung 0 ebenfalls nicht benutzt (`ImapActionQueue.cpp:2372`, PRUEFER-28 P1). Also:
`pSum == NULL`, `pQuelle == NULL`, kein `APPEND`, `bHochgeladen = FALSE` → `bSomeFailed`
(`:2403-2406`).

Bis 7.2.0.95 (und im Original) fand `GetSummaryFromUID(0)` (`ImapToc.cpp:1644-1663`, keine
Sonderbehandlung von 0) den ersten Eintrag mit Kennung 0 im Ziel, also die Vorab-Kopie, und lud
sie hoch; das Original sieht den Fall ausdrücklich vor (`ImapToc.cpp:1448-1455`, „Messages in
the local Out mailbox have a hash of 0“).

Wen es trifft: jede Nachricht mit Kennung 0 — alles aus `Out` und alles, was aus `Out` in einen
lokalen Ordner verschoben wurde (gesendete Post; `CSummary::Copy` übernimmt die Kennung,
`Eudora/summary.cpp:605`). Folgen:

* **Aus `Out` verschoben:** `ImapXferFromLocalToImap` legt die Quelle schon beim Einreihen in den
  lokalen Papierkorb (`ImapToc.cpp:1018-1027`). Die Vorab-Kopie mit Kennung 0 steht im IMAP-Ordner,
  bis der Abgleich am Ende von `DoPostProcessing` (`ImapActionQueue.cpp:2457-2459`) sie verwirft,
  weil der Server sie nicht kennt. Danach gibt es die Nachricht nur noch im lokalen Papierkorb.
  **Keine Meldung:** der Zustand `kActionStateFailed` nach `DoPostProcessing` wird nirgends
  ausgewertet (`ImapActionQueue.cpp:553-558` ruft nur auf; `ErrorDialog` in
  `ImapCopyMsgFromLocalToImap` kommt nur bei gescheitertem `APPEND`, hier wird keins versucht).
  Leert der Nutzer den Papierkorb (oder leert Eudora ihn beim Beenden), ist die Nachricht verloren.
* **Kopie aus `Out` (z. B. Filter „Kopie nach IMAP-Gesendet“):** die Quelle bleibt in `Out`, im
  IMAP-Ordner kommt nie etwas an. Kein Verlust, aber die Funktion fehlt still.
* **Gesendete Post aus einem lokalen Ordner:** die Quelle bleibt stehen (`pQuelle == NULL`), nichts
  wird hochgeladen. Kein Verlust.
* **Mehrere aus `Out` auf einmal** (`"0,0,…"`): alle scheitern gleich.

Vorschlag: die Vorab-Kopie nicht über die Kennung wiederfinden, sondern über das Merkzeichen allein
— `E121FindeVorabKopie` darf bei gesetztem Merkzeichen auch Kennung 0 liefern (der erste
markierte Eintrag mit 0; nach dem Hochladen wird das Merkzeichen gelöscht, `ImapToc.cpp:1446`, der
nächste Durchlauf nimmt den nächsten). In `ImapCopyMsgFromLocalToImap` dann nicht neu suchen,
sondern `pSum` selbst wiederverwenden, wenn `this == pTargetToc && pSum->IstE121Vorab()`; im Weg aus
der Quelle (`this != pTargetToc`) keine fremde Vorab-Kopie übernehmen. Gegenprobe am Prüfstand:
eine Nachricht aus `Out` in einen IMAP-Ordner verschieben, erwartet `id=0 im-ziel=1 hochgeladen=1`;
an 7.2.0.96 ist `im-ziel=0 in-quelle=0 hochgeladen=0` zu erwarten.

## F2 — `ImapMergeTmpMbx` wird nie aufgerufen — kosmetisch, belegt

Einziger Aufruf: `EuImap/src/ImapThread.cpp:209`, innerhalb von `#ifdef OMITFORNOW`
(`:168` bis `:212`). `OMITFORNOW` ist nirgends definiert (Suche über alle `.h`, `.cpp`, `.vcxproj`,
`.props` unter `Eudora71/`: nur `#ifdef`/`#endif`). Die Datei wird gebaut
(`tools/wer-baut.pl`: `EuImap.vcxproj`), der Aufruf nicht. Der vierte Teil
(`ImapToc.cpp:3695-3715`) kann also nie laufen — passt zu Gregors Protokoll an 1.0.94 (keine Zeile
`E-121 Abgleich uebernimmt`).

Damit beantwortet: **eine Use-after-free-Lage über `ImapMergeTmpMbx` gibt es nicht.** Liefe er
doch, prüfte er das Merkzeichen nicht (`GetSummaryFromUID`, `:3702`) und entfernte auch eine
Vorab-Kopie; `DoPostProcessing` hält aber keinen Zeiger über Durchläufe hinweg, sondern sucht je
Kennung neu (`ImapActionQueue.cpp:2365`) und fiele auf die Quelle zurück. In
[BEFUNDE.md#e-121](../BEFUNDE.md#e-121) steht beim vierten Teil „Aufruf aus `ImapThread.cpp:209`“ als
Ursache des Doppels — das ist so nicht haltbar und sollte berichtigt werden; der Code kann als
toter Code stehen bleiben oder ausgebaut werden. Der wirkliche Abgleichsweg ist
`CImapMailbox::ImapAppendSumList` (`ImapMailbox.cpp:4961`, siehe F7).

## F3 — `RemoveSum(pVorab)` im Weg ohne UIDPLUS — falsche Anzeige / möglicher Absturz, Vermutung

`ImapToc.cpp:1385-1393` (Teil 3, Server ohne `APPENDUID`) entfernt die Vorab-Kopie mit
`RemoveSum`. Das ist genau der Weg, den Teil 5 im anderen Zweig vermeidet: `RemoveSum(CSummary*)`
→ `SubtractSum(pos, -1)` (`Eudora/tocdoc.h:169-170`, `tocdoc.cpp:1570`) → Zeilenindex aus
`m_Sums.GetIndex(Sum)` (`tocdoc.cpp:1535-1536`) → `DeleteString(Index)` (`:1548`). Trifft das
nicht die Zeile der Vorab-Kopie (Ursache nach Teil 5 oder nach F4), bleibt ihre Zeile mit dem
Zeiger auf die eben freigegebene Zusammenfassung (`tocdoc.cpp:1589`, `delete Sum`) in der Liste —
beim nächsten Zeichnen Zugriff auf freigegebenen Speicher. Außerdem wird vorher kein offenes
Nachrichtenfenster geschlossen; der tote Teil 4 tut das (`ImapToc.cpp:3708-3713`), hier fehlt es.
Hat der Nutzer die neue Mail im IMAP-Ordner geöffnet, während die Übertragung in der Warteschlange
stand, hält das Fenster ein Dokument, dessen `m_Sum` freigegeben wird (`tocdoc.cpp:1582-1589`:
`NukeMessageDocIfUnused` gibt ein benutztes Dokument nicht frei).

Nur bei Servern ohne UIDPLUS; GMX meldet die UID (Gregors Protokoll `neue-uid=…`), daher bei ihm
nicht aufgetreten. Vorschlag: auch hier nicht entfernen, sondern wie im Zweig mit UID markieren
oder vor dem Entfernen Fenster schließen und den Zeilenindex aus `m_SumListBox.GetIndex(pSum)`
(`tocview.cpp:219-230`) übergeben.

## F4 — Gegenvermutung zur Ursache von Teil 5 — falsche Anzeige, Mechanik belegt, Wirkung Vermutung

Teil 5 nennt als Ursache, die Reihenfolge der Fensterliste stimme nach dem Einfügen nicht mit
`m_Sums` überein („Sortierung steht noch aus“). Konkreter und am Quelltext belegt:
`SubtractSum` rechnet den Zeilenindex mit `m_Sums.GetIndex(Sum)` und dem Vorgabewert
`bIgnoreDeletedIMAP = FALSE` (`Eudora/summary.h:558-560`, `summary.cpp:293-320`) — es zählt die
gelöschten IMAP-Nachrichten mit. Die Fensterliste enthält sie aber nicht, wenn sie ausgeblendet
werden (`tocdoc.cpp:1451`, `HideDeletedIMAPMsgs()`). Die Vorab-Kopie steht am Ende von `m_Sums`
(`tocdoc.cpp:1444`, `AddTail`); jede ausgeblendete gelöschte Nachricht verschiebt den Index um eins,
schon bei einer liegt er hinter der letzten Zeile — `DeleteString` tut nichts, `AddSum` fügt eine
zweite Zeile mit **demselben Zeiger** hinzu. Das ist genau Gregors Bild an 1.0.94: doppelt in der
Liste, `summen` stimmt, nach dem Neuöffnen einmal.

Ob das bei Gregor die Ursache war, ist nicht gemessen; dafür müssten ausgeblendete gelöschte
Nachrichten im Zielordner gestanden haben. Prüfbar mit einer Spurmarke vor `SubtractSum`, die
`m_Sums.GetIndex(Sum)`, `m_Sums.GetIndex(Sum, TRUE)` und `View->m_SumListBox.GetIndex(Sum)` in
**einer** Zeile ausgibt. Die Mechanik gilt für jedes `SubtractSum`/`RemoveSum` über einen Zeiger
in einem IMAP-Ordner mit ausgeblendeten gelöschten Nachrichten (Original), hier also für F3.
Teil 5 selbst ist davon unberührt richtig: an Ort und Stelle aktualisieren braucht keinen Index.

## F5 — Merkzeichen geht beim Neustart verloren — falsche Anzeige, Vermutung

`m_bE121Vorab` steht nur im Speicher (`summary.h:474`, nicht in `Read`/`Write`, `summary.cpp:2464`/`:2543` lesen und schreiben `m_Hash`, kein Merkzeichen). Bleibt eine Übertragung über einen Neustart in der
Warteschlange (`actionqueue.dat`; [E-121](../BEFUNDE.md#e-121) Nebenbefund (a): das kommt vor), hat die geladene
Vorab-Kopie kein Merkzeichen. `E121FindeVorabKopie` findet sie nicht; bei eindeutiger Quelle wird
aus der Quelle hochgeladen (`ImapActionQueue.cpp:2394-2397`) und im Ziel eine **neue**
Zusammenfassung angelegt (`ImapToc.cpp:1412`, `:1427`, `:1436`). Die alte Vorab-Kopie mit lokaler
Kennung bleibt bis zum Abgleich daneben stehen (doppelt, wie an 1.0.90). Verwirft der Abgleich sie
nicht, weil ihre lokale Kennung zufällig eine Server-UID ist (Gregors Kollisionsfall), bleibt sie
dauerhaft: Mail doppelt in der Liste, die Leiche trägt die UID einer fremden Mail (siehe F6).
Bis 7.2.0.95 fand die Suche über die Kennung die Vorab-Kopie auch nach dem Neustart (ohne
Kollision). Kein Verlust: ohne eindeutige Quelle wird nichts hochgeladen und nichts entfernt.

## F6 — Vorab-Kopie mit lokaler Kennung gilt im IMAP-Ordner als Server-UID — Datenverlust (fremde Mail), Vermutung, alt

Im IMAP-Ordner ist `m_Hash` die UID (Kommentar `ImapToc.cpp:1441-1444`; Uidlisten werden aus
`m_Hash` gebaut, z. B. `ImapToc.cpp:1000`). Die Vorab-Kopie trägt bis zum Hochladen die **lokale**
Kennung. Bearbeitet der Nutzer sie in dieser Zeit im IMAP-Ordner — löschen, als gelesen markieren,
in einen anderen IMAP-Ordner verschieben —, geht der Befehl an den Server mit dieser Kennung als UID.
Fällt sie mit einer fremden Server-UID zusammen (Gregor an 1.0.95: Kennung 13), trifft das die
**fremde** Mail: löschen und bereinigen hieße fremde Mail weg. Das Zeitfenster ist die Wartezeit
der Warteschlange, die bis zum nächsten Start reichen kann ([E-121](../BEFUNDE.md#e-121) Nebenbefund (a)).
Nicht neu in 7.2.0.94–96 (so seit QUALCOMM), aber erst jetzt ist die Kollision belegt. Den Weg
„Löschen einer IMAP-Zusammenfassung → STORE/EXPUNGE“ habe ich nicht durchgerechnet. Vorschlag:
das Merkzeichen nutzen, um Server-Befehle für markierte Einträge zu sperren (oder die Vorab-Kopie
bis zum Hochladen mit Kennung 0 bzw. einer unmöglichen UID führen und das Wiederfinden über das
Merkzeichen allein machen, siehe F1).

## F7 — Abgleich hält eine neue Server-Mail für die Vorab-Kopie — falsche Anzeige, Vermutung

`CImapMailbox::ImapAppendSumList` (`EuImap/src/ImapMailbox.cpp:4999-5001`) legt eine vom Server
gemeldete Nachricht nur an, wenn noch keine Zusammenfassung mit ihrer UID existiert — ohne Blick auf
das Merkzeichen. Kommt während der Wartezeit eine neue Mail mit UID gleich der lokalen Kennung einer
Vorab-Kopie an, wird sie nicht angezeigt. Nach dem Hochladen trägt die Vorab-Kopie die neue UID
(`ImapToc.cpp:1445`); ob der nächste Abgleich die fremde Mail dann nachholt, habe ich nicht
nachgerechnet. Kein Verlust auf dem Server. Vorschlag: in `:4999` markierte Einträge überspringen.

## F8 — APPEND oder `RewriteMbxStub` scheitert — falsche Anzeige, kein Verlust, belegt

* **APPEND scheitert:** Fehlerdialog (`ImapToc.cpp:1358-1371`), weder Entfernen (`:1385`) noch
  Aktualisieren (`:1396`); die Vorab-Kopie bleibt **markiert** mit lokaler Kennung, die Quelle
  bleibt (`ImapActionQueue.cpp:2403-2408`). Der Abgleich am Ende (`:2457`, nur wenn
  `m_bIsLastOnMailbox`) verwirft die Kopie, wenn der Server die Kennung nicht kennt; die Bilddateien
  bleiben (`SetDeleteEmbedded(FALSE)`, `tocdoc.cpp:2932`). Mit Kollision bleibt sie als Leiche
  (wie F5). Kein Verlust.
* **Zweite Übertragung derselben Mail, solange die erste Leiche markiert ist:** die Suche nimmt den
  **ersten** markierten Eintrag (`ImapToc.cpp:1635-1640`), also die alte Leiche; der neue Eintrag
  bleibt markiert stehen, bis ein Abgleich ihn verwirft. Gleicher Inhalt, kein Verlust.
* **APPEND gelingt, `RewriteMbxStub` scheitert** (`ImapToc.cpp:1400-1401`): `bResult = FALSE`,
  obwohl die Mail auf dem Server liegt → Quelle bleibt, Vorab-Kopie bleibt markiert, der Abgleich
  holt die Server-Fassung dazu. Doppelt (Server und Quelle), kein Verlust.

## F9 — Aktualisierung an Ort und Stelle — kosmetisch, belegt

`ImapToc.cpp:1438-1439` ändert `m_Offset` und `m_Length` der Vorab-Kopie ohne die Zähler
`m_MesSpace`/`m_TotalSpace`/`m_DelSpace` nachzuführen; vorher erledigten das `SubtractSum`
(`tocdoc.cpp:1508-1509`) und `AddSum` (`:1417-1418`). Der alte Text im `.mbx` ist danach toter
Platz, der nicht als gelöscht zählt — die Schwelle fürs Komprimieren wird etwas später erreicht.
Außerdem setzt der Zweig keinen Änderungsmerker (`AddSum` tat es, `tocdoc.cpp:1480`); ob der
anschließende Abgleich die `.toc` ohnehin schreibt, ist nicht nachgerechnet. Vorschlag:
`pTargetToc->m_MesSpace += NewLength - alteLaenge; pTargetToc->SetModifiedFlag();`.

## Bestätigt

* **B1 — kein ungewolltes Übertragen des Merkzeichens.** `CSummary::Copy`
  (`summary.cpp:580-621`) übernimmt `m_bE121Vorab` nicht; der Konstruktor setzt `FALSE`
  (`:538`). `CSummary` hat keinen eigenen Kopierkonstruktor oder Zuweisungsoperator, die von
  `CObject` sind privat — keine Kopie per Wert möglich. `CImapSum::CopyToCSummary`
  (`ImapSum.cpp:351` ff.) füllt eine neue Zusammenfassung (Merkzeichen `FALSE`). Gesetzt wird das
  Merkzeichen an genau einer Stelle (`tocdoc.cpp:2933`, nur lokal → IMAP), gelöscht an einer
  (`ImapToc.cpp:1446`).
* **B2 — Gregors Kollisionsfall.** Die Suche verlangt Merkzeichen **und** Kennung
  (`ImapToc.cpp:1638`); eine fremde Server-Mail mit derselben UID hat kein Merkzeichen und wird
  weder hochgeladen noch überschrieben. Deckt sich mit Gregors Protokoll an 1.0.96 (`id=312 …
  hochgeladen=1`) und der Messung am Prüfstand.
* **B3 — kein Zugriff auf freigegebenen Speicher in `DoPostProcessing`.** Im Weg ohne UID ist
  `pVorab == pSum` (gleiche Suche, gleicher erster Treffer) und wird in `ImapToc.cpp:1391`
  freigegeben; danach wird `pSum` weder in `ImapCopyMsgFromLocalToImap` (`:1396` ist falsch) noch
  in `DoPostProcessing` dereferenziert (`ImapActionQueue.cpp:2400` vergleicht nur mit `NULL`). Jeder
  Durchlauf sucht neu, kein Zeiger überlebt eine Runde. Vermutung am Rande, alt: pumpt
  `AppendMessageFromLocal` Fensterbotschaften, könnte der Nutzer während des Hochladens `pSum` oder
  `pQuelle` entfernen — nicht nachgerechnet, im Original genauso.
* **B4 — zwei Mails mit gleicher Kennung ≠ 0, dieselbe Mail zweimal verschoben.** Jeder Durchlauf
  nimmt den ersten markierten Eintrag, der Zweig mit UID löscht dessen Merkzeichen (`:1446`), der
  nächste Durchlauf nimmt den nächsten — keine fremde Mail. Zweimal verschoben heißt zweimal
  hochgeladen (bekannt, [E-121](../BEFUNDE.md#e-121) Nebenbefund (b)), kein Verlust. Die Quelle wird bei doppelter Kennung
  nicht entfernt (`ImapActionQueue.cpp:2385-2386`). PRUEFER-29 N1 bleibt unverändert offen.
* **B5 — Listenansicht nach der Aktualisierung an Ort und Stelle.** Die Zeile behält denselben
  Zeiger; geändert werden nur `m_Offset`, `m_Length`, `m_Hash` und das Merkzeichen. Angezeigt wird
  im IMAP-Ordner die Größe aus `m_MsgSize` (`summary.cpp:648-651`), nicht `m_Length`; keine
  Sortierspalte hängt an den geänderten Feldern. Kein Neuzeichnen, kein Umsortieren nötig.
* **B6 — Spurmarken.** Die drei neuen Zeilen (`ImapActionQueue.cpp:1582-1585`, `:2432-2436`,
  `:2461-2464`) lesen nur `NumSums()`; `m_pDestTocDoc` ist an diesen Stellen gesetzt
  (`:1578`, `:2288-2292`, `:2457`). Am Rande, kosmetisch: das Ergebnis von `:2362` wird sofort überschrieben, der
  Aufruf bleibt nur wegen des Kürzens von `strUIDList` nötig — ein Kommentar dazu fehlt; die
  `atoi`-Umwandlung dort (`:1641`) ist damit für das Ergebnis bedeutungslos.
