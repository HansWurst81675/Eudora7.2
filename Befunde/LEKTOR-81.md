# <a id="lektor-81"></a>LEKTOR-81 — Prüfung vor dem PR des Zweigs `0.123_ergebnisse` nach `main`: Kurztest 7.2.0.124 abgeschlossen, Entscheidungen 12–14, Fassung 7.2.0.125, 26.10.2026

**Auftrag.** Kurzprüfung vor dem PR: (1) ob [L-80.1](LEKTOR-80.md#l-80.1)
bis [L-80.9](LEKTOR-80.md#l-80.9) erledigt sind; (2) ob die neuen Einträge
untereinander und mit `Intern/BEFUNDE.md` stimmen — [E-137](../Intern/BEFUNDE.md#e-137) dritter Teil und
Paket 1.0.125, [E-142](../Intern/BEFUNDE.md#e-142) mit den Entscheidungen 12 und 13, [E-124](../Intern/BEFUNDE.md#e-124)/[E-138](../Intern/BEFUNDE.md#e-138) mit
Entscheidung 14, CHANGELOG 7.2.0.125 und 7.2.0.124, PAKETE 1.0.125 gegen ZIP
und Testverzeichnis, README-Stand, ZIEL-Stand und Kriterien 4/6,
TESTPLAN-Kopf; (3) was nach dem Merge auf `main` falsch wäre. Lauf über
`f11f17f..1e819254` (14 Commits), gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor`. `git log HEAD..origin/main` ist leer (gemessen) —
nach dem Merge gilt auf `main` genau der Stand dieses Zweigs.

**Ergebnis vorweg.** **10 Funde** (0 falsch, 7 veraltet, 3 unklar).
[L-80.1](LEKTOR-80.md#l-80.1) bis [L-80.9](LEKTOR-80.md#l-80.9) sind
erledigt bis auf einen Rest von [L-80.4](LEKTOR-80.md#l-80.4) (siehe
[L-81.4](#l-81.4)). Paket 1.0.125 stimmt mit `Releases/PAKETE.md` überein
(Größe, SHA-256, `cmp` gegen den Bau, Spurmarke, `LogLevel` — gemessen).
Nichts gibt [E-137](../Intern/BEFUNDE.md#e-137) dritter Teil als bestätigt aus. Die Funde liegen fast alle in
einer Richtung: Gregors Ergebnisse T4–T6 und die Entscheidungen 12–14 sind
nicht überall nachgezogen — am deutlichsten bei [E-156](../Intern/BEFUNDE.md#e-156), dessen Bestätigung
(T5 *ja*) in `BEFUNDE.md`, `ZIEL.md` und `CHANGELOG.md` noch aussteht und
Kriterium 4 deshalb weiter *„fast“* heißt ([L-81.1](#l-81.1)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-80

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-80.1](LEKTOR-80.md#l-80.1) | [E-137](../Intern/BEFUNDE.md#e-137) fehlte in den erzeugten Listen | **erledigt** | `CHANGELOG.md:39` führt [E-137](../Intern/BEFUNDE.md#e-137); `perl tools/offene-befunde.pl` → *„41 offene Befunde, in beiden Listen gleich.“* rc=0 (gemessen). Der Vorschlag, das Werkzeug solle Urteile ohne Offen-/Erledigt-Wort melden, ist nicht gebaut (war nur Vorschlag) |
| [L-80.2](LEKTOR-80.md#l-80.2) | [E-137](../Intern/BEFUNDE.md#e-137) kannte den zweiten Durchgang von T1 nicht | **erledigt** | `Intern/BEFUNDE.md:395` *„im ersten Durchgang von T1 nicht bestanden, im zweiten bestanden“*, *„Zuletzt gemessen: 26.10.2026 an 7.2.0.124“*; `Intern/WEITERMACHEN.md:121` *„zweiter Teil an 1.0.124 bestätigt“* (belegt). Neu veraltet durch Paket 1.0.125: [L-81.2](#l-81.2) |
| [L-80.3](LEKTOR-80.md#l-80.3) | [E-119](../Intern/BEFUNDE.md#e-119)/[E-158](../Intern/BEFUNDE.md#e-158) warteten auf Bestätigung | **erledigt** | `perl tools/ziel-stand.pl` → *„25 von 25 erfüllt, 0 offen“* (gemessen); `Intern/BEFUNDE.md:365` *„behoben — von Gregor am 26.10.2026 an Paket 1.0.124 bestätigt (TESTPLAN T2 …)“*, `:382` *„von Gregor am 26.10.2026 an Paket 1.0.124 bestätigt (TESTPLAN T3 …)“*; `ZIEL.md:69,73,201` nachgezogen (belegt) |
| [L-80.4](LEKTOR-80.md#l-80.4) | [E-142](../Intern/BEFUNDE.md#e-142) erwartete noch T4 | **teilweise** | Urteilskopf, *Was noch fehlt* und *Zuletzt gemessen* nachgezogen; im Rumpf steht weiter *„Gregor prüft es im Testpaket 7.2.0.124“* → [L-81.4](#l-81.4) |
| [L-80.5](LEKTOR-80.md#l-80.5) | README sagte, ab 7.2.1 frage Eudora nach | **erledigt** | `README.md:172` *„hat Eudora den Entwurf inzwischen neu vom Server geladen, lehnt es das Verschieben ab, und auch Message → Send Again ergibt dann eine leere Mail“* (belegt) |
| [L-80.6](LEKTOR-80.md#l-80.6) | dritter Teil [E-137](../Intern/BEFUNDE.md#e-137) ohne CHANGELOG-Satz | **erledigt** | `CHANGELOG.md:100` eigener Abschnitt 7.2.0.125; `:115` *„Der dritte Teil von [E-137](../Intern/BEFUNDE.md#e-137) kam nach dem Schnüren dazu und steht unter 7.2.0.125“* (belegt) |
| [L-80.7](LEKTOR-80.md#l-80.7) | WEITERMACHEN nannte T3/T4 als offen | **erledigt** | `Intern/WEITERMACHEN.md:135` *„Stand 26.10.2026, 21:00 … Kurztest an 7.2.0.124 abgeschlossen“* (belegt) |
| [L-80.8](LEKTOR-80.md#l-80.8) | PAKETE: 1.0.124 folge noch | **erledigt** | `Releases/PAKETE.md:6` *„geschnürt ist bis 1.0.125“* (belegt) |
| [L-80.9](LEKTOR-80.md#l-80.9) | Lehre nannte eine Schranke, die ihre Regel nicht prüft | **erledigt** | `Arbeitsweise/nur-testplan-zaehlt.md:17` *„Schranke: keine - eine Regel für den Chat, kein Werkzeug liest Chattext …“* (belegt) |

## <a id="l-81.1"></a>L-81.1 — veraltet: E-156 und Kriterium 4 warten noch auf T5, das Gregor mit *ja* abgeschlossen hat

* `Intern/TESTPLAN.md` Ergebnistabelle 7.2.0.124, T5 (belegt): *„**ja** …
  **0** Abstürze aus `Eudora72-1.0.124-release`; im Protokoll keine Zeile
  `Ausnahme`“*.
* `Intern/BEFUNDE.md:384` ([E-156](../Intern/BEFUNDE.md#e-156), belegt): *„**Was noch fehlt:** Gregors
  Bestätigung am Testpaket 7.2.0.124 — null neue Abstürze aus dem
  Paketverzeichnis im Ereignisprotokoll.“* — genau das ist T5.
* `ZIEL.md:72` (belegt): *„von Gregor im Testpaket zu bestätigen“*.
* `ZIEL.md:199` Kriterium 4 (belegt): **„fast“** … *„behoben für 7.2.0.124,
  Gregors Bestätigung im Kurztest T5“*. Daneben `ZIEL.md:201` Kriterium 6
  **„erfüllt — an 7.2.0.124 von Gregor bestätigt (Kurztest T3)“** und
  `ZIEL.md:205-207` *„4 und 6 bestanden dort nicht. Beide sind für 7.2.0.124
  behoben, Gregors Kurztest bestätigt sie (T5 und T3)“* — Kriterium 6 ist
  nachgezogen, Kriterium 4 nach demselben Kurztest nicht.
* `CHANGELOG.md:77-78` (belegt, Abschnitt *Erreicht*): Kriterium 4 *„fast …
  für 7.2.0.124 behoben“*, Kriterien 5 und 6 *„Kriterium 6 an 7.2.0.123 nicht
  bestanden“* — beide vor T3/T5; zugleich eine **Doppelung** der
  Kriterientabelle in `ZIEL.md` (die Zeilen verweisen selbst auf *„Stand in
  ZIEL.md“*).

**Was zu tun wäre:** [E-156](../Intern/BEFUNDE.md#e-156) mit T5 fortschreiben; `ZIEL.md:72` und `:199`
nachziehen (ob Kriterium 4 damit *erfüllt* heißt oder wegen U4 an 1.0.125
noch *fast*, ist eine Zeile — entscheiden, wer den PR stellt);
`CHANGELOG.md:77-78` auf einen Verweis nach `ZIEL.md` kürzen.

## <a id="l-81.2"></a>L-81.2 — veraltet: das Urteil von E-137 sagt *„nicht im Paket 1.0.124“*, nennt aber Paket 1.0.125 nicht

* `Intern/BEFUNDE.md:395` (belegt): *„der dritte Teil (Klick auf Titelzeile
  oder Rand des schwebenden Fensters) ist eingebaut, aber nicht im Paket
  1.0.124 und am Programm noch nicht gemessen.“* Seit `1e819254` steckt er im
  Paket 1.0.125 (gemessen: `grep -a -c '[E-137](../Intern/BEFUNDE.md#e-137) Klick auf den Rahmen der
  schwebenden Leiste'` in `C:\Users\Gregor\Eudora72-1.0.125-release\Eudora.exe`
  → 1; `Releases/PAKETE.md:168`).
* *Was noch fehlt* (dieselbe Zeile): *„Gregors Prüfung im nächsten
  Testpaket“* — das ist 1.0.125, Prüfschritte `Intern/TESTPLAN.md` U1–U3;
  übernommen in `CHANGELOG.md:39`.

**Was zu tun wäre:** *„eingebaut, im Testpaket 1.0.125 (TESTPLAN U1–U3), am
Programm noch nicht gemessen“*; *Was noch fehlt* auf U1–U3 verweisen.

## <a id="l-81.3"></a>L-81.3 — unklar: E-137 verlangt Titelzeile und Rand *„angedockt und schwebend“*, U1–U3 prüfen sie nur schwebend

* `Intern/BEFUNDE.md:395` *Was noch fehlt* (belegt): *„Klick in die Leiste,
  auf ihre Titelzeile und auf ihren Rand, jeweils dann Strg+W, angedockt und
  schwebend.“*
* `Intern/TESTPLAN.md` U1/U2 (belegt): Titelzeile und Rand nur am
  **schwebenden** Filterfenster; U3 angedockt nur die **Beschriftung** (das
  ist der zweite Teil, an 1.0.124 schon bestätigt).
* Der dritte Teil sitzt in `QCMiniDockFrameWnd::OnMouseActivate`, dem kleinen
  Rahmen der **schwebenden** Leiste (`BEFUNDE.md:395`); eine angedockte Leiste
  hat diesen Rahmen nicht (Vermutung nach dem Quelltextzitat im Eintrag,
  nicht nachgelesen). Für Griff und Reiter der angedockten Leiste nennt
  [PRÜFER-59 K1](PRUEFER-59.md#k1) eine Nebenwirkung, die kein U-Schritt
  berührt.
* Unklar ist also nur, welche Seite den Umfang richtig nennt — entweder ist
  *„angedockt“* im Befund zu viel, oder im Testplan fehlt ein Schritt.

**Was zu tun wäre:** *Was noch fehlt* auf den Umfang von U1–U3 bringen, oder
einen Schritt *„angedockt: auf den Griff klicken, dann Strg+W“* ergänzen.

## <a id="l-81.4"></a>L-81.4 — veraltet: E-142 und Entscheidung 12 sagen noch, *Send Again* sei nicht geprüft und T4 stehe aus

* `Intern/BEFUNDE.md:378` (belegt), Rest aus [L-80.4](LEKTOR-80.md#l-80.4):
  *„seit demselben Tag wählt die Rückfrage **No** vor (…), Gregor prüft es im
  Testpaket 7.2.0.124.“* — T4 ist gelaufen, die Rückfrage kam nicht.
* Dieselbe Zeile (belegt): *„Ob *Send Again* aus dem IMAP-Ordner eine
  sendbare Nachricht ergibt, ist noch nicht geprüft (Intern/WEITERMACHEN.md,
  Entscheidung 12).“* — zwei Sätze später: *„**Kurztest T6 an 1.0.124:** …
  liefert eine leere mail“*.
* `Intern/WEITERMACHEN.md:131` Entscheidung 12 (belegt): *„das ist **noch
  nicht geprüft** und kommt als Testschritt in den Kurztest des nächsten
  Pakets, ebenso die berichtigte Beschreibung von T4“* — geprüft wurde es als
  T6 an 1.0.124 (`Intern/TESTPLAN.md`, T6 *nein*), und Entscheidung 13
  (`:132`) hat die Bedingung ersetzt. Eine berichtigte T4-Beschreibung steht
  im Kurztest 7.2.0.125 nicht (U1–U4, gemessen) — nach Entscheidung 13 auch
  nicht mehr nötig, aber die Zeile kündigt sie an.

**Was zu tun wäre:** in `BEFUNDE.md:378` die beiden Sätze durch das Ergebnis
ersetzen; Entscheidung 12 als Wortlaut stehen lassen und anhängen *„(geprüft
als T6 an 1.0.124: nein — siehe Entscheidung 13)“*.

## <a id="l-81.5"></a>L-81.5 — veraltet: TESTPLAN T4 sagt, Gregor entscheide noch

* `Intern/TESTPLAN.md:61` (belegt), Bemerkung zu T4: *„Ob das so bleiben
  soll oder die Entwurfsmarke erhalten werden muss, entscheidet Gregor
  ([E-142](BEFUNDE.md#e-142))“* — entschieden: Entscheidung 12
  (`Intern/WEITERMACHEN.md:131`, *„die ablehnung reicht“*) und 13 (`:132`).

**Was zu tun wäre:** *„entschieden: die Ablehnung bleibt (Entscheidungen 12
und 13)“*.

## <a id="l-81.6"></a>L-81.6 — veraltet: E-124 trägt *Zuletzt gemessen 23.10.2026*, obwohl am 26.10. an 1.0.124 wieder gemessen

* `Intern/BEFUNDE.md:370` (belegt): *„Zuletzt gemessen: 23.10.2026 an
  7.2.0.121“*; in derselben Zeile seit `17a084ec`: *„**Wieder aufgetreten am
  26.10.2026 an Paket 1.0.124** … die `Eudora.exe` von 1.0.124 hat SHA-256
  `b08ca8dc30602343…` (gemessen an der Kopie in
  `C:\Users\Gregor\Eudora72-1.0.124-release` …)“*.
* Gemessen: `sha256sum C:\Users\Gregor\Eudora72-1.0.124-release\Eudora.exe`
  → `b08ca8dc30602343b272…` — der Nachtrag stimmt.
* Das alte Datum geht in die erzeugten Listen: `CHANGELOG.md:45`,
  `Intern/WEITERMACHEN.md:374` *„23.10.2026 an 7.2.0.121“*.

**Was zu tun wäre:** *Zuletzt gemessen: 26.10.2026 an 7.2.0.124*, dann
`perl tools/offene-befunde.pl -schreiben`.

## <a id="l-81.7"></a>L-81.7 — veraltet: README nennt drei Testpakete und verweist auf *„beide Fassungen“*

* `README.md:136-137` (belegt): *„**Neu in den Testpaketen 7.2.0.123 bis
  7.2.0.125** … steht an einer Stelle, im CHANGELOG unter beiden Fassungen“*.
  Commit `6ef9fa8d` hat die Überschrift von *„7.2.0.123 und 7.2.0.124“*
  umgestellt, den Folgesatz nicht (gemessen, `git diff`).

**Was zu tun wäre:** *„unter den drei Fassungen“*.

## <a id="l-81.8"></a>L-81.8 — veraltet: README *Bekannte Fehler* kündigt die E-119-Behebung für 7.2.0.124 an, die Gregor dort bestätigt hat

* `README.md:164` (belegt): *„**im Testpaket 7.2.0.123** kleine Bilder
  richtig, Bilder über 48 KB verstümmelt … | die Behebung für große Bilder
  kommt mit dem Testpaket 7.2.0.124 und dem Release 7.2.1“*.
* `Intern/BEFUNDE.md:365` (belegt): *„behoben — von Gregor am 26.10.2026 an
  Paket 1.0.124 bestätigt (TESTPLAN T2 …)“*.
* Die Nachbarzeilen `README.md:165,167` haben die Form *„**Behoben ab dem
  Release 7.2.1** (schon im Testpaket 7.2.0.123)“* (belegt).

**Was zu tun wäre:** wie die Nachbarzeilen: *„Behoben ab dem Release 7.2.1
(große Bilder seit dem Testpaket 7.2.0.124)“*.

## <a id="l-81.9"></a>L-81.9 — unklar: ANWENDER sagt, eine Code-Signatur gebe es *„bisher“* nicht — nach Entscheidung 14 kommt keine

* `Doku/ANWENDER.md:223-224` (belegt): *„Dauerhaft hilft nur eine
  Code-Signatur mit einem Zertifikat – die gibt es für dieses Projekt bisher
  nicht.“*
* `Intern/WEITERMACHEN.md:133` Entscheidung 14 (belegt): **„keine
  Code-Signatur“**; `Intern/BEFUNDE.md:370` und der E-138-Eintrag sind
  nachgezogen (`git diff f11f17f..HEAD`, gemessen), `ANWENDER.md` nicht.
* *„bisher“* lässt den Anwender erwarten, dass eine Signatur kommt. Nicht
  falsch — es gibt keine —, aber die Erwartung ist durch die Entscheidung
  überholt.

**Was zu tun wäre:** *„… – dieses Projekt wird nicht signiert.“* (oder
*„bisher“* streichen).

## <a id="l-81.10"></a>L-81.10 — veraltet: PAKETE 1.0.124 nennt den Kurztest T1–T5, es gab auch T6

* `Releases/PAKETE.md:178` (belegt): *„Für Gregors Kurztest ([TESTPLAN
  T1–T5](../Intern/TESTPLAN.md))“* — `Intern/TESTPLAN.md` führt T6 an 1.0.124
  (Ergebnis *nein*).

**Was zu tun wäre:** *„T1–T6“*.

---

## Geprüft ohne Fund

* **Paket 1.0.125 gegen `Releases/PAKETE.md:159-171`** (gemessen, nur
  gelesen): `Releases/Eudora72-1.0.125-release.zip` im Hauptbaum 9.125.690
  Byte, SHA-256 `017753d0…c40c7a7` — gleich `:167`; im Testverzeichnis
  `Eudora.exe` und `EudoraRes.dll` mit `cmp` gleich `Eudora71/Bin/Release`;
  Spurmarke in der `Eudora.exe` vorhanden; `Mailverzeichnis` enthält nur
  `Eudora.ini` mit `LogLevel=58527`; 39 Dateien mit Endung
  `exe/dll/eif/ocx/vxd`, in keiner ein Name einer Debug-Laufzeit
  (`ucrtbased`, `vcruntime140d`, `msvcp140d`, `mfc140d`, `MSVCR71D`).
  `Releases/PRUEFBERICHT.md`: 312/312, 19/19, 36/36 — gleich `PAKETE.md:169`
  und `CHANGELOG.md:110`.
* **Fassung 7.2.0.125 überall gleich:** `Eudora71/Version.h:11,14`
  (`EUDORA_VERSION4 125`, `"7.2.0.125"`), `VERSION` `1.0.125`, `README.md:99`,
  `ZIEL.md:172`, `Intern/AUFGABEN.md:3`, `Intern/WEITERMACHEN.md:9,12`,
  `Intern/TESTPLAN.md:1`, `Doku/MITARBEITEN.md:63` (gemessen).
* **Include-Korrektur** `Eudora71/Eudora/workbook.cpp:41` `#include
  "WazooWnd.h"` steht; der Eintrag in `BEFUNDE.md:395` beschreibt sie
  (belegt).
* **[E-142](../Intern/BEFUNDE.md#e-142) und README:** `README.md:172` steht unter *Bekannte Fehler*
  (`:144`), wie Entscheidung 13 sagt; *„Entwürfe daher im lokalen Postfach
  `Out` lassen“* stimmt mit Gregors *„einfach im out lassen?“* (belegt).
  `CHANGELOG.md:34` und `Intern/WEITERMACHEN.md:363` übernehmen *„vor 7.2.1
  nichts — Gregors Entscheidung 13“* (gemessen, erzeugte Liste).
* **[E-138](../Intern/BEFUNDE.md#e-138):** `Intern/BEFUNDE.md` nennt die abgelehnte Signatur mit Verweis
  auf [E-124](../Intern/BEFUNDE.md#e-124) (gemessen, `git diff --word-diff`).
* **TESTPLAN-Kopf** `Intern/TESTPLAN.md:1-6`: Quellstand, Paket, *„7.2.0.124
  und 7.2.0.123 sind abgeschlossen“* — stimmt mit T1–T6 und dem Abschnitt
  *„abgeschlossen am 26.10.2026“* (belegt).

## Nach dem Merge auf `main`

Nichts wird als bestätigt ausgegeben, was nicht bestätigt ist. Falsch wird
nach dem Merge nichts; nach `main` gingen die Lücken
[L-81.1](#l-81.1) bis [L-81.10](#l-81.10) — der Leser von `ZIEL.md` sähe
Kriterium 4 als *„fast“* mit einem ausstehenden Test, der längst *ja* ist
([L-81.1](#l-81.1)). `origin/main` hat keine Commits, die der Zweig nicht
hat (gemessen).

## Nicht geprüft

* Der Quelltext von `469742da` und `46707a76` außer der einen Include-Zeile
  — PRÜFER-Sache ([PRÜFER-60](PRUEFER-60.md)).
* `Releases/PRUEFBERICHT.md:6` *„Arbeitsbaum nicht sauber (1 Dateien)“* —
  welche Datei, nicht gemessen (Vermutung: `tools/AGENTEN-LAUFEN.md`, das im
  Hauptbaum als geändert steht).
* Mechanische Prüfungen außer `offene-befunde.pl` und `ziel-stand.pl`.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)): genügt dein Ergebnis an 7.2.0.123 plus
  die Kurztests an 7.2.0.124 und 7.2.0.125, oder willst du am Paket 7.2.1.N
  noch einmal alle neun Kriterien durchgehen?
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)): zuletzt
  am 06.09.2026 an 1.0.10 geprüft; seit 7.2.0.124 ist die Zusammensetzung des
  Pakets anders. Muss der Test wiederholt werden?
