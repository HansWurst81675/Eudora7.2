# PRUEFER-5 — Review der Exit-Behebung in 7.2.0.22

| | |
|---|---|
| Datum | 08.09.2026 |
| Arbeitsbaum | `C:\Users\Gregor\Documents\github\Eudora7.2-wt-pruefer` |
| Zweig | `wt/pruefer` |
| Bezugscommit | `d003d46` („Paket 1.0.22: Kriterium 7 erfuellt, A-1 belegt"), per `git merge --ff-only origin/pruefer-4-einarbeiten` |
| Behebungscommit | `269f3b5` („E-40/E-41/E-42: ein Fehler beim Aufraeumen verhindert das Beenden nicht mehr") |
| Zusatzstand | `Eudora71/Eudora/PersonalityView.cpp` **unversioniert im Hauptbaum**, Stand 08.09.2026 09:21:30, MD5 `25eaca77a17e45a4dcedded2cac6d879` — der zweite E-37-Anlauf ist im Prüfstand `d003d46` **nicht** enthalten (dort steht noch der erste). Punkt 4 wurde deshalb gegen eine Momentaufnahme des Hauptbaums geprüft. |
| MFC-Quellen | `C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\atlmfc` |
| Nicht getan | nicht gebaut, kein Programm gestartet, nichts committet, keinen Zweig angelegt; geschrieben wurde nur diese Datei |

**Harte Vorabmessung, die drei Antworten trägt:** die Release-Konfiguration
übersetzt mit `/EHsc`. Belegt aus dem echten Compileraufruf, nicht aus der
Projektdatei (die setzt `<ExceptionHandling>` gar nicht):
`Eudora71/Eudora/Build/Release/Eudora.tlog/CL.command.1.tlog`, Suchmuster `/EH`
→ genau ein Treffer, `/EHsc`.

---

## 1. E-42 — das Makro `AUFRAEUMEN` (`Eudora71/Eudora/mainfrm.cpp:5092-5109`)

Zwölf Aufrufe, nachgezählt: `mainfrm.cpp:5151, 5161, 5181, 5192, 5199, 5214`
(in `OnClose`) und `5359, 5411, 5425, 5430, 5439, 5444` (in `CloseDown`).
`IMAP4` ist in der Release-Konfiguration definiert (`Eudora.vcxproj:132`), der
`#ifdef`-Schritt `CloseImapConnections` existiert also wirklich — es sind zwölf,
nicht elf.

### (a) Ist das Makro sauber?

**Behauptung:** `do { } while (0)`, keine Klammerfalle, `CATCH_ALL`/`END_CATCH_ALL`
richtig geschachtelt, `e` nicht außerhalb benutzt.

**Gemessen** gegen `afx.h` (VS 2022, MSVC 14.38.33130):

```
afx.h:854   #define TRY            { AFX_EXCEPTION_LINK _afxExceptionLink; try {
afx.h:870   #define CATCH_ALL(e)   } catch (CException* e) { { ASSERT(...); _afxExceptionLink.m_pException = e;
afx.h:878   #define END_CATCH_ALL  } } }
```

Damit expandiert `AUFRAEUMEN` zu

```
do { { AFX_EXCEPTION_LINK _afxExceptionLink; try { { anweisung; } }
     catch (CException* e) { { ...Rumpf... } } } } while (0)
```

Klammerbilanz: `TRY` öffnet zwei (`{` + `try {`), das Makro selbst eines
(`{ anweisung; }` — geschlossen im Makro), `CATCH_ALL` schließt das `try` und
öffnet zwei, `END_CATCH_ALL` schließt drei. Ausgeglichen.

Die von `TRY` erzeugte Klammer ist hier nicht kosmetisch: sie gibt jedem
`AUFRAEUMEN` ein eigenes Gültigkeitsfeld für `_afxExceptionLink`. Ohne sie
würden die sechs Aufrufe in `OnClose` denselben Namen mehrfach deklarieren.
Geprüft, dass das trägt: `OnClose` enthält sechs `AUFRAEUMEN` in einem Rumpf.

`do { } while (0)` mit angehängtem `;` ist an allen zwölf Stellen richtig, auch
bei `mainfrm.cpp:5161`, wo der Aufruf der einzige Satz eines `if`-Zweiges mit
Klammern ist. Es gibt keinen Aufruf ohne Klammern in einem `if`/`else`, also
keine hängende `else`-Falle.

`e` wird ausschließlich im Rumpf benutzt (`mainfrm.cpp:5099`). Kein Leck: der
Destruktor von `AFX_EXCEPTION_LINK` ruft `AfxTryCleanup()` (`afx.h:820-828`),
das die gefangene Ausnahme freigibt. Ein zusätzliches `e->Delete()` wäre
falsch, es fehlt zu Recht.

Kommata in den Anweisungen (`TrayItem(IDR_MAINFRAME, NIM_DELETE)`,
`DeleteMenuObjects(GetMenu(), FALSE)`) stehen in Klammern und spalten die
Makroargumente nicht. `_T(name)` mit `name` = Zeichenkettenliteral ist in
beiden Zeichensatzmodellen gültig; der Bau ist MBCS (kein `_UNICODE` in
`Eudora.vcxproj:132`), `_T` ist dort die Identität.

**Urteil: bestätigt.** Ein Restpunkt, kein Fehler: `PutDebugLog` und
`CString::Format` stehen selbst im `CATCH_ALL`-Rumpf. Wirft `Format` bei
Speichermangel eine `CMemoryException`, verlässt sie `AUFRAEUMEN` und trifft
`AfxCallWndProc` — das Beenden bleibt dann stehen wie vor der Behebung. Das ist
der Fall „kein Speicher", nicht der Fall, den E-42 adressiert.

### (b) Welcher Schritt darf NICHT übersprungen werden?

**Behauptung:** `QCWorkbook::OnClose` ist `CFrameWnd::OnClose`; wird es
verschluckt, wird das Fenster vielleicht nie zerstört.

**Gemessen.** Erst die Auflösung des Aufrufs:

* `QCWorkbook : SECWorkbook` (`Eudora71/Eudora/workbook.h:174`)
* `SECWorkbook : SECMDIFrameWnd` (`Eudora71/OTShim/OTShim.h:1431`)
* `SECMDIFrameWnd : CMDIFrameWnd` (`OTShim/OTShim.h:1082`)
* kein `SECWorkbook::OnClose`, kein `SECMDIFrameWnd::OnClose` in `OTShim/`
  (Suche über `OTShim/` und `Eudora/` ohne Treffer)
* kein `CMDIFrameWnd::OnClose` und kein `ON_WM_CLOSE` in
  `atlmfc/src/mfc/winmdi.cpp`

`QCWorkbook::OnClose()` ist also **genau** `CFrameWnd::OnClose()`.

Dann dessen Rumpf, `atlmfc/src/mfc/winfrm.cpp:843-942`. Die für uns
entscheidenden Zeilen:

| Zeile | was dort geschieht |
|---|---|
| 855 | `pDocument->CanCloseFrame(this)` — Veto des aktiven Dokuments |
| 874 | `pApp->SaveAllModified()` — hier hängen `CDoc::SaveModified` und `CMessageDoc::SaveModified` aus Punkt 3 |
| 885 | `pApp->HideApplication()` — ab hier ist das Hauptfenster unsichtbar |
| 888 | `pApp->CloseAllDocuments(FALSE)` |
| **941** | **`DestroyWindow()`** |

`CMainFrame::OnClose` ruft selbst **kein** `DestroyWindow`. Nachgesehen:
`mainfrm.cpp:5214` bis zum Ende der Funktion bei `5243` stehen nur
`TocCleanup`, `CHostList::Cleanup`, `delete gSearchDoc`, `AutomationStop`,
`pSWM->UnRegister(this)` und Spurmarken. Die einzige Zerstörung des
Hauptfensters auf dem ganzen Weg ist `winfrm.cpp:941`.

Und daran hängt der Rest: `ExitInstance` wird erst erreicht, wenn das Fenster
zerstört ist (der Kommentar in `eudora.cpp:2022-2027` sagt es, und
`CWnd::OnNcDestroy` → `AfxPostQuitMessage` bestätigt die Kette).

**Urteil: bestätigt — mit einer wichtigen Einschränkung.**

Ja: fällt in `QCWorkbook::OnClose` eine `CException`, springt `AUFRAEUMEN`
hinter `winfrm.cpp:941`, `DestroyWindow` läuft nie, es kommt kein `WM_QUIT`,
`ExitInstance` wird nie erreicht — Eudora läuft weiter. Fällt der Wurf **nach**
`winfrm.cpp:885`, ist das Fenster dabei schon versteckt: ein Prozess ohne
Fenster und ohne Taskleisteneintrag, den nur der Taskmanager beendet.

Die Einschränkung: **das ist keine neue Gefahr.** Vor E-42 fing dieselbe
Ausnahme `AfxCallWndProc` (`atlmfc/src/mfc/wincore.cpp:252-278`),
`AfxProcessWndProcException` zeigte die Meldung und lieferte 0 — auch dann lief
`DestroyWindow` nicht. Das Ergebnis ist identisch. E-42 **erbt** diesen Hänger,
es erzeugt ihn nicht. Was E-42 hier ändert, ist nur die Sichtbarkeit: vorher
sah Gregor „Encountered an improper argument", jetzt passiert nichts und die
Begründung landet in einem Protokoll, das standardmäßig nicht geschrieben wird
(siehe „Was die Behebung kostet", Abschnitt Protokoll).

**Empfehlung:** `QCWorkbook::OnClose` aus `AUFRAEUMEN` herausnehmen und
stattdessen so behandeln:

```
TRY { QCWorkbook::OnClose(); }
CATCH_ALL(e) { ...protokollieren...; if (::IsWindow(m_hWnd)) DestroyWindow(); }
END_CATCH_ALL
```

Damit ist der einzige Schritt, dessen Überspringen das Beenden hängen lässt,
auch der einzige mit einer Ersatzhandlung. Kein anderer der zwölf Schritte
braucht das.

### (c) Was wird jetzt nicht gespeichert?

Siehe den eigenen Abschnitt „Was die Behebung kostet". **Urteil: teilweise** —
zwei der zwölf Schritte kosten wirklich etwas, einer davon kann den nächsten
Start verändern; die anderen zehn sind belegbar folgenlos oder rein kosmetisch.

### (d) Läuft eine Speicherschutzverletzung weiter durch?

**Behauptung:** `CATCH_ALL` fängt nur `CException*`.

**Gemessen.** `afx.h:870`: `CATCH_ALL(e)` ist `} catch (CException* e) {`. Ein
typisierter `catch` kann eine strukturierte Windows-Ausnahme nie annehmen; und
der Bau ist `/EHsc` (Beleg oben aus `CL.command.1.tlog`), unter dem selbst
`catch (...)` keine SEH-Ausnahme fängt. Es gibt keinen
`_set_se_translator`-Aufruf im ganzen Quellbestand (Suche über
`Eudora71/**/*.cpp,*.h` ohne Treffer).

Wohin sie stattdessen geht, ist ebenfalls belegt:
`ExceptionHandler.cpp:107` setzt `SetCrashHandlerFilter(QCCrashHandler)`, das in
`EuMemMgr/BugslayerUtil/CrashHandler.cpp:190` auf
`SetUnhandledExceptionFilter` läuft. Eine Zugriffsverletzung in einem der zwölf
Schritte erzeugt also einen Minidump und beendet den Prozess.

**Urteil: bestätigt.** Und das ist hier die gute Nachricht: `AUFRAEUMEN`
verwandelt einen Absturz nicht in einen stillen Hänger. Es wirkt ausschließlich
auf `CException`-Würfe, also genau auf `ENSURE`/`ENSURE_VALID`/`ENSURE_ARG` und
`AfxThrow*` — die Klasse, die E-33 verursacht hat.

---

## 2. E-41 — `CMainFrame::OnSysCommand` (`mainfrm.cpp:5454-5515`)

### (a) Kann daraus eine Endlosschleife werden?

**Gemessen.** `PostMessage(WM_CLOSE)` läuft nur, wenn `CFrameWnd::OnSysCommand`
geworfen **hat** (`mainfrm.cpp:5505`). Für eine Schleife müsste der
`WM_CLOSE`-Weg wieder ein `SC_CLOSE` an dasselbe Fenster erzeugen. Alle
`SC_CLOSE`-Absender im Bestand nachgesehen:

| Fundstelle | Ziel |
|---|---|
| `Eudora/workbook.h:67, :119` | `QCWorksheet` / `QCControlBarWorksheet` — MDI-Kindfenster, nicht das Hauptfenster |
| `Eudora/tocdoc.cpp:2749`, `EuImap/src/ImapToc.cpp:1044, 1702, 1915, 2065, 3563, 4882, 4906` | jeweils `Frame` bzw. `m_FrameWnd` eines Postfachs, nicht `CMainFrame` |
| `SwMapi/dialog.cpp:237` | eigener Dialog |
| `Eudora/FileBrowseView.cpp:2221` | `AfxGetMainWnd()->PostMessage(**WM_COMMAND**, SC_CLOSE)` — falsche Nachricht, landet nie in `OnSysCommand` |

Kein Absender schickt `WM_SYSCOMMAND/SC_CLOSE` an `CMainFrame`. `OnClose` und
`CloseDown` (`mainfrm.cpp:5111-5452`) enthalten keinen.

**Urteil: widerlegt.** Eine Endlosschleife ist nicht konstruierbar. Pro
eintreffendem `SC_CLOSE` gibt es höchstens ein nachgeschicktes `WM_CLOSE`.

### (b) Wird `WM_CLOSE` doppelt verarbeitet?

**Gemessen.** `CFrameWnd::OnSysCommand` (`winfrm.cpp:1111-1142`):

```
1113   CFrameWnd* pFrameWnd = GetTopLevelFrame();
1114   ENSURE_VALID(pFrameWnd);          <- der einzige Wurf
...    Hilfemodus-Zweig (m_bHelpMode)
1141   CWnd::OnSysCommand(nID, lParam); <- letzte Anweisung, danach nichts
```

Der Wurf steht in der **ersten** wirksamen Anweisung. Zu diesem Zeitpunkt ist
nichts geschehen — kein `DefWindowProc`, kein `WM_CLOSE`. „Teilweise
durchgelaufen" gibt es hier nicht.

Der Weg über `CWnd::OnSysCommand` → `Default()` → `DefWindowProc` erzeugt
`WM_CLOSE` **synchron**. Wirft dabei etwas in `CMainFrame::OnClose`, wird es
nicht von diesem `TRY` gefangen, sondern von dem `AfxCallWndProc` der
verschachtelten Zustellung (`wincore.cpp:252-278` — jede Zustellung hat ihr
eigenes `CATCH_ALL`). `bSystemwegOk` bleibt dann `TRUE`, es wird nichts
nachgeschickt.

Der Wächter `::IsWindow(m_hWnd)` (`mainfrm.cpp:5505`) fängt zusätzlich den Fall,
dass das Fenster bereits zerstört wurde.

**Urteil: widerlegt.** Eine doppelte Verarbeitung ist nicht herstellbar.
Restrisiko, nur der Vollständigkeit halber und ohne Beleg für einen Weg dorthin:
würde eine Ausnahme irgendwann **nach** `winfrm.cpp:1141` entstehen, nachdem
`CloseDown` den Anwender gefragt und er abgebrochen hat, käme die Rückfrage ein
zweites Mal. Nach dem gelesenen Quelltext gibt es nach Zeile 1141 keine
Anweisung mehr, die werfen könnte.

### (c) Ist die Maskierung richtig?

**Gemessen.** `(nID & 0xFFF0) == SC_CLOSE` ist genau das, was die
Windows-Dokumentation für `WM_SYSCOMMAND` fordert: die vier untersten Bits von
`wParam` benutzt das System selbst. `SC_CLOSE` ist `0xF060`; die Maske deckt
`0xF060`–`0xF06F`. Die Nachbarn liegen bei `0xF050` (`SC_PREVWINDOW`) und
`0xF070` (`SC_VSCROLL`) — kein anderer Systembefehl fällt hinein.

`ID_SYSTEM_MENU_CHECKMAIL` ist `32907` = `0x808B` (`Eudora/resource.h:4094`),
`0x808B & 0xFFF0` = `0x8080` ≠ `0xF060`. Kein Zufallstreffer, und der Vergleich
steht ohnehin vorher.

**Urteil: bestätigt.**

**Nebenbefund, nicht aus dieser Behebung:** `CMainFrame::PreTranslateMessage`
prüft `pMsg->wParam == SC_CLOSE` **ohne** Maske (`mainfrm.cpp:3024`) und
schluckt die Nachricht, solange der Anpassen-Dialog offen ist. Die beiden
Stellen behandeln dasselbe Ereignis nach zwei verschiedenen Regeln. Zusätzlich
sieht `PreTranslateMessage` nur *gepostete* Nachrichten; das `WM_SYSCOMMAND`
aus Alt-F4 erzeugt `DefWindowProc` per `SendMessage` und läuft dort nie durch.
Für E-41 ohne Folge, für den Anpassen-Dialog wahrscheinlich ein eigener Befund.

### (d) Läuft `ID_SYSTEM_MENU_CHECKMAIL` noch, und kehrt es richtig zurück?

**Behauptung:** „Ich habe dort ein `return;` eingefügt, das vorher nicht da war."

**Gemessen.** Die Fassung vor `269f3b5` (aus `git show 269f3b5^`, Zeilen
5422-5431):

```
VOID CMainFrame::OnSysCommand(UINT nID, LPARAM lParam)
{
    if (nID == ID_SYSTEM_MENU_CHECKMAIL)
    {
        g_pApp->OnCheckMail();
    } else
        CFrameWnd::OnSysCommand(nID,lParam);

    return;
}
```

Das alte `else` hat `CFrameWnd::OnSysCommand` im Prüfmail-Fall **genauso**
verhindert wie das neue `return;`. Beide Fassungen rufen `OnCheckMail()` und
verlassen die Funktion.

**Urteil: die Sorge ist widerlegt.** Das `return;` ändert das Verhalten nicht;
es macht nur explizit, was das `else` implizit tat. `ID_SYSTEM_MENU_CHECKMAIL`
läuft unverändert und kehrt richtig zurück.

---

## 3. E-40 — `CDoc::SaveModified` (`doc.cpp:50-103`) und `CMessageDoc::SaveModified` (`msgdoc.cpp:940-1091`)

### (a) Was kann `AfxMessageBox` mit `MB_YESNOCANCEL` wirklich liefern?

**Gemessen.** `AfxMessageBox(LPCTSTR, UINT, UINT)` ist
`atlmfc/src/mfc/appui1.cpp:136-147`: es delegiert an
`pApp->DoMessageBox(...)`, das über `CWinApp::ShowAppMessageBox`
(`appui1.cpp:~122`) auf `::MessageBox` läuft. Es gibt keine MFC-eigene
Umrechnung des Rückgabewerts.

`::MessageBox` mit `MB_YESNOCANCEL` liefert `IDYES` (6), `IDNO` (7),
`IDCANCEL` (2) — auch beim Schließen mit Esc oder dem Kreuz — oder **0**, wenn
das Fenster nicht erzeugt werden kann. Alle drei Antworten haben eigene
Zweige. In `default` fällt also **nur die 0**.

Eine Ausnahme, die im ausgelieferten Programm nicht auftritt, aber
festgehalten gehört: überschreibt jemand `CWinApp::DoMessageBox`, kann jeder
Wert kommen. Im Bestand tut das genau ein Ort, und der liefert `IDOK` (= 1) —
`Eudora71/Tests/OTShimProbe.cpp:31-42`. Wer `SaveModified` je unter dem
Testprogramm laufen lässt, landet damit im `default`-Zweig. Im Eudora-Projekt
selbst gibt es keine Überschreibung (Suche `DoMessageBox` über
`Eudora71/**` — Treffer nur in `Tests/`).

**Urteil: bestätigt.** Der `default`-Zweig ist der Fall „niemand hat
entschieden", und die alte Rückgabe FALSE („Abbrechen") war dafür falsch.

### (b) Was verliert der Anwender, wenn `default` durchläuft?

**`CDoc`** (`doc.cpp:84-101`): nach dem `break` läuft
`SetModifiedFlag(FALSE)` und `return TRUE`. Die Änderungen des Dokuments
werden **nicht gespeichert und verworfen**. Betroffen sind die von `CDoc`
abgeleiteten Dokumente (Filter, Rufnamen, Briefpapier, Signaturen).
Vorher blieb das Dokument geändert und offen, der Anwender konnte danach noch
speichern; jetzt ist der Inhalt weg. Das ist ein echter, wenn auch sehr
seltener Datenverlust — er tritt nur ein, wenn `AfxMessageBox` 0 liefert, also
in einer Lage, in der der Anwender ohnehin nicht gefragt werden kann.

**`CMessageDoc`** (`msgdoc.cpp:1056-1089`): dasselbe für eine Nachricht in
Bearbeitung — getippter Text einer Verfassen-Nachricht wird verworfen. Dazu
kommen die beiden Dinge, nach denen Du gefragt hast:

* Das **Löschen der Anhangs- und Einbettungsdateien** hängt am `IDNO`-Zweig
  (`msgdoc.cpp:1039-1050`) und wird übersprungen. Aber:
  `msgdoc.cpp:1086-1087` löscht `m_pAssociatedFiles` in **jedem** Zweig. Die
  Pfadliste ist danach weg, die Dateien liegen noch auf der Platte. Ergebnis:
  verwaiste temporäre Dateien, die niemand mehr aufräumt. Nicht schlimm für
  Daten, aber Müll, den nur der Anwender findet.
* `InvalidateCachedPreviewSummary` (`msgdoc.cpp:1052-1053`) wird ebenfalls
  übersprungen. Folge: der zwischengespeicherte Vorschautext im Postfach bleibt
  auf dem alten Stand, bis Eudora neu startet. Rein kosmetisch.

**Urteil: bestätigt, mit einem Änderungsvorschlag.** Der `default`-Zweig
behandelt „niemand hat entschieden" derzeit wie `IDNO` („verwerfen"). Wenn
niemand entschieden hat, ist `IDYES` („speichern") die sicherere Vorgabe:
`if (!DoSave(m_strPathName, TRUE)) { ...protokollieren... }` und dann weiter.
Damit bleibt das Beenden entblockt **und** der Inhalt erhalten. Zwei Zeilen
Unterschied, und der einzige Datenverlust dieser Behebung fällt weg.

### (c) Ist `doc.cpp` mit dem neuen `#include "debug.h"` in Ordnung?

**Gemessen.** `debug.h` hat einen Wächter (`_EUDORA_DEBUG_H_`,
`QCUtils/public/inc/debug.h:6-7, 100`), Doppelaufnahme ist also harmlos. Und
sie liegt vor: `Eudora/stdafx.h:54` nimmt `qcassert.h` auf, das in
`QCUtils/public/inc/qcassert.h:38-39` `debug.h` nachzieht, weil `NOEXPRLOG`
nicht definiert ist — `NOEXPRLOG` steht im ganzen Bestand nur in
`Eudora71/Tests/Tests.vcxproj:43`.

**Urteil: die Aufnahme ist redundant, aber nicht falsch.** Sie ist sogar die
bessere Form: sie macht `doc.cpp` von der Reihenfolge in `stdafx.h`
unabhängig. Kein Handlungsbedarf.

---

## 4. E-37, zweiter Anlauf — `CPersonalityView::OnCmdDeletePersonality`

Geprüft gegen die Momentaufnahme des Hauptbaums (Kopfzeile), dort Zeilen
920-1041. Der Prüfstand `d003d46` enthält diese Fassung nicht.

### (a) Trägt Spalte 0 immer genau den Namen, den `Remove` bekommt?

**Gemessen — die Kette ist geschlossen:**

1. `PopulateView` (`PersonalityView.cpp:219-232`) setzt `theItem.pszText` auf
   die Zeichenkette aus `g_Personalities.List()` und trägt sie mit
   `iSubItem = 0` ein.
2. `CPersonality::List()` (`persona.cpp:626-670`) liefert die INI-Einträge
   **ohne** das Präfix (`strcpy(m_ListBuf, &Entry[csPersonaPreface.GetLength()])`,
   Zeile 643) und stellt `CRString(IDS_DOMINANT)` voran (Zeilen 650-652). Der
   angezeigte Text des Dominant-Eintrags ist also **genau** die Zeichenkette,
   gegen die `OnCmdDeletePersonality:940` mit `CRString(IDS_DOMINANT) == strName`
   prüft. Ein Name mit Leerzeichen wird nirgends verändert — kein Trimmen, kein
   Kürzen.
3. `GetSelectedPersonalities` (`PersonalityView.cpp:296`) holt den Namen mit
   `theCtrl.GetItemText(nIndex, 0)`, also aus **derselben** Spalte.
4. Die neue Suche vergleicht `theCtrl.GetItemText(iZeile, 0) == strName`.

Beide Seiten des Vergleichs stammen aus derselben Funktion auf derselben
Spalte. Der Treffer ist damit **konstruktiv garantiert**, solange die Liste
zwischen Schritt 3 und 4 nicht neu aufgebaut wird — und genau das tut der
zweite Anlauf nicht mehr.

Zwei Nebenmessungen, die die Sache stützen:

* Die Liste ist **nicht** sortiert: `OnInitialUpdate` setzt `LVS_REPORT`,
  `LVS_ICON` und `LVS_NOSORTHEADER`, kein `LVS_SORTASCENDING`
  (`PersonalityView.cpp:163-167`). Die Reihenfolge ändert sich also nicht
  unter dem Zugriff.
* Es gibt genau **eine** `CPersonalityView`-Instanz:
  `PersonalityWazooWnd.cpp:85` erzeugt sie, `:95-96` trägt sie mit einem
  `ASSERT(NULL == pMainWnd->m_pActivePersonalityView)` als einzige ein. Die
  Liste links im Fenster ist dieselbe, die der Befehl bearbeitet — es gibt
  keine zweite Ansicht, die stehenbleiben könnte.

**Urteil: bestätigt.**

### (b) Groß-/Kleinschreibung: passt `CString ==` zu `Remove`?

**Gemessen.** `operator==(const CString&, const CString&)` vergleicht über
`Compare`, also `strcmp` — **unterscheidend**. `CPersonality::Remove` benutzt
`strcmpi (persona.cpp:536)` — **nicht unterscheidend**.

Für den Löschweg ist das ohne Wirkung: `strName` **ist** der Text der Spalte 0,
Byte für Byte, und `List()` baut Spalte 0 aus denselben INI-Einträgen, die
`Remove` durchsucht. Ein Unterschied in der Schreibweise kann zwischen diesen
beiden Punkten nicht entstehen.

Die einzige Abweichung, die aus dem Quelltext folgt: stehen in `[Personality]`
zwei Einträge, die sich nur in der Schreibweise unterscheiden, zeigt `List()`
beide an, `Remove` entfernt aber den **ersten** Treffer nach `strcmpi` — unter
Umständen den anderen als den markierten. Dann verschwindet in der Liste die
angeklickte Zeile, aus der INI aber der andere Eintrag. Belegt aus
`persona.cpp:532-540`; ob eine Eudora.ini so aussehen kann, habe ich nicht
geprüft (Eudora selbst legt beim Hinzufügen keinen zweiten gleichnamigen
Eintrag an, `persona.cpp:238-244` prüft mit `strcmpi`).

**Urteil: teilweise.** Der Vergleich ist strenger als `Remove`, und für diesen
Weg ist das richtig, weil beide Seiten aus derselben Quelle kommen. Der
strengere Vergleich ist hier sogar der sicherere: er trifft nur die Zeile, die
der Anwender wirklich markiert hat.

### (c) Warum hat `PopulateView()` geworfen?

**Was ich belegen kann:**

* Die Meldung „Encountered an improper argument" ist MFCs Text für
  `CInvalidArgException` — sie entsteht ausschließlich aus
  `AfxThrowInvalidArgException`, also aus `ENSURE`, `ENSURE_ARG` oder
  `ENSURE_VALID`.
* Die Listensteuerung selbst kann sie **nicht** geworfen haben. Ich habe alle
  von `PopulateView` benutzten `CListCtrl`-Funktionen aufgesucht:
  `DeleteAllItems`, `InsertItem`, `SetItemText` (`winctrl2.cpp:541-549`),
  `SetItemState` (`winctrl2.cpp:~530`), `GetItemCount`. Keine enthält `ENSURE`
  oder `AfxThrowInvalidArg` — Suche über `include/afxcmn.inl` und
  `include/afxcmn2.inl` findet nur `LVM_ENSUREVISIBLE` und `TVM_ENSUREVISIBLE`,
  also Namensähnlichkeit, keine Prüfung.
* `CPersonalityView` hat keinen `LVN_DELETEITEM`- oder
  `LVN_DELETEALLITEMS`-Behandler (Nachrichtentabelle,
  `PersonalityView.cpp:74-115`). `DeleteAllItems()` löst also keinen
  Eudora-Code aus.
* `PopulateView` läuft beim Öffnen der Ansicht fehlerfrei
  (`PersonalityView.cpp:189`, aus `OnInitialUpdate`). Der Unterschied liegt
  also nicht in der Funktion, sondern im Zustand, in dem sie das zweite Mal
  gerufen wird.
* Der Zustand nach `Remove` ist nachweislich ein anderer:
  `persona.cpp:572` ruft `g_thePersonalityDirector.DeleteCommand(Name)` (das
  Menü „Message : Change : Personality" wird umgebaut), `:574` setzt
  `m_bListStale = TRUE`, `:576-577` postet `msgTaskViewUpdateCols`.
* `PopulateView` ruft in der Schleife `g_Personalities.SetCurrent()`
  (`PersonalityView.cpp:244`), und `SetCurrent` ist nicht harmlos: es ruft
  `SavePassInfo`, `FlushINIFile`, `RemoveAllFromCache`, `RestorePassInfo`
  (`persona.cpp:188-202`), schreibt also mitten in der Schleife die INI und
  wirft den ganzen INI-Zwischenspeicher weg.

**Vermutung, ausdrücklich nicht belegt:** die wahrscheinlichste Quelle ist
nicht die Liste, sondern der Umweg über `SetCurrent` — entweder weil
`g_Personalities.GetCurrent()` beim Wiederherstellen am Ende
(`PersonalityView.cpp:262`) auf eine gerade gelöschte Persönlichkeit zeigt,
deren INI-Abschnitt `Remove` (`persona.cpp:566`) bereits entfernt hat, oder
weil das durch `DeleteCommand` umgebaute Menü beim nächsten
Befehlszustandsdurchlauf in eine `ENSURE`-Prüfung läuft. Beides ist mit den
mir erlaubten Mitteln (nicht bauen, nicht starten) nicht entscheidbar.

**Urteil: nicht belegbar — aber die Frage ist entschärft.** Der zweite Anlauf
ruft `SetCurrent` nicht mehr und hängt nicht mehr davon ab, warum
`PopulateView` warf. Er ist außerdem selbstdiagnostizierend: findet die
Textsuche die Zeile nicht, sagt es die Protokollzeile
(`PersonalityView.cpp:1005-1011`), und damit wäre widerlegt, dass Spalte 0 den
Namen trägt. Das ist die richtige Bauform für eine ungeklärte Ursache.

### (d) Bleibt beim Löschen mehrerer markierter Konten alles richtig?

**Gemessen.** `GetSelectedPersonalities` sammelt **alle** Namen, **bevor**
gelöscht wird (`PersonalityView.cpp:290-298`); die Namensliste ist danach von
der Steuerung unabhängig. In jedem Schleifendurchlauf wird der Index neu über
`GetItemCount()` und die Textsuche bestimmt (`:989-997`). Ein Index aus einem
früheren Durchlauf wird nie wiederverwendet. Die Liste darf also unter der
Schleife beliebig schrumpfen.

**Urteil: bestätigt.** Zwei kleine Punkte, kein Fehler:

* `lvFindInfo` (`PersonalityView.cpp:932-934`) wird noch gefüllt, aber nicht
  mehr benutzt — toter Code, der beim Lesen den Eindruck erweckt, es werde noch
  mit `FindItem` gesucht. Sollte weg.
* Nach dem Löschen setzt niemand den Fokus neu. `PopulateView` tat das
  (`:257`, `SetItemState(0, LVIS_FOCUSED, ...)`), der zweite Anlauf nicht.
  Folge: die Liste hat danach unter Umständen kein Fokusfeld, der Fokusrahmen
  fehlt bis zum nächsten Klick. Kosmetisch.

---

## Was die Behebung kostet

Alle zwölf Schritte, jeder einzeln nachgesehen. „Schwere" ist mein Urteil, die
Spalte „Folge" ist gemessen.

| # | Schritt | was ausfällt, wenn er übersprungen wird | Schwere |
|---|---|---|---|
| 1 | `CloseImapConnections` | `CImapMailbox::Close` (`EuImap/src/ImapMailbox.cpp:929-945`) gibt **nur** die Verbindung frei; der Kommentar Zeile 933 sagt ausdrücklich „Don't update the imap info file at this time". Kein lokaler Datenverlust; die Verbindung schließt das Betriebssystem beim Prozessende. | folgenlos |
| 2 | `EmptyTrash` | Der Papierkorb wird nicht geleert, obwohl die Option gesetzt ist. Es geht nichts verloren — im Gegenteil, es bleibt mehr erhalten als gewollt. | kosmetisch |
| 3 | `CleanSSLLibrary` | SSL-Ressourcen im eigenen Prozess. Der Prozess endet ohnehin. | folgenlos |
| 4 | `TrayItem(NIM_DELETE)` | Das Symbol im Infobereich bleibt als Geist stehen, bis der Anwender mit der Maus darüberfährt. | kosmetisch |
| 5 | `DeleteMenuObjects` | C++-Menüobjekte werden nicht freigegeben. Speicher eines endenden Prozesses. | folgenlos |
| 6 | `QCWorkbook::OnClose` | **`DestroyWindow` läuft nie** (`winfrm.cpp:941`). Kein `WM_QUIT`, kein `ExitInstance`. Zusätzlich: das nachgelagerte `IniStringCleanUp()` (`eudora.cpp:2118` → `rs.cpp:1433-1436` → `FlushINIFile`) fällt mit aus, also bleiben **alle** noch nicht geschriebenen INI-Änderungen dieser Sitzung ungeschrieben. Fällt der Wurf nach `winfrm.cpp:885`, ist das Fenster dabei bereits versteckt. | **schwer** |
| 7 | `TrimJunk` | Das Junk-Postfach wird nicht gekürzt und wächst weiter. Kein Verlust. | kosmetisch |
| 8 | `RemoveBogusAdToolBars` | Reine Werbeleisten bleiben registriert (`mainfrm.cpp:6133-6182` löscht sie nicht, es meldet sie nur ab). Der **nächste** Schritt `SaveBarState` schreibt sie dann mit in die INI: beim nächsten Start stehen leere Werbeleisten im Fenster. | mittel |
| 9 | `SaveBarState("ToolBar")` | Der Leistenzustand dieser Sitzung wird nicht gespeichert: Anordnung, Andockung und **alle Anpassungen der Werkzeugleiste** fallen auf den letzten gespeicherten Stand zurück. Bricht der Schritt *mitten* im Schreiben ab, steht ein halber `[ToolBar-xxx]`-Abschnitt in der INI — laut dem Kommentar in `mainfrm.cpp:1356-1358` ist genau das die Lage, in der MFCs `LoadBarState()` beim nächsten Start abstürzen kann. | **mittel bis schwer** |
| 10 | `SaveWazooBarConfigToIni` | Die Größen der angedockten und schwebenden Wazoo-Fenster gehen auf den letzten Stand zurück. | mittel |
| 11 | `SaveCrashStateToINI` | Die führende `0` in `LastKnownCrashInfo` bleibt stehen (`ExceptionHandler.cpp:391-412`). Beim nächsten Start hält Eudora das für einen möglichen Absturz. Alle Auswerter nachgesehen: `m_bEudoraCrashedDuringLastRun` wird **ausschließlich** in `ExceptionHandler.cpp:379` benutzt und legt dann eine Sicherheitskopie von `EudoraCrashDump.dmp` an — und nur, wenn eine solche Datei überhaupt existiert. Keine Postfachprüfung, keine Meldung, kein Datenverlust. | folgenlos |
| 12 | `WriteToolBarMarkerToIni` | Zwei Dinge. (a) Der Versionsmarker `Commercial32Version` wird nicht geschrieben und der gegenläufige nicht gelöscht (`mainfrm.cpp:1321-1347`). Beim nächsten Start entscheidet `FlushIncompatibleToolBarState` (`mainfrm.cpp:1363-1400`) auf „unverträglich" und **löscht die `[ToolBar-xxx]`-Abschnitte** — die Leistenanordnung ist weg. Das greift nur, wenn der Marker nicht schon von einem früheren saubern Beenden stimmt. (b) Das `FlushINIFile()` in Zeile 1349 fällt aus; das ist folgenlos, weil `ExitInstance` über `IniStringCleanUp()` (`eudora.cpp:2118`, `rs.cpp:1433-1436`) noch einmal flusht — **vorausgesetzt**, Schritt 6 ist durchgelaufen. | mittel |

**Die Antwort auf Deine Hauptfrage, in einem Satz:** von den zwölf Schritten
kann **genau einer** — `QCWorkbook::OnClose` — das Beenden hängen lassen, weil
nur er `DestroyWindow` ausführt; **Daten** verliert kein einziger, mit einer
Ausnahme in Schritt 9/12, wo nicht Daten, sondern die **Leisten- und
Fensteranordnung** verloren geht oder beim nächsten Start gelöscht wird.

**Und ein Kostenpunkt, der in keiner der zwölf Zeilen steht: das Protokoll ist
im Normalbetrieb stumm.** `PutDebugLog` kehrt sofort zurück, wenn die Maske
nicht passt oder keine Protokolldatei offen ist:

```
QCUtils/src/debug.cpp:140-145
  if ((QCLogFileMT::DebugMask & ID) == 0 || !QCLogFileMT::s_pLogFile) return;
```

`DebugMask` ist mit `0` vorbelegt (`debug.cpp:22`) und wird nur aus der
INI-Einstellung `DebugLogLevel` gesetzt (`debug.cpp:112-119`). Alle
E-40-, E-41-, E-42- und E-37-Meldungen brauchen `DEBUG_MASK_MISC` (0x8000)
oder `DEBUG_MASK_TOC_CORRUPT` (0x80). Steht `DebugLogLevel` nicht auf einem
Wert mit einem dieser Bits, sieht Gregor bei einem Fehlschlag **nichts** — die
Meldung „Encountered an improper argument" ist weg, und die Erklärung landet
nirgends. Vor der Behebung war das Symptom sichtbar und die Ursache unklar;
jetzt ist beides unsichtbar. Das ist der Preis, den ich für den größten halte.

**Empfehlung dazu:** entweder in `PORTIERUNG.md`/`README.md` eine Prüfanleitung
mit dem nötigen `DebugLogLevel` aufnehmen, oder — besser — die
E-4x-Fehlschläge zusätzlich in die `Exception.log` schreiben, die
`QCExceptionHandler::ReportSilentFailure` (`ExceptionHandler.cpp:156ff.`)
ohnehin unabhängig von der Debug-Maske führt.

---

## Was ich nicht prüfen konnte

1. **Nichts gebaut, nichts gestartet** (Auflage). Alle Urteile stammen aus dem
   Quelltext, den MFC-Quellen von VS 2022 (14.38.33130) und dem echten
   Compileraufruf im `.tlog`. Kein Urteil beruht auf einem Lauf.
2. **Der Grund für den Wurf in `PopulateView`** (Punkt 4c). Ohne Lauf mit
   Haltepunkt oder mit gesetztem `DebugLogLevel` nicht entscheidbar. Was ich
   ausschließen konnte, steht dort; der Rest ist als Vermutung gekennzeichnet.
3. **Punkt 4 gegen einen unversionierten Stand.** `PersonalityView.cpp` liegt im
   Hauptbaum geändert und nicht committet. Die geprüfte Momentaufnahme ist im
   Kopf mit MD5 festgehalten. Ändert sich die Datei noch, gilt dieses Urteil für
   sie nicht mehr.
4. **Ob es die zwölf Ausnahmen im Betrieb überhaupt gibt.** Ich habe geprüft,
   *was passiert, wenn* ein Schritt wirft — nicht, welcher von ihnen bei Gregor
   tatsächlich wirft. Das steht im Protokoll, sobald `DebugLogLevel` gesetzt
   ist, und nur dann.
5. **Tests.** Es gibt keine für diese Behebung, und mit dem heutigen
   Testprojekt sind auch keine möglich: `Eudora71/Tests/Tests.vcxproj:70-90`
   übersetzt ausschließlich `OTShim`-, `secaux`- und Testdateien, keine
   einzige Datei aus `Eudora71/Eudora`. `mainfrm.cpp`, `doc.cpp`, `msgdoc.cpp`
   und `PersonalityView.cpp` sind dort nicht erreichbar. Was ohne großen
   Umbau prüfbar wäre:
   * **Das Makro `AUFRAEUMEN` selbst** — wenn es aus `mainfrm.cpp` in einen
     Header wanderte, könnte ein Test in `Tests/` belegen: `CException` wird
     gefangen, die Ausführung läuft weiter, der Name steht in der Meldung, und
     ein Wurf, der keine `CException` ist, läuft durch. Achtung: `Tests`
     definiert `NOEXPRLOG` (`Tests.vcxproj:43`), dort zieht `qcassert.h` kein
     `debug.h` nach — ein solcher Test braucht die Aufnahme ausdrücklich.
   * **Die Maske aus E-41** — `(nID & 0xFFF0) == SC_CLOSE` als freie Funktion,
     Tabellentest über alle `SC_*`-Werte und über `ID_SYSTEM_MENU_CHECKMAIL`.
   * **Die Entscheidungstabelle aus E-40** — dafür müsste der `switch` aus
     `SaveModified` in eine freie Funktion `SaveModifiedEntscheidung(int)`
     mit vier Ausgängen (Abbrechen / Speichern / Verwerfen / Fortsetzen)
     herausgezogen werden. Das ist die einzige der drei Behebungen, deren Kern
     eine reine Entscheidung ist, und der Umbau kostet wenige Zeilen.
6. **Zeilenenden und Kodierung** habe ich gemessen, nicht nur angenommen: CR-Zahl
   von `mainfrm.cpp`, `doc.cpp`, `msgdoc.cpp`, `PersonalityView.cpp` ist in
   `d003d46` identisch mit `567a5d8` (18 / 0 / 18 / 18), keine Zeile mit Bytes
   über 0x7F. Auch die unversionierte `PersonalityView.cpp` im Hauptbaum hat 18
   CR. Nichts kaputtgeschrieben.

---

## Urteilstabelle

| Punkt | Frage | Urteil |
|---|---|---|
| 1a | Makro `AUFRAEUMEN` sauber — `do/while(0)`, Schachtelung, `e` | **bestätigt** |
| 1b | Überspringen von `QCWorkbook::OnClose` kann das Beenden hängen lassen | **bestätigt** (aber schon vor E-42 so — geerbt, nicht neu) |
| 1c | Es wird etwas nicht gespeichert, was der Anwender erwartet | **teilweise** — Leisten- und Fensteranordnung ja, Nachrichten und Postfächer nein |
| 1d | Speicherschutzverletzung läuft durch `CATCH_ALL` hindurch | **bestätigt** (`/EHsc` aus `CL.command.1.tlog`) |
| 2a | Endlosschleife `WM_CLOSE` → `SC_CLOSE` möglich | **widerlegt** |
| 2b | `WM_CLOSE` wird doppelt verarbeitet | **widerlegt** — `ENSURE_VALID` ist die erste Anweisung |
| 2c | Maskierung `(nID & 0xFFF0) == SC_CLOSE` richtig, trifft nichts anderes | **bestätigt** |
| 2d | Das neue `return;` bei `ID_SYSTEM_MENU_CHECKMAIL` ändert das Verhalten | **widerlegt** — das alte `else` tat dasselbe |
| 3a | Nur die 0 fällt in `default` | **bestätigt** (Ausnahme: eine überschriebene `DoMessageBox`, im Bestand nur in `Tests/`) |
| 3b | Der `default`-Zweig kostet den Anwender etwas | **bestätigt** — verworfene Dokument-/Nachrichtenänderung, verwaiste Anhangsdateien, veralteter Vorschautext |
| 3c | Das neue `#include "debug.h"` in `doc.cpp` war nötig | **widerlegt** — `debug.h` kam schon über `stdafx.h` → `qcassert.h`; die Aufnahme ist redundant, aber richtig |
| 4a | Spalte 0 trägt genau den Namen, den `Remove` bekommt | **bestätigt** — Kette `List()` → Spalte 0 → `GetItemText` geschlossen |
| 4b | `CString ==` passt zu `Remove` mit `strcmpi` | **teilweise** — strenger als `Remove`, hier folgenlos und sogar sicherer |
| 4c | Warum `PopulateView()` geworfen hat | **nicht belegbar** — Liste ausgeschlossen, Rest Vermutung; Frage durch den zweiten Anlauf entschärft |
| 4d | Mehrfachauswahl bleibt richtig, während die Liste schrumpft | **bestätigt** |

**Offene Empfehlungen, nach Gewicht:**

1. `QCWorkbook::OnClose` aus `AUFRAEUMEN` herausnehmen und im Fehlerfall
   `DestroyWindow()` nachziehen (Punkt 1b). Das ist die einzige Stelle, an der
   die Behebung das Symptom nicht wirklich behebt.
2. Die E-4x-Meldungen unabhängig von `DebugLogLevel` sichtbar machen (Abschnitt
   „Was die Behebung kostet"). Sonst ist der nächste Fehlschlag stumm.
3. `default` in beiden `SaveModified` auf „speichern" statt „verwerfen" stellen
   (Punkt 3b). Zwei Zeilen, und der einzige Datenverlust der Behebung fällt weg.
4. `lvFindInfo` in `OnCmdDeletePersonality` entfernen (Punkt 4d), toter Code.
5. `SaveModifiedEntscheidung` herausziehen, damit E-40 überhaupt testbar wird
   (Abschnitt „Was ich nicht prüfen konnte", Punkt 5).
