---
name: fehlerklassen-abstellen
description: "Wiederholte Fehler mit Werkzeug und Schranke abstellen, nicht einzeln nachbessern — Vorsatz allein hält nicht"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:09.641Z
---

Schranke: tools/lehren-schranken.pl (pre-commit)

Wenn derselbe Fehler zum zweiten Mal auftritt, ist das kein Anlass, ihn nochmals
zu beheben, sondern ihn **unmöglich zu machen**: ein Werkzeug, das den richtigen
Weg zum bequemsten macht, und eine Schranke, die den falschen Weg blockiert.

**Why:** Gregor am 28.08.2026, nachdem eine Einzeilenänderung zum zweiten Mal als
134 geänderte Zeilen im Diff erschien:

> „sowas ähnliches habe ich heute bereits gelesen. kannst du das nicht besser
> machen? anstatt hinterher es zu fixen? da kann man doch bestimmt eine regel oder
> strategie anwenden?"

Und tags darauf, als die Schranke einen dritten Anlauf abfing: „gut, daß er von der
schranke entdeckt wird, aber das kostet ja zeit" — die Schranke ist die zweite
Verteidigungslinie, nicht die erste.

**Was daraus entstanden ist und sich bewährt hat:**

- `tools/aendere-zeile.pl` — byteerhaltende Einzelzeilenänderung; ersetzt
  handgebautes `sed -b`.
- `tools/pruefe-bytes.pl` als pre-commit-Hook („die Schranke") — hat am 29.08.2026
  zwei Zeilenendenschäden abgefangen, die sonst im Repo gelandet wären.
- Die Testprojekte unter `Eudora71/Tests` — haben zwei echte Fehler in der
  Zeichentabelle aufgedeckt, die durch Lesen nicht aufgefallen waren.

Das sind die wirksamsten Ergebnisse des Projekts nach Zeitersparnis. Eine Merkregel
im Kopf hat dagegen dreimal nicht gehalten.

**How to apply:** Beim zweiten Auftreten derselben Fehlerklasse die Arbeit
unterbrechen und fragen: *Welches Werkzeug macht den Fehler unmöglich, und welche
Prüfung fängt ihn ab, falls er doch passiert?* Beides bauen, ins Repo legen,
dokumentieren — erst dann weitermachen. Das gilt nicht nur für Zeilenenden: für
hängende Kommandos ist das Werkzeug „alles Lange in den Hintergrund"
([[nie-stillstehen]]), für ungeprüfte Zahlen in der Doku der zweite Agent, der
jeden Wert nachmisst ([[doku-bei-jedem-commit-mitziehen]]).

Siehe auch [[quelldateien-nur-byte-erhaltend-aendern]] und
[[tests-vor-jedem-commit-laufen-lassen]].

## Nachtrag 12.10.2026: ein bekannter Nebenbefund, der seit 34 Tagen jeden zweiten Bau abweist

**Was geschah:** `tools/bauen.ps1` weist den Bau ab, solange ungesicherte
Quelldateien im Baum liegen. Am 12.10. hat es dreimal einen Zustand
abgewiesen bzw. vorgefunden, den **der vorige Bau selbst erzeugt hatte**:

| Zeit | Was | Behandlung |
|---|---|---|
| 11:20:28 | `BAU ABGEWIESEN`, darunter fünf MIDL-Ausgaben | 11:20:52 von Hand `git checkout --` |
| 11:35:37 | wieder abgewiesen, dieselben fünf | 11:35:43 von Hand `git checkout --` |
| 11:41:25 | `git merge origin/main` startet mit denselben fünf als ` M` im Baum | 11:43:14 von Hand `git checkout --`, eingeschoben in den Merge-Commit-Befehl |

Die fünf Dateien sind `Eudora71/Eudora/EudoraExe_i.c`, `EudoraExe_p.c`,
`GoogleDesktopSearchAPI_i.c`, `GoogleDesktopSearchAPI_p.c` und `dlldata.c`.
MIDL schreibt sie bei jedem Bau neu, **mit CRLF**. Im Repo liegen sie mit LF,
inhaltlich gleich. Um 11:35:43 heißt es im Denken *„das halte ich als Befund
fest"*. Der Befund **steht aber schon da**: `BEFUNDE.md`, Abschnitt
„Nebenbefund: jeder Bau verändert fünf versionierte Dateien" (um Zeile 7465,
vom 07./08.09.2026), mit Messung (`dlldata.c` HEAD `CR=0 LF=40`, nach dem
Bau `CR=40 LF=40`). Die drei Lösungen sind dort aufgezählt, mit dem Satz
*„Nicht behoben — die Entscheidung steht aus."* Der Kommentar in
`bauen.ps1` (Zeile 219 f.) begründet die Ausnahme für `Bin/` und `Build/`
wörtlich mit *„sonst wäre die Prüfung nach jedem Bau selbst rot"*. Genau
das geschieht hier, nur mit fünf Dateien außerhalb von `Bin/`.

### Why

Ein Nebenbefund ohne Eigentümer wird nicht behoben, sondern umgangen. Das
Umgehen kostet jedes Mal wenig, deshalb wird es nie zum Anlass. Die
Schranke war richtig gebaut, aber ihr Ausnahmeverzeichnis war unvollständig.
Eine Schranke, die ihren eigenen Normalfall abweist, erzieht dazu, sie per
Hand zu übergehen. `-Ungesichert` steht im Abweisungstext gleich darunter.
Der Schritt zu „ich setze schnell zurück, ohne hinzusehen" ist kurz.

### How to apply

- **Zweites Auftreten = Werkzeug.** Hier war es das dritte an einem
  Vormittag. Die Frage, die zu Gregor geht, ist eine Entscheidung zwischen
  drei Lösungen, keine Meldung:
  (a) die CRLF-Fassung einmal committen, dann ist der Baum nach jedem Bau
  sauber (vorher an `EudoraExe_p.c` messen, ob wirklich nur die Zeilenenden
  abweichen; `--numstat` zeigte 8108 geänderte Zeilen); (b) die fünf Pfade in
  die Ausnahmeliste von `bauen.ps1`; (c) am Ende von `bauen.ps1` automatisch
  zurücksetzen, nur bei reinem Zeilenendenwechsel.
- **Vor „das halte ich als Befund fest" läuft `perl tools/befund-suchen.pl
  <datei>`** (CLAUDE.md, Punkt 2). Mit `dlldata.c` hätte es den Eintrag vom
  September gefunden. Die Entscheidung, die dort aussteht, ist dann die
  Aufgabe, und ein neuer Eintrag entfällt.
