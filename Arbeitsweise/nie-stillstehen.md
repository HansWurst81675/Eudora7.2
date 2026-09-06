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

---

## Nachtrag 06.09.2026 — der Stillstand ist nicht weg, er hat die Form gewechselt

**25 Nachrichten** in den beiden Mitschriften fragen, warum nichts vorangeht.
Der offene Leerlauf vom 28.08. (1 Stunde 46 Minuten) ist nicht wieder
vorgekommen. Was stattdessen kam, ist schwerer zu sehen: **Betrieb ohne
Ergebnis.**

| Datum | Gregor |
|---|---|
| 05.09. 20:28 | *„immer noch dran? oder schon was geliefert?"* |
| 06.09. 14:11 | *„immer noch nichts neues ausser Eudora72-1.0.12-release"* |
| 06.09. 14:19 | *„du sollst nicht ahnen, sondern untersuchen und fixen! warum dauert es so lange? mach' einfach!"* |
| 06.09. 14:21 | *„was machst du denn die ganze zeit? warum ist es immer noch nicht gefixt?"* |
| 06.09. 16:17 | *„haben wir seit heute schon etwas gefixt oder verbessert? ... dsa ist fast ein ganzer arbeitstag, aber ohne sichtbare ergebnisse."* |

Die letzte Frage ist die harte: nicht „warum wartest du", sondern **„was ist
seit heute morgen fertig geworden"**. Darauf muss ich jederzeit mit einer Liste
antworten koennen, nicht mit einer Beschreibung von Betriebsamkeit.

### Zwei Ergaenzungen zur Regel

4. **Was Gregor sieht, zaehlt — nicht was laeuft.** Ein Fix ist erst ein
   Ergebnis, wenn er in einem Paket liegt, das Gregor starten kann. Vierzehn
   Agenten, die arbeiten, sind fuer ihn null Fortschritt. Am 05.09.2026 musste
   er fragen: *„wieso hast du 24 agenten, die etwas bauen? woran arbeiten sie
   denn alle?"*
5. **Messen ist kein Ergebnis.** Zweimal habe ich einen Schaden vermessen und
   berichtet, statt ihn zu beheben — *„behebe den fehler, statt zu messen."*
   (05.09.) und *„du sollst nicht ahnen, sondern untersuchen und fixen!"*
   (06.09.). Eine Messung gehoert in denselben Arbeitsgang wie die Behebung; sie
   allein ist kein Zwischenstand, den man melden kann.

**Der Handgriff:** Am Ende jeder Arbeitsstunde eine Zeile in `CHANGELOG.md` —
was ist seit der letzten Zeile fertig geworden und in welchem Paket liegt es.
Bleibt die Zeile leer, ist das die Meldung, die Gregor ungefragt bekommt, mit
dem Grund. Eine leere Stunde, die er selbst entdecken muss, kostet mehr als
eine leere Stunde, die ich melde.
