# <a id="lektor-110"></a>LEKTOR-110 — Abschlusslauf nach dem Schnüren von 7.2.1.129 (31.10.2026)

Kurzer Lauf vor dem Pull Request, kein Vollbestand. Geprüft: die beiden
Funde aus [LEKTOR-109](LEKTOR-109.md) und alles seit `f7f1ebc6` bis
`1026f407`: Paket 7.2.1.129 geschnürt und bei Gregor bereitgestellt
(`13b1396a`), Gregors Ergebnisse, [PRÜFER-68](PRUEFER-68.md) eingearbeitet,
Testkorrektur `TT_EndTest` (`c458c74d`), Bestätigung zu
[E-165](../Intern/BEFUNDE.md#e-165) (`1026f407`).

## Kurz

Beide Funde aus [LEKTOR-109](LEKTOR-109.md#lektor-109) sind **erledigt**.
Nirgends steht, 7.2.1.129 sei veröffentlicht, und nirgends, der Emoji-Verlust
beim Speichern ([E-136](../Intern/BEFUNDE.md#e-136)) oder die verbaute
Vervollständigungsbox ([E-165](../Intern/BEFUNDE.md#e-165)) sei behoben.
Drei neue Funde: das Urteil zu [E-136](../Intern/BEFUNDE.md#e-136) sagt zugleich „in 7.2.1.129“ und „in
keinem Paket“ ([L-110.1](#l-110.1)); [E-165](../Intern/BEFUNDE.md#e-165) ist aus der Liste offener Befunde
in WEITERMACHEN verschwunden, obwohl er offen ist, und `offene-befunde.pl`
endet mit Exit 1 ([L-110.2](#l-110.2)); PAKETE nennt Gregors
E-165-Ergebnis nicht ([L-110.3](#l-110.3)).

Eingearbeitet vor dem Commit dieses Berichts in 2e795e79.

## Funde aus LEKTOR-109

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-109.1](LEKTOR-109.md#l-109.1) | MITARBEITEN: zwei verschiedene Beispielnummern unter „beide gleich“ | **erledigt** | `Doku/MITARBEITEN.md:62` *„**Quellstand**, z. B. `7.2.1.129`“*, `:63` *„**Paketnummer**, z. B. `7.2.1.129`“* — beide gleich (gemessen; geändert in `13b1396a`) |
| [L-109.2](LEKTOR-109.md#l-109.2) | CHANGELOG-Abschnitt 7.2.1.129 sagte nicht, dass das Paket noch nicht geschnürt war | **erledigt** (durch den Fortgang) | `CHANGELOG.md:107` *„**Geschnürt am 31.10.2026, bereitgestellt in `C:\Users\Gregor\Eudora72-7.2.1.129-release`, nicht veröffentlicht** ([PAKETE](Releases/PAKETE.md))“* (gemessen) |

## Neu seit f7f1ebc6 — Abgleich der Aussagen

| Stelle | Aussage | Urteil |
|---|---|---|
| `Releases/PAKETE.md:184` | *„**Geschnürt am 31.10.2026 um 21:31, bereitgestellt in `C:\Users\Gregor\Eudora72-7.2.1.129-release`; nicht veröffentlicht**“* | stimmt mit `CHANGELOG.md:107` (gemessen) |
| `Releases/PAKETE.md:189` | ZIP *„nicht im Repo (`.gitignore`), nicht auf GitHub“* | stimmt (gemessen) |
| `Intern/TESTPLAN.md:1` | *„geschnürt am 31.10.2026, liegt in `C:\Users\Gregor\Eudora72-7.2.1.129-release`“* | stimmt (gemessen) |
| `Intern/WEITERMACHEN.md:3` | *„Testpaket **7.2.1.129** geschnürt und bei Gregor im Test … Zuletzt veröffentlicht: **`v7.2.1.128`**“* | stimmt (gemessen) |
| `README.md:167`, `Doku/FAQ.md:333` | [E-171](../Intern/BEFUNDE.md#e-171) (Suche ohne Markierung): *„behoben in 7.2.1.129 (Testpaket)“* bzw. *„behoben ab 7.2.1.129“* | stimmt mit `Intern/BEFUNDE.md:389` *„behoben in 7.2.1.129 … Gregors Test steht aus“* (gemessen) |
| `README.md:182` | [E-136](../Intern/BEFUNDE.md#e-136): *„in 7.2.1.129 geändert (am Programm noch nicht nachgemessen)“* | stimmt; kein „behoben“ (gemessen) |
| `README.md:186` | [E-165](../Intern/BEFUNDE.md#e-165): *„in 7.2.1.129 geändert (mit zwei Treffern gemessen)“* | stimmt; Gregors Bestätigung steht dort nicht, eine Überbehauptung ist es nicht (gemessen) |
| `CHANGELOG.md:105` | *„## 7.2.1.129 — Testpaket: [E-139](../Intern/BEFUNDE.md#e-139), [E-140](../Intern/BEFUNDE.md#e-140), [E-171](../Intern/BEFUNDE.md#e-171) behoben; [E-136](../Intern/BEFUNDE.md#e-136) und [E-165](../Intern/BEFUNDE.md#e-165) zum Nachmessen“* | stimmt (gemessen) |
| `Intern/TESTPLAN.md:149` | Rechtschreibhinweis [E-139](../Intern/BEFUNDE.md#e-139): *„**Ergebnis 31.10.2026, Gregor an 7.2.1.129: bestanden**“* | stimmt mit `Releases/PAKETE.md:194` (gemessen) |
| `Intern/TESTPLAN.md:185` | [E-165](../Intern/BEFUNDE.md#e-165): *„mit zwei und drei Treffern: besser … Offen: der Fall mit **einem** Treffer“* | stimmt mit `Intern/BEFUNDE.md:382` (gemessen); fehlt in PAKETE, siehe [L-110.3](#l-110.3) |
| `Intern/TESTPLAN.md:204-207` | *„File → Save As aus dem Nachrichtenfenster … macht aus Emoji in 7.2.1.129 weiter `??` — ein zweiter Weg, noch nicht behoben ([PRÜFER-68](../Befunde/PRUEFER-68.md) K1“* | stimmt mit dem Rest von Prüferfund K1 im E-136-Urteil (gemessen) |
| `Intern/BEFUNDE.md:383-384` | [E-179](../Intern/BEFUNDE.md#e-179) (HTML-zu-Text verliert Zeichen) und [E-178](../Intern/BEFUNDE.md#e-178) (Bearbeiten-Modus verliert Emoji) neu: *„offen, am Quelltext belegt (… K3) / (… K2), nie gemessen“* | stimmt; beide in WEITERMACHEN und CHANGELOG gelistet (gemessen) |
| `Releases/PRUEFBERICHT.md:5-8` | *„`7.2.1.129` (Paketnummer `7.2.1.129`)“*, Commit *„`c458c74d` — **Arbeitsbaum nicht sauber** (1 Dateien)“*, Gesamturteil *„**BESTANDEN**“* | stimmt mit `Releases/PAKETE.md:191`, das den Unterschied zwischen Bau `11643ee1` und Bericht `c458c74d` erklärt (*„nur Testdateien“*) (gemessen) |

**Überbehauptung gesucht (gemessen):** `grep -rln` nach „7.2.1.129“ mit
„veröffentlicht“ bis 40 Zeichen dahinter trifft nur `CHANGELOG.md` und
`Releases/PAKETE.md`, beide mit *„nicht veröffentlicht“*. Die Suche nach
„[E-136](../Intern/BEFUNDE.md#e-136)“ oder „[E-165](../Intern/BEFUNDE.md#e-165)“ mit „behoben“ bis 30 Zeichen dahinter über README,
CHANGELOG, `Doku/`, WEITERMACHEN, TESTPLAN und ZIEL: kein Treffer.

## Funde

### <a id="l-110.1"></a>L-110.1 — Urteil zu E-136: „in 7.2.1.129“ und „in keinem Paket“ in einem Satz

**Gewicht: mittel.** `Intern/BEFUNDE.md:409`

> *„**offen — Behebung im Quellstand (31.10.2026), am Quelltext und am
> Funktionstest belegt, am laufenden Programm NICHT nachgestellt; in
> 7.2.1.129 (nur der Weg *Strg-S*); in keinem Paket.**“*

Seit `13b1396a` ist 7.2.1.129 ein geschnürtes Paket
(`Releases/PAKETE.md:184`). Die Wendung „in keinem Paket“ stammt aus
`cb477bbf`, als es noch nicht geschnürt war; „in 7.2.1.129“ kam in
`13b1396a` dazu, „in keinem Paket“ blieb stehen (gemessen:
`git log -S"in keinem Paket" -- Intern/BEFUNDE.md` nennt beide Commits).
Wer das Urteil liest, erfährt nicht, ob Gregor die Behebung in der Hand hat.
Gemeint ist wohl „in keinem veröffentlichten Paket“ (Vermutung).

**Vorschlag:** *„… in 7.2.1.129 (Testpaket, nur der Weg Strg-S), in keinem
veröffentlichten Paket.“*

### <a id="l-110.2"></a>L-110.2 — E-165 fehlt in der Liste offener Befunde in WEITERMACHEN; offene-befunde.pl endet mit Exit 1

**Gewicht: mittel.** `Intern/WEITERMACHEN.md:73-120`

`1026f407` hat aus dem erzeugten Block in WEITERMACHEN die Zeile
*„| **[E-165](BEFUNDE.md#e-165)** | Die Vervollständigungsbox im To:-Feld …“*
**entfernt**, ohne Ersatz (gemessen: im Diff nur eine `-`-Zeile).
`Intern/BEFUNDE.md:382` beginnt aber mit *„**offen — Behebung im
Quellstand …**“* und sagt *„Offen bleibt nur der Fall mit EINEM
Treffer.“*; `CHANGELOG.md:38` führt die Zeile weiter (gemessen: Vergleich
der Kennungen beider Blöcke, Unterschied nur [E-165](../Intern/BEFUNDE.md#e-165)).

`perl tools/offene-befunde.pl` meldet *„offene-befunde: der Abschnitt in
./CHANGELOG.md ist nicht auf dem Stand.“* und endet mit **Exit 1**
(gemessen, Ausgabe unten). Beide Blöcke werden laut `CHANGELOG.md:17`
erzeugt; die Hand-Änderung widerspricht dem.

**Vorschlag:** die Zeile nicht von Hand löschen, sondern beide Blöcke mit
`tools/offene-befunde.pl` aus BEFUNDE neu erzeugen; die Spalte „zuletzt
gemessen“ für [E-165](../Intern/BEFUNDE.md#e-165) sollte dann 7.2.1.129 nennen statt *„31.10.2026 an
7.2.1.128“*. Ob das Werkzeug [E-165](../Intern/BEFUNDE.md#e-165) dabei wieder in WEITERMACHEN aufnimmt,
ist nicht geprüft (Vermutung: ja, weil das Urteil mit „offen“ beginnt,
`tools/offene-befunde.pl:165`).

### <a id="l-110.3"></a>L-110.3 — PAKETE nennt Gregors E-165-Ergebnis nicht

**Gewicht: Kleinkram.** `Releases/PAKETE.md:194`

> *„| Von Gregor getestet | **[E-139](../Intern/BEFUNDE.md#e-139) bestanden** … Antworten und Weiterleiten
> mit Original-HTML ([E-88](../Intern/BEFUNDE.md#e-88)) kamen richtig an …
> Übrige Schritte stehen aus |“*

`1026f407` hat das Ergebnis zu [E-165](../Intern/BEFUNDE.md#e-165) in TESTPLAN (`Intern/TESTPLAN.md:185`)
und BEFUNDE (`:382`) eingetragen, PAKETE nicht berührt (gemessen an
`git log --stat`).

**Vorschlag:** in die Zeile aufnehmen: *„[E-165](../Intern/BEFUNDE.md#e-165) mit zwei und drei Treffern
besser (‚sieht besser aus e-165‘), der Fall mit einem Treffer offen“*.

## Werkzeuge

`perl tools/doku-pruefen.pl` (Exit 0, gemessen):

```
  Quellstand                   7.2.1.129
  Paketnummer                  7.2.1.129
  Kriterien in ZIEL.md         9
  gepruefte Dateien            50
  Kennungen im Verzeichnis     166
  Abschnitte in Intern/BEFUNDE.md 14
  ------------------------------------------------------------
  Kein Widerspruch gefunden.
```

„Zur Kenntnis“ nennt 20 Dateien ohne die Fassung 7.2.1.129, darunter
`ZIEL.md`, `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` (höchste genannte
Fassung jeweils 7.2.1.128). `README.md` und `Doku/FAQ.md` stehen nicht mehr
darin (in [LEKTOR-109](LEKTOR-109.md) noch ja) — sie nennen 7.2.1.129 jetzt
(gemessen).

`perl tools/offene-befunde.pl` (Exit 1, gemessen):

```
    offen laut Intern/BEFUNDE.md  42
      davon aktuell gemessen       4  (ab Nummer 124)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     25
      davon NIE gemessen          13
    in Intern/WEITERMACHEN.md     42
  offene-befunde: der Abschnitt in ./CHANGELOG.md ist nicht auf dem Stand.
```

Gegenüber [LEKTOR-109](LEKTOR-109.md): „NIE gemessen“ 11 → 13 ([E-178](../Intern/BEFUNDE.md#e-178),
[E-179](../Intern/BEFUNDE.md#e-179) neu), „aktuell gemessen“ 5 → 4, „veraltet“ 26 → 25 (gemessen). Dass
WEITERMACHEN trotz fehlender E-165-Zeile 42 zählt, ist nicht geklärt; das
Werkzeug zählt dort offenbar nicht die Zeilen des Blocks (Vermutung), siehe
[L-110.2](#l-110.2).

## Was nur Gregor entscheiden kann

Nichts Neues.
