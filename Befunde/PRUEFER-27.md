# PRÜFER-27 — E-118 Content-Type beim IMAP-Hochladen (`7deeed67`, `65d066a8`, 7.2.0.89)

Lauf am 14.10.2026. Quellcode unter `Eudora71/` nicht geändert, kein Eudora gestartet.
Stand: Zweig `wt/pruefer`, gemergt mit `origin/e-118_HTML_header` (`65d066a8`).
Zeilennummern beziehen sich auf diesen Stand.

**Selbst gemessen:** `E118Gleich`, `E118Huelle`, `E118Achtbit` (`EuImap/src/ImapAppend.cpp:666-729`,
wörtlich herausgeschnitten) in einem eigenen Prüfprogramm im Scratchpad, gebaut mit `cl`, sechs
Rümpfe abgespielt (Ergebnisse in 2). Das Protokoll des Prüfservers aus MESSSTANDs Lauf
(`C:\Temp\E118`, APPEND-Zeilen) gelesen (4).
**Nicht selbst gemessen:** Testsuite 207/207 und die Läufe 7.2.0.89/7.2.0.88 — aus
[E-118](../Intern/BEFUNDE.md#e-118) und den Commit-Nachrichten übernommen.
`perl tools/wer-baut.pl`: `ImapAppend.cpp` wird von `EuImap.vcxproj` gebaut.

**Urteil: auslieferbar, nein — nicht in dieser Form.** Für den gemessenen Fall (einteilige
HTML-Mail, Hülle umschließt den ganzen Rumpf) ist die Behebung richtig und pufferfest. Aber
`E118Huelle` schneidet **alles hinter dem letzten `</x-html>` ab** (F1). Was dort steht, geht
beim Verschieben verloren, und die lokale Kopie wird danach gelöscht: ein angehängter
`text/plain`-Teil (Fußzeile von Mailinglisten) und — im einteiligen Weg — die Zeile
`Attachment Converted:` eines Anhangs, dessen Datei fehlt. Vorher kam beides als Text an. Das ist
eine neue Datenverlust-Richtung; genau dieser Fehler wurde in [E-101](../Intern/BEFUNDE.md#e-101) schon
einmal gefunden und abgestellt ([P-19](PRUEFER-13.md#p-19), `Eudora/msgutils.cpp:4097-4130`). Die Abhilfe ist klein
(2), danach ja.

---

## 1. Grenzen und Längen

| Stelle | nachgerechnet | Ergebnis |
|---|---|---|
| `E118Huelle` Anfang (`ImapAppend.cpp:686-691`) | `a` läuft nur bei `a < e`; Vergleich mit 8 Bytes erst nach `e - a < 8`-Prüfung | sicher |
| CR/LF hinter `<x-html>` (`:693-697`) | nach `a += 8` gilt `a ≤ e`; jedes Weiterzählen mit `a < e` geschützt | sicher |
| Suche nach `</x-html>` (`:701-705`) | `k` von `e - 9` abwärts bis `a`, gelesen `p[k..k+8]`, `k + 8 ≤ e - 1` | sicher; bei `e - 9 < a` keine Runde, `k < a`, `e` bleibt — fehlendes Ende = Rest ist Inhalt |
| `*pnEnde ≥ *pnAnfang` | `e` ist `nLaenge` oder ein `k ≥ a` | immer; damit `nEnde - nAnfang ≥ 0` |
| `ReformatBody` einteilig (`:1208-1214`) | `len` ist `size_t`, bekommt `(long) strlen` hin und `nEnde - nAnfang` (≥ 0) zurück | kein Vorzeichenproblem; Rümpfe ≥ 2 GB gibt es nicht |
| Rumpf nur Hülle (`<x-html>\r\n</x-html>\r\n`) | gemessen: `html=1`, Inhalt 0 Byte; `len > 0` (`:1216`) verhindert `p[len - 1]` | sicher, Kopf `text/html`, leerer Rumpf |
| `p[len - 1]` (`:1221`) | nur bei `len > 0` | sicher. Die Bedingung vergleicht zweimal mit `'\n'` — Originaltippfehler, harmlos |
| `AddTextBodyPart` (`:1287-1294`) | `p` und `len` werden **nach** der Leerprüfung (`:1274-1285`) verschoben; die Schleife `:1327-1400` arbeitet nur mit dem lokalen `p`, `q = p` und dem neuen `len` | stimmt. Alle `Write(p, q - p)` bleiben im Bereich; der Fall „letztes Zeichen `\r`“ (`:1360-1369`) schreibt bis `q`, das hinter den Bereich zeigt, aber nur `q - p ≤ len` Bytes |
| Teil nur aus Hülle mehrteilig | Leerprüfung sieht noch `<x-html>` → nicht leer; danach `len = 0` → Grenze, Kopf, Leerzeile, kein Text | gültiges MIME (leerer Teil), harmlos |

## 2. Was hinter `</x-html>` steht

### F1 — Text hinter dem letzten `</x-html>` geht verloren (Datenverlust)

`E118Huelle` setzt das Ende auf das **letzte** `</x-html>` (`:700-705`) und gibt nur
`[a, e)` weiter; `ReformatBody` (`:1213-1218`) und `AddTextBodyPart` (`:1293-1294`) schreiben
nur diesen Bereich. Alles dahinter fällt weg, ohne Prüfung, ob es Leerraum ist.

Gemessen am herausgeschnittenen Code:

| Rumpf | html | Eingang | weitergegeben | verloren |
|---|---|---|---|---|
| `<x-html>…</x-html>` + `-- \r\nListe: abmelden …` | 1 | 72 | 14 | **58** (Fußzeile ganz weg) |
| `<x-html>…</x-html>` + `Attachment Converted: "…rechnung.pdf"` | 1 | 76 | 14 | **62** (Anhangszeile weg) |
| `<x-html>A</x-html>` + `mitte` + `<x-html>C</x-html>` | 1 | 55 | 34 | 21 (nur Hülle; `mitte` wird als HTML gesetzt, innere Marken bleiben) |
| `Vorspann` + `<x-html>…</x-html>` | 0 | 41 | 41 | 0 (wie vorher: `text/plain` samt Marken) |

**Dass solche Rümpfe lokal entstehen, am Quelltext:** `TextReader::ReadIt` setzt die Hülle **je
Textteil** — `<x-html>` am Anfang (`Eudora/TextReader.cpp:112-133`), `</x-html>` am Ende
(`:398-403`). Ein folgender `text/plain`-Teil (Mailinglisten hängen ihre Fußzeile so an eine
HTML-Mail) steht danach ohne Hülle. `Attachment Converted:`-Zeilen schreibt `WriteAttachNote`
(`Eudora/mime.cpp:426-456`) ebenfalls hinter das `</x-html>` des Textteils.

**Warum die Anhangszeile im einteiligen Weg landet:** `ReformatBody` macht die Nachricht nur dann
mehrteilig, wenn die Anhangsdatei gefunden wird (`ImapAppend.cpp:1152-1159`). Fehlt sie
(Anhangsordner verschoben, Datei gelöscht), bleibt die Zeile im Text — und wird seit 7.2.0.89
abgeschnitten. Vorher stand sie als Hinweis auf dem Server.

**Schwere:** nach dem Verschieben ist die lokale Kopie weg ([E-118](../Intern/BEFUNDE.md#e-118)
„Vorgeschichte“). Was hier abgeschnitten wird, ist damit nirgends mehr.

**Abhilfe (Vorschlag):** wie [P-19](PRUEFER-13.md#p-19) in [E-101](../Intern/BEFUNDE.md#e-101) (`Eudora/msgutils.cpp:4097-4130`): `</x-html>` nur als
Ende nehmen, wenn dahinter nichts als Leerraum steht; sonst `e = nLaenge` lassen (Marken bleiben
sichtbar, aber nichts geht verloren). Besser noch: den Bereich hinter dem Ende als eigenen
`text/plain`-Teil schreiben — das verlangt aber `multipart/mixed` im einteiligen Weg und ist
größer. Test: die beiden ersten Zeilen der Tabelle als Gegenrichtung in `Tests/TestE118.cpp`.

**Werkzeug vor Eigenbau:** `E101SpeicherfassungAufbereiten` (`Eudora/msgutils.cpp:3893`) löst
dieselbe Aufgabe für „Speichern unter“ und trägt die Lehren [P-18](PRUEFER-13.md#p-18), [P-19](PRUEFER-13.md#p-19) und [P-28](PRUEFER-14.md#p-28) als Kommentar.
`E118Huelle` ist eine Neuerfindung, die [P-19](PRUEFER-13.md#p-19) wieder verliert.

### F2 — mehrteilig: Hülle über eine Anhangszeile hinweg (selten, Gegenvermutung)

Für empfangene Post steht jede `Attachment Converted:`-Zeile außerhalb der Hülle (F1, Beleg
oben), jeder Teil bringt sein `<x-html>`/`</x-html>` mit. **Ausnahme, nicht gemessen:**
uuencode/BinHex **innerhalb** eines Textteils wird in `TextReader.cpp:259-262` dekodiert, also
zwischen `<x-html>` und `</x-html>`. Ist der Teil HTML, zerfällt er an der Anhangszeile in zwei
`AddTextBodyPart`-Aufrufe: der erste hat kein Ende (`:705` greift nicht, Rest ist HTML — richtig),
der zweite beginnt nicht mit `<x-html>` → `text/plain` mit einem sichtbaren `</x-html>`.
Kein Verlust, nur Schönheitsfehler; uuencode in HTML ist selten.

### Geprüft und unbedenklich

* **Selbst verfasste/weitergeleitete Mails (Gregors OUTBOX-Fall):** in `Out.mbx` steht dieselbe
  Hülle am Rumpfanfang — gemessen an Gregors Datei in [E-101](../Intern/BEFUNDE.md#e-101) (`Eudora/msgutils.cpp:3846-3855`:
  vier Kopfzeilen, Leerzeile, `<x-html>`, HTML). `etf2html.cpp:200` schreibt `<x-html>` ohne
  Zeilenende — `E118Huelle` überspringt CR/LF nur, wenn sie da sind (`:693-697`), also auch richtig.
  Die Behebung greift dort. `AppendMessageFromLocal` liest den Text über `GetFullMessage`
  (`ImapMailbox.cpp:4243`) — dieselbe Quelle wie [E-101](../Intern/BEFUNDE.md#e-101).
* **`<x-html content-base=…>`:** gemessen `html=0`, Rumpf unverändert. TextReader schreibt die
  Form nicht mehr (`TextReader.cpp:117-121` auskommentiert), sehr alte Postfächer könnten sie
  tragen. Ergebnis wie vor 7.2.0.89 (`text/plain` mit Marken), keine Verschlechterung.
* **Text, der `<x-html>` nur zitiert:** bleibt Text (Test 3 in `Tests/TestE118.cpp`), weil nur der
  Rumpfanfang zählt.

## 3. Andere Hüllen

`TextReader.cpp:107-111`/`:392-397` schreibt `<x-rich>` für `text/enriched` und `text/richtext`,
`:137-144`/`:404-409` `<x-flowed>` für `text/plain; format=flowed`. `E118Huelle` kennt nur
`<x-html>` (`:691`). Beide anderen gehen weiter als `text/plain` mit sichtbaren Marken hoch —
**wie vor 7.2.0.89, keine Verschlechterung**, jetzt aber ausdrücklich so beschriftet.

### F3 — `<x-flowed>` erscheint auf dem Server als Text (Originalfehler, häufig)

`format=flowed` ist bei Thunderbird die Voreinstellung; jede so empfangene Klartextmail zeigt nach
dem Verschieben `<x-flowed>`/`</x-flowed>` als erste und letzte Zeile. Abhilfe analog: Hülle
abstreifen, `; format=flowed` an den `Content-Type` hängen (Vorlage `sendmail.cpp:804-807`).
`<x-rich>` entsprechend mit `text/enriched` (`AppendContentType`, `ImapAppend.cpp:1989-1990`).
Nicht gemessen; eigener Befund, kein Sperrgrund für [E-118](../Intern/BEFUNDE.md#e-118).

## 4. Zeichensatz

* **Annahme „lokal steht Windows-1252“:** für UTF-8-Post richtig. `TextReader` übersetzt jeden
  Zeichensatz mit Index > 2 (`TextReader.cpp:265-301`), UTF-8 über `MultiByteToWideChar` →
  `WideCharToMultiByte(CP1252)` (`Eudora/utils.cpp:1482-1514`); was 1252 nicht kennt, wird
  Ersatzzeichen oder `?` — schon **beim Empfang**, nicht beim Hochladen. Die Kennzeichnung
  `windows-1252`/`iso-8859-1` stimmt damit für das, was lokal liegt.
* **Gegenvermutung G1 — `windows-1250/1251/…`:** `FindMIMECharset` gibt für **jedes**
  `windows-*` den Index 0 (`Eudora/mime.cpp:387-391`), `TextReader` übersetzt dann nicht
  (`:267`). Eine kyrillische `windows-1251`-Mail liegt lokal roh und wird jetzt als
  `iso-8859-1`/`windows-1252` hochgeladen — falsch beschriftet. Vorher `us-ascii` (gar keine
  Angabe), also nicht schlechter, nur anders falsch. Nicht gemessen.
* **Gegenvermutung G2 — `<meta charset=utf-8>` im HTML:** der Rumpf ist nach der Übersetzung
  1252, der `<meta>`-Kopf im HTML sagt weiter `utf-8`. Nach HTML-Regel gewinnt der
  Transport-Kopf (`Content-Type`); ob jeder Mailleser das tut, ist nicht gemessen. Vorher gab es
  keinen Transport-Zeichensatz, der `<meta>` galt — für solche Mails könnte die Anzeige in einem
  Leser, der `<meta>` vorzieht, gleich bleiben, in einem, der den Kopf nimmt, richtig werden.
* **`SendCharset` im INI:** `NameCharset` nimmt ihn auch bei `nAchtbit == 0`
  (`Eudora/sendmail.cpp:749-754`) — wie beim Senden. `Replace` (`ImapAppend.cpp:747`) vergleicht
  groß/klein-genau: steht `SendCharset=ISO-8859-1` im INI, bleibt ein Euro-Text als
  `ISO-8859-1` beschriftet. Randfall.

## 5. 8bit im APPEND

Der Rumpf wurde schon **vor** 7.2.0.89 roh geschrieben (`BodyFileWriter.Write(p, len)`,
`ImapAppend.cpp:1218`, unverändert aus dem Original; mehrteilig `:1330-1400`), die Kopfzeilen roh
übernommen (`ReformatHeader`). Bytes über 0x7F gingen also schon immer im Literal hinaus;
RFC 3501 erlaubt im Literal jedes Byte außer NUL. 7.2.0.89 ergänzt nur die **Angabe**
`Content-Transfer-Encoding: 8bit`. Nichts ist schlechter geworden.

**Gegenvermutung G3:** RFC 2045 begrenzt auch `8bit` auf 998 Byte je Zeile; empfangene HTML-Teile
haben oft sehr lange Zeilen (nach QP-Dekodierung). Das galt vorher (implizit `7bit`) genauso —
kein neuer Verstoß. Ein Server, der das prüft, ist mir nicht bekannt; nicht gemessen.

## 6. `AppendMessageAcrossRemotes` (Server zu Server)

Nicht betroffen. `CImapAppend::AppendMessageAcrossRemotes` (`ImapAppend.cpp:1472-1531`) reicht
den Rohtext der Quelle über `StreamAppendDriver` durch; `ReformatMessage`/`ReformatBody` laufen
dort nicht (nur über `SpoolMessageToFile`, `:645`, aus `AppendMessage`, `:524`).

## 7. Gegenvermutung MESSSTAND — Eingangsdatum beim APPEND zwei Stunden zu früh

**Bestätigt als echter Fehler (Originalfehler, nicht behoben).**

**Gemessen:** Prüfnachricht `Date: Wed, 14 Oct 2026 09:10:00 +0200`
(`Testdaten/e118-html-in-imap-ordner.eml`), Prüfserverprotokoll in `C:\Temp\E118`:

    APPEND Ablage () "14-Oct-2026 07:10:00 +0200" {501}

Richtig wäre `09:10:00 +0200` (= 07:10 UTC). Gesendet wurde 05:10 UTC.

**Nachgerechnet:**

1. `GetTimeMT` liest die Uhrzeit des `Date:`-Kopfes und gibt sie an `mktime`
   (`QCUtils/src/services.cpp:2264-2265`) — als **Ortszeit** des Rechners: 09:10 MESZ → 07:10 UTC.
2. `FormatDateMT` zieht davon noch einmal die Zone des Absenders ab
   (`services.cpp:2069-2076`): 07:10 − 2 h = **05:10**. Das ist `CSummary::m_Seconds`.
   Eudora rechnet damit intern folgerichtig: `ComposeDateMT` addiert die Zone wieder
   (`services.cpp:2094`) und formatiert über `CTime` in Ortszeit (`:2096-2126`) → 09:10.
   `m_Seconds` ist also **nicht** UTC, sondern UTC minus Ortsabweichung des Rechners.
3. `AppendMessageFromLocal` reicht `pSum->m_Seconds` unverändert weiter
   (`EuImap/src/ImapMailbox.cpp:4281`, der Zonenanteil `+ 60*pSum->m_TimeZoneMinutes` ist
   auskommentiert) über `CImapStream::AppendMessage` (`Imapdll/src/ImapStream.cpp:1909-1913`) an
   `append_date` → `do_date` (`Imapdll/src/osdep.cpp:159-194`). `do_date` erwartet ein echtes
   `time_t` (UTC) und schreibt `localtime` samt Ortsabweichung: 05:10 UTC → `07:10:00 +0200`.
4. `ImapDownload.cpp:538` rechnet in der Gegenrichtung `m_Seconds + 60*m_TimeZoneMinutes` — das
   ergibt dort den Wert von `GetTime` ohne Zonenabzug, wie `CImapSum` ihn auch an
   `ImapDownload.cpp:2296` und `:6123` führt. Die Stelle ist in sich richtig; sie belegt nur,
   dass die beiden Zählweisen verschieden sind.

**Die auskommentierte Korrektur wäre nur halb richtig:** `m_Seconds + 60*m_TimeZoneMinutes`
= `mktime(Uhrzeit des Absenders)` ist nur dann UTC, wenn Absender und Rechner in derselben Zone
liegen. Richtig ist `m_Seconds + Ortsabweichung des Rechners zu diesem Zeitpunkt` (Sommer-/
Winterzeit des **Nachrichtendatums**, nicht von heute). Ein Absender mit `+0000` um 09:10 ergibt
`m_Seconds` = 07:10 − 0 = 07:10; mit der auskommentierten Zeile ebenfalls 07:10 — wahr wäre 09:10 UTC.

**Wirkung:** Mailprogramme, die nach Eingangsdatum (IMAP `INTERNALDATE`) sortieren oder es
anzeigen, zeigen jede aus Eudora hochgeladene Nachricht um die eigene Zonenabweichung zu früh
(Sommer 2 h, Winter 1 h). Der `Date:`-Kopf selbst bleibt richtig.

**Nicht nachgerechnet:** ob `m_Seconds` für **selbst verfasste** Nachrichten derselben Zählweise
folgt — `SetDate` setzt dort `time(0)` (`Eudora/summary.cpp:2884-2888`), also echtes UTC; dann
wäre das APPEND-Datum dort richtig, und eine Behebung müsste die beiden Fälle trennen.
`befund-suchen.pl ImapMailbox.cpp:4281`: kein Befund. Eigener Eintrag berechtigt.

## 8. Nebenfunde

### F4 — `befund-suchen.pl` sieht E-118 nicht

`perl tools/befund-suchen.pl ImapAppend` meldet „Kein bestehender Befund nennt diesen Ort. Ein
neuer Eintrag ist berechtigt.“ — obwohl [E-118](../Intern/BEFUNDE.md#e-118) `ImapAppend.cpp` sechsmal mit
Zeilen nennt. Ursache: das Werkzeug zerlegt nur in `##`/`###`-Abschnitte und lässt die
Übersichtstabelle bewusst aus (`tools/befund-suchen.pl:86-99`, Begründung: „sie tragen das Urteil,
aber nicht die Fundstellen“). [E-118](../Intern/BEFUNDE.md#e-118) steht **nur** als Tabellenzeile (`BEFUNDE.md:285`), mit allen
Fundstellen darin. Gezählt: 118 `E-`-Tabellenzeilen, 25 `E-`-Abschnitte. Die Schranke aus
`CLAUDE.md` §2 ist für den Großteil der `E-`-Befunde blind — genau der E-85-Fall, gegen den sie
gebaut wurde. Abhilfe: Tabellenzeilen als eigene Treffer mitnehmen.

### F5 — mehrteilig: neue Grenze je Textteil (Originalfehler, Gegenvermutung)

`AddTextBodyPart` ruft `NewMimeBoundary` **bei jedem Aufruf** (`ImapAppend.cpp:1304`, außerhalb
des `if (!m_bIsMultipart)` `:1297-1301`); `ReformatAttachment` nur beim ersten
(`:1430-1436`). Die Grenze ist `time(0)` (`:1615`, `EudoraRes.rc:9572`). Steht nicht-leerer Text
**nach** einem Anhang (Fußzeilenteil, Apple-Mail-Bild zwischen zwei Absätzen) und dauert das
Kodieren des Anhangs über eine Sekundengrenze, bekommt der zweite Textteil eine neue Grenze; der
Kopf (`:820`) und der Abschluss (`:1231`) nehmen die letzte. Alles davor — erster Text und Anhang —
steht dann in der Präambel und ist für jeden Leser unsichtbar. Nicht gemessen; nicht durch [E-118](../Intern/BEFUNDE.md#e-118)
entstanden, aber in derselben Funktion.

## 9. Tests

`Tests/TestE118.cpp` deckt Hüllenerkennung, Schreibweisen, Gegenrichtung (Text ohne Hülle) und
die beiden Achtbit-Arten ab. **Es fehlt die Gegenrichtung zu F1**: Text hinter `</x-html>`. Mit
dem jetzigen Code wäre ein solcher Test rot. In Test 4 steht die Prüfung „Umlaut allein: Art 1“
doppelt (gleiche Eingabe wie zwei Zeilen davor) — harmlos.

## Zusammenfassung

| Nr. | Art | Fundstelle | Gewicht |
|---|---|---|---|
| F1 | Text hinter dem letzten `</x-html>` fällt beim Hochladen weg | `ImapAppend.cpp:700-705`, `:1213-1218`, `:1293-1294` | **Datenverlust, neu in 7.2.0.89 — vor Auslieferung beheben** |
| F2 | uuencode in HTML-Teil lässt `</x-html>` sichtbar | `TextReader.cpp:259-262` | Schönheitsfehler, selten |
| F3 | `<x-flowed>`/`<x-rich>` bleiben als Text | `ImapAppend.cpp:691` | Originalfehler, häufig, eigener Befund |
| G1 | `windows-125x` außer 1252 falsch beschriftet | `mime.cpp:387-391` | nicht schlechter als vorher |
| G2 | `<meta charset>` widerspricht dem neuen Kopf | — | nicht gemessen |
| G3 | Zeilen > 998 Byte trotz `8bit` | — | nicht schlechter als vorher |
| MESSSTAND | APPEND-Datum um die Ortsabweichung zu früh | `ImapMailbox.cpp:4281` ↔ `services.cpp:2265/2076`, `osdep.cpp:168-194` | **bestätigt**, gemessen und nachgerechnet; eigener Befund |
| F4 | `befund-suchen.pl` übergeht Tabellenzeilen | `tools/befund-suchen.pl:86-99` | Schranke blind für [E-118](../Intern/BEFUNDE.md#e-118) |
| F5 | neue MIME-Grenze je Textteil | `ImapAppend.cpp:1304` | Originalfehler, Gegenvermutung |
