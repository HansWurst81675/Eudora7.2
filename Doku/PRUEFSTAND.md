# Eigene Änderungen prüfen: der Prüfstand

Der Prüfstand startet Eudora rund sechzig Mal, jedes Mal in einer vorbereiteten
Umgebung mit Testmails, bedient die Fenster über Windows-Nachrichten und prüft
danach, ob das Programm sich so verhält wie erwartet. Seine gut hundert Fälle
bewachen Fehler, die in diesem Projekt schon einmal behoben wurden. Wer Eudora selbst
ändert – in einem Klon oder Fork dieses Repos –, sieht damit nach einer bis anderthalb
Stunden (gemessen 60 bis 91 Minuten), ob die Änderung etwas kaputt gemacht hat, was vorher ging.

Diese Anleitung setzt kein Wissen über das Projekt voraus.

## Kurz: eigene Änderungen prüfen

1. Eudora bauen (siehe unten „Bauen“).
2. Im Hauptordner des Repos **`Pruefstand starten.cmd`** doppelklicken.
3. Die Frage „Fortfahren? (j/n)“ mit `j` beantworten.
4. Warten – gemessen 60 bis 91 Minuten, siehe „Wie lange es dauert“ – und den Rechner nicht benutzen.
5. Am Ende steht `ERGEBNIS: alle Fälle bestanden` – oder die Liste der Fälle,
   die nicht bestanden haben.

## Kurz: nur ausprobieren – ohne Visual Studio

1. Windows 10 oder 11, am besten in einem eigenen Windows-Konto oder einer
   virtuellen Maschine.
