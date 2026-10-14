# PRÜFER-29 — Nachprüfung PRUEFER-28 P1–P4 (`a10adbda`, `6bbb8fa3`, 7.2.0.90)

Gegenstand: die Behebungen der Funde aus [PRUEFER-28](PRUEFER-28.md) in
`a10adbda` (P1, P2, P4, E1) und `6bbb8fa3` (P3). Gelesen am Quelltext, nichts gebaut,
nichts am Prüfserver gefahren. Zeilen beziehen sich auf den Stand nach `6bbb8fa3`.

## Urteil

**Die Datenverlust-Klasse aus PRUEFER-28 ist geschlossen; 7.2.0.90 ist in dieser Hinsicht
auslieferbar.** P1, P2 und P4 sind behoben wie vorgeschlagen. P3 ist nur **teilweise**
behoben: der Schutz greift im Zeitfenster bis zum Start der Aufgabe, nicht mehr beim Abgleich
am Ende von `DoPostProcessing` (N2). Verloren gehen dort höchstens **Bilddateien einer
Nachricht, die in der Quelle stehen bleibt**, keine Nachricht. Zwei Restfälle (N1, N3) sind
Gegenvermutungen, nicht gemessen, und setzen seltene Lagen voraus.

## P1 — behoben

`EuImap/src/ImapActionQueue.cpp:2362-2379`: die Quelle wird nur gesetzt, wenn
`ulId != 0` und genau eine Zusammenfassung in `pSrcToc` diesen Hash trägt
(`nTreffer != 1` → `NULL`, `:2377-2378`). Damit fallen die Fälle A–C aus PRUEFER-28 weg:
`Out` und gesendete Post (Hash 0) werden nie mehr als Quelle benutzt; mehrdeutige Hashes ebenso.
Entfernt wird nur unter `pQuelle != NULL` (`:2400`). Ohne Quelle und ohne Vorab-Kopie bleibt
`bHochgeladen` falsch → `bSomeFailed` (`:2395-2398`), die Nachricht bleibt in der Quelle
(bzw. für `Out` im lokalen Papierkorb, `ImapToc.cpp:1018-1028`).

### N1 — Eindeutigkeit wird zur falschen Zeit gezählt (Gegenvermutung, nicht gemessen; selten)

