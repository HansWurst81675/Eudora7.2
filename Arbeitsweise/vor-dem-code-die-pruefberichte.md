---
name: vor-dem-code-die-pruefberichte
description: Vor der ersten Zeile an einer Stelle nachsehen, wer sie schon geprueft hat - befund-suchen.pl sieht nur 182 von 591 Kennungen, die Antwort auf E-101 lag in den uebrigen
metadata:
  type: feedback
---

Schranke: keine - noch zu bauen: tools/befund-suchen.pl --alles (Befunde/ mitlesen) und ein meldender Hinweis im pre-commit, der zu jeder vorgemerkten Quelldatei die Pruefberichte nennt, die sie beim Namen nennen. Spezifikation in Befunde/CHRONIST-2026-10-19.md

Bevor eine Quelldatei geändert wird, wird gefragt: **wer hat diese Stelle
schon geprüft?** — und zwar über `BEFUNDE.md` **und** `Befunde/*.md`. Ein
Prüfbericht ist Bestand, nicht Archiv.

**Why:** Am 17.10.2026 habe ich in `msgutils.cpp` 225 Zeilen geschrieben,
deren Kern auf dem einzigen Aufrufweg tot ist — `StripTabooHeaders` entfernt
`Content-Type` vorher, gemessen in 72 von 72 Nachrichten. Begründung und
fertiger Ersatztext standen seit dem 17.09.2026 **zweimal** im Repo (P-23 in
PRUEFER-13, P-33 in PRUEFER-14). Zwei Gründe, warum die bestehende Regel nicht
griff, beide mechanisch: der Auslöser in `CLAUDE.md` feuert *„vor jedem neuen
Befund"* — ich habe aber Code geschrieben, keinen Befund angelegt; und
`befund-suchen.pl` liest nur `BEFUNDE.md`, also 182 von 591 Kennungen.
`perl tools/befund-suchen.pl StripTabooHeaders` meldet E-80 und sonst nichts.

**How to apply:** Vor der ersten Zeile an einer Stelle quer durch `Befunde/`
nach Dateiname **und** Funktionsname suchen (`grep -rl` reicht, solange
`befund-suchen.pl --alles` nicht gebaut ist). Ein Lauf über `msgutils.cpp`,
`Content-Type` und `StripTabooHeaders` hätte PRUEFER-13 und PRUEFER-14
genannt, bevor die erste Zeile stand. Siehe [[bestand-vor-neuer-suche]],
[[quelle-muss-im-bau-stehen]], [[werkzeug-vor-eigenbau]].
