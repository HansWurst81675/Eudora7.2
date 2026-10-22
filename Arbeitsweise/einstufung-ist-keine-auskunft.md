---
name: einstufung-ist-keine-auskunft
description: "\"teilweise, Wirkung belegt\" sagt nicht, was noch zu tun ist - am 22.10.2026 nannten 23 von 40 offenen Befunden nur ihre Einstufung, acht davon mit einem einzigen Wort"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-22T12:10:00.000Z
---

Schranke: `tools/offene-befunde.pl` weist seit dem 22.10.2026 ab, wenn ein offener Befund keine Marke `**Was noch fehlt:**` traegt. Sie wurde erst scharfgestellt, nachdem alle 40 gefuellt waren — eine Schranke, die ab dem ersten Tag jeden Commit blockiert, wird wieder ausgebaut ([[schranke-gehoert-in-den-haken]]).

# Eine Einstufung ist keine Auskunft

**Regel.** Ein offener Punkt beantwortet nicht die Frage *„wie steht es?"*,
sondern die Frage *„was muss ich tun?"* Wer nur den Status notiert —
`offen`, `teilweise`, `bestaetigt`, `in Arbeit` —, zwingt jeden Leser,
das ganze Urteil zu lesen, um den Rest zu finden. Der naechste Leser ist
meistens Gregor, und er hat das Urteil nicht geschrieben.

## Was passiert ist (22.10.2026)

Gregor sah sich einen einzelnen Eintrag an:

> *„Erscheinungsbild: fuenf Punkte umgesetzt | teilweise, Wirkung belegt —
> was heisst es? was fehlt hier?"*

und gleich darauf, bevor ich mit der Antwort zu A-1 fertig war:

> *„mir geht es nicht nur um A-1, sondern um alle punkte!"*

Gemessen am selben Tag ueber die Tabelle der offenen Befunde:

| | |
|---|---|
| offene Befunde | **40** |
| Urteile, die nur die **Einstufung** nennen, nicht den Rest | **23** |
| davon mit einem **einzigen Wort** | **8** |

Die Tabelle in `Intern/WEITERMACHEN.md` hatte bis dahin **zwei** Spalten:
Kennung und *worum es geht*. Was zu tun ist, stand in keiner. Seitdem hat
sie drei, und `offene-befunde.pl` erzeugt die dritte aus der Marke
`**Was noch fehlt:**` am Ende der Urteilsspalte von `Intern/BEFUNDE.md`.

Wie viel darin steckt, zeigen die Eintraege, die es vorher nicht gab:

- **B5.7:** *„der IMAP-Weg ruft `SetExtension` nicht auf. Zehn der elf Teile
  sind behoben; im Test fiel es nicht auf."*
- **F2:** *„`StripTabooHeaders` entfernt die `Content-Type`-Zeile, bevor der
  Kern sie setzen kann."*
- **S-3c:** *„`MFC71.DLL` und `MSVCP71.dll` fehlen dauerhaft, damit fallen
  Adressbuch und … aus."*

Das sind Saetze, aus denen man anfangen kann. *„teilweise"* ist kein Satz.

## Warum die benachbarte Lehre nicht gereicht hat

[[kuerzel-im-chat-uebersetzen]] verlangt dasselbe — *„nie allein; immer was
passiert und was verloren gehen kann"* —, aber **nur fuer den Chat**. In
einer Datei durfte eine Kennung weiter fuer sich stehen. Die Lehre hat ihren
Geltungsbereich an der Stelle gezogen, an der Gregor sie damals gemeldet
hatte, nicht an der Stelle, an der der Mangel entsteht.

[[ueberall-heisst-ueberall]] ist der zweite Teil von Gregors Satz und hat
ebenfalls nicht von selbst gefeuert: die erste Reaktion war eine Antwort zu
**A-1**. Dass der Befund die **Klasse** meinte, musste er nachschieben.

## How to apply

1. **Jeder offene Punkt endet mit dem Rest, nicht mit dem Status.** Ein bis
   drei Saetze, mit Datei und Zeile, wo es sie gibt.
2. **Die Probe ist die Frage eines Fremden:** *„was mache ich morgen frueh
   als Erstes, wenn ich diesen Punkt uebernehme?"* Steht die Antwort nicht
   da, fehlt sie.
3. **„teilweise", „in Arbeit", „bestaetigt", „beobachtet" sind Anfaenge von
   Saetzen, keine Saetze.** Nach jedem dieser Worte kommt ein Doppelpunkt.
4. **Wenn Gregor einen Einzelfall nennt, ist der Einzelfall das Beispiel.**
   Erst die Klasse messen, dann antworten — sonst kommt *„mir geht es nicht
   nur um A-1"* hinterher ([[ueberall-heisst-ueberall]]).
5. **Die dritte Spalte wird erzeugt, nicht gepflegt** — sie kommt aus
   `Intern/BEFUNDE.md`, damit sie nicht die naechste handgefuehrte Zweitliste
   wird ([[liste-aus-einer-quelle]]).