Gezählt wird beim Nachholen, nicht beim Einreihen. Steht im Quellordner beim Einreihen die
verschobene Nachricht M **und** eine andere X mit demselben Hash ≠ 0, und entfernt der Nutzer M
vor dem Nachholen von Hand aus der Quelle, ist X beim Nachholen der einzige Treffer und wird nach
dem Hochladen der Vorab-Kopie von M entfernt (`:2371-2378`, `:2416`). Gleiches gilt für eine
zusammengesetzte Nachricht (`IsComp`) mit Hash ≠ 0, die schon im Papierkorb liegt
(`ImapToc.cpp:1018`): ein einzelner Namensvetter im Ordner würde entfernt.
Voraussetzung: doppelte Hashes ≠ 0 in einem lokalen Ordner — möglich bei Post aus mehreren
IMAP-Ordnern (kleine UIDs, PRUEFER-28 P1 „Gegenvermutung“). Die saubere Lösung bleibt die in
PRUEFER-28 genannte: Quelle über `m_UniqueMessageId` wiederfinden (Formatänderung
`actionqueue.dat`). **Kein Hindernis für 7.2.0.90**, aber bei [E-121](../BEFUNDE.md#e-121) als Rest vermerken.

## P2 — behoben

`ImapActionQueue.cpp:2405-2413`: offenes Fenster → `CanCloseFrame`; lässt es sich nicht
schließen, `continue`, sonst `PostMessage(SC_CLOSE)` und danach `RemoveSum` — dasselbe Muster
wie das Original `ImapToc.cpp:1693-1703` (dort ebenfalls `PostMessage` vor dem Entfernen).

**`continue` im `do … while`:** springt in C++ an das Ende des Schleifenrumpfs, also zur
Auswertung von `while (!strUIDList.IsEmpty())` (`:2419`) — nicht an den Anfang des Rumpfs.
**Keine Endlosschleife:** `strUIDList` wird in jeder Runde vor dem `continue` verkürzt, und zwar
in `GetSummaryFromUIDStringFromDestination` (`:2357` → `:1625-1634`, Kopf bis zum Komma bzw.
ganz). Der einzige Weg ohne Verkürzung ist `m_pDestTocDoc == NULL` (`:1616-1619`); den schließt
`DoPreThreadAction` aus (`:2283-2287`, `kActionStateFailed` → Aufgabe wird verworfen,
`:3667-3672`), und `:2384` würde ihn ohnehin dereferenzieren. Folge des `continue`: Nachricht
hochgeladen, Quelle bleibt — doppelt statt Absturz, wie vorgeschlagen.
Am Rande, wie im Original (`ImapToc.cpp:1042`, `:1696`): `GetActiveDocument()` wird nicht auf
`NULL` geprüft, und `CanCloseFrame` kann bei geänderter Nachricht eine Rückfrage zeigen — hier
mitten im Nachholen. Nicht neu in der Art, nur am neuen Ort.

## P4 — behoben

Die beiden Spurmarken mit `atoi(m_szMessageIDs)` sind entfernt; `grep "atoi(m_szMessageIDs"`
über `EuImap/src/*.cpp` findet nichts mehr. `DoPreThreadAction` ruft wieder direkt
`OpenMailbox` (`ImapActionQueue.cpp:2289`). `GetSummaryFromUIDStringFromDestination` ruft
`atoi(strUID)` auf einem `CString` (`:1637`) — kein `NULL`.

## P3 — teilweise behoben

### Geprüft und in Ordnung

* **Header** `EuImap/public/inc/ImapAccount.h:239-242`: der Einschub steht in einem
  `private:`-Abschnitt (`:227`), öffnet `public:` und stellt `private:` vor
  `UserJustCancelledLogin` wieder her (`:242-243`). Alles nach dem Einschub bleibt privat. Richtig.
* **RTTI**: `EuImap/EuImap.vcxproj:67` und `:90` setzen `RuntimeTypeInfo=true` für beide
  Konfigurationen (Debug `:57`, Release `:81`). `CImapAction` ist polymorph
  (`ImapActionQueue.h:73`, virtuelles `DoPostProcessing`); `m_array` ist ein `CPtrArray`
  (`:570`), das nur `CImapAction*` aufnimmt (`ImapActionQueue.cpp:3747`, `:3751`, `:3784`,
  `:3801`). Der Umweg `(CImapAction*)` → `dynamic_cast` ist korrekt (`:3887`).
* **Zerlegung der Kennungen** (`:3889-3911`): bricht bei leerem/kaputtem Rest ab
  (`pEnde == p`), überspringt Komma und Leerzeichen; `NULL`-Kennungen abgefangen (`:3888`).
  Hash 0 wird nie geschützt (`:3879-3882`).
* **Anhänge** („Attachment Converted:“) sind nicht betroffen: `ImapRemoveAttachments` löscht
  nur Pfade unter dem Anhangsverzeichnis des IMAP-Kontos (`ImapToc.cpp:4261`,
  `StripAttachmentName` verwirft andere Pfade, `Eudora/tocdoc.cpp:4360-4365`). Die Anhänge der
  lokalen Quelle liegen in `Attach` und werden nicht angefasst.

### Frage: steht die laufende Aktion während `DoPostProcessing` noch in `m_array`?

**Nein.** `CActionQueue` nimmt die Aufgabe aus `m_array`, sobald sie an den Arbeitsfaden
übergeben ist (`ImapActionQueue.cpp:3652-3656`); `DoPostProcessing` läuft danach
(`:553-558`). Während `DoPreThreadAction` steht sie noch drin (`:3645` vor `:3654`) — dort liegt
der Abgleich beim Öffnen des Zielordners (`:2289`), und der ist jetzt geschützt, auch nach einem
Neustart. Das deckt den gemessenen Wettlauf aus [E-121](../BEFUNDE.md#e-121).

### N2 — Abgleich am Ende von `DoPostProcessing` ist nach einem Neustart ungeschützt (Bildverlust in der Quelle, Gegenvermutung, nicht gemessen)

`DoPostProcessing` lädt hoch (`:2384`) und ruft am Ende `DoManualResync` (`:2440-2443`). In
diesem Moment steht die Aufgabe nicht mehr in `m_array`, `HatOffeneUebertragung` liefert
`false`. Nach einem Neustart trägt die Vorab-Kopie wieder `m_DeleteEmbedded = TRUE`
(PRUEFER-28 P3). Verwirft der Abgleich die Kopie (ohne UIDPLUS behält sie den Quell-Hash, der
keine Server-UID ist), löscht `ImapRemoveAttachments` die geteilten Bilddateien
(`ImapToc.cpp:4325-4330`).

* Quelle entfernt (Verschieben, eindeutiger Hash): **unschädlich** — die Bilder sind schon auf
  dem Server, die Quelle ist weg.
* Quelle bleibt (Kopieren `m_bCopy`, Hash nicht eindeutig nach P1, Fenster nicht schließbar nach
  P2): **die Nachricht in der Quelle verliert ihre Bilder.** Die Nachricht selbst bleibt, und auf
  dem Server ist sie vollständig.

Ohne Neustart schützt weiterhin `SetDeleteEmbedded(FALSE)` (`Eudora/tocdoc.cpp:2930-2931`).
**Abhilfe (klein):** in `DoPostProcessing` vor `DoManualResync` die Vorab-Kopie `pSum` mit
`SetDeleteEmbedded(FALSE)` markieren, solange die Quelle stehen bleibt — oder die Aufgabe erst
nach `DoPostProcessing` aus der Zählung nehmen. Testfall: Kopieren (nicht Verschieben) einer
lokalen HTML-Nachricht mit Bild in einen IMAP-Ordner offline, Eudora beenden, neu starten, online;
danach die Quelle öffnen — Bild vorhanden?

### N3 — Hash 0 ist nach einem Neustart nie geschützt (Gegenvermutung, nicht gemessen)

`HatOffeneUebertragung(0)` liefert immer `false` (`:3879-3882`), richtig gegen Fehlschutz,
aber: gesendete Post (Hash 0, PRUEFER-28 P1) mit eingebetteten Bildern, offline in einen
IMAP-Ordner übertragen, Neustart, Abgleich beim Öffnen (`:2289`) verwirft die Vorab-Kopie →
Bilddateien gelöscht. Die Quelle bleibt seit P1 stehen (Hash 0 → keine Quelle), Hochladen
scheitert (`bSomeFailed`) — **Nachricht bleibt, Bilder weg**. Ob gesendete Post ihre Bilder im
Verzeichnis `Embedded` mit `Embedded Content:` führt, habe ich nicht gemessen.

### Frage: kann der Schutz Dateien dauerhaft festhalten (Leck)?

Nur begrenzt. Der Schutz dauert, solange eine passende Aufgabe in `m_array` steht; gescheiterte
Aufgaben werden entfernt (`:3667-3672`), erfolgreiche bei der Übergabe (`:3654`). Wird in dieser
Zeit eine **andere** Nachricht des Kontos entfernt, deren Hash zufällig gleich ist, bleiben ihre
Bilddateien liegen und werden nie mehr gelöscht — **verwaiste Dateien, kein Verlust.**

### Frage: Kollision lokale Kennung ↔ echte IMAP-UID

Geprüft wird kontoweit, nicht je Ordner (`ImapToc.cpp:4320-4323` → `ImapAccount.cpp:582-585`
→ alle Aufgaben `:3885-3913`). Lokale Hashes aus `PersonaHash` sind groß, Server-UIDs klein;
lokale Post aus IMAP-Ordnern trägt aber deren kleine UIDs als Hash (PRUEFER-28 P1). Eine echte
Servernachricht mit gleicher UID, die während einer ausstehenden Übertragung verworfen wird,
behält ihre Bilddateien. **Folge nur Leck** (siehe oben); gelöscht wird dadurch nichts, und der
Schutz wirkt nur auf eingebettete Objekte, nicht auf Anhänge oder die Zusammenfassung selbst.

### Nebenläufigkeit (nicht vollständig geprüft)

`HatOffeneUebertragung` liest `m_array` ohne Sperre. Verändert wird `m_array` in
`ProcessQueue`/`Add`/`FinishUp` (`:3654`, `:3669`, `:3720`, `:3747-3801`); der Queue-Schreiber
läuft im Arbeitsfaden (`ImapAccount.cpp:666`). Ob `ImapRemoveAttachments` je aus einem
Arbeitsfaden gerufen wird, habe ich nicht verfolgt; die Aufrufer `ImapToc.cpp:1720`, `:1943`,
`:2077`, `:3555`, `:3902` sind Abgleich- und Löschwege des Hauptfadens.

## E1 — behoben

`EuImap/src/ImapAppend.cpp:909-916`: der Zweig `Content-Location` ist entfernt, der Kommentar
nennt den Grund und die Folge (Bild als Teil ohne Kopf, nicht verloren).

## Zusammenfassung

| Fund | Stand | Schwere |
|---|---|---|
| P1 | behoben (`ImapActionQueue.cpp:2362-2379`) | — |
| N1 | Rest: Eindeutigkeit beim Nachholen gezählt, nicht beim Einreihen | Datenverlust, sehr selten, Nutzerhandlung nötig |
| P2 | behoben; `continue` korrekt, keine Endlosschleife (`:2357`, `:1625-1634`, `:2419`) | — |
| P4 | behoben | — |
| P3 | Fenster bis zum Start der Aufgabe geschützt, auch nach Neustart | — |
| N2 | Rest: Abgleich am Ende von `DoPostProcessing` nach Neustart ungeschützt | Bildverlust in stehenbleibender Quelle |
| N3 | Rest: Hash 0 nach Neustart nie geschützt | Bildverlust, Nachricht bleibt |
| E1 | behoben | — |

Auslieferbar im Sinne der Datenverlust-Klasse: **ja** — keine Nachricht geht auf einem
gewöhnlichen Weg verloren; N1 braucht doppelte Hashes plus eine Handlung des Nutzers.
N2/N3 betreffen Bilddateien nach einem Neustart mit ausstehender Übertragung und sollten bei
[E-121](../BEFUNDE.md#e-121) offen stehen bleiben.
