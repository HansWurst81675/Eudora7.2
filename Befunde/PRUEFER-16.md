# PRÜFER-16 — E-106, E-104, E-101 und der Prüfstand vor Paket 1.0.70

Stand: 17.09.2026. Geprüfter Commit: `ceab98f` (= `origin/main`), Quellstand
7.2.0.70. Eigener Zweig `wt/pruefer-1070` von `origin/main`, eigener
Arbeitsbaum `C:\Users\Gregor\Documents\github\Eudora7.2-wt-pruefer-1070`.
**Kein Quelltext geändert.** Nur diese Datei ist neu.

---

## Die Antwort in einem Satz

**Ja — aber nicht im Text, sondern über einen Absturz, und nicht mehr im
Hauptbaum.** In `origin/main` (`ceab98f`) läuft der neue E-106-Block auch auf
dem Weg `EMBED_PREPARE_IMAGE`, auf dem QUALCOMM ausdrücklich vor einem
*flüchtigen* Embed warnt; Gregor hat dort am 17.09.2026 um 21:23 mit 1.0.69
einen `EXCEPTION_ACCESS_VIOLATION` in `Paige32.dll` gemessen. Ein Absturz nimmt
jede offene, noch nicht gesicherte Nachricht mit — das ist der Weg, auf dem
Text verlorengeht.

**Im Hauptbaum liegt die Behebung schon, aber unversioniert** (der Wächter
`bAllowThreadedFetch &&`, dort als E-107 bezeichnet). Solange dieser Stand
nicht committet und im Paket ist, darf **1.0.70 nicht hinaus**.

Durch **E-104 geht kein Text verloren und wird nichts Falsches geschrieben** —
nachgerechnet, siehe Abschnitt 3. `SA.PutText(CopyText)` schreibt Byte für Byte
dasselbe wie vorher `SA.PutText(UnwrapText(CopyText))`.

---

## 0. Was ich gefahren habe

* `perl tools/befund-suchen.pl PgEmbeddedImage.cpp` → E-2 (anderer Ort,
  fortgeschrieben wird nichts), `ReadMessageDoc.cpp` → kein Eintrag.
* Testsammlung **selbst gebaut und gefahren** im eigenen Arbeitsbaum
  (MSBuild → `Tests\Build\Debug\EudoraTests.exe`):
  **171 Tests, 171 bestanden, 0 fehlgeschlagen.**
* Quelltext gelesen: `PgEmbeddedImage.cpp`, `ReadMessageDoc.cpp`,
  `msgutils.cpp`, `tocview.cpp`, `filtersd.cpp`, `Paige_io.cpp`,
  `PgTextExport.cpp`, `PGEXPORT.CPP` (beide Fassungen), `PGIMPORT.CPP`,
  `PGEMBED.C`, `PGHTMIMP.CPP`, `PGHTMEXP.CPP`, `TinyTest.cpp`, `TestE101.cpp`.

---

## 1. E-106 — `PgEmbeddedImage.cpp`, `PgLoadUrlImage`

### Zuerst das Gute: die Annahme hinter E-106 stimmt, und sie ist jetzt belegt

Der Commit sagt „Paige skaliert nicht" und nennt das nicht nachgewiesen. Es ist
nachweisbar, im Quelltext: `draw_meta_file`
(`Eudora71/PaigeDLL/PGSOURCE/PGEMBED.C:4085-4100`) verschiebt bei
`mapping_mode == MM_TEXT` — dem Vorgabewert, wenn das Feld 0 ist — nur den
Ursprung (`SetWindowOrgEx`) und spielt die Metadatei dann unverändert ab.
**Kein `SetViewportExtEx`, keine Skalierung.** Erst im `else`-Zweig (fremder
Abbildungsmodus) wird auf `target_rect` skaliert. Eine Datei, die größer ist als
die Angabe im HTML, wird also tatsächlich über ihren Kasten hinaus gezeichnet.
Die Ursachenbeschreibung von E-106 ist damit bestätigt.

### P-39 (DATENVERLUST über einen Absturz) — der Block läuft auf einem flüchtigen Embed

