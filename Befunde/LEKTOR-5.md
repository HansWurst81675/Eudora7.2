# LEKTOR-5 — alle 50 MD gegen den Stand vom 08.09.2026 gemessen

**Agent:** LEKTOR · **Kennung:** `L-9` · **Datum:** 08.09.2026 ·
**Arbeitsbaum:** `C:\Users\Gregor\Documents\github\Eudora7.2-wt-lektor` ·
**Zweig:** `pruefer-4-einarbeiten` ·
**Bezugscommit:** `d003d46` (per `git merge --ff-only origin/pruefer-4-einarbeiten`)

**Nicht gebaut, Eudora nicht gestartet, keine Zeile Quelltext geändert.** Diese
Datei ist die einzige Änderung. Jede Aussage ist am Baum gemessen; der
Messbefehl steht dabei. Bytes wurden im Rohmodus gelesen
(`open($f,"<:raw",...)`), nicht mit `grep -c`.

## Der Anlass

Gregor am 08.09.2026, wörtlich:

> *„lass' mal wieder den lektor los: .../pruefer-4-einarbeiten/AUFGABEN.md ist
> veraltet. er soll pruefen, ob andere MDs auch"*

## Der Maßstab

`ZIEL.md` im Bezugscommit. Gemessen:

```
cat VERSION                                  # 1.0.22
grep EUDORA_BUILD_VERSION Eudora71/Version.h # "7.2.0.22"
ls Releases/*.zip                            # 1.0.2-lauffaehig, 1.0.21-release, 1.0.22-release
git ls-files "*.md" | grep -vc '^Arbeitsweise/'   # 50
```

| Was gilt | Stelle |
|---|---|
| Quellstand **7.2.0.22**, Paketnummer **1.0.22** | `VERSION`, `Eudora71/Version.h:14`, `ZIEL.md:17` |
| **Kriterium 7 ist ERFÜLLT** — *„schließen klappt jetzt."*, alle drei Wege | `ZIEL.md:36` |
| Behoben durch **E-40**, **E-41**, **E-42** | `ZIEL.md:36`; im Quelltext `doc.cpp:73`, `msgdoc.cpp:1057`, `mainfrm.cpp:5462`, `mainfrm.cpp:5079` |
| **E-43** ist der Rest: `SaveBarState` wirft weiter, E-42 fängt es nur ab | `ZIEL.md:36` |
| Bilanz: **sechs von neun belegt (0, 1, 3, 5, 6, 7)**, zwei fast/halb (2, 4), eines nicht (8) | `ZIEL.md:39-40` |
| **A-1 ist am laufenden Programm belegt** | `ZIEL.md:159-161` |
| **A-2 ist neu und nicht angefangen** | `ZIEL.md:175-195` |
| **E-37 ist NICHT behoben** — der erste Anlauf hat es schlimmer gemacht, der zweite ist unbestätigt | Gregors Messung vom 08.09.2026 |
| Neuer Befund: Erscheinungsbild nach dem **ersten Anlegen eines Kontos** falsch (Wazoo-Bereiche als senkrechte Spalten links) | noch nirgends aufgeschrieben |

## Ergebnis in Zahlen

| | |
|---|---|
| geprüfte Dateien | **50** (`git ls-files "*.md"` ohne `Arbeitsweise/`) |
| Dateien mit Widerspruch | **10** |
| Fundstellen | **41** |
| davon schwer | **28** in 6 Dateien |
| Dateien, die mit `ZIEL.md` übereinstimmen | `PORTIERUNG.md` — als einzige der sechs Statusdateien |

## Tabelle aller geprüften Dateien

| Datei | Widerspruch? | Schwere |
|---|---|---|
| `ABRUF-PRUEFEN.md` | nein | — |
| `AGENTEN.md` | nein | — |
| `AUFGABEN.md` | **ja** — 9 Stellen (L-9.1, L-9.3, L-9.6, L-9.8, L-9.14) | **schwer** |
| `BEFUNDE-ALTBESTAND.md` | nein | — |
| `BEFUNDE.md` | **ja** — E-37-Zeile falsch, E-40…E-43 fehlen ganz, A-1 doppelt vergeben (L-9.2, L-9.3, L-9.8) | **schwer** |
| `Befunde/ASSISTENT.md` | nein (Zeitdokument, datiert) | — |
| `Befunde/BEENDEN.md` | ja — kein Nachtrag zum Abschluss (L-9.12) | mittel |
| `Befunde/FENSTER.md` | nein (Zeitdokument mit Nachtrag) | — |
| `Befunde/LEKTOR-2.md` | nein | — |
| `Befunde/LEKTOR-3.md` | nein | — |
| `Befunde/LEKTOR-4.md` | ja — 18 Verweise ins Leere (L-9.11) | mittel |
| `Befunde/LEKTOR.md` | nein | — |
| `Befunde/OEFFNEN.md` | nein | — |
| `Befunde/PAIGE.md` | nein | — |
| `Befunde/PAKET.md` | nein (kein H1, aber Kopfzeile mit Agent/Datum/Status) | leicht |
| `Befunde/PERSONA.md` | nein (kein H1, s.o.) | leicht |
| `Befunde/PORT.md` | nein (kein H1, s.o.) | leicht |
| `Befunde/POSTFACH.md` | nein (kein H1, s.o.) | leicht |
| `Befunde/PRUEFER-3.md` | nein | — |
| `Befunde/PRUEFER-4.md` | ja — sein E-37-Urteil ist am laufenden Programm widerlegt, ohne Nachtrag (L-9.13) | leicht |
| `Befunde/SPUR.md` | nein (kein H1, s.o.) | leicht |
| `Befunde/SYMBOLE-VORARBEIT.md` | nein | — |
| `Befunde/SYMBOLE.md` | nein | — |
| `Befunde/VERFASSEN.md` | nein | — |
| `Befunde/VERFASSER.md` | nein (Zeitdokument mit Nachtrag) | — |
| `CHANGELOG.md` | **ja** — 8 Stellen, darunter die Prüfanleitung zu 1.0.22 (L-9.1, L-9.3, L-9.4, L-9.9) | **schwer** |
| `Eudora71/OTShim/BEFUND-ANSICHT.md` | nein — enthält aber die Vorarbeit zu A-2, unverlinkt (L-9.7) | leicht |
| `Eudora71/OTShim/BEFUND-MENUE.md` | nein | — |
| `Eudora71/OTShim/INVENTAR.md` | nein | — |
| `Eudora71/OTShim/PLAN.md` | nein | — |
| `Eudora71/OpenSSL3/BAUEN.md` | nein | — |
| `Eudora71/Tests/QCSSL/README.md` | nein | — |
| `Eudora71/VC71Bruecke/BEFUND.md` | nein | — |
| `LEKTORAT.md` | nein — sagt in Zeile 3 selbst, dass es ein Fahrtenbuch ist | — |
| `PORTIERUNG.md` | **nein** — `:38-40` stimmt Wort für Wort mit `ZIEL.md:39-40` | — |
| `PRUEFBERICHT.md` | nein | — |
| `PRUEFUNG-BAU.md` | nein — `:94` nennt 7.2.0.21 in einem **datierten** Rückblick, das ist richtig | — |
| `PRUEFUNG-BRANCH.md` | nein | — |
| `PRUEFUNG-CODE.md` | nein — die ZIP-Namen stehen alle in datierten Messungen | — |
| `Pruefung/PRUEFUNG-KETTE.md` | nein | — |
| `Pruefung/PRUEFUNG-PAKET.md` | nein | — |
| `Pruefung/PRUEFUNG-ZEIGER.md` | ja — nur Zeilenenden: **193 CR**, die einzige MD mit CRLF (L-9.15) | leicht |
| `README.md` | **ja** — 6 Stellen (L-9.1, L-9.3, L-9.4, L-9.10) | **schwer** |
| `Releases/1.0/AUSLIEFERUNGEN.md` | nein | — |
| `Releases/1.0/README.md` | nein | — |
| `Releases/PAKETE.md` | **ja** — 4 Stellen, 1.0.22 kommt nicht vor (L-9.5) | **schwer** |
| `STARTUMGEBUNG.md` | nein — sagt in `:6` selbst, dass es überholt ist | — |
| `WEITERMACHEN.md` | **ja** — 8 Stellen (L-9.1, L-9.4, L-9.6, L-9.16) | **schwer** |
| `ZIEL.md` | nein — der Maßstab | — |
| `tools/patches/zertifikatspruefung-verschaerfen.md` | nein | — |

