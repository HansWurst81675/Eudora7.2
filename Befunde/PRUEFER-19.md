# PRÜFER-19 — AN-1 achter Teil (Commit `ca8da5a`, 7.2.0.80)

Lauf am 12.10.2026, nur lesend, Bericht aus dem Notizordner übernommen. **Nachgang:** Abschnitt 5 (GetMaps) ist am Programm bestätigt und in 7.2.0.81 behoben (`123b218`); der Vorzeichenfehler in `SetExtension` ist ebenfalls in `123b218` behoben. Die übrigen „Weiteren Befunde" sind **offen**.


Stand: 12.10.2026, abgeschlossen (Zeilennummern gegen ca8da5a nachgemessen). Nur gelesen, nichts im Repo verändert.
Geprüft am Quellstand `ca8da5a` (HEAD). „gemessen" = am Code/an Dateien/an der
Registry nachgesehen; „vermutet" = Schluss ohne Lauf am Programm.

Bytes der sieben geänderten Quelldateien (gemessen, `git show` vor/nach):
Zeilenenden unverändert gemischt bzw. rein, keine Bytes >127 dazugekommen.
`imapmime.cpp` 506→509 CRLF / 0 nur-LF, `mime.cpp` 18 CRLF / 2307→2316 LF,
`MIMEMap.cpp` 18 / 412→440, Rest rein LF. In Ordnung.

---

## 1. AnhangNameKuerzen (QCUtils/src/rfc2231.cpp:241-271)

Nachgerechnet (gemessen am Code):

| Fall | Eingabe | nMax | Ergebnis | Bewertung |
|---|---|---|---|---|
| Messfall 03 | 300×A + `.pdf` (304) | 259 | 255×A + `.pdf` (259) | richtig |
| danach DeMacify | 255×A+`.pdf` (259) | 255 | 251×A + `.pdf` (255) | richtig |
| nMax 0 | `abc` | 0 | `""` (nEndung>=0 → 0, Stamm 0, pZiel[0]=0) | richtig |
| nMax 0, leer | `""` | 0 | `""` (memmove 1 Byte) | richtig |
| nMax 1 | `ab.c` | 1 | `a` (nEndung 2 >= 1 → 0) | richtig |
| nMax 3 | `abc.d` | 3 | `a.d` | richtig, Stamm >= 1 durch `nEndung >= nMax` |
| Endung 16 Zeichen (inkl. Punkt) | | 255 | Endung bleibt | wie dokumentiert |
| Endung 17 | | 255 | stumpf gekappt | wie dokumentiert |
| Name endet auf `.` | | | nEndung 1 < 2 → stumpf | in Ordnung |
| Punkt am Anfang `.`+300 | | 255 | nEndung 301 → stumpf | in Ordnung |
| `x.tar.gz` lang | | 255 | Stamm + `.gz`, `.tar` geht verloren | hinnehmbar, nur notiert |
| pZiel == pQuelle | | | Stamm-memmove ist Nullbewegung; pPunkt = Quelle+nLaenge-nEndung > Ziel+nMax-nEndung, also liegt die Quelle der Endung hinter dem Ziel - memmove korrekt | richtig |
| Länge <= nMax | | | memmove nLaenge+1, braucht nMax+1 Platz | wie dokumentiert |

Off-by-one: keiner. `pZiel[nMax] = 0` braucht nMax+1 Bytes, wie im Kopf (rfc2231.h:67) verlangt.

Anmerkungen (klein):
* rfc2231.cpp:243: bei `nMax < 0` bleibt `pZiel` unangetastet (kein `*pZiel = 0`). Kein Aufrufer tut das; nur notiert.
* Überlappung pZiel != pQuelle mit pZiel > pQuelle würde die Endung vor dem Kopieren überschreiben. Kein Aufrufer tut das.
* Im POP-Weg (mime.cpp:1701) wird VOR DeMacifyName32 gekürzt, also vor dem Entfernen unzulässiger Zeichen. Bei einem Namen mit vielen `?`/`*` wird mehr gekürzt als nötig, und die „Endung" ist die rohe. Klein.
* Byteweises Kürzen kann eine UTF-8-Folge zerschneiden, falls der Name nach RFC2231ZeichensatzUmsetzen noch UTF-8 ist. War vorher genauso.

