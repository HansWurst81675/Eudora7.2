# <a id="lektor-143"></a>LEKTOR-143 (04.11.2026) — Einarbeitung von LEKTOR-142, Zweig `release_7_2_2_132` nach 57d0be9b

**Umfang:** `git log --stat 05ee2b79..HEAD` (fünf Commits: `ddd7b374` Werkzeuge kennen 7.2.2.N; `ad6f24a9` Urteile je Befund fortgeschrieben, Tabellen 61 → 54; `ebfdd0f8` FAQ und FUNKTIONEN; `b6e314ae` Nummernschema, Entscheidung 25; `57d0be9b` LEKTORAT). Je fortgeschriebenem Befund das Urteil gegen [TESTPLAN](../Intern/TESTPLAN.md#test-7-2-2-132) (Schritte, Belegtabelle, Kasten *Am Prüfstand erledigt*), `Releases/PAKETE.md:187-200` und die erzeugten Tabellen gelesen; CHANGELOG 7.2.2.132 gegen *Noch offen*; Entscheidung 25 gegen `ZIEL.md:110-123`; FAQ/FUNKTIONEN gegen den Release-Stand. Keine Wiederholung von [LEKTOR-142](LEKTOR-142.md#lektor-142).

**Urteil:** Die Einarbeitung trägt. Alle sieben *behoben*-Urteile halten: die drei *„von Gregor bestätigt“* ([A-5](../Intern/BEFUNDE.md#a-5) Hilfe-Menü, [E-216](../Intern/BEFUNDE.md#e-216) About-Dialog, [E-207](../Intern/BEFUNDE.md#e-207) leere Signaturdatei) stehen jeweils auf einem Schritt, den Gregor selbst bestanden hat; die vier *„am Prüfstand bestätigt“* ([E-196](../Intern/BEFUNDE.md#e-196) Zeichensatz in `.htm`, [E-205](../Intern/BEFUNDE.md#e-205) falsches Datum, [E-204](../Intern/BEFUNDE.md#e-204) geerbtes Kennwort, [E-203](../Intern/BEFUNDE.md#e-203) Persönlichkeit bleibt aktuell) auf einem Fall im Kasten. Liegen geblieben sind Ränder: drei offene Befunde haben als Rest etwas, das sich nach eigener Aussage nicht herbeiführen lässt ([L-143.1](#l-143.1)); der CHANGELOG berichtigt den Widerspruch nur in der Zeile *Berichtigt*, nicht in *Neu*, und die README nennt einen Befund mit Rest „behoben“ ([L-143.2](#l-143.2)); das neue Nummernschema lässt offen, wie ein reines Fehlerbehebungs-Paket nach 7.2.2.132 heißt ([L-143.4](#l-143.4), Frage an Gregor). Sechs Funde, keiner hält den Merge auf.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*, 19 Hinweise *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“* — derselbe Altbestand wie in [LEKTOR-142](LEKTOR-142.md#lektor-142).
* `perl tools/offene-befunde.pl` (gemessen): *„54 offene Befunde, in beiden Listen gleich.“*; *„davon aktuell gemessen 19“*, *„davon nur am Quelltext 2“*, *„veraltet gemessen 24“*, *„NIE gemessen 11“*.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„mit Testfall im Pruefstand 66 von 72“*, *„OHNE jede Pruefung 4 <- Rueckstand [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129)“*, *„Kein neues "behoben" ohne Regressionstest.“*
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* — prüft nicht, ob ZIEL im Abschnitt 7.2.2 noch *„im Testpaket“* sagt ([L-143.5](#l-143.5)).
* `grep -rnE '7\.2\.\[01\]' tools/` außerhalb von Kommentaren (gemessen): 0 Treffer; `7\\.2\\.\[012\]` 19 Stellen.

## Funde aus LEKTOR-142 und älter — heutiger Stand

| Fund | Stand | Stelle |
|---|---|---|
| [L-142.1](LEKTOR-142.md#l-142.1) 15 offene Befunde warten auf „das Paket 7.2.2.132“ | **erledigt**; Ränder in [L-143.1](#l-143.1), [L-143.2](#l-143.2) | `grep -c "Testpaket 7.2.2.132" Intern/BEFUNDE.md` → 0 (gemessen); offene 61 → 54; `CHANGELOG.md:122` *„Sechs davon haben nach der Auslieferung einen Rest und stehen deshalb oben unter *Noch offen*“* |
| [L-142.2](LEKTOR-142.md#l-142.2) FAQ „noch in keinem Paket“, FUNKTIONEN ohne *bestätigt* | **erledigt** | `Doku/FAQ.md:223` *„**Behoben in 7.2.2.132:**“*; `Doku/FUNKTIONEN.md:85`, `:87`, `:176`, `:265`, `:266`, `:269` *„**bestätigt** ([TESTPLAN] …, Schritt …)“*; `:1097` nur noch *Send Queued Messages* — die Begründung im Commit `ebfdd0f8` (Schritt 4 belegt den Weg nicht) hält |
| [L-142.3](LEKTOR-142.md#l-142.3) Werkzeuge kennen 7.2.2.N nicht | **erledigt bis auf den Selbsttest**; siehe [L-143.6](#l-143.6) | `tools/WERKZEUGE.md:194` *„`--tests` fährt **23 Fälle**“*; Muster siehe oben |
| [L-142.4](LEKTOR-142.md#l-142.4) Nummernschema kennt nur 7.2.1.N | **erledigt**; die Lesart wirft eine Frage auf ([L-143.4](#l-143.4)) | `CHANGELOG.md:3-5`, `Releases/PAKETE.md:51-57`, `:96-100`, `Doku/MITARBEITEN.md:66`, `ZIEL.md:41-43`, `Intern/WEITERMACHEN.md:163` (Verweis), `:168` (Entscheidung 25) |
| [L-142.5](LEKTOR-142.md#l-142.5) [E-188](../Intern/BEFUNDE.md#e-188) (Mail geht beim Verschieben verloren): BEFUNDE „nie gemessen“ | **offen**, löst sich mit dem E-188-Zweig | `Intern/WEITERMACHEN.md:92`, `CHANGELOG.md:44` *„**nie gemessen**“* |
| [L-142.6](LEKTOR-142.md#l-142.6) `main` sagt „Testpaket … nicht veröffentlicht“ | **offen** — kein PR | `git show origin/main:README.md` Zeile 104 *„Testpaket … nicht veröffentlicht“*; `gh pr list --head release_7_2_2_132 --state all` → `[]`; `origin/release_7_2_2_132` = `57d0be9b` (gemessen) |
| [L-142.7](LEKTOR-142.md#l-142.7) Release-Notizen ohne Satz zum Rückstand an Regressionstests | **offen**, Gregors Frage aus [LEKTOR-142](LEKTOR-142.md#lektor-142) steht | `Releases/7.2.2.132/RELEASE-NOTIZEN.md` unverändert seit `05ee2b79` |
| [L-142.8](LEKTOR-142.md#l-142.8) Kleinkram | **teilweise**: `ZIEL.md:41` erledigt; `ZIEL.md:124` weiter *„im Testpaket 7.2.2.132“* | siehe [L-143.5](#l-143.5) |
| [L-141.3](LEKTOR-141.md#l-141.3) Backtick-Kennungen [`E-220`](../Intern/BEFUNDE.md#e-220)/`E-221` | **offen, Merkposten** | `grep -c 'id="e-22[01]"' Intern/BEFUNDE.md` → 0 (gemessen) |
| [L-140.2](LEKTOR-140.md#l-140.2) „81 von 81“ aus zwei Läufen | **teilweise** — TESTPLAN nennt jetzt den Grund | `Intern/TESTPLAN.md:58-60` *„**81 Fälle, 81 bestanden** — vier E-170-Fälle erst nach einer Berichtigung im Messskript“*; `Releases/PRUEFBERICHT.md:6` *„**Arbeitsbaum nicht sauber** (2 Dateien)“* |
| [L-138.9](LEKTOR-138.md#l-138.9) Zahl der Berichte in der README | **offen** | `README.md:98` *„219 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026“*; `ls Befunde/LEKTOR-*.md Befunde/PRUEFER-*.md \| wc -l` → 233, mit diesem 234 (gemessen) |
| [L-138.11](LEKTOR-138.md#l-138.11) [E-216](../Intern/BEFUNDE.md#e-216) Umbruch nicht gemessen | **erledigt** | `Intern/BEFUNDE.md:400` *„Gregor sah am 03.11.2026 an seinem System beide Zeilen ganz“* |
| [L-138.12](LEKTOR-138.md#l-138.12), [L-139.1](LEKTOR-139.md#l-139.1) | **offen**, unverändert | `tools/WERKZEUGE.md:171`; `Intern/TESTPLAN.md:423` *„Erledigt am 03.11.2026: das Label bleibt“* bei offenem [E-170](../Intern/BEFUNDE.md#e-170) (Label beim Verschieben im IMAP-Konto) |

## Je Befund: das Urteil gegen TESTPLAN und PAKETE (belegt)

| Befund | Urteil heute | Trägt? |
|---|---|---|
| [A-5](../Intern/BEFUNDE.md#a-5) Hilfe-Menü | behoben, von Gregor bestätigt | ja — Schritte 6, 7 bestanden (`TESTPLAN.md:22-23`, Beleg `:47` *„beide Hilfeseiten im Browser“*); `A-5p`, `A-5p-log` im Kasten |
| [E-216](../Intern/BEFUNDE.md#e-216) About-Dialog | behoben, von Gregor bestätigt | ja — Schritt 8 verlangt *„die Zeilen *Log* und *Mail folder from* ganz zu lesen“* (`:24`), Schritt 9 *Latest Release*; bestanden |
| [E-207](../Intern/BEFUNDE.md#e-207) Signatur als leere Datei | behoben, von Gregor bestätigt | ja — Schritt 11 (*„nichts ändern“*) trifft die Ursache, denn `Serialize` tat unabhängig von einer Änderung nichts (`BEFUNDE.md:408`, *„landet deshalb bei `CObject::Serialize`, und die tut nichts“*); die zweite Hälfte (Änderung geht ohne Rückfrage verloren) sieht nur `E-207p` — kein Fund |
| [E-196](../Intern/BEFUNDE.md#e-196), [E-205](../Intern/BEFUNDE.md#e-205), [E-204](../Intern/BEFUNDE.md#e-204), [E-203](../Intern/BEFUNDE.md#e-203) | behoben, am Prüfstand bestätigt | ja — `E-194p/k`, `E-205p`, `E-204p/w`, `E-203p/v/w` im Kasten (`TESTPLAN.md:69-74`), Lauf am Bau `7.2.2.132+561f3ebf` (`PAKETE.md:197`). [E-196](../Intern/BEFUNDE.md#e-196) sagt selbst *„nicht von Gregor selbst geprüft“* — sauber getrennt |
| [E-128](../Intern/BEFUNDE.md#e-128) Endung beim Speichern | offen, Rest IMAP-Schutz (K2: die Endung wird bei einer IMAP-Mail ohne geladenen Text nicht falsch geraten) | ja; die Wendung *„die Endung aus dem Inhalt hat Gregor bestätigt“* ist breiter als Schritt 10 ([L-143.5](#l-143.5)) |
| [E-194](../Intern/BEFUNDE.md#e-194), [E-195](../Intern/BEFUNDE.md#e-195) Speichern unter | offen mit Rest | ja; aber README nennt [E-194](../Intern/BEFUNDE.md#e-194) „behoben“ ([L-143.2](#l-143.2)), die Tabelle nennt K3/K4 ohne Klartext ([L-143.3](#l-143.3)) |
| [E-133](../Intern/BEFUNDE.md#e-133) fehlendes Mailverzeichnis | offen, Rest K6 (Wege *Yes*, *Cancel*, Start mit Anhang ungemessen) | ja — Kasten nennt nur `E-133p`, `E-133q` |
| [E-39](../Intern/BEFUNDE.md#e-39), [E-209](../Intern/BEFUNDE.md#e-209), [E-211](../Intern/BEFUNDE.md#e-211) | offen mit Rest | Rest nicht herbeizuführen ([L-143.1](#l-143.1)) |
| [E-210](../Intern/BEFUNDE.md#e-210) Kennwort-Puffer 128 Byte | offen, Rest Messung am Programm | ja — der Schritt ist machbar (Konto ab 128 Zeichen) |
| [E-170](../Intern/BEFUNDE.md#e-170) Label beim Verschieben | offen mit zwei Resten | ja; CHANGELOG nennt nur einen ([L-143.2](#l-143.2)) |

## Funde

### <a id="l-143.1"></a>L-143.1 — Drei Befunde bleiben offen auf einen Rest, der sich nach eigener Aussage nicht herbeiführen lässt

**Gewicht: mittel — die Liste der offenen Befunde kann an diesen drei Stellen nie kürzer werden, und `CHANGELOG.md:122` gibt für [E-39](../Intern/BEFUNDE.md#e-39) einen falschen Grund an.**

- [E-39](../Intern/BEFUNDE.md#e-39) (leerer Rest einer gelöschten Persönlichkeit in der `Eudora.ini`): `Intern/BEFUNDE.md:466` *„**Was noch fehlt:** am Programm sieht den Weg seit der Behebung von [[E-203](../Intern/BEFUNDE.md#e-203)] kein Prüfstandsfall mehr — gesichert ist die Behebung durch `TestE39.cpp`; … für Gregor nichts zu prüfen“* — das ist eine Feststellung, kein Schritt. Die erzeugte Zeile `Intern/WEITERMACHEN.md:121` übernimmt das als *was noch fehlt* (gemessen).
- [E-211](../Intern/BEFUNDE.md#e-211) (neue Nachricht scheitert, Persönlichkeit bleibt umgeschaltet): `:404` *„ein Lauf am Programm fehlt, der Fehlerfall lässt sich nicht herbeiführen“*; `WEITERMACHEN.md:80` ebenso.
- [E-209](../Intern/BEFUNDE.md#e-209) (Mailverzeichnis auf Laufwerk ohne 8.3-Namen): `:406` *„am Programm nicht nachstellbar“*, die Tabelle `WEITERMACHEN.md:82` verlangt dennoch *„die Messung an einem Laufwerk ohne 8.3-Namen“*. Ob ein virtuelles Laufwerk mit abgeschalteten Kurznamen genügt, ist nicht geprüft (Vermutung).
- Der Commit `ad6f24a9` begründet das Offenbleiben bei [E-210](../Intern/BEFUNDE.md#e-210)/[E-211](../Intern/BEFUNDE.md#e-211) mit dem Werkzeug: *„pruefe-behoben-belegt verlangt einen Lauf“* — das Werkzeug bestimmt hier das Urteil, nicht der Befund.
- **Falscher Grund im CHANGELOG** (belegt): `CHANGELOG.md:122` *„[[E-39](../Intern/BEFUNDE.md#e-39)], [[E-210](../Intern/BEFUNDE.md#e-210)] und [[E-211](../Intern/BEFUNDE.md#e-211)] (am Programm nicht gemessen)“*. [E-39](../Intern/BEFUNDE.md#e-39) *ist* am Programm gemessen: `BEFUNDE.md:466` *„Am laufenden Programm gemessen: vorher `abschnitt-wieder=1`, nachher `abschnitt-wieder=0 war-aktuell=1`“*; was fehlt, ist ein Prüfstandsfall für die Zukunft.

**Vorschlag:** je Befund entweder einen machbaren Schritt als Rest nennen ([E-209](../Intern/BEFUNDE.md#e-209): Laufwerk ohne Kurznamen) oder eine Urteilsform für „behoben, nur am Quelltext und im Test belegt, am Programm nicht herbeizuführen“ festlegen und `pruefe-behoben-belegt.pl` dazu bringen, sie zu kennen. `CHANGELOG.md:122` für [E-39](../Intern/BEFUNDE.md#e-39) *„sieht kein Prüfstandsfall mehr“*. Einstufung und Form sind Sache des Hauptagenten.

### <a id="l-143.2"></a>L-143.2 — CHANGELOG *Neu* und README *Bekannte Fehler*: ausgeliefert und offen, ohne es zu sagen

**Gewicht: Kleinkram mit Außenwirkung — beides liest, wer von der Release-Seite kommt.**

- `CHANGELOG.md:121` *„**Neu:** [[A-5](../Intern/BEFUNDE.md#a-5)] … [[E-216](../Intern/BEFUNDE.md#e-216)] … [[E-128](../Intern/BEFUNDE.md#e-128)] — *Speichern unter* schlägt die Endung vor …; [[E-133](../Intern/BEFUNDE.md#e-133)] — fehlt das gespeicherte Mailverzeichnis, fragt Eudora … (dazu [[E-209](../Intern/BEFUNDE.md#e-209)] …)“*. [E-128](../Intern/BEFUNDE.md#e-128), [E-133](../Intern/BEFUNDE.md#e-133) und [E-209](../Intern/BEFUNDE.md#e-209) stehen alle drei unter *Noch offen* (`CHANGELOG.md:34`, `:59`, `:61` in der erzeugten Tabelle, gemessen). Der erklärende Satz *„… haben nach der Auslieferung einen Rest“* steht nur in der Zeile *Berichtigt* (`:122`) — derselbe Widerspruch wie in [L-142.1](LEKTOR-142.md#l-142.1), eine Zeile höher.
- `README.md:203` (*Bekannte Fehler*, Speichern unter): *„**Alle drei behoben in 7.2.2.132 — das `.rtf` nur für Nachrichten …**“*. [E-194](../Intern/BEFUNDE.md#e-194) (`<x-flowed>`-Zeilen in der Textdatei) ist offen: `BEFUNDE.md:417` *„**Rest, nicht behoben (gering):** K3 — bei mehreren Textteilen, einer Anhangszeile vor dem Text oder einem flowed- gefolgt von einem HTML-Teil bleiben Klammern in der Mitte stehen“*. Für eine Mail mit Anhang stimmt „behoben“ also nicht (belegt).
- [E-170](../Intern/BEFUNDE.md#e-170) (Label beim Verschieben): `CHANGELOG.md:122` nennt als Rest *„Bestätigung an einem echten Server ohne UIDPLUS“*; `BEFUNDE.md:430` nennt zuerst *„messen, warum das Label am 29.10.2026 an Paket 1.0.127 fehlte“* und dann erst den Server ohne UIDPLUS; `Doku/FAQ.md:223-227` nennt nur den ersten. Jede Stelle für sich richtig, zusammen unvollständig.

**Vorschlag:** in `:121` hinter [E-128](../Intern/BEFUNDE.md#e-128), [E-133](../Intern/BEFUNDE.md#e-133) und [E-209](../Intern/BEFUNDE.md#e-209) je den Rest in Klammern (wie in `:122`), oder ein Satz für beide Zeilen; `README.md:203` *„… behoben in 7.2.2.132; bei Mails mit mehreren Textteilen oder Anhang können die Klammern in der Mitte stehen bleiben ([[E-194](../Intern/BEFUNDE.md#e-194)])“*; `CHANGELOG.md:122` bei [E-170](../Intern/BEFUNDE.md#e-170) beide Reste.

### <a id="l-143.3"></a>L-143.3 — Die erzeugte Tabelle nennt bei [E-194](../Intern/BEFUNDE.md#e-194) „K3, K4“ ohne Klartext

**Gewicht: Kleinkram, aber öffentlich (CHANGELOG).**

- `CHANGELOG.md:40` und `Intern/WEITERMACHEN.md:88` *„K3, K4 und eine Prüfnachricht mit Anhang (K9) als Rest“* (gemessen); ebenso `BEFUNDE.md:417` im Urteil *„offen sind nur noch die Reste K3, K4 und eine Prüfnachricht mit Anhang (K9)“*. Was K3 und K4 sind, steht erst tief im Befundtext (`:417` *„K3 — bei mehreren Textteilen …; K4 — `</x-html>` allein auf seiner Zeile vor einer Anhangszeile bleibt stehen“*). Die anderen Zeilen machen es richtig, z. B. [E-128](../Intern/BEFUNDE.md#e-128) *„der IMAP-Schutz (K2)“*, [E-133](../Intern/BEFUNDE.md#e-133) *„die Messung der Wege *Yes*, *Cancel* … (K6)“*.

**Vorschlag:** im Urteil von [E-194](../Intern/BEFUNDE.md#e-194) *„Klammern bleiben bei mehreren Textteilen oder vor einer Anhangszeile stehen (K3, K4)“*; die Tabelle folgt beim nächsten `offene-befunde.pl -schreiben`.

### <a id="l-143.4"></a>L-143.4 — Entscheidung 25 liest ZIEL als zwei Reihen nebeneinander; wie das nächste reine Fehlerbehebungs-Paket heißt, steht nirgends

**Gewicht: mittel — das nächste Paket ist die E-188-Behebung (Mail geht beim Verschieben verloren), also eine reine Fehlerbehebung, und braucht eine Nummer.**

- `ZIEL.md:115-123` sagt: *„**7.2.1.x bleibt die Reihe für Fehlerbehebungen.** Neue Funktionen gehören nicht dazu“*, *„**7.2.2 ist die erste Fassung mit neuen Funktionen.**“*, *„das erste Paket 7.2.2 heißt **7.2.2.132** — die letzte Stelle zählt weiter“*. Ob nach 7.2.2.132 wieder 7.2.1.N kommt, sagt ZIEL nicht.
- `Intern/WEITERMACHEN.md:168` (Entscheidung 25), `CHANGELOG.md:3-5`, `Releases/PAKETE.md:51-54`, `Doku/MITARBEITEN.md:66` sagen einheitlich *„7.2.1.N für Fehlerbehebungen, 7.2.2.N mit neuen Funktionen“* — gelesen als Regel je Paket, hieße das E-188-Paket `7.2.1.133`. Zitate, Marke `v7.2.2.<n>` und der TESTPLAN-Schritt je neuer Funktion stimmen mit ZIEL überein (belegt); die Regel je Paket ist eine Auslegung, kein Zitat von Gregor.
- Die Folge (Vermutung, nicht gemessen): `7.2.1.133` ist als Fassung kleiner als `7.2.2.132`; was nach der höchsten Fassung sortiert — *Latest* auf GitHub nach Datum nicht, aber `doku-pruefen.pl` *„hoechste genannte Fassung“* und jede Dateiversions-Prüfung bei einem Update über ein installiertes 7.2.2.132 — sähe das neuere Paket als älteres. `grep -rn '7\.2\.[12]\.133'` über alle MDs außer `Befunde/` → 0 (gemessen): die Nummer ist noch nicht vergeben.

**Vorschlag:** die Frage an Gregor (unten); bis dahin in Entscheidung 25 nur das Zitierte.

### <a id="l-143.5"></a>L-143.5 — Kleinkram

- `ZIEL.md:124-125` *„**Umgesetzt, am Prüfstand gemessen, auf `main` seit #206** (im Testpaket 7.2.2.132, [[A-5](../Intern/BEFUNDE.md#a-5)])“* — [A-5](../Intern/BEFUNDE.md#a-5) ist ausgeliefert und von Gregor bestätigt (`BEFUNDE.md:243`). Rest aus [L-142.8](LEKTOR-142.md#l-142.8).
- `ZIEL.md:134-135` [E-128](../Intern/BEFUNDE.md#e-128) unter *Kandidaten* *„wartet auf Gregors Entscheidung“* — vier Zeilen tiefer (`:139`) *„damit ist der Kandidat oben umgesetzt“*; Gregor hat am 03.11.2026 entschieden (`BEFUNDE.md:391`).
- `BEFUNDE.md:391` [E-128](../Intern/BEFUNDE.md#e-128) *„die Endung aus dem Inhalt hat Gregor … bestätigt“* — Schritt 10 zeigt eine HTML-Mail aus Liste (`.eml`) und Fenster (`.htm`); `.txt` und die Umlaut-`.eml` sah nur der Prüfstand. `Doku/FUNKTIONEN.md:85` sagt es genau (*„aus der Postfachliste (`.eml`) und dem Nachrichtenfenster (`.htm`)“*).
- [E-209](../Intern/BEFUNDE.md#e-209) hat keine Marke *„Zuletzt belegt am Quelltext“* und steht deshalb als *„**nie gemessen**“* (`WEITERMACHEN.md:82`), während [E-210](../Intern/BEFUNDE.md#e-210)/[E-211](../Intern/BEFUNDE.md#e-211) mit derselben Lage *„02.11.2026 an 7.2.1.131 (Quelltext)“* zeigen (gemessen).
- [E-216](../Intern/BEFUNDE.md#e-216), [E-207](../Intern/BEFUNDE.md#e-207): *„Zuletzt gemessen: … an 7.2.1.131“* neben *„von Gregor … an 7.2.2.132 bestätigt“* — für geschlossene Befunde ohne Wirkung auf die Tabellen.

### <a id="l-143.6"></a>L-143.6 — Werkzeuge: kein Selbsttest mit 7.2.2, und `offene-befunde.pl` kollidiert mit dem E-188-Zweig

**Gewicht: Kleinkram, Merkposten für den Merge.**

- Von den sieben in `ddd7b374` berichtigten Werkzeugen nennt nur `pruefe-behoben-ausgeliefert.pl` die Reihe 7.2.2 überhaupt (`:131-132`, Kommentar); einen Fall mit einer 7.2.2-Nummer, der am alten Muster rot wäre, hat keines (`grep -cE '7\.2\.2\.[0-9]'` je Datei, gemessen). Der Vorschlag aus [L-142.3](LEKTOR-142.md#l-142.3) (gemeinsames Muster `7\.2\.\d`, Selbsttest) ist nicht umgesetzt — die nächste Reihe löst dieselbe Runde aus.
- `tools/offene-befunde.pl:210`, `:228` sind hier `7\.2\.[012]` (`ddd7b374`), auf `origin/e188_loeschschranke` dieselben zwei Zeilen als `7.2.[012]` mit ungeschützten Punkten und anderem Kommentar (`git diff HEAD origin/e188_loeschschranke -- tools/offene-befunde.pl`, gemessen). Beim Merge in eine Richtung entsteht ein Konflikt; die Fassung hier ist die genauere.

**Vorschlag:** beim Merge die Fassung dieses Zweigs nehmen.

## Was nur Gregor entscheiden kann

1. **Wie heißt das nächste Paket, wenn es nur Fehler behebt — `7.2.1.133` oder `7.2.2.133`?** ([L-143.4](#l-143.4): du hast am 02.11.2026 gesagt, neue Funktionen kommen in 7.2.2.x, und das erste Paket heißt 7.2.2.132. Ob danach eine reine Fehlerbehebung wie die für [E-188](../Intern/BEFUNDE.md#e-188) — Mail geht beim Verschieben verloren — wieder `7.2.1.N` heißt, hast du nicht gesagt. `7.2.1.133` wäre als Fassungsnummer kleiner als das schon veröffentlichte `7.2.2.132`.) Ja zu `7.2.2.133` heißt: nach 7.2.2.132 bleibt jede Fassung 7.2.2.N; ja zu `7.2.1.133` heißt: zwei Reihen nebeneinander.
2. Die Frage aus [LEKTOR-142](LEKTOR-142.md#l-142.7) (Release-Text von v7.2.2.132 um den Rückstand an Regressionstests ergänzen) ist noch offen.
