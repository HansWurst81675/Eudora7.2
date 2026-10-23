---
name: test-prueft-den-ausstieg
description: Ein Regressionstest, der nur die neue Meldung sucht und nicht den Ausstieg, laesst den ganzen Fehler zurueck - 277 von 277 gruen mit vollstaendig wiederhergestelltem Befund
metadata:
  node_type: memory
  type: feedback
---

Schranke: keine - welche Haelfte einer Behebung die Wirkung traegt, steht in keinem Muster; ein Werkzeug kann "Dialog zeigen" nicht von "abbrechen" unterscheiden. Der Ausloeser ist stattdessen eine Handlung: beim Gegentesten die KLEINSTE Ruecknahme fahren (eine Zeile der neuen Behebung loeschen), nicht die groesste (alles auf HEAD zurueck).



# Der Test prüft die Meldung, nicht den Ausstieg — und wird dadurch blind

Am 23.10.2026 habe ich [[E-125]] behoben: Ziehen einer empfangenen Nachricht
nach `Out` wird abgelehnt. Die Behebung hat **zwei** Teile:

```c
AlertDialog(IDD_XFER_TO_OUT_REFUSED);
break;                                  // <- der eigentliche Wirkteil
```

Mein Regressionstest prüfte die Bedingung, den Dialogaufruf, die Spurmarke und
die Abwesenheit des alten Standes. **Den Ausstieg prüfte er nicht.**

**Gemessen, nicht vermutet:** PRÜFER hat die Zeile `break;` gelöscht — sonst
nichts. Danach läuft der Ablauf nach dem Hinweis weiter in den `ToOut`-Zweig,
`Sum->SendAgain` legt wieder eine neue Nachricht an, **der Befund ist
vollständig zurück** — und der Prüfstand meldete **277 von 277 bestanden**.

**Why:** Ich *hatte* gegengetestet, und zwar zweimal — gegen den alten
Quelltext und gegen eine zu weite Bedingung (`if (ToOut)` statt
`if (ToOut && !Sum->IsComp())`). Beide Gegenproben waren rot. Das hat mich
sicher gemacht. Keine davon traf die Stelle, an der die Wirkung wirklich
hängt. [[schranke-gegentesten]] sagt „gegen den echten Fehler fahren" — ich
habe gegen **einen** echten Fehler gefahren und daraus geschlossen, der Test
sei dicht.

Die Gegenprobe, die fehlte, ist die **kleinste mögliche Rücknahme**: nicht
„den alten Stand wiederherstellen", sondern „eine einzelne Zeile der neuen
Behebung entfernen".

**How to apply:**

- **Eine Behebung aus zwei Teilen braucht zwei Testfälle.** Dialog zeigen und
  abbrechen, Merker setzen und abfragen, prüfen und zurückgeben — je Hälfte
  ein Fall, der rot wird, wenn genau diese Hälfte fehlt.
- **Die Reihenfolge mitprüfen, wenn sie trägt.** Stünde die Ablehnung hinter
  dem Anlegen, wäre jede gesuchte Zeichenkette noch da und die Wirkung weg.
  `QT_Stelle(a) < QT_Stelle(b)` kostet drei Zeilen.
- **Beim Gegentesten die kleinste Rücknahme wählen, nicht die größte.** „Alles
  zurück auf HEAD" ist die bequeme Probe; „eine Zeile raus" ist die, die etwas
  findet ([[pruefstand-nicht-bequemer-als-die-wirklichkeit]]).
- **Suchen nie an der Aufrufform festmachen.** `QT_LeerraumZusammen` zieht
  Leerraum auf *ein* Leerzeichen zusammen, entfernt ihn nicht:
  `AlertDialog( IDD_STRIP_HEADERS )` läuft an der Nadel
  `AlertDialog(IDD_STRIP_HEADERS)` vorbei. Der Bezeichner allein genügt.
