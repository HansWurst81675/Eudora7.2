# PRUEFER-4 — Nachprüfung der Behauptungen vom 07.09.2026

| | |
|---|---|
| Datum | 07.09.2026 |
| Arbeitsbaum | `C:\Users\Gregor\Documents\github\Eudora7.2-wt-pruefer` |
| Zweig | `wt/pruefer` |
| Bezugscommit | `4dae638` (`4dae6381d9a22a36b9da09ecb2ccb1fadc4f1d15`), per `merge --ff-only origin/beenden-und-kontovorgaben` |
| Vergleichsstand | `003e8d8` (Zustand vor dem heutigen Einbau) |
| MFC-Quellen | `VC\Tools\MSVC\14.38.33130\atlmfc` (VS 2022 Professional) |
| Nicht getan | nicht gebaut, kein Programm gestartet, nur diese Datei geschrieben |

**Umfang:** 49 Dateien gelesen, davon 9 Projektdateien, 13 MFC-Quellen und die
Ressourcentabelle von `mfc140enu.dll`. 24 behauptete Zeilenangaben einzeln
nachgeschlagen.

---

## 1. E-37 — ist die Behebung richtig und vollständig?

> **Nachtrag 08.09.2026: dieses Urteil ist am laufenden Programm widerlegt.**
> Die Behebung hat sehr wohl Schaden angerichtet — der `PopulateView()`-Aufruf
> hat geworfen, die Ausnahme lief aus dem Befehlsbehandler heraus, und Gregor
> sah **„Encountered an improper argument"**: *„die meldung kommt, wenn ich eine
> persona gelöscht habe"*. Der Eintrag verschwand außerdem weiter nicht: *„sie
> verschwindet links nicht, bis ich eudora geschlossen habe"*. **E-37 steht
> wieder als nicht behoben**, der zweite Anlauf ist in 7.2.0.23 gebaut und
> unbestätigt. Der Abschnitt bleibt als Zeitdokument stehen — aber **nicht als
> Beleg zitieren**; genau das ist einmal passiert.

**Urteil: teilweise bestätigt.** Die Behebung wirkt und richtet keinen neuen
Schaden an. Zwei Aussagen der Behauptung sind aber falsch, und ein vorhandener
Mangel bleibt unbenannt.

### (a) Ist `PopulateView()` aufrufbar und tut es das Richtige?

**Behauptung:** aufrufbar, aber `protected` (`PersonalityView.h:58`); es leert
die Liste und füllt sie neu.

**Gemessen:**

* `PopulateView()` ist **`public`**, nicht `protected`. Die
  Zugriffsbezeichner in `PersonalityView.h` stehen in den Zeilen 41
  (`protected:`), 45 (`public:`), 48 (`public:`), 62, 86, 93, 100, 136.
  `BOOL PopulateView();` steht in Zeile 58 — der nächste Bezeichner davor ist
  Zeile 48 `public:`. Nur der Kommentarkopf in `PersonalityView.cpp:199` sagt
  „PopulateView [protected]"; er ist falsch. Für die Behebung ist das ohne
  Folge (der Aufruf käme auch bei `protected` aus der eigenen Klasse durch),
  aber die Begründung der Behauptung trifft nicht zu.
* Es leert die Liste wirklich: `PersonalityView.cpp:207-208`
  `CListCtrl& theCtrl = GetListCtrl(); theCtrl.DeleteAllItems();`
* Es füllt sie aus derselben Quelle, aus der `Remove()` gelöscht hat:
  Schleife über `g_Personalities.List()` (`PersonalityView.cpp:219-221`),
  und `List()` liest den Abschnitt `[Personality]` der `Eudora.ini`
  (`persona.cpp:626ff.`). Nach `Remove()` ist der Eintrag dort weg
  (`persona.cpp:546-568`), also erscheint er auch nicht wieder.

**Urteil (a): bestätigt in der Sache, widerlegt in der Begründung** —
`PopulateView` ist `public`.

### (b) Kann `PopulateView()` an dieser Stelle etwas kaputt machen?

**Behauptung:** es ruft `g_Personalities.SetCurrent()` in einer Schleife und
muss die aktuelle Persönlichkeit wiederherstellen; es läuft jetzt nach einem
`Remove`.

**Gemessen — Schritt für Schritt:**

1. `PopulateView` merkt sich die aktuelle Persönlichkeit in Zeile 214
   (`CString strCurrentPersona = g_Personalities.GetCurrent();`) und stellt sie
   in Zeile 259 wieder her (`g_Personalities.SetCurrent(strCurrentPersona);`).
   Auch der Abbruchweg bei `InsertItem < 0` stellt sie wieder her (Zeile 236).
   Die Auflage „BE SURE TO RESTORE" ist also **auf allen drei Wegen erfüllt**.
2. `CPersonality::Remove` (`persona.cpp:520-580`) rührt `m_Current`
   **nirgends** an. Wird die aktuelle Persönlichkeit gelöscht, zeigt
   `m_Current` danach auf einen Abschnitt, den es nicht mehr gibt.
3. `CPersonality::SetCurrent` (`persona.cpp:179-204`) prüft den Namen nicht —
   der Kommentar sagt es selbst: „we're trusting souls" — und liefert
   bedingungslos `TRUE`.
4. Folge: wenn die gelöschte Persönlichkeit die aktuelle war, stellt
   `PopulateView` den **gelöschten Namen** als aktuelle Persönlichkeit wieder
   her. Der Löschbefehl ist nur gegen `<Dominant>` gesperrt
   (`OnUpdateDeletePersonality`, `PersonalityView.cpp:1051-1078`) — die
   aktuelle Persönlichkeit darf man löschen.
5. **Aber:** dieser Zustand bestand schon **vor** der Behebung, weil `Remove`
   `m_Current` nie zurückgesetzt hat. `PopulateView` **erzeugt** ihn nicht, es
   trägt ihn nur weiter. Die Behebung macht es also nicht schlimmer.
