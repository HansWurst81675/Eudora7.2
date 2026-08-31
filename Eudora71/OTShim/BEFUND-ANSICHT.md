# BEFUND-ANSICHT - das Erscheinungsbild (Befund S-6)

Agent ANSICHT, 30.08.2026. Branch `worktree-agent-a84c76a2ea910c75d`,
ausgehend von `31810e2` (`origin/eudora-exe-linkt`).

**UNFERTIG.** Die Sitzung wurde abgebrochen, bevor eine Behebung geschrieben
werden konnte. Diese Datei haelt fest, was gemessen ist, was ausgeschlossen ist
und wo die naechste Sitzung ansetzen muss. **Es wurde keine einzige Quelldatei
geaendert** - der Code ist unveraendert der von `31810e2`.

Alles hier ist reine Quellcodeanalyse. Eudora wurde nicht gestartet (Auflage:
nichts auf Gregors Bildschirm).

---

## Vorbemerkung zum Arbeitsverzeichnis

Der Worktree stand beim Start auf `22a6d77` (`main`). Dort gibt es weder
`ZIEL.md` noch die Befunde `S-1` bis `S-7`. Der Arbeitsstand liegt auf
`origin/eudora-exe-linkt` (`31810e2`); darauf wurde zurueckgesetzt. Wer hier
weitermacht, muss dasselbe tun, sonst sucht er Dateien, die es auf `main` nicht
gibt.

---

## Punkt 1 - die leeren Werkzeugleisten-Knoepfe

### Was gemessen ist

**Die Vorgabe sind GROSSE Knoepfe.** `EudoraRes.rc:7648` setzt
`IDS_INI_SHOW_LARGEBUTTONS "ShowLargeButtons\n1"`. `QCToolBarManager::LoadToolBarResource`
(`QCToolBarManager.cpp:268-271`) reicht diesen Wert unmittelbar an
`QCEnableLargeBtns` durch. Beim ersten Start wird also `IDR_MAINFRAME32` /
`32A` / `32B` geladen, nicht die 16er-Fassung.

**Die Bitmaps und ihre Bildzahlen passen zusammen.** Gemessen an den Dateikoepfen
und an den `TOOLBAR`-Ressourcen in `EudoraRes.rc:6351-6760`:

| Ressource | Bitmap | Breite x Hoehe | Farbtiefe | BUTTON-Zeilen | Breite/Hoehe |
|---|---|---|---|---|---|
| IDR_MAINFRAME16  | res/icons/tbar16.bmp  | 1024 x 16 | 24 bpp | 64 | 64 |
| IDR_MAINFRAME16A | res/icons/tbar16a.bmp |  976 x 16 | 24 bpp | 61 | 61 |
| IDR_MAINFRAME16B | res/icons/tbar16b.bmp |  816 x 16 | 24 bpp | 51 | 51 |
| IDR_MAINFRAME32  | res/icons/tbar32.bmp  | 2048 x 32 | 24 bpp | 64 | 64 |
| IDR_MAINFRAME32A | res/icons/tbar32a.bmp | 1952 x 32 | 24 bpp | 61 | 61 |
| IDR_MAINFRAME32B | res/icons/tbar32b.bmp | 1632 x 32 | 24 bpp | 51 | 51 |

**Keine der sechs Ressourcen enthaelt eine `SEPARATOR`-Zeile.** Damit ist die
Zusicherung `ASSERT((int)m_nBmpItems == bmp1.bmWidth / bmp1.bmHeight)`
(`QCToolBarManager.cpp:399-401`) erfuellt, und die Fassung der Ersatzschicht,
die Trenner beim Zaehlen ueberspringt
(`OTShim_Werkzeugleiste.cpp:3400-3417`), liefert dieselbe Zahl wie eine, die
das nicht taete.

**Alle 15 Standardknoepfe der Hauptleiste kommen aus dem ERSTEN Bitmap.**
Die Standardbelegung steht in `mainfrm.cpp:684-711` (`buttons[]`, per
`m_pToolBar->SetButtons(buttons, DIM(buttons))` in `mainfrm.cpp:1737`).
Ihre Bildplaetze in der zusammengesetzten Bitmap:

| Befehl | Index | aus |
|---|---|---|
| ID_MESSAGE_DELETE | 0 | IDR_MAINFRAME16/32 |
| ID_MAILBOX_IN | 1 | dto. |
| ID_MAILBOX_OUT | 2 | dto. |
| ID_FILE_CHECKMAIL | 3 | dto. |
| ID_MESSAGE_NEWMESSAGE | 4 | dto. |
| ID_MESSAGE_REPLY | 6 | dto. |
| ID_MESSAGE_REPLY_ALL | 9 | dto. |
| ID_MESSAGE_FORWARD | 10 | dto. |
| ID_PREVIOUS_MESSAGE | 16 | dto. |
| ID_NEXT_MESSAGE | 17 | dto. |
| ID_MESSAGE_ATTACHFILE | 18 | dto. |
| ID_WINDOW_NICKNAMES | 20 | dto. |
| ID_FILE_PRINT | 21 | dto. |
| ID_CONTEXT_HELP | 22 | dto. |
| ID_EDIT_FIND_FINDMSG | 62 | dto. |

Alle 15 liegen unter 64, also im Bereich des ersten Bitmaps.

### Was damit AUSGESCHLOSSEN ist

