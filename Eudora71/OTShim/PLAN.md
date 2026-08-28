# OT501-Ersatzschicht — Umsetzungsplan

Grundlage: die vier Familienanalysen vom 28.08.2026 gegen die Bestandsaufnahme
in [INVENTAR.md](INVENTAR.md). Jede Aussage hier ist an Header- und Aufrufstellen
belegt; wo etwas unbelegt blieb, steht es ausdrücklich dabei.

## Kernergebnis

Die 77 Methoden aus dem Inventar sind **nicht** 77 Aufgaben. Sie zerfallen in drei
Kategorien, und nur eine davon kostet Arbeit:

| Kategorie | Bedeutung | Konsequenz |
|---|---|---|
| **A** | Gar keine Stingray-Methode, sondern eine geerbte MFC-Methode, die Eudora nur qualifiziert aufruft (`SECFoo::Bar()` ist auch für rein geerbte Member erlaubt) | Kein Code. Muss nur über die Vererbungskette erreichbar sein |
| **B** | Echte Stingray-Funktionalität | Nachbauen |
| **C** | Deklariert, aber von Eudora nie aufgerufen — Qualcomm hat sie durch eigene Varianten ersetzt, oder die Treffer im Inventar stammen aus Kommentaren | Leerer Rumpf oder Deklaration |

Die Kategorie-A-Fälle sind der Grund, warum die Schicht kleiner ausfällt als befürchtet.
In der Workbook-Familie sind von 16 gelisteten Methoden nur **6** überhaupt in
Stingray-Headern deklariert.

## Der Weg zum ersten startenden `Eudora.exe`

**Die Registerkartenleiste ist verzichtbar.** Sie ist keine Struktur, sondern eine zur
Laufzeit umschaltbare Anwendereinstellung:

```
ShowMDITaskBar(GetIniShort(IDS_INI_MDI_TASKBAR))      mainfrm.cpp:1025
```

Jede Auswertung der Tabs steht hinter `m_bWorkbookMode` (`workbook.cpp:1075,1100,1741`;
`mainfrm.cpp:8438,8484,8549,8654`). Bei `FALSE` läuft nichts davon an — ein von Qualcomm
vorgesehener, über die Einstellungen erreichbarer Zustand (`settings.cpp:1055-1060`).

`SECWorkbook` ist auch kein Tab-Control-Container, sondern ein `CMDIFrameWnd`
(`SECWB.H:118` → `swinmdi.h:53`), der seine Tabs mit GDI-Polygonen selbst in einen
Randstreifen malt, den `SECWorkbookClient` per `SetMargins` freihält.

**Damit entfällt für Stufe 1 der gesamte Zeichencode — der teuerste Posten.**

Nicht verzichtbar ist der MDI-Unterbau: alle Dokumentfenster sind Worksheets
(`mdichild.h:14`), und `m_pWBClient` wird unabhängig vom Tab-Modus vorausgesetzt
(`mainfrm.cpp:1287-1294`, `3280-3283`). `SECWorkbookClient` muss das MDICLIENT-Fenster
also real subclassen, darf aber Ränder von (0,0,0,0) melden.

## Stufenplan

### Stufe 0 — die geschenkten Klassen

| Klasse | Vorgehen | Beleg |
|---|---|---|
| `SECStatusBar` (11 Methoden) | **`typedef CStatusBar SECStatusBar;`** — `sbarstat.h` ist eine 1:1-Kopie von `CStatusBar` (afxext.h:269) mit `SECControlBar` statt `CControlBar` als Basis. Alle 11 Aufrufe sind Kategorie A. Stingray macht für Nicht-WIN32 selbst `#define SECStatusBar CStatusBar` (`sbarstat.h:139`). Die Statusleiste wird nie über den SEC-Bar-Manager angefasst | `sbarstat.h:44,139` |
| `SECTipOfDay` | Stub: Konstruktor merkt die Werte, `DoModal()` liefert `IDOK`. Einzige Einstiegspunkte sind ein Menüpunkt und ein `PostMessage` beim Start; nichts hängt daran. Der INI-Rückschreibpfad (`eudora.cpp:256-257`) braucht nur plausible Werte | `SECTOD.H:41` |
| `SECLoadSysColorBitmap` | `CBitmap::LoadMappedBitmap` | `SECBTNS.H:340` |

