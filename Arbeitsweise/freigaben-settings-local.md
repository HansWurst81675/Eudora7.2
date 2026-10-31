---
name: freigaben-settings-local
description: "Gregor 30.10.2026 abends - Freigaben stehen in .claude/settings.local.json (git push, perl tools/); Befehle so schreiben, dass sie genau darunter fallen; alles im Projektordner, Rollenbaeume unter .wt/"
metadata:
  node_type: memory
  type: feedback
  originSessionId: f6188ad4-4df8-4a5e-bb99-a9fb32d6557a
  modified: 2026-10-30T22:26:24.192Z
---

Schranke: keine - ob eine Abfrage kommt, entscheidet die Rechtepruefung; die Regeln stehen in `.claude/settings.local.json` (ignoriert, nicht im Repo).

Gregor hat am 30.10.2026 gegen 22:20 per `/permissions` in **`.claude/settings.local.json`** freigegeben: `Bash(git push:*)` und `Bash(perl tools/:*)`. Beide gegengeprueft: `git push` (cf45bc19) und `perl tools/auftrag-rolle.pl` liefen ohne Abfrage. Zusaetzlich gilt weiter `permissions.blockReadsOutsideWorkingDirectories` - jedes Lesen ausserhalb von `C:\Users\Gregor\Documents\github\Eudora7.2` wird gesperrt.

Gregor: *„mach so weiter, wie du vor dem release gemacht hast - ohne mich zu fragen ... ohne mich mit einzelnen abfragen zu nerven"* und *„warum arbeitest du also nicht in deinem eigenen raum?"*

**Why:** Bis 7.2.1.128 kamen keine Abfragen; danach fragte jede schreibende oder nach aussen gehende Aktion. Gregor lehnte die Abfragen ab, statt sie zu beantworten - jede kostet ihn Zeit und Vertrauen ([[keine-unverstaendlichen-abfragen]]).

**How to apply:**
- Nur im Projektordner arbeiten. Rollen- und Agentenbaeume legen `tools/auftrag-rolle.pl` und `tools/arbeitsbaum-frei.pl` jetzt unter `.wt/<name>` an (Commit f0493d14). Die alten `../Eudora7.2-wt-*` nicht mehr anfassen.
- Befehle so schreiben, dass sie unter eine Regel fallen: `git push` allein, `perl tools/<name>.pl ...` allein, ohne `perl -e`, moeglichst ohne Pipes und Verkettungen um den freigegebenen Befehl herum.
- Faellt etwas Noetiges unter keine Regel: Gregor die genaue Regel und den Ort (`/permissions` -> Allow -> Project settings (local)) nennen, nicht den Befehl trotzdem abschicken.

## Stand 30.10.2026 Schluss: die vollstaendige Liste

Gregor hat nach *„du verplämperst meine zeit damit, irgendwelche freigaben zu erfragen“* alles in einem Block in `.claude/settings.local.json` gesetzt: allow `git push:*`, `git fetch:*`, `git merge:*`, `perl tools/*` (Stern direkt hinter dem Schraegstrich - `perl tools/:*` griff vermutlich nie), `gh pr create:*`, `powershell -NoProfile -ExecutionPolicy Bypass -File tools/*`; additionalDirectories `.wt\lektor`, `.wt\chronist`, der projects-Ordner und `C:\Temp`. **Nicht wieder nach Freigaben fragen.** Faellt etwas darunter nicht, arbeite ich ohne es weiter und schreibe es in die Uebergabe. PowerShell-Skripte genau in dieser Form aufrufen (Pfad relativ `tools/...`, aus dem Projektordner, ohne `cd`).

## Nachtrag 30.10.2026 (CHRONIST): die Regel stand um 22:32, der Auftrag um 22:40 brach sie

Zeiten MEZ, Transkript `f6188ad4`, gemessen.

- **Der eigene Auftrag hielt die Regel nicht ein.** Diese Lehre sagt seit 22:32:29: *„ohne Verkettungen um den freigegebenen Befehl herum“*. Der CHRONIST-Auftrag um 22:40 schrieb als einzig erlaubte Shell-Form vor: `cd /c/Users/Gregor/Documents/github/Eudora7.2 && perl tools/verlauf-messen.pl <argumente>`. Der CHRONIST hielt sich wörtlich daran, und es kamen drei Abfragen (22:41:04, 22:41:32, 22:41:40). Gregor um 22:42:56: *„ich habe ja wt für chronisten freitgegeben, ja? warum hält er sich nicht dran?“* Er hielt sich daran. Falsch war die Vorgabe. Ein Auftrag mit Befehlsform wird vor dem Start gegen diese Lehre gelesen ([[auftrag-darf-nicht-loeschen]], gleiche Klasse: der Auftrag trägt den Fehler).
- **Die Freigaben kamen in fünf Runden.** Gregor meldete *„ist gesetzt, prüfe“* um 22:28:21, 22:30:21, 22:35:37, 22:36:04 und 22:38:45. Zuerst wurde ihm nur `git push` genannt. Die Perl-Regel kam erst, nachdem er selbst gefragt hatte: *„was ist mit perl?“* (22:28:41), *„z.b. für  perl tools/lehren-uebersicht.pl“* (22:29:20). Danach folgten das Verzeichnis für den LEKTOR, ein fehlendes Komma und um 22:37:58 *„wo ist die andere freigabe für chronisten?“*. Alles, was die Rollen des Abends brauchten, stand schon um 22:24 fest: `tools/auftraege/LEKTOR.txt`, die CHRONIST-Vorgabe und die Pfade der Protokolle.
- **How to apply, zusätzlich:** Wer Gregor um eine Freigabe bittet, nennt **alle** Einträge für alle Rollen des Abends in einem Block. Vorher wird für jede Rolle gezählt, welche Befehle und Verzeichnisse ihr Auftrag nennt ([[liste-aus-einer-quelle]]). Eine Rolle, deren Befehle unter keine Regel fallen, startet erst, wenn die Regel steht.
