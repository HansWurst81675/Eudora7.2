# E-22 — Es lässt sich kein Nachrichtenfenster öffnen

Agent FENSTER, 05./06.09.2026. Branch `wt/fenster-2` (von `fehler-nach-1010`).

Gregors Fehlerliste vom 05.09.2026, Fassung 7.2.0.10:

> - wenn ich suche, läßt sich die mail nicht anklicken
> - doppelklick öffnet nicht die mail im großen
> - ctrl-N: crash
> - fehler message box

**Ursache gefunden: nein.** Was dieser Befund liefert, ist ein *neuer, harter
Messwert*, der die bisherige Suchrichtung widerlegt, dazu sechs belegte
Schwachstellen auf genau dem Weg, den Gregor beschreibt, und eine Anleitung,
die den Fehler im nächsten Lauf festnagelt.

---

## 1. Der neue Messwert: Eudora beschädigt den Heap

Nicht aus dem Quelltext, sondern aus dem **Windows-Ereignisprotokoll**
(`Anwendung`, Quelle `Application Error`) — dort steht, was bisher niemand
nachgesehen hat:

| Zeit 05.09.2026 | Fassung | Fehlermodul | Ausnahmecode | Pfad |
|---|---|---|---|---|
| 22:43:06 | 7.2.0.10 | `ntdll.dll` +0x000e6dc3 | **`0xc0000374`** | `…\selbst_bauen\Eudora7.2\Eudora71\Bin\Release\Eudora.exe` |
| 22:43:17 | 7.2.0.10 | `ntdll.dll` +0x000e6dc3 | **`0xc0000374`** | dito |
| 22:46:31 | 7.2.0.10 | `dbghelp.dll` +0x00016c9c | `0xc0000005` | dito |
| 21:54:48 | 7.2.0.7 | `ntdll.dll` +0x0003dfb6 | `0xc0000005` | `C:\Users\Gregor\Eudora72-1.0.7-release` |
| 21:56:18 | 7.2.0.7 | `ntdll.dll` +0x000696ac | `0xc0000005` | `C:\Users\Gregor\Eudora72-1.0.7-debug` |

`0xc0000374` ist `STATUS_HEAP_CORRUPTION`. Der Heap-Verwalter merkt beim
nächsten `RtlFreeHeap`/`RtlAllocateHeap`, dass seine Buchführung nicht mehr
stimmt, und **beendet den Prozess sofort und ohne Dialog**. Das ist genau
Gregors Bild: „Bei Strg-N verabschiedet sich Eudora lautlos."

Die Einträge zu 7.2.0.7 zeigen dasselbe eine Stufe früher: `0xc0000005`
**innerhalb von ntdll** ist der Zugriffsfehler, den die Heap-Verkettung
auslöst, wenn ein Blockkopf überschrieben wurde.

Nachzulesen jederzeit:

    Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Application Error'} |
        Where-Object { $_.Message -like '*udora*' } | Select-Object TimeCreated, Message

### Was daraus folgt — und was das für E-16 bedeutet

Bei einer Heap-Beschädigung ist der Ort des Absturzes **nicht** der Ort des
Fehlers. Und — das ist der Punkt — eine beschädigte `CPtrArray` trägt
beschädigte `m_nSize`/`m_pData`. Dann meldet **jeder** Zugriff
`nIndex >= m_nSize`, auch ein völlig korrekt begrenzter. Die Zusicherung
`afxcoll.inl:213` und „Encountered an improper argument" sind dann **Folge**,
nicht Ursache.

Genau dieses Muster ist in diesem Programm schon einmal aufgetreten und
dokumentiert: **E-4** (`BEFUNDE.md`). Dort schrieb
`CWazooBarMgr::SetDefaultWazooBarState` beim *Start* über einen C-Cast in ein
Objekt falschen Typs; sichtbar wurde es erst beim *Beenden* als
`afxcoll.inl:213`. Der Befund hält ausdrücklich fest: „daher die irreführende
Spur zu `afxcoll.inl:213`".

**Empfehlung: die Suche nach einem unbegrenzten Feldindex ist mit E-16
ausgereizt. Gesucht wird ein Schreibzugriff daneben.**

---

