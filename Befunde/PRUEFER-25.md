# PRÜFER-25 — E-115 (`3e714c4`) und E-117 (`afc9cd5`), Hinweise zu E-118/E-119

Lauf am 13.10.2026, nur lesend. Nichts gebaut, nichts geändert, kein Programm gestartet.
Stand: Zweig `wt/pruefer`, gemergt mit `origin/e-112-skalierung` (`2d7c922`).

**Nicht selbst gemessen:** die Laufbeobachtungen (7.2.0.84 Meldung / 7.2.0.86 keine;
7.2.0.85 holt `&amp;w=2`, 7.2.0.87 holt `&w=2`) und die Testsuite 196/196 sind aus
dem Auftrag bzw. den Commit-Nachrichten übernommen. Nachgerechnet ist nur, ob sie
zur Quelle passen.

**Urteil: beide Behebungen richtig und auslieferbar.** [E-115](../Intern/BEFUNDE.md#e-115) traversiert vollständig,
ohne Lücke und ohne Doppelprüfung. [E-117](../Intern/BEFUNDE.md#e-117) ist längen- und lesesicher, deckt aber nur
die eine Entität `&amp;` ab (G2). Zwei Funde am Rand, beide **nicht** durch diese
Commits entstanden: eine zweite %-Dekodierung im Ladeweg mit Überlesen am
Pufferende (G3), und für [E-118](../Intern/BEFUNDE.md#e-118) eine andere Ursachenstelle als in BEFUNDE.md (H1).
Für [E-119](../Intern/BEFUNDE.md#e-119) ist der in BEFUNDE.md vorgeschlagene Behebungsort zu spät (H2).

---

## 1. E-115 — `FindCheck` (`Eudora71/Eudora/MBoxTreeCtrlCheck.cpp:928-967`)

### 1.1 Traversierung nachgerechnet

`GetNextTraversalItem(h, false)` (`:617-632`) liefert den nächsten Knoten **nach dem
ganzen Teilbaum** von `h`: erst Geschwister, sonst Geschwister eines Vorfahren, sonst NULL.

Ablauf mit Recent = R, Nachfolger nach R-Teilbaum = X:

| Schritt | hItem | geprüft |
|---|---|---|
| Schleifenkopf liefert R | R | — |
| `:945-950` Sprung | X (oder NULL → `break`) | — |
| Rumpf `:952-963` | X | **X einmal** |
| Schleifenkopf `GetNextTraversalItem(X)` | Kind von X bzw. Nachfolger | normal weiter |

- **Kein Element übersprungen:** X ist genau der Knoten, den die Vorordnung nach dem
  letzten R-Nachkommen besucht hätte; er wird im selben Durchlauf geprüft.
- **Kein Element doppelt:** der Schleifenkopf geht von X weiter, nicht von R.
- **R-Kinder werden nicht geprüft:** gewollt, sonst fände `FindCheck` die Recent-Kopie
  (gleicher `m_pCommand`) vor dem echten Postfach.
- **NULL-Fall:** `break` statt `GetItemData(NULL)` — das war die Wurfstelle.
- Gleichwertig zum Original, wenn R Geschwister hat (`GetNextSiblingItem` = `GetNextTraversalItem(…, false)` in diesem Fall).

**Gegenvermutung zur Begründung, nicht zur Behebung:** der Kommentar `:939-941` sagt
„Recent ist der LETZTE Eintrag unter dem Mailverzeichnis“. Eingefügt wird Recent aber
**nach Trash** (`QCMailboxTreeCtrl.cpp:445-458`, `hInsertAfter = Trash`), nicht ans Ende.
Letzter Eintrag ist es nur, wenn hinter Trash keine eigenen Postfächer/Ordner stehen
oder diese vor Recent eingefügt wurden. Ungemessen. Die Behebung deckt beide Lagen ab;
nur der Kommentar ist enger als die Quelle.

### 1.2 Gleiches Muster anderswo

Gesucht: Recent-Sprung bzw. `GetNextSiblingItem` mit möglichem NULL vor `GetItemData`.

| Stelle | Urteil |
|---|---|
| `MBoxTreeCtrlCheck.cpp:331, 401, 422, 433, 488, 502, 558` | alle in `while (hChild)`/`while (hRoot)` — sicher |
| `MBoxTreeCtrlCheck.cpp:791/856` `GetListMailboxPathnamesWithSelectedState` | sicher (`GetNextTraversalItem`). **Nebenbefund, ungemessen:** Recent selbst wird übergangen, `bWantChildren` bleibt aber `true` → die **Kinder** von Recent werden besucht und, wenn angehakt (z.B. nach „Alle auswählen“, `CheckAll` `:866-871` hakt auch sie an), ein zweites Mal in die Suchliste gelegt. Folge höchstens doppelte Suche/doppelte Treffer. Original QUALCOMM |
| `mboxtree.cpp:584-603` `GetNextWrapItem` | sicher, wickelt auf `GetRootItem()` |
| `mboxtree.cpp:795, 848, 907, 947` | `while (h_child != NULL)` — sicher |
| `mboxtree.cpp:3085-3088` `FindPathname` | `for (; hItem; …)` mit `continue` bei Recent — sicher |
| `mboxtree.cpp:3108` `FindPathname(GetNextSiblingItem(hItem), …)` | kann NULL übergeben; `:3076-3080` fängt das ab (`return NULL`), nur das `ASSERT` `:3074` schlägt im Debug an |
| `QCMailboxTreeCtrl.cpp:445-453` | `while (hItem)` — sicher; aber `p_itemdata->m_itemType` ohne NULL-Prüfung (Original, ungemessen, nie gesehen) |
| `SearchView.cpp:5306` `HandleSelectMessage` | prüft `hItem` vor `Expand`/`Select` (`:5310`) — sicher |

**Keine zweite Stelle mit demselben Fehler.**

---

## 2. E-117 — `resolve_URL` (`Eudora71/Eudora/HTMLUtils.cpp:15-92`)

### 2.1 Aufrufer

| Aufrufer | Eingabe | Wirkung der Änderung |
|---|---|---|
| `PGHTMIMP.CPP:2006` (`<img src>` beim HTML-Import) | roher Attributwert, Entitäten **nicht** dekodiert (Tokenizer `:793-847` kopiert nur) | gewollt: `&amp;` → `&` |
| `PgEmbeddedImage.cpp:1415` (`PgNewUrlImageRef`, nur wenn `pUrlImage == NULL`) | `file://`-Pfad aus `make_filepath_url` (`:1294-1302`, hängt nur `file://` vor, **keine** Maskierung): `PgInsertImageFromFile` `:165`, `PgInsertEmoticonImageFromFile` `:183` | G1 |

Kein Weg ruft `resolve_URL` zweimal auf dieselbe Zeichenkette (`:2006` schreibt in
`szImageURL`, danach `strncpy`/`strcat` in `image_record.URL`, `:2034-2049`).

### 2.2 Grenzen

- **Länge:** der neue Zweig schreibt genau ein Zeichen und läuft durch dieselbe
  Zählung `output_size++` / `== nMaxLength` (`:86-89`). Höchstens `nMaxLength-1`
  Zeichen plus Null — wie die anderen Zweige. Richtig.
- **Lesen:** `input[1..4]` werden nur gelesen, solange die Vorgänger passen
  (`&&` kurzschließt); bei `"…&am"` am Ende scheitert der Vergleich am Nullbyte,
  kein Überlesen. Richtig.
- **`&amp;amp;` → `&amp;`:** richtig — einmal dekodieren ist HTML-Semantik; die
  Ausgabe wird nicht erneut abgetastet.
- **`%26amp;` → `&amp;`:** richtig — das %-Ergebnis wird nicht erneut geprüft.
- Fehlende Tests (nur Vorschlag): `&amp;` genau an der `nMaxLength`-Grenze,
  `&amp;amp;`, abgeschnittenes `&am` am Ende. `TestResolveURL.cpp:192-205` prüft nur
  den eBay-Fall und ein einzelnes `&`.

### 2.3 Gegenvermutungen

**G1 — wörtliches `&amp;` in einem Dateinamen (gering, ungemessen).** „Bild
einfügen“ mit einer Datei `Tom &amp; Jerry.jpg` ergibt jetzt `file://…Tom & Jerry.jpg`
→ Datei nicht gefunden. Dieselbe Klasse besteht seit jeher für `%xx` in
Dateinamen (`a%41.jpg` → `aA.jpg`), weil `make_filepath_url` nicht maskiert.
Kein Grund, die Änderung zurückzunehmen.

**G2 — nur eine Entität (Lücke, ungemessen).** Links laufen durch den vollen
Entitätsdekoder `Html2Text` (`PGHTMIMP.CPP:3151-3154`), Bilder jetzt nur durch
`&amp;`. Nicht übersetzt werden u.a. `&#38;`, `&#x26;`, `&AMP;`, `&quot;`, `&#39;`.
`&#38;` kommt in Newsletter-HTML vor. `Html2Text` direkt zu nehmen wäre
**nicht** gleichwertig (behandelt Tags/Zeilen), wohl aber die Entitätentabelle,
die der Import schon hat (`PGHTMIMP.CPP:3000-3020`, `character_entity_arr`).

**G3 — zweite %-Dekodierung im Ladeweg (Original, ungemessen, betrifft [E-110](../Intern/BEFUNDE.md#e-110)).**
`PgEmbeddedImage.cpp:494-495` ruft vor dem Abruf `unescape_url(purl)` auf
`pUrlImage->URL` auf — die Adresse ist dann bereits durch `resolve_URL` dekodiert.
Folgen:
1. `%2541` → `%41` (resolve_URL) → `A` (unescape_url): doppelt dekodiert.
2. `unescape_url` (`HTMLUtils.cpp:116-127`) hat **keine Endprüfung**: endet die
   Zeichenkette auf `%` oder `%x` (entsteht aus `…%25` am Ende), liest
   `x2c(&url[j+1])` über das Nullbyte hinaus und `j += 2` springt hinter das Ende —
   die Schleife läuft in fremdem Speicher weiter.
`&amp;` ist davon nicht berührt (`unescape_url` kennt kein `&`).

**G4 — Ausfuhr maskiert nicht (Original, ungemessen).** `PGHTMEXP.CPP:961` schreibt
`image_ptr->URL` über `InsertParameter` (`:1750-1781`) **roh** zurück: kein `&` → `&amp;`,
kein `%` → `%25`. Wird eine so ausgeführte Nachricht wieder eingelesen (Antwort,
Weiterleitung über den Export), wird erneut dekodiert: `&amp;amp;` → `&amp;` → `&`,
`%2541` → `A`. Ob Antworten/Weiterleiten diesen Rundweg nehmen, ist nicht gemessen;
Gregors Messung an 7.2.0.87 zeigt jedenfalls den Normalfall richtig.

---

## 3. Hinweise für E-118 und E-119

### H1 — E-118: die Ursache liegt nicht in `AppendContentType`

BEFUNDE.md nennt `AppendContentType` (`EuImap/src/ImapAppend.cpp:120`). Am Quelltext:

- `AppendContentType` (`:1821-1871`) wird **nur für Anhänge** gerufen (`:1640`, `:1650`,
  jeweils mit `MIMEMap* mm`, das `Type`/`Subtype` überschreibt `:1851-1855`). Für den
  Textrumpf läuft sie nie.
- `ReformatHeader` verwirft **alle** `Content-*`-Köpfe der Nachricht
  (`IsHeaderToInclude` `:2020-2026`, Präfix `IDS_MIME_HEADER_PREFIX` = `"Content-"`,
  `EudoraRes.rc:7773`; Aufruf `:880`).
- Einteilig: `AppendMIMEMessageHeaders(NULL, …)` (`:692`, Rumpf `:1980-2010`) schreibt
  nur `MIME-Version` — **gar kein** `Content-Type`. Der Server nimmt den Vorgabewert
  `text/plain; charset=us-ascii` (RFC 2045). Damit fehlt auch der Zeichensatz.
- Mehrteilig: `AddTextBodyPart` schreibt fest `text/plain` (`:1166-1169`).

Behebungsort also `:692`/`:1980` und `:1166`, nicht `:1821`. Vorlage für die Entscheidung:
`SendContentType` (`Eudora/sendmail.cpp:766-821`) — `MSF_XRICH` → `text/html`
(`IDS_MIME_HTML`, `:790-794`), sonst `text/plain` plus `format=flowed`; Charset über
`NameCharset` (`:780`), QP/8bit `:816`. Aufgerufen mit `MSF_XRICH` für HTML in
`sendmail.cpp:2012`. In `ImapAppend.cpp` gibt es keine dieser Kennungen; woher dort
der HTML-Merker der Nachricht käme (Summary-Flag), ist nicht nachgesehen.
**Ungemessen:** Rohkopf auf dem Server; ob es neben `ReformatMessage` (`:655`) einen
Hochladeweg ohne Umbau gibt.

### H2 — E-119: im Ladeweg ist das Bild schon abgeschnitten

BEFUNDE.md schlägt vor, das `data:`-Bild in `PgEmbeddedImage.cpp` vor
`CanHandleImageInternally` zu dekodieren. Das reicht nicht:

1. Der HTML-Import kürzt jeden Attributwert auf 1023 Zeichen
   (`PGHTMIMP.CPP:3317-3318`, `kMaxAttributeSize` `PaigeDLL/PGHEADER/PGTXR.H:312`).
2. `resolve_URL` schreibt in `szImageURL[512]` (`PGHTMIMP.CPP:1996`, `:2006`),
   das Ziel `pg_url_image.URL` hat 512 Byte (`PaigeDLL/PGHEADER/PAIGE.H:1479`).

Ein 600×224-JPEG in Base64 hat zehntausende Zeichen; im Ladeweg kommen davon höchstens
511 an. Die Dekodierung muss **vor** `:3317` ansetzen (beim Zerlegen des `<img>`-Tags),
die Daten in eine Datei unter `Embedded` schreiben und `src` durch `file://…` bzw.
eine `cid:` ersetzen. Zusätzlich: `data:` steht nicht in `IDS_URL_SCHEMES`
(`EudoraRes.rc:10828`) → `IsURLScheme` (`Text2Html.cpp:287`) ist falsch, und bei
vorhandenem `<base href>` hängt `PGHTMIMP.CPP:2011-2050` die Basisadresse davor.

Vorhandener Dekoder: `Base64Decoder` (`Eudora/Base64.h:29-38`, `Base64.cpp:146ff`),
Schnittstelle `Init()` + `Decode(In, InLen, Out, OutLen)` (`Decode.h`), im Speicher,
schon außerhalb von MIME benutzt in `AuthRPA.cpp:257`. Prozent-kodierte `data:`-Adressen
(ohne `;base64`) bräuchten `unescape_url` — mit der Endprüfung aus G3.

---

## Zusammenfassung

| Nr | Art | Ort | Stand |
|---|---|---|---|
| [E-115](../Intern/BEFUNDE.md#e-115) | Behebung richtig | `MBoxTreeCtrlCheck.cpp:945-950` | Traversierung nachgerechnet |
| — | Kommentar enger als Quelle | `MBoxTreeCtrlCheck.cpp:939-941` vs. `QCMailboxTreeCtrl.cpp:445-458` | ungemessen |
| — | Recent-Kinder in Suchliste | `MBoxTreeCtrlCheck.cpp:791/856` | Original, ungemessen |
| [E-117](../Intern/BEFUNDE.md#e-117) | Behebung richtig | `HTMLUtils.cpp:73-84` | Länge/Lesen nachgerechnet |
| G1 | `&amp;` im Dateinamen | `PgEmbeddedImage.cpp:1294-1302, 1415` | gering, ungemessen |
| G2 | nur `&amp;`, nicht `&#38;` u.a. | `HTMLUtils.cpp:73` vs. `PGHTMIMP.CPP:3151-3154` | Lücke, ungemessen |
| G3 | doppelte %-Dekodierung, Überlesen | `PgEmbeddedImage.cpp:495`, `HTMLUtils.cpp:116-127` | Original, ungemessen |
| G4 | Ausfuhr maskiert nicht | `PGHTMEXP.CPP:961, 1750-1781` | Original, ungemessen |
| H1 | [E-118](../Intern/BEFUNDE.md#e-118) Ursachenort | `ImapAppend.cpp:692, 1980-2010, 1166-1169, 2020-2026` | am Quelltext |
| H2 | [E-119](../Intern/BEFUNDE.md#e-119) Behebungsort zu spät | `PGHTMIMP.CPP:3317`, `PAIGE.H:1479` | am Quelltext |
