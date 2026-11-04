# <a id="pruefer-93"></a>PRUEFER-93

Lauf nach PRUEFER-92. Zweig wt/pruefer-20261103d, abgezweigt von `origin/paket_7_2_2_132`. Geprüft wird `origin/main..HEAD -- Eudora71 tools Releases/1.0`. Das sind zwei Commits: 561f3ebf (Versionssprung auf 7.2.2.132) und e96dd180 (Paket geschnürt, Regel in `tools/messen-e184.ps1` berichtigt). Dazu habe ich das Paket `Eudora72-7.2.2.132-release` und sein ZIP gelesen, aber nichts gestartet und nichts geschrieben. Eudora habe ich weder gebaut noch gestartet. Ich habe kein Fenster geöffnet und keinen Prüfstand angefasst.

## Ergebnis vorweg

Das Paket ist in Ordnung. Die Fassung steht überall gleich da: in `VERSION`, in allen fünf Werten von `Version.h`, in der Dateiversion der `Eudora.exe` im Paket, in der Baukennung, im Verzeichnisnamen und im ZIP-Namen. Die `Eudora.exe` im Paket hat dieselbe Prüfsumme wie in `Releases/PAKETE.md`. Das Paketverzeichnis hat 163 Dateien, so wie dort angegeben, und seit 12:41 wurde darin nichts geändert. Das Prüfstandsbuch stimmt mit `tools/TESTLAEUFE.md` überein: 47 Starts zwischen 11:49 und 12:26, 81 Fälle, alle grün am Bau im Paket. Die Testsuite läuft in meinem Baum mit 408/408.

Die neue Regel `grund=([^\s"]+)` ist richtig. Sie liest alle sieben E-170-Fälle richtig. Kein anderes Messskript liest einen Wert am Ende einer Dialogzeile. Die Ursache steht im Quelltext: Eudora setzt hinter jede Zeile der Bereiche *Dialog*, *Sent* und *Received* ein `"`. Rot waren genau die vier Fälle, deren Grund aus der Zeile *nach dem Abgleich* kommt. Nur dort steht `grund=` am Zeilenende.

Zwei Dinge sind neu:

- **Das ZIP neben Gregors Testverzeichnis ist nicht mehr das geschnürte (K2, gemessen).** Um 13:04:58 wurde es überschrieben, also 21 Minuten nach dem Commit. Jetzt ist es 18.139.827 Byte groß und hat 333 Einträge: das Paket zweimal, einmal flach und einmal in einem Unterordner. Die SHA-256 in `PAKETE.md` stimmt nicht mehr. Das Original im Arbeitsbaum des Schnürers ist unversehrt. Wer das ZIP geändert hat, weiß ich nicht.
- **`bauen.ps1` prüft die Tests des Baums, in dem man gerade steht, nicht die des gebauten Baums (K3, E-218, am Quelltext belegt, Weg gemessen).** Startet die Hauptsitzung den Bau eines Arbeitsbaums aus dem Projektordner, läuft die `EudoraTests.exe` des Hauptbaums. So sieht es die Regel *„Hauptsitzung bleibt im Projektordner“* vor, es ist also der Normalfall.

**Kein Fund hält das Paket auf.** Gregor testet das Verzeichnis, und das ist unverändert. Vor einem Release muss das ZIP aus dem Arbeitsbaum des Schnürers neu daneben gelegt und nachgemessen werden (K2). Neue Kennungen: E-218 (K3) und E-219 (K5).

## 1. Versionssprung