1. **Das Zusammensetzen der drei Bitmaps ist nicht die Ursache.**
   `QCEnableLargeBtns` (`QCToolBarManager.cpp:283-540`) setzt die drei
   Ressourcen zu einer Bitmap zusammen und benutzt dabei bei der Vorgabe
   `ToolbarDisplayFix=0` (`EudoraRes.rc:8621`) den `SECDib`-Weg ueber
   `StretchDIBits` (`QCToolBarManager.cpp:415-455`). Selbst wenn dieser Weg
   fuer die Teile A und B versagte, waeren die 15 sichtbaren Knoepfe davon
   nicht betroffen - sie stehen alle im ersten, zuerst kopierten Stueck.
   Ein Ausfall des ersten `StretchDIBits` wuerde ALLE 15 leer lassen, nicht
   einzelne.

2. **Eine nicht gefundene Befehlskennung ist nicht die Ursache.**
   `SECCustomToolBar::IDToBmpIndex` (`OTShim_Werkzeugleiste.cpp:1922-1937`)
   liefert bei unbekannter Kennung `0`. Der Knopf zeigte dann das ERSTE Bild
   (Papierkorb), also ein falsches Symbol - nie ein leeres graues Feld.

3. **Verschobene Bildplaetze durch Trenner sind nicht die Ursache** (siehe
   oben: keine Trenner in den Ressourcen, Zahlen stimmen exakt).

4. **Nicht gesetzte Systemfarben sind nicht die Ursache.**
   `secData` ist echt vorhanden: `OT501/Src/secaux.cpp:23` definiert es, und
   die Datei ist in `Eudora/Eudora.vcxproj:217` als `ClCompile` eingetragen.
   `SEC_AUX_DATA::UpdateSysColors` (`secaux.cpp:52-70`) holt die echten
   Systemfarben. `clrBtnFace`, `clrBtnShadow`, `clrBtnHilite` sind also
   gefuellt.

5. **`QCCustomToolBar` ueberschreibt das Zeichnen nicht.** Gemessen ueber
   `QCCustomToolBar.cpp` und `.h`: es gibt kein `DoPaint`, kein `DrawButton`,
   kein `DrawFace`. Gezeichnet wird ausschliesslich mit
   `SECCustomToolBar::DoPaint` (`OTShim_Werkzeugleiste.cpp:2639-2659`) und
   `SECStdBtn::DrawButton` (`OTShim_Werkzeugleiste.cpp:851-897`).

6. **Die Puffergrenze in `DrawButton` ist fuer die Hauptleiste ausgeschlossen.**
   `OTShim_Werkzeugleiste.cpp:877-878` steigt aus, wenn `m_cx > data.m_cxBuf`.
   `m_cxBuf` kommt aus `m_nMaxBtnWidth` (`PreDrawButton`, Z. 347). Dieser Wert
   wird an drei Stellen mitgezogen - `SetToolBarInfo` (Z. 1893-1901),
   `CreateButton` (Z. 2084-2085) und `SetButtons` (Z. 2120) - und kann daher
   nicht kleiner sein als ein `m_cx`. Fuer Leisten, deren Knoepfe NACH dem
   Anlegen wachsen (`SECWndBtn::AdjustSize`, Z. 1055), bleibt der Weg offen;
   die Hauptleiste hat keine solchen Knoepfe (`btnMap` ist leer,
   `mainfrm.cpp:280-281`).

### Die Spur, die als naechstes zu verfolgen ist (UNGEPRUEFT)

**Verdacht A - der Weg fuer GESPERRTE Knoepfe.** Er passt als einziger auf das
Muster "einzelne leer, andere da".

Auf einer frisch gestarteten Eudora ohne ausgewaehlte Nachricht sind gerade
`Delete`, `Reply`, `Reply All`, `Forward`, `Previous`, `Next`, `Attach` und
`Print` gesperrt - acht von fuenfzehn. Uebrig blieben `In`, `Out`, `Check Mail`,
`New Message`, `Nicknames`, `Find`, `Help`. Gregors Bild zeigt eine Leiste, in
der genau so etwas wie die Haelfte fehlt. Auf seinem VERGLEICHSBILD ist ein
Nachrichtenfenster offen, dort waeren dieselben Knoepfe FREIGEGEBEN und also
sichtbar. Das erklaert auch, warum das Original vollstaendig aussieht.

Gesperrte Knoepfe laufen ueber `SECStdBtn::DrawDisabled`
(`OTShim_Werkzeugleiste.cpp:786-801`):

```
CreateMask(data, x, y, nWidth, nHeight);
CBrush brHilite(secData.clrBtnHilite);
CBrush brShadow(secData.clrBtnShadow);
CBrush* pOld = data.m_drawDC.SelectObject(&brHilite);
data.m_drawDC.BitBlt(x + 1, y + 1, nWidth, nHeight, &data.m_monoDC, 0, 0,
                     OTSHIM_ROP_MASKED_PATTERN);
data.m_drawDC.SelectObject(&brShadow);
data.m_drawDC.BitBlt(x, y, nWidth, nHeight, &data.m_monoDC, 0, 0,
                     OTSHIM_ROP_MASKED_PATTERN);
```

**Was hier fehlt:** die klassische Vorlage (MFC, `winctrl3.cpp`, und dieselbe
Stelle in jeder Lehrbuchfassung dieses Verfahrens) setzt VOR den beiden
`BitBlt` ausdruecklich

```
dc.SetTextColor(0x00000000L);     // Einfarbig 0 -> 0
dc.SetBkColor  (0x00FFFFFFL);     // Einfarbig 1 -> 1
```

