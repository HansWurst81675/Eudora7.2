# <a id="pruefer-106"></a>PRUEFER-106

Geprüft habe ich den Stand `38c614c3` des Zweigs `paket_7_2_2_137`. Mein Zweig ist wt/pruefer-20261107. Geprüft ist alles, was seit `1cb9087d` unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam (`git log 1cb9087d..HEAD`: vier Commits mit Inhalt, `79c65d62`, `507227e8`, `29acf3ed` und die Buchführung). Das ist die Runde vor dem Test-ZIP 7.2.2.137. Schwerpunkte: `CTridentView::Print` mit den neuen E242-Helfern (Registry setzen und herstellen, Zeitgeber `E242Uhr`, Aufruf aus `CEudoraApp::ExitInstance`), die Spurmarken und die Sanduhr für [E-240](../Intern/BEFUNDE.md#e-240), die Spurmarken für [E-71](../Intern/BEFUNDE.md#e-71) in `filtersd.cpp`, `TestE169.cpp`, `messen-e169.ps1` und die neuen Prüfstandsfälle.

Eudora habe ich weder gebaut noch gestartet und kein Fenster geöffnet. Keinen Prüfstand unter `C:\Temp` habe ich angefasst, keine Registry geändert. Die Testsuite lief zweimal in meinem Baum: einmal unverändert, einmal mit einer vorübergehenden Gegenprobe (§4). Danach habe ich beide Dateien byte-genau wiederhergestellt, `cmp` gegen `HEAD` war gleich.

## Ergebnis vorweg

**Kein Fund hält das Test-ZIP 7.2.2.137 auf.** Für die Druckvorschau stimmt der Aufbau mit der Messung überein (am Quelltext belegt): Die Werte werden gesetzt, auch wenn sie fehlen. Hergestellt werden sie erst, wenn das Vorschaufenster zu ist, spätestens beim nächsten Druck und beim Beenden. Mehrere der vorgeschlagenen Gegenvermutungen habe ich widerlegt: der Überlauf von `GetTickCount`, das statische Objekt mit `CString`, ein Zeitgeber nach `ExitInstance`, ein Wert über 256 Byte und der Abbruch des Druckdialogs (§2). Die Testsuite ist grün, 429/429 (gemessen).

**Beim Druck auf Papier kann die Rückstellung zu früh kommen (K1, mittel, Vermutung).** Ohne Vorschau zählt der Zeitgeber die 10 Sekunden „ohne Dialog“ ab dem Moment, in dem `Exec` zurückkehrt. Bei der Vorschau kehrt `Exec` aber nach 16 bis 62 ms zurück, und beim ersten Aufruf nach dem Start hat Gregor bis zum Fenster rund 38 s gestoppt. Verhält sich der Druck genauso, ist der alte Stand schon wieder da, wenn Druckdialog oder Druckvorlage erscheinen. Auf dem Papier stünde dann wieder der Pfad mit dem Anmeldenamen. Für die Vorschau gilt dieselbe Grenze mit 60 s. Abhilfe: auch beim Druck erst auf das erste Fenster warten und erst danach die Ruhezeit zählen. Für Gregors Papierschritt gibt es eine Leseanleitung im Protokoll (K1).

**Ein Absturz bei offener Vorschau hinterlässt Eudoras Kopf und Fuß für immer, nicht nur bis zum nächsten Druck (K2, mittel, belegt).** `E242Setzen` liest beim nächsten Druck den hängengebliebenen Wert als „alten“ Stand und stellt danach genau diesen wieder her. Die *Grenze* in [E-242](../Intern/BEFUNDE.md#e-242) („bis zum nächsten Druck aus Eudora“) stimmt deshalb nicht. Im Fuß steht dabei Gregors Absenderadresse, auch auf Ausdrucken aus dem Internet Explorer.

**Der Prüfstandsfall für [E-242](../Intern/BEFUNDE.md#e-242) kann blind grün werden (K3, mittel, belegt).** Laut `TESTLAEUFE.md` „musste“ Eudora schon mehrfach „abgeschossen werden“. Geschieht das bei offener Vorschau, stehen Eudoras Werte schon vor dem nächsten Lauf in der Registry. Dann melden `E-242p` (`kopf=eudora fuss=eudora`) und `E-242r` (`unveraendert=1`) grün, auch ohne Behebung. `messen-e169.ps1` gibt den Stand vor dem Lauf zwar aus, wertet ihn aber nicht aus.

**Der Fall `E-71n` ist blind (K4, gering, belegt).** Seine Muss-Zeile `E-71 Bericht: eintraege=0` schreibt jeder POP-Abruf, auch einer ganz ohne neue Post (`pop.cpp:1022` steht außerhalb von `if (nNumMessagesToFilter)`). Dasselbe gilt für jedes Senden (`sendmail.cpp:318`).

Dazu kommen fünf geringe Funde (K5 bis K9). Der wichtigste davon ist K8: Ein `&` im Betreff oder im Absender gilt dem Internet Explorer als Platzhalter. `&u` druckt die URL, also den Pfad der Zwischendatei mit dem Anmeldenamen. Das ist genau der Inhalt, den [E-242](../Intern/BEFUNDE.md#e-242) vom Papier holen will. Der Fehler steht schon im Original, wirkt aber erst jetzt, weil Kopf und Fuß jetzt überhaupt ankommen.

**Neue Kennung:** E-247 für K8 (steht noch nicht in `Intern/BEFUNDE.md`). Ich empfehle, mit K1, K2 und K3 [E-242](../Intern/BEFUNDE.md#e-242) fortzuschreiben, mit K5 und K6 [E-240](../Intern/BEFUNDE.md#e-240) und mit K4 [E-71](../Intern/BEFUNDE.md#e-71). E-248 bleibt frei. `befund-suchen.pl "CTridentView::Print"` nennt [E-62](../Intern/BEFUNDE.md#e-62), [E-169](../Intern/BEFUNDE.md#e-169), [E-240](../Intern/BEFUNDE.md#e-240), [E-241](../Intern/BEFUNDE.md#e-241) und [E-242](../Intern/BEFUNDE.md#e-242), keinen zum `&` im Kopf.

## 1. `CTridentView::Print` und die E242-Helfer: Aufbau gegen die Quelle

* **Setzen (belegt).** Der Titel samt `&bPage &p of &P` und der Fuß *„Printed for %s“* samt `&b&d` (`EudoraRes.rc:9351`, `:11385-11386`) werden vor dem Befehl gesetzt (`TridentView.cpp:2562-2563`, Befehl `:2604`). Das geschieht jetzt auch, wenn der Wert fehlt. Die Länge enthält das Nullbyte (`GetLength() + 1`, `:2359`). Das Original schrieb `GetLength()` ohne Nullbyte. Das Projekt ist MultiByte (`Eudora.vcxproj:29`), Bytes und Zeichen sind also dasselbe.
* **Herstellen (belegt).** `E242Herstellen` (`:2363-2375`) schreibt mit Typ und Länge zurück oder löscht den Wert, wenn er vorher fehlte. Ein Wert, der nicht in 256 Byte passt (`ERROR_MORE_DATA`), wird gar nicht angefasst (`:2357-2358`). Das ist richtig.
* **Reihenfolge (belegt).** `E242Zurueckstellen("neuer Druck")` (`:2539`) steht vor dem Setzen. Eine noch offene Rückstellung wird also zuerst erledigt, und der eigene Wert gilt nicht als „alt“. Der Zeitgeber wird erst nach `Exec` gestartet (`:2619-2627`). Gelingt `SetTimer` nicht, wird sofort hergestellt.
* **Zeitgeber (belegt).** `SetTimer(NULL, 0, 250, E242Uhr)` ist ein Zeitgeber des Fadens. Sein `WM_TIMER` mit `hwnd == NULL` geht durch `CWinThread::PreTranslateMessage` (keine `ON_THREAD_MESSAGE` für `WM_TIMER` in `CEudoraApp`) an `DispatchMessage`, und das ruft die Rückrufprozedur. Dasselbe Muster läuft in Eudora schon lange (`StatMng.cpp:454`). Modale Schleifen auf dem Hauptfaden reichen ihn ebenfalls weiter.
* **Suche nach dem Fenster (belegt).** `E242FensterSuchen` (`:2422-2437`) nimmt nur sichtbare Fenster dieses Prozesses, und zwar nur oberste Fenster (`EnumWindows`). Bei der Vorschau zählt nur `Internet Explorer_TridentDlgFrame`, beim Druck zusätzlich `#32770`. Ein modeloser Dialog von Eudora, etwa *Edit → Find*, hält die Rückstellung beim Druck bis zur Obergrenze von 10 min auf (`:2450`). Das ist ungefährlich, die Werte stehen dann nur länger.

## 2. Gegenvermutungen aus dem Auftrag

| Gegenvermutung | Urteil | Begründung |
|---|---|---|
| Überlauf von `GetTickCount` | widerlegt (belegt) | Alle Vergleiche rechnen mit der Differenz in `DWORD` (`:2448`, `:2450`, `:2468`). Das bleibt über den Überlauf nach 49,7 Tagen richtig. |
| statisches Objekt mit `CString`, Reihenfolge der Zerstörung | unbedenklich (belegt) | MFC ist dynamisch gebunden (`Eudora.vcxproj:27`), der String-Manager lebt in der MFC-DLL bis nach den Statiken der EXE. Statische `CString` gibt es schon (`compmsgd.cpp:2132`, `eudora.cpp:3860`). Hergestellt wird vorher in `ExitInstance`. |
| Zeitgeber feuert nach `ExitInstance` | widerlegt (belegt) | `E242Zurueckstellen` beendet den Zeitgeber als Erstes (`:2380-2384`), auch wenn nichts mehr aktiv ist. `ExitInstance` läuft auf dem Hauptfaden, danach pumpt niemand mehr. |
| Wert länger als 256 Byte | richtig behandelt (belegt) | Er wird nicht gesetzt (`:2357`). Nur die Spurmarke meldet dann `vorher=0`, als fehle der Wert (K9). |
| Abbruch des Druckdialogs | unbedenklich (belegt) | `Exec` kehrt zurück, der Zeitgeber stellt nach 10 s ohne Dialog her. |
| zweite Vorschau, während die erste offen ist | teilweise bestätigt (Vermutung) | siehe K7 |
| falsches Fenster gefunden | beim Druck harmlos, bei zwei Vorschauen möglich | siehe §1 und K7 |
| Zeitgeber aus der alten Rückstellung feuert in der Warteschleife `IsReady` (`:2498`) | unbedenklich (belegt) | Er stellt nur den vorigen Stand her, `:2539` würde dasselbe tun. |
| `WM_TIMER` des Fadens wird für Eudoras Leerlauf-Zeitgeber gehalten (`eudora.cpp:2411`) | unbedenklich (Vermutung) | Das ginge nur, wenn die vom System vergebene Kennung zufällig gleich `GetGeneralTimerID()` wäre. |

**Offen gelassen, nicht gemessen:**
* Die Schrift wird 16 bis 62 ms nach `Exec` auf die Nachrichtenschrift zurückgesetzt (`:2642`). Die Vorschau baut aber erst danach auf. Möglich ist, dass die Vorschau deshalb die Nachrichtenschrift statt der Druckerschrift (`IDS_INI_PRINTER_FONT`) zeigt. Das wäre der Mechanismus von [E-242](../Intern/BEFUNDE.md#e-242), angewandt auf die Schrift. Es ist Originalverhalten, also kein Rückschritt. Mit einer auffälligen Druckerschrift ließe es sich am Prüfstand in einem Lauf klären.
* Beim Drucken mehrerer Nachrichten (`TocFrame.cpp:910`, `QuietPrint` in einer Schleife) stellt jeder neue Aufruf den vorigen Stand sofort her. Liest MSHTML beim Druck später, trüge Nachricht N den Titel von N+1. Vorher hätte sie den Wert des Internet Explorer getragen. Das ist nicht schlechter als vorher, und gemessen ist es nicht.

## 3. E-240, E-71 und die Werkzeuge

* **[E-240](../Intern/BEFUNDE.md#e-240) (belegt).** Es gibt die Spurmarken `Anfang`, `Befehl ab` und `zurueck`. Die im Kommentar versprochene Marke `bereit` (`:2486`) fehlt. Die Zeit der Warteschleife steckt in `Befehl ab`. Die Kommentare `:2488-2489` und `:2590` sagen, die Vorschau sei modal und kehre erst beim Schließen zurück. Das widerspricht der eigenen Messung (16 bis 62 ms) (K5). Zur Wirkung der Sanduhr siehe K6.
* **[E-71](../Intern/BEFUNDE.md#e-71) (belegt).** Die Spurmarke in `CFilter::Action` nennt alle Größen, von denen die Bedingung `filtersd.cpp:1691-1694` abhängt: Aktion, Ziel, Typ, `m_NotfyUserNR` und den INI-Schalter. Nebenbei: Durch den Vorrang von `&&` vor `||` umgeht ein Filter mit `NO_REPORT` die Typprüfung. Das ist Originalbestand und hier ohne Folgen. Die Marke `E-71 Bericht:` in `EndFiltering` stimmt. `fenster=1` ist der Normalfall, weil `GetFilterReportView` das Fenster bei Bedarf selbst anlegt (`FilterReportView.cpp:141-147`). Zur Blindheit von `E-71n` siehe K4.
* **`messen-e169.ps1` (belegt).** `KF` erkennt Eudoras Werte am Ende `&bPage &p of &P` und am Anfang `Printed for `. Das passt zu `EudoraRes.rc`. Mit 60 s Wartezeit und 100-ms-Schritten bis zur Vorschau ist das Skript richtig für [E-240](../Intern/BEFUNDE.md#e-240). Zur fehlenden Prüfung des Stands vor dem Lauf siehe K3.

## 4. Testsuite und Gegenprobe

**Gemessen:** `RunTests.cmd` an `38c614c3`: 429 Tests, 429 bestanden.

**Gegenprobe, gemessen.** Zwei Zeilen habe ich vorübergehend durch einen Kommentar ersetzt, mit Perl byte-genau und mit je einem Treffer:
1. `E242Zurueckstellen("Beenden");` in `eudora.cpp`. Erwartung: rot.
2. `s_E242.bAktiv = TRUE;` in `TridentView.cpp`. Damit wird **nie** hergestellt und kein Zeitgeber gestartet, Eudoras Werte blieben für immer stehen.

Ergebnis: 428/429. Rot ist nur *„ExitInstance stellt eine beim Beenden noch offene Rueckstellung nicht her“*. Die zweite Änderung geht unbemerkt durch (K9). Danach habe ich beide Dateien aus der Sicherung im Scratchpad zurückkopiert, `cmp` gegen `git show HEAD:` war gleich, und `git status` war leer.

## Funde

### <a id="k1"></a>K1 (mittel, Vermutung, am Quelltext belegt): Beim Druck beginnt die Ruhezeit zu früh

Ohne Vorschau setzt `Print` `dwRuhigSeit = dwAnfang` gleich nach `Exec` (`:2621-2622`). `E242Uhr` stellt her, sobald 10 s lang kein `#32770` und kein `TridentDlgFrame` sichtbar war (`:2444-2449`). Ob `Exec(OLECMDID_PRINT)` früh zurückkehrt, ist nicht gemessen. Für die Vorschau ist das aber gemessen: 16 bis 62 ms, danach baut MSHTML in Ruhe auf. Beim ersten Aufruf nach dem Start gingen bei Gregor rund 38 s vorbei ([E-240](../Intern/BEFUNDE.md#e-240)). Lädt der Druck dieselben Teile, erscheint sein Dialog nach mehr als 10 s. Dann ist Eudoras Kopf und Fuß schon wieder fort, und das Papier zeigt wieder den Pfad `file:///C:/Users/…`. Dieselbe Grenze gilt für die Vorschau, nur mit 60 s (`:2468`). Bei 38 s ist das knapp. Auf einem langsameren Rechner bekäme die Vorschau wieder MSHTMLs Vorgaben.

**Abhilfe:** Beim Druck mit Dialog (`bDialog`) wie bei der Vorschau erst auf das erste Fenster warten (bis 60 s) und erst danach die 10 s zählen. Für `QuietPrint` ohne Dialog die Ruhezeit auf etwa 60 s anheben. Die Grenze für die Vorschau auf etwa 120 s anheben. Das kostet nur, dass die Werte länger stehen.

**Für Gregors Papierschritt:** Steht unten doch `file:///…`, dann im `eudora.log` nachsehen: `E-240 Druck: zurueck nach N ms` und `E-242 zurueck (Druck, 10 s ohne Dialog) nach M ms`. Liegt M vor dem Erscheinen des Druckdialogs, ist es K1.

### <a id="k2"></a>K2 (mittel, am Quelltext belegt): Nach einem Absturz bei offener Vorschau bleiben Eudoras Werte für immer

Hergestellt wird nur aus dem Speicher (`s_E242`), und zwar beim Schließen der Vorschau, beim nächsten Druck oder in `ExitInstance`. Stürzt Eudora ab, wird es abgeschossen oder wird Windows hart beendet, während eine Vorschau offen ist oder in den 10 s nach einem Druck, dann bleiben Titel und *„Printed for <Absenderadresse>“* in `HKCU\…\Internet Explorer\PageSetup` stehen. Beim nächsten Druck liest `E242Setzen` genau diese Werte als „alten“ Stand (`:2353-2356`, `bHatte = TRUE`) und stellt sie danach wieder her. **Sie bleiben also dauerhaft**, nicht nur *„bis zum nächsten Druck aus Eudora“*, wie es die Grenze in [E-242](../Intern/BEFUNDE.md#e-242) sagt. Folge: Jeder Druck aus dem Internet Explorer oder aus einem anderen Programm, das MSHTML nutzt, trägt den Titel der letzten Eudora-Nachricht und Gregors Adresse. Das Fenster dafür war im Original 30 bis 60 ms lang. Jetzt dauert es so lange, wie die Vorschau offen ist. Kein Mailverlust.

**Abhilfe:** Den alten Stand beim Setzen dauerhaft vormerken, etwa als Werte unter `HKCU\Software\Qualcomm\Eudora\E242` oder in der INI, dabei „fehlt“ eigens kennzeichnen. Nach dem Herstellen die Vormerkung löschen. Beim Start: Steht noch eine Vormerkung, zuerst herstellen. Mindestens die Grenze in [E-242](../Intern/BEFUNDE.md#e-242) berichtigen.

### <a id="k3"></a>K3 (mittel, am Quelltext belegt): `E-242p` und `E-242r` werden mit hängengebliebenen Werten blind grün

`messen-e169.ps1` gibt `E242 REGISTRY vor dem Lauf …` nur aus. `E-242p` verlangt `kopf=eudora fuss=eudora` während der Vorschau, `E-242r` verlangt `unveraendert=1`. Stehen Eudoras Werte schon vor dem Lauf da (K2), sind beide Bedingungen auch mit einem Bau ohne Behebung erfüllt. Dass das am Prüfstand vorkommt, zeigt `TESTLAEUFE.md`: Am 06.11.2026 „musste“ Eudora dreimal „abgeschossen werden“. Die Gegenprobe vom 07.11.2026 (rot am alten Bau) war gültig, weil die Werte da fehlten. Ein späterer Rückschritt wäre aber unsichtbar.

**Abhilfe:** Steht vor dem Lauf `kopf=eudora` oder `fuss=eudora`, gibt `messen-e169.ps1` `E169 ABBRUCH vorher schon Eudora-Werte` aus. Das steht bei beiden Fällen schon als *darf nicht*. Alternativ räumt das Skript die beiden Werte vor dem Lauf weg. Dann ist `E-242r` aber nur noch für den Zustand „fehlt“ aussagekräftig.

### <a id="k4"></a>K4 (gering, am Quelltext belegt): `E-71n` ist blind

`CPopSession` ruft `filt.EndFiltering()` nach dem `if (nNumMessagesToFilter)`-Block auf (`pop.cpp:1022`), also bei jedem Abruf. Die neue Marke schreibt dann `E-71 Bericht: eintraege=0 fenster=-` (`filtersd.cpp:4166-4167`). Dasselbe geschieht beim Senden (`sendmail.cpp:318`). Die Muss-Zeile von `E-71n` steht deshalb auch dann im Protokoll, wenn die Testmail nie ankommt oder der Filter nicht greift. Das *darf nicht* `eintraege=1` fängt nur den umgekehrten Fehler. Gemessen habe ich das nicht, die Protokolle liegen unter `C:\Temp`.

**Abhilfe:** Als Muss für `E-71n` die Zeile nehmen, die nur ein greifender Filter schreibt: `E-71 Eintrag: aktion=1 ziel=1`, dazu den INI-Wert, etwa mit einer Teilzeichenkette `… ini=0`. Das *darf nicht* bleibt `eintraege=1`.

### <a id="k5"></a>K5 (gering, belegt): Kommentare zu E-240 widersprechen der Messung

`TridentView.cpp:2488-2489`: *„OLECMDID_PRINTPREVIEW kehrt erst zurueck, wenn die Vorschau geschlossen ist“*. `:2590`: *„solange die modale Vorschau offen ist“*. Beides ist durch die eigene Spurmarke widerlegt (16 bis 62 ms, nicht modal), und der E-242-Kommentar zehn Zeilen darunter sagt das Gegenteil. `:2486` kündigt eine Spurmarke *„bereit (nach der Warteschleife)“* an, die es nicht gibt. Wer später an der Vorschau arbeitet, liest die falsche Hälfte. **Abhilfe:** die drei Stellen berichtigen. Die Marke `bereit` entweder nachrüsten oder aus dem Kommentar streichen.

### <a id="k6"></a>K6 (gering, Vermutung): Die Sanduhr verschwindet bei der ersten Mausbewegung

`::SetCursor(IDC_WAIT)` (`:2600`) wirkt bis zum nächsten `WM_SETCURSOR`. Weil `Exec` nach 16 bis 62 ms zurückkehrt und der Hauptfaden dann wieder Nachrichten verarbeitet, setzt die nächste Mausbewegung über Eudora den Pfeil zurück. Die Sanduhr hilft also nur, wenn die 38 s des ersten Aufrufs **vor** der Rückkehr von `Exec` im Hauptfaden vergehen. Liegen sie danach, sieht Gregor wieder keine Rückmeldung, und genau dann klickt man *„wild herum“*. Welcher Fall vorliegt, zeigen erst seine Spurmarken. **Abhilfe:** Die Rückmeldung bis zum Fund des Vorschaufensters halten. `E242Uhr` weiß das schon (`:2459-2466`). Infrage kommen ein Text in der Statuszeile oder ein zählender Wartezeiger, der dort beendet wird. Im Testschritt zu [E-240](../Intern/BEFUNDE.md#e-240) sollte stehen: Maus nach dem Klick ruhig halten, und notieren, ob die Sanduhr bleibt.

### <a id="k7"></a>K7 (gering, Vermutung): Zwei Vorschauen zugleich

Öffnet Gregor eine zweite Vorschau, während die erste offen ist, etwa durch erneutes Klicken in den 38 s ([E-240](../Intern/BEFUNDE.md#e-240)), dann stellt `:2539` den Stand sofort her, solange die erste noch offen ist. *Drucken* aus der ersten Vorschau hätte dann keine Eudora-Werte mehr, wenn sie dort neu gelesen werden. Danach nimmt `E242Uhr` das erste sichtbare `TridentDlgFrame`, das `EnumWindows` liefert. Ist die zweite Vorschau noch nicht sichtbar, ist das die erste. Schließt Gregor sie, wird hergestellt, während die zweite noch aufbaut. Das ist selten und ohne Datenverlust. **Abhilfe:** beim Fund ein Fenster überspringen, das schon vor `Exec` sichtbar war (Liste vor `Exec` merken), oder zurückstellen, sobald **kein** `TridentDlgFrame` mehr sichtbar ist statt eines bestimmten.

### <a id="k8"></a>K8 (gering, belegt, neu als E-247): `&` in Betreff oder Absender wird zum Platzhalter

Kopf und Fuß des Internet Explorer kennen Platzhalter: `&w` Titel, `&u` URL, `&d`/`&D` Datum, `&t`/`&T` Uhrzeit, `&p`/`&P` Seite, `&b` Ausrichtung, `&&` ein Zeichen `&`. `Print` hängt den Betreff (`pDoc->GetTitle()`, `:2551`) und die Absenderadresse (`GetReturnAddress()`, `:2558`) unverändert ein. Ein Betreff *„R&D“* druckt `R` + langes Datum. Ein Betreff mit `&u` druckt die URL, also den Pfad der Zwischendatei mit dem Windows-Anmeldenamen. Das ist genau das, was [E-242](../Intern/BEFUNDE.md#e-242) vom Papier holen soll. Der Fehler steht schon im Original, wirkte aber nie, weil die Werte nie ankamen. **Abhilfe:** In `Title` und `NewFooter` vor dem Anhängen der festen Teile jedes `&` durch `&&` ersetzen (`Replace("&", "&&")`). Das sind zwei Zeilen.

### <a id="k9"></a>K9 (gering, gemessen): Die Quelltextprobe sieht ein fehlendes `bAktiv = TRUE` nicht, die Spurmarke verwechselt „zu lang“ mit „fehlt“

Gegenprobe (§4): Ohne `s_E242.bAktiv = TRUE;` wird nie hergestellt und kein Zeitgeber gestartet, und `TestE169` bleibt grün. Bemerken würde das nur der Prüfstand (`E-242r`), und der kann blind sein (K3). **Abhilfe:** `QT_Stelle(pP, "s_E242.bAktiv = TRUE;")` zwischen dem Setzen und `ExecCommandOnNullSet` verlangen und den Wächter `if (s_E242.bAktiv)` vor `SetTimer` prüfen. Außerdem meldet `E-242 gesetzt: kopf vorher=0 gesetzt=0` dasselbe für „fehlt und nicht setzbar“ und für „über 256 Byte, absichtlich nicht angefasst“ (`:2356`). Mit dem Rückgabewert `l` in der Spurmarke ließen sich die beiden Fälle unterscheiden.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Druck ohne Vorschau: Rückstellung nach 10 s ab Rückkehr von `Exec`, beim langsamen ersten Aufruf vielleicht vor dem Lesen; Vorschau-Grenze 60 s knapp über 38 s | mittel | nein; beim Papierschritt Protokollzeilen lesen |
| [K2](#k2) | Absturz oder Abschuss bei offener Vorschau: Eudoras Kopf und Fuß (mit Adresse) bleiben **für immer** in der IE-Einstellung; Grenze in [E-242](../Intern/BEFUNDE.md#e-242) falsch beschrieben | mittel | nein (selten, kein Mailverlust); Vormerkung empfohlen |
| [K3](#k3) | `E-242p`/`E-242r` blind grün, wenn Werte vom abgeschossenen Lauf schon stehen | mittel | nein; vor dem nächsten vollen Lauf beheben |
| [K4](#k4) | `E-71n` grün bei jedem Abruf, auch ohne Filtertreffer | gering | nein |
| [K5](#k5) | Kommentare: Vorschau „modal“, „kehrt erst beim Schließen zurück“, Marke `bereit` fehlt | gering | nein |
| [K6](#k6) | Sanduhr verschwindet bei der ersten Mausbewegung, falls die Wartezeit nach `Exec` liegt | gering | nein; Testschritt ergänzen |
| [K7](#k7) | zweite Vorschau während der ersten: zu frühe Rückstellung, falsches Fenster | gering | nein |
| [K8](#k8) | `&` im Betreff/Absender wird IE-Platzhalter, `&u` druckt den Pfad mit Anmeldenamen (neu E-247) | gering | nein (zwei Zeilen) |
| [K9](#k9) | Quelltextprobe blind für fehlendes `bAktiv = TRUE`; Spurmarke unterscheidet „zu lang“ nicht von „fehlt“ | gering | nein |
