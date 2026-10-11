# E-33 — *File → Exit* beendet Eudora nicht

Untersucht am 07.09.2026 auf `wt/pruefer`, Ausgangsstand `009263b`. **Nur
Quelltext gelesen und gemessen — Eudora wurde nicht gestartet, nichts gebaut,
nichts committet.**

> **Nachtrag 08.09.2026: der Fall ist entschieden.** **Kriterium 7** in
> [ZIEL.md](../ZIEL.md) ist **erfüllt** — Gregor an Paket 1.0.22: *„schließen
> klappt jetzt."* Alle drei Wege beenden: *File → Exit*, **Alt-F4** und das
> **Kreuz**.
>
> Behoben durch **E-40** (eine Rückfrage, die sich nicht öffnen lässt, galt als
> „Abbrechen"), **E-41** (Alt-F4 und das Kreuz laufen durch ein `ENSURE_VALID`
> in `CFrameWnd::OnSysCommand`, das *File → Exit* nicht hat — die Folgerung des
> **zweiten** Durchgangs, unten am Ende dieser Datei, hat getragen) und **E-42**
> (zwölf Aufräumschritte konnten das Beenden abbrechen). Dazu **E-45**: einer
> der zwölf Schritte, `QCWorkbook::OnClose`, darf **nicht** übersprungen werden
> — sonst bleibt ein Prozess ohne Fenster übrig. Gefunden hat das PRUEFER
> ([PRUEFER-5.md](PRUEFER-5.md)).
>
> **Der Wurf selbst ist nicht verschwunden:** `SaveBarState("ToolBar")` wirft
> weiter und steht als **E-43** offen — abgefangen, nicht behoben. Der daraus
> abgeleitete Verdacht **E-46** (freigegebenes `CMainFrame`-Objekt) ist am
> 08.09.2026 **widerlegt**.
>
> Alles, was unten steht, bleibt als **vermessener Weg** richtig und ist
> ausdrücklich nicht überschrieben.

> **Zwei Durchgänge, ein Befund.** Der erste hat den Weg vermessen und eine
> Messung vorgeschlagen; Gregor hat sie am 07.09.2026 gefahren (siehe unten),
> und ihr Ergebnis hat die Rangliste umgeworfen. Was der zweite Durchgang
> berichtigt, ist im Text ausdrücklich als **BERICHTIGT** oder **widerlegt**
> gekennzeichnet — die alten Behauptungen bleiben sichtbar stehen, damit
> niemand denselben Umweg zweimal geht.
>
> **Zu den Zeilennummern:** die Nummern in „Der Weg des Beendens" stammen vom
> Stand **nach dem ersten** Spurmarken-Einbau. Der zweite Durchgang hat in
> `mainfrm.cpp` weitere Marken eingesetzt, wodurch sich alles ab
> `CMainFrame::OnClose` um einige Zeilen nach unten verschoben hat. Die
> Nummern in den Abschnitten ab „Was in diesem Durchgang … gemessen wurde"
> sind aktuell.

## Symptom

Gregor am 07.09.2026 zu Paket 1.0.21:

> *„beenden geht nicht."*

Und vorher zu Paket 1.0.18:

> *„es crasht nicht, aber es passiert auch nichts. **beenden kann ich es auch
> nicht.** nichts statt crash ist auch keine verbesserung!"*

Das ist **Kriterium 7** in [ZIEL.md](../ZIEL.md) und der einzige verbliebene
Fehler der zweiten Stufe.

## Die Messung ist gefahren — und sie entscheidet die Frage

**Gregor am 07.09.2026, mit Bildschirmfoto:**

> *„exit: weder alt+F4, noch x rechts oben funktionieren. da kommt wieder die
> meldung:"*

Das Bildschirmfoto zeigt einen Meldungsdialog, Titel **„Eudora"**, rotes Kreuz,
Text:

> **Encountered an improper argument.**

Daraus folgt dreierlei, und alles drei ist damit **gemessen**, nicht vermutet:

1. **Es ist Fall (b): das Beenden beginnt.** Kreuz und Alt-F4 gehen über
   `WM_SYSCOMMAND`/`SC_CLOSE` → `CMainFrame::OnSysCommand` →
   `CFrameWnd::OnSysCommand` → `WM_CLOSE` in dasselbe `CMainFrame::OnClose`.
   Dass sie **dasselbe** Symptom zeigen wie *File → Exit*, schließt den
   Menüweg aus — und damit `CFileBrowseView::OnAppExit`
   (`FileBrowseView.cpp:2218`) als Ursache. **Dieser Kandidat ist gestrichen**
   (er war Platz 4 und die einzige Möglichkeit, Fall (a) zu erzeugen).
2. **Der Abbruch ist eine geworfene Ausnahme, keine stille FALSE-Rückgabe.**
   „Encountered an improper argument" ist MFCs Text für
   **`CInvalidArgException`** (`AFX_IDS_INVALID_ARG_EXCEPTION, 0xF025`). Damit ist
   `CMainFrame::SaveOpenWindows` als *lautloser* Ausgang **nicht mehr die
   führende Erklärung**; gesucht ist eine **Wurfstelle** auf demselben Weg.
3. **Der Weg nach dem Wurf ist bestätigt** (bisher Platz 3, jetzt kein
   Verdachtspunkt mehr, sondern der Mechanismus): `AfxCallWndProc` fängt
   (MFC 14, `wincore.cpp:270-277`), `CWinApp::ProcessWndProcException`
   (`appcore.cpp:1009-1039`) zeigt genau diese Meldung und liefert **0**,
   `WM_CLOSE` gilt als beantwortet, das Fenster bleibt stehen. Eudora
   überschreibt `ProcessWndProcException` nirgends.

