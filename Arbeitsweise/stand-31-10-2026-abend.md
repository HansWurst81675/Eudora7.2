---
name: stand-31-10-2026-abend
description: "Stand 31.10.2026 ~20:15 - Zweig e140-speichern-zeichensatz (Gregor gewaehlt): E-140 und E-139 behoben+gemessen, LEKTOR-106 laeuft; danach PR; Ende heute 21:40 (Gregor: 22:00)"
metadata:
  node_type: memory
  type: project
  originSessionId: 473878d1-638a-4825-8932-03b1fabf688f
  modified: 2026-10-31T19:11:22.481Z
---

Schranke: keine - Stand-Vermerk; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt.

Gregor am 31.10.2026: Abschalten 22:00 -> Ende 21:40 ([[abschalten-ist-ein-termin]]). Pruefstand mit Fenster erlaubt ([[entscheidung-pruefstand-fenster-31-10]]).

**Zweig `e140-speichern-zeichensatz`** (Gregor per Dialog gewaehlt, in tools/ZWEIGE.md), von origin/main (#191 gemergt):
- `eb65fd94` E-140 behoben: E140TextFuerDatei (msgutils.cpp) in ReadMessageDoc/compmsgd SaveAsFile; TestE140.cpp; Fall E-140p (zeichensatz=3); 7.2.1.128 -> zeichensatz=1.
- `a5e2f173` E-139 behoben: spell.cpp NoteDialog + WarnSpellUnavailable (11152) + IDS_SPELL_NICHT_VORHANDEN (8118); TestE139.cpp; Fall E-139p; messen-e139.ps1 zwei Laeufe; Gegenprobe C:\Temp\E139-alt (7.2.1.128) rot.
- Tests 346/346. TESTPLAN-Abschnitte e-139-naechstes, e-140-naechstes.

**Laeuft:** LEKTOR-106 im Baum `.wt/lektor` (wt/lektor-20261031), bis 21:15. Danach: Funde einarbeiten, `perl tools/agenten-laufen.pl --fertig LEKTOR`, `gh pr create`. Doku bis dahin NICHT aendern (macht LEKTOR wieder faellig).

**Offen:** PRUEFER und CHRONIST faellig. Bauen.ps1 braucht -Ungesichert, weil `.claude/settings - Kopie.json` (nicht meine Datei) ungetrackt liegt. Naechste Behebungen laut Absprache: E-165, E-141 messen, E-138.
