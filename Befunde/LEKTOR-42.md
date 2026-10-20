# <a id="lektor-42"></a>LEKTOR-42 — Doku nach 7.2.0.107 bis 7.2.0.110 (E-101 dritter Teil, E-69 P3, R1–R4) und drei nie geschnürte Pakete

Lauf am 19.10.2026 auf Zweig `e-69-meldungsflut`, Stand `8d1075b0`. Anlass: seit
[LEKTOR-41](LEKTOR-41.md#lektor-41) (`fd890f3`) sind 7.2.0.107 ([E-101](../BEFUNDE.md#e-101), dritter Teil, dazu
[PRÜFER-37](PRUEFER-37.md)), 7.2.0.108 ([E-123](../BEFUNDE.md#e-123): P1/P2 aus [PRÜFER-36](PRUEFER-36.md)), 7.2.0.109
([E-69](../BEFUNDE.md#e-69): P3) und 7.2.0.110 (R1–R4 aus [PRÜFER-38](PRUEFER-38.md)) dazugekommen. **Drei
Paketnummern sind an einem Tag entstanden und wieder verworfen worden** —
1.0.107, 1.0.108 und 1.0.109 sind übersetzt, aber **nie geschnürt**.

**Auftrag diesmal: melden *und* berichtigen.**

## Umfang

`git ls-files "*.md"` = **233** verfolgte Dateien. Ohne `Arbeitsweise/` **136**,
davon **42** außerhalb von `Befunde/`.

* **Alle 233** maschinell durchsucht nach: `1\.0\.(107|108|109|110)`;
  [`E-123`](../BEFUNDE.md#e-123) zusammen mit *behoben / erledigt / geschlossen*;
  `(Quellstand|Stand|aktuell|derzeit|inzwischen|jetzt).{0,80}7\.2\.0\.(9x|10x)`;
  `Stand TT.MM.2026`; *zum Test bei Gregor / bei Gregor bereitgestellt /
  liegt bei Gregor*.
* **Die 42 außerhalb von `Befunde/`** zusätzlich auf Stand- und
  Release-Aussagen gelesen; ganz gelesen: `WEITERMACHEN.md` Kopftabelle und
  *Der nächste Schritt*, `CHANGELOG.md` *Noch offen* und die Abschnitte
  7.2.0.107 bis 7.2.0.110, `README.md` *Auf einen Blick* (`:36-82`),
  `ZIEL.md:14-47`, `TESTPLAN.md`, `Releases/PAKETE.md:1-310`,
  `PORTIERUNG.md:40-50`, `FILTER.md:1-6` und `:712-727`, `tools/ZWEIGE.md:95-113`,
  `tools/WERKZEUGE.md:1-6`, `LEKTORAT.md`.
* Dazu `Befunde/PRUEFER-37.md` und `Befunde/PRUEFER-38.md` ganz.

**Maßstab von außen** ([Einigkeit ist kein Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)):
`Eudora71/Version.h` = **7.2.0.110**, `VERSION` = **1.0.110**, *(Nachtrag 20.10.2026: inzwischen 7.2.0.112 / 1.0.112 — dieser Bericht ist ein Rückblick auf den Stand vom 19.10.)*
`git tag | sort -V | tail -1` = **`v1.0.101`**, der laufende Zweig =
`e-69-meldungsflut`, `git log --oneline fd890f3..HEAD` = 12 Commits,
`git diff --stat fd890f3..HEAD` = 31 Dateien.

**Werkzeuge vorher:** `doku-pruefen.pl` kein Widerspruch (7 Hinweise *zur
Kenntnis*), `offene-befunde.pl` 33/33, `pruefe-release-buchfuehrung.pl` grün,
`pruefe-befundurteile.pl` grün, `pruefe-bytes.pl` grün.
**Nachher:** alle fünf grün, `doku-pruefen.pl` nur noch **3** Hinweise *zur
Kenntnis* (bewertet in [L-42.11](#l-42.11)).

---

## Berichtigt

### <a id="l-42.1"></a>L-42.1 — der Quellstand stand an sechs Stellen auf 7.2.0.106 (hoch)

`Eudora71/Version.h` sagt **7.2.0.110**, `VERSION` **1.0.110**, der Zweig heißt
`e-69-meldungsflut`. Sechs Stellen behaupteten im **Präsens** etwas anderes:

| Stelle | stand dort | jetzt |
|---|---|---|
| `WEITERMACHEN.md:9`, Zeile *Quellstand* | *„7.2.0.106 (`Eudora71/Version.h`) auf Zweig `e-123-beenden-warten`“* | 7.2.0.110 auf `e-69-meldungsflut`, mit 7.2.0.109/108/107 als Vorgeschichte und dem Vermerk **nie geschnürt** |
| `WEITERMACHEN.md:3` | *„Stand 17.10.2026.“* | 19.10.2026 |
| `PORTIERUNG.md:44` | *„Stand 17.10.2026, Zweig `e-123-beenden-warten`: Quellstand 7.2.0.106, `VERSION` 1.0.106“* | neuer Block *Stand 19.10.2026* davor, der alte bleibt als Rückblick stehen |
| `README.md:38` | *„in Arbeit 7.2.0.106“* | *„in Arbeit 7.2.0.110 / Paket 1.0.110 (19.10.2026, nicht veröffentlicht)“* |
| `ZIEL.md:47` | *„Quellstand ist jetzt 7.2.0.106 / Paket 1.0.106 (Zweig `e-123-beenden-warten` …)“* | 7.2.0.110 / 1.0.110, mit der Regression und den drei nie geschnürten Nummern |
| `tools/WERKZEUGE.md:3` | *„der Quellstand ist inzwischen 7.2.0.106“* | 7.2.0.110; nachgemessen mit `git diff --stat fd890f3..HEAD -- tools/`: **seit 7.2.0.106 ist kein Werkzeug dazugekommen** |

Die Widersprüche standen teils **in derselben Tabelle**: `WEITERMACHEN.md:9`
sagte 7.2.0.106, drei Zeilen tiefer sagte `:12` 1.0.110. Keine Schranke hat das
gemeldet — `doku-pruefen.pl` prüft, ob ein Dokument die aktuelle Nummer
**kennt**, nicht, ob es daneben eine ältere als aktuell ausgibt (derselbe
Zuschnitt wie bei [L-41.2](LEKTOR-41.md#l-41.2), dort für *„veröffentlicht ist“*).

### <a id="l-42.2"></a>L-42.2 — der Block „HIER WEITERMACHEN“ stand bei 7.2.0.106 und PR #101 (hoch)

`WEITERMACHEN.md:130` ist der Block, der *„gilt vor allen Blöcken darunter“*.
Er nannte Zweig `e-123-beenden-warten`, Quellstand 7.2.0.106, *„PR #101 offen“*
und als nächsten Schritt einen Zweig, der inzwischen abgearbeitet ist.
**Jetzt:** ein neuer Block *Stand 19.10.2026* davor; der alte trägt
*„(überholt)“* wie die beiden darunter. Der neue nennt ausdrücklich, dass
1.0.107 bis 1.0.109 nie geschnürt wurden, dass [E-123](../BEFUNDE.md#e-123) offen bleibt und dass
die Regression ein Release sperrt.

### <a id="l-42.3"></a>L-42.3 — kein Dokument nannte das letzte Paket, das Gregor wirklich hat (hoch)

Die Kopftabelle von `WEITERMACHEN.md` sprang von **1.0.110** (`:12`) direkt auf
**1.0.101** (`:13`). Für **1.0.106** — das jüngste Paket, das tatsächlich bei
ihm liegt (`Releases/PAKETE.md:303`, bereitgestellt am 17.10.2026, nicht
getestet) — gab es keine Zeile, und für die drei verworfenen Nummern ebenso
wenig. Wer die Tabelle liest, konnte daraus schließen, 1.0.110 liege bei ihm.
**Zwei neue Zeilen eingesetzt:** *Pakete 1.0.107 bis 1.0.109 — nie geschnürt*
und *Paket 1.0.106 — bei Gregor, noch nicht getestet*.

### <a id="l-42.4"></a>L-42.4 — die bekannte Regression F3/F4 fehlte überall außer im CHANGELOG (hoch)

Ein Paket, das eine Regression trägt und es nicht sagt, ist eine Falle.
**Gemessen:** die Fundstellen lagen nur in `CHANGELOG.md` (Abschnitte 7.2.0.109
und 7.2.0.110), `Releases/PAKETE.md` (1.0.109, 1.0.110), `WEITERMACHEN.md:12`
und `Befunde/PRUEFER-37.md`. **Nicht genannt** war sie in `README.md`,
`TESTPLAN.md`, `ZIEL.md`, `AUFGABEN.md` und in der CHANGELOG-Zeile *Noch offen*
zu [E-101](../BEFUNDE.md#e-101).

Eingesetzt:

| Stelle | neu |
|---|---|
| `README.md:76`, Tabelle *Was passiert* | *„Ab 7.2.0.107 (noch nicht veröffentlicht) ist es für Post in `windows-1251`, `koi8-r` oder `iso-8859-2` **schlechter als in `v1.0.101`**“*, mit dem Hinweis, dass Latin-1 und UTF-8 nicht betroffen sind |
| `CHANGELOG.md:28`, *Noch offen*, [E-101](../BEFUNDE.md#e-101) | dritter Teil in 7.2.0.107 (nie geschnürt), F2 tot, F1 offen, **F4 Regression gegenüber 1.0.106** |
| `TESTPLAN.md`, neuer Abschnitt [C6](../TESTPLAN.md#c6) | *„bitte nicht als neuen Fehler melden“* samt der Angabe, welche Zeichensätze betroffen sind |
| `ZIEL.md:23`, Maßstabszeile [E-101](../BEFUNDE.md#e-101) | Stand ergänzt: F2 tot, F1 offen, F4 Regression |
| `AUFGABEN.md:3` | dieselbe Angabe im Kopf, mit *„kein Release, solange das offen ist“* |

### <a id="l-42.5"></a>L-42.5 — der Testplan nannte 1.0.110 im Kopf und gab Gregor keinen einzigen Handgriff dazu (hoch)

`TESTPLAN.md:1` sagte *„Stand 19.10.2026, Paket 1.0.110“* und im selben Satz
*„**Paket 1.0.106 ([E-69](../BEFUNDE.md#e-69) und [E-123](../BEFUNDE.md#e-123)) zum Test bei Gregor**“*. Einen Abschnitt zu
1.0.110 gab es nicht; die letzte Prüfanleitung im Plan ist **C5 zu 1.0.89**
(14.10.2026). Die Prüfschritte zu 1.0.110 standen allein in `CHANGELOG.md` und
`Releases/PAKETE.md` — also dort, wo Gregor sie nicht sucht.

**Eingesetzt:** Abschnitt **[C6 · Paket 1.0.110](../TESTPLAN.md#c6)** mit vier
Handgriffen und je einer Spalte *was richtig ist*: der Anlassfall zu [E-69](../BEFUNDE.md#e-69)
(IMAP-Postfach filtern bei nicht erreichbarem Server, **zwei** Einträge), die
Gegenprobe zu **R1** (*direkt danach, ohne Neustart* — kommt kein Eintrag, ist
R1 nicht behoben), der Beenden-Weg zu [E-123](../BEFUNDE.md#e-123) und der zweite *File → Exit*
(**R4**). Dazu der Satz, dass 1.0.107 bis 1.0.109 nicht existieren und dass
F1 (Nachricht mit Anhang speichern) **nicht** getestet werden darf.
Der Kopf `:1` nennt jetzt 1.0.110 mit Verweis auf C6 und führt 1.0.106 als
*„bei Gregor, nicht getestet“*.

### <a id="l-42.6"></a>L-42.6 — E-123: die Prüfpunkte wurden mehrfach wie der Befund gelesen (hoch)

P1, P2 (PRÜFER-36) und R4 (PRÜFER-38) sind Prüfpunkte **am Beenden-Weg**.
[E-123](../BEFUNDE.md#e-123) selbst — eingebettete Bilder fehlen nach einem Abbruch mitten in der
Übertragung — **bleibt offen** (`BEFUNDE.md:290`).

* **An meiner eigenen Fassung gefangen:** mein erster Entwurf von
  `WEITERMACHEN.md:9` trug *„Bekannte Regression, nicht behoben“* in derselben
  **Tabellenzeile** wie [E-123](../BEFUNDE.md#e-123). `pruefe-befundurteile.pl` wertet in einer
  Tabellenzeile die **ganze Zeile** als Umfeld und meldete:
  *„WEITERMACHEN.md:9 nennt [E-123](../BEFUNDE.md#e-123) als 'behoben' – BEFUNDE.md fuehrt ihn
  OFFEN“*. Zu Recht. Umformuliert auf *„weiter offen“*, dazu steht jetzt
  ausdrücklich *„[E-123](../BEFUNDE.md#e-123) bleibt **offen** – abgearbeitet sind nur die
  Prüfpunkte am Beenden-Weg“* in derselben Zeile.
* `Releases/PAKETE.md`, Abschnitt 1.0.110, beschrieb P1/P2/R4 ohne ein Wort
  dazu, dass der Befund offen bleibt. **Absatz ergänzt.**
* `CHANGELOG.md:20`, *Noch offen*, endete bei 7.2.0.104 und bei *„höchstens
  5 Minuten“*. Das ist seit 7.2.0.108 **sachlich falsch herum**: nach fünf
  Minuten wird nicht mehr erzwungen beendet, sondern das Beenden **aufgegeben**.
  Ergänzt um 7.2.0.108/7.2.0.110 und den Satz, dass es Prüfpunkte sind.
* `README.md:79` sagte *„Ab 7.2.0.104 … wartet Eudora … höchstens 5 Minuten“*.
  Dieselbe Umkehrung eingesetzt.
* `AUFGABEN.md:3` und `ZIEL.md:47`: *„der Befund selbst bleibt offen“* ergänzt.

**Kein Dokument behauptete „[E-123](../BEFUNDE.md#e-123) behoben“** — gesucht über alle 233 MDs in
beiden Richtungen (Kennung vor dem Urteilswort und dahinter). Die Treffer
liegen alle in `Befunde/` und in `LEKTORAT.md`, und alle beschreiben genau
diesen Fehler als vergangenen.

### <a id="l-42.7"></a>L-42.7 — E-69: vier Stellen endeten bei 7.2.0.106 (mittel)

Der Stand ist: ab 7.2.0.106 ein Eintrag in *Task Errors*, **ab 7.2.0.109/110**
nur noch der erste Fall eines Laufs einzeln, der Rest als ein Sammeleintrag,
und höchstens ein Piepton je zwei Sekunden.

| Stelle | stand dort | jetzt |
|---|---|---|
| `CHANGELOG.md:45`, *Noch offen* | *„die drei Abbruchstellen protokollieren jetzt … ab 7.2.0.106 Eintrag in Task Errors“* | dazu 7.2.0.109/110, [PRÜFER-38](PRUEFER-38.md) R1–R3, *„von Gregor noch nicht bestätigt“*. (Es sind **fünf** Stellen, nicht drei — `CHANGELOG.md`, Abschnitt 7.2.0.106; „drei“ war der Stand davor.) |
| `README.md:75` | endete bei 7.2.0.106 | dazu Sammeleintrag und Zwei-Sekunden-Grenze ab 7.2.0.110 |
| `FILTER.md:722` | endete bei 7.2.0.106 | dasselbe, mit Verweis auf PRÜFER-36 P3 und PRÜFER-38 R1–R3 |
| `ZIEL.md:22`, Maßstabszeile | *„behoben in 7.2.0.106 … vor dem Release [PRÜFER-36](PRUEFER-36.md) P3“* | P3 ist abgearbeitet; jetzt *„nachgebessert in 7.2.0.109 und 7.2.0.110“* |

Dazu `FILTER.md:4`: *„Der Quellstand ist inzwischen 7.2.0.73“* → 7.2.0.113
(Altlast aus [L-41.5](LEKTOR-41.md#l-41.5)).

### <a id="l-42.8"></a>L-42.8 — ZWEIGE: die beiden neuen Zeilen standen außerhalb der Tabelle (mittel)

`tools/ZWEIGE.md` hatte die Zeilen zu `e-123-notbremse-und-zaehler` und
`e-69-meldungsflut` **mit Leerzeilen davor und dazwischen** angehängt
(`:109`, `:111`, `:113`). In Markdown bricht das die Tabelle ab: beide Zeilen
werden als Fließtext mit rohen `|` ausgegeben, nicht als Tabellenzeile.
**Leerzeilen entfernt**, beide hängen jetzt an der Tabelle. Dazu in der Zeile
`e-69-meldungsflut` nachgetragen, was auf dem Zweig entstanden ist (7.2.0.109
`e15053ac` **nie geschnürt**, 7.2.0.110 `8d1075b0` mit R1–R4, 224 Tests) —
nach dem Muster aus [L-41.9](LEKTOR-41.md#l-41.9).

### <a id="l-42.9"></a>L-42.9 — die Prüfanleitung zu 7.2.0.107 verlangt etwas, das auf dem Weg nicht vorkommt (mittel)

`CHANGELOG.md`, Abschnitt 7.2.0.107, sagte Gregor: *„Die `Content-Type`-Zeile
muss zum Inhalt passen (kein `multipart` über einem einteiligen Rumpf)“*.
Nach [PRÜFER-37](PRUEFER-37.md) **F2** kann das auf dem einzigen Aufrufweg nicht eintreten:
`StripTabooHeaders` entfernt die `Content-Type`-Zeile vorher — gemessen in
**72 von 72** Nachrichten. Im Protokoll steht dann `ct-ersetzt=0`, und das ist
**erwartet**. Wer nach der alten Anleitung prüft, meldet einen Fehler, der
keiner ist, oder hält eine tote Änderung für wirksam.

**Nachtrag eingesetzt** (datiert, der ursprüngliche Abschnitt bleibt als
Rückblick): F2 benannt, `ct-ersetzt=0` als erwartet erklärt, F1 und F3/F4 als
offen, und die Warnung aus PRÜFER-37 *„nicht testen: eine Nachricht mit
Anhang speichern“* übernommen.

### <a id="l-42.10"></a>L-42.10 — zwei PRÜFER-Berichte laden zum Test nicht existierender Pakete ein (mittel)

`Befunde/PRUEFER-37.md` trägt die Überschrift *„Gregors Test an 1.0.107“*,
`Befunde/PRUEFER-38.md` *„Gregors Test an 1.0.109 — wenn R1 und R2 drin
sind“*. Beide Pakete gibt es nicht. Das sind **datierte Berichte**, also
Rückblicke — ihre Urteile (*„Paket 1.0.107 zu Gregor: ja“*, *„Paket 1.0.109 zu
Gregor: NEIN“*) bleiben unverändert stehen. Eine **Prüfanleitung** ist aber
kein Rückblick, sondern eine Aufforderung zu handeln. Unter beide Überschriften
ist deshalb ein gekennzeichneter *Nachtrag LEKTOR, 19.10.2026* gesetzt: das
Paket wurde nie geschnürt, der Inhalt steckt in 1.0.110, die Schritte stehen in
`TESTPLAN.md` [C6](../TESTPLAN.md#c6).

### <a id="l-42.11"></a>L-42.11 — die Hinweise „zur Kenntnis“ aus `doku-pruefen.pl`

Vorher sieben, jetzt drei (`PORTIERUNG.md`, `ZIEL.md`, `tools/WERKZEUGE.md`
und `tools/ZWEIGE.md` sind berichtigt).

| Datei | soll den Quellstand nennen? | Begründung |
|---|---|---|
| `Releases/1.0.101/RELEASE-NOTIZEN.md` | **nein** | veröffentlichter Text zu genau 7.2.0.101 |
| `Testdaten/README.md` | **nein** | der Kopf (`:3`) sagt selbst *„haengen an keiner Programmfassung“* |
| `tools/pruefdaten/LIESMICH.md` | **nein** | Messtabelle zu [AN-1](../BEFUNDE.md#an-1) mit den Fassungen, an denen gemessen wurde |

Der Vorschlag aus [L-41.10](LEKTOR-41.md#l-41.10) steht weiter: diese drei in eine Ausnahmeliste,
damit der Hinweis die echten nicht übertönt. **Nicht von mir gebaut** — das ist
Quelltext in `tools/`, nicht `.md`.

---

## Offen — gemeldet, nicht geändert

### <a id="l-42.12"></a>L-42.12 — `pruefe-befundurteile.pl` prüft sieben von Hand aufgezählte Dokumente (mittel)

Die Schranke, die heute meinen eigenen Fehler gefangen hat, liest eine **feste
Liste**: `README.md`, `FILTER.md`, `PORTIERUNG.md`, `ZIEL.md`, `CHANGELOG.md`,
`WEITERMACHEN.md`, `Releases/1.0.3/LIESMICH.txt`. Der Kommentar begründet das
ausdrücklich — Fehlalarme aus `Befunde/`, `LEKTORAT.md` und `Arbeitsweise/`,
und das ist richtig. **Nicht geprüft werden aber auch `TESTPLAN.md`,
`AUFGABEN.md` und `Releases/PAKETE.md`** — alle drei sind Anwenderdokumente,
alle drei habe ich heute angefasst, und gerade `TESTPLAN.md` ist das Dokument,
aus dem Gregor handelt.
[Prüfumfang nicht von Hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md),
Punkt 2: die Ausnahme sollte am **Merkmal** hängen (Verzeichnis `Befunde/`,
`Arbeitsweise/`, Datei `LEKTORAT.md`), nicht als Positivliste der Prüflinge.
**Vorschlag:** Umfang aus `git ls-files "*.md"` minus diese drei Merkmale.

### <a id="l-42.13"></a>L-42.13 — `doku-pruefen.pl` sieht einen Widerspruch innerhalb derselben Tabelle nicht (mittel)

`WEITERMACHEN.md` nannte in Zeile 9 den Quellstand 7.2.0.106 und in Zeile 12
die Paketnummer 1.0.110. Beide Zeilen stehen in **einer** Tabelle, drei Zeilen
auseinander. `doku-pruefen.pl` meldete *„Kein Widerspruch gefunden“* und nannte
`WEITERMACHEN.md` nicht einmal unter *zur Kenntnis* — weil die Datei die
aktuelle Nummer irgendwo **kennt**. Das ist derselbe Zuschnitt wie bei
[L-41.2](LEKTOR-41.md#l-41.2). **Vorschlag:** ein Muster
*Quellstand … 7.2.0.NN* in einer Tabellenzeile oder einem Absatz, der sich
selbst als Stand ausgibt, gegen `Version.h` halten — unabhängig davon, was die
Datei sonst noch nennt.

### <a id="l-42.14"></a>L-42.14 — aus LEKTOR-41 weiter offen

| Punkt | Stand heute |
|---|---|
| [L-41.1](LEKTOR-41.md#l-41.1) [E-121](../BEFUNDE.md#e-121): Gregors *„ja, e-121 behoben“* | **erledigt**: `BEFUNDE.md:288` führt ihn behoben, `offene-befunde.pl` 33/33, die Restfälle stehen als [E-126](../BEFUNDE.md#e-126) und [E-127](../BEFUNDE.md#e-127) |
| [L-41.2](LEKTOR-41.md#l-41.2) `v1.0.87` als *„veröffentlicht ist“* | **erledigt** in `ZIEL.md:47` und `AUFGABEN.md:3` (beide nennen jetzt `v1.0.101`); `pruefe-release-buchfuehrung.pl` grün |
| [L-41.3](LEKTOR-41.md#l-41.3) [E-123](../BEFUNDE.md#e-123) fehlt im Maßstab 7.2.1.0 | **offen** — `ZIEL.md:18-34` führt [E-123](../BEFUNDE.md#e-123), [E-122](../BEFUNDE.md#e-122), [E-124](../BEFUNDE.md#e-124) bis [E-127](../BEFUNDE.md#e-127) weiterhin weder als Voraussetzung noch unter *ausdrücklich nicht*. **Bewusst nicht geändert: das ist Gregors Entscheidung** |
| [L-41.4](LEKTOR-41.md#l-41.4) *„höchstens 90 s“* und *„7.2.0.102“* | **erledigt** in `README.md:79` und `CHANGELOG.md:20` ([L-42.6](#l-42.6)) |
| [L-41.5](LEKTOR-41.md#l-41.5) README überzeichnet [E-69](../BEFUNDE.md#e-69), CHANGELOG/FILTER ohne Stand | **erledigt** ([L-42.7](#l-42.7)); der Satz *„diese eine Nachricht“* steht in `README.md:75` inzwischen richtig da |
| [L-41.6](LEKTOR-41.md#l-41.6) Block *Der nächste Schritt* bei 7.2.0.102 | **erledigt** ([L-42.2](#l-42.2), [L-42.3](#l-42.3)) |
| [L-41.7](LEKTOR-41.md#l-41.7) TESTPLAN ohne Abschnitt ab 1.0.90 | **erledigt** mit [C6](../TESTPLAN.md#c6) ([L-42.5](#l-42.5)); die Lücke 1.0.90 bis 1.0.106 bleibt |
| [L-41.8](LEKTOR-41.md#l-41.8) zwei Messskripte ohne Eintrag | **offen** — `messen-e69.ps1` und `messen-e123-doppelt.ps1` fehlen weiter in `tools/WERKZEUGE.md`. Seit 7.2.0.106 ist **kein** weiteres dazugekommen (gemessen) |
| [L-41.9](LEKTOR-41.md#l-41.9) ZWEIGE bei 7.2.0.102 | **erledigt** für den laufenden Zweig ([L-42.8](#l-42.8)); die Zeile `e-123-beenden-warten` (`:102`) endet weiter bei 7.2.0.102 |
| [L-41.11](LEKTOR-41.md#l-41.11) PRÜFER und CHRONIST fällig | PRÜFER mit [PRÜFER-37](PRUEFER-37.md) und [PRÜFER-38](PRUEFER-38.md) gelaufen; **CHRONIST läuft** (`tools/AGENTEN-LAUFEN.md`, seit 19.10.2026 13:47) |
| [L-38.5](LEKTOR-38.md#l-38.5) [E-78](../BEFUNDE.md#e-78) in der README-Tabelle | **offen** |
| [L-37.10](LEKTOR-37.md#l-37.10) AUFGABEN ohne Zeilen für [E-122](../BEFUNDE.md#e-122) bis [E-127](../BEFUNDE.md#e-127) | **offen** |
| [L-37.13](LEKTOR-37.md#l-37.13) DLLs im Hauptbaum | **offen**: ` M` an `DirServ.dll`, `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` (Git-Stand zu Sitzungsbeginn) |

---

## Was bewusst stehen geblieben ist

* **Die Urteile in `Befunde/PRUEFER-37.md` und `-38.md`** (*„Paket 1.0.107 zu
  Gregor: ja“*, *„Paket 1.0.109 zu Gregor: NEIN“*). Datierte Berichte sind
  Rückblicke und dürfen alte Nummern nennen; nur die **Prüfanleitungen** haben
  einen Nachtrag bekommen ([L-42.10](#l-42.10)).
* **Alle Blöcke `WEITERMACHEN.md:132` und tiefer**, alle Abschnitte in
  `CHANGELOG.md` zu 7.2.0.109 und älter, alle `Releases/PAKETE.md`-Abschnitte
  unterhalb 1.0.110, `LEKTORAT.md` insgesamt: Fassungsgeschichte.
* **`Releases/PAKETE.md:6`** (*„Diese Buchführung ist unvollständig — Stand
  17.10.2026“*): die Aussage betrifft die Vollständigkeit der Liste und die
  Messung vom 17.09.2026, nicht den heutigen Quellstand; *„zuletzt
  veröffentlicht 1.0.101“* stimmt (`git tag`).
* **`ZIEL.md:18-34`**, die Maßstabstabelle für 7.2.1.0 — welche der neuen
  Befunde Voraussetzung sind, entscheidet Gregor ([L-42.14](#l-42.14)).
* **`tools/pruefe-befundurteile.pl` und `tools/doku-pruefen.pl`** — Quelltext,
  nicht `.md`; die Vorschläge stehen in [L-42.12](#l-42.12) und [L-42.13](#l-42.13).

---

## <a id="l-42.15"></a>L-42.15 — `paket-bereit.pl`: von vier abweisenden Schranken auf zwei

Vor diesem Lauf wiesen **vier von acht** ab, danach **zwei**:

| Schranke | vorher | jetzt |
|---|---|---|
| `pruefe-stand-md.pl` | *„`Releases/PAKETE.md` behauptet 'Stand 17.10.2026', der jüngste Vorgang im CHANGELOG ist vom 19.10.2026“* | **grün** — Kopfzeile auf den 19.10.2026 gezogen, mit dem Zusatz, dass 1.0.107 bis 1.0.109 nie geschnürt wurden. (Ich hatte diese Zeile zunächst bewusst stehen lassen; die Schranke hatte recht und ich nicht.) |
| `befunde-verlinken.pl` | 17 Kennungen ohne Link in fünf Dateien | **grün** — mit `--anker --verlinken` nachgezogen. Danach gemessen: `pruefe-bytes.pl` Rückgabe 0, in allen berührten Dateien **CRLF 0** und **0** Doppelkodierungen (`Ã` + Folgebyte). Die Doppelkodierung vom Vormittag hat sich **nicht** wiederholt. |
| `rollen-faellig.pl` | PRÜFER fällig | **weiter fällig** — siehe unten |
| `agenten-laufen.pl` | LEKTOR und CHRONIST eingetragen | LEKTOR schließt der Auftraggeber, CHRONIST läuft noch |

**PRÜFER ist erneut fällig, und zwar an genau einer Datei:** seit `8eded03`
([PRÜFER-38](PRUEFER-38.md)) hat sich `Eudora71/Version.h` geändert — der
Versionssprung auf 7.2.0.110 in `8d1075b0` (Stand dieses Berichts; seit dem 20.10.2026 ist der Quellstand 7.2.0.113). Inhaltlich ist seit PRÜFER-38 kein
Quelltext dazugekommen; die Schranke zählt die Datei trotzdem, weil sie in
PRÜFERs Bereich liegt. **Das ist kein Mangel an der Behebung**, sondern einer
am Zuschnitt: ein reiner Versionssprung macht jede Behebung wieder
nachrechnungspflichtig. Gemessen mit
`git diff --name-only 8eded03..HEAD -- Eudora71/` — **eine** Datei,
`Eudora71/Version.h`. Wer das abstellen will, nimmt `Version.h` aus PRÜFERs
Bereich heraus; das ist Quelltext in `tools/`, also nicht meine Änderung.

**Nebenbefund, nicht von mir:** im Index liegen `Eudora71/Eudora/msgutils.cpp`
und `Eudora71/Tests/TestE101.cpp` als **gestaget** (`git status --short`:
`M ` in der ersten Spalte). Zu Sitzungsbeginn standen sie dort nicht. Ich habe
nichts an `Eudora71/` angefasst und nichts gestaget — wer immer das war, sollte
vor dem nächsten Commit nachsehen, ob das so gewollt ist
([Agenten trennen mit Worktrees](../Arbeitsweise/agenten-trennen-worktrees.md)).

---

## Geänderte Dateien

`WEITERMACHEN.md`, `README.md`, `CHANGELOG.md`, `ZIEL.md`, `AUFGABEN.md`,
`TESTPLAN.md`, `PORTIERUNG.md`, `FILTER.md`, `Releases/PAKETE.md`,
`tools/ZWEIGE.md`, `tools/WERKZEUGE.md`, `Befunde/PRUEFER-37.md`,
`Befunde/PRUEFER-38.md`, `LEKTORAT.md`, dieser Bericht. Dazu hat
`befunde-verlinken.pl --anker --verlinken` Kennungen in `CHANGELOG.md`,
`WEITERMACHEN.md`, `tools/AGENTEN-LAUFEN.md`, diesem Bericht und im Bericht
des CHRONIST nachverlinkt.

Alle nach jedem Schreibzugriff gemessen: **CRLF 0**, reine LF, UTF-8 ohne BOM,
**0** Doppelkodierungen; `perl tools/pruefe-bytes.pl` Rückgabe 0.