### Und noch eine Einschränkung, die viel wegnimmt

Gregor kann **nach** der Meldung weiter Alt-F4 drücken — das Hauptfenster steht
also noch. `CFrameWnd::OnClose` versteckt es aber schon bei
**`pApp->HideApplication()`** (MFC 14, `winfrm.cpp:885`), lange bevor die
Dokumente geschlossen werden. **Der Wurf muss deshalb VOR `winfrm.cpp:885`
fallen.** Alles, was danach kommt — `CloseAllDocuments`,
`CDocument::OnCloseDocument` mit `pView->EnsureParentFrame()`
(`doccore.cpp:872`), `ENSURE_VALID(pView)` (`winfrm.cpp:923`),
`DestroyWindow` — kann es **nicht** gewesen sein: dann wäre das Fenster
verschwunden und nur der Prozess übrig geblieben.

## Was vorher schon widerlegt war

* Die Annahme, eine **modale** Meldung der Ersatzschicht verdecke das Beenden,
  ist gegenstandslos: die `AfxMessageBox`-Aufrufe in `Eudora71/OTShim/*.cpp`
  sind durch `OutputDebugString` ersetzt, und `tools/pruefe-fensterbau.pl` hält
  das als Schranke (Prüfung läuft grün, 0 modale Meldungen).
* **E-32** (`CHeaderView::OnKillFocusRecipient`) war nie die Ursache — dreimal
  gemessen, `Befunde/PRUEFER-3.md`.

## Der Weg des Beendens, vollständig

### 1. Der Befehl

| Schritt | Fundstelle |
|---|---|
| Menüpunkt *File → Exit* | `Eudora71/Eudora/EudoraRes.rc:5500` — `MENUITEM "E&xit\tCtrl+Q", ID_APP_EXIT` |
| Tastenkürzel Strg-Q | `Eudora71/Eudora/EudoraRes.rc:335` |
| Kennung `ID_APP_EXIT` = `0xE141` | `Eudora71/Help/afxres.h:227` |
| Behandler | `Eudora71/Eudora/eudora.cpp:622` — `ON_COMMAND(ID_APP_EXIT, OnAppExit)` in der Nachrichtentabelle von **`CEudoraApp`** |
| `CEudoraApp::OnAppExit` | `Eudora71/Eudora/eudora.cpp:806` — bei gedrückter Shift-Taste nur `SaveOpenWindows(FALSE)`, sonst `CWinApp::OnAppExit()` |
| `CWinApp::OnAppExit` | MFC 14, `atlmfc/src/mfc/appui.cpp:19` — `m_pMainWnd->SendMessage(WM_CLOSE)` |

Zwei **Nebeneingänge** auf denselben Weg:

* Werkzeugleisten-Knopf *File:Exit* → `CMainFrame::OnFakeAppExit`
  (`mainfrm.cpp:4012`) → `PostMessage(WM_COMMAND, ID_APP_EXIT)`.
* `CFileBrowseView::OnAppExit` (`FileBrowseView.cpp:2218`) fängt den Befehl ab,
  **solange die Dateibrowser-Ansicht die aktive Ansicht ist**, und schickt
  `PostMessage(WM_COMMAND, SC_CLOSE)`. Das ist im Original schon falsch:
  `SC_CLOSE` (`0xF060`) ist ein **`WM_SYSCOMMAND`**-Wert und wird als
  `WM_COMMAND` von niemandem behandelt. Wer den Dateibrowser im Vorschaufenster
  offen und angeklickt hat, bekommt auf *File → Exit* **gar nichts** — ohne
  Meldung. Siehe Rangliste, Platz 4.
* Das Kreuz im Fensterrahmen und Alt-F4 gehen über `WM_SYSCOMMAND`/`SC_CLOSE` →
  `CMainFrame::OnSysCommand` (`mainfrm.cpp:5338`, gibt alles außer
  `ID_SYSTEM_MENU_CHECKMAIL` an `CFrameWnd::OnSysCommand` weiter) → `WM_CLOSE`.
  **Damit landet das Kreuz genau auf demselben `CMainFrame::OnClose` wie
  *File → Exit*, überspringt aber die ganze Befehlszustellung.** Darauf baut die
  Messung unten auf.

### 2. `CMainFrame::OnClose` — `Eudora71/Eudora/mainfrm.cpp:5079`

| Zeile | Schritt |
|---|---|
| 5089 | **Spurmarke** „OnClose: WM_CLOSE angekommen" |
| 5092 | `m_lpfnCloseProc` — Sonderfall Druckvorschau, kehrt dann zurück |
| 5095 | **`if (!CloseDown()) return;`** — hier endet das Beenden **ohne jede Meldung**, wenn eine der sechs Vetostufen FALSE liefert |
| 5113 | `CImapMailMgr::CloseImapConnections()` (`#ifdef IMAP4`, ist gesetzt) |
| 5117 | `EmptyTrash()`, falls `IDS_INI_EMPTY_TRASH_ON_QUIT` |
| 5119–5127 | `SetIcon(FALSE)`, `KillTimer` |
| 5134 | `Network::CleanSSLLibrary()`, `delete NetConnection` |
| 5142 | `TrayItem(IDR_MAINFRAME, NIM_DELETE)` |
| 5146 | `CDynamicMenu::DeleteMenuObjects(GetMenu(), FALSE)` |
| 5158 | **`QCWorkbook::OnClose()`** — siehe 4. |
| 5164 | `TocCleanup()` — `tocdoc.cpp:4107`, schreibt geänderte `.toc` und ruft `OnCloseDocument()` |
| 5167 | `CHostList::Cleanup()` |
| 5170 | `delete gSearchDoc;` |
| 5173 | `AutomationStop()` |
| 5176–5180 | `QCSharewareManager::UnRegister` |
| 5185 | **Spurmarke** „OnClose: durchgelaufen" |

