---
name: agenten-trennen-worktrees
description: "Parallele Agenten teilen sich Arbeitsverzeichnis und git-Index — mit Worktrees trennen, sonst mit Pfadangabe committen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-30T13:21:35.141Z
---

Mehrere gleichzeitig laufende Agenten teilen sich **dasselbe Arbeitsverzeichnis und
denselben git-Index**. Das führt zu zwei Schäden:

1. Ein `git add` eines Agenten stagt auch die halbfertigen Dateien der anderen; der
   nächste `git commit` nimmt sie mit. Am 30.08.2026 landeten so vier Quelldateien
   und ein ganzer `BEFUNDE.md`-Abschnitt eines Agenten im Commit eines anderen,
   dessen Nachricht von etwas völlig anderem sprach.
2. Gleichzeitige Commits scheitern mit `cannot lock ref 'HEAD'`.

**Ein eigener Branch pro Agent hilft NICHT** — Branches teilen sich das
Arbeitsverzeichnis. Ein `git checkout` eines Agenten würde die Dateien unter den
anderen wegändern.

**How to apply:**

*Beim Beauftragen einer neuen Welle:* `isolation: "worktree"` im Agent-Aufruf. Jeder
Agent bekommt ein eigenes Verzeichnis mit eigenem Index und eigenem Branch;
zusammengeführt wird bewusst am Ende. Das ist der richtige Weg, wenn mehrere Agenten
Code schreiben.

*Wenn Agenten schon laufen* (Umzug wäre Abbruch und Kontextverlust): allen die Regel
geben, **nur mit ausdrücklicher Pfadangabe zu committen**:

    git commit -m "..." -- <pfad1> <pfad2>

Kein `git add` vorher. Das committet genau diese Pfade, unabhängig vom Indexzustand.
Bei `cannot lock ref 'HEAD'` kurz warten und erneut versuchen.

*Immer:* jedem Agenten eine eigene Zieldatei für seine Dokumentation zuweisen. Wo
mehrere in dieselbe Datei schreiben müssen (etwa `BEFUNDE.md`), bekommt jeder einen
eigenen, überschriebenen Abschnitt am Ende — dann löst `git pull --rebase` die
Konflikte meist von selbst. Siehe [[agenten-benennen]] und
[[wissen-gehoert-in-dateien]].
