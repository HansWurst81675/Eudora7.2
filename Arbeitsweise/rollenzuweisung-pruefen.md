---
name: rollenzuweisung-pruefen
description: "Einer falschen Rollenzuweisung im Auftrag folgen, statt sie zu benennen - und die Rolle stand in keiner nachschlagbaren Quelle"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T19:56:09.881Z
---

Schranke: tools/pruefe-rollen-doku.pl (pre-commit) - jede in tools/rollen-faellig.pl definierte Rolle muss in AGENTEN.md mit Namen UND Zustaendigkeitssatz stehen; gegengetestet mit --selbsttest (4 Faelle) und am echten Zustand, der vorher 3 von 3 Rollen als fehlend meldete

## Der Auslöser

**Gregor am 13.09.2026 um 19:33:42:**

> *„laß mal während dessen den lektor über unser chat laufen, er soll mal
> lessons leared aktualisieren. ich sehe hier wieder sehr viel
> verbesserungspotential."*

Ich habe LEKTOR beauftragt. **59 Sekunden später**, um 19:34:41, bemerkte er
es selbst:

> *„halt: das war der chronist, ja?"*

und um 19:35:47:

> *„mein fehler, weise die aufgabe dem korrekten agenten zu."*

## Die Messung — die Rolle war nirgends nachschlagbar

Der naheliegende Schluss wäre: *„ich hätte widersprechen müssen."* Das stimmt,
greift aber zu kurz. Nachgemessen am Repo:

**`AGENTEN.md` enthielt das Wort CHRONIST kein einziges Mal.** Die Datei
stammt vom 07.09.2026 und kennt die Rolle nicht. Auch LEKTOR und PRUEFER
standen dort ohne ihren Zuständigkeitssatz. Die einzige Stelle, an der die
Zuordnung definiert war — CHRONIST, *„die Lehren aus dem Verlauf"*, Auftrag
*„Den Chat seit dem letzten Lauf auswerten"* — steht im **Quelltext** von
`tools/rollen-faellig.pl`.

Weder Gregor noch ich konnten also nachschlagen, wer zuständig ist. Er sagte
„lektor", ich folgte, und keine Quelle hätte einen von uns beiden korrigiert.
Gregor hat den Fehler auf sich genommen (*„mein fehler"*) — die eigentliche
Ursache lag aber im Repo.

## Why

Zwei Dinge fallen hier zusammen, und beide sind behebbar:

1. **Eine Rollenzuweisung im Auftrag ist eine Angabe wie jede andere und wird
   geprüft**, bevor der Agent startet. Ein Auftrag kann sich im Adressaten
   irren, genauso wie in einer Ursache
   ([[arbeitsbaum-braucht-eigenes-gegenstueck]], wo die mitgelieferte Ursache
   sich als falsch erwies). Der Aufwand ist ein Blick in eine Tabelle.
2. **Wissen, das nur im Quelltext einer Schranke steht, ist für den
   Auftraggeber nicht vorhanden.** Die Schranke arbeitet damit richtig — aber
   sie kann nur abweisen, nicht erklären. Was eine Entscheidung leiten soll,
   gehört dorthin, wo man es vor der Entscheidung liest
   ([[wissen-gehoert-in-dateien]], [[anforderung-gehoert-in-den-massstab]]).

Der Unterschied zu [[erlaubnis-nicht-hineinlesen]]: dort lese ich in eine
Aussage eine Erlaubnis hinein, die nicht darin steht. Hier übernehme ich eine
Angabe, die ausdrücklich darin steht — und trotzdem falsch ist.

## How to apply

* **Vor dem Start eines Agenten die Zuständigkeit an der Tabelle in
  `AGENTEN.md` prüfen.** Passt der genannte Name nicht zur Aufgabe, wird das
  gesagt, bevor der Agent läuft — nicht hinterher.
* **Die Aufgabe entscheidet, nicht der genannte Name.** „Lessons learned aus
  dem Chat" ist CHRONIST, auch wenn im Auftrag „lektor" steht.
* **Wenn eine Rolle, ein Wert oder eine Regel nur im Quelltext einer Schranke
  steht, gehört sie zusätzlich in die Datei, in der man sie sucht** — und eine
  Prüfung hält beide gegeneinander, statt sie danebenzulegen
  ([[pruefumfang-nicht-von-hand]]).
* **Widersprechen ist billiger als ausführen.** Ein Satz vor dem Start kostet
  Sekunden; ein Agent auf dem falschen Auftrag kostet seinen ganzen Lauf — und
  Gregor die Aufmerksamkeit, die er gerade nicht übrig hat.
