# <a id="pruefer-101"></a>PRUEFER-101

Geprüft habe ich den Zweig `e223_e222_e193rest`. Mein Zweig ist wt/pruefer-20261105b, abgezweigt von `origin/e223_e222_e193rest` (Stand `1e42c6b1`). Geprüft ist alles, was seit `c7dafc00` unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam. Das ist ein einziger Commit, `1e42c6b1` (Rest von [E-193](../Intern/BEFUNDE.md#e-193)): `TridentView.cpp`, der neue Test `TestE193f.cpp`, `messen-e193f.ps1`, die Fälle `E-193fs`/`E-193f`/`E-193fd` in `pruefstand-faelle.txt`. Unter `Releases/1.0` hat sich nichts geändert. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet und keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Die Prüfstandläufe stehen im Commit und im Befund, gemessen habe ich sie nicht.

## Ergebnis vorweg

Die Behebung tut am Quelltext, was Gregor am 05.11.2026 entschieden hat (*„A, aber dann dorthin scrollen, um es sichtbar zu machen.“*): Findet *Edit → Find* ab der Markierung nichts mehr, sucht es einmal von oben, markiert den Treffer und scrollt ihn ins Bild. Eine Endlosschleife gibt es nicht. Fehlt das Wort ganz, kommt weiter *„not found“*. Die Testsuite läuft mit **425/425** (gemessen). Vier Gegenproben machen den neuen Test rot (gemessen, §3): die Suche von oben gestrichen, das ungültige Lesezeichen zurückgebaut, die Behebung in `#if 0` gesetzt, ein Rückruf von `DoFindFirst` auf `DoFindNext` eingebaut.

**Das Wichtigste für Gregors Test von 7.2.2.135 (K2, K3).** Der Prüfstand hat nur gemessen, dass keine Meldung *„not found“* mehr kommt. Ob das Wort danach **markiert und sichtbar** ist, hat er nicht gemessen. Genau das war aber Gregors Bedingung. Auch der Fall „Wort fehlt ganz“ ist am neuen Weg nicht gemessen, obwohl der Befund das behauptet. Am Quelltext stimmt beides. Der Testschritt für Gregor sollte deshalb ausdrücklich sagen: das Wort muss markiert und im Bild sein. Außerdem ändert sich das Verhalten für **jede** Mail mit mehreren Treffern: *Weitersuchen* läuft jetzt im Kreis, ohne am Ende *„not found“* zu melden (K3). Das ist von Gregors Entscheidung gedeckt, steht aber nirgends. Ohne Hinweis meldet Gregor es womöglich als neuen Fehler.

Unverändert bleibt der Fehler in den Fenstern, die nicht Microsofts Anzeige nutzen (K1): im Nachrichtenfenster, wenn *Use Microsoft's viewer* aus ist, und vermutlich im Verfassen-Fenster. Gregor nutzt die Microsoft-Anzeige (Vermutung, sie ist die Vorgabe). Zwei Stellen in der Doku sind veraltet (K4).

**Kein Fund hält das Paket 7.2.2.135 oder den Merge auf.** Neue E-Kennungen habe ich nicht vergeben. K1 gehört als Rest zu [E-193](../Intern/BEFUNDE.md#e-193) (`perl tools/befund-suchen.pl DoFindNext` meldet nur [E-193](../Intern/BEFUNDE.md#e-193)).

## 1. Was die Behebung tut

**Der Ablauf (am Quelltext belegt).** Öffnet *Find Messages* eine Mail per Doppelklick, ruft `SearchView.cpp:3039` `DoFindFirst(strSearch, false, bWholeWord, TRUE)` auf die Ansicht. `CTridentView::DoFindFirst` (`TridentView.cpp:1709-1831`) sucht von oben, markiert den Treffer, scrollt ihn ins Bild (:1806-1812) und legt das Lesezeichen **hinter** den Treffer (:1802, :1814). Danach setzt `SearchView.cpp:3044` den Suchtext für F3. *Edit → Find* und F3 landen beide in `CReadMessageFrame::OnFindReplace` → `DoFindNext` (`ReadMessageFrame.cpp:1396-1397`). Der Dialog geht über `QCFindMgr::DoFind` → `SendFindMsg` (`QCFindMgr.cpp:345`), F3 über `DoFindAgain` → `SendFindMsg` (:407). `DoFindNext` sucht ab dem Lesezeichen (:1883). Steht das Wort nur einmal in der Mail, fand es bisher nichts, und `SendFindMsg` zeigte *„not found“* (`QCFindMgr.cpp:305-307`).

**Die Behebung (belegt).** `DoFindNext` ruft jetzt an zwei weiteren Stellen `DoFindFirst` mit denselben Schaltern auf: wenn das Lesezeichen ungültig ist (:1890, vorher `return FALSE`) und wenn ab dem Lesezeichen nichts kam (:1943-1946). Ohne Lesezeichen tat es das schon im Original (:1850-1853). `DoFindFirst` markiert und scrollt, wenn `bSelect` wahr ist. Alle Aufrufer übergeben `TRUE` (`ReadMessageFrame.cpp:1397`, `TocFrame.cpp:475`, `CompMessageFrame.cpp:1937`).

**Endlosschleife (belegt, Gegenprobe gemessen).** `DoFindFirst` ruft `DoFindNext` nicht. Keine Unterklasse überschreibt eine der beiden Funktionen: `TridentReadMessageView.h` und `TridentPreviewView.h` deklarieren keine, nur `TridentView.h:62-63`. Kein Aufrufer ruft `DoFindNext` in einer Schleife, bis `FALSE` kommt. Gesendet wird `WM_FINDREPLACE` nur vom Suchdialog, von F3 (`QCFindMgr.cpp:407`) und von F3 bei offenem Suchdialog (`FindDlg.cpp:86-90`, ein `PostMessage` je Tastendruck). Hält man F3 gedrückt, markiert Eudora bei einem einzigen Treffer immer wieder dasselbe Wort. Das ist harmlos. Fehlt das Wort ganz, sucht `DoFindFirst` einmal und gibt `FALSE` zurück. Dann kommt wie bisher *„not found“*.

**Ganzes Wort, Groß/Klein (belegt).** `DoFindFirst` bekommt dieselben `bMatchCase`/`bWholeWord` wie `DoFindNext`. Die Schalter wirken in beiden gleich (:1793 und :1900). *Find Messages* legt für F3 „Groß/Klein egal“ und sein eigenes Ganzwort fest (`SearchView.cpp:3044`). F3 sofort nach dem Öffnen sucht also genau so, wie *Find Messages* markiert hat.

**Vorschaufenster (belegt; Gewinn ist Vermutung).** Das Vorschaufenster unter der Postfachliste ist `CTridentPreviewView`. Es erbt `DoFindNext` (`QCProtocol.cpp:81-92`, `TocFrame.cpp:474-475`) und bekommt dasselbe Verhalten. Das Lesezeichen wird nur im Konstruktor und in `DoFindFirst` zurückgesetzt (`TridentView.cpp:144`, :1762). Die Vorschau zeigt nacheinander verschiedene Mails. Das Lesezeichen der vorigen Mail bleibt also stehen. Ob `moveToBookmark` es in der neuen Mail ablehnt oder auf eine fremde Stelle setzt, habe ich nicht gemessen. In beiden Fällen sucht Eudora jetzt von oben, wo es bisher *„not found“* melden konnte.

**Neu erreichbar, aber harmlos (belegt).** `DoFindFirst` pumpt Botschaften, solange die Anzeige nicht bereit ist (:1726-1760, mit der Behandlung von `WM_QUIT` aus [E-62](../Intern/BEFUNDE.md#e-62)). Über `DoFindNext` war das bisher nur ohne Lesezeichen erreichbar, jetzt auch nach einer erfolglosen Suche. Wer gerade sucht, sieht eine fertige Anzeige. Dann läuft die Schleife nicht.

## 2. Trifft die Messung den Weg?

Die Runde `suchweg` (`messen-e193f.ps1:228-345`) geht Gregors Weg: *Find Messages*, Doppelklick auf die Ergebniszeile, dann *Edit → Find* mit demselben Wort. Sie misst damit genau den Weg der Behebung. Ihr Urteil ist aber nur „kein Fenster mit *not found*“ (:305-313). Was markiert ist und ob es im Bild steht, liest sie nicht aus (K2). Die Runden `direkt`, `dialog` und `klick` öffnen **für jedes Wort ein frisches Fenster** (Kopf von `Runde`, :373-388). Dort gibt es kein Lesezeichen, und `DoFindNext` springt schon in :1850 auf `DoFindFirst`, wie im Original. Diese drei Runden prüfen also nicht die neue Stelle, sondern dass nichts anderes kaputt ist. Das gilt auch für `negativ-falsch=0`.

F3 selbst misst kein Fall. `suchweg` nimmt den Dialog (Befehl 32776). Am Quelltext ist F3 derselbe Weg ab `SendFindMsg` (§1).

## 3. Gegenproben am Test

`TestE193f.cpp` prüft die Stelle im Quelltext (`QT_LiesNurCode`, also ohne Kommentare und ohne `#if 0`). Ich habe `TridentView.cpp` vorübergehend mit Perl (`:raw`) auf vier Arten geändert, die Suite jeweils gebaut und gefahren und die Datei danach zurückgeholt. `cmp` gegen die Sicherung: gleich. `git diff`: leer. Zeilenenden wie in HEAD (CRLF 18, nur-LF 4370, >127: 0).

| Probe | Änderung | Ergebnis (gemessen) |
|---|---|---|
| ohne | Stand `1e42c6b1` | 425 Tests, 425 bestanden |
| M1 | Suche von oben am Ende gestrichen (:1943-1946) | 424 bestanden, 1 rot (`E-193 Rest`, 2 Abweichungen) |
| M2 | ungültiges Lesezeichen wieder `return FALSE;` (:1890) | 424 bestanden, 1 rot (2 Abweichungen) |
| M4 | Block :1943-1946 in `#if 0 … #endif` | 424 bestanden, 1 rot (2 Abweichungen) |
| M5 | in `DoFindFirst` vor dem Ende `if( !bReturn ) bReturn = DoFindNext( … );` (Kreis) | 424 bestanden, 1 rot (1 Abweichung) |

Der Test vergleicht den Wortlaut. Eine gleichwertige Schreibweise wie `if (!bReturn)` würde ihn ebenfalls rot machen. Das ist die übliche Art der Quelltext-Tests hier und kein Fund.

## Funde

### <a id="k1"></a>K1 (gering, belegt): Ohne Microsofts Anzeige bleibt der alte Fehler

Ist *Use Microsoft's viewer* aus (`IDS_INI_USE_BIDENT_ALWAYS`, `utils.cpp:1848-1851`), baut das Nachrichtenfenster `PgReadMsgView` statt `CTridentReadMessageView` (`ReadMessageFrame.cpp:275-282`). Dessen `CPaigeEdtView::DoFindNext` sucht ab dem Ende der Markierung (`PaigeEdtView.cpp:6611-6626`). `Find` gibt am Textende `FALSE` zurück, ohne von oben zu suchen (:6730). *Find Messages* markiert den Treffer auch hier über `DoFindFirst` (`SearchView.cpp:3039`). Kommt das Wort nur einmal vor, meldet *Edit → Find* danach weiter *„not found“*. Dasselbe gilt vermutlich für ein Verfassen-Fenster, das *Find Messages* öffnet (`SearchView.cpp:3069`, `bodyview->DoFindFirst` auf die Paige-Ansicht). Welche Fensterhälfte dort danach die Suche bekommt, habe ich nicht verfolgt. Gregor nutzt die Microsoft-Anzeige, das ist die Vorgabe (Vermutung, nicht an seiner INI gelesen). **Vorschlag:** als Rest in [E-193](../Intern/BEFUNDE.md#e-193) fortschreiben, nicht neu nummerieren. Gregor entscheidet, ob `CPaigeEdtView::DoFindNext` dasselbe Verhalten bekommt.

### <a id="k2"></a>K2 (gering, belegt): Markieren und Scrollen sind nicht gemessen, „Wort fehlt“ nicht am neuen Weg

Gregors Bedingung war *„dorthin scrollen, um es sichtbar zu machen“*. Die Runde `suchweg` zählt als gefunden, wenn kein Fenster mit *not found* erscheint (`messen-e193f.ps1:309-313`). Markierung und Rollposition liest sie nicht aus. Am Quelltext tut `DoFindFirst` beides (`TridentView.cpp:1806-1812`). Der Befund schreibt außerdem: *„fehlt es ganz, bleibt es bei „not found“ (`negativ-falsch=0` in beiden Runden)“*. Beide Runden öffnen aber für jedes Wort ein frisches Fenster ohne Lesezeichen (§2). Die neue Stelle (:1943-1946) hat der Negativfall also nie durchlaufen. Die Aussage stimmt am Quelltext (§1), der genannte Messwert trägt sie aber nicht. **Vorschlag:** im Befund „am Quelltext belegt“ statt der Messzeile schreiben. In `suchweg` nach dem Öffnen auch `Zebrafink` suchen. Im Testschritt für Gregor ausdrücklich verlangen: das Wort ist markiert und steht im Bild.

### <a id="k3"></a>K3 (gering, belegt): Weitersuchen läuft jetzt in jeder Mail im Kreis, ohne Meldung am Ende

Bisher kam nach dem letzten Treffer einmal *„not found“*. Das Lesezeichen war dann gelöscht (:1884), und der nächste Druck begann oben. Diese Meldung war das einzige Zeichen „Ende erreicht“. Jetzt springt *Weitersuchen* oder F3 nach dem letzten Treffer stumm auf den ersten. Das betrifft jede Mail mit mehreren Treffern, nicht nur Mails aus *Find Messages*. Gregors Entscheidung deckt das im Wortlaut (*„sucht es einmal von oben weiter“*). Es steht aber weder in den Release-Notizen noch im Befund als Folge. Gemessen ist der Kreis auch nicht: `f14` (Wort zweimal) wird nur einmal weitergesucht, `zweiter=` läuft nur nach *not found* (:317-329). **Vorschlag:** im Testplan für 7.2.2.135 und in den Release-Notizen einen Satz ergänzen: *„Nach dem letzten Treffer beginnt Weitersuchen ohne Meldung wieder oben.“*

### <a id="k4"></a>K4 (gering, belegt): Die Doku nennt die Ursache noch „offen“

Die Statuszelle von [E-193](../Intern/BEFUNDE.md#e-193) (`Intern/BEFUNDE.md:425`) sagt weiter *„Offen: Edit → Find übersieht in einer Outlook-Rundmail ein sichtbares Wort (Ursache offen, siehe Nachtrag)“*. Dieselbe Zelle sagt: *„Ursache von Gregor gefunden, behoben“*. Die Spalte *Was noch fehlt* in `CHANGELOG.md:45` und `Intern/WEITERMACHEN.md:114` verlangt noch *„die Ursache bei Edit → Find in Gregors Outlook-Rundmail (dafür die echte Anzeigedatei `eud*.htm`…)“*. Der Kommentar `messen-e193f.ps1:314-316` beschreibt das alte Verhalten (*„nach not found ist das Lesezeichen geloescht, die Suche beginnt wieder oben“*). Mit der Behebung kommt `zweiter=` in Microsofts Anzeige nur noch bei einem Wort vor, das ganz fehlt.

## Hinweise (keine Funde)

* **T1 (Original):** `TridentReadMessageView.h:35` deklariert ein zweites `m_bstrBookmark`, das das der Basisklasse verdeckt. Gesetzt wird es nur im Konstruktor (`TridentReadMessageView.cpp:202`), gelesen nirgends. Es ist ohne Wirkung.
* **T2 (Original):** Das Lesezeichen aus `getBookmark` wird nie mit `SysFreeString` freigegeben (:1814, :1922; überschrieben bei :1762, :1884). Je erfolgreicher Suche bleibt ein kleiner BSTR liegen. Die Behebung ändert daran nichts.
* **T3:** Die Doku zieht mit: README, CHANGELOG und `Releases/7.2.2.134/RELEASE-NOTIZEN.md` sagen *„im Quellstand behoben, kommt mit dem nächsten Paket“*. Im Projekt steht `TestE193f.cpp` (`Tests.vcxproj`, `TestMain.cpp`). Die neuen Fälle in `pruefstand-faelle.txt` passen zu den Ausgabezeilen des Skripts.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | ohne Microsofts Anzeige (und vermutlich im Verfassen-Fenster) meldet *Edit → Find* nach *Find Messages* weiter *„not found“* | gering | nein; als Rest in [E-193](../Intern/BEFUNDE.md#e-193), Gregor entscheidet |
| [K2](#k2) | Markieren/Scrollen und „Wort fehlt“ am neuen Weg nicht gemessen; der Befund nennt dafür einen Messwert, der den Weg nicht trifft | gering | nein; im Testschritt „markiert und sichtbar“ verlangen |
| [K3](#k3) | *Weitersuchen* läuft in jeder Mail stumm im Kreis, das Ende-Zeichen *„not found“* fällt weg; nirgends gesagt | gering | nein; Satz in Testplan und Release-Notizen |
| [K4](#k4) | [E-193](../Intern/BEFUNDE.md#e-193) nennt die Ursache an drei Stellen noch „offen“, Skriptkommentar beschreibt altes Verhalten | gering | nein |
| T1 | verdecktes `m_bstrBookmark` in `CTridentReadMessageView` (Original) | – | nein |
| T2 | BSTR des Lesezeichens wird nie freigegeben (Original) | – | nein |
| T3 | Doku, Testprojekt, Fallliste stimmig | – | nein |
