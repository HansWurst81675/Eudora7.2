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
