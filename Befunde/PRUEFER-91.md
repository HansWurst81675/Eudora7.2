# <a id="pruefer-91"></a>PRUEFER-91

Lauf nach PRUEFER-90. Zweig wt/pruefer-20261103b, abgezweigt von `origin/about_dialog_github`. Geprüft wird `origin/main..HEAD -- Eudora71 tools Releases/1.0`, also der Commit 70c83b16 ([E-216](../Intern/BEFUNDE.md#e-216): About-Dialog). Zeilen sind Stand 70c83b16, `Eudora71/Eudora/`. Eudora habe ich weder gebaut noch gestartet. Ich habe kein Fenster geöffnet und keinen Prüfstand angefasst. Textbreiten habe ich mit GDI in einem Speicher-DC ohne Fenster gemessen (Skript im Scratchpad, PowerShell, `CreateCompatibleDC(NULL)`, 96 dpi).

## Ergebnis vorweg

Die Behebung tut, was Gregor wollte. Die fünf Knöpfe stehen in einer Reihe und überdecken sich nicht. Die Zeile *Mail folder from* ist jetzt zwei Zeilen hoch, und alle festen Herkunftstexte passen hinein. Der neue Knopf *Latest Release* führt auf die richtige, öffentliche Seite. Die Reihenfolge beim Durchlaufen mit der Tabulatortaste stimmt jetzt mit der Anordnung auf dem Bildschirm überein. Vorher stimmte sie nicht. Die Testsuite läuft mit 398/398.

Drei Dinge sind nicht ganz fertig. Die Zeile *Log:* ist weiter nur eine Zeile hoch. Mit der Vorgabe (Mailverzeichnis unter Application Data, `LogLevel` aus der Vorgabe) ist ihr Text breiter als der Dialog. Der Hinweis *„keine E-nn-Marken“* am Ende fehlt dann. Das ist derselbe Fehler, den Gregor an der Nachbarzeile gemeldet hat. Er ist älter als [E-216](../Intern/BEFUNDE.md#e-216), aber er betrifft fast jeden, der Eudora mit der Vorgabe betreibt (K1). Die Regressionstests lesen nur den Quelltext. Sie bleiben grün, wenn man die Knöpfe alle übereinanderlegt oder die Verbreiterung der Pfadzeilen abschaltet (K3, gemessen). Den Knopf *Latest Release* hat noch niemand gedrückt. Das soll Gregor im Testplan tun. Dort fehlt aber das Merkmal „es kommt keine Meldung“ (K4).

**Kein Fund hält das nächste Paket (7.2.2.132) auf.** Wenn sowieso noch einmal gebaut wird, ist K1 billig mitzunehmen. Sonst gehören alle Funde zu [E-216](../Intern/BEFUNDE.md#e-216) und werden dort fortgeschrieben. Neue Kennungen habe ich nicht vergeben.

## 1. Der Weg am Quelltext

- **Breite des Dialogs.** `OnInitDialog` setzt die Fensterbreite auf Logo + 2·`kInsetPixels` + 2 (AboutDlg.cpp:375). Das Logo `RES\EUDBYQC.BMP` ist 490 × 171 Pixel groß (gemessen, aus dem BMP-Kopf). Mit `WS_BORDER` ergibt das einen Clientbereich von 496 Pixeln. Beide `GetClientRect` stehen danach (:452, :561). Belegt.
- **Knopfreihe, Rechnung bei 96 dpi.** Die Dialogschrift ist *MS Shell Dlg* 8 pt mit `DS_SETFONT | DS_FIXEDSYS`. Gemessen im Speicher-DC: Grundeinheit 6 × 13, sowohl bei der Zuordnung auf Microsoft Sans Serif als auch auf Tahoma. Damit sind 58 DLU = 87 Pixel. Fünf Knöpfe brauchen 435 Pixel. Der Abstand ist (496 − 435) / 6 = 10 Pixel, die Untergrenze von 4 greift nicht. Die längste Aufschrift (*Latest Release*) ist 71 Pixel breit, gemessen. Sie passt also. Belegt mit Messung.
- **Fehlende Knöpfe.** `if (!p) continue;` (:544). Mit einer alten `EudoraRes.dll` ohne den neuen Knopf werden vier Knöpfe verteilt, und nichts stürzt ab. Belegt.
- **Pfadzeilen.** Breite = Client − 2·(3 + 4) = 482 Pixel, die Höhe bleibt (:450-465). Danach zentriert `CenterControl` am Fensterrechteck, das links und rechts denselben Rand hat. Belegt. Vorher waren die Zeilen 280 DLU = 420 Pixel breit. Die Zeile *Mail folder from* hat jetzt 20 DLU, das sind 32 Pixel. Die Zeile von `ANSI_VAR_FONT` ist 13 Pixel hoch (gemessen), also passen zwei Zeilen hinein.
- **Handler.** `ShellExecuteExA` mit `SEE_MASK_FLAG_NO_UI`. Der Fehlerzweig gibt genau eine Meldung aus und endet mit `return` (:1289-1322). Das ist dasselbe Muster wie bei `CMainFrame::HilfeSeiteOeffnen` (mainfrm.cpp:6193-6230), nur ohne die Sonderbehandlung von `SE_ERR_NOASSOC`. Belegt.

## 2. Gegenvermutungen aus dem Auftrag

| Gegenvermutung | Ergebnis | Kennzeichnung |
|---|---|---|
| Startbild (`m_IsSplash`): Knöpfe weg, Höhe richtig? | Ja. Die Höhe ist wie vorher Copyright-Unterkante + 2 (:506-528), alle fünf Knöpfe werden versteckt. `Create` im Konstruktor ruft `OnInitDialog` synchron. Danach versteckt der Konstruktor drei der Knöpfe ein zweites Mal (:303-311). Das ist doppelt, schadet aber nicht (K6). | belegt |
| Credits / zweite Seite verschiebt Knöpfe erneut | Widerlegt. `StartScrollTimer` und `StopScrollTimer` ändern nur `EnableWindow` und den Fokus (:1229, :1233, :1251). `OnClickedCredits` ruft kein `SetWindowPos`. An der Stelle um :1150 steht `LoadCreditsList`, nicht die Knopfreihe. | belegt (grep über `SetWindowPos`, `MoveWindow`, `ShowWindow`) |
| Hohe Bildschirmskalierung | Eudora ist nicht DPI-bewusst: `Eudora.manifest` enthält kein `dpiAware`, und `Eudora.vcxproj` setzt kein `EnableDpiAwareness`. Windows rechnet also mit 96 dpi und vergrößert das fertige Bild. Die Rechnung oben gilt dann bei jeder Skalierung. Der Zweig „Knöpfe schmaler“ greift heute nie. Würde Eudora einmal DPI-bewusst, wären die Knöpfe bei 150 % je 94 Pixel breit, und die Aufschrift *Latest Release* wäre etwa 107 Pixel breit. Dann würde sie abgeschnitten. Das ist eine reine Annahme, heute ohne Wirkung. | Vermutung mit starkem Beleg (Manifest, Projekt) |
| Tab-Reihenfolge | Sie ist jetzt gleich der Anordnung auf dem Bildschirm: Close, Visit Web Site, Latest Release, Credits, Copy info (EudoraRes.rc:396-400). `SWP_NOZORDER` lässt sie stehen. Vorher war die Tab-Reihenfolge Close → Visit → Credits → Copy, auf dem Bildschirm standen die Knöpfe aber als Close, Copy, Visit (Mitte), Credits. Das ist eine Verbesserung. | belegt |
| Schrift von *Visit Web Site* | Vorher setzte `CenterControl` dem Knopf `ANSI_VAR_FONT` (:1125). Er hatte also eine andere Schrift als die übrigen Knöpfe. Jetzt tragen alle fünf die Dialogschrift, und das ist einheitlich. Die Aufschrift passt (66 Pixel bei 87, gemessen). | belegt |
| 8318 kollidiert | Nein. 8318 steht in resource.h genau einmal (grep und Test), `_APS_NEXT_CONTROL_VALUE` ist 8319. Kennungen von Steuerelementen müssen ohnehin nur innerhalb eines Dialogs eindeutig sein. `EudoraRes.dll` wird aus denselben Dateien `EudoraRes.rc` und `resource.h` gebaut (EudoraRes.vcxproj). Eine andere Ressourcendatei mit `IDD_ABOUTBOX` gibt es im Repo nicht. EuGraph und CrashTest haben eigene Dialoge mit demselben Namen in eigenen Modulen. | belegt |
| URL fest im Code statt in der Ressource | Unbedenklich. Das Repo ist öffentlich (`gh repo view`: PUBLIC, gemessen). `/releases/latest` zeigt heute auf v7.2.1.131, das als *Latest* markiert ist (`gh release list`, gemessen). Eine Übersetzung der Ressourcen gibt es nicht. Hinweis: GitHub überspringt bei `latest` Vorabversionen. Wird 7.2.2.x als *Pre-release* veröffentlicht, führt der Knopf weiter auf 7.2.1.x (K7). | gemessen / belegt |

## 3. Testsuite und Gegenproben (in meinem Baum)

Gemessen mit `Eudora71\Tests\RunTests.cmd` aus PowerShell. Die Quelle habe ich mit Perl `:raw` geändert, jeder Anker traf genau einmal. Danach habe ich sie aus der Sicherung im Scratchpad zurückkopiert. `cmp` meldete byte-gleich, `git diff HEAD -- Eudora71` war leer.

| Lauf | Änderung (vorübergehend, AboutDlg.cpp) | Ergebnis |
|---|---|---|
| 0 | keine | 398/398 |
| G1 + G2 | G1: `x += nBreite + nAbstand;` → `x += nAbstand;` (alle Knöpfe liegen übereinander, um je 10 Pixel versetzt). G2: `if (!pZeile …)` → `if (pZeile …)` (die Pfadzeilen werden nie verbreitert) | **398/398, grün** (K3) |
| P (Positivprobe, zusätzlich zu G1 + G2) | `ON_BN_CLICKED(IDC_ABOUT_LATEST_RELEASE, …)` auskommentiert | 397/398, rot nur an „Knopf Latest Release hat keinen Handler im MESSAGE_MAP“. Der Test liest also meinen Baum. |
| 0' | alles zurück | 398/398 |

## 4. Funde

### <a id="k1"></a>K1 (gering): die Zeile *Log:* ist mit der Vorgabe abgeschnitten

`IDC_ABOUT_LOG_PATH` ist weiter 10 DLU hoch (EudoraRes.rc:394), das sind 16 Pixel, also eine Zeile. Der Text lautet `Log: <EudoraDir><LogFileName>  (LogLevel=<n>, keine E-nn-Marken)` (AboutDlg.cpp, E-132-Block). Die Vorgabe ist `LogFileName=eudora.log` und `LogLevel=25759` (EudoraRes.rc:8472-8473). 25759 & 32768 = 0, also wird der Zusatz in der Vorgabe immer angehängt. Gemessen in `ANSI_VAR_FONT` bei 482 Pixeln Breite:

| Text (Beispiel) | einzeilig | nötig |
|---|---|---|
| `Log: C:\Users\Al\AppData\Roaming\Qualcomm\Eudora\eudora.log  (LogLevel=25759, keine E-nn-Marken)` | 511 px | 2 Zeilen |
| `Log: C:\Users\Gregor\AppData\Roaming\…\eudora.log  (LogLevel=25759, keine E-nn-Marken)` | 534 px | 2 Zeilen |
| `Log: C:\Users\Gregor\Eudora72-7.2.1.131\Mailverzeichnis\eudora.log  (LogLevel=25759, keine E-nn-Marken)` | 522 px | 2 Zeilen |
| dieselbe Zeile mit `LogLevel=58527` | 426 px | 1 Zeile |

- **Was passiert:** Die zweite Zeile ist unsichtbar. Es fehlt ausgerechnet der Hinweis *„keine E-nn-Marken“*, also die Auskunft, für die [E-132](../Intern/BEFUNDE.md#e-132) die Zeile eingeführt hat. *Copy info* kopiert den vollen Text. Ein Ticket ist also vollständig, nur der Dialog zeigt den Hinweis nicht.
- **Wie oft:** Bei jedem, der `LogLevel` nicht geändert hat und dessen Pfad nicht sehr kurz ist. Mit Application Data ist das schon bei einem Benutzernamen aus zwei Buchstaben der Fall. Vor [E-216](../Intern/BEFUNDE.md#e-216) war die Zeile 420 Pixel breit und damit noch öfter abgeschnitten. Neu ist der Fehler also nicht, nur nicht mitbehoben. Gregors eigene Zeile passt vermutlich, weil sein `LogLevel` 32768 enthält. Das ist eine Vermutung.
- **Gilt auch für** *Data*, *Application*, *INI*, *Default INI*, wenn der Pfad länger als etwa 95 Zeichen ist. Auch ein Pfad ohne Leerzeichen wird umbrochen, und die zweite Zeile ist dann unsichtbar (gemessen mit `DrawText DT_WORDBREAK`: 114 Zeichen ergeben 2 Zeilen). Das kommt selten vor.
- **Behebung, Aufwand:** Am billigsten ist ein kürzerer Zusatz, etwa `(LogLevel=25759: no E-nn)`. Das ist eine Zeile Code. Gründlicher wäre es, die Zeile *Log* wie *Mail folder from* auf 20 DLU zu setzen. Dann müssen *Mail folder from* um 10 DLU und die Knopfreihe auf 254 DLU rücken, und der Dialog wird 279 DLU hoch. Das sind vier Zahlen in EudoraRes.rc. Der Test prüft nur `y + h <= lKnopfOben` und zieht deshalb mit.
- **Hält das Paket nicht auf.**

### <a id="k2"></a>K2 (sehr gering): *Mail folder from* mit Pfad kann mehr als zwei Zeilen brauchen

Alle festen Herkunftstexte passen in zwei Zeilen (gemessen). Der längste ist *„Registry: … – [E-132](../Intern/BEFUNDE.md#e-132): fremdes Verzeichnis, frueher mit "Ja" bestaetigt (Zeile E132Angenommen in DEudora.ini loescht den Merker)“* mit 178 Zeichen und 874 Pixeln. Er braucht 2 Zeilen. Der Text von [E-133](../Intern/BEFUNDE.md#e-133) enthält aber den vollen alten Pfad (eudora.cpp:4705). Mit 146 Zeichen sind es noch 2 Zeilen. Ab einem Pfad von etwa 90 Zeichen wären es 3, und die dritte wäre nur angeschnitten. Das ist aus der Messung hochgerechnet. Es kommt nur vor, wenn ein gespeichertes Mailverzeichnis fehlte und sein Pfad lang ist, also sehr selten. *Copy info* hat den vollen Text. Die Behebung wäre 30 DLU Höhe, aber das kostet Platz für einen Randfall. Ich empfehle, es so zu lassen.

### <a id="k3"></a>K3 (gering, Prüfmittel): Test und Prüfstand sehen die Rechnung nicht

- **Test:** `TestE216.cpp` prüft nur Text in Ressource und Code. G1 und G2 bleiben grün (gemessen, Abschnitt 3). G1 legt alle Knöpfe übereinander, also genau den gemeldeten Fehler in schlimmer. Den fängt der Test nicht.
- **Prüfstand:** `messen-about.ps1` fängt G1 über `ueberlappt=`. G2 (keine Verbreiterung) fängt er nicht. `herkunft-zeilen` ist Höhe durch Zeilenhöhe, also nur das Fassungsvermögen, nicht der Bedarf. Mit 420 statt 482 Pixeln bleibt der Wert 2. `passt=` und `ausserhalb=` werden gemessen, stehen aber nicht in der Zeile `ABOUT ERGEBNIS` und damit nicht in der Erwartung von E-216p (pruefstand-faelle.txt:454). Das habe ich aus dem Skripttext geschlossen, nicht am Prüfstand gefahren.
- **Wie oft / was schiefgeht:** Nur bei einer späteren Änderung am Dialog. Dann bliebe eine falsche Rechnung grün.
- **Behebung, Aufwand:** `herkunft-passt=` und `rand=` in die Zeile `ABOUT ERGEBNIS` aufnehmen und dazu eine Zeile *Log* messen (siehe K1). Das sind wenige Zeilen in messen-about.ps1 und eine Zeile Erwartung. Einen Test des Verhaltens im Quelltext würde ich für die Knopfreihe nicht bauen, der Prüfstand misst das besser.
- **Hält das Paket nicht auf.**

### <a id="k4"></a>K4 (gering): *Latest Release* ist nie gedrückt worden, und dem Testschritt fehlt ein Merkmal

- Der Prüfstand drückt den Knopf bewusst nicht, damit kein Browser aufgeht (messen-about.ps1, Kopf (3)). Der Test prüft nur den Text. Der Handler ist also nie gelaufen. Belegt.
- Der Erfolg wird an `hInstApp > 32` erkannt. Laut Schnittstellenbeschreibung setzt `ShellExecuteEx` diesen Wert bei Erfolg zuverlässig nur mit `SEE_MASK_NOCLOSEPROCESS`. In der Praxis setzt Windows 42, und `HilfeSeiteOeffnen` macht es genauso. Ob das auch für eine `https:`-Adresse gilt, wo ein Protokoll-Handler statt einer Dateizuordnung greift, ist nicht gemessen. Wenn nicht, ginge der Browser auf, **und** es käme die Fehlermeldung. Das ist eine Vermutung, ich halte es für unwahrscheinlich.
- TESTPLAN, Abschnitt `e-216-naechstes`, Schritt 2: *„Bestanden:“* nennt Browser und Seite, aber nicht „es kommt keine Meldung von Eudora“. Ein Fehlalarm neben einem geöffneten Browser würde leicht als bestanden durchgehen.
- **Behebung, Aufwand:** Einen Halbsatz im Testplan ergänzen, dazu optional die Logzeile `About: Latest Release geoeffnet` als Merkmal nennen (sie steht nur mit `DEBUG_MASK_MISC`). Das kostet nichts. Wäre der Fehlalarm echt, könnte man im Code `bGut` allein entscheiden lassen. Das wäre eine Zeile, auch in mainfrm.cpp.
- **Hält das Paket nicht auf.** Es ist Gregors Testschritt, der den Weg zum ersten Mal fährt.

### <a id="k5"></a>K5 (sehr gering): die anklickbaren Pfadzeilen sind breiter geworden

*Data* und *Application* sind `CDirectoryStatic` (DDX_Control, :684-685). Sie nehmen jeden Klick auf ihrer ganzen Fläche an (`OnNcHitTest` → `HTCLIENT`, :80) und öffnen das Verzeichnis (:97ff). Mit der Verbreiterung von 420 auf 482 Pixel reicht die Fläche bis 7 Pixel an den Rand. Ein Klick ins Leere neben dem Text öffnet den Ordner im Explorer. Das war vorher auch so, nur auf einer schmaleren Fläche. Belegt. Es ist harmlos, und ich empfehle keine Änderung.

### <a id="k6"></a>K6 (sehr gering): doppeltes Verstecken im Startbild

Der Konstruktor versteckt nach `Create` noch einmal *Close*, *Credits* und *Visit Web Site* (:303-311). Das hat `OnInitDialog` schon erledigt, und zwar für alle fünf Knöpfe. Es ist harmlos. Wer aufräumt, kann die Stelle streichen. Belegt.

### <a id="k7"></a>K7 (sehr gering): `releases/latest` überspringt Vorabversionen

Siehe Abschnitt 2. Das betrifft nur den Fall, dass ein Paket als *Pre-release* auf GitHub kommt. Bisher sind alle Releases normale Releases (`gh release list`, gemessen). Eine Entscheidung braucht es nur, falls 7.2.2.x als Vorabversion erscheinen soll.

## Übersicht

| Fund | Was passiert | Wie oft | Schwere | Hält das Paket auf? |
|---|---|---|---|---|
| K1 | Zeile *Log:* einzeilig, der Hinweis „keine E-nn-Marken“ ist abgeschnitten, ebenso lange Pfade in Data/Application/INI | fast immer mit `LogLevel` aus der Vorgabe; lange Pfade selten | gering | nein (billig mitzunehmen) |
| K2 | *Mail folder from* mit langem E-133-Pfad braucht 3 Zeilen | sehr selten | sehr gering | nein |
| K3 | Test grün bei übereinanderliegenden Knöpfen und ohne Verbreiterung; Prüfstand-Ergebnis ohne `passt`/`rand` | nur bei künftigen Änderungen | gering | nein |
| K4 | *Latest Release* nie gedrückt; Testschritt nennt „keine Meldung“ nicht; `hInstApp` ohne `NOCLOSEPROCESS` | einmal, bei Gregors Test | gering | nein |
| K5 | Pfadzeilen *Data*/*Application* auf breiterer Fläche anklickbar | gelegentlich, harmlos | sehr gering | nein |
| K6 | Startbild versteckt drei Knöpfe doppelt | immer, ohne Wirkung | sehr gering | nein |
| K7 | `releases/latest` überspringt Vorabversionen | nur bei Pre-release | sehr gering | nein |
