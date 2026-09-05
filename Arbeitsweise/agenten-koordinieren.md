---
name: agenten-koordinieren
description: "Fünf Kollisionsarten paralleler Agenten und das Verfahren gegen jede; die Zuteilung ist meine Aufgabe, nicht die der Agenten"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-05T18:44:11.670Z
---

**Das Verfahren steht in [AGENTEN.md](AGENTEN.md) im Repo. Vor jeder Runde
paralleler Agenten lesen und befolgen.**

Gregor am 05.09.2026: *„du mußt deine agenten besser koordinieren, damit nichts
verloren geht! das ist wichtig. jedes mal. bei jeder session!"* und *„schreib es
dir auf! und merke es dir. und befolge es bei der nächsten session! du mußt
immer dazu lernen."*

**Why:** An einem Abend liefen bis zu acht Agenten. Sie haben viel geschafft,
sich aber **fünfmal** behindert — jedes Mal anders. Keine davon war ein Fehler
der Agenten; alle fünf waren Fehler der Zuteilung, und die liegt bei mir.

| Art | Was passierte |
|---|---|
| **Raum** | Zwei Agenten bekamen denselben Arbeitsbaum. Der zweite wechselte den Branch und löschte die unversionierte Arbeit des ersten. |
| **Zeit** | Sechs bauten gleichzeitig: 28 MSBuild-Prozesse, ein Debug-Bau stieg von 2 auf 14 Minuten. |
| **Zusammenführung** | Alle hängten Befunde ans Ende von `BEFUNDE.md`. Jede Zusammenführung endete im Konflikt — viermal derselbe Handgriff. |
| **Namensraum** | Zwei wählten unabhängig „die nächste freie E-Nummer" und nahmen beide `E-12`. |
| **Doppelarbeit** | Ein Agent und ich haben denselben Fehler behoben. Beide Fassungen richtig, eine umsonst. |

**How to apply — die fünf Antworten:**

1. **Ein Baum je Agent.** `perl tools/arbeitsbaum-frei.pl --neu NAME` legt an
   und bucht; Pfad und Branch **wörtlich in den Auftrag**. Nach dem Rücklauf
   `--freigeben NAME`. Das Verzeichnis ist nötig, weil aus dem Dateisystem
   nicht ablesbar ist, ob dort jemand arbeitet — die erste Fassung des
   Werkzeugs meldete prompt zwei benutzte Bäume als frei.
2. **Bauten nacheinander.** Prüf- und Doku-Agenten bekommen die Auflage, **nicht
   zu bauen**. Ich baue einmal am Ende über den zusammengeführten Stand — das
   ist ohnehin der einzige Bau, der zählt.
3. **Niemand schreibt in eine gemeinsame Datei.** Jeder Agent schreibt
   `Befunde/<NAME>.md`; `BEFUNDE.md`, `AUFGABEN.md`, `README.md`,
   `WEITERMACHEN.md`, `PORTIERUNG.md` fasst **kein** Agent an. Das Einarbeiten
   ist ein eigener Auftrag (LEKTOR) und läuft **allein**, wenn die anderen
   fertig sind. Damit sind Konflikte strukturell unmöglich.
4. **Kennungen vergebe ich**, im Auftrag genannt, bei mehreren als Block
   (KONTO `E-12`, ZEICHEN `E-13`, …). Ein Agent kann nicht wissen, was frei ist.
5. **Die Buchung trägt die Aufgabe, nicht nur den Namen.** Und: sitzt ein Agent
   an einer Sache, **arbeite ich nicht mit**. Was ich finde, geht per Nachricht
   an ihn. Das hat funktioniert — Gregors Bildschirmfoto zeigte die Ursache von
   E-4, ich schickte sie an den Agenten, und er behob sie gründlicher als ich.

**Was gut lief und bleibt:** deutsche Namen statt Nummern; Aufträge mit
Fundstelle, Hypothese **und** der Aufforderung, die Hypothese zu widerlegen
(zwei Agenten haben meine widerlegt und die echte Ursache gefunden);
Nachrichten an laufende Agenten statt Warten auf den Rücklauf; die festen
Auflagen in jedem Auftrag (kein Fenster starten, byte-erhaltend, Zeilenenden
messen, committen **und** pushen, Gregors Testverzeichnis nur lesen).

Siehe [[agenten-benennen]], [[agenten-trennen-worktrees]],
[[nie-stillstehen]], [[fehlerklassen-abstellen]] und
[[main-muss-immer-baubar-sein]].
