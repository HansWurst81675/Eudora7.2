# <a id="pruefer-67"></a>PRUEFER-67 — Prüfung der Regressionstests zu E-15/19/21, E-28, E-57/58/75, E-86, E-104/115 und M-1, 30.10.2026

**Auftrag.** Alles, was seit `022e115` unter `Eudora71`, `tools` und
`Releases/1.0` dazukam (`git log 022e115..HEAD`, Stand `de8cdefd`). Schwerpunkt
sind die sechs neuen Testdateien `TestZusicherungen.cpp`, `TestE28.cpp`,
`TestE57E58E75.cpp`, `TestE86.cpp`, `TestE104E115.cpp` und `TestM1.cpp`. Die
Frage war nicht, ob ein Test rot wird, wenn man die Behebung an der Hauptstelle
zurücknimmt. Das hat der Hauptagent schon gemessen. Die Frage war: Bleibt ein
Test grün, wenn derselbe Fehler **auf einem Nebenweg** zurückkommt, also in
anderer Schreibweise, an einer anderen Aufrufstelle oder an einer Stelle, die
der Test gar nicht liest?

Eudora wurde weder gebaut noch gestartet. Gebaut und gefahren habe ich nur die
Testsuite im Arbeitsbaum `Eudora7.2-wt-pruefer` (`perl tools/pruefe-testbau.pl`,
dann `EudoraTests.exe` direkt). Grundlauf: **337 Tests, 337 bestanden**
(gemessen). Jede Gegenprobe unten habe ich vorübergehend per Perl byte-genau
eingesetzt und danach mit `git checkout --` zurückgenommen. `git status` war
danach jedes Mal leer.

**Ergebnis vorweg.**