## 2. Was ich am Quelltext ausgeschlossen habe

Alles gegengelesen, nichts davon trägt:

* **`SECCustomToolBar::SetButtons` bricht halb ab.** Das war VERFASSENs
  verbliebene Hypothese (`Befunde/VERFASSEN.md`, Abschnitt 3b). Sie ist
  **widerlegt**: `SetButtons` gibt nur bei `pBtn == NULL` auf, und
  `CreateButton` (`OTShim_Werkzeugleiste.cpp:2074-2121`) liefert NULL nur,
  wenn `new class_name` in `IMPLEMENT_BUTTON` NULL liefert — das ist ein
  werfendes `new`. Fehlt ein Eintrag in der Knopftabelle, fällt die Funktion
  auf `SECStdBtn` zurück, sie bricht nicht ab. Also liefert
  `CommandToIndex(ID_EDIT_INSERT)` sehr wohl einen gültigen Platz, und die
  sechs Stellen aus E-16 waren nie scharf.
* **`SECDockBar::NormalizeBarArray` (E-4) wird umgangen.** Das stimmt, ist
  aber folgenlos: **kein einziger** Rahmen in Eudora leitet von
  `QCControlBarWorksheet` ab (einzige Treffer für den Namen liegen in
  `workbook.h`/`workbook.cpp` selbst). Nachrichtenfenster sind
  `CCompMessageFrame`/`CReadMessageFrame` → `CMessageFrame` → `CMDIChild` →
  `QCWorksheet` → **`SECWorksheet`**, bekommen über `CFrameWnd::EnableDocking`
  also gewöhnliche `CDockBar`. Deren Aufbau baut MFC selbst wohlgeformt auf
  (`bardock.cpp:158-160`: `m_arrBars.Add(pBar); m_arrBars.Add(NULL);`, dazu
  `CDockBar::CDockBar`, das mit `m_arrBars.Add(NULL)` beginnt). Die
  ungesicherten Stellen in `CDockBar::RemoveControlBar`/`RemovePlaceHolder`
  (`bardock.cpp:297, 321, 328`) greifen dort nicht daneben.
* **Der C-Cast in `headervw.cpp:444`**,
  `QCUpdateTab((SECWorksheet*)GetParentFrame())`: unbedenklich. Das
  Elternfenster einer `CHeaderView` **ist** ein `SECWorksheet`, und
  `QCWorkbook::QCUpdateTab` (`workbook.cpp:767-776`) prüft zusätzlich mit
  `DYNAMIC_DOWNCAST`, das auch NULL verträgt.
* **`SECLoadToolBarResource` / `QCToolBarManagerWithBM::AddButtonImage`.**
  Der Verdacht war ein `delete []` auf einen Zeiger, der nicht mit `new []`
  kam — dieser Weg läuft bei Strg-N tatsächlich an
  (`QCChildToolBar::AddTranslatorButtons`, Gregor hat drei Plugins). Er trägt
  aber nicht: `SECLoadToolBarResource`
  (`OTShim_Werkzeugleiste.cpp:3408-3480`) legt `pBmpItems` mit `new UINT[]`
  an, `QCToolBarManager.cpp:601-606` gibt es mit `delete []` frei.
* **`SECImage::CreateFromBitmap`** (`OTShim_Bild.cpp:1120-1207`): der DIB wird
  als 24 bpp angelegt, `m_lpBMI` braucht für 24 bpp keine Farbtabelle, die von
  `::GetDIBits` beschriebene Länge passt zu `dwDatenBytes`.
* **Nicht-virtueller Destruktor bei Mehrfachvererbung.** `CTBarStaticBtn` und
  `CTBarEditBtn` erben `CStatic`/`CEdit` **und** `SECWndBtn`; `m_btns` hält
  sie als `SECStdBtn*`, also mit Versatz. `delete m_btns[i]` in
  `SetButtons`/`RemoveButton` wäre bei nicht-virtuellem Destruktor eine
  Heap-Beschädigung. Ist es nicht: `virtual ~SECStdBtn()` steht in
  `OTShim_Werkzeugleiste.h:296` **und** im Original
  `OT501/Include/tbtnstd.h:173`.

---