| Prüfung | Ergebnis | Kennzeichnung |
|---|---|---|
| `VERSION` | `7.2.2.132` | gemessen |
| `Version.h` | `EUDORA_VERSION1..4` = 7, 2, 2, 132; `EUDORA_BUILD_NUMBER 7,2,2,132`; `EUDORA_BUILD_DESC "Version 7.2.2.132\0"`; `EUDORA_BUILD_VERSION "7.2.2.132"`. Alle fünf Werte stimmen überein. | belegt (Version.h:8-14) |
| Übrige Stellen mit der alten Nummer | `7.2.1.131` steht in `Eudora71/` nur noch in Kommentaren und Testmeldungen (msgutils.cpp, tocview.cpp, E170Zuordnung.h, ImapActionQueue.cpp, Tests). | belegt (grep) |
| Wo `EUDORA_VERSION3` wirkt | Im Betreff des Fehlerberichts (eudora.cpp:545-553), im Audit-Start als `722` statt `721` (eudora.cpp:1122) und über COM (QComApplication.cpp:602). Nichts davon prüft die Nummer gegen einen gespeicherten Wert. | belegt |
| Dateiversion der `Eudora.exe` im Paket | `FileVersion` 7.2.2.132, `ProductVersion` 7.2.2.132, fester Teil 7.2.2.132 | gemessen (`FileVersionInfo`, nur gelesen) |
| Baukennung in der `Eudora.exe` im Paket | genau eine: `Eudora 7.2.2.132+561f3ebf 2026-11-03 11:46` (ohne Sternchen) | gemessen |
| Titelzeile | Alle 47 Starts des vollen Laufs zeigen dieselbe Kennung, nur E-128k um 12:26:05 zeigt nur `Eudora` (siehe 3.). | gemessen (TESTLAEUFE.md) |
| Verzeichnis und ZIP | `Eudora72-7.2.2.132-release` und `Eudora72-7.2.2.132-release.zip` | gemessen |
| `Eudora.exe` gegen PAKETE.md | SHA-256 `1e998bd4…8ac9a43c`, gleich | gemessen |
| `PRUEFBERICHT.md` im Paket gegen `Releases/PRUEFBERICHT.md` | byte-gleich (`cmp`) | gemessen |
| Schranke `pruefe-fassungsnummer.pl` | rc 0 am Stand. Gegenprobe: `EUDORA_BUILD_VERSION` vorübergehend auf 7.2.2.133 gesetzt, Ergebnis **rc 1**, „VERSION sagt 7.2.2.132, Eudora71/Version.h sagt 7.2.2.133“. Gegenprobe 2: nur `EUDORA_BUILD_NUMBER` auf `7,2,2,133` gesetzt, Ergebnis **rc 0**, also nicht bemerkt (K4). Beide Male mit Perl `:raw` geändert und aus der Sicherung zurückgeholt, `cmp` byte-gleich, `git status` leer. | gemessen |

## 2. `messen-e184.ps1`: `grund=([^\s"]+)`

