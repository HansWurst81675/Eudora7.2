# PAIGE — die Anbindung an Paige32.dll

Kennung **E-31**. Bearbeitet den Absturz **E-27** (Strg-N und *Weiterleiten*
beenden Eudora sofort und lautlos).

---

## 1. Zwei Annahmen aus der Vorarbeit sind falsch

### 1.1 "Zu Paige32.dll gibt es keine Quellen"

Es gibt sie. Sie liegen seit dem ersten Commit im Baum:

* `Eudora71/PaigeDLL/PGSOURCE/` — 38 C-Dateien (`PGINIT.C`, `PGDEFSTL.C`,
  `PGSTLSHT.C`, `PGFONTS.C`, `PGSTYLES.C` …)
* `Eudora71/PaigeDLL/PGPLATFO/` — die maschinenabhaengigen Teile,
  darunter `PGWIN.C` mit **`pgInstallFont`** (Zeile 635) und
  `pgStyleInitProc`
* `Eudora71/PaigeDLL/PGHEADER/` — die Kopfdateien
* `Eudora71/PaigeDLL/PAIGE32/Paige32.vcproj` — das Projekt der DLL

Damit ist die Endlosrekursion aus E-27 nicht mehr nur zu vermuten,
sondern nachzulesen. `PGWIN.C:635` ruft bei `style_overlay != 0`
`pgStyleSuperImpose`, und `PGDEFSTL.C:1585` ruft am Ende

```c
    target_style->procs.init(pg, target_style, &imposed_font);
```

Steht in `procs.init` versehentlich `pgInstallFont` statt
`pgStyleInitProc`, dann rufen sich beide Funktionen gegenseitig, bis der
Stapel voll ist. Genau dieser Zyklus wurde am 06.09.2026 gemessen
(526 Windungen, `0xC00000FD`). Die Rahmen sind gross — jede Windung legt
ein `style_info` und ein `font_info` auf den Stapel —, deshalb reichen
gut 500 Windungen fuer ein Megabyte.

### 1.2 "Die Strukturen passen schon"

Sie passen nicht. Gemessen, nicht vermutet — siehe Abschnitt 2.

---

## 2. Der Befund: `pg_time_t` ist unter VS2022 acht Byte breit

`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`, im Windows-Zweig:

```c
    typedef time_t                  pg_time_t;
```

`time_t` war unter VC6 und VC7.1 vier Byte breit (`long`). Unter VS2022
ist es **acht** Byte (`__int64`), seit VS2005 die Vorgabe. Die 2005
gebaute `Paige32.dll` rechnet mit vier.

`pg_time_t` steckt in `style_info` (`time_stamp`) und in `pg_doc_info`
(fuenf Felder). `pg_globals` enthaelt ein `style_info`, `paige_rec`
enthaelt ein `pg_doc_info`. Damit verschiebt sich in allen drei
Strukturen alles, was hinter dem Zeitstempel liegt — und der
Ausrichtungsbedarf von acht Byte schiebt zusaetzlich Fuellbytes davor.

### Messung

Ein 32-Bit-Programm laedt die ausgelieferte `Paige32.dll`, ruft
`pgMemStartup` und `pgInit` auf einen genullten Puffer und sucht darin
die Adressen der exportierten Standardprozeduren. So steht Byte fuer
Byte fest, wo die DLL ihre Felder ablegt. Danebengestellt, was VS2022
aus `PAIGE.H` errechnet:

| Feld in `pg_globals` | DLL (gemessen) | VS2022 vorher | VS2022 nachher |
|---|---|---|---|
| `def_style` | 308 | **312** | 308 |
| `def_style.procs.init` (`pgStyleInitProc`) | 524 | **536** | 524 |
| `def_style.procs.install` (`pgInstallFont`) | 528 | **540** | 528 |
| `def_style.procs.measure` (`pgMeasureProc`) | 532 | **544** | 532 |
| `def_par` | 600 | **616** | 600 |
| `def_par.procs.line_proc` (`pgLineMeasureProc`) | 1300 | **1316** | 1300 |
| `def_hooks` | 1360 | **1376** | 1360 |
| `pg_extend` | 1852 | **1868** | 1852 |
| `sizeof(style_info)` | 292 | **304** | 292 |
| `sizeof(pg_globals)` | ≥ 1856 | **1880** | 1864 |

Die 30 Zeigerplaetze in `def_hooks` und die 17 in `def_style.procs`
wurden vollstaendig aufgeloest und liegen alle luekenlos an den
erwarteten Stellen — die Uebereinstimmung nach der Aenderung ist keine
Stichprobe, sondern deckt die ganze Struktur ab.

