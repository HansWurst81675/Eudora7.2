# Befund P-3 — Gegenlesen von E-31, E-32, der Fehlerklasse und des Baus

**Stand 07.09.2026.** Auftrag: nicht neuen Code suchen, sondern vier
Behauptungen widerlegen. Grundlage war Gregors Ansage vom 07.09.2026:
*„ich traue dir nicht ganz, jemand soll dich immer wieder ueberpruefen — das
bin aber nicht ich!"*

Ergebnis in einem Satz: **E-31 ist bestaetigt und sogar staerker belegt als
behauptet. Die Ursachenbehauptung von E-32 ist widerlegt. Der Bau stimmt.
Die Fehlerklasse ist echt und hat 19 belegte, offene Stellen.**

| Behauptung | Urteil |
|---|---|
| 1. E-31 `pg_time_t` — Ursache gefunden und behoben | **bestaetigt**, mit 1922 gemessenen Feldoffsets |
| 2. E-32 — `pField` ungeprueft *war die modale Meldung* | **Code-Mangel ja, Ursachenbehauptung widerlegt** |
| 3. Die Fehlerklasse E-18/E-22/E-32 ist maschinell auffindbar | **bestaetigt**, 19 belegte Stellen, Werkzeug mit 33 Tests |
| 4. Die ganze Projektmappe baut mit 0 Fehlern | **bestaetigt**, 0 Fehler, 11:58, ohne `-m` |

---

## 1. E-31 — `pg_time_t`: bestaetigt, und staerker als behauptet

### Was gemessen wurde, und womit

Der Befund behauptete vier Werte. Statt sie nachzurechnen habe ich eine
**unabhaengige Messquelle** gefunden: `Eudora71/Bin/Release/Paige32.pdb`
gehoert zur ausgelieferten `Paige32.dll` von 2005. Belegt:

| | Wert |
|---|---|
| `Paige32.dll` Maschinentyp | `0x014C` (x86) |
| `Paige32.dll` PE-Zeitstempel | **14.10.2005 17:44:56 UTC** |
| CodeView-Eintrag der DLL | GUID `70D2FD5A-4E54-46AB-A5D0-1E50D547C22D`, Alter 1 |
| `Paige32.pdb` | GUID `70D2FD5A-4E54-46AB-A5D0-1E50D547C22D`, Alter 1 |
| PDB-Pfad in der DLL | `d:\Source Code\perforce\Eudora\PaigeDLL\Paige32\Build\Release\Paige32.pdb` |

Die PDB passt zur DLL. Damit ist der Feldaufbau, mit dem die DLL von 2005
rechnet, **messbar statt vermutbar**. Dafuer gibt es jetzt
`tools/pruefstand/pdb-felder.cpp` (liest Strukturen ueber DIA aus einer PDB;
DIA ist auf dieser Maschine nicht registriert, das Werkzeug laedt
`msdia140.dll` deshalb direkt) und `tools/pruefstand/messen.ps1`, das die
heutigen Kopfdateien in eine eigene PDB uebersetzt und beide gegenueberstellt.

Wichtig fuer die Voraussetzung des Befundes: `PaigeDLL` ist **kein Projekt**
in `Eudora71/Eudora.sln`. `Paige32.dll` wird nicht gebaut, sondern als
Fremdbinaerdatei mitgeliefert. Die ABI-Frage stellt sich also wirklich.

### Die vier behaupteten Werte

Alle vier stimmen — auf **beiden** Seiten:

| Feld | DLL (PDB 2005) | VS2022 heute | behauptet DLL | behauptet vorher | gemessen vorher |
|---|---|---|---|---|---|
| `def_style.procs.init` | 308 + 216 = **524** | **524** | 524 | 536 | **536** |
| `def_par.procs.line_proc` | 600 + 700 = **1300** | **1300** | 1300 | 1316 | **1316** |
| `def_hooks` | **1360** | **1360** | 1360 | 1376 | **1376** |
| `sizeof(style_info)` | **292** | **292** | 292 | 304 | **304** |

