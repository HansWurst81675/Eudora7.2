---
name: zweigname-heisst-vorheriger-fertig
description: "Einen neuen Zweignamen vorzuschlagen ist die Behauptung, der vorherige sei vollständig — erst git status leer und gepusht"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-18T10:49:25.489Z
---

Schranke: tools/gesichert.pl meldet ungesicherte Dateien und fehlende Pushes - es haengt aber in keinem Haken und niemand ruft es vor einem Zweigvorschlag auf; genau das war am 18.09.2026 die Luecke.

Gregor am 18.09.2026:

> *„wenn du mir einen neuen branch namen vorschlägst, dann gehe ich davon aus,
> daß der vorherige branch komplett ist."*

**Der Anlass.** Ich hatte `e112-bilder-auf-angegebene-groesse` vorgeschlagen,
während auf dem Zweig davor zwei Nachträge **ungesichert im Arbeitsbaum**
lagen: Gregors Bestätigung zu E-110 und der neue Befund E-112. Er hat auf den
Vorschlag hin gemergt — und auf `main` stand danach *„von Gregor noch nicht
bestätigt"* neben einer Behebung, die er gerade bestätigt hatte, und kein Wort
über den Folgebefund.

Es ist dieselbe Klasse wie am Morgen desselben Tages, nur in Minuten statt über
Nacht: **Material, das nach dem Merge nachgeschoben werden müsste.**

**Die Regel.** Ein Zweigname-Vorschlag ist kein Vorschlag, sondern eine
**Meldung**: *der vorherige Zweig ist vollständig*. Vorher, ohne Ausnahme:

```bash
git status --short     # leer (Baureste ausgenommen)
git log origin/main..HEAD   # leer, also gepusht und gemergt
perl tools/gesichert.pl
```

Und inhaltlich: steht alles, was seit dem Push gemessen wurde, auch **im**
Zweig? Eine Bestätigung von Gregor und ein neu entdeckter Befund gehören dazu,
auch wenn sie erst fünf Minuten alt sind.

**Warum das trägt.** Gregor merged auf mein Wort hin. Sage ich „der nächste
Zweig heißt X", handelt er sofort. Ein Vorschlag, der eine Unwahrheit
transportiert, kostet ihn einen Merge, den er nicht zurücknehmen kann.

Verwandt: [[fertig-heisst-fertig]], [[zweig-vorher-abstimmen]],
[[schranke-gehoert-in-den-haken]], [[doku-parallel-nicht-hinterher]],
[[erfolgsmeldung-aus-dem-ergebnis]].
