---
name: arbeitsbaum-braucht-eigenes-gegenstueck
description: "Ein Arbeitsbaum-Zweig ohne eigenen Upstream hebt die Trennung auf, fuer die es Arbeitsbaeume gibt - und die fertige Ursachenerklaerung war falsch"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T19:52:29.137Z
---

Schranke: tools/pruefe-branch.pl (pre-commit) - weist ab, wenn ein Zweig wt/<name> nicht origin/wt/<name> verfolgt; gegengetestet in beide Richtungen, die 15 Faelle von pruefe-branch-tests.pl bleiben gruen

## Der Auslöser

**Gregor am 13.09.2026 um 19:22:58:**

> *„was spielt ihr da für ein ping-pong?"*

## Was gemessen wurde

Arbeitsbäume gibt es, damit drei Agenten sich nicht in die Quere kommen.
Verfolgt der Zweig eines Agenten das Gegenstück eines **anderen**, ist genau
diese Trennung aufgehoben: sein `git push` ohne Argumente landet auf fremdem
Gebiet.

Im Wegwerf-Repo gemessen, vier Fälle:

| Befehl | Upstream danach | |
|---|---|---|
| `git checkout -B wt/x fix-imap_utf8` | **keiner** | |
| `git worktree add -b wt/x <pfad> <lokal>` | **keiner** | |
| `git push -u origin wt/x` | `origin/wt/x` | **richtig** |
| `git checkout -B wt/x origin/fix-imap_utf8` | `origin/fix-imap_utf8` | **falsch** |

**Eine lokale Basis vererbt nichts. Eine Remote-Basis — mit `origin/` davor —
setzt den Upstream auf sich selbst.** Das ist der Weg, auf dem ein
Agentenzweig an fremdem Gegenstück hängt.

Die Fälle *ganz ohne* Upstream sind nicht harmlos, sondern nur anders
sichtbar: `pruefe-branch.pl` weist sie ab, und der Agent kann keinen einzigen
Commit machen, bis er es selbst löst. Am 13.09.2026 ist mir genau das im
eigenen Arbeitsbaum passiert — `wt/chronist` hatte keinen Upstream, und der
erste Commit wurde abgewiesen.

**Ein Arbeitsbaum ist also erst dann fertig aufgesetzt, wenn sein Zweig ein
eigenes Gegenstück auf dem Server hat.** Das ist die Aufgabe dessen, der den
Baum aufsetzt, nicht die des Agenten, der darin arbeiten soll
([[agenten-koordinieren]]: die Zuteilung ist meine Aufgabe).

## Why — und der zweite, wichtigere Befund

Die Ursachenerklärung lag mir **fertig formuliert** vor, als ich diesen
Auftrag bekam: `git checkout -B wt/lektor fix-imap_utf8` habe *„dadurch das
Tracking meines Zweigs geerbt"*. Das klang plausibel, deckte sich mit dem
beobachteten Zustand — und ist **falsch**. Die Messung oben zeigt: mit einer
lokalen Basis wird gar kein Upstream gesetzt.

Ebenso nachgemessen: mein eigener erster Befund *„`wt/lektor` trackt
`origin/fix-imap_utf8`"* stimmte um 21:40, aber nicht mehr um 21:50 — LEKTOR
hatte um **21:46:50** selbst gepusht und damit sein Gegenstück angelegt. Ein
Zustand, den ein anderer Agent parallel verändert, ist kein Befund, solange
sein Zeitpunkt nicht dabeisteht.

**Eine Ursache, die im Auftrag schon dabeisteht, ist eine Vermutung wie jede
andere** ([[pruefen-statt-vermuten]], [[widerlegte-vermutungen-aufschreiben]]).
Sie ist sogar die gefährlichere Sorte: sie kommt von jemandem, dem ich glaube,
und sie erspart mir Arbeit. Beides zusammen macht das Nachmessen unattraktiv —
und genau deshalb muss es ausdrücklich sein.

## How to apply

* **Beim Aufsetzen eines Arbeitsbaums gehört der Push dazu**, in einem Schritt:

      git worktree add -b wt/<name> ../Eudora7.2-wt-<name> <basis>
      git -C ../Eudora7.2-wt-<name> push -u origin wt/<name>

* **Nie eine Basis mit `origin/` davor**, wenn der neue Zweig ein eigenes
  Gegenstück bekommen soll. Lokale Basis nehmen, dann `push -u`.
* **Jede Ursachenangabe im Auftrag wird behandelt wie eine eigene Vermutung.**
  Zustimmen ist keine Prüfung. Widerlegt sie sich, gehört das in die Antwort —
  dem Auftraggeber ist mit einer bestätigten Fehlannahme nicht gedient.
* **Einen Zustand, an dem parallele Agenten arbeiten, immer mit Uhrzeit
  messen** — und vor dem Urteil noch einmal, weil er sich inzwischen geändert
  haben kann.