---

# Die Widersprüche im Einzelnen

## L-9.1 — Kriterium 7 wird in vier Statusdateien als **nicht erfüllt** geführt (schwer)

Das ist der schwerste Befund: die vier Dateien, die einem Einsteiger sagen, wo
er steht, nennen den einen Fehler, der seit dem 08.09.2026 **weg** ist, als den
einzigen verbliebenen.

**`README.md:44-46`**

> *„**Fertig ist es nicht.** Was ein Anwender jetzt noch merkt, sind zwei Dinge:
> *File → Exit* beendet Eudora nicht (*„beenden geht nicht"* — Kriterium 7), und
> die untere Statuszeile mit den Reitern für offene Fenster fehlt"*

**`README.md:69-75`** führt denselben Punkt als ersten Aufzählungspunkt unter
*Offen*, mit der Ursachenanalyse zu E-33.

**`WEITERMACHEN.md:34`**

> `| 7 | ***File → Exit*** beendet Eudora sauber | **nicht erfüllt** — *„beenden geht nicht."* |`

**`WEITERMACHEN.md:69-113`** — der ganze Abschnitt *Der nächste Schritt* ist das
Beenden: *„Das ist der einzige verbliebene **Fehler**; alles Weitere ist
Ausstattung."* (`:77-78`), samt Verdacht auf `QCCustomToolBar::SaveCustomInfo`
und der Anleitung *„ein Paket aus diesem Stand bauen … und die letzte
`E-33`-Zeile in `eudora.log` lesen"* (`:101-107`).

**`CHANGELOG.md:17`** führt E-33 unter *Noch offen*; **`:33`**

> `| **Kriterium 7** (Beenden) | **nicht erfüllt** — der einzige verbliebene Fehler der zweiten Stufe |`

**`CHANGELOG.md:148`** ist die schlimmste Einzelstelle, weil sie in der
**Prüfanleitung zu Paket 1.0.22** steht — also zu genau dem Paket, mit dem
Gregor gemessen hat, dass es klappt:

> `| ***File → Exit*** | beendet sauber | **bekannt: tut es nicht** (Kriterium 7) |`

**`CHANGELOG.md:636-644`** (*Wo man weitermachen kann*, Punkt 2):

> *„Das ist der **einzige verbliebene Fehler** der zweiten Stufe. … Noch nicht
> untersucht."*

Das ist doppelt falsch: untersucht ist es (`Befunde/BEENDEN.md`, 557 Zeilen),
und behoben ist es auch.

**`AUFGABEN.md:8`, `:20`, `:31-117`** — siehe L-9.14.

**Was stattdessen gilt.** `ZIEL.md:36`: **erfüllt**, Gregor am 08.09.2026 an
Paket 1.0.22 — *„schließen klappt jetzt."* Alle drei Wege beenden. Offen bleibt
allein **E-43**: `SaveBarState` wirft weiter, der Leistenzustand wird nie
gespeichert, und das Beenden läuft nur durch, weil E-42 den Wurf abfängt.

**Vorschlag für den neuen Text** (`README.md:43-46`):

> **Fertig ist es nicht.** Was ein Anwender jetzt noch merkt, sind drei Dinge:
> das Erscheinungsbild direkt nach dem ersten Anlegen eines Kontos ist falsch
> (E-44), *Task Status* und *Task Errors* stehen senkrecht links statt waagrecht
> unten (A-2), und die untere Statuszeile mit den Reitern für offene Fenster
> fehlt; die offenen Fenster stehen nur im *Window*-Menü (Kriterium 8, halb).
> **Beenden geht** — seit dem 08.09.2026, alle drei Wege (Menü, Alt-F4, Kreuz).
> Der Fehler dahinter ist damit nicht verschwunden, sondern abgefangen: er steht
> als Protokollzeile da und ist als **E-43** offen.

Für `CHANGELOG.md:148`:

> \| ***File → Exit***, **Alt-F4**, **Kreuz** \| beenden sauber \| E-40/E-41/E-42 greifen nicht — die `E-42`-Zeile in `eudora.log` nennt den Schritt \|

Für `WEITERMACHEN.md:34`:

> \| 7 \| ***File → Exit*** beendet Eudora sauber \| **erfüllt** (08.09.2026, Paket 1.0.22, von Gregor bestätigt) — Rest als E-43 offen \|

## L-9.2 — E-40, E-41, E-42 und E-43 stehen in **keiner** Datei außer `ZIEL.md` (schwer)

Gemessen über alle 50 Dateien, im Rohmodus:

```
perl scan2.pl mds.txt 'E-4[0123]'
→ genau ein Treffer: ZIEL.md:36
```

Im Quelltext sind die drei Behebungen dagegen vergeben und begründet:

| Kennung | Fundstelle im Quelltext |
|---|---|
| E-40 | `Eudora71/Eudora/doc.cpp:11,73,87`; `Eudora71/Eudora/msgdoc.cpp:1057,1066` |
| E-41 | `Eudora71/Eudora/mainfrm.cpp:5462,5494,5508` |
| E-42 | `Eudora71/Eudora/mainfrm.cpp:5079,5102` |
| E-43 | **nirgends** — weder Quelltext noch MD außer `ZIEL.md:36` |

**Was stattdessen gilt.** Das Verzeichnis in `BEFUNDE.md` endet bei **E-39**
(`BEFUNDE.md:183`). Die drei Behebungen, die Kriterium 7 erfüllt haben, haben
dort keine Zeile; der verbliebene Fehler **E-43** existiert als bloße Erwähnung
in einem Satz von `ZIEL.md:36`. Damit ist die Frage aus dem Auftrag gemessen:
**`BEFUNDE.md` kennt E-43 nicht.**

Das ist genau die Fehlerklasse, für die Prüfung 10 in `tools/doku-pruefen.pl`
gebaut wurde — *„E-34, E-35 und E-36 fehlten dort vollständig, und `ZIEL.md`
belegte Kriterium 4 mit genau diesen drei"* (`tools/doku-pruefen.pl:507-515`).
Sie greift hier nicht, siehe L-9.17.

**Vorschlag für den neuen Text**, vier Zeilen hinter `BEFUNDE.md:183`
(Spalten: Kennung | Worum es geht | Status):

- **E-40** — eine Rückfrage, die sich nicht öffnen lässt, galt als *Abbrechen*:
  `CDoc::SaveModified` und `CMessageDoc::SaveModified` gaben bei jedem
  fehlgeschlagenen `AfxMessageBox` FALSE zurück und brachen damit das Beenden ab.
  **Status:** behoben und von Gregor bestätigt (Paket 1.0.22, 08.09.2026) —
  `doc.cpp:73-87`, `msgdoc.cpp:1057-1066`; der Fehlschlag geht ins Protokoll und
  gilt nicht mehr als Nein.
- **E-41** — Alt-F4 und das Kreuz laufen durch ein `ENSURE_VALID` in
  `CFrameWnd::OnSysCommand`, das *File → Exit* nicht hat: dieselbe Ausnahme,
  dieselbe Meldung, **vor** jedem `OnClose`. **Status:** behoben und von Gregor
  bestätigt (Paket 1.0.22) — `CMainFrame::OnSysCommand`
  (`mainfrm.cpp:5462-5508`) fängt `SC_CLOSE` ab und schickt `WM_CLOSE` selbst.
- **E-42** — zwölf Aufräumschritte in `CMainFrame::CloseDown` konnten das
  Beenden abbrechen. **Status:** behoben und von Gregor bestätigt (Paket 1.0.22)
  — jeder Schritt einzeln in `TRY`/`CATCH_ALL`, der Wurf geht ins Protokoll
  (`mainfrm.cpp:5079-5102`). Nur eine bewusste Entscheidung des Anwenders bricht
  das Beenden noch ab.
- **E-43** — `SaveBarState("ToolBar")` wirft; der Leistenzustand wird nie
  gespeichert. **Status: offen.** Sichtbar seit E-42 als Protokollzeile
  `E-42 Beenden: Schritt 'SaveBarState(ToolBar)' hat eine Ausnahme ausgeloest`.
  Das Beenden läuft nur deshalb durch, weil E-42 den Wurf abfängt; die Ursache
  ist nicht belegt. Der vermessene Weg steht in `Befunde/BEENDEN.md`.

## L-9.3 — E-37 wird an acht Stellen als behoben geführt (schwer)

**Das ist die wichtigste Berichtigung.** Gregor am 08.09.2026 zu Paket 1.0.22:
*„die meldung kommt, wenn ich eine persona geloescht habe"* und *„sie
verschwindet links nicht, bis ich eudora geschlossen habe"*. Der
`PopulateView()`-Aufruf hat geworfen, die Ausnahme lief aus dem Befehlsbehandler
heraus, `ProcessWndProcException` zeigte **„Encountered an improper argument"**,
und die Liste blieb unverändert. Ein zweiter Anlauf ist gebaut, aber **von
Gregor nicht bestätigt**.

| Datei:Zeile | Zitat | was stattdessen gilt |
|---|---|---|
| `AUFGABEN.md:119` | *„### 2. E-37 — Anzeige behoben, Ursache offen"* | die Anzeige ist **nicht** behoben; der erste Anlauf hat sie verschlechtert |
| `AUFGABEN.md:121` | *„**Behoben am 07.09.2026, aber in keinem Paket.**"* | es war in Paket 1.0.22, und dort ist es aufgeschlagen |
| `AUFGABEN.md:131-132` | *„die Liste wird einmal am Ende über `PopulateView()` neu aufgebaut"* | genau dieser Aufruf ist die Fehlerquelle |
| `AUFGABEN.md:8` | *„## Die Hauptarbeit: das Beenden, zwei Kontofehler, die Reiterleiste"* | E-37 ist einer der „zwei Kontofehler" und wird unten als behoben geführt |
| `README.md:76-78` | *„**Nur die Anzeige ist behoben, die Ursache ist offen — und in keinem Paket.**"* | zweimal falsch: nicht behoben, und in 1.0.22 gewesen |
| `README.md:116` | *„E-37 viermal (behoben)"* | nicht behoben |
| `CHANGELOG.md:22` | *„E-37 ist behoben, indem die Liste neu aufgebaut wird."* | der Neuaufbau ist die Fehlerquelle |
| `CHANGELOG.md:58,68` | *„**E-37: nur die ANZEIGE behoben** … **Von Gregor nicht nachgemessen** — es ist in keinem Paket."* | von Gregor nachgemessen, und durchgefallen |
| `BEFUNDE.md:181` | *„**nur die ANZEIGE behoben — die Ursache ist offen.**"* | die Anzeige ist nicht behoben |

**Vorschlag für den neuen Text** (`BEFUNDE.md:181`, Statusspalte):

> **offen — der erste Behebungsversuch hat es verschlechtert.** Gregors Messung
> vom 07.09.2026: *„ja, sie verschwinden nach neustart"* — gelöscht wird immer
> korrekt, nur die Liste im Fenster blieb stehen. Der erste Anlauf (Liste am
> Ende über `PopulateView()` neu aufbauen) hat in Paket 1.0.22 **geworfen**: die
> Ausnahme lief aus dem Befehlsbehandler heraus, `ProcessWndProcException`
> zeigte **„Encountered an improper argument"**, und die Liste blieb trotzdem
> stehen. Gregor am 08.09.2026: *„die meldung kommt, wenn ich eine persona
> geloescht habe"*, *„sie verschwindet links nicht, bis ich eudora geschlossen
> habe"*. Ein **zweiter** Anlauf ist gebaut und **noch nicht bestätigt**. Offen
> bleiben zusätzlich: (a) **warum** `FindItem` den Eintrag nicht findet;
> (b) das Löschen der **aktuell benutzten** Persönlichkeit, siehe **E-39**

Und für `AUFGABEN.md:119`: **`### 2. E-37 — nicht behoben; der erste Anlauf hat
geworfen`**.

## L-9.4 — die Bilanz „fünf von neun belegt" steht dreimal (schwer)

| Datei:Zeile | Zitat |
|---|---|
| `README.md:36-37` | *„**Neun Kriterien stehen in ZIEL.md — fünf sind belegt (0, 1, 3, 5, 6), drei fast oder halb (2, 4, 8), eines nicht: das Beenden (7).**"* |
| `WEITERMACHEN.md:23-24` | *„**Neun Kriterien stehen in ZIEL.md — fünf belegt (0, 1, 3, 5, 6), drei fast oder halb (2, 4, 8), eines nicht: das Beenden (7).**"* |
| `CHANGELOG.md:122-124` | *„Von den neun Kriterien sind fünf belegt, drei fast oder halb, und **eines nicht: das Beenden**."* |

**Was stattdessen gilt.** `ZIEL.md:39-40`: *„**Sechs von neun Kriterien sind
belegt (0, 1, 3, 5, 6, 7), zwei fast oder halb (2, 4), eines nicht (8 — die
Reiterleiste).**"* — `PORTIERUNG.md:38-40` hat es als einzige Statusdatei
richtig.

**Vorschlag:** den Satz aus `ZIEL.md:39-40` wörtlich übernehmen, wie
`PORTIERUNG.md` es tut.

**Der Eintrag in `CHANGELOG.md:122-124` ist kein Mangel** — er steht unter der
Überschrift `## 7.2.0.21 / Paket 1.0.21` (`:99`), also in einem datierten
Rückblick, und war an jenem Tag richtig. Falsch sind nur `README.md:36` und
`WEITERMACHEN.md:23`, weil beide Dateien in ihren ersten Zeilen behaupten, den
**heutigen** Stand zu nennen (`README.md:14`, `WEITERMACHEN.md:3`).

**Wichtig für die Schranke:** alle drei Sätze sind rechnerisch richtig
(5 + 3 + 1 = 9). Deshalb hat `tools/doku-pruefen.pl` sie nicht gefunden — siehe
L-9.17.

## L-9.5 — `Releases/PAKETE.md` kennt Paket 1.0.22 nicht (schwer)

**`Releases/PAKETE.md:13-19`**

> *„**Im Repo liegen als ZIP** (`ls Releases/*.zip`, nachgezählt am 07.09.2026):
> nur noch **1.0.2** (`Eudora72-1.0.2-lauffaehig.zip` …) und **1.0.21**
> (`Eudora72-1.0.21-release.zip`)."*

**Gemessen am 08.09.2026:**

```
ls Releases/*.zip
Releases/Eudora72-1.0.2-lauffaehig.zip
Releases/Eudora72-1.0.21-release.zip
Releases/Eudora72-1.0.22-release.zip
```

**`Releases/PAKETE.md:25-27`**

> *„Der Quellstand ist **7.2.0.21 / Paketnummer 1.0.21**, und das Paket dazu
> liegt vor."*

Das ist keine datierte Rückschau, sondern eine Aussage in der Gegenwartsform im
Kopfkasten — also ein Mangel. `VERSION` sagt `1.0.22`, `Version.h:14` sagt
`7.2.0.22`.

Dazu: die Datei hat **keinen Abschnitt `## 1.0.22`**; der jüngste ist
`## 1.0.21 — veröffentlicht am 07.09.2026` (`:136`). Und `:28` besteht aus dem
Textrest **`> offen.`** — ein Satzende ohne Satz.

**Nicht zu ändern:** `:164-168` (*„Was in dieser Fassung noch nicht geht: File →
Exit beendet Eudora nicht"*) steht unter der Überschrift `## 1.0.21` und gilt
für jene Fassung. Das war richtig und bleibt richtig.

**Vorschlag für den neuen Text** (`Releases/PAKETE.md:13-19` und `:25-27`):

> **Im Repo liegen als ZIP** (`ls Releases/*.zip`, nachgezählt am 08.09.2026):
> **1.0.2** (`Eudora72-1.0.2-lauffaehig.zip`, Baugrundlage für
> `tools/paket-bauen.ps1` — **nicht löschen**), **1.0.21** und **1.0.22**
> (`Eudora72-1.0.22-release.zip`, das aktuelle Paket).
>
> Der Quellstand ist **7.2.0.22 / Paketnummer 1.0.22** (`cat VERSION`,
> `grep EUDORA_BUILD_VERSION Eudora71/Version.h`), und das Paket dazu liegt vor.
> Als Marke ist es noch **nicht** veröffentlicht; die jüngste Marke ist
> `v1.0.21`.

Dazu ein neuer Abschnitt `## 1.0.22 — gebaut am 08.09.2026, nicht als Marke
veröffentlicht` mit ZIP-Name, SHA256
(`7ddab1a0f0fdf1c4458a7aa2ab00d2f1fbb15561ab576657c73006fcfa95586c`,
gemessen in `WEITERMACHEN.md:11` und `CHANGELOG.md:136`), Quellstand 7.2.0.22,
und: *„Die Fassung, mit der Kriterium 7 erfüllt wurde — E-40, E-41, E-42; Gregor
am 08.09.2026: ‚schließen klappt jetzt.' Ebenfalls belegt: A-1. Aufgeschlagen
ist der erste E-37-Anlauf."* Und `:28` löschen.

## L-9.6 — Anforderung A-2 steht nur in `ZIEL.md` (schwer)

Gemessen: `A-2\b|waagrecht|Task Errors|Task Status` über alle 50 Dateien —
Treffer in `ZIEL.md:175,179,183,188`, sonst nur in **Zeitdokumenten**
(`BEFUNDE.md:2800,3091,5107`, `Eudora71/OTShim/BEFUND-ANSICHT.md:269,304`,
`README.md:552` — dort in anderer Sache: *„Link History und Task Status bleiben
leer"*).

**Was stattdessen gilt.** `ZIEL.md:175-195` hält A-2 als verbindliche
Anforderung fest, samt Gregors Reihenfolge: *„nach dem exit-fix korrigieren"* —
und der Exit-Fix ist da. **A-2 ist damit die erste Aufgabe**, und sie steht in
`AUFGABEN.md` nicht, in `WEITERMACHEN.md` nicht, in `CHANGELOG.md` nicht und im
Verzeichnis von `BEFUNDE.md` nicht.

**Vorschlag:** in `AUFGABEN.md` als Abschnitt 1 unter *Die Hauptarbeit*:

> ### 1. A-2 — *Task Status* und *Task Errors* waagrecht unten
>
> Gregor am 08.09.2026: *„task errors und task status wären waagrecht unten
> besser als senkrecht — nach dem exit-fix korrigieren."* Der Exit-Fix ist da
> (Kriterium 7 erfüllt), also gilt jetzt das. Beide Bereiche liegen heute
> senkrecht als schmale Spalten links neben dem MDI-Bereich. Fundstellen zum
> Einstieg stehen in `ZIEL.md:192-195`: `Eudora71/Eudora/WazooBar.cpp`, Abschnitt
> `[WazooBars]` in der `Eudora.ini` (`WazooBarIds`, `WazooBar%d`, `WazooMDI%d`,
> Namen in `EudoraRes.rc:10637-10640`), und die Andockseite in
> `Eudora71/OTShim/OTShim_Werkzeugleiste.cpp`. Die Vorarbeit dazu liegt schon
> vor: `Eudora71/OTShim/BEFUND-ANSICHT.md:304` (*„Punkt 3 — Task Status / Task
> Errors als senkrechter Streifen mitten im Fenster"*). Zusammenhang mit
> Kriterium 8: dieselbe Gegend des Fensters, dieselbe Ersatzschicht — wer eines
> angeht, sieht sich das andere gleich mit an.

## L-9.7 — der neue Befund zum Erscheinungsbild nach dem Kontoanlegen steht nirgends (schwer)

Gregor am 08.09.2026, mit Bildschirmfoto: *„erscheinungsbild nach dem ersten
anlegen von konto wie im screenshot. muss korrigiert werden."* Alle
Wazoo-Bereiche liegen als schmale senkrechte Spalten links, der MDI-Bereich ist
nach rechts gedrängt.

**Gemessen: null Fundstellen.** `Erscheinungsbild` trifft nur in
Zeitdokumenten (`BEFUNDE.md:121,3048,5513`, `LEKTORAT.md`,
`Eudora71/OTShim/BEFUND-ANSICHT.md:1`, `PORTIERUNG.md:35,512`) und nie in
Verbindung mit dem **Anlegen eines Kontos**. Kein Eintrag in `BEFUNDE.md`, keine
Kennung, keine Aufgabe.

**Vorschlag:** eine neue Kennung **E-44** im Verzeichnis von `BEFUNDE.md`:

> **E-44** — das Erscheinungsbild direkt nach dem **ersten** Anlegen eines
> Kontos ist falsch: alle Wazoo-Bereiche liegen als schmale senkrechte Spalten
> links, der MDI-Bereich ist nach rechts gedrängt. **Status: offen, von Gregor
> am 08.09.2026 an Paket 1.0.22 gemeldet** (*„erscheinungsbild nach dem ersten
> anlegen von konto wie im screenshot. muss korrigiert werden."*), mit
> Bildschirmfoto. Der Fall unterscheidet sich von S-6: er tritt beim **ersten**
> Lauf auf, also bevor `[WazooBars]` in der `Eudora.ini` steht — der Weg führt
> deshalb über `CWazooBarMgr::SetDefaultWazooBarState` und
> `CWazooBarMgr::CreateInitialWazooBars`, nicht über `LoadBarState`. Gehört mit
> **A-2** in einen Arbeitsgang, weil beide dieselbe Andockrechnung betreffen.

Dazu ein Verweis in `ZIEL.md` bei Kriterium 2, weil es die Darstellung betrifft.

## L-9.8 — die Kennung `A-1` ist zweimal vergeben (schwer)

| Bedeutung | Fundstellen |
|---|---|
| **Vorgaben für ein neu angelegtes Konto** (Gregors Anforderung) | `ZIEL.md:113,167`; `CHANGELOG.md:75,85`; `tools/doku-pruefen.pl:523` |
| **Erscheinungsbild (S-6), fünf Punkte umgesetzt** (Agentenbefund vom 30.08.2026) | `BEFUNDE.md:110,121,3048,4911,4925,5051,5071,5099`; `PORTIERUNG.md:35,512`; `Releases/PAKETE.md:307`; `LEKTORAT.md:66,170,172,181,193,289`; `AUFGABEN.md:396` |

`AUFGABEN.md:396` ist die verwirrendste Stelle, weil sie beide Zählungen mischt:

> *„### E1 · `FloatControlBarInMDIChild` ist ein leerer Rumpf (**A-1**)"*

Hier steht `A-1` für den Erscheinungsbild-Befund, in einem Abschnitt, der `E1`
heißt — während `E-1` im Verzeichnis von `BEFUNDE.md:151` der erste erfolgreiche
Mailabruf ist.

**Was stattdessen gilt.** `ZIEL.md:106-111` legt die Zählung `A-n` ausdrücklich
für **Gregors Anforderungen** fest: *„sie bekommen eine Kennung `A-n` und stehen
hier, damit sie nachprüfbar sind"*. Der ältere Agentenbefund hat damit einen
Namen, der schon vergeben ist.

**Vorschlag:** den alten Befund in `BEFUNDE.md` auf **`S-6a`** umbenennen (er
ist ohnehin die Umsetzung von S-6, siehe `BEFUNDE.md:110`) und in jeder der
oben genannten Zeitdokumentzeilen einmalig `A-1 (heute S-6a)` schreiben. `A-1`
bleibt allein Gregors Kontovorgabe. Die Umbenennung gehört in einen eigenen
Commit, weil sie 18 Zeilen in fünf Dateien berührt.

## L-9.9 — `CHANGELOG.md` hat keinen Abschnitt für 7.2.0.22 / Paket 1.0.22 (schwer)

Gemessen (`grep -n '^#\{2,3\} ' CHANGELOG.md`):

```
 49:## Nach 7.2.0.22 — alles Gebaute ist gepackt
 99:## 7.2.0.21 / Paket 1.0.21 — 07.09.2026 · fünf Verfassen-Fenster, kein Absturz
114:### Von Gregor bestätigt: Mail schreiben, senden, empfangen
134:### Was an 1.0.22 zu prüfen ist
```

Die Prüfanleitung zum aktuellen Paket hängt als `###` **innerhalb** des
Abschnitts zu 1.0.21. Damit hat 1.0.22 keinen eigenen Eintrag, obwohl es die
Fassung ist, die Kriterium 7 erfüllt und A-1 belegt.

Dazu drei Widersprüche im Abschnitt `## Nach 7.2.0.22` (`:49-85`):

| Zeile | Zitat | was stattdessen gilt |
|---|---|---|
| `:51` | *„Zurzeit liegt **keine** Änderung im Repo, die nicht in Paket **1.0.22** steckt."* | richtig — dann gehören die Punkte darunter aber in den Abschnitt zu 1.0.22, nicht in „danach" |
| `:68` | *„**Von Gregor nicht nachgemessen** — es ist in keinem Paket."* (zu E-37) | es war in 1.0.22 und ist aufgeschlagen, siehe L-9.3 |
| `:75-77` | *„**`tools/DEudora.ini`** — Vorgaben für neu angelegte Konten (**A-1** …)"* | ohne den Beleg: A-1 ist seit dem 08.09.2026 am laufenden Programm bestätigt |
| `:12` | *„## Noch offen (Stand 07.09.2026)"* | der Stand ist der 08.09.2026 |

**Vorschlag:** einen Abschnitt `## 7.2.0.22 / Paket 1.0.22 — 08.09.2026 ·
Beenden geht` **oberhalb** von `:99` anlegen, die vorhandene Unterüberschrift
`### Was an 1.0.22 zu prüfen ist` (`:134`) dorthin verschieben, und die Punkte
aus `:58-85` (E-37, Spurmarken, `DEudora.ini`, `bauen.ps1`, `doku-pruefen.pl`)
in ihn hineinziehen. Der Abschnitt `## Nach 7.2.0.22` bleibt dann als leerer
Platzhalter mit dem Satz aus `:51-56` stehen — das ist seine Aufgabe.

## L-9.10 — A-1 wird in `README.md` nicht als belegt geführt (mittel)

`README.md:119-144` beschreibt `tools/DEudora.ini` und die vier Werte
vollständig und richtig. Was fehlt, ist der **Beleg am laufenden Programm**:
Gregor am 08.09.2026 an Paket 1.0.22 — *„default werte beim neuen persona konto
für ‚leave message on server' greifen."* Die Datei sagt nur, wie es gebaut ist,
nicht dass es wirkt.

**Vorschlag**, als neuer Satz hinter `README.md:144`:

> **Am laufenden Programm belegt.** Gregor am 08.09.2026 an Paket 1.0.22, nach
> dem Anlegen eines neuen Kontos: *„default werte beim neuen persona konto für
> ‚leave message on server' greifen."* Die Anforderung dahinter ist **A-1** in
> [ZIEL.md](ZIEL.md); `tools/paket-pruefen.ps1` warnt, wenn die Datei im Paket
> fehlt oder einen der vier Werte nicht trägt.

## L-9.11 — 18 Verweise ins Leere in `Befunde/LEKTOR-4.md` (mittel)

Gemessen mit einem eigenen Prüfskript über alle 50 Dateien: **18 Treffer, alle
in einer Datei.** Die Ursache ist überall dieselbe — die Datei liegt in
`Befunde/`, schreibt aber `](CHANGELOG.md)` statt `](../CHANGELOG.md)`:

| Zeile | Verweis | zeigt tatsächlich auf |
|---|---|---|
| 363, 796, 801, 836, 1106 | `CHANGELOG.md` | `Befunde/CHANGELOG.md` — gibt es nicht |
| 647, 835, 1105 | `ZIEL.md` | `Befunde/ZIEL.md` |
| 797 | `AUFGABEN.md` | `Befunde/AUFGABEN.md` |
| 836, 1106 | `README.md` | `Befunde/README.md` |
| 963 | `AGENTEN.md` | `Befunde/AGENTEN.md` |
| 1108 | `WEITERMACHEN.md` | `Befunde/WEITERMACHEN.md` |
| 839-842 | `Befunde/LEKTOR.md` … `Befunde/LEKTOR-4.md` | `Befunde/Befunde/LEKTOR*.md` — die letzte zeigt auf sich selbst |
| 1019 | `../../Eudora71/QCSSL/src/QCSSLContext.cpp` | eine Ebene zu hoch |

**Vorschlag:** `../` voranstellen, bei `:839-842` das doppelte `Befunde/`
entfernen, bei `:1019` ein `../` streichen. Das ist reine Mechanik und ändert
keine Aussage.

## L-9.12 — `Befunde/BEENDEN.md` hat keinen Nachtrag zum Abschluss (mittel)

Die Datei heißt in `:1` **„E-33 — *File → Exit* beendet Eudora nicht"** und sagt
in `:32-33`:

> *„Das ist **Kriterium 7** in [ZIEL.md](../ZIEL.md) und der einzige verbliebene
> Fehler der zweiten Stufe."*

Der jüngste Nachtrag ist vom 07.09.2026 (`:522`). Als Zeitdokument darf die
Datei ihre damaligen Behauptungen behalten — `ZIEL.md:36` und `CHANGELOG.md`
verweisen aber weiter auf sie, und ein Leser, der dort landet, findet keinen
Hinweis, dass der Fall entschieden ist.

**Vorschlag**, als Kasten hinter `:5`:

> **Nachtrag 08.09.2026: der Fall ist entschieden.** Kriterium 7 ist **erfüllt**
> — Gregor an Paket 1.0.22: *„schließen klappt jetzt."* Alle drei Wege beenden.
> Behoben durch **E-40** (eine Rückfrage, die sich nicht öffnen lässt, galt als
> Abbrechen), **E-41** (Alt-F4 und das Kreuz laufen durch ein `ENSURE_VALID` in
> `CFrameWnd::OnSysCommand`, das *File → Exit* nicht hat — die Folgerung des
> zweiten Durchgangs, siehe `:522`, hat getragen) und **E-42** (zwölf
> Aufräumschritte konnten das Beenden abbrechen). Der Wurf selbst ist **nicht**
> verschwunden: `SaveBarState("ToolBar")` wirft weiter und steht als **E-43**
> offen. Was unten steht, bleibt als vermessener Weg richtig.

## L-9.13 — `Befunde/PRUEFER-4.md`: das E-37-Urteil ist widerlegt, ohne Nachtrag (leicht)

`Befunde/PRUEFER-4.md:19` fragt *„## 1. E-37 — ist die Behebung richtig und
vollständig?"* und antwortet mit *„teilweise bestätigt — die Behebung wirkt und
richtet keinen neuen Schaden an"* (zitiert in `BEFUNDE.md:181`). Am laufenden
Programm ist das widerlegt: sie richtet Schaden an (L-9.3). Zeitdokument, darf
stehen bleiben — aber ein Zweizeiler *„Nachtrag 08.09.2026: am laufenden
Programm widerlegt, siehe E-37"* würde verhindern, dass das Urteil ein zweites
Mal als Beleg zitiert wird. Es ist genau so schon einmal zitiert worden.

## L-9.14 — `AUFGABEN.md`: was ich als überholt gemessen habe (schwer)

Gregor hat die Datei ausdrücklich genannt. Gemessen, Abschnitt für Abschnitt:

| Abschnitt | Zeilen | Zustand |
|---|---|---|
| Kopf *„Stand 07.09.2026, morgens"* | 3 | **überholt** — Stand ist der 08.09.2026, zwei Pakete später |
| `## Die Hauptarbeit: das Beenden, zwei Kontofehler, die Reiterleiste` | 8 | **überholt in allen drei Punkten:** das Beenden ist erledigt, einer der zwei Kontofehler (E-37) ist nicht behoben statt behoben, und die Reiterleiste ist nicht mehr die zweite Aufgabe, sondern A-2 ist es |
| Kriterientabelle | 15-21 | **falsch bei 4 und 7** — `:17` *„das Beenden fehlt noch"*, `:20` *„**nicht erfüllt**"* |
| *„**Damit bleiben vier Punkte.**"* | 23-29 | **überholt** — von den vier ist Kriterium 7 erledigt; dazu kommen A-2 und der neue Befund zum Erscheinungsbild |
| `### 1. Kriterium 7 — das Beenden (E-33)` | 31-117 | **vollständig überholt.** 87 Zeilen Suchanleitung für einen behobenen Fehler: die offene Frage in `:51-54` (*„bringt File → Exit die Meldung … das ist die nächste Frage an Gregor"*) ist beantwortet, der Verdacht in `:71-80` ist erledigt, die Bauanleitung in `:99-105` ist gefahren |
| `### 2. E-37 — Anzeige behoben, Ursache offen` | 119-137 | **falsch** — siehe L-9.3 |
| `### 3. E-38` | 139-163 | **gültig, aber die Sperre ist weg.** `:139ff` hängt nach `README.md:99` an E-33; E-33 ist erledigt, also ist E-38 jetzt **messbar**. Das steht nirgends |
| `### 4. Kriterium 8` | 165-172 | gültig |
| `### Was schon nachgemessen ist` | 174-195 | gültig |
| `## Erledigt seit 1.0.10` | 197-207 | **unvollständig** — E-40/E-41/E-42 und A-1 fehlen, beide von Gregor bestätigt |
| `## Was sonst noch offen ist` | 209-218 | **falsch in Zeile 213** (*„File → Exit bringt eine Meldung (E-33) — Bau + Start"*); E-43 fehlt in der Tabelle |
| `## A` (ReleaseBuffer) | 222-268 | gültig, gemessen am 07.09.2026 |
| `## B` | 272-302 | `:279-282` **falsch** (nennt Kriterium 7 als ersten Schritt) |
| `## C` | 306-341 | gültig |
| `## D3a` | 347-390 | gültig |
| `## E1` | 396-412 | Kennungskollision, siehe L-9.8 |
| `## E2`, `## E3` | 414-424 | gültig |
| `## F` | 428-448 | `:440-444` **unvollständig** — der M-4-Mangel zählt 1.0.4 bis 1.0.17, 1.0.19 und 1.0.20 auf; **1.0.22 fehlt jetzt ebenfalls** in `Releases/PAKETE.md` |
| `## Zurückgestellt` | 452-456 | gültig |
| `## Auflagen für Agenten` | 460-513 | gültig — das ist der tragfähigste Teil der Datei |

**Vorgeschlagene neue Reihenfolge der Hauptarbeit** (nicht gesetzt, nur
vorgeschlagen — die Reihenfolge ist Gregors Sache):

1. **E-37 zu Ende bringen.** Der zweite Anlauf ist gebaut und unbestätigt; der
   erste hat am laufenden Programm Schaden angerichtet. Das ist der einzige
   Punkt, an dem die Portierung gerade **schlechter** ist als vor der letzten
   Änderung — deshalb vor allem anderen.
2. **A-2** — *Task Status* und *Task Errors* waagrecht unten. Gregor hat die
   Reihenfolge selbst gesetzt: *„nach dem exit-fix korrigieren"*, und der ist da.
3. **E-44** (neu) — das Erscheinungsbild nach dem ersten Anlegen eines Kontos.
   Gehört mit A-2 in einen Arbeitsgang: dieselbe Andockrechnung, dieselbe
   Ersatzschicht.
4. **E-38** — jetzt erstmals messbar, weil Eudora sich normal beenden lässt. Der
   erste Handgriff kostet keinen Bau: `[Persona-<Name>]` in der `Eudora.ini`
   nach einem normalen Beenden ansehen (`AUFGABEN.md:159-163`).
5. **Kriterium 8** — die Reiterleiste. Mit A-2 verwandt, aber größer.
6. **E-43** — `SaveBarState` wirft. Abgefangen, nicht behoben; der Leistenzustand
   wird nie gespeichert. Kein Anwender merkt es unmittelbar, deshalb hinten.

## L-9.15 — `Pruefung/PRUEFUNG-ZEIGER.md` ist die einzige MD mit CRLF (leicht)

Gemessen im Rohmodus über alle 50 Dateien:

```
Pruefung/PRUEFUNG-ZEIGER.md   CR=193, Zeilen=194
alle übrigen 49               CR=0
```

Kein inhaltlicher Widerspruch, aber die Datei fällt aus dem Bestand. Wer sie mit
einem Werkzeug anfasst, das Zeilenenden angleicht, erzeugt einen Diff über die
ganze Datei. **Vorschlag:** einmalig mit `tools/zeilenenden-angleichen.pl` auf
LF ziehen, in einem eigenen Commit, damit der Diff nachvollziehbar bleibt.

## L-9.16 — `WEITERMACHEN.md`: der Kopfkasten nennt den vorletzten Lauf (mittel)

| Zeile | Zitat | was stattdessen gilt |
|---|---|---|
| `:3` | *„**Stand 07.09.2026, morgens.**"* | 08.09.2026 |
| `:12` | *„Zuletzt von Gregor gestartet \| Paket 1.0.21 am 07.09.2026"* | Paket **1.0.22** am 08.09.2026 |
| `:13` | *„Zuletzt von Gregor bestätigte Behebungen \| 7.2.0.21 (E-31/E-34/E-35/E-36)"* | dazu **7.2.0.22**: E-40/E-41/E-42 (Beenden) und **A-1** (Kontovorgaben) |
| `:14` | *„Was er dabei bemängelt hat \| *„beenden geht nicht."* und *„kann man die untere zeile (status) immer anzeigen lassen?"*"* | jetzt: A-2 (*„task errors und task status wären waagrecht unten besser"*), das Erscheinungsbild nach dem Kontoanlegen, und die aufgeschlagene E-37-Behebung |

`:9-11` sind **richtig** (7.2.0.22 / 1.0.22 / ZIP mit SHA256) — die Datei ist
also halb nachgezogen. Genau das ist der Fall, den die Lehre *Doku parallel
berichtigen* meint: ein Wert wurde berichtigt, die Sätze daneben nicht.

## L-9.17 — die Schranke `tools/doku-pruefen.pl` greift bei keinem dieser Befunde (schwer)

Gemessen, im Bezugscommit, ohne Änderung am Baum:

```
perl tools/doku-pruefen.pl
  Quellstand                   7.2.0.22
  Paketnummer                  1.0.22
  Kriterien in ZIEL.md         9
  gepruefte Dateien            18
  Kennungen im Verzeichnis     38
  Abschnitte in BEFUNDE.md     13
  Kein Widerspruch gefunden.
EXIT=0
```

**Die Schranke gibt Entwarnung**, während sechs Statusdateien Kriterium 7 als
offen führen und vier Befundkennungen fehlen. Die Ursachen sind gelesen, nicht
vermutet:

1. **Prüfung 3 zählt nur die Summe, nicht die Verteilung**
   (`tools/doku-pruefen.pl:114-135`). Sie vergleicht Zahlwörter gegen die Anzahl
   der Kriterienzeilen in `ZIEL.md`. *„fünf belegt, drei fast, eines nicht"*
   ergibt neun und geht durch. Welches Kriterium welchen Stand hat, prüft sie
   nicht.
2. **Prüfung 10a liest `CHANGELOG.md`, nicht `ZIEL.md`**
   (`:507-521`): `$im_changelog{$1} = 1 while $changelog =~ /^###\s+(E-\d+)\b/gm`
   — sie meldet nur Kennungen, die im `CHANGELOG` eine **eigene
   `###`-Überschrift** haben und im Verzeichnis fehlen. E-40, E-41 und E-42
   stehen im `CHANGELOG` überhaupt nicht, also fällt nichts auf. Dabei nennt der
   Kommentar darüber genau diesen Fall als Anlass: *„E-34, E-35 und E-36 fehlten
   dort vollständig — und `ZIEL.md` belegte Kriterium 4 mit genau diesen drei."*
   Der Anlass war `ZIEL.md`, die Umsetzung liest `CHANGELOG.md`.
3. **18 von 50 Dateien werden auf Aktualität geprüft** (`:106`): alles unter
   `Befunde/`, `Pruefung/`, `Releases/1.0/`, dazu `BEFUNDE.md`, `LEKTORAT.md`,
   `PRUEFUNG-*`, `ABRUF-PRUEFEN.md` und **`Releases/PAKETE.md`** gilt als
   Zeitdokument. Deshalb bleibt L-9.5 (`Releases/PAKETE.md:25`, *„Der Quellstand
   ist 7.2.0.21"*) stumm, obwohl es ein Kopfkasten in der Gegenwartsform ist.

**Vorschlag — drei Prüfungen, jede mit Gegenprobe:**

- **Prüfung 12: Kriterienstand je Nummer.** Aus `ZIEL.md` je Kriterium das erste
  fette Statuswort ziehen (`erfüllt` / `fast` / `halb` / `nicht`) und gegen die
  Kriterientabellen in `README.md`, `WEITERMACHEN.md`, `AUFGABEN.md` und
  `CHANGELOG.md` halten. Gegenprobe **umgedreht** (nach Gregors Technik): in
  einer Kopie von `README.md` Kriterium 7 auf `**erfüllt**` setzen — die Prüfung
  muss dann schweigen; auf `**nicht erfüllt**` setzen — sie muss anschlagen.
- **Prüfung 13: Kennungen aus `ZIEL.md` gegen das Verzeichnis.** Jede `E-\d+`
  und `A-\d+`, die in `ZIEL.md` vorkommt, muss im Verzeichnis von `BEFUNDE.md`
  eine Zeile haben. Gegenprobe: E-43 aus `ZIEL.md:36` entfernen — Prüfung
  schweigt; wieder einsetzen — sie schlägt an. Heute schlägt sie an.
- **Prüfung 14: Kopfkästen sind keine Zeitdokumente.** Die
  Zeitdokument-Ausnahme endet nach der ersten `##`-Überschrift einer Datei; was
  davor steht, wird wie eine Statusdatei geprüft. Damit fällt
  `Releases/PAKETE.md:25` auf, ohne dass die 250 datierten Zeilen darunter
  Fehlalarme erzeugen. Gegenprobe: `Releases/PAKETE.md:164` (*„Was in dieser
  Fassung noch nicht geht"*, unter `## 1.0.21`) darf **nicht** anschlagen.

## L-9.18 — Adressat und Zweck: fünf Dateien ohne H1 (leicht)

Geprüft, ob in den ersten Zeilen steht, für wen die Datei ist und was in ihr
gilt. **45 von 50 sind in Ordnung**, viele ausdrücklich gut: `LEKTORAT.md:3`
(*„Diese Datei ist ein Fahrtenbuch, kein Statusbericht"*), `PORTIERUNG.md:8`
(*„Für wen diese Datei ist"*), `Eudora71/OTShim/INVENTAR.md:3` (*„diese Datei
ist maschinell erzeugt und enthaelt Fehler"*), `STARTUMGEBUNG.md:6`
(*„Überholt in den Voraussagen"*), `ZIEL.md:12` (*„Diese Tabelle ist die
Quelle"*).

Fünf beginnen mit `##` statt `#` und haben damit keine Überschrift, sondern
gleich einen Abschnitt: `Befunde/PAKET.md`, `Befunde/PERSONA.md`,
`Befunde/PORT.md`, `Befunde/POSTFACH.md`, `Befunde/SPUR.md`. Alle fünf tragen
darunter eine Kopfzeile mit Agent, Zweig, Datum und Status — der Zweck ist also
erkennbar, nur die Ebene stimmt nicht. **Vorschlag:** eine `#`-Zeile mit der
Kennung voranstellen, wie `Befunde/SYMBOLE.md` es macht.

`AUFGABEN.md` hat keinen Adressatensatz — nur *„Stand 07.09.2026, morgens"* und
Verweise. Beim Umbau (L-9.14) wäre ein Satz angebracht: *„Für den Agenten, der
als nächstes anfängt. Was hier steht, ist die Reihenfolge; der Maßstab ist
`ZIEL.md`."*

---

# Was ich nicht prüfen konnte

- **Ob der zweite E-37-Anlauf trägt.** Er ist gebaut, aber nicht gestartet — ich
  habe nach Auflage nichts gebaut und kein Programm mit Fenster gestartet. Die
  Aussage *„nicht bestätigt"* stammt aus dem Auftrag, nicht aus einer eigenen
  Messung.
- **Das Bildschirmfoto zum Erscheinungsbild nach dem Kontoanlegen.** Ich habe es
  nicht gesehen; die Beschreibung (*„Wazoo-Bereiche als schmale senkrechte
  Spalten links, MDI-Bereich nach rechts gedrängt"*) stammt aus dem Auftrag.
  **Vermutung**, dass der Fall von S-6 verschieden ist, weil beim **ersten** Lauf
  noch kein `[WazooBars]` in der `Eudora.ini` steht und der Weg deshalb über
  `SetDefaultWazooBarState` statt `LoadBarState` läuft — gelesen in
  `Eudora71/OTShim/BEFUND-ANSICHT.md:304-314` und `BEFUNDE.md:5265-5303`, **nicht
  am laufenden Programm gemessen**.
- **Ob E-40/E-41/E-42 im Quelltext das tun, was `ZIEL.md:36` behauptet.** Ich
  habe die Kennungen und ihre Kommentare gefunden (`doc.cpp:73`,
  `msgdoc.cpp:1057`, `mainfrm.cpp:5079`, `mainfrm.cpp:5462`) und den
  Protokolltext aus `mainfrm.cpp:5102` gegen `ZIEL.md:36` gehalten — er stimmt
  wörtlich. Die **Wirkung** habe ich nicht gemessen; das hat Gregor getan.
- **Die Zeilennummern in den Änderungsvorschlägen** gelten für den Bezugscommit
  `d003d46`. Am `AUFGABEN.md`, `README.md`, `CHANGELOG.md`, `BEFUNDE.md` und
  `Eudora71/Eudora/PersonalityView.cpp` wurde parallel zu dieser Prüfung
  gearbeitet; wer die Vorschläge einsetzt, prüft die Zeilen nach.
- **Die Marke `v1.0.22`.** `WEITERMACHEN.md:11` sagt, sie sei noch nicht
  veröffentlicht. Ich habe `git ls-remote --tags origin` nicht gefahren, weil
  dafür ein Netzzugriff nötig ist; die Aussage ist übernommen, nicht gemessen.
- **Ob die vorgeschlagenen Prüfungen 12 bis 14 fehlalarmfrei sind.** Die
  Gegenproben sind entworfen, nicht gefahren — dafür hätte ich
  `tools/doku-pruefen.pl` ändern müssen, und ich schreibe nach Auflage nur diese
  eine Datei.
