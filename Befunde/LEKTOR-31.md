# <a id="lektor-31"></a>LEKTOR-31 — 7.2.0.87, Gregors Urteile an 1.0.86, E-118 berichtigt

Lauf am 13.10.2026 auf `wt/lektor`, nach dem Merge von `origin/e-112-skalierung`
(vorgespult auf `2d7c922`) und, auf Anweisung, von `origin/wt/pruefer`
([PRÜFER-25](PRUEFER-25.md), `f2415c7`). Umfang: die Themen seit [LEKTOR-30](LEKTOR-30.md#lektor-30), in **allen**
MDs gegen den Bestand gesucht (`git ls-files '*.md'`, 202 Dateien), nicht gegen
den Diff. Die Berichte unter `Befunde/` bleiben, wie sie sind.

Maßstab: `BEFUNDE.md` (Urteilszeilen zu [E-103](../BEFUNDE.md#e-103), [E-112](../BEFUNDE.md#e-112), [E-115](../BEFUNDE.md#e-115) bis [E-120](../BEFUNDE.md#e-120), [E-105](../BEFUNDE.md#e-105)),
`Eudora71/Version.h` (7.2.0.87), `VERSION` (1.0.87), die Prüfnachricht
`Testdaten/e117-amp-in-bildadresse.eml` (gemessen: 14 CRLF, 0 nackte LF, 0 Bytes
≥ 0x80, ein `<img>`), `tools/bildserver-e117.pl` (Aufruf aus dem Quelltext
gelesen) und für [L-31.6](#l-31.6) die Quelle selbst (`ImapAppend.cpp`, `PGHTMIMP.CPP`).

`commit-bereit.pl` meldete vor dem Lauf 28 von 28 grün — keiner der Mängel unten
wurde von einer Schranke gefunden.

## Mängel

### <a id="l-31.1"></a>L-31.1 — Stand-Köpfe: 7.2.0.85, „ungemessen“, „von Gregor noch nicht bestätigt“

| Datei | Belegzitat | geändert |
|---|---|---|
| `WEITERMACHEN.md`, *Quellstand* | *„7.2.0.85 (`Eudora71/Version.h`), in Arbeit“* | 7.2.0.87 |
| `WEITERMACHEN.md`, *Paketnummer* | *„[E-117](../BEFUNDE.md#e-117) … am laufenden Programm ungemessen“*, *„[E-115](../BEFUNDE.md#e-115) … Wirkung nicht gemessen“*, *„Von Gregor noch nicht bestätigt“* | gemessen (beide), [E-112](../BEFUNDE.md#e-112)/[E-103](../BEFUNDE.md#e-103)/[E-115](../BEFUNDE.md#e-115) an 1.0.86 bestätigt, neue Befunde genannt |
| `WEITERMACHEN.md`, Zeile [E-103](../BEFUNDE.md#e-103) | *„DURCHGEFALLEN an 1.0.84“*, *„von Gregor noch nicht bestätigt“* | *„BESTÄTIGT an 1.0.86 (an 1.0.84 durchgefallen)“* |
| `WEITERMACHEN.md`, *Zuletzt von Gregor bestätigt* | begann mit 1.0.84 | 1.0.86 vorangestellt |
| `ZIEL.md`, Stand | *„Quellstand ist jetzt 7.2.0.85 / Paket 1.0.85 … von Gregor noch nicht bestätigt“*, *„[E-117](../BEFUNDE.md#e-117) … ungemessen“* | 7.2.0.87, 1.0.85/1.0.86 als Testverzeichnisse, Bestätigungen, [E-118](../BEFUNDE.md#e-118)/[E-119](../BEFUNDE.md#e-119)/[E-105](../BEFUNDE.md#e-105) |
| `AUFGABEN.md`, Stand-Kopf | *„[E-117](../BEFUNDE.md#e-117) eingebaut, ungemessen; davor [E-115](../BEFUNDE.md#e-115) eingebaut, ungemessen“*, *„von Gregor noch nicht bestätigt“* | ebenso; Absatz [E-112](../BEFUNDE.md#e-112) und Kasten oben mitgezogen |
| `PORTIERUNG.md`, Stand | *„Stand 13.10.2026: Quellstand 7.2.0.85“* | neuer Absatz für 7.2.0.87 davor, der alte als „mittags“ |
| `README.md`, [E-112](../BEFUNDE.md#e-112) und [E-115](../BEFUNDE.md#e-115) | *„noch nicht ausgeliefert und von Gregor noch nicht bestätigt“*; [E-115](../BEFUNDE.md#e-115) *„offen … Ohne IMAP-Konto nicht nachgestellt“* | bestätigt an 1.0.86, [E-115](../BEFUNDE.md#e-115) behoben in 7.2.0.86 |
| `Releases/PAKETE.md`, Kopf, 1.0.85–1.0.87 | *„Quellstand 1.0.85 in Arbeit“*; 1.0.86 *„Von Gregor noch nicht getestet“*; 1.0.87 ohne Testsuite | Kopf berichtigt, Zeile *Gregors Test* bei 1.0.86, 196/196 und Messwerte bei 1.0.87 |

### <a id="l-31.2"></a>L-31.2 — `CHANGELOG.md`: [E-115](../BEFUNDE.md#e-115) „Neu, offen“, 7.2.0.86 „Nicht gemessen“

*Noch offen* führte [E-115](../BEFUNDE.md#e-115) als *„Neu, offen … nicht nachgestellt“*, der Abschnitt
7.2.0.86 schloss mit *„Nicht gemessen: dass die Meldung danach ausbleibt“* —
`BEFUNDE.md` nennt die Gegenprobe (7.2.0.84 Meldung, 7.2.0.86 keine) und Gregors
Bestätigung. Berichtigt, mit Vermerk im Abschnitt. [E-112](../BEFUNDE.md#e-112) unter *Noch offen*:
*„von Gregor noch nicht bestätigt“* → bestätigt; im Abschnitt 7.2.0.85 eine Zeile
dazu. Neu unter *Noch offen*: [E-117](../BEFUNDE.md#e-117) (behoben, unbestätigt), [E-118](../BEFUNDE.md#e-118), [E-119](../BEFUNDE.md#e-119); bei [E-105](../BEFUNDE.md#e-105)
der zweite Fall.

### <a id="l-31.3"></a>L-31.3 — neue Befunde nur in `BEFUNDE.md` und `WEITERMACHEN.md`

[E-118](../BEFUNDE.md#e-118), [E-119](../BEFUNDE.md#e-119) und [E-120](../BEFUNDE.md#e-120) standen in keiner anderen MD (mit `grep` gezählt). Nachgetragen in
`README.md` (*Was es nicht kann*: [E-118](../BEFUNDE.md#e-118), [E-119](../BEFUNDE.md#e-119), [E-105](../BEFUNDE.md#e-105) zweiter Fall), `ZIEL.md`,
`AUFGABEN.md` (*Was sonst noch offen ist*: [E-115](../BEFUNDE.md#e-115) heraus, [E-118](../BEFUNDE.md#e-118)/[E-119](../BEFUNDE.md#e-119)/[E-105](../BEFUNDE.md#e-105) hinein),
`CHANGELOG.md`, `PORTIERUNG.md`, `Releases/PAKETE.md`. [E-120](../BEFUNDE.md#e-120) nur dort, wo Gregors Test
an 1.0.86 aufgezählt wird — es ist kein eigener Fehler.

Dazu in `README.md` ein Satzbaufehler: die Zeile *„Neu und eingebaut in 7.2.0.87,
noch ungemessen: [E-117](../BEFUNDE.md#e-117) …“* stand ohne Einrückung **mitten** im Satz *„eine Angabe
wie ⏎⏎ … `width="35px"` wird als 3508 gelesen“* und zerriss den Listenpunkt.
Eingeordnet und auf „behoben, gemessen, unbestätigt“ gebracht.

### <a id="l-31.4"></a>L-31.4 — `TESTPLAN.md`: kein Prüfschritt für 1.0.85 bis 1.0.87

Der Kopf nannte 1.0.87 und 1.0.85, der Plan selbst hatte keinen Abschnitt dazu.
Neu: **C4** mit [E-112](../BEFUNDE.md#e-112), [E-103](../BEFUNDE.md#e-103), [E-115](../BEFUNDE.md#e-115) (✅ an 1.0.86) und [E-117](../BEFUNDE.md#e-117) (☐, Handgriff an
Gregors eBay-Nachricht; Spurmarke `E-110 Laden`, Maske `DEBUG_MASK_MISC` = 0x8000,
in `LogLevel=58527` enthalten — an `PgEmbeddedImage.cpp:1007` und `debug.h:36`
gelesen). Kopf nachgezogen.

### <a id="l-31.5"></a>L-31.5 — `Testdaten/README.md`: `e117-amp-in-bildadresse.eml` fehlte

Neue Zeile mit Fall, Prüfweg und Bytes. Der Bildserver braucht vier Argumente
(`<port> <bild.png> <pixel.png> <log>`, aus `tools/bildserver-e117.pl` gelesen);
die beiden PNG liegen **nicht** im Repo — so vermerkt. [E-103](../BEFUNDE.md#e-103)/[E-112](../BEFUNDE.md#e-112)-Zeilen: bestätigt.

### <a id="l-31.6"></a>L-31.6 — [E-118](../BEFUNDE.md#e-118): Ursachenstelle falsch, [E-119](../BEFUNDE.md#e-119): Behebungsort zu spät (aus [PRÜFER-25](PRUEFER-25.md))

Auf Anweisung des Koordinators eingearbeitet. [PRÜFER-25](PRUEFER-25.md) H1: `AppendContentType`
läuft nur für Anhänge. Vom LEKTOR an der Quelle nachgelesen: `ImapAppend.cpp:120`
ist die **Deklaration**, die Aufrufe stehen nur an `:1640` und `:1650` (Anhangweg);
`:692` ruft `AppendMIMEMessageHeaders(NULL, …)`, `:880` `IsHeaderToInclude`,
`:1166-1169` schreibt fest `text/plain`. In `BEFUNDE.md` die Ursache ersetzt, die
alte Angabe als widerlegt mit Zitat stehen gelassen; `CHANGELOG.md`, `AUFGABEN.md`,
`README.md` mitgezogen. H2 ([E-119](../BEFUNDE.md#e-119)): `PGHTMIMP.CPP:3317-3318` (Kürzung auf
`kMaxAttributeSize - 1`) nachgelesen; Nachtrag in `BEFUNDE.md`, Zeile in `AUFGABEN.md`.
[PRÜFER-25](PRUEFER-25.md)s Urteil *auslieferbar* zu [E-115](../BEFUNDE.md#e-115) und [E-117](../BEFUNDE.md#e-117) in die Urteilszeilen übernommen.

## Nicht berichtigt

* Die Abschnittsköpfe 7.2.0.85 und 7.2.0.86 in `CHANGELOG.md` sagen weiter *„in
  Arbeit, nicht ausgeliefert“* — als Testverzeichnis liegen beide bei Gregor,
  veröffentlicht ist keine. Belassen: „ausgeliefert“ meint in diesen Köpfen
  durchgehend „veröffentlicht“; eine Umbenennung beträfe alle Köpfe, nicht nur zwei.
* `WEITERMACHEN.md` *Der nächste Schritt*, Punkt 4: *„`ImapAppend.cpp` kennt kein
  `text/html`“* — stimmt auch nach H1, belassen.
* [PRÜFER-25](PRUEFER-25.md) G1–G4 (Nebenfunde zu [E-117](../BEFUNDE.md#e-117)) sind nur in der Urteilszeile erwähnt,
  nicht als eigene Punkte in `WEITERMACHEN.md`. Entscheidung, ob sie eigene
  Befunde werden, liegt beim Koordinator.
* Die Bilddateien zum Bildserver fehlen im Repo ([L-31.5](#l-31.5)); nicht nachgeliefert.

## Nachgemessen

Siehe Commit-Nachrichten; alle geänderten MDs: UTF-8 ohne BOM, nur LF, 0 U+FFFD,
Backslash-Zahl vor/nach je Datei gleich bzw. um die neu geschriebenen Pfade erhöht.
