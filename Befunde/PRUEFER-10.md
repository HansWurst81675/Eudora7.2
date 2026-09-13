# PRUEFER-10 — E-85 adversarisch nachgerechnet

Stand: 13.09.2026, Zweig `wt/pruefer`, Ausgangspunkt 82a6d6f (E-85 aus 881d5c4).

Alle Aussagen unten sind an der Quelle gemessen, nicht vermutet. Zeilennummern
beziehen sich auf den Stand 82a6d6f.

---

## Kurzfassung

| Gegenvermutung | Ergebnis |
|---|---|
| Die Behauptung über die Ressourcenkennungen stimmt nicht | **widerlegt** — sie stimmt genau |
| `FindMIMECharset` liefert eine andere Skala als `ISOTranslate` erwartet | **widerlegt** — dieselbe Skala, für jeden Zeichensatz durchgerechnet |
| Die Schwelle `> 2` ist falsch | **widerlegt** — sie ist richtig, `> 1` war es auf der neuen Skala nicht |
| Es gibt weitere Stellen im IMAP-Weg mit der alten Skala | **widerlegt** — `ImapLex822.cpp` rechnete schon immer auf der neuen |
| `ISOTranslateChunk` schreibt vor den Anfang des Stücks | **widerlegt** — kein Pfad kann das, Beweis unten |
| `imapgets.cpp` hat einen zweiten Schreibweg mit derselben Lücke | **widerlegt** — `CFileWriter` schreibt Anhänge, dort ist Nicht-Übersetzen richtig |
| **Die Behebung führt einen neuen Fehler ein** | **BESTÄTIGT — siehe Befund 1** |

---

## Befund 1 (NEU, schwer): ISOTranslate nullt das erste Byte der nächsten Zeile

**Wo:** `Eudora71/Eudora/utils.cpp:1443` (`szBuf[lSize] = 0;` in `ISOTranslate`),
ausgelöst über `Eudora71/EuImap/src/ImapDownload.cpp:4705` →
`ISOTranslateChunk` → Schritt 3.

**Was passiert:** `ISOTranslate` schreibt eine Null an `szBuf[lSize]`, also EIN
BYTE HINTER den übergebenen Bereich. Im IMAP-Weg zeigt `pBuf` bei
`m_bMustReadSingleLines` (das ist **text/plain**) mitten in den Puffer von
`CChunkReader` — `*pBuf = m_pStart`, `*lBytes = inLen`, und `m_pNext = m_pStart +
inLen` ist das **erste Byte der nächsten Zeile im selben Puffer**
(`imapgets.cpp:1309-1311`). Dieses Byte wird auf 0 gesetzt.

Folge: Bei einer IMAP-Nachricht `text/plain; charset=utf-8` ohne
Content-Transfer-Encoding-Decoder (also `8bit`/`7bit`/`binary` — der Normalfall
für UTF-8-Post) verliert **jede Zeile ihr erstes Zeichen**, und statt dessen
landet ein NUL-Byte in der Mailboxdatei.

**Warum es vorher nicht auftrat:** Das ist keine Altlast, sondern eine
Regression von 881d5c4. Der alte Code konnte `szBuf[lSize] = 0` nie erreichen:

| charset | alter Index | `> 1`? | ISOTranslate |
|---|---|---|---|
| `windows-*` | -1 | nein | nicht gerufen |
| `us-ascii` | 0 | nein | nicht gerufen |
| `iso-8859-1` | 1 | nein | nicht gerufen |
| `iso-8859-15` | 2 | ja | gerufen, aber `iCharsetIdx <= 2` → **return vor der Nullung** |
| `utf-8` | -1 | nein | nicht gerufen |

`ISOTranslate` kehrt bei `iCharsetIdx <= 2` zurück, BEVOR `szBuf[lSize] = 0`
ausgeführt wird (`utils.cpp:1411-1443`). Der alte IMAP-Weg hat also faktisch
**nie** übersetzt und **nie** das Folgebyte angefasst. Erst mit Index 4 für
UTF-8 (und 3 für Latin-9) wird die Nullung erreicht.