`Eudora71/Eudora/PgEmbeddedImage.cpp:657-757` in `ceab98f`:

    if ( nEchtHoehe > 0 && embed->height > 0 && nEchtHoehe > embed->height )

`eCallback` ruft `PgLoadUrlImage` an zwei Stellen (`:268` und `:280`). Über der
ersten steht QUALCOMMs eigene Warnung:

    // Don't allow threaded fetch, because we're being called with a
    // temporary embed_ptr
    PgLoadUrlImage( pg, image, embed_ptr, false )

Auf diesem Weg liest der neue Block `embed->height` und `embed->style` eines
flüchtigen Objekts und durchsucht damit das **ganze Dokument**
(`pgGetIndEmbed`, `UseMemory`/`UnuseMemory` je Treffer), um anschließend mit
`pgSetStyleInfo` **ins Dokument zu schreiben**.

Warum E-106 dort ankommt und E-103 nicht: `EMBED_PREPARE_IMAGE` ruft nur, wenn
`!(image->source_width && image->source_height)` — die *Quell*größe ist
unbekannt. Das schließt ein Bild mit `width`/`height` im HTML **nicht** aus:
`embed->height` ist dann 52, `source_height` aber noch 0. Genau diese Lage ist
E-106s Zielfall, und genau dort ist der Embed flüchtig. Der E-103-Block daneben
verlangt `embed->height == 0` und trifft die Lage deshalb seltener.

Gregors Messung an 1.0.69, 17.09.2026, 21:23, beim Antworten auf eine geöffnete
Nachricht: `EXCEPTION_ACCESS_VIOLATION in Paige32.dll at UnuseMemory()+0006,
ESI=FFFFFFFF`.

**Behoben, aber unversioniert.** Im Hauptbaum steht bereits

    if ( bAllowThreadedFetch &&
         nEchtHoehe > 0 && embed->height > 0 && nEchtHoehe > embed->height )

Ich habe den Wächter nachgerechnet, und er kostet E-106 nichts: für ein Bild
**mit** Maßangaben und gesetzten `source_*` ruft `EMBED_PREPARE_IMAGE` die
Funktion gar nicht erst; der Fall kommt über `EMBED_LOAD_IMAGE` mit
`bAllowThreadedFetch == true`. Der Wächter ist richtig.

**Was daraus folgt:** `origin/main` in seinem jetzigen Stand ist **nicht
paketfähig**. Der Stand aus dem Hauptbaum muss vorher committet sein.

### P-40 (Regressionsgefahr, gerechnet, nicht gemessen) — derselbe Wächter kann E-103 stilllegen

Der Hauptbaum setzt denselben Wächter zusätzlich vor den **E-103**-Nachtrag
(`:592-600`, `if ( bAllowThreadedFetch && pUrlImage->source_height > 0 )`). Das
ist folgerichtig — dieser Block schreibt ebenfalls ins Dokument —, hat aber eine
Nebenwirkung, die niemand gemessen hat:

* Ein Bild, dessen Datei **beim Vorbereiten schon da ist** (`cid:`-Anhang aus
  dem eigenen MIME-Speicher, `file://`), wird in `EMBED_PREPARE_IMAGE`
  vollständig geladen: `image_data` wird gesetzt.
* `EMBED_LOAD_IMAGE` prüft danach `if ( !image->image_data )`
  (`PgEmbeddedImage.cpp:279`) — und ruft **nicht mehr**.
* Mit dem Wächter läuft der Ascent-Nachtrag im Vorbereiten nicht, und ein
  zweiter Durchgang kommt nie. **Für eingebettete Bilder ohne Maßangabe wäre
  E-103 damit wieder offen.**

Für Bilder über `http://` bleibt alles richtig: dort findet das Vorbereiten
keinen Dateipfad, der Nachtrag geschieht beim Laden. Gregors neun
Kleinanzeigen-Bilder sind mit hoher Wahrscheinlichkeit dieser Fall — deshalb
fällt es an seinem Protokoll nicht auf.

**Die entscheidende Messung** (bitte an 1.0.70): eine Nachricht mit einem
**eingebetteten** Bild ohne `height`-Attribut öffnen und im Protokoll nachsehen,
ob

    E-103 Zeilenhoehe: pos=... ascent-vorher=... nachgezogen=1

