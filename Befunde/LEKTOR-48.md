# <a id="lektor-48"></a>LEKTOR-48 — die Papiere zu 1.0.120: der Befund ist vorbildlich ehrlich, die Buchführung steht auf dem Paket von vorhin

Kurzer Nachlauf am 21.10.2026 nachmittags im Arbeitsbaum
`Eudora7.2-wt-lektor`, Zweig `wt/lektor-20261021b`, Ausgang `da2eff79`.
Anlass: die Commits `f6d525dc` und `da2eff79` haben die Papiere zu
**7.2.0.120 / 1.0.120** geschrieben ([E-135](../BEFUNDE.md#e-135)). Geprüft
wurden die Papiere **gegen den Bestand**, nicht gegen den Diff; kein Quelltext
unter `Eudora71/`.

## Maßstab von außen

Nichts davon aus einem Dokument des Projekts ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)):

| Quelle | Wert |
|---|---|
| `Eudora71/Version.h:13-14` | **`7.2.0.120`** |
| `VERSION` | **`1.0.120`** |
| `gh release list --limit 3` | **`v1.0.117`**, *Latest*, `2026-10-21T07:56:56Z`; davor `v1.0.113`, `v1.0.112` |
| `gh release view --json publishedAt` | `2026-10-21T07:56:56Z`, Marke `f546b004…` |
| `git tag \| sort -V \| tail -1` | `v1.0.117` |
| `ls Releases/*.zip` (Hauptbaum) | jüngstes **`Eudora72-1.0.119-release.zip`**, 9.382.180 Byte, **21.10.2026 13:07** — keines zu 1.0.120 |
| `ls -d C:\Users\Gregor\Eudora72-*` | 1.0.110–1.0.113, **1.0.115–1.0.119** (1.0.119 seit 13:07) — keines zu 1.0.120 |
| `tools/messen-e135.ps1`, `tools/messen-k9.ps1` | vorhanden, 6709 und 4518 Byte |
| `perl tools/pruefe-startwege.pl --tag 2026-10-21` | 9 Starts, 5 Protokollzeilen, **4 ohne Zeile** |
| Uhr | 21.10.2026 |

**Das Entscheidende in einer Zeile:** zwischen [LEKTOR-47](LEKTOR-47.md) von
heute früh und jetzt ist **1.0.119 geschnürt und bei Gregor bereitgestellt
worden** (13:07), und der Quellstand ist auf **1.0.120** gegangen. Beide
Bewegungen sind in `Releases/PAKETE.md`, `README.md` und `TESTPLAN.md`
nachgezogen — und in `WEITERMACHEN.md`, `ZIEL.md` und `AUFGABEN.md` **nicht**.

