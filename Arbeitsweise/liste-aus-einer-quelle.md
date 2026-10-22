---
name: liste-aus-einer-quelle
description: "Wer dieselbe Liste zweimal von Hand fuehrt, fuehrt sie einmal falsch - die Liste \"Noch offen\" im CHANGELOG nannte am 22.10.2026 fuenf Befunde als offen, die in ihrer EIGENEN Statusspalte \"behoben\" sagten, und zehn offene fehlten ganz"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-22T12:05:00.000Z
---

Schranke: `tools/offene-befunde.pl` erzeugt seit dem 22.10.2026 **beide** Listen — `Intern/WEITERMACHEN.md` und `CHANGELOG.md` — aus derselben Quelle `Intern/BEFUNDE.md` und weist ab, sobald eine der beiden abweicht. Gegenprobe: eine Kennung im CHANGELOG-Block verfaelscht, Rueckgabe 1; der alte Ausstieg bei deckungsgleichen Kennungen kam dabei gruen zurueck und wurde entfernt.

# Eine Liste kommt aus einer Quelle oder gar nicht

**Regel.** Eine Angabe, die an zwei Stellen stehen muss, wird an **einer**
gepflegt und an der anderen **erzeugt**. Nicht „an beiden Stellen
berichtigen" — das ist [[doku-parallel-nicht-hinterher]] und haelt genau
einen Arbeitsschritt lang. Gregor am 22.10.2026:

> *„das datum steht also genau einmal richtig an einer stelle, sonst nicht."*

## Was passiert ist (22.10.2026)

Gregor, nach einem Blick auf den Abschnitt „Noch offen":

> *„alles, was als ‚offen' markiert ist, ist wahr? die direktive ‚keine
> luegen auf main' gilt immer noch und sollte von dir immer eingehalten
> werden. im moment sehe ich es nicht!"*

Gemessen an derselben Datei:

| | |
|---|---|
| **Fuenf Befunde als offen gefuehrt, die in ihrer eigenen Statusspalte „Behoben" sagten** | E-112, E-115, E-117, E-118, E-68 |
| **Zehn offene Befunde fehlten ganz** | die Liste war von Hand gepflegt und seit mehreren Releases nicht nachgezogen |

Die Liste widersprach also nicht einer fernen Quelle, sondern **sich
selbst, auf derselben Seite**.

Am selben Tag der zweite Fall, von Gregor in `ZIEL.md:75` gefunden:
**E-86 stand als offen, obwohl seit 7.2.0.55 behoben** und in
`Intern/BEFUNDE.md` mit Messung und Gegenprobe als behoben eingetragen.

**Und der Rest des Bestands, nachgezaehlt:** `Intern/AUFGABEN.md` nannte
einmal vier wartende Behebungen, von denen drei bestaetigt waren; die
Lehrentabelle fuehrte 27 von 56 Lehren; `tools/RELEASES.md` kannte ein
Release von elf. **Jede handgepflegte Zweitliste dieses Projekts war am
Ende falsch — ohne eine einzige Ausnahme.**

## Warum keine Schranke es gefangen hat

Fuer genau diesen Fall gibt es `tools/pruefe-befundurteile.pl`: kein
Dokument darf einen Befund anders einstufen als `Intern/BEFUNDE.md`. Sie
schwieg, und das ist gemessen:

- Die Gegenrichtung („behoben, aber anderswo als unerledigt gefuehrt") haengt
  an der Wortliste `@unerledigt`. Sie hat **acht Eintraege** — `nicht
  angewandt`, `nicht begonnen`, `liegt bereit`, `liegt nur bereit`, `bleibt
  liegen`, `bleibt unangewendet`, `wartet auf`, `noch nicht beurteilt` —
  und **„offen" ist keiner davon.**
- Das Wort nachzutragen hilft nicht: es erzeugte **78 Treffer**, fast alle
  berechtigte Fassungsgeschichte. In den geprueften Dokumenten steht
  „offen" **247 mal**. Eine Schranke mit dieser Fehlalarmrate wird
  abgeschaltet ([[schranke-gehoert-in-den-haken]]).

Das ist der eigentliche Befund: **die zweite Liste laesst sich nicht
zuverlaessig pruefen, weil ihre Sprache dieselbe ist wie die der
Geschichtsschreibung.** Pruefbar ist nur, ob sie ueberhaupt von Hand
gefuehrt wird.

## How to apply

1. **Bevor eine Angabe ein zweites Mal aufgeschrieben wird, die Frage:
   welche Stelle ist die Quelle?** Die andere bekommt einen erzeugten Block
   zwischen zwei Marken (`<!-- offene-befunde: Anfang -->` …) und wird nicht
   mehr angefasst.
2. **Ein erzeugter Block braucht einen Vergleich, keinen Schreibvorgang
   allein.** Das Werkzeug muss ohne Schalter **abweisen**, wenn der Block
   nicht auf dem Stand ist; sonst wirkt es erst, wenn jemand daran denkt.
3. **Kein fruehzeitiger Ausstieg.** `offene-befunde.pl` stieg bis zum
   22.10.2026 aus, sobald die **Kennungslisten** deckungsgleich waren — und
   war damit blind fuer jede Aenderung am Inhalt und fuer das zweite Ziel.
   Ein Vergleich, der nur einen Teil des Blocks anfasst, ist keiner.
4. **Eine Zweitliste, die sich nicht erzeugen laesst, wird geloescht und
   durch einen Verweis ersetzt.** Ein Verweis veraltet nicht.
5. **Die Probe heisst: welchen Wert aendere ich, damit beide Stellen sich
   mitaendern?** Gibt es keinen, sind es zwei Wahrheiten
   ([[einigkeit-ist-kein-beweis]]).
