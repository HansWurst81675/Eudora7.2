# <a id="pruefer-73"></a>PRUEFER-73: Nachlauf zur Einarbeitung von PRUEFER-72 (Commit 6815325a)

**Ergebnis vorweg.** K1 aus [PRUEFER-72](PRUEFER-72.md#pruefer-72) ist so umgesetzt, wie vorgeschlagen:
`CMessageDoc::OnUpdateDynamicCommand` fragt vor `Enable( TRUE )`
`E143OutGesperrt` und graut Out aus (am Quelltext belegt,
`Eudora71/Eudora/msgdoc.cpp:1520-1525`, gleich gebaut wie
`TocFrame.cpp:2529`). Die Gegenprobe greift (gemessen). Keine neuen Funde.

| Prüfpunkt | Ergebnis | Art |
|---|---|---|
| K1: Nachrichtenfenster fragt `E143OutGesperrt` | stimmt, Form wie `CTocFrame` | am Quelltext belegt (msgdoc.cpp:1521) |
| Gegenprobe: Block in msgdoc.cpp entfernt | `[FEHL] E-143 (Quelltext)` | gemessen |
| Wiederhergestellt (`git checkout --`, `git diff --quiet`) | 355/355 | gemessen |
| K3: wörtliche Prüfung in TestE143/TestE170 | im Diff vorhanden; Gegenprobe zu K1 zeigt, dass TestE143 den neuen Handler wörtlich prüft | gemessen (für K1-Teil) |
| ob Out in der laufenden Oberfläche grau erscheint | nicht geprüft | nicht gemessen |