## 2. Aufrufstellen und Puffer

**mime.cpp:1665** `char fName[_MAX_PATH + 1]` (261). `AnhangNameKuerzen(fName, _MAX_PATH-1, …)` (1701/1703/1705) schreibt höchstens 259 Zeichen + Null = 260 Bytes. Vorher schrieb strncpy 259 Bytes OHNE Null. Jetzt 1 Byte mehr, passt. `CRString(IDS_UNTITLED)` als Temporärobjekt lebt bis zum Ende des Ausdrucks — in Ordnung. `subj` ist 32 — in Ordnung.

**mime.cpp:1696-1700** filename="" → name=; name="" → AE=NULL → Betreff. Logik richtig. Marke 4 meldet dann „KEIN filename", richtig.

**DeMacifyName32 (mime.cpp:958-986) / LOCAL_DeMacifyName32 (imapmime.cpp:92-120):** Ergebnis ist nie länger als die Eingabe, und vorher wurde ebenfalls an Ort und Stelle (`strcpy(Name, pcname)`) geschrieben. Also wird **nirgends länger geschrieben als vorher**. Einziger Unterschied: die Schleife liest jetzt bis zur Null statt höchstens bis zum 255. übernommenen Zeichen. Das zählt nur bei nicht abgeschlossenen Eingaben — die einzige bekannte war das strncpy in ReadIt, das jetzt abschließt.

Aufrufer (grep im ganzen Eudora71, gemessen):
* DeMacifyName32 nur aus OpenAttachFile (mime.cpp:1350) und OpenEmbeddedFile (mime.cpp:1428).
* OpenAttachFile-Aufrufer: fileutil.cpp:710 (`(LPTSTR)(LPCTSTR)CString` — schreibt in den CString-Puffer, GetLength danach veraltet; **vorher genauso**), hexbin.cpp:316, mime.cpp:601/1582/1745, msgdoc.cpp:1143 (schreibt in ein CRString-Temporärobjekt; vorher genauso), RegInfoReader.cpp:662, TransReader.cpp:186/340, uudecode.cpp:121. Alle vertragen die neue Semantik, weil das Ergebnis nicht länger wird.
* LOCAL_DeMacifyName32 nur aus OpenLocalAttachFile (imapmime.cpp:347). Aufrufer: ImapDownload.cpp:4141 (`tmp[2048]`), ImapMailbox.cpp:6766 (`Name[MAXBUF+4]`, MAXBUF 2048), ImHexbin.cpp:686, ImUudecode.cpp:355. In Ordnung.

**Außerhalb des Diffs, aber auf demselben Weg (gemessen):**
* **mime.cpp:575-597** (Digest-Zweig): `char fName[MAX_PATH]; strcpy(fName, AE->m_Value); strcat(fName, ".mbx");` — ungebremstes Kopieren eines vom Server kommenden Namens auf den Stapel. Ein filename ab 256 Zeichen (Messfall 03 hat 304) läuft über. befund-suchen „mime.cpp:575": kein Befund.
* **MIMEMap.cpp:438-449 SetExtension** — siehe Abschnitt 5, latenter Überlauf, wird erreichbar, sobald Find wieder funktioniert.

## 3. CheckName mit Pfad 35 und Name 255 (gemessen am Code, nachgerechnet)

