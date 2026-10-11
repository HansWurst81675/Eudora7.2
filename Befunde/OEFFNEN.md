# E-28 — Doppelklick öffnet die Nachricht nicht; Suchtreffer nicht anklickbar

**Agent:** OEFFNEN · **Zweig:** `wt/oeffnen` · **Datum:** 06.09.2026 ·
**Fassung beim Auftreten:** 7.2.0.10 / 7.2.0.12

Gregors Fehlerliste:

> - wenn ich suche, läßt sich die mail nicht anklicken
> - doppelklick öffnet nicht die mail im großen

---

## 1. Haben beide dasselbe Problem? — Ja, ab `CSummary::Display()`

**Gemessen** (durch Lesen des Quelltextes, jede Stelle nachvollziehbar):

Die beiden Wege sind bis zum Schluss **verschieden** und treffen sich erst
ganz am Ende:

| Schritt | Postfachliste | Suchtrefferliste |
|---|---|---|
| Steuerelement | `CTocListBox` (Listenfeld, `LBS_OWNERDRAWFIXED`, `IDD_TOC` in `EudoraRes.rc:1645`) | `CListCtrlEx` (`IDC_SEARCHWND_RESULTS_LIST`) |
| Abfang | `CTocListBox::OnLButtonDblClk` (`tocview.cpp:1690`), eingetragen in `BEGIN_MESSAGE_MAP` (`tocview.cpp:383`) | `CListCtrlEx::OnLButtonDblClk` (`ListCtrlEx.cpp:1137`), eingetragen (`ListCtrlEx.cpp:53`) |
| Zuordnung Zeile → Nachricht | `GetItemDataPtr(i)` (Zeigerspalte des Listenfelds) | `HitTest` + `GetItemData(idx)` |
| Weitergabe | direkter Aufruf `CTocView::OpenMessages()` (`tocview.cpp:4661`) | registrierte Botschaft `msgListCtrlEx_LBtnDblClk` an den Besitzer → `CSearchView::OnMsgListDblClk` (`SearchView.cpp:4177`) → `OpenMsg` (`SearchView.cpp:2932`) |
| **gemeinsamer Endpunkt** | **`CSummary::Display()` (`summary.cpp:794`)** | **`CSummary::Display()`** |

`Display()` führt weiter zu `NewChildFrame(ReadMessageTemplate, pMessageDoc)`
(`summary.cpp:850` → `eudora.cpp:2182`). Alles davor ist bei beiden
verschieden, alles ab `Display()` ist **dieselbe** Funktion.

Die beiden Verdächtigungen aus der Aufgabenstellung sind **entkräftet**:

* Die Postfachliste ist **kein** virtuelles Listenfeld (`LVS_OWNERDATA`
  kommt in `Eudora71/Eudora/` nirgends vor); es ist ein gewöhnliches
  `CListBox` mit `LBS_EXTENDEDSEL`, `GetSelCount`/`GetSel` liefern also
  gültige Werte, nicht `LB_ERR`.
* `tocview.cpp` und `SearchView.cpp` sind gegenüber den Originalquellen
  (`git diff 567a5d8 HEAD`) **unverändert**. Der Fehler liegt nicht in der
  Trefferzuordnung, sondern hinter ihr.

---

## 2. Der Beleg: Eudoras eigenes Absturzprotokoll

`C:\Users\Gregor\Eudora72-1.0.12-release\Mailverzeichnis\Exception.log`,
06.09.2026 00:32:43, Fassung 7.2.0.12:

```
Eudora.exe caused an EXCEPTION_ACCESS_VIOLATION in module
<UNKNOWN> at 0023:414E3345
```

`<UNKNOWN>` heißt: der Befehlszeiger steht **außerhalb jedes geladenen
Moduls**. Das ist kein Zugriff über einen Nullzeiger, sondern ein **Sprung
über einen kaputten Funktions- bzw. vtable-Zeiger**.

Der Aufrufstapel (innen nach außen, gekürzt; die Zahlen in Klammern sind die
von CrashFinder mitgeschriebenen Stapelwörter):

