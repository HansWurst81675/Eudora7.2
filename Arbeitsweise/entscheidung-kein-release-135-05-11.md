---
name: entscheidung-kein-release-135-05-11
description: Gregor 05.11.2026: 7.2.2.135 nicht auf GitHub; nur solide, getestete Bauten veröffentlichen – nächstes Release frühestens 7.2.2.136 mit E-239-Behebung
metadata:
  type: project
---
Schranke: keine - Entscheidung zu einem einzelnen Release; geprüft vor jedem Aufruf von release-veroeffentlichen.ps1 durch die Frage nach offenen kritischen Befunden.

Auf die Frage, ob v7.2.2.135 (von Gregor vollständig getestet, E-239 offen) heute als Release auf GitHub soll: *„nein, eilt nicht. es sollten nur solide builds und getestete ergebnisse auf github.“*

**Why:** Ein Release mit offenem kritischem Befund (Absturz, Datenverlust nicht ausgeschlossen) ist nicht „solide“, auch wenn der Fehler schon in der Vorfassung steckte.
**How to apply:** Kein Release mit offenem kritischem Befund vorschlagen, ohne dass er behoben oder sein Ausschluss gemessen ist; nächster Kandidat 7.2.2.136 (E-239, E-169) nach Gregors Test. Siehe [[entscheidung-e188-release-7-2-2-132]], [[kein-paket-mit-offenem-datenverlust]].
