# <a id="lektor-54"></a>LEKTOR-54 — Bestandsprüfung nach PR #157, #158 und #159 (E-116, E-130, Gregors Entscheidungen vom 23.10.2026 abends), 23.10.2026

**Auftrag.** Gregor hat PR #157, #158 und #159 gemergt (`git log
afafdcfa..edb66e02`). Darin: [E-116](../Intern/BEFUNDE.md#e-116) eingebaut
(ein Bild mit `width="35px"` wurde riesig breit), [E-130](../Intern/BEFUNDE.md#e-130)
behoben (der Bau veränderte fünf mitgelieferte DLLs von QUALCOMM), seine
Entscheidungen vom Abend, die Bestätigungen von [E-142](../Intern/BEFUNDE.md#e-142)
und [E-144](../Intern/BEFUNDE.md#e-144) am Programm, ein neuer
CHANGELOG-Abschnitt und eine neue Reihenfolge in `Intern/WEITERMACHEN.md`.
Geprüft wurde **der Bestand**, nicht der Diff: alle 180 `.md` aus `git ls-files`
ohne `Arbeitsweise/`. Maßstab von außen: `Eudora71/Version.h` (`7.2.0.122`),
`VERSION` (`1.0.122`), `git tag` (zuletzt `v1.0.120`), `Releases/PAKETE.md`,
`Intern/BEFUNDE.md`, `git log`.

**Ergebnis vorweg.** Die neue Kurzform, mit der heute drei Befundzeilen
beginnen (*„Kurz: …"*), macht zwei Werkzeuge blind: Die zwei Fehler, die
Gregor heute am Programm bestätigt hat (leere Nachricht in `Out`, Antwort fällt
aus dem Gesprächsfaden), stehen in **keiner** erzeugten Liste offener Befunde
mehr, und [E-130](../Intern/BEFUNDE.md#e-130) ging auf *behoben*, ohne dass
die Regressionsschranke es bemerkt hat. Gregors Entscheidungen vom Abend
stehen fast nur in `Intern/WEITERMACHEN.md`: der Maßstab `ZIEL.md` nennt drei
davon noch *„nicht entschieden"*, die neue Versionsregel steht in keiner der
neun Dateien, die das Release *„7.2.1.0"* nennen. `Intern/WEITERMACHEN.md`
hat vier Einstiegsblöcke von heute, und der einzige mit der Marke *HIER
WEITERMACHEN* ist der älteste.

**19 Funde**: 6 veraltet, 5 Widerspruch, 4 unvollständig, 3 falsch (zwei davon
in Werkzeugen), 1 Form. **Vier Fragen an Gregor** stehen gesammelt am Ende.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **am Text
belegt** (Zitat mit Datei:Zeile), **Vermutung**.

---

## Teil 1 — Die Kurzform und die Werkzeuge

### <a id="l-54.1"></a>L-54.1 — die zwei heute bestätigten Fehler stehen in keiner Liste offener Befunde mehr

**Gewicht: falsch, lautlos.** `Intern/BEFUNDE.md:370` ([E-142](../Intern/BEFUNDE.md#e-142)), `:372` ([E-144](../Intern/BEFUNDE.md#e-144)); erzeugte Tabellen `CHANGELOG.md:30-60`, `Intern/WEITERMACHEN.md:347-386`

Worum es geht: Wer einen Entwurf aus einem IMAP-Ordner nach `Out` zieht,
bekommt dort eine leere Nachricht ([E-142](../Intern/BEFUNDE.md#e-142)). Ein
Antwortentwurf, der aus `Trash` zurück nach `Out` geschoben wird, verliert die
Angabe, worauf er antwortet ([E-144](../Intern/BEFUNDE.md#e-144)). Beide hat
Gregor heute am Programm bestätigt, beide nennen sich selbst *„Die Behebung
fehlt noch"*.

**Gemessen:** Der Merge hat beide Zeilen aus der erzeugten Tabelle *Noch offen*
in `CHANGELOG.md` **und** in `Intern/WEITERMACHEN.md` gelöscht (`git diff
afafdcfa..edb66e02 -- CHANGELOG.md`: `-| **[[E-144](../Intern/BEFUNDE.md#e-144)]…` und `-| **[[E-142](../Intern/BEFUNDE.md#e-142)]…`).
`perl tools/offene-befunde.pl` meldet trotzdem *„38 offene Befunde, in beiden
Listen gleich."*

**Ursache, am Quelltext belegt:** `tools/offene-befunde.pl:145-162` liest das
**erste Fettgedruckte** des Urteils und verlangt darin ein Wort aus
`@offen_wort` (`:81`: *offen, in arbeit, zurückgestellt, teilweise, beobachtet,
nicht gemessen*). Der neue Kurzsatz enthält keines davon. Bei
[E-142](../Intern/BEFUNDE.md#e-142) kommt dazu: Der Kurzsatz enthält die
kursive Meldung `*„No messages were transferred!"*`; das Muster
`\*\*([^*]+?)\*\*` endet am ersten `*`, und als „erstes Fettgedrucktes" liest
das Werkzeug ein Bruchstück aus der Mitte (gemessen, Nachbau der Zeilen
`:112-135`: *„ an Paket 1.0.122 (auf seinen 0.116-Daten): Entwurf von …"*).

**Gegenprobe, gemessen** an einer Kopie in meinem Notizverzeichnis: vor beide
Kurzsätze `offen. ` gesetzt → *„offen laut Intern/BEFUNDE.md 39 … FEHLEN (1):
[E-144](../Intern/BEFUNDE.md#e-144)"*. [E-144](../Intern/BEFUNDE.md#e-144) kommt zurück, [E-142](../Intern/BEFUNDE.md#e-142) nicht (wegen der Kursivschrift).

**Vorschlag:** Die Regel für den Kurzsatz um eine Bedingung ergänzen: der
**zweite** Satz (der Stand) beginnt mit dem Urteilswort, also *„Offen."* oder
*„Behoben in …"*. So bleiben die Werkzeuge gültig, ohne dass sie Prosa raten
müssen. Dazu in `offene-befunde.pl` (und im gleichlautenden
`pruefe-befundurteile.pl`; `offene-befunde.pl:75` sagt *„Dieselbe Regel wie pruefe-befundurteile.pl"*) einfache Sternchen
innerhalb von Fettschrift nicht als Ende werten. Zuerst den Gegentest mit der
heutigen E-142-Zeile, sonst ist die Berichtigung wieder blind
([Schranke gegentesten](../Arbeitsweise/schranke-gegentesten.md)).

### <a id="l-54.2"></a>L-54.2 — E-130 ist auf „behoben" gegangen, ohne dass die Regressionsschranke es gesehen hat

**Gewicht: falsch (Schranke umgangen, nicht absichtlich).** `Intern/BEFUNDE.md:368`; `tools/pruefe-regressionstest.pl:176-178`, `:193-198`

Die Schranke weist einen Commit ab, der einen Befund **neu** auf *behoben*
setzt, ohne Testfall (`ZIEL.md:103-105`). Sie erkennt *behoben* daran, dass
das erste kurze Fettgedruckte (höchstens 90 Zeichen) mit dem Wort
**beginnt** (`/^\s*behoben/i`). [E-130](../Intern/BEFUNDE.md#e-130) beginnt mit *„**Kurz: Nach jedem Bau …
Behoben am 23.10.2026 …**"*.

**Gemessen** (Nachbau von `status_von`): [E-130](../Intern/BEFUNDE.md#e-130) an `HEAD` → `sonst`. Mit
vorangestelltem `**behoben am 23.10.2026.**` → `behoben`. Die Schranke hätte
also abgewiesen. `pruefe-regressionstest.pl` führt [E-130](../Intern/BEFUNDE.md#e-130) weiter unter
*„OHNE jede Pruefung"* (gemessen, Ausgabe von heute), aber nicht als neu
behoben. Die Gegenprobe in [E-130](../Intern/BEFUNDE.md#e-130) (*„5 Tests, 5 bestanden"*) ist ein
einmaliger Lauf, kein Fall in `tools/pruefstand-faelle.txt` oder in der
Testsuite (Vermutung, nicht weiter gesucht).

**Vorschlag:** wie [L-54.1](#l-54.1), Stand-Satz mit dem Urteilswort. Für
[E-130](../Intern/BEFUNDE.md#e-130) danach entscheiden, ob der Vergleich der fünf SHA-1 nach
`BindExe.bat` ein Regressionsfall wird. Er ist billig und deckt genau den
Rückfall ab.

---

## Teil 2 — Gregors Entscheidungen vom Abend: wo sie fehlen

### <a id="l-54.3"></a>L-54.3 — der Maßstab nennt drei Fragen „noch nicht entschieden", die heute entschieden sind

**Gewicht: Widerspruch.** `ZIEL.md:38`

> *„**Noch nicht entschieden:** [[AN-1](../Intern/BEFUNDE.md#an-1)], [[E-130](../Intern/BEFUNDE.md#e-130)], [[E-133](../Intern/BEFUNDE.md#e-133)] ([[L-53.13](LEKTOR-53.md#l-53.13)])"*

**Was stimmt** (am Text belegt, `Intern/WEITERMACHEN.md:135-138`): [AN-1](../Intern/BEFUNDE.md#an-1)
(ein IMAP-Anhang kommt ohne Dateiendung an) *„aufschreiben, jetzt nicht"*;
[E-130](../Intern/BEFUNDE.md#e-130) behoben; [E-133](../Intern/BEFUNDE.md#e-133) (Eudora startet nicht, wenn das gemerkte Mailverzeichnis
fehlt) bleibt offen, mit Umgehung in `README.md:146`.

**Vorschlag:** den Satz ersetzen durch *„Ebenfalls keine Voraussetzung,
entschieden am 23.10.2026: [AN-1](../Intern/BEFUNDE.md#an-1) (später, im Regressionstest-Block), [E-133](../Intern/BEFUNDE.md#e-133)
(Umgehung `Eudora starten.cmd` in README). [E-130](../Intern/BEFUNDE.md#e-130) ist behoben."*

### <a id="l-54.4"></a>L-54.4 — Adressbuch-Taste: oben „erfüllt, keine Doku", in derselben Zelle „Taste in README aufschreiben"

**Gewicht: Widerspruch in einer Zeile.** `ZIEL.md:40`

Die zweite Spalte sagt seit heute *„ERFÜLLT … die vorher verlangte Doku
entfällt damit"*. Die dritte Spalte derselben Zeile endet weiter mit *„**Was
noch zu tun ist:** die Taste in [README.md] aufschreiben und einmal am
laufenden Programm nachmessen."* (am Text belegt).

**Vorschlag:** den Satz als *„überholt am 23.10.2026 (Gregor: nichts mehr zu
tun)"* kennzeichnen oder streichen. Damit ist der Adressbuch-Teil von
[L-53.11](LEKTOR-53.md#l-53.11) erledigt.

### <a id="l-54.5"></a>L-54.5 — die neue Versionsregel steht nur in WEITERMACHEN; neun Dateien sagen „7.2.1.0"

**Gewicht: unvollständig.** Regel: `Intern/WEITERMACHEN.md:133`. Gegenstellen:
`ZIEL.md:10`, `:12-14`, `:62`; `README.md:60`, `:75`, `:98`, `:135`;
`Intern/PORTIERUNG.md:37`; `Intern/TESTPLAN.md:16`; `Intern/BEFUNDE.md:152`;
`Intern/WEITERMACHEN.md:146`; `tools/WERKZEUGE.md:127`; `Releases/PAKETE.md:50-54`

Gregor: *„release wird dann heißen: 7.2.1.123 (bzw. die laufende build nummer,
die wird hinten angehängt)."* **Gemessen:** `grep -n "7\.2\.1\.123\|7\.2\.1\.<"`
über alle 180 Dateien → ein einziger Treffer, `WEITERMACHEN.md:133`.
`ZIEL.md:67` schreibt *„7.2.1.x"*, dieselbe Datei in `:10` *„Maßstab für die
Fassung 7.2.1.0"* und in `:62` *„erst danach Marke `v7.2.1.0`"*.
`Releases/PAKETE.md:50` beschreibt die Produktversion als `7.2.0.x`.

**Was sich damit erledigt** (am Text belegt): Die Sorge aus
[L-53.16](LEKTOR-53.md#l-53.16), bei 7.2.1.0 hieße das Paket 1.0.0, entfällt.
Mit 7.2.1.123 und Paket 1.0.123 bleibt die Verabredung *„dieselbe letzte
Stelle"* (`PAKETE.md:54`) erhalten. **Was bleibt:** `release-veroeffentlichen.ps1:81-82`
verlangt weiter `7,2,0,<n>` und `"7.2.0.<n>"`, `:173` bildet die Marke
`v1.0.<n>`. Das sagt `WEITERMACHEN.md:133` selbst.

**Vorschlag:** In `ZIEL.md` die Überschrift auf *„Maßstab für das Release
7.2.1"* und einen Satz mit Gregors Regel. Gregors Zitat vom 14.10. (*„für die
7.2.1.0 version"*) bleibt als Zitat stehen. `:62` erst nach
[Frage 1](#fragen). `PAKETE.md:50` um die Zeile *„ab dem Release 7.2.1:
`7.2.1.<Buildnummer>`"* ergänzen. Die übrigen Stellen auf *„7.2.1"* ziehen.
`doku-pruefen.pl` meldet das nicht, weil alle Dateien sich einig sind
([Einigkeit ist kein Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)).

### <a id="l-54.6"></a>L-54.6 — „der Rückstand ist vor 7.2.1.0 abzuarbeiten" steht weiter in BEFUNDE.md und WEITERMACHEN.md

**Gewicht: Widerspruch.** `Intern/BEFUNDE.md:150-152`; `Intern/WEITERMACHEN.md:144`; dazu veraltet `ZIEL.md:98-105`

Worum es geht: Für 50 von 67 kritischen Befunden gibt es keinen Test, der
meldet, wenn der Fehler zurückkommt. Gregor hat heute entschieden, dass das
Release darauf **nicht** wartet (`ZIEL.md:67-75`: *„Das Release wird also
**nicht** aufgehalten …"*).

> BEFUNDE.md:150-152: *„**15 von 64 mit automatischem Testfall, 0 manuell im
> Testplan, 49 ohne jede Prüfung.** Das ist der Rückstand, der vor 7.2.1.0
> abzuarbeiten ist."*
>
> WEITERMACHEN.md:144: *„Vereinbart war seit dem 22.10.2026, den Rückstand
> vor 7.2.1.0 abzuarbeiten"* (ohne Hinweis, dass das am Abend geändert wurde)

**Gemessen** (`perl tools/pruefe-regressionstest.pl`, heute): 17 von 67 mit
Testfall, 1 manuell, 50 ohne Prüfung; insgesamt 199 Befunde, 41 mit Testfall,
**88** behoben ohne Testfall. `ZIEL.md:98-105` nennt weiter 186 / 29 / 0 /
**97** vom 22.10.

**Vorschlag:** BEFUNDE.md:152 auf *„Er wird ab der nächsten Sitzung vor jedem
neuen Thema abgearbeitet; das Release 7.2.1 wartet nicht darauf, nennt ihn aber
(Gregor, 23.10.2026, siehe ZIEL.md)"*. In WEITERMACHEN.md:144 einen
Halbsatz *„… geändert am Abend: das Release wartet nicht darauf"*. Die Zahlen
aus dem Werkzeug erzeugen statt von Hand. Damit ist
[L-53.12](LEKTOR-53.md#l-53.12) erledigt.

### <a id="l-54.7"></a>L-54.7 — „die Release-Notizen nennen den Rückstand": keine Stelle sorgt dafür

**Gewicht: unvollständig.** `ZIEL.md:70-71`; `CHANGELOG.md:102-123`; `tools/release-veroeffentlichen.ps1`

Die Entscheidung steht als Prosa im Abschnitt *Regressionstests*. Sie steht
nicht im erzeugten Block *Was noch fehlt* (`ZIEL.md:18-34`), und kein Werkzeug
prüft sie (am Text belegt: `grep -n "Rueckstand\|Rückstand"
tools/release-veroeffentlichen.ps1` → kein Treffer, gemessen). Der
CHANGELOG-Abschnitt *„Seit 7.2.0.122, noch ohne Paket"*, aus dem die nächsten
Release-Notizen entstehen, erwähnt den Rückstand nicht.

**Vorschlag:** eine Zeile im Maßstab (*„Release-Notizen nennen die Zahl der
kritischen Befunde ohne Test, erzeugt aus `pruefe-regressionstest.pl`"*),
damit `ziel-stand.pl` sie zählt, oder eine Prüfung in
`release-veroeffentlichen.ps1`
([Anforderung gehört in den Maßstab](../Arbeitsweise/anforderung-gehoert-in-den-massstab.md)).

### <a id="l-54.8"></a>L-54.8 — Teil M: M2 ist abgeschaltet, aber drei Stellen zählen es weiter mit

**Gewicht: veraltet.** `Intern/TESTPLAN.md:16`, `:523`; `Intern/BEFUNDE.md:267`; `Releases/PRUEFBERICHT.md:68` (erzeugt von `tools/pruefbericht.pl:265`)

Teil M sind die Handtests M1 (fremdes Mailverzeichnis), M2 (Suchindex) und
M3 (Ziehen nach `Out`). Heute richtig eingetragen (am Text belegt):
`TESTPLAN.md:519` *„vor dem Release 7.2.1"*, `:521` *„nicht vor jedem
Release"*, `:564` M2 *„Deaktiviert am 23.10.2026, nicht gelöscht"*. Damit sind
[L-53.21](LEKTOR-53.md#l-53.21) und der Kern von [L-53.14](LEKTOR-53.md#l-53.14)
erledigt.

Was nicht mitgezogen ist:

* `TESTPLAN.md:16`: *„Vor dem Release 7.2.1.0 bleiben die Fälle aus Teil M
  von Hand zu fahren."* Gemeint sind jetzt nur M1 und M3.
* `TESTPLAN.md:523`: *„Diese Fälle gehören zu **kritischen** Befunden"* —
  M2 gehört zu [E-14](../Intern/BEFUNDE.md#e-14), Stufe *wichtig*
  (Rest von [L-53.14](LEKTOR-53.md#l-53.14)).
* `BEFUNDE.md:267` ([E-14](../Intern/BEFUNDE.md#e-14)) trägt weiter
  *„Prüfung: manuell (Teil M2 in TESTPLAN)"*. **Vermutung:**
  `pruefe-regressionstest.pl` zählt [E-14](../Intern/BEFUNDE.md#e-14) deshalb als *manuell geprüft*,
  obwohl der Fall abgeschaltet ist. In derselben Zelle stehen weiter
  unmarkiert *„**Was noch fehlt:** die eine Messung, die entscheidet"* und
  *„Steht seit dem 05.09.2026 ungeprüft"* (Nebenbefund aus [L-53.14](LEKTOR-53.md#l-53.14), nicht
  eingearbeitet).
* `PRUEFBERICHT.md:68`: *„sie muessen vor einem Release von Hand gefahren …
  werden"*. Der Satz kommt aus dem Erzeuger, eine Berichtigung von Hand
  hielte nur bis zum nächsten Lauf. Der Bericht selbst nennt noch Paket
  `1.0.121` (`:5`).

**Vorschlag:** `TESTPLAN.md:16` auf *„Vor dem Release 7.2.1 bleiben M1 und M3
von Hand zu fahren; M2 ist abgeschaltet."* `:523` auf *„… zu Befunden, die sich
nicht automatisch prüfen lassen"*. In [E-14](../Intern/BEFUNDE.md#e-14) die Marke auf *„Prüfung: manuell
(Teil M2, abgeschaltet am 23.10.2026)"* und die zwei alten Sätze als überholt
kennzeichnen. `pruefbericht.pl:265` auf *„vor dem Release 7.2.1"*.

---

## Teil 3 — Die heute angefassten Befunde, gegen den Bestand

### <a id="l-54.9"></a>L-54.9 — E-116 heißt an fünf Stellen „noch im Zweig", „in Arbeit" oder „Test zuerst, dann Bau"; es ist auf `main`

**Gewicht: veraltet.** `Intern/BEFUNDE.md:354`; `Intern/WEITERMACHEN.md:139`, `:144`, `:146`; `Intern/AUFGABEN.md:414`

**Gemessen:** `git log --oneline afafdcfa..edb66e02` → `df4f0ac1 Merge pull
request #157 from HansWurst81675/e-116-bildbreite-px`. Der Code ist auf `main`.

* `BEFUNDE.md:354` beginnt mit *„**offen, am Quelltext belegt (PRUEFER-22,
  F3, 13.10.2026), nicht am laufenden Programm gesehen.**"* und sagt weiter
  hinten *„Zweig `e-116-bildbreite-px`, noch nicht in einer Fassung"* und
  *„Behebung auf dem Zweig"*.
* `WEITERMACHEN.md:139`: *„liegt fertig im Zweig … noch ohne PR; Gregor ist
  mit seiner Durchsicht noch nicht fertig."*
* `WEITERMACHEN.md:146`: *„**In Arbeit:** [E-116](../Intern/BEFUNDE.md#e-116) im Zweig
  `e-116-bildbreite-px`."* — `:144`: *„[E-116](../Intern/BEFUNDE.md#e-116) läuft schon"*.
* `AUFGABEN.md:414`: *„Test zuerst, dann Bau (Vorschlag des PRÜFERS …)"*.

Dass das Urteil *offen* lautet, ist im Sinn der Regel richtig (am Programm noch
nicht gesehen). Falsch ist nur der Ort. Die Zeile verstößt außerdem gegen die
neue Regel (siehe Teil 5 unten).

**Dazu, am Text belegt:** Der Nebenfund (a) in `WEITERMACHEN.md:142`
(*„`numeric_value` … macht aus `" 35"` eine 0"*) hat keine eigene Kennung.
`perl tools/befund-suchen.pl numeric_value` nennt [E-116](../Intern/BEFUNDE.md#e-116)
und [E-89](../Intern/BEFUNDE.md#e-89) (gemessen). Nach `CLAUDE.md` §2 gehört
er als Fortschreibung in [E-116](../Intern/BEFUNDE.md#e-116), nicht als neue Nummer. Heute steht er nur in
WEITERMACHEN und ist für `offene-befunde.pl` unsichtbar.

**Vorschlag:** in [E-116](../Intern/BEFUNDE.md#e-116) *„auf `main` seit PR #157 (23.10.2026), noch nicht in
einem Paket"*. In WEITERMACHEN die drei Stellen auf diesen Stand bringen. Die
Zeile in AUFGABEN.md auf *„gebaut mit Test; fehlt: Prüfnachricht am
Programm"*. Den Nebenfund (a) in [E-116](../Intern/BEFUNDE.md#e-116) nachtragen.

### <a id="l-54.10"></a>L-54.10 — E-130 ist behoben, sagt aber in derselben Zelle weiter „Offen: wer stempelt"

**Gewicht: veraltet in sich.** `Intern/BEFUNDE.md:368`

Der Anfang ist richtig (*„Behoben am 23.10.2026 … für Gregor ist nichts zu
tun"*). Weiter hinten stehen unmarkiert drei Sätze vom 20. und 22.10. (am Text
belegt):

> *„**Offen:** wer stempelt, und welche der beiden Fassungen gilt. **Was noch
> fehlt:** zweierlei — **wer** die fünf DLLs beim Bau stempelt, ist nicht
> gefunden …"* — *„Der zweite Teil … bleibt offen."*

Die Zelle hat genau **ein** *Was noch fehlt*, und das ist das überholte.
Dieselbe Falle hat [L-53.19](LEKTOR-53.md#l-53.19) für [E-123](../Intern/BEFUNDE.md#e-123) beschrieben: die
Werkzeuge nehmen das erste. Für die heutige Tabelle folgenlos, weil [E-130](../Intern/BEFUNDE.md#e-130) als
erledigt gilt.

**Vorschlag:** den Teil ab *„Vorher: offen, am 20.10.2026 gemessen"* unter
*„Verlauf (überholt am 23.10.2026):"* stellen und *„Was noch fehlt"* darin in
*„Damals fehlte"* umbenennen. Ein neues *Was noch fehlt*: *„nichts"*, oder
der Regressionsfall aus [L-54.2](#l-54.2).

### <a id="l-54.11"></a>L-54.11 — E-125 ist bestätigt, die Zelle verlangt weiter „Gregors Lauf am Programm"

**Gewicht: veraltet in sich.** `Intern/BEFUNDE.md:363`

> *„**Was noch fehlt:** Gregors Lauf am Programm. Der Weg geht über
> Ziehen-und-Ablegen … der Prüfstand kann ihn nicht auslösen."*

Das ist der Satz, den [L-53.2](LEKTOR-53.md#l-53.2) im CHANGELOG gefunden hat,
und der dort berichtigt ist. In der Befundzeile selbst steht er unverändert
(am Text belegt: das Urteil am Anfang derselben Zelle sagt *„die Ablehnung von
Gregor am 23.10.2026 an 1.0.122 bestätigt"*). **Form, am Text belegt:** Nach
*„Entschieden von Gregor am 17.10.2026:**"* schließt ein `**`, das nie geöffnet
wurde. Danach ist die Fettschrift der Zelle verschoben, und das „erste kurze
Fettgedruckte" für `pruefe-regressionstest.pl` ist *„Ziehen nach `Out` wird
abgelehnt"* (gemessen, Nachbau `status_von`).

**Vorschlag:** den Satz als *„überholt am 23.10.2026"* kennzeichnen. Das
verwaiste `**` entfernen.

### <a id="l-54.12"></a>L-54.12 — E-142: der Kurzsatz sagt „leere Nachricht", Stufe, Schadensaussage und „Was noch fehlt" sagen noch „Duplikat"

**Gewicht: veraltet in sich, an zwei weiteren Stellen übernommen.** `Intern/BEFUNDE.md:370`; `Intern/TESTPLAN.md:626-628`; `Intern/TESTBERICHT-E125.md:59-60`

Gregors Lauf von heute hat das Bild geändert (am Text belegt, dieselbe Zelle):
*„die neue Nachricht von 23:21:24 hat `To:` leer, `Subject:` leer und keinen
Rumpf. **Schlimmer als ursprünglich beschrieben**"*. Weiter hinten stehen
unmarkiert:

* *„**Kein Datenverlust:** es entsteht eine Kopie zuviel, nichts
  verschwindet."*
* *„**Keine Regression**, vor 1.0.122 genauso"*. Gemessen ist das für die
  leere Nachricht nicht; die Aussage galt dem Duplikat.
* *„**Was noch fehlt:** zweierlei … Erstens die Fehlmeldung … Zweitens die
  Frage, ob ein Entwurf … **verschwinden** soll."* Dass in `Out` eine
  **leere** Nachricht entsteht, steht dort nicht. Damit fehlt genau die
  Behebung, die der Kurzsatz verlangt.
* *„**Stufe: wichtig** (Funktion: Duplikat und eine Meldung …)"*.

`TESTPLAN.md:627` und `TESTBERICHT-E125.md:60` sagen weiter *„liegt danach
doppelt da"*.

**Vermutung zur Stufe:** Die Regel in `BEFUNDE.md:139` stuft als *kritisch*
ein, wenn *„eine Nachricht falsch hinausgeht"*. Eine leere Nachricht in `Out`
ohne Empfänger geht nicht hinaus. Wer aber glaubt, der Entwurf sei verschoben,
und das Original im IMAP-Ordner löscht, verliert ihn. Ob das „Post geht
verloren" ist, ist eine Einstufung, kein Messwert → [Frage 3](#fragen).

**Vorschlag:** die drei Sätze als überholt kennzeichnen. *Was noch fehlt* neu:
*„(1) In `Out` entsteht eine leere Nachricht. Warum der Inhalt beim Neuanlegen
aus einem IMAP-Ordner fehlt, ist nicht gemessen. (2) die falsche Meldung (mit
[E-141](../Intern/BEFUNDE.md#e-141)). (3) Gregors Entscheidung, ob das Original verschwinden soll."* Den
Stufen-Grund auf *„leere Nachricht in Out"* ändern. TESTPLAN und Testbericht
auf *„ergibt eine leere Nachricht in `Out`"*.

### <a id="l-54.13"></a>L-54.13 — E-144: „den Fehler einmal am Programm sehen" ist erledigt, steht aber noch da

**Gewicht: veraltet in sich.** `Intern/BEFUNDE.md:372`

> *„**Was noch fehlt:** die beiden Kopfzeilen beim Neuanlegen übernehmen
> (`compmsgd.cpp:2167`) und den Fehler einmal am Programm sehen."* — weiter
> vorn: *„Gemessen ist nur, dass neu angelegt wird"*

Gregor hat ihn heute gesehen (dieselbe Zelle: *„beide Zeilen sind
**leer**"*, `Out.mbx` 23:28:46). **Vorschlag:** den zweiten Halbsatz
streichen; *„Gemessen ist nur …"* als Stand vor dem 23.10. kennzeichnen. Das
Nachstellen am Prüfstand (`WEITERMACHEN.md:142`) bleibt richtig: es ist der
Regressionsfall, nicht die Bestätigung.

### <a id="l-54.14"></a>L-54.14 — AN-1 und E-133: die Entscheidungen stehen nicht in ihren Befundzeilen

**Gewicht: unvollständig.** `Intern/BEFUNDE.md:248` ([AN-1](../Intern/BEFUNDE.md#an-1)), `:380` ([E-133](../Intern/BEFUNDE.md#e-133)); `Intern/WEITERMACHEN.md:137`

* **[AN-1](../Intern/BEFUNDE.md#an-1)** (ein IMAP-Anhang kann ohne Dateiendung abgelegt werden): Gregors
  *„aufschreiben, jetzt nicht"* und der fertige Plan (Prüfserver um
  BODYSTRUCTURE erweitern, `ImapDownload.cpp:3728`, `:4119`) stehen nur in
  `WEITERMACHEN.md:135`. **Gemessen:** `grep -c "jetzt nicht"
  Intern/BEFUNDE.md` → 1, und der Treffer (`:1537`) gehört nicht zu [AN-1](../Intern/BEFUNDE.md#an-1).
* **[E-133](../Intern/BEFUNDE.md#e-133)** (Eudora startet nicht, wenn das gemerkte Mailverzeichnis fehlt):
  Die Umgehung steht seit heute in `README.md:146` (*„`Eudora starten.cmd`
  benutzen"*). **Gemessen:** in der Befundzeile `:380` null Treffer für
  `starten.cmd` und für `README`.
* `WEITERMACHEN.md:137` schreibt zu [E-133](../Intern/BEFUNDE.md#e-133): *„Das Häkchen beim Auspacken
  ([[E-138](../Intern/BEFUNDE.md#e-138)]) steht in `README.md` und `Doku/ANWENDER.md` — reicht laut
  Gregor."* Das Häkchen gehört zu [E-138](../Intern/BEFUNDE.md#e-138) (Windows
  sperrt die heruntergeladene EXE), nicht zu [E-133](../Intern/BEFUNDE.md#e-133). Die neue README-Zeile zu
  [E-133](../Intern/BEFUNDE.md#e-133) erwähnt der Satz nicht. **Vermutung:** zwei Entscheidungen in einem
  Satz zusammengezogen.

**Vorschlag:** In [AN-1](../Intern/BEFUNDE.md#an-1) und [E-133](../Intern/BEFUNDE.md#e-133) je einen Satz mit Datum und Zitat. In
WEITERMACHEN den Punkt in zwei teilen: [E-133](../Intern/BEFUNDE.md#e-133) mit Umgehung in README, [E-138](../Intern/BEFUNDE.md#e-138)
mit dem Häkchen.

### <a id="l-54.15"></a>L-54.15 — `main` ist nicht mehr 7.2.0.122, nennt sich aber so

**Gewicht: unvollständig (Version eindeutig).** `Eudora71/Version.h:12-14`; `Intern/WEITERMACHEN.md:9`; `CHANGELOG.md:102-106`

**Gemessen:** `Version.h` → `7,2,0,122` / `"7.2.0.122"`; auf `main` stecken
seit heute [E-116](../Intern/BEFUNDE.md#e-116) (`PGHTMIMP.CPP`) und [E-130](../Intern/BEFUNDE.md#e-130) (`BindExe.bat`, fünf DLLs). Ein Bau
aus `main` meldet sich also als 7.2.0.122 und ist nicht das Paket 1.0.122. Der
CHANGELOG sagt das ehrlich (*„die Fassungsnummer bleibt bis dahin 7.2.0.122"*).
Der Einstieg `WEITERMACHEN.md:9` nennt als Quellstand nur *„7.2.0.122 … Zweig
`e-14-gemessen-und-rollen`"*, ohne die beiden Nachträge.

**Vorschlag:** in WEITERMACHEN Zeile 9 einen Halbsatz: *„auf `main` dazu [E-116](../Intern/BEFUNDE.md#e-116)
und [E-130](../Intern/BEFUNDE.md#e-130) (PR #157, #158), noch ohne eigene Nummer"*. Ein Bau aus diesem Stand
sollte nicht als Paket weitergegeben werden, bevor die Nummer steigt
([Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md)).

---

## Teil 4 — `Intern/WEITERMACHEN.md` als Einstieg

### <a id="l-54.16"></a>L-54.16 — vier Einstiegsblöcke von heute; die Marke „HIER WEITERMACHEN" trägt der älteste

**Gewicht: Widerspruch.** `Intern/WEITERMACHEN.md:132-146`

Unter *„Der nächste Schritt"* stehen vier Blöcke vom 23.10.2026 (am Text
belegt):

| Zeile | Block | Stand |
|---|---|---|
| `:132-140` | *Entschieden am 23.10.2026 abends* | spät; [E-116](../Intern/BEFUNDE.md#e-116) noch *„ohne PR"* (veraltet, [L-54.9](#l-54.9)) |
| `:142` | *Reihenfolge seit dem 23.10.2026 spät* | der jüngste |
| `:144` | *Als Erstes in der nächsten Sitzung: der Rückstand* | Nachmittag, nachträglich mit Klammer an `:142` angepasst |
| `:146` | ***Stand 23.10.2026 – HIER WEITERMACHEN.*** | der älteste (vor PR #157) |

**Widersprüche, am Text belegt:**

1. `:146`: *„**Wartet auf Gregor:** sein Ja zum Versionsvorschlag (eine Nummer
   ab 7.2.1.0, Zweig `version-7.2.1.0-eine-nummer`)"*. Entschieden ist
   anders (`:133`, 7.2.1.<Buildnummer>). Einen Zweig dieses Namens gibt es
   nicht (gemessen: `git branch -a | grep -i version` → leer).
2. `:146`: *„offene Fragen an Gregor in [LEKTOR-53](LEKTOR-53.md#fragen)"*.
   Von den sechs Fragen sind vier durch die Entscheidungen vom Abend
   beantwortet (siehe Teil 5 unten).
3. Reihenfolge: `:142` sagt **(1)** Bild-Regressionsfälle, **(2)** [E-119](../Intern/BEFUNDE.md#e-119) und
   [E-113](../Intern/BEFUNDE.md#e-113) beheben, **(3)** alle Bildfälle fahren, **(4)** der übrige Rückstand.
   `:144` sagt *„Neue Themen ([E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119), die Versionsnummer) erst
   danach"*, also nach dem **ganzen** Rückstand. Die Klammer in `:144`
   (*„für die Bildfälle … vorgezogen"*) zieht nur die Bildfälle vor, nicht
   [E-113](../Intern/BEFUNDE.md#e-113) und [E-119](../Intern/BEFUNDE.md#e-119). `ZIEL.md:72` sagt dazu *„vor jedem neuen Thema"*. Wer
   nach `:144` arbeitet, fängt nach den Bildfällen mit [S-1](../Intern/BEFUNDE.md#s-1) an; wer nach `:142`
   arbeitet, mit [E-119](../Intern/BEFUNDE.md#e-119). Gregors Zitat in `:142` (*„nachdem du mit [E-113](../Intern/BEFUNDE.md#e-113) und
   [E-119](../Intern/BEFUNDE.md#e-119) fertig bist"*) spricht für `:142`.

**Vorschlag:** die vier Blöcke zu **einem** Block *„Stand 23.10.2026 abends –
HIER WEITERMACHEN"* zusammenfassen: Entscheidungen, dann **eine** nummerierte
Reihenfolge (die aus `:142`, mit *„danach der übrige Rückstand vor jedem neuen
Thema; [E-77](../Intern/BEFUNDE.md#e-77) und die Versionsnummer erst danach"*). Den bisherigen Block `:146`
als *überholt* kennzeichnen, wie es mit dem Block vom 21.10. (`:148`) schon
geschehen ist.

### <a id="l-54.17"></a>L-54.17 — „88 fehlende Tests" und „50 von 67" auf derselben Seite, ohne zu sagen, was gezählt ist

**Gewicht: Form.** `Intern/WEITERMACHEN.md:142` gegen `:144`

`:142`: *„alle 88 fehlenden Tests 40–60 Std."* — `:144`: *„50 von 67
kritischen Befunden haben keinen Test"*. **Gemessen** (`pruefe-regressionstest.pl`):
Beide Zahlen stimmen. 88 sind *alle* behobenen Befunde ohne Testfall, gleich
welcher Stufe. 50 sind die kritischen ohne jede Prüfung, offene eingeschlossen.
Wer nur eine der Zeilen liest, hält die andere für einen Rechenfehler.

**Vorschlag:** *„88 behobene Befunde ohne Test, davon … kritisch"*, beide Zahlen
aus dem Werkzeug.

---

## <a id="teil-5"></a>Teil 5 — Die offenen Funde aus LEKTOR-53

Stand gegen die Dateien von heute (am Text belegt, wo nicht anders gesagt):

| Fund | worum es ging | heute |
|---|---|---|
| [L-53.10](LEKTOR-53.md#l-53.10) | `ZIEL.md` sagt, der Leseweg von [E-131](../Intern/BEFUNDE.md#e-131) (eine schon beschädigte INI hindert Hermes 7.1 am Start) sei offen; der Befund sagt geschlossen | **bleibt.** `ZIEL.md:37` *„Offen bleibt allein der Leseweg"*, `:39` *„der Leseweg bleibt offen"* unverändert |
| [L-53.11](LEKTOR-53.md#l-53.11) | `ziel-stand.pl` zählt jede Maßstabszeile ohne Befundnummer als erfüllt; drei Zeilen mit Vorbehalt | **zum Teil erledigt.** Adressbuch: entschieden, aber der Satz in der Zelle steht noch ([L-54.4](#l-54.4)). [E-69](../Intern/BEFUNDE.md#e-69) und [E-101](../Intern/BEFUNDE.md#e-101): Gregor lässt sie am Prüfstand rot und grün nachstellen (`WEITERMACHEN.md:136`); damit ist Frage 1 im Sinn von „ich teste, nicht Gregor" beantwortet. **Bleibt:** das Loch im Werkzeug, `ziel-stand.pl:140` unverändert (gemessen: `grep -n "unless (@ids)"`) |
| [L-53.12](LEKTOR-53.md#l-53.12) | BEFUNDE.md verlangt den Test-Rückstand vor 7.2.1.0, ZIEL.md nicht | **entschieden** (Release wartet nicht), **nicht eingearbeitet** in BEFUNDE.md und WEITERMACHEN → [L-54.6](#l-54.6) |
| [L-53.14](LEKTOR-53.md#l-53.14) | Suchindex-Test M2 unter „kritisch", Befund „wichtig" und erledigt | **im Kern erledigt** (M2 abgeschaltet). Rest → [L-54.8](#l-54.8) |
| [L-53.15](LEKTOR-53.md#l-53.15) | Kriterientabelle nennt Quellstand 7.2.0.120; Neumessung der Kriterien fehlt im erzeugten Block | **bleibt.** `ZIEL.md:147` *„Stand 22.10.2026. Quellstand 7.2.0.120"*; `:60-61` unverändert |
| [L-53.16](LEKTOR-53.md#l-53.16) | kein Weg zu einer Marke `v7.2.1.0`, Paketnummer unbestimmt | **zum Teil erledigt.** Nummer entschieden, Paketnummer folgt daraus ([L-54.5](#l-54.5)). **Bleibt:** Werkzeug und Name der Marke → [Frage 1](#fragen) |
| [L-53.17](LEKTOR-53.md#l-53.17) | Kriterium 2 und 4 hängen an „Encountered an improper argument" beim Anzeigen, ohne Befundnummer | **bleibt.** `ZIEL.md:183` unverändert. Ergänzung: `Intern/AUFGABEN.md:244-247` nennt dieselbe Meldung *„den letzten bekannten Fehler, den ein Anwender merkt"*, ebenfalls ohne Kennung |
| [L-53.18](LEKTOR-53.md#l-53.18) | [`A-1`](../Intern/BEFUNDE.md#a-1) heißt in ZIEL.md und BEFUNDE.md zwei verschiedene Dinge | **bleibt.** `ZIEL.md:271`, `:325` gegen `BEFUNDE.md:218` |
| [L-53.19](LEKTOR-53.md#l-53.19) | [E-123](../Intern/BEFUNDE.md#e-123): Listen sagen „Bilder gehen verloren", die eigene Messung sagt: die ausstehende Übertragung geht verloren | **bleibt.** `CHANGELOG.md:44` und `WEITERMACHEN.md:361` zeigen weiter *„der Verlust eingebetteter Bilder"* |
| [L-53.20](LEKTOR-53.md#l-53.20) | „neun Kriterien" und „14 von 18" auf derselben Seite | **bleibt**, jetzt *„15 von 19"* (`ZIEL.md:20`) |
| [L-53.21](LEKTOR-53.md#l-53.21) | Teil M: vor jedem Release oder vor 7.2.1.0? | **erledigt** (`TESTPLAN.md:519-521`); Rest in `:16` → [L-54.8](#l-54.8) |

**Die sechs Fragen aus [LEKTOR-53](LEKTOR-53.md#lektor-53)**: beantwortet sind 2 (Rückstand), 3
([AN-1](../Intern/BEFUNDE.md#an-1), [E-130](../Intern/BEFUNDE.md#e-130), [E-133](../Intern/BEFUNDE.md#e-133)), 4 (M2) und 6 (Teil M). Frage 1 ist für [E-69](../Intern/BEFUNDE.md#e-69) und [E-101](../Intern/BEFUNDE.md#e-101)
praktisch beantwortet (Nachstellen am Prüfstand), nicht ausdrücklich für die
Zählung im Maßstab. Frage 5 ist zur Hälfte beantwortet (Nummer ja, Marke und
Prüfverzeichnisse nein).

---

## Teil 6 — Die Regel „höchstens drei Sätze ohne Kürzel"

### <a id="l-54.18"></a>L-54.18 — die Regel steht nicht dort, wo die Zeilen geschrieben werden

**Gewicht: unvollständig.** `Intern/BEFUNDE.md:1-160`; Regel: `Intern/WEITERMACHEN.md:140`, `Arbeitsweise/befund-in-klartext.md`

**Gemessen:** `grep -n "drei Sätze\|ohne Kürzel"` in `Intern/BEFUNDE.md` →
kein Treffer in der Legende oder im Kopf. Die Notiz sagt selbst
*„Schranke: keine - noch kein Werkzeug"*. Wer eine Zeile fortschreibt, sieht
die Regel nicht. Wie [L-54.1](#l-54.1) zeigt, braucht sie außerdem eine
Bedingung, damit die Werkzeuge sie lesen können.

**Vorschlag:** einen Absatz unter der Legende in `BEFUNDE.md` (*„Wie eine
Befundzeile beginnt"*), mit Beispiel. Erster Satz: was der Anwender merkt.
Zweiter Satz: **Urteilswort zuerst** (*„Offen."*, *„Behoben in 7.2.0.n, von
Gregor bestätigt am …"*). Dritter Satz: was fehlt, und ob Gregor etwas tun
muss.

### <a id="l-54.19"></a>L-54.19 — die sechs heute angefassten Zeilen gegen die Regel

**Gewicht: falsch bzw. Form, je Zeile.** `Intern/BEFUNDE.md`

Gemessen ist der Anfang jeder Zelle (Nachbau des Lesewegs der Werkzeuge, erstes
Fettgedrucktes) und die Zahl der *Was noch fehlt* je Zelle.

| Befund | Zeile | Anfang der Zelle | gegen die Regel |
|---|---|---|---|
| [E-116](../Intern/BEFUNDE.md#e-116) | `:354` | *„offen, am Quelltext belegt (PRUEFER-22, F3, 13.10.2026), nicht am laufenden Programm gesehen."* | **nein.** Kürzel im ersten Satz (`PRUEFER-22`, `F3`), kein Satz über das, was der Anwender sieht, kein Hinweis, dass der Code fertig ist |
| [E-125](../Intern/BEFUNDE.md#e-125) | `:363` | *„behoben in 7.2.0.122 – die Ablehnung von Gregor … bestätigt, die Gegenprobe … gemessen"* | **zum Teil.** Kein Kürzel, aber auch kein Satz, was der Anwender merkt. Danach sofort *„Vorher: offen …"* und ein verwaistes `**` ([L-54.11](#l-54.11)) |
| [E-130](../Intern/BEFUNDE.md#e-130) | `:368` | *„Kurz: Nach jedem Bau waren fünf … DLLs von QUALCOMM verändert … Behoben am 23.10.2026 im Zweig `fix_ohne_tests`; für Gregor ist nichts zu tun."* | **ja** (zwei Sätze, verständlich). Werkzeuge erkennen *behoben* nicht ([L-54.2](#l-54.2)); weiter hinten veraltet ([L-54.10](#l-54.10)) |
| [E-132](../Intern/BEFUNDE.md#e-132) | `:381` | *„behoben und ausgeliefert: die Rückfrage steckt in `v1.0.117` (… 07:56:56 UTC), ihr Fehlerfall in `v1.0.120` (…)"* | **nein.** *„ihr Fehlerfall"* ist ohne die Herleitung nicht zu verstehen, und Gregors Bestätigung des Starttests (vom CHRONIST belegt) steht erst tief in der Zelle |
| [E-142](../Intern/BEFUNDE.md#e-142) | `:370` | *„Kurz: Wer einen Entwurf aus einem IMAP-Ordner … nach `Out` zieht, bekommt dort eine leere Nachricht … Die Behebung fehlt noch."* | **ja**, drei Sätze. Werkzeuge sehen ihn nicht mehr als offen ([L-54.1](#l-54.1)); dahinter veraltet ([L-54.12](#l-54.12)) |
| [E-144](../Intern/BEFUNDE.md#e-144) | `:372` | *„Kurz: Ein gespeicherter Antwortentwurf … verliert die Angabe, worauf er antwortet … Die Behebung fehlt noch."* | **ja**, vier Sätze (einer zu viel, harmlos). Werkzeuge sehen ihn nicht mehr ([L-54.1](#l-54.1)) |

**Die fünf offenen Zeilen, die am dringendsten so umgeschrieben werden
müssten.** Ausgewählt nach: kritisch oder als Nächstes in Arbeit, Länge der
Zelle, und ob der Anfang heute in die Irre führt. Gemessen: Länge des Urteils
in Zeichen und Zahl der *Was noch fehlt* je Zelle.

| | Befund | worum es geht | warum zuerst |
|---|---|---|---|
| 1 | [E-123](../Intern/BEFUNDE.md#e-123) (`:361`, kritisch, 6.988 Zeichen, 2× *Was noch fehlt*) | was verloren geht, wenn Eudora mitten im Verschieben in einen IMAP-Ordner abstürzt | Der Anfang lautet *„Der Beenden-Weg ist … bestätigt"* und klingt nach erledigt. Das erste *Was noch fehlt* nennt den falschen Schaden ([L-53.19](LEKTOR-53.md#l-53.19)). Von dort kommt der Rat in der README |
| 2 | [E-129](../Intern/BEFUNDE.md#e-129) (`:367`, kritisch, 7.176 Zeichen, 2×) | nach Verschieben ohne Verbindung und sofortigem Beenden zeigt der Ordner nur eine von fünf Nachrichten | längste offene Zeile. Gregors eigene Frage (*„sind sie weg?"*) wird erst nach Messwerten beantwortet; die beiden *Was noch fehlt* sagen dasselbe zweimal verschieden |
| 3 | [E-124](../Intern/BEFUNDE.md#e-124) (`:362`, kritisch, 6.695 Zeichen, 2×) | Defender hält Eudora für einen Trojaner | Der Anfang *„offen (nicht im Code behebbar) … Schranke eingebaut"* sagt nicht, dass die Meldung bei Microsoft abgewiesen ist und **wer** neu einreichen muss. Das steht nur im zweiten *Was noch fehlt* |
| 4 | [AN-1](../Intern/BEFUNDE.md#an-1) (`:248`, kritisch, 1.614 Zeichen) | ein IMAP-Anhang kann ohne Dateiendung abgelegt werden und lässt sich dann nicht öffnen | Der Anfang nennt *„B5.7"* als einziges Offenes, also ein Kürzel. Gregors Entscheidung von heute fehlt ([L-54.14](#l-54.14)) |
| 5 | [E-113](../Intern/BEFUNDE.md#e-113) (`:351`, wichtig, 2.815 Zeichen) | breite Bilder laufen rechts aus dem Fenster | Nach Gregors Reihenfolge der nächste Bau (zusammen mit [E-119](../Intern/BEFUNDE.md#e-119)), und Zeile im Maßstab. Der Anfang *„offen, von Gregor am 18.09.2026 angeordnet"* sagt nicht, was der Anwender sieht. *Was noch fehlt* beginnt mit *„alles —"* |

Knapp dahinter [E-119](../Intern/BEFUNDE.md#e-119) (graue Kästen statt
`data:`-Bildern), aus demselben Grund wie [E-113](../Intern/BEFUNDE.md#e-113).

---

## <a id="fragen"></a>Was nur Gregor entscheiden kann

1. **Wie heißt die Marke des Releases auf GitHub: `v1.0.123` wie bisher, oder
   `v7.2.1.123`?** Die Nummer im Programm ist entschieden (7.2.1.<Buildnummer>).
   `release-veroeffentlichen.ps1` bildet die Marke heute immer als `v1.0.<n>`,
   `ZIEL.md:62` verlangt `v7.2.1.0`. Dazu der zweite Teil der alten Frage 5:
   Sollen alle Prüfstandsverzeichnisse vor dem letzten Regressionslauf auf die
   Fassung des Releases gehoben werden? ([L-54.5](#l-54.5), [L-53.8](LEKTOR-53.md#l-53.8))
2. **Heißt das nächste Paket 7.2.0.123 oder schon 7.2.1.123?** Der CHANGELOG
   sagt *„Beim nächsten Paket wird dieser Abschnitt zu 7.2.0.123"*
   (`CHANGELOG.md:105-106`). Gilt die neue Nummer erst für das Release oder ab
   sofort für jedes Paket? ([L-54.5](#l-54.5))
3. **Ist [E-142](../Intern/BEFUNDE.md#e-142) jetzt kritisch?** Statt einer
   Kopie zu viel entsteht in `Out` eine **leere** Nachricht, das Original bleibt
   im IMAP-Ordner. Wer es dort löscht, weil er es für verschoben hält, verliert
   den Entwurf. Heute: *wichtig* ([L-54.12](#l-54.12))
4. **Soll die Regel für Befundzeilen ausdrücklich verlangen, dass der zweite
   Satz mit „Offen." oder „Behoben in …" beginnt?** Ohne diese Bedingung
   sehen die Werkzeuge die neu geschriebenen Zeilen nicht mehr
   ([L-54.1](#l-54.1), [L-54.2](#l-54.2), [L-54.18](#l-54.18)).

---

## Geprüft und in Ordnung

* **[E-130](../Intern/BEFUNDE.md#e-130) im CHANGELOG** (`CHANGELOG.md:116-123`): Ursache, Behebung und
  Messung stimmen mit `BEFUNDE.md:368` überein. Für den Anwender steht *„ändert
  sich nichts"*. Das ist richtig: In den Paketen lagen immer die Originale.
* **[E-116](../Intern/BEFUNDE.md#e-116) im CHANGELOG** (`:108-115`): *„Am laufenden Programm noch nicht
  gesehen — deshalb im Befund ‚eingebaut', nicht ‚behoben'"*. Richtig und
  ehrlich. *„280 Tests, 280 bestanden"* steht gleich in BEFUNDE.md:354.
* **Teil M** heißt in `TESTPLAN.md:519-521` und `ZIEL.md:67` übereinstimmend
  *„vor 7.2.1"* bzw. *„7.2.1.x"*; „vor jedem Release" für Teil M steht nur noch
  im erzeugten Prüfbericht ([L-54.8](#l-54.8)).
* **[E-133](../Intern/BEFUNDE.md#e-133) in der README** (`README.md:146`): Meldungstext, Umgehung und
  Gregors Zitat stimmen mit `BEFUNDE.md:380` überein.
* **[L-53.9](LEKTOR-53.md#l-53.9)**: `WEITERMACHEN.md:10-11` nennen jetzt
  7.2.0.121 und `v1.0.120`, der Block vom 21.10. ist als überholt gekennzeichnet.
* **`perl tools/doku-pruefen.pl`**: kein Widerspruch zwischen Dokumenten; die
  14 Hinweise betreffen datierte Release-Notizen und Hintergrundtexte.
* **„Doku fehlt" für die Adressbuch-Taste** steht in keiner Datei mehr
  (gemessen: `grep -n "Doku fehlt"` → kein Treffer). Übrig ist nur der Satz
  aus [L-54.4](#l-54.4).

## Nicht geprüft

* Ob `pruefe-regressionstest.pl` [E-14](../Intern/BEFUNDE.md#e-14) wegen der Marke als *manuell geprüft*
  zählt ([L-54.8](#l-54.8), Vermutung).
* Ob die Gegenprobe zu [E-130](../Intern/BEFUNDE.md#e-130) (*„5 Tests"*) irgendwo als wiederholbarer Fall
  liegt ([L-54.2](#l-54.2)).
* Der Code von [E-116](../Intern/BEFUNDE.md#e-116) und `BindExe.bat`. Das ist Sache des PRÜFERS, nicht des
  Lektorats.
