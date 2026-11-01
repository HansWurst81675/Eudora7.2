# <a id="lektor-111"></a>LEKTOR-111 — Bestand nach 10102f8d (01.11.2026)

Bestandslauf im Arbeitsbaum `.wt/lektor` (Zweig `wt/lektor-20261101`, Stand
`10102f8d`). Geprüft: die drei Funde aus [LEKTOR-110](LEKTOR-110.md), alles seit
`99f0a36` (16 Commits, `git log --stat 99f0a36..HEAD`) und die Dateien aus
`git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/` auf Aussagen über
den Stand. Besonders geprüft: die erzeugte Stufentabelle in
`Intern/BEFUNDE.md`, der Eintrag zu `tools/fettstellen.pl` in
`tools/WERKZEUGE.md`, [E-136](../Intern/BEFUNDE.md#e-136) (Emoji gehen beim Speichern verloren; Stufe jetzt
unkritisch, zweiter Speicherweg), [E-165](../Intern/BEFUNDE.md#e-165) (Vervollständigungsbox im To:-Feld,
geschlossen), FAQ 16 und [PRÜFER-69](PRUEFER-69.md).

Nichts gebaut, nichts gestartet. Für die Liste unter „ohne Urteilswort“
lief eine Kopie von `tools/offene-befunde.pl` mit einer zusätzlichen
Ausgabezeile im Scratchpad.

## Kurz