Der Grund: beim Kopieren von einem EINFARBIGEN in einen FARBIGEN Kontext
uebersetzt GDI die 1 in die **Hintergrundfarbe des Zielkontextes** und die 0 in
dessen **Textfarbe**. Die Verknuepfungszahl `PSDPxax` (`0x00B8074A`) rechnet
bitweise `Ergebnis = S ? D : P`; sie setzt also voraus, dass das uebersetzte S
entweder ganz aus Einsen (0xFFFFFF) oder ganz aus Nullen (0x000000) besteht.

**Im Shim ist das Ziel `data.m_drawDC` aber nicht auf Weiss/Schwarz gesetzt.**
Schlimmer: `SECStdBtn::DrawFace` ruft in Zeile 704
`data.m_drawDC.FillSolidRect(x, y, nWidth, nHeight, secData.clrBtnFace)`, und
`CDC::FillSolidRect` ist in MFC als `::SetBkColor(m_hDC, clr)` plus
`::ExtTextOut(..., ETO_OPAQUE, ...)` umgesetzt - **die Hintergrundfarbe bleibt
danach auf `clrBtnFace` stehen.** Beim `BitBlt` aus `m_monoDC` wird die
Maskeneins deshalb nicht nach `0xFFFFFF`, sondern nach `clrBtnFace` uebersetzt.

Ob daraus ein leeres Feld wird, haengt an den Bits der Systemfarbe:

- Windows-10-Vorgabe `clrBtnFace = 0xF0F0F0`: von Hand durchgerechnet ergibt
  sich trotzdem noch das richtige Bild (die unteren vier Bits sind null, und
  der zweite Durchgang stellt wieder her, was der erste verbogen hat).
- Jede Farbe mit gesetzten unteren Bits - Windows XP benutzt `0xECE9D8`, das
  klassische Grau ist `0xD4D0C8` - laesst diese Rechnung NICHT aufgehen.
  Wieviel dann noch sichtbar bleibt, ist **nicht durchgerechnet**.

**Was zu tun waere:** die beiden fehlenden Zeilen ergaenzen und danach die
Farben wiederherstellen. Das kostet nichts, macht den Weg von der Systemfarbe
unabhaengig und stellt genau die Vorlage her, der der uebrige Zeichencode
folgt. Es ist der billigste sinnvolle naechste Schritt an Punkt 1.

Derselbe Mangel steht ein zweites Mal in `SECStdBtn::CreateMask`
(`OTShim_Werkzeugleiste.cpp:765-771`): dort wird zwar die Hintergrundfarbe der
QUELLE richtig gesetzt (das ist die Regel fuer Farbe -> Einfarbig und stimmt),
aber `DrawChecked` (Z. 806-828) setzt fuer den umgekehrten Weg Text- und
Hintergrundfarbe sehr wohl - `DrawDisabled` als einzige nicht. Die
Ungleichbehandlung innerhalb derselben Datei ist ein zusaetzliches Anzeichen,
dass hier etwas vergessen wurde.

**Verdacht B - `TBBS_HIDDEN`.** `SECStdBtn::DrawButton` steigt in
`OTShim_Werkzeugleiste.cpp:856-858` bei gesetztem `TBBS_HIDDEN` aus, OHNE etwas
zu malen; die Anordnungsrechnung behaelt den Platz aber bei. Das ergaebe
buchstaeblich ein leeres graues Feld an der richtigen Stelle. **Nicht geprueft:
wer `TBBS_HIDDEN` setzt.** Zu suchen ist in `QCCustomToolBar.cpp` und in
`SECCustomToolBar::SetButtonStyle`.

**Verdacht C - `SECBtnDrawData` wird geteilt.** `GetDrawData()` (Aufruf in
`DoPaint`, Z. 2650) - **nicht nachgesehen, ob das ein statisches oder ein
Leisten-eigenes Objekt ist.** Falls statisch, teilen sich Hauptleiste,
Suchleiste und die Leisten der Nachrichtenfenster einen Puffer und eine
Bitmapauswahl. `PreDrawButton` waehlt `m_hBmp` in `m_bmpDC` aus (Z. 353);
dieselbe Bitmap laesst sich nicht gleichzeitig in zwei Geraetekontexte
auswaehlen - `::SelectObject` liefert dann NULL und der spaetere `BitBlt` malt
nichts. Das waere ein Weg, auf dem eine ganze Leiste leer bliebe.

### Die Messung, die den Streit entscheidet

Ich haette dafuer ein **fensterloses** Messprogramm gebaut (Teilsystem WINDOWS,
legt kein Fenster an, schreibt nur eine Textdatei), das

1. `Eudora.exe` mit `LoadLibraryEx(..., LOAD_LIBRARY_AS_DATAFILE)` oeffnet,
2. `IDR_MAINFRAME32/A/B` genau so laedt und zusammensetzt, wie
   `QCEnableLargeBtns` es tut,
3. fuer jeden der 176 Bildplaetze prueft, ob er einfarbig (= leer) ist,
4. das Ergebnis in eine Datei schreibt.

Damit waere in einem Lauf entschieden, ob die zusammengesetzte Bitmap
vollstaendig ist. Ist sie es - und danach sieht es aus -, liegt der Fehler
zwingend im Zeichnen je Knopf, also bei Verdacht A, B oder C.

---

## Punkt 2 - die sich ueberlagernden Bereiche

