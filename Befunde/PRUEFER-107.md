# <a id="pruefer-107"></a>PRUEFER-107

Geprüft habe ich den Stand `c24d6d4a` des Zweigs `paket_7_2_2_137`, in meinem Zweig wt/pruefer-20261107b. Geprüft ist `git log -p 72bcb0b8..HEAD -- Eudora71 tools/paket-bauen.ps1`. Das sind zwei Commits: `1051bfaf` (Sanduhr und Abweisung für [E-240](../Intern/BEFUNDE.md#e-240), `TestE169.cpp`, Schritt 8 in `paket-bauen.ps1`) und `e54fb907` (`EudoraUnicodeFix` unter `Bin/Release/Plugins`). Es ist ein kurzer Lauf vor dem Test-ZIP 7.2.2.138. Das Vorbild ist [PRÜFER-106](PRUEFER-106.md).

Eudora habe ich weder gebaut noch gestartet und kein Fenster geöffnet. Keinen Prüfstand habe ich angefasst. Die Testsuite lief zweimal in meinem Baum: einmal unverändert, einmal mit einer vorübergehenden Gegenprobe (§3). Danach habe ich `TridentView.cpp` aus der Sicherung zurückkopiert. `cmp` gegen `git show HEAD:` war gleich, `git status` war leer.

## Ergebnis vorweg

**Kein Fund hält das Test-ZIP 7.2.2.138 auf.** Die Testsuite ist grün, 429/429 (gemessen). Die Sanduhr aus dem Zeitgeber passt zu Gregors Messung. Am Quelltext belegt sind drei Dinge: Sie endet beim Fund des Fensters. Sie endet spätestens nach 120 s. Und sie hängt nicht an der Ansicht, das Schließen der Mail während der Wartezeit ist also ungefährlich. Die verworfene Durchreiche für [E-241](../Intern/BEFUNDE.md#e-241) steht nicht mehr in `eudora.cpp` (gemessen). Schritt 8 in `paket-bauen.ps1` ist schlüssig.

**Die Abweisung gilt für jeden Aufruf, nicht nur für eine zweite Vorschau (K1, gering, am Quelltext belegt).** Druckt Gregor während der bis zu 120 s Ladezeit aus der Postfachliste mehrere Nachrichten, bricht `CTocFrame::Print` die ganze Reihe nach der ersten ab, ohne Meldung. *Print* (Strg+P) in einer anderen Mail tut in dieser Zeit ebenfalls nichts.

**Beim Druck mit Dialog könnte die Sanduhr bis zu 120 s stehen bleiben (K2, gering, Vermutung).** Das passiert dann, wenn `Exec(OLECMDID_PRINT)` den Druckdialog im Hauptthread zeigt und erst danach zurückkehrt. Dann findet der Zeitgeber keinen Dialog mehr. Gregors Messung an 7.2.2.137 entscheidet das nicht. Eine Leseanleitung steht bei K2.

Dazu kommen drei geringe Funde: die Sanduhr flackert bei Mausbewegung (K3, Vermutung), die Quelltextprobe ist blind für eine Sanduhr, die nie eingeschaltet wird (K4, gemessen), und ein Kommentar ist überholt (K5).

**Kennungen:** keine neue vergeben. E-249 und E-250 bleiben frei. Ich empfehle, K1 bis K5 bei [E-240](../Intern/BEFUNDE.md#e-240) fortzuschreiben.

## 1. E-240: Sanduhr und Abweisung gegen die Quelle

* **Ablauf (belegt).** `Print` setzt nach `Exec` `s_E242.bSanduhr` (`TridentView.cpp:2684`), aber nur bei Vorschau oder Dialog und nur, wenn `SetTimer` gelang. `E242Uhr` prüft die Sanduhr bei jedem Schlag **vor** der Fenstersuche (`:2462-2468`). Gibt es schon `hVorschau` oder sind 120 s vorbei, wird sie abgeschaltet, sonst neu gesetzt. `E242Zurueckstellen` schaltet sie immer ab (`:2386`), auch wenn nichts mehr aktiv ist.
* **`E240SanduhrSetzen` (belegt).** Die Sanduhr wird nur gesetzt, wenn `WindowFromPoint` ein Fenster dieses Prozesses liefert (`:2446-2457`). Über fremden Programmen bleibt der Zeiger also unberührt.

| Gegenvermutung | Urteil | Begründung |
|---|---|---|
| `SetCursor` aus dem Zeitgeber wirkt nicht, wenn die Maus über einem Fenster des Hauptthreads steht | widerlegt (belegt, Wirkung am Bildschirm nicht gemessen) | Der Zeitgeber ist ein Thread-Zeitgeber (`SetTimer(NULL, …)`, `:2681`). Seine Rückrufprozedur läuft deshalb im Hauptthread, also in dem Thread, dem Eudoras Fenster gehören. `SetCursor` wirkt dort. Über einem Fenster eines anderen Threads, etwa dem fertigen Vorschaufenster, wirkt es nicht. Dann ist aber `bSanduhr` schon aus. Zwischen zwei Schlägen setzt jede Mausbewegung den Pfeil zurück (K3). |
| Die Sanduhr bleibt nach dem Erscheinen hängen | widerlegt (belegt) | Im Schlag, in dem das Fenster gefunden wird, steht die Sanduhr-Prüfung noch davor. Sie setzt also ein letztes Mal. Im nächsten Schlag (250 ms) ist `hVorschau` gesetzt und `bSanduhr` aus. Diese letzte Sanduhr steht bis zum nächsten `WM_SETCURSOR`. Erscheint die Vorschau unter dem Zeiger, setzt ihr eigener Thread den Zeiger. |
| Die Vorschau kommt nie | begrenzt (belegt) | Nach 120 s greift `E242Zurueckstellen("kein Vorschaufenster binnen 120 s")` (`:2504-2505`). Damit enden Sanduhr, Zeitgeber und Abweisung (`uUhr = 0`, `:2384`). Im schlimmsten Fall bleibt die Sanduhr also 120 s, und zwei Minuten lang wird jeder weitere Aufruf abgewiesen (K1). |
| Der Benutzer schließt die Mail, während er wartet | ungefährlich (belegt für Eudoras Teil) | `s_E242` ist statisch und ohne Zeiger auf die Ansicht. `E242Uhr` fasst keine Ansicht an (`:2459-2510`). Außerhalb der Helfer nutzt nur `ExitInstance` die Rückstellung (grep). Ob MSHTML die Vorschau dann abbricht, ist nicht gemessen. Bricht sie ab, gilt die Zeile darüber (120 s). |
| `Print` hängt an der Abweisung fest, Rückgabe `FALSE` | kein Hängen (belegt), aber stille Folgen | Die Abweisung kehrt sofort zurück. Sie liegt vor `SetRedraw(FALSE)` (`:2521-2526`), die Ansicht bleibt also nicht dunkel. `OnFilePrint`, `OnFilePrintOne` und `OnFilePrintPreview` übergehen den Rückgabewert (`:3432-3446`), ebenso `CSumList` (`summary.cpp:3039`). `CTocFrame::Print` wertet `FALSE` als Fehler und bricht die Reihe ab (`TocFrame.cpp:873`, `:910`), siehe K1. |

## 2. `tools/paket-bauen.ps1`, Schritt 8

* **`$ausRedist` nur bei Release (belegt).** Die Liste wird vor Schritt 7 leer angelegt und nur im Release-Zweig gefüllt (`:735-737`). Schritt 8 läuft selbst nur bei Release (`:780`). Das passt zusammen. `-contains` vergleicht ohne Rücksicht auf Groß- und Kleinschreibung. Verglichen wird der Pfad relativ zum Paket. Nur die drei Dateien im Paketstamm werden übersprungen, eine gleichnamige Datei in einem Unterordner nicht.
* **Prüfung auf das Debug-Muster übersprungen: vertretbar (belegt).** Schritt 7 holt die drei Dateien fest aus `VC\Redist\MSVC\<neueste>\x86\Microsoft.VC143.CRT` bzw. `…MFC` (`:756-758`). Die Debug-Fassungen liegen bei Visual Studio unter `debug_nonredist` und kommen auf diesem Weg nicht ins Paket. `Nimm` bricht ab, wenn die Quelle fehlt (`:502`). Eine alte Kopie bleibt also nicht unbemerkt stehen, sie wird überschrieben. `paket-pruefen.ps1` hat Gregor nach der Klonprobe ohne Fehler laufen lassen (laut Commit `c24d6d4a`, von mir nicht wiederholt).
* **`EudoraUnicodeFix.dll` (gemessen).** Das Debug-Muster aus `:783` findet in der Datei nichts. Sie bindet nur `kernel32`, `user32` und `shell32`. Sie liegt unter `Bin/Release/Plugins`, also prüft Schritt 8 sie regulär mit.

## 3. `TestE169.cpp`, Testsuite und Gegenprobe

**Gemessen:** `RunTests.cmd` an `c24d6d4a`: 429 Tests, 429 bestanden.

**Gegenprobe, gemessen.** Zwei Stellen in `TridentView.cpp` habe ich vorübergehend geändert, mit Perl `:raw` und mit je einem Treffer:
1. `s_E242.bSanduhr = (s_E242.uUhr != 0 && (bDoPreview || bDialog));` → `s_E242.bSanduhr = FALSE;`. Damit kommt die Sanduhr **nie**.
2. Die Abweisung `… && !s_E242.hVorschau)` → `… && s_E242.hVorschau)`. Damit ist sie umgedreht.

Ergebnis: 428/429. Rot ist nur *„ein weiterer Aufruf waehrend die Vorschau laedt wird nicht vor allem anderen abgewiesen ([E-240](../Intern/BEFUNDE.md#e-240))“* (Zeile 147). Die erste Änderung geht unbemerkt durch (K4). Danach habe ich die Datei aus der Sicherung im Scratchpad zurückkopiert: `cmp` gleich, `git status` leer.

## 4. E-241: Durchreiche entfernt

**Gemessen:** `git diff 72bcb0b8 HEAD -- Eudora71/Eudora/eudora.cpp` ist leer. In `eudora.cpp` kommt `TridentDlgFrame` nicht vor. `CEudoraApp::PreTranslateMessage` (`eudora.cpp:1900-1999`) enthält nur den Originalbestand und den E-137-Merker. `Internet Explorer_TridentDlgFrame` steht nur noch in `TridentView.cpp:2412` und `:2434`, also in der Fenstersuche von [E-242](../Intern/BEFUNDE.md#e-242).

## Funde

### <a id="k1"></a>K1 (gering, am Quelltext belegt): Die Abweisung trifft auch Druckaufträge, die Serie aus dem Postfach bricht still ab

Die Bedingung `s_E242.uUhr && s_E242.bVorschau && !s_E242.hVorschau` (`TridentView.cpp:2521`) fragt nur den Zustand der laufenden Vorschau ab. Ob der neue Aufruf selbst eine Vorschau ist, fragt sie nicht ab. Außerdem ist `s_E242` für alle Ansichten gemeinsam. Solange eine Vorschau lädt (bei Gregor 36,6 s, höchstens 120 s), passiert deshalb Folgendes:
* *Print* und *Print One* in **jeder** Mail tun nichts. Rückmeldung gibt es nur einmal kurz als Sanduhr und als Zeile im Protokoll.
* *File → Print* aus der Postfachliste (`CTocFrame::Print`): Die erste `QuietPrint` liefert `FALSE`. Daraufhin wird `bError = TRUE` gesetzt, und die Schleife endet (`TocFrame.cpp:873`, `:910`). Der Fortschritt schließt sich, gedruckt wurde nichts, eine Meldung gibt es nicht.

Das ist selten und ohne Datenverlust, Gregor kann den Druck wiederholen. **Abhilfe:** die Abweisung auf `bDoPreview` beschränken. Ein Druck in dieser Zeit stiehlt dann zwar der ladenden Vorschau die Werte (`E242Zurueckstellen("neuer Druck")`, wie in PRÜFER-106 K7), das ist aber das kleinere Übel. Wer die Abweisung für alle behalten will, sollte wenigstens einen Signalton oder einen Text in der Statuszeile ausgeben, und `CTocFrame::Print` sollte sie nicht als Fehler werten.

### <a id="k2"></a>K2 (gering, Vermutung): Sanduhr bis zu 120 s nach einem Druck mit Dialog

`bSanduhr` gilt auch für den Druck mit Dialog (`:2684`). Abgeschaltet wird sie, sobald der Zeitgeber ein `#32770` dieses Prozesses sieht (`:2477-2481`, dann `hVorschau` gesetzt). Der Zeitgeber startet aber erst **nach** `Exec`. Ist der Druckdialog von `OLECMDID_PRINT` modal **in** `Exec`, ist er beim ersten Schlag schon zu. Dann sieht der Zeitgeber keinen Dialog, und Sanduhr und Werte bleiben bis „Druck, kein Dialog binnen 120 s“ (`:2484-2485`) stehen. Bei der Vorschau ist gemessen, dass `Exec` sofort zurückkehrt. Beim Druck ist das nicht gemessen. Gregors Messung an 7.2.2.137 (`E-242 zurueck (Druck, 10 s ohne Dialog) nach 22297 ms`) zeigt, dass **ein** Dialog gesehen wurde. Das kann aber auch der Speichern-Dialog von *Microsoft Print to PDF* gewesen sein, denn der ist ebenfalls ein `#32770` in Eudoras Prozess. Mit einem echten Drucker gibt es diesen Dialog nicht.

**Leseanleitung für Gregors Papierschritt:** Ist `E-240 Druck: zurueck nach N ms` mehrere Sekunden lang, war `Exec` synchron. Steht danach `E-242 zurueck (Druck, kein Dialog binnen 120 s)`, dann ist es K2. **Abhilfe in diesem Fall:** beim Druck die Sanduhr nur setzen, wenn `Exec` schnell zurückkehrt, etwa unter 1 s.

### <a id="k3"></a>K3 (gering, Vermutung): Die Sanduhr flackert, sobald die Maus bewegt wird

Jede Mausbewegung über Eudora schickt `WM_SETCURSOR`, und der Klassencursor (Pfeil) steht wieder da, bis der nächste Schlag nach höchstens 250 ms die Sanduhr setzt. Bei ruhiger Maus bleibt sie stehen, beim Bewegen wechselt sie mit dem Pfeil. Das ist das Beste, was ohne zählenden Wartezeiger geht. Den hat PRÜFER-106 K6 genannt, er wurde aber zu Recht nicht gewählt, weil er über Eudoras Fenstern auch nach dem Fund stehen bliebe, bis `EndWaitCursor` kommt. Der Testschritt 4 für 7.2.2.138 sollte deshalb sagen: *„Maus ruhig: Sanduhr steht; Maus bewegt: Sanduhr kommt immer wieder.“* Der alte Text *„die Maus dabei nicht bewegen (sonst verschwindet die Sanduhr vorzeitig)“* (`Intern/TESTPLAN.md:24`) gilt für 7.2.2.137.

### <a id="k4"></a>K4 (gering, gemessen): Die Quelltextprobe merkt nicht, wenn die Sanduhr nie eingeschaltet wird

Die neue Prüfung verlangt `if (s_E242.bSanduhr)` und `E240SanduhrSetzen();` in den Helfern (`TestE169.cpp:143`). Dass `Print` `bSanduhr` überhaupt setzt, prüft sie nicht. Gegenprobe (§3): Mit `s_E242.bSanduhr = FALSE;` bleibt sie grün. Auch der Rumpf der Abweisung (`return FALSE;`) wird nicht geprüft, nur die Bedingung und ihre Lage. **Abhilfe:** `QT_Stelle(pP, "s_E242.bSanduhr = (s_E242.uUhr != 0 && (bDoPreview || bDialog));")` hinter `lUhr` verlangen.

### <a id="k5"></a>K5 (gering, belegt): Überholter Kommentar zur Sanduhr

`TridentView.cpp:2643-2648` sagt weiter, die Sanduhr stehe nur bis zum nächsten `WM_SETCURSOR`. Lädt MSHTML erst nach der Rückkehr, *„nimmt die erste Mausbewegung sie weg ([PRUEFER-106](PRUEFER-106.md#pruefer-106) K6, nicht gemessen)“*. Gregor hat das inzwischen gemessen (94 ms und 36,6 s), und der Zeitgeber hält die Sanduhr jetzt. Der Kommentar sollte auf `E240SanduhrSetzen` und `E242Uhr` verweisen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Während eine Vorschau lädt (bis 120 s), werden auch Druckaufträge still abgewiesen; die Druckreihe aus dem Postfach bricht ohne Meldung ab | gering | nein (selten, kein Datenverlust); Abweisung auf `bDoPreview` beschränken |
| [K2](#k2) | Ist der Druckdialog synchron in `Exec`, bleibt die Sanduhr nach dem Druck bis zu 120 s | gering | nein; beim Papierschritt `E-240 Druck: zurueck nach` lesen |
| [K3](#k3) | Sanduhr flackert bei Mausbewegung (Pfeil bis zum nächsten Schlag) | gering | nein; Testschritt 4 anpassen |
| [K4](#k4) | `TestE169` bleibt grün, wenn `bSanduhr` nie gesetzt wird (Gegenprobe gemessen) | gering | nein |
| [K5](#k5) | Kommentar `TridentView.cpp:2643-2648` überholt | gering | nein |
