# PRÜFER-24 — E-89-Deckel nach N1 und Gegenrichtung (`9f5142b`, `bf96856`)

Lauf am 13.10.2026, nur lesend. Nichts gebaut, nichts geändert, kein Programm gestartet.
Stand: Zweig `wt/pruefer`, gemergt mit `origin/e-112-skalierung` (`f305f49`).
Gelesen: `Eudora71/Eudora/msgutils.cpp:3486-3740` (`E89BilderMessbarMachen`),
`Eudora71/Eudora/PgEmbeddedImage.cpp:371-411` (`E112Zielrechteck`),
`Eudora71/Tests/TestE89.cpp` (4), (4b), (4c), BEFUNDE.md [E-112](../BEFUNDE.md#e-112)/[E-113](../BEFUNDE.md#e-113).

**Nicht selbst gemessen:** Testsuite 195/195 und die beiden Spurmarken
(`angegeben=600x0 gemalt=600x230`, `angegeben=0x600 gemalt=606x600`) sind aus
dem Auftrag übernommen; ich habe weder gebaut noch das Programm laufen lassen.
Nachgerechnet ist nur, dass sie zur Quelle passen.

**Urteil: auslieferbar.** Beide Änderungen sind minimal (je eine Bedingung,
Diff geprüft) und schließen die Lücke in beiden Richtungen. Der Rest der
Funktion ist damit konsistent. Ein Bild kann breiter als 600 gemalt werden —
das ist **nicht neu** und gehört zu [E-113](../BEFUNDE.md#e-113). Daneben eine
veraltete Stelle in BEFUNDE.md (D1) und zwei Hygienepunkte an der Zählung (Z1, Z2),
alle drei nicht durch diese Änderungen entstanden.

---

## 1. Die beiden Änderungen

| Fall | Quelle | geschrieben | Paige malt (E112Zielrechteck) |
|---|---|---|---|
| `width="1200"`, keine Höhe | `msgutils.cpp:3654-3666`: Höhe 0 bleibt 0, Breite 600 | `width="600"` (`:3746-3749`) | Zweig „nur Breite“, `PgEmbeddedImage.cpp:387-397` → 600 × (Datei-Verhältnis) — passt zu `600x230` |
| `height="900"`, keine Breite | `msgutils.cpp:3668-3680`: Breite 0 bleibt 0, Höhe 600 | `height="600"` | Zweig „nur Höhe“, `:398-405`: (600·330 + 163) / 327 = 606 — passt zu `606x600` |
| beide bekannt, `1200x600` | `:3658-3664`, danach `:3668` nicht erreicht | `600x300` | unverändert, Test (4) |
| beide bekannt, `1200x1500` | Breite → 600, Höhe → 750; dann `:3668`: Breite → 480, Höhe 600 | `480x600` | seitenverhältnistreu, beide Deckel greifen nacheinander |

Vorher wurde 0·600/n = 0 auf 1 angehoben (`height="1"` bzw. `width="1"`), seit
[E-112](../BEFUNDE.md#e-112) als Strich gemalt. Die Tests (4b)/(4c) prüfen genau das Fehlen des
erfundenen Maßes (`TestE89.cpp:150-195`), nicht nur die Abwesenheit der 1 — gut.

## 2. Der Rest der Funktion

* **Prozentbreite + unbekannte Höhe** (`bProzB`, `nHoehe 0`): Breitendeckel
  übersprungen (`:3654`), Höhendeckel nicht erreicht (`:3668`, 0 > 600 falsch).
  Geschrieben wird nur `width="50%"` (`:3689`, `:3746`). Konsistent.
* **Prozentbreite + Höhe > 600:** Höhe → 600, Breite bleibt Prozent
  (`:3672`). Verhältnis geht verloren — war vorher genauso (`if (!bProzB)` stand
  schon da, nur `&& nBreite > 0` kam hinzu). Kein neuer Fehler.
* **Beide unbekannt:** `continue` vor dem Deckel (`:3626-3632`), Markierung
  unberührt. Unverändert.
* **Höhe aus CSS:** `:3559-3569`, nur Pixelwerte; Prozent-Höhe in CSS wird
  verworfen, Prozent-Höhe im Attribut ebenso (`:3538-3542`). Danach läuft sie
  durch denselben Deckel wie eine Attribut-Höhe, `bAusCss` zählt mit. Konsistent.
* **Was geschrieben wird, wenn ein Maß 0 bleibt:** `:3746-3749` schreibt nur
  Maße > 0. Das alte Attribut wird in jedem Fall herausgeschnitten
  (`:3713-3740`), auch ein ungültiges wie `width="auto"`. Mit N1 und [LEKTOR-29](LEKTOR-29.md#lektor-29)
  erreicht jetzt **kein** Pfad mehr den Fall, dass eine 0 durch den Deckel zur 1
  wird — die einzige Stelle, an der vorher ein erfundenes Maß entstand.
* **`bAendern`** (`:3692-3694`): wegen `!bHatBreite || !bHatHoehe` wird jedes
  Bild mit nur einem Attribut neu geschrieben, auch wenn sich nichts ändert
  (siehe Z2). Für die beiden neuen Fälle ohne Belang: dort ändert sich der Wert
  ohnehin (1200 → 600, 900 → 600).

## 3. Kann ein Bild breiter als 600 durchkommen? — Ja, und nicht erst jetzt

Beispiel aus dem Auftrag: nur `height="900"`, Datei 2344 × 900. [E-89](../BEFUNDE.md#e-89) schreibt
`height="600"`, `E112Zielrechteck` ergänzt die Breite aus dem Verhältnis
(`PgEmbeddedImage.cpp:398-405`): **1563 × 600**. Ungemessen, aus der Quelle
gerechnet. Schon der gemessene Fall `606x600` liegt über 600.

**Kein neuer Fehler gegenüber vorher**, aus drei Gründen:

1. Vorher kam an dieser Stelle `width="1" height="600"` heraus — ein senkrechter
   Strich. Ein zu breites, aber erkennbares Bild ist besser als keins.
2. Derselbe Weg bestand schon vor dieser Änderung für **jede** Höhe ≤ 600 ohne
   Breite: [E-89](../BEFUNDE.md#e-89) fasst sie gar nicht an, `E112Zielrechteck` ergänzt die Breite
   seit F2 (`11b6a3a`) ohne Obergrenze. `height="500"` bei Datei 2000 × 500 →
   2000 × 500 (gerechnet, ungemessen).
3. Bilder ganz ohne Maß malt Paige in Dateigröße ([E-103](../BEFUNDE.md#e-103),
   `PgEmbeddedImage.cpp:406-411`), beliebig breit.

[E-89](../BEFUNDE.md#e-89) deckelt **angegebene** Maße; die gemalte Breite hat es nie begrenzen
können, weil es die Datei nicht kennt (die Bilder sind beim Umschreiben noch
nicht geladen). Die gemalte Breite gegen den verfügbaren Platz ist genau
**[E-113](../BEFUNDE.md#e-113)**. Empfehlung dafür: die Obergrenze nach `E112Zielrechteck` auf das
Ergebnisrechteck anwenden (gegen `page_width`, `PGHTMIMP.CPP:235-240`), nicht
in [E-89](../BEFUNDE.md#e-89) — dort fehlt die Dateigröße.

## 4. Funde daneben

* **D1 (Doku, veraltet):** BEFUNDE.md, Zeile [E-112](../BEFUNDE.md#e-112), Nachtrag zu PRÜFER-23,
  sagt erst „die Gegenrichtung (`width="1"`) ist ebenfalls behoben … gemessen:
  `angegeben=0x600 gemalt=606x600`“ und unmittelbar danach „**Die Gegenrichtung
  war offen ([LEKTOR-29](LEKTOR-29.md#lektor-29)):** bei nur `height` über `E89_MAX_HOEHE` wird die
  Breite 0 weiter zu 1 (`msgutils.cpp:3668-3677`, `width="1"`), aus der Quelle
  gelesen, ungemessen.“ Der zweite Satz steht im Präsens und widerspricht dem
  ersten; die Zeilen sind jetzt `:3668-3680`. Zu streichen oder als
  „behoben in `bf96856`“ umzuschreiben.
* **Z1 (niedrig, Zählung):** `nOhneMass` zählt „Breite bekannt, Höhe nicht“
  (`msgutils.cpp:3633-3645`), aber nicht „Höhe bekannt, Breite nicht“ — für
  diesen Fall gibt es keinen Zweig. Die Deklaration nennt die Zahl „kein Maß
  bekannt — Bild unangetastet gelassen“ (`:3399`); beides trifft auf den
  Breite-only-Fall nicht zu (er kann gedeckelt und umgeschrieben werden). Die
  Spurmarke `ohne-Mass=` ist damit für halbe Angaben schief. Nicht neu, nur
  Spur.
* **Z2 (niedrig, nicht neu):** `bAendern` ist für jedes Bild mit nur einem
  Attribut wahr (`:3692`), auch wenn nichts hinzukommt (`<img width="300">`
  ohne CSS): die Markierung wird gleichwertig neu geschrieben, `unveraendert=`
  zählt sie nicht. Folgenlos für die Darstellung (Paige liest dieselben Werte),
  verfälscht nur die Spur.

Kein Fund an den beiden geprüften Änderungen selbst.
