---
name: nie-direkt-auf-main
description: "Jede Änderung geht über einen eigenen Zweig; auf main wird nur gemergt, und Gregor merged"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-05T20:21:49.945Z
---

**Nie direkt auf `main` committen. Jede Änderung geht über einen eigenen Zweig.**

Gregor am 05.09.2026: *„keine direkten änderungen am main branch. ich werde ihn
sperren, damit du das nicht dauernd machen kannst."* Und vorher schon:
*„main wird ausgecheckt, sonst nichts!"*

**Why:** Am 05.09.2026 habe ich nach dem Merge zwei Commits direkt auf `main`
gelegt (`61c9540`, `1cfc520`), weil der Arbeitszweig gerade gelöscht worden war
und es „nur noch zwei Kleinigkeiten" waren. Genau so entsteht ein `main`, der
nicht mehr das ist, was Gregor gemerged hat.

Der Zusammenhang mit [[main-muss-immer-baubar-sein]]: `main` trägt immer einen
Stand, der fehlerfrei baut und aus dem sich jederzeit ein Release erstellen
lässt. Das lässt sich nur halten, wenn jede Änderung **vorher** auf einem Zweig
geprüft wurde — nicht, wenn nebenbei direkt hineingeschrieben wird.

**How to apply:**

- **Vor der ersten Änderung** einer Sitzung: Zweig anlegen, auch wenn es „nur
  eine Kleinigkeit" ist.
  ```
  git checkout -b <sprechender-name> origin/main
  ```
- **Nach einem Merge durch Gregor**: der alte Zweig ist weg. Für die nächste
  Arbeit einen **neuen** anlegen, nicht auf `main` weitermachen. Das ist genau
  die Stelle, an der ich es falsch gemacht habe.
- **Gregor merged**, nicht ich. Ich pushe den Zweig und sage, dass er fertig
  ist — mit dem Prüfstand: Bauten grün, Tests grün, was ungeprüft ist.
- **`main` wird gesperrt.** Wenn ein Push nach `main` abgelehnt wird, ist das
  kein Fehler, den ich umgehe — es ist die Schranke, die tut, was sie soll.

Siehe [[main-muss-immer-baubar-sein]], [[commit-auf-extra-branch-und-pushen]]
und [[agenten-koordinieren]].
