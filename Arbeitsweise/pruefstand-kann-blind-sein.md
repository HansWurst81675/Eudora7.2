---
name: pruefstand-kann-blind-sein
description: "Ein kaputter und ein gruener Pruefstand melden im Alltag dasselbe, naemlich nichts - die Pruefinstanz braucht ihre eigene Schranke"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T19:14:56.428Z
---

Schranke: tools/pruefe-testbau.pl (pre-push) - weist ab, wenn sich EudoraTests.exe nicht bauen laesst; nicht bei roten Tests. Gegengetestet mit --selbsttest (7 Faelle in beide Richtungen) und am echten Fehler im echten Bau.

## Was passiert ist

Vom **10.09.2026 bis zum 13.09.2026** liess sich die Testsammlung nicht bauen,
und drei Tage lang hat es niemand gemerkt.

Commit `3acb82f` vom 10.09.2026 setzte eine Spurmarke zu E-76 in `OTShim.cpp`
und rief dafuer `PutDebugLog` auf. Die Funktion liegt in QCUtils; QCUtils
gehoert nicht zum Testprojekt, aber `Tests.vcxproj` uebersetzt
`..\OTShim\OTShim.cpp` direkt mit. Ergebnis:

```
OTShim.obj : error LNK2019: Verweis auf nicht aufgeloestes externes Symbol
"void __cdecl PutDebugLog(unsigned long,char const *,int)"
```

Kein `EudoraTests.exe`. **Folgen:** die Schranken vom 13.09.2026 sind nie
gegen die Tests gefahren, und zwei rote Tests blieben drei Tage unsichtbar.

## Why — warum die vorhandene Lehre nichts genuetzt hat

[[tests-vor-jedem-commit-laufen-lassen]] steht seit dem **28.08.2026** im
Verzeichnis und ist eindeutig formuliert. Sie hat trotzdem nicht gewirkt, und
der Grund ist nicht Nachlaessigkeit:

**Ein kaputter Pruefstand und ein gruener Pruefstand melden im Alltag
dasselbe, naemlich nichts.** Wer die Tests nicht laufen laesst, sieht keinen
Unterschied. Wer sie laufen laesst, sieht einen Baufehler — aber die Lehre
verlangte einen Handgriff, den nichts ausgeloest hat.

Ihre Schranke-Zeile lautete wortwoertlich: *„keine — kein Hook ruft die
Testsammlungen auf"*. Das war ehrlich und beschrieb genau die Luecke, durch
die der Fehler dann drei Tage lang gefallen ist. **Eine begruendete Ausnahme
ist kein Freibrief, sondern eine offene Rechnung** ([[fehlerklassen-abstellen]]).

Der zweite Grund ist die Bauart der uebrigen fuenfzehn Hook-Schranken: alle
lesen statisch Quelltext mit Perl und sind in Sekundenbruchteilen fertig.
Keine einzige **baut** etwas. Damit war der Bau selbst der einzige Bereich
ohne Waechter — und ausgerechnet dort sass der Schaden.

## Was es kostet — die Frage, die vorher nie gestellt wurde

Am 13.09.2026 gemessen: **17,7 Sekunden** fuer Bau **und** Lauf der gesamten
Sammlung aus dem kalten Stand, 120 Tests. Der reine Bau liegt darunter.

Damit gibt es keinen Kostengrund, der die Luecke rechtfertigt. Die Schranke
haengt jetzt im **pre-push** statt im pre-commit: einmal je Zweig ist billig,
einmal je Commit waere laestig — und eine laestige Schranke wird umgangen,
womit sie auch den Baufehler nicht mehr faengt.

## How to apply

* **Die Pruefinstanz braucht ihre eigene Schranke.** Bei allem, was Fehler
  finden soll — Tests, Spurmarken, Protokolle, Schranken selbst — ist
  „meldet nichts" zweideutig. Es muss einen Weg geben, auf dem sich „laeuft
  und ist still" von „laeuft gar nicht" unterscheiden laesst.
