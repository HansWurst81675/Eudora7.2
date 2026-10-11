---
name: ausreisser-ist-der-befund
description: "Was in der eigenen Messausgabe steht und nicht ins Ergebnis passt, ist der Befund - nicht das Rauschen, das man wegerklaert"
metadata:
  type: feedback
---

Schranke: keine - dass ich eine Zeile meiner eigenen Ausgabe weggedeutet habe, steht nirgends; im Repo bleibt die gerundete Zahl stehen, nicht die Zeile, die ihr widersprochen hat. Vorschlag fuer eine Schranke am Ende dieser Datei.

# Der Ausreißer in der eigenen Ausgabe ist der Befund

Am 11.09.2026 habe ich für E-80 an Gregors echten Postfächern nachgerechnet,
welche Kopfzeilen der Knopf *Blah Blah Blah* stehen lässt, und **„genau acht"**
berichtet: `From`, `To`, `Cc`, `Bcc`, `Subject`, `Date`, `Reply-To`, `Sender`.

In **meiner eigenen Ausgabe** stand:

```
   134x To          43x Cc           3x Sender
   134x Subject     42x Bcc          3x Referer     <- gesehen und weggedeutet
   134x From         9x Reply-To     2x CC
    92x Date
```

Es sind **zehn** Namen, oder neun, wenn man `CC` und `Cc` zusammenzieht. Ich
habe `3x Referer` gelesen, für eine Nebensächlichkeit gehalten — die drei
Vorkommen sind sogar leer, `Referer:` ohne Wert — und die Acht trotzdem so
genannt. Gefunden hat es PRÜFER, nicht ich (`Befunde/PRUEFER-8.md`, 2.4).

**Und der Ausreißer war der einzige inhaltlich neue Punkt der ganzen Messung.**
`Referer` bleibt stehen, weil der Listeneintrag `References` zehn Zeichen lang
ist und der Präfixvergleich nur in einer Richtung greift: `References` deckt
`Referer: ` nicht ab. Das ist eine Lücke in der Behebung selbst, keine
Rundungsfrage — genau die Erkenntnis, die in der weggedeuteten Zeile steckte.

## Dieselbe Bewegung, dreimal belegt

| Datum | in meiner Ausgabe sichtbar | was ich stattdessen sagte |
|---|---|---|
| 05.09.2026 | 10,2 MB neben 2,9 MB in derselben Auflistung | „Debug/Release mit `strings` erkannt" |
| 05.09.2026 | `s.dll`, `ts.dll` unter den Treffern | „die DLL-Namen aus der Binärdatei" |
| 11.09.2026 | `3x Referer` in der Häufigkeitstabelle | „genau acht Kopfzeilen bleiben" |

Alle drei stehen in [[pruefen-statt-vermuten]] beziehungsweise hier; alle drei
haben dieselbe Gestalt: **die Widerlegung lag im eigenen Ergebnis, eine Zeile
neben dem Satz, den ich geschrieben habe.**

**Warum das eine eigene Klasse ist:** [[pruefen-statt-vermuten]] handelt davon,
dass ich eine Quelle **nicht geöffnet** habe, und [[eingebaute-messung-auslesen]]
davon, dass eine Messung **ungelesen** liegen blieb. Hier ist beides erfüllt —
gemessen, ausgegeben, gelesen — und das Ergebnis trotzdem falsch, weil ich die
Zeile, die nicht passte, im Kopf wegsortiert habe. Eine Messung, deren Ausreißer
man wegerklärt, ist keine Messung mehr, sondern eine Bestätigung dessen, womit
man hingegangen ist.

## Wie anwenden

1. **Auslöser: eine glatte Zahl.** „Genau acht", „alle", „nur diese drei" — wenn
   ein Ergebnis rund klingt, ist das der Moment, die Rohausgabe noch einmal Zeile
   für Zeile gegen den Satz zu halten, den ich schreiben will. Die Rundung ist
   das Warnzeichen, nicht der Beleg.
2. **Jede Zeile der Ausgabe kommt im Ergebnis vor — oder wird benannt.** Wer
   zehn Zeilen misst und acht nennt, schreibt dazu, welche zwei warum nicht
   zählen. „Hat mit der Frage nichts zu tun" ist ein Satz, den ich begründen
   muss, kein Grund, den ich verschweigen darf.
3. **Die Rohausgabe gehört in den Bericht**, nicht die Zusammenfassung allein.
   Beim Nachlesen fällt eine Zeile auf, die im Fließtext fehlt; an einer Zahl
   fällt nichts auf ([[zwei-werte-in-eine-ausgabe]]).
4. **Der Ausreißer wird zuerst untersucht, nicht zuletzt.** Er ist die einzige
   Zeile, die etwas sagt, was ich noch nicht wusste. Hier hat er auf eine echte
   Lücke der Behebung gezeigt; die neun erwarteten Zeilen haben nichts gezeigt.
5. **Ein Ergebnis, das ich in Prosa runde, gehört in ein Werkzeug.** `3x Referer`
   hätte in einer Prüfung nicht verschwinden können. Was ich von Hand
   zusammenfasse, fasse ich zu meinen Gunsten zusammen
   ([[fehlerklassen-abstellen]]).

## Was eine Schranke hier könnte — Vorschlag an PRÜFER

Eine Prüfung kann nicht sehen, was ich gedacht habe. Sie kann aber sehen, ob ein
Werkzeug seine **vollständige** Verteilung ausgibt: ein Zählwerkzeug, das ein
Ergebnis liefert, gibt jede Klasse mit ihrer Häufigkeit aus und meldet zusätzlich
die Gesamtzahl der Klassen (`10 Namen, davon 8 genannt`). Wo Werkzeug und Text
auseinandergehen, ist die Zahl im Text falsch. `tools/taboo-rechnen.pl` tut das
inzwischen; es als Anforderung an jedes zählende Werkzeug zu prüfen, wäre die
Schranke — sie zu bauen ist PRÜFERs Feld, nicht meins.

Siehe [[pruefen-statt-vermuten]], [[eingebaute-messung-auslesen]],
[[zwei-werte-in-eine-ausgabe]], [[widerlegte-vermutungen-aufschreiben]] und
[[pruefumfang-nicht-von-hand]].
