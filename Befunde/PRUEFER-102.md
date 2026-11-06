# <a id="pruefer-102"></a>PRUEFER-102

Geprüft habe ich den Zweig `e239_absturz_beenden`. Mein Zweig ist wt/pruefer-20261105c, abgezweigt von `origin/e239_absturz_beenden` (Stand `3282be36`). Geprüft ist alles, was seit `0dfce844` unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam: die Commits `4667839c` und `3282be36` zu [E-239](../Intern/BEFUNDE.md#e-239). Das sind `mainfrm.cpp`/`mainfrm.h`, der neue Test `TestE239.cpp`, `tools/messen-e239.ps1` und der Fall `E-239p` in `pruefstand-faelle.txt`. Unter `Releases/1.0` hat sich nichts geändert. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet und keinen Prüfstand laufen lassen. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Aus dem Prüfstand `C:\Temp\E239` habe ich nur zwei Dateien **gelesen**: `modus.txt` und `Mailverzeichnis\eudora.log`. Daraus stammen die Messwerte in §3.

## Ergebnis vorweg

Die Behebung beseitigt den gemessenen Absturz. Sie tut das aber anders, als Befund und Test es beschreiben. Wirksam ist vor allem der **Aufschub**: Kommt ein Schließwunsch, während ein Dialog das Hauptfenster sperrt, wartet Eudora, bis der Dialog zu ist, und beendet sich dann. In den neun Prüfstandläufen mit der Endfassung lief **nur dieser Weg** (gemessen im `eudora.log`). Der Merker gegen ein zweites `CloseDown` kam dort kein einziges Mal zum Zug. Den Zeitgeber, der `DestroyWindow` nachholt, hat er nie gebraucht, das erledigte jedes Mal MFC selbst. Beide Teile sind am Quelltext sinnvoll (§1). Gemessen sind sie in der Endfassung aber nicht.

**Der Regressionstest schützt die Behebung kaum (K1).** Ich habe `mainfrm.cpp` auf sieben Arten vorübergehend verändert. **Sechs** davon lässt `TestE239` durch, darunter die eine Zeile, die den Absturz verhindert (das `return;` hinter dem Merker). Rot wird der Test nur, wenn eine der abgefragten `if`-Zeilen selbst fehlt. Auch der Prüfstandfall `E-239p` kann grün melden, ohne dass der Fehlerweg durchlaufen wurde (K2).

**Eudora bleibt nicht für immer offen.** Am Quelltext gibt es keinen Weg, auf dem der Aufschub ewig wartet, solange Dialoge irgendwann geschlossen werden (§1). **Die Windows-Abmeldung wird durch [E-239](../Intern/BEFUNDE.md#e-239) weder blockiert noch ohne `CloseDown` hart beendet.** Der Weg, den Gregor im Testplan (2) prüfen soll, läuft wie vor der Behebung durch `CloseDown` (§2). Er ist weiterhin nicht gemessen.

Zwei Randfälle stehen am Quelltext (K4, K5): Im Modus *nur im Infobereich* deutet die Behebung ein abgebrochenes Beenden als OLE-Fall und beendet Eudora trotzdem. Ein aufgeschobener Schließwunsch kann außerdem ein späteres *Abbrechen* einmal übergehen. Für Gregors Test gibt es einen Weg, den der Anwender wirklich erreicht: *Exit* im Menü des Symbols im Infobereich, während der Hinweis offen ist (K7).

**Kein Fund hält das Paket 7.2.2.136 auf.** K1 und K2 sollten vor dem Merge oder spätestens mit dem Paket nachgezogen werden, weil sonst eine spätere Änderung den Schutz unbemerkt entfernen kann. Neue E-Kennungen vergebe ich nicht. Alles gehört als Rest zu [E-239](../Intern/BEFUNDE.md#e-239). `befund-suchen.pl OnTrayCallback` und `befund-suchen.pl SaveAllModified` melden keinen bestehenden Befund.

## 1. Was die Behebung am Quelltext tut

**Aufschub (belegt).** `CMainFrame::OnClose` kehrt bei gesperrtem Hauptfenster zurück (`mainfrm.cpp:5687-5696`). Der Zeitgeber `E239_SCHLIESSEN_TIMER_ID` wird nur einmal gestellt, dafür sorgt der Merker `m_bE239SchliessenWartet`. Ein weiterer Schließwunsch während desselben Dialogs geht still verloren, ist aber durch den einen nachgeholten abgedeckt. `OnTimer` schickt `WM_CLOSE`, sobald das Fenster wieder frei ist, und löscht Zeitgeber und Merker (:1998-2008). Das `WM_TIMER` wird auch in der Schleife des Dialogs zugestellt, denn ein modaler Dialog holt alle Botschaften des Fadens. Während der Dialog offen ist, tut der Zeitgeber also nichts.

**Merker ab `CloseDown == TRUE` (belegt).** Er wird gesetzt bei :5737 und in `OnClose` vor der Prüfung auf Sperre abgefragt (:5674). Diese Reihenfolge ist richtig. Ein Schließwunsch, der kommt, während ein Dialog **im** Beenden offen ist (etwa der Hinweis aus `~CPOPSession` während `CloseAllDocuments`), wird ignoriert und nicht noch einmal aufgeschoben. Zurückgesetzt wird der Merker nur, wenn das Fenster nach `QCWorkbook::OnClose` noch **sichtbar** steht (:5862-5868). Das passt zu MFC: `CFrameWnd::OnClose` kehrt vor `HideApplication` nur bei `CanCloseFrame`/`SaveAllModified == FALSE` zurück (MFC 14.38 `winfrm.cpp:855-875`).

**DestroyWindow nachholen (belegt).** Die MFC-Annahme stimmt. `AfxOleOnReleaseAllObjects` zerstört das Hauptfenster nur, wenn es nicht gesperrt ist (`olelock.cpp:33-38`). Vorher setzt es `AfxOleSetUserCtrl(TRUE)` (:27) und versucht es danach nie wieder. Der Zeitgeber `E239_ZERSTOEREN_TIMER_ID` (:2010-2035) schließt diese Lücke. Bleiben OLE-Objekte für immer offen, bleibt auch der Prozess für immer versteckt. Das war schon vorher so. Neu ist nur, dass alle 5 s eine Zeile ins Protokoll geschrieben wird.

**`g_Nicknames` (belegt).** `CloseDown` ruft `g_Nicknames->` nur noch hinter der Prüfung auf NULL auf (:5972). Das ist dieselbe Form wie bei `CanCloseFiltersFrame`.

**Gegenvermutung (1): „Eudora endet nie“ (belegt, nicht bestätigt).**
* Der Zeitgeber des Aufschubs läuft, bis das Fenster frei ist. Eine Obergrenze wie die 5 Minuten bei [E-123](../Intern/BEFUNDE.md#e-123) gibt es nicht. Gesperrt wird das Hauptfenster aber nur durch Dialoge und durch vier Stellen, die die Sperre selbst wieder aufheben: `progress.cpp:403/475`, `summary.cpp:3078/3108`, `tocview.cpp:3860/4079` und `guiutils.cpp:3475/3509`. Bleibt die Sperre hängen, ist Eudora ohnehin nicht mehr bedienbar. `WM_QUERYENDSESSION` prüft die Sperre nicht und beendet auch dann.
* Arbeitet der Anwender nach dem Aufschub weiter? Das kann er nicht. Höchstens 500 ms nach dem Schließen des Dialogs kommt das `WM_CLOSE`, und das ist das gewünschte Beenden.
* Zusammenspiel mit [E-123](../Intern/BEFUNDE.md#e-123) (`mainfrm.cpp:5697-5717`, :2037-2130): Der Zeitgeber von [E-123](../Intern/BEFUNDE.md#e-123) schickt `WM_CLOSE` nur bei freiem Fenster (:2048, :2120-2129). Ein nachgeholtes `WM_CLOSE` während des Wartens von [E-123](../Intern/BEFUNDE.md#e-123) wird von :5697 ignoriert. Daraus entsteht kein Kreis.
* Die Kennungen der Zeitgeber 1003/1004 kollidieren mit keinem anderen `SetTimer` am Hauptfenster (`mainfrm.cpp:2280`, :9548, nur 1000/1001/1002).

**Gegenvermutung (3): Zeitgeber feuert nach dem Zerstören (gemessen, nicht bestätigt).** Windows löscht die Zeitgeber eines Fensters zusammen mit dem Fenster. Im Lauf ab `eudora.log:4071` war ein Aufschub gestellt, und das Fenster wurde vorher zerstört (:4087 → :4122). Danach steht keine Zeile *nachgeholt* mehr, und `ExitInstance` wurde erreicht.

**Gegenvermutung (4): [E-33](../Intern/BEFUNDE.md#e-33)/[E-40](../Intern/BEFUNDE.md#e-40)/[E-123](../Intern/BEFUNDE.md#e-123) (belegt).** Die Spuren von [E-33](../Intern/BEFUNDE.md#e-33) bleiben unverändert. [E-40](../Intern/BEFUNDE.md#e-40) sorgt dafür, dass eine Rückfrage, die nicht aufgeht, als *Abbrechen* gilt. Genau das ist der Fall *sichtbar*, in dem der Merker zurückgesetzt wird. Danach ist Eudora aber nur noch zur Hälfte da, und zwar schon vor der Behebung (T1). `SaveOpenWindows(TRUE)` stellt die Rückfragen jedes offenen Fensters schon in `CloseDown` (:2730). Damit wird `SaveAllModified` in `CFrameWnd::OnClose` selten noch etwas fragen.

## 2. Windows-Abmeldung (Gegenvermutung 2)

**Blockiert [E-239](../Intern/BEFUNDE.md#e-239) die Abmeldung? Nein (belegt).** `OnQueryEndSession` (:5578-5604) prüft die Sperre nicht. Ist der Hinweis offen und läuft noch kein Beenden, ruft es wie bisher `CloseDown`, innerhalb der Schleife des Hinweises. Eine Rückfrage aus `CloseDown` (*tasks running*, `WarnYesNoDialog` :5918; Warteschlange `AlertDialog` :5563) hält die Abmeldung auf. Das war schon im Original so. Danach kommt `WM_ENDSESSION`. Ein eigenes `OnEndSession` hat `CMainFrame` nicht (`grep ON_WM_ENDSESSION`: nur `ON_WM_QUERYENDSESSION`, :503). Also läuft `CFrameWnd::OnEndSession` mit `CloseAllDocuments(TRUE)` und `ExitInstance` (`winfrm.cpp:1208-1212`). Die Postfächer werden dabei geschlossen. Die Aufräumschritte aus `OnClose` (`TocCleanup`, IMAP trennen, …) laufen bei der Abmeldung nicht, auch das wie vorher.

**Hart ohne `CloseDown`? Nur, wenn `CloseDown` schon gelaufen ist (belegt).** `return (TRUE)` ohne `CloseDown` gibt es nur bei gesetztem `m_bE239BeendenLaeuft`. Dann hat `CloseDown` bereits zugestimmt. Was danach geschieht, steht in K6. Gregors Testschritt (2) („Hinweis offen lassen, abmelden“) trifft den Weg **ohne** Merker, also den Weg des Originals. Am Prüfstand ist er mit der Behebung nicht gemessen: alle drei `endsession`-Läufe (`TESTLAEUFE.md`, 19:30:48, 19:32:21, 19:33:38) liefen am alten Bau `1cf4a59f`.

## 3. Trifft die Messung den Weg?

Aus `C:\Temp\E239\Mailverzeichnis\eudora.log` (Stand 21:47) habe ich die Zeilen zu [E-239](../Intern/BEFUNDE.md#e-239) ausgezählt (gemessen):

| Spurzeile | Anzahl im ganzen Log | davon in den 9 Läufen der Endfassung (ab Zeile 3698) |
|---|---|---|
| `E-239 Beenden aufgeschoben` | 7 | 7 |
| `E-239 Beenden nachgeholt` | 6 | 6 |
| `E-239 Beenden laeuft schon` | 8 | **0** |
| `DestroyWindow aufgeschoben (OLE)` | 13 | 9 |
| `aufgeschobenes DestroyWindow nachgeholt` | **0** | **0** |
| `Fenster steht noch sichtbar` | 0 | 0 |
| `E-239 Beenden wartet` | 12 | 0 (nur erste Fassung) |

Daraus folgt (gemessen):
* In allen 9 Läufen der Endfassung schob `CFrameWnd::OnClose` `DestroyWindow` wegen offener OLE-Objekte auf. Das gilt auch beim Beenden ohne Dialog (Läufe ab :4417 und :4658). Zerstört hat das Fenster jedes Mal MFC über `AfxOleOnReleaseAllObjects`, nie der neue Zeitgeber. Das normale Beenden lief also schon immer über diese Stelle in MFC. Der Zeitgeber ist eine Absicherung, die nie gebraucht wurde.
* Der Merker (`laeuft schon`) kam nur in der ersten Fassung vor (:3681, :3689). Mit dem Aufschub kommt der Prüfstandfall gar nicht mehr in den Zustand „Beenden läuft, und dann ein zweiter Schließwunsch“. Grün bei `exit-close` heißt also: der Aufschub wirkt. Der Schutz gegen das zweite `CloseDown` und die Prüfung auf NULL sind in der Endfassung nicht gemessen.
* Im Lauf ab :4071 kam der erste Schließwunsch bei freiem Fenster an und lief in `CloseDown` hinein. Der zweite wurde aufgeschoben (:4087), also **vor** :5737. Das heißt: Der Dialog, den das Skript als „Hinweis“ zählte, stand in `CloseDown` und war vermutlich die Rückfrage *tasks running*, nicht der Hinweis nach dem Abruf (`pruefstand-faelle.txt` nennt diese Rückfrage ebenfalls). `E239 PROBE ok` prüft nur, dass nach dem `QUIT` **irgendein** `#32770` sichtbar war (`messen-e239.ps1:191-211`, :286).

## 4. Gegenproben am Test

`TestE239.cpp` liest `mainfrm.cpp` zur Laufzeit (`QT_LiesNurCode`). Ich habe `mainfrm.cpp` vorübergehend mit Perl (`:raw`, Ersatz über Regex, Trefferzahl je 1) geändert, `EudoraTests.exe` gefahren und die Datei aus der Sicherung zurückgeholt. Nach jeder Probe meldete `cmp` „gleich“. `git status` ist leer, die Zeilenenden sind wie in HEAD (CRLF 18, nur-LF 10807, >127: 0).

| Probe | Änderung | Ergebnis (gemessen) |
|---|---|---|
| ohne | Stand `3282be36` (`RunTests.cmd`, gebaut) | 426 Tests, 426 bestanden |
| G0 | `mainfrm.cpp` von `0dfce844` | 425 bestanden, 1 rot (9 Abweichungen) |
| G1 | `m_bE239SchliessenWartet = FALSE;` im Zeitgeber gestrichen | **426 bestanden** |
| G2 | `KillTimer(E239_SCHLIESSEN_TIMER_ID);` gestrichen (alle 500 ms ein neues `WM_CLOSE`) | **426 bestanden** |
| G3 | `return;` des Aufschubs gestrichen (beendet doch in der Schleife des Dialogs) | **426 bestanden** |
| G4 | `if (IsWindowVisible())` → `if (!IsWindowVisible())` | **426 bestanden** |
| G5 | `return (TRUE);` im Merker-Zweig von `OnQueryEndSession` gestrichen | **426 bestanden** |
| G6 | `return;` hinter *weiteres Schliessen ignoriert* gestrichen (der Absturzweg ist wieder offen) | **426 bestanden** |
| G7 | `if (!IsWindowEnabled())` → `if (FALSE && !IsWindowEnabled())` | 425 bestanden, 1 rot |

## Funde

### <a id="k1"></a>K1 (mittel, gemessen): Der Regressionstest lässt die wirksamen Zeilen der Behebung fallen

`TestE239` prüft die **Lage** der `if`-Zeilen (`QT_Stelle`) und ob bestimmte Zeichenketten irgendwo im Abschnitt stehen. Was in den Zweigen passiert, prüft er nicht. Sechs von sieben Gegenproben bleiben grün (§4). Darunter ist G6: Ohne das `return;` hinter dem Merker läuft ein zweites `WM_CLOSE` wieder durch `CloseDown`. Das ist genau der gemessene Absturz, aufgefangen nur noch durch die Prüfung auf NULL. Darunter ist auch G3: Ohne das `return;` des Aufschubs ist der Teil weg, der am Prüfstand tatsächlich wirkt (§3). Und G2: Der Zeitgeber würde nach einem *Abbrechen* alle 500 ms ein neues Beenden auslösen. **Vorschlag:** jeden Zweig als ganzen Block prüfen, den `QT_LiesNurCode` auf ein Leerzeichen zusammenzieht, zum Beispiel `if (m_bE239BeendenLaeuft) { PutDebugLog(…); return; }`. Ebenso die Blöcke `if (!IsWindowEnabled()) { … } return; }` und `case E239_SCHLIESSEN_TIMER_ID: if (IsWindowEnabled()) { KillTimer(…); m_bE239SchliessenWartet = FALSE; … PostMessage(WM_CLOSE); } return;` sowie `if (m_bE239BeendenLaeuft) { …; return (TRUE); }` in `OnQueryEndSession`. Danach G1 bis G6 wiederholen.

### <a id="k2"></a>K2 (mittel, gemessen/belegt): Der Prüfstand misst nur den Aufschub und kann grün melden, ohne den Fehlerweg zu treffen

1. In der Endfassung sind Merker und `DestroyWindow`-Zeitgeber nie gelaufen (§3, gemessen). Der Befund nennt sie unter *Behebung* gleichrangig. Das Urteil *rot/grün* gilt aber nur für den Aufschub.
2. `E-239p` verlangt `absturz=0 beendet=1` (`pruefstand-faelle.txt`), nicht `hinweis=1`. Das Skript nimmt außerdem jeden Dialog nach dem `QUIT` als Hinweis (§3).
3. Die Betriebsart steht nicht im Fall, sondern in `C:\Temp\E239\modus.txt`, außerhalb des Repos. Heute steht dort `exit-close` (gelesen, 21:48). Kein Werkzeug schreibt die Datei (`grep modus.txt tools/pruefstaende-auffrischen.ps1 tools/pruefstand-lauf.ps1`: nichts). Ohne die Datei gilt `einfach` (`messen-e239.ps1:58`). Mit `einfach` stürzte auch der alte Bau nicht ab (Befund: 0 von 2). Ein frisch angelegter Prüfstand prüft den Absturz also nicht mehr.

**Vorschlag:** Das Skript soll ein Gesamturteil ausgeben, etwa `E239 URTEIL gruen`, und zwar nur dann, wenn `hinweis=1` und `absturz=0 beendet=1` gelten und der Dialogtext der Hinweis nach dem Abruf ist. Der Fall verlangt dann genau diese Zeile. Die Betriebsart gehört als Schalter in die Fallzeile oder wird bei `-Vorbereiten` geschrieben. Das Skript soll die Zeilen zu [E-239](../Intern/BEFUNDE.md#e-239) aus `eudora.log` mit ausgeben (aufgeschoben/laeuft schon/nachgeholt). Erst damit lässt sich ablesen, welcher Teil der Behebung gewirkt hat.

### <a id="k3"></a>K3 (gering, belegt): Das Grün lässt sich keinem Commit zuordnen

`tools/TESTLAEUFE.md` zeigt dieselbe Bau-Kennung `7.2.2.135+0dfce844* 2026-11-05 19:40` für die Läufe mit *„musste abgeschossen werden“* (20:09:53 bis 20:17:12, erste Fassung) und für die grünen Läufe (21:36:32 bis 21:47:27). Das Sternchen sagt: Der Bau hatte uncommittete Änderungen. Die Uhrzeit ist nicht der Bauzeitpunkt (`kennung-erzeugen.pl:28-35`). Der Befund nennt für *grün mit der Behebung* keine Kennung. Ob der gemessene Bau dem Stand `3282be36` entspricht, lässt sich deshalb nicht belegen. **Vorschlag:** `E-239p` im vollen Prüfstandlauf am Paketbau 7.2.2.136 fahren und dessen Kennung in den Befund schreiben. Der Lauf steht vor dem Paket ohnehin an.

### <a id="k4"></a>K4 (gering, belegt; Erreichbarkeit Vermutung): Im Modus *nur im Infobereich* gilt ein abgebrochenes Beenden als OLE-Fall, und Eudora beendet sich trotzdem

Die Behebung unterscheidet die beiden Fälle nach dem Rückweg aus `CFrameWnd::OnClose` nur an `IsWindowVisible()` (:5864). Mit *Show only in tray* (`IDS_INI_SHOW_ONLY_IN_TRAY`) ist das Hauptfenster versteckt, wenn es minimiert ist (`SetIcon`, :2296-2297). `SetIcon(FALSE)` in `OnClose` (:5766) zeigt es dann nicht wieder an. Nehmen wir an, der Anwender wählt im Menü des Symbols *Exit* (`EudoraRes.rc:6353`, `OnTrayCallback` :2227). `SaveAllModified` fragt, und er drückt *Abbrechen* (`winfrm.cpp:874-875`). Dann steht das Fenster noch und ist versteckt. [E-239](../Intern/BEFUNDE.md#e-239) stellt den Zeitgeber für `DestroyWindow`. Bei `AfxOleCanExitApp() == TRUE` zerstört er 500 ms später das Hauptfenster mit dem Dokument, das der Anwender behalten wollte. Vor der Behebung blieb ein versteckter Prozess ohne Symbol im Infobereich zurück (`TrayItem NIM_DELETE` :5791). Der war über einen zweiten Start erreichbar (Vermutung). Selten ist der Fall, weil `SaveOpenWindows` die Rückfragen schon stellt (§1). **Vorschlag:** Den OLE-Fall an dem Merkmal erkennen, das MFC selbst setzt. Nur im OLE-Zweig ruft `CFrameWnd::OnClose` `AfxOleSetUserCtrl(FALSE)` auf (`winfrm.cpp:898`). Also den Zeitgeber nur bei `!AfxOleGetUserCtrl()` stellen und sonst den Merker zurücksetzen.

### <a id="k5"></a>K5 (gering, Vermutung; der Weg ist gemessen): Ein aufgeschobener Schließwunsch übergeht ein späteres *Abbrechen*

Der Zeitgeber des Aufschubs wird nur gelöscht, wenn er sein `WM_CLOSE` schickt. Zwei Folgen:
* (a) Im Lauf `eudora.log:4071-4087` (gemessen) wurde ein Schließwunsch aufgeschoben, während die Rückfrage **in** `CloseDown` offen stand. Drückt der Anwender dort *Abbrechen*, liefert `CloseDown` FALSE. 500 ms später schickt der Zeitgeber `WM_CLOSE`, und die Rückfrage erscheint noch einmal.
* (b) `OnQueryEndSession` löscht den Zeitgeber von [E-123](../Intern/BEFUNDE.md#e-123), ausdrücklich *„damit nach einem abgebrochenen Herunterfahren nichts von selbst schliesst“* (:5580-5589). Den Zeitgeber des Aufschubs löscht es nicht. Wird die Abmeldung abgebrochen, beendet sich Eudora, sobald der Hinweis zu ist.

Beides setzt einen Schließwunsch bei gesperrtem Fenster voraus. Den erzeugen Skripte, `taskkill` ohne `/F` oder das Symbol im Infobereich (K7). **Vorschlag:** Zeitgeber und Merker löschen, wenn `CloseDown` in `OnClose` FALSE liefert und in `OnQueryEndSession`.

### <a id="k6"></a>K6 (gering, Vermutung): Abmeldung bei laufendem Beenden: `CloseAllDocuments` läuft verschachtelt in sich selbst

Steht `m_bE239BeendenLaeuft`, antwortet `OnQueryEndSession` mit TRUE (:5594-5598). Das passiert zum Beispiel, wenn der Hinweis aus `~CPOPSession` während `CloseAllDocuments` in `CFrameWnd::OnClose` offen ist. Danach ruft `CFrameWnd::OnEndSession` `CloseAllDocuments(TRUE)` und `ExitInstance` (`winfrm.cpp:1208-1212`), und zwar innerhalb des noch laufenden `CloseAllDocuments(FALSE)`. Das innere schließt alle Dokumente. Das äußere läuft danach auf einer Liste weiter, die es nicht mehr gibt. Die Folge ist womöglich ein Absturz während der Abmeldung, nachdem gesichert ist. Das ist nicht schlechter als vor der Behebung: dort stürzte `CloseDown` an `g_Nicknames == NULL` ab. **Vorschlag:** am Prüfstand `endsession` mit der Endfassung messen, auch mit Hinweis **während** des Beendens. Eine eigene Fassung von `OnEndSession`, die bei gesetztem Merker nur `ExitInstance` ruft, erst nach dieser Messung erwägen.

### <a id="k7"></a>K7 (gering, belegt): Der Anwender erreicht den Weg über das Symbol im Infobereich

[LEKTOR-151 L-151.2](LEKTOR-151.md#l-151.2) und der Befund lassen offen, ob ein Anwender den Weg erreicht. `OnTrayCallback` (:2190-2236) wird auch bei gesperrtem Hauptfenster zugestellt, denn gesperrt wird nur die Eingabe, nicht die Zustellung. `TrackPopupMenu` zeigt das Menü, und *Exit* schickt `ID_APP_EXIT` per `PostMessage` (:2227). Das führt über `CWinApp::OnAppExit` zu `WM_CLOSE` bei offenem Hinweis. Ob die Shell den Klick auf das Symbol bei offenem modalem Dialog weitergibt, habe ich nicht gemessen. Mit der Behebung wird dieser Schließwunsch aufgeschoben, und Eudora endet nach *OK*. **Vorschlag:** Diesen Schritt in Gregors Testplan aufnehmen (nur, wenn das Symbol im Infobereich sichtbar ist): „Abruf, Hinweis offen lassen, im Infobereich *Exit*; nach *OK* schließt Eudora ohne Fehlermeldung.“ Im Befund den Satz „ob ein Anwender den Weg erreicht …, ist nicht belegt“ entsprechend fortschreiben.

## Hinweise (keine Funde)

* **T1 (schon vor [E-239](../Intern/BEFUNDE.md#e-239)):** Steht das Fenster nach `QCWorkbook::OnClose` noch sichtbar da, sind die Aufräumschritte schon gelaufen. Das sind `CloseImapConnections`, `delete NetConnection`, `KillTimer(m_timerID)` (der allgemeine Zeitgeber, also kein automatischer Abruf mehr), `TrayItem NIM_DELETE`, `DeleteMenuObjects`, `TocCleanup`, `CHostList::Cleanup`, `delete gSearchDoc` und `AutomationStop` (:5748-5893). Eudora läuft dann nur noch zur Hälfte weiter. Der zurückgesetzte Merker lässt ein zweites Beenden zu. Doppelt freigegeben wird dabei nichts: `~CSearchDoc` setzt `gSearchDoc = NULL` (`SearchDoc.cpp:72`).
* **T2:** Auch die Fortschrittsanzeige sperrt das Hauptfenster (`progress.cpp:403`). Ein Schließwunsch während eines Abrufs mit Fortschrittsfenster wird jetzt bis zum Ende der Anzeige aufgeschoben. Vorher lief er verschachtelt im Abruf. Das ändert das Verhalten und ist vermutlich besser. Im Befund steht es nicht.
* **T3:** Der Aufschub prüft mit `IsWindowEnabled()` nur, ob ein Dialog offen ist. Schleifen, die das Fenster nicht sperren, sieht er nicht: das Hochladen bei IMAP, das Warten in `DoFindFirst`, `SyncPlayMedia` ohne Sperre. Ein nachgeholtes `WM_CLOSE` kann dort wie jedes andere ankommen. Das war schon vorher so (Vermutung, nicht verfolgt).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | `TestE239` bleibt grün, wenn die wirksamen `return`/`KillTimer`/Rücksetz-Zeilen fehlen (6 von 7 Gegenproben) | mittel | nein; vor dem Merge nachschärfen |
| [K2](#k2) | Prüfstand misst nur den Aufschub; Merker und Zeitgeber für `DestroyWindow` nie gelaufen; `E-239p` ohne `hinweis=1`, Betriebsart außerhalb des Repos (Vorgabe `einfach` trifft den Absturz nicht) | mittel | nein; Urteilszeile und Betriebsart im Fall |
| [K3](#k3) | rote Hänger und grüne Läufe tragen dieselbe Bau-Kennung `0dfce844* 19:40`; grün keinem Commit zuzuordnen | gering | nein; `E-239p` am Paketbau mit Kennung |
| [K4](#k4) | *nur im Infobereich*: *Abbrechen* in `SaveAllModified` wird als OLE-Fall gedeutet, Eudora beendet sich trotzdem | gering | nein |
| [K5](#k5) | ein aufgeschobener Schließwunsch übergeht ein späteres *Abbrechen* und eine abgebrochene Abmeldung | gering | nein |
| [K6](#k6) | Abmeldung während des Beendens: `CloseAllDocuments` verschachtelt in sich selbst | gering | nein; `endsession` an der Endfassung messen |
| [K7](#k7) | Anwenderweg vorhanden: *Exit* im Infobereich bei offenem Hinweis; gehört in den Testplan | gering | nein |
