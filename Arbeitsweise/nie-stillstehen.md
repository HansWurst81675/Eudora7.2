---
name: nie-stillstehen
description: "Leerlauf ist der teuerste Fehler dieses Projekts — im Hintergrund bauen, weiterarbeiten, ungefragt melden"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-10-13T15:00:00.000Z
---

Schranke: keine - Leerlauf ist eine Eigenschaft des Gesprächsverlaufs; im Repo ist eine Pause nicht von Arbeit zu unterscheiden

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

## Nachtrag 13.10.2026: „für morgen" war zum Teil schon heute machbar

Um 14:10 UTC stand der Plan für den nächsten Tag in `WEITERMACHEN.md` und im Chat. Punkt 1 lautete *„E-117 am laufenden Programm messen. Prüffall ist deine eBay-Weiterleitung"*. Schon die Abschaltmeldung um 14:06 hatte gesagt: *„E-117 ist noch nicht am laufenden Programm gemessen … Beides erledige ich in der nächsten Sitzung."* Gregor um 14:11:00:

> *„du kannst es ja teilweise selbst überprüfen, nicht wahr?"*

Die Antwort kam elf Sekunden später: *„Ja. E-117 kann ich ohne dich nachstellen."* Gebaut wurden eine Prüfnachricht mit `&amp;` in der Bildadresse (`Testdaten/e117-amp-in-bildadresse.eml`) und ein Bildserver auf `127.0.0.1` (`tools/bildserver-e117.pl`), der das richtige Bild nur bei `&` liefert. Um 14:13:43 stand die Gegenprobe (`Datei=1x1 gemalt=165x165`, genau Gregors eBay-Bild), um 14:15:40 die Messung an 7.2.0.87. **Viereinhalb Minuten.** Der Punkt stand als Aufgabe für morgen da, mit Gregors Postfach als Prüffall.

**Why:** Wer eine Liste für morgen schreibt, sortiert nach Reihenfolge, nicht danach, wer etwas braucht. Ein Punkt, der Gregors Nachricht als Prüffall nennt, sieht aus, als bräuchte er Gregor. Der Mechanismus (`&amp;` im `src`) ließ sich aber aus seinem Protokoll vollständig nachbauen.

**How to apply:**

- **Jeder Punkt einer Liste für später bekommt eine Spalte: braucht Gregor / geht ohne ihn.** Was ohne ihn geht und keine Stunde braucht, wird gemacht, solange er noch da ist, und die Liste wird danach geschrieben.
- **Ein Prüffall aus Gregors Postfach ist ein Hinweis auf den Mechanismus, kein Termin bei ihm.** Erst fragen, ob sich der Mechanismus mit einer Testnachricht und einem Server auf `127.0.0.1` nachbauen lässt ([[testdaten-muessen-durchkommen]]: das Netz außen vor lassen).

## Nachtrag 25.10.2026 spät (CHRONIST): „seit wann“ geschätzt statt abgelesen, zehnmal „danach der PR“

Zeiten MEZ, gemessen am Transkript. Gregor schrieb um 20:17:00 *„sag bescheid, wenn was zum mergen da ist.“*, um 20:17:19 *„ich warte.“*, um 20:19:35 *„lebt der prüfer noch?“* und um 20:35:48 *„ich warte...“*. PR #175 kam um 20:49:47, 33 Minuten nach seiner ersten Bitte.

- **Regel 3 verlangt „seit wann“. Die Angabe war falsch.** Um 20:17:22: *„Der PRUEFER läuft noch, gestartet ist er vor etwa 20 Minuten.“* Gestartet war PRUEFER-56 um 20:12:15, also fünf Minuten vorher. Angekündigt waren *„etwa 10–20 Minuten“*. Wer „20 Minuten“ liest, hält den Lauf für überfällig. Dass Gregors *„lebt der prüfer noch?“* zwei Minuten später daher kam, ist eine Vermutung. Die Antwort darauf war gut, weil gemessen: Zeitstempel und Größe von `PRUEFER-56.md` (20:19, 12 KB), fünf Sekunden nach der Frage.
- **Zehn Zusagen „danach der PR“ zwischen 20:12:23 und 20:46:35** (gezählt am Text). Jede stimmte, als sie geschrieben wurde. Dann kam der nächste Lauf dazwischen: PRUEFER-56 fand um 20:20 die unwirksame Behebung, danach kamen Verlegung, Bau, Prüfstand, LEKTOR-66/PRUEFER-57, LEKTOR-67 und LEKTOR-68. Eine neue Zeitangabe für den PR gab es in den 33 Minuten nie, auch nicht, als um 20:21 feststand, dass die Behebung neu gebaut werden muss.
- Die tatsächlichen Laufzeiten der sechs Kurzläufe (LEKTOR-65 bis -68, PRUEFER-56/57) lagen bei 1,6 bis 8,7 Minuten (gemessen an `duration_ms`). Die Ansage „10–20 Minuten“ war zu hoch, und das ist harmlos. Gefehlt hat die Gesamtzeit bis zum Ziel, auf das Gregor wartete.

**How to apply, zusätzlich:**
- „Seit wann“ wird abgelesen (Startzeit des Agenten oder Zeitstempel seiner Datei), nie geschätzt.
- Ändert sich der Weg zum zugesagten Ziel (neuer Fund, neuer Bau), dann sagt die nächste Zeile das neue Ziel mit Zeit: *„Der PR verschiebt sich, weil … Neue Schätzung: etwa 20:45.“* Ein weiteres „danach der PR“ ohne Zeit zählt nicht.
