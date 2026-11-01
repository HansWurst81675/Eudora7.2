# <a id="lektor-112"></a>LEKTOR-112 — Abschlusslauf nach f959d928 (01.11.2026)

Kurzlauf vor dem PR im Arbeitsbaum `.wt/lektor` (Zweig `wt/lektor-20261101b`,
Stand `f959d928`). Geprüft: die sechs Funde aus [LEKTOR-111](LEKTOR-111.md),
eingearbeitet in `6f762167`; alles an `.md` seit `efbeafb3` ohne `Befunde/`
und `Arbeitsweise/` (`git log -p efbeafb3..HEAD`: `Intern/BEFUNDE.md`,
`Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `ZIEL.md`,
`tools/WERKZEUGE.md`); dazu die neue WEITERMACHEN-Zeile zu
[PRÜFER-70](PRUEFER-70.md) K1/K2.

Nichts gebaut, nichts gestartet. Gelesen wurde nur der Zeitstempel des
ZIP unter `Releases/` im Hauptbaum.

## Kurz

Fünf der sechs Funde aus [LEKTOR-111](LEKTOR-111.md#lektor-111) sind
**erledigt**, [L-111.6](LEKTOR-111.md#l-111.6) (fünf Kleinigkeiten) ist
**teilweise** erledigt. Die Begründung, [L-111.2](LEKTOR-111.md#l-111.2) nicht zu streichen, stimmt:
das Paket 7.2.1.129 ist vor der `.htm`-Behebung gebaut, und die Behebung
steckt nicht darin (gemessen). Die mechanischen Prüfungen sind grün, 43
offene Befunde in beiden Listen.

Vier neue Funde, keiner betrifft das Programm:

* Die neue WEITERMACHEN-Zeile zu PRÜFER-70 nennt zwei Aussagen „gemessen“,
  die PRÜFER-70 selbst als Vermutung kennzeichnet ([L-112.1](#l-112.1)).
* BEFUNDE und WERKZEUGE erzählen weiter mit verschiedenen Zahlen, was
  Gregor aus der alten Stufentabelle gelesen hat: 64 oder 73 zu behebende
  ([L-112.2](#l-112.2), Rest von [L-111.6](LEKTOR-111.md#l-111.6) Punkt 3).
* Die Messmarke zu [E-165](../Intern/BEFUNDE.md#e-165) (Vervollständigungsbox im To:-Feld, geschlossen) nennt jetzt
  7.2.1.129, aber den Bau einer früheren Prüfstandsmessung
  ([L-112.3](#l-112.3)).
* TESTPLAN nennt für das Schnüren von 7.2.1.129 21:29, PAKETE 21:31
  ([L-112.4](#l-112.4)).

## Funde aus LEKTOR-111

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-111.1](LEKTOR-111.md#l-111.1) | Urteil zu [E-165](../Intern/BEFUNDE.md#e-165) hatte eine ungerade Zahl Fettmarken | **erledigt** | `Intern/BEFUNDE.md:398`: 60 Marken `**`, die Folge `keine Box.**` kommt nicht mehr vor (gemessen) |
| [L-111.2](LEKTOR-111.md#l-111.2) | TESTPLAN nannte den zweiten Speicherweg von [E-136](../Intern/BEFUNDE.md#e-136) (Emoji gehen beim Speichern verloren) „noch nicht behoben“ | **erledigt** | `Intern/TESTPLAN.md:205-209` *„ein zweiter Weg, in 7.2.1.129 noch nicht behoben … Für `.htm` ist er im Quellstand seit dem 31.10.2026, 22:12 behoben (nach dem Schnüren von 7.2.1.129 um 21:29) und kommt mit dem nächsten Paket“*. Die Reihenfolge stimmt: Bau `Eudora 7.2.1.129+11643ee1 2026-10-31 21:28` (`Releases/PAKETE.md:190`), ZIP-Zeitstempel `2026-10-31 21:31:25`, `b106664e` (die Behebung) `2026-10-31 22:12:26`; `git merge-base --is-ancestor b106664e 11643ee1` → 1, die Behebung ist **nicht** im Paket (alles gemessen). Nicht streichen war richtig. Die Uhrzeit 21:29 siehe [L-112.4](#l-112.4) |
| [L-111.3](LEKTOR-111.md#l-111.3) | Gregors Release-Frage stand nur in einer Standnotiz | **erledigt** | `Intern/WEITERMACHEN.md:3` *„**Nächstes Release (Gregor 31.10.2026, 22:16/22:17):** … Also: Behebungen sammeln, dann ein Testpaket, die Release-Entscheidung danach“*; Wortlaut stimmt mit `Arbeitsweise/stand-31-10-2026-abend.md:33-34` (gemessen) |
| [L-111.4](LEKTOR-111.md#l-111.4) | Spalte „ohne Urteilswort“ unerklärt | **erledigt** | `Intern/BEFUNDE.md:166` *„„Ohne Urteilswort“ heißt: der fette Kopf des Urteils sagt weder „offen“ noch „behoben“ … oder die Kennung ist eine Unterzeile mit Punkt ([P-2.1](../Intern/BEFUNDE.md#p-2.1) …)“*; der Zusatz zu den Unterzeilen ist durch `tools/offene-befunde.pl:394-396` belegt (*„[P-2.1](../Intern/BEFUNDE.md#p-2.1), [P-2.2](../Intern/BEFUNDE.md#p-2.2), [B-2.2](../Intern/BEFUNDE.md#b-2.2) und [B-2.5](../Intern/BEFUNDE.md#b-2.5) (Unterzeilen, alle werkzeug)“*) (gemessen) |
| [L-111.5](LEKTOR-111.md#l-111.5) | übersprungene Tests zählen als bestanden, nirgends vorgemerkt | **erledigt** | `Intern/WEITERMACHEN.md:41` *„Übersprungene Tests zählen in `TinyTest` als bestanden (`TestOTShimAndocken.cpp:602`, `:609`, `:625`)“* (gemessen) |
| [L-111.6](LEKTOR-111.md#l-111.6) | fünf Kleinigkeiten | **teilweise** | Punkt 1 (Messmarke [E-165](../Intern/BEFUNDE.md#e-165)): erledigt, aber siehe [L-112.3](#l-112.3). Punkt 2 (FAQ 16 an 7.2.1.129): **offen**, bewusst — `CHANGELOG.md:116` weiter *„an 7.2.1.128 bestätigt“*; Commit-Nachricht `6f762167` *„Nicht nachgezogen: FAQ-16-Bestaetigung in CHANGELOG/PAKETE (Kleinigkeit)“*. Punkt 3 (64 oder 73): **teilweise**, siehe [L-112.2](#l-112.2). Punkt 4 (ZIEL.md): erledigt, `ZIEL.md:68` *„seit 31.10.2026 auf Gregors Entscheidung *unkritisch*“*. Punkt 5 (Standzeile): erledigt, `Intern/WEITERMACHEN.md:3` nennt Herabstufung und `.htm`-Weg im Quellstand (alles gemessen) |

## Seit efbeafb3 dazugekommen

| Stelle | Aussage | Urteil |
|---|---|---|
| `Intern/WEITERMACHEN.md:3` | *„Im Quellstand seit dem Schnüren: [[E-136](../Intern/BEFUNDE.md#e-136)] zweiter Speicherweg (`.htm`), Schranken gegen blinde Tests (`TinyTest.cpp`) und gegen Kursiv im Urteilskopf (`tools/fettstellen.pl`), erzeugte Stufentabelle“* | stimmt: `b106664e` (22:12), `10102f8d`, `fettstellen.pl` vom 01.11.2026, `380b07b3` liegen alle nach dem Bau 21:28 (gemessen am Commitverlauf) |
| `Intern/WEITERMACHEN.md:3` | *„[[E-136](../Intern/BEFUNDE.md#e-136)] ist seit der Herabstufung (unkritisch) kein Grund, mit dem Release zu warten“* | belegt durch `Arbeitsweise/stand-31-10-2026-abend.md:35` *„Rueckfrage "Release erst nach [E-136](../Intern/BEFUNDE.md#e-136)?" entfaellt“* |
| `Intern/WEITERMACHEN.md:40` (PRÜFER-70 K1/K2) | `TestE136.cpp:61`, `tools/pruefe-tests-gruen.pl:87`, `RunTests.cmd:22` | Zeilenangaben stimmen: `:61` *„!QT_Enthaelt(pR, "szBody = cbstr;")“*, `:87` *„(TestMain.cpp:127 liefert die Zahl der roten)“*, `Eudora71/Tests/RunTests.cmd:22` *„echo Fehlgeschlagene Tests: %RC%“* (gemessen). Zur Einstufung „gemessen“ siehe [L-112.1](#l-112.1) |
| `Intern/TESTPLAN.md:205-209` | siehe [L-111.2](LEKTOR-111.md#l-111.2) oben | stimmt bis auf die Uhrzeit ([L-112.4](#l-112.4)) |
| `Intern/BEFUNDE.md:166` | siehe [L-111.4](LEKTOR-111.md#l-111.4) oben | stimmt |
| `ZIEL.md:68` | Halbsatz zu [E-136](../Intern/BEFUNDE.md#e-136) unkritisch | stimmt mit `Intern/BEFUNDE.md:425` (Stufe unkritisch) |
| `tools/WERKZEUGE.md:174` | *„gezählt waren am 31.10.2026 73, und Gregor las daraus „73 zu beheben“, wo 11 offen waren“* | stimmt mit `Arbeitsweise/stand-31-10-2026-abend.md:38` (*„kritisch 11/61“*, *„Gregor sah "73 kritische zu beheben"“*); widerspricht `Intern/BEFUNDE.md:152` ([L-112.2](#l-112.2)) |

## Funde

### <a id="l-112.1"></a>L-112.1 — WEITERMACHEN nennt „gemessen“, was PRÜFER-70 Vermutung nennt

**Gewicht: mittel.** `Intern/WEITERMACHEN.md:40` (gemessen)

> *„… `szMsg=cbstr;` ohne Leerzeichen (ebenso `szBody = cbstr;`,
> `TestE136.cpp:61`) bliebe grün … (beides gemessen von PRÜFER, Urteil der
> Tests stimmt)“*

[PRÜFER-70](PRUEFER-70.md#k1) K1 hat nur den `szMsg`-Fall gemessen
(350/350). Zu `szBody` steht dort: *„dass sie bei `szBody=cbstr;` grün
bleibt, ist eine **Vermutung** nach demselben Mechanismus, nicht gemessen“*
(`Befunde/PRUEFER-70.md`, K1, „Warum“). Ebenso in
[K2](PRUEFER-70.md#k2): gemessen ist die Ausgabe von
`pruefe-tests-gruen.pl`; die von `RunTests.cmd` *„habe ich nicht gefahren,
**Vermutung**“*. Die Zeile macht aus zwei Vermutungen Messungen — genau die
Unterscheidung, die der Bestand sonst durchhält. Folgen für das Programm
hat es keine; wer die Aufgabe abarbeitet, sollte den `szBody`-Fall aber
selbst gegenprüfen, statt ihn als belegt zu nehmen.

**Vorschlag:** *„(`szMsg` gemessen von PRÜFER; `szBody` und die Ausgabe
von `RunTests.cmd` nach demselben Mechanismus vermutet)“*.

### <a id="l-112.2"></a>L-112.2 — 64 oder 73: BEFUNDE und WERKZEUGE erzählen denselben Anlass verschieden

**Gewicht: Kleinkram.** `Intern/BEFUNDE.md:152` gegen
`tools/WERKZEUGE.md:174` (gemessen)

`6f762167` hat WERKZEUGE berichtigt, BEFUNDE nicht.

* `Intern/BEFUNDE.md:152`: *„eine Spalte „Zahl am 22.10.2026“ mit 64
  kritischen; … gelesen wurde sie als 64 zu behebende“*
* `tools/WERKZEUGE.md:174`: *„(64 kritische); gezählt waren am 31.10.2026
  73, und Gregor las daraus „73 zu beheben“, wo 11 offen waren“*; ebenso
  `tools/offene-befunde.pl:377-379`.

Die Quelle, `Arbeitsweise/stand-31-10-2026-abend.md:38`, stützt WERKZEUGE:
*„Gregor sah "73 kritische zu beheben"“* (belegt). [L-111.6](LEKTOR-111.md#l-111.6) Punkt 3 ist damit
zur Hälfte erledigt.

**Vorschlag:** in `Intern/BEFUNDE.md:152` *„gelesen wurde sie als 64 zu
behebende“* → *„gezählt waren es am 31.10.2026 73, und gelesen wurden sie
als 73 zu behebende“*.

### <a id="l-112.3"></a>L-112.3 — Messmarke zu E-165 nennt 7.2.1.129 mit einem fremden Bau

**Gewicht: Kleinkram.** `Intern/BEFUNDE.md:398` (gemessen)

> *„**Zuletzt gemessen: 31.10.2026 an 7.2.1.129** (Bau `efcd5945`,
> Quellstand mit der Behebung)“*

Vor `6f762167` stand dort *„an 7.2.1.128“*; geändert wurde nur die Nummer
(gemessen am Diff). `efcd5945` (20:16) ist der Bau der Prüfstandsmessung
in der VM, 7.2.1.129 ist Bau `11643ee1` (`Releases/PAKETE.md:190`). Beide
Messungen sind richtig, die Marke vermengt sie: wer den Bau in Klammern
nachschlägt, findet nicht das Paket, das Gregor getestet hat.
`efcd5945` ist im Paket enthalten (`git merge-base --is-ancestor efcd5945
11643ee1` → 0), es geht also um die Zuordnung, nicht um den Inhalt.

**Vorschlag:** *„an 7.2.1.129 von Gregor (Bau `11643ee1`); Prüfstand am
Bau `efcd5945`, Quellstand mit der Behebung“*.

### <a id="l-112.4"></a>L-112.4 — Uhrzeit des Schnürens: TESTPLAN 21:29, PAKETE 21:31

**Gewicht: Kleinkram.** `Intern/TESTPLAN.md:207` (gemessen)

TESTPLAN: *„nach dem Schnüren von 7.2.1.129 um 21:29“*.
`Releases/PAKETE.md:184`: *„Geschnürt am 31.10.2026 um 21:31“*; der Bau
trägt 21:28 (`:190`), das ZIP hat den Zeitstempel 21:31:25 (gemessen).
21:29 steht in keiner Quelle. An der Aussage ändert das nichts — die
Behebung kam um 22:12, in jedem Fall danach.

**Vorschlag:** *„um 21:29“* → *„um 21:31“* (wie PAKETE).

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

„Zur Kenntnis“: dieselben 19 Dateien ohne die Fassung 7.2.1.129 wie in
[LEKTOR-111](LEKTOR-111.md), darunter `Doku/ANWENDER.md` und
`Intern/PORTIERUNG.md` (höchste genannte Fassung 7.2.1.128). Richtig,
solange 7.2.1.128 die veröffentlichte Fassung ist.

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

Unverändert gegenüber [LEKTOR-111](LEKTOR-111.md#lektor-111); die Stufentabelle steht weiter auf 43 /
164 / 16 / 223 (`Intern/BEFUNDE.md:162`).

## Was nur Gregor entscheiden kann

Nichts Neues. Die Release-Frage hast du am 31.10.2026 beantwortet
(Behebungen sammeln, dann ein Testpaket; `Intern/WEITERMACHEN.md:3`). Alle
vier Funde oben sind Textberichtigungen, die ohne dich erledigt werden
können.