### 3. `CMainFrame::CloseDown` — `mainfrm.cpp:5189`

Die **Weiche**. Sechs Stellen liefern hier FALSE:

| Zeile | Stufe | Liefert FALSE wenn | Sichtbar? |
|---|---|---|---|
| 5200 | `QCGetTaskManager()->GetTaskCount()` | — (aber `QCGetTaskManager` prüft nur mit `ASSERT`, `QCTaskManager.cpp:82-86`) | — |
| 5205 | `WarnYesNoDialog(IDS_INI_TASK_WARN_CLOSE, …) == IDCANCEL` | Anwender bricht ab | **ja**, Dialog |
| 5211 | `g_ImapAccountMgr.FinishUpActionQueues()` | — (indexgesichert, `EuImap/src/ImapAccountMgr.cpp:1277-1307`) | — |
| 5230 | `MAPIUninstall(TRUE) > STATUS_NOT_INSTALLED` | MAPI-Abbau schlägt fehl | **nein** |
| 5246 | `CanCloseFiltersFrame()` → `filtersd.cpp:1978` → `g_Filters->CanCloseFrame(NULL)` | laut Kommentar nie | eher nein |
| 5256 | `g_Nicknames->CanCloseFrame(NULL)` → `nickdoc.cpp:2610` | laut Kommentar nie | eher nein |
| 5266 | `QuerySendQueuedMessages()` → `mainfrm.cpp:5027` | Warteschlange nicht leer **und** `IDS_INI_WARN_QUIT_WITH_QUEUED` gesetzt | **ja**, `AlertDialog` — **aber auch bei „Senden": dann FALSE und Beenden erst später, siehe unten** |
| 5276 | **`SaveOpenWindows(TRUE)`** → `mainfrm.cpp:2429` | ein offenes Fenster verweigert das Schließen | **nein — völlig lautlos** |
| 5284 | `TrimJunk()` | — | — |
| 5292–5320 | Werbeleiste ab-, `RemoveBogusAdToolBars()` (5965), `SaveBarState("ToolBar")` (5318) → `QCToolBarManager::SaveState` (`QCToolBarManager.cpp:1203`) → `QCCustomToolBar::SaveCustomInfo` (`QCCustomToolBar.cpp:377`), `m_WazooBarMgr.SaveWazooBarConfigToIni()` (5320) | — | — |
| 5325 | `g_QCExceptionHandler.SaveCrashStateToINI()` | — | — |
| 5328 | `WriteToolBarMarkerToIni()` — leert die `Eudora.ini` auf Platte | — | — |
| 5334 | `return TRUE` | | |

### 4. `QCWorkbook::OnClose()` löst sich auf `CFrameWnd::OnClose` auf

`QCWorkbook` (`Eudora/workbook.h:174`) hat keinen `OnClose`, und **`SECWorkbook`
in der Ersatzschicht hat auch keinen** (`Eudora71/OTShim/OTShim.h:1431-1610` —
dort sind nur `OnEraseBkgnd`, `OnPaint`, `OnLButtonDown/Up`, `OnDestroy`
deklariert). Der Aufruf in `mainfrm.cpp:5158` landet also unmittelbar bei
**MFC 14, `atlmfc/src/mfc/winfrm.cpp:843`**:

| MFC-Zeile | Schritt |
|---|---|
| 854 | `CDocument* pDocument = GetActiveDocument();` — **BERICHTIGT am 07.09.2026: das ist beim MDI-Hauptfenster NULL.** `CMDIFrameWnd` überschreibt nur `GetActiveFrame` (`winmdi.cpp:248`); `GetActiveDocument` liest `m_pViewActive`, und das Hauptfenster hat keine Ansicht |
| 855 | `pDocument->CanCloseFrame(this)` — **wird deshalb übersprungen**. Die frühere Behauptung, hier bekomme `CTocDoc::CanCloseFrame` den Hauptrahmen, ist widerlegt |
| 874 | `pApp->SaveAllModified()` — **läuft**, weil `pDocument == NULL` ist; Eudora überschreibt `SaveAllModified` **nicht** |
| 885 | `pApp->HideApplication()` — **versteckt das Hauptfenster, bevor die Dokumente geschlossen werden** |
| 888 | `pApp->CloseAllDocuments(FALSE)` → je Dokument `OnCloseDocument()` → `doccore.cpp:872` `pView->EnsureParentFrame()` |
| 922 | `ENSURE_VALID(pView)` in der Schleife über die Ansichten des aktiven Dokuments |
| 935+ | `DestroyWindow()` |

### 5. Danach

`DestroyWindow()` → `WM_DESTROY` → `CMainFrame::OnDestroy`
(`mainfrm.cpp:3271`: `CPopupText::Destroy`, Fensterlage in die `Eudora.ini`,
`ShutdownMDITaskBarTooltips`, `m_WazooBarMgr.DestroyAllWazooBars`, MDI-Client
entklammern, dann `QCWorkbook::OnDestroy` → `SECWorkbook::OnDestroy`,
`OTShim/OTShim.cpp:1241`) → `WM_NCDESTROY`; `CWnd::OnNcDestroy` setzt für das
Hauptfenster `WM_QUIT` ab, `CWinThread::Run` kehrt zurück, und **erst dann**
läuft `CEudoraApp::ExitInstance` (`eudora.cpp:2020`) mit `.toc`-Aufräumen,
`SaveStdProfileSettings`, `ResetEudoraIni` (nur bei `0xCAFEB0EF`),
`QCLogFileMT::CleanupDebug`, `PgSharedAccess::SillyShutdown`,
`QCSpoolMgrMT::Shutdown`, `QCTaskManager::Destroy`, `_Module.Term`.

