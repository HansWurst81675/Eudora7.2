---
name: ausbleiben-ist-kein-befund
description: "Eine Messung, die nichts ausgibt, hat nichts gemessen - am 20.10.2026 blieb die Spurmarke zu E-132 aus zwei verschiedenen Gruenden stumm (zwei Pfade in einer Registry-Zeichenkette, dann ein Protokoll, das noch gar nicht offen war), und dieselbe Fehldeutung lief am selben Abend noch zweimal"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-10-21T05:39:27.326Z
---

Schranke: tools/spur-lesen.pl (bei jeder Auswertung eines Protokolls auf eine Spurmarke) - trennt drei Lagen: Marke da (0), Marke fehlt bei offenem Kanal (1, ein Messergebnis), stummer Kanal (2, KEIN Messergebnis: leeres Protokoll, keine einzige Marke, LogLevel ohne 32768). Gegengetestet mit --selbsttest (8 Fälle in beide Richtungen) und an drei echten Protokollen: 1.0.113 meldet 1 (E-132 fehlt, 18 andere Marken da), 1.0.114 und 1.0.115 melden 0.

# Ausbleiben ist kein Befund

**Regel.** „Es steht nichts im Protokoll", „kein Dialog gefunden", „keine
Fassung lesbar" sind **keine Messergebnisse**, sondern Zustände der Messung.
Bevor aus einem Nichts eine Aussage über das Programm wird, kommt die
**Positivprobe**: ist überhaupt etwas angekommen?

## Was passiert ist (20.10.2026 abends, drei Fälle in vier Stunden)

### 1. Die Rückfrage zu [E-132](../BEFUNDE.md#e-132) war eingebaut und blieb stumm — zweimal, aus verschiedenen Gründen

Eudora sollte fragen, bevor es das Mailverzeichnis einer fremden Installation
übernimmt. Beim Nachstellen kam keine Rückfrage und keine Spurmarke. Die
naheliegende Deutung — *„die Stelle wird nicht erreicht"* — war beide Male
falsch:

| | Ursache, gemessen | Behebung |
|---|---|---|
| **a)** 21:56 (`1e02c232`) | Die Registry speichert nicht ein Verzeichnis, sondern den **ganzen Aufruf**. Nach dem Abschneiden des Programmnamens standen **zwei Pfade in einer Zeichenkette**, durch ein Leerzeichen getrennt. Der angehängte `Eudora.ini`-Pfad existierte deshalb nie, `bHatEigeneIni` war immer falsch. | `E132AufrufZerlegen` trennt nach derselben Regel wie `GetDirs` (`fileutil.cpp:432`) |
| **b)** 22:17 (`0c436bde`) | `StartEudoraWithDefaultLocation` läuft, **bevor** `QCLogFileMT::InitDebug` das Protokoll öffnet — und das muss so sein, denn das Protokoll liegt in dem Mailverzeichnis, das dort erst gesucht wird. `PutDebugLog` kehrt ohne `s_pLogFile` **stumm** zurück (`QCUtils/src/debug.cpp:141`). | `E132SpurMerken` sammelt, `E132SpurAusgeben` gibt direkt nach `InitDebug` aus (`eudora.cpp:1209`) |

Dazu die dritte Änderung, die den Fall erst messbar machte: **beide Ausgänge**
schreiben jetzt eine Spurmarke, mit allen Werten in **einer** Zeile. Vorher
protokollierte nur der Fremdfall — deshalb stand im Protokoll überhaupt
nichts, nicht einmal, dass die Stelle erreicht wurde
([[zwei-werte-in-eine-ausgabe]]).

### 2. „KEIN Dialog gefunden" — und der Dialog stand da

Das Messskript zum Über-Dialog meldete, es habe keinen Dialog gefunden. Daraus
wurde um 21:36 die Berichtigung *„das Skript hat den Dialog nie geöffnet"*
(`11125332`). Gregor zwei Minuten später: *„war schon offen, habe nur den copy
button gedrückt und dir den inhalt gezeigt."* Um 21:39 die zweite Berichtigung
(`5f721756`): **geöffnet, nur nicht wiedererkannt.** Die erste Berichtigung
stützte sich auf dieselbe stumme Messung wie der Fehler davor.

### 3. „In der Eudora.exe steht keine Fassung 7.2.0.NN"

Defender zog um 20:45:19 die ausgepackte Datei ein; die Schranke las keine
Bytes und machte daraus eine Aussage über das Paket. Der Fall steht in
[[pruefung-legt-nichts-ab]]; die Behebung enthält genau diese Lehre als
Codezeile: *„nicht lesbar" ist etwas anderes als „falsche Fassung".*

## Warum die vorhandenen Lehren nicht gereicht haben

- [[messung-muss-den-weg-treffen]] fragt, ob der geprüfte Weg überhaupt
  gelaufen ist. Richtig — aber sie setzt voraus, dass die Messung **etwas**
  ausgibt. Hier war der Betriebsmodus richtig und der Weg lief; der
  **Ausgabekanal** war zu.
