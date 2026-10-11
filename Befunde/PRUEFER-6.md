# PRUEFER-6 — Review von A-3 (Registerkarten) und A-4 (Trennbalken links)

| | |
|---|---|
| Datum | 09.09.2026 |
| Arbeitsbaum | `C:\Users\Gregor\Documents\github\Eudora7.2-wt-pruefer` |
| Zweig | `wt/pruefer` |
| Prüfstand | gelesen auf `40ec935` („A-4 umgesetzt, A-3 nachgebessert"); **alle Zeilenangaben auf `d751d23`** („E-53 behoben") umgerechnet und einzeln nachgeschlagen. `d751d23` aendert an `OTShim.cpp` nur die Fuellflaeche in `OnPaint` (E-53) und beruehrt keinen Befund dieses Reviews |
| Geprüfte Dateien | `Eudora71/OTShim/OTShim.cpp`, `OTShim.h`, `Eudora71/Eudora/workbook.cpp`, `DockBar.cpp`, `mainfrm.cpp`, `settings.cpp`, `AdWazooBar.cpp`, `WazooBarMgr.cpp` |
| MFC-Quellen | `C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\atlmfc` |
| Nicht getan | nicht gebaut, kein Programm gestartet, kein `git push`; geschrieben wurde nur diese Datei |

**Kurzfassung.** Von den acht Behauptungen halten sechs ganz, eine halb
(Punkt 6), eine nicht (Punkt 7 — die Ziehschleife kann *nicht* mehr hängen,
aber sie kann Schlimmeres). Der schwerste neue Befund ist **kein Hänger**,
sondern eine **Benutzung nach dem Freigeben** in derselben Schleife
(Abschnitt 7c). Dazu kommen vier Regressionen, die erst dadurch entstanden
sind, dass `m_bWorkbookMode` jetzt `TRUE` ist (Abschnitte N-1 bis N-4).

---

## 1. `SECWorkbook::OnPaint` — `CPaintDC` und Ausnahmen

**Behauptung:** `OnPaint` legt eine `CPaintDC` an, ruft `m_cxTab =
recalcTabWidth()` und je sichtbarem Blatt `OnDrawTab` + `OnDrawTabIconAndLabel`.
Frage war, ob die Basis ebenfalls eine `CPaintDC` anlegt und was eine Ausnahme
anrichtet.

### (a) Legt die Basis eine zweite `CPaintDC` an? — **Nein, widerlegt**

Nachgemessen, nicht vermutet:

* `SECMDIFrameWnd` hat **keine** `OnPaint` — weder Deklaration
  (`OTShim.h:1097-1240`) noch Nachrichtentabelleneintrag. Der Aufruf
  `SECMDIFrameWnd::OnPaint()` (`OTShim.cpp:1383`) bindet damit statisch an
  `CWnd::OnPaint`.
* `CWnd::OnPaint` (`src/mfc/wincore.cpp:4278-4288`) legt eine `CPaintDC`
  **nur** an, wenn `m_pCtrlCont != NULL` (fensterloser ActiveX-Container).
  Sonst: nichts als `Default()`.
* Es gibt genau **einen** `ON_WM_PAINT` in der ganzen Rahmenkette:
  `CMainFrame` (`mainfrm.cpp:525`). `QCWorkbook` hat keinen
  (`workbook.cpp:640-649`), `SECWorkbook` hat einen (`OTShim.cpp:790`), der
  aber vom abgeleiteten `CMainFrame` verdeckt wird.
* `CMainFrame::OnPaint` (`mainfrm.cpp:1946-1961`) legt eine eigene `CPaintDC`
  **nur im Symbolzustand** an und kehrt dann sofort zurück; sonst reicht sie
  an `QCWorkbook::OnPaint` → `SECWorkbook::OnPaint` weiter.

**Also genau eine `BeginPaint`/`EndPaint`-Klammer je `WM_PAINT`.** Der
Verdacht ist ausgeräumt.

*Nebenbei:* der Rückfallzweig `SECMDIFrameWnd::OnPaint()` wäre die einzige
Stelle mit einem echten Doppel — wenn `m_pCtrlCont` je gesetzt würde, machte
`CWnd::OnPaint` `BeginPaint`/`EndPaint` **und** danach `Default()`. Bei
`CMainFrame` ist `m_pCtrlCont` NULL (kein `EnableControlContainer`-Aufruf im
Bestand gefunden). Kein Handlungsbedarf, aber es ist kein Zufallsverdienst.

### (b) Kann `OnDrawTab` werfen? — **Praktisch nein**

Der Sorge lag `ENSURE` zugrunde (`afx.h:379-387`: `ENSURE(cond)` →
`AfxThrowInvalidArgException()` auch im Release). Ich habe jede GDI-Anweisung
des Zeichenwegs im MFC-Quelltext aufgeschlagen:

| Aufruf | MFC-Fundstelle | wirft? |
|---|---|---|
| `dc.FillSolidRect(&rect, clr)` | `wingdix.cpp:212-220` | `ENSURE_VALID(this)`, `ENSURE(m_hDC)`, `ENSURE(lpRect)` — **kann werfen**, aber alle drei sind bei gültiger `CPaintDC` erfüllt |
| `CDC::SelectObject(CPen*/CBrush*/CFont*)` | `wingdi.cpp:232-266` | nur `ASSERT` |
| `CDC::MoveTo` / `LineTo` | `wingdi.cpp:616-634` | `ASSERT` + `VERIFY` (Release: Ausdruck ja, Prüfung nein) |
| `CGdiObject::Attach` (aus `CreateSolidBrush`, `CreateRectRgn`, `CreatePen`) | `wingdi.cpp:1111-1121` | nur `ASSERT`, liefert `FALSE` |
| `CPaintDC::CPaintDC` | `wingdi.cpp:1047-1054` | `AfxThrowResourceException()` bei `BeginPaint == NULL` |

Die Zeichenwerkzeuge sind alle gültig: `m_fontTab`, `m_penWhite/Black/Shadow/Face`
in `SECWorkbook::CreateClient` (`OTShim.cpp:884-895`), `m_fontTabBold` und
`m_penHilight` in `QCWorkbook::CreateClient` (`workbook.cpp:804-808`). Ein
leeres `CFont`/`CPen`, das im Original ein Zusicherungsfehler gewesen wäre,
gibt es nicht.

**Bleibt ein Restweg:** `CPaintDC` selbst. Fliegt `AfxThrowResourceException`,
fängt `AfxCallWndProc` sie ab, der ungültige Bereich bleibt aber **stehen** →
Windows schickt `WM_PAINT` sofort wieder → Dauerschleife bei 100 % Last. Das
ist die einzige Ausnahmelage, die den Rahmen wirklich lahmlegt, und sie ist
mit drei Zeilen abzufangen (`try`/`catch` um den Rumpf plus `ValidateRect`).
Empfehlung, keine Fehlermeldung.

**Urteil 1: Behauptung hält. Der geäußerte Verdacht ist widerlegt.**

---

## 2. `GetTabPts` — die sechs Punkte gegen jeden Leser einzeln

**Behauptung:** Reihenfolge 0 = oben links, 1 = unten links, 2 = unten links,
3 = unten rechts, 4 = unten rechts, 5 = oben rechts.