**Woher das Anführungszeichen kommt.** `QCLogFileMT::PutLineTrailer` schreibt für `DEBUG_MASK_TRANS`, `DEBUG_MASK_RCV` und `DEBUG_MASK_DIALOG` ein `"` ans Zeilenende (QCUtils/src/debug.cpp:287-292). Der Vorspann ist `IDS_DEBUG_DIALOG` = `Dialog: "` (EudoraRes.rc:9848). Seit [PRUEFER-90](PRUEFER-90.md#pruefer-90) K10 schreiben beide E-170-Zeilen in `DEBUG_MASK_DIALOG`. Belegt.

**Die beiden Zeilen.**

| Zeile | Quelle | Wo steht `grund=` | alte Regel `\S+` |
|---|---|---|---|
| `E-170 Labels beim Verschieben im Konto: … grund=%s vorgemerkt=%d schon-da=%d` | ImapActionQueue.cpp:1780 | in der Mitte | richtig |
| `E-170 Labels beim Verschieben im Konto, nach dem Abgleich: … grund=%s` | ImapToc.cpp:2071 | am Zeilenende | liest `zugeordnet"` |

Die Erwartungen in `tools/pruefstand-faelle.txt` (Zeilen 488-514) passen genau dazu. Die Fälle mit `ok`, `fehlgeschlagen` und `keine-neuen-uids` (E-170p, c, s) haben ihren Grund aus der ersten Zeile und waren schon vorher grün. Die Fälle mit `zugeordnet` und `mehrdeutig` (E-170o, m, f, g) haben ihn aus der zweiten Zeile, und genau diese vier waren rot. Damit ist die Erklärung im Commit am Quelltext belegt. Die roten Ausgaben selbst habe ich nicht gesehen, sie sind überschrieben.

**Die Regel an Beispielzeilen** (gemessen in PowerShell, beide Regeln auf dieselbe Zeile):

| Zeile | alt | neu |
|---|---|---|
| Dialog, Mitte, `grund=keine-neuen-uids vorgemerkt=1 …"` | `keine-neuen-uids` | `keine-neuen-uids` |
| Dialog, Ende, `… grund=zugeordnet"` | `zugeordnet"` | `zugeordnet` |
| Dialog, Ende, `… grund=mehrdeutig"` | `mehrdeutig"` | `mehrdeutig` |
| alter Bereich Misc (ohne Anführungszeichen) | `zugeordnet` | `zugeordnet` |
| Dialog, Ende, Leerzeichen hinter `"` | `zugeordnet"` | `zugeordnet` |
| Dialog, Ende, leerer Grund `grund="` | `"` | kein Treffer → `(keine-logzeile)` |

Den letzten Fall kann es nicht geben: `E170WegGrund` (E170Zuordnung.h:146-157) und ImapToc.cpp:2061-2067 liefern nur nicht-leere Wörter ohne Leerzeichen und ohne `"`. Würde er doch auftreten, wäre der Fall rot und nicht falsch grün. Die Regel kann also keinen echten Fehler verdecken: Ein falscher Grund wird weiter als falscher Grund gelesen. Belegt.

**Liest ein anderes Messskript `grund=` oder einen Wert am Zeilenende ebenso falsch?** Nein. Ich habe alle 26 Werkzeuge durchsucht, die `eudora.log` lesen:

| Skript | Was es liest | Ergebnis | Kennzeichnung |
|---|---|---|---|
| `messen-e184.ps1:521-522` | `vorgemerkt=(\d+)`, `schon-da=(\d+)`, nur aus der Zeile `…im Konto: ` (Mitte, Ziffern) | richtig | belegt |
| `messen-e170*.ps1` (7 Hüllen), `messen-e189.ps1` | rufen `messen-e184.ps1` auf, lesen selbst nichts | richtig | belegt |
| [E-184](../Intern/BEFUNDE.md#e-184), E-184m, [E-189](../Intern/BEFUNDE.md#e-189) | Ihre Ergebniszeilen `E184`, `E184M` und `E189` enthalten keinen Logwert. | nicht betroffen | belegt |
| [E-192](../Intern/BEFUNDE.md#e-192) | hat keinen Prüfstandsfall (BEFUNDE: „nie gemessen“) | nicht betroffen | belegt |
| `messen-e39.ps1:355-358` | ` aktuell=(\S+)` am Zeilenende, aber die Zeile kommt aus `DEBUG_MASK_MISC` (persona.cpp:621-623) und hat kein `"` | heute richtig | belegt |
| `messen-hilfe.ps1:302` | `fehler=\S+`, danach folgt ` winfehler=` (mainfrm.cpp:6211) | richtig | belegt |
| `messen-e204.ps1:299-300` | `> USER (.*)$`, liest das POP-Protokoll des Prüfservers, nicht `eudora.log` (:68) | nicht betroffen | belegt |

Rest (K1): Dieselbe Falle wartet auf jede neue Logzeile in den Bereichen *Dialog*, *Sent* und *Received*, deren letzter Wert gelesen wird. Sie trifft auch `messen-e39.ps1`, falls die E-39-Zeile einmal nach *Dialog* wandert, wie es [E-170](../Intern/BEFUNDE.md#e-170) mit [PRUEFER-90](PRUEFER-90.md#pruefer-90) K10 getan hat.

## 3. Prüfstandsbuch, TESTLAEUFE, Prüfbericht

| Prüfung | Ergebnis | Kennzeichnung |
|---|---|---|
| Starts 11:49-12:26 in `TESTLAEUFE.md` | 47, und `pruefstand-dauer.txt` sagt `starts 47`. Das Ende 12:26:43 minus 2220 s ergibt 11:49:43, der erste Start war um 11:49:46. | gemessen |
| Starts danach | 7 Starts zwischen 12:29:45 und 12:39:41, nur [E-170](../Intern/BEFUNDE.md#e-170). `pruefstand-ergebnis.txt` sagt `nur=E-170`, 7/7. | gemessen |
| Neue Zeilen in `TESTLAEUFE.md` | 54 (47 + 7), keine doppelt | gemessen |
| Fälle in `pruefstand-faelle.txt` | 81 | gemessen |
| Einträge im Buch | 84. Davon sind 81 genau die 81 Fälle: 74 von 12:26:42 und 7 von 12:39:43, alle `ok`, alle mit dem Bau `7.2.2.132+561f3ebf 2026-11-03 11:46`. Die übrigen 3 sind `E-128k-alt`, `E-128p-alt` und `E-128t-alt` von 08:29 am alten Bau. Diese Fälle stehen nicht mehr in der Fallliste. | gemessen (diff der Kennungen) |
| Wertet `pruefbericht.pl` die drei `-alt` aus? | Nein. Gezählt werden nur die Kennungen der Fallliste (pruefbericht.pl:205-216). Der Bericht nennt zu Recht 81/81. | belegt |
| Bau im Buch | wird aus der `Eudora.exe` des Prüfstands gelesen (`BauKennung`, pruefstand-lauf.ps1, um :420), nicht aus der Titelzeile. Dass bei E-128k um 12:26:05 die Kennung im Titel fehlt, ändert also nichts am Buch. Warum sie fehlt, weiß ich nicht. Vermutlich war ein Nachrichtenfenster maximiert. | belegt / Vermutung |
| Prüfbericht: Dauer | 37 min 00 s = 2220 s | gemessen |
| Prüfbericht: Kopf | `561f3ebf — Arbeitsbaum nicht sauber (2 Dateien)`. Welche zwei Dateien, sagt er nicht (K6). | gemessen |
| Unit-Tests in meinem Baum | `RunTests.cmd`: 408 Tests, 408 bestanden, Rückgabe 0. Eudora-Code wie 561f3ebf. | gemessen |

Wiederkehrend und nicht neu: [E-133](../Intern/BEFUNDE.md#e-133) endet bei jedem Lauf mit „Kein Hauptfenster … musste abgeschossen werden“, weil der Fall eine Rückfrage vor dem Hauptfenster erwartet. [E-205](../Intern/BEFUNDE.md#e-205) braucht jedes Mal 30 s zum Schließen und wird abgeschossen. So steht es auch an jedem Lauf seit dem 02.11. Beide Fälle sind grün. Ich melde das nur, damit es nicht für neu gehalten wird.

## 4. Das Paket

| Prüfung | Ergebnis | Kennzeichnung |
|---|---|---|
| Dateien im Verzeichnis | 163, wie in PAKETE.md:189. Neuer als die `Eudora.exe` (11:47) sind nur die DLLs aus demselben Bau, `PRUEFBERICHT.md`, `Hilfe/*.html` und `Mailverzeichnis/Eudora.ini` (alle 12:41). | gemessen |
| Gegen 7.2.1.131 | gleich, nur der Ordner `Hilfe` ist hinzugekommen ([A-5](../Intern/BEFUNDE.md#a-5)) | gemessen |
| ZIP im Arbeitsbaum des Schnürers (`Releases/`) | 9.174.979 Byte, SHA-256 `177b5997…9115478`, 163 Einträge, 12:41:17. Das ist genau der Wert in PAKETE.md. | gemessen (nur gelesen) |
| ZIP neben dem Testverzeichnis | **18.139.827 Byte, SHA-256 `9a5095d6…eaef9fc`, 333 Einträge, geändert 13:04:58** | gemessen (K2) |

## 5. Funde

### <a id="k1"></a>K1 (gering): ein Wert am Ende einer Dialogzeile trägt das schließende `"`

- **Was passiert:** Eine Messregel mit `\S+` oder `(.*)$` liest bei Zeilen der Bereiche *Dialog*, *Sent* und *Received* das `"` mit. Der Fall wird rot, obwohl das Programm richtig arbeitet. Das ist einmal passiert und kostete beim Schnüren einen zweiten E-170-Lauf (10 Minuten). Falsch grün kann der Fehler nicht machen, er macht nur falsch rot.
- **Wie oft:** Bei jeder künftigen Logzeile, die in einen dieser Bereiche wandert oder neu dort entsteht. Heute ist keine weitere Stelle betroffen (Tabelle in 2.).
- **Behebung:** Die Berichtigung in e96dd180 ist richtig und reicht für [E-170](../Intern/BEFUNDE.md#e-170). Billig wäre es, die Falle als Klasse abzustellen. Eine kleine gemeinsame Funktion `LogWert($zeile, $schluessel)` könnte vor dem Lesen ein `"` am Zeilenende abschneiden. `messen-e184.ps1` und `messen-e39.ps1` würden sie benutzen, und ein Selbsttest würde die sechs Zeilen aus 2. prüfen. Das sind etwa 20 Zeilen. Gehört zu [E-170](../Intern/BEFUNDE.md#e-170), keine eigene Kennung.

### <a id="k2"></a>K2 (mittel, vor dem Release): das ZIP neben dem Testverzeichnis wurde nach dem Schnüren verändert

- **Gemessen:** `Eudora72-7.2.2.132-release.zip` neben dem Testverzeichnis hat jetzt 333 Einträge. 163 davon liegen flach mit `\` als Trenner, das ist das geschnürte ZIP. Dazu kommen 170 unter `Eudora72-7.2.2.132-release/` mit `/` als Trenner, Verzeichniseinträge eingeschlossen. Das sieht aus wie das Verzeichnis, nachträglich ins vorhandene ZIP gelegt. Größe, Prüfsumme und Zeit passen nicht mehr zu PAKETE.md:189 (*„byte-gleich daneben“*). Nach 12:44 gibt es keinen Commit in irgendeinem Zweig. Das Verzeichnis selbst ist unverändert.
- **Was schiefgeht:** Wer dieses ZIP weitergibt oder hochlädt, liefert das Paket doppelt aus, einmal mit einem Unterordner. Die Angabe in PAKETE.md ist dann falsch. Für Gregors Test spielt das keine Rolle, er testet das Verzeichnis.
- **Wie oft:** einmal, jetzt.
- **Behebung, Aufwand:** Klären, ob Gregor das ZIP selbst geändert hat (Vermutung: ja, von Hand gepackt). Vor einem Release das ZIP aus `Releases/` im Arbeitsbaum des Schnürers wieder daneben kopieren und die SHA-256 gegen PAKETE.md messen. Das ist eine Minute. Das Hochladen sollte ohnehin aus `Releases/` geschehen, wie bei 7.2.1.131 (PAKETE.md:205). Keine Kennung, denn das ist ein Zustand und kein Codefehler.

### <a id="k3"></a>K3 (mittel): `bauen.ps1` fährt die Testsammlung des Aufrufverzeichnisses, nicht die des gebauten Baums (E-218)

- **Belegt am Quelltext:** `bauen.ps1` bestimmt seine Wurzel aus dem eigenen Pfad (`$wurzel = Split-Path -Parent $PSScriptRoot`, bauen.ps1:290). Den Prüfer ruft es zwar über den eigenen Pfad auf (`Join-Path $PSScriptRoot 'pruefe-tests-gruen.pl'`, :1260, Aufruf `--ohne-bau --hinweis`, :1276), wechselt aber nicht das Verzeichnis. `pruefe-tests-gruen.pl` sucht die Wurzel im **aktuellen Verzeichnis**: `my $wurzel = -f 'VERSION' ? '.' : '..';` (:53). Dort liegt dann auch `Eudora71/Tests/Build/Debug/EudoraTests.exe` (:54).
- **Gemessen** (dieselbe Pfadlogik als Perl-Einzeiler in vier Verzeichnissen, nichts ausgeführt):

| Aufrufverzeichnis | gefundene `EudoraTests.exe` |
|---|---|
| Projektordner (Hauptbaum) | die **des Hauptbaums**, Stand 08:53 |
| Wurzel des Arbeitsbaums | die eigene, 13:05 |
| `tools/` des Arbeitsbaums | die eigene |
| `Eudora71/Tests` des Arbeitsbaums | keine, „fehlt … Nicht geprueft“, rc 0 |

  Aus einem Verzeichnis außerhalb des Repos meldet `pruefe-tests-gruen.pl --ohne-bau --hinweis` *„fehlt - MSBuild ist hier vermutlich nicht vorhanden. Nicht geprueft“* mit rc 0 (gemessen). Die Meldung nennt also eine falsche Ursache.
- **Was schiefgeht:** Nach dem Bau eines Arbeitsbaums steht „Alle 408 Tests bestanden“ oder „MANGEL“ für die Tests eines **anderen** Baums, und zwar mit einer womöglich alten `.exe`. Eine Behebung, die einen Test rot macht, sieht so grün aus, und eine rote Regression bleibt unbemerkt, bis der `pre-push` läuft. Der Bau selbst und das Paket sind nicht betroffen. Der `pre-push`-Haken und `pruefbericht.pl` laufen in der Wurzel des Baums und lesen deshalb die richtige `.exe`. Das ist am Aufruf belegt: Git startet Haken in der Wurzel des Arbeitsbaums. Die Unit-Zahl im Prüfbericht von 7.2.2.132 ist also nicht betroffen, und ich habe 408/408 in meinem Baum nachgemessen.
- **Zweite Schwäche am selben Ort:** `--ohne-bau` fährt die `.exe`, die gerade da liegt. `bauen.ps1` baut die Testsammlung nie (grep: kein Aufruf von `pruefe-testbau.pl` oder `Tests.vcxproj`). Nach einer Änderung an einem Test oder an einer geprüften Funktion läuft also die alte Sammlung. Die Tests mit dem Zusatz *(Quelltext)* lesen die Quellen zur Laufzeit. Ob sie das relativ zur `.exe` tun und deshalb trotzdem den neuen Stand sehen, habe ich nicht geprüft (Vermutung).
- **Wie oft:** bei jedem `bauen.ps1`, das nicht aus dem gebauten Baum gestartet wird. Nach der Regel *„Hauptsitzung bleibt im Projektordner“* ist das bei jedem Bau eines Arbeitsbaums durch die Hauptsitzung so. Gemeldet hat es der Schnürer.
- **Behebung, Aufwand:** Erstens in `bauen.ps1` um den Aufruf `Push-Location $wurzel` … `Pop-Location` (in `finally`) legen. Genau so macht es `paket-bauen.ps1:445` schon. Das sind 3 Zeilen. Zweitens soll `pruefe-tests-gruen.pl` die Wurzel aus dem eigenen Pfad ableiten, etwa `$0 =~ m{^(.*)[\\/]tools[\\/][^\\/]+$}` wie in `pruefe-auspacken.pl:63`. `FindBin` kommt nicht in Frage, es versteht laut `paket-bauen.ps1:319` im Git-Perl keinen Backslash-Pfad. Außerdem soll es den absoluten Pfad und die Zeit der gefahrenen `.exe` ausgeben. Das sind etwa 5 Zeilen. Drittens soll `bauen.ps1` ohne `--ohne-bau` aufrufen, damit `pruefe-testbau.pl` die Sammlung bei Bedarf neu baut. Das kostet etwa 10 s je Bau (Dauer laut Prüfbericht). Dieselbe Pfadzeile `-f 'VERSION' ? '.' : '..'` steht in 24 Werkzeugen. Schädlich ist sie nur dort, wo ein Skript aus einem fremden Baum aufgerufen wird. Das gilt heute nachweislich für diesen einen Weg.
- **Gegenprobe nach der Behebung:** `bauen.ps1` des Arbeitsbaums aus dem Projektordner aufrufen, vorher in der `.exe` des Arbeitsbaums einen Test rot machen. Der Bau muss dann „MANGEL“ melden.

### <a id="k4"></a>K4 (gering): die fünf Nummern in `Version.h` werden nicht gegeneinander geprüft

- **Gemessen:** Wird `EUDORA_BUILD_NUMBER` allein auf `7,2,2,133` gesetzt, meldet `pruefe-fassungsnummer.pl` rc 0. Es liest nur `EUDORA_BUILD_VERSION` (kennung-erzeugen.pl:115 ebenso). `bauen.ps1:1174-1194` vergleicht den festen Teil der Ressource mit `EUDORA_BUILD_NUMBER` und den Text mit `EUDORA_BUILD_VERSION`, aber nicht die beiden miteinander. Auch `EUDORA_VERSION1..4` und `EUDORA_BUILD_DESC` prüft niemand.
- **Was schiefgeht:** Rutscht beim Versionssprung eine der fünf Zeilen durch, zeigt der Explorer unter *Details → Dateiversion* den festen Teil, also die falsche Nummer. Titelzeile und Paketname tragen dann die richtige. Heute stimmen alle fünf (gemessen).
- **Wie oft:** bei jedem Versionssprung von Hand, also etwa einmal am Tag. Bisher ist es nicht passiert.
- **Behebung:** In `pruefe-fassungsnummer.pl` die fünf Werte aus `Version.h` lesen und gegeneinander halten. Das sind etwa 10 Zeilen und ein Selbsttestfall. Keine Kennung, das ist eine Ergänzung der Schranke.

### <a id="k5"></a>K5 (gering, alt): die ZIP-Einträge haben `\` als Trenner (E-219)

- **Gemessen:** Im geschnürten ZIP enthalten 113 von 163 Einträgen einen `\` (z. B. `Emoticons\!3a'( Cry.png`, `Mailverzeichnis\Eudora.ini`). Im veröffentlichten ZIP 7.2.1.131 sind es 111. Die Ursache liegt in `[System.IO.Compression.ZipFile]::CreateFromDirectory` unter Windows PowerShell 5.1 (paket-bauen.ps1:787). Das .NET Framework schreibt dort ohne Kompatibilitätsschalter den Windows-Trenner. Diese Ursache ist eine Vermutung mit starkem Beleg: Das Muster passt, die Laufzeit habe ich nicht untersucht. Die ZIP-Spezifikation (APPNOTE 4.4.17) verlangt `/`.
- **Was schiefgeht:** Unter Windows nichts. Explorer, 7-Zip und `ExtractToDirectory` legen Unterordner an. Wer das ZIP unter Linux oder macOS auspackt, etwa für Wine, bekommt je nach Werkzeug flache Dateien mit `\` im Namen. Dann fehlen `Emoticons`, `Plugins` und `Hilfe` als Ordner (Vermutung, nicht gemessen).
- **Wie oft:** in jedem ZIP seit dem ersten Paket. Betroffen sind nur Anwender außerhalb von Windows.
- **Behebung:** In `paket-bauen.ps1` das ZIP mit `ZipArchive` selbst schreiben und `CreateEntryFromFile($datei, $relativ.Replace('\','/'))` aufrufen. Das sind etwa 10 Zeilen. Danach mit `unzip -l` nachmessen, dass kein `\` mehr vorkommt. Nach `befund-suchen.pl CreateFromDirectory` steht nur PR-2.7 an dieser Stelle, und dort geht es um die Zeitstempel. Deshalb eine neue Kennung.

### <a id="k6"></a>K6 (sehr gering): der Prüfbericht sagt „nicht sauber (2 Dateien)“, aber nicht welche

- `pruefbericht.pl:87-88` zählt nur die Zeilen von `git status --porcelain`. Beim Bericht von 12:40 war mindestens die berichtigte `messen-e184.ps1` noch nicht eingecheckt, denn sie kam erst mit e96dd180. Welche Datei die zweite war, lässt sich nachträglich nicht feststellen (Vermutung: `Intern/pruefstand-dauer.txt`, das nicht ausgenommen ist). Wer den Bericht im Paket liest, kann nicht erkennen, ob eine Programmdatei oder ein Messskript abwich.
- **Behebung:** Die bis zu fünf Pfade in die Kopfzeile schreiben, eine Zeile in `pruefbericht.pl`.

### Hinweis (hält nichts auf)

- **T1 (sehr gering, alt):** Im Prüfbericht stehen rund 110 Unit-Tests unter dem Bereich *„[E-148](../Intern/BEFUNDE.md#e-148): keine kompromittierten Wurzelzertifikate im Paket“*, darunter [E-170](../Intern/BEFUNDE.md#e-170), [E-82](../Intern/BEFUNDE.md#e-82), [E-60](../Intern/BEFUNDE.md#e-60) und [E-3](../Intern/BEFUNDE.md#e-3). Grund: `TT_Suite` in TestE148.cpp:29 gilt bis zum nächsten `TT_Suite`, und die folgenden Testdateien eröffnen keinen eigenen Bereich. Gemessen an der Ausgabe von `RunTests.cmd`. Das ist nur eine Frage der Anzeige.
- **Bauweg:** e96dd180 nennt `-RollenSindGelaufen` (*„PRUEFER nur Version.h“*). Mit diesem Bericht ist der PRÜFER für den ganzen Stand gelaufen.

| Fund | Was passiert | Wie oft | Schwere | Hält das Paket auf? |
|---|---|---|---|---|
| K1 | Wert am Ende einer Dialogzeile trägt `"`, der Fall wird falsch rot (nie falsch grün). Für [E-170](../Intern/BEFUNDE.md#e-170) behoben. | bei jeder künftigen Logzeile in Dialog/Sent/Received | gering | nein |
| K2 | ZIP neben dem Testverzeichnis um 13:04 verändert, Paket doppelt drin, SHA passt nicht zu PAKETE.md | einmal | mittel (nur vor Release) | nein, das getestete Verzeichnis ist unverändert. Vor dem Release neu daneben legen und messen. |
| K3 / E-218 | `bauen.ps1` meldet das Testergebnis eines anderen Baums, ohne Neubau der Sammlung | bei jedem Bau eines Arbeitsbaums aus dem Projektordner | mittel | nein, `pre-push` und Prüfbericht lesen den richtigen Baum, 408/408 nachgemessen |
| K4 | Die fünf Nummern in `Version.h` werden nicht gegeneinander geprüft | bei jedem Versionssprung, bisher nie passiert | gering | nein, heute stimmen alle fünf |
| K5 / E-219 | ZIP-Einträge mit `\`, außerhalb von Windows womöglich flach ausgepackt | in jedem ZIP | gering | nein |
| K6 | Prüfbericht nennt die abweichenden Dateien nicht | bei jedem unsauberen Bericht | sehr gering | nein |
| T1 | Unit-Tests unter falschem Bereichstitel | jeder Bericht | sehr gering | nein |
