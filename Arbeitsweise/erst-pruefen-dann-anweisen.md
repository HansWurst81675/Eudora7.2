---
name: erst-pruefen-dann-anweisen
description: "Keine Handlungsanweisung an Gregor geben, ohne sie vorher selbst durchgeführt und gemessen zu haben"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-31T05:44:00.043Z
---

Wenn ich Gregor sage „schau unter *Hilfe → Über*" oder „starte es aus diesem
Verzeichnis", muss ich vorher **geprüft haben, dass dieser Weg funktioniert**.

**Why:** Am 31.08.2026 zweimal hintereinander falsch:

1. Ich sagte, die Version 7.2.0.3 sei im Startbildschirm und unter *Help → About*
   zu sehen — ohne geprüft zu haben, ob die frisch gebaute EXE überhaupt startet.
2. Ich schlug vor, sie aus `Eudora71\Bin\Debug` zu starten. Dort liegen die
   **Debug**-Fassungen der vorgebauten Fremd-DLLs von 2006, die `MSVCR71D.dll`
   verlangen. Das ist Befund S-1 — der Fehler, an dem schon Paket 1.0.1
   gescheitert war und den ich selbst dokumentiert hatte.

Seine Worte: *„erst prüfen, dann antworten! wenn exe nicht lauffähig, dann
schlage nicht vor, ich soll unter hilfe -> about nachschauen"*

Der Schaden ist nicht die falsche Auskunft an sich, sondern dass Gregor seine
Zeit für einen Weg aufwendet, den ich in Sekunden hätte ausschließen können.

**How to apply:**

- Vor jeder Handlungsanweisung: den Weg selbst gehen, soweit es ohne Fenster
  geht. Abhängigkeiten mit `dumpbin -dependents` oder
  `tools/paket-pruefen.ps1` durchrechnen, statt sie anzunehmen.
- Ein Verzeichnis, aus dem gebaut wird, ist **nicht** ein Verzeichnis, aus dem
  gestartet werden kann. `Bin\Debug` enthält den Bauzustand, nicht das Paket.
  Zum Starten gehört ein mit `tools/paket-bauen.ps1` erstelltes Verzeichnis.
- Was ich nicht prüfen kann (alles mit Fenstern, siehe
  [[nichts-auf-gregors-bildschirm-starten]]), sage ich als **ungeprüft** an —
  nicht als Anweisung.

Siehe [[pruefen-statt-vermuten]] und [[was-lauffaehig-heisst]].