6. Geprüfte Nebenwirkung, die ich für den ernstesten Kandidaten hielt:
   `SetCurrent` ruft beim Wechsel `SavePassInfo()`/`RestorePassInfo()`
   (`persona.cpp:191, 201`). Beide schreiben **nicht** in die INI: `SavePassInfo`
   (`persona.cpp:1073-1080`) setzt nur `m_Passwords[...]`, `RestorePassInfo`
   (`persona.cpp:1116-1129`) nur die globale `POPPassword`. Der Abschnitt der
   gelöschten Persönlichkeit wird also **nicht** wieder angelegt. **Diese
   Befürchtung ist widerlegt.**
7. Echte, harmlose Verhaltensänderung: `DeleteAllItems` verwirft die Markierung,
   und Zeile 254 setzt den Fokus auf den ersten Eintrag
   (`theCtrl.SetItemState(0, LVIS_FOCUSED, LVIS_FOCUSED)`). Nach dem Löschen ist
   also nichts mehr markiert; vorher blieben die übrigen Markierungen stehen.
   Unschädlich, weil der Löschbefehl über `OnUpdateDeletePersonality` an eine
   Markierung gebunden ist. Eine leere Liste kann nicht entstehen: `List()`
   führt `<Dominant>` immer zuerst (`persona.cpp:624`).

**Urteil (b): bestätigt** — `PopulateView` kann hier nichts kaputt machen.
**Zusatzbefund:** dass nach dem Löschen der aktuellen Persönlichkeit
`m_Current` auf einen gelöschten Abschnitt zeigt, ist ein echter, bislang
unbenannter Mangel in `CPersonality::Remove` — nicht durch diese Behebung
verursacht und durch sie auch nicht behoben.

### (c) Bleibt bei mehreren markierten Konten alles richtig?

**Gemessen:** ja.

* `GetSelectedPersonalities` (`PersonalityView.cpp:275-300`) kopiert die
  **Namen** in `strListPersonalities`, **bevor** die Schleife beginnt. Der
  Namensvorrat hängt danach nicht mehr an `theCtrl`.
* Die Schleife (`PersonalityView.cpp:940-1015`) nimmt je Durchlauf einen Namen
  mit `RemoveHead()`, ruft `FindItem` **neu** (Zeile 985) und löscht nur den
  gefundenen Index. Verschieben sich die Indizes durch `DeleteItem`, ist das
  ohne Folge, weil der nächste Durchlauf wieder über den Namen sucht.
* `PopulateView()` läuft **einmal** hinter der Schleife (Zeile 1022), unter
  `if (bNeuAufbauen)` — also nur, wenn mindestens ein `Remove` erfolgreich war.

**Urteil (c): bestätigt.**

### (d) Sind die drei Protokollzeilen korrekt gebaut?

**Gemessen:**

* `PutDebugLog` nimmt **keinen** Formatstring:
  `void PutDebugLog(DebugMaskType ID, LPCTSTR Buffer, int Length = -1)`
  (`Eudora71/QCUtils/public/inc/debug.h:86`, Rumpf in
  `Eudora71/QCUtils/src/debug.cpp:140-145`). Bestätigt.
* Alle drei Stellen sind richtig: zwei bauen den Text zuerst mit
  `CString::Format` (`PersonalityView.cpp:990-996` und `1002-1008`), die dritte
  übergibt ein festes Literal ohne Platzhalter (`1016-1017`). Kein Fall, in dem
  ein Formatstring an `PutDebugLog` durchgereicht wird.
* `%s` mit `(const char *) strName`: richtig. `CharacterSet` ist `MultiByte`
  (`Eudora.vcxproj:29,37`), `_T(...)` ist also `char`, und der ausdrückliche
  Cast ist die korrekte Form. `%d` mit `(int) theCtrl.GetItemCount()` ebenso
  (der Cast ist redundant, `GetItemCount` liefert schon `int`).
* `PutDebugLog` ist im **Release-Bau aktiv**: `debug.h:84` lautet
  `#ifdef TRUE //_DEBUG`, also gilt immer die exportierte Fassung.
* Die Deklaration erreicht die Datei: `PersonalityView.cpp` bindet `debug.h`
  nicht selbst ein, sondern über `stdafx.h:54` → `qcassert.h:39` → `debug.h`.
* **Wichtiger Zusatzbefund zur Maske.** `DEBUG_MASK_MISC` ist `0x8000`,
  `DEBUG_MASK_TOC_CORRUPT` ist `0x80` (`debug.h:36` und `:22`). `PutDebugLog`
  prüft `(DebugMask & ID) == 0`, ein ODER wirkt also als „schreibe, wenn eines
  der Bits gesetzt ist". Der Vorgabewert von `LogLevel` ist **25759 = 0x649F**
  (`EudoraRes.rc:8441`, `IDS_INI_DEBUG_LOG_LEVEL "LogLevel\n25759"`), und
  `0x649F & 0x8000 = 0`, aber `0x649F & 0x80 = 0x80`. Die Zeilen schreiben also
  **auch ohne jede `LogLevel`-Zeile** in der `Eudora.ini`. `tools/DEudora.ini`
  setzt `LogLevel` nicht.

**Urteil (d): bestätigt.**

---

## 2. Die Behauptung zu E-33 — trägt sie?

**Urteil: teilweise.** Der erste Halbsatz ist in der Sache richtig, nennt aber
eine Kennung, die es nicht gibt. Der zweite Halbsatz — die Folgerung aus
„Kreuz und Alt-F4" — ist **widerlegt**. Die Aussage über
`ProcessWndProcException` ist bestätigt.

### Ist „Encountered an improper argument" MFCs Text für `CInvalidArgException`?

**Gemessen** (Ressourcenverzeichnis von `C:\Windows\SysWOW64\mfc140enu.dll`
selbst geparst, `RT_STRING`, Block `0xF03`, Datenoffset 20160, 388 Bytes):

| Kennung | Index | Text |
|---|---|---|
| `0xF020` | 0 | „No error message is available." |
| `0xF021` | 1 | „Attempted an unsupported operation." |
| `0xF022` | 2 | „A required resource was unavailable." |
| `0xF023` | 3 | „Out of memory." |
| `0xF024` | 4 | „An unknown error has occurred." |
| **`0xF025`** | **5** | **„Encountered an improper argument."** |
| `0xF026`…`0xF02F` | 6…15 | leer |

