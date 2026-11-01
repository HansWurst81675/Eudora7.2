# <a id="pruefer-69"></a>PRUEFER-69 — Prüfung des zweiten E-136-Speicherwegs, des Testgerüsts und der Stufentabelle, 01.11.2026

**Auftrag.** Alles, was seit `13b1396` unter `Eudora71`, `tools` und
`Releases/1.0` dazukam (`git log 13b1396..HEAD`, Stand `380b07b3`): drei
Commits. `b106664e` ([E-136](../Intern/BEFUNDE.md#e-136), zweiter Speicherweg),
`ddc81808` (`TinyTest.cpp`, `tools/fettstellen.pl`) und `380b07b3`
(Stufentabelle in `offene-befunde.pl`). Unter `Releases/1.0` hat sich nichts
geändert.

Eudora wurde weder gebaut noch gestartet. Gebaut und gefahren habe ich nur
die Testsuite im Arbeitsbaum `.wt/pruefer` (`Eudora71\Tests\RunTests.cmd`).
Grundlauf: **350 Tests, 350 bestanden**, 350 Zeilen `[ok  ]`, keine davon
ohne Namen (gemessen). Für die zwei Gegenproben unten habe ich Quelldateien
per Perl (`<:raw`, je 1 Treffer) verändert und danach aus Kopien
zurückgeschrieben. `cmp` gegen die Kopien war jedes Mal gleich, `git status`
danach leer.

Jede Aussage trägt ihre Herkunft: **gemessen**, **am Quelltext belegt**
(Datei:Zeile) oder **Vermutung**.

**Ergebnis vorweg.**

* **Der zweite Speicherweg von [E-136](../Intern/BEFUNDE.md#e-136) ist richtig und vollständig.**
  *Speichern unter* als `.htm` ohne Kopfzeilen läuft jetzt über dieselbe
  Umwandlung wie *Strg-S*. Damit gehen alle drei Wege, auf denen Eudora HTML
  aus der Anzeige in eine Datei schreibt, über `E136HtmlAusBstr`. Weitere
  Speicherwege mit der alten Umwandlung habe ich nicht gefunden. Übrig sind
  nur die schon bekannten Grenzen (`.txt`, Kopfzeilen) und die
  Formatierbefehle aus [E-178](../Intern/BEFUNDE.md#e-178).
* **Das Testgerüst zählt einen vergessenen Testabschluss jetzt richtig als
  Fehler.** Ein Test mit Abweichung, der nicht ordentlich endet, wird einmal
  gezählt, nicht zweimal (gemessen). Blind bleibt es für einen **doppelten**
  Abschluss. Dann zählt ein roter Test zweimal, und ein grüner Test erzeugt
  eine namenlose `[ok  ]`-Zeile, ohne dass es jemand merkt (gemessen,
  [K2](#k2)). Das ist harmlos: kein roter Test wird dadurch grün.
* **Die neue Lesart des Fettgedruckten liest kein Urteil falsch, das vorher
  richtig gelesen wurde.** Gemessen habe ich mit allen drei Werkzeugen, je
  einmal mit dem alten und einmal mit dem neuen Muster, auf Kopien des
  Repos. Die Liste der offenen Befunde, `WEITERMACHEN.md` und `ZIEL.md` sind
  gleich. Anders sind nur vier Urteile, die vorher gar nicht gelesen wurden
  und jetzt als erledigt zählen. Das neue Muster liest in 19 Zeilen aber
  Fließtext als fett ([K4](#k4)). Heute hat das keine Folgen.
* **Die Stufentabelle stimmt mit `pruefe-regressionstest.pl` überein**
  (223 / 71 / 67 / 40, gemessen). Unter „ohne Urteilswort“ stehen aber
  Befunde, die beim Lesen erledigt sind, darunter drei kritische
  ([K5](#k5)).
* **Die Tests bewachen den neuen Weg so schwach wie den alten.** Gemessen:
  eine zweite, verlustbehaftete Zuweisung hinter der neuen Zeile in
  `GetMessageBody` lässt alle Tests grün ([K1](#k1)). Das ist dieselbe Lücke
  wie in [PRÜFER-68](PRUEFER-68.md) K6 (siehe [K1](#k1)).
* **In `Intern/BEFUNDE.md` widerspricht sich der Eintrag zu [E-136](../Intern/BEFUNDE.md#e-136):** Er
  nennt den zweiten Weg „behoben“ und drei Sätze weiter noch offen. Die
  Zeilennummern in [E-178](../Intern/BEFUNDE.md#e-178) liegen seit `b106664e` um 11 daneben ([K3](#k3)).

**Hält etwas das nächste Paket auf?** Nein. Alle fünf Funde sind niedrig.
Keiner betrifft das Verhalten von Eudora. Sie betreffen Tests, Werkzeuge
und Doku.

## <a id="k1"></a>K1 — Der Test für `GetMessageBody` bleibt bei einer zweiten Zuweisung grün

**Gemessen (Gegenprobe 1).** In `TridentReadMessageView.cpp` habe ich hinter
dem neuen `if( bAsHTML ) … else szMsg = cbstr;` eine Zeile eingesetzt:

    szMsg = cbstr;

Damit macht *Speichern unter* `.htm` das Emoji wieder zu `??`, genau wie vor
`b106664e`. Ergebnis: `[ok  ] [E-136](../Intern/BEFUNDE.md#e-136) (Quelltext): Strg-S und GetAllHTML
wandeln ueber E136HtmlAusBstr`. Der Test blieb grün. (Die Gesamtzahl des
Laufs war 349/1, aber nur wegen der zweiten Gegenprobe, die im selben Bau
steckte, siehe [K2](#k2).)

**Am Quelltext belegt.** `TestE136.cpp` prüft mit `QT_Enthaelt`, dass der
genaue Text `if( bAsHTML ) szMsg = E136HtmlAusBstr( (BSTR) cbstr ); else szMsg = cbstr;`
dasteht. Ein Verbot wie bei `SaveInfo` (`!QT_Enthaelt(pR, "szBody = cbstr;")`)
geht hier nicht, weil der `else`-Zweig dieselbe Zeichenfolge legitim enthält.
Zwei Folgen:

* Eine zusätzliche Zuweisung danach fällt nicht auf (gemessen, oben).
* Umgekehrt wird die gleichwertige Schreibweise
  `szMsg = bAsHTML ? E136HtmlAusBstr( (BSTR) cbstr ) : CString( cbstr );`
  rot. Genau diese Schreibweise hatte [PRÜFER-68](PRUEFER-68.md) K1
  vorgeschlagen. Das ist ein Fehlalarm, also die harmlose Richtung.

**Was zu tun wäre:** den Abschnitt von `get_htmlText` bis `return TRUE;`
schneiden (`QT_Abschnitt`) und darin genau zwei `szMsg =` verlangen, davon
eines mit `E136HtmlAusBstr`. Dasselbe gilt für `GetAllHTML`
([PRÜFER-68](PRUEFER-68.md) K6, noch offen). **Schwere:** niedrig, nur
Tests.

## <a id="k2"></a>K2 — Testgerüst: ein doppeltes `TT_EndTest` zählt doppelt oder gar nicht

**Was die Behebung leistet, gemessen (Gegenprobe 2, zwei Läufe).**

| Fall (eingesetzt) | Zeilen im Protokoll | Zählung | richtig? |
|---|---|---|---|
| `TestE165`: Abweichung, **kein** `TT_EndTest` | `[FEHL] E-165 …`, `^-- FEHLGESCHLAGEN: ohne TT_EndTest verlassen (bemerkt in TT_BeginTest) - 1 Abweichung(en)` | **1** | ja, keine Doppelzählung |
| `TT_CHECK_MSG(0, …)` hinter dem letzten `TT_EndTest` von `TestE171` | `[FEHL] (ausserhalb eines Tests) GEGENPROBE …` | **1**, Rückgabe 1 | ja |
| `TestE171`: Abweichung, dann **zweimal** `TT_EndTest` | `^-- FEHLGESCHLAGEN: 1 Abweichung(en)` **zweimal** | **2** für einen Test | **nein** |
| `TestE171` grün, dann **zweimal** `TT_EndTest` | zusätzlich `[ok  ] ` **ohne Namen** | 0, keine Meldung | **nein, blind** |

Lauf A (Abweichung außerhalb und doppeltes Ende nach grünem Test):
`350 Tests, 349 bestanden, 1 fehlgeschlagen`, dabei aber **351** Zeilen
`[ok  ]`. Lauf B (fehlendes Ende mit Abweichung und doppeltes Ende nach rotem
Test): `350 Tests, 347 bestanden, 3 fehlgeschlagen` für **zwei** rote Tests.

**Am Quelltext belegt.** `TT_EndTest` (`TinyTest.cpp:106-122`) fragt
`s_bOffen` nicht ab. `s_iChecksFailed` wird nur in `TT_BeginTest` (`:99`)
zurückgesetzt, ein zweiter Aufruf sieht also die Abweichungen des vorigen
Tests noch einmal. Eine Abweichung außerhalb eines Tests erhöht
`s_iFailedTests` (`:131`), aber nicht `s_iTests`. Darum zeigt die Summe
„349 bestanden“, obwohl alle 350 Tests mit Namen grün sind. Bei vielen
solchen Abweichungen kann „bestanden“ sogar negativ werden.

**Gegen `pruefe-tests-gruen.pl` gehalten (belegt):** Die Schranke liest nur
die Ergebniszeile und den Rückgabewert (`urteil`, `pruefe-tests-gruen.pl`).
Zeilen zählt sie nicht. In keinem der vier Fälle wird damit ein roter Lauf
grün gemeldet; die Richtung ist sicher. Der Abgleich „gemeldete Tests
gegen Zeilen im Protokoll“, mit dem [PRÜFER-68](PRUEFER-68.md) die neun
offenen Tests gefunden hat, ist aber weiterhin Handarbeit. Und er stimmt
jetzt auch bei einem sauberen roten Lauf nicht mehr, sobald eine Abweichung
außerhalb eines Tests dabei ist.

**Weiter blind, alt (belegt):** Ein Test, der sich selbst überspringt, zählt
als bestanden: `TestOTShimAndocken.cpp:603/610/626` (`TT_Note("… - Test
uebersprungen"); TT_EndTest(); return;`). Gemessen habe ich, dass jede
`Run…Tests`-Funktion aus `TestMain.cpp` aufgerufen wird und jede statische
Testfunktion aus ihrer Datei. Ein vergessener Aufruf ist heute also nicht
dabei.

**Was zu tun wäre:** In `TT_EndTest` bei `!s_bOffen` den Aufruf als Fehler
des Gerüsts melden und zurückkehren. Abweichungen außerhalb eines Tests als
eigene Zahl in der Summe ausweisen statt von „bestanden“ abziehen.
Übersprungene Tests als `[skip]` zählen. **Schwere:** niedrig, nur Tests.

## <a id="k3"></a>K3 — `BEFUNDE.md`: E-136 widerspricht sich, E-178 nennt verschobene Zeilen

**Am Quelltext belegt** (`Intern/BEFUNDE.md:423`). Der Eintrag zu [E-136](../Intern/BEFUNDE.md#e-136) sagt
zuerst: *„Zweiter Weg (PRÜFER-68 K1) — für `.htm` im Quellstand behoben am
31.10.2026“*. Gleich danach steht noch der alte Satz: *„… läuft über
`GetMessageBody`, und dort steht noch `szMsg = cbstr` … — Emoji werden dort
weiter `??`“*. Unter „Was noch fehlt“ steht weiter *„K1 beheben“*. Wer nur
den zweiten Satz liest, hält den Weg für offen. Richtig ist: offen ist nur
`.txt`, und das ist als Grenze vermerkt.

**Gemessen.** `b106664e` hat in `TridentReadMessageView.cpp` 11 Zeilen vor
den Stellen aus [E-178](../Intern/BEFUNDE.md#e-178) eingefügt. Dort stehen `3207, 3217, 3338, 3408, 3411, 3621,
4058`, heute sind es `3218, 3228, 3349, 3419, 3422, 3632, 4069`. Nur `2679`
stimmt noch. Mein eigener Bericht [PRÜFER-68](PRUEFER-68.md) K2 nennt
dieselben alten Nummern. Funktionsnamen (`ExpandTag`, `SplitTagOff`,
`WrapTag`) wären haltbarer. **Schwere:** niedrig, Doku. Das ist Sache von
LEKTOR.

## <a id="k4"></a>K4 — `fettstellen.pl`: bei verschachteltem Fett wird Fließtext zur Fettstelle

**Gemessen** über alle 3222 Tabellenzellen von `Intern/BEFUNDE.md`, altes
gegen neues Muster:

* **Erste Fettstelle anders:** in der Urteilsspalte genau [E-89](../Intern/BEFUNDE.md#e-89), [E-137](../Intern/BEFUNDE.md#e-137), [E-138](../Intern/BEFUNDE.md#e-138)
  und [E-158](../Intern/BEFUNDE.md#e-158). Das deckt sich mit der Commit-Nachricht. Alle vier lasen vorher
  ein Stück aus der Mitte („Ursache:“, „Was es ist:“ …) und jetzt richtig
  ihren Kopf. Dazu kommen vier Zellen der Beschreibungsspalte ([E-38](../Intern/BEFUNDE.md#e-38), [E-115](../Intern/BEFUNDE.md#e-115),
  [E-173](../Intern/BEFUNDE.md#e-173), [E-177](../Intern/BEFUNDE.md#e-177)), die kein Werkzeug als Urteil liest.
* **Spätere Fettstellen anders:** in 19 Urteilen. In mehreren, etwa [E-112](../Intern/BEFUNDE.md#e-112),
  [E-123](../Intern/BEFUNDE.md#e-123), [E-133](../Intern/BEFUNDE.md#e-133), [E-165](../Intern/BEFUNDE.md#e-165) und [E-117](../Intern/BEFUNDE.md#e-117), verrutscht die Paarung: Was **zwischen** zwei
  Fettstellen steht, gilt dann als fett. Beispiel [E-133](../Intern/BEFUNDE.md#e-133): neu als „fett“
  gelesen wird *„der Befund bleibt offen, auf Gregors Entscheidung hin nicht
  behoben.“* Das ist Fließtext. Ursache ist Fett im Fett (`**offen … hin
  **offen gelassen** (…)**`) oder `***` als Grenze. Das alte Muster
  verrutschte an solchen Stellen auch, nur anders.

**Gemessen, Wirkung auf die Werkzeuge:** Ich habe `offene-befunde.pl
-schreiben`, `ziel-stand.pl -schreiben` und `pruefe-befundurteile.pl` in zwei
Kopien des Repos laufen lassen, eine mit altem und eine mit neuem Muster in
`fettstellen.pl`. `WEITERMACHEN.md` und `ZIEL.md` sind byte-gleich, die
Liste der offenen Befunde ist gleich. Der einzige Unterschied: 4 wichtige
Befunde wandern in der Stufentabelle von „ohne Urteilswort“ zu „erledigt“,
und `pruefe-befundurteile` zählt 118 statt 114 behobene. **Kein Urteil wird
jetzt falsch gelesen, das vorher richtig gelesen wurde.**

**Warum es trotzdem ein Fund ist (Vermutung zur Zukunft, am Quelltext
belegt):** `offene-befunde.pl` hält einen Befund offen, wenn irgendwo im
Fettgedruckten „bleibt offen“ steht (`$bleibt_offen`, aus `$alle`). Durch
das Verrutschen kann das künftig aus Fließtext kommen. Das irrt in die
sichere Richtung: ein erledigter Befund bliebe auf der Liste, keiner fiele
heraus. Einen Befund *schließen* kann nur die erste Fettstelle, und die ist
gegen das Verrutschen weitgehend sicher. Der Selbsttest von `fettstellen.pl`
hat keinen Fall mit Fett im Fett. **Schwere:** niedrig, Werkzeug.

## <a id="k5"></a>K5 — Stufentabelle: „ohne Urteilswort“ enthält Erledigtes

**Gemessen** mit einer Kopie von `offene-befunde.pl` und einer zusätzlichen
Ausgabezeile: Die 16 Kennungen unter „ohne Urteilswort“ und ihr Kopf sind

| Stufe | Kennung, Kopf des Urteils |
|---|---|
| kritisch | [E-3](../Intern/BEFUNDE.md#e-3) *„bestätigt am 31.08.2026“*, [E-23](../Intern/BEFUNDE.md#e-23) *„Ursache belegt“* (… drei Löcher gestopft, Regressionstest), [V-1](../Intern/BEFUNDE.md#v-1) *„Regel jetzt durchgesetzt“* |
| wichtig | [E-38](../Intern/BEFUNDE.md#e-38) *„kein Fehler“*, [E-95](../Intern/BEFUNDE.md#e-95), [E-96](../Intern/BEFUNDE.md#e-96), [E-118](../Intern/BEFUNDE.md#e-118) *„BESTÄTIGT von Gregor …“* |
| unkritisch | [E-1](../Intern/BEFUNDE.md#e-1), [E-8](../Intern/BEFUNDE.md#e-8) *„Beleg“* |
| werkzeug | [PR-1](../Intern/BEFUNDE.md#pr-1), [PR-2](../Intern/BEFUNDE.md#pr-2), [Z-1](../Intern/BEFUNDE.md#z-1) *„Bericht“*; [P-2.1](../Intern/BEFUNDE.md#p-2.1), [P-2.2](../Intern/BEFUNDE.md#p-2.2), [B-2.2](../Intern/BEFUNDE.md#b-2.2), [B-2.5](../Intern/BEFUNDE.md#b-2.5) (Zeilen aus der Tabelle „Falsch“ einer Nachprüfung, die Spalte 3 ist dort „tatsächlich“, kein Urteil) |

**Am Quelltext belegt.** Die Wörter „bestätigt“ und „kein Fehler“ stehen
nicht in `@erledigt_wort`. Kennungen mit Punkt erreicht die erste Schleife
nie (`$kennung`, `offene-befunde.pl:95`). Die zweite Schleife nimmt sie nur
für die Stufe auf, darum können sie nie „erledigt“ werden.

Die Tabelle ist damit ehrlich: Sie schlägt nichts still einer Seite zu, und
das war die Absicht. Gregors Frage *„wie viele kritische sind offen?“*
beantwortet sie aber mit „10 offen, 3 ohne Urteilswort“. Wer nachfragt,
findet drei erledigte. Abhilfe: entweder die Wörter aufnehmen und dabei
gegen die Offen-Liste messen, oder die drei kritischen Urteile mit einem
Erledigt-Wort beginnen lassen. **Schwere:** niedrig, Auskunft.

**Gegenvermutungen, verworfen (gemessen):** Eine Zeile mit zwei
verschiedenen `**Stufe: …**`-Marken, bei der „erste Marke gewinnt“ falsch
wäre, gibt es nicht. Ebenso keine Marke außerhalb der Urteilsspalte. Die
Gesamtzahlen 223 / 71 / 67 / 40 stimmen mit `pruefe-regressionstest.pl`
überein.

## <a id="haelt"></a>Was hält

**[E-136](../Intern/BEFUNDE.md#e-136), zweiter Weg** (`TridentReadMessageView.cpp:2913-2928`):

* **Richtiger Zweig:** `bAsHTML` ist derselbe Schalter, der zwei Zeilen
  höher zwischen `get_htmlText` und `get_text` wählt (`:2904-2911`). HTML
  bekommt Entitäten, Text nicht (belegt).
* **Wer ruft `GetMessageBody`?** Nur `GetMessageAsHTML` (`:2943`) und
  `GetMessageAsText` (`:2955`). `GetMessageAsHTML` der Leseansicht ruft nur
  `CReadMessageDoc::SaveAsFile` (`ReadMessageDoc.cpp:626`). Die Änderung
  wirkt also genau auf *Speichern unter* `.htm` und sonst nirgends. Plug-ins
  und Übersetzer gehen über `GetMessageAsText` oder `GetAllHTML` und sind
  davon nicht berührt (belegt, `Trnslate.cpp:4160`, `QCPluginCommand.cpp:156`).
* **Alle HTML-Speicherwege:** `SaveInfo` (`:1894`, Strg-S), `GetAllHTML`
  (`TridentView.cpp:4112`, `.htm` mit Kopfzeilen) und jetzt `GetMessageBody`
  (`:2924`, `.htm` ohne Kopfzeilen). *Speichern unter* aus der Postfachliste
  schreibt aus dem Dokument, nicht aus der Anzeige, und bietet kein `.htm`
  an (`tocview.cpp:3019`ff., Kommentar dort). Das Verfassen-Fenster hat eine
  Paige-Ansicht, keine Trident-Ansicht (`compmsgd.cpp:3399`ff. über
  `PgCompMsgView`). Belegt.
* **Übrig, alles schon bekannt:** `.txt` mit und ohne Kopfzeilen
  (`TridentView.cpp:3983`, `TridentReadMessageView.cpp:2926`), die
  Kopfzeilen in `SaveInfo` (`:1883-1884`, `get_text`, in [E-136](../Intern/BEFUNDE.md#e-136) vermerkt) und
  die Formatierbefehle aus [E-178](../Intern/BEFUNDE.md#e-178). Die übrigen `= cbstr` in beiden Dateien
  (über 40 Stellen) sind Tagnamen, Attributwerte und Verweisziele, keine
  Nachrichtentexte (belegt, durchgesehen).
* **Nebenbei, alt, Vermutung:** Die `.htm`-Datei ohne Kopfzeilen ist ein
  HTML-Bruchstück ohne `<meta charset>`. Umlaute stehen als windows-1252-Bytes
  darin, und der Browser muss den Zeichensatz raten. Die neuen Entitäten
  sind reines ASCII und davon nicht betroffen. Das ist kein Fund dieser
  Behebung.

**`TinyTest.cpp`:** Keine Doppelzählung bei einem offenen Test mit
Abweichungen; die `[FEHL]`-Zeile erscheint dabei nur einmal (`:84` fragt
`s_iChecksFailed` ab). Die Notizen des offenen Tests werden ausgegeben, und
der Name wird geleert. Die Abweichung außerhalb eines Tests wird gezählt,
die Rückgabe ist ungleich null. Alles gemessen, siehe [K2](#k2).

**`fettstellen.pl` im Einsatz:** In `pruefe-befundurteile.pl` liefert
`if (my ($kopf) = fettstellen(…))` in skalarem Zusammenhang die Zahl der
Treffer. Die Bedingung ist also richtig. Neu wird dort auch die leere
Fettstelle aus `*** **` verworfen, wie in den beiden anderen Werkzeugen
schon vorher (belegt). Der Selbsttest läuft grün, einschließlich der
Gegenprobe gegen das alte Muster (laut Commit; die Wirkung habe ich
stattdessen an den Werkzeugen selbst gemessen, siehe [K4](#k4)).

**Stufentabelle:** Beim Schreiben wird die Zahl der CRLF vorher und nachher
verglichen (`offene-befunde.pl`, Block „Stufentabelle“). Fehlen die Marken,
bricht das Werkzeug mit Meldung ab, statt den Block anzuhängen (belegt). Ob
die Tabelle auf dem Stand ist, prüft es vor dem Abgleich mit
`WEITERMACHEN.md`. Bei veralteter Tabelle erscheint darum zuerst nur diese
Meldung. Das ist eine Frage der Reihenfolge, kein Fehler.

## Neue Kennungen

Keine. K1 und K2 gehören zu den Tests ([PRÜFER-68](PRUEFER-68.md) K6), K3 ist
Doku für LEKTOR, K4 und K5 betreffen Werkzeuge. Die mir zugeteilten
Kennungen E-180 und E-181 habe ich nicht verwendet. In `Intern/BEFUNDE.md`
habe ich nichts eingetragen.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | 350/350 im Grundlauf. Der zweite Speicherweg von [E-136](../Intern/BEFUNDE.md#e-136) ist richtig und vollständig: alle drei HTML-Speicherwege laufen über `E136HtmlAusBstr`, keine weitere Stelle gefunden. Das Testgerüst zählt einen vergessenen Abschluss einmal. `fettstellen.pl` liest kein Urteil neu falsch (gemessen mit allen drei Werkzeugen). | keine | nein |
| [K1](#k1) | Eine zweite Zuweisung `szMsg = cbstr;` hinter der neuen Zeile in `GetMessageBody` lässt alle Tests grün (Gegenprobe). | niedrig (nur Tests) | nein |
| [K2](#k2) | Doppeltes `TT_EndTest`: rot zählt doppelt, grün erzeugt eine namenlose `[ok  ]`-Zeile ohne Meldung. Eine Abweichung außerhalb eines Tests senkt „bestanden“. Übersprungene Tests zählen als bestanden. | niedrig (nur Tests, sichere Richtung) | nein |
| [K3](#k3) | `BEFUNDE.md`: [E-136](../Intern/BEFUNDE.md#e-136) nennt den zweiten Weg zugleich behoben und offen. Die Zeilennummern in [E-178](../Intern/BEFUNDE.md#e-178) liegen um 11 daneben. | niedrig (Doku) | nein |
| [K4](#k4) | `fettstellen.pl`: Bei Fett im Fett liest das neue Muster in 19 Urteilen Fließtext als fett. Heute ohne Wirkung (gemessen); künftig nur in die sichere Richtung (bleibt offen). | niedrig (Werkzeug) | nein |
| [K5](#k5) | Stufentabelle: unter „ohne Urteilswort“ stehen 16 Kennungen, darunter erledigte ([E-3](../Intern/BEFUNDE.md#e-3), [E-23](../Intern/BEFUNDE.md#e-23), [V-1](../Intern/BEFUNDE.md#v-1) kritisch; „bestätigt“, „kein Fehler“ fehlen in der Wortliste; Kennungen mit Punkt können nie „erledigt“ werden). | niedrig (Auskunft) | nein |
