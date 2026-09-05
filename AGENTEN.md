# Wie Agenten zusammenarbeiten, ohne sich zu behindern

Am 05.09.2026 liefen bis zu acht Agenten gleichzeitig an diesem Baum. Sie haben
viel geschafft — E-4, E-12, Z-2b, die Statusleiste, zwei Prüfberichte an einem
Abend. Sie haben sich dabei aber **fünfmal gegenseitig behindert**, und jedes
Mal auf eine andere Weise.

Gregor: *„überlege dir, wie du die arbeit der agenten in zukunft koordinieren
kannst, ohne daß sie sich gegenseitig blockieren und dinge kaputt machen!"*

Diese Datei ist die Antwort. Sie beschreibt keine guten Vorsätze, sondern
Verfahren — nach der Lehre dieses Projekts: **eine Regel, die nur als Grundsatz
existiert, feuert nicht.**

---

## Die fünf Kollisionen, gemessen

| # | Art | Was passierte |
|---|---|---|
| 1 | **Raum** | Zwei Agenten bekamen denselben Arbeitsbaum. Der zweite wechselte den Branch und löschte die unversionierte Arbeit des ersten. |
| 2 | **Zeit** | Sechs Agenten bauten gleichzeitig: 28 MSBuild-Prozesse. Ein Debug-Bau stieg von 2 auf 14 Minuten. |
| 3 | **Zusammenführung** | Alle hängten ihre Befunde ans Ende von `BEFUNDE.md`. Jede einzelne Zusammenführung endete im Konflikt — viermal derselbe Handgriff. |
| 4 | **Namensraum** | KONTO und FORTSCHRITT wählten unabhängig „die nächste freie E-Nummer" und nahmen beide `E-12`. |
| 5 | **Doppelarbeit** | BEENDEN und ich haben E-4 unabhängig voneinander behoben. Beide Fassungen waren richtig, eine war überflüssig. |

Keine davon ist ein Fehler der Agenten. Alle fünf sind Fehler der **Zuteilung**
— und die liegt bei mir.

---

## 1. Raum: ein Arbeitsbaum gehört genau einem Agenten

**Verfahren:** vor jeder Zuteilung

```bash
perl tools/arbeitsbaum-frei.pl --neu KONTO
```

Das Werkzeug legt den Baum an, bucht ihn im Verzeichnis unter
`.git/agenten-zuteilung` und gibt Pfad und Branch aus. **Beides gehört wörtlich
in den Auftrag**, zusammen mit der Auflage: nur in diesem Baum arbeiten, am Ende
committen **und** pushen.

Nach dem Rücklauf:

```bash
perl tools/arbeitsbaum-frei.pl --freigeben KONTO
```

**Warum ein Verzeichnis nötig ist:** aus dem Dateisystem lässt sich „hier
arbeitet jemand" nicht ablesen. Die erste Fassung des Werkzeugs meldete prompt
zwei Bäume als frei, in denen gerade gearbeitet wurde — sie hatten nur noch
nichts geschrieben.

Das Werkzeug nennt außerdem **namentlich**, welche unverfolgten Dateien ein
Branchwechsel vernichten würde. Das sind fast immer Prüfberichte.

---

## 2. Zeit: Bauten laufen nacheinander, nicht gleichzeitig

Ein Bau dieser Projektmappe braucht auf dieser Maschine **rund zwei Minuten**,
wenn er allein läuft. Sechs gleichzeitige Bauten machen daraus 14 Minuten je
Bau — sie sind nicht langsamer geworden, sie warten aufeinander.

**Verfahren:**

- Im Auftrag steht `-m` **nicht** drin, wenn mehr als zwei Agenten laufen.
- Agenten, deren Aufgabe keinen Bau braucht (Prüfen, Lesen, Dokumentation),
  bekommen ausdrücklich die Auflage, **nicht zu bauen**.
- Ich baue am Ende **einmal** für alle, nachdem zusammengeführt ist. Das ist
  ohnehin der einzige Bau, der zählt: der über den zusammengeführten Stand.

Ein Agent, der seine Änderung nicht selbst baut, kann sie nicht selbst prüfen —
das ist der Preis. Er ist bezahlbar, solange **ich** am Ende baue und das
Ergebnis gegen seine Zusage messe.

---

## 3. Zusammenführung: niemand schreibt in eine gemeinsame Datei

Das war der teuerste Punkt. `BEFUNDE.md` ist eine Datei, an die alle anhängen —
also kollidieren alle, jedes Mal, an derselben Stelle.

**Verfahren: jeder Agent schreibt seine eigene Datei.**

