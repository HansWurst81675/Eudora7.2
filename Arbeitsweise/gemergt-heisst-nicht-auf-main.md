---
name: gemergt-heisst-nicht-auf-main
description: "GitHub zeigte PR #134 und #135 beide als merged, und main enthielt den Inhalt von #135 trotzdem nicht - der Zweig war von #134 abgezweigt statt von main, 13 Minuten lang stand ein Paket als geliefert da, das nirgends angekommen war"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-22T12:15:00.000Z
---

Schranke: keine - es fehlt ein Werkzeug, das nach jedem Merge den **Inhalt** gegen `origin/main` haelt statt den PR-Status. Der Einzeiler steht unten unter *How to apply* Punkt 2 und ist gemessen; er gehoert nach `tools/` und in `commit-bereit.pl`, was dieser Lauf nicht anfassen durfte. Bis dahin ist die Luecke hier gezaehlt statt vergessen.

# „Gemergt" heisst nicht „auf main"

**Regel.** Ein Zweig wird von dem Stand abgezweigt, auf den er zurueck soll.
Und nach dem Merge wird nicht der **Status** des Pull Requests gelesen,
sondern der **Inhalt** von `origin/main`. Der Status ist eine Behauptung der
Oberflaeche ([[anzeige-ist-kein-zustand]]); der Inhalt ist der Zustand.

## Was passiert ist (22.10.2026, vormittags)

Zwei Arbeitspakete, zwei Pull Requests. Paket B wurde auf den Zweig von
Paket A gesetzt statt auf `main`. Nachgemessen an den Eltern der
Merge-Commits:

| Zeit | PR | Merge-Commit | erster Elternteil | also gemergt **in** |
|---|---|---|---|---|
| 08:38 | **#134** (Paket A) | `b36598a3` | `d3ac3a95` | **main** |
| 08:39 | **#135** (Paket B) | `cd2fcc35` | `52ef99ba` | **den Zweig von #134**, nicht main |
| 08:52 | **#136** (derselbe Zweig nochmal) | `b6f83e3d` | `b36598a3` | **main** — erst jetzt kam Paket B an |

Dreizehn Minuten lang zeigte GitHub **beide** PRs als *merged*, und
`main` enthielt `65f29776` — die ganze Arbeit von Paket B — nicht. Gregor
meldete *„beide gemerged"*, weil genau das auf seinem Bildschirm stand.
Aufgefallen ist es erst, als ich den Inhalt von `main` las statt der
PR-Seite.

Der Schaden war diesmal klein, weil ein zweiter Merge desselben Zweigs ihn
geholt hat. Er ist in der Klasse nicht klein: ein Release, das in diesem
Fenster gebaut worden waere, haette Paket B nicht enthalten, und jede
Meldung nach aussen haette auf eine Datei verwiesen, die es auf `main` nicht
gab ([[verweis-erst-nach-dem-merge]]).

## Warum die benachbarten Lehren nicht gegriffen haben

- [[anzeige-ist-kein-zustand]] trifft den Kern — *„ein Oberflaechentext ist
  eine Behauptung des Programms ueber sich selbst"* —, ist aber ganz an
  **Eudora** geschrieben (E-83, drei Tage Suche nach einem Startproblem, das
  es nie gab). Dass GitHubs *merged*-Abzeichen dieselbe Sorte Behauptung ist,
  steht dort nirgends. Eine Lehre feuert nicht ueber einen Analogieschluss.
- [[review-sieht-nur-den-diff]] ist naeher dran, als es aussieht: der Diff
  von #135 war richtig. Falsch war die **Basis**, und die steht in keinem
  Diff. Die Lehre warnt vor der *unveraenderten Datei*, nicht vor dem
  unbeachteten Fusspunkt.
- [[zweigname-heisst-vorheriger-fertig]] verlangt vor einem neuen Zweignamen
  `git status` leer und gepusht. Beides war erfuellt. Was fehlte, war die
  Frage **wovon** abgezweigt wird.
- [[nie-direkt-auf-main]] regelt die Richtung, nicht den Ausgangspunkt.

## How to apply

1. **Vor `git checkout -b`: `git fetch origin && git checkout -b <name>
   origin/main`.** Der Ausgangspunkt wird genannt, nicht geerbt. Wer aus
   einem Arbeitszweig heraus abzweigt, bekommt dessen Commits mit in den PR
   und dessen Schicksal dazu.
2. **Nach jedem Merge den Inhalt pruefen, nicht die Seite.** Der Einzeiler,
   der den Fall vom 22.10. gezeigt haette:

   ```bash
   git fetch origin && git merge-base --is-ancestor <commit> origin/main \
     && echo "auf main" || echo "NICHT auf main"
   ```

   Gegen `65f29776` zwischen 08:39 und 08:52 haette er *NICHT auf main*
   gesagt, waehrend GitHub *merged* zeigte.
3. **Ein Arbeitspaket je Zweig, und das naechste erst nach dem Merge des
   vorigen.** Ist das nicht moeglich, wird die Abhaengigkeit im PR-Text
   genannt — und der zweite PR nach dem ersten gemergt, nicht parallel.
4. **Eine Meldung Gregors ueber einen Zustand ist eine Messung seiner
   Anzeige, nicht des Zustands.** *„beide gemerged"* war richtig
   beobachtet und falsch in der Sache. Solche Meldungen werden
   nachgemessen, nicht uebernommen.
5. **Vor dem Bauen eines Pakets einmal `git log --first-parent origin/main`
   lesen.** Fehlt dort ein Commit, den ich fuer geliefert halte, ist er es
   nicht.
