# <a id="lektor-106"></a>LEKTOR-106 — Bestand nach a5e2f173

**Datum:** 31.10.2026 · **Geprüft:** Commit `a5e2f173` auf `wt/lektor-20261031` (abgezweigt von `e140-speichern-zeichensatz`), im Arbeitsbaum `.wt/lektor`

**Auftrag.** Voller Lauf: Funde aus [LEKTOR-105](LEKTOR-105.md#lektor-105)
nachsehen, dann den Bestand der MDs (ohne `Arbeitsweise/` und `Befunde/`)
gegen den heutigen Stand lesen. Schwerpunkt: die Commits seit `0d9b5f88` —
[E-140](../Intern/BEFUNDE.md#e-140) (*Speichern unter* aus Nachrichten- und
Verfassen-Fenster schreibt jetzt den Zeichensatz in die Datei) und
[E-139](../Intern/BEFUNDE.md#e-139) (der Hinweis „Rechtschreibprüfung fehlt“
lässt sich dauerhaft abschalten). **Alle Zeilenangaben gelten für
`a5e2f173`.** Nichts gebaut, nichts gestartet. **In diesem Bericht steht
nichts aus Gregors Rechner oder Postfach.**

**Ergebnis vorweg.** Von den sechs Funden aus [LEKTOR-105](LEKTOR-105.md#lektor-105)
sind vier erledigt und zwei teilweise. **Sechs neue Funde.** [E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140)
kommen in BEFUNDE, README, CHANGELOG, TESTPLAN, WERKZEUGE und WEITERMACHEN
einheitlich als „behoben im Quellstand, am Programm gemessen, in keinem
Paket“ an; nirgends steht für sie noch „offen“, „nie gemessen“ oder
„zurückgestellt“. Der wichtigste Fund: Der Prüfstandsfall zu
[E-139](../Intern/BEFUNDE.md#e-139) (`E-139p`) ist **nie** über den Prüfstand
gelaufen — im Ergebnisbuch fehlt er ganz —, CHANGELOG und TESTPLAN sagen aber,
er sei gefahren worden ([L-106.1](#l-106.1)). Zweitens: Das CHANGELOG nennt
[E-144](../Intern/BEFUNDE.md#e-144) (Antwortentwurf verliert den
Gesprächsfaden) „am Programm gemessen (Prüfstandsfall `E-144p`)“, während
BEFUNDE.md richtig sagt, dass `E-144p` nur rot aufgezeichnet ist
([L-106.2](#l-106.2)). Drittens geben zwei Zeilen der README-Tabelle
„Bekannte Fehler“ zum selben Symptom entgegengesetzten Rat
([L-106.3](#l-106.3)).

## Funde aus LEKTOR-105

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-105.1](LEKTOR-105.md#l-105.1) | „Was noch fehlt“ verlangte bei [E-141](../Intern/BEFUNDE.md#e-141) (IMAP → `Out` löst Expunge aus) und [E-176](../Intern/BEFUNDE.md#e-176) (Lesen aus freigegebenem Speicher) eine schon erfolgte Quelltextberichtigung | **erledigt** | `Intern/BEFUNDE.md:377` *„**Was noch fehlt:** die Messung am IMAP-Prüfserver … Die Berichtigung selbst steht seit dem 30.10.2026 im Quellstand (`tocdoc.cpp:3170` …)“*; `:383` *„**Was noch fehlt:** ein Test, der `CSummary` und `CMessageFrame` echt anlegt …“*; der erzeugte Block in `CHANGELOG.md` übernimmt beides (gemessen). Rest am Rand: die „Kette“ in `:377` nennt weiter *„Die Bedingung in `tocdoc.cpp:3134` lautet …“* — als Beschreibung des alten Stands lesbar, kein Fund |
| [L-105.2](LEKTOR-105.md#l-105.2) | Urteil [E-144](../Intern/BEFUNDE.md#e-144): „Kurz“ sagte „Die Behebung fehlt noch“, „Was noch fehlt“ beschrieb einen nicht umgesetzten Vorschlag | **teilweise** | „Kurz“ jetzt *„Behoben im Quellstand und am Programm gemessen; kommt mit dem nächsten Paket.“*; der PRÜFER-48-Vorschlag ist als *„Dieser Vorschlag hätte auch *Message → Send Again* die Bezüge behalten lassen“* gekennzeichnet; „Was noch fehlt“ ist *„der Prüfstandsfall `E-144p` grün im Ergebnisbuch“* (alles `Intern/BEFUNDE.md:401`, gemessen). **Offen:** dieselbe Zelle nennt weiter *„340 Tests, 340 bestanden“*, die Commit-Nachricht von `45aa451c` 341 ([L-106.6](#l-106.6)) |
| [L-105.3](LEKTOR-105.md#l-105.3) | `E-144p` nur rot aufgezeichnet, `E-125c` rot im Ergebnisbuch, keine Doku sagt es | **teilweise** | BEFUNDE sagt es jetzt: `Intern/BEFUNDE.md:401` *„Prüfstandsfall `E-144p` … **bisher nur einmal aufgezeichnet, und zwar rot**“* (gemessen). **Unverändert:** `E-144p` hat keine Zeile in `Intern/pruefstand-buch.tsv`; `:26` führt weiter *„E-125c FEHL 2026-10-30 14:18:03“* (gemessen). `tools/WERKZEUGE.md:131` sagt weiter *„ein Teillauf mit `-Nur` ersetzt nur seine eigenen Zeilen“*; heute hat derselbe Weg (`-Nur E-140p`, 19:57:58) eine neue Zeile angelegt (`pruefstand-buch.tsv:34`, gemessen) — warum `E-144p` am 30.10. keine bekam, bleibt ungeklärt. Neu dazu: das CHANGELOG widerspricht ([L-106.2](#l-106.2)) |
| [L-105.4](LEKTOR-105.md#l-105.4) | ZIEL.md führte [E-144](../Intern/BEFUNDE.md#e-144) und [E-145](../Intern/BEFUNDE.md#e-145) als „bleiben offen“ | **erledigt** | `ZIEL.md:89` *„die Befunde selbst blieben zum Release offen“*, *„[E-144](../Intern/BEFUNDE.md#e-144) (seit 30.10.2026 im Quellstand behoben)“*, *„[E-141](../Intern/BEFUNDE.md#e-141) (im Quellstand berichtigt, nicht gemessen), [E-145](../Intern/BEFUNDE.md#e-145) (seit 30.10.2026 im Quellstand behoben)“* (gemessen). Dieselbe Zeile ist für [E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140) jetzt nicht nachgezogen ([L-106.5](#l-106.5)) |
| [L-105.5](LEKTOR-105.md#l-105.5) | README ohne „im Quelltext behoben“ bei [E-141](../Intern/BEFUNDE.md#e-141), [E-144](../Intern/BEFUNDE.md#e-144), [E-145](../Intern/BEFUNDE.md#e-145); [E-176](../Intern/BEFUNDE.md#e-176) fehlt | **erledigt** (soweit Lektorat) | `README.md:184` ([E-144](../Intern/BEFUNDE.md#e-144)) *„im Quelltext behoben, kommt mit dem nächsten Paket“*; `:189` ([E-141](../Intern/BEFUNDE.md#e-141)) *„im Quelltext berichtigt, noch nicht gemessen“*; `:191` ([E-145](../Intern/BEFUNDE.md#e-145)) *„(am Original-Dekodierer gemessen)“* und *„im Quelltext behoben, kommt mit dem nächsten Paket“* (gemessen). [E-176](../Intern/BEFUNDE.md#e-176) steht weiter nicht in der README (`git grep E-176 README.md` ohne Treffer) — das war als Formfrage dem Hauptagenten zugewiesen und ist hier kein Rest |
| [L-105.6](LEKTOR-105.md#l-105.6) | `messen-e144.ps1` und `messen-e13.ps1` fehlten in WERKZEUGE.md | **erledigt** | `tools/WERKZEUGE.md:140` (`messen-e13.ps1`), `:141` (`messen-e144.ps1`) (gemessen). Die neuen `messen-e140.ps1` und `messen-e139.ps1` stehen in `:142` und `:143` |

## Neue Funde

### <a id="l-106.1"></a>L-106.1 — Der Prüfstandsfall E-139p ist nie über den Prüfstand gelaufen; CHANGELOG und TESTPLAN sagen, er sei gefahren worden

**Gewicht: Messaussage ohne Aufzeichnung.** `CHANGELOG.md:110`; `Intern/TESTPLAN.md:144-146`; `Intern/BEFUNDE.md:403`; Gegenstück `Intern/pruefstand-buch.tsv`, `Intern/pruefstand-ergebnis.txt`

Worum es geht: Für den abschaltbaren Rechtschreibhinweis gibt es einen neuen
Test über die Oberfläche. Er steht in der Fallliste, ist aber kein einziges
Mal über `pruefstand-lauf.ps1` gelaufen. Zwei Dokumente sagen das Gegenteil.

> `CHANGELOG.md:110`: *„**am Programm gemessen** (Prüfstandsfall `E-139p`,
> zwei Läufe): der neue Bau zeigt sie nach dem Ankreuzen nicht wieder …“*
>
> `Intern/TESTPLAN.md:144-146`: *„Am Prüfstand am 31.10.2026 so gefahren
> (Fall `E-139p`, Befund [E-139](../Intern/BEFUNDE.md#e-139)): neuer Bau Lauf 1 mit Kästchen, Lauf 2 ohne
> Meldung; 7.2.1.128 in beiden Läufen mit Meldung, ohne Kästchen.“*

Dagegen, **gemessen**:

* `Intern/pruefstand-buch.tsv` hat keine Zeile `E-139p` (`grep -n E-139p`
  ohne Treffer). `E-140p` dagegen steht dort (`:34`, *„E-140p ok 2026-10-31
  19:57:58“*).
* `Intern/pruefstand-ergebnis.txt:2-4` ist der letzte Prüfstandslauf:
  *„zeit=2026-10-31 19:57:58 … nur=E-140p“* — vor allen E-139-Starts.
* Die vier E-139-Starts in `tools/TESTLAEUFE.md:615-618` (20:06:46 bis
  20:07:51, `C:\Temp\E139` und `C:\Temp\E139-alt`) sind die Läufe von
  `messen-e139.ps1`, aus denen das Urteil seine Werte hat
  (`BEFUNDE.md:403` *„**Messung** (`tools/messen-e139.ps1`, Prüfstand
  `C:\Temp\E139`, Bau `7.2.1.128+7c13c368`)“*).
* Der Fall selbst prüft nur **einen** Lauf: `tools/pruefstand-faelle.txt`
  erwartet *„E139 ERGEBNIS lauf=1 erschienen=1 kaestchen=1 angekreuzt=1
  lebt=1“*; `WERKZEUGE.md:143` sagt richtig *„Prüfstandsfall `E-139p`
  (Lauf 1)“*. „Zwei Läufe“ im CHANGELOG gibt es im Fall nicht.

Die Messung am Programm ist also da (**belegt** durch Urteil und
Startprotokoll), nur nicht als Prüfstandsfall. Dasselbe Muster wie bei
`E-144p` ([L-105.3](LEKTOR-105.md#l-105.3)): eine Fall-Kennung wird als
Messbeleg genannt, das Ergebnisbuch kennt sie nicht. Wiederholt sich
`pruefstand-lauf.ps1 -Nur E-139p` nicht grün, merkt es niemand — die Zahl
in `pruefe-regressionstest.pl` zählt den Fall schon mit. Dass der Fall bei
einem zweiten Lauf nicht an der vom ersten Lauf geschriebenen
`WarnSpellUnavailable=0` scheitert, ist vorgesehen: `pruefstand-lauf.ps1:272`
ruft vor jedem Fall `-Vorbereiten`, und das nimmt den Schalter heraus
(`messen-e139.ps1:19`, `:50`; **belegt** am Quelltext, nicht gemessen).

**Vorschlag:** `pruefstand-lauf.ps1 -Nur E-139p` einmal fahren, bis das Buch
eine Zeile führt. Bis dahin in `CHANGELOG.md:110` „Prüfstandsfall `E-139p`,
zwei Läufe“ durch „`messen-e139.ps1`, zwei Läufe“ ersetzen und in
`TESTPLAN.md:144` „(Fall `E-139p` …)“ durch „(mit `tools/messen-e139.ps1`
…)“.

### <a id="l-106.2"></a>L-106.2 — CHANGELOG nennt E-144 „am Programm gemessen (Prüfstandsfall E-144p)“; BEFUNDE sagt, dieser Fall lief nur rot

**Gewicht: zwei Dokumente widersprechen sich über einen Messwert.** `CHANGELOG.md:116` gegen `Intern/BEFUNDE.md:401`

Worum es geht: Für den Antwortentwurf, der aus `Trash` zurück nach `Out`
gezogen seinen Gesprächsfaden verliert, sagt das CHANGELOG, ein
Oberflächentest habe die Behebung bestätigt. Das Urteil sagt, genau dieser
Test sei nur einmal und rot gelaufen.

> `CHANGELOG.md:116`: *„Regressionstest `TestE144.cpp`; **am Programm
> gemessen** (Prüfstandsfall `E-144p`): der neue Bau behält beide
> Kopfzeilen, die veröffentlichte 7.2.1.128 verliert sie.“*
>
> `Intern/BEFUNDE.md:401`: *„Prüfstandsfall `E-144p` … **bisher nur einmal
> aufgezeichnet, und zwar rot**“*; *„**Was noch fehlt:** der
> Prüfstandsfall `E-144p` grün im Ergebnisbuch.“*

Der Satz stand schon vor [LEKTOR-105](LEKTOR-105.md#lektor-105) so da; die
Einarbeitung `e44685bf` hat BEFUNDE berichtigt, das CHANGELOG nicht (am Diff
gemessen: `git show e44685bf -- CHANGELOG.md` ändert nur die zwei Zeilen
des erzeugten Blocks). [L-105.3](LEKTOR-105.md#l-105.3) hatte nur
BEFUNDE.md genannt — das war mein Versäumnis. Gemessen am Programm ist
[E-144](../Intern/BEFUNDE.md#e-144) über `messen-e144.ps1` (nach
`tools/TESTLAEUFE.md`); falsch ist nur die Klammer. **Gemessen.**

**Vorschlag:** In `CHANGELOG.md:116` „(Prüfstandsfall `E-144p`)“ durch
„(mit `tools/messen-e144.ps1`; der Prüfstandsfall `E-144p` steht noch
nicht grün im Buch)“ ersetzen — oder erst `-Nur E-144p` grün fahren.

### <a id="l-106.3"></a>L-106.3 — Zwei Zeilen der README-Tabelle geben zum selben Symptom entgegengesetzten Rat

**Gewicht: widersprüchlicher Rat an den Anwender.** `README.md:161` gegen `README.md:190`

Worum es geht: Wer eine gespeicherte Nachricht in einem anderen Programm mit
falschen Umlauten sieht, liest in der README zwei Ratschläge. Der eine sagt
„nicht speichern“, der andere „aus der Postfachliste speichern, dieser Weg
ist richtig“.

> `README.md:161` ([E-101](../Intern/BEFUNDE.md#e-101)): *„Eine als Datei
> gespeicherte Nachricht zeigt in anderen Programmen falsche Zeichen | die
> **gespeicherte Datei** ist verfälscht … | die Nachricht im Postfach lassen
> oder weiterleiten statt speichern.“*
>
> `README.md:190` ([E-140](../Intern/BEFUNDE.md#e-140)): *„aus der
> Postfachliste speichern (Nachricht markieren, *File → Save As*) — dieser
> Weg ergänzt die Angabe“*

Das Urteil zu [E-101](../Intern/BEFUNDE.md#e-101) sagt
*„**behoben, soweit es Datenverlust und Gregors Symptom betrifft** … die
Ergänzung der Kopfzeile ist am 23.10.2026 an 7.2.0.120 belegt“*
(`Intern/BEFUNDE.md`, Zeile mit `id="e-101"`), und die Messung zu [E-140](../Intern/BEFUNDE.md#e-140) an
7.2.1.128 bestätigt den Weg aus der Postfachliste (`BEFUNDE.md:402`
*„aus der **Postfachliste** `ct=1 charset=windows-1252` (Gegenprobe,
[E-101](../Intern/BEFUNDE.md#e-101))“*). Die Zeile `:161` beschreibt also einen Stand, der für den Weg
aus der Postfachliste seit 7.2.0.120 nicht mehr gilt; für Nachrichten- und
Verfassen-Fenster deckt ihn jetzt `:190` ab. **Belegt.** Was von [E-101](../Intern/BEFUNDE.md#e-101)
noch offen ist (F2, F5 bis F9, *„Wirkung ohne Schaden“*), steht in der
Zeile nicht.

**Vorschlag:** Zeile `:161` an den Stand von [E-101](../Intern/BEFUNDE.md#e-101) anpassen (welche Post,
welcher Weg, ab welcher Fassung) oder streichen und auf `:190` verweisen.
Ob die Zeile bleibt, ist eine Formfrage für den Hauptagenten.

### <a id="l-106.4"></a>L-106.4 — Der Rest von E-140 (Filteraktion „an Programm übergeben“) steht in keiner Liste

**Gewicht: bekannter offener Rest ohne Platz in der Aufgabenliste.** `Intern/BEFUNDE.md:402`; vergleiche `Intern/WEITERMACHEN.md:20-40`

Worum es geht: Beim Beheben von [E-140](../Intern/BEFUNDE.md#e-140) wurde ein dritter Speicherweg
gefunden, der die Zeichensatzangabe weiter nicht schreibt. Er steht nur am
Ende des Urteils eines Befunds, der jetzt als behoben gilt — dort sucht ihn
niemand.

> `Intern/BEFUNDE.md:402`: *„**Nicht behoben:** die Filteraktion *„an
> Programm übergeben"* (`filtersd.cpp:2074` → `ReadMessageDoc.cpp:531`)
> schreibt ihre Zwischendatei weiter ohne Angabe — ungemessen.“*

`offene-befunde.pl` führt [E-140](../Intern/BEFUNDE.md#e-140) nicht mehr (43 statt 45 offene, gemessen),
und `git grep -n "filtersd.cpp:2074"` findet die Stelle außerhalb von
`BEFUNDE.md` nirgends — weder in der Liste
[Nach dem Release 7.2.1](../Intern/WEITERMACHEN.md#nach-dem-release) noch in
`Intern/AUFGABEN.md` (gemessen). Die Stelle selbst trifft:
`filtersd.cpp:2074` öffnet die Zwischendatei, `:2094` ruft
`CReadMessageDoc::SaveAs` (`ReadMessageDoc.cpp:531`) — und [E-140](../Intern/BEFUNDE.md#e-140) hat
`SaveAsFile` geändert, nicht `SaveAs` (**belegt** am Quelltext und am
Diff von `9459edaa`).

**Vorschlag:** Den Rest als eigene Zeile in die Liste
[Nach dem Release 7.2.1](../Intern/WEITERMACHEN.md#nach-dem-release) (ohne
Befundnummer: „Filteraktion *an Programm übergeben* schreibt ohne
Zeichensatz, ungemessen“, Verweis auf [E-140](../Intern/BEFUNDE.md#e-140)) — oder, wenn der Hauptagent
das als Befund führen will, mit eigener Nummer.

### <a id="l-106.5"></a>L-106.5 — ZIEL.md: E-139 und E-140 ohne den Vermerk, den E-144 und E-145 haben

**Gewicht: Form, uneinheitlich in einer Zeile.** `ZIEL.md:89`

Worum es geht: Der Maßstab zählt die Fehler auf, die zum Release in der
README blieben. Bei zwei schon behobenen steht „(seit 30.10.2026 im
Quellstand behoben)“, bei den zwei heute behobenen nichts.

> `ZIEL.md:89`: *„dazu [E-144](../Intern/BEFUNDE.md#e-144) (seit 30.10.2026 im Quellstand behoben),
> [E-143](../Intern/BEFUNDE.md#e-143), [E-139](../Intern/BEFUNDE.md#e-139), [E-136](../Intern/BEFUNDE.md#e-136), [AN-1](../Intern/BEFUNDE.md#an-1), … [E-140](../Intern/BEFUNDE.md#e-140), [E-141](../Intern/BEFUNDE.md#e-141) (im Quellstand
> berichtigt, nicht gemessen), [E-145](../Intern/BEFUNDE.md#e-145) (seit 30.10.2026 im Quellstand
> behoben)“*

`Intern/BEFUNDE.md:402` und `:403` sagen bei beiden *„**behoben im
Quellstand, am 31.10.2026 am laufenden Programm gemessen; in keinem
Paket.**“*. `ziel-stand.pl` meldet *„27 von 27 erfüllt“*; diesen Satz liest
es nicht. **Gemessen.**

**Vorschlag:** hinter [E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140) je „(seit 31.10.2026 im
Quellstand behoben)“.

### <a id="l-106.6"></a>L-106.6 — Drei kleine Reste: Testzahl bei E-144, ein entfernter Kommentar im Präsens, ein Verweis „wo es jetzt steht“

**Gewicht: Kleinkram, je ein Satz.**

* `Intern/BEFUNDE.md:401` ([E-144](../Intern/BEFUNDE.md#e-144)): *„340
  Tests, 340 bestanden“* — die Commit-Nachricht von `45aa451c` nennt 341
  (Rest aus [L-105.2](LEKTOR-105.md#l-105.2), **belegt**).
* `Intern/BEFUNDE.md:403` ([E-139](../Intern/BEFUNDE.md#e-139)): *„der
  Kommentar in `spell.cpp:65-66` nennt genau den Grund, warum es bisher
  unterblieb: *„Kein CRString/IDS_…“*“* — dieser Kommentar ist mit
  `7c13c368` entfernt (`grep -n "Kein CRString" Eudora71/Eudora/spell.cpp`
  ohne Treffer, gemessen). Der Absatz ist als Vorgeschichte gemeint, steht
  aber im Präsens; ebenso *„`ZeigeHinweisEinmal()` (`:58`)“* und
  *„`AfxMessageBox`“* als heutiger Weg im Abschnitt „Die Stelle“.
* `Intern/WEITERMACHEN.md:137` (Entscheidung 7): *„die offenen Befunde
  [E-140](../Intern/BEFUNDE.md#e-140), [E-141](../Intern/BEFUNDE.md#e-141), [E-145](../Intern/BEFUNDE.md#e-145) … Wo es jetzt steht: [Nach dem Release
  7.2.1]“* — [E-140](../Intern/BEFUNDE.md#e-140) und [E-145](../Intern/BEFUNDE.md#e-145) sind behoben und stehen dort nicht mehr
  (gemessen). Die Entscheidung selbst bleibt Geschichte; nur der Verweis
  „wo es jetzt steht“ führt für zwei der drei ins Leere.

**Vorschlag:** 340 → 341; in `:403` „nannte“ statt „nennt“ und vor „Die
Stelle“ ein „(Stand vor der Behebung)“; in `WEITERMACHEN.md:137` hinter
[E-140](../Intern/BEFUNDE.md#e-140) und [E-145](../Intern/BEFUNDE.md#e-145) „(seit 30./31.10.2026 im Quellstand behoben)“.

## Bestand ohne Fund

* **[E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140) kommen einheitlich an.** `Intern/BEFUNDE.md:402`, `:403`
  *„behoben im Quellstand, am 31.10.2026 am laufenden Programm gemessen; in
  keinem Paket“*; `README.md:186` und `:190` je *„im Quelltext behoben, kommt
  mit dem nächsten Paket“*; `CHANGELOG.md:107-110` unter *„Im Quellstand,
  noch in keinem Paket“*, Zweig `e140-speichern-zeichensatz`, *„344 Tests“*
  bzw. *„346 Tests“* — passt zu `commit-bereit.pl` *„Alle 346 Tests
  bestanden.“* (gemessen); `tools/WERKZEUGE.md:142-143` mit beiden
  Messskripten und den gemessenen Werten; `tools/ZWEIGE.md:199` mit dem
  Zweig, *„Von Gregor gewählt“*; aus der offenen Liste in
  `Intern/WEITERMACHEN.md` sind beide Zeilen gestrichen (je `-1` in
  `eb65fd94` und `a5e2f173`, gemessen).
* **Kein „offen“, „nie gemessen“, „zurückgestellt“ mehr** für [E-139](../Intern/BEFUNDE.md#e-139) oder
  [E-140](../Intern/BEFUNDE.md#e-140) außerhalb von `Befunde/` und `Arbeitsweise/`: `git grep` nach den
  Kennungen mit diesen Wörtern trifft nur `WEITERMACHEN.md:137` (siehe
  [L-106.6](#l-106.6)) und das Archiv `WEITERMACHEN-bis-7.2.0.md:139`
  (gemessen). In `Arbeitsweise/entscheidung-vor-7-2-1-beheben.md:25` steht
  *„[E-139](../Intern/BEFUNDE.md#e-139) bleibt bis nach 7.2.1 nur in der README“* — das ist mit dem
  Release 7.2.1.128 eingelöst, kein Widerspruch.
* **TESTPLAN-Abschnitte** [e-139-naechstes](../Intern/TESTPLAN.md#e-139-naechstes)
  und [e-140-naechstes](../Intern/TESTPLAN.md#e-140-naechstes)
  (`Intern/TESTPLAN.md:127-164`): beide sagen *„Noch kein Paket — erst
  ausführen, wenn das nächste Paket da ist“* und *„am **lokalen** Postfach
  *In*“* ([testschritt-nennt-den-ort](../Arbeitsweise/testschritt-nennt-den-ort.md)).
  Die Schritte decken sich mit `messen-e139.ps1` (Reply, Kästchen, Neustart)
  und `messen-e140.ps1` (Nachrichtenfenster, Verfassen-Fenster). Schritt 4
  bei [E-139](../Intern/BEFUNDE.md#e-139) (*„die Zeile `WarnSpellUnavailable=0` löschen — beim nächsten
  Start kommt die Meldung wieder einmal“*) ist am Quelltext richtig
  (Vorgabe `"WarnSpellUnavailable\n1"` in `EudoraRes.rc`, belegt am Diff
  von `7c13c368`), am Programm aber nicht gemessen; die Gegenprobe aus dem
  Urteil (*„Schlüssel von Hand zurücksetzen“*) ist nicht gefahren.
* **Zahlen:** `offene-befunde.pl` 43 (vorher 45), *„nie gemessen 12“*
  (vorher 14) — genau [E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140) weniger. `pruefe-regressionstest.pl`
  *„mit Testfall 103“* (vorher 101) — ebenfalls die zwei.
* `README.en.md:36-46` verweist für bekannte Fehler auf die deutsche
  README und nennt nur Defender und Entwürfe; nichts zu berichtigen.
* Die „Zur Kenntnis“-Liste von `doku-pruefen.pl` ist dieselbe wie bei
  [LEKTOR-105](LEKTOR-105.md#lektor-105) (15 Archiv-, Hintergrund- und
  Testdatendateien).

## Mechanisch (zitiert, gemessen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 50 … Kein Widerspruch gefunden.“*; 15 „Zur Kenntnis“-Zeilen. Es vergleicht Fassungsnummern; [L-106.1](#l-106.1) bis [L-106.6](#l-106.6) kann es nicht sehen |
| `perl tools/offene-befunde.pl` | *„43 offene Befunde, in beiden Listen gleich.“* (5 aktuell, 26 veraltet, 12 nie gemessen). Den Rest aus [L-106.4](#l-106.4) zählt es nicht, weil [E-140](../Intern/BEFUNDE.md#e-140) behoben ist |
| `perl tools/pruefe-regressionstest.pl` | *„Befunde insgesamt 220 … mit Testfall 103 … behoben und OHNE Testfall 50 … mit Testfall im Pruefstand 59 von 72 … OHNE jede Pruefung 11 … Kein neues "behoben" ohne Regressionstest.“* Ein Prüfstandsfall zählt, sobald er in der Fallliste steht — auch `E-139p`, der nie gelaufen ist ([L-106.1](#l-106.1)) |
| `perl tools/ziel-stand.pl` | *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* Den Satz aus [L-106.5](#l-106.5) liest es nicht |

## Nicht geprüft

* Nicht jede Datei Zeile für Zeile. Ganz gelesen: die Urteile zu [E-139](../Intern/BEFUNDE.md#e-139),
  [E-140](../Intern/BEFUNDE.md#e-140), [E-141](../Intern/BEFUNDE.md#e-141), [E-144](../Intern/BEFUNDE.md#e-144), [E-176](../Intern/BEFUNDE.md#e-176) (Ausschnitte), `CHANGELOG.md:1-30` und
  `:100-120`, README „Bekannte Fehler“ (`:150-200`), `TESTPLAN.md:100-170`,
  `WEITERMACHEN.md:10-40`, `ZIEL.md:89`, `WERKZEUGE.md:140-143`. Die
  übrigen Dateien nur nach [E-139](../Intern/BEFUNDE.md#e-139), [E-140](../Intern/BEFUNDE.md#e-140), Testzahlen und den Wörtern
  „offen/nie gemessen/zurückgestellt“ durchsucht.
* Ob `TestE139.cpp` und `TestE140.cpp` prüfen, was ihr Name sagt, und ob
  `E140TextFuerDatei` alle Wege trifft: Sache des PRÜFERS (laut
  `commit-bereit.pl` seit `ae3efe3` fällig).
* Nichts am laufenden Programm, kein Prüfstand.
* **Zum Ablauf:** Der Commit-Haken (`lehren-spiegeln`) hat beim ersten
  Sichern die Gedächtnisdatei `stand-31-10-2026-abend.md` nach
  `Arbeitsweise/` gespiegelt und `MEMORY.md` ergänzt; ohne sie wies er ab.
  Mitgenommen wie in `0d9b5f88` ([LEKTOR-105](LEKTOR-105.md#lektor-105)),
  dazu die Zeile in `Arbeitsweise/README.md` aus
  `lehren-uebersicht.pl -schreiben`. Inhaltlich habe ich daran nichts
  geändert.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Offen seit [LEKTOR-103](LEKTOR-103.md#lektor-103);
  `ZIEL.md:37-38` sagt weiter, der Satz fehle. Unverändert.
* **Wann kommt das nächste Paket mit den Behebungen?** Im Quellstand liegen
  jetzt, am Programm gemessen: der Filter mit „doesn't appear“, der in
  7.2.1.128 jede Nachricht verschiebt ([E-72](../Intern/BEFUNDE.md#e-72)),
  der Antwortentwurf, der den Gesprächsfaden verliert
  ([E-144](../Intern/BEFUNDE.md#e-144)), *Speichern unter* mit
  Zeichensatzangabe ([E-140](../Intern/BEFUNDE.md#e-140)) und der
  abschaltbare Rechtschreibhinweis ([E-139](../Intern/BEFUNDE.md#e-139));
  dazu, nur am Quelltext, Base64 ([E-145](../Intern/BEFUNDE.md#e-145)),
  IMAP → `Out` ([E-141](../Intern/BEFUNDE.md#e-141)) und das Lesen aus
  freigegebenem Speicher ([E-176](../Intern/BEFUNDE.md#e-176)). Die
  TESTPLAN-Abschnitte für [E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140) warten auf dieses Paket.
