# <a id="pruefer-82"></a>PRUEFER-82

Lauf nach [PRUEFER-81](PRUEFER-81.md#pruefer-81), geprüft: `6c95e284..HEAD -- Eudora71 tools Releases/1.0` (a7e05aef, c301a8a0, 782c6908, dcedef85, 214a0879), Zweig wt/pruefer-20261102b (von `origin/e143_suchfenster`). Schwerpunkt [E-143](../Intern/BEFUNDE.md#e-143) Suchfenster, dazu die Messskripte `messen-e143s.ps1` und `messen-e178.ps1`. Nichts gestartet; die Prüfstände `C:\Temp\E143S`, `C:\Temp\E178` und `C:\Temp\E178-alt` nur gelesen.

## Ergebnis vorweg

Die Änderung im Suchfenster tut, was sie soll: Werden mehrere empfangene Treffer nach Out übertragen, kommt der Hinweis einmal statt je Treffer, und verfasste Nachrichten gehen weiter durch. Das steht so im Quelltext und im Protokoll des Prüfstands, und die Testsuite läuft bei mir durch. Eine kleine Nebenwirkung habe ich gefunden: Liegt eine empfangene Nachricht schon in Out und wird aus dem Suchfenster nach Out übertragen, kam vorher gar nichts, jetzt kommt der Hinweis. Der Test fängt nicht ab, wenn jemand den Hinweis in die Schleife zurückschiebt.

Wichtiger ist ein Fund an der Messung zu [E-178](../Intern/BEFUNDE.md#e-178). Die Antwort auf markierten Text ist am neuen Bau **nicht** gemessen. Die gespeicherte Antwort in `C:\Temp\E178\Mailverzeichnis\Out.mbx` zitiert die ganze Nachricht, nicht die Markierung. Eudora hat also gar keine Markierung bekommen, und die reparierte Stelle `GetSelectedHTML` lief nicht. Am alten Bau zitiert dieselbe Messung nur die Markierung. „antwort=passt“ ist damit kein Beleg, und weil der TESTPLAN Gregors Test für [E-178](../Intern/BEFUNDE.md#e-178) gestrichen hat, prüft diesen Weg im Moment niemand. Dazu ein Originalfehler von QUALCOMM, den die Messung nebenbei sichtbar macht, ohne ihn zu bemerken: *Festbreite* im Bearbeiten-Modus schreibt die Zeichen `t;` in den Text (neu: [E-199](../Intern/BEFUNDE.md#e-199)).

Für das Paket: Der Suchfenster-Teil hält nichts auf. Bei [E-178](../Intern/BEFUNDE.md#e-178) muss vor dem Paket die Aussage über die Antwort berichtigt oder nachgemessen werden.

## 1. Die Behebung im Suchfenster am Quelltext

- **Die Schleife** (SearchView.cpp:3847-3921): `bE143NachOut` wird einmal aus `pDestTocDoc->m_Type == MBT_OUT` bestimmt (:3847). Das ist dasselbe Objekt und dieselbe Bedingung, die `CTocDoc::Xfer` als `ToOut` prüft (tocdoc.cpp:2624). Übersprungen wird genau, was Xfer abgelehnt hätte: `!pSum->IsComp()` (:3882 gegen tocdoc.cpp:2754). Am Quelltext belegt.
- **Gemischte Auswahl**: verfasste Treffer laufen weiter durch Xfer (:3889-3892), empfangene werden gezählt. Der Hinweis kommt einmal nach `CloseProgress()` (:3912-3921). Sein Text lautet *„Messages can't be transferred to the Out mailbox. To send this message again, …“* (EudoraRes.rc:2048). Er sagt nicht, dass die Entwürfe übertragen wurden. Das ist der bekannte Punkt „gemischte Auswahl“ aus [PRÜFER-45](PRUEFER-45.md) im E-143-Eintrag, kein neuer Fund. Am Quelltext belegt, am Programm nicht gemessen (das Messskript legt nur empfangene Treffer an).
- **Kopie mit Shift**: Die E-125-Ablehnung in Xfer fragt `Copy` nicht ab (tocdoc.cpp:2754). Vorher wurde also auch eine Kopie abgelehnt, und jetzt wird sie ebenso übersprungen. Gleiches Verhalten. Am Quelltext belegt.
- **IMAP-Entwürfe (E-142-Frage)**: Verfasste IMAP-Treffer gehen weiter einzeln an Xfer. `E142Gefragt` ist eine lokale Variable je Aufruf (tocdoc.cpp:2646), die Frage kommt also weiter **je Treffer**, und *Nein* bricht nur diesen einen Treffer ab. Das steht als offener Rest im E-143-Eintrag; ich bestätige es am Quelltext, gemessen ist es nicht. Ein aus IMAP neu geladener Entwurf gilt nicht mehr als verfasst ([E-142](../Intern/BEFUNDE.md#e-142), Nachtrag T4). Er wird jetzt gezählt und übersprungen, also wie vorher abgelehnt, nur ohne eigenen Dialog.
- **Escape**: `PumpEsc` steht nur hinter Xfer (:3906). Der Überspringzweig pumpt nicht, aber er tut auch nichts, was dauert. Bricht der Anwender mit Escape ab, kommt der Hinweis trotzdem für die bis dahin gezählten Treffer. Die Logzeile nennt dann als „von m“ die ganze Auswahl (`SelIdxList.size()`, :3918), nicht die bearbeiteten Treffer. Das ist nur eine kleine Unschärfe in der Spur, kein Fund. Am Quelltext belegt.
- **Fortschritt**: Der Überspringzweig ruft `ProgressAdd(1)` vor `continue` (:3885). Die Balkensumme stimmt. Am Quelltext belegt.
- **Nebenwirkung, die zum Guten ausfällt**: Xfer leerte die Undo-Listen vor der Ablehnung (tocdoc.cpp:2606-2612; das ist K4 aus PRÜFER-58 für [E-142](../Intern/BEFUNDE.md#e-142)). Übersprungene Treffer rufen Xfer nicht mehr auf und leeren nichts mehr. Am Quelltext belegt.
- **Am Prüfstand**: `C:\Temp\E143S\Mailverzeichnis\eudora.log`, Zeile 65: `E-143 Suchfenster nach Out: 3 von 3 Treffern abgelehnt (empfangen), ein Hinweis`, danach genau ein `Dialog:` mit dem Hinweistext. `Out.mbx` ist 0 Byte groß. Gemessen (vom Hauptagenten, von mir nachgelesen).

## 2. Testsuite und Gegenproben (in meinem Baum)

Gemessen, `cmd /c Eudora71\Tests\RunTests.cmd`:

| Lauf | Änderung (vorübergehend, SearchView.cpp) | Ergebnis |
|---|---|---|
| 1 | keine | 361/361 |
| G1 | `AlertDialog` in den Überspringzweig, nach der Schleife entfernt | **360/361**, rot `Test_E143_Suchfenster` (*„empfangene Treffer nach Out gehen wieder einzeln an Xfer“*) |
| G1b | den ganzen Block `if ( nE143Abgelehnt > 0 ) { … AlertDialog … }` **in** die Schleife vor `ProgressAdd(1)` verschoben | **361/361, grün** (K4) |
| G2 | `PutDebugLog` der E-143-Zeile auskommentiert | **361/361, grün** (K4) |

Nach jedem Lauf zurückkopiert; `cmp` gegen die Sicherung ergab keinen Unterschied, `git status` war leer.

## 3. Die Messskripte

**messen-e143s.ps1.** Der Weg ist getroffen. Die Befehlsnummer für *Transfer → Out* kommt aus dem Hauptmenü und geht als `WM_COMMAND` an die Suchansicht. Dort fängt sie `ON_COMMAND_EX_RANGE` in `CSearchView::OnDynamicCommand` ab. Das Protokoll zeigt die E-143-Zeile, also lief genau diese Schleife (gemessen). Die Dialoge werden einzeln gezählt, und jeder wird erst als geschlossen gewertet, wenn sein Fenster weg ist. Lücken siehe K5.

**messen-e178.ps1.** Den Bearbeiten-Modus erreicht das Skript über `umsgButtonSetCheck` und `ID_EDIT_MESSAGE`; nachgewiesen ist er über `isContentEditable`. Das hält. Die Befehle laufen als `WM_COMMAND` an das Nachrichtenfenster. Das Urteil `passt` prüft aber nur zweierlei: dass 🔥 und Ж im Dokument stehen und dass zwischen „Vierbyte“ und „Euro“ kein `?` steht. Dass ein Befehl gewirkt hat oder der Text sonst heil ist, prüft es nicht. Siehe K1 bis K3.

## Funde

### K1 — E-178, Antwort auf markierten Text: am neuen Bau nicht gemessen, die Antwort zitiert die ganze Nachricht

**Was passiert.** Die gespeicherte Antwort am neuen Bau (`C:\Temp\E178\Mailverzeichnis\Out.mbx`, 11:18:55) enthält die **ganze** Prüfnachricht: `<body>`, `<p>E-136 Pruefnachricht.</p>`, alle drei Listenpunkte einschließlich „Euro“ und den Satz „Erwartet nach Strg-S …“. Die Tags sind klein geschrieben, so wie in der Postfachdatei. Am alten Bau (`C:\Temp\E178-alt\Mailverzeichnis\Out.mbx`, 11:17:44) enthält die Antwort mit demselben Skript nur die Markierung: `<LI>Vierbyte-Zeichen: ??</LI>` und `<LI>Kyrillisch: ?</LI>`, mit großen Tags, wie MSHTML sie liefert. Gemessen (beide Dateien gelesen; ebenso die Zeile `E-89 Bilder im Editor … anfang=[…]` in beiden `eudora.log`).

**Was das heißt.** Ohne Markierung liefert `CMessageDoc::GetSelectedText` 0 (msgdoc.cpp:596-641). Dann übergibt `ComposeMessage` `pSelText = NULL` (msgdoc.cpp:590), und Eudora zitiert die ganze Nachricht. `CTridentView::GetSelectedHTML` (TridentView.cpp:3904-3962) ist die Stelle, die [E-178](../Intern/BEFUNDE.md#e-178) repariert hat. Sie lief am neuen Bau nicht bis zur Umwandlung, oder sie fand keine Textauswahl. Am Quelltext belegt. „antwort=passt“ misst deshalb nur, dass die ganze Nachricht ihre Entitäten behält. Das tat sie schon vor [E-178](../Intern/BEFUNDE.md#e-178). Die Gegenprobe „antwort=kaputt“ am alten Bau ist dagegen echt.

**Warum die Markierung fehlte** — Vermutung, nicht gemessen. Entweder kam `select()` des Skripts nicht als Auswahl im Dokument an: Ob es eine gibt, kann das Skript nicht prüfen, `document.selection` ist über IDispatch nicht erreichbar (messen-e178.ps1:257). Oder der neue Bau verliert die Auswahl selbst. Das zweite wäre ein Funktionsfehler: Wer auf markierten Text antwortet, bekäme die ganze Nachricht zitiert. Die Änderung an `GetSelectedHTML` (26dfa116, eine Zeile) kann das nicht auslösen, denn ein leerer Rückgabewert von `E136HtmlAusBstr` ergäbe `<html></html>` und kein Vollzitat. Darum halte ich das erste für wahrscheinlicher, ausgeschlossen ist das zweite nicht.

**Folgen für die Buchführung.** In BEFUNDE.md ([E-178](../Intern/BEFUNDE.md#e-178)) steht „bleiben Emoji und Kyrillisch bei … Antwort erhalten“. Im TESTPLAN steht „Für Gregor entfällt dieser Test vorerst — er misst sich am Prüfstand“ (Intern/TESTPLAN.md:229). Zusammen heißt das: Die Antwort auf markierten Text prüft im Moment niemand. Nebenbei: BEFUNDE.md sagt bei [E-178](../Intern/BEFUNDE.md#e-178) „Gregors Test steht aus“, der TESTPLAN sagt „entfällt“. Belegt (beide Dateien gelesen).

**Vorschlag.** Im Skript nach der Antwort prüfen, dass `Out.mbx` **nur** die Markierung zitiert, also kein „Euro“ und kein „Erwartet“. Sonst `antwort=-` mit Grund ausgeben statt `passt`. Dann an beiden Bauten nachmessen. Bleibt das Vollzitat am neuen Bau, ist es ein Funktionsfehler (dafür E-200 nehmen). Bis dahin in [E-178](../Intern/BEFUNDE.md#e-178) und im TESTPLAN „Antwort: nicht gemessen“. **Schwere: wichtig** (Messlücke an einem Weg mit Datenschaden; möglicher Funktionsfehler). **Hält das Paket auf:** nur die Aussage. Vor dem Paket nachmessen oder berichtigen.

### K2 — E-199: *Festbreite* im Bearbeiten-Modus schreibt `t;` in den Text (Originalfehler von QUALCOMM)

**Was passiert.** Nach dem Messlauf steht in `C:\Temp\E178\Mailverzeichnis\In.mbx` (gespeicherte Fassung, 11:18:36) `<LI><TT>t;Vierbyte-Zeichen: …` und weiter unten `<LI>t; <BR>`. Am alten Bau (`C:\Temp\E178-alt\…\In.mbx`, 11:17:26) steht `<LI><TT>t;Vierbyte-Zeichen: ??` und `<P>E</P></LI>…<P>t;rwartet nach Strg-S`. Dort ist also zusätzlich ein Buchstabe aus „Erwartet“ in einen eigenen Absatz gerutscht. Gemessen (beide Dateien gelesen). Das Messskript wertet beides als `passt` bzw. nur wegen der `?` als `kaputt`.

**Ursache, am Quelltext belegt.** `WrapTag` (TridentReadMessageView.cpp:4074-4077, ebenso `SplitTagOff` :3639-3642) wandelt den Platzhalter `<…ON>` mit `Text2Html` und schneidet danach zwei Zeichen ab, Kommentar `// strip "\r\n"`. `Text2Html` hängt `"\r\n"` aber nur an, wenn die Zeile auf `\r` endet (Text2Html.cpp:1045-1056). Der Platzhalter hat kein `\r`. Abgeschnitten wird deshalb `t;` von `&gt;`. `Find` (:4082, :4095) findet dann den Platzhalter ohne die letzten zwei Zeichen, und `t;` bleibt im Dokument stehen. `Text2Html.cpp` ist bis auf eine Zeile (2fb15664, `strchr`) unverändert seit dem ersten Commit 567a5d87, also ein Originalfehler. Nicht neu durch [E-178](../Intern/BEFUNDE.md#e-178). `befund-suchen.pl` findet zu `WrapTag` keinen Eintrag; die Treffer zu `Text2Html` ([E-196](../Intern/BEFUNDE.md#e-196), [R-1](../Intern/BEFUNDE.md#r-1)) betreffen anderes.

**Wann es den Anwender trifft.** Wer im Bearbeiten-Modus einer empfangenen Nachricht Text markiert und *Festbreite* gibt, hat danach sichtbaren Zeichenmüll im Text, und *Strg-S* speichert ihn. Vermutung: Das kommt selten vor (Bearbeiten-Modus plus Festbreite). **Behebung (Vorschlag):** nur abschneiden, wenn `Right(2) == "\r\n"`, an beiden Stellen. **Schwere: klein.** **Hält das Paket auf:** nein.

### K3 — messen-e178.ps1: „passt“ sieht nur die zwei Zeichen

Das Urteil (`Zustand`, messen-e178.ps1:222-232; Datei :405-412) prüft nur, ob 🔥 und Ж erhalten sind und ob ein `?` vorkommt. Drei Dinge entgehen ihm. Erstens ein Befehl, der nicht wirkt: Nach dem Link steht `<A href="http://e178.invalid/"><EM></EM></A>`, ein **leerer** Link neben dem Emoji statt eines Links um den markierten Text (In.mbx, gemessen; ob das am Skript oder am Programm liegt, ist nicht gemessen). Zweitens der Zeichenmüll aus K2. Drittens das Vollzitat aus K1. Außerdem ist `gespeichert=kaputt` am alten Bau nur die Folge von `tt=kaputt`: Vor dem Speichern wird nicht zurückgesetzt (:376 setzt nur **vor** einem Schritt zurück). Damit ist es kein eigener Beleg für den Speicherweg. Am Quelltext belegt. Vorschlag: je Schritt eine Wirkprobe (`<TT>`, `<A href=…>` mit Text) und ein Vergleich des sichtbaren Texts ohne Tags mit dem Ausgangstext. **Schwere: klein.** **Hält das Paket auf:** nein.

### K4 — Suchfenster: Test fängt einen Hinweis in der Schleife nicht; Out nach Out zeigt jetzt einen Hinweis

- **Test.** In Gegenprobe G1b habe ich den Hinweisblock in die Schleife verschoben, und der Test bleibt grün (gemessen). Dann käme der Hinweis wieder mehrfach, und zwar nach jedem weiteren Treffer, sobald einer abgelehnt ist. `QT_Zaehle(...) == 1` und `QT_Enthaelt("if ( nE143Abgelehnt > 0 )")` prüfen nicht, **wo** der Block steht. Auch die Logzeile prüft der Test nicht (G2 grün). Gregor hatte bei [E-143](../Intern/BEFUNDE.md#e-143) „zusätzlich eine zeile im log“ verlangt (Entscheidung vom 01.11., für den Filterteil). Vorschlag: den Abschnitt ab `CloseProgress();` schneiden und dort `AlertDialog( IDD_XFER_TO_OUT_REFUSED );` und `"E-143 Suchfenster nach Out:` verlangen.
- **Out nach Out.** Bisher gab Xfer bei `TargetToc == this` die Nachricht still zurück, und zwar **vor** der E-125-Ablehnung (tocdoc.cpp:2553-2564). Jetzt wird eine Nachricht, die schon in Out liegt und nicht `IsComp()` ist, vorher gezählt, und der Hinweis „can't be transferred to the Out mailbox“ erscheint. Er ist falsch, denn sie liegt schon dort. Erreichbar ist das mit Altbestand aus 7.1, bei dem empfangene Nachrichten nach Out gezogen wurden, oder mit dem Status *Recovered* (`IsComp` schließt `MS_RECOVERED` aus, summary.h:276-277). Am Quelltext belegt, nicht gemessen. Vorschlag: `bE143NachOut && pTocDoc != pDestTocDoc && !pSum->IsComp()`.

**Schwere: klein.** **Hält das Paket auf:** nein.

### K5 — E-143s: Gegenprobe falsch beschriftet; gemischte Auswahl ungemessen

- Commit 782c6908 und BEFUNDE.md ([E-143](../Intern/BEFUNDE.md#e-143)) nennen die Gegenprobe „am Bau `7.2.1.130+034162bc`“. Das Startprotokoll (tools/TESTLAEUFE.md, Läufe 10:16:08 und 10:58:00 in `C:\Temp\E143S`) nennt im Fenstertitel `7.2.1.130+b25ba6b1 2026-11-02 09:13`. Belegt. In der Sache hält die Gegenprobe: Beide Stände sind Vorgänger von a7e05aef und haben die Änderung in SearchView.cpp nicht (`git diff --stat` gemessen). Nur die Kennung ist falsch.
- Das Skript legt nur empfangene Treffer an. Die Hälfte der Entscheidung, nach der verfasste Nachrichten weiter nach Out gehen, und der Text des Hinweises bei gemischter Auswahl sind am Programm nicht gemessen. Den Teil „von m“ der Logzeile wertet das Skript nicht aus (`abgelehnt-log` nimmt nur n, messen-e143s.ps1:315-319). Am Quelltext belegt. Vorschlag: einen Entwurf nach `In` legen (Status verfasst) und erwarten: `out-neu=1 hinweise=1 abgelehnt-log=3`, „3 von 4“.

**Schwere: klein** (Doku und Messumfang). **Hält das Paket auf:** nein.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Antwort auf markierten Text am neuen Bau nicht gemessen: Die Antwort zitiert die ganze Nachricht, `antwort=passt` belegt nichts; Gregors Test ist gestrichen | wichtig | nur die Aussage: vor dem Paket nachmessen oder in [E-178](../Intern/BEFUNDE.md#e-178)/TESTPLAN berichtigen |
| K2 ([E-199](../Intern/BEFUNDE.md#e-199)) | *Festbreite* im Bearbeiten-Modus schreibt `t;` in den Text (Originalfehler, `Left(-2)` ohne `\r\n`) | klein | nein |
| K3 | Messskript [E-178](../Intern/BEFUNDE.md#e-178) wertet nur die zwei Zeichen, sieht weder leeren Link noch Zeichenmüll noch Vollzitat | klein | nein |
| K4 | Test fängt einen Hinweis in der Schleife nicht (G1b grün), Logzeile ungeprüft; Out nach Out zeigt jetzt einen falschen Hinweis | klein | nein |
| K5 | Gegenprobe E-143s mit falscher Bau-Kennung; gemischte Auswahl ungemessen | klein | nein |
