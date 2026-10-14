# <a id="lektor-32"></a>LEKTOR-32 — E-117 an 1.0.87 bestätigt, Zweig bereit für den PR

Lauf am 14.10.2026 auf `wt/lektor`, nach dem Merge von `origin/e-112-skalierung`
(`1ea7fb3`). Kurzlauf vor dem PR `e-112-skalierung` → `main`. Umfang: **alle**
MDs (`git ls-files '*.md'`, 205 Dateien) nach Stellen gesucht, die
[E-117](../BEFUNDE.md#e-117) oder 1.0.87 betreffen, nicht der Diff. Die Berichte
unter `Befunde/` und die `Arbeitsweise/CHRONIST-*.md` bleiben, wie sie sind.

Maßstab: die Urteilszeile zu [E-117](../BEFUNDE.md#e-117) in `BEFUNDE.md`
(*„behoben in 7.2.0.87, von Gregor an 1.0.87 bestätigt am 14.10.2026“*, Commit
`1ea7fb3`) und `Releases/1.0.87/TESTEN.txt`. Damit sind alle Behebungen des
Zweigs bestätigt: [E-112](../BEFUNDE.md#e-112), [E-103](../BEFUNDE.md#e-103),
[E-115](../BEFUNDE.md#e-115) (an 1.0.86), [E-117](../BEFUNDE.md#e-117) (an 1.0.87).
Offen bleiben u. a. [E-118](../BEFUNDE.md#e-118), [E-119](../BEFUNDE.md#e-119),
[E-105](../BEFUNDE.md#e-105), [E-116](../BEFUNDE.md#e-116).

## Mängel

### <a id="l-32.1"></a>L-32.1 — E-117 überall noch „von Gregor nicht bestätigt“

Die Bestätigung stand nur im Kopf der Zeile in `BEFUNDE.md`; im Rumpf derselben
Zeile und in neun weiteren Dateien hieß es weiter *„von Gregor noch nicht
bestätigt“*, *„in Arbeit, nicht ausgeliefert“* oder *„noch nicht getestet“*.

| Datei, Stelle | stand | jetzt |
|---|---|---|
| `BEFUNDE.md`, [E-117](../BEFUNDE.md#e-117) Rumpf | *„… G1–G4 …); von Gregor noch nicht bestätigt.“* | Halbsatz gestrichen (Kopf sagt bestätigt) |
| `AUFGABEN.md`, Stand-Kopf | *„Stand 13.10.2026 … 1.0.87 in Arbeit … von Gregor noch nicht bestätigt“* | 14.10.2026, Testverzeichnis, bestätigt, nächster Schritt PR und Release |
| `CHANGELOG.md`, *Noch offen* | *„Stand 13.10.2026“*; [E-117](../BEFUNDE.md#e-117) *„nicht ausgeliefert … noch nicht bestätigt“* | 14.10.2026; *„von Gregor am 14.10.2026 an 1.0.87 bestätigt“* |
| `CHANGELOG.md`, Abschnitt 7.2.0.87 | *„in Arbeit, nicht ausgeliefert“* | Testverzeichnis 1.0.87, bestätigt, nicht veröffentlicht |
| `README.md`, Absatz [E-112](../BEFUNDE.md#e-112)/[E-117](../BEFUNDE.md#e-117) | *„von Gregor noch nicht bestätigt“* | *„von Gregor an 1.0.87 bestätigt (14.10.2026)“* |
| `PORTIERUNG.md`, Stand-Kasten | *„Stand 13.10.2026, abends … in Arbeit … noch nicht bestätigt“* | 14.10.2026, Testverzeichnis, bestätigt |
| `ZIEL.md`, Stand (zwei Stellen) | *„13.10.2026“*, *„in Arbeit und nicht ausgeliefert … noch nicht bestätigt“* | 14.10.2026, bestätigt |
| `Testdaten/README.md`, `e117-amp-in-bildadresse.eml` | *„von Gregor noch nicht bestaetigt“* | *„am 14.10.2026 an 1.0.87 bestaetigt“* |
| `WEITERMACHEN.md`, Kopf, *Quellstand*, *Paketnummer* | *„Stand 13.10.2026“*, *„in Arbeit, nicht ausgeliefert“*, *„noch nicht bestätigt“* | 14.10.2026, Testverzeichnis, bestätigt |

### <a id="l-32.2"></a>L-32.2 — WEITERMACHEN-Einstieg: „Gregors Ergebnis abwarten“

Der Nachtrag *„Morgen: Gregors Ergebnis zu 1.0.87 abwarten“* und Punkt 1
*„Gregors eigener Test … steht noch aus“* waren erledigt. Neu oben im Abschnitt
*Der nächste Schritt* ein Block *Stand 14.10.2026*: alle Behebungen des Zweigs
bestätigt, **nächster Schritt PR `e-112-skalierung` → `main`, dann Release nach
Gregors Zustimmung, danach [E-118](../BEFUNDE.md#e-118)**. Der Nachtrag ist
durchgestrichen mit Vermerk, Punkt 1 trägt die Bestätigung.

### <a id="l-32.3"></a>L-32.3 — TESTPLAN C4: E-117 offen

Kopfzeile *„C4 … [E-117](../BEFUNDE.md#e-117) offen, Paket 1.0.87 in Arbeit“*, Überschrift *„offen ist
noch einer“*, Kasten *„1.0.87 … noch nicht hingelegt“*, Zeile [E-117](../BEFUNDE.md#e-117) ☐. Jetzt:
Stand 14.10.2026, C4 erledigt, [E-117](../BEFUNDE.md#e-117) ✅ mit Datum und Beleg.

### <a id="l-32.4"></a>L-32.4 — PAKETE: 1.0.87 „Von Gregor noch nicht getestet“

`Releases/PAKETE.md`: der Stand-Kopf sagte *„1.0.87 in Arbeit, noch nicht als
Paket gebaut“* (das Testverzeichnis lag seit dem 13.10.2026 bei Gregor), der
Abschnitt 1.0.87 endete mit *„Von Gregor noch nicht getestet“*. Jetzt: Kopf
14.10.2026 mit 1.0.85 bis 1.0.87 als Testverzeichnisse, im Abschnitt eine Zeile
*Gregors Test, 14.10.2026* wie bei 1.0.86.

## Nicht geändert

`Befunde/*.md`, `Arbeitsweise/CHRONIST-2026-10-13e.md`, `LEKTORAT.md` (bis auf
den neuen Durchgang) und `tools/TESTLAEUFE.md` sind Protokolle ihres Zeitpunkts.
Die älteren Blöcke in `WEITERMACHEN.md` (*Stand 13.10.2026*) bleiben als
Verlauf unter dem neuen Block stehen.
