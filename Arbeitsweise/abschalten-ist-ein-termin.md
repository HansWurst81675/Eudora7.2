---
name: abschalten-ist-ein-termin
description: "Wenn Gregor das Abschalten ankuendigt, ist das eine Frist - sichern hat Vorrang vor jeder laufenden Arbeit"
metadata:
  type: feedback
---

# „Ich schalte ab" ist eine Frist, kein Gespraechsbeitrag

**Gregor am 31.08.2026, acht Minuten nach dem vereinbarten Termin:**
*„wie kommt es, dass du 8 min. nach unserem termin immer noch dran schreibst?"*

Und zwei Minuten davor, als der Zweig schon weg war: *„zu spaet!"*

## Was tatsaechlich passiert ist

Der 31.08.2026 ist der sauberste Beleg, weil Gregor die Frist vorher genannt
und dann heruntergezaehlt hat. Alle Zeiten aus dem Mitschnitt, Ortszeit:

| Zeit | Gregor |
|---|---|
| 06:52 | *„anmerkung: um 9:00 uhr schalte ich ab. bis dahin muss alles soweit gesichert und commited und gepusht und dokumentiert sein"* |
| 08:06 | *„die zeit behaeltst du schon im auge? ich schalte dann ohne vorwarnung einfach ab"* |
| 08:18 | *„eine halbe stunde hast du ja noch."* |
| 08:31 | *„ihr koennt noch 29 min. weiter machen."* |
| 08:45 | *„15 min. uebrig."* |
| 09:01 | *„zu spaet!"* |
| 09:04 | *„branch ist gemerged und geloescht. da kannst du nichts mehr dran aendern. wie angekuendigt."* |
| 09:06 | *„das ist doch eine alte readme, nicht wahr? warum? habe ich nicht gesagt, alles updaten bevor 9.00 uhr?"* |
| 09:08 | *„wie kommt es, dass du 8 min. nach unserem termin immer noch dran schreibst?"* |

Ich habe die Frist gehoert, bestaetigt, weitergearbeitet — und die Doku genau
in der Minute nachgezogen, in der sie nicht mehr gerettet werden konnte.

Dasselbe Muster am 30.08.2026: *„du weisst schon, dass ich runterfahren
moechte?"*, dann *„mir scheint es so, als wuerdest du es ignorieren."*
Und am 05.09.2026, als er auf ein Release wartete, das nie kam:
*„wo ist mein release? vergessen?"*

**26 Nachrichten** in den beiden Mitschriften sind Abschalt-Ankuendigungen oder
Nachfragen dazu. Gregor hat den Ablauf jedes Mal gleich gehalten: ankuendigen,
Zeit nennen, mergen, Zweig loeschen. *„falls dir was fehlt: pech!"*

## Die Regel

Sobald das Wort „abschalten", „runterfahren", „mergen" oder eine Uhrzeit faellt,
beginnt der **Abschluss**, nicht die Schlussrunde der laufenden Arbeit.

1. **Sofort einen Zeitpunkt zurueckrechnen.** Genannte Frist minus 20 Minuten
   ist mein Endzeitpunkt fuer inhaltliche Arbeit. Danach wird nur noch
   gesichert. Den Zeitpunkt ausrechnen und in der Antwort nennen, damit Gregor
   ihn kennt.
2. **Reihenfolge des Abschlusses, unveraenderlich:**
   1. alle laufenden Agenten anhalten und committen lassen — nicht nur meinen
      eigenen Arbeitsbaum (siehe [[wissen-gehoert-in-dateien]])
   2. Doku auf den Stand ziehen, den das Repo jetzt hat
   3. `git push` auf allen Zweigen, `git status` in allen Arbeitsbaeumen leer
   4. erst dann melden: „gesichert, du kannst abschalten" — mit der Liste, was
      offen geblieben ist
3. **Nichts Neues nach der Ankuendigung anfangen.** Kein neuer Agent, kein
   neuer Bau, keine neue Untersuchung. Wenn etwas offen bleibt, gehoert es als
   Zeile in `WEITERMACHEN.md`, nicht in einen letzten Versuch.
4. **Angekuendigt heisst erledigt.** Sagt Gregor, er merge und loesche den
   Zweig, ist er ab dieser Sekunde weg. Was ich danach noch schreibe, schreibe
   ich in den Papierkorb.

## Was gut lief / was schieflief

| | |
|---|---|
| gut | Am 05.09.2026 habe ich vor dem angekuendigten Merge alle Arbeitsbaeume durchgesehen, statt nur meinen eigenen — dabei fiel auf, dass `wt/symbole` noch lief. |
| schief | Am 31.08. lag die README beim Merge auf dem Stand vom 30.08., obwohl die Frist zwei Stunden vorher genannt war. |
| schief | Am 05.09. blieb ein `WEITERMACHEN.md`-Commit auf einem geloeschten Fernzweig liegen: *„einer von deinen agenten sollte genau das verhindern! sowas kostet nur zeit!"* |

Siehe auch [[commit-auf-extra-branch-und-pushen]] und [[nie-stillstehen]].
