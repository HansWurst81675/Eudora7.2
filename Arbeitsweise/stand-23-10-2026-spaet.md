---
name: stand-23-10-2026-spaet
description: Stand beim Abschalten am 23.10.2026 spaet - PR 156 offen, BILDBREITE (E-116) mitten in der Arbeit abgebrochen, Regressionstest-Rueckstand ist der erste Schritt
metadata:
  type: project
---

Schranke: keine - ein Stand beim Abschalten laesst sich nicht pruefen, nur aufschreiben ([[abschalten-ist-ein-termin]]).

- **PR #156** (`lektor-53-und-pruefer-47`) war beim Abschalten fertig zum Mergen; ob Gregor gemergt hat, am Serverstand pruefen ([[gemergt-heisst-nicht-auf-main]]).
- **Erster Schritt der naechsten Sitzung:** der Rueckstand an Regressionstests (50 von 67 kritischen ohne Test), steht oben in `Intern/WEITERMACHEN.md`. Gregor: *"war anders vereinbart."* Keine neuen Themen davor.
- **BILDBREITE (E-116) fertig:** Zweig `e-116-bildbreite-px` auf 501bf0bd gepusht, KEIN PR angelegt (Gregor: Regressionstests zuerst). Behebung eingebaut, Testsuite 280/280, Gegentest beidseitig, Release-Bau 0 Fehler; am Programm nicht gesehen, in BEFUNDE "eingebaut", nicht "behoben". Beim Merge moeglicher Konflikt in der erzeugten Zeile E-116 in ZIEL.md/CHANGELOG.md. Nebenbefund: numeric_value (height) macht aus " 35" eine 0. bauen.ps1:1262 findet perl aus PowerShell nicht (Rueckgabe 1 trotz Erfolg).
- **Wartet auf Gregor:** Versionsvorschlag (eine Nummer ab 7.2.1.0, Zweig `version-7.2.1.0-eine-nummer`) und die Fragen in `Befunde/LEKTOR-53.md#fragen`.
- **Gregor 23.10.2026 spaet, auf LEKTOR-53 Frage 2 ("zaehlt behoben ohne seinen Test?"):** er fragte *"hast du es nachgestellt?"*. Antwort: E-69 nur gruen am Pruefstand (rote Seite nur am Quelltext), E-101 F1/F3/F4 nur Testsuite mit Gegenprobe, Adressbuch-Taste Strg+Umschalt+, gar nicht. Vereinbart: **in der naechsten Sitzung** als Teil des Regressionstest-Rueckstands alle drei am Pruefstand rot UND gruen nachstellen und als Regressionsfall einbauen; danach zaehlen sie als erfuellt ohne Gregors Test. In `Intern/WEITERMACHEN.md` nachtragen (stand beim Abschalten nur hier).
- **Gregor 23.10.2026 spaet, Adressbuch-Taste:** *"die Adressbuch-Taste Strg+Umschalt+, damit kann ich gut leben, also hier nichts mehr zu tun. markiere als erledigt."* -> ZIEL.md Zeile "Adressbuch benutzbar" auf erledigt setzen (auch die vorher verlangte Doku in README entfaellt damit), LEKTOR-53 Frage 2 fuer diesen Punkt beantwortet; aus der Nachstell-Liste der naechsten Sitzung streichen. Noch NICHT im Repo (braucht Zweig).
- **AN-1:** Gregor *"am prüfstand nachstellen, wenn es schnell geht."* Ergebnis meiner Pruefung: nicht schnell - tools/imap-pruefserver.pl kann kein BODYSTRUCTURE, der IMAP-Anhangweg braucht es. Gregor gefragt, ob es trotzdem gemacht werden soll.
- **AN-1 entschieden:** Gregor *"AN-1 aufschreiben, jetzt nicht."* -> in der naechsten Sitzung im Regressionstest-Block: Pruefserver um BODYSTRUCTURE erweitern, Pruefnachricht mit Anhang ohne Endung, rot/gruen nachstellen, zwei SetExtension-Aufrufe in ImapDownload.cpp (:3728, :4119).
