---
name: entscheidung-nummer-7-2-2-fortlaufend
description: "Gregor 04.11.2026: seit 7.2.2.132 heißt jede Fassung 7.2.2.N, auch reine Fehlerbehebungen (nächstes Paket 7.2.2.133); 7.2.1 ist abgeschlossen"
metadata:
  type: project
---

Schranke: keine - eine Nummernentscheidung; durchgesetzt wird sie von tools/release-veroeffentlichen.ps1 und pruefe-fassungsnummer.pl, sobald dort 7.2.1.N nach 7.2.2.132 abgewiesen wird (offen).

Gregor am 04.11.2026 auf die Frage aus LEKTOR-143 L-143.4 (nächstes Paket nur mit Fehlerbehebungen: 7.2.1.133 oder 7.2.2.133?): **„7.2.2.133“**. Seit 7.2.2.132 geht jede Fassung auf 7.2.2.N weiter, Testpaket wie Release, auch wenn sie nur Fehler behebt. Die Reihe 7.2.1 ist abgeschlossen. Die Nummern steigen immer.

**Why:** 7.2.1.133 wäre kleiner als das veröffentlichte 7.2.2.132; Windows und jeder Versionsvergleich hielten es für älter. Die Lesart „zwei Reihen nebeneinander“ (Entscheidung 25 in der Fassung vom 04.11. früh, CHANGELOG, PAKETE, MITARBEITEN) ist damit überholt.
**How to apply:** Entscheidung 25 und die Stellen aus L-142.4 berichtigen; die Werkzeuge sollen nach 7.2.2.132 kein 7.2.1.N mehr annehmen. Verwandt: [[entscheidung-7-2-2-umfang]], [[entscheidung-marke-v7-2-1]].
