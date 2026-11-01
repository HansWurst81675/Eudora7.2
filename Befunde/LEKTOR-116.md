# <a id="lektor-116"></a>LEKTOR-116 — Kurzlauf vor dem Testpaket 7.2.1.130, Zweig paket_7_2_1_130 (01.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-115](LEKTOR-115.md#lektor-115).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261101f`, Stand `955d50d4`.

## Kurz

Der Fund aus [LEKTOR-115](LEKTOR-115.md#lektor-115) ist erledigt (gemessen). Die Nummer 7.2.1.130 ist in
CHANGELOG, TESTPLAN, PAKETE, README, ZIEL, WEITERMACHEN-Kopf, AUFGABEN,
MITARBEITEN, DEFENDER-FEHLALARM, WERKZEUGE und ZWEIGE einheitlich angekommen;
nirgends steht, 7.2.1.130 sei geschnürt oder getestet. Alle vier Werkzeuge
grün, 44 offene Befunde in beiden Listen. Drei Funde, keiner am Programm: die
Urteile in BEFUNDE zu [E-178](../Intern/BEFUNDE.md#e-178), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143) sagen weiter „mit dem nächsten
Testpaket“, und das schlägt in die erzeugten Listen von CHANGELOG und
WEITERMACHEN durch ([L-116.1](#l-116.1)); README und BEFUNDE nennen bei [E-136](../Intern/BEFUNDE.md#e-136) nur 7.2.1.129, den
`.htm`-Weg in 7.2.1.130 nicht ([L-116.2](#l-116.2)); die FAQ sagt zu [E-170](../Intern/BEFUNDE.md#e-170) „kommt mit dem
nächsten Paket“ ([L-116.3](#l-116.3)).

## Funde aus LEKTOR-115

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-115.1](LEKTOR-115.md#l-115.1) CHANGELOG-Zweigzeile nennt #194 zweimal | erledigt | `CHANGELOG.md:108`: *„Zweige `e165_schliessen_e136_speichern_unter` (#194), `e178_bearbeiten_emoji` (#195) und `paket_7_2_1_130`“* |

## Bestand seit 8713f012

Gelesen: `git log --stat 8713f012..HEAD` (Merge #195, `7d9cca14`, `955d50d4`)
und alle geänderten Zeilen von `git show 7d9cca14 -- '*.md'`. Danach über alle
`git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/` gesucht nach
„noch in keinem Paket“, „nächste(n/m) (Test)paket“, „nicht mit 7.2.1.129“,
„seit dem Schnüren“ (gemessen, `grep -nE`). Treffer, die ältere Befunde oder
datierte Abschnitte betreffen (z. B. `CHANGELOG.md:148` im Abschnitt 7.2.1.129,
`Intern/BEFUNDE.md:331`, `:336`), sind Geschichte und kein Fund.

Stimmt (belegt, Lesung): `Releases/PAKETE.md:6` *„vergeben ist 7.2.1.130“* und
der neue Abschnitt *„Nur übersetzt am 01.11.2026, noch nicht geschnürt“* (laut
Auftrag kein Fund); `Intern/TESTPLAN.md:213`, `:235`, `:252` *„Mit dem Paket
7.2.1.130 auszuführen“*; `Intern/TESTPLAN.md:206-208` zum `.htm`-Weg von
[E-136](../Intern/BEFUNDE.md#e-136) (Emoji beim Speichern zu `??`); `README.md:185` zu [E-143](../Intern/BEFUNDE.md#e-143) (Out im Filter)
*„In 7.2.1.130 für Filter geändert“*; `Intern/WEITERMACHEN.md:3`;
`Intern/AUFGABEN.md:8`; `tools/ZWEIGE.md:203`.

## Funde

### <a id="l-116.1"></a>L-116.1 — Urteile zu E-178, E-170, E-143 sagen „mit dem nächsten Testpaket“

**Gewicht: mittel** — die Stelle ist die Quelle zweier erzeugter Listen. (gemessen)

`Intern/BEFUNDE.md:401` ([E-178](../Intern/BEFUNDE.md#e-178), Fett/Link im Bearbeiten-Modus machen Emoji zu `??`), `:407` ([E-170](../Intern/BEFUNDE.md#e-170), Label geht beim
Verschieben im IMAP-Konto verloren) und `:395` ([E-143](../Intern/BEFUNDE.md#e-143), Out-Hinweis je Nachricht aus
Filtern): *„**Was noch fehlt:** die Messung am Programm mit dem nächsten
Testpaket“*. Dieselben Worte stehen, aus BEFUNDE erzeugt, in
`CHANGELOG.md:32`, `:37`, `:43` und `Intern/WEITERMACHEN.md:81`, `:86`, `:92`.
Die Spalte „Urteil“ sagt bei allen dreien und bei [E-179](../Intern/BEFUNDE.md#e-179) (`:400`, Emoji in der
Textfassung zu `%`) nur *„Behebung im Quellstand (01.11.2026, Zweig
`e178_bearbeiten_emoji`)“*, 7.2.1.130 fehlt.

**Vorschlag:** in BEFUNDE „mit dem nächsten Testpaket“ durch „mit 7.2.1.130“
ersetzen und im Urteil „in 7.2.1.130“ ergänzen, danach die Listen neu erzeugen
(`perl tools/offene-befunde.pl`). Die Anker `e-178-naechstes` usw. können bleiben.

### <a id="l-116.2"></a>L-116.2 — E-136: README und BEFUNDE nennen den `.htm`-Weg in 7.2.1.130 nicht

**Gewicht: Kleinkram.** (gemessen)

`README.md:182`: *„in 7.2.1.129 geändert (am Programm noch nicht nachgemessen)“*.
`Intern/BEFUNDE.md:426`: *„in 7.2.1.129 (nur der Weg Strg-S); dort noch nicht
nachgemessen“* — die Zeile nennt 7.2.1.130 nicht (`grep` ohne Treffer). Der
CHANGELOG-Abschnitt 7.2.1.130 (`CHANGELOG.md:119`) und `Intern/TESTPLAN.md:207`
führen den `.htm`-Weg aber als Inhalt von 7.2.1.130.

**Vorschlag:** README „in 7.2.1.129 geändert, *Speichern unter* als `.htm` in
7.2.1.130“; im Urteil zu [E-136](../Intern/BEFUNDE.md#e-136) „`.htm`-Weg in 7.2.1.130“ ergänzen.

### <a id="l-116.3"></a>L-116.3 — FAQ: E-170 „kommt mit dem nächsten Paket“

**Gewicht: Kleinkram.** (gemessen)

`Doku/FAQ.md:208-209`: *„im Quellstand berichtigt für Server, die die neuen
Nummern der verschobenen Mails melden — kommt mit dem nächsten Paket“*. Die
README sagt an derselben Stelle schon „in 7.2.1.130 berichtigt“.

**Vorschlag:** „— in 7.2.1.130 berichtigt, am Programm nicht gemessen“.

Zur Kenntnis, kein Fund: `README.md:155` ([E-72](../Intern/BEFUNDE.md#e-72), verneinte Filterbedingung trifft
jede Nachricht) rät *„solche Filter bis zum nächsten Paket abschalten“*;
behoben ist es seit 7.2.1.129, das nur ein Testpaket ist. Für Leser des
Releases 7.2.1.128 stimmt „nächstes Paket“ sinngemäß noch (Vermutung zur Absicht).

## Werkzeuge

`perl tools/doku-pruefen.pl`:

```
  Quellstand                   7.2.1.130
  Paketnummer                  7.2.1.130
  gepruefte Dateien            50
  Kein Widerspruch gefunden.
```

(„Zur Kenntnis“: ältere Release-Notizen nennen 7.2.1.130 nicht — wie bisher.)

`perl tools/offene-befunde.pl`:

```
    offen laut Intern/BEFUNDE.md  44
      davon veraltet gemessen     28
      davon NIE gemessen          14
    in Intern/WEITERMACHEN.md     44

  44 offene Befunde, in beiden Listen gleich.
```

`perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne Regressionstest.“* (Rückstand unverändert 8 ohne Prüfung).

`perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

Die Werkzeuge sehen [L-116.1](#l-116.1) bis [L-116.3](#l-116.3) nicht: `doku-pruefen.pl` vergleicht Nummern, nicht „nächstes Paket“.

## Was nur Gregor entscheiden kann

Nichts Neues.
