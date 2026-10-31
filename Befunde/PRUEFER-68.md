# <a id="pruefer-68"></a>PRUEFER-68 — Prüfung von E-136, E-165, E-171, E-139, E-140 und ihren Tests, 31.10.2026

**Auftrag.** Alles, was seit `ae3efe3` unter `Eudora71`, `tools` und
`Releases/1.0` dazukam (`git log ae3efe3..HEAD`, Stand `11643ee1`).
Schwerpunkt: [E-136](../Intern/BEFUNDE.md#e-136) (Datenverlust beim
Speichern), dann [E-165](../Intern/BEFUNDE.md#e-165),
[E-171](../Intern/BEFUNDE.md#e-171), [E-139](../Intern/BEFUNDE.md#e-139),
[E-140](../Intern/BEFUNDE.md#e-140) und die neuen Tests dazu.

Eudora wurde weder gebaut noch gestartet. Gebaut und gefahren habe ich nur
die Testsuite im Arbeitsbaum `.wt/pruefer` (`Eudora71\Tests\RunTests.cmd`).
Grundlauf: **350 Tests, 350 bestanden** (gemessen). Die eine Gegenprobe unten
habe ich per Perl byte-genau eingesetzt und danach aus einer Kopie
zurückgeschrieben; `cmp` gegen die Kopie war gleich, `git status` leer.

Jede Aussage trägt ihre Herkunft: **gemessen**, **am Quelltext belegt**
(Datei:Zeile) oder **Vermutung**.

**Ergebnis vorweg.**

* **Die neue Umwandlung `E136HtmlAusBstr` selbst verliert nichts.** Länge,
  Puffer, Ersatzpaare, Umlaute, Euro und Doppelbyte-Codepages gehen richtig
  durch (am Quelltext belegt). Die Sorge, sie zerlege unter der
  UTF-8-Codepage alle Tags in Entitäten, habe ich gemessen und widerlegt.
* **Aber das Emoji geht auf drei anderen Speicherwegen weiter verloren**
  ([K1](#k1)). *Datei → Speichern unter* aus dem Nachrichtenfenster liest das
  HTML über `GetMessageBody`. Dort steht noch `szMsg = cbstr`
  (`TridentReadMessageView.cpp:2915`). Das ist genau die Zeile, die
  [E-136](../Intern/BEFUNDE.md#e-136) an zwei anderen Stellen ersetzt hat. Getroffen ist der Normalfall:
  *.htm* ohne „Kopfzeilen einschließen“. Dazu kommt jede *.txt*-Datei aus
  demselben Fenster.
* **Wer im Bearbeiten-Modus etwas formatiert, zerstört das Emoji schon auf
  dem Bildschirm** ([K2](#k2)). *Fett*, *Link einfügen* und ähnliche Befehle
  holen das HTML mit `CString = BSTR` und schreiben es zurück
  (`TridentReadMessageView.cpp:2679, 3338, 3411, 3621, 4058`). Danach
  speichert Strg-S getreu die Fragezeichen. Ebenso verliert eine Antwort auf
  markierten Text das Emoji (`TridentView.cpp:3944`). Vorschlag: neue Kennung
  E-178.
* **Die neuen Entitäten werden an anderer Stelle falsch zurückgelesen**
  ([K3](#k3)). Eudoras HTML-zu-Text-Wandler nimmt von `&#128293;` nur das
  unterste Byte: `( char )( atoi(...) & 0xFF )` (`html2text.cpp:1184`). Aus
  dem Emoji wird `%`, aus einem kyrillischen `Ж` ein Steuerzeichen 0x16.
  Vorher stand an dieser Stelle `??`, jetzt steht dort **ein falsches Zeichen
  ohne Warnung**. Das betrifft etwa den Textteil einer gesendeten
  HTML-Nachricht. Vorschlag: neue Kennung E-179.
* **[E-165](../Intern/BEFUNDE.md#e-165), [E-171](../Intern/BEFUNDE.md#e-171), [E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140) halten.** Geblieben sind Kleinigkeiten:
  Die Spalte der Vervollständigungsbox ist um eine Bildlaufleistenbreite zu
  schmal ([K4](#k4)). Wer im Suchfenster mit leerem Feld selbst *Search*
  drückt, bekommt weiter „internal error“ ([K5](#k5)).
* **Die Tests fangen die Hauptstelle, die Nebenwege nicht** ([K6](#k6)).
  Gemessen: eine zusätzliche verlustbehaftete Zuweisung direkt hinter dem
  neuen Aufruf in `GetAllHTML` lässt alle Tests grün.

**Hält etwas das nächste Paket auf?** Nach meiner Einschätzung keiner der
Funde. Kein Fund ist ein **neuer** Verlust: K1 und K2 sind der alte Fehler auf
Wegen, die [E-136](../Intern/BEFUNDE.md#e-136) nicht angefasst hat. K3 tauscht `??` gegen ein falsches
Zeichen. **Aber:** [E-136](../Intern/BEFUNDE.md#e-136) sollte nicht „behoben“ heißen, solange K1 offen ist.
Testet Gregor mit *Speichern unter* statt mit Strg-S, sieht er weiter `??`.
Gregor entscheidet.

## <a id="k1"></a>K1 — „Speichern unter“ aus dem Nachrichtenfenster wandelt weiter mit `CString = BSTR`

**Am Quelltext belegt.** `CReadMessageDoc::SaveAsFile`
(`ReadMessageDoc.cpp:605`ff.) holt den Inhalt über das Protokoll der Ansicht:

| Dateiendung | Schalter „Kopfzeilen einschließen“ | Aufruf | Umwandlung |
|---|---|---|---|
| `.htm`/`.html` | an | `GetMessageAsHTML` → `GetAllHTML` | `E136HtmlAusBstr` — behoben |
| `.htm`/`.html` | **aus** | `GetMessageAsHTML` → `GetMessageBody(…, TRUE)` (`TridentReadMessageView.cpp:2932`) | **`szMsg = cbstr;` (`:2915`)** |
| `.txt` u. a. | an | `GetMessageAsText` → `GetAllText` (`TridentView.cpp:3983`, `get_text`) | `CString = BSTR` |
| `.txt` u. a. | aus | `GetMessageAsText` → `GetMessageBody(…, FALSE)` | **`szMsg = cbstr;` (`:2915`)** |

`GetMessageBody` holt mit `get_htmlText` bzw. `get_text` (`:2906/2910`) und
weist dann zu wie vor [E-136](../Intern/BEFUNDE.md#e-136). Aus 🔥 wird damit `??`, aus `Ж` ein `?`.
„Kopfzeilen einschließen“ ist nach [E-98](../Intern/BEFUNDE.md#e-98) auf
Windows 10 nicht anwählbar und steht bei Gregor auf *aus*. Die erste Zeile der
Tabelle, die einzige behobene, ist damit die seltene.

**Was zu tun wäre.** Im HTML-Zweig von `GetMessageBody` gilt dasselbe wie in
`SaveInfo`: `szMsg = bAsHTML ? E136HtmlAusBstr( (BSTR) cbstr ) : CString( cbstr );`.
Für die Textwege (`get_text`) hilft eine Entität nicht. Dort bliebe nur, die
Datei als UTF-8 zu schreiben und das auch anzugeben. Das reicht über [E-136](../Intern/BEFUNDE.md#e-136)
hinaus. Ich schlage vor, den HTML-Zweig als Fortschreibung von [E-136](../Intern/BEFUNDE.md#e-136) zu
behandeln und die Textwege dort als „nicht behoben“ zu vermerken.

**Gegenvermutung, verworfen:** [E-140](../Intern/BEFUNDE.md#e-140) könnte das mit erledigt haben. Nein:
`E140TextFuerDatei` bekommt den schon umgewandelten `CString`. Er ergänzt nur
die Angabe `charset=windows-1252` und kann verlorene Zeichen nicht
zurückholen (am Quelltext belegt, `msgutils.cpp`, `E140TextFuerDatei`).

## <a id="k2"></a>K2 — Bearbeiten-Modus und Antwort auf Markiertes: dieselbe Umwandlung, aber vor dem Speichern

**Am Quelltext belegt.** Im Nachrichtenfenster im Bearbeiten-Modus holen
diese Befehle HTML aus der Anzeige, verändern es als `CString` und schreiben
es zurück:

| Funktion | Stelle | zurück in die Anzeige |
|---|---|---|
| `OnEditInsertLink` | `TridentReadMessageView.cpp:2679` `szInnerHTML = cbstr;` | über `A2BSTR` |
| `ExpandTag` | `:3207`, `:3217`, `:3338` | `put_outerHTML` / `pasteHTML` |
| `SplitTagOff` | `:3408`, `:3411`, `:3621` | ebenso |
| `WrapTag` | `:4058` `szText = cbstr;` | ebenso |

Wird ein markierter Bereich mit Emoji fett gesetzt oder verlinkt, stehen
danach **auf dem Bildschirm** Fragezeichen. Strg-S speichert sie dann
getreu ab, und die neue E-136-Spur meldet „0 Zeichen ausserhalb der
Codepage“ (Vermutung zur Wirkung; die Umwandlungen sind belegt).

Dazu kommt `CTridentView::GetSelectedHTML` (`TridentView.cpp:3944`,
`szHTML += CString( cbstrText );`). Sie liefert den markierten Text für
*Antworten* (`msgdoc.cpp:638`), für Antworten aus der Postfachliste
(`TocFrame.cpp:1945`) und für Übersetzer-Plug-ins (`Trnslate.cpp:1970`). Wer
auf ein markiertes Emoji antwortet, zitiert `??`.

**Schwere:** mittel. Es ist derselbe Verlust wie [E-136](../Intern/BEFUNDE.md#e-136), nur an der Quelle.
Die Abhilfe ist dieselbe Funktion, an sieben Stellen statt an zwei.
**Vorschlag: neue Kennung E-178.** `tools/befund-suchen.pl` findet zu
`GetSelectedHTML`, `GetMessageBody` und `WrapTag` keinen Befund.

## <a id="k3"></a>K3 — `Html2Text` liest `&#128293;` als `%`

**Am Quelltext belegt:** `html2text.cpp:1175-1184` liest bei `&#` die Ziffern
und schreibt `( char )( atoi( szTemp ) & 0xFF )`. **Nachgerechnet:** 128293
mod 256 = 37, also `%`. 1046 (`Ж`) mod 256 = 22, also das Steuerzeichen
0x16. `EmoticonManager.cpp:544-548` rechnet ebenso.

Der Fehler ist alt und traf schon empfangene HTML-Nachrichten mit
numerischen Entitäten. **Neu ist, dass [E-136](../Intern/BEFUNDE.md#e-136) solche Entitäten jetzt selbst in
die Postfachdatei schreibt.** Jedes Emoji, das Strg-S rettet, kommt auf diesen
Wegen als `%` heraus statt als `??`:

* der Textteil, den `sendmail.cpp:2002/2674/2710/2727` aus dem HTML einer
  ausgehenden Nachricht erzeugt;
* die Volltextsuche (`X1EmailIndexItem.cpp:251`);
* `TextReader.cpp:49` und `Trnslate.cpp:5017`.

`??` sieht jeder als Verlust. `%` sieht aus wie Inhalt. Wie das
Verfassen-Fenster (Paige) `&#128293;` beim Einlesen behandelt, habe ich nicht
gefunden; die HTML-Einleselogik liegt nicht als Quelltext unter `PaigeDLL`.
**Ungeprüft.**

**Was zu tun wäre:** Werte über 255 nicht abschneiden. Entweder die
Entität unverändert stehen lassen, oder ein Zeichen, das die Codepage nicht
hat, als `?` schreiben, wie bisher. Beide Stellen in einem Zug ändern.
**Schwere:** mittel (falsches Zeichen ohne Warnung, kein Verlust der
Postfachdatei). **Vorschlag: neue Kennung E-179.** `befund-suchen.pl
Html2Text` findet nur [E-117](../Intern/BEFUNDE.md#e-117), und das betrifft
`&amp;` in Bildadressen, eine andere Sache.

## <a id="k4"></a>K4 — E-165: die Spalte zieht die Bildlaufleiste zweimal ab

**Am Quelltext belegt.** Die Liste wird mit `WS_VSCROLL` angelegt
(`AutoCompleteSearcher.cpp:1499`). Der Hauptagent hat auch gemessen, dass sie
eine senkrechte Bildlaufleiste trägt. Bei sichtbarer Leiste ist
`m_ListCtrl->GetClientRect` **schon ohne** sie. `:1459` zieht
`SM_CXVSCROLL` dann noch einmal ab. Nachgerechnet bei 100 % Skalierung: alt
`(Liste+1) − 18 = Liste − 17`, das ist genau die Innenbreite. Neu ist es
`Liste − 17 − 17`. Die Spalte endet also eine Leistenbreite vor dem Rand, und
lange Adressen werden um so viel früher abgeschnitten (Vermutung zur
Sichtbarkeit). Ohne sichtbare Leiste ist es alt wie neu `Liste − 17`.
**Abhilfe:** `SM_CXVSCROLL` nur abziehen, wenn `GetStyle() & WS_VSCROLL`
gerade **nicht** gesetzt ist, oder die Spalte einfach auf die Innenbreite
setzen. **Schwere:** niedrig, nur Aussehen. Die Höhenrechnung
`E165BoxHoehe` halte ich für richtig (siehe [Was hält](#haelt)).

## <a id="k5"></a>K5 — E-171: dieselbe Meldung ist mit einem Klick weiter erreichbar

**Am Quelltext belegt.** Die Behebung verhindert nur den **automatischen**
Start (`guiutils.cpp:3375ff.`). Das Fenster geht mit leerem Suchfeld auf.
Drückt der Anwender dort *Search*, ohne etwas einzutragen, lehnt
`CSearchView::GetCriteria` den leeren Text ab (`SearchView.cpp:2335`). Die
Liste bleibt leer, `DoSearch` gibt `false` zurück (`:2592`), und `OnOk` zeigt
dieselbe Meldung „There has been an internal error during the search“
(`:2475`). Das ist keine Verschlechterung. Der Text ist aber falsch, denn es
fehlt nur der Suchbegriff. Vermutlich war das im Original genauso
(**Vermutung**, nicht gemessen).

Nebenbei (belegt, alt): mit leerem Suchtext schreibt `OpenFindMessagesWindow`
trotzdem `SearchCriteria1=Anywhere;Contains;` in die INI (`:3389`). Das
überschreibt das zuletzt gespeicherte Suchkriterium des Anwenders. Klein,
aber eine Bedingung `*szSearchPhrase` vor dem `SetIniString` würde es
abstellen. **Schwere:** niedrig.

Gegenvermutung, verworfen: ein Suchtext nur aus Leerraum umgeht die neue
Sperre. Nein, beide Aufrufer schneiden vorher ab (`GetSelectedTextAndTrim`,
`TridentView.cpp:1121`, `PaigeEdtView.cpp:8737`).

## <a id="k6"></a>K6 — Was die neuen Tests nicht fangen

**Gemessen (Gegenprobe).** In `CTridentView::GetAllHTML` habe ich direkt
hinter `szHTML = E136HtmlAusBstr( (BSTR) cbstrText );` die alte Zuweisung
`szHTML = CString( cbstrText );` eingesetzt. Das ist der E-136-Fehler auf dem
Weg, den der Test ausdrücklich bewacht. Ergebnis: siehe Abschnitt
[Gegenprobe](#gegenprobe). `Test_E136_Stelle` prüft nur, **dass** der
neue Aufruf dasteht, und schließt `szBody = cbstr;` aus. Andere Schreibweisen
schließt er nicht aus, und auch nicht `GetAllHTML`.

**Am Quelltext belegt:**

* `TestE136.cpp` liest nur zwei der elf Stellen aus K1 und K2. Würde der Test
  „keine Zuweisung `= cbstr` hinter `get_htmlText` in diesen Dateien“
  verlangen, hätte er K1 und K2 selbst gefunden.
* `TestE136.cpp` legt `&#55357;` für eine einzelne Ersatzhälfte als Soll fest.
  Das ist kein gültiger HTML-Zeichenverweis; ein Browser zeigt dafür U+FFFD.
  Gegenüber `?` ist es kein Verlust. Als Soll fest eingeschrieben ist es aber
  eine Entscheidung, die niemand getroffen hat. Niedrig.
* `TestE165.cpp`, `TestE171.cpp`, `TestE139.cpp` und `TestE140.cpp` sind reine
  Quelltextmuster. Sie werden rot, wenn die Hauptstelle zurückgenommen wird.
  Ob die Höhe stimmt ([E-165](../Intern/BEFUNDE.md#e-165)) oder ob das Kästchen den Schalter wirklich setzt
  ([E-139](../Intern/BEFUNDE.md#e-139), `CWarnDialog::DoDataExchange`, `guiutils.cpp:464ff.`), prüft keiner.
  K4 und K5 bleiben grün.
* `Extract.ps1` Region W schneidet von `^CString E136HtmlAusBstr\s*\(` bis
  zur ersten `}` in Spalte 0. Das ist die richtige Grenze. Beim Umbenennen
  bricht `Find-Line` ab, statt still eine leere Datei zu liefern (am
  Quelltext belegt). Der Funktionstest ruft damit wirklich die echte
  Funktion, und das ist der stärkste der fünf Tests.

## <a id="gegenprobe"></a>Gegenprobe

**Gemessen, 31.10.2026.** Eingesetzt per Perl (`<:raw`, 1 Treffer) in
`Eudora71/Eudora/TridentView.cpp`, direkt hinter
`szHTML = E136HtmlAusBstr( (BSTR) cbstrText );`:

    szHTML = CString( cbstrText );

Damit verliert `GetAllHTML` das Emoji wieder genau wie vor [E-136](../Intern/BEFUNDE.md#e-136). Ergebnis
von `RunTests.cmd`: **350 Tests, 350 bestanden, 0 fehlgeschlagen.** Danach
habe ich die Datei aus der Kopie zurückgeschrieben. `cmp` meldete keinen
Unterschied, und `git status` zeigte nur diesen Bericht.

Gegenprobe zur Gegenprobe: der Hauptagent hat gemessen, dass der Test rot
wird, wenn man den neuen Aufruf **ersetzt** („erwartet `&#128293;`, bekommen
`??`“). Beide Messungen zusammen zeigen: Der Test bewacht, dass die neue
Zeile dasteht. Ob danach noch etwas zerstört, prüft er nicht.

## <a id="haelt"></a>Was hält

**[E-136](../Intern/BEFUNDE.md#e-136), die Funktion selbst** (`TridentView.cpp:4024-4087`):

* **Länge und Puffer:** `GetBuffer( nBytes + 1 )`, dann `WideCharToMultiByte`
  mit `nBytes` und `ReleaseBuffer( nBytes )`. Das ist richtig, denn mit
  `nLaenge` statt `-1` wird kein Nullbyte mitgezählt (belegt).
* **Nullbyte im BSTR:** `wcslen` (`:4031`) hält am ersten eingebetteten
  Nullzeichen an. Das tat `CString = BSTR` vorher genauso, es ist also keine
  Verschlechterung. `get_htmlText` liefert ohnehin keines (Vermutung).
* **Ersatzpaare:** ein gültiges Paar ergibt **eine** Entität mit dem echten
  Codepunkt. Eine einzelne Hälfte ergibt eine Zahl (siehe K6). Belegt und
  vom Test gedeckt.
* **Codepage ≠ 1252:** bei Doppelbyte-Codepages reicht `aZeichen[8]`; ein
  Zeichen wird einzeln gewandelt und ergibt bis zu zwei Bytes (belegt).
  **Gemessen** mit `WideCharToMultiByte` und `WC_NO_BEST_FIT_CHARS` samt
  `lpUsedDefaultChar` auf diesem Rechner: `<p>a</p>` bei 1252, 65001 und 932
  je 8 Byte, `used=0`. `x🔥` bei 1252 und 932 `used=1` (der langsame Weg
  greift), bei 65001 5 Byte und `used=0`. Meine Gegenvermutung war, unter
  UTF-8 als Systemcodepage schlage der Aufruf fehl und **jedes** Zeichen,
  auch `<`, werde zur Entität. **Widerlegt.** Dass [E-101](../Intern/BEFUNDE.md#e-101) und [E-140](../Intern/BEFUNDE.md#e-140) solche
  Bytes dann als `windows-1252` ausweisen, ist ein eigenes, altes Thema.
* **Sehr lange Texte:** der langsame Weg ruft `WideCharToMultiByte` je
  Zeichen auf und hängt mit `Append` an. `CSimpleStringT` wächst um die
  Hälfte, das ist linear. Er läuft nur, wenn ein Zeichen fehlt. Kein Verlust,
  höchstens Zeit (Vermutung zur Größenordnung, nicht gemessen).
* **Wiedereinlesen:** die gespeicherte Entität wird beim nächsten Anzeigen
  vom Browser aufgelöst. Beim nächsten Strg-S liefert `get_htmlText` wieder
  das Zeichen und daraus wieder dieselbe Entität, der Weg ist stabil (belegt).
  Was hingegen über `Html2Text` geht, siehe K3.
* **Kein Best-Fit:** vorher machte `CString = BSTR` aus `Ā` still ein `A`.
  Jetzt wird es `&#256;`. Das ist eine Verbesserung, die niemand bestellt hat
  und die richtig ist.

**[E-165](../Intern/BEFUNDE.md#e-165)** `E165BoxHoehe` (`AutoCompleteSearcher.cpp`): Die Zeilenhöhe kommt
aus `GetItemRect` der ersten Zeile, und die Liste hat `LVS_NOCOLUMNHEADER`
(`:1501`), es fehlt also keine Kopfzeile in der Rechnung. Der Rahmen ist
Außen minus Innen von Box und Liste, `+1` für den Pixel aus `MoveWindow`. Die
Grenze aus der INI (Vorgabe 70, `EudoraRes.rc:6949`) gilt wie vorher, mit
mindestens vier Zeilen. Belegt; die Pixelwerte selbst hat der Hauptagent am
Prüfstand gemessen, ich nicht.

**[E-171](../Intern/BEFUNDE.md#e-171):** Die Sperre steht vor dem einzigen `if (bStartSearch)` der
Funktion (belegt).

**[E-139](../Intern/BEFUNDE.md#e-139):** `IDS_SPELL_NICHT_VORHANDEN` 8118 und `IDS_INI_WARN_SPELL_UNAVAILABLE`
11152 kommen in keinem Header ein zweites Mal vor (belegt). `NoteDialog`
(`guiutils.cpp:1147`) nimmt den Text als Formatstring; er enthält kein `%`.
Das Kästchen setzt den Schalter in `CWarnDialog::DoDataExchange` nur bei
**OK** (`guiutils.cpp:473-478`). Wer das Kästchen ankreuzt und mit Esc oder
dem Schließfeld geht, bekommt die Meldung beim nächsten Start wieder. So
verhält sich jeder Warndialog in Eudora; ich führe es nicht als Fund.

**[E-140](../Intern/BEFUNDE.md#e-140):** beide Textwege in beiden Fenstern laufen über
`E140TextFuerDatei`, der HTML-Weg nicht, und das ist so gewollt (belegt).
Ohne Kopfzeilen ergänzt der Kern bei Hochbytes `MIME-Version` und
`Content-Type` vor einer reinen Textdatei. Das ist die Entscheidung aus
[E-101](../Intern/BEFUNDE.md#e-101) („ergänzt wird nur, was der Leser
braucht“), kein neuer Fehler. **Eine Randbemerkung, Vermutung:** zeigt das
Nachrichtenfenster mit „Blah Blah Blah“ alle Kopfzeilen und sind sie
eingeschlossen, kann die Datei `Content-Transfer-Encoding: base64` oder
`quoted-printable` aus der Originalmail tragen. Ist der Rumpf reines ASCII,
lässt der Kern diese Zeile stehen. Er benennt nur um, wenn Typ, Zeichensatz
oder Multipart nicht passen (`msgutils.cpp`, Block 4a). Ein fremdes Programm
würde den bereits dekodierten Text dann noch einmal dekodieren. Nicht
gemessen. Das ist F2 aus [PRÜFER-37](PRUEFER-37.md) auf einem neuen Weg und
gehört zu [E-101](../Intern/BEFUNDE.md#e-101).

## Neue Kennungen

Vorgeschlagen: **E-178** für [K2](#k2) (Bearbeiten-Modus und Antwort auf
Markiertes wandeln mit `CString = BSTR`), **E-179** für [K3](#k3)
(`Html2Text` schneidet numerische Entitäten auf ein Byte). K1 ist eine
Fortschreibung von [E-136](../Intern/BEFUNDE.md#e-136), K4 von
[E-165](../Intern/BEFUNDE.md#e-165), K5 von [E-171](../Intern/BEFUNDE.md#e-171).
K6 betrifft nur die Tests. In `Intern/BEFUNDE.md` habe ich nichts eingetragen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | 350/350 Tests im Grundlauf. `E136HtmlAusBstr` verliert nichts: Länge, Puffer, Ersatzpaare, Doppelbyte, UTF-8-Codepage (gemessen) in Ordnung. [E-139](../Intern/BEFUNDE.md#e-139), [E-140](../Intern/BEFUNDE.md#e-140) und die Höhe in [E-165](../Intern/BEFUNDE.md#e-165) ohne Fund. | keine | nein |
| [K1](#k1) | *Speichern unter* aus dem Nachrichtenfenster: `.htm` ohne Kopfzeilen und jede `.txt` gehen über `GetMessageBody` (`TridentReadMessageView.cpp:2915`, `szMsg = cbstr`). Emoji wird `??` wie vor [E-136](../Intern/BEFUNDE.md#e-136). Fortschreibung [E-136](../Intern/BEFUNDE.md#e-136). | mittel (Verlust wie [E-136](../Intern/BEFUNDE.md#e-136), auf dem Normalfall von *Speichern unter*) | nein, aber [E-136](../Intern/BEFUNDE.md#e-136) nicht „behoben“ nennen, solange das offen ist; Gregor entscheidet |
| [K2](#k2) | Fett, Link usw. im Bearbeiten-Modus (`:2679/3207/3217/3338/3408/3411/3621/4058`) und Antwort auf Markiertes (`TridentView.cpp:3944`) machen das Emoji schon in der Anzeige zu `??`. Vorschlag E-178. | mittel | nein |
| [K3](#k3) | `Html2Text` und `EmoticonManager` nehmen von `&#128293;` nur das unterste Byte: `%` statt Emoji, 0x16 statt `Ж`. [E-136](../Intern/BEFUNDE.md#e-136) schreibt solche Entitäten jetzt selbst. Vorschlag E-179. | mittel (falsches Zeichen ohne Warnung) | nein |
| [K4](#k4) | [E-165](../Intern/BEFUNDE.md#e-165): Spaltenbreite zieht die Bildlaufleiste doppelt ab, wenn sie sichtbar ist. | niedrig (Aussehen) | nein |
| [K5](#k5) | [E-171](../Intern/BEFUNDE.md#e-171): *Search* von Hand mit leerem Feld zeigt weiter „internal error“; leerer Suchtext überschreibt das gespeicherte Kriterium in der INI. | niedrig | nein |
| [K6](#k6) | Tests: `TestE136` deckt 2 von 11 Umwandlungsstellen, eine zweite Zuweisung hinter dem neuen Aufruf bleibt grün (Gegenprobe); [E-139](../Intern/BEFUNDE.md#e-139)/[E-140](../Intern/BEFUNDE.md#e-140)/[E-165](../Intern/BEFUNDE.md#e-165)/[E-171](../Intern/BEFUNDE.md#e-171) sind reine Quelltextmuster. | niedrig (nur Tests) | nein |