2. Git für Windows installieren (<https://git-scm.com>).
3. Repo klonen: `git clone https://github.com/HansWurst81675/Eudora7.2.git`
4. Im geklonten Ordner **`Pruefstand starten.cmd`** doppelklicken und die
   Frage mit `j` beantworten. Geprüft wird dann das zuletzt veröffentlichte
   Release (einmaliger Download, rund 9 MB).
5. Eine bis anderthalb Stunden warten (gemessen 60 bis 91 Minuten), den Rechner nicht
   benutzen.

### Voraussetzungen in Kürze

* eigenes Windows-Konto oder VM, wenn auf dem Rechner eine echte Eudora-Einrichtung läuft
* Git für Windows, für alle Benutzer installiert (bringt das nötige Perl mit)
* den Klon in einem Ordner **ohne Leerzeichen** im Pfad
* Visual Studio 2022 nur, um eigene Änderungen zu bauen
* freie Ports 11110, 1143, 1144, 1025 und 18169 auf `127.0.0.1`
* gut 700 MB für den Klon, dazu rund 1,6 GB für die 49 Prüfverzeichnisse
* eine bis anderthalb Stunden, in der der Rechner nicht benutzt wird
* Internet nur beim ersten Lauf (Download des Release-ZIPs)

Ausführlich unter „Voraussetzungen“ weiter unten.

## Wie lange es dauert

Gemessen, nicht geschätzt (Stand 06.11.2026):

| Schritt | Dauer | gemessen |
|---|---|---|
| Eudora bauen | 1 min 21 s nach einer Änderung an wenigen Dateien; ein Neubau aller Projekte dauert länger (nicht gemessen) | `Eudora71\Bin\bauen-Release.log`, 05.11.2026 |
| Unit-Tests bauen und fahren | 11 s | Prüfbericht, 05.11.2026 |
| Schranken | 9 s | Prüfbericht, 05.11.2026 |
| Prüfverzeichnisse einrichten | gut 1 min für 46 Verzeichnisse (ohne den einmaligen Download des Release-ZIPs, rund 9 MB) | Klonprobe aus einem frischen Klon, 05.11.2026 |
| **voller Prüfstandslauf** | **60 bis 91 min**, zuletzt **91 min 16 s** (110 Fälle, 67 Eudora-Starts, 7.2.2.136, 06.11.2026); je Fassung siehe [Dauer je Fassung](#dauer-je-fassung) | Entwicklermaschine; Klonprobe |

Der Wert des letzten vollen Laufs steht immer aktuell in
[`Intern/pruefstand-dauer.txt`](../Intern/pruefstand-dauer.txt);
`Pruefstand starten.cmd` liest ihn und nennt die erwartete Dauer vor dem
Start, am Ende die tatsächliche. Wie schnell es auf einem anderen Rechner
geht, hängt vor allem davon ab, wie schnell Eudora startet und schließt.

### Dauer je Fassung

Je Fassung der letzte volle Lauf, gemessen von `tools/pruefstand-lauf.ps1`
(`Intern/pruefstand-dauer.txt` in der Git-Geschichte; die Fassung aus der
Freigabe bzw. Baukennung in `tools/TESTLAEUFE.md`). Entwicklermaschine, VM.
Nur, was gemessen ist — ältere Läufe ohne eindeutige Fassung fehlen. Die Dauer
wächst vor allem mit der Zahl der Fälle und der Eudora-Starts; einzelne Fälle
mit langen Wartezeiten (E-193f bis zu 25 Minuten) verschieben sie stärker als
ein neuer kurzer Fall.

| Fassung | Art | Datum | Fälle | Eudora-Starts | Dauer |
|---|---|---|---:|---:|---:|
| 7.2.1.128 | Release | 29.10.2026 | 41 | 13 | 7 min 24 s |
| 7.2.1.129 | Testpaket | 31.10.2026 | 46 | 18 | 8 min 56 s |
| 7.2.1.130 | Testpaket | 01.11.2026 | 46 | 18 | 9 min 17 s |
| 7.2.1.131 | Release | 02.11.2026 | 53 | 25 | 16 min 58 s |
| 7.2.2.132 | Release | 03.11.2026 | 81 | 47 | 37 min 00 s |
| 7.2.2.133 | Release | 04.11.2026 | 96 | 61 | 59 min 50 s |
| 7.2.2.134 | Testpaket | 05.11.2026 | 102 | 64 | 67 min 12 s |
| 7.2.2.135 | Testpaket | 05.11.2026 | 103 | 64 | 80 min 52 s |
| 7.2.2.135 | Testpaket, Klonprobe aus einem frischen Klon (Prüfverzeichnisse aus `v7.2.2.133`) | 05.11.2026 | 102 | 63 | 76 min 57 s |
| 7.2.2.136 | Release | 06.11.2026 | 110 | 67 | 91 min 16 s |
| 7.2.2.136 | Release, voller Lauf über den Starter unter `C:\Temp\Eudora72-Pruefstand` (49 Verzeichnisse frisch aus den Vorlagen, ohne S/MIME-Zusatzdateien; aus dem Entwicklerbaum, Dauer laut Ausgabe des Starters) | 06.11.2026 | 106 | 66 | 81 min 21 s |

## Was der Prüfstand prüft – und was nicht

Es gibt drei Arten von Prüfungen in diesem Repo:

| Art | Prüft | Dauer | Aufruf |
|---|---|---|---|
| **Unit-Tests** | einzelne Funktionen im Quelltext, ohne Fenster | Sekunden | `Eudora71\Tests\RunTests.cmd` |
| **Schranken** | Regeln über Quelltext und Dokumente (Kodierung, Verweise …) | Sekunden | laufen beim Commit von selbst, wenn die Git-Haken eingerichtet sind |
| **Prüfstand** | das **laufende Programm**: Mail abrufen, verschieben, suchen, speichern, beenden | 60 bis 91 min (gemessen) | `Pruefstand starten.cmd` |

Der Prüfstand prüft **nicht**:

* echte Mailserver und Konten – er benutzt eigene Prüfserver auf dem eigenen Rechner;
* große Postfächer und lange Laufzeiten;
* den Druck auf Papier und alles, was nur von Hand zu sehen ist (Aussehen, Farben) – die Druckvorschau prüft er;
* das S/MIME-Plugin, solange `MFC71.DLL` und `msvcp71.dll` fehlen (siehe unten).

## Voraussetzungen

* **Windows 10 oder 11.** Der Prüfstand bedient Eudora-Fenster; er braucht
  einen angemeldeten Benutzer mit Bildschirm.
* **Ein eigenes Windows-Konto oder eine virtuelle Maschine**, wenn auf dem
  Rechner eine echte Eudora-, Hermes- oder Eudora-7.2-Einrichtung benutzt wird.
  Eudora schreibt bei jedem Start in die Windows-Registry
  (`HKCU\Software\Qualcomm\Eudora`). Der Prüfstand hält den Stand vorher fest
  und setzt ihn danach zurück; wird er hart abgebrochen (Strom weg, Prozess
  beendet), kann aber ein Rest bleiben, der auf ein Prüfverzeichnis zeigt.
* **Eigene Eudora-Daten bleiben unberührt.** Der Prüfstand arbeitet nur in
  Verzeichnissen, die er selbst angelegt und mit der Datei
  `.eudora72-pruefstand` markiert hat – Vorgabe ist der Ordner
  `C:\Temp\Eudora72-Pruefstand`. Ein Eudora-Verzeichnis ohne diese Marke, etwa
  eine eigene Installation mit echten Mails unter `C:\Temp`, fasst er nie an:
  er startet dort nichts, leert dort nichts und setzt dessen Registry-Einträge
  nicht zurück.
* **Git für Windows** (<https://git-scm.com>). Es bringt das Perl mit, mit dem
  die Prüfserver laufen. Gesucht wird es unter
  `C:\Program Files\Git\usr\bin\perl.exe`, also bei einer Installation für alle
  Benutzer (die Vorgabe des Installers); wer Git nur für sich installiert hat,
  bekommt „Perl fehlt“. Weitere Perl-Module braucht es nicht.
* **Ein Ordner ohne Leerzeichen** für den Klon: liegt er etwa unter
  `C:\Mein Ordner\…`, starten die Prüfserver nicht (bekannter Fehler E-244).

* **Visual Studio 2022** mit „Desktopentwicklung mit C++“, um Eudora zu bauen.
  Ohne eigenen Bau prüft der Prüfstand das zuletzt veröffentlichte Release –
  das ist nützlich, um den Prüfstand selbst auszuprobieren, sagt aber nichts
  über eigene Änderungen.
* **Freie Ports** auf `127.0.0.1`: 11110 (POP), 1143 und 1144 (IMAP),
  1025 (SMTP), 18169 (Bilder für die Druckvorschau). Belegt sie ein anderes
  Programm, startet der Prüfstand nicht und nennt das Programm.
* **Platz:** gut 700 MB für den Klon (gemessen am 06.11.2026: 510 MB Dateien
  und 224 MB Git-Geschichte), dazu rund 1,6 GB für die 49 Prüfverzeichnisse
  (gemessen: 1578 MB unter `C:\Temp\Eudora72-Pruefstand`).
* **Eine bis anderthalb Stunden** (gemessen 60 bis 91 Minuten), in der der Rechner nicht benutzt wird. Ein Klick in ein
  Eudora-Fenster während des Laufs kann einen Fall rot machen.
* **Internet** nur beim ersten Lauf: Fehlt im Ordner `Releases\` ein
  Release-ZIP, lädt der Prüfstand das neueste Release dieses Projekts von
  GitHub. Es liefert die Dateien, die nicht im Repo gebaut werden.

## Bauen

```
powershell -NoProfile -ExecutionPolicy Bypass -File tools\bauen.ps1
```

`bauen.ps1` baut nur, wenn alle Quelldateien committet sind; für einen
schnellen Bau einer noch nicht committeten Änderung `-Ungesichert` anhängen,
oder in Visual Studio die Projektmappe `Eudora71\Eudora.sln` mit
`Release|x86` bauen.

Ausführlich in [Doku/BAUEN.md](BAUEN.md). Danach liegt das Programm in
`Eudora71\Bin\Release`. Die Unit-Tests laufen mit
`Eudora71\Tests\RunTests.cmd`; sie sind schnell und sollten vor dem
Prüfstand grün sein.

## Starten

Doppelklick auf **`Pruefstand starten.cmd`** im Hauptordner, oder in einer
Eingabeaufforderung:

```
"Pruefstand starten.cmd"
```

Was dann geschieht:

1. **Voraussetzungen.** Perl, eigener Bau, keine Eudora mehr offen in den
   Prüfverzeichnissen, freie Ports. Fehlt etwas, steht dort, was zu tun ist,
   und es wird nichts gestartet. Reste von Prüfservern aus einem früheren,
   abgebrochenen Lauf dieses Repos werden beendet – andere Programme nicht.
2. **Frage.** „Fortfahren? (j/n)“. Das `j` gilt als Freigabe für diesen Lauf
   und steht im Protokoll.
3. **Einrichten.** Unter `C:\Temp\Eudora72-Pruefstand` entstehen 49
   Prüfverzeichnisse (`…\E13`, `…\E118` …), je eine Kopie des Programms
   (Release-ZIP, darüber der eigene Bau) und ein vorbereitetes Mailverzeichnis
   aus `Testdaten\pruefstand\`. Jedes bekommt die Marke
   `.eudora72-pruefstand`; nur Verzeichnisse mit dieser Marke fasst der
   Prüfstand an. Ein Verzeichnis gleichen Namens ohne Marke bleibt unberührt;
   seine Fälle werden dann übersprungen.
4. **Lauf.** Fortschritt in der Form

   ```
   [12/58] Faelle 37-39 von 102: E-193fs, E-193f, E-193fd
       [ ok ] E-193fs  E193F ERGEBNIS suchweg-ohne f1=1 ...
   ```

   Zwischendurch gehen Eudora-Fenster auf und zu. Nichts anklicken.
5. **Ergebnis.** Die Liste aller Fälle mit `[ ok ]` oder `[FEHL]`, die
   Ergebniszeile, die Dauer und die Datei
   `C:\Temp\Eudora72-Pruefstand\pruefstand-ergebnis.txt`.

### Schalter

Hinter `"Pruefstand starten.cmd"` lassen sich Schalter anhängen:

| Schalter | Wirkung |
|---|---|
| `-Nur E-193` | nur die Fälle, deren Kennung so beginnt – schnell, um einen einzelnen Fehler nachzuprüfen |
| `-Wurzel D:\Pruefstand` | anderer Ordner für die Prüfverzeichnisse, wie das Arbeitsverzeichnis beim Start von Eudora; jeder Ordner außer einem Laufwerksstamm und ohne Leerzeichen im Pfad (bekannter Fehler E-244). Die Marke schützt fremde Verzeichnisse auch dort. Ein deutlich längerer Pfad als die Vorgabe kann `E-216l` (langer Pfad im About-Dialog) rot machen, ohne dass etwas kaputt ist: der Dialog hat für die Zeile *Log* zwei Zeilen Platz |
| `-Grundlage C:\pfad\Eudora72-7.2.2.133-release.zip` | dieses Release-ZIP statt des Downloads |
| `-Bau C:\pfad\Bin\Release` | ein anderes Bauverzeichnis |
| `-ZusatzDlls C:\pfad` | Ordner mit `MFC71.DLL` und `msvcp71.dll`, damit der S/MIME-Fall mitläuft |
| `-Ja` | beantwortet die Frage ohne Tastatur (etwa für einen geplanten Lauf) |

## Ergebnis lesen

```
Ergebnis: 107 Faelle, 107 bestanden, 0 fehlgeschlagen
Uebersprungen (auf diesem Rechner nicht einrichtbar): 3
    [UEBR] E-166a   S/MIME- bzw. Junk-Plugin braucht MFC71.DLL und msvcp71.dll ...
```

* **`[ ok ]`** – der Fall hat bestanden.
* **`[FEHL]`** – der Fall hat nicht bestanden. Dahinter steht, was fehlte oder
  was nicht hätte erscheinen dürfen, bei Messungen auch, was das Messskript
  stattdessen gemeldet hat.
* **`[UEBR]`** – auf diesem Rechner nicht einrichtbar, weder rot noch grün.
  Heute der S/MIME-Fall `E-222w` und die beiden Junk-Fälle `E-166a`/`E-166b`.

Die Kennung eines Falls (`E-193fs`) verweist auf den Fehler, den er bewacht:
`E-193` steht in der Befundliste dieses Projekts,
[Intern/BEFUNDE.md](../Intern/BEFUNDE.md) – dort ist beschrieben, was einmal
falsch war und wie es behoben wurde. Die erwartete Zeile jedes Falls steht in
[tools/pruefstand-faelle.txt](../tools/pruefstand-faelle.txt).

### Ein Fall ist rot – was tun?

1. **Einzeln wiederholen:** `"Pruefstand starten.cmd" -Nur E-193fs`. Manche
   Fälle hängen von der Zeit ab; ist er beim zweiten Mal grün, war es
   vermutlich der Rechner, nicht die Änderung.
2. **Gegenprobe ohne die eigene Änderung:** den unveränderten Stand bauen
   (`git stash` oder ein zweiter Klon, dort `tools\bauen.ps1`) und denselben
   Fall mit `-Bau <dessen Eudora71\Bin\Release>` fahren. Ist er auch dort rot,
   liegt es nicht an der Änderung.
3. **Protokoll lesen:** im Prüfverzeichnis des Falls,
   `C:\Temp\Eudora72-Pruefstand\<Name>\Mailverzeichnis\eudora.log`.
   `Exception.log` daneben gibt es nur, wenn Eudora abgestürzt ist.

### Typische Fehlerbilder

| Meldung | Ursache | Abhilfe |
|---|---|---|
| `Belegt: Port 11110: …` | ein anderer Mailserver oder ein zweiter Prüfstand läuft | das genannte Programm beenden |
| `Pruefverzeichnis fehlt` | Einrichten wurde übersprungen oder ist gescheitert | Ausgabe oben lesen, neu starten |
| `kein Pruefstand (Marke .eudora72-pruefstand fehlt)` | im Ordner liegt ein Verzeichnis gleichen Namens, das nicht der Prüfstand angelegt hat | es bleibt unberührt; anderen Ordner mit `-Wurzel` wählen oder das Verzeichnis selbst umbenennen |
| `Vorbereiten mit … gescheitert` | ein Messskript fand seine Ausgangslage nicht | neu starten; bleibt es, Prüfverzeichnis löschen |
| `kein Protokoll nach dem Lauf` | Eudora startete nicht (fehlende DLL, Defender) | `Eudora.exe` im Prüfverzeichnis von Hand starten und die Meldung lesen |
| `Eudora ist in diesem Lauf abgestuerzt` | Absturz im Windows-Ereignisprotokoll | `Exception.log` im Prüfverzeichnis lesen |
| Defender meldet einen Trojaner | Fehlalarm, siehe [Releases/DEFENDER-FEHLALARM.md](../Releases/DEFENDER-FEHLALARM.md) | Datei aus der Quarantäne zurückholen |

## Der S/MIME-Fall und die Junk-Fälle

Das S/MIME-Plugin von 2006 braucht `MFC71.DLL` und `msvcp71.dll` aus Visual
Studio .NET 2003. Dieses Projekt darf sie nicht weitergeben, und Microsoft
bietet kein Paket an, das sie nachinstalliert. Dasselbe gilt für die Junk-Filter-Plugins.
Ohne die beiden Dateien werden die Fälle `E-222w` (S/MIME) und
`E-166a`/`E-166b` (die Frage zum Junk-Postfach kommt nur mit geladenem
Junk-Plugin) übersprungen. Wer die beiden Dateien hat – etwa aus einer alten Eudora-7.1-,
Hermes- oder Visual-Studio-2003-Installation –, legt sie in einen Ordner und
startet mit `-ZusatzDlls <ordner>`. Von DLL-Download-Seiten ist abzuraten.

## Wie es gebaut ist

Für alle, die den Prüfstand erweitern wollen:

| Datei | Aufgabe |
|---|---|
| `Pruefstand starten.cmd` | Doppelklick-Einstieg, ruft `tools\pruefstand-starten.ps1` |
| `tools\pruefstand-starten.ps1` | Voraussetzungen, Frage, Einrichten, Lauf, Ergebnis |
| `tools\pruefstand-einrichten.ps1` | legt die Prüfverzeichnisse an; fasst Verzeichnisse ohne die Marke `.eudora72-pruefstand` nie an |
| `tools\pruefstand-lauf.ps1` | fährt die Fälle, prüft die erwarteten Zeilen, erkennt Abstürze |
| `tools\pruefstand-faelle.txt` | ein Fall je Zeile: Kennung, Verzeichnis, Zeit, Quelle, erwartete Zeile, verbotene Zeile, Testmail, Messskript |
| `tools\messen-*.ps1` | je Fall die Bedienung: Lage herstellen (`-Vorbereiten`), Fenster bedienen, Ergebniszeile ausgeben |
| `tools\testlauf.ps1` | startet und beendet Eudora; der einzige Weg, auf dem die Skripte Eudora starten |
| `tools\anhang-pruefdaten.pl`, `tools\imap-pruefserver.pl`, `tools\smtp-pruefserver.pl`, `tools\e169-bildserver.pl` | die Prüfserver für POP, IMAP, SMTP und die Bilder der Druckvorschau, nur auf `127.0.0.1` |
| `tools\pruefserver-aufraeumen.ps1` | beendet Reste der Prüfserver dieses Repos, meldet belegte Ports |
| `Testdaten\pruefstand\<Name>\` | das vorbereitete Mailverzeichnis je Prüfverzeichnis, daneben bei Bedarf eine Schalterdatei (`e169-schalter.txt`); erfasst mit `tools\pruefstand-vorlage-erfassen.ps1 -Nur <Name>`. Zu jedem Verzeichnis der Fallliste muss es eine Vorlage geben (Schranke `tools\pruefe-feste-pfade.pl`) |
| `Testdaten\*.eml` | die Testmails; alle erfunden, Adressen auf `.invalid` |

Ein neuer Fall braucht eine Zeile in `tools\pruefstand-faelle.txt` und, wenn
er Fenster bedienen muss, ein Messskript. Gilt er für ein neues
Prüfverzeichnis, gehört dessen Mailverzeichnis nach `Testdaten\pruefstand\`.

Die Entwickler dieses Projekts fahren den Prüfstand mit
`tools\pruefstand-lauf.ps1` direkt; die Ergebnisse gehen dort zusätzlich in
die Buchführung unter `Intern\`. Der Starter schreibt nichts nach `Intern\`.
Ein Protokoll jedes Eudora-Starts hängt `tools\testlauf.ps1` an
`tools\TESTLAEUFE.md` an – in einem Fork ist das eine lokale Änderung, die
nicht committet werden muss.
