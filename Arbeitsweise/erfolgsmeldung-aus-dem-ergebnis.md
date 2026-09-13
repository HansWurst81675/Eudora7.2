---
name: erfolgsmeldung-aus-dem-ergebnis
description: "Ein Skript darf Erfolg nur melden, wenn es das Ergebnis gemessen hat - mein Perl-Einzeiler schrieb 'eingefuegt', ohne etwas einzufuegen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T11:28:41.976Z
---

Schranke: keine - der Fehler steckt in Wegwerf-Einzeilern, die kein Skript vorher zu sehen bekommt. Die Pruefung ist der Handgriff danach: nach jedem Schreibzugriff den Marker in der Datei zaehlen, bevor irgendetwas gemeldet wird.

Am 13.09.2026, beim Festhalten der offenen Punkte in `WEITERMACHEN.md` vor
Gregors Herunterfahren: ein Perl-Einzeiler sollte eine Tabellenzeile über einen
Anker einsetzen. Die Ausgabe war

```
Can't open : No such file or directory at -e line 2.
  eingefuegt
  CR: 0  LF: 274
```

**Beides stand da — der Abbruch und die Erfolgsmeldung.** Der Pfad kam über
`$ENV{S}`, und `S` war in der Bash gesetzt, aber nicht exportiert. Eingefügt
wurde nichts: `grep -c` ergab **0 Treffer**, und die Zeilenzahl stand
unverändert bei 274.

**Why:** Der `print "eingefuegt"` hing am **Kontrollfluss**, nicht am Ergebnis.
Ohne die Nachmessung wäre der Satz „habe ich festgehalten" in die
Abschlussmeldung gegangen, und am nächsten Tag hätte weder E-85 noch der
QCSSL-Punkt irgendwo im Repo gestanden — genau die Klasse, die Gregor mit 45
Fundstellen auf Platz 1 seiner Fehlerliste geführt hat. Dass die Meldung neben
einem sichtbaren Fehler stand, macht es schlimmer, nicht besser: gemischte
Ausgaben liest man als „lief durch, kleine Warnung".

**How to apply:**

* **Nach jedem Schreibzugriff das Ergebnis messen, nicht den Rückgabewert des
  eigenen Skripts.** `grep -c <Marker>` auf die geschriebene Datei, und die
  Zeilenzahl gegen vorher. Erst dieses Ergebnis darf gemeldet werden.
* **Nie `$ENV{...}` für einen Pfad zwischen Bash und Perl.** Die Variable muss
  exportiert sein, und das sieht man dem Aufruf nicht an. Den Pfad direkt ins
  Skript schreiben — er ist ohnehin einmalig.
* Eine Erfolgsmeldung **unter** einer Fehlermeldung ist ein Alarmzeichen, kein
  Nebengeräusch. Dann zuerst nachmessen.

Verwandt: [[zeilenenden-nach-jedem-schreibzugriff-messen]] misst dieselbe Datei
auf eine andere Eigenschaft — dort lautlos falscher Inhalt, hier gar keiner.
Und [[gegenprobe-umdrehen]]: nicht fragen, ob mein Skript zufrieden ist,
sondern ob der gewünschte Zustand in der Datei steht.
