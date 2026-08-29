---
name: nie-stillstehen
description: "Leerlauf ist der teuerste Fehler dieses Projekts — im Hintergrund bauen, weiterarbeiten, ungefragt melden"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:56:08.761Z
---

Stillstand kostet in diesem Projekt mehr als jeder fachliche Irrtum. Drei Regeln,
die ohne Erinnerung wirken müssen:

1. **Alles, was länger als zwei Minuten dauern kann, läuft im Hintergrund.**
   Kein Vordergrundaufruf mit grossem Zeitlimit. Während er läuft, arbeite ich an
   der nächsten Sache — Analyse, Doku, ein Agentenauftrag. Warten ist kein
   Arbeitsschritt.
2. **Auf eine Wiederaufnahme-Aufforderung folgt nie „No response requested."**
   „Continue from where you left off" heisst: Stand messen, in einem Absatz
   melden, weiterarbeiten. Diese Antwort ist in der Portierung zweimal gefallen
   (28.08.2026, 16:23 und 17:47) und hat beide Male eine Wiederaufnahme
   verschenkt, bis Gregor selbst „fertig?" bzw. „status" tippen musste.
3. **Ich melde mich von selbst**, bevor gefragt wird: was gerade läuft, seit wann,
   was der nächste messbare Zwischenstand ist.

**Why:** Gemessen am Mitschnitt vom 28.08.2026:

- **1 Stunde 46 Minuten kompletter Stillstand.** Letzte Aktivität 14:36:35, nächste
  16:23. Gregor hatte um 14:36:40 geschrieben: „ich fahre die VM runter. du bleibst
  dran und sicherst den stand." Genau die Zeit, die er für unbeaufsichtigtes
  Arbeiten freigegeben hatte, blieb ungenutzt. Zwei weitere Nachrichten aus der
  Warteschlange (14:37:21) wurden nie verarbeitet.
- **Dreimal zehn Minuten in Vordergrund-Zeitlimits** (nicht zweimal, wie früher
  notiert): ein voller MSBuild-Solution-Lauf und zweimal die OpenSSL-Konfiguration.
  Siehe [[haengende-kommandos-abbrechen]].
- Gregors Reaktionen darauf, wörtlich: „was dauert da so lange?", „hallo - ich rede
  mit dir.", „du hast meine wertvolle zeit vergeudet!", „ich bekomme keine
  rückmeldung von dir. das geht gar nicht.", „wenn du nochmal den gleichen fehler
  zum dritten mal machst, dann breche ich das projekt ab."

**How to apply:** Vor jedem längeren Lauf: Hintergrund, Ausgabe in eine Datei,
und im selben Zug den nächsten Arbeitsschritt beginnen. Sieben Mal hat Gregor
sinngemäss „mach währenddessen weiter" sagen müssen („währenddessen kannst du ja
weiter machen", „laß' dich nicht aufhalten, ich warte auf ein endergebnis",
„weitermachen - jetzt, sofort!"). Das ist kein Hinweis mehr, das ist die
Grundeinstellung. Reden blockiert nicht arbeiten: eine Antwort an Gregor und ein
laufender Agent schliessen sich nicht aus.

Siehe auch [[anweisungen-abarbeiten]] und [[agenten-benennen]].
