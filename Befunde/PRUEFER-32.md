# PRÜFER-32 — 7.2.0.100 nachgerechnet

Gegenstand: `git diff b1cc0b9f..16c27e4e -- Eudora71/`, also Commit `16c27e4e` (7.2.0.100) mit den
Behebungen von [PRUEFER-31](PRUEFER-31.md) F1, F3 und F4 zu [E-121](../BEFUNDE.md#e-121) und
[E-83](../BEFUNDE.md#e-83). Gelesen am Quelltext, nichts gebaut, nichts gestartet. Zeilen beziehen
sich auf `16c27e4e`. Messdaten (nur gelesen): `C:\Temp\E118\Mailverzeichnis\eudora-{n,u,x}100{a,b}-1.log`
und `C:\Temp\E118\imap-{n,u,x}100{a,b}-1.log`, sechs Läufe an 7.2.0.100.

## Urteil

**Die drei Behebungen sind richtig.** F1, F3 und F4 tun, was [PRUEFER-31](PRUEFER-31.md) verlangt hat. Nirgends wird
Speicher benutzt, der freigegeben ist. Die richtige Sperre wird freigegeben. Nichts wird in den
Papierkorb geschrieben, was dort nicht schon im Original landete.

**Release v1.0.100: noch nicht.** Zwei Gründe:

1. **Gemessen ist F1 nicht.** Alle sechs Läufe verschieben **eine** Mail mit Kennung `514638030`.
   `id=0` steht in keinem Protokoll. Der Fall, für den 7.2.0.100 gebaut ist (mehrere Mails aus `Out`
   auf einmal), ist ungeprüft. Gregors Probe aus [PRUEFER-31](PRUEFER-31.md) steht noch aus: drei Mails aus `Out`
   gleichzeitig in einen IMAP-Ordner. Erwartet werden dreimal `id=0 … hochgeladen=1` mit drei
   **verschiedenen** `neue-uid`.
2. **N1 ist ein verbliebener Weg zum Datenverlust** (verzögert, über den lokalen Papierkorb). Es geht
   um Vorab-Kopien, für die nie ein Auftrag entsteht. Ein solcher Fall ist alltäglich: der Server ist
   beim Verschieben nicht erreichbar. Gegenüber dem Original ist das kein Rückfall. Nach der Regel
   „kein Paket mit offenem Datenverlust“ gehört N1 aber vor das Release. Die andere Möglichkeit:
   Gregor nimmt N1 ausdrücklich als bekannten Fehler mit Abhilfe in den README-Abschnitt
   „Auf einen Blick“.

| Fund | Einstufung | Stand |
|---|---|---|
| F1 ([PRUEFER-31](PRUEFER-31.md)) Vorab-Kopie wird mehrfach genommen | — | **behoben**, am Quelltext belegt, Fall „mehrere aus `Out`“ nicht gemessen |
| F3 ([PRUEFER-31](PRUEFER-31.md)) leere Kennungsliste | — | **behoben**, am Quelltext belegt, nicht gemessen |
| F4 ([PRUEFER-31](PRUEFER-31.md)) Sperre über `RemoveTaskInfo` | — | **behoben**, belegt; Restfenster wie im Original |
| N1 Vorab-Kopien ohne Auftrag bleiben markiert und werden vom nächsten Auftrag mit Kennung 0 genommen | **Datenverlust** (verzögert, Papierkorb) | Mechanik belegt, Ablauf nicht gemessen |
| N2 Nach einem Fehlschlag bleibt eine unmarkierte Kopie mit lokaler Kennung; fällt die mit einer Server-UID zusammen, gilt sie als diese Nachricht | **Datenverlust** (fremde Mail beim Löschen), selten | Mechanik belegt, alt, durch 7.2.0.100 nicht verändert |
| N3 Kommentar `ImapToc.cpp:1359` „bleibt die Quelle stehen“ gilt nicht für `Out` | kosmetisch | belegt |
| N4 Am Prüfstand ohne UIDPLUS ist „einmal im Ziel“ nicht messbar: `NOOP` meldet kein `EXISTS` | kosmetisch (Prüflücke) | belegt |
| F2, F5, F6, F7 ([PRUEFER-31](PRUEFER-31.md)) | wie dort | **unverändert offen**, 7.2.0.100 berührt sie nicht |

## F1 — nachgerechnet: behoben

Die Änderung besteht aus zwei Stellen:

* `EuImap/src/ImapToc.cpp:1361-1362`: Ist `this == pTargetToc`, wird das Merkzeichen an `pSum` vor
  `AppendMessageFromLocal` gelöscht. Das heißt: Die Vorab-Kopie selbst wird hochgeladen.
* `ImapToc.cpp:1400`: Ohne neue UID wird im selben Fall `pVorab = pSum` genommen und nicht mehr
  gesucht. Das ist zwingend. Weil das Merkzeichen schon gelöscht ist, fände
  `E121FindeVorabKopie` (`ImapToc.cpp:1649-1665`, prüft `IstE121Vorab`) `pSum` nicht mehr. Sie
  träfe dann die Kopie eines **anderen** Auftrags mit derselben Kennung, oder sie träfe nichts.

Die Fälle im Einzelnen. „Kopie“ heißt die markierte Vorab-Kopie im Ziel, `DoPostProcessing` steht
in `EuImap/src/ImapActionQueue.cpp`.

| Fall | Was geschieht | Ergebnis |
|---|---|---|
| mehrere Kennung 0, UIDPLUS | Runde 1 nimmt Kopie V1 (`:2369`), Merkzeichen weg, `RewriteMbxStub` ersetzt sie (`ImapToc.cpp:1429-1430`, `:1465`). Runde 2 findet V2. | jede genau einmal, richtig |
| mehrere Kennung 0, ohne UIDPLUS | Merkzeichen weg, `APPEND` gelingt, `:1396` greift nicht (Kennung 0). Die Kopie bleibt **unmarkiert** mit Kennung 0. Runde 2 findet V2. | jede genau einmal, richtig. Bis zum Abgleich steht jede Mail lokal zweimal da. Der Abgleich verwirft die Kopien: UID 0 kommt in die Liste (`ImapMailbox.cpp:7400-7404`), `ImapRemoveListedTocs` entfernt **jeden** Eintrag dieser UID (`ImapToc.cpp:1761-1824`). |
| `APPEND` scheitert | Merkzeichen weg, Fehlerdialog (`:1380`). Runde 2 nimmt die **nächste** Kopie. | je Mail ein Dialog, jede wird versucht. Vorher: dreimal derselbe Dialog. |
| `APPEND` gelingt, `RewriteMbxStub` scheitert | Mail auf dem Server, Kopie unmarkiert mit lokaler Kennung, `bHochgeladen=0`, also `bSomeFailed` (`:2420-2423`). Die Quelle wird nicht entfernt (`:2428`). | Kennung ≠ 0: doppelt (Quelle und Server), kein Verlust. Kennung 0: die Quelle liegt im Papierkorb, die Mail auf dem Server. Siehe N2. |
| Kennung ≠ 0 ohne UIDPLUS, aus dem Ziel | `pVorab = pSum`, `RemoveSum(pSum)` (`:1404`) | **jetzt die richtige** Zusammenfassung. Gemessen in u100a und u100b: `neue-uid=0`, `summen=0` direkt nach dem Hochladen, die einzige Kopie ist weg, beide Läufe enden mit `ExitInstance: erreicht`. |
| aus der Quelle (`pQuelle`, `this != pTargetToc`) | Das Merkzeichen wird nicht berührt (`:1361`). `:1400` sucht wie bisher. Den Zweig gibt es nur, wenn `:2369` im Ziel keine markierte Kopie dieser Kennung fand, also liefert die Suche `NULL`. | unverändert, richtig |

**Wird `pSum` nach `RemoveSum` noch benutzt? Nein, belegt.** `CTocDoc::RemoveSum` gibt frei
(`Eudora/tocdoc.cpp:1589`, `delete Sum`). In `ImapCopyMsgFromLocalToImap` steht danach nur noch
`if (bResult && NewUid)` (`:1409`). `NewUid` ist in diesem Zweig 0, und `return bResult` greift
nicht auf `pSum` zu. Im Aufrufer `DoPostProcessing` kommt `pSum` nach dem Aufruf (`:2409`) nur
noch einmal vor: als `pSum != NULL` in der Spurzeile (`:2417`). Das ist ein reiner Zeigervergleich.
`pCopySum` bleibt `NULL` (`:1342`) und wird im Aufrufer nicht gelesen. Die nächste Runde sucht in
`m_Sums`, und dort steht `pSum` nicht mehr. Die einzigen Aufrufer sind `:2409` und `:2413`. Der Weg
„`RemoveSum` auf die hochgeladene Kopie“ ist übrigens nicht neu: Bis 7.2.0.99 lieferte die Suche an
`:1400` in diesem Fall ebenfalls `pSum` selbst, denn das Merkzeichen stand noch.

**Über Aufträge hinweg** ([PRUEFER-31](PRUEFER-31.md) F1, letzter Absatz): Behoben für jede Kopie, die **versucht**
wurde. Sie ist danach unmarkiert, und der nächste Auftrag greift sie nicht mehr. Ein späterer
Auftrag mit derselben Kennung ≠ 0 fällt jetzt auf die Quelle zurück (`:2411-2413`) und nimmt nicht
mehr die liegengebliebene Kopie. Das ist die bessere Richtung. Nicht behoben ist das für Kopien, die
**nie versucht** werden, siehe N1.

**Nach einem Fehlschlag bleibt eine unmarkierte Kopie stehen** (gefragt). Wie lange sie bleibt,
hängt von ihrer Kennung ab:

* **Kennung 0:** Sie bleibt nur bis zum nächsten Abgleich (siehe Tabelle). Ist der Auftrag nicht der
  letzte auf dem Ordner (`m_bIsLastOnMailbox`, `:2478`), läuft der Abgleich erst später. In n100b
  und x100a fehlt die Zeile `Ziel nach dem Abgleich`, dort lief am Ende keiner. Die Kopie ist
  unmarkiert, also nimmt sie kein anderer Auftrag mehr.
* **Kennung ≠ 0:** Siehe N2.

## F3 — nachgerechnet: behoben

`ImapActionQueue.cpp:2364-2365`: Bei leerer Liste bricht die Schleife ab, bevor gesucht wird.

* **Folgen für `bSomeFailed` und `m_iState`:** keine. Auch vorher galt bei leerer Liste
  `!strVorher.IsEmpty()` als falsch (`:2420`), es gab also keinen Fehlschlag. `m_iState` wird
  `kActionStateSucceeded` (`:2470`), wie vorher.
* **Abgleich am Ende:** Er läuft wie vorher, wenn der Auftrag der letzte auf dem Ordner ist
  (`:2478`). Das ist sogar nützlich: Er verwirft die markierte Kopie der übersprungenen Mail, wenn
  ihre Kennung nicht auf dem Server steht. Bei Kennung 0 ist das immer so.
* **Eine leere Stelle mitten in der Liste,** die die übrigen Kennungen abschneiden würde, kann es
  nicht geben. Die Liste entsteht aus `"%lu"` und `",%lu"` (`ImapToc.cpp:1000-1005`) und wird
  unverändert gespeichert.
* Vor der Änderung lief bei leerer Liste genau eine Runde. Jetzt läuft keine. Sonst ist nichts anders.

Die zweite Hälfte des Vorschlags aus [PRUEFER-31](PRUEFER-31.md) ist **nicht** umgesetzt: bei leerer Liste keinen
Auftrag einreihen, die Vorab-Kopie der übersprungenen Mail entfernen. Die Kopie bleibt markiert.
Das ist ein Fall von N1.

## F4 — nachgerechnet: behoben

* **Richtiges Sperrobjekt: ja.** `lock` an `Eudora/QCTaskManager.cpp:1020` ist das äußere Objekt von
  `:977` (`m_ObjGuard`). Das innere `CSingleLock lock(&m_Guard_TaskInfoList)` (`:1000`) verdeckt den
  Namen nur in seinem Block `:999-1016`, und der ist an `:1020` geschlossen. Im zweiten Zweig heißt
  das innere Objekt `lockListe` (`:1052`), sein Block endet an `:1070`. Also ist `:1071` ebenfalls
  `m_ObjGuard`.
* **Kein doppeltes Freigeben:** `CSingleLock::Unlock` setzt `m_bAcquired` zurück. Der Destruktor
  am Funktionsende gibt dann nichts mehr frei (MFC `mtex.cpp`). Im Zweig `TOBJ_ERROR` und im Fall
  ohne altes Fenster und ohne `pWnd` bleibt die Sperre bis zum Ende stehen, wie im Original.
* **Ist die Sperre danach noch nötig? Nein.** Nach `:1020` bzw. `:1071` kommen nur noch drei Dinge:
  die Schleife über die lokale Liste `lErledigt`, `RemoveTaskInfo`, das selbst
  `m_Guard_TaskInfoList` nimmt (`:819`), und `return pOldWnd`, eine lokale Kopie. `m_DispWndMap`
  ist vorher unter der Sperre gesetzt (`:980`). Alles läuft im Hauptfaden.
* **Restfenster: wie im Original.** `SetDisplayWindow` nimmt weiterhin erst `m_ObjGuard`, dann die
  Liste (`:977` → `:1000`). `Register(CTaskInfoMT*)` sperrt umgekehrt (`:161` → `:186`). Dasselbe
  stand schon im Original (`567a5d87`, `SetDisplayWindow`, Zweig `TOBJ_INFO`), dort ohne
  Rückruf und ohne Dialog. Den modalen Dialog und den Gruppenrückruf ruft `RemoveTaskInfo` unter der
  **Listen**sperre auf (`:819`, `:876`, `:887`). Das ist der unveränderte Weg des Originals, den auch
  `CTaskStatusView::OnMsgDeleteInfo` nimmt.
* Am Prüfstand nicht messbar: `gruppe=0`, kein Zertifikatsdialog. In allen sechs Läufen steht genau
  einmal `beim-Umhaengen-schon-fertig-entfernt: uid=1`, und alle sechs enden mit
  `ExitInstance: erreicht`.

## N1 — Vorab-Kopien ohne Auftrag bleiben markiert — Datenverlust (verzögert), Mechanik belegt

`CTocDoc::Xfer` legt die markierte Vorab-Kopie im IMAP-Ziel an und markiert die Quelle
(`Eudora/tocdoc.cpp:2930-2935`, `:2944`). Erst **danach** entscheidet
`ImapXfer` (`:3087`) → `ImapXferMessages` → `ImapXferFromLocalToImap`, ob überhaupt ein Auftrag
entsteht und für welche Mails. In folgenden Fällen bleibt die Kopie **markiert** liegen, und zu ihr
gibt es keinen Auftrag:

* **Server nicht erreichbar:** `OpenMailbox` scheitert, `ImapToc.cpp:431-432` `return NULL`.
* **Offline und nicht erlaubt:** `:407-410`.
* **Zielordner nur lesbar:** `:377-382`.
* **Konto nicht gefunden:** `:950-953`.
* **Fenster lässt sich nicht schließen** (Verfassen-Fenster, Nutzer bricht „Änderungen speichern?“
  ab): `:993` `continue`. Das ist der Fall F3.
* **Esc während der Schleife:** `:988-989` `break`. Alle folgenden Mails bleiben ohne Auftrag.

Die Quelle wird in diesen Fällen nicht angefasst, sie bleibt in `Out`. Für sich allein ist das ein
Doppel und kein Verlust. Der Verlust entsteht beim **nächsten** Auftrag mit Kennung 0, wenn er vor
dem nächsten Abgleich dieses Ordners läuft:

1. Der Nutzer verschiebt Mail A aus `Out` in den IMAP-Ordner, der Server ist nicht erreichbar.
   Zurück bleibt Kopie A, markiert, Kennung 0. Ohne Verbindung läuft kein Abgleich, der sie
   verwerfen könnte.
2. Später verschiebt er Mail B aus `Out`. `Xfer` hängt Kopie B **hinter** A an (`AddTail`). Die
   Quelle B kommt beim Einreihen in den lokalen Papierkorb (`ImapToc.cpp:1018-1027`).
3. `DoPostProcessing` sucht für `id=0` die **erste** markierte Kopie (`ImapActionQueue.cpp:2369`,
   `ImapToc.cpp:1657-1662`). Es findet A. A wird hochgeladen, die Spur zeigt
   `id=0 im-ziel=1 … hochgeladen=1`.
4. Kopie B bleibt markiert. Der Abgleich am Ende verwirft sie (UID 0 steht nicht auf dem Server).
5. Am Ende liegt A auf dem Server **und** in `Out`. B liegt nur im lokalen Papierkorb. Beim Beenden
   läuft `EmptyTrash` ([PRUEFER-31](PRUEFER-31.md) F1). Leert die Einstellung den Papierkorb, ist B weg. Eine Meldung
   gibt es nicht.

Dasselbe geschieht innerhalb **einer** Übertragung, wenn die übersprungene Mail (Fenster, `:993`)
vor einer verschobenen steht. Nach einem Esc stehen die Liegengebliebenen hinten. Sie stören dann
erst den nächsten Auftrag.

Einordnung:

* **Kein Rückfall gegenüber dem Original:** `GetSummaryFromUID(0)` nahm dort jede beliebige
  Zusammenfassung mit Kennung 0.
* **Gegenüber 7.2.0.96 schon:** Damals fand die Suche bei Kennung 0 nichts. Seit 7.2.0.97
  (PRUEFER-30 F1) findet sie markierte Kopien mit 0.
* 7.2.0.100 schließt diesen Weg für versuchte Kopien, für nie versuchte nicht.
* Bei Kennung ≠ 0 entsteht kein Verlust: Der nächste Auftrag derselben Kennung nimmt die
  liegengebliebene Kopie. Die stammt von derselben Quelle oder von einem Namensvetter (dann ein
  Doppel, siehe [PRUEFER-31](PRUEFER-31.md) F2).
* Gemessen ist der Ablauf nicht.

Vorschlag. Die Zuordnung „welche Kopie gehört zu welcher Quelle“ kennt nur `Xfer`, also gehört die
Behebung dorthin:

* `Xfer` führt eine lokale Liste der Paare (Quelle, Vorab-Kopie), die es anlegt.
* `ImapXferFromLocalToImap` löscht an jeder Quelle, die es **nicht** einreiht, das Merkzeichen
  `SetE121Quelle(FALSE)`. Das betrifft `:993`, den Esc-Abbruch und die frühen Rücksprünge, die dann
  in `ImapXferMessages` vor `return NULL` kommen.
* Nach `ImapXfer` entfernt `Xfer` jede Vorab-Kopie, deren Quelle kein Merkzeichen mehr trägt:
  `SetDeleteEmbedded(FALSE)`, dann `RemoveSum`.

Damit ist zugleich ein Teil von [PRUEFER-31](PRUEFER-31.md) F2 erledigt. Die Kurzfassung wäre, die Prüfung an `:993`
in `Xfer` vorzuziehen. Das deckt aber nur den Fensterfall ab, nicht den Fall „Server nicht
erreichbar“, und gerade der ist der häufigste.

Gegenprobe am Prüfstand: den Server beim ersten Verschieben aus `Out` nicht starten. Dann den Server
starten und eine **andere** Mail aus `Out` verschieben. Erwartet wird, dass auf dem Server die
zweite Mail liegt (Inhalt von `append-001.eml` gegen die Mail prüfen) und dass im Papierkorb keine
Mail ohne Gegenstück steht.

## N2 — Unmarkierte Kopie mit lokaler Kennung gleich einer Server-UID — Datenverlust, selten, alt

Gefragt war, ob eine nach einem Fehlschlag liegengebliebene Kopie mit einer Server-UID verwechselt
werden kann. **Ja, wenn ihre lokale Kennung im Ordner als Server-UID vorkommt** (der
E-121-Kollisionsfall, Prüfstand `--fremde-uid`). Das Merkzeichen spielt dabei keine Rolle, denn der
Abgleich kennt es nicht:

* `GetCurrentUids` (`EuImap/src/ImapMailbox.cpp:7376-7407`) nimmt **jede** Zusammenfassung mit ihrer
  Kennung in die Liste auf, ebenso für den Hintergrundabgleich (`ImapMailMgr.cpp:337`).
* Steht die Kennung auf dem Server, bleibt die Kopie stehen.
* Löscht der Nutzer diese Kopie, geht das Löschen an die Server-UID, also an die **fremde** Mail.

Das galt vor 7.2.0.100 genauso: Damals blieb die Kopie markiert, aber der Abgleich sah das nicht.
Auch im Original war es so. **Durch 7.2.0.100 nicht verändert.** Es gibt nur einen Unterschied: Ein
Wiederholungsauftrag derselben Kennung nahm die alte markierte Kopie früher noch einmal. Bei Erfolg
hätte er sie mit UIDPLUS zur Server-Fassung gemacht. Jetzt nimmt er die Quelle, und die alte Kopie
bleibt. Der Fehlschlag allein hinterlässt aber in beiden Fassungen genau eine solche Kopie.

Voraussetzungen: `APPEND` oder `RewriteMbxStub` scheitert, und die lokale Kennung fällt mit einer
Server-UID im Zielordner zusammen. Beides zusammen ist selten.

Nebenbei, eine Vermutung, nicht nachgerechnet: Weil `GetCurrentUids` die lokalen Kennungen der
Kopien mitzählt, bestimmt eine hohe lokale Kennung (in den Läufen `514638030`) über
`GetHighestUid` den Punkt, ab dem neue Nachrichten geholt werden (`ImapChecker.cpp:820`,
`ImapMailbox.cpp:1968`). Neue Server-Nachrichten unterhalb dieser Kennung würden dann bei diesem
Abgleich nicht geholt. Das wäre eine falsche Anzeige und kein Verlust.

Vorschlag, eine Stelle, schließt N2 und macht den Abgleich als Aufräumer unnötig:
`ImapCopyMsgFromLocalToImap` entfernt bei `this == pTargetToc && !bResult` die Kopie sofort, mit
`SetDeleteEmbedded(FALSE)` und `RemoveSum(pSum)`. Der Aufrufer dereferenziert `pSum` nicht, das ist
oben belegt. Die Quelle bleibt bei Kennung ≠ 0 stehen. Bei `Out` liegt sie im Papierkorb wie im
Original, und der Fehlerdialog ist erschienen. Nicht vor dem Release nötig.

## N3 — Kommentar „bleibt die Quelle stehen“ — kosmetisch, belegt

`ImapToc.cpp:1359-1360`: *„Scheitert der Versuch, bleibt die Quelle stehen“*. Für Mails aus `Out`
und für Entwürfe (`IsComp`) stimmt das nicht. Ihre Quelle liegt seit dem Einreihen im lokalen
Papierkorb (`:1018-1027`). Gerade um diese Mails geht es in F1. Vorschlag: „bleibt die Quelle
stehen (aus `Out`: im lokalen Papierkorb)“.

## N4 — Prüfstand ohne UIDPLUS: „einmal im Ziel“ ist nicht messbar — Prüflücke, belegt

In u100a und u100b steht `Ziel nach dem Abgleich: summen=0`. Die hochgeladene Mail ist auf dem
Server: `APPEND … OK APPEND completed`, `append-001.eml` liegt in der Ablage. Lokal erscheint sie aber
nicht. Nach dem `APPEND` schickt Eudora nur `NOOP`, und `tools/imap-pruefserver.pl:389` beantwortet
`NOOP` ohne `* n EXISTS`. Eudora erfährt also nicht, dass eine Nachricht dazukam. Das ist ein Mangel
des Prüfservers, kein Fehler in Eudora: Ein echter Server meldet `EXISTS`.

Folge: Der Teil von [E-121](../BEFUNDE.md#e-121) „ohne UIDPLUS genau einmal im Ziel“ ist am Prüfstand in beiden Richtungen
blind. Ein Doppel würde er ebenso wenig zeigen wie ein Fehlen. Vorschlag: Der Prüfserver meldet bei
`NOOP` für das gewählte Postfach `* n EXISTS`, wenn sich `n` seit der letzten Meldung geändert hat.

## Unverändert offen aus [PRUEFER-31](PRUEFER-31.md): F2, F5, F6, F7

7.2.0.100 ändert weder `tocdoc.cpp` noch `TaskStatusWazooWnd.cpp` noch `tools/paket-pruefen.ps1`.

* **F2** (`m_bE121Quelle` bleibt hängen): unverändert. Neu kommen die N1-Fälle dazu. Dort bleibt das
  Merkzeichen ebenfalls stehen, weil nie ein Auftrag entsteht. Der Vorschlag zu N1 räumt es dort mit
  ab.
* **F5** (Zweig „ohne Anzeige“ läuft nie): unverändert. In allen sechs Läufen stehen
  `ohne-Anzeige`, `Anzeige-nachgetragen` und `ohne-Anzeige-erledigt-entfernt` je 0-mal. Gewirkt hat
  wieder der erste Zweig (`beim-Umhaengen-schon-fertig-entfernt` je einmal). Der Kommentar an
  `QCTaskManager.cpp:1040-1049` nennt weiter die nicht gemessene Ursache.
* **F6** (`aktiv` unter 0): unverändert. `aktiv=-1/10` steht in n100a (9-mal), x100a (4-mal) und
  x100b (6-mal), jeweils nach einer zweiten Aufgabe `zustand=ERZEUGT(1) m_pThread=NULL`.
* **F7** (Defender-Block): unverändert, `ProgramW6432` und `ExclusionPath` stehen nicht in
  `tools/paket-pruefen.ps1`.

## Bestätigt an den Läufen von 7.2.0.100

* Alle sechs Läufe melden `Version 7.2.0.100` und enden mit `ExitInstance: erreicht`.
* **n100a und n100b** (UIDPLUS): `neue-uid=1`, `summen=1` nach dem Hochladen und, wo der Abgleich
  lief (n100a), auch danach.
* **u100a und u100b** (ohne UIDPLUS): Die Kopie wird über den neuen Weg `pVorab = pSum` entfernt
  (`summen=0`). Kein Absturz, also wurde der freigegebene Zeiger nicht benutzt.
* **x100a und x100b** (fremde UID `514638030` gleich der lokalen Kennung): `neue-uid=514638031`,
  `summen=2`, die fremde Nachricht unverändert.
* `markiert=1 hochgeladen=1` in allen sechs Läufen. Die Quelle wurde nur nach dem Hochladen entfernt.
