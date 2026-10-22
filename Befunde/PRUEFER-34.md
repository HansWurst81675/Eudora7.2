# PRÜFER-34 — 7.2.0.102 nachgerechnet

Gegenstand: `git diff 66a2ed04..HEAD -- Eudora71/`, also Commit `f09362f0` (7.2.0.102) zu
[E-123](../Intern/BEFUNDE.md#e-123): Das Beenden wartet auf Übertragungen lokal → IMAP, und eine nur
belegte Verbindung blockiert die IMAP-Warteschlange nicht mehr. Gelesen am Quelltext, nichts gebaut,
nichts gestartet. Die Zeilenangaben beziehen sich auf `f09362f0`. Messdaten, nur gelesen:
`C:\Temp\E118\Mailverzeichnis\eudora-w123{a,b,c,d,rot}-1.log` und `C:\Temp\E118\imap-w123*-1.log`.

## Urteil

**Zu Gregor zum Test: ja.** Den Normalfall verbessert 7.2.0.102 gemessen. Lauf d zeigt: Eudora
wartet 10 s, bis der Server das Hochladen bestätigt, und endet sauber bis `ExitInstance`. In der
Gegenprobe an 7.2.0.101 verschwindet das Fenster, der Prozess hängt bis zum Abschuss, und die
Mail wird nie hochgeladen. Fast alle Reste unten führen höchstens auf diesen alten Stand zurück.
Die Ausnahme ist S3: Im Offline-Modus wartet Eudora jetzt 90 s vergeblich, das ist neu.

**Ins Release: erst nach S1, S3 und S4, möglichst zusammen mit S2.** S1 ist der wichtigste Fund.
Wer während des Wartens ein zweites Mal schließt, landet genau im Hänger der Gegenprobe. Dasselbe
geschieht nach 90 s, wenn das Hochladen dann noch läuft. Das zweite Schließen ist naheliegend:
Während des Wartens zeigt Eudora nichts an (S2).

| Fund | Einstufung | Stand |
|---|---|---|
| S1 Zweites Schließen während des Wartens oder Ablauf der 90 s **mitten im Hochladen**: Abbau läuft verschachtelt im Hochladen ab, wie in der Gegenprobe | **Hänger** (Fenster weg, Prozess bleibt; danach der E-123-Bildschaden wieder möglich) | Mechanik **belegt** (Lauf d und rot), Auslösung an 7.2.0.102 Vermutung, ungemessen |
| S2 Während des Wartens zeigt Eudora nichts an | falsche Anzeige (führt zu S1) | belegt |
| S3 Globaler Offline-Modus: Beenden wartet 90 s auf eine Warteschlange, die nie läuft | Hänger (90 s), **neu gegenüber 7.2.0.101** | Mechanik belegt, ungemessen |
| S4 Zeitgeber läuft nach dem zweiten Schließen weiter; `m_bE123Gewartet` wird nie zurückgesetzt | falsche Anzeige; der E-123-Schutz fällt für den Rest der Sitzung weg | belegt am Quelltext |
| S5 Modaler Dialog (Kennwort, Fehlermeldung) beim Ablauf der 90 s: `WM_CLOSE` läuft in der Dialogschleife | Absturz oder Hänger | Vermutung |
| S6 Gezählt wird jede laufende Aufgabe, nicht nur Übertragungen lokal → IMAP | Hänger (unnötige Wartezeit bis 90 s) | belegt am Quelltext |
| S7 Wiederholung bei belegter Verbindung: endlos alle 3 s, kein Serververkehr, kein wiederholter Kennwortdialog | kosmetisch (Protokoll), mit [E-83](../Intern/BEFUNDE.md#e-83) jedes Beenden 90 s | am Quelltext begründet, **ungemessen** |
| S8 Spurmarke `E-123 Warteschlange` schreibt nur beim Beenden, `Verbindung belegt` auch sonst | kosmetisch | belegt (Lauf d: 6 Zeilen in 10 s) |
| S9 Läufe a und b zeigen an „7.2.0.102“ keine einzige E-123-Zeile | Prüflücke | belegt; Ursache Vermutung |
| S10 Kommentar am falschen Ort; Kommentar „nicht, wenn offline“ trifft den Offline-Modus nicht | kosmetisch | belegt |

## Wege zum Beenden

| Weg | Stelle | läuft durch `OnClose` | wartet |
|---|---|---|---|
| Datei → Beenden | `eudora.cpp:806-825` → `CWinApp::OnAppExit` → `SendMessage(WM_CLOSE)` | ja | ja |
| Datei → Beenden mit Umschalt | `eudora.cpp:821-822` | nein, beendet nicht | — |
| Beenden-Knopf in der Leiste | `mainfrm.cpp:4105-4108` (`ID_FAKE_APP_EXIT` → `ID_APP_EXIT`) | ja | ja |
| Menü des Infobereichs (Tray) | `mainfrm.cpp:2079` `PostMessage(WM_COMMAND, nID)` | ja, falls das Menü „Beenden“ führt | ja |
| Kreuz, Alt-F4, Systemmenü | `SC_CLOSE` → `WM_CLOSE`, mit E-41-Ausweg `mainfrm.cpp:5662-5666` | ja | ja |
| Automation `CloseEudora` | `QComApplication.cpp:398-405` `PostMessage(WM_CLOSE)` | ja | ja (der Aufrufer hat sein `S_OK` schon) |
| Beenden nach dem Senden | `sendmail.cpp:3765-3769` | ja | ja |
| Einstellungen/Leisten zurücksetzen | `mainfrm.cpp:4447`, `:4805` → `ID_APP_EXIT` | ja | ja, unschädlich |
| Abmelden/Herunterfahren von Windows | `mainfrm.cpp:5164-5170` `OnQueryEndSession` → `CloseDown` direkt | nein | nein (gewollt) |
| MAPI | kein eigener Beenden-Weg gefunden | — | — |

Druckvorschau: `m_lpfnCloseProc` wird **vor** dem Warten geprüft (`mainfrm.cpp:5217-5218`). Ist die
Vorschau beim ersten Schließen offen, schließt nur die Vorschau, wie im Original. Öffnet der
Anwender sie **während** des Wartens, schließt das `WM_CLOSE` vom Zeitgeber nur die Vorschau.
`m_bE123Gewartet` steht dann schon auf TRUE, der Zeitgeber ist gelöscht, Eudora bleibt offen.
Das ist harmlos, nur geht der Beenden-Wunsch verloren (Vermutung, sehr selten).

Faden: `E123OffeneUebertragungen` läuft nur in `OnClose` und `OnTimer`, also im Hauptfaden.
`m_array` und `m_iState` ändern ebenfalls nur Hauptfaden-Wege: `OnIdle`, `Add`, `ActionDone` im
Destruktor der Aufgabe. Den einzigen Lesezugriff aus dem Arbeitsfaden hat
`GetNextMailboxMatch` aus `DoWork`. Er ist alt und unverändert. **Kein neuer Wettlauf.**
`dynamic_cast` auf `CImapAction*` ist zulässig, die Klasse hat virtuelle Methoden.

## S1 — zweites Schließen oder Zeitablauf mitten im Hochladen: der Hänger der Gegenprobe

**Was Lauf d zeigt.** Das Hochladen (`APPEND`) läuft im **Hauptfaden** in
`CImapFromLocalTransferMsgAction::DoPostProcessing`. Der Faden wartet dort in einer Schleife, die
Fensterbotschaften weiter zustellt:

* `imap-w123d-1.log:14-18`: `APPEND` gesendet um 21:28:37, Antwort um 21:29:02.
* `eudora-w123d-1.log`: `E-118 Hochladen` mit Fadenkennung `MAIN` bei 0.29. Das ist die Antwort
  von 21:29:02, das `APPEND` begann also bei 0.04.
* **Dazwischen**, bei 0.20, `E-33 OnClose: WM_CLOSE angekommen`. Bei 0.22, 0.24, 0.26 und 0.28
  folgen die Zeitgeberzeilen `E-123 Warteschlange … zustand=1`.

`OnClose` und `OnTimer` liefen also **verschachtelt innerhalb des Hochladens**. In 7.2.0.102
kehrt `OnClose` dort früh zurück (`mainfrm.cpp:5229-5241`). Das ist der eigentliche Grund, warum
Lauf d gelingt. Das abschließende `WM_CLOSE` kommt erst nach dem Hochladen (0.30) und läuft nicht
verschachtelt.

**Was die Gegenprobe zeigt.** In 7.2.0.101 läuft der ganze Abbau im verschachtelten `OnClose` ab:
`CloseDown`, `CloseImapConnections`, `QCWorkbook::OnClose`, `~CMainFrame`, `durchgelaufen`
(`eudora-w123rot-1.log`, Ende). Danach kehrt der Faden in die Warteschleife des Hochladens zurück,
`ExitInstance` kommt nie, und das Hochladen wird nie beantwortet (`imap-w123rot-1.log`, Ende).

**Zwei Wege führen in 7.2.0.102 genau dorthin:**

1. **Zweites Schließen.** Nach dem ersten `WM_CLOSE` steht `m_bE123Gewartet` auf TRUE
   (`mainfrm.cpp:5237`). Jedes weitere `WM_CLOSE` geht an `:5229` vorbei direkt in `CloseDown`
   (`:5244`). Kommt es, während das Hochladen noch läuft, ist es der Lauf rot.
2. **Zeitablauf.** `OnTimer` schickt nach 90 s `PostMessage(WM_CLOSE)` (`mainfrm.cpp:1968-1975`),
   gleichgültig, ob das Hochladen gerade auf dem Stapel liegt. Das ist bei einer großen Anlage auf
   langsamer Leitung oder bei einem langsamen Server der Fall. Die Botschaft wird in derselben
   Warteschleife zugestellt.

**Folge:** Das Fenster verschwindet, der Prozess läuft weiter, bis er abgeschossen wird. Ein neuer
Start trifft dann womöglich auf die hängende Instanz (Vermutung). Die Übertragung steht nicht in
`actionqueue.dat`. Sie ist schon aus `m_array` genommen (`ImapActionQueue.cpp:3706`), und in der
Gegenprobe war die Datei leer. Die Mail bleibt in der Quelle ([E-121](../Intern/BEFUNDE.md#e-121)), aber der E-123-Bildschaden
ist über den Neustart wieder möglich.

**Anwender:** Er klickt aufs Kreuz, sieht nichts geschehen (S2) und klickt noch einmal. Das
Fenster verschwindet, aber Eudora hängt unsichtbar weiter und muss im Task-Manager beendet werden.

**Vorschlag:**

* (a) Ein zweites `WM_CLOSE` wird ignoriert, solange der Zeitgeber läuft. Einen eigenen Merker
  dafür setzen und beim `KillTimer` löschen.
* (b) Der Zeitgeber schickt `WM_CLOSE` nicht, solange ein Hochladen auf dem Stapel liegt. Das geht
  mit einem Zähler, den `CImapFromLocalTransferMsgAction::DoPostProcessing` beim Eintritt hoch-
  und beim Austritt herunterzählt. Die Netzzeitbegrenzung des Sockets begrenzt das Warten ohnehin.

## S2 — keine Anzeige während des Wartens

`mainfrm.cpp:5229-5241` schreibt nur ins Protokoll und stellt den Zeitgeber. Das Fenster bleibt
voll bedienbar. Es gibt keinen Text in der Statuszeile, keinen Sanduhrzeiger und keine Meldung.

**Anwender:** Er schließt Eudora, und bis zu 90 s lang passiert nichts Sichtbares. Er hält das
Beenden für kaputt und schließt noch einmal (S1).

**Vorschlag:** Text in der Statuszeile, etwa „Eudora wartet, bis n Nachricht(en) im IMAP-Ordner
angekommen sind …“.

## S3 — Offline-Modus: 90 s Warten auf nichts

`CImapAccountMgr::ProcessActionQueues` ruft im Offline-Modus (`IDS_INI_CONNECT_OFFLINE`) keine
Warteschlange auf (`ImapAccountMgr.cpp:1203`, `:1241`, `:1256`, jeweils `!bIsOffline`). Der
Zustand der Warteschlange bleibt dabei `kQueueStateIdle`, nicht `Blocked`. `bBlockiert` an
`ImapActionQueue.cpp:3943` ist deshalb falsch, und jede eingereihte Übertragung zählt.

Der Weg dorthin ist offen: `ImapXferMessages` fragt im Offline-Modus nach und reiht die
Übertragung bei „offline erledigen“ ein (`ImapToc.cpp:396-410`, `:1058-1069`). Danach wartet
jedes Beenden 90 s, ohne dass etwas geschehen kann. Der Kommentar `mainfrm.cpp:5228` („nicht,
wenn ein Konto offline … ist“) trifft nur die einzelne blockierte Warteschlange, nicht diesen Fall.

**Anwender:** Er arbeitet offline, verschiebt eine Mail in einen IMAP-Ordner und beendet. Eudora
bleibt 90 s ohne Hinweis offen. In 7.2.0.101 schloss es sofort.

**Vorschlag:** `CImapAccountMgr::E123OffeneUebertragungen` gibt 0 zurück, wenn
`GetIniShort(IDS_INI_CONNECT_OFFLINE)` gesetzt ist. Das ist eine Zeile.

## S4 — Zeitgeber und Merker nach dem zweiten Schließen

* Nach dem zweiten `WM_CLOSE` (S1) läuft `E123_WARTE_TIMER_ID` weiter. Vor `CloseDown` steht kein
  `KillTimer` (`mainfrm.cpp:5244`). Bricht der Anwender eine Rückfrage in `CloseDown` ab (*„You
  currently have n task(s) running“*, Stufe 1, `:5414-5420`, oder ausstehende Post, Stufe 3),
  läuft Eudora weiter. Höchstens 90 s später schickt der Zeitgeber selbst `WM_CLOSE`. Eudora fragt
  dann erneut oder schließt ganz ohne Rückfrage, wenn keine Rückfrage mehr ansteht.
* `m_bE123Gewartet` wird nie zurückgesetzt (`mainfrm.cpp:733`, `:5237`). Hat der Anwender einmal
  in `CloseDown` abgebrochen, wartet kein späteres Beenden derselben Sitzung mehr. [E-123](../Intern/BEFUNDE.md#e-123) ist dann
  wieder offen.

**Anwender:** Er drückt beim Beenden „Abbrechen“, weil noch etwas läuft. Kurz darauf fragt Eudora
von selbst noch einmal oder geht zu. Beendet er später in derselben Sitzung, wartet Eudora nicht
mehr.

**Vorschlag:** `KillTimer(E123_WARTE_TIMER_ID)` vor `CloseDown`. Liefert `CloseDown` FALSE, wird
`m_bE123Gewartet = FALSE` gesetzt.

## S5 — modaler Dialog beim Ablauf der Wartezeit

Während des Wartens laufen `OnIdle` und damit die Warteschlange weiter. Zwei Dialoge können dabei
erscheinen:

* **Kennwort.** `Add` hebt eine Blockade wegen gescheiterter Anmeldung auf
  (`ImapActionQueue.cpp:3820-3823`). Die nächste Aufgabe ruft `GetLogin` im Hauptfaden
  (`ImapMailbox.cpp:821-826`). Ohne gespeichertes Kennwort kommt der Kennwortdialog.
* **Fehlermeldung aus `DoPostProcessing`**, etwa *„Attempt to add the message to mailbox …
  failed“*.

Solange der Dialog offen ist, steht die Warteschlange auf `Processing`, `nOffen` ist mindestens 1,
und nach 90 s schickt der Zeitgeber `WM_CLOSE`. Die Dialogschleife stellt `WM_TIMER` und gepostete
Botschaften auch an das gesperrte Hauptfenster zu. `OnClose` baut dann ab, während der Dialog und
darunter `DoPreThreadAction` oder `DoPostProcessing` auf dem Stapel liegen. Das ist derselbe
verschachtelte Abbau wie in S1, nur unter einem offenen Dialog.

**Vermutung**, nicht gemessen. **Anwender:** Er beendet Eudora und geht weg. Eine Fehlermeldung
erscheint und bleibt 90 s stehen, dann verschwindet das Fenster, und Eudora hängt oder stürzt ab.

**Vorschlag:** Der Zeitgeber schickt nicht, solange `!IsWindowEnabled()` gilt, also ein modaler
Dialog offen ist. Zusammen mit S1 (b).

## S6 — gezählt wird jede laufende Aufgabe

`m_iState = kQueueStateProcessing` setzt `OnIdle` für **jede** Aufgabenart (`:3688`), ebenso für
Abgleich (`CImapResyncAction`), Herunterladen (`CImapDownloadAction`) und Merkzeichen setzen.
`E123OffeneUebertragungen` zählt den Zustand ohne Ansehen der Art als Übertragung (`:3954-3957`).
Ein langer Abgleich oder ein Herunterladen für den Offline-Betrieb lässt das Beenden bis zu 90 s
warten, obwohl keine Übertragung lokal → IMAP aussteht.

**Gegenvermutung „`Processing` bleibt dauerhaft hängen“:**

* Über den Fehlschlag von `QueueWorkerThread` (`:3706-3718`, Zustand bleibt `Processing`) **nicht
  erreichbar**. `CanScheduleTask` lehnt nur einen zweiten POP-Abruf derselben Persönlichkeit ab
  (`QCTaskManager.cpp:258-261`, `:289-301`), IMAP-Aufgaben nie. Diese Gegenvermutung ist
  entkräftet.
* Über [E-83](../Intern/BEFUNDE.md#e-83) („liegengeblieben“, die Nachbearbeitung läuft nie, also läuft
  auch der Destruktor nie, der `ActionDone` ruft, `:619-627`): Steckt eine Aufgabe der
  Warteschlange dort fest, wartet jedes Beenden 90 s. Das ist Vermutung. In c steht die
  liegengebliebene Aufgabe „Checking“ außerhalb der Warteschlange (`zustand=0`).

**Anwender:** Er beendet Eudora, während ein großer Ordner abgeglichen oder heruntergeladen wird,
und wartet bis zu 90 s ohne Hinweis. Klickt er dabei noch einmal, geht er in S4.

**Vorschlag:** In `OnIdle` merken, ob die gestartete Aufgabe eine
`CImapFromLocalTransferMsgAction` ist, und nur dann zählen.

## S7 — Wiederholung bei belegter Verbindung

**Woher `kActionStateBusy` kommt.** `CImapAction::OpenMailbox` (`:836-839`) erhält
`ERROR_BUSY` aus zwei Quellen:

* der Wiedereintrittssperre `CLoginLock` in `CImapMailbox::OpenMailbox` (`ImapMailbox.cpp:830-835`);
* dem `LockNoWait` der Verbindung (`ImapConnection.cpp:708-712` und die weiteren Stellen dort),
  wenn eine andere Aufgabe die Verbindung hält, etwa der Abgleich vom Start.

Ein Busy aus `GetLogin` selbst wird zu `CANCEL` umgewandelt (`ImapMailbox.cpp:825-826`). Er wird
nicht wiederholt und gilt als blockiert. Das ist eine Lücke, aber nicht schlechter als das Original.

**Endlosschleife?** Ja, solange die Verbindung belegt bleibt, alle 3 s ein Versuch (`:3676-3681`).
Jeder Versuch prüft nur lokale Sperren, **ohne Netzverkehr**. Der Server wird nicht bombardiert.
`GetLogin` läuft vor der Sperre. Ein Kennwortdialog käme nur ohne bekanntes Kennwort, und eine
belegte Verbindung setzt eine bestehende Anmeldung voraus. Bricht der Anwender ab, wird daraus
`Cancel`, und die Wiederholung endet. **Kein wiederholter Dialog.**

Bleibt die Verbindung dauerhaft belegt ([E-83](../Intern/BEFUNDE.md#e-83)), entstehen zwei Folgen:

* alle 3 s die Zeile `Verbindung belegt` für die ganze Sitzung;
* `bBlockiert` ist falsch (`:3943`), also wartet jedes Beenden 90 s.

**Ungemessen:** In keinem der fünf Läufe steht `Verbindung belegt`. Das sagt auch BEFUNDE.md.

**Anwender:** Er merkt nichts, solange [E-83](../Intern/BEFUNDE.md#e-83) nicht zuschlägt. Steckt der Abgleich fest, dauert das
Beenden 90 s.

## S8 — Spurmarken

`E-123 Warteschlange` schreibt bei jedem Aufruf von `CActionQueue::E123OffeneUebertragungen`
(`:3959-3963`). Aufgerufen wird die Funktion nur aus `OnClose` (`mainfrm.cpp:5231`, einmal je
Beenden) und `OnTimer` (`:1966`, alle 2 s). Das ergibt je Konto höchstens 46 Zeilen pro Beenden,
**außerhalb des Beendens keine**. Gemessen sind 6 Zeilen in 10 s (Lauf d) und 1 Zeile ohne Warten
(Lauf c).

`Verbindung belegt` (`:3742`) schreibt dagegen auch im laufenden Betrieb, siehe S7. Beide Zeilen
erscheinen nur mit `DEBUG_MASK_MISC`.

**Anwender:** Er merkt nichts, es entsteht nur eine längere `eudora.log`.

## S9 — Messlücke in den Läufen a und b

`eudora-w123a-1.log` und `-w123b-1.log` melden `Version 7.2.0.102`, enthalten aber **keine**
E-123-Zeile, nicht einmal `E-123 Warteschlange`. Die müsste jedes `OnClose` dieses Quellstands
schreiben, solange ein IMAP-Konto eine Warteschlange hat (`ImapAccount.cpp:567`), und c und d
schreiben sie. Vermutlich stammen a und b von einem Zwischenbau mit derselben Versionsnummer. Das
ist eine Vermutung, alle Läufe liegen vor dem Commit (21:24–21:29, Commit 21:31).

Beweiskraft: d belegt das Warten, c den Weg ohne Warten (`uebertragungen=0`). a und b belegen für
7.2.0.102 nichts. Nach [Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md) ist das ein Fall für die
Regel: zwei Bauten unter einer Nummer.

**Anwender:** keine Wirkung, nur die Zahl der Belege ist kleiner als angegeben (zwei statt vier).

## S10 — kosmetisch

* `ImapAccountMgr.cpp:1270-1277`: Die neue Funktion steht zwischen dem Kopfkommentar von
  `FinishUpActionQueues` („Have each account finish processing its action queue.“) und deren
  Rumpf. Der Kommentar steht jetzt über der falschen Funktion.
* `mainfrm.cpp:5227-5228` und `ImapActionQueue.cpp:3936-3937` sagen „offline“. Gemeint ist nur
  die einzelne blockierte Warteschlange (S3).

**Anwender:** keine Wirkung.

## Was vor dem Release zu ändern ist

1. **S1:** Ein zweites `WM_CLOSE` während des Wartens ignorieren. Den Zeitgeber kein `WM_CLOSE`
   schicken lassen, solange ein Hochladen läuft (Zähler in `DoPostProcessing`) oder ein modaler
   Dialog offen ist (S5).
2. **S3:** Im Offline-Modus nicht warten.
3. **S4:** `KillTimer` vor `CloseDown`. `m_bE123Gewartet` zurücksetzen, wenn `CloseDown` FALSE
   liefert.
4. **S2:** Text in der Statuszeile während des Wartens.
5. Nach Möglichkeit **S6**: nur Übertragungen lokal → IMAP zählen.

**Gregors Test an 1.0.102:** Eine Mail aus einem lokalen Ordner in einen IMAP-Ordner verschieben
und **sofort einmal** beenden, dann **nicht ein zweites Mal klicken**. Richtig ist der Lauf, wenn
in `eudora.log` diese Zeilen stehen:

* `E-123 Beenden wartet auf 1 Uebertragung(en)`
* danach `E-121 Uebertragung: … hochgeladen=1`
* danach `E-123 Beenden: Warten zu Ende … offen=0`
* und `E-33 ExitInstance`
