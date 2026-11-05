---
name: entscheidung-e193-suche-umbruch-05-11
description: Gregor 05.11.2026: Edit→Find sucht nach erfolgloser Weitersuche automatisch von oben weiter (A) und scrollt zum Treffer; Forget Password lässt Häkchen stehen
metadata:
  type: project
---
Schranke: keine - Entscheidung; geprüft beim Einarbeiten in Intern/BEFUNDE.md (E-193) und durch den Regressionstest der Behebung.

Ursache E-193-Rest (Gregor 05.11.2026 selbst gefunden, Bildschirmfoto an 7.2.2.134): Find Messages öffnet die Mail mit markiertem Treffer; Edit → Find sucht ab der Markierung weiter (wie F3), kommt das Wort nur einmal vor → „not found“, kein Umbruch nach oben.

Gregor: *„A, aber dann dorthin scrollen, um es sichtbar zu machen.“* → Bei „nicht gefunden“ und Start nicht am Anfang einmal von oben weitersuchen; den (ggf. einzigen, schon markierten) Treffer markieren UND in den sichtbaren Bereich scrollen.

Außerdem 05.11.: *Forget Password(s)* löscht nur das Kennwort, das Häkchen „Remember password“ bleibt — *„können wir aber so drin lassen.“* (PRÜFER-100 K1).

**Why:** Anwender sieht sonst „not found“ für ein Wort, das in der Mail steht.
**How to apply:** Nicht wieder fragen. Siehe [[entscheidung-e193-zweistufig]].
