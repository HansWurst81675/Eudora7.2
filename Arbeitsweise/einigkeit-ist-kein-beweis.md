---
name: einigkeit-ist-kein-beweis
description: Dokumente gegeneinander zu prüfen findet nur Widersprüche; der Maßstab muss von außen kommen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-18T07:35:49.614Z
---

Schranke: tools/pruefe-release-buchfuehrung.pl (pre-commit, pre-push) misst die Dokumente gegen den Tag-Bestand statt gegeneinander; die uebrigen Massstaebe von aussen decken tools/pruefe-behoben-ausgeliefert.pl und tools/pruefe-fassungsnummer.pl

`doku-pruefen.pl` hält die Dokumente **gegeneinander**. Am 17.09.2026 sagten
fünf führende Dokumente einhellig, das neueste Release sei `v1.0.64` — während
das Tag `v1.0.72` längst gesetzt war. Widerspruchsfrei und falsch.

**Einigkeit ist kein Wahrheitsbeweis.** Wer nur intern vergleicht, misst die
Konsistenz einer Behauptung, nicht ihren Wahrheitsgehalt. Die Antwort auf *„was
ist wirklich veröffentlicht?"* steht nicht in den Dokumenten, sondern im
Tag-Bestand — also außerhalb.

Daraus `tools/pruefe-release-buchfuehrung.pl`: höchstes Tag als Maßstab, die
Dokumente werden **daran** gemessen. Dasselbe Muster gilt weiter:

| Frage | Maßstab **nicht** | sondern |
|---|---|---|
| Was ist veröffentlicht? | die Dokumente | `git tag` |
| Welche Fassung liegt beim Anwender? | `VERSION` | die Versionsressource der **ausgelieferten** `Eudora.exe` |
| Ist der Befund behoben? | „behoben in 7.2.0.NN" | Gregors Lauf am Programm |
| Was ist zu prüfen? | meine Liste | `git ls-files "*.md"` |

**Die Gegenrichtung hat sofort zugeschlagen und gehört dazu:** eine Schranke,
die auf eine Fassungsnummer auslöst und die neueste verlangt, erzwingt in einem
**historischen** Eintrag eine Lüge. `doku-pruefen.pl` hat einen Eintrag in
`tools/ZWEIGE.md` dreimal weitergeschoben — 69 → 70 → 71 → 72 —, obwohl dort
steht, was ein Zweig damals **gebracht** hat. Der LEKTOR hat es als **L-15.5**
belegt und die Zeile umformuliert, statt die Zahl weiterzuschieben.

Also: Maßstab von außen holen — und beim Schreiben unterscheiden, ob ein Satz
die **Gegenwart** behauptet oder die **Vergangenheit** berichtet. Nur der erste
muss der neuesten Fassung folgen.

Verwandt: [[pruefumfang-nicht-von-hand]], [[review-sieht-nur-den-diff]],
[[schranke-gehoert-in-den-haken]], [[version-eindeutig-machen]],
[[anzeige-ist-kein-zustand]].
