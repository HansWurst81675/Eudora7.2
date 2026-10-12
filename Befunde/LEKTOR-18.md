# LEKTOR-18 — Kurzlauf zu `d292850` (Messstand 7.2.0.83)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Beide Mängel sind im selben Commit wie dieser Bericht behoben.**


## Belegt
- `Eudora71/Bin/bauen-Release.log.fehler`: 3 Byte, nur BOM, keine Fehlerzeile.
- `Eudora71/Bin/Release/Eudora.exe`: FileVersion 7.2.0.83, 12.10.2026 12:02:55.
- `scratchpad/tests5.txt`: 185 Tests, 185 bestanden, 0 fehlgeschlagen.
- `C:\Temp\AN5\Mailverzeichnis\attach`: sechs Dateien, alle mit vollem Namen und `.pdf`.
- `eudora.log` Kopf: „Version 7.2.0.83“; „kennt den Typ NICHT“ 0-mal; keine `Exception.log` unter `C:\Temp\AN5`.
- TESTLAEUFE.md:89: `C:\Temp\AN5`, Titel 7.2.0.83 / 1.0.83+e26f24c, 12:01 — passt zur EXE (12:02:55) und zu eudora.log (12:03:34).

## Mängel
1. `Releases/PAKETE.md:158`: steht auf „**in Arbeit**“, CHANGELOG.md:71 sagt „**gebaut und gemessen**“. Vorschlag: so fassen wie 1.0.82, also „gebaut und gemessen, nicht geschnürt“. ZIP-Zeile: „existiert nicht — nur das Prüfverzeichnis `C:\Temp\AN5`“. Die Begründung in Zeile 168f. um den Messstand ergänzen.
2. `WEITERMACHEN.md:10`: nennt als Messung nur 7.2.0.81 (AN3) und 7.2.0.82 (AN4). 7.2.0.83 steht dort nur als Änderung, nicht als gemessen. Vorschlag: „7.2.0.83 in `C:\Temp\AN5`, Testsuite 185/185“ ergänzen.
