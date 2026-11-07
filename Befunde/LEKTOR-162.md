# <a id="lektor-162"></a>LEKTOR-162 (07.11.2026) — Zweig `paket_7_2_2_137` nach c24d6d4a: Anleitung „Ein eigenes Release-ZIP bauen“, Nachträge E-240/E-241/E-248, Testergebnis 7.2.2.137

**Umfang:** `git diff 9f7d69ce..HEAD -- '*.md'` (28 Dateien), Schwerpunkt `Doku/BAUEN.md` (neuer Abschnitt), `README.md`, `Intern/TESTPLAN.md`, die Nachträge zu [E-240](../Intern/BEFUNDE.md#e-240) (Druckvorschau ohne Rückmeldung), [E-241](../Intern/BEFUNDE.md#e-241) (Bild ↑/↓ in der Vorschau) und [E-248](../Intern/BEFUNDE.md#e-248) (Release-ZIP aus einem frischen Klon). Die Anleitung habe ich gegen `tools/paket-bauen.ps1`, `tools/bauen.ps1`, `tools/paket-pruefen.ps1`, `tools/hooks-einrichten.sh`, `tools/pruefe-branch.pl` und den Repo-Bestand gehalten. Gebaut und gestartet habe ich nichts. Den Versionssprung 7.2.2.138 (`a1bf7dc6`) habe ich mitgeprüft. Er kam während des Laufs auf `origin/paket_7_2_2_137`, siehe [L-162.8](#l-162.8).

**Urteil:** Die Anleitung ist in den Befehlen richtig: Schalternamen, Pfade, Anker und die Zahlen der Klonprobe stimmen (siehe unten). Für jemanden ohne Vorwissen fehlt der Weg zur **eigenen Fassungsnummer**: der Hook weist einen Commit auf `main` ab, und `bauen.ps1` weist eine ungesicherte Nummer ab ([L-162.4](#l-162.4)). **Datenschutz: kein Treffer.** **8 Funde.** **Nichts hält das ZIP 7.2.2.138 auf.** Den Testabschnitt für 7.2.2.138 hat der Versionssprung `a1bf7dc6` angelegt, und er prüft die Abhilfe richtig ([L-162.8](#l-162.8)). Vor dem PR: [L-162.1](#l-162.1) bis [L-162.4](#l-162.4).

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“*, 27 Hinweise *„nennt weder …“* (wie in [LEKTOR-161](LEKTOR-161.md#lektor-161)).
* **Datenschutz (gemessen):** `perl tools/pruefe-namen-gestaget.pl --commit <rev>` für alle sechs Commits ohne Merge in `9f7d69ce..HEAD`: jeweils *„kein Name aus der lokalen Liste (commit, 11 Muster)“*. Dazu habe ich die hinzugefügten MD-Zeilen von Hand nach Mailadressen, Postfach- und Ordnernamen, Betreffzeilen und Absendern durchgesehen (`grep` nach `@`, `postfach`, `ordner`, `betreff`, `absender`, `C:\Users`). Kein Treffer. Das Testergebnis `Intern/TESTPLAN.md:28` nennt nur *„Bildschirmfoto mit zwei Zielpostfächern“* und *„Kopf mit Absender, Datum, Betreff“*, keine Werte. `Arbeitsweise/CHRONIST-2026-11-07.md:69` und `:154` nennen den Vorfall mit Gregors Testordner, nicht den Inhalt.

## Funde

### <a id="l-162.1"></a>L-162.1 — Gregors Test an 7.2.2.137 bestätigt E-242 auch auf Papier; der Befund, README, CHANGELOG und WEITERMACHEN verlangen diesen Test noch

**Gewicht: mittel.** Gemessen am Text. **Vor dem PR.**

* `Intern/TESTPLAN.md:28` *„Schritt 3 **bestanden** (beide PDFs je drei Seiten mit „Printed for“ und „Page n of 3“, kein `file:///`“*.
* `Intern/BEFUNDE.md:409` ([E-242](../Intern/BEFUNDE.md#e-242), Druck zeigt den Pfad der Zwischendatei): *„**Was noch fehlt:** Gregors Test, auch der Druck auf Papier (oder *Microsoft Print to PDF*)“*. Ein Nachtrag mit dem Ergebnis fehlt.
* `README.md:239` *„der Druck auf Papier ist nicht gemessen“*.
* `CHANGELOG.md:36` und `Intern/WEITERMACHEN.md:112` übernehmen *„Gregors Test, auch der Druck auf Papier …“* als offenen Punkt.

**Soll:** In [E-242](../Intern/BEFUNDE.md#e-242) einen Nachtrag „Gregor an 7.2.2.137: Vorschau, Druck aus der Vorschau und *File → Print* bestanden (PDF)“ und „Was noch fehlt“ neu fassen; README `:239` berichtigen. Die Tabellen kommen dann von selbst nach.

### <a id="l-162.2"></a>L-162.2 — E-240: der neue Nachtrag steht in der Mitte, am Ende stehen weiter „nicht gemessen“ und „Was noch fehlt“ von vorher

**Gewicht: mittel.** Gemessen am Text. **Vor dem PR.**

* `Intern/BEFUNDE.md:411`, Mitte: *„**Nachtrag 07.11.2026 — an Gregors System gemessen, Schritt 4 des Tests an 7.2.2.137 nicht bestanden:** `E-240 Vorschau: zurueck nach 94 ms`, `E-242 Vorschaufenster da nach 36609 ms`“*.
* Dieselbe Zelle, am Ende: *„**Nicht gemessen:** die 38 s beim allerersten Aufruf (am Prüfstand nicht nachzustellen) und ob die Sanduhr dabei wirklich stehen bleibt. **Was noch fehlt:** Gregors Test am ersten Aufruf nach einem Neustart des Rechners“*. Beides ist durch den Nachtrag überholt.
* `CHANGELOG.md:38` und `Intern/WEITERMACHEN.md:114` zeigen deshalb *„Gregors Test am ersten Aufruf nach einem …“* als offenen Punkt.

Dieselbe Klasse wie [L-160.6](LEKTOR-160.md#l-160.6) und [L-161.4](LEKTOR-161.md#l-161.4).

**Soll:** Den alten Schluss mit „(überholt durch den Nachtrag vom 07.11.2026, Gregors Test)“ kennzeichnen. Als „Was noch fehlt“ ans Ende: „Gregors Test an 7.2.2.138, Schritt 4: bleibt die Sanduhr bis zum Vorschaufenster stehen?“

### <a id="l-162.3"></a>L-162.3 — E-248 hat keine Messmarke: die Tabellen sagen „nie gemessen“ und nennen als offen, was schon erledigt ist

**Gewicht: mittel.** Gemessen am Text. **Vor dem PR.**

* `Intern/BEFUNDE.md:403` ([E-248](../Intern/BEFUNDE.md#e-248)): *„**Klonprobe** (`git clone --branch paket_7_2_2_137` nach …): Bau 3,4 min, 0 Fehler“*. Die Zelle hat aber keine Zeile *„**Zuletzt gemessen: …**“*.
* `CHANGELOG.md` und `Intern/WEITERMACHEN.md`, Zeile [E-248](../Intern/BEFUNDE.md#e-248) in der Tabelle der offenen Befunde: *„**nie gemessen** | Schritt 8 nimmt die in Schritt 7 aus dem Redist-Ordner gelegten Dateien aus; das Plug-in kommt aus der Grundlage …“*. Das ist das **erste** „Was noch fehlt“. Laut Nachtrag ist es erledigt (*„behoben im Zweig `paket_7_2_2_137` und aus einem frischen Klon gemessen“*). Offen ist nur noch der Rest mit den fünf MIDL-Dateien.

**Soll:** In [E-248](../Intern/BEFUNDE.md#e-248) eine Marke „**Zuletzt gemessen: 07.11.2026 an 7.2.2.137** (Klonprobe)“ setzen. Das erste „Was noch fehlt“ als erledigt kennzeichnen oder umformulieren, damit der Tabellenauszug den MIDL-Rest zeigt.

### <a id="l-162.4"></a>L-162.4 — Anleitung: der Weg zur eigenen Fassungsnummer scheitert in einem frischen Klon am Hook, und die Reihenfolge stimmt nicht

**Gewicht: mittel.** Belegt am Quelltext, nicht gemessen. **Vor dem PR.** Das betrifft Gregors Forderung *„… ein paket selbst bauen und testen können, um es auf github zu veröffentlichen!“* unmittelbar.

* `Doku/BAUEN.md:252-254` *„**Eine eigene Fassungsnummer.** Wer veröffentlichen will, hebt vorher die Version und committet … — sonst trägt das ZIP dieselbe Nummer wie das letzte Release.“*
* Der Codeblock `:219-227` richtet in Zeile `:222` den Hook ein. Danach steht der Klon auf `main`. Der Hook ruft `pruefe-branch.pl` auf (`tools/hooks-einrichten.sh:57`), und das bricht auf `main` ab: `tools/pruefe-branch.pl:185-203` *„COMMIT ABGEBROCHEN - '$branch' nimmt keine direkten Commits“*. Die Meldung spricht von Gregor und von *„abgestimmten“* Zweignamen (`:189-194`). Ein Außenstehender kann damit nichts anfangen.
* Ohne Commit weist `bauen.ps1` die geänderte `VERSION` und `Version.h` ab (`tools/bauen.ps1:225-246`; ausgenommen sind nur `Eudora71/Bin/*`, `Build/*`, `Releases/*` und `TESTLAEUFE.md`).
* Die Nummer muss **vor** dem Bau gehoben werden, sie steht aber als vierter Punkt **nach** dem Codeblock. Wer der Reihenfolge folgt, baut erst und hat danach die MIDL-Dateien aus `:246-250` im Baum. Dann weist der zweite Bau ab.

**Soll:** Für Veröffentlichende einen eigenen Ablauf vor den Codeblock stellen: `git switch -c meine-fassung`, die Version heben (Verweis auf [Vor dem Bau: die Version heben](../Doku/BAUEN.md#vor-dem-bau-die-version-heben)), committen, dann bauen. Dazu ein Satz, dass der Hook auf `main` abweist und die Meldung zu „abgestimmten Zweignamen“ nur für dieses Projekt gilt.

### <a id="l-162.5"></a>L-162.5 — „jede ausführbare Datei wird aus dem eigenen Bau ersetzt“ stimmt nicht ganz

**Gewicht: gering.** Belegt am Quelltext.

* `Doku/BAUEN.md:241-243` *„**jede ausführbare Datei** darin wird aus dem eigenen Bau ersetzt (Schritt 8 …)“*.
* `tools/paket-bauen.ps1:735-737` und `:791`: Ausgenommen sind die drei Laufzeit-DLLs `mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll`. Sie kommen aus dem Redist-Ordner von Visual Studio (Schritt 7), was die Voraussetzungen in `:213-215` selbst sagen.
* Die Plug-ins `SMIME.dll`, `SpamHeaders.dll`, `SpamWatch.dll` und `EudoraUnicodeFix.dll` kommen aus `Eudora71\Bin\Release\Plugins`. Gebaut werden sie dort nicht, sie sind dort versioniert (`git ls-files`). So steht es auch in der neuen Tabellenzeile `:139`.

**Soll:** „wird aus `Eudora71\Bin\Release` genommen (eigener Bau und die dort versionierten Plug-ins); ausgenommen sind die drei Laufzeit-DLLs aus Schritt 7“.

### <a id="l-162.6"></a>L-162.6 — „Sonst nichts“: zwei Lücken in den Voraussetzungen und Schaltern

**Gewicht: gering.** Belegt.

* `Doku/BAUEN.md:217` *„Sonst nichts — alles Weitere liegt im Repo.“* Der Schritt *Veröffentlichen* (`:260`) braucht aber `gh`, also GitHub CLI mit Anmeldung, oder das Hochladen über die Weboberfläche. Beides steht nicht in den Voraussetzungen.
* Die Anleitung nennt drei Schranken-Schalter (`:229-238`). Die vierte Schranke in `tools/paket-bauen.ps1:113-120` (`-TrotzDatenverlust`, bei einem offenen Befund zu Datenverlust) fehlt. Bei der Klonprobe hat sie nicht gegriffen. Steht ein solcher Befund offen, weist sie ab. Die Meldung nennt den Schalter selbst (`:116`), deshalb ist das Gewicht gering.

**Soll:** Bei *Veröffentlichen* „mit GitHub CLI (`gh auth login`) oder über die Release-Seite im Browser“ ergänzen. Bei den Schaltern einen Satz zu `-TrotzDatenverlust` und dazu, wann er nötig wird.

### <a id="l-162.7"></a>L-162.7 — E-241: „zwei Vermutungen gemessen widerlegt“, widerlegt ist aber eine

**Gewicht: gering.** Gemessen am Text.

* `Intern/BEFUNDE.md:410` *„**Nachtrag 07.11.2026 — zwei Vermutungen gemessen widerlegt, Ursache weiter offen“***. Darunter: (1) widerlegt die Vermutung zur Durchreiche in `PreTranslateMessage`. (2) ist eine Messung, kein Widerlegen (*„die Vorschau läuft in einem **eigenen Thread**“*). (3) sagt selbst: *„kann diese Messung nicht unterscheiden“*.

**Soll:** „eine Vermutung widerlegt, eigener Thread der Vorschau gemessen“. So steht es schon in der Commit-Nachricht von `1051bfaf` (*„eigener Thread der Vorschau, Vermutungen widerlegt“*). Oder die zweite Vermutung beim Namen nennen.

### <a id="l-162.8"></a>L-162.8 — Stand-Aussagen nach dem Versionssprung 7.2.2.138 (`a1bf7dc6`): Testplan neu, vier Stellen noch auf 137

**Gewicht: mittel.** Gemessen am Text von `a1bf7dc6`. Er kam während dieses Laufs auf `origin/paket_7_2_2_137`, ich habe ihn mitgeprüft.

**Erledigt mit dem Sprung:** `Intern/TESTPLAN.md:3` *„**Stand:** Quellstand 7.2.2.138“*. Neu ist ein Abschnitt `test-7-2-2-138`. Schritt 2 sagt jetzt *„die Maus **ruhig über Eudora bewegen**“*, Schritt 3 prüft den zweiten Klick. Damit prüft der Testplan die Abhilfe, also nicht mehr „Maus nicht bewegen“. `CHANGELOG.md` und `Releases/PAKETE.md:189` haben Abschnitte für 7.2.2.138 (*„Nur übersetzt am 07.11.2026, noch nicht geschnürt“*). Der README-Verweis nennt *„seit 7.2.2.138, [E-248](../Intern/BEFUNDE.md#e-248)“*.

**Noch auf 137 bzw. vorgezogen:**

* `README.md:239-240` (in `a1bf7dc6` unverändert): *„im Testpaket 7.2.2.137 (nicht veröffentlicht)“*. Für [E-240](../Intern/BEFUNDE.md#e-240) ist das überholt: die Sanduhr von 137 hielt nicht, die Abhilfe ist erst in 138. Für [E-242](../Intern/BEFUNDE.md#e-242) siehe [L-162.1](#l-162.1).
* `Intern/WEITERMACHEN.md:16` *„**In Arbeit: Testpaket 7.2.2.137**“*. Der neue Satz in `Intern/AUFGABEN.md` nennt dagegen schon 7.2.2.138.
* `Intern/TESTPLAN.md:11` (Abschnitt 138): *„Das Test-ZIP `Eudora72-7.2.2.138-test-mit-smime-dlls.zip` liegt neben deinem letzten Testverzeichnis.“* `Releases/PAKETE.md:189` sagt *„noch nicht geschnürt“*. Das ist dieselbe Klasse wie [L-161.1](LEKTOR-161.md#l-161.1) und wird mit dem Schnüren richtig.
* `CHANGELOG.md:132` (7.2.2.138) übernimmt *„zwei Vermutungen widerlegt“* aus [E-241](../Intern/BEFUNDE.md#e-241), siehe [L-162.7](#l-162.7).
* Der Abschnitt `test-7-2-2-138` hat keinen freiwilligen Schritt für [E-241](../Intern/BEFUNDE.md#e-241) (Bild ↓ nach einem Mausklick in die Vorschauseite). Dort steht er als *„Was noch fehlt: Gregors Probe …“*. Gering: Er kann auch später drankommen.
* Historisch, also **richtig** auch nach dem Sprung: `Doku/BAUEN.md:204-207` (Klonprobe an `1051bfaf`, *„derselbe Dateibestand wie das Testpaket 7.2.2.137“*) und das Ergebnis `Intern/TESTPLAN.md:48` (in `a1bf7dc6`).

**Soll:** `README.md:240` auf „Abhilfe in 7.2.2.138 (nur übersetzt)“ bringen. `Intern/WEITERMACHEN.md:16` auf 7.2.2.138 umstellen. Der Rest kommt mit dem Schnüren. **Nichts davon hält das ZIP auf.**

## Was sich als richtig erwiesen hat (gemessen bzw. belegt)

* **Schalternamen (belegt):** `-Ziel`, `-Zip`, `-AusBauverzeichnis`, `-Bauart Release`, `-RollenSindGelaufen`, `-OhnePruefbericht`, `-AgentLaeuftAbsichtlich` stehen so im `param`-Block `tools/paket-bauen.ps1:49-74`. `-Grundlage` ebenso. `paket-pruefen.ps1 -Paket` steht in `tools/paket-pruefen.ps1:71-73`. `bauen.ps1` ohne Schalter baut Release (`tools/bauen.ps1:185` *„$Konfiguration = 'Release'“*).
* **Pfade (gemessen):** `tools/hooks-einrichten.sh`, `tools/bauen.ps1`, `tools/paket-pruefen.ps1` und `Releases/Eudora72-1.0.2-lauffaehig.zip` sind vorhanden. Die Grundlage ist die Vorgabe in `tools/paket-bauen.ps1:488`. Die Klon-URL ist gleich `git remote -v` (`origin`). Die Plug-ins der Tabellenzeile `Doku/BAUEN.md:139` liegen versioniert unter `Eudora71/Bin/Release/Plugins` (`git ls-files`: drei QUALCOMM-DLLs, `EudoraUnicodeFix.dll` mit LIESMICH und LIZENZ). Ein schon vorhandenes Zielverzeichnis wird vorher gelöscht (`tools/paket-bauen.ps1:494`). Ein zweiter Lauf scheitert also nicht daran.
* **Perl aus der PowerShell (belegt):** `paket-bauen.ps1:91-97` sucht Perl auch unter `C:\Program Files\Git\usr\bin\perl.exe`. Damit stimmt *„Git für Windows (bringt `sh` und Perl mit)“* (`Doku/BAUEN.md:216`), obwohl Perl nicht im Suchpfad der PowerShell liegt.
* **Anker (belegt nach der GitHub-Regel):** `README.md:50` → `Doku/BAUEN.md#ein-eigenes-release-zip-bauen--aus-einem-frischen-klon`. Der Gedankenstrich fällt weg, zwei Leerzeichen werden zwei Bindestriche. Dasselbe gilt für den Verweis aus [E-248](../Intern/BEFUNDE.md#e-248). `#vor-dem-bau-die-version-heben` und `#den-eigenen-bau-starten` passen zu den Überschriften `:65` und `:187`.
* **Klonprobe (gemessen am Text):** Die Zahlen in `Doku/BAUEN.md:204-207` und `:243-244` (3,4 min, 0,8 min, *„6 ersetzt, 33 schon gleich, keine Debug-Laufzeit“*, *„keine Fehler“*) sind dieselben wie im Nachtrag zu [E-248](../Intern/BEFUNDE.md#e-248) (`Intern/BEFUNDE.md:403`). Die abweisende Meldung *„KEIN PAKET, solange eine Rolle ueberfaellig ist“* ist an beiden Stellen gleich zitiert. `Doku/BAUEN.md:208-209` sagt ehrlich, dass der Hook in der Klonprobe aus der Git Bash eingerichtet wurde, nicht mit der PowerShell-Zeile `:222`.
* **MIDL-Rest (belegt):** `tools/bauen.ps1:225-246` nimmt `Eudora71/Eudora/*.c` nicht aus. Damit stimmt die Warnung in `Doku/BAUEN.md:246-251` samt dem `git checkout`-Befehl.
* **Aus [LEKTOR-161](LEKTOR-161.md#lektor-161):** [L-161.1](LEKTOR-161.md#l-161.1) (Stand „geschnürt“) ist erledigt (`README.md:239-240`, `Releases/PAKETE.md`, `Intern/AUFGABEN.md:9`). [L-161.3](LEKTOR-161.md#l-161.3) (ruhige Maus) ist erledigt (`Intern/TESTPLAN.md:24`).

## Was nur Gregor entscheiden kann

Nichts Neues aus dieser Runde.
