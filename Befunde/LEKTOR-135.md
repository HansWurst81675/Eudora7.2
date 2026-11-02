# <a id="lektor-135"></a>LEKTOR-135 — Bestand nach E-203/E-204 (Persönlichkeit und Kennwort), Zweig e203_e204_persona_kennwort nach 78b47ebe (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-134](LEKTOR-134.md#lektor-134).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102n`, abgezweigt von `origin/e203_e204_persona_kennwort`, Stand `78b47ebe` (*„[PRUEFER-88](PRUEFER-88.md#pruefer-88) K1-K7: Positivproben [E-203](../Intern/BEFUNDE.md#e-203), schaerfere Tests, Spurzeile, [E-210](../Intern/BEFUNDE.md#e-210), [E-211](../Intern/BEFUNDE.md#e-211), startzeilen-sammeln“*); `git rev-list HEAD..origin/e203_e204_persona_kennwort` → 0 (gemessen).
Umfang: Bestand der MD-Dateien außerhalb von `Arbeitsweise/` und `Befunde/`. `git log ee7b5400..HEAD` enthält die Commits von #209 (`e194_e196_speichern_unter`) und #210 (`messungen_vor_7_2_2_132`), beide auf `main` und dort von [LEKTOR-133](LEKTOR-133.md#lektor-133) und [LEKTOR-134](LEKTOR-134.md#lektor-134) geprüft. Eigen sind die sechs Commits `origin/main..HEAD` (gemessen): `f96f8797` (Zweig eingetragen, `startzeilen-sammeln.pl`), `47093e2f` (Behebung [E-203](../Intern/BEFUNDE.md#e-203)/[E-204](../Intern/BEFUNDE.md#e-204)), `21029ad6` (Prüfstandssperre übernommen), `4182961e` ([PRÜFER-88](PRUEFER-88.md#pruefer-88)), `2b3a529d` (Merge von `main` nach #210), `78b47ebe` (PRÜFER-88 eingearbeitet, neu [E-210](../Intern/BEFUNDE.md#e-210), [E-211](../Intern/BEFUNDE.md#e-211)). Nichts gebaut, nichts gestartet, keine Prüfstände angefasst; Quelltext, Messskripte, `pruefstand-buch.tsv`, `pruefstand-ergebnis.txt` und `TESTLAEUFE.md` nur gelesen.

## Kurz