**Ursache gefunden und belegt. Es ist kein Fehler, sondern eine offene
Baustelle: die prozentuale Zeilenaufteilung der Andockleiste fehlt vollstaendig.**

Die Ersatzschicht sagt es an ihrer eigenen Deklaration, `OTShim.h:695-699`:

> STUFE 2 OFFEN: die Splitter selbst. AddSplitter wird nie aufgerufen, also
> bleibt m_arrSplitters leer, HitTest liefert NULL und CalcTrackingLimits
> (samt der Eudora-Ueberschreibung DockBar.cpp:149) wird nie erreicht.
> Dasselbe gilt fuer NormalizeRow und die prozentualen Zeilenbreiten.
> **Die Leisten liegen dadurch so, wie CDockBar sie anordnet.**

Die Belege im Code, alle in `Eudora71/OTShim/OTShim.cpp`:

| Stelle | Zustand |
|---|---|
| `SECDockBar::CalcFixedLayout` Z. 2505-2508 | reicht 1:1 an `CDockBar::CalcFixedLayout` durch |
| `SECDockBar::OnSizeParent` Z. 2990-2993 | reicht 1:1 an `CDockBar::OnSizeParent` durch |
| `SECDockBar::NormalizeRow` Z. 2239-2266 | zaehlt nur die Leisten der Zeile, **verteilt keine Breite** |
| `SECDockBar::SetControlBarWidthsInRow` Z. 2226-2228 | leerer Rumpf |
| `SECDockBar::CalcDockingLayout` Z. 2513-2520 | gibt das Eingangsrechteck unveraendert zurueck |
| `SECDockBar::SetRowHeight` / `AdjustRowHeight` Z. 2524-2530 | leere Ruempfe |
| `SECMDIFrameWnd::DockControlBarEx` Z. 274-291 | legt `fPctWidth` ab, **wertet es nicht aus** (steht so im Kommentar Z. 262-264) |

Dazu kommt `SECControlBar::CalcFixedLayout` (`OTShim.cpp:1606-1630`): bei
gesetztem `bStretch` liefert sie in Zeilenrichtung **32767**. Jede Wazoo-Leiste
fordert also die volle Zeilenbreite an. MFCs `CDockBar` kennt keine
prozentuale Aufteilung einer Zeile auf mehrere Leisten - es reiht sie
aneinander und beschneidet nicht. Genau das ergibt

- den Adressbuch-Bereich ueber der Nachrichtenliste,
- den schmalen leeren senkrechten Streifen zwischen den Bereichen,
- und (Punkt 3) den Registerkartenstreifen "Task Status"/"Task Errors" mitten
  im Fenster: das ist eine Wazoo-Leiste, die zwar eine Zeilenposition, aber
  keine sinnvolle Breite zugeteilt bekommt.

**Ausgeschlossen** ist, dass es an der abgeschalteten Werbeleiste liegt.
`QCDockBar::IsControlBarAtMaxWidthInRow` (`DockBar.cpp:51-75`) und
`::IsOnlyControlBarInRow` (`DockBar.cpp:82-99`) pruefen selbst auf
`SWM_MODE_ADWARE` und fallen sonst auf `SECDockBar` zurueck - dieser Zustand ist
von QUALCOMM vorgesehen. Bestaetigt frueheren Befund S-6.

### Was zu bauen ist

Eine echte Nachbildung, nicht eine Korrektur. Kern:

1. `SECDockBar::OnSizeParent` muss selbst rechnen statt durchzureichen:
   je Zeile die verfuegbare Breite ermitteln, sie anhand von
   `SECControlBar::m_fPctWidth` auf die sichtbaren Leisten der Zeile verteilen
   und dazwischen `Splitter::cx` (= 4, `OTShim.cpp:2091`) freilassen.
2. `SECDockBar::NormalizeRow` muss die `m_fPctWidth`-Summe einer Zeile auf 1.0
   normieren - darauf baut `QCDockBar::NormalizeRow` (`DockBar.cpp:225-297`)
   auf, das nach dem Basisaufruf die Werbeleistenbreite herausrechnet.
3. `AddSplitter` muss beim Anordnen tatsaechlich gerufen werden, damit
   `m_arrSplitters` gefuellt ist; sonst gibt es keine Ziehmarken zwischen den
   Bereichen und `HitTest` liefert weiter NULL.

Die Struktur von `m_arrBars` ist dabei zu beachten: `QCDockBar::FindControlBarLocation`
(`DockBar.cpp:106-137`) unterscheidet ausdruecklich zwischen
"`GetDockedControlBar(nPos)` liefert NULL **und** `m_arrBars[nPos]` ist NULL"
(= Zeilenende) und "`GetDockedControlBar` liefert NULL, `m_arrBars[nPos]` aber
nicht" - letzteres sind im Original die Splitter-Eintraege. Wer die Splitter
nachbaut, muss diese Unterscheidung erhalten, sonst zerfaellt Eudoras eigene
Zeilen- und Spaltenzaehlung.

---

## Punkt 3 - "Task Status / Task Errors" als senkrechter Streifen mitten im Fenster

**Nicht getrennt untersucht.** Nach dem Befund zu Punkt 2 ist das mit hoher
Wahrscheinlichkeit dieselbe Ursache: eine Wazoo-Leiste, die ihre Zeilenbreite
nicht zugeteilt bekommt und deshalb mit ihrer eigenen Wunschbreite an einer
Stelle stehenbleibt, an der sie im Original nur ein Bruchteil der Zeile waere.
**UNGEPRUEFT.**