POP, `CheckName` (mime.cpp:1009ff), Dir `c:\temp\an1\mailverzeichnis\attach` (34) + `\` → nDirLength 35, Name 251×A+`.pdf` (255):
* 1048: bMightNeedToTruncate = 35+255+4 = 294 > 259 → wahr.
* 1060-1096: pDOSReservedExtension = Punkt an 251; Suche von hinten, Grenze 6 → pExtension = `.pdf`, Abbruch wegen bOnlySupportOneExtension.
* 1111: sBaseName = Teil vor dem ERSTEN Punkt = 251×A.
* 1159-1163: 35+251 = 286 > nMaxLengthAllowed = 259-4 = 255.
* 1168-1173: strncpy 255 → 35 Pfad + 220×A, dann `.pdf` → FinalFname 259 Zeichen.
* **Ergebnis: `220×A.pdf`, 224 Zeichen.** Gleiche Länge wie im Fehlerbild, jetzt mit Endung. Bei vorhandener Datei (1252-1265) wird um die Ziffern gekürzt, `220-n×A` + Zahl + `.pdf` — korrekt, passt in FinalFname[261].

IMAP, `LOCAL_CheckName` (imapmime.cpp:124ff), DirName ohne `\` 34, FName 255:
* 154: 34+255 = 289 > 257 → Kürzungszweig. Difference = 32.
* 166-168: FinalFname = 35 + strncat 223 = 258 Zeichen.
* 176: leader = FinalFname + (257 - 4) = 253 → `.pdf` an 253-256, Null an 257.
* **Ergebnis: `218×A.pdf`, 222 Zeichen** (1 Zeichen weniger als nötig, weil der `\` in Difference nicht mitzählt — Original, harmlos).

**Grenzen von CheckName, die AnhangNameKuerzen nicht teilt (GEGENVERMUTUNG/BEFUND klein):**
* CheckName erkennt eine Endung nur bis 5 Zeichen inkl. Punkt (mime.cpp:1072, `nMaxExtensionLimit = 6`, Vergleich `<`). AnhangNameKuerzen behält bis 16. Bei einer Endung mit 6..16 Zeichen (`.torrent`, `.numbers`, `.webarchive`) und Pfad+Name > 259 setzt CheckName pExtension = NULL, nimmt den Teil vor dem ersten Punkt und kappt stumpf. Nachgerechnet 247×A+`.torrent` (255): Basis 247×A, 35+247 = 282 > 259 → `224×A` ohne Endung. Die Endung, die AnhangNameKuerzen gerettet hat, fällt hier doch noch weg.
* Bei bMightNeedToTruncate nimmt CheckName den Teil vor dem ERSTEN Punkt als Basis (mime.cpp:1111). `Rechnung 2026.10.12 <lang>.pdf` wird zu `Rechnung 2026.pdf`. Original-Verhalten, nicht neu, aber es trifft genau lange Namen.
* IMAP LOCAL_CheckName, Schleife bei vorhandener Datei (imapmime.cpp:262-284): `wsprintf(FinalFname, "%s\\%s%d%0.4s", DirName, tmp, …)` mit tmp bis 254 Zeichen → 34+1+251+1+4 = **291 Zeichen in FinalFname[_MAX_PATH+1] (261)**: Stapelüberlauf in OpenLocalAttachFile. Auslöser: denselben langen Anhang ein zweites Mal über IMAP laden. War vor ca8da5a genauso erreichbar (255×A ohne Punkt → tmp 254 → 290). Zusätzlich kürzt `%0.4s` `.docx` auf `.doc`. Nicht neu, aber in AN-1 nicht als Überlauf geführt (BEFUNDE.md nennt LOCAL_CheckName nur zur Kürzung).

## 4. Linkbarkeit (gemessen an Projektdateien)

* QCUtils ist DynamicLibrary (QCUtils.vcxproj:24/29) mit `src\QCUtils.def` (Zeile 76/121). Die .def enthält **keine** Exporte („Explicit exports can go here") — Exporte laufen nur über `__declspec(dllexport)`. Die .def muss nicht ergänzt werden.
* rfc2231.cpp bindet rfc2231.h ein (Zeile 11) → die Definition erbt dllexport.
* Eudora.vcxproj:94/144 linkt QCUtils.lib. EuImap ist StaticLibrary (EuImap.vcxproj:24/31) und wird in Eudora.exe gelinkt; ImapDownload.cpp:74 benutzt RFC2231Zusammensetzen schon (AN-1 fünfter Teil), header.cpp:592/599 ebenso. Gleicher Weg → **in Ordnung (vermutet bis zum Bau; Präzedenzfall belegt)**.
* rfc2231.cpp ist in QCUtils.vcxproj:174 eingetragen. In der alten QCUtils.vcproj nicht geprüft (wird laut Projekt nicht gebaut — falls doch, dort nachsehen).

## 5. MIMEMap::Find scheitert für application/pdf — Gegenvermutungen

Die Test-ini (gemessen, C:\Temp\AN1\Mailverzeichnis\Eudora.ini, Stand 11:12): 6992 Bytes, 341 CRLF, kein nur-LF, keine NUL (also kein UTF-16), keine Zeile über 255 Zeichen, `[Mappings]` in Zeile 48, `both=pdf,,,application,pdf` in Zeile 64.

| Nr | Vermutung | Beleg im Code | Status |
|---|---|---|---|
| V1 | **GetMaps liefert FALSE aus dem Registry-Teil** | MIMEMap.cpp:365-367: `floater = strchr(NameOfKey, '/'); if (!floater) return (FALSE);` — jeder Schlüssel unter `HKCR\Mime\Database\Content Type` OHNE `/`, der einen Wert `Extension` hat, bricht GetMaps mit FALSE ab, NACHDEM [Mappings] schon gelesen ist. | **Registry gemessen** (`reg query`, auch `/reg:32`): 149 Schlüssel, 12 ohne `/` (`pkcs10`, `pkcs7-mime`, `pkcs7-signature`, `pkix-cert`, `pkix-crl`, `vnd.ms-pki.*`, `x-pkcs12`, `x-pkcs7-*`, `x-x509-ca-cert`). Der erste davon, `pkcs10` an Stelle 100, hat `Extension REG_SZ .p10`. Kein Schlüssel ist länger als 64 Zeichen, die Aufzählung (Puffer 65, Zeile 346) bricht also NICHT vorher ab. **Stärkste Vermutung**: trifft jeden Teil, jeden Typ, auf jedem Windows mit diesen Zertifikats-Schlüsseln. Am Programm noch nicht gemessen. |
| V1a | Folge: kein Cache | `MIMEMap mm` ist lokal in ReadIt (mime.cpp:1662), m_Maps ist Mitglied (MIMEMap.h:41). Jeder Teil liest ini + Registry neu und scheitert neu. Zusätzlich Leck je Aufruf: `map` (Zeile 356), NameOfKey/extensionData und beide Registry-Handles werden beim `return FALSE` nicht freigegeben. | gemessen am Code |
| V1b | Vorhersage für Marke 11 | Bei V1 meldet Marke 11 „GetMaps scheitert" mit Zahl **> 0** (ini-Einträge ~120 plus Registry-Einträge bis pkcs10). Zahl 0 hieße: Open(INIPath) oder GetLine gescheitert. | Prüfkriterium |
| V2 | INIPath falsch / Open scheitert | rs.cpp:1372-1411 setzt INIPath aus Kommandozeile oder EudoraDir, mit GetFullPathName. DefaultINIPath wird nur gesetzt, wenn die Datei existiert (rs.cpp:1365-1368). | vermutet unwahrscheinlich; Marke 11 nennt INIPath |
| V3 | GetLine mit buf[256] | jjfile.cpp:811-858: bei Zeile >= 256 Bytes wird **nicht** nullterminiert, TrimWhitespaceMT liest dann über buf hinaus, der Rest kommt als nächste „Zeile". FAILED nur bei Lesefehler (-1). | Test-ini hat keine Zeile > 255 (gemessen) → nicht die Ursache hier; latentes Lesen über den Puffer für andere ini-Dateien |
| V4 | Abschnittsname / Groß-Klein | `IDS_MIME_MAPPINGS` = `"[Mappings]"` (EudoraRes.rc:9569), CompareNoCase nach TrimWhitespaceMT (276-279). | in Ordnung (gemessen) |
| V5 | Parsen der Zeile | 295-323: `both` → weder `in` noch `out` → MT_BOTH aus Init; Suffix `pdf`, Mimetype `application`, Subtype `pdf`. Treffer in 121-125. bestMac bleibt NULL, da Creator/Type leer (131-132 vergleicht `""` mit `MSWD` → kein Treffer). | in Ordnung (gemessen) |
| V6 | isMIME der Teile | mime.cpp:626 setzt `innerHD->isMIME = TRUE` für jeden Unterteil; Kopf: header.cpp:308 aus MIME-Version. Ohne isMIME gäbe es gar keinen Decoder (mime.cpp:117) — die Anhänge wurden aber dekodiert gespeichert. | unwahrscheinlich (gemessen am Code) |
| V7 | contentType-Inhalt | header.cpp:317 übernimmt TrimWhitespaceMT(Token), Vergleich stricmp. Nur falls das Token Anführungszeichen o. ä. enthielte. | unwahrscheinlich, Marke 11 (dritter Ausstieg) zeigt Typ/Untertyp |
| V8 | MIMEMap.cpp:70 `hd = ms->m_hd` vor der Null-Prüfung in 77 | macht `!ms` in 77 wirkungslos | klein, Original |

**Folgerung für das zweite Symptom** (filename="" → Betreff ohne Endung): das ist dieselbe Ursache — SetExtension hätte `.pdf` angehängt, wenn Find gelungen wäre.

**Warnung, bevor V1 behoben wird — BEFUND, schwer:** `SetExtension` (MIMEMap.cpp:438-449):
```
if ((strlen(m_Suffix) + strlen(Filename) + 2) > _MAX_PATH)
{
    int Difference = _MAX_PATH - (strlen(m_Suffix) + strlen(Filename) +2);   // NEGATIV
    ...
    while (Difference--) floater--;
    *floater = 0;
}
```
Das Vorzeichen ist verkehrt: Difference ist in genau diesem Zweig negativ. `while (Difference--)` läuft von -4 bis zum Überlauf auf 0 (~4,29 Mrd. Schritte); auf 32 Bit ist das netto `floater += 4` → `*floater = 0` schreibt 4 Bytes HINTER das Stringende, danach hängt strcat `.`+Suffix an einen 259-Zeichen-Namen → bis 264 Bytes in `fName[261]` (mime.cpp:1665): Stapelüberlauf. Nachgerechnet mit 300×A+`.docx` (Typ application/msword, ini `doc`): AnhangNameKuerzen → 254×A+`.docx` (259); SetExtension: Endung 4 Zeichen → ersetzen; 3+259+2 = 264 > 260 → Difference -4. Ebenso jeder Name > 259 ohne Punkt. **Heute verdeckt, weil Find immer scheitert (V1).** War vorher ebenso angelegt (strncpy 259). Empfehlung: in ReadIt `nMax` so wählen, dass Platz für `.`+Suffix (m_Suffix[8] → bis 7) bleibt, z. B. `_MAX_PATH - 1 - 8`, und/oder Difference umdrehen.

## 6. Marke 2 in lex822.cpp:225-240 / ImapLex822.cpp:240-255

Ablauf (gemessen am Code, lex822.cpp):
* 222-223: LF gefolgt von SP/HT → charClass = SPACE822.
* CollectQText, case CR822 (337-341): CR mit `InStructure && nextClass == LF822` → CR in die Marke, weiter. Sonst → QText beenden.
* case LF822 (346-354): unbeendete Zeichenkette → QText beenden.

Also:
* Gefaltete Zeile (CR LF SP): CR → kein LF822, LF → SPACE822 → **keine Meldung, richtig**. Vorher meldete die CR-Abfrage hier fälschlich.
* Echter Umbruch (CR LF Nicht-WSP): CR wird mitgenommen, LF kommt als LF822 an → **Meldung, richtig**.
* Nackter LF (ohne CR, z. B. LF-Zeilenenden im IMAP-Kopf): LF822 → Meldung, richtig.
* **CR OHNE folgendes LF** (nacktes CR mitten im Wert): case CR822 beendet die Zeichenkette (342-344), LF822 kommt nie → **keine Meldung mehr** (vorher gemeldet). Lücke, Schwere klein (nur Diagnose; nackte CR in Kopfzeilen sind selten). Vorschlag: `(charClass == LF822 || (charClass == CR822 && nextClass != LF822))`.
* Die Escape-Abfrage `Token[TokenSpot] == '\\'` (lex822.cpp:316/326) ist laut BEFUNDE.md:8140 schon als wirkungslos bekannt; sie stört die Marke nicht.
* ImapLex822.cpp:249 ist gleich gebaut (m_State/m_InStructure, case CR822 an 352). Gleiches Urteil.

---

## Liste

### BEFUND
1. **schwer (Ursache des zweiten Symptoms und von Marke 5 „kennt den Typ NICHT")** — MIMEMap.cpp:365-367: GetMaps gibt FALSE zurück bei Registry-Schlüssel ohne `/` mit `Extension`. Registry gemessen: `pkcs10` (Stelle 100, `.p10`) u. a. Am Programm noch zu bestätigen über Marke 11 (Erwartung: „GetMaps scheitert", Zahl > 0). Dazu Leck MIMEMap.cpp:356/346-347 (map, Puffer, zwei HKEY) je Aufruf. befund-suchen „GetMaps": kein Befund.
2. **schwer (latent, wird mit Behebung von 1 erreichbar)** — MIMEMap.cpp:438-449 SetExtension: Difference mit falschem Vorzeichen → Schreiben hinter fName[261] (mime.cpp:1665), weil ReadIt jetzt Namen mit 259 Zeichen liefert (mime.cpp:1701).
3. **schwer (vorbestehend, gleicher Weg)** — imapmime.cpp:278/281 LOCAL_CheckName: wsprintf bis 291 Zeichen in FinalFname[261] (imapmime.cpp:305), sobald ein langer Name schon als Datei existiert.
4. **mittel (vorbestehend)** — mime.cpp:575/583/592/596: Digest-Zweig, `fName[MAX_PATH]` mit ungebremstem strcpy aus AE->m_Value plus strcat `.mbx`.
5. **mittel** — mime.cpp:1072 vs. rfc2231.cpp:259: CheckName kennt Endungen nur bis 5 Zeichen, AnhangNameKuerzen bis 16; bei Pfad+Name > 259 fällt eine 6..16-Zeichen-Endung doch weg (nachgerechnet `224×A` ohne `.torrent`).
6. **klein** — lex822.cpp:234 / ImapLex822.cpp:249: nacktes CR in Anführungszeichen beendet die Zeichenkette ohne Marke.
7. **klein (latent)** — jjfile.cpp:822-858 ReadLine_: Zeile >= Puffergröße wird nicht abgeschlossen; MIMEMap.cpp:274-276 liest dann über buf[256] hinaus.

### GEGENVERMUTUNG
* V2 INIPath (rs.cpp:1372-1411) — unwahrscheinlich, Marke 11 zeigt den Pfad.
* V6 isMIME (mime.cpp:626, header.cpp:308) — unwahrscheinlich, Teile wurden dekodiert.
* V7 contentType mit Fremdzeichen (header.cpp:317) — unwahrscheinlich.
* CheckName nimmt bei langen Namen den Teil vor dem ERSTEN Punkt (mime.cpp:1111) — Original, trifft lange Namen mit Punkten im Stamm.
* IMAP `%0.4s` (imapmime.cpp:278/281) kürzt `.docx` → `.doc` bei Namenskonflikt.

### IN ORDNUNG
* rfc2231.cpp:241-271 AnhangNameKuerzen: alle Grenzfälle nachgerechnet, kein Off-by-one, pZiel==pQuelle korrekt.
* mime.cpp:1665/1701-1705: Puffer reicht (260 von 261 Bytes), Null jetzt immer gesetzt.
* mime.cpp:1696-1700: leeres filename/name richtig behandelt.
* mime.cpp:958-986, imapmime.cpp:92-120: an Ort und Stelle, Ergebnis nie länger als Eingabe; alle Aufrufer (Liste in Abschnitt 2) vertragen es.
* mime.cpp:1009-1290 CheckName mit Pfad 35 / Name 255 → `220×A.pdf` (224 Zeichen), mit Endung. IMAP → `218×A.pdf`.
* Linken: QCUtils.def ohne Exporte, dllexport genügt; Eudora.vcxproj:94/144 hat QCUtils.lib; Präzedenz header.cpp:592, ImapDownload.cpp:74.
* Marke 2 auf LF822 (lex822.cpp:234, ImapLex822.cpp:249): richtig gegen Faltung und echten Umbruch.
* MIMEMap.cpp:77-92/143-154 Marke 11: Signatur von PutDebugLogSichtbar (debug.h:112, lZahl Vorgabe -1) passt.
* Zeilenenden/Bytes aller sieben Quelldateien unverändert in ihrer Art.