**Der stärkste Beleg dafür stand ungenutzt im Bestand:** `QCWorkbook`
überschreibt im eigenen Konstruktor `m_cxFold = 0; m_cxActive = 0;
m_cyActive = 0;` (`workbook.cpp:661-663`). **Ohne Abschrägung fallen 1/2 und
3/4 zwangsläufig zusammen** — die gelieferte Reihenfolge ist also nicht nur
verträglich, sie ist die einzig richtige für `QCWorkbook`.

Rechenbasis (nach `QCWorkbook::GetTabPts`, `workbook.cpp:978-989`: alle Punkte
`+2/-2`, bei 3, 4, 5 zusätzlich `x-1`), mit
`oben = Streifen.top + 2`, `unten = oben + 20`:

| | Roh (Shim) | Nach QCWorkbook |
|---|---|---|
| pts[0] | (links, oben) | (links+2, oben-2) |
| pts[1] | (links, unten) | (links+2, unten-2) |
| pts[2] | (links, unten) | (links+2, unten-2) |
| pts[3] | (rechts, unten) | (rechts+1, unten-2) |
| pts[4] | (rechts, unten) | (rechts+1, unten-2) |
| pts[5] | (rechts, oben) | (rechts+1, oben-2) |

Jede der sechs verlangten Stellen einzeln durchgerechnet:

| Stelle | liest | Ergebnis | Urteil |
|---|---|---|---|
| `QCGetTabRect` (`workbook.cpp:745-757`) | `pts[0]`, `pts[4]` | `(links+2, oben-2, rechts+1, unten-2)` — normalisiert, Höhe 20, Breite `cxKarte-1` | **passt** |
| `OnDrawTab` (`:1254-1334`) | 0,1,2,4,5 | Gebiet `(links+3, oben-1)–(rechts, unten-2)`, Breite `cxKarte-5`, Höhe 19; Linienzüge ergeben einen geschlossenen Kasten | **passt** |
| `GetIconAndTextPositions` (aus `OnDrawTabIconAndLabel`, `:1569-1597`) | 0,2,3,4 | Symbol bei `(links+7, oben+2)`; Text `(links+26, oben-1, rechts-2, unten-1)`, Höhe 20 | **passt** |
| `TabHitTest` (`:1739-1775`) | über `QCGetTabRect` | dieselbe Geometrie wie das Zeichnen | **passt** |
| `RecalcToolTipRects` (`:1671-1729`) | über `QCGetTabRect` | dieselbe Geometrie | **passt** |
| `IsTabLabelTruncated` (`:1528-1559`) | über `GetIconAndTextPositions` | dieselbe Geometrie | **passt** (aber siehe **N-1**) |

**Zwei Löcher, beide klein, beide belegt:**

* **2a — Textbreite kann negativ werden.** `rectText.Width() = cxKarte - 30`
  (nachgerechnet aus `:1587`). `recalcTabWidth` (`:999-1010`) liefert
  `(MDI-Breite + 10) / Anzahl sichtbarer Blätter`, gedeckelt auf 130. Ab
  **etwa 30 offenen Fenstern bei 900 Pixel MDI-Breite** wird `cxKarte < 30`.
  Dann kürzt die `while`-Schleife in `OnDrawTabIconAndLabel` (`:1377-1385`)
  bis `len < 4`, also auf `"..."`, und `DrawText` malt in ein umgestülptes
  Rechteck. Kein Absturz, keine Endlosschleife (die Schleife verkürzt in jedem
  Durchlauf um ein Zeichen), aber leere Karten. **Kosmetisch.**
* **2b — `m_cxTab` ist außerhalb von `OnPaint` veraltet.** Gesetzt wird es nur
  in `SECWorkbook::OnPaint` (`OTShim.cpp:1418`). `TabHitTest`,
  `RecalcToolTipRects` und der Ablegetest rechnen aber jederzeit über
  `GetTabPts`. Zwischen `StreifenAuffrischen()` (nur `InvalidateRect`) und dem
  tatsächlichen `WM_PAINT` liegt ein Fenster, in dem **Treffertest und
  Zeichnung auseinanderlaufen** — genau eine Kartenbreite je neu geöffnetem
  Fenster. Fix: `m_cxTab = recalcTabWidth()` an den Anfang von `GetTabPts`
  ziehen oder in `StreifenAuffrischen` mitziehen. **Eine Zeile.**

**Urteil 2: Behauptung hält für alle sechs Leser. Zwei Nebenlöcher gefunden.**

---

## 3. Streifen ab MDI-Bereich statt `rectClient.left`

**Behauptung:** bewusste Abweichung von `QCGetTaskBarRect`; `QCGetTaskBarRect`
werde nur zum Ungültigerklären benutzt, ein zu großes Rechteck schade dort
nicht.

**Vollständige Liste der Benutzer von `QCGetTaskBarRect`** (gemessen über den
ganzen Baum `Eudora71/Eudora`, nicht geschätzt): **zwei**.

1. `QCInvalidateAllTabs` (`workbook.cpp:955-969`) — nur `InvalidateRect`.
   Zu groß ist unschädlich: der überzählige Teil liegt unter der linken
   Andockleiste, und die ist ein Kindfenster mit `WS_CLIPCHILDREN` am Rahmen;
   der Rahmen malt dort ohnehin nicht. **Behauptung bestätigt.**
2. `CalcLogoTopLeft` (`workbook.cpp:1411-1467`) — benutzt vom ganzen Rechteck
   **nur `rectTaskBar.top`**, und `top` ist in beiden Fassungen identisch
   (`rectMDIClient.bottom + 2`). Links und rechts holt sie sich selbst aus
   `m_pWBClient->GetWindowRect()`. **Die Abweichung wirkt sich hier nicht
   aus.** Aber siehe **N-2** — `CalcLogoTopLeft` hat ein anderes Problem.

**Laufen Zeichnen und Treffertest auseinander?** Nein. Beide Wege enden in
`GetTabPts` → `OTShimStreifenRect` (`OTShim.cpp:1058-1092`):

* Zeichnen: `SECWorkbook::OnPaint` → `OnDrawTab`/`OnDrawTabIconAndLabel` → `GetTabPts`
* Maus: `QCWorkbook::OnLButtonDown` (`:1095`) → `TabHitTest` → `QCGetTabRect` → `GetTabPts`
* **Ziehen und Ablegen:** `CMainFrameOleDropTarget` (`mainfrm.cpp:8819` in
  `OnDragOver`) ruft `pMainFrame->TabHitTest(point, FALSE)` — **nicht**
  `QCGetTaskBarRect`. Also derselbe Weg. Der Kommentarkopf von
  `QCGetTaskBarRect` („can be used … for drag and drop hit tests",
  `workbook.cpp:920-922`) ist im Bestand **nicht eingelöst**; er hat mich
  zunächst in die Irre geführt und ist eine Falle für den nächsten Leser.
* Kurzhinweise: `RecalcToolTipRects` → `QCGetTabRect` → derselbe Weg.
* Der Klick auf den Logobereich (`mainfrm.cpp:8827`, `workbook.cpp:1132`) geht
  über `IsOnMDIClientAreaBlankSpot`/`CalcLogoTopLeft`, beide ohne
  `QCGetTaskBarRect`-Geometrie.

**Urteil 3: Behauptung hält vollständig. Kein Auseinanderlaufen.**

---

## 4. `m_bSelected` im Zeichnen löschen

**Behauptung:** vertretbar, weil die Marke „gewählt, Rahmen noch nicht aktiv"
ihren Zweck verloren hat, sobald ein anderer Rahmen aktiv ist.

