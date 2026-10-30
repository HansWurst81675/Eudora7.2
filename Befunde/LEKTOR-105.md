# <a id="lektor-105"></a>LEKTOR-105 — Bestand nach cf45bc19

**Datum:** 30.10.2026 · **Geprüft:** Commit `cf45bc19` auf `wt/lektor-20261030` (abgezweigt von `fortsetzen_status_nie_gemessen`), im Arbeitsbaum `.wt/lektor`

**Auftrag.** Voller Lauf: Funde aus [LEKTOR-104](LEKTOR-104.md#lektor-104)
nachsehen, dann den Bestand der MDs (ohne `Arbeitsweise/` und `Befunde/`)
gegen den heutigen Stand lesen. Schwerpunkt: die sieben Commits seit
`c28f8801` — [E-145](../Intern/BEFUNDE.md#e-145), [E-141](../Intern/BEFUNDE.md#e-141), [E-144](../Intern/BEFUNDE.md#e-144), [E-176](../Intern/BEFUNDE.md#e-176), `bauen.ps1` findet `perl`, die
Rollenbäume unter `.wt/<name>`. **Alle Zeilenangaben gelten für
`cf45bc19`.** Nichts gebaut, nichts gestartet. **In diesem Bericht steht
nichts aus Gregors Rechner oder Postfach.**

**Ergebnis vorweg.** Von den fünf Funden aus [LEKTOR-104](LEKTOR-104.md#lektor-104) sind alle fünf
erledigt. **Sechs neue Funde.** Der wichtigste: Die erzeugte Liste der
offenen Befunde sagt bei [E-141](../Intern/BEFUNDE.md#e-141) (IMAP nach `Out` löst einen Expunge aus) und
[E-176](../Intern/BEFUNDE.md#e-176) (Lesen aus freigegebenem Speicher beim Schließen einer neuen
Nachricht) unter *„was noch fehlt“*, man solle den Quelltext berichtigen.
Das ist schon geschehen. Was wirklich fehlt — die Messung am Programm —
steht dort nicht ([L-105.1](#l-105.1)). Zweitens: Der einzige
aufgezeichnete Lauf des neuen Prüfstandsfalls zu [E-144](../Intern/BEFUNDE.md#e-144) ist **rot**, und das
Ergebnisbuch führt [E-125](../Intern/BEFUNDE.md#e-125)c weiter als rot. Keine Doku sagt das
([L-105.3](#l-105.3)). Die Verlegung der Rollenbäume ist sauber
nachgezogen; den alten Ort nennt keine Anleitung mehr als gültig.

## Funde aus LEKTOR-104

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-104.1](LEKTOR-104.md#l-104.1) | Filter mit *„doesn't appear“* verschiebt in 7.2.1.128 jede Nachricht; fehlte unter „Bekannte Fehler“ | **erledigt** | `README.md:155` *„Bis 7.2.1.128: ein Filter mit einer verneinten Bedingung trifft jede Nachricht“*; `Intern/BEFUNDE.md:319` nennt vorn *„in keinem Paket — 7.2.1.128 trägt diesen Fehler noch“* (gemessen) |
| [L-104.2](LEKTOR-104.md#l-104.2) | TESTPLAN-Schritt lässt alle manuellen Filter mitlaufen | **erledigt** | `Intern/TESTPLAN.md:27-30` bindet „verschoben wird nichts“ an *Manual*; Schritt 0 (`:33-36`) und 7 (`:48`); Strg+J gestrichen (`:40-42`) (gemessen) |
| [L-104.3](LEKTOR-104.md#l-104.3) | elf neue Regressionstests in keinem Dokument | **erledigt** | `CHANGELOG.md:124` nennt alle elf und *„337 Tests, 337 bestanden“*; `Intern/WEITERMACHEN.md:33` ebenso; Vermerk **Regressionstest** in `Intern/BEFUNDE.md:225, 284, 304, 305, 322, 333, 350, 361, 432, 434, 436` (gemessen, je ein Treffer) |
| [L-104.4](LEKTOR-104.md#l-104.4) | ZIEL.md nennt „97 ohne jede Prüfung“ im Präsens | **erledigt** | `ZIEL.md:161` und `:181` verweisen auf `pruefe-regressionstest.pl`; die 97 stehen nur noch in der datierten Tabelle `:142-149` (gemessen) |
| [L-104.5](LEKTOR-104.md#l-104.5) | BEFUNDE.md sagt, die Release-Notizen nennen den Rückstand | **erledigt** | `Intern/BEFUNDE.md:160` *„die Release-Notizen zu 7.2.1.128 nennen ihn **nicht**“* und *„Das war der Rückstand am 22.10.2026“* (gemessen) |

## Neue Funde

### <a id="l-105.1"></a>L-105.1 — Die Liste „was noch fehlt“ verlangt bei E-141 und E-176 eine Behebung, die schon da ist

**Gewicht: falsche Handlungsanweisung im erzeugten Block.** `CHANGELOG.md:30`, `:43`; `Intern/WEITERMACHEN.md:77`, `:90`; Quelle `Intern/BEFUNDE.md:377`, `:383`

Worum es geht: Wer die Liste der offenen Befunde liest, bekommt gesagt, er
solle zwei Fehler im Quelltext beheben. Beide sind seit heute behoben. Die
Messung am Programm, die wirklich fehlt, steht dort nicht.

> `CHANGELOG.md:21` *„Die Spalte **was noch fehlt** sagt, was zu tun bleibt —
> nicht, was schon erledigt ist.“*
>
> `CHANGELOG.md:43` ([E-141](../Intern/BEFUNDE.md#e-141)): *„die Berichtigung in `tocdoc.cpp:3134` — die
> Klammer um den Oder-Teil ziehen …“*
>
> `CHANGELOG.md:30` ([E-176](../Intern/BEFUNDE.md#e-176)): *„der Rückzeiger muss mit der Zusammenfassung
> sterben — `~CSummary` löscht `m_pSumBackPtr` im Rahmen …“*

Beides ist in `ca1b455b` und `45aa451c` geschehen
(`Eudora71/Eudora/tocdoc.cpp:3171` mit der neuen Klammer,
`summary.cpp` ruft `CMessageFrame::E176ZusammenfassungStirbt(this)`; belegt
am Diff). Das Werkzeug `offene-befunde.pl` schreibt die Spalte aus dem
Absatz **„Was noch fehlt:“** im Urteil. Dort steht in `BEFUNDE.md:377`
([E-141](../Intern/BEFUNDE.md#e-141)) weiter *„**Was noch fehlt:** die Berichtigung in
`tocdoc.cpp:3134`“* und in `:383` ([E-176](../Intern/BEFUNDE.md#e-176)) *„**Was noch fehlt:** der
Rückzeiger muss mit der Zusammenfassung sterben …; dazu ein Test, der
`CSummary` und Rahmen echt anlegt“*. Vorn in denselben Zellen steht
richtig *„im Quellstand am 30.10.2026 berichtigt“*. **Belegt.**

Was wirklich fehlt, steht nur im Fließtext: bei [E-141](../Intern/BEFUNDE.md#e-141) die Messung am
IMAP-Prüfserver samt Gegenprobe *IMAP → Trash* und *IMAP → lokal*
(`:377` *„das gehört an den IMAP-Prüfserver, bevor hier „behoben“
steht“*). Bei [E-176](../Intern/BEFUNDE.md#e-176) ein Test, der `CSummary` und Rahmen wirklich anlegt.
`TestE176.cpp:28-41` sucht nur Zeichenketten im Quelltext
(`QT_Enthaelt`). Dieser Rest ist also noch offen. **Gemessen.**

Genau dieser Fehler hat zu [E-85](../Intern/BEFUNDE.md#e-85) geführt
(`CLAUDE.md`, Abschnitt 1), nur umgekehrt: Wer der Liste folgt, macht eine
Arbeit noch einmal, die schon getan ist.

**Vorschlag:** In beiden Urteilen den Absatz „Was noch fehlt“
umschreiben: bei [E-141](../Intern/BEFUNDE.md#e-141) *„am IMAP-Prüfserver messen, Gegenprobe Trash und
lokal“*, bei [E-176](../Intern/BEFUNDE.md#e-176) *„ein Test, der `CSummary` und `CMessageFrame` echt
anlegt; Messung unter Page-Heap“*. Danach den Block neu erzeugen. Den
Ort `tocdoc.cpp:3134` in der „Kette“ von [E-141](../Intern/BEFUNDE.md#e-141) auf `:3170` ziehen.

### <a id="l-105.2"></a>L-105.2 — Das Urteil zu E-144 sagt zweimal, die Behebung fehle, und nennt eine Nebenwirkung, die es nicht gibt

**Gewicht: Widerspruch in einer Zelle.** `Intern/BEFUNDE.md:401`

Worum es geht: Ein Antwortentwurf, den man aus `Trash` zurück nach `Out`
zieht, verliert die Angabe, worauf er antwortet. Behoben ist das. Die Zelle
sagt vorn „behoben“, weiter hinten aber zweimal das Gegenteil.

> vorn: *„**behoben im Quellstand, am 30.10.2026 am laufenden Programm
> gemessen; in keinem Paket.**“* … *„*Message → Send Again* aus dem Menü
> (`DisplayIt` TRUE) bleibt wie im Original — damit entsteht keine
> Abweichung vom Original, die hier stehen müsste.“*
>
> Mitte: *„**Kurz: … Die Behebung fehlt noch.**“*
>
> hinten: *„**Was noch fehlt:** die beiden Kopfzeilen beim Neuanlegen
> übernehmen … Nebenwirkung: auch *Message → Send Again* auf eine gesendete
> Antwort behält dann die Bezüge — eine Abweichung vom Original, die hier
> stehen muss. Dazu der Regressionsfall am Prüfstand.“*

Der Klartext „Kurz“ ist das, was Gregor liest ([befund-in-klartext](../Arbeitsweise/befund-in-klartext.md)).
Und er sagt das Gegenteil des Urteils. Der Absatz „Was noch fehlt“
beschreibt den Vorschlag aus [PRÜFER-48](PRUEFER-48.md) K8. Umgesetzt wurde
eine andere Lösung, die *Send Again* gerade ausnimmt. Weil [E-144](../Intern/BEFUNDE.md#e-144) nicht mehr
offen ist, steht der Satz in keinem erzeugten Block. Er widerspricht aber dem
Urteil daneben. Nebenbei: die Zelle nennt *„340 Tests, 340 bestanden“*, die
Commit-Nachricht von `45aa451c` *„341 von 341“*. **Belegt.**

**Vorschlag:** „Kurz“ auf den behobenen Stand bringen (*„Behoben im
Quellstand und am Programm gemessen; kommt mit dem nächsten Paket.“*). Den
Absatz „Was noch fehlt“ als „Vorschlag von PRÜFER-48, so nicht umgesetzt“
kennzeichnen oder streichen.

### <a id="l-105.3"></a>L-105.3 — Der Prüfstand hat E-144p nur rot aufgezeichnet, E-125c steht rot im Ergebnisbuch, und keine Doku sagt es

**Gewicht: grüne Aussage gegen roten Messwert.** `Intern/pruefstand-ergebnis.txt:2-8`, `Intern/pruefstand-buch.tsv:24-26`, `Intern/BEFUNDE.md:401`, `tools/WERKZEUGE.md:131`

Worum es geht: Für [E-144](../Intern/BEFUNDE.md#e-144) gibt es einen neuen Test über die Oberfläche. Sein
einziger aufgezeichneter Lauf ist durchgefallen. Ein älterer Test zu [E-125](../Intern/BEFUNDE.md#e-125)
steht ebenfalls als durchgefallen im Buch. Keine Doku erwähnt einen roten
Fall.

> `Intern/pruefstand-ergebnis.txt:2-8`: *„zeit=2026-10-30 14:24:41 …
> nur=E-144p … bestanden=0 fehlgeschlagen=1 fall=[FEHL] E-144p fehlt in
> messung: E144 ERGEBNIS probe=ok gleich=1 references=1“*
>
> `Intern/pruefstand-buch.tsv:26`: *„E-125c FEHL 2026-10-30 14:18:03
> C:\Temp\E125 Eudora 7.2.1.128+ca1b455b* … fehlt in log: [E-125](../Intern/BEFUNDE.md#e-125) Xfer nach
> Out abgelehnt: quelle=In ziel=Out“*

Beide Dateien sind mit `8cb340ab` eingecheckt (gemessen). Dagegen stehen
diese Aussagen:

* `Intern/BEFUNDE.md:401`: *„**Regressionstest** auch über die Oberfläche:
  Prüfstandsfall `E-144p`“* — ohne Hinweis, dass dieser Fall nie grün
  aufgezeichnet wurde. Die gemessenen Werte („vorher und nachher
  `In-Reply-To` …“) kommen nach `tools/TESTLAEUFE.md` (Starts 14:24:39 bis
  14:28:22 in `C:\Temp\E144` und `E144-alt`) aus Läufen von
  `messen-e144.ps1`. Ihr Ergebnis steht in keiner eingecheckten Datei außer
  dem Urteil selbst.
* Die Commit-Nachricht von `8cb340ab`: *„42 Faelle; 5 im Gesamtlauf rot,
  einzeln wiederholt alle gruen“*. Im Buch ist E-125c weiter rot. E-125a/b
  tragen noch den Stand vom 29.10. (`:24-25`). Eine grüne Wiederholung von
  [E-125](../Intern/BEFUNDE.md#e-125) ist im Buch nicht zu sehen, obwohl `tools/TESTLAEUFE.md` um 14:21:16
  einen Start in `C:\Temp\E125` verzeichnet. **Gemessen.**
* `tools/WERKZEUGE.md:131`: *„ein Teillauf mit `-Nur` ersetzt nur seine
  eigenen Zeilen“*. Der Teillauf `-Nur E-144p` um 14:24:41 hat aber keine
  Zeile im Buch hinterlassen: `E-144p` kommt in `pruefstand-buch.tsv` nicht
  vor (gemessen, `git grep` ohne Treffer). Beim Fall E-13p hat derselbe Weg
  am Vormittag eine Zeile angelegt (`ae3efe3f`, `+1` im Buch). Warum
  diesmal nicht: **Vermutung** — vielleicht schreibt das Werkzeug einen
  neuen Fall nur, wenn er besteht.

E-125c prüft die Ablehnung *In → Out*. [E-141](../Intern/BEFUNDE.md#e-141) hat in derselben Funktion
`CTocDoc::Xfer` die Bedingung vor `ImapXfer` geändert. Am Diff gelesen,
greift die Änderung nur, wenn eine Seite IMAP ist. Ein Weg *In → Out*
(beide lokal) läuft nicht durch sie (**belegt**). Der rote Fall stammt
deshalb wahrscheinlich aus dem abgeschossenen Lauf um 14:11:35
(`TESTLAEUFE.md`: *„ABER: musste abgeschossen werden. Schliesszeit 30.4
s“*). Das ist eine **Vermutung**, bis [E-125](../Intern/BEFUNDE.md#e-125) grün im Buch steht.

**Vorschlag:** `pruefstand-lauf.ps1 -Nur E-144p` und `-Nur E-125c` so lange
fahren, bis das Buch beide grün führt. Erst danach in [E-144](../Intern/BEFUNDE.md#e-144) „Regressionstest
über die Oberfläche“ schreiben. Bleibt E-144p rot, den Grund ins Urteil
schreiben. `WERKZEUGE.md:131` oder das Werkzeug berichtigen, je nachdem,
was der Lauf zeigt.

### <a id="l-105.4"></a>L-105.4 — ZIEL.md führt E-144 und E-145 als „bleiben offen“

**Gewicht: veraltete Aussage im Maßstab.** `ZIEL.md:89`

Worum es geht: Der Maßstab sagt, zwei Fehler seien offen und kämen erst
später dran. Beide sind im Quelltext behoben.

> `ZIEL.md:89` *„Bekannte Fehler in der README | **keine Voraussetzung, durch
> Entscheidung** — die Befunde selbst bleiben offen | … dazu
> [E-144](../Intern/BEFUNDE.md#e-144), … [E-141](../Intern/BEFUNDE.md#e-141), [E-145](../Intern/BEFUNDE.md#e-145)“*

`Intern/BEFUNDE.md:400` ([E-145](../Intern/BEFUNDE.md#e-145)) *„**behoben im Quellstand am 30.10.2026, in
keinem Paket**“*, `:401` ([E-144](../Intern/BEFUNDE.md#e-144)) *„**behoben im Quellstand, am 30.10.2026 am
laufenden Programm gemessen; in keinem Paket.**“*. `offene-befunde.pl`
zählt beide nicht mehr (45 statt 47). `ziel-stand.pl` meldet trotzdem
*„27 von 27 erfüllt“*, denn es liest die Kriterien, nicht diesen Satz.
**Gemessen.**

**Vorschlag:** In `:89` „bleiben offen“ durch „blieben zum Release offen“
ersetzen und hinter [E-144](../Intern/BEFUNDE.md#e-144) und [E-145](../Intern/BEFUNDE.md#e-145) „(seit 30.10.2026 im Quellstand
behoben)“ setzen. Hinter [E-141](../Intern/BEFUNDE.md#e-141) „(im Quellstand berichtigt, nicht gemessen)“.

### <a id="l-105.5"></a>L-105.5 — README: E-141, E-144 und E-145 ohne den Vermerk „im Quelltext behoben“, E-176 fehlt

**Gewicht: Form, nach außen uneinheitlich.** `README.md:184`, `:189`, `:191`; vergleiche `:155`

Worum es geht: Bei dem Filterfehler sagt die README, dass er im Quelltext
behoben ist. Bei drei heute behobenen Fehlern sagt sie das nicht. Ein
weiterer Fehler, der in jedem Paket seit 7.2.0.12 steckt, fehlt ganz.

* `:155` ([E-72](../Intern/BEFUNDE.md#e-72)) *„… im Quelltext behoben“*. Bei `:184` ([E-144](../Intern/BEFUNDE.md#e-144)), `:189`
  ([E-141](../Intern/BEFUNDE.md#e-141)) und `:191` ([E-145](../Intern/BEFUNDE.md#e-145)) fehlt ein solcher Vermerk. Für 7.2.1.128 sind die
  drei Zeilen richtig. Sie sagen aber nicht, dass die Behebung kommt.
* `:191` sagt zu [E-145](../Intern/BEFUNDE.md#e-145) *„(am Quelltext gelesen, nicht gemessen)“*. Seit
  `a2c31bf8` ist der Fehler am Original-Dekodierer gemessen: `TestE145.cpp`
  läuft gegen den bei jedem Bau frisch herausgeschnittenen Code aus
  `Base64.cpp` (`Tests/UnderTest2047.cpp:8-10`, `:98-100`). Ohne Behebung
  ist der Test rot (`BEFUNDE.md:400`). **Belegt.**
* [E-176](../Intern/BEFUNDE.md#e-176) steht nicht in der README (`git grep E-176 README.md` ohne
  Treffer, gemessen). `BEFUNDE.md:383` sagt: *„eingeschleppt mit der
  Behebung von [E-28](../Intern/BEFUNDE.md#e-28) in 7.2.0.12, also in jedem
  Paket seitdem“* und *„in seltenen Fällen … wird NULL in fremden Speicher
  geschrieben. Verloren geht nach heutigem Wissen nichts“*. Laut `ZIEL.md:27-28`
  muss gehen, was die README nicht nennt. Ob ein Fehler ohne beobachteten
  Schaden dort stehen soll, ist eine Formfrage. Sie gehört zum Hauptagenten.

**Vorschlag:** An `:184`, `:189` und `:191` je „im Quelltext behoben, kommt
mit dem nächsten Paket“ anhängen, wie bei `:155` (bei [E-141](../Intern/BEFUNDE.md#e-141) „berichtigt,
noch nicht gemessen“). In `:191` „am Quelltext gelesen“ durch „am
Original-Dekodierer gemessen“ ersetzen. Über [E-176](../Intern/BEFUNDE.md#e-176) entscheidet der
Hauptagent.

### <a id="l-105.6"></a>L-105.6 — `messen-e144.ps1` und `messen-e13.ps1` fehlen in WERKZEUGE.md

**Gewicht: Bestand unvollständig.** `tools/WERKZEUGE.md` (Tabelle ab `:131`, *„Nicht in der Tabelle“* ab `:177`)

Worum es geht: Die Werkzeugliste soll alles enthalten (`CLAUDE.md`,
Abschnitt 3: *„`tools/WERKZEUGE.md` führt den vollständigen Bestand“*).
Zwei neue Messskripte stehen nicht darin.

`tools/messen-e144.ps1` (neu in `8cb340ab`, 267 Zeilen) und
`tools/messen-e13.ps1` (neu in `ae3efe3f`, 193 Zeilen, schon vor
[LEKTOR-104](LEKTOR-104.md#lektor-104) im Bestand, dort übersehen) kommen in `WERKZEUGE.md` nicht vor
(gemessen: `git grep` nach `messen-e144` und `messen-e13\.ps1` in
`tools/WERKZEUGE.md` ohne Treffer). Die
übrigen Messskripte der Prüfstandsfälle haben dort je eine Zeile
(`:134-145`). **Gemessen.**

**Vorschlag:** Je eine Zeile nach dem Muster von `messen-e125.ps1`
(`:140`): Prüfstand, Ablauf, Ausgabezeile, was am alten und am neuen Bau
gemessen wurde.

## Bestand ohne Fund

* **Rollenbäume unter `.wt/<name>`.** Der alte Ort `../Eudora7.2-wt-<rolle>`
  steht außerhalb von `Befunde/` und `Arbeitsweise/` nur noch so:
  `tools/WERKZEUGE.md:155` und `tools/auftrag-rolle.pl:18` sagen
  ausdrücklich *„nicht mehr“*. `Intern/AGENTEN.md:135` ist ein Beispiel
  vom 05.09.2026. `Intern/LEKTORAT.md`, `PRUEFUNG-*.md`,
  `Releases/PAKETE.md:1346` und `Intern/BEFUNDE.md:7663` sind Geschichte.
  Dazu kommen Kommentare in `arbeitsbaum-frei.pl:15`, `gesichert.pl:477`
  und `lehren-spiegeln.pl:64-67`. Sie beschreiben, was früher geschah
  (gemessen mit `git grep`). Das Verfahren in `Intern/AGENTEN.md:32-49`
  nennt keinen Pfad. `.gitignore` führt `.wt/` und
  `.claude/settings.local.json`. `arbeitsbaum-frei.pl:249` und
  `auftrag-rolle.pl:52` legen den Baum unter `$wurzel/.wt/` an (belegt am
  Diff). `doku-pruefen.pl` zählt weiter 50 Dateien, liest also nicht in
  `.wt/` hinein (gemessen).
* **`bauen.ps1` findet `perl`.** Die Aufgabe ist aus
  `Intern/WEITERMACHEN.md:49` gestrichen. `CHANGELOG.md:115` beschreibt sie.
  Die verbleibende Nennung in `WEITERMACHEN-bis-7.2.0.md:161` steht im
  Archiv.
* **[E-145](../Intern/BEFUNDE.md#e-145):** Das Urteil `BEFUNDE.md:400` sagt *„behoben im Quellstand …;
  am herausgeschnittenen Original-Dekodierer gemessen“*. Das trifft zu:
  Der Test rechnet mit dem echten Code, nicht mit einer Abschrift (siehe
  [L-105.5](#l-105.5)). `CHANGELOG.md:111` stimmt damit überein.
* **[E-141](../Intern/BEFUNDE.md#e-141) wird nirgends als „behoben“ geführt.** `BEFUNDE.md:377`
  *„offen, im Quellstand am 30.10.2026 berichtigt; am laufenden Programm
  noch nicht gemessen“* und `CHANGELOG.md:112` *„am Programm noch nicht
  gemessen“* stimmen. [E-176](../Intern/BEFUNDE.md#e-176) ist in `BEFUNDE.md:383` als offen geführt.
  Nur `CHANGELOG.md:114` sagt ohne Einschränkung *„Eudora liest dabei nicht
  mehr aus schon freigegebenem Speicher“*. Der Satz steht unter *„Im
  Quellstand, noch in keinem Paket“* und ist als Aussage über den Quelltext
  vertretbar. Er sollte aber wie die Zeile zu [E-141](../Intern/BEFUNDE.md#e-141) *„am Programm nicht
  gemessen“* tragen. Das gehört zu [L-105.1](#l-105.1).
* `CHANGELOG.md:109-117`: neuer Zweig, #189 als gemergt; passt zu
  `tools/ZWEIGE.md:198`.
* `Intern/WEITERMACHEN.md:47`: *„Neun Messskripte liegen nur unter
  `C:\Temp`“*. Das neue Messskript liegt unter `tools/`, die Zeile bleibt
  also richtig.
* Die „Zur Kenntnis“-Liste von `doku-pruefen.pl` ist dieselbe wie bei
  [LEKTOR-104](LEKTOR-104.md#lektor-104) (15 Archiv-, Hintergrund- und
  Testdatendateien).

## Mechanisch (zitiert, gemessen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 50 … Kein Widerspruch gefunden.“*; 15 „Zur Kenntnis“-Zeilen wie bei [LEKTOR-104](LEKTOR-104.md#lektor-104). Es vergleicht Fassungsnummern. Die Spalte „was noch fehlt“ aus [L-105.1](#l-105.1) kann es nicht sehen |
| `perl tools/offene-befunde.pl` | *„45 offene Befunde, in beiden Listen gleich.“* (5 aktuell, 26 veraltet, 14 nie gemessen). Es prüft, ob beide Listen gleich sind, nicht ob der Inhalt stimmt |
| `perl tools/pruefe-regressionstest.pl` | *„Befunde insgesamt 220 … mit Testfall 101 … behoben und OHNE Testfall 50 … mit Testfall im Pruefstand 59 von 72 … OHNE jede Pruefung 11 … Kein neues "behoben" ohne Regressionstest.“* Ein Prüfstandsfall zählt dabei auch dann, wenn er nur rot gelaufen ist ([L-105.3](#l-105.3)) |
| `perl tools/ziel-stand.pl` | *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* Den Satz aus [L-105.4](#l-105.4) liest es nicht |

## Nicht geprüft

* Nicht jede Datei Zeile für Zeile. Ganz gelesen: der Kopf von WEITERMACHEN
  (`:1-60`), ZIEL.md `:25-189` und die Urteile zu [E-72](../Intern/BEFUNDE.md#e-72), [E-141](../Intern/BEFUNDE.md#e-141), [E-144](../Intern/BEFUNDE.md#e-144), [E-145](../Intern/BEFUNDE.md#e-145)
  und [E-176](../Intern/BEFUNDE.md#e-176). Abschnittsweise: CHANGELOG bis `:124` und README „Bekannte
  Fehler“. Die übrigen Dateien nur nach dem alten Ort der Rollenbäume, nach
  Testzahlen und nach den fünf Kennungen durchsucht.
* Ob `TestE141`, `TestE144`, `TestE145` und `TestE176` prüfen, was ihr Name
  sagt: Das ist Sache des PRÜFERS. Gelesen habe ich nur, dass [E-141](../Intern/BEFUNDE.md#e-141) und
  [E-176](../Intern/BEFUNDE.md#e-176) Zeichenketten im Quelltext suchen.
* Den Text des Releases `v7.2.1.128` habe ich diesmal nicht abgerufen (`gh`
  ist für diesen Lauf nicht freigegeben). Die Aussage unten stützt sich auf
  `ZIEL.md:37-38`.
* Nichts am laufenden Programm, kein Prüfstand.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Offen seit [LEKTOR-103](LEKTOR-103.md#lektor-103).
  `ZIEL.md:37-38` sagt weiter *„Bei 7.2.1.128 fehlt dieser Satz in den
  Notizen“*. Deine Anordnung vom 23.10. ist damit noch nicht erfüllt.
* **Wann kommt das nächste Release mit den Behebungen?** In 7.2.1.128
  verschiebt ein Filter mit „… doesn't appear“ und *transfer* jede Nachricht
  ([E-72](../Intern/BEFUNDE.md#e-72)). Die README warnt jetzt davor. Seit heute liegen im Quellstand
  außerdem die Behebungen für den Antwortentwurf, der den Gesprächsfaden
  verliert ([E-144](../Intern/BEFUNDE.md#e-144), am Programm gemessen), und für fehlerhaftes Base64 ([E-145](../Intern/BEFUNDE.md#e-145)).
  Ungemessen sind die Behebungen für den Expunge nach IMAP → `Out`
  ([E-141](../Intern/BEFUNDE.md#e-141)) und für das Lesen aus freigegebenem Speicher ([E-176](../Intern/BEFUNDE.md#e-176)). Frage
  aus [LEKTOR-104](LEKTOR-104.md#gregor): eine Warnung in den Text von
  `v7.2.1.128`, oder bald ein Release 7.2.1.N?