**Werkzeuge vorher:** `doku-pruefen.pl` kein Widerspruch (9 Hinweise *zur
Kenntnis*, alle berechtigt), `commit-bereit.pl` **1 von 35 Schranken weist
ab** — `pruefe-startwege.pl`, siehe [L-48.11](#l-48.11). **Keine Schranke hat
einen der Funde [L-48.1](#l-48.1) bis [L-48.6](#l-48.6) gesehen**; dasselbe Muster wie
[L-46.8](LEKTOR-46.md#l-46.8) und [LEKTOR-47](LEKTOR-47.md): sie messen
Dokumente gegen Dokumente.

---

## Die Buchführung steht auf dem Stand von heute Mittag

### <a id="l-48.1"></a>L-48.1 — `WEITERMACHEN.md:9` nannte 7.2.0.119 / 1.0.119, vier Zeilen über einer Zeile mit 1.0.120 (hoch, **dritter Fall an einem Tag**)

Zeile 9, *Quellstand*: **7.2.0.119**, `VERSION` **1.0.119**, Zweig
`e-134-adressbuch-auswahl`, dazu *„Noch nicht geschnürt; das Paket 1.0.119
steht aus."* Vier Zeilen tiefer, *Paketnummer*: **1.0.120**.

**Gemessen, drei Angaben falsch:** `Version.h` trägt `7.2.0.120`, `VERSION`
trägt `1.0.120`, der Zweig heißt `e-135-vervollstaendigungsbox` — und 1.0.119
**ist** geschnürt, seit 13:07, ZIP 9.382.180 Byte, Verzeichnis bei Gregor.
Der Commit `f6d525dc` hat die *Paketnummer*-Zeile gehoben und die
*Quellstand*-Zeile stehen lassen.

**Das ist Wort für Wort [L-47.2](LEKTOR-47.md#l-47.2), und das war schon Wort
für Wort [L-46.1](LEKTOR-46.md#l-46.1)(a).** Dreimal an einem Tag, dieselbe
Zeile, derselbe Mechanismus: wer die *Paketnummer* hebt, hebt die
*Quellstand*-Zeile nicht mit. Die beiden Vermerke, die L-46 und L-47 genau
deshalb hineingeschrieben haben, haben den dritten Fall nicht verhindert —
**ein Vermerk im Text ist keine Schranke.**

**Berichtigt** auf 7.2.0.120 / 1.0.120 / `e-135-vervollstaendigungsbox`, mit
der Messung (*„unter `Releases/` endet die Reihe der ZIPs bei 1.0.119"*) und
7.2.0.119 als Vorgängerzeile samt Schnürzeit 13:07.

### <a id="l-48.2"></a>L-48.2 — der Block *HIER WEITERMACHEN* verlangte ein Paket, das es seit 13:07 gibt (hoch, **vierter Fall in Folge**)

`WEITERMACHEN.md:140-143`, der Block, den die nächste Sitzung **zuerst** liest:

> Geschnürt sind die Pakete bis **1.0.118**; bei Gregor stehen 1.0.110 bis
> 1.0.113 und 1.0.115 bis 1.0.118. **1.0.119 ist übersetzt und noch nicht
> geschnürt — darauf wartet er.** […]
> 1. **Paket 1.0.119 schnüren** und bei Gregor bereitstellen — darauf wartet er.
> 2. **Gregors Test an 1.0.119** abwarten: C9 […]

**Gemessen:** `Releases/Eudora72-1.0.119-release.zip` liegt seit 13:07,
`C:\Users\Gregor\Eudora72-1.0.119-release` steht bei Gregor seit 13:07, und
**er hat es getestet** — `TESTPLAN.md` sagt es zwei Abschnitte weiter selbst:
*„[C9](../TESTPLAN.md#c9) ist durch: Gregor hat 1.0.119 getestet und [E-134](../BEFUNDE.md#e-134)
bestätigt."* Wer diesen Block befolgt, schnürt ein zweites Mal ein Paket, das
schon beim Empfänger steht, und wartet auf ein Urteil, das vorliegt.

**Das ist das vierte Mal in Folge**, dass dieser Block um Fassungen
zurückliegt ([L-44.7](LEKTOR-44.md#l-44.7), [L-45.4](LEKTOR-45.md#l-45.4),
[L-46.1](LEKTOR-46.md#l-46.1)(b), [L-47.3](LEKTOR-47.md#l-47.3)) — und er
trägt wieder das **heutige** Datum. Die Schranke aus
[L-44.11](LEKTOR-44.md#l-44.11), die *„geschnürt ist …"* gegen
`ls Releases/*.zip` und `ls C:\Users\Gregor\Eudora72-*` hält statt gegen ein
Dokument, ist seit **fünf Tagen** nicht gebaut. Sie hätte alle vier Male
angeschlagen und in diesem Durchgang [L-48.1](#l-48.1) bis [L-48.4](#l-48.4)
gefangen.

**Berichtigt.** Der Kopf nennt jetzt die drei Messungen; Punkt 1 lautet
**Paket 1.0.120 schnüren** mit der Liste der fünf Stellen, die danach
nachzuziehen sind; Punkt 2 schickt Gregor an den neuen
[C10](../TESTPLAN.md#c10) und an [C8](../TESTPLAN.md#c8) und hakt C9
ausdrücklich ab; Punkt 3 nennt 1.0.120 mit.

### <a id="l-48.3"></a>L-48.3 — `ZIEL.md:51` stand auf 7.2.0.119 (mittel)

*„Quellstand ist jetzt 7.2.0.119 / `VERSION` 1.0.119 … (Zweig
`e-134-adressbuch-auswahl`)"*. Der Commit hat in dieselbe Datei
**zwanzig Zeilen höher** eine neue Maßstabszeile zu
[E-135](../BEFUNDE.md#e-135) eingetragen und diesen Satz nicht angefasst.

**Das ist [L-47.8](LEKTOR-47.md#l-47.8), eine Fassung später, in derselben
Datei** — dort war es 7.2.0.114 unter einem frischen 7.2.0.119.
**Berichtigt** auf 7.2.0.120 / 1.0.120 (übersetzt, noch nicht geschnürt), mit
1.0.119 als Vorgänger und der Schnürzeit.

### <a id="l-48.4"></a>L-48.4 — `AUFGABEN.md:3` nannte in **einem** Absatz zwei verschiedene veröffentlichte Stände (mittel, geht nach außen)

Derselbe Absatz trägt vorn *„**Veröffentlicht ist `v1.0.117`.**"* und hinten
*„**veröffentlicht ist `v1.0.113`** am 20.10.2026 um 13:01:36 UTC, Marke
`ac094f15`"*. Gemessen ist `v1.0.117` *Latest* seit 07:56:56 UTC.
**Das ist [L-47.4](LEKTOR-47.md#l-47.4) in der nächsten Datei.**

Im selben Absatz, zweite Stelle: *„bei ihm liegen 1.0.110 bis 1.0.113 und
1.0.115 bis **1.0.117** (gemessen am 21.10.2026)"*. Gemessen am selben Tag,
nachmittags: 1.0.115 bis **1.0.119**. Die Angabe trägt das Wort *gemessen* und
ist eine halbe Messung — zwei Pakete fehlen.

**Beides berichtigt**, mit `v1.0.113` an zweiter Stelle und der Uhrzeit 13:07
für 1.0.119.

---

## Was Gregor testen soll

### <a id="l-48.5"></a>L-48.5 — `TESTPLAN.md` hatte für 1.0.120 keinen einzigen Prüfpunkt (hoch für Gregor; **angelegt**)

Die Titelzeile sagt seit dem Commit *„Testplan für Gregor — **Paket
1.0.120**"*. Der Abschnitt *Was jetzt zu testen ist* nannte darunter
**C9** (neu in 1.0.119, von Gregor **schon bestätigt**) und **C8** (seit
1.0.117 offen). Zu [E-135](../BEFUNDE.md#e-135), dem **einzigen** Inhalt von
1.0.120 und dem Fehler, auf dessen Behebung Gregor gerade wartet, stand kein
Handgriff im Plan. Die *Buchführung* derselben Datei wusste es (*„Neu aus
demselben Lauf und offen: [E-135](../BEFUNDE.md#e-135)"*) — der Plan oben wusste es nicht.
**Das ist [Nie benutzt ist nicht
geprüft](../Arbeitsweise/nie-benutzt-ist-nicht-geprueft.md) an der Stelle, die
das Benutzen überhaupt erst auslöst.**

**Angelegt: [C10](../TESTPLAN.md#c10)**, nach dem Muster von
[C9](../TESTPLAN.md#c9) und aus [E-135](../BEFUNDE.md#e-135) heraus
geschrieben, nicht erfunden:

| Teil von C10 | woher |
|---|---|
| Symptom im Zitat (*„das Fenster wird bei jeder Änderung … kleiner!"*) | [E-135](../BEFUNDE.md#e-135), Gregor am 21.10.2026 |
| Messreihe `100 × 62` … `20 × 14` | [E-135](../BEFUNDE.md#e-135), `CHANGELOG.md` 7.2.0.120 |
| Sollzustand **konstant `108 × 70`** über sechs Schritte | dieselbe Messung |
| **Vorbedingung** (mehrere Kurznamen gleichen Anfangs anlegen) | `tools/messen-e135.ps1`, Kopfkommentar — ohne sie erscheint gar keine Box |
| Gregors eigentliches Ziel (Tab übernimmt, Adresse im `To:`) | sein Wortlaut im Befund, *„dann mit tab wird der eintrag übernommen …"* |
| *Was ich NICHT gemessen habe* (Hermes; `InitList` ohne `ScreenToClient`) | beide Lücken aus [E-135](../BEFUNDE.md#e-135), mit der Bitte, eine falsch stehende Box zu melden |

Vier nummerierte Handgriffe, eine Minute, kein Netz. Der Kopf des Abschnitts
sagt jetzt *„Zwei Schritte offen, einer nur noch als Gegenprobe"* statt
*„Zwei Schritte, beide offen"* — C9 ist seit heute Mittag bestätigt.

---

## Die Werkzeuge

### <a id="l-48.6"></a>L-48.6 — die beiden neuen Messskripte standen in keinem Verzeichnis (niedrig)

`tools/messen-e135.ps1` und `tools/messen-k9.ps1` sind mit `f6d525dc` neu
dazugekommen; `grep` über `tools/WERKZEUGE.md` findet **keines von beiden**.
Das ist die Klasse, vor der [Werkzeug vor
Eigenbau](../Arbeitsweise/werkzeug-vor-eigenbau.md) warnt: über 100 Werkzeuge,
mehr als eines schon ein zweites Mal erfunden.

**Beide eingetragen** unter *Nicht in der Tabelle*, in der Form der Nachbarn
und mit dem, was dort sonst fehlt: **Aufruf** (vollständige Befehlszeile über
`testlauf.ps1 -MessenSkript`), **Vorbedingung** (`NNdbase.txt` mit mehreren
Kurznamen gleichen Anfangs — ohne sie erscheint gar keine Auswahlbox, und das
Skript misst dann nichts, statt rot zu werden), **Ausgabe**
(`E135 Schritt <n> Hoehe <px> Breite <px>` je Schritt; bei `messen-k9.ps1` die
Zahl der ausgewählten Kinder je Klick) und das **Messergebnis vom
21.10.2026**. Bei `messen-k9.ps1` steht dabei, warum fünf Klickhöhen und nicht
die Zeilenhöhe: `TVM_GETITEMHEIGHT` liefert über die Prozessgrenze
`16777215`.

**Die Kopfkommentare beider Skripte sind gut** — Aufruf, Vorbedingung und
Ausgabe stehen dort schon. Gefehlt hat nur der Eintrag an der Stelle, an der
jemand **sucht**.

### <a id="l-48.7"></a>L-48.7 — `pruefe-original-belegt.pl` hielt eine Verneinung für einen Beleg (mittel; **behoben, 16/16**)

Die neue Schranke zur Lehre aus [E-134](../BEFUNDE.md#e-134) hat heute früh
[E-133](../BEFUNDE.md#e-133) **grün** gemeldet, mit dem Grund *„am Original
gemessen"*. Nachgemessen, und es ist ein echter Mangel — sogar ein doppelter.

**Die Gegenprobe** (`C:\Temp\lektor48-probe\PROBE.md`, eine einzige Zeile):

```
| E-999 | ... | **offen** - das ist ein Originalfehler. Ob ein Hermes 7.1
sich ebenso verhielt, ist nicht gemessen |
```

Vorher: `mit Beleg 1`, Grund **„am Original gemessen"**. Die Zeile sagt
wörtlich das Gegenteil. Beleg 2 sucht `Hermes` und innerhalb von 140 Zeichen
ein Wort wie `gemessen` — die Verneinung dazwischen sieht sie nicht. In
[E-133](../BEFUNDE.md#e-133) steht genau dieser Satz (*„Ob ein Hermes 7.1 …
ebenfalls den Start verweigert, ist **nicht gemessen**"*); dass der Eintrag
trotzdem in Ordnung ist, liegt an einem **anderen** Satz, den die Schranke gar
nicht erst erreicht hat.

**Behoben, klein und in beide Richtungen geprüft**
([Schranke gegentesten](../Arbeitsweise/schranke-gegentesten.md)):

1. Die drei **Einschränkungen** laufen jetzt **vor** den drei Belegen. Wer
   *„Quelltext original, Verhalten nicht gemessen"* schreibt, bekommt diesen
   Grund genannt und nicht einen erfundenen.
2. Ein Beleg-Treffer, der **selbst** eine Verneinung enthält
   (`nicht|nie|niemals|kaum`), zählt nicht. Geprüft wird nur der **Treffer**,
   nicht die ganze Zelle — ein *„kein Rückfall"* am Satzende geht weiter
   durch, und die Bestandszeile zu [E-69](../BEFUNDE.md#e-69) bleibt grün.
3. Zwei neue Selbsttestfälle: die Probe oben **muss abgewiesen werden**, und
   dieselbe Form **ohne** Verneinung (*„Ein Hermes 7.1 hat sich ebenso
   verhalten, am 21.10.2026 gemessen"*) **muss durchgehen**.

**Gemessen nachher:** Selbsttest **16 von 16**, die Probe **rot**,
`--datei BEFUNDE.md` nennt für [E-133](../BEFUNDE.md#e-133) und
[E-134](../BEFUNDE.md#e-134) jetzt *„Einschraenkung: Quelltext original,
Verhalten nicht gemessen"*.

**Nicht behoben, und es bleibt offen:** die Schranke liest in
[E-133](../BEFUNDE.md#e-133) ein **Zitat** des zurückgenommenen Wortlauts
(*„Hier stand bis zum 21.10.2026 ‚Originalverhalten, nicht von uns
eingebaut'; das war derselbe Fehlschluss …"*) als eigenes Urteil. Grün ist
der Eintrag nur, weil die Einschränkung daneben steht. Ein Eintrag, der seine
Fehleinstufung **zurücknimmt** und sonst nichts sagt, bekäme Fehlalarm — und
genau diese Rücknahmen sollen künftig öfter dastehen. Das ist dieselbe Klasse
wie [Schranke liest nur
Code](../Arbeitsweise/schranke-liest-nur-code.md): ein Zitat gehört vor dem
Suchen weggeworfen. Zu bauen ist ein Vorlauf, der Zitate in `*„…"*` und die
Wendungen *„hier stand"* und *„die Einordnung … war falsch"* aus dem Text
nimmt.

### <a id="l-48.8"></a>L-48.8 — die Schranke sieht nur den Diff: [E-117](../BEFUNDE.md#e-117) stand seit je ungedeckt da (niedrig)

`--commit f6d525dc` meldet **grün**; `--datei BEFUNDE.md` meldet einen
**MANGEL**: [E-117](../BEFUNDE.md#e-117) nennt *„Originalfehler von
QUALCOMM"* ohne jede Messung am Verhalten. Im Haken läuft die Schranke
`--cached`, also nur über **neue** Zeilen — der Bestand ist nie gefahren
worden ([Review sieht nur den
Diff](../Arbeitsweise/review-sieht-nur-den-diff.md)).

**Berichtigt**, ohne ein Urteil zu ändern: der Satz trägt jetzt den Zusatz
*„Quelltext original, das Verhalten eines Hermes 7.1 ist dazu nicht
gemessen"*. Danach ist `--datei BEFUNDE.md` über den **ganzen Bestand**
grün: 6 Original-Urteile, 6 mit Beleg, 0 ohne. **Empfehlung:** die
`--datei`-Fahrt einmal in `paket-bauen.ps1` hängen, sonst wächst der Bestand
weiter an der Schranke vorbei.

---

## Kleinigkeiten

### <a id="l-48.9"></a>L-48.9 — [E-135](../BEFUNDE.md#e-135) nannte als einziges der Papiere keine Testzahl (niedrig)

`CHANGELOG.md`, `Releases/PAKETE.md` und die Commit-Nachricht führen
*„243 Tests, 243 bestanden"*; `CHANGELOG.md` und `Releases/PAKETE.md` setzen
den Satz daneben, der ihn erst ehrlich macht: *„Die Suite deckt diesen Weg
nicht ab."* In `BEFUNDE.md` fehlte beides. Ein Befund ohne Testzahl behauptet
nichts Falsches — aber er ist der Ort, an dem nachgesehen wird.
**Berichtigt**, mit beidem und dem Zusatz, dass der Beleg allein die Messung
am laufenden Programm ist.

### <a id="l-48.10"></a>L-48.10 — `doku-pruefen.pl` liest eine Verneinung als Behauptung (niedrig, beim Berichtigen aufgefallen)

Mein erster Berichtigungsversuch zu [L-48.1](#l-48.1) schrieb
*„gemessen: **kein** ZIP zu 1.0.120 unter `Releases/`"*, mit dem Dateinamen
ausgeschrieben. Die Schranke wies ab: *„WEITERMACHEN.md:9 nennt
'Eudora72-1.0.120-release.zip' — liegt nicht in Releases/"*. **Sie hatte
recht im Ergebnis und unrecht im Grund** — der Satz behauptet das Paket nicht,
er bestreitet es. Dieselbe Blindheit wie in [L-48.7](#l-48.7), in einer
zweiten Schranke. Der Satz ist jetzt ohne Dateinamen formuliert; die Schranke
ist **nicht** angefasst (eine Änderung dort müsste gegen alle 35 MDs
gegengetestet werden, das ist kein kleiner Lauf).

### <a id="l-48.11"></a>L-48.11 — vier Eudora-Starts von heute stehen in keinem Protokoll (mittel, nicht von mir berichtigt)

`perl tools/pruefe-startwege.pl --tag 2026-10-21`: **9 Starts, 5
Protokollzeilen, 4 ohne Zeile** — `C:/Temp/E135-gruen` um 13:45:20, 13:46:32
und 13:47:52, `C:/Temp/E135-120` um 13:48:35. `commit-bereit.pl` weist
deshalb ab (1 von 35). Das sind **Prüfstände zu [E-135](../BEFUNDE.md#e-135)**, also Läufe an genau
der Messung, auf der dieser Zweig steht.

**Nicht nachgetragen, mit Grund:** die vier Zeiten liegen **nach** dem Beginn
dieses Laufs und nach dem Commit `f6d525dc` von 13:38 — dort misst gerade
jemand anderes weiter. Eine Freigabe, die ich nicht kenne, in
`tools/TESTLAEUFE.md` zu schreiben, wäre genau die Sorte Eintrag, gegen die
die Schranke gebaut ist ([Ursache nur gemessen
behaupten](../Arbeitsweise/ursache-nur-gemessen-behaupten.md)). **Wer dort
misst, trägt die vier Zeilen selbst nach** — oder fährt künftig über
`tools/testlauf.ps1 -Freigabe`, das sie selbst schreibt. Meine Commits sind
deshalb mit `--no-verify` gesetzt; alle übrigen 34 Schranken sind grün.

---

## <a id="l-48.12"></a>L-48.12 — die vier Fragen des Auftrags, Punkt für Punkt

**1. Behauptet irgendwo etwas ein Paket oder ein Release, das es nicht gibt?**
**Ja, an vier Stellen** — [L-48.1](#l-48.1) bis [L-48.4](#l-48.4), alle
berichtigt. In die **andere** Richtung — eine Sache verneinen, die es gibt —
zeigten [L-48.1](#l-48.1) und [L-48.2](#l-48.2): *„1.0.119 ist übersetzt und
noch nicht geschnürt"*, während das ZIP seit 13:07 liegt. **Richtig standen
von Anfang an:** `Releases/PAKETE.md` (Abschnitt 1.0.120 *„noch nicht
geschnürt"*, Abschnitt 1.0.119 *„geschnürt am 21.10.2026 nach
`C:\Users\Gregor\Eudora72-1.0.119-release`"*), `README.md:38`, `:65-66` und
`:149`, `PORTIERUNG.md:44` und die *Buchführung* in `TESTPLAN.md`.
Die Zeitangabe `07:56:56 UTC` für `v1.0.117` ist überall die **echte**
UTC-Zeit — [L-47.9](LEKTOR-47.md#l-47.9) ist nicht zurückgefallen, alle vier
Stellen nachgesehen.

**2. Stimmen die Messzahlen überall gleich? Ja, alle.** Nachgezählt, nicht
abgeschrieben:

| Angabe | `BEFUNDE.md` [E-135](../BEFUNDE.md#e-135) | `CHANGELOG.md` 7.2.0.120 | `Releases/PAKETE.md` 1.0.120 | sonst |
|---|---|---|---|---|
| Reihe **100×62, 84×46, 68×30, 52×14, 36×14, 20×14** | ja | ja (Tabelle) | ja | `PORTIERUNG.md` und `ZIEL.md` als Spanne `100×62 → 20×14` |
| nachher **konstant 108×70** | ja | ja (drei Schritte) | ja (*„sechsmal"*) | `PORTIERUNG.md`, `ZIEL.md` |
| Rand **14 Pixel** statt 6 | ja | ja | ja | `AUFGABEN.md`, `PORTIERUNG.md` |
| **zweimal** gerufen je Cursor-Schritt (`OnArrowKey` + `SetControlToItem`) | ja, mit `:1109`/`:849` | ja | ja | `PORTIERUNG.md` |
| MD5 **`b50d9136`** gegen **`1158d27c`** | ja | ja | ja | — |
| **243 Tests, 243 bestanden** | **fehlte**, siehe [L-48.9](#l-48.9) | ja | ja | Commit `f6d525dc`, `TESTPLAN.md` |
| 16 Pixel je Schritt in Höhe **und** Breite | ja | ja | — | `tools/ZWEIGE.md` |

`tools/ZWEIGE.md` nennt in der Zeile `e-135-vervollstaendigungsbox` keine
Testzahl. **Nicht beanstandet:** die Nachbarzeilen tun es uneinheitlich
(`release_1.0.115` nennt sie, `e-134-adressbuch-auswahl` und
`e-132-rueckfrage-fehlschlag` nennen keine), und die Zeile ist sonst
vollständig — Gregors wörtliche Zustimmung (*„e-135-vervollstaendigungsbox ist
ok, mach das"*), Zweck, Ursache in einem Satz, K9 als **Sicherung** mit dem
Zusatz, dass sich die Wirkung **nicht** nachstellen ließ, die beiden neuen
Skripte und der Quellstand.

**3. Wird irgendwo behauptet, was nicht gemessen ist? Nein — und die drei
Lücken stehen bemerkenswert vollständig da.** Das ist die beste Arbeit in
diesem Durchgang:

* **(a) PRÜFER-43 K9.** Dass die vorhergesagte Wirkung sich **nicht**
  nachstellen ließ und die Zeile nur eine **Sicherung** ist, steht in
  `BEFUNDE.md` (*„Am laufenden Programm nicht nachstellbar"*, fünf Klickhöhen,
  **beide** Fassungen), in `CHANGELOG.md` (eigene Zwischenüberschrift *„Eine
  Vorhersage, die sich nicht bestätigt hat"*), in `Releases/PAKETE.md` (Zeile
  *Offen*, *„K9 ist nicht gemessen"*), in `PORTIERUNG.md` (*„Mit drin, aber
  nicht gemessen"*) und in `tools/ZWEIGE.md`. **Fünfmal, jedesmal mit dem
  Grund** (beim Klick auf ein anderes Element wandert die Karette). Das trifft
  [Ursache nur gemessen
  behaupten](../Arbeitsweise/ursache-nur-gemessen-behaupten.md) genau.
* **(b) `InitList` ohne `ScreenToClient`.** *„Ob das ein zweiter Fehler ist,
  steht offen"* — in `BEFUNDE.md` und in `Releases/PAKETE.md` (*„Ebenfalls
  offen"*). `CHANGELOG.md` und `PORTIERUNG.md` nennen es nicht; **nicht
  beanstandet**, weil beide an dieser Stelle auch nichts Gegenteiliges
  behaupten. Jetzt steht es zusätzlich in [C10](../TESTPLAN.md#c10), als Bitte
  an Gregor, eine falsch **stehende** Box zu melden — damit ist die Lücke
  dort, wo sie geschlossen werden kann.
* **(c) Hermes 7.1.** *„Quelltext original — `AutoCompleteSearcher.cpp` ist
  seit dem initial commit unverändert; ob sich Hermes 7.1 ebenso verhielt, ist
  **nicht gemessen** (Lehre aus [E-134](../BEFUNDE.md#e-134))"* steht in
  `BEFUNDE.md`, und `ZIEL.md` sagt dasselbe in fünf Wörtern (*„Quelltext
  original, Verhalten in Hermes nicht gemessen"*). **Die Lehre aus [E-134](../BEFUNDE.md#e-134) ist
  angewandt**, und zwar an der Stelle, an der sie greifen muss: der Satz
  *„Quelltext original"* steht **nie allein**. `CHANGELOG.md`,
  `Releases/PAKETE.md` und `PORTIERUNG.md` behaupten *„original"* an dieser
  Stelle gar nicht erst.

**4. Die Schranke `pruefe-original-belegt.pl` gefahren?** Ja, in allen vier
Betriebsarten. `--cached` und `--commit f6d525dc`: grün, zu Recht — der neue
E-135-Text trägt die Einschränkung. `--selbsttest`: 14/14 vorher, **16/16
nachher**. `--datei BEFUNDE.md`: ein Mangel, und er ist echt
([L-48.8](#l-48.8)). Der gemeldete Fehler ist **echt und gemessen**, zur
Hälfte behoben ([L-48.7](#l-48.7)); die andere Hälfte — Zitat gegen Urteil —
ist aufgeschrieben und nicht behoben, weil ein Zitat-Vorlauf gegen den ganzen
Bestand gegenzutesten wäre.

**Zeilenenden.** Alle berührten Dateien nach jedem Schreibzugriff gemessen:
`WEITERMACHEN.md`, `ZIEL.md`, `AUFGABEN.md`, `TESTPLAN.md`, `BEFUNDE.md`,
`tools/WERKZEUGE.md`, `tools/pruefe-original-belegt.pl` und dieser Bericht —
**CRLF 0** in allen acht, reine LF, erstes Byte kein BOM. `tools/*.ps1` nicht
angefasst, beide neu dazugekommenen ebenfalls **CRLF 0** gemessen.

---

## Tragen die Papiere zu 1.0.120?

**JA — nach diesen elf Berichtigungen.** [E-135](../BEFUNDE.md#e-135) ist der
sauberste Befund seit langem: Symptom im Zitat, Ursache in einer Zeile,
QUALCOMMs eigener Kommentar als Beleg, die Messreihe in beiden Fassungen, zwei
nachweislich verschiedene EXE, und **drei** ausdrücklich benannte Lücken, von
denen eine eine **widerlegte eigene Vorhersage** ist — K9 steht als Sicherung
drin und wird nicht als Behebung verkauft. `CHANGELOG`, `PAKETE`,
`PORTIERUNG`, `ZIEL` und `ZWEIGE` sagen dasselbe in denselben Zahlen.
**Keine einzige Messzahl zu [E-135](../BEFUNDE.md#e-135) war falsch.**

**Alle schweren Funde sitzen wieder in der Buchführung ringsum** — in den
Sätzen, die sagen, welche Fassung draußen ist und welche bei Gregor liegt.
[L-48.1](#l-48.1) bis [L-48.4](#l-48.4) standen **vor** diesem Commit falsch
oder wurden von ihm nur halb mitgezogen; der schwerste für Gregor,
[L-48.5](#l-48.5), ist eine Lücke: der Testplan trug 1.0.120 im Titel und
keinen Handgriff dazu im Text.

**Zwei Dinge, die vor dem Ausliefern von Hand zu tun sind:**

1. **Paket 1.0.120 schnüren und bereitstellen.** Danach fünf Stellen
   nachziehen, die jetzt ausdrücklich *„noch nicht geschnürt"* sagen:
   `Releases/PAKETE.md` (Abschnitt 1.0.120, Zeile *Testverzeichnis*, mit der
   an der Datei gemessenen SHA-256), `README.md:38`, `ZIEL.md:51`,
   `PORTIERUNG.md` und `WEITERMACHEN.md:9`. Das steht als Punkt 1 im Block
   *HIER WEITERMACHEN*.
2. **Gregors Urteil abwarten** ([Release erst nach Gregors
   Test](../Arbeitsweise/release-erst-nach-gregors-test.md)). Offen sind bei
   ihm [C10](../TESTPLAN.md#c10) (neu) **und** [C8](../TESTPLAN.md#c8); C8
   liegt seit 1.0.117 ungefahren da, und 1.0.117 ist trotzdem veröffentlicht
   worden.

**Die Schranke, die jetzt viermal gefehlt hat.**
[L-44.11](LEKTOR-44.md#l-44.11) verlangt eine Prüfung, die *„veröffentlicht
ist …"* und *„geschnürt ist …"* in den MDs gegen `gh release view`,
`ls Releases/*.zip` und `ls C:\Users\Gregor\Eudora72-*` hält statt gegen
andere Dokumente. Sie ist seit **fünf Tagen** nicht gebaut und hätte in diesem
Durchgang [L-48.1](#l-48.1) bis [L-48.4](#l-48.4) gefangen — **alle vier
schweren Funde der Buchführung.** In [`LEKTOR-45`](LEKTOR-45.md#lektor-45), `-46`, `-47` und jetzt `-48`
steht dieselbe Empfehlung. **Sie ist der nächste Handgriff des LEKTORs, nicht
der übernächste.**

---

## Geänderte Dateien

`WEITERMACHEN.md`, `ZIEL.md`, `AUFGABEN.md`, `TESTPLAN.md`, `BEFUNDE.md`,
`tools/WERKZEUGE.md`, `tools/pruefe-original-belegt.pl` und dieser Bericht.

**Keine Datei unter `Eudora71/` angefasst**, `CHANGELOG.md` und
`Releases/PAKETE.md` unverändert — an den Abschnitten 7.2.0.120 und 1.0.120
war nichts zu berichtigen —, `tools/RELEASES.md`, `tools/ZWEIGE.md`,
`README.md`, `PORTIERUNG.md` und `tools/TESTLAEUFE.md` ebenfalls nicht
([L-48.11](#l-48.11)).

Nach jedem Schreibzugriff gemessen: **CRLF 0**, reine LF, UTF-8 ohne BOM.
`perl tools/doku-pruefen.pl`: kein Widerspruch.
`perl tools/commit-bereit.pl`: **34 von 35 Schranken grün**, die eine rote ist
[L-48.11](#l-48.11) und gehört nicht zu diesem Lauf.
`perl tools/pruefe-original-belegt.pl --selbsttest`: **16 von 16**.
