# PRÜFER-33 — 7.2.0.101 nachgerechnet

Gegenstand: `git diff 01f4a2a8..04a33cca -- Eudora71/`, also Commit `04a33cca` (7.2.0.101) mit den
Behebungen von [PRUEFER-32](PRUEFER-32.md) N1 und N2 zu [E-121](../BEFUNDE.md#e-121) und den Spurmarken
zu [E-67](../BEFUNDE.md#e-67). Gelesen am Quelltext, nichts gebaut, nichts gestartet. Zeilen beziehen
sich auf `04a33cca`. Messdaten (nur gelesen): `C:\Temp\E118\Mailverzeichnis\eudora-{n101,r101,x101a,x101b}-1.log`,
`eudora-e67b.log`, `eudora-e67rot.log` und `C:\Temp\E118\imap-*101*-1.log`.

## Urteil

**Beide Behebungen sind richtig.** N1 (eine liegengebliebene Vorab-Kopie wird von der nächsten
gesendeten Mail genommen) ist am Quelltext geschlossen. N2 (eine gescheiterte Vorab-Kopie bleibt
mit lokaler Kennung liegen) ist geschlossen und gemessen. Die E-67-Spurmarken verändern nichts.

**Release v1.0.101 nach Gregors Test: ja, unter zwei Bedingungen.**

1. **Gregors Test muss den neuen Weg zeigen.** Kein Lauf am Prüfstand berührt `E121NeueKennung`.
   Alle vier E-121-Läufe verschieben eine Mail aus `In` mit der alten Kennung `514638030`. Gregors
   Probe aus `Releases/1.0.101/TESTEN.txt` (zwei gesendete Mails zusammen in die OUTBOX) ist der
   einzige Beleg. Richtig ist sie nur, wenn in seiner `eudora.log` **zwei** Zeilen
   `E-121 Uebertragung: id=… im-ziel=1 … hochgeladen=1` stehen, mit **zwei verschiedenen** `id`,
   beide mindestens `268435456`. Steht dort `id=0`, ist der neue Weg nicht gelaufen.
2. **Die README-Zusage muss berichtigt werden, oder Q1 wird vorher behoben.** `README.md` sagt
   *„eine verschobene Nachricht kann nicht mehr verlorengehen“* und *„In keinem dieser Fälle geht
   eine Nachricht in Ihrem Postfach verloren“*. Für gesendete Post stimmt das nicht (Q1). Der Fehler
   ist alt und steht seit [PRUEFER-28](PRUEFER-28.md) im Bestand. 7.2.0.101 verschlechtert ihn nicht.
   Erst die neue eigene Kennung macht ihn aber mit wenigen Zeilen behebbar.

| Fund | Einstufung | Stand |
|---|---|---|
| N1 ([PRUEFER-32](PRUEFER-32.md)) liegengebliebene Vorab-Kopie wird von der nächsten gesendeten Mail genommen | — | **behoben**, am Quelltext belegt, **nicht gemessen** (Prüfstand kann `Out` nicht) |
| N2 ([PRUEFER-32](PRUEFER-32.md)) gescheiterte Vorab-Kopie bleibt mit lokaler Kennung | — | **behoben**, belegt und gemessen (r101) |
| Q1 Gesendete Post: verwirft ein Abgleich die Vorab-Kopie vor dem Hochladen, liegt die Mail nur im lokalen Papierkorb | **Datenverlust** (verzögert, Papierkorb) | alt (PRUEFER-28, wie im Original), unverändert; Mechanik belegt, Ablauf nicht gemessen |
| Q2 Liegengebliebene Vorab-Kopie mit hoher Kennung: im Zielordner wird neue Post beim nächsten Abruf nicht als neu geholt | falsche Anzeige, vorübergehend | Vermutung, Mechanik belegt; für `Out` neu in 7.2.0.101 |
| Q3 Fenster der gescheiterten Vorab-Kopie wird ohne `CanCloseFrame` geschlossen | Absturz, sehr selten | Vermutung |
| Q4 Beim **Kopieren** aus `Out` behält die Quelle dauerhaft die neue Kennung | keine Wirkung gefunden | belegt (alle Leser von `m_Hash` durchgesehen) |
| Q5 Kommentare „Kennung 0 = `Out`“ und „verwirft der nächste Abgleich“ sind überholt (erweitert N3) | kosmetisch | belegt |
| Q6 [E-67](../BEFUNDE.md#e-67): `verb-auswahl` ist der Wert vor `DDX_CBIndex`, nicht die Auswahl im Feld | kosmetisch | belegt |
| Q7 `TESTEN.txt` nennt die Protokollzeile nicht, an der Gregors Test erst etwas beweist | kosmetisch (Prüflücke) | belegt |
| F2, F5, F6, F7 ([PRUEFER-31](PRUEFER-31.md)), N4 ([PRUEFER-32](PRUEFER-32.md)) | wie dort | **unverändert offen**; F2 wird für gesendete Post harmloser |

## N1 — nachgerechnet: behoben

Die Änderung steht an zwei Stellen:

* `Eudora/tocdoc.cpp:2937-2942`: Hat die Quelle die Kennung 0, bekommen Quelle und Vorab-Kopie
  dieselbe neue Kennung aus `E121NeueKennung`. Das geschieht im Zweig lokal → IMAP (`:2930`), vor
  `AddSum` der Kopie (`:2952`).
* `EuImap/src/ImapToc.cpp:1675-1694`: `E121NeueKennung` bildet einen Wert aus `GetTickCount`,
  einem Zähler und `0xE1210000`. Ein Wert unter `0x10000000` wird auf `≥ 0x80000000` gehoben. Werte,
  die in Quelle oder Ziel schon vorkommen, werden übersprungen (`GetSummaryFromUID`, `:1683-1686`).

**Der Ablauf aus PRUEFER-32 N1 jetzt.** Mail A wird aus `Out` verschoben, der Server ist nicht
erreichbar. Zurück bleibt Kopie A mit Kennung `K_A`, markiert. Später wird Mail B verschoben, ihre
Kopie bekommt `K_B`. `DoPostProcessing` sucht `E121FindeVorabKopie(Ziel, K_B)`
(`ImapActionQueue.cpp:2369`, `ImapToc.cpp:1697-1715`) und findet **nur** Kopie B. B wird
hochgeladen. A bleibt in `Out` (`K_A` ist mit `Write()` an `tocdoc.cpp:3080` schon in `Out.toc`
gespeichert). Kopie A verwirft der nächste Abgleich. Ihre Bilddateien bleiben dabei erhalten, denn
`SetDeleteEmbedded(FALSE)` steht an `:2932`. **Nichts geht verloren.** Dasselbe gilt für den
Fensterfall (`ImapToc.cpp:993`) und den Esc-Abbruch (`:988-989`) innerhalb einer Übertragung.

**Wiederholt der Nutzer das Verschieben von A,** behält A ihre Kennung `K_A` (`:2937` greift nicht).
Liegt Kopie A1 noch markiert im Ziel, nimmt der Auftrag A1 statt A2. Beide sind Kopien derselben
Mail, also gibt es keinen Verlust. A2 verwirft der Abgleich.

**Ist die Kennung eindeutig genug?**

* **Gegen andere Nachrichten in Quelle und Ziel: ja.** Vorhandene Werte werden übersprungen. Zwei
  Aufrufe in derselben Millisekunde unterscheiden sich im Zähler (`<< 8`). Eine Kollision bleibt nur
  mit Wahrscheinlichkeit von etwa 1 zu 2³² je Paar möglich, und das Merkzeichen schützt zusätzlich.
* **Gleiche Kennung entsteht sonst nur durch Kopieren.** `CSummary::Copy` übernimmt `m_Hash`
  (`summary.cpp:606`). Zwei Nachrichten mit gleichem `K` sind also Kopien derselben Mail.
  Verwechselt die Suche sie, ist der Inhalt derselbe. `SendAgain` legt eine **neue**
  Zusammenfassung mit Kennung 0 an (`summary.cpp:1912`, `NewCompDocument`). Die Kennung wandert also
  nicht in neue Post.
* **Gegen Server-UIDs: genügend.** Server-UIDs, die noch nicht im lokalen Zwischenspeicher stehen,
  prüft `E121NeueKennung` nicht. RFC 3501 erlaubt UIDs bis 2³²−1. Werte ab 268 Millionen sind
  aber selten. Außerdem lebt die Kopie mit `K` nur bis `DoPostProcessing`: Mit UIDPLUS bekommt sie
  die Server-UID (`ImapToc.cpp:1465`), ohne UIDPLUS wird sie entfernt (`:1396-1406`, das gilt jetzt
  auch für `Out`), beim Fehlschlag ebenso (`:1488-1500`). Eine Kollision wirkt nur bei einer
  liegengebliebenen Kopie (N1-Fälle). Dann gilt PRUEFER-32 N2: Die Kopie gilt als die fremde Mail.
  Vermutung, praktisch ausgeschlossen.
* **Gegen LMOS (POP „auf dem Server lassen“): Vermutung, praktisch ausgeschlossen.**
  `CLMOSRecord(Sum)` sucht über `m_Hash` (`MsgRecord.cpp:960-971`). Die Quelle liegt danach mit `K`
  im lokalen Papierkorb. Wird sie dort gelöscht und ist „vom Server löschen, wenn aus dem Papierkorb
  entfernt“ eingestellt (`tocdoc.cpp:2894-2904`), wird nach einem POP-Eintrag mit Hash `K` gesucht.
  Ein Treffer setzt eine Kollision mit einem 32-Bit-Hash voraus, also etwa (Zahl der LMOS-Einträge)
  zu 4·10⁹. Folge wäre: eine fremde POP-Mail wird auf dem Server zum Löschen vorgemerkt.
* **Spool (`SpoolMgr.cpp:450`):** nimmt den Hash aus dem LMOS-Eintrag, nicht aus der
  Zusammenfassung. Nicht betroffen.
* **Randwert `0xFFFFFFFF`:** möglich (1 zu 2³²). `ImapGetMinSummaryUid` benutzt ihn als Marke für
  „leer“ (`ImapToc.cpp:4270-4284`). Kosmetisch, nicht weiter verfolgt.

**Gibt es Stellen, die Kennung 0 für Nachrichten aus `Out` voraussetzen?** Durchgesehen sind alle
Leser von `GetHash()`, `SetHash(` und `m_Hash` in `Eudora/` und `EuImap/src/`:

* **Senden, Warteschlange, Send Again, Suche, Undo:** keine Stelle liest den Hash. Senden und
  Warteschlange laufen über `m_State`. Send Again legt eine neue Zusammenfassung an. Der Weg lokal →
  IMAP hat kein Undo (`tocdoc.cpp:2977`, `:2987`).
* **Filter:** `ImapFiltersd.cpp` liest den Hash nur für IMAP-Ordner. Ein Ausgangsfilter „transfer
  in einen IMAP-Ordner“ läuft durch denselben Zweig von `Xfer` (`SingleSum`) und bekommt ebenfalls
  eine Kennung. Gewollt.
* **Junk-Plugins** bekommen den Hash als Nachrichtenkennung (`Trnslate.cpp:4822`). Ob ein Plugin bei
  gesendeter Post mit 0 rechnet, ist nicht prüfbar. Vermutung: keine Wirkung.
* **`ImapCopyMsgFromLocalToImap`, Zweig `if (pSum->GetHash() == 0)`** (`ImapToc.cpp:1472-1475`):
  Er läuft jetzt praktisch nie. `pSum` ist die Vorab-Kopie (`K ≠ 0`) oder eine Quelle, die nur bei
  `ulId ≠ 0` gesucht wird (`ImapActionQueue.cpp:2377`). Harmlos: Der Zweig war ohnehin überflüssig,
  denn `pCopySum == pSum` bekommt `NewUid` schon an `:1465`.
* **`:1396`** (ohne UIDPLUS die Vorab-Kopie entfernen) gilt jetzt auch für `Out`. Vorher blieb dort
  eine unmarkierte Kopie mit 0 bis zum Abgleich stehen. Jetzt verhält sich `Out` wie `In` am
  Prüfstand (u100a/u100b). Die Mail fehlt bis zum nächsten Abgleich im Ordner. Das ist dieselbe
  falsche Anzeige wie bei `In`, an GMX (UIDPLUS) nicht relevant.
* **Bilderschutz `HatOffeneUebertragung`** (`ImapActionQueue.cpp:3920-3925`): Er gab bei Kennung 0
  immer `false`. Die Bilddateien einer Vorab-Kopie aus `Out` waren nach einem Neustart also nie
  geschützt ([E-121](../BEFUNDE.md#e-121) PRUEFER-29 N3, [E-123](../BEFUNDE.md#e-123)). **Mit eigener Kennung greift der
  Schutz jetzt auch hier.** Das ist eine Verbesserung, nicht beabsichtigt und nicht gemessen.

**Wird die neue Kennung gespeichert?**

* **Beim Verschieben aus `Out`: ja.** `Xfer` schreibt `Out.toc` an `tocdoc.cpp:3080`, nach
  `SetHash` (`:2940`) und vor dem Wechsel in den Papierkorb. Danach legt
  `ImapXferFromLocalToImap` die Quelle in den lokalen Papierkorb (`ImapToc.cpp:1018-1027`).
  `SubtractSum` und `AddSum` setzen das Änderungszeichen (`tocdoc.cpp:1543`, `:1480`). `Trash.toc`
  wird also mit `K` geschrieben, sobald der Papierkorb gespeichert wird, wie jedes andere Feld.
  Das Ziel schreibt `Xfer` an `:3055` mit der Kopie und `K`.
* **Beim Kopieren: erst später.** An `:3058` wird `Write()` nur bei `!Copy` aufgerufen, und
  `SetHash` setzt kein Änderungszeichen. `K` steht im Speicher und kommt mit dem nächsten Schreiben
  von `Out.toc` auf die Platte. Siehe Q4.

**`DoPostProcessing` mit `ulId ≠ 0` für Mails aus `Out`** (`ImapActionQueue.cpp:2377-2404`):

* **Verschieben:** Die Suche in `pSrcToc` (= `Out`) findet nichts, die Quelle liegt schon im
  Papierkorb. Also gilt `in-quelle=0 markiert=0`, nichts wird entfernt (`:2428`). Das ist richtig
  und dasselbe Ergebnis wie vorher mit `ulId == 0`. Folge: Die Quelle im Papierkorb behält ihr
  Merkzeichen `m_bE121Quelle`. Das ist F2, harmlos, denn `Xfer` setzt es beim nächsten Verschieben
  ohnehin neu.
* **Kopieren:** Die Suche findet die Quelle in `Out` (`nTreffer=1`, markiert). Entfernt wird sie
  wegen `m_bCopy` nicht. **Das ist neu und nützlich:** Fehlt die Vorab-Kopie, weil ein Abgleich sie
  verworfen hat, wird jetzt aus `Out` hochgeladen (`:2411-2413`). Vorher scheiterte das bei Kennung 0.
* **Fehlt beim Verschieben die Vorab-Kopie,** findet die Suche nichts: Das ist Q1.

## N2 — nachgerechnet: behoben, gemessen

`ImapToc.cpp:1488-1500`: Scheitert das Hochladen aus dem Ziel (`!bResult && this == pTargetToc`),
wird die Vorab-Kopie mit `RemoveSum` entfernt. Vorher bleibt `SetDeleteEmbedded(FALSE)` stehen, das
Fenster wird geschlossen und `*ppCopySum = NULL` gesetzt.

* **Wird `pSum` danach noch benutzt? Nein, belegt.** `RemoveSum` gibt frei (`tocdoc.cpp:1589`). In
  `ImapCopyMsgFromLocalToImap` folgt nur `return bResult`. Im Aufrufer steht `pSum` danach nur in
  `pSum != NULL` in der Spurzeile (`ImapActionQueue.cpp:2417`), einem reinen Zeigervergleich.
  `pCopySum` wird nicht gelesen. Die nächste Runde sucht in `m_Sums` neu.
* **Die Abfrage `GetSumList().Find(pSum)`** schützt gegen den Fall, dass während des modalen
  Fehlerdialogs (`:1380`) ein Abgleich die Kopie schon entfernt hat. Sie vergleicht nur Zeiger. Gut.
* **`:1396` und `:1488` treffen nie zusammen:** `:1404` entfernt nur bei `bResult`, `:1488` nur bei
  `!bResult`.
* **`APPEND` gelingt, `RewriteMbxStub` scheitert** (`:1413`, `bResult` wird `FALSE`): Die Kopie wird
  entfernt, die Mail steht auf dem Server. `bHochgeladen=0` ergibt `bSomeFailed`, die Quelle wird
  nicht entfernt (`ImapActionQueue.cpp:2428`). Was dann geschieht, hängt von der Herkunft ab:
  * Aus `In` oder einem anderen lokalen Ordner: Die Quelle bleibt. Der nächste Abgleich holt die
    Server-Fassung: Ihre UID `NewUid` ist die höchste, also kommt sie als neue Nachricht. Ergebnis:
    doppelt (lokal und auf dem Server), **kein Verlust**.
  * Aus `Out`: Die Quelle liegt im lokalen Papierkorb, die Server-Fassung kommt mit dem nächsten
    Abgleich. **Kein Verlust.**
  * Einen Fehlerdialog gibt es in diesem Fall nicht, denn `:1380` steht nur im `APPEND`-Zweig. Das
    ist wie vorher.
* **Gemessen an r101** (Server lehnt `APPEND` ab, `imap-r101-1.log`: `NO [TRYCREATE]`): Die Spur
  zeigt `Hochgeladen: ergebnis=0`, dann `Hochladen gescheitert, Vorab-Kopie entfernt:
  kennung=514638030`, dann `im-ziel=1 in-quelle=1 markiert=1 hochgeladen=0` und
  `Ziel nach dem Hochladen: summen=0`. Der Lauf endet mit `ExitInstance: erreicht`. Die Quelle blieb,
  die Kopie ist weg, kein Absturz. Der Zweig „`RewriteMbxStub` scheitert“ ist nicht gemessen.
* **Fenster und Vorschau:** `InvalidateCachedPreviewSummary` steht vor dem Entfernen (`:1494`),
  `SubtractSum` wiederholt es (`tocdoc.cpp:1552`). Die Vorschau ist sauber. Zum Fenster siehe Q3.

## Q1 — Gesendete Post: Vorab-Kopie vor dem Hochladen verworfen — Datenverlust (verzögert), alt

**Was der Anwender tut und was passiert:** Er verschiebt eine gesendete Mail in einen IMAP-Ordner,
während Eudora diesen Ordner gerade abgleicht (typisch kurz nach dem Start). Die Mail kommt nicht auf
dem Server an und liegt nur noch im lokalen Papierkorb. Leert er den Papierkorb, oder leert Eudora
ihn beim Beenden, ist sie weg.

Mechanik, am Quelltext belegt:

1. `ImapXferFromLocalToImap` legt gesendete Post (`IsComp()`, `summary.h:276-277`, oder Ordner
   `Out`) schon beim Einreihen in den lokalen Papierkorb (`ImapToc.cpp:1018-1027`). Das gilt auch für
   gesendete Post in anderen lokalen Ordnern.
2. Ein Abgleich des Zielordners, der vor `DoPostProcessing` fertig wird, verwirft die Vorab-Kopie.
   Ihre Kennung steht nicht auf dem Server (`ImapRemoveListedTocs`, `ImapToc.cpp:1787-1860`). Das ist
   der in [E-121](../BEFUNDE.md#e-121) gemessene Wettlauf mit dem Start-Abgleich.
3. `DoPostProcessing` findet keine Vorab-Kopie. Es sucht die Quelle in `pSrcToc`, also im
   **Ursprungsordner** (`ImapActionQueue.cpp:2356`, `:2377-2404`), nicht im Papierkorb. Das ergibt
   `im-ziel=0 in-quelle=0 hochgeladen=0`.

Einordnung: Das steht seit [PRUEFER-28](PRUEFER-28.md) im Bestand (Abschnitt „`Out`/zusammengesetzte
Nachrichten (Papierkorb)“). Es ist wie im Original und in jeder Fassung seither, also kein Rückfall
durch 7.2.0.101. **Neu ist nur, dass es jetzt behebbar ist:** Vorher war die Kennung 0, die Quelle im
Papierkorb also nicht wiederzufinden. Jetzt trägt sie ein eindeutiges `K` und ihr Merkzeichen.

Vorschlag, eine Stelle: In `DoPostProcessing` wird, wenn `pSum == NULL` und `pMarkiert == NULL`,
zusätzlich `GetTrashToc()` nach genau einer **markierten** Zusammenfassung mit Kennung `ulId`
durchsucht. Wird sie gefunden, wird sie hochgeladen (`ImapCopyMsgFromLocalToImap` aus dem
Papierkorb). Danach wird sie **nicht** entfernt, denn sie lag im Original auch im Papierkorb. Ein
Ordner ohne Papierkorb oder kein Treffer ändert nichts gegenüber heute.

Gegenprobe: am Prüfstand nicht möglich (keine Post mit `IsComp()`, N4). Erste Wahl wäre ein
vorübergehender Prüfschalter, der die Vorab-Kopie vor `DoPostProcessing` verwirft. So wurde Fall (2)
in [E-121](../BEFUNDE.md#e-121) am 14.10. erzwungen. Dazu eine gesendete Mail, die von Hand in einen
lokalen Ordner gelegt wird. Erwartet: `im-ziel=0 … hochgeladen=1`, die Mail auf dem Server und im
Papierkorb.

## Q2 — Hohe Kennung in einer liegengebliebenen Vorab-Kopie — falsche Anzeige, Vermutung

**Was der Anwender tut und was passiert:** Er verschiebt eine gesendete Mail in einen IMAP-Ordner,
während der Server nicht erreichbar ist (N1-Fall). Beim nächsten Abruf dieses Ordners wird neu
eingegangene Post dort nicht als neu gemeldet. Sie erscheint erst, wenn die liegengebliebene Kopie
verworfen ist.

* `GetCurrentUids` nimmt jede Zusammenfassung mit ihrer Kennung auf (`ImapMailbox.cpp:7394-7405`).
  Eine liegengebliebene Kopie mit `K ≥ 0x10000000` macht `K` zur „höchsten lokalen UID“.
* **Abruf im Vordergrund** (`GetAndFilterNewMessages`, `ImapMailbox.cpp:1968-1983`): `NextUid` wird
  `min(Server-Höchste, max(K, …))`, also die höchste Server-UID. Neues wird nicht geholt. Verworfen
  wird die Kopie dort auch nicht.
* **Abruf im Hintergrund** (`ImapChecker.cpp:820-840`, `:893-916`): Ebenso kommt nichts als neu.
  Die neuen Server-UIDs landen aber in `m_mapNewOldUIDs` und werden als „fehlende alte“ nachgeladen.
  Die Kopie wird dabei als verwaist erkannt. Ob dann die Neu-Meldung und die Filter des Posteingangs
  laufen, ist nicht nachgerechnet.
* `m_UIDHighest` wird nur aus Server-Werten gesetzt (`ImapMailbox.cpp:2310`, `:2456`, `:2641`). Die
  Wirkung bleibt also auf diesen einen Abruf beschränkt, sie ist nicht dauerhaft.

Für Mails aus `In` (POP-Kennungen wie `514638030`) galt das schon vorher. PRUEFER-32 N2 hat es
nebenbei vermutet. Für `Out` ist es neu, weil die Kennung dort vorher 0 war. Vorschlag: keiner vor
dem Release. Erledigt sich mit dem Vorschlag zu N1 aus PRUEFER-32 (Vorab-Kopien ohne Auftrag sofort
entfernen).

## Q3 — Fenster der gescheiterten Vorab-Kopie — Absturz, sehr selten, Vermutung

**Was der Anwender tut und was passiert:** Er öffnet die eben verschobene Mail im IMAP-Ordner,
ändert ihren Text, und das Hochladen scheitert. Beim anschließenden Schließen des Fensters fragt
Eudora „Änderungen speichern?“, aber die Zusammenfassung dazu ist schon freigegeben. Speichert er,
kann Eudora abstürzen.

`ImapToc.cpp:1495-1498` schickt `SC_CLOSE` per `PostMessage` und gibt die Zusammenfassung sofort
frei. `~CSummary` setzt `Doc->m_Sum = NULL` (`summary.cpp:568-574`). Das Schließen läuft erst danach,
dann ohne Zusammenfassung. Die anderen Stellen fragen vorher `CanCloseFrame`:
`ImapActionQueue.cpp:2435`, `ImapToc.cpp:1840` (Original). Diese hier nicht. Die Vorab-Kopie lebt
nur Sekunden, und ein bearbeitetes Lesefenster ist selten. Vorschlag: wie an `:2435` erst
`CanCloseFrame` fragen. Lässt sich das Fenster nicht schließen, bleibt die Kopie stehen; sie ist
unmarkiert und hat mit `K` keine Server-UID. Nicht vor dem Release nötig.

## Q4 — Kopieren aus `Out`: die Quelle behält die Kennung — keine Wirkung gefunden, belegt

**Was der Anwender tut und was passiert:** Er **kopiert** eine gesendete Mail in einen IMAP-Ordner
(oder ein Ausgangsfilter tut das). Die Mail in `Out` trägt danach dauerhaft eine eigene Kennung. Er
bemerkt davon nichts.

`tocdoc.cpp:2937` unterscheidet nicht nach `Copy`. Gespeichert wird `K` mit dem nächsten Schreiben
von `Out.toc` (siehe N1). Durchgesehen sind die Leser (siehe N1): Keiner setzt bei `Out` die
Kennung 0 voraus. Ein zweites Kopieren derselben Mail benutzt dasselbe `K`. Die zweite Vorab-Kopie
findet ihren Auftrag, weil die erste mit UIDPLUS die Server-UID bekommen hat bzw. ohne UIDPLUS
entfernt ist. Zwei Kopieraufträge kurz hintereinander nehmen je die erste markierte Kopie, und beide
haben denselben Inhalt. Nebenbei behebt es etwas: Fehlt die Vorab-Kopie, wird jetzt aus `Out`
hochgeladen (siehe N1).

## Q5 — Überholte Kommentare — kosmetisch, belegt (erweitert N3 aus PRUEFER-32)

Mit 7.2.0.101 gilt „alle Nachrichten aus `Out` haben 0“ nicht mehr, und eine gescheiterte Kopie
verwirft nicht der Abgleich:

* `ImapToc.cpp:1359-1360`: *„bleibt die Quelle stehen; die unmarkierte Kopie verwirft der naechste
  Abgleich“*. Für `Out` stimmt der erste Teil nicht (N3), der zweite gar nicht mehr (`:1488-1500`).
* `ImapToc.cpp:1390`: *„Nicht bei Kennung 0 (Out, PRUEFER-28 P1)“*. `Out` hat jetzt eine Kennung.
* `ImapToc.cpp:1421-1422` und `:1468-1471`: dasselbe.
* `ImapActionQueue.cpp:2370-2373`: *„alle Nachrichten aus Out haben 0“*.

Richtig steht es in `ImapToc.cpp:1483-1487` und `:1667-1674`.

## Q6 — E-67-Spurmarken — verändern nichts, belegt; eine Benennung kosmetisch

Gefragt war, ob die Spurmarken in `Eudora/filtersv.cpp` etwas verändern können:

* **`filt` ist nie NULL:** Die Ladezeile steht in `if (filt)` (`:1197`, Marke `:1246-1254`), die
  Speicherzeile in `if (pDX->m_bSaveAndValidate == TRUE && filt)` (`:1448`, Marke `:1501-1506`).
* **`GetCount` auf einem nicht erzeugten Feld:** Davor fragt die Marke `GetSafeHwnd()` und liefert
  sonst `-1`. `CB_GETCOUNT` liest nur. `RefreshVerbCombo` hat das Feld eine Zeile vorher schon mit
  `ResetContent` beschrieben. Die Marke macht nichts schlimmer.
* **Format:** Der Regelname geht als Argument zu `%s`, nicht als Formatzeichenkette, ein `%` im
  Namen schadet also nicht. Die Marke schreibt nur in `PutDebugLog`, sonst nirgendwohin. Die
  Speichermarke steht nach dem Setzen von `SetModifiedFlag` und vor dem Zurückschreiben. Sie liest
  nur.
* **Kosmetisch:** `verb-auswahl` ist `m_Verb0` **vor** `DDX_CBIndex` (`:1395`), also der Wert, der
  gleich ins Feld gesetzt wird, nicht die Auswahl im Feld. Der Kommentar *„nur so ist belegt, dass
  die Regel wirklich angezeigt wurde“* sagt mehr, als die Marke zeigt. Aussagekräftig ist sie
  trotzdem: `verb-auswahl=14 eintraege=2` (e67rot) heißt „Index außerhalb, Feld leer“, und
  `verb-auswahl=0 eintraege=2` (e67b) heißt „richtig“. Genauer wäre `GetCurSel()` nach dem DDX.
* **Gemessen:** e67b `verb-gespeichert=14 verb-auswahl=0 … verb-neu=14 geaendert=0`; e67rot
  `verb-auswahl=14` beim Laden, `verb-neu=14` beim Speichern. Die zweite Hälfte der Behebung
  (`:1471`) verhindert dort die 28. Beide enden mit `ExitInstance: erreicht`.

## Q7 — `TESTEN.txt` nennt die beweisende Protokollzeile nicht — Prüflücke, belegt

`Releases/1.0.101/TESTEN.txt` verlangt: zwei gesendete Mails stehen je einmal in der OUTBOX, und es
erscheint kein Fehlerdialog. Das galt aber schon an 1.0.99 mit **einer** Mail und `id=0`.
Mit GMX (UIDPLUS) geht der alte Weg bei zwei Mails ebenfalls gut: Runde 1 nimmt die erste markierte
Kopie und entfernt das Merkzeichen, Runde 2 die nächste. Nur das Protokoll unterscheidet die
Fassungen: zwei verschiedene `id` ≥ `268435456` statt zweimal `id=0`. Vorschlag: in die Spalte
„richtig ist“ aufnehmen: „in `eudora.log` zwei Zeilen `E-121 Uebertragung` mit verschiedener großer
`id` und `hochgeladen=1`“.

## Unverändert offen

7.2.0.101 ändert weder `QCTaskManager.cpp` noch `TaskStatusWazooWnd.cpp`, `tools/paket-pruefen.ps1`
oder `tools/imap-pruefserver.pl`.

* **F2** (`m_bE121Quelle` bleibt hängen): offen. Für gesendete Post wird es harmloser: Gleiches `K`
  haben nur Kopien derselben Mail. Damit entfällt Kette (b) aus PRUEFER-31 für Mails, die vorher
  Kennung 0 hatten. Für Mails aus `In` mit gemeinsamer Kennung gilt sie weiter.
* **F5:** unverändert. `ohne-Anzeige` und `Anzeige-nachgetragen` stehen in allen vier Läufen 0-mal,
  `beim-Umhaengen-schon-fertig-entfernt` je einmal.
* **F6:** unverändert. `aktiv=-1/10` steht in jedem der vier Läufe 7-mal.
* **F7:** unverändert, `ProgramW6432` und `ExclusionPath` stehen nicht in `tools/paket-pruefen.ps1`.
* **N3:** offen, erweitert zu Q5.
* **N4:** unverändert (`imap-pruefserver.pl:389`, `NOOP` ohne `EXISTS`). Dazu: In keinem der vier
  Läufe steht `E-121 Ziel nach dem Abgleich`. Der Abgleich am Ende von `DoPostProcessing` ist an
  7.2.0.101 nicht gemessen.

## Bestätigt an den Läufen von 7.2.0.101

* Alle vier E-121-Läufe und beide E-67-Läufe melden `Version 7.2.0.101` und enden mit
  `ExitInstance: erreicht`.
* **n101:** `[APPENDUID 1 1]`, `neue-uid=1`, `hochgeladen=1`, `summen=1`.
* **r101:** siehe N2.
* **x101a, x101b** (fremde UID `514638030`): `neue-uid=514638031`, `summen=2`, `hochgeladen=1`.
* **Nicht gemessen:** jeder Lauf mit einer Quelle aus `Out` bzw. mit Kennung 0, also der ganze Weg
  `E121NeueKennung`. In allen vier Läufen ist `id=514638030`.
