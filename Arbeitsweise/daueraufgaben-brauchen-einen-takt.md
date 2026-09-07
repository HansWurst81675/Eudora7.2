---
name: daueraufgaben-brauchen-einen-takt
description: "Lektor, Pruefer und Chronist laufen nach einem festen Auslaeser; wenn Gregor nach ihnen fragen muss, ist die Rolle nicht eingerichtet"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:29:37.686Z
---

# Eine Daueraufgabe ohne Auslöser läuft nicht

**Gregor am 06.09.2026, 16:28 Uhr:**

> *„das sollte ja immer und regelmäßig im hintergrund laufen, ohne daß ich dich
> daran erinnern muß. ich verlasse mich drauf, daß du es machst."*

Eine Minute später, auf meinen Satz, es gebe eine laufende Überwachung:

> *„laufende Überwachung: die sollte es bereits gebefn!"*

## Was tatsächlich passiert ist

Gregor hat in dieser Sitzung **sechsmal** nach denselben drei Rollen gefragt,
weil sie ohne seine Frage nicht liefen:

| Zeit | Gregor |
|---|---|
| 06.09. 16:36 | *„was ist mit dem chronisten? ist er fertig? hat er was neues gefunden?"* |
| 06.09. 16:50 | *„haben wir inzwischen feedback vom chronisten?"* |
| 07.09. 06:51 | *„was ist mit dem chronisten? was hat er gesammelt und festgeschrieben?"* |
| 07.09. 08:00 | *„standard frage: … findings eingepflegt? vom lektor, prüfer, chronist?"* |
| 07.09. 08:10 | *„hat der lektor und der prüfer wieder gepennt?"* |
| 07.09. 08:19 | *„nun ja, das sollte der chronist ja herausgefunden haben … hat er es nicht gemacht?"* |

Meine eigene Antwort auf die letzte Frage (07.09., 08:19) ist der Beleg:
*„nein, er hat es nicht festgeschrieben, weil ich ihn seit gestern nicht
angesetzt habe."* Die Rolle war eingerichtet, das Verzeichnis war da, die Lehre
[[lehren-anwenden-nicht-nur-schreiben]] verlangt sogar ausdrücklich einen Lauf
am Sitzungsende — gelaufen ist er nicht, weil kein Ereignis ihn gestartet hat.

**Warum:** Eine Rolle, an die Gregor erinnern muss, kostet ihn genau die Arbeit,
für die sie eingerichtet wurde. Sein Satz *„ich verlasse mich drauf"* ist eine
Zusage, die ich gegeben habe; jede seiner sechs Fragen ist ein Beleg, dass ich
sie nicht gehalten habe. Und die Rollen sind nicht dekorativ: der Lektor hätte
die veralteten Zahlen gefunden, die Gregor selbst finden musste.

**Wie anwenden — jede Daueraufgabe bekommt ein Ereignis, kein „regelmäßig":**

| Rolle | Auslöser |
|---|---|
| LEKTOR (alle MDs gegen den Bestand) | vor jedem Push eines Zweigs, den Gregor mergen soll |
| PRÜFER (Code, Tests, Messwerte) | nach jedem Bau, der Gregor als Paket erreicht |
| CHRONIST (Lehren aus dem Protokoll) | am Sitzungsende und nach jedem Tadel Gregors zur Arbeitsweise |
| `gesichert.pl` / `doku-pruefen.pl` | im Hook, also bei jedem Commit und Push |

1. **Kein „läuft im Hintergrund" ohne Startzeitpunkt.** Wenn ich es sage, muss
   ich den Auslöser nennen können, der es startet — sonst ist die Aussage
   falsch, und Gregor merkt das sofort.
2. **Wer eine Rolle einrichtet, startet sie sofort einmal.** Eine Rolle, die
   noch nie gelaufen ist, ist nicht eingerichtet.
3. **Der Rücklauf wird gemeldet, ohne dass gefragt wird** — mit Zahl: wie viele
   Dateien, wie viele Mängel, was davon behoben. Ein „der Lektor hat geschaut"
   ohne Zahl ist keine Meldung ([[mannschaft-fuehren]], Punkt 2).
4. **Gregors Standardfrage ist eine Kontrolle, kein Auftrag.** *„alles
   gesichert? alles commited? readme updated? changelog auch? findings
   eingepflegt?"* — wenn sie das erste Mal ausgelöst hat, was sie prüft, war
   der Takt nicht da.

Siehe [[mannschaft-fuehren]], [[lehren-anwenden-nicht-nur-schreiben]],
[[nie-stillstehen]] und [[anweisungen-abarbeiten]].
