# <a id="lektor-142"></a>LEKTOR-142 (03.11.2026) — Nachträge nach der Veröffentlichung von v7.2.2.132, Zweig `release_7_2_2_132` nach 606789ba

**Umfang:** `git log --stat 7de75dcf..HEAD` (zwei Commits: `7a8118e5` — `tools/release-veroeffentlichen.ps1` lässt 7.2.2.N zu, `tools/ZWEIGE.md`, Spiegelungen; `606789ba` — Stand-Zeilen in README, CHANGELOG, TESTPLAN, ZIEL, PAKETE, WEITERMACHEN, AUFGABEN, FUNKTIONEN, `tools/RELEASES.md`, `tools/pruefe-release-buchfuehrung.pl`, CHRONIST-Spiegelung). Gelesen gegen: das veröffentlichte Release (`gh release view v7.2.2.132`, `gh api …/releases/latest`, `git ls-remote --tags origin`), `origin/main`, die Zweige `messungen_e188_e193`/`e188_loeschschranke` (`f6693b4b`), dazu jede Datei aus `git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/` (67 Dateien), gezielt über die Fassungsnummern und die Wendungen *Testpaket 7.2.2.132*, *nicht veröffentlicht*, *noch in keinem Paket*, *7.2.1.N*. Jeder Fund aus [LEKTOR-141](LEKTOR-141.md#lektor-141) und die offenen aus [LEKTOR-138](LEKTOR-138.md#lektor-138) bis 140 am heutigen Stand.

**Urteil:** Die Stand-Köpfe der acht führenden Dateien stimmen mit dem Release überein und untereinander: alle nennen v7.2.2.132, veröffentlicht am 03.11.2026, Marke `7a8118e5`, alle zwölf Schritte bestanden. Das Release selbst ist so draußen, wie die Papiere sagen. Liegen geblieben ist alles, was **unterhalb** der Stand-Köpfe auf das Paket wartete: 15 offene Befunde nennen als einzige fehlende Bedingung *„das Paket 7.2.2.132“*, und die ist erfüllt ([L-142.1](#l-142.1)). Dazu kommt: die Reihe 7.2.2.N ist in zwei Werkzeugen nachgezogen, in sechs weiteren nicht ([L-142.3](#l-142.3)). Und `main` sagt öffentlich noch *„Testpaket … nicht veröffentlicht“* ([L-142.6](#l-142.6)). Acht Funde, keiner hält etwas auf.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*, *„Quellstand 7.2.2.132“*, *„Paketnummer 7.2.2.132“*, *„gepruefte Dateien 53“*, 19 Hinweise *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“* — derselbe Altbestand wie in [LEKTOR-140](LEKTOR-140.md#lektor-140)/141. Dass es grün ist, sagt für die Reihe 7.2.2 wenig: drei seiner Muster kennen nur 7.2.0/7.2.1 ([L-142.3](#l-142.3)).
* `perl tools/offene-befunde.pl` (gemessen): *„61 offene Befunde, in beiden Listen gleich.“*; *„davon aktuell gemessen 26“*, *„veraltet gemessen 24“*, *„NIE gemessen 11“*.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„mit Testfall im Pruefstand 66 von 72“*, *„OHNE jede Pruefung 4 <- Rueckstand [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129)“*, *„Kein neues "behoben" ohne Regressionstest.“*
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*
* `perl tools/pruefe-release-buchfuehrung.pl --tests` (gemessen): *„Selbsttest: 23 von 23 bestanden“*; ohne Schalter: *„Jedes fuehrende Dokument kennt v7.2.2.132“*, *„5 Datei(en), 6 Standaussage(n)“*.
* **Das Release gegen die Papiere** (gemessen): `gh release view v7.2.2.132` → veröffentlicht `2026-11-03T17:38:35Z`, kein Entwurf, keine Vorabfassung, ein Anhang `Eudora72-7.2.2.132-release.zip` mit 9174979 Byte; `releases/latest` → `v7.2.2.132`; `git ls-remote --tags origin 'v7.2.2*'` → `7a8118e5…`. Der Release-Text ist bis auf den Zeilenumbruch am Ende gleich `Releases/7.2.2.132/RELEASE-NOTIZEN.md` (`diff` nach `tr -d '\r'`: nur `124d123 <`). Das stimmt mit `Releases/PAKETE.md:184` (*„17:38:35 UTC, Marke auf `7a8118e5`“*), `:189` (*„9.174.979 Byte“*) und `tools/RELEASES.md` (letzte Zeile *„2026-11-03 18:38:35 | v7.2.2.132“* — Ortszeit, eine Stunde nach UTC wie bei v7.2.1.131) überein.

## Funde aus LEKTOR-138 bis LEKTOR-141 — heutiger Stand

| Fund | Stand | Stelle |
|---|---|---|
| [L-141.1](LEKTOR-141.md#l-141.1) Vorgeschlagener Dateiname bei *Speichern unter* (`E-220`): 64 statt 63 Zeichen, „Windows lehnt ihn ab“ | **erledigt** | `README.md:164` *„nach 63 Zeichen abgeschnitten“*, ohne den Windows-Satz; `Releases/7.2.2.132/RELEASE-NOTIZEN.md:75-77` *„auf 63 Zeichen gekürzt“*; `Intern/TESTPLAN.md:49` *„bei 63 Zeichen abgeschnitten. Der ganze Pfad … kam nach Gregors eigener Einschätzung aus dem Explorer hineinkopiert“* |
| [L-141.2](LEKTOR-141.md#l-141.2) Gekürzter Umlaut-Betreff in der Liste (`E-221`): „sendet solche Betreffs so“ klang nach immer | **erledigt**; die Frage, ob es auch ohne Umlaute geschieht, bleibt für den Merge des E-221-Zweigs | `README.md:165`, `RELEASE-NOTIZEN.md:78-82` *„bei etwa jedem fünften Umlaut-Betreff von 40 bis 60 Zeichen“* |
| [L-141.3](LEKTOR-141.md#l-141.3) Backtick-Kennungen `E-220`/`E-221`, doppelte E-220-Zeile beim Merge | **offen, Merkposten** — beide Zweige sind nicht gemergt (`grep -c 'id="e-22[01]"' Intern/BEFUNDE.md` → 0, gemessen) | `README.md:164-165` |
| [L-140.1](LEKTOR-140.md#l-140.1) TESTPLAN-Schritte 10/11 doppeln den Prüfstand | **überholt** — der Test ist bestanden; der Kopfsatz bleibt Muster | `Intern/TESTPLAN.md:7` |
| [L-140.2](LEKTOR-140.md#l-140.2) „81 von 81“ aus zwei Läufen; Prüfbericht mit unsauberem Baum | **offen**; PAKETE schreibt es inzwischen richtig, TESTPLAN nicht | `Intern/TESTPLAN.md:58-59` *„**81 Fälle, 81 bestanden**“* gegen `Releases/PAKETE.md:192` *„77 bestanden, 4 rot … nach der Berichtigung … 7 von 7“*; `Releases/PRUEFBERICHT.md:6` *„**Arbeitsbaum nicht sauber** (2 Dateien)“* |
| [L-140.3](LEKTOR-140.md#l-140.3) „kommt mit 7.2.2.132“ nach dem Schnüren | **in [L-142.1](#l-142.1) aufgegangen** — jetzt nach der Veröffentlichung | `grep -o "Testpaket 7.2.2.132" Intern/BEFUNDE.md` → 17, *„kommt mit dem Paket 7.2.2.132“* → 1 ([E-170](../Intern/BEFUNDE.md#e-170), `:430`) (gemessen) |
| [L-138.2](LEKTOR-138.md#l-138.2) Logzeile zum IMAP-Label ([E-170](../Intern/BEFUNDE.md#e-170)) nur unter *Misc* | **teilweise, Rest bewusst**, unverändert | `Intern/BEFUNDE.md:430` |
| [L-138.9](LEKTOR-138.md#l-138.9) Zahl der Berichte in der README | **offen** | `README.md:98` *„(219 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“*; `ls Befunde/LEKTOR-*.md Befunde/PRUEFER-*.md \| wc -l` → 232, mit diesem 233 (gemessen) |
| [L-138.10](LEKTOR-138.md#l-138.10) Ordnernamen in den Logzeilen zu [E-189](../Intern/BEFUNDE.md#e-189) (Vorab-Kopie bleibt im Ziel) | **hier offen, auf dem E-192-Zweig behoben** | `Eudora71/EuImap/src/ImapToc.cpp:1819`, `:1825` weiter *„ziel=\"%s\"“* (gemessen) |
| [L-138.11](LEKTOR-138.md#l-138.11) [E-216](../Intern/BEFUNDE.md#e-216) (About-Dialog) „Umbruch nicht gemessen“ | **offen, jetzt beantwortbar** — Gregors Schritt 8 hat genau das gesehen (*„die Zeilen *Log* und *Mail folder from* ganz zu lesen“*, bestanden, `Intern/TESTPLAN.md:24`, `:48`) | `Intern/BEFUNDE.md:400` *„**Nicht gemessen:** der Umbruch selbst“* |
| [L-138.12](LEKTOR-138.md#l-138.12) CHANGELOG nennt nur den Fall `E-216p` | **offen** | `tools/WERKZEUGE.md:171` |
| [L-139.1](LEKTOR-139.md#l-139.1) TESTPLAN „Erledigt“ bei offenem [E-170](../Intern/BEFUNDE.md#e-170) (Label ohne UIDPLUS) | **offen** | `Intern/TESTPLAN.md:423` *„Erledigt am 03.11.2026: das Label bleibt beim Verschieben im IMAP-Konto“* |

## Funde

### <a id="l-142.1"></a>L-142.1 — 15 offene Befunde warten auf „das Paket 7.2.2.132“, das draußen und von Gregor getestet ist

**Gewicht: mittel — die Liste der offenen Befunde ist um ein Viertel zu lang, und der CHANGELOG widerspricht sich selbst.**

- **Die Bedingung ist erfüllt** (gemessen): in der erzeugten Tabelle `Intern/WEITERMACHEN.md:75-141` nennen 15 Zeilen in der Spalte *was noch fehlt* das Paket 7.2.2.132 als das, worauf sie warten: [E-216](../Intern/BEFUNDE.md#e-216) (About-Dialog) und [A-5](../Intern/BEFUNDE.md#a-5) (Hilfe-Menü) *„Gregors Blick am Paket 7.2.2.132“*; [E-128](../Intern/BEFUNDE.md#e-128) (Endung bei *Speichern unter*) ebenso, dazu der IMAP-Schutz K2; [E-207](../Intern/BEFUNDE.md#e-207) (Signaturfenster speichert leer), [E-205](../Intern/BEFUNDE.md#e-205) (falsches Datum), [E-196](../Intern/BEFUNDE.md#e-196), [E-195](../Intern/BEFUNDE.md#e-195) (Speichern-unter-Kleinigkeiten) *„das Paket 7.2.2.132.“* und sonst nichts; [E-204](../Intern/BEFUNDE.md#e-204) (geerbtes Kennwort) und [E-203](../Intern/BEFUNDE.md#e-203) *„das Paket 7.2.2.132; für Gregor nichts zu prüfen“*; [E-211](../Intern/BEFUNDE.md#e-211), [E-210](../Intern/BEFUNDE.md#e-210) *„das Paket 7.2.2.132; am Programm nicht …“*; [E-209](../Intern/BEFUNDE.md#e-209) (8.3-Kurznamen), [E-194](../Intern/BEFUNDE.md#e-194), [E-133](../Intern/BEFUNDE.md#e-133) (fehlendes Mailverzeichnis), [E-39](../Intern/BEFUNDE.md#e-39) (aktuelle Persönlichkeit gelöscht) mit Paket und einem Rest. `awk '/offene-befunde: Anfang/,/Ende/' … \| grep -c 7.2.2.132` → 15 in WEITERMACHEN, 15 in CHANGELOG.
- **Der Widerspruch im CHANGELOG** (gemessen): `CHANGELOG.md:128` führt unter 7.2.2.132 *„**Berichtigt:** … [E-194](../Intern/BEFUNDE.md#e-194) … [E-195](../Intern/BEFUNDE.md#e-195) … [E-196](../Intern/BEFUNDE.md#e-196) … [E-205](../Intern/BEFUNDE.md#e-205) … [E-207](../Intern/BEFUNDE.md#e-207) … [E-214](../Intern/BEFUNDE.md#e-214) …; Persönlichkeiten — [E-39](../Intern/BEFUNDE.md#e-39), [E-203](../Intern/BEFUNDE.md#e-203), [E-204](../Intern/BEFUNDE.md#e-204) …, [E-210](../Intern/BEFUNDE.md#e-210), [E-211](../Intern/BEFUNDE.md#e-211); IMAP — [E-170](../Intern/BEFUNDE.md#e-170)“*; 11 dieser 12 stehen 100 Zeilen höher unter *Noch offen* (`CHANGELOG.md:34-78`, etwa `:39` [E-204](../Intern/BEFUNDE.md#e-204), `:36` [E-207](../Intern/BEFUNDE.md#e-207)). Für einen Leser, der von der Release-Seite kommt, ist dieselbe Behebung zugleich ausgeliefert und offen.
- **Die Quelle** ist `Intern/BEFUNDE.md`: 17-mal *„steckt im Testpaket 7.2.2.132 (von Gregor am 03.11.2026 getestet)“* (`:243` [A-5](../Intern/BEFUNDE.md#a-5), `:391` [E-128](../Intern/BEFUNDE.md#e-128), `:400`–`:417`, `:452` [E-133](../Intern/BEFUNDE.md#e-133), `:466` [E-39](../Intern/BEFUNDE.md#e-39)), einmal *„kommt mit dem Paket 7.2.2.132“* (`:430` [E-170](../Intern/BEFUNDE.md#e-170)). Gregors Schritte 6–11 haben [A-5](../Intern/BEFUNDE.md#a-5), [E-216](../Intern/BEFUNDE.md#e-216), [E-128](../Intern/BEFUNDE.md#e-128), [E-196](../Intern/BEFUNDE.md#e-196) und [E-207](../Intern/BEFUNDE.md#e-207) am Paket gesehen und bestanden (`Intern/TESTPLAN.md:47-50`); der volle Prüfstandslauf am Bau im Paket lief (`Releases/PAKETE.md:192`). Die Tabelle wird erzeugt — sie wird erst stimmen, wenn die Urteile in BEFUNDE nachgezogen sind (belegt: `Intern/WEITERMACHEN.md:68-71` *„Diese Tabelle wird aus `BEFUNDE.md` **erzeugt**“*).
- **Im Zusammenhang:** [L-138.11](LEKTOR-138.md#l-138.11) (Umbruch im About-Dialog nicht gemessen) ist mit Gregors Schritt 8 beantwortbar.

**Vorschlag:** Je Befund das Urteil fortschreiben — wo nur das Paket fehlte, auf *behoben in 7.2.2.132* mit Verweis auf den TESTPLAN-Schritt bzw. den Prüfstandsfall; wo ein Rest bleibt ([E-128](../Intern/BEFUNDE.md#e-128) K2, [E-194](../Intern/BEFUNDE.md#e-194) K3/K4/K9, [E-133](../Intern/BEFUNDE.md#e-133) K4, [E-39](../Intern/BEFUNDE.md#e-39), [E-209](../Intern/BEFUNDE.md#e-209)), den Rest als einzige Bedingung stehen lassen und *„steckt im Testpaket“* in *„ausgeliefert mit v7.2.2.132“* ändern. Dann `offene-befunde.pl` neu setzen lassen. Vorher die Zweige `messungen_e188_e193`/`e188_loeschschranke` ansehen: dort ist `offene-befunde.pl` schon für 7.2.2.N berichtigt ([L-142.3](#l-142.3)).

### <a id="l-142.2"></a>L-142.2 — FAQ und FUNKTIONEN: „im Quellstand berichtigt, noch in keinem Paket“ und Gregors bestandene Schritte nicht als *bestätigt*

**Gewicht: Kleinkram mit Außenwirkung — beides sind Anwenderdokumente, FUNKTIONEN ist zudem die Quelle der Hilfe-Seiten im Paket.**

- `Doku/FAQ.md:223-226` *„**Im Quellstand für 7.2.2.132 berichtigt, noch in keinem Paket:** ohne UIDPLUS erkennt Eudora die Mail …“* ([E-170](../Intern/BEFUNDE.md#e-170), Label geht beim Verschieben verloren). Seit dem Schnüren falsch, seit der Veröffentlichung öffentlich falsch; `CHANGELOG.md:128` und `README.md:104` führen [E-170](../Intern/BEFUNDE.md#e-170) als in 7.2.2.132 enthalten (gemessen). `doku-pruefen.pl` meldet es nicht.
- `Doku/FUNKTIONEN.md:176` (*Change ▸ Label*) *„im Quellstand für 7.2.2.132 berichtigt“* — dieselbe Lage, milder formuliert, während der Kopf `:19` *„**Stand:** Release 7.2.2.132“* sagt.
- `Doku/FUNKTIONEN.md:265`, `:266` (*Keyboard Shortcuts*, *Settings Reference*) in der Spalte *Stand* weiter *„am Prüfstand gemessen“*, `:269` (*About Eudora*) *„Vorlage; Knopfreihe und neuer Knopf am Prüfstand gemessen, ohne den Knopf zu drücken“*. Die Legende `:17` sagt: *„**bestätigt** — Gregor hat es am laufenden Programm gesehen; der Verweis führt zum Beleg in … TESTPLAN“*. Gregor hat beide Hilfeseiten (Schritte 6, 7) und den gedrückten Knopf *Latest Release* (Schritt 9) gesehen und bestanden (`Intern/TESTPLAN.md:47-48`) (belegt). Ebenso `:85` *Save As* für die Endung aus der Postfachliste und dem Nachrichtenfenster (Schritt 10).
- Nebenbei: `Doku/FUNKTIONEN.md:1097` *Zum Bestätigen*, Zeile 3 (*File → Check Mail*) *„täglicher Weg, nirgends als geprüft vermerkt“* — Gregors Schritte 2 und 3 haben bei jedem Test seit 7.2.1.128 genau das (`Intern/TESTPLAN.md:18-19`, Belege `:44`). Altbestand.

**Vorschlag:** FAQ:223 *„**Behoben in 7.2.2.132:** ohne UIDPLUS …“*; FUNKTIONEN:176 *„in 7.2.2.132 berichtigt“*; `:265`/`:266`/`:269` auf **bestätigt** ([TESTPLAN](../Intern/TESTPLAN.md#test-7-2-2-132), 03.11.2026); `:85` den Endungsteil ebenso. Zeile 3 der Bestätigungsliste streichen und bei *Check Mail* den Verweis setzen.

### <a id="l-142.3"></a>L-142.3 — Die Reihe 7.2.2.N: in zwei Werkzeugen nachgezogen, in einem auf einem Zweig, in sechs nicht

**Gewicht: mittel — Schranken, die die Reihe nicht kennen, melden für sie grün, ohne hinzusehen.** Die beiden Berichtigungen dieses Zweigs sind die dritte und vierte Stelle derselben Klasse; das Werkzeug `tools/release-veroeffentlichen.ps1` hatte das freigegebene Paket abgewiesen (Commit `7a8118e5`), `pruefe-release-buchfuehrung.pl` hielt v7.2.1.131 für das neueste Tag (Commit `606789ba`).

- **Berichtigt und stimmig** (gemessen): `tools/release-veroeffentlichen.ps1` lässt `'^7\.2\.[12]\.\d+$'` zu, Kopfkommentar Punkt 3 *„ein Release traegt die Nummer 7.2.1.N oder 7.2.2.N“*; `tools/pruefe-release-buchfuehrung.pl` `7\.2\.[012]` an beiden Stellen, Selbsttest 23 von 23.
- **Auf einem Zweig berichtigt, hier nicht** (gemessen): `tools/offene-befunde.pl:210`, `:228` `(7\.2\.[01]\.\d+)` für *„Zuletzt gemessen“*/*„Zuletzt belegt“*. Auf `origin/e188_loeschschranke` Commit `f6693b4b`: *„Die Marke verlangte 7.2.0.N oder 7.2.1.N - eine Messung an 7.2.2.132 stand in CHANGELOG/WEITERMACHEN als "nie gemessen". Jetzt [012]“*. Bis zum Merge zählt jede Messung an 7.2.2.132 hier als *nie gemessen* — wichtig für [L-142.1](#l-142.1).
- **Noch nicht nachgezogen** (`grep -nE '7\\\.2\\\.\[01\]' tools/*.pl`, gemessen; Wirkung belegt am Quelltext, nicht ausprobiert):
  - `tools/doku-pruefen.pl:646` (Überschrift nennt die Nummer), `:678`/`:682` (Fassungsstand: *„nennt weder den Quellstand …“*), `:815` (*„behauptet … als gueltigen Quellstand“*). Ab 7.2.2.133 sieht Prüfung 6 eine Datei, die nur *7.2.2.132* nennt, gar nicht als veraltet, und Prüfung `:815` lässt *„Stand 7.2.2.132“* durch (Vermutung zur Wirkung, aus dem Muster abgeleitet).
  - `tools/pruefe-aussenstand.pl:58` (*„veröffentlicht ist …“*) und `:64` `$NUMMER` — genau die Schranke, die Präsensaussagen über den Veröffentlichungsstand gegen `gh` hält; eine Aussage *„veröffentlicht ist v7.2.2.132“* prüft sie nicht. Ein Lauf hier (gemessen): Rückgabe 0 bis auf vier Mängel zu 1.0.115–1.0.119, die daher rühren, dass im Arbeitsbaum keine ZIPs liegen — kein Fund.
  - `tools/pruefe-behoben-ausgeliefert.pl:132`, `:148`, `:360`, `:361`, `:386`, `:419` — erkennt *„behoben in 7.2.2.N“*, ein Verzeichnis `Eudora72-7.2.2.N-release` und Überschriften `## 7.2.2.N` nicht.
  - `tools/pruefe-nachgestellt.pl:72`, `tools/pruefe-original-belegt.pl:102`, `:104` — *„an 7.2.2.132 gemessen/nachgestellt“* wird nicht als Beleg erkannt.
  - `tools/ausliefern.pl:111` — liest die Fassung der Testverzeichnisse nur als 7.2.0/7.2.1.
- **WERKZEUGE.md** (gemessen): `tools/WERKZEUGE.md:194` zu `pruefe-release-buchfuehrung.pl` *„`--tests` fährt **19 Fälle**“* — es sind 23 (schon vor diesem Zweig 21, laut Commit `606789ba` *„am alten Muster rot (2 von 23)“*); die Reihe 7.2.2 erwähnt der Eintrag nicht. `:129` zu `release-veroeffentlichen.ps1` nennt keine Nummernregel — dort fehlt nichts.

**Vorschlag:** Ein gemeinsames Muster (etwa `7\.2\.\d\.\d+`) statt der Aufzählung `[01]`/`[012]`, damit 7.2.3 nicht die nächste Runde auslöst; je Werkzeug ein Selbsttest mit einer 7.2.2-Nummer, am alten Muster rot. `WERKZEUGE.md:194` auf 23 Fälle und die Reihe 7.2.2.

### <a id="l-142.4"></a>L-142.4 — Das Nummernschema in den Dokumenten kennt nur 7.2.1.N

**Gewicht: Kleinkram, aber Quelle des Fehlers aus [L-142.3](#l-142.3)** — wer die Werkzeuge nach den Dokumenten richtet, findet 7.2.2 nirgends.

- `CHANGELOG.md:3-5` *„Jede Nummer gehört genau einem Bau: **`7.2.1.N`** (seit dem Release 7.2.1.128 für Testpaket wie Release …)“* — der erste Abschnitt darunter ist 7.2.2.132.
- `Releases/PAKETE.md:51-54` *„**Seit dem Release 7.2.1.128 heißt jede Fassung `7.2.1.N`** … ZIP (`Eudora72-7.2.1.N-release.zip`), Marke (`v7.2.1.N`)“*; `:96` *„`7.2.1.N` — **sechs Zeilen**“* (für 7.2.2 ist `EUDORA_VERSION3` 2, nicht 1).
- `Doku/MITARBEITEN.md:66` *„`7.2.1.N` für Testpaket wie Release (Gregors Entscheidung 20)“*.
- `Intern/WEITERMACHEN.md:170` Entscheidung 20 *„**ab dem Release 7.2.1.128 heißt jede neue Fassung 7.2.1.N**“* ohne Hinweis auf die Entscheidung vom 02.11.2026; Entscheidung 10 (`:160`) hat für die Ablösung durch 20 einen solchen Hinweis — für 7.2.2 fehlt er. Die Entscheidung steht in `ZIEL.md:108-121` und `Arbeitsweise/entscheidung-7-2-2-umfang.md`, nicht in der Entscheidungsliste.
- `ZIEL.md:41` *„veröffentlicht wird ein Stand erst nach seinem Test, mit der Marke `v7.2.1.<n>`“* gegen `ZIEL.md:120` *„Die Marke auf GitHub heißt entsprechend `v7.2.2.<n>`“* — in derselben Datei.

**Vorschlag:** an jeder Stelle *„7.2.1.N für Fehlerbehebungen, 7.2.2.N mit neuen Funktionen (Gregor 02.11.2026)“*; in WEITERMACHEN eine Entscheidung 25 mit Verweis aus 20 heraus.

### <a id="l-142.5"></a>L-142.5 — [E-188](../Intern/BEFUNDE.md#e-188) (Mail geht beim Verschieben verloren): README und Release-Notizen sagen „gemessen“, BEFUNDE sagt „nie gemessen, nicht untersucht“

**Gewicht: mittel — es geht um Datenverlust, und der Befund ist hinter der eigenen Warnung zurück.**

- `README.md:173` *„**Lehnt das Ziel das Hochladen ab oder lässt sich der Text nicht laden, löscht Eudora die Mail in der Quelle trotzdem** … (am Prüfstand am 03.11.2026 an 7.2.2.132 gemessen …)“*; `Releases/7.2.2.132/RELEASE-NOTIZEN.md:89-96` ebenso, öffentlich.
- `Intern/BEFUNDE.md:421` *„**offen, am Quelltext belegt … nie gemessen**“*, *„Kurz: … treffen dabei womöglich eine fremde Mail“*, *„**Stufe: wichtig** (… ob auf dem Server etwas verloren gehen kann, ist nicht untersucht)“*; die erzeugte Zeile `Intern/WEITERMACHEN.md:98` *„**nie gemessen** | am Prüfstand nachstellen“* (gemessen).
- Fortgeschrieben ist der Befund auf `origin/messungen_e188_e193` bzw. `origin/e188_loeschschranke` (Commit `8225deb6` *„[E-188](../Intern/BEFUNDE.md#e-188), [E-193](../Intern/BEFUNDE.md#e-193): Befunde fortgeschrieben (Messung, Ursache, Abwaegung)“*, `f6693b4b` *„Zuletzt gemessen: 03.11.2026 an 7.2.2.132“*) (gemessen an `git log`). Die Stufe dort habe ich nicht gelesen.
- Die Folge: `Arbeitsweise/kein-paket-mit-offenem-datenverlust.md` und `Arbeitsweise/entscheidung-e188-release-7-2-2-132.md` setzen voraus, dass ein Verlust auf dem Server als solcher in BEFUNDE steht; auf diesem Stand steht er dort als *„nicht untersucht“* (belegt).

**Vorschlag:** Den Stand der beiden Zweige zu [E-188](../Intern/BEFUNDE.md#e-188) bald nach `main` bringen, unabhängig von der Behebung; die Einstufung dabei an der Legende prüfen (Verlust auf dem Server).

### <a id="l-142.6"></a>L-142.6 — `main` sagt öffentlich noch „Testpaket … nicht veröffentlicht“; die Marke liegt nicht auf `main`

**Gewicht: mittel — die Release-Notizen verlinken auf `blob/main`.**

- `git show origin/main:README.md` Zeile 104 (gemessen): *„*Stand **7.2.2.132** — Testpaket, die erste Fassung der Reihe 7.2.2: am 03.11.2026 geschnürt, nicht veröffentlicht, …“*; Zeile 204 *„Im Testpaket 7.2.2.132 steht der Inhalt darin“*. Die Release-Notizen schicken den Leser genau dorthin (`RELEASE-NOTIZEN.md:72` *„[README unter „Bekannte Fehler“](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md#bekannte-fehler)“*).
- `origin/main` steht auf `7de75dcf`; die Marke `v7.2.2.132` auf `7a8118e5` liegt nur auf `origin/release_7_2_2_132` (gemessen: `git log -2 origin/main`, `git ls-remote --tags`). `gh pr list --head release_7_2_2_132 --state all` → `[]` — es gibt keinen PR für die Nachträge (gemessen).
- Für die Nachträge selbst gilt: auf diesem Zweig stimmt alles, was oben unter *Urteil* steht; ein Merge macht `main` richtig.

**Vorschlag:** PR für `release_7_2_2_132` — mit diesem Bericht und den Berichtigungen aus [L-142.1](#l-142.1) bis [L-142.5](#l-142.5), soweit sie bis dahin fertig sind; nicht auf sie warten, wenn sie länger dauern.

### <a id="l-142.7"></a>L-142.7 — Die Release-Notizen zu 7.2.2.132 nennen den Rückstand an Regressionstests nicht

**Gewicht: Kleinkram, aber gegen den eigenen Maßstab.**

- `ZIEL.md:115-116` *„**7.2.2 ist die erste Fassung mit neuen Funktionen.** Für sie gelten dieselben Punkte 1 bis 4 wie für 7.2.1.x“*; Punkt 4 (`ZIEL.md:35-36`): *„**Fehlende automatische Tests** dürfen nachgeliefert werden; die Release-Notizen nennen den Rückstand“*.
- `Releases/7.2.1.131/RELEASE-NOTIZEN.md:92-95` hat den Satz (*„Bei den kritischen Befunden sind es am 02.11.2026 noch **6 von 70** ohne jede Prüfung“*); `Releases/7.2.2.132/RELEASE-NOTIZEN.md:58-66` (*Wie geprüft*) nicht — `grep -i "rückstand\|nachgeliefert"` → 0 (gemessen). Heute: *„OHNE jede Pruefung 4 … [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129)“* von 72 (`pruefe-regressionstest.pl`, gemessen).
- Keine Schranke hat das bemerkt — Punkt 4 ist in [L-101.1](LEKTOR-101.md#l-101.1) schon einmal für 7.2.1.128 gemeldet worden (`ZIEL.md:37-38`), das ist das zweite Auftreten.

**Vorschlag:** den Satz in die Vorlage der Release-Notizen bzw. als Prüfung in `paket-bereit.pl` aufnehmen, damit er beim nächsten Paket nicht wieder fehlt. Ob der veröffentlichte Text nachträglich ergänzt wird, ist Gregors Frage (unten).

### <a id="l-142.8"></a>L-142.8 — Kleinkram

- `ZIEL.md:121-122` *„**Umgesetzt, am Prüfstand gemessen, auf `main` seit #206** (im Testpaket 7.2.2.132, [[A-5](../Intern/BEFUNDE.md#a-5)]…)“* — drei Zeilen über dem nachgezogenen *„Dazu in 7.2.2.132 (veröffentlicht am 03.11.2026)“* (`:135`).
- `ZIEL.md:227` *„**Was zur Fassung 7.2.1 noch fehlt, steht im erzeugten Block oben**“* — der Block heißt weiter so; mit der Reihe 7.2.2 trägt die Überschrift (`ZIEL.md:10`) nicht mehr allein. Kein Fehler, nur ein Hinweis zur Form.
- `Intern/WEITERMACHEN.md:15`, `:20` *„Nach dem Release 7.2.1“* als Name der einzigen Aufgabenliste — der Anker wird von `pruefe-nach-dem-release.pl` geprüft, eine Umbenennung braucht also das Werkzeug mit (belegt: `:15-18`).
- `README.en.md:36-48` *Known issues* nennt zwei Punkte (Defender, Entwürfe) und verweist sonst auf die deutsche Liste; die Warnung zu [E-188](../Intern/BEFUNDE.md#e-188) (Mail im Ziel prüfen vor *Purge*) steht nur auf Deutsch. Die Release-Notizen sind ebenfalls deutsch — Form der Doku, kein Widerspruch.
- `Doku/FAQ.md:214` *„**Bekannte Einschränkung bis einschließlich 7.2.1.131:**“* stimmt (Abschnitt [E-170](../Intern/BEFUNDE.md#e-170)); nur der Schluss `:223` ist falsch (siehe [L-142.2](#l-142.2)).
- `Releases/PAKETE.md:6` Kopf: v7.2.2.132 *„auf GitHub *Latest*“*, v7.2.1.131 *„damals *Latest*“* — stimmt mit `releases/latest` (gemessen). `Releases/PAKETE.md:854`, `:867` *„(heute ist `v7.2.2.132` *Latest*)“* — stimmt.
- **„nicht veröffentlicht“ zu 7.2.2.132 übrig?** Auf diesem Zweig nein: in README, README.en, CHANGELOG, TESTPLAN, ZIEL, PAKETE, WEITERMACHEN, AUFGABEN, Doku/* und den Release-Notizen steht es nur noch für 7.2.1.129/7.2.1.130 und 1.0.114 (gemessen, `grep -n "nicht veröffentlicht"` über die führenden Dateien). Übrig sind die Wendungen aus [L-142.1](#l-142.1) (*Testpaket 7.2.2.132* in BEFUNDE und den erzeugten Tabellen) und [L-142.2](#l-142.2) (*noch in keinem Paket* in der FAQ) — und `main` ([L-142.6](#l-142.6)).

## Bestand außerhalb des Schwerpunkts

- **Persönliche Angaben:** keine in den Änderungen seit `7de75dcf` außerhalb von `Arbeitsweise/` (gelesen: `git show 7a8118e5 606789ba -- README.md CHANGELOG.md Intern/ Releases/ ZIEL.md Doku/ tools/RELEASES.md`). PAKETE spricht von *„neben Gregors letztem Testverzeichnis“* ohne Pfad. `Releases/PAKETE.md:200` (7.2.1.131, Altbestand) nennt `C:\Users\Gregor\Eudora72-7.2.1.131-release` — schon vor diesem Zweig so.
- **Gregors Entscheidung „Stehen lassen“** zu [E-188](../Intern/BEFUNDE.md#e-188) steht in `Releases/PAKETE.md:184` und `Arbeitsweise/entscheidung-e188-release-7-2-2-132.md` gleichlautend; dass `Intern/WEITERMACHEN.md:3` *„der Zweigname wird vorher abgestimmt“* durch den bestätigten Zweig `e188_loeschschranke` ersetzt wird, ist dem Hauptagenten bekannt (in `.wt/release` ungestaget) — kein Fund.
- **TESTPLAN Schritt 9** (`Intern/TESTPLAN.md:25`): *„seit dem 03.11.2026 ist das 7.2.2.132 selbst, bei deinem Test war es noch 7.2.1.131“* — stimmt mit `releases/latest` (gemessen).

## Was nur Gregor entscheiden kann

1. **Den veröffentlichten Release-Text von v7.2.2.132 um den Satz zum Rückstand an Regressionstests ergänzen?** ([L-142.7](#l-142.7): ZIEL verlangt, dass die Release-Notizen nennen, welche kritischen Befunde noch keinen automatischen Test haben — heute 4 von 72; bei 7.2.1.131 stand der Satz drin, bei 7.2.2.132 fehlt er.) Ja heißt: `gh release edit` und dieselbe Zeile in `Releases/7.2.2.132/RELEASE-NOTIZEN.md`; Nein heißt: erst ab dem nächsten Paket. Du hast veröffentlichte Release-Texte schon zweimal berichtigen lassen (Entscheidungen 17 und 19 in `Intern/WEITERMACHEN.md`).