### Stufe 1 — MDI ohne Registerkarten

Ziel: ein `Eudora.exe`, das startet.

- `SECMDIFrameWnd` : `CMDIFrameWnd`, `SECWorkbook` : `SECMDIFrameWnd`
- `SECMDIChildWnd` : `CMDIChildWnd`, `SECWorksheet` : `SECMDIChildWnd`
- `SECWorkbookClient` : `CWnd` mit echtem Subclassing des MDICLIENT, `SetMargins` → 0
- `m_bWorkbookMode` hart auf `FALSE`
- `AddSheet`/`RemoveSheet` als reine Listenpflege über `CObArray m_worksheets`
- alle Zeichen-Overridables (`OnDrawTab`, `OnDrawBorder`, `OnDrawTabIconAndLabel`) als No-Op

**Die Klassenkette darf nicht eingespart werden.** Eudora springt an fünf Stellen bewusst
über eine Vererbungsebene hinweg (`workbook.cpp:133,295,361,521,1165`); fehlt eine
Zwischenklasse, bricht das still.

`GetTabPts` muss auch im Stub ein `new CPoint[n]` mit **mindestens 6** Punkten liefern —
der Aufrufer prüft `ASSERT(count > 5)` und macht `delete[]` (`workbook.cpp:986`, `757`).

### Stufe 2 — Andockfamilie

Der aufwendigste Teil, weil hier echte Stingray-Funktionalität steckt, die MFC nicht hat:
prozentuale Zeilenbreiten (`m_fPctWidth`) und Splitter.

- `SECControlBar` : `CControlBar` — `Create` selbst bauen (`CControlBar` hat keins),
  `CalcFixedLayout`, `GetBarInfoEx`/`SetBarInfoEx`, `OnBarFloat`, `OnBarMDIFloat`,
  `OnFloatAsMDIChild`, `OnUpdateCmdUI` (in MFC rein virtuell)
- `SECDockBar` : `CDockBar` — `NormalizeRow`, `CalcTrackingLimits`,
  `IsControlBarAtMaxWidthInRow`, `IsOnlyControlBarInRow`, Klasse `Splitter` feldgenau
- `SECMiniDockFrameWnd` : `CMiniDockFrameWnd` mit **zweiter** Dockbar `m_wndSECDockBar`
  neben dem geerbten `m_wndDockBar` — beide müssen konsistent bleiben

Die Kommandos `ID_SEC_HIDE`/`ID_SEC_ALLOWDOCKING`/`ID_SEC_MDIFLOAT` (`SECRES.H:189-191`)
kommen per `SendMessage` an die Bar und brauchen echte Handler in der Message-Map.

### Stufe 3 — Werkzeugleisten und Knöpfe

**Für die schwierigste Methode existiert eine Vorlage im Repo.** `SECStdBtn::DrawFace`
ist das Kernstück des Owner-Draws — und `TBarSendButton.cpp:71-160` repliziert die
Original-Logik samt `secData`-Farben und `SEC_TBBS_RAISED` bereits vollständig, weil
Eudora sie überschreibt. Das Zeichenverhalten ist also ablesbar, nicht zu erraten.

`SECStdBtn` ist **weder `CObject` noch `CWnd`** — reine Zeichenobjekte in einem
`CPtrArray` der Leiste. Ein Umbau auf `CMFCToolBarButton` scheidet aus: er bräche die
`m_ulData`-Zugriffe an rund 20 Stellen.

Kategorie C in dieser Familie: `SECToolBarManager::EnableLargeBtns` und `LoadState`
werden nie aufgerufen — alle Inventartreffer sind Kommentare; Qualcomm hat sie durch
`QCEnableLargeBtns` und `QCLoadState` ersetzt. Aber `LargeBtnsEnabled()` und
`SetDefaultDockState()` **werden** gebraucht.

`SECComboBtn` erbt von `CComboBox` **und** `SECWndBtn` — die Mehrfachvererbung muss
erhalten bleiben (`TBarCombo.cpp:19,30`).

### Stufe 4 — Bilder

