# <a id="lektor-130"></a>LEKTOR-130 — Bestand nach dem Hilfe-Menü (A-5), Zweig hilfe_menue nach b65e4f1c (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-129](LEKTOR-129.md#lektor-129).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102k`, abgezweigt von `origin/hilfe_menue`, Stand `b65e4f1c` (*„Merge remote-tracking branch 'origin/main' into hilfe_menue“*).
Umfang: Bestand aller 66 MD-Dateien außerhalb von `Arbeitsweise/` und `Befunde/` (`git ls-files '*.md'`, gezählt), Schwerpunkt der Zweig `hilfe_menue` — gegenüber `253a8a40` (Merge von #205, Stand von `main`) 18 Commits, 21 Dateien, 1517 Zeilen hinzu, 270 weg (`git diff --stat`, gemessen). Dazu die erzeugten Seiten unter `C:\Temp\EHILFE\Hilfe\` (nur gelesen) und eine frische Erzeugung mit `tools/hilfe-html.pl` ins Scratchpad zum Vergleich. Nichts gestartet.

## Kurz

Das Hilfe-Menü selbst ist sauber beschrieben: Testplan, Befund, Werkzeugliste und Quelltext stimmen in Menüstelle, Statuszeilentext, Meldungstext und Logzeile überein, und die Seiten unter `C:\Temp\EHILFE\Hilfe\` sind inhaltlich gleich mit dem, was `hilfe-html.pl` heute aus `Doku/FUNKTIONEN.md` erzeugt (gemessen). **Zwei Dinge sind aber nicht in Ordnung, bevor der Zweig nach `main` geht:** In der Geschichte des Zweigs steht eine Gedächtnisdatei mit einer persönlichen Angabe Gregors, die laut eigener Regel nicht ins Repo soll — ein gewöhnlicher Merge brächte sie nach `main`. Und alle Stellen nennen das kommende Paket „7.2.2.0“, obwohl die Nummernregel eine laufende Buildnummer verlangt und die Schranke `pruefe-fassungsnummer.pl` eine 0 abweisen würde. Dazu: der 7.2.2-Block steht im CHANGELOG mitten im Abschnitt des veröffentlichten Releases 7.2.1.131, ZIEL.md sagt „umgesetzt ist davon noch nichts“, und der Testplan verschweigt, dass die Logzeile erst nach dem Beenden in der Datei steht. Acht Funde, keiner am Programmcode.

## Funde aus LEKTOR-129 — heutiger Stand

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-129.1](LEKTOR-129.md#l-129.1) „zuletzt veröffentlicht 7.2.1.128“ in drei Stand-Köpfen | **Text erledigt, Schranke offen** | `Intern/WEITERMACHEN.md:3` *„Zuletzt veröffentlicht: **`v7.2.1.131`** (02.11.2026, siehe oben); davor **`v7.2.1.128`**“*; `Releases/PAKETE.md:6` *„veröffentlicht zuletzt also 7.2.1.131; davor 7.2.1.128“*; `ZIEL.md:216` unverändert richtig. `tools/pruefe-release-buchfuehrung.pl` zuletzt geändert in `cf6c3fee` ([LEKTOR-95](LEKTOR-95.md#lektor-95)), `grep -c 'zuletzt ver'` → 0: die vorgeschlagene Prüfung fehlt |
| [L-129.2](LEKTOR-129.md#l-129.2) „nicht veröffentlicht“ unter „Release“ | **erledigt** | `CHANGELOG.md:116` *„veröffentlicht am 02.11.2026 als [`v7.2.1.131`]“*; `Releases/PAKETE.md:189` *„als Anhang von [`v7.2.1.131`]“*; `grep 'Release-Kandidat — veröffentlicht wird' Releases/PAKETE.md` kein Treffer |
| [L-129.3](LEKTOR-129.md#l-129.3) Kleinkram (TESTPLAN-Kopf, AUFGABEN, FUNKTIONEN) | **erledigt** | `Intern/TESTPLAN.md:1` *„Release `v7.2.1.131`, veröffentlicht am 02.11.2026“*; `Intern/AUFGABEN.md:8` *„Eingereicht als `release_7_2_1_131` (#204) und am 02.11.2026 als [`v7.2.1.131`] …“*; `Doku/FUNKTIONEN.md:914` (war `:908`) *„berichtigt in 7.2.1.131“* |
| [L-128.2](LEKTOR-128.md#l-128.2) Schranke gegen „PR folgt“ nach dem Merge | **offen** | `grep -l 'PR folgt' tools/*.pl` kein Treffer; die Wiederholung steht als [L-130.6](#l-130.6) |
| [L-128.3](LEKTOR-128.md#l-128.3) Schranke gegen einen Entwurfskopf in der Notizdatei | **offen** | `tools/release-veroeffentlichen.ps1:128` *„if ($text -match 'noch nicht best')“* prüft weiter nur den CHANGELOG-Abschnitt; `:261` reicht die Datei ungeprüft an `--notes-file` |
| [L-128.8](LEKTOR-128.md#l-128.8) Berichtszahl in der README | **stimmt bis zu diesem Bericht** | `README.md:98` *„(209 LEKTOR- und PRÜFER-Berichte)“* = `ls Befunde \| grep -cE '^(LEKTOR\|PRUEFER)-[0-9]+\.md$'` → 209; mit diesem Bericht 210 |
| [L-126.1](LEKTOR-126.md#l-126.1) Schritt im Webmailer prüft vermutlich das falsche Datum | **teilweise** (wie in [LEKTOR-129](LEKTOR-129.md#lektor-129)) | `Intern/TESTPLAN.md:409` *„Im lokalen *In* eine Mail aussuchen, deren Uhrzeit du kennst“* unverändert; `:427` verweist auf [L-126.1](LEKTOR-126.md#l-126.1) |
| [L-126.5](LEKTOR-126.md#l-126.5) Starts ohne Titelzeile in `tools/TESTLAEUFE.md` | **teilweise** | die vier A-5-Läufe `:762`–`:765` tragen *„[Eudora 7.2.1.130+0a4b77a1 …]“* bzw. *„[Eudora 7.2.1.131+a2f29b69* …]“*; vom 02.11. sind aber weiter 10 von 51 Zeilen ohne `[Eudora` (`:715`, `:719`, `:721`, `:722`, `:724`, `:728`, `:730`, `:732`, `:735`, `:736`) — `:736` (11:53:06, `C:\Temp\E143S`) war im Bericht [LEKTOR-126](LEKTOR-126.md#lektor-126) nicht mitgezählt |

## A-5 gegen den Quelltext und die erzeugten Seiten

| Aussage | Stelle | Gegen (gemessen) |
|---|---|---|
| Menüstelle: hinter *Tip of the Day*, durch Trennlinien abgesetzt | `Intern/TESTPLAN.md:435-436` | `EudoraRes.rc` (Diff zu `253a8a40`): `MENUITEM SEPARATOR` vor und nach den beiden neuen Einträgen; `BEFUNDE.md:243` *„`Ti&p of the Day=32969` an Stelle 6, `&Keyboard Shortcuts=33270` an 8, `Settings Re&ference=33271` an 9“* passt dazu |
| Statuszeile *Shows all keyboard shortcuts in your web browser* / *Shows Tools > Options and the Eudora.ini keys in your web browser* | `Intern/TESTPLAN.md:438-440` | `EudoraRes.rc` STRINGTABLE, zeichengleich |
| Meldung *The help page Tastenkuerzel.html could not be found* mit Pfad | `Intern/TESTPLAN.md:451-453`, `BEFUNDE.md:243` | `mainfrm.cpp`, `CMainFrame::HilfeSeiteOeffnen`: *„The help page %s could not be found.\n\nEudora expects it here:\n%s“* |
| Kennungen 33270/33271 | `BEFUNDE.md:243`, `WERKZEUGE.md:155` | `resource.h:4466-4467`; 33269 bis 33275 sonst nirgends in `Eudora71/Eudora/*.h` belegt |
| Logzeile `Hilfe: <datei> geoeffnet\|fehlt\|fehler=n`, Bereich *Misc* | `BEFUNDE.md:243`, `TESTPLAN.md:456-458` | `mainfrm.cpp`: `PutDebugLog(DEBUG_MASK_MISC, …)` an allen drei Ausgängen; `DEBUG_MASK_MISC = 0x8000` (`QCUtils/public/inc/debug.h:36`) = das Bit 32768, das `Doku/FUNKTIONEN.md:949` für Gregors `LogLevel` als **bestätigt** führt |
| Seite 2: Tabellen *Strg + Buchstabe*, *Strg + Ziffer* … | `TESTPLAN.md:442-443` | `C:\Temp\EHILFE\Hilfe\Tastenkuerzel.html`: `<h3>` *Strg + Buchstabe*, *Strg + Ziffer*, *Strg + Umschalt + …*, *Funktionstasten*, *Alt + …*, *Sonderzeichen und Einzeltasten* = `Doku/FUNKTIONEN.md:329-408`; 68 Tabellenzeilen auf der Seite, 68 in der Quelle |
| Seite 3: je eine Tabelle pro Optionsseite, *Getting Started* bis *Find Messages*, dann Schlüssel ohne Optionsseite | `TESTPLAN.md:445-448` | `Einstellungen.html`: 33 Tabellen = 32 Optionsseiten (`FUNKTIONEN.md:483-860`) + Abschnitt 5; erste `<h3>` *Getting Started*, letzte *Find Messages* |
| Spalte *Abschnitt*: 197 Zeilen `[Settings]` unter *Tools → Options*, 4 leer | `BEFUNDE.md:243`, Commit `54b7b5fa` | `FUNKTIONEN.md:483-870`: 201 Tabellenzeilen, 197 mit `` `[Settings]` ``. Auf der Seite 210 Zellen `[Settings]` und 3 `[Debug]` (mit Abschnitt 5) |
| Stichprobe Zeile | `FUNKTIONEN.md:495` *„\| *Allow authentication* \| `SmtpAuthAllowed` \| `[Settings]` \| `1` \|“* | `Einstellungen.html`: dieselbe Zeile, Spalten gleich |
| Verweise: Anker auf derselben Seite bleiben, alle anderen auf `blob/main/` | `WERKZEUGE.md:58` | beide Seiten: jeder `href` außerhalb der Seite zeigte damals auf den Pfad `blob/main/` des Repositorys auf GitHub |
| Seiten am Prüfstand = heutige Quelle | — | frisch erzeugt (`perl tools/hilfe-html.pl <scratchpad>`): beide Dateien byte-gleich lang (25668 / 73721), `diff` nur in Zeile 25-26 (Kopf: Fassung und Commit) |
| `--selbsttest` 31 Fälle | `WERKZEUGE.md:58`, `BEFUNDE.md:243` | `perl tools/hilfe-html.pl --selbsttest` → *„31 ok, 0 FEHLER“* |
| Regressionsfall `A-5p`/`A-5p-log` grün | `BEFUNDE.md:243` | `Intern/pruefstand-buch.tsv:3-4` *„A-5p ok 2026-11-02 14:40:01 … menue=1 kuerzel=ausgelassen einstellungen=ausgelassen fehlt-meldung=1 lebt=1“*; `tools/pruefstand-faelle.txt:369-370` |
| Maßstab 7.2.2: jede neue Funktion mit Testplan-Schritt und, wo es geht, Prüfstandsfall | `ZIEL.md:115-118` | erfüllt: `TESTPLAN.md#a-5-naechstes`, Fälle `A-5p`/`A-5p-log` |

## Funde

### <a id="l-130.1"></a>L-130.1 — In der Geschichte von `hilfe_menue` steht eine persönliche Angabe Gregors; ein gewöhnlicher Merge brächte sie nach `main`

**Gewicht: hoch.** Gregor hat ausdrücklich gesagt, dass der Grund und der Termin nirgends im Repo stehen sollen; `main` ist heute frei davon. (gemessen)

- `Arbeitsweise/entscheidung-7-2-2-umfang.md:10` *„Gregor wünscht ausdrücklich, dass der GRUND für den Termin nirgends im Repo steht … — auch der Termin nicht.“*
- Commit `d9ae24c8` (*„ZWEIGE: hilfe_menue (Gregor 02.11.2026); Lehre 7.2.2 gespiegelt“*) legt unter `Arbeitsweise/` die Vorgängerdatei an; Dateiname, Beschreibung und ein *Nachtrag* darin nennen genau diese Angaben (gelesen mit `git show`, hier nicht wiedergegeben). `0a4b77a1` ersetzt sie durch `entscheidung-7-2-2-umfang.md` — die alte Fassung bleibt aber in der Geschichte, und `git log --stat 253a8a40..HEAD` zeigt ihren Namen.
- `git branch -r --contains d9ae24c8` → `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`. Dieselbe Datei in älterer Fassung: `9f3feb8f`, `cb18ca56` auf `origin/paket_7_2_1_131` und `origin/wt/lektor-20261102g`; `86e58a79` auf `origin/wt/lektor-20261102f`. `git log origin/main -- <alte Datei>` → leer: auf `main` nicht.
- Die Merges `d1bfd765` und `b65e4f1c` haben `main` in den Zweig geholt — ein PR von `hilfe_menue` mit gewöhnlichem Merge nähme `d9ae24c8` mit.

**Vorschlag:** Den Zweig wie `release_7_2_1_131` als **einen** Commit auf `main` bringen (so ist [L-128.9](LEKTOR-128.md#l-128.9) gelöst worden), und die Zweige auf GitHub, die die Datei tragen, nach dem Merge löschen. Beides ist Gregors Entscheidung (unten).

### <a id="l-130.2"></a>L-130.2 — Das kommende Paket heißt überall „7.2.2.0“; die Nummernregel und die Schranke verlangen eine laufende Buildnummer

**Gewicht: mittel.** Wer nach dem Testplan *„Fassung 7.2.2.0“* auf der Seite erwartet, findet etwas anderes — oder die Schranke weist das Paket ab. (Text gemessen; Verhalten der Schranke belegt aus dem Code, nicht gelaufen)

- `Intern/TESTPLAN.md:429` *„## Mit 7.2.2.0: Help → …“*, `:431` *„Erst mit dem Paket 7.2.2.0 auszuführen“*, `:443-444` *„oben stehen die Fassung 7.2.2.0“*; `Intern/BEFUNDE.md:243` *„Gregor muss erst mit dem Paket 7.2.2.0 etwas tun“*; daraus erzeugt `CHANGELOG.md:71` und `Intern/WEITERMACHEN.md:120` *„Gregors Blick am Paket 7.2.2.0“*.
- `ZIEL.md:105` *„Das Release heißt `7.2.1.<laufende Buildnummer>`“* (Gregor am 23.10.2026); `VERSION` heute `7.2.1.131`.
- `tools/pruefe-fassungsnummer.pl:89` liest nur die **letzte** Stelle (*„/\b\d+\.\d+\.\d+\.(\d+)\b/“*), `:131` ebenso für Tags; Prüfung D (`:46` *„Kein Tag ist HOEHER als die Nummer aus VERSION“*, Meldung `:183`). Bei `VERSION` = `7.2.2.0` stünde 0 gegen das Tag `v7.2.1.131` mit 131.
- Die Fassung im Seitenkopf kommt aus `VERSION` (`tools/hilfe-html.pl:111-117`, `lies_fassung`), nicht aus einer festen Zahl — der Testplan-Satz stimmt also nur, wenn `VERSION` wirklich `7.2.2.0` heißt.

**Vorschlag:** Im Testplan und im Befund „das erste Paket 7.2.2“ ohne Endnummer; die Nummer setzt das Schnüren. Welche Nummer es wird, ist ein Name — Frage unten.

### <a id="l-130.3"></a>L-130.3 — Der 7.2.2-Block steht im CHANGELOG im Abschnitt des veröffentlichten Releases 7.2.1.131

**Gewicht: mittel.** Unter *„Die Einzelheiten je Zweig“* eines Releases liest man: das ist drin. Das Hilfe-Menü ist in keinem Paket. (gemessen)

- `CHANGELOG.md:114` *„## 7.2.1.131 — Release (`v7.2.1.131`, veröffentlicht am 02.11.2026) …“*, `:123` *„Die Einzelheiten je Zweig, jüngster zuerst:“*, darunter `:129` *„**Für 7.2.2 vorgemerkt — Zweig `hilfe_menue`** (… noch nicht gemergt, noch in keinem Paket)“* und `:131` der Eintrag zum Menü; die nächste `##`-Überschrift ist erst `:173` (7.2.1.130).
- Der Satz in `:129` stellt es selbst richtig — aber nur, wer ihn liest; das Inhaltsverzeichnis und die Überschrift sagen anderes.

**Vorschlag:** Eigene Überschrift über `:114`, etwa *„## 7.2.2 — im Quellstand, noch in keinem Paket“*, und den Block dorthin.

### <a id="l-130.4"></a>L-130.4 — ZIEL.md: „Umgesetzt ist davon noch nichts“

**Gewicht: mittel.** ZIEL.md ist der Maßstab; dort steht das Hilfe-Menü als bloß *vorgemerkt*, während es im Quellstand des Zweigs umgesetzt, getestet und am Prüfstand gemessen ist. (gemessen)

- `ZIEL.md:119-122` *„**Vorgemerkt:** im Hilfe-Menü *Keyboard Shortcuts* und *Settings Reference* — eine HTML-Seite …“*, `:131` *„Umgesetzt ist davon noch nichts; die Reihenfolge entscheidet Gregor.“*
- Dagegen `Intern/BEFUNDE.md:243` *„offen — im Quellstand umgesetzt und am Prüfstand gemessen (02.11.2026)“*. ZIEL.md ist im Zweig nicht geändert (`git diff --stat 253a8a40 HEAD` nennt sie nicht).
- `perl tools/ziel-stand.pl` → *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* — das Werkzeug liest die Kriterien, nicht diesen Absatz.

**Vorschlag:** `:119` auf *„Umgesetzt im Zweig `hilfe_menue` ([A-5](Intern/BEFUNDE.md#a-5)), am Prüfstand gemessen, kommt mit dem ersten Paket 7.2.2“*; `:131` auf *„Von den Kandidaten ist noch nichts umgesetzt“*.

### <a id="l-130.5"></a>L-130.5 — Testplan Schritt 5: die Logzeile steht erst nach dem Beenden in der `eudora.log`

**Gewicht: mittel.** Wer die Datei bei laufendem Eudora öffnet, findet nichts und meldet „nicht bestanden“, obwohl alles stimmt. (gemessen, aus zwei Belegen)

- `Intern/TESTPLAN.md:456-458` *„In der `eudora.log` stehen je Wahl eine Zeile `Hilfe: Tastenkuerzel.html geoeffnet` bzw. `Hilfe: … fehlt` (Protokollbereich *Misc*, in deiner `Eudora.ini` eingeschaltet).“* — kein Wort davon, wann.
- `Intern/BEFUNDE.md:243` *„`eudora.log`: … — **erst nach dem Beenden** in der Datei, Eudora schreibt gepuffert“*; `tools/WERKZEUGE.md:155` *„Die Logzeilen … stehen **erst nach dem Beenden** in der `eudora.log` (gepuffert, gemessen)“*; `tools/pruefstand-faelle.txt:368` *„geprueft wird sie nach dem Beenden (A-5p-log)“*.
- Nebenbei: die Gegenprobe in Schritt 4 erzeugt eine Zeile `fehlt`, die Schritte 2 und 3 je eine `geoeffnet` — Schritt 5 sollte sagen, dass nach einem Durchgang **drei** (bzw. mit *Settings Reference* in der Gegenprobe vier) Zeilen zu erwarten sind.

**Vorschlag:** Schritt 5 an das Ende, nach *„Eudora beenden“*, mit der erwarteten Zahl der Zeilen.

### <a id="l-130.6"></a>L-130.6 — WEITERMACHEN nennt den gemergten Doku-Zweig „laufend“; ZWEIGE sagt bei `paket_7_2_1_131` „nicht auf GitHub“

**Gewicht: Kleinkram, aber dieselbe Klasse zum sechsten Mal** ([L-128.2](LEKTOR-128.md#l-128.2): Schranke gegen „läuft/PR folgt“ nach dem Merge). (gemessen)

- `Intern/WEITERMACHEN.md:3` *„#199 bis #204 sind gemergt … Laufend: Zweig `hilfe_menue` (…); Zweig `release_7_2_1_131_doku` (diese Nachträge).“* — `253a8a40` ist *„Merge pull request #205 from HansWurst81675/release_7_2_1_131_doku“*.
- `tools/ZWEIGE.md:212` (`paket_7_2_1_131`) *„Nicht auf GitHub, bis Gregor lokal getestet hat.“* — getestet und als `v7.2.1.131` veröffentlicht; die Zeile `e122_imap_datum` (`:204`) zeigt, wie der Nachtrag aussieht (*„gemergt als #202“*). Die Zeile `release_7_2_1_131_doku` (`:210`) hat keinen Stand.

**Vorschlag:** In einem Zug mit [L-130.3](#l-130.3); die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) sollte auch „Laufend: Zweig `x`“ gegen `git branch -r --merged origin/main` halten.

### <a id="l-130.7"></a>L-130.7 — FUNKTIONEN: die zwei neuen Help-Einträge tragen die Marke „Vorlage“

**Gewicht: Kleinkram.** (gemessen)

- `Doku/FUNKTIONEN.md:263-264` *Keyboard Shortcuts* und *Settings Reference*, letzte Spalte *„Vorlage“*.
- Die Legende `:15` *„Vorlage \| aus der Ressourcendatei … oder dem Code gelesen — so **steht** es im Programm; in dieser Portierung hat es noch niemand eigens angeklickt“*. Beides passt nicht: die Einträge kommen nicht aus QUALCOMMs Fassung, sondern aus dieser Portierung, und sie sind am Prüfstand gemessen (`BEFUNDE.md:243`, Menü und beide Seiten im Browser).
- Die Legende kennt nur *Vorlage* und **bestätigt** (`:14-16`); für „am Prüfstand gemessen, von Gregor noch nicht gesehen“ fehlt eine Marke.

**Vorschlag:** Marke *„neu in 7.2.2, am Prüfstand gemessen“* (oder eine dritte Legendenzeile *gemessen*); in `:18` steht schon, dass Änderungen „an der Zeile dabei“ stehen.

### <a id="l-130.8"></a>L-130.8 — Der Seitenkopf nennt einen Commit, der nicht die Quelle der Seite ist

**Gewicht: Kleinkram (Werkzeug).** (gemessen)

- `C:\Temp\EHILFE\Hilfe\Einstellungen.html`, Zeile 26: *„Stand der Vorlage: 02.11.2026 (Commit 39958105)“*. Die Seite hat 33 Tabellen mit der Spalte *Abschnitt*; `git show 39958105:Doku/FUNKTIONEN.md \| grep -c '\| Abschnitt \|'` → **1**, die heutige Datei → 33. Die Seite ist aus der uncommitteten Fassung entstanden (Dateizeit 14:42, Commit `54b7b5fa` 14:45).
- `tools/hilfe-html.pl:120-131` (`stand_der_quelle`) nimmt `git log -1 -- Doku/FUNKTIONEN.md` und prüft nicht, ob die Datei geändert ist; `tools/paket-bauen.ps1` prüft vor Schritt 5b ebenfalls nicht (`grep porcelain` kein Treffer). Der Bau selbst markiert einen solchen Stand mit `*` (`7.2.1.131+a2f29b69*`, `tools/TESTLAEUFE.md:764`).

**Vorschlag:** Bei geänderter Quelle *„(Commit 39958105, geändert)“* oder `*` in den Kopf, wie beim Bau.

## Bestand außerhalb des Schwerpunkts

Die 66 MD-Dateien hat [LEKTOR-128](LEKTOR-128.md#lektor-128) zuletzt voll gelesen, [LEKTOR-129](LEKTOR-129.md#lektor-129) den Diff danach. Seit `253a8a40` hat der Zweig außer den A-5-Stellen nur `tools/ZWEIGE.md` (eine Zeile), `tools/TESTLAEUFE.md` (Startzeilen) und `Doku/FUNKTIONEN.md` (Spalte *Abschnitt*) geändert; die Stand-Köpfe von README, CHANGELOG, PAKETE, ZIEL und TESTPLAN nennen weiter richtig `v7.2.1.131` als zuletzt veröffentlicht (`perl tools/pruefe-release-buchfuehrung.pl` grün; die Lücke dieses Werkzeugs steht bei [L-129.1](LEKTOR-129.md#l-129.1)). Die *Zur Kenntnis*-Liste von `doku-pruefen.pl` (unten) ist dieselbe wie in [LEKTOR-129](LEKTOR-129.md#lektor-129); dort genannte Dateien sind Archive oder Anleitungen ohne Stand-Aussage.

Persönliche Angaben: im heutigen Stand der 66 Dateien keine (`git grep -il` nach der Angabe aus [L-130.1](#l-130.1) → nur ein Treffer in `tools/rfc2231-pruefen.pl`, ohne Bezug). In der Geschichte siehe [L-130.1](#l-130.1).

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): 52 geprüfte Dateien, 176 Kennungen, *„Kein Widerspruch gefunden.“*; *Zur Kenntnis* u. a. `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` (höchste Fassung 7.2.1.128), `Doku/FAQ.md` (7.2.1.130). [L-130.2](#l-130.2) bis [L-130.8](#l-130.8) sieht es nicht.

`perl tools/offene-befunde.pl` (gemessen): *„52 offene Befunde, in beiden Listen gleich.“* — eins mehr als in [LEKTOR-129](LEKTOR-129.md#lektor-129) ([A-5](../Intern/BEFUNDE.md#a-5)).

`perl tools/pruefe-regressionstest.pl` (gemessen): Kritische *„mit Testfall im Pruefstand 62 von 70“*, *„OHNE jede Pruefung 6 <- Rueckstand: [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39)“*; *„Kein neues "behoben" ohne Regressionstest.“* [A-5](../Intern/BEFUNDE.md#a-5) ist *unkritisch* und nicht behoben, steht also nicht darunter.

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* — trotz [L-130.4](#l-130.4).

`perl tools/hilfe-html.pl --selbsttest` (gemessen): *„31 ok, 0 FEHLER“*.

## Was nur Gregor entscheiden kann

1. **Wie kommt `hilfe_menue` nach `main`** ([L-130.1](#l-130.1): in der Geschichte des Zweigs liegt eine Datei mit einer persönlichen Angabe, die nicht ins Repo soll)? Vorschlag: als **ein** Commit, wie beim Release 7.2.1.131; danach die Zweige auf GitHub löschen, die die Datei tragen (`hilfe_menue`, `paket_7_2_1_131` und drei `wt/…`-Zweige).
2. **Welche Nummer bekommt das erste Paket 7.2.2** ([L-130.2](#l-130.2): Testplan und Befund sagen 7.2.2.0, die bisherige Regel und die Schranke erwarten die laufende Buildnummer)? Also `7.2.2.132` (bzw. die nächste laufende Nummer) wie bei 7.2.1 — oder `7.2.2.0`, dann muss `pruefe-fassungsnummer.pl` die ersten drei Stellen mitvergleichen.

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Gegengelesen: `git diff 83093a38..origin/hilfe_menue` (3 Commits bis `1aa731fc`, 17 Dateien, 487 Zeilen hinzu, 212 weg; nach `tools/arbeitsbaum-angleichen.sh`), dazu die neu erzeugten Seiten `C:\Temp\EHILFE\Hilfe\Tastenkuerzel.html` und `Einstellungen.html` (15:47, nur gelesen). Keine neue Runde, nichts gestartet. (gemessen)

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-130.1](#l-130.1) persönliche Angabe in der Geschichte | **wird über einen neuen Zweig gelöst** | laut Hauptagent als `hilfe_menue_7_2_2` mit einem Commit, Name von Gregor bestätigt. Im Stand `1aa731fc` noch nicht nachprüfbar: `tools/ZWEIGE.md` auf `hilfe_menue` kennt `hilfe_menue_7_2_2` nicht (`grep` kein Treffer); `d9ae24c8` steckt weiter in `origin/hilfe_menue`. Erst am neuen Zweig messen: `git log origin/main..origin/hilfe_menue_7_2_2` ein Commit, die alte Datei nicht in dessen Baum |
| [L-130.2](#l-130.2) „7.2.2.0“ | **erledigt** | Gregor am 02.11.2026: *„7.2.2.132, ja“*. `Intern/TESTPLAN.md:429` *„Mit 7.2.2.132“*, `:444` *„Fassung 7.2.2.132“*; `Intern/BEFUNDE.md:243` *„kommt mit 7.2.2.132“*; `CHANGELOG.md:71`, `Intern/WEITERMACHEN.md:120` *„am Paket 7.2.2.132“*; `ZIEL.md:119` *„das erste Paket 7.2.2 heißt **7.2.2.132** — die letzte Stelle zählt weiter wie bei 7.2.1“*. `git grep '7\.2\.2\.0'` außerhalb `Befunde/`: nur noch `Arbeitsweise/entscheidung-7-2-2-umfang.md:15` *„dann 7.2.2.0 mit dem Hilfe-Menü“* (Gedächtnisspiegel, nicht im Prüfumfang) und mein eigener Satz in `Intern/LEKTORAT.md` |
| [L-130.3](#l-130.3) 7.2.2-Block im Release-Abschnitt | **erledigt** | `CHANGELOG.md:114` eigene Überschrift *„## Im Quellstand, noch in keinem Paket“*, das Release folgt ab `:123` |
| [L-130.4](#l-130.4) ZIEL.md „umgesetzt ist davon noch nichts“ | **erledigt** | `ZIEL.md:122` *„**Umgesetzt im Zweig `hilfe_menue`, am Prüfstand gemessen** (kommt mit 7.2.2.132, [A-5](../Intern/BEFUNDE.md#a-5))“*, `:135` *„Von den Kandidaten ist noch nichts umgesetzt“* |
| [L-130.5](#l-130.5) Logzeile erst nach dem Beenden | **erledigt** | `Intern/TESTPLAN.md:456` *„**Erst nach dem Beenden** von Eudora (vorher steht nichts in der Datei, Eudora schreibt das Protokoll gepuffert)“*, mit den vier erwarteten Zeilen |
| [L-130.6](#l-130.6) „laufend“ nach dem Merge, „nicht auf GitHub“ | **erledigt, Schranke offen** | `Intern/WEITERMACHEN.md:3` *„#205 (`release_7_2_1_131_doku`, …) ist gemergt“*; `tools/ZWEIGE.md:210` *„**Stand:** gemergt als #205“*, `:212` *„**Stand:** von Gregor lokal getestet …“*. Die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) fehlt weiter |
| [L-130.7](#l-130.7) Marke „Vorlage“ | **erledigt** | `Doku/FUNKTIONEN.md:16` neue Legendenzeile *„am Prüfstand gemessen \| neu in dieser Portierung; am laufenden Programm auf dem Prüfstand gemessen, von Gregor noch nicht gesehen“*; `:264-265` tragen sie |
| [L-130.8](#l-130.8) Commit im Seitenkopf | **erledigt** | `tools/hilfe-html.pl:170-182` (`stand_der_quelle`): bei `git status --porcelain` mit Inhalt *„(nicht committet)“* statt des Commits. Neue Seite: *„Stand der Vorlage: 02.11.2026 (Commit 1aa731fc)“* — `1aa731fc` ist der Commit, der `Doku/FUNKTIONEN.md` zuletzt geändert hat |

**Die neuen Seiten** (gemessen):

- **Keine internen Verweise:** jeder `href` zeigt auf `…/blob/v7.2.1.131/Doku/` (`FUNKTIONEN.md`, `FAQ.md`, `ANWENDER.md`); kein Link auf `Intern/`, `Befunde/`, `Arbeitsweise/`, `tools/` oder `Eudora71/`. Im Text steht noch einmal das Wort *TESTPLAN* (`Einstellungen.html`, Zeile zu [`E-87`](../Intern/BEFUNDE.md#e-87): *„**bestätigt** (TESTPLAN, *Weiterleiten behält die HTML-Formatierung* …)“*) und Befundkennungen als bloßer Text (*[E-139](../Intern/BEFUNDE.md#e-139)*, *[E-80](../Intern/BEFUNDE.md#e-80)* u. a.) — ohne Link, für Anwender nur unverständlich, kein Verweis ins Innere.
- **Keine Namen:** `grep -ci gregor` → 0 in beiden Dateien; die Ersetzungen in `tools/hilfe-html.pl` (`@NEUTRAL`) greifen, z. B. *„die Protokolle der Testläufe tragen die Spurmarken“*.
- **Kopf:** *„Eudora 7.2.1.131 · Help → Settings Reference“* — die Seiten am Prüfstand sind mit dem heutigen `VERSION` erzeugt; im Paket steht dort die Paketnummer.

### <a id="l-130.9"></a>L-130.9 — Neu: die Verweise der Seiten zeigen auf eine Marke, die es bei Gregors Test noch nicht gibt

**Gewicht: Kleinkram.** (gemessen)

- `tools/paket-bauen.ps1:646-649` ruft den Erzeuger mit `--fassung` aus `VERSION` auf; `tools/hilfe-html.pl:105` setzt dann alle Verweise auf `blob/v<Fassung>/`. Im Paket 7.2.2.132 zeigen also alle Verweise der beiden Seiten (heute 60 in `Tastenkuerzel.html`, 23 in `Einstellungen.html`) auf `blob/v7.2.2.132/`.
- `git ls-remote origin refs/tags/v7.2.2.132` → leer. Die Marke entsteht erst beim Veröffentlichen, und das erst nach Gregors Test ([Release erst nach Gregors Test](../Arbeitsweise/release-erst-nach-gregors-test.md)). Bei seinem Test führt jeder Klick auf einen Verweis zu einer Fehlerseite von GitHub; bei einem Paket, das nie veröffentlicht wird, bleibt es so.
- `Intern/TESTPLAN.md:441-448` (Schritte 2 und 3) sagt dazu nichts.

**Vorschlag:** Im Testplan einen Satz: *„Die Verweise auf der Seite führen erst nach der Veröffentlichung zum Ziel.“* Oder der Erzeuger nimmt `blob/v<N>/` nur, wenn die Marke auf `origin` schon steht, sonst `main`.

Ergebnis: [L-130.2](#l-130.2) bis [L-130.8](#l-130.8) erledigt; [L-130.1](#l-130.1) wird über `hilfe_menue_7_2_2` gelöst und ist dort nachzumessen; neu [L-130.9](#l-130.9) (Kleinkram). Persönliche Angaben im Diff `83093a38..1aa731fc` und in den drei Commit-Nachrichten: keine (gelesen).

## <a id="nachtrag-2-02-11-2026"></a>Nachtrag 2, 02.11.2026

Gegengelesen `git diff 949bee0e..origin/hilfe_menue` (3 Commits bis `00fcdb4d`, 12 Dateien) und die neu erzeugten Seiten unter `C:\Temp\EHILFE\Hilfe\` (16:00, nur gelesen). Ergebnis (gemessen): [L-130.9](#l-130.9) ist **erledigt**. In den beiden Seiten stehen 83 Verweise (60 in `Tastenkuerzel.html`, 23 in `Einstellungen.html`), alle auf `blob/1aa731fcda64…/Doku/`; `grep -c 'blob/v'` → 0, `grep -ci gregor` → 0. Der Seitenkopf nennt *„(Commit 1aa731fc)“*. `tools/hilfe-html.pl:186` setzt die Basis auf den Commit der Quelle, `--selbsttest` → *„49 ok, 0 FEHLER“*. Die Beschreibungen passen dazu: `Intern/BEFUNDE.md:243` (*„alle 83 Verweise auf `blob/1aa731fc…/`, keiner auf `blob/v7…`“*), `tools/WERKZEUGE.md:58` (49 Fälle), der Kommentar in `tools/paket-bauen.ps1` und `CHANGELOG.md` (*„verlinkt öffentliche Doku auf den Commit der Quelle“*). `Arbeitsweise/entscheidung-7-2-2-umfang.md:15` nennt jetzt 7.2.2.132 statt 7.2.2.0. **Ein Hinweis, nur eine Vermutung:** Die Verweise im Paket hängen jetzt daran, dass der Commit, aus dem das Paket gebaut wird, auf GitHub erreichbar bleibt. `1aa731fc` liegt nur auf `origin/hilfe_menue` und zwei `wt/…`-Zweigen (`git branch -r --contains`). Wird `hilfe_menue` nach dem Ein-Commit-Merge gelöscht, wie für [L-130.1](#l-130.1) vorgeschlagen, wird der Commit unerreichbar. Ob GitHub `blob/<commit>/` dann weiter ausliefert, ist nicht gemessen. Das Paket 7.2.2.132 sollte daher von einem Commit gebaut werden, der auf `main` liegt oder dessen Zweig stehen bleibt.
