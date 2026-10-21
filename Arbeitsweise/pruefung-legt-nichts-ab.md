---
name: pruefung-legt-nichts-ab
description: "Eine Pruefung, die zum Messen etwas Ausfuehrbares auspackt, misst am Ende den Virenscanner mit - am 20.10.2026 zog Defender die von unserer eigenen Schranke ausgepackte Eudora.exe ein, und die Schranke meldete danach eine falsche Fassung fuer ein richtiges Paket"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-10-21T05:38:42.281Z
---

Schranke: tools/pruefe-auspacken.pl (pre-commit) - kein tools/pruefe-*.pl und kein tools/*-pruefen.* legt etwas Ausfuehrbares auf die Platte (unzip ohne -p, Expand-Archive, ExtractToDirectory, 7z x, tar -x); Ausnahme nur mit der Zeile „auspacken-erlaubt: <Grund>" im Werkzeug. Gegengetestet mit --selbsttest (14 Faelle in beide Richtungen), am echten Stand `1d081b27^` von `pruefe-behoben-ausgeliefert.pl` (weist ab) und am heutigen Bestand (56 Prüfwerkzeuge, lässt durch).

# Eine Prüfung legt nichts ab

**Regel.** Eine Prüfung darf das Geprüfte nicht verändern. Sie packt nichts
aus, startet nichts, räumt nichts weg und schreibt nichts neben das Ziel. Was
sie lesen muss, liest sie aus dem Strom. Und wenn sie nichts lesen konnte,
meldet sie **ungeprüft** — niemals einen Befund.

## Was passiert ist (20.10.2026, Zeiten Ortszeit)

Defender hat an diesem Tag **dreimal** zugeschlagen ([E-124](../BEFUNDE.md#e-124)):

| Zeit | Datei | ausgelöst von |
|---|---|---|
| 13:17:28 | `Eudora.exe` des Baus von 13:09:05 (daraus Paket 1.0.111) | — acht Minuten nach einem Scan mit **0 Funden** |
| 20:33:12 | `C:\Users\Gregor\Eudora72-1.0.113-release\Eudora.exe` | **beim Ausführen** (Gregor: *„virus alarm vom defender!"*) |
| 20:45:19 | `Releases\.pruefe-behoben-1.0.113\Eudora.exe` | **`perl.exe`** — unsere eigene Schranke |

Der dritte Fall ist der, um den es hier geht.
`tools/pruefe-behoben-ausgeliefert.pl` packte die `Eudora.exe` aus dem
Release-ZIP in ein Verzeichnis unter `Releases/`, um die Versionsressource zu
lesen. Defender zog die ausgepackte Datei ein. Die Schranke fand danach keine
Bytes mehr und meldete:

> *„Paket 1.0.113: in der `Eudora.exe` steht keine Fassung 7.2.0.NN"*

**Eine falsche Aussage über ein richtiges Paket, erzeugt von der Prüfung
selbst.** Das Paket war in Ordnung; der Scanner hatte die Probe gefressen, die
die Schranke selbst hingelegt hatte.

Behoben in `1d081b27`, zwei Änderungen, die zusammengehören:

1. Gelesen wird über `unzip -p` aus dem Strom. Was nie auf der Platte liegt,
   kann kein Virenscanner einziehen, kein Indexdienst öffnen und keine zweite
   Prüfung versehentlich mitmessen.
2. **„nicht lesbar" ist etwas anderes als „falsche Fassung".** Nur wenn Bytes
   ankamen, gilt das Paket als geprüft; sonst bleibt es ungeprüft und fällt
   unter den Satz, der schon in der Datei stand: *„NICHTS GEPRUEFT ist kein
   gruenes Ergebnis."*

## Derselbe Fehler ohne Virenscanner: das Messskript am Über-Dialog

Am selben Abend, 21:31 Uhr: das Skript, das den Über-Dialog messen sollte,
**räumte vor der Messung offene Dialoge weg** — und erkannte danach den
Dialog nicht wieder, den es selbst geöffnet hatte (*„KEIN Dialog gefunden"*).
Beide Fälle sind dieselbe Klasse: die Messung greift in das ein, was sie
messen soll, und liefert danach eine Aussage über ihr eigenes Eingreifen.

Ein Virenscanner ist dabei kein Sonderfall, sondern nur der sichtbarste
Mitleser. Auf dieser Maschine lesen mit: Defender, die Suchindizierung,
`git status` (eine neue Datei im Arbeitsbaum), und jede andere Schranke, die
unter `Releases/` zählt.

## Warum die vorhandenen Lehren nicht gegriffen haben

- [[paket-gegen-den-bau-messen]] verlangt, das Paket gegen das Bauverzeichnis
  zu messen — genau das wollte die Schranke tun. Sie sagt nichts darüber,
  **wie** gemessen wird.
- [[schranke-gegentesten]] verlangt den Gegentest beim **Bau** der Schranke.
  Diese Schranke war gegengetestet und lief seit Wochen grün; der Schaden
  entstand erst, als eine fremde Software auf ihre Spur reagierte.
- [[pruefstand-kann-blind-sein]] handelt von einer Prüfung, die **nichts**
  meldet. Hier hat sie etwas gemeldet, und zwar das Falsche. Das ist teurer:
  eine stumme Prüfung weckt Misstrauen, eine falsche Aussage wird geglaubt.

## How to apply

1. **Vor dem Schreiben einer Prüfung die Frage stellen: lege ich etwas ab?**
   Dateien, Verzeichnisse, Registry-Werte, laufende Prozesse, geschlossene
   Fenster. Wenn ja: aus dem Strom lesen (`unzip -p`, `git show`,
   `-WhatIf`), oder in ein Wegwerf-Repo außerhalb des Arbeitsbaums.
2. **Nichts Ausführbares auf die Platte.** Eine `.exe`, die nur zum Messen
   existiert, ist für jeden Scanner eine frisch geschriebene unsignierte
   Binärdatei aus einem Archiv — das Muster, auf das `!ml`-Erkennungen
   ansprechen.
3. **„Nichts gefunden" nie als Befund melden.** Ein Werkzeug, das seine
   Eingabe nicht lesen konnte, schreibt *ungeprüft* und sagt, warum
   ([[ausbleiben-ist-kein-befund]]).
4. **Eine Messung, die aufräumt, räumt ihren eigenen Treffer weg.** Wer vor
   der Messung Fenster schließt, Dateien löscht oder Zustände zurücksetzt,
   protokolliert jeden dieser Eingriffe mit — sonst ist das Ergebnis nicht
   deutbar.
5. **Ein gezielter Scan ist kein Freispruch.** Derselbe `Start-MpScan` auf
   dieselbe Datei meldete nichts, während der Start sie einzog
   ([E-124](../BEFUNDE.md#e-124)).

**Lücke der Schranke.** Sie liest Text und erkennt die fünf gängigen
Auspack-Befehle. Wer in einem Prüfwerkzeug über eine selbstgebaute Funktion
oder über ein anderes Skript auspackt, kommt durch. Sie schützt auch nicht vor
dem Ablegen anderer Dinge (Registry, Prozesse) — dafür gibt es nur Punkt 1.
