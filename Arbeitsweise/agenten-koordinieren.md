---
name: agenten-koordinieren
description: "Ein Arbeitsbaum gehört genau einem Agenten; vor jedem Start prüfen, ob er frei ist, und nach jedem Rücklauf die Sicherung messen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-05T18:37:10.093Z
---

**Ein Arbeitsbaum gehört genau einem Agenten — für dessen ganze Lebensdauer.**

Gregor am 05.09.2026: *„du mußt deine agenten besser koordinieren, damit nichts
verloren geht! das ist wichtig. jedes mal. bei jeder session!"*

**Why:** Ich hatte BAUMEISTER und BEENDEN denselben Baum
(`Eudora7.2-wt-paket`) zugeteilt. BEENDEN hat dort mit `git checkout -B` den
Branch gewechselt und dabei BAUMEISTERs **unversionierte** Arbeit gelöscht.
BAUMEISTER musste sie rekonstruieren und in einen anderen Baum ausweichen. Es
ging am Ende nichts verloren — aber nur, weil der Agent es selbst gemerkt und
gemeldet hat. Darauf ist kein Verlass.

Ein zweiter Weg, auf dem Arbeit verschwindet: ein Agent liefert seinen Bericht
als **unverfolgte Datei** im Arbeitsbaum ab und committet sie nicht. Beim
nächsten Branchwechsel ist sie weg.

**How to apply:**

- **Vor jedem Start:** `git worktree list` und nachsehen, ob der Baum schon
  belegt ist. Belegt heißt: ein Agent läuft dort noch — nicht, ob Dateien
  drinliegen. Ist keiner frei, einen neuen anlegen:
  `git worktree add -b wt/<name> ../Eudora7.2-wt-<name> <basis>`
- **Im Auftrag immer nennen:** der genaue Pfad des Baums, der Branchname, und
  die Auflage *„arbeite ausschließlich in deinem eigenen Baum"*.
- **Nie zwei Agenten auf dieselbe Datei ansetzen** — auch nicht auf
  `BEFUNDE.md`. Wenn beide dort schreiben sollen, macht es einer, oder sie
  schreiben in getrennte Dateien und ich führe zusammen.
- **Befundkennungen vergebe ICH, nicht der Agent.** Am 05.09.2026 haben KONTO
  und FORTSCHRITT unabhängig „die nächste freie E-Nummer" gewählt und beide
  `E-12` genommen. Wer parallel arbeitet, kann keine freie Nummer bestimmen —
  der Nachbar schreibt gleichzeitig. Also im Auftrag die Kennung **nennen**,
  oder den Agenten in eine eigene Datei schreiben lassen und beim
  Zusammenführen numerieren.
- **Im Auftrag verlangen:** committen **und** pushen, nicht nur schreiben. Ein
  Bericht, der unverfolgt im Baum liegt, ist nicht gesichert.
- **Nach jedem Rücklauf messen**, nicht glauben: `perl tools/gesichert.pl`
  zeigt je Baum, was uncommittet und was ungepusht ist.
- **Wenn Gregor einen Merge ankündigt:** sofort alle Bäume prüfen, bevor
  irgendetwas anderes passiert. Siehe [[main-muss-immer-baubar-sein]].

Der Grundsatz dahinter ist derselbe wie bei den Schranken: eine Regel, die nur
in meinem Kopf existiert, trägt nicht. Sie muss vor dem Start geprüft und nach
dem Rücklauf gemessen werden. Siehe [[fehlerklassen-abstellen]],
[[agenten-trennen-worktrees]], [[wissen-gehoert-in-dateien]] und
[[agenten-benennen]].