* **Die Schranke weist beim Baufehler ab, nicht bei roten Tests.** Ein roter
  Test ist ein Ergebnis, kein Grund, einen Push zu verweigern — am
  13.09.2026 waren zwei Tests rot, waehrend an E-85 gearbeitet wurde. Wer
  rote Tests abweist, bringt mich dazu, die Schranke zu umgehen.
* **Eine Schranke-Zeile „keine — weil es keinen Hook gibt" ist eine offene
  Rechnung, keine Ausnahme.** Ausnahmen sind Faelle, die sich nicht
  mechanisch pruefen lassen. „Es hat noch niemand gebaut" ist etwas anderes.
* **Vor dem Haengen gegentesten, in beide Richtungen** — dazu unten mehr, es
  hat sich hier sofort ausgezahlt.

## Was beim Bau dieser Schranke passiert ist — zwei Fehlalarme in zehn Minuten

Beide haetten jeden Push im Projekt abgewiesen, und beide sind nur aufgefallen,
weil der Gegentest gegen den **heilen** Stand gefahren wurde
([[schranke-gegentesten]]):

1. Die Schranke rief MSBuild mit `/p:Configuration=Debug` auf — so wie
   `RunTests.cmd` es tut. `RunTests.cmd` laeuft aber von `cmd.exe`, die
   Schranke vom git-Hook und damit aus einer **MSYS-Shell**. Die schreibt
   jedes Argument, das mit `/` beginnt, in einen Windows-Pfad um. MSBuild
   antwortete mit *„Informationen zur Schaltersyntax erhalten Sie…"*, die
   Schranke urteilte „baut nicht". Gemessen: `/p:` Rueckgabe 1, `-p:`
   Rueckgabe 0, **gleicher Stand**.
2. Die erste Ursachenvermutung dazu war **falsch** — ein `-f` auf den
   MSBuild-Pfad hatte „gibt es nicht" gemeldet, und daraus wurde auf
   Backslashes geschlossen. Nachgemessen sagte `-f` fuer beide Schreibweisen
   „da": die erste Messung war selbst durch eine Backslash-Zerstoerung in der
   Bash verfaelscht ([[text-nicht-durch-schichten-schicken]], zehnter Fall am
   selben Tag). Die darauf gebaute Korrektur war wirkungslos
   ([[pruefen-statt-vermuten]]).

Der echte Gegentest bestand dann aus drei Laeufen: heiler Stand → laesst durch;
Attrappe ausgebaut → weist ab, mit **wortgleicher** LNK2019-Meldung wie am
10.09.2026; zurueckgesetzt → laesst durch.

## Was am 13.09.2026 gut lief — der Beleg, dass der Ansatz traegt

Drei Schranken haben an diesem Tag echte Fehler gefangen, **bevor** sie auf
main kamen. Das gehoert genauso festgehalten wie die Fehlgriffe:

| Schranke | Was sie gefangen hat |
|---|---|
| `tools/pruefe-bytes.pl` | ein **Mojibake im CHANGELOG** — genau die lautlose Klasse, die man von Hand nie findet |
| `tools/pruefe-doku-takt.pl` | ein veralteter Abschnitt **„Noch offen"** — haette das Paket gesperrt |
| `tools/rollen-faellig.pl` | **genau die drei Rollen** waren ueberfaellig, und Gregor fragte im selben Moment: *„machst du wieder alles allein?"* |

Der Unterschied zu den Lehren, die nicht gewirkt haben, ist **nicht** der
Inhalt, sondern der Auslöser: diese drei haengen im pre-commit bzw. in
`paket-bauen.ps1` und fragen niemanden um Erlaubnis. `rollen-faellig.pl` hat
Gregors Frage nicht nur vorweggenommen, sondern denselben Befund mechanisch
erzeugt — das ist der Zielzustand aus
[[daueraufgaben-brauchen-einen-takt]].

Verwandt: [[lehren-anwenden-nicht-nur-schreiben]] — eine Lehre ohne Auslöser
wirkt nicht. [[eingebaute-messung-auslesen]] ist derselbe Gedanke eine Ebene
tiefer: eine Spurmarke, die niemand ausliest, ist keine Messung. Hier war es
ein Pruefstand, den niemand gestartet hat.
