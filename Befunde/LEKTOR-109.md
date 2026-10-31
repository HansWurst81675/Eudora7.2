# <a id="lektor-109"></a>LEKTOR-109 — Kurzlauf vor dem Testpaket 7.2.1.129 (31.10.2026)

Kurzer Lauf, kein Vollbestand. Geprüft: die beiden Funde aus
[LEKTOR-108](LEKTOR-108.md) und alles seit `295f01d0`: FAQ 16 (`c5e8db39`),
der Messweg zu [E-136](../Intern/BEFUNDE.md#e-136) (Emoji gehen beim
Speichern verloren; `d74af082`, `3d4df61a`) und die Vergabe der Nummer
7.2.1.129 (`11643ee1`).

## Kurz

Beide Funde aus [LEKTOR-108](LEKTOR-108.md#lektor-108) sind **erledigt**.
Die Angaben zu 7.2.1.129 stimmen untereinander; **nirgends** steht, das
Paket sei geschnürt, ausgeliefert oder getestet. Zwei kleine neue Funde: in
der Nummerntabelle von MITARBEITEN stehen als Beispiel zwei verschiedene
Nummern, obwohl der Satz darunter sagt, beide seien gleich
([L-109.1](#l-109.1)); der CHANGELOG-Abschnitt 7.2.1.129 heißt
„Testpaket“, sagt aber nicht, dass es noch nicht geschnürt ist — PAKETE
und TESTPLAN sagen es ([L-109.2](#l-109.2)).

## Funde aus LEKTOR-108

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-108.1](LEKTOR-108.md#l-108.1) | Im Urteil zu [E-136](../Intern/BEFUNDE.md#e-136) stand der alte Absatz „Was noch fehlt … nicht gefunden“ im Präsens hinter der neuen Ursache | **erledigt** | `Intern/BEFUNDE.md:407` enthält „Was noch fehlt“ nur noch **einmal** (vorher zweimal; `grep -o … \| wc -l` → 1, gemessen), nämlich *„**Was noch fehlt:** Gregors Weg am nächsten Paket ([TESTPLAN](…)“*. Der alte Absatz heißt jetzt *„**Damals offen (bis 31.10.2026):** die Stelle, an der beim Speichern nach windows-1252 umkodiert wird. Sie war **nicht** gefunden …“* (gemessen); die Zeichenfolge „Vermutung, nicht gemessen“ kommt in der Zeile nicht mehr vor (gemessen) |
| [L-108.2](LEKTOR-108.md#l-108.2) | Überschriften in CHANGELOG und TESTPLAN sagten „gehen nicht mehr verloren“ als Tatsache | **erledigt** | `CHANGELOG.md:115` *„**Emoji und andere Zeichen außerhalb von windows-1252 beim Speichern einer HTML-Nachricht — Behebung im Quellstand, am Programm noch nicht nachgemessen**“*; `Intern/TESTPLAN.md:183` *„Im nächsten Paket: gehen Emoji beim Speichern noch verloren? ([E-136](…))“* — als Frage (gemessen) |

## Neu seit 295f01d0

### FAQ 16 — ein Wort in einer Mail suchen

`Doku/FAQ.md:314-334` (Commit `c5e8db39`). Drei Schritte (Mail öffnen,
*Blah Blah Blah*, *Strg+Umschalt+F*), dazu *Find Messages* über viele
Mails. Die Herkunft jeder Aussage ist getrennt genannt: *„die Suche nach
`x-persona` mit Blah Blah Blah und Strg+Umschalt+F am 31.10.2026 an
7.2.1.128 (*„ja, funktioniert mit ctrl-shift-F“*)“* — Gregors Bestätigung;
*„*Find Messages* mit *Headers* ist am Quelltext nachgesehen“* — nicht als
gemessen ausgegeben (gemessen am Text). Der Hinweis auf
[E-171](../Intern/BEFUNDE.md#e-171) (Suche ohne markierten Text) sagt
*„im Quellstand behoben, kommt mit dem nächsten Paket“* — stimmt mit
`Intern/BEFUNDE.md:387` und `CHANGELOG.md:104` überein (gemessen). Kein
Fund.

### E-136 — Messweg im Befund

`Intern/BEFUNDE.md:407` (Commits `d74af082`, `3d4df61a`): *„**Warum der
Prüfstand nicht schreibt (belegt am Quelltext, 31.10.2026):**
`CMessageDoc::OnUpdateFileSave` gibt *Speichern* nur mit `IsModified()`
frei …“*, *„… beantwortet weder `TB_BUTTONCOUNT` noch `TB_COMMANDTOINDEX`
(gemessen 31.10.2026, 21:02)“*. Belegt und gemessen sind getrennt
gekennzeichnet; der Befund bleibt **offen**, die Messmarke *„22.10.2026 an
7.2.0.120 — **veraltet**“* steht unverändert in `CHANGELOG.md:44` (gemessen).
Der CHANGELOG-Eintrag `CHANGELOG.md:109` nennt nur den Messweg, keine
Behebung. Die Quelltextstellen selbst habe ich nicht nachgelesen
(Kurzlauf). Kein Fund.

### Nummer 7.2.1.129

| Ort | Aussage | Urteil |
|---|---|---|
| `VERSION` | `7.2.1.129` | gemessen |
| `Eudora71/Version.h` | `EUDORA_VERSION4 129`, `7,2,1,129`, `"Version 7.2.1.129\0"`, `"7.2.1.129"` (Diff von `11643ee1`) | gemessen; gleich `VERSION` |
| `Eudora71/Bin/Release/Eudora.exe` (Hauptbaum) | Produktversion `7.2.1.129`, geschrieben 31.10.2026 21:29:06 — **nach** dem Commit `11643ee1` (21:26:49) | gemessen (Dateiinfo gelesen, nichts gestartet). „Nur übersetzt“ trifft damit zu |
| `Releases/PAKETE.md:184` | *„**Nur übersetzt am 31.10.2026, noch nicht geschnürt.** … Kein Release — veröffentlicht wird nur mit Gregors Ja.“* | stimmt (gemessen) |
| `Intern/TESTPLAN.md:1` | *„Quellstand 7.2.1.129 (Testpaket, `VERSION` gleich; nur übersetzt, Schnüren folgt) … (zuletzt getestet am 29.10.2026 das Release 7.2.1.128, [E-166](../Intern/BEFUNDE.md#e-166) bestanden)“* | stimmt (gemessen) |
| `Intern/WEITERMACHEN.md:3` | *„Testpaket **7.2.1.129** in Arbeit“* | stimmt (gemessen) |
| `Intern/AUFGABEN.md:7-8` | *„Neu seither, mit Testpaket 7.2.1.129: [[E-139](../Intern/BEFUNDE.md#e-139)], [[E-140](../Intern/BEFUNDE.md#e-140)] und [[E-171](../Intern/BEFUNDE.md#e-171)] behoben; [[E-136](../Intern/BEFUNDE.md#e-136)] und [[E-165](../Intern/BEFUNDE.md#e-165)] im Quellstand geändert, offen bis zur Messung.“* Darunter bleibt der Kopf *„**Stand 29.10.2026**, Quellstand **7.2.1.128**“* — durch den Satz davor (*„gilt der Text unten als Stand vom 29.10.2026“*) als alter Stand gekennzeichnet | stimmt (gemessen) |
| `CHANGELOG.md:104` | *„## 7.2.1.129 — Testpaket: [E-139](../Intern/BEFUNDE.md#e-139), [E-140](../Intern/BEFUNDE.md#e-140), [E-171](../Intern/BEFUNDE.md#e-171) behoben; [E-136](../Intern/BEFUNDE.md#e-136) und [E-165](../Intern/BEFUNDE.md#e-165) zum Nachmessen“* | Inhalt stimmt mit BEFUNDE (`Intern/BEFUNDE.md:403-404` *„behoben im Quellstand“*); Stand des Pakets fehlt, siehe [L-109.2](#l-109.2) |
| `Doku/MITARBEITEN.md:62-63` | Quellstand *„z. B. `7.2.1.128`“*, Paketnummer *„z. B. `7.2.1.129`“* | siehe [L-109.1](#l-109.1) |
| `Releases/PRUEFBERICHT.md:5` | *„`7.2.1.128` (Paket `7.2.1.128`; dieser Bericht gilt dem Release, nicht 7.2.1.129)“* | stimmt (gemessen) |
| `Intern/WEITERMACHEN-bis-7.2.0.md:25` | Zeile umbenannt in *„**Letztes Paket bei der Archivierung**“*, Inhalt 7.2.1.128 | stimmt; archivierte Datei (gemessen) |
| `ZIEL.md:89` | [[E-165](../Intern/BEFUNDE.md#e-165)] *„(seit 31.10.2026 im Quellstand geändert, offen bis Gregors Blick)“*, [[E-171](../Intern/BEFUNDE.md#e-171)] *„(seit 31.10.2026 im Quellstand behoben)“* | stimmt (gemessen) |
| `README.md:186` | neue Zeile zu [[E-165](../Intern/BEFUNDE.md#e-165)]: *„im Quelltext geändert (mit zwei Treffern gemessen), kommt mit dem nächsten Paket“* | stimmt (gemessen) |

**Überbehauptung gesucht:** `grep -rn "7\.2\.1\.129" --include=*.md` über
den ganzen Baum außer `Befunde/` (gemessen). Keine Stelle nennt 7.2.1.129
geschnürt, ausgeliefert, bei Gregor abgelegt, getestet oder veröffentlicht.
`Arbeitsweise/stand-29-10-2026.md:44` nennt 7.2.1.129 nur als Vorschlag
eines Werkzeugs (alter Stand).

## Neue Funde

### <a id="l-109.1"></a>L-109.1 — MITARBEITEN: zwei verschiedene Nummern als Beispiel, darunter „beide gleich“

**Gewicht: Kleinkram.** `Doku/MITARBEITEN.md:62-63`

> *„| **Quellstand**, z. B. `7.2.1.128` | `Eudora71/Version.h` | …“*
> *„| **Paketnummer**, z. B. `7.2.1.129` | die Datei `VERSION` | …“*
>
> `Doku/MITARBEITEN.md:65`: *„Ab der Endnummer 128 (erste Fassung:
> 7.2.1.128) sind beide Nummern **gleich**“*

Der Commit `11643ee1` hat nur die Zeile für die Paketnummer hochgezogen
(gemessen am Diff). Wer die Tabelle liest, sieht zwei Nummern und darunter
die Aussage, sie seien gleich.

**Vorschlag:** beide Beispiele gleich, etwa beide `7.2.1.129`, oder beide
wieder `7.2.1.128` — ein Beispiel muss nicht mit jeder Nummer mitwandern.

### <a id="l-109.2"></a>L-109.2 — CHANGELOG-Abschnitt 7.2.1.129 sagt nicht, dass das Paket noch nicht geschnürt ist

**Gewicht: Kleinkram.** `CHANGELOG.md:104-106`

> *„## 7.2.1.129 — Testpaket: [E-139](../Intern/BEFUNDE.md#e-139), [E-140](../Intern/BEFUNDE.md#e-140), [E-171](../Intern/BEFUNDE.md#e-171) behoben; [E-136](../Intern/BEFUNDE.md#e-136) und
> [E-165](../Intern/BEFUNDE.md#e-165) zum Nachmessen“* — *„Nummer am 31.10.2026 vergeben (Gregor: …).
> Testschritte je Behebung: [TESTPLAN](…).“*

`Releases/PAKETE.md:184` sagt *„Nur übersetzt am 31.10.2026, noch nicht
geschnürt“*, `Intern/TESTPLAN.md:1` *„nur übersetzt, Schnüren folgt“*
(gemessen). Der CHANGELOG ist die Stelle, auf die alle anderen für die
Fassungsgeschichte verweisen; ein Abschnitt mit Nummer und „Testpaket“
liest sich dort wie ein ausgeliefertes Paket. Eine Überbehauptung ist es
nicht — „geschnürt“ oder „ausgeliefert“ steht nicht da (gemessen).

**Vorschlag:** in Zeile 106 ergänzen *„Nur übersetzt, noch nicht
geschnürt ([PAKETE](Releases/PAKETE.md))“* und beim Schnüren durch Datum
und Ablageort ersetzen — wie es PAKETE schon tut.

## Werkzeuge

`perl tools/doku-pruefen.pl` (Exit 0):

```
  Quellstand                   7.2.1.129
  Paketnummer                  7.2.1.129
  Kriterien in ZIEL.md         9
  gepruefte Dateien            50
  Kennungen im Verzeichnis     164
  Abschnitte in Intern/BEFUNDE.md 14
  Kein Widerspruch gefunden.
```

„Zur Kenntnis“ nennt 22 Dateien ohne die Fassung 7.2.1.129, darunter
`Doku/FAQ.md`, `README.md` und `ZIEL.md` (höchste genannte Fassung jeweils
7.2.1.128). Das ist richtig so, solange 7.2.1.129 nicht geschnürt ist; die
Doku schreibt dort „kommt mit dem nächsten Paket“.

`perl tools/offene-befunde.pl`:

```
    offen laut Intern/BEFUNDE.md  42
      davon aktuell gemessen       5  (ab Nummer 124)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          11
    in Intern/WEITERMACHEN.md     42

  42 offene Befunde, in beiden Listen gleich.
```

Die Grenze für „aktuell gemessen“ ist von *„ab Nummer 123“*
([LEKTOR-108](LEKTOR-108.md#lektor-108)) auf *„ab Nummer 124“* gewandert —
das Werkzeug leitet sie aus der neuen Nummer ab; die Zahl 5 blieb gleich
(gemessen).

## Was nur Gregor entscheiden kann

Nichts Neues.
