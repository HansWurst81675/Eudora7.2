---
name: datenformat-aendern-heisst-alle-leser-messen
description: "Wer das Format einer gemeinsam gelesenen Datei aendert, misst JEDEN Leser dagegen - sonst melden die blind gewordenen weiter gruen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f193092b-2e64-587f-a070-7e656c44c557
  modified: 2026-10-12T19:10:00.000Z
---

Schranke: tools/leser-vergleichen.pl - faehrt jeden Leser gegen einen Arbeitsbaum auf dem Stand davor und vergleicht die GANZE Ausgabe, nicht den Rueckgabewert. Von Hand vor jedem Commit, der ein Format aendert; nicht im Haken, weil sie einen zweiten Arbeitsbaum anlegt und sechzehn Werkzeuge zweimal faehrt. Gegengetestet: --tests mit 12 Faellen, und am echten Fehler (den Ankersprung in pruefe-befund-verbreitung.pl wieder entfernt - gemeldet als 'E-94 -> (keine)').

# Ein neues Zeichen in einer gemeinsamen Datei macht zwölf Werkzeuge blind

Am 12.10.2026 habe ich in `BEFUNDE.md` vor jede Kennung der Urteilstabelle
einen Anker gesetzt:

```
| E-94 | ...            ->    | <a id="e-94"></a>E-94 | ...
```

Eine Ergänzung, kein Umbau. Keine Zeile kam dazu, keine fiel weg, die
Bytezählung je Datei blieb gleich.

**Zwölf Werkzeuge lesen genau diese erste Zelle.** Alle zwölf haben sie danach
nicht mehr gefunden.

| Werkzeug | vorher | danach |
|---|---|---|
| `doku-pruefen.pl` | 164 Kennungen im Verzeichnis | **1** — und wies den Commit ab |
| `pruefe-behoben-ausgeliefert.pl` | 17 Urteile, 8 bestätigt | **0 und 0 — Rückgabewert trotzdem 0** |
| `pruefe-befund-verbreitung.pl` | Umfang `E-94` | **`(keine)` — Rückgabewert trotzdem 0** |
| `spuren-auswerten.pl` | frei | weist ab, meldet vier vorhandene Zeilen als fehlend |
| sechs weitere | — | Tabelle leer |
| `pruefe-anzeigetext.pl`, `pruefe-behoben-belegt.pl` | 0 Zeilen im Zuwachs | **378** — die ganze Tabelle galt als frisch |

Die gefährlichen sind nicht die, die abweisen. Die gefährlichen sind die
**zwei, die weiter grün meldeten, während sie nichts mehr prüften**. Ohne den
Vergleichslauf wären sie so geblieben, und beim nächsten echten Fehler hätte
niemand etwas gemerkt.

## Das Verfahren, und wie es jetzt heisst

```sh
perl tools/leser-vergleichen.pl            # gegen origin/main
perl tools/leser-vergleichen.pl <commit>   # gegen einen anderen Stand
```

Es legt einen Arbeitsbaum auf dem alten Stand an, sucht **im Quelltext**
jedes Werkzeug, das Markdown-Tabellenzeilen zerlegt, faehrt jedes in beiden
Baeumen und vergleicht die **ganze Ausgabe** — nicht den Rueckgabewert. Genau
darin steckte der Befund: `0 Urteile` statt `17 Urteile` bei gleichem
Rueckgabewert 0.

Die Liste der Leser wird **nicht** von Hand gefuehrt
([pruefumfang-nicht-von-hand](pruefumfang-nicht-von-hand.md)). Mein erster
Durchgang von Hand filterte auf `BEFUNDE` und uebersah deshalb
`spuren-auswerten.pl`, das `SPURMARKEN.md` liest. Das Werkzeug sucht nach dem
**Muster** — wer `^\|` zerlegt, ist ein Leser — und findet sechzehn.

Danach bleibt **jede** Abweichung zu erklaeren. Erlaubt sind nur die, die man
benennen kann: *„drei neue Lehren, deshalb 75 -> 78"*. Drei Werkzeuge sind
bewusst ausgenommen und werden dabei genannt, nicht verschwiegen:
`pruefe-branch.pl` (der Vergleichsbaum hat einen abgeloesten HEAD),
`pruefe-stand-md.pl` (zaehlt den neuen Bericht mit) und die `*-tests.pl`
(nennen ihren eigenen Pfad).

## Die Regel

1. Ändert sich das **Format** einer Datei, die mehrere Werkzeuge lesen, dann
   gehört zum selben Commit ein Lauf **aller** Leser gegen den Stand davor.
2. Wer die Leser sucht, sucht nach dem **Muster**, nicht nach dem Dateinamen:
   `grep -l '\^\\|' tools/*.pl` findet jeden, der Tabellenzeilen zerlegt — auch
   die, die eine ganz andere Datei lesen. Mein erster Durchgang filterte auf
   `BEFUNDE` und übersah deshalb `spuren-auswerten.pl`, das `SPURMARKEN.md`
   liest.
3. Die Leser lernen das neue Zeichen **zu überspringen**, nicht es zu
   verlangen — sonst bricht die alte Fassung der Datei.
4. Gleiches gilt für Schranken, die ihren Umfang aus dem **Zuwachs** nehmen:
   eine Zeile, die sich nur im Format geändert hat, ist kein Zuwachs
   (`tools/verweise-filtern.pl`, dasselbe wie
   `entmojibake_nur_kodierung_gefiltert()` für umkodierte Zeilen).

Dieselbe Familie wie
[gemeinsame-dateien-gegen-alles-messen](gemeinsame-dateien-gegen-alles-messen.md)
— dort ist es eine `stdafx.h`, die vier Projekte einbinden, hier eine
Tabellenzeile, die zwölf Werkzeuge lesen. Der Unterschied: ein Compiler sagt
`C1083`. Ein Perl-Muster, das nicht mehr trifft, sagt **gar nichts**.
