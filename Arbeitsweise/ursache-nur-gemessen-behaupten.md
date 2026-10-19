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
