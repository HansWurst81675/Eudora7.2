---
name: kein-paket-mit-offenem-datenverlust
description: "Kein Paket ausliefern, solange ein bekannter Weg offen ist, auf dem der Anwender Daten verliert"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-10T00:00:00.000Z
---

Am 10.09.2026 ist Gregors Postfach auf dem Server geleert worden. Seine
Nachricht: *„mails sind weg. vom server gelöscht. ich kann nichts mehr
filtern! bin sauer!"*

**Why:** Der Fehler war **nicht die Analyse**. Eudora kennt drei Wege, Post
auf dem Server zu löschen; ich hatte alle drei gefunden und beschrieben —
den dritten (`Delete fetched junk`, im Original **an**) am selben Vormittag.
Ausgeliefert habe ich dann 1.0.38, das nur **einen** der Wege sperrt, mit der
Bitte zu testen. **Das Testen hat den Verlust ausgelöst.**

Ein Paket ist keine Mitteilung, sondern eine Aufforderung zu handeln. Wer es
ausliefert, während ein bekannter Datenverlustweg offen steht, verursacht
den Verlust — die Kenntnis macht es schlimmer, nicht besser. Dass die
Behebung „schon in Arbeit" war, ändert daran nichts: der Anwender testet mit
dem, was er hat.

**How to apply:**

1. Ein Befund, auf dem der Anwender **Daten verliert**, bekommt in
   `BEFUNDE.md` das Wort **`DATENVERLUST`** in die Zeile. Grob und
   auffällig, nicht fein abgestuft.
2. Solange eine solche Zeile nicht **`**behoben**`** trägt, wird **kein
   Paket gebaut**. `tools/paket-bauen.ps1` bricht ab.
3. Muss es doch sein, braucht es `-TrotzDatenverlust "<Begründung>"`, und
   die Begründung steht im Protokoll.
4. Und wenn ein Paket in dieser Lage hinausgeht: **nicht zum Testen
   auffordern, ohne den Weg zu nennen.** „Bitte prüfe X" liest sich als
   „gefahrlos".

**Schranke:** tools/pruefe-datenverlust.pl (paket-bauen)

Gegengetestet in beide Richtungen: mit einer offenen Zeile weist die Prüfung
ab (exit 1), mit allen vier Zeilen auf *behoben* läuft sie durch (exit 0),
und `BEFUNDE.md` war danach byte-gleich wie vorher.

Verwandt: [[erst-pruefen-dann-anweisen]] — dieselbe Wurzel, eine Stufe
früher: keine Handlungsanweisung, deren Folgen ich nicht selbst geprüft
habe. Und [[fehlerklassen-abstellen]]: beim zweiten Auftreten Werkzeug und
Schranke bauen. Hier hat einmal genügt.

## Nachtrag 03.11.2026 (CHRONIST): E-188 gemessen, nicht gekennzeichnet, und das Release steht bevor

Zeiten MEZ, Transkript `f3d03714`, gemessen ([[CHRONIST-2026-11-03]], Abschnitt 4). Um 15:20:55: *„E-188 ist schlimmer als gedacht: Dabei kann auf dem Server eine Mail verloren gehen.“* Das Paket 7.2.2.132 war um 12:43 geschnürt, PR #217 stand seit 14:54:53, Gregors *„ja, wir können es auf github releasen“* kam um 14:00:43, also vor der Messung. Die Warnung kam in README und Release-Notizen (Punkt 4 hier). Dann: *„#217 ist bereit zum Mergen. Danach lege ich das Release an.“*

Gemessen beim CHRONIST-Lauf am 03.11. abends: Die E-188-Zeile in `BEFUNDE.md` trägt auf dem Messzweig *„kann die Mail auf dem Server verloren gehen“*, aber **nicht** `DATENVERLUST` (Punkt 1 hier). `pruefe-datenverlust.pl` sieht sie also nicht, und es ist nur in `paket-bauen.ps1` angeschlossen, nicht in `release-veroeffentlichen.ps1`. Gregors Entscheidung vom 23.10. ([[entscheidung-kritische-nicht-release-blocker]]) nennt sechs Kennungen, E-188 nicht.

**How to apply, zusätzlich:**
- **Eine Messung, die einen Verlustweg zeigt, setzt im selben Commit `DATENVERLUST`** in die Urteilszeile, auch auf einem reinen Messzweig.
- **Ein Ja zum Release, das vor der Messung fiel, gilt nicht für den neuen Stand.** Die Frage an Gregor lautet ausdrücklich: „7.2.2.132 veröffentlichen, obwohl E-188 Mails auf dem Server verlieren kann, mit der Warnung in den Notizen?“ Seine Antwort kommt wörtlich in die Begründung von `-TrotzDatenverlust`.
- **Schranken-Vorschlag (nicht gebaut):** `release-veroeffentlichen.ps1` fährt `pruefe-datenverlust.pl` wie der Paketbau; das Werkzeug meldet zusätzlich Urteilszeilen mit *„auf dem Server verloren“*, *„geht verloren“* oder *„Mailverlust“* ohne `DATENVERLUST`. Gegenprobe: E-188-Zeile des Messzweigs → gemeldet; mit `DATENVERLUST` und `**offen**` → Release abgewiesen; mit `**behoben**` → durch.

## Nachtrag 06.11.2026 (CHRONIST): das Release kam, während die prüfende Rolle noch lief

Zeiten MEZ, Transkript `1ad467cf`, gemessen ([[CHRONIST-2026-11-06]], Abschnitt 5). 03.11. 18:26:05 startete die Hauptsitzung selbst den CHRONIST. 18:38:19 veröffentlichte sie v7.2.2.132. 18:47:29 kam der CHRONIST zurück, erster Punkt: E-188 ist ein gemessener Mailverlust, das Release eine offene Frage an Gregor. Gefragt wurde 18:48:34, Gregor 18:52:20: *„Stehen lassen“* ([[entscheidung-e188-release-7-2-2-132]]). Die Abfrage vor dem Release (18:29:36) nannte nur Zweig und Werkzeug.

Seither richtig: Vor v7.2.2.133 (05.11. 09:36:22) und v7.2.2.136 (06.11. 11:16:28) stand die Frage nach neuem Verlust ausdrücklich da. Weiter offen: `release-veroeffentlichen.ps1` fährt `pruefe-datenverlust.pl` nicht (gemessen am 06.11., `grep -i datenverlust` leer).

**How to apply, zusätzlich:** Läuft eine Rolle, deren Ergebnis das Release berührt (CHRONIST, LEKTOR, PRÜFER), wird es vor dem Veröffentlichen abgewartet. Schranken-Vorschlag (nicht gebaut): `release-veroeffentlichen.ps1` liest `tools/AGENTEN-LAUFEN.md` im Hauptordner wie `haken-pr-lektor.pl` und weist ab, solange eine dieser Rollen als laufend steht; dazu Vorschlag 2 vom 03.11. **Gegenprobe:** Zustand 03.11. 18:38 → abweisen; leere Agentenliste → durch.
