---
name: chat-knapp-halten
description: "Antworten im Chat kurz halten; Messdetails gehören in BEFUNDE.md, nicht in die Konsole"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T07:54:02.042Z
---

Gregor am 13.10.2026, mitten im Testlauf zu 1.0.84: *„schreib hier nicht so viele inhalte in die console, das macht das ganze unübersichtlicher"*.

**Why:** Er testet parallel und braucht im Chat nur Ergebnis und nächsten Handgriff. Lange Tabellen, Befehlsausgaben und Herleitungen verdecken das.

**How to apply:** Je Antwort: Urteil in einem Satz, was er jetzt tun soll, höchstens eine Frage. Herleitung, Zahlen und Fundstellen stehen in BEFUNDE.md — dort nur verweisen (Kennung, Commit). Auch Werkzeugaufrufe mit kurzer Ausgabe fahren (grep -c, tail -3 statt ganzer Logs). Verwandt: [[auftrag-vor-selbstbetrachtung]], [[erfolg-aus-anwendersicht]].

Schranke: keine - die Länge einer Chat-Antwort steht in keiner Datei, die ein Haken lesen könnte; Gregors Einwurf ist der Messwert ([[einwurf-ist-ein-messwert]]).