**`CEudoraApp::ExitInstance` ist also nur erreichbar, wenn
`CFrameWnd::OnClose` bis `DestroyWindow()` durchkommt.** Kehrt
`CMainFrame::OnClose` bei Zeile 5095 zurück, wird `ExitInstance` nie erreicht —
und Eudora läuft mit vollständig intaktem Fenster weiter.

### `OnQueryEndSession` gehört nicht dazu

`CMainFrame::OnQueryEndSession` (`mainfrm.cpp:5071`) ruft ebenfalls
`CloseDown()`, wird aber nur beim **Herunterfahren von Windows** aufgerufen,
nicht bei *File → Exit*.

## Was in diesem Durchgang aus den MFC-14-Quellen gemessen wurde

Alles Folgende ist an
`C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\atlmfc`
gelesen, nicht erinnert.

### Die Wurfmakros — was genau wirft

| Makro | Fundstelle | wirft im Release-Bau? |
|---|---|---|
| `ENSURE_THROW(cond, ex)` | `include/afx.h:379-380` | ja — `ASSERT` **und** danach `if (!cond) { ex; }` |
| `ENSURE(cond)` / `ENSURE_ARG(cond)` | `afx.h:381-382` | ja, `AfxThrowInvalidArgException()` |
| `ENSURE_VALID(pOb)` | `afx.h:385-387` | ja, wenn `pOb == NULL` |
| `ASSERT_KINDOF(class, obj)` | `afx.h:603-604` | **nein** — reines `ASSERT`, im Release-Bau nichts |
| `ASSERT_VALID(pOb)` | `afx.h:376` | **nein** — `DEBUG_ONLY` |

### Die MFC-Sammlungen — `m_btns[i]` wirft wirklich

`SECBtnArray` leitet von `CPtrArray` ab (`OTShim_Werkzeugleiste.h:880-906`).
In MFC 14 stehen die Zugriffe in **`include/afxcoll.inl:201-217`**:

```cpp
_AFXCOLL_INLINE void* CPtrArray::GetAt(INT_PTR nIndex) const
	{ ASSERT(nIndex >= 0 && nIndex < m_nSize);
		if( nIndex < 0 || nIndex >= m_nSize )
			AfxThrowInvalidArgException();
		return m_pData[nIndex]; }
```

Dasselbe in `SetAt` (206) und `ElementAt` (212) — und `operator[]` ist nichts
als `GetAt` bzw. `ElementAt` (226-229). **Jeder Griff neben ein
`CPtrArray`/`CObArray`/`CStringArray`/`CDWordArray` wirft im Release-Bau
`CInvalidArgException`, also genau Gregors Meldung.** In MFC 6 stand dort nur
das `ASSERT`. Das ist die Fehlerklasse aus E-16/E-34, und `BEFUNDE.md:164`
nennt `afxcoll.inl:213` schon namentlich.

## Auftrag 2: der bisherige Spitzenkandidat ist **widerlegt**

`CTocDoc::CanCloseFrame` (`tocdoc.cpp:1286`, Zugriffe bei `:1295` und `:1312`)
kann diese Meldung **nicht** erzeugen, und er wird auf diesem Weg **gar nicht
gerufen**. Zwei unabhängige Messungen:

**(1) Keine der beiden Stellen wirft.**

```cpp
BOOL CWnd::GetWindowPlacement(WINDOWPLACEMENT* lpwndpl) const
{
	ASSERT(::IsWindow(m_hWnd));
	lpwndpl->length = sizeof(WINDOWPLACEMENT);
	return ::GetWindowPlacement(m_hWnd, lpwndpl);
}
```

`src/mfc/wincore.cpp:1214-1218` — **nur `ASSERT`, kein `ENSURE`**, und das
Argument wird ungeprüft beschrieben. Ein falscher `pFrame` gibt hier also
**Datenmüll oder eine Zugriffsverletzung**, keine `CInvalidArgException`.
`CTocFrame::GetLastSplitterPos()` (`TocFrame.h:58`) ist
`return m_nLastSplitterPos;` — ein Feldlesen, das ebenfalls nicht wirft. Der
Schutz `ASSERT_KINDOF(CTocFrame, pFrame)` (`tocdoc.cpp:1303`) ist im
Release-Bau ein Nichts, richtig — aber der Schaden daraus ist ein falscher
Zahlenwert, kein Wurf.

**(2) `CFrameWnd::OnClose` erreicht die Funktion überhaupt nicht.** Das ist die
Berichtigung meiner eigenen Aussage aus dem ersten Durchgang:

```cpp
CDocument* pDocument = GetActiveDocument();               // winfrm.cpp:854
if (pDocument != NULL && !pDocument->CanCloseFrame(this)) // winfrm.cpp:855
	return;
```

`CFrameWnd::GetActiveDocument()` (`winfrm.cpp:1370-1376`) liefert
`GetActiveView()->GetDocument()`, und `GetActiveView()` ist `m_pViewActive`
(`afxwin.h:4108`). **`CMDIFrameWnd` überschreibt nur `GetActiveFrame`**
(`winmdi.cpp:248`), *nicht* `GetActiveDocument`; das Hauptfenster einer
MDI-Anwendung hat selbst keine Ansicht, `m_pViewActive` ist NULL. Also ist
`pDocument == NULL`, `CanCloseFrame` wird übersprungen — und stattdessen läuft
die Zeile darunter:

```cpp
if (pDocument == NULL && !pApp->SaveAllModified())        // winfrm.cpp:874
	return;
```

