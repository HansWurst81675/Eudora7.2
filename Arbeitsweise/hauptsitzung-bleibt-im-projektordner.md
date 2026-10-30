---
name: hauptsitzung-bleibt-im-projektordner
description: "Ein cd in der Hauptsitzung bleibt stehen, sobald das Ziel ein freigegebenes Verzeichnis ist; am 30.10.2026 um 22:36 wanderte die Hauptsitzung so in den LEKTOR-Baum .wt/lektor, und jeder spätere Agent erbte ihn als Arbeitsverzeichnis, ohne den Projektordner"
metadata:
  node_type: memory
  type: feedback
  originSessionId: f6188ad4-4df8-4a5e-bb99-a9fb32d6557a
  modified: 2026-10-30T21:48:23.452Z
---

Schranke: keine - das Arbeitsverzeichnis der Sitzung prüft kein Werkzeug. Vorschlag in [[CHRONIST-2026-10-30c]], Werkzeugmängel Punkt 2.

# Die Hauptsitzung bleibt im Projektordner

**Regel.** In der Hauptsitzung beginnt kein Bash-Aufruf mit `cd` in einen Rollenbaum (`.wt/<name>`). Was dort zu tun ist, läuft mit `git -C .wt/<name> …` oder mit einem Pfad als Argument. Nach jedem `cd`, das nicht in den Projektordner zurückführt, steht im nächsten Aufruf `pwd`.

## Was passiert ist (30.10.2026, Transkript `f6188ad4`, MEZ)

| Zeit | Was | Art |
|---|---|---|
| 22:35:37 | Gregor trägt `.wt/lektor` als freigegebenes Verzeichnis ein (*„ist gesetzt, prüfe“*), die Sitzung meldet *„Additional working directories added: …\.wt\lektor“* | gemessen |
| 22:36:10 | Aufruf `cd /c/Users/Gregor/Documents/github/Eudora7.2/.wt/lektor && git status --short --branch`. Ab hier trägt jeder Eintrag der Sitzung `"cwd":"…\Eudora7.2\.wt\lektor"`, 82 Einträge bis 22:47 | gemessen (Grep auf `cwd`) |
| 22:40 | Der CHRONIST startet. Sein Arbeitsverzeichnis ist `.wt\lektor`, der Zweig laut Kopf `wt/lektor-20261030`. Freigegeben sind ihm `.wt\lektor`, `.wt\chronist` und der Protokollordner, der Projektordner selbst nicht | belegt (Umgebungsblock des Laufs) |
| 22:41:04–22:41:40 | Drei Abfragen beim CHRONIST, Befehl jedes Mal `cd /c/Users/Gregor/Documents/github/Eudora7.2 && perl tools/verlauf-messen.pl …`, alle abgelehnt | gemessen |
| 22:45:20 | Hauptsitzung: `perl tools/lehren-uebersicht.pl -schreiben` ohne Verkettung, aber in `.wt/lektor`. Trotz der Regel `Bash(perl tools/:*)` kam eine Abfrage, Gregor lehnte ab | gemessen |

Der Bash-Hinweis von Claude Code sagt es selbst: Ein `cd` wirkt in der Hauptsitzung weiter, *wenn es innerhalb der freigegebenen Verzeichnisse endet*. Bis 22:35 war `.wt/lektor` kein solches Verzeichnis. Danach war es eines, und das `cd` blieb stehen.

**Warum es zählt.**
- **Jeder Agent erbt den Ort.** Ein CHRONIST oder PRUEFER, der danach startet, arbeitet im Baum des LEKTOR und hat den Projektordner nicht mehr unter seinen Freigaben. Dass die drei Abfragen des CHRONIST um 22:41 daher kamen, ist eine Vermutung. Sein Befehl wechselte in den Projektordner, und genau der fehlte in seiner Liste.
- **Die Freigaben liegen nicht im Baum.** `.claude/settings.local.json` ist ignoriert und steht nur im Projektordner. Unter `.wt/lektor/.claude/` liegt nur `settings.json` (gemessen mit Glob). Dass die Abfrage um 22:45:20 daher kam, ist eine Vermutung. Dagegen spricht, dass der zweite LEKTOR (ab 22:36, Arbeitsverzeichnis `.wt/lektor`) `perl tools/doku-pruefen.pl` und drei weitere Werkzeuge ohne Abfrage fahren konnte. Die Abfrage kam nur bei dem schreibenden Aufruf `-schreiben`.
- **Commits landen auf dem falschen Zweig.** Ein `git commit` ohne Pfad geht ab 22:36 auf `wt/lektor-20261030`, nicht auf `fortsetzen_status_nie_gemessen`.

**How to apply:**
- In der Hauptsitzung: `git -C .wt/lektor status`, nicht `cd .wt/lektor && git status`.
- Vor jedem Agentenstart prüft `pwd`, dass die Hauptsitzung im Projektordner steht. Ein Agent, der in einem Rollenbaum arbeiten soll, bekommt den Baum über `isolation` oder im Auftrag als Pfad.
- Nach einer neuen Freigabe für ein Verzeichnis (`/add-dir`) wird in der Hauptsitzung nicht dorthin gewechselt.

Verwandt: [[agenten-trennen-worktrees]], [[arbeitsbaum-braucht-eigenes-gegenstueck]], [[freigaben-settings-local]], [[keine-unverstaendlichen-abfragen]].
