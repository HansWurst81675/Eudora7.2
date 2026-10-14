---
name: fund-ganz-abhaken
description: "Vor der Behebung eines Fundes seine Punkte als Liste abhaken (tools/fund-punkte.pl): N1 wurde nur in einer Richtung behoben, obwohl PRÜFER-23 die Gegenrichtung im selben Abschnitt nannte"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T10:40:00.000Z
---

Schranke: tools/fund-punkte.pl <Bericht> <Anker> - vor dem ersten Handgriff an einem Fund aufrufen; listet jeden Ort und jeden zweiten Fall (Gegenrichtung, ebenso, Gegenprobe) des Abschnitts. `--selbsttest`, 5 Fälle. Kein Haken: welcher Fund behoben wird, steht nur in der Commit-Nachricht.

Am 13.10.2026 meldete PRÜFER-23 den Fund **N1**: Die Breitenbegrenzung aus E-89 macht aus `<img width="1200">` die Angabe `width="600" height="1"`, seit E-112 ein Strich. Derselbe Abschnitt sagt zwei Sätze weiter: *„Gegenrichtung `:3663-3669`: bei nur `height="900"` wird aus der Breite 0 die Breite 1, also `width="1" height="600"`."* Im Vorschlag steht noch einmal: *„Ebenso für die Breite."* Die Behebung `9f5142b` (10:09 UTC) hat nur den Breitendeckel repariert, mit rotem und grünem Test. Die zweite Hälfte fand **LEKTOR-29** um 10:22. Das kostete einen zweiten Test, einen zweiten Bau, eine zweite Messung und eine Rollenrunde mehr vor dem Paket, also eine Viertelstunde, in der Gregor wartete.

Am selben Vormittag war es schon einmal so gewesen ([[messung-muss-den-weg-treffen]], Fall 9): PRÜFER-22 F2 nannte die Ladestelle `PgEmbeddedImage.cpp:384-392`, getestet wurde nur die Regel. **Das ist zweimal dieselbe Klasse:** Der Fund wird gelesen, aber nicht Punkt für Punkt abgehakt. Der Kern wird behoben, und was im Nebensatz steht, bleibt liegen.

**Why:** Ein PRÜFER-Abschnitt ist dicht. Der Hauptfall steht in der Überschrift, die Gegenrichtung und die Aufrufstellen stehen im Fließtext. Wer mit dem Test für den Hauptfall anfängt, hat das Gefühl, den Fund zu bearbeiten, und liest den Rest nicht mehr als Auftrag. Der grüne Test bestätigt dann genau das, was ich verstanden habe, nicht das, was dastand ([[schranke-teilt-nicht-die-annahme]]). Ein Deckel für Breite *und* Höhe ist ein symmetrischer Fall. Dass es die andere Seite gibt, hätte ich auch ohne den Bericht fragen müssen.

**How to apply:**

- **Vor dem ersten Handgriff an einem Fund** `perl tools/fund-punkte.pl Befunde/PRUEFER-NN.md <anker>` fahren. Jeder `ORT` bekommt einen Test oder eine Messung am Weg, jeder `ZWEITE`-Punkt einen eigenen Testfall. Was nicht gemacht wird, steht begründet in der Commit-Nachricht.
- **Gegenprobe am echten Fall:** Für PRÜFER-23 N1 meldet das Werkzeug 7 Orte und 3 zweite Fälle, darunter `Gegenrichtung :3663-3669` und `Ebenso für die Breite`. Für PRÜFER-22 F2 meldet es `PgEmbeddedImage.cpp:384-392` als ersten Ort. Beide Lücken des Vormittags hätte es also gezeigt.
- **Bei jedem Fund mit einer Grenze, einem Deckel oder einem Paar** (Breite/Höhe, Lesen/Schreiben, Senden/Empfangen) fragen, ob es die Gegenrichtung gibt, auch wenn der Bericht sie nicht nennt. Das Werkzeug erinnert daran, wenn es keinen zweiten Fall findet.
- Ein Bericht, der eine Stelle nennt, ist ein Auftrag, keine Begründung (siehe [[bestand-vor-neuer-suche]]: auch dort lag die Antwort fertig im Repo).
