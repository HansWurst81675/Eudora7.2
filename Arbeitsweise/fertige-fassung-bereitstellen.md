---
name: fertige-fassung-bereitstellen
description: "Ist eine neue Fassung fertig, erst eigene Tests, dann als Verzeichnis neben Gregors letztem Release-Verzeichnis bereitstellen"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-12T09:50:13.809Z
---

Gregor am 12.10.2026: *„wenn eine neue version fertig ist, mach lasse die eigenen tests und wenn alles ok ist, stell mir diese bereit"* — und auf die Frage nach dem Ort: *„ja, hier C:\Users\Gregor\Eudora72-1.0.76-release parallel dazu"*.

**Why:** Er will nicht nach jeder Fassung fragen müssen, ob sie getestet ist und wo sie liegt; er testet selbst erst, wenn meine Prüfung grün ist.

**How to apply:**
- Nach dem Bau: Testsuite (EudoraTests), Messlauf am laufenden Programm über `tools/testlauf.ps1` mit `-MessenSkript`, `paket-pruefen.ps1` — erst wenn alles grün ist, bereitstellen.
- Ort: ein **neues** Verzeichnis `C:\Users\Gregor\Eudora72-<Paketnummer>-release` **neben** dem vorhandenen; das vorhandene (z. B. `Eudora72-1.0.76-release`) wird nicht angefasst. Sein `Mailverzeichnis` dort enthält seine alten Mails und die ini — nur lesen.
- Das ist eine Erlaubnis für genau dieses Bereitstellen, nicht für andere Schreibzugriffe in seinen `Eudora72-*`-Verzeichnissen ([[erlaubnis-nicht-hineinlesen]], [[nichts-auf-gregors-bildschirm-starten]]).
- Kein Release ohne seinen Test ([[release-erst-nach-gregors-test]]).

Schranke: tools/paket-pruefen.ps1 (nach jedem Bereitstellen, gegen das Zielverzeichnis) - ob eine Fassung "fertig" ist, laesst sich nicht mechanisch pruefen; geprueft wird, dass das Bereitgestellte vollstaendig ist und zum Bau passt
