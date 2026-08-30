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
In der Workbook-Familie sind von 16 gelisteten Methoden nur **7** überhaupt in dem
Stingray-Header derjenigen Klasse deklariert, unter der das Inventar sie führt:
`SECMDIFrameWnd::LoadBarState` (`swinmdi.h:102`), `SECWorkbook::CreateClient`
(`SECWB.H:157`), `AddSheet` (`179`), `RemoveSheet` (`180`), `GetTabPts` (`182`),
`OnLButtonDown` (`209`) und `SECWorksheet::OnDestroy` (`SECWB.H:75`). Die übrigen
neun sind Kategorie A — sie stehen entweder in einer Basisklasse (`OnActivate`,
`RecalcLayout`), in einer *anderen* SEC-Klasse (`OnSize`, `OnClose` nur in
`SECControlBarWorksheet`; `SECMDIFrameWnd::OnLButtonDown` nur in `SECWorkbook`;
`SECMDIChildWnd::OnMDIActivate` nur in `SECWorksheet`, `SECWB.H:74`) oder gar nicht
in den Headern (`OnNotify`, `OnSetCursor`, `WindowProc`).

## Der Weg zum ersten startenden `Eudora.exe`

> **Teilweise widerlegt.** Der folgende Absatz gilt nur für den MDI-Registerkarten-
> streifen, nicht für das Registerkarten-Steuerelement in den Wazoo-Leisten. Siehe
> [Berichtigung 1](#1-die-registerkarten-sind-nicht-verzichtbar) am Ende der Datei —
> im Zweifel gilt die Berichtigung.

**Die Registerkartenleiste ist verzichtbar.** Sie ist keine Struktur, sondern eine zur
Laufzeit umschaltbare Anwendereinstellung:

```
ShowMDITaskBar(GetIniShort(IDS_INI_MDI_TASKBAR))      mainfrm.cpp:1025
```

Jede Auswertung der Tabs steht hinter `m_bWorkbookMode` (`workbook.cpp:1065,1101,1741`;
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
| `SECStatusBar` (11 Methoden) | **`typedef CStatusBar SECStatusBar;`** — `sbarstat.h` ist eine 1:1-Kopie von `CStatusBar` (`afxext.h:268` in MSVC 14.38.33130) mit `SECControlBar` statt `CControlBar` als Basis. Alle 11 Aufrufe sind Kategorie A. Stingray macht für Nicht-WIN32 selbst `#define SECStatusBar CStatusBar` (`sbarstat.h:140`). Die Statusleiste wird nie über den SEC-Bar-Manager angefasst | `sbarstat.h:43,140` |
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
der Aufrufer prüft `ASSERT(count > 5)` und macht `delete[]` (`workbook.cpp:987`, `757`).

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
libjpeg. Es steht mitten im Rumpf von `class SECJpeg`, die bei `SECJPEG.H:207`
beginnt: die libjpeg-Deklarationen laufen dort von Zeile 228 (`forward_DCT`) bis 823
(`jinit_memory_mgr`), erst ab `:827` folgt wieder Stingray-Eigenes. Die Datei hat
885 Zeilen.

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
  `LoadState`, `SECMDIFrameWnd::LoadBarState`, `SECControl` — letzteres kommt in den
  Eudora-Quellen genau einmal vor, in einem Kommentar (`mainfrm.cpp:2464`).
- **`SEC_TEXT` gehört nicht dazu** — das ist ein SSPI-Makro aus `Sspi.h`
  (dort dreimal definiert, `:80`, `:98`, `:126`), kein Stingray.
- **`SECCustonToolBar` existiert nicht** — Tippfehler in einem Kommentar
  (`QCCustomizeToolBar.cpp:241`).
- **Abschnitt 3 ist auch nach oben unvollständig.** Er listet 52 Bezeichner, aber
  `SEC_AUX_DATA` fehlt darin, obwohl es an fünf Stellen in echtem Code steht
  (`EmoticonToolbarButton.cpp:91`, `MoodMailStatic.cpp:63` und `:140`,
  `QCCustomizeToolBar.cpp:17`, `TBarSendButton.cpp:74`, jeweils
  `extern SEC_AUX_DATA secData;`). Die 52 ist deshalb weder eine Ober- noch eine
  Untergrenze und sollte nicht als Kennzahl zitiert werden.
- **Fehlende Ableitungen in Abschnitt 1:** der Generator hat nur `class X : public SECY`
  mit `SEC` als *erster* Basis erfasst. Es fehlten sieben Einträge — inzwischen in
  `INVENTAR.md` nachgetragen: `QCWorkbookClient : SECWorkbookClient`
  (`mainfrm.cpp:333`), `QC3DTabControl : SEC3DTabControl` (`QC3DTabWnd.h:14`),
  `QC3DTabWnd : SEC3DTabWnd` (`QC3DTabWnd.h:74`), `CDontFloatDockContext : SECDockContext`
  (`QCChildToolBar.cpp:43`) sowie die drei Mehrfachvererbungen auf `SECWndBtn`:
  `CTBarBitmapComboBtn` (`TBarBmpCombo.h:14`), `CTBarEditBtn` (`TBarEdit.h:12`),
  `CTBarStaticBtn` (`TBarStatic.h:12`). Damit sind es **30** Ableitungen von
  **22** verschiedenen Stingray-Basisklassen, nicht 23.
- **Fehlende Einträge:** `SECControlBar::GetBarInfo`/`SetBarInfo` (`WazooBarMgr.cpp:433,435`),
  `SECDockBar::GetControlBarRow`/`GetFirstControlBar`/`RemoveControlBar`,
  `SECControlBar::GetInsideRect`/`CalcInsideRect`/`IsMDIChild`, dazu die gesamte
  Zusatzoberfläche von `SECCustomToolBar` (rund 20 Member) und `SECStdBtn`.

## Was unabhängig vom Shim blockiert

Drei Dinge kosten Arbeit, haben aber mit OT501 nichts zu tun:

1. **`statbar.h:71`** deklariert `afx_msg void OnTimer(UINT)`; `ON_WM_TIMER()` verlangt in
   MFC 14 `UINT_PTR` — Compilerfehler unabhängig von der Shim-Wahl.
2. **Direkter Zugriff auf die libpng-Strukturen** in `QCGraphics.cpp` — libpng-1.2-API,
   seit 1.4 gekapselt. Vier Stellen, davon liegt nur eine in `QCPng::LoadImage`:
   - `306` — `png_ptr->error_ptr` im Warn-Callback `libpng_warning`
   - `313` — `png_ptr->error_ptr` im Fehler-Callback `libpng_error`
   - `316` — `longjmp(png_ptr->jmpbuf, 1)`, ebenfalls in `libpng_error`
   - `354` — `setjmp(png_ptr->jmpbuf)` in `QCPng::LoadImage(LPCTSTR)`
3. **`QCChildToolBar.cpp:62`** bindet `ON_MESSAGE_VOID(WM_IDLEUPDATECMDUI, OnIdleUpdateCmdUI)`
   an einen Handler mit Signatur `LRESULT(WPARAM,LPARAM)` (`QCChildToolBar.h:24`) —
   Typmismatch, vermutlich aus einem früheren Portierungsschritt.

Dazu die vier Quelldateien, deren Header vorliegen, deren Implementierung aber in der
CHM-Freigabe fehlt: `TBarBmpCombo.cpp`, `TBarEdit.cpp`, `TBarStatic.cpp`, `spell.cpp`.
Die ersten drei sind Toolbar-Steuerelemente und gehören fachlich zu Stufe 3.

## Verfügbares Material

Unter `OT501/Src/` liegen **67** Quelldateien (alle `.cpp`, keine `.c`) — von den
186, die `otlib50.mak` erwartet. Aufgeteilt:

| Ort | Anzahl | Was |
|---|---|---|
| `image/JPEG` | 46 | libjpeg (Fremdcode) |
| `utility/zlib` | 14 | zlib (Fremdcode) |
| `ui/shortcut` | 4 | Shortcut-Dialoge |
| `controls/treectrl` | 1 | `TreeNode.cpp` |
| `OT501/Src` selbst | 2 | `secaux.cpp` und `STDAFX.CPP` |

`secaux.cpp` ist die einzige davon, die echte Stingray-Substanz enthält — sie
liefert `secData` (`SEC_AUX_DATA`) mit den Systemfarben, die der Zeichencode an mehreren
Stellen direkt liest (`TBarSendButton.cpp:74`, `MoodMailStatic.cpp:63`,
`QCCustomizeToolBar.cpp:17`). `STDAFX.CPP` ist der übliche Vorkompilierungs-Rumpf,
alles Übrige Fremdcode.

Jede Aussage über die *Innereien* der SEC-Implementierungen bleibt damit Rekonstruktion
aus den Erwartungen der Aufrufer.

---

# Berichtigungen nach der Umsetzung von Stufe 2 (29.08.2026)

Beim Umsetzen und Nachmessen haben sich drei Aussagen dieses Plans als falsch
erwiesen. Sie stehen oben unveraendert, damit nachvollziehbar bleibt, was
angenommen wurde — hier steht der gemessene Befund.

## 1. Die Registerkarten sind NICHT verzichtbar

Oben steht, die Registerkartenleiste sei eine Anwendereinstellung hinter
`m_bWorkbookMode` und koenne entfallen. **Das gilt nur fuer den MDI-Streifen.**

`SEC3DTabWnd` und `SEC3DTabControl` sind etwas anderes: das Registerkarten-
Steuerelement **innerhalb jeder Wazoo-Leiste**.

- `CWazooBar::m_wndTab` ist ein `QC3DTabWnd` — `Eudora/WazooBar.h:137`
- `QC3DTabWnd : SEC3DTabWnd`, `QC3DTabControl : SEC3DTabControl` —
  `Eudora/QC3DTabWnd.h:14` und `:74`
- `m_bWorkbookMode` schaltet davon nichts ab

Eudora ruft echte Funktionalitaet auf: `GetTabCount` 19x, `GetActiveTab` 7x,
`GetTabInfo` 6x, dazu `AddTab`, `InsertTab`, `RemoveTab`, `FindTab`,
`ActivateTab`, `SetTabIcon`, `ScrollToTab`, `TabExists`, `TabHit`,
`SetTabLocation`, `ShowTabs`.

Mit leeren Ruempfen linkt und startet Eudora — aber **jede Wazoo-Leiste bleibt
leer**: Mailboxes, Nicknames, Filters, Directory Services, Link History, Task
Status. Das Programm waere unbenutzbar.

Umfang: rund 80 Symbole, eigene Stufe zwischen 2 und 3. Fuer die Zeichenarbeit
gibt es **keine** Vorlage im Repo (anders als bei `SECStdBtn::DrawFace`).

## 2. Drei Klassenfamilien fehlen im Plan ganz

- **`CSafetyPalette` / `CPaletteDC`** aus `safetypal.h`, 14 Symbole. `CPaletteDC`
  ist der Geraetekontext, durch den Eudora jede Bitmap zeichnet — Aufrufstellen in
  `QCToolBarManager.cpp` (9x), `QCGraphics.cpp` (5x), `tocview.cpp`, `AdView.cpp`,
  `LinkHistoryManager.cpp`, `mainfrm.cpp` (4x). Aufwand gering.
- **`SECDateTimeCtrl`** aus `dtctrl.h`, 6 Symbole. `SearchView.h:388` haelt ein
  Feld davon. MFCs `CDateTimeCtrl` deckt es ab.
- **`SECFrameWnd`, `SECDockState`, `SECControlBarInfo(Ex)`, `SECControlBarManager`,
  `SECDockContext`** — gehoeren zur Andockfamilie, in Stufe 2b nachgezogen. Ihre
  Originalheader uebersetzen unter MFC 14 fehlerfrei; es fehlte nur die Umsetzung.

## 3. `secData` liegt bereits im Repo

`SEC_AUX_DATA` und die drei anderen freien Funktionen brauchen keinen Nachbau:
`OT501/Src/secaux.cpp` ist Teil der Freigabe und muss nur in die Projektdatei
aufgenommen werden.

## Stand der Symbolliste

> **Veraltet — Stand 29.08.2026.** Die Tabelle beschreibt den Zustand, als erst
> Stufe 0-2 und 4 eingehaengt waren. Der fortgeschriebene Stand mit Bezugscommits
> steht unten im Abschnitt
> [Der Weg zum Linken](#der-weg-zum-linken-agent-linker-30082026); an `2d68555`
> ist von den Stingray-Symbolen keines mehr offen.

Gemessen mit einer leeren Platzhalter-`OTA50D.LIB`: 1088 ungeloeste Externe,
651 verschiedene. Nach dem Einhaengen von Stufe 0-2 und 4 bleiben rund 299:

| Familie | Symbole | Stand |
|---|---|---|
| Werkzeugleisten und Knoepfe | 158 | Stufe 3 |
| Registerkarten | 80 | eigene Stufe |
| Bilder | 27 | Stufe 4 fertig, Rest beim Einhaengen |
| Palette | 14 | eigene Kleinstufe |
| `SECDateTimeCtrl` | 6 | eigene Kleinstufe |
| freie Funktionen | 4 | `secaux.cpp` ins Projekt |
| nicht Stingray (`ATL::CImage`, `CVoiceText`, `TraceStart`) | 5 | eigenstaendig |

## Stolperstein beim Einhaengen

`OTShim.h` setzt `__SWINMDI_H__`, `__SECWB_H__`, `__SBARCORE_H__`, `__SBARDOCK_H__`
selbst. Nicht gesetzt sind `__SECTOD_H__` und `__SBARSTAT_H__` — die stehen in
`OTShimAll.h`. Der Wächter `__SECBTNS_H__` laesst sich **nicht** setzen, ohne
`SECStdBtn` und die uebrigen Knopfklassen mit wegzunehmen.

> **Berichtigung (30.08.2026).** Der letzte Halbsatz lautete hier: „das loest erst
> der Ersatz fuer `secbtns.h` aus Stufe 3 auf". **Das ist nachgemessen falsch.**
> Auch mit vollstaendig eingehaengter Stufe 3 laesst sich der Waechter nicht
> setzen, denn `secbtns.h` liefert ausserdem `SECBitmapButton`, das Stufe 3 nicht
> ersetzt. Gemessen an `22a6d77`, `Eudora.vcxproj` einzeln:
>
> | Waechter `__SECBTNS_H__` | Fehler |
> |---|---|
> | auskommentiert (wie im Repo) | **1** (`secbtns.h(340,83): C2572`) |
> | eingekommentiert | **102** (`C3646`, `C4430`, `C2065`, `C2653`, `C3861`) |
>
> Der `C2572` ist stattdessen so geloest, dass die inline-Fassung in
> `OTShim.h:307` **kein Standardargument** mehr fuehrt; `secbtns.h:340` traegt es
> nach (`78a9c10`). Der Waechter bleibt in `OTShimAll.h` auskommentiert stehen,
> samt Begruendung. Die allgemeine Lehre steht in
> `Arbeitsweise/`: Include-Waechter sind alles-oder-nichts — wer einen setzt,
> nimmt **jede** Deklaration der Datei weg, nicht nur die stoerende.

---

# Der Weg zum Linken (Agent LINKER, 30.08.2026)

Laufendes Protokoll. Jede Zahl hier ist gemessen, mit Bezugscommit.

## Gemessene Symbolzahlen

| Zustand | Bezug | ungeloeste Externe |
|---|---|---|
| ohne Ersatzschicht | frueher, nicht reproduzierbar | 1088 (651 verschiedene) |
| nach Stufe 0-2 und 4 | frueher, nicht reproduzierbar | rund 299 |
| **alle fuenf Teile eingehaengt, Uebersetzung fehlerfrei** | **78a9c10** | **8** |
| fuenf Nicht-Stingray-Symbole geloest | `4ba2dd3` | 3 |
| `SECBitmapButton` umgesetzt | `e61f243` | 1 |
| **nachgemessen von LEKTOR** | **`2d68555`** | **1** — `__imp___iob`, angefordert von der vorgefertigten `libpng.lib` (`pngerror.obj`, `pngrutil.obj`). **Kein Stingray**: von der Ersatzschicht her ist `Eudora.exe` gebunden |

Gemessen mit

    MSBuild Eudora71\Eudora\Eudora.vcxproj -p:Configuration=Debug -p:Platform=x86
            -p:BuildProjectReferences=false -p:IntDir=.\Build\DebugLINKER\ -v:m -nologo

und der leeren Attrappe `Eudora71/Lib/Debug/OTA50D.LIB`.

**Wichtig fuer jede weitere Messung:** `IntDir` muss ueberschrieben werden, solange
mehrere Agenten gleichzeitig bauen — sonst schreiben zwei `cl.exe` in dieselbe
`Build\Debug\vc143.pdb` und der Bau bricht mit 148x `C1041` ab (gemessen).
`OutDir` dagegen **nicht** ueberschreiben: die Projektverweise loesen ihre
Importbibliotheken ueber `$(OutDir)` auf, und der Link endet dann mit
`LNK1104: AccountWizard.lib` (gemessen).

## Was auf dem Weg dorthin zu beheben war

Drei Uebersetzungsfehler, alle in `78a9c10`:

1. **`C2572` in `secbtns.h:340`** — Neudefinition des Standardarguments von
   `SECLoadSysColorBitmap`. Der Waechter `__SECBTNS_H__` ist **nicht** die
   Loesung (102 Fehler statt einem, weil `secbtns.h` ausserdem
   `SECBitmapButton` liefert). Stattdessen fuehrt die inline-Fassung in
   `OTShim.h:307` kein Standardargument mehr; `secbtns.h:340` traegt es nach.
2. **`WINVER=0x0410`** aus `Eudora.vcxproj:67` brach MFC 14.38
   (`afxv_w32.h:36`, `C1189`) fuer alle Dateien ohne `stdafx.h` — also fuer vier
   der fuenf Shim-Dateien. Statt den Umgehungsblock aus `OTShim_Palette.cpp`
   viermal zu kopieren, steht die Projektdefinition jetzt auf `0x0501`, genau
   dem Wert, den `stdafx.h:20-29` ohnehin fuer jede andere Datei erzwingt.
3. **Fuenf `C3861` zu `MIN`/`MAX`** in `sendmail.cpp` und `summary.cpp`. Ursache
   gemessen: `secall.h` zog ueber `secjpeg.h` die libjpeg-Kopfdatei `Jpegint.h`
   nach, und die definiert `MIN`/`MAX` (`Jpegint.h:326,329`). `OTShim_Bild.h`
   setzt `__SECJPEG_H__`, damit war die zufaellige Quelle weg. Die Makros stehen
   jetzt wortgleich in `OTShimAll.h`. Betroffene Stellen: `sendmail.cpp:1676`,
   `:1733`, `:1734`, `:1736`, `mime.cpp:1779`, `summary.cpp:2828`.

An den Shim-Dateien anderer Agenten war **nichts inhaltlich zu korrigieren** —
nur die eine Deklaration in `OTShim.h:307` und Kommentare in `OTShimAll.h`.

## Die 8 verbliebenen Symbole (Stand 78a9c10)

| Symbol | Herkunft | Betroffene Objektdateien |
|---|---|---|
| `SECBitmapButton::SECBitmapButton()` | Stingray, `secbtns.h:189` | nickpage, PaymentAndRegistrationDlg |
| `SECBitmapButton::~SECBitmapButton()` | Stingray, `secbtns.h:233` | mainfrm, nickpage, nicksht, PaymentAndRegistrationDlg |
| `ATL::CImage::s_initGDIPlus` | **nicht Stingray** | QCGraphics |
| `ATL::CImage::s_cache` | **nicht Stingray** | QCGraphics |
| `CVoiceText::Init(...)` | **nicht Stingray** (SpeechSDK) | TextToSpeech |
| `CVoiceText::Speak(...)` | **nicht Stingray** (SpeechSDK) | TextToSpeech |
| `__imp___iob` | **nicht Stingray** (libpng.lib, alte CRT) | libpng.lib(pngerror,pngrutil) |
| `TraceStart()` | `OT501/Include/TraceFile.h:9` | EudoraExe |

Von den 158+80+27+14+6 Symbolen der Stingray-Familien ist damit **eines** offen:
`SECBitmapButton`. Alles andere traegt die Ersatzschicht.

## Ergebnis: Eudora.exe bindet

Gemessen am 30.08.2026, Debug/x86:

    Eudora.vcxproj -> Eudora71\Bin\Debug\Eudora.exe     10 196 992 Byte

**0 Uebersetzungsfehler, 0 ungeloeste Symbole, und ohne die Attrappe
`OTA50D.LIB`.** Der Weg dorthin in Zahlen:

| Schritt | Bezugscommit | ungeloeste Externe |
|---|---|---|
| alle fuenf Teile eingehaengt, Uebersetzung fehlerfrei | 78a9c10 | 8 |
| `TraceStart`, `ATL::CImage`, `CVoiceText` geloest | 4ba2dd3 | 3 |
| `SECBitmapButton` geloest | e61f243 | 1 |
| `__imp___iob` geloest | dieser Commit | **0** |

### Die drei Symbole, die nicht aus Stingray stammen

| Symbol | Ursache, gemessen | Behandlung |
|---|---|---|
| `TraceStart` | `OT501/Include/TraceFile.h:9` deklariert vier freie Funktionen, deren Umsetzung in der Freigabe komplett fehlt - sie lag in `OTA50D.LIB`. Aufgerufen wird nur `TraceStart` (`EudoraExe.cpp:44`) | `OTShim_Spur.cpp`. Ausgabe an `OutputDebugString`. Die drei nie aufgerufenen stehen als Rumpf daneben |
| `ATL::CImage::s_cache`, `::s_initGDIPlus` | `Eudora/atlimage.h` ist die Kopie einer aelteren ATL. Sie deklariert beide statischen Felder (`:242`, `:272`), definiert sie aber nirgends; die alte ATL tat das am Dateiende mit `__declspec(selectany)` | `OTShim_Fremdsymbole.cpp`, Definition in genau einer Uebersetzungseinheit. Muss weg, wenn Eudora auf den SDK-eigenen `atlimage.h` wechselt |
| `CVoiceText::Init`, `::Speak` | `dumpbin /SYMBOLS` auf `SpeechSDK/Lib/spchwrap.lib`: beide Funktionen sind da, aber mit `PBG` statt `PB_W` im dekorierten Namen. Die Bibliothek wurde uebersetzt, als `wchar_t` noch ein `typedef` auf `unsigned short` war. ABI und Bitbreite gleich, nur der Name unterscheidet sich | zwei `/alternatename`-Anweisungen in `OTShim_Fremdsymbole.cpp`. Nicht `/Zc:wchar_t-`: das brach die Bindung an MFC 14.38 |

Dazu ein viertes, das erst beim Linken sichtbar wurde:

| `__imp___iob` | `Lib/Debug/libpng.lib` ist eine vorgebaute libpng 1.2.7 aus der Zeit vor der UCRT; `stderr` war damals `(&_iob[2])` auf ein Feld, das die CRT-DLL exportierte. `dumpbin /disasm` auf `pngerror.obj` und `pngrutil.obj`: **jeder** Zugriff lautet `mov ecx,[__imp___iob]` / `add ecx,40h` - also ausschliesslich `_iob[2]`, Elementabstand 32 Byte | `OTShim_Libpng.cpp` definiert `_imp___iob` (dekoriert `__imp___iob`) mit dem Wert `(char*)stderr - 2*32`. Eigene Datei, weil `pruefe-bytes.pl` das Anhaengen von Zeilen an eine bestehende CRLF-Datei nicht von einem umgeschriebenen Zeilenende unterscheiden kann und den Commit abweist - der Inhalt gehoert fachlich als Block 3 in `OTShim_Fremdsymbole.cpp`. Damit trifft `_iob[2]` den echten `stderr` der UCRT. Sauber behoben waere es erst mit einem Neubau von libpng aus `Eudora71/PNG/libpng` |

### `SECBitmapButton` - der letzte Stingray-Rest

`OTShim_Knopf.cpp` liefert `SECOwnerDrawButton` und `SECBitmapButton`.
**Sonderfall:** hier wird der Stingray-Header nicht ersetzt. `secbtns.h` bleibt
im Original eingebunden, die Datei liefert nur die Ruempfe - den Waechter
`__SECBTNS_H__` zu setzen ergibt gemessen 102 Uebersetzungsfehler.

Ungeloest waren nur zwei Symbole (Konstruktor und Destruktor), mit ihnen kommt
aber die virtuelle Tabelle beider Klassen, und die verlangt jede virtuelle
Methode. `SECWellButton`, `SECMenuButton`, `SECPopupColorWell` und `DDX_Color`
bleiben aus - gemessen ueber alle `.cpp` und `.h` unter `Eudora71/Eudora`: kein
Aufruf.

### Die Attrappe `OTA50D.LIB` wird nicht mehr gebraucht

`WEITERMACHEN.md` beschreibt sie als notwendige Falle. Das gilt nicht mehr.
Zwei Aenderungen in `Eudora.vcxproj` loesen die Bindung an sie:

- `_SECNOMSG` in den Praeprozessordefinitionen. `SECVER.H:210-211` haengt das
  `#pragma comment(lib, _SECAUTOLIBNAME)` daran; ohne die Definition traegt
  jede Objektdatei die Anforderung `ota50d.lib` in sich.
- `<LinkLibraryDependencies>false</LinkLibraryDependencies>` beim
  Projektverweis auf `OT501` (Zeile 1015). `ReferenceOutputAssembly` allein
  genuegt **nicht**: MSBuild reicht die Ausgabe des verwiesenen Projekts
  trotzdem als Bindeeingabe weiter. Gemessen: mit `ReferenceOutputAssembly`
  allein steht `Lib\Debug\OTA50D.LIB` in der Eingabeliste des Linkers, und
  `/NODEFAULTLIB:OTA50D.LIB` hilft dagegen nicht.

`OTA50D.LIB` ist damit weder noetig noch vorhanden.

### Was beim ersten Startversuch zu erwarten ist

`dumpbin /dependents` auf `Bin/Debug/Eudora.exe` nennt 27 Abhaengigkeiten.
Geprueft gegen `Bin/Debug`: **alle vorhanden** - `Paige32d.dll`, `Imap.dll`,
`QCSocket.dll`, `QCUtils.dll`, `EuMemMgr.dll`, `EuLang.dll`, `LIBEXPAT.dll`,
`plstclnt.dll` sowie die Systemteile bis hin zu `mfc140d.dll`, `gdiplus.dll`,
`ucrtbased.dll`.

**`EudoraRes.dll` steht nicht in dieser Liste** - sie wird zur Laufzeit
nachgeladen, nicht gebunden, und fehlt in `Bin/Debug`. Sie traegt Dialoge,
Zeichenketten und Symbole. Der Startversuch scheitert daran voraussichtlich vor
allem anderen; Einzelheiten in `STARTUMGEBUNG.md`.

Weiter ist zu erwarten, dass die Ersatzschicht beim Start durch Code laeuft, den
bisher nur der Uebersetzer gesehen hat. Die Stellen, an denen sie bewusst nichts
tut, melden sich ueber `OTShimNichtUmgesetzt` mit einem Hinweisfenster.
