# <a id="lektor-113"></a>LEKTOR-113 — Nachlauf vor dem PR nach a9a66afe (01.11.2026)

Sehr kurzer Lauf im Arbeitsbaum `.wt/lektor` (Zweig `wt/lektor-20261101c`,
Stand `a9a66afe`). Geprüft: die vier Funde aus [LEKTOR-112](LEKTOR-112.md),
eingearbeitet in `a9a66afe`, und `da80e5b4` — [AN-1](../Intern/BEFUNDE.md#an-1)
(Anhänge; offen nur noch B5.7: ein Anhang ganz ohne Endung bekommt über
IMAP keine, verloren geht nichts) auf Gregors Entscheidung vom 01.11.2026
von *kritisch* auf *unkritisch*, Stufentabelle neu gesetzt.

Nichts gebaut, nichts gestartet.

## Kurz

Alle vier Funde aus [LEKTOR-112](LEKTOR-112.md#lektor-112) sind **erledigt**
(gemessen am Diff und an den Zeilen). Die Herabstufung von [AN-1](../Intern/BEFUNDE.md#an-1) kommt im
Bestand an: die Stufentabelle stimmt mit `pruefe-regressionstest.pl`
überein (kritisch 70, davon 9 offen; unkritisch 41), nirgends außerhalb
von `Befunde/` und `Arbeitsweise/` steht [AN-1](../Intern/BEFUNDE.md#an-1) noch als kritisch, außer in
einem datierten Prüfbericht. Ein kleiner Fund: `ZIEL.md:68` nennt bei
[E-136](../Intern/BEFUNDE.md#e-136) die Herabstufung, bei [AN-1](../Intern/BEFUNDE.md#an-1) nicht
([L-113.1](#l-113.1)).

## Funde aus LEKTOR-112

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-112.1](LEKTOR-112.md#l-112.1) | WEITERMACHEN nannte zwei Vermutungen von [PRÜFER-70](PRUEFER-70.md) „gemessen“ | **erledigt** | `Intern/WEITERMACHEN.md:40` *„von PRÜFER gemessen: die Lücke bei `szMsg=cbstr;` und die Beschriftung in `pruefe-tests-gruen.pl`; Vermutung: dieselbe Lücke bei `szBody` und die Ausgabe von `RunTests.cmd`“* (gemessen) |
| [L-112.2](LEKTOR-112.md#l-112.2) | BEFUNDE „64 zu behebende“, WERKZEUGE „73“ | **erledigt** | `Intern/BEFUNDE.md:152` *„gezählt waren an dem Tag 73 kritische, und gelesen wurde das als 73 zu behebende, obwohl 11 offen waren“*; stimmt mit `tools/WERKZEUGE.md:174` (gemessen) |
| [L-112.3](LEKTOR-112.md#l-112.3) | Messmarke zu [E-165](../Intern/BEFUNDE.md#e-165) mit fremdem Bau | **erledigt** | `Intern/BEFUNDE.md:398` *„(Gregors Test am Paket, Bau `11643ee1`; davor am Prüfstand an Bau `efcd5945`, Quellstand mit der Behebung)“* (gemessen) |
| [L-112.4](LEKTOR-112.md#l-112.4) | TESTPLAN 21:29, PAKETE 21:31 | **erledigt** | `Intern/TESTPLAN.md:207` *„Bau `11643ee1` um 21:28, ZIP um 21:31“*; stimmt mit `Releases/PAKETE.md:184`, `:190` (gemessen) |

## AN-1 im Bestand

| Stelle | Aussage | Urteil |
|---|---|---|
| `Intern/BEFUNDE.md:272` | *„**Stufe: unkritisch** (herabgestuft von *kritisch* auf Gregors Entscheidung vom 01.11.2026 …)“*; das alte *„Datenschaden: Anhang ohne Endung ist nicht mehr zu oeffnen“* ist fort | stimmt (gemessen am Diff `da80e5b4`) |
| `Intern/BEFUNDE.md:158-162` | kritisch 9 / 58 / 3 / 70, unkritisch 7 / 32 / 2 / 41, zusammen 43 / 164 / 16 / 223 | stimmt mit `perl tools/pruefe-regressionstest.pl` (*„kritisch 70“*, *„unkritisch 41“*) und `offene-befunde.pl` (43 offen) (gemessen) |
| `Intern/BEFUNDE.md:8056` ff. (Abschnitt [AN-1](../Intern/BEFUNDE.md#an-1)) | kein „kritisch“, kein „Datenschaden“ | stimmt (gemessen, `grep -i`) |
| `README.md:188` | Bekannter Fehler, *„nichts – die Datei ist vollständig, nur die Endung fehlt“* | stimmt, nennt keine Stufe |
| `Intern/WEITERMACHEN.md:119` | erzeugte Zeile, nennt keine Stufe | stimmt |
| `Intern/TESTPLAN.md:844` | Testabschnitt C1, nennt keine Stufe | stimmt |
| `ZIEL.md:68` | [AN-1](../Intern/BEFUNDE.md#an-1) *„später (aufschreiben, jetzt nicht)“*, Stand 23.10.2026 | Herabstufung fehlt, siehe [L-113.1](#l-113.1) |
| `Releases/PRUEFBERICHT.md:501` | *„Von **72** kritischen Befunden … Ohne Test: [AN-1](../Intern/BEFUNDE.md#an-1) …“* | datierter Bericht zum Paket 7.2.1.129 (Bau 21:28, `:495-497`); richtig für seinen Zeitpunkt, kein Fund |

Weitere Nennungen (CHANGELOG, AUFGABEN, PAKETE, WERKZEUGE, ZWEIGE,
LEKTORAT, Archiv) nennen keine Stufe (gemessen, `git ls-files '*.md'`
ohne `Befunde/` und `Arbeitsweise/`, `grep -n 'AN-1'`).

## Funde

### <a id="l-113.1"></a>L-113.1 — ZIEL.md nennt die Herabstufung von AN-1 nicht

**Gewicht: Kleinkram.** `ZIEL.md:68` (gemessen)

Für [E-136](../Intern/BEFUNDE.md#e-136) trägt die Zeile *„seit 31.10.2026
auf Gregors Entscheidung *unkritisch*“* nach ([L-111.6](LEKTOR-111.md#l-111.6) Punkt 4). Für
[AN-1](../Intern/BEFUNDE.md#an-1) steht nur die Entscheidung vom 23.10.2026
(*„aufschreiben, jetzt nicht“*). Falsch ist nichts — [AN-1](../Intern/BEFUNDE.md#an-1) steht dort nicht
unter den „sechs kritischen“ —, aber derselbe Fall wird an derselben Stelle
einmal nachgetragen, einmal nicht.

**Vorschlag:** hinter *„[[AN-1](../Intern/BEFUNDE.md#an-1)] später (*„aufschreiben, jetzt nicht"*)“*
ergänzen: *„; seit 01.11.2026 auf Gregors Entscheidung *unkritisch*“*.

## Werkzeuge

`perl tools/doku-pruefen.pl` (Exit 0, gemessen):

```
  Quellstand                   7.2.1.129
  gepruefte Dateien            50
  Kennungen im Verzeichnis     166

  Kein Widerspruch gefunden.
```

„Zur Kenntnis“ wie in [LEKTOR-112](LEKTOR-112.md#lektor-112): Dateien ohne
die Fassung 7.2.1.129 (alte Release-Notizen, `tools/ZWEIGE.md`,
`tools/pruefdaten/LIESMICH.md` u. a.).

`perl tools/offene-befunde.pl` (Exit 0, gemessen):

```
    offen laut Intern/BEFUNDE.md  43
      davon aktuell gemessen       4  (ab Nummer 124)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          13
    in Intern/WEITERMACHEN.md     43

  43 offene Befunde, in beiden Listen gleich.
```

## Was nur Gregor entscheiden kann

Nichts. Die Release-Frage ist beantwortet, die Stufe von [AN-1](../Intern/BEFUNDE.md#an-1) hast du am
01.11.2026 entschieden; [L-113.1](#l-113.1) ist eine Textergänzung.
