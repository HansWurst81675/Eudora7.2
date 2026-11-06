---
name: pruefstand-nur-mit-marke
description: Prüfstand-Werkzeuge fassen nur Verzeichnisse mit der Marke .eudora72-pruefstand an – unter C:\Temp können fremde Eudora-Ordner mit echten Mails liegen; nie in Gregors Ordnern messen
metadata:
  node_type: memory
  type: project
  originSessionId: 8e921d9a-b658-4cfb-9fea-ce8200ddbb4c
  modified: 2026-11-06T16:35:52.607Z
---

Schranke: tools/testlauf.ps1, tools/pruefstand-lauf.ps1, tools/pruefstaende-auffrischen.ps1 und die Registry-Rücksetzung (tools/pruefstand-sperre.ps1) weisen Verzeichnisse ohne die Marke .eudora72-pruefstand ab (seit 06.11.2026, E-243). Nicht geschützt: ein messen-*.ps1 -Vorbereiten von Hand.

Unter `C:\Temp` können Eudora-Ordner mit echten Mails liegen (etwa ein entpacktes Release, mit dem jemand arbeitet). Die Prüfstand-Werkzeuge leeren Postfächer, schreiben die Eudora.ini um und setzen Registry-Werte zurück – in einem fremden Ordner wäre das Datenverlust.

**Why:** E-243 (PRÜFER-104 K2), Entscheidung 39.

**How to apply:** Prüfstände nur über den Einrichter (Marke) oder von Hand markiert, wenn sie nachweislich eigene sind. Keinen Prüfstandslauf für Gregors Rechner vorschlagen. **Nie Angaben über Gregors Rechner, Ordner oder Daten in eine Datei schreiben** – auch nicht als Anlass ([[gedaechtnis-ist-oeffentlich]]); Gregor 06.11.2026: *„anlaß heißt nicht, alle persönlichen daten!“*