Dazu als Zugabe: `sizeof(pg_globals)` = **1864** auf beiden Seiten,
`style_info.time_stamp` liegt bei 172 und ist **4 Byte** breit — genau das,
was `typedef long pg_time_t;` in `CPUDEFS.H:703` bewirkt.

Der Zustand VOR der Behebung ist nachgestellt worden: eine Kopie von
`PGHEADER`, in der die eine Zeile wieder `typedef time_t pg_time_t;` heisst,
uebersetzt mit `messen.ps1 -Kopfdateien <Kopie>`.

### Die eigentliche Nachricht: 755 statt 4

Der Befund nennt vier Felder. Gemessen sind es **755 falsche Feldoffsets von
1922** und **zehn zu grosse Paige-Strukturen**:

| Struktur | DLL | vorher | Delta |
|---|---|---|---|
| `paige_rec` | 1200 | 1224 | +24 |
| `pg_translator` | 1804 | 1848 | +44 |
| `style_table_entry` | 1288 | 1304 | +16 |
| `style_walk` | 388 | 408 | +20 |
| `pg_doc_info` | 324 | 344 | +20 |
| `pg_embed_rec` | 140 | 152 | +12 |
| `pg_globals` | 1864 | 1880 | +16 |
| `style_info` | 292 | 304 | +12 |
| `pg_time` | 8 | 16 | +8 |
| `pg_date` | 8 | 16 | +8 |

**Nach der Behebung: 0 von 1922 Feldoffsets abweichend.**

### Die ungeprueften Nebenbehauptung „`time_t` war der einzige"

Diese Behauptung stand ausdruecklich als unbewiesen im Auftrag. Sie ist
**jetzt bewiesen**, und zwar nicht durch Nachdenken ueber Typbreiten, sondern
durch Messung: von 92 Strukturen, die in beiden PDB stehen, sind **91
feldweise identisch** (1922 Felder). Uebrig bleiben genau zwei, und beide
gehen nicht ueber die Paige-Schnittstelle:

* `_iobuf` (also `FILE`): DLL 32, heute 4 Byte. **`FILE` kommt in keiner
  einzigen Kopfdatei unter `PGHEADER` vor** (gesucht in allen 56 Dateien).
  Der Typ ist DLL-intern und taucht nur auf, weil die Messdatei `<stdio.h>`
  mitzieht.
* `_EXCEPTION_REGISTRATION_RECORD`: in der DLL-PDB nur vorwaerts erklaert
  (Groesse 0), also nicht vergleichbar. Ein Windows-SEH-Typ, ebenfalls nicht
  in `PGHEADER`.

Auch der Fall, den ich fuer den gefaehrlichsten gehalten hatte, ist in
Ordnung: `pg_fail_info` (`PGEXCEPS.H:43`) enthaelt ein `jmp_buf` und wird an
`pgPushHandler` in `EuMemMgr.dll` von 2005 uebergeben. Gemessen: **72 Byte auf
beiden Seiten** — `jmp_buf` ist unter VS2022 x86 genauso 64 Byte breit wie
unter VC7.1.

Nebenbei nachgesehen und in Ordnung: `CPUDEFS.H:540` definiert `pg_time_t` ein
zweites Mal als `unsigned long` — das ist der Mac-Zweig (`RgnHandle`,
`DateTimeRec`) und wird unter Windows nicht uebersetzt. Das Vorzeichen
weicht ab, die Breite nicht.

**So pruefst du das nach:**

```
powershell -ExecutionPolicy Bypass -File tools\pruefstand\messen.ps1
```

Erwartung: `Feldoffsets GLEICH: 1922 Felder in 91 Strukturen geprueft.`
und `sizeof UNTERSCHIEDLICH in 2 von 92 Strukturen` mit genau `_iobuf` und
`_EXCEPTION_REGISTRATION_RECORD`.

---

## 2. E-32 — der Code-Mangel ist echt, die Ursachenbehauptung ist widerlegt

### Was stimmt

