# <a id="lektor-47"></a>LEKTOR-47 — die Papiere zu 1.0.119: der Befund ist sauber, die Buchführung um ein Release und ein Paket daneben

Kurzer, eiliger Nachlauf am 21.10.2026 im Arbeitsbaum `Eudora7.2-wt-lektor`,
Zweig `wt/lektor-20261021`, Ausgang `c70297c5`. Anlass: **Gregor wartet auf das
Paket 1.0.119**, und die beiden Commits `14786286` und `c70297c5` haben die
Papiere dazu geschrieben. Geprüft wurden die Papiere, kein Quelltext.

## Maßstab von außen

Nichts davon aus einem Dokument des Projekts ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)):

| Quelle | Wert |
|---|---|
| `git tag \| sort -V \| tail -1` | **`v1.0.117`** |
| `gh release view v1.0.117 --json publishedAt` | **`2026-10-21T07:56:56Z`** (`createdAt` 07:56:11Z), Marke `f546b004`, *Latest* |
| `Eudora71/Version.h:13-14` | `7.2.0.119` |
| `VERSION` | `1.0.119` |
| ZIPs im Hauptbaum `Releases/` | jüngstes **`Eudora72-1.0.118-release.zip`** — **kein** `…-1.0.119-…` |
| `ls C:\Users\Gregor\Eudora72-*` | 1.0.110–1.0.113, 1.0.115–1.0.118 — **kein 1.0.119** |
| `gh issue view 102` | der freigegebene Beitrag ist **abgeschickt**, 21.10.2026, 08:13:26 UTC |
| `tools/RELEASES.md:36` | die `v1.0.117`-Zeile steht **in** der Tabelle (Ortszeit `09:56:57`) |
| `EudoraRes.rc:5806` / `:2586` / `:1702` | *Tools* → `&Address Book` mit `Ctrl+L` (`ID_WINDOW_NICKNAMES`), Knopf `&New` (`IDC_NICKNAME_LEFT_NEW`), Feld `&Nickname:` |
| `nickview.cpp:1266` | *„Eudora Nicknames address book is called NNdbase.txt"* |
| Uhr | 21.10.2026 |

