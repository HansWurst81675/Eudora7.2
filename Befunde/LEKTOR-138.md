# <a id="lektor-138"></a>LEKTOR-138 — Zweig e170_label_ohne_uidplus vor dem PR, nach 07cca482; dazu lesend about_dialog_github (03.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-137](LEKTOR-137.md#lektor-137).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261103c`, abgezweigt von `origin/e170_label_ohne_uidplus`, Stand `07cca482` (gemessen: `git rev-list --count HEAD..origin/e170_label_ohne_uidplus` → 0). Eigen gegen `origin/main` (gemessen, `git log --oneline origin/main..HEAD`): `ade064f9` (ZWEIGE), `d2cf569d`/`783a1be7` ([E-170](../Intern/BEFUNDE.md#e-170) ohne UIDPLUS, Prüfstand), `45920db7`/`80b98b69`/`01f4c9cd` (PRÜFER-89 und Einarbeitung), `ce2277a0` (PRÜFER-90 K8–K10), `3dc3644a` (PRÜFER-90 Nachtrag 2), dazu Merges von `main` (#211–#214) und TESTLAEUFE-Commits. `about_dialog_github` (`70c83b16`) nur über `git diff origin/main...origin/about_dialog_github` gelesen. Nichts gebaut, nichts gestartet, keine Prüfstände angefasst.

## Kurz