* **Die Behebung von [E-28](../Intern/BEFUNDE.md#e-28) liest freigegebenen
  Speicher** ([K1](#k1)). Das passiert, wenn man eine neue Nachricht öffnet und
  sie schließt, ohne sie je gespeichert zu haben. Dann löscht
  `CCompMessageFrame::OnDestroy` die Zusammenfassung. Gleich danach liest
  `CMessageFrame::OnDestroy` über den neuen Rückzeiger `m_pSumBackPtr` aus genau
  diesem gelöschten Objekt (am Quelltext belegt). Das steckt in jedem Paket seit
  7.2.0.12. Ein Absturz ist unwahrscheinlich, weil nur gelesen und nur bei
  Gleichheit geschrieben wird (Vermutung). Der Test sieht davon nichts.
  Vorschlag: neue Kennung [E-176](../Intern/BEFUNDE.md#e-176).
* **[E-19](../Intern/BEFUNDE.md#e-19) ist nur zu einem Fünftel behoben**
  ([K2](#k2)). Das `ASSERT(0)` im Reparaturzweig ist nur für das In-Postfach
  weg. Für Out, Trash und Junk und für den Zweig „normales Postfach mit
  Systemnamen“ steht es noch viermal da (`tocdoc.cpp:680, 700, 725, 751`, am
  Quelltext belegt). Der Test liest nur den In-Zweig und bleibt grün. Folgen hat
  das nur im Debug-Bau, dort als Dialog.
* **Zu [E-15](../Intern/BEFUNDE.md#e-15) steht dieselbe Zusicherung eine Ebene
  höher noch einmal** ([K3](#k3)). In `settings.cpp:1490` steht
  `ASSERT(QCGetTaskStatusView());`. Sie feuert, wenn man die Spalten der
  Aufgabenanzeige ändert, solange dieses Fenster in der Sitzung noch nie offen
  war (am Quelltext belegt, nicht gemessen). Auch das gilt nur im Debug-Bau.
* **Drei Tests bleiben bei einer anderen Schreibweise grün** ([K4](#k4), alles
  gemessen):
  `ASSERT (…)` mit Leerzeichen und `_ASSERTE(…)` bei [E-15](../Intern/BEFUNDE.md#e-15);
  `UnwrapText( CopyText )` ohne `::` bei [E-104](../Intern/BEFUNDE.md#e-104), eine Schreibweise, die in
  derselben Datei schon vorkommt; eine Bedingung vor der `X-UA-Compatible`-Zeile
  bei [E-86](../Intern/BEFUNDE.md#e-86).
  Außerdem bleibt die Behebung von [PRUEFER-66](PRUEFER-66.md#pruefer-66) K3 bei einem PowerShell-Blockkommentar
  `<# … #>` grün (gemessen an [S-8](../Intern/BEFUNDE.md#s-8)).
* **Ohne Befund geprüft:** [E-21](../Intern/BEFUNDE.md#e-21), [E-57](../Intern/BEFUNDE.md#e-57), [E-58](../Intern/BEFUNDE.md#e-58), [E-75](../Intern/BEFUNDE.md#e-75), [E-115](../Intern/BEFUNDE.md#e-115) und [M-1](../Intern/BEFUNDE.md#m-1). Für jeden
  dieser Tests habe ich nach einem Nebenweg gesucht und keinen gefunden. Die
  Einzelheiten stehen im Abschnitt [Was hält](#haelt).
* **Hält ein Fund das nächste Paket auf?** Nach meiner Einschätzung nicht. K1
  ist ein echter Speicherfehler im Release, aber vermutlich ohne sichtbare Folge,
  und er steckt seit 7.2.0.12 in jedem Paket. Die Entscheidung trifft Gregor.
  K2 bis K4 betreffen nur den Debug-Bau oder nur die Tests.

## <a id="k1"></a>K1 — Die Behebung von E-28 liest aus einer gelöschten Zusammenfassung

**Was passiert** (am Quelltext belegt, nicht gemessen):

1. `CMessageFrame::ActivateFrame` merkt sich die Zusammenfassung:
   `m_pSumBackPtr = Sum;` (`msgframe.cpp:61`). Das gilt auch für
   Verfassen-Fenster, denn `CCompMessageFrame` überschreibt `ActivateFrame`
   nicht.
2. Man öffnet eine neue Nachricht und schließt sie, ohne sie je gespeichert zu
   haben. Dann ruft `CCompMessageFrame::OnDestroy` erst `Toc->RemoveSum(Sum)`
   auf und setzt dann `doc->m_Sum = NULL` (`CompMessageFrame.cpp:910-913`).
   `RemoveSum(CSummary*)` (`tocdoc.h:169-170`) führt zu
   `CTocDoc::RemoveSum(POSITION)`, und das gibt den Speicher mit `delete Sum;`
   frei (`tocdoc.cpp:1589`).
3. Am Ende ruft es `CMessageFrame::OnDestroy()` auf
   (`CompMessageFrame.cpp:918`). Dort ist `Sum` jetzt `NULL`, weil
   `doc->m_Sum` schon geleert ist. Die Bedingung
   `m_pSumBackPtr != NULL && m_pSumBackPtr != Sum && m_pSumBackPtr->m_FrameWnd == this`
   (`msgframe.cpp:202-203`) liest deshalb `m_FrameWnd` aus dem gerade
   freigegebenen `CSummary`.
4. `~CSummary` (`summary.cpp:556ff.`) setzt den Rückzeiger im Rahmen nicht
   zurück. Nichts anderes tut es.

**Wie schlimm** (Vermutung). In aller Regel wird nur gelesen. Auf dem Weg über
`WM_CLOSE` hat `CMessageDoc::PreCloseFrame` (`msgdoc.cpp:176`) `m_FrameWnd`
vorher schon auf `NULL` gesetzt. Der freigegebene Speicher enthält dort also
`NULL` oder im Debug-Bau `0xDD…`, und es wird nichts geschrieben. Geschrieben
wird nur dann, wenn der Speicher noch `this` enthält. Das wäre der Fall, wenn
das Fenster ohne `WM_CLOSE` zerstört wird, etwa beim Beenden, oder wenn ein
anderer Faden den Block inzwischen neu belegt hat. Dann schreibt die Zeile
`NULL` in fremden Speicher. Werkzeuge wie Application Verifier oder ein
Page-Heap melden schon das Lesen. Der Weg „neue Nachricht, verworfen“ ist
alltäglich.

**Zweiter Weg, gleiche Ursache** (am Quelltext belegt, seltener). Verschiebt
ein Filter die geöffnete Nachricht, hängt `filtersd.cpp:1585-1588` das Dokument
an die neue Zusammenfassung. Das Fenster behält aber `m_pSumBackPtr` auf der
alten, die anschließend gelöscht wird. Beim Schließen liest `OnDestroy` wieder
aus freigegebenem Speicher.

**Was der Test sieht.** `TestE28` prüft, dass die drei Zeilen dastehen
(`TestE28.cpp:107, 115, 117, 123`). Ob der Zeiger, den sie benutzen, noch lebt,
prüft er nicht. Am Text kann er das auch nicht.

**Vorschlag.** Der Rückzeiger muss mit der Zusammenfassung sterben. Am
einfachsten: In `CCompMessageFrame::OnDestroy` nach `RemoveSum` auch
`m_pSumBackPtr = NULL` setzen. Das reicht aber nur für den häufigen Weg. Für
alle Wege muss `~CSummary` über `m_FrameWnd` den Rahmen finden und dort
`m_pSumBackPtr` löschen. Auf `m_FrameWnd` allein ist dabei kein Verlass, siehe
den filtersd-Weg. Sicherer ist, dass `OnDestroy` vor dem Zugriff prüft, ob
`m_pSumBackPtr` noch in einer Toc steht. Ein Test, der das wirklich prüft,
müsste `CSummary` und `CMessageFrame` echt anlegen. Dafür fehlt im Prüfstand
heute die Umgebung.

**Nebenbei** (Vermutung, gering). Die Sicherung in `CSummary::Display`
(`summary.cpp:813`) fragt `::IsWindow(m_FrameWnd->GetSafeHwnd())`. Liegt an der
alten Adresse inzwischen ein **neues** Nachrichtenfenster, gleiche Größe und
damit gleiche Heap-Klasse, ist das Fenster gültig. Dann wird das falsche
Fenster nach vorn geholt. Das tritt nur ein, wenn `OnDestroy` den Zeiger nicht
gelöscht hat. Die Sicherung fängt also nicht jeden Fall, den sie fangen soll.

**Kennung.** Ein bestehender Befund nennt diesen Ort nicht
(`befund-suchen.pl m_pSumBackPtr`: kein Treffer). Vorschlag: [E-176](../Intern/BEFUNDE.md#e-176), eingetragen
wird das vom Hauptagenten.

## <a id="k2"></a>K2 — E-19: viermal dasselbe `ASSERT(0)` in den Nachbarzweigen

`CTocDoc::Read` repariert die Namen der Systempostfächer in fünf
gleichgebauten Zweigen. Die Behebung von [E-19](../Intern/BEFUNDE.md#e-19) hat
die Zusicherung nur im ersten Zweig entfernt (am Quelltext belegt):

| Zweig | Zeile | Zustand |
|---|---|---|
| In: Name weicht vom lokalisierten Namen ab | `tocdoc.cpp:641-664` | behoben, Kommentar „KEIN ASSERT(0) hier“ |
| Out: dasselbe | `tocdoc.cpp:680` | `ASSERT(0);` steht noch |
| Trash: dasselbe | `tocdoc.cpp:700` | `ASSERT(0);` steht noch |
| Junk: dasselbe | `tocdoc.cpp:725` | `ASSERT(0);` steht noch |
| normales Postfach heißt wie ein Systempostfach | `tocdoc.cpp:751` | `ASSERT(0);` steht noch |

Jeder dieser Zweige repariert danach, genau wie der In-Zweig. Die Begründung
in BEFUNDE trifft also auf alle fünf zu: *„feuert genau dann, wenn alles wie
vorgesehen läuft“*. Ob die vier Zweige auf Gregors Wegen betreten werden, habe
ich nicht gemessen. Der letzte trifft vermutlich jeden Ordner, der „In“, „Out“,
„Trash“ oder „Junk“ heißt, aber anders gespeichert ist, zum Beispiel einen
IMAP-Ordner „Junk“ (Vermutung).

**Was der Test sieht.** `TestZusicherungen.cpp:58-62` schneidet nur den
In-Zweig heraus, von `m_Type = MBT_IN; if( Name().CompareNoCase( szInBoxName ) != 0 ) {`
bis `needed_repair = TRUE; }`. Die vier anderen `ASSERT(0)` stehen heute da, und
der Test ist grün (gemessen, Grundlauf).

**Folgen.** Nur im Debug-Bau, dort als Zusicherungsdialog. Im Release ist
`ASSERT` leer. Das ist eine Fortschreibung von [E-19](../Intern/BEFUNDE.md#e-19) und braucht keine neue
Kennung.

## <a id="k3"></a>K3 — E-15: der Aufrufer in `settings.cpp` sichert dasselbe noch einmal zu

Der Kommentar zur Behebung (`TaskStatusView.cpp:78-80`) nennt
`settings.cpp:1492` als Aufrufer, der „ausdrücklich auf NULL abfragt“. Das
stimmt. Zwei Zeilen darüber steht aber (am Quelltext belegt):

```
settings.cpp:1490    ASSERT(QCGetTaskStatusView());
settings.cpp:1492    if (QCGetTaskStatusView())
```

Die Aufgabenanzeige wird erst angelegt, wenn ihr Fenster das erste Mal gezeigt
wird (`TaskStatusWazooWnd.cpp:87-91`, `CreateView`). Bis dahin ist
`g_TaskStatusView` `NULL`. Das ist der Fall, in dem Gregor [E-15](../Intern/BEFUNDE.md#e-15) gleich nach dem
Start sah. Ändert man in den Einstellungen die Spalten der Aufgabenanzeige
(`bTaskStatusColChanged`, `settings.cpp:1163`), bevor das Fenster je offen war,
feuert Zeile 1490 im Debug-Bau (am Quelltext belegt, nicht gemessen).

Der Test liest nur `QCGetTaskStatusView` selbst und bleibt grün (gemessen,
Grundlauf). Das ist eine Fortschreibung von [E-15](../Intern/BEFUNDE.md#e-15). Nebenbei: `~CTaskStatusView`
setzt `g_TaskStatusView` nicht zurück (`TaskStatusView.cpp:112-120`). Solange
die Ansicht bis zum Programmende lebt, schadet das nicht. Geprüft habe ich das
nicht.

## <a id="k4"></a>K4 — Andere Schreibweise, Test bleibt grün

Alle Zeilen dieser Tabelle sind gemessen. Für jede Zeile habe ich die
Änderung eingesetzt, `EudoraTests.exe` gefahren und die Änderung wieder
zurückgenommen. Zur Kontrolle gefahren: `ASSERT(g_TaskStatusView != NULL);` in
`QCGetTaskStatusView` macht [E-15](../Intern/BEFUNDE.md#e-15) rot; `::UnwrapText( CopyText );` in
`compmsgd.cpp:3471` macht [E-104](../Intern/BEFUNDE.md#e-104) rot.

| Test | Eingesetzte Änderung | Wirkung im Programm | Test |
|---|---|---|---|
| [E-15](../Intern/BEFUNDE.md#e-15) | `ASSERT (g_TaskStatusView != NULL);` (Leerzeichen vor der Klammer) | Zusicherung wieder da | **grün** |
| [E-15](../Intern/BEFUNDE.md#e-15) | `_ASSERTE(g_TaskStatusView != NULL);` | Zusicherung wieder da | **grün** |
| [E-104](../Intern/BEFUNDE.md#e-104) | `compmsgd.cpp:3471` `::UnwrapText( pszRumpf );` → `UnwrapText( CopyText );` | Kopfzeilen kleben wieder zusammen | **grün** |
| [E-104](../Intern/BEFUNDE.md#e-104) | dieselbe Zeile → `::UnwrapText( msg.GetBuffer() );` | dito | **grün** |
| [E-86](../Intern/BEFUNDE.md#e-86) | `if (in_bIsBlahBlahBlah)` vor `theFile.Write( szKompatibilitaet, …)` | Zeile fehlt bei fast jeder Nachricht | **grün** |
| [S-8](../Intern/BEFUNDE.md#s-8) (Behebung von [PRUEFER-66](PRUEFER-66.md#pruefer-66) K3) | `<#` vor `if ($pe.Arch -ne 'x86') {`, `#>` hinter `$falscheArch++` in `paket-pruefen.ps1` | Prüfung auskommentiert | **grün** |

Zur letzten Zeile: Meine Einfügung war kein gültiges PowerShell, denn die
schließende Klammer vor `elseif` bleibt offen. Ein gültiger Blockkommentar um
die ganze `if/elseif`-Kette wirkt im Test genauso. `LiesSkript`
(`TestPaket.cpp`, aus `abfb9b43`) leert nur Zeilen, deren erstes sichtbares
Zeichen `#` ist. Ein Blockkommentar `<# … #>` bleibt stehen (am Quelltext
belegt).

Die Zeile zu [E-104](../Intern/BEFUNDE.md#e-104) ist die wichtigste. Die Schreibweise ohne `::` steht schon
in derselben Datei (`compmsgd.cpp:3920`, dort harmlos, weil `szBody` nur der
Rumpf ist). Der Test zählt den Ganztext-Aufruf nur in den zwei Schreibweisen
`::UnwrapText( CopyText )` und `::UnwrapText(CopyText)`. Dass `UnwrapText` auf
`pszRumpf` läuft, prüft er nicht, sondern nur, dass die `FindBody`-Zeile
dasteht (`TestE104E115.cpp:33-38`). Robuster wäre die Prüfung, dass im
Abschnitt **jeder** `UnwrapText(`-Aufruf `pszRumpf`/`pszRumpf2` als Argument
hat.

Bei [E-15](../Intern/BEFUNDE.md#e-15) wäre eine Suche nach `ASSERT` ohne Klammer, plus `_ASSERTE` und
`VERIFY`, robuster.

Auch hier gilt der Nebenweg aus [PRUEFER-66](PRUEFER-66.md#pruefer-66) K3: `#if 0` um eine Behebung lässt
alle sechs Quelltexttests grün, weil `QT_LiesNurCode` nur Kommentare entfernt.
Das habe ich hier nicht neu gemessen.

## <a id="haelt"></a>Was hält

Für diese Tests habe ich nach einem Nebenweg gesucht und keinen gefunden (am
Quelltext belegt):

* **[E-21](../Intern/BEFUNDE.md#e-21).** `MessageWait` gibt es nur einmal (`QCWorkerSocket.cpp:1719`). Der
  Ausschnitt beginnt am Ende des `UNEXPECTED_CLOSE`-Blocks. Eine neue
  Zusicherung zwischen den beiden Blöcken zerreißt den Anfangsanker, und der
  Test wird rot. *Nebenbei, Vermutung, nicht gemessen:* `m_hEvent` ist ein
  manuell zurückzusetzendes Ereignis (`QCWorkerSocket.cpp:1448-1451`), und in
  der Schleife setzt es niemand zurück. Wenn der Zweig ohne Zusicherung
  erreicht wird, kehrt `MsgWaitForMultipleObjects` sofort zurück. Dann pumpt
  die Schleife keine Nachrichten mehr und läuft bis zum erwarteten Ereignis oder
  bis zum Zeitlimit mit voller Last. Das ist so seit dem Original. Die
  Zusicherung hat es vorher nur angezeigt.
* **[E-57](../Intern/BEFUNDE.md#e-57).** Außerhalb von `OnPaint`/`OnNcPaint` legt keine Funktion im Baum
  einen `CPaintDC` an. Gesucht habe ich über alle `.cpp` mit der umgebenden
  Funktion. Ein zweiter Weg zum selben Fehler existiert heute nicht.
* **[E-58](../Intern/BEFUNDE.md#e-58).** Beide Treffer-Fragen (`workbook.cpp:1201, 1619`) laufen über
  `CalcLogoTopLeft`. Die frühe Rückkehr steht vor jeder Rechnung
  (`workbook.cpp:1548-1549`).
* **[E-75](../Intern/BEFUNDE.md#e-75).** Strg+J wird sonst nur im Einstellungsdialog gesetzt
  (`settings.cpp:921-927`), und zwar ausdrücklich nach dem Haken. Der
  Rückfall auf `CTRL_J_JUNK` in `settings.cpp:2027-2030` greift nur bei
  `CTRL_J_UNKNOWN`. `InitJunkMenus` läuft aber bei jedem Start bedingungslos
  (`eudora.cpp:1645`) und setzt den Wert vorher. Diese Zeile ist heute also
  unerreichbar.
* **[E-115](../Intern/BEFUNDE.md#e-115).** Die übrigen Durchläufe, die Recent überspringen
  (`mboxtree.cpp:3088`, `MBoxTreeCtrlCheck.cpp:791`), überspringen mit
  `continue` oder mit einer Bedingung, nicht durch eigenes Weiterspringen. Dort
  kann `hItem` nicht unerwartet `NULL` werden.
* **[M-1](../Intern/BEFUNDE.md#m-1).** Der Test ruft die echte Klasse auf. `OTShim_Werkzeugleiste.cpp`
  wird in Eudora und im Testprojekt gebaut (`perl tools/wer-baut.pl`). Beide
  Konstruktoren beginnen mit `FALSE` (`OTShim_Werkzeugleiste.cpp:3717, 3744`).
  Gesetzt wird der Zustand nur über `EnableMainFrame`. Das rufen
  `SECToolBarCmdPage::OnSetActive` und `QCToolBarCmdPage::OnSetActive` auf,
  beide unter `m_pManager != NULL`. Zurückgesetzt wird er in
  `~SECToolBarCmdPage`, unter derselben Bedingung.
* **`release-veroeffentlichen.ps1`** (`87089d6f`). Die Abweisung von 7.2.0.N
  sieht nur die dritte Stelle an. Eine 7.3.1.N käme durch diese Zeile, aber
  nicht durch die folgenden Vergleiche mit `VERSION` und `Version.h`. Die
  Version.h-Muster arbeiten mit `-like '*…*'`, deshalb passt
  `EUDORA_VERSION4 12` auch auf `128`. Das Muster mit Anführungszeichen
  `"7.2.1.12"` fängt diesen Fall (am Quelltext belegt). Ich sehe hier keinen
  Fund.

## Neue Kennungen

Vorgeschlagen: **[E-176](../Intern/BEFUNDE.md#e-176)** für [K1](#k1) (Lesen aus der gelöschten Zusammenfassung
über `m_pSumBackPtr`). [E-177](../Intern/BEFUNDE.md#e-177) habe ich nicht vergeben. K2 ist eine
Fortschreibung von [E-19](../Intern/BEFUNDE.md#e-19), K3 eine von
[E-15](../Intern/BEFUNDE.md#e-15), K4 betrifft nur die Tests. In
`Intern/BEFUNDE.md` habe ich nichts eingetragen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | 337/337 Tests im Grundlauf. Kein Nebenweg gefunden bei [E-21](../Intern/BEFUNDE.md#e-21), [E-57](../Intern/BEFUNDE.md#e-57), [E-58](../Intern/BEFUNDE.md#e-58), [E-75](../Intern/BEFUNDE.md#e-75), [E-115](../Intern/BEFUNDE.md#e-115), [M-1](../Intern/BEFUNDE.md#m-1) und bei der Abweisung von 7.2.0.N. | keine | nein |
| [K1](#k1) | Neue Nachricht öffnen und ungespeichert schließen: `CMessageFrame::OnDestroy` liest über `m_pSumBackPtr` aus der gerade gelöschten Zusammenfassung. Ebenso nach einem Filter, der die offene Nachricht verschiebt. Seit 7.2.0.12 in jedem Paket. Vorschlag [E-176](../Intern/BEFUNDE.md#e-176). | mittel (Speicherfehler, vermutlich ohne sichtbare Folge) | nach meiner Einschätzung nein; Gregor entscheidet |
| [K2](#k2) | [E-19](../Intern/BEFUNDE.md#e-19) nur im In-Zweig behoben. Für Out, Trash, Junk und für ein normales Postfach mit Systemnamen steht `ASSERT(0)` noch da (`tocdoc.cpp:680/700/725/751`). Nur im Debug-Bau. | niedrig | nein |
| [K3](#k3) | `settings.cpp:1490` sichert `QCGetTaskStatusView()` zu. Feuert im Debug-Bau, wenn Spalten der Aufgabenanzeige geändert werden, bevor deren Fenster je offen war. | niedrig | nein |
| [K4](#k4) | Bei anderer Schreibweise bleiben Tests grün: `ASSERT (`, `_ASSERTE(` ([E-15](../Intern/BEFUNDE.md#e-15)), `UnwrapText( CopyText )` ohne `::` ([E-104](../Intern/BEFUNDE.md#e-104)), Bedingung vor der Meta-Zeile ([E-86](../Intern/BEFUNDE.md#e-86)), `<# … #>` ([S-8](../Intern/BEFUNDE.md#s-8)). | niedrig (nur Tests) | nein |
