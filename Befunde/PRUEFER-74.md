# PRÜFER-74 — Kurzlauf vor dem PR `paket_7_2_1_130`

Geprüft: `git log 289cb512..HEAD -- Eudora71 tools Releases/1.0` im Baum `.wt/pruefer` (Zweig `wt/pruefer-20261101f`, Stand `d2a85c89`).

## Ergebnis vorweg

Der Versionssprung von 7.2.1.129 auf 7.2.1.130 ist sauber. Alle vier Versionsangaben in `Version.h` sagen 130, die Datei ist bis auf die vier Ziffernfolgen byte-gleich, und die Bau-Kennung im Paketeintrag passt zum Quellstand. Es gibt keinen Fund; das Paket wird von dieser Prüfung nicht aufgehalten.

## Was sich geändert hat

Gemessen (`git diff --stat 289cb512..HEAD`): einzige Code-Datei ist `Eudora71/Version.h` (8 Zeilen, 4 raus, 4 rein); daneben nur `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` (Buchführung, kein Code). `Releases/1.0` unverändert.

## 1. Die vier Defines

Am Quelltext belegt (`Eudora71/Version.h`, Diff gegen `289cb512`):

| Define | vorher | nachher |
|---|---|---|
| `EUDORA_VERSION4` | 129 | 130 |
| `EUDORA_BUILD_NUMBER` | `7,2,1,129` | `7,2,1,130` |
| `EUDORA_BUILD_DESC` | `"Version 7.2.1.129\0"` | `"Version 7.2.1.130\0"` |
| `EUDORA_BUILD_VERSION` | `"7.2.1.129"` | `"7.2.1.130"` |

`EUDORA_VERSION1..3` (Zeilen 8–10) stehen unverändert auf 7, 2, 1 — konsistent mit den drei Zeichenketten. Das `\0` in `EUDORA_BUILD_DESC` ist erhalten.

## 2. Bytes

Gemessen, beide Stände aus git gelesen:

| Stand | CRLF | nur-LF | >127 | Länge |
|---|---|---|---|---|
| `289cb512` | 0 | 21 | 0 | 606 |
| `HEAD` | 0 | 21 | 0 | 606 |

Gleiche Länge (129 und 130 sind gleich lang), gleiche Zeilenenden, keine Latin-1-Zeichen in der Datei. Der Wort-Diff zeigt genau acht geänderte Tokens (vier raus, vier rein) — nichts außer den Ziffern.

## 3. VERSION-Datei

Gemessen: `VERSION` enthält `7.2.1.130`, zuletzt geändert im selben Commit `7d9cca14` wie `Version.h`. Gleich.

## 4. Bau-Kennung im Paketeintrag

`Releases/PAKETE.md`, Abschnitt 7.2.1.130 nennt den Bau `Eudora 7.2.1.130+955d50d4* 2026-11-01 15:15`. Gemessen: `git log 955d50d4..HEAD -- Eudora71` ist leer, `VERSION` in `955d50d4` sagt `7.2.1.130`. Der Bau steht also auf demselben Quellstand wie der PR. Das Sternchen erklärt der Eintrag mit `tools/AGENTEN-LAUFEN.md`; nachgemessen habe ich das nicht (Vermutung, aber unschädlich: diese Datei geht nicht in den Bau).

## Gegenvermutungen

* *Ein weiterer Ort trägt die Nummer hart, z. B. ein `.rc`.* Nicht neu geprüft; laut Diff hat sich außer `Version.h` und `VERSION` nichts geändert, und 7.2.1.129 lief mit demselben Verfahren. Der Paketeintrag meldet Dateiversion 7.2.1.130 für `Eudora.exe` (belegt nur durch den Eintrag, nicht von mir gemessen).
* *Zeilenenden durch das Bearbeiten verändert.* Widerlegt durch die Messung oben.

Testsuite nicht gefahren: die Änderung betrifft nur Konstanten, und der PRUEFBERICHT nennt 355 bestandene Unit-Tests am selben Bau.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | keiner | — | nein |
