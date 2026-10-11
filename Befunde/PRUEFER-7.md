# PRUEFER-7 — Filter: Ursachen der drei Befunde an 1.0.29 und Bestandsaufnahme

| | |
|---|---|
| Datum | 09.09.2026 |
| Arbeitsbaum | `C:\Users\Gregor\Documents\github\Eudora7.2-wt-pruefer` |
| Zweig | `wt/pruefer`, Stand von `main` nach Release 1.0.29 (`238cfec`) |
| Gemessen an | Gregors Laufverzeichnis `C:\Users\Gregor\Eudora72-1.0.29-release` — `Mailverzeichnis\eudora.log` (111 KB, sechs Sitzungen vom 09.09.2026), `Mailverzeichnis\Filters.pce`, `Eudora.exe` vom 09.09.2026 12:37 |
| Nicht getan | **nicht gebaut, kein Programm gestartet, keine Quelldatei geändert.** Geschrieben wurden nur diese Datei und der Nachtrag in `BEFUNDE.md` |

**Kurzfassung.** Die drei Befunde haben drei verschiedene Ursachen, und keine
davon liegt im Filterquelltext selbst: **die Filterdateien sind seit dem
Ursprungscommit unverändert.** Nachgezählt mit
`git log --oneline -- Eudora71/Eudora/filtersd.cpp filtersv.cpp
FiltersWazooWnd.cpp MakeFilter.cpp FilterReportView.cpp
FilterReportWazooWnd.cpp JunkMail.cpp filtersd.h filtersv.h` — genau **ein**
Commit, `567a5d8` („00 initial commit mit den original sourcen"). Was
schiefgeht, geht in der Umgebung schief, die diese Dateien benutzen.

Der schwerste Befund (alle Mails werden verschoben) ist am Protokoll
**nachgemessen**, nicht nur nachgelesen — und die Messung hat einen
**Widerspruch** aufgedeckt, den ich aus dem Protokoll allein nicht auflösen
konnte. Er steht unten offen, mit der einen Ausgabe, die ihn entscheidet.

---

## Teil A — die drei Befunde

### E-64 — Filter auf die ganze In-Mailbox verschiebt **alle** Nachrichten (Datenverlust)

Gregors Wortlaut: *„filter greifen (z.b. verschieben nach spam), aber wenn man
es z.b. auf die ganze in-mailbox anwendet, dann werden ALLE (!) mails
verschoben, nicht nur die, die gefiltert werden sollen."*

#### Was BELEGT ist — der Schaden ist am Protokoll nachgemessen

Sitzung vom 09.09.2026, 12:51:30, Fassung 7.2.0.29 (`eudora.log` ab Zeile 558).
Die Zeitangaben sind Minuten.Sekunden seit Sitzungsbeginn.

| Zeit | Protokollzeile | Bedeutung |
|---|---|---|
| 0.01 | `In .mbx size: MBX 1089243, TOC 1089244` | In.mbx hat **1 089 243** Byte |
| 0.12 | `Junk .mbx size: MBX 0, TOC 1` | **Junk.mbx ist leer — 0 Byte** |
| 4.06–4.10 | `Messages left to filter: 21` … `: 0` | Handfilterlauf über **22** Nachrichten |
| 4.11 | `JJFileMT::Open() …\Junk.mbx, Size: 1089243` | **Junk.mbx hat jetzt exakt 1 089 243 Byte** |

Die Zahl ist byte-genau die Größe, die In.mbx vor dem Lauf hatte. **Der ganze
Posteingang ist in den Junk-Ordner gewandert.** Das ist kein Bericht mehr,
das ist eine Messung. Danach hat Gregor zurückgeräumt: um 4.29 wächst In.mbx
beim Schreiben von 1 089 243 auf 2 004 290 Byte (+915 047).

Es gab drei Handläufe in dieser Sitzung: 3.50–3.51 über 2 Nachrichten,
4.06–4.10 über 22, 6.30–6.33 über 6. Die Zählzeilen stammen aus
`CTocFrame::OnFilterMessages` (`Eudora71/Eudora/TocFrame.cpp:2374`,
`CountdownProgress(CRString(IDS_FILTER_MESSAGES_LEFT), SelCount)`), es war also
der Handweg *Special ▸ Filter Messages*, nicht der Junk-Weg — dessen Zähltext
lautet `"Messages left to scan for junk: "` (`IDS_JUNK_MESSAGES_LEFT`,
`EudoraRes.rc:9651`) und kommt im ganzen Protokoll **nicht** vor.

#### Was BELEGT ist — die Filterdatei selbst ist in Ordnung

`Mailverzeichnis\Filters.pce` (779 Byte, geschrieben 13:16) enthält vier
Regeln, alle nach demselben Muster:

```
rule From:newsletter@service.freenet.de
transfer Junk.mbx
stop
incoming
manual
header From:
verb contains
value newsletter@service.freenet.de
conjunction ignore
header
verb contains
value
```

Das ist **wohlgeformt**: Kopfzeile `From:`, Operator `contains`, Wert die
Adresse, Verknüpfung `ignore` — die zweite, leere Bedingung wird damit gar
nicht ausgewertet (`filtersd.cpp:932-937`). Ich habe die Lesestrecke
(`CFiltersDoc::Read`, `filtersd.cpp:2526-2905`) Schlüsselwort für
Schlüsselwort gegen die Ressourcentexte geprüft: `"transfer "`
(`IDS_FIO_TRANSFER_TO`, `EudoraRes.rc:10574`) wird korrekt vor `"Xfer"`
(`IDS_FIO_TRANSFER`, `:10570`) getroffen, `"stop "` (`IDS_FIO_SKIP`, `:10571`)
ebenso, und `JJFileMT::ReadLine_` (`Eudora71/QCUtils/src/jjfile.cpp:812-865`)
schneidet CRLF sauber ab — **kein Wagenrücklauf bleibt am Wert kleben**. Nach
dem Lesen steht `m_Actions = {ID_FLT_TRANSFER, ID_FLT_SKIP_REST, NONE, NONE,
NONE}`, `m_Verb[0] = 0` (= `IDS_CONTAINS`) und `m_ServerOpt = -1` (Konstruktor,
`filtersd.cpp:283-288`).

Mit **dieser** Filterdatei dürften höchstens die vier genannten Absender in
Junk landen.

#### Was BELEGT ist — `CFilter::Action` **lief**, mit einer Aktion, die nirgends steht

Während des 22er-Laufs stehen im Protokoll vier LMOS-Schreibvorgänge
(Zeilen 927–949, Maske 8192 = `DEBUG_MASK_LMOS`):

```
MAIN  8192: 4.06 Writing single record of LMOS file for adventskalender-mails@freenet.de@mx.freenet.de
MAIN  8192: 4.06 Msg 4 hash 220195767 gmt 6AA13111 flags 0x1289 f R k s D
```

Diese Zeile entsteht an **genau einer** Stelle des Programms:
`CPopHost::WriteSingleLMOSRecord` (`pophost.cpp:481-493`). Ihr **einziger**
Aufrufer ist `CLMOSRecord::WriteLMOS` (`MsgRecord.cpp:991-995`), und dessen
**einziger** Aufrufer im ganzen Baum ist `filtersd.cpp:1166` — mitten im Zweig
`case ID_FLT_SERVER_OPT:` von `CFilter::Action` (`filtersd.cpp:1137-1168`).
Nachgezählt mit `grep -rn "WriteLMOS\|WriteSingleLMOSRecord"`: keine weitere
Aufrufstelle.

Daraus folgt zweierlei, und beides widerspricht der Filterdatei oben:

1. **`CFilter::Action` wurde ausgeführt.** `Action` wird an genau einer Stelle
   gerufen — `filtersd.cpp:2323`, unmittelbar hinter
   `if (filt->Match(text, Sum))`. Es hat also **gepasst**.
2. Der ausgeführte Zweig war `ID_FLT_SERVER_OPT` mit `m_ServerOpt > 0` — eine
   Aktion, die in Gregors Filterdatei **nicht steht** und die der Konstruktor
   auf `-1` setzt. Der Filter im Arbeitsspeicher trug also Aktionen, die weder
   aus der Datei noch aus einer Benutzereingabe stammen können. Dass nur vier
   der 22 Nachrichten eine Protokollzeile haben, ist kein Widerspruch: nur
   diese vier haben noch einen LMOS-Satz auf dem Server, für die übrigen 18
   liefert `LMOSRecord.GetMsgRecord()` `NULL` und es wird still nichts
   geschrieben. Der Zweig lief **für alle 22**.

**Das ist die eigentliche Spur:** die `CFilter`-Objekte im Arbeitsspeicher
weichen von der Datei ab. Wer sie verändert, tut es über den einzigen Weg, der
sie überhaupt anfasst — `CFiltersViewRight::DoDataExchange`
(`filtersv.cpp:1179-1440`) in Speicherrichtung. Und der wird **ungefragt**
angestoßen: `CFiltersWazooWnd::OnDeactivateWazoo` (`FiltersWazooWnd.cpp:122`)
ruft `GetFiltersDoc()->CanCloseFrame(NULL)`, und das ruft für die rechte
Ansicht `pView->UpdateData(TRUE)` (`filtersd.cpp:2058-2072`). Jedes Wegklicken
vom Filterreiter schreibt also den **Zustand der Steuerelemente** in den
Filter zurück: `filt->m_Verb[0] = m_Verb0`, `filt->m_Value[0] = m_Value0` und
`SaveIntoFilter(filt, m_ActionCommands[i], i)` (`filtersv.cpp:1425-1437`).
Stimmen die Steuerelemente nicht mit dem Filter überein, ist der Filter danach
falsch. Das verbindet **E-64 mit E-65**: derselbe Weg, ein Symptom in der
Anzeige, eins in den Daten.

#### Der offene Widerspruch — und die Ausgabe, die ihn entscheidet

Unmittelbar **vor** dem `Action`-Aufruf steht in derselben `if`-Klammer eine
Protokollzeile (`filtersd.cpp:2309-2318`):

```c
if (QCLogFileMT::DebugMaskSet(DEBUG_MASK_FILTERS))
{
    sprintf(szBuf, "Filter \"%s\" matches \"%s\"", szFilterName, Sum->GetSubject());
    PutDebugLog(DEBUG_MASK_FILTERS, szBuf);
}
```

**Diese Zeile steht im ganzen Protokoll kein einziges Mal.** Nachgemessen:
`grep -oE "^MAIN +[0-9]+:" eudora.log | sort | uniq -c` liefert die Masken
32896, 128, 16384, 16, 8192, 25759 und 2 — **1024 (`DEBUG_MASK_FILTERS`) ist
nicht dabei**. Und zwar nicht, weil die Maske ausgeschaltet wäre: die
Kopfzeile jeder Sitzung lautet `LogLevel 25759 (0x649F)`, und `0x649F`
enthält `0x400`. Die Gegenprobe steht direkt daneben:
`WriteSingleLMOSRecord` benutzt **dasselbe** Verfahren
(`DebugMaskSet(DEBUG_MASK_LMOS)` + `PutDebugLog`, `pophost.cpp:489-495`) und
schreibt. Auch der Formatstring steckt im ausgelieferten Programm —
`grep -a -o 'Filter "%s" matches "%s"' Eudora.exe` liefert einen Treffer.

Die zweite Marke in derselben Klammer, `Progress(-1, Sum->MakeTitle())`
(`filtersd.cpp:2308`), fehlt ebenfalls — die ist aber **erklärt und beweist
nichts**: `Progress(long, const char*, long)` kehrt sofort zurück, wenn
`ProgWin->CurrentObject()` `NULL` ist (`progress.cpp:568-571`), und
`CountdownProgress` legt kein `CProgressObject` an.

Bleibt der Widerspruch: **`Action` lief, aber die Trefferzeile davor wurde
nicht geschrieben.** Aus dem Protokoll allein ist das nicht aufzulösen — genau
die Lage, für die
[Arbeitsweise/zwei-werte-in-eine-ausgabe.md](../Arbeitsweise/zwei-werte-in-eine-ausgabe.md)
gilt. **Was als Nächstes einzubauen ist**, unbedingt in *einer* Zeile je
Nachricht und je Filter, direkt vor `if (filt->Match(text, Sum))`:

```
E-64 Filter='<m_Name>' Kopf0='<m_Header[0]>' Verb0=<m_Verb[0]> Wert0='<m_Value[0]>'
     Konj=<m_Conjunction> Akt=<m_Actions[0..4]> ServerOpt=<m_ServerOpt>
     Match=<Ergebnis> Betreff='<Sum->GetSubject()>'
```

Und zwar mit `DEBUG_MASK_MISC | DEBUG_MASK_TOC_CORRUPT`, **nicht** mit
`DEBUG_MASK_FILTERS` — die Maske, deren Wirksamkeit hier gerade in Frage
steht, darf die Messung nicht tragen. Diese eine Zeile schließt alle
Kandidaten unten auf einmal aus oder ein, und sie sagt, ob `Match` überhaupt
`TRUE` liefert.

#### Die Kandidaten, nach Wahrscheinlichkeit — alle **VERMUTUNG**

1. **Die Steuerelemente der rechten Filteransicht überschreiben den Filter**
   (siehe oben, `filtersv.cpp:1382-1437` und `filtersd.cpp:2058-2072`). Erklärt
   die fremde Aktion `ID_FLT_SERVER_OPT` und einen verstellten Operator in
   einem Zug. Steht `m_Verb[0]` danach auf 1 (`"doesn't contain"`), dreht
   `filtersd.cpp:911-917` das Ergebnis um, und **jede** Nachricht passt außer
   der, die gemeint war. Das ist genau Gregors Bild.
2. **Leerer Wert bei `contains`.** `strstr(text, "")` liefert einen Zeiger
   ungleich `NULL`, also `TRUE` (`filtersd.cpp:712-716`). Ein Filter, dessen
   Wert verlorengegangen ist, passt auf **alles**, was die Kopfzeile trägt.
3. **`m_Verb` außerhalb des Bereichs.** `DDX_CBIndex` liefert `-1`, wenn das
   Auswahlfeld keine Auswahl hat; `VERB_FIRST + (-1)` = 829 trifft in
   `MatchValue` keinen `case` — aber in `CFiltersDoc::Write`
   (`filtersd.cpp:3065-3068`, `Verbs[filt->m_Verb[0]]`) ist es ein
   **Feldzugriff daneben**.
4. Ein Weg zu `CFilter::Action`, den ich nicht gefunden habe. Ich halte ihn
   für unwahrscheinlich (ein einziger Aufrufer im ganzen Baum), aber der
   Widerspruch oben lässt ihn offen.

#### Zwei Härtungen, die unabhängig von der Ursache richtig sind

* `CFilter::MatchValue`, `case IDS_CONTAINS` (`filtersd.cpp:712`): bei leerem
  `value` **nicht** `TRUE` liefern. Ein Filter ohne Wert darf nichts treffen.
  Dasselbe für `IDS_IS`, `IDS_STARTS_WITH` und `IDS_ENDS_WITH`.
* Eine Schranke in `CTocFrame::OnFilterMessages`, die abbricht und meldet,
  wenn **ein** Filter mehr als einen bestimmten Anteil der bearbeiteten
  Nachrichten trifft. Ein Filter, der 22 von 22 trifft, ist im Zweifel kaputt
  und nicht scharf — und der Anwender bekommt seine Mails nicht zurück.

---

### E-65 — Filter lassen sich anlegen, aber nicht mehr bearbeiten

Gregors Wortlaut: *„filter kann man setzen, aber nicht mehr editieren."*

**Was BELEGT ist.** Seine `Filters.pce` enthält vier Regeln, davon **zwei
wortgleich** (`rule From:news@softmaker.software` steht zweimal, mit
identischen Bedingungen und Aktionen). Das ist das Bild eines Anwenders, der
eine Regel neu anlegt, weil er die vorhandene nicht ändern kann. Die Regeln
tragen die Namen, die `CFilter::SetName` (`filtersd.cpp:310-323`) aus
Kopfzeile und Wert erzeugt — sie stammen also aus *Special ▸ Make Filter*
(`CTocFrame::OnMakeFilter`, `TocFrame.cpp:2420-2445`), nicht aus dem
Filterfenster.

**Was ich NICHT klären konnte:** was „nicht editieren" genau heißt — bleibt
die rechte Hälfte leer, sind die Felder grau, oder wird die Änderung nicht
behalten? Das entscheidet zwischen den drei Kandidaten. **Die Frage an Gregor
ist genau diese**, und ein Bildschirmfoto des geöffneten Filterfensters
beantwortet sie sofort.

**Kandidat 1 (VERMUTUNG, am besten belegbar): die rechte Hälfte hat die Breite
null.** `CFiltersWazooWnd::OnActivateWazoo` (`FiltersWazooWnd.cpp:149-186`)
legt einen statischen Teiler mit zwei Spalten an und setzt

```c
m_wndSplitter.SetColumnInfo(0, nSplit, 0);   // nSplit = max(140, Fensterbreite/4)
m_wndSplitter.SetColumnInfo(1, 0, 0);        // Wunschbreite 0, Mindestbreite 0
```

Die linke Spalte bekommt also **mindestens 140 Pixel Wunschbreite**, die
rechte **null**. Ist der Wazoo-Bereich schmal — und Gregors Anordnung ist laut
Protokoll (`eudora.log`, E-44-Zeile der Sitzung 12:51) *„Postfaecher links,
Kurznamen versteckt, Aufgabenstatus waagrecht unten"*, also eine **angedockte
Leiste** —, bleibt für Spalte 1 nichts übrig. Die Mindestbreite von 420
Pixeln aus `OnGetMinMaxInfo` (`:249-255`) greift **nur für ein frei
schwebendes Fenster**, nicht für eine angedockte Leiste. Ergebnis: Liste
sichtbar, Bearbeitungsfelder unsichtbar. **Messung, die entscheidet:** das
Filterfenster losreißen (frei schwebend) oder die Leiste sehr breit ziehen —
erscheinen dann die Felder, ist der Kandidat belegt.

**Kandidat 2 (VERMUTUNG): die Ansichten werden nach einem Schließen nie wieder
angelegt.** `OnActivateWazoo` schützt sich mit

```c
static BOOL bFuncEntered = FALSE;
```

Das ist ein **funktionslokales `static`, also prozessweit** — nicht je Fenster.
Wird das Filter-Wazoo einmal zerstört und neu erzeugt, ist `bFuncEntered`
immer noch `TRUE`, der Teiler und beide Ansichten werden **nicht** neu
angelegt, und der Reiter zeigt eine leere Fläche. Dazu passt, dass Wazoo-Fenster
in dieser Portierung nachweislich zerstört und neu aufgebaut werden (E-53).

**Kandidat 3 (VERMUTUNG): stiller Abbruch nach der bekannten Fehlerklasse.**
Scheitert eine der drei Erzeugungen, lautet die ganze Fehlerbehandlung

```c
ASSERT(0);
return ; //-1;
```

(`FiltersWazooWnd.cpp:149-155`). Im Release-Bau ist das **ein leerer Zweig** —
kein Absturz, keine Meldung, ein leeres Filterfenster. Genau
[Arbeitsweise/assert-ist-im-release-nichts.md](../Arbeitsweise/assert-ist-im-release-nichts.md).
Dieselbe stille Rückkehr steht ein zweites Mal in `:169` (unplausibler
gespeicherter Teilerstand) und in `CFiltersViewLeft::OnInitialUpdate`
(`filtersv.cpp:176-182`) sowie `CFiltersViewRight::OnInitialUpdate`
(`:963-969`) — beide brechen mit `ASSERT(0); return;` ab, wenn sie ein zweites
Mal gerufen werden, und `SendMessageToDescendants(WM_INITIALUPDATE, …)`
(`FiltersWazooWnd.cpp:189`) kann genau das auslösen.

**Härtung, unabhängig von der Ursache:** die vier `ASSERT(0)`-Zweige im
Filterfenster durch Spurmarken ersetzen (`PutDebugLog`, `ASSERT` daneben
stehen lassen — [dummy-statt-weglassen]), und `SetColumnInfo(1, …)` eine echte
Mindestbreite geben.

---

### E-66 — der Trennbalken der **rechten** Leiste ist sichtbar, lässt sich aber nicht ziehen

Gregors Wortlaut: *„rechts ist zwar ein balken sichtbar, aber nicht
verschiebbar."* Links geht es seit A-4 (E-49, E-52, E-54, E-55).

**Ursache 1 (BELEGT, wirksam): rechts entsteht überhaupt kein
Trennbalken-Objekt.** `TrennbalkenNeuAnlegen` in
`Eudora71/OTShim/OTShim.cpp` misst den freien Streifen je nach Andockleiste:

```c
case AFX_IDW_DOCKBAR_RIGHT:  nFrei = rectLeiste.left - rect.left;     break;   // Zeile 4165
...
if (nPos >= 0 && !rect.IsRectEmpty() && nFrei >= 2)                            // Zeile 4174
```

`CDockBar::CalcFixedLayout` der MFC
(`…\MSVC\14.38.33130\atlmfc\src\mfc\bardock.cpp:387`) setzt den Startpunkt für
die Kindleisten **in jeder** Andockleiste auf
`CPoint(-afxData.cxBorder2, -afxData.cyBorder2)` und beginnt jede weitere
Spalte wieder dort (`:522`/`:526`). Die Ausrichtung `CBRS_ALIGN_RIGHT`
bestimmt nur, wohin der **Rahmen** die Andockleiste legt, nicht, wo die
Kindleiste in deren Clientbereich sitzt. Der Zuschlag von `3*Splitter::cx = 12`
aus `SECDockBar::CalcFixedLayout` (`OTShim.cpp:3017-3028`) bleibt darum immer
am **großen** Ende des Clientrechtecks liegen:

* **links** ist das die Innenkante zum MDI-Bereich → `nFrei = rect.right -
  rectLeiste.right ≈ 7` → Balken entsteht → funktioniert;
* **rechts** ist es die **Außenkante zum Fensterrand**, der Code misst aber bei
  `rect.left`: `nFrei = -2 - 0 = -2` → die Bedingung `nFrei >= 2` ist falsch →
  `AddSplitter` (`:4182-4185`) läuft nie → `m_arrSplitters` bleibt für die
  rechte Leiste leer → `HitTest` (`:3565-3578`) liefert `NULL`,
  `OnLButtonDown` (`:4033`) und `OnSetCursor` (`:4004`) reichen durch. Nichts
  zu greifen;
* **unten** ist es dieselbe Rechnung (Zeile 4166).

`BrauchtGreifstreifen` (`:2966`) und die Bedingung `nVorhanden > 8` (`:3017`)
sind für links und rechts **identisch** — die Spur „andere Bedingung für
rechts" ist damit **widerlegt**. Der Platz wird sehr wohl geschaffen, nur an
der falschen Kante. Passend dazu die schon gemessene Beobachtung aus
`Befunde/PRUEFER-6.md`, Abschnitt 5(d): oben blieben *„netto rund 8 Pixel
leerer Streifen unter der Werkzeugleiste"* — derselbe Streifen am max-Ende.
**VERMUTUNG:** was Gregor rechts als „Balken" sieht, ist genau dieser
Leerstreifen zwischen Leiste und Fensterrand.

**Ursache 2 (BELEGT, heute verdeckt): die Ziehgrenzen für rechts und unten
sind sinnverkehrt.** `CalcTrackingLimits` (`OTShim.cpp:3622-3623`, waagrecht
`:3637-3638`):

```c
pSplitter->m_nMin = rectRahmen.left  + nMindest;
pSplitter->m_nMax = rectRahmen.right - nFreiraum;
```

`rectRahmen` ist der Rahmen-Clientbereich, umgerechnet in Clientkoordinaten
**dieser** Andockleiste (`:3607`). Für eine rechte Leiste der Breite ~190 bei
Fensterbreite W ergibt das `rectRahmen.left ≈ -(W-190)` und
`rectRahmen.right ≈ 190`, also `m_nMax = 190 - 200 = -10`. Der Balken läge bei
`x ≈ 0…7`, der ganze zulässige Bereich liegt **links davon**, und
`Splitter::Track` klemmt jede Mausbewegung (`:3938-3939`) sofort fest.
Ergebnis wäre exakt „sichtbar, lässt sich nicht verschieben". Richtig wäre für
rechts/unten `m_nMin = rectRahmen.left + nFreiraum` und
`m_nMax = rectRahmen.right - nMindest`. `QCDockBar::CalcTrackingLimits`
(`Eudora71/Eudora/DockBar.cpp:149`) verschärft nur und nur im Adware-Modus, es
kann das nicht heilen.

**ASSERT/VERIFY/ENSURE spielen hier keine Rolle** — der Weg läuft still durch
eine gewöhnliche Bedingung, im Debug-Bau genauso wie im Release-Bau. Deshalb
ist es nie aufgefallen.

**Messung, die zwischen beiden Ursachen entscheidet, ohne Bau und in fünf
Sekunden:** den Mauszeiger über den rechten Streifen halten. Bleibt er der
normale Pfeil, gibt es kein Splitter-Objekt → **Ursache 1**. Wird er zum
Doppelpfeil, gibt es eins → **Ursache 2**. **Kostenlose Gegenprobe:** nach
derselben Rechnung muss auch der **untere** Trennbalken tot sein. Lässt der
sich ziehen, ist meine Herleitung falsch.

**Umfang der Behebung:** eine Datei (`OTShim.cpp`), zwei Funktionen.
`CalcTrackingLimits` (`:3593-3643`): Fallunterscheidung nach `GetDlgCtrlID()`,
`nMindest`/`nFreiraum` für rechts/unten tauschen — 8 bis 12 Zeilen.
`TrennbalkenNeuAnlegen` (`:4110-4198`): 20 bis 35 Zeilen, mit einer
Entscheidung dazwischen — entweder `nFrei` für rechts/unten am tatsächlichen
Ort messen (dann sitzt der Griff zwischen Leiste und Fensterrand, und die
Vorzeichen in `OnSplitterMoved`, `:3696`/`:3704`, müssen neu geprüft werden),
oder in `OnSize` (`:4094`) die Kindleiste für rechts/unten um `nFrei` nach
innen versetzen, sodass der Streifen an der Innenkante liegt und Balkenlage
wie Vorzeichen bleiben wie links. Das Zweite ist ergonomisch richtig.
`mainfrm.cpp` und `DockBar.cpp` sind **nicht** zu ändern: `CMainFrame::
EnableDocking` (`mainfrm.cpp:2181-2199`) legt alle vier Andockleisten als
`QCDockBar` an, die Kette ist geschlossen.

---
## Teil B — Bestandsaufnahme der Filterfunktionen

Der Umfang ist aus der Quelle erhoben, nicht aus einer Liste von Hand:
Ausgangspunkt waren `filtersd.cpp/.h`, `filtersv.cpp/.h`, `FiltersWazooWnd.cpp`,
`MakeFilter.cpp`, `FilterReportView.cpp`, `FilterReportWazooWnd.cpp`,
`JunkMail.cpp` sowie alles, was sie ruft (`resource.h`, `EudoraRes.rc`,
`pop.cpp`, `sendmail.cpp`, `SMTPSession.cpp`, `TocFrame.cpp`, `msgdoc.cpp`,
`SearchView.cpp`, `Trnslate.cpp`, `EuImap/src/ImapFiltersd.cpp`).

### B.0 Die Zahlen

| Gegenstand | vorhanden | davon wirksam | Beleg |
|---|---|---|---|
| Kopfzeilen zur Auswahl | 15 IDs | **10** (fünf `IDS_FHEADER_FUTURE_*` haben keinen Text) | `resource.h:496-510`, `EudoraRes.rc:9271-9276, 9659-9662`, Aufklappfeld `filtersv.cpp:1045` |
| Vergleichsoperatoren | 16 | **16** (14 allgemein, 2 nur für Junk-Score) | `filtersd.h:29-34`, `resource.h:511-526` |
| Verknüpfungen | 4 | **4** (`ignore`, `and`, `or`, `unless`) | `filtersd.h:36-38`, `filtersd.cpp:932-951` |
| Aktionen | 22 IDs | **19** Aktionen + `None`; 2 × `FUTURE` unbenutzt | `resource.h:4250-4271`, Aufklappfeld `filtersv.cpp:984` |
| Aktionen mit eigenem Zweig in `CFilter::Action` | 19 von 20 | `ID_FLT_NOTIFY_USER` hat **keinen** eigenen Zweig | `filtersd.cpp:1094-1480` |
| Aktionsplätze je Filter | 5 | 5 | `NUM_FILT_ACTS`, `filtersv.h:39` |
| Filterlisten | 3 | 3 (Vor-, Haupt-, Nachfilter) | `filtersd.cpp:3460-3467` |
| Anwendungsstellen | 12 | 11 vollständig, 1 mit auskommentierter Lücke | siehe B.3 |

**Nichts davon ist eine Attrappe der Ersatzschicht.** Der Filterkern enthält
**keine einzige `SEC*`-Klasse**; `CFiltersWazooWnd` und
`CFilterReportWazooWnd` erben von `CWazooWnd`, und das ist ein schlichtes
`CWnd` (`WazooWnd.h:16`). Erst der **Behälter** `CWazooBar` erbt von
`SECControlBar` (`WazooBar.h:60`). Auch der reguläre Ausdruck ist echt:
`MatchesRegex` benutzt POSIX-`regcomp`/`regexec` aus `hsregex`
(`filtersd.cpp:364-380`), kein leerer Rumpf. **Durch die Ersatzschicht ist an
den Filtern nichts verlorengegangen** — mit einer Ausnahme, die kein
Filterproblem ist, sondern das Rahmenfenster betrifft (E-65, E-66).

**Die Shareware-Schranke greift in diesem Bau nicht.**
`CFilter::IsRestrictedFilterAction` (`filtersd.cpp:1032-1076`) würde im
Modus `SWM_MODE_LIGHT` **12 der 19 Aktionen** sperren (Label, Personality,
Sound, Speak, Open, Print, Notify User, Forward, Redirect, Reply, Server
Options, Junk). `Eudora.vcxproj:78` und `:132` setzen aber
`BUILD_BOX_OR_SITE_R_VERSION`, damit ist `DEFAULT_SWM_MODE = SWM_MODE_PRO`
(`QCSharewareManager.h:54-59`) und `UsingFullFeatureSet()` liefert `true`
(`:79`). Gregors Protokoll bestätigt das: jede Sitzung schreibt `Mode 2`.

### B.1 Bedingungen — was Eudora 7.1 kann und was davon da ist

Zehn Kopfzeilen: `To:`, `From:`, `Subject:`, `Cc:`, `Reply-To:`, `«Any
Header»`, `«Body»`, `«Any Recipient»`, `«Personality»`, `«Junk Score»`. Das
Feld ist ein **beschreibbares** Aufklappfeld, jede andere Kopfzeile kann
eingetippt werden (`CFilter::MatchCondition`, `filtersd.cpp:897`,
`strnicmp`-Vergleich gegen den Kopfzeilennamen). Alle zehn werden ausgewertet:
Junk Score `:818`, Body `:824`, Any Header `:835`, Any Recipient `:837`,
Personality `:839`.

Sechzehn Operatoren: `contains`, `doesn't contain`, `is`, `is not`, `starts
with`, `ends with`, `appears`, `doesn't appear`, `intersects nickname`,
`doesn't intersect nickname`, `intersects address book`, `doesn't intersect
address book`, `matches regexp (case insensitive)`, `matches regexp` — dazu
`is less than` und `is greater than`, die **ausschließlich** für den Junk-Score
gelten (`filtersd.cpp:686`, `:690`; Feldfüllung `RefreshVerbCombo`,
`filtersv.cpp:1152-1177`).

Zwei Bedingungen je Filter, verknüpft mit `ignore` / `and` / `or` / `unless`
(`filtersd.cpp:932-951`). `ignore` heißt: die zweite Bedingung wird gar nicht
ausgewertet — so stehen Gregors vier Regeln in der Datei.

### B.2 Aktionen — 19, davon 18 mit eigenem Zweig

Make Status, Make Priority, Make Label, Make Personality, Make Subject, Play
Sound, Speak, Open, Print, Notify User, Notify Application, Forward To,
Redirect To, Reply with, Server Options, Copy To, Transfer To, Junk, Skip
Rest. **Kein Zweig ist leer oder auskommentiert.**

Die eine Ausnahme: **`ID_FLT_NOTIFY_USER` hat in `CFilter::Action` keinen
`case`.** Die Wirkung entsteht nur mittelbar über das Feld `m_NotfyUserNR`
(`filtersd.cpp:1434`, `:1501-1504`, `:1525`), und alle drei Abfragen hängen an
`if (bDidFiltAction)` (`:1495`) bzw. zusätzlich an `bDidMoveAction` (`:1501`).
**„Notify User" als einzige Aktion eines Filters bleibt damit vollständig
wirkungslos** — kein Zweig setzt `bDidFiltAction`. Zusammen mit
Transfer/Copy/Junk wirkt sie. Das entspricht vermutlich der Absicht des
Originals, ist im Aktionsraster aber ein Loch.

### B.3 Wo gefiltert wird — 12 Stellen

Einziger Einstieg ist `CFilterActions::FilterOne` (`filtersd.cpp:3449-3487`),
das `CFiltersDoc::FilterMsg` dreimal ruft: Vorfilter, Hauptfilter, Nachfilter.

| Anlass | Stelle | vollständig? |
|---|---|---|
| eingehend, POP | `pop.cpp:919` / `:950` / `:999` / `:1018` | ja |
| ausgehend, SMTP | `sendmail.cpp:113` / `:186` / `:317` | ja |
| ausgehend, Vorabfrage | `SMTPSession.cpp:114` (nur „gibt es Ausgangsfilter?") | ja |
| **manuell, Postfachfenster** | `TocFrame.cpp:2351` / `:2377` / `:2398` / `:2417` | ja — **das ist Gregors Weg (E-64)** |
| manuell, einzelne Nachricht | `msgdoc.cpp:783` / `:792` / `:796` | ja |
| Junk neu bewerten (Nachricht / Auswahl) | `msgdoc.cpp:816`, `TocFrame.cpp:991` → `JunkMail.cpp:535` | ja |
| Junk-Status ändern (Nachricht / Auswahl) | `msgdoc.cpp:894`, `TocFrame.cpp:1151` → `JunkMail.cpp:742` | ja |
| **Suchfenster, „Nicht Junk"** | `SearchView.cpp:3686` / `:3722` / `:3751` | **nein** |
| IMAP | `EuImap/src/ImapFiltersd.cpp:425`, `TocFrame.cpp:2365` → `ImapToc.cpp:3679` | teilweise |

**Lücke im Suchfenster (BELEGT):** `SearchView.cpp:3722` ruft
`CJunkMail::DeclareJunk( pSum, ..., &oaABHashes, NULL/*&filt*/ )` — das
Filterobjekt ist **auskommentiert**. In `DeclareJunk` (`JunkMail.cpp:739`)
läuft `FilterOne` nur bei `pFilt != NULL`. „Nicht Junk" aus dem Suchfenster
verschiebt die Nachricht also **ohne** Filterlauf nach In, während derselbe
Befehl aus einem Postfach vorher filtert. Zusätzlich wird
`filt.EndFiltering()` (`:3751`) auch dann gerufen, wenn `StartFiltering` nie
lief.

**Einschränkung bei IMAP (BELEGT):** im Zweig `bSearchOnServer` arbeitet
`ImapFiltersd.cpp:392` nur mit `m_Filters` — Vor- und Nachfilter werden dort
übersprungen. `EuImap/src/ImapFiltersd.cpp` ist übrigens die **einzige** Datei
des Filterwegs, die überhaupt angefasst wurde (`03c94fe`, zwei Zeilen,
`std::auto_ptr` → `std::unique_ptr`).

### B.4 Filterdateien — was geschrieben und was gelesen wird

`Filters.pce` im Mailverzeichnis (`IDS_FIO_FILENAME`, `EudoraRes.rc:9704`),
Zwischendatei `Filters.tmp`. Dazu Zusatzfilter im Unterverzeichnis `Filters`
mit den Endungen `.pre` und `.pst` (`CFiltersDoc::LoadExtraFilters`,
`filtersd.cpp:2371-2403`) — Gregors `Filters`-Verzeichnis ist leer.

Der Schlüsselwortbereich umfasst **32** Wörter (`IDS_FIO_RULE` 3774 bis
`IDS_FIO_JUNK` 3805). **30 werden gelesen, 28 geschrieben.** Die vier
Einbahnstraßen, einzeln bewertet:

* `raise` / `lower` — **unschädlich.** `Read` erkennt die Werte auch aus
  `priority N` (`filtersd.cpp:2629-2632`), `Write` gibt genau diese Zahl aus
  (`:3197`). Der Rundlauf bleibt heil.
* `none` (`IDS_FIO_NONE`) und `Xfer` (`IDS_FIO_TRANSFER`) — **tot in beide
  Richtungen.** Kein Datenverlust, nur zwei nutzlose `CRString`-Ladungen je
  `Write`-Aufruf (`:3047`, `:3061`).
* `copyInstead ` (`IDS_FIO_COPY_TO`) und die Pfadzeile hinter `transfer ` —
  **echter Datenverlust.** Siehe **E-68** unten.

**`Write()` speichert nur `m_Filters`** (`:3084`). `m_PreFilters` und
`m_PostFilters` werden nie geschrieben — und in `filtersv.cpp` kommen sie
**kein einziges Mal** vor. Die `.pre`/`.pst`-Dateien sind also reine
Nur-Lese-Erweiterungsfilter, die im Filterfenster **unsichtbar** sind. Das ist
Absicht des Originals, gehört aber gewusst.

### B.5 Filterbericht und „Filter erzeugen"

**Filterbericht** (`FilterReportView.cpp`, 431 Zeilen): drei Spalten
(Postfach / Anzahl / Zeit), Sortierung nach allen dreien mit Umschaltung
auf-/absteigend (`:40`, `:62`, `:84`, `:332-388`), Doppelklick und
Eingabetaste öffnen das Postfach (`:391-411`, `:419-429`). Eintragung aus
`CFilterActions::EndFiltering` (`filtersd.cpp:3580`). Die Liste lebt **nur in
der Sitzung** und wird beim Beenden verworfen (`eudora.cpp:2095-2098`). Das
einzige leere Stück, `OnDraw` (`:159-162`), ist bei einer `CListView` richtig
so. **Aber:** fehlt das Wazoo-Fenster, greift `FilterReportWazooWnd.cpp:65`
`ASSERT(0)` — im Freigabebau ein stiller Ausfall, `GetFilterReportView()`
liefert `NULL`, `EndFiltering` überspringt die **gesamte** Berichtsausgabe
wortlos und `ClearAllLists()` (`filtersd.cpp:3618`) wirft die gesammelten
Einträge weg.

**Filter erzeugen** (`MakeFilter.cpp`, 915 Zeilen; Aufruf aus `msgdoc.cpp:1331`
und `TocFrame.cpp:2420`): deckt **3 von 10** Kopfzeilen ab (Subject, From,
Any Recipient — `:466-489`) und **3 von 19** Aktionen (neues Postfach,
vorhandenes Postfach, Papierkorb — `:491-533`, alle über `SetTransferMBOX`,
das zusätzlich `Skip Rest` setzt). Der Operator wird **nie** gesetzt; es bleibt
beim Vorgabewert `m_Verb[0] = 0` = `contains` aus dem Konstruktor. Kein
Operator, keine zweite Bedingung, keine Verknüpfung. `OnOK` und `OnDetails`
rufen `CreateFilterItem` (`filtersd.cpp:2181-2192`), das sofort schreibt. Der
Weg ist vollständig — die Beschränkung auf 3 von 19 Aktionen ist Absicht des
Originals und genau der Grund, warum man **danach** ins Filterfenster muss
(E-65).

### B.6 Junk-Mail

Vier Berührungspunkte, alle ausprogrammiert: Junk-Score als Bedingung
(`filtersd.cpp:679-694`), `ID_FLT_JUNK` als Aktion (`:1454-1476`), die
Weißliste über dieselben Adressbuch-Streuwerte wie die
„intersects address book"-Operatoren (`JunkMail.cpp:163/198/224`,
`filtersd.cpp:392-521`) und die Anbindung der Erweiterungen über EMSAPI
(`Trnslate.cpp:4896-5052`, vier Aufrufstellen). **Kein Stub.**

### B.7 Die drei größten Lücken der Bestandsaufnahme

1. **E-67 — der Junk-Score-Operator „is less than" wird beim bloßen Anschauen
   zu „matches regexp".** Belegt durch Nachrechnen: `filtersv.cpp:1210` und
   `:1222` prüfen `if (m_Verb0 > NumVerbsNonJunk)` mit `NumVerbsNonJunk == 14`,
   kodiert wird beim Speichern aber mit `m_Verb0 += 14` (`:1378`), also
   „is less than" → **14**. `14 > 14` ist falsch, die Rückrechnung unterbleibt,
   `DDX_CBIndex` ruft `SetCurSel(14)` auf ein Feld mit **zwei** Einträgen →
   `CB_ERR`. Beim nächsten `UpdateData(TRUE)` liest `DDX_CBIndex` `-1`,
   `:1378` macht daraus `-1 + 14 = 13`, und `:1413` schreibt das in den Filter:
   `IDS_MATCHES_REGEX`. Weil sich der Wert unterscheidet, setzt `:1404` das
   Änderungskennzeichen — der verfälschte Filter wird **gespeichert**. Danach
   greift er nie wieder (`MatchValue` verlangt für Junk-Score-Köpfe
   `IDS_LESS_THAN`/`IDS_MORE_THAN`, `filtersd.cpp:679-694`). Behebung: zwei
   Zeichen, `>` → `>=` an zwei Stellen.
2. **E-68 — Zielpostfächer verschwinden beim Speichern.** Zwei Wege:
   `copyInstead ` wird gelesen (`filtersd.cpp:2746`, füllt aber `m_Mailbox`
   statt `m_CopyTo[i]`; der Quelltext nennt das selbst „legacy code that never
   gets executed"), und der Schreibzweig prüft `m_CopyTo[i]` (`:3120`) — also
   wird nichts geschrieben. Und beim Transfer steht das **Schlüsselwort** unter
   `if (filt->IsTransferTo())`, die **Pfadzeile** darunter aber nicht
   (`:3132-3133`); nach einer ausgeführten Copy-Aktion, die `SetCopyTo()` auf
   demselben Filterobjekt hinterlässt (`:1369`, IMAP `:1764`), entsteht eine
   kennungslose Zeile, die `Read` verwirft (`:2599-2600`). Dazu die **fehlende
   Grenzprüfung**: `Read` zählt den Aktionszähler `i` in 19 Zweigen hoch, ohne
   je gegen `NUM_FILT_ACTS` (= 5) zu prüfen — im ganzen Bereich `:2526-2907`
   kommt die Konstante nicht vor. Eine von Hand oder von einer Erweiterung
   erzeugte `.pre`-Datei mit sechs Aktionen schreibt über `m_Actions[5]`
   hinaus.
3. **E-69 — drei `ASSERT(0)` in `CFiltersDoc::FilterMsg` brechen den
   Filterlauf im Freigabebau lautlos ab.** `:2241` (kein TOC), `:2286`
   (Nachrichtendokument nicht ladbar), `:2302` (Nachrichtentext leer) führen
   alle auf `break` aus der Filterschleife, und die Funktion liefert danach
   `FA_NORMAL` (`:2354-2358`) — dasselbe Ergebnis wie „durchgelaufen, nichts
   getroffen". Weder `pop.cpp:999` noch `sendmail.cpp:186` noch
   `TocFrame.cpp:2398` können den Unterschied sehen: keine Meldung, kein
   Protokolleintrag (die Debug-Zeile `:2312-2320` steht erst **hinter** dem
   Treffer), kein Berichtseintrag. Bei einer beschädigten Postfachdatei bleiben
   eingehende Nachrichten ungefiltert liegen, ohne dass es jemand merkt. Genau
   [assert-ist-im-release-nichts](../Arbeitsweise/assert-ist-im-release-nichts.md).

**Zwei kleinere Befunde nebenbei, beide belegt, beide ohne eigene Kennung:**
`filtersd.cpp:697` schreibt
`if( !((verb == IDS_MATCHES_REGEX) || (verb == IDS_MATCHES_REGEX)))` — der
zweite Vergleich sollte offensichtlich `IDS_MATCHES_REGEX_ICASE` lauten;
Folge: beim Operator „matches regexp (case insensitive)" werden Suchtext
**und Muster** vorher kleingeschrieben, was Zeichenklassen wie `[A-Z]` still
umschreibt (wegen `REG_ICASE` meist folgenlos). Und `CompareRString` /
`CompareRStringI` / `FindRStringIndex` (`rs.cpp:710-780`) prüfen den
Rückgabewert von `QCLoadString` **nicht**; schlägt das Laden fehl, wird auf
einem uninitialisierten Stapelpuffer verglichen. Beide Stellen stammen aus dem
Original.

---

## Teil C — Reihenfolge der Behebung, nach Schaden

| # | Befund | Schaden | Größe | Warum in dieser Reihenfolge |
|---|---|---|---|---|
| 1 | **E-64** — Filterlauf verschiebt alle Nachrichten | **Datenverlust beim Anwender**, am Protokoll nachgemessen | **erst messen (klein), dann beheben (unbekannt)** | Der einzige Befund, der Gregors Postfach zerstört. Er ist noch **nicht** ursachenreif: zuerst die eine Spurmarke aus Teil A einbauen, ein Paket schnüren, Gregor einmal filtern lassen. Marke einbauen ≈ 15 Zeilen in `filtersd.cpp`; die Behebung danach hängt am Messergebnis |
| 1b | **Härtung zu E-64** | verhindert den Schaden unabhängig von der Ursache | **klein**, ~15 Zeilen | Zusammen mit der Marke ausliefern: leerer Wert bei `contains`/`is`/`starts with`/`ends with` darf **nicht** treffen (`filtersd.cpp:712-740`), und eine Schranke in `CTocFrame::OnFilterMessages`, die abbricht, wenn ein Filter fast alles trifft |
| 2 | **E-67** — Junk-Score-Filter wird beim Anschauen verfälscht | stiller, dauerhafter Datenverlust am Filter | **winzig**, zwei Zeichen (`>` → `>=`, `filtersv.cpp:1210` und `:1222`) | Belegt, eindeutig, kostet nichts. Gegentest: einen Filter „«Junk Score» is less than 50" anlegen, Filterfenster öffnen, wegklicken, `Filters.pce` ansehen — vorher steht dort `verb regex`, nachher `verb less` |
| 3 | **E-68** — Zielpostfächer verschwinden beim Speichern | Datenverlust am Filter | **mittel**, ~25 Zeilen in `filtersd.cpp` (`:2746`, `:3120`, `:3132`) plus eine Grenzprüfung auf `NUM_FILT_ACTS` in `Read` | Zweiter Datenverlust; die Grenzprüfung schließt zusätzlich einen Pufferüberlauf |
| 4 | **E-65** — Filter lassen sich nicht bearbeiten | Funktion fehlt; Gregor kann Filter nur anlegen, nie ändern | **erst fragen (nichts), dann klein bis mittel** | Vor jeder Änderung Gregors Antwort auf **eine** Frage: bleibt die rechte Hälfte leer, sind die Felder grau, oder wird die Änderung nicht behalten? Danach: Mindestbreite für Spalte 1 (~3 Zeilen), `bFuncEntered` zum Fensterfeld machen (~5 Zeilen), vier `ASSERT(0)` durch Spurmarken ersetzen (~20 Zeilen) |
| 5 | **E-66** — Trennbalken rechts (und unten) | Bedienung fehlt, kein Datenverlust | **mittel**, 30 bis 45 Zeilen in **einer** Datei (`OTShim.cpp`, `CalcTrackingLimits` und `TrennbalkenNeuAnlegen`) | Ursache belegt, Umfang bekannt, kein Risiko für Daten. Vor dem Anfassen die Fünf-Sekunden-Messung aus Teil A machen — sie entscheidet, ob eine oder beide Stellen zu ändern sind |
| 6 | **E-69** — `FilterMsg` bricht stumm ab | ungefilterte Post, ohne Hinweis | **klein**, drei Spurmarken (`filtersd.cpp:2241`, `:2286`, `:2302`) | Kein Sofortschaden, aber es nimmt jeder künftigen Filterstörung die Unsichtbarkeit. Sinnvoll **zusammen mit** Schritt 1, weil dieselbe Datei angefasst wird |
| 7 | Lücke im Suchfenster (`SearchView.cpp:3722`) | „Nicht Junk" aus der Suche filtert nicht | **winzig**, eine Zeile entkommentieren — **aber erst nach E-64** | Solange E-64 offen ist, wäre das Einschalten eines weiteren Filterlaufs ein Risiko |

**Klein** heißt hier: eine Datei, unter 30 Zeilen, kein Bau von Kopfdateien.
**Mittel:** eine bis zwei Dateien, unter 60 Zeilen. Nur **E-64** ist heute
nicht schätzbar — und genau deshalb steht die Messung davor und nicht die
Behebung.

**Was zusammen in ein Paket gehört:** Schritt 1 (Marke), 1b (Härtung), 2, 3
und 6 fassen alle `filtersd.cpp`/`filtersv.cpp` an, brauchen keinen
Kopfdateibau und lassen sich in einem Zug prüfen. E-65 und E-66 sind
Fenstersachen und gehören in ein zweites Paket.
