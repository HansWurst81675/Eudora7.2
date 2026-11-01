# <a id="pruefer-80"></a>PRUEFER-80

Kurzlauf nach [PRUEFER-79](PRUEFER-79.md#pruefer-79), geprüft: `3c17cf7e..HEAD` (7b41c8d7, 424f46de), Zweig wt/pruefer-20261101l.

## Ergebnis vorweg

Der neue Testfall prüft den Überlauf jetzt wirklich: Ohne die Prüfung schlägt er fehl, mit ihr läuft alles durch (selbst nachgefahren, 356/357 und 357/357). Der Bereich an der Obergrenze ist richtig gelesen und zeigt, dass die Schleife nicht überläuft. Beim Start-Haken sind der Fehlalarm und vier der fünf Lücken geschlossen; nur ein Aufruf ohne „.exe“ geht noch durch, das ist klein und hält nichts auf.

## 1. Testfall Überlauf (PRUEFER-79 K4)

- `"4294967300"`: nach acht Ziffern steht `ulVon` = 42949673, nach der neunten 429496730; vor der zehnten Ziffer greift `ulVon > 429496729UL` (UidMenge.h:42) → -1. Ohne die Abfrage: 4294967300 mod 2^32 = 4, ungleich 0, zehn Ziffern → als UID 4 angenommen, der Fall in `boese` (TestE184.cpp:53) wird rot. Am Quelltext belegt und **gemessen**: Zeile 42 vorübergehend entfernt → `Ergebnis: 357 Tests, 356 bestanden, 1 fehlgeschlagen`, rot genau `E-184 K3: UID-Mengen …`; zurück, `cmp` gleich, `touch` → 357/357. Deckt sich mit der Meldung in 7b41c8d7.
- Die Abfrage in Zeile 55 (zweite Zahl im Bereich) belegt `"1:4294967297"` weiterhin nicht: läuft auf 1, ergibt Bereich 1:1, wird angenommen → wäre ohne Zeile 55 rot. Am Quelltext nachgerechnet; nicht gemessen.
- `"4294967294:4294967295"` (TestE184.cpp:57): Schleife UidMenge.h:64-68 hängt 4294967294 und 4294967295 an und bricht bei `u == ulBis` **vor** dem `u++` ab - kein Überlauf auf 0. Richtig, am Quelltext belegt; grün gemessen. Eine Schleife `u <= ulBis` liefe hier endlos - der Testfall würde dann hängen statt rot zu werden. Bemerkt, kein Fund.

## 2. Haken gegen Eudora-Starts (PRUEFER-79 K1/K2)

Selbsttest `perl tools/haken-eudora-start.pl --selbsttest`: 47/47 (gemessen). Meine Gegenproben aus [PRUEFER-79](PRUEFER-79.md#pruefer-79) über die Hakenschnittstelle (Rückgabe 2 = abgewiesen), gemessen:

| Befehl | soll | ist |
|---|---|---|
| `grep -c "Eudora.exe" tools/TESTLAEUFE.md` | durch | durch |
| `tasklist \| grep -c 'Eudora.exe'` | durch | durch |
| `sleep 1 & /c/Temp/E184/Eudora.exe` | abweisen | abgewiesen |
| `env /c/Temp/E184/Eudora.exe` | abweisen | abgewiesen |
| `xargs -I{} /c/Temp/E184/Eudora.exe` | abweisen | abgewiesen |
| `wsl.exe -e /mnt/c/Temp/E184/Eudora.exe` | abweisen | abgewiesen |
| `/c/Temp/E184/Eudora` (ohne .exe) | abweisen | **durch** |
| `powershell -c "& '…\Eudora.exe'"` | abweisen | abgewiesen |
| `start C:\Temp\E184\Eudora.exe` | abweisen | abgewiesen |
| `bash -c "/c/Temp/E184/Eudora.exe"` | abweisen | abgewiesen |

K1 behoben, K2 bis auf den Pfad ohne `.exe` behoben. Die Commit-Nachricht nennt diesen Fall nicht - er ist weder behoben noch als zurückgestellt vermerkt.

## Funde

**K1 - Haken lässt `/c/Temp/E184/Eudora` (ohne .exe) weiter durch**; Rest aus [PRUEFER-79](PRUEFER-79.md#pruefer-79) K2, in 7b41c8d7 stillschweigend offen geblieben. Gemessen. Bash startet so dieselbe Datei. Schwere: klein.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Start-Haken erkennt Eudora-Aufruf ohne `.exe` nicht | klein | nein |