## 3. Was ich behoben habe (belegt, aber nicht als Ursache bewiesen)

Alle Stellen liegen **auf genau dem Weg**, den Gregor beschreibt (`WM_CREATE`
des Nachrichtenfensters bzw. dessen Anzeige), und alle sind Zugriffe über
einen Zeiger, den die Funktion selbst **nicht** geprüft hat, obwohl die
Schwesterfunktion daneben es tut. Ein solcher Zugriff ist im Release-Bau ein
`0xc0000005` **ohne Dialog** — also das gemeldete Bild.

| Datei | Was war | Was jetzt |
|---|---|---|
| `Eudora71/Eudora/ReadMessageFrame.cpp:255` | `Doc` und `Doc->m_Sum` nur per `ASSERT_KINDOF` „geprüft" (im Release leer), danach überall benutzt | Abbruch mit `FALSE`, wenn eines NULL ist |
| `Eudora71/Eudora/ReadMessageFrame.cpp:416-478` | **fünf** `GetDlgItem`-Ergebnisse ungeprüft benutzt: Abschleppwagen (`SetIcon`), Betreff-Beschriftung (`SetWindowText`/`AdjustSize`), Betreff-Feld (`SetWindowText`), Prioritätsauswahl (`Add`/`SetCurSel`), Schriftauswahl (`AddString`) | jeweils `if (…)` davor |
| `Eudora71/Eudora/CompMessageFrame.cpp:391` | `pDoc` und `pDoc->m_Sum` ungeprüft (`pDoc->GetText()` unmittelbar darunter) | Abbruch mit `FALSE` |
| `Eudora71/Eudora/CompMessageFrame.cpp:547-670` | vier ungeprüfte `GetDlgItem`-Ergebnisse: Priorität, Signatur, Kodierung, Schrift | jeweils `if (…)` davor |
| `Eudora71/Eudora/PgDocumentFrame.cpp:235-310` | Schriftauswahl ungeprüft; danach `pMainFrame->MDIGetActive`, `pMainFrame->GetMenu()` und **drei** `GetSubMenu` in Reihe, alle nur mit `VERIFY` — im Release wertet `VERIFY` nur aus und prüft nichts | dieselben Abfragen wie in `CCompMessageFrame::OnCreateClient`, die es dort längst gibt |
| `Eudora71/Eudora/msgframe.cpp:44, :107` | `((CMessageDoc*)GetActiveDocument())->m_Sum` ohne Prüfung auf NULL — in `ActivateFrame`, also unmittelbar auf dem Weg `CSummary::Display` → `NewChildFrame` → `InitialUpdateFrame` | `pDoc ? pDoc->m_Sum : NULL`. `OnDestroy` derselben Klasse (Zeile 133) prüfte schon immer |
| `Eudora71/Eudora/mdichild.cpp:102` | `Win->GetSafeHwnd()` mit `Win` aus `MDIGetActive()`, das NULL liefert, solange kein Kindfenster offen ist. `CWnd::GetSafeHwnd` fängt das nur über `this == NULL` ab (`afxwin2.inl:24`) — nicht definiert | `Win == NULL ||` davor. Zwölf Zeilen weiter unten prüft die Funktion `Win` selbst schon auf NULL |

Alle Änderungen byte-erhaltend über `tools/ersetze-bereich.pl`; CR-Zahl je
Datei unverändert (`CompMessageFrame.cpp`, `ReadMessageFrame.cpp`,
`PgDocumentFrame.cpp` je 18 CR für den CHM-Kopf, Rest LF; `msgframe.cpp` und
`mdichild.cpp` 0 CR), keine Bytes ab 0x80 hinzugekommen.

**Ehrlich: keine dieser Stellen ist als *die* Ursache nachgewiesen.**
Nachgewiesen ist nur, dass jede von ihnen genau das Bild erzeugen würde, das
Gregor sieht, und dass sie alle auf dem beschriebenen Weg liegen.

---

## 4. Was mir fehlt — und wie Gregor es in einem Lauf liefert

Mir fehlt **der Aufrufstapel im Augenblick der Beschädigung**. Statisch ist er
nicht zu bekommen: bei einer Heap-Beschädigung liegt der Absturzort
grundsätzlich woanders als der Fehler. Selbst starten darf ich Eudora auf
diesem Rechner nicht.

