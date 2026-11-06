---
name: entscheidung-release-7-2-2-136-06-11
description: Gregor 06.11.2026 „ja zum release“ für 7.2.2.136 – gilt unter der Bedingung voller Prüfstandslauf + E-239-Messungen grün; bei Rot neu fragen
metadata:
  node_type: memory
  type: project
  originSessionId: 8e921d9a-b658-4cfb-9fea-ce8200ddbb4c
  modified: 2026-11-06T10:27:08.517Z
---
Schranke: tools/release-veroeffentlichen.ps1 verlangt -Freigabe und die Bestaetigung im CHANGELOG; ob die Bedingungen (Pruefstand gruen) erfuellt sind, prueft es nicht.

Gregor am 06.11.2026 nach seinem Test (Schritte 1,2,3,5,6 bestanden): *„ja zum release“*. Freigabetext für `release-veroeffentlichen.ps1 -Freigabe`: `Gregor am 06.11.2026: 'ja zum release'`.

Angesagt war vorher: Release nur, wenn (1) voller Prüfstandslauf an 7.2.2.136 grün, (2) E-239-Messungen (einfach/syscmd/hinweis-exit, je mit/ohne Post) grün, (3) kein nach der Freigabe neu gemessener Datenverlust ([[entscheidung-e188-release-7-2-2-132]]).

**Why:** Ein Ja gilt für den Stand, den Gregor kannte ([[erlaubnis-nicht-hineinlesen]]).

**How to apply:** Ist etwas rot oder kommt ein Verlust dazu: erst fragen, nicht veröffentlichen. Release-Text: E-242 (Anmeldename im Pfad auf Ausdrucken, Originalverhalten) als bekannte Einschränkung nennen – so angekündigt, Gregor hat nicht widersprochen. CHANGELOG-Abschnitt 7.2.2.136 braucht die Bestätigung, sonst weist das Werkzeug ab.
