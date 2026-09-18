# PRÜFER-18 — die E-110-Spurmarke in `PGHTMIMP.CPP` (Commit `dca1d8f`)

Stand: 18.09.2026. Zweig `e110-spurmarke-bilddaten`, Arbeitsbaum
`C:\Users\Gregor\Documents\github\Eudora7.2`. **Kein Quelltext unter
`Eudora71/` angefasst, kein ändernder git-Befehl gefahren.** Geprüft wurde
genau eine Änderung: `Eudora71/Eudora/PGHTMIMP.CPP`, Zeilen 2229–2311.

---

## Die Antwort in einem Satz

**Der Code ist sicher — er schreibt über keinen Puffer hinaus, und der
Hauptverdacht gegen ihn (`image_record.URL` nicht nullterminiert) ist
widerlegt. Aber die Messung misst nicht, was sie behauptet: `daten=` wird in
Gregors Bestand in allen 128 Zeilen `0` ausgeben, auch bei Bildern, die
nachweislich geladen werden.** Als Paket gebaut kostet es eine Testrunde und
beantwortet E-110 nicht.

---

## 0. Was ich gefahren habe

* `git show dca1d8f -- Eudora71/Eudora/PGHTMIMP.CPP` und den Bestand um die
  Änderung herum (Zeilen 1976–2320) gelesen.
* `pg_url_image` (`Eudora71/PaigeDLL/PGHEADER/PAIGE.H:1478-1491`),
  `pgNewImageRecord` (`Eudora71/PaigeDLL/PGSOURCE/PGEMBED.C:1813`),
  `GetMemoryRecord` (`Eudora71/PaigeDLL/PGPLATFO/PGMEMMGR.C:450`),
  `pgInitEmbedStyleInfo` (`PGEMBED.C:1697`), `eCallback` und `PgLoadUrlImage`
  (`Eudora71/Eudora/PgEmbeddedImage.cpp:255, 330, 453`) gelesen.
* **Die Pufferarithmetik compiliert und gefahren** — der Block wörtlich
  nachgestellt, mit 64 Byte Wächter vor und hinter `szSrc`, Längen 0…1000
  (MSVC 14.38, `/W4 /Od`, 32 Bit).
* **Gregors eigenes Protokoll gemessen**:
  `C:\Users\Gregor\Eudora72-1.0.72-release\Mailverzeichnis\eudora.log`
  (150 580 Byte, 18.09.2026 08:20).

---

## Fund 1 — Punkt 4 des Auftrags: `daten=` wird immer 0 sein. Die Messfassung misst E-110 nicht.

