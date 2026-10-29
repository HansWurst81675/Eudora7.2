---
name: ausreisser-ist-der-befund
description: "Was in der eigenen Messausgabe steht und nicht ins Ergebnis passt, ist der Befund - nicht das Rauschen, das man wegerklaert"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2dc0ce9e-d597-4bea-8a46-cb21a63838b0
  modified: 2026-10-29T07:58:24.490Z
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

## Nachtrag 29.10.2026 (CHRONIST): ein Absturz und eine Eins, beide in der eigenen Ausgabe

Zeiten MEZ, gemessen an `72be6093…` und `2dc0ce9e…`.

**1. Der Absturz vom 28.10. (heute E-168).** Lauf 6 zum Konto-Assistenten, gestartet 13:34:54, Ausgabe 13:35:19. In der (mit `Select-String` gefilterten) Ausgabe stand dreimal hintereinander dieselbe Seite, *„Your Name:“* mit leerem Feld, als Seite 3, 4 und 5, dazu `reihenfolge=assistent-abgebrochen` und `Beendet: True`. Um 13:35:24 schrieb ich: *„Der Weg funktioniert.“* Zwischen 13:35:19 und 13:35:24 war Eudora um 13:35:16 mit einer Zugriffsverletzung abgestürzt (`Exception.log` am Prüfstand). Gefunden hat es LEKTOR-90 (L-90.12), nicht ich. Auch der CHRONIST vom 28.10. hat Lauf 6 gelesen und den Absturz nicht gesehen. Drei gleiche Seiten nach drei *Weiter* sind der Ausreißer: Die Seite ging nicht weiter, weil eine Meldung offen war. Am 29.10. gemessen: Der Assistent ist dann gesperrt, nur das eigene `PostMessage` kam durch. Nachstellen ließ sich der Absturz nicht (drei Läufe, einer mit der alten `Eudora.exe`). Die Ursache bleibt offen, „erledigt“ in E-168 heißt: für Anwender nicht erreichbar, mit Gregors *„ja, so eintragen“* (07:09:04).

Mitgewirkt hat ein Werkzeugmangel (belegt am Quelltext): `tools/testlauf.ps1` prüft einen Prozess, der **während der Messung** endet, nicht. Der Exitcode wird nur ausgegeben, wenn der Prozess vor dem Hauptfenster endet (`:331–333`). Danach steht nur `Beendet: True` (`:382`), gleich ob Eudora regulär schloss oder abstürzte. Einen Blick auf ein neues `Exception.log` gibt es nicht.

**2. Die Startwege-Schranke, 29.10.** Um 07:17:55 lief die umgebaute `pruefe-startwege.pl --tag 2026-10-28` und meldete in **einer** Zeile: `Starts 1   Protokollzeilen 23   ohne Zeile 0`, darunter *„Jeder eigene Eudora-Start am 2026-10-28 steht im Protokoll.“* Bekannt waren 21 Starts an diesem Tag (CHRONIST vom 28.10.). Um 07:18:37 stand in `tools/WERKZEUGE.md`, die Schranke zähle jetzt `Audit.log`, um 07:18:57 in `WEITERMACHEN.md` L-90.18 als erledigt. LEKTOR-91 (L-91.1, 07:54) fand die Ursache: `pruefe-startwege.pl:163` verwirft jeden Start vor der Änderungszeit der `Eudora.exe`, und die wurde am 28.10. um 14:19:06 getauscht. Berichtigt wurde die Meldung um 07:56:52, nicht die Schranke. Eins gegen 23 in derselben Zeile ist die Gestalt dieser Lehre ([[zwei-werte-in-eine-ausgabe]]), und die Gegenprobe gegen den echten Fall, für den die Änderung gebaut wurde, war genau dieser Aufruf ([[schranke-gegentesten]]).

**How to apply, zusätzlich:**
- Steht in einer Prüfstandsausgabe dieselbe Seite oder derselbe Zustand mehrfach, obwohl jeder Schritt weiterschalten sollte, ist das der erste Befund, vor jedem „funktioniert“.
- Nach jedem Prüfstandslauf wird `Exception.log` im Mailverzeichnis gezählt (Zeitstempel gegen den Laufbeginn). Besser im Werkzeug: `testlauf.ps1` meldet *„Prozess endete während der Messung, Exitcode X“* und ein neues `Exception.log` als `FEHL` (Vorschlag, nicht gebaut; Gegenprobe: der Lauf vom 28.10. 13:34:54 müsste rot werden).
- Eine Erledigung wird erst gemeldet, wenn die Ausgabe für den Fall, der sie verlangt hat, die erwartete Zahl zeigt.
