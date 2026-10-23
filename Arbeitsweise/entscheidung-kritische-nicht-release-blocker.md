---
name: entscheidung-kritische-nicht-release-blocker
description: "Gregor 23.10.2026 - die sechs offenen \"kritischen\" Befunde E-122, E-123, E-124, E-126, E-129, E-136 halten 7.2.1.0 NICHT auf (\"unkritisch, randfaelle\"); noch nicht im Repo eingetragen"
metadata:
  node_type: memory
  type: project
  originSessionId: a69eff9b-25ae-4f47-954f-33083d44e7c0
  modified: 2026-10-23T13:05:32.641Z
---

Schranke: keine - eine Entscheidung, die noch nicht im Repo steht, laesst sich nicht pruefen, nur eintragen. Der Ausloeser ist das Einarbeiten von LEKTOR-53 ([[wissen-gehoert-in-dateien]]).

Gregor am 23.10.2026 auf meine Frage, ob die sechs offenen, als kritisch eingestuften Befunde ausserhalb von ZIEL.md vor 7.2.1.0 erledigt sein muessen: *"ich sehe die ganzen dinge unkritisch. sind randfälle."* Auf Rueckfrage bestaetigt: gemeint sind **E-122, E-123, E-124, E-126, E-129, E-136** — nicht die vier Anzeigefehler E-77, E-113, E-116, E-119 (die bleiben im Massstab).

**Why:** BEFUNDE.md (Stufe "kritisch" = vor jedem Release) und ZIEL.md widersprachen sich; der LEKTOR hatte es mehrfach als Gregors Entscheidung offen gelassen.

**How to apply:** Beim Einarbeiten von LEKTOR-53 in ZIEL.md und BEFUNDE.md als Entscheidung mit Zitat eintragen (Ausnahmezeile wie "wir fixen nichts fuer hermes"); danach diese Notiz loeschen. Siehe [[nur-offene-entscheidungen-auf-gregors-liste]].

## Ebenfalls noch einzutragen: E-132 (Starttest) von Gregor bestaetigt

Gregor 23.10.2026: *"starten mit fremden verz. funktioniert schon länger. das habe ich mehrfach geprüft."* / *"doku: ziehe es nach!"*. CHRONIST hat den Verlauf ausgewertet (drei Zitate von mir am JSONL nachgeprueft): Rueckfrage erscheint (M1 Schritt 1) an 1.0.114 (21.10. 07:14) und 1.0.115 (07:38, *"0.115: 2x nacheinander starten verhält sich jetzt korrekt"*); *Vorhandenes benutzen* (Schritt 5) an 1.0.118 (11:06, *"0.118 habe ich auf die mails von 0.116 gesetzt, absichtlich"*) und 1.0.120 (21.10. 14:19, 22.10. 19:44). Gescheitert 1.0.117 (10:15, *"kann nichts starten, wenn ich nur die .exe anklicke"*), behoben in .118. Schritte 2, 3, 4, 6 von M1 nicht einzeln gemeldet. Eintragen in BEFUNDE.md (E-132) und TESTPLAN M1/C8 als "von Gregor bestaetigt", die nicht gemeldeten Schritte als solche benennen.
