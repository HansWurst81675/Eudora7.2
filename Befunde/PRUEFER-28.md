# PRÜFER-28 — E-118 Teil 2 und E-121 nachgerechnet (`d7439ee6`, 7.2.0.90)

Lauf am 14.10.2026. Quellcode unter `Eudora71/` nicht geändert, kein Eudora gestartet.
Stand: Zweig `wt/pruefer`, gemergt mit `origin/e-118_HTML_header` (`d7439ee6`).
Zeilennummern beziehen sich auf diesen Stand.

**Selbst gemessen:** (a) `atoi` der Laufzeitbibliothek v143 mit Werten ab 2^31 und mit `NULL`
(eigenes Prüfprogramm im Scratchpad, `cl /MT`): `atoi("2147483648")` = 2147483647,
`atoi(NULL)` bricht den Prozess mit `0xC0000409` ab. (b) Spurmarken der Messläufe in
`C:\Temp\E118` gelesen (`E-118 Ziel …`, `E-121 Uebertragung …`): alle Kennungen dort liegen unter 2^31.
**Nicht selbst gemessen:** Suite 209/209, die drei Prüfserverläufe aus [E-121](../Intern/BEFUNDE.md#e-121) —
übernommen aus Commit-Nachricht und Befund.
`perl tools/befund-suchen.pl ImapActionQueue.cpp` / `GetSummaryFromUID` / `SetDeleteEmbedded`:
alles gehört zu [E-121](../Intern/BEFUNDE.md#e-121); kein neuer Befund nötig, dort fortschreiben.

**Urteil: auslieferbar, nein.** [E-121](../Intern/BEFUNDE.md#e-121) schließt den gemessenen Wettlauf, öffnet aber einen
neuen Verlustweg: die Quelle wird jetzt **über ihren Hash** wiedergefunden und entfernt
(`EuImap/src/ImapActionQueue.cpp:2369`, `:2390-2395`). Der Hash ist lokal **nicht eindeutig** —
alle Nachrichten aus `Out` haben den Hash 0 (`ImapToc.cpp:1391-1394`, Originalkommentar). Wer eine
Nachricht aus `Out` oder aus einem Ordner mit früher gesendeter Post nach IMAP verschiebt, verliert
eine **andere** Nachricht (P1). Die Abhilfe ist klein (unten), danach ja.
PRÜFER-27 F1 und F5 sind richtig behoben.

---

## 1. PRÜFER-27 F1 und F5 — behoben

| Fund | Stelle | nachgerechnet | Ergebnis |
|---|---|---|---|
| F1 Text hinter `</x-html>` | `ImapAppend.cpp:714-724` | `</x-html>` zählt nur als Ende, wenn ab `k + 9` bis `e` nur Leerraum steht; sonst bleibt `e = nLaenge` | **behoben.** Fußzeile/Anhangszeile gehen mit hoch (im HTML-Teil, `</x-html>` als unbekannte Endmarke sichtbar im Quelltext, im Leser unsichtbar). Kein Verlust. Mehrteilig endet jeder Abschnitt `[p, t)` vor der Anhangs-/Bildzeile, dort greift das Abstreifen weiter. Test `Tests/TestE118.cpp:96` |
| F5 Grenze je Textteil | `ImapAppend.cpp:1480-1489`, `:1616-1622` | `NewMimeBoundary` nur noch beim Übergang nach mehrteilig, in `AddTextBodyPart` wie in `ReformatAttachment` | **behoben.** Kopf (`:973`) und Abschluss (`:1414`) nehmen dieselbe Grenze wie alle Teile |

## 2. E-121 — die Behebung

### P1 — Quelle wird über einen nicht eindeutigen Hash gesucht: falsche Nachricht entfernt (DATENVERLUST, neu in 7.2.0.90)

**Kette, am Quelltext:**

1. `ImapXferFromLocalToImap` schreibt in die Aufgabe nur `pSum->m_Hash` je Nachricht
   (`EuImap/src/ImapToc.cpp:998-1006`), dazu den Pfad der Quelle (`:1058`).
2. `DoPostProcessing` sucht die Quelle mit `pSrcToc->GetSummaryFromUID(strtoul(strId))`
   (`ImapActionQueue.cpp:2369`). `GetSummaryFromUID` liefert die **erste** Zusammenfassung mit
   diesem Hash (`ImapToc.cpp:1578-1589`).
3. Nach erfolgreichem Hochladen wird **diese** entfernt: `RemoveSum(pQuelle)` und `Write()`
   (`ImapActionQueue.cpp:2390-2401`). Eine Prüfung auf Hash 0 oder auf Eindeutigkeit gibt es nicht.

**Wo der Hash nicht eindeutig ist:**

* **`Out`:** `CSummary` beginnt mit `m_Hash = 0` (`Eudora/summary.cpp:526`); gesetzt wird er nur
  beim POP-Abruf (`Eudora/pop.cpp:376`, `:394`), aus `X-UID:` (`summary.cpp:2295`) und von IMAP.
  Selbst verfasste Post behält 0 — das sagt auch der Originalkommentar
  `ImapToc.cpp:1391-1394` („Messages in the local Out mailbox have a hash of 0“).
* **Ordner mit gesendeter Post** (aus `Out` lokal weiterverschoben): `CSummary::Copy` übernimmt den
  Hash (`summary.cpp:604`) — alle 0.
* **Gegenvermutung, nicht gemessen:** lokal abgelegte Post aus verschiedenen IMAP-Ordnern trägt deren
  UID als Hash (`summary.cpp:604`, `ImapToc.cpp:1527`); kleine Zahlen, über Ordner hinweg gleich.

**Fall A — aus `Out` nach IMAP verschieben (Hand oder Ausgangsfilter):** die verschobene Nachricht
geht sofort in den lokalen Papierkorb (`ImapToc.cpp:1018-1028`). In `DoPostProcessing` findet
`GetToc(Out)` + `GetSummaryFromUID(0)` die **älteste andere Nachricht in `Out`** — z. B. eine noch
**nicht versandte**. Das Hochladen der Vorab-Kopie gelingt, `pQuelle` ist nicht `NULL`, also
`RemoveSum` auf die fremde Nachricht. Sie ist weder auf dem Server noch lokal (der Rumpf bleibt nur
bis zum Komprimieren in `Out.mbx`). Gregors „OUTBOX“-Fall aus [E-118](../Intern/BEFUNDE.md#e-118) (weitergeleitete Mails aus `Out` in
einen IMAP-Ordner) ist genau dieser Weg.

**Fall B — aus einem lokalen Ordner mit gesendeter Post:** die verschobene Nachricht M bleibt in der
Quelle (jetzt gewollt), entfernt wird die erste Nachricht mit Hash 0 — eine andere, X. M steht danach
doppelt (lokal und auf dem Server), X ist weg.

**Fall C — mehrere Nachrichten mit Hash 0 in einer Aufgabe (`0,0,0`):** jede Runde entfernt die
jeweils erste Hash-0-Nachricht der Quelle. Ohne UIDPLUS am Server bekommt die Vorab-Kopie im Ziel
keinen neuen Hash (`ImapToc.cpp:1374`, `:1395-1398`), jede Runde lädt **dieselbe** Kopie hoch
(Originalfehler, vom Kommentar `:1391` benannt); die übrigen kommen nie an.

**Fehlt die Vorab-Kopie** (der gemessene Wettlauf) und ist der Hash mehrdeutig, lädt der neue
Quellweg (`ImapActionQueue.cpp:2376-2379`) eine fremde Nachricht hoch und entfernt sie — kein
Verlust, aber eine Nachricht wandert, die niemand verschoben hat.

**Warum die Messung das nicht traf:** alle drei Läufe nahmen eine POP-Nachricht
(`id=514638030`, `C:\Temp\E118`), deren Hash aus `PersonaHash` stammt (`Eudora/MsgRecord.cpp:40-45`)
und im Posteingang eindeutig ist.

**Abhilfe (Vorschlag, klein):** in `DoPostProcessing` die Quelle nur dann benutzen (hochladen **und**
entfernen), wenn `strtoul(strId) != 0` **und** genau eine Zusammenfassung in `pSrcToc` diesen Hash
trägt; sonst die Quelle stehen lassen (Ergebnis: doppelt statt verloren). Für `Out`/zusammengesetzte
Nachrichten ist die Quelle ohnehin schon im Papierkorb, `pSrcToc` darf dort gar nicht gesucht werden
(`m_szMailbox` ist `Out.mbx`). Saubere Lösung später: die Quelle über `m_UniqueMessageId` statt über
den Hash wiederfinden (`tocdoc.cpp:1438`) — das ändert `actionqueue.dat`, also alle Leser messen.

**Testfälle (beschrieben, nicht gebaut):**

* T1: `Out` mit zwei gesendeten Nachrichten A (älter) und B; B in einen IMAP-Ordner verschieben.
  Soll: B auf dem Server, B im Papierkorb, A in `Out`. Mit 7.2.0.90 erwartet:
  `E-121 Uebertragung: id=0 im-ziel=1 in-quelle=1 hochgeladen=1` — `in-quelle=1`, obwohl B schon im
  Papierkorb liegt — und A fehlt in `Out`.
* T2: lokaler Ordner mit drei aus `Out` übertragenen Nachrichten; die jüngste nach IMAP verschieben.
  Soll: die jüngste weg, zwei bleiben. Erwartet: die älteste fehlt, die jüngste bleibt.
* T3: Gegenrichtung zur Abhilfe: POP-Nachricht mit eindeutigem Hash — Quelle wird nach dem
  Hochladen entfernt (der gemessene Fall 1 aus [E-121](../Intern/BEFUNDE.md#e-121) muss grün bleiben).

### P2 — offenes Fenster der Quelle beim Entfernen (Gegenvermutung, nicht gemessen)

Der alte Code schloss das Nachrichtenfenster **beim Einreihen** und übersprang Nachrichten, deren
Fenster sich nicht schließen ließ (`ImapToc.cpp:993`, `:1039-1046`). Danach war die Quelle weg.
Jetzt bleibt sie sichtbar, bis die Aufgabe läuft — offline beliebig lange —, und der Nutzer kann sie
wieder öffnen. `DoPostProcessing` ruft `RemoveSum` ohne Blick auf `pQuelle->m_FrameWnd`
(`ImapActionQueue.cpp:2390-2394`). `RemoveSum` schließt keine Fenster: `NukeMessageDocIfUnused` lässt
ein angezeigtes Dokument stehen (`Eudora/summary.cpp:776-790`), der Destruktor setzt nur
`Doc->m_Sum = NULL` (`summary.cpp:566-572`). Ein offenes Fenster mit `m_Sum == NULL` ist die Lage aus
[E-28](../Intern/BEFUNDE.md#e-28). Abhilfe: Fenster offen → Quelle nicht entfernen (doppelt statt Absturz) oder wie
`:1039-1046` schließen. Die Vorschau ist versorgt (`tocdoc.cpp:1545-1553`).

### P3 — `SetDeleteEmbedded(FALSE)` überlebt keinen Neustart (Bildverlust, Gegenvermutung zum Weg)

`Xfer` schützt die Bilddateien der Vorab-Kopie mit `CopySum->SetDeleteEmbedded(FALSE)`
(`Eudora/tocdoc.cpp:2930-2931`). Der Merker steht nur im Speicher: Anfangswert `TRUE`
(`summary.cpp:537`), `m_DeleteEmbedded` wird weder gelesen noch geschrieben (`summary.cpp:2463ff.`,
`:2542ff.` lesen/schreiben `m_Hash` usw., der Merker kommt in keiner anderen Zeile vor). Nach einem
Neustart trägt die Vorab-Kopie aus der `.toc` wieder `TRUE`. Genau dann läuft der in
[E-121](../Intern/BEFUNDE.md#e-121) beschriebene Fall: liegengebliebene Übertragung, nachgeholt aus `actionqueue.dat`, Abgleich
vom Start. Verwirft der Abgleich die Kopie vorher, löscht `ImapRemoveAttachments` die geteilten
Bilddateien (`ImapToc.cpp:4316-4324` → `DeleteEmbeddedObjects`, ohne Verzeichnisprüfung), und der
Quellweg lädt ohne Bild hoch (`E-118 Bild: vorhanden=0`) — die Quelle wird danach entfernt; die Bilder
sind dann nirgends mehr. Die Nachricht selbst geht nicht verloren.
**Testfall:** Übertragung offline einreihen, Eudora beenden, neu starten, online gehen;
Spur `E-118 Bild: … vorhanden=` lesen. Abhilfe: in `ImapRemoveAttachments` eingebettete Dateien nur
löschen, wenn keine andere geladene Zusammenfassung sie nennt, oder den Merker in den
`m_FlagsEx`-Bits ablegen (Formatfrage).

### P4 — Spurmarke `E-118 Ziel …` mit `atoi(NULL)` (Absturz, selten)

`ImapActionQueue.cpp:2291` und `:2297` rufen `atoi(m_szMessageIDs)`. `Write` schreibt die Kennungen nur,
wenn sie nicht leer sind (`ImapActionQueue.cpp:688-691` im Bereich `CImapAction::Write`), der
Standardkonstruktor setzt `NULL` (`:602`). Eine Aufgabe ohne Kennungen — entsteht, wenn in
`ImapXferFromLocalToImap` jede Nachricht übersprungen wird (`ImapToc.cpp:988-993`, Esc oder Fenster
nicht schließbar), wird trotzdem eingereiht (`:1058-1069`) — kommt nach einem Neustart mit `NULL`
zurück. Gemessen: `atoi(NULL)` beendet den Prozess (`0xC0000409`; Eudora leitet das über
`QCInvalidParameterHandler` in einen Absturzbericht, `Eudora/ExceptionHandler.cpp:112`).
Vorher lief hier nur `CString(NULL)` — harmlos. Abhilfe: die beiden Spurmarken ausbauen (die
Diagnose ist abgeschlossen) oder `m_szMessageIDs ? strtoul(…) : 0`.

### Geprüft und unbedenklich (bzw. besser als vorher)

* **Doppelt aus Ziel und Quelle in einer Runde:** nein — `else if` (`ImapActionQueue.cpp:2372-2379`),
  je Kennung höchstens ein `APPEND`.
* **Doppelt über mehrere Aufgaben:** möglich, wenn der Nutzer die (jetzt sichtbar gebliebene) Quelle
  vor dem Hochladen ein zweites Mal nach IMAP verschiebt, oder beim Nachholen aus `actionqueue.dat`
  nach einem Abbruch mitten in `DoPostProcessing`. Ergebnis jeweils doppelt auf dem Server, kein
  Verlust. Nebenbefund (b) aus [E-121](../Intern/BEFUNDE.md#e-121) bleibt.
* **Die Aufgabe verlässt die Warteschlange schon bei der Übergabe an den Faden**
  (`ImapActionQueue.cpp:3629-3633`), und `FinishUp` beim Beenden ruft nur `DoPreThreadAction`
  (`:3690-3701`, aus `Eudora/mainfrm.cpp:5381`) — eine dort hängende Übertragung lädt nie hoch.
  Vorher war die Quelle dann schon weg; jetzt bleibt sie. **Echte Verbesserung durch [E-121](../Intern/BEFUNDE.md#e-121).**
* **Dauerhaftes Scheitern:** die Quelle bleibt liegen, die Aufgabe ist aus der Schlange
  (keine Wiederholung). Sichtbar: `IDS_ERR_IMAP_APPEND_FAILED` (`ImapToc.cpp:1365-1370`), außer bei
  Abbruch durch den Nutzer oder lokalem Fehler (z. B. Anhang nicht lesbar) — dann still, die Nachricht
  steht einfach noch in der Quelle. Kein Verlust; Meldung wäre schön, kein Sperrgrund.
* **Offline:** die Quelle bleibt bis zum Hochladen sichtbar (vorher sofort weg). Löscht der Nutzer sie
  in der Zwischenzeit (lokal in den Papierkorb, Hash bleibt), lädt die Vorab-Kopie trotzdem hoch,
  `pQuelle` ist `NULL` (`GetToc` sucht im alten Ordner), der Papierkorb behält seine Kopie. Löscht er
  die Vorab-Kopie im IMAP-Ordner, lädt der Quellweg trotzdem hoch — die Nachricht „kommt zurück“.
  Beides kein Verlust. Verschiebt er die Quelle nach lokal weiter: dort bleibt sie, oben doppelt.
* **`GetToc(m_szMailbox)`:** `m_szMailbox` ist `m_MBFileName` (`ImapToc.cpp:1058`),
  `GetToc` vergleicht `GetMBFileName()` ohne Groß/Klein (`tocdoc.cpp:3592`) — richtig. Ist der Ordner
  inzwischen umbenannt/gelöscht, zeigt `GetToc` mitten im Hochladen `IDS_ERR_MAILBOX_EXIST`
  (`tocdoc.cpp:3605-3611`, `bDisplayErrors` steht auf Vorgabe `TRUE`). Schönheitsfehler;
  `GetToc(m_szMailbox, NULL, FALSE, FALSE, FALSE)` wäre still.
* **`Out`/zusammengesetzte Nachrichten (Papierkorb):** abgesehen von P1 unverändert: fehlt die
  Vorab-Kopie, liegt die Nachricht nur im lokalen Papierkorb; wird der geleert, ist sie weg. Die
  Commit-Aussage „nie verloren“ gilt für diesen Weg nicht.
* **Anhänge (`Attachment Converted:`):** das Verwerfen der Vorab-Kopie löscht die Anhangsdateien der
  Quelle **nicht**. `ImapRemoveAttachments` nimmt als Verzeichnis den `Attach`-Ordner **des IMAP-Kontos**
  (`ImapToc.cpp:4256-4265`, `EuImap/src/ImapMailbox.cpp:6489-6499`), und `StripAttachmentName` liefert
  für jeden Pfad außerhalb davon den leeren Namen (`tocdoc.cpp:4359-4365`); `FileRemoveMT` läuft dann
  nur auf `""` (`ImapToc.cpp:4298-4303`). Lokale Anhänge liegen im allgemeinen Anhangsordner.
* **`atoi` in `GetSummaryFromUIDStringFromDestination` (`ImapActionQueue.cpp:1636`) — widerlegt als
  Ursache:** `atoi` kappt ab 2^31 (gemessen), aber `HashMT` bleibt unter 2^31
  (`QCUtils/src/services.cpp:82-104`, Rest modulo 2147483629, plus 1), und IMAP-UIDs sind klein.
  Restfall: `pop.cpp:394` (`strtoul(BaseName, 16)`), nicht weiter verfolgt.
* **Endlosschleife?** `while (!strUIDList.IsEmpty())` (`ImapActionQueue.cpp:2396`) verlässt sich darauf,
  dass `GetSummaryFromUIDStringFromDestination` die Liste kürzt; bei `m_pDestTocDoc == NULL` kehrt sie
  vorher zurück (`:1615-1618`) und die Schleife liefe ewig im Hauptfaden. `DoPreThreadAction` und
  `DoWork` schließen `NULL` aus (`:2282-2286`, `:2330-2334`) — heute unerreichbar, aber zerbrechlich;
  die Kennung besser in der Schleife selbst abschneiden.
* **Filter:** `filtersd.cpp:1529-1571` hängt das Nachrichtendokument auf die Vorab-Kopie um und arbeitet
  mit ihr weiter — wie vorher. Die Quelle bleibt bis zum Hochladen im Posteingang; ein erneutes
  „Filtern“ von Hand in dieser Zeit erzeugt eine zweite Aufgabe (doppelt).

## 3. E-118 Teil 2 — eingebettete Bilder

| Stelle | nachgerechnet | Ergebnis |
|---|---|---|
| `E118Verweis` Puffer (`ImapAppend.cpp:805-814`) | Kopie nur bei `e - a < nAus` **und** `< sizeof(szKandidat)` (1024); `strcpy` nach `szAus` mit höchstens `min(nAus, 1024) - 1` Zeichen | sicher. Aufrufer gibt `sizeof(szVerweis)` = 1024 (`:910`, `:913`) |
| Leseschritte in `E118Verweis` | `i + 4/5/11 <= nLaenge` vor jedem Vergleich, `pHtml[i - 1]` nur bei `i > 0`, alle Schleifen bis `nLaenge` | sicher |
| `ReverseFind(':')` (`:898`) | Eudora schreibt nur den **Dateinamen** (`mime.cpp:2157-2161`, `:2195`), Windows-Namen haben keinen Doppelpunkt; auch ein voller Pfad `C:\…` geht, weil der letzte Doppelpunkt vor den Hashes steht | richtig |
| Pfad (`:905-907`) | dieselbe Regel wie `URIMap::ResolvePathToFullPath` (`Eudora/Convhtml.cpp:633-649`) | richtig |
| CID-Hash | `Init` streift `<…>` ab und hasht (`mime.cpp:2101-2108`); Eudoras Anzeige hasht den Teil hinter `cid:` (`Convhtml.cpp:658-662`, `strnicmp`) — `E118Verweis` genauso, `E118Gleich` vergleicht ohne Groß/Klein (`ImapAppend.cpp:676-690`) | gleiche Zählweise wie die Anzeige. Was Eudora lokal anzeigen kann, findet auch das Hochladen |
| Bild ohne passenden Verweis | `szKopf` leer → Teil ohne `Content-ID`, `inline` (`:1354-1355`, `:2043-2047`) | kein Verlust, Bild hängt als Teil an |
| mehrere Bilder | je Zeile `AddTextBodyPart` (leer → nichts, `:1457-1468`) und ein Bildteil | richtig |
| Text hinter den Bildern | Rest über `AddTextBodyPart(p, NULL)` (`:1380-1385`) | richtig, gemessen in [E-118](../Intern/BEFUNDE.md#e-118) (`FUSSZEILE-E118`) |
| `m_bE118Related` je Nachricht | `CImapAppend` je Nachricht neu (`ImapMailbox.cpp:4189`, `:4428`) | kein Überhang |

### E1 — Zweig „Content-Location“ ist toter Code; der Test prüft eine Annahme, die nicht gilt

`E118EingebettetLesen` sucht den Nicht-`cid:`-Verweis nur bei `CLHash != 0` (`ImapAppend.cpp:913`).
Das zweite Feld der Zeile ist aber **immer 0**: `EmbeddedElement::Init` setzt `m_CLHash = 0`
(`mime.cpp:2109`), `SetCLHash` (`mime.h:101`) ruft niemand. Eudora selbst ordnet solche Bilder über das
**vierte** Feld zu: `HashMT("<MRI dezimal><URL>")` (`mime.cpp:2112-2130`, Anzeige `Convhtml.cpp:671-678`).
Folge: Bilder, die über `Content-Location` verknüpft sind (MHTML, ältere Apple Mail), gehen ohne
Kopfzeile hoch — vorhanden, aber im HTML nicht angezeigt. Kein Verlust, aber Teil 2 wirkt für sie nicht.
`Tests/TestE118.cpp:123-125` prüft `E118Verweis` mit dem Roh-Hash der URL — grün, aber nicht der Weg, den
das Programm nimmt (Lehre `schranke-teilt-nicht-die-annahme`).
**Abhilfe:** im Modus `bCid = 0` den Kandidaten als `Format("%lu%s", MRI, Kandidat)` hashen und mit `X`
vergleichen (wie `Convhtml.cpp:674-677`); `MRI` an `E118Verweis` durchreichen. Test: Hash aus
`"3https://example.invalid/a.png"` gegen `src=https://example.invalid/a.png` mit MRI 3.

### E2 — Bild und echter Anhang in einer Nachricht (Gegenvermutung, nicht gemessen)

Ist ein Bild dabei, wird die **ganze** Nachricht `multipart/related; type="text/html"`
(`ImapAppend.cpp:973`, `:2330-2340`), auch ein `Attachment Converted:`-Anhang steht dann darin
(`Content-Disposition: attachment`). RFC 2387 verbietet das nicht. Gmail, Apple Mail und Outlook zeigen
nicht verwiesene Teile als Anhang; ob jeder Leser das tut, ist nicht gemessen. Richtig wäre
`multipart/mixed` { `multipart/related` { HTML, Bilder }, Anhang } — zwei Grenzen, größerer Umbau.
**Akzeptabel als Zwischenstand**, mit einer Prüfmail (HTML + Bild + PDF) in Thunderbird gegenzusehen.
Randfall: ist der Text vor dem ersten Bild leer, wird das Bild erster Teil, obwohl `type="text/html"`
dasteht (`:1457-1468`); kommt bei empfangener Post praktisch nicht vor.

### E3 — `isMHTML = FALSE`: Bild als „Attachment Converted:“ mit Hashes (Originalfehler, Randfall)

Ist das `multipart/related` nicht als MHTML erkannt, schreibt `WriteEmbeddedElements` dieselbe Zeile mit
`Attachment Converted:` statt `Embedded Content:` (`mime.cpp:2186-2193`), samt `: MRI,…`-Anhang. Der
Anhangszweig (`ImapAppend.cpp:1296-1331`) findet die Datei unter dem Namen mit Hashes nicht, die Zeile
bleibt Text — wie vor 7.2.0.90. Keine Verschlechterung.

## 4. Spurmarken

| Marke | Stelle | Kosten | Inhalt |
|---|---|---|---|
| `E-118 Hochladen` | `ImapAppend.cpp:534-538` | eine Zeile je Nachricht | Merker und `HRESULT` — unbedenklich |
| `E-118 Bild` | `:1345-1347` | eine Zeile je Bild | lokaler Pfad (enthält den Windows-Benutzernamen und den Bildnamen des Absenders) und `Content-ID` — keine Kennwörter, kein Mailtext; vertretbar |
| `E-118 Ziel vor/nach dem Oeffnen` | `ImapActionQueue.cpp:2288-2298` | zwei Durchläufe über den Zielordner je Aufgabe, vernachlässigbar | Kennungsliste. **Aber:** `atoi(NULL)` (P4) und `atoi` statt `strtoul` — zeigt nur die erste Kennung. Ausbauen |
| `E-121 Uebertragung` | `:2381-2383` | eine Zeile je Nachricht | Kennung und drei Merker — unbedenklich, für P1 sogar der Nachweis (`in-quelle=1` bei einer `Out`-Nachricht) |

Alle über `DEBUG_MASK_MISC` (32768), das in Gregors `eudora.log` aktiv ist.

## Zusammenfassung

| Nr. | Art | Fundstelle | Gewicht |
|---|---|---|---|
| F1 (PRÜFER-27) | Text hinter `</x-html>` | `ImapAppend.cpp:714-724` | **behoben** |
| F5 (PRÜFER-27) | Grenze je Textteil | `ImapAppend.cpp:1480-1489` | **behoben** |
| P1 | Quelle über nicht eindeutigen Hash (0 in `Out`) gesucht → fremde Nachricht entfernt | `ImapActionQueue.cpp:2369`, `:2390-2395` ↔ `ImapToc.cpp:1391-1394` | **Datenverlust, neu in 7.2.0.90 — vor Auslieferung beheben** |
| P2 | Quelle mit offenem Fenster entfernt | `ImapActionQueue.cpp:2390-2394`, `summary.cpp:566-572` | Absturzgefahr, Gegenvermutung |
| P3 | Schutz der Bilddateien geht beim Neustart verloren | `tocdoc.cpp:2930-2931`, `summary.cpp:537` | Bildverlust im Nachholfall |
| P4 | `atoi(NULL)` in der Spurmarke | `ImapActionQueue.cpp:2291`, `:2297` | Absturz, selten; Marke ausbauen |
| E1 | Content-Location-Zweig nie erreicht, Test grün auf falscher Annahme | `ImapAppend.cpp:913` ↔ `mime.cpp:2109` | Bilder ohne CID nicht verknüpft, kein Verlust |
| E2 | Anhang innerhalb `multipart/related` | `ImapAppend.cpp:973` | Gegenvermutung, akzeptabel |
| E3 | Bild als `Attachment Converted:` mit Hashes | `mime.cpp:2186-2193` | Originalfehler, Randfall |
| — | Anhangsdateien beim Verwerfen der Vorab-Kopie | `tocdoc.cpp:4359-4365` | **widerlegt**, bleiben erhalten |
| — | `atoi` ab 2^31 in der Zielsuche | `ImapActionQueue.cpp:1636` | **widerlegt** für `HashMT`/UIDs |
