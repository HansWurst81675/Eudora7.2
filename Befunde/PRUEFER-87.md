# <a id="pruefer-87"></a>PRUEFER-87

Lauf nach [PRUEFER-86](PRUEFER-86.md). Geprüft wurde `456c95e1..HEAD -- Eudora71 tools Releases/1.0` auf Zweig wt/pruefer-20261102g (von `origin/e133_mailverzeichnis_fehlt`, Stand 61882b61, also mit #208). Inhaltlich neu gegenüber PRUEFER-86 sind c473e7f7 (Behebung [E-133](../Intern/BEFUNDE.md#e-133), `TestE133.cpp`, `messen-e133.ps1`, Schalter in `pruefstand-lauf.ps1`) und 1275215f (Messung, Fälle `E-133p`/`E-133q`). Der Rest des Bereichs ist [E-39](../Intern/BEFUNDE.md#e-39) und wurde in [PRUEFER-85](PRUEFER-85.md) geprüft; seit c473e7f7 hat sich unter `Eudora71/` nichts mehr geändert (gemessen: `git diff --stat c473e7f7 61882b61 -- Eudora71` leer). Schwerpunkte: `StartEudoraWithDefaultLocation` und die vier `E133…`-Helfer, alle Startwege, `RegisterCommandLine(NULL)`, der Fall „`Current` und HKCR fehlen beide“, `TestE133`, `messen-e133.ps1`, und auf Wunsch des BEHEBERS: schützen `testlauf.ps1` und `pruefstand-lauf.ps1` Gregors Registry, wenn mehrere Arbeitsbäume gleichzeitig messen ([E-157](../Intern/BEFUNDE.md#e-157))? Eudora habe ich weder gebaut noch gestartet, keinen Prüfstand angefasst, nichts in der Registry gelesen oder geschrieben. Die Registryfrage ist nur am Quelltext beantwortet.

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