```
00894B53   Eudora.exe          <- hier stand der indirekte Aufruf
008962D7   Eudora.exe
6FB9A3E6   mfc140.dll
6FB99B6D   mfc140.dll  (0x0000C23F ...)   <- Botschaftsnummer: registrierte Botschaft
6FB97E24 / 6FB98074 / 6FA77334  mfc140.dll (WindowProc-Kette)
773A4D4D   USER32.dll  SendMessageA()+0077
007F1CDB   Eudora.exe          <- der Aufrufer von SendMessage
6FB9A140   mfc140.dll
6FB99B6D   mfc140.dll  (0x00000203 ...)   <- 0x203 = WM_LBUTTONDBLCLK
...        DispatchMessageW
```

Das ist Zeile für Zeile der Weg
`WM_LBUTTONDBLCLK` → `CListCtrlEx::OnLButtonDblClk` →
`pOwner->SendMessage(msgListCtrlEx_LBtnDblClk, …)` (`ListCtrlEx.cpp:1159`;
registrierte Botschaften liegen in `0xC000..0xFFFF`, hier `0xC23F`) →
`CSearchView::OnMsgListDblClk` → ein weiterer Rahmen → Sprung ins Nichts.

Zwei weitere Messungen aus demselben Verzeichnis stützen das:

* `Mailverzeichnis\eudora.log` endet mit
  `Finding Messages` / `Clearing results…` / `Searching…` /
  `Displaying Search Results…` / `Searching…` — die **letzte** Handlung vor
  dem Abbruch war also eine Suche mit angezeigter Trefferliste.
* `ExceptionHandler.cpp:321` liefert `EXCEPTION_CONTINUE_SEARCH`. Eudora
  schreibt das Protokoll und **überlässt den Prozess dann Windows** — es gibt
  keinen Dialog, das Fenster ist einfach weg. Von außen sieht das aus wie
  „die Mail lässt sich nicht anklicken".

---

## 3. Ursache

`Eudora71/Eudora/msgframe.cpp`, Stand vor der Änderung.

`CMessageFrame::ActivateFrame` trägt den Rückzeiger **bedingungslos** ein
(Zeile 57):

```cpp
	if (Sum)
	{
		Sum->m_FrameWnd = this;
```

`CMessageFrame::OnDestroy` löschte ihn **nur unter einer Bedingung**
(Zeilen 158-181):

```cpp
	if (m_InitialSize != wp.rcNormalPosition)      // <-- nur wenn verschoben/größer
	{
			if(Sum != NULL)
			{
				Sum->SetSavedPos( CRect( wp.rcNormalPosition ) );
				…
				Sum->m_FrameWnd = NULL;            // <-- steht INNERHALB
			}
	}
```

Der Kommentar an dieser Stelle verrät, wie es dazu kam: die Zuweisung wurde
aus `CMessageDoc::PreCloseFrame()` hierher **verschoben**, weil sie dort
Abstürze beim Beenden verursachte — und landete dabei innerhalb des
falschen `if`. `PreCloseFrame` (`msgdoc.cpp:167`) löscht den Zeiger zwar
weiterhin, wird aber nur von `CFrameWnd::OnClose` aufgerufen und nur dann,
wenn `GetActiveDocument()` in diesem Augenblick noch ein Dokument liefert.

Damit gilt: **wird ein Nachrichtenfenster geöffnet und geschlossen, ohne dass
es zwischendurch verschoben oder in der Größe geändert wurde, zeigt
`CSummary::m_FrameWnd` weiter auf den zerstörten Rahmen.**

Der nächste Öffnungsversuch landet in `CSummary::Display()`
(`summary.cpp:796`):

```cpp
	if (m_FrameWnd)
	{
		ASSERT_VALID(m_FrameWnd);          // im Release leer
		ASSERT_KINDOF(QCWorksheet, …);     // im Release leer
		if (m_FrameWnd->IsIconic())
			m_FrameWnd->MDIRestore();
		else
			m_FrameWnd->ActivateFrame();   // virtueller Aufruf
		return TRUE;                       // meldet Erfolg
	}
```

