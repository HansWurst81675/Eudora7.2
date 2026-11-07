# <a id="lektor-160"></a>LEKTOR-160 (07.11.2026) — Zweig `paket_7_2_2_137` nach 38c614c3: Doku vor dem Test-ZIP 7.2.2.137, Einarbeitung von LEKTOR-159

**Umfang:** geprüft habe ich `origin/paket_7_2_2_137` (`38c614c3`). Der Arbeitsbaum wurde zuerst mit `tools/arbeitsbaum-angleichen.sh` auf diesen Stand vorgespult (2 Commits). Seit `1cb9087d` (Merge #231) sind neun Commits dazugekommen, geändert sind 20 MD-Dateien (`git diff --stat 1cb9087d HEAD -- '*.md'`). Die Schwerpunkte waren [E-71](../Intern/BEFUNDE.md#e-71) (leerer Filterbericht), [E-242](../Intern/BEFUNDE.md#e-242) (Pfad der Zwischendatei auf Ausdruck und Vorschau), [E-240](../Intern/BEFUNDE.md#e-240) (Druckvorschau ohne Rückmeldung), der Nachtrag zu [E-129](../Intern/BEFUNDE.md#e-129) (Postfachverzeichnis nach Übertragung in einen IMAP-Ordner unvollständig), `tools/ZWEIGE.md`, der CHANGELOG-Abschnitt 7.2.2.137 und der TESTPLAN-Entwurf. Den übrigen Bestand der 72 Dateien aus `git ls-files '*.md'` (ohne `Arbeitsweise/` und `Befunde/`) habe ich gegen die Funde von [LEKTOR-159](LEKTOR-159.md#lektor-159) gehalten. Gebaut und gestartet habe ich nichts.

**Urteil:** Die neuen Texte zu [E-71](../Intern/BEFUNDE.md#e-71), [E-242](../Intern/BEFUNDE.md#e-242) und [E-240](../Intern/BEFUNDE.md#e-240) sind in der Sache richtig und stimmen untereinander. Die Spurmarken, die der Testplan nennt, stehen so im Code. `LogLevel=58527` enthält ihren Kanal. **Nichts davon hält das Test-ZIP auf.** Vier Stellen sollten aber mit dem Commit zum Schnüren berichtigt werden:
* Der Kopf des TESTPLAN sagt „kein neuer Testabschnitt“, direkt darunter steht der neue ([L-160.1](#l-160.1)).
* Der CHANGELOG nennt [E-242](../Intern/BEFUNDE.md#e-242) „Originalfehler“, gemessen ist nur der Quelltext ([L-160.2](#l-160.2)). Daraus wird sonst der Release-Text.
* [E-242](../Intern/BEFUNDE.md#e-242) und [E-240](../Intern/BEFUNDE.md#e-240) stehen in beiden erzeugten Tabellen als „nie gemessen“ ([L-160.3](#l-160.3)).
* `Intern/FILTER.md` führt [E-71](../Intern/BEFUNDE.md#e-71) zweimal als offen und zurückgestellt ([L-160.4](#l-160.4)).

Von den 14 Funden aus [LEKTOR-159](LEKTOR-159.md#lektor-159) ist keiner ganz erledigt, drei sind es teilweise. Sie stehen nicht auf dem Weg zum Test-ZIP. **10 neue Funde**, keiner betrifft das Verhalten des Programms.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): *„Quellstand 7.2.2.136“*, *„gepruefte Dateien 58“*, *„Kein Widerspruch gefunden.“* Dazu dieselben 23 Hinweise *„nennt weder den Quellstand …“* wie in [LEKTOR-159](LEKTOR-159.md#lektor-159). Der Quellstand 7.2.2.136 ist richtig: Die Nummer 137 wird erst beim Schnüren vergeben (`CHANGELOG.md:126`).
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 61“*, *„davon NIE gemessen 16“*, *„davon veraltet gemessen 30“*, *„61 offene Befunde, in beiden Listen gleich.“* Gegenüber [LEKTOR-159](LEKTOR-159.md#lektor-159) (63) sind es zwei weniger. Unter den 16 „nie gemessen“ stehen [E-242](../Intern/BEFUNDE.md#e-242) und [E-240](../Intern/BEFUNDE.md#e-240), obwohl beide am 07.11. gemessen sind ([L-160.3](#l-160.3)).
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“*, kritisch *„OHNE jede Pruefung 1 … [E-243](../Intern/BEFUNDE.md#e-243)“* (unverändert), *„behoben und OHNE Testfall 50“*.
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen“*.
* `perl tools/testplan-voraussetzungen.pl` (gemessen): *„frei: jede Voraussetzung der Messskripte steht im Testabschnitt.“* (Abschnitt 7.2.2.137).
* Eigene Zählungen (gemessen): `tools/pruefstand-faelle.txt` hat jetzt **114** Fallzeilen (`grep -c '^[A-Z][^ #|]* |'`), bei `1cb9087d` waren es 110. Neu sind `E-71n`, `E-71r`, `E-242p` und `E-242r`. Ihre Vorlagen `Testdaten/pruefstand/E118`, `E71` und `E169` sind vorhanden. Die Klon-Lücke aus [L-156.1](LEKTOR-156.md#l-156.1) (Fälle ohne Vorlage werden still übersprungen) entsteht hier also nicht wieder.
* Spurmarken gegen Testplan (gemessen): `E-240 …` und `E-242 …` schreibt `TridentView.cpp:2395-2611` über `DEBUG_MASK_MISC` (`0x8000`, `QCUtils/public/inc/debug.h:36`). `58527` = `0xE49F` enthält `0x8000`. Die Angabe in `Intern/TESTPLAN.md:28` (*„`LogLevel=58527` wie bisher genügt“*) stimmt.

## Funde aus LEKTOR-159 — heutiger Stand

| Fund | Stand | Stelle (heute, gemessen) |
|---|---|---|
| [L-159.1](LEKTOR-159.md#l-159.1) [E-151](../Intern/BEFUNDE.md#e-151)/[E-243](../Intern/BEFUNDE.md#e-243) warten auf den Merge von #229 | **offen** | `Intern/BEFUNDE.md:454` [E-151](../Intern/BEFUNDE.md#e-151) (Prüfstand aus dem Klon) *„**offen bis zum Merge von `e15…`“*; `:406` [E-243](../Intern/BEFUNDE.md#e-243) (Prüfstand konnte echte Eudora-Ordner treffen); erzeugt in `CHANGELOG.md:33` und `Intern/WEITERMACHEN.md:109` *„der Merge von `e151_pruefstand_klon`; …“* |
| [L-159.2](LEKTOR-159.md#l-159.2) WEITERMACHEN: Merges, Überschrift der Entscheidungen | **teilweise** | erledigt: `Intern/WEITERMACHEN.md:10-15` nennt #228 bis #231. Offen: `:173` *„Gregors Entscheidungen vom 25. bis 29.10.2026“*, die Liste reicht bis Entscheidung 40 vom 07.11.2026 (`:218`) |
| [L-159.3](LEKTOR-159.md#l-159.3) sechs Befunde „im Quellstand“, ausgeliefert in 7.2.1.131 | **offen** | `Intern/BEFUNDE.md:435` [E-189](../Intern/BEFUNDE.md#e-189) (Verschieben ohne UIDPLUS), `:437` [E-184](../Intern/BEFUNDE.md#e-184) (fremde Zusammenfassung nach dem Verschieben), `:440` [E-177](../Intern/BEFUNDE.md#e-177) (falsche Zeichensatzangabe an ein Programm) weiter *„kommt mit dem Testpaket 7.2.1.131“*; `:396` [E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis), `:439` [E-178](../Intern/BEFUNDE.md#e-178) (Emoji bei Link und Festbreite), `:464` [E-136](../Intern/BEFUNDE.md#e-136) (Zeichenverlust beim Speichern) weiter *„im Quellstand“* |
| [L-159.4](LEKTOR-159.md#l-159.4) PAKETE-Kopf: 7.2.2.133 und 1.0.120 als *Latest* | **offen** | `Releases/PAKETE.md:6` *„veröffentlicht zuletzt also 7.2.2.133“* (im selben Absatz jetzt *„7.2.2.137 in Arbeit“*); `:20` *„**auf GitHub als *Latest***“* zu `v1.0.120` |
| [L-159.5](LEKTOR-159.md#l-159.5) CHANGELOG „Wo man weitermachen kann“, Stand 09.09. | **offen** | `CHANGELOG.md:13` verweist dorthin; `:6428` Überschrift, `:6431` *„**Stand 09.09.2026.**“* |
| [L-159.6](LEKTOR-159.md#l-159.6) sechs Testplan-Abschnitte ohne Ergebnis | **offen** | `Intern/TESTPLAN.md:673`, `:712`, `:736`, `:759`, `:783`, `:797`, Überschriften unverändert (um 25 Zeilen verschoben) |
| [L-159.7](LEKTOR-159.md#l-159.7) Kriterium 0 „nie gemessen“ gegen ZIEL.md | **offen** | `Intern/WEITERMACHEN.md:77` *„nie auf einem solchen Rechner gemessen“* |
| [L-159.8](LEKTOR-159.md#l-159.8) FUNKTIONEN.md Stand 7.2.2.132 | **offen** | `Doku/FUNKTIONEN.md:19` *„**Stand:** Release 7.2.2.132“*, `:91` *„manche HTML-Mails ohne Bilder in der Vorschau“*. Mit 7.2.2.137 wäre in derselben Zeile auch die Kopf- und Fußzeile ([E-242](../Intern/BEFUNDE.md#e-242)) nachzutragen |
| [L-159.9](LEKTOR-159.md#l-159.9) toter Anker `#e-203` | **offen** | `CHANGELOG.md:78` und `Intern/WEITERMACHEN.md:154` (Zeile [E-39](../Intern/BEFUNDE.md#e-39), Rest einer gelöschten Persönlichkeit in der INI) |
| [L-159.10](LEKTOR-159.md#l-159.10) [E-222](../Intern/BEFUNDE.md#e-222) „Test steht aus“ neben „bestätigt“ | **offen** | `Intern/BEFUNDE.md:400` [E-222](../Intern/BEFUNDE.md#e-222) (S/MIME-Mail meldet „Plugin no longer available“): *„Gregors Test an einer signierten Mail steht aus“*, *„Schritt 4 im Testplan an 7.2.2.134 ist offen“* |
| [L-159.11](LEKTOR-159.md#l-159.11) „nach/vor 7.2.1“ in offenen Befunden | **teilweise** | erledigt: [E-71](../Intern/BEFUNDE.md#e-71) (durch die Doku, Entscheidung 40). Teilweise: `:397` [E-147](../Intern/BEFUNDE.md#e-147) (Umlaut-Reparatur aus EudoraUnicodeFix) nennt jetzt *„Gregors Entscheidung, ob ohne diese Antwort gebaut wird“*, aber weiter *„danach (nach 7.2.1)“*. Offen: `:442` [E-173](../Intern/BEFUNDE.md#e-173) (Labels im Filterfenster ausgegraut) *„nach dem Release 7.2.1“*, `:395` [E-142](../Intern/BEFUNDE.md#e-142) (Entwurf aus IMAP leer in Out) *„vor 7.2.1 nichts“*, `README.md:170` *„Was zur Fassung 7.2.1 noch fehlt“* |
| [L-159.12](LEKTOR-159.md#l-159.12) GitHub-Text `v7.2.1.131` ohne Nachtrag 03.11. | **offen** | `Releases/7.2.1.131/RELEASE-NOTIZEN.md:144` unverändert; in `Intern/WEITERMACHEN.md:23-25` (*„Offen für Gregor“*) steht weiter nur `v7.2.2.133` |
| [L-159.13](LEKTOR-159.md#l-159.13) Prüfbericht ohne E-133r | **offen**, wird beim Schnüren neu erzeugt | `Releases/PRUEFBERICHT.md:5-6` *„`7.2.2.136`“*, *„**Arbeitsbaum nicht sauber** (4 Dateien)“*. Mit 7.2.2.137 kommen vier Fälle dazu ([L-160.5](#l-160.5)) |
| [L-159.14](LEKTOR-159.md#l-159.14) „behoben“ ohne Fassung ([S-4](../Intern/BEFUNDE.md#s-4), [S-5](../Intern/BEFUNDE.md#s-5), [Z-2](../Intern/BEFUNDE.md#z-2), [Z-2b](../Intern/BEFUNDE.md#z-2b), [X-3](../Intern/BEFUNDE.md#x-3)) | **offen** | `Intern/BEFUNDE.md:229`, `:230`, `:248`, `:249` (*„**behoben, ungeprüft** … **Stufe: kritisch**“*), `:261` |

Ältere Funde (gemessen): [L-155.3](LEKTOR-155.md#l-155.3) (Prüfbericht 110/109, Baum nicht sauber) ist **offen** wie [L-159.13](LEKTOR-159.md#l-159.13). [L-157.4](LEKTOR-157.md#l-157.4) (Kommentare kennen die neue Wurzel nicht) ist **teilweise** erledigt. *„Wurzel ist C:\Temp“* steht nicht mehr in `tools/pruefstand-einrichten.ps1`, aber `:1` sagt weiter *„die Pruefverzeichnisse unter C:\Temp“*, und `E-133r` steht 0-mal in `Doku/PRUEFSTAND.md` und in `tools/WERKZEUGE.md`. [L-157.5](LEKTOR-157.md#l-157.5) (`-Wurzel D:\…` nie gefahren) und [L-157.6](LEKTOR-157.md#l-157.6) (*„60 bis 91“* in `Doku/PRUEFSTAND.md:8`, `:17`, `:56` und `README.md:112`) sind **teilweise** erledigt, unverändert seit [LEKTOR-159](LEKTOR-159.md#lektor-159).

## Funde

### <a id="l-160.1"></a>L-160.1 — TESTPLAN: der Kopf sagt „kein neuer Testabschnitt“, darunter steht der Entwurf 7.2.2.137

**Gewicht: mittel.** Gemessen.

* `Intern/TESTPLAN.md:3` *„**Stand:** 07.11.2026 kein neuer Testabschnitt — 7.2.2.137 ist in Arbeit, noch nicht geschnürt“*.
* `:5` *„## Dein Test an 7.2.2.137 — ca. 10 Minuten, an deinem echten System“*, `:11` *„bis dahin ist dieser Abschnitt ein Entwurf“*.

Der Satz stammt aus `f611da8f`, der Abschnitt kam einen Commit später (`38c614c3`). Gregor liest den Testplan als Arbeitsliste (`Arbeitsweise/nur-testplan-zaehlt.md`). Wer oben liest, sucht keinen Test, und wer weiterliest, findet einen.

**Soll:** Mit dem Schnüren in `:3` „Test 7.2.2.137 (unten), Paket geschnürt am …“ schreiben. Bis dahin genügt „Entwurf für 7.2.2.137 unten, noch nicht geschnürt“. Den Hinweis *„Entwurf“* in `:11` beim Schnüren entfernen.

### <a id="l-160.2"></a>L-160.2 — CHANGELOG 7.2.2.137 nennt E-242 „Originalfehler“, gemessen ist nur der Quelltext

**Gewicht: mittel.** Belegt.

* `CHANGELOG.md:128` *„**Die Druckvorschau trägt wieder Eudoras Kopf- und Fußzeile** ([E-242](../Intern/BEFUNDE.md#e-242), Originalfehler)“*.
* `Intern/BEFUNDE.md:407` (Stufe in [E-242](../Intern/BEFUNDE.md#e-242)): *„Quelltext original, Verhalten am Original nicht gemessen“*. Die Herkunft ist `git blame` `567a5d87`. Die Vermutung zum IE 6 (*„zu Zeiten des IE 6 standen die Werte nach dem ersten Druck aus dem IE in der Registry“*) ist ungemessen.

Derselbe Fall stand bei [E-239](../Intern/BEFUNDE.md#e-239) (Absturz beim Beenden bei offenem Hinweis) im CHANGELOG und wurde nach [L-154.4](LEKTOR-154.md#l-154.4) berichtigt. Heute sagt `CHANGELOG.md:138` dort *„ob der Fehler schon im Original steckt, ist nicht gemessen“*. Die Regel dahinter steht in `Arbeitsweise/original-ist-eine-messung.md`: Original ist eine Aussage über Verhalten, nicht über Quelltext. Der Abschnitt wird beim Release zum Release-Text.

**Soll:** „(Quelltext aus dem Original; ob das Original sich ebenso verhielt, ist nicht gemessen)“ schreiben, wie in `:138`.

### <a id="l-160.3"></a>L-160.3 — E-242 und E-240 stehen in beiden erzeugten Tabellen als „nie gemessen“

**Gewicht: mittel.** Gemessen.

* `CHANGELOG.md:34` [E-242](../Intern/BEFUNDE.md#e-242) (Pfad der Zwischendatei auf Ausdruck und Vorschau) und `:36` [E-240](../Intern/BEFUNDE.md#e-240) (Druckvorschau ohne Rückmeldung), Spalte „zuletzt gemessen“: *„**nie gemessen**“*. Ebenso `Intern/WEITERMACHEN.md:110` und `:112`.
* Gemessen ist aber beides, am 07.11.2026 am Prüfstand an einem Bau 7.2.2.136 mit der Behebung. Zu [E-242](../Intern/BEFUNDE.md#e-242) sagt `Intern/BEFUNDE.md:407` *„rot am Bau ohne Behebung … grün mit der Behebung“*, Fälle `E-242p`/`E-242r`. Zu [E-240](../Intern/BEFUNDE.md#e-240) sagt `:409` *„`E240 VORSCHAU-ERSCHIENEN vorschau-p1 nach 112 ms`“*.
* Der Grund: `tools/offene-befunde.pl:210` erkennt eine Messung nur an der Marke `**Zuletzt gemessen: TT.MM.JJJJ an 7.2.x.N**`, und keiner der beiden Urteilsköpfe hat sie.

Das ist dieselbe Klasse wie [L-157.2](LEKTOR-157.md#l-157.2) bei [E-151](../Intern/BEFUNDE.md#e-151) und [E-243](../Intern/BEFUNDE.md#e-243): Die Messung steht im Text, aber die Tabelle sieht sie nicht. Gregor liest die Tabelle im CHANGELOG ganz oben.

**Soll:** In beide Urteile `**Zuletzt gemessen: 07.11.2026 an 7.2.2.136**` setzen, mit dem Zusatz „(Bau mit der Behebung, Prüfstand)“. Danach `offene-befunde.pl` laufen lassen. Ob das Werkzeug ein Urteil mit Messdatum im Text, aber ohne Marke anmahnen soll, ist eine Werkzeugfrage für den Hauptagenten.

### <a id="l-160.4"></a>L-160.4 — FILTER.md führt E-71 zweimal als offen und zurückgestellt

**Gewicht: mittel.** Gemessen. [E-71](../Intern/BEFUNDE.md#e-71) ist laut `Intern/BEFUNDE.md:335` *„**erledigt durch die Doku — Gregor am 07.11.2026**“*. Der neue Kasten `Intern/FILTER.md:328-339` sagt das richtig. Zwei ältere Stellen derselben Datei widersprechen ihm:

* `Intern/FILTER.md:357-361`, gleich unter dem Kasten im selben Abschnitt: *„**Berichtigung einer früheren Einstufung.** … und der Bericht bleibt trotzdem leer. **[E-71](../Intern/BEFUNDE.md#e-71) ist ein eigener, offener Befund.**“*
* `:733`, Tabelle *„Die folgenden Befunde betreffen die Filter und sind **offen**“* (`:726`): *„[**E-71**](../Intern/BEFUNDE.md#e-71) \| **der Filterbericht bleibt leer** — … Auf seinen Wunsch zurückgestellt.“*

Das war ein Schwerpunkt dieser Runde. FAQ 23 verlinkt auf genau diesen Abschnitt (`Doku/FAQ.md:532-533`, *„Mehr: FILTER.md, Der Filterbericht“*). Wer dem Link folgt, liest zuerst „kein Fehler“ und vier Absätze später „offener Befund“.

**Soll:** Den Absatz `:357-361` mit „damals (bis 07.11.2026)“ kennzeichnen oder in den Kasten einarbeiten. Die Zeile `:733` aus der Tabelle der offenen Befunde in die Aufzählung „Behoben, aber gut zu wissen“ (`:736`) verschieben, mit „erledigt durch die Doku, 07.11.2026“.

### <a id="l-160.5"></a>L-160.5 — „107 Fälle“ im Testplan des Klonlaufs und in der Anleitung; seit 7.2.2.137 sind es 114

**Gewicht: gering.** Gemessen (Zählung). Die erwartete Zahl 111 ist eine Vermutung: Ich nehme an, dass im fremden Klon dieselben drei Fälle übersprungen werden.

* `Intern/TESTPLAN.md:78` (Test zu [E-151](../Intern/BEFUNDE.md#e-151), Prüfstand aus einem frischen Klon, Schritt 4): *„`Ergebnis: 107 Faelle, 107 bestanden, 0 fehlgeschlagen` und genau drei `[UEBR]` (`E-166a`, `E-166b`, `E-222w`)“*.
* `Doku/PRUEFSTAND.md:214` zeigt dieselbe Ausgabe als Beispiel.
* `tools/pruefstand-faelle.txt`: 110 Fallzeilen bei `1cb9087d`, heute 114 (neu `E-71n`, `E-71r`, `E-242p`, `E-242r`). Mit drei übersprungenen Fällen wären es 111.

Der Schritt gehört zu Gregors zurückgestelltem Lauf auf einem zweiten Rechner. Mit diesem Zweig könnte er so nicht bestehen. Dieselbe Klasse wie [L-156.1](LEKTOR-156.md#l-156.1): Eine feste Zahl im Testplan veraltet mit jedem neuen Fall.

**Soll:** Die Zahl aus der Fallliste ableiten und im Testplan als „N Fälle (Stand …), davon drei `[UEBR]`“ führen. Oder nur „0 fehlgeschlagen und genau drei `[UEBR]`“ verlangen. Beim Schnüren den Prüfbericht mit 114 Fällen erzeugen ([L-159.13](LEKTOR-159.md#l-159.13)).

### <a id="l-160.6"></a>L-160.6 — E-71: alte „Was noch fehlt“-Sätze im erledigten Urteil, und der Hinweis in EINSTELLUNGEN.md fehlt

**Gewicht: gering.** Belegt.

* `Intern/BEFUNDE.md:335` ([E-71](../Intern/BEFUNDE.md#e-71), leerer Filterbericht). Der Kopf ist richtig (*„erledigt durch die Doku“*), und der alte Stand ist mit *„Vorher: **offen — zurückgestellt**“* eingeleitet. Weiter hinten in derselben Zelle stehen aber ohne Kennzeichnung *„Nicht von selbst aufgreifen: Gregor hat ihn ausdrücklich auf die nächste Fassung geschoben“*, *„Gregors Zurückstellung gilt weiter.“* und *„**Was noch fehlt:** nicht die Behebung, sondern Gregors Freigabe“*. Das ist der Wortlaut, den Werkzeuge und Leser als „Was noch fehlt“ greifen.
* `Arbeitsweise/entscheidung-e71-doku-und-zweig-07-11.md:11` hält Gregors Entscheidung fest: *„FilterReport bleibt 0, Hinweis in FAQ/EINSTELLUNGEN.md“*. In `Intern/EINSTELLUNGEN.md` steht `FilterReport` 0-mal (gemessen mit `grep -i`), auch nicht im Abschnitt *„4. Überraschungen“* (`:233`). Der Hinweis steht in FAQ 23 und in `Doku/FUNKTIONEN.md:711`.

**Soll:** Die drei Sätze mit „(bis 07.11.2026)“ kennzeichnen oder in den Vorher-Teil ziehen. In `Intern/EINSTELLUNGEN.md` Abschnitt 4 eine Zeile mit Verweis auf FAQ 23 anlegen, oder die Gedächtnisnotiz auf „FAQ“ berichtigen.

### <a id="l-160.7"></a>L-160.7 — E-241: ist es in 7.2.2.137 oder nicht?

**Gewicht: gering.** Belegt.

* `Intern/WEITERMACHEN.md:19` *„[E-241](../Intern/BEFUNDE.md#e-241) nur bei geklärter Ursache“*, ebenso Entscheidung 40 (`:218`).
* `Intern/BEFUNDE.md:408` [E-241](../Intern/BEFUNDE.md#e-241) (Bild ↑/↓ blättern in der Druckvorschau nicht): *„Ursache **nicht gemessen**“*. Kein Commit seit `1cb9087d` nennt [E-241](../Intern/BEFUNDE.md#e-241) (`git log --oneline 1cb9087d..HEAD`).
* Der CHANGELOG-Abschnitt 7.2.2.137 (`:124-130`) und der Testplan-Entwurf (`Intern/TESTPLAN.md:5-28`) nennen [E-241](../Intern/BEFUNDE.md#e-241) zu Recht nicht.

Die Bedingung aus Entscheidung 40 ist also nicht erfüllt, und [E-241](../Intern/BEFUNDE.md#e-241) kommt nicht ins Test-ZIP. Der WEITERMACHEN-Kopf liest sich aber, als sei das noch offen.

**Soll:** In `Intern/WEITERMACHEN.md:19` „[E-241](../Intern/BEFUNDE.md#e-241) nicht in 7.2.2.137 (Ursache nicht gemessen, Entscheidung 40)“ schreiben.

### <a id="l-160.8"></a>L-160.8 — E-242: mit `PrintHeaders=0` setzt Eudora jetzt leere Kopf- und Fußzeilen; das steht nirgends

**Gewicht: gering.** Belegt am Quelltext, nicht gemessen.

* `TridentView.cpp:2544` *„`const BOOL bDoHeaderFooter = GetIniShort(IDS_INI_PRINT_HEADERS);`“*. Bei `0` bleiben `Title` und `NewFooter` leer (`:2549-2560`). `:2562-2563` *„`E242Setzen(hkIEPageSetup, HeaderValueName, Title, s_E242.Kopf);`“* setzt dann beide trotzdem, und das auch bei fehlendem Wert. Vorher geschah das nur, wenn der Wert schon stand. Die Vorgabe ist `PrintHeaders\n1` (`EudoraRes.rc:10315`).
* `Intern/BEFUNDE.md:407` erwähnt nur *„Der Schalter *Print headers* (`IDS_INI_PRINT_HEADERS`) wirkt aus demselben Grund nicht“*. Was er nach der Behebung tut, steht weder dort noch im CHANGELOG 7.2.2.137, in `Intern/EINSTELLUNGEN.md` oder in `Doku/FUNKTIONEN.md` (`PrintHeaders` 0-mal in allen MD außer BEFUNDE, gemessen).

Bei der Vorgabe ändert sich nichts gegenüber dem, was CHANGELOG und Testplan beschreiben. Nur wer den Schalter ausgeschaltet hat, bekommt jetzt leere Werte statt der Vorgaben des IE: `E242Setzen` (`:2348-2361`) schreibt den leeren Text mit `RegSetValueEx` als `REG_SZ`. Wie MSHTML einen leeren Wert druckt (vermutlich gar keine Kopf- und Fußzeile), ist nicht gemessen.

**Soll:** einen Satz in [E-242](../Intern/BEFUNDE.md#e-242) schreiben: „Mit `PrintHeaders=0` …“. Wenn das Verhalten so bleibt, eine Zeile im CHANGELOG.

### <a id="l-160.9"></a>L-160.9 — E-129: der Nachtrag vom 07.11. erreicht die Tabelle nicht, „Was noch fehlt“ zitiert den überholten Satz

**Gewicht: gering.** Gemessen.

* `CHANGELOG.md:66` [E-129](../Intern/BEFUNDE.md#e-129) (nach einer Übertragung in einen IMAP-Ordner zählt das Postfachverzeichnis zu wenige Nachrichten): *„22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet**“* und *„beide Mängel stehen noch — (1) … (2) …“*.
* `Intern/BEFUNDE.md:392`: Erstens berichtigt der Text selbst Punkt (2). Dort steht *„Hier stand, `tocdoc.cpp:962-995` vergleiche das Verzeichnis *nie* … Gelesen: es vergleicht **doch**, aber das Falsche“*. Das Werkzeug kopiert aber das erste „Was noch fehlt“. Zweitens ist der *„Nachtrag 07.11.2026 — dieselbe Klasse mit Serververbindung, aus Gregors Protokoll an 7.2.2.136“* eine neue Beobachtung an 7.2.2.136 mit eigenem „Wie zu prüfen“. Die Marke `**Zuletzt …**` ist aber unverändert.

Datenschutz (geprüft): Der Nachtrag nennt aus Gregors Protokoll nur Größen, Zählungen und Zustände, keine Namen. Das entspricht `Arbeitsweise/gedaechtnis-ist-oeffentlich.md` (*„Aus Gregors Daten nur Zahlen und Zeitpunkte“*).

**Soll:** Das erste „Was noch fehlt“ auf den berichtigten Stand bringen oder als „damals“ kennzeichnen. Die Marke auf `**Zuletzt gemessen: 07.11.2026 an 7.2.2.136**` setzen, mit dem Zusatz „(Protokoll, nur lesend)“.

### <a id="l-160.10"></a>L-160.10 — CHANGELOG 7.2.2.137 nennt keine Regressionstests

**Gewicht: gering.** Belegt.

* `CHANGELOG.md:128-130`: Die drei Punkte nennen keinen Fall und keinen Test. Im Abschnitt 7.2.2.136 steht das bei jedem Punkt, z. B. `:138` *„Regressionstest `TestE239.cpp`“* und `:141` *„Am Prüfstand gemessen (`E-169p`, …), Regressionstest `TestE169.cpp`“*.
* Vorhanden sind die Fälle `E-242p`, `E-242r`, `E-71n` und `E-71r` (`tools/pruefstand-faelle.txt:139-140`, `:342-343`) und der neue Test zu [E-242](../Intern/BEFUNDE.md#e-242) in `Eudora71/Tests/TestE169.cpp` (`507227e8`, *„neuer Test [E-242](../Intern/BEFUNDE.md#e-242)“*).

**Soll:** Beim Schnüren je Punkt die Fälle und `TestE169.cpp` nennen. Die Zahl der Unit-Tests ergibt sich erst aus dem Bau.

## Was sich als richtig erwiesen hat (Auswahl, gemessen)

* **[E-71](../Intern/BEFUNDE.md#e-71):** Die Aussagen in `Doku/FAQ.md:517-533`, `README.md:235`, `ZIEL.md:98` und `:158`, `CHANGELOG.md:130`, `Intern/AUFGABEN.md:9`, `Intern/WEITERMACHEN.md:17` und Entscheidung 40 (`:218`) stimmen untereinander und mit dem Urteil überein. Das FAQ-Inhaltsverzeichnis (`Doku/FAQ.md:19`) verlinkt 23 mit gültigem Anker. Die Fälle `E-71n`/`E-71r` stehen in `tools/pruefstand-faelle.txt:139-140`, die Läufe vom 07.11. um 09:51 in `tools/TESTLAEUFE.md:1640-1641`.
* **[E-242](../Intern/BEFUNDE.md#e-242)/[E-240](../Intern/BEFUNDE.md#e-240):** Die Beschreibung im CHANGELOG (`:128-129`), in der README (`:239-240`, beide *„noch in keinem Paket“*) und im Urteil passen zum Code (`TridentView.cpp:2318-2614`). Die Spurmarken im Testplan heißen im Code genauso.
* **ZWEIGE:** `tools/ZWEIGE.md` hat die Einträge für `e71_filterbericht`, `paket_7_2_2_137` und `e242_e240_druckvorschau`, jeweils mit Gregors Wortlaut und Datum. `paket_7_2_2_137` nennt *„nach dem LEKTOR“*, wie Entscheidung 40.
* **Datenschutz der neuen Texte:** Die README nennt den Pfad als `C:/Users/<Windows-Benutzer>/…`. Ich habe keinen Anmeldenamen, keinen Absender und keinen Betreff aus Gregors Daten gefunden. Die Kopfzeile im Urteil von [E-242](../Intern/BEFUNDE.md#e-242) stammt aus der Prüfmail (*„E125 Pruefstand <e125@127.0.0.1>“*).

## <a id="gregor"></a>Was nur Gregor entscheiden kann

1. **Kopf- und Fußzeile bei ausgeschaltetem *Print headers*** ([L-160.8](#l-160.8), am Quelltext belegt, nicht gemessen): Wer `PrintHeaders=0` gesetzt hat, bekam bisher die Kopf- und Fußzeile des Internet Explorer, also auch den Pfad mit dem Anmeldenamen. Mit 7.2.2.137 bekommt er leere Werte, also vermutlich gar keine. Ist das so gewollt? Bei der Vorgabe `1` ändert sich nichts gegenüber dem Testplan.

Die beiden noch offenen Fragen aus [LEKTOR-159](LEKTOR-159.md#lektor-159) bleiben bei Gregor. Erstens: Soll der Release-Text `v7.2.1.131` auf GitHub den Nachtrag vom 03.11. bekommen ([L-159.12](LEKTOR-159.md#l-159.12); auf GitHub steht weiter, dass das Label beim Verschieben im IMAP-Konto erhalten bleibt)? Zweitens: Soll die Reparatur aus EudoraUnicodeFix ohne Rays Antwort gebaut werden ([E-147](../Intern/BEFUNDE.md#e-147), Umlaute aus manchen Absendern zerstört)? Die dritte Frage, [E-71](../Intern/BEFUNDE.md#e-71), hat Gregor am 07.11. entschieden.
