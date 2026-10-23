# <a id="lektor-53"></a>LEKTOR-53 — Bestandsprüfung nach PR #155 (E-125 an 1.0.122 geprüft), 23.10.2026

**Auftrag.** Nach dem Merge von PR #155 (`dd1d1f82..ed2b74c0`): Gregors Test
von [E-125](../Intern/BEFUNDE.md#e-125) (eine empfangene Nachricht nach `Out`
ziehen) an Paket 1.0.122 ist eingetragen, dazu die Gegenprobe am Prüfstand und
der neue [Testbericht](../Intern/TESTBERICHT-E125.md). Geprüft wurde **der
Bestand**, nicht der Diff: alle 178 `.md` aus `git ls-files` ohne
`Arbeitsweise/`. Zweiter Schwerpunkt: der Weg zum Release 7.2.1.0, gemessen an
[ZIEL.md](../ZIEL.md). Maßstab von außen: `Eudora71/Version.h` (7.2.0.122),
`VERSION` (1.0.122), `git tag` (zuletzt `v1.0.120`), die Dateien auf der Platte
und `tools/TESTLAEUFE.md`.

**Ergebnis vorweg.** Der Test von [E-125](../Intern/BEFUNDE.md#e-125) ist in den sechs Dateien, die PR #155
angefasst hat, richtig eingetragen. In fünf anderen steht weiter, er fehle
noch: in `ZIEL.md`, im `CHANGELOG.md`, in `Releases/PAKETE.md`, in der
Fehlertabelle der `README.md` und in `Doku/ANWENDER.md`. Dazu stimmen zwei
Angaben über das Paket nicht: Es gibt ein ZIP, obwohl drei Dateien „kein ZIP"
sagen, und seine Prüfanleitung enthält noch den Schritt, den Gregor abgelehnt
hat. Am Maßstab für 7.2.1.0 haben sich von acht Kandidaten sechs bestätigt,
einer zum Teil und einer nicht. Das Werkzeug, das „14 von 18 erfüllt" ausrechnet,
zählt **jede Maßstabszeile ohne Befundnummer als erfüllt** — auch die eine,
die ihre eigene offene Aufgabe nennt.

**21 Funde**: 7 falsch, 6 veraltet, 5 Widerspruch zwischen Maßstab, Testplan und
Befunden, 2 unvollständig, 1 Form. **Sechs Fragen an Gregor** stehen gesammelt
am Ende.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **am Text
belegt** (Zitat mit Datei:Zeile), **Vermutung**.

---

## Teil 1 — Was über Paket 1.0.122 und E-125 noch falsch dasteht

### <a id="l-53.1"></a>L-53.1 — der Maßstab sagt, E-125 warte noch auf Gregors Test

**Gewicht: falsch.** `ZIEL.md:54`

Wer in `ZIEL.md` nachsieht, was vor 7.2.1.0 fehlt, liest, dass Gregor das
Ziehen nach `Out` noch testen muss:

> *„gebaut in 7.2.0.122 … **Offen bis zu Gregors Lauf**, TESTPLAN M3"*

**Was stimmt** (am Text belegt): `Intern/BEFUNDE.md:363` sagt *„behoben in
7.2.0.122 – die Ablehnung von Gregor am 23.10.2026 an 1.0.122 bestätigt, die
Gegenprobe am selben Tag am Prüfstand gemessen"*; `Intern/TESTBERICHT-E125.md:9`
sagt *„Bestanden"*. PR #155 hat in `ZIEL.md` nur den erzeugten Block oben
geändert (13 → 14 erfüllt), nicht diese Zeile.

**Vorschlag:** Zeile 54 auf *„behoben in 7.2.0.122, von Gregor am 23.10.2026
an 1.0.122 bestätigt (Ablehnung); die Gegenprobe mit einem Entwurf am Prüfstand
([Testbericht](Intern/TESTBERICHT-E125.md))"*.

### <a id="l-53.2"></a>L-53.2 — der CHANGELOG verlangt noch Gregors Lauf und sagt, der Prüfstand könne den Weg nicht auslösen

**Gewicht: veraltet.** `CHANGELOG.md:154-158`, `CHANGELOG.md:106`

> *„**Was noch fehlt:** Gregors Lauf am Programm. Der Weg geht über
> Ziehen-und-Ablegen und endet in einem modalen Dialog, den der Prüfstand nicht
> auslösen kann."*

**Was stimmt** (am Text belegt): Beides ist überholt. Gregors Lauf ist da
(`BEFUNDE.md:363`), und der Prüfstand fährt den Weg seit PR #155 über das Menü
*Transfer*, als Regressionsfälle `E-125a` bis `E-125c`
(`tools/pruefstand-faelle.txt`, `Intern/TESTPLAN.md:590-593`). PR #155 hat im
CHANGELOG nur die Zeile in der erzeugten Tabelle *Noch offen* entfernt, den
Abschnitt zu 7.2.0.122 nicht. Zeile 106 sagt außerdem *„kein ZIP"* — siehe
[L-53.3](#l-53.3).

**Vorschlag:** den Absatz *Was noch fehlt* ersetzen durch *„Von Gregor am
23.10.2026 an 1.0.122 bestätigt; die Gegenprobe mit einem Entwurf am
Prüfstand"*, mit Verweis auf den Testbericht.

### <a id="l-53.3"></a>L-53.3 — drei Dateien sagen „kein ZIP", aber es liegt eins da

**Gewicht: falsch.** `Releases/PAKETE.md:161`, `:164-165`, `:6`; `CHANGELOG.md:106`

> PAKETE.md:161: *„Übersetzt und als Testverzeichnis abgelegt, aber kein ZIP
> und nicht veröffentlicht."* — :164-165: *„Ein ZIP gibt es dazu noch nicht —
> TESTPLAN M3 braucht Gregors Lauf."* — :6: *„geschnürt ist bis 1.0.120"*

**Was stimmt** (gemessen, nur die Dateiangaben gelesen, nicht geöffnet):

```
$ ls -la --time-style=full-iso /c/Users/Gregor/Eudora72-1.0.122-release.zip
-rw-r--r-- 1 Gregor 197121 9308973 2026-10-23 13:28:50 … Eudora72-1.0.122-release.zip
```

Der Testbericht sagt dasselbe (`Intern/TESTBERICHT-E125.md:27`: *„Paket
1.0.122, aus der ZIP-Datei in `C:\Temp\E125` ausgepackt"*). Die Zeitstempel in
`C:\Temp\E125` passen dazu: Die Verzeichnisse tragen 12:00:44 mit glatten
Sekunden, also aus einem Archiv übernommen; `TESTEN.txt` (12:46:54) und
`LIESMICH.txt` (12:58:22) sind die Nachbesserungen aus [LEKTOR-52](LEKTOR-52.md#lektor-52). Damit war
der Satz *„kein ZIP"* aus [L-52.5](LEKTOR-52.md#l-52.5) um 12:00 richtig und
ist seit 13:28 falsch. **Vermutung:** Das ZIP ist für die Prüfstandsmessung
entstanden und nie eingetragen worden. Es liegt in Gregors Heimverzeichnis,
nicht unter `Releases/`.

**Vorschlag:** In PAKETE.md eine Zeile *ZIP* mit Pfad, Größe, Uhrzeit und
SHA-256 eintragen (die Prüfsumme habe ich nicht gemessen, weil ich die Datei
nicht öffnen darf). Den Satz *„braucht Gregors Lauf"* streichen, den Kopf in
Zeile 6 auf *„Nummern bis 1.0.122 verzeichnet, geschnürt ist bis 1.0.122"*
setzen. Dieselbe Berichtigung in CHANGELOG.md:106.

### <a id="l-53.4"></a>L-53.4 — die Fehlertabelle der README führt E-125 als bestehenden Fehler

**Gewicht: veraltet.** `README.md:163`

In der Tabelle der bekannten Fehler steht weiter, ohne Fassungsangabe:

> *„Eine Nachricht aus einem IMAP-Ordner nach `Out` gezogen wird nicht
> verschoben: in `Out` entsteht eine neue Nachricht mit `<br>` … Nachrichten
> nicht aus einem IMAP-Ordner nach `Out` ziehen"*

**Was stimmt** (am Text belegt): Für den veröffentlichten Stand `v1.0.120`
gilt die Zeile weiter. Ab 1.0.122 ist das Ziehen abgelehnt
(`README.md:98` sagt das selbst, 65 Zeilen höher). Andere Zeilen derselben
Tabelle machen es vor, etwa `README.md:147` (*„Läuft eine Fassung **vor
7.2.0.113** …"*).

**Vorschlag:** *„Bis `v1.0.120`: …; ab 1.0.122 lehnt Eudora das Ziehen mit
einem Hinweis ab"*. Die Zeile bleibt stehen, solange `v1.0.120` die
veröffentlichte Fassung ist.

### <a id="l-53.5"></a>L-53.5 — die Anwenderdoku sagt, 1.0.122 sei noch nicht geschnürt

**Gewicht: veraltet.** `Doku/ANWENDER.md:251-253`

> *„**Ab Paket 1.0.122** … in `v1.0.120` ist er **noch nicht** enthalten, und
> 1.0.122 ist zum Zeitpunkt dieser Zeile noch nicht geschnürt"*

Das ist die Klasse aus [L-52.5](LEKTOR-52.md#l-52.5) in der fünften Datei;
PR #154 und #155 haben vier berichtigt. **Vorschlag:** *„… in `v1.0.120` ist er
noch nicht enthalten; 1.0.122 ist geschnürt, aber nicht veröffentlicht"*.

### <a id="l-53.6"></a>L-53.6 — die Prüfanleitung im Paket enthält noch den Schritt, den Gregor abgelehnt hat

**Gewicht: falsch — betrifft jeden, der das Paket bekommt.** `TESTEN.txt` im Paket 1.0.122

PR #155 hat Schritt 4 von M3 neu geschrieben, weil Gregor ihn als nicht
durchführbar abgelehnt hat (`Intern/TESTPLAN.md:617-621`). Die `TESTEN.txt`
im Paket hat das nicht mitbekommen.

**Gemessen** an der Kopie im Prüfstand (4.539 Byte, genau die Größe, die
[L-52.6](LEKTOR-52.md#l-52.6) für die ausgelieferte Datei nennt):

```
$ grep -n "Entwurf\|4\." /c/Temp/E125/TESTEN.txt
78:4. GEGENPROBE - der wichtigere Schritt.
79:   Eine SELBST VERFASSTE, noch nicht gesendete Nachricht (Entwurf)
```

Das ist der alte Ein-Satz-Schritt ohne 4a–4d. **Vermutung:** Das ZIP von 13:28
enthält dieselbe Datei. Nachgesehen habe ich nicht, weil das ZIP in Gregors
Verzeichnis liegt.

**Vorschlag:** `TESTEN.txt` aus dem neuen M3 erzeugen, bevor das ZIP
weitergegeben oder veröffentlicht wird. Dazu als Dauerlösung: `paket-bauen.ps1`
legt die Datei nicht selbst an ([L-52.6](LEKTOR-52.md#l-52.6)), sie wird jedes Mal von Hand
geschrieben. Deshalb ist sie gegen den Testplan nicht geprüft.

### <a id="l-53.7"></a>L-53.7 — der Testplan hat noch die Buchführung vom 21.10.

**Gewicht: veraltet.** `Intern/TESTPLAN.md:257`

> *„**Stand 21.10.2026, nachmittags.** … **Offen zu testen bleibt [C8](#c8)**
> (der Starttest)"*

**Was stimmt** (am Text belegt): Der Kopf desselben Dokuments, von PR #155 neu
geschrieben, sagt in Zeile 21-22, C8 sei *„derselbe Starttest wie M1 und wird
dort geführt"*. Gregors Urteil zu 1.0.122 ([E-125](../Intern/BEFUNDE.md#e-125), 23.10.2026) fehlt in der
Buchführung, die die Überschrift *„was wann an welchem Paket bestätigt wurde"*
trägt.

**Vorschlag:** einen Satz vorn anfügen: *„Stand 23.10.2026: an 1.0.122 [E-125](../Intern/BEFUNDE.md#e-125)
bestätigt (Ablehnung; Gegenprobe am Prüfstand, Testbericht). C8 wird als M1
geführt."*

### <a id="l-53.8"></a>L-53.8 — „gegen 1.0.122 alle acht Fälle grün": fünf der acht liefen gegen 1.0.121

**Gewicht: falsch.** `tools/WERKZEUGE.md:129`; unvollständig in `Intern/TESTBERICHT-E125.md:23`

> WERKZEUGE.md:129: *„Gegengetestet gegen Paket 1.0.120: zwei der drei
> E-125-Fälle rot, gegen 1.0.122 alle acht Fälle grün"*

**Gemessen** in `tools/TESTLAEUFE.md` (Einträge aus PR #155): Die Fälle
`E-131a`–`c` liefen in `C:\Temp\E131L`, die Fälle [`E-121`](../Intern/BEFUNDE.md#e-121) und [`E-118`](../Intern/BEFUNDE.md#e-118) in
`C:\Temp\E118`. Beide Fenstertitel nennen **`Eudora 7.2.0.121 / Paket
1.0.121+1da36abd*`** (Läufe 14:53:37, 14:54:02, 14:54:26). Nur die drei
E-125-Fälle liefen an 7.2.0.122. Die Zuordnung der Verzeichnisse steht fest in
`tools/pruefstand-faelle.txt`.

**Warum das zählt.** `ZIEL.md:78` verlangt: *„Vor jedem Release laufen alle
Regressionstests, und alle müssen bestehen."* So wie der Satz eingerichtet ist,
prüft er bei fünf von acht Fällen nicht die Fassung, die veröffentlicht werden
soll.

**Zweiter Widerspruch, im Text belegt:** WERKZEUGE.md:129 sagt *„zwei der drei
E-125-Fälle rot"* gegen 1.0.120. `BEFUNDE.md:363` sagt *„dieselben Fälle werden
rot"*, `TESTPLAN.md:593` *„gegen 7.2.0.120 werden sie rot"*. **Vermutung:**
Grün bleibt am alten Stand die Gegenprobe `E-125a`, denn das Verschieben eines
Entwurfs ging dort auch. Dann ist „zwei der drei" richtig, und es ist auch so
gewollt.

**Vorschlag:** WERKZEUGE.md:129 auf *„… drei E-125-Fälle an 1.0.122, die
übrigen fünf an 1.0.121"*. Im Testbericht dieselbe Angabe zu Zeile 23. In
BEFUNDE und TESTPLAN *„zwei der drei, die Gegenprobe bleibt erwartungsgemäß
grün"*. Für das Release eine Regel, dass alle Prüfverzeichnisse vor dem Lauf
auf die Kandidatenfassung gehoben werden — siehe [Frage 5](#fragen).

### <a id="l-53.9"></a>L-53.9 — der Einstieg „Hier weitermachen" steht zwei Tage und sieben Fassungen zurück

**Gewicht: veraltet.** `Intern/WEITERMACHEN.md:10-11`, `:132`

* Zeile 10: *„**Quellstand davor** | 7.2.0.101 … auf Zweig
  `e-121-mehrere-gesendete`"*. Davor lag aber 7.2.0.121 (`git log -S'7.2.0.122'
  -- Eudora71/Version.h` → `196810ce`, davor 7.2.0.121).
* Zeile 11: *„**Quellstand davor (Release)** | 7.2.0.101 … veröffentlicht als
  `v1.0.101`"*. Zuletzt veröffentlicht ist **`v1.0.120`** (`git tag`, Zeile 12
  derselben Tabelle).
* Zeile 132: *„**Stand 21.10.2026 – HIER WEITERMACHEN (gilt vor allen Blöcken
  darunter).** Quellstand **7.2.0.115**"*. Darin steht *„Offen ist allein C8"*
  (inzwischen M1) und *„Defender … Status *pending*"*. Laut
  `BEFUNDE.md` [E-124](../Intern/BEFUNDE.md#e-124) ist der Vorgang
  **abgewiesen**.

Wer nach dieser Datei einsteigt (`BEFUNDE.md:156`: *„Wer neu dazukommt:
**`WEITERMACHEN.md`**"*), liest einen Stand vom 21.10.

**Am Text geprüft und in Ordnung:** *„Zweig `e-14-gemessen-und-rollen`"* in
Zeile 9 und in `PORTIERUNG.md:44`. Der Commit `196810ce` (7.2.0.122) und der
Paketcommit `0c976ce4` liegen beide in PR #152 dieses Zweigs
(`git merge-base --is-ancestor 196810ce 3ce09a81` → wahr).

**Vorschlag:** Zeile 10 auf 7.2.0.121, Zeile 11 auf `v1.0.120`. Den Block
Zeile 132 als *überholt* kennzeichnen und darüber einen kurzen Block *Stand
23.10.2026* setzen: 1.0.122 geprüft, nächster Schritt laut
[Reihenfolge](../ZIEL.md).

---

## Teil 2 — Der Weg zum Release 7.2.1.0: die acht Kandidaten

### <a id="l-53.10"></a>L-53.10 — (a) bestätigt: der Maßstab nennt den Leseweg von E-131 offen, der Befund geschlossen

**Gewicht: Widerspruch Maßstab ↔ Befund.** `ZIEL.md:37`, `ZIEL.md:38`

Worum es geht: Ob eine Eudora.ini, die eine frühere Fassung schon beschädigt
hat, eine daneben installierte Hermes 7.1 weiter am Start hindern kann.

> ZIEL.md:37: *„**Offen bleibt allein der Leseweg von [E-131](../Intern/BEFUNDE.md#e-131)** — eine INI, die
> den kaputten Wert schon trägt, wird erst beim nächsten Speichern
> berichtigt."* — ZIEL.md:38: *„der Leseweg bleibt offen"*

**Was stimmt** (am Text belegt): `BEFUNDE.md:381`, Urteil: *„behoben in
7.2.0.113 (Schreibweg) und 7.2.0.121 (Bereinigung vor dem ersten Laden), am
laufenden Programm gemessen; der Leseweg ist am 22.10.2026 zu Ende gemessen und
war nie der beschriebene."* `tools/ZWEIGE.md:160`: *„[E-131](../Intern/BEFUNDE.md#e-131) ist zu — der erste
Fehlerbericht von außen … damit vollständig erledigt."* `ziel-stand.pl` zählt
die Zeile richtig als erfüllt. Falsch ist nur der Text daneben.

**Nebenbefund, am Text belegt:** In der Zelle `BEFUNDE.md:381` stehen weiter
ältere Sätze *„Offen bleibt der Leseweg"*, ohne dass sie als überholt markiert
sind. Daraus ist der Satz in ZIEL.md vermutlich abgeschrieben.

**Vorschlag:** ZIEL.md:37 und :38 auf *„in 7.2.0.121 auch der Leseweg
geschlossen"*. In BEFUNDE.md:381 die älteren Sätze als *überholt am
22.10.2026* kennzeichnen.

### (b) widerlegt: ZIEL.md führt E-101 nicht als offen

`ZIEL.md:45` sagt *„behoben, soweit es Datenverlust und Gregors Symptom
betrifft … **Nicht behoben, aber ohne Schaden:** F2"*. Das ist wörtlich das
Urteil aus `BEFUNDE.md:340`. `ziel-stand.pl` zählt die Zeile als erfüllt, und
[E-101](../Intern/BEFUNDE.md#e-101) steht nicht in der erzeugten Liste der vier offenen Punkte. Die
Berichtigung [L-52.8](LEKTOR-52.md) hat gehalten. Für das, was an [E-101](../Intern/BEFUNDE.md#e-101)
noch zu fragen bleibt, siehe [L-53.11](#l-53.11).

### <a id="l-53.11"></a>L-53.11 — (c) bestätigt: „erfüllt, nicht fast" — das Werkzeug zählt drei Zeilen mit Vorbehalt als erfüllt

**Gewicht: Widerspruch, und ein Loch im Werkzeug.** `ZIEL.md:16`, `:39`, `:44`, `:45`; `tools/ziel-stand.pl:140`

> ZIEL.md:16: *„Maßstab sind alle neun Kriterien unten, und zwar **erfüllt**,
> nicht „fast"."*

**Gemessen am Werkzeug.** `tools/ziel-stand.pl:139-142`:

```perl
my @ids = $c[1] =~ /\[\*{0,2}([A-Z]+-\d+)/g;
unless (@ids) { $erfuellt++; next }          # eine Anforderung
```

Jede Maßstabszeile **ohne** Befundnummer gilt als erfüllt, egal was in ihr
steht. Drei Zeilen zählen damit als erfüllt, obwohl sie selbst einen offenen
Rest nennen:

| Zeile | was sie selbst sagt | Beleg |
|---|---|---|
| `ZIEL.md:39` Adressbuch | *„ERFÜLLT, Doku fehlt … **Was noch zu tun ist:** die Taste in README.md aufschreiben und einmal am laufenden Programm nachmessen"* | **gemessen:** `grep -n -i "umschalt\|shift" README.md Doku/ANWENDER.md` → kein Treffer. Die Tasten selbst gibt es: `EudoraRes.rc:267-268` legt `Strg+,` und `Strg+Umschalt+,` auf `ID_EDIT_FINISHNICKNAME` |
| `ZIEL.md:44` [E-69](../Intern/BEFUNDE.md#e-69) — ein Filterlauf brach lautlos ab und meldete Erfolg | *„am Prüfstand gemessen, von Gregor noch nicht bestätigt"* | `TESTPLAN.md:205-221` hat Gregors Schritt dazu zurückgezogen (*„Nicht von Gregor zu testen"*). Ein Test durch ihn ist also auch nicht geplant |
| `ZIEL.md:45` [E-101](../Intern/BEFUNDE.md#e-101) — eine gespeicherte Datei war für andere Programme unbrauchbar | *„F1, F3 und F4 sind in 7.2.0.110 behoben"* | `BEFUNDE.md:340`: *„F1, F3 und F4 behoben in 7.2.0.110, von Gregor noch nicht bestätigt"* |

**Vorschlag:** Bei der Adressbuch-Taste ist der Weg klar und ohne Gregor zu
gehen: die Taste in README.md eintragen, einmal messen, dann erst *ERFÜLLT*.
In `ziel-stand.pl` sollte eine Anforderungszeile, deren Text *„Was noch zu tun
ist"* oder *„fehlt"* enthält, als offen zählen. Ob ein *behoben* ohne Gregors
Test zählt, ist seine Entscheidung — [Frage 1](#fragen).

### <a id="l-53.12"></a>L-53.12 — (d) bestätigt: BEFUNDE.md verlangt den Rückstand an Regressionstests vor 7.2.1.0, ZIEL.md nicht

**Gewicht: Widerspruch.** `Intern/BEFUNDE.md:150-152` gegen `ZIEL.md:102-105`

Worum es geht: Für viele kritische Befunde gibt es keinen Test, der meldet,
wenn der Fehler zurückkommt.

> BEFUNDE.md:150-152: *„**15 von 64 mit automatischem Testfall, 0 manuell im
> Testplan, 49 ohne jede Prüfung.** Das ist der Rückstand, der vor 7.2.1.0
> abzuarbeiten ist."*
>
> ZIEL.md:102-105: *„**Die Schranke verlangt den Rückstand nicht auf einmal**
> … die 97 werden gezählt und können dadurch nur sinken."*

Der Maßstab nennt den Rückstand in keiner Zeile, und `ziel-stand.pl` zählt ihn
nicht. **Gemessen** (Ausgabe des `pre-commit` an diesem Arbeitsbaum,
23.10.2026): *„Die kritischen … mit Testfall im Pruefstand 17 von 67 … OHNE
jede Pruefung 50"*. Die Zahlen in beiden Dateien (64/49 bzw. 97) sind
außerdem vom 22.10. und veraltet.

**Vorschlag:** Erst [Frage 2](#fragen). Danach den Satz in BEFUNDE.md oder
in ZIEL.md der Antwort anpassen, und die Zahl von `pruefe-regressionstest.pl`
erzeugen lassen statt sie von Hand zu schreiben.

### <a id="l-53.13"></a>L-53.13 — (e) entschieden, aber nicht eingetragen; und es sind zehn offene kritische, nicht sechs

**Gewicht: unvollständig.** `ZIEL.md:56-57`, `Intern/BEFUNDE.md:139`

**Gregor hat das schon entschieden.** Der `pre-commit` hat beim Versuch, diesen
Bericht zu committen, aus dem Gedächtnisverzeichnis
`Arbeitsweise/entscheidung-kritische-nicht-release-blocker.md` gespiegelt:

> *„ich sehe die ganzen dinge unkritisch. sind randfälle."* — gemeint sind
> [E-122](../Intern/BEFUNDE.md#e-122), [E-123](../Intern/BEFUNDE.md#e-123), [E-124](../Intern/BEFUNDE.md#e-124), [E-126](../Intern/BEFUNDE.md#e-126), [E-129](../Intern/BEFUNDE.md#e-129), [E-136](../Intern/BEFUNDE.md#e-136) (Gregor, 23.10.2026)

Die Notiz sagt selbst: *„noch nicht im Repo eingetragen"*. Diesen Teil stelle
ich also nicht als Frage, sondern als Auftrag: in `ZIEL.md:56` unter
*Ausdrücklich nicht Voraussetzung* mit dem Zitat eintragen.

**Zur Lesart, am Text belegt:** `BEFUNDE.md:139` sagt bei *kritisch*:
*„**Diese müssen vor jedem Release laufen.**"* Gemeint sind ihre **Prüfungen**
(der Satz steht im Abschnitt über Regressionstests, Gregors Wortlaut bei
`pruefe-regressionstest.pl`: *„so dass sie auf jeden fall vor einem release
ausgefuehrt werden"*). Verlangt ist also nicht, dass sie **behoben** sind. Die
Vorprüfung hatte den Satz in diesem zweiten Sinn gelesen.

**Was die Liste der sechs nicht abdeckt** (gemessen: alle Befunde mit
*„Stufe: kritisch"* und offenem Urteil in `BEFUNDE.md`):

| Befund | was es für den Anwender heißt | in ZIEL.md |
|---|---|---|
| [AN-1](../Intern/BEFUNDE.md#an-1) | Ein Anhang, der über IMAP kommt, kann ohne Dateiendung abgelegt werden und lässt sich dann nicht öffnen (Teil B5.7) | nein |
| [E-130](../Intern/BEFUNDE.md#e-130) | Fünf fremde DLLs werden bei jedem Bau neu gestempelt; im Paket liegt nicht genau das, was im Bau steht | nein |
| [E-133](../Intern/BEFUNDE.md#e-133) | Zeigt die Registry auf ein gelöschtes Mailverzeichnis, startet Eudora nicht, statt zu fragen — Gregor: *„nur aufnehmen, nicht fixen"* | nein |
| [E-39](../Intern/BEFUNDE.md#e-39) | Löscht man die gerade benutzte Persönlichkeit, können ihre Einstellungen wiederkommen | **ja**, `ZIEL.md:56` ausdrücklich ausgenommen |

**Vorschlag:** die sechs mit Gregors Zitat eintragen. Für [AN-1](../Intern/BEFUNDE.md#an-1), [E-130](../Intern/BEFUNDE.md#e-130) und
[E-133](../Intern/BEFUNDE.md#e-133) [Frage 3](#fragen).

### <a id="l-53.14"></a>L-53.14 — (f) bestätigt: der Suchindex-Test M2 steht unter „kritisch", der Befund ist „wichtig" und erledigt

**Gewicht: Widerspruch.** `Intern/TESTPLAN.md:521-523`, `:560-584`; `Intern/BEFUNDE.md:267`

Worum es geht: ob der Suchindex bei jedem Start neu aufgebaut wird, was die
Suche in großen Postfächern unbrauchbar machen würde.

> TESTPLAN.md:521: *„Diese Fälle gehören zu **kritischen** Befunden"*

**Was stimmt** (am Text belegt): [E-14](../Intern/BEFUNDE.md#e-14) trägt *„Stufe: wichtig"*, Urteil
*„erledigt … kein Fehler, sondern der normale erste Lauf"* (`BEFUNDE.md:267`).
Gemessen wurde aus neun Mailverzeichnissen: 59 Sitzungen, je Verzeichnis eine
Erasing-Zeile, immer in der ersten Sitzung. Das ist genau die Bedingung, die M2
Schritt 2 prüft. Die Marke *„Prüfung: manuell (Teil M2)"* ist richtig gesetzt.
Mit dem Testplan widersprüchlich ist nur der Einleitungssatz von Teil M.

**Nebenbefund, am Text belegt:** In derselben Zelle `BEFUNDE.md:267` stehen
weiter unmarkiert *„**Was noch fehlt:** die eine Messung, die entscheidet"* und
*„Steht seit dem 05.09.2026 ungeprüft"*. Das sind die Sätze, die
[L-52.11](LEKTOR-52.md) in AUFGABEN und WEITERMACHEN berichtigt hat. Im
Befund selbst stehen sie noch.

**Vorschlag:** TESTPLAN.md:521 auf *„Diese Fälle gehören zu Befunden, die sich
nicht automatisch prüfen lassen"* (oder [E-14](../Intern/BEFUNDE.md#e-14) heraus, je nach
[Frage 4](#fragen)). In BEFUNDE.md:267 die beiden alten Sätze als *überholt
am 23.10.2026* kennzeichnen.

### <a id="l-53.15"></a>L-53.15 — (g) bestätigt: die Kriterientabelle des Maßstabs nennt Quellstand 7.2.0.120

**Gewicht: veraltet.** `ZIEL.md:135`, dazu `ZIEL.md:59-60`

> ZIEL.md:135: *„**Stand 22.10.2026.** Quellstand **7.2.0.120** / `VERSION`
> **1.0.120**"*

**Gemessen:** `grep EUDORA_BUILD_VERSION Eudora71/Version.h` → `"7.2.0.122"`,
`cat VERSION` → `1.0.122`. `doku-pruefen.pl` meldet das nicht, weil die Datei
den Quellstand an anderer Stelle (im erzeugten Block) richtig nennt.

Schwerer wiegt `ZIEL.md:59-60`: *„die Tabelle der Kriterien neu messen (ihre
Urteile stammen von 7.2.0.55)"*. Das ist eine Release-Bedingung, die im
erzeugten Block *Was noch fehlt* nicht vorkommt. Wer nur den Block liest, sieht
vier offene Punkte, nicht fünf.

**Vorschlag:** Zeile 135 auf 7.2.0.122 / 1.0.122. Die Neumessung der neun
Kriterien als eigene Zeile in den Maßstab, damit `ziel-stand.pl` sie zählt.

### <a id="l-53.16"></a>L-53.16 — (h) bestätigt: für eine Marke `v7.2.1.0` gibt es keinen Weg, und die Paketnummer ist unbestimmt

**Gewicht: unvollständig — betrifft den Release selbst.** `ZIEL.md:61`; `tools/release-veroeffentlichen.ps1:63`, `:79-81`, `:173`

> ZIEL.md:61: *„… erst danach Marke `v7.2.1.0`."*

**Gemessen am Werkzeug, das jedes Release macht:**

* `:63` verlangt `-Fassung` in der Form `1.0.28` und vergleicht sie mit
  `VERSION`.
* `:79-81` verlangt in `Version.h` wörtlich `7,2,0,<n>` und `"7.2.0.<n>"`. Ein
  `Version.h` mit 7.2.1.0 weist es ab.
* `:173` `$marke = 'v' + $Fassung`. Die Marke ist immer `v1.0.<n>`, nie
  `v7.2.1.0`.

Dazu die Verabredung in `Releases/PAKETE.md` (*„Produkt- und Paketversion haben
dieselbe letzte Stelle"*), die `tools/kennung-erzeugen.pl:105-123` prüft. Bei
7.2.1.0 hieße das Paket 1.0.0, oder die Verabredung bricht.

**Vorschlag:** erst [Frage 5](#fragen), dann das Werkzeug und `PAKETE.md`
anpassen, **bevor** der Release-Tag kommt. Sonst wird das Werkzeug am Tag des
Releases umgangen oder umgebaut.

---

## Teil 3 — Weitere Funde am Maßstab

### <a id="l-53.17"></a>L-53.17 — Kriterium 2 und 4 hängen an einer Meldung, für die es keinen offenen Befund gibt

**Gewicht: falsch (Zählung).** `ZIEL.md:162`, `:168-172`

Worum es geht: Die neun Kriterien sagen, wann Eudora „lauffähig" ist. Zwei
davon (korrekte Darstellung, keine Abstürze) stehen auf *fast*.

> ZIEL.md:162: *„**Offen bleibt eine Stelle:** die Meldung „Encountered an
> improper argument" beim **Anzeigen** mancher Nachrichten"*

**Was stimmt** (gemessen: `grep -c "improper argument" Intern/BEFUNDE.md` →
5): Die fünf Treffer gehören zu [E-16](../Intern/BEFUNDE.md#e-16)
(Verfassen), [E-34](../Intern/BEFUNDE.md#e-34),
[E-115](../Intern/BEFUNDE.md#e-115) (Strg+F), [E-33](../Intern/BEFUNDE.md#e-33) und [E-37](../Intern/BEFUNDE.md#e-37). Alle sind
erledigt (behoben bzw. *kein eigener Fehler*). Für die Meldung **beim Anzeigen** gibt es keine Kennung. Der
erzeugte Block (*„4 offen"*) kann sie deshalb nicht zählen, während die Tabelle
darunter zwei Kriterien an ihr festmacht.

**Vorschlag:** Das ist eine Aufgabe für mich, keine für Gregor. In den
Protokollen nach der Meldung beim Anzeigen suchen. Wird sie gefunden, bekommt
sie eine Kennung und eine Zeile im Maßstab. Wird sie nicht gefunden, kommt
der Satz mit Datum heraus, und Kriterium 2 und 4 stehen ohne diesen Rest da.

### <a id="l-53.18"></a>L-53.18 — die Kennung A-1 heißt zwei verschiedene Dinge

**Gewicht: falsch (Verweis).** `ZIEL.md:259`, `:313` gegen `Intern/BEFUNDE.md:218`, `:3270`

* `ZIEL.md:259`: *„[A-1](../Intern/BEFUNDE.md#a-1) — Vorgaben für ein **neu angelegtes** Konto"*, erfüllt
  seit 07.09.2026.
* `BEFUNDE.md:218`: *„[A-1](../Intern/BEFUNDE.md#a-1) | Erscheinungsbild: fünf Punkte umgesetzt |
  **teilweise**"*, und so steht es in der erzeugten Liste *Noch offen* im
  CHANGELOG.

`ZIEL.md:313` verlinkt `[A-1](Intern/BEFUNDE.md#a-1)` und schickt den Leser
damit zu einem anderen Befund. Die Legende in `BEFUNDE.md` sagt, `A-` sei
*„Anforderung … aus ZIEL.md"*. Das ist der Eintrag in BEFUNDE.md nicht.
**Folge für Gregor:** Die Liste *Noch offen* führt ein „[A-1](../Intern/BEFUNDE.md#a-1)" als offen, und
wer im Maßstab nachschlägt, findet „[A-1](../Intern/BEFUNDE.md#a-1) erfüllt".

**Vorschlag:** Den Eintrag in BEFUNDE.md umbenennen, er ist ein Agentenbefund
zum Erscheinungsbild (zum Beispiel unter [`S-6`](../Intern/BEFUNDE.md#s-6), wohin er inhaltlich gehört),
oder den Link in ZIEL.md:313 entfernen. Das Werkzeug `befunde-verlinken.pl`
müsste die Doppelvergabe melden; es tut es nicht.

### <a id="l-53.19"></a>L-53.19 — E-123: Einstufung und erzeugte Listen sagen „Bilder gehen verloren", die eigene Messung sagt das Gegenteil

**Gewicht: falsch.** `Intern/BEFUNDE.md:361`; übernommen in der erzeugten
Tabelle `CHANGELOG.md` (Zeile [E-123](../Intern/BEFUNDE.md#e-123)), `README.md:153`, `Intern/TESTPLAN.md:225-228`

Worum es geht: Was verloren geht, wenn Eudora abstürzt oder abgeschossen wird,
während es eine Nachricht in einen IMAP-Ordner verschiebt.

> BEFUNDE.md:361, Schluss: *„**Stufe: kritisch** (Datenverlust: eingebettete
> Bilder nach Neustart weg)"*; die erzeugte Spalte *was noch fehlt*: *„der
> Verlust eingebetteter Bilder nach Absturz, Defender, Stromausfall …"*

**Was stimmt** (am Text belegt, dieselbe Zelle, Messung vom 22.10.2026): *„**Das
eingebettete Bild geht also NICHT verloren.** Verloren geht die ausstehende
Übertragung: `actionqueue.dat` ist 78 Byte — leer … der Anwender erfährt es
nicht."* Darunter steht ein **zweites** *„Was noch fehlt"*: *„die ausstehende
Übertragung muss den Abbruch überleben"*.

**Ursache der falschen Übernahme, am Quelltext belegt:**
`tools/ziel-stand.pl:74` nimmt das **erste** `**Was noch fehlt:**` einer Zelle.
In [E-123](../Intern/BEFUNDE.md#e-123) ist das erste überholt. **Vermutung:** `offene-befunde.pl`, das die
Tabelle im CHANGELOG erzeugt, liest auf dieselbe Weise; die Tabelle zeigt
jedenfalls den alten Text.

**Folge für Gregor:** Die README rät *„vor dem Beenden warten"* wegen
verlorener Bilder. Der gemessene Schaden ist ein anderer: Die Nachricht bleibt
lokal liegen und kommt nie im IMAP-Ordner an, und das ohne Meldung.

**Vorschlag:** In [E-123](../Intern/BEFUNDE.md#e-123) das erste *Was noch fehlt* als überholt kennzeichnen
(nicht löschen) und die Einstufung auf *„Stiller Schaden: ausstehende
Übertragung geht ohne Meldung verloren"* setzen. README:153 und
TESTPLAN:225-228 entsprechend ändern. Für die Werkzeuge: Bei mehreren *Was noch
fehlt* in einer Zelle gilt das **letzte**, oder der Haken weist ab.

### <a id="l-53.20"></a>L-53.20 — „neun Kriterien" und „14 von 18" auf derselben Seite

**Gewicht: Form.** `ZIEL.md:16` gegen `:20`

Zeile 16 sagt *„Maßstab sind alle neun Kriterien"*, Zeile 20 *„Stand: 14 von
18 erfüllt"*. Gezählt werden in Zeile 20 die 18 Zeilen der Maßstabstabelle
(Befunde und Anforderungen), nicht die neun Kriterien. Wer das nicht weiß,
liest einen Rechenfehler. **Vorschlag:** *„14 von 18 Zeilen des Maßstabs
erfüllt"* im erzeugten Satz.

### <a id="l-53.21"></a>L-53.21 — Teil M: „vor jedem Release" oder „vor 7.2.1.0"?

**Gewicht: Widerspruch.** `Intern/TESTPLAN.md:16` gegen `:519`

Teil M sind die drei Handtests M1–M3: fremdes Mailverzeichnis, Suchindex,
Ziehen nach `Out`.

> TESTPLAN.md:16: *„**Vor dem Release 7.2.1.0** bleiben die Fälle aus Teil M
> von Hand zu fahren."* — :519: *„Manuelle Fälle, die **vor jedem Release** zu
> fahren sind"*

Gregors Wortlaut in Zeile 526-527: *„… vor 7.2.1.0 release ausgeführt"*. Für
die automatischen Tests gilt dagegen *„vor jedem release"* (`ZIEL.md:66-67`).
Ob ein Zwischenrelease `v1.0.12x` alle drei Handtests braucht, ist offen —
[Frage 6](#fragen).

---

## <a id="fragen"></a>Was nur Gregor entscheiden kann

1. **Zählt „behoben" im Maßstab ohne deinen Test als erfüllt?** Drei Zeilen
   stehen so: [E-69](../Intern/BEFUNDE.md#e-69) (der Filter überspringt eine
   unlesbare Nachricht jetzt sichtbar statt still abzubrechen), am Prüfstand
   gemessen, von dir nie getestet, und dein Testschritt ist zurückgezogen; die
   drei Nachbesserungen an [E-101](../Intern/BEFUNDE.md#e-101) (gespeicherte
   Nachricht behält ihren Zeichensatz); und die Adressbuch-Taste
   *Strg+Umschalt+,*, die du selbst als Ziel gesetzt hast. ([L-53.11](#l-53.11))
2. **Muss der Rückstand an Regressionstests vor 7.2.1.0 abgearbeitet sein?**
   Heute haben 50 von 67 kritischen Befunden keinen Test, der meldet, wenn der
   Fehler zurückkommt. `BEFUNDE.md` sagt ja, `ZIEL.md` sagt „darf nur sinken".
   ([L-53.12](#l-53.12))
3. **Gilt „Randfälle" auch für [AN-1](../Intern/BEFUNDE.md#an-1), [E-130](../Intern/BEFUNDE.md#e-130) und [E-133](../Intern/BEFUNDE.md#e-133)?** Deine Entscheidung vom
   23.10. nennt sechs Befunde. Offen und kritisch sind außerdem: ein
   IMAP-Anhang kann ohne Dateiendung ankommen ([AN-1](../Intern/BEFUNDE.md#an-1)); im Paket liegen fünf DLLs,
   die anders gestempelt sind als im Bau ([E-130](../Intern/BEFUNDE.md#e-130)); Eudora startet nicht, wenn
   das Mailverzeichnis aus der Registry gelöscht ist ([E-133](../Intern/BEFUNDE.md#e-133), von dir auf
   „nur aufnehmen" gesetzt). ([L-53.13](#l-53.13))
4. **Soll M2 (Suchindex) als Handtest vor dem Release bleiben?** Der Befund ist
   erledigt und aus neun deiner Mailverzeichnisse gemessen. M2 würde nur
   prüfen, dass er nicht zurückkommt. ([L-53.14](#l-53.14))
5. **Wie heißt das Release 7.2.1.0 nach außen, und welche Paketnummer trägt
   es?** Marke `v7.2.1.0` wie in `ZIEL.md`, oder wie bisher `v1.0.<n>`? Und
   sollen dafür alle Prüfstandsverzeichnisse vor dem Regressionslauf auf genau
   diese Fassung gehoben werden? Heute laufen fünf der acht Fälle an 1.0.121.
   ([L-53.16](#l-53.16), [L-53.8](#l-53.8))
6. **Gelten die drei Handtests M1–M3 vor jedem Release oder nur vor 7.2.1.0?**
   ([L-53.21](#l-53.21))

---

## Geprüft und in Ordnung

* **Die sechs Dateien, die PR #155 berichtigt hat** — README.md:98,
  AUFGABEN.md:3, PORTIERUNG.md:44, WEITERMACHEN.md:12, BEFUNDE.md:363 und der
  Kopf von TESTPLAN.md nennen 1.0.122 übereinstimmend als geschnürt und
  geprüft.
* **`tocdoc.cpp:2753`** (TESTPLAN M3, Testbericht) ist die Zeile
  `if (ToOut && !Sum->IsComp())`, also genau die Prüfung.
* **277 Tests** stehen übereinstimmend in TESTPLAN.md:251, README.md:98 und
  PAKETE.md.
* **`Intern/pruefstand-ergebnis.txt`** nennt 8 Fälle, 8 bestanden, mit
  Gregors Freigabesatz und der Uhrzeit des letzten Laufs (14:54:52) — passt
  zu `tools/TESTLAEUFE.md`.
* **`perl tools/doku-pruefen.pl`**: kein Widerspruch zwischen den Dokumenten.
  Die 14 Hinweise *„nennt weder Quellstand noch Paketnummer"* betreffen
  datierte Release-Notizen und Hintergrundtexte, bei denen das richtig ist.

## Nicht geprüft

* Den **Inhalt** des ZIP `Eudora72-1.0.122-release.zip` und seine SHA-256 —
  es liegt in Gregors Heimverzeichnis, ich habe nur die Dateiangaben gelesen.
* Die **453 Spurmarken** aus `Intern/TESTBERICHT-E125.md:37`. Das Protokoll des
  Laufs habe ich nicht ausgezählt.
* Welcher der drei E-125-Fälle gegen 1.0.120 grün blieb ([L-53.8](#l-53.8), Vermutung).

## Zum Ablauf dieses Berichts

Der Bericht ist **nicht committet**. Der `pre-commit` weist ihn aus Gründen
ab, die außerhalb meines Auftrags liegen (`perl tools/commit-bereit.pl`: zuletzt 3 von 41
Schranken; `befunde-verlinken.pl` betraf diesen Bericht selbst und ist behoben):

* `lehren-spiegeln.pl` hat `Arbeitsweise/MEMORY.md` und die neue Notiz
  `Arbeitsweise/entscheidung-kritische-nicht-release-blocker.md` aus dem
  Gedächtnisverzeichnis in den Arbeitsbaum kopiert und verlangt, dass sie
  mitcommittet werden.
* `lehren-schranken.pl` und `lehren-uebersicht.pl` weisen genau diese Notiz
  ab, weil ihr die Zeile `Schranke:` fehlt.
* `pruefe-stand-md.pl` verlangt einen Eintrag für [LEKTOR-53](#lektor-53) in
  `Intern/LEKTORAT.md`.

Alle drei verlangen Änderungen an Dateien, die ich laut Auftrag nicht ändere.
[LEKTOR-51](LEKTOR-51.md#lektor-51) und [LEKTOR-52](LEKTOR-52.md#lektor-52) sind auf demselben Weg ins Repo gekommen: beim
Einarbeiten zusammen mit `LEKTORAT.md`.
