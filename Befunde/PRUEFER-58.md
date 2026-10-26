# <a id="pruefer-58"></a>PRUEFER-58 — Spurmarke „improper argument“, E-142-Hinweis, rootcerts-Logzeile und E-146, nachgerechnet, 26.10.2026

**Auftrag.** Geprüft wurde, was seit `07f181dc` in `Eudora71/`, `tools/` und
`Releases/1.0` dazukam (`e0e811f5`, `4e065f5b`, `33c694d8`, `62f6047c`,
`2fbc35d4`). Das sind vier Behebungen und die Änderung am IMAP-Prüfserver.
Eudora wurde weder gebaut noch gestartet. Kein Prüfstand unter `C:\Temp` wurde
angefasst. Die Testsuite lief nur in meinem Arbeitsbaum. Den Prüfserver habe
ich auf einem eigenen Port (11439) mit Protokoll im Scratchpad befragt. Die
MFC-Stellen sind in der Quelle auf diesem Rechner nachgelesen
(`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Keiner der Funde hält das Testpaket 7.2.0.123 auf.** Alle vier Behebungen
  tun nach dem Quelltext, was sie sollen. Keine verschlechtert etwas gegenüber
  dem Stand davor.
* **Die Spurmarke für „Encountered an improper argument“ erfasst die Meldung
  auf dem Weg, auf dem die MFC sie zeigt** (am Quelltext belegt). Das gilt
  für jede Fensterbotschaft im Hauptfaden, auch in modalen Dialogen und
  Meldungsfenstern. Es gibt zwei Lücken. [K1](#k1): Eine Ausnahme aus dem
  Leerlauf, aus `PreTranslateMessage` oder aus der Nachbearbeitung einer
  Aufgabe zeigt keine Meldung. Eudora **beendet sich dann wortlos**, ohne
  Logzeile und ohne `ExitInstance`. Das war schon im Original so, ist aber die
  schwerste Lücke. [K2](#k2): Ausnahmen in `UpdateData` von Dialogen zeigt die
  MFC selbst an, an der Spurmarke vorbei.
* **[E-142](../Intern/BEFUNDE.md#e-142), der Hinweis, ist richtig gebaut.** Er kommt einmal je Übertragung,
  vor dem Anlegen der Kopie. „Nein“ überträgt nichts und unterdrückt die
  Meldung „No messages were transferred!“. Beim automatischen Abruf kommt er
  nicht, weil empfangene Post schon vorher an [E-125](../Intern/BEFUNDE.md#e-125) abgelehnt wird. Die ID
  26697 ist in `EudoraRes.dll` nur einmal vergeben. Klein: [K3](#k3) und
  [K4](#k4).
* **Die rootcerts-Logzeile liest wirklich die Wahl von QCSSL** (am Quelltext
  belegt). Es ist dasselbe Objekt per Zeiger über die DLL-Grenze, kein Abzug.
  Jede TLS-Verbindung, auch STARTTLS, läuft durch diese eine Stelle. Klein:
  [K5](#k5).
* **[E-146](../Intern/BEFUNDE.md#e-146) hält.** Es gibt keinen übersehenen Aufrufer, die Nachbearbeitung
  läuft im Hauptfaden, und der Refresh kann keine Schleife bilden. Drei Reste
  aus dem Original bleiben, alle selten: [K6](#k6) ist das Spiegelbild von K9
  (lokal scheitert, Server benennt um). [K7](#k7) ist der Fall „der abgelehnte
  Name existiert am Server schon“, das ist eine Vermutung und noch nicht
  gemessen. [K8](#k8): Das liegengebliebene Verzeichnis ist nicht leer, wie der
  Commit sagt, sondern enthält den alten Zwischenspeicher.
* **Die Musterauswertung im Prüfserver verfälscht die anderen Fälle nach
  meiner Messung nicht** ([K9](#k9)). Nachgemessen am Prüfstand sind [E-118](../Intern/BEFUNDE.md#e-118),
  [E-121](../Intern/BEFUNDE.md#e-121) und E-77d mit dem neuen Server aber noch nicht.
* **Drei Rückfälle bleiben im Test grün** ([K10](#k10), gemessen).

**Testsuite** (gemessen, in meinem Baum): 307 Tests, 307 bestanden, vorher
und mit allen drei Rückfallproben. Die Positivprobe war rot (siehe K10). Jede
geänderte Datei war danach byte-gleich zurück (SHA-1 und `cmp` gegen `HEAD`),
danach `touch`.

## Teil 1 — Spurmarke in `CEudoraApp::ProcessWndProcException`

**Wo die MFC die Meldung zeigt** (am Quelltext belegt). Der Text kommt aus
`CInvalidArgException::GetErrorMessage`. Er erscheint nur, wenn jemand
`ReportError` aufruft. In der MFC geschieht das an genau drei Stellen:

| Stelle | Weg | Von der Spurmarke erfasst? |
|---|---|---|
| `appcore.cpp:1032-1038`, `CWinApp::ProcessWndProcException` | Ausnahme aus einer Fensterbotschaft, gefangen in `AfxCallWndProc` (`wincore.cpp:270-276`) oder `_AfxActivationWndProc` (`:483-489`) | **ja** |
| `wincore.cpp:4384-4390`, `CWnd::UpdateData` | Ausnahme aus `DoDataExchange` | **nein**, [K2](#k2) |
| `afxtagmanager.cpp:209` | Tag-Manager der Feature-Pack-Klassen | in Eudora nicht benutzt (Vermutung) |

In Eudora selbst ruft niemand `ReportError` einer Ausnahme auf. Die einzige
Stelle ist auskommentiert (`PgEmbeddedImage.cpp:2044`).

**Modale Schleifen, Dialoge, Meldungsfenster** (am Quelltext belegt). Auch
dort geht jede Botschaft über `DispatchMessage` → `AfxWndProc` →
`AfxCallWndProc`. Sie ist also erfasst.

**Andere Fäden** (am Quelltext belegt). `AfxProcessWndProcException`
(`thrdcore.cpp:210-217`) fragt `AfxGetThread()`. In einem Faden ohne eigenes
`CWinThread` ist das NULL. Dann läuft `AfxInternalProcessWndProcException`,
ohne Meldung. In einem `CWinThread`-Faden läuft dessen eigene Fassung
(`thrdcore.cpp:780`), ebenfalls ohne Meldung. Die Meldung, die Gregor sah,
kann also nur aus dem Hauptfaden stammen, und dort sitzt die Spurmarke. Eine
Ausnahme in einem Nebenfaden bleibt so stumm wie vorher. Das ist keine
neue Lücke.

**Leerlauf, `PreTranslateMessage`, Nachbearbeitung:** nicht erfasst und ohne
Meldung, siehe [K1](#k1).

**Format** (am Quelltext belegt). `TCHAR szText[256]` mit
`sizeof/sizeof(TCHAR)` ist richtig, denn Eudora baut mit MBCS. `%s` bekommt
den Text als Argument, nicht als Format. Ein `%` im Ausnahmetext schadet also
nicht. `GetRuntimeClass()` wird nur bei `e != NULL` gerufen.
`m_lpszClassName` ist `LPCSTR`. `(UINT) pMsg->wParam` mit `%X` passt im
32-Bit-Bau. Ist `e` NULL, wirft danach `ENSURE_ARG` in der MFC-Fassung
(`appcore.cpp:1011`) aus dem `catch`-Block heraus. Das ist aber MFC-Verhalten
von vorher, und `AfxCallWndProc` übergibt nie NULL.

**Kann die Überschreibung selbst werfen?** (Vermutung, am Quelltext
gestützt). `CString::Format` kann bei Speichermangel eine
`CMemoryException` werfen. Dann ginge sie aus dem `catch`-Block in
`AfxCallWndProc` hinaus. Das betrifft aber jede Zeile, die Eudora schreibt.
`PutDebugLog` (`debug.cpp:140-145`) prüft nur Maske und Datei und wirft nicht.

**Verhalten** (am Quelltext belegt). Unverändert. Danach wird
`CWinApp::ProcessWndProcException` mit denselben Argumenten gerufen, ihr
Rückgabewert geht durch. Neu ist nur, dass auch bei `WM_PAINT`, `WM_CREATE`
und `CUserException` eine Zeile entsteht, wo die MFC still bleibt. Das ist
eher ein Gewinn. Eine Flut ist nicht zu erwarten, denn bei `WM_PAINT` macht
die MFC das Fenster gültig (`thrdcore.cpp:201-205`).

**`DEBUG_MASK_MISC` bei LogLevel 58527** (gerechnet). 58527 = `0xE49F`, darin
ist `0x8000` gesetzt (`debug.h:36`). Gesetzt wird der Wert aber nur, wenn die
`Eudora.ini` des Pakets noch keinen `LogLevel` hat (`paket-bauen.ps1:623`).
Gregors eigene Daten haben ihre eigene `Eudora.ini`. Dass dort MISC gesetzt
ist, belegen seine Protokolle zu [E-142](../Intern/BEFUNDE.md#e-142): Die Zeile `E-121 Hochgeladen`
(`ImapToc.cpp:1393`, `DEBUG_MASK_MISC`) stand darin.

## <a id="k1"></a>K1 — Eine Ausnahme außerhalb einer Fensterbotschaft beendet Eudora wortlos

**Was passiert** (am Quelltext belegt). `CEudoraApp::Run`
(`eudora.cpp:1991-2022`) fängt jede `CException` und jede `std::exception`,
die aus `CWinApp::Run` kommt. Es löscht sie und kehrt zurück. Die
`ASSERT`-Zeile ist im Release nichts. Aus `CWinApp::Run` kommt eine Ausnahme
genau dann, wenn sie **nicht** in einer Fensterprozedur entsteht:

* im Leerlauf, also in `CEudoraApp::OnIdle` und allem, was dort angestoßen wird.
  Dazu gehört `CActionQueue::OnIdle` → `DoPreThreadAction` jeder IMAP-Aktion
  (`ImapActionQueue.cpp:3814`).
* in `PreTranslateMessage` (`CEudoraApp::PreTranslateMessage`,
  `eudora.cpp:1988`, und die Kette der Fenster).
* in der Nachbearbeitung von Aufgaben. `QCTaskManager::DoPostProcessing`
  wirft ausdrücklich weiter (`QCTaskManager.cpp:720-733`). Dort laufen die
  `DoPostProcessing` aller IMAP-Aktionen, ab jetzt auch die aus [E-146](../Intern/BEFUNDE.md#e-146).

Danach gibt `AfxWinMain` (`winmain.cpp`) den Rückgabewert zurück, ohne
`ExitInstance`. Das ruft `CWinThread::Run` nur beim regulären `WM_QUIT`
(`thrdcore.cpp:630`). Eudora verschwindet also: ohne Meldung, ohne Zeile im
`eudora.log`, ohne das Beenden, das Inhaltsverzeichnisse und Einstellungen
schreibt. Was davon ungeschrieben im Speicher lag, ist verloren (Vermutung,
der Umfang ist nicht gemessen).

**Warum es hierher gehört.** Die Spurmarke soll Kriterium 2 und 4 aus
`ZIEL.md` messbar machen. Ein Absturz auf diesem Weg hinterlässt ein Log, das
mitten im Lauf endet und keine „Logging shutdown“-Zeile hat. Der
Prüfstandsfall ZIEL24 sucht genau diese Zeile als Positivprobe. Er würde rot,
aber ohne Ursache.

**Kein Rückschritt**, im Original genauso. `befund-suchen.pl
"CEudoraApp::Run"` findet nichts. **Abhilfe**, klein: In beiden
`catch`-Zweigen von `CEudoraApp::Run` dieselbe Art Zeile schreiben,
`GetErrorMessage` und `GetRuntimeClass()->m_lpszClassName` mit
`PutDebugLog(DEBUG_MASK_MISC, ...)`, dazu die Wörter „Eudora endet“.
Vorschlag für die Kennung: E-154.

## <a id="k2"></a>K2 — `UpdateData` zeigt dieselbe Meldung an der Spurmarke vorbei

**Was passiert** (am Quelltext belegt). `CWnd::UpdateData`
(`wincore.cpp:4372-4390`) fängt jede Ausnahme aus `DoDataExchange` selbst ab
und ruft `e->ReportError(MB_ICONEXCLAMATION, AFX_IDP_INTERNAL_FAILURE)`. Eine
`CInvalidArgException` zeigt dort wortgleich „Encountered an improper
argument.“. Weil die Ausnahme in `UpdateData` endet, erreicht sie
`ProcessWndProcException` nie. Ob einer von Eudoras Dialogen in
`DoDataExchange` werfen kann, habe ich nicht untersucht.

**Schwere niedrig.** Sieht Gregor die Meldung wieder, und das Log hat keine
Zeile „Ausnahme in Fensterbotschaft“, dann ist das **kein** Beweis, dass sie
von woanders kam. Sie kann aus `UpdateData` stammen, also beim Öffnen oder
Bestätigen eines Dialogs. **Abhilfe**, falls gewünscht: die Frage an Gregor
um „Was haben Sie gerade getan – einen Dialog bestätigt?“ ergänzen. Eine
Überschreibung von `UpdateData` in jeder Dialogklasse wäre unverhältnismäßig.

## Teil 2 — E-142, Hinweis beim Ziehen eines Entwurfs aus IMAP nach `Out`

**Lage** (am Quelltext belegt, `tocdoc.cpp`). Der Hinweis steht in der
Schleife hinter der E-125-Ablehnung (`:2754-2771`). Er kommt also nur für
Entwürfe (`Sum->IsComp()`) und nur bei der ersten ausgewählten Nachricht,
die übertragen werden soll. Er steht vor `CanCloseFrame`, vor
`InvalidateCachedPreviewSummary` und vor `SendAgain` (`:3038`). Bei „Nein“
ist noch nichts verändert.

**„Nein“ im Einzelnen** (am Quelltext belegt):

* **HighlightIndex.** Er wird auf die aktuelle Zeile gesetzt (`:2798-2799`).
  Danach wählt `:3099-3104` dieselbe Zeile wieder aus, sie war schon
  ausgewählt. Richtig.
* **Neuzeichnen.** Die Schleife endet mit `break`, und der Weg danach ist
  derselbe wie bei jedem Abbruch. `SetRedraw(TRUE)` (`:3107-3117`) läuft.
  Richtig.
* **Rückgabewert.** `CopySum` ist NULL, es wurde nichts angelegt. Die
  IMAP-Nachbearbeitung ist durch `!E142Abgebrochen` (`:3166`) gesperrt.
  `Xfer` gibt `CopySum` zurück, also NULL. Alle Aufrufer fangen NULL ab, das
  ist schon in [E-143](../Intern/BEFUNDE.md#e-143) belegt (`filtersd.cpp:1590-1594`, `:2005-2009`). Das
  Suchfenster aktualisiert nur bei `pSumNew` (`SearchView.cpp:3872`).
* **Undo-Liste:** siehe [K4](#k4).

**Filter und automatischer Abruf** (am Quelltext belegt). Ein Filter beim
Abruf arbeitet auf **empfangener** Post. Die ist nie `IsComp`, also greift
vorher die E-125-Ablehnung. Der E-142-Hinweis kommt dort nicht, und er hält
auch keinen Abruf an. Den Abruf hält, wie bekannt, die E-125-Meldung an, das
ist [E-143](../Intern/BEFUNDE.md#e-143). Erreicht wird der Hinweis nur auf Wegen, die Entwürfe in einem
IMAP-Ordner anfassen: Ziehen im Baum, das Transfer-Menü, das Suchfenster und
„Filter Messages“ von Hand auf einem solchen Ordner. Die beiden letzten fragen
je Nachricht, siehe [K3](#k3).

**Kopieren statt Verschieben** (am Quelltext belegt). Der Hinweis kommt auch
bei `Copy`. Das ist richtig, denn der Weg nach `Out` ist derselbe
(`SendAgain`, `:3036-3052`), also auch die leere Kopie. Der Text sagt aber
„Moving a draft“, siehe [K4](#k4).

**ID 26697** (am Quelltext belegt). Die Zeichenketten liegen in
`EudoraRes.dll`. Das ist das einzige Projekt mit `EudoraRes.rc`
(`EudoraRes.vcxproj:345`). Hinein kommen `resource.h`, `afxres.h/.rc`,
`afxprint.rc` und Stingrays `SECRES.H/secres.rc` (`EudoraRes.rc:3-11`,
`:11733-11736`). 26697 ist in ganz `Eudora71/` nur einmal definiert
(`resource.h:3890`). In MFCs `afxres.h` steht die Zahl nicht, auch nicht als
`0x6849`. Die anderen `.rc` mit `STRINGTABLE` gehören zu eigenen DLLs und
haben eigene Ressourcen. Eine Überschneidung dort wäre wirkungslos. Der Text
hat kein `%`, `YesNoDialogPlain` nimmt ihn als Format (`guiutils.cpp:1167`).
Das ist also unbedenklich. Länge etwa 230 Zeichen, der Puffer hat 1024.

## <a id="k3"></a>K3 — Aus dem Suchfenster kommt der Hinweis je Entwurf

**Was passiert** (am Quelltext belegt). Das Suchfenster ruft `Xfer` für jede
markierte Nachricht einzeln (`SearchView.cpp:3837-3868`). `E142Gefragt` ist
eine lokale Variable je Aufruf. Zehn Entwürfe aus einem IMAP-Ordner ergeben
also zehn Fragen. „Nein“ bricht nur die eine Nachricht ab, die nächste fragt
wieder. Dasselbe gilt für „Filter Messages“ von Hand (`filtersd.cpp:1531`,
`:1981`, je Nachricht mit `SingleSum`).

Die Zusage „einmal je Übertragung“ gilt also nur für das Ziehen und das
Transfer-Menü. Das ist dieselbe Klasse wie [E-143](../Intern/BEFUNDE.md#e-143), dort ist der Fall
beschrieben und offen. **Abhilfe** gehört zu [E-143](../Intern/BEFUNDE.md#e-143), nicht hierher. Bei der
dortigen Entscheidung sollte [E-142](../Intern/BEFUNDE.md#e-142) mitgenannt werden. **Schwere niedrig**,
lästig, kein Datenverlust.

## <a id="k4"></a>K4 — „Nein“ löscht trotzdem die Undo-Liste; „Moving“ auch beim Kopieren

**Was passiert** (am Quelltext belegt). Vor der Schleife leert `Xfer` die
Undo-Listen beider Postfächer, wenn nicht kopiert wird (`tocdoc.cpp:2606-2611`).
Wer also eine Übertragung gemacht hat, dann einen IMAP-Entwurf nach `Out`
zieht und „Nein“ sagt, kann die erste Übertragung nicht mehr rückgängig
machen. Bei der E-125-Ablehnung und bei `CanCloseFrame` ist es genauso, das
ist also kein neues Muster. Der Hinweistext beginnt mit „Moving a draft“ und
kommt auch beim Kopieren mit Umschalt oder „Copy To“. **Schwere niedrig.**
Abhilfe beim Text: „Transferring a draft“.

## Teil 3 — Logzeile für rootcerts.p7b

**Dasselbe Objekt?** (am Quelltext belegt). `g_fnQCSSLBeginSession` ist
`bool (WINAPI *)(QCSSLReference*)` (`QCSSL.h:506`). QCSSL bekommt also einen
Zeiger auf `m_pSSLReference`. `BeginQCSSLSession` (`QCSSLContext.cpp:747`)
reicht ihn an `SetupCertificates` (`:773`) → `ChooseCertFileDirectories`
(`:483`) → `ChooseCertFileDirectory(pSSLReference->m_CertificateInfo.m_RootCertStoreDir, ...)`
(`:461`) weiter. Das nimmt eine `CString&` und überschreibt sie (`:431-442`).
Die Logzeile liest danach dasselbe Feld desselben Objekts. Eine Kopie gibt es
auf dem Weg nicht. Die `CString` wechselt dabei die DLL-Grenze. Das tat sie
aber schon vorher in `SetSSLMode` (`QCWorkerSocket.cpp:2122`), es ist also
nichts Neues.

**Faden** (am Quelltext belegt). `m_pSSLReference` gehört zum
Socket-Objekt. Gelesen wird im selben Faden, der die Sitzung eben aufgebaut
hat. `BeginQCSSLSession` hält währenddessen `g_Mutex` und ist danach fertig.
Die Einmal-Schranke ist `InterlockedExchange` auf eine `static LONG`. Bei
gleichzeitigen Verbindungen schreibt genau eine.

**Wann steht noch „\r\n“ drin?** (am Quelltext belegt). Nur, wenn QCSSL vor
`SetupCertificates` ausstieg: `SetSSLVersion` liefert NULL (`:761-767`) oder
`SetCipherSuites` scheitert (`:770`). Dann wurde wirklich nichts geladen, und
keine Zeile ist richtig. Scheitert erst der Handshake, war die Wahl schon
getroffen. Dann kommt die Zeile, mit dem tatsächlich benutzten Verzeichnis.
Das ist gut so, denn gerade bei einem Zertifikatsfehler will man sie sehen.

**Gibt es Wege ohne die Zeile?** (am Quelltext belegt). `g_fnQCSSLBeginSession`
wird nur an einer Stelle gerufen (`QCWorkerSocket.cpp:2011`). Diese Stelle,
`InitializeQCSSL`, erreichen alle drei Lese- und Schreibwege (`:1251`,
`:1266`, `:1285`). `SetSSLMode` rufen POP (`POPSession.cpp:604`, `:3495`),
SMTP mit STARTTLS (`SMTPSession.cpp:721`, `:841`), IMAP (`proto.cpp:568`,
`:622`) und die Kennwortänderung (`password.cpp:392`), und alle gehen über
`QCWorkerSocket`. Eine zweite Socket-Klasse mit QCSSL gibt es nicht.
`m_InputCertsDir` enthält immer beide Kandidaten (`SSLSettings.cpp:87`).

## <a id="k5"></a>K5 — Die Zeile kommt einmal je Lauf, auch wenn sie dabei verloren geht

**Was passiert** (am Quelltext belegt). Die Schranke `s_lGeschrieben` wird
gesetzt, **bevor** `PutDebugLog` prüft, ob das Log läuft und MISC gesetzt ist
(`debug.cpp:140-145`). Wer das Protokoll erst nach der ersten
TLS-Verbindung einschaltet, bekommt die Zeile in diesem Lauf nie. Dasselbe
gilt, wenn er während des Laufs eine eigene `rootcerts.p7b` ins
Mailverzeichnis legt: QCSSL wählt beim nächsten Aufbau neu, die Zeile nennt
aber weiter die erste Wahl. Für [E-148](../Intern/BEFUNDE.md#e-148) ist genau dieser Wechsel der
interessante Fall. **Schwere niedrig.** Abhilfe: die Zeile schreiben, wenn
sich das Verzeichnis gegenüber dem zuletzt geschriebenen geändert hat, statt
einmal je Lauf.

## Teil 4 — E-146, Umbenennen von IMAP-Ordnern

**Aufrufer** (am Quelltext belegt). `CImapAccount::RenameMailbox` hat genau
einen Aufrufer (`QCImapMailboxDirector.cpp:2401`), `UpdateAfterRename` ebenso
(`:2456`). Gesucht wurde in `*.cpp/*.h` unter `Eudora71/`. Das Verschieben
eines Ordners (`ImapAccount.cpp:3330-3400`) bildet seinen Namen selbst und
schickt `RENAME` gleich im Hauptfaden. Er ist ein eigener Weg und nicht
Gegenstand von [E-146](../Intern/BEFUNDE.md#e-146). `UpdateChildrenAfterRename` (`:2954-3040`) baut die
Namen der Kinder aus dem jetzt richtigen Elternnamen. Ohne Trenner kehrt es
vorher zurück, aber ein Ordner ohne Trenner hat auch keine Kinder.

**Nur eine Rechnung** (am Quelltext belegt). `strNewFullImapName` wird in
`RenameMailbox` einmal gebildet (`:2998-3049`). Mit ihm wird das lokale
Verzeichnis benannt (`:3062-3067`). Er geht in die Rename-Aktion (`:3084`),
und jetzt auch an `UpdateAfterRename` (`:3078-3079`). Der Name in Eudora und
der am Server sind damit dieselbe Zeichenkette. K8 aus PRÜFER-50 ist am
Quelltext behoben, ohne Trenner ebenso wie bei INBOX mit Präfix.

**Faden der Nachbearbeitung** (am Quelltext belegt). `::DoPostProcessing`
(`ImapActionQueue.cpp:553-559`) ruft die virtuelle Methode. Gerufen wird sie
aus `CTaskInfoMT::DoPostProcessing` (`TaskInfo.cpp:427-477`, `ASSERT` auf den
Hauptfaden), das wiederum nur aus `QCTaskManager::DoPostProcessing`
(`QCTaskManager.cpp:667`) kommt, „Should only get called from OnIdle loop“.
Die Aktion lebt bis dahin: Gelöscht wird sie erst in `RemoveTaskInfo`
(`QCTaskManager.cpp:902`), nach `Kill()` am Ende der Nachbearbeitung. Das ist
dasselbe Muster wie bei `CImapDeleteMsgAction` (`:1193`) und
`CImapTransferMsgAction` (`:1588`).

**Offline und `actionqueue.dat`** (am Quelltext belegt). Ist Eudora offline,
arbeitet `ProcessActionQueues` die Warteschlange gar nicht ab
(`ImapAccountMgr.cpp:1203-1262`, nur `!bIsOffline`). Die Aktion wird in die
Datei geschrieben und später wieder gelesen. Gelesen wird über `SetNewName`,
der Merker steht dann auf seinem Anfangswert `false`. Gesetzt wird er erst in
`DoWork` **desselben** Objekts, und `DoPostProcessing` liest ihn am selben
Objekt. `Duplicate`/`Copy` laufen nur im Destruktor bei `kActionStateOffline`
(`:619-623`), und diesen Zustand setzt die Rename-Aktion nie. Der fehlende
Merker in `Copy` schadet also nicht. **Nebenbefund aus dem Original:**
`CImapRenameMailboxAction::Copy` (`:2791-2794`) kopiert auch `m_szNewName`
nicht. Ein Duplikat hätte keinen neuen Namen und scheiterte an
`RenameMailboxOnServer` (`ImapAccount.cpp:3118-3123`). Auf heute erreichbaren
Wegen gibt es dieses Duplikat aber nicht. Kein Fund.

**Schleife?** (am Quelltext belegt). Nein. Den Refresh legt nur eine
gescheiterte Rename-Aktion an. `CImapRefreshMailboxesAction` legt selbst
keine Aktion an (`:3084-3163`). Ein gescheiterter Refresh endet ohne Folge.

**Keine Verbindung** (am Quelltext belegt, Wirkung Vermutung). Ist der Server
nicht erreichbar, scheitert `RenameMailboxOnServer` an `OpenControlStream`.
Dann wird der Refresh angelegt. Dessen Arbeit läuft vollständig in
`DoPostProcessing` im Hauptfaden (`DoWork` ist leer, `:3114-3117`).
`QCImapMailboxCommand::Execute(CA_IMAP_REFRESH)` ändert den Baum nur, wenn
`UpdateMailboxLists` gelang (`QCImapMailboxCommand.cpp:172-189`). Ohne
Verbindung geschieht also nichts, und es entsteht kein Schaden. Der falsche
lokale Name bleibt dann aber stehen, bis jemand von Hand „Refresh“ wählt. Die
Behebung wirkt also für „Server sagt NO“, nicht für „keine Verbindung“. Der
Kommentar über `DoPostProcessing` (`:2857`) nennt beides. Schwere niedrig,
daher kein eigener Fund. Ich empfehle, den Kommentar zu berichtigen.

**`SetPostProcFn` bei jeder Rename-Aktion** (am Quelltext belegt). Ja, die
Funktion wird in `DoPreThreadAction` (`:2821`) angemeldet. Bei Erfolg kehrt
`DoPostProcessing` sofort zurück (`:2866-2867`). `CTaskInfoMT::DoPostProcessing`
ruft `Kill()` mit und ohne Funktion gleich (`TaskInfo.cpp:443-460`). Ein
Unterschied bleibt: Die Aufgabe zeigt jetzt den Nachbearbeitungstext
„Renaming…“, wie die anderen Aktionen mit Nachbearbeitung. Harmlos.

## <a id="k6"></a>K6 — Lokal gescheitert, am Server trotzdem umbenannt

**Was passiert** (am Quelltext belegt, aus dem Original). `RenameMailbox`
legt die Rename-Aktion **auch dann** in die Warteschlange, wenn das lokale
Umbenennen gescheitert ist (`ImapAccount.cpp:3067`, `:3081-3090`, `bResult`
wird erst danach in `:3097` ausgewertet). `HandleRenameImapMailbox` kehrt dann
früh zurück (`QCImapMailboxDirector.cpp:2404-2408`). Der Baum behält den
alten Namen, der Server benennt um. Weil das am Server gelingt, kommt kein
Refresh. Danach fragt Eudora den Server nach einem Ordner, den es dort nicht
mehr gibt. Das ist genau das Bild von K8 aus PRÜFER-50, nur aus der anderen
Richtung. Scheitern kann das lokale Umbenennen, wenn `MakeSuitableMailboxName`
nichts findet oder Umbenennen und Neuanlegen des Verzeichnisses beide
misslingen (`ImapMailbox.cpp:7267-7289`). Das ist selten (Vermutung).
**Schwere niedrig.** Abhilfe: die Aktion nur bei `bResult` anlegen.

## <a id="k7"></a>K7 — Der abgelehnte Name gibt es am Server schon

**Was passiert** (Weg am Quelltext belegt, Wirkung Vermutung, nicht
gemessen). Der häufigste Grund für ein `NO` auf `RENAME` ist, dass der
Zielname am Server schon existiert. Der Baum prüft nur gegen lokale
Geschwister (`SiblingHasSameName`, `mboxtree.cpp:1692`). Gibt es „B“ am
Server, aber noch nicht im lokalen Baum, dann läuft das so:

1. A wird lokal zu B. Das Verzeichnis bekommt einen eindeutigen Namen
   (`MakeSuitableMailboxName`), das schützt vor Überschreiben. Der Eintrag
   trägt den IMAP-Namen „B“ und den Zwischenspeicher von A.
2. Der Server lehnt ab, Eudora liest die Liste neu: A und B.
3. Der Eintrag „B“ passt nach seinem Namen zum Server-Ordner B und bleibt
   gültig. Das ist eine Vermutung, wie `CImapMlistMgr` zuordnet, habe ich
   nicht verfolgt. A wird neu angelegt, leer.

Dann zeigt „B“ bis zum nächsten Abgleich die Nachrichten von A. Der
UIDVALIDITY-Abgleich (`ImapMailbox.cpp:1500ff`) sollte das beim Öffnen
bemerken und neu laden, weil die beiden Ordner verschiedene UIDVALIDITY
haben. Löscht jemand vorher in der Liste, ginge der Befehl mit A-UIDs an B.
Ob das möglich ist, ist nicht gemessen. **Schwere niedrig, bis gemessen.**
Messbar ist es mit dem Prüfserver: ein Ordner, der bei `LIST` fehlt, bis
`RENAME` abgelehnt wurde. Vorschlag für die Kennung, falls die Messung den
Weg bestätigt: E-155.

## <a id="k8"></a>K8 — Das liegengebliebene Verzeichnis ist nicht leer

**Was passiert** (am Quelltext belegt). Der Commit `2fbc35d4` und
[BEFUNDE.md](../Intern/BEFUNDE.md) sprechen von einem „leeren
Zwischenspeicher“, der liegen bleibt. Liegen bleibt aber das **umbenannte
Verzeichnis von A** (`RenameMboxDirAndContents`, `ImapMailbox.cpp:7275-7283`)
mit MBX, TOC und Infodateien von A. Am Prüfstand war es leer, weil der Ordner
dort nie geladen wurde (Vermutung). Bei Gregor enthält es die geladenen
Nachrichten von A. Verloren geht nichts, was nicht am Server liegt, außer dem,
was Eudora nur lokal führt, etwa Etiketten im TOC (Vermutung). **Schwere
niedrig.** Abhilfe: Wortlaut in BEFUNDE berichtigen und das Verzeichnis nach
dem Refresh löschen oder zurückbenennen, wenn kein Eintrag mehr darauf zeigt.

## Teil 5 — Prüfserver mit Musterauswertung

**Gemessen** am eigenen Port 11439, Protokoll im Scratchpad: Auf `LIST "" "*"`,
`LIST "" "%"`, `LIST "" *` und `LSUB "" "*"` kommen alle vier Ordner wie
vorher. `LIST "" ""` liefert nur noch den Trenner, `(\Noselect) "/" ""`.
Vorher kam die ganze Liste. Eudora liest daraus den Trenner „/“, und der ist
derselbe. `LIST "" "inbox"` liefert `INBOX`. `LIST "" "Ablage/%"`,
`LIST "Ablage/" "%"`, `LIST "" "INBOX/%"` und `LIST "" "INBOX.%"` liefern
nichts. Nach `RENAME` steht der neue Name in der Liste.

## <a id="k9"></a>K9 — Die anderen Prüfstandsfälle sind mit dem neuen Server nicht nachgemessen

**Was passiert** (am Quelltext belegt, Wirkung Vermutung). Den Prüfserver
benutzen nur `e118-serie.ps1` ([E-118](../Intern/BEFUNDE.md#e-118), [E-121](../Intern/BEFUNDE.md#e-121)) und `messen-e77-umbenennen.ps1`
(E-77d, [E-146](../Intern/BEFUNDE.md#e-146)). Die Fälle E-77a–c, [E-119](../Intern/BEFUNDE.md#e-119) und ZIEL24 starten ihn nicht. Die
Ordnerliste ist fest und flach (`imap-pruefserver.pl:174`). Für flache Namen
liefern `*` und `%` dasselbe wie die alte Vollausgabe (gemessen, s. o.).
Deshalb erwarte ich keine Änderung. Laut `tools/TESTLAEUFE.md` liefen [E-118](../Intern/BEFUNDE.md#e-118)
und E-77U zuletzt um 07:32 und 07:36, also **vor** der Änderung. Danach lief
nur E146. **Schwere niedrig.** Vor dem Paket einmal [E-118](../Intern/BEFUNDE.md#e-118), [E-121](../Intern/BEFUNDE.md#e-121) und E-77d mit
dem neuen Server fahren.

Ein Rest für künftige Fälle: Der Server meldet jeden Ordner mit
`\HasNoChildren`. Wer später einen Ordner mit „/“ im Namen anlegt oder
dorthin umbenennt, bekommt bei `%` die Eltern ohne Kinderhinweis. Eudora
stiege dann nicht hinab. Heute gibt es keinen solchen Fall.

## <a id="k10"></a>K10 — Was die Tests nicht sehen (gemessen)

Jede Probe wurde in meinem Baum byte-genau eingesetzt (Perl, ein Treffer je
Probe). Alle drei liefen in einem gemeinsamen Lauf. Danach kamen die Dateien
aus der Sicherung zurück (SHA-1 gleich, `cmp` gegen `HEAD` gleich) und bekamen
ein `touch`.

| Probe | Änderung | Ergebnis |
|---|---|---|
| P0 (Positivprobe) | `tocdoc.cpp`: Bedingung des Hinweises um `&& Copy` ergänzt | **rot**, 306/307, „fehlt oder getrennt: if (ToOut && IsImapToc() && !E142Gefragt) {“ |
| P1 | `tocdoc.cpp`: `BOOL E142Gefragt = TRUE;` statt `FALSE`. Der Hinweis kommt nie. | grün, 307/307 |
| P2 | `QCWorkerSocket.cpp`: `if (bSuccess) ProtokolliereRootCertsVerzeichnis(...)`. Die Zeile fehlt genau bei gescheitertem Handshake. | grün, 307/307 |
| P3 | `ImapAccount.cpp`: bei INBOX `prefix +` gestrichen. Die INBOX-Hälfte von PRÜFER-50 K8 ist zurück. | grün, 307/307 |

P1 schaltet [E-142](../Intern/BEFUNDE.md#e-142) vollständig ab, und der Test merkt es nicht. Er prüft den
Block, nicht den Anfangswert. Abhilfe: zusätzlich `BOOL E142Gefragt = FALSE;`
verlangen. P3 zeigt, dass TestE146 nur die *eine* Rechnung prüft, nicht ihren
Inhalt. Das ist vertretbar, denn die Präfix-Rechnung ist Original, sollte aber
im Testkopf stehen. P2 ist eine Feinheit.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Eine Ausnahme im Leerlauf, in `PreTranslateMessage` oder in der Nachbearbeitung beendet Eudora wortlos: keine Meldung, keine Logzeile, kein geordnetes Beenden. Ungeschriebenes kann verloren gehen. Schon im Original so. | mittel | nein |
| [K2](#k2) | „Encountered an improper argument“ aus `UpdateData` eines Dialogs zeigt die MFC selbst, ohne Logzeile. | niedrig | nein |
| [K3](#k3) | Im Suchfenster und bei „Filter Messages“ von Hand kommt der E-142-Hinweis je Entwurf, nicht einmal. Gehört zu [E-143](../Intern/BEFUNDE.md#e-143). | niedrig | nein |
| [K4](#k4) | „Nein“ auf den Hinweis löscht trotzdem die Undo-Liste. Der Text sagt „Moving“ auch beim Kopieren. | niedrig | nein |
| [K5](#k5) | Die rootcerts-Zeile kommt einmal je Lauf. War das Log da aus oder wechselt das Verzeichnis später, fehlt sie. | niedrig | nein |
| [K6](#k6) | Scheitert das lokale Umbenennen, benennt der Server trotzdem um, und Eudora behält den alten Namen. Selten, aus dem Original. | niedrig | nein |
| [K7](#k7) | Existiert der abgelehnte Name am Server schon, trägt der Ordner nach dem Neueinlesen vermutlich bis zum Abgleich den Inhalt des alten. Nicht gemessen. | niedrig (Vermutung) | nein |
| [K8](#k8) | Das liegengebliebene Verzeichnis enthält den Zwischenspeicher des alten Ordners, es ist nicht leer. Wortlaut in BEFUNDE falsch. | niedrig | nein |
| [K9](#k9) | [E-118](../Intern/BEFUNDE.md#e-118), [E-121](../Intern/BEFUNDE.md#e-121) und E-77d sind mit dem geänderten Prüfserver noch nicht gefahren. Erwartet: unverändert. | niedrig | nein, vor dem Paket einmal fahren |
| [K10](#k10) | Drei Rückfälle bleiben im Test grün, darunter das vollständige Abschalten des E-142-Hinweises. | niedrig | nein |