Der Versatz waechst von 4 (Ausrichtung vor `def_style`) ueber 12
(`time_stamp` in `style_info`) auf 16 Byte und bleibt bis zum Ende der
Struktur. Alles davon folgt aus der einen Typbreite; es gibt keinen
zweiten Grund.

Ein `/Zp` steht weder in `Eudora.vcxproj` noch in `Paige32.vcproj`, und
in den Kopfdateien steht kein `#pragma pack`. Beide Seiten packen mit
acht — die Packung ist **nicht** schuld. Auch die uebrigen Typen
(`long`, Zeiger, `enum`, `HFILE`, `UINT`, `COLORREF`, `HRGN`,
`struct tm`, `double`) sind unter beiden Uebersetzern gleich breit;
`time_t` ist der einzige Ausreisser. Geprueft ueber alle Dateien in
`PGHEADER`.

### Was daraus folgt

Alles, was Eudora an Paige reicht oder aus Paige liest, sitzt schief,
sobald ein Feld hinter dem Zeitstempel liegt:

* `PgGlobals::InitFonts` (`Eudora71/Eudora/PgGlobals.cpp:76`) tut
  ```c
      memcpy( &def_style, &styleInfo, sizeof(style_info) );
  ```
  mit Eudoras `sizeof(style_info)` = 304. Das echte `def_style` der DLL
  ist 292 Byte lang. Die zwoelf ueberzaehligen Byte landen in
  `def_par` — bei **jedem** Anlegen eines `PgSharedAccess`-Objektes,
  also staendig.
* `CPaigeEdtView::NewPaigeObject` (`PaigeEdtView.cpp:1666`) schreibt
  ```c
      pPg->user_refcon = (long) pSB;
  ```
  `user_refcon` liegt in `paige_rec` **hinter** `doc_info`, und
  `pg_doc_info` enthaelt fuenf `pg_time_t`. Eudoras `user_refcon` liegt
  also 20 Byte hinter dem echten. Der Zeiger auf den `PgStuffBucket`
  geht in ein fremdes Feld der DLL.
* `pgGetDocInfo`/`pgSetDocInfo` in derselben Funktion tauschen ein
  `pg_doc_info` aus, dessen Laenge und Feldlage nicht stimmt.

Damit ist auch erklaert, warum die **sieben** frueheren Vermutungen alle
nichts geholfen haben: sie haben am Aufrufort gedreht, waehrend die
Grenze zwischen Programm und DLL selbst verschoben war. Und warum das
Ueberspringen von `pgNewNamedStyle` nichts brachte: die Verwuestung
geschieht schon vorher, in `PgGlobals::InitFonts` und beim Schreiben von
`user_refcon`.

---

## 3. Die Aenderung

`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`, Windows-Zweig:

```c
    typedef long                    pg_time_t;
```

statt `typedef time_t pg_time_t;`, mit Begruendung im Kommentar.

Eine Zeile. `pg_time_t` wird in keiner Eudora-Quelle benutzt
(geprueft ueber `Eudora71/Eudora`, `Eudora71/QCUtils`,
`Eudora71/EuMemMgr`), und `PaigeDLL\PGHEADER` steht nur im Include-Pfad
von `Eudora.vcxproj`. Die Aenderung wirkt also genau dort, wo sie soll.

Die Datei ist LF-only mit einem Hoch-Byte; vor und nach der Aenderung
gemessen: `CR=0 HI=1` unveraendert.

---

## 4. Die Probe: vorher und nachher

Werkzeuge dafuer neu: `tools/strg-n-pruefen.ps1` (startet Eudora aus
einem Testverzeichnis, schliesst Meldungsfenster, schickt den Befehl per
`WM_COMMAND`, meldet Fenster und Beendigungscode) und
`tools/befehl-schicken.ps1` (dasselbe von aussen, fuer einen Lauf unter
`tools/stapel-untersuchen.ps1`). Beide beenden nur Eudora-Prozesse,
deren Programmpfad im angegebenen Testverzeichnis liegt.

**Vorher** (Stand 75a4d98, Testverzeichnis im Scratchpad, Strg-N):

```
ERGEBNIS: ABGESTUERZT - Eudora beendet mit Code 0xC0000005
letzte Spurmarke: E-27 NPO: vor CreateHTMLStyles
```

Im ganzen Protokoll kein einziger vollstaendiger Durchlauf von
`CPaigeEdtView::OnCreate`. Damit ist die erste Frage beantwortet:
**in dieser Portierung entstand bis dahin nie ein Paige-Fenster.**

**Nachher** (dieselbe Umgebung, nur `Eudora.exe` ausgetauscht):

