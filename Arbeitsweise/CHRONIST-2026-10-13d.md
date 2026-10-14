---
name: chronist-2026-10-13d
description: "CHRONIST-Lauf 13.10.2026 (vierter): neue Lehre fund-ganz-abhaken mit Werkzeug tools/fund-punkte.pl (N1 nur in einer Richtung behoben), Nachträge zu erlaubnis-nicht-hineinlesen (Rollen in Fragen ausschreiben) und einwurf-ist-ein-messwert (neue Zeit mit dem Fund melden)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T10:40:00.000Z
---

Schranke: keine - dies ist der Bericht eines CHRONIST-Laufs, keine Lehre. Jede neue oder ergänzte Lehre trägt ihre eigene Schranke-Zeile.

# CHRONIST, Lauf vom 13.10.2026 (vierter)

## Quelle

| Transkript | Zeitraum (UTC) | Nachrichten Gregor | davon Einwurf |
|---|---|---:|---:|
| `7cea137a-…jsonl` | 13.10.2026, 10:11–10:30 | 3 | 2 (66 %) |

Gezählt mit `perl tools/verlauf-messen.pl <transkript> 2026-10-13T10:11`.
Werkzeugaufrufe 24, größter Block ohne neue Nachricht 3. Für den Hergang von
N1 wurde ab 10:05 gelesen, dazu `Befunde/PRUEFER-23.md` (N1, Zeilen 181-216)
und die Commits `9f5142b`, `bf96856`.

## Neu

| Lehre | Kern |
|---|---|
| [fund-ganz-abhaken](fund-ganz-abhaken.md) | `9f5142b` behob nur den Breitendeckel. PRÜFER-23 N1 nannte die Gegenrichtung `:3663-3669` und schrieb im Vorschlag *„Ebenso für die Breite"*. LEKTOR-29 fand die zweite Hälfte 13 Minuten später (`bf96856`). Das ist das zweite Mal am Vormittag nach PRÜFER-22 F2, daher mit Werkzeug |

## Nachträge

| Lehre | Kern |
|---|---|
| [erlaubnis-nicht-hineinlesen](erlaubnis-nicht-hineinlesen.md) | Die vorgegebenen Antworten wirkten, *„nein, erst rollen"* war eindeutig. *„die drei Rollen"* ohne Namen: Gregor riet zwei (*„wenn du lerktor und prüfer meinst?"*). Außerdem bot die Frage wieder an, eine Schranke auszulassen, zehn Minuten nach dem Nachtrag, der das verbietet |
| [einwurf-ist-ein-messwert](einwurf-ist-ein-messwert.md) | *„kann ich was mergen?"* kam um 10:27:57, genau nach den 15 Minuten, die um 10:12 angekündigt waren. Der LEKTOR-Fund um 10:22 hatte die Arbeit verlängert, eine neue Zeit stand nicht dabei. Die Antwort selbst war richtig gebaut („Noch nicht" vorn) |
| [messung-muss-den-weg-treffen](messung-muss-den-weg-treffen.md), Fall 9 | Verweis auf die neue Lehre |

## Werkzeug

- `tools/fund-punkte.pl <Bericht> <anker>` neu, in `tools/WERKZEUGE.md`
  eingetragen. `--selbsttest` mit 5 Fällen richtig (Gegenrichtung gefunden,
  Nachbarabschnitt nicht hineingelesen, kein Fehlalarm ohne zweiten Fall,
  fehlender Anker erkannt). Gegenprobe an den echten Fällen:
  `PRUEFER-23.md n1` liefert 7 Orte und 3 zweite Fälle, darunter
  `Gegenrichtung :3663-3669`. `PRUEFER-22.md F2` liefert
  `PgEmbeddedImage.cpp:384-392` als ersten Ort. Beide Lücken des Vormittags
  stehen also in der Liste.
- **Kein Haken.** Welcher Fund gerade behoben wird, weiß der pre-commit
  nicht. Auslöser ist der erste Handgriff an einem Fund. Vorschlag für die
  Hauptsitzung: Der Auftrag „Fund X beheben" beginnt mit diesem Aufruf.

## Verworfen

- **„kann ich was mergen?" als eigene Lehre:** verworfen. Die Antwort folgte
  [abschalten-ist-ein-termin](abschalten-ist-ein-termin.md) Punkt 1 und
  [chat-knapp-halten](chat-knapp-halten.md) (*„Noch nicht"* vorn, Stand des
  Zweigs dahinter). Neu daran ist nur der Zeitpunkt, und der steht als
  Nachtrag bei `einwurf-ist-ein-messwert`.
- **„Rollennamen ausschreiben" als eigene Lehre:** verworfen, als Nachtrag
  zu `erlaubnis-nicht-hineinlesen`. Dort steht schon, wie eine Frage an
  Gregor gebaut wird.