Alle drei Funde aus [LEKTOR-110](LEKTOR-110.md#lektor-110) sind **erledigt**. Die mechanischen
Prüfungen sind grün; Stufentabelle, `pruefe-regressionstest.pl` und
`offene-befunde.pl` nennen dieselben Zahlen (223 Befunde, 71 / 67 / 40 / 45
je Stufe, 43 offen). [E-165](../Intern/BEFUNDE.md#e-165) steht überall als geschlossen,
[E-136](../Intern/BEFUNDE.md#e-136) überall als offen, nirgends als behoben. PRÜFER-69 K1 bis K3 sind
eingearbeitet, K4 und K5 in WEITERMACHEN vorgemerkt.

Sechs neue Funde, keiner betrifft das Programm:

* Im Urteil zu [E-165](../Intern/BEFUNDE.md#e-165) ist ein Fettdruck nicht geschlossen; ab der Mitte
  zeigt GitHub Fett und Normal vertauscht ([L-111.1](#l-111.1)).
* TESTPLAN sagt Gregor, der zweite Speicherweg von [E-136](../Intern/BEFUNDE.md#e-136) sei „noch nicht
  behoben“; im Quellstand ist er es für `.htm` ([L-111.2](#l-111.2)).
* Gregors offene Frage vom 31.10.2026, was ins nächste Release gehört, steht
  nur in einer Standnotiz unter `Arbeitsweise/`, nicht in WEITERMACHEN
  ([L-111.3](#l-111.3)).
* Dazu drei kleinere: die Stufentabelle erklärt ihre Spalte „ohne
  Urteilswort“ nicht ([L-111.4](#l-111.4)), ein Rest aus PRÜFER-69 K2 (übersprungene Tests
  zählen als bestanden) ist nirgends vorgemerkt ([L-111.5](#l-111.5)), fünf Kleinigkeiten
  ([L-111.6](#l-111.6)).

## Funde aus LEKTOR-110

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-110.1](LEKTOR-110.md#l-110.1) | Urteil zu [E-136](../Intern/BEFUNDE.md#e-136) sagte „in 7.2.1.129“ und „in keinem Paket“ zugleich | **erledigt** | `Intern/BEFUNDE.md:423` *„in 7.2.1.129 (nur der Weg Strg-S); dort noch nicht nachgemessen.“* — „in keinem Paket“ ist fort (gemessen) |
| [L-110.2](LEKTOR-110.md#l-110.2) | [E-165](../Intern/BEFUNDE.md#e-165) fehlte in WEITERMACHEN, `offene-befunde.pl` endete mit Exit 1 | **erledigt** (durch den Fortgang: [E-165](../Intern/BEFUNDE.md#e-165) ist geschlossen) | `Intern/BEFUNDE.md:396` *„**behoben in 7.2.1.129, von Gregor am 31.10.2026 bestätigt**“*; `offene-befunde.pl` Exit 0, *„43 offene Befunde, in beiden Listen gleich.“*; keine E-165-Zeile in den erzeugten Blöcken von WEITERMACHEN und CHANGELOG (gemessen) |
| [L-110.3](LEKTOR-110.md#l-110.3) | PAKETE nannte Gregors E-165-Ergebnis nicht | **erledigt** | `Releases/PAKETE.md:194` *„[[E-165](../Intern/BEFUNDE.md#e-165)] mit zwei und drei Treffern ‚sieht besser aus e-165‘, bei einem Treffer keine Box, sondern Ergänzung im Feld“* (gemessen) |

## Heute besonders geprüft

| Stelle | Aussage | Urteil |
|---|---|---|
| `Intern/BEFUNDE.md:154-164` (Stufentabelle) | kritisch 10 / 58 / 3 / 71, wichtig 19 / 44 / 4 / 67, unkritisch 6 / 32 / 2 / 40, werkzeug 8 / 30 / 7 / 45, zusammen 43 / 164 / 16 / 223 | stimmt mit `pruefe-regressionstest.pl` (*„Befunde insgesamt 223“*, *„kritisch 71 … wichtig 67 … unkritisch 40 … werkzeug 45“*) und `offene-befunde.pl` (*„offen laut Intern/BEFUNDE.md 43“*); der Block ist auf dem Stand, sonst endete `offene-befunde.pl` mit Exit 1 (`tools/offene-befunde.pl:437`) (gemessen). Spalte „ohne Urteilswort“ siehe [L-111.4](#l-111.4) |
| `tools/WERKZEUGE.md:175` (`fettstellen.pl`) | *„eine Stelle für `offene-befunde.pl`, `pruefe-befundurteile.pl` und `ziel-stand.pl`“* | stimmt: genau diese drei laden es (`grep -l fettstellen tools/*.pl`) (gemessen) |
| `tools/WERKZEUGE.md:175` | *„jetzt 118 statt 114 behobene erkannt“* | stimmt: `pruefe-befundurteile.pl` meldet *„davon behoben 118“* (gemessen) |
| `tools/WERKZEUGE.md:175` | *„`--selbsttest`: sechs Fälle und die Gegenprobe“* | stimmt: sechs `[ok  ]` und *„Gegenprobe: altes Muster liest bei [E-136](../Intern/BEFUNDE.md#e-136) " "“*, Exit 0 (gemessen) |
| `tools/WERKZEUGE.md:175` | Grenze des Musters bei Fett im Fett ([PRÜFER-69 K4](PRUEFER-69.md#k4)) | steht nicht im Eintrag, aber in `Intern/WEITERMACHEN.md` (Zeile *„Urteilsköpfe ohne Urteilswort und Fett im Fett …“*) vorgemerkt — keine Überbehauptung (belegt) |
| `Intern/BEFUNDE.md:423` ([E-136](../Intern/BEFUNDE.md#e-136), Stufe) | *„**Stufe: unkritisch** (herabgestuft von *kritisch* auf Gregors Entscheidung vom 31.10.2026 …)“* | stimmt mit `Arbeitsweise/stand-31-10-2026-abend.md:35` (*„zuerst ‚ja, auf medium setzen‘, dann … ‚unkritisch‘“*); [E-136](../Intern/BEFUNDE.md#e-136) steht in `pruefe-regressionstest.pl` nicht mehr unter den kritischen ohne Prüfung (gemessen) |
| `Intern/BEFUNDE.md:423` ([E-136](../Intern/BEFUNDE.md#e-136), zweiter Weg) | *„für `.htm` im Quellstand behoben am 31.10.2026 … seither gilt das nur noch für `.txt`“*; „Was noch fehlt“ ohne „K1 beheben“ | stimmt; der Widerspruch aus [PRÜFER-69 K3](PRUEFER-69.md#k3) ist fort (gemessen). `TridentReadMessageView.cpp:2926` ist die einzige `szMsg = cbstr;` (Text-Zweig) (gemessen) |
| `Intern/BEFUNDE.md:398` ([E-178](../Intern/BEFUNDE.md#e-178)) | Stellen *„`TridentReadMessageView.cpp:2679, 3218, 3228, 3349, 3419, 3422, 3632, 4069` … und `TridentView.cpp:3944`“* | stimmt: an allen neun Zeilen steht eine `= cbstr`-Zuweisung bzw. `CString( cbstrText )` (gemessen) |
| `README.md:182`, `CHANGELOG.md:109`, `:123`, `Intern/AUFGABEN.md:8`, `Intern/WEITERMACHEN.md:3` | [E-136](../Intern/BEFUNDE.md#e-136) *„in 7.2.1.129 geändert (am Programm noch nicht nachgemessen)“*, *„bleibt offen bis zur Messung am Programm“* | stimmt; nirgends „behoben“ (gemessen). Ausnahme TESTPLAN, siehe [L-111.2](#l-111.2) |
| `README.md:186`, `CHANGELOG.md:110`, `:125`, `ZIEL.md:89`, `Intern/AUFGABEN.md:8`, `Intern/TESTPLAN.md:185`, `Releases/PAKETE.md:194` | [E-165](../Intern/BEFUNDE.md#e-165) *„behoben in 7.2.1.129 (Testpaket, von Gregor bestätigt)“* | stimmt untereinander und mit `Intern/BEFUNDE.md:396` (gemessen) |
| `Doku/FAQ.md:328-330` (FAQ 16) | *„am 31.10.2026 an 7.2.1.128 und an 7.2.1.129 (‚ja, funktioniert mit ctrl-shift-F‘)“* | belegt durch `Arbeitsweise/stand-31-10-2026-abend.md:27` (*„FAQ-16-Suche ok“*) und `:29`; CHANGELOG und PAKETE nennen nur 7.2.1.128, siehe [L-111.6](#l-111.6) |
| [PRÜFER-69](PRUEFER-69.md) K1 | Test für `GetMessageBody` bleibt bei zweiter Zuweisung grün | **eingearbeitet** in `10102f8d` (`TestE136.cpp` +15 Zeilen); `Intern/BEFUNDE.md:423` *„Gegenprobe gemessen: 349/1, wiederhergestellt 350/0“* (belegt) |
| PRÜFER-69 K2 | doppeltes `TT_EndTest`, Abweichung außerhalb eines Tests | **teilweise**: beides in `TinyTest.cpp` als „Gerüstfehler“ gezählt (`10102f8d`, gemessen am Diff); der dritte Teil (übersprungene Tests) siehe [L-111.5](#l-111.5) |
| PRÜFER-69 K3 | [E-136](../Intern/BEFUNDE.md#e-136) widersprüchlich, E-178-Zeilen verschoben | **eingearbeitet** (beide Zeilen oben) |
| PRÜFER-69 K4, K5 | Fett im Fett; „ohne Urteilswort“ enthält Erledigtes | **vorgemerkt** in `Intern/WEITERMACHEN.md` (Tabelle „Aufgaben ohne Befundnummer“, Verweis *„[PRÜFER-69 K4] … [K5]“*) (gemessen) |

**Überbehauptung gesucht (gemessen):** „7.2.1.129“ mit „veröffentlicht“ bis
40 Zeichen dahinter trifft weiter nur *„nicht veröffentlicht“*
(`CHANGELOG.md:114`, `Releases/PAKETE.md:184`). „[E-136](../Intern/BEFUNDE.md#e-136)“ mit „behoben“ bis
30 Zeichen dahinter: nur Treffer für den zweiten Weg im Quellstand
(`Intern/BEFUNDE.md:423`) und den falschen Gegenschluss in TESTPLAN
([L-111.2](#l-111.2)).

## Funde

### <a id="l-111.1"></a>L-111.1 — Urteil zu E-165: ein Fettdruck ist nicht geschlossen

**Gewicht: mittel.** `Intern/BEFUNDE.md:396` (gemessen)

Die Zeile enthält **61** Fettmarken `**` — eine ungerade Zahl. Die
überzählige steht hier:

> *„… Der Fall mit einem Treffer: siehe oben, keine Box.\*\* Auf seinem
> Rechner schrieb 7.2.1.129 …“*

Herkunft (gemessen an `git show 5ab45da9`): Der alte Kopf endete mit
*„… Offen bleibt nur der Fall mit EINEM Treffer.\*\*“*. `5ab45da9` hat einen
neuen Kopf davorgesetzt, den alten Kopf zur „Vorgeschichte“ gemacht und
dabei die öffnende Marke entfernt, die schließende stehen lassen. Ab dieser
Stelle zeigt GitHub bis zum Zeilenende Fett und Normal vertauscht.

Dieselbe Stelle ist eine der Ursachen von [PRÜFER-69 K4](PRUEFER-69.md#k4):
dort steht [E-165](../Intern/BEFUNDE.md#e-165) unter den Urteilen, bei denen `fettstellen.pl` die Paarung
verliert. Den Kopf liest das Werkzeug richtig (gemessen: [E-165](../Intern/BEFUNDE.md#e-165) steht in
keiner offenen Liste).

**Vorschlag:** `keine Box.**` → `keine Box.` Danach die Zahl der Marken
erneut zählen.

### <a id="l-111.2"></a>L-111.2 — TESTPLAN nennt den zweiten Speicherweg von E-136 „noch nicht behoben“

**Gewicht: mittel.** `Intern/TESTPLAN.md:203-206`

> *„**Nur mit Strg+S prüfen, nicht mit *Speichern unter*:** *File → Save
> As* aus dem Nachrichtenfenster (`.txt`, `.htm` ohne Kopfzeilen) macht aus
> Emoji in 7.2.1.129 weiter `??` — ein zweiter Weg, noch nicht behoben
> ([PRÜFER-68] K1, im Befund nachgetragen).“*

Für 7.2.1.129 stimmt die Aussage, das Paket ist vor der Behebung gebaut.
Die Wendung „noch nicht behoben“ stimmt aber seit `b106664e` nicht mehr:
`Intern/BEFUNDE.md:423` sagt *„für `.htm` im Quellstand behoben am
31.10.2026“*, `CHANGELOG.md:109` ebenso. TESTPLAN ist die Datei, aus der
Gregor testet ([Nur der Testplan zählt](../Arbeitsweise/nur-testplan-zaehlt.md)). `5ab45da9` hat TESTPLAN
berührt, diesen Absatz aber nicht (gemessen am Diff).

**Vorschlag:** *„… macht aus Emoji in 7.2.1.129 weiter `??`. Für `.htm` ist
das im Quellstand behoben (kommt mit dem nächsten Paket); als `.txt` bleibt
es, weil eine windows-1252-Textdatei kein Emoji tragen kann.“*

### <a id="l-111.3"></a>L-111.3 — Gregors Frage zum nächsten Release steht nicht in WEITERMACHEN

**Gewicht: mittel.** `Intern/WEITERMACHEN.md` (ganze Datei, gemessen per
Suche nach „welchen stand“, „veröffentlichen“, „nächste Release“: kein
Treffer zur Frage)

Gregor am 31.10.2026, 22:16, festgehalten nur in
`Arbeitsweise/stand-31-10-2026-abend.md:33`:

> *„wir müssen dann überlegen, welchen stand wir als release auf github
> wieder veröffetnlichen wollen: was muß denn alles enthalten sein, welche
> behebungen sollen drin sein.“*

Daneben steht dort die Vorlage des Hauptagenten. Sie nennt [E-136](../Intern/BEFUNDE.md#e-136) noch
*„kritisch, Datenverlust“*; seit `01daf2b4` ist [E-136](../Intern/BEFUNDE.md#e-136) unkritisch. Nach
`Intern/WEITERMACHEN.md:14` steht, was zu tun ist, *„an genau einer
Stelle“* — in WEITERMACHEN. Eine Standnotiz unter `Arbeitsweise/` ist das
nicht. Eine offene Frage Gregors, die nur dort steht, geht mit dem
nächsten Standwechsel unter (belegt).

**Vorschlag:** in WEITERMACHEN eine Zeile „Gregors Frage vom 31.10.2026:
was gehört ins nächste Release?“ mit Verweis auf die Vorlage. Die Vorlage
dabei auf die heutige Stufe von [E-136](../Intern/BEFUNDE.md#e-136) bringen. Die Frage selbst steht unten
unter „Was nur Gregor entscheiden kann“.

### <a id="l-111.4"></a>L-111.4 — Stufentabelle: „ohne Urteilswort“ ist nirgends erklärt, drei kritische darunter sind erledigt

**Gewicht: Kleinkram.** `Intern/BEFUNDE.md:152-162`

Die Zeile *„| **kritisch** | 10 | 58 | 3 | 71 |“* beantwortet Gregors Frage
*„ist es noch aktuell?“* mit „10 offen, 3 ohne Urteilswort“. Was die dritte
Spalte bedeutet, sagt der Absatz darüber (`:152`) nicht. Erklärt ist sie
nur im Werkzeug (`tools/offene-befunde.pl:386-388`), und dort heißt es
*„(kein Fettdruck, kein Urteilswort)“*. Gemessen haben die drei
kritischen aber beides, nur ein Wort, das nicht in der Liste steht:
[E-3](../Intern/BEFUNDE.md#e-3) *„**bestätigt am 31.08.2026**“* (`:279`; TLS 1.3 bei freenet), [E-23](../Intern/BEFUNDE.md#e-23)
*„**Ursache belegt**, drei Löcher gestopft“* (`:293`; POP3 nur über Port
110), [V-1](../Intern/BEFUNDE.md#v-1) *„**Regel jetzt durchgesetzt**“* (`:264`; zwei ZIPs unter einer
Nummer). Alle 16 Kennungen der Spalte decken sich mit
[PRÜFER-69 K5](PRUEFER-69.md#k5) (gemessen).

Die Werkzeugseite ist in WEITERMACHEN vorgemerkt. Wer die Tabelle in
BEFUNDE liest, erfährt davon nichts.

**Vorschlag:** ein Satz unter dem Block, außerhalb der Marken: *„‚ohne
Urteilswort‘: der Kopf des Urteils trägt keines der Wörter, die das Werkzeug
kennt — am 01.11.2026 waren alle 16 nach dem Wortlaut erledigt
([PRÜFER-69 K5](../Befunde/PRUEFER-69.md#k5)).“* Den Werkzeugkommentar
berichtigt, wer K5 umsetzt.

### <a id="l-111.5"></a>L-111.5 — Rest aus PRÜFER-69 K2: übersprungene Tests zählen als bestanden, nirgends vorgemerkt

**Gewicht: Kleinkram.** `Befunde/PRUEFER-69.md`, K2, „Was zu tun wäre“

K2 schlägt drei Dinge vor. `10102f8d` hat zwei umgesetzt: doppeltes
`TT_EndTest` und Abweichungen außerhalb eines Tests sind jetzt Gerüstfehler
(gemessen am Diff von `Eudora71/Tests/TinyTest.cpp`). Der dritte Vorschlag
fehlt: *„Übersprungene Tests als `[skip]` zählen.“* Er ist weder umgesetzt
(`TinyTest.cpp` kennt kein `skip`, gemessen) noch vorgemerkt (kein Treffer
in WEITERMACHEN, BEFUNDE und WERKZEUGE). Betroffen sind
`TestOTShimAndocken.cpp:602, 609, 625` (*„Test uebersprungen“*, gemessen;
PRÜFER-69 nennt 603/610/626, eine Zeile daneben). Ein solcher Test zählt
als bestanden, obwohl er nichts geprüft hat.

**Vorschlag:** eine Zeile in WEITERMACHEN mit Verweis auf
[PRÜFER-69 K2](PRUEFER-69.md#k2).

### <a id="l-111.6"></a>L-111.6 — Fünf Kleinigkeiten

**Gewicht: Kleinkram.**

1. **[E-165](../Intern/BEFUNDE.md#e-165), Messmarke.** `Intern/BEFUNDE.md:396` *„**Zuletzt gemessen:
   31.10.2026 an 7.2.1.128** (Bau `efcd5945` …)“*. Gregor hat am selben Tag
   an 7.2.1.129 gemessen, das steht im Kopf derselben Zeile. Für einen
   geschlossenen Befund liest kein Werkzeug die Marke; ein Leser wird
   trotzdem stutzen (gemessen).
2. **FAQ 16 an 7.2.1.129.** `Doku/FAQ.md:328` nennt die Bestätigung auch
   an 7.2.1.129. `CHANGELOG.md:116` sagt nur *„von Gregor am 31.10.2026 an
   7.2.1.128 bestätigt“*. `Releases/PAKETE.md:194` („Von Gregor getestet“)
   führt FAQ 16 gar nicht. Belegt ist die Aussage der FAQ nur in
   `Arbeitsweise/stand-31-10-2026-abend.md:27` (gemessen).
3. **64 oder 73.** `Intern/BEFUNDE.md:152`: *„mit 64 kritischen; … gelesen
   wurde sie als 64 zu behebende“*. `tools/WERKZEUGE.md:174`: *„Gregor las
   aus 73 kritischen ‚73 zu beheben‘, wo 11 offen waren“*, ebenso
   `tools/offene-befunde.pl:377-380`. Die Tabelle zeigte 64, gezählt und
   Gregor genannt wurden 73 (`Arbeitsweise/stand-31-10-2026-abend.md:36,
   38`). Beide Stellen erzählen denselben Anlass mit verschiedenen Zahlen
   (gemessen).
4. **ZIEL.md, [E-136](../Intern/BEFUNDE.md#e-136) unter „kritisch“.** `ZIEL.md:68` führt [E-136](../Intern/BEFUNDE.md#e-136) unter
   *„die sechs offenen, als kritisch eingestuften Befunde“*. Der Satz gibt
   die Lage vom 23.10.2026 wieder, also kein Fehler. Ein Halbsatz *„(seit
   31.10.2026 unkritisch, Gregors Entscheidung)“* erspart die Rückfrage
   (belegt).
5. **WEITERMACHEN, Standzeile.** `Intern/WEITERMACHEN.md:3` *„**Stand
   31.10.2026.**“* nennt weder die Herabstufung von [E-136](../Intern/BEFUNDE.md#e-136) noch, dass der
   `.htm`-Weg im Quellstand behoben und noch in keinem Paket ist. Laut
   `Arbeitsweise/stand-31-10-2026-abend.md:31` ist er auch noch nicht
   gebaut (*„TridentReadMessageView.cpp geaendert, ungebaut!“*). Ob seither
   gebaut wurde, ist nicht geprüft (gemessen / Vermutung).

## Bestand

Die 64 Dateien aus `git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/`
habe ich nach Aussagen über den heutigen Stand durchsucht: Fassungen,
„veröffentlicht“, [E-136](../Intern/BEFUNDE.md#e-136), [E-165](../Intern/BEFUNDE.md#e-165), offene Zahlen, Zweignamen. Seit `99f0a36`
geändert sind nur `CHANGELOG.md`, `Doku/FAQ.md`, `Intern/AUFGABEN.md`,
`Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`,
`README.md`, `ZIEL.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`,
`tools/AGENTEN-LAUFEN.md` und der neue Bericht `Befunde/PRUEFER-69.md`
(gemessen). Außerhalb der Funde oben habe ich keine Aussage gefunden, die
nicht mehr stimmt. Die übrigen Dateien sind seit dem letzten Bestand
unverändert. Sie nennen 7.2.1.129 nicht, und das ist richtig, solange
7.2.1.128 die veröffentlichte Fassung ist.

`tools/ZWEIGE.md:201` führt `e165_schliessen_e136_speichern_unter` mit
Gregors Ja (*„ja, branch name ok“*), stimmt mit dem Zweig auf `origin`
(gemessen).

## Werkzeuge

`perl tools/doku-pruefen.pl` (Exit 0, gemessen):

```
  Quellstand                   7.2.1.129
  Paketnummer                  7.2.1.129
  Kriterien in ZIEL.md         9
  gepruefte Dateien            50
  Kennungen im Verzeichnis     166
  Abschnitte in Intern/BEFUNDE.md 14
  ------------------------------------------------------------
  Kein Widerspruch gefunden.
```

„Zur Kenntnis“: 19 Dateien ohne die Fassung 7.2.1.129, darunter
`Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` (höchste genannte Fassung
7.2.1.128). In [LEKTOR-110](LEKTOR-110.md) waren es 20; `ZIEL.md` steht nicht mehr
darin, es nennt 7.2.1.129 seit `5ab45da9` (gemessen).

`perl tools/offene-befunde.pl` (Exit 0, gemessen):

```
    offen laut Intern/BEFUNDE.md  43
      davon aktuell gemessen       4  (ab Nummer 124)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          13
    in Intern/WEITERMACHEN.md     43

  43 offene Befunde, in beiden Listen gleich.
```

Gegenüber [LEKTOR-110](LEKTOR-110.md): 42 → 43 offen, „veraltet“ 25 → 26. Beides geht
auf [E-136](../Intern/BEFUNDE.md#e-136) zurück: am 31.10.2026 fiel es wegen des Kursivs im Kopf aus der
Liste, `0cc40bfc` hat es zurückgeholt. [E-165](../Intern/BEFUNDE.md#e-165) ist seither geschlossen
(gemessen am Commitverlauf; die Zuordnung der Zahlen ist Vermutung).

`perl tools/pruefe-regressionstest.pl` (Exit 0, gemessen, Auszug):

```
    Befunde insgesamt            223
    davon mit Testfall           106
    behoben und OHNE Testfall     50   <- Rueckstand
    kritisch    71   wichtig     67   unkritisch  40   werkzeug    45
    OHNE jede Pruefung            10   <- Rueckstand
      AN-1 E-122 E-123 E-124 E-126 E-129 E-172 E-170 E-133 E-39
  Kein neues "behoben" ohne Regressionstest.
```

`perl tools/ziel-stand.pl` (Exit 0, gemessen):
*„ziel-stand: 27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

`perl tools/pruefe-befundurteile.pl` (Exit 0, gemessen): *„davon behoben
118“*, *„Kein Dokument erklaert einen offenen Befund fuer erledigt“*.

## Was nur Gregor entscheiden kann

1. **Was ins nächste Release auf GitHub gehört.** Deine Frage vom
   31.10.2026 ist offen ([L-111.3](#l-111.3)). Seit `v7.2.1.128` sind von dir bestätigt:
   [E-139](../Intern/BEFUNDE.md#e-139) (Rechtschreibhinweis abschaltbar), [E-165](../Intern/BEFUNDE.md#e-165) (Vervollständigungsbox)
   und der Antwortweg mit Original-HTML. Gemessen, aber nicht von dir
   getestet: [E-140](../Intern/BEFUNDE.md#e-140) (Zeichensatzangabe bei *Speichern unter*) und [E-171](../Intern/BEFUNDE.md#e-171)
   (Suche ohne Markierung), dazu [E-144](../Intern/BEFUNDE.md#e-144) und [E-145](../Intern/BEFUNDE.md#e-145). Offen und auf deine
   Entscheidung jetzt unkritisch: [E-136](../Intern/BEFUNDE.md#e-136) (Emoji beim Speichern). Sein
   `.htm`-Weg ist nur im Quellstand behoben und steckt in keinem Paket.
   Zu entscheiden: Release erst nach deiner Messung von [E-136](../Intern/BEFUNDE.md#e-136) am nächsten
   Paket, oder vorher, mit [E-136](../Intern/BEFUNDE.md#e-136) unter „Bekannte Fehler“ in der README?
