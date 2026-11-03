---
name: entscheidung-e128-endung-aus-inhalt
description: "Gregor 03.11.2026 - E-128 Vorschlag angenommen, Vorgabeendung beim Speichern aus dem Inhalt ableiten"
metadata:
  node_type: memory
  type: project
  originSessionId: f3d03714-d2ce-4d84-96d0-5244b9e265ce
  modified: 2026-11-03T06:45:58.147Z
---

Gregor hat am 03.11.2026 auf die Frage „Endung beim Speichern aus dem Inhalt ableiten (`.html` bei HTML, sonst `.txt`) — so einbauen?“ mit *„ja“* geantwortet.

Schranke: keine - Entscheidung Gregors; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt.

Umfang laut Vorschlag in Intern/BEFUNDE.md (E-128): `.html` für eine HTML-Nachricht, `.eml` wenn Kopfzeilen mitgespeichert werden, `.txt` nur für reinen Text; Dateityp im Dialog entsprechend vorbelegen. Stellen: `SaveAsDialog.cpp:284`, `EudoraRes.rc:8509`/`:10602`.

**Why:** offene Entscheidung seit 20.10.2026; nicht wieder fragen.
**How to apply:** Einbau auf eigenem Zweig (Name vorher abstimmen, [[zweig-vorher-abstimmen]]); Entscheidung in Intern/WEITERMACHEN.md (Entscheidungsliste) und im E-128-Eintrag vermerken. Achtung: im Chat nannte ich nur `.html`/`.txt`, `.eml` (mit Kopfzeilen) stand im Befund — beim Einbau `.eml` mitnehmen und das Gregor in einem Satz sagen.

**Nachtrag 03.11.2026 (PRÜFER-90 K3):** eine reine Textmail mit Umlauten bekommt aus der Postfachliste einen MIME-Kopf (E-101) und damit `.eml`. Gregor auf die Frage „.eml oder .txt?“: *„.eml (Recommended)“* — bleibt `.eml`.
