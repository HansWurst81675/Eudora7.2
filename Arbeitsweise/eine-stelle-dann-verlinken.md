---
name: eine-stelle-dann-verlinken
description: "Gregor 26.10.2026 - jede Information in den MD-Dateien nur an EINER Stelle, andere MDs verlinken dorthin; keine Widersprueche"
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-29T20:38:06.143Z
---

Gregor am 26.10.2026, nachdem die Schranke pruefe-befund-verbreitung.pl beim Fassungssprung auf 7.2.0.123 dreizehn "schweigende" Stellen meldete und ich dieselbe Aufzaehlung (E-137, E-142, E-146, E-154 ...) in README, ZIEL, AUFGABEN und CHANGELOG nachgetragen hatte:

*"ja, die infos in den MD dateien sollen alle konsistent sein und sich nicht widersprechen. am besten nur an einer stelle, fall notwenidg, von anderen MDs verlinken."*

**Why:** Jede Kopie ist eine Stelle, die beim naechsten Stand veraltet. LEKTOR-69 fand vier "falsch"-Funde, die alle aus einer zweiten Fassung desselben Sachverhalts kamen (README-Einleitung gegen E-142-Zeile, ZIEL 2a gegen ZIEL Zeile 67, CHANGELOG-Ueberschrift gegen origin/main). Verwandt: [[liste-aus-einer-quelle]], [[doku-parallel-nicht-hinterher]], [[einigkeit-ist-kein-beweis]].

**How to apply:**
- Vor jedem Nachtrag fragen: wo ist die EINE Stelle fuer diese Aussage? Urteil eines Befunds -> Intern/BEFUNDE.md; Inhalt einer Fassung -> CHANGELOG.md; Anwender-Wissen und bekannte Fehler -> README.md; Massstab -> ZIEL.md; Gregors Pruefschritte und Ergebnisse -> Intern/TESTPLAN.md; Pakete -> Releases/PAKETE.md. Ueberall sonst nur ein Satz mit Link.
- Schranken, die "nennt E-nnn nicht" melden (pruefe-befund-verbreitung.pl), mit einem Verweis bedienen, nicht mit einer weiteren Beschreibung. Wenn eine Schranke Kopien erzwingt, die Schranke umbauen.
- Offen (nach dem Testpaket 7.2.0.123): die Doppelungen vom 26.10. (Aufzaehlung in README "Neu im Testpaket", ZIEL-Zeilen, AUFGABEN-Stand, CHANGELOG-Ueberschrift) auf Verweise auf CHANGELOG 7.2.0.123 zurueckbauen.

Schranke: keine - eine Pruefung auf doppelte Beschreibungen desselben Sachverhalts gibt es noch nicht; Ausloeser ist jeder Nachtrag, den pruefe-befund-verbreitung.pl verlangt.

## Nachtrag 29.10.2026 abends (CHRONIST): die Liste für „nach dem Release“ stand an vier Orten

Gregor fragte um 21:09:53 MEZ, wo die Aufgaben für die Zeit nach dem Release stehen (*„in weitermachen.md?“*). Die Antwort um 21:10:13 (gemessen an `052dc212-…jsonl`): an drei Stellen in `Intern/WEITERMACHEN.md` (Tabelle „Alles Offene“ mit E-169 bis E-173, Entscheidung 16 in Zeile 137, „Offene Arbeiten ohne Befundnummer“ ab Zeile 424 mit Stand 12.10.), und ein Punkt, die Übersicht „Was Eudora kann“, **nur im Gedächtnis**. Gregor um 21:12:06:

> *„wichtig ist, daß es nicht wieder überall etwas verstreut ist. wie soll jemand, der nach dem release fortsetzen möchte, hier durchblicken, ohne alles lesen zu müssen?“*

Vereinbart (21:14:17, 21:14:53, 21:15:54): ein eigener PR nach dem Merge von `release-7.2.1`. Alles bis 7.2.0.x geht in eine Archivdatei, *„dann wirkt es aufgeräumt. wie nach einem sprint review und retrospection, dann kommt eine neue user story“*. Das neue `WEITERMACHEN.md` hat einen kurzen Kopf, **eine** Liste „Nach dem Release 7.2.1“ mit Link je Zeile und oben einen Link auf das Archiv. Die Befundzeilen der Liste erzeugt `offene-befunde.pl` ([[liste-aus-einer-quelle]]). Der Plan steht in `memory/stand-29-10-2026.md`, Nachträge 21:15 und 21:25.

**Neu gegenüber dem 26.10.:** Dort ging es um denselben Sachverhalt in mehreren Dateien. Hier lag er in **einer** Datei mit 548 Zeilen an drei Stellen. Der Leser muss trotzdem alles lesen. „Eine Stelle“ heißt also auch: eine Stelle **innerhalb** der Datei, und sie steht oben.

**How to apply, zusätzlich:** Eine Aufgabe für später kommt in die eine Liste oder gar nicht ins Repo. Eine Vereinbarung, die „nur im Gedächtnis“ steht, wird beim nächsten Commit dort eingetragen, nicht erst nach dem Merge.

**Schranke (vereinbart, gebaut am 30.10.2026 als `tools/pruefe-nach-dem-release.pl`, Commit `9369fb63`):** Der Commit-Haken weist eine „nach dem Release“-Aufgabe außerhalb der Liste ab (Vorschlag 21:12:19, von Gregor mit dem Plan angenommen). Gegenprobe beim Bau: eine Zeile „nach dem Release“ in der alten Tabelle „Offene Arbeiten ohne Befundnummer“ muss abgewiesen werden, dieselbe Zeile in der neuen Liste muss durchgehen.