`Eudora71/Eudora/headervw.cpp`, `CHeaderView::OnKillFocusRecipient`: dass
`pField` in Zeile 289 auf NULL geprueft und in Zeile 294 ungeprueft
dereferenziert wurde, **ist objektiv richtig** und ist dieselbe Fehlerklasse
wie E-22. Die Absicherung ist eine Verbesserung.

### Was nicht stimmt

**Behauptung:** *„GetDlgItem liefert NULL, solange das Kopfzeilenfeld noch
nicht existiert — und genau das ist beim Aufbau des Verfassen-Fensters der
Fall: OnKillFocusTo laeuft waehrend LoadFrame, bevor die Felder da sind."*
Und: dass genau das die modale Meldung `0xC000041D` erzeugte.

Drei unabhaengige Messungen sprechen dagegen.

**(a) Die Funktion wird auf dem Strg-N-Weg gar nicht betreten.**
Ich habe eine Messspur in `OnKillFocusRecipient` eingesetzt (Wert von
`GetDlgItem`, `m_hWnd`, und `IsKindOf(RUNTIME_CLASS(CHeaderField))`),
uebersetzt und `tools\strg-n-pruefen.ps1` laufen lassen.
Ergebnis: **0 Spurzeilen.** Die Funktion laeuft nicht. Die E-27-Spurmarken
derselben Sitzung laufen dagegen alle durch, bis
`OnMessageNewMessage: fertig`.

**(b) Die Behebung wieder herausnehmen bringt die Meldung nicht zurueck.**
Ich habe `headervw.cpp` auf den Stand `060a4bf^` zurueckgesetzt — also die
Behebung entfernt —, die Messspur wieder eingesetzt, neu uebersetzt und
denselben Versuch gefahren. Ergebnis: **keine Ausnahmemeldung**, und wieder
0 Spurzeilen.

**(c) Das ausgelieferte Paket 1.0.18 zeigt die Meldung ebenfalls nicht.**
Kontrollversuch mit `C:\Users\Gregor\Eudora72-1.0.18-release` (in ein eigenes
Verzeichnis kopiert): auch dort **keine Ausnahmemeldung** beim Strg-N-Versuch.
Das ist derselbe Bau, in dem E-32 gemeldet wurde.

Aus (c) folgt die ehrliche Einschraenkung: **das Symptom laesst sich mit
`strg-n-pruefen.ps1` ueberhaupt nicht erzeugen.** Der wahrscheinliche Grund:
das Werkzeug schickt `WM_COMMAND 32797` direkt und wechselt dabei nirgends den
Eingabefokus — ohne Fokuswechsel gibt es kein `EN_KILLFOCUS`, und ohne das
kein `OnKillFocusRecipient`. Damit ist (a) und (b) **kein Beweis, dass die
Behauptung falsch ist**, wohl aber der Beweis, dass **die Behebung nie gegen
das Symptom geprueft wurde** und mit diesem Werkzeug auch nicht geprueft
werden kann.

### Warum die Begruendung auch am Quelltext scheitert

Die Behauptung ist in sich widerspruechlich. Erreicht wird
`OnKillFocusRecipient` ueber die Nachrichtenzuordnung:

```
headervw.cpp:188   ON_EN_KILLFOCUS(IDC_HDRFLD_EDIT1, OnKillFocusTo)
```

`EN_KILLFOCUS` ist eine `WM_COMMAND`-Benachrichtigung **des Eingabefeldes an
sein Elternfenster**. Kommt sie an, dann existiert das Feld — sonst haette es
sie nicht schicken koennen. `CWnd::GetDlgItem` ist nichts anderes als
`::GetDlgItem(m_hWnd, nID)` plus `CWnd::FromHandle`. Existiert das
Kindfenster, liefert `::GetDlgItem` seinen `HWND`, und `FromHandle` liefert
nie NULL. **Der behauptete Ausloeser und der behauptete Mechanismus schliessen
sich gegenseitig aus.**

### Was an der Stelle wirklich gefaehrlich ist — und was die Behebung nicht abdeckt