### (a) Ist die Zustandsänderung im Zeichnen gefährlich? — **Nein**

`SetSelected` ist eine Inline-Zuweisung ohne Fensterbotschaft und ohne
`Invalidate` (`OTShim.h:1305-1306`). Keine Wiedereintrittsgefahr, kein
zweites `WM_PAINT`. Der Zeigervergleich `pBlatt != (SECWorksheet*) pAktiv` ist
zulässig: die Kette `SECWorksheet → SECMDIChildWnd → CMDIChildWnd → CFrameWnd →
CWnd` ist **einfache** Vererbung, die Adresse ändert sich beim Abwärtscast
nicht. Eudora selbst vergleicht an drei Stellen genauso (`workbook.cpp:1270,
1371, 1546`).

### (b) Gibt es einen Fall, in dem die Marke gebraucht wird, während der Rahmen noch nicht aktiv ist? — **Nein, aber die Begründung liegt woanders, als angenommen**

Ich habe die Stelle aufgeschlagen, `workbook.cpp:1095-1165`, und dazu die
Aktivierungsseite, die im Auftrag nicht genannt war:

* `QCWorkbook::OnLButtonDown` (`:1109`) setzt `SetSelected(TRUE)` und ruft
  **unmittelbar danach** `MDIActivate(pSheet)` (`:1118`) — synchron, per
  `WM_MDIACTIVATE`. Wenn das nächste `WM_PAINT` läuft, ist `GetActiveFrame()`
  bereits das neue Blatt. Das Fenster, in dem „gewählt, aber noch nicht aktiv"
  gelten müsste, existiert also **nicht einmal für ein Neuzeichnen**.
* **Gegenvermutung, die ich aufstellen und widerlegen musste:** „ein
  Fensterwechsel über das Menü *Window* oder Strg+Tab lässt die alte Karte
  gedrückt, weil dann niemand den Streifen für ungültig erklärt." —
  **Widerlegt.** `QCWorksheet::OnMDIActivate` (`workbook.cpp:133-150`)
  erklärt **beide** Karten für ungültig, die abgehende und die ankommende, je
  über `QCGetTabRect` plus zwei Pixel. Das Neuzeichnen kommt also von selbst.

**Die Marke ist damit tot:** gelesen wird sie nur noch an drei Zeichenstellen
(`:1270`, `:1371`, `:1546`), und dort ist sie zum Lesezeitpunkt garantiert
`FALSE` für jedes nicht aktive Blatt. Das ist kein Fehler, aber die Behebung
sitzt an der teuersten Stelle: sie läuft bei **jedem** Neuzeichnen über
**alle** Blätter. Der Ort mit einem Auslöser wäre `SECWorksheet::OnMDIActivate`
(`OTShim.cpp:679-682`, heute reines Durchreichen): dort steht das
abgehende Blatt schon als Parameter bereit.

**Urteil 4: Behauptung hält. Empfehlung: nach `OnMDIActivate` verschieben.**

---

## 5. `CalcFixedLayout` — Zuschlag `3 * Splitter::cx`

**Behauptung:** Zuschlag, wenn Kennung eine der vier Andockleisten,
`!m_bFloating` und Basisgröße `> 8`.

Der Code steht in `OTShim.cpp:2908-2973`, die Bedingung in `:2959`,
`Splitter::cx == 4` in `:2399`. Zuschlag also **12**.

### (a) Schwebende Leiste — **doppelt abgesichert, in Ordnung**

Eine schwebende Andockleiste entsteht in `SECMiniDockFrameWnd::Create`
(`OTShim.cpp:4133-4139`) mit der Kennung **`AFX_IDW_DOCKBAR_FLOAT`**. Damit
ist `bAndockleiste` schon `FALSE`; die Zusatzprüfung `!m_bFloating` ist
Gürtel und Hosenträger. `TrennbalkenNeuAnlegen` prüft `!m_bFloating` noch
einmal (`:3986`). **Kein Loch.**

### (b) Mehrere Leisten in einer Zeile — **Loch, belegt**

`TrennbalkenNeuAnlegen` (`OTShim.cpp:3982-4062`) nimmt die **erste sichtbare**
angedockte Leiste aus `m_arrBars` — das ist die erste Leiste der **ersten
Zeile**. `m_arrBars` läuft aber über *alle* Zeilen, durch `NULL` getrennt.

Stehen im linken Andockbereich **zwei Zeilen** (bei senkrechter Ausrichtung:
zwei Spalten nebeneinander), dann ist

```
nFrei = rect.right - rectLeiste.right
```

nicht der 8-Pixel-Greifstreifen, sondern **die ganze zweite Spalte plus
Streifen**. Der angelegte Balken (`:4037-4039`) überdeckt dann die zweite
Spalte vollständig: `OnSetCursor` zeigt dort den Größenzeiger, und
`OnLButtonDown` (`:3905-3916`) fängt **jeden** Klick ab, bevor
`CDockBar::OnLButtonDown` ihn sieht. **Die zweite Leiste wäre unbedienbar**,
und `OnSplitterMoved` würde die Größe der *ersten* ändern.

Erreichbar ist das: `m_pSearchBar->EnableDocking(CBRS_ALIGN_ANY)`
(`mainfrm.cpp:903`), `m_pToolBar` (`:1761`), `m_pToolBarAd` (`:6285`) und
jede Wazoo-Leiste dürfen links andocken. Es genügt, eine zweite Leiste neben
die vorhandene zu ziehen. **Vorschlag:** `nFrei` gegen eine Obergrenze
(etwa `4 * Splitter::cx`) deckeln, dann ist der Balken im schlimmsten Fall an
der falschen Stelle statt flächendeckend.

### (c) Die Reklameleiste — **`QCDockBar::CalcTrackingLimits` reicht, aber nicht deshalb**

Zuerst die Voraussetzung, die im Auftrag als gegeben unterstellt war und die
ich nachgemessen habe: die Andockleisten sind **tatsächlich** `QCDockBar`
(`CMainFrame::EnableDocking`, `mainfrm.cpp:2181-2199`, `DEBUG_NEW QCDockBar`
für alle vier Kennungen). `StartTracking` ruft `CalcTrackingLimits` virtuell
(`OTShim.cpp:3590`), landet also wirklich in `DockBar.cpp:149`. **Die Kette
ist geschlossen.**

Was `QCDockBar::CalcTrackingLimits` leistet und was nicht:

* Es **verschärft nur die Grenzen** (`__max`/`__min` auf `m_nMin`/`m_nMax`,
  `DockBar.cpp:203-212`), damit die Reklameleiste nicht unter `GetMinWidth()`
  gedrückt wird. Das genügt für den Fall „Balken schiebt die Reklame zusammen".
* Es tut **nichts**, wenn die Reklameleiste selbst die erste sichtbare Leiste
  ist und damit `pSplitter->m_nPos` trägt. Dann schreibt `OnSplitterMoved`
  `m_szDockVert.cx` der Reklameleiste. Das ist folgenlos, weil
  `CAdWazooBar::CalcFixedLayout` (`AdWazooBar.cpp:237-256`) das Ergebnis
  ohnehin mit `__max(theSize.cx, MinWidth)` nach unten festnagelt —
  **vergrößern** ließe sich die Reklame damit aber sehr wohl. Kosmetisch.
* Der ganze Zweig läuft nur bei `GetSharewareMode() == SWM_MODE_ADWARE`
  (`DockBar.cpp:152`).