Zu pruefen waere, ob der Aufgabenstatus-Wazoo ueberhaupt in der richtigen
Andockleiste sitzt: `CWazooBarMgr::CreateInitialWazooBars`
(`mainfrm.cpp:1689`) und `WazooBarMgr.cpp:242, 366, 375, 425` uebergeben
`nCol`, `nRow` und `fPctWidth` an `SECMDIFrameWnd::DockControlBarEx` -
und **`nCol` und `nRow` werden dort verworfen** (`OTShim.cpp:274`, die beiden
Argumente sind auskommentiert benannt). Die Leisten landen also in der
Reihenfolge, in der MFC sie einsortiert, nicht in der, die Eudora verlangt.
Das allein kann eine Leiste an eine voellig falsche Stelle bringen.

---

## Punkt 4 - die fehlende Fensterleiste unten ("Auto-Wazoo", "MDI Task Bar")

**Nicht untersucht.** Was aus den vorhandenen Unterlagen feststeht:

- Die Ersatzschicht meldet sie ausdruecklich als nicht umgesetzt
  (`OTShimNichtUmgesetzt`, `OTShim.cpp:153`; Meldungstext neu gefasst in
  `OTShim.cpp:165-167`, siehe Befund S-3a).
- `PLAN.md` (Abschnitt "Der Weg zum ersten startenden Eudora.exe") haelt fest:
  `SECWorkbook` ist kein Behaelter fuer ein Registerkarten-Steuerelement,
  sondern ein `CMDIFrameWnd`, der seine Registerkarten mit GDI-Polygonen
  selbst in einen Randstreifen malt, den `SECWorkbookClient` per `SetMargins`
  freihaelt. In Stufe 1 wurde `m_bWorkbookMode` hart auf `FALSE` gesetzt und
  `SetMargins` auf (0,0,0,0); alle Zeichen-Overridables (`OnDrawTab`,
  `OnDrawBorder`, `OnDrawTabIconAndLabel`) sind leer.
- Eudora schaltet sie ueber `ShowMDITaskBar(GetIniShort(IDS_INI_MDI_TASKBAR))`
  (`mainfrm.cpp:1025`); jede Auswertung haengt hinter `m_bWorkbookMode`
  (`workbook.cpp:1065,1101,1741`, `mainfrm.cpp:8438,8484,8549,8654`).
- `GetTabPts` muss ein `new CPoint[n]` mit mindestens 6 Punkten liefern; der
  Aufrufer prueft `ASSERT(count > 5)` und gibt mit `delete[]` frei
  (`workbook.cpp:987`, `757`).

**Aufwandsschaetzung, UNGEPRUEFT:** mittel. Die Geruestteile
(`AddSheet`/`RemoveSheet`/`GetTabPts`) sind vorhanden; zu bauen waeren
`m_bWorkbookMode = TRUE`, echte Raender in `SetMargins`, das Zeichnen der
Registerkarten und die Trefferpruefung in `OnLButtonDown`. Das ist eine eigene
Sitzung wert - aber **erst nach den Punkten 1 bis 3**, weil ohne korrekte
Andockrechnung ohnehin nichts an der richtigen Stelle landet.

---

## Bauzustand

`Eudora.vcxproj`, Debug/Win32, gemessen an `31810e2` **ohne jede Aenderung von
mir**:

```
LINK : fatal error LNK1104: Datei "imap.lib" kann nicht geoeffnet werden.
```

Alle Quelldateien uebersetzen fehlerfrei (einschliesslich der sieben
`OTShim_*.cpp` und `OT501/Src/secaux.cpp`); es scheitert allein am Linker,
weil `imap.lib` im Arbeitsverzeichnis fehlt. Das ist derselbe Zustand wie vor
meiner Sitzung und deckt sich mit dem Hinweis in `BEFUNDE.md` (S-3b), dass der
Release-Zweig an fehlender `Imap.lib` scheitert - hier trifft es auch Debug,
weil `BuildProjectReferences=false` das `imapdll`-Projekt nicht mitbaut.
**Zu pruefen:** ob ein Bau ohne `/p:BuildProjectReferences=false` oder ein Bau
der ganzen Solution die Datei erzeugt.

Der MSBuild-Aufruf aus dem Auftrag laeuft aus der Git-Bash **nicht** durch:
die Bash macht aus `/p:Configuration=Debug` einen Pfad. Er muss aus PowerShell
gestartet werden. Der Pfad ist auf diesem Rechner
`C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe`
(**Professional**, nicht Community).

---

## Zweite Sitzung, 31.08.2026 - die Umsetzung

Branch `ansicht-darstellung`, ausgehend von `76efdb6` (`darstellung-und-menue`).
Wieder ohne einen einzigen Programmstart (Auflage: keine Fenster auf Gregors
Sitzung). Alles Folgende ist Quellcodeanalyse plus Kontrolluebersetzung.

### Was geaendert wurde

#### 1. `SECStdBtn::DrawDisabled` - Text- und Hintergrundfarbe (Commit `db28adb`)

`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp`, in `DrawDisabled`.

Vor den beiden `BitBlt` stehen jetzt

```
COLORREF crOldText = data.m_drawDC.SetTextColor(0x00000000L);
COLORREF crOldBk   = data.m_drawDC.SetBkColor(0x00FFFFFFL);
```

