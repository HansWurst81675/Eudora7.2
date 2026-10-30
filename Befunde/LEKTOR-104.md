# <a id="lektor-104"></a>LEKTOR-104 — Bestand nach de8cdefd

**Datum:** 30.10.2026 · **Geprüft:** Commit `de8cdefd` auf `weitermachen-aufraeumen`, im Arbeitsbaum `Eudora7.2-wt-lektor`

**Auftrag.** Voller Lauf: Funde aus [LEKTOR-103](LEKTOR-103.md#lektor-103)
nachsehen, dann den Bestand der MDs (64 Dateien aus `git ls-files '*.md'`
ohne `Arbeitsweise/` und `Befunde/`) gegen den heutigen Stand lesen, mit
Schwerpunkt auf allem, was seit `eb7a3f88` geändert wurde (zehn Commits bis
`de8cdefd`). **Alle Zeilenangaben gelten für `de8cdefd`.** Nichts gebaut,
nichts gestartet. **In diesem Bericht steht nichts aus Gregors Rechner oder
Postfach.**

**Ergebnis vorweg.** Aus [LEKTOR-103](LEKTOR-103.md#lektor-103) war kein Fund offen. **Fünf neue Funde.**
Der wichtigste: Ein Filter mit *„… doesn't appear“* trifft in der
veröffentlichten Fassung 7.2.1.128 **jede** Nachricht. Mit der Aktion
*transfer* verschiebt er den ganzen Posteingang. Behoben ist das nur im
Quelltext, und die README nennt es nicht unter „Bekannte Fehler“
([L-104.1](#l-104.1)). Außerdem: ein Prüfschritt im TESTPLAN lässt fremde
Filter mitlaufen ([L-104.2](#l-104.2)); elf neue Regressionstests stehen in
keinem Dokument ([L-104.3](#l-104.3)); zwei alte Aussagen zum Rückstand an
Regressionstests ([L-104.4](#l-104.4), [L-104.5](#l-104.5)).

## Funde aus LEKTOR-103

[LEKTOR-103](LEKTOR-103.md#lektor-103) hatte **keine Funde**. Offen war nur Gregors Frage, ob die
veröffentlichten Notizen zu `v7.2.1.128` einen Satz zu den fehlenden
Regressionstests bekommen. **Heute weiter offen:** `ZIEL.md:37-38`
*„Bei 7.2.1.128 fehlt dieser Satz in den Notizen“*. **Gemessen:** der Text
des Releases (`gh release view v7.2.1.128`, 92 Zeilen) enthält weder „test“
noch „Rückstand“ noch „nachgeholt“; die Positivprobe [`E-166`](../Intern/BEFUNDE.md#e-166) trifft einmal.

## Neue Funde

### <a id="l-104.1"></a>L-104.1 — Der Filterfehler in 7.2.1.128 fehlt unter „Bekannte Fehler“

**Gewicht: Lücke nach außen.** `README.md:148` (Abschnitt „Bekannte Fehler“), `Intern/BEFUNDE.md:319`, `CHANGELOG.md:115`

Worum es geht: In der veröffentlichten Fassung verschiebt ein gewöhnlicher
Filter jede Nachricht statt nur der passenden.

> `CHANGELOG.md:115`: *„Seit 7.2.0.36 traf eine Bedingung „Kopfzeile doesn't
> appear“ **jede** Nachricht, „appears“ keine; „doesn't contain“ oder „is
> not“ mit leerem Wert ebenfalls jede. Mit der Aktion *transfer* verschiebt so
> ein Filter den ganzen Posteingang.“*

Die Behebung steht nur in `022e115f`, unter *„Im Quellstand, noch in keinem
Paket“* (`CHANGELOG.md:109`). 7.2.1.128 trägt den Fehler also. Ein Anwender
der veröffentlichten Fassung erfährt davon nur in der README. Dort steht
**kein** Treffer für [`E-72`](../Intern/BEFUNDE.md#e-72) (`grep -c 'E-72\b' README.md` = 0, gemessen); die
Befunde [E-140](../Intern/BEFUNDE.md#e-140) bis [E-173](../Intern/BEFUNDE.md#e-173) stehen dagegen alle darin (je mindestens ein Treffer,
gemessen). Das Urteil in `Intern/BEFUNDE.md:319` lautet weiter vorn
*„**behoben** in 7.2.0.36“*. Der Nachtrag vom 30.10.2026 steht erst weiter
hinten in derselben Zelle. Dass seine Behebung in keinem Paket ist, sagt die
Zelle nicht. **Belegt.**

Wie gewöhnlich so eine Regel ist, sagt [PRÜFER-66](PRUEFER-66.md#k1) selbst
(`:84-86`): *„Eine gewöhnliche Regel wie „Kopfzeile X-Spam-Flag doesn't
appear → transfer Gelesen“ hat deshalb normalerweise einen leeren Wert.“*
Und `:28`: mit *transfer* *„derselbe Schaden wie [E-64](../Intern/BEFUNDE.md#e-64)“*.

**Vorschlag:** [E-72](../Intern/BEFUNDE.md#e-72) mit einem Satz unter „Bekannte Fehler“ aufnehmen, bis
das nächste Paket veröffentlicht ist. Im Urteil `BEFUNDE.md:319` den Stand
des Nachtrags vorn nennen: „Nachtrag 30.10. im Quelltext behoben, in keinem
Paket“. Ob mehr geschehen soll, steht unten bei [Gregor](#gregor).

### <a id="l-104.2"></a>L-104.2 — Der neue TESTPLAN-Schritt zu E-72 lässt alle manuellen Filter laufen

**Gewicht: Prüfschritt mit Nebenwirkung.** `Intern/TESTPLAN.md:27`, `:30`, `:33`

Worum es geht: Der Prüfschritt verspricht, dass nichts verschoben wird. Er
startet aber jeden Filter, bei dem *Manual* angekreuzt ist, nicht nur den
neuen Prüffilter.

> `:27` *„Geprüft wird nur mit **Make Label**, nichts wird verschoben.“*
> `:33` *„Im lokalen *In* alle Nachrichten markieren, *Special → Filter
> Messages* (Strg+J).“*

*Filter Messages* ruft für jede markierte Nachricht
`filt.FilterOne(…, WTA_MANUAL, …)` auf (`Eudora71/Eudora/TocFrame.cpp:2424`).
`FilterMsg` nimmt dabei **jeden** Filter, dessen `m_WhenToApply` das
Manuell-Bit trägt (`filtersd.cpp:2627` *„if (filt->m_WhenToApply &
WhenToApply)“*). Das Ergebnis wird auf `FA_TRANSFER` geprüft, verschoben
werden kann also auch. Wer schon eigene manuelle Filter mit *transfer* hat,
verschiebt mit Schritt 4 den ganzen markierten Posteingang nach deren Regeln.
Dass Gregor manuelle Filter hat und Strg+J zum Filtern benutzt, steht in [E-75](../Intern/BEFUNDE.md#e-75)
(`Intern/BEFUNDE.md:322`). **Belegt am Quelltext.**

Zweiter, kleinerer Punkt: *„(Strg+J)“* filtert nur, solange `CtrlJMapping`
nicht auf *Junk* steht. Sonst verschiebt dieselbe Taste alle markierten
Nachrichten nach `Junk` ([E-75](../Intern/BEFUNDE.md#e-75), `BEFUNDE.md:322`). Ob das auf einem von
Gregors Rechnern so steht, weiß ich nicht. **Vermutung.**

**Vorschlag:** Den Schritt in einem eigenen, leeren Mailverzeichnis
ausführen lassen, oder vorher bei allen anderen Filtern *Manual* abhaken
lassen. Die Taste Strg+J aus dem Schritt streichen und nur den Menüweg
nennen. Den Satz „nichts wird verschoben“ an diese Bedingung binden.

### <a id="l-104.3"></a>L-104.3 — Elf neue Regressionstests stehen in keinem Dokument

**Gewicht: Doku nicht mitgezogen.** `CHANGELOG.md:118`, `Intern/WEITERMACHEN.md:33`, elf Zeilen in `Intern/BEFUNDE.md`

Worum es geht: Seit dem letzten Commit prüfen neue Tests, ob elf alte Fehler
zurückkommen. Die Doku weiß davon nichts.

`ff851fca` und `de8cdefd` bringen sechs Testdateien (`TestZusicherungen.cpp`,
`TestE28.cpp`, `TestE57E58E75.cpp`, `TestE86.cpp`, `TestE104E115.cpp`,
`TestM1.cpp`). Die Commit-Nachricht von `de8cdefd` nennt *„Tests: 337 von
337 bestanden“*. Beide Commits ändern **keine** `.md`-Datei
(`git log --stat eb7a3f88..HEAD`, gemessen). Deshalb steht heute:

* `CHANGELOG.md:118` *„neue Tests für [E-60](../Intern/BEFUNDE.md#e-60), [E-64](../Intern/BEFUNDE.md#e-64)/[E-72](../Intern/BEFUNDE.md#e-72), [E-82](../Intern/BEFUNDE.md#e-82), [S-1](../Intern/BEFUNDE.md#s-1), [S-8](../Intern/BEFUNDE.md#s-8),
  [E-156](../Intern/BEFUNDE.md#e-156), [E-3](../Intern/BEFUNDE.md#e-3), [E-23](../Intern/BEFUNDE.md#e-23), [E-32](../Intern/BEFUNDE.md#e-32) und [V-1](../Intern/BEFUNDE.md#v-1) … 326 Tests, 326 bestanden“*. Es fehlen
  [E-15](../Intern/BEFUNDE.md#e-15), [E-19](../Intern/BEFUNDE.md#e-19), [E-21](../Intern/BEFUNDE.md#e-21), [E-28](../Intern/BEFUNDE.md#e-28), [E-57](../Intern/BEFUNDE.md#e-57), [E-58](../Intern/BEFUNDE.md#e-58), [E-75](../Intern/BEFUNDE.md#e-75), [E-86](../Intern/BEFUNDE.md#e-86), [E-104](../Intern/BEFUNDE.md#e-104), [E-115](../Intern/BEFUNDE.md#e-115) und [M-1](../Intern/BEFUNDE.md#m-1), und
  die Zahl ist 337.
* `Intern/WEITERMACHEN.md:33` *„neu getestet [E-60](../Intern/BEFUNDE.md#e-60), [E-64](../Intern/BEFUNDE.md#e-64), [E-72](../Intern/BEFUNDE.md#e-72), [E-82](../Intern/BEFUNDE.md#e-82), [S-1](../Intern/BEFUNDE.md#s-1),
  [S-8](../Intern/BEFUNDE.md#s-8), [E-156](../Intern/BEFUNDE.md#e-156), [E-3](../Intern/BEFUNDE.md#e-3), [E-23](../Intern/BEFUNDE.md#e-23), [E-32](../Intern/BEFUNDE.md#e-32), [V-1](../Intern/BEFUNDE.md#v-1)“*: dieselbe Lücke.
* `Intern/BEFUNDE.md`: Die Befunde, die am 30.10.2026 vormittags Tests bekamen, tragen im
  Urteil einen Vermerk **„Regressionstest“** mit Datei und Zahl (z. B. [S-1](../Intern/BEFUNDE.md#s-1)
  `:210`, [E-60](../Intern/BEFUNDE.md#e-60) `:307`, [E-3](../Intern/BEFUNDE.md#e-3) `:265`). Bei den elf neuen fehlt er: [E-15](../Intern/BEFUNDE.md#e-15) `:431`,
  [E-19](../Intern/BEFUNDE.md#e-19) `:433`, [E-21](../Intern/BEFUNDE.md#e-21) `:435`, [E-28](../Intern/BEFUNDE.md#e-28) `:284`, [E-57](../Intern/BEFUNDE.md#e-57) `:304`, [E-58](../Intern/BEFUNDE.md#e-58) `:305`, [E-75](../Intern/BEFUNDE.md#e-75)
  `:322`, [E-86](../Intern/BEFUNDE.md#e-86) `:333`, [E-104](../Intern/BEFUNDE.md#e-104) `:350`, [E-115](../Intern/BEFUNDE.md#e-115) `:361`, [M-1](../Intern/BEFUNDE.md#m-1) `:225`. Gemessen: kein
  Treffer für „Regressionstest“ in diesen elf Zeilen.

`pruefe-regressionstest.pl` zählt die Tests trotzdem mit, denn es liest die
`.cpp`-Dateien selbst (`tools/pruefe-regressionstest.pl:79`). Deshalb hat
keine Schranke angeschlagen. **Gemessen.**

**Vorschlag:** An allen drei Stellen nachtragen. Die Gegenprobe aus der
Commit-Nachricht (*„alle 15 neuen Pruefungen rot“*) gehört in den
CHANGELOG-Satz.

### <a id="l-104.4"></a>L-104.4 — ZIEL.md nennt „97 ohne jede Prüfung“ im Präsens, gemessen sind 50

**Gewicht: veraltete Zahl, seit [L-53.12](LEKTOR-53.md#l-53.12) offen.** `ZIEL.md:160-161`, `ZIEL.md:181`

Worum es geht: Der Maßstab nennt für den Rückstand an Tests eine Zahl, die
seit einer Woche nicht mehr stimmt.

> `ZIEL.md:160-161` *„Sie weist ab, sobald ein Befund **neu** auf *behoben*
> geht, ohne geprüft zu sein; die 97 werden gezählt und können dadurch nur
> sinken.“*
> `ZIEL.md:181` *„die Altlasten: 97 Befunde stehen als *behoben* ohne jede
> Prüfung.“*

`perl tools/pruefe-regressionstest.pl` heute: *„behoben und OHNE Testfall 50
<- Rueckstand“*. Die Tabelle darüber ist mit *„Stand am 22.10.2026“*
(`ZIEL.md:142`) datiert und darf 97 behalten. Die beiden zitierten Sätze sind
nicht datiert und stehen im Präsens. [LEKTOR-53](LEKTOR-53.md#lektor-53) hat dieselbe Zahl schon am
23.10.2026 als veraltet gemeldet (`Befunde/LEKTOR-53.md:321-327`). **Gemessen.**

**Vorschlag:** In beiden Sätzen die Zahl weglassen und auf
`pruefe-regressionstest.pl` verweisen. Das schlug schon [L-53.12](LEKTOR-53.md#l-53.12) vor.

### <a id="l-104.5"></a>L-104.5 — BEFUNDE.md sagt, die Release-Notizen nennen den Rückstand

**Gewicht: Widerspruch, Rest von [L-101.1](LEKTOR-101.md#l-101.1).** `Intern/BEFUNDE.md:159-160` gegen `ZIEL.md:114-115`

Worum es geht: Eine Datei sagt, der Rückstand an Tests sei in den
veröffentlichten Notizen genannt. Er ist es nicht.

> `BEFUNDE.md:160` *„**Er hält das Release 7.2.1 nicht auf** — … die
> Release-Notizen nennen ihn, und er wird vor jedem neuen Thema
> abgearbeitet“*
>
> `ZIEL.md:114-115` *„Die Release-Notizen zu 7.2.1.128 nennen den Rückstand
> **nicht** (gemessen am 30.10.2026, [L-100.1](LEKTOR-100.md#l-100.1))“*

Die Messung oben (Funde aus [LEKTOR-103](LEKTOR-103.md#lektor-103)) gibt ZIEL.md recht. [L-101.1](LEKTOR-101.md#l-101.1) hat den
Satz in ZIEL.md berichtigt, die Parallelstelle in BEFUNDE.md nicht. Gleich
davor stehen in `:159` die Zahlen vom 22.10.2026 (*„15 von 64 mit
automatischem Testfall … 49 ohne jede Prüfung.“*) mit dem Satz *„Das ist der
Rückstand.“* im Präsens. Heute misst das Werkzeug *„mit Testfall im
Pruefstand 59 von 72 … OHNE jede Pruefung 11“*. **Gemessen.**

**Vorschlag:** In `:160` „nennen ihn“ durch „nennen ihn nicht (siehe
ZIEL.md)“ ersetzen. „Das ist der Rückstand“ wird zu „Das war damals der
Rückstand; heute zählt ihn `perl tools/pruefe-regressionstest.pl`“.

## Bestand ohne Fund

* `Intern/WEITERMACHEN.md`: Kopf (`:3`), Liste „Nach dem Release 7.2.1“, die
  erzeugte Tabelle (47 Zeilen) und die Entscheidungen 1 bis 20 passen
  zueinander. Die *„11 kritische Befunde ohne jede Prüfung“* in `:33`
  stimmen mit dem Werkzeug (gemessen). Entscheidung 1 und 10 verweisen auf
  Entscheidung 20.
* [E-120](../Intern/BEFUNDE.md#e-120) herabgestuft (`87089d6f`): steht nicht mehr unter den kritischen
  Befunden ohne Prüfung (gemessen); `CHANGELOG.md:118` nennt es.
* `release-veroeffentlichen.ps1` weist 7.2.0.N ab: `CHANGELOG.md:120`
  beschreibt das zutreffend (belegt am Diff von `87089d6f`).
* `README.en.md:36-39` verweist für bekannte Fehler auf die deutsche README.
  Dass dort keine Kennungen stehen, ist gewollt.
* Die „Zur Kenntnis“-Liste von `doku-pruefen.pl` (15 Dateien ohne die
  aktuelle Fassung) besteht aus Archiv-, Hintergrund- und Testdatendateien.
  In den Stichproben (`Doku/FAQ.md`, `Testdaten/README.md`) behauptet keine
  davon einen Gegenwartsstand.

## Mechanisch (zitiert, gemessen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 50 … Kein Widerspruch gefunden.“*; dazu 15 „Zur Kenntnis“-Zeilen wie bei [LEKTOR-103](LEKTOR-103.md#lektor-103). Es vergleicht Fassungsnummern, keine Zählungen; die Funde oben kann es nicht sehen |
| `perl tools/offene-befunde.pl` | *„47 offene Befunde, in beiden Listen gleich.“* (5 aktuell, 26 veraltet, 16 nie gemessen) |
| `perl tools/pruefe-regressionstest.pl` | *„Befunde insgesamt 219 … mit Testfall 96 … behoben und OHNE Testfall 50 … mit Testfall im Pruefstand 59 von 72 … OHNE jede Pruefung 11 … Kein neues "behoben" ohne Regressionstest.“* |
| `perl tools/ziel-stand.pl` | *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* Es zählt die Kriterien, nicht die Sätze, die [L-104.4](#l-104.4) trifft |

## Nicht geprüft

* Nicht jede der 64 Dateien Zeile für Zeile. Ganz gelesen: WEITERMACHEN.
  Abschnittsweise: der Kopf von CHANGELOG bis 7.2.1.128, die Abschnitte zu
  Regressionstests in ZIEL und BEFUNDE, der Zuwachs im TESTPLAN. Die übrigen
  Dateien nur nach Standaussagen durchsucht (`Stand …`, „nächste Paket“,
  „7.2.1.129“, Testzahlen, Kennungen der README).
* Ob die elf neuen Tests prüfen, was ihr Name sagt: das ist Sache des
  PRÜFERS (laut Commit-Haken fällig).
* Nichts am laufenden Programm.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Weiter offen aus [LEKTOR-103](LEKTOR-103.md#lektor-103).
  `ZIEL.md:37-38` sagt, dass er fehlt; deine Anordnung vom 23.10.
  (*„für release dokumentieren wir, daß die fehlenden regression tests
  nachgeholt werden“*) ist damit noch nicht erfüllt.
* **In 7.2.1.128 verschiebt ein Filter mit „… doesn't appear“ und der
  Aktion *transfer* jede Nachricht, nicht nur die passenden
  ([L-104.1](#l-104.1)). Soll dazu eine Warnung in den veröffentlichten Text
  von `v7.2.1.128`, oder soll bald ein Release 7.2.1.129 mit der Behebung
  kommen?** Die Behebung ist übersetzt und hat einen Regressionstest, ist aber
  in keinem Paket.
