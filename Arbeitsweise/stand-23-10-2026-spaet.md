---
name: stand-23-10-2026-spaet
description: Stand beim Abschalten am 23.10.2026 spaet - PR 156 offen, BILDBREITE (E-116) mitten in der Arbeit abgebrochen, Regressionstest-Rueckstand ist der erste Schritt
metadata:
  type: project
---

Schranke: keine - ein Stand beim Abschalten laesst sich nicht pruefen, nur aufschreiben ([[abschalten-ist-ein-termin]]).

- **PR #156** (`lektor-53-und-pruefer-47`) war beim Abschalten fertig zum Mergen; ob Gregor gemergt hat, am Serverstand pruefen ([[gemergt-heisst-nicht-auf-main]]).
- **Erster Schritt der naechsten Sitzung:** der Rueckstand an Regressionstests (50 von 67 kritischen ohne Test), steht oben in `Intern/WEITERMACHEN.md`. Gregor: *"war anders vereinbart."* Keine neuen Themen davor.
- **BILDBREITE (E-116)** hat die Behebung als 6bce2a45 committet und gepusht (Zweig `e-116-bildbreite-px`), lief danach noch mit eigener Hintergrundarbeit; im Baum `Eudora7.2-wt-bildbreite` lagen uncommittet Aenderungen an CHANGELOG, BEFUNDE, WEITERMACHEN, ZIEL und Arbeitsweise. Vor dem Weitermachen seinen Bericht abwarten bzw. den Baum lesen, `agenten-laufen.pl --fertig BILDBREITE` erst danach.
- **Wartet auf Gregor:** Versionsvorschlag (eine Nummer ab 7.2.1.0, Zweig `version-7.2.1.0-eine-nummer`) und die Fragen in `Befunde/LEKTOR-53.md#fragen`.
- **Gregor 23.10.2026 spaet, auf LEKTOR-53 Frage 2 ("zaehlt behoben ohne seinen Test?"):** er fragte *"hast du es nachgestellt?"*. Antwort: E-69 nur gruen am Pruefstand (rote Seite nur am Quelltext), E-101 F1/F3/F4 nur Testsuite mit Gegenprobe, Adressbuch-Taste Strg+Umschalt+, gar nicht. Vereinbart: **in der naechsten Sitzung** als Teil des Regressionstest-Rueckstands alle drei am Pruefstand rot UND gruen nachstellen und als Regressionsfall einbauen; danach zaehlen sie als erfuellt ohne Gregors Test. In `Intern/WEITERMACHEN.md` nachtragen (stand beim Abschalten nur hier).
