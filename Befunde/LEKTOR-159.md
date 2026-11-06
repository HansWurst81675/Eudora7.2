# <a id="lektor-159"></a>LEKTOR-159 (06.11.2026) — `main` nach 9af39dc6 (Merge #230): die ganze Doku gegen den Bestand, Einarbeitung von LEKTOR-158

**Umfang:** Gregors Auftrag vom 06.11.2026: *„laß lektor über die ganze doku drüber schauen, ob noch ungültige angaben oder verlinkungen da sind auf dem repo. also ob weitermachen.md stimmt, ob befunde noch gültig sind, prüfbericht aktuell, testplan abgearbeitet? und ob changelog soweit stimmig ist.“* Geprüft habe ich `origin/main` (`9af39dc6`): alle 72 Dateien aus `git ls-files '*.md'` außer `Arbeitsweise/` und `Befunde/`. Dazu kamen die Marken (`git tag`), die Releases auf GitHub (`gh release list`, `gh release view`), die PRs #228 bis #230 (`gh pr view`) und der Stand der Funde aus LEKTOR-158. Gebaut und gestartet habe ich nichts. Die Prüfskripte liegen nur im Scratchpad.

**Datenschutz:** Die Funde L-158.2 und L-158.4 bis L-158.10 sowie alle Pfade in Gregors Benutzerverzeichnis werden im Zweig `ranjit_bereinigt_teil2` bereinigt. Sie stehen hier nur in der Tabelle und nicht noch einmal als Fund. Diese Datei nennt keinen privaten Fundtext.

