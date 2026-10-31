---
name: entscheidung-pruefstand-fenster-31-10
description: "Gregor 31.10.2026 ~19:15 - Prüfstandsläufe mit Fenster heute erlaubt: 'ja, starte auf deinem lokalen prüfstand deine testes, ich halte mich zurück'; VM-Uhr ging ~20 h nach"
metadata:
  node_type: memory
  type: project
  originSessionId: f6188ad4-4df8-4a5e-bb99-a9fb32d6557a
  modified: 2026-10-30T22:29:39.453Z
---

Schranke: tools/testlauf.ps1 verlangt eine Freigabe mit dem HEUTIGEN Datum (gegen die Uhr der VM).

Gregor am 31.10.2026 gegen 19:15 (wörtlich): *„ja, starte auf deinem lokalen prüfstand deine testes, ich halte mich zurück.“* Gilt für diesen Tag, für Prüfstände unter `C:\Temp`, über `tools/testlauf.ps1`.

**Uhr:** Die VM zeigte um diese Zeit 30.10.2026 23:27 (`date`). Gregor fuhr die VM danach neu, um die Zeit zu synchronisieren. Vor dem ersten Lauf `date` prüfen; zeigt die VM noch den 30.10., wird `-Freigabe` mit 31.10. abgewiesen — dann nicht das Datum fälschen, sondern Gregor die Uhr nennen.

**Stand E-140:** Prüfstand `C:\Temp\E140` ist als Kopie von `C:\Temp\E97` angelegt (noch NICHT vorbereitet). Nächste Schritte: `powershell -NoProfile -ExecutionPolicy Bypass -File tools/messen-e140.ps1 -Pfadfilter C:\Temp\E140 -Vorbereiten`, dann `powershell -NoProfile -ExecutionPolicy Bypass -File tools/testlauf.ps1 -Verzeichnis C:\Temp\E140 -Freigabe "Gregor am 31.10.2026: 'ja, starte auf deinem lokalen prüfstand deine testes'" -Sekunden 90 -MessenSkript tools\messen-e140.ps1`. Welche Eudora.exe in E97 liegt (Fassung), vor dem Lauf feststellen und im Ergebnis nennen.

Der CHRONIST-Lauf (Bericht CHRONIST-2026-10-30d.md) lief beim Neustart noch — was davon im memory-Ordner liegt, prüfen und ggf. neu starten.
