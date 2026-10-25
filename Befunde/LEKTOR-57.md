# <a id="lektor-57"></a>LEKTOR-57 — Bestandsprüfung nach PR #170 bis #172 und PRÜFER-50 (E-119 K5, E-148, Prüfbericht, neue Haken), 25.10.2026

**Auftrag.** Nach [LEKTOR-56](LEKTOR-56.md#lektor-56) (`d880fb7f`) kamen
20 Commits, `git log d880fb7..5403acf8`: PR #170 ([E-119](../Intern/BEFUNDE.md#e-119) K5, eine
eigene Bilddatei je Nachricht), PR #171 ([E-148](../Intern/BEFUNDE.md#e-148), vier eMudhra-Wurzeln aus
`rootcerts.p7b` genommen), PR #172 (Prüfbericht je Test mit Zeitpunkt und
Bau), [PRÜFER-50](PRUEFER-50.md#pruefer-50) mit [E-146](../Intern/BEFUNDE.md#e-146), die Behebungen der
PRÜFER-50-Funde K2, K3, K4 und K12 an den Schranken und drei neue Werkzeuge
(`haken-pr-lektor.pl`, `sitzungsbeginn.pl`, `auftrag-rolle.pl`) auf dem Zweig
`agenten-befunde-25-10`. Geprüft wurde **der Bestand**, nicht der Diff: jede
Datei aus `git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/`, dazu
die PRÜFER-Berichte dort, wo der Auftrag sie nennt. Maßstab von außen:
`Eudora71/Version.h` (`7.2.0.122`), `VERSION` (`1.0.122`), `git tag`
(zuletzt `v1.0.120`), `origin/main` (enthält #170, #171, #172; nicht
`2277a5a9` und später, gemessen mit `git merge-base --is-ancestor`), die
Ausgaben der Werkzeuge selbst.

**Ergebnis vorweg.**

* **Der Sitzungsbeginn-Haken nennt keinen einzigen offenen Befund.**
  `CLAUDE.md:13` sagt über `offene-befunde.pl`: *„Das nennt jeden Befund, der
  … als offen steht"*. Das Werkzeug gibt nur Zahlen aus, und der neue Haken
  reicht nur diese Zahlen weiter. Der Schritt, der seit [E-85](../Intern/BEFUNDE.md#e-85) verhindern soll,
  dass ein Agent einen schon beschriebenen Fehler neu erarbeitet, liefert
  keine Kennung ([L-57.1](#l-57.1)).
* **Die PR-Schranke öffnet sich mit dem ersten Gerüst des LEKTOR-Berichts.**
  Gemessen an diesem Lauf: nach meinem Commit *„[LEKTOR-57](#lektor-57): Geruest"* (Inhalt
  *„In Arbeit"*) meldet `rollen-faellig.pl` den LEKTOR *„aktuell"*, und
  `gh pr create` ginge durch. Dazu lässt der Haken den PR durch, wenn die
  Sitzung nicht in der Wurzel steht oder der Befehl in Anführungszeichen
  steckt ([L-57.2](#l-57.2)).
* **Die Zählung der Regressionstests übersieht Prüfstandsfälle mit
  Buchstaben.** `E-108p`, `E-106p` und `E-119a` bis `d` zählen nicht für
  [E-108](../Intern/BEFUNDE.md#e-108), [E-106](../Intern/BEFUNDE.md#e-106) und [E-119](../Intern/BEFUNDE.md#e-119). Gemessen: drei Befunde mehr mit Test,
  [E-108](../Intern/BEFUNDE.md#e-108) (Absturz beim Antworten, kritisch) fällt aus der Liste *„OHNE jede
  Prüfung"* ([L-57.3](#l-57.3)). Der Prüfbericht vom Morgen ist schon wieder
  überholt, und zwei seiner Schrankenzeilen wurden mit den alten, blinden
  Schranken gemessen ([L-57.4](#l-57.4)).

**Stand der 10 Funde aus [LEKTOR-56](LEKTOR-56.md#lektor-56):** 0 erledigt,
2 teilweise, 8 offen (Teil 1). Die 13 offenen aus [LEKTOR-55](LEKTOR-55.md#lektor-55) sind
unverändert (gemessen: `git diff --stat d880fb7..HEAD` berührt `ZIEL.md`,
`Intern/AUFGABEN.md`, `Intern/TESTPLAN.md`, `Doku/ANWENDER.md`,
`Intern/PORTIERUNG.md` nicht). **10 neue Funde**: 3 falsch, 3 veraltet,
3 unvollständig, 1 Form. **Eine neue Frage an Gregor**, dazu die alte, am
Ende.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

---

## Mechanisch zuerst

Gemessen am 25.10.2026 gegen 11:00 in diesem Arbeitsbaum (`5403acf8`).
Übernommen nicht als Urteil.

| Werkzeug | Ausgabe | was sie nicht sagt |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden."*, 46 Dateien, 13 Hinweise *„nennt weder den Quellstand …"*. Der Hinweis zu `Releases/PRUEFBERICHT.md` aus [LEKTOR-56](LEKTOR-56.md#lektor-56) ist weg | dass der Prüfbericht nach dem Commit, nicht nach der Fassung veraltet ([L-57.4](#l-57.4)); `Intern/ABRUF-PRUEFEN.md:106` nennt 121 Zertifikate ([L-57.9](#l-57.9)) |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 38 … davon NIE gemessen 11 … 38 offene Befunde, in beiden Listen gleich."* | **welche** 38: das Werkzeug nennt keine Kennung ([L-57.1](#l-57.1)); die PRÜFER-49- und PRÜFER-50-Funde in *behoben*-Zeilen zählen nicht ([L-57.6](#l-57.6)) |
| `perl tools/pruefe-regressionstest.pl` | 202 Befunde, **58** mit Testfall ([LEKTOR-56](LEKTOR-56.md#lektor-56): 64), 74 behoben ohne Testfall; kritisch 68, davon 39 mit Testfall, **27 ohne jede Prüfung**, darunter neu [E-108](../Intern/BEFUNDE.md#e-108) | dass Fälle wie `E-108p` nicht gezählt werden ([L-57.3](#l-57.3)) |
| `perl tools/ziel-stand.pl` | *„19 von 19 erfüllt, 0 offen - ZIEL.md ist auf dem Stand."* | wie [L-56.1](LEKTOR-56.md#l-56.1), unverändert |
| `perl tools/pruefe-befundurteile.pl` | *„Kein Dokument erklaert einen offenen Befund fuer erledigt"* | `README.md:160`, `:161`, `:163` nennen [E-119](../Intern/BEFUNDE.md#e-119), [E-113](../Intern/BEFUNDE.md#e-113)/[E-116](../Intern/BEFUNDE.md#e-116) und [E-77](../Intern/BEFUNDE.md#e-77) weiter als bekannte Fehler ([L-55.6](LEKTOR-55.md#l-55.6)) |
| `perl tools/rollen-faellig.pl --nur-melden` | vor meinem ersten Commit: *„LEKTOR ist faellig … 8 Datei(en)"*; danach: *„LEKTOR aktuell (Bericht 692d27d …)"* | dass `692d27d` ein leeres Gerüst ist ([L-57.2](#l-57.2)) |

Der erste Commit wurde von `pruefe-stand-md.pl` abgewiesen: *„Intern/LEKTORAT.md nennt
1 von 57 Berichten des LEKTOR nicht"*. Der Abschnitt in `LEKTORAT.md` musste
mit dem Gerüst entstehen. Das ist richtig so, nur steht es nicht im
Auftragstext.

---

## <a id="teil-1"></a>Teil 1 — Die 10 Funde aus LEKTOR-56, Stand heute

| Fund | worum es ging | heute | Beleg |
|---|---|---|---|
| [L-56.1](LEKTOR-56.md#l-56.1) | `ZIEL.md` meldet *„Alle Zeilen des Maßstabs sind erfüllt"*, zwei Kriterien heißen *„fast"* | **offen** | `ZIEL.md:20` *„**Stand: 19 von 19 erfüllt, 0 offen.**"*, `:26`; Datei seit `d880fb7` unverändert (gemessen) |
| [L-56.2](LEKTOR-56.md#l-56.2) | [E-142](../Intern/BEFUNDE.md#e-142) (Entwurf aus IMAP-Ordner ergibt leere Nachricht in `Out`): Gregor hat einen Hinweis entschieden, Urteil und Listen sagen „messen, dann beheben" | **offen** | `Intern/BEFUNDE.md:378` weiter *„Verloren geht nichts … Die Behebung fehlt noch."*; `CHANGELOG.md:31` und `Intern/WEITERMACHEN.md:355` *„die Ursache der leeren Kopie messen"* |
| [L-56.3](LEKTOR-56.md#l-56.3) | [E-116](../Intern/BEFUNDE.md#e-116) (Bildbreite `35px`) geschlossen, vier Stellen sagen „eingebaut" oder „bekannter Fehler" | **offen** | `CHANGELOG.md:118-119` *„Am laufenden Programm noch nicht gesehen — deshalb im Befund „eingebaut""*; `Intern/AUFGABEN.md:414`; `Testdaten/README.md:40`; `README.md:161` |
| [L-56.4](LEKTOR-56.md#l-56.4) | [E-113](../Intern/BEFUNDE.md#e-113) Variante B (Bild passt sich beim Schmalerziehen nicht an) entschieden, Zelle sagt „Was noch fehlt: alles" | **offen** | `Intern/BEFUNDE.md:359` *„**Was noch fehlt:** alles"*, *„Danach Fenstergröße ändern und noch einmal sehen."*; `CHANGELOG.md:147`; `Intern/AUFGABEN.md:100` *„**Weiter offen: [E-113](../Intern/BEFUNDE.md#e-113)**"* |
| [L-56.5](LEKTOR-56.md#l-56.5) | „Vor dem Release" in `ZIEL.md` ohne Gregors Entscheidungen 1 und 4 | **offen** | `ZIEL.md:57-59` weiter mit dem Beispiel *„7.2.1.123"* |
| [L-56.6](LEKTOR-56.md#l-56.6) | sechs Lücken aus PRÜFER-49 nur in *behoben*-Zeilen | **teilweise.** K5 (das Löschen einer Nachricht nahm der anderen das `data:`-Bild) ist behoben, gemessen rot/grün, Regressionsfall `E-119d`. Weiter nur in *behoben*-Zeilen: K3 (eine alte gespeicherte Nachricht mit Ablage in einen Umlaut-Ordner legt ihre Kopie nicht mehr ab), K6 (`data:`-Bilder über 48 KB kommen abgeschnitten an), K7 (eine Weiterleitung trägt den lokalen Pfad mit dem Windows-Benutzernamen hinaus), K9, K10 | `CHANGELOG.md:137-141`; `Intern/BEFUNDE.md:365` (K5 durchgestrichen, K6/K7 nicht); gemessen: `git grep 'PRUEFER-49.md#k[3679]'` außerhalb `Befunde/` nur in `BEFUNDE.md:324`, `:359`, `:365`; im CHANGELOG kein Satz zu K3 oder K7 |
| [L-56.7](LEKTOR-56.md#l-56.7) | `Releases/PRUEFBERICHT.md` nannte das nie geschnürte 1.0.121, kein Werkzeug rief den Erzeuger auf | **teilweise, im Kern erledigt.** Neu erzeugt am 25.10.2026 09:39 an `ac3f2f29`, jeder Test einzeln mit Zeitpunkt und Bau, `--vergleich`; `paket-bauen.ps1:419-448` baut kein Paket ohne *BESTANDEN*; `README.md:77` verweist darauf, `:88` trennt die beiden Dateien gleichen Namens. Offen: `Intern/TESTPLAN.md:251` *„277 Tests"* (Bericht: 295); und der Bericht ist schon wieder überholt → [L-57.4](#l-57.4) | `Releases/PRUEFBERICHT.md:1-9`; `tools/paket-bauen.ps1:419-448`, `:494-495` |
| [L-56.8](LEKTOR-56.md#l-56.8) | `AUFGABEN.md` nennt [E-86](../Intern/BEFUNDE.md#e-86) und [E-77](../Intern/BEFUNDE.md#e-77) als Lücke von Kriterium 2 | **offen** | `Intern/AUFGABEN.md:24-26` |
| [L-56.9](LEKTOR-56.md#l-56.9) | zwei Prüfnachrichten und sechs Regressionsfälle fehlen in ihren Verzeichnissen | **offen**, jetzt sieben Fälle (`E-119d` dazu) | gemessen: `grep -n "e11[39]" Testdaten/README.md` → nichts; `tools/WERKZEUGE.md:136` zählt weiter nur `E-103p` … `BILD-lauf` |
| [L-56.10](LEKTOR-56.md#l-56.10) | README zählt 112 Prüfberichte, 109 Lehren | **offen** | `README.md:94-95`; gemessen: `git ls-files 'Befunde/*.md' \| wc -l` → 126 vor diesem Bericht, `Arbeitsweise/*.md` → 131 |

---

## Teil 2 — Die neuen Haken gegen CLAUDE.md und WERKZEUGE.md

### <a id="l-57.1"></a>L-57.1 — CLAUDE.md Abschnitt 1 verspricht eine Liste der offenen Befunde; Werkzeug und Sitzungsbeginn-Haken liefern nur Zahlen

**Gewicht: falsch (Kern der wichtigsten Regel).** `CLAUDE.md:7-14`, `:54-64`; `tools/sitzungsbeginn.pl:1-4`, `:25-28`; `tools/offene-befunde.pl:394-402`; `tools/WERKZEUGE.md:149`; `.claude/settings.json`

Worum es geht: `CLAUDE.md` Abschnitt 1 steht an erster Stelle, weil ein Agent
am 14.09.2026 zwei Tage an einem Fehler suchte, dessen Antwort fertig in
`BEFUNDE.md` stand: [E-85](../Intern/BEFUNDE.md#e-85) (Umlaute kommen über IMAP falsch an), die Antwort
stand unter [NP3-8](../Intern/BEFUNDE.md#np3-8). Die Regel lautet: zu Beginn lesen und verstehen, **was**
offen ist.

**Belegt:**

> `CLAUDE.md:13-14`: *„Das nennt jeden Befund, der in BEFUNDE.md als offen steht, und gleicht ihn gegen WEITERMACHEN.md ab."*
> `tools/sitzungsbeginn.pl:3`: *„Faehrt die Schritte aus CLAUDE.md, Abschnitte 1 und 3"*

**Gemessen:** `perl tools/offene-befunde.pl` gibt 13 Zeilen aus, nur Zahlen
(*„offen laut Intern/BEFUNDE.md 38 … davon NIE gemessen 11 … 38 offene
Befunde, in beiden Listen gleich."*). Keine Kennung, kein Kurzsatz. Die
Ausgabe stammt aus `offene-befunde.pl:394-402`. Eine Liste schreibt das
Werkzeug nur mit `-schreiben` in `WEITERMACHEN.md` und `CHANGELOG.md`.
`sitzungsbeginn.pl:25-28` filtert aus dieser Ausgabe noch einmal drei
Zahlenzeilen heraus. Was zu Sitzungsbeginn im Kontext landet, ist *„38
offen, 11 nie gemessen"*.

**Dazu, belegt:**

* `CLAUDE.md` nennt keinen der beiden Haken (gemessen: `grep -n -i
  "haken\|sitzungsbeginn\|settings.json" CLAUDE.md` → nichts). Wer `CLAUDE.md`
  liest, fährt Abschnitt 1 und 3 von Hand noch einmal. Wer sich auf den
  Haken verlässt, glaubt Abschnitt 1 erledigt.
* Abschnitt 3 nennt drei Befehle (`:57-59`). Der Haken fährt
  `rollen-faellig.pl` und `gesichert.pl`, **nicht** `paket-bereit.pl`
  (`sitzungsbeginn.pl:30-43`). Der Kopf *„Abschnitte 1 und 3"* stimmt also
  auch für Abschnitt 3 nur zum Teil.
* Die Haken stehen nur auf `agenten-befunde-25-10`, nicht auf `origin/main`
  (gemessen: `5403acf8` ist nicht in `origin/main`). Ein Arbeitsbaum, der
  von `main` abzweigt, hat sie nicht.

**Vorschlag:** Der Haken gibt die 38 Kennungen mit ihrem Kurzsatz aus, in
der Reihenfolge der erzeugten Tabelle *Noch offen* in `WEITERMACHEN.md`, mindestens
Kennung und erste Spalte. 38 Zeilen sind für den Kontext tragbar. Ein
Verweis auf die Tabelle allein reicht nicht: Bei [E-85](../Intern/BEFUNDE.md#e-85) stand die Antwort
lesbar im Repo und wurde trotzdem nicht gelesen. `CLAUDE.md:13` richtigstellen (*„zählt die offenen
Befunde; die Liste steht in WEITERMACHEN.md, Noch offen"*) und in
Abschnitt 1 und 3 je einen Satz: *„Läuft als SessionStart-Haken
(`tools/sitzungsbeginn.pl`); von Hand bleibt: die Liste lesen, und
`paket-bereit.pl`."* Gegenprobe: einen offenen Befund in `BEFUNDE.md`
zufügen, der Haken muss seine Kennung zeigen.

### <a id="l-57.2"></a>L-57.2 — die PR-Schranke für den LEKTOR öffnet sich mit dem Gerüst des Berichts, außerhalb der Wurzel und bei einem Befehl in Anführungszeichen

**Gewicht: unvollständig (gewichtig: die Schranke ist das, was Gregor verlangt hat).** `tools/haken-pr-lektor.pl:42-50`, `:60-67`; `tools/rollen-faellig.pl:100-112`; `tools/WERKZEUGE.md:148`; `tools/auftraege/LEKTOR.txt:20`

Worum es geht: `haken-pr-lektor.pl` soll verhindern, dass ein PR entsteht,
bevor der LEKTOR über den Stand gelaufen ist. Laut Kopf `:7-10` war der
Anlass, dass #170, #171 und #172 ohne LEKTOR hinausgingen. Drei Wege lassen den PR
trotzdem durch.

**1. Ein leeres Gerüst genügt.** **Gemessen:**

```
vor meinem ersten Commit:  - LEKTOR ist faellig: seit seinem Bericht (d880fb7) haben sich 8 Datei(en) … geaendert
nach Commit 692d27d:         LEKTOR    aktuell (Bericht 692d27d, seither 0 Dateien in seinem Bereich)
```

`692d27d` ist *„[LEKTOR-57](#lektor-57): Geruest"*, Inhalt *„**In Arbeit.** Gerüst,
gesichert vor dem ersten Abschnitt."* `rollen-faellig.pl:112` sieht nur, dass
eine Datei `Befunde/LEKTOR-*.md` committet wurde, nicht, ob der Bericht fertig
ist. Der Auftragstext verlangt das frühe Gerüst ausdrücklich (*„FRUEH
SICHERN: sobald der Bericht ein Gerüst hat"*, Platzhalter `{SICHERN}` in
`tools/auftraege/LEKTOR.txt:20`). Holt der Hauptagent den Zweig nach dem
ersten Sichern, ist die Schranke offen. **Vermutung:** Genau das ist der
naheliegende Ablauf, wenn der LEKTOR länger braucht.

**2. Außerhalb der Wurzel fällt sie offen.** `:42-43` setzt die Wurzel auf
`cwd` aus dem Haken-Aufruf und ruft `perl "$wurzel/tools/rollen-faellig.pl"`.
Steht die Sitzung in `tools/` oder `Eudora71/`, gibt es die Datei nicht, die
Ausgabe enthält kein *„LEKTOR ist faellig"*, und `:50` gibt 0 zurück.

**3. Ein Befehl in Anführungszeichen geht durch.** `nur_befehle` (`:60-67`)
entfernt alle Zeichenketten in Anführungszeichen, damit eine
Commit-Nachricht nicht abgewiesen wird. Dabei fällt auch
`bash -c "gh pr create …"` weg.

**Gemessen zu 2. und 3.** mit einer Kopie des Hakens im Notizverzeichnis. In
ihr ist die Antwort von `rollen-faellig.pl` auf *„LEKTOR ist faellig"*
gesetzt, wenn die Datei gefunden wird. Sonst ist sie unverändert:

| Aufruf | Rückgabe |
|---|---|
| `gh pr create`, `cwd` = Wurzel | **2** (abgewiesen) |
| `gh pr create`, `cwd` = Wurzel`/tools` | **0** (durch) |
| `bash -c "gh pr create"`, `cwd` = Wurzel | **0** (durch) |
| `gh pr create`, ohne `cwd` | 2 |

`tools/WERKZEUGE.md:148` beschreibt keine der drei Grenzen und sagt *„Live
gegengeprüft"*. Der `--selbsttest` (10 Fälle) prüft nur die Erkennung des
Befehls, nicht Wurzel und Gerüst.

**Vorschlag:** (1) `rollen-faellig.pl` zählt einen LEKTOR-Bericht erst, wenn
sein Abschnitt in `LEKTORAT.md` nicht mehr *„In Arbeit"* sagt, oder an einer
Schlussmarke im Bericht. (2) Die Wurzel mit `git -C <cwd> rev-parse
--show-toplevel` bestimmen. Schlägt der Aufruf fehl, weist der Haken ab,
statt durchzulassen. (3) Ein `gh pr create` innerhalb von `-c "…"` oder
`-Command "…"` zählt mit. In WERKZEUGE.md die Grenzen nennen, die bleiben.
Gegenprobe je Fall in den Selbsttest.

### <a id="l-57.3"></a>L-57.3 — die Zählung der Regressionstests übersieht Prüfstandsfälle mit Buchstaben; E-108 steht deshalb „ohne jede Prüfung"

**Gewicht: falsch (Zahl, auf die 7.2.1.0 wartet).** `tools/pruefe-regressionstest.pl:96-106`, `:144-148`; `tools/pruefstand-faelle.txt:180`; `Befunde/PRUEFER-50.md:425-437`

Worum es geht: `pruefe-regressionstest.pl` zählt, welche Befunde einen
Regressionstest haben. Die Fälle aus `pruefstand-faelle.txt` werden als
Kennung gesammelt (`:96-106`) und mit `/\QE-108\E\b/` gesucht (`:147`). In
`E-108p` folgt auf [`E-108`](../Intern/BEFUNDE.md#e-108) ein Buchstabe, `\b` greift nicht, der Fall zählt
nicht für [E-108](../Intern/BEFUNDE.md#e-108).

**Gemessen** mit einer Kopie im Notizverzeichnis, in der nur `:147` statt
`\b` ein `(?![0-9])` trägt:

| | heute | mit Buchstaben-Fällen |
|---|---|---|
| Befunde mit Testfall | 58 | **61** |
| behoben ohne Testfall | 74 | 72 |
| kritisch mit Testfall | 39 von 68 | 40 von 68 |
| kritisch ohne jede Prüfung | 27 | 26, **ohne [E-108](../Intern/BEFUNDE.md#e-108)** |

Gemessen sind die drei Befunde: [E-106](../Intern/BEFUNDE.md#e-106), [E-108](../Intern/BEFUNDE.md#e-108) und [E-119](../Intern/BEFUNDE.md#e-119). Ihre Kennung kommt
in keinem Code der Testsuite vor (`grep -v '^\s*//' Eudora71/Tests/*.cpp`),
nur als `E-106p`, `E-108p` und `E-119a` bis `d` am Prüfstand. **[E-119](../Intern/BEFUNDE.md#e-119)** ist am
24.10.2026 auf *behoben* gegangen, mit vier Regressionsfällen, und wird
trotzdem unter *„behoben und OHNE Testfall"* geführt.

**Widerspruch, belegt:** [PRÜFER-50 K4](PRUEFER-50.md#k4) nennt [E-108](../Intern/BEFUNDE.md#e-108)
*„Absturz beim Antworten, kritisch"*, für den es keinen Test gebe. Die
Commit-Nachricht `2277a5a9` nimmt *„[E-108](../Intern/BEFUNDE.md#e-108) (kritisch, Absturz beim
Antworten) steht jetzt unter 'OHNE jede Pruefung'"* als bestandene
Gegenprobe. `tools/pruefstand-faelle.txt:180` führt
`E-108p | C:\Temp\EBILD | … | Logging shutdown | Exception`, grün in
`Releases/PRUEFBERICHT.md` (Abschnitt 3). **Nicht geprüft:** ob `E-108p` den
Absturz aus [E-108](../Intern/BEFUNDE.md#e-108) wirklich auslöst. Das ist Sache des PRÜFERS. Gezählt
gehört der Fall aber, oder er gehört umbenannt.

**Vorschlag:** in `:147` die Buchstaben-Nachsilbe zulassen, Gegenprobe
`--selbsttest` um einen Fall `E-998p` erweitern (muss zählen) und um
`E-9981` (darf nicht für `E-998` zählen). Danach prüft der PRÜFER, ob
`E-108p` [E-108](../Intern/BEFUNDE.md#e-108) trifft. Die Zahlen in [L-57.4](#l-57.4) und `ZIEL.md:64-70`
ändern sich damit noch einmal.

### <a id="l-57.4"></a>L-57.4 — der Prüfbericht vom Morgen ist überholt; zwei seiner Schrankenzeilen wurden mit den Schranken gemessen, die PRÜFER-50 als blind nachgewiesen hat

**Gewicht: veraltet (gewichtig: das Testbuch zählt in einer Schranke).** `Releases/PRUEFBERICHT.md:3-9`, `:347-370`, `:411-417`; `Releases/pruefbericht-tests.tsv:1`; `tools/pruefe-regressionstest.pl:117-140`

**Gemessen:** Bericht und Testbuch stimmen untereinander: 295 Unit-Tests,
14 Schranken, 29 Prüfstandsfälle, dieselben 29 Kennungen, alle *ok*. Beide
sind erzeugt *„am 2026-10-25 09:39 fuer 7.2.0.122, Commit ac3f2f29"*
(`pruefbericht-tests.tsv:1`). Danach kamen:

| Commit | was sich änderte | was der Bericht dazu sagt |
|---|---|---|
| `2277a5a9` (K4) | Kommentare zählen nicht mehr als Test | `:413` *„Von **68** kritischen Befunden haben **40** einen Test, **26** keinen"*, [E-108](../Intern/BEFUNDE.md#e-108) fehlt in der Liste. Heute 39 und 27, mit [E-108](../Intern/BEFUNDE.md#e-108) (gemessen) |
| `20fe6a57` (K3) | `pruefe-nachrichtenschleife.pl` verlangt `PostQuitMessage`; neue Rückfallprobe [E-62](../Intern/BEFUNDE.md#e-62) | `:359` *„[E-62](../Intern/BEFUNDE.md#e-62) … ok … vorher=0 rueckfall=1"*, gemessen mit der alten Schranke und der alten Probe |
| `71fae300` (K2) | `pruefe-fensterbau.pl` prüft je Anweisung; drei neue Rückfallproben [E-35](../Intern/BEFUNDE.md#e-35) | `:364` *„[E-35](../Intern/BEFUNDE.md#e-35) … ok"*, gemessen mit der alten Schranke |
| `58113d66` (K12) | eine Schranke zählt nur, wenn das Testbuch sie grün führt | — |

**Belegt am Quelltext:** K12 (`pruefe-regressionstest.pl:121-139`) liest
aus dem Testbuch nur *ok* oder *rot* je Kennung. Ob die Zeile **nach** der
letzten Änderung an Schranke oder Probe entstand, prüft es nicht. Für
[E-62](../Intern/BEFUNDE.md#e-62) zählt damit genau die Messung, die [PRÜFER-50 K3](PRUEFER-50.md#k3) als blind
nachgewiesen hat: *„Schranke grün, obwohl `WM_QUIT` wieder verschluckt
wird"*. Zeitlich: `regression-schranken.txt` zuletzt geändert in
`71fae300` (10:21), das Testbuch stammt von `ac3f2f29` (davor). Die
Commit-Nachricht zu K12 sagt *„Schranken zaehlen nur, wenn ihre
Rueckfallprobe zuletzt gemessen abwies"*. Zuletzt gemessen ist hier vor der
Änderung. Das Muster heißt im Repo
[Prüfstand kann blind sein](../Arbeitsweise/pruefstand-kann-blind-sein.md).

**Dazu, belegt:** Der Kopf sagt *„Quellstand `7.2.0.122` (Paketnummer
`1.0.122`)"* (`:5`). Gelaufen sind die Prüfstände am Bau *„Paket
1.0.122+9402f257"*. Der enthält [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-116](../Intern/BEFUNDE.md#e-116), [E-119](../Intern/BEFUNDE.md#e-119) und [E-148](../Intern/BEFUNDE.md#e-148).
Die stecken in Gregors Paket 1.0.122 vom 23.10.2026 nicht. Wer den Kopf
liest, hält den Bericht für den Bericht zu seinem Paket
([Version eindeutig machen](../Arbeitsweise/version-eindeutig-machen.md)).
`doku-pruefen.pl` meldet nichts mehr, weil die Fassungsnummer stimmt.

**Vorschlag:** Kopf mit der Baukennung, die schon in Abschnitt 3 steht
(*„1.0.122+9402f257, nicht das Paket 1.0.122 vom 23.10.2026"*). K12 um eine
Frische-Prüfung ergänzen: Eine Schrankenzeile zählt nur, wenn ihr Commit im
Testbuch jünger ist als die letzte Änderung an Schranke und
`regression-schranken.txt`. Sonst zählt sie als *ungemessen*. Gegenprobe:
Heute muss [E-62](../Intern/BEFUNDE.md#e-62) dann unter *ohne* stehen, nach `pruefbericht.pl` wieder
gedeckt. Den Bericht neu erzeugen, wenn [L-57.3](#l-57.3) erledigt ist.

### <a id="l-57.5"></a>L-57.5 — WERKZEUGE.md beschreibt die vier geschärften Schranken im alten Stand; AGENTEN.md kennt die neuen Werkzeuge nicht

**Gewicht: veraltet.** `tools/WERKZEUGE.md:64`, `:106`, `:128`, `:131`, `:132`; `Intern/AGENTEN.md:164-186`

Die Commits zu K2, K3, K4 und K12 ändern Verhalten, das `WERKZEUGE.md`
beschreibt. Nachgezogen ist keine dieser Zeilen (gemessen: `git diff
d880fb7..HEAD -- tools/WERKZEUGE.md` berührt nur die Zeilen der drei neuen
Werkzeuge, `messen-e119-geteilt.ps1`, `pruefstaende-auffrischen.ps1`,
`pruefstand-lauf.ps1`, `pruefbericht.pl` und `gesichert.pl`). Belegt:

| Zeile | steht da | gilt seit |
|---|---|---|
| `:128` `pruefe-regressionstest.pl` | *„Gedeckt ist er mit einem automatischen Testfall, der seine Kennung nennt"* | `2277a5a9`: nur Code und Zeichenketten, keine Kommentare |
| `:132` `regression-schranken.txt` | *„zählt eine Kennung nur dann als gedeckt, wenn sie hier steht **und** ihre Schranke im pre-commit eingehängt ist"* | `58113d66`: dazu grün und nicht rot im Testbuch |
| `:131` `schranken-gegenprobe.pl` | *„13 Fälle werden rot"*, *„mit Rückfall ≠ 0"* | 18 Fälle (gemessen: `grep -v '^\s*#' tools/regression-schranken.txt \| grep -c '\S'`); nur Rückgabe 1 zählt |
| `:106` `pruefe-nachrichtenschleife.pl` | *„Schranke gegen eigene Nachrichtenschleifen, die `WM_QUIT` verschlucken"* | `20fe6a57`: `PostQuitMessage` nach `WM_QUIT` verlangt |
| `:64` `pruefe-fensterbau.pl` | *„jeder `GetButton`-Aufruf prüft sein Ergebnis auf NULL"* | `71fae300`: je Anweisung, Prüfung vor dem ersten `name->`, Aufruf ohne Namen wird gemeldet |

`Intern/AGENTEN.md:168` sagt weiter *„Bäume buchen und Kennungen vergeben,
je Agent einer, im Auftrag genannt"* als Handschritt. Seit `5403acf8`
erledigt das `auftrag-rolle.pl` für LEKTOR und PRÜFER. Schritt 7 (`:174`) ordnet
den LEKTOR nach dem Einsammeln ein, der Haken verlangt ihn vor jedem PR.
`AGENTEN.md` nennt weder das Werkzeug noch den Haken (gemessen: `grep -n -i
"auftrag-rolle\|haken-pr" Intern/AGENTEN.md` → nichts).

**Vorschlag:** die fünf Zeilen je um einen Satz *„Seit 25.10.2026 (PRÜFER-50
Kn): …"* ergänzen, die Fallzahl in `:131` streichen und auf die Liste
verweisen ([Liste aus einer Quelle](../Arbeitsweise/liste-aus-einer-quelle.md)).
In `AGENTEN.md` Schritt 2 und 7 auf `auftrag-rolle.pl` und den PR-Haken
verweisen.

---

## Teil 3 — Befunde, Pläne und Außenwirkung

### <a id="l-57.6"></a>L-57.6 — acht Funde aus PRÜFER-50 stehen in keiner Liste; einer davon ist Programmverhalten

**Gewicht: unvollständig.** `Befunde/PRUEFER-50.md:566-582`; `Intern/BEFUNDE.md:381`; `tools/ZWEIGE.md:183`; `Intern/WEITERMACHEN.md:136-142`

[PRÜFER-50](PRUEFER-50.md#pruefer-50) hat 13 Funde. Eingearbeitet sind K8
(als [E-146](../Intern/BEFUNDE.md#e-146): ein umbenannter IMAP-Ordner heißt in Eudora anders als
am Server, wenn der Server kein Trennzeichen hat oder INBOX mit Präfix umbenannt wird) und K2, K3, K4 und
K12 (Schranken und Zählung, Commits oben). **Gemessen:** `git grep -n
"[PRUEFER-50](PRUEFER-50.md#pruefer-50)\|PRÜFER-50"` außerhalb `Befunde/` und `Arbeitsweise/` findet
nur `BEFUNDE.md:381` ([E-146](../Intern/BEFUNDE.md#e-146)), `LEKTORAT.md`, `WEITERMACHEN.md:140` (ohne
Bezug auf die Funde), `AGENTEN-LAUFEN.md:12` (PRÜFER-51 läuft) und
`ZWEIGE.md:183`. Die übrigen acht stehen nirgends:

| Fund | was passiert | Schwere laut PRÜFER-50 |
|---|---|---|
| [K1](PRUEFER-50.md#k1) | der Regressionstest zu [E-20](../Intern/BEFUNDE.md#e-20) ist grün, wenn der ursprüngliche Überlauf ohne Leerzeichen zurückkommt | wichtig (Prüfstand) |
| [K5](PRUEFER-50.md#k5) | der Test zu [E-25](../Intern/BEFUNDE.md#e-25) ist grün bei einer Doppelfreigabe in anderer Schreibweise | mittel |
| [K7](PRUEFER-50.md#k7) | der Testfall zu [E-77](../Intern/BEFUNDE.md#e-77) prüft Aufrufnamen, nicht die Gleichheit der Namen | mittel |
| [K11](PRUEFER-50.md#k11) | `E-113b2` ist grün, auch wenn das Fenster nicht schmaler wurde | mittel |
| [K6](PRUEFER-50.md#k6) | der Test zu [E-18](../Intern/BEFUNDE.md#e-18) prüft die Reihenfolge, nicht die Wirkung | gering |
| [K9](PRUEFER-50.md#k9) | **Programm:** Lehnt der Server das Umbenennen ab oder bricht die Verbindung ab, bleibt der Ordner in Eudora umbenannt, am Server nicht (Original von QUALCOMM) | gering |
| [K10](PRUEFER-50.md#k10) | `E-77d` verlangt nicht, dass der Ordner danach geöffnet wurde | gering |
| [K13](PRUEFER-50.md#k13) | [S-2](../Intern/BEFUNDE.md#s-2) über die Projektdatei; „überholt" genügt eine Ursache | gering |

PRÜFER-50 schreibt dazu (`:56-59`): *„Sie gehören aber vor **7.2.1.0**, für
das Gregor angeordnet hat, dass alle Regressionstests laufen und bestehen:
ein Test, der den Fehler nicht sieht, besteht dort auch."* `ZWEIGE.md:183`
nennt als Zweck *„die Schwaechen der Regressionstests K1-K4 beheben"*. K1
ist nicht behoben (gemessen: `git log --grep K1 d880fb7..HEAD` → nichts).
**Vermutung:** in Arbeit. K9 ist der einzige Fund über Programmverhalten
ohne Kennung. Ob er eine bekommt, entscheidet der Hauptagent.

Dieselbe Fehlerklasse wie [L-56.6](LEKTOR-56.md#l-56.6): Was nur im Bericht
steht, zählt `offene-befunde.pl` nicht, und `pruefe-regressionstest.pl`
zählt die Tests aus K1, K5, K6, K7, K10 und K11 weiter als Deckung.

**Vorschlag:** eine Liste *„Regressionstests, die ihren Fehler nicht sehen"*
(in `WEITERMACHEN.md` unter dem Rückstand oder als Spalte in
`regression-schranken.txt`), aus der `pruefe-regressionstest.pl` die
Kennung als *nicht gedeckt* liest, bis der Test nachgeschärft ist. Für K9
eine Kennung oder in [E-146](../Intern/BEFUNDE.md#e-146) ein Satz, warum nicht.

### <a id="l-57.7"></a>L-57.7 — „Als Nächstes" in WEITERMACHEN.md ist abgearbeitet; der nächste Schritt steht nirgends, und E-148 heißt „auf dem Zweig"

**Gewicht: veraltet.** `Intern/WEITERMACHEN.md:3`, `:9`, `:132`, `:134-140`; `Intern/BEFUNDE.md:380`

**Belegt:**

> `:140`: *„**Als Nächstes, Stand 24.10.2026 spät:** (1) PR mit [E-119](../Intern/BEFUNDE.md#e-119) K5 … (2) **[E-148](../Intern/BEFUNDE.md#e-148)** auf dem Zweig `e-148-emudhra-wurzeln` … (3) **Prüfbericht** neu bauen — **erledigt am 25.10.2026**"*

**Gemessen:** (1) ist PR #170 (`032895e5`), (2) ist PR #171 (`492878c6`), beide
in `origin/main`. Nur (3) trägt *erledigt*. Die Reihenfolge `:134-137`
(Bild-Regressionsfälle, [E-119](../Intern/BEFUNDE.md#e-119) und [E-113](../Intern/BEFUNDE.md#e-113) beheben, alle Bildfälle fahren) ist
ebenfalls erledigt: alle 17 Bildfälle am Prüfstand `C:\Temp\EBILD` sind grün im Prüfbericht. Sie
trägt keinen Haken. Offen bleibt Schritt 4, der Rückstand an
Regressionstests. Was danach kommt, steht nicht da: PRÜFER-50 einarbeiten
([L-57.6](#l-57.6)), PRÜFER-51 (läuft laut `AGENTEN-LAUFEN.md:12`), das
Paket 7.2.0.123.

Dazu weiter (wie [L-55.4](LEKTOR-55.md#l-55.4)): `:3` *„Stand 24.10.2026"*;
`:9` Quellstand mit *„Zweig `e-14-gemessen-und-rollen`"*; `:132` *„auf
`main` stecken aber schon [E-116](../Intern/BEFUNDE.md#e-116) und [E-130](../Intern/BEFUNDE.md#e-130)"*. Heute stecken dort zusätzlich
[E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-119](../Intern/BEFUNDE.md#e-119) samt K5 und [E-148](../Intern/BEFUNDE.md#e-148).

`Intern/BEFUNDE.md:380` ([E-148](../Intern/BEFUNDE.md#e-148)): *„**behoben auf dem Zweig
`e-148-emudhra-wurzeln` (25.10.2026), kommt mit Paket 7.2.0.123**"*. Seit
#171 ist das `main`. Dieselbe Klasse wie [L-55.1](LEKTOR-55.md#l-55.1).

**Vorschlag:** `:140` durch einen neuen Block *„Stand 25.10.2026"*
ersetzen, mit Haken an (1) bis (3) und an Schritt 1 bis 3. Darunter der
nächste Schritt aus dem Rückstand, PRÜFER-50 und dem Paket. In `:380` *„auf
`main` seit PR #171"*.

### <a id="l-57.8"></a>L-57.8 — für Gregors Sitzung am Paket 7.2.0.123 gibt es weiter keinen Plan; inzwischen sind es sieben Behebungen, und E-148 ist nur dort messbar

**Gewicht: unvollständig.** `Intern/TESTPLAN.md:1`, `:8`, `:251`; `Intern/BEFUNDE.md:380`; `Intern/WEITERMACHEN.md:142`

Wie [L-55.12](LEKTOR-55.md#l-55.12), jetzt mit einem Fall, der nur bei
Gregor gemessen werden kann. **Belegt:**

> `Intern/BEFUNDE.md:380` ([E-148](../Intern/BEFUNDE.md#e-148)): *„für Gregor ist nichts zu tun außer dem Test im Paket"*; *„**Nicht gemessen:** eine Verbindung durch Eudora selbst gegen einen echten Server — gemessen hat OpenSSL auf der Kommandozeile"*
> `Intern/TESTPLAN.md:8`: *„**Im Moment nichts.**"*

**Gemessen:** `grep -c "E-148" Intern/TESTPLAN.md` → 0;
`grep -c "E-148" Intern/AUFGABEN.md` → 0. Der Test, den [E-148](../Intern/BEFUNDE.md#e-148) von Gregor
erwartet, steht in keinem Plan. Er ist zugleich die erste Messung durch
Eudora selbst. Auf `main` warten jetzt [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113), [E-116](../Intern/BEFUNDE.md#e-116), [E-119](../Intern/BEFUNDE.md#e-119) mit K5,
[E-130](../Intern/BEFUNDE.md#e-130) und [E-148](../Intern/BEFUNDE.md#e-148) auf das Paket. Gregor will *„mehrere sachen zusammen
testen"* (`WEITERMACHEN.md:142`). `TESTPLAN.md:251` nennt weiter
*„277 Tests, 277 bestanden"*, der Prüfbericht 295.

**Vorschlag:** Testplan für 7.2.0.123 mit je einem Schritt: [E-148](../Intern/BEFUNDE.md#e-148) (IMAP,
POP und SMTP bei GMX und freenet über TLS; grün: kein Zertifikatsdialog,
Post kommt an), [E-77](../Intern/BEFUNDE.md#e-77) (Ordner mit Umlaut anlegen und umbenennen, GMX, IMAP),
[E-119](../Intern/BEFUNDE.md#e-119) (Weiterleitung mit `data:`-Bild senden), dazu die Gegenproben aus
[L-55.12](LEKTOR-55.md#l-55.12). Je Schritt den Ort: lokales Postfach
oder IMAP ([Testschritt nennt den Ort](../Arbeitsweise/testschritt-nennt-den-ort.md)).
`:251` auf den Prüfbericht verweisen statt eine Zahl zu führen.

### <a id="l-57.9"></a>L-57.9 — README sagt „GMX und freenet werden weiter angenommen" und rät, die Zertifikatsdatei in ältere Pakete zu legen; gemessen ist beides nicht mit Eudora

**Gewicht: falsch (Außenwirkung).** `README.md:235-237`, `:241-244`; `Intern/ABRUF-PRUEFEN.md:106`; `Intern/BEFUNDE.md:380`

**Belegt:**

> `README.md:235-237`: *„GMX und freenet (IMAP, POP3, SMTP) sind mit der neuen Liste gemessen und werden weiter angenommen"*
> `README.md:241-244`: *„**Was Sie mit einem älteren Paket tun können:** `rootcerts.p7b` im Programmverzeichnis durch die neue Datei aus `Releases/1.0/` ersetzen (Eudora vorher beenden)"*
> `Intern/BEFUNDE.md:380`: *„**Nicht gemessen:** eine Verbindung durch Eudora selbst gegen einen echten Server — gemessen hat OpenSSL auf der Kommandozeile"*

*„werden weiter angenommen"* liest ein Anwender als *„Eudora verbindet
sich weiter"*. Gemessen ist, dass `openssl s_client` mit der neuen Liste
die Kette prüft. Dass QCSSL dieselbe Prüfung macht, ist am Quelltext belegt,
nicht am Programm gemessen. Der Rat an Besitzer älterer Pakete ist eine
Handlungsanweisung nach außen, die niemand mit Eudora durchgeführt hat
([Erst prüfen, dann anweisen](../Arbeitsweise/erst-pruefen-dann-anweisen.md)).
Ob ein älteres Paket die neue Datei lädt, ist nicht gemessen.

**Gemessen:** `sha256sum Releases/1.0/rootcerts.p7b` → `07fea9d2…`, gleich
`rootcerts.p7b.sha256` und `Releases/1.0/README.md:122`. Die Datei selbst
stimmt.

**Dazu:** `Intern/ABRUF-PRUEFEN.md:106`, die Anleitung zum Prüfen eines
Pakets: *„`rootcerts.p7b` — der Wurzelzertifikatsspeicher, 121
Zertifikate"*. Wer danach das Paket 7.2.0.123 prüft, findet 117 und hält das
richtige Paket für falsch ([Doku parallel berichtigen](../Arbeitsweise/doku-parallel-nicht-hinterher.md)).

**Vorschlag:** README `:235-237`: *„… mit der neuen Liste über OpenSSL
geprüft; die Verbindung durch Eudora selbst wird am Paket 7.2.0.123
gemessen."* Den Rat `:241-244` erst nach dieser Messung geben, und dann mit dem
Paket, an dem er gemessen ist. Bis dahin: *„Eudora bis zum neuen Paket nur
im eigenen Netz benutzen."* `ABRUF-PRUEFEN.md:106` auf 117 und *„ohne
eMudhra"* setzen, oder auf die Prüfsumme verweisen statt auf eine Zahl.

### <a id="l-57.10"></a>L-57.10 — das Verlinkungswerkzeug macht aus „E-146 bleibt frei" einen Verweis auf den heutigen E-146

**Gewicht: Form.** `Befunde/PRUEFER-48.md:23`, `:529`; `Befunde/PRUEFER-49.md:46`, `:604`; `Befunde/PRUEFER-50.md:64`, `:584`

**Gemessen:** Commit `2277a5a9` hat in zwei abgeschlossenen Berichten Sätze
über **freie** Kennungen verlinkt:

> `PRUEFER-48.md:22-23`: *„[E-145](../Intern/BEFUNDE.md#e-145) und [E-146](../Intern/BEFUNDE.md#e-146) sind nicht vergeben."*; `:529` *„… und [E-146](../Intern/BEFUNDE.md#e-146) bleiben frei."*
> `PRUEFER-49.md:46`: *„**[E-146](../Intern/BEFUNDE.md#e-146) bleibt frei.**"*; `:604` *„Frei: [E-146](../Intern/BEFUNDE.md#e-146)."*

Der Verweis führt zu einem Befund, den es zur Zeit des Berichts nicht gab
und der mit diesen Berichten nichts zu tun hat. `PRUEFER-50.md:64` und
`:584` (*„E-147 bleibt frei"*) werden beim nächsten Lauf genauso verlinkt,
sobald E-147 vergeben ist.

**Gemessen an diesem Bericht:** Ich hatte die vier Stellen oben als reinen
Text zitiert. Der Commit-Haken wies ab (*„MANGEL - 4 Kennung(en) sind kein
Link."*), und `befunde-verlinken.pl --anker --verlinken` hat sie verlinkt.
Die Schranke verlangt also für **jede** Kennung mit Anker einen Link,
ohne Rücksicht auf den Satz. Ein Bericht kann nicht schreiben, dass [E-146](../Intern/BEFUNDE.md#e-146)
damals frei war, ohne auf den heutigen [E-146](../Intern/BEFUNDE.md#e-146) zu verweisen.

**Vorschlag:** Werkzeug und Schranke lassen Kennungen hinter *„frei"*,
*„nicht vergeben"* und *„bleibt frei"* ohne Link. Danach die vier Verweise in
PRÜFER-48 und PRÜFER-49 und die vier Zitate hier zurücknehmen.

---

## <a id="fragen"></a>Was nur Gregor entscheiden kann

1. **Soll die Behebung von [E-148](../Intern/BEFUNDE.md#e-148) vor 7.2.1 veröffentlicht werden?**
   Wer heute `v1.0.120` von GitHub lädt, bekommt die vier
   eMudhra-Wurzelzertifikate mitgeliefert, unter denen am 20.10.2026 acht
   kompromittierte Zwischenzertifikate bekannt wurden. Ein Angreifer im
   selben Netz (etwa öffentliches WLAN) kann Eudora damit einen falschen
   Mailserver vorspielen und Kennwort und Post mitlesen
   (`BEFUNDE.md:380`, *Stufe: kritisch*). Du hast am 24.10.2026 entschieden:
   kein Sonderbau für einzelne Behebungen. Das galt für Pakete zum Testen.
   Hier geht es darum, ob Leute **außerhalb** bis 7.2.1 mit der alten Liste
   weiterarbeiten. Möglich ist: (a) warten bis 7.2.1; (b) das Paket
   7.2.0.123 nach deinem Test veröffentlichen; (c) nur einen Hinweis auf
   der Release-Seite von `v1.0.120`.
2. **Heißt die Marke auf GitHub für 7.2.1 `v7.2.1.<n>` oder weiter
   `v1.0.<n>`?** Unverändert offen seit [LEKTOR-54](LEKTOR-54.md#lektor-54)
   (`Intern/WEITERMACHEN.md:146`). Mit Frage 1 (b) wird sie schon früher
   fällig.

Nicht hierher gehören, weil Gregor sie übertragen hat: ob K9 aus
PRÜFER-50 eine Kennung bekommt, die Reihenfolge der Tests für 7.2.0.123,
die Form des Prüfberichts und der Ausgabe zu Sitzungsbeginn, und wie die
Schranken in [L-57.2](#l-57.2) bis [L-57.4](#l-57.4) nachgeschärft werden.

---

## Geprüft und in Ordnung

* **[E-146](../Intern/BEFUNDE.md#e-146)** (`BEFUNDE.md:381`): Urteil vorn, drei Sätze ohne
  Kürzel, *Was noch fehlt* mit Datei:Zeile, Herkunft *PRÜFER-50 K8*, Stufe.
  Steht in beiden erzeugten Listen (`CHANGELOG.md:27`, `WEITERMACHEN.md:351`;
  gemessen: 38 = 38).
* **[E-119](../Intern/BEFUNDE.md#e-119) K5** in `BEFUNDE.md:365` (alter Satz durchgestrichen, Messung
  vorher/nachher, Regressionsfall `E-119d`) und `CHANGELOG.md:137-141`.
* **[E-148](../Intern/BEFUNDE.md#e-148) in `Releases/1.0/README.md`**: alle fünf Stellen mit 121
  nachgezogen (`:12`, `:62`, `:93`, `:116`, `:119`), Prüfsumme gemessen
  gleich. `README.md:147` (*Bekannte Fehler*) ist eine gültige Tabellenzeile
  mit Befundspalte (gemessen: 5 Trennstriche wie die Nachbarzeile).
* **`Releases/PRUEFBERICHT.md` gegen `pruefbericht-tests.tsv`**: gleiche
  Zahlen, gleiche 29 Fallkennungen, alle *ok* (gemessen).
* **`tools/auftraege/LEKTOR.txt`**: dieser Auftrag nennt
  `arbeitsbaum-angleichen.sh . agenten-befunde-25-10` ohne `origin/`. Der
  Fehler, der Anlass für das Werkzeug war, ist behoben.
* **`tools/ZWEIGE.md:183-186`**: `agenten-befunde-25-10`,
  `pruefbericht-vorher-nachher`, `e-148-emudhra-wurzeln` und
  `e-119-bild-geteilt` stehen mit Gregors Freigabe zum Namen.
* **`git tag`**: zuletzt `v1.0.120`. Keine Datei behauptet ein späteres
  Release (gemessen, `pruefe-release-buchfuehrung.pl` im Commit-Haken).

## Nicht geprüft

* Ob `E-108p` den Absturz aus [E-108](../Intern/BEFUNDE.md#e-108) auslöst ([L-57.3](#l-57.3)), und der Code
  der Commits zu K2, K3, K4 und K12. Das ist Sache des PRÜFERS; PRÜFER-51
  läuft.
* Ob Claude Code den Haken wirklich mit dem `cwd` eines Unterverzeichnisses
  aufruft. Gemessen ist das Verhalten des Werkzeugs bei dieser Eingabe,
  nicht der Aufruf durch Claude Code.
* Die Angaben des Artikels zu eMudhra (`README.md:212-222`): nicht
  nachgeprüft, nur dass `BEFUNDE.md:380` sie gleich wiedergibt.
* Auf dem Server liegen noch die gemergten Zweige `e-148-emudhra-wurzeln`,
  `pruefbericht-vorher-nachher` und acht alte `wt/`-Zweige (gemessen: `git
  branch -r --merged origin/agenten-befunde-25-10`). Ob sie bleiben sollen,
  ist keine Doku-Frage.
* `Arbeitsweise/` und `Befunde/` über die genannten Stellen hinaus (Auftrag).
  Im Hauptbaum sind laut Sitzungsstand `tools/AGENTEN-LAUFEN.md` und
  `tools/auftrag-rolle.pl` ungesichert geändert. Den Hauptbaum fasse ich
  nicht an.