| | |
|---|---|
| **Fund** | `image_record` ist an der Spurmarke zwar **dasselbe Abbild** wie das, was `pgNewImageRecord` hinterlassen hat — aber eingefroren auf den Stand **vor** dem eigentlichen Laden. Der Griff, den `PgLoadUrlImage` setzt, entsteht in Gregors Bestand ausnahmslos **später**, in einem anderen Aufruf, und erreicht diese Kopie nie. |
| **Ort** | `Eudora71/Eudora/PGHTMIMP.CPP:2059` (`GetMemoryRecord`) gegen `:2306`; `Eudora71/Eudora/PgEmbeddedImage.cpp:257-263` (`EMBED_PREPARE_IMAGE`) und `:453` |
| **Gemessen** | (a) `image_record` wird in Zeile 2059 aus `image_ref` **frisch herausgeholt** — bis dahin ist die Kopie also aktuell; zwischen 2059 und 2306 wird sie nirgends mehr beschrieben (`awk`-Lauf über 2059–2232: genau eine Fundstelle, die Zeile 2059 selbst). Der Verdacht „Kopie von vor dem Laden" trifft also **nicht** über die Kopiermechanik. (b) Er trifft über den **Zeitpunkt**: Daten kann nur `EMBED_PREPARE_IMAGE` aus `pgNewImageRecord` (`PGEMBED.C:1871`) eingetragen haben, und dieser Zweig läuft laut `PgEmbeddedImage.cpp:257` nur, `if ( !(image->source_width && image->source_height) )`. (c) In `eudora.log`: **128** Zeilen `E-95 Bild`, davon **76** mit vollständigem `attr=BxH` → für diese 76 wird `EMBED_PREPARE_IMAGE` gar nicht erst tätig. (d) Die übrigen **52** tragen alle `attr=…x0` **und** `embed=0x0`. Da `attr` aus derselben frisch geholten Kopie stammt, hätte ein geglückter Ladeversuch dort `source_height` gefüllt (`PgEmbeddedImage.cpp:447-449`) — er ist also bei allen 52 fehlgeschlagen. **Ergebnis: `image_data` ist an dieser Stelle in allen 128 Fällen 0.** (e) Geladen wird trotzdem, nur später: dieselbe Protokolldatei enthält **22 ×** `E-103 Nachtrag` und **32 ×** `E-106 groesser als angegeben`, beides aus `PgLoadUrlImage` mit `bAllowThreadedFetch=true`, also aus `EMBED_LOAD_IMAGE` beim Zeichnen — lange nachdem `DoDataTag` zurückgekehrt ist. |
| **Bewertung** | Die Spalte behauptet *„Paige hat Bilddaten"* und misst *„das Bild wurde schon während des Imports synchron geladen"* — und das ist in Gregors Bestand nie der Fall. Schlimmer: die Auslassung ist **deckungsgleich mit der E-110-Bevölkerung**. E-110 heißt *„ein Teil der Bilder bleibt grau, und der Platz stimmt trotzdem"*; „der Platz stimmt" heißt `attr=BxH` vollständig, und das sind die 76, bei denen der Ladezweig per `if` übersprungen wird. Die Messung ist gerade dort blind, wo der Befund sitzt. Das ist derselbe Mechanismus, den der Commit selbst bei der Adresse benennt (`Arbeitsweise/anzeige-ist-kein-zustand.md`): die Ausgabe ist eine Behauptung des Programms über sich selbst, hier über einen Zeitpunkt, den niemand geprüft hat. |
| **Behebung** | **Kleinster ehrlicher Eingriff (A):** Spalte umbenennen und um ihren Gegenwert ergänzen — `daten-import=%ld ladeergebnis=%ld` aus `image_data` und `loader_result`. Dann sagt die Zeile, was sie misst, und `0/0` ist als *„beim Import nicht einmal versucht"* lesbar. **Die Messung, die E-110 beantwortet (B):** eine Zeile in `Eudora71/Eudora/PgEmbeddedImage.cpp` unmittelbar vor `return fRet;` (Zeile **777**), im Rumpf von `PgLoadUrlImage`, mit `if (pUrlImage)` davor (der Eintritt bei `:356` lässt `pUrlImage == NULL` durch): `"E-110 Laden: src=%s faden=%d ok=%d daten=%ld art=%ld fehler=%ld quelle=%dx%d"` aus `pUrlImage->URL` (gekürzt wie in `PGHTMIMP.CPP`), `bAllowThreadedFetch`, `fRet`, `image_data`, `type_and_flags`, `loader_result`, `source_width/height`. Das ist die Stelle, an der die Antwort entsteht — `Arbeitsweise/zwei-werte-in-eine-ausgabe.md`: Erfolg und Griff gehören in dieselbe Zeile. **A ohne B lohnt kein Paket.** |

---

## Fund 2 — Punkt 3 des Auftrags: der Hauptverdacht ist widerlegt

