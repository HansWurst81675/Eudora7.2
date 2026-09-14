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
| **Die Behebung führt einen neuen Fehler ein** | **BESTÄTIGT — siehe Befund 1, inzwischen behoben** |

Dazu die zwei roten Tests: **beide waren falsch, nicht der Code.** Siehe den
letzten Abschnitt.

Stand am Ende: **121 Tests, 121 bestanden, 0 fehlgeschlagen.**

---

## Die drei Fragen zur Speichersicherheit, kurz beantwortet

**1. Gibt es einen Pfad, auf dem `lErgebnis > 0` ist, ohne dass vorher
`pBuf += lHolen` mit `lHolen >= lErgebnis` gelaufen ist?**

**Nein.** `lErgebnis` wird an genau einer Stelle auf einen Wert > 0 gesetzt —
im inneren `else`-Zweig von Schritt 1 —, und in demselben Block stehen
unmittelbar danach die Deckelung `else if (lErgebnis > lHolen) lErgebnis =
lHolen;` und `pBuf += lHolen;`. Beide werden zusammen ausgeführt oder gar
nicht; zwischen diesem Block und dem `memcpy` in Schritt 4 gibt es keine
weitere Zuweisung an `pBuf` (Schritt 2 ändert nur `lSize`, Schritt 3 nur den
Inhalt). Also gilt beim `memcpy` immer `pBuf - lErgebnis >= pBuf - lHolen =
*ppBuf beim Eintritt`. Der ausführliche Beweis samt der Invariante
`1 <= lHolen` steht weiter unten unter "Ist `ISOTranslateChunk`
speichersicher?".

**2. Bleibt `lErgebnis` im Fall `*plUebertrag > 0, lNoetig == 0` von einem
früheren Durchlauf stehen?**

**Nein.** `utils.cpp`, Deklarationsblock von `ISOTranslateChunk`:
`LONG lErgebnis = 0;` — bei der Deklaration initialisiert, und es ist eine
gewöhnliche lokale Variable ohne `static`. Jeder Aufruf beginnt bei 0. Im Zweig
`lNoetig == 0` wird `*plUebertrag = 0` gesetzt und sonst nichts; `lErgebnis`
bleibt 0, Schritt 4 wird nicht betreten, `pBuf` bleibt unverschoben. (Der
Nebeneffekt: die zurückgehaltenen Bytes verschwinden — das ist Befund 2, kein
Speicherproblem.)

**3. Schreibt `ISOTranslate` mit `szBuf[lSize] = 0` über das Ende hinaus, wenn
`pBuf` bei `m_bMustReadSingleLines` mitten in den Puffer zeigt?**

**JA — das ist der gefundene Fehler, Befund 1.** Bei `m_bMustReadSingleLines`
gilt nicht die Rechnung mit der `BUFLEN + 4`-Reserve: `GetNextChunk` liefert
`*pBuf = m_pStart` und `*lBytes = inLen`, und `m_pNext = m_pStart + inLen` ist
das erste Byte der nächsten Zeile IM SELBEN PUFFER. `pBuf[lSize]` trifft genau
dieses Byte. Die Reserve am Pufferende hilft dort nicht.

Nicht argumentiert, sondern gemessen: mit herausgenommener Rettung meldet die
neue Schranke *"Index 4: das erste Byte der naechsten Zeile wurde auf 0x00
gesetzt, erwartet 'X' (0x58)"* — und dasselbe für Index 3 (Latin-9). Behoben in
`86a5441`.

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

**BEHOBEN** (Commit `86a5441`): Das Byte an `pBuf[lSize]` wird in
`ISOTranslateChunk` um beide `ISOTranslate`-Aufrufe auf dem fremden Puffer
herum gerettet — vor dem Aufruf gelesen, danach zurückgeschrieben, und nur
dort, wo `ISOTranslate` überhaupt schreibt (`iCharsetIdx > 2`, `lSize >= 0`).
`ISOTranslate` selbst bleibt unangetastet, so wie der Kommentar dort es
verlangt.

Dazu die Schranke `ISOTranslateChunk: das Byte hinter dem Stueck bleibt
unangetastet` (`Eudora71/Tests/TestIsoTranslate.cpp`): zwei Zeilen in einem
Puffer, Wächterbyte `'X'` hinter der ersten, geprüft für UTF-8 und Latin-9.
Gegengetestet — mit herausgenommener Rettung schlägt sie an.

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

Der gemeinsame `CChunkReader` ist aber die Quelle von Befund 1 — der zweite
Schreibweg hat die Lücke nicht, weil er gar nicht übersetzt.

---

## Die zwei roten Tests: beide waren falsch, nicht der Code

### `SECImage: FlipHorz/FlipVert/… melden sich`