### (d) Der Zuschlag trifft **alle vier** Andockleisten — **neu, nicht in der Behauptung**

Die Bedingung fragt nur nach der Kennung, nicht danach, ob dort überhaupt ein
Trennbalken gebraucht wird. Folge, aus dem Code abgeleitet:

* **oben** liegt `m_pToolBar` (`mainfrm.cpp:1761`) → die obere Andockleiste
  wird 12 Pixel höher, netto rund 8 Pixel **leerer Streifen unter der
  Werkzeugleiste**, und `TrennbalkenNeuAnlegen` legt dort einen waagerechten
  Balken an.
* **unten** dockt `WazooBarMgr.cpp:253` und `:493` Wazoo-Leisten an → dasselbe
  noch einmal.
* Zieht man den oberen Balken, schreibt `OnSplitterMoved` `m_szDockHorz.cy`
  der Werkzeugleiste. `SECControlBar::CalcFixedLayout` (`OTShim.cpp:1912-1938`)
  gibt genau dieses Feld zurück — die Werkzeugleiste ließe sich also in der
  Höhe verziehen, obwohl ihre Höhe von der Knopfgröße kommt.

Gregor hat „verschieben rauf / runter — bug gefixt, die anzeige ist korrekt"
gemeldet (E-52); das war also vermutlich genau dieser unbeabsichtigte obere
oder untere Balken. **Vorschlag:** Zuschlag und Balken auf die Andockleisten
beschränken, in denen mindestens eine Leiste mit `CBRS_SIZE_DYNAMIC` bzw.
eine `CWazooBar` steht — oder schlicht auf LINKS und RECHTS.

**Urteil 5: Behauptung hält für das Schwebende. Zwei Löcher: (b) mehrere
Zeilen, (d) alle vier Seiten.**

---

## 6. Balken entsteht in `OnSize` — kommt `WM_SIZE` wirklich immer?

Zwei Fragen, zwei verschiedene Antworten.

### (a) Kommt `WM_SIZE` nach jeder Größenänderung, auch bei `DeferWindowPos`? — **Ja, und die Reihenfolge stimmt sogar**

Das ist der Punkt, an dem ich die Behebung von E-52 gegen die MFC-Quelle
prüfen konnte, statt sie zu glauben. Belegt:

* `CDockBar::CalcFixedLayout` eröffnet ein **eigenes**
  `::BeginDeferWindowPos` (`bardock.cpp:385`) und schließt es mit
  `::EndDeferWindowPos` **innerhalb derselben Funktion** (`bardock.cpp:537`).
  Die **Kindleisten** werden also **sofort** verschoben.
* Die Andockleiste **selbst** wird erst danach verschoben, nämlich über
  `AfxRepositionWindow` in `CControlBar::OnSizeParent`
  (`barcore.cpp:799ff`), und zwar in das `hDWP` des **Rahmens**, das erst am
  Ende von `CFrameWnd::RecalcLayout` geschlossen wird.

**Folge: wenn die Andockleiste ihr `WM_SIZE` bekommt, stehen ihre Kindleisten
schon an der neuen Stelle.** `TrennbalkenNeuAnlegen` misst also mit
`pErste->GetWindowRect()` + `ScreenToClient()` (`OTShim.cpp:4015-4017`) einen
gültigen Wert. Die Verlagerung von `OnSizeParent` nach `OnSize` ist **richtig
und aus der MFC-Quelle begründbar**, nicht nur empirisch.

### (b) Kommt `OnSize` auch, wenn sich nur die Leiste darin ändert? — **Nein. Loch, belegt**

`AfxRepositionWindow` (`wincore.cpp:3276-3300`):

```
if (::EqualRect(rectOld, lpRect))
    return;     // nothing to do
```

Bleibt das Rechteck der Andockleiste gleich, gibt es **kein `SetWindowPos`,
kein `WM_WINDOWPOSCHANGED`, kein `WM_SIZE`** — und damit kein
`TrennbalkenNeuAnlegen`. Der Balken bleibt dort, wo er war.

Wann tritt das ein? Immer dann, wenn sich **innen** etwas verschiebt, ohne
dass die Gesamtbreite sich ändert. Zwei belegbare Fälle:

* Zwei Zeilen im linken Bereich, die erste wird ausgeblendet: die zweite
  bestimmt die Breite weiter, die Andockleiste bleibt gleich breit, aber
  `nPos` und die Innenkante haben gewechselt. Balken steht falsch und
  `OnSplitterMoved` greift die falsche Leiste.
* Eine Leiste in derselben Zeile wird sichtbar/unsichtbar, ohne die Breite
  der Zeile zu bestimmen.

**Vorschlag:** `TrennbalkenNeuAnlegen` zusätzlich in `SECDockBar::OnBarHideShow`
(`OTShim.cpp:3309`) und am **Ende** von `SECDockBar::CalcFixedLayout` (nur wenn
`!m_bLayoutQuery`) auslösen. Beide Stellen existieren schon.

**Urteil 6: Behauptung hält zur Hälfte. (a) bestätigt und jetzt belegt,
(b) widerlegt.**

---

## 7. `Splitter::Track` — der wichtigste Punkt

**Behauptung/Frage:** kann die Mausschleife noch hängen, und verschluckt sie
Nachrichten?

Der Rumpf steht in `OTShim.cpp:3737-3836`.

### (a) Kann sie hängen? — **Der genannte Weg: nein. Ein anderer: ja**

Die äußere Schleife bricht bei drei Bedingungen ab (`:3777-3785`): Fenster
weg, Mausfang weg, Taste los. Die Wartezeit ist auf 100 ms gedeckelt
(`:3787`). Das ist dicht **gegen den Fehler von E-51**.

**Zwei Gegenvermutungen, die ich prüfen musste:**

