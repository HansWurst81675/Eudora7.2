---
name: befund-gegen-die-quelle-lesen
description: Widerlegt wird der Prueferbericht, nicht die Zusammenfassung in BEFUNDE.md - aus "Block 4a ist tot" war "der Kern ist tot" geworden, und daran haette eine Auslieferung gehangen
metadata:
  node_type: memory
  type: feedback
---

Schranke: keine - ob eine Zusammenfassung ihren Ursprungsbericht richtig wiedergibt, laesst sich nicht mechanisch pruefen; dazu muesste das Werkzeug beide Texte verstehen. Der Ausloeser ist die Lage: wer einen Punkt aus einem PRUEFER- oder LEKTOR-Bericht fuer widerlegt erklaert, schlaegt vorher Befunde/<ROLLE>-NN.md auf.



# Ich habe meine eigene Zusammenfassung widerlegt, nicht den Befund

Am 23.10.2026 stand in `Intern/BEFUNDE.md` zu [[E-101]] als letzter offener
Punkt F2:

> *„`StripTabooHeaders` entfernt die `Content-Type`-Zeile, bevor der Kern sie
> setzen kann; auf dem einzigen Aufrufweg ist **er** damit tot."*

Ich habe die Reihenfolge nachgemessen — `StripTabooHeaders` in
`tocview.cpp:3138`, der Kern in `:3186`, also **danach** — und F2 für
widerlegt erklärt. Dadurch meldete `tools/pruefe-datenverlust.pl` *„Kein
offener Weg. Ein Paket darf gebaut werden."* **An dieser Drehung hing eine
Auslieferung.**

In `Befunde/PRUEFER-37.md:41` steht F2 aber so:

> *„Der ganze neue **Block 4a** ist auf dem einzigen Aufrufweg **tot**"* —
> Schwere: *„hoch (Wirkung), **kein Schaden**"*

**Nicht „der Kern", sondern „Block 4a"** — die F1-Behebung in
`msgutils.cpp:4276-4390`. Und derselbe Bericht nennt den Ergänzungszweig
bereits selbst (`:248`): *„das tut schon der zweite Teil (`:4418-4426`), weil
nach dem Taboo-Schnitt keine `Content-Type`-Zeile mehr da ist."*

**Der PRÜFER kannte die Reihenfolge also und hatte sie aufgeschrieben.** Meine
Messung war richtig, meine Folgerung wertlos: sie traf einen Satz, den ich
selbst zu eng abgeschrieben hatte. F2 besteht fort.

**Why:** Eine Zusammenfassung verliert genau das, was sie zusammenfasst. Aus
„ein Block läuft nie" wurde „der Kern ist tot" — ein Satz, der sich leicht
widerlegen lässt, weil er falsch ist. Wer die Zusammenfassung widerlegt, hält
den Befund für erledigt und übersieht, dass die Schwere („kein Schaden")
und der eigentliche Mangel (225 Zeilen ohne Wirkung) nie bestritten waren.

Dass das Paket trotzdem gebaut werden durfte, lag an etwas ganz anderem: der
Riegel hing an **P-28** in derselben Tabellenzeile, und P-28 ist seit
7.2.0.69 behoben und in 23 Fällen gegengeprüft. **Das richtige Ergebnis aus
der falschen Begründung** — der unangenehmste Ausgang, weil er sich wie
Bestätigung anfühlt.

**How to apply:**

- **Vor jeder Urteilsdrehung den Ursprungsbericht öffnen.** Steht in der
  Urteilsspalte „F2", „K3", „L-44.14", dann ist `Befunde/<ROLLE>-NN.md` die
  Quelle, nicht der Satz daneben ([[vor-dem-code-die-pruefberichte]]).
- **Die Schwere mitlesen.** PRÜFER-37 schreibt zu F2 „kein Schaden". Das
  allein hätte gezeigt, dass F2 den Datenverlust-Riegel nie begründet hat —
  und die ganze Übung wäre eine andere gewesen.
- **Wenn an einer Urteilsdrehung eine Auslieferung hängt, einen zweiten Leser
  darauf ansetzen — mit dem Auftrag zu widerlegen, nicht zu bestätigen.** Am
  23.10.2026 hat genau das gegriffen: LEKTOR hat die Begründung umgeworfen,
  das Urteil bestätigt und zwei neue Befunde mitgebracht
  ([[gegenprobe-umdrehen]]).
