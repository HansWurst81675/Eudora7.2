# <a id="lektor-33"></a>LEKTOR-33 — Doku nach Release v1.0.87 und E-105 (7.2.0.88)

Lauf am 14.10.2026 auf `wt/lektor`, nach dem Merge von `origin/e-105_doppelte_bilder`
(`1d010e0f`, schneller Vorlauf). Umfang aus der Quelle: `git ls-files '*.md'` im
Wurzelverzeichnis, `tools/`, `Testdaten/`, `Releases/` — **31 Dateien**, ohne
`Befunde/` und `Arbeitsweise/`. Jede gegen den Bestand gelesen, nicht gegen den Diff.

Maßstab: `Eudora71/Version.h` **7.2.0.88**, `VERSION` **1.0.88**, höchste Marke
**`v1.0.87`** (auf `41c6752`), `gh release list` (`v1.0.87` *Latest*,
2026-10-14T05:46:20Z), die Urteilszeilen in `BEFUNDE.md` und `tools/RELEASES.md`.
`tools/doku-pruefen.pl`: kein Widerspruch. `tools/commit-bereit.pl`: 1 von 28
Schranken rot (`befunde-verlinken.pl`, drei nackte Kennungen) — berichtigt.

Der Stand nach Release und 7.2.0.88 ist in den führenden Dateien (`WEITERMACHEN.md`,
`AUFGABEN.md`, `ZIEL.md`, `PORTIERUNG.md`, `CHANGELOG.md`, `Releases/PAKETE.md`,
`tools/ZWEIGE.md`, `Testdaten/README.md`, `TESTPLAN.md`-Kopf) schon richtig
nachgezogen. Die Mängel sitzen an den Rändern.

## Berichtigt

### <a id="l-33.1"></a>L-33.1 — drei nackte Kennungen

