# <a id="lektor-55"></a>LEKTOR-55 — Bestandsprüfung vor dem Paket 7.2.0.123 (E-77, E-113, E-116, E-119, E-130), 24.10.2026

**Auftrag.** Vor dem Paket 7.2.0.123, dem Kandidaten für das Release 7.2.1.
Seit [LEKTOR-54](LEKTOR-54.md#lektor-54) gemergt: PR #161 ([E-130](../Intern/BEFUNDE.md#e-130) vollständig,
Schranke `pruefe-befund-anfang.pl`, [LEKTOR-54](LEKTOR-54.md#lektor-54) und PRÜFER-48 eingearbeitet),
#162 (Bild-Regressionsfälle, `tools/messen-bild.ps1`), #163 (E-119
`data:`-Bilder), #164 ([E-113](../Intern/BEFUNDE.md#e-113) zu breite Bilder), #165 ([E-77](../Intern/BEFUNDE.md#e-77) IMAP-Ordnernamen),
`git log e5e45de5..bcbce2fb`. Geprüft wurde **der Bestand**, nicht der Diff:
alle 182 `.md` aus `git ls-files '*.md'` ohne `Arbeitsweise/`. Maßstab von
außen: `Eudora71/Version.h` (`7.2.0.122`), `VERSION` (`1.0.122`), `git tag`
(zuletzt `v1.0.120`), `Releases/PAKETE.md` (zuletzt 1.0.122),
`Intern/BEFUNDE.md`, `git log`.

**Ergebnis vorweg.** Die fünf Behebungen sind im CHANGELOG richtig
beschrieben. Ihre eigenen Befundzeilen sagen aber noch *„auf dem Zweig"*,
und dahinter steht jeweils der alte Satz *„Was noch fehlt: die Behebung"*.
Einstieg, Aufgabenliste, Maßstab und Anwenderdoku nennen [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113) und
[E-119](../Intern/BEFUNDE.md#e-119) weiter offen, oder sie nennen sie gar nicht. **Für Gregors eine
Testsitzung am Paket 7.2.0.123 gibt es keinen Testplan.** `TESTPLAN.md` ist
der Plan für 1.0.122 und sagt *„Im Moment nichts"*. Die *Prüfung aller neun
Kriterien*, die `ZIEL.md` vor dem Release verlangt, hat in `TESTPLAN.md` keinen
einzigen Schritt. Das Wort „Kriterium" kommt dort nicht vor. *„18 von 19
erfüllt"* zählt Zeilen ohne offenen Befund, nicht Erfülltes. Würde [E-116](../Intern/BEFUNDE.md#e-116)
geschlossen, stünde dort *„alle erfüllt"*, obwohl zwei der neun Kriterien
*„fast"* heißen und drei Behebungen noch in keinem Paket stecken.

**19 Funde**: 5 veraltet, 5 Widerspruch, 5 unvollständig, 3 falsch (einer
davon in einem Werkzeug), 1 Form. **Fünf Fragen an Gregor** stehen gesammelt
am Ende, die **Testplan-Liste** für 7.2.0.123 in Teil 3.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **am Text
belegt** (Zitat mit Datei:Zeile), **Vermutung**.

---

## Teil 1 — Der Stand „Seit 7.2.0.122, noch ohne Paket", überall gleich?

### <a id="l-55.1"></a>L-55.1 — E-77, E-113 und E-119 stehen in ihren eigenen Zeilen noch „auf dem Zweig“, dahinter „Was noch fehlt: die Behebung“

**Gewicht: veraltet.** `Intern/BEFUNDE.md:324` ([E-77](../Intern/BEFUNDE.md#e-77)), `:359` ([E-113](../Intern/BEFUNDE.md#e-113)), `:365` ([E-119](../Intern/BEFUNDE.md#e-119))

Worum es geht: Drei Fehler sind behoben. IMAP-Ordner mit Umlauten hießen
`Entw&APw-rfe` statt *Entwürfe* ([E-77](../Intern/BEFUNDE.md#e-77)). Zu breite Bilder liefen im
Verfassen-Fenster rechts hinaus ([E-113](../Intern/BEFUNDE.md#e-113)). Bilder, die direkt im HTML stecken,
waren beim Antworten ein grauer Kasten ([E-119](../Intern/BEFUNDE.md#e-119)).

Das Urteil, jeweils am Zeilenanfang:

> `:324` *„**behoben auf dem Zweig `e-77-imap-ordnernamen` (24.10.2026), kommt mit Paket 7.2.0.123; …**"*
> `:359` *„**behoben (Variante A) auf dem Zweig `e-113-breite-bilder` (24.10.2026), kommt mit Paket 7.2.0.123; …**"*
> `:365` *„**behoben auf dem Zweig `e-119-data-bilder` (24.10.2026), kommt mit Paket 7.2.0.123; …**"*

**Was stimmt (gemessen,** `git log --oneline e5e45de5..bcbce2fb`**):** Alle
drei sind auf `main`: `8f81d2a5` Merge PR #163 ([E-119](../Intern/BEFUNDE.md#e-119)), `0b5b93be` PR #164
([E-113](../Intern/BEFUNDE.md#e-113)), `bcbce2fb` PR #165 ([E-77](../Intern/BEFUNDE.md#e-77)).

Schwerer wiegt der Schwanz derselben Zellen, am Text belegt:

| Befund | Satz weiter hinten in der Zelle | stimmt nicht mehr, weil |
|---|---|---|
| [E-77](../Intern/BEFUNDE.md#e-77) `:324` | *„**Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — unverändert offen … Eine Dekodierung gibt es also nach wie vor nicht. **Was noch fehlt:** die Behebung"* | die Dekodierung steht seit PR #165 in `ImapMailbox.cpp` |
| [E-77](../Intern/BEFUNDE.md#e-77) `:324` | *„**Wie zu pruefen:** **ICH** — am eigenen IMAP-Prüfserver … Einen Ordner `Entwürfe` anlegen"* | dieselbe Zeile sagt vorher: *„der IMAP-Prüfserver kennt `CREATE` und `RENAME` nicht"*. Der Schritt ist am Prüfstand nicht ausführbar |
| [E-113](../Intern/BEFUNDE.md#e-113) `:359` | *„**Zuletzt belegt am Quelltext: 22.10.2026** — bleibt offen … Einen Deckel gibt es weiterhin nicht"*, *„**Was noch fehlt:** alles"* | `E113Deckeln` steht seit PR #164 in `PgEmbeddedImage.cpp` |
| [E-113](../Intern/BEFUNDE.md#e-113) `:359` | *„**Wie zu pruefen:** … Danach Fenstergröße ändern und noch einmal sehen."* | dieser Schritt wird **rot**: Variante B ist nicht gebaut (dieselbe Zeile, Satz 3) |
| [E-119](../Intern/BEFUNDE.md#e-119) `:365` | *„**Was noch fehlt:** der Einbau"*; *„**Zuletzt belegt am Quelltext: 22.10.2026** — der Mangel steht unverändert"* | `E119DataNachDatei` steht seit PR #163 in `PGHTMIMP.CPP` |

Die erzeugten Listen sind davon nicht betroffen. Sie lesen nur das Urteil vorn,
und [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113) und [E-119](../Intern/BEFUNDE.md#e-119) stehen richtig nicht unter *Noch offen*
(gemessen: `perl tools/offene-befunde.pl` → 37 offen, keiner der drei).

**Vorschlag:** im Urteil *„behoben in 7.2.0.123 (auf `main` seit PR #16x,
noch ohne Paket)"*. Beim Schnüren wird daraus *„behoben in 7.2.0.123"*.
Die alten *Was noch fehlt* und *Zuletzt belegt* als *„Bis 24.10.2026 stand
hier: …"* kennzeichnen, wie es [E-130](../Intern/BEFUNDE.md#e-130) schon tut. *Wie zu prüfen* auf den
heutigen Regressionsfall umschreiben (`E-77a`–`c`, `E-113p`, `E-119a`–`c` in
`tools/pruefstand-faelle.txt:186-204`).

### <a id="l-55.2"></a>L-55.2 — E-116: „es fehlt eine Prüfnachricht“, während dieselbe Zeile die Messung mit genau dieser Prüfnachricht beschreibt

**Gewicht: Widerspruch.** `Intern/BEFUNDE.md:362`; erzeugt daraus `CHANGELOG.md:43`, `Intern/WEITERMACHEN.md:363`, `ZIEL.md:28`; dazu `CHANGELOG.md:107-109`

Worum es geht: Ein Bild mit `width="35px"` wurde riesig breit gezeichnet
([E-116](../Intern/BEFUNDE.md#e-116)). Die Behebung ist seit PR #157 auf
`main`.

> `:362`, Mitte: *„**Am Programm gemessen am 24.10.2026, und dabei NICHT rot nachgestellt:** Prüfnachricht `Testdaten/e116-breite-mit-einheit.eml` … die neue Fassung malt `width="35px"` als `gemalt=35x35` …, **die alte 7.2.0.120 aber genauso**"*
>
> `:362`, hinten: *„**Was noch fehlt:** die Messung am laufenden Programm — **am laufenden Programm noch nicht gesehen**, es fehlt eine Prüfnachricht mit `<img width="35px">`, auf der das Bild vorher zu breit war."*
>
> `:362`, Schluss: *„**Zuletzt belegt am Quelltext: 23.10.2026 an 7.2.0.122** — Behebung auf dem Zweig `e-116-bildbreite-px`"*

**Was stimmt (am Text belegt):** Die Prüfnachricht gibt es
(`Testdaten/README.md:40`). Gemessen wurde mit ihr, und der Fehler war auf dem
Weg *Öffnen/Weiterleiten* auch an der **alten** Fassung nicht zu sehen.
`tools/pruefstand-faelle.txt:167` hält das fest: *„NICHT abgedeckt, am
24.10.2026 gemessen: (1) [E-116](../Intern/BEFUNDE.md#e-116) - auch 7.2.0.120 malt …"*. Was fehlt, ist also
kein Prüfstück. Es fehlt **ein Weg, auf dem der Fehler sichtbar wird**. Der
Satz *„es fehlt eine Prüfnachricht"* geht über das erzeugte *Was noch fehlt*
wortgleich in drei Dateien und in den Maßstab.

Der CHANGELOG benutzt dazu ein drittes Wort:

> `CHANGELOG.md:107-109`: *„**Am laufenden Programm noch nicht gesehen** — deshalb im Befund ‚eingebaut', nicht ‚behoben'."*

Im Befund steht nicht *eingebaut*, sondern **offen** (`:362`, Urteil). Für
den Anwender ändert sich durch die Behebung nach heutigem Wissen nichts
Sichtbares. Auch das sagt der CHANGELOG nicht.

**Vorschlag:** *Was noch fehlt* in `:362` ersetzen durch: *„ein Weg, auf dem
der Fehler am Programm sichtbar wird (Kandidat laut Zelle: Antworten im reinen
Paige-Weg, ungemessen); wird keiner gefunden, entscheidet Gregor, ob die
Testsuite mit Gegenprobe als Beleg genügt ([Frage 2](#fragen))."* Die
Zeitmarke auf *„**Zuletzt gemessen: 24.10.2026 an …**"*. Im CHANGELOG
*„eingebaut"* durch das Urteilswort des Befunds ersetzen und einen Satz
ergänzen: *„Auf den bisher gemessenen Wegen war der Fehler auch vorher nicht
zu sehen."*

### <a id="l-55.3"></a>L-55.3 — CHANGELOG: „Gemergt am 23.10.2026 (PR #157 und #158)“ über einem Abschnitt, der zur Hälfte am 24.10. kam

**Gewicht: veraltet.** `CHANGELOG.md:98-100`

> *„**Gemergt am 23.10.2026 (PR #157 und #158), noch nicht als Paket gebaut;
> die Fassungsnummer bleibt bis dahin 7.2.0.122.**"*

**Was stimmt (gemessen,** `git log`**):** Die Überschrift `:96` nennt fünf
Befunde. [E-119](../Intern/BEFUNDE.md#e-119), [E-113](../Intern/BEFUNDE.md#e-113) und [E-77](../Intern/BEFUNDE.md#e-77) kamen am 24.10.2026 mit PR #163, #164 und #165,
der Nachtrag zu [E-130](../Intern/BEFUNDE.md#e-130) mit PR #161.

**Vorschlag:** *„Gemergt am 23. und 24.10.2026 (PR #157, #158, #161, #163,
#164, #165), noch nicht als Paket gebaut …"*.

### <a id="l-55.4"></a>L-55.4 — Einstieg, Aufgaben und Portierung nennen zwei oder drei der fünf; die Reihenfolge ist abgearbeitet und steht als offen da ([L-54.15](LEKTOR-54.md#l-54.15) fortgesetzt)

**Gewicht: veraltet.** `Intern/WEITERMACHEN.md:9`, `:132-137`; `Intern/AUFGABEN.md:3`, `:100-104`, `:414`, `:416`; `Intern/PORTIERUNG.md:44`

Am Text belegt:

* `WEITERMACHEN.md:9` (Kopfzeile *Quellstand*): *„**7.2.0.122** … Zweig
  `e-14-gemessen-und-rollen` — [E-125](../Intern/BEFUNDE.md#e-125) …"*. Kein Wort von den fünf
  Behebungen auf `main`. Das war [L-54.15](LEKTOR-54.md#l-54.15) mit zwei
  Behebungen, jetzt sind es fünf.
* `WEITERMACHEN.md:132`, der Block *HIER WEITERMACHEN*: *„auf `main` stecken
  aber schon [E-116](../Intern/BEFUNDE.md#e-116) und [E-130](../Intern/BEFUNDE.md#e-130), die beim nächsten Paket **7.2.0.123**
  dazukommen"*. [E-119](../Intern/BEFUNDE.md#e-119), [E-113](../Intern/BEFUNDE.md#e-113) und [E-77](../Intern/BEFUNDE.md#e-77) fehlen.
* `:134-137`, *Die Reihenfolge*: Schritt 1 (Bild-Regressionsfälle) ist PR #162,
  Schritt 2 ([E-119](../Intern/BEFUNDE.md#e-119) und [E-113](../Intern/BEFUNDE.md#e-113)) ist PR #163 und #164. Beide stehen ohne Haken da.
  [E-77](../Intern/BEFUNDE.md#e-77) kam ohne Eintrag in diese Reihenfolge dazu. Ob Schritt 3 (*„Alle
  Bildfälle fahren"*) gelaufen ist, sagt die Datei nicht (die Commit-Nachricht `a865e980`
  nennt *„18 von 18 gruen"* nur für PR #162; nicht weiter gesucht).
* `AUFGABEN.md:3`: *„(auf `main` dazu [E-116](../Intern/BEFUNDE.md#e-116), [E-130](../Intern/BEFUNDE.md#e-130) **und mit diesem Zweig
  [E-119](../Intern/BEFUNDE.md#e-119)**, noch ohne Paket)"*. Das ist ein Satz aus der Sicht eines Zweigs,
  der auf `main` gelandet ist. [E-113](../Intern/BEFUNDE.md#e-113) und [E-77](../Intern/BEFUNDE.md#e-77) fehlen.
* `AUFGABEN.md:100`: *„**Weiter offen: [E-113](../Intern/BEFUNDE.md#e-113)**"*.
* `AUFGABEN.md:414` ([E-116](../Intern/BEFUNDE.md#e-116)) *„offen ist nur die Messung am laufenden
  Programm"*; `:416` ([E-119](../Intern/BEFUNDE.md#e-119)) *„Messen, ob 1.0.84 dasselbe zeigt; dann Bau
  …"*. Der Bau ist geschehen.
* `PORTIERUNG.md:44`: der jüngste Stand-Absatz ist der vom 23.10.2026,
  Zweig `e-14-gemessen-und-rollen`.

**Dazu, als Vermutung:** Alle Messungen vom 24.10.2026 liefen an einem Bau, der
sich als **7.2.0.122** meldet. `tools/pruefstand-faelle.txt:159` schreibt
selbst *„an 7.2.0.122 (Bau mit [E-116](../Intern/BEFUNDE.md#e-116))"*. Wer später *„gemessen an 7.2.0.122"*
liest, hält das für das Paket 1.0.122, und das hatte keine dieser
Behebungen ([Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md)).

**Vorschlag:** Eine Zeile, aus der die anderen verweisen: in
`WEITERMACHEN.md:9` *„auf `main` dazu [E-116](../Intern/BEFUNDE.md#e-116), [E-130](../Intern/BEFUNDE.md#e-130), [E-119](../Intern/BEFUNDE.md#e-119), [E-113](../Intern/BEFUNDE.md#e-113), [E-77](../Intern/BEFUNDE.md#e-77) (PR
#157–#165), noch ohne eigene Nummer; Messungen vom 24.10. laufen an diesem
Bau"*. In `:134-137` Schritt 1 und 2 als erledigt markieren, mit PR-Nummer.
`AUFGABEN.md:3`, `:100`, `:414`, `:416` nachziehen. Beim Schnüren ist der
Satz ohnehin fällig.

### <a id="l-55.5"></a>L-55.5 — der Maßstab zählt E-77 oben als erfüllt und nennt es unten das, „was Kriterium 2 noch fehlt“

**Gewicht: Widerspruch (im Maßstab selbst).** `ZIEL.md:169`, `:177-181` gegen `ZIEL.md:20`, `:45`

> `:169` (Zeile **2a**, *offen zu Kriterium 2*): *„[**E-77**](../Intern/BEFUNDE.md#e-77): IMAP-Postfachnamen mit Umlauten stehen roh da …"*
>
> `:177-180`: *„Was Kriterium 2 noch fehlt, steht vollständig in der Zeile **2a**: [**E-77**](../Intern/BEFUNDE.md#e-77) (IMAP-Postfachnamen mit Umlauten) und die Meldung „Encountered an improper argument" …"*

**Was stimmt:** [E-77](../Intern/BEFUNDE.md#e-77) ist behoben (`BEFUNDE.md:324`), und der erzeugte Block
oben in derselben Datei zählt seine Zeile `:45` als erfüllt (gemessen:
`perl tools/ziel-stand.pl` → *„18 von 19 erfüllt, 1 offen"*, offen nur [E-116](../Intern/BEFUNDE.md#e-116)).
Dieselbe Datei sagt also oben erfüllt und unten offen. Dasselbe Muster hat
`ZIEL.md:183-189` am 22.10.2026 schon einmal berichtigt ([E-86](../Intern/BEFUNDE.md#e-86), *„Gefunden hat
alle drei Gregor, nicht die Schranken"*). Die Zeilen `:45-48` nennen für [E-77](../Intern/BEFUNDE.md#e-77),
[E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) und [E-116](../Intern/BEFUNDE.md#e-116) nur das Symptom, ohne Stand. Alle Nachbarzeilen
(`:44`, `:50-52`) tragen ihren Stand in Klammern.

**Vorschlag:** `:169` und `:177-181`: [E-77](../Intern/BEFUNDE.md#e-77) mit Datum herausnehmen, wie es bei
[E-86](../Intern/BEFUNDE.md#e-86) gemacht wurde. Übrig bleibt die Meldung „improper argument"
([L-53.17](LEKTOR-53.md#l-53.17), weiter offen, siehe Teil 6). In
`:45-48` den Stand anhängen: *„(behoben in 7.2.0.123, noch ohne Paket)"*,
bei [E-113](../Intern/BEFUNDE.md#e-113) mit *„Variante A; B nicht gebaut"*.

### <a id="l-55.6"></a>L-55.6 — die Liste „Bekannte Fehler“ in drei Anwenderdateien: richtig für 1.0.122, falsch ab 7.2.0.123, und kein Schritt sorgt für das Nachziehen

**Gewicht: unvollständig.** `README.md:158`, `:159`, `:161`; `Doku/ANWENDER.md:32`, `:41-44`; `Intern/EINSTELLUNGEN.md:219-222`

> `README.md:158`: *„Bilder, die als `data:` im HTML stecken, erscheinen beim Antworten und Weiterleiten als grauer Kasten"* ([E-119](../Intern/BEFUNDE.md#e-119))
> `README.md:159`: *„Sehr breite Bilder laufen rechts aus dem Fenster; Größenangaben wie `35px` können ein Bild verzerren"* ([E-113](../Intern/BEFUNDE.md#e-113), [E-116](../Intern/BEFUNDE.md#e-116))
> `README.md:161`: *„IMAP-Ordnernamen mit Umlauten stehen roh da"* ([E-77](../Intern/BEFUNDE.md#e-77))
> `Doku/ANWENDER.md:32`: *„([**E-77**](../Intern/BEFUNDE.md#e-77), offen)"*; `:42`: *„([**E-119**](../Intern/BEFUNDE.md#e-119), offen, am Protokoll belegt)"*
> `Intern/EINSTELLUNGEN.md:221`: *„(Befund [**E-77**](../Intern/BEFUNDE.md#e-77), offen, CHANGELOG.md unter *Noch offen*)"*. Unter *Noch offen* steht [E-77](../Intern/BEFUNDE.md#e-77) nicht mehr

**Was stimmt:** Die README nennt als Stand *„7.2.0.122 / `VERSION` 1.0.122"*
(`README.md:98`). Für dieses Paket sind die Zeilen richtig. Ab dem Paket
7.2.0.123 sind vier davon falsch. Bei [E-125](../Intern/BEFUNDE.md#e-125) hat die README die Form dafür
schon: *„**Bis `v1.0.120`:** … **Ab Paket 1.0.122** lehnt Eudora … ab"*
(`README.md:164`). `ANWENDER.md:7` verspricht: *„Hier steht nur, was heute
fehlt."* `EINSTELLUNGEN.md:221` verweist auf eine Liste, in der [E-77](../Intern/BEFUNDE.md#e-77) nicht
mehr steht. Das ist schon heute falsch.

**Vorschlag:** In den Paketschritt eine Liste aufnehmen. Beim Schnüren von
7.2.0.123 die drei Zeilen der README auf die E-125-Form umstellen
(*„Bis 1.0.122: …; ab 7.2.0.123 behoben"*). In der E-113-Zeile bleibt
Variante B ([L-55.8](#l-55.8)), in der E-116-Zeile bleibt, was Gregor
entscheidet. Dazu die zwei Zeilen in `ANWENDER.md` entfernen, wie dort
verlangt. `EINSTELLUNGEN.md:219-222` jetzt schon berichtigen.

### <a id="l-55.7"></a>L-55.7 — die Schranke, die genau das finden soll, sieht „(E-77, offen)“ nicht

**Gewicht: falsch (Werkzeug, lautlos).** `tools/pruefe-befundurteile.pl:225-229`, `:248-260`

**Gemessen:** `perl tools/pruefe-befundurteile.pl` → *„Kein Dokument erklaert
einen offenen Befund fuer erledigt — und keinen behobenen fuer unerledigt."*
Das ist falsch für `Doku/ANWENDER.md:32` und `:42` (siehe [L-55.6](#l-55.6)).

**Ursache, am Quelltext belegt:** Die Gegenrichtung (*behoben, aber als
unerledigt geführt*) schlägt nur bei den Wörtern in `@unerledigt` an
(`:225-229`: *nicht angewandt, nicht begonnen, liegt bereit, … noch nicht
beurteilt*). *„offen"* ist dort bewusst nicht enthalten, weil es *„zu häufig
in Nebensätzen"* steht (`:214`). Die Form *„([E-77](../Intern/BEFUNDE.md#e-77), offen)"* direkt hinter der
Kennung kennt das Werkzeug für die **andere** Richtung schon (`:324`: *„Steht
die Kennung selbst als offen da — „([E-67](../Intern/BEFUNDE.md#e-67), offen)""*). Für diese Richtung kennt
es sie nicht. `Intern/EINSTELLUNGEN.md` steht außerdem nicht in der Liste
`:248-260`.

**Vorschlag:** In der Gegenrichtung *„(E-nn, offen"* (Kennung, Komma, *offen*
direkt dahinter) als unerledigt werten. Den Gegentest an der heutigen
`ANWENDER.md:32` fahren, die Positivprobe an einer Zeile mit *„[E-101](../Intern/BEFUNDE.md#e-101) … offen
bleibt F2"*, die nicht anschlagen darf
([Schranke gegentesten](../Arbeitsweise/schranke-gegentesten.md)). Dazu
entscheiden, ob `EINSTELLUNGEN.md` ein Leserdokument ist.

### <a id="l-55.8"></a>L-55.8 — Variante B von E-113 fällt aus jeder Liste

**Gewicht: unvollständig.** `Intern/BEFUNDE.md:359`; `Intern/WEITERMACHEN.md:254`; `Intern/AUFGABEN.md:100-104`; `CHANGELOG.md:132-134`

Worum es geht: Gregor hat zu [E-113](../Intern/BEFUNDE.md#e-113) zwei Stufen angeordnet: A = beim Laden
einpassen, B = beim Ziehen am Fenster mitwachsen. Sein Wortlaut:

> `WEITERMACHEN.md:254`: *„ok, erst A, dann B"*; ebenso `BEFUNDE.md:359` und `AUFGABEN.md:102`.

**Gemessen:** A ist gebaut, das Urteil lautet *behoben*, und damit steht [E-113](../Intern/BEFUNDE.md#e-113)
in keiner erzeugten Liste mehr (`perl tools/offene-befunde.pl` → kein [E-113](../Intern/BEFUNDE.md#e-113)).
`git grep -n "Variante B" -- '*.md' ':!Arbeitsweise'` findet nur zwei
erklärende Sätze (`CHANGELOG.md:133`, `BEFUNDE.md:359`) und einen fremden
Treffer (`PRUEFER-18.md:143`). Es gibt keine Zeile, in der B als offen gezählt
wird. Was Gregor angeordnet hat, ist damit aus dem Bestand verschwunden, ohne
dass er es entschieden hat
([Liste aus einer Quelle](../Arbeitsweise/liste-aus-einer-quelle.md)).

Hinzu kommt: `:359` *Wie zu prüfen* verlangt *„Danach Fenstergröße ändern und
noch einmal sehen"*. Wer den Schritt befolgt, sieht genau das nicht Gebaute
([L-55.1](#l-55.1)).

**Vorschlag:** B als eigenen Befund aufnehmen, mit offenem Urteil und dem Satz
aus `:359` (*„ob Paige dafür einen Einstiegspunkt bietet, ist **nicht
untersucht**"*). Ob er zu 7.2.1 gehört, entscheidet Gregor ([Frage 3](#fragen)).

### <a id="l-55.9"></a>L-55.9 — E-130 ist behoben, die Zelle sagt weiter „Offen: wer stempelt“ und „bleibt offen“ ([L-54.10](LEKTOR-54.md#l-54.10) zum Teil erledigt)

**Gewicht: veraltet.** `Intern/BEFUNDE.md:376`

Das Urteil vorn ist richtig und beginnt mit dem Urteilswort (gemessen:
`perl tools/pruefe-befund-anfang.pl --bestand` führt [E-130](../Intern/BEFUNDE.md#e-130) nicht unter den 32
Zeilen ohne Urteil vorn). Am Text belegt bleiben in derselben Zelle stehen:

* *„**Offen:** wer stempelt, und welche der beiden Fassungen gilt."* Dahinter
  ist der nächste Satz als überholt markiert (*„Bis zum 23.10.2026 stand hier
  …"*), dieser nicht.
* *„**Zuletzt belegt am Quelltext: 22.10.2026 an 7.2.0.121** — … Der zweite
  Teil … ist davon unberührt **und bleibt offen**."*
* *„**Stufe: kritisch** (Paket: ausgeliefert wird etwas anderes als im Bau
  steht)"*. Seit der Behebung stimmt die Klammer nicht mehr.
* Die Beschreibung (Spalte 2) sagt *„**Fünf** vorgebaute Fremd-DLLs"*, das
  Urteil *„alle **zwölf**"*.

**Vorschlag:** die drei Sätze als *„Bis 23.10.2026 stand hier …"*
kennzeichnen und die Beschreibung auf *„Zwölf (zuerst fünf gefunden)"*
ändern. Die Stufe bleibt, die Klammer bekommt die Vergangenheitsform.

---

## Teil 2 — `ZIEL.md`: stimmt „18 von 19 erfüllt“?

### <a id="l-55.10"></a>L-55.10 — „erfüllt“ heißt im erzeugten Block „kein offener Befund in BEFUNDE.md“, nicht „erfüllt“

**Gewicht: falsch (Zählung, irreführend).** `ZIEL.md:16`, `:20`; `tools/ziel-stand.pl:134-145`

> `ZIEL.md:16`: *„Maßstab sind alle neun Kriterien unten, und zwar **erfüllt**, nicht „fast“."*
> `ZIEL.md:20`: *„**Stand: 18 von 19 erfüllt, 1 offen.**"*

**Gemessen:** `perl tools/ziel-stand.pl` → *„18 von 19 erfüllt, 1 offen"*. Die
Zahl ist richtig gerechnet. Was sie zählt, steht in `ziel-stand.pl:139-144`:
Eine Zeile gilt als erfüllt, wenn sie **keine Kennung** trägt oder wenn **keine**
ihrer Kennungen in `BEFUNDE.md` offen ist. Gezählt werden die 19 Zeilen
`ZIEL.md:34-52`. Darunter sind, am Text belegt:

* [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) (`:45-47`): in **keinem** Paket, von Gregor **nicht**
  gesehen;
* [E-69](../Intern/BEFUNDE.md#e-69) (`:42`): *„am Prüfstand gemessen, von Gregor noch nicht bestätigt"*;
* drei Zeilen ohne Kennung (`:34`, `:35`, `:37`): Entscheidungen, als erfüllt
  gezählt ([L-53.11](LEKTOR-53.md#l-53.11)).

Nicht gezählt werden die neun Kriterien selbst (`ZIEL.md:164-175`). Davon
stehen zwei auf *„fast"* (`:177`), ihre Urteile stammen von 7.2.0.55 (`:57-58`).
Die Tabelle nennt als Stand *„Quellstand 7.2.0.120"* (`:144`).

**Die Folge, wenn [E-116](../Intern/BEFUNDE.md#e-116) geschlossen wird** (am Quelltext belegt, `ziel-stand.pl:165-166`):
Der Block springt auf *„**Alle Zeilen des Maßstabs sind erfüllt.**"*. An dem
Tag stehen zwei Kriterien auf *fast*, drei Behebungen in keinem Paket, und
Gregors Test der neun Kriterien ist nicht gemacht. Es gibt dafür auch keine
Schritte ([L-55.12](#l-55.12)).

**Vorschlag:** Im erzeugten Block zwei Zahlen ausgeben: *„im Code erledigt"*
und *„an einem Paket von Gregor bestätigt oder ausdrücklich nicht verlangt"*.
Dazu zwei Zeilen in den Maßstab, die das Werkzeug als offen zählt, bis sie
eine Marke tragen: *„Kriterientabelle neu gemessen"* und *„Gregors Test der
neun Kriterien an Paket 7.2.0.123"*. Das ist der Weg aus
[Anforderung gehört in den Maßstab](../Arbeitsweise/anforderung-gehoert-in-den-massstab.md);
heute stehen beide nur als Prosa in `:57-58`.

### <a id="l-55.11"></a>L-55.11 — E-116 ist die einzige offene Zeile, und nach heutigem Stand kann sie niemand schließen

**Gewicht: unvollständig (eine Entscheidung fehlt).** `ZIEL.md:28`, `:48`; `Intern/BEFUNDE.md:362`

**Was stimmt** (am Text belegt, `BEFUNDE.md:362`):

1. Die Behebung ist im Code und in der Testsuite mit Gegenprobe belegt
   (*„ohne Behebung 278/280"*).
2. PRÜFER-48 hat sie nachgerechnet: *„die Behebung hält"* (K4–K6).
3. Am Programm ist der Fehler auf dem einzigen gemessenen Weg (*Öffnen,
   Weiterleiten*) **auch an der alten Fassung nicht sichtbar**. Die Vermutung
   in der Zelle: Der Weg läuft über den Internet Explorer, der den Wert vorher
   umschreibt.
4. *„Für Gregor ist nichts zu tun"* (Urteil). *wer* im Maßstab: *„ich"*
   (`ZIEL.md:28`).

Damit ist [E-116](../Intern/BEFUNDE.md#e-116) *offen* im Sinn von *„am Programm nicht rot nachgestellt"*,
nicht im Sinn von *„der Fehler besteht"*. Die Regel
[Erst nachstellen, dann ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md)
verlangt rot, dann grün. Bleibt die Suche nach dem Weg ohne Ergebnis, bleibt
die Zeile auf Dauer offen und hält das Release auf. Ob sie das soll, steht
nirgends. Gregor hat zu [E-116](../Intern/BEFUNDE.md#e-116) bisher nichts entschieden (`git grep -n "E-116"`
in `Intern/WEITERMACHEN.md`: nur die erzeugte Zeile `:363`; in
`:132-142` kein Satz zu [E-116](../Intern/BEFUNDE.md#e-116) außer *„stecken schon auf main"*).

Die Behebung braucht **keinen** Lauf bei Gregor: Er kann nichts sehen, was ich
nicht sehe.

**Vorschlag:** Gregor drei Wege vorlegen ([Frage 2](#fragen)):
(a) den Weg weitersuchen, der den Fehler zeigt (Antworten im reinen
Paige-Weg). Das ist eine Arbeit mit offenem Ende, die das Release aufhält.
(b) [E-116](../Intern/BEFUNDE.md#e-116) gilt als *„behoben, am Programm nicht nachstellbar"*. Beleg wären
Testsuite und Gegenprobe. Die Zeile im Maßstab wäre damit erfüllt.
(c) [E-116](../Intern/BEFUNDE.md#e-116) aus dem Maßstab nehmen. Er bleibt offen, hält 7.2.1 aber nicht auf.
Mein Vorschlag: (b), mit dem Satz aus 3. im Urteil.

---

## <a id="teil-3"></a>Teil 3 — Der Testplan für Gregors eine Sitzung am Paket 7.2.0.123

### <a id="l-55.12"></a>L-55.12 — es gibt keinen Testplan für 7.2.0.123, und für „Gregors Test aller neun Kriterien“ gibt es keinen einzigen Schritt

**Gewicht: unvollständig.** `Intern/TESTPLAN.md:1-17`; `ZIEL.md:57-58`

> `TESTPLAN.md:1`: *„Testplan für Gregor — Quellstand 7.2.0.122 / `VERSION` 1.0.122"*; `:8`: *„**Im Moment nichts.**"*
> `ZIEL.md:57-58`: *„**Vor dem Release:** die Tabelle der Kriterien neu messen …, dann Gregors Test aller neun Kriterien an einem frischen Paket, erst danach die Marke."*

**Gemessen:** `grep -n -i "kriteri" Intern/TESTPLAN.md` → **kein Treffer**.
Teil M nennt sich *„vor dem Release 7.2.1 zu fahren"* (`:519`), mit M1 und M3.
Wenn 7.2.0.123 der Kandidat ist, gehört Teil M in **dieselbe** Sitzung. Bisher
steht nirgends, dass diese Sitzung die Abnahme ist.

**Vorschlag:** Vor dem Schnüren einen Abschnitt *„Paket 7.2.0.123 — Abnahme
für 7.2.1"* oben in `TESTPLAN.md`. Inhalt ist die Liste unten. Jede Zeile
nennt Postfach mit Lage, Handgriff und woran man das Gelingen sieht. Erst
selbst fahren, was am Prüfstand geht
([Erst prüfen, dann anweisen](../Arbeitsweise/erst-pruefen-dann-anweisen.md)).

**Die Liste. Wer braucht Gregors Lauf, wer nicht** (Lage: `<Dominant>` ist sein
GMX-IMAP-Konto im Postfachbaum, siehe
[testschritt-nennt-den-ort](../Arbeitsweise/testschritt-nennt-den-ort.md)):

| # | Was | Befund / Fundstelle | Gregors Lauf? | Warum |
|---|---|---|---|---|
| G1 | **Ordnernamen ansehen:** im Postfachbaum unter **`<Dominant>`** (IMAP, nicht die lokalen Postfächer oben) und im Menü *Transfer* stehen „Entwürfe" und „Gelöscht", nicht `Entw&APw-rfe` | [E-77](../Intern/BEFUNDE.md#e-77), `BEFUNDE.md:324` | **ja**, kurz | am Prüfstand gemessen (`E-77a`–`c`), aber mit nachgebauter Ordnerliste. Gregors echtes GMX ist die Bestätigung |
| G2 | **Ordner mit Umlaut anlegen und umbenennen:** unter **`<Dominant>`** einen Ordner `Prüfö` anlegen, im **GMX-Webmailer** nachsehen, wie er heißt (muss `Prüfö` sein). Dann in Eudora in `Prüfä` umbenennen, wieder im Webmailer nachsehen, danach löschen | [E-77](../Intern/BEFUNDE.md#e-77), `BEFUNDE.md:324`: *„Nicht am Programm gemessen: Anlegen und Umbenennen … der IMAP-Prüfserver kennt `CREATE` und `RENAME` nicht"* | **ja, nur bei ihm messbar** | schreibt auf seinen echten Server. Vorher PRÜFER über die Kodierung ([L-55.15](#l-55.15)) |
| G3 | **Weiterleiten mit `data:`-Bild:** die Mail *„Einladung Polizeitag München"* weiterleiten. Im Verfassen-Fenster steht das Bild, kein grauer Kasten. **An sich selbst senden** und beim Empfang (Eudora **und** Webmailer) nachsehen, ob das Bild ankommt | [E-119](../Intern/BEFUNDE.md#e-119), `BEFUNDE.md:365`: *„Ebenfalls nicht gemessen: was beim **Senden** einer solchen Weiterleitung mit dem `file://`-Verweis geschieht"* | **ja**, Senden als echte Mail | das Anzeigen ist am Prüfstand gemessen, das Senden nicht. In welchem Postfach die Mail liegt (lokal `In` oder unter `<Dominant>`), muss der Plan nennen. Es steht in keiner Datei |
| G4 | **Breites Bild beim Antworten:** auf einen Newsletter mit breitem Banner antworten. Das Bild passt in den Textbereich, kein waagerechter Rollbalken. **Dann das Fenster schmaler ziehen: das Bild passt sich NICHT an. Das ist bekannt (Variante B), kein neuer Fehler** | [E-113](../Intern/BEFUNDE.md#e-113), `BEFUNDE.md:359` | **ja, zum Ansehen** (am Prüfstand gemessen: `E-113p`) | Darstellung ist Kriterium 2, und das Urteil darüber hat Gregors Auge. Ohne den Hinweis auf B meldet er B als neuen Fehler |
| G5 | **Die neun Kriterien 0–8**, je ein Handgriff: Paket aus dem ZIP auspacken (vorher *Zulassen*, [E-138](../Intern/BEFUNDE.md#e-138)) und mit `Eudora starten.cmd` starten; POP und IMAP abrufen; HTML-Nachricht ansehen; neue Mail schreiben und senden; weiterleiten; Fensterliste und Registerkarten; *File → Exit* | `ZIEL.md:57-58`, `:164-175` | **ja** | verlangt vor der Marke. Schritte fehlen ganz ([L-55.12](#l-55.12)) |
| G6 | **M1** Starttest (fremdes Mailverzeichnis) | [E-132](../Intern/BEFUNDE.md#e-132), `TESTPLAN.md:531-560` | **ja** | Teil M, *„vor dem Release 7.2.1"*. Schritte stehen |
| G7 | **M3** Ziehen nach `Out` (Schritt 1–3 empfangene Nachricht; 4a–4d Entwurf über das **lokale** `Trash`, das oberste, nicht das unter `<Dominant>`) | [E-125](../Intern/BEFUNDE.md#e-125), `TESTPLAN.md:590-629` | **ja** | Teil M. Schritte am 23.10. neu geschrieben, Lage genannt |
| — | [E-116](../Intern/BEFUNDE.md#e-116) Bildbreite `35px` | `BEFUNDE.md:362` | **nein** | auch an der alten Fassung nicht sichtbar. Gregor kann nichts sehen ([L-55.11](#l-55.11)) |
| — | [E-130](../Intern/BEFUNDE.md#e-130) DLLs im Original | `BEFUNDE.md:376` | **nein** | betrifft den Bau. Beim Schnüren prüfe ich: die zwölf DLLs im Paket gleich `567a5d87` (SHA-1) |
| — | [E-69](../Intern/BEFUNDE.md#e-69), [E-101](../Intern/BEFUNDE.md#e-101) F1/F3/F4 | `WEITERMACHEN.md:137` | **nein** | Gregor: ich stelle am Prüfstand nach |
| — | M2 Suchindex | `TESTPLAN.md:562-564` | **nein** | deaktiviert am 23.10.2026 |
| — | [E-142](../Intern/BEFUNDE.md#e-142), [E-144](../Intern/BEFUNDE.md#e-144) | `BEFUNDE.md:378`, `:380` | **nein** (nicht behoben) | gehören unter *„Was bekannt ist"*, damit er sie nicht neu meldet ([L-55.14](#l-55.14)) |

Vor G1–G7, Bedingung aus `TESTPLAN.md:605-606`: `LogLevel` mit den Masken für
[`E-125`](../Intern/BEFUNDE.md#e-125) (32768) und für die Bildspuren. Den Wert nennt der Plan, nicht Gregor.

### <a id="l-55.13"></a>L-55.13 — vier „Wie zu prüfen“ sind mehrdeutig oder nicht ausführbar, eines davon ist genau der Fall vom 23.10.

**Gewicht: Form (Lehre [testschritt-nennt-den-ort](../Arbeitsweise/testschritt-nennt-den-ort.md) nicht angewandt).** `Intern/BEFUNDE.md:380`, `:378`, `:324`, `:359`

* **[E-144](../Intern/BEFUNDE.md#e-144) `:380`:** *„**Wie zu pruefen:** einen Antwortentwurf speichern,
  nach `Trash` und zurück nach `Out` schieben"*. Es gibt zwei `Trash`, und
  welches gemeint ist, sagt der Satz nicht. Genau dieser Satz hat am 23.10.2026
  Gregors Lauf auf [E-142](../Intern/BEFUNDE.md#e-142) statt [E-144](../Intern/BEFUNDE.md#e-144) gelenkt (die Lehre selbst, Absatz 2). Der
  Kurzsatz derselben Zelle sagt es richtig: *„aus einem lokalen Postfach (etwa
  `Trash`)"*.
* **[E-142](../Intern/BEFUNDE.md#e-142) `:378`:** *„einen Entwurf in einem IMAP-Ordner anlegen, nach `Out`
  ziehen"*. Wie ein Entwurf in einen IMAP-Ordner kommt, sagt der Satz nicht.
  An derselben Lücke hat Gregor M3 Schritt 4 abgelehnt (`TESTPLAN.md:620-624`).
* **[E-77](../Intern/BEFUNDE.md#e-77) `:324`:** am Prüfstand nicht ausführbar ([L-55.1](#l-55.1)).
* **[E-113](../Intern/BEFUNDE.md#e-113) `:359`:** der letzte Schritt prüft Variante B ([L-55.8](#l-55.8)).

**Vorschlag:** [E-144](../Intern/BEFUNDE.md#e-144): *„in das **lokale** `Trash` (oberstes im Baum, nicht
das unter `<Dominant>`)"*. [E-142](../Intern/BEFUNDE.md#e-142): den Weg aus dem Bericht übernehmen
(*„Entwurf in `Out` speichern, nach `Trash` unter **`<Dominant>`** ziehen,
zurück nach `Out`"*, wie Gregor ihn gefahren hat, `:378`). Die übrigen zwei
wie in [L-55.1](#l-55.1).

### <a id="l-55.14"></a>L-55.14 — „Was bekannt ist“ im Testplan: drei Einträge werden mit 7.2.0.123 falsch, drei fehlen

**Gewicht: veraltet (ab Paket).** `Intern/TESTPLAN.md:224-241`, `:251`

> `:230-233`: *„Bilder, die als `data:`-Adresse in der Mail stecken, erscheinen als **grauer Kasten**. / Bilder, die **breiter sind als das Fenster**, werden nicht verkleinert. / Eine Größenangabe mit Einheit (`width="35px"`) wird nicht ausgewertet."*

Ab 7.2.0.123 sind die ersten beiden falsch. Der dritte war nach der
Messung vom 24.10. ([L-55.2](#l-55.2)) nie sichtbar. Es **fehlen**
(am Text belegt, kein Treffer in `:224-241`): [E-142](../Intern/BEFUNDE.md#e-142)
(Entwurf aus IMAP nach `Out` → leere Nachricht), [E-144](../Intern/BEFUNDE.md#e-144)
(Antwortentwurf verliert den Gesprächsfaden) und Variante B von [E-113](../Intern/BEFUNDE.md#e-113). Alle drei
trifft Gregor in G3, G4 und G7 leicht.

Dazu `:228`: *„Schritt 2 prüft nur das **ordentliche** Beenden."* Einen
Schritt 2 gibt es im Abschnitt *Was jetzt zu testen ist* nicht mehr. Dort steht
*„Im Moment nichts"*. Und `:251`: *„**277 Tests, 277 bestanden** (Stand
7.2.0.122)"*. `CHANGELOG.md:140` nennt für `main` 286/286. Der Satz dahinter
fordert selbst, die Zahl zu erzeugen ([L-51.16](LEKTOR-51.md)).

**Vorschlag:** mit dem neuen Abschnitt aus [L-55.12](#l-55.12) neu fassen.

### <a id="l-55.15"></a>L-55.15 — „Für Gregor ist nichts zu tun“ bei E-77 und E-119, obwohl der ungemessene Teil nur bei ihm messbar ist; PRÜFER hat die drei nicht gesehen

**Gewicht: Widerspruch.** `Intern/BEFUNDE.md:324`, `:365`; `CHANGELOG.md:136-142`

> `:324` ([E-77](../Intern/BEFUNDE.md#e-77)): *„Für Gregor ist nichts zu tun außer dem Test im Paket."* Dieselbe Zelle: *„**Nicht am Programm gemessen:** Anlegen und Umbenennen eines Ordners mit Umlaut"*.
> `:365` ([E-119](../Intern/BEFUNDE.md#e-119)): *„Für Gregor ist nichts zu tun; wer solche Post hat, kann es an 7.2.0.123 sehen."* Dieselbe Zelle: *„Ebenfalls nicht gemessen: was beim **Senden** einer solchen Weiterleitung … geschieht"*.

**Was stimmt:** Beide ungemessenen Teile gehen nach außen. Bei [E-77](../Intern/BEFUNDE.md#e-77) legt
Eudora einen Ordner auf Gregors **echtem** GMX-Server an. Bei [E-119](../Intern/BEFUNDE.md#e-119) geht eine
Mail mit einem Bild aus `file://` an einen Empfänger. Am Prüfstand ist beides
heute nicht messbar: Der IMAP-Prüfserver kennt kein `CREATE` und `RENAME`, und
gesendet wurde nichts. Gregor **hat** solche Post. [E-119](../Intern/BEFUNDE.md#e-119) ist seine Meldung vom
13.10.2026 (*„Einladung Polizeitag München"*).

**Gemessen:** `perl tools/rollen-faellig.pl` → *„PRUEFER ist faellig: seit
seinem Bericht (561df9f) haben sich 14 Datei(en) … geaendert —
`ImapMailbox.h`, `ImapAccount.cpp`, `ImapMailbox.cpp` und 11 weitere"*. Der
letzte PRÜFER-Bericht (PRÜFER-48) kennt [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113) und [E-119](../Intern/BEFUNDE.md#e-119) nicht.

**Vorschlag:** In beiden Zellen *„Für Gregor"* auf G2 bzw. G3 aus der Liste
oben ändern. Vor dem Schnüren läuft PRÜFER über `E77Utf7Kodieren`. Ein Fehler
dort legt einen falsch benannten Ordner auf einem echten Server an, und
löschen müsste ihn Gregor. Für [E-119](../Intern/BEFUNDE.md#e-119) prüfen, ob sich das Senden am Prüfstand
nachstellen lässt (SMTP-Mitschnitt). Dann wird G3 eine Bestätigung statt einer
Erstmessung.

---

## Teil 4 — Die heute angefassten Befundzeilen gegen die Regel

Regel `BEFUNDE.md:18-24`: Urteil fett zuerst, dann höchstens drei Sätze ohne
Kürzel, dann die Herleitung. Gemessen: `perl tools/pruefe-befund-anfang.pl
--bestand` → 199 Zeilen, 32 ohne Urteil vorn. **Keine** der sieben unten ist
darunter.

| Befund | Zeile | Urteil vorn | die Sätze danach, für Gregor | gegen die Regel |
|---|---|---|---|---|
| [E-77](../Intern/BEFUNDE.md#e-77) | `:324` | *„behoben auf dem Zweig …, kommt mit Paket 7.2.0.123; … 286 Tests …"* | zwei Sätze, verständlich | **zum Teil.** *„auf dem Zweig"* veraltet ([L-55.1](#l-55.1)); *„nichts zu tun"* falsch ([L-55.15](#l-55.15)); das Urteil selbst trägt Kürzel (`E-77a` bis `c`) |
| [E-113](../Intern/BEFUNDE.md#e-113) | `:359` | *„behoben (Variante A) auf dem Zweig …"* | drei Sätze, mit Variante B. **Gut** | *„auf dem Zweig"*; Schwanz veraltet ([L-55.1](#l-55.1)) |
| [E-116](../Intern/BEFUNDE.md#e-116) | `:362` | *„offen — die Behebung ist seit PR #157 … auf `main` …; am laufenden Programm noch nicht gesehen."* | *„wird nicht mehr riesig breit … Für Gregor ist nichts zu tun."* | **irreführend.** *„noch nicht gesehen"* klingt nach *„noch nicht nachgesehen"*; gemessen ist aber, dass der Fehler auf diesem Weg nie sichtbar war ([L-55.2](#l-55.2)) |
| [E-119](../Intern/BEFUNDE.md#e-119) | `:365` | *„behoben auf dem Zweig …"* | zwei Sätze, verständlich | *„auf dem Zweig"*; *„nichts zu tun"* ([L-55.15](#l-55.15)) |
| [E-130](../Intern/BEFUNDE.md#e-130) | `:376` | *„behoben am 23./24.10.2026, Regressionstest `TestE130.cpp` …"* | zwei Sätze, verständlich | **ja.** Rest veraltet ([L-55.9](#l-55.9)); ohne Fassungsnummer, aber der Befund betrifft den Bau, nicht das Programm |
| [E-142](../Intern/BEFUNDE.md#e-142) | `:378` | *„offen, von Gregor am 23.10.2026 am laufenden Programm bestätigt"* | drei Sätze | **Widerspruch innen**, siehe [L-55.17](#l-55.17) |
| [E-144](../Intern/BEFUNDE.md#e-144) | `:380` | *„offen, von Gregor … bestätigt"* | vier Sätze, verständlich | **ja.** *Wie zu prüfen* mehrdeutig ([L-55.13](#l-55.13)) |

### <a id="l-55.16"></a>L-55.16 — E-142 und E-144 heißen in den erzeugten Listen „nie gemessen“; Gregor hat beide am 23.10. am Programm gemessen

**Gewicht: falsch (erzeugte Tabelle).** `CHANGELOG.md:27`, `:29`; `Intern/WEITERMACHEN.md:347`, `:349`; Ursache `Intern/BEFUNDE.md:378`, `:380`

**Gemessen:** Beide Zeilen tragen in der Spalte *zuletzt gemessen*
*„**nie gemessen**"*. `perl tools/offene-befunde.pl` zählt sie unter *„davon
NIE gemessen 9"*. **Ursache, am Quelltext belegt:**
`tools/offene-befunde.pl:187`, `:205` erkennen nur die Marken
`**Zuletzt gemessen: TT.MM.JJJJ an 7.2.0.n**` und `**Zuletzt belegt am
Quelltext: …**`. Beide Zellen schreiben statt dessen *„**Von Gregor am
laufenden Programm bestätigt am 23.10.2026** an Paket 1.0.122"*.

Die zwei Fehler, die als einzige im ganzen Bestand von Gregor gestern am
Programm gesehen wurden, stehen damit in der Tabelle als nie gemessen.

**Vorschlag:** in beide Zellen `**Zuletzt gemessen: 23.10.2026 an
7.2.0.122**` (Paket 1.0.122) einsetzen. Ob das Werkzeug bei einem offenen
Befund ohne Marke warnen soll, statt still *nie* zu schreiben, entscheidet
der, der es pflegt.

### <a id="l-55.17"></a>L-55.17 — E-142: der Kurzsatz sagt „Verloren geht nichts“, die Zelle sagt, wann der Entwurf verloren geht

**Gewicht: Widerspruch.** `Intern/BEFUNDE.md:378`

> Kurzsatz: *„Verloren geht nichts, das Original bleibt im IMAP-Ordner."*
> Dieselbe Zelle, weiter hinten: *„wer es dort löscht, weil er es für verschoben hält, verliert den Entwurf."*
> Stufe: *„ob es wegen des möglichen Entwurfsverlusts kritisch ist, entscheidet Gregor"*

Der Kurzsatz ist das, was Gregor liest. Er beantwortet die Frage, die
[LEKTOR-54](LEKTOR-54.md#fragen) Frage 3 ihm stellt, schon im Voraus mit
„nein". Die Frage ist weiter offen (`WEITERMACHEN.md:142`: *„Ist [E-142](../Intern/BEFUNDE.md#e-142)
kritisch …?"*).

**Vorschlag:** *„Sofort verloren geht nichts. Wer das Original im IMAP-Ordner
löscht, weil er es für verschoben hält, verliert den Entwurf."*

---

## Teil 5 — Release-Notizen und Version des Kandidaten

### <a id="l-55.18"></a>L-55.18 — „die Release-Notizen nennen den Rückstand“: weiterhin keine Stelle, und der nächste Bau ist der Kandidat ([L-54.7](LEKTOR-54.md#l-54.7) bleibt)

**Gewicht: unvollständig.** `ZIEL.md:64-73`; `CHANGELOG.md:96-142`; `tools/release-veroeffentlichen.ps1`

**Gemessen:** `grep -n "Rückstand\|Rueckstand" CHANGELOG.md
tools/release-veroeffentlichen.ps1` → **kein Treffer**. Die heutigen Zahlen
(`perl tools/pruefe-regressionstest.pl`): **88** behobene Befunde ohne
Testfall; von 67 kritischen haben **49** keine Prüfung. `ZIEL.md:69` nennt
*„am 23.10.2026: 50 von 67"*, also mit Datum richtig, aber nicht mehr der
Stand. Die Tabelle `ZIEL.md:95-102` nennt *„Stand am 22.10.2026"* 186 / 29 /
0 / 97. Heute sind es 199 / 44 / 2 / 88.

**Vorschlag:** wie [L-54.7](LEKTOR-54.md#l-54.7). Dazu jetzt konkret: in den
CHANGELOG-Abschnitt, aus dem die Release-Notizen werden, einen Satz mit den
zwei Zahlen aus dem Werkzeug. Die Tabelle `ZIEL.md:95-102` entweder erzeugen
lassen oder als Stand vom 22.10. kennzeichnen und auf das Werkzeug verweisen.

### <a id="l-55.19"></a>L-55.19 — das Paket heißt 7.2.0.123, das Release 7.2.1.&lt;n&gt;: getestet würde ein anderer Bau als der, der veröffentlicht wird

**Gewicht: Widerspruch (Regel gegen Regel).** `ZIEL.md:59`; `Intern/WEITERMACHEN.md:132`, `:140`

> `ZIEL.md:59`: *„Das Release heißt `7.2.1.<laufende Buildnummer>` (Gregor am 23.10.2026: „release wird dann heißen: 7.2.1.123 (bzw. die laufende build nummer …)")"*
> `WEITERMACHEN.md:132`: *„beim nächsten Paket **7.2.0.123** … (Gregor: „wir haben noch keine 7.2.1. version, bleiben also bei 0.123")"*

**Was daraus folgt** (am Text belegt, Schluss von mir): Besteht 7.2.0.123
Gregors Abnahme, muss für das Release `Version.h` auf `7.2.1.n` gehoben und neu
gebaut werden. Veröffentlicht würde dann eine `Eudora.exe`, die Gregor nie
gestartet hat. Zwei Regeln des Projekts stehen dagegen:
[Release erst nach Gregors Test](../Arbeitsweise/release-erst-nach-gregors-test.md)
und [Paket gegen den Bau messen](../Arbeitsweise/paket-gegen-den-bau-messen.md).
Dazu die offene Frage aus [LEKTOR-54](LEKTOR-54.md#lektor-54) nach dem Namen der Marke
(`WEITERMACHEN.md:142`). `release-veroeffentlichen.ps1` kennt nur `v1.0.<n>`
([L-53.16](LEKTOR-53.md#l-53.16), am Text belegt in `ZIEL.md:59`).

**Vorschlag:** Gregor entscheiden lassen ([Frage 1](#fragen)): Entweder wird
der Kandidat schon als 7.2.1.123 gebaut, dann ist das, was er testet, das
Release. Oder der Neubau als 7.2.1.124 bekommt vor der Marke einen kurzen
zweiten Lauf (Start, Fenstertitel, eine Mail).

---

## <a id="teil-6"></a>Teil 6 — Die offenen Reste aus LEKTOR-54 und LEKTOR-53

Stand gegen die Dateien von heute (am Text belegt, wo nicht anders gesagt):

| Fund | worum es ging | heute |
|---|---|---|
| [L-54.7](LEKTOR-54.md#l-54.7) | Release-Notizen nennen den Test-Rückstand, keine Stelle sorgt dafür | **bleibt** → [L-55.18](#l-55.18) |
| [L-54.10](LEKTOR-54.md#l-54.10) | [E-130](../Intern/BEFUNDE.md#e-130) behoben, Zelle sagt *„Offen: wer stempelt"* | **zum Teil.** Urteil vorn richtig, drei alte Sätze stehen → [L-55.9](#l-55.9) |
| [L-54.15](LEKTOR-54.md#l-54.15) | `main` ist nicht mehr 7.2.0.122, nennt sich aber so | **bleibt, größer:** jetzt fünf Behebungen statt zwei → [L-55.4](#l-55.4) |
| [L-54.17](LEKTOR-54.md#l-54.17) | „88 fehlende Tests" und „50 von 67" ohne Erklärung | **zum Teil.** Die Zeile mit 88 ist mit dem Einstiegsblock verschwunden (gemessen: `grep -n "88 fehlende" Intern/WEITERMACHEN.md` → nichts). `ZIEL.md:69` *„50 von 67"* steht mit Datum, heute 49 → [L-55.18](#l-55.18) |
| [L-54.18](LEKTOR-54.md#l-54.18) | Regel für Befundzeilen steht nicht dort, wo geschrieben wird | **erledigt.** `BEFUNDE.md:18-24`, mit Schranke `pruefe-befund-anfang.pl` |
| [L-54.19](LEKTOR-54.md#l-54.19) | die fünf dringendsten Zeilen umschreiben ([E-123](../Intern/BEFUNDE.md#e-123), [E-129](../Intern/BEFUNDE.md#e-129), [E-124](../Intern/BEFUNDE.md#e-124), [AN-1](../Intern/BEFUNDE.md#an-1), [E-113](../Intern/BEFUNDE.md#e-113)) | **zum Teil.** [E-113](../Intern/BEFUNDE.md#e-113) neu, [E-129](../Intern/BEFUNDE.md#e-129) und [E-124](../Intern/BEFUNDE.md#e-124) beginnen mit Urteil, [AN-1](../Intern/BEFUNDE.md#an-1) trägt Gregors Entscheidung. **[E-123](../Intern/BEFUNDE.md#e-123) bleibt**, kritisch und offen, und beginnt weiter mit *„Der Beenden-Weg ist … bestätigt"* (`BEFUNDE.md:369`). Gemessen: unter den 32 Zeilen ohne Urteil vorn ist [E-123](../Intern/BEFUNDE.md#e-123) die einzige offene kritische |
| [L-53.10](LEKTOR-53.md#l-53.10) | `ZIEL.md` nennt den Leseweg von [E-131](../Intern/BEFUNDE.md#e-131) offen, der Befund geschlossen | **bleibt.** `ZIEL.md:34` *„Offen bleibt allein der Leseweg"*, `:36` *„der Leseweg bleibt offen"* gegen `BEFUNDE.md:390` *„der Leseweg ist am 22.10.2026 zu Ende gemessen"* |
| [L-53.11](LEKTOR-53.md#l-53.11) | `ziel-stand.pl` zählt Zeilen ohne Kennung als erfüllt | **bleibt** (`ziel-stand.pl:142`) → Teil von [L-55.10](#l-55.10) |
| [L-53.15](LEKTOR-53.md#l-53.15) | Kriterientabelle nennt Quellstand 7.2.0.120 | **bleibt.** `ZIEL.md:144` |
| [L-53.17](LEKTOR-53.md#l-53.17) | Kriterium 2 und 4 hängen an „improper argument" beim Anzeigen, ohne Befundnummer | **bleibt.** `ZIEL.md:169`, `:177-181`. Mit [E-77](../Intern/BEFUNDE.md#e-77) heraus ([L-55.5](#l-55.5)) ist das der **einzige** Grund für *„fast"* bei Kriterium 2 |
| [L-53.18](LEKTOR-53.md#l-53.18) | [A-1](../Intern/BEFUNDE.md#a-1) heißt in ZIEL.md und BEFUNDE.md zwei Dinge | **bleibt.** `ZIEL.md:322` *„Was [A-1](../Intern/BEFUNDE.md#a-1) ausdrücklich nicht verlangt: ein bestehendes Konto"* verlinkt auf `BEFUNDE.md:226` *„Erscheinungsbild: fünf Punkte"* |
| [L-53.19](LEKTOR-53.md#l-53.19) | [E-123](../Intern/BEFUNDE.md#e-123): Listen sagen „Bilder gehen verloren", die Messung: die ausstehende Übertragung | **bleibt.** `CHANGELOG.md:41` *„der Verlust eingebetteter Bilder nach Absturz …"* |
| [L-53.20](LEKTOR-53.md#l-53.20) | „neun Kriterien" und eine zweite Zählung auf derselben Seite | **bleibt**, jetzt *„18 von 19"* → [L-55.10](#l-55.10) |

**Fragen aus [LEKTOR-54](LEKTOR-54.md#lektor-54):** Frage 2 (heißt das nächste Paket 7.2.0.123?) ist
beantwortet (`WEITERMACHEN.md:132`). Frage 4 (Urteil zuerst) ist beantwortet
und umgesetzt (`BEFUNDE.md:18-24`). **Offen** sind Frage 1, die Marke auf
GitHub (`WEITERMACHEN.md:142`), jetzt Teil von [Frage 1](#fragen) unten, und
Frage 3, ob [E-142](../Intern/BEFUNDE.md#e-142) kritisch ist (`WEITERMACHEN.md:142`), siehe
[Frage 5](#fragen).

---

## <a id="fragen"></a>Was nur Gregor entscheiden kann

1. **Wird der Kandidat schon als 7.2.1.123 gebaut, oder wird 7.2.0.123 nach
   deiner Abnahme neu gebaut?** Im zweiten Fall wäre das, was veröffentlicht
   wird, ein Bau, den du nicht gestartet hast. Und heißt die Marke auf GitHub
   `v7.2.1.<n>` oder weiter `v1.0.<n>`? ([L-55.19](#l-55.19))
2. **[E-116](../Intern/BEFUNDE.md#e-116) (`width="35px"`): Genügt die Testsuite als Beleg?** Die Behebung
   ist im Code und von PRÜFER nachgerechnet. Am Programm war der Fehler aber
   auch an der alten Fassung nicht zu sehen. (a) weitersuchen, das hält das
   Release auf; (b) als *„behoben, am Programm nicht nachstellbar"* schließen;
   (c) aus dem Maßstab nehmen. Mein Vorschlag: (b). ([L-55.11](#l-55.11))
3. **[E-113](../Intern/BEFUNDE.md#e-113) Variante B (Bild wächst beim Ziehen am Fenster mit): eigener Befund,
   und gehört er zu 7.2.1?** Du hast *„erst A, dann B"* angeordnet. A ist
   fertig, B steht in keiner Liste mehr. ([L-55.8](#l-55.8))
4. **Ist die Sitzung am Paket 7.2.0.123 deine Abnahme für 7.2.1?** Dann
   gehören die neun Kriterien, M1 und M3 in dieselbe Sitzung, zusammen mit [E-77](../Intern/BEFUNDE.md#e-77)
   (Ordner anlegen und umbenennen auf deinem GMX) und [E-119](../Intern/BEFUNDE.md#e-119) (eine Weiterleitung
   mit Bild wirklich senden). Das sind sieben Punkte, Liste in
   [L-55.12](#l-55.12).
5. **Ist [E-142](../Intern/BEFUNDE.md#e-142) kritisch?** In `Out` entsteht eine
   leere Nachricht. Wer das Original im IMAP-Ordner löscht, verliert den
   Entwurf. Offen seit [LEKTOR-54](LEKTOR-54.md#lektor-54). ([L-55.17](#l-55.17))

---

## Geprüft und in Ordnung

* **Der CHANGELOG-Abschnitt** `CHANGELOG.md:96-142`: Was der Anwender merkt,
  stimmt für [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) und [E-130](../Intern/BEFUNDE.md#e-130) mit den Befundzeilen überein. Dazu
  die Zahlen 284/284 ([E-113](../Intern/BEFUNDE.md#e-113)), 286/286 ([E-77](../Intern/BEFUNDE.md#e-77)) und die Regressionsfälle (gegen
  `tools/pruefstand-faelle.txt:186-204`). Variante B ist offen benannt
  (`:132-133`), ebenso *„Anlegen und Umbenennen sind nur in der Testsuite
  geprüft"* (`:141-142`).
* **Die erzeugten Listen** *Noch offen* (`CHANGELOG.md`, `WEITERMACHEN.md`):
  *„37 offene Befunde, in beiden Listen gleich"* (gemessen). [E-142](../Intern/BEFUNDE.md#e-142) und [E-144](../Intern/BEFUNDE.md#e-144)
  sind wieder drin ([L-54.1](LEKTOR-54.md#l-54.1) erledigt).
* **`ziel-stand.pl`**: *„ZIEL.md ist auf dem Stand"* (gemessen). Die Zahl ist
  richtig gerechnet, nur ihre Bedeutung ist es nicht ([L-55.10](#l-55.10)).
* **`pruefe-befund-anfang.pl --bestand`**: alle sieben heute angefassten
  Zeilen beginnen mit dem Urteil (gemessen).
* **`doku-pruefen.pl`**: *„Kein Widerspruch gefunden"*, 14 Hinweise auf
  datierte Release-Notizen und Hintergrundtexte (gemessen).
* **`tools/ZWEIGE.md:182-188`**: alle fünf Zweige mit Gregors Freigabe zum
  Namen.
* **`git tag`**: zuletzt `v1.0.120`; keine Datei behauptet ein späteres Release.

## Nicht geprüft

* Ob Schritt 3 der Reihenfolge (*„Alle Bildfälle fahren"*) nach [E-113](../Intern/BEFUNDE.md#e-113) und [E-119](../Intern/BEFUNDE.md#e-119)
  gelaufen ist ([L-55.4](#l-55.4)). Die Commit-Nachrichten nennen die Einzelfälle.
* Wo Gregors Mail *„Einladung Polizeitag München"* liegt (lokal oder unter
  `<Dominant>`). Das zu klären braucht sein `eudora.log` oder ihn; ich habe
  seine Verzeichnisse nicht angefasst.
* Der Code von [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113) und [E-119](../Intern/BEFUNDE.md#e-119). Das ist Sache des PRÜFERS, der fällig ist
  ([L-55.15](#l-55.15)).
* `Releases/1.0.122` und frühere Release-Notizen über den Hinweis von
  `doku-pruefen.pl` hinaus.
