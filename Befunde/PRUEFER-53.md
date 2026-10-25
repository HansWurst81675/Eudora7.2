# <a id="pruefer-53"></a>PRUEFER-53 — die Behebung von E-150, die neuen Regressionstests zu E-20, E-150, E-99 und E-51 und die neuen Messwerkzeuge gegen die Quelle nachgerechnet, 25.10.2026

**Auftrag.** Geprüft wurde, was `git log 3040aea3..HEAD -- Eudora71 tools Releases/1.0`
zeigt (Stand `48cd36fa`, Zweig `wt/pruefer-20261025c`):

* die Behebung von [E-150](../Intern/BEFUNDE.md#e-150) in `ListCtrlEx.cpp`
  (`1e85186c`),
* die neuen Tests in `UnderTestE20.cpp` und `TestSpeicherfehler.cpp`,
* Regel 1b in `pruefe-nachrichtenschleife.pl` ([E-51](../Intern/BEFUNDE.md#e-51)),
* die Messskripte `messen-e97.ps1` und `messen-e67.ps1 -Vorbereiten`,
* in `pruefstand-lauf.ps1` das geteilte Lesen und die Dauer,
* in `pruefbericht.pl` die Dauer-Tabelle (`9a4a4f90`, `718509c0`).

**Ergebnis vorweg.**

* **Die Behebung von [E-150](../Intern/BEFUNDE.md#e-150) stimmt, für alle
  Aufrufer.** Wer im Fenster „Task Status“ eine Spalte abschaltet, bringt
  Eudora nicht mehr dazu, hinter ein Feld zu schreiben. Meine Gegenvermutung
  war: Irgendwer verlässt sich darauf, dass ein Feld nach dem Löschen immer um
  eins kürzer ist. Sie trifft nicht zu. Außer `ListCtrlEx.cpp` selbst liest
  niemand die Längen, und jedes Lesen dort prüft die Grenze. Beide Rückfälle
  der Behebung selbst färbt der neue Test rot.
* **Die neuen Tests zum Ein- und Ausblenden von Spalten prüfen nur Längen und
  Schutzstreifen, nicht den Inhalt** ([K1](#k1)). Drei Rückfälle blieben grün,
  **301 von 301**. Bei einem davon wird hinter dem alten Feld gelesen, im
  Bildlisten-Block, so wie bei [E-20](../Intern/BEFUNDE.md#e-20). Bei den
  beiden anderen landet ein Spaltensymbol in der falschen Spalte.
  [PRUEFER-52 K2](PRUEFER-52.md#k2) ist damit nur zum Teil geschlossen.
* **Der neue Test zu [E-99](../Intern/BEFUNDE.md#e-99) übersieht den Fehler in
  seiner einfachsten Form** ([K2](#k2)). [E-99](../Intern/BEFUNDE.md#e-99) ist der Fehler, bei dem getippter
  Text beim Senden verloren geht. Ich habe hinter das Setzen des Merkers
  `= HasChanged();` geschrieben, also genau den alten Fehler wieder eingebaut.
  Ergebnis: **301 von 301 grün**. Ebenso grün blieb es mit `= 0` und mit
  `=FALSE` ohne Leerzeichen.
* **Die neue Regel 1b für [E-51](../Intern/BEFUNDE.md#e-51) fängt den Fehler
  nicht in der Form, in der [E-51](../Intern/BEFUNDE.md#e-51) ihn beschreibt** ([K3](#k3)). [E-51](../Intern/BEFUNDE.md#e-51) ist das
  Einfrieren beim Ziehen eines Trennbalkens. Die Schranke meldet
  `while (::GetMessage(…))` in der Ziehschleife nicht. Grund: Regel 1 lässt
  jede Schleife durch, die WM_QUIT behandelt, und die Ziehschleife tut das
  seit [E-61](../Intern/BEFUNDE.md#e-61). Gemessen über `pruefe_text`: 6 von
  8 Rückfällen ohne Meldung.
* **Den zweiten Teil von [E-100](../Intern/BEFUNDE.md#e-100) misst der neue
  Prüfstandsfall nicht** ([K4](#k4)). Gemeint sind zwei uninitialisierte Werte,
  die in die Eudora.ini gelangten. `messen-e97.ps1` liest die Eudora.ini,
  während Eudora noch läuft. Solche Werte schreibt Eudora aber erst beim
  Beenden in die Datei (am Quelltext belegt). Der Prüfbericht führt [E-100](../Intern/BEFUNDE.md#e-100)
  trotzdem als grün mit `ini=ok`.
* **Nebenfund am Rand von [E-20](../Intern/BEFUNDE.md#e-20)** ([K5](#k5)): Wenn Windows das Anlegen einer
  Spalte ablehnt (`InsertColumn` liefert -1), schreibt `InsertArr` 4 Byte
  **vor** das neue Feld. Gemessen habe ich das am herausgeschnittenen Code. Dass
  es kaum je vorkommt, ist eine Vermutung. Der Fund gehört als Fortschreibung
  zu [E-20](../Intern/BEFUNDE.md#e-20) und braucht keine neue Kennung.
* **Die Änderungen an den Werkzeugen halten.** Das geteilte Lesen in
  `pruefstand-lauf.ps1` scheitert nicht still: Liest es nichts, greift die
  vorhandene Positivprobe für Protokoll und INI. `messen-e67.ps1 -Vorbereiten`
  schreibt eine Filterdatei, die der Leser in `filtersd.cpp` versteht. Die
  Dauer-Tabelle ist an zwei Stellen etwas ungenau ([K6](#k6)).
* **Die Testsuite ist grün: 301 Tests, 301 bestanden** (gemessen, vor allen
  Proben und zuletzt nach `touch` und vollem Neubau).

**Hält ein Fund das Release 7.2.1.x auf?** **Nein**, mit einer Bedingung zu
[K4](#k4). Kein Fund ist ein Programmfehler, auf den Anwender stoßen. Nur
[K5](#k5) betrifft das Programm, und dafür muss erst ein Windows-Aufruf
scheitern. [ZIEL.md](../ZIEL.md) verlangt in Punkt 3 aber, dass jedes
Ergebnis stimmt, das im Repo steht. Solange [K4](#k4) offen ist, darf der
Prüfbericht den INI-Teil von [E-100](../Intern/BEFUNDE.md#e-100) deshalb nicht als geprüft führen. Er
gehört als Rückstand in die Release-Notizen (Punkt 4). [K1](#k1) bis
[K3](#k3) sind Lücken in Tests, die heute grün sind, und zwar zu Recht. Sie
müssen geschlossen sein, bevor eine dieser Stellen das nächste Mal als
„behoben“ gilt.

**Neue E-Kennungen: keine vergeben. E-152 und E-153 bleiben frei.** In
`Intern/BEFUNDE.md` ist nichts eingetragen. Vorher gelaufen:
`perl tools/befund-suchen.pl InsertArr` (meldet [E-20](../Intern/BEFUNDE.md#e-20))
und `… NotifyInsertedCol` (meldet [E-20](../Intern/BEFUNDE.md#e-20) und
[E-150](../Intern/BEFUNDE.md#e-150)). Deshalb schlage ich [K5](#k5) als
Fortschreibung von [E-20](../Intern/BEFUNDE.md#e-20) vor.

Jede Aussage ist gekennzeichnet: **gemessen** (Testlauf, Rückfallprobe,
Werkzeuglauf), **am Quelltext belegt** (Datei:Zeile, Stand `48cd36fa`) oder
**Vermutung**.

---

## 1. Die Behebung von E-150

**Was geändert wurde** (am Quelltext belegt). `DeleteArr` kehrt bei
`nIdx >= nLen` sofort zurück (`ListCtrlEx.cpp:1394-1395`). Der
Bildlisten-Block in `NotifyDeletedCol` läuft nur bei
`nCol < m_DispImageListArrLen` (`:1450`). Damit sind beide Stellen aus
[PRUEFER-52 K1](PRUEFER-52.md#k1) geschlossen. Das gilt auch für `nLen = 0`:
Dort ergab `nLen - 1` vorzeichenlos über vier Milliarden.

**Ist das Ergebnis richtig?** Ja (am Quelltext belegt). Liegt die gelöschte
Spalte hinter dem Feldende, gehören die vorhandenen Einträge 0 bis `nLen-1`
alle zu Spalten **vor** ihr. Keiner davon verschiebt sich. Das Feld ist also
richtig, wenn es unverändert bleibt.

**Gegenvermutung: Verlässt sich ein Aufrufer darauf, dass die Länge nach
`NotifyDeletedCol` um eins sinkt?** Widerlegt:

* `DeleteArr` hat genau einen Aufrufer, `NotifyDeletedCol` (`:1444-1446`).
  `NotifyDeletedCol` und `NotifyInsertedCol` werden nur aus
  `TaskStatusView.cpp` gerufen, an zehn Stellen (`:616-768`). Gemessen mit
  `grep` über `Eudora71/` ohne `Tests/`.
* Die vier Längen stehen zwar im öffentlichen Teil der Klasse
  (`ListCtrlEx.h:94-118`). Außerhalb von `ListCtrlEx.cpp` liest sie aber
  niemand. Das gilt auch für die abgeleiteten Klassen `MyListCtrl`
  (`AutoCompleteSearcher.h:191`) und `CResultsListCtrl` (`SearchView.h:54`).
  Gemessen mit `grep`.
* In `ListCtrlEx.cpp` prüft jedes Lesen die Grenze, bevor es zugreift:
  `GetColDisplayType` (`:849`), `GetColImageList` (`:919`),
  `GetColImageWidth` (`:929`) und `GetColImageHeight` (`:971`). Die
  Set-Funktionen vergrößern das Feld bei Bedarf (`:859`, `:885`, `:949`,
  `:991`). Für alle diese Stellen ist ein Feld, das kürzer ist als erwartet,
  der Normalfall.
* `TaskStatusView` führt die Lage der Spalten selbst (`m_pColPosition`,
  `DoDeletedCol` `:544-560`) und fragt die Längen nicht ab.

**Nebenbei, am Quelltext belegt:** Bevor `TaskStatusView` die Spalten Task
und Status löscht, ruft es `SetColImageList(…, NULL)` auf (`:639`, `:708`).
Das vergrößert das Bildlisten-Feld und das Typ-Feld bis zu dieser Spalte. Bei
diesen beiden Spalten können also nur die Felder für Höhe und Breite zu kurz
sein. Bei Persona, Details und Progress können es alle vier sein. Die
Behebung deckt beide Fälle.

**Rückfälle der Behebung selbst.** Bei jeder Probe habe ich `ListCtrlEx.cpp`
mit Perl `:raw` geändert, gebaut, die Tests gefahren und die Datei
zurückgeschrieben (`cmp` gleich):

| Probe | Rückfall | Ergebnis |
|---|---|---|
| L1 | Schranke in `DeleteArr` wirkungslos (`if (0)`) | **299/301**, „DeleteArr hinter dem Feldende“ und „NotifyDeletedCol hinter dem Feldende“ rot |
| L2 | Bedingung `&& nCol < m_DispImageListArrLen` in `NotifyDeletedCol` entfernt | **300/301**, „NotifyDeletedCol hinter dem Feldende“ rot |
| L5 | `>=` zu `>` in `DeleteArr` (der Fall `nIdx == nLen`) | **299/301**, dieselben zwei rot |

**Zur Behebung selbst gibt es keinen Fund.**

## 2. Die neuen Tests zu E-20 und E-150

**Was sie tun** (am Quelltext belegt). `Extract.ps1:437-458` schneidet jetzt
`DeleteArr`, `NotifyDeletedCol`, `NotifyInsertedCol` und die Konstante
`LVEX_DISPLAY_NORMAL` aus dem Original. `UnderTestE20.cpp` merkt sich jede
Anlage mit ihrer Größe. Nach dem Aufruf prüft es den Schutzstreifen hinter
**allen vier** Feldern. Das ist besser als zur Zeit von
[PRUEFER-52](PRUEFER-52.md#pruefer-52): Damals sah der Test nur das zuletzt
angelegte Feld. Nach jeder meiner Proben stand der geänderte Code im
passenden `generated/listctrlex_*.inc` (gemessen mit `grep -F`). Der Test lief
also wirklich gegen den Rückfall.

### <a id="k1"></a>K1 — Die Spaltentests prüfen Länge und Schutzstreifen, aber nicht, was in den Feldern steht

**Gemessen.** Drei Rückfälle, alle **301 von 301 grün**:

| Probe | Rückfall in `ListCtrlEx.cpp` | Folge im Programm (am Quelltext belegt) |
|---|---|---|
| L3 | `NotifyDeletedCol`: `pTemp[i-1] = m_DispImageListArr[i-1]` statt `[i]` (`:1458`) | Nach dem Löschen einer Spalte bleibt die Bildliste der gelöschten Spalte stehen. Die nächste Spalte zeigt fremde Symbole. Die Bildliste der letzten Spalte geht verloren und wird nie freigegeben. |
| L4 | `NotifyInsertedCol`: `nBis2 = nCol` statt `min(nCol, m_DispImageListArrLen)` (`:1427`) | Liest hinter dem alten Feld und nimmt, was dort steht, als Zeiger auf eine Bildliste. Das ist die Leseseite von [E-20](../Intern/BEFUNDE.md#e-20), genau die Probe `nBis = nIdx` aus der Commit-Nachricht von [E-20](../Intern/BEFUNDE.md#e-20). In `InsertArr` färbt der Test sie rot, hier nicht. |
| L6 | `NotifyInsertedCol`: `pTemp[i] = …` statt `pTemp[i+1] = …` (`:1434`) | Fügt man eine Spalte vor einer bestehenden ein, wird ihr Eintrag überschrieben. Die Bildlisten verrutschen um eine Spalte. |

**Warum** (am Quelltext belegt). `E20Spalte` füllt alle vier Felder mit 0
bzw. NULL (`UnderTestE20.cpp:202-207`). Ein vertauschter oder verschobener
Eintrag sieht also genauso aus wie ein richtiger. Geprüft werden nur der
Streifen und die vier Längen (`TestSpeicherfehler.cpp:68-72`, `:156-166`).
`NotifyInsertedCol` wird nur mit einer Spalte **hinter** dem Feldende
gerufen, mit `(1, 3)`. Der Fall „Einfügen vor einer bestehenden Spalte“ fehlt
ganz. Bei `InsertArr` und `DeleteArr` prüft der Test dagegen jeden Eintrag
(`E20_Pruefe`, `E150_Pruefe`). Deshalb fängt er L4 dort, in der Fassung von
`InsertArr`.

**Vorschlag:** In `E20Spalte` jedes Feld mit verschiedenen Werten füllen, etwa
`10+k` und `(CImageList*)(0x100+k)`. Nach dem Aufruf jeden Eintrag mit der
erwarteten Folge vergleichen. Dazu für Einfügen und Löschen je einen Fall
„vor einer bestehenden Spalte“, also `(3, 1)` für beide. Liest der Code dann
hinter dem Feld, fällt der Wert `0xABABABAB` aus dem Streifen auf. **Schwere:**
mittel, weil der Regressionstest von zwei kritischen Befunden eine Lücke hat.
**Hält das Release nicht auf.**

## 3. Der Quelltexttest zu E-99

**Was er prüft** (am Quelltext belegt, `TestSpeicherfehler.cpp:107-133`). Der
Test liest den Code ohne Kommentare und prüft fünf Dinge:

1. In `PgMsgView.cpp` steht das Setzen
   `if ( HasChanged() ) pComp->m_bE88AnwenderHatGetippt = TRUE;`.
2. Dieses Setzen steht vor dem Aufruf `E88OriginalEinsetzen(`.
3. Der Aufruf bekommt den Merker übergeben.
4. In `PgMsgView.cpp` steht nirgends `m_bE88AnwenderHatGetippt = FALSE`.
5. In `compmsgd.cpp` steht diese Zeichenfolge genau einmal.

Die Commit-Nachricht nennt eine Gegenprobe (HasChanged() statt Merker als
Argument), bei der der Test rot wird. Die habe ich nicht wiederholt.

### <a id="k2"></a>K2 — Der E-99-Test bleibt grün, wenn der Merker wieder aus HasChanged() kommt

**Gemessen.** Für jede Probe habe ich `PgMsgView.cpp:444` mit Perl `:raw`
geändert, die Testsuite gefahren und die Datei zurückgeschrieben (`cmp`
gleich):

| Probe | `PgMsgView.cpp:444` danach | Ergebnis |
|---|---|---|
| E1 | `… = TRUE; pComp->m_bE88AnwenderHatGetippt = HasChanged();` | **301/301 grün** |
| E2 | `… = TRUE; else pComp->m_bE88AnwenderHatGetippt = 0;` | **301/301 grün** |
| E3 | `… = TRUE; else pComp->m_bE88AnwenderHatGetippt=FALSE;` | **301/301 grün** |
| E4 | `… = TRUE; else pComp->m_bE88AnwenderHatGetippt = FALSE;` | 300/301, [E-99](../Intern/BEFUNDE.md#e-99) rot |

E1 bis E3 bauen alle drei wieder den Fehler aus
[E-99](../Intern/BEFUNDE.md#e-99) ein. Der Merker rastet nicht mehr ein. Wer
erst einen Entwurf sichert und dann sendet, durchläuft den Code zweimal. Beim
zweiten Mal kommt der Merker als FALSE an, und das Original überschreibt den
getippten Text.

**Warum** (am Quelltext belegt). Ob der Merker zurückgesetzt wird, prüft der
Test nur über die wörtliche Zeichenfolge `m_bE88AnwenderHatGetippt = FALSE`
(`:126`, `:128`). `QT_LeerraumZusammen` fasst Leerraum zusammen, fügt aber
keinen ein (`Quelltext.cpp:123-145`). Deshalb kommen `=FALSE`, `= 0`,
`= false` und jede andere Zuweisung durch. Dass der Merker nur im Konstruktor
vorbelegt wird, prüft der Test nur über die Anzahl. Wo die eine Zeile steht,
prüft er nicht.

**Vorschlag:** Statt nach `= FALSE` jede Zuweisung an den Merker zählen, also
`m_bE88AnwenderHatGetippt\s*=(?!=)`. Erlaubt sind dann genau zwei:

* in `PgMsgView.cpp` die eine mit `= TRUE` innerhalb von `if ( HasChanged() )`,
* in `compmsgd.cpp` die eine im Rumpf von `CCompMessageDoc::CCompMessageDoc`.

In allen übrigen Quellen darf es keine geben. **Schwere:** mittel, weil der
Test das einzige automatische Netz für einen Datenverlust ist. **Hält das
Release nicht auf.** [E-99](../Intern/BEFUNDE.md#e-99) ist am laufenden
Programm geprüft und bleibt behoben (am Quelltext belegt,
`PgMsgView.cpp:443-449`, `compmsgd.cpp:129`).

## 4. Regel 1b in pruefe-nachrichtenschleife.pl (E-51)

**Was sie tut** (am Quelltext belegt, `pruefe-nachrichtenschleife.pl:125-145`).
Enthält eine Funktion `PeekMessage(… PM_REMOVE …)`, sind darin zwei Aufrufe
verboten: `WaitMessage()` und `MsgWaitForMultipleObjects[Ex](…INFINITE…)`.
Die Probe in `regression-schranken.txt:93-95` setzt `::WaitMessage();` an die
Stelle, an der `OTShim.cpp:4375` wartet.

**Gemessen.** Ich habe `OTShim.cpp` nur im Speicher geändert und durch
`pruefe_text` geschickt. Das ist derselbe Weg, den der Lauf über den Baum
nimmt: Das Werkzeug lässt sich als Bibliothek laden (`:189`). An der
Quelldatei habe ich nichts geändert.

| Probe | Rückfall in der Ziehschleife `SECDockBar::Splitter::Track` | Meldungen |
|---|---|---|
| 0 | unverändert | 0 |
| 1 | `::WaitMessage();` (die Probe aus `regression-schranken.txt`) | **1** |
| 2 | `MsgWaitForMultipleObjects(…, INFINITE, …)` | **1** |
| 3 | `const DWORD dwWarte = INFINITE;`, dann `…, dwWarte, …` | 0 |
| 4 | `0xFFFFFFFF` statt `INFINITE` | 0 |
| 5 | Warten und `PeekMessage` ersetzt durch `while (!bFertig && ::GetMessage(&msg, NULL, 0, 0))` | **0** |
| 6 | dasselbe mit `if (::GetMessage(…))` in der äußeren Schleife | 0 |
| 7 | `::WaitForSingleObject(hEreignis, INFINITE);` | 0 |
| 8 | das Warten in eine Hilfsfunktion `ZiehWarten()` ausgelagert | 0 |

Ein Lauf von `perl tools/pruefe-nachrichtenschleife.pl` über den Baum gab
Rückgabe 0 (gemessen).

### <a id="k3"></a>K3 — Die E-51-Schranke lässt die Form durch, in der E-51 entstand

**Was passiert** (gemessen, Probe 5). [E-51](../Intern/BEFUNDE.md#e-51) war
`while(::GetMessage(...))` in der Ziehschleife. So steht es in
`OTShim.cpp:4352` und im Kopf der Schranke (`:13-17`). Genau diese Form
bleibt nach dem Rückfall ohne Meldung.

**Warum** (am Quelltext belegt). Regel 1 (`:106-123`) lässt eine
`while (… GetMessage(`-Schleife durch, sobald die Funktion irgendwo WM_QUIT
erwähnt. Gedacht war das für die Wartestellen der Trident-Anzeige. Die
Ziehschleife behandelt WM_QUIT seit [E-61](../Intern/BEFUNDE.md#e-61)
(`OTShim.cpp:4400-4406`). Die Behebung von [E-61](../Intern/BEFUNDE.md#e-61) öffnet damit dem Rückfall von
[E-51](../Intern/BEFUNDE.md#e-51) die Tür. Regel 1b sieht nur Funktionen mit `PeekMessage`, und nach diesem
Rückfall gibt es dort keins mehr. Bei [E-51](../Intern/BEFUNDE.md#e-51) ging es aber nie um WM_QUIT. Es
ging darum, dass kein WM_LBUTTONUP kommt. Die Ausnahme für Trident passt auf
diesen Fall nicht.

**Dazu, am Quelltext belegt:** Der Kopf der Schranke verweist auf Gegentests
in `tools/pruefe-nachrichtenschleife-tests.pl` (`:40-41`). Diese Datei gibt es
nicht, und es hat sie nie gegeben (gemessen: `git log --all` ohne Treffer).
Gegengetestet wird Regel 1b nur über die eine Zeile in
`regression-schranken.txt`.

**Vorschlag:** Regel 1 nicht pauschal freigeben, sobald WM_QUIT vorkommt,
sondern nur für die bekannten Stellen, als Liste von Funktionsnamen. Eine
andere Möglichkeit: Eine Funktion, die `SetCapture` aufruft, darf
`GetMessage` überhaupt nicht benutzen. Die Proben 3 bis 6 kommen in
`regression-schranken.txt`, sobald die Regel sie fängt. Probe 7 gehört nicht
zur Klasse „wartet auf eine Nachricht“. Sie steht hier nur, damit die Grenze
bekannt ist. **Schwere:** mittel, denn die Schranke ist für
[E-51](../Intern/BEFUNDE.md#e-51) als Regressionstest eingetragen. **Hält das
Release nicht auf.**

## 5. Die neuen Mess- und Prüfstandswerkzeuge (nur am Quelltext)

Wie beauftragt habe ich die Werkzeuge nicht ausgeführt und keinen Prüfstand
angefasst.

### <a id="k4"></a>K4 — messen-e97.ps1 prüft die INI-Werte aus E-100, bevor Eudora sie in die Datei schreibt

**Am Quelltext belegt.** Teil 3 des Skripts liest `Eudora.ini`
(`messen-e97.ps1:253-261`), während Eudora noch läuft. Danach schreibt das
Skript nur noch die Ergebniszeile. Beendet wird Eudora erst von
`testlauf.ps1`. Die beiden Werte setzen die Aufrufer mit `SetIniShort`
(`tocview.cpp:3087-3088`, `compmsgd.cpp:3375-3376`). `SetIniShort` ruft
`SetIniString`. Das setzt nur den Wert im Zwischenspeicher und die Marke
`IES_DIRTY` (`rs.cpp:643-646`). In die Datei kommt der Wert erst mit
`FlushINIFile` (`rs.cpp:1189-1266`). Aufgerufen wird das an diesen Stellen:

* beim Beenden (`IniStringCleanUp`, `rs.cpp:1435`),
* beim OK im Optionsfenster (`settings.cpp:346`, `:479`, `:1518`),
* beim Wechsel der Persönlichkeit (`persona.cpp:194`),
* an einzelnen Stellen beim Start (`mainfrm.cpp:2445`, `eudora.cpp:484`,
  `:1671`).

Keiner dieser Wege liegt zwischen „Speichern unter“ und dem Lesen im Skript.
Diese letzte Aussage ist eine **Vermutung**: Der Prüfstand hat eine
Persönlichkeit, und das Skript öffnet keine Optionen.

**Folge.** Nach dem Lauf stünde ein uninitialisierter Wert in der Datei. Zu
dem Zeitpunkt, an dem das Skript liest, steht er dort noch nicht. Deshalb
meldet das Skript `ini=ok` auch dann, wenn der Fehler da ist. Im Kopf des
Skripts steht als Messung „beide fehlen“ (`:24-27`). Erklärt wird das damit,
dass Eudora nur Werte schreibt, die vom Vorgabewert abweichen. Näher liegt
eine andere Erklärung: Zu dem Zeitpunkt ist noch gar nichts geschrieben.
Gemessen habe ich das nicht, denn Eudora habe ich nicht gestartet. Teil 1 und
Teil 2 (Dialog, Absturz, Datei) sind davon nicht betroffen.

**Vorschlag:** Die INI erst nach dem Beenden prüfen, also in
`pruefstand-lauf.ps1`. Das liest die INI nach dem Lauf schon (`:252`) und hat
dafür eine Positivprobe (`:282-286`). Ein eigener Fall `E-100b` mit Quelle
`ini` wäre eine Möglichkeit. `DarfNicht` sucht aber nur eine feste
Zeichenfolge, deshalb ist ein kleiner eigener Prüfschritt besser. Dazu gehört
eine Gegenprobe: Im Konstruktor von `CSaveAsDialog` die beiden Zeilen
`SaveAsDialog.cpp:48-49` entfernen, dann muss der Fall rot werden. Ohne diese
Gegenprobe weiß niemand, ob der Fehler auf dem heutigen Weg durch den Dialog
überhaupt einen fremden Wert erzeugt. **Schwere:** wichtig (Prüfstand). Der
Prüfbericht bescheinigt einen kritischen Befund, von dem nur die Hälfte
gemessen wird. **Hält das Release nur in einem Punkt auf:** Bis zur Behebung
darf der Prüfbericht diesen Teil nicht als geprüft führen
([ZIEL.md](../ZIEL.md), Punkt 3).

**Sonst an `messen-e97.ps1`, am Quelltext belegt, ohne Fund:**

* Die Pfadschranke steht vor jeder Wirkung (`:42-43`).
* `-Vorbereiten` löscht die alte Ergebnisdatei (`:55`), und
  `pruefstand-lauf.ps1:204` ruft es vor jedem Start auf.
* Stürzt Eudora beim Aufbau des Dialogs ab, ergibt das `dialog=0` bzw.
  `lebt=0` und damit Rot.
* Das Skript schickt nur Botschaften an gemessene Handles, keinen Tastendruck.
* Eine kleine Unschärfe: Den Prozess sucht das Skript mit
  `StartsWith($Pfadfilter)` (`:168`), also ohne abschließenden `\`. Ein
  Prüfstand `C:\Temp\E97x` würde mitgezählt. Heute gibt es keinen (gemessen,
  `pruefstand-faelle.txt`).

### messen-e67.ps1 -Vorbereiten — kein Fund

Am Quelltext belegt:

* Die erste Zeile `3` ist die Versionsnummer, die `filtersd.cpp:3102-3111`
  liest. Sie entspricht `FiltVersion` (`filtersd.h:343`). Deshalb erscheint
  kein Dialog zur Aktualisierung (`filtersd.cpp:3518-3519`).
* `rule`, `incoming`, `header`, `verb less`, `value` und `conjunction ignore`
  sind die Schlüsselwörter aus `EudoraRes.rc:9719-9763` und `:10566-10569`.
* Den Kopf `«Junk Score»` schreibt das Skript in Latin-1, so wie er in der
  .rc steht.
* Die Pfadschranke steht vor der Wirkung.
* Der Fall in `pruefstand-faelle.txt:243` verlangt die Spurmarke. Fehlt sie,
  weil das Filterfenster nicht aufging, wird der Fall rot.

### pruefstand-lauf.ps1 — kein Fund

Am Quelltext belegt:

* `LiesGeteilt` (`:242-251`) gibt nach zehn Fehlversuchen `''` zurück. Das
  bleibt nicht still. Für das Protokoll greift die Positivprobe „ohne
  Protokoll hat nichts gemessen“ (`:254`). Für die INI greift die Probe
  `:282-286` („keine Eudora.ini nach dem Lauf“, FEHL).
* Bei Rot hängt die Anzeige die letzten vier Zeilen der Messausgabe an
  (`:296-299`). Am Urteil ändert das nichts.
* Die Dauer wird nur bei einem vollen Lauf (ohne `-Nur`) geschrieben (`:379`).
  Sie kommt in eine eigene Datei, das Ergebnisbuch bleibt unverändert.

### <a id="k6"></a>K6 — Die Dauer-Tabelle im Prüfbericht unterschätzt den Bau und nennt eine nachgetragene Zahl „gemessen“

1. **Gemessen:** Der Prüfbericht nennt „Unit-Tests bauen und fahren |
   0 min 07 s“ (`Releases/PRUEFBERICHT.md:14`). Das war ein Bau, bei dem
   nichts zu übersetzen war. Ein voller Neubau der Testsammlung
   (`/t:Rebuild`) samt Lauf dauerte in meinem Arbeitsbaum **18 s**. Mit
   `--ohne-bau` misst `pruefbericht.pl:95-141` gar keinen Bau, die Zeile
   heißt aber weiter „bauen und fahren“.
2. **Am Quelltext belegt:** `Intern/pruefstand-dauer.txt` trägt den Vermerk
   „nachgetragen aus den Zeitstempeln der Laufausgabe … vor dem Einbau der
   Messung“. In der Spalte „gemessen“ schreibt der Bericht trotzdem „voller
   Lauf“. `pruefbericht.pl:303-304` liest nur die Wertzeilen und lässt den
   Vermerk fallen.

**Vorschlag:** Die Zeile je nach `$ohne_bau` benennen, etwa „nur gefahren“.
Einen Vermerk aus der Dauerdatei in die Spalte „gemessen“ übernehmen.
**Schwere:** niedrig. **Hält das Release nicht auf.**

## 6. Nebenfund: InsertArr mit nIdx = -1

### <a id="k5"></a>K5 — Schlägt InsertColumn fehl, schreibt InsertArr 4 Byte vor das neue Feld (Fortschreibung E-20)

**Gemessen** am herausgeschnittenen `InsertArr`
(`generated/listctrlex_e20.inc`, übersetzt mit `cl /Zc:forScope-`, Win32).
Der Prüfling lag im eigenen Verzeichnis, nicht in der Testsuite, und hatte
einen Schutzstreifen **vor** und hinter dem Feld. Aufruf mit `nLen = 2` und
`nIdx = (unsigned) -1`. Ergebnis: neues Feld 12 Byte, **vorn 4 Byte
verändert**, hinten nichts, `nLen` danach 3.

**Warum** (am Quelltext belegt). `nIdx + 1` läuft über und wird 0. Damit
gilt `nNeu = nLen + 1` (`ListCtrlEx.cpp:1361`). `pTemp[nIdx]` (`:1373`) ist
auf 32 Bit dieselbe Stelle wie `pTemp - 1`. `NotifyInsertedCol` rechnet im
Bildlisten-Block genauso (`:1420-1431`). Die Behebung von
[E-20](../Intern/BEFUNDE.md#e-20) prüft `nIdx > nLen`, aber nicht den
Überlauf. `DeleteArr` ist seit [E-150](../Intern/BEFUNDE.md#e-150) dagegen geschützt (`nIdx >= nLen`).

**Wie Eudora dorthin käme** (am Quelltext belegt). `TaskStatusView.cpp:615`
gibt den Rückgabewert von `InsertColumn` ungeprüft an `NotifyInsertedCol(idx)`
weiter (`:616`, ebenso `:655`, `:683`, `:724`, `:752`).
`CListCtrl::InsertColumn` liefert -1, wenn die Liste das Einfügen ablehnt.
Wann das geschieht, ist eine **Vermutung**: praktisch nur bei Speichermangel.
Gäbe es das Fenster noch nicht, käme von `SendMessage` an NULL eine 0 zurück,
keine -1.

**Vorschlag:** In `UpdateColumns` bei `idx < 0` die Spalte nicht anmelden.
Oder in `InsertArr` und `NotifyInsertedCol` bei `nIdx == (unsigned)-1` sofort
zurückkehren. Das gehört **als Fortschreibung zu
[E-20](../Intern/BEFUNDE.md#e-20)**, weil Ort und Rechnung dieselben sind
(`befund-suchen.pl InsertArr` meldet [E-20](../Intern/BEFUNDE.md#e-20)). **Schwere:** niedrig. Es ist zwar
ein Speicherfehler, tritt aber nur nach einem gescheiterten Windows-Aufruf
auf; der Code stammt im Original von QUALCOMM. **Hält das Release nicht auf.**

---

## 7. Stand der bekannten Funde aus PRUEFER-52

Seit `3040aea3` hat kein Commit `pruefe-regressionstest.pl`,
`haken-pr-lektor.pl` oder `paket-bauen.ps1` geändert (gemessen,
`git log 3040aea3..HEAD -- <Dateien>`). `pruefbericht.pl` bekam nur die
Dauer-Tabelle.

| Fund | Kurz | Stand |
|---|---|---|
| [PRUEFER-52 K1](PRUEFER-52.md#k1) | [E-150](../Intern/BEFUNDE.md#e-150) | **behoben** (`1e85186c`), siehe Abschnitt 1 |
| [PRUEFER-52 K2](PRUEFER-52.md#k2) | Der E-20-Test bewacht `NotifyInsertedCol` nicht | **teilweise geschlossen**: Schreiben hinter das Feld wird rot, Lesen und Verschieben nicht ([K1](#k1)) |
| [PRUEFER-52 K3](PRUEFER-52.md#k3) | `pruefe-regressionstest.pl` sieht eine rote zweite Schrankenprobe nicht | **offen**: `:130` liest weiter `/^(\S+)/` |
| [PRUEFER-52 K4](PRUEFER-52.md#k4) | Ohne Release-Bau gilt die Fassungsnummer | **offen**: `pruefbericht.pl:211-212` unverändert |
| [PRUEFER-52 K5](PRUEFER-52.md#k5) | `--vergleich` gibt bei weggefallenen Tests 0 zurück | **offen**: `pruefbericht.pl:268` unverändert |
| [PRUEFER-52 K6](PRUEFER-52.md#k6) | Der PR-Haken lässt `gh pr new` u. a. durch | **offen**: `haken-pr-lektor.pl:41` unverändert |

Die Funde aus [PRUEFER-51](PRUEFER-51.md#pruefer-51), die [PRUEFER-52](PRUEFER-52.md#pruefer-52) in
Abschnitt 6 nennt, habe ich nicht neu nachgesehen.

## Was gelaufen ist

* `Eudora71/Tests/RunTests.cmd` im Arbeitsbaum `Eudora7.2-wt-pruefer`:
  **301 Tests, 301 bestanden**, Rückgabe 0, vor allen Proben.
* Zum Schluss nach dem Zurückschreiben `touch Eudora71/Eudora/ListCtrlEx.cpp`
  und ein voller Neubau (`/t:Rebuild`, 18 s): wieder **301 von 301**. Die Zahl
  301 blieb in jedem Lauf gleich, auch in jeder Probe. Danach stand der
  zurückgeschriebene Code wieder in `generated/listctrlex_e150*.inc` und
  `listctrlex_e20b.inc` (gemessen, `grep -c`).
* Rückfallproben mit Bau: sechs an `ListCtrlEx.cpp` (L1–L6) und vier an
  `PgMsgView.cpp` (E1–E4). `PgMsgView.cpp` liest der Test zur Laufzeit, sie
  wird nicht übersetzt.
* Jede Probe mit Perl `:raw` ersetzt, mit genau einem Treffer, und danach mit
  `cp -p` aus der Kopie zurückgeholt. `cmp` gleich nach jeder Probe und am
  Ende. `git status` danach ohne Änderung an eingecheckten Dateien.
* `pruefe-nachrichtenschleife.pl`: neun Proben über `pruefe_text` im Speicher
  und ein Lauf über den Baum (Rückgabe 0).
* Prüfling für `InsertArr` mit `cl` (VS 2022, `vcvars32.bat`) übersetzt und
  gefahren.
* Alle Hilfsdateien lagen in `pruef-tmp/` im Arbeitsbaum und sind gelöscht.
* Nicht getan: Eudora gebaut oder gestartet, ein Fenster geöffnet,
  `pruefstand-lauf.ps1`, `messen-e97.ps1`, `messen-e67.ps1` oder
  `pruefbericht.pl` ausgeführt, etwas unter `C:\Temp` angefasst.
* Der Commit-Haken verlangte zwei Dinge: die vom Hauptagenten gespiegelten
  Dateien in `Arbeitsweise/` und eine neu erzeugte Lehrentabelle
  (`perl tools/lehren-uebersicht.pl -schreiben`). Beides steht in einem
  eigenen Commits (`6abd7d4c`, `410e0819`), getrennt von diesem Bericht.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Release 7.2.1.x auf? |
|---|---|---|---|
| [K1](#k1) | Die Tests zum Ein- und Ausblenden einer Spalte prüfen nur Längen und Schutzstreifen. Drei Rückfälle blieben 301/301 grün: einmal Lesen hinter dem alten Feld (wie bei [E-20](../Intern/BEFUNDE.md#e-20)), zweimal ein Symbol in der falschen Spalte | mittel | nein |
| [K2](#k2) | Der Test zu [E-99](../Intern/BEFUNDE.md#e-99) (getippter Text geht verloren) bleibt grün, wenn der Merker wieder aus `HasChanged()` kommt oder mit `= 0` bzw. `=FALSE` zurückgesetzt wird | mittel | nein |
| [K3](#k3) | Die Schranke zu [E-51](../Intern/BEFUNDE.md#e-51) (Einfrieren beim Ziehen) lässt `while (GetMessage)` in der Ziehschleife durch, also die Form, in der [E-51](../Intern/BEFUNDE.md#e-51) entstand. 6 von 8 Rückfällen ohne Meldung. Die genannte Testdatei gibt es nicht | mittel | nein |
| [K4](#k4) | Der Prüfstandsfall zu [E-100](../Intern/BEFUNDE.md#e-100) liest die INI, bevor Eudora sie schreibt. Ein falscher Wert in den Einstellungen bliebe unsichtbar, der Bericht meldet trotzdem `ini=ok` | wichtig (Prüfstand) | nur in einem Punkt: Bis zur Behebung darf der Prüfbericht den INI-Teil von [E-100](../Intern/BEFUNDE.md#e-100) nicht als geprüft führen |
| [K5](#k5) | Lehnt Windows das Anlegen einer Spalte in „Task Status“ ab, schreibt Eudora 4 Byte vor ein Feld (gemessen am Ausschnitt). Kommt praktisch nur bei Speichermangel vor; Fortschreibung von [E-20](../Intern/BEFUNDE.md#e-20) | niedrig | nein |
| [K6](#k6) | Die Dauer-Tabelle im Prüfbericht zeigt 7 s für einen Bau, bei dem nichts übersetzt wurde (voller Neubau: 18 s), und nennt eine nachgetragene Prüfstandsdauer „gemessen“ | niedrig | nein |
| [PRUEFER-52 K3–K6](PRUEFER-52.md#k3) | bekannt, seit `3040aea3` unverändert offen | wie dort | nein |

**Vergeben: keine Kennung. Frei: E-152, E-153.** In `Intern/BEFUNDE.md` ist
nichts eingetragen.
