---
name: review-sieht-nur-den-diff
description: "Ein Diff-Review kann eine veraltete unveraenderte Datei nicht sehen; vor dem Merge wird der Bestand geprueft, nicht die Aenderung"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:28:47.513Z
---

Schranke: tools/doku-pruefen.pl (pre-commit, pre-push — prüft alle MDs, nicht die geänderten)

# Ein Review über den Diff findet die alte Lüge nicht

**Gregor am 07.09.2026, 08:15 und 08:17 Uhr:**

> *„wäre vor dem mergen wichtig, daß keine lügen im main stehen!"*
> *„das sollte ja im review auffallen, daß content nicht stimmt. wer ist
> schuld?"*
> *„wir machen ja vor jedem merge ein review"*

## Was tatsächlich passiert ist

Vor jedem Merge lief ein Review — und es hat die falschen Sätze in
`README.md`, `AUFGABEN.md` und `WEITERMACHEN.md` nicht gefunden. Der Grund ist
mechanisch, nicht nachlässig: **das Review liest den Diff.** Was ich geändert
hatte, war stimmig. Es hat nicht gefragt, ob die 44 Dateien, die ich *nicht*
angefasst habe, noch die Wahrheit sagen.

Eine Datei, die vor drei Tagen richtig war und durch einen Bau von heute falsch
wurde, steht in keinem Diff. Sie ist unverändert — und genau deshalb falsch.
Beispiel aus derselben Stunde: `WEITERMACHEN.md:10` nannte 1.0.18 als aktuellen
Stand, während `VERSION` schon 1.0.21 sagte. Niemand hatte die Zeile
angefasst; sie war einmal richtig.

**Warum:** Ein Merge nach `main` macht jede Behauptung im Zweig zur Aussage des
Projekts. Gregors Maßstab ist nicht „der Diff ist saubere Arbeit", sondern
„im `main` steht nichts Falsches". Das eine prüft Änderungen, das andere den
Bestand — und nur das Zweite ist die Zusage, die er hören will.

**Wie anwenden:**

1. **Vor jedem Merge zwei getrennte Durchgänge.** Erster Durchgang: der Diff
   (ist die Änderung richtig?). Zweiter Durchgang: der **Bestand** (sagt der
   Baum als Ganzes die Wahrheit?). Der zweite Durchgang ignoriert den Diff
   vollständig.
2. **Der Bestandsdurchgang ist ein Werkzeug, kein Lesen.** Er vergleicht die
   Werte, die mehrfach vorkommen, gegen ihre Quelle: Paketnummer gegen
   `VERSION`, Quellstand gegen `Eudora71/Version.h`, Kriterienzahl gegen
   `ZIEL.md`, genannte ZIP-Dateien gegen das Verzeichnis. Das ist
   `tools/doku-pruefen.pl`; es muss **immer** laufen, nicht nur wenn eine MD
   im Commit steht — ein Commit, der nur Quelltext ändert, ist genau der, der
   die Doku veralten lässt.
3. **Die Schranke gehört vor den Push, nicht nur vor den Commit.** Der Zweig,
   den Gregor mergt, ist die Einheit, die geprüft werden muss.
4. **„Wer ist schuld?" wird beantwortet, nicht verteilt.** Der Zuschnitt des
   Reviews ist meiner. Ein Prüfer, dem ich den Diff gebe, kann den Bestand
   nicht prüfen.

Siehe [[pruefumfang-nicht-von-hand]], [[doku-parallel-nicht-hinterher]],
[[main-muss-immer-baubar-sein]] und [[nie-direkt-auf-main]].

## Nachtrag 11.09.2026: eine Schranke, die nur den neuesten Eintrag prüft, prüft den Diff

Diese Lehre handelte bisher von **Menschen**, die den Diff lesen. Am 11.09.2026
hat eine frisch gebaute **Schranke** denselben Zuschnitt gehabt.

`tools/pruefe-doku-takt.pl` ist am Vormittag entstanden und prüfte, ob
`CHANGELOG.md` einen Abschnitt für den **aktuellen** Quellstand aus `Version.h`
hat. Sie hat noch am selben Tag zu Recht ein Paket verweigert, weil der
Abschnitt zu 7.2.0.48 fehlte. Was sie nicht sehen konnte, war der **Bestand
darüber und darunter** — und dort lagen zwei Mängel, die Gregor selbst finden
musste:

> *„reihenfolge stimmt nicht: oben 2.29 / dann 0.47 / 0.46 / ..."*

1. Ein Zwischenstandstext vom 09.09. („Nach 1.0.29 — es wird an 7.2.0.30
   gearbeitet") stand **ganz oben**, vor allen Fassungsabschnitten.
2. **7.2.0.45 fehlte als Abschnitt ganz.** Der Text dazu steckte als
   `###`-Unterabschnitt mitten in 7.2.0.44 — mein eigener Einfügefehler: ich
   hatte an `## 7.2.0.44` verankert, statt einen eigenen Fassungsabschnitt
   anzulegen.

Beide Mängel sind **unveränderte alte Zeilen**. Kein Diff zeigt sie, und eine
Prüfung, die nur nach dem neuesten Abschnitt fragt, ebenso wenig. Die Schranke
kann es seit `a788753`: Abschnitte müssen absteigend stehen, und zwischen der
jüngsten und der ältesten genannten Fassung darf keine Nummer fehlen. **Beim
ersten scharfen Lauf hat sie sofort drei weitere Lücken gefunden** — 7.2.0.36,
.37 und .38 haben Pakete, aber nie einen Abschnitt bekommen. Sie stehen jetzt
als benannte Altlast in der Schranke, damit **neue** Lücken auffallen.

**Also gehört zu Punkt 1 und 2 dieser Lehre:**

- **Eine Schranke wird danach beurteilt, ob sie den Bestand oder die Änderung
  prüft.** „Gibt es einen Abschnitt für den aktuellen Stand?" ist eine
  Diff-Frage. „Sind alle Abschnitte da und in der richtigen Ordnung?" ist eine
  Bestandsfrage. Nur die zweite hält, was der Merge verspricht.
- **Bei jeder Liste, die über die Zeit wächst** — Fassungen, Befundkennungen,
  Paketnummern — wird zusätzlich **Reihenfolge und Lückenlosigkeit** geprüft,
  nicht nur die Existenz des neuesten Eintrags. Das ist billig und fängt genau
  die Fehler, die niemand mehr ansieht.
- **Altlasten werden benannt und gezählt, nicht stillschweigend ausgenommen.**
  Drei fehlende Abschnitte stehen im Skript mit Nummer; wer sie nachträgt,
  streicht sie dort. Eine stille Ausnahme wäre wieder eine Namensliste
  ([[pruefumfang-nicht-von-hand]]).
