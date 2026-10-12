# PRÜFER-20 — `123b218` nachgerechnet (`GetMaps`, `SetExtension`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Nachgang:** Befund 1 (`uudecode.cpp:88`) und der neu erreichbare Teil von Befund 2 (`hexbin.cpp:312`, `ImHexbin.cpp:374`) sind in `c8064b4` (7.2.0.83) behoben — `SetExtension` bekommt die Puffergröße. **Offen:** `hexbin.cpp:276`/`ImHexbin.cpp:333` (Name ohne Grenze, schon vorher erreichbar) und der Versandweg (`.docx` als `application/msword`).


Stand: 12.10.2026, Zweig `an1-endungen`. Nur gelesen; nichts geändert, gebaut
oder gestartet. Zeilennummern beziehen sich auf den Arbeitsbaum (= 123b218).
`befund-suchen.pl`: zu `SetExtension` gibt es AN-1; zu `hexbin.cpp` und
`uudecode.cpp` gibt es noch keinen Befund.

## Ergebnis vorab

* Für sich genommen sind (a) und (b) **richtig**.
* 123b218 bringt aber Code zum Laufen, der vorher **tot** war. Auf
  Windows 10 scheiterte `GetMaps` immer; das habe ich mit `reg query` gemessen:
  12 Schlüssel ohne `/`, z. B. `pkcs10`, `x-pkcs12`, `vnd.ms-pki.seccat`.
  Damit lief hinter `GetMaps` nichts mehr. Jetzt läuft alles, was danach kommt,
  in allen drei `Find`-Varianten und in allen `SetExtension`-Aufrufern. Dabei
  werden **zwei Überläufe aus dem QUALCOMM-Original scharf**, die (b) nicht
  verhindern kann, weil (b) auf `_MAX_PATH` kürzt und nicht auf den Puffer des
  Aufrufers (Befunde 1 und 2).
* Außerdem ändert sich sichtbares Verhalten beim Empfang (Endungen mit vier
  Zeichen werden ersetzt) und beim Versand (Content-Type aus der Tabelle). Siehe
  Beobachtungen 3 und 4.

## (a) GetMaps, Schlüssel ohne Schrägstrich – IN ORDNUNG

* **`delete map` passt zur Anlage.** `map` wird mit `DEBUG_NEW_MFCOBJ_NOTHROW`
  angelegt, also `::new(std::nothrow[, _AFX_CLIENT_BLOCK, file, line])`
  (`QCUtils/public/inc/DebugNewHelpers.h:51/56`). Freigegeben wird genauso wie
  im Destruktor (`delete m_Maps[i]`, `MIMEMap.cpp:49`): `delete` auf ein
  `CObject` mit virtuellem Destruktor. So wird jede Tabellenzeile freigegeben,
  daher passt es.
* **`~MIMEMap` ist unschädlich.** Das Zeilenobjekt hat ein leeres eigenes
  `m_Maps`, die Schleife im Destruktor läuft also null Mal. `map` ist noch
  nicht in `m_Maps` eingetragen (das geschieht erst in Z. 391), deshalb gibt es
  weder ein doppeltes `delete` noch einen hängenden Zeiger.
* **Schlüssel.** `Extension` wird im `continue`-Zweig genau einmal geschlossen
  (Z. 382). Die Zeilen 418–421 werden übersprungen. `ContentTypes` wird wie
  bisher nach der Schleife geschlossen. Vorher blieben bei `return (FALSE)`
  beide Schlüssel offen und `NameOfKey`/`extensionData` gingen verloren. Auch
  das ist jetzt behoben.
* **Schleife.** `index++` steht in der while-Bedingung (Z. 349), `continue`
  geht also mit dem nächsten Index weiter. `bufLength` (65 Zeichen) und
  `sizeofExtension` (32) werden vor dem nächsten `RegEnumKeyEx` und
  `RegQueryValueEx` zurückgesetzt (Z. 380/381).
* **MT_OUT.** Stimmt. Registry-Einträge bekommen `m_MapType = MT_OUT`
  (Z. 409), es sei denn, `EudoraMapType` sagt etwas anderes.
  `Find(MIMEState*)` überspringt MT_OUT (Z. 117), `Find(Creator,Type)` auch
  (Z. 183). Nur `Find(LPCTSTR Extension)` (Versand) benutzt sie, denn es
  überspringt nur MT_IN (Z. 221). Die eigentliche Wirkung von (a) beim Empfang
  ist deshalb: `[Mappings]` aus Eudora.ini/DEudora.ini gilt wieder.
