---
name: reihenfolge-nach-1083
description: "Gregors Reihenfolge der Befunde - Stand 14.10.2026: nach PR e-112-skalierung zuerst E-105, dann E-118, E-113, E-77"
metadata:
  node_type: memory
  type: project
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-14T05:32:45.658Z
---

Gregors Reihenfolge, fortgeschrieben:

- 12.10.2026: Release 1.0.83, dann E-94 mit Test zuerst, dann E-112, E-113, E-77.
- 13.10.2026: E-112 (mit E-103), E-115, E-117 auf Zweig `e-112-skalierung` behoben, an 1.0.86/1.0.87 von Gregor bestätigt.
- **14.10.2026: „ja, E-105 vorziehen"** – nach dem PR `e-112-skalierung` → `main` kommt **E-105** (doppelte Abschnitte durch `display:none`, Desktop- und Handyfassung von Newslettern), dann E-118 (HTML-Mail in IMAP-Ordner als Quelltext), dann E-113, E-77.

**Why:** E-105 trat an einem Tag dreimal bei Gregors echten Newslettern auf (Camper, freenet Autofahrer); sichtbarer als E-113.

**How to apply:** Nach dem Merge zuerst einen Zweignamen für E-105 vorschlagen ([[zweig-vorher-abstimmen]]), Test zuerst ([[tests-vor-jedem-commit-laufen-lassen]]).

Schranke: keine - eine Reihenfolge ist eine Absprache, kein Zustand im Code.

- **14.10.2026: Zweig für E-118 heißt `e-118_HTML_header`** (Gregors Vorschlag, von mir bestätigt). Anlegen erst nach dem Merge von `e-105_doppelte_bilder`, auf frischem `main` - sonst tragen beide Zweige 7.2.0.88 (Gregor: *„ja, macht sinn.“*).