`CEudoraApp` überschreibt `SaveAllModified` nicht (über ganz `Eudora71/`
geprüft), es gilt `CWinApp::SaveAllModified` → `CDocManager::SaveAllModified` →
je Vorlage `CDocTemplate::SaveAllModified` → je Dokument `pDoc->SaveModified()`.

## Rangliste der Wurfstellen vor `HideApplication`

### 1. `QCCustomToolBar::SaveCustomInfo` — `Eudora71/Eudora/QCCustomToolBar.cpp:421` (Schleife), Zugriffe `:423`, `:424`, `:427`, `:491`, `:508`

```cpp
for( iCurrentButton = 0; iCurrentButton < GetBtnCount(); iCurrentButton ++ )
{
	if( ( m_btns[ iCurrentButton ]->m_ulData != 0 ) && ...
```

**Warum das die Ursache sein dürfte, in drei Sätzen:**

1. Es ist **wortwörtlich die Form von E-34** — Grenze aus `GetBtnCount()`
   (`OTShim_Werkzeugleiste.h:744`, `m_btns.GetSize()`), Zugriff mit
   `m_btns[...]` über `CPtrArray::ElementAt` — und E-34 hat mit einer eigenen
   Protokollzeile **belegt**, dass dieses Paar in diesem Bau auseinanderläuft
   (*„Ausnahme bei Index 24 von 27 … Grund: Encountered an improper
   argument."*, `CHANGELOG.md` zu 7.2.0.20).
2. Die Stelle liegt auf dem **gemeinsamen** Stück des Weges — `CloseDown`
   Stufe 5, `SaveBarState(_T("ToolBar"))` → `CMainFrame::SaveBarState`
   (`mainfrm.cpp:2570,2584`) → `QCToolBarManager::SaveState`
   (`QCToolBarManager.cpp:1202-1219`) → `SaveCustomInfo` — und damit **vor**
   `pApp->HideApplication()`; sie wird von *File → Exit*, vom Kreuz und von
   Alt-F4 gleich erreicht.
3. Und sie läuft im normalen Betrieb **nur beim Beenden**: die beiden anderen
   Aufrufer sind `if (pMgr->ConvertOldStuff()) SaveBarState(...)`
   (`mainfrm.cpp:974`, greift nur bei einer alten INI) und der Anpassen-Dialog
   (`QCToolBarManager.cpp:1109`, nach `DoModal`). Das erklärt, warum die
   Meldung bei **jedem** Beendenversuch kommt und im laufenden Betrieb nicht.

Die zwölf Zugriffe in dieser Funktion sind **alle ungesichert** — anders als
die Zugriffe der Ersatzschicht selbst, die seit E-16 durchweg
`if (nIndex < 0 || nIndex >= GetBtnCount()) return ...;` davor haben
(`OTShim_Werkzeugleiste.cpp:2257,2277,2305,2311,2319,2327` — nachgesehen).

### 2. `CDockBar::RemoveControlBar` — MFC 14, `src/mfc/bardock.cpp:302-308`

```cpp
int nPos = FindBar(pBar, nPosExclude);
ENSURE(nPos > 0);
```

`FindBar` (`bardock.cpp:653-660`) liefert **-1**, wenn die Leiste nicht in
`m_arrBars` steht; `ENSURE(nPos > 0)` wirft dann `CInvalidArgException`. In
MFC 6 stand dort `ASSERT` — genau das beschreibt der Original-Kommentar in
`mainfrm.cpp:6165-6172`: *„A bad index value caused MFC to have fits when a
release build was running with a bad toolbar like this."*

Erreichbar beim Beenden über `CMainFrame::RemoveBogusAdToolBars`
(`mainfrm.cpp:5965-6014`) → `RemoveAdToolBarFromItsDockBar`
(`mainfrm.cpp:6158-6184`) und über die Werbeleiste selbst.

**Was dagegen spricht:** die Schranke aus **BEFUND E-4** sitzt in
`SECDockBar::RemoveControlBar` (`OTShim.cpp:2541-2566`) und prüft vorher
`if (FindBar(pBar, nPosExclude) <= 0) return FALSE;`. Sie wird erreicht, weil
alle Andockleisten dieses Baus `SECDockBar` sind: `CMainFrame::EnableDocking`
legt `QCDockBar` an (`mainfrm.cpp:2165-2181`, `QCDockBar : SECDockBar`,
`DockBar.h:16`), und schwebende Leisten sitzen in
`SECMiniDockFrameWnd::m_wndSECDockBar` (`OTShim.cpp:3398`). **Und**
`RemoveBogusAdToolBars` läuft auch beim **Start** (`mainfrm.cpp:971`) — käme
der Wurf von dort, hätte Gregor die Meldung schon beim Start. Bleibt als Loch
der `else`-Zweig in `mainfrm.cpp:6263-6266`, der MFCs ungesicherte Fassung ruft.

Nebenbefund derselben Funktion, unabhängig davon: die Schleife
`for (int i = 0; bDeleteIt && (i < GetBtnCount()); i++)` (`mainfrm.cpp:5983`)
lässt `bDeleteIt` auf `true` stehen, wenn die Leiste **gar keine** Knöpfe hat —
eine leere `SECCustomToolBar` (außer `CSearchBar`) wird beim Beenden also
gelöscht.

### 3. `CWinApp::SaveAllModified()` — erreicht über `winfrm.cpp:874`

Neu in der Rangliste, weil Auftrag 2 den Weg dorthin freigelegt hat. Je
Dokument läuft `SaveModified()`:

* `CDoc::SaveModified` (`doc.cpp:49-72`) und `CMessageDoc::SaveModified`
  (`msgdoc.cpp:940-1075`) rufen im *Ja*-Zweig `DoSave(m_strPathName, TRUE)`.
* `CDocument::DoSave` (MFC 14, `doccore.cpp:370`) prüft die Vorlage nur mit
  `ASSERT(pTemplate != NULL)` — **kein `ENSURE`**, also kein Wurf, sondern eine
  Zugriffsverletzung, wenn ein Dokument ohne Vorlage drankommt. Gemessen: das
  ist hier **keine** Wurfstelle.
* `CDocument::SetPathName` (`doccore.cpp:278-314`) hat `ENSURE(lpszPathName)` —
  das kann aus einer `CString` heraus aber nie NULL werden; bei leerem Pfad
  wirft `AfxFullPath` eine **`CFileException`** (`badPath`), deren Text
  *anders* lautet. Also auch hier **kein** „improper argument".

Bleibt an dieser Kette der **lautlose** Ausgang: liefert ein `SaveModified`
FALSE, kehrt `CFrameWnd::OnClose` ohne ein Wort zurück. Das ist die Erklärung
für „es passiert nichts" — **nicht** für die Meldung.

### 4. Nicht mehr führend, aber weiter belegte Mängel

* `CMainFrame::SaveOpenWindows(TRUE)` (`mainfrm.cpp:2429`, Abbruch am einzigen
  `break`, Rückgabe `return (Win? FALSE : TRUE)`): der einzige **lautlose**
  Ausgang von `CloseDown`. Erklärt „nichts passiert", nicht die Meldung.
  `((CMDIChild*)Win)->GetTemplateID()` bleibt eine harte Umwandlung, geschützt
  nur durch `ASSERT_KINDOF`.
* `QuerySendQueuedMessages` (`mainfrm.cpp:5027`) → `ExitAfterSend`
  (`sendmail.cpp:3741-3745`): bei jedem Sendefehler wird `WM_CLOSE` nie
  nachgeschickt.
* Blinde Zeiger (Fehlerklasse E-35): `compmsgd.cpp:524`, `msgdoc.cpp:1027`,
  `TocFrame.cpp:3966-3972`, `QCTaskManager.cpp:82-86`, `mainfrm.cpp` bei
  `g_Nicknames`. Jeder stürzt ab, keiner wirft.
* `VERIFY(...Destroy())` sechsmal in `CEudoraApp::ExitInstance`
  (`eudora.cpp:2028-2034`) — prüft im Release-Bau nichts.

### 5. Geprüft und als Wurfstelle ausgeschlossen

| Stelle | Messung |
|---|---|
| `CFileBrowseView::OnAppExit` (`FileBrowseView.cpp:2218`) | **gestrichen** — Gregors Messung: Kreuz und Alt-F4 zeigen dasselbe Symptom, und die gehen nicht über die Befehlszustellung |
| `CTocDoc::CanCloseFrame` (`tocdoc.cpp:1295,1312`) | **widerlegt**, zweifach — siehe Auftrag 2 |
| `CDocument::CanCloseFrame` (`doccore.cpp:243-267`) | benutzt `GetParentFrame()` **ohne** `EnsureParentFrame`, nur `ASSERT_VALID` — kein Wurf |
| `CFrameWnd::ShowControlBar` (`winfrm.cpp:1378`) | `ENSURE_VALID(pBar)`, aber `pBar` kommt aus der eigenen Leistenliste |
| `CDynamicMenu::DeleteMenuObjects` (`DynamicMenu.cpp:55-72`) | `CMenu::GetMenuItemCount` liefert bei Fehler `(UINT)-1`; `int i = … - 1` wird damit negativ, die Schleife läuft nicht. `CMenu::GetSubMenu` wirft nicht |
| `CFrameWnd::SaveBarState` / `GetDockState` / `CDockState::SaveState` (`dockstat.cpp:448,534,354`) | in `dockstat.cpp` steht **kein einziges** `ENSURE`; alle Schleifen sind an `m_arrBarInfo.GetSize()` gebunden |
| `SECToolBarManager::SaveState` (`OTShim_Werkzeugleiste.cpp:4378`), `SECCustomToolBarInfoEx::SaveState` (`:3310`) | beide nur `GetSize()`-gebundene Schleifen |
| Reiter der Ersatzschicht (`OTShim_Reiter.cpp:400-470`) | `GetTabPtr` prüft über `TabExists`; `GetTabInfo`, `GetActiveTab`, `GetTabCount` sind alle gesichert |
| alles hinter `pApp->HideApplication()` (`winfrm.cpp:885`) | ausgeschlossen, weil Gregors Fenster nach der Meldung noch da ist |

## Auftrag 3: die eine Stelle — und der Beleg, der noch fehlt

**Verdacht:** `QCCustomToolBar::SaveCustomInfo`,
`Eudora71/Eudora/QCCustomToolBar.cpp:421-512`.

**Belegt ist das noch nicht.** Aus dem Quelltext allein ist es nicht zu
beweisen: die Schleifengrenze und der Index stammen sichtbar aus demselben
Feld, und **warum** sie bei E-34 auseinanderliefen, ist bis heute offen (siehe
unten). Nach der Auflage aus dem Auftrag — *„Kannst Du sie nicht belegen,
behebe nichts"* — ist deshalb **nichts behoben**.

**Der Beleg, der dafür gebraucht wird, ist eingebaut** (nur Spurmarken, keine
Verhaltensänderung):

| Datei | Marke |
|---|---|
| `QCCustomToolBar.cpp:408-415` | vor der Schleife: `E-33 SaveCustomInfo: Abschnitt=… GetBtnCount=…` |
| `QCCustomToolBar.cpp:419-422` | `TRY {` um die Schleife |
| `QCCustomToolBar.cpp:514-533` | `CATCH_ALL(e)` → `GetErrorMessage` ins Protokoll: `E-33 SaveCustomInfo: Ausnahme bei Index %d von %d - Grund: %s`, danach **`THROW_LAST()`** |

Die Einfassung **fängt nicht ab**. Sie schreibt Platz, Anzahl und den
Meldungstext ins Protokoll und wirft mit `THROW_LAST()` unverändert weiter — am
Ablauf ändert sich also nichts, aber die Meldung hat danach eine Adresse.
Steht die Zeile im Protokoll und liest sie *„Encountered an improper
argument"*, **ist die Stelle belegt**; steht sie nicht da, ist der Verdacht
widerlegt und die Marken davor sagen, welcher Aufruf es stattdessen war.

Damit das auch bei einem Fehlschlag etwas nützt, sind die Stufenmarken aus dem
ersten Durchgang **auf Aufrufgenauigkeit verfeinert** — eine Marke unmittelbar
vor und eine unmittelbar nach jedem Aufruf, auf dem ganzen Stück vor
`HideApplication`:

| Datei | Marken |
|---|---|
| `mainfrm.cpp`, `CloseDown` Stufe 5 | `5a` vor / `5b` nach `TrimJunk`; `5c`/`5d` um `RemoveControlBar(m_pToolBarAd)` und `RemoveAdToolBarFromItsDockBar`; `5e` vor `RemoveBogusAdToolBars`; `5f` vor / `5g` nach `SaveBarState(ToolBar)`; `5g`/`5h` um `SaveWazooBarConfigToIni`; `5i` vor `WriteToolBarMarkerToIni` |
| `mainfrm.cpp`, `OnClose` nach `CloseDown` | `6a`/`6b` um `CloseImapConnections`; `6b`/`6c` um `EmptyTrash`; `6d` vor `TrayItem`; `6e` vor / `6f` nach `DeleteMenuObjects` |

Die vierzehn Marken des ersten Durchgangs bleiben alle stehen; dazu kommen
diese vierzehn. **Die letzte geschriebene E-33-Zeile nennt jetzt den Aufruf,
nicht nur die Stufe.**

> **Ohne `LogLevel=32896` unter `[Settings]` in der `Eudora.ini` schreibt keine
> einzige dieser Marken.** `PutDebugLog` prüft die Maske und kehrt sonst sofort
> zurück (`QCUtils/src/debug.cpp:138-143`). 32896 = 0x8080 =
> `DEBUG_MASK_MISC` (0x8000) `|` `DEBUG_MASK_TOC_CORRUPT` (0x80).

## Auftrag 4: nichts behoben — und warum

Es ist **nichts** behoben. Grund: der Verdacht ist nicht belegt (Auftrag 3),
und eine Behebung nach dem Muster von E-34 (Indexschranke +
`TRY`/`CATCH_ALL` + NULL-Prüfung an jeder Aufrufstelle) hätte hier keine
Aufrufstellen, die etwas prüfen könnten — `SaveCustomInfo` schreibt nur in die
INI-Datei. Eine Schranke, die den Wurf verschluckt, würde das Beenden
vielleicht durchlassen und dabei die **Ursache** endgültig verdecken. Genau
diesen Fehler hat E-34 gemacht und damit E-35 und E-36 erzeugt.

`tools/pruefe-bytes.pl` → **0**. `tools/pruefe-fensterbau.pl` → **0**, alle
drei Schranken stehen (0 modale Meldungen; `GetButton` mit Schranke und
Ausnahmefang; 10 Aufrufstellen, 0 ohne NULL-Prüfung). CR-Anzahl in
`mainfrm.cpp` und `QCCustomToolBar.cpp` unverändert **18**, alle neuen Zeilen
LF.

**Muss `pruefe-fensterbau.pl` um den Beenden-Weg erweitert werden?** Noch
nicht — eine Schranke hält eine **Behebung** fest, und es gibt keine. Sobald
eine Wurfstelle belegt und gesichert ist, gehört genau diese Sicherung in das
Werkzeug, mit Gegenprobe. Vorher wäre es eine Schranke ohne Gegenstand. Was
`pruefe-fensterbau.pl` **grundsätzlich** nicht erfasst: der Mechanismus
`CWinApp::ProcessWndProcException` → `ReportError` liegt **in MFC**, nicht in
`Eudora71/`.

## Was **nicht** belegt ist

* **Die Ursache ist nicht gefunden.** Die Rangliste ist eine Rangliste mit
  Fundstellen und Messungen, kein Befund.
* **Die offene Wurzel von E-34 bleibt offen, und sie ist ein Widerspruch.**
  `GetBtnCount()` ist `inline (int)m_btns.GetSize()`, also `m_nSize`; der
  Zugriff `m_btns[24]` prüft in `CPtrArray::ElementAt` gegen **dasselbe**
  `m_nSize`. Aus einem einzigen, unveränderten Objekt heraus **kann** „Index 24
  von 27" nicht werfen. Es bleiben nur Erklärungen, die außerhalb der
  Indexrechnung liegen: ein Zeiger auf ein bereits abgebautes oder falsch
  typisiertes Leistenobjekt, oder beschädigter Heap. **Solange das offen ist,
  ist auch Platz 1 nur ein Verdacht** — und dieselbe Wurzel könnte an jeder
  anderen `m_btns`-Schleife zuschlagen.
* Ob eine Rückfrage („Änderungen speichern?") vor der Meldung erscheint, ist
  nicht bekannt. Das entscheidet, ob Platz 3 mitspielt.
* Ob `CloseDown` überhaupt bis Stufe 5 kommt, ist nicht gemessen — dafür sind
  die neuen Marken da.

## Nebenbefund: `tools/lehren-spiegeln.pl` ist aus einem Arbeitsbaum unbrauchbar

Das gehört nicht zu E-33, darf aber nicht verlorengehen.

`tools/lehren-spiegeln.pl` bestimmt sein Ziel über
**`git rev-parse --git-common-dir`**. In einem `git worktree` zeigt das immer
auf das `.git` des **Hauptbaums** — das Werkzeug schreibt die gespiegelten
Lehren also nach `Eudora7.2\Arbeitsweise\…` im Hauptbaum, nicht in den
Arbeitsbaum, aus dem es gestartet wurde.

**Folge:** die Forderung des `pre-commit`-Hooks, `git add Arbeitsweise`
mitzustagen, ist aus einem Arbeitsbaum heraus **grundsätzlich unerfüllbar** —
die Datei, die gestaget werden soll, liegt außerhalb des Arbeitsbaums und ist
für dessen Index unerreichbar. Wer in einem Arbeitsbaum eine Lehre anlegt,
kann sie dort nicht committen; sie landet stumm im Hauptbaum und erscheint dort
als unversionierte Änderung.

Die Behebung liegt nicht bei mir (so abgesprochen). Der Ort ist
`tools/lehren-spiegeln.pl`, der Aufruf von `--git-common-dir`; gebraucht wird
`--show-toplevel` (der Arbeitsbaum) für das Schreiben, und `--git-common-dir`
höchstens noch zum **Finden** des Gedächtnisses.

---

## Nachtrag 07.09.2026: was PRUEFER an diesem Bericht berichtigt hat

Nachgeprüft in `Befunde/PRUEFER-4.md`, 56 Stellen in 49 Dateien, 24 behauptete
Zeilenangaben einzeln nachgeschlagen. Fünf Angaben dieses Berichts sind falsch:

| Behauptet | Gemessen |
|---|---|
| die Meldung sei `AFX_IDP_INVALID_ARGUMENT` | **`AFX_IDS_INVALID_ARG_EXCEPTION`, `0xF025`** (`afxres.h:382`); der behauptete Bezeichner steht nirgends in `atlmfc`. Belegt am Ressourcenverzeichnis von `mfc140enu.dll`: `RT_STRING`-Block `0xF03`, Index 5 |
| „Kreuz und Alt-F4 zeigen dasselbe ⇒ der Wurf liegt in `OnClose`/`CloseDown`" | **trägt nicht.** Kreuz und Alt-F4 teilen zusätzlich `WM_SYSCOMMAND`/`SC_CLOSE`, den *File → Exit* nicht hat — und dort steht `ENSURE_VALID(pFrameWnd)` in `CFrameWnd::OnSysCommand` (`winfrm.cpp:1112-1114`): dieselbe Ausnahme, dieselbe Meldung, **vor** jedem `OnClose`. Es folgt **nur**, dass der `WM_COMMAND`-Behandler ausgeschlossen ist |
| der Verdacht auf `SaveCustomInfo` sei die „E-34-Form" | **Begründung widerlegt.** `GetBtnCount()` **ist** `m_btns.GetSize()` (`OTShim_Werkzeugleiste.h:744`), wird je Durchlauf neu ausgewertet, und der Rumpf verändert `m_btns` nirgends — einfädig ist dort kein Indexfehler möglich. `QCChildToolBar::GetButton` hat **dieselbe** Absicherung (`:120`) und hat trotzdem geworfen. Die Kette und die Einfassung sind bestätigt, der Verdacht bleibt **möglich, aber unbegründet** |
| „28 Marken" | **32**: 28 in `mainfrm.cpp`, 2 in `eudora.cpp`, 2 in `QCCustomToolBar.cpp`. Die 28 gelten nur für `mainfrm.cpp` |
| `mainfrm.cpp:6182` für den `else`-Zweig | **`mainfrm.cpp:6263-6266`**, in `RemoveAdToolBarFromItsDockBar` ab `:6242` |

**Was PRUEFER bestätigt hat:** `appcore.cpp:1009-1039` liefert bei `WM_CLOSE`
nachweislich 0 und zeigt den Ausnahmetext; `wincore.cpp:273` macht die 0 zur
Antwort. `THROW_LAST()` = `(AfxThrowLastCleanup(), throw)` (`afx.h:867`),
`END_CATCH_ALL` = `} } }` — **verschluckt wird nichts**, und `CATCH_ALL` fängt
nur `CException*`, Speicherschutzverletzungen laufen durch. Ebenfalls genau:
`winfrm.cpp:843`/`:885`, `bardock.cpp:302-308` mit `ENSURE(nPos > 0)` in `:308`,
`debug.cpp:140`, `sendmail.cpp:3741`, `mainfrm.cpp:2570`,
`QCToolBarManager.cpp:1109`, `QCCustomToolBar.cpp:421`.

**Die offene Frage, die alles entscheidet und einen Klick kostet:** bringt
*File → Exit* die Meldung **auch**, oder passiert dort lautlos nichts?

- **Auch dort** → der gemeinsame Grund ist `OnClose`/`CloseDown`.
- **Nur bei Kreuz und Alt-F4** → es ist `CFrameWnd::OnSysCommand`
  (`winfrm.cpp:1112-1114`), und der ganze Rest dieses Berichts betrifft dann
  einen anderen Fehler.

**Zwei weitere Vermutungen hat PRUEFER selbst geprüft und verworfen:** ein
ODR-Bruch durch zwei `SECCustomToolBar`-Definitionen (`tbarcust.h:73` gegen
`OTShim_Werkzeugleiste.h:693`) — widerlegt, weil `:1436` `__TBARCUST_H__` setzt
und `:53-58` mit `#error` abbricht; und dass `RestorePassInfo` den Abschnitt
einer gelöschten Persönlichkeit neu schreibe — widerlegt,
`persona.cpp:1073-1129` berührt nur `m_Passwords` und `::POPPassword`.
