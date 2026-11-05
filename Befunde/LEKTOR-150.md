# <a id="lektor-150"></a>LEKTOR-150 (05.11.2026) — Zweig `paket_7_2_2_133` nach 3d4ba7da: Release v7.2.2.133 und die Nachträge gegen den Bestand, vor dem PR nach `main`

**Umfang:** `git log --stat 70bcc775..HEAD` (13 Commits, von `7818338c` „Versionssprung“ bis `3d4ba7da` „S-3c fortgeschrieben“). Gelesen habe ich die geänderten Stellen und dazu den Bestand: `Releases/7.2.2.133/RELEASE-NOTIZEN.md` (gegen den veröffentlichten Text, `gh release view v7.2.2.133`), `Releases/PAKETE.md`, `Releases/PRUEFBERICHT.md`, `CHANGELOG.md`, `README.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `Intern/AUFGABEN.md`, `ZIEL.md`, `Doku/FAQ.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`, `Intern/BEFUNDE.md` ([E-188](../Intern/BEFUNDE.md#e-188), [E-192](../Intern/BEFUNDE.md#e-192), [E-193](../Intern/BEFUNDE.md#e-193), [E-199](../Intern/BEFUNDE.md#e-199), [E-220](../Intern/BEFUNDE.md#e-220), [E-221](../Intern/BEFUNDE.md#e-221), [E-222](../Intern/BEFUNDE.md#e-222), [E-223](../Intern/BEFUNDE.md#e-223), [E-224](../Intern/BEFUNDE.md#e-224), [S-3](../Intern/BEFUNDE.md#s-3)/S-3c), [PRÜFER-99](PRUEFER-99.md#pruefer-99), `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md`, dazu `Eudora71/Eudora/TridentView.cpp` (Diff gegen den ersten Commit `567a5d87`). Gebaut und gestartet habe ich nichts.

**Urteil:** Die Buchführung des Releases selbst stimmt: Marke `v7.2.2.133` auf `a0278acf` (gemessen, `git ls-remote`), zwischen dem Paketbau `3d3789d3` und `a0278acf` keine Änderung unter `Eudora71/` (gemessen, `git diff --stat`), der veröffentlichte Text gleicht der Datei bis auf einen Zeilenvorschub am Ende (gemessen, `diff`). **Nichts hält den PR nach `main` auf.** Acht Funde, keiner betrifft Mailverlust. Die drei wichtigsten:

1. Die sechs ausgelieferten Befunde stehen in BEFUNDE weiter auf „kommt mit dem nächsten Paket“, ihre Spalte „was noch fehlt“ verlangt Erledigtes, und [E-220](../Intern/BEFUNDE.md#e-220) erscheint als „nie gemessen“ ([L-150.1](#l-150.1)). Das ist dasselbe wie [L-142.1](LEKTOR-142.md#l-142.1) bei 7.2.2.132, also zum zweiten Mal.
2. Die Release-Notizen nennen den Rückstand an Regressionstests nicht, obwohl ZIEL das verlangt und Gregor am 04.11.2026 festgelegt hat: *ab dem nächsten Release fest in der Vorlage*. Eine Vorlage oder Schranke dafür gibt es nicht ([L-150.2](#l-150.2)).
3. Im veröffentlichten Text stimmen vier Aussagen nicht mit dem Bestand. Die 90 Prüfstandsfälle liefen nicht „an den Bauten der einzelnen Behebungen“, sondern alle am Sammelbau `7818338c`. Dass „alle“ neuen Fehler aus dem Original stammen, ist beim Rest von [E-193](../Intern/BEFUNDE.md#e-193) nicht belegt. Dazu kommen zwei absolute Sätze zu [E-188](../Intern/BEFUNDE.md#e-188) und [E-221](../Intern/BEFUNDE.md#e-221) ([L-150.3](#l-150.3)).

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*, *„Quellstand 7.2.2.133“*, *„Paketnummer 7.2.2.133“*, *„gepruefte Dateien 54“*, dazu 22 Hinweise *„… nennt weder den Quellstand 7.2.2.133 noch die Paketnummer 7.2.2.133“*. Darunter steht *„Doku/FAQ.md … (hoechste genannte Fassung: 7.2.2.132)“*, und das trifft einen echten Fund ([L-150.5](#l-150.5)). Die übrigen sind Altbestand.
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 59“*, *„aktuell gemessen 21“*, *„nur am Quelltext 2“*, *„veraltet gemessen 26“*, *„NIE gemessen 12“*, *„59 offene Befunde, in beiden Listen gleich.“* In den 59 stecken die sechs ausgelieferten Befunde aus [L-150.1](#l-150.1). `git status` danach leer.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„Befunde insgesamt 252“*, *„behoben und OHNE Testfall 50 <- Rueckstand“*, *„kritisch 69“*, *„unkritisch 57“*, *„mit Testfall im Pruefstand 67 von 69“*, *„OHNE jede Pruefung 0 <- Rueckstand“*, *„Kein neues "behoben" ohne Regressionstest.“*
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* Das Werkzeug sieht nicht, dass Kriterium 4 in den Notizen fehlt ([L-150.2](#l-150.2)).
* `perl tools/befunde-verlinken.pl` (gemessen): *„Anker: vollstaendig“*, *„Jede Kennung ist ein Link, und jeder Link trifft eine Urteilszeile.“*

## Funde aus LEKTOR-149 — heutiger Stand

[LEKTOR-149](LEKTOR-149.md#lektor-149) galt dem Zweig `e199_festbreite`. Gregor hat ihn als #221 gemergt (`55004ca5`, Vorfahr von HEAD, gemessen), **bevor** die drei Funde eingearbeitet waren. In `Intern/LEKTORAT.md` fehlt zu [LEKTOR-149](LEKTOR-149.md#lektor-149) die Zeile „Eingearbeitet“ (gemessen, letzte Zeilen der Datei).

| Fund | Stand | Stelle (heute) |
|---|---|---|
| [L-149.1](LEKTOR-149.md#l-149.1) [E-199](../Intern/BEFUNDE.md#e-199) (Festbreite schreibt `t;` in den Text): „der Test zählt jede Schreibweise“ | **offen** | `Intern/BEFUNDE.md:418` *„PRÜFER-98 K1 und K2 (`1e96dc3a`: Wirkprobe sieht Platzhalter, `T>`-Rest und fehlende Festbreite, der Test zählt jede Schreibweise)“* (gemessen, unverändert) |
| [L-149.2](LEKTOR-149.md#l-149.2) WERKZEUGE und TESTPLAN: „das Urteil prüft nur die Zeichen“ | **offen** | `tools/WERKZEUGE.md:171` *„es prüft nur, ob 🔥 und Ж erhalten sind und kein `?` dasteht, nicht, ob ein Befehl gewirkt hat“*; `Intern/TESTPLAN.md:442` *„Das Urteil sieht nur die beiden Zeichen“* (gemessen) |
| [L-149.3](LEKTOR-149.md#l-149.3) FAQ 20 und README: „in dieser Ladung“, obwohl die Teile bei dauerhafter Verweigerung nie erscheinen | **offen** | `Doku/FAQ.md:447-449` *„erscheinen in dieser Ladung nicht. Die Mail bleibt „nicht geladen“ und wird beim nächsten Öffnen neu geholt“*; `README.md:175` *„die Teile dahinter fehlen in dieser Ladung, die Mail wird beim nächsten Öffnen neu geholt“* (gemessen) |

Alle drei sind Wortlaut, je ein Halbsatz; die Vorschläge in [LEKTOR-149](LEKTOR-149.md#lektor-149) gelten unverändert. Sie gehören in denselben PR, weil sie seit #221 auf `main` stehen.

## Funde

### <a id="l-150.1"></a>L-150.1 — Sechs ausgelieferte Befunde warten in BEFUNDE weiter auf „das nächste Paket“

**Gewicht: mittel.** Es geht nichts verloren, aber `main` sagt nach dem Merge über sechs Behebungen das Gegenteil des Releases. Der Fall ist derselbe wie [L-142.1](LEKTOR-142.md#l-142.1) bei 7.2.2.132; er tritt also zum zweiten Mal auf.

Die Urteile (gemessen, Spalte 3 der Zeilen):

- `Intern/BEFUNDE.md:426` [E-188](../Intern/BEFUNDE.md#e-188) (Mailverlust beim Verschieben zwischen Konten): *„offen — im Quellstand behoben (Zweig `e188_loeschschranke`, 04.11.2026), … kommt mit dem nächsten Paket.“*
- `Intern/BEFUNDE.md:424` [E-192](../Intern/BEFUNDE.md#e-192) (Papierkorb mit mehreren IMAP-Mails vertauscht Einträge): *„offen — im Quellstand behoben … kommt mit dem nächsten Paket.“*
- `Intern/BEFUNDE.md:423` [E-193](../Intern/BEFUNDE.md#e-193) (Suche mit Umlauten und €): *„offen — im Quellstand behoben (Zweig `e193_suche_zweistufig`, 04.11.2026) … kommt mit dem nächsten Paket.“*
- `Intern/BEFUNDE.md:418` [E-199](../Intern/BEFUNDE.md#e-199) (Festbreite schreibt `t;`): *„offen — im Quellstand behoben (Zweig `e199_festbreite`, 04.11.2026) … kommt mit dem nächsten Paket.“*
- `Intern/BEFUNDE.md:403` [E-220](../Intern/BEFUNDE.md#e-220) (Dateiname beim Speichern): *„offen — im Quellstand behoben (03.11.2026, Zweig `e220_dateiname_vorschlag`) und am Prüfstand gemessen; kommt mit dem nächsten Paket nach 7.2.2.132.“*
- `Intern/BEFUNDE.md:404` [E-221](../Intern/BEFUNDE.md#e-221) (langer Betreff verliert sieben Zeichen): *„offen — im Quellstand behoben … kommt mit dem nächsten Paket.“*

Die erzeugte Spalte „was noch fehlt“ verlangt Erledigtes (gemessen, `CHANGELOG.md:34-49`, gleich in `Intern/WEITERMACHEN.md`):

- [E-193](../Intern/BEFUNDE.md#e-193): *„die Umsetzung (Index, bei Umlaut oder € jeden Treffer nachprüfen); alte gegen neue Fassung messen …“*. Umgesetzt ist das seit `c3016591`.
- [E-192](../Intern/BEFUNDE.md#e-192): *„PRÜFER über die Behebung; Paket.“* Der PRÜFER war [PRÜFER-99](PRUEFER-99.md#pruefer-99).
- [E-199](../Intern/BEFUNDE.md#e-199): *„das Paket; ein weiterer LEKTOR über den Zweig nach [[LEKTOR-148](LEKTOR-148.md#lektor-148)] …“*. Der war [LEKTOR-149](LEKTOR-149.md#lektor-149).
- [E-188](../Intern/BEFUNDE.md#e-188): *„das Paket (… #220 ist gemergt …)“*.
- [E-220](../Intern/BEFUNDE.md#e-220): *„Gregors Blick am nächsten Paket“*.
- [E-221](../Intern/BEFUNDE.md#e-221): *„Gregors Test am nächsten Paket …“*.

[E-220](../Intern/BEFUNDE.md#e-220) erscheint in der Tabelle als *„**nie gemessen**“* (`CHANGELOG.md:35`), obwohl das Urteil „am Prüfstand gemessen“ sagt und `E-220p` im Prüfbericht grün steht (`Releases/PRUEFBERICHT.md`, *„E-220p | **ok, ANDERER BAU** | 2026-11-04 17:53:26“*). Der Grund (belegt): dem Urteil fehlt die Marke `**Zuletzt gemessen: … an 7.2.x.y**`, nach der `tools/offene-befunde.pl:210` sucht.

Gregor hat im Test keinen Schritt einzeln gemeldet (`Intern/TESTPLAN.md:29` *„einzelne Schritte nicht als *bestanden* oder *nicht bestanden* gemeldet“*). „Von Gregor bestätigt“ wie bei 7.2.2.132 lässt sich also nicht schreiben. Am Paket gemessen ist jeder der sechs (gemessen, Fallzeilen im Prüfbericht):

- am Sammelbau `7818338c`: `E-188k/a/u/t/l/f/tm/fm/e/d`, [`E-192`](../Intern/BEFUNDE.md#e-192), `E-184m`, `E-178p` (für [E-199](../Intern/BEFUNDE.md#e-199)), `E-220p`, `E-221p`;
- am Paketbau `3d3789d3`: `E-193p` und `E-193w`.

Zwischen den beiden Bauten hat sich unter `Eudora71/` nur `SearchEngine.cpp` und `TestE193.cpp` geändert (gemessen, `git diff --stat 7818338c 3d3789d3 -- Eudora71`).

**Vorschlag:**

- [E-188](../Intern/BEFUNDE.md#e-188), [E-192](../Intern/BEFUNDE.md#e-192), [E-199](../Intern/BEFUNDE.md#e-199), [E-220](../Intern/BEFUNDE.md#e-220), [E-221](../Intern/BEFUNDE.md#e-221): *„**behoben in 7.2.2.133** (veröffentlicht am 05.11.2026); am Prüfstand am Paket gemessen, Fall … grün am Bau `7818338c` (bis auf `SearchEngine.cpp` gleich dem Paketbau); Gregors Test an 7.2.2.133 meldete keinen Schritt einzeln.“* Bei [E-188](../Intern/BEFUNDE.md#e-188) die offenen geringen Reste (PRÜFER-94 K3/K4/K6/K7, PRÜFER-95 K4/K5/K6) als einzige Bedingung stehen lassen. „Was noch fehlt“ leeren oder auf diese Reste setzen.
- [E-220](../Intern/BEFUNDE.md#e-220) und [E-221](../Intern/BEFUNDE.md#e-221): dazu die Marke `**Zuletzt gemessen: 04.11.2026 an 7.2.2.133**`.
- [E-193](../Intern/BEFUNDE.md#e-193) bleibt **offen**, aber nur noch für den Rest. *Find Messages* ist behoben in 7.2.2.133. Offen sind *Edit → Find* in der Outlook-Rundmail und der IMAP-Weg (siehe [L-150.4](#l-150.4)).
- Werkzeug: Es passiert zum zweiten Mal, also nach `Arbeitsweise/fehlerklassen-abstellen.md` eine Schranke. `pruefe-release-buchfuehrung.pl` (oder `offene-befunde.pl`) meldet jedes Urteil mit *„kommt mit dem nächsten Paket“* oder *„im Quellstand behoben“*, dessen genannter Zweig Vorfahr der neuesten Marke `v7.2.2.*` ist.

### <a id="l-150.2"></a>L-150.2 — Die Release-Notizen nennen den Rückstand an Regressionstests nicht, zum dritten Mal

**Gewicht: mittel.** Eine Vorgabe aus ZIEL und eine ausdrückliche Entscheidung Gregors sind nicht umgesetzt, und keine Schranke merkt es.

- `ZIEL.md:34-37` *„**Fehlende automatische Tests** dürfen nachgeliefert werden; die Release-Notizen nennen den Rückstand … Bei 7.2.1.128 fehlt dieser Satz in den Notizen ([[L-101.1](LEKTOR-101.md#l-101.1)])“*.
- `Arbeitsweise/entscheidung-release-text-7-2-2-132-nachtrag.md:13` (Gregor 04.11.2026) *„Der Satz zum Rückstand an Regressionstests … kommt erst ab dem nächsten Release, dann fest in die Vorlage der Release-Notizen.“* Das nächste Release ist 7.2.2.133.
- `grep -c 'Rückstand\|ohne jede Prüfung\|ohne automatischen' Releases/7.2.2.133/RELEASE-NOTIZEN.md` → 0 (gemessen). Der Text sagt nur *„Jede Behebung hat einen Regressionstest“* (`:36`). Das betrifft die sechs neuen Behebungen, nicht den Altbestand.
- Eine Vorlage gibt es nicht (gemessen, kein solches Wort in `Releases/` und `tools/WERKZEUGE.md`). `tools/release-pruefen.pl` und `tools/release-veroeffentlichen.ps1` prüfen den Satz nicht (gemessen, `grep -n 'Rückstand\|Rueckstand'` → 0). `ziel-stand.pl` meldet trotzdem *„27 von 27 erfüllt“*.
- Das Muster gibt es schon: `Releases/7.2.1.131/RELEASE-NOTIZEN.md:92-95` *„**Rückstand an Regressionstests:** … Bei den kritischen Befunden sind es am 02.11.2026 noch **6 von 70** ohne jede Prüfung“*.

**Vorschlag:** In `Releases/7.2.2.133/RELEASE-NOTIZEN.md` den Absatz nach dem Muster von 7.2.1.131 nachtragen. Die Zahlen kommen aus `pruefe-regressionstest.pl`: heute **0 von 69** kritischen ohne jede Prüfung, **50** behobene ohne eigenen Testfall. Dazu eine Prüfung in `release-pruefen.pl`, die ohne den Satz abweist (Muster in der Datei, Zahl gegen das Werkzeug). Ob der **veröffentlichte** Text nachgezogen wird, ist Gregors Frage (unten).

### <a id="l-150.3"></a>L-150.3 — Im veröffentlichten Release-Text stimmen vier Aussagen nicht mit dem Bestand

**Gewicht: mittel.** Der Text liegt so auf GitHub (gemessen: `gh release view v7.2.2.133 --json body` gleich der Datei).

1. **„die übrigen 90 an den Bauten der einzelnen Behebungen“** (`RELEASE-NOTIZEN.md:38-40` *„von den 96 Prüfstandsfällen liefen 6 an genau diesem Bau, die übrigen 90 an den Bauten der einzelnen Behebungen, keiner rot“*). Gemessen an der Falltabelle in `Releases/PRUEFBERICHT.md`: 90 Fälle tragen `Eudora 7.2.2.133+7818338c 2026-11-04 16:51` und 6 tragen `Eudora 7.2.2.133+3d3789d3 2026-11-04 18:02`. Alle 90 liefen also im vollen Lauf am **Sammelbau**, nicht an Einzelbauten. Das sagt auch `Releases/PAKETE.md:194` *„voller Lauf am Bau `7818338c` …: 96 Fälle, 95 bestanden; rot nur `E-141g`, Erwartung seit [[E-188](../Intern/BEFUNDE.md#e-188)] veraltet …, berichtigt“*. Der wirkliche Stand ist besser als der Text: ein Bau statt vieler. „Keiner rot“ stimmt nur für den jeweils letzten Lauf, denn `E-141g` war am Sammelbau rot.
2. **„Alle stammen aus dem Original“** (`:44-45`). Für [E-222](../Intern/BEFUNDE.md#e-222) (S/MIME-Mail lässt sich nicht öffnen) und [E-223](../Intern/BEFUNDE.md#e-223) („Remember password“ erst beim zweiten Mal) ist das am Quelltext belegt (*„Quelltext original, am Original nicht gemessen“*). Für den **Rest von [E-193](../Intern/BEFUNDE.md#e-193)** (*Edit → Find* übersieht ein Wort in einer Outlook-Rundmail) ist es nicht belegt. Die Ursache ist offen (`Intern/BEFUNDE.md:423` *„**Vermutung, nicht gemessen:** `findText` kommt hinter den Emoji … aus dem Tritt“*). Auf `e223_e222_e193rest` ist diese Vermutung inzwischen widerlegt, die Ursache aber weiter offen (Commit `6a3da99d`: *„Ursache bei Gregors Mail weiter offen“*). Das Projekt hat außerdem genau die Anzeigedatei geändert, in der *Edit → Find* sucht (belegt, `git diff 567a5d87 HEAD -- Eudora71/Eudora/TridentView.cpp`). `WriteTempFile` schreibt seit [E-86](../Intern/BEFUNDE.md#e-86) `<meta http-equiv="X-UA-Compatible" content="IE=edge">` und ein eigenes `charset=windows-1252` an den Anfang, und `DoFindFirst` hat zwei neue Ausstiege für `WM_QUIT`. Ob der Fehler aus dem Original stammt oder aus dem IE=edge-Modus, ist also offen. Derselbe Satz steht in `README.md:104` (*„drei neue Fehler aus dem Original“*), `CHANGELOG.md:124` (*„alle aus dem Original“*), `Intern/TESTPLAN.md:29` und `Releases/PAKETE.md:189`.
3. **„Die scheinbar doppelten Einträge im Zielordner entstehen nicht mehr“** (`:8-9`). Das ist absolut gesagt. [E-188](../Intern/BEFUNDE.md#e-188) führt aber selbst zwei seltene Wege zu einem zweiten Eintrag als offen (`Intern/BEFUNDE.md:426`): *„K4 (nach einem Neustart mit gespeicherter Warteschlange fehlt das Merkzeichen, nach lokal entsteht ein zweiter Eintrag)“* aus PRÜFER-94 und *„K4 (… die Mail stünde zweimal im Ziel, einmal unter falschem Betreff)“* aus PRÜFER-95. Keiner davon kostet Mail.
4. **„auch bei Mails anderer Programme“** zu [E-221](../Intern/BEFUNDE.md#e-221) (`:29-30`; ebenso `CHANGELOG.md:132` *„eine so gefaltete Nachricht eines anderen Programms kommt jetzt ebenfalls mit vollem Betreff in die Liste“*). Das gilt nur bei POP. Bei IMAP liest Eudora einen so gefalteten Betreff an einer anderen Stelle vermutlich als **leer** ([PRÜFER-99](PRUEFER-99.md#k5) K5, *„Bei POP ist das jetzt behoben, bei IMAP nicht.“*; am Quelltext belegt, nicht gemessen). Siehe [L-150.4](#l-150.4).

**Vorschlag:** In der Datei:

- (1) *„die übrigen 90 im vollen Lauf am Sammelbau `7818338c` desselben Pakets (danach nur die Suche geändert); dort war `E-141g` rot, weil seine Erwartung seit [E-188](../Intern/BEFUNDE.md#e-188) veraltet war, am Paketbau grün“*;
- (2) *„[E-222](../Intern/BEFUNDE.md#e-222) und [E-223](../Intern/BEFUNDE.md#e-223) stammen aus dem Original; beim Rest von [E-193](../Intern/BEFUNDE.md#e-193) ist die Ursache noch offen“*, ebenso in README, CHANGELOG, TESTPLAN und PAKETE;
- (3) *„entstehen beim gewöhnlichen Verschieben nicht mehr“*;
- (4) *„bei POP auch …; bei IMAP noch nicht (PRÜFER-99 K5)“*.

Ob der veröffentlichte Text nachgezogen wird, ist Gregors Frage (unten).

### <a id="l-150.4"></a>L-150.4 — PRÜFER-99 K3, K5 und K6 stehen in keinem Befund; die Kennungen E-232 und E-233 gibt es nicht

**Gewicht: mittel.** K5 ist als *wichtig* eingestuft, und dieser Fund geht sonst verloren.

- [PRÜFER-99](PRUEFER-99.md#pruefer-99) `:15` *„Ich habe zwei neue Kennungen vergeben: E-232 (K1) und E-233 (K5). Beide stehen noch nicht in BEFUNDE.md.“* Gemessen: `grep -rn 'E-233' --include=*.md .` trifft nur `Arbeitsweise/stand-04-11-2026.md`, `Befunde/PRUEFER-99.md` und `Intern/WEITERMACHEN.md:3`, nicht `Intern/BEFUNDE.md`. Die höchste vergebene Kennung ist [E-224](../Intern/BEFUNDE.md#e-224); E-225 bis E-231 sind frei.
- `Intern/BEFUNDE.md` nennt PRÜFER-99 nur in [E-193](../Intern/BEFUNDE.md#e-193) (gemessen, `grep -n 'PRÜFER-99' Intern/BEFUNDE.md` → nur Zeile 423), und zwar mit K1, K2 und K4. Es fehlen:
  - **K5** ([PRÜFER-99](PRUEFER-99.md#k5), wichtig): *„Eine IMAP-Mail mit `Subject:` und gleich dem Zeilenumbruch steht in der Liste vermutlich ohne Betreff.“* Die Stelle ist `ImapDownload.cpp:2354-2365` und `:2725-2736`. [E-221](../Intern/BEFUNDE.md#e-221) erwähnt IMAP nicht (gemessen, `grep -c IMAP` auf Zeile 404 → 0).
  - **K3** (gering): Eine lange Suche ohne Treffer lässt sich nicht mit Esc abbrechen. Seit der genauen Suche dauert sie länger.
  - **K6** (gering): [E-220](../Intern/BEFUNDE.md#e-220) nimmt bei einem so gefalteten Betreff nur 63 Zeichen.
- `Intern/WEITERMACHEN.md:3` *„**Vor PR und Release offen:** LEKTOR über die Doku, voller Prüfstandslauf am endgültigen Bau, PRÜFER-99 K5 (E-233) und K3/K6 entscheiden.“* Das Release ist erschienen, entschieden ist nichts davon.
- PRÜFER-99 `:15` und `:172` verlangten für K1 (Umlaut-Suche in IMAP-Postfächern) *„vor dem Release an IMAP messen“*. [E-193](../Intern/BEFUNDE.md#e-193) sagt *„am Quelltext belegt, am IMAP-Prüfstand nicht gemessen“* (`:423`). Gregors Schritt 4 lief *„lokal“* (`Intern/TESTPLAN.md:19`). Die README-Zeile zu [E-193](../Intern/BEFUNDE.md#e-193) (`README.md:207`) sagt nicht, dass der IMAP-Weg ungemessen ausgeliefert ist (gemessen, kein „IMAP“ in der Zeile).

**Vorschlag:** `perl tools/befund-suchen.pl ParseMinimalHeaderInMemory` laufen lassen. Meldet es nichts, vergibt der Hauptagent für K5 die nächste freie Kennung. Den Hinweis „E-232/E-233“ in PRÜFER-99 und WEITERMACHEN mit *„nicht vergeben, siehe …“* berichtigen. K3 in [E-193](../Intern/BEFUNDE.md#e-193) und K6 in [E-220](../Intern/BEFUNDE.md#e-220) als offene Reste führen. In [E-193](../Intern/BEFUNDE.md#e-193) unter „Was noch fehlt“ und in `README.md:207` vermerken: *„in IMAP-Postfächern am Prüfstand nicht gemessen“*.

### <a id="l-150.5"></a>L-150.5 — FAQ 14 und FAQ 20: „ab der nächsten Fassung, noch in keinem Paket“

**Gewicht: gering.** Das ist dasselbe Muster wie [L-142.2](LEKTOR-142.md#l-142.2).

- `Doku/FAQ.md:456` *„Das gilt **ab der nächsten Fassung** (im Quellstand, noch in keinem Paket).“*
- `Doku/FAQ.md:309` *„Eine Ausnahme gilt ab der nächsten Fassung: Bei einer IMAP-Mail, die nie ganz geladen wurde, bleiben die dabei gesammelten Anhangdateien … liegen“*.
- Beides ist [E-188](../Intern/BEFUNDE.md#e-188) „Sicherheit vor Platz“ und steckt in 7.2.2.133. `README.md:175` sagt richtig *„Gilt ab 7.2.2.133“* (gemessen). `doku-pruefen.pl` meldet dazu *„Doku/FAQ.md nennt weder den Quellstand 7.2.2.133 noch die Paketnummer“*.

**Vorschlag:** In beiden Stellen *„ab 7.2.2.133“* schreiben. Im selben Zug [L-149.3](LEKTOR-149.md#l-149.3) einarbeiten, denn es ist derselbe Absatz.

### <a id="l-150.6"></a>L-150.6 — S-3: der Kopf nennt die Messung vom 05.11. nicht; „CAPICOM … siehe E-222“ zeigt ins Leere

**Gewicht: gering.** Es geht um [S-3](../Intern/BEFUNDE.md#s-3)/S-3c: Junk-Filter und S/MIME brauchen zwei Microsoft-DLLs, die das Paket nicht mitbringt.

- `Intern/BEFUNDE.md:228` *„**Zuletzt gemessen: 28.10.2026 an 7.2.0.127**“*. Der Nachtrag `Intern/BEFUNDE.md:3038-3040` sagt aber *„Gemessen am Prüfstand `C:\Temp\E222`: mit `MFC71.DLL` … laden `SMIME.dll` und `SpamHeaders.dll`“* (05.11.2026). An welchem Bau gemessen wurde, steht dort nicht.
- `Intern/BEFUNDE.md:3066-3067` *„… eine signierte Mail aus [E-222](#e-222) verarbeitet (CAPICOM fehlt am Prüfstand, siehe [E-222](../Intern/BEFUNDE.md#e-222))“*. CAPICOM kommt im ganzen Bestand nur an dieser Stelle vor (gemessen, `grep -rn CAPICOM --include=*.md .` → ein Treffer). [E-222](../Intern/BEFUNDE.md#e-222) sagt dazu nichts.

**Vorschlag:** Die Marke `**Zuletzt gemessen: 05.11.2026 an 7.2.2.133**` setzen, wenn der Bau am Prüfstand 7.2.2.133 war; sonst den gemessenen Bau nennen. Den CAPICOM-Satz entweder in [E-222](../Intern/BEFUNDE.md#e-222) belegen (was fehlt, woran gemessen) oder hier ohne „siehe [E-222](../Intern/BEFUNDE.md#e-222)“ stehen lassen.

### <a id="l-150.7"></a>L-150.7 — Links des Release-Textes treffen auf `main` noch nichts

**Gewicht: mittel, behebt sich mit dem Merge.** Das ist dasselbe Muster wie [L-142.6](LEKTOR-142.md#l-142.6) (Marke nicht auf `main`) und `Arbeitsweise/verweis-erst-nach-dem-merge.md`.

Gemessen gegen `origin/main` (`55004ca5`):

- Die Anker `e-220`, `e-221`, `e-222` und `e-223` gibt es in `Intern/BEFUNDE.md` nicht (je 0 Treffer).
- `test-7-2-2-133` fehlt in `Intern/TESTPLAN.md` (0 Treffer).
- Die README-Liste „Bekannte Fehler“ kennt [E-222](../Intern/BEFUNDE.md#e-222) nicht (0 Treffer).
- `Releases/PRUEFBERICHT.md` zeigt noch *„`7.2.2.132` (Paketnummer `7.2.2.132`)“*.

Der Release-Text verlinkt auf genau diese Stellen unter `blob/main/…` (`RELEASE-NOTIZEN.md:28`, `:31`, `:41`, `:43`, `:50`, `:56`, `:59`). Seit 08:36 UTC liest ein Anwender also Links ins Leere oder einen veralteten Prüfbericht.

**Vorschlag:** Den PR bald stellen, mit den Funden dieses Berichts, die `main` betreffen ([L-150.1](#l-150.1), [L-150.3](#l-150.3) in den Dateien, [L-150.5](#l-150.5), [L-150.6](#l-150.6), [L-150.8](#l-150.8) und die drei aus [LEKTOR-149](LEKTOR-149.md#lektor-149)). Für das nächste Release: `release-veroeffentlichen.ps1` weist ab, solange die Marke kein Vorfahr von `origin/main` ist. Andernfalls verlinken die Notizen auf die Marke statt auf `main`.

### <a id="l-150.8"></a>L-150.8 — Kleinkram

**Gewicht: gering.**

- `Releases/PAKETE.md:52` *„(Gregor 04.11.2026, Entscheidung 26; das nächste Paket ist 7.2.2.133)“*. Das nächste ist 7.2.2.134. **Vorschlag:** *„7.2.2.133 ist erschienen, das nächste ist 7.2.2.134“*.
- `Intern/TESTPLAN.md:9` *„(nach deinem Test am 05.11.2026 als `v7.2.2.133` veröffentlicht)“*. Der Test war am **04.**11.2026, so steht es in `:3` und `:29`. **Vorschlag:** *„nach deinem Test am 04.11.2026 am 05.11.2026 …“*.
- `CHANGELOG.md:130` *„Wie schnell die genaue Suche in einem großen Postfach ist, zeigt erst der Test am echten Bestand.“* Der Test hat es gezeigt: `README.md:207` *„an Gregors Postfach am 04.11.2026 132 HTML-Mails in 141–156 ms“*. **Vorschlag:** den Satz durch diesen Messwert ersetzen.
- `Releases/7.2.2.133/RELEASE-NOTIZEN.md:65` *„Die Behebungen kommen mit 7.2.2.134.“* Beim Rest von [E-193](../Intern/BEFUNDE.md#e-193) ist die Ursache offen ([L-150.3](#l-150.3) Punkt 2). **Vorschlag:** in der Datei *„sind in Arbeit für 7.2.2.134“*, wie in `README.md:104`.

Kein Widerspruch, nur zur Kenntnis: `tools/ZWEIGE.md` führt `e223_e222_e193rest` hier noch nicht. Der Eintrag steht auf dem Zweig selbst (`origin/e223_e222_e193rest:tools/ZWEIGE.md:235`, gemessen).

## Hält etwas den PR `paket_7_2_2_133` → `main` auf?

**Nein.** Gemessen: `origin/main` ist Vorfahr von HEAD (30 Commits voraus, keiner zurück), und zwischen dem Paketbau und der Marke hat sich am Code nichts geändert. [L-150.7](#l-150.7) spricht sogar für einen **baldigen** Merge, weil erst er die Links des Release-Textes einlöst. In den PR gehören:

- [L-150.1](#l-150.1), sonst sagt `main` nach dem Merge „kommt mit dem nächsten Paket“ über ein erschienenes Release;
- die Datei-Berichtigungen aus [L-150.2](#l-150.2) und [L-150.3](#l-150.3);
- [L-150.5](#l-150.5), [L-150.8](#l-150.8) und die drei offenen Funde aus [LEKTOR-149](LEKTOR-149.md#lektor-149).

[L-150.4](#l-150.4) (PRÜFER-99 K5 als Befund) und die Schranken aus [L-150.1](#l-150.1), [L-150.2](#l-150.2) und [L-150.7](#l-150.7) können folgen. Sie sollten vor dem nächsten Paket stehen.

## Was nur Gregor entscheiden kann

1. **Den veröffentlichten Release-Text von v7.2.2.133 nachziehen?** Gemeint sind drei Dinge:
   - den Absatz zum Rückstand an Regressionstests ([L-150.2](#l-150.2): 0 von 69 kritischen Befunden ohne jede Prüfung, 50 behobene ohne eigenen Test; laut deiner Entscheidung vom 04.11. gehört er ab diesem Release hinein);
   - die Berichtigung, dass 90 Prüfstandsfälle am Sammelbau liefen ([L-150.3](#l-150.3) Punkt 1);
   - die Einschränkungen „Ursache beim Rest von [E-193](../Intern/BEFUNDE.md#e-193) offen“, „Doppel beim gewöhnlichen Verschieben“ und „Betreff bei IMAP noch nicht“ ([L-150.3](#l-150.3) Punkte 2–4).

   Die ZIP bliebe unverändert. In der Datei im Repo kann der Hauptagent das ohnehin berichtigen. Ob der Text auf GitHub geändert wird, ist eine Release-Frage.