**Warum der POP3-Weg das nicht hat:** `TextReader::ReadIt` lässt bewusst Platz
am Pufferende — der Kommentar `TextReader.cpp:177-179` sagt das ausdrücklich
("It's safer to make ourselves leave space for ISOTranslate than to change
ISOTranslate"). Der IMAP-Weg hat diesen Platz nicht, weil hinter der Zeile die
nächste Zeile steht, nicht das Pufferende.

**Nicht betroffen:**
- Blockmodus (text/html): `pBuf = m_pReadBuffer`, `inLen = BUFLEN`, der Puffer
  ist `BUFLEN + 4` groß (`imapgets.cpp:1179`) — die Null landet in der Reserve.
- Mit Decoder (base64, quoted-printable): `pBuf` zeigt dann auf
  `m_pReadBuffer`/`m_pWriteBuffer` des `CImapDownloader`, beide `BUFLEN + 4`.
- Letzte Zeile eines Pufferinhalts: `m_pNext` zeigt hinter die Daten, aber noch
  in die +4-Reserve.

**Vorschlag:** Das Byte an `pBuf[lSize]` in `ISOTranslateChunk` vor Schritt 3
sichern und danach wiederherstellen. Das trifft genau die Stelle, an der der
fremde Puffer benutzt wird, und lässt `ISOTranslate` unangetastet.

---

## Befund 2 (klein): Übertrag ohne Kopfbyte verschwindet

`utils.cpp:1310-1313`: Ist `szUebertrag[0]` kein UTF-8-Kopfbyte, wird
`*plUebertrag = 0` gesetzt und die zurückgehaltenen Bytes fallen ersatzlos weg.
Sie gehörten eigentlich vor das Stück ausgegeben. Praktisch unerreichbar, weil
`ISOIncompleteUTF8Tail` nur Kopfbytes zurückhält — aber der Zweig behauptet,
diesen Fall zu behandeln, und tut es durch Löschen.

## Befund 3 (kosmetisch): toter Zweig

`utils.cpp:1327-1330`: Der `else`-Zweig zu `if (*plUebertrag + lSize <= 4)` ist
unerreichbar. Die Bedingung, unter der man dort landet, ist `lHolen > lSize`,
also `*plUebertrag + lSize < lNoetig <= 4`. Die Prüfung ist damit immer wahr.
Harmlos, aber der Kommentar "laenger als jedes Zeichen - verwerfen" beschreibt
einen Fall, den es nicht gibt.

---

## Die einzelnen Fragen

### Ressourcenkennungen

Gemessen in `Eudora71/Eudora/resource.h:1807-1810`:

    IDS_MIME_US_ASCII    3611
    IDS_MIME_ISO_LATIN1  3612
    IDS_MIME_ISO_LATIN9  3613
    IDS_MIME_UTF_8       3614

Und die Texte in `Eudora71/Eudora/EudoraRes.rc:9385-9388`: `"us-ascii"`,
`"iso-8859-1"`, `"iso-8859-15"`, `"utf-8"`. Die Behauptung stimmt: der alte
Suchbereich endete bei 3613, UTF-8 lag dahinter und konnte nie gefunden werden.
`FindRStringIndexI` vergleicht mit `len < 0` über `stricmp`, also exakt und ohne
Rücksicht auf Groß- und Kleinschreibung (`rs.cpp:803-810`) — "UTF-8" und "utf-8"
sind gleichwertig, ein `charset="utf-8"` mit Anführungszeichen aber nicht. Das
gilt für den alten wie für den neuen Weg gleichermaßen, ist also kein Unterschied.

### Skala, für jeden Zeichensatz durchgerechnet

`FindMIMECharset` (`mime.cpp:382-401`): `windows-*` → 0; sonst
`FindRStringIndexI(3611, 3614, ...)` → 0..3, danach `++` → 1..4; unbekannt → -1.

| charset | FindMIMECharset | `> 2`? | ISOTranslate nach `-= 3` | Tabelle |
|---|---|---|---|---|
| `windows-1252` | 0 | nein | — | — |
| `us-ascii` | 1 | nein | — | — |
| `iso-8859-1` | 2 | nein | — | — |
| `iso-8859-15` | 3 | ja | 0 | Tabellenzeile 0 |
| `utf-8` | 4 | ja | 1 | Codepage-Zweig |
| `koi8-r`, `iso-2022-jp`, … | -1 → 0 | nein | — | — |

`MAX_CHARACTER_SETS` ist `IDS_MIME_UTF_8 - IDS_MIME_US_ASCII - 1 = 2`
(`utils.cpp:59`). Die beiden erreichbaren Tabellenindizes 0 und 1 liegen darunter,
`ASSERT(0)` bei `iCharsetIdx >= MAX_CHARACTER_SETS` kann nicht auslösen.

`ISOIsUTF8Charset` (`utils.cpp:1159-1162`) rechnet
`IDS_MIME_UTF_8 - IDS_MIME_ISO_LATIN9 + 3 = 4` — genau der Wert, den
`FindMIMECharset("utf-8")` liefert. Der Codepage-Zweig in `ISOTranslate`
(`utils.cpp:1476`) prüft `iCharsetIdx == IDS_MIME_UTF_8 - IDS_MIME_ISO_LATIN9`
NACH `iCharsetIdx -= 3`, also gegen 1. Beide Rechnungen treffen denselben
Zeichensatz. **Die Skalen sind identisch.**

Zusatzbefund: Der alte IMAP-Code war nicht nur für UTF-8 kaputt, sondern auch
für ISO-8859-15. Er gab den Index 2 an `ISOTranslate`, das bei `<= 2` sofort
zurückkehrt. Der ganze Übersetzungszweig im IMAP-Weg war toter Code. Die
Behebung ist damit sogar besser begründet als in der Commit-Nachricht steht.

### Schwelle `> 1` auf `> 2`

Richtig. Auf der neuen Skala ist 2 = Latin-1, das nicht übersetzt werden darf;
mit `> 1` wäre Latin-1 an `ISOTranslate` gegangen — das hätte zwar wegen
`<= 2` nichts übersetzt, aber die Schwelle wäre gegen `TextReader.cpp` und
`ImapLex822.cpp:574` verschoben gewesen. Verhalten bei Index 2:
vorher (alte Skala, 2 = Latin-9) Zweig betreten, `ISOTranslate` no-op;
nachher (neue Skala, 2 = Latin-1) Zweig nicht betreten. Beides ergibt "keine
Übersetzung" — kein Unterschied für den Anwender, aber nur die neue Fassung
sagt auch das, was sie tut.

### Weitere Stellen mit `iCharsetIdx` im IMAP-Weg

`grep -rn iCharsetIdx Eudora71/EuImap/` findet außer `ImapDownload.cpp` nur
`ImapLex822.cpp:549,553,572,574,577`. Das ist `Translate2047` für die
Kopfzeilen — es ruft seit jeher `FindMIMECharset` und prüft `> 2`, also schon
auf der neuen Skala. Die Variable ist dort lokal, es gibt keine Wechselwirkung.
**Es gibt genau eine geänderte Stelle.**

### Ist `ISOTranslateChunk` speichersicher?

Ja. Der gefährliche `memcpy(pBuf - lErgebnis, szVereint, lErgebnis)` in Schritt 4
kann nicht vor den Anfang des Stücks schreiben. Beweis über die Invariante:

1. `lErgebnis > 0` wird nur in Schritt 1 gesetzt, und nur im Zweig, in dem
   auch `pBuf += lHolen` ausgeführt wird. Zwischen Schritt 1 und Schritt 4
   wird `pBuf` nicht weiter verändert (Schritt 2 ändert nur `lSize`,
   Schritt 3 nur den Inhalt).
2. `lErgebnis` wird unmittelbar davor auf `lHolen` gedeckelt
   (`else if (lErgebnis > lHolen) lErgebnis = lHolen;`).
3. Also `pBuf - lErgebnis >= (pBuf - lHolen) = *ppBuf beim Eintritt`.

Die Invariante `1 <= lHolen` hält ebenfalls: `*plUebertrag < lNoetig` gilt beim
Eintritt immer, denn `*plUebertrag` wird nur an zwei Stellen gesetzt —
`ISOIncompleteUTF8Tail` liefert `lTail` nur, wenn `lTail < lNeeded`, und der
Anhäng-Zweig wird nur bei `*plUebertrag + lSize < lNoetig` betreten. Ein
negatives `lHolen` (das über `memcpy(..., (size_t)lHolen)` zu einem Unterlauf
und damit zu einem sofortigen Absturz führen würde) ist damit ausgeschlossen.
Wäre es erreichbar, wäre es die gefährlichste Stelle der Datei — es ist nicht
erreichbar, aber die Funktion prüft es auch nicht ab.

Alle übrigen `memcpy`:
- `memcpy(szVereint, szUebertrag, *plUebertrag)` — `szVereint[8]`, Wert ≤ 4. OK.
- `memcpy(szVereint + *plUebertrag, pBuf, lHolen)` — Summe = `lNoetig` ≤ 4. OK.
- `szVereint[lNoetig] = 0` — Index ≤ 4 < 8. OK.
- `memcpy(szUebertrag + *plUebertrag, pBuf, lSize)` — durch die Prüfung
  `*plUebertrag + lSize <= 4` gedeckelt, `szUTF8Uebertrag[4]`. OK.
- `memcpy(szUebertrag, pBuf + lSize - lTail, lTail)` — `lTail` ≤ 3. OK.

Der einzige Schreibzugriff außerhalb des Stücks ist der aus Befund 1, und der
steckt in `ISOTranslate`, nicht in `ISOTranslateChunk`.

### Zweiter Schreibweg in `imapgets.cpp`

`imapgets.cpp:467` steht in `CFileWriter::Write` — das ist der Weg, der
**Anhänge in Dateien** schreibt, nicht der Nachrichtenrumpf in die Mailboxdatei.
Dort gibt es keine Zeichensatzumwandlung und darf auch keine geben: eine
angehängte Datei muss byteweise so ankommen, wie sie abgeschickt wurde. Der
POP3-Weg macht es genauso. **Keine zweite Lücke.**
