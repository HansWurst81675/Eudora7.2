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
