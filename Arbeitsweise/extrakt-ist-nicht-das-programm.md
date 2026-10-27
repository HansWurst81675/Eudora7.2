---
name: extrakt-ist-nicht-das-programm
description: Ein ausgeschnittener Pruefstand misst die Regel, nicht ihre Verwendung - Lebenslauf, Aufrufstellen und Uebersetzbarkeit bleiben ungeprueft; am 19.10.2026 dreimal an einem Tag
metadata:
  type: feedback
---

Schranke: tools/bauen.ps1 (drei Messpunkte: Fehlermeldungen im Protokoll, Eudora.exe aelter als die Quellen, Versionsressource gegen Version.h) - sie haben den dritten Fall gefangen. Fuer Lebenslauf und Aufrufstellen fehlt tools/pruefe-extrakt.pl, Spezifikation in Befunde/CHRONIST-2026-10-19.md

Der Prüfstand schneidet mit `Extract.ps1` Regionen aus dem Produktivcode aus.
Das ist richtig — und genau das Heraustrennen macht einen Spalt auf: der
Extrakt hat einen **anderen Lebenslauf**, **andere Aufrufer** und eine
**andere Reihenfolge** als das Original. In den Worten von PRUEFER-38: *„die
Regel ist richtig geprüft, ihre Verwendung nicht."*

**Why:** Am 19.10.2026 dreimal im selben Code, jedes Mal bei 222/222 grün —
(1) E-69 wäre nach dem ersten Filterlauf **stumm** gewesen, weil jeder
Testblock ein frisches `CE69Sammlung` anlegt, Eudora aber eine globale
Variable hat (R1); (2) die Klammer fehlte an vier Schleifen, darunter am
**IMAP-Weg**, also am Anlassfall des Commits (R2); (3) **Eudora übersetzte
nicht** (C3861, C2065), weil `Extract.ps1` die Funktion ausschneidet und die
Reihenfolge im Original nicht kennt.

**How to apply:** Drei Fragen, jedes Mal, wenn `Extract.ps1` eine neue Region
bekommt. **Lebenslauf:** lebt das Geprüfte im Original länger als ein
Testblock (global, `static`, `__declspec(thread)`)? Dann muss mindestens ein
Test **über zwei Blöcke hinweg auf demselben Objekt** laufen. **Aufrufstellen:**
sind alle Aufrufer abgedeckt? Das findet kein Test von innen, nur eine
Schranke, die die Stellen im Baum zählt. **Übersetzbarkeit:** ein grüner
Prüfstand ist kein Beleg, dass das Programm baut — erst `bauen.ps1`, dessen
drei Messpunkte Fall 3 gefangen haben. Siehe [[pruefstand-kann-blind-sein]],
[[schranke-gegentesten]], [[nie-benutzt-ist-nicht-geprueft]].

## Nachtrag 25.10.2026 spät (CHRONIST): der Quelltexttest las die falsche Funktion

Zeiten MEZ, belegt an Commits und Berichten. Die erste Behebung von [[E-137]] (`ed0d53a2`, 19:37) fing Strg+W in `CMainFrame::OnCmdMsg` ab, und zwar „bevor der Befehl an das Wazoo-Fenster weitergeht“. `TestE137.cpp` prüfte genau das: Mit `QT_Abschnitt` schnitt er den Rumpf von `OnCmdMsg` aus und verlangte, dass die Abfangung vor der Zeile `CWazooWnd* pWazooWnd = GetWazooWindowWithFocus();` steht. Rote Probe ohne Behebung 301/302, mit Behebung 302/302. PRUEFER-55 (19:55) fand vier von fünf Rückfällen unsichtbar, den Weg aber nicht. Erst PRUEFER-56 (20:20) zeigte, dass die Behebung **nie erreicht** wurde: `CMainFrame::OnCommand` gibt den Befehl schon vorher an das Wazoo-Fenster, von dort geht er über das Dokument an `CDoc::OnFileClose`, und das schickt `WM_CLOSE` an den Rahmen. Angedockt ist das der Hauptrahmen (am Quelltext belegt, nicht gemessen). Um 20:23 wurde die Abfangung verlegt (`78f2ad2a`). Auf `main` kam die unwirksame Fassung nie, PR #174 war schon um 18:40 gemergt.

**Was es früher gezeigt hätte (gemessen an `ed0d53a2:mainfrm.cpp`):** Die Ankerzeile des Tests, `GetWazooWindowWithFocus();`, steht in derselben Datei **zweimal**: in Zeile 3408 (`OnCommand`) und in Zeile 3498 (`OnCmdMsg`). Eine einzige Suche nach dem eigenen Anker hätte zwei Weitergaben gezeigt, und der Test bewachte nur eine davon. Der Test prüfte, ob die Regel richtig steht, aber nicht, ob der Befehl die Funktion überhaupt erreicht. Das ist dieselbe Klasse wie die Extrakte vom 19.10., nur ohne `Extract.ps1`: `QT_Abschnitt` schneidet eine Funktion aus, und alles außerhalb des Schnitts ist unsichtbar.

