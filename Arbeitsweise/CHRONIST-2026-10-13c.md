---
name: chronist-2026-10-13c
description: "CHRONIST-Lauf 13.10.2026 (dritter): neue Lehre quelle-muss-im-bau-stehen mit Werkzeug tools/wer-baut.pl, Nachträge zu messung-muss-den-weg-treffen (F2) und erlaubnis-nicht-hineinlesen („ok“ auf Entweder-oder)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T10:20:00.000Z
---

Schranke: keine - dies ist der Bericht eines CHRONIST-Laufs, keine Lehre. Jede neue oder ergänzte Lehre trägt ihre eigene Schranke-Zeile.

# CHRONIST, Lauf vom 13.10.2026 (dritter)

## Quelle

| Transkript | Zeitraum (UTC) | Nachrichten Gregor | davon Einwurf |
|---|---|---:|---:|
| `7cea137a-…jsonl` | 13.10.2026, 09:31–10:11 | 1 | 1 (100 %) |

Gezählt mit `perl tools/verlauf-messen.pl <transkript> 2026-10-13T09:31`.
Werkzeugaufrufe 64, größter Block ohne neue Nachricht 7. Die einzige
Nachricht war das „ok" um 10:09. Für den Hergang von F1 und F2 wurde ab
09:20 gelesen, weil die PGEMBED-Änderung noch vor dem Zeitraum lag.

## Neu

| Lehre | Kern |
|---|---|
| [quelle-muss-im-bau-stehen](quelle-muss-im-bau-stehen.md) | F1 in `PGEMBED.C` eingebaut (`dae6727`, 09:21). Kein Projekt der Mappe baut die Datei, der Bau blieb grün, wirkungslos laut Messung 09:38, richtig in `PGHTMIMP.CPP` (`ac8f030`). Im Bestand stehen 379 von 1727 Quellen in keinem Projekt. Neues Werkzeug `tools/wer-baut.pl` |

## Nachträge

| Lehre | Kern |
|---|---|
| [messung-muss-den-weg-treffen](messung-muss-den-weg-treffen.md), Fall 9 | F2-Regel grün getestet, am Ladeweg stand die Angabe in `source_*`, `embed` war 0. PRÜFER-22 hatte die Ladestelle genannt. Gleiche Klasse wie Fall 8 vom Vortag |
| [erlaubnis-nicht-hineinlesen](erlaubnis-nicht-hineinlesen.md) | „ok" auf „Rollen laufen lassen oder auslassen?". Diesmal richtig nicht als Freigabe gelesen. Fehler war die Frage: Sie bot das Auslassen einer Schranke an und nannte Kosten von 15 Minuten, die parallel fast null waren |

## Werkzeug

- `tools/wer-baut.pl` neu, in `tools/WERKZEUGE.md` eingetragen. Gegenprobe
  `--selbsttest`, 6 Fälle richtig. Dazu `PGEMBED.C` vorgemerkt: `--staged`
  meldet `NEIN` bei Rückgabe 0, ohne Vormerkung still. Als Dateiaufruf
  liefert es Rückgabe 1.
- `tools/hooks-einrichten.sh`: Schritt 1c im pre-commit meldet nur und weist
  nicht ab (`sh -n` sauber). **Wirkt erst nach `sh tools/hooks-einrichten.sh`
  im Hauptbaum.** Nicht von mir ausgeführt: Die Haken liegen im gemeinsamen
  git-Verzeichnis.

## Bewertet, nicht geändert: Rollenschranke „nach jedem Merge wieder fällig"

Gemessen an `9f5142b`. Eine **Endlosschleife ist es nicht.** LEKTOR schließt
`Arbeitsweise/` und die beiden Werkzeugprotokolle aus. CHRONIST zählt keine
`.md` im Wurzelverzeichnis. Die beiden Rollen machen sich gegenseitig also
nicht mehr fällig, das ist seit dem 12.10. abgestellt. Fällig werden sie
durch die **eigenen Commits der Hauptsitzung nach dem Start der Rolle**:
LEKTOR durch `BEFUNDE.md` und `CHANGELOG.md` (N1-Eintrag), CHRONIST durch
die Quellen der F1-, F2- und N1-Behebung. Das ist so gewollt und eher eine Treppe:
Wer nach dem Rollenstart noch Messeinträge schreibt, hat beim Paket wieder
eine fällige Rolle.

Zwei Schwächen, als Vorschlag:

1. CHRONISTs Muster `^(?:Eudora71/|tools/)` zählt die eingecheckten
   Bauausgaben mit, etwa `Eudora71/Bin/Release/*.dll` (7 von 13 Dateien
   am Stand `9f5142b`). Ein Neubau ist kein Ereignis im Chat. Vorschlag:
   `Eudora71/Bin/` in `ausser` aufnehmen.
2. Gegen die Treppe hilft keine Änderung am Werkzeug, sondern die
   Reihenfolge: Die Messeinträge kommen **vor** dem Rollenstart. Oder die
   Rollen laufen parallel zum letzten Bau, wie um 10:09 geschehen.

## Geprüft und verworfen

- **pre-commit, der Änderungen an ungebauten Quellen abweist:** verworfen,
  nur melden. Kommentare oder Spurmarken in Fremdquellen können gewollt
  sein. Ein abweisender Haken würde umgangen
  ([schranke-gehoert-in-den-haken](schranke-gehoert-in-den-haken.md):
  Hinweise dürfen nicht abweisen).
- **F2 als eigene Lehre:** Es ist Fall 8 einen Tag später, deshalb ein
  Nachtrag als Fall 9.
- **„ok" als eigene Lehre:** Die Lesart ist in `erlaubnis-nicht-hineinlesen`
  schon geregelt („es gilt der kleinere Umfang"). Neu ist nur die Bauart der
  Frage, deshalb ein Nachtrag.