und am Ende die Wiederherstellung. Begruendung wie in Verdacht A oben: beim
Kopieren von EINFARBIG nach FARBIG uebersetzt GDI die Maskeneins in die
Hintergrund- und die Maskennull in die Textfarbe des ZIELkontextes; `PSDPxax`
rechnet bitweise und setzt voraus, dass daraus `0xFFFFFF` bzw. `0x000000`
werden. In `data.m_drawDC` stand statt dessen noch `secData.clrBtnFace`, weil
`DrawFace` sie ueber `CDC::FillSolidRect` (= `SetBkColor` + `ExtTextOut` mit
`ETO_OPAQUE`) gesetzt und stehengelassen hat.

**Was gewirkt haben muesste:** die acht gesperrten Knoepfe der Hauptleiste
werden wieder als eingepraegtes graues Bild gezeichnet statt als leeres Feld.
**UNGEPRUEFT ohne Programmstart.** Die Rechnung geht bei
`clrBtnFace = 0xF0F0F0` (Windows-10-Vorgabe) auch vorher schon auf; ob Gregors
Sitzung diese Farbe benutzt, ist nicht gemessen. Die Aenderung stellt in jedem
Fall die Vorlage her und macht das Ergebnis von der Systemfarbe unabhaengig.

#### 2. `SECBtnDrawData::PreDrawButton` - `::SelectObject` wird geprueft

Dieselbe Datei, in `PreDrawButton`, Abschnitt "1. Kontext mit der
Leistenbitmap".

**Verdacht C ist damit halb geklaert.** `GetDrawData()` liefert wirklich einen
GETEILTEN Puffer: `SECCustomToolBar::GetDrawData` reicht an
`SECToolBarManager::GetDrawData` durch, und das gibt das Feld `m_drawData`
zurueck (`OTShim_Werkzeugleiste.h:1123`). Alle Leisten EINES Verwalters teilen
sich also `m_bmpDC`, und ueber `SetToolBarInfo` teilen sie sich auch dieselbe
`HBITMAP` (`m_bOwnBitmap` ist dann `FALSE`).

**Ein dauerhafter Konflikt ist trotzdem ausgeschlossen:** `PostDrawButton`
waehlt die Bitmap am Ende jedes `DoPaint` wieder ab, und `WM_PAINT` laeuft je
Faden nacheinander. Ein Fehlschlag bliebe aber unbemerkt, weil der
Rueckgabewert nicht ausgewertet wurde - `m_bmpDC` behielte dann seine
1x1-Vorgabebitmap und JEDES `BitBlt` daraus maelte einen leeren Knopf. Der
Rueckgabewert wird jetzt geprueft; im Fehlerfall wird gar nicht gemalt und eine
`TRACE`-Zeile geschrieben.

#### 3. `TBBS_HIDDEN` - Verdacht B ist ausgeraeumt

Gemessen mit einer Volltextsuche ueber `Eudora71/`:

| Fundstelle | Bedeutung |
|---|---|
| `OT501/Include/Sbartool.h:163` | die Definition |
| `OTShim_Werkzeugleiste.cpp:875` | `DrawButton` steigt aus |
| `OTShim_Werkzeugleiste.cpp:1371` | Trefferpruefung steigt aus |
| `Eudora/TocFrame.cpp:3093,3095` | **die einzige setzende Stelle** |

`CTocFrame::ShowHideSplitter` setzt es auf `m_PeanutToolBar` - der kleinen
Leiste eines Postfachfensters -, und zwar nur fuer die Knoepfe ab Index 2 und
nur, wenn der Dateibrowser aus ist. **Die Hauptleiste des Rahmenfensters ist
davon nicht betroffen.** Verdacht B scheidet als Erklaerung fuer die leeren
Knoepfe der Hauptleiste aus.

#### 4. Die Andockrechnung - prozentuale Zeilenbreiten

`Eudora71/OTShim/OTShim.cpp` und `OTShim.h`.

**Die eigentliche Ursache ist gefunden und belegt, und sie ist eine andere als
im ersten Befund vermutet.** Der Kern steht in MFCs
`CDockBar::DockControlBar` (`bardock.cpp:165-172`):

```
else
{
    // always add on current row, then create new one
    m_arrBars.Add(pBar);
    m_arrBars.Add(NULL);
    ...
}
```

`SECMDIFrameWnd::DockControlBarEx` rief `CMDIFrameWnd::DockControlBar(pBar,
nDockBarID, NULL)` - **ohne Rechteck**. Damit landet JEDE Leiste in einer
EIGENEN ZEILE, ganz gleich, welches `nCol`/`nRow` Eudora verlangt hat. Die
prozentualen Breiten konnten deshalb gar nicht zum Tragen kommen: in einer
Zeile mit genau einer Leiste gibt es nichts zu verteilen.

Der zweite Teil steht in `CDockBar::CalcFixedLayout` (`bardock.cpp:360-545`).
Sie fragt jede Leiste ueber `CalcDynamicLayout` nach ihrer Wunschgroesse, und
`SECControlBar::CalcFixedLayout` lieferte in Zeilenrichtung `32767`. Folge
(`bardock.cpp:441-447`): sobald doch einmal zwei Leisten in einer Zeile
stuenden, schoebe MFC eine `NULL`-Marke dazwischen und braeche sie in zwei
Zeilen um. Die Aufteilung war also doppelt verriegelt.

Umgesetzt sind jetzt:

