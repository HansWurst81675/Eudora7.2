# <a id="lektor-58"></a>LEKTOR-58 — Nachlauf nach LEKTOR-57: E-148-Nachtrag, PRÜFER-51 K1–K3 und K6, nachgeschärfte Haken, 25.10.2026

**Auftrag.** Nach [LEKTOR-57](LEKTOR-57.md#lektor-57) (`7aa65800`) kamen
12 Commits, `git log 7aa65800..ed9e698b`: [PRÜFER-51](PRUEFER-51.md#pruefer-51)
(`c0bbacb5`, 11 Funde), der Regressionstest zu [E-20](../Intern/BEFUNDE.md#e-20)
(`5c89d9b9`, PRÜFER-50 K1), der Prüfbericht nach PRÜFER-51 K1–K3
(`3b48d9b9`), der README-Nachtrag zu [E-148](../Intern/BEFUNDE.md#e-148)
(`a123af93`, PRÜFER-51 K6) und drei Commits auf [LEKTOR-57](LEKTOR-57.md#lektor-57) hin (`98298cb8`,
`f90e13e8`, `ed9e698b`). Schwerpunkt laut Auftrag: die dabei geänderten
Dateien `CLAUDE.md`, `Intern/AGENTEN.md`, `README.md`,
`Intern/ABRUF-PRUEFEN.md`, `Intern/BEFUNDE.md`, `tools/WERKZEUGE.md`,
`Releases/PRUEFBERICHT.md`. Jede Aussage dort ist gegen den Code und gegen
die anderen Dateien gehalten. Die übrigen Funde aus [LEKTOR-57](LEKTOR-57.md#lektor-57) stehen nur mit
ihrem Stand da. Maßstab von außen: `Eudora71/Version.h` (`7.2.0.122`),
`VERSION` (`1.0.122`), die Quelltexte der genannten Werkzeuge,
`QCSSLContext.cpp` und die Ausgaben der Werkzeuge selbst.

**Ergebnis vorweg.**

* **Die Schranke gegen zerbrochene Tabellenzeilen sieht `Intern/` nicht.**
  Seit dem Umzug der Arbeitsdateien nach `Intern/` am 22.10.2026 prüft
  `pruefe-tabellenzeilen.pl` im Commit-Haken weder `BEFUNDE.md` noch
  `WEITERMACHEN.md`. Gebaut wurde sie gerade für diese beiden Dateien. Heute
  ist so der Nachtrag zu [E-148](../Intern/BEFUNDE.md#e-148) (kompromittierte
  eMudhra-Zertifikate) mit einer zerbrochenen Tabellenzeile durchgegangen.
  Gezielt aufgerufen meldet dasselbe Werkzeug den Fehler ([L-58.1](#l-58.1)).
* **121 Tabellenzeilen stehen hinter einer Leerzeile und damit außerhalb
  ihrer Tabelle.** Betroffen sind 12 Befunde in `BEFUNDE.md`, darunter das
  offene [E-39](../Intern/BEFUNDE.md#e-39) (eine gelöschte Persönlichkeit
  kann wiederkehren). Dazu 25 Werkzeuge in `WERKZEUGE.md`, zwei der
  Leerzeilen dort sind von heute. Und 84 Zweige in `ZWEIGE.md`, wo Gregors
  Freigaben der Zweignamen stehen. Keine Schranke kennt diese Form
  ([L-58.2](#l-58.2)).
* **Die Berichtigung zu [E-148](../Intern/BEFUNDE.md#e-148) steht in der README, aber nicht im CHANGELOG.**
  `CHANGELOG.md:109-110` sagt weiter *„GMX und freenet sind mit der neuen
  Liste gemessen und werden weiter angenommen"*. Genau diesen Satz hat
  `ed9e698b` in der README als nicht mit Eudora gemessen berichtigt. Aus dem
  CHANGELOG entstehen die Release-Notizen, und 7.2.0.123 soll nach Gregors
  Entscheidung veröffentlicht werden. Dazu sagt `README.md:223` weiter
  *„im Programmverzeichnis"*. 24 Zeilen tiefer steht der neue Absatz, nach dem
  Eudora zuerst im Mailverzeichnis sucht ([L-58.3](#l-58.3)).

**Stand der 10 Funde aus [LEKTOR-57](LEKTOR-57.md#lektor-57):** 2 erledigt,
5 teilweise, 3 offen (Teil 1). Die offenen Funde aus
[LEKTOR-55](LEKTOR-55.md#lektor-55) und [LEKTOR-56](LEKTOR-56.md#lektor-56)
sind unverändert. Gemessen: `git diff --stat 7aa65800 HEAD` berührt `ZIEL.md`,
`Intern/AUFGABEN.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`,
`CHANGELOG.md`, `Intern/PORTIERUNG.md`, `Doku/ANWENDER.md` und
`Testdaten/README.md` nicht. **7 neue Funde**: 2 falsch, 1 veraltet,
2 unvollständig, 2 Form. **Eine neue Frage an Gregor**, dazu die
offene Frage nach dem Namen der Marke, am Ende. Die andere Frage aus [LEKTOR-57](LEKTOR-57.md#lektor-57) hat Gregor
beantwortet ([L-58.7](#l-58.7)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

---

## Mechanisch zuerst

Gemessen am 25.10.2026 gegen 11:10 in diesem Arbeitsbaum (`ed9e698b`).
Die Ausgaben sind nicht als Urteil übernommen.

| Werkzeug | Ausgabe | was sie nicht sagt |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden."*, 46 Dateien, 13 Hinweise *„nennt weder den Quellstand …"* (dieselben wie in [LEKTOR-57](LEKTOR-57.md#lektor-57)) | dass `CHANGELOG.md:109-110` und `README.md:236-239` über [E-148](../Intern/BEFUNDE.md#e-148) Verschiedenes sagen ([L-58.3](#l-58.3)) |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 38 … davon NIE gemessen 11 … 38 offene Befunde, in beiden Listen gleich."* | gibt weiter nur Zahlen aus. Die Kennungen liefert jetzt `sitzungsbeginn.pl` (gemessen: 38 Zeilen, [`E-146`](../Intern/BEFUNDE.md#e-146) bis [`R-1`](../Intern/BEFUNDE.md#r-1)) |
| `perl tools/pruefe-regressionstest.pl` | 202 Befunde, **61** mit Testfall ([LEKTOR-57](LEKTOR-57.md#lektor-57): 58), 72 behoben ohne Testfall; kritisch 68, davon **40** mit Testfall, **26 ohne jede Prüfung**, [E-108](../Intern/BEFUNDE.md#e-108) nicht mehr darunter | dass [E-108](../Intern/BEFUNDE.md#e-108) jetzt über einen Fall zählt, den sein Befund *„nicht nachgestellt"* nennt ([L-58.5](#l-58.5)) |
| `perl tools/ziel-stand.pl` | *„19 von 19 erfüllt, 0 offen - ZIEL.md ist auf dem Stand."* | wie [L-56.1](LEKTOR-56.md#l-56.1), unverändert |
| `perl tools/pruefe-befundurteile.pl` | *„Kein Dokument erklaert einen offenen Befund fuer erledigt"* | — |
| `perl tools/pruefe-tabellenzeilen.pl` | ohne Angabe: *„278 Dateien, keine gebrochene Tabellenzeile."*; mit `Intern/BEFUNDE.md`: *„GEBROCHENE TABELLENZEILE … Intern/BEFUNDE.md:381"* | dass der Bestandslauf `Intern/` nicht liest ([L-58.1](#l-58.1)) |
| `perl tools/rollen-faellig.pl --nur-melden` | vor meinem ersten Commit: LEKTOR, PRUEFER und CHRONIST fällig (*„LEKTOR ist faellig: seit seinem Bericht (7aa6580) haben sich 7 Datei(en) …"*) | — |

**Sichern war in diesem Lauf nicht möglich (gemessen).** Der Commit-Haken
spiegelt die Lehren aus dem Gedächtnis des Hauptagenten nach `Arbeitsweise/`
(`lehren-spiegeln.pl`). Danach weist `lehren-schranken.pl` ab: *„MANGEL: -
Arbeitsweise/entscheidung-e148-release-7-2-0-123.md -
Arbeitsweise/zwischendateien-ins-scratchpad.md"*. Beide Dateien haben keine
Zeile `Schranke:`. Beide sind heute neu und stammen vom Hauptagenten. Ohne
sie bricht der Spiegel den Commit ab, mit ihnen die Lehrenschranke. Ich
ändere sie nicht und umgehe den Haken nicht.

---

## <a id="teil-1"></a>Teil 1 — Die 10 Funde aus LEKTOR-57, Stand heute

| Fund | worum es ging | heute | Beleg |
|---|---|---|---|
| [L-57.1](LEKTOR-57.md#l-57.1) | Sitzungsbeginn-Haken nannte keinen offenen Befund, `CLAUDE.md` versprach eine Liste | **erledigt.** Der Haken gibt alle 38 Kennungen mit Klartext aus; `CLAUDE.md` sagt jetzt *„zählt"* und nennt beide Haken. Rest, Form: Abschnitt 3 sagt nicht, dass `paket-bereit.pl` von Hand bleibt, und der Kopf von `sitzungsbeginn.pl:3` sagt weiter *„Abschnitte 1 und 3"* | gemessen: `perl tools/sitzungsbeginn.pl` → 38 Zeilen; `CLAUDE.md:13-22`; `tools/sitzungsbeginn.pl:35-53` |
| [L-57.2](LEKTOR-57.md#l-57.2) | PR-Schranke offen mit dem Gerüst, außerhalb der Wurzel, bei `bash -c "…"` | **erledigt** für alle drei Wege. Das Gerüst hält über den Eintrag in `AGENTEN-LAUFEN.md`, die Wurzel kommt vom Skriptort, `-c`/`-Command`/`eval` zählen | `tools/haken-pr-lektor.pl:49-64`, `:90-92`; gemessen: Selbsttest 13/13; `gh pr create` → 2, `cd tools && gh pr create` → 2, `sh -c 'gh pr create'` → 2 |
| [L-57.3](LEKTOR-57.md#l-57.3) | Prüfstandsfälle mit Buchstaben zählten nicht, [E-108](../Intern/BEFUNDE.md#e-108) stand „ohne jede Prüfung" | **teilweise.** Gezählt wird jetzt (61, [E-108](../Intern/BEFUNDE.md#e-108) heraus). Die vorgeschlagene Gegenprobe im `--selbsttest` fehlt: der Selbsttest übergibt `$hat` fest und ruft `hat_test` nie auf. Zur Sache von E-108p → [L-58.5](#l-58.5) | `tools/pruefe-regressionstest.pl:144-151`, `:395-405`; gemessen: Selbsttest 8/8 |
| [L-57.4](LEKTOR-57.md#l-57.4) | Prüfbericht überholt, zwei Schrankenzeilen mit blinden Schranken gemessen | **teilweise.** Neu erzeugt um 10:58, 18 Schrankenproben nach den neuen Schranken, kritisch 40/26 wie das Werkzeug; der Bau steht jetzt in `:10`. Offen ist die Frische-Prüfung in K12: `pruefe-regressionstest.pl` ist nur in `hat_test` geändert. Der Kopf `:5` nennt weiter nur *„Quellstand 7.2.0.122 (Paketnummer 1.0.122)"*. Neu: `:6` *„Arbeitsbaum nicht sauber (1 Dateien)"*. Erzeugt wurde der Bericht, bevor `pruefe-regressionstest.pl` committet war. Der Paketbau erzeugt ihn neu (`paket-bauen.ps1:428-448`) | `Releases/PRUEFBERICHT.md:5-10`, `:364-371`, `:420`; `git diff 7aa65800 HEAD -- tools/pruefe-regressionstest.pl` → nur `:147-150` |
| [L-57.5](LEKTOR-57.md#l-57.5) | WERKZEUGE.md beschrieb vier geschärfte Schranken im alten Stand; AGENTEN.md kannte die neuen Werkzeuge nicht | **teilweise.** `AGENTEN.md:169-177` nennt `auftrag-rolle.pl` und den PR-Haken. Die fünf Zeilen in `WERKZEUGE.md` sind unverändert, `:131` sagt weiter *„13 Fälle"* (Bericht: 18 Proben) | `git diff 7aa65800 HEAD -- tools/WERKZEUGE.md` berührt nur `:139`, `:148-151` |
| [L-57.6](LEKTOR-57.md#l-57.6) | acht PRÜFER-50-Funde in keiner Liste | **teilweise.** K1 ist behoben: der Test zu [E-20](../Intern/BEFUNDE.md#e-20) ruft jetzt `InsertArr` auf (`5c89d9b9`). K5, K6, K7, K9, K10, K11, K13 stehen weiter nirgends; dazu kommen sieben aus PRÜFER-51 → [L-58.4](#l-58.4) | gemessen: `git grep "PRUEFER-50.*K[0-9]"` außerhalb `Befunde/` → nur K1, K2, K3, K4, K8, K12 |
| [L-57.7](LEKTOR-57.md#l-57.7) | „Als Nächstes" in WEITERMACHEN.md abgearbeitet; [E-148](../Intern/BEFUNDE.md#e-148) „auf dem Zweig" | **offen** | `Intern/WEITERMACHEN.md:140` unverändert; `Intern/BEFUNDE.md:380` weiter *„behoben auf dem Zweig `e-148-emudhra-wurzeln`"* |
| [L-57.8](LEKTOR-57.md#l-57.8) | kein Testplan für das Paket 7.2.0.123, [E-148](../Intern/BEFUNDE.md#e-148) nur dort mit Eudora messbar | **offen**, jetzt dringlicher: 7.2.0.123 soll nach Gregors Test veröffentlicht werden ([L-58.7](#l-58.7)) | gemessen: `grep -c E-148 Intern/TESTPLAN.md` → 0; `:251` weiter *„277 Tests"* (Bericht: 296) |
| [L-57.9](LEKTOR-57.md#l-57.9) | README: „werden weiter angenommen" und Rat für ältere Pakete, beides nicht mit Eudora gemessen | **teilweise.** `README.md:236-239` sagt jetzt *„mit **OpenSSL** gemessen … **Mit Eudora selbst** ist das erst im Paket 7.2.0.123 zu messen"*; `ABRUF-PRUEFEN.md:106-109` nennt 117. Offen ist der Rat in `:242-245`. Er steht unverändert und widerspricht jetzt dem Satz darüber (siehe [L-58.3](#l-58.3)) | `README.md:236-245`; `Intern/ABRUF-PRUEFEN.md:106-109` |
| [L-57.10](LEKTOR-57.md#l-57.10) | Verlinkung macht aus „[E-146](../Intern/BEFUNDE.md#e-146) bleibt frei" einen Verweis auf den heutigen [E-146](../Intern/BEFUNDE.md#e-146) | **offen** | `tools/befunde-verlinken.pl` seit `7aa65800` unverändert (gemessen: `git diff --stat` leer) |

---

## Teil 2 — Neue Funde

### <a id="l-58.1"></a>L-58.1 — die Schranke gegen zerbrochene Tabellenzeilen liest `Intern/` nicht; der E-148-Nachtrag hat die Befundtabelle zerbrochen

**Gewicht: falsch (Schranke blind, seit 22.10.2026).** `tools/pruefe-tabellenzeilen.pl:54-60`; `tools/hooks-einrichten.sh:142`; `Intern/BEFUNDE.md:380-381`

Worum es geht: `pruefe-tabellenzeilen.pl` weist einen Commit ab, wenn eine
Tabellenzeile über zwei Zeilen läuft. Gebaut wurde die Schranke am 22.10.2026
für `WEITERMACHEN.md` und `BEFUNDE.md`. Auf GitHub war dort Text in die
falsche Spalte gerutscht (Kopf `:17-21`).

**Belegt:** Ohne Dateiangabe nimmt das Werkzeug seinen Umfang aus einer
festen Liste:

> `tools/pruefe-tabellenzeilen.pl:55-59`: `glob('*.md')`, `glob('Befunde/*.md')`, `glob('tools/*.md')`, `glob('Arbeitsweise/*.md')`, `glob('Releases/*.md')`

`Intern/` steht nicht darin, ebenso wenig `Doku/` und `Testdaten/`. Der Haken
ruft es ohne Angabe auf (`hooks-einrichten.sh:142`, `schranke
pruefe-tabellenzeilen.pl`; `schranke()` in `:40-48` hängt keine Datei an).
`BEFUNDE.md` kam mit `c28cde84` am 22.10.2026 nach `Intern/`. Zuletzt
geändert wurde das Werkzeug davor, in `9c898756` am selben Tag (gemessen,
`git log --follow`).

**Gemessen:**

```
perl tools/pruefe-tabellenzeilen.pl                    -> 278 Dateien, keine gebrochene Tabellenzeile.
perl tools/pruefe-tabellenzeilen.pl Intern/BEFUNDE.md  -> GEBROCHENE TABELLENZEILE  Intern/BEFUNDE.md:381
                                                          steht allein da:  |
                                                          Zeile ohne eine einzige gefuellte Zelle - beendet die Tabelle
```

`cat -A` zeigt Zeile 381 als ` |$`. Der Nachtrag zu
[E-148](../Intern/BEFUNDE.md#e-148) aus `a123af93` (*„Nachtrag 25.10.2026
([PRUEFER-51](PRUEFER-51.md#pruefer-51) K6 …)"*) endet in `:380` ohne Abschluss. Das schließende `|`
steht allein in der nächsten Zeile. Nach dem Urteil des Werkzeugs endet die
Tabelle dort, und darunter folgen [E-146](../Intern/BEFUNDE.md#e-146) und
die übrigen Zeilen des Abschnitts. Wie GitHub das genau darstellt, habe ich
nicht angesehen. Alle anderen Dateien in `Intern/`, `Doku/` und `Testdaten/`
habe ich einzeln geprüft, ohne Meldung (gemessen).

Dieselbe Klasse wie [Schranke teilt nicht die Annahme](../Arbeitsweise/schranke-teilt-nicht-die-annahme.md)
und [Prüfstand kann blind sein](../Arbeitsweise/pruefstand-kann-blind-sein.md):
Die Liste der Verzeichnisse stammt aus der Zeit vor dem Umzug.

**Vorschlag:** Den Umfang aus `git ls-files '*.md'` nehmen statt aus festen
Mustern ([Liste aus einer Quelle](../Arbeitsweise/liste-aus-einer-quelle.md)).
Gegenprobe: Mit dem heutigen Stand muss der Bestandslauf `BEFUNDE.md:381`
melden. `:380`/`:381` zu einer Zeile zusammenziehen. Andere Werkzeuge mit
fester Verzeichnisliste daraufhin durchsehen (nicht geprüft).

### <a id="l-58.2"></a>L-58.2 — 121 Tabellenzeilen stehen hinter einer Leerzeile außerhalb ihrer Tabelle, zwei der Leerzeilen sind von heute

**Gewicht: Form (gewichtig: betrifft Befundtabelle, Werkzeugbestand und Gregors Zweigfreigaben).** `Intern/BEFUNDE.md:395`; `tools/WERKZEUGE.md:140`, `:150`; `tools/ZWEIGE.md:98-178`; `Eudora71/OTShim/PLAN.md:407`

Worum es geht: Eine Markdown-Tabelle endet an der ersten Leerzeile. Zeilen,
die danach mit `|` beginnen, bilden ohne eigene Kopf- und Trennzeile keine
Tabelle. Sie erscheinen als Fließtext mit Strichen (belegt an der GFM-Regel,
auf GitHub nicht angesehen).

**Gemessen** mit einem Skript im Notizverzeichnis. Es sucht Zeilen, die mit
`|` beginnen, hinter einer Leerzeile stehen und keine Trennzeile `|---` nach
sich haben. Codeblöcke sind ausgenommen. Geprüft wurden alle Dateien aus
`git ls-files '*.md'` ohne `Befunde/` und `Arbeitsweise/`:

| Datei:Zeile | Zeilen ohne Kopf | was dort steht | Leerzeile seit |
|---|---|---|---|
| `Intern/BEFUNDE.md:396` | 12 | [X-7](../Intern/BEFUNDE.md#x-7), [X-8](../Intern/BEFUNDE.md#x-8), ein Nebenbefund, [E-44](../Intern/BEFUNDE.md#e-44) bis [E-46](../Intern/BEFUNDE.md#e-46), [E-34](../Intern/BEFUNDE.md#e-34) bis [E-39](../Intern/BEFUNDE.md#e-39) | `94d9fb5d` (22.10.2026) |
| `tools/WERKZEUGE.md:141` | 9 | `messen-e123-abbruch.ps1` bis `haken-pr-lektor.pl` | **`3b48d9b9` (heute, PRÜFER-51 K1–K3)** |
| `tools/WERKZEUGE.md:151` | 16 | `sitzungsbeginn.pl` bis zum Ende der Tabelle | **`98298cb8` (heute, nach [LEKTOR-57](LEKTOR-57.md#lektor-57))** |
| `tools/ZWEIGE.md:99` bis `:179` | 84 in 13 Gruppen | Zweignamen mit Gregors Freigabe | älter, nicht ausgezählt |
| `Eudora71/OTShim/PLAN.md:408` | 1 | eine Bibliothekszeile | älter |

[E-39](../Intern/BEFUNDE.md#e-39) ist offen: Wird die gerade benutzte
Persönlichkeit gelöscht, kann ihr INI-Abschnitt teilweise wiederkehren. Er
steht unter *„kritisch, OHNE jede Prüfung"*. Wer `BEFUNDE.md` auf GitHub
liest, findet ihn nicht in der Tabelle. Die Werkzeuge lesen Rohzeilen und
sehen ihn (gemessen: `sitzungsbeginn.pl` nennt [E-39](../Intern/BEFUNDE.md#e-39)). Seit dem 24.10.2026
gilt: *„Gregor versteht BEFUNDE.md nicht mehr"*
([Befund in Klartext](../Arbeitsweise/befund-in-klartext.md)).

`pruefe-tabellenzeilen.pl` kennt diese Form nicht. Gemessen:
`perl tools/pruefe-tabellenzeilen.pl tools/WERKZEUGE.md` → *„keine gebrochene
Tabellenzeile"*. Sein eigener Hinweis empfiehlt sogar, *„eine Leerzeile vor
die Tabelle setzen"*.

**Vorschlag:** Die Leerzeilen entfernen (fünf Dateien, Inhalt unverändert).
Die Schranke um den Fall *„Tabellenzeile hinter Leerzeile ohne Trennzeile"*
erweitern, Gegenprobe mit `WERKZEUGE.md` vor der Berichtigung.

### <a id="l-58.3"></a>L-58.3 — E-148 sagt in README und CHANGELOG Verschiedenes; README nennt das Programmverzeichnis als Ort und rät, was sie selbst ungemessen nennt

**Gewicht: falsch (Außenwirkung, Sicherheit).** `CHANGELOG.md:103-110`; `README.md:147`, `:222-224`, `:236-245`, `:247-255`

Worum es geht: [E-148](../Intern/BEFUNDE.md#e-148). Eudora vertraute vier
Wurzelzertifikaten von eMudhra, unter denen kompromittierte
Zwischenzertifikate bekannt wurden. Ein Angreifer im selben Netz könnte einen
falschen Mailserver vorspielen. Behoben ist das in der mitgelieferten Liste
ab 7.2.0.123.

**1. CHANGELOG nicht nachgezogen.** Belegt:

> `CHANGELOG.md:109-110`: *„GMX und freenet sind mit der neuen Liste gemessen und werden weiter angenommen."*
> `README.md:236-239` (seit `ed9e698b`): *„gegen die neue Liste mit **OpenSSL** gemessen … **Mit Eudora selbst** ist das erst im Paket 7.2.0.123 zu messen; bis dahin ist es eine Rechnung, keine Beobachtung am Programm."*

`ed9e698b` hat nur `README.md` und `ABRUF-PRUEFEN.md` berührt (gemessen,
`git show --stat`). Der CHANGELOG-Abschnitt wird *„beim nächsten Paket … zu
7.2.0.123"* (`:100-101`). Er ist damit die Notiz, die nach außen geht.
Auch der Hinweis auf eine eigene `rootcerts.p7b` im Mailverzeichnis
(PRÜFER-51 K6) fehlt dort (gemessen: `grep -c -i mailverzeichnis` im
Abschnitt `:103-110` → 0).

**2. README widerspricht sich beim Ort.** Belegt:

> `README.md:222-223`: *„Eudora prüft Serverzertifikate nicht gegen Windows, sondern gegen die Datei `rootcerts.p7b` im Programmverzeichnis"*
> `README.md:247-249`: *„Eudora sucht `rootcerts.p7b` zuerst im **Mailverzeichnis** … und nur, wenn sie dort fehlt, im Programmverzeichnis"*

Am Quelltext stimmt `:247`: `QCSSLContext.cpp:410-442`
(`ChooseCertFileDirectory`) prüft erst `strDir1` (das Mailverzeichnis), dann
`strDir2` (das Programmverzeichnis). [PRÜFER-51 K6](PRUEFER-51.md#k6) hatte
`:223` und `:147` ausdrücklich genannt. Nachgezogen wurde `:147`, `:223`
nicht.

**3. Der Rat für ältere Pakete steht unter dem Satz, der ihn ungemessen
nennt.** `:238-239` sagt, mit Eudora selbst sei die neue Liste erst im Paket
7.2.0.123 zu messen. `:242-245` rät Besitzern älterer Pakete, genau diese
Liste in ihr Programmverzeichnis zu legen. Das ist dieselbe Messung, nur beim
Anwender statt bei uns ([Erst prüfen, dann anweisen](../Arbeitsweise/erst-pruefen-dann-anweisen.md);
Rest von [L-57.9](LEKTOR-57.md#l-57.9)). Messen ließe sie sich heute an jedem
älteren Paket unter `C:\Temp`, ohne neues Paket. **Vermutung:** Ein älteres
Paket lädt die Datei auf demselben Weg. Nachgesehen habe ich das nicht.

**Vorschlag:** `CHANGELOG.md:109-110` so fassen wie `README.md:236-239` und den
Mailverzeichnis-Satz anfügen. `README.md:223`: *„… gegen die Datei
`rootcerts.p7b` (zuerst im Mailverzeichnis, sonst im Programmverzeichnis)"*.
Den Rat in `:242-245` erst geben, wenn ein älteres Paket mit der neuen
Datei am Prüfstand gegen GMX verbunden hat.

### <a id="l-58.4"></a>L-58.4 — sieben der elf PRÜFER-51-Funde stehen in keiner Liste; K8 ist Programmverhalten zu E-119

**Gewicht: unvollständig.** `Befunde/PRUEFER-51.md:478-492`; `Intern/BEFUNDE.md:365`, `:380`

[PRÜFER-51](PRUEFER-51.md#pruefer-51) hat 11 Funde. Eingearbeitet sind K1,
K2 und K3 (Prüfbericht, `3b48d9b9`) und K6 (README, `a123af93`).
**Gemessen:** `git grep -n PRUEFER-51` außerhalb `Befunde/` findet nur
`README.md:255`, `BEFUNDE.md:380` (K6), `WERKZEUGE.md:139` (K1–K3) und
Kommentare in `pruefbericht.pl`. Nirgends stehen:

| Fund | was passiert | Schwere laut PRÜFER-51 |
|---|---|---|
| [K8](PRUEFER-51.md#k8) | **Programm:** Scheitert das Kopieren des Bildes (volle Platte, gesperrte Datei), teilen sich zwei Entwürfe wieder eine Bilddatei. Löscht man einen, kann das Bild des anderen verloren gehen, der Fehler aus [E-119](../Intern/BEFUNDE.md#e-119) K5. Ein Fehler beim letzten Schreiben gilt als gelungen, die Nachricht verweist dann auf ein abgeschnittenes Bild | gering |
| [K4](PRUEFER-51.md#k4) | die Schranke zu [E-62](../Intern/BEFUNDE.md#e-62) bleibt grün, wenn eine von zwei Warteschleifen einer Funktion `WM_QUIT` verschluckt | wichtig (Prüfstand) |
| [K5](PRUEFER-51.md#k5) | die Schranke zu [E-35](../Intern/BEFUNDE.md#e-35) übersieht `(*p).` und eine Prüfung, die nicht schützt | mittel |
| [K7](PRUEFER-51.md#k7) | `TestE148` prüft den Text von `paket-bauen.ps1`, nicht das Paket | gering |
| [K9](PRUEFER-51.md#k9) | `E-119d` prüft nicht, ob überhaupt gelöscht wurde | gering |
| [K11](PRUEFER-51.md#k11) | alle Prüfstandsfälle eines Laufs tragen dieselbe Uhrzeit | gering |
| [K10](PRUEFER-51.md#k10) | Entwürfe aus 1.0.110 bis 1.0.122 tragen die geteilte Datei weiter (Vermutung) | Hinweis |

`BEFUNDE.md:365` ([E-119](../Intern/BEFUNDE.md#e-119)) erwähnt K8 nicht
(gemessen: `grep -c PRUEFER-51 Intern/BEFUNDE.md` → 1, das ist `:380`).
PRÜFER-51 schreibt selbst *„Eingetragen in `Intern/BEFUNDE.md` ist nichts"*
(`:491-492`).

Folge für die Zählung, belegt: [E-62](../Intern/BEFUNDE.md#e-62) und
[E-35](../Intern/BEFUNDE.md#e-35) stehen im Prüfbericht mit allen Proben
*ok* (`PRUEFBERICHT.md:364-371`) und zählen als gedeckt. K4 und K5 haben
aber je einen Rückfall gemessen, den die Schranke durchlässt. Das ist
dieselbe Klasse wie [L-56.6](LEKTOR-56.md#l-56.6) und
[L-57.6](LEKTOR-57.md#l-57.6): Was nur im Bericht steht, zählt kein
Werkzeug.

**Vorschlag:** K8 als Satz in [E-119](../Intern/BEFUNDE.md#e-119) mit
*„Was noch fehlt"*. K4, K5, K7, K9 in die Liste der Tests, die ihren Fehler
nicht sehen, die [L-57.6](LEKTOR-57.md#l-57.6) vorschlägt.

### <a id="l-58.5"></a>L-58.5 — E-108 zählt jetzt als geprüft über einen Fall, den sein Befund „nicht nachgestellt" nennt

**Gewicht: veraltet (Zählung kritischer Befunde).** `Intern/BEFUNDE.md:354`; `tools/pruefstand-faelle.txt:177`, `:180`; `tools/messen-bild.ps1:211-224`

Worum es geht: [E-108](../Intern/BEFUNDE.md#e-108), Absturz beim Antworten,
kritisch. Seit `f90e13e8` zählt der Prüfstandsfall `E-108p` für ihn, und
[E-108](../Intern/BEFUNDE.md#e-108) steht nicht mehr unter *„OHNE jede Prüfung"*. Belegt:

> `Intern/BEFUNDE.md:354`: *„**Nicht nachgestellt:** der Prüfstand lädt zwar Bilder, aber der Block läuft dort nicht an; **nur Gregors Lauf entscheidet.**"*
> `tools/pruefstand-faelle.txt:180`: `E-108p | C:\Temp\EBILD | 240 | log | Logging shutdown | Exception | | messen=tools\messen-bild.ps1`
> `tools/messen-bild.ps1:224`: `Befehl $haupt 32799   # ID_MESSAGE_FORWARD`

`E-108p` verlangt nur, dass der Lauf ordentlich endet. Der Lauf leitet
weiter, er antwortet nicht. Dass der fragliche Block heute am Prüfstand
läuft, ist belegt, aber über einen anderen Fall: `E-106p` (`:177`) verlangt
die Spurmarke *„[E-106](../Intern/BEFUNDE.md#e-106) groesser als"*, und er ist grün (`PRUEFBERICHT.md`,
Abschnitt 3). Der Satz in `:354` ist damit veraltet. Die Commit-Nachricht
`f90e13e8` sagt *„E-108p nachgesehen … zuletzt gruen"*. Ob der Fall den
Absturz je rot gesehen hat, sagt sie nicht. Ursache von [E-108](../Intern/BEFUNDE.md#e-108) sind zwei
Bilder gleicher Maßangabe, die sich `embed->style` teilen. Ob die Testmail des
Prüfstands so ein Paar enthält, ist **nicht geprüft**. Das ist Sache des
PRÜFERS.

**Vorschlag:** In `:354` den Satz *„Nicht nachgestellt"* durch den heutigen
Stand ersetzen. Der Block läuft am Prüfstand (`E-106p`), der Weg dort ist
Weiterleiten, nicht Antworten, und `E-108p` prüft nur ein ordentliches Ende.
Ob das als Regressionstest für einen Absturz beim Antworten gilt, entscheidet
der Hauptagent. Gilt es nicht, gehört [E-108](../Intern/BEFUNDE.md#e-108) zurück in die Liste. In
`pruefe-regressionstest.pl --selbsttest` einen Fall aufnehmen, der `hat_test` mit
`E-998p` (zählt) und `E-9981` (zählt nicht) aufruft.

### <a id="l-58.6"></a>L-58.6 — WERKZEUGE.md: drei angehängte Sätze ohne Satzgrenze, eine Zeile mit zwei Fallzahlen; AGENTEN.md vergibt E-Kennungen auch für den LEKTOR

**Gewicht: Form.** `tools/WERKZEUGE.md:139`, `:149`, `:151`; `Intern/AGENTEN.md:171`; `tools/auftrag-rolle.pl:20`

Belegt:

> `WERKZEUGE.md:139`: *„… der Bericht liegt im Paket **Seit 25.10.2026 ([[PRUEFER-51](PRUEFER-51.md#pruefer-51)] K1–K3)** heißt es …"*
> `WERKZEUGE.md:149`: *„… `--selbsttest`, **10 Fälle** in beide Richtungen. … beides live gemessen am 25.10.2026 **Nachgeschärft nach [[LEKTOR-57](LEKTOR-57.md#lektor-57)] …** Selbsttest **13 Fälle**"*
> `WERKZEUGE.md:151`: *„… hing an meinem Gedächtnis Nennt seit [[L-57.1](LEKTOR-57.md#l-57.1)] …"*

Die Nachträge hängen ohne Punkt am alten Text. In `:149`
stehen alte und neue Fallzahl nebeneinander. Gemessen ist 13
(`haken-pr-lektor.pl --selbsttest` → *„13 Faelle, 0 rot"*).

> `Intern/AGENTEN.md:169-172`: *„Für LEKTOR und PRUEFER erledigt das **ein** Aufruf … Berichtsnummer und freie E-Kennungen vergeben"*
> `tools/auftrag-rolle.pl:20`: *„Berichtsnummer und - fuer PRUEFER - zwei freie E-Kennungen vergeben"*

Der LEKTOR vergibt keine E-Kennungen. `WERKZEUGE.md:148` sagt es richtig.

**Vorschlag:** Satzgrenzen setzen, in `:149` *„10 Fälle"* streichen. In
`AGENTEN.md:172` *„für PRUEFER zwei freie E-Kennungen"*.

### <a id="l-58.7"></a>L-58.7 — Gregors Entscheidung „E-148 mit 7.2.0.123 veröffentlichen" steht in keiner Repo-Datei

**Gewicht: unvollständig.** `Arbeitsweise/entscheidung-e148-release-7-2-0-123.md` (nur im Arbeitsbaum, vom Commit-Haken gespiegelt); `Intern/WEITERMACHEN.md:140-146`; `README.md:147`

**Belegt:** Der Commit-Haken hat in meinen Arbeitsbaum eine neue Lehre
gespiegelt:

> *„Gregor am 25.10.2026 auf die Frage aus [LEKTOR-57](LEKTOR-57.md#lektor-57) …: **„[E-148](../Intern/BEFUNDE.md#e-148): (b), nach meinem test veröffentlichen"** … Die Entscheidung gehört nach dem Merge auch ins Repo (`Intern/WEITERMACHEN.md`)."*

**Gemessen:** `git grep -n "nach meinem test"` → nichts, im Repo
steht sie also nirgends. `WEITERMACHEN.md` ist seit `7aa65800` unverändert.
`:146` führt weiter nur die offene Markenfrage, `:140` das abgearbeitete
*„Als Nächstes"* ([L-57.7](LEKTOR-57.md#l-57.7)). `README.md:147` sagt *„Behoben ab 7.2.0.123"*, aber
nicht, dass dieses Paket veröffentlicht wird. Damit hängen jetzt drei offene
Punkte am Paket 7.2.0.123, das nach außen geht: der Testplan mit [E-148](../Intern/BEFUNDE.md#e-148)
([L-57.8](LEKTOR-57.md#l-57.8)), der CHANGELOG-Satz ([L-58.3](#l-58.3)) und
die Markenfrage. Die Lehrdatei selbst konnte nicht eingecheckt werden
(siehe *Mechanisch zuerst*).

**Vorschlag:** Die Entscheidung mit Datum und Wortlaut in
`WEITERMACHEN.md` unter *„Entschieden am 25.10.2026"* und als neues
*„Als Nächstes"*: Merge, Paket 7.2.0.123, Testplan, Gregors Test,
Veröffentlichung nach seinem Ja.

---

## <a id="fragen"></a>Was nur Gregor entscheiden kann

1. **Soll Eudora melden, wenn es die Zertifikatsliste aus dem
   Mailverzeichnis statt der mitgelieferten nimmt?** Hat ein Anwender je eine
   eigene `rootcerts.p7b` ins Mailverzeichnis gelegt, behält Eudora auch mit
   dem neuen Paket diese Liste, samt den kompromittierten eMudhra-Wurzeln
   ([E-148](../Intern/BEFUNDE.md#e-148), PRÜFER-51 K6). Heute steht das nur
   in der README. Möglich ist: (a) nichts ändern, README genügt; (b) eine
   Zeile im Protokoll, aus welchem Verzeichnis die Liste kam; (c) ein
   einmaliger Hinweis beim Start, wenn sie aus dem Mailverzeichnis kommt. (b)
   und (c) ergänzen einen QUALCOMM-Weg, der so gewollt ist
   (`QCSSLContext.cpp:407-408`).
2. **Heißt die Marke auf GitHub für das Release `v7.2.1.<n>` bzw.
   `v7.2.0.123` oder weiter `v1.0.<n>`?** Unverändert offen
   (`Intern/WEITERMACHEN.md:146`). Mit der Entscheidung, 7.2.0.123 zu
   veröffentlichen, ist sie jetzt beim nächsten Release fällig.

Nicht hierher gehören, weil Gregor sie übertragen hat: ob `E-108p` als Test
für [E-108](../Intern/BEFUNDE.md#e-108) gilt ([L-58.5](#l-58.5)), ob K8 aus
PRÜFER-51 eine eigene Kennung bekommt, die Form der Tabellen und wie die
Schranke in [L-58.1](#l-58.1) und [L-58.2](#l-58.2) erweitert wird.

---

## Geprüft und in Ordnung

* **`QCSSLContext.cpp:398-442`** gegen `README.md:247-255`, `BEFUNDE.md:380`
  (Nachtrag) und `ABRUF-PRUEFEN.md:108-109`: Das Mailverzeichnis kommt vor
  dem Programmverzeichnis. Liegt die Datei in keinem von beiden, gilt das
  Mailverzeichnis. Der Kommentar `:407-408` bestätigt die Absicht.
* **`tools/paket-bauen.ps1:483-491`**: legt `Releases\1.0\rootcerts.p7b`
  immer ins Programmverzeichnis des Pakets, nicht ins Mailverzeichnis.
  Passt zu *„Das Paket legt dort keine solche Datei ab"* (`README.md:251-252`).
  Ob die Grundlage `Eudora72-1.0.2-lauffaehig.zip` eine im Mailverzeichnis
  trägt, habe ich nicht nachgesehen. `BEFUNDE.md:380` sagt *„gemessen"*.
* **`Releases/PRUEFBERICHT.md`**: 296 Unit-Tests, 18 Schrankenproben
  ([E-35](../Intern/BEFUNDE.md#e-35) vier, [E-62](../Intern/BEFUNDE.md#e-62) zwei), 29 Prüfstandsfälle, alle am Bau `9402f257`. Seit
  `9402f257` hat sich unter `Eudora71/` außer in `Tests/` nichts geändert
  (gemessen, `git diff --stat 9402f257 HEAD -- Eudora71 ':!Eudora71/Tests'`
  leer). Die Prüfstandsergebnisse gelten also für den heutigen Programmstand.
* **`CLAUDE.md:13-22`**: Jede Aussage über die beiden Haken stimmt mit
  `.claude/settings.json` und den Werkzeugen überein (gemessen, siehe Teil 1).
* **`tools/AGENTEN-LAUFEN.md`**: In diesem Zweig ist kein Lauf eingetragen.
  Laut `sitzungsbeginn.pl` ist die Datei im Hauptbaum ungesichert geändert,
  vermutlich mit diesem Lauf (**Vermutung**, den Hauptbaum fasse ich nicht an).
  Der PR-Haken liest sie dort (`$CLAUDE_PROJECT_DIR`). Für den Hauptbaum ist
  das richtig.

## Nicht geprüft

* Wie GitHub `BEFUNDE.md:380-382` und die Zeilen hinter Leerzeilen
  tatsächlich darstellt ([L-58.1](#l-58.1), [L-58.2](#l-58.2)). Belegt sind
  die Zeilenstruktur und die GFM-Regel.
* Ob `E-108p` den Absturz aus [E-108](../Intern/BEFUNDE.md#e-108) je rot
  gesehen hat. Ebenso der Code von `3b48d9b9` (Prüfbericht) und `5c89d9b9`
  (E-20-Test). Das ist Sache des PRÜFERS, der laut `rollen-faellig.pl` fällig
  ist.
* Ob ein älteres Paket die neue `rootcerts.p7b` lädt ([L-58.3](#l-58.3)).
* `Arbeitsweise/` und `Befunde/` über die genannten Stellen hinaus (Auftrag).
