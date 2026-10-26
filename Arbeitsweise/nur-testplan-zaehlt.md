---
name: nur-testplan-zaehlt
description: "Gregor testet nur noch, was in Intern/TESTPLAN.md im Repo steht; Testanweisungen im Chat zählen nicht"
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-26T13:26:25.645Z
---

Gregor am 26.10.2026: *„ich teste jetzt nur noch sachen aus dem testplan, die im repo stehen. habe keine lust, hier in dem vielen text nach einzelnen hinweisen und anweisungen zu suchen.“* Davor: *„in dem chat steht so viel für mich unnützliches zeug drin, ich finde die wichtigen antworten und aussagen einfach nicht.“*

**Why:** Lange Chatantworten mit Herleitung, Lektor-Zwischenständen und Anweisungen dazwischen; er musste mehrfach nachfragen (T0–T5, ob etwas im TESTPLAN steht, Sprache wechselte versehentlich ins Englische).

**How to apply:** Jede Testanweisung zuerst in `Intern/TESTPLAN.md` schreiben, committen, pushen — im Chat nur „steht in TESTPLAN, Abschnitt X“. Keine Testschritte nur im Chat. Antworten kurz: Urteil, nächster Handgriff, höchstens eine Frage. Immer Deutsch. Siehe [[chat-knapp-halten]], [[testschritt-nennt-den-ort]].

Schranke: keine - eine Regel für den Chat, kein Werkzeug liest Chattext. Wirksam wird sie dadurch, dass Testschritte nur in Intern/TESTPLAN.md entstehen und pruefe-tabellenzeilen.pl dort jede Tabellenzeile prüft.