* **Weitere `return (FALSE)` in GetMaps, die eine fertig gelesene Tabelle
  verwerfen** (dieselbe Fehlerart, aber alle selten):
  * Z. 268/269: DEudora.ini ist vorhanden, lässt sich aber nicht öffnen (z. B.
    gesperrt). Eudora.ini ist dann schon gelesen und wird verworfen. Fehlt die
    Datei ganz, wird `DefaultINIPath` geleert (`rs.cpp:1365-1368`); das ist
    harmlos.
  * Z. 290/291 und Z. 356/357: `new` scheitert. Z. 357 verliert dabei
    zusätzlich beide Schlüssel und beide Puffer. Praktisch bedeutungslos.
  * Z. 333/334: nur bei einem echten Lesefehler (`GetLine` meldet EOF als
    `S_FALSE`, `jjfile.cpp:793`). In Ordnung.
* **Am Rand (stummes Abschneiden, kein Verwerfen).** Scheitert
  `RegOpenKeyEx` für einen Unterschlüssel, wird `bufLength` nicht
  zurückgesetzt (das Rücksetzen steht nur im Erfolgsblock, Z. 418). Ist dann
  der nächste Name länger, liefert `RegEnumKeyEx` `ERROR_MORE_DATA` und die
  Schleife endet still. Dasselbe passiert bei einem Typnamen über 64 Zeichen.
  Gemessen auf diesem Rechner: der längste Name hat 37 Zeichen. Die
  Registry-Einträge sind ohnehin MT_OUT. Niedrig, nur notiert.

## (b) SetExtension, neue Kürzung – Rechnung IN ORDNUNG

`m_Suffix[8]` heißt nSuffix ≤ 7. Ohne Kürzung gilt nStamm+nSuffix+2 ≤ 260, also
Ergebnis = nStamm+1+nSuffix ≤ 259. Mit Kürzung ist das Ergebnis genau
260−2+1 = 259. **Höchstens 259 Zeichen + NUL = 260 Byte.**

| Eingabe | Weg | Ergebnis |
|---|---|---|
| 259 Zeichen ohne Punkt, Suffix `pdf` | 259+3+2=264>260 → nStamm=255, `.pdf` | 259 Zeichen |
| 254×A + `.docx`, Suffix `docx` | Endung 4 → ersetzen, nStamm=254, 254+4+2=260 nicht >260 | `254×A.docx`, 259 Zeichen |
| 255×A + `.pdf` | Endung 3 → `return FALSE` vor der Rechnung | unverändert, 259 |
| 259 ohne Punkt, Suffix mit 7 Zeichen | nStamm=251, `.` + 7 | 259 Zeichen |
| 260 Zeichen (mime.cpp:1541 lässt bis 260 zu), Endung mit 4 Zeichen, Suffix 3 | nStamm=255, 255+3+2=260 → ersetzen | 259 |

