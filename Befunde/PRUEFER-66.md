# <a id="pruefer-66"></a>PRUEFER-66 — Prüfung der Regressionstests zu E-60, E-72/E-64, E-82, S-1, S-8 und E-156, 30.10.2026

**Auftrag.** Die neuen Regressionstests aus `6d355899` und `2c79b15c`
(`git log eb7a3f88..HEAD -- Eudora71/Tests`, Stand `cc78de65`):
`TestE60.cpp`, `TestE72.cpp`, `TestE82.cpp`, `TestPaket.cpp`, ihre Eintragung
in `TestMain.cpp` und `Tests.vcxproj`, und die neuen Sätze zu [S-1](../Intern/BEFUNDE.md#s-1), [S-8](../Intern/BEFUNDE.md#s-8), [E-60](../Intern/BEFUNDE.md#e-60),
[E-72](../Intern/BEFUNDE.md#e-72), [E-82](../Intern/BEFUNDE.md#e-82) und [E-156](../Intern/BEFUNDE.md#e-156) in `Intern/BEFUNDE.md`. Die Kernfrage war: Wird ein Test
rot, wenn der Fehler auf einem **anderen, realistischen** Weg zurückkommt als
auf dem einen Weg, der beim Anlegen gegengeprüft wurde?

Eudora wurde weder gebaut noch gestartet. Ich habe keine Quelldatei geändert
und keine Gegenprobe am Quelltext gefahren. Die Gegenvermutungen unten sind am
Test und an der Quelle **gelesen**, nicht gemessen. Gefahren habe ich nur die
Testsuite im Projektordner (`RunTests.cmd`, Stand `cc78de65` plus
ungespeicherte Änderung an `tools/AGENTEN-LAUFEN.md`): **321 Tests, 321
bestanden** (gemessen).

**Ergebnis vorweg.**

* **Eingetragen und lauffähig sind alle vier Tests** (gemessen). Findet ein
  Test seinen Abschnitt nicht, wird er rot, nicht grün. Das gilt für jeden
  `QT_Abschnitt` und jedes `HoleDebugMuster` in den vier Dateien (am
  Quelltext belegt).
* **Die Behebung von [E-72](../Intern/BEFUNDE.md#e-72) hat bei den verneinten Bedingungen eine neue
  Lücke aufgemacht** ([K1](#k1)). Eine Filterregel *„X doesn't appear“* trifft
  jetzt **jede** Nachricht, und *„X appears“* trifft keine mehr. Eine Regel
  *„doesn't contain“* mit leerem Wert trifft ebenfalls jede Nachricht. Mit der
  Aktion „transfer“ ist das derselbe Schaden wie [E-64](../Intern/BEFUNDE.md#e-64). `TestE72` schreibt die
  fehlerhafte Stelle fest und bleibt grün.
* **`TestE60` sichert Funktionen, die im Programm niemand aufruft**
  ([K2](#k2)). Der echte Anordnungsdurchlauf läuft über `DeleteAllSplitters`,
  und das achtet nicht auf `m_bTracking`. Der Satz in BEFUNDE, dass
  `TrennbalkenNeuAnlegen` während des Ziehens sofort zurückkehrt, stimmt heute
  nicht. Eine Gefahr besteht heute nicht, weil keine Trennbalken mehr angelegt
  werden.
* **Die Paket-Tests sehen auskommentierte Prüfungen als vorhanden**
  ([K3](#k3)). Steht vor `Melde-Fehler` oder `throw` ein `#`, bleiben [S-1](../Intern/BEFUNDE.md#s-1), [S-8](../Intern/BEFUNDE.md#s-8)
  und [E-156](../Intern/BEFUNDE.md#e-156) grün. Ebenso bleiben [E-72](../Intern/BEFUNDE.md#e-72) und [E-82](../Intern/BEFUNDE.md#e-82) grün, wenn man ihre Behebung in
  `#if 0` einschließt.
* **Jeder Quelltexttest hat einen Nebenweg, auf dem er grün bleibt**
  ([K4](#k4)). Diese Nebenwege sind weniger wahrscheinlich als K1 bis K3, aber
  realistisch.
* **Hält ein Fund ein Paket auf?** K1 betrifft Anwender mit Filterregeln
  *„appears“* oder *„doesn't appear“* und kann Nachrichten verschieben. Ob das
  ein Paket aufhält, entscheidet Gregor. K2 bis K4 betreffen nur die Tests.

## Frage 1 — Setzt `Splitter::Track` die Marke `m_bTracking` wirklich?

**Ja** (am Quelltext belegt). `OTShim.cpp:4346` setzt `m_bTracking = TRUE`
nach `SetCapture` und vor der Nachrichtenschleife. `OTShim.cpp:4437` setzt die
Marke nach der Schleife wieder auf `FALSE`. Zwischen den beiden Zeilen steht
jedes `DispatchMessage`, die Marke deckt die gefährliche Strecke also ab.

`TestE60.cpp:42` setzt die Marke **von Hand**. Fällt Zeile 4346 weg, bleibt der
Test deshalb grün. Die Behebung wäre dann wirkungslos (am Test belegt). Das
ist Teil von [K2](#k2).

## Frage 2 — Wird ein Test rot, wenn er seinen Abschnitt nicht findet?

**Ja, überall** (am Quelltext belegt). `QT_Abschnitt` gibt `NULL` zurück, wenn
Anfang oder Ende fehlen (`Quelltext.cpp:206-212`). Jeder Aufrufer prüft das mit
`TT_CHECK_MSG(p != NULL, …)` oder bricht mit `TT_Fail` ab:
`TestE72.cpp:38,42,54,76`, `TestE82.cpp:38,54`, `TestPaket.cpp:57,101,114,143`.
Eine nicht lesbare Datei ist ebenfalls rot (`… - ungeprueft ist nicht gruen`).

## <a id="k1"></a>K1 — Ein leerer Suchwert macht verneinte Filterbedingungen zu „trifft alles“

**Was passiert.** Die zweite Sperre zu [E-72](../Intern/BEFUNDE.md#e-72) steht in `CFilter::MatchValue`
(`filtersd.cpp:713-716`): Ist der Suchwert leer, liefert die Funktion `FALSE`.
Die **Verneinung** geschieht aber erst danach, in `CFilter::MatchCondition`
(`filtersd.cpp:933-939`). Bei `doesn't contain`, `is not` und `doesn't appear`
wird dort `Matches = !Matches` gerechnet. Aus „passt nicht“ wird also „passt“
(am Quelltext belegt, nicht gemessen):

| Bedingung, Wert leer | vor der Behebung | jetzt |
|---|---|---|
| `contains` | jede Nachricht (der E-64-Schaden) | keine |
| `doesn't contain` | keine | **jede Nachricht** |
| `appears` | Nachrichten mit dieser Kopfzeile | **keine** |
| `doesn't appear` | Nachrichten ohne diese Kopfzeile | **jede Nachricht** |

Die Zeilen zu `appears` und `doesn't appear` sind der wichtigere Fall. Diese
beiden Verben brauchen keinen Wert. Der `case` in `MatchValue`
(`filtersd.cpp:766-768`) liefert `TRUE`, ohne den Wert anzusehen. Eine
gewöhnliche Regel wie *„Kopfzeile X-Spam-Flag doesn't appear → transfer
Gelesen“* hat deshalb normalerweise einen leeren Wert. Bis zur Behebung
verschob sie nur Nachrichten ohne diese Kopfzeile. Jetzt verschiebt sie
**jede** Nachricht, und eine Regel mit `appears` greift gar nicht mehr. Ob
das Filterfenster den Wert bei diesen Verben ausblendet oder leer lässt, habe
ich nicht nachgesehen. An `MatchValue` ändert das nichts.

**Welcher Test bleibt grün.** `TestE72` (*„ein Filter mit leerem Suchwert
trifft keine Nachricht“*) prüft genau diese Stelle und verlangt sie dort, nach
den Junk-Score-Verben und vor dem Textvergleich (`TestE72.cpp:79-84`). Das
Verb sieht er nicht an. Er schreibt die Lücke also fest. Eine richtige
Behebung an anderer Stelle würde ihn rot machen.

**Der BEFUNDE-Satz** zu [E-72](../Intern/BEFUNDE.md#e-72) sagt: *„eine Bedingung mit leerem Wert passt
nicht mehr auf alles“*. Das stimmt für `contains`, `is`, `starts with` und
`ends with`, für die drei verneinten Verben aber nicht.

**Vorschlag.** Der leere Wert gehört nicht in `MatchValue`, sondern in
`MatchCondition` **nach** der Verneinung. Dort gilt dann: Ist der Wert leer
und das Verb weder `appears` noch `doesn't appear`, ist das Ergebnis `FALSE`.
Der Test prüft dann diese Stelle und das Verb. Am besten führt er
`MatchCondition` aus, statt die Stelle zu lesen. Für Kopfzeilen braucht er
dafür kein `CSummary`, nur für `Junk Score`.

**Schwere: hoch** (Daten werden verschoben, betrifft nur Anwender mit diesen
Regeln). **Hält das Paket auf:** entscheidet Gregor. Bekannt war das
nicht: `befund-suchen.pl MatchValue` meldet [E-67](../Intern/BEFUNDE.md#e-67) und [E-72](../Intern/BEFUNDE.md#e-72), keiner der beiden
Einträge nennt die verneinten Verben.

## <a id="k2"></a>K2 — `TestE60` sichert einen Weg, den das Programm nicht mehr geht

**Was der Test prüft.** `TestE60` ruft `AddSplitter`, `BeginRecycleSplitters`
und `EndRecycleSplitters` auf, setzt `m_bTracking` von Hand und prüft, dass
der ziehende Balken nicht freigegeben, nicht umgewidmet und nicht gelöscht
wird. Das tut er richtig.

**Was das Programm tut** (am Quelltext belegt):

* `AddSplitter`, `BeginRecycleSplitters` und `EndRecycleSplitters` haben
  **keinen Aufrufer** außer dem Test (Grep über `Eudora71`, `*.cpp`/`*.h`).
* Der Anordnungsdurchlauf ist `SECDockBar::OnSize` →
  `TrennbalkenNeuAnlegen` (`OTShim.cpp:4667`). Das ist seit [E-66](../Intern/BEFUNDE.md#e-66) stillgelegt
  und ruft nur noch `DeleteAllSplitters()` (`OTShim.cpp:4694`). Dieses löscht
  **jeden** Balken, auch einen, der gerade gezogen wird
  (`OTShim.cpp:3711-3717`, keine Abfrage von `m_bTracking`).
* Gezogen wird heute über `ZiehenAmRand` mit einem Balken **auf dem Stapel**
  (`OTShim.cpp:4089-4097`). Den kann `DeleteAllSplitters` nicht treffen. Weil
  `m_arrSplitters` leer bleibt, findet `HitTest` nichts, und
  `StartTracking` (`OTShim.cpp:3986`, der Weg mit Zeiger in das Feld) wird nie
  erreicht.

**Folge.** Heute besteht keine Gefahr. Wird aber das Anlegen der Balken
wiederbelebt (das Gerüst steht ausdrücklich noch da, `OTShim.cpp:4688-4693`),
dann läuft der Anordnungsdurchlauf weiter über `DeleteAllSplitters`, und [E-60](../Intern/BEFUNDE.md#e-60)
ist zurück. `TestE60` bleibt dabei grün. Ebenso bleibt er grün, wenn
`Splitter::Track` die Marke nicht mehr setzt ([Frage 1](#frage-1--setzt-splittertrack-die-marke-m_btracking-wirklich)).

**Der BEFUNDE-Satz** zu [E-60](../Intern/BEFUNDE.md#e-60) sagt: *„`TrennbalkenNeuAnlegen` kehrt sofort
zurück, solange gezogen wird“*. Heute steht dort keine solche Abfrage
(`OTShim.cpp:4674-4695`). Auch der Kommentar `OTShim.h:772-778` nennt noch den
alten Weg *„TrennbalkenNeuAnlegen -> EndRecycleSplitters“*. Der neue Satz
*„stellt den Anordnungsdurchlauf mitten im Ziehen nach“* trifft nur den alten
Durchlauf.

**Vorschlag.** `DeleteAllSplitters` bekommt dieselbe Abfrage wie
`EndRecycleSplitters`, oder `TrennbalkenNeuAnlegen` kehrt bei einem ziehenden
Balken zurück, wie BEFUNDE es beschreibt. Der Test ruft dann zusätzlich
`TrennbalkenNeuAnlegen` mit einem ziehenden Balken auf. BEFUNDE und
`OTShim.h:775` werden auf den heutigen Weg berichtigt.

**Schwere: mittel** (die Schranke ist blind für den echten Weg, heute ohne
Wirkung). **Hält das Paket auf: nein.**

## <a id="k3"></a>K3 — Auskommentierte oder ausgeschaltete Prüfungen gelten als vorhanden

**PowerShell.** `TestPaket.cpp` liest beide Skripte mit `QT_Lesen` und
`QT_LeerraumZusammen`. Kommentare entfernt es **nicht**: `QT_KommentareRaus`
kennt nur `//` und `/* */`, und es wird hier gar nicht aufgerufen. Jede
Prüfung mit `QT_Enthaelt` findet deshalb auch eine auskommentierte Zeile (am
Quelltext belegt):

* `# Melde-Fehler ("{0} ist eine Debug-Fassung …` → [E-156](../Intern/BEFUNDE.md#e-156) bleibt grün
  (`TestPaket.cpp:108`).
* `# throw ("ABBRUCH: {0} enthaelt Debug-Laufzeit …` → [E-156](../Intern/BEFUNDE.md#e-156) bleibt grün
  (`:119`), ebenso das zweite `throw` (`:118`).
* `# if ($pe.Arch -ne 'x86') { Melde-Fehler (…` → [S-8](../Intern/BEFUNDE.md#s-8) bleibt grün (`:165`).
* `# Melde-Fehler ("$n fehlt im Paket …` → [S-1](../Intern/BEFUNDE.md#s-1) bleibt grün (`:137`).

Auskommentieren ist die übliche Art, eine Prüfung „vorübergehend“
abzuschalten. Die Gegenproben in BEFUNDE haben anders abgeschaltet (*„Mit
`Write-Host` statt `throw`“*, *„mit abgeschalteter Architekturprüfung“*) und
konnten das deshalb nicht sehen. Das widerspricht der Lehre
[Schranke liest nur Code](../Arbeitsweise/schranke-liest-nur-code.md).

**C++.** `QT_LiesNurCode` entfernt Kommentare, aber keinen Präprozessor. Steht
die Behebung in `#if 0 … #endif`, bleiben `TestE72` (Sperre und leerer Wert)
und `TestE82` (der gemeinsame Zweig) grün (am Quelltext belegt). In den
Eudora-Quellen ist `#if 0` eine verbreitete Art, Code abzuschalten.

**Vorschlag.** Eine Hilfsfunktion `QT_LiesNurCodePs` entfernt Zeilen ab `#`
außerhalb von Zeichenketten sowie `<# … #>`. `QT_KommentareRaus` überspringt
`#if 0`-Blöcke. Gegenprobe dafür: jeweils eine geprüfte Zeile auskommentieren,
der Test muss rot werden.

**Schwere: mittel.** **Hält das Paket auf: nein.**

## <a id="k4"></a>K4 — Nebenwege, auf denen einzelne Tests grün bleiben

Alle am Test gelesen, nicht gemessen.

* **[E-72](../Intern/BEFUNDE.md#e-72), Sperre.** `TestE72.cpp:45,48` verlangt nur, dass `m_pGeladen =
  filt;` irgendwo in `DoDataExchange` steht, nicht im Ladezweig. Rutscht die
  Zuweisung nach oben neben `m_CurFilter = filt;` (`filtersv.cpp:1191`), ist
  sie bei jedem Aufruf gesetzt, und die Sperre greift nie mehr. [E-72](../Intern/BEFUNDE.md#e-72) ist dann
  zurück, der Test bleibt grün. Eine zweite Zuweisung außerhalb von
  `DoDataExchange`, etwa in `OnUpdate`, sieht er gar nicht.
* **[E-82](../Intern/BEFUNDE.md#e-82).** Geprüft wird die Zeichenfolge `iOK =` mit Leerzeichen
  (`TestE82.cpp:57,62`). Grün bleiben:
  * `iOK=1;` ohne Leerzeichen, `iOK |= 1;` oder `++iOK;` im `switch`.
  * `return 1;` im gemeinsamen Zweig hinter `AddErrors(…CHAINNOTTRUSTED);`.
    Die lange Zeichenfolge in `:43-45` endet vor dieser Stelle.
  * Ein Ausstieg **vor** dem `switch`, etwa `if (X509_STORE_CTX_get_error(…)
    == X509_V_ERR_CERT_UNTRUSTED) return 1;`.
  * `return 1;` statt `return iOK;` am Ende des Callbacks.

  Rot wird der Test dagegen bei der Gegenvermutung aus dem Auftrag, einem
  eigenen `case` für 21 oder 27. Zwei gleiche `case`-Marken übersetzt der
  Compiler nicht. Wer den Code aus dem gemeinsamen Zweig nimmt, bricht die
  Zeichenfolge in `:43-45`.
* **[E-156](../Intern/BEFUNDE.md#e-156), Dateiauswahl.** In `paket-pruefen.ps1` prüft der Test nur den
  Anfang der Auswahl `Get-ChildItem -LiteralPath $Paket -Recurse -File |`
  (`TestPaket.cpp:104`). Ein zusätzlicher Filter im folgenden `Where-Object`,
  etwa nur `.exe`/`.dll`, bleibt grün. Ausgeschlossen ist nur der Name
  `$binaer`. In `paket-bauen.ps1` Schritt 8 prüft der Test die Dateiauswahl
  gar nicht (`:117-119`).
* **[E-156](../Intern/BEFUNDE.md#e-156), Muster.** Gelesen wird das erste `$debugMuster = '(?i)…'`. Ob
  `[regex]::Matches` auch damit sucht, prüft der Test nicht. Eine zweite
  Zuweisung weiter unten oder ein Aufruf mit einer anderen Variable bleibt
  grün. Ein in eine gemeinsame Datei verlegtes Muster macht den Test dagegen
  rot. Das ist die richtige Richtung.
* **[S-1](../Intern/BEFUNDE.md#s-1), Windows-Liste.** Geprüft wird nur das Feld `$windowsEigen = @(…)` und
  die letzte Zeile von `Klassifiziere`. Ein späteres `$windowsEigen +=
  'msvcr71'` oder eine neue Regel vor der Nachschlagezeile (`if ($n -like
  'msvc*') { return 'Windows' }`, so wie schon `api-ms-win-*` in
  `paket-pruefen.ps1:425`) bleiben grün.

**Schwere: niedrig.** **Hält das Paket auf: nein.**

## Was sonst geprüft wurde

* **Eintragung.** Die vier `Run…Tests` stehen in `TestMain.cpp` deklariert und
  aufgerufen, die vier Dateien in `Tests.vcxproj`. `OTShim.cpp` wird mitgebaut
  (`Tests.vcxproj:78`), `TestE60` ruft also wirklich den echten Code. Alle
  sieben neuen Testfälle stehen im Lauf als `[ok  ]` (gemessen).
* **Ausgeführtes Muster.** `TestPaket` übersetzt das Debug-Muster mit
  `std::regex` (ECMAScript, `icase`). Für die verwendeten Bausteine (`\d`,
  `[a-z]+`, `u?`, Alternativen) verhält sich das wie .NET mit `(?i)` (am
  Quelltext belegt). Beide Skripte tragen heute dasselbe Muster
  (`paket-pruefen.ps1:779`, `paket-bauen.ps1:689`).
* **BEFUNDE-Zeilen.** [S-1](../Intern/BEFUNDE.md#s-1), [S-8](../Intern/BEFUNDE.md#s-8), [E-82](../Intern/BEFUNDE.md#e-82) und [E-156](../Intern/BEFUNDE.md#e-156) behaupten nur, was der Test
  prüft, und nennen die Gegenprobe. Die Zahlen 318 und 321 passen zu den zwei
  Commits. [E-72](../Intern/BEFUNDE.md#e-72) und [E-60](../Intern/BEFUNDE.md#e-60) enthalten je einen Satz, der nicht stimmt
  ([K1](#k1), [K2](#k2)).

## Neue Kennungen

Keine vergeben. K1 ist eine Fortschreibung von
[E-72](../Intern/BEFUNDE.md#e-72), K2 eine von
[E-60](../Intern/BEFUNDE.md#e-60). In `Intern/BEFUNDE.md` habe ich nichts
eingetragen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | Fragen 1 und 2: `Track` setzt die Marke. Jeder Test wird rot, wenn er seinen Abschnitt nicht findet. 321/321 Tests. | keine | nein |
| [K1](#k1) | Filterregeln mit `doesn't appear` (Wert normalerweise leer) treffen jetzt jede Nachricht, `appears` keine mehr, `doesn't contain` mit leerem Wert jede. `TestE72` schreibt das fest. | hoch | Gregor entscheidet |
| [K2](#k2) | `TestE60` prüft Funktionen ohne Aufrufer. Der echte Durchlauf (`DeleteAllSplitters`) achtet nicht auf `m_bTracking`. Ein BEFUNDE-Satz beschreibt eine Abfrage, die es nicht gibt. Heute ohne Wirkung. | mittel | nein |
| [K3](#k3) | Ein `#` vor der geprüften PowerShell-Zeile oder `#if 0` um die C++-Behebung lässt [S-1](../Intern/BEFUNDE.md#s-1), [S-8](../Intern/BEFUNDE.md#s-8), [E-156](../Intern/BEFUNDE.md#e-156), [E-72](../Intern/BEFUNDE.md#e-72) und [E-82](../Intern/BEFUNDE.md#e-82) grün. | mittel | nein |
| [K4](#k4) | Nebenwege: `m_pGeladen` an falscher Stelle, `iOK=1` ohne Leerzeichen oder `return 1;`, engere Dateiauswahl, zweite Windows-Regel. Die Tests bleiben dabei grün. | niedrig | nein |