| | |
|---|---|
| **Fund** | `image_record.URL` **ist** an der Spurmarke garantiert nullterminiert. `strlen` darauf ist zulässig. |
| **Ort** | `Eudora71/Eudora/PGHTMIMP.CPP:2036-2037` |
| **Gemessen** | Unmittelbar hinter beiden Füllzweigen steht, von QUALCOMM, mit eigenem Kommentar: `// Terminate the string for edge cases` / `image_record.URL[sizeof(image_record.URL)-1] = '\0';`. Das trifft genau den Fall, den der Auftrag vermutet — `strncpy` mit `sizeof(image_record.URL)` in Zeile 2018 terminiert bei Gleichstand nicht. Beide Wege durch `pgNewImageRecord` erhalten die Terminierung: der Neu-Weg kopiert das ganze `pg_url_image` (`PGEMBED.C:1846`, `*result_image = *image;`), der Wiederverwendungs-Weg wird nur betreten, wenn `pgEqualStruct` über **alle 512 Byte** des URL-Feldes Gleichheit meldet (`PGEMBED.C:1839`) — dann steht die Null im wiederverwendeten Satz an derselben Stelle. `GetMemoryRecord` (`PGMEMMGR.C:450`) ist ein reiner `pgBlockMove` der vollen Satzgröße. |
| **Bewertung** | Kein Mangel. Die Vorbedingung, die `strlen` mitbringt (`Arbeitsweise/funktion-bringt-ihre-vorbedingung-mit.md`, Frage 2: *„Erwartet er eine bestimmte Terminierung?"*), ist erfüllt — allerdings nicht durch die Änderung, sondern durch eine Zeile 250 Zeilen darüber, die ihre Zusage nirgends ausspricht. Wer das URL-Feld künftig anders füllt, hebt sie auf. |
| **Behebung** | keine nötig. Wünschenswert: ein Halbsatz im Kommentarblock, dass die Terminierung aus Zeile 2037 stammt. |

---

## Fund 3 — Punkt 1 des Auftrags: die Pufferarithmetik ist exakt, mit null Byte Luft

| | |
|---|---|
| **Fund** | Der Kürzungsblock schreibt im ungünstigsten Fall **genau 200 Byte** in `szSrc[200]`. Er läuft nicht über, und `pURL + nLang - nFuss` kann nie vor `pURL` zeigen. |
| **Ort** | `Eudora71/Eudora/PGHTMIMP.CPP:2282-2297` |
| **Gemessen** | Nachgerechnet: `nMax = 199`, `nKopf = 40`, `nFuss = 199 - 40 - 2 = 157`. `memcpy(szSrc, pURL, 40)` → Index 0…39; zwei Punkte → 40, 41; `memcpy(szSrc+42, …, 157)` → Index 42…198; `szSrc[42+157] = szSrc[199] = 0`. Höchster beschriebener Index **199**, letzter gültiger Index **199**. Der `strcpy`-Weg schreibt bei `nLang = 199` ebenfalls 200 Byte. Der `else`-Weg wird erst ab `nLang ≥ 200` betreten, also immer `nLang > nFuss = 157` → `nLang - nFuss ≥ 43 > 0`. **Gegentest compiliert und gefahren** (MSVC 14.38, 32 Bit, `/W4 /Od`, Wächterbereich 64 Byte vor und hinter `szSrc`, Längen 0…1000): kein Wächterbyte verändert, Ergebnis in jedem Lauf terminiert. Einzelwerte: `nLang=42 → 42 Zeichen`; `198 → 198`; `199 → 199`; `200 → 199`; `201 → 199`; `1000 → 199`. Bei 42 Zeichen greift der `strcpy`-Weg, nichts wird ausgelassen. |
| **Bewertung** | Richtig, aber **auf Kante genäht**: die drei Konstanten müssen zusammenpassen, und nichts im Code hält sie zusammen. Bei `nKopf ≥ 198` würde `nFuss ≤ -1`, und `memcpy` bekäme eine negative Länge, die als riesiges `size_t` ankommt. Das ist heute nicht der Fall und kann es nur durch eine spätere Änderung werden. |
| **Behebung** | Nicht erforderlich. Wenn ohne Kosten mitzunehmen: ein `szSrc[sizeof(szSrc)-1] = 0;` als letzte Zeile des Blocks kostet nichts und macht jede spätere Verrechnung harmlos. |

---

## Fund 4 — Punkt 2 des Auftrags: `wsprintf` passt, mit 140 Byte Reserve

| | |
|---|---|
| **Fund** | Die größtmögliche Ausgabe ist **372 Byte** einschließlich der abschließenden Null. `szSpur` fasst 512. |
| **Ort** | `Eudora71/Eudora/PGHTMIMP.CPP:2229, 2300-2308` |
| **Gemessen** | Fester Text ohne Platzhalter: **73** Zeichen (gezählt, nicht geschätzt: Formatzeichenkette 99 Zeichen, darin 1 × `%s`, 6 × `%ld`, 3 × `%d`). Adresse höchstens **199** (Fund 3). Neun Zahlen, jede im ungünstigsten Fall als negatives 32-Bit-`long` **11** Zeichen: 9 × 11 = **99**. Summe 73 + 199 + 99 = **371**, plus Null = **372**. Reserve **140 Byte**. Realistisch sind die drei `%d` `short`-Werte (`source_width/height` und `style_info.ascent` sind `short`, `PAIGE.H:1483-1484, 1736`), also höchstens 6 Zeichen → 357 Byte. |
| **Bewertung** | Ausreichend, auch im ungünstigsten Fall, und `wsprintf`s eigene Obergrenze von 1024 Byte ist nicht berührt. Dass `wsprintf` nichts prüft, stimmt — hier trägt die Rechnung. Der einzige Weg zu einem Überlauf wäre ein nicht terminiertes `szSrc`, und das ist durch Fund 3 ausgeschlossen. |
| **Behebung** | keine. |

---

## Fund 5 — Punkt 5 des Auftrags: `long i;` ist sauber entfernt

| | |
|---|---|
| **Fund** | Der Bezeichner `i` kommt im ganzen Spurmarkenblock nicht mehr vor. |
| **Ort** | `Eudora71/Eudora/PGHTMIMP.CPP:2225-2312` |
| **Gemessen** | `awk 'NR>=2225 && NR<=2320' … \| grep -n "\bi\b"` → **keine Ausgabe**. Die Deklaration stand im inneren Block; ihre Entfernung kann keinen äußeren Gebrauch treffen. |
| **Bewertung** | In Ordnung. Das Ausbleiben einer Compilerwarnung ist hier kein Beleg — gemessen ist der Bestand, nicht die Warnung. |
| **Behebung** | keine. |

---

## Nebenbefund NB-1 — ein Byte Überlauf im URL-Feld, **nicht** aus dieser Änderung

| | |
|---|---|
| **Fund** | Der Zusammensetz-Zweig kann **513 Byte** in `pg_char URL[512]` schreiben. |
| **Ort** | `Eudora71/Eudora/PGHTMIMP.CPP:2015-2033` (Originalcode QUALCOMM, von `dca1d8f` nicht berührt) |
| **Gemessen** | Der `else`-Zweig wird betreten, wenn `strlen(base_url_string) + strlen(szImageURL) <= sizeof(image_record.URL)`, also auch bei Summe **512**. `strcpy` + `strcat` schreiben dann 512 Zeichen **plus** Null = 513 Byte. Ein führender Schrägstrich wird nur übersprungen, wenn einer da ist. |
| **Bewertung** | Real, aber folgenlos: das 513. Byte ist `alt_string[0]`, und `alt_string` wird zwanzig Zeilen später ohnehin beschrieben (`:2046-2053`). Zudem setzt Zeile 2037 `URL[511] = 0`, sodass kein unbegrenztes Lesen entstehen kann. **Kein Grund, das Paket aufzuhalten**; gehört als eigener Befund in `BEFUNDE.md`, nicht in diesen Commit — vorher `tools/befund-suchen.pl` über die Stelle laufen lassen (`Arbeitsweise/bestand-vor-neuer-suche.md`). |
| **Behebung** | Vergleich auf `>=` ziehen oder `sizeof(URL) - 1` als Grenze. |

---

## Nebenbefund NB-2 — `daten=%ld` auf einem Handle

`image_data` ist `generic_var`, unter Windows `unsigned long`
(`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H:678`). Als `%ld` gedruckt erscheint ein
Metadateigriff oberhalb `0x7FFFFFFF` als **negative** Zahl. Für die Frage
„0 oder nicht 0" unschädlich, beim Wiedererkennen desselben Griffs in zwei
Zeilen aber lästig. `%08lX` wäre die bessere Wahl — kostet nichts und macht
die Spalte zwischen zwei Bildern vergleichbar.

---

## Was an der Änderung gut ist und bleiben soll

Die **Adresse ungekürzt** ist die eigentliche Verbesserung dieses Commits, und
sie trägt. In `eudora.log` sind heute alle 128 Zeilen auf 32 Zeichen
abgeschnitten — `src=https://secureir.ebaystatic.com/` steht für mehrere
verschiedene Bilder. Die Mitte auszulassen statt des Endes ist nach E-106
(`_3x` im Dateinamen) die richtige Entscheidung, und sie ist, siehe Fund 3,
sauber gerechnet. `art=` aus `type_and_flags` ist harmlos und nützlich.

---

## Urteil

| Frage | Antwort |
|---|---|
| Schreibt der Code über einen Puffer hinaus? | **Nein.** Compiliert und über 1001 Längen gemessen. |
| Ist `strlen` auf `image_record.URL` zulässig? | **Ja.** Terminierung in Zeile 2037 belegt. |
| Beantwortet `daten=` die Frage von E-110? | **Nein.** Der Wert ist in Gregors Bestand in allen 128 Fällen 0. |
| Darf das Paket **so** gebaut werden? | **Sicherheitstechnisch ja — als Messfassung nein.** |

Die Empfehlung ist nicht „aufhalten", sondern **eine Zeile mitnehmen**:
Fund 1, Variante B in `PgEmbeddedImage.cpp:777`. Ohne sie liefert 1.0.73
128 Zeilen `daten=0`, und E-110 steht danach genau da, wo es jetzt steht —
`Arbeitsweise/eingebaute-messung-auslesen.md`: der Einbau ist noch keine
Messung, und eine Messung an der falschen Stelle ist keine.

**Gegenprobe zu Fund 1, umgedreht formuliert** (`Arbeitsweise/gegenprobe-umdrehen.md`):
Wenn 1.0.73 unverändert gebaut wird, ist die Vorhersage falsifizierbar —
**erscheint auch nur eine Zeile `E-95 Bild` mit `daten=` ungleich 0, ist dieser
Fund widerlegt.** Erscheinen 128 Nullen, ist er bestätigt und die Testrunde war
umsonst.
