# <a id="pruefer-57"></a>PRUEFER-57 — E-137 in `CMainFrame::OnCommand`, nachgerechnet gegen PRUEFER-56 K1, 25.10.2026

**Auftrag.** Kurzlauf. Geprüft wurde nur, was seit `03480db6` in `Eudora71/`
dazukam (`78f2ad2a`): Die Abfangung von [E-137](../Intern/BEFUNDE.md#e-137) sitzt jetzt am Anfang von
`CMainFrame::OnCommand` (`Eudora71/Eudora/mainfrm.cpp`). Die Fassung in
`OnCmdMsg` ist entfernt. Der Test `Eudora71/Tests/TestE137.cpp` ist neu
geschrieben. Eudora wurde weder gebaut noch gestartet. Die Testsuite lief nur in
meinem Arbeitsbaum. Die MFC-Stellen sind in der Quelle nachgelesen, die auf
diesem Rechner liegt (`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Die neue Fassung hält gegen [PRUEFER-56 K1](PRUEFER-56.md#k1).** Das ist am Quelltext belegt, nicht
  gemessen. Ein Strg-W kommt als `WM_COMMAND` beim Hauptfenster an, auch wenn ein
  Postfach offen ist. Dort läuft als Erstes `CMainFrame::OnCommand`. Der
  Abfangblock (`mainfrm.cpp:3433`) steht vor der Weitergabe an das
  Wazoo-Fenster (`:3447`) und vor `QCWorkbook::OnCommand` (`:3485`). Erst
  danach würde das aktive MDI-Fenster den Befehl bekommen. Weder das Dokument
  der Filter-Leiste noch das Postfach `In` kommt also vorher dran.
* **Die Suchleiste und das Verfassen-Fenster sind nicht betroffen** (am
  Quelltext belegt). `CSearchBar` ist eine Werkzeugleiste (`SearchBar.h:112`),
  keine `CWazooBar`. Verfassen-Fenster sind MDI-Fenster. In beiden Fällen findet
  `GetWazooBarWithFocus` keine Leiste (`WazooBarMgr.cpp:1019-1038`). Strg-W
  nimmt dann seinen alten Weg.
* **Vier Funde, alle niedrig.** Keiner davon hält das Release 7.2.1.x auf.
  [K1](#k1): Bei manchen Registern bewirkt Strg-W vermutlich weiterhin gar
  nichts, wenn kein Postfach offen ist. [K2](#k2): Auch Datei → Schließen aus
  dem Menü versteckt jetzt die Leiste, und mit gedrückter Umschalttaste werden
  nicht mehr alle Fenster geschlossen. [K3](#k3): In der Werbeleiste schluckt die
  Abfangung das Strg-W. [K4](#k4) (gemessen): Drei Rückfälle bleiben im Test
  grün.
* **[E-137](../Intern/BEFUNDE.md#e-137) ist nach dem Quelltext jetzt plausibel behoben.** Als behoben gilt
  es aber erst, wenn Gregor es am laufenden Programm gesehen hat. Prüfen sollte
  er zwei Fälle: die angedockte Filter-Leiste und das Postfach-Register, während
  `In` offen ist.

**Testsuite** (gemessen, in meinem Baum): 302 Tests, 302 bestanden. Das galt
vorher und nach allen Rückfallproben. `mainfrm.cpp` war nach jeder Probe
byte-gleich zurück (SHA-1 verglichen), danach `touch`.

| Fund | Was passiert | Schwere | Hält das Release 7.2.1.x auf? |
|---|---|---|---|
| [K1](#k1) | Strg-W in z. B. dem Postfach-Register, ohne offenes Postfach: Der Menüpunkt ist gesperrt, also kommt kein Befehl an, und die Leiste bleibt offen. Das war schon im Original so. | niedrig | nein |
| [K2](#k2) | Datei → Schließen oder der Knopf „Close Window“, während eine Leiste den Schwerpunkt hat, versteckt die Leiste statt das Postfach zu schließen. Mit der Umschalttaste wird nicht mehr „alle schließen“ ausgeführt. | niedrig | nein |
| [K3](#k3) | Hat die Werbeleiste den Schwerpunkt (nur im Werbemodus), geschieht bei Strg-W nichts, und der Befehl ist verschluckt. | niedrig | nein |
| [K4](#k4) | Der Test bleibt bei `#if 0` um den Block, bei einer vorgeschalteten Weitergabe und bei einer geänderten Berechnung von `wCommandID` grün. | niedrig | nein |

## Weg eines Strg-W (am Quelltext belegt)

1. Strg+W ist auf `ID_FILE_CLOSE` gelegt (`EudoraRes.rc:364`). Die Tastenbotschaft
   geht durch die `PreTranslateMessage`-Kette bis zum Hauptfenster.
   `CMDIFrameWnd::PreTranslateMessage` lässt zuerst das aktive MDI-Fenster
   übersetzen. Das tut es aber mit `::TranslateAccelerator(GetMDIFrame()->m_hWnd, ...)`
   (MFC `winmdi.cpp:465`), also ebenfalls zum Hauptfenster hin. Sonst übersetzt
   das Hauptfenster selbst (`winmdi.cpp:210`). In beiden Fällen bekommt
   `CMainFrame` das `WM_COMMAND`.
2. `CWnd::OnWndMsg` ruft das virtuelle `OnCommand` auf, also
   `CMainFrame::OnCommand`. Bei einem Tastenkürzel ist `HIWORD(wParam)` gleich 1.
   Dann wird `wCommandID` aus `LOWORD` genommen (`mainfrm.cpp:3401`) und ist
   `ID_FILE_CLOSE`.
3. Der Block (`:3433-3445`) versteckt die Leiste mit dem Schwerpunkt per
   `ID_SEC_HIDE`, gibt den Schwerpunkt an das aktive MDI-Fenster und kehrt mit
   `TRUE` zurück. Zur Wazoo-Weitergabe (`:3447`) und zum MDI-Fenster
   (`QCWorkbook::OnCommand`, `:3485`) kommt es nicht mehr.

Eine schwebende Leiste liegt in einem eigenen Popup-Rahmen. `IsChild` steigt
vom Schwerpunkt nur über Kindfenster auf und erreicht die Leiste trotzdem. Den
Rahmen braucht es dafür nicht. Die Fassung schließt den schwebenden Fall also
mit ein. Andere Absender von `ID_FILE_CLOSE` gibt es im Quelltext nicht. Gesucht
wurde nach `ID_FILE_CLOSE` in `*.cpp/*.h/*.rc`. Es gibt nur die Behandler in
`doc.cpp:109`, `msgdoc.cpp:510` und `workbook.cpp:245`.

## <a id="k1"></a>K1 — Strg-W kommt bei gesperrtem Menüpunkt gar nicht an

**Was passiert** (MFC-Seite am Quelltext belegt, Windows-Seite Vermutung).
Bevor `TranslateAccelerator` einen Befehl schickt, der einem Menüpunkt
entspricht, fragt es den Menüzustand ab. MFC sperrt dabei jeden Punkt, für den
auf dem Weg kein Behandler liegt (`m_bAutoMenuEnable`, `winfrm.cpp:93`,
`:1519`, in Eudora nicht abgeschaltet, `mainfrm.cpp:743`). `ID_FILE_CLOSE`
behandeln nur `CDoc`, `CMessageDoc` und `QCControlBarWorksheet`. Ist kein
Postfach offen und hat ein Register ohne Dokument den Schwerpunkt, etwa die
Postfach-Liste, dann ist „Close“ gesperrt. Nach dem dokumentierten Verhalten
von `TranslateAccelerator` geht dann kein `WM_COMMAND` hinaus. Das ist nicht
gemessen. Der Abfangblock wird nicht erreicht, und die Leiste bleibt offen.

Die erste Fassung in `OnCmdMsg` hatte für diesen Fall eine Freigabe über
`CN_UPDATE_COMMAND_UI`. Sie ist mit dem Umzug ersatzlos entfallen. Gregors
Fall, die Filter-Leiste, ist davon nicht betroffen: Ihr Dokument hat einen
Behandler, also bleibt der Punkt frei. **Kein Rückschritt:** Im Original
geschah in diesem Fall ebenfalls nichts. **Abhilfe**, falls gewünscht: in
`OnCmdMsg` für `ID_FILE_CLOSE`/`CN_UPDATE_COMMAND_UI` den Punkt freigeben,
wenn `GetWazooBarWithFocus()` eine sichtbare Leiste liefert. Das ist nur die
Freigabe aus der ersten Fassung, ohne den Befehlsteil.

## <a id="k2"></a>K2 — Menü und Knopf folgen jetzt ebenfalls dem Schwerpunkt

**Was passiert** (am Quelltext belegt). Der Block unterscheidet nicht, woher
der Befehl kommt: Menü (`HIWORD` 0), Tastenkürzel (1) oder Werkzeugknopf
(`EudoraRes.rc:6397`, `:6465`). Ein Menüklick nimmt der Leiste den Schwerpunkt
nicht. Das ist eine Vermutung, ebenso für den Knopf. Wer also in die
Postfach-Liste klickt und dann Datei → Schließen wählt, versteckt die Leiste und
nicht das offene Postfach. Bisher schloss das das Postfach, bei der Filter-Leiste
sogar ganz Eudora.

Dazu kommt die Umschalttaste. Laut Hilfetext schließt Umschalt + Close alle
Fenster (`EudoraRes.rc:8839`; `doc.cpp:139-140`, `msgdoc.cpp:1117-1118`). Mit
dem Schwerpunkt in einer Leiste versteckt sie jetzt nur die Leiste. Ob das
gewollt ist („das Fenster mit dem Schwerpunkt schließt“), entscheidet Gregor.
Datenverlust entsteht nicht.

## <a id="k3"></a>K3 — In der Werbeleiste wird Strg-W verschluckt

**Was passiert** (am Quelltext belegt). `CAdWazooBar` steht in derselben Liste
(`WazooBarMgr.cpp:166-169`) und leitet `ID_SEC_HIDE` auf `OnDisabled` um
(`AdWazooBar.cpp:46`). Hat sie den Schwerpunkt, gibt der Block `TRUE` zurück,
ohne dass etwas geschieht. Das betrifft nur den Werbemodus
(`AdWazooBar.cpp:268`). Abhilfe wäre, den Block für `CAdWazooBar` zu überspringen
(`IsKindOf`).

## <a id="k4"></a>K4 — Was der Test nicht sieht (gemessen)

Jede Probe wurde in meinem Baum byte-genau eingesetzt (Perl, `:raw`). Danach
lief die Testsuite, die Datei kam zurück (SHA-1 gleich) und bekam ein `touch`.

| Probe | Änderung | Ergebnis |
|---|---|---|
| P4 (Positivprobe) | `ID_SEC_HIDE` → `ID_SEC_MDIFLOAT` | **rot**, 301/302, „fehlt oder getrennt: …PostMessage…“ |
| P1 | `#if 0` … `#endif` um den ganzen Block | grün, 302/302 |
| P2 | davor `if (wCommandID == ID_FILE_CLOSE && MDIGetActive()) return QCWorkbook::OnCommand(wParam, lParam);` | grün, 302/302 |
| P3 | `if (wCommandID <= 1)` → `<= 0` (Tastenkürzel liefern dann `wCommandID` = 1) | grün, 302/302 |

P2 ist genau der Fehler aus [PRUEFER-56 K1](PRUEFER-56.md#k1), nur an anderer Stelle: Die Abfangung
steht im Text, wird aber übergangen. Der Test prüft die Lage nur gegen die
Wazoo-Weitergabe, nicht gegen jeden früheren Ausstieg. Abhilfe: Zwischen
Funktionsanfang und Block darf kein `return` stehen, keine Zeile mit `#if`, und
die Zeile `if (wCommandID <= 1)` muss erhalten bleiben. P3 würde allerdings
auch jedes andere Tastenkürzel in Wazoo-Fenstern stören und sofort auffallen.
