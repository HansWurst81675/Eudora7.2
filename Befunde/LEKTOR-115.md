# <a id="lektor-115"></a>LEKTOR-115 — Nachlauf vor dem PR nach ebcee8d6, Zweig e178_bearbeiten_emoji (01.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-114](LEKTOR-114.md#lektor-114).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261101e`, Stand `ebcee8d6`.

## Kurz

Alle zehn Funde aus [LEKTOR-114](LEKTOR-114.md#lektor-114) sind eingearbeitet (gemessen). Der neue
Text stimmt mit Quelltext und Ressourcen überein; die Zeilenangaben der
Stichprobe treffen. Beide Werkzeuge grün, 44 offene Befunde in beiden Listen.
Ein Fund, Kleinkram: die Zweigzeile im CHANGELOG nennt `#194` zweimal ([L-115.1](#l-115.1)).

## Funde aus LEKTOR-114

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-114.1](LEKTOR-114.md#l-114.1) CHANGELOG „Im Quellstand“ | erledigt | `CHANGELOG.md:108-115`: Zweig `e178_bearbeiten_emoji`, je ein Punkt zu [E-178](../Intern/BEFUNDE.md#e-178), [E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143), [E-184](../Intern/BEFUNDE.md#e-184) neu |
| [L-114.2](LEKTOR-114.md#l-114.2) Standzeile WEITERMACHEN | erledigt | `Intern/WEITERMACHEN.md:3`: *„Im Quellstand seit dem Schnüren (Zweig `e178_bearbeiten_emoji` …)“* |
| [L-114.3](LEKTOR-114.md#l-114.3) Geltende Entscheidungen | erledigt | `Intern/WEITERMACHEN.md:154-157`, Punkte 21 bis 24 |
| [L-114.4](LEKTOR-114.md#l-114.4) Testschritt zu [E-143](../Intern/BEFUNDE.md#e-143) | erledigt | `Intern/TESTPLAN.md:261-264`: *Special → Make Filter* aus Postfach- und Nachrichtenfenster; Menüeintrag belegt in `Eudora71/Eudora/EudoraRes.rc:5787`, `:5899`, `:5920` (`ID_SPECIAL_MAKE_FILTER`) |
| [L-114.5](LEKTOR-114.md#l-114.5) Logzeile zu [E-170](../Intern/BEFUNDE.md#e-170) | erledigt | `Intern/TESTPLAN.md:243-245`: Bereich *Misc* 0x8000; nachgerechnet: 58527 enthält 0x8000 (58527 − 32768 = 25759), 25759 nicht |
| [L-114.6](LEKTOR-114.md#l-114.6) [E-184](../Intern/BEFUNDE.md#e-184) Aufrufer | erledigt | `Intern/BEFUNDE.md:399` nennt `ImapToc.cpp:2728`, `:3034`; beide Zeilen rufen `ImapTransferSummaryData` |
| [L-114.7](LEKTOR-114.md#l-114.7) verschobene Zeilen | erledigt | `Intern/BEFUNDE.md:404` und `:407`: die alten Werte 2258, 2269, 4665, 8314, 594 kommen nicht mehr vor (`grep -F`); `filtersv.cpp:2259` „goddam“, `summary.cpp:599` `m_Label = NewInfo->m_Label;`; `tools/WERKZEUGE.md:156` `TestMain.cpp:222` = `iFailed = TT_Summary();` |
| [L-114.8](LEKTOR-114.md#l-114.8) PAKETE-Kopf | erledigt | `Releases/PAKETE.md:6`: *„geschnürt ist bis 7.2.1.129“*; „seither nichts Neues“ kommt nicht mehr vor |
| [L-114.9](LEKTOR-114.md#l-114.9) README und FAQ | erledigt | `README.md:165`, `:169`; `Doku/FAQ.md:202-203`, `:208-209` |
| [L-114.10](LEKTOR-114.md#l-114.10) ZWEIGE | erledigt | `tools/ZWEIGE.md:202` nennt [E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143), [E-184](../Intern/BEFUNDE.md#e-184); der zweite Punkt ([E-179](../Intern/BEFUNDE.md#e-179) „nie gemessen“) war zur Kenntnis |

## Der neue Text aus ebcee8d6

Gelesen: alle hinzugefügten Zeilen von `git show ebcee8d6 -- '*.md'`. Kein
Widerspruch zu BEFUNDE, TESTPLAN oder den Entscheidungen gefunden. Überall
„im Quellstand, am Programm nicht gemessen“ bzw. „berichtigt“, nirgends
„behoben“ für die vier Behebungen (belegt, Lesung). Stichprobe der
Zeilenangaben: `ImapToc.cpp:1538` (`CTocDoc::ImapTransferSummaryData`), `:2728`,
`:3034`, `summary.cpp:599`, `filtersv.cpp:2259`, `:2270` (`TrackPopupMenu`),
`TestMain.cpp:222` — alle treffen (gemessen, `sed -n`).

## Funde

### <a id="l-115.1"></a>L-115.1 — CHANGELOG-Zweigzeile nennt #194 zweimal

**Gewicht: Kleinkram.** (gemessen)

`CHANGELOG.md:108`: *„(nach dem Merge von #194; davor `e165_schliessen_e136_speichern_unter`, gemergt als #194)“*.
Beide Hälften sagen dasselbe; gemeint ist wohl „abgezweigt nach dem Merge
von #194 (`e165_schliessen_e136_speichern_unter`)“. Falsch ist nichts, die
Zeile liest sich nur wie ein Widerspruch.

**Vorschlag:** zu *„(abgezweigt nach dem Merge von #194, Zweig `e165_schliessen_e136_speichern_unter`)“* kürzen.

## Werkzeuge

`perl tools/doku-pruefen.pl`:

```
  Quellstand                   7.2.1.129
  Paketnummer                  7.2.1.129
  gepruefte Dateien            50
  Kein Widerspruch gefunden.
```

(darunter „Zur Kenntnis“: ältere Release-Notizen und `tools/ZWEIGE.md` nennen 7.2.1.129 nicht — wie bisher, kein Fund.)

`perl tools/offene-befunde.pl`:

```
      davon veraltet gemessen     26
      davon NIE gemessen          14
    in Intern/WEITERMACHEN.md     44

  44 offene Befunde, in beiden Listen gleich.
```

## Was nur Gregor entscheiden kann

Nichts Neues. Ob jetzt das Testpaket 7.2.1.130 kommt, ist ihm schon gestellt.
