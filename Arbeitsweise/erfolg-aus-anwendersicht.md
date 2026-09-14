---
name: erfolg-aus-anwendersicht
description: "Erfolg wird daran gemessen, was Gregor danach tun kann; kein Crash ist keine Verbesserung"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-14T00:00:00.000Z
---

Schranke: keine - „was Gregor jetzt tun kann" ist ein Urteil über die Bedienbarkeit des laufenden Programms; kein Werkzeug kann ein Fenster bedienen und beurteilen

# Erfolg heißt: der Anwender kann etwas, was er vorher nicht konnte

**Gregor am 06.09.2026, 17:06 Uhr**, mit meiner eigenen Überschrift aus dem
`CHANGELOG.md` davor:

> *„7.2.0.18 / Paket 1.0.18 — 06.09.2026 · der Durchbruch*
>
> *für den anwender ist es kein durchbruch!"*

Elf Minuten zuvor, nachdem er das Paket selbst gestartet hatte:

> *„ich habe jetzt 0.18 selbst gestartet: ja, es crasht nicht, aber es passiert
> auch nichts.*
> *beenden kann ich es auch nicht.*
> *also kein großer fortschritt: nichts statt crash ist auch keine
> verbesserung!"*

## Was tatsächlich passiert ist

Technisch war der Tag ein guter: die Ursache des Strg-N-Absturzes war belegt —
`pg_time_t` war unter VS2022 acht Byte breit statt vier
(`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`, Commit `ae0e165`, Beleg in
`Befunde/PAIGE.md`), nach sieben widerlegten Vermutungen.

Für Gregor sah dieselbe Fassung so aus: Strg-N zeigt kein Fenster, sondern eine
**modale** Meldung „An unhandled exception has occurred", und weil sie modal
ist, lässt sich Eudora danach **nicht mehr beenden**. Gegenüber 1.0.16 war das in
einem Punkt sogar schlechter: vorher stürzte es ab und war weg, jetzt bleibt es
stehen. Das habe ich in der Überschrift „der Durchbruch" genannt.

Denselben Maßstab habe ich am selben Nachmittag ein zweites Mal verfehlt, mit
dem Satz „Alle vier Kriterien aus `ZIEL.md` sind erfüllt (06.09.2026)" im
`CHANGELOG.md` — siehe
[doku-parallel-nicht-hinterher](doku-parallel-nicht-hinterher.md).

## Die Regel

1. **Die Überschrift eines Pakets ist ein Satz über Gregor**, nicht über den
   Quelltext: *„Strg-N öffnet das Verfassen-Fenster."* Lässt sich dieser Satz
   nicht schreiben, ist die Überschrift der **Befund** — *„Ursache des
   Strg-N-Absturzes belegt: `pg_time_t`"* — und nicht „Durchbruch".
2. **Die Wörter „Durchbruch", „gelöst", „erreicht", „funktioniert" gehören
   Gregor.** Vor seinem Testbericht heißt es „belegt", „Ursache gefunden",
   „behoben, ungetestet". Sein Testbericht ist das einzige belastbare
   Messergebnis des Projekts (siehe
   [version-eindeutig-machen](version-eindeutig-machen.md)).
3. **Einen Absturz zu entfernen ist keine Verbesserung, solange die Funktion
   nicht tut.** „Kein Crash" ist eine Zwischenmessung für mich, kein Ergebnis
   für ihn.
4. **Zu jedem Paket drei Zeilen im Vergleich zum vorigen**, in seinen Worten:
   was ging vorher, was geht jetzt, **was ist schlechter geworden**. Die dritte
   Zeile wird am ehesten weggelassen und ist die wichtigste — „nicht mehr
   beendbar" hätte in 1.0.18 dort stehen müssen, und zwar von mir, nicht von
   ihm.
5. **Eine Regression wird benannt, auch wenn sie ein Nebeneffekt eines
   Fortschritts ist.** Sonst prüft Gregor sie für mich — und das kostet ihn
   einen Testlauf.

## Nachtrag 07./08.09.2026: „behoben" heißt, der Weg ist einmal gelaufen

Am 07.09.2026 habe ich E-37 (*ein Konto lässt sich nicht löschen*) als
**behoben** in die Commit-Nachricht, den `CHANGELOG.md` und `BEFUNDE.md`
geschrieben. Gregor hat sofort nachgefragt:

> *„dazu hast du wenigstens einen neuen bug erstellt, ja? sonst denkt jeder,
> das löschen ist gefixt, was nur teilweise stimmt."*

Am 08.09.2026, 07:19 Uhr, hat er es dann selbst gemessen:

> *„die meldung kommt, wenn ich eine persona gelöscht habe."*
> *„sie verschwindet links nicht, bis ich eudora geschlossen habe"*

Mein Fix rief `PopulateView()`; der Aufruf **warf** — die Meldung
„Encountered an improper argument" war meine eigene Behebung. Zur selben Zeit
stand in `ZIEL.md` von meiner Hand „Kriterium 7 ist erfüllt" und im
`CHANGELOG.md` „E-37 behoben". Übersetzt, kompiliert, alle Schranken grün —
und der Weg, um den es ging (eine Persönlichkeit löschen), war **nie einmal
durchlaufen**.

**Die Regel dazu, als Ergänzung zu Punkt 2:**

- **„Behoben" setzt einen Durchlauf voraus, keinen Bau.** Solange die geänderte
  Zeile nicht **einmal ausgeführt** wurde — belegt durch eine Spurmarke im Log,
  nicht durch ein Argument — heißt es „geändert, nicht durchlaufen".