Die Felder werden erst in `CHeaderView::OnInitialUpdate` untergeklinkt:

```
headervw.cpp:581   pField->Attach( this, iLabel, iEdit );
headervw.cpp:2590  fRet = SubclassDlgItem( idcEdit, m_pWndParent );
```

**Vor** diesem `SubclassDlgItem` liefert `GetDlgItem` ein **temporaeres
`CWnd`**, nicht das `CHeaderField`. Der Zeiger ist dann *nicht NULL*, aber
die Umwandlung `(CHeaderField*)` ist falsch, und

```
headervw.cpp:289   if (pField && pField->m_ACListBox)
```

liest hinter dem Ende eines `CWnd`. `m_ACListBox` ist ein Mitglied von
`CHeaderField` (`headervw.h:81`). Dass der urspruengliche Verfasser genau
damit rechnete, steht drei Zeilen weiter im eigenen Code:

```
headervw.cpp:311   pField->IsKindOf(RUNTIME_CLASS(CHeaderField))
```

Diese Pruefung kommt **nach** dem `m_ACListBox`-Zugriff — und das ist heute
noch so. Die Behebung `if (!pField) return;` deckt diesen Fall **nicht ab**.

### Zusatzbefund aus derselben Messung: `CHeaderView::OnInitialUpdate` laeuft nie

In beiden Sitzungen (mit und ohne Behebung) endet die Spur bei
`OnMessageNewMessage: fertig`. Die Marke

```
headervw.cpp:558   PutDebugLog(..., "E-27 CHeaderView::OnInitialUpdate: Anfang");
```

erscheint **nicht ein einziges Mal**, und es entsteht kein sichtbares
Verfassen-Fenster. Der Rahmen wird gebaut (`OnCreateClient: beide Ansichten
angelegt`), aber die Kopfansicht wird nie erstinitialisiert. Das ist eine
bessere Spur fuer Kriterium 5 als E-32 — und sie ist gemessen, nicht vermutet.

### Weitere Stellen desselben Musters in denselben zwei Dateien

Der Auftrag wollte sie gezaehlt. Gemessen mit `tools/zeiger-nachpruefen.pl`:

| Datei | Zeile | Zeiger | Urteil |
|---|---|---|---|
| `headervw.cpp` | 585 | `pField` | **echt** — `if ( pField )` bei 580 schuetzt nur 581 |
| `headervw.cpp` | 2833 | `m_ACListBox` | Fehlalarm — bei 2825 ueber `bDoAutoComplete` abgesichert |
| `AutoCompleteSearcher.cpp` | — | — | **keine Stelle** |

Dazu drei Stellen der verwandten Klasse „gar nicht geprueft" in `headervw.cpp`
(`GetDlgItem`/`GetHeaderCtrl` ohne jede Pruefung dereferenziert):

* `headervw.cpp:448`, `449`, `450` — `GetHeaderCtrl(HEADER_*)->GetWindowText(...)`
* `headervw.cpp:734` — `GetDlgItem(IDC_HDRFLD_EDIT2)->ModifyStyle(0, WS_TABSTOP)`

### Dokumentationswiderspruch