`ActivateFrame` ist virtuell. Der Aufruf geht über die vtable des
freigegebenen Objekts:

* Solange der Speicherblock noch die alten Bytes trägt, läuft der Aufruf
  formal durch, arbeitet aber auf einem toten `HWND` — `MDIActivate` auf ein
  ungültiges Fensterhandle tut nichts, `Display()` meldet trotzdem `TRUE`,
  und **es passiert nichts**. Genau Gregors Bild beim Doppelklick.
* Sobald der Block wiederverwendet wurde, steht an der vtable-Stelle etwas
  anderes — der Sprung geht an eine Adresse außerhalb jedes Moduls. Genau
  das steht im Exception.log (`0x414E3345`).

Dass ein und derselbe kaputte Zeiger einmal wirkungslos ist und einmal
abstürzt, erklärt auch, warum die beiden Symptome verschieden aussehen,
obwohl sie dieselbe Wurzel haben.

### Warum fiel das unter VC6 nicht auf?

**Vermutet, nicht gemessen:** `m_InitialSize` wird in `ActivateFrame` aus
`GetWindowPlacement` gefüllt, `OnDestroy` vergleicht denselben Wert erneut.
Unter den Fensterabmessungen und der MDI-Kaskade von Windows 9x/2000 wich
die Lage eines Nachrichtenfensters zwischen Aktivierung und Zerstörung
praktisch immer ab, die Bedingung war also fast immer wahr und der Zeiger
wurde faktisch immer gelöscht. Belegen lässt sich das ohne einen VC6-Bau
nicht. Unabhängig davon ist die Stelle in jeder Fassung falsch: ein
bedingungslos gesetzter Rückzeiger muss bedingungslos gelöscht werden.

---

## 4. Behebung

Alle Änderungen byte-erhaltend über `tools/ersetze-bereich.pl`.
CR-Zahl und Zahl der Bytes ≥ 0x80 vorher/nachher identisch
(`msgframe.cpp` 0/0, `msgframe.h` 0/0, `summary.cpp` 18/0,
`SearchView.cpp` 18/0).

| Datei | Was war | Was jetzt |
|---|---|---|
| `msgframe.cpp` (`OnDestroy`) | `Sum->m_FrameWnd = NULL;` stand innerhalb von `if (m_InitialSize != wp.rcNormalPosition)` | Die Größenabfrage umschließt nur noch `SetSavedPos`. Der Rückzeiger wird **immer** gelöscht, abgesichert mit `m_FrameWnd == this`, damit ein inzwischen anders belegter Eintrag stehen bleibt |
| `msgframe.h` / `msgframe.cpp` (`ActivateFrame`, Konstruktor) | `OnDestroy` fand die Zusammenfassung nur über `GetActiveDocument()`, das beim Fensterabbau NULL liefern kann — dann blieb der Zeiger auch dann stehen | neuer Member `CSummary* m_pSumBackPtr`, in `ActivateFrame` mitgeschrieben, in `OnDestroy` ausgewertet und geleert |
| `summary.cpp` (`CSummary::Display`) | `if (m_FrameWnd)` → sofort virtueller Aufruf | davor `if (m_FrameWnd && !::IsWindow(m_FrameWnd->GetSafeHwnd())) m_FrameWnd = NULL;` — ein stehengebliebener Eintrag wird verworfen und **ein neues Fenster gebaut**, statt auf einem toten Rahmen zu arbeiten. Zweite Schranke, nicht die Behebung selbst |
| `SearchView.cpp` (`CSearchView::OpenMsg`) | vier ungeprüfte Zeiger im Hervorhebungsblock: `GetFirstViewPosition()`-Ergebnis, `pView`, `view`, `bodyview`; `view->DoFindFirst(…)` und `bodyview->DoFindFirst(…)` sind virtuelle Aufrufe. `QCProtocol::QueryProtocol` gibt für jede nicht aufgeführte Kombination ausdrücklich NULL zurück (`QCProtocol.cpp:187`), und `CDocument::GetNextView` liest im Release über einen Nullknoten, wenn das Dokument keine Ansicht hat | jeweils geprüft, Fehlschlag bricht nur die Hervorhebung ab. Das Nachrichtenfenster ist zu diesem Zeitpunkt bereits geöffnet |