Die vier Befundtexte stimmen in der Sache mit Quelle und Messung. [E-204](../Intern/BEFUNDE.md#e-204) (nach dem Löschen einer Persönlichkeit erbt eine gleichnamige neue ihr Kennwort und schickt es ungefragt ab) ist am alten Bau rot und am neuen grün, mit Positivprobe und Spurzeile; die Stufe *kritisch* passt zur Legende („Sicherheit“). [E-203](../Intern/BEFUNDE.md#e-203) (*Change Password* schaltet nach der Fehlermeldung nicht zurück) ist mit `E-203p/v/w` im selben Start gemessen. [E-210](../Intern/BEFUNDE.md#e-210) (zu langes POP-Konto läuft über den Stapel) und [E-211](../Intern/BEFUNDE.md#e-211) (neue Nachricht scheitert, Persönlichkeit bleibt umgeschaltet) sind ehrlich als „nur am Quelltext“ geführt. Der Merge mit `main` hat nichts verloren. **Nicht in Ordnung:** Die FAQ nennt das gewöhnliche Löschen einer Persönlichkeit „unbedenklich“, aber genau dieser Weg ist [E-204](../Intern/BEFUNDE.md#e-204). [E-39](../Intern/BEFUNDE.md#e-39) (gelöschte „aktuelle“ Persönlichkeit hinterlässt einen INI-Rest) sagt noch, der Prüfstand sehe den Weg vollständig; seit `E-39p` zu `E-203p` wurde, misst ihn kein Fall mehr. Der Satz „durchgesehen ist nur *Change Password*“ unterschlägt die vollständige Durchsicht aus [PRÜFER-85](PRUEFER-85.md#pruefer-85). WERKZEUGE kennt die übernommene Prüfstandssperre nicht. Zehn Funde, keiner am Programmcode.

## Funde aus LEKTOR-134 — heutiger Stand

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-134.1](LEKTOR-134.md#l-134.1) bis [L-134.8](LEKTOR-134.md#l-134.8) | **erledigt** (Nachtrag 1 von [LEKTOR-134](LEKTOR-134.md#lektor-134)), mit `main` unverändert hereingekommen | `git diff origin/main HEAD -- Doku/FAQ.md Intern/TESTPLAN.md Releases/` → leer |
| [L-134.9](LEKTOR-134.md#l-134.9) Konflikte zwischen `messungen_…` und `e194_…` | **erledigt** | beide gemergt (#209 `9e58799c`, #210 `0341c5fe`); Stufentabelle `BEFUNDE.md:156-162` erzeugt, `offene-befunde.pl` *„57 offene Befunde, in beiden Listen gleich.“* |
| [L-134.10](LEKTOR-134.md#l-134.10) halb ersetzter Bereich, Repo-Pfad übrig | **offen** | `BEFUNDE.md:435` *„jedes Paket in `<Gregors Testverzeichnis des Pakets 1.0.110>` bis `-1.0.122-release` liefert 121 Wurzeln aus“*; `:2359-2361` drei Zeilen mit dem Repo-Pfad unter Gregors Benutzerverzeichnis (`grep -c` → 3, auf `main` ebenso 3) |
| [L-134.11](LEKTOR-134.md#l-134.11) Liste zu [E-176](../Intern/BEFUNDE.md#e-176) ohne den offenen Test | **offen** | `WEITERMACHEN.md:98` *„die Messung unter Page-Heap. **Was es zum Messen braucht:** …“* — der echte Test für `CSummary`/`CMessageFrame` fehlt weiter |
| [L-134.12](LEKTOR-134.md#l-134.12) FAQ-Logzeile ohne Bedingung *Misc* | **offen** | `Doku/FAQ.md:213` *„Ab 7.2.1.131 steht in der `eudora.log`, warum es fehlt“*; `grep -c -E 'Misc\|0x8000' Doku/FAQ.md` → 0 |
| [L-134.13](LEKTOR-134.md#l-134.13) doppelte Startzeilen | **offen, gewachsen** | `grep '^\| 20' tools/TESTLAEUFE.md \| sort \| uniq -d \| wc -l`: `origin/main` 34, `4182961e` 0, Merge `2b3a529d` 61, `78b47ebe` 58 — alle vom 02.11. `startzeilen-sammeln.pl` legt selbst keine gleichen Zeilen an (`:53` *„next if $da{$z}“*), die Merges schon |
| [L-131.8](LEKTOR-131.md#l-131.8) Berichtszahl | **stimmt mit diesem Bericht** | `README.md:98` *„(219 LEKTOR- und PRÜFER-Berichte …)“*; im Verzeichnis 218, mit diesem 219 |
| [L-130.1](LEKTOR-130.md#l-130.1) persönliche Angabe in alten Zweigen | **unverändert** | `git branch -r --contains d9ae24c8` → `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; dieser Zweig ist frei davon |
| [L-129.1](LEKTOR-129.md#l-129.1) Schranke „zuletzt veröffentlicht“ | **offen** | `grep -c 'zuletzt ver' tools/pruefe-release-buchfuehrung.pl` → 0 |
| [L-128.2](LEKTOR-128.md#l-128.2) Schranke gegen „läuft“ nach dem Merge | **offen**, zum elften Mal aufgetreten ([L-135.5](#l-135.5)) | `grep -l -E 'Laufend: Zweig\|PR folgt' tools/*.pl` → kein Treffer |
| [L-128.3](LEKTOR-128.md#l-128.3) Entwurfskopf in der Notizdatei | **offen** | `tools/release-veroeffentlichen.ps1:128` *„if ($text -match 'noch nicht best')“* weiter nur am CHANGELOG |
| [L-126.5](LEKTOR-126.md#l-126.5) Starts ohne Titelzeile | **teilweise** | vom 02.11. 161 verschiedene Zeilen, 32 ohne `[Eudora`; von den 40 neuen Zeilen dieses Zweigs 11 ohne, darunter eine eigene (`18:42:19 C:\Temp\E204` *„Hauptfenster 9046020 - Eudora  Schliesszeit 1 s.“*) |

## Die Befundtexte gegen Quelle und Messung

| Aussage | Stelle | Gegen (gemessen, wo nicht anders gesagt) |
|---|---|---|
| [E-204](../Intern/BEFUNDE.md#e-204) vorher `pass=alt` ohne Frage, nachher `pass=neu` mit Frage | `BEFUNDE.md:405`; `CHANGELOG.md:123`; `README.md:165` | `pruefstand-buch.tsv:60-61` *„E-204p ok 2026-11-02 19:23:28 … 7.2.1.131+2b3a529d* … rueckfrage=1 user=e204neu pass=neu lebt=1“*, `E-204w … PROBE ok`; `pruefstand-ergebnis.txt` *„nur=[E-204](../Intern/BEFUNDE.md#e-204) … bestanden=2“*. Der alte Wert `pass=alt` steht nur im Befundtext, der Lauf am alten Bau ist belegt durch drei Startzeilen `C:\Temp\E204-alt` (18:20:42, 18:22:53, 18:45:12, Bau `f31dbff9`), zwei davon *„musste abgeschossen werden“* — passt zum Absturz beim Beenden im Vermerk. Trifft |
| [E-204](../Intern/BEFUNDE.md#e-204) Quelltextstellen | `BEFUNDE.md:405` | `persona.cpp:1137` *„m_Passwords[m_Current] = POPPassword;“*, `:1183` *„if(m_Passwords.Lookup(strPersona, POPPassword) == 0)“*, `:596-619` Block mit `listVergessen` und `CompareNoCase` hinter `SetCurrent( NULL )` (`:593`), `POPSession.cpp:2853` *„if (::POPPassword.IsEmpty())“*, `ModifyAcctDlgs.cpp:334` `ClearPasswordFor` — alle treffen |
| [E-204](../Intern/BEFUNDE.md#e-204) Stufe *kritisch* | `BEFUNDE.md:405` *„Sicherheit: ein Kennwort ging ungefragt an ein anderes Konto; heraufgestuft am 02.11.2026 nach der Messung“* | Legende `BEFUNDE.md:146` nennt für *kritisch* ausdrücklich *„Sicherheit“*; auf `main` stand *„wichtig (*kritisch* — Sicherheit —, falls das Senden des alten Kennworts gemessen wird)“* — die Bedingung ist erfüllt. Stufentabelle: *kritisch* offen 9 (`main` 8), trifft |
| [E-203](../Intern/BEFUNDE.md#e-203) `E-203p/v/w` im selben Start | `BEFUNDE.md:406` *„3 von 3 bestanden“* | `pruefstand-buch.tsv:57-59`, alle drei *„2026-11-02 19:22:54 C:\Temp\E203 … 2b3a529d*“*; `pruefstand-faelle.txt:405-411` alle auf `C:\Temp\E203` — [PRÜFER-88](PRUEFER-88.md#pruefer-88) K1 erledigt |
| [E-203](../Intern/BEFUNDE.md#e-203) Quelltextstellen | `BEFUNDE.md:406` | `password.cpp:451-452` trifft; Behebung *„(`password.cpp:463-476`)“* und *„die vier Ausgänge“* sind seit [E-210](../Intern/BEFUNDE.md#e-210) überholt ([L-135.6](#l-135.6)) |
| [E-210](../Intern/BEFUNDE.md#e-210) Quelltextstellen | `BEFUNDE.md:401` | `password.cpp:430` *„char	Username[128];“*, `:474` *„if (strlen(POPAccount) >= sizeof(Username))“*, `:481` *„strcpy(Username, POPAccount);“*, `rs.cpp:48` *„const int INI_NORMAL_BUF_SIZE = 512;“*, `guiutils.cpp:943`/`:949` `char buf[1024]`/`_vsnprintf` — treffen; `EudoraRes.rc:9158` → heute `:9160` ([L-135.6](#l-135.6)). „ab 128 Zeichen“ stimmt: 128 Zeichen plus Null sind 129 Byte |
| [E-211](../Intern/BEFUNDE.md#e-211) Quelltextstellen | `BEFUNDE.md:400` *„`compmsgd.cpp:2260-2270`“* | `compmsgd.cpp:2267` *„g_Personalities.SetCurrent( csCurPersona );“* unter `#ifdef COMMERCIAL`, `:2269` *„return (NewCompDoc);	// error creating document“* — trifft |
| [E-210](../Intern/BEFUNDE.md#e-210)/[E-211](../Intern/BEFUNDE.md#e-211) „nur am Quelltext“ | `BEFUNDE.md:400-401`, `CHANGELOG.md:30-31` *„(Quelltext)“*, `:125-126` | trifft; kein Prüfstandsfall, keine Startzeile dazu (`grep -c 'E210\|E211' tools/pruefstand-faelle.txt` → 0) |
| Tests 389/389 | `BEFUNDE.md:400-406`, `CHANGELOG.md:128` | belegt durch Commit `78b47ebe` und die Befundtexte, nicht nachgefahren (nichts gestartet) |
| [E-39](../Intern/BEFUNDE.md#e-39) „kein *bekannter* Weg“ | `BEFUNDE.md:460`, `:406`; `pruefstand-faelle.txt:402-404`; `tools/messen-e39.ps1:37-38` | Einschränkung „bekannt“ trifft; „durchgesehen ist nur *Change Password*“ nicht ([L-135.3](#l-135.3)) |
| Merge mit `main` ohne Verlust | `git diff origin/main HEAD` | entfernte Zeilen gegen `main`: CHANGELOG 2, WEITERMACHEN 3 (die alten Zeilen zu [E-203](../Intern/BEFUNDE.md#e-203)/[E-204](../Intern/BEFUNDE.md#e-204) und Zeile 3), BEFUNDE 6 (drei Stufenzeilen, [E-39](../Intern/BEFUNDE.md#e-39), [E-203](../Intern/BEFUNDE.md#e-203), [E-204](../Intern/BEFUNDE.md#e-204) — alle fortgeschrieben), WERKZEUGE 2 (fortgeschrieben), README/ZWEIGE/TESTPLAN/FAQ/AUFGABEN 0. `pruefstand-buch.tsv` 5 Zeilen weniger: die doppelten `E-140p`/`E-177p`/`E-178p` von `main` (je zwei Zeilen) sind auf eine zusammengefasst, `E-179p` steht gleich da; `TESTLAEUFE.md` 3 „entfernte“ Zeilen stehen alle weiter in der Datei (verschoben). Nichts verloren |
| persönliche Angaben | eigene Commits, Messskripte, TESTLAEUFE | erfundene Testkennwörter `e204-alt-kennwort`/`e204-neu-kennwort`, Konten `e204alt`/`e204neu@127.0.0.1`; kein Pfad aus Gregors Verzeichnissen in den sechs eigenen Commits (gelesen) |

## Funde

### <a id="l-135.1"></a>L-135.1 — Die FAQ nennt das gewöhnliche Löschen einer Persönlichkeit „unbedenklich“ — genau dieser Weg schickt bis 7.2.1.131 das alte Kennwort ab (E-204)

**Gewicht: mittel.** Ein Anwender, der eine Persönlichkeit löscht und gleich neu anlegt, folgt der FAQ und gibt sein altes Kennwort an das neue Konto weiter. Die README warnt davor, die FAQ widerspricht ihr. (gemessen an den Texten)

- `Doku/FAQ.md:153-158` *„**Löschen:** das gewöhnliche Löschen über *Personalities → Delete* ist unbedenklich (am Prüfstand gemessen). Nur wer vorher *Change Password* … sollte Eudora vor dem Löschen einmal beenden und neu starten“* — gemessen war das für [E-39](../Intern/BEFUNDE.md#e-39) (der INI-Rest), nicht für das Kennwort.
- `README.md:165` *„Betroffen ist der gewöhnliche Fall: die gelöschte war beim Löschen nicht die aktuelle“*, Abhilfe *„nach dem Löschen Eudora einmal beenden und neu starten, bevor Sie eine gleichnamige Persönlichkeit anlegen“*; `BEFUNDE.md:405` gemessen `PASS e204-alt-kennwort` für `e204neu`.
- `git diff origin/main HEAD -- Doku/FAQ.md` → leer: der Zweig hat die FAQ nicht angefasst.

**Vorschlag:** an derselben Stelle: *„Wer eine Persönlichkeit löscht und in derselben Sitzung eine neue **mit demselben Namen** anlegt, sollte dazwischen Eudora einmal beenden und neu starten — bis 7.2.1.131 bekommt die neue sonst das Kennwort der gelöschten und schickt es beim ersten Abruf ungefragt an ihr Konto ([E-204](../Intern/BEFUNDE.md#e-204), behoben ab 7.2.2.132).“* „unbedenklich“ auf den INI-Rest einengen.

### <a id="l-135.2"></a>L-135.2 — E-39 sagt weiter, der Prüfstand sehe den Weg vollständig; seit `E-39p` zu `E-203p` wurde, misst ihn kein Fall

**Gewicht: Kleinkram mit Wirkung auf die Arbeitsliste.** (gemessen)

- `BEFUNDE.md:460` am Ende *„**Was noch fehlt:** das Paket 7.2.2.132 …; für Gregor nichts zu prüfen — der Prüfstand sieht den Weg vollständig.“* — im selben Eintrag kurz davor *„die E-39-Behebung selbst sichert nur noch `TestE39.cpp`“*. Erzeugt übernommen in `CHANGELOG.md:74` und `WEITERMACHEN.md:123`.
- `pruefstand-faelle.txt:405` `E-203p` verlangt `war-aktuell=0`; einen Fall mit `war-aktuell=1` gibt es nicht mehr. Stehen geblieben sind `E-39v`/`E-39w` auf `C:\Temp\E39` (`:412-413`) — Positivproben ohne den Fall, den sie absichern; sie messen dasselbe wie `E-203v`/`E-203w` in einem zweiten Start. `pruefstand-buch.tsv:64` führt weiter *„E-39p ok 2026-11-02 16:40:17 … war-aktuell=1“* für einen Fall, den `pruefstand-faelle.txt` nicht mehr kennt.
- `tools/WERKZEUGE.md:162` (`messen-e39.ps1`): vorn *„in den Prüfstandsfällen `E-39p`/`E-39v`/`E-39w`, Prüfstand `C:\Temp\E39`“*, hinten *„`E-39p` gibt es nicht mehr“*; `E-203v`/`E-203w` und `C:\Temp\E203` fehlen.
- `CHANGELOG.md:144` (Block #207) *„Regressionsfälle `E-39p`/`E-39v`/`E-39w`“* ist Geschichte und darf so stehen.

**Vorschlag:** [E-39](../Intern/BEFUNDE.md#e-39) *„**Was noch fehlt:** das Paket 7.2.2.132; am Programm sieht den Weg seit der Behebung von [E-203](../Intern/BEFUNDE.md#e-203) kein Prüfstandsfall mehr, gesichert ist er durch `TestE39.cpp`; für Gregor nichts zu prüfen.“*, dann `offene-befunde.pl -schreiben`. `E-39v`/`E-39w` streichen oder begründen, die Buchzeile `E-39p` entfernen, die WERKZEUGE-Zeile auf `E-203p/v/w` umstellen.

### <a id="l-135.3"></a>L-135.3 — „Durchgesehen ist nur *Change Password*“ unterschlägt die Durchsicht aller 97 Aufrufe in PRÜFER-85

**Gewicht: Kleinkram.** Der Satz macht die Lage schlechter, als sie belegt ist, und nennt die echte Grenze nicht. (gemessen an den Texten)

- `BEFUNDE.md:406` ([E-203](../Intern/BEFUNDE.md#e-203)) *„durchgesehen ist nur *Change Password* ([PRÜFER-88](PRUEFER-88.md#pruefer-88) K4: rund 100 Aufrufe von `SetCurrent`, Stichproben ohne Fund …)“*; ebenso `BEFUNDE.md:460` ([E-39](../Intern/BEFUNDE.md#e-39)), `pruefstand-faelle.txt:402-404` *„durchgesehen ist nur Change Password, [PRUEFER-88](PRUEFER-88.md#pruefer-88) K4“*, `tools/messen-e39.ps1:37-38`.
- Dagegen `Befunde/PRUEFER-85.md:36` *„Ich habe alle 97 `SetCurrent`-Aufrufe außerhalb von `Tests/` mit einem Skript nach Funktionen gruppiert. Gesucht habe ich `return`, `break`, `goto` und `throw` zwischen dem ersten und dem letzten Aufruf einer Funktion. 16 Funktionen meldet das Skript, alle habe ich gelesen.“* und `:46` *„Über die Oberfläche bleibt also nur `ChangePassword`.“* — [E-39](../Intern/BEFUNDE.md#e-39) zitiert das im selben Eintrag (*„Andere Wege … (PRÜFER-85 Abschnitt 3, am Quelltext belegt): über die Oberfläche nur `ChangePassword`“*). [PRÜFER-88](PRUEFER-88.md#pruefer-88) K4 kannte die Durchsicht offenbar nicht (Vermutung).
- Die echte Grenze: gesucht wurde nur innerhalb einer Funktion; ein Umschalten in der einen und Zurückschalten in einer anderen sieht das Skript nicht. Nach [E-211](../Intern/BEFUNDE.md#e-211) bleibt von den gefundenen Wegen nur `DownloadSingleMessage` (`ImapDownload.cpp:1033`).

**Vorschlag:** *„kein *bekannter* Weg: [PRÜFER-85](PRUEFER-85.md#pruefer-85) hat alle 97 Aufrufe innerhalb je einer Funktion durchgesehen; Wege über Funktionsgrenzen sind nicht durchgesehen; offen bleibt der Fehlerfall in `DownloadSingleMessage`.“* — an den vier Stellen gleich.

### <a id="l-135.4"></a>L-135.4 — WERKZEUGE kennt die übernommene Prüfstandssperre nicht und beschreibt `strg-n-pruefen.ps1` und `testlauf.ps1` wie vor ihr

**Gewicht: Kleinkram, vor dem Merge zu erledigen.** (gemessen)

- Schleife über `git ls-files 'tools/*.pl' 'tools/*.ps1' 'tools/*.sh' 'tools/*.py'` gegen `tools/WERKZEUGE.md`: genau eine Datei fehlt, `tools/pruefstand-sperre.ps1` (aus `21029ad6`).
- `tools/WERKZEUGE.md:68` *„`tools/strg-n-pruefen.ps1` | startet Eudora, klickt Meldungen weg, schickt Strg-N …“* — die Datei bricht seit `78b47ebe` gleich ab (`strg-n-pruefen.ps1:25-32` *„STILLGELEGT am 02.11.2026 … exit 2“*) und verweist dabei auf WERKZEUGE. `:126` (`testlauf.ps1`) nennt weder die Sperre noch `-MitVorbereiten`/`-SperreMinuten` (`testlauf.ps1:49-59`).
- `tools/pruefstand-sperre.ps1:6` *„Selbsttest ohne Eudora-Start: tools\pruefstand-sperre-test.ps1“* — die Datei gibt es in diesem Zweig nicht ([PRÜFER-88](PRUEFER-88.md#pruefer-88) K7: die Stilllegung ist jetzt übernommen, der Gegentest nicht).
- Auf `origin/e133_mailverzeichnis_fehlt` (nicht gemergt) stehen alle drei Zeilen (`WERKZEUGE.md:125-127`). `git merge-tree --write-tree --name-only HEAD origin/e133_mailverzeichnis_fehlt` → Konflikte in `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `Intern/pruefstand-ergebnis.txt`, `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/pruefstand-faelle.txt`.
- Stand-Kopf `WERKZEUGE.md:3` *„am 02.11.2026 neu `messen-e177`, … `messen-e179` und `smtp-pruefserver`“* — ohne `startzeilen-sammeln`, `messen-e204` und `pruefstand-sperre`.

**Vorschlag:** die drei Zeilen aus `e133_…` übernehmen (Sperre; `strg-n-pruefen.ps1` stillgelegt; `testlauf.ps1` mit Sperre), den Gegentest mitnehmen oder den Verweis in `pruefstand-sperre.ps1:6` als „liegt auf `e133_…`“ kennzeichnen; Stand-Kopf ergänzen. Wer als Zweiter gemergt wird, löst die sieben Konflikte und erzeugt die Listen neu.

### <a id="l-135.5"></a>L-135.5 — WEITERMACHEN nennt `messungen_vor_7_2_2_132` nach #210 weiter laufend; zwei CHANGELOG-Blöcke ohne PR-Nummer

**Gewicht: Kleinkram, dieselbe Klasse zum elften Mal** ([L-128.2](LEKTOR-128.md#l-128.2)). (gemessen)

- `Intern/WEITERMACHEN.md:3` *„… Laufend: Zweig `messungen_vor_7_2_2_132` ([E-141](../Intern/BEFUNDE.md#e-141) und [E-179](../Intern/BEFUNDE.md#e-179) am Prüfstand bestätigt …)“* — `origin/main` ist `0341c5fe` *„Merge pull request #210 from HansWurst81675/messungen_vor_7_2_2_132“*; `#210` kommt in Zeile 3 nicht vor, `#209` schon.
- `CHANGELOG.md:130` *„**Zweig `e194_e196_speichern_unter`, Quellstand weiter 7.2.1.131 — nur übersetzt; kommt mit 7.2.2.132.**“* und `:146` *„**Messungen — Zweig `messungen_vor_7_2_2_132`**“* ohne *„(gemergt als #209/#210)“*, anders als `:142` *„`e39_persona_loeschen` (gemergt als #207)“*.

**Vorschlag:** Zeile 3 *„Gemergt als #210: Zweig `messungen_vor_7_2_2_132` (…)“*; in beide CHANGELOG-Köpfe die Nummer. Das Werkzeug aus [L-128.2](LEKTOR-128.md#l-128.2) bleibt die eine Abhilfe für alle künftigen Fälle.

### <a id="l-135.6"></a>L-135.6 — Zeilenangaben in E-203, E-210 und E-39 treffen nicht mehr

**Gewicht: Kleinkram.** (gemessen am Quelltext)

- [E-203](../Intern/BEFUNDE.md#e-203) (`BEFUNDE.md:406`) *„beide frühen Ausgänge schalten … zurück (`password.cpp:463-476`)“* — seit dem Block von [E-210](../Intern/BEFUNDE.md#e-210) dazwischen stehen sie `:461-466` und `:482-488`. *„der Test vergleicht die vier Ausgänge als ganze Blöcke“* — `TestE203E204.cpp:141` verlangt *„nAusgaenge == 5“*.
- `EudoraRes.rc:9158` (`IDS_ERR_BAD_POP_ACCT`, in [E-203](../Intern/BEFUNDE.md#e-203), [E-210](../Intern/BEFUNDE.md#e-210), [E-39](../Intern/BEFUNDE.md#e-39)) steht heute `:9160`; in [E-39](../Intern/BEFUNDE.md#e-39) `:10725` (`IDS_PERSONA_PERMANENT_DELETE`) → `:10726`, `:11290` (`RemoveChangePassword`) → `:11292`. Verschoben schon auf `main` (#209), nicht durch diesen Zweig.
- [E-39](../Intern/BEFUNDE.md#e-39) *„`NewCompDocument`, wenn das Dokument nicht angelegt werden kann (`compmsgd.cpp:2251`)“* — `:2251` ist das Umschalten, die Rückkehr steht heute `:2269` (auf `main` `:2261`).
- [E-203](../Intern/BEFUNDE.md#e-203) und [E-204](../Intern/BEFUNDE.md#e-204) nennen unter *„Zuletzt gemessen“* den Bau `f96f8797*`; der letzte Lauf war `2b3a529d*` (`pruefstand-buch.tsv:57-61`) — steht weiter hinten im Text, der Kopf sagt das Ältere.

**Vorschlag:** die Angaben nachziehen; Köpfe auf `2b3a529d*`.

### <a id="l-135.7"></a>L-135.7 — Der Prüfstandsvermerk zu den Debug-`.eif` steht nur in E-204 und verweist auf einen geschlossenen Befund

**Gewicht: Kleinkram.** (gemessen an Texten und Skript)

- `BEFUNDE.md:405` **Vermerk zum Prüfstand**: Prüfstände tragen Debug-Fassungen von `NSImport.eif`, `OEImport.eif`, `OLImport.eif`, Eudora stürzte danach *„beim Beenden in `ucrtbased.dll“* ab, *„`tools/pruefstaende-auffrischen.ps1` kopiert die `.eif` nicht mit“* (`grep -c eif tools/pruefstaende-auffrischen.ps1` → 0). Die zwei abgeschossenen Starts `C:\Temp\E204-alt` (`TESTLAEUFE.md`, 18:20:42 und 18:22:53) passen dazu.
- `WEITERMACHEN.md:3` *„Offen dazu: die Prüfstände tragen noch Debug-`.eif` ([E-160](../Intern/BEFUNDE.md#e-160))“* — [E-160](../Intern/BEFUNDE.md#e-160) ist *„**behoben — von Gregor am 27.10.2026 an Paket 1.0.127 bestätigt“*. Mit dem Schließen von [E-204](../Intern/BEFUNDE.md#e-204) verschwindet der Vermerk aus jeder Liste; ein Absturz beim Beenden kann so einen echten verdecken (Vermutung).

**Vorschlag:** der Hauptagent ordnet es einem bestehenden *werkzeug*-Befund zu oder legt einen an (Messweg: `.eif` im Prüfstand gegen den eigenen Bau vergleichen). Keine Kennung von mir.

### <a id="l-135.8"></a>L-135.8 — E-210 begründet die Stufe mit der Erreichbarkeit, die die Legende nicht kennt

**Gewicht: Kleinkram.** (gemessen am Text)

- `BEFUNDE.md:401` *„**Stufe: wichtig** (ein Speicherfehler wäre *kritisch*, ist aber ab Werk kaum erreichbar und nicht gemessen)“*. Legende `BEFUNDE.md:146-147`: *kritisch* u. a. *„das Programm stürzt ab“*; *wichtig* *„Eine Funktion ist unbrauchbar, aber nichts geht verloren und der Anwender merkt es sofort“* — ein Stapelüberlauf passt in keine der beiden Beschreibungen von *wichtig*, und „kaum erreichbar“ ist kein Kriterium der Legende. Dieselbe Begründung trägt die Herabstufung von [E-39](../Intern/BEFUNDE.md#e-39) (`:460` *„ab Werk kaum erreichbar“*), dort neben dem gemessenen harmlosen Rest.
- Folge: [E-210](../Intern/BEFUNDE.md#e-210) zählt nicht unter `pruefe-regressionstest.pl` *kritisch* und braucht dort keine Prüfung.

**Vorschlag:** der Hauptagent entscheidet — entweder *kritisch* mit dem Vermerk „ab Werk kaum erreichbar“, oder die Legende um die Erreichbarkeit ergänzen, damit [E-39](../Intern/BEFUNDE.md#e-39) und [E-210](../Intern/BEFUNDE.md#e-210) nach einer Regel stehen.

### <a id="l-135.9"></a>L-135.9 — ZWEIGE nennt für diesen Zweig nur E-203 und E-204

**Gewicht: Kleinkram** (dieselbe Klasse wie [L-133.7](LEKTOR-133.md#l-133.7)). (gemessen)

- `tools/ZWEIGE.md:221` *„[E-203](../Intern/BEFUNDE.md#e-203) (…) und [E-204](../Intern/BEFUNDE.md#e-204) (…), Folgefehler von [E-39](../Intern/BEFUNDE.md#e-39), für 7.2.2.132.“* — [E-210](../Intern/BEFUNDE.md#e-210), [E-211](../Intern/BEFUNDE.md#e-211), `startzeilen-sammeln.pl` und die übernommene Prüfstandssperre (`21029ad6`) fehlen. CHANGELOG (`:121-128`) und WEITERMACHEN (`:3`) nennen sie.

**Vorschlag:** ergänzen: *„dazu [E-210](../Intern/BEFUNDE.md#e-210), [E-211](../Intern/BEFUNDE.md#e-211) (nach PRÜFER-88), `tools/startzeilen-sammeln.pl`, Prüfstandssperre aus `e133_mailverzeichnis_fehlt` übernommen.“*

### <a id="l-135.10"></a>L-135.10 — Die doppelten Startzeilen sind durch zwei Merges von 11 auf 58 gewachsen

**Gewicht: Kleinkram** (Fortschreibung von [L-134.13](LEKTOR-134.md#l-134.13)). (gemessen)

- `sort | uniq -d` über die Datenzeilen von `tools/TESTLAEUFE.md`: `origin/main` 34, Zweigstand vor dem Merge `4182961e` 0, Merge `2b3a529d` 61, `78b47ebe` 58. Alle vom 02.11.2026.
- `startzeilen-sammeln.pl` ist nicht die Ursache: es übernimmt keine gleiche Zeile (`:53`) und sortiert ein (WERKZEUGE-Zeile, gegengetestet). Die Ursache ist die Merge-Auflösung, wenn beide Seiten dieselben Zeilen an verschiedenen Stellen haben. [PRÜFER-88](PRUEFER-88.md#pruefer-88) K6.3 beschreibt, dass `pruefe-startwege.pl` ohnehin nur Zeiten zählt; Dubletten verdecken darum nichts zusätzlich (belegt am Quelltext laut K6, nicht nachgelesen).

**Vorschlag:** einmal auf `main` bereinigen (eine Zeile je Zeitpunkt und Verzeichnis) und `startzeilen-sammeln.pl` um eine Warnung bei vorhandenen Dubletten ergänzen — dann sieht der nächste Merge sie.

## Bestand außerhalb des Schwerpunkts

Seit `ee7b5400` geänderte MDs außerhalb von `Arbeitsweise/` und `Befunde/` (`git log --stat ee7b5400..HEAD`): die von #209/#210 (auf `main`, geprüft in [LEKTOR-133](LEKTOR-133.md#lektor-133) und [LEKTOR-134](LEKTOR-134.md#lektor-134)) und aus den eigenen Commits `CHANGELOG.md`, `README.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` — alle gelesen. Übrige MDs nach `Change Password`, `RemoveChangePassword` und den vier Kennungen durchsucht (`git grep` ohne `Befunde/`, `Arbeitsweise/`, `BEFUNDE.md`, `LEKTORAT.md`): außer [L-135.1](#l-135.1) nur `Doku/FUNKTIONEN.md:216`, `:973`, `:1105` (*Change Password* ab Werk ausgeblendet, `mainfrm.cpp:8487-8488` — trifft: `:8487` *„if (GetIniShort(IDS_INI_REMOVE_CHANGE_PASSWORD))“*). Die README-Zeile zu [E-204](../Intern/BEFUNDE.md#e-204) (`:165`) sagt „Bis 7.2.1.131“, „im Quellstand behoben, kommt mit 7.2.2.132“ und gibt eine Abhilfe — stimmig mit dem Befund. `Intern/AUFGABEN.md` ist laut Kopf nur noch zum Nachschlagen; nicht berührt. `Intern/TESTPLAN.md` braucht nichts: alle vier Befunde sagen „für Gregor nichts zu prüfen“.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„gepruefte Dateien 52“*, *„Kennungen im Verzeichnis 183“*, *„Kein Widerspruch gefunden.“*; *Zur Kenntnis* wie in [LEKTOR-134](LEKTOR-134.md#lektor-134) (Dateien mit älterer höchster Fassung, z. B. `Testdaten/README.md` 7.2.0.120). [L-135.1](#l-135.1) bis [L-135.10](#l-135.10) sieht es nicht — es vergleicht Fassungsnummern, nicht Aussagen.

`perl tools/offene-befunde.pl` (gemessen): *„57 offene Befunde, in beiden Listen gleich.“*, *„davon aktuell gemessen 22“*, *„davon NIE gemessen 10“*. Dass [E-39](../Intern/BEFUNDE.md#e-39) „der Prüfstand sieht den Weg vollständig“ sagt, ohne dass es einen Fall gibt ([L-135.2](#l-135.2)), erkennt es nicht.

`perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 71“*, *„mit Testfall im Pruefstand 64 von 71“*, *„OHNE jede Pruefung 5 <- Rueckstand [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133)“*, *„Kein neues "behoben" ohne Regressionstest.“* — [E-204](../Intern/BEFUNDE.md#e-204) zählt richtig unter „mit Testfall“ (`E-204p`/`E-204w`).

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

1. **Sollen die Zweige auf GitHub gelöscht werden, die noch eine Gedächtnisdatei mit einer persönlichen Angabe tragen** ([L-130.1](LEKTOR-130.md#l-130.1): eine Angabe, die nicht ins Repo soll)? `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; `main` und dieser Zweig sind frei davon. Unverändert seit [LEKTOR-131](LEKTOR-131.md#lektor-131).
2. **Administratorrechte für die Messung von [E-176](../Intern/BEFUNDE.md#e-176)** (Lesen aus schon freigegebenem Speicher beim Schließen einer verworfenen neuen Nachricht): unverändert aus [LEKTOR-134](LEKTOR-134.md#lektor-134) Frage 2 — `WEITERMACHEN.md:98` nennt weiter *„eine Sitzung mit Administratorrechten (Gregors Ja)“*; eine Antwort steht nirgends im Repo.