Die Behebung steht als Kommentar im Code und in der Commit-Nachricht von
`060a4bf` („E-32 behoben"), aber:

* `ZIEL.md:30/31` nennt E-32 weiterhin als **nicht erfuellt**,
* `CHANGELOG.md:16` nennt es weiterhin **offen** mit „Verdacht",
* `WEITERMACHEN.md:55` fuehrt es weiterhin als offene Aufgabe.

Der Commit `060a4bf` hat **keine** dieser Dateien angefasst. Nach der Lehre
*„Doku bei jedem Commit mitziehen"* haette das zusammen gehen muessen. Da die
Ursachenbehauptung ohnehin nicht traegt, ist der Stand in ZIEL.md
sachlich naeher an der Wahrheit als der Kommentar im Code.

Bemerkenswert dabei: derselbe Commit hat `tools/doku-pruefen.pl` mitgebracht,
das genau solche Widersprueche finden soll. Es findet diesen **nicht**, weil es
nur `.md` gegen `.md` prueft — „behoben" steht hier im Quelltextkommentar und in
der Commit-Nachricht, nicht in einer `.md`. Das Werkzeug meldet stattdessen
acht andere, ungeloeste Widersprueche (vier Stellen nennen 7 Kriterien statt 8;
E-7, E-11, E-14 und E-16 stehen in `BEFUNDE.md` gleichzeitig als behoben und
als offen). Ein Pruefwerkzeug, dessen erster Lauf acht Maengel findet und deren
keiner danach behoben wird, prueft nichts.

---

## 3. Die Fehlerklasse — `tools/zeiger-nachpruefen.pl`, 33 Tests, 19 belegte Stellen

### Warum ein zweites Werkzeug neben `tools/suche-zeiger.pl`

`suche-zeiger.pl` gibt es schon und ist gegen Fehlalarme gehaertet (X-1). Es
hat **E-32 nicht gefunden**, obwohl E-32 genau seine Fehlerklasse ist.
Nachgemessen an der Fassung vor der Behebung:

```
$ perl tools/suche-zeiger.pl <headervw.cpp aus 060a4bf^>
...:560 geprueft 'pField' -> benutzt :565 (Abstand 5)
```

Nur Zeile 560. Die E-32-Stelle bei 287/294 fehlt. Zwei Ursachen:

1. **Ein Zugriff in einer Bedingung wurde als Pruefung gewertet.** Filter 6
   von `suche-zeiger.pl` zaehlt „jede Pruefung des Namens in einer Bedingung"
   als erneute Absicherung. Bei E-32 steht der ungepruefte Zugriff aber selbst
   in einer Bedingung — `if (GetIniShort(...) && pField->IsKindOf(...))`. Der
   Filter, der Fehlalarme verhindern sollte, hat den echten Treffer
   verschluckt.
2. **Kommentare wurden nicht ausgeblendet.** In `headervw.cpp` steht heute ein
   Kommentar, der `if (pField && ...)` im Klartext zitiert.

Beides ist im neuen Werkzeug abgestellt und als Test hinterlegt.

### Sieben belegte Fehlalarmklassen, jede mit Fundstelle und Test

Wie X-1 es gemacht hat: Stichprobe von Hand nachgelesen, Ursache benannt,
Regel gebaut, Test dazu. Von 76 Treffern der ersten Fassung sind es jetzt 48.

| Nr | Klasse | Fundstelle |
|---|---|---|
| 1 | Zeiger als **Argument** in der Bedingung, nicht als Wahrheitswert | `AboutEMS.cpp:188`, `eudora.cpp:2252` |
| 2 | **Kurzschlussauswertung** ueber mehrere Zeilen (`!X \|\| X->y`) | `MIMEMap.cpp:116`, `nickdoc.cpp:2526`, `sendmail.cpp:3568` |
| 3 | `!(A && B)` ist ein **negierter** Waechter fuer beide Namen | `mboxtree.cpp:3580` |
| 4 | Bedingung nicht an der schliessenden Klammer beschnitten | (liess 3 scheitern) |
| 5 | Aufruf **mit Aufruf im Argument** — die Klammerleerung stand still | `mime.cpp:628` |
| 6 | **Abgeschalteter Praeprozessorzweig** | `PgEmbeddedObject.cpp:155` (`#if 0`), `TridentReadMessageView.cpp:993` (`#ifdef OLDSTUFF`) |
| 7 | Positiver Waechter, dessen **else-Zweig herausspringt** | `compmsgd.cpp:2247-2250` |

Und ein Fehler **in die andere Richtung**, gefunden weil ein von Hand
belegter echter Treffer verschwand: „ab hier geprueft" galt fuer den *Rest der
Funktion*. Damit fiel `StatMng.cpp:1574` weg — der Aussprung steht bei 1524 im
**Geschwisterzweig** von 1516 und liegt gar nicht auf dem Weg zu 1574. Eine
solche Marke reicht jetzt nur bis der umgebende Block zugeht.

### Die Trefferliste

48 Treffer in 713 Dateien, **alle 48 von Hand nachgelesen: 19 echt, 29
Fehlalarm**. Das ist eine Genauigkeit von 40 Prozent — deutlich weniger, als
ich wollte, und weniger, als Gregors Auflage („lieber wenige belegte Treffer")
verlangt. Die verbleibenden Fehlalarme haben fast alle **eine** Ursache, die
ein textlesendes Werkzeug nicht aufloesen kann: die Absicherung laeuft ueber
einen **anderen Namen** — ein Hilfsflag, ein abgeleiteter Zeiger, eine
`POSITION`, ein `bLoadedDoc`.

Ein Fehlalarm ist dabei ein **Fehler im Werkzeug**, den ich nicht mehr
abgestellt habe: `filtersd.cpp:2333`. Der Waechter `if (!pTocDoc) { ASSERT(0);
break; }` bei 2239 und der Zugriff bei 2333 stehen **im selben Block**
`if (!text)` (2234 bis 2345); der Waechter beherrscht den Zugriff also. Die
Regel `reicht_bis` haette das abdecken muessen und tut es nicht. Notiert, damit
es niemand fuer einen Fund haelt.

**Die 19 belegten, offenen Stellen:**

| Datei | Zeile | Zeiger | Pruefung | Bemerkung |
|---|---|---|---|---|
| `CompMessageFrame.cpp` | 798 | `pMainFrame` | 709 | in `OnCreateClient` — dem Verfassen-Weg |
| `filtersd.cpp` | 1108 | `Sum` | 1088 | Block endet 1091, `switch` danach ungeschuetzt |
| `headervw.cpp` | 585 | `pField` | 580 | Block endet 582; `ASSERT` daneben zaehlt nicht |
| `msgdoc.cpp` | 1028 | `m_Sum` | 942 | Block endet 1004 |
| `nickview.cpp` | 3033 | `View` | 3029 | Nachbarfunktionen machen es richtig |
| `QCMailboxDirector.cpp` | 2450 | `pCommand` | 2441 | Kurzschluss laesst NULL durch |
| `SearchManager.cpp` | 999 | `m_pInfo` | 995 | auch 1002, 1005, 1008 |
| `settings.cpp` | 2194 | `m_Static` | 1832 | Zuteilung ist `NOTHROW` |
| `settings.cpp` | 2199 | `m_StatCombo` | 1840 | dito |
| `settings.cpp` | 2953 | `CtrlACAPButton` | 2939 | **`GetDlgItem` bei 2935** |
| `settings.cpp` | 2954 | `CtrlOKButton` | 2941 | **`GetDlgItem` bei 2936** |
| `settings.cpp` | 2955 | `CtrlCANCELButton` | 2943 | **`GetDlgItem` bei 2937** |
| `StatMng.cpp` | 1574 | `gStatData` | 1571 | 1577 prueft wieder — die Absicht ist belegt |
| `TocFrame.cpp` | 3101 | `TocDoc` | 3092 | `GetTocDoc` kann NULL liefern |
| `TocFrame.cpp` | 3973 | `pTocDoc` | 3968 | Block endet 3969 |
| `TridentReadMessageView.cpp` | 1854 | `pCollection` | 1695 | uninitialisiert erklaert (1660) |
| `TridentReadMessageView.cpp` | 3841 | `pCollection` | 3724 | uninitialisiert erklaert (3694) |
| `TridentView.cpp` | 3162 | `pCollection` | 3093 | uninitialisiert erklaert (3020) |
| `Trnslate.cpp` | 5223 | `pMboxInfo` | 5217 | 5232 prueft wieder — **exakt die Gestalt von E-32** |

Zwei Muster sind es wert, zusammen behoben zu werden:

* **`settings.cpp:2953-2955`** — drei `GetDlgItem`-Ergebnisse werden bei
  2939/2941/2943 einzeln geprueft und bei 2953/2954/2955 alle drei
  ungeprueft benutzt. Das ist E-32 in Reinform, dreifach, und es belegt
  nebenbei, dass in diesem Quellbaum `GetDlgItem` sehr wohl als
  NULL-faehig behandelt wird.
* **`pCollection->Release()` nach fehlgeschlagenem `get_all`** —
  dreimal derselbe Fehler in den Trident-Ansichten, Variable jeweils
  uninitialisiert erklaert.

**So pruefst du das nach:**

```
perl tools/zeiger-nachpruefen-tests.pl          # 33 gruen, 0 rot
perl tools/zeiger-nachpruefen.pl Eudora71/Eudora
```

### Ein Wort zur Praemisse des Auftrags

Der Auftrag sagt: *„E-18, E-22 und E-32 sind derselbe Fehler."* Fuer E-22 und
E-32 stimmt das. **Fuer E-18 nicht:** dort war `pFld` an *keiner* Stelle
geprueft (`headervw.cpp:246-253`), also nicht „an einer Stelle geprueft, an der
naechsten nicht", sondern „nie geprueft". Das ist eine Nachbarklasse, die
dieses Werkzeug ausdruecklich **nicht** findet.

Nebenbei: `BEFUNDE.md:171` behauptet *„E-10, E-15, E-18 bis E-21 gibt es
nicht. Gesucht am 06.09.2026 im ganzen Repo: diese Kennungen sind nie vergeben
worden."* `headervw.cpp:246` sagt `Befund E-18`. Einer der beiden Saetze ist
falsch.

---

## 4. Der Bau — bestaetigt

Selbst gefahren, ohne `-m`, nachdem `Get-Process MSBuild,cl,link` nichts
gefunden hatte:

```
 Konfiguration    Release|x86    Ziel Build
 Rueckgabewert    0  (erster Gang)
 Fehler           0 neu, 0 bekannt (OT501)
 Warnungen        5572
 Dauer            00:11:58
 Zweiter Gang     nicht noetig
 Eudora.exe         2.943.488 B   2026-09-07 07:22:53  neu
 EudoraRes.dll      2.447.360 B   2026-09-07 07:23:00  neu
 ...
 ERGEBNIS: ERFOLG - 0 Fehler, 0 Warnungen
```

**Behauptung bestaetigt.** Auch die bekannten OT501-Fehler sind bei 0.

Zur Sicherheit ein zweites Mal, diesmal als **vollstaendiger Neubau**
(`-Ziel Rebuild`), nachdem der Quellbaum wieder auf `HEAD` stand:

```
 Rueckgabewert    0  (erster Gang)
 Fehler           0 neu, 0 bekannt (OT501)
 Dauer            00:10:34
 Eudora.exe         2.943.488 B   2026-09-07 08:10:12  neu
 ERGEBNIS: ERFOLG - 0 Fehler, 0 Warnungen
```

`Eudora.exe` ist byteweise gleich gross wie beim ersten Lauf (2.943.488) —
der Quellbaum ist also wirklich wieder der Stand von `HEAD`, und die
Messspur aus Abschnitt 2 ist restlos entfernt (`headervw.cpp`: 96097 Byte,
18 CR, 0 Byte ueber 127 — identisch mit `HEAD`).

Zwei Randbeobachtungen an `tools/bauen.ps1` selbst:

1. Die Schlusszeile sagt `ERFOLG - 0 Fehler, 0 Warnungen`, waehrend zwoelf
   Zeilen darueber `Warnungen 5572` steht. Eine der beiden Zahlen ist falsch
   beschriftet.
2. Nach einer Aenderung an einer `.cpp` des Eudora-Projekts meldet der
   inkrementelle Bau `FEHLSCHLAG`, weil `EudoraRes.dll` aelter als die Quellen
   „seines eigenen Projekts" sei. `EudoraRes.vcxproj` teilt das Quellverzeichnis
   mit `Eudora.vcxproj`, und eine Codeaenderung macht die Ressourcen-DLL
   deshalb formal „veraltet", ohne dass sie neu gebaut werden muesste. Das
   kostet bei jedem Zwischenbau eine falsche Alarmmeldung.

Und eine dritte, die kein Werkzeug betrifft, sondern das Repo: der Bau
**aendert getrackte Binaerdateien**. Nach jedem Lauf melden
`Eudora71/Bin/Release/Paige32.dll`, `EuMemMgr.dll`, `DirServ.dll`,
`EudoraBk.dll`, `ISock.dll`, `Ldap.dll` und `Ph.dll` sich als geaendert (gleiche
Groesse) — das ist der Bindeschritt, der die Importtabellen an Ort und Stelle
umschreibt. Dazu kommen die MIDL-Erzeugnisse `EudoraExe_i.c`, `EudoraExe_p.c`,
`GoogleDesktopSearchAPI_i.c`, `GoogleDesktopSearchAPI_p.c` und `dlldata.c`.
Wer nach einem Bau `git status` liest, sieht elf Dateien geaendert, die
niemand angefasst hat.

---

## Was ich nicht pruefen konnte

1. **Das Symptom von E-32.** Mit `tools/strg-n-pruefen.ps1` erscheint die
   Meldung „An unhandled exception has occurred" **in keinem** der drei
   gefahrenen Versuche — nicht mit Behebung, nicht ohne, und nicht im
   ausgelieferten Paket 1.0.18. Das Werkzeug schickt `WM_COMMAND` direkt und
   erzeugt dabei keinen Fokuswechsel; damit fehlt der `EN_KILLFOCUS`, um den
   es bei E-32 geht. Um die Behauptung wirklich zu erledigen, braeuchte es
   einen Versuch, der **den Fokus bewegt** (`SetFocus` auf ein Kopffeld,
   dann `SetFocus` auf ein anderes) — oder Gregors eigene Sitzung.
2. **Ob die Umgebung schuld ist.** Mein Testverzeichnis brauchte
   `Paige32.dll`, `mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll`
   nachgelegt; das ausgelieferte Paket importiert noch `Paige32d.dll`, der
   frische Bau `Paige32.dll`. Ein Unterschied im DLL-Satz kann Verhalten
   aendern. Der Kontrollversuch mit dem unveraenderten Paket 1.0.18 spricht
   dagegen, beweist es aber nicht.
3. **Den Fehler im Werkzeug bei `filtersd.cpp:2333`** habe ich gefunden, aber
   nicht behoben. `reicht_bis` muesste den Waechter von 2239 bis zum Ende von
   `if (!text)` (2345) tragen und tut es nicht. Wer das anfasst: erst den Test
   dafuer schreiben, dann die Regel, und danach `StatMng.cpp:1574` nachmessen —
   dieselbe Regel hat den Treffer schon einmal verschluckt.
4. **Die Fehlerklasse ausserhalb von `Eudora71/Eudora`.** Der Auftrag nannte
   dieses Verzeichnis; `QCUtils`, `QCSocket`, `EuImap`, `Imapdll`, `QCSSL` und
   `SearchEngine` sind nicht durchgesehen.
5. **`pg_fail_info` im Betrieb.** Die Groesse stimmt (72 Byte auf beiden
   Seiten), aber `setjmp` uebersetzt *unser* Compiler und `longjmp` fuehrt die
   `EuMemMgr.dll` von 2005 mit ihrer eigenen Laufzeit aus. Dass die
   Registerablage bitgleich belegt wird, ist damit **nicht** gemessen, nur die
   Groesse.
6. **Die 29 als Fehlalarm eingeordneten Treffer** habe ich nicht alle selbst
   nachgelesen. Ein Teil kommt von einer zweiten Instanz, die jede Einordnung
   mit Zeilenzitat begruendet hat; **zehn davon habe ich selbst nachgemessen**,
   und bei einem (`filtersd.cpp:2333`) war die fremde Einordnung *falsch* — sie
   hatte „echt" gesagt, gemessen ist es ein Fehlalarm. Bei den uebrigen 19
   steht die Begruendung, nicht meine Messung.