- **Eine Behebung, die eine Meldung erzeugt, ist eine Regression**, auch wenn
  der ursprüngliche Fehler weg ist. Sie gehört in dieselbe Zeile wie der
  Erfolg, nicht in einen späteren Befund.
- **Wer „teilweise" behoben hat, schreibt den Rest sofort als eigenen Befund
  auf.** Gregors Satz nennt den Schaden genau: der Eintrag „behoben" nimmt
  jedem anderen den Anlass, noch hinzusehen.

## Nachtrag 14.09.2026: der Satz stand schon da — nur nicht vorne

**Gregor am 14.09.2026, 05:29:27 Uhr:**

> *„nennen wir es so: es läßt sich nicht beenden."*

Acht Minuten vorher, um 05:21:24 Uhr, hatte er es schon gesagt:

> *„immer noch die gleiche meldung, kann deshalb eudora nicht beenden."*

Dazwischen habe ich ihm eine Tabelle geschickt, in der E-83
**„Statuszeile hängt ewig"** hiess, und in `CHANGELOG.md` stand die
Paketüberschrift

    ## 7.2.0.53 — die Aufgabe war fertig, nicht wartend (E-83)

## Warum Regel 1 hier nicht gegriffen hat

Regel 1 oben passt wörtlich: *„Die Überschrift eines Pakets ist ein Satz über
Gregor."* Sie wurde trotzdem verfehlt, und zwar aus drei Gründen, die sich
benennen lassen:

1. **Die Überschrift nannte die Entdeckung, nicht die Wirkung.** *„Die
   Aufgabe war fertig, nicht wartend"* ist der Moment, in dem mir ein Licht
   aufging. Für Gregor ist das keine Nachricht. Je überraschender ein Befund
   für mich war, desto grösser ist der Zug, ihn in die Überschrift zu
   schreiben.
2. **Die Ausnahme in Regel 1 wurde falsch gezogen.** Dort steht: *„Lässt sich
   dieser Satz nicht schreiben, ist die Überschrift der Befund."* Der Satz
   liess sich schreiben — *„Eudora lässt sich wieder beenden"*. Es fühlte
   sich nur so an, als dürfte man ihn noch nicht sagen, weil in diesem
   Augenblick noch nicht gebaut war. Das sind zwei verschiedene Dinge: **ob
   der Satz stimmt** entscheidet der Testlauf, **wovon die Überschrift
   handelt** entscheidet der Leser.
3. **Der richtige Satz stand bereits im Text — im Nebensatz.** Die
   `BEFUNDE.md`-Zeile lautete vorher: *„eine IMAP-Aufgabe bleibt scheinbar in
   der Warteschlange stehen … **und Eudora lässt sich nicht beenden**"*. Die
   Korrektur bestand nicht darin, etwas zu finden, sondern darin, die zwei
   Hälften zu **tauschen** — der ganze Commit `9d01d82` ändert zwei Zeilen.

**Why:** Eine Überschrift ist eine Sortierentscheidung, keine
Formulierungsfrage. Was vorn steht, bestimmt, wonach als nächstes gesucht
wird ([[anzeige-ist-kein-zustand]]) und was Gregor in der Fehlerliste
wiederfindet. Der innere Satz und der äussere Satz sind beide wahr; der
Unterschied ist, wer damit etwas anfangen kann. Und die teuerste Form dieses
Fehlers ist nicht die falsche Überschrift, sondern die **richtige an zweiter
Stelle** — sie sieht beim Schreiben vollständig aus.

**Die Ergänzung zur Regel:**

- **Die Regel gilt ab dem Tag, an dem der Befund aufgemacht wird**, nicht erst
  beim Erfolgspaket. Eine Befundüberschrift ist der Satz, mit dem Gregor
  das Problem beschreiben würde.
- **Wenn Gregor das Symptom in eigenen Worten genannt hat, sind das die
  Worte.** Nicht sinngemäss — wörtlich, bis auf die Grammatik. *„kann deshalb
  eudora nicht beenden"* lag acht Minuten und eine Bildschirmaufnahme vor
  meiner Tabelle.
- **Steht der anwenderseitige Satz schon im Text, aber hinten: nach vorn.**
  Vor jeder Umformulierung wird die vorhandene Zeile daraufhin gelesen. In
  drei von vier Fällen ist die Arbeit schon getan und falsch sortiert.
- **Die eigene Entdeckung darf in den zweiten Satz.** Sie ist nicht wertlos,
  sie ist nur nicht die Nachricht. *„Eudora lässt sich wieder beenden — die
  Aufgaben waren fertig und wurden nie nachbearbeitet."*

**Warum es hier keine Schranke gibt** (die Zeile oben bleibt „keine"): ob ein
Satz aus Gregors Sicht geschrieben ist, lässt sich nicht mechanisch
entscheiden — *„die Aufgabe war fertig, nicht wartend"* enthält keinen
Bezeichner, keinen Dateinamen, keine Konstante, an denen ein Werkzeug etwas
festmachen könnte. Die **mechanisch prüfbare Hälfte** desselben Vorfalls
deckt `tools/pruefe-anzeigetext.pl` ab: sie verlangt, dass ein zitierter
Oberflächentext auf seine Quelle zurückgeführt wird. Was bleibt, ist ein
Urteil — und der Auslöser dafür ist Gregors nächste eigene Beschreibung des
Symptoms.

Siehe [was-lauffaehig-heisst](was-lauffaehig-heisst.md),
[lauffaehiges-ergebnis-liefern](lauffaehiges-ergebnis-liefern.md),
[messung-muss-den-weg-treffen](messung-muss-den-weg-treffen.md) und
[version-eindeutig-machen](version-eindeutig-machen.md).
