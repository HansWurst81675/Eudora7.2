# <a id="lektor-140"></a>LEKTOR-140 (03.11.2026) — Paket 7.2.2.132 vor dem PR, Zweig `paket_7_2_2_132` nach e96dd180

**Umfang:** `git log --stat origin/main..HEAD` (zwei Commits, `561f3ebf` Versionssprung und `e96dd180` geschnürt); gelesen: CHANGELOG-Abschnitt 7.2.2.132, Releases/PAKETE.md (7.2.2.132), Releases/PRUEFBERICHT.md (Kopf), Intern/TESTPLAN.md *Dein Test an 7.2.2.132*, README *Bekannte Fehler* und Stand-Absatz, ZIEL- und WEITERMACHEN-Diff; dazu jeder Fund aus [LEKTOR-138](LEKTOR-138.md#lektor-138) und [LEKTOR-139](LEKTOR-139.md#lektor-139) am heutigen Stand. Die übrigen der 66 MD-Dateien (ohne `Arbeitsweise/`, `Befunde/`) nur über `doku-pruefen.pl` und gezielte Suche nach Zustandswörtern (*„noch in keinem Paket“*, *„noch nicht geschnürt“*, *„kommt mit 7.2.2.132“*, *„NICHT VOLLSTÄNDIG“*), nicht einzeln gelesen.

**Urteil:** Paketbuchführung stimmig — Nummer, Bau, Kennung, SHA-256 und Prüfzahlen stehen in CHANGELOG, PAKETE, README, WEITERMACHEN, ZIEL und TESTPLAN gleich; keine neuen Pfade, Ordner-, Konto- oder Anbieternamen in den MDs (`git diff origin/main..HEAD -- '*.md'`, nur Prüfstandspfade unter `C:\Temp`). Drei Funde, keiner hält den PR auf.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*; 19 Hinweise der Art *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“* für alte Releasenotizen, `MELDUNGEN-VON-AUSSEN.md`, `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md` — Altbestand, beschreibt frühere Fassungen, kein Fund.
* `perl tools/offene-befunde.pl` (gemessen): *„61 offene Befunde, in beiden Listen gleich.“*; davon *„veraltet gemessen 24“*, *„NIE gemessen 11“*.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„mit Testfall im Pruefstand 66 von 72“*, *„OHNE jede Pruefung 4 … [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129)“* — unverändert gegenüber dem Vorstand.
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen“*.
* `perl tools/paket-bereit.pl` (gemessen): Rückgabe 1, einziger Mangel *„LEKTOR ist faellig: seit seinem Bericht (928edc0) haben sich 10 Datei(en) in seinem Bereich geändert“* — dieser Bericht.

## Funde aus LEKTOR-138 und LEKTOR-139 — heutiger Stand

| Fund | Stand | Stelle |
|---|---|---|
| [L-138.1](LEKTOR-138.md#l-138.1) Labelverlust als Alltagsfehler dargestellt | **erledigt** | `README.md:167` beginnt *„An einem IMAP-Server, der beim Verschieben **keine neuen Nummern** meldet (ohne UIDPLUS)“* |
| [L-138.2](LEKTOR-138.md#l-138.2) E-170-Logzeile im Eintrag noch als *Misc* | **teilweise, Rest bewusst** | `Intern/BEFUNDE.md:430` enthält weiter *„Misc*, 0x8000 — in Gregors `LogLevel=58527` an, in der Vorgabe 25759 aus“* — laut BEHEBER im Teil, der 7.2.1.131 beschreibt; trifft (belegt) |
| [L-138.3](LEKTOR-138.md#l-138.3) alter Bau, alte Testzahl | **erledigt** (Nachtrag 1), unverändert | — |
| [L-138.4](LEKTOR-138.md#l-138.4) bis [L-138.6](LEKTOR-138.md#l-138.6) | **erledigt** (Nachtrag 1), unverändert | — |
| [L-138.7](LEKTOR-138.md#l-138.7)/[L-138.8](LEKTOR-138.md#l-138.8) About-Zweig | **erledigt** (Nachtrag 2) | — |
| [L-138.9](LEKTOR-138.md#l-138.9) Berichtszahl README (vorgemerkt) | **offen** | `README.md:98` *„(219 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“*; `ls Befunde/LEKTOR-*.md Befunde/PRUEFER-*.md` → 229, mit diesem 230 (gemessen) |
| [L-138.10](LEKTOR-138.md#l-138.10) Ordnernamen über E-189-Zeilen im Protokoll ([E-189](../Intern/BEFUNDE.md#e-189): Vorab-Kopie bleibt im Ziel) | **offen** | `Eudora71/EuImap/src/ImapToc.cpp:1819` und `:1825` weiter *„ziel=\"%s\"“* mit `pZiel->Name()` (gemessen) |
| [L-138.11](LEKTOR-138.md#l-138.11) [E-216](../Intern/BEFUNDE.md#e-216) „Nicht gemessen: der Umbruch selbst“ (vorgemerkt) | **offen** | `Intern/BEFUNDE.md:400` *„Nicht gemessen:** der Umbruch selbst — die Herkunft im Prüfstand ist 30 Zeichen kurz“* |
| [L-138.12](LEKTOR-138.md#l-138.12) CHANGELOG nur `E-216p` (vorgemerkt) | **offen** | `CHANGELOG.md:187` nennt nur `E-216p`; `tools/WERKZEUGE.md:171` Kopf weiter *„Mail folder from* mehr als eine Zeile hoch“* |
| [L-139.1](LEKTOR-139.md#l-139.1) TESTPLAN-Überschrift „Erledigt“ bei offenem [E-170](../Intern/BEFUNDE.md#e-170) (vorgemerkt) | **offen** | `Intern/TESTPLAN.md:402` *„Erledigt am 03.11.2026: das Label bleibt beim Verschieben im IMAP-Konto“*; [E-170](../Intern/BEFUNDE.md#e-170) offen in `Intern/BEFUNDE.md:430` |

## Funde

### <a id="l-140.1"></a>L-140.1 — TESTPLAN 7.2.2.132: zwei Schritte für Dinge, die der Prüfstand schon misst

**Gewicht: mittel.** Der Abschnitt verspricht in `Intern/TESTPLAN.md:7` *„**Hier steht nur, was der Prüfstand nicht kann**“* — und der Kasten darunter nennt für genau zwei der zwölf Schritte schon einen Prüfstandsfall. (gemessen an den Texten)

- Schritt 10 (`Intern/TESTPLAN.md:26`, [E-128](../Intern/BEFUNDE.md#e-128): *Speichern unter* schlägt die zum Inhalt passende Endung vor) erwartet *„aus der Liste … **Mail Files (*.eml)** …, aus dem geöffneten Fenster **HTML Files (*.htm)**“*; der Kasten (`:47`) *„`E-128p`, `E-128k`, `E-128t` | `.eml`/`.htm`/`.txt` je nach Inhalt und Fenster“*.
- Schritt 11 (`:27`, [E-207](../Intern/BEFUNDE.md#e-207): *Save As* aus dem Signaturfenster schrieb eine leere Datei) erwartet *„die gespeicherte Datei nicht leer ist“*; Kasten (`:50`) *„`E-207p` | `.txt` und `.htm` enthalten den Text“*.
- Die übrigen zehn Schritte sind je für Gregor ausführbar (Ort, Menü, erwartetes Bild genannt) und brauchen etwas, das der Prüfstand nicht hat: echte Konten (2–5), seinen Browser (6, 7, 9), seine Bildschirmeinstellung (8; Vermutung: deshalb neben `E-216p`), sein Beenden mit echtem Mailverzeichnis (12).

**Vorschlag:** entweder die Schritte 10 und 11 streichen (der Kasten deckt sie) oder sagen, was Gregors System hinzufügt (*„an einer deiner echten HTML-Mails“*, *„an deiner eigenen Signatur“*); dann den Kopfsatz in *„vor allem, was der Prüfstand nicht kann“* ändern.

### <a id="l-140.2"></a>L-140.2 — „81 Fälle, 81 bestanden“ aus zwei Läufen, Prüfbericht mit unsauberem Arbeitsbaum

**Gewicht: Kleinkram.** (gemessen an den Texten)

- `Intern/TESTPLAN.md:37-38` *„Voller Lauf am Bau … **81 Fälle, 81 bestanden** — vier E-170-Fälle erst nach einer Berichtigung im Messskript“*; `Releases/PRUEFBERICHT.md` Dauerzeile *„Pruefstand, 81 Faelle, 47 Eudora-Starts | 37 min 00 s | voller Lauf, Ende 2026-11-03 12:26:43“*. Tatsächlich: voller Lauf 77 von 81, danach die sieben E-170-Fälle neu (12:29–12:39) — so richtig in `Releases/PAKETE.md:193` und in der Commit-Nachricht von `e96dd180`. Die Zahl stimmt, „voller Lauf … 81 bestanden“ als ein Lauf nicht.
- `Releases/PRUEFBERICHT.md:6` *„`561f3ebf` — **Arbeitsbaum nicht sauber** (2 Dateien)“* neben `Releases/PAKETE.md:190` *„(ohne Sternchen: der Arbeitsbaum war beim Bau sauber)“* — beides wahr (Bau 11:46, Bericht 12:40, dazwischen `tools/messen-e184.ps1` geändert; welche die zweite Datei war, Vermutung: das Prüfstandsbuch), für den Leser aber ein scheinbarer Widerspruch. Welche zwei Dateien, sagt keine Stelle.

**Vorschlag:** TESTPLAN *„81 von 81 (voller Lauf 77, die sieben E-170-Fälle nach der Berichtigung des Messskripts am selben Bau neu)“*; in PAKETE ein Halbsatz *„der Prüfbericht nennt den Baum unsauber: `messen-e184.ps1` war berichtigt, noch nicht committet; ins Programm geht es nicht“*.

### <a id="l-140.3"></a>L-140.3 — BEFUNDE: „kommt mit 7.2.2.132“ und „Zuletzt gemessen … an 7.2.1.131“ nach dem Schnüren

**Gewicht: Kleinkram, Klasse [L-128.2](LEKTOR-128.md#l-128.2) (Zustandsangabe überlebt den Schritt).** (gemessen)

- `grep -c "kommt mit 7.2.2.132" Intern/BEFUNDE.md` → 16, z. B. `:243` [A-5](../Intern/BEFUNDE.md#a-5) (Hilfe-Menü) *„kommt mit 7.2.2.132“*, `:391` [E-128](../Intern/BEFUNDE.md#e-128), `:400` [E-216](../Intern/BEFUNDE.md#e-216) (About-Dialog), `:430` [E-170](../Intern/BEFUNDE.md#e-170) (Label ohne UIDPLUS); ebenso `CHANGELOG.md:34` und `Intern/WEITERMACHEN.md:83` für [E-209](../Intern/BEFUNDE.md#e-209) (Pfad mit Leerzeichen ohne 8.3-Namen). Das Paket ist geschnürt; README, PAKETE und CHANGELOG-Kopf sagen *„im Testpaket 7.2.2.132“*.
- Dieselben Einträge: *„Zuletzt gemessen: 03.11.2026 an 7.2.1.131“* (`:391`, `:400`), obwohl der Prüfstand am Bau `7.2.2.132+561f3ebf` alle ihre Fälle grün hat (`Releases/PRUEFBERICHT.md`). `offene-befunde.pl` zählt sie dennoch als aktuell (ab Nummer 127) — veraltet ist die Angabe, nicht die Zählung.

**Vorschlag:** beim Merge von `paket_7_2_2_132` *„kommt mit 7.2.2.132“* → *„im Testpaket 7.2.2.132“* und *Zuletzt gemessen* auf den Paketbau setzen; Kandidat für ein Werkzeug, da es bei jedem Paket wiederkehrt.

## Bestand außerhalb des Schwerpunkts

- CHANGELOG 7.2.2.132 (`CHANGELOG.md:123-189`): Überschrift, Kopfabsatz (*„Geschnürt am 03.11.2026 … nicht veröffentlicht“*), Neu/Berichtigt/Gemessen und *Werkzeug beim Schnüren* stimmen mit PAKETE und Commit-Nachricht überein (gelesen).
- README *Bekannte Fehler*: neue Behebungen durchweg mit *„Ab 7.2.2.132 (Testpaket)“* bzw. *„Im Testpaket 7.2.2.132 berichtigt“* (`README.md:163`, `:167`, `:202`) — keine als veröffentlicht dargestellt; [E-170](../Intern/BEFUNDE.md#e-170) mit der UIDPLUS-Bedingung vorn (Randfall richtig gewichtet).
- ZIEL (Diff): Kandidat *Speichern unter* als umgesetzt vermerkt, *„Von den übrigen Kandidaten“* — trifft; `ziel-stand.pl` 27/27.
- WEITERMACHEN-Kopf (`Intern/WEITERMACHEN.md:3`): #215/#216 gemergt, laufend `paket_7_2_2_132` — trifft.
- TESTPLAN Schritt 9 erwartet richtig, dass *Latest Release* noch 7.2.1.131 zeigt.

## Was nur Gregor entscheiden kann

Nichts.
