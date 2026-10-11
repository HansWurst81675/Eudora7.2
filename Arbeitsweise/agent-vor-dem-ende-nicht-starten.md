---
name: agent-vor-dem-ende-nicht-starten
description: "Ein Agent, der beim Sitzungsende noch laeuft, verliert seine ganze Arbeit - vor einer angekuendigten Pause keinen mehr starten"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T10:42:08.992Z
---

Schranke: keine - keine mechanische möglich, denn der Auslöser ist Gregors Ankündigung im Chat, und die kann kein Skript lesen. Stattdessen die Regel unten, geprüft an dem Moment, in dem ich `Agent` aufrufen will.

Gregor am 13.09.2026, nachdem zwei Agenten vom Vorabend nichts hinterlassen
hatten:

> *„warum fehlen wieder daten? mach es besser, daß es nicht immer wieder
> passiert!"*

**Was passiert war.** Am 11.09.2026 hatte er angekündigt: *„möchte bald
runterfahren. sollte alles gesichert und dokumentiert sein."* Kurz darauf:
*„dann merge ich noch nichts, wir machen jetzt schluß."* **Danach** habe ich
LEKTOR und PRÜFER gestartet — zwei Aufträge von je zwanzig Minuten. Als die
Sitzung endete, liefen beide noch. Gemessen am nächsten Tag: in beiden
Arbeitsbäumen **null geänderte Dateien, null Commits**. Die gesamte Arbeit war
weg, und mit ihr zwei Schranken und ein Doku-Durchgang.

**Why:** Ein Subagent schreibt erst beim Commit ins Repo. Bricht die Sitzung
vorher ab, ist alles verloren — anders als bei meiner eigenen Arbeit, die in
Dateien liegt, sobald ich sie schreibe. Und es fällt erst am nächsten Tag auf,
wenn Gregor nach dem Stand fragt. Er bezahlt die Zeit doppelt: einmal für den
Lauf, der nichts hinterließ, und einmal für den, der ihn wiederholt.

**How to apply:**

* **Nach einer Ankündigung des Endes** („ich schalte ab", „möchte bald
  runterfahren", „wir machen jetzt Schluss") **keinen Agenten mehr starten.**
  Was noch zu tun ist, wird notiert — in `WEITERMACHEN.md` oder als Auftrag im
  Chat —, nicht begonnen.
* **Läuft schon einer**, wenn die Ankündigung kommt: das sagen, statt es zu
  verschweigen. Gregor entscheidet dann, ob er wartet.
* **Auch ohne Ankündigung**: einen Agenten nur starten, wenn danach
  voraussichtlich noch genug Sitzung übrig ist. Zwanzig Minuten Auftrag
  brauchen zwanzig Minuten Sitzung.
* Im Auftrag selbst **früh committen lassen**: lieber ein Zwischenstand auf dem
  Zweig als ein perfektes Ergebnis, das nie ankommt.

Verwandt: [[abschalten-ist-ein-termin]] — dieselbe Ankündigung, andere
Konsequenz. Dort geht es um meine eigene Arbeit, hier um fremde, die ich
anstoße und dann nicht mehr einholen kann.
