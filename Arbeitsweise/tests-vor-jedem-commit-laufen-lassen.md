---
name: tests-vor-jedem-commit-laufen-lassen
description: "Unit- und Komponententests gehoeren zu jedem Commit - Ergebnis mitteilen, auch wenn es rot ist"
metadata:
  type: feedback
---

Gregors Vorgabe vom 28.08.2026: "lass die zwei pruefstand und feldversuch immer mit
laufen, bevor du etwas commitest - oder von mir aus auch hinterher. man kann im
fehlerfall nochmal zurueck."

Also: Zu jedem Commit gehoeren die Tests. Vorher ist besser, hinterher ist erlaubt -
entscheidend ist, dass das Ergebnis vorliegt und mitgeteilt wird, bevor der naechste
Arbeitsschritt beginnt. Ein Commit ist rueckholbar, ein unbemerkter Fehler nicht.

**Praktische Form:** Nicht jedes Mal einen Agenten starten - das ist teuer und
langsam. Sobald die Testprojekte unter `Eudora71/Tests` gebaut sind, ist der Lauf
ein Befehl: Testprojekt mit MSBuild bauen, ausfuehren, Ausgabe lesen. Nur wenn neue
Testfaelle zu schreiben sind, lohnt wieder ein Agent (PRUEFSTAND fuer Unit-Tests,
FELDVERSUCH fuer die TLS-Komponententests).

**Das Ergebnis gehoert in die Commit-Nachricht** - welche Tests liefen, wie viele
bestanden, welche nicht. Ein roter Test ist ein Ergebnis, kein Grund zu warten:
committen, den Fehlschlag benennen und ihn als naechstes angehen. Verschweigen ist
das Einzige, was nicht geht.

Siehe auch [[doku-bei-jedem-commit-mitziehen]] und [[agenten-benennen]].