```
Befunde/KONTO.md
Befunde/ZEICHEN.md
Befunde/BEENDEN.md
```

Am Ende führt ein Werkzeug sie zusammen:

```bash
perl tools/befunde-einsammeln.pl            # zeigt, was anliegt
perl tools/befunde-einsammeln.pl --anhaengen
```

**Konflikte sind damit strukturell unmöglich** — zwei Agenten fassen nie
dieselbe Datei an. Dasselbe gilt für `AUFGABEN.md`, `PORTIERUNG.md`,
`WEITERMACHEN.md` und `README.md`: **Agenten ändern sie nicht.** Wer etwas
mitzuteilen hat, schreibt es in seine eigene Datei; das Einarbeiten ist ein
eigener Auftrag (LEKTOR) und läuft **allein**, wenn die anderen fertig sind.

---

## 4. Namensraum: Kennungen vergebe ich, nicht der Agent

Ein Agent kann nicht wissen, welche Nummer frei ist — der Nachbar schreibt
gleichzeitig. `E-12` wurde deshalb zweimal vergeben.

**Verfahren:** die Kennung steht **im Auftrag**. Ich reserviere sie vor dem
Start:

```bash
perl tools/befunde-einsammeln.pl --naechste E    # nennt die nächste freie
```

Wenn ich mehrere Agenten gleichzeitig starte, vergebe ich einen Block: KONTO
bekommt `E-12`, ZEICHEN `E-13`, BEENDEN `E-14`. Jeder benutzt seine und keine
andere.

---

## 5. Doppelarbeit: die Zuteilung wird aufgeschrieben, bevor sie beginnt

BEENDEN und ich haben denselben Fehler behoben, weil ich nach seinem Start
selbst weitergesucht habe. Das Ergebnis war zweimal richtig und einmal umsonst.

**Verfahren:** Die Buchung trägt die Aufgabe, nicht nur den Namen:

```
C:/.../Eudora7.2-wt-konto    KONTO    Kontodialog zeigt leere Felder (E-12)
```

Und die Regel für mich selbst: **wenn ein Agent an einer Sache sitzt, arbeite
ich nicht daran mit.** Was ich finde, geht per Nachricht an ihn — das ist
schneller als eine zweite Behebung und kollidiert nicht. Heute hat genau das
funktioniert: Gregors Bildschirmfoto hat die Ursache von E-4 gezeigt, ich habe
sie an BEENDEN geschickt, und er hat sie gründlicher behoben, als ich es getan
hatte.

---

## Was gut lief und bleibt

- **Namen statt Nummern.** KONTO, ZEICHEN, BEENDEN, FORTSCHRITT, PRUEFER —
  man weiß sofort, wer woran sitzt.
- **Auftrag mit Fundstellen.** Je genauer der Auftrag (Datei, Zeile, Befund,
  bekannte Fallen), desto besser das Ergebnis. Die Aufträge, die eine konkrete
  Hypothese *und* die Aufforderung enthielten, sie zu widerlegen, haben die
  besten Ergebnisse gebracht — ZEICHEN und FORTSCHRITT haben beide meine
  Hypothese widerlegt und die echte Ursache gefunden.
- **Nachrichten an laufende Agenten.** Neue Erkenntnisse gehen sofort hin,
  statt auf den Rücklauf zu warten.
- **Auflagen im Auftrag**, jedes Mal: kein Fenster starten, byte-erhaltend
  arbeiten, Zeilenenden messen, committen und pushen, Gregors Testverzeichnis
  nur lesen.

---

## Die Reihenfolge einer Runde

1. **Aufgaben schneiden** — möglichst so, dass zwei Agenten nie dieselbe
   Quelldatei anfassen. Geht das nicht, laufen sie nacheinander.
2. **Bäume buchen und Kennungen vergeben**, je Agent einer, im Auftrag genannt.
3. **Starten.** Prüf- und Doku-Agenten mit der Auflage, nicht zu bauen.
4. **Erkenntnisse weiterreichen**, statt selbst mitzuarbeiten.
5. **Einsammeln**: Befunddateien zusammenführen, Zweige in Abhängigkeitsreihen-
   folge zusammenführen.
6. **Einmal bauen**, Release und Debug, und die Zusagen der Agenten nachmessen.
7. **LEKTOR allein** über die Dokumentation laufen lassen.
8. **Freigeben**: `arbeitsbaum-frei.pl --freigeben`, und `gesichert.pl` als
   letzte Probe, dass nichts uncommittet oder ungepusht liegenbleibt.
