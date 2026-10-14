---
name: commit-auf-einmal-pruefen
description: "Vor dem ersten Commit nach einem Versionssprung oder Urteilswechsel alle Schranken auf einmal fahren (tools/commit-bereit.pl) - der Haken zeigt je Anlauf nur den ersten Mangel"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T09:45:00.000Z
---

Am 13.10.2026 hat der `pre-commit` neun Commit-Anläufe in zwei Serien abgewiesen, jeden wegen eines **anderen** Mangels. Auf `mailadressen-raus` (08:46–08:49 UTC): E-103 in WEITERMACHEN als „behoben" bei offenem Befund, eine Kennung ohne Link, der Zweig fehlte in `tools/ZWEIGE.md` (pre-push), noch eine Kennung ohne Link. Beim Versionssprung auf 7.2.0.85 (08:57–08:59): Stand-Zeilen in AUFGABEN und PAKETE, dreimal der Testplan-Kopf, zuletzt der fehlende Abschnitt 1.0.85 in `Releases/PAKETE.md`. In genau dieser Viertelstunde schrieb Gregor *„viel bla, bla, wenig fortschritt"*.

**Why:** Der Haken fährt seine 28 Schranken mit `|| exit $?` nacheinander und steigt bei der ersten aus. Wer fünf Mängel hat, braucht fünf Anläufe und sieht nie, was noch kommt. Dieselbe Fehlerklasse hatte am 13.09.2026 `paket-bauen.ps1` (vier Anläufe, Gregor: *„noch keine funktionierende tool chain"*); gelöst wurde sie damals nur für das Paket (`tools/paket-bereit.pl`), nicht für den Commit. Jede Abweisung war inhaltlich richtig - falsch war die Form.

**How to apply:** Vor dem ersten Commit, nachdem `VERSION`/`Version.h` hochgezählt, ein Befundurteil geändert oder ein Zweig angelegt wurde: `perl tools/commit-bereit.pl` (mit `-push` auch die Schranken des pre-push), alle Mängel in **einem** Zug beheben, dann committen. Weist der Haken trotzdem ab, nicht den nächsten Einzelversuch fahren, sondern `commit-bereit.pl` - der Haken nennt es seit diesem Lauf bei jeder Abweisung. Beim Versionssprung gehören erfahrungsgemäß dazu: README, WEITERMACHEN, AUFGABEN-Stand, PAKETE-Stand **und** Abschnitt, TESTPLAN-Kopf, CHANGELOG. Verwandt: [[fehlerklassen-abstellen]], [[pruefumfang-nicht-von-hand]], [[doku-parallel-nicht-hinterher]].

Schranke: tools/commit-bereit.pl - liest seine Liste aus tools/hooks-einrichten.sh; der Haken nennt es bei jeder Abweisung (wirkt erst nach `sh tools/hooks-einrichten.sh`). Gegenprobe 13.10.2026: heutiger Stand 28 Schranken grün, Rückgabe 0; mit VERSION 1.0.86 vier Schranken rot in einem Lauf, Rückgabe 1.