* `0xF025` ist **`AFX_IDS_INVALID_ARG_EXCEPTION`** (`afxres.h:382`).
* **`AFX_IDP_INVALID_ARGUMENT` existiert nicht.** Der Bezeichner kommt in der
  gesamten `atlmfc`-Auslieferung (`include` und `src`) nicht ein Mal vor. Die
  Kennung ist im Kommentar `mainfrm.cpp:5378` und in `CHANGELOG.md:17` falsch
  genannt.
* Der einzige Nutzer von `AFX_IDS_INVALID_ARG_EXCEPTION` in MFC ist
  `CInvalidArgException _simpleInvalidArgException(FALSE, AFX_IDS_INVALID_ARG_EXCEPTION);`
  (`except.cpp:180`), und `AfxThrowInvalidArgException()` wirft genau dieses
  Objekt (`except.cpp:229-232`). Der Text steht also tatsächlich für
  `CInvalidArgException`.

### Kann den Text noch etwas anderes erzeugen?

* Innerhalb von MFC: nein. Kein anderer Aufrufer von `0xF025`, kein anderes
  `CSimpleException`-Objekt mit dieser Kennung.
* Grundsätzlich ja: jeder Code, der `AfxMessageBox(0xF025)` oder
  `AfxLoadString(0xF025)` ruft, zeigte denselben Text. In den Eudora-Quellen
  habe ich keine solche Stelle gefunden (Suche nach `0xF025`,
  `AFX_IDS_INVALID_ARG` — nicht erschöpfend).
* **Der Text benennt keine Stelle, nur eine Klasse.** `ENSURE`, `ENSURE_ARG`
  und `ENSURE_VALID` werfen alle dieselbe Ausnahme und sind **auch im
  Release-Bau wirksam** (`afx.h:379-388`:
  `ENSURE_THROW(cond, exception)` prüft `if (!(__afx_condVal)){exception;}`
  ohne `_DEBUG`-Klammer). Vorkommen allein in den Rahmen- und Leistenquellen:
  `winfrm.cpp` 35, `bardock.cpp` 18, `barcore.cpp` 9, `winmdi.cpp` 4. Dazu
  `CPtrArray::GetAt` und `::ElementAt` (`afxcoll.inl:201-205`, `212-216`).

### Gehen Kreuz und Alt-F4 wirklich durch dasselbe `CMainFrame::OnClose`?

**Diesen Halbsatz halte ich für widerlegt — jedenfalls als Beweisführung.**

* Kreuz und Alt-F4 haben einen gemeinsamen Abschnitt, den *File → Exit*
  **nicht** hat: `WM_SYSCOMMAND` mit `SC_CLOSE`. *File → Exit* kommt als
  `WM_COMMAND ID_APP_EXIT` bei `CEudoraApp::OnAppExit` an (`eudora.cpp:806`)
  und schickt von dort erst `WM_CLOSE`.
* Auf diesem gemeinsamen Abschnitt liegt ein eigener MFC-Behandler mit einer
  werfenden Prüfung: `CFrameWnd::OnSysCommand` (`winfrm.cpp:1112-1114`) beginnt
  mit `CFrameWnd* pFrameWnd = GetTopLevelFrame(); ENSURE_VALID(pFrameWnd);` —
  dieselbe Ausnahme, dieselbe Meldung, und zwar **vor** jedem `OnClose`.
  `CFrameWnd` hat `ON_WM_SYSCOMMAND()` in seiner Nachrichtentabelle
  (`winfrm.cpp:49`).
* Aus „Kreuz und Alt-F4 zeigen die Meldung" folgt daher nur, dass der
  `WM_COMMAND`-Behandler ausgeschlossen ist. Es folgt **nicht**, dass der Wurf
  in `CMainFrame::OnClose`/`CloseDown` liegt: der SysCommand-Weg bleibt als
  zweiter gemeinsamer Kandidat offen.
* **Vermutung, nicht gemessen:** dass `SC_CLOSE` über `DefWindowProc` zu
  `WM_CLOSE` führt, ist Verhalten von `user32.dll`; dafür liegt hier keine
  Quelle. Gemessen ist nur, dass MFC auf dem Weg dorthin einen eigenen
  Behandler mit `ENSURE_VALID` hat.
* **Auslegungsfrage, keine Messung:** Gregors Satz in `CHANGELOG.md:17` lautet
  „weder alt+F4, noch x rechts oben funktionieren. da kommt **wieder** die
  meldung". Wenn „wieder" heißt, dass sie auch bei *File → Exit* kam, dann ist
  der gemeinsame Abschnitt tatsächlich `WM_CLOSE` und die Folgerung trägt. Das
  steht so aber nirgends belegt, und der Satz im Prüfstand begründet es anders
  (nämlich mit Kreuz und Alt-F4 allein) — und diese Begründung trägt nicht.

### Liefert `CWinApp::ProcessWndProcException` bei `CInvalidArgException` 0?

**Gemessen: ja, bestätigt.** `appcore.cpp:1009-1039`:

1. `switch (pMsg->message)` behandelt nur `WM_CREATE` und `WM_PAINT` gesondert
   (Zeilen 1013-1019). `WM_CLOSE` fällt durch.
2. `UINT nIDP = AFX_IDP_INTERNAL_FAILURE; LRESULT lResult = 0;` (1022-1023).
3. Der `WM_COMMAND`-Zweig, der `lResult` auf `TRUE` setzen würde, greift nicht
   (1024-1029).
4. `CInvalidArgException` ist weder `CMemoryException` noch `CUserException`,
   also `e->ReportError(MB_ICONSTOP, nIDP);` (1034-1037).
5. `return lResult;` → **0** (1038).

Der angezeigte Text ist der der Ausnahme, nicht `AFX_IDP_INTERNAL_FAILURE`:
`CException::ReportError` (`except.cpp:103-119`) nimmt zuerst
`GetErrorMessage`, und `CSimpleException::GetErrorMessage`
(`except.cpp:195-217`) lädt `0xF025` erfolgreich über `InitString`
(`except.cpp:188-193`). `nIDP` wäre nur der Rückfall.

