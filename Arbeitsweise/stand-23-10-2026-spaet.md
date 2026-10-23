---
name: stand-23-10-2026-spaet
description: Stand beim Abschalten am 23.10.2026 spaet - PR 156 offen, BILDBREITE (E-116) mitten in der Arbeit abgebrochen, Regressionstest-Rueckstand ist der erste Schritt
metadata:
  type: project
---

Schranke: keine - ein Stand beim Abschalten laesst sich nicht pruefen, nur aufschreiben ([[abschalten-ist-ein-termin]]).

- **PR #156** (`lektor-53-und-pruefer-47`) war beim Abschalten fertig zum Mergen; ob Gregor gemergt hat, am Serverstand pruefen ([[gemergt-heisst-nicht-auf-main]]).
- **Erster Schritt der naechsten Sitzung:** der Rueckstand an Regressionstests (50 von 67 kritischen ohne Test), steht oben in `Intern/WEITERMACHEN.md`. Gregor: *"war anders vereinbart."* Keine neuen Themen davor.
- **BILDBREITE (E-116)** lief beim Abschalten noch und ist damit abgebrochen. Arbeitsbaum `C:\Users\Gregor\Documents\github\Eudora7.2-wt-bildbreite`, Zweig `e-116-bildbreite-px` (gepusht nur der ZWEIGE-Commit 66ec9cc5). Ungesichert auf der Platte: `Eudora71/Tests/TestE116.cpp`, `UnderTestE116.cpp/.h`, Aenderungen an `Extract.ps1`, `TestMain.cpp`, `Tests.vcxproj`. Ob `PGHTMIMP.CPP` schon geaendert war: nein (nicht in git status). Vor dem Weitermachen Bytes von Tests.vcxproj gegen HEAD messen. `perl tools/agenten-laufen.pl --fertig BILDBREITE` erst nach Klaerung.
- **Wartet auf Gregor:** Versionsvorschlag (eine Nummer ab 7.2.1.0, Zweig `version-7.2.1.0-eine-nummer`) und die Fragen in `Befunde/LEKTOR-53.md#fragen`.
