---
name: fehlerbild-ist-ein-messfenster
description: "Solange Gregors Fehlermeldung offen steht, ist der Fehlerzustand messbar - erst messen (Log, Stapel des laufenden Prozesses), dann schließen lassen"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T08:36:58.668Z
---

Am 13.10.2026 stand bei Gregor die Meldung „Encountered an improper argument" nach Ctrl+F offen ([E-115](../BEFUNDE.md#e-115)). Er fragte: *„ok, soll ich meins jetzt schließen?"* Ich antwortete „nein, deins kannst du offen lassen" - gemeint als „es stört meinen Lauf nicht" - und startete Nachstellversuche in `C:\Temp`. Er schloss es trotzdem. Drei Nachstellläufe brachten nichts; der Fehler war **nur einmal, spontan** aufgetreten. Gregor danach: *„deshalb habe ich gefragt, ob ich es beenden soll, sonst hättest du ins log oder sonst wo reinschauen können, während der fehler sichtbar war"*.

**Why:** Ein seltener Fehler ist oft nur in diesem einen Moment messbar. Solange die Meldung steht, lebt der Prozess im Fehlerzustand: das Protokoll ist noch nicht überschrieben, und der Hauptthread steht im Fangblock - sein Stapel nennt die Nachricht und den Rahmen, der die Ausnahme fing. Nach dem Schließen bleibt nur Nachstellen, und das kann scheitern.

**How to apply:** Meldet Gregor eine sichtbare Fehlermeldung, ist die erste Antwort: **„bitte noch offen lassen"** - dann sofort lesen, was ohne Start geht: `eudora.log` (Ende, Zeitstempel), `Exception.log`, Fensterliste des Prozesses (nach Pfad gefiltert). Den Stapel des laufenden Prozesses nur mit seinem Ja (Anhängen eines Debuggers greift in seinen Prozess ein - [[nichts-auf-gregors-bildschirm-starten]], [[erlaubnis-nicht-hineinlesen]]). Erst danach schließen lassen. Fragt er „soll ich schließen?", ist das die Frage nach dem Messfenster, nicht nach meinem Lauf. Verwandt: [[eingebaute-messung-auslesen]], [[anzeige-ist-kein-zustand]].

Schranke: keine - der Moment, in dem eine Meldung offen steht, ist in keiner Datei sichtbar; offen ist ein Werkzeug, das den Stapel eines laufenden Eudora (nach Pfad, mit Freigabe) ohne Neustart ausliest.