Die 0 wird zur Rückgabe der Fensterprozedur: `AfxCallWndProc`
(`wincore.cpp:235-283`) fängt in `CATCH_ALL(e)` (Zeile 271) und setzt
`lResult = AfxProcessWndProcException(e, &pThreadState->m_lastSentMsg);`
(Zeile 273). `WM_CLOSE` gilt damit als beantwortet, `DefWindowProc` läuft
nicht, das Fenster bleibt stehen. Eudora hat `ProcessWndProcException`
**nicht** überschrieben (Suche über alle `.cpp`/`.h`: kein Treffer außer dem
Kommentar `mainfrm.cpp:5316`).

**Geprüfte Zeilenangaben, alle richtig:** `appcore.cpp:1009-1039`,
`wincore.cpp:270-277`, `afxcoll.inl:212-217`.

---

## 3. Der Verdacht auf `QCCustomToolBar::SaveCustomInfo`

**Urteil: die Begründung ist widerlegt, die Aufrufkette und die Einfassung sind
bestätigt.** Der Verdacht bleibt als Verdacht möglich, aber die angegebene
Begründung („dieselbe Form wie E-34") trägt nicht.

### Die Aufrufkette — nachgeprüft, stimmt

| Schritt | behauptet | gemessen |
|---|---|---|
| `CloseDown` Stufe 5 | `SaveBarState("ToolBar")` | `mainfrm.cpp:5393` ✔ |
| → `CMainFrame::SaveBarState` | `mainfrm.cpp:2570` | `mainfrm.cpp:2570` ✔ **genau** |
| → `QCToolBarManager::SaveState` | `QCToolBarManager.cpp:1202` | **`:1203`** (Aufruf in `mainfrm.cpp:2585`) — um 1 daneben |
| → `QCCustomToolBar::SaveCustomInfo` | `QCCustomToolBar.cpp:378` | **`:377`** (Aufruf in `QCToolBarManager.cpp:1221`) — um 1 daneben |

Zusatz, in der Behauptung nicht genannt: `CMainFrame::SaveBarState` ruft die
Kette bei einem Registry-Fehler ein **zweites Mal** (`mainfrm.cpp:2803`,
`if (bMissionControlWeHaveAProblem)`). `SaveCustomInfo` kann also pro Beenden
zweimal laufen.

### Liegt die Stelle vor `pApp->HideApplication()`? — ja

* `CloseDown` läuft vollständig ab, bevor `CMainFrame::OnClose` überhaupt
  `QCWorkbook::OnClose()` erreicht (`mainfrm.cpp:5099` gegen `:5182`).
* `QCWorkbook::OnClose()` löst wirklich auf `CFrameWnd::OnClose` auf. Geprüft:
  `QCWorkbook` (`workbook.h:174`) hat keinen eigenen `OnClose` — die
  Deklaration in `workbook.h:124` gehört zu `QCControlBarWorksheet`
  (`workbook.cpp:455`). `SECWorkbook` (`OTShim.h:1431`) hat keinen,
  `SECMDIFrameWnd` (`OTShim.h:1082`) hat keinen, `CMDIFrameWnd` in MFC hat
  keinen (`winmdi.cpp`: kein `ON_WM_CLOSE`, kein `CMDIFrameWnd::OnClose`).
* `CFrameWnd::OnClose` steht in `winfrm.cpp:843`, `pApp->HideApplication()` in
  **`winfrm.cpp:885`**. Beide Angaben der Behauptung stimmen **genau**.

### „Im normalen Betrieb nur beim Beenden erreicht" — teilweise

* `SaveCustomInfo` hat genau **einen** Aufrufer: `QCToolBarManager.cpp:1221`.
  Die in der Behauptung genannten „zwei anderen Aufrufer" sind Aufrufer von
  `CMainFrame::SaveBarState`, nicht von `SaveCustomInfo`.
* Aufrufer von `CMainFrame::SaveBarState` (vollständig, ganzer Baum):
  * `mainfrm.cpp:974` — nur wenn `pMgr->ConvertOldStuff()` in Zeile 973 `TRUE`
    liefert, also bei einer alten INI. ✔ wie behauptet.
  * `QCToolBarManager.cpp:1109` — direkt hinter `toolbarSheet.DoModal()`, also
    nach dem **Anpassen-Dialog**. ✔ wie behauptet, aber: das ist normaler
    Betrieb. „Im normalen Betrieb NUR beim Beenden" gilt nur, solange niemand
    die Werkzeugleiste anpasst.
  * `mainfrm.cpp:5393` — `CloseDown`.

### Die Begründung — widerlegt

**Behauptet:** „Grenze aus `GetBtnCount()`, Zugriff mit `m_btns[...]` —
dieselbe Form wie bei E-34, wo dieses Paar auseinanderlief."

**Gemessen:**

* `GetBtnCount()` **ist** die Größe des indizierten Feldes:
  `inline int GetBtnCount() const { return (int)m_btns.GetSize(); }`
  (`OTShim/OTShim_Werkzeugleiste.h:744`), `m_btns` ist die `SECBtnArray`
  (abgeleitet von `CPtrArray`) derselben Klasse (`:878-906`).
* Die Schleifenbedingung `iCurrentButton < GetBtnCount()`
  (`QCCustomToolBar.cpp:421`) wird bei **jedem** Durchlauf neu ausgewertet.
* Der Schleifenrumpf (`QCCustomToolBar.cpp:421-509`) verändert `m_btns`
  **nirgends**. Er liest `m_ulData` und `m_nID`, ruft
  `g_theCommandStack.Lookup`, `IsKindOf`, `GetPathname`/`GetName` und
  `pApp->WriteProfileString`. Kein `Add`, `RemoveAt`, `SetSize`, `InsertAt`.
* **Damit ist ein Indexfehler hier nicht möglich**, solange kein anderer Faden
  das Feld verkleinert. Das ist keine „Form, bei der ein Paar auseinanderlaufen
  kann" — Grenze und Feld sind dieselbe Größe.

Richtig ist, dass der Zugriff im Release-Bau werfen **würde**: `m_btns[i]` auf
einem nicht-konstanten Objekt geht über `CPtrArray::operator[]` →
`CPtrArray::ElementAt` (`afxcoll.inl:212-216`) mit
`if (nIndex < 0 || nIndex >= m_nSize) AfxThrowInvalidArgException();`; der
const-Weg über `GetAt` (`afxcoll.inl:201-205`) genauso. Nur kommt der Index
hier nie dorthin.

**Der eigentliche Wurfkandidat in dieser Schleife ist ein anderer** —
und die Einfassung fängt ihn nicht: `m_btns[i]->m_ulData` (Zeile 423)
dereferenziert den Zeiger, und `pCommand->IsKindOf(...)` (Zeile 437) den
Rückgabewert von `Lookup`. Ein NULL-Element ergibt eine
Speicherschutzverletzung, keine `CException` — und `CATCH_ALL` fängt nur
`CException*` (siehe unten). Die Marke würde dann **nicht** schreiben.

### E-34 zum Vergleich — der Widerspruch bleibt offen

`QCChildToolBar::GetButton` (`QCChildToolBar.cpp:114-176`) hat **genau
dieselbe** Absicherung, die ich oben für `SaveCustomInfo` als ausreichend
gemessen habe: `if (iIndex < 0 || iIndex >= GetBtnCount()) return NULL;`
(Zeile 120) — und hat trotzdem geworfen („Ausnahme bei Index 24 von 27").
Dieser Widerspruch ist in der eigenen Doku als offen vermerkt
(`Befunde/BEENDEN.md:417`, `Befunde/LEKTOR-4.md:591`). Solange er offen ist,
lässt sich aus „gleiche Form wie E-34" nichts folgern: die Form hat bei E-34
selbst nichts erklärt.

**Eigene Vermutung, geprüft und widerlegt.** Ich habe vermutet, dass zwei
konkurrierende Definitionen von `SECCustomToolBar` einen ODR-Bruch und damit
verschobene Feldlagen erzeugen — das hätte „27 gemeldet, Index 24 wirft"
erklärt. Es gibt sie wirklich zweimal:

* `Eudora71/OT501/Include/tbarcust.h:73` mit `GetBtnCount` in `:128` und
  `m_btns` in `:354`
* `Eudora71/OTShim/OTShim_Werkzeugleiste.h:693` mit `GetBtnCount` in `:744` und
  `m_btns` in `:906`

und `Eudora71/Eudora/QCChildToolBar.h:12` bindet ausgerechnet `tbarcust.h` ein.
**Widerlegt durch:** `OTShim_Werkzeugleiste.h:1436` setzt `__TBARCUST_H__`
(den Include-Wächter von `tbarcust.h:21-22`), das spätere `#include
"tbarcust.h"` ist damit wirkungslos; und `OTShim_Werkzeugleiste.h:53-58` bricht
mit `#error` ab, falls `tbarcust.h` doch zuerst käme. `stdafx.h:52` zieht
`OTShimAll.h` vor allem anderen ein. Der Bau hat 0 Fehler, das `#error` ist
also nicht gefallen — `tbarcust.h` wird nie übersetzt.

### Lässt `THROW_LAST()` im `CATCH_ALL` den Ablauf unverändert? — ja

**Gemessen, aus `afx.h`:**

* `CATCH_ALL(e)` = `} catch (CException* e) { { ASSERT(...); _afxExceptionLink.m_pException = e;` (`afx.h:870-872`) — es fängt **nur** `CException*`. Keine SEH-Ausnahme, keine `std::exception`, kein `catch(...)`.
* `END_CATCH_ALL` = `} } }` (`afx.h:878`) — **löscht nichts** und schluckt nichts.
* `THROW_LAST()` = `(AfxThrowLastCleanup(), throw)` (`afx.h:867`) — ein echtes
  `throw;`, also dieselbe Ausnahme, unverändert.
* `AfxThrowLastCleanup` (`except.cpp:153-165`) setzt nur
  `pLinkTop->m_pException = NULL`, damit der `AFX_EXCEPTION_LINK`-Destruktor
  das Objekt nicht löscht. Das ist genau die vorgesehene Verwendung. Das Objekt
  (`_simpleInvalidArgException`, `m_bAutoDelete = FALSE`) erreicht `AfxCallWndProc`
  unverändert.
* `e->GetErrorMessage(szGrund, 256)` ist richtig gerufen — Signatur
  `(LPTSTR, UINT, PUINT = NULL)`, Puffer `TCHAR[256]`.
* Nebensache: das `iCurrentButton = 0;` vor dem `TRY` (Zeile 417) ist ohne
  Wirkung, weil die `for`-Schleife es sofort wieder setzt; das
  `szEntry.Format("btn%u", iCurrentButton)` **hinter** dem `END_CATCH_ALL`
  (Zeile 533) sieht denselben Wert wie vorher. Der Ablauf ist unverändert.

**Warnung zum Auslesen:** die Einfassung in `QCChildToolBar::GetButton`
(E-34, `QCChildToolBar.cpp:151-175`) **verschluckt** dagegen bewusst und gibt
NULL zurück. Entsteht dieselbe Ausnahme dort, erreicht sie die Meldung nie.
Kein Mangel des Prüfstands, aber beim Lesen des Protokolls zu bedenken.

### Liegen die Marken, wo sie behauptet werden?

**Die Zahl stimmt nicht: es sind 32, nicht 28.**

| Datei | neue `PutDebugLog`-Aufrufe mit `E-33` |
|---|---|
| `Eudora71/Eudora/mainfrm.cpp` | **28** |
| `Eudora71/Eudora/eudora.cpp` | 2 (`OnAppExit`, `ExitInstance`) |
| `Eudora71/Eudora/QCCustomToolBar.cpp` | 2 (vor der Schleife, im `CATCH_ALL`) |
| **Summe** | **32** |

Gemessen mit `git diff 003e8d8..HEAD -- <datei> | grep -c '^+.*PutDebugLog('`.
`WEITERMACHEN.md:103-107` nennt „28 Marken" und zählt dabei **alle drei**
Dateien auf — die 28 gelten aber nur für `mainfrm.cpp`. `CHANGELOG.md:17`
nennt ebenfalls 28.

**Lage der Marken — nachgeprüft, alle 32 liegen dort, wo sie hingehören:**
`mainfrm.cpp` 2499 (`SaveOpenWindows`), 5090/5101/5106 (`OnClose`-Eingang und
beide `CloseDown`-Ausgänge), 5115-5210 (`6a`…`6f` und drei Rahmenmarken in
`OnClose`), 5222/5268/5289/5299/5305/5417 (Stufen 1-6 in `CloseDown`),
5324/5330/5363/5370/5377/5391/5396/5401/5410 (`5a`…`5i`). Jede `5x`- und
`6x`-Marke steht wirklich unmittelbar vor bzw. hinter dem benannten Aufruf.
Die Behauptung „eine Ausnahme fällt immer zwischen zwei Marken" trägt für den
Abschnitt `5a`…`5i` und `6a`…`6f`.

**Falsche Zeilenangaben in den neuen Kommentaren:**

| Angabe im Kommentar | gemessen |
|---|---|
| `AFX_IDP_INVALID_ARGUMENT` (`mainfrm.cpp:5378`) | **existiert nicht**; richtig ist `AFX_IDS_INVALID_ARG_EXCEPTION` = `0xF025` (`afxres.h:382`) |
| „IsKindOf-Zweig von `mainfrm.cpp:6179`" (`mainfrm.cpp:5360`) | **falsch.** Der Zweig steht in `mainfrm.cpp:6263-6266`, in `CMainFrame::RemoveAdToolBarFromItsDockBar` (ab `:6242`). Zeile 6179 liegt in der Vorgabelage der Ad-Leiste |
| `SECDockBar::RemoveControlBar` `OTShim.cpp:2541` | um 2 daneben; die Funktion beginnt in `:2543` |
| `QCToolBarManager.cpp:1202` | um 1 daneben; `:1203` |
| `QCCustomToolBar.cpp:378` | um 1 daneben; `:377` |
| `QCCustomToolBar.cpp:421` (`CHANGELOG.md:17`) | **stimmt genau** — die `for`-Zeile |
| `bardock.cpp:302-308`, `ENSURE(nPos > 0)` | **stimmt genau** — `ENSURE(nPos > 0)` in `:308` |
| `winfrm.cpp:843-935`, `:885` | **stimmt genau** |
| `afxcoll.inl:212-217` | stimmt |
| `debug.cpp:140` | **stimmt genau** |
| `sendmail.cpp:3741` (`ExitAfterSend`) | **stimmt genau** |
| `OTShim/OTShim.h:1431ff.` (`SECWorkbook`) | **stimmt genau** |
| `QCToolBarManager.cpp:1109` (Anpassen-Dialog) | **stimmt genau** |
| `mainfrm.cpp:974` (nach `ConvertOldStuff`) | `:973` ist `ConvertOldStuff()`, `:974` der `SaveBarState`-Aufruf — als Anker richtig |
| `mainfrm.cpp:2570` (`CMainFrame::SaveBarState`) | **stimmt genau** |

### Widerspruch in der Doku zur Log-Maske

`WEITERMACHEN.md:145` sagt „Ohne diese Zeile schreibt Eudora nichts", der
Kasten in `WEITERMACHEN.md:140-146` sagt richtig, `LogLevel=32896` sei
„ausreichend, aber nicht nötig". **Gemessen gilt der Kasten:** der Vorgabewert
aus `EudoraRes.rc:8441` ist 25759 = `0x649F`, und `0x649F & 0x80 = 0x80` —
die Marken schreiben auch ohne jede `LogLevel`-Zeile.

---

## 4. `tools/bauen.ps1` — die neue `Hole-NeuesteQuelleFuer`

**Urteil: bestätigt** — für jedes der neun überwachten Artefakte kommt eine
Quellmenge > 0 heraus, keines fällt still auf den Rückfall. **Aber es gibt eine
neue, gegenläufige Lücke**, die der alte Rückfall nicht hatte.

Gemessen mit einer Messfassung von `Hole-ProjektDatei` und dem Zählteil von
`Hole-NeuesteQuelleFuer` im Arbeitsbaum. Nichts gebaut, nichts gestartet.

| Artefakt | Projektdatei | Quelldateien | Rückfall | jüngste Quelle |
|---|---|---:|---|---|
| `Eudora.exe` | `Eudora.vcxproj` | **741** | nein | `mainfrm.cpp` |
| `EudoraRes.dll` | `EudoraRes.vcxproj` | **3** | nein | `resource.h` |
| `EuLang.dll` | `EuLang.vcxproj` | **2** | nein | `src\lang_info.cpp` |
| `Imap.dll` | `imap.vcxproj` | **40** | nein | `src\stdafx.h` |
| `QCSocket.dll` | `QCSocket.vcxproj` | **17** | nein | `src\StdAfx.cpp` |
| `QCUtils.dll` | `QCUtils.vcxproj` | **38** | nein | `src\services.cpp` |
| `QCSSL.dll` | `QCSSL.vcxproj` | **27** | nein | `src\sslutils.cpp` |
| `plstclnt.dll` | `plstclnt.vcxproj` | **36** | nein | `xml_parser_base.cpp` |
| `msvcr71.dll` | `VC71Bruecke.vcxproj` | **1** | nein | `src\bruecke.c` |

**Nirgends 0. Der Rückfall greift für kein Artefakt.**

**Der behobene Fehlalarm ist wirklich behoben.** `Eudora.vcxproj` und
`EudoraRes.vcxproj` liegen im selben Ordner; jetzt bekommt `EudoraRes.dll` nur
`EudoraRes.cpp`, `EudoraRes.rc` und `resource.h` — `mainfrm.cpp` ist nicht
dabei. Die Projektnamen sind eindeutig: 19 `.vcxproj` ohne `OT501`, kein
doppelter Grundname, also ist `Select-Object -First 1` heute unkritisch.

### Neue Lücke: `.def`, `CustomBuild`, `Manifest`, Bilder

Die neue Funktion sieht nur `ClCompile`, `ClInclude`, `ResourceCompile` und
`Midl` an. Der alte Rückfall kannte auch `.def` (und `.props`, `.rc2`, `.inc`).
Sechs der neun Projekte binden ihre Exportliste als
`<None Include="…def">` mit zugehörigem `<ModuleDefinitionFile>` ein — diese
Dateien zählen **jetzt nicht mehr mit**:

| Artefakt | nicht mehr überwacht |
|---|---|
| `msvcr71.dll` | `src\msvcr71.def`, `src\msvcrt-namen.def` |
| `EuLang.dll` | `src\EuLang.def` |
| `QCUtils.dll` | `src\QCUtils.def` |
| `QCSSL.dll` | `src\qcssl.def` |
| `plstclnt.dll` | `plstclnt.def` |
| `EudoraRes.dll` | `EudoraRes.def` |

Bei `msvcr71.dll` wiegt das am schwersten: die Quellmenge ist genau **eine**
Datei (`src\bruecke.c`), während die Exporte der Laufzeitbrücke in
`msvcr71.def` und `msvcrt-namen.def` stehen. Eine Änderung dort macht die DLL
nicht „VERALTET".

Bei `Eudora.exe` fehlen zusätzlich `CustomBuild: EudoraExe.idl`,
`Manifest: Eudora.manifest` und sechs `.rgs`-Dateien.

Bei `EudoraRes.dll` fehlen **202** weitere Einträge (`Image`, `None`, `Text`:
alle `.bmp`, `.ico`, `.cur`, `.html`, `.txt`, die die `.rc` einbindet). Eine
geänderte Symboldatei markiert `EudoraRes.dll` also nicht als veraltet. Das ist
genau die Gegenrichtung des behobenen Fehlalarms, und angesichts der laufenden
Symbolarbeit (`Releases/Eudora72-1.0.2-symbole.zip`) nicht theoretisch.

### Nebenbefunde

* **Sechs Include-Angaben zeigen auf Dateien, die es nicht gibt**, und werden
  lautlos übersprungen: `imap.vcxproj` → `src\com_err.h`, `src\imapfr.h`,
  `src\krb5.h`, `src\profile.h`, `src\win-mac.h`; `Eudora.vcxproj` →
  `winsock.h`. Kein Fehler (alte Projekteinträge), aber ungemeldet.
* Je Projekt werden 6 Knoten ohne `Include`-Attribut übersprungen (bei
  `VC71Bruecke` 2) — das sind die `<ClCompile>`/`<ResourceCompile>` aus den
  `<ItemDefinitionGroup>`. Korrekt behandelt.
* `$max` wird im Rückfallzweig richtig auf `1990-01-01` zurückgesetzt, der
  Zeitstempel der Projektdatei selbst zählt im XML-Zweig immer mit. Beides
  sauber.

---

## Was ich nicht prüfen konnte

* **Nichts gebaut, nichts gestartet** (Auflage). Es gibt daher keine Messung,
  ob die 32 Marken zur Laufzeit schreiben, wo die letzte Marke fällt, und ob
  die Meldung wirklich in `CloseDown` entsteht. Punkt 3 ist deshalb eine
  Prüfung des Prüfstands, nicht des Fehlers.
* Ob Kreuz und Alt-F4 auf diesem System tatsächlich über `SC_CLOSE` nach
  `WM_CLOSE` gelangen — das ist `user32`-Verhalten, dafür liegt keine Quelle
  vor. **Ausdrücklich Vermutung.** Gemessen ist nur, dass MFC auf diesem Weg
  einen eigenen Behandler mit einer werfenden Prüfung hat.
* Welche MFC-DLL `Eudora.exe` zur Laufzeit tatsächlich bindet. Geprüft ist
  `UseOfMfc=Dynamic` und `CharacterSet=MultiByte` (`Eudora.vcxproj:27-37`); den
  Text `0xF025` habe ich in `SysWOW64\mfc140.dll`, `SysWOW64\mfc140enu.dll` und
  der x86-Redist-Fassung gelesen, alle drei gleichlautend. Das Importverzeichnis
  der `Eudora.exe` habe ich nicht gelesen.
* Ob Eudora eigene Ressourcen mit der Kennung `0xF025` mitbringt.
  `AfxLoadString` sucht zuerst in den eigenen Modulen; das habe ich nicht
  ausgeschlossen.
* Ob ein anderer Faden `m_btns` während `SaveCustomInfo` verkleinert — statisch
  nicht entscheidbar. Meine Aussage „Indexfehler nicht möglich" gilt für den
  Einfaden-Fall.
* Die offene Wurzel von E-34 („27 gemeldet, Index 24 wirft") bleibt offen. Ich
  habe nur **eine** Erklärung ausgeschlossen (ODR-Bruch durch zwei
  `SECCustomToolBar`-Definitionen).
* Die Suche nach weiteren Erzeugern des Meldungstexts in den Eudora-Quellen war
  nicht erschöpfend (gesucht nach `0xF025` und `AFX_IDS_INVALID_ARG`).

---

## Tabelle aller Urteile

| Nr. | Behauptung | Urteil |
|---|---|---|
| 1a | `PopulateView()` ist von `OnCmdDeletePersonality` aufrufbar und leert/füllt die Liste | **bestätigt** in der Sache; **widerlegt** in der Begründung — es ist `public` (`PersonalityView.h:48/58`), nicht `protected` |
| 1b | `PopulateView()` kann an dieser Stelle nichts kaputt machen, „BE SURE TO RESTORE" ist erfüllt | **bestätigt.** Zusatzbefund: `Remove()` setzt `m_Current` nicht zurück, die gelöschte Persönlichkeit bleibt „aktuell" — vorhandener Mangel, nicht durch die Behebung erzeugt. Befürchtung, `RestorePassInfo` schreibe den Abschnitt neu: **widerlegt** |
| 1c | Bei mehreren markierten Konten bleibt alles richtig | **bestätigt** |
| 1d | Die drei Protokollzeilen sind korrekt gebaut (`PutDebugLog` ohne Formatstring, `%s` mit `(const char*)`) | **bestätigt.** Zusatz: nur `DEBUG_MASK_TOC_CORRUPT` (0x80) macht sie mit dem Vorgabe-`LogLevel` 25759 sichtbar, `DEBUG_MASK_MISC` allein nicht |
| 2a | „Encountered an improper argument" ist MFCs Text für `CInvalidArgException` | **bestätigt** in der Sache; **widerlegt** in der Kennung — es ist `AFX_IDS_INVALID_ARG_EXCEPTION` (`0xF025`), `AFX_IDP_INVALID_ARGUMENT` gibt es nicht |
| 2b | Außer `CInvalidArgException` kann den Text nichts erzeugen | **bestätigt** für MFC (einziger Nutzer von `0xF025`). Aber: `ENSURE`/`ENSURE_ARG`/`ENSURE_VALID` werfen ihn an mindestens 66 Stellen der Rahmen- und Leistenquellen — die Meldung benennt keine Stelle |
| 2c | Kreuz und Alt-F4 gehen durch dasselbe `CMainFrame::OnClose`, damit ist der Menüweg ausgeschlossen und der Wurf liegt in `OnClose`/`CloseDown` | **widerlegt als Beweisführung.** Kreuz und Alt-F4 teilen zusätzlich `WM_SYSCOMMAND`/`SC_CLOSE`, den *File → Exit* nicht hat, und dort steht `ENSURE_VALID` in `CFrameWnd::OnSysCommand` (`winfrm.cpp:1112-1114`) |
| 2d | `CWinApp::ProcessWndProcException` liefert bei `CInvalidArgException` 0, `WM_CLOSE` gilt als beantwortet | **bestätigt** (`appcore.cpp:1009-1039`, `wincore.cpp:273`) |
| 3a | Aufrufkette `CloseDown` → `SaveBarState` → `CMainFrame::SaveBarState` → `QCToolBarManager::SaveState` → `SaveCustomInfo` | **bestätigt**; zwei Zeilenangaben um 1 daneben (`:1203`, `:377`). Zusatz: `mainfrm.cpp:2803` ruft die Kette bei Registry-Fehler ein zweites Mal |
| 3b | Die Stelle liegt vor `pApp->HideApplication()` | **bestätigt**, `winfrm.cpp:843`/`:885` stimmen genau |
| 3c | `SaveCustomInfo` läuft im normalen Betrieb nur beim Beenden | **teilweise** — der Anpassen-Dialog (`QCToolBarManager.cpp:1109`) ist normaler Betrieb |
| 3d | Begründung: „dieselbe Form wie E-34, Grenze aus `GetBtnCount()`, Zugriff mit `m_btns[...]`" | **widerlegt.** `GetBtnCount()` **ist** `m_btns.GetSize()` (`OTShim_Werkzeugleiste.h:744`), wird je Durchlauf neu ausgewertet, und der Rumpf verändert `m_btns` nicht. Ein Indexfehler ist hier nicht möglich |
| 3e | Die 28 Marken liegen an den behaupteten Stellen | **teilweise.** Die Lage stimmt überall, die **Zahl nicht**: 32 Marken (28 `mainfrm.cpp`, 2 `eudora.cpp`, 2 `QCCustomToolBar.cpp`) |
| 3f | `THROW_LAST()` im `CATCH_ALL` lässt den Ablauf unverändert, verschluckt nichts | **bestätigt** (`afx.h:867/870/878`, `except.cpp:153-165`). `CATCH_ALL` fängt nur `CException*` — Speicherschutzverletzungen laufen durch |
| 3g | Zeilenangaben `bardock.cpp:302-308` mit `ENSURE(nPos > 0)`, `mainfrm.cpp:6179` (IsKindOf-Zweig), `OTShim.cpp:2541` | `bardock.cpp` **stimmt genau**; `mainfrm.cpp:6179` **falsch** (richtig `:6263-6266`); `OTShim.cpp:2541` um 2 daneben (`:2543`) |
| 4a | Für jedes der neun Artefakte kommt eine sinnvolle Quellmenge heraus, keines fällt still auf den Rückfall | **bestätigt** — 741 / 3 / 2 / 40 / 17 / 38 / 27 / 36 / 1, nirgends 0 |
| 4b | Die Verwechslung `Eudora.vcxproj` ↔ `EudoraRes.vcxproj` ist behoben | **bestätigt** — `EudoraRes.dll` bekommt 3 Dateien, `mainfrm.cpp` ist nicht dabei |
| 4c | (nicht behauptet) Vollständigkeit der Quellmenge | **neue Lücke:** `.def`-Dateien von 6 Projekten, `EudoraExe.idl`, `Eudora.manifest`, 6 `.rgs` und 202 Ressourceneinträge von `EudoraRes` zählen nicht mehr mit. Bei `msvcr71.dll` bleibt genau **eine** Quelldatei übrig |

### Zusätzlich widerlegt, ohne dass es behauptet war

| Vermutung | Messung |
|---|---|
| Zwei konkurrierende `SECCustomToolBar`-Definitionen (`tbarcust.h:73` gegen `OTShim_Werkzeugleiste.h:693`) erzeugen einen ODR-Bruch und erklären E-34 | **widerlegt.** `OTShim_Werkzeugleiste.h:1436` setzt `__TBARCUST_H__`, `:53-58` bricht mit `#error` ab, `stdafx.h:52` bindet den Shim zuerst ein, der Bau hat 0 Fehler — `tbarcust.h` wird nie übersetzt |
| `RestorePassInfo` schreibt beim Zurückstellen der gelöschten Persönlichkeit deren INI-Abschnitt neu | **widerlegt.** `persona.cpp:1073-1129` berührt nur `m_Passwords` und `::POPPassword`, keine INI |
| `WEITERMACHEN.md:145` „Ohne `LogLevel=32896` schreibt Eudora nichts" | **widerlegt.** Vorgabe 25759 = `0x649F`, `& 0x80 = 0x80` — die Marken schreiben auch ohne die Zeile. Der Kasten in `:140-146` sagt es richtig, der Satz in `:145` widerspricht ihm |
