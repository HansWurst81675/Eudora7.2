---
name: freigaben-settings-local
description: "Gregor 30.10.2026 abends - Freigaben stehen in .claude/settings.local.json (git push, perl tools/); Befehle so schreiben, dass sie genau darunter fallen; alles im Projektordner, Rollenbaeume unter .wt/"
metadata:
  node_type: memory
  type: feedback
  originSessionId: f6188ad4-4df8-4a5e-bb99-a9fb32d6557a
  modified: 2026-10-30T21:32:29.708Z
---

Schranke: keine - ob eine Abfrage kommt, entscheidet die Rechtepruefung; die Regeln stehen in `.claude/settings.local.json` (ignoriert, nicht im Repo).

Gregor hat am 30.10.2026 gegen 22:20 per `/permissions` in **`.claude/settings.local.json`** freigegeben: `Bash(git push:*)` und `Bash(perl tools/:*)`. Beide gegengeprueft: `git push` (cf45bc19) und `perl tools/auftrag-rolle.pl` liefen ohne Abfrage. Zusaetzlich gilt weiter `permissions.blockReadsOutsideWorkingDirectories` - jedes Lesen ausserhalb von `C:\Users\Gregor\Documents\github\Eudora7.2` wird gesperrt.

Gregor: *„mach so weiter, wie du vor dem release gemacht hast - ohne mich zu fragen ... ohne mich mit einzelnen abfragen zu nerven"* und *„warum arbeitest du also nicht in deinem eigenen raum?"*

**Why:** Bis 7.2.1.128 kamen keine Abfragen; danach fragte jede schreibende oder nach aussen gehende Aktion. Gregor lehnte die Abfragen ab, statt sie zu beantworten - jede kostet ihn Zeit und Vertrauen ([[keine-unverstaendlichen-abfragen]]).

**How to apply:**
- Nur im Projektordner arbeiten. Rollen- und Agentenbaeume legen `tools/auftrag-rolle.pl` und `tools/arbeitsbaum-frei.pl` jetzt unter `.wt/<name>` an (Commit f0493d14). Die alten `../Eudora7.2-wt-*` nicht mehr anfassen.
- Befehle so schreiben, dass sie unter eine Regel fallen: `git push` allein, `perl tools/<name>.pl ...` allein, ohne `perl -e`, moeglichst ohne Pipes und Verkettungen um den freigegebenen Befehl herum.
- Faellt etwas Noetiges unter keine Regel: Gregor die genaue Regel und den Ort (`/permissions` -> Allow -> Project settings (local)) nennen, nicht den Befehl trotzdem abschicken.
