---
name: gegenprobe-einmal-beim-bau
description: Die rote Gegenprobe (Test ohne Fix muss rot werden) gehoert einmal zum BAU eines Tests; im laufenden Betrieb genuegt gruen
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T17:35:21.510Z
---

Gregor am 25.10.2026: *„regression tests brauchen wir nicht erst rot, grün genügt. wir haben bisher beim bauen der tests geprüft, ob ohne fix der test rot ist. das müssen wir nicht jedes mal machen."*

Die Gegenprobe ohne Behebung (Quelle zurücksetzen, Test muss rot werden) gehört **einmal** zum **Anlegen** eines neuen Tests — sie beweist, dass der Test den Fehler überhaupt sieht ([[schranke-gegentesten]], [[test-prueft-den-ausstieg]]). Danach ist der Test ein Regressionstest: vor jedem Paket und Release laufen und **grün** sein, mehr nicht.

**Why:** Bei jeder Behebung erneut „erst rot, dann grün" anzukündigen und zu fahren, kostet Bauten (eine Eudora-Gegenprobe = zwei volle Bauten) ohne neuen Erkenntnisgewinn; Gregor hat es als überflüssig benannt.

**How to apply:** Neuer Test → einmal rot ohne Behebung, grün mit; in der Commit-Nachricht festhalten. Bestehender Test → nur grün. In Zusagen an Gregor nicht mehr „erst rot, dann grün" für jede Behebung versprechen, sondern „mit Regressionstest". Ausnahme: `schranken-gegenprobe.pl` IST der Test einer Schranke (sie prüft, dass die Schranke den Rückfall abweist) — der läuft weiter bei jedem Prüfbericht.

Schranke: keine - eine Arbeitsregel ueber den Umfang von Gegenproben; sie wirkt beim Planen, nicht als Pruefung.