- [[eingebaute-messung-auslesen]] sagt, eine Spurmarke, die niemand ausliest,
  sei keine Messung. Diese wurde ausgelesen — und war leer.
- [[pruefstand-kann-blind-sein]] beschreibt denselben Mechanismus eine Ebene
  höher: *ein kaputter und ein grüner Prüfstand melden dasselbe, nämlich
  nichts.* Hier melden **„nicht erreicht"** und **„Kanal zu"** dasselbe,
  nämlich nichts.
- [[ursache-nur-gemessen-behaupten]]: *„die Stelle wird nicht erreicht"* war
  dreimal eine Ursachenbehauptung ohne Messung, und dreimal falsch.

## How to apply

1. **Positivprobe zuerst.** Bevor aus einem Nichts eine Aussage wird:
   `perl tools/spur-lesen.pl <protokoll> <marke>`. Kommt dort Urteil **2**
   (stummer Kanal), ist nichts gemessen worden — dann wird der Kanal
   repariert, nicht die Vermutung weitergebaut.
2. **Jede eingebaute Messung protokolliert beide Ausgänge**, in einer Zeile,
   mit den Eingangswerten. Eine Marke, die nur den interessanten Fall
   schreibt, kann „nicht erreicht" nie von „anders entschieden" trennen.
3. **Eine Messstelle vor der Initialisierung ihres Ausgabewegs puffert** und
   gibt aus, sobald der Weg offen ist. Im Startweg von Eudora liegt diese
   Grenze bei `InitDebug` — alles davor ist stumm.
4. **Die Eingabe nachsehen, nicht annehmen.** Der Registry-Wert hieß wie ein
   Verzeichnis und war eine Befehlszeile. Ein Wert, auf dem eine Entscheidung
   steht, wird einmal ausgegeben, bevor man ihm glaubt.
5. **Ein Werkzeug, das nichts lesen konnte, meldet „ungeprüft"** und nennt den
   Grund — nie einen Befund ([[pruefung-legt-nichts-ab]]).
6. **Eine Berichtigung, die aus derselben stummen Messung stammt wie der
   Fehler, ist keine Berichtigung.** Am 20.10. kostete das zwei Fassungen
   derselben Zeile in drei Minuten.

**Lücke der Schranke.** `spur-lesen.pl` prüft Protokolle. Für Messungen ohne
Protokoll — Fensterskripte, Oberflächenprüfungen — gilt dieselbe Regel, aber
sie wird von keinem Werkzeug durchgesetzt: dort hilft nur Punkt 1 von Hand,
also eine Positivprobe, die beweist, dass die Messung überhaupt etwas sehen
kann.

## Nachtrag 25.10.2026 abends (CHRONIST): ein Fensterskript ohne Fenster als „nachgestellt" gemeldet

Zeiten MEZ, gemessen an den Ausgabedateien `e137*.txt` im Scratchpad der Sitzung.

`tools/messen-e137.ps1` lief viermal auf `C:\Temp\E97`. Jedes Mal meldete es *„Filterfenster nicht gefunden - sichtbare Titel:"*, gefolgt von einer **leeren** Liste. Auch die Liste *„Fenster des Prozesses (oben, sichtbar)"* blieb leer. Die Ergebnisse widersprachen sich: um 19:12 und 19:31 `lebt=0`, zweimal um 19:31 `lebt=1`. Eine Positivprobe gab es nicht: Das Skript fand nicht einmal das Hauptfenster in seiner eigenen Aufzählung, obwohl `testlauf.ps1` es gerade gemeldet hatte.

Um 19:28:55 sagte ich Gregor trotzdem: *„**Mein automatischer Versuch hat das Zugehen nachgestellt**, fand aber das Filterfenster nicht."* Um 19:30:56 baute ich darauf eine Ursache: *„Möglicherweise beendet Strg+W also schon dann, wenn kein Fenster den Befehl annimmt."* Zu dem Zeitpunkt gab es genau einen Lauf, und der hatte nichts gesehen.

Ehrlich wurde es erst im Repo: Um 19:36:59 schreibt `BEFUNDE.md` E-137 *„unbrauchbar: das Skript sah kein einziges Fenster des Prozesses, seine Ergebnisse widersprachen sich … verworfen"*, und die Skripte wurden gelöscht. Im Chat wurde das „nachgestellt" nicht zurückgenommen. Erst um 19:55 nannte ich das Skript nebenbei „unbrauchbar".

**How to apply, zusätzlich:** Ein Fensterskript, dessen Aufzählung leer ist, hat **nichts** gemessen, auch nicht `lebt=0`. Das Wort „nachgestellt" setzt voraus, dass die Positivprobe grün war: Das Skript sieht das Hauptfenster in derselben Aufzählung, mit der es das Zielfenster sucht. Widersprechen sich zwei Läufe, ist der Widerspruch der Befund ([[ausreisser-ist-der-befund]]). Er wird Gregor gemeldet, bevor eine Ursache darauf gebaut wird.