### Bauzustand

| Bau | Ergebnis |
|---|---|
| Release / Win32, `-t:Rebuild`, ohne `-m` | **0 Fehler**, `Eudora71\Bin\Release\Eudora.exe` neu geschrieben 06.09.2026 12:47 |

---

## 5. Was gemessen ist und was nicht

**Gemessen:**

* Beide Wege enden in `CSummary::Display()` — durch Lesen belegt, Zeile für
  Zeile in Abschnitt 1.
* Der Suchtreffer-Doppelklick ist **kein** stilles Nichtstun, sondern ein
  Zugriffsfehler mit Sprung außerhalb jedes Moduls; der Aufrufstapel im
  Exception.log passt Rahmen für Rahmen auf
  `CListCtrlEx::OnLButtonDblClk` → registrierte Botschaft →
  `CSearchView::OnMsgListDblClk`.
* `Sum->m_FrameWnd = NULL` stand nachweislich innerhalb der Größenabfrage,
  während `ActivateFrame` den Zeiger bedingungslos setzt. Das ist ein
  hängender Zeiger, unabhängig davon, wie oft er sich auswirkt.
* Bau mit 0 Fehlern.

**Nicht gemessen (und deshalb nicht behauptet):**

* Dass genau dieser hängende Zeiger *die* Ursache des protokollierten
  Absturzes ist. Die Adressen im Exception.log sind mangels Ladeadresse
  (ASLR, siehe E-26) keinem Funktionsnamen zuzuordnen; der Stapel belegt nur
  den Weg, nicht die Zeile. Erst ein Absturzprotokoll aus einem Bau **mit**
  E-26 (Modultabelle) und der zugehörigen `Eudora.map` nennt die Funktion.
* Ob damit *alle* Fälle behoben sind. Bleibt der Doppelklick nach dieser
  Änderung wirkungslos, liegt der nächste Verdacht bei
  `CReadMessageFrame::OnCreateClient` (`ReadMessageFrame.cpp:216`): die
  Funktion gibt `fRet` zurück, also das Ergebnis von
  `m_wndSplitter.Create(…)` aus Zeile 284, und wertet es dazwischen nirgends
  aus. Schlägt die Erzeugung der Ansicht im Teilfenster fehl, gibt
  `OnCreateClient` FALSE zurück, `CMDIChildWnd::LoadFrame` scheitert,
  `CDocTemplate::CreateNewFrame` liefert NULL — und `NewChildFrame` gibt
  NULL zurück, **ohne jede Meldung**. Das ergäbe dasselbe Bild.

## 6. Nebenbefunde (nicht angefasst)

* `Eudora71/Eudora/SearchView.cpp:2777`:
  `m_MsgResultArr = (CMsgResult *) malloc(MAX_LISTCOUNT * sizeof(CMsgResult))`
  — roher Speicher für Objekte mit `CString`-Membern, ohne Konstruktoraufruf.
  Heute folgenlos, weil `m_UseFastWay` im Konstruktor auf `false` gesetzt
  wird (`SearchView.cpp:502`); wird der Schalter je wieder eingeschaltet, ist
  das eine sichere Heap-Beschädigung.
* `Eudora71/Eudora/eudora.cpp:2182` `NewChildFrame`: `ASSERT_VALID(frame)` vor
  `if (frame)`. Im Debug-Bau bricht das ab, sobald ein Fenster nicht entsteht
  — im Release läuft es still weiter. Gehört zur Klasse „ASSERT an Stellen,
  die im Betrieb vorkommen" (E-15/E-19/E-21).