**Werkzeuge vorher:** `doku-pruefen.pl` kein Widerspruch (9 Hinweise *zur
Kenntnis*, alle berechtigt — ältere Release-Notizen und zwei Testdaten-MDs),
`commit-bereit.pl` **33 Schranken, keine weist ab**. **Nachher** dieselben
Werte. **Keine Schranke hat einen der zwölf Funde gesehen** — dasselbe Muster
wie in [L-46.8](LEKTOR-46.md#l-46.8): sie messen Dokumente gegen Dokumente.

---

## Das Paket, das es noch nicht gibt

### <a id="l-47.1"></a>L-47.1 — `Releases/PAKETE.md` führte 1.0.119 als geschnürt und bei Gregor bereitgestellt (hoch, der schwerste Punkt)

Der neue Abschnitt trug in der Überschrift *„geschnürt am 21.10.2026 nach
`C:\Users\Gregor\Eudora72-1.0.119-release`"* und in der ersten Zeile der
Tabelle *„Testverzeichnis | bereitgestellt am 21.10.2026,
`C:\Users\Gregor\Eudora72-1.0.119-release`"*.

**Gemessen, beides falsch:** unter `Releases/` liegt kein
`Eudora72-1.0.119-release.zip` — das jüngste ZIP ist `…-1.0.118-…` —, und bei
Gregor steht kein Verzeichnis `Eudora72-1.0.119-release`; dort sind 1.0.110 bis
1.0.113 und 1.0.115 bis 1.0.118. Der Zweig trägt `VERSION 1.0.119` und einen
Bau mit 243 Tests, mehr nicht.

**Warum das mehr ist als eine Formulierung.** Gregor wartet in genau diesem
Moment auf das Paket. Die Buchführung ist die Stelle, an der nachgesehen wird,
**ob er es schon hat** — und sie hätte *ja* gesagt. Dasselbe Papier ist am
20.10. und zweimal am 21.10. wegen derselben Klasse berichtigt worden
([L-45.2](LEKTOR-45.md#l-45.2), [L-46.4](LEKTOR-46.md#l-46.4)); diesmal zeigt
der Fehler in die **andere** Richtung: nicht die Abwesenheit einer Sache wird
behauptet, die es gibt, sondern die Anwesenheit einer Sache, die es nicht gibt.
Die Lehre dazu heißt
[Nummer erst beim Schnüren](../Arbeitsweise/nummer-erst-beim-schnueren.md).

**Berichtigt.** Überschrift jetzt *„Quellstand 7.2.0.119, Zweig
`e-134-adressbuch-auswahl`, am 21.10.2026 übersetzt und noch nicht
geschnürt"*; die Zeile *Testverzeichnis* nennt die Messung und sagt
ausdrücklich, dass sie **beim Schnüren** auf Pfad, Uhrzeit, Größe und die an
der Datei gemessene SHA-256 gesetzt wird. Dieselbe Einschränkung steht jetzt in
`README.md:38`, `ZIEL.md:50` und `PORTIERUNG.md` ([L-47.12](#l-47.12)).

---

## Die Buchführung hinter dem Release `v1.0.117`

[LEKTOR-46](LEKTOR-46.md) hat beim Freigeben von `v1.0.117` aufgeschrieben,
welche Stellen *„heute richtig sind und mit dem Tag falsch werden"*. Das Tag
steht seit 07:56:56 UTC. **Vier dieser Stellen sind nachgezogen worden, vier
nicht** — und `tools/ZWEIGE.md:139` führt sogar einen eigenen Zweig
`release_1.0.117-nacharbeit`, der *„fünf Stellen, die weiter `v1.0.113` als
veröffentlichten Stand ausgaben"* nachgezogen haben will. Er hat vier erwischt.

### <a id="l-47.2"></a>L-47.2 — `WEITERMACHEN.md` nannte in derselben Tabelle zwei Fassungen, zum zweiten Mal an einem Tag (hoch)

Zeile 9, *Quellstand*: **7.2.0.118**, `VERSION` **1.0.118**, Zweig
`e-132-rueckfrage-fehlschlag`. Fünf Zeilen tiefer, *Paketnummer*: **1.0.119**.
Gemessen trägt `Version.h` `7.2.0.119`, `VERSION` `1.0.119`, der Zweig heißt
`e-134-adressbuch-auswahl`. Der Commit `14786286` hat die untere Zeile
geändert und die obere stehen lassen.

**Das ist Wort für Wort [L-46.1](LEKTOR-46.md#l-46.1)(a) von heute früh** — die
dort berichtigte Zeile trug damals `7.2.0.114` über einem `1.0.117`. In der
berichtigten Fassung steht seitdem der Vermerk *„(Diese Zeile stand bis zum
21.10.2026 auf 7.2.0.114 / 1.0.114, während die Zeile darunter … schon eine
drei Fassungen höhere Nummer nannte)"*. Der Vermerk hat den Wiederholungsfall
nicht verhindert: wer die *Paketnummer* hebt, hebt die *Quellstand*-Zeile nicht
mit.

**Berichtigt**, mit dem ausdrücklichen Zusatz *„noch nicht geschnürt — Gregor
wartet auf das Paket 1.0.119"* und 7.2.0.118 als Vorgängerzeile.

### <a id="l-47.3"></a>L-47.3 — der Block *HIER WEITERMACHEN* verlangte ein Release, das es seit dem Vormittag gibt (hoch)

Die vier Handgriffe, die die nächste Sitzung **zuerst** liest, lauteten:
*„1. Gregors Test an 1.0.117 abwarten … 2. Release `v1.0.117` … 4. Erst nach
dem Release den Beitrag in Issue #102 abschicken … noch nicht abgeschickt"*.
Darüber stand, gemessen am selben Tag: *„Veröffentlicht ist weiterhin
`v1.0.113`"*.

**Gemessen:** `v1.0.117` ist seit 07:56:56 UTC *Latest*, und der Beitrag an
`rjsdotorg` ist um 08:13:26 UTC abgeschickt. Wer diesen Block befolgt,
veröffentlicht ein zweites Mal und schreibt dem Melder ein zweites Mal
dieselbe Nachricht.

**Das ist das dritte Mal in Folge**, dass dieser Block um Fassungen zurückliegt
([L-44.7](LEKTOR-44.md#l-44.7), [L-45.4](LEKTOR-45.md#l-45.4),
[L-46.1](LEKTOR-46.md#l-46.1)(b)) — und er trug wieder das **heutige** Datum.
Die Schranke aus [L-44.11](LEKTOR-44.md#l-44.11), die gegen `gh release view`
statt gegen das Dokument misst, ist weiterhin **nicht gebaut**; sie hätte alle
drei Male angeschlagen.

**Berichtigt.** Der Block nennt jetzt fünf Punkte in der Reihenfolge, die
wirklich ansteht: **1.** Paket 1.0.119 schnüren und bereitstellen, dann die
vier Stellen nachziehen, die *„noch nicht geschnürt"* sagen; **2.** Gregors
Test an [C9](../TESTPLAN.md#c9) und [C8](../TESTPLAN.md#c8); **3.** kein
Release ohne sein Ja; **4.** die beiden Handgriffe nach einem künftigen
`gh release create`; **5.** Issue #102 als erledigt, mit den drei offenen
Fragen aus [L-44.8](LEKTOR-44.md#l-44.8).

### <a id="l-47.4"></a>L-47.4 — `Releases/PAKETE.md` gab an zwei Stellen `v1.0.113` als veröffentlichten Stand aus (hoch)

`:6`, im Kopfkasten: *„zuletzt veröffentlicht 1.0.113 als `v1.0.113` am
20.10.2026 um 13:01:36 UTC"* — und das in **demselben Satz**, der im selben
Commit auf *„Pakete bis 1.0.119 verzeichnet"* gehoben wurde. `:20`:
*„veröffentlicht ist inzwischen `v1.0.113` … davor am selben Tag `v1.0.112`
um 11:55 UTC, auf GitHub als Latest"* — die Auszeichnung *Latest* saß
überdies an der falschen Fassung.

**Berichtigt**, beide auf `v1.0.117` mit Marke `f546b004` und der gemessenen
Zeit; `v1.0.113` rückt an die zweite Stelle.

### <a id="l-47.5"></a>L-47.5 — die README erklärte die ausgelieferte Behebung für unveröffentlicht (mittel, geht nach außen)

`README.md:60-64`, im Abschnitt *Auf einen Blick*:

> **Veröffentlicht ist davon noch nichts** (Stand 21.10.2026: jüngstes Release
> `v1.0.113`) … Die Pakete 1.0.115 bis 1.0.117 sind geschnürt und liegen bei
> Gregor.

Genau diese Behebung — die Rückfrage vor dem fremden Mailverzeichnis — **ist**
seit demselben Tag als `v1.0.117` draußen, und sie ist der Grund des Releases.
Zwölf Zeilen höher (`:38`) stand die richtige Angabe. **Berichtigt**, samt
*„1.0.115 bis 1.0.118 … 1.0.119 übersetzt und noch nicht geschnürt"*.

### <a id="l-47.6"></a>L-47.6 — der Testplan schickte Gregor zum Testen an 1.0.117 (mittel)

`TESTPLAN.md:1` sagt seit dem Commit *„Paket 1.0.119"*. Die Buchführung
derselben Datei sagte: *„Stand 21.10.2026. Zu testen ist 1.0.117 (oben) …
Veröffentlicht ist 1.0.113 als `v1.0.113`"*. Beides falsch, und das erste
widerspricht dem Titel. **Das ist [L-46.5](LEKTOR-46.md#l-46.5) in derselben
Datei, eine Fassung später.**

**Berichtigt** auf 1.0.119 mit dem Zusatz, dass das Paket noch nicht geschnürt
ist, und auf `v1.0.117` als veröffentlichten Stand.

### <a id="l-47.7"></a>L-47.7 — *„241 Tests, 241 bestanden"* unter dem Plan zu 1.0.119 (mittel)

`TESTPLAN.md`, letzte Zeile des aktuellen Teils: *„Eigene Tests dieser Fassung:
241 Tests, 241 bestanden"*. Die Zahl gehört zu 7.2.0.114. Der Bau zu
7.2.0.119 meldet **243**, und zwar in `BEFUNDE.md`, `CHANGELOG.md`,
`Releases/PAKETE.md`, `AUFGABEN.md`, `tools/ZWEIGE.md` und der Commit-Nachricht
— in sechs Dokumenten dieselbe Zahl, im siebten eine zwei Fassungen alte.
**Berichtigt.**

### <a id="l-47.8"></a>L-47.8 — `ZIEL.md` stand fünf Fassungen zurück (mittel)

`ZIEL.md:50`: *„Quellstand ist jetzt 7.2.0.114 / Paket 1.0.114, noch nicht
geschnürt und nicht veröffentlicht (Zweig `e-132-fremdes-mailverzeichnis`);
veröffentlicht ist 7.2.0.113 / Paket 1.0.113"*. Der Commit hat in dieselbe
Datei eine neue Maßstabszeile zu [E-134](../BEFUNDE.md#e-134) eingetragen und
diesen Satz zwanzig Zeilen tiefer nicht angefasst. **Berichtigt** auf 7.2.0.119
/ 1.0.119 (übersetzt, nicht geschnürt) und `v1.0.117` als veröffentlichten
Stand.

### <a id="l-47.9"></a>L-47.9 — *„09:56:57 UTC"* ist Ortszeit, nicht UTC (mittel, geht nach außen)

Vier Stellen nennen den Zeitpunkt des Releases `v1.0.117` als **09:56:57 UTC**:
`README.md:38`, `README.md:149` (*„09:56 UTC"*), `WEITERMACHEN.md:46` und
`Releases/PAKETE.md:175`.

**Gemessen** mit `gh release view v1.0.117 --json createdAt,publishedAt`:
`publishedAt` = **`2026-10-21T07:56:56Z`**. Die Quelle des Fehlers steht in
`tools/RELEASES.md:36`: dort führt die Tabelle **Ortszeit** (`2026-10-21
09:56:57`, wie auch `15:01:37` für das `v1.0.113` von 13:01:36 UTC) — der Wert
ist von dort abgeschrieben und mit *UTC* beschriftet worden. Zwei Stunden
Unterschied, dazu eine Sekunde aus der Uhr des Werkzeugs.

**Warum das zählt:** die anderen Releases in denselben Sätzen (*„13:01:36 UTC"*,
*„11:55 UTC"*, *„19:12 UTC"*) sind **echte** UTC-Zeiten. Nebeneinander sieht es
nach einer Reihe aus; es ist keine. Wer daraus eine Abfolge rekonstruiert,
verschiebt `v1.0.117` um zwei Stunden. **Alle vier berichtigt** auf
`07:56:56 UTC`. `tools/RELEASES.md` ist **nicht** angefasst — die Spalte ist
dort durchgehend Ortszeit und in sich stimmig.

---

## Kleinigkeiten

### <a id="l-47.10"></a>L-47.10 — die Richtigstellung in `Befunde/LEKTOR-42.md` steht zweimal im selben Absatz (niedrig)

Der Commit kennzeichnet dort eine historische Fassungsnummer als Zitat — zu
Recht, der Bericht gilt für seinen Tag. Nur stand die Begründung danach
**doppelt**, in zwei aufeinanderfolgenden Zeilen: einmal als Klammer hinter der
Zielnummer, einmal als eigener Satz dahinter, mit demselben Wortlaut *„der
Stand vom 21.10.2026, zu dem dieser Bericht geschrieben wurde"*. Dazu ein
Rückstrich statt eines Gedankenstrichs. **Berichtigt** auf eine Nennung.

### <a id="l-47.11"></a>L-47.11 — *„Zwei Schritte, beide neu"* — einer ist es nicht (niedrig)

`TESTPLAN.md:4`. [C9](../TESTPLAN.md#c9) ist neu in 1.0.119,
[C8](../TESTPLAN.md#c8) steht seit 1.0.117 im Plan und ist von Gregor **nie
gefahren** worden. *„Neu"* lädt dazu ein, C8 für schon erledigt zu halten.
**Berichtigt** auf *„beide offen"*, mit einem Satz, welcher seit wann.

### <a id="l-47.12"></a>L-47.12 — *„Stand Paket 1.0.119"* in der README-Kopfzeile (niedrig)

`README.md:38` eröffnete mit *„Stand Paket 1.0.119 … gebaut, nicht
veröffentlicht"*. Gebaut ist es, ein **Paket** ist es nicht ([L-47.1](#l-47.1)).
**Berichtigt** auf *„Stand 7.2.0.119 / `VERSION` 1.0.119 — übersetzt, noch
nicht geschnürt und nicht veröffentlicht"*; in `PORTIERUNG.md` ist derselbe
Zusatz ergänzt, den die Nachbarabsätze dort führen.

---

## <a id="l-47.13"></a>L-47.13 — die vier Fragen des Auftrags, Punkt für Punkt

**Stimmen die gemessenen Zahlen in [E-134](../BEFUNDE.md#e-134), CHANGELOG und PAKETE überein?
Ja, alle.** Nachgezählt, nicht abgeschrieben:

| Angabe | `BEFUNDE.md` [E-134](../BEFUNDE.md#e-134) | `CHANGELOG.md` 7.2.0.119 | `Releases/PAKETE.md` 1.0.119 | sonst |
|---|---|---|---|---|
| **3 × `alias hans`** gegen **3 × `alias Untitled`** an **1.0.118** | ja | ja (als Tabelle) | ja | `AUFGABEN.md`, `PORTIERUNG.md` |
| **243 Tests, 243 bestanden** | ja | ja | ja | `AUFGABEN.md`, `tools/ZWEIGE.md`, `TESTPLAN.md` (nach [L-47.7](#l-47.7)), Commit `14786286` |
| *„nach SelectItem allein: NICHT ausgewaehlt"* / *„nach DoSelectItem: ausgewaehlt"* | wörtlich | wörtlich | wörtlich | — |
| `Auswahl im Baum` **(0) → (1)** | ja | ja | ja | — |
| Prüfgröße `Mailverzeichnis\NNdbase.txt` | ja | ja | ja | `TESTPLAN.md` C9 |
| Zwischenstand brachte **einen** Buchstaben (`alias h`) | ja | ja | — | Commit |

**Behauptet irgendwo etwas als gemessen, was nicht gemessen ist? Nein.** Die
beiden Lücken stehen da, wo sie hingehören:

* **Warum `SelectItem()` `TVIS_SELECTED` nicht mehr setzt** — *„nicht gemessen"*
  steht in `BEFUNDE.md` ([E-134](../BEFUNDE.md#e-134), eigener Fettsatz *„Nicht gemessen und weiterhin
  offen"*), in `CHANGELOG.md` (*„ist nicht gemessen; naheliegend ist die
  Fassung der Common Controls oder der MFC"*) und in `Releases/PAKETE.md`
  (Zeile *Offen*). Dreimal, mit derselben Vermutung, und dreimal mit dem
  Zusatz, dass die Behebung nicht daran hängt. Das trifft
  [Ursache nur gemessen behaupten](../Arbeitsweise/ursache-nur-gemessen-behaupten.md).
* **Der Weg über *Einfügen* statt Tippen** — steht als *„Was ich NICHT gemessen
  habe"* in `TESTPLAN.md` C9, mit dem ehrlichen Zusatz *„Der Weg geht durch
  dieselbe Stelle, aber gemessen ist er nicht"*. Das ist der richtige Ort: es
  ist eine Bitte an Gregor, kein Befundinhalt.
* Dazu, ungefragt richtig: **die Testsuite deckt diesen Weg nicht ab** — in
  allen drei Dokumenten, neben den 243 bestandenen Tests. Ohne diesen Satz wäre
  *„243 bestanden"* ein Beleg, der keiner ist
  ([Extrakt ist nicht das Programm](../Arbeitsweise/extrakt-ist-nicht-das-programm.md)).

**Ist die frühere Fehleinstufung sauber zurückgenommen? Ja, und zwar
ausdrücklich.** `BEFUNDE.md` [E-134](../BEFUNDE.md#e-134) schreibt: *„Die Einordnung
‚Originalverhalten', die hier zuerst stand, war falsch; belegt war nur,
dass die `//FORNOW`-Kommentare original sind — eine Aussage über den Kommentar,
nicht über das Verhalten."* Der Unterschied Quelltext/Verhalten steht gleich
viermal: `BEFUNDE.md` (*„Also: Quelltext original, Verhalten verändert"*, mit
`git log`/`git diff` leer und dem Gegenbeleg `nickdoc.cpp:1759`),
`CHANGELOG.md` (eigene Zwischenüberschrift *„Der Quelltext ist original. Das
Verhalten nicht."*), `PORTIERUNG.md` und `Releases/PAKETE.md`. **Rest der alten
Fassung gesucht und nicht gefunden:** `grep -rn 'Originalverhalten'` über alle
MDs trifft im Umfeld Adressbuch/Nickname/Kurzname **nur** den Satz, der sie
zurücknimmt. Der andere Treffer gehört zu [E-133](../BEFUNDE.md#e-133), wo
*„Originalverhalten"* richtig ist — dort ist der **Startweg** unverändert.

**Ist C9 für Gregor ohne Rückfrage ausführbar? Ja.** Gegen den Quelltext
gehalten, nicht gegen ein Dokument:

| Angabe in C9 | Beleg |
|---|---|
| *Tools → Address Book* | `EudoraRes.rc:5806`, im `POPUP "&Tools"`: `MENUITEM "&Address Book"` mit `Ctrl+L`, `ID_WINDOW_NICKNAMES` |
| Knopf **New** | `EudoraRes.rc:2586`, `PUSHBUTTON "&New",IDC_NICKNAME_LEFT_NEW` |
| Feld *Nickname* | `EudoraRes.rc:1702`, `LTEXT "&Nickname:",IDC_LBL_NICKNAME_CALLIT` |
| Datei `NNdbase.txt` | `nickview.cpp:1266`, *„Eudora Nicknames address book is called NNdbase.txt"* |
| Erwartung *Baum zeigt `hans`*, auf der Platte `alias hans` | deckt sich mit der Messung in [E-134](../BEFUNDE.md#e-134) |

Vier nummerierte Handgriffe, eine Minute, kein Netz nötig, und mit der
Gegenprobe in `NNdbase.txt` eine Prüfgröße, die er selbst nachsehen kann. Dazu
bittet C9 um zwei Fälle, die **nicht** gemessen sind (vorhandenen Eintrag
umbenennen, schon vergebener Name) — das ist die Gegenprobe, die eine
Regression fangen würde. **Nicht beanstandet, aber angemerkt:** die Tastenfolge
`Ctrl+L` wäre eine Zeile wert.

**`tools/ZWEIGE.md` — vollständig und in der Form der Nachbarn? Ja.** Die Zeile
führt Name, Datum, Gregors wörtliche Zustimmung (*„e-134-adressbuch-auswahl ist
ok, behebe beides"*), den Zweck mit Verweis auf [E-134](../BEFUNDE.md#e-134),
die Ursache in zwei Sätzen, beide behobenen Stellen und den Quellstand — genau
der Satzbau der Nachbarzeilen `e-132-rueckfrage-fehlschlag` und
`e-132-startwege-und-merker`. Der Verweis zeigt mit `../BEFUNDE.md#e-134`
richtig aus `tools/` heraus. **Nicht beanstandet:** die Zeile nennt keine
Paketnummer — und das ist nach [L-47.1](#l-47.1) richtig so, es gibt keine.

**Zeilenenden.** Alle berührten Dateien nach jedem Schreibzugriff gemessen:
`README.md`, `TESTPLAN.md`, `ZIEL.md`, `WEITERMACHEN.md`, `PORTIERUNG.md`,
`Releases/PAKETE.md`, `Befunde/LEKTOR-42.md`, `BEFUNDE.md`, `CHANGELOG.md`,
`AUFGABEN.md`, `tools/ZWEIGE.md` — **CRLF 0** in allen elf, reine LF, erstes
Byte kein BOM.

---

## Tragen die Papiere zu 1.0.119?

**JA — nach diesen zwölf Berichtigungen.** Der Befund selbst ist die beste
Arbeit in diesem Durchgang: [E-134](../BEFUNDE.md#e-134) nennt Symptom,
Ursache, Messung, Gegenprobe, die zurückgenommene Fehleinstufung und die
verbleibende Lücke, und `CHANGELOG`, `PAKETE`, `PORTIERUNG`, `ZIEL`,
`AUFGABEN`, `ZWEIGE` und `TESTPLAN` sagen dasselbe in denselben Zahlen. **Keine
einzige Zahl zu [E-134](../BEFUNDE.md#e-134) war falsch.**

**Alle zwölf Funde sitzen in der Buchführung ringsum** — in den Sätzen, die
sagen, welche Fassung draußen ist und welche bei Gregor liegt. Zehn davon
standen schon **vor** diesem Commit falsch oder wurden von ihm nur halb
mitgezogen.

**Zwei Dinge, die vor dem Ausliefern von Hand zu tun sind:**

1. **Paket 1.0.119 schnüren und bereitstellen.** Danach vier Stellen nachziehen,
   die jetzt ausdrücklich *„noch nicht geschnürt"* sagen:
   `Releases/PAKETE.md` (Abschnitt 1.0.119, Zeile *Testverzeichnis*, mit der an
   der Datei gemessenen SHA-256), `README.md:38`, `ZIEL.md:50` und
   `PORTIERUNG.md`. Das steht als Punkt 1 im Block *HIER WEITERMACHEN*.
2. **Gregors Urteil abwarten** ([Release erst nach Gregors
   Test](../Arbeitsweise/release-erst-nach-gregors-test.md)). Offen sind bei ihm
   [C9](../TESTPLAN.md#c9) **und** [C8](../TESTPLAN.md#c8); C8 liegt seit
   1.0.117 ungefahren da, und 1.0.117 ist trotzdem veröffentlicht worden.

**Die Schranke, die dreimal gefehlt hat.** [L-44.11](LEKTOR-44.md#l-44.11)
verlangt eine Prüfung, die *„veröffentlicht ist …"* und *„geschnürt ist …"* in
den MDs gegen `gh release view`, `ls Releases/*.zip` und
`ls C:\Users\Gregor\Eudora72-*` hält statt gegen andere Dokumente. Sie ist seit
vier Tagen nicht gebaut. Sie hätte **[L-47.1](#l-47.1) bis
[L-47.6](#l-47.6)** gefangen — sechs von zwölf Funden, darunter alle vier
schweren. Solange sie fehlt, findet diese Klasse nur, wer von Hand nachsieht.

---

## Geänderte Dateien

`README.md`, `TESTPLAN.md`, `ZIEL.md`, `WEITERMACHEN.md`, `PORTIERUNG.md`,
`Releases/PAKETE.md`, `Befunde/LEKTOR-42.md`, `LEKTORAT.md` und dieser Bericht.

**Keine Datei unter `Eudora71/` angefasst, kein Werkzeug unter `tools/`
geändert**, `tools/RELEASES.md` ausdrücklich **nicht** ([L-47.9](#l-47.9): die
Spalte dort ist Ortszeit und in sich stimmig), `Releases/ISSUE-102-ANTWORT.md`
unverändert (abgeschickt), `BEFUNDE.md` und `CHANGELOG.md` unverändert — an
[E-134](../BEFUNDE.md#e-134) war nichts zu berichtigen.

Nach jedem Schreibzugriff gemessen: **CRLF 0**, reine LF, UTF-8 ohne BOM.
`perl tools/commit-bereit.pl`: **33 Schranken, keine weist ab.**
`perl tools/doku-pruefen.pl`: kein Widerspruch.
