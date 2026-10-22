# PRÜFER-36 — 7.2.0.104 und 7.2.0.106 nachgerechnet

Gegenstand: `git diff 6b52c618..d3314ddd -- Eudora71/`, also zwei Commits:

* `a4cae066` (7.2.0.104): [E-123](../Intern/BEFUNDE.md#e-123), das Beenden-Warten nach
  [PRÜFER-35](PRUEFER-35.md) abgesichert;
* `d3314ddd` (7.2.0.106): [E-69](../Intern/BEFUNDE.md#e-69), eine Nachricht, die der Filter
  überspringt, erscheint jetzt im Fenster „Task Errors“.

Gelesen am Quelltext, nichts gebaut, nichts gestartet. Die Zeilenangaben beziehen sich auf
`d3314ddd`. Messdaten, nur gelesen: `C:\Temp\E118\Mailverzeichnis\eudora-w123{h,i}-1.log`
(7.2.0.104) und `eudora-v69{a,b,c,d}*.log` (7.2.0.105 und 7.2.0.106).

## Urteil

**Zu Gregor zum Test: ja.** Beide Änderungen tun im Normalfall, was sie sollen, und das ist
gemessen. In den Läufen h und i wartet Eudora das Hochladen ab, ignoriert ein zweites Schließen und
endet sauber bis `ExitInstance`. In Lauf v69d steht die übersprungene Nachricht als Eintrag in
„Task Errors“, und sie bleibt in `In`. Datenverlust habe ich in keinem der beiden Commits gefunden.

**Ins Release: erst nach P1 und P2.** Beides sind kleine Änderungen von je ein bis zwei Zeilen.

* **P1:** Die neue Notbremse beendet Eudora nach 5 Minuten in jedem Fall, also auch mitten im
  Hochladen oder bei offenem Kennwortdialog. Das ist genau der verschachtelte Abbau, der in der
  Gegenprobe zu PRÜFER-34 in einen unsichtbaren Hänger führte. Die Notbremse schützt dabei vor
  nichts mehr, denn der Zähler aus 7.2.0.104 kann nicht von selbst stehen bleiben.
* **P2:** N4 aus PRÜFER-35 ist **nicht** geschlossen, obwohl der Kommentar es sagt. Der Zähler um
  den Verbindungsaufbau wird nie hochgezählt, weil die Übertragung lokal → IMAP die Basisfunktion
  gar nicht aufruft. Das ist am Quelltext belegt.

P3 (Flut von Einträgen in Task Errors) sollte vor dem Release begrenzt werden. Ein Fehler ist es
nicht, aber Gregor wird es merken, sobald eine IMAP-Verbindung beim Filtern streikt.

### Stand der Funde aus PRÜFER-35

| Fund | Stand in 7.2.0.104 | Beleg |
|---|---|---|
| N1 `bLaeuft` ohne Obergrenze | **geschlossen.** `bLaeuft` kommt nur noch aus dem Zähler `s_lE123HochladenLaeuft`, und der hängt am Stapel von `DoPostProcessing`, nicht an der Abmeldekette aus [E-83](../Intern/BEFUNDE.md#e-83). Bleibt die Abmeldung aus, zählt die Aufgabe nur noch in `nOffen`, und dort gilt die Grenze von 90 s | Quelltext; ungemessen, siehe P4 |
| N2 `GetLastActivePopup` | **geschlossen.** `!IsWindowEnabled()` (`mainfrm.cpp:1975`) | Quelltext |
| N3 Offline-Abfrage vor `bLaeuft` | **geschlossen.** `*pbLaeuft` wird vor der Offline-Prüfung gesetzt (`ImapAccountMgr.cpp:1285-1286`) | Quelltext |
| N4 Verbindungsaufbau der nächsten Übertragung | **nicht geschlossen**, siehe P2 | Quelltext |
| N5 Herunterfahren abgebrochen | **geschlossen.** `OnQueryEndSession` löscht Zeitgeber und Merker vor `CloseDown` (`mainfrm.cpp:5175-5187`) | Quelltext |
| N6 Statuszeile kann „Ready“ zeigen | **offen, bekannt.** `OnTimer` setzt den Text nicht neu | Quelltext |
| N7 zwei Bauten unter einer Nummer | für [E-123](../Intern/BEFUNDE.md#e-123) diesmal sauber: h und i melden `7.2.0.104`. Für [E-69](../Intern/BEFUNDE.md#e-69) siehe P7 | gemessen |

### Neue Funde

| Fund | Schwere | Stand |
|---|---|---|
| P1 Notbremse nach 5 min beendet auch mitten im Hochladen oder bei offenem modalen Dialog | **mittel, selten.** Unsichtbarer Hänger oder Absturz statt Warten | Mechanik belegt, Auslösung Vermutung |
| P2 Zähler in `CImapAction::DoPreThreadAction` ist für die Übertragung toter Code. N4 bleibt offen | **mittel, selten.** Hänger wie in der Gegenprobe, nur nach 90 s | belegt am Quelltext |
| P3 Ein Eintrag je Nachricht und je Filterliste, jeweils mit Piepton und Nach-vorne-Holen von Task Errors | **lästig**, kein Datenverlust | Mechanik belegt, Auslösung Vermutung |
| P4 Die Spurmarke zeigt `laeuft` der Warteschlange, nicht den Zähler. Die Schließung von N1 ist ungemessen | Prüflücke | belegt |
| P5 Im Debug-Bau löst jede E-69-Meldung `ASSERT(pInfo)` aus | gering, nur Debug | belegt |
| P6 Eintragszeile beginnt mit „, Filtering, “, und im Fall „no mailbox“ steht `mailbox ""` | kosmetisch | belegt |
| P7 v69a bis v69c sind 7.2.0.105 mit anderem Grundtext. Nur v69d ist 7.2.0.106; ein „vorher“-Lauf an 7.2.0.104 liegt nicht unter `v69*` | Prüflücke | belegt |

## Was am Quelltext und in den Läufen geschlossen ist

**N1.** `E123HochladenLaeuft()` (`ImapActionQueue.cpp:650-653`) liest einen Zähler. Ein Objekt im
Rumpf von `CImapFromLocalTransferMsgAction::DoPostProcessing` zählt ihn hoch und beim Verlassen
wieder herunter (`:2365`), auch wenn eine Ausnahme fliegt. Eine Abmeldung über „Task Status“ ist
dafür nicht nötig. Bleibt `ActionDone` aus, dann bleibt nur `m_bE123UebertragungLaeuft` stehen.
Das wirkt nur auf `nOffen` (`:3980-3984`), und dort beendet `OnTimer` nach 90 s
(`mainfrm.cpp:1977`). Eudora kann also nicht mehr für immer offen bleiben, weil eine Abmeldung
fehlt.

**N2.** Ein modaler Dialog sperrt seinen Besitzer, ein schwebendes Fenster tut das nicht.
`!IsWindowEnabled()` unterscheidet genau diese beiden Fälle.

**N3.** Schaltet der Anwender während des Hochladens auf offline, liefert
`E123OffeneUebertragungen` zwar `nOffen = 0`, aber `bLaeuft` steht weiter, weil der Zähler vor
der Offline-Prüfung gelesen wird. Beendet wird also erst nach dem Hochladen.

**N5.** Belegt am Quelltext, siehe Tabelle.

**Gemessen, 7.2.0.104:**

* Lauf h, Zeilen 153-211: Warten beginnt, die Antwort auf das Hochladen kommt (161-163),
  „Warten zu Ende nach 10015 ms, offen=0“ (178), `CloseDown` alle Stufen, `ExitInstance` (211).
* Lauf i, Zeilen 153-203: Datei → Beenden, zweites Schließen ignoriert (167-168), Ende nach
  8078 ms (170), `ExitInstance` (203).

**[E-69](../Intern/BEFUNDE.md#e-69), gemessen in v69d (7.2.0.106):** In.mbx war von außen gesperrt. Zeile 78 zeigt
„kein Nachrichtentext“, Zeile 79 die Spurmarke mit Betreff, Postfach `In` und Grund, Zeile 80 den
Text des Eintrags (über `Register`, `DEBUG_MASK_DIALOG`). Danach läuft der Filterlauf zu Ende
(„Messages left to filter: 0“), und Eudora beendet normal.

## P1 — Notbremse nach 5 Minuten beendet mitten im Hochladen

`mainfrm.cpp:1976-1977`:

```cpp
BOOL bNotfall = (dwVergangen > 300000);
if (bNotfall || (!bLaeuft && !bDialogOffen && (nOffen == 0 || dwVergangen > 90000)))
```

`bNotfall` übergeht `bLaeuft` **und** `bDialogOffen`. Nach 5 Minuten wird `WM_CLOSE` gepostet,
auch wenn gerade

* ein Hochladen auf dem Stapel liegt (Zähler > 0). Das Hochladen stellt nebenbei Botschaften zu
  (PRÜFER-34, Lauf d). `OnClose` findet `m_bE123WarteAktiv == FALSE` und
  `m_bE123Gewartet == TRUE` und ruft `CloseDown` **verschachtelt im Hochladen**. Das ist die Lage
  der Gegenprobe zu PRÜFER-34: Das Fenster verschwindet, und der Prozess hängt unsichtbar weiter.
* ein modaler Dialog offen ist, etwa die Kennwortabfrage aus `OpenMailbox`. Die gepostete
  Botschaft stellt die modale Schleife des Dialogs zu. `CloseDown` und `DestroyWindow` laufen dann
  unter dem Dialog. Danach kehrt dessen `DoModal` in Code zurück, dessen Fenster und Objekte schon
  abgebaut sind (Vermutung: Absturz oder Hänger).

**Belegt am Quelltext:** Die Bedingung übergeht beide Sperren. **Vermutung:** Der Ablauf danach,
abgeleitet aus der Gegenprobe.

**Warum die Notbremse nichts mehr schützt.** Der Zähler ist seit 7.2.0.104 an den Stapel gebunden
(siehe N1). Er bleibt nur dann stehen, wenn das Hochladen selbst nie zurückkehrt. Genau dann führt
die Notbremse aber in den verschachtelten Abbau, also in den Hänger. Ein Dialog, der offen
bleibt, ist für den Anwender sichtbar, und er kann ihn schließen. Die Notbremse tauscht damit
einen sichtbaren Zustand gegen einen unsichtbaren.

**Auslösung, Vermutung, selten:**

* Viele oder große Mails werden auf eine langsame Leitung hochgeladen, und eine einzelne Aufgabe
  braucht länger als 5 Minuten. Eine Aufgabe kann mehrere Nachrichten tragen (`strUIDList`,
  `:2368`).
* Der Anwender beendet, Eudora fragt nach dem Kennwort, und er geht weg.

**Anwender:** Er verschiebt einen Ordner voller großer Anhänge in einen IMAP-Ordner und beendet.
Nach 5 Minuten verschwindet das Fenster. Eudora läuft unsichtbar weiter, ein neuer Start geht
nicht oder findet die alte Sitzung noch vor. Er muss im Task-Manager abschießen.

**Was verloren gehen kann:** Das Hochladen bricht mitten in der Aufgabe ab, und `CloseDown`
sichert Fensterlagen und Leisten dann nicht vollständig. Ob beim Verschieben eine Nachricht lokal
schon entfernt, auf dem Server aber noch nicht angekommen ist, habe ich nicht verfolgt (offen).
Nach PRÜFER-34 steht die Aufgabe dann in `actionqueue.dat` und läuft beim nächsten Start weiter,
die Schutzvermerke der eingebetteten Bilder aus [E-123](../Intern/BEFUNDE.md#e-123) gehen dabei aber verloren.

**Vorschlag:** Die Notbremse nur greifen lassen, wenn `!bLaeuft && !bDialogOffen`, oder sie ganz
streichen. Damit ist sie gleichwertig mit der Regel nach 90 s. In die Zeile „Warten zu Ende“
`laeuft=`, `dialog=` und `notfall=` aufnehmen, siehe P4.

## P2 — N4 nicht geschlossen: der Zähler um den Verbindungsaufbau zählt nie

`ImapActionQueue.cpp:665`, in `CImapAction::DoPreThreadAction`:

```cpp
CE123HochladenZaehler e123Zaehler(dynamic_cast<CImapFromLocalTransferMsgAction*>(this) != NULL);
```

`CImapFromLocalTransferMsgAction::DoPreThreadAction` (`:2284-2333`) ruft die Basisfunktion
**nicht** auf. Das steht dort sogar im Kommentar des Originals (`:2286`): *„This is the only
subclass of CImapAction that doesn't call CImapAction::DoPreThreadAction()“*. Alle anderen
Unterklassen rufen sie zwar auf, sind aber keine `CImapFromLocalTransferMsgAction` (Hierarchie
`ImapActionQueue.h:113-505`). Der `dynamic_cast` ist für sie NULL. Der Zähler wird an dieser Stelle
also nie hochgezählt.

Damit gilt N4 aus PRÜFER-35 unverändert. Während `OpenMailbox` der nächsten Übertragung
(`:2314`), also während Verbindung, Anmeldung und `SELECT`, ist `bLaeuft` falsch. Fällt der
Zeitgeber nach 90 s genau hinein (`nOffen > 0`, denn die Aufgabe steht noch in `m_array`), läuft
der Abbau verschachtelt im Verbindungsaufbau. Der Kommentar in `ImapAccountMgr.cpp:1282-1284`
(„PRUEFER-35 N1/N3/N4“) behauptet das Gegenteil.

**Belegt am Quelltext**, dass der Zähler hier nicht wirkt. **Vermutung**, dass `OpenMailbox`
Botschaften zustellt. Das ist wie in PRÜFER-35 ungemessen.

**Anwender:** Er verschiebt viele Mails in mehreren Schüben und beendet. Nach anderthalb Minuten
verschwindet das Fenster, und Eudora hängt unsichtbar weiter.

**Was verloren gehen kann:** wie bei P1, die noch ausstehenden Übertragungen. Sie stehen in
`actionqueue.dat`, aber ohne die Schutzvermerke aus [E-123](../Intern/BEFUNDE.md#e-123).

**Vorschlag:** Den Zähler an den Anfang von
`CImapFromLocalTransferMsgAction::DoPreThreadAction` setzen
(`CE123HochladenZaehler e123Zaehler(true);`) und die Zeile in `CImapAction::DoPreThreadAction`
streichen.

## P3 — Flut in Task Errors

`E69UebersprungenMelden` legt bei **jedem** Abbruch einen eigenen Eintrag an
(`filtersd.cpp:2392-2397`). `FilterOne` ruft `FilterMsg` für jede Nachricht bis zu dreimal auf,
für die Vor-, Haupt- und Nachfilterliste (`:3860-3866`). Gemeldet wird in jeder Liste, die einen
Filter für diesen Zeitpunkt hat. Gemessen (v69d Zeilen 70-81): nur die Hauptliste hatte einen
Filter, also ein Eintrag je Nachricht.

Jeder Eintrag bewirkt in `CTaskErrorView::OnMsgNewError`:

* `MessageBeep(MB_ICONEXCLAMATION)` (`TaskErrorView.cpp:255`);
* bei `TaskErrorBringToFront`, Vorgabe **1** (`EudoraRes.rc:10312`), holt `SwitchAndHighlight`
  das Fenster Task Errors nach vorn und setzt den Fokus dorthin (`:252`, `:262-268`);
* bei `ShowMeTheErrors=1` einen modalen Dialog, jeweils nur einen zur gleichen Zeit (`:249`).

**Wann es viele werden, Vermutung:** Neu ist vor allem der IMAP-Weg (`:2515-2519`).
`DownloadFullHeaders` liefert für **jede** Nachricht einen Fehler, solange die Verbindung nicht
geht: Anmeldung abgebrochen (`HRESULT_MAKE_CANCEL`, `ImapMailbox.cpp:826`), Verbindung belegt
(`HRESULT_MAKE_BUSY`, `:834`) oder offline. Filtert der Anwender dann von Hand ein IMAP-Postfach mit
500 nur angerissenen Nachrichten (Special → Filter Messages oder Auswahl, `TocFrame.cpp:2403`),
entstehen 500 Einträge, 500 Pieptöne, und das Fenster springt 500-mal nach vorn. Beim lokalen Weg
(In.mbx gesperrt) zeigt Eudora schon heute zwei modale Meldungen je Nachricht (v69d Zeilen 72-77).
Die Flut dort ist also alt, sie kommt nur um einen Eintrag je Nachricht dazu.

**Anwender:** Er filtert ein IMAP-Postfach, während der Server nicht erreichbar ist. Es piept
ununterbrochen, Task Errors drängt sich immer wieder nach vorn, und die Liste hat hunderte gleiche
Zeilen. „Remove all“ räumt sie ab (`:487-506`).

**Was verloren gehen kann:** nichts. Die Nachrichten bleiben, wo sie sind. Speicher je Eintrag
etwa ein paar hundert Byte, freigegeben beim Leeren.

**Vorschlag:** Je Filterlauf zählen und am Ende **einen** Eintrag schreiben („12 messages could
not be filtered, first: …“). Oder höchstens einen Eintrag je Nachricht und Grund, und ab dem
zehnten nur noch zählen.

## P4 — Die Schließung von N1 ist ungemessen

`OnTimer` entscheidet über `E123HochladenLaeuft()`. Die Spurmarke
`E-123 Warteschlange: … laeuft=…` (`ImapActionQueue.cpp:3988`) schreibt aber den **alten** Wert
`m_bE123UebertragungLaeuft` der Warteschlange, nicht den Zähler. In h und i bedeutet `laeuft=1`
also nicht, was `OnTimer` gesehen hat. Die Zeile „Warten zu Ende nach … ms“ (`mainfrm.cpp:1982`)
nennt weder `bLaeuft` noch `bDialogOffen` noch `bNotfall`. Ob die Notbremse gegriffen hat, ist am
Protokoll nicht zu erkennen ([Zwei Werte in eine Ausgabe](../Arbeitsweise/zwei-werte-in-eine-ausgabe.md)).

Belegt: Die Läufe h und i sind mit der Änderung **verträglich**, beweisen den Zähler aber nicht.

**Anwender:** keine Wirkung. Es fehlt nur ein Beleg.

**Vorschlag:** In die Zeile „Warten zu Ende“ und in die Spurmarke je Durchgang den Zählerstand,
`dialog=` und `notfall=` aufnehmen.

## P5 — Debug-Bau: `ASSERT(pInfo)` bei jeder Meldung

`TaskErrorMT.cpp:22`: Der Konstruktor verlangt `ASSERT(pInfo)`. `E69UebersprungenMelden` übergibt
`NULL` (`filtersd.cpp:2392`). Im Freigabebau ist das nichts. Im Debug-Bau erscheint bei jeder
Meldung ein Assert-Dialog, bei den Wegen `!pImapMailbox` und Kopfzeilen zusätzlich zu den
`ASSERT(0)` der anderen drei Wege. Mit P3 werden das viele. Belegt.

**Anwender:** keiner, nur ein Prüfstand mit Debug-Bau.

**Vorschlag:** `ASSERT(pInfo)` lockern oder einen eigenen Konstruktor ohne Aufgabe anbieten, in
dem `SetzeKontext` aufgeht.

## P6 — Eintragszeile

`TaskErrorView.cpp:214-217` baut die Zeile aus Persona, Haupttext, Zweittext und Uhrzeit. Bei
leerer Persona beginnt sie mit „, Filtering, “, und es folgt ein leeres Feld vor der Zeit. Im Fall
„no mailbox“ (`filtersd.cpp:2485`) ist `Sum->m_TheToc` NULL, und der Text sagt
`in mailbox ""`. Außerdem steht dort „It is still in that mailbox“, obwohl gar kein Postfach
bekannt ist. Belegt, kosmetisch.

**Anwender:** Eine Zeile sieht leicht kaputt aus. Keine Wirkung auf die Daten.

## P7 — Belege zu E-69

`eudora-v69a-1*.log`, `v69b*`, `v69c*` melden `7.2.0.105`, einen nie ausgelieferten Zwischenbau
(so die Commit-Nachricht). v69c schreibt `grund=message text is empty`. Diesen Text gibt es im
Commit nicht, der Bau stimmt also nicht mit `d3314ddd` überein. Nur **v69d** meldet `7.2.0.106`
und den Text des Commits. Die Commit-Nachricht nennt einen roten Lauf „an 7.2.0.104 nur
Protokollzeile“. Unter `v69*` liegt kein Lauf an 7.2.0.104. Belegt; vielleicht liegt er anderswo.

**Anwender:** keine Wirkung. Für `d3314ddd` beweist nur v69d etwas.

## Gegenvermutungen aus dem Auftrag

**1. Läuft `FilterMsg` in einem Nebenfaden, und ist `Register` dort sicher? — widerlegt.**
Alle Aufrufer von `FilterOne` liegen im Hauptfaden:

* `CPOP::GetMailFromSpool` schaltet vorher das Neuzeichnen der Postfachliste ab (`pop.cpp:149`);
* `CImapChecker::DoPostFiltering` wird aus `DoMergeNewTocs` gerufen, mit
  `ASSERT(IsMainThreadMT())` (`ImapChecker.cpp:1197`, `:1481`);
* `msgdoc.cpp:792` und `TocFrame.cpp:2403` sind Menübefehle;
* `sendmail.cpp:187` filtert beim Senden.

Auch im Nebenfaden wäre `Register(CTaskErrorMT*)` sicher. Es sperrt `m_Guard_TaskErrorList` und
`m_ObjGuard` und meldet über `PostMessage` an das Anzeigefenster (`QCTaskManager.cpp:202-213`,
`TaskObject.cpp:88-99`). Das Original ruft es so aus dem POP-Abholfaden
(`POPSession.cpp:403-434` → `CTaskInfoMT::CreateError`, `TaskInfo.cpp:506-512`).

**2. Eintrag ohne Aufgabe (Persona leer, `pInfo` NULL): Anzeige, Freigabe, Leck? — widerlegt,
Rest P5/P6.** Der Konstruktor lässt bei `pInfo == NULL` alle Felder auf ihren Vorgaben
(`TaskErrorMT.cpp:18-41`). Die Anzeige liest nur Zeichenketten und `GetTimeStamp()` des
Basisobjekts, nicht den Zeitstempel der Aufgabe (`TaskErrorView.cpp:210-217`). Der Dialog setzt nur
Texte (`TaskErrorDlg.cpp:75-81`). Beim Entfernen einzeln (`:125`), beim Leeren aller (`:501`) und
nach dem Dialog (`:439`) ruft die Ansicht `RemoveTaskError`, und das gibt den Eintrag mit `delete`
frei (`QCTaskManager.cpp:951-963`). `m_pError` ist NULL, der Destruktor löscht also nichts
Fremdes. `GetNumTaskErrors` zählt den Eintrag nicht, weil er den Typ `TASK_TYPE_UNKNOWN` hat. Das
ist richtig, denn er gehört zu keiner Aufgabe. Ein Leck oder einen Absturz finde ich nicht.

**3. Flut? — belegt (Mechanik), siehe P3.**

**4. Liefert `DownloadFullHeaders` negative HRESULTs, und ändert die neue Bedingung einen richtigen
Weg? — belegt: ja und nein.** `DownloadFullHeaders` (`ImapMailbox.cpp:2935-2970`) liefert:

| Fall | Wert | alt `!hResult` | neu |
|---|---|---|---|
| Erfolg | `TRUE` (1) aus `DownloadFullHeaderToString` (BOOL, `ImapDownload.cpp:2723-2741`) | weiter | weiter |
| Abruf gescheitert | `FALSE` (0) | übersprungen | übersprungen |
| `OpenMailbox` gescheitert: Anmeldung abgebrochen, belegt, offline, `E_FAIL` | negativ (`:2953`) | **mit leeren Kopfzeilen weitergefiltert** | übersprungen |
| keine Verbindung | `E_FAIL` (`:2961`) | **weitergefiltert** | übersprungen |
| `E_INVALIDARG` | negativ (`:2942`) | — | kann hier nicht auftreten, `pTocDoc` und `Sum` sind gesetzt |

`SUCCEEDED` ist „≥ 0“, positive Werte außer 1 gibt es nicht. Ein Erfolgsweg wird also nicht
abgeschnitten. Geändert wird nur der Weg mit leeren Kopfzeilen. Der war falsch: Ein Filter
„From enthält nicht …“ trifft auf leeren Text zu und kann die Nachricht verschieben (Vermutung
zur Semantik von `CFilter::Match`, nicht nachgelesen). Neu bleibt sie stehen und wird gemeldet.
Das ist richtiger, macht den Weg aber zur Hauptquelle von P3.

**5. `%` in Betreff oder Postfachname? — widerlegt.** Betreff und Postfach gehen nur als
`%s`-Argument in `CString::Format` (`filtersd.cpp:2382-2389`). Dabei wird der Inhalt nicht als
Format gelesen. Alle weiteren Stationen nehmen den fertigen Text als Text:

* `PutDebugLog(DebugMaskType, LPCTSTR, int)` ist kein printf (`debug.h:93`);
* `Register` schreibt `GetErrText()` ebenso über `PutDebugLog` (`QCTaskManager.cpp:212`);
* die Ansicht kopiert den Text Zeichen für Zeichen und ersetzt Nicht-Druckbares durch Leerzeichen
  (`TaskErrorView.cpp:219-237`);
* `SetItemText` und `SetWindowText` werten nichts aus.

Ein Betreff mit `%s%n` erscheint wörtlich.

## Was vor dem Release zu ändern ist

1. **P1:** Die Notbremse nicht über `bLaeuft` und `bDialogOffen` hinweg greifen lassen, oder sie
   streichen.
2. **P2:** Den Zähler in `CImapFromLocalTransferMsgAction::DoPreThreadAction` setzen, die tote
   Zeile in der Basis streichen und den Kommentar in `ImapAccountMgr.cpp` berichtigen.
3. Möglichst **P3:** einen Sammeleintrag je Filterlauf. **P4:** Zähler, Dialog und Notbremse in
   die Spurmarke aufnehmen.
4. N6 bleibt wie besprochen offen.

## Gregors Test an 1.0.106

**Test 1 ([E-123](../Intern/BEFUNDE.md#e-123), wie bisher):** Eine Mail aus einem lokalen Ordner in einen IMAP-Ordner
verschieben, sofort beenden und gleich noch einmal auf das Kreuz klicken. In `eudora.log` stehen
dann „Beenden wartet auf 1 Uebertragung(en)“, „weiteres Schliessen waehrend des Wartens
ignoriert“, „Warten zu Ende nach … ms, offen=0“ und `E-33 ExitInstance: erreicht`.

**Test 2 ([E-69](../Intern/BEFUNDE.md#e-69)):** Eine Nachricht, die der Filter nicht lesen kann, steht als Eintrag in
„Task Errors“ und bleibt in ihrem Postfach. Auf eine Wiederholung achten: Erscheint derselbe
Betreff mehrmals, ist das P3.

**Nicht testen:** Fünf Minuten warten, während ein Kennwortdialog offen ist. Das ist P1, und es
kann Eudora unsichtbar hängen lassen.