Dafür gibt es genau ein Werkzeug, und es ist auf jedem Windows vorhanden:
**Page Heap** (`gflags`, Teil der Debugging Tools for Windows). Er legt hinter
jeden Heap-Block eine unbeschreibbare Seite. Der erste Schreibzugriff daneben
wird damit **sofort** zum Zugriffsfehler — an der Anweisung, die ihn begeht,
nicht Minuten später.

1. Eingabeaufforderung **als Administrator**:

       gflags /p /enable Eudora.exe /full

2. Eudora aus dem Debug-Testverzeichnis starten (die `Eudora.pdb` muss
   danebenliegen), Strg-N drücken.
3. Beim Absturz: `tools\stapel-untersuchen.ps1` in einer **32-Bit**-PowerShell.
   Der erste Rahmen außerhalb von `ntdll`/`mfc140d` nennt Datei und Zeile.
4. Danach wieder abschalten, sonst läuft Eudora dauerhaft langsam:

       gflags /p /disable Eudora.exe

Zweitbeste Möglichkeit, falls Page Heap ausfällt: im Debug-Bau im
Zusicherungsdialog **„Wiederholen"** drücken (macht daraus einen Haltepunkt)
und dann `tools\stapel-untersuchen.ps1`. Das liefert den Ort der *Folge*, nicht
den der Ursache — aber immerhin die Sammlung, die beschädigt wurde.

Nützlich wäre außerdem, welcher der drei Punkte **welche** Meldung erzeugt:
Suchtreffer-Klick, Doppelklick und Strg-N sind bisher zu „fehler message box"
und „crash" zusammengefasst. Kommt die Meldung auch beim einfachen Anklicken
in der Vorschau, liegt der Fehler vor dem Fensterbau.

---

## 5. Bauzustand

| Bau | Ergebnis |
|---|---|
| Release / x86 (Projekte Win32) | 0 Fehler |
| Debug / x86 | 0 Fehler |

Aufruf jeweils
`MSBuild Eudora71/Eudora.sln -t:Build -p:Configuration=<…> -p:Platform=x86 -m`,
kein `Rebuild`, kein `Clean`.

---

## 6. Nebenbefunde (nicht angefasst — gehören anderen Agenten oder später)

* `Eudora71/Eudora/PgDocumentFrame.cpp:170`: `int OnCreate(...)` gibt bei
  fehlgeschlagener Leistenerzeugung `return FALSE` zurück. `FALSE` ist `0`, und
  `0` heißt bei `OnCreate` **Erfolg**. Richtig wäre `-1`. Heute folgenlos, weil
  die beiden `DEBUG_NEW_MFCOBJ_NOTHROW` praktisch nie NULL liefern. Nicht
  geändert, weil es den Fehlerfall verhaltensmäßig verschiebt.
* `Eudora71/Eudora/ReadMessageFrame.cpp:490` und `CompMessageFrame.cpp:664`:
  die Menüplätze `1 + i`, `11` und `10` sind fest verdrahtete Wetten auf den
  Aufbau der Menüressource — dieselbe Bauart wie die feste `13` aus E-16. Sie
  fallen jetzt nur nicht mehr um, sie stimmen deshalb noch nicht. Wer die
  Menüs im Nachrichtenfenster vermisst, sucht hier.
* `Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:4104`:
  `SECToolBarManager::CreateToolBar` kopiert den uebergebenen Titel mit
  `lstrcpy` in ein `TCHAR szBuffer[128]` auf dem Stapel, ohne die Laenge zu
  pruefen. Das ist ein echter Pufferueberlauf. Nicht geaendert, weil die
  Funktion nur fuer benutzereigene Werkzeugleisten laeuft und damit nicht
  auf Gregors Weg liegt - und weil gleichzeitig andere Agenten in dieser
  Datei arbeiten koennten. Behebung ist eine Zeile: `lstrcpyn(szBuffer,
  lpszTitle, 128)`.
* Von den Bereichen der drei anderen Agenten (POP3-Port, doppeltes „In" unter
  Recent, Kontoassistent) ist mir nichts untergekommen.
