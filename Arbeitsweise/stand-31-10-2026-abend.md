---
name: stand-31-10-2026-abend
description: "Stand 31.10.2026 21:05 - #192 gemergt (E-140, E-139, E-171 behoben; E-165, E-136 im Quellstand offen); Zweig e136_messweg (Gregor ok) gepusht bei 3d4df61a, kein PR; naechstes Mal: E-136-Messweg ueber Stingray-Leiste, PRUEFER und CHRONIST faellig"
metadata:
  node_type: memory
  type: project
  originSessionId: 473878d1-638a-4825-8932-03b1fabf688f
  modified: 2026-10-31T20:03:05.720Z
---

Schranke: keine - Stand-Vermerk; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt.

Gregor am 31.10.2026: heutige Behebungen sind Schoenheitsfehler, kommen mit dem naechsten regulaeren Paket, kein Sonderbau.

**Gemergt: #192** (main `5869d718`) - E-140, E-139, E-171 behoben und am Programm gemessen (Faelle E-139p, E-140p, E-171p gruen); E-165 und E-136 Behebung im Quellstand, Befunde OFFEN; E-138 erledigt durch Doku ([[entscheidung-e138-erledigt-durch-doku]]); E-177 neu. LEKTOR-106/107/108 eingearbeitet. Zweig `e140-speichern-zeichensatz` ist in main - Loeschen ist Gregors Sache.

**Zweig `e136_messweg`** (Gregor: *„e136_messweg als branch name ok“*), gepusht bei `3d4df61a`, KEIN PR bisher. Inhalt: L-108.1/L-108.2 eingearbeitet; Messweg-Erkenntnis in BEFUNDE E-136.

**E-136 Messweg - Stand:** Strg-S schreibt nur bei IsModified() (CMessageDoc::OnUpdateFileSave; MFC fuehrt gesperrte Befehle auch per Botschaft nicht aus). Bearbeiten-Modus haengt am Knopf ID_EDIT_MESSAGE (32996) der Stingray-Leiste "Read Message" (SECToolBarManager, theReadMessageButtons, zur Laufzeit gekuerzt, Klasse `Afx:...`, 535x24, keine TB_-Abfragen). Kein Kindfenster 32996. NICHT auf Verdacht klicken (Fehltreffer = Delete moeglich). Naechster Schritt: Knopflage aus CReadMessageToolBar/SEC-Quelle bestimmen, dann WM_LBUTTONDOWN/UP, dann ID_EDIT_TEXT_ITALIC (32884, setzt SetModifiedFlag), dann ID_FILE_SAVE (57603). Skript: tools/messen-e136.ps1 (Pruefstaende C:\Temp\E136 neu, C:\Temp\E136-alt mit 7.2.1.128).

**Faellig:** PRUEFER (Code seit ae3efe3, viel neu: AutoCompleteSearcher, TridentView, spell, guiutils, msgutils...) und CHRONIST. Ungetrackt im Hauptbaum: `.claude/settings - Kopie.json` (nicht meine; bauen.ps1 deshalb mit -Ungesichert).

**Offene Frage an Gregor:** Suche in einer geoeffneten Mail (Blah Blah Blah + Find Text nach x-persona) am Pruefstand nachmessen? - beantwortet aus Menue/Ressource, nicht gemessen.
