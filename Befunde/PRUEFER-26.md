# PRÜFER-26 — E-105 `display:none` (`f74dd4b1`, `1d010e0f`, 7.2.0.88)

Lauf am 14.10.2026. Quellcode unter `Eudora71/` nicht geändert, kein Eudora gestartet.
Stand: Zweig `wt/pruefer`, gemergt mit `origin/e-105_doppelte_bilder` (`1d010e0f`).

**Selbst gemessen:** `E105Schritt` samt Hilfsfunktionen (`PGHTMIMP.CPP:601-798`, wörtlich
herausgeschnitten) in einem eigenen Prüfprogramm im Scratchpad, gebaut mit `cl /fsanitize=address`,
15 Tagfolgen abgespielt (Ergebnisse unten in 2). AddressSanitizer meldet nichts.
**Nicht selbst gemessen:** Testsuite 202/202 und die Läufe in `C:\Temp\E105`/`E105-1087` —
aus den Commit-Nachrichten und [E-105](../Intern/BEFUNDE.md#e-105) übernommen.

**Urteil: auslieferbar, ja.** Die Behebung trifft Gregors gemessene Fälle (Vorschauzeile,
Handyfassung als `<table … display:none>`), ist pufferfest und auf die gebaute Quelle gesetzt.
Sie hat aber eine **Fehlalarm-Richtung**, die der Kommentar selbst als Gefahr nennt und nur für
`<p>` abfängt: ein verstecktes Element, dessen Ende-Tag fehlt — in HTML erlaubt bei
`<td>`, `<th>`, `<tr>`, `<li>` — verschluckt den **ganzen Rest des HTML-Teils** bis `</body>` (F1).
Das ist kein Datenverlust im Postfach, aber sichtbarer Inhalt verschwindet und fehlt auch im
Zitat beim Antworten/Weiterleiten. Kein Fall in Gregors Post belegt; Newsletter-Generatoren
schließen ihre Zellen. Deshalb kein Sperrgrund, aber Test und Schutz empfohlen.

---

## 1. Puffergrenzen

| Stelle | nachgerechnet | Ergebnis |
|---|---|---|
| `szName[16]` (`PGHTMIMP.CPP:692`) | geschrieben nur bei `nName < 15` (`:708-709`), danach `szName[nName] = 0` mit `nName ≤ 15` (`:713`) | sicher |
| `strcpy(szTag, szName)` (`:790`) | nur bei `!bLang`, also ≤ 15 Zeichen + NUL; Ziel `e105_tag[16]` (`PGTXRCPP.H:396`) | sicher |
| `strcpy(e105_tag_vorher, e105_tag)` (`:2774`) und zurück (`:2840`) | `e105_tag` ab dem Konstruktor NUL-terminiert (`:107`), sonst nur über `:790` beschrieben | sicher |
| `attribute_ptr` nullterminiert? | `InsertTokenChar` schreibt nach **jedem** Zeichen eine 0 dahinter (`:3630`) und vergrößert vorher (`:3622-3628`, Zeiger neu geholt); `ReadHTMLTag` hängt zusätzlich `'\0'` an (`:917`) | ja, jede Schleife in `E105Schritt` hält an `*p == 0` (`:703`, `:725`, `:732`, `:738`) |
| `E105DisplayNone` (`:628-681`) | Schleife `i + 7 <= nWert` liest `[i..i+6]`; `k` vor jedem Zugriff gegen `nWert` geprüft (`:657`, `:659`, `:662`); `w[0..3]` nur bei `k + 4 <= nWert` (`:664`); `n` nur bei `k + 4 < nWert` (`:675`) | sicher, kein Lesen hinter `nWert` |
| Aufruf mit `pTok + 1, nTok - 2` (`:744`) | nur wenn `nTok >= 2` und erstes = letztes Zeichen ein Anführungszeichen | sicher; offenes Anführungszeichen geht über `:746` mit voller Länge |
| `szSpur[96]` (`:924`) | längster Text „[E-105](../Intern/BEFUNDE.md#e-105) versteckter Bereich <%s> ohne Ende-Tag beendet“ = 52 + 15 | sicher |
| `pg_char` → `const char*` (`:926`) | Eudora baut ohne `UNICODE`, `pg_char` ist `unsigned char` (`PaigeDLL/PGHEADER/CPUDEFS.H:647`) | richtig; Bytes > 127 werden negativ, alle Vergleiche sind auf `'A'..'Z'`/ASCII, unschädlich |

Mit AddressSanitizer an 15 Folgen gefahren, darunter offenes Anführungszeichen,
`style =` am Pufferende, leerer Wert, 21 Zeichen langer Tagname: keine Meldung.

## 2. Fehlalarm — kann ein verstecktes Element echten Inhalt verschlucken?

Gemessen am herausgeschnittenen Original (`[-]` = verschluckt):

| Folge | durchgelassen | Tiefe am Ende |
|---|---|---|
| `<table><tr><td style=display:none>x<td>…</tr><tr><td></td></tr></table><p></p>` | `table tr` und **sonst nichts** | 2 (`td`) |
| `<ul><li style=display:none><li><li></ul><p>` | `ul` | 3 (`li`) |
| `<table><tr style=display:none><td></td><tr><td></td></table><p>` | `table` | 2 (`tr`) |
| `<td><div style=display:none></td><td></td></tr></table><p></body>` (vergessenes `</div>`) | `table tr td` … erst wieder `/body` | 0 |
| `<td><p style=display:none><td></td>` | `td`, `/td` — **das `<td>` der zweiten Zelle ist verschluckt**, ihr `</td>` nicht | 0 |
| `<DIV style=display:none><Div></div></DIV><p>` | `p` | 0 — Groß/klein richtig |
| `<div style="x" style="display:none"></div><p>` | `p` | 0 |
| `<div style="display:none" /><p></div>` | `p /div` | 0 |
| `<div style="display:\r\nnone">` | alles | 0 |

### F1 — implizite Enden fehlen außer bei `<p>` (Fehlalarm, Rest der Mail unsichtbar)

`E105Schritt` beendet einen Bereich nur über das gleichnamige Ende-Tag (`:775-777`), über
`</body>`/`</html>` (`:763-766`) oder — nur wenn `szTag == "p"` — über ein Blockelement
bzw. ein Container-Ende (`:768-771`). HTML erlaubt das Weglassen von `</td>`, `</th>`,
`</tr>`, `</li>` (auch `</dt>`, `</dd>`, `</option>`); der Browser schließt sie am nächsten
Geschwister. Hier zählt das nächste gleichnamige Start-Tag **hoch** (`:779-780`), die Tiefe
wächst, und alles bis `</body>` verschwindet (Tabelle oben, Zeilen 1–3). Ebenso ein
vergessenes `</div>`/`</span>` innerhalb einer Zelle: der Browser schließt es mit `</td>`,
hier verschwinden das sichtbare `</td>`, die Folgezellen, `</table>` und alles danach (Zeile 4).
Fehlt `</body>` im HTML-Teil, reicht der Schaden bis zum Ende des Teils; über den Teil hinaus
nicht, weil jeder Import ein neues Filterobjekt bekommt (siehe 4).

Folgen über den Bildschirm hinaus: der Tabellen-Vorlauf liest dann ebenfalls bis zum Ende
(`</table>` verschluckt, `ProcessPreTable`, Schleife ab `:2792`, endet erst an EOF) — gleiche Lage wie
eine nie geschlossene Tabelle, kein neuer Absturzweg erkennbar. Beim Antworten/Weiterleiten fehlt
der Inhalt im Zitat.

**Testfall (nicht gebaut):** in `TestE105.cpp` eine Folge
`"table ", "tr ", "td style = \"display:none\" ", "td ", "/td ", "/tr ", "/table ", "p ", 0`
→ erwartet mindestens `…|/table|p`, Tiefe 0. Zweite Folge mit `li`. Beide sind mit dem
heutigen Stand rot (gemessen, s. o.). **Schutzvorschlag:** wie beim `<p>` für
`szTag ∈ {td, th}` ein `<td>`/`<th>`/`<tr>`/`</tr>`/`</table>`, für `tr` ein `<tr>`/`</table>`,
für `li` ein `<li>`/`</ul>`/`</ol>` als Ende werten — aber nur bei Tiefe 1, damit
verschachtelte Tabellen im versteckten Bereich nicht vorzeitig enden.

### F2 — verstecktes `<p>` schluckt das Start-Tag der nächsten Zelle

`aBlock` (`:688-689`) enthält `td`, `th`, `tr`, `li` nicht. `<td><p style=display:none>…<td>y</td>`:
das zweite `<td>` wird verschluckt, `y` ebenso, erst `</td>` beendet den Bereich (Zeile 5).
Die Tabelle bekommt ein `</td>` ohne `<td>`; Vorlauf und Hauptlauf zählen gleich (beide über
`ReadHTMLTag`), die Spaltenzahl bleibt also stimmig, aber die Zelle fehlt. Selten (setzt `<td>`
ohne `</td>` voraus). **Testfall:** `"td ", "p style = \"display:none\" ", "td ", "/td ", 0` →
erwartet `td|td|/td`.

### Geprüft und unbedenklich

* **Groß-/Kleinschreibung** von Tagname, `style`, `display`, `none`: überall gesenkt
  (`:706-707`, `:610-611`, `:646-647`, `:668-669`). Gemessen (Zeile 6).
* **Tagnamen > 15 Zeichen:** `bLang` — das Tag selbst wird verschluckt, aber kein Bereich
  geöffnet (`:789`); im Bereich zählen lange Namen nie (`:775`). Richtung „zeigt zu viel“, sicher.
* **`<div … />`** öffnet keinen Bereich (`:757`, `:789`). Ein Browser ignoriert `/` bei `div`
  und versteckt bis `</div>` — Eudora zeigt also mehr als der Browser. Sichere Richtung.
* **doppeltes `style`:** ein Browser nimmt das erste, `E105Schritt` verodert alle (`:744-746`).
  Fehlalarm theoretisch, in Mails nicht gesehen.
* **Zeilenumbruch zwischen `display:` und `none`** im Attribut (`ReadHTMLTag` behält CR/LF in
  Anführungszeichen, `:893`): nicht erkannt (`:657`, `:662` überspringen nur Leerzeichen und Tab).
  Sichere Richtung.

## 3. Wege, auf denen im versteckten Bereich trotzdem etwas ausgegeben wird

Die vier Sperren in `pgReadNextBlock` (`:429`, `:448`, `:482`, `:502`) decken Entitäten (beide
Zweige) und gewöhnlichen Text ab. Daneben:

| Weg | Stelle | im Bereich |
|---|---|---|
| CR/LF außerhalb der Tabelle | `:534-541` — der `else if`-Zweig nach der Sperre gibt `' '` aus | **ein Leerzeichen** je Bereich; `IMPORT_NO_LEADING_SPACES` (`:84`, `PGIMPORT.CPP:1078-1081`) schluckt weitere. Gleich wie seit [AN-2](../Intern/BEFUNDE.md#an-2) bei `<script>`. Sichtbar höchstens als Leerzeichen zwischen zwei Wörtern: `Hallo<span style=display:none>x⏎</span>Welt` → „Hallo Welt“ statt „HalloWelt“. Kosmetisch. |
| ESC (0x1B) | `:546-548` | wird ausgegeben. Nur ISO-2022-JP-Mails; unsichtbares Steuerzeichen. Kosmetisch. |
| `<` vor Nicht-Buchstabe | `ReadHTMLTag` `:857-860` (`OutputCharacter('<')` vor dem E-105-Haken) | ein `<` erscheint, z. B. aus `a < b` oder `<?xml …>` im versteckten Text. Selten. |
| Kommentare `<!-- -->` | `:827-852` — Rückkehr **vor** dem Haken, Ausgabe nur bei `code_listing` | nichts. Bedingte Kommentare (`<!--[if mso]>`) verhalten sich wie vorher. |
| `code_listing` (`<listing>`, `PGHTMDEF.C:28`, Wert 12) | Haken übersprungen (`:922`) | ein `<listing>` **im** Bereich wird selbst verschluckt, `code_listing` wird dort nie gesetzt; Bereich **im** `<listing>` wird nicht versteckt — richtig, dort ist alles Literaltext. |
| `ProcessEmbed` | `:310-312`, nur über `current_style.embed_object` aus `DoDataTag` | verstecktes `<img>` erreicht `DoDataTag` nie. |
| Tabellen-Vorlauf | `ProcessPreTable` `:2798` ruft `ReadHTMLTag` | Zustand gesichert/wiederhergestellt (`:2771-2774`, `:2840-2841`), versteckte Zellen zählen in beiden Läufen gleich. Richtig. |
| `ScanStyleSheet`, `SkipToEndTag` (Eudoras Unterklasse) | `Paige_io.cpp:1260`, `:1304` rufen `ReadHTMLTag` | [E-105](../Intern/BEFUNDE.md#e-105) läuft dort mit. Ohne Wirkung, solange im CSS bzw. in der Signatur kein unvollständiges verstecktes Element steht. |

### Gegenvermutung G1 — Tags in `<script>` öffnen einen Bereich

Der Haken prüft `inside_script` nicht (`:922`). Ein `document.write('<div style="display:none">')`
ohne passendes `</div>` im selben Skript öffnet einen Bereich bis `</body>`. Skripte in Mails
sind selten; nicht gemessen. Billige Abhilfe: `if (!code_listing && !inside_script)`.

### Gegenvermutung G2 — die Zahl „elf versteckte Bereiche“ ist zu hoch

Die Spurmarke (`:928-931`) schreibt auch im **Tabellen-Vorlauf**, und `ProcessPreTable` liest jede
Tabelle oberster Ebene zweimal (`:2678`, `:2698` nur ohne `parallel_buffer`/`temp_buffer_ref`). Jedes
versteckte Element **innerhalb** einer Tabelle steht also doppelt im Protokoll. Beim echten
freenet-Newsletter (Layout aus Tabellen) sind die „elf“ vermutlich weniger verschiedene
Elemente. Ändert nichts an der Richtigkeit, nur an der Lesart der Messung in BEFUNDE.md.
Die Prüfnachricht (`Testdaten/e105-handyfassung-versteckt.eml`) hat ihre vier Bereiche außerhalb
von Tabellen, dort stimmt „vier“.

### Hinweis zu BEFUNDE.md

[E-105](../Intern/BEFUNDE.md#e-105) schreibt unter „Nicht abgedeckt“: *„Paige wertet `<style>` nicht aus, [AN-2](../Intern/BEFUNDE.md#an-2) verschluckt ihn“*.
Im gebauten Eudora stimmt der zweite Teil nicht: `CMyPaigeHTMLImportFilter::PreProcessTag`
fängt `style_command` vorher ab und ruft `ScanStyleSheet` (`Paige_io.cpp:1071-1075`); `DoControlTag`
mit `inside_script = TRUE` (`PGHTMIMP.CPP:1470-1472`) wird für `<style>` nie erreicht.
`ScanStyleSheet` liest nur `p.`/`div.`-Klassen auf Ränder hin, `display` nicht. Die Aussage
„Klassen-`display:none` nicht abgedeckt“ bleibt richtig, die Begründung ist zu berichtigen.
Wer Klassen nachrüsten will, setzt dort an, nicht bei [AN-2](../Intern/BEFUNDE.md#an-2).

## 4. Zurücksetzen zwischen Importen

`e105_tag`/`e105_tiefe` werden nur im Konstruktor gesetzt (`:107-108`), wie `inside_script`
(`:106`); `pgPrepareImport` (`:154-249`) setzt keins von beiden zurück. Das genügt, weil jedes
Filterobjekt genau einen Import macht: `Paige_io.cpp:178/194/200`, `:338/685/695`,
`:751/762/768` (je anlegen — `pgImportFile` — `delete`), `MakeTranslator` legt jedes Mal neu an
(`:820`), `PGIMPORT.CPP:1312-1322` ebenso. Ein Bereich, der am Ende eines HTML-Teils offen ist,
kann also nicht in den nächsten Teil oder die nächste Nachricht hinüberwirken.
**Gegenvermutung G3:** Wer künftig ein Filterobjekt wiederverwendet, erbt den offenen Bereich —
eine Zeile `e105_tiefe = 0; e105_tag[0] = 0;` in `pgPrepareImport` wäre billige Vorsorge
(gilt genauso für `inside_script`).

## 5. Wer baut die Stelle

`perl tools/wer-baut.pl Eudora71/Eudora/PGHTMIMP.CPP` → **ja**, `Eudora.vcxproj`.
`Eudora71/PaigeDLL/PGTXR/PGHTMIMP.CPP` und `PGIMPORT.CPP` → **in keinem Projekt**. `Paige32.dll`
enthält keinen HTML-Import; die Behebung sitzt am richtigen Ort.
Klassenlayout: die neuen Glieder stehen nur in `Eudora71/Eudora/PGTXRCPP.H:396-397`, nicht in
`PaigeDLL/PGHEADER/PGTXRCPP.H`. `Paige_io.h:8` bindet mit Anführungszeichen ein, also zuerst
aus dem eigenen Verzeichnis; außerhalb von `Eudora71/Eudora/` bindet keine Datei `pgtxrcpp.h` oder
`Paige_io.h` ein (grep). Kein Layout-Bruch — dasselbe Muster trägt seit [AN-2](../Intern/BEFUNDE.md#an-2) `inside_script`.

## 6. Tests

`UnderTestE105.cpp` bindet die von `Extract.ps1` geschnittene Region `^static int E105GleichKlein`
bis Ende `E105Schritt` ein — es wird der echte Code geprüft, keine Abschrift. Die sechs Fälle
decken Erkennung, Gegenrichtung, Verschachtelung, leere Elemente, `</body>` und `<p>` ab.
**Es fehlt:** jedes weggelassene Ende-Tag außer `</p>` (F1, F2) — genau die Richtung, in der
sichtbare Post verschwindet.

## Zusammenfassung

| Nr | Fund | Stelle | Gewicht |
|---|---|---|---|
| F1 | verstecktes `<td>`/`<tr>`/`<li>` ohne Ende-Tag oder vergessenes `</div>` in einer Zelle lässt den Rest des HTML-Teils verschwinden | `PGHTMIMP.CPP:768-781` | mittel, gemessen, nicht in Gregors Post gesehen |
| F2 | verstecktes `<p>` verschluckt das Start-Tag der nächsten Zelle | `PGHTMIMP.CPP:688-689`, `:769` | gering, gemessen |
| G1 | Tags in `<script>` öffnen Bereiche (Gegenvermutung) | `PGHTMIMP.CPP:922` | gering, ungemessen |
| G2 | Spurmarke zählt versteckte Elemente in Tabellen doppelt | `PGHTMIMP.CPP:928-931`, `:2798` | nur Messdeutung |
| G3 | kein Zurücksetzen in `pgPrepareImport` (Vorsorge) | `PGHTMIMP.CPP:154` | heute folgenlos |
| — | ein Leerzeichen, ESC und `<` können aus dem Bereich durchsickern | `:534-548`, `:857-860` | kosmetisch |
| — | BEFUNDE.md: `<style>` geht über `ScanStyleSheet`, nicht über [AN-2](../Intern/BEFUNDE.md#an-2) | `Paige_io.cpp:1071-1075` | Doku |

Puffergrenzen: alle sicher (Abschnitt 1, ASan ohne Meldung).