noch erscheint. Erscheint sie nicht mehr, ist E-103 für diese Klasse
zurückgefallen. Der saubere Weg wäre dann, den Nachtrag aus `PgLoadUrlImage`
herauszulösen und ihn in `eCallback` bei `EMBED_LOAD_IMAGE` **auch dann** zu
fahren, wenn `image->image_data` schon steht:

    case EMBED_LOAD_IMAGE:
        if ( !image->image_data ) {
            if ( PgLoadUrlImage( pg, image, embed_ptr, true ) )
                return 0;
            else
                image->loader_result = 0xFFFF;
        }
        else
        {
            // Beim Vorbereiten geladen: dort war der Embed fluechtig
            // (P-39), hier ist er echt. Jetzt die Zeilenhoehe nachziehen.
            PgEmbedZeilenhoeheNachziehen( pg, image, embed_ptr );
        }
        break;

### P-41 (Anzeige, mittel) — die Suchschleife vergleicht **Zeiger**, nicht Kennungen

`PgEmbeddedImage.cpp:735-750`:

    if (embed->style == embed_ptrE->style)
        bFundE = true;

`style` ist in `pg_embed_rec` ein `style_info_ptr`
(`Eudora71/PaigeDLL/PGHEADER/PGEMBED.H:231`) — ein **Zeiger auf den
Stileintrag**, kein Schlüssel für dieses Bild. Zwei Bilder mit demselben
Stileintrag sind nicht unterscheidbar, und dass zwei Bilder denselben Stil
bekommen, ist bei E-106 der **Normalfall**: der HTML-Import setzt
`current_style.ascent = (short)image_record.source_height`
(`PGHTMIMP.CPP:2166`) — zwei Bilder mit derselben Maßangabe bekommen damit
denselben Stil.

Folge: die Schleife bleibt beim **ersten** Bild dieses Stils stehen. Dessen
Zeile wächst, die des zweiten nicht — der Text unter dem zweiten Bild bleibt
zugedeckt, und über dem ersten entsteht eine Lücke. Kein Datenverlust, aber der
Befund wird für einen Teil der Bilder nur scheinbar behoben. (Die Schleife
stammt im Kern von QUALCOMM; E-106 weitet ihren Anwendungsbereich von „Bilder
ohne Maßangabe" auf „fast jedes Bild jeder Werbemail" aus, und damit auch diese
Schwäche.)

Eindeutig ist nicht der Stil, sondern das Bild selbst. `pg_embed_rec.data` trägt
den `memory_ref` auf genau dieses `pg_url_image` — derselbe Zeiger, der als
`pUrlImage` hereinkommt (so identifiziert es auch `PgTextExport.cpp:75-85`):

    if (embed_ptrE)
    {
        if (embed_ptrE->data)
        {
            pg_url_image_ptr pBildE =
                (pg_url_image_ptr) UseMemory( (memory_ref) embed_ptrE->data );

            if (pBildE == pUrlImage)
                bFundE = true;

            UnuseMemory( (memory_ref) embed_ptrE->data );
        }

        UnuseMemory( erE );
    }

Bis dahin gehört in die Spurmarke, wie oft der Stil überhaupt passt — ein
einziger Zähler entscheidet die Frage an Gregors Protokoll:

    long nTrefferE = 0;   // in der Schleife: bei jedem Stiltreffer ++
    ...
    "... gefunden=%d treffer=%ld pos=%ld\r\n", bFundE ? 1 : 0, nTrefferE, posE

Steht dort je `treffer=2` oder mehr, ist P-41 belegt.

### P-42 (Robustheit, klein) — `(short) nEchtHoehe` kann das Vorzeichen kippen

`PgEmbeddedImage.cpp:784`:

    info106.ascent = (short) nEchtHoehe;

`nEchtHoehe` kommt aus `QCMetaFileInfo.height`, und das ist ein `long`
(`QCGraphics.h:11`). `style_info.ascent` ist ein `short` (`PAIGE.H:1736`). Ein
Bild über 32767 Punkt Höhe — lange Verlaufsgrafiken und Bildschirmmitschnitte
gibt es — ergibt einen **negativen** Ascent. Der Vergleich darüber
(`info106.ascent < nEchtHoehe`) rechnet in `long` und feuert dabei zuverlässig.
E-103 hat das Problem nicht, dort ist die Quelle schon ein `short`.

