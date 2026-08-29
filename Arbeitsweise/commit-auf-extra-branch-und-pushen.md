---
name: commit-auf-extra-branch-und-pushen
description: "Zwischenstaende regelmaessig auf einem eigenen Branch committen und pushen, nicht erst am Ende"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-28T18:20:00.000Z
---

Bei laengeren Umbauten in diesem Repo Zwischenstaende laufend auf einem separaten
Branch committen und sofort nach `origin` pushen — nicht bis zum Ende der Sitzung
warten. Gregor hat das am 28.08.2026 ausdruecklich als **Anweisung** wiederholt:
"alles immer sichern und commiten".

**Why:** Die Sitzungen sind lang und die Arbeit besteht aus vielen kleinen,
muehsam gefundenen Einzelkorrekturen. Dazu kommt ein zweiter Grund, der sich am
28.08.2026 gezeigt hat: Wird mein Kontext mitten in der Sitzung zusammengefasst,
verliere ich den Blick auf meine eigene frueher geleistete Arbeit. Die Commits
sind dann das einzige verlaessliche Gedaechtnis — fuer mich wie fuer Gregor.

**How to apply:** Nach jeder abgeschlossenen Fehlerklasse committen und pushen.
Nur Quelldateien stagen (`git add -- "*.h" "*.cpp" "*.vcxproj"`) — Build-Artefakte
sind im Repo mitversioniert und wuerden jeden Commit zumuellen. Den Doku-Abgleich
aus [[doku-bei-jedem-commit-mitziehen]] als festen Schritt davor erledigen.

**Wenn die Repo-Historie unvertraut wirkt:** zuerst `git reflog` und
`git worktree list` befragen, nicht spekulieren. Am 28.08.2026 habe ich Commits
aus meiner eigenen, zusammengefassten Sitzungshaelfte fuer die einer zweiten,
parallel laufenden Sitzung gehalten und Gregor diese Vermutung als Tatsache
mitgeteilt. Das Reflog zeigte eine einzige durchgehende Kette in einem einzigen
Arbeitsverzeichnis. Siehe auch
[[vom-nutzer-geliefertes-material-zuerst-auswerten]].
