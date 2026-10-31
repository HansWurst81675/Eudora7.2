---
name: stand-31-10-2026-abend
description: "Stand 31.10.2026 ~20:50 - Zweig e140-speichern-zeichensatz: E-140, E-139, E-171 behoben+gemessen; E-165 und E-136 im Quellstand, offen; E-138 erledigt durch Doku; E-177 neu; LEKTOR-108 laeuft, dann PR; Ende 21:40"
metadata:
  node_type: memory
  type: project
  originSessionId: 473878d1-638a-4825-8932-03b1fabf688f
  modified: 2026-10-31T19:49:10.609Z
---

Schranke: keine - Stand-Vermerk; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt.

Gregor am 31.10.2026: Abschalten 22:00 -> Ende 21:40 ([[abschalten-ist-ein-termin]]). Pruefstand mit Fenster erlaubt ([[entscheidung-pruefstand-fenster-31-10]]). Gregor: die heutigen Behebungen sind Schoenheitsfehler, kommen mit dem naechsten regulaeren Paket, kein Sonderbau.

**Zweig `e140-speichern-zeichensatz`** (Gregor gewaehlt), Stand `33e7a52d`, Tests 350/350:
- E-140 behoben (Speichern unter mit Zeichensatz), Fall E-140p gruen.
- E-139 behoben (Rechtschreibhinweis mit Kaestchen, WarnSpellUnavailable), Fall E-139p gruen.
- E-171 behoben (Suche ohne Suchtext startet nicht), Fall E-171p gruen.
- E-165 Behebung im Quellstand (Box-Hoehe aus Zeile+Rahmen), mit zwei Treffern gemessen; bleibt OFFEN bis Gregors Blick (ein Treffer in der VM nicht nachstellbar).
- E-136 (Emoji -> ?? beim Strg-S) Ursache: `CString = BSTR` in TridentReadMessageView::SaveInfo und CTridentView::GetAllHTML; Behebung E136HtmlAusBstr (Entitaeten), Funktionstest mit Gegenprobe rot "??". Am Programm NICHT nachgestellt: messen-e136.ps1 erreicht SaveInfo nicht (gespeichert=0, auch nach ID_EDIT_MESSAGE + WM_CHAR). Bleibt OFFEN; TESTPLAN e-136-naechstes fuer Gregor.
- E-138 erledigt durch Doku ([[entscheidung-e138-erledigt-durch-doku]]); E-177 neu (Rest aus E-140, Filteraktion).

**Laeuft:** LEKTOR-108 (wt/lektor-20261031c) bis 21:05. Danach: `git merge origin/wt/lektor-20261031c`, `perl tools/agenten-laufen.pl --fertig LEKTOR`, PR (`gh pr create`), KEINE Doku-Aenderung dazwischen (jede Einarbeitung macht LEKTOR wieder faellig - Schleife; Funde aus LEKTOR-108 in den naechsten Zweig).

**Offen:** PRUEFER und CHRONIST faellig. Gregors Frage zur Suche in einer Mail (Blah Blah Blah + Find Text) beantwortet aus Menue/Ressource, nicht gemessen; Messung angeboten.