**Urteil:** Die Verweise sind fast alle in Ordnung. Gemessen habe ich über alle 72 Dateien jeden relativen Link und jeden Anker, dazu die Links auf `github.com/…/blob/main/…`. Kaputt sind nur zwei, beide aus derselben erzeugten Zeile ([L-159.9](#l-159.9)). Der CHANGELOG stimmt mit den Marken, mit `tools/RELEASES.md` und mit den Release-Seiten auf GitHub überein. Was nicht mehr stimmt, sind **Zustandsangaben**:
* Zwei Befunde warten auf einen Merge, der um 16:47 UTC geschehen ist.
* Sechs Befunde sagen „im Quellstand“ oder „kommt mit dem Testpaket 7.2.1.131“, obwohl `v7.2.1.131` seit dem 02.11. veröffentlicht ist.
* Der Kopf von `Releases/PAKETE.md` nennt zwei verschiedene Fassungen als *Latest*, und keine davon ist die heutige.
* Der Abschnitt im CHANGELOG, auf den Neueinsteiger geschickt werden, hat den Stand vom 09.09.2026.
* Sechs Testanleitungen im TESTPLAN lesen sich noch als „auszuführen“, obwohl Gregor sie längst bestätigt hat.

Insgesamt **14 Funde**. Keiner davon betrifft das Programm.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Quellstand 7.2.2.136“*, *„gepruefte Dateien 58“*, *„Kein Widerspruch gefunden.“* Dazu 23 Hinweise *„nennt weder den Quellstand 7.2.2.136 …“*, Altbestand wie bei LEKTOR-158. Darunter steht `Doku/FUNKTIONEN.md` mit *„hoechste genannte Fassung: 7.2.2.132“*, siehe [L-159.8](#l-159.8).
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 63“*, *„davon NIE gemessen 17“*, *„davon veraltet gemessen 31“*, *„63 offene Befunde, in beiden Listen gleich.“*
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“* Kritisch *„OHNE jede Pruefung 1 … [E-243](../Intern/BEFUNDE.md#e-243)“*. Gemeint ist [E-243](../Intern/BEFUNDE.md#e-243), der Prüfstand, der echte Eudora-Ordner treffen konnte. Es ist ein Werkzeugbefund, sein Test ist der Klonlauf. *„behoben und OHNE Testfall 50“*.
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen“*.
* `perl tools/befunde-verlinken.pl` (gemessen): *„262 Kennungen in der Urteilstabelle“*, *„Anker: vollstaendig“*.
* Eigene Prüfungen im Scratchpad (gemessen):
  * Links und Anker in den 72 Dateien: 2 Fehler ([L-159.9](#l-159.9)). Eine Positivprobe mit einer erfundenen Datei und einem erfundenen Anker wurde erkannt.
  * „behoben in 7.2.x.y“ im Urteilskopf gegen den CHANGELOG-Abschnitt derselben Fassung: 48 geprüft, 43 passend. Die fünf Abweichungen sind erklärbar. [E-141](../Intern/BEFUNDE.md#e-141) und [E-179](../Intern/BEFUNDE.md#e-179) (beide berichtigt in 7.2.1.129/130, Urteil nennt das erste Release 7.2.1.131) und [E-223](../Intern/BEFUNDE.md#e-223) („Remember password“, Urteil nennt das Release 7.2.2.136, der CHANGELOG 7.2.2.134) folgen der Regel „behoben im ersten Release“. [E-66](../Intern/BEFUNDE.md#e-66) nennt 7.2.0.36, dafür gibt es keinen eigenen Abschnitt. [E-78](../Intern/BEFUNDE.md#e-78) ist ein Fehltreffer meines Musters.
  * Release-Texte auf GitHub gegen `Releases/<Fassung>/RELEASE-NOTIZEN.md`: 7.2.2.136, 7.2.2.132 und 7.2.1.128 sind gleich (nur die abschließende Leerzeile fehlt). 7.2.2.133 weicht ab, das ist bekannt (`Intern/WEITERMACHEN.md:24`). 7.2.1.131 weicht ab ([L-159.12](#l-159.12)).
  * SHA-256 des ZIPs `v7.2.2.136` auf GitHub (`gh release view --json assets`) = `Releases/PAKETE.md:196` (`12dda7a6…`). Größe 9 179 940 Byte, gleich.

## Funde aus LEKTOR-158 — heutiger Stand

LEKTOR-158 liegt noch nicht auf `main`, sondern im Zweig `ranjit_bereinigt_teil2` (`Befunde/LEKTOR-158.md`). Seit seiner Grundlage `037c361c` haben sich auf `main` nur neun Dateien geändert (gemessen, `git diff --stat 037c361c 9af39dc6`). Die Stellen der übrigen Funde stehen deshalb unverändert.

| Fund | Stand | Stelle (heute, gemessen) |
|---|---|---|
| L-158.1 Freigabepfad der VM in einem Werkzeug | **erledigt** | `tools/testplan-voraussetzungen.pl:33` ist jetzt ein Platzhalter (`e875ee1a`) |
| L-158.2 Austauschordner und Ausstattung | offen auf `main`, in Arbeit in `ranjit_bereinigt_teil2` | Dateien seit `037c361c` unverändert, außer `Intern/BEFUNDE.md` (eine Zeile, [E-243](../Intern/BEFUNDE.md#e-243)) und `Releases/PAKETE.md:324` |
| L-158.3 „bei Gregor gegeben“ | **erledigt** | [E-243](../Intern/BEFUNDE.md#e-243) (`Intern/BEFUNDE.md:406`), Stufe jetzt *„bei Anwendern mit echten Instanzen unter `C:\Temp`“*; `Befunde/PRUEFER-104.md:88` umformuliert (`e875ee1a`) |
| L-158.4 bis L-158.8 | offen auf `main`, in Arbeit in `ranjit_bereinigt_teil2` | Stellen unverändert |
| L-158.9 [E-246](../Intern/BEFUNDE.md#e-246) hinter der Entscheidung | offen, in `ranjit_bereinigt_teil2` | `Intern/BEFUNDE.md:403` weiter *„**Was noch fehlt:** Gregors Entscheidung, ob er beim GitHub-Support …“*. [E-246](../Intern/BEFUNDE.md#e-246) ist der umgeschriebene Commit, den GitHub über seine Kennung noch ausliefert |
| L-158.10 WEITERMACHEN „Wartet auf Merge“ | offen, in `ranjit_bereinigt_teil2` | `Intern/WEITERMACHEN.md:11` *„**Wartet auf Merge:** `e151_pruefstand_klon`“*; #229 ist am 06.11.2026 um 16:47 UTC gemergt (`gh pr view 229`) |

Ältere Funde, die weiter offen sind (gemessen):

| Fund | Stand | Stelle |
|---|---|---|
| [L-155.3](LEKTOR-155.md#l-155.3) Prüfbericht 110/109, Baum nicht sauber | **offen** | `Releases/PRUEFBERICHT.md:6` *„**Arbeitsbaum nicht sauber** (4 Dateien)“*, `:16` *„110 Faelle“*, `:25` *„109 \| 109“*; siehe [L-159.13](#l-159.13) |
| [L-157.4](LEKTOR-157.md#l-157.4) Kommentare kennen die neue Wurzel nicht | **offen** | `tools/pruefstand-einrichten.ps1:1` *„unter C:\Temp“*, `:42` *„Wurzel ist C:\Temp“*; `E-133r` 0-mal in `Doku/PRUEFSTAND.md` und `tools/WERKZEUGE.md` |
| [L-157.5](LEKTOR-157.md#l-157.5) `-Wurzel D:\…` nie gefahren | **teilweise** | `Doku/PRUEFSTAND.md:205` unverändert |
| [L-157.6](LEKTOR-157.md#l-157.6) Zahlen in der Anleitung | **teilweise** | *„60 bis 91“* in `Doku/PRUEFSTAND.md:8`, `:17`, `:30`, `:56`, `:140` und `README.md:112`; `Doku/MITARBEITEN.md:101` *„rund eine Stunde“*. `Doku/PRUEFSTAND.md:214` zeigt *„107 Faelle, 107 bestanden“* als Beispielausgabe, ein solcher Lauf steht in `tools/TESTLAEUFE.md` nicht (letzte Zeile 06.11.2026 17:24) |

## Funde

### <a id="l-159.1"></a>L-159.1 — E-151 und E-243 warten auf den Merge, der geschehen ist

**Gewicht: mittel.** Gemessen. #229 (`e151_pruefstand_klon`) ist am 06.11.2026 um 16:47 UTC gemergt (`gh pr view 229`, `037c361c`).

* [E-151](../Intern/BEFUNDE.md#e-151) (Prüfstand aus einem frischen Klon), `Intern/BEFUNDE.md:454`. Der Kopf sagt *„**offen bis zum Merge von `e151_pruefstand_klon`**“*, „Was noch fehlt“ beginnt mit *„der Merge; …“*. Dort steht auch *„die Schranke `pruefe-feste-pfade.pl` wirkt erst, wenn nach dem Merge `tools/hooks-einrichten.sh` läuft“*. Das ist erledigt: Der `pre-commit` des Hauptrepos ruft `pruefe-feste-pfade` auf (gemessen mit `grep`).
* [E-243](../Intern/BEFUNDE.md#e-243) (Prüfstand konnte echte Eudora-Ordner treffen), `Intern/BEFUNDE.md:406`. Dort steht *„**Offen bleibt es bis zum Merge.**“* und *„**Was noch fehlt:** der Merge von `e151_pruefstand_klon`; …“*.
* Beide Sätze stehen erzeugt auch in `CHANGELOG.md:34` und `Intern/WEITERMACHEN.md:109` ([E-243](../Intern/BEFUNDE.md#e-243)) sowie in der E-151-Zeile beider Tabellen.

**Was offen bleibt, ist richtig benannt.** Bei [E-151](../Intern/BEFUNDE.md#e-151) fehlen der volle Lauf mit 107 Fällen nach der Berichtigung der Pfadfälle (in `tools/TESTLAEUFE.md` gibt es keinen) und Gregors zurückgestellter Lauf auf einem zweiten Rechner. Bei [E-243](../Intern/BEFUNDE.md#e-243) prüfen die Messskripte die Marke nicht selbst.

**Soll:** In beiden Köpfen „bis zum Merge“ durch „gemergt am 06.11.2026 (#229)“ ersetzen. „Der Merge“ und den Satz über die Haken aus „Was noch fehlt“ streichen. Danach `offene-befunde.pl` laufen lassen.

### <a id="l-159.2"></a>L-159.2 — WEITERMACHEN: Merges und Überschrift der Entscheidungen

**Gewicht: gering.** Gemessen. Dieser Fund ergänzt L-158.10, wiederholt ihn aber nicht.

* `Intern/WEITERMACHEN.md:10` *„**Gemergt am 06.11.2026:** #228 (`paket_7_2_2_136`, Release-Stand 7.2.2.136).“* #229 (16:47 UTC) und #230 (`ranjit_bereinigt_teil1`, 17:22 UTC) fehlen (`gh pr view`).
* `:174` *„Gregors Entscheidungen vom 25. bis 29.10.2026, nummeriert …“*. Die Liste reicht bis Entscheidung 39 vom 06.11.2026.

**Soll:** Zeile 10 um #229 und #230 ergänzen. In `:174` „vom 25.10.2026 an“ schreiben.

### <a id="l-159.3"></a>L-159.3 — Sechs offene Befunde sind seit dem 02.11. ausgeliefert, ihr Kopf sagt „im Quellstand“

**Gewicht: mittel.** Gemessen. `v7.2.1.131` ist am 02.11.2026 veröffentlicht (`gh release list`). Laut `CHANGELOG.md:235` enthält es *„[E-177](../Intern/BEFUNDE.md#e-177), [E-143](../Intern/BEFUNDE.md#e-143) (Suchfenster), [E-122](../Intern/BEFUNDE.md#e-122), [E-184](../Intern/BEFUNDE.md#e-184), [E-189](../Intern/BEFUNDE.md#e-189) im Quelltext berichtigt“*, dazu aus den Testpaketen 7.2.1.129 und 7.2.1.130 [E-178](../Intern/BEFUNDE.md#e-178) und [E-136](../Intern/BEFUNDE.md#e-136) (Strg-S).

| Befund | Was passiert | Kopf heute |
|---|---|---|
| [E-189](../Intern/BEFUNDE.md#e-189) `:435` | Verschieben im IMAP-Konto ohne UIDPLUS, die Mail steht unter falscher Nummer | *„Behebung im Quellstand … **kommt mit dem Testpaket 7.2.1.131**“* |
| [E-184](../Intern/BEFUNDE.md#e-184) `:437` | Zusammenfassung einer fremden Mail nach dem Verschieben | ebenso, zweimal *„kommt mit dem Testpaket 7.2.1.131“* |
| [E-177](../Intern/BEFUNDE.md#e-177) `:440` | falsche Zeichensatzangabe für „an Programm übergeben“ | *„im Quellstand behoben … kommt mit dem Testpaket 7.2.1.131“* |
| [E-143](../Intern/BEFUNDE.md#e-143) `:396` | Out-Hinweis je Treffer aus Suche und Filter | *„Filterteil im Quellstand berichtigt“*, *„(kommt mit dem Testpaket 7.2.1.131)“* |
| [E-178](../Intern/BEFUNDE.md#e-178) `:439` | Emoji bei Link und Festbreite im Bearbeiten-Modus | *„behoben im Quellstand (01.11.2026)“* |
| [E-136](../Intern/BEFUNDE.md#e-136) `:464` | Zeichen gehen beim Speichern verloren | *„Behebung im Quellstand (31.10.2026), in 7.2.1.129“*, ohne das Release |

Offen sind sie zu Recht, wegen ihrer Reste. Der Kopf verschweigt aber, dass der Hauptteil seit vier Tagen beim Anwender ist. Die Schranke „Zuerst (dritte Wiederholung)“ in `Intern/WEITERMACHEN.md:56` soll genau dieses Muster fangen, ist aber noch nicht gebaut. Sie ist außerdem nur für *„kommt mit dem (Test)paket 7.2.2.N“* beschrieben. Diese sechs Fälle stehen in der Reihe 7.2.1.

**Soll:** „ausgeliefert in 7.2.1.131 (Release vom 02.11.2026)“ in jeden der sechs Köpfe, so wie es [E-222](../Intern/BEFUNDE.md#e-222) und [E-193](../Intern/BEFUNDE.md#e-193) schon tun. Die geplante Schranke für jede veröffentlichte Marke `v7.2.*` beschreiben, nicht nur für 7.2.2.N.

### <a id="l-159.4"></a>L-159.4 — Releases/PAKETE.md: der Kopf nennt 7.2.2.133 und 1.0.120 als *Latest*

**Gewicht: mittel.** Gemessen. *Latest* ist laut `gh release list` `v7.2.2.136`.

* `Releases/PAKETE.md:6` *„Nummern bis 7.2.2.133 verzeichnet, 7.2.2.136 am 06.11.2026 als `v7.2.2.136` veröffentlicht …“*. Weiter: *„veröffentlicht als `v7.2.2.133` … auf GitHub *Latest*); veröffentlicht zuletzt also 7.2.2.133“*. Derselbe Absatz widerspricht sich also, und Abschnitte für 7.2.2.134 bis 7.2.2.136 gibt es längst (`:187`, `:203`, `:219`).
* `:20` *„veröffentlicht ist inzwischen **`v1.0.120`** (21.10.2026 …, **auf GitHub als *Latest***, nachgemessen am 23.10.2026 …)“*.

Die Datei sagt selbst, dass aus dieser Liste die nächste Nummer abgeleitet wird (`:6`, *„die Quelle, aus der die Nummer kommt“*).

**Soll:** In `:6` „verzeichnet bis 7.2.2.136; veröffentlicht zuletzt 7.2.2.136 (*Latest*)“ schreiben. 7.2.2.133 bekommt „*Latest* bis zum 06.11.2026“. In `:20` „damals *Latest*“ schreiben. Am besten den Satz über die letzte Veröffentlichung an einer Stelle führen und von hier verlinken.

### <a id="l-159.5"></a>L-159.5 — CHANGELOG „Wo man weitermachen kann“: Stand 09.09.2026, und der Kopf schickt Neueinsteiger dorthin

**Gewicht: mittel.** Belegt.

* `CHANGELOG.md:11-14` *„**Wer hier neu einsteigt:** … Der Abschnitt **Wo man weitermachen kann** ganz unten nennt die offenen Enden mit Fundstelle.“*
* `:6422-6425` *„## Wo man weitermachen kann … **Stand 09.09.2026.**“*. Was dort steht, ist überholt:
  * `:6486` sagt, [E-50](../Intern/BEFUNDE.md#e-50) sei *„**noch nicht** von ihm beurteilt“*. [E-50](../Intern/BEFUNDE.md#e-50) (`Intern/BEFUNDE.md:314`) ist aber *„von Gregor an 1.0.84 bestätigt am 13.10.2026“*.
  * `:6505` sagt über die Meldung „improper argument“, sie sei *„**neu zu messen**“*. Kriterium 2 ist laut `CHANGELOG.md:102` und `ZIEL.md` erfüllt (an 7.2.0.123 kam die Meldung nicht).
  * `:6521` nennt *„`AGENTEN.md`“* ohne Pfad. Die Datei liegt unter `Intern/AGENTEN.md`, im Wurzelverzeichnis gibt es sie nicht.
* `Intern/WEITERMACHEN.md:37-38` legt fest: *„**Was zu tun ist, steht an genau einer Stelle:** in der Liste [Nach dem Release 7.2.1]“*. Der CHANGELOG-Abschnitt ist eine zweite, veraltete Stelle.

**Soll:** Den Abschnitt in „Wie es bis 09.09.2026 weiterging (Archiv)“ umbenennen oder nach `Intern/WEITERMACHEN-bis-7.2.0.md` verschieben. `:11-14` verweist dann auf [WEITERMACHEN, Nach dem Release](../Intern/WEITERMACHEN.md#nach-dem-release) und auf die Tabelle „Noch offen“ darüber.

### <a id="l-159.6"></a>L-159.6 — TESTPLAN: sechs Anleitungen ohne Ergebnis, obwohl Gregor sie bestätigt hat

**Gewicht: gering.** Gemessen. Gezählt habe ich je Abschnitt die Wörter „Ergebnis“, „bestanden“ und „bestätigt“. Die Urteile stehen in `Intern/BEFUNDE.md`.

| Abschnitt | Überschrift heute | Stand laut BEFUNDE.md |
|---|---|---|
| `Intern/TESTPLAN.md:648` | *„Mit 7.2.2.132: Help → Keyboard Shortcuts …“*, *„**Erst mit dem Paket 7.2.2.132 auszuführen**“* | [A-5](../Intern/BEFUNDE.md#a-5) *„von Gregor am 03.11.2026 an 7.2.2.132 bestätigt“* |
| `:687` | *„Mit 7.2.2.132: Speichern unter schlägt die passende Endung vor“* | [E-128](../Intern/BEFUNDE.md#e-128) Endung von Gregor am 03.11.2026 gesehen, Rest offen |
| `:711` | *„Mit 7.2.2.132: About-Dialog“* | [E-216](../Intern/BEFUNDE.md#e-216) *„von Gregor am 03.11.2026 an 7.2.2.132 bestätigt“* |
| `:734` | *„Im nächsten Paket nach 7.2.2.132: Find Messages mit Umlauten und €“* | [E-193](../Intern/BEFUNDE.md#e-193) an 7.2.2.135 bestätigt, ausgeliefert in 7.2.2.136 |
| `:758` | *„Im nächsten Paket nach 7.2.2.132: Speichern unter schlägt einen speicherbaren Namen vor“* | [E-220](../Intern/BEFUNDE.md#e-220) behoben in 7.2.2.133 |
| `:772` | *„In 7.2.1.129: Suche aus dem Rechtsklickmenü ohne Markierung“* | [E-171](../Intern/BEFUNDE.md#e-171) *„an 7.2.1.130 bei Gregor bestätigt (01.11.2026)“* |

`:561` zeigt, wie es geht: *„Erledigt am 03.11.2026: das Label bleibt …“*. Gregor liest den Testplan als Arbeitsliste (`Arbeitsweise/nur-testplan-zaehlt.md`). Wer ihn so liest, hält diese sechs für offen.

**Soll:** Jede Überschrift wie in `:561` mit „Erledigt am …“ beginnen und eine Zeile „Ergebnis“ mit Verweis auf das Urteil anfügen. Die Anweisung „Erst mit dem Paket … auszuführen“ als „damals“ kennzeichnen.

### <a id="l-159.7"></a>L-159.7 — „Kriterium 0 nie auf einem Rechner ohne Visual Studio gemessen“ widerspricht ZIEL.md

**Gewicht: gering.** Belegt.

* `Intern/WEITERMACHEN.md:76` *„Kriterium 0 (das Paket läuft ohne Nachinstallieren) auf einem Rechner ohne Visual Studio \| nie auf einem solchen Rechner gemessen“*.
* `ZIEL.md:277` *„**erfüllt** — Gregor hat `Eudora72-1.0.10-release.zip` am 06.09.2026 auf einem Rechner **ohne Visual Studio** ausgepackt und gestartet“*. Ebenso `CHANGELOG.md:101`.

Gemeint ist wohl: an keiner Fassung der Reihe 7.2.1 oder 7.2.2 gemessen (Vermutung). So, wie der Satz dasteht, ist er falsch.

**Soll:** „zuletzt am 06.09.2026 an 1.0.10 gemessen, an keiner Fassung seit 7.2.1“.

### <a id="l-159.8"></a>L-159.8 — Doku/FUNKTIONEN.md: Stand 7.2.2.132, Druckvorschau mit dem alten Fehler

**Gewicht: gering.** Gemessen.

* `Doku/FUNKTIONEN.md:19` *„**Stand:** Release 7.2.2.132 (03.11.2026).“* Das widerspricht `:971`: Dort steht schon `PrintBackground` aus 7.2.2.136.
* `:91` *Print Preview*: *„Druckvorschau ([E-169](…), *manche HTML-Mails ohne Bilder in der Vorschau*)“*. Seit 7.2.2.136 ist das schaltbar. `README.md:200` sagt *„**behoben in 7.2.2.136**“*.

**Soll:** Den Stand auf 7.2.2.136 setzen. In `:91` schreiben: „Hintergründe nur mit `PrintBackground=1`, seit 7.2.2.136“, mit Verweis auf `:971`.

### <a id="l-159.9"></a>L-159.9 — Der einzige tote Anker der Doku: `#e-203` in den beiden erzeugten Tabellen

**Gewicht: gering.** Gemessen (Linkprüfung über 72 Dateien, 2 Fehler).

* `CHANGELOG.md:80` und `Intern/WEITERMACHEN.md:155`, Zeile [E-39](../Intern/BEFUNDE.md#e-39) (Rest einer gelöschten Persönlichkeit in der `Eudora.ini`): *„seit der Behebung von [E-203](#e-203)“*. In BEFUNDE.md trifft der relative Anker. In den beiden Tabellen, in die `offene-befunde.pl` den Text kopiert, zeigt er ins Leere.

**Soll:** `offene-befunde.pl` schreibt beim Kopieren `](#` zu `](BEFUNDE.md#` bzw. `](Intern/BEFUNDE.md#` um. Heute betrifft das nur [E-39](../Intern/BEFUNDE.md#e-39). Beim nächsten Befund mit relativem Verweis in „Was noch fehlt“ entsteht derselbe Fehler wieder.

Die Berichte unter `Befunde/` habe ich nur gezählt: 95 Treffer in 281 Dateien, die meisten sind zitierte Links in *„…“*. Kein Fund.

### <a id="l-159.10"></a>L-159.10 — E-222 sagt zugleich „Gregors Test steht aus“ und „von Gregor bestätigt“

**Gewicht: gering.** Belegt. [E-222](../Intern/BEFUNDE.md#e-222) (Klick auf eine S/MIME-signierte Mail meldet „Plugin no longer available“), `Intern/BEFUNDE.md:400`:

* *„Gregors Test an einer signierten Mail steht aus.“*
* *„Schritt 4 im Testplan an 7.2.2.134 ist offen“*
* weiter hinten: *„**Von Gregor am 05.11.2026 an 7.2.2.135 bestätigt**“*, und der Kopf sagt *„von Gregor am 05.11.2026 an 7.2.2.135 bestätigt“*.

Die ersten beiden Sätze sind von der Bestätigung überholt. Offen ist nur der Rest mit dem Kopftext.

**Soll:** Beide Sätze als „damals“ kennzeichnen oder streichen. Das geschieht am besten zusammen mit der Bereinigung von L-158.2 in derselben Zeile.

### <a id="l-159.11"></a>L-159.11 — „nach“ oder „vor 7.2.1“ in offenen Befunden, vier Wochen nach dem Release 7.2.1

**Gewicht: gering.** Gemessen. `v7.2.1.128` ist seit dem 29.10.2026 veröffentlicht.

* [E-173](../Intern/BEFUNDE.md#e-173) (Labels im Filterfenster ausgegraut), `Intern/BEFUNDE.md:442`: *„**Was noch fehlt:** erst **nach dem Release 7.2.1** — nachstellen …“*. Erzeugt auch in `CHANGELOG.md` und `Intern/WEITERMACHEN.md`.
* [E-142](../Intern/BEFUNDE.md#e-142) (Entwurf aus IMAP ergibt in Out eine leere Nachricht), `:395`: *„**Was noch fehlt:** vor 7.2.1 nichts — Gregors Entscheidung 13“*. Damit ist nicht gesagt, was jetzt fehlt.
* [E-147](../Intern/BEFUNDE.md#e-147) (Reparatur zerstörter Umlaute aus EudoraUnicodeFix übernehmen), `:397`: *„Rays Antwort im Issue #102, ob er die Veröffentlichung möchte; danach (nach 7.2.1) …“*. Gemessen: Issue #102 ist **geschlossen**, der letzte Kommentar stammt vom 25.10.2026 und vom Besitzer des Repos (`gh issue view 102`). Auf eine Antwort in einem geschlossenen Issue zu warten, ist kein Plan.
* [E-71](../Intern/BEFUNDE.md#e-71) (Filterbericht nach einem Filterlauf leer), `:335`: *„Gregors Freigabe — er hat ihn ausdrücklich auf die nächste Fassung geschoben“*. Zuletzt gemessen am 22.10.2026. Seitdem sind sechs Releases erschienen.
* `README.md:170` *„Was zur Fassung 7.2.1 noch fehlt, steht erzeugt ganz oben in ZIEL.md“*. `ziel-stand.pl` meldet 27 von 27 erfüllt.

**Soll:** Jeweils sagen, was heute fehlt: [E-173](../Intern/BEFUNDE.md#e-173) nachstellen, [E-142](../Intern/BEFUNDE.md#e-142) „zurückgestellt nach Entscheidung 13“. [E-147](../Intern/BEFUNDE.md#e-147) und [E-71](../Intern/BEFUNDE.md#e-71) sind Fragen an Gregor ([unten](#gregor)). In README:170 „Was zur Fassung 7.2.1 gefehlt hat …“ oder streichen.

### <a id="l-159.12"></a>L-159.12 — Der Release-Text `v7.2.1.131` auf GitHub kennt den Nachtrag vom 03.11. nicht

**Gewicht: gering.** Gemessen (`gh release view v7.2.1.131 --json body` gegen die Datei).

* `Releases/7.2.1.131/RELEASE-NOTIZEN.md:41-47` (Label beim Verschieben im IMAP-Konto, [E-170](../Intern/BEFUNDE.md#e-170)): In der Datei steht *„bleibt das Label meistens erhalten“*, dazu die Bedingung `LogLevel` und *„am 29.10.2026 einmal verloren, die Ursache ist offen (Nachtrag 03.11.2026)“*. Auf GitHub steht noch *„bleibt das Label erhalten“*, ohne Einschränkung.
* `:144` sagt nur, dass die Stellen „Nachtrag 02.11.2026“ auch auf GitHub stehen. Das stimmt (gemessen), der Nachtrag vom 03.11. fehlt aber dort.

Beim Anwender ist also die Aussage „Label bleibt“ angekommen, die die Datei inzwischen einschränkt. Für `v7.2.2.133` ist derselbe Fall bekannt und als Frage an Gregor geführt (`Intern/WEITERMACHEN.md:24`). Für 7.2.1.131 steht er nirgends.

**Soll:** Den Release-Text nachziehen, wenn Gregor zustimmt ([unten](#gregor)). Bis dahin in `:144` vermerken, dass der Nachtrag vom 03.11. nur in der Datei steht. In WEITERMACHEN neben 7.2.2.133 aufnehmen.

### <a id="l-159.13"></a>L-159.13 — Prüfbericht: gilt für den Release-Bau 7.2.2.136, kennt die Fälle seit #229 nicht

**Gewicht: gering.** Gemessen.

* `Releases/PRUEFBERICHT.md:5-6` *„Quellstand `7.2.2.136`“*, *„Commit `adf559dc` — **Arbeitsbaum nicht sauber** (4 Dateien)“*, erstellt am 06.11.2026 um 13:12. Die Marke `f99a3b41` ist Vorfahre von `adf559dc` (gemessen). Unter `Eudora71/` unterscheiden sich Marke und `main` nur in `Eudora71/Tests/TestE239.cpp`. Für die Fassung 7.2.2.136 ist der Bericht also **aktuell**.
* Der Fall `E-133r` (seit #229) steht 0-mal im Bericht. `tools/pruefstand-faelle.txt` hat 110 Zeilen ohne Kommentar, der Bericht 109 Prüfstandsfälle (`:25`). Die Fehlzahl 110/109 und der unsaubere Baum sind [L-155.3](LEKTOR-155.md#l-155.3), seit drei Berichten offen.

**Soll:** Beim nächsten Paket den Bericht aus einem sauberen Stand erzeugen. Das fordert auch [E-151](../Intern/BEFUNDE.md#e-151) selbst. Bis dahin gehört in den Kopf ein Satz: „Stand Release 7.2.2.136; Fälle, die nach dem Release dazukamen (E-133r), sind nicht enthalten.“

### <a id="l-159.14"></a>L-159.14 — Vier Programmbefunde „behoben“ ohne Fassung, einer davon kritisch und „ungeprüft“

**Gewicht: gering.** Gemessen (Urteilskopf beginnt mit „behoben“ und enthält keine Fassungsnummer). Werkzeugbefunde habe ich ausgelassen.

* `Intern/BEFUNDE.md:229` [S-4](../Intern/BEFUNDE.md#s-4) (Zusicherung im Adressbuch): *„**behoben** **Stufe: unkritisch**“*
* `:230` [S-5](../Intern/BEFUNDE.md#s-5) (Menüs klappen nicht auf): *„**behoben**, am laufenden Programm gemessen …“*
* `:248` [Z-2](../Intern/BEFUNDE.md#z-2) (ausgehende Mail ohne Zeichensatzangabe): *„**behoben**, an der Zwischendatei belegt …“*
* `:249` [Z-2b](../Intern/BEFUNDE.md#z-2b) (Zeichen an der Stückgrenze zerrissen): *„**behoben, ungeprüft** … **Stufe: kritisch**“*

Dazu `:261` [X-3](../Intern/BEFUNDE.md#x-3): *„**behoben** — die **neun Zeigerstellen** sind offen und brauchen einen Bau“*. Ein Urteil, das „behoben“ und „offen“ zugleich sagt. `Intern/WEITERMACHEN.md:79` führt die neun Zeigerstellen als alten Punkt.

**Soll:** Die Fassung aus dem CHANGELOG nachtragen (alle vier stammen aus der Zeit bis 7.2.0.3x). Für [Z-2b](../Intern/BEFUNDE.md#z-2b) entscheiden: Entweder gibt es einen Test, dann „behoben in …, Test …“, oder das Urteil lautet „offen, nie gemessen“. [X-3](../Intern/BEFUNDE.md#x-3) als „teilweise“ führen.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

1. **Release-Text `v7.2.1.131` auf GitHub nachziehen?** Auf GitHub steht, dass das Label beim Verschieben im IMAP-Konto erhalten bleibt. Die Datei sagt seit dem 03.11. „meistens“ und nennt einen ungeklärten Verlust ([L-159.12](#l-159.12)). Das ZIP bleibt unverändert. Für `v7.2.2.133` liegt dieselbe Frage schon bei ihm.
2. **[E-147](../Intern/BEFUNDE.md#e-147), Reparatur aus EudoraUnicodeFix übernehmen:** Issue #102 ist geschlossen, Rays Antwort zur Veröffentlichung kam seit dem 25.10. nicht. Nachfragen, ohne seine Zustimmung nur die eigene Reparatur bauen, oder ruhen lassen ([L-159.11](#l-159.11))?
3. **[E-71](../Intern/BEFUNDE.md#e-71), leerer Filterbericht:** Gregor hatte ihn „auf die nächste Fassung“ geschoben, seither kamen sechs Releases. Soll er in 7.2.2.137 mit hinein oder bleibt er zurückgestellt?