| neu | Datei | was es tut |
|---|---|---|
| `SECDockBar::MoveControlBarToPosition` | `OTShim.cpp` | schiebt den Eintrag in `m_arrBars` nach dem Andocken an die von Eudora verlangte Zeile und Spalte |
| `SECDockBar::AssignRowExtents` | `OTShim.cpp` | ermittelt die verfuegbare Zeilenlaenge genau so wie `CDockBar::CalcFixedLayout` (`bardock.cpp:366-380`) und geht die Zeilen durch |
| `SECDockBar::DistributeRow` | `OTShim.cpp` | verteilt die Laenge anhand von `m_fPctWidth` auf die sichtbaren Leisten einer Zeile, mit unterer Schranke und Restausgleich bei der letzten |
| `SECDockBar::ClearRowExtents` | `OTShim.cpp` | nimmt die Zuteilung nach dem Durchlauf zurueck |
| `SECDockBar::CalcFixedLayout` | `OTShim.cpp` | klammert `CDockBar::CalcFixedLayout` zwischen die beiden |
| `SECControlBar::m_nRowExtent` | `OTShim.h` | die Zuteilung; 0 heisst "keine" |
| `SECControlBar::CalcFixedLayout` | `OTShim.cpp` | liefert `m_nRowExtent` statt `32767`, wenn eine Zuteilung vorliegt |
| `SECDockBar::NormalizeRow` | `OTShim.cpp` | normiert die Summe der Anteile einer Zeile auf 1.0 - genau das, worauf `QCDockBar::NormalizeRow` (`DockBar.cpp:225-296`) aufsetzt |
| `SECMDIFrameWnd::DockControlBarEx` | `OTShim.cpp` | wertet `nCol` und `nRow` aus, statt sie zu verwerfen |

Die Zeilenzaehlung folgt `QCDockBar::FindControlBarLocation`
(`DockBar.cpp:110-140`): die fuehrende `NULL`-Marke aus dem `CDockBar`-
Konstruktor (`bardock.cpp:36`) beendet eine leere Zeile VOR Zeile 0. Zeile
`nRow` beginnt also hinter der `(nRow+1)`-ten `NULL`. `m_arrBars` endet nach
dem Verschieben weiterhin mit einer `NULL`-Marke.

**Was gewirkt haben muesste** (alles UNGEPRUEFT ohne Programmstart):

- Die Wazoo-Leisten sitzen in der Zeile und Spalte, die Eudora verlangt:
  Postfachbaum links (`WazooBarMgr.cpp:377`, Spalte 0, Zeile 0),
  Aufgabenstatus unten (`:436`, Spalte 1, Zeile 0), Werbeleiste unten
  (`AdWazooBar.cpp:176`, Spalte 5).
- Die Suchleiste steht neben der Hauptwerkzeugleiste statt darunter
  (`mainfrm.cpp:966` uebergibt `nCol+1, nRow`).
- Kein Leistenfenster ist mehr 32767 Bildpunkte breit.
- Zwei Leisten in derselben Zeile teilen sich die Breite nach `m_fPctWidth`,
  statt uebereinander umgebrochen zu werden.

**Was NICHT umgesetzt ist:** die Splitter zwischen den Bereichen.
`AddSplitter` wird weiterhin nie gerufen, `m_arrSplitters` bleibt leer,
`HitTest` liefert `NULL`. Es gibt also keine Ziehmarken, mit denen der Anwender
die Aufteilung aendern koennte; die Anteile stehen so, wie Eudora sie vorgibt.
Zwischen den Leisten wird auch kein Platz fuer einen Splitter freigelassen -
`DistributeRow` verteilt die volle Zeilenlaenge.

### Was OFFEN bleibt

#### Punkt 4 des ersten Befundes: die MDI-Fensterleiste - unveraendert offen

Nicht angefasst. Der Befund von oben gilt weiter.

#### NEU UND WICHTIG: `FloatControlBarInMDIChild` tut nichts

`OTShim.cpp` (`SECMDIFrameWnd::FloatControlBarInMDIChild`) ist ein leerer
Rumpf mit `TRACE`. Das hat eine Folge, die im ersten Befund noch nicht stand
und die **wahrscheinlich der Rest der Ueberlagerungen ist**:

`CWazooBarMgr::SetDefaultWazooBarState` (`WazooBarMgr.cpp:365-445`) macht beim
ERSTEN Start fuer Gruppe 1 - Adressbuch (`CNicknamesWazooWnd`),
Verzeichnisdienste, Filter, Filterbericht, Linkverlauf - Folgendes:

```
pMainFrame->DockControlBarEx(pWazooBar, AFX_IDW_DOCKBAR_RIGHT, 0, 0, 1.00, 180);
pWazooBar->SendMessage(WM_COMMAND, ID_SEC_MDIFLOAT, 0);   // -> tut nichts
pMainFrame->RecalcLayout(FALSE);
...
QCControlBarWorksheet* pMDIFrame = (QCControlBarWorksheet *) pWazooBar->GetParentFrame();
ASSERT_KINDOF(QCControlBarWorksheet, pMDIFrame);
pMDIFrame->MoveWindow(rectMDIClient.left, rectMDIClient.top,
                      rectMDIClient.Width(), __max(rectMDIClient.Height(),355));
```

