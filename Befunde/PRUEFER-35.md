# PRÜFER-35 — 7.2.0.103 nachgerechnet

Gegenstand: `git diff fbbf6c31..HEAD -- Eudora71/`, also Commit `916df7c7` (7.2.0.103). Er soll
die Funde S1 bis S6 aus [PRÜFER-34](PRUEFER-34.md) zu [E-123](../Intern/BEFUNDE.md#e-123) schließen.
Gelesen am Quelltext, nichts gebaut, nichts gestartet. Die Zeilenangaben beziehen sich auf
`916df7c7`. Messdaten, nur gelesen: `C:\Temp\E118\Mailverzeichnis\eudora-w123{e,f,g}-1.log`.

## Urteil

**Zu Gregor zum Test: ja.** Der Fund, der in PRÜFER-34 am meisten wog, ist geschlossen und
gemessen. Das zweite Schließen während des Wartens führte in den Hänger der Gegenprobe. Jetzt wird
es ignoriert, Eudora wartet das Hochladen ab und endet sauber bis `ExitInstance` (Lauf g). Der
Offline-Modus wartet nicht mehr, und ein Abgleich hält das Beenden nicht mehr auf.

**Ins Release: erst nach N1 und N2.** Die Korrektur hat eine Obergrenze entfernt. In 7.2.0.102
wartete Eudora schlimmstenfalls 90 s. In 7.2.0.103 gibt es zwei Zustände, in denen es **nie**
endet, und jedes weitere Schließen wird dabei ignoriert:

* N1: Die laufende Übertragung wird nie als erledigt abgemeldet. Diese Abmeldung hängt an
  derselben Kette, die in [E-83](../Intern/BEFUNDE.md#e-83) dreimal gerissen ist.
* N2: Ein nicht-modales Fenster von Eudora war zuletzt aktiv, etwa ein schwebendes Fenster.

Der Anwender kommt dann nur über den Task-Manager heraus. Das ist Gregors altes Symptom aus [E-83](../Intern/BEFUNDE.md#e-83):
„Eudora lässt sich nicht beenden“. Beide Auslöser sind Vermutung, die Mechanik ist am Quelltext
belegt. Beides lässt sich mit einer Änderung beheben, siehe unten.

### Stand der Funde aus PRÜFER-34

| Fund | Stand in 7.2.0.103 | Beleg |
|---|---|---|
| S1 Weg 1: zweites Schließen während des Wartens | **geschlossen** | gemessen, Lauf g Zeile 160-161 und 182-214 |
| S1 Weg 2: Zeitablauf nach 90 s mitten im Hochladen | **geschlossen** für das Hochladen selbst; Rest siehe N3 und N4 | Quelltext; ungemessen |
| S2 keine Anzeige während des Wartens | **teilweise**: Text in der Statuszeile, siehe N6 | Quelltext |
| S3 Offline-Modus wartet 90 s | **geschlossen**; Nebenwirkung N3 | Quelltext |
| S4 Zeitgeber läuft nach `CloseDown`-Abbruch weiter, Merker bleibt stehen | **geschlossen** auf dem Weg über `OnClose`; Rest N5 (Herunterfahren) | Quelltext |
| S5 modaler Dialog beim Ablauf | **geschlossen**, aber zu weit gefasst, siehe N2 | Quelltext |
| S6 jede laufende Aufgabe zählt | **geschlossen** | Quelltext; `laeuft=1` in Lauf g während der Übertragung |
| S7 Wiederholung bei belegter Verbindung | unverändert, kosmetisch | — |
| S8 Spurmarken | unverändert, kosmetisch | — |
| S9 zwei Bauten unter einer Nummer | **wieder aufgetreten**, siehe N7 | gemessen |
| S10 Kommentar am falschen Ort | **unverändert** (`ImapAccountMgr.cpp:1272-1277`, `mainfrm.cpp:5234-5235`) | Quelltext |

### Neue Funde

| Fund | Einstufung | Stand |
|---|---|---|
| N1 `bLaeuft` hat keine Obergrenze. Bleibt die Abmeldung der Übertragung aus, endet Eudora nie, jedes Schließen wird ignoriert | **Hänger ohne Ende**, nur über den Task-Manager zu verlassen; **neu gegenüber 7.2.0.102** (dort 90 s) | Mechanik belegt am Quelltext, Auslösung Vermutung |
| N2 `GetLastActivePopup` meldet auch nicht-modale Fenster als „Dialog offen“ | **Hänger ohne Ende**, bis der Anwender ins Hauptfenster klickt; neu | Vermutung (Windows-Verhalten), ungemessen |
| N3 Offline-Abfrage steht vor `bLaeuft`. Wer während des Hochladens auf offline schaltet, beendet verschachtelt im Hochladen | Hänger wie in der Gegenprobe, sehr selten | belegt am Quelltext, Auslösung Vermutung |
| N4 Während des Verbindungsaufbaus der nächsten Übertragung ist `bLaeuft` noch falsch | Hänger wie in der Gegenprobe, nur nach 90 s, selten | Vermutung |
| N5 Herunterfahren abgebrochen: der Zeitgeber läuft weiter | falsche Anzeige, Eudora fragt erneut oder geht zu | belegt am Quelltext |
| N6 Statuszeilentext kann verschwinden oder unsichtbar sein | kosmetisch | Vermutung (MFC-Verhalten) |
| N7 Läufe e und f melden `7.2.0.102`, enthalten aber Code von 7.2.0.103 | Prüflücke | belegt |

## Was am Quelltext geschlossen ist

**S1 Weg 1.** `mainfrm.cpp:5242-5246` kehrt sofort zurück, solange `m_bE123WarteAktiv` steht. Der
Merker wird an genau einer Stelle zusammen mit `SetTimer` gesetzt (`:5256`, `:5259`) und an genau
einer Stelle zusammen mit `KillTimer` gelöscht (`:1975-1976`). Merker und Zeitgeber laufen also
immer gemeinsam. Die Druckvorschau wird vorher geprüft (`:5224`), ihr Schließen bleibt möglich.

Gemessen in Lauf g, Version `7.2.0.103`:

* `:154-156` erstes `WM_CLOSE`, `laeuft=1 uebertragungen=1`, Warten beginnt;
* `:160-161` zweites `WM_CLOSE` bei 0.29, **„weiteres Schliessen waehrend des Wartens ignoriert“**;
* `:163-166` die Antwort auf das Hochladen kommt **danach** (0.30), das zweite `WM_CLOSE` lag also
  verschachtelt im Hochladen. Das ist genau die Lage der Gegenprobe;
* `:180-181` `laeuft=0 uebertragungen=0`, „Warten zu Ende nach 10047 ms“;
* `:182-214` `CloseDown` alle Stufen, `ExitInstance` erreicht.

Lauf f zeigt dasselbe Bild (Zeilen 160-161, 213), siehe aber N7.

**S1 Weg 2.** `OnTimer` beendet nur bei `!bLaeuft` (`mainfrm.cpp:1973`). `bLaeuft` ist wahr von
`QueueWorkerThread` (`ImapActionQueue.cpp:3714`) bis `ActionDone` (`:3878`). `ActionDone` wird im
Destruktor der Aufgabe gerufen (`:626`). Der Destruktor läuft erst nach der Nachbearbeitung, also
nach dem Hochladen (`CImapFromLocalTransferMsgAction::DoPostProcessing`, `:2343-2470`). Damit
liegt das Hochladen nie auf dem Stapel, wenn der Zeitgeber `WM_CLOSE` schickt. Für das Hochladen
selbst ist S1 Weg 2 geschlossen. Den Preis dafür zahlt N1.

**S3.** `ImapAccountMgr.cpp:1285-1286` liefert im Offline-Modus 0. `IDS_INI_CONNECT_OFFLINE` ist
dieselbe Abfrage wie in `ProcessActionQueues` (`:1204`).

**S4.** `CloseDown` wird aus `OnClose` nur erreicht, wenn `m_bE123WarteAktiv` falsch ist. Dann
ist auch der Zeitgeber gelöscht, siehe oben. Ein eigenes `KillTimer` vor `CloseDown` ist deshalb
unnötig. Liefert `CloseDown` FALSE, wird `m_bE123Gewartet` zurückgesetzt (`mainfrm.cpp:5273`), und
das nächste Beenden wartet wieder. Eine Schleife ohne Anwender entsteht daraus nicht, denn
gewartet wird nur auf ein `WM_CLOSE` hin.

**S6.** Gezählt werden die wartenden Übertragungen in `m_array` (`ImapActionQueue.cpp:3951-3957`,
das war schon so) und die laufende Aufgabe nur, wenn sie eine Übertragung ist (`:3714`, `:3959`).
Ein Abgleich oder ein Herunterladen hält das Beenden nicht mehr auf.

**`ActionDone` in jedem Weg?** Nach `QueueWorkerThread` setzt keine Aufgabe mehr
`kActionStateOffline`. Diesen Zustand setzt nur `OpenMailbox` (`:830`, `:844`), und das läuft in
`DoPreThreadAction`, also vorher. Der Destruktor nimmt deshalb immer den Zweig `ActionDone`
(`:619-627`), bei Erfolg wie bei Fehlschlag. Ein Abbruch durch den Anwender beendet den Faden, und
`RemoveWorkerThread` fordert auch dann die Nachbearbeitung an (`QCTaskManager.cpp:587-650`).
**Wenn** der Destruktor läuft, wird `ActionDone` also in jedem Weg gerufen. Die offene Frage ist,
**ob** er läuft, siehe N1.

## N1 — `bLaeuft` ohne Obergrenze: Eudora endet nie

**Mechanik, belegt am Quelltext.** `OnTimer` beendet nicht, solange `bLaeuft` wahr ist, auch
nicht nach 90 s (`mainfrm.cpp:1973`). `OnClose` ignoriert jedes weitere Schließen
(`:5242-5246`). Wird `ActionDone` nie gerufen, bleibt Eudora also für immer offen.

`ActionDone` hängt an einer langen Kette. Fällt eines ihrer Glieder aus, bleibt `bLaeuft` wahr:

1. Der Faden endet, und `RemoveWorkerThread` fordert die Nachbearbeitung an.
2. `QCTaskManager::DoPostProcessing` ruft die Nachbearbeitung, also das Hochladen.
3. `CTaskInfoMT::DoPostProcessing` ruft `Kill()` (`TaskInfo.cpp:459`), aber nur, wenn keine weitere
   Nachbearbeitung angefordert ist (`:454`).
4. `NotifyDead` schickt eine Botschaft an das Fenster „Task Status“ (`TaskInfo.cpp:114-117`).
5. `CTaskStatusView` ruft `RemoveTaskInfo` (`TaskStatusView.cpp:425`, `:435`).
6. `RemoveTaskInfo` löscht die Aufgabe (`QCTaskManager.cpp:902`).
7. `~CImapAction` ruft `ActionDone` (`ImapActionQueue.cpp:626`).

Genau diese Kette ist in [E-83](../Intern/BEFUNDE.md#e-83) gerissen, am Ende von Schritt 1 und zweimal
in Schritt 4/5 (Nachträge 14.09. und 16.10.2026, jeweils als „liegengeblieben“). Dazu kommt
Schritt 2: Wirft das Hochladen eine Ausnahme, wird sie weitergeworfen (`QCTaskManager.cpp:725`,
`:732`). `Kill` und alle weiteren Glieder entfallen dann.

**Auslösung: Vermutung.** In e, f und g wird die Übertragung abgemeldet (`laeuft=0`). Die
Spurmarke `liegengeblieben` erscheint in g nur für den Abgleich vom Start, uid=1 (Zeile 46). Er
wird kurz darauf entfernt (Zeile 54, `beim-Umhaengen-schon-fertig-entfernt`). Der Weg ist also
heute heil, aber er ist schon dreimal gerissen.

**Vorher:** In 7.2.0.102 endete das Warten in diesem Fall nach 90 s. Da nichts mehr auf dem Stapel
lag, war das Beenden dann sogar sicher. In 7.2.0.103 endet es nie.

**Ausweg für den Anwender:**

* **Task-Manager.** Eudora reagiert weiter auf Botschaften, es ist nur nicht beendbar. Unter
  „Details“ beendet „Task beenden“ den Prozess sofort. Ob „Prozesse → Task beenden“ nach dem
  ignorierten `WM_CLOSE` von selbst hart beendet, habe ich nicht gemessen (Vermutung: ja, nach
  kurzer Frist). In beiden Fällen läuft `CloseDown` nicht. Fensterlagen, Leistenzustand und die
  Stufen 4 bis 6 werden dann nicht gesichert (Vermutung zum Umfang).
* **Abmelden oder Herunterfahren von Windows** beendet Eudora auch in diesem Fall.
  `OnQueryEndSession` ruft `CloseDown` direkt und geht an `OnClose` vorbei
  (`mainfrm.cpp:5171-5177`). Das Warten wird umgangen, wie im Original beim Herunterfahren.
* Umschalt + Datei → Beenden hilft nicht, es beendet nicht (PRÜFER-34, Tabelle der Wege).

**Anwender:** Er verschiebt eine Mail in einen IMAP-Ordner und beendet. Die Statuszeile sagt
„Waiting …“, und dabei bleibt es. Klickt er wieder aufs Kreuz, passiert nichts. Er muss Eudora im
Task-Manager abschießen.

**Vorschlag, schließt N1, N3 und N4 auf einmal.** Statt `bLaeuft` aus dem Zustand der
Warteschlange abzuleiten, einen Zähler „Hochladen liegt auf dem Stapel“ führen. Das war Vorschlag
(b) aus PRÜFER-34. Er wird beim Eintritt in `CImapFromLocalTransferMsgAction::DoPostProcessing`
hoch- und beim Austritt heruntergezählt, am besten über ein Objekt im Rumpf, damit auch eine
Ausnahme ihn zurückstellt. Dasselbe gilt für `DoPreThreadAction` (N4). Der Zähler kann nicht
stehen bleiben, weil er an den Stapel gebunden ist und nicht an die Abmeldekette. Den Zustand
„Übertragung läuft“ (`:3959`) weiter nur für `nOffen` zählen, also mit der Obergrenze von 90 s.

## N2 — `GetLastActivePopup` meldet auch nicht-modale Fenster

`mainfrm.cpp:1972`: `bDialogOffen = (::GetLastActivePopup(m_hWnd) != m_hWnd)`.
`GetLastActivePopup` liefert das zuletzt aktive Fenster, das dem Hauptfenster gehört. Ob es modal
ist, ob es den Rahmen sperrt und (soweit ich weiß) ob es sichtbar ist, prüft die Funktion nicht.
Raymond Chens Alt-Tab-Verfahren prüft nach `GetLastActivePopup` deshalb eigens `IsWindowVisible`.
Fenster, die Eudora gehören und nicht modal sind:

* schwebende Leisten und schwebende Wazoo-Fenster (`WazooBarMgr.cpp`, `mainfrm.cpp`,
  Mini-Rahmen mit dem Hauptfenster als Besitzer);
* nicht-modale Hinweisdialoge (`CAuditNagTask.cpp:389`, `CRegisterNagTask.cpp:160`,
  `CFullFeatureNagTask.cpp:132`, jeweils `Create(…, AfxGetMainWnd())`).

**Ablauf, Vermutung:** Der Anwender klickt in ein schwebendes Fenster, etwa die Postfachliste, und
wechselt dann in ein anderes Programm. Er schließt Eudora über die Taskleiste (Rechtsklick →
„Fenster schließen“). Das aktiviert Eudora nicht, das zuletzt aktive Fenster bleibt das
schwebende. `bDialogOffen` ist wahr, solange er nicht ins Hauptfenster klickt. Eudora bleibt
offen, auch nachdem das Hochladen fertig ist, und jedes weitere Schließen über die Taskleiste wird
ignoriert. Ein Klick ins Hauptfenster löst es auf, denn danach ist das Hauptfenster wieder das
zuletzt aktive. Das weiß der Anwender aber nicht.

**Anwender:** Er schließt Eudora über die Taskleiste, und es geht nie zu. Er schließt noch einmal,
wieder passiert nichts. Er schießt es ab oder klickt zufällig hinein, dann geht es zwei Sekunden
später zu.

**Vorschlag:** Statt `GetLastActivePopup` prüfen, ob das Hauptfenster gesperrt ist:
`!IsWindowEnabled()`. Ein modaler Dialog (Kennwort, Fehlermeldung, `CTrustCertDlg`) sperrt seinen
Besitzer, ein schwebendes Fenster und ein nicht-modaler Hinweis tun es nicht. Das war der
Vorschlag zu S5 in PRÜFER-34.

## N3 — Offline-Abfrage vor `bLaeuft`

`ImapAccountMgr.cpp:1280-1286`: `*pbLaeuft = false` und im Offline-Modus sofort `return 0`, ohne
die Konten zu fragen. Das Fenster bleibt während des Wartens bedienbar, auch „Work Offline“.
Schaltet der Anwender während des Hochladens auf offline, findet der nächste Zeitgeber
`nOffen == 0` und `bLaeuft == false` und schickt `WM_CLOSE`. Das Hochladen liegt dabei noch auf dem
Stapel, also wird der Abbau verschachtelt darin ausgeführt, wie in der Gegenprobe.

**Belegt am Quelltext**, dass `bLaeuft` im Offline-Modus falsch geliefert wird. **Vermutung**, dass
das Umschalten das laufende Hochladen nicht abbricht. Sehr selten.

**Anwender:** Er beendet, wartet, schaltet dann schnell auf offline, damit es vorangeht. Das
Fenster verschwindet, Eudora hängt unsichtbar weiter.

**Vorschlag:** Erst `bLaeuft` über alle Konten ermitteln, dann im Offline-Modus `nOffen = 0`
liefern. Mit dem Stapelzähler aus N1 entfällt die Frage ganz.

## N4 — Verbindungsaufbau der nächsten Übertragung

`m_bE123UebertragungLaeuft` wird erst nach `QueueWorkerThread` gesetzt (`ImapActionQueue.cpp:3714`).
Davor läuft `DoPreThreadAction` mit `OpenMailbox` im Hauptfaden (`:3704`, `:2294`), also
Verbindung, Anmeldung und `SELECT` des Zielordners. Für das Hochladen ist belegt, dass der
Hauptfaden dabei Botschaften zustellt (PRÜFER-34, Lauf d). Für `OpenMailbox` vermute ich dasselbe,
gemessen ist es nicht.

Schickt der Zeitgeber in diesem Augenblick nach 90 s `WM_CLOSE` (`nOffen > 0`, denn die Aufgabe
steht noch in `m_array`), läuft der Abbau verschachtelt im Verbindungsaufbau. Das setzt mehrere
Übertragungen voraus, die zusammen etwa 90 s brauchen, und der Zeitgeber muss genau in den
Verbindungsaufbau der letzten fallen. **Vermutung, selten.** Der Kennwortdialog an dieser Stelle
ist durch `bDialogOffen` abgedeckt, das Warten auf das Netz nicht.

**Anwender:** Er verschiebt viele große Mails und beendet. Nach anderthalb Minuten verschwindet das
Fenster, und Eudora hängt unsichtbar weiter.

**Vorschlag:** Stapelzähler wie in N1, auch um `DoPreThreadAction` der Übertragung.

## N5 — Herunterfahren abgebrochen während des Wartens

Fährt Windows herunter, während Eudora wartet, ruft `OnQueryEndSession` `CloseDown` direkt
(`mainfrm.cpp:5171-5177`). Der Zeitgeber läuft dabei weiter, `m_bE123WarteAktiv` bleibt gesetzt.

* Liefert `CloseDown` TRUE, endet die Sitzung, und der Zeitgeber spielt keine Rolle.
* Bricht der Anwender in `CloseDown` ab (Rückfrage „tasks running“ oder ausstehende Post), lehnt
  Eudora das Herunterfahren ab und läuft weiter. Höchstens 2 s nach dem Ende der Übertragung
  schickt der Zeitgeber selbst `WM_CLOSE`, und Eudora fragt erneut oder geht ohne Rückfrage zu.

Das ist der Rest von S4, nur auf dem Weg über das Herunterfahren. Belegt am Quelltext, selten. Dass
`CloseDown` beim Herunterfahren verschachtelt im Hochladen laufen kann, ist alt und hat mit
7.2.0.103 nichts zu tun.

**Anwender:** Er fährt Windows herunter, drückt bei Eudoras Rückfrage „Abbrechen“, und kurz danach
fragt Eudora von selbst noch einmal oder geht zu.

**Vorschlag:** In `OnQueryEndSession` vor `CloseDown` den Zeitgeber löschen und beide Merker
zurücksetzen.

## N6 — Statuszeile

`mainfrm.cpp:5258` setzt den Text einmal. Er erscheint nicht, wenn die Statuszeile ausgeblendet
ist (`mainfrm.cpp:1751`, „Show Status Bar“). Und MFC setzt die Statuszeile auf den Ruhetext
zurück, sobald ein Menü geschlossen wird oder der Mauszeiger eine Leiste verlässt (Vermutung zum
genauen Auslöser). Danach steht dort wieder „Ready“, während Eudora weiter wartet. Mit N1 oder N2
verschärft sich das: Der einzige Hinweis ist dann weg.

**Anwender:** Er schließt, sieht kurz „Waiting …“, fährt über die Leiste, und der Text ist weg.
Eudora wartet trotzdem weiter.

**Vorschlag:** Den Text in `OnTimer` bei jedem Durchgang neu setzen, das ist eine Zeile.

## N7 — wieder zwei Bauten unter einer Nummer

`eudora-w123e-1.log` und `-w123f-1.log` melden in Zeile 3 `Version 7.2.0.102`. Sie enthalten aber
das Feld `laeuft=` (e Zeile 154, f Zeile 155), und f enthält die Zeile „weiteres Schliessen
waehrend des Wartens ignoriert“ (Zeile 161). Beides gibt es erst in 7.2.0.103. Nur g meldet
`7.2.0.103`.

Für den Quellstand von `916df7c7` beweist damit nur **g** etwas: Weg 1 von S1, S6 und das normale
Ende. Ob g genau `916df7c7` ist, lässt sich am Protokoll nicht prüfen. Dasselbe stand in PRÜFER-34
als S9, es ist also ein Fall für [Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md).

**Anwender:** keine Wirkung. Es gibt nur weniger Belege, als die Zahl der Läufe nahelegt.

## Nebenbefund, nicht neu

`aktiv=-1/10` steht in g siebenmal (ab Zeile 65), ebenso in allen Läufen seit a und schon in der
Gegenprobe. Das ist [PRÜFER-31](PRUEFER-31.md) F6, unverändert, und hat mit 7.2.0.103 nichts zu
tun.

## Was vor dem Release zu ändern ist

1. **N1, N3, N4 mit einer Änderung:** Für `bLaeuft` einen Zähler „Hochladen oder
   Verbindungsaufbau einer Übertragung liegt auf dem Stapel“ führen. Er wird im Rumpf von
   `DoPostProcessing` und `DoPreThreadAction` der Übertragung über ein Objekt gezählt, nicht über
   `ActionDone`. Der Zustand der Warteschlange zählt nur noch für `nOffen`, und dort gilt die
   Obergrenze von 90 s.
2. **N2:** `!IsWindowEnabled()` statt `GetLastActivePopup`.
3. Nach Möglichkeit N5 (eine Zeile in `OnQueryEndSession`) und N6 (eine Zeile in `OnTimer`).

## Gregors Test an 1.0.103

**Vorher wissen:** Geht Eudora nach dem Schließen nicht zu, und erscheint in `eudora.log` immer
wieder `E-123 Warteschlange: … laeuft=1`, obwohl die Mail im IMAP-Ordner längst angekommen ist,
dann ist das N1. Eudora lässt sich dann nur im Task-Manager beenden, unter „Details“ mit „Task
beenden“. Die `eudora.log` bitte vorher sichern.

**Test 1 (S1):** Eine Mail aus einem lokalen Ordner in einen IMAP-Ordner verschieben, sofort
beenden und **gleich noch einmal** auf das Kreuz klicken. Richtig ist der Lauf, wenn in
`eudora.log` diese Zeilen stehen, wie in Lauf g:

* `E-123 Beenden wartet auf 1 Uebertragung(en) in IMAP-Ordner`
* `E-123 Beenden: weiteres Schliessen waehrend des Wartens ignoriert`
* `E-121 Uebertragung: … hochgeladen=1`
* `E-123 Beenden: Warten zu Ende nach … ms, offen=0`
* `E-33 ExitInstance: erreicht`

**Test 2 (N2), nur wenn Gregor ein schwebendes Fenster benutzt:** dort einmal hineinklicken, in ein
anderes Programm wechseln und Eudora über Rechtsklick in der Taskleiste → „Fenster schließen“
beenden. Geht Eudora nach dem Ende der Übertragung nicht innerhalb von wenigen Sekunden zu, ist N2
bestätigt. Ein Klick in Eudoras Hauptfenster löst es dann auf.