```
E-27 NPO: vor pgNewNamedStyle
E-27 NPO: nach pgNewNamedStyle
E-27 NPO: vor Stilschleife
E-27 NPO: nach Stilschleife
E-27 NPO: vor CreateHTMLStyles
E-27 NPO: nach CreateHTMLStyles          <- lief zum ersten Mal durch
E-27 PaigeOnCreate: nach NewPaigeObject
E-27 OnCreateClient: beide Ansichten angelegt
E-27 OnMessageNewMessage: fertig
ERGEBNIS: Eudora laeuft noch.
```

Das Verfassen-Fenster steht — der Titel des Hauptfensters wechselt auf
das neue MDI-Kind —, und 60 Sekunden nach dem Befehl laeuft Eudora
unveraendert weiter. *Weiterleiten* (32799) beendet Eudora ebenfalls
nicht mehr. Das ist der erste belegte, vollstaendige Durchlauf von
`CPaigeEdtView::NewPaigeObject` in dieser Portierung ueberhaupt.

---

## 5. Ein zweiter Fehler, der erst jetzt erreichbar ist

Ein Lauf unter `tools/stapel-untersuchen.ps1` mit Strg-N brachte eine
**andere** toedliche Ausnahme zutage:

```
AUSNAHME 0xC000041D  (STATUS_FATAL_USER_CALLBACK_EXCEPTION)
EIP  Eudora.exe  AutoCompleterListBox::KillACListBox + 5
                 AutoCompleteSearcher.cpp:551
Weg: CMainFrame::OnMessageNewMessage -> CEudoraApp::NewChildFrame
     -> CMDIChild::LoadFrame -> SECWorksheet::LoadFrame (OTShim.cpp:631)
     -> ... -> CHeaderView::OnKillFocusTo (headervw.cpp:265)
```

`KillACListBox` fasst `m_AutoCompList` ohne Pruefung an. Dieses Feld ist
nur nach `~AutoCompleterListBox` (`AutoCompleteSearcher.cpp:509`) NULL.
Der Aufrufer prueft `pField->m_ACListBox` zwar auf NULL, aber `pField`
entsteht aus einer ungeprueften Umdeutung
`(CHeaderField*)GetDlgItem(nID)` (`headervw.cpp:287`) — waehrend
`LoadFrame` laeuft, muss das noch nicht das erwartete Steuerelement
sein.

**Ehrliche Einordnung:** gemessen wurde das nur unter dem Debugger,
waehrend das Begleitskript im 700-ms-Takt Meldungsfenster wegklickte und
damit den Eingabefokus staendig verschob. Vier Laeufe ohne Debugger
(dreimal Strg-N, davon einer mit 60 Sekunden Nachlauf, einmal
Weiterleiten) haben den Fehler **nicht** ausgeloest. Er ist real, aber
fokusabhaengig, und er hat mit Paige nichts zu tun — er war vorher nur
unerreichbar, weil Eudora schon davor starb. Eigener Befund, in dieser
Aenderung **nicht** behoben.

---

## 6. Was noch offen ist

* Die Rechnung deckt `pg_globals` vollstaendig ab. `paige_rec`,
  `pg_undo`, `pg_hyperlink`, `pg_table` und die Strukturen aus
  `PGCNTL.H`/`PGEMBED.H` sind nicht einzeln nachgemessen; sie enthalten
  ausser `pg_time_t` aber keinen Typ, dessen Breite sich geaendert hat.
* Die zweite Spur — zwei getrennte Halden — traegt **nicht**.
  `Paige32.dll` und `EuMemMgr.dll` holen `malloc`/`free` aus `MSVCR71`
  (im Paket eine Bruecke auf `msvcrt.dll`), `Eudora.exe` benutzt die
  UCRT; der in `NewPaigeObject` mit `DEBUG_NEW` angelegte
  `PgStuffBucket` wandert als `user_refcon` in Paiges Datensatz. Gesucht
  nach `user_refcon` in allen 48 Quelldateien unter
  `PGSOURCE`/`PGPLATFO`: 14 Treffer, alle in `PGEMBED.C`, alle auf dem
  **eigenen** `user_refcon` des `embed_rec`. Das `user_refcon` des
  `paige_rec` fasst Paige nirgends an. Freigegeben wird es allein von
  Eudora, in `CPaigeEdtView::DeletePaigeObject`
  (`PaigeEdtView.cpp:1818`), also auf derselben Halde, auf der es
  angelegt wurde. Ueber diesen Zeiger geht nichts kaputt.
* Da die Quellen vollstaendig vorliegen, waere ein Neubau von
  `Paige32.dll` mit VS2022 der endgueltige Weg: dann kann keine
  Kopfdatei mehr von der Binaerdatei abweichen, und die
  Halden-Trennung faellt mit weg. Das ist ein eigenes Vorhaben.