Zum Vergleich die alte Fassung in denselben Fällen (Win32): `Difference = −k`,
und `while (Difference--)` läuft 2³²−k Mal. Auf einem 32-Bit-Zeiger heißt das
`floater` = Ende **+ k**. Die NUL landete also k Byte **hinter** dem Ende (Fall
2: Index 264 in einem Puffer mit 261 Byte), und `strcat` hängte ungekürzt an
(Fall 1: 264 Zeichen in 261 Byte). Der Kommentar in Z. 459/460 („rückwärts durch
den Speicher") stimmt also im Ergebnis nicht ganz: es war ein Überlauf nach
vorn. Für die Bewertung ändert das nichts. Die neue Fassung beseitigt ihn.

Aufrufer mit Puffern von _MAX_PATH+1: `mime.cpp:1718` fName[261] (vorher mit
`AnhangNameKuerzen(…, 259, …)` begrenzt), `mime.cpp:1576` Filename[261]
(Z. 1541: höchstens 260), `hexbin.cpp:314` m_AltFilename[MAX_PATH+1]. **Alle
drei passen.** Am Rand und schon vorher vorhanden: `hexbin.cpp:96` kopiert
`AltFilename` mit `_tcscpy` ungeprüft. Das hat mit 123b218 nichts zu tun; (b)
kürzt dort eher.

`ImSingle.cpp:196` (attributeName[32]) steht in `#if 0` (Z. 191–198) und wird
**nicht übersetzt**. Kein Befund.

## BEFUNDE

### Befund 1 – MITTEL – `Eudora71/Eudora/uudecode.cpp:88`, m_Name[255]: Überlauf durch 123b218 lebendig

* `IsAbLine` kopiert den Namen aus der `begin`-Zeile mit bis zu 254 Zeichen
  (Z. 79/80). Danach kommt `mm.Find(m_ms)` → `SetExtension(m_Name)`.
  `SetExtension` kürzt erst ab 260 und schreibt bis zu 259+1 Byte. Der Puffer
  hat 255 Byte.
* Überlauf, wenn angehängt wird und L + S ≥ 254 (L = Namenslänge, S = Suffix):
  mit `pdf` ab **L = 251** (1 Byte), bei L = 254 4 Byte. Mit einem
  Suffix von 7 Zeichen (eigene INI) bis zu 5 Byte. Dazu ersetzt ein Name, der
  auf eine Endung mit 4 Zeichen endet, nur bei L = 254 und S ≥ 5.
* Wohin: `m_Name` ist das letzte Glied von `DecodeUU`. Das Objekt liegt **auf
  dem Stapel** (`TextReader.cpp:73 DecodeUU UUDecoder(ms);`), also werden die
  Nachbarvariablen von `TextReader::ReadIt` überschrieben. Der Inhalt ist
  `.pdf\0` bzw. der Suffix. Er ist nicht frei wählbar, wohl aber durch den
  gewählten MIME-Typ.
* Konkrete Eingabe (POP): ein Teil `Content-Type: application/pdf`,
  `Content-Transfer-Encoding: x-uuencode` (mime.cpp, Leser-Auswahl: uuencode
  geht für **jeden** Typ an den TextReader), Rumpf `begin 644 ` + 251×`A`
  (ohne Punkt). `both=pdf,,,application,pdf` steht in DEudora.ini Z. 134,
  also findet `Find(ms)` einen Treffer und hängt `.pdf` an → 255 Zeichen + NUL
  in 255 Byte.
* **Vermutung, nicht gemessen:** die `begin`-Zeile enthält wohl noch CR/LF
  (Z. 74 prüft auf `'\r'`). Dann sieht `strrchr('.')` `pdf\r\n` (5 Zeichen) als
  Endung und hängt **an**. Zwei Folgen: die Schwelle sinkt um 2 (Name ab etwa
  249 Zeichen), und selbst kurze Namen werden zu `x.pdf\r\n.pdf`. Was
  `DeMacifyName32` daraus macht, habe ich nicht geprüft.
* **Neu oder schon da?** Der Fehler steht im Original (QUALCOMM). In diesem
  Projekt war er tot, solange `GetMaps` scheiterte, und **123b218 macht ihn
  lebendig**. (b) ändert daran nichts: in diesem Bereich (L+S+2 ≤ 260) nehmen
  alte und neue Fassung denselben Weg. Für L+S+2 > 260 kann es nicht kommen,
  weil L ≤ 254 und S ≤ 7 höchstens 263 ergeben. Bei 261–263 verhält sich die
  neue Fassung besser (259 statt bis zu 263 Zeichen), bleibt aber zu lang.

### Befund 2 – NIEDRIG – `Eudora71/Eudora/hexbin.cpp:312` und `Eudora71/EuImap/src/ImHexbin.cpp:374`, m_Name[40]

* Aufbau von `m_Name`: [Längenbyte][Name][NUL]. Ergebnis nach
  `SetExtension`: 1 + L + 1 + S + 1 Byte. Ein **neuer** Überlauf entsteht bei
  L + S > 37 und L ≤ 38: mit S = 3 bei **L = 35…38** (1–4 Byte), mit S = 7 ab
  L = 31 (bis zu 8 Byte). Betroffen sind nur Namen ohne Endung von 1–3 Zeichen.
* Wohin: in das eigene Objekt. Bei S = 3 und L = 38 wird `m_LastData`='p',
  `m_State68`='d', `m_B8`='f', `m_RunCount`=0. Das ist der Zustand der
  6→8-Bit-Dekodierung, der Anhang kann also verstümmelt herauskommen. Bei
  S ≥ 5 trifft es auch `m_Run`/`m_Translate`. Speicher außerhalb des Objekts
  wird nicht getroffen.
* Eingabe: BinHex-4.0-Anhang (`application/mac-binhex40` oder BinHex im
  Text), Name 35–38 Zeichen ohne Punkt, Typ/Creator mit einer in/both-Zuordnung
  (z. B. `MSWD`/leer → `doc`, DEudora.ini Z. 120). Der HFS-Name war höchstens
  31 Zeichen lang, die Lage ist also selten.
* **Schon vorher und von 123b218 unabhängig, aber schwerer:**
  `hexbin.cpp:276-278` und `ImHexbin.cpp:333-335` schreiben den Namen **ohne
  jede Grenze** nach `m_Name`, bis ein NUL-Byte kommt. Ab L ≥ 39 läuft das
  über, mit einem Inhalt, den der Angreifer wählt, und ohne Obergrenze. Das
  ist lebendig, egal ob `GetMaps` gelingt. Es ist ein eigener Befund (neu, noch
  nicht in BEFUNDE.md) und schwerer als Befund 2.

## Beobachtungen (kein Fehler in 123b218, aber eine Wirkung, die mitgeprüft werden sollte)

3. **Empfang (POP): Endungen mit 4 Zeichen werden ersetzt.** Die Regel des
   Originals (`MIMEMap.cpp:443`: „0 or 4: replace") greift jetzt. Mit
   DEudora.ini wird `Foto.jpeg` (image/jpeg) zu `Foto.jpg`, `seite.html`
   (text/html) zu `seite.htm`, `bild.tiff` zu `bild.tif`, `film.mpeg` zu
   `film.mpg` (der erste Treffer `mpg` steht vor `mpeg`). Eine `.docx`, die als
   `application/msword` kommt, wird zu `.doc`. Eine richtig ausgezeichnete
   docx ist nicht betroffen: der Untertyp wird auf 31 Zeichen gekappt und
   trifft keine Zeile. iOS schickt Bilder häufig als `.jpeg`. Gregor sollte das
   wissen, sonst hält er es beim Test für einen Fehler. IMAP ruft
   `SetExtension` nicht auf (`ImapDownload.cpp:3728/4119`). **POP und IMAP
   benennen damit dieselbe Anlage verschieden.**
4. **Versand: der Content-Type ändert sich.** `EncodingType`
   (`sendmail.cpp:2182`) bekommt jetzt Treffer: aus der INI und aus der
   Registry (MT_OUT). Bekannte Nicht-Text-Typen gehen sofort als ET_BINARY,
   und der Content-Type kommt aus der Tabelle. `Find(Extension)` vergleicht
   nur 3 Zeichen (`MIMEMap.cpp:223`), deshalb wird `.docx` beim ersten
   `doc`-Eintrag einsortiert (`application/msword`, DEudora.ini Z. 120) und
   `.xlsx` beim ersten `xls`-Eintrag. Das ist Verhalten des Originals, war
   hier aber tot. `ImapAppend.cpp` und `ImapDownload.cpp:3535`
   (`m_bDelete`) sind ebenso betroffen. Laut Commit-Nachricht sind die Tests
   nicht gelaufen. Ein Versand mit `.docx`/`.pdf`/`.txt` sollte vor der
   Auslieferung einmal gemacht werden.
5. `MIMEMap.cpp:108-111` ist jetzt ebenfalls lebendig: `HexToString` liest
   immer 8 Zeichen aus `x-mac-type`/`x-mac-creator`. Bei einem kürzeren Wert
   liest es über das Ende der Zeichenkette hinaus, schreibt aber höchstens 4
   Byte in `m_Type[5]`. Nur lesend, sehr niedrig.

## IN ORDNUNG

* (a) vollständig: `delete map`, Destruktor, Schlüsselverwaltung, Fortgang der
  Schleife, Zurücksetzen von `bufLength`/`sizeofExtension`, MT_OUT-Logik.
* (b) Rechnung: Ergebnis höchstens 259 Zeichen. Alle Aufrufer mit Puffern von
  `_MAX_PATH+1` passen (mime.cpp:1576, :1718, hexbin.cpp:314). Der alte
  Überlauf nach vorn ist beseitigt.
* ImSingle.cpp:196: in `#if 0`, nicht übersetzt.
* `strcpy(m_Mimetype/m_Subtype, hd->contentType/SubType)` (Z. 94/95, jetzt
  lebendig): Quelle und Ziel sind beide 32 Byte groß, das passt.

## Empfehlung

**Vorher beheben: Befund 1 (uudecode.cpp:88).** Kleinster Eingriff:
`SetExtension` eine Puffergröße mitgeben (`SetExtension(LPTSTR, size_t nPuffer)`,
Grenze `min(_MAX_PATH, nPuffer-1)` statt `_MAX_PATH`) und an allen Aufrufern
`sizeof(...)` übergeben. Das erledigt Befund 1 und Befund 2 als eine Klasse.
Den Fall CR/LF im uudecode-Namen dabei einmal messen. Davon getrennt, aber
naheliegend: die Namensschleife in hexbin.cpp:276 und ImHexbin.cpp:333 auf
`sizeof(m_Name)-1` begrenzen (eigener Befund, vorher schon lebendig).
Beobachtungen 3 und 4 gehören in die Prüfanleitung für Gregor (Umbenennung
`.jpeg`→`.jpg`, Versand-Content-Type), und vor dem Paket sollte ein
Versand-Test laufen.