Weil `ID_SEC_MDIFLOAT` nichts bewirkt, bleibt die Leiste am RECHTEN Rand des
Hauptfensters angedockt. `GetParentFrame()` liefert dann **das Hauptfenster**,
nicht ein `QCControlBarWorksheet`. Im Debug-Bau schlaegt das `ASSERT_KINDOF`
zu; **im Release-Bau wird `MoveWindow` auf das HAUPTFENSTER angewandt** - mit
dem Rechteck des MDI-Klientbereichs. **UNGEPRUEFT**, aber das erklaerte
zwanglos ein Hauptfenster, dessen Bereiche nicht dorthin passen, wo sie
hingehoeren.

Zu pruefen ist als naechstes: ob `SECMDIFrameWnd::FloatControlBarInMDIChild`
so weit nachgebaut werden kann, dass `GetParentFrame()` wenigstens ein
`SECControlBarWorksheet` liefert. Das Geruest ist da
(`SECControlBarWorksheet`, `OTShim.h:1558`), `CreateFloatingMDIChild`
(`OTShim.cpp`) liefert bisher `NULL`.

#### Die Werbeleiste

`AdWazooBar.cpp:176` und `:212` docken mit `nCol = 5`. Nach dem Umbau wird das
auf das Zeilenende begrenzt. Das ist die Absicht - im Original steht die
Werbeleiste am Ende ihrer Zeile.

### Bauzustand dieser Sitzung

| was | Ergebnis |
|---|---|
| `Eudora71\Eudora\Eudora.vcxproj` Debug/Win32 `/t:ClCompile` | Exit 0, keine neuen Warnungen |
| `Eudora71\Tests\Tests.vcxproj` Debug/Win32 (voll, mit Linker) | Exit 0, `Eudora71\Tests\Build\Debug\EudoraTests.exe` erzeugt |

Der Testbau ist zugleich die Linkerprobe fuer `OTShim.cpp` - dort wird
`OTShim.cpp` mitgebunden, und das Programm entsteht vollstaendig. Der Linkerlauf
von `Eudora.exe` selbst scheitert weiterhin an fehlender `imap.lib` (Befund
S-3b), unabhaengig von dieser Sitzung.

**OFFENE BITTE AN GREGOR:** `EudoraTests.exe` wurde **nicht ausgefuehrt**. Es ist
ein Konsolenprogramm, und die Auflage dieser Sitzung lautete, kein Programm zu
starten. `TestOTShimAndocken.cpp:162-224` und `:371` pruefen genau die Fassung
`SECControlBar::CalcFixedLayout`, die hier geaendert wurde. Die Faelle sollten
weiter durchgehen, weil `m_nRowExtent` im Konstruktor auf 0 steht und die
Testleisten frisch angelegt werden - **gemessen ist das aber nicht.** Der Lauf
waere:

```
Eudora71\Tests\Build\Debug\EudoraTests.exe
```

---

## Stand und naechster Schritt

**Stand (31.08.2026, Branch `ansicht-darstellung`):**

| Punkt aus dem Auftrag | Zustand |
|---|---|
| 1 `DrawDisabled` Farben | **erledigt**, uebersetzt, eigener Commit |
| 2 `GetDrawData` / `SelectObject` | **erledigt** - geteilter Puffer belegt, Rueckgabewert wird geprueft |
| 3 `TBBS_HIDDEN` verfolgen | **erledigt** - nur `TocFrame.cpp:3093/3095`, betrifft die Hauptleiste nicht |
| 4 Andockrechnung | **umgesetzt**, uebersetzt; Splitter weiterhin offen |
| 5 `nCol`/`nRow` in `DockControlBarEx` | **erledigt** |

**Nicht gemessen, weil kein Programmstart erlaubt war:** ob eine der
Aenderungen auf dem Bildschirm das tut, was sie soll. Alle Wirkungsaussagen
oben sind als UNGEPRUEFT gekennzeichnet.

**Was als naechstes dran waere, in dieser Reihenfolge:**

1. **Einmal starten und ein Bildschirmfoto machen.** Ohne das ist jeder
   weitere Schritt geraten. Zu vergleichen sind die vier Merkmale aus
   `ZIEL.md`, "Woran sich Kriterium 2 misst".
2. **`SECMDIFrameWnd::FloatControlBarInMDIChild`** (`OTShim.cpp`) - siehe den
   Abschnitt "NEU UND WICHTIG" oben. Das ist jetzt der groesste bekannte
   verbliebene Einzelposten am Erscheinungsbild. Der Weg fuehrt ueber
   `CreateFloatingMDIChild` (`OTShim.cpp`, liefert bisher `NULL`) und
   `SECControlBarWorksheet` (`OTShim.h:1558`).
3. **Die Splitter** - `SECDockBar::AddSplitter` wird nie gerufen. Erst damit
   kann der Anwender die Aufteilung selbst aendern und
   `SECDockBar::SetControlBarWidthsInRow` (leerer Rumpf) bekommt einen
   Aufrufer. Ansatz: in `AssignRowExtents` zwischen je zwei Leisten
   `Splitter::cx` freilassen und dort einen `Splitter` anlegen.
4. **Die MDI-Fensterleiste unten** (`m_bWorkbookMode`) - siehe Punkt 4 des
   ersten Befundes. Erst nach 1 bis 3.

**Woran Gregor auf einem Bildschirmfoto sehen wuerde, dass es geklappt hat:**
kein leeres graues Feld mehr in der Werkzeugleiste (gesperrte Knoepfe grau,
aber erkennbar); Postfachbaum links als eigener Streifen; Suchleiste neben der
Werkzeugleiste statt darunter; keine Leiste mehr, die die ganze Fensterbreite
belegt, obwohl sie sich die Zeile teilen sollte.
