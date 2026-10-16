# PRÜFER-31 — 7.2.0.97 bis 7.2.0.99 nachgerechnet

Gegenstand: `git diff 45ed40c0..8e5936aa -- Eudora71/` und `tools/paket-pruefen.ps1`, also
7.2.0.97 (PRUEFER-30 F1 und PRUEFER-29 N1 zu [E-121](../BEFUNDE.md#e-121)), 7.2.0.98 (zweite
Ursache von [E-83](../BEFUNDE.md#e-83)) und 7.2.0.99 (nur Versionsnummer, Defender-Schranke).
Gelesen am Quelltext, nichts gebaut, nichts gestartet. Zeilen beziehen sich auf `8e5936aa`.
Messdaten: `C:\Temp\E118\Mailverzeichnis\eudora-*.log` und Gregors Protokoll
`Eudora72-1.0.99-release\Mailverzeichnis\eudora.log` (nur gelesen; ab Zeile 1590 der Lauf mit
7.2.0.99, davor 7.2.0.96).

## Urteil

**PR `e-118_HTML_header` → `main` mergen: ja.** Die Behebungen tun, was sie sollen. Gregors Fall
(eine Mail aus `Out` nach IMAP) ist belegt: `id=0 im-ziel=1 … hochgeladen=1`, `neue-uid=15`. Und
alle 15 Läufe am Prüfstand mit 7.2.0.98/99 enden mit `ExitInstance: erreicht`. Keine der Behebungen
schreibt in den Papierkorb, keine gibt Speicher frei, auf den noch eine Nachricht zeigt.

**Release: erst nach F1.** F1 ist ein Weg zum Datenverlust (verzögert, über den lokalen
Papierkorb). Er öffnet sich, sobald mehrere Mails mit Kennung 0 in einer Übertragung stehen und
eine davon nicht sauber mit neuer UID hochkommt: der Server kennt kein UIDPLUS, `APPEND` scheitert
oder `RewriteMbxStub` scheitert. Dann wird dieselbe Vorab-Kopie mehrmals hochgeladen und die anderen
gar nicht. Bei Gregors Servern (UIDPLUS vorhanden) tritt es nur im Fehlerfall auf. Das Original
hatte denselben Mangel. Nach der Regel „kein Paket mit offenem Datenverlust“ gehört die Behebung
trotzdem vor das Release, und sie ist klein (zwei Stellen). F4 (Sperre über einem modalen Dialog)
sollte im selben Zug mit einer Zeile geschlossen werden.

| Fund | Einstufung | Stand |
|---|---|---|
| F1 Mehrere Mails mit Kennung 0: ohne neue UID bleibt die Vorab-Kopie markiert und wird erneut genommen | **Datenverlust** (verzögert, über den lokalen Papierkorb) | belegt am Quelltext, nicht gemessen |
| F2 Merkzeichen `m_bE121Quelle` bleibt hängen (Kopieren, Fehlschlag, Kennung 0, Fenster offen) | doppelt (Verschieben wird Kopieren); Datenverlust nur in einer Kette | Mechanik belegt, Schaden Vermutung |
| F3 Leere Kennungsliste sucht eine fremde Vorab-Kopie mit Kennung 0 | falsche Anzeige (ungewollt hochgeladen) | Vermutung, Mechanik belegt |
| F4 `SetDisplayWindow` hält `m_ObjGuard` über `RemoveTaskInfo` (Gruppenrückruf, Zertifikatsdialog) | Hänger (Verklemmung) | Vermutung, Sperrfolge belegt |
| F5 Der neue Zweig „ohne Anzeige“ lief nie; Kommentar nennt eine Ursache, die die Messung nicht zeigt | kosmetisch (Begründung), ungeprüfter Code | belegt (0 Marken) |
| F6 `aktiv=-10/10`: Zähler fällt je Aufgabe ohne Faden, alt | kosmetisch (Obergrenze gelockert) | belegt, nicht durch 7.2.0.98 |
| F7 Defender-Block: 32-Bit-PowerShell und Ausnahmepfade machen ihn stumm | kosmetisch (Prüflücke) | Vermutung |

Gefragte Gegenvermutungen, die **nicht** zutreffen (im Abschnitt „Widerlegt“ belegt):
* Vorab-Kopie wandert aus dem IMAP-Ordner in den Papierkorb: nein.
* `RemoveTaskInfo` aus `SetDisplayWindow` löscht vor der Nachbearbeitung oder hinterlässt eine Nachricht, die den Zeiger benutzt: nein.
* Doppeltes Entfernen: harmlos.

## F1 — Mehrere Mails mit Kennung 0: die Vorab-Kopie bleibt markiert — Datenverlust, belegt am Quelltext

Der Weg mit UIDPLUS und Erfolg ist richtig: `DoPostProcessing` sucht je Kennung
`E121FindeVorabKopie(m_pDestTocDoc, 0)` (`EuImap/src/ImapActionQueue.cpp:2365`), findet die erste
markierte Kopie mit Kennung 0 (`EuImap/src/ImapToc.cpp:1643-1650`), lädt sie hoch. Dabei bekommt
sie `pCopySum = pSum` (`ImapToc.cpp:1416-1417`), die neue UID (`:1452`) und verliert das Merkzeichen
(`:1453`). Die nächste Runde findet die nächste. Jede Kopie ist selbst der Inhalt ihrer Nachricht,
also wird jede genau einmal hochgeladen. Bei „0,0,0“ mit UIDPLUS findet also jede Mail ihre eigene
Vorab-Kopie.

Das Merkzeichen fällt aber **nur** im Zweig `bResult && NewUid` und dort nur nach gelungenem
`RewriteMbxStub` (`ImapToc.cpp:1396-1401`, `:1453`). In drei Fällen bleibt es stehen:

1. **Server ohne UIDPLUS** (`NewUid == 0`): Der Zweig `:1385-1393`, der die Vorab-Kopie
   entfernt, ist ausdrücklich nicht für Kennung 0 (`pSum->GetHash() != 0`). Die Kopie bleibt
   markiert, mit Kennung 0.
2. **`APPEND` scheitert** (`:1355`, `bResult = FALSE`): Die Kopie bleibt unverändert.
3. **`APPEND` gelingt, `RewriteMbxStub` scheitert** (`:1400`): Die Mail liegt auf dem Server, die
   Kopie bleibt markiert.

In allen drei Fällen nimmt die **nächste** Runde derselben Übertragung wieder **dieselbe**
Kopie, denn sie steht vorn in `m_Sums` (`AddTail`, `Eudora/tocdoc.cpp:1444`). Bei „0,0,0“
ohne UIDPLUS wird die erste Mail dreimal hochgeladen, die zweite und dritte nie. Die Spur zeigt
dreimal `id=0 im-ziel=1 … hochgeladen=1`, also sieht alles erfolgreich aus. Im Fall 2 erscheint
dreimal der Fehlerdialog für dieselbe Mail, die anderen werden nie versucht.

Was dann mit den nicht hochgeladenen geschieht:

* Ihre Quellen liegen schon seit dem Einreihen im **lokalen Papierkorb** (`ImapToc.cpp:1018-1027`).
  Aus `Out` wird nie bis zum Hochladen gewartet.
* Ihre Vorab-Kopien verwirft der Abgleich am Ende (`ImapActionQueue.cpp:2474-2476`), weil der
  Server sie nicht kennt.
* Die Quelle wird bei Kennung 0 nicht als Ersatz benutzt (`:2373`, `ulId != 0`). Selbst wenn sie es
  würde, sucht `pSrcToc` in `Out` und nicht im Papierkorb.
* Beim Beenden wird `EmptyTrash` aufgerufen (Gregors Protokoll, Zeilen `E-33 6b … vor EmptyTrash`).
  Leert die Einstellung dabei den Papierkorb, sind die Mails weg.

Dasselbe gilt **über Aufträge hinweg**: Ist der Auftrag nicht der letzte auf dem Ordner
(`m_bIsLastOnMailbox`, `:2474`), läuft kein Abgleich. Die liegengebliebene markierte Kopie ist dann
der erste Treffer des **nächsten** Auftrags mit Kennung 0. Dessen eigene Kopie bleibt liegen.

Auch Fall 1 bei Kennung ≠ 0 trifft unter Umständen die falsche Kopie: `:1387` sucht über die
Kennung, obwohl `pSum` selbst die Vorab-Kopie ist (`this == pTargetToc`). Liegen zwei Aufträge mit
derselben Kennung an, wird die Kopie des anderen entfernt. Die Folge ist ein Doppel auf dem Server,
kein Verlust: der andere Auftrag fällt auf die Quelle zurück.

Einordnung:
* **Kein Rückfall gegenüber dem Original:** `GetSummaryFromUID(0)` nahm dort ebenso immer den
  ersten Eintrag mit 0.
* **Kein Rückfall gegenüber 7.2.0.96:** Dort wurde gar nichts hochgeladen.
* **Gemessen ist es nicht:** In keinem Prüfstandsprotokoll steht `id=0`. In Gregors Protokoll
  steht es genau einmal, mit einer einzigen Mail. Der Fall „mehrere aus `Out` auf einmal“ ist ungeprüft.

Vorschlag (zwei Stellen):

* `ImapCopyMsgFromLocalToImap`: Ist `this == pTargetToc`, wird nach jedem Versuch das Merkzeichen
  an `pSum` gelöscht, also `pSum->SetE121Vorab(FALSE)`, bei Erfolg wie bei Misserfolg. Im Zweig ohne
  UIDPLUS wird `pVorab = pSum` genommen statt neu gesucht, dann gilt die Einschränkung auf Kennung ≠ 0
  dort nicht mehr. Die Kopie verwirft danach der Abgleich, die Quelle liegt im Papierkorb wie im Original.
* `DoPostProcessing`: die Zeiger der bereits versuchten Kopien merken (lokale Liste) und in
  `E121FindeVorabKopie` überspringen. Oder die Kopien aller Kennungen vor der Schleife einmal
  auflösen.

Gegenprobe am Prüfstand: drei Mails aus `Out` gleichzeitig in einen IMAP-Ordner verschieben.
Erwartet dreimal `id=0 im-ziel=1 hochgeladen=1` mit **drei verschiedenen** `neue-uid` und danach
`summen` um 3 höher. Für den Fall ohne UIDPLUS genügt es nicht, `APPEND` scheitern zu lassen. Zu
messen ist, dass nach dem Fehlschlag der ersten die zweite und dritte versucht werden.

## F2 — `m_bE121Quelle` bleibt hängen — doppelt; Datenverlust nur in einer Kette (Vermutung)

Gesetzt wird das Merkzeichen in `Eudora/tocdoc.cpp:2934`, im Zweig `if (!ToOut)` (`:2914`), also
**vor** der Unterscheidung `if (!Copy)` (`:2967`). Gelöscht wird es nie: weder im Konstruktor
eines anderen Objekts (`CSummary::Copy` übernimmt es nicht, `summary.cpp:581-606`, richtig) noch
in `DoPostProcessing`. Es bleibt an der Quelle stehen, wenn

* kopiert statt verschoben wurde (`m_bCopy`, `ImapActionQueue.cpp:2424`),
* das Hochladen scheiterte (`bHochgeladen == FALSE`),
* die Kennung 0 ist (gesendete Post in einem lokalen Ordner, `:2373`), in diesem Fall dauerhaft
  doppelt: Verschieben wirkt wie Kopieren,
* das Nachrichtenfenster sich nicht schließen ließ (`:2431-2434`),
* die Quelle aus `Out` in den Papierkorb ging (`ImapToc.cpp:1026`, dasselbe Objekt). Das ist harmlos.

Schaden nur bei Namensvettern im selben lokalen Ordner. Die sind nicht selten: aus IMAP geholte Mails
tragen ihre UID als Kennung, Gregors Protokoll zeigt `id=325` und `id=330`.

* **(a)** Ein hängendes Merkzeichen an X, dann wird Namensvetter Y verschoben: `nMarkiert = 2`
  (`:2394`), nichts wird entfernt, Y steht doppelt. Sicher, aber das Verschieben wirkt als Kopieren.
* **(b)** Ein hängendes Merkzeichen an X stammt aus einem **gescheiterten** Verschieben. Y wird
  verschoben, und der Nutzer löscht Y, bevor der Auftrag läuft (genau der Fall PRUEFER-29 N1). Jetzt
  ist X die einzige markierte Quelle, die Vorab-Kopie von Y wird hochgeladen, und **X wird
  entfernt**, obwohl X nie auf dem Server ankam. Drei Zufälle, aber ein Weg.

Vorschlag: in `Xfer` nur setzen, wenn `!Copy`, und in `DoPostProcessing` am Ende jeder Runde das
Merkzeichen aller Kandidaten dieser Kennung löschen (`pKandidat->SetE121Quelle(FALSE)`), bei Erfolg
wie bei Misserfolg. Löscht das das Merkzeichen eines zweiten, noch wartenden Auftrags derselben
Kennung, bleibt dessen Quelle stehen. Das ist die sichere Richtung.

## F3 — Leere Kennungsliste sucht eine fremde Vorab-Kopie mit Kennung 0 — falsche Anzeige, Vermutung

`ImapXferFromLocalToImap` reiht den Auftrag auch dann ein, wenn jede Nachricht übersprungen wurde
(`ImapToc.cpp:993` `continue` bei nicht schließbarem Fenster; `:1058` legt den Auftrag ohne
Bedingung an). Dann ist `strId` leer, `strtoul("") = 0`, und `:2365` sucht eine **beliebige**
markierte Kopie mit Kennung 0. Bis 7.2.0.96 lieferte die Suche bei 0 `NULL`. Eine solche Kopie
gibt es gerade in diesem Fall: `Xfer` hatte sie vor dem Überspringen schon angelegt
(`tocdoc.cpp:2921-2944`). Ein Beispiel ist eine Mail aus `Out`, deren Verfassen-Fenster der Nutzer
nicht schließen wollte. Die Folge: Sie wird hochgeladen, obwohl der Nutzer das Verschieben abgebrochen
hat. Sie bleibt in `Out` und steht dann zusätzlich auf dem Server. Bei zwei Mails, von denen nur
eine übersprungen wird, nimmt der Auftrag womöglich die Kopie der übersprungenen und lässt die
eigene liegen. Das ist dann der Verlustweg aus F1.

Vorschlag: am Anfang der Schleife `if (strId.IsEmpty()) break;`. In `ImapXferFromLocalToImap` bei
leerer Liste keinen Auftrag einreihen. Die Vorab-Kopie einer übersprungenen Mail gehört wieder
entfernt; das ist der Rest von F1 und ohne Messung nicht dringend.

## F4 — `SetDisplayWindow` hält `m_ObjGuard` über `RemoveTaskInfo` — Hänger, Vermutung

`Eudora/QCTaskManager.cpp:977` nimmt `m_ObjGuard` für die ganze Funktion. Die neuen Aufrufe
`RemoveTaskInfo` (`:1017-1018`, `:1067-1068`) laufen innerhalb dieser Sperre. Dort geschieht:

* `m_Guard_TaskInfoList` (`:819`),
* der Gruppenrückruf `gc()` (`:876`),
* der **modale** Zertifikatsdialog `trustCertDlg.DoModal()` (`:887`),
* `ScheduleTasks` → `AfxBeginThread` (`:914`).

Die Sperrfolge anderswo ist umgekehrt:

* `Register(CTaskInfoMT*)`: erst Liste, dann `m_ObjGuard` (`:161`, `:186`).
* `Register(CTaskErrorMT*)`: erst Fehlerliste, dann `m_ObjGuard` (`:206`, `:209`). Erreicht über
  `CTaskInfoMT::CreateError` (`TaskInfo.cpp:506-512`), das die Aufgaben aus ihrem eigenen Faden
  rufen.

Die Umkehrung gab es schon im Original: der Zweig `TOBJ_ERROR` in `SetDisplayWindow`, `:1022`. Dort
war das Fenster aber kurz. Jetzt kann es einen modalen Dialog und beliebigen Rückrufcode umfassen. In
dieser Zeit wartet ein Faden, der einen Fehler meldet, auf `m_ObjGuard` und hält dabei die
Fehlerliste. Greift der Hauptfaden in der Dialogschleife auf die Fehlerliste zu (Statusleiste,
`GetNumTaskErrors`, `:794`), stehen beide. Voraussetzung ist eine beim Umhängen schon fertige Aufgabe
mit offener Zertifikatsfrage oder mit Gruppe. Am Prüfstand traf das nie zu: `gruppe=0`, kein
Zertifikatsdialog. Deshalb ist das eine Vermutung.

Vorschlag (eine Zeile): vor den beiden Schleifen über `lErledigt` die äußere Sperre freigeben,
`lock.Unlock();`. `m_DispWndMap` ist da schon gesetzt, `pOldWnd` ist eine lokale Kopie, und die
Rückgabe braucht keine Sperre.

## F5 — Der neue Zweig „ohne Anzeige“ lief nie — kosmetisch / ungeprüft, belegt

Der Zweig `else if (pWnd && type == TOBJ_INFO)` (`QCTaskManager.cpp:1034-1069`) und die Marke
`ohne-Anzeige` in `Register` (`:198-199`) stehen in **keinem** Protokoll. Gezählt habe ich alle
`eudora-*98*.log` am Prüfstand und Gregors Lauf mit 7.2.0.99: `ohne-Anzeige` 0,
`Anzeige-nachgetragen` 0, `ohne-Anzeige-erledigt-entfernt` 0. Gewirkt hat der andere Zweig:
`beim-Umhaengen-schon-fertig-entfernt` je einmal in c1–c4 und d1–d2, und alle 15 Läufe mit
7.2.0.98/99 enden mit `ExitInstance: erreicht`. In Gregors Lauf meldet sich die Ansicht zuerst an
(`Ansicht-angemeldet` bei 0.00), dort griff keiner der beiden Zweige.

Der Kommentar bei `:1036-1045` nennt als Ursache der „sechs von sechs“ hängenden Läufe Aufgaben ohne
Anzeigefenster. Die Marken zeigen das nicht. Sie zeigen den Rahmen als altes Fenster, also den
ersten Zweig. Außerdem läuft der Zweig, wenn er je läuft, im **Konstruktor** von
`CTaskStatusWazooWnd` (`TaskStatusWazooWnd.cpp:55`). Dort hat der Rahmen noch kein `m_hWnd`. Das
`SetDisplayWnd(pWnd, true)` an `:1057` schickt dann `PostMessage` an `NULL` und erzeugt damit eine
Fadennachricht, die niemand auswertet. Die Aufgabe wäre wieder an einen Rahmen gebunden, der ihre
Abmeldung nicht kennt. Vermutung, weil der Zweig nie läuft. `Register` setzt mit
`ASSERT(m_DispWndMap[…])` (`:159`) ohnehin voraus, dass er nie gebraucht wird.

Vorschlag: den Kommentar nach den Marken berichtigen, so dass er als Ursache den Rahmen nennt, der
die Abmeldung nicht kennt. Den Zweig stehen lassen oder ausbauen; vor dem Release nicht nötig.

## F6 — `aktiv=-10/10` ist alt — kosmetisch, belegt

Hochgezählt wird `m_nActiveTasks` nur in `StartWorkerThread` (`QCTaskManager.cpp:559`).
Heruntergezählt wird es in `RemoveTaskInfo` ohne Bedingung (`:831`). Laut `git blame` steht das so
seit dem Original-Import `567a5d87`. Jede Aufgabe, die eingetragen und entfernt wird, ohne zu
starten, senkt den Zähler um eins. Im Protokoll sind das die Zeilen
`eingetragen: … zustand=ERZEUGT(1) m_pThread=NULL … typ=3`.

* Gregors Lauf mit **7.2.0.96** (Zeilen 1–1589): zehn solche Einträge, der Zähler fällt
  stufenweise auf −10 (−1 bis −8 je einmal, −9 41-mal, −10 45-mal). Das gefragte −11 kommt nicht vor.
* Am Prüfstand steht −1 schon an 7.2.0.87, 7.2.0.89, 7.2.0.90 (`eudora-vorher.log`,
  `eudora-lauf1.log`, `eudora-e121-*.log`). In `eudora-g96-1.log` (7.2.0.96) steht ebenfalls −1.
* Gregors Lauf mit 7.2.0.99: keine Aufgabe ohne Faden, Werte nur 0 bis 2.

7.2.0.98 hat daran nichts geändert. Die neuen Entfernungen betreffen nur Aufgaben, die nicht mehr
leben, und die hatten gestartet. Die Wirkung ist gering: Regel 1 in `ScheduleTasks` (`:503`,
`m_nActiveTasks == m_nMaxConcurrentTasks`) greift später, es laufen also mehr als zehn Aufgaben
zugleich. Gefährlich wäre die Gegenrichtung, ein Zähler, der dauerhaft auf 10 steht. Die kommt nur
von liegengebliebenen, gestarteten Aufgaben, also von [E-83](../BEFUNDE.md#e-83) selbst, und die räumt 7.2.0.98 jetzt ab.
Vorschlag: nur zurückzählen, wenn `m_pWinThread` gesetzt ist. Nicht vor dem Release nötig.

## F7 — Defender-Block in `tools/paket-pruefen.ps1` — Prüflücke, Vermutung

Die Logik stimmt:

* Rückgabe 2 von `MpCmdRun -Scan -ScanType 3 -File … -DisableRemediation` bedeutet „Bedrohung
  gefunden“ und führt zu einem Fehler.
* Der Ausdruck `Threat\s*:\s*(\S+)` trifft die Zeile `Threat : <Name>` im Fundbericht. Die
  Überschrift `Threat information` hat keinen Doppelpunkt danach, ein Fehlalarm darüber ist also
  ausgeschlossen.
* Jede andere Rückgabe ungleich 0 ist eine Warnung, zum Beispiel ein anderer Virenschutz aktiv oder
  die Datei gesperrt.
* `-in` vergleicht ohne Rücksicht auf Groß- und Kleinschreibung.
* `$ErrorActionPreference = 'Continue'` (`:76`) sorgt dafür, dass `2>&1` keinen Abbruch auslöst.

Zwei Fälle, in denen der Block **grün und stumm** bleibt:

1. In einer **32-Bit-PowerShell** ist `$env:ProgramFiles` gleich `C:\Program Files (x86)`.
   `MpCmdRun.exe` wird dann nicht gefunden, es bleibt bei einer Warnung, und `exit 0` (`:750`) lässt
   das Paket durch. Abhilfe: `$env:ProgramW6432` zuerst, sonst
   `C:\ProgramData\Microsoft\Windows Defender\Platform\*\MpCmdRun.exe` (die aktuelle Plattform).
2. Liegt das Bau- oder Paketverzeichnis in einer **Defender-Ausnahme** (`Get-MpPreference`,
   `ExclusionPath`), meldet der Scan „no threats“, ohne zu prüfen. Ich habe das nicht nachgesehen,
   nichts gestartet. Vorschlag: einmal `(Get-MpPreference).ExclusionPath` gegen `$Paket` halten und bei
   Treffer warnen.

Gegentest fehlt: Belegt ist nicht, dass der Block einen echten Fund meldet. Probe mit der
EICAR-Testdatei, umbenannt auf `.exe`, in einem Kopie-Paket (Lehre „Schranke gegentesten“).
Der Kommentar nennt die Grenze richtig: das Urteil aus der Cloud kann später kommen.

7.2.0.99 sonst: `Version.h:11-14` nennt viermal denselben Stand, und das Diff enthält außer der
Versionsnummer keinen Quelltext.

## Widerlegt — gefragte Gegenvermutungen

**Vorab-Kopie wandert in den Papierkorb (Frage 1c): nein, belegt.** Die Verschiebung in den
Papierkorb steht nur in `ImapXferFromLocalToImap` (`ImapToc.cpp:1018-1027`). Dort ist `this` die
**Quelle** (`Out`), und `pSum` stammt aus deren Auswahlliste. Der Vorgang läuft beim Einreihen, vor
jedem Hochladen. `ImapCopyMsgFromLocalToImap` (`:1333-1471`) enthält keinen Weg in den Papierkorb.
`DoPostProcessing` entfernt nur bei `pMarkiert`, und das ist bei Kennung 0 immer `NULL` (`:2373`).
Zusätzlich gilt dort `pSrcToc != m_pDestTocDoc` (`:2424`). Gregors Protokoll zeigt dieselbe
Reihenfolge:

* `Leeway 10, Trash: MBX 1792065068` bei 1.33 betrifft den **lokalen** Papierkorb (derselbe
  Zeitstempel wie Zeile 96).
* Danach erst `eingereiht: uid=12 … "Transferring"`, dann `Hochgeladen … neue-uid=15` bei 1.34.
* Nach 1.34 greift nichts mehr auf `Trash.mbx` zu. Der Zugriff ist der des Originals: die
  `Out`-Quelle wird in den Papierkorb gelegt.

**Ziel als Quelle (`this == pTargetToc`) ist neu? Nein.** Den Aufruf
`m_pDestTocDoc->ImapCopyMsgFromLocalToImap(pSum, m_pDestTocDoc, …)` gab es schon in `45ed40c0`
(Zeile 2392). Neu ist nur `pCopySum = pSum`. `RewriteMbxStub` mit Quelle = Ziel liest den Text über
das Dokument der Zusammenfassung (`ImapToc.cpp:4672-4683`), nicht über Versatz und Datei. Seit
[E-121](../BEFUNDE.md#e-121) Teil 1 ist das an Gregors Tests bestätigt.

**`RemoveTaskInfo` aus `SetDisplayWindow`, zu früh oder mit wartender Nachricht: nein.**

* Entfernt wird nur, was `!IsAlive()` ist. `m_bDead` setzt allein `Kill()`
  (`TaskObject.cpp:107-120`), und das ruft allein `CTaskInfoMT::DoPostProcessing`, nach dem letzten
  Aufruf der Nachbearbeitung und nur, wenn keine weitere angefordert ist (`TaskInfo.cpp:443-460`).
  Die Nachbearbeitung ist also gelaufen.
* `Kill` hat `msgTaskViewInfoDead` mit dem Zeiger an das **damalige** Fenster geschickt, den
  Rahmen (`TaskInfo.cpp:116`). Der Rahmen behandelt nur `msgTaskViewInfoAlive`
  (`TaskStatusWazooWnd.cpp:44`) und benutzt den Zeiger auch dort nicht (`:136-147`). Die
  Abmeldung verfällt ungelesen.
* Im Zweig ohne altes Fenster wurde nie etwas zugestellt (`m_pDisplayWnd == NULL`).
* Ein noch stehender Eintrag in `m_PostProcessList` wird vor der Benutzung gegen die Liste geprüft
  (`QCTaskManager.cpp:695`, `find`). Ein wiederverwendeter Speicherplatz träfe ein gültiges Objekt.
* Wettlauf zwischen `IsAlive` und `Kill`: keiner, beide laufen im Hauptfaden.

**Doppeltes Entfernen: harmlos.** `RemoveTaskInfo` sucht über die UID und ändert nichts, wenn sie
fehlt; es läuft dann nur `ScheduleTasks`. Der neue Zweig in `CTaskStatusView::OnMsgDeleteInfo`
(`TaskStatusView.cpp:416-428`) greift nicht auf `pInfo` zu, nur auf `nUID`. Kommt die Abmeldung
nach einer Entfernung in `SetDisplayWindow`, geschieht nichts. Der Zähler `m_nActiveTasks` sinkt nur
beim tatsächlichen Löschen (`:831` steht innerhalb des Treffers).

**Gruppenrückruf:** wird wie im Original beim letzten Mitglied gerufen, jetzt eben aus
`SetDisplayWindow` heraus. Das ist die Lage aus F4. Eine Verdopplung gibt es nicht, weil
`RemoveTaskInfo` die Aufgabe vor dem Rückruf aus der Liste nimmt (`:828`).

## Bestätigt

* PRUEFER-30 F1 ist für eine einzelne Mail aus `Out` behoben, belegt in Gregors Lauf:
  `id=0 im-ziel=1 in-quelle=0 markiert=0 hochgeladen=1`, `summen` 15 vor und nach dem Abgleich.
* PRUEFER-29 N1 ist behoben. Entfernt wird nur die markierte Quelle (`ImapActionQueue.cpp:2424`),
  ohne Merkzeichen bleibt die Quelle stehen. Am Prüfstand 25-mal und bei Gregor zweimal
  `markiert=1` mit `hochgeladen=1`. `markiert=1` ohne Hochladen kommt nicht vor.
* [E-83](../BEFUNDE.md#e-83) zweite Ursache ist behoben. Alle 15 Läufe mit 7.2.0.98/99 am Prüfstand beenden sauber, in
  sechs davon greift die neue Entfernung. Gregors Lauf mit 7.2.0.99 endet ebenfalls mit
  `ExitInstance: erreicht`.
