---
name: tor-gehoert-zum-schritt
description: "Jede Schranke gehoert zu genau EINEM Schritt und sagt ueber die anderen nichts - am 21.10.2026 hielt die Abweisung von paket-bereit.pl (Schranke vor dem BAUEN) das Veroeffentlichen von 1.0.120 auf, obwohl das Paket seit Stunden fertig war und release-veroeffentlichen.ps1 in WERKZEUGE.md Zeile 123 stand"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-21T20:10:00.000Z
---

Schranke: `tools/paket-bereit.pl` nennt seit dem 21.10.2026 in **beiden** Ausgaben seinen Umfang — im grünen Fall („das Paket kann **gebaut** werden … über das Veröffentlichen sagt das nichts") und im roten Fall mit dem zuständigen Tor für den Nachbarschritt. Gegenprobe: beide Ausgabewege einmal gefahren, beide nennen `tools/release-veroeffentlichen.ps1`.

# Ein Tor gehört zu einem Schritt

**Regel.** Bevor eine Schranke gefahren wird, steht fest, **welchen Schritt**
sie bewacht. Ihre Abweisung gilt für diesen Schritt und für keinen anderen.
Und umgekehrt: zu einem Schritt, den Gregor nennt, wird das Tor **nachge-
schlagen** — in `tools/WERKZEUGE.md` — und nicht aus dem Gedächtnis gewählt.

## Was passiert ist (21.10.2026, abends)

Gregor wollte das GitHub-Release zu 1.0.120 fertig haben. Das Paket war seit
Stunden gebaut, der Tag kam um 21:07:37 (`tools/RELEASES.md`, Zeile 49).
Gelaufen ist trotzdem:

```
perl tools/paket-bereit.pl     ->  WEIST AB (LEKTOR faellig)
```

Darauf folgte eine halbe Stunde Sortieren von Rollen und Arbeitsbäumen.
Gregor: *„was ist das wieder für chaos? wir bauen es doch nicht zum ersten
mal."*

Beides war falsch, auf zwei verschiedene Weisen:

| | |
|---|---|
| **Falsches Tor gewählt** | `paket-bereit.pl` liest seine Liste aus `paket-bauen.ps1` — es ist die Schranke vor dem **Bauen**. Der Schritt hieß **Veröffentlichen**, und dafür gibt es `tools/release-veroeffentlichen.ps1` mit eigenen Voraussetzungen (Gregors Freigabe, CHANGELOG-Bestätigung, Nummern, ZIP). Der Weg stand in `tools/WERKZEUGE.md`, **Zeile 123**, und wurde nicht nachgeschlagen |
| **Fremde Abweisung als eigene gelesen** | Die Abweisung war inhaltlich richtig — für einen Paketbau. Für das Veröffentlichen eines schon gebauten Pakets sagt sie nichts. Gehandelt wurde trotzdem nach ihr |

## Warum die benachbarten Lehren nicht gegriffen haben

- [[werkzeug-vor-eigenbau]] fragt *„gibt es dafür schon etwas?"* — vor dem
  **Eigenbau**. Hier wurde nichts gebaut; es wurde ein vorhandenes Werkzeug
  benutzt, nur das falsche. Diesen Moment kennt die Lehre nicht.
- [[bestand-vor-neuer-suche]] zielt auf `BEFUNDE.md` und den Auslöser
  `offene-befunde.pl`/`befund-suchen.pl`. `WERKZEUGE.md` hat keinen solchen
  Auslöser.
- [[ausloeser-an-den-anfang]] benennt die Ursache genau, ohne diesen Fall
  abzudecken: die Frage *„welches Tor gehört zu diesem Schritt?"* muss am
  **Anfang** stehen, nicht nachdem eine Abweisung schon gelesen wurde.

Die Antwort ist deshalb kein weiterer Vorsatz und kein Nachschlagewerkzeug —
ein `grep` über `WERKZEUGE.md` hätte nicht gefeuert, denn der Fehler war
**nicht nachzusehen**. Die Antwort sitzt dort, wo der Fehler entsteht: in der
Ausgabe der Schranke selbst.

## How to apply

1. **Den Schritt benennen, bevor ein Werkzeug läuft.** Bauen, Veröffentlichen,
   Committen, Pushen, Mergen, Starten, Abschalten — das sind verschiedene
   Schritte mit verschiedenen Toren.
2. **Zum genannten Schritt das Tor nachschlagen**, in `tools/WERKZEUGE.md`.
   Drei Werkzeuge stehen dort als *„der einzige erlaubte Weg"*: `testlauf.ps1`
   (Starten), `release-veroeffentlichen.ps1` (Release), `paket-bauen.ps1`
   (Paket).
3. **Eine Abweisung zuerst auf Zuständigkeit lesen.** *Ist das überhaupt mein
   Schritt?* Wenn nein: notieren, weitergeben, weitermachen — nicht abbiegen.
4. **Wer eine Schranke baut, schreibt ihren Umfang in ihre Ausgabe** — in den
   grünen Fall genauso wie in den roten. „Alle Schranken frei" ohne Angabe,
   wofür, wird für das Tor des nächsten Schritts gehalten.
5. **Buchführung ist nicht der Schritt, auf den Gregor wartet**
   ([[funktionsbug-vor-buchfuehrung]]). Eine fällige Rolle hält das
   Veröffentlichen nicht auf; sie läuft daneben.
