---
name: nur-testplan-zaehlt
description: "Gregor testet nur noch, was in Intern/TESTPLAN.md im Repo steht; Testanweisungen im Chat zählen nicht"
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-29T08:00:56.387Z
---

Gregor am 26.10.2026: *„ich teste jetzt nur noch sachen aus dem testplan, die im repo stehen. habe keine lust, hier in dem vielen text nach einzelnen hinweisen und anweisungen zu suchen.“* Davor: *„in dem chat steht so viel für mich unnützliches zeug drin, ich finde die wichtigen antworten und aussagen einfach nicht.“*

**Why:** Lange Chatantworten mit Herleitung, Lektor-Zwischenständen und Anweisungen dazwischen; er musste mehrfach nachfragen (T0–T5, ob etwas im TESTPLAN steht, Sprache wechselte versehentlich ins Englische).

**How to apply:** Jede Testanweisung zuerst in `Intern/TESTPLAN.md` schreiben, committen, pushen — im Chat nur „steht in TESTPLAN, Abschnitt X“. Keine Testschritte nur im Chat. Antworten kurz: Urteil, nächster Handgriff, höchstens eine Frage. Immer Deutsch. Siehe [[chat-knapp-halten]], [[testschritt-nennt-den-ort]].

Schranke: keine - eine Regel für den Chat, kein Werkzeug liest Chattext und kein Werkzeug prüft sie; sie wirkt nur, wenn ich vor jeder Testanweisung zuerst die TESTPLAN-Zeile schreibe.

## Nachtrag 27.10.2026 (CHRONIST): „Immer Deutsch“ – wann es kippt

Zeiten MEZ, gemessen am Transkript (Textzeilen der Antworten, nach englischen Funktionswörtern ohne deutsche gezählt).

- 26.10.: vier englische Zeilen 07:28–08:00, direkt nach der Kompaktierung um 07:26. Dann **27 von 38** Antwortzeilen zwischen 12:41 und 14:18, direkt nach der Kompaktierung um 12:41, darunter die Meldung an Gregor *„I've fixed it and pushed“* (14:04). Gregor 14:18:27: *„wieso haben wir jetzt auf englisch umgeschaltet?“* Die Regel „Immer Deutsch“ kam um 14:26 in diese Datei, um 14:28:58 folgte noch eine englische Zeile (*„I can't find a report on T3–T5 in the chat.“*).
- 27.10.: drei englische Zeilen ohne vorherige Kompaktierung: 12:45:05 (*„I wrote this file with Write, so I edit it with Edit.“*), 15:39:55 und 15:40:12 (beide beim Reparieren von `ZWEIGE.md`).

**Vermutung, nicht gemessen:** Die Zusammenfassung nach einer Kompaktierung ist englisch (*„This session is being continued …“*, *„Primary Request and Intent“*). Was danach kommt, setzt deren Sprache fort, bis Gregor schreibt. Die drei Zeilen vom 27.10. kamen jeweils mitten in einer Reparatur, als der Blick auf dem Werkzeug lag.

**How to apply, zusätzlich:** Nach *„This session is being continued“* ist die erste Zeile an Gregor deutsch, bevor ein Werkzeug läuft. Englischer Werkzeugtext (Fehlermeldungen, Ausgaben) wird zitiert, nicht fortgesetzt.

## Nachtrag 28.10.2026 (CHRONIST): eine englische Zeile

Gezählt wie am 27.10., Transkript `72be6093…`: Unter 72 Antworttexten der Sitzung ist einer englisch, um 13:33:07 MEZ: *„The working directory had shifted. I'm using absolute paths now.“* Das war 64 Minuten nach der Kompaktierung (12:29), mitten in einer Reparatur und direkt nach einer **deutschen** PowerShell-Fehlermeldung. Gregor hat nicht nachgefragt. Das passt zur zweiten Hälfte der Vermutung vom 27.10. (*„mitten in einer Reparatur, als der Blick auf dem Werkzeug lag“*). Die erste Hälfte (*„setzt die Sprache der Zusammenfassung fort“*) erklärt diesen Fall nicht. Belegt ist nur die Zeile.

## Nachtrag 29.10.2026 (CHRONIST): vier englische Zeilen, alle beim Reparieren oder Prüfen

Gezählt wie oben. 28.10. ab 15:28 MEZ: 21 Antworttexte, einer englisch (15:38:33, *„The path was mangled again (backslashes lost). I'm fixing it with `\x5c`.“*). 29.10. bis 08:47 MEZ: 46 Antworttexte, drei englisch oder halb: 07:49:27 (*„I schreibe die Label-Antwort …“*), 08:21:56 (*„Excluded — safe to commit.“*), 08:31:30 (*„No links ended up inside code spans. Commit and push.“*). Keine Kompaktierung davor. Alle vier stehen direkt nach einer Werkzeugausgabe, die ich gerade prüfte (Rückstrich, Haken-Ausnahme, Codespannen). Gregor hat nicht nachgefragt. Die zweite Hälfte der Vermutung vom 27.10. hat damit acht Fälle aus drei Tagen für sich (27.10.: drei, 28.10.: zwei, 29.10.: drei), die erste keinen weiteren.

## Nachtrag 30.10.2026 (CHRONIST): drei Zeilen in 51 Antworttexten

Gezählt wie oben. 29.10. 21:20 bis 22:31 MEZ: 41 Antworttexte, einer halb englisch (21:41:45, *„I ziehe gerade veraltete Zeilenangaben in FILTER.md und EINSTELLUNGEN.md nach.“*), mitten im Einarbeiten von LEKTOR-96. 30.10. bis 07:10: 10 Antworttexte, zwei englisch (07:08:14 *„Now the WEITERMACHEN file. Let me read it fully.“*, 07:12:18 *„Now assemble both files.“*), beide als Ankündigung des nächsten Handgriffs, ohne Kompaktierung davor. Gregor hat nicht nachgefragt. Das Muster vom 29.10. (*„direkt nach einer Werkzeugausgabe, die ich gerade prüfte“*) passt auf alle drei. Neu ist die Form: kurze Selbstansagen vor einem Werkzeugaufruf.
