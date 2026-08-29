---
name: fehlerklassen-abstellen
description: "Wiederholte Fehler mit Werkzeug und Schranke abstellen, nicht einzeln nachbessern — Vorsatz allein hält nicht"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:09.641Z
---

Wenn derselbe Fehler zum zweiten Mal auftritt, ist das kein Anlass, ihn nochmals
zu beheben, sondern ihn **unmöglich zu machen**: ein Werkzeug, das den richtigen
Weg zum bequemsten macht, und eine Schranke, die den falschen Weg blockiert.

**Why:** Gregor am 28.08.2026, nachdem eine Einzeilenänderung zum zweiten Mal als
134 geänderte Zeilen im Diff erschien:

> „sowas ähnliches habe ich heute bereits gelesen. kannst du das nicht besser
> machen? anstatt hinterher es zu fixen? da kann man doch bestimmt eine regel oder
> strategie anwenden?"

Und tags darauf, als die Schranke einen dritten Anlauf abfing: „gut, daß er von der
schranke entdeckt wird, aber das kostet ja zeit" — die Schranke ist die zweite
Verteidigungslinie, nicht die erste.

**Was daraus entstanden ist und sich bewährt hat:**

- `tools/aendere-zeile.pl` — byteerhaltende Einzelzeilenänderung; ersetzt
  handgebautes `sed -b`.
- `tools/pruefe-bytes.pl` als pre-commit-Hook („die Schranke") — hat am 29.08.2026
  zwei Zeilenendenschäden abgefangen, die sonst im Repo gelandet wären.
- Die Testprojekte unter `Eudora71/Tests` — haben zwei echte Fehler in der
  Zeichentabelle aufgedeckt, die durch Lesen nicht aufgefallen waren.

Das sind die wirksamsten Ergebnisse des Projekts nach Zeitersparnis. Eine Merkregel
im Kopf hat dagegen dreimal nicht gehalten.

**How to apply:** Beim zweiten Auftreten derselben Fehlerklasse die Arbeit
unterbrechen und fragen: *Welches Werkzeug macht den Fehler unmöglich, und welche
Prüfung fängt ihn ab, falls er doch passiert?* Beides bauen, ins Repo legen,
dokumentieren — erst dann weitermachen. Das gilt nicht nur für Zeilenenden: für
hängende Kommandos ist das Werkzeug „alles Lange in den Hintergrund"
([[nie-stillstehen]]), für ungeprüfte Zahlen in der Doku der zweite Agent, der
jeden Wert nachmisst ([[doku-bei-jedem-commit-mitziehen]]).

Siehe auch [[quelldateien-nur-byte-erhaltend-aendern]] und
[[tests-vor-jedem-commit-laufen-lassen]].
