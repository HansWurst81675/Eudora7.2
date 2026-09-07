# LEKTOR-3 — Falsche und veraltete Werte in der Doku, gemessen statt gelesen

**Agent:** LEKTOR · **Kennung:** `L-7` · **Zweig:** `wt/lektor` ·
**Arbeitsbaum:** `Eudora7.2-wt-lektor` · **Datum:** 07.09.2026 ·
**Bezugscommit:** `060a4bf`

**Nicht gebaut, Eudora nicht gestartet, keine Zeile Quelltext geändert.** Jede
Aussage unten ist am Baum gemessen; der Messbefehl steht dabei.

## Der Anlass

> *„ich hasse es, wenn in den dokus falsche oder veraltete infos und werte
> stehen. das muss immer parallel gleich erledigt werden, klar?"*

Vorher hatte Gregor selbst drei Widersprüche gefunden — `ZIEL.md` mit vier
Kriterien, wo sieben verabredet waren; „Alle vier Kriterien sind erfüllt" im
`CHANGELOG` gegen „drei von vier" in `ZIEL.md`; und das Wort *„Durchbruch"* für
eine Fassung, in der aus Anwendersicht nichts passiert. Dieser Durchgang soll
dafür sorgen, dass er solche Fehler nicht mehr findet.

## Was am schwersten wog

**Vier Behauptungen waren nicht nur veraltet, sondern falsch, und alle vier
hätten jemanden in die Irre geführt, der danach gearbeitet hätte.**

### L-7.1 — „E-15 und E-18 bis E-21 gibt es nicht" — fünf Befunde für nie vergeben erklärt

`BEFUNDE.md` führte einen Kasten:

> *„**E-10, E-15, E-18 bis E-21 gibt es nicht.** Gesucht am 06.09.2026 im ganzen
> Repo: diese Kennungen sind nie vergeben worden. Lücken in der Nummerierung,
> keine verlorenen Befunde — wer sie sucht, sucht umsonst."*

**Gesucht worden war nur in den `.md`-Dateien.** Fünf der sechs Kennungen sind
in **Quellkommentaren** vergeben und dort auch begründet:

```sh
grep -rn "Befund E-18" --include=*.cpp --include=*.h Eudora71/
```

| Kennung | Quelle | Worum es geht |
|---|---|---|
| E-15 | `Eudora71/Eudora/TaskStatusView.cpp`, `QCGetTaskStatusView` | `ASSERT(g_TaskStatusView != NULL)` widersprach allen drei Aufrufern (`persona.cpp:265` und `:576`, `settings.cpp:1492`) — die fragen ausdrücklich auf NULL ab |
| E-18 | `Eudora71/Eudora/headervw.cpp`, Persönlichkeitsmenü | `pFld` ungeprüft dereferenziert; der Zweig läuft nur bei **mehr als einer** Persönlichkeit und war bis 05.09.2026 nie betreten |
| E-19 | `Eudora71/Eudora/tocdoc.cpp` | `ASSERT(0)` in einem **Reparaturzweig** — feuert genau dann, wenn alles wie vorgesehen läuft |
| E-20 | `Eudora71/Eudora/ListCtrlEx.cpp`, `CListCtrlEx::InsertArr` und `NotifyInsertedCol` | `[nLen + 1]` statt `[nIdx + 1]`; geschrieben wird bis `pTemp[nIdx]`, und `nIdx` kann größer als `nLen` sein |
| E-21 | `Eudora71/QCSocket/src/QCWorkerSocket.cpp` | `ASSERT(0)`, wo `WSAEWOULDBLOCK` (10035) die normale Antwort eines nicht blockierenden Sockets ist |