[E-170](../Intern/BEFUNDE.md#e-170) (das Label einer Mail geht beim Verschieben im IMAP-Konto verloren) ist an Code, Test und PRÜFER-90 stimmig: alle vier E-170-Logzeilen schreiben jetzt in den Bereich *Dialog*, der in der Vorgabe an ist. **Der Eintrag selbst sagt an zwei Stellen noch „Protokollbereich *Misc*, 0x8000, in der Vorgabe aus“** — für dieselben Zeilen, die ein paar Sätze weiter „nicht mehr in *Misc*“ stehen. Nach Gregors Hinweis zu Randfällen: README und FUNKTIONEN stellen den Verlust als allgemeines Verhalten dar („Ein Label geht verloren, wenn …“, „Geht beim Verschieben … verloren“), obwohl er nur Server ohne UIDPLUS trifft — Gregors eigener Server behält das Label. Die Hinweise T1–T3 aus PRÜFER-90 Nachtrag 2 fehlen im Eintrag; T3 (Postfachname jetzt in der Vorgabe im Protokoll) ist eine Frage an Gregor. Im About-Zweig steht der Umbruch der Herkunftszeile im CHANGELOG als Tatsache, im Eintrag als ungemessen. Neun Funde, keiner am Programmcode.

## Mechanisch (Ausgaben, kein Urteil)

- `perl tools/doku-pruefen.pl`: nur die bekannten Hinweise *„nennt weder den Quellstand 7.2.1.131 noch die Paketnummer“* (u. a. `Releases/1.0.117/RELEASE-NOTIZEN.md`, `Releases/7.2.1.128/RELEASE-NOTIZEN.md`, `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md`) — Archiv bzw. bewusst älter, kein neuer Fund.
- `perl tools/offene-befunde.pl`: *„60 offene Befunde, in beiden Listen gleich.“*
- `perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne Regressionstest.“* — [E-170](../Intern/BEFUNDE.md#e-170) ist weiter *offen*, die Schranke greift hier nicht.
- `perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Funde aus LEKTOR-137 — heutiger Stand

| Fund | Stand | Stelle (gemessen, dieser Zweig) |
|---|---|---|
| [L-137.1](LEKTOR-137.md#l-137.1) Umlaut-Textmail → `.eml` | **erledigt** (mit #214 auf `main`, hier hereingemergt) | `Intern/TESTPLAN.md:487-490` wie im Nachtrag 1 von [LEKTOR-137](LEKTOR-137.md#lektor-137) |
| [L-137.2](LEKTOR-137.md#l-137.2) „Gregor muss nichts tun“ bei [E-128](../Intern/BEFUNDE.md#e-128) | **erledigt** | `Intern/BEFUNDE.md:391` *„Gregor testet es am Paket 7.2.2.132“* |
| [L-137.3](LEKTOR-137.md#l-137.3) WEITERMACHEN | **erledigt** | `Intern/WEITERMACHEN.md:3` *„Zweig `e128_endung_aus_inhalt` (gemergt als #214)“*, *„Laufend: `e170_label_ohne_uidplus`, `about_dialog_github`“* — trifft |
| [L-137.4](LEKTOR-137.md#l-137.4) ZWEIGE ohne [E-213](../Intern/BEFUNDE.md#e-213)/[E-214](../Intern/BEFUNDE.md#e-214) | **erledigt** | — |
| [L-137.5](LEKTOR-137.md#l-137.5) Berichtszahl README | **offen** | [L-138.9](#l-138.9) |
| [L-137.6](LEKTOR-137.md#l-137.6) IMAP-Weg von [E-128](../Intern/BEFUNDE.md#e-128) | **erledigt im TESTPLAN, am Prüfstand weiter ungemessen** | — |

## Funde

### <a id="l-138.1"></a>L-138.1 — Randfall als Alltagsfehler: README und FUNKTIONEN sagen „Label geht verloren“ ohne die Bedingung vorn

**Gewicht: mittel** (Gregors Hinweis vom 03.11.2026). Wer die README liest, glaubt, Labels gingen beim Verschieben im IMAP-Konto generell verloren. Tatsächlich trifft es bis 7.2.1.131 nur Server, die keine neuen Nummern melden (kein UIDPLUS), und einen ungeklärten Einzelfall vom 29.10.2026; Gregors Server behält das Label (gemessen von Gregor, 02.11.2026). Wie oft Server ohne UIDPLUS vorkommen, ist nirgends gemessen (Vermutung: selten, die verbreiteten Server können es). (gemessen an den Texten)

- `README.md:167` beginnt *„Ein **Label** geht verloren, wenn die Mail zwischen zwei Ordnern **desselben IMAP-Kontos** verschoben wird“*; die Bedingung kommt erst danach (*„mitgenommen wird es … meistens, wenn der Server die neuen Nummern meldet“*).
- `Doku/FUNKTIONEN.md:176` *„Geht beim Verschieben im selben IMAP-Konto verloren ([E-170](../Intern/BEFUNDE.md#e-170), *Label nur lokal gespeichert*)“* — ohne jede Bedingung.
- Richtig gewichtet dagegen `Doku/FAQ.md:215-217` *„ist das Label danach weg, wenn der Server die neuen Nummern … nicht meldet (UIDPLUS)“* und der Kopf von [E-170](../Intern/BEFUNDE.md#e-170) (`Intern/BEFUNDE.md:429`) *„an Gregors Server (er meldet UIDPLUS) bleibt das Label … erhalten“*.

**Vorschlag:** README-Zeile mit der Bedingung beginnen: *„An einem IMAP-Server, der beim Verschieben keine neuen Nummern meldet (ohne UIDPLUS), geht das Label verloren …“*; FUNKTIONEN:176 ebenso *„Geht an Servern ohne UIDPLUS beim Verschieben … verloren; im Quellstand für 7.2.2.132 berichtigt“*.

### <a id="l-138.2"></a>L-138.2 — E-170: die neuen Logzeilen stehen im Eintrag noch in *Misc*, „in der Vorgabe aus“

**Gewicht: mittel.** Der Eintrag widerspricht sich selbst; wer ihn für eine Rückfrage an Gregor liest, bittet ihn, `LogLevel` umzustellen, was seit K10 nicht mehr nötig ist. (gemessen an Text und Code)

- `Intern/BEFUNDE.md:429` (Behebung): *„Logzeile `E-170 Labels beim Verschieben im Konto, nach dem Abgleich: … grund=…` mit `zugeordnet`, `mehrdeutig` oder `kein-treffer` (Protokollbereich *Misc*, 0x8000)“* und *„`… grund=keine-neuen-uids` (Protokollbereich *Misc*, 0x8000 — in Gregors `LogLevel=58527` an, in der Vorgabe 25759 aus)“*.
- Derselbe Eintrag weiter hinten: *„alle E-170-Zeilen stehen im Bereich *Dialog* (0x08, in der Vorgabe `LogLevel=25759` an …), nicht mehr in *Misc*“*. Code: `Eudora71/EuImap/src/ImapToc.cpp:1904` *„[E-170](../Intern/BEFUNDE.md#e-170) Vormerkung verworfen: anzahl=%d“*; `Eudora71/Tests/TestE170.cpp:331` zählt `PutDebugLog(DEBUG_MASK_DIALOG, szSpur);` == 3 und `DEBUG_MASK_MISC` == 0; `Befunde/PRUEFER-90.md:310` *„Alle vier Logzeilen … schreiben mit `DEBUG_MASK_DIALOG`“*.
- Nicht betroffen, weil sie 7.2.1.131 beschreiben: `Doku/FAQ.md:222`, `Releases/7.2.1.131/RELEASE-NOTIZEN.md:44-45`, `Intern/TESTPLAN.md:364-365` (Schritt 4, *„auszuführen sind sie nicht mehr“*), `CHANGELOG.md:163`.
- Außerhalb der MDs, nur zur Kenntnis: `tools/messen-e170.ps1:12` und `tools/messen-e170o.ps1:12` *„(Protokollbereich Misc, 0x8000)“*; `Eudora71/Tests/TestE170.cpp:335` meldet im Fehlerfall *„fehlt die Logzeile '[E-170](../Intern/BEFUNDE.md#e-170) Vormerkung verworfen: verfallen='“*, geprüft wird aber `anzahl=`.

**Vorschlag:** an beiden Stellen im Eintrag *„(Bereich *Dialog*, 0x08, in der Vorgabe an; bis PRÜFER-90 K10 *Misc*)“*; die beiden Skriptkommentare und die Testmeldung beim nächsten Codeschritt mitziehen.

### <a id="l-138.3"></a>L-138.3 — E-170 „Zuletzt gemessen“ und WERKZEUGE nennen den Bau vor K8–K10, CHANGELOG die alte Testzahl

**Gewicht: Kleinkram.** (gemessen)

- `Intern/BEFUNDE.md:429` *„**Zuletzt gemessen: 03.11.2026 an 7.2.1.131** am Prüfstand (Quellstand mit der Einarbeitung von PRÜFER-89, Bau `7.2.1.131+012feff7*` …)“*; derselbe Eintrag später *„Prüfstand am Bau `7.2.1.131+1b1d6825*`: `E-170p/o/m/f/g/c/s` 7/7“*, ebenso `Befunde/PRUEFER-90.md` *Eingearbeitet auf e170*.
- `tools/WERKZEUGE.md:162` endet *„alle sieben E-170-Fälle 7/7 (Bau `7.2.1.131+012feff7*`)“*.
- `CHANGELOG.md:157` *„Regressionstest mit der Verwaltung im Verhalten, 388/388, 16 Gegenproben rot“*; nach PRÜFER-90 398/398 mit elf weiteren Gegenproben (`Befunde/PRUEFER-90.md:266`, Tabelle T1–T11).

**Vorschlag:** *Zuletzt gemessen* auf `1b1d6825*` (mit K8–K10) setzen, WERKZEUGE:162 ebenso; CHANGELOG *„398/398“*.

### <a id="l-138.4"></a>L-138.4 — „gibt es hier noch nicht / daher ohne Verweis“ — nach dem Merge von #214 überholt

**Gewicht: Kleinkram, Klasse von [L-128.2](LEKTOR-128.md#l-128.2) (Zustandsangabe überlebt den Merge).** (gemessen)

- `Befunde/PRUEFER-90.md:291` *„In dieser Kopie (Zweig e170) sind die Verweise auf [E-213](../Intern/BEFUNDE.md#e-213) und [E-214](../Intern/BEFUNDE.md#e-214) reiner Text: beide Kennungen gibt es hier noch nicht (sie kommen mit e128)“* — beide stehen jetzt in `Intern/BEFUNDE.md:400-401`, und der Bericht verlinkt sie (`grep -c` auf Verweise → 9).
- `Intern/BEFUNDE.md:429` *„Einarbeitung PRÜFER-90 K8–K10 (der Bericht kommt mit dem Zweig e128 auf main, daher hier ohne Verweis)“* — `Befunde/PRUEFER-90.md` liegt im Zweig.

**Vorschlag:** den Satz in PRÜFER-90 streichen; im Eintrag *„PRÜFER-90 K8–K10“* verlinken (`../Befunde/PRUEFER-90.md#k8`).

### <a id="l-138.5"></a>L-138.5 — PRÜFER-90 Nachtrag 2: Überschriften und Tabelle ohne Leerzeile

**Gewicht: Kleinkram.** (gemessen, `awk` über die Zeilen)

- `Befunde/PRUEFER-90.md:291→292`: Absatz, dann sofort `## Nachtrag 2`; `:294→295` Absatz, dann `### Gegen die Quelle`; `:315→316` Listenpunkt T3, dann sofort die Tabelle `| Fund | Was passiert |` — eine Tabelle direkt nach einem Listenpunkt wird als Fortsetzung des Punkts gelesen und nicht als Tabelle gesetzt (Vermutung aus der Markdown-Regel, nicht auf GitHub angesehen).

**Vorschlag:** je eine Leerzeile davor.

### <a id="l-138.6"></a>L-138.6 — Die Hinweise T1–T3 aus PRÜFER-90 Nachtrag 2 fehlen im E-170-Eintrag

**Gewicht: Kleinkram.** (gemessen: in `Intern/BEFUNDE.md:429` weder `T1`, `T2`, `T3` noch `Nachtrag 2`)

- `Befunde/PRUEFER-90.md:313-315`: T1 — in der Lage *„älterer Abgleich lief beim Verschieben“* kann eine fremde, in Sekunde, Absender und Betreff gleiche Mail das Label bekommen (Häufigkeit vermutet: sehr selten); T2 — ein Abgleich mit UID-Obergrenze verwirft die Vormerkung (Label fehlt, kein falsches); T3 — *„Mit K10 steht der **Postfachname** (`ziel="…"`) jetzt in der Vorgabe im Protokoll“*.
- Der Eintrag nennt unter *Was noch fehlt* nur K9 als ungemessen. T1 und T2 halten nach PRÜFER-90 nichts auf — so sollten sie auch dastehen (Randfälle mit benannter Folge), nicht fehlen.

**Vorschlag:** ein Satz im Eintrag: *„Restlagen nach PRÜFER-90 Nachtrag 2: T1 (sehr selten ein Label auf einer gleich aussehenden fremden Mail), T2 (Label fehlt nach einem Abgleich mit UID-Grenze); T3 siehe Frage an Gregor.“*

### <a id="l-138.7"></a>L-138.7 — About-Zweig: CHANGELOG und FUNKTIONEN sagen „bricht um“, der Eintrag sagt „nicht gemessen“

**Gewicht: Kleinkram.** (gemessen an `git diff origin/main...origin/about_dialog_github`)

- CHANGELOG (Zweig): *„*Mail folder from* bricht um statt abgeschnitten zu werden“*; FUNKTIONEN (Zweig): *„die Zeile *Mail folder from* bricht um, statt abgeschnitten zu werden“*.
- [E-216](../Intern/BEFUNDE.md#e-216) (Zweig; im About-Dialog überdecken sich die Knöpfe, und es fehlt der Weg zum neuesten Release): *„**Nicht gemessen:** der Umbruch selbst — die Herkunft im Prüfstand ist 30 Zeichen kurz und passt in eine Zeile (`noetig=13`)“*. Gemessen ist nur, dass die Zeile zwei Zeilen hoch ist (`herkunft-zeilen=2`). Der TESTPLAN-Abschnitt *e-216-naechstes* prüft den Umbruch bei Gregor (*„ist sie länger als die Dialogbreite, steht der Rest in einer zweiten Zeile“*) — gut.
- Nebenbei: die neue Logzeile *„About: Latest Release geoeffnet|fehler=…“* schreibt laut Eintrag mit `DEBUG_MASK_MISC`, also in der Vorgabe nicht ins Protokoll — dieselbe Lage, die K10 bei [E-170](../Intern/BEFUNDE.md#e-170) behoben hat. Da ein Fehler zusätzlich eine Meldung zeigt, hier ohne Folgen.
- *„Zuletzt gemessen … Bau aus `e992d982` mit den Änderungen vor dem Commit“*: gemessen wurde ein Stand ohne Kennung; ob er `70c83b16` gleicht, ist nicht belegt (Vermutung: ja).

**Vorschlag:** CHANGELOG/FUNKTIONEN *„die Zeile ist zwei Zeilen hoch und bricht um (der Umbruch selbst ist am Prüfstand nicht gemessen)“*.

### <a id="l-138.8"></a>L-138.8 — About-Zweig: WEITERMACHEN auf dem Stand vor #214

**Gewicht: Kleinkram, Klasse [L-128.2](LEKTOR-128.md#l-128.2).** (gemessen an `git diff origin/main...origin/about_dialog_github -- Intern/WEITERMACHEN.md`)

- Der Zweig setzt seinen Satz vor den alten Kopf *„Laufend: `e128_endung_aus_inhalt` ([E-128](../Intern/BEFUNDE.md#e-128)), `e170_label_ohne_uidplus`, `e133_mailverzeichnis_fehlt`, `e203_e204_persona_kennwort`“* — drei davon sind gemergt (#212, #213, #214). Auf `main` ist der Kopf inzwischen ein anderer; der Merge ergibt in Zeile 3 einen Konflikt (Vermutung aus den beiden Fassungen, nicht probegemergt).

**Vorschlag:** vor dem PR `main` hereinholen und den E-216-Satz vor den heutigen Kopf setzen.

### <a id="l-138.9"></a>L-138.9 — Berichtszahl in der README

**Gewicht: Kleinkram** (Fortschreibung [L-137.5](LEKTOR-137.md#l-137.5)). (gemessen)

- `README.md:98` *„(219 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“*; `ls Befunde/LEKTOR-*.md Befunde/PRUEFER-*.md | wc -l` → 226 vor diesem Bericht, mit ihm 227.

**Vorschlag:** wie vereinbart nach dem letzten Merge setzen oder erzeugen lassen.

## Bestand außerhalb des Schwerpunkts

- `Intern/TESTPLAN.md:350-371` ([E-170](../Intern/BEFUNDE.md#e-170)): als *Erledigt* gekennzeichnet, Schritte *„bleiben zum Nachlesen stehen; auszuführen sind sie nicht mehr“* — trifft. Für 7.2.2.132 gibt es keinen E-170-Schritt; Gregors Server meldet UIDPLUS, der neue Weg ist bei ihm nicht zu sehen — so im Eintrag (*„der Weg ist nur am Prüfstand gemessen“*), kein Fund.
- `Doku/FAQ.md:213-226` und `Releases/7.2.1.131/RELEASE-NOTIZEN.md:41-47`: Bedingung UIDPLUS, Einzelfall 29.10.2026 und *Misc* für 7.2.1.131 richtig (gelesen).
- `tools/WERKZEUGE.md:3`, `:160-162`: `messen-e170c`, `messen-e170s` mit Ergebniszeilen beschrieben; Skripte vorhanden (`ls tools/messen-e170*` → sieben) — trifft bis auf [L-138.3](#l-138.3).
- `tools/ZWEIGE.md:214` beschreibt `e170_label_ohne_uidplus` nur mit dem Anlass vom 02.11.2026 — PRÜFER-89/90 fehlen; Klasse [L-137.4](LEKTOR-137.md#l-137.4), beim Merge mitziehen.
- `Befunde/PRUEFER-90.md` *Eingearbeitet auf e170* (`:263-291`): K8 gegen Nachtrag 2 (*„Beide verwerfen jetzt mit ihrem eigenen Beginn … K8 erledigt“*), K10 gegen `TestE170.cpp:331` — trifft (belegt).
- About-Zweig: TESTPLAN-Abschnitt *e-216-naechstes* (drei Schritte, *Ort: lokal*), WERKZEUGE `messen-about` (*„Drückt *Latest Release* nicht“*), Zählung in der Stufentabelle (+1 unkritisch, 61/245) — gelesen, trifft.
- Die übrigen MD-Dateien ohne `Arbeitsweise/` und `Befunde/` nur über `doku-pruefen.pl` und gezielte Suche nach [E-170](../Intern/BEFUNDE.md#e-170)/[E-216](../Intern/BEFUNDE.md#e-216) und den Zweignamen geprüft, nicht einzeln gelesen.

## Was nur Gregor entscheiden kann

1. **Ordnernamen im Protokoll** (PRÜFER-90 T3): seit K10 steht in der `eudora.log` schon mit der Vorgabe bei jeder E-170-Zeile der Name des Zielordners (`ziel="…"`). Die Zeilen von [E-128](../Intern/BEFUNDE.md#e-128) nennen bewusst keinen Pfad. Du schickst deine `eudora.log` mit den Ergebnis-ZIPs: dürfen Ordnernamen darin stehen, oder soll die Zeile sie weglassen?

## <a id="eingearbeitet"></a>Eingearbeitet (BEHEBER, 03.11.2026) — nur die Funde zu e170

Zweig `e170_label_ohne_uidplus`. [L-138.7](#l-138.7) und [L-138.8](#l-138.8) gehören zum About-Zweig und sind hier nicht angefasst; [L-138.9](#l-138.9) (Berichtszahl in der README) bleibt bis nach dem letzten Merge.

| Fund | was geschah |
|---|---|
| [L-138.1](#l-138.1) | `README.md` (Zeile zu [E-170](../Intern/BEFUNDE.md#e-170)) beginnt jetzt mit der Bedingung (*„An einem IMAP-Server, der beim Verschieben keine neuen Nummern meldet …“*), Gregors Server behält das Label; `Doku/FUNKTIONEN.md` (*Change ▸ Label*) ebenso, mit dem Hinweis auf die Berichtigung im Quellstand |
| [L-138.2](#l-138.2) | Im [E-170](../Intern/BEFUNDE.md#e-170)-Eintrag steht die Zeile *nach dem Abgleich* jetzt im Bereich *Dialog* (0x08, in der Vorgabe an; bis PRÜFER-90 K10 *Misc*); die zweite Stelle mit *Misc* steht im Teil *„Bis 03.11.2026 stand hier“* und beschreibt 7.2.1.131 — bleibt. Kommentare `tools/messen-e170.ps1:12`, `messen-e170o.ps1:12` und die Meldung in `TestE170.cpp` (`anzahl=`) berichtigt |
| [L-138.3](#l-138.3) | *Zuletzt gemessen* in [E-170](../Intern/BEFUNDE.md#e-170) nennt `1b1d6825*` (mit K8–K10), `tools/WERKZEUGE.md` ebenso; CHANGELOG nennt 388/388 als damaligen Stand und 398/398 bzw. 405/405 als heutigen |
| [L-138.4](#l-138.4) | Satz *„In dieser Kopie (Zweig e170) …“* in [PRÜFER-90](PRUEFER-90.md#pruefer-90) gestrichen; im Eintrag ist *PRÜFER-90 K8–K10* jetzt ein Link |
| [L-138.5](#l-138.5) | Leerzeilen vor und nach den Überschriften von Nachtrag 2 und vor der Tabelle |
| [L-138.6](#l-138.6) | T1 und T2 stehen im Eintrag als **Grenze** (nicht behoben, Gregor 03.11.2026: erst abwägen); T3 ist durch Gregors Entscheidung erledigt: keine E-170-Zeile nennt mehr den Ordnernamen (`ziel="…"` entfernt). Test: Quelltextprüfung (kein `ziel=`, kein `->Name()` im E-170-Block); Gegenprobe Name in jede der drei Zeilen zurück → je 404/405 rot, wiederhergestellt 405/405 |

Unit-Tests vorher 405/405 (Stand a04af7bc), nachher 405/405; Release-Bau ohne Fehler. Prüfstand nicht gefahren: geändert sind nur Logzeilen, die die Messskripte über `grund=` lesen.

## Nachtrag 1 (03.11.2026, nach 9bad293a)

`origin/e170_label_ohne_uidplus` in `wt/lektor-20261103c` gemergt (Spitze `9bad293a` *„[E-170](../Intern/BEFUNDE.md#e-170): keine Ordnernamen im Protokoll (Gregor 03.11.2026, [PRUEFER-90](PRUEFER-90.md#pruefer-90) T3); [LEKTOR-138](#lektor-138) L-138.1-.6 eingearbeitet“*). Gemessen mit `grep`/`awk` am Stand nach dem Merge.

| Fund | Stand | Stelle |
|---|---|---|
| [L-138.1](#l-138.1) Randfall als Alltagsfehler | **erledigt** | `README.md:167` *„An einem IMAP-Server, der beim Verschieben **keine neuen Nummern** meldet (ohne UIDPLUS), geht das **Label** … verloren“*; `Doku/FUNKTIONEN.md:176` *„Geht an Servern ohne UIDPLUS …“* |
| [L-138.2](#l-138.2) *Misc* statt *Dialog* im E-170-Eintrag | **teilweise** | erste Stelle berichtigt: `Intern/BEFUNDE.md:429` *„(Protokollbereich *Dialog*, 0x08, in der Vorgabe an; bis PRÜFER-90 K10 *Misc*, 0x8000)“*. **Zweite Stelle unverändert:** derselbe Eintrag *„`E-170 Labels beim Verschieben im Konto: … grund=keine-neuen-uids` (Protokollbereich *Misc*, 0x8000 — in Gregors `LogLevel=58527` an, in der Vorgabe 25759 aus)“*. Die Skriptkommentare `messen-e170.ps1`/`messen-e170o.ps1` sind geändert (`git diff --stat 07cca482 9bad293a`) |
| [L-138.3](#l-138.3) alter Bau, alte Testzahl | **erledigt** | `Intern/BEFUNDE.md:429` *„Bau `7.2.1.131+1b1d6825*` mit PRÜFER-90 K8–K10“*; `tools/WERKZEUGE.md:162` *„erneut 7/7 am Bau `7.2.1.131+1b1d6825*`“*; `CHANGELOG.md:157` *„damals 388/388 mit 16 Gegenproben rot, nach …“* |
| [L-138.4](#l-138.4) „gibt es hier noch nicht“ | **erledigt** | `grep -c 'reiner Text: beide' Befunde/PRUEFER-90.md` → 0; *„daher hier ohne Verweis“* im Eintrag → 0 |
| [L-138.5](#l-138.5) Leerzeilen Nachtrag 2 | **erledigt** | `awk` über `Befunde/PRUEFER-90.md`: keine Überschrift nach nicht-leerer Zeile, keine Tabelle direkt nach einem Listenpunkt |
| [L-138.6](#l-138.6) T1–T3 im Eintrag | **erledigt** | `Intern/BEFUNDE.md:429` nennt [T1](PRUEFER-90.md#t1) (*„sehr selten, am Quelltext belegt“*), [T2](PRUEFER-90.md#t2) und *„T3 (Ordnername im Protokoll) ist durch die Entscheidung oben erledigt“* |
| [L-138.7](#l-138.7)/[L-138.8](#l-138.8) About-Zweig | nicht nachgemessen (gehören zu `about_dialog_github`) | — |
| [L-138.9](#l-138.9) Berichtszahl | **offen** (vereinbart: nach dem letzten Merge) | — |

### <a id="l-138.10"></a>L-138.10 — Ordnernamen stehen weiter im Protokoll, über die E-189-Zeilen

**Gewicht: mittel** (Gregors Entscheidung vom 03.11.2026 *„Weglassen“*, im Eintrag *„**Keine Ordnernamen im Protokoll**“*). Umgesetzt ist sie nur für [E-170](../Intern/BEFUNDE.md#e-170). (gemessen am Code)

- `Eudora71/EuImap/src/ImapToc.cpp:1819` *„[E-189](../Intern/BEFUNDE.md#e-189) Vorab-Kopie bleibt, Fenster nicht geschlossen: alte-uid=%lu ziel=\"%s\"“* und `:1825` *„[E-189](../Intern/BEFUNDE.md#e-189) Vorab-Kopie ohne neue UID entfernt: … ziel=\"%s\"“*, beide mit `pZiel->Name()`, geschrieben mit `DEBUG_MASK_MISC` — in der Vorgabe aus, in Gregors `LogLevel` (58527, laut E-170-Eintrag) an. [E-189](../Intern/BEFUNDE.md#e-189) ist der Befund, bei dem eine Vorab-Kopie im Ziel bleibt oder entfernt wird.
- Ob Gregors Entscheidung nur die E-170-Zeilen meint oder alle Logzeilen, sagt der Eintrag nicht; der Wortlaut *„Keine Ordnernamen im Protokoll“* ist allgemein.

**Vorschlag:** die beiden E-189-Zeilen ebenso ohne `ziel=` schreiben und die Quelltextprüfung in `TestE170.cpp` (kein `ziel=`) auf den ganzen Block bzw. eine Schranke über alle `szSpur.Format` mit `->Name()` ausdehnen; oder im Eintrag ausdrücklich *„nur [E-170](../Intern/BEFUNDE.md#e-170)“* schreiben.

Neu: ein Fund ([L-138.10](#l-138.10)); [L-138.2](#l-138.2) teilweise. Was nur Gregor entscheiden kann: weiter nichts — die Frage aus dem Hauptteil (Ordnernamen) hat er beantwortet.

## <a id="eingearbeitet-about"></a>Eingearbeitet auf `about_dialog_github` (Dialogbauer, 03.11.2026) — nur L-138.7 und L-138.8

| Fund | was geschah |
|---|---|
| [L-138.7](#l-138.7) | CHANGELOG, FUNKTIONEN und WEITERMACHEN sagen nicht mehr „bricht um“, sondern dass *Log* und *Mail folder from* Platz für zwei Zeilen haben. CHANGELOG nennt, was gemessen ist: der Umbruch für *Log* am langen Prüfstandspfad (114 Zeichen, 26 Pixel nötig, 33 Platz), für *Mail folder from* nicht. Der gemessene Stand hat jetzt eine Kennung (`7.2.1.131+f209fd82*`, also die Änderungen auf dem Merge `f209fd82` vor dem Commit). Die Logzeile bleibt bei `DEBUG_MASK_MISC`, ein Fehler zeigt zusätzlich eine Meldung. |
| [L-138.8](#l-138.8) | `main` (#211–#214) hereingeholt; der E-216-Satz steht als eigener Satz vor dem heutigen Kopf von WEITERMACHEN. |

## Nachtrag 2 (03.11.2026, about_dialog_github nach caf1c0d7)

`origin/about_dialog_github` (Spitze `caf1c0d7` *„[E-216](../Intern/BEFUNDE.md#e-216) nach [PRUEFER-91](PRUEFER-91.md#pruefer-91): Zeile "Log:" zweizeilig (K1), Test und Messung geschaerft (K3), Erfolg aus ShellExecuteEx (K4)“*) in `wt/lektor-20261103c` gemergt. Konflikt nur in diesem Bericht: der Abschnitt *Eingearbeitet auf `about_dialog_github`* des Dialogbauers und mein Nachtrag 1 stehen jetzt beide da. Gelesen gegen den Bestand: [E-216](../Intern/BEFUNDE.md#e-216) (im About-Dialog überdecken sich die Knöpfe, es fehlt der Weg zum neuesten Release), CHANGELOG, FUNKTIONEN, TESTPLAN *e-216-naechstes*, WERKZEUGE `messen-about`, WEITERMACHEN-Kopf, PRÜFER-91 *Eingearbeitet*.

| Fund | Stand | Stelle |
|---|---|---|
| [L-138.7](#l-138.7) „bricht um“ als Tatsache | **erledigt in CHANGELOG und FUNKTIONEN, im Eintrag ein Rest** ([L-138.11](#l-138.11)) | `CHANGELOG.md:176` *„haben Platz für zwei Zeilen (am Prüfstand gemessen ist der Platz; dass ein langer Text tatsächlich in die zweite Zeile umbricht, ist für *Log* mit langem Pfad gemessen, für *Mail folder from* nicht)“*; `Doku/FUNKTIONEN.md:269` *„haben Platz für zwei Zeilen“*; gemessener Stand mit Kennung `7.2.1.131+f209fd82*` |
| [L-138.8](#l-138.8) WEITERMACHEN vor #214 | **erledigt** | `Intern/WEITERMACHEN.md:3` beginnt mit dem E-216-Satz, danach der heutige Kopf *„Laufend: `e170_label_ohne_uidplus`, `about_dialog_github`“*; die ältere Liste mit `e128_…` steht weiter hinten als Rückblick |

Trifft (gelesen): TESTPLAN Schritte 1–3 (*Ort: lokal*, Schritt 2 *„Eudora zeigt dabei keine Meldung“* nach K4); PRÜFER-91 *Eingearbeitet* (`Befunde/PRUEFER-91.md:107-121`) gegen den Eintrag — K1, K3, K4 behoben, K2/K5/K6/K7 unter *Grenze* mit Häufigkeit und Folge (*„sehr selten, *Copy info* hat den vollen Text“*, *„harmlos“*, *„ohne Wirkung“*, *„nur bei einem *Pre-release*“*) — so gewichtet, wie Gregor es will. Interne Angaben: im Eintrag stehen nur Prüfstandspfade unter `C:\Temp` und die öffentliche Release-Adresse (`grep 'Users'` im Eintrag → nichts).

### <a id="l-138.11"></a>L-138.11 — E-216: „Nicht gemessen: der Umbruch selbst“ steht noch allgemein

**Gewicht: Kleinkram.** (gemessen am Text)

- `Intern/BEFUNDE.md` ([E-216](../Intern/BEFUNDE.md#e-216)) *„**Nicht gemessen:** der Umbruch selbst — die Herkunft im Prüfstand ist 30 Zeichen kurz und passt in eine Zeile (`noetig=13`)“*; derselbe Eintrag danach: *„die Zeile *Log* hat 114 Zeichen und braucht 26 Pixel bei 33 Platz“* — für *Log* ist der Umbruch gemessen, und das CHANGELOG sagt es richtig.

**Vorschlag:** *„Nicht gemessen: der Umbruch von *Mail folder from* (die Herkunft im Prüfstand ist 30 Zeichen kurz …)“*.

### <a id="l-138.12"></a>L-138.12 — CHANGELOG nennt nur `E-216p`, WERKZEUGE-Kopfsatz nur *Mail folder from*

**Gewicht: Kleinkram.** (gemessen)

- `CHANGELOG.md:176` endet *„Regressionstest `TestE216.cpp`, Prüfstandsfall `E-216p` (`tools/messen-about.ps1`)“* — der neue Fall `E-216l` (langer Pfad, `LogLevel=25759`), der allein den Umbruch von *Log* misst, fehlt.
- `tools/WERKZEUGE.md:171` fragt im fetten Kopf *„… und ist die Zeile *Mail folder from* mehr als eine Zeile hoch?“*; das Skript misst seit K3 alle sechs Pfadzeilen (*„Ausgabe `ABOUT ERGEBNIS … log-zeilen= passt= rand= …`; Fälle `E-216p` und `E-216l`“*, dieselbe Zeile).

**Vorschlag:** CHANGELOG *„Prüfstandsfälle `E-216p`, `E-216l`“*; WERKZEUGE-Kopf *„… und passen die Pfadzeilen (*Log*, *Mail folder from* zweizeilig)?“*.

Neu: zwei Funde (Kleinkram). Was nur Gregor entscheiden kann: weiter nichts Neues. (PRÜFER-91 K7 — *Latest Release* zeigt kein *Pre-release* — betrifft nur, wenn 7.2.2.x als Vorabversion erschiene; die Form des Releases entscheidet Gregor ohnehin beim Veröffentlichen, eine Frage ist es erst dann.)