GDI+ über `CImage` (`atlimage.h`) deckt BMP/JPEG/GIF/PNG/TIFF ab; Eudora nutzt es
bereits selbst (`QCGraphics.cpp:582-604`). Damit entfällt das komplette eingebettete
libjpeg (`SECJPEG.H:207-830`).

**Aber `CImage` ersetzt nur den Dekoder, nicht die Schnittstelle.** Fünf Stellen greifen
roh auf `m_lpSrcBits`/`m_lpBMI` zu und reichen sie an `::StretchDIBits` weiter
(`mainfrm.cpp:5683`, `6158`, `6185`; `LinkHistoryManager.cpp:1238`;
`QCToolBarManager.cpp:428` u.a.). Die Datenmember bleiben, gefüllt über `::GetDIBits`.

`CreateFromBitmap` wird auf demselben Objekt mehrfach aufgerufen
(`QCToolBarManager.cpp:421,434,447`) — alte Puffer freigeben, sonst Leck.

## Fehler im Inventar

`INVENTAR.md` ist maschinell erzeugt und an mehreren Stellen irreführend. Vor der
Umsetzung zu korrigieren:

- **Falsche Positive:** `SECDockBar::CalcFixedLayout` stammt ausschließlich aus
  Kommentaren (`SearchBar.cpp` 7×). Ebenso `SECToolBarManager::EnableLargeBtns`,
  `LoadState`, `SECMDIFrameWnd::LoadBarState`, `SECControl`.
- **`SEC_TEXT` gehört nicht dazu** — das ist ein SSPI-Makro aus `Sspi.h`, kein Stingray.
- **`SECCustonToolBar` existiert nicht** — Tippfehler in einem Kommentar
  (`QCCustomizeToolBar.cpp:241`).
- **Fehlende Einträge:** `SECControlBar::GetBarInfo`/`SetBarInfo` (`WazooBarMgr.cpp:433,435`),
  `SECDockBar::GetControlBarRow`/`GetFirstControlBar`/`RemoveControlBar`,
  `SECControlBar::GetInsideRect`/`CalcInsideRect`/`IsMDIChild`, dazu die gesamte
  Zusatzoberfläche von `SECCustomToolBar` (rund 20 Member) und `SECStdBtn`.

## Was unabhängig vom Shim blockiert

Drei Dinge kosten Arbeit, haben aber mit OT501 nichts zu tun:

1. **`statbar.h:71`** deklariert `afx_msg void OnTimer(UINT)`; `ON_WM_TIMER()` verlangt in
   MFC 14 `UINT_PTR` — Compilerfehler unabhängig von der Shim-Wahl.
2. **`QCPng::LoadImage`** (`QCGraphics.cpp:353,379`) benutzt `png_ptr->jmpbuf` und
   direkten Strukturzugriff — libpng-1.2-API, seit 1.4 gekapselt.
3. **`QCChildToolBar.cpp:62`** bindet `ON_MESSAGE_VOID(WM_IDLEUPDATECMDUI, OnIdleUpdateCmdUI)`
   an einen Handler mit Signatur `LRESULT(WPARAM,LPARAM)` (`QCChildToolBar.h:24`) —
   Typmismatch, vermutlich aus einem früheren Portierungsschritt.

Dazu die vier Quelldateien, deren Header vorliegen, deren Implementierung aber in der
CHM-Freigabe fehlt: `TBarBmpCombo.cpp`, `TBarEdit.cpp`, `TBarStatic.cpp`, `spell.cpp`.
Die ersten drei sind Toolbar-Steuerelemente und gehören fachlich zu Stufe 3.

## Verfügbares Material

`secaux.cpp` ist die **einzige** OT501-Quelldatei, die die Freigabe enthält — und sie
liefert `secData` (`SEC_AUX_DATA`) mit den Systemfarben, die der Zeichencode an mehreren
Stellen direkt liest (`TBarSendButton.cpp:74`, `MoodMailStatic.cpp:63`,
`QCCustomizeToolBar.cpp:17`). Alles Übrige unter `OT501/Src/` ist Fremdcode
(libjpeg, zlib, TreeNode, Shortcut).

Jede Aussage über die *Innereien* der SEC-Implementierungen bleibt damit Rekonstruktion
aus den Erwartungen der Aufrufer.
