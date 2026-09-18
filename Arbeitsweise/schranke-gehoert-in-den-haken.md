---
name: schranke-gehoert-in-den-haken
description: "Eine Schranke, die nur läuft wenn ich daran denke, ist keine Schranke; und eine, die zu oft umsonst warnt, wird entwaffnet"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-18T07:35:33.513Z
---

Schranke: tools/lehren-schranken.pl (pre-commit) haelt jede Lehre gegen ihre Aufrufstelle; die Verdrahtung der Schranken selbst prueft niemand - gemessen am 18.09.2026 hingen 4 von 6 Doku-Schranken in keinem Haken, und release-pruefen.pl hing mit "|| true"

Eine Prüfung, die nicht in `.git/hooks/pre-commit` **oder** `pre-push` steht,
läuft nur, wenn ich daran denke — und genau dann, wenn es darauf ankommt, denke
ich nicht daran.

Gregor am 18.09.2026, nachdem er den Zweig zu `v1.0.72` gemergt hatte und ich
die fehlenden Dokumente **danach** auf einem nicht vereinbarten Zweig
nachschieben wollte:

> *„repareire deine schranken, so daß VOR dem commit und merge alles auf github
> vorhanden ist. […] keine lügen auf dem main."*

**Nachgemessen war die Ursache nicht Nachlässigkeit, sondern Verdrahtung.**
`pruefe-befund-verbreitung.pl`, `pruefe-stand-md.pl`, `pruefe-doku-takt.pl` und
`offene-befunde.pl` hingen in **keinem** Haken. Alle vier waren gebaut, getestet
und gut — und liefen zum Commit-Zeitpunkt nicht. Folge: fünf führende Dokumente
nannten nach dem Release weiterhin `v1.0.64`.

**Die zweite Hälfte ist die wichtigere.** `release-pruefen.pl` hing im Haken,
aber als `perl … || perl … || true` — es konnte nie abweisen. Der Grund stand
nicht im Haken, sondern im Werkzeug: es gab auch für einen bloßen **Hinweis**
den Wert 1 zurück und war deshalb dauernd rot. Jemand (ich) hat es daraufhin
entwaffnet, statt die Ursache zu beheben.

**Also, in dieser Reihenfolge:**

1. Neue Prüfung **sofort** in den Haken, mit `|| exit $?`. Sonst ist sie ein
   Aufsatz, kein Riegel.
2. Prüfung braucht **getrennte Rückgabewerte**: `0` in Ordnung, `1` abweisen,
   ein eigener Wert für „nur ein Hinweis". Eine Prüfung, die für Hinweise
   abweist, wird binnen Tagen umgangen.
3. Wird eine Schranke lästig, **an den Kosten ansetzen, nicht am Prüfumfang**.
   Der naheliegende Schnitt — „nur prüfen, was der Commit anfasst" — ist genau
   das `if`, das am 07.09.2026 entfernt wurde: eine veraltete Datei, die niemand
   anfasst, steht in keinem Diff (siehe [[review-sieht-nur-den-diff]]).

Gregor hat die Laufzeit danach ausdrücklich angenommen: *„pre commit mit 22sek
ist akzeptabel."* Die Entscheidung ist in `Befunde/PRUEFER-17.md` festgehalten,
damit sie niemand erneut aufmacht.

Verwandt: [[lehren-anwenden-nicht-nur-schreiben]], [[werkzeug-vor-eigenbau]],
[[fehlerklassen-abstellen]], [[schranke-gegentesten]], [[fertig-heisst-fertig]].
