---
name: quelle-muss-im-bau-stehen
description: "Vor dem Ändern einer Quelldatei prüfen, ob ein Projekt der Mappe sie überhaupt baut (tools/wer-baut.pl) - die F1-Behebung saß in PGEMBED.C, Paige32.dll wird nicht aus dem Quelltext gebaut"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T10:20:00.000Z
---

Am 13.10.2026 um 09:20 UTC kam der Fund F1 aus PRÜFER-22 zu E-112: zwei Bilder mit derselben Adresse und verschiedener Größe teilen sich einen Datensatz. Der Bericht argumentierte mit Zeilen aus `PaigeDLL/PGSOURCE/PGEMBED.C` (`:1840`, `:1855-1871`), und genau dort habe ich die Behebung eingebaut (`dae6727`, 09:21). Der Bau lief fehlerfrei durch. Erst die Messung am laufenden Programm um 09:38 zeigte, dass sie wirkungslos war: dasselbe Logo als 70x70 kam weiter als 35x35. `Paige32.dll` hatte byte-genau die alte Größe, eine `pgembed.obj` gab es nicht. **Kein Projekt in `Eudora.sln` baut `PGEMBED.C`.** `PaigeDLL/PAIGE32/Paige32.vcproj` steht in keiner Mappe, die DLL wird fertig übernommen. Die Datei war seit dem ersten Commit nie geändert worden. Die richtige Stelle war Eudoras eigener HTML-Import (`PGHTMIMP.CPP`, `ac8f030`, 09:39). Gekostet hat es einen Bau, eine Messung und 18 Minuten, in denen Gregor auf das Paket wartete.

**Why:** Eine Stelle, an der der Fehler *entsteht*, ist nicht automatisch eine Stelle, an der ich ihn *beheben kann*. Den Quelltext einer fertig übernommenen Bibliothek zu lesen ist richtig: er erklärt, was die DLL tut. Ihn zu ändern bewirkt nichts. Der Bau meldet das nicht. Er übersetzt einfach nicht, was in keinem Projekt steht, und bleibt dabei grün. Gemessen am 13.10.: von 1727 `.c`/`.cpp` unter `Eudora71/` stehen **618** in einem Projekt der Mappe und **730** unter einem nmake-Projekt (OpenSSL, OT501). **379** baut niemand: PaigeDLL, BugslayerUtil, PureVoice, EMSAPI-Plugins, DirectoryServices, libpng, expat. Das ist keine seltene Ecke, sondern gut ein Fünftel des Baums.

**How to apply:**

- **Vor dem ersten Handgriff an einer Quelldatei:** `perl tools/wer-baut.pl <datei>`. Bei `NEIN` wird nicht dort behoben, sondern beim gebauten Aufrufer. Bei PGEMBED.C war das die Stelle, die `pgNewImageRecord` aufruft. Bei `make` steht der Inhalt im Makefile; dann wird dort nachgesehen.
- **Ein PRÜFER-Fund nennt den Ort der Ursache, nicht den Ort der Behebung.** Liegt die Zeilenangabe außerhalb eines gebauten Projekts, wird der Ort der Behebung neu bestimmt, bevor ich etwas ändere.
- **Nach dem Bau messen, ob die geänderte Datei übersetzt wurde.** Dafür reichen das `.obj` und der Zeitstempel der Ausgabe. So hat es sich hier verraten: gleiche DLL-Größe, kein `.obj`. Verwandt: [[messung-muss-den-weg-treffen]], [[paket-gegen-den-bau-messen]], [[pruefen-statt-vermuten]].

Schranke: tools/wer-baut.pl - liest die Projekte aus Eudora71/Eudora.sln (dazu Tests.vcxproj); der pre-commit meldet vorgemerkte ungebaute Quellen (Schritt 1c, nur melden, wirkt erst nach `sh tools/hooks-einrichten.sh`). Gegenprobe 13.10.2026: `--selbsttest` 6 Fälle (PGEMBED.C nein, PGHTMIMP.CPP ja, Schreibweise, Testprojekt, nmake-Projekt), PGEMBED.C vorgemerkt -> Meldung bei Rückgabe 0, ohne Vormerkung still.
