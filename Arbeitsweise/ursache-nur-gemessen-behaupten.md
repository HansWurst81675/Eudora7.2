---
name: ursache-nur-gemessen-behaupten
description: Eine Ursache, die ich nicht gemessen habe, gehoert nicht in einen Bericht - zeitliche Naehe ist keine Messung; am 19.10.2026 zweimal behauptet, beide Male war der Beschuldigte unschuldig
metadata:
  type: feedback
---

Schranke: keine - bewusst nicht gebaut: ein Muster auf Ursachensaetze (weil, verursacht, kommt von) hat ein hohes Fehlalarmrisiko, und ein Fehlalarm kostet dasselbe wie eine stumme Pruefung. Der billige Anfang waere die Tabellenspalte Stand in neuen Befunde/*.md

Eine Ursache kommt in einen Bericht, eine Commit-Nachricht oder einen
Agentenauftrag nur mit einem von drei Vermerken: **gemessen** (mit der
Ausgabe), **belegt am Quelltext** (mit Datei und Zeile) oder **Vermutung**
(ausdrücklich so genannt, mit dem, was sie widerlegen würde).

**Why:** Am 19.10.2026 zweimal am selben Tag. *„`befunde-verlinken.pl` hat
PRUEFER-38.md doppelt kodiert"* — tatsächlich kam die Datei neu vom
PRÜFER-Subagenten, der Rundlauf des Werkzeugs ist byte-identisch; die
Behauptung stand da, weil `--anker --verlinken` kurz davor gelaufen war. Und
*„alle 128 `src=` sind auf 32 Zeichen abgeschnitten"* — es war die **eigene**
Spurmarke (`%.32s` an zwei Stellen). Beide Male wurde eine **Gleichförmigkeit**
oder eine **zeitliche Nähe** als Ursache gelesen. Beides sagt, wo man messen
soll, und ist nie das Messergebnis.

**How to apply:** Der Auslöser ist das **Schreiben**, nicht das Denken — darin
unterscheidet sich das von [[pruefen-statt-vermuten]]: die Behauptung stand
nicht im Gespräch, sondern in einem Dokument, das weitergereicht wurde, und
ein Bericht wird gelesen, nachdem der Chat weg ist. PRUEFER-37 und PRUEFER-38
führen die drei Werte bereits in der Spalte *Stand* ihrer Fundtabellen; die
Konvention gehört aus den Prüfberichten in die eigene Prosa. Siehe
[[wissen-gehoert-in-dateien]], [[widerlegte-vermutungen-aufschreiben]],
[[mannschaft-fuehren]].

## Nachtrag 20.10.2026: wer gemessen hat, gehört zur Messung — und die Berichtigung braucht dieselbe Prüfung

In den Release-Notizen zu 1.0.114 stand, der Knopf *„Copy info"* im
Über-Dialog sei **von mir** als Fensterbotschaft an ein gemessenes Handle
gedrückt worden. Gemessen hat es **Gregor**: er hatte den Dialog offen, drückte
den Knopf und schickte mir den Inhalt der Zwischenablage.

Berichtigt wurde das **zweimal**:

| Zeit (UTC) | Commit | Aussage | Stand |
|---|---|---|---|
| 19:36:53 | `11125332` | *„Das Skript hat den Dialog nie gefunden … Gregor hat Help → About selbst geöffnet"* | **falsch** |
| 19:39:33 | `5f721756` | *„geöffnet, aber nicht wiedererkannt"* (Gregor: *„war schon offen, habe nur den copy button gedrückt"*) | richtig |

Die erste Berichtigung stammte aus **derselben stummen Messung** wie der
Fehler: aus dem *„KEIN Dialog gefunden"* des Skripts
([[ausbleiben-ist-kein-befund]]). Sie war schnell, gut formuliert und wieder
unbelegt.

**How to apply, zusätzlich:**

- **Jede Messung nennt ihren Urheber.** „gemessen" heißt: von wem, womit. Wer
  geprüft hat, entscheidet, wie belastbar die Prüfung ist — hier war sie
  **belastbarer**, nicht weniger: ein Mensch hat geklickt.
- **Eine Berichtigung ist eine neue Behauptung und braucht eine neue Messung.**
  Sie darf nicht aus derselben Quelle stammen, die den ersten Fehler erzeugt
  hat.
