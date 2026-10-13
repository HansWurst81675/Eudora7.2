---
name: schranke-teilt-nicht-die-annahme
description: "Eine Schranke, die ihren Umfang aus derselben Annahme nimmt wie das Werkzeug, das sie pruefen soll, prueft nichts"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f193092b-2e64-587f-a070-7e656c44c557
  modified: 2026-10-12T19:10:00.000Z
---

Schranke: keine - sie waere selbst eine. Pruefbar ist nur das Muster: findet GREGOR den Fehler, den meine frische Schranke uebersehen hat, dann teilten beide eine Annahme.

# Die Schranke darf nicht dasselbe glauben wie das Werkzeug

Am 12.10.2026 habe ich `tools/befunde-verlinken.pl` gebaut: es verlinkt jede
Kennung, und **ohne Schalter ist es die Schranke dazu** — Rückgabewert 1,
sobald eine Nennung kein Link ist. Eingehängt in `pre-commit`, `pre-push` und
`paket-bauen.ps1`.

Die Schranke meldete:

> *„Jede Kennung ist ein Link, und jeder Link trifft eine Urteilszeile."*

Zur selben Zeit standen `E-85`, `E-98`, `L-17.1` und `B5.7` unverlinkt in den
Dokumenten. Gefunden hat das **Gregor**, in vier Nachrichten hintereinander.

## Warum sie es nicht finden konnte

Weil sie dieselbe Frage stellt wie das Werkzeug: *„was von dem, was **ich** für
eine Kennung halte, ist noch kein Link?"* Was das Werkzeug nicht als Kennung
erkannte, war für die Schranke auch keine:

| übersehen | weil das Werkzeug glaubte |
|---|---|
| `E-85` in *„Dazu waren **E-85** und E-86"* | nur die erste Nennung je Absatz zähle |
| `E-98` in `**E-98 bis E-101**` | eine Kennung trage den Fettdruck symmetrisch |
| `L-17.1`, `LEKTOR-20`, `P-42` | alle Kennungen stünden in `BEFUNDE.md` |
| `B5.7` | eine Kennung habe einen Bindestrich |

Vier Annahmen, vier blinde Flecken — und die Schranke hat **jede davon
geteilt**, weil sie aus demselben Quelltext kommt. Sie war kein zweites Paar
Augen, sondern dasselbe Auge zweimal.

## Was eine Schranke stattdessen braucht

**Eine Quelle, die das Werkzeug nicht kennt.** Für dieses Werkzeug wäre das:
jede Zeichenkette zählen, die *aussieht* wie eine Kennung — Großbuchstabe,
Ziffern, Bindestrich oder Punkt —, und melden, wie viele davon **weder Link
noch bekannt** sind. Dann hätte dort gestanden: *„603 Nennungen passen auf das
Muster, stehen aber in keinem Verzeichnis"*, und ich hätte nachgesehen.

Allgemein:

1. Der Umfang kommt aus einer **anderen Richtung** als die Umsetzung —
   aus der Datei statt aus dem Modell, aus `git ls-files` statt aus einer
   Liste ([pruefumfang-nicht-von-hand](pruefumfang-nicht-von-hand.md)).
2. Die Schranke meldet, was sie **nicht** einordnen konnte, statt es
   stillschweigend wegzulassen. Ein Rest von 0 ist eine Aussage, ein
   verschwiegener Rest ist keine.
3. *„Nichts gefunden"* und *„nichts zu prüfen"* sind zwei verschiedene
   Meldungen (Befund E-109, Punkt 4: *„ein Freispruch über eine leere Menge"*).

## Die Probe

Wenn **Gregor** einen Fehler findet, den eine frisch gebaute Schranke hätte
fangen sollen, dann ist die erste Frage nicht *„welcher Fall fehlt?"*, sondern:
**welche Annahme teilen Werkzeug und Schranke?** Der fehlende Fall ist immer
nur ein Symptom davon.
