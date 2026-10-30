---
name: keine-unverstaendlichen-abfragen
description: "Gregor 30.10.2026 - keine Freigabe-Abfragen fuer Skripte oder Befehle, die er nicht nachvollziehen kann; er lehnt sie ab. Lesen/Suchen/Aendern mit Read, Grep, Edit statt Perl-Einzeilern"
metadata:
  node_type: memory
  type: feedback
  originSessionId: c21b8f54-4b4e-486c-b533-f8d1c2356772
  modified: 2026-10-30T07:27:27.778Z
---

Schranke: keine - ob ein Befehl eine Abfrage ausloest, entscheidet die Rechtepruefung, nicht ein Werkzeug von mir.

Gregor am 30.10.2026, nachdem er zwei Abfragen hintereinander abgelehnt hatte (Perl-Hilfsskripte ins Scratchpad und ein Perl-Einzeiler zum Messen von Zeilenenden): *„ich möchte keine abfrage von irgendwelchen skripten oder befehlen, die ich nicht verstehe und nachvollziehen kann, klar? ich werde sie einfach ablehnen!“* Davor: *„was zeigst du mir denn für pearl skripte mit der frage, ob ich damit fortfahren möchte? was soll ich damit?“*

**Why:** Eine Abfrage ist eine Bitte an Gregor, etwas zu pruefen. Ein Perl-Einzeiler mit Regex, Heredocs und Variablen ist fuer ihn nicht pruefbar; die Abfrage zwingt ihn, blind zu bestaetigen oder abzulehnen. Ausloeser am 30.10.: Arbeit in einem zweiten Arbeitsbaum ausserhalb des Projektverzeichnisses und verschachtelte Shell-Befehle.

**How to apply:**
- Lesen mit Read, Suchen mit Grep/Glob, Aendern von UTF-8-Dateien mit Edit. Shell nur fuer einfache, lesbare Befehle (git, ein Werkzeug aus tools/ mit Namen).
- Nur im Projektverzeichnis arbeiten; keine eigenen Arbeitsbaeume ausserhalb davon.
- Latin-1-Quellen (Eudora71/) brauchen weiter Perl ([[quelldateien-nur-byte-erhaltend-aendern]]): dann vorher in einem Satz sagen, was der Befehl tut und welche Datei er aendert, und ein festes Werkzeug unter tools/ statt eines Einzeilers benutzen.
- Wird eine Abfrage abgelehnt: nicht in anderer Form wiederholen ([[abweisung-ist-eine-antwort]]).