`tools/TESTLAEUFE.md` (zwei Zeilen zum freenet-Newsletter) und
`tools/AGENTEN-LAUFEN.md` (dieser Lauf) nannten [E-105](../Intern/BEFUNDE.md#e-105) ohne Link.
Nachgezogen mit `perl tools/befunde-verlinken.pl --anker --verlinken`. Commit `663c15c`.

### <a id="l-33.2"></a>L-33.2 — `tools/RELEASES.md`: die Zeile zu `v1.0.87` stand außerhalb der Tabelle, in Ortszeit

Die Zeile hing direkt unter dem Blockzitat *„Nachgetragen am 17.09.2026 vom LEKTOR“*,
ohne Leerzeile — Markdown liest sie als Fortsetzung des Zitats, nicht als
Tabellenzeile. Und ihre Zeit war `07:46:21`, Ortszeit; alle anderen Zeilen führen
UTC, wie `gh release list` (`v1.0.84` 12:59:15, `v1.0.83` 11:18:20).
Jetzt: in die Tabelle hinter `v1.0.84` verschoben, Zeit `05:46:20` nach
`gh release list`. Commit `7210f087`. Ursache siehe [L-33.6](#l-33.6).

### <a id="l-33.3"></a>L-33.3 — E-105 an drei Stellen noch im Zustand vor dem Einbau

| Datei, Stelle | stand | jetzt |
|---|---|---|
| `AUFGABEN.md`, Tabelle der nächsten Schritte | *„Entscheidung, ob Paige `display:none` lernen soll“* | gestrichen; eingebaut in 7.2.0.88, gemessen, offen bis Gregors Test an 1.0.88 |
| `README.md`, Liste der bekannten Fehler | *„([E-105](../Intern/BEFUNDE.md#e-105), offen)“* | *„im Download `v1.0.87` offen; Behebung in 7.2.0.88 eingebaut, noch nicht ausgeliefert, von Gregor noch nicht bestätigt“* |
| `WEITERMACHEN.md`, Stand-Block [LEKTOR-32](LEKTOR-32.md#lektor-32) | *„Nächster Schritt: [E-105](../Intern/BEFUNDE.md#e-105)“* ohne Ergebnis | Nachtrag: eingebaut, gemessen, es fehlen Paket 1.0.88 bei Gregor und sein Urteil |

## Offen — mit Ermessen, nicht berichtigt

### <a id="l-33.4"></a>L-33.4 — E-95 und E-96 bleiben offen; Gregors E-112-Bestätigung deckt sie nicht

**Urteil: offen.** Die Bestätigung von [E-112](../Intern/BEFUNDE.md#e-112) an 1.0.86
(13.10.2026, *„paßt dagegen“*) gilt der **Kleinanzeigen**-Nachricht: ein Logo steht
in der angegebenen Größe **über** dem Text statt darauf. Geprüft wird damit
Größe und Überdeckung **eines** Bildes.

* [E-95](../Intern/BEFUNDE.md#e-95) ist ein anderes Fehlerbild: im Verfassenfenster wurden
  Bilder **zerschnitten** bzw. auf 20×20 **gequetscht** — an der **Mail-A**-Nachricht
  (eingebettete `cid:`-Bilder) und an der Mail-B.
* [E-96](../Intern/BEFUNDE.md#e-96) betrifft **mehrere** Bilder unterschiedlicher Höhe
  hintereinander (jedes bekam die Zeilenhöhe des ersten). Gemessen nur im eigenen
  Lauf vom 15.09.2026.

In `BEFUNDE.md`, `WEITERMACHEN.md`, `TESTPLAN.md`, `CHANGELOG.md` und allen
`Befunde/*.md` steht **kein** Zitat Gregors zu Mail-A, Mail-B oder
abgeschnittenen Bildern nach dem 15.09.2026. Die Urteilszeile zu
[E-95](../Intern/BEFUNDE.md#e-95) sagt selbst *„von Gregor noch nicht am laufenden
Programm bestätigt“*. TESTPLAN C3 führt beide zu Recht als offen.

**Was Gregor dafür tun müsste** (aus `WEITERMACHEN.md`, Zeile *VON GREGOR ZU
PRÜFEN, 15.09.2026*, und `CHANGELOG.md` 7.2.0.63): mit 1.0.87 oder 1.0.88 die
**Mail-A**- und die **Mail-B**-Nachricht je einmal **beantworten** und
**weiterleiten**. Zu sehen sein muss: kein Bild abgeschnitten, keines auf 20×20
gequetscht, jedes Bild in eigener Höhe, der Text frei.

### <a id="l-33.5"></a>L-33.5 — TESTPLAN C3: der Handgriff zu E-95 prüft das Falsche

In C3 steht für [E-95](../Intern/BEFUNDE.md#e-95): *„antworten/weiterleiten mit Bildern —
Bilder in der **angegebenen** Größe“*. Das ist das Kriterium von
[E-112](../Intern/BEFUNDE.md#e-112), nicht von [E-95](../Intern/BEFUNDE.md#e-95) — und genau diese Formulierung lädt
dazu ein, die E-112-Bestätigung als Erledigung von [E-95](../Intern/BEFUNDE.md#e-95) zu lesen. `WEITERMACHEN.md`
beschreibt [E-95](../Intern/BEFUNDE.md#e-95)/[E-96](../Intern/BEFUNDE.md#e-96) dagegen als *„die Bilder behalten ihre wirkliche Größe, und
jedes bekommt seine eigene Zeilenhöhe“* mit den Mail-A und Mail-B.
**Vorschlag:** die beiden C3-Zeilen auf den Handgriff aus [L-33.4](#l-33.4)
umschreiben. Nicht selbst geändert, weil das die Prüfanweisung an Gregor ändert.

### <a id="l-33.6"></a>L-33.6 — `tools/release-veroeffentlichen.ps1` schreibt die Zeile falsch

Zeile 283: `Get-Date -Format 'yyyy-MM-dd HH:mm:ss'` liefert Ortszeit, die Tabelle
führt UTC. Und die Zeile wird ans **Dateiende** gehängt, das seit dem 17.09.2026
ein Blockzitat ist — dadurch fiel sie aus der Tabelle ([L-33.2](#l-33.2)). Beim
nächsten Release passiert beides wieder. Vorschlag: `(Get-Date).ToUniversalTime()`
und hinter der letzten Tabellenzeile einfügen statt anhängen (oder das Blockzitat
über die Tabelle stellen). Nicht geändert — Werkzeugänderung mit Gegentest.

### <a id="l-33.7"></a>L-33.7 — TESTPLAN hat keinen Schritt für 1.0.88

Kopf und C4 enden bei 1.0.87. Für [E-105](../Intern/BEFUNDE.md#e-105) gibt es keinen
Handgriff. Solange 1.0.88 nicht bei Gregor liegt, ist das kein Fehler; mit dem
Paket gehört ein Abschnitt C5 dazu (den freenet-Newsletter „Änderungen für
Autofahrer“ und eine eBay-Nachricht mit Fragezeichenzeile öffnen und weiterleiten:
Titelbild einmal, keine `? ? ? ?`-Zeile).

### <a id="l-33.8"></a>L-33.8 — Rollen fällig

Der Commit-Haken meldet **PRÜFER** fällig (5 Dateien seit `f2415c7`, u. a.
`Tests/TestE105.cpp`) und **CHRONIST** fällig (11 Dateien seit `2edceb4`, u. a.
`PGHTMIMP.CPP`). Vor einem Paket 1.0.88 laufen lassen.

### <a id="l-33.9"></a>L-33.9 — zur Kenntnis aus `doku-pruefen.pl`

`tools/WERKZEUGE.md` (höchste Fassung 7.2.0.85), `tools/ZWEIGE.md` (7.2.0.84) und
`tools/pruefdaten/LIESMICH.md` (7.2.0.83) nennen 7.2.0.88 nicht. Gelesen: keine
der drei gibt eine ältere Fassung als aktuellen Stand aus; `ZWEIGE.md` führt den
Zweig `e-105_doppelte_bilder`. Kein Mangel.