* *„`GetKeyState` liefert die physische Tastenlage, also greift der Abbruch
  immer."* — **Widerlegt.** `GetKeyState` liefert die **synchronisierte**
  Lage zum Zeitpunkt der zuletzt entnommenen Nachricht, nicht die physische;
  das wäre `GetAsyncKeyState`. Der Kommentar bei `:3784` („die PHYSISCHE
  Maustaste") ist **sachlich falsch**. Folgenlos ist es nur deshalb, weil die
  innere `PeekMessage`-Schleife mit `PM_REMOVE` ohnehin jede Eingabe
  entnimmt und damit die Lage laufend nachzieht. Der Kommentar gehört
  berichtigt, sonst verlässt sich der nächste Leser auf eine Zusage, die der
  Aufruf nicht gibt.
* *„Die inneren Schleife läuft immer leer und gibt an die äußere zurück."* —
  **Widerlegt, und das ist der verbliebene Hängeweg.** Die Abbruchprüfungen
  stehen **nur in der äußeren** Schleife. Die innere
  (`while (!bFertig && ::PeekMessage(...))`, `:3790`) läuft, solange
  überhaupt Nachrichten da sind. Eine Nachricht, die sich selbst erneuert —
  klassisch ein `WM_PAINT`, dessen Behandler den Bereich nicht abräumt
  (siehe **1b**!) — hält die innere Schleife fest, und **die äußere kommt nie
  wieder zum Zug**. Dann hilft weder die 100-ms-Grenze noch die
  Tastenprüfung. Kosten der Absicherung: die drei Abbruchprüfungen **in die
  innere Schleife** ziehen oder die Zahl der Durchläufe deckeln.

### (b) Verschluckt sie Nachrichten? — **Ja, und eine davon ist teuer**

`::PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)` (`:3790`) entnimmt über **alle**
Fenster des Stranges. Der Code prüft `WM_LBUTTONUP`, `WM_RBUTTONDOWN`,
`VK_ESCAPE`, `WM_MOUSEMOVE` und schickt den Rest an
`TranslateMessage`/`DispatchMessage`.

* **`WM_QUIT` wird entnommen und weggeworfen.** `DispatchMessage(WM_QUIT)` tut
  nichts, und die Nachricht ist aus der Warteschlange verschwunden. Kommt sie
  während eines Ziehens (Alt+F4, Windows-Abmeldung, `PostQuitMessage` aus
  einem anderen Zweig), **beendet sich Eudora nicht mehr** — genau die
  Fehlerklasse, die dieses Projekt schon zweimal gekostet hat. Fix: eine
  Zeile, `if (msg.message == WM_QUIT) { ::PostQuitMessage((int) msg.wParam);
  bAbbruch = TRUE; bFertig = TRUE; break; }`.
* **`PreTranslateMessage` wird umgangen.** Für die Dauer des Ziehens gibt es
  keine Tastenkürzel und keine MFC-Kurzhinweisweitergabe. Beim Ziehen mit der
  Maus praktisch folgenlos; genannt der Vollständigkeit halber.
* **`msg.hwnd` wird bei `WM_MOUSEMOVE` nicht geprüft** (`:3810-3811`). Der
  Kommentar begründet das mit dem Mausfang — richtig für *neue* Nachrichten,
  aber Nachrichten, die **vor** `SetCapture` in die Warteschlange kamen,
  tragen ein anderes `hwnd` und damit ein anderes Koordinatensystem. Ein
  Sprung des Ziehbalkens um die Fensterversetzung, einmalig, beim Anfassen.
  Fix: `msg.hwnd == pWnd->GetSafeHwnd()` mitprüfen.

### (c) Was ich gesucht und *nicht* erwartet habe: Benutzung nach dem Freigeben

**Das ist der schwerste Befund dieses Reviews.**

`Track` arbeitet die ganze Zeit auf `this` — dem `Splitter`-Objekt — und
`StartTracking` (`OTShim.cpp:3584-3594`) benutzt denselben Zeiger **nach**
der Rückkehr für `OnSplitterMoved(pSplit, nDelta)`.

Während `Track` läuft, dispatcht die innere Schleife fremde Nachrichten. Jede
davon kann einen Anordnungsdurchlauf auslösen (ein Zeitgeber der Mailabholung,
ein `WM_SIZE` des Rahmens, das Ein-/Ausblenden der Reklameleiste). Der Weg ist
dann:

```
DispatchMessage → ... → CFrameWnd::RecalcLayout → Andockleiste WM_SIZE
   → SECDockBar::OnSize (OTShim.cpp:3966)
   → TrennbalkenNeuAnlegen (:3966)
       BeginRecycleSplitters()   -> m_bInUse = FALSE fuer ALLE       (:3404)
       ... AddSplitter nur, wenn nPos >= 0 und nFrei >= 2            (:4014)
       EndRecycleSplitters()     -> delete jedes !m_bInUse           (:3414)
```

Zwei Ausgänge, beide schlecht:

1. `AddSplitter` läuft: unser Objekt wird **wiederverwendet** —
   `m_rect`, `m_nPos`, `m_orientation` werden **unter der laufenden Schleife
   überschrieben** (`:3396-3400`). `Track` rechnet weiter mit dem alten
   `rectZieh` (lokale Kopie, überlebt), aber `OnSplitterMoved` greift danach
   über das **neue** `m_nPos` möglicherweise die **falsche Leiste**.
2. `AddSplitter` läuft **nicht** (keine sichtbare Leiste mehr, `nFrei < 2`):
   `EndRecycleSplitters` ruft `delete pSplitter` auf **genau das Objekt, in
   dessen Methode wir stehen**. Danach liest `Track` `m_orientation` und
   `m_rect` aus freigegebenem Speicher, und `StartTracking` ruft
   `OnSplitterMoved` auf einen toten Zeiger.

Das ist kein theoretischer Weg: `TrennbalkenNeuAnlegen` ist die *einzige*
Stelle, die Splitter anlegt, und sie hängt an `WM_SIZE`, das während des
Ziehens jederzeit kommen kann.

**Fix, klein und ausreichend:** ein `m_bTracking` am `Splitter`; `AddSplitter`
überspringt Objekte mit `m_bTracking`, `EndRecycleSplitters` löscht sie nicht.
Sauberer wäre, in `StartTracking` alles Nötige (`m_nPos`, `m_orientation`) vor
`Track` in lokale Variablen zu kopieren und `OnSplitterMoved` diese Werte statt
des Zeigers zu geben.

### (d) Der Ziehbalken ist unsichtbar, sobald man nach rechts zieht

`rectZieh` wird in `DrawTrackerRect` (`:3704-3721`) über
`pWndClipTo->ScreenToClient()` in den **Clientbereich der Andockleiste**
zurückgerechnet und auf deren DC gemalt (`pZeichenfenster = pWndClipTo = this`,
`:3742-3744`). Die Andockleiste ist heute **180 Pixel** breit; `m_nMax` erlaubt
aber bis `Rahmen.right - 200` (`:3561`). **Alles jenseits der Andockleiste wird
weggeschnitten** — die Rückmeldung verschwindet genau in der Richtung, in die
Gregor ziehen will. MFC macht es deshalb anders:
`CDockContext` holt sich einen DC des Rahmens mit
`DCX_WINDOW|DCX_CACHE|DCX_LOCKWINDOWUPDATE`. **Empfehlung: auf den
Andockrahmen zeichnen, nicht auf die Andockleiste.**

**Urteil 7: Behauptung „kann nicht mehr hängen" hält für den Weg von E-51,
aber nicht allgemein. Vier neue Befunde: (a) innere Schleife ohne Abbruch,
(b) `WM_QUIT` verschluckt, (c) Benutzung nach Freigabe, (d) unsichtbarer
Ziehbalken.**

---

## 8. `OnSplitterMoved` — ist `SetBarInfo` der richtige Weg?

`OTShim.cpp:3611-3668`, über `SECControlBar::SetBarInfo` (`:2105-2132`) nach
`CControlBar::SetBarInfo` (`src/mfc/dockstat.cpp:584-615`).

**Was `CControlBar::SetBarInfo` sonst noch tut** — vollständig aufgeschlagen,
nicht überflogen:

| Zeile | Anweisung | Wirkung hier |
|---|---|---|
| `587-591` | `if (IsDockBar()) → CDockBar::SetBarInfo` | greift nicht, `pBar` ist eine Leiste |
| `598` | `m_nMRUWidth = pInfo->m_nMRUWidth` | unverändert (kam gerade aus `GetBarInfo`) |
| `599` | `CalcDynamicLayout(0, LM_HORZ\|LM_MRUWIDTH\|LM_COMMIT)` | **nachgerechnet, harmlos:** `SECControlBar::CalcDynamicLayout` (`OTShim.cpp:1944-1967`) fällt bei `nLength == 0` und ohne `LM_*DOCK` auf `CalcFixedLayout(FALSE, TRUE)` durch — eine **reine Abfrage** ohne Seiteneffekt. Der Rückgabewert wird verworfen |
| `601-610` | `m_pDockContext->m_uMRUDockID` usw. | Werte kamen unverändert aus `GetBarInfo` |
| `613-614` | **`SetWindowPos(NULL, m_pointPos.x, m_pointPos.y, 0,0, SWP_NOSIZE\|SWP_NOACTIVATE\|SWP_NOZORDER \| (m_bVisible ? SWP_SHOWWINDOW : SWP_HIDEWINDOW))`** | **die einzige echte Nebenwirkung** |

Zu Zeile 613/614 im Einzelnen:

* **Andocken/Abdocken: nein.** Es gibt kein `FloatControlBar`, kein
  `DockControlBar`, kein Umhängen von `m_pDockBar`. Die Leiste bleibt, wo sie
  ist.
* **Bewegen: nein, in der Praxis.** `m_pointPos` stammt aus
  `CControlBar::GetBarInfo` (`dockstat.cpp:564-569`) und ist die
  **Clientkoordinate innerhalb der Andockleiste** — dasselbe Bezugssystem, in
  dem `SetWindowPos` sie wieder setzt. Zwischen `GetBarInfo` und `SetBarInfo`
  liegt in `OnSplitterMoved` nichts, was sie ändert. Der Aufruf verschiebt
  also um null.
* **Sichtbarkeit verlieren: theoretisch ja.** `pInfo->m_bVisible = IsVisible()`
  (`dockstat.cpp:561`), und `IsVisible` berücksichtigt die verzögerten
  Zustände `delayHide`/`delayShow`. Steckte die Leiste in `delayHide`, würde
  `SetBarInfo` sie mit `SWP_HIDEWINDOW` **wirklich** verbergen. Erreichbar ist
  das nur **während** eines Anordnungsdurchlaufs; `OnSplitterMoved` läuft aus
  einer Mausbotschaft heraus, also außerhalb. **Kein akutes Loch, aber es ist
  ein Weg, der nur durch den Aufrufzeitpunkt zu ist** — und nach Befund 7c
  können während `Track` sehr wohl Anordnungsdurchläufe stattfinden.
* Ein weiterer Nebenpunkt: `SetBarInfo` löst mit `SWP_SHOWWINDOW` ein
  `WM_WINDOWPOSCHANGED` aus, obwohl sich nichts ändert — ein überflüssiger
  Neuzeichenanstoß vor dem ohnehin folgenden `RecalcLayout` +
  `RedrawWindow`. Kosmetisch.

**Der einfachere Weg wäre, `m_szDockVert.cx` direkt zu setzen** — geht nicht,
das Feld ist in `SECControlBar` geschützt und `SECDockBar` ist kein `friend`.
Ein `SetDockSize(int, int)` an `SECControlBar` wäre drei Zeilen und spart die
ganze `SetBarInfo`-Maschinerie.

**Urteil 8: Behauptung hält. `SetBarInfo` ist zu schwer, aber nicht falsch;
weder Andocken noch Abdocken noch Sichtbarkeitsverlust im heutigen
Aufrufweg.**

---

# Neue Befunde, die nicht in den acht Behauptungen standen

## N-1 — `IsTabLabelTruncated` legt eine `CPaintDC` **außerhalb** von `WM_PAINT` an

`workbook.cpp:1528-1530`:

```
BOOL QCWorkbook::IsTabLabelTruncated(SECWorksheet* pSheet)
{
    CPaintDC dc(this);      // device context for painting
```

Aufgerufen wird sie **nur** aus `QCWorkbook::OnNotify` (`:1636`), also aus der
`TTN_NEEDTEXT`-Behandlung des Kurzhinweisfensters — mitten in einer
Mausbewegung, **nicht** in einem `WM_PAINT`.

`CPaintDC` ruft `::BeginPaint` (`src/mfc/wingdi.cpp:1052`). `BeginPaint`
**räumt den ungültigen Bereich des Fensters ab.** Steht zu diesem Zeitpunkt
ein Neuzeichnen des Streifens aus — etwa das gerade von
`StreifenAuffrischen`, `QCUpdateTab` oder `QCWorksheet::OnMDIActivate`
angemeldete —, ist es **weg**, und es kommt kein `WM_PAINT`.

Die Kette dorthin ist geschlossen und läuft bei **jeder** Mausbewegung über
dem Rahmen:

```
WM_MOUSEMOVE → QCWorkbook::WindowProc (:1065)  [nur wenn m_bWorkbookMode]
   → TTM_RELAYEVENT ans Kurzhinweisfenster (:1078)
   → TTN_NEEDTEXT → QCWorkbook::OnNotify (:1613)  [nur wenn m_bWorkbookMode]
   → IsTabLabelTruncated → CPaintDC → BeginPaint  → Auffrischung verschluckt
```

Beide Wächter fragen `m_bWorkbookMode`. **Solange der Registerkartenbetrieb
aus war, war diese Stelle unerreichbar.** Sie ist eine **Regression aus A-3**
und passt exakt auf Gregors Klasse von Meldungen („hier ist kein refresh
drin"). Fix: `CClientDC` statt `CPaintDC` — eine Zeile, und die Funktion
braucht ohnehin nur die Schriftmetrik.

## N-2 — Ein unsichtbares Logo startet den Webbrowser

`SECWorkbook::OnPaint` ruft `OnDrawBorder` **nicht** auf. Damit wird das
QUALCOMM-Logo nie gezeichnet (`QCWorkbook::OnDrawBorder`, `workbook.cpp:1505-1520`;
`CMainFrame::OnDrawBorder`, `mainfrm.cpp:6066-6108`). Nachgemessen: **niemand
im Bestand ruft `OnDrawBorder`** — im Original tat das die
Stingray-Rahmenklasse.

Die **Trefferprüfung** dazu läuft aber weiter:

* `QCWorkbook::OnLButtonDown` → `CalcLogoTopLeft(NULL, &point)` (`:1132`) →
  `LogoClicked()` → `LaunchURL(CRString(IDS_MAIN_WEB_URL))`.
* `CalcLogoTopLeft` (`:1411-1467`) prüft **nur `pIntersectPoint->x >=
  nLeftEdge`** — **keine y-Prüfung**.
* `nLeftEdge = m_pWBClient.right - m_nLogoBitmapWidth - 3`. Nachgemessen aus
  `Eudora71/Eudora/res/icons/qclogo.bmp` (BMP-Kopf, Offset 18): **111 x 23**.
  Der Bereich ist also die **rechten 114 Pixel** des Rahmenclientbereichs.

**Folge: ein Klick in die rechten 114 Pixel des Registerkartenstreifens (oder
jede andere freie Rahmenfläche) öffnet ungefragt den Webbrowser.** Der
`m_bWorkbookMode`-Wächter in `OnLButtonDown` (`:1101`) hat das bis 1.0.24
verhindert. **Regression aus A-3.**

Zwei mögliche Behebungen: `OnDrawBorder(&dc)` in `SECWorkbook::OnPaint`
aufnehmen (dann ist das Logo wenigstens sichtbar, und nebenbei greift die
Selbstheilung `if (m_lastVisCount != CountVisibleTabs()) ResetTaskBar()` in
`workbook.cpp:1511` wieder), **oder** den Logo-Zweig in `OnLButtonDown`
stilllegen. Das eine ist Originaltreue, das andere ist weniger Risiko.

Dieselbe fehlende y-Prüfung macht übrigens auch `QCWorkbook::OnSetCursor`
(`:1476-1494`) zum Störer: rechts im Rahmen erscheint der
„Browser-starten"-Zeiger, ohne dass dort etwas ist. Das gab es allerdings
schon vor A-3, weil `OnSetCursor` **nicht** durch `m_bWorkbookMode` gedeckt
ist.

## N-3 — Das Ankreuzfeld „Show MDI task bar" schaltet den Streifen nicht sauber ab

A-3-Prüfpunkt 5 aus `ZIEL.md` verlangt: „Das Ankreuzfeld schaltet ihn aus und
wieder ein."

* `settings.cpp:1055-1061` → `CMainFrame::ShowMDITaskBar(New)`.
* `QCWorkbook::ShowMDITaskBar` (`workbook.cpp:720-736`) ruft
  `SetWorkbookMode(bShow)` und macht **`RecalcLayout()` und `ResetTaskBar()`
  nur im `if (m_bWorkbookMode)`-Zweig**.
* `SECWorkbook::SetWorkbookMode` (`OTShim.cpp:1290-1307`) setzt beim Abschalten
  die Ränder auf 0 und ruft `Invalidate(FALSE)` — **ohne Löschen** und **ohne
  Anordnungsdurchlauf**.
* `SECWorkbookClient::SetMargins` (`OTShim.cpp:739-745`) trägt den Wert nur
  ein; der Kommentar dort („Alle drei Aufrufstellen rufen danach selbst
  RecalcLayout") ist für den **Abschaltweg falsch**.

**Folge: der MDI-Bereich behält seine verkleinerte Größe, und die alten Karten
bleiben stehen**, bis irgendetwas anderes einen Anordnungsdurchlauf auslöst.
Fix: in `SetWorkbookMode` `Invalidate(TRUE)` statt `FALSE`, und in
`ShowMDITaskBar` das `RecalcLayout()` aus dem `if` herausziehen — letzteres
wäre allerdings eine Änderung an Eudoras eigenem Code; die saubere Stelle ist
`SetWorkbookMode` selbst.

## N-4 — Neun Kommentarblöcke behaupten das Gegenteil des Codes

Nicht kosmetisch: das sind die Sätze, die der nächste Leser als Bestandsaufnahme
nimmt, und keiner davon steht in irgendeinem Diff (Lehre
„Review sieht nur den Diff"). Alle im Prüfstand `40ec935` nachgeschlagen:

| Fundstelle | Behauptet | Tatsächlich |
|---|---|---|
| `OTShim.h:702-706` | „STUFE 2 OFFEN: die Splitter selbst. `AddSplitter` wird nie aufgerufen … `CalcTrackingLimits` … wird nie erreicht" | wird aufgerufen (`OTShim.cpp:4037-4051`), wird erreicht (`:3590`) |
| `OTShim.h:1459` | `m_bWorkbookMode // bleibt in dieser Stufe fest FALSE` | wird von `SetWorkbookMode` gesetzt |
| `OTShim.cpp:2396-2398` | „Weil in dieser Stufe nie ein Splitter angelegt wird, hat der Wert keine Wirkung" | `Splitter::cx` bestimmt Zuschlag und Mindestbreiten |
| `OTShim.cpp:3371-3379` | „nichts im Shim ruft `AddSplitter` … `m_arrSplitters` … bleiben leer, `HitTest` liefert NULL" | falsch, siehe oben |
| `OTShim.cpp:3874-3875` | „Weil es keine Splitter gibt, fällt die Fassung immer durch" | `OnSetCursor` greift jetzt |
| `OTShim.cpp:806-808` | „VORGABE: Registerkartenbetrieb bleibt aus. Ohne ihn läuft der gesamte Zeichencode nie an" | nur noch der Ausgangswert des Konstruktors |
| `OTShim.cpp:884-888` | Zeichenwerkzeuge „werden in dieser Stufe nie benutzt" | werden bei jedem Neuzeichnen benutzt |
| `OTShim.cpp:1205-1206` | `GetTabRgn` „liefert also derzeit ein leeres Gebiet" | liefert jetzt ein echtes |
| `OTShim.cpp:739-745` | `SetMargins`: „Alle drei Aufrufstellen rufen danach selbst `RecalcLayout`" | der Abschaltweg nicht, siehe **N-3** |

Dazu zweimal derselbe Kommentarblock hintereinander in `CalcFixedLayout`
(`OTShim.cpp:2922-2931` und `:2941-2953`, beide beginnen „A-4: Platz fuer den
Trennbalken.") — beim Zusammenführen doppelt geblieben. Und in
`OTShimStreifenRect` (`:1069-1070`) wird `rectClient` geholt und nie benutzt;
toter Rest der verworfenen `rectClient.left`-Fassung.

---

## N-5 — E-53 steht in keiner Befundtabelle

`d751d23` behebt E-53 („schoenheitsfehler beim schliessen, da bleibt ein strich
uebrig") im Quelltext und beschreibt es ausführlich in der **Commit-Nachricht**.
Nachgezählt in `BEFUNDE.md` auf demselben Stand: **`E-53` kommt dort nicht ein
einziges Mal vor** (`grep -c E-53 BEFUNDE.md` → 0), und `tools/doku-pruefen.pl`
zählt 51 Kennungen im Verzeichnis, also unverändert. Damit steht die Ursache
nur in der Versionsgeschichte, nicht dort, wo der nächste Leser sie sucht —
gegen die Lehre „Doku bei jedem Commit mitziehen". Nachzutragen sind die
Verzeichniszeile in `BEFUNDE.md` und der Vermerk in `ZIEL.md` bei A-3.

---

# Urteilstabelle

| Nr. | Behauptung | Urteil |
|---|---|---|
| 1a | Legt die Basis `SECMDIFrameWnd::OnPaint` ebenfalls eine `CPaintDC` an? | **widerlegt** — keine `OnPaint` in `SECMDIFrameWnd`; `CWnd::OnPaint` nur bei `m_pCtrlCont != NULL`; genau ein `ON_WM_PAINT` in der Kette (`mainfrm.cpp:525`) |
| 1b | Kann `OnDrawTab` im Release werfen? | **widerlegt** für alle GDI-Aufrufe (MFC-Quellen einzeln aufgeschlagen); **Restweg** `CPaintDC` → `AfxThrowResourceException` → `WM_PAINT`-Dauerschleife |
| 2 | Punktreihenfolge passt zu jedem Leser | **bestätigt** für alle sechs Stellen; zusätzlich belegt durch `m_cxFold = m_cxActive = m_cyActive = 0` (`workbook.cpp:661`) |
| 2a | Textbreite kann negativ werden | **neues Loch**, kosmetisch (ab ~30 Fenstern) |
| 2b | `m_cxTab` außerhalb `OnPaint` veraltet | **neues Loch** — Treffertest und Zeichnung laufen kurzzeitig auseinander |
| 3 | `QCGetTaskBarRect` nur zum Ungültigerklären, kein Auseinanderlaufen | **bestätigt** — zwei Benutzer, beide unschädlich; Ablegetest geht über `TabHitTest`, nicht über `QCGetTaskBarRect` |
| 4a | Zustandsänderung im Zeichnen vertretbar | **bestätigt** — `SetSelected` ist eine Zuweisung, kein Wiedereintritt |
| 4b | Fall, in dem die Marke ohne aktiven Rahmen gebraucht wird | **widerlegt** — `MDIActivate` folgt synchron; `QCWorksheet::OnMDIActivate` (`:133-150`) frischt beide Karten auf |
| 5a | Schwebende Leiste | **bestätigt** — Kennung `AFX_IDW_DOCKBAR_FLOAT`, doppelt gedeckt |
| 5b | Mehrere Leisten in einer Zeile | **Loch** — bei zwei Zeilen überdeckt der Balken die ganze zweite Spalte |
| 5c | `QCDockBar::CalcTrackingLimits` reicht für die Reklameleiste | **bestätigt** (Kette über `DEBUG_NEW QCDockBar`, `mainfrm.cpp:2191`, nachgemessen), verschärft aber nur Grenzen |
| 5d | Zuschlag trifft alle vier Andockleisten | **neues Loch** — 8 Pixel leerer Streifen oben und unten, Balken an der Werkzeugleiste |
| 6a | `WM_SIZE` kommt trotz `DeferWindowPos` | **bestätigt und belegt** — `CDockBar::CalcFixedLayout` schließt sein eigenes `hDWP` (`bardock.cpp:385/537`) vor dem des Rahmens |
| 6b | `OnSize` auch bei Änderung nur der Leiste | **widerlegt** — `AfxRepositionWindow` kehrt bei `EqualRect` zurück (`wincore.cpp:3292`) |
| 7a | Ziehschleife kann nicht mehr hängen | **halb** — Weg von E-51 zu, aber die innere `PeekMessage`-Schleife hat **keine** Abbruchprüfung |
| 7a' | `GetKeyState` liefert die physische Tastenlage | **widerlegt** — synchronisierte Lage; Kommentar `:3784` falsch, praktisch folgenlos |
| 7b | Schleife kann Nachrichten verschlucken | **bestätigt** — **`WM_QUIT` geht verloren** (Eudora ließe sich nicht mehr beenden); `PreTranslateMessage` umgangen; `msg.hwnd` ungeprüft |
| 7c | — (nicht behauptet) | **schwerster Befund: Benutzung nach dem Freigeben.** `TrennbalkenNeuAnlegen` kann den laufenden `Splitter` während `Track` recyceln oder `delete`n |
| 7d | — (nicht behauptet) | Ziehbalken ist jenseits der Andockleistenbreite **unsichtbar** — genau in Gregors Zugrichtung |
| 8 | `SetBarInfo` richtig; kein An-/Abdocken, kein Sichtbarkeitsverlust | **bestätigt** — einzige Nebenwirkung `SetWindowPos` auf dieselbe Stelle (`dockstat.cpp:613`); `CalcDynamicLayout(0, LM_HORZ\|…)` ist bei `SECControlBar` eine reine Abfrage |
| N-1 | — | **Regression aus A-3:** `IsTabLabelTruncated` legt `CPaintDC` außerhalb `WM_PAINT` an und verschluckt Auffrischungen |
| N-2 | — | **Regression aus A-3:** unsichtbares 111x23-Logo startet bei jedem Klick in die rechten 114 Pixel den Webbrowser |
| N-3 | — | **A-3-Prüfpunkt 5 nicht erfüllt:** Abschalten über die Einstellungen zieht keinen Anordnungsdurchlauf nach |
| N-4 | — | neun Kommentarblöcke behaupten das Gegenteil des Codes; ein Block doppelt; `rectClient` tot |
| N-5 | — | `E-53` ist im Quelltext behoben, steht aber **in keiner Befundtabelle** (`grep -c E-53 BEFUNDE.md` → 0) |

**Rangfolge der Behebungen, nach Gewicht:**

1. **7c** — `m_bTracking` am `Splitter`, damit `TrennbalkenNeuAnlegen` das
   laufende Objekt nicht freigibt. Ohne das ist A-4 ein Absturzkandidat.
2. **7b** — `WM_QUIT` wiedereinstellen. Eine Zeile, verhindert einen
   nicht beendbaren Prozess.
3. **N-2** — Logoklick stilllegen oder `OnDrawBorder` aufnehmen. Der Anwender
   bekommt heute ungefragt einen Browser.
4. **N-1** — `CClientDC` statt `CPaintDC` in `IsTabLabelTruncated`. Eine Zeile,
   und eine ganze Klasse von „kein refresh"-Meldungen fällt weg.
5. **7a** — Abbruchprüfungen in die innere Schleife.
6. **5d** — Zuschlag und Balken auf LINKS/RECHTS beschränken.
7. **N-3** — `Invalidate(TRUE)` und Anordnungsdurchlauf beim Abschalten.
8. **7d** — Ziehbalken auf den Rahmen zeichnen statt auf die Andockleiste.
9. **6b/5b** — `TrennbalkenNeuAnlegen` auch bei `OnBarHideShow`; `nFrei` deckeln.
10. **2b** — `m_cxTab` in `GetTabPts` nachziehen.
11. **N-4** — die neun Kommentarblöcke berichtigen.

---

# Was ich nicht entscheiden konnte

1. **Die „4 Pixel, die MFC selbst verbraucht"** (E-49, `ZIEL.md`). Aus der
   MFC-Quelle nicht nachvollziehbar: `CDockBar` setzt seine vier Randbreiten im
   Konstruktor auf 0 (`bardock.cpp:41`), und wo genau die vier Pixel bleiben,
   habe ich nicht gefunden. **Es ist aber gleichgültig**, weil
   `TrennbalkenNeuAnlegen` den freien Streifen **nachmisst** statt ihn zu
   rechnen — der Entwurf ist an dieser Stelle richtig unabhängig von der Zahl.
   Ich kann die Zahl weder bestätigen noch widerlegen.
2. **Die Zahlen aus den Messversuchen** (Andockleiste 176/180/187/188,
   freier Streifen 7/8, Streifen 127 Pixel). Alle stammen vom laufenden
   Programm; ohne Bauen und Starten — beides ausdrücklich untersagt — kann ich
   sie nicht nachmessen. Ich habe nur geprüft, ob der Code zu ihnen passt: er
   passt.
3. **Ob die innere `PeekMessage`-Schleife in der Praxis je festhängt**
   (Punkt 7a). Der Weg ist strukturell offen; ob es eine Nachricht gibt, die
   sich in Eudora tatsächlich selbst erneuert, ist ohne Laufzeitmessung nicht
   zu sagen. Ich habe keine gefunden, aber der Bestand ist zu groß, um das
   auszuschließen.
4. **Ob `SWM_MODE_ADWARE` in der ausgelieferten Fassung überhaupt eintritt.**
   `GetSharewareMode()` habe ich nicht bis zur Quelle verfolgt. Trifft es nicht
   zu, ist `QCDockBar::CalcTrackingLimits` (`DockBar.cpp:149`) toter Code, und
   Punkt 5c wäre gegenstandslos statt bestätigt.
5. **Die Parameterreihenfolge von `SECWorkbookClient::SetMargins`.** Die
   Signatur ist `(left, right, top, bottom)`, zugewiesen wird mit
   `SetRect(left, top, right, bottom)` — die Zuordnung vertauscht also `right`
   und `top`. Beide Aufrufstellen (`OTShim.cpp:1298`, `workbook.cpp:727`)
   übergeben nur Nullen plus einen Wert an letzter Stelle, der Unterschied ist
   heute **nicht messbar**. Ob die Reihenfolge des Originals so war, kann ich
   ohne die Stingray-Kopfdatei nicht sagen.
6. **Wieviele Fenster Gregor tatsächlich offen hat.** Loch 2a (negative
   Textbreite) hängt an der Kartenzahl; ob das je erreicht wird, ist eine
   Nutzungsfrage, keine Codefrage.
