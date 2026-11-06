---
name: entscheidung-alte-pfade-weg-06-11
description: "Gregor 06.11.2026 — Pfade in sein Benutzerverzeichnis aus dem Repo entfernen, C:\\Temp darf stehen bleiben"
metadata:
  node_type: memory
  type: project
  originSessionId: 8e921d9a-b658-4cfb-9fea-ce8200ddbb4c
  modified: 2026-11-06T21:10:15.431Z
---

Schranke: `tools/pruefe-namen-gestaget.pl` (pre-commit, pre-push) mit dem Muster „Pfad ins Benutzerverzeichnis des Anwenders“ in der lokalen Liste `tools/anonym-begriffe.lokal` (seit 06.11.2026).

Gregor am 06.11.2026 zu LEKTOR-158 L-158.8 (rund 290 alte Pfade in seine Testverzeichnisse): Pfade in sein Benutzerverzeichnis sollen weg. Pfade unter `C:\Temp` sind unkritisch und bleiben.

**Why:** Datenschutz; `C:\Temp` ist der vereinbarte Testort, das Benutzerverzeichnis ist privat.

**How to apply:** Teil 2 der Bereinigung entfernt Pfade ins Benutzerverzeichnis überall im Baum (nicht kürzen, [[ueberall-heisst-ueberall]]). `C:\Temp`-Pfade nicht anfassen. Die Frage nach dem Umschreiben der Geschichte von `main` ist damit nicht entschieden. Siehe [[gedaechtnis-ist-oeffentlich]].