Vorschlag, eine Zeile:

    if ( nEchtHoehe > 30000 )
        nEchtHoehe = 30000;   // style_info.ascent ist ein short (PAIGE.H:1736)

unmittelbar vor der Bedingung in `:725`.

### P-43 (Messung, mittel) — die Spurmarke von E-106 liegt auf einem Kanal, den die Vorgabe abschaltet

`PgEmbeddedImage.cpp:762` schreibt über `PutDebugLog( DEBUG_MASK_MISC, ... )`.
`MISC` ist `0x8000`, die Vorgabe für `LogLevel` ist 25759 = `0x649F`
(`EudoraRes.rc:8443`) — das Bit ist **nicht** gesetzt. Genau dafür wurde
Stunden vorher `e227940` geschrieben („E-101-Spurmarke auf einen Kanal, der in
der Vorgabe AN ist"), und die Begründung steht ausführlich in
`tocview.cpp:3196-3215`.

E-106 ist der **am wenigsten belegte** Eingriff im Paket — der Commit sagt es
selbst: „NICHT NACHGEWIESEN … nur sein Lauf kann die Behebung belegen". Sein
einziger Beleg ist eine Zeile, die in der Vorgabe nicht geschrieben wird. Bei
Gregor steht MISC offenbar an (seine Protokolle tragen die E-95/E-103-Marken),
für jeden anderen Stand und nach jeder frischen INI ist die Behebung stumm.

In 25759 gesetzt sind nach `QCUtils/public/inc/debug.h:15-36` die Bits `0x01`,
`RCVD`, `NAV`, `DIALOG`, `PROG`, `TOC_CORRUPT`, `FILTERS`, `LMOS` und `SEARCH`;
einen eigenen Kanal für die Oberfläche gibt es nicht. Es bleibt dieselbe Wahl
wie bei E-101: `DEBUG_MASK_DIALOG` (0x08), mit einem Satz zur Begründung im
Quelltext — der Bildweg gehört zur Anzeige einer geöffneten Nachricht, und eine
Marke, die einen zugedeckten Text belegen soll, darf nicht abschaltbar sein.

### P-44 (Kosten, klein) — die Schleife läuft je Bild über alle Embeds

`selE.end = pg->t_length`, dann `pgGetIndEmbed` mit laufendem Index. Je Bild ein
voller Durchgang durch alle Embeds des Dokuments, dazu je Bild ein
`Invalidate()`. Bei Gregors neun bis siebenundzwanzig Bildern ist das nichts;
bei einem Prospekt mit einigen hundert Bildern wird daraus eine quadratische
Zahl von Schritten mitten im Seitenaufbau. Kein Grund zu handeln, aber der
Grund, die Schleife nicht noch einmal zu kopieren: sie steht jetzt **zweimal
wörtlich** in derselben Funktion (`:507-527` und `:729-751`). Eine gemeinsame
Hilfsfunktion (siehe P-40) erledigt P-40, P-41 und P-44 in einem Griff.

---

## 2. E-104, zweiter Teil — `ReadMessageDoc.cpp`

### Die Rechnung: schreibt der neue Code dasselbe?

**Ja.** `UnwrapText` (`msgutils.cpp:453-512`) endet auf `return (text);` — der
Rückgabewert **ist** das Argument. Damit ist
`Put(UnwrapText(X))` → `UnwrapText(X); Put(X)` eine Identität. Die Beweisführung
aus PRÜFER-15 (ein Puffer, kein Schreibzugriff unterhalb von `Beg`, Puffer wird
nie länger) gilt hier unverändert, weil es dieselbe Funktion ist.

### Der Fall „Kopfzeilen nicht mitspeichern" trifft — und ein Fall daneben

* `bKopfzeilen == FALSE`: `Text = FindBody(Text)` streift die Kopfzeilen ab,
  `pszRumpf = CopyText` entfaltet alles. **Richtig.**
* `bKopfzeilen == TRUE`, normale Nachricht: `Text` trägt die Kopfzeilen,
  `pszRumpf = FindBody(CopyText)` setzt hinter der Leerzeile auf. **Richtig.**

### Was die Umstellung trägt, und was dabei niemand nachgesehen hat

`FindBody` sucht `"\r\n\r\n"` (`msgutils.cpp:333-347`). Ob der Text auf diesem
Weg überhaupt LF trägt, entscheidet eine Stelle, die man leicht übersieht:
`SaveAsFile` nimmt den Text aus `PgReadMsgView::GetMessageAsText` → `GetTextAs`
→ `PgDataTranslator::ExportData` → `PaigeTextExportFilter`. Paige selbst hält
Zeilenenden **als einzelnes CR** (`PGIMPORT.CPP:937` „TranslateCrLf removes LFs
from stream since Paige doesn't want them"), und `EXPORT_EVERYTHING_FLAG`
(`0x00FFFFFF`) enthält `INCLUDE_LF_WITH_CR` (`0x02000000`) **nicht**.

Dass trotzdem CRLF herauskommt, hängt an einer einzigen Zeile in Eudoras
**eigener Kopie** des Ausgabefilters: `Eudora71/Eudora/PGEXPORT.CPP:51` setzt im
Konstruktor `export_bits |= INCLUDE_LF_WITH_CR;` — die Fassung in
`Eudora71/PaigeDLL/PGTXR/PGEXPORT.CPP` tut das nicht, und `Eudora.vcxproj:406`
übersetzt die eigene. **Ohne diese Zeile fände `FindBody` auf dem Lesefenster-Weg
nie eine Grenze, und „Absätze raten" liefe ersatzlos ins Leere.** Wer die
doppelte Datei einmal aufräumt, nimmt E-104 mit. Das gehört aufgeschrieben, und
deshalb steht es hier.

### P-45 (Mangel, mittel; kein Datenverlust) — `FindBody` läuft bei Teilnachrichten zweimal

`ReadMessageDoc.cpp:543-582`:

    if (!bKopfzeilen || m_Sum->IsSubPart())
        Text = FindBody(Text);
    ...
    char* pszRumpf = bKopfzeilen ? (char*) ::FindBody( CopyText ) : CopyText;

Bei `bKopfzeilen == TRUE` **und** `IsSubPart()` sind die Kopfzeilen oben schon
abgestreift — `CopyText` ist reiner Rumpf. Der zweite `FindBody` sucht dann die
nächste Leerzeile **im Rumpf** und setzt erst dort auf: der erste Absatz der
Nachricht wird nicht entfaltet. Hat der Rumpf gar keine Leerzeile, liefert
`FindBody` das Ende der Zeichenkette (`message + strlen(message)`), `*pszRumpf`
ist 0, und es wird **überhaupt nichts** entfaltet.

Geschrieben wird in beiden Fällen der vollständige Text — kein Verlust, aber die
Einstellung wirkt nicht. Die Bedingung muss einmal gerechnet und zweimal benutzt
werden:

    const BOOL  bKopfzeilen     = E104SchalterLesen( IDS_INI_INCLUDE_HEADERS );
    const BOOL  bTextHatKopf    = ( bKopfzeilen && !m_Sum->IsSubPart() );

    if (!bTextHatKopf)
        Text = FindBody(Text);
    ...
    char*   pszRumpf = bTextHatKopf ? (char*) ::FindBody( CopyText ) : CopyText;

`SaveAsFile` braucht das nicht: dort sagt `bKopf2` unmittelbar, ob
`GetMessageAsText` Kopfzeilen geliefert hat.

### P-46 (Altlast, klein) — `delete` auf einem `new[]`, und eine fehlende Prüfung

`ReadMessageDoc.cpp:637-665`:

    char *CopyText = ::SafeStrdupMT( msg );     // keine NULL-Pruefung
    ...
    delete CopyText;                             // zweimal, :656 und :661

`SafeStrdupMT` legt mit `new char[...]` an (`QCUtils/src/services.cpp:594`);
`delete` statt `delete []` ist undefiniert. Beides stammt von QUALCOMM, aber die
Zeilen wurden gerade angefasst. Dazu: schlägt die Anforderung fehl, liefert
`Put(NULL)` ein `S_OK` („successfully wrote nothing", `jjfile.cpp:920`) — der
Anwender bekommt **eine leere Datei und die Meldung, es sei gespeichert**.

    char *CopyText = ::SafeStrdupMT( msg );

    if ( CopyText == NULL )
        return (FALSE);
    ...
    delete [] CopyText;

### P-47 (Doku im Quelltext, klein) — der Kommentar beschuldigt eine richtige Zeile

`ReadMessageDoc.cpp:566-568` sagt: „Hier war `FindBody` sogar GENAU UMGEKEHRT
eingesetzt: es lief, wenn die Kopfzeilen NICHT mitsollten." Gemeint ist Zeile
546 — und die ist **richtig**: sind die Kopfzeilen nicht gewollt, streift
`FindBody` sie ab. Der alte Fehler war allein, dass `UnwrapText` danach über
*alles* lief. Ein Kommentar, der eine richtige Zeile als Fehler ausweist, führt
den nächsten Leser genau dorthin, wo nichts zu holen ist
(`Arbeitsweise/anzeige-ist-kein-zustand.md`). Der Satz gehört auf „`UnwrapText`
lief über die ganze Nachricht, auch über die Kopfzeilen" zurückgeschnitten.

---

## 3. E-101 nach `e27ccf1` / `db346ec` — ist einer meiner Fälle wieder aufgegangen?

**Nein.** Selbst gebaut, selbst gefahren, 171 von 171 grün; die Fälle P-18 bis
P-22 und die drei P-28-Fälle sind darunter. Zwei Werte habe ich von Hand
nachgerechnet, statt der Meldung „ok" zu glauben:

| Fall | Spurmarke im eigenen Lauf | Rechnung |
|---|---|---|
| P-28, Marker und Text auf derselben Zeile | `rumpf-vorher=74 rumpf-nachher=55` | 74 − 8 (`<x-html>`) − 9 (`</x-html>`) − 2 (CRLF) = **55** ✓ |
| P-20, führende Leerzeile | `bytes-vorher=22 nachher=22 geaendert=0` | 22 Byte rein, 22 raus, nichts angefasst ✓ |

Der neue `else`-Zweig (`msgutils.cpp:4214-4267`) hängt hinter
`if ( !szKopf.IsEmpty() )` und kann keinen der alten Fälle berühren: er läuft
nur, wenn **kein** Kopf vorhanden ist, und er schneidet nichts, er stellt voran.
Schritt 2 (Markerentfernung, P-18/P-19/P-28) und der Kopfzweig (P-21) sind
unverändert.

### P-48 (Entscheidung für Gregor, nicht Mangel) — jede deutsche Klartextnachricht bekommt jetzt drei Zeilen

Die neue Bedingung lautet `!bHatContentType && ( bWarHtml || bHochbyte )`.
`bHochbyte` ist wahr, sobald **ein einziges Byte ≥ 0x80** im Rumpf steht — also
bei jedem Umlaut. Aus dem eigenen Testlauf, wörtlich:

    E-101 speichern: kopfzeilen=0 ... typ=text/plain charset=ISO-8859-1
    bytes-vorher=17 nachher=119 rumpf-vorher=17 rumpf-nachher=17 mime-ergaenzt=1

Aus 17 Byte Text werden 119. Wer „Kopfzeilen einschließen" **aus** hat — nach
der E-104-Reparatur ist das Gregors Stand — und einen Textausschnitt sichert,
bekommt jetzt drei technische Zeilen über seinem Text, in einer `.txt`-Datei,
die er im Editor öffnet.

Für den HTML-Fall ist die Ergänzung richtig und notwendig (ohne Content-Type
zeigt jeder Leser Quelltext). Für den reinen Klartextfall ist es eine
**Entscheidung**, keine Behebung, und sie trifft im Deutschen praktisch jede
Nachricht. Dazu: `tocview.cpp:3060-3230` schreibt bei mehreren markierten
Nachrichten **alle in eine Datei** — dort stehen die MIME-Zeilen künftig mitten
im Text, einmal je Nachricht.

Zwei mögliche Wege, beide klein:

* nur bei `bWarHtml` ergänzen und beim Klartext nichts tun (die alte
  Entscheidung für Text beibehalten), oder
* beim Klartext statt der drei Kopfzeilen nichts schreiben und den Zeichensatz
  über den Dateinamen/den Dialog anbieten.

Gregor muss das entscheiden — es ist sein Speichern. Ich nenne nur die Zahl:
17 → 119.

---

## 4. TinyTest — stimmt der Fund, und sind frühere Belege betroffen?

**Der Fund stimmt, die Behebung ist richtig, und sie ist an meinem eigenen Lauf
nachgerechnet.**

`TT_BeginTest` merkt den Namen nur; gedruckt wird er in `TT_EndTest`. `TT_Note`
druckte vorher sofort — also **vor** dem Namen des eigenen Tests und damit
optisch unter dem Test davor. Im Lauf von eben steht jede Notiz unter ihrem
eigenen `[ok  ]`, und beide Rechnungen oben gehen auf. Der Puffer ist sauber:
der Überlaufzweig schreibt genau bis `sizeof(s_szNotes)-1` und setzt das
Abschlussbyte selbst, es kann kein Rest eines früheren Tests mitgedruckt werden.

**Ist früheren Belegen zu misstrauen?** Der Zuordnung ja, den Schlüssen nein.

* Jede Aussage der Form „unter Test *X* stand *Y*" aus PRÜFER-13/-14 und aus
  den Commit-Nachrichten davor ist **um einen Test verschoben** und darf nicht
  mehr wörtlich zitiert werden.
* Widerlegt wird dadurch keine meiner Feststellungen. Die Spurzeilen tragen ihre
  Eingangsgrößen selbst (`bytes-vorher`, `rumpf-vorher`, `xhtml`, `kopfzeilen`),
  der Lauf ist wiederholbar, und ich habe ihn eben wiederholt — jetzt richtig
  beschriftet, 171 von 171 grün, und die beiden nachgerechneten Werte stimmen.
* Der eine Beleg, den es wirklich erwischt hat, ist der, an dem der Fund
  gemacht wurde: `rumpf-vorher=74 rumpf-nachher=55` stand unter „P-21", gehört
  aber zu „P-28".

### P-49 (klein) — eine Notiz geht jetzt verloren, wenn der Lauf abbricht

`TT_Note` schreibt in einen Puffer, ausgegeben wird in `TT_EndTest` (oder in
`TT_Fail`). Stürzt der Prüfstand **innerhalb** eines Tests ab — und genau dann
braucht man die Notiz —, ist sie weg; vorher stand sie schon im Protokoll.
Der Prüfstand fährt geprüften Quelltext, Abstürze sind dort keine Theorie.
Behebung, ohne den Puffer aufzugeben: den Namen gleich in `TT_BeginTest`
ausgeben und in `TT_EndTest` nur noch das Ergebnis dahinter — dann braucht es
gar keinen Puffer. Wer den Puffer behalten will, meldet ihn über `atexit` ab.

---

## 5. Die alten offenen Punkte, kurz

* **P-8, P-9, P-10, P-12** (`PGHTMIMP.CPP`) — unverändert offen, seit PRÜFER-11
  bzw. -14 nichts daran geändert. P-10 (die feste Klemmung von
  `current_style.ascent/descent` in `ProcessEmbed`) hat durch E-103 und E-106
  an Gewicht gewonnen: drei Stellen stellen jetzt dieselbe Zeilenhöhe ein, eine
  beim Import und zwei beim Laden. **P-11 ist behoben** (`e28875c`).
* **M-3** (`filtersd.cpp:2048` und `:2083`) — **offen und jetzt schädlicher als
  vorher**:

      short ih = GetIniShort(IDS_INI_INCLUDE_HEADERS);   // :2048, roher Wert
      ...
      SetIniShort(IDS_INI_INCLUDE_HEADERS, ih);          // :2083, zurueck

  Der rohe Wert wird gesichert und zurückgeschrieben. Steht dort Gregors
  `16720`, macht diese Stelle die Reparatur von `E104SchalterLesen`
  (`msgutils.cpp:4331-4355`) bei jedem Filterlauf mit `%6` **rückgängig**. Eine
  Zeile:

      short ih = E104SchalterLesen( IDS_INI_INCLUDE_HEADERS ) ? 1 : 0;

* **Der `.htm`-Zweig ohne `<meta charset>`** — unverändert offen.
  `ReadMessageDoc.cpp:622-631` schreibt, was `GetMessageAsHTML` liefert, und der
  HTML-Ausgabefilter lässt `<head>` und `<title>` **bewusst** weg
  (`Eudora71/Eudora/PGHTMEXP.CPP:190-194`, QUALCOMM: „provide no value and just
  clutter things up"). Die Datei trägt damit Latin-1-Bytes ohne jede Angabe;
  jeder heutige Browser nimmt UTF-8 an und zeigt aus „gültig" etwas anderes.
  Das ist derselbe Befund wie E-101, nur für die andere Dateiendung, und E-101
  löst ihn für `.htm` nicht mit. Kleinster Eingriff, an der Schreibstelle statt
  im Filter:

      view->GetMessageAsHTML(msg, E104SchalterLesen( IDS_INI_INCLUDE_HEADERS ));

      // BEFUND E-101 fuer .htm: der Ausgabefilter schreibt kein <head>
      // (PGHTMEXP.CPP:190). Ohne Angabe nimmt jeder Browser UTF-8 an,
      // die Bytes sind aber Latin-1.
      {
          const int nHtml = msg.Find( "<html>" );

          if ( nHtml >= 0 )
              msg.Insert( nHtml + 6,
                  "<head><meta http-equiv=\"Content-Type\" "
                  "content=\"text/html; charset=ISO-8859-1\"></head>" );
      }

---

## 6. Was vor dem Paket 1.0.70 zu tun ist

1. **P-39 committen.** Der Wächter `bAllowThreadedFetch` liegt unversioniert im
   Hauptbaum. Ohne ihn stürzt 1.0.70 beim Antworten auf Nachrichten mit Bildern
   ab — gemessen an 1.0.69. Das ist die einzige Schranke, die zwingend ist.
2. **P-40 nachmessen**, sobald 1.0.70 läuft: eingebettetes Bild ohne
   `height`-Attribut öffnen, `E-103 Zeilenhoehe … nachgezogen=1` im Protokoll
   suchen. Fehlt die Zeile, ist E-103 für eingebettete Bilder zurückgefallen.
3. **P-43**: solange die E-106-Marke auf `DEBUG_MASK_MISC` liegt, muss Gregor
   `LogLevel` mit gesetztem MISC-Bit fahren, sonst belegt sein Lauf nichts.
4. P-41, P-42, P-45, P-46 und M-3 sind klein und können in einem Zug nach dem
   Paket laufen. P-48 ist eine Frage an Gregor, keine Arbeit.

Nichts davon außer Punkt 1 steht einem Paket im Weg.

---

## Nachtrag, 21:42 — Punkt 1 ist committet

Während dieser Bericht geschrieben wurde, hat die andere Sitzung den Wächter
als **`7d555df` („E-107: Absturz beim Antworten — von mir mit E-106
eingeschleppt", 1.0.71)** committet, auf `paketliste-glattziehen`. Sie hat den
Absturz unabhängig und schärfer belegt, als ich es konnte: die **letzte Zeile
vor dem Abbruch** in Gregors Protokoll ist die E-106-Spurmarke selbst —

    E-106 groesser als angegeben: attr=135x40 quelle=405x120 gefunden=1 pos=765

— danach nichts mehr. Damit ist P-39 nicht nur hergeleitet, sondern gemessen,
und `attr=135x40 quelle=405x120` ist zugleich der Beleg dafür, dass es die
Bilder mit Maßangabe sind, die auf dem Vorbereiten-Weg ankommen.

**P-39 ist damit erledigt**, sobald dieser Stand in `origin/main` steht.
**P-40 bis P-49 bleiben offen** — P-40 betrifft genau diesen neuen Wächter und
ist ohne Gregors Messung an einem eingebetteten Bild nicht zu entscheiden.
