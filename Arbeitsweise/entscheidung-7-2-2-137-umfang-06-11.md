---
name: entscheidung-7-2-2-137-umfang-06-11
description: "Gregor 06.11.2026: 7.2.2.137 = E-242 (Anmeldename auf Ausdrucken) + E-240 (Sanduhr erste Druckvorschau) sicher, E-241 (Bild auf/ab in Vorschau) nur wenn Ursache klar; Beginn erst nach E-151"
metadata:
  node_type: memory
  type: project
  originSessionId: 8e921d9a-b658-4cfb-9fea-ce8200ddbb4c
  modified: 2026-11-06T14:43:07.125Z
---

Schranke: keine - Umfang-Entscheidung; nachzutragen als Entscheidung 40 in Intern/WEITERMACHEN.md, wenn der Zweig für 7.2.2.137 angelegt wird.

Gregor am 06.11.2026 auf meinen Vorschlag (E-242 und E-240 sicher, E-241 nur wenn sich die Ursache findet): *„ja, 2.137 so, nach e151“*.

**Why:** E-240 hatte er auf „nach dem Release“ gelegt ([[entscheidung-e240-nach-release-06-11]]); E-242 (Windows-Anmeldename im Pfad auf jedem Ausdruck) ist „wichtig“.

**How to apply:** Erst E-151 (Prüfstand nach frischem Klon) bis zum PR fertig. Dann Zweignamen bei Gregor erfragen (z. B. `e242_e240_druckvorschau`, Sammelzweig `paket_7_2_2_137`) – kein Zweig ohne sein Ja. Testplan-Schritte vorher selbst am Prüfstand fahren und `perl tools/testplan-voraussetzungen.pl --ini <sein ZIP>` ([[erst-pruefen-dann-anweisen]]). Kürzel im Chat immer mit Klartext ([[kuerzel-im-chat-uebersetzen]]).
