# <a id="pruefer-87"></a>PRUEFER-87

Lauf nach [PRUEFER-86](PRUEFER-86.md). Geprüft wurde `456c95e1..HEAD -- Eudora71 tools Releases/1.0` auf Zweig wt/pruefer-20261102g (von `origin/e133_mailverzeichnis_fehlt`, Stand 61882b61, also mit #208). Inhaltlich neu gegenüber [PRUEFER-86](PRUEFER-86.md#pruefer-86) sind c473e7f7 (Behebung [E-133](../Intern/BEFUNDE.md#e-133), `TestE133.cpp`, `messen-e133.ps1`, Schalter in `pruefstand-lauf.ps1`) und 1275215f (Messung, Fälle `E-133p`/`E-133q`). Der Rest des Bereichs ist [E-39](../Intern/BEFUNDE.md#e-39) und wurde in [PRUEFER-85](PRUEFER-85.md) geprüft; seit c473e7f7 hat sich unter `Eudora71/` nichts mehr geändert (gemessen: `git diff --stat c473e7f7 61882b61 -- Eudora71` leer). Schwerpunkte: `StartEudoraWithDefaultLocation` und die vier `E133…`-Helfer, alle Startwege, `RegisterCommandLine(NULL)`, der Fall „`Current` und HKCR fehlen beide“, `TestE133`, `messen-e133.ps1`, und auf Wunsch des BEHEBERS: schützen `testlauf.ps1` und `pruefstand-lauf.ps1` Gregors Registry, wenn mehrere Arbeitsbäume gleichzeitig messen ([E-157](../Intern/BEFUNDE.md#e-157))? Eudora habe ich weder gebaut noch gestartet, keinen Prüfstand angefasst, nichts in der Registry gelesen oder geschrieben. Die Registryfrage ist nur am Quelltext beantwortet.

## Ergebnis vorweg

Die Behebung tut auf dem Weg, für den sie gebaut ist, was sie soll. Zeigt die Registry beim Doppelklick auf ein Verzeichnis, das es nicht gibt, fragt Eudora jetzt, statt sich mit zwei Meldungen zu beenden. Die Prüfung steht vor `GetDirs`, prüft dasselbe wie `CheckMailDirectory`, und schließt sich mit der Rückfrage von [E-132](../Intern/BEFUNDE.md#e-132) sauber aus. Die Ordnerauswahl ist richtig eingebunden (COM ist an dieser Stelle schon offen). Die Testsuite läuft mit 368/368. Von sechs Gegenproben wird nur eine rot.

Der wichtigste Fund liegt nicht im Programm, sondern im Prüfstand. Laufen zwei Prüfstandsläufe aus verschiedenen Arbeitsbäumen gleichzeitig, kann `CommandLine\Current` danach auf einen Prüfstand zeigen, auch auf `C:\Temp\E133-gibt-es-nicht`. Dann startet Gregors heutiges Paket per Doppelklick nicht mehr, genau das Bild von [E-133](../Intern/BEFUNDE.md#e-133). `testlauf.ps1` allein sichert gar nichts. [E-157](../Intern/BEFUNDE.md#e-157) ist damit nur für einen einzelnen Lauf geschlossen (K1, am Quelltext belegt).

Dazu zwei Grenzen der Behebung, beide Altbestand. Fehlt `Current` ganz, startet Eudora weiterhin nicht, und die neue Frage hilft dort nicht (K2, Vorschlag [E-208](../Intern/BEFUNDE.md#e-208)). Liegt das Mailverzeichnis mit Leerzeichen auf einem Laufwerk ohne 8.3-Kurznamen, fragt Eudora bei jedem Start neu, obwohl der Text verspricht, sich die Wahl zu merken (K3, Vorschlag [E-209](../Intern/BEFUNDE.md#e-209)). Der Prüfstand `C:\Temp\E133` kann K3 nicht sehen. Dazu kommen drei kleine Funde zur Vorgabe *No*, zum Test und zum Messskript (K4 bis K6) und ein bekannter Rest (K7).

Für das Paket: Keiner der Funde hält 7.2.2.132 auf. Vor Gregors nächstem Test sollte jemand `CommandLine\Current` nachsehen (K1). Über K2 und K4 sollte Gregor entscheiden.

## 1. Die Behebung am Quelltext

- **Stelle.** `if (!bFremd && E133VerzeichnisFehlt(szVerzeichnis))` (eudora.cpp:4564) steht im Block `if (*buf)` hinter der E-132-Prüfung und vor `if (err || !GetDirs(buf))` (:4622). Belegt.
- **Gleiche Prüfung wie `CheckMailDirectory`.** `E133VerzeichnisFehlt` (:4026) nimmt abschließende Schrägstriche weg und fragt `FileExistsMT`, also `_access(…, 0)` (QCUtils/src/services.cpp:1021-1032). `CheckMailDirectory` fragt dasselbe, ohne das Schreibrecht, obwohl der Kommentar „writable“ sagt (fileutil.cpp:372). Die Schreibweise ist auch gleich: `szVerzeichnis` kommt aus `E132AufrufZerlegen` (:3913) mit derselben Trennregel wie `GetDirs` (fileutil.cpp:443-446). Belegt. Was `CheckMailDirectory` darüber hinaus tut (`GetFullPathName`, Laufwerk ergänzen), ändert an der Existenz nichts. Für relative Angaben gilt das nur, solange das aktuelle Verzeichnis dasselbe ist. Das ist so, beide laufen im selben Aufruf. Belegt.
- **Ausschluss mit [E-132](../Intern/BEFUNDE.md#e-132).** `bFremd` verlangt `bEinrichtungDa`, also eine vorhandene Datei im Verzeichnis (:4302-4326). Ein fehlendes Verzeichnis kann nicht fremd sein. Belegt.
- **`E133OrdnerWaehlen` gegen Win32.** `BIF_NEWDIALOGSTYLE` verlangt ein initialisiertes COM. `AfxOleInit` läuft in `InitInstance` (:917) vor allen drei Aufrufen von `StartEudoraWithDefaultLocation` (:1017, :1029, :1055). `CoTaskMemFree(pidl)` gibt die Liste frei, `SHGetPathFromIDList` füllt höchstens `MAX_PATH`. Belegt.
- **`E133InBefehlszeile`.** Eine vollständig geklammerte Zeile wird von `GetDirs` nicht getrennt, weil das letzte Zeichen `"` ist (fileutil.cpp:446), und `StripQuotesMT` nimmt die Klammern weg. Ein Laufwerk als Wahl (`"D:\"`) geht genauso durch. Der Ausweg über die Kurzform greift erst ab 259 Zeichen. Ohne 8.3 schneidet `_tcsncpy` dann das schließende `"` ab (das Muster aus PRUEFER-42 K3). Das kann `SHGetPathFromIDList` mit seinen `MAX_PATH` kaum liefern, darum kein eigener Fund. Belegt.
- **Rückfrage.** `MessageBox` mit 0 (Fehlschlag) fällt durch auf `return FALSE` (:4604), ohne etwas zu schreiben. Abbruch der Ordnerauswahl führt zurück zur Frage. Das ist keine Endlosschleife ohne Anwender, jede Runde zeigt eine `MessageBox`. Belegt.

## 2. Die Startwege

| Weg | Erreicht [E-133](../Intern/BEFUNDE.md#e-133)? | Belegt |
|---|---|---|
| Doppelklick, keine `Eudora.ini` neben der EXE | ja, :1046-1052 → :1055 | Quelltext; gemessen von BEHEBER (`E-133p`) |
| Doppelklick, `Eudora.ini` neben der EXE | nein, `FileExistsMT(INIPath)` (:1050) | Quelltext |
| Befehlszeile mit Pfad (auch `Eudora starten.cmd`) | nein, `CommandLine` nicht leer (:1048) | Quelltext |
| Anhang, Briefpapier, `mailto:`, `.mbx`, Nachricht | ja, :1017, aber nur, wenn kein Eudora läuft (`ProcessAttachmentWEI`, :1013) | Quelltext, nicht gemessen |
| Automation | ja, :1029 | Quelltext, nicht gemessen |

`ExecutableDir` ist auf allen Wegen gesetzt (:4126-4137, PRUEFER-41 K1), `E133NebenProgramm` bekommt also nie einen leeren Ordner. Belegt.

## 3. `RegisterCommandLine(NULL)` nach `GetDirs`

- Der Parameter wird in `RegisterCommandLine` nicht gelesen (:3730-3770). Geschrieben werden `HKCU\…\CommandLine\Current` und der Standardwert von `HKCR\Software\Qualcomm\Eudora\CommandLine\Current` (`IDS_REG_SOFTWARE`, EudoraRes.rc:10682, eudora.cpp:3755). Belegt. Die HKCR-Schreibzugriffe scheitern ohne Administratorrechte, weil es unter `HKCU\Software\Classes` keinen dieser Schlüssel gibt. Gemessen ist das für die anderen HKCR-Schlüssel in [PRUEFER-59 K10](PRUEFER-59.md#k10). Für diesen Schlüssel ist es eine Vermutung.
- **Nur wenn gewählt wurde.** Der Aufruf hängt an `bE133Gewaehlt` (:4636). Das wird nur hinter der Rückfrage gesetzt (:4610). Auf allen anderen Wegen schreibt die Funktion wie vorher nichts. Belegt.
- **Doppelklick:** zweimal derselbe Wert, einmal hier und einmal in `InitInstance` (:1067). Harmlos. Belegt.
- **Anhang und Automation:** neu ist, dass dort überhaupt geschrieben wird. Danach steht noch `if (IsEudoraRunning()) return FALSE;` (:1021, :1035). Läuft gleichzeitig ein zweites Eudora an, das `ProcessAttachmentWEI` noch nicht gefunden hat, ist der Zeiger schon umgebogen, bevor dieser Start aufgibt. Vermutung, eng, kein Fund.
- **Nach Abbruch oder Fehlschlag** von `GetDirs` wird nicht geschrieben (:4622-4626 vor :4636). Richtig. Belegt.

## 4. `Current` und HKCR fehlen beide

`cmdLine` ist nicht vorbelegt (:4140). Scheitern beide `RegQueryValueEx` (:4161, :4169), wird `*cmdLine` trotzdem gelesen (:4175). Das ist [PRUEFER-41 K12](PRUEFER-41.md#k12), Originalbestand (567a5d87 enthält dieselben Zeilen). Neu ist, was danach passiert. Darum geht es in K2.

Noch eine Kleinigkeit, Altbestand, nur fürs Protokoll. Liefert die erste Abfrage `ERROR_MORE_DATA`, steht in `buflen` danach die nötige Länge, nicht mehr `sizeof(cmdLine)`. Die zweite Abfrage (:4169) bekommt dann einen zu großen Puffer gemeldet. Bei einem langen HKCR-Wert liefe sie über `cmdLine` hinaus. So steht es in der Win32-Beschreibung von `RegQueryValueEx`. Heute ist das folgenlos, weil der HKCR-Wert fehlt (Vermutung, siehe Abschnitt 3).

## 5. Testsuite und Gegenproben (in meinem Baum)

Gemessen. Die Basis lief über `cmd /c Eudora71\Tests\RunTests.cmd`. `TestE133` liest `eudora.cpp` zur Laufzeit (`QT_LiesNurCode`). Die Gegenproben haben deshalb nur die Quelle mit Perl `:raw` geändert, Anker jeweils mit genau 1 Treffer, und `EudoraTests.exe` neu gestartet, ohne neuen Bau. Dass das wirkt, zeigt G5. Danach habe ich die Sicherung byte-genau zurückgeschrieben. `cmp` meldete keinen Unterschied, `git status` war leer. `eudora.cpp` hat vorher und nachher 18 CRLF, 5806 reine LF und 0 Byte über 127.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 368/368 |
| G1 | `if (nWahl == IDYES)` → `IDNO`: *Yes* und *No* vertauscht | **368/368, grün** (K5) |
| G2 | `"\\Mailverzeichnis"` → `"\\Mailordner"` in `E133NebenProgramm` | **368/368, grün** (K5) |
| G3 | Klammer in `E133InBefehlszeile` weg (`"%s"`) | **368/368, grün** (K5) |
| G4 | `bE133Gewaehlt = true; bE133Gewaehlt = false;`: Registry wird nie berichtigt | **368/368, grün** (K5) |
| G5 | Abbruch der Ordnerauswahl beendet Eudora (`continue` → `return FALSE;`) | 367/368, rot `der E-133-Block hat nicht genau einen Ausstieg` |
| G6 | leerer Name gilt als fehlend (`return false` → `return true`) | **368/368, grün** (gering, der Fall kommt nicht vor: `*buf` ist geprüft) |

## 6. Messskript und Prüfstandsfälle

`messen-e133.ps1` trifft den Weg *Doppelklick*. `-Vorbereiten` setzt `Current` auf `C:\Temp\E133-gibt-es-nicht`, `testlauf.ps1 -OhneArgument` startet ohne Befehlszeile, neben der EXE liegt keine `Eudora.ini` (geprüft in :65). Das führt über :1055 in die neue Stelle. Belegt. Der Dialog wird am Text `does not exist any more` erkannt und mit `WM_COMMAND IDNO` an das gemessene Handle beantwortet, ohne Tastendruck. Belegt. Was es nicht trifft, siehe K6. Gemessen hat der BEHEBER am Bau `88142c78*`. Die Quelle von c473e7f7 unterscheidet sich von 88142c78 genau um die E-133-Dateien (gemessen, `git diff --stat`). Dass der Bau mit Stern genau diesen Stand trug, kann ich nicht nachprüfen.

## 7. Registry und E-157 (Schwerpunkt des BEHEBERS)

- **`testlauf.ps1`** liest und schreibt keine Registry (kein Treffer auf `HKCU`, `ItemProperty`, `Registry` außer in Kommentaren, :47-48, :297-314). Belegt. Jeder Start darüber schreibt `Current`, auch mit Verzeichnis auf der Befehlszeile: dieser Start läuft durch den `default`-Zweig bis `RegisterCommandLine(m_lpCmdLine)` (eudora.cpp:1041-1067). Belegt. `messen-e133.ps1` sagt das selbst (:13-19).
- **`pruefstand-lauf.ps1`** hält `CommandLine` und `LaunchManager` einmal vor dem ganzen Lauf fest (:144-180) und schreibt im `finally` diesen Stand zurück (:398-399). Gegen den eigenen Lauf ist das richtig. Gegen einen gleichzeitigen Lauf aus einem anderen Arbeitsbaum ist es das nicht, siehe K1. Belegt.
- **Nicht festgehalten:** HKCR (Abschnitt 3, schreibt ohne Adminrechte nichts) und die Zweige je Mailverzeichnis ([PRUEFER-59](PRUEFER-59.md#pruefer-59) K10). Belegt bzw. dort gemessen.
- **Betrifft es [E-157](../Intern/BEFUNDE.md#e-157)?** Ja. [E-157](../Intern/BEFUNDE.md#e-157) nennt als Grenzen den Standardwert, Gregors gleichzeitige Änderungen und den Abschuss von außen. Zwei Wege fehlen dort: Läufe nur mit `testlauf.ps1` und gleichzeitige Prüfstandsläufe mehrerer Arbeitsbäume. Mit [E-133](../Intern/BEFUNDE.md#e-133) ist der zweite Weg gefährlicher geworden. `messen-e133.ps1 -Vorbereiten` legt absichtlich den Zeiger auf ein fehlendes Verzeichnis, und genau dieser Wert kann als „Stand vorher“ eines anderen Laufs gesichert und später zurückgeschrieben werden.

## 8. Funde

### <a id="k1"></a>K1: Gleichzeitige Prüfstandsläufe können Gregors `Current` auf einen Prüfstand oder ein fehlendes Verzeichnis zurücksetzen

(am Quelltext belegt; die Folge ist eine Vermutung, angestoßen von der Meldung des BEHEBERS, dass mehrere Arbeitsbäume gleichzeitig in `CommandLine\Current` und `LaunchManager` schreiben.)

Ablauf: Lauf A sichert den Stand S0 (Gregors Wert) und startet. Sein Eudora oder sein `-Vorbereiten` schreibt `Current` = A-Prüfstand. Lauf B in einem anderen Baum beginnt jetzt und sichert diesen Wert als *seinen* Stand vorher. A endet und schreibt S0 zurück. B endet und schreibt den A-Wert zurück. Danach zeigt `Current` dauerhaft auf A. Ist A ein [`E-133`](../Intern/BEFUNDE.md#e-133)-Fall, zeigt der Zeiger auf `C:\Temp\E133-gibt-es-nicht`, und Gregors Paket 7.2.1.131 hat die Behebung noch nicht. Ein Doppelklick ohne `Eudora starten.cmd` endet dann mit den beiden Meldungen aus [E-133](../Intern/BEFUNDE.md#e-133). Für `LaunchManager\DLLPath` gilt dieselbe Kette, mit der Folge aus [E-157](../Intern/BEFUNDE.md#e-157) (fremde `EuShlExt.dll`). Dazu kommt, dass gleichzeitige Läufe sich gegenseitig die Messung verderben: `registry-danach` in `E-133p` liest den globalen Wert.

**Abhilfe:** eine Sperre über alle Eudora-Starts aus `tools/`, zum Beispiel ein benannter Mutex in `testlauf.ps1`, den auch `pruefstand-lauf.ps1` für die ganze Dauer hält. Oder beim Zurücksetzen nur Werte anfassen, die noch den Wert des eigenen Laufs tragen. Läufe mit `testlauf.ps1` allein sollten genauso sichern wie `pruefstand-lauf.ps1`. **Schwere: mittel.** In [E-157](../Intern/BEFUNDE.md#e-157) fortschreiben, keine neue Kennung. **Hält das Paket nicht auf.** Vor Gregors nächstem Test `Current` und `LaunchManager\DLLPath` nachsehen.

### <a id="k2"></a>K2: Fehlt `Current`, startet Eudora per Doppelklick weiterhin nicht, und die neue Frage kann umsonst kommen (Vorschlag: E-208)

(am Quelltext belegt, nicht gemessen)

Scheitert die HKCU-Abfrage, trägt `err` das Ergebnis der HKCR-Abfrage (:4169). Der HKCR-Wert wird ohne Adminrechte nie geschrieben (Abschnitt 3, Vermutung). Dann bleibt `err` ungleich null. Auch wenn darauf Application Data gefunden wird, endet `if (err || !GetDirs(buf))` (:4622) mit `IDS_ERR_CANNOT_START_WITH_ATTACH`. Das trifft einen Anwender, der den Registryeintrag gelöscht hat, und einen frischen Rechner mit unserem Paket, das keine `Eudora.ini` neben der EXE hat. Das ist Originalverhalten und keine Folge der Behebung. Aber [E-133](../Intern/BEFUNDE.md#e-133) beschreibt sich als *„fragt statt sich zu beenden“*, und für diese Lage gilt das nicht.

Schlimmer ist der Randfall aus [PRUEFER-41 K12](PRUEFER-41.md#k12). Ergibt der Stapelmüll in `cmdLine` ein Leerzeichen, steht ein Unsinnspfad in `buf`. Den gibt es nicht, also kommt die E-133-Frage mit diesem Pfad. Der Anwender wählt einen Ordner, danach beendet `err` den Start trotzdem, und weil `RegisterCommandLine` hinter der Prüfung steht, ist nichts gemerkt. **Abhilfe:** `cmdLine[0] = 0` vorbelegen. Gregor entscheidet, ob eine fehlende Angabe wie Application Data behandelt wird (`err` nach `if (!*buf)` mit gefundenem Pfad zurücksetzen). **Schwere: mittel** (Start verweigert, Altbestand). **Hält das Paket nicht auf.**

### <a id="k3"></a>K3: Pfad mit Leerzeichen ohne 8.3-Kurznamen: Eudora fragt bei jedem Start (Vorschlag: E-209)

(am Quelltext belegt, nicht gemessen)

`RegisterCommandLine` schreibt `"%s %s %s"` aus `GetShortPathName` (:3748-3752). Auf einem Laufwerk ohne 8.3-Namen gibt `GetShortPathName` die Langform zurück, mit Leerzeichen und ohne Klammer. Beim nächsten Start trennt `StartEudoraWithDefaultLocation` am ersten Leerzeichen (:4178). Liegt schon die EXE unter einem Pfad mit Leerzeichen, steht danach der Rest des Programmpfads als „Verzeichnis“ da. Sonst trennt `E132AufrufZerlegen` bzw. `GetDirs` im Mailverzeichnis. In beiden Fällen gibt es das Verzeichnis nicht. Vorher endete das mit zwei Meldungen. Jetzt kommt bei jedem Start die E-133-Frage, *No* geht, und dieselbe kaputte Zeile wird wieder geschrieben. Der Text *„Eudora remembers the folder you pick for the next start“* stimmt dann nicht. Der Prüfstand `C:\Temp\E133` hat keine Leerzeichen und kann das nicht sehen (`Arbeitsweise/pruefstand-nicht-bequemer-als-die-wirklichkeit.md`, `tools/pruefe-pruefstand-pfad.pl`). Ob Laufwerke ohne 8.3-Namen beim Anwender häufig sind (neuere Windows-Fassungen legen sie auf Datenlaufwerken oft ohne an), ist eine Vermutung. **Abhilfe:** in `RegisterCommandLine` jeden Teil klammern, der ein Leerzeichen enthält. Die Leser (:4175-4185, `E132AufrufZerlegen`, `GetDirs`) kennen die Form `"…" ` schon. **Schwere: gering bis mittel.** **Hält das Paket nicht auf.**

### <a id="k4"></a>K4: Die Vorgabe *No* biegt bei einem abgezogenen Laufwerk den Zeiger dauerhaft um

(am Quelltext belegt)

Der Dialog nennt selbst den Fall *„on a drive that is not connected“*. Wer dann die Vorgabe wegdrückt, bekommt den Ordner neben dem Programm, und `RegisterCommandLine` schreibt ihn fest (:4601, :4638). Ist das Laufwerk beim nächsten Start wieder da, fragt Eudora nicht mehr, weil der neue Ordner existiert. Es startet mit den Postfächern des Programmordners, also oft leer. Verloren geht nichts, das alte Verzeichnis bleibt unberührt. Zurück kommt man nur über die Befehlszeile oder `Eudora starten.cmd`. **Vorschlag zur Entscheidung:** bei *No* nicht in die Registry schreiben, oder einen vierten Weg *„Retry“* anbieten. **Schwere: gering.** **Hält das Paket nicht auf**, Entscheidung Gregor.

### <a id="k5"></a>K5: TestE133 schützt Zuordnung, Klammer, Ordnernamen und Merker nicht

(gemessen, Abschnitt 5)

G1 bis G4 bleiben grün. Der Test prüft nur, dass die Zeichenketten vorkommen, nicht welche Antwort wohin führt, ob die Zeile geklammert ist, welcher Ordner neben dem Programm gilt und ob `bE133Gewaehlt` gesetzt *bleibt*. Am wichtigsten ist G4: ohne Registryberichtigung fragt Eudora auf den Wegen mit Anhang bei jedem Start. `E-133q` würde das am Programm rot sehen, `TestE133` nicht. **Abhilfe:** `E133InBefehlszeile` und `E133NebenProgramm` fensterlos wie `E132AufrufZerlegen` in den Test ziehen und mit Leerzeichenpfad prüfen, dass `GetDirs`-Trennung *einen* Pfad ergibt. Den *Yes*-Zweig über `QT_Abschnitt` von `IDYES` bis `IDNO` abgrenzen. **Schwere: gering.**

### <a id="k6"></a>K6: `E-133p` belegt die eigene Registryberichtigung nicht, und nur der Doppelklick ist gemessen

(am Quelltext belegt)

Beim Doppelklick schreibt `InitInstance` denselben Wert ohnehin (:1067). `registry-danach=…MAILVE~1` in `E-133p` wäre also auch ohne `RegisterCommandLine(NULL)` grün (vgl. G4). Das tragende Zeichen ist allein die Spurzeile in `E-133q`. Gerade die Wege, für die der Aufruf eingebaut wurde (Anhang, `mailto:`, Automation), misst kein Fall, ebenso wenig *Yes* und *Cancel* (in [E-133](../Intern/BEFUNDE.md#e-133) selbst als *nicht gemessen* vermerkt). `registry-danach` ist außerdem anfällig für K1. **Abhilfe:** einen Fall mit `.eml` oder `mailto:` als Argument und `-Antwort Abbrechen` als zweiten Fall. **Schwere: gering.**

### <a id="k7"></a>K7: *Cancel* hinterlässt keine Spur (bekannt, PRUEFER-41 K9)

(am Quelltext belegt)

`E132SpurMerken("E-133 Antwort: abgebrochen")` (:4603) landet nur im Puffer. Ausgegeben wird er erst nach `InitDebug` (:1213), und dorthin kommt der Abbruch nie. Das ist dieselbe Lücke wie 41-K9, durch [E-133](../Intern/BEFUNDE.md#e-133) um einen Weg erweitert. **Schwere: gering.**

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Gleichzeitige Prüfstandsläufe aus mehreren Arbeitsbäumen schreiben fremde „Stände vorher“ zurück; `Current` kann auf einen Prüfstand oder `C:\Temp\E133-gibt-es-nicht` zeigen, dann startet Gregors 7.2.1.131 per Doppelklick nicht; `testlauf.ps1` allein sichert nichts ([E-157](../Intern/BEFUNDE.md#e-157) fortschreiben) | mittel | nein; vor Gregors nächstem Test `Current` und `DLLPath` nachsehen |
| K2 | Fehlt `Current`, endet der Start weiter an `err` (:4622); bei Stapelmüll in `cmdLine` kommt die E-133-Frage umsonst (Vorschlag [E-208](../Intern/BEFUNDE.md#e-208)) | mittel | nein, Altbestand; Entscheidung Gregor |
| K3 | Leerzeichen ohne 8.3-Kurznamen: `RegisterCommandLine` schreibt ungeklammert, Eudora fragt bei jedem Start (Vorschlag [E-209](../Intern/BEFUNDE.md#e-209)) | gering bis mittel | nein |
| K4 | Vorgabe *No* bei abgezogenem Laufwerk biegt den Zeiger dauerhaft auf den Programmordner | gering | nein, Entscheidung Gregor |
| K5 | `TestE133` bleibt grün bei vertauschtem *Yes*/*No*, fehlender Klammer, falschem Ordnernamen und unterdrückter Registryberichtigung | gering | nein |
| K6 | `E-133p` wäre auch ohne die eigene Berichtigung grün; Anhang, `mailto:`, *Yes* und *Cancel* ungemessen | gering | nein |
| K7 | *Cancel* schreibt keine Spur (41-K9) | gering | nein |

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Geprüft wurde `git diff 9c23df4f..origin/e133_mailverzeichnis_fehlt`, also 80336491 (K3 als [E-209](../Intern/BEFUNDE.md#e-209) behoben, K5 eingearbeitet, K2 als [E-208](../Intern/BEFUNDE.md#e-208) offen) und ff49d438 (K1: `tools/pruefstand-sperre.ps1`, Anbindung in `testlauf.ps1` und `pruefstand-lauf.ps1`, `strg-n-pruefen.ps1` stillgelegt, Gegentest `pruefstand-sperre-test.ps1`). Mein Baum stand danach auf ff49d438. Eudora habe ich weder gebaut noch gestartet. Den Gegentest der Sperre habe ich gefahren, er startet kein Eudora und schreibt nur in den Probeschlüssel `HKCU\Software\Eudora72Probe`, den er danach entfernt.

### Ergebnis vorweg

`E209BefehlszeileBauen` schreibt, was alle eigenen Leser verstehen. Ohne Leerzeichen bleibt die Zeile Byte für Byte wie vorher, fremde Leser bekommen also nichts Neues. Der Puffer reicht für den längsten Fall. Die Sperre schließt gleichzeitige Läufe aus und setzt nur eigene Werte zurück. Beides ist gemessen: 372/372 Tests, Gegentest der Sperre 22/22.

Drei Dinge bleiben offen. Erstens gilt die Sperre nur in Bäumen, die sie schon haben. Sechs von zehn Arbeitsbäumen fahren noch das alte `pruefstand-lauf.ps1`, das alles zurückschreibt, darunter `.wt\messen`, das heute misst. Bis alle Bäume angeglichen sind, ist K1 nicht geschlossen (N3, gemessen). Zweitens macht ein abgeschossener Halter seine Registryänderungen nicht rückgängig, und der nächste Läufer hält sie als „Stand vorher“ fest. Das ist dieselbe Klasse wie K1, nur über einen anderen Weg (N2, belegt). Drittens schreibt `RegisterCommandLine` auf Laufwerken ohne 8.3-Namen jetzt Langformen, aber der Leser liest höchstens 261 Byte. Eine lange Zeile endet im Startabbruch von [E-208](../Intern/BEFUNDE.md#e-208), und die zweite Abfrage kann über den Puffer schreiben (N1, belegt, Reichweite Vermutung).

Für das Paket: Kein Fund hält 7.2.2.132 auf. N3 sollte vor dem nächsten Prüfstandslauf erledigt sein, sonst gilt K1 weiter.

### E209BefehlszeileBauen gegen die Leser

| Form (Beispiel) | `StartEudoraWithDefaultLocation` (:4232-4242) | `GetDirs` (fileutil.cpp:443-456) | `E132AufrufZerlegen` (:3913) |
|---|---|---|---|
| ohne Leerzeichen: `A B C` | unverändert | unverändert | unverändert |
| nur Programm: `"A x" B C` | springt über das `"…"` (:4232-4233), Rest `B C` | – | – |
| Verzeichnis und INI: `A "B x" "B x\C"` | Rest `"B x" "B x\C"` | trennt an `" ` (:443-444), `StripQuotesMT` beide | dieselbe Regel, beide richtig |
| INI fehlt (`GetShortPathName` scheitert, neue Einrichtung): `A "B x" ` | Rest `"B x" ` | trennt an `" `, `Ini` = leer, `SetupINIFilename` nimmt die Vorgabe (rs.cpp:1371) | Verzeichnis richtig, INI leer |

Alle Zeilen am Quelltext belegt, die mittlere Spalte zusätzlich im Test (`E209ProgrammAbschneiden`). Die letzte Zeile hat schon vorher so ausgesehen (`"%s %s %s"` mit leerem dritten Teil). Neu ist nur die Klammer. Die Form steht in keinem Test.

**Fremde Leser** (am Quelltext belegt):

- *Hermes / Eudora 7.1* hat dieselbe Lesestelle (567a5d87) und versteht die Klammer genauso.
- *MAPI* `GetEudoraWindowHandle` gibt die Zeile an `WinExec` (MAPI/mapifunc.cpp:238). Mit geklammertem Programm ist das jetzt eindeutiger als vorher.
- *MAPI* `IsEudoraMapi` hat einen alten Fehler im Zweig mit geklammertem Programm: `strchr(Command, '"')` findet das *erste* Anführungszeichen statt des schließenden (:456-458). `Program` bleibt dann unabgeschlossen, `GetFileVersionInfoSize` scheitert, und die Antwort ist 0xFFFFFFFF („Modus unbekannt“). Vorher kam dieser Zweig nie vor. Ein Programmpfad mit Leerzeichen war aber auch ungeklammert kaputt (`Program` = `C:\Program`). Kein Rückschritt.
- *EudoraBk* (DirectoryServices/EudoraBk/src/Protocol.cpp:166-171) trennt stumpf an Leerzeichen. Mit Leerzeichen im Pfad war das vorher und nachher falsch, ohne bleibt es gleich.

**Puffer.** `val` hat 3 × 260 + 10 = 790 Byte (:3793). Der längste Inhalt sind drei Teile zu je höchstens 260 Zeichen, 2 Leerzeichen, 6 Anführungszeichen und die Null, zusammen 789. `_sntprintf` mit Restlänge (:3769-3779), abgeschlossen bei Überlauf. Der Test „zu kleiner Puffer“ prüft das Wächterbyte. Belegt und gemessen.

### Gegenproben (in meinem Baum)

Gemessen. `eudora.cpp` habe ich vorübergehend geändert (Treffer je 1), mit `RunTests.cmd` neu gebaut, weil `Extract.ps1` die Funktion schneidet, und danach zurückgeschrieben. Die Prüfsumme gegen die Sicherung war gleich, 18 CRLF und 5863 LF wie vorher, `git status` leer.

| Lauf | Änderung | Ergebnis |
|---|---|---|
| 0 | keine | 372/372 |
| GE1 | `abKlammer[2] = false;`: INI nie geklammert | 371/372, rot `Teile mit Leerzeichen sind nicht geklammert (E-209)` |
| GE2 | `abKlammer[1]` nur nach dem Verzeichnis: hat nur die INI ein Leerzeichen, bleibt alles ungeklammert | **372/372, grün** (N6) |
| S0 | `pruefstand-sperre-test.ps1` | 22/22, B wartete 5158 ms, nach dem Abschuss übernahm B nach 86 ms |

### N1: Langformen ohne 8.3 können länger sein als der Leser

(am Quelltext belegt; Reichweite Vermutung)

Der Leser liest `Current` mit `buflen = sizeof(cmdLine)` = 261 Byte (:4197, :4212). Ohne 8.3-Namen ist jeder der drei Teile eine Langform, und das Mailverzeichnis steht zweimal darin. Ab etwa 85 Zeichen je Teil ist die Zeile länger als 260 Zeichen. Die Klammern bringen bis zu 6 Byte dazu. Dann liefert `RegQueryValueEx` `ERROR_MORE_DATA`, `err` ist gesetzt, und der Start endet bei :4679 wie in [E-208](../Intern/BEFUNDE.md#e-208). Schlimmer noch: Nach `ERROR_MORE_DATA` steht in `buflen` die nötige Länge. Die HKCR-Abfrage (:4226) bekommt deshalb einen zu großen Puffer gemeldet. Gibt es den HKCR-Wert, weil Eudora einmal mit Adminrechten lief, schreibt sie über `cmdLine` hinaus. So steht es in der Win32-Beschreibung von `RegQueryValueEx`. Das ist Altbestand, aber [E-209](../Intern/BEFUNDE.md#e-209) zielt genau auf die Laufwerke, auf denen die langen Zeilen entstehen. **Abhilfe:** `cmdLine` auf `3 * MAX_PATH + 10` vergrößern (dann passt `strcpy(buf, c)` nicht mehr ohne Prüfung, `buf` ebenfalls), `buflen` vor der zweiten Abfrage neu setzen, und `cmdLine[0] = 0` vorbelegen ([E-208](../Intern/BEFUNDE.md#e-208)). **Schwere: mittel.** In [E-209](../Intern/BEFUNDE.md#e-209) oder [E-208](../Intern/BEFUNDE.md#e-208) fortschreiben. **Hält das Paket nicht auf.**

### N2: Ein abgeschossener Halter hinterlässt seine Werte, und der nächste hält sie als „vorher“ fest

(am Quelltext belegt)

Wird der Halter von außen beendet, zum Beispiel durch die Zeitschranke eines Agenten, läuft sein `finally` nicht ([PRUEFER-59](PRUEFER-59.md#pruefer-59) K9). Der nächste Läufer übernimmt den verlassenen Mutex und meldet das nur (pruefstand-sperre.ps1:86-91). Danach hält er mit `Registry-Festhalten` die Werte des Abgeschossenen fest, also `Current` auf dessen Prüfstand oder auf `C:\Temp\E133-gibt-es-nicht`, und schreibt sie am Ende zurück. Gregors Wert ist dann dauerhaft weg, dieselbe Folge wie K1. **Abhilfe:** Der Halter schreibt sein Festgehaltenes neben die Halterdatei (`C:\Temp\Eudora72-Pruefstand.reg.json`). Wer einen verlassenen Mutex übernimmt, setzt zuerst danach zurück und löscht die Datei, bevor er selbst festhält. Mindestens sollte er einen „Stand vorher“, der selbst auf einen Prüfstand zeigt, laut melden. **Schwere: mittel.**

### N3: Sechs Arbeitsbäume haben die Sperre noch nicht

(gemessen: `tools/pruefstand-sperre.ps1` je Baum unter `.wt\`)

Ohne Sperre sind `chronist` (wt/chronist-20261102b), `e122` (main), `e194`, `lektor` (wt/lektor-20261102b), `messen` (messungen_vor_7_2_2_132) und `pruefer88`. Dort läuft das alte `pruefstand-lauf.ps1`. Es nimmt keine Sperre und schreibt am Ende *alle* Werte auf seinen Stand vorher zurück, auch die eines gleichzeitigen gesperrten Laufs. Der neue Lauf schützt sich also nur gegen neue Läufe. **Abhilfe:** Bis zum Merge und zum Angleichen aller Bäume keine Prüfstandsläufe aus Bäumen ohne `pruefstand-sperre.ps1`. Danach `Current` und `LaunchManager\DLLPath` einmal nachsehen. **Schwere: mittel.** **Hält das Paket nicht auf**, aber den Abschluss von K1.

### N4: Eine Ausnahme beim Zurücksetzen überspringt die Freigabe und den Rest

(am Quelltext belegt)

Im `finally` stehen `Registry-Zurueck` und dann `Sperre-Freigeben` hintereinander (testlauf.ps1:417-419, pruefstand-lauf.ps1:380-382). `testlauf.ps1` setzt `$ErrorActionPreference = 'Stop'`. Scheitert in `Registry-Zurueck` ein `Remove-ItemProperty` oder `New-ItemProperty`, zum Beispiel am Standardwert aus [PRUEFER-59](PRUEFER-59.md#pruefer-59) K9, bricht die Schleife ab. Die übrigen Werte bleiben stehen, und die Sperre wird erst beim Prozessende als verlassen frei, mit N2 als Folge. Zwischen `Sperre-Nehmen` und `try` liegen in `pruefstand-lauf.ps1` 35 Zeilen (:152-187). Eine Ausnahme dort hat dieselbe Folge, ist aber unwahrscheinlich (nur Funktionsdefinitionen und Zuweisungen). **Abhilfe:** jeden Wert in `Registry-Zurueck` in einem eigenen `try`, `Sperre-Freigeben` in einem inneren `finally`, `try` direkt hinter `Sperre-Nehmen`. **Schwere: gering.**

### N5: Der Gegentest der Sperre sieht die Anbindung nicht

(am Quelltext belegt)

`pruefstand-sperre-test.ps1` lädt nur das Modul. Nimmt man `Sperre-Nehmen` aus `testlauf.ps1` oder `pruefstand-lauf.ps1` heraus, oder stellt man im `finally` die Freigabe vor das Zurücksetzen, bleibt er 22/22. Fall 1 hängt außerdem daran, dass A binnen 2 s startet. Ein langsamer PowerShell-Start macht ihn rot. Das ist ein Fehlalarm, kein blindes Grün. **Abhilfe:** eine Quelltextprüfung, dass beide Werkzeuge `Sperre-Nehmen` vor `Registry-Festhalten` und `Registry-Zurueck` vor `Sperre-Freigeben` im selben `finally` haben, wie `TestE133` am Quelltext prüft. In Fall 1 warten, bis A „A-HAT“ geschrieben hat. **Schwere: gering.**

### N6: Der Testfall „nur die INI mit Leerzeichen“ schützt nichts

(gemessen, GE2)

Hat nur die INI ein Leerzeichen, geht auch die ungeklammerte Zeile richtig durch. Die INI ist der Rest hinter dem ersten Leerzeichen. Der Grund für das gemeinsame Klammern, den der Kommentar nennt (eine Zeile, die auf `"` endet, trennt `GetDirs` gar nicht, fileutil.cpp:446), ist ein anderer Fall: Verzeichnis ungeklammert, INI geklammert. Den baut der Test nicht. **Abhilfe:** genau diese Zeile an `E132AufrufZerlegen` geben und rot erwarten, oder `abKlammer[1]` am Quelltext festhalten. **Schwere: gering.**

### N7: Kleinigkeiten im Zurücksetzen

(am Quelltext belegt)

- **`PathCount` mit fremdem neuem `Path#`:** Die eigenen `Path#N` werden trotzdem entfernt, `PathCount` bleibt. Dann entsteht eine Lücke (im Gegentest so gewollt). `EuShlExt` verträgt das, es protokolliert nur *„The Path, Path#%d is empty“* (EuShlExt/ShellHookImpl.cpp:329), und `CompactRegistryEntries` schließt die Lücke später (EuShlRegEntryMgr.cpp:584-614).
- **`AlreadyWarned#N`** gehört zu den Begleitwerten (EuShlExt/RegDefines.h:11), fehlt aber in der Liste (pruefstand-sperre.ps1, `Path|WarnExtensions|DoNotWarnExtensions`). Ein eigener neuer Wert würde als FREMD gemeldet und bliebe stehen. Eudora.exe selbst schreibt ihn nicht, nur die Shell-Erweiterung beim Warnen.
- **Verdichtung während des Laufs:** Verdichtet `CompactRegistryEntries` während des Laufs, verschieben sich vorhandene `Path#k`. Der Vergleich nach Namen meldet die verschobenen fremden als FREMD und schreibt die alten Endwerte zurück. Folge wären doppelte Einträge, kein Verlust (Vermutung).
- **`Global\` und `Local\`:** Scheitert `Global\Eudora72-Pruefstand` für einen Prozess, etwa weil ein Prozess mit Adminrechten den Mutex mit enger Zugriffsliste angelegt hat, weicht er auf `Local\` aus. Dann schließen sich die beiden nicht mehr aus. Vermutung. Abhilfe: nicht ausweichen, sondern abweisen.

**Schwere: gering.**

### Übersicht Nachtrag

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| N1 | Ohne 8.3 kann `Current` länger als 260 Zeichen werden; der Leser bricht ab ([E-208](../Intern/BEFUNDE.md#e-208)-Weg), die HKCR-Abfrage kann über `cmdLine` schreiben | mittel | nein |
| N2 | Abgeschossener Halter: seine Prüfstandswerte werden vom nächsten als „vorher“ festgehalten und bleiben | mittel | nein |
| N3 | Sechs Arbeitsbäume ohne Sperre fahren das alte Zurücksetzen, darunter `.wt\messen` | mittel | nein, aber K1 erst nach Angleichen aller Bäume geschlossen |
| N4 | Ausnahme in `Registry-Zurueck` überspringt den Rest und die Freigabe | gering | nein |
| N5 | Gegentest der Sperre bleibt grün ohne Anbindung in `testlauf.ps1`/`pruefstand-lauf.ps1`; Fall 1 zeitabhängig | gering | nein |
| N6 | `TestE133`-Fall „nur INI mit Leerzeichen“ bleibt grün, wenn das gemeinsame Klammern fehlt (GE2) | gering | nein |
| N7 | `PathCount`-Lücke (verträglich), `AlreadyWarned#N` fehlt, Verdichtung, Ausweichen auf `Local\` | gering | nein |

## <a id="nachtrag-2-02-11-2026"></a>Nachtrag 2 (02.11.2026)

Geprüft wurde `git diff 863311f4..origin/e133_mailverzeichnis_fehlt -- Eudora71 tools` im Baum `.wt\pruefer87b`, Zweig wt/pruefer-20261102j, Stand eb7e67cd. Inhaltlich ist das eb7e67cd (N1, N2, N4 bis N7 eingearbeitet). Den Merge 7876f242 (main #209/#210) habe ich nur auf Verluste geprüft. Eudora habe ich weder gebaut noch gestartet. Vor dem Gegentest der Sperre lief kein Eudora-Prozess, und weder Halterdatei noch Standdatei lagen in `C:\Temp` (gemessen).

### Ergebnis vorweg

Die Einarbeitung trägt. Der Leser in `StartEudoraWithDefaultLocation` fasst jetzt, was der Schreiber schreibt, die zweite Abfrage kann nicht mehr über den Puffer schreiben, und `cmdLine` liest keinen Stapelinhalt mehr. Die Sperre setzt nach einem abgeschossenen Halter zuerst dessen Stand zurück. Eine Ausnahme beim Zurücksetzen überspringt die Freigabe nicht mehr. Gemessen: 390/390 Tests, Gegentest der Sperre 33/33 (B wartete 7583 ms, die Übernahme nach dem Abschuss dauerte 38 ms).

Ein neuer Fund, und er kommt von N1 selbst. Weil `buf` jetzt 790 Zeichen fasst, greift die Kurzform-Ausweiche aus PRUEFER-42 K3 an zwei Stellen erst ab 790 statt ab 261 Zeichen. `GetDirs` gibt das Verzeichnis aber an `CheckMailDirectory` weiter, und dort ist der Puffer weiterhin 261 Byte groß (P1, belegt). Treffen kann das nur einen Programmpfad von etwa 244 bis 259 Zeichen. Es hält das Paket nicht auf, sollte aber vor dem Merge berichtigt werden, weil es ein neuer Überlauf ist.

### N1 an allen Pufferstellen

(am Quelltext belegt, Zeilen in `eudora.cpp` am Stand eb7e67cd)

- **Registry lesen:** `buflen = sizeof(cmdLine) - sizeof(TCHAR)` und nach der gescheiterten ersten Abfrage neu gesetzt, `cmdLine[0] = 0` davor und nach einem Fehlschlag, dazu ein Abschluss am Ende des Puffers. Damit kann keine der beiden Abfragen über `cmdLine` hinaus schreiben, und ohne Wert bleibt `buf` leer. Richtig.
- **`strcpy(buf, c)`:** `c` zeigt in `cmdLine`, das höchstens 789 Zeichen und die Null trägt. `buf` ist gleich groß. Richtig.
- **Application Data:** `GetShortPathName(FullPath, buf, sizeof(cmdLine)/sizeof(TCHAR))` stimmt weiterhin, beide Puffer sind gleich groß. `GetPrivateProfileString(…, buf, sizeof(buf), …)` meldet die Größe in Byte statt in Zeichen, was mit ANSI dasselbe ist.
- **`E132AufrufZerlegen`** schneidet auf `MAX_PATH` (`szVerzeichnis`, `szIni`). Die E-132- und E-133-Entscheidung fällt damit am abgeschnittenen Namen, `GetDirs` bekommt dagegen das ganze `buf`. Aus unserem Schreiber ist der erste Teil nie länger als 262 Zeichen (260 und die Klammern), der Unterschied tritt also nur bei einem fremden oder von Hand geschriebenen Wert auf. Kein eigener Fund.
- **E-208-Weg:** Fehlen beide Werte, ist `cmdLine` leer, also auch `buf`. Danach kommt Application Data, und `err` beendet den Start wie bisher. Die Frage mit dem Unsinnspfad aus K2 kann nicht mehr kommen. Der Startabbruch bleibt, wie vermerkt, eine Entscheidung für Gregor.
- **Neu: P1**, siehe unten.

### P1: Die Kurzform-Ausweiche greift erst ab 790 Zeichen, `CheckMailDirectory` hat 261

(am Quelltext belegt; nicht gemessen)

Zwei Stellen fragen, ob der geklammerte Pfad in `buf` passt, und weichen sonst auf die 8.3-Form aus (PRUEFER-42 K3):

- *[E-132](../Intern/BEFUNDE.md#e-132) „Nein“*: `if (szGeklammert.GetLength() >= (int)(sizeof(buf) / sizeof(TCHAR)))` (:4576). `szEigenes` ist `ExecutableDir` + `Mailverzeichnis` (:4531).
- *[E-133](../Intern/BEFUNDE.md#e-133) „No“*: `E133InBefehlszeile(szGewaehlt, buf, sizeof(buf) / sizeof(TCHAR))` (:4691) mit `if (szGeklammert.GetLength() >= (int) nBuf)` (:4150). `szNeben` ist `ExecutableDir` + `\Mailverzeichnis` (:4108).

Seit eb7e67cd hat `buf` 790 Zeichen (:4205). Bis dahin hieß die Grenze 261. Ein Pfad mit 259 bis 789 Zeichen wird jetzt geklammert durchgereicht. `GetDirs` nimmt die Klammern weg und ruft `CheckMailDirectory(CmdLine, …)`. Dort steht `char szShortEDir[_MAX_PATH + 1]` und `strcat(szShortEDir, dir)` (fileutil.cpp:324, :340), danach `strcpy(Edir, szShortEDir)` in einen gleich großen Puffer (:356). Ein Verzeichnisname ab 261 Zeichen schreibt dort über den Stapel. Erreichbar ist das, wenn `ExecutableDir` zwischen etwa 244 und 259 Zeichen lang ist, denn mehr lässt `GetModuleFileName` mit `MAX_PATH` nicht zu. Vorher kam an dieser Stelle die Kurzform, oder `buf` schnitt ab. Die *Yes*-Wahl ist nicht betroffen (`SHGetPathFromIDList` liefert höchstens `MAX_PATH`).

**Abhilfe:** an beiden Stellen gegen `MAX_PATH` vergleichen (die Grenze von `GetDirs`/`CheckMailDirectory`), nicht gegen `sizeof(buf)`. Zusätzlich gehört in `CheckMailDirectory` eine Längenprüfung vor das `strcat`, dann ist auch ein fremder Registrywert abgefangen. Einen Testfall dafür gibt es noch nicht. Er ließe sich fensterlos bauen: `E133InBefehlszeile` mit einem 250 Zeichen langen Ordner auf ein Ergebnis von höchstens `MAX_PATH` prüfen. **Schwere: gering** (enger Bereich, aber Stapelüberlauf). **Hält das Paket nicht auf.** Vor dem Merge berichtigen.

### N2: Stand ablegen und übernehmen

(am Quelltext belegt; Fall 6 gemessen)

- **Kann der Stand eines noch lebenden Halters übernommen werden?** Nein. Die Standdatei wird erst gelesen, wenn der Mutex gehalten wird (Sperre-Nehmen nach `WaitOne`). Solange der Halter lebt, kommt kein anderer dorthin. Ein erbendes Kind kehrt vorher zurück und liest sie nie. `Registry-Festhalten` legt nur ab, wenn der Prozess den Mutex selbst hält und nicht erbt. Belegt.
- **Reihenfolge beim Übernehmen:** Erst wird nach dem fremden Stand zurückgesetzt und die Datei gelöscht (in `Sperre-Nehmen`), dann hält der neue Läufer fest (`Registry-Festhalten` im `try` von `testlauf.ps1` und `pruefstand-lauf.ps1`). Richtig.
- **Wird die Datei nach Erfolg gelöscht?** Ja, am Ende von `Registry-Zurueck`, aber nur, wenn `$bild.Pid -eq $PID`. Scheitert vorher etwas außerhalb der Einzel-`try` (`Get-Item`/`New-Item` je Schlüssel, `reg.exe`), bleibt die Datei liegen. Der nächste Halter setzt dann noch einmal nach diesem Stand zurück. Das schadet nicht, weil nur Werte angefasst werden, die auf einen Prüfstand zeigen. Kein Fund.
- **Randfälle**, beide gering und ohne eigene Nummer:
  - Ist die pid des Abgeschossenen inzwischen an den Übernehmer vergeben, gilt der Stand als eigener und wird ungelesen gelöscht (`if ($alt.Pid -ne $PID)`). Vermutung, sehr unwahrscheinlich.
  - Ein liegengebliebener Stand mit anderer Basis legt die Probeschlüssel wieder an (`New-Item -Path $s -Force` bei fehlendem Schlüssel). Das kann nur der Gegentest selbst hinterlassen, wenn er mitten in Fall 6 abbricht. Dann entsteht `HKCU\Software\Eudora72Probe` mit Beispielwerten, Ballast ohne Wirkung.

### N4 und N5

- **N4** (belegt): In beiden Werkzeugen steht `Sperre-Nehmen` jetzt unmittelbar vor dem `try`, `Registry-Festhalten` darin, und die Freigabe in einem inneren `finally` hinter dem Zurücksetzen. Jede Registryänderung hat ein eigenes `try` mit `-ErrorAction Stop`, Fehler werden gemeldet. Richtig.
- **N5** (gemessen, Fall 7): Die Quelltextschranke prüft vier Stellen der Reihenfolge und das innere `finally`. Ihre Gegenproben (vertauscht, ohne `Sperre-Nehmen`) fallen im Speicher durch. Grenze: Sie prüft nur die Reihenfolge der Namen, nicht ob `Registry-Festhalten` wirklich innerhalb des `try` steht. Das genügt für die beiden gefundenen Fehlerbilder. Fall 1 wartet jetzt auf „A-HAT“ statt auf 2 s.

### Merge 7876f242 auf Verluste

(gemessen)

Unter `Eudora71/` und `tools/` hat der Merge nur in vier Dateien von Hand zusammengeführt: `TESTLAEUFE.md`, `WERKZEUGE.md`, `ZWEIGE.md` und `pruefstand-faelle.txt`. Gezählt habe ich die nichtleeren Zeilen jedes Elternstands, die im Ergebnis fehlen. In `TESTLAEUFE.md`, `ZWEIGE.md` und `pruefstand-faelle.txt` fehlt keine. In `WERKZEUGE.md` fehlen drei: die Standzeile und die alten Einträge zu `strg-n-pruefen.ps1` und `testlauf.ps1`. Alle drei stehen in neuer Fassung da (Stilllegung, Sperre). Kein Verlust.

### Übersicht Nachtrag 2

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| P1 | Seit `buf` 790 Zeichen fasst, kürzt die [E-132](../Intern/BEFUNDE.md#e-132)/E-133-Ausweiche erst ab 790 statt 261; ein Verzeichnis von 261 bis 275 Zeichen läuft in `CheckMailDirectory` (fileutil.cpp:340) über den Stapel (nur bei Programmpfad ab etwa 244 Zeichen) | gering | nein; vor dem Merge berichtigen |
| – | N1, N2, N4, N5, N6, N7 eingearbeitet und geprüft; N3 bleibt offen (in [E-157](../Intern/BEFUNDE.md#e-157) vermerkt) | – | – |
