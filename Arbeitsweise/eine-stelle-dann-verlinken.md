---
name: eine-stelle-dann-verlinken
description: "Gregor 26.10.2026 - jede Information in den MD-Dateien nur an EINER Stelle, andere MDs verlinken dorthin; keine Widersprueche"
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-26T07:50:07.406Z
---

Gregor am 26.10.2026, nachdem die Schranke pruefe-befund-verbreitung.pl beim Fassungssprung auf 7.2.0.123 dreizehn "schweigende" Stellen meldete und ich dieselbe Aufzaehlung (E-137, E-142, E-146, E-154 ...) in README, ZIEL, AUFGABEN und CHANGELOG nachgetragen hatte:

*"ja, die infos in den MD dateien sollen alle konsistent sein und sich nicht widersprechen. am besten nur an einer stelle, fall notwenidg, von anderen MDs verlinken."*

**Why:** Jede Kopie ist eine Stelle, die beim naechsten Stand veraltet. LEKTOR-69 fand vier "falsch"-Funde, die alle aus einer zweiten Fassung desselben Sachverhalts kamen (README-Einleitung gegen E-142-Zeile, ZIEL 2a gegen ZIEL Zeile 67, CHANGELOG-Ueberschrift gegen origin/main). Verwandt: [[liste-aus-einer-quelle]], [[doku-parallel-nicht-hinterher]], [[einigkeit-ist-kein-beweis]].

**How to apply:**
- Vor jedem Nachtrag fragen: wo ist die EINE Stelle fuer diese Aussage? Urteil eines Befunds -> Intern/BEFUNDE.md; Inhalt einer Fassung -> CHANGELOG.md; Anwender-Wissen und bekannte Fehler -> README.md; Massstab -> ZIEL.md; Gregors Pruefschritte und Ergebnisse -> Intern/TESTPLAN.md; Pakete -> Releases/PAKETE.md. Ueberall sonst nur ein Satz mit Link.
- Schranken, die "nennt E-nnn nicht" melden (pruefe-befund-verbreitung.pl), mit einem Verweis bedienen, nicht mit einer weiteren Beschreibung. Wenn eine Schranke Kopien erzwingt, die Schranke umbauen.
- Offen (nach dem Testpaket 7.2.0.123): die Doppelungen vom 26.10. (Aufzaehlung in README "Neu im Testpaket", ZIEL-Zeilen, AUFGABEN-Stand, CHANGELOG-Ueberschrift) auf Verweise auf CHANGELOG 7.2.0.123 zurueckbauen.

Schranke: keine - eine Pruefung auf doppelte Beschreibungen desselben Sachverhalts gibt es noch nicht; Ausloeser ist jeder Nachtrag, den pruefe-befund-verbreitung.pl verlangt.