**How to apply, zusätzlich:**
- **Ein Test der Form „A steht vor B“ zählt B im ganzen Baum.** Kommt B mehr als einmal vor, gibt es mehr als einen Weg, und jeder braucht eine eigene Prüfung oder einen Grund, warum er nicht zählt.
- **Bei einem Befehlsweg (`WM_COMMAND`, `OnCmdMsg`, `OnCommand`, `PreTranslateMessage`) wird der Weg vom Eingang an gelesen**, nicht von der Stelle an, an der die Behebung passt. Bei E-137 stand der Eingang 60 Zeilen über der Behebung, mit dem Kommentar *„change the standard command routing to include the Wazoo window“*.
- Eine rote Probe beweist nur, dass der Test den **Text** sieht. Ob der Weg dort vorbeikommt, beweist sie nicht ([[test-prueft-den-ausstieg]], [[gegenprobe-umdrehen]]).

**Vorschlag für eine Schranke (nicht gebaut):** `QT_Abschnitt` bekommt eine Schwester `QT_Eindeutig(pCode, "<anker>")`, die rot meldet, wenn ein Anker im **ganzen** Datei-Code mehr als einmal vorkommt. Gegenprobe: `TestE137.cpp` auf dem Stand `ed0d53a2` mit diesem Aufruf für `GetWazooWindowWithFocus();` muss rot werden, auf `78f2ad2a` (Abfangung in `OnCommand` vor der ersten Weitergabe) grün.

## Nachtrag 27.10.2026 (CHRONIST): grün, nicht übersetzbar und nie ausgeführt

Zeiten MEZ, gemessen am Transkript, belegt an `Befunde/PRUEFER-61.md`. Der dritte und der vierte Anlauf zu [[E-137]] zeigen alle drei Fragen dieser Datei auf einmal:

- **Übersetzbarkeit.** 26.10. 14:01: *„The counter-test is red without the fix (311/312) and green with it (312/312)“*, 14:04 an Gregor: *„I've fixed it and pushed (commit `0b0b50de`)“*. Übersetzt hat der Code erst um 20:47, weil eine Einbindung fehlte (20:58: *„Der Unit-Test liest nur den Quelltext und hat das nicht gemerkt“*). Sechs Stunden lang stand „behoben“ für Code, der nicht baute. Fall 3 vom 19.10., wörtlich.
- **Lebenslauf (hier: gibt es das Objekt überhaupt?).** Beide Anläufe saßen in Handlern von `QCMiniDockFrameWnd`. `mainfrm.cpp:1791` setzt diese Klasse, aber `EnableDocking` fünfzehn Zeilen später überschreibt sie in MFC ausnahmslos mit `CMiniDockFrameWnd` (`winfrm2.cpp:51`). **Kein schwebender Rahmen ist je ein `QCMiniDockFrameWnd`**, keine Zeile der Behebung lief jemals. Die Quelltexttests waren grün, die rote Probe auch, denn sie sahen den Text.
- **Ein Kommentar als Beleg.** PRUEFER-60 hatte den dritten Anlauf bestätigt, gestützt auf `mainfrm.cpp:1791` und den Kommentar `OTShim.h:993-994`. PRUEFER-61 schreibt dazu: *„Den Aufruf danach habe ich nicht nachgerechnet.“* ([[schranke-liest-nur-code]], [[befund-gegen-die-quelle-lesen]].)

Was es gelöst hat, war kein besserer Quelltexttest, sondern ein Fall, der das **laufende** Programm fragt: `tools/messen-e137.ps1` klickt per Fensterbotschaft auf Titelzeile und Rand und prüft, ob das Fenster dahinter offen bleibt. Rot an 1.0.125 (27.10. 12:48), grün an 1.0.126 (12:49). Er entstand erst auf Gregors Frage ([[erst-nachstellen-dann-ausliefern]], Nachtrag 27.10.).

**How to apply, zusätzlich:**
- **Eine Behebung in einer Klasse beginnt mit dem Beweis, dass ein Objekt dieser Klasse zur Laufzeit existiert:** eine Spurzeile im Konstruktor oder ein Prüfstandsfall. Bei Fensterklassen, die über `RUNTIME_CLASS` gesetzt werden, den Weg bis zum `new`/`CreateObject` lesen, nicht bis zur Zuweisung.
- **„Behoben“ an Gregor erst nach `bauen.ps1`**, nie nach den Unit-Tests allein.
- Die Spurzeile, die 1.0.125 schreiben sollte (`E-137 Klick auf den Rahmen`), stand im Bau (PAKETE.md belegt es) und in Gregors Protokoll fehlte sie. Das Ausbleiben war hier der Befund; er wurde gelesen (26.10. 22:19) ([[ausbleiben-ist-kein-befund]]).