Die Vermutung stimmt. `OTShimNichtUmgesetzt` (`Eudora71/OTShim/OTShim.cpp`)
ruft seit E-33 (07.09.2026) `::OutputDebugString`, nicht mehr `AfxMessageBox`.
Die Probe in `Eudora71/Tests/OTShimProbe.cpp` fängt `CWinApp::DoMessageBox` ab
und sieht deshalb nichts; sie zählte auf null, der Test erwartete fünf.

Berichtigt, aber **nicht entschärft, sondern umgedreht**: aus der Zählung wird
eine Schranke GEGEN E-33 — kein Rumpf darf ein Meldungsfenster aufmachen.
Damit sie nicht grün ist, weil gar nichts lief, belegen die Rückgabewerte, dass
alle sechs Rümpfe gelaufen sind. Was nicht prüfbar ist (ob die Meldung wirklich
in der Debug-Ausgabe ankommt, ob das Merkzeichen sie beim zweiten Mal
unterdrückt), behauptet der Test nicht mehr — `::OutputDebugString` lässt sich
im eigenen Prozess ohne Debugger nicht verlässlich mitlesen.

Gegengetestet: mit `AfxMessageBox(strMeldung)` statt `::OutputDebugString`
schlägt die Schranke an — *"E-33 ist zurueck: 6 modale Meldung(en) aus den
Ruempfen"*.

### `SECControlBar::CalcDynamicLayout: der Schwebe-Zweig zieht an einem Rand`

**Der Test war falsch, der Code hat recht.** Er erwartete von
`CalcDynamicLayout(320, LM_COMMIT)` das Ergebnis 320x150 — also genau das, was
BEFUND E-76 WAR. Die Schranke war am 13.09.2026 gegen die *Erwartung*
geschrieben, nicht gegen das Gemessene, und konnte nie laufen, weil
`EudoraTests.exe` seit dem 10.09. nicht linkte.

Gemessen hat es die Spurmarke `E76Marke` in `OTShim.cpp`: beim abschließenden
Aufruf ist `dwMode = LM_COMMIT|LM_HORZ` **ohne** `LM_LENGTHY`, und `nLength`
trägt dort die BREITE (780), nicht die gezogene Höhe. Wer beim COMMIT `nLength`
als Breite übernimmt, speichert 780x100 statt 780x299 — Gregors Meldung
*"filter fenster laesst sich nicht nach unten vergroessern, nur zur seite"*.
Deshalb ignoriert die Behebung `nLength` beim COMMIT und nimmt
`m_szZuletztGezogen`. E-76 ist am laufenden Programm bestätigt.

Der Test prüft jetzt das bestätigte Verhalten und bekommt eine Gegenprobe in
Gregors Richtung: der gemessene Ablauf (105/172/234/299 mit
`LM_LENGTHY|LM_HORZ`, dann `LM_COMMIT|LM_HORZ` mit der Breite 780) muss die
gezogene Höhe überleben.

Gegengetestet: mit dem alten Zweig (`else` statt `else if (!(dwMode &
LM_COMMIT))`, kein Merker beim Speichern) schlägt die Schranke an und meldet
exakt die aus dem Protokoll bekannten 780x100.

### Nachgezogen: ein Testname, der seit E-85 nicht mehr stimmte

`TestPopEmpfang.cpp`: *"POP: der Index wird um eins verschoben — anders als im
IMAP-Pfad"* war grün und trotzdem veraltet. Der Test beschrieb sich selbst als
"Belegstelle fuer den bekannten IMAP-Fehler" — den es seit E-85 nicht mehr
gibt. Name und Begründung nachgezogen; die Messungen bleiben, denn sie
begründen jetzt, WARUM die Verschiebung nötig ist.

---

## Was zurückbleibt

- Befund 2 und 3 in `ISOTranslateChunk` sind nicht behoben: beide sind
  unerreichbar, beide beschreiben aber einen Fall, den es so nicht gibt.
- `ISOTranslate` selbst null-terminiert weiterhin einen Byte hinter dem
  Bereich. Jeder künftige Aufrufer mit fremdem Puffer läuft in dieselbe Falle.
  Der Kommentar in `utils.cpp` warnt davor, das zu ändern; eine Schranke, die
  neue Aufrufstellen darauf prüft, gibt es nicht.
- `SECControlBar::CalcDynamicLayout`: zieht der Anwender erst in der Höhe und
  dann in der Breite, setzt der Breiten-Zweig `size = m_szFloat` und verwirft
  damit die gerade gezogene Höhe im Merker. Ob MFC beim Ziehen an einer Ecke
  beide Richtungen nacheinander meldet, ist ungeprüft. Nicht gemessen, deshalb
  hier nur notiert.
