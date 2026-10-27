---
name: stand-26-10-2026-nacht
description: "26.10. 22:45 — 9 Dateien UNGESICHERT im Hauptbaum (E-137 vierter Anlauf, E-160), Zweig 0.123_ergebnisse gemergt; zuerst Zweignamen 0.125_ergebnisse von Gregor bestätigen lassen"
metadata:
  node_type: memory
  type: project
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-26T21:25:56.181Z
---

Stand 26.10.2026, 22:45, Gregor fuhr herunter ("fahre jetzt runter - alles sichern").

**Ungesichert im Hauptbaum** (Zweig `0.123_ergebnisse`, der ist mit PR #178 gemergt; `pruefe-branch.pl` weist dort jeden Commit ab):
workbook.cpp/.h (E-137 vierter Anlauf: `FokusInDieLeiste`, `OnNcLButtonDown`, Spurzeile vor jeder Entscheidung), OLImportClass.cpp (E-160: ohne Outlook-Registry kein MAPI), TestE137.cpp, TestE160.cpp (neu), TestMain.cpp, Tests.vcxproj, Intern/BEFUNDE.md (E-160 neu, E-137 Nachtrag), Intern/TESTPLAN.md (U1 nein). Bau 0 Fehler, 313/313; E-160-Test einmal rot ohne Fix.
Kopie als Patch: scratchpad dieser Sitzung `e137b/ungesichert-2026-10-26.patch` (85 KB).

**Why:** Kein neuer Zweig ohne Gregors Ja zum Namen; vorgeschlagen war `0.125_ergebnisse`, er hat nicht darauf geantwortet.

**How to apply:** Morgen als Erstes Gregor nach dem Zweignamen fragen, dann `git switch -c <name>` (Änderungen wandern mit), committen, pushen. Danach: E-119 an 1.0.125 als bestanden nachtragen (*„E-119, T2 PASSED“*), Fassung 7.2.0.126, Bau, Prüfstand, Paket, Kurztest (U1–U3 neu, E-160 *Persona → Neu*), LEKTOR, PR. Gregor testet U2–U4 an 1.0.125 morgen. Siehe [[zweig-vorher-abstimmen]].

Schranke: keine - ein Stand-Vermerk, keine Lehre; überholt, sobald die Dateien auf dem Server sind.
