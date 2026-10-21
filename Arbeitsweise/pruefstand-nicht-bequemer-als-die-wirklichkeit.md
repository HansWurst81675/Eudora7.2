---
name: pruefstand-nicht-bequemer-als-die-wirklichkeit
description: "Ein Pruefstand, der bequemer gebaut ist als die Wirklichkeit, misst den Fehler weg - C:\\Temp\\E132 ist sein eigener 8.3-Kurzname, deshalb meldeten alle drei Messungen zu E-132 gruen, waehrend Eudora beim Anwender sein EIGENES Mailverzeichnis fuer fremd hielt"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-10-21T05:52:37.507Z
---

Schranke: tools/pruefe-pruefstand-pfad.pl (vor jeder Messung am laufenden Programm, und in die Zeile „Gemessen" von Releases/PAKETE.md) - misst für jeden Prüfpfad mit Win32::GetShortPathName drei Lagen, die beim Anwender vorkommen: 8.3-Alias, Leerzeichen, Benutzerprofil. Gegengetestet mit --selbsttest (8 Fälle in beide Richtungen) und an den echten Pfaden: `C:\Temp\E132` deckt 3 von 3 Lagen nicht ab, `C:\Users\Gregor\Eudora72-1.0.114-release` hat den Alias `EUDORA~1.114`.

# Der Prüfstand darf nicht bequemer sein als die Wirklichkeit

**Regel.** Ein Prüfstand wird dort gebaut, wo der Anwender steht — nicht dort,
wo es sich gut tippt. Jede Bequemlichkeit (kurzer Pfad, kein Leerzeichen,
eigenes Startskript, selbst geschriebene Registry) ist eine Lage, die der
Prüfstand **nicht sehen kann**. Was er nicht sehen kann, meldet er grün.

## Was passiert ist (20./21.10.2026, [E-132](../BEFUNDE.md#e-132))

Am Abend des 20.10. war die Behebung **auf allen drei Wegen am laufenden
Programm gemessen** — Ja, Nein, Abbrechen, jeder mit Protokoll und
Prüfsumme der fremden `Eudora.ini`. Das ist genau das, was
[[erst-nachstellen-dann-ausliefern]] verlangt, und es war ehrlich gemacht.

Am 21.10. vormittags hat Gregor die Fassung **zwei Minuten nach dem ersten
Start** widerlegt: sie fragt bei **jedem** Start, obwohl das eigene
Mailverzeichnis längst angelegt ist.

**Die Ursache ist der Prüfstand, nicht der Code.** Gemessen mit
`Win32::GetShortPathName`:

| | Pfad | Kurzform |
|---|---|---|
| Prüfstand | `C:\Temp\E132` | `C:\Temp\E132` — **identisch** |
| Wirklichkeit | `C:\Users\Gregor\Eudora72-1.0.114-release` | `C:\Users\Gregor\EUDORA~1.114` |

Die Registry liefert den Aufruf in der **Kurzform**. Am Prüfstand sind Kurz-
und Langform dasselbe, der Vergleich *„ist das mein eigenes Verzeichnis?"*
geht auf, und alle drei Messungen melden grün. Beim Anwender sind es zwei
verschiedene Zeichenketten — und Eudora hält sein eigenes Verzeichnis für
fremd. Im Protokoll von 1.0.114 steht es wörtlich:

```
E-132 Startverzeichnis: gefunden="C:\Users\Gregor\EUDORA~1.114\MAILVE~1"
      eigenes="C:\Users\Gregor\Eudora72-1.0.114-release\" fremd=1
```

**Das stand in meiner eigenen Messausgabe**, bevor Gregor es meldete: der
CHRONIST hat am 21.10. um 10:0x `tools/spur-lesen.pl` gegen genau dieses
Protokoll gefahren und die Zeile ausgegeben — `fremd=1` für das eigene
Verzeichnis. Gelesen wurde sie als Beleg dafür, dass die Spurmarke
funktioniert ([[ausreisser-ist-der-befund]]).

PRÜFER-41 hat danach zwei weitere Lagen gefunden, die derselbe Prüfstand nicht
treffen konnte: ein Pfad **ohne Leerzeichen** und der Startweg mit **leerer
Befehlszeile** (Doppelklick statt Startskript).

## Warum die vorhandenen Lehren nicht gereicht haben

- [[erst-nachstellen-dann-ausliefern]] verlangt „alter Stand rot, neuer grün".
  Beides war erfüllt — **am falschen Ort**. Die Lehre sagt, *dass* nachgestellt
  wird, nicht *wo*.
- [[pruefstand-kann-blind-sein]] handelt von einem Prüfstand, der gar nicht
  läuft. Dieser lief, vollständig, dreimal.
- [[extrakt-ist-nicht-das-programm]] ist derselbe Gedanke eine Ebene tiefer:
  dort fehlt dem Prüfling der Lebenslauf, hier der Umgebung die Rauheit.
- [[gegenprobe-umdrehen]] hätte es gefangen: nicht prüfen, ob der gewünschte
  Zustand erscheint („fragt nach fremdem Verzeichnis"), sondern ob der
  **umgekehrte** durchkommt („fragt beim eigenen **nicht**"). Diese Gegenprobe
  ist am Prüfstand gefahren worden — und sie war dort grün, weil die Pfade
  identisch waren.

## How to apply

1. **Vor jeder Messung am laufenden Programm:**
   `perl tools/pruefe-pruefstand-pfad.pl <Prüfpfad>`. Was dort als nicht
   abgedeckt gemeldet wird, ist eine Lage, über die die Messung **nichts**
   sagt.
2. **Der Prüfstand steht, wo der Anwender steht:** unter
   `C:\Users\<Name>\…`, mit einem Verzeichnisnamen, der einen 8.3-Alias
   erzwingt, und einmal zusätzlich mit Leerzeichen im Pfad.
3. **Gestartet wird, wie der Anwender startet.** Doppelklick (leere
   Befehlszeile) ist ein anderer Weg im Code als ein Startskript mit Argument.
   Beide messen, nicht einen.
4. **Was ich selbst in die Registry schreibe, misst meine Annahme.** Die
   Registry muss aus einem echten Setup oder einem echten fremden PC stammen —
   Gregors Export von einem fremden Rechner hat am 20.10. genau deshalb den
   Unterschied gezeigt (dieselbe Befehlszeile dreifach, in Kurzform).
5. **Die Lücke gehört in die Zeile „Gemessen"**, wenn sie bleibt: *„gemessen
   an `C:\Temp\E132` — ohne 8.3-Alias, ohne Leerzeichen, nicht unter dem
   Benutzerprofil"*. Dann sieht der nächste Leser, was offen ist, statt ein
   grünes Ergebnis zu erben.

**Lücke der Schranke.** Sie prüft Pfade. Dieselbe Bequemlichkeit gibt es auch
ohne Pfad: ein Prüfserver, der immer `APPENDUID` meldet
([[erst-nachstellen-dann-ausliefern]]), ein Konto ohne Umlaute, ein Postfach
mit drei Nachrichten statt dreitausend. Die Frage dahinter ist immer dieselbe:
**worin ist es hier leichter als bei ihm?**