E-18 und E-19 stehen sogar im `CHANGELOG.md` unter 7.2.0.10 (*„zwei Fehler, die
erst mit einer zweiten Persönlichkeit auftreten"*) — die Datei widersprach also
einer anderen Datei, die zwei Bildschirmseiten weiter oben verlinkt ist.

**Nur E-10 ist wirklich eine Lücke**; das ist in `PRUEFUNG-BRANCH.md`
unabhängig belegt.

**Alle fünf sind jetzt im Verzeichnis**, mit Fundstelle und Status, und die
Lehre steht dabei: **wer prüft, ob eine Kennung vergeben ist, muss den
Quelltext mitsuchen.**

### L-7.2 — „der ernsteste der neun" war ein Fehlalarm des eigenen Werkzeugs

`AUFGABEN.md`, D3a, Nummer 1:

> *„`EuImap/src/ImapMailbox.cpp:1637` → `:1659` (`pImapCommand`) — der Block des
> Wächters ist `if (!pImapCommand) { ASSERT(0); … }` **ohne `return`**. Im
> **Release** entfällt das `ASSERT`, dann läuft es weiter und greift auf den
> Nullzeiger zu. **Der ernsteste der neun.**"*

Nachgesehen in `CImapMailbox::CheckMail`: der Block **endet mit
`return E_FAIL;`**. Nach dem Wächter ist der Zeiger belegt, der Zugriff bei
`:1659` ist in Ordnung.

Der Treffer ist ein **Fehlalarm von `tools/suche-zeiger.pl`**: bei einem
**negativen** Wächter (`if (!p)`) sucht das Werkzeug das `return` nur in den
nächsten sechs Zeilen — hier steht es fünfzehn Zeilen weiter, weil zwischen
`ASSERT(0)` und `return E_FAIL` noch aufgeräumt wird. Das ist eine **vierte
Fehlerklasse** neben den drei, die X-1 an diesem Werkzeug schon abgestellt hat.

**Sie gehört ins Werkzeug, nicht in die Aufgabenliste** — und ist deshalb hier
als offene Aufgabe benannt, nicht behoben: `suche-zeiger.pl` hat keine
Testsammlung, und ein Filter ohne Testfall ist genau der Fehler, den Auflage 10
verbietet.

Nebenbei bei derselben Messung: die drei *„unklaren"* Treffer waren zu zwei
Dritteln verschwunden. `CompMessageFrame.cpp` und `StatMng.cpp` melden nichts
mehr, `ImapAccount.cpp:3152` ist ein gewöhnlicher positiver Wächter. Die Liste
in D3a ist vollständig neu gemessen und trägt jetzt **Funktionsnamen** —
`headervw.cpp` allein war um 34 Zeilen verrutscht.

### L-7.3 — `WazooBarMgr.cpp:377-400` ist auskommentierter Code

`AUFGABEN.md`, E1, beschrieb den größten verbliebenen Darstellungsmangel an
`WazooBarMgr.cpp:377-400`. **Jede Zeile dieses Bereichs beginnt mit
`//FORNOW`** — der Bereich ist vollständig auskommentiert:

```sh
sed -n '370,400p' Eudora71/Eudora/WazooBarMgr.cpp
```

Die **lebenden** Stellen sind `CWazooBarMgr::CreateNewWazooBar` (heute
Zeile 254) und `CWazooBarMgr::SetDefaultWazooBarState` (heute Zeile 424); beide
schicken `ID_SEC_MDIFLOAT` und sind seit Befund **E-4** im Quelltext
ausdrücklich abgesichert. Berichtigt, mit Funktionsnamen.

### L-7.4 — `LinkLibraryDependencies` kommt in `Eudora.vcxproj` nicht vor

`PORTIERUNG.md` begründete, warum die Attrappe `OTA50D.LIB` nicht mehr gebraucht
wird, mit *„`_SECNOMSG` und `LinkLibraryDependencies` auf `false`,
`Eudora.vcxproj:1015`"*. Gemessen:

```sh
grep -n "LinkLibraryDependencies" Eudora71/Eudora/Eudora.vcxproj   # 0 Treffer
grep -c "ReferenceOutputAssembly>false" Eudora71/Eudora/Eudora.vcxproj   # 15
grep -c "<ProjectReference" Eudora71/Eudora/Eudora.vcxproj               # 15
```

Das Element heißt `ReferenceOutputAssembly` und steht bei **jedem** der 15
Projektverweise. `LinkLibraryDependencies` gibt es in der Datei nicht.
**Und zwanzig Zeilen weiter unten** sagte dieselbe Datei in einem
Berichtigungskasten vom 06.09.2026 schon, dass die Zeilenangabe `:1015` nicht
stimmt — sie widersprach sich also selbst.

## Zahlen, die nicht stimmten

| Wo | Stand | Gemessen | Messweg |
|---|---|---|---|
| `ZIEL.md` | *„Vier von sieben Kriterien sind belegt, eines fast, drei nicht"* | **drei** belegt (0, 1, 3), eines fast, **vier** nicht — die alte Summe war außerdem 8 bei sieben Kriterien | die Tabelle in derselben Datei |
| `README.md`, `WEITERMACHEN.md`, `PORTIERUNG.md` | dieselbe Aussage, dreimal wiederholt | dito | dito |
| `README.md`, `ZIEL.md`, `WEITERMACHEN.md` | „sieben Kriterien" | die Tabelle führt **acht** (0 bis 7) | `perl tools/doku-pruefen.pl` |
| `AUFGABEN.md` A2 | „24 Stellen sind zu ändern", 19 `falsch` | **21** zu ändern: 16 `falsch`, 4 `lockbuffer`, 1 `danach`, dazu 116 `ok` | `perl tools/releasebuffer-pruefen.pl --alle` |
| `BEFUNDE.md`, R-1 | „25 von 142" | **21 von 137** | dito |
| `PORTIERUNG.md` | „142 Vorkommen im Baum, 25 davon falsch" | dito | dito |
| `CHANGELOG.md` | „`PGSOURCE`, 38 C-Dateien" | **37** `.C` — `git ls-files` liefert 38 Einträge, davon einer `.SBT` | `git ls-files Eudora71/PaigeDLL/PGSOURCE` |
| `BEFUNDE.md`, Kopf | „7349 Zeilen" | **7373** | `wc -l < BEFUNDE.md` |
| `Releases/PAKETE.md`, 1.0.3 | „`Eudora.exe` 2 933 248 B" | **2.933.760 B**, 512 Byte mehr | `unzip -l Releases/Eudora72-1.0.3-release.zip` |
| `README.md` | „Drei davon sind seit 7.2.0.14 angemeldet", „ein Bericht ab 7.2.0.14" | **7.2.0.13** (ausgeliefert erstmals in Paket 1.0.14); `absturz-auswerten.pl` sagt selbst *„Ab 7.2.0.13 schreibt Eudora sie selbst mit"* | `CHANGELOG.md`, Abschnitt 7.2.0.13; `tools/absturz-auswerten.pl:520` |
| `README.md` (Werkzeugtabelle) | „Modultabelle des Berichts (ab 7.2.0.14)" | dito | dito |

**Nachgemessen und richtig** — damit der Bericht nicht nur die Fehler zeigt:
alle drei SHA256 in `Releases/PAKETE.md` (1.0.1, 1.0.2, 1.0.3) und der
QCSSL-Hash stimmen auf das Byte, ebenso die ZIP-Größen 9.207.607, 12.808.796
und 1.489.032 und die `Eudora.exe` mit 10.201.088 B in 1.0.2. Zusätzlich sind
**alle neun** beiliegenden `.sha256` gegen ihr ZIP geprüft — neun von neun in
Ordnung. Von den Fundstellen der Form `datei.cpp:1234` in den sieben
Stand-Dateien stimmen unter anderem `QCChildToolBar.cpp:62`, `pop.cpp:663`,
`lex822.cpp:544`, `ImapDownload.cpp:4644` und `:4662`, `QCSSLContext.cpp:53`
und `:569`, `qccertificate.cpp:101`/`110`/`157`, `secbtns.h:340`,
`OTShim.h:307`, `mime.cpp:382`, `Eudora.vcxproj:147`, `stdafx.h:52`,
`QCSocket.vcxproj:60` und die vier libpng-Stellen in `QCGraphics.cpp`
(306, 313, 316, 354).

## Zustandsaussagen, die überholt waren

Der schlimmste Fall war der Abschnitt *Wo man weitermachen kann* am Ende von
`CHANGELOG.md`. Punkt 1 hieß **„E-27: die Rekursion in Paige (der große
Brocken)"** und fragte, ob in dieser Portierung überhaupt jemals ein
Paige-Fenster entsteht — beantwortet und behoben am 06.09.2026. Darin stand:

> *„**Was Paige angeht:** `Eudora71/PaigeDLL` enthält nur Kopfdateien und
> Makefiles, keine Quellen."*

Das widersprach dem eigenen Abschnitt 7.2.0.18 derselben Datei (*„Es gibt Paige-
Quellen"*). Und unter **„Noch nicht versucht"** stand *„ein Vergleich der
Strukturgrößen `style_info`/`font_info`/`par_info` zwischen `PAIGE.H` und dem,
was die DLL von 2005 erwartet"* — genau die Messung, die E-31 gelöst hat, drei
Bildschirmseiten weiter oben ausführlich beschrieben.

Die übrigen:

| Datei | Behauptung | Wirklichkeit |
|---|---|---|
| `README.md` | Quellstand 7.2.0.14, Paket 1.0.14, ZIP `1.0.14` | 7.2.0.18 / 1.0.18, Marke `v1.0.18` auf `e881164` (`git ls-remote --tags origin`) |
| `README.md` | *„Die Suche nach der Wurzel der Abstürze … Die Beschädigung selbst ist gefunden (**E-25**)"* | die Wurzel ist **E-31**; E-25 hat den Test nicht bestanden, das stand schon als Nachtrag darunter |
| `README.md` | *„**Strg-N** beendet Eudora; die schuldige Zeile ist **nicht** gefunden"*, *„**Beenden** bricht ab"*, *„E-30, in Arbeit"* | E-31 und E-32 behoben, E-30 behoben und von Gregor bestätigt |
| `WEITERMACHEN.md` | Quellstand 7.2.0.17, zuletzt veröffentlicht v1.0.15, Arbeitszweig `strg-n-diagnose` | 7.2.0.18 / v1.0.18; der Zweig ist mit PR #9 (`95298b1`) zusammengeführt |
| `WEITERMACHEN.md` | *„Alle drei hängen an einem einzigen Fehler: E-27"*, *„Die nächste Frage: Entsteht überhaupt jemals ein Paige-Fenster?"* | beantwortet und behoben |
| `AUFGABEN.md` | *„Alle drei hängen an E-27"*; B2 (gesperrte Knöpfe) als Aufgabe; C2 (Kriterium 0 nachweisen) als Aufgabe; C1 *„Solange das offen ist, ist Kriterium 0 nicht nachweisbar"* | E-30 und Kriterium 0 sind von Gregor bestätigt |
| `AUFGABEN.md` B1 | verwies auf einen Abschnitt *„Ganz zuerst"* | den gibt es in der Datei nicht |
| `ZIEL.md` | *„Für das Release-Paket ist dieser Lauf noch nicht gemacht worden"* | Gregor hat `1.0.10-release.zip` am 06.09.2026 ohne VS gestartet — steht in derselben Datei zwei Tabellenzeilen höher |
| `ZIEL.md` | *„Kriterium 0 steht vor den anderen dreien"* | es sind sieben andere |
| `CHANGELOG.md`, `README.md`, `WEITERMACHEN.md` | E-32 als **offen**, Verdacht auf `AutoCompleterListBox::KillACListBox` | seit `060a4bf` behoben; die Ursache war der **ungeprüfte Zeiger auf dem Weg dorthin** (`CHeaderView::OnKillFocusRecipient`) |
| `CHANGELOG.md`, Abschnitt 7.2.0.18 | ein Punkt behauptete, die Spur ende bei *„Auswahlfelder gefüllt"* | drei Absätze darüber steht, sie laufe bis `OnMessageNewMessage: fertig` durch — der Punkt gehörte zu 7.2.0.17 und ist entfallen |
| `PORTIERUNG.md` | *„die Prüfstandsmarke oben steht deshalb weiter auf `d826a3f`"* | oben stand `9512108` |
| `Releases/PAKETE.md` | *„Kriterium 0 bleibt trotzdem offen: kein Paket ist auf einem Rechner ohne Visual Studio ausgepackt und gestartet worden"* | erfüllt seit 06.09.2026 |
| `Releases/PAKETE.md` | *„Produktversion … dazu die Dateiversion der `Eudora.exe`"* | `Eudora.exe` hat **gar keinen** `VS_VERSION_INFO`-Block; die Version steckt über `EUDORA_BUILD_DESC` im String `IDS_VERSION` |

## L-7.5 — `EUDORA_BUILD_NUMBER` hinkt seit 7.2.0.13 hinterher

`Releases/PAKETE.md` nennt für eine neue Nummer **fünf Zeilen in zwei Dateien**.
Eine davon ist seit sechs Fassungen nicht mitgezogen worden:

```sh
grep -n "EUDORA_" Eudora71/Version.h
#   EUDORA_VERSION4        18
#   EUDORA_BUILD_NUMBER    7,2,0,12      <-- steht auf 12
#   EUDORA_BUILD_DESC      "Version 7.2.0.18\0"
#   EUDORA_BUILD_VERSION   "7.2.0.18"
```

**Kein Werkzeug hat das gemeldet.** `perl tools/ausliefern.pl --pruefen` und
`perl tools/kennung-erzeugen.pl` laufen beide sauber durch; sie vergleichen nur
`EUDORA_BUILD_VERSION` gegen `VERSION`.

Folgenlos ist es **derzeit** nur, weil das Makro nirgends benutzt wird:

```sh
grep -rn "EUDORA_BUILD_NUMBER" Eudora71/    # ein Treffer: die Definition selbst
```

Wer es je in eine `VERSIONINFO`-Ressource einsetzt, bekommt eine `Eudora.exe`,
deren Dateiversion nicht zu ihrer Produktversion passt.

**Nicht behoben** — das ist Quelltext, und LEKTOR fasst keinen Quelltext an.
Stattdessen: `tools/doku-pruefen.pl` meldet den Fall jetzt bei jedem Lauf unter
*ZU TUN am Quellstand*, und in `Releases/PAKETE.md` steht ein Kasten dazu.
**Eine Zeile in `Eudora71/Version.h`, wenn Gregor sie freigibt.**

## Erfolgston

Gregors Einwand zum Wort *„Durchbruch"* gilt allgemein: die Doku beschreibt, was
der **Anwender** hat. Umgeschrieben:

* `ZIEL.md`: *„was übrig bleibt, ist ein **einzelner benannter Punkt** statt
  einer ganzen Bibliothek"* — es sind drei offene Punkte, und ob der Anwender ein
  Fenster sieht, entscheidet sein Rechner, nicht diese Datei.
* `README.md`: Gregors Urteil war **verkürzt zitiert**, *„beenden kann ich es
  auch nicht"* fehlte. Vollständig eingesetzt.
* Überall, wo E-31 oder E-32 vorkommen, steht jetzt dazu, dass **niemand es auf
  Gregors Rechner nachgemessen hat** und dass E-32 **nicht in Paket 1.0.18**
  steckt.
* Nach den Wörtern „Durchbruch", „endlich", „Meilenstein", „geschafft" gesucht:
  in den sieben Stand-Dateien kein Treffer mehr.

## Die Schranke: `tools/doku-pruefen.pl`

Beim ersten Lauf am 06.09.2026 hat das Werkzeug acht Widersprüche gemeldet —
**vier davon waren Fehlalarme**, alle aus derselben Wurzel: die Statusprüfung
nahm *jedes* Wort „offen" oder „behoben" *irgendwo* in derselben Zeile als
Status der Kennung.

| Meldung | Warum sie falsch war |
|---|---|
| E-7 behoben **und** offen | die Verzeichniszeile lautet *„die Bau-Kennung fehlt im Titel, solange kein Postfach **offen** ist"* — gemeint ist ein aufgeklapptes Postfach |
| E-11 behoben **und** offen | die Zeile ist `\| R-1 \| die Fehlerklasse hinter E-11 ausgezählt \| **offen** …` — der Status gehört **R-1** |
| E-14, E-16 behoben **und** offen | *„**Z-3** stand auf „offen", ist aber behoben; **E-14**, **E-16**, … fehlten im Verzeichnis"* — der Status gehört **Z-3** |

Nach der Berichtigung von `ZIEL.md` kamen zwei weitere derselben Art dazu
(E-31 und E-32 in der Kriterienzeile, wo „nicht erfüllt … bleibt das Kriterium
offen" und „behoben" in einer Zeile stehen). **Eine Schranke, die umsonst
warnt, wird ignoriert** (X-1) — deshalb umgebaut.

**Jetzt gilt:** ein Status zählt nur, wo die Kennung ihn **besitzt** — allein in
der **ersten Spalte** einer Verzeichniszeile, und der Status **fett**.
Überschriften sind Zeitdokumente (`## E-5 … (31.08.2026, OFFEN)`) und werden
nicht gegen das heutige Verzeichnis gehalten.

Dafür sind drei scharfe Prüfungen dazugekommen:

| Prüfung | Was sie findet |
|---|---|
| 4a | eine Kennung mit **zwei Abschnitten** in `BEFUNDE.md` — Gregors dritter Widerspruch war genau das (E-31 zweimal vergeben) |
| 4b | zwei Verzeichniszeilen zur selben Kennung mit **verschiedenem** Status |
| 4c | was im `CHANGELOG` unter *Noch offen* steht, muss im Verzeichnis stehen und darf dort **nicht behoben** sein. **Diese Prüfung hätte das heutige Problem gefunden:** E-32 stand als offen im `CHANGELOG` und war behoben |
| 7 | `Eudora71/Version.h` gegen sich selbst und gegen `VERSION` — daran ist L-7.5 aufgefallen |

Prüfung 6 (Fassungsstand) hat `AUFGABEN.md` zu Unrecht angeschwärzt, weil die
Datei `7.2.0.17` als **Fundstelle** nennt (*„die sieben Vermutungen stehen unter
7.2.0.17"*). Eine Datei gilt jetzt als aktuell, wenn sie den Quellstand **oder**
die Paketnummer nennt.

**Ein Fehler im Werkzeug selbst**, gefunden und behoben: gelesen wird mit
`:raw`, also byteweise — das Muster für die Überschrift enthielt `\x{2014}` als
**Zeichen** und konnte die drei Bytes `E2 80 94` nie treffen. Prüfung 4a lief
dadurch ins Leere. Mit Gegenprobe belegt: vorher stumm, nachher meldet sie.

### Fünf Gegenproben auf einem Kopierbaum

Nicht am Repo, sondern an einer Kopie im Kratzverzeichnis — sonst ist die
Gegenprobe ein Eingriff.

| | Eingriff | Erwartet | Ergebnis |
|---|---|---|---|
| A | „Sieben Kriterien" in `ZIEL.md` | Meldung | `ZIEL.md:19 nennt 7 Kriterien, ZIEL.md fuehrt 8` |
| B | E-33 im Verzeichnis auf `**behoben**` | Meldung (4c) | `E-33 steht in CHANGELOG.md:16 unter 'Noch offen', im Verzeichnis aber als behoben` |
| C | zweite Überschrift `## E-7 — …` | Meldung (4a) | `E-7 hat in BEFUNDE.md zwei Abschnitte` |
| D | E-33-Zeile aus dem Verzeichnis entfernt | Meldung (4c) | `… fehlt aber im Verzeichnis von BEFUNDE.md` |
| E | unverändert, mit der E-7-Prosa | **stumm** | stumm — kein Fehlalarm |

### Eingehängt, aber nicht installiert

`tools/hooks-einrichten.sh` ruft das Werkzeug jetzt als Schritt 4 auf,
**abweisend nur, wenn der Commit eine `.md`, `VERSION` oder
`Eudora71/Version.h` anfasst** — ein Commit, der nur Quelltext ändert, soll
nicht an einem Widerspruch zwischen zwei Markdown-Dateien hängen bleiben.

**Der eingerichtete Hook im gemeinsamen git-Verzeichnis ist bewusst NICHT
überschrieben.** Die anderen Arbeitsbäume haben die berichtigten Dateien noch
nicht; die Schranke würde dort auf ihrem alten Stand anschlagen und fremde
Arbeit blockieren. **Nach dem Merge einmal `sh tools/hooks-einrichten.sh`.**

## Was ich bewusst stehen gelassen habe

| Was | Warum |
|---|---|
| **Alle Messwerte in den Prüfberichten** (`PRUEFUNG-*.md`, `Pruefung/*.md`, `Befunde/*.md`) | Ein Bericht ist ein Zeitdokument. Überholt ist nur die *Schlussfolgerung*, und die wird mit einem datierten Nachtrag gekennzeichnet, nicht ersetzt |
| **Die Überschriften in `BEFUNDE.md` mit `(31.08.2026, OFFEN)`** | dito — sie sagen, was an jenem Tag galt. Das Verzeichnis oben ist die einzige Quelle für den heutigen Status, und `doku-pruefen.pl` liest deshalb nur dieses |
| **`EUDORA_BUILD_NUMBER` auf `7,2,0,12`** | Quelltext. Siehe L-7.5 — eine Zeile, wenn Gregor sie freigibt |
| **Der Fehlalarm in `tools/suche-zeiger.pl`** (negativer Wächter, `return` weiter als sechs Zeilen entfernt) | Ein Filter ohne Testfall ist der Fehler, den Auflage 10 verbietet, und `suche-zeiger.pl` hat keine Testsammlung. Als Aufgabe benannt, siehe L-7.2 |
| **`README.md`: „`Eudora.map`, 51.075 Einträge" und „18 erfolgreich, 0 Fehler, 1 übersprungen, 2:37 min"** | beides entsteht erst beim Bau, und ich baue nicht. Gregors eigene Messung vom 06.09.2026 |
| **`README.md`: „30 Stellen, 22 Stingray-Klassen, 77 Methoden"** | Die Zählweise ist nicht dokumentiert, und mir ist keine Rekonstruktion gelungen, die genau diese drei Zahlen ergibt. Raten wäre schlimmer als stehen lassen. **Weiter zurückgestellt** (schon aus L-6) |
| **`Releases/PAKETE.md` ohne Abschnitte für 1.0.4 bis 1.0.17** | Für die meisten liegt kein ZIP im Repo; Größen und Prüfsummen wären erfunden. **M-4** bleibt offen und steht dort benannt. Für 1.0.18 ist der Abschnitt jetzt da, weil dafür alles messbar war |
| **`Eudora71/Eudora/mainfrm.cpp`, alte Bau-Kennung im Kommentar (M-9)** | Quelltext |

## L-7.6 — Zwei Fehlerklassen, nicht viele Einzelfehler

1. **Eine Datei, die „was jetzt gilt" behauptet, sammelt Vergangenheit an.**
   `README.md` und `CHANGELOG.md` trugen ganze Abschnitte über eine Suche, die
   längst beendet ist — Heap-Beschädigung, E-25, „die schuldige Zeile ist nicht
   gefunden". Niemand löscht so etwas, weil darin Arbeit steckt.
   **Schranke:** widerlegte Vermutungen gehören ins `CHANGELOG` unter die
   Fassung, in der sie widerlegt wurden, und werden dort **als widerlegt**
   benannt. In der Stand-Datei steht ein Satz und ein Verweis.
2. **Eine Prüfung, die nur die halbe Menge durchsucht, erzeugt eine falsche
   Gewissheit.** „E-15 und E-18 bis E-21 gibt es nicht — gesucht im ganzen Repo"
   war eine Suche in `*.md`. Das Ergebnis war nicht nur falsch, es war als
   **geprüft** gekennzeichnet, und das ist schlimmer als eine offene Frage.
   **Schranke:** wer „im ganzen Repo gesucht" schreibt, schreibt den **Befehl**
   dazu. Steht er da, sieht der nächste Leser die Lücke.

## L-7.7 — Arbeitsweise und Byte-Messung

**Kein Edit-Werkzeug an Markdown.** Alle Änderungen über
`tools/ersetze-bereich.pl`, das mit `:raw` liest und schreibt und Kopf und Rumpf
byteweise durchreicht und bei Abweichung abbricht. Nach jeder Datei gemessen und
**gegen `HEAD` gehalten**, nicht gegen null:

```sh
perl -e 'open(my $h,"<:raw",$ARGV[0]);local $/;my $d=<$h>;
  my $cr=()=$d=~/\r/g; my $dk=()=$d=~/\xC3\x83\xC2|\xC3\xA2\xC2\x80|\xC3\x82\xC2/g;
  print "CR=$cr DK=$dk\n"' DATEI.md
```

| Datei | CR | DK vorher | DK nachher |
|---|---|---|---|
| `README.md`, `ZIEL.md`, `WEITERMACHEN.md`, `AUFGABEN.md`, `CHANGELOG.md`, `Releases/PAKETE.md` | 0 | 0 | 0 |
| `PORTIERUNG.md` | 0 | 1 | 1 |
| `BEFUNDE.md` | 0 | 3 | 3 |

Die vier Doppelkodierungstreffer sind die bekannten **zitierten** Beispiele in
den Umlautbefunden (Z-2, Z-2b) und gehören dort hin.

**Ein Fund für den nächsten Durchgang:** ein Ersetzungstext mit `\\` durch die
Befehlszeile zu reichen frisst eine Ebene — aus `s{\\}{/}g` wurde `s{\}{/}g`,
und Perl schluckte die folgenden Zeilen in das Suchmuster. Ein Hilfsskript ist
daran gescheitert, bevor es überhaupt lief. **Backslashes gehören über eine
Datei in den Perl-Code**, nie inline durch die Shell.
