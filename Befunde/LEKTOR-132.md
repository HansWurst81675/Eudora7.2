# <a id="lektor-132"></a>LEKTOR-132 — Bestand nach den Abschnitten der Eudora.ini, Zweig funktionen_ini_abschnitte nach d79494c0 (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-131](LEKTOR-131.md#lektor-131) (`Befunde/LEKTOR-131.md`, liegt auf `origin/e39_persona_loeschen` und `origin/wt/lektor-20261102l`, nicht in diesem Zweig — darum hier ohne Verweis).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102m`, abgezweigt von `origin/funktionen_ini_abschnitte`, Stand `d79494c0` (*„FUNKTIONEN.md: Abschnitte der Eudora.ini, Kontoschluessel [Persona-<Name>]“*).
Umfang: Bestand aller 66 MD-Dateien außerhalb von `Arbeitsweise/` und `Befunde/` (`git ls-files '*.md'`, gezählt). Schwerpunkt: der Zweig gegenüber `456c95e1` (Merge von #206, Stand von `main`) — 2 Commits (`05eea120`, `d79494c0`), 5 Dateien: `Doku/FUNKTIONEN.md` (+125/−34), `tools/hilfe-html.pl` (+15/−2), `tools/TESTLAEUFE.md` (+22), `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` (je +1/−1 bzw. +1) (`git log --stat 456c95e1..HEAD`, gemessen). Dazu der Nachbarzweig `origin/e39_persona_loeschen` (jetzt `f31dbff9`, *„[LEKTOR-131](LEKTOR-131.md#lektor-131) eingearbeitet“*), weil beide nach `main` wollen. Nichts gebaut, nichts gestartet; `tools/hilfe-html.pl` lief nur als Perl-Selbsttest und einmal in das Scratchpad.

## Kurz

Der neue Abschnitt 6 von `Doku/FUNKTIONEN.md` (*Die Abschnitte der `Eudora.ini`*) ist im Kern richtig: die Nummernbereiche aus `GetSectionID`, die vier Suchstufen, der Abschnittsname `Persona-` mit Bindestrich und die **40 Schlüssel aus `SavePersonaInfo` stimmen genau** mit dem Quelltext überein (mechanisch gegeneinander gelegt, kein Schlüssel zu viel oder zu wenig), ebenso die sechs Schlüssel, die Eudora selbst je Konto schreibt oder liest. Auch die Spalte *Abschnitt* ist durchgehend: jede Tabellenzeile mit einem der 46 Schlüssel trägt „`[Settings]` bzw. `[Persona-<Name>]`“, keine andere (gemessen). `hilfe-html.pl --selbsttest` meldet *„50 ok, 0 FEHLER“*, die erzeugte `Einstellungen.html` enthält den Abschnitt und nennt keinen Namen. **Nicht in Ordnung:** der Zweig gerät beim Merge mit `e39_persona_loeschen` in zwei Konflikte, und nach diesem Merge treffen vier seiner neuen `persona.cpp`-Angaben nicht mehr; Testplan, Befund [A-5](../Intern/BEFUNDE.md#a-5) und CHANGELOG beschreiben die Einstellungsseite noch ohne den neuen Teil — Gregors Testschritt 3 nennt ein falsches Seitenende; zwei Zeilen der Abschnittstabelle (Werkzeugleisten, alte Abschnitte) sagen am Quelltext etwas anderes. Acht Funde, keiner am Programmcode. Die acht Funde aus [LEKTOR-131](LEKTOR-131.md#lektor-131) sind auf `e39_persona_loeschen` erledigt; auf `main` (und damit hier) stehen [L-131.2](LEKTOR-131.md#l-131.2) und [L-131.8](LEKTOR-131.md#l-131.8) noch, bis jener Zweig gemergt ist.

## Funde aus LEKTOR-131 — heutiger Stand

[LEKTOR-131](LEKTOR-131.md#lektor-131) prüfte `e39_persona_loeschen` nach `1721eee2`. Seitdem trägt jener Zweig `f31dbff9` (*„[LEKTOR-131](LEKTOR-131.md#lektor-131) eingearbeitet ([L-131.1](LEKTOR-131.md#l-131.1) bis [L-131.8](LEKTOR-131.md#l-131.8))“*). Gemessen mit `git show origin/e39_persona_loeschen:<datei>`.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-131.1](LEKTOR-131.md#l-131.1) Merge-Spuren (doppelte Zeile `paket_7_2_1_131`, Leerzeile im CHANGELOG, Trennlinie vor [A-5](../Intern/BEFUNDE.md#a-5)) | **erledigt** auf `e39_persona_loeschen` | `tools/ZWEIGE.md`: eine Zeile `paket_7_2_1_131` (`:213`); `CHANGELOG.md:120` leer vor *„**Für 7.2.2 — Zweig `hilfe_menue`** (auf `main` seit #206 …“*; `tools/pruefstand-faelle.txt:371-373` Leerzeile, `# ----`, *„# [A-5](../Intern/BEFUNDE.md#a-5) - Hilfe-Menue …“*; `TESTLAEUFE.md` nach Zeit umgestellt (`f31dbff9`, drei EHILFE-Zeilen von 14:39 bis 14:41 nach vorn) |
| [L-131.2](LEKTOR-131.md#l-131.2) `hilfe_menue` „nicht gemergt“ nach #206 | **erledigt** auf `e39_persona_loeschen`, **auf `main` und hier offen** | dort `ZIEL.md:122` *„Umgesetzt, am Prüfstand gemessen, auf `main` seit #206“*, `ZWEIGE.md` *„Stand: gemergt als #206“*. Hier unverändert: `CHANGELOG.md:116` *„(noch nicht gemergt, …)“*, `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `hilfe_menue`“*, `ZIEL.md:122` *„Umgesetzt im Zweig `hilfe_menue`“* — dieser Zweig fasst die drei Dateien nicht an, kein Konflikt zu erwarten |
| [L-131.3](LEKTOR-131.md#l-131.3) FAQ rät zum Umweg | **erledigt** auf `e39_persona_loeschen` | dort `Doku/FAQ.md:153` *„**Löschen:** das gewöhnliche Löschen über *Personalities → Delete* ist unbedenklich (am Prüfstand gemessen)“*; hier noch `Doku/FAQ.md:153-155` *„vor dem Löschen der gerade benutzten Persönlichkeit auf eine andere wechseln“* |
| [L-131.4](LEKTOR-131.md#l-131.4) Zeilenangaben nach #206 | **erledigt für die genannten Stellen** auf `e39_persona_loeschen`; **hier offen**; die Klasse ohne Werkzeug | dort `BEFUNDE.md` `mainfrm.cpp:8487-8488`, `EudoraRes.rc:11290`; `FUNKTIONEN.md` 22 Angaben nachgezogen (`f31dbff9`). Hier noch 12 veraltete `mainfrm.cpp`-Angaben über 6118 in `Doku/FUNKTIONEN.md` (z. B. `:968` *„`mainfrm.cpp:8372-8373`“*, heute `:8487-8488`) — siehe [L-132.1](#l-132.1) |
| [L-131.5](LEKTOR-131.md#l-131.5) kein Bau/Testlauf nach dem Merge | **erledigt** (Tests) | dort `BEFUNDE.md:455` *„Tests: 367 Tests, 367 bestanden (am Stand nach dem Merge von #206“*; das Programm am gemergten Stand selbst ist weiter nicht als gebaut vermerkt |
| [L-131.6](LEKTOR-131.md#l-131.6) PRÜFER-85 unverlinkt | **erledigt** | `git show …:CHANGELOG.md …:Intern/BEFUNDE.md \| grep -c 'PRUEFER-85.md'` → 4 |
| [L-131.7](LEKTOR-131.md#l-131.7) WERKZEUGE nennt alte Ausgabe von `messen-e39.ps1` | **erledigt** | dort `tools/WERKZEUGE.md` *„E39 ERGEBNIS abschnitt-wieder= schluessel= war-aktuell= aktuell-danach= lebt=“* |
| [L-131.8](LEKTOR-131.md#l-131.8) Berichtszahl in der README | **erledigt** auf `e39_persona_loeschen`, hier offen | dort `README.md:98` *„(213 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“*; hier `README.md:98` *„(209 …)“* bei 211 Berichten im Verzeichnis (`ls Befunde \| grep -cE '^(LEKTOR\|PRUEFER)-[0-9]+\.md$'`), mit diesem 212. Der Vorschlag, die Zahl wegzulassen oder prüfen zu lassen, ist nicht umgesetzt — sie veraltet weiter mit jedem Bericht |
| [L-130.1](LEKTOR-130.md#l-130.1) persönliche Angabe in alten Zweigen | **für `main` und hier erledigt; Zweige stehen noch** | `git merge-base --is-ancestor d9ae24c8 HEAD` → nein; `git branch -r --contains d9ae24c8` → `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d` |
| [L-129.1](LEKTOR-129.md#l-129.1) Schranke „zuletzt veröffentlicht“ | **offen** | `tools/pruefe-release-buchfuehrung.pl` zuletzt `cf6c3fee`; `grep -c 'zuletzt ver'` → 0 |
| [L-128.2](LEKTOR-128.md#l-128.2) Schranke gegen „läuft/PR folgt“ nach dem Merge | **offen** | `grep -l 'PR folgt\|Laufend' tools/*.pl` → kein Treffer; die Stellen aus [L-131.2](LEKTOR-131.md#l-131.2) stehen auf `main` weiter |
| [L-128.3](LEKTOR-128.md#l-128.3) Entwurfskopf in der Notizdatei | **offen** | `tools/release-veroeffentlichen.ps1:128` *„if ($text -match 'noch nicht best')“* nur am CHANGELOG; `:261` reicht `--notes-file` ungeprüft weiter |
| [L-126.1](LEKTOR-126.md#l-126.1) Webmailer-Schritt prüft vermutlich das falsche Datum | **teilweise** (unverändert) | `Intern/TESTPLAN.md:409` *„Im lokalen *In* eine Mail aussuchen, deren Uhrzeit du kennst“* |
| [L-126.5](LEKTOR-126.md#l-126.5) Starts ohne Titelzeile | **teilweise** | vom 02.11. jetzt 75 Zeilen, davon 14 ohne `[Eudora` (`grep '^\| 2026-11-02' tools/TESTLAEUFE.md \| grep -vc '\[Eudora'`); die 22 mit `05eea120` übernommenen E39-/E194-Zeilen tragen alle eine Titelzeile |

## Abschnitt 6 und die Kontoschlüssel gegen den Quelltext

| Aussage | Stelle | Gegen (gemessen) |
|---|---|---|
| Nummernbereiche: bis 10800 und ab 11101 `[Settings]`, 10801–10900 `[Debug]`, 10901–11100 `[Window Position]` | `Doku/FUNKTIONEN.md:1017-1019` | `rs.cpp:89-98` `GetSectionID` (*„if (IniID > IDS_INISN_SETTINGS2) return IDS_INISN_SETTINGS;“* …); `resource.h:3503` `IDS_INISN_DEBUG 10800`, `:3515` `IDS_INISN_WINDOW_POSITION 10900`, `:3543` `IDS_INISN_SETTINGS2 11100` — trifft |
| vier Suchstufen in `rs.cpp:449-464` | `FUNKTIONEN.md:989-997` | `rs.cpp:442` *„CString Personality = g_Personalities.GetCurrent();“*, `:451` `g_Personalities.GetProfileString(Personality, …)`, `:454` `Eudora.ini`, `:456` `DefaultINIPath`, `:461-464` eingebauter Wert — trifft (die zweite Fassung für `char*`-Puffer, `rs.cpp:330-346`, macht dasselbe) |
| Hauptkonto → `[Settings]`, sonst `Persona-<Name>` | `FUNKTIONEN.md:992-993`, `:1021` | `persona.cpp:52` *„const CString csPersonaPreface = "Persona-";“*; `:904-907` *„if ( *lpName == '\0' \|\| ! strcmp( lpName, m_Dominant ) ) PersonaID = "Settings"; else PersonaID = csPersonaPreface + lpName;“* — trifft, und zwar **unabhängig von der Zahl der Konten** |
| `[Personalities]` mit `Persona0=Persona-<Name>` | `FUNKTIONEN.md:1020` | `persona.cpp:74` *„CString PersonaID = csPersonaPreface + Name;“*, `:84-85` Vergleich mit `Persona%d`; geschrieben in `Add`, `:255` — trifft; `EudoraRes.rc:8007` *„IDS_PERSONALITIES "Personalities"“* |
| 40 Schlüssel aus `SavePersonaInfo` | `FUNKTIONEN.md:1038-1048` | `persona.cpp:931-1078`: 41 Kennungen, 40 verschiedene (`IDS_INI_AUTH_PASS` doppelt, die zweite auskommentiert, `:1066`), über `EudoraRes.rc` in Namen übersetzt und gegen die fünf Tabellenzeilen gelegt: `comm -3` leer — **genau dieselben 40** |
| „gelesen von `GetParams` (`persona.cpp:278-490`)“ | `FUNKTIONEN.md:1040` | `GetParams` liest **38** davon; `MarkAsDeleted` und `SavePasswordText` nicht ([L-132.5](#l-132.5)) |
| `SavePassword`/`SavePasswordText` gehen in den Abschnitt der aktiven | `FUNKTIONEN.md:1012-1014`, `:1055` | `rs.cpp:1238-1240` *„// password stuff goes to current personality … if ( StringNum == IDS_INI_SAVE_PASSWORD \|\| StringNum == IDS_INI_SAVE_PASSWORD_TEXT )“* — trifft |
| `AccountDir` | `FUNKTIONEN.md:1056` | `QCImapMailboxDirector.cpp:205` liest, `:227` *„g_Personalities.WriteProfileString( strPersona, key, szAccountSubdir);“* — trifft |
| `ImapUIDPLUSFound`, `ImapScoreJunk`, `ImapIgnoreUIDPLUS`, `ImapIgnoreNAMESPACE` | `FUNKTIONEN.md:1057-1059` | `ImapAccount.cpp:202-218` vier Lesungen je Persönlichkeit; `:818` und `:872` `WriteProfileString(strPersona, key, szValue)` für UIDPLUS und ScoreJunk; die beiden *Ignore* werden nirgends geschrieben — trifft |
| Spalte *Abschnitt* bei allen 46 | `FUNKTIONEN.md:476-481` | eigenes Perl-Skript über alle Tabellenzeilen vor Abschnitt 6: keine Zeile mit einem der 46 ohne „bzw.“, keine „bzw.“-Zeile ohne einen der 46; 27 Zeilen (26 in Abschnitt 3, dazu `AccountDir` `:970`) — trifft. Die Commit-Nachricht von `d79494c0` sagt *„in 25 Tabellenzeilen“* |
| `[Mappings]` aus `Eudora.ini`, sonst `DEudora.ini` | `FUNKTIONEN.md:1022` | `MIMEMap.cpp:253` `IDS_MIME_MAPPINGS` (`EudoraRes.rc:9598` *„"[Mappings]"“*), `:257` `INIPath`, `:266-268` `DefaultINIPath` — trifft |
| `[ToolBar-…]` | `FUNKTIONEN.md:1023-1024` | **trifft nur halb** ([L-132.3](#l-132.3)) |
| alte Abschnitte werden übernommen | `FUNKTIONEN.md:1025` | **mit Bedingung** ([L-132.4](#l-132.4)) |
| `hilfe-html.pl`: dritter Teil auf `Einstellungen.html` | `tools/hilfe-html.pl:91-92` *„qr/Die Abschnitte der `?Eudora\.ini/“* | `perl tools/hilfe-html.pl --selbsttest` (mit `TMPDIR` im Scratchpad): *„hilfe-html --selbsttest: 50 ok, 0 FEHLER“*; erzeugte Seite: `<h2 id="6-die-abschnitte-der-eudoraini">`, Sprungziel `was-ein-zusätzliches-konto-eigens-haben-kann` vorhanden, `grep -c Gregor` → 0. `tools/WERKZEUGE.md:58` nennt 50 Fälle und die drei Teile — passt |

## Funde

### <a id="l-132.1"></a>L-132.1 — Dieser Zweig und `e39_persona_loeschen` vertragen sich beim Merge nicht, und danach treffen vier neue Zeilenangaben nicht mehr

**Gewicht: mittel.** Wer zuerst gemergt wird, ist gleich; der zweite Zweig bringt Konflikte mit und verschiebt Angaben des ersten. (gemessen mit `git merge-tree`, nichts ausgecheckt)

- `git merge-tree --write-tree --name-only HEAD origin/e39_persona_loeschen` → *„CONFLICT (content): Merge conflict in Doku/FUNKTIONEN.md“* und *„… in tools/TESTLAEUFE.md“*. In `FUNKTIONEN.md` hat `f31dbff9` 22 Zeilenangaben nach #206 nachgezogen ([L-131.4](LEKTOR-131.md#l-131.4)), dieser Zweig dieselbe Datei in den Tabellen um `:496-553` und `:968-970` geändert; in `TESTLAEUFE.md` hat `05eea120` die E39-Zeilen übernommen, `f31dbff9` dieselben Zeilen umgestellt. Dazu kommt mit diesem Bericht `Intern/LEKTORAT.md`: beide Zweige hängen einen Abschnitt hinter [LEKTOR-130](LEKTOR-130.md#lektor-130) an.
- [E-39](../Intern/BEFUNDE.md#e-39) fügt `persona.cpp` hinter `:572` 27 Zeilen ein (`git diff HEAD origin/e39_persona_loeschen -- Eudora71/Eudora/persona.cpp` → *„@@ -572,6 +572,33 @@ BOOL CPersonality::Remove“*). Danach steht `GetProfileString` auf `:921` statt `:894`, `SavePersonaInfo` auf `:958` statt `:931` (gemessen am Stand von `e39_persona_loeschen`). Die neuen Angaben `persona.cpp:876-911` (`FUNKTIONEN.md:993`, `:1017`), `:931-940` (`:1011`) und `:931-1078` (`:1041`) treffen dann um 27 Zeilen daneben; `:52`, `:79-90` und `:278-490` liegen davor und bleiben.
- Hier selbst stehen noch die zwölf `mainfrm.cpp`-Angaben über Zeile 6118, die #206 verschoben hat ([L-131.4](LEKTOR-131.md#l-131.4)) — dieser Zweig hat `:968` (*„`mainfrm.cpp:8372-8373`“*) beim Umbau der Tabelle angefasst und die Zahl nicht nachgezogen.

**Vorschlag:** Den zweiten Zweig vor dem PR mit dem ersten (bzw. mit `main` nach dessen Merge) vereinigen und dann die `persona.cpp`-Angaben in Abschnitt 6 neu messen. Die Angaben in Abschnitt 6 tragen fast alle schon einen Funktionsnamen (`SavePersonaInfo`, `GetParams`, `GetSectionID`) — das ist der Textanker, der den Merge übersteht; das Werkzeug, das `datei:zeile` gegen den Quelltext hält, fehlt weiter ([L-131.4](LEKTOR-131.md#l-131.4)).

### <a id="l-132.2"></a>L-132.2 — Testplan, Befund A-5 und CHANGELOG beschreiben die Einstellungsseite noch ohne den neuen Teil

**Gewicht: mittel.** Gregor prüft am Paket 7.2.2.132 nach dem Testplan; der nennt ein anderes Seitenende als das, was er sehen wird. (gemessen)

- `Intern/TESTPLAN.md:445-448` *„3. *Help → Settings Reference* wählen. **Bestanden:** eine zweite Seite … mit je einer Tabelle pro Seite von *Tools → Options* (*Getting Started* bis *Find Messages*) und am Ende die Tabelle der `Eudora.ini`-Schlüssel ohne Optionsseite.“* — die erzeugte Seite endet jetzt mit *6. Die Abschnitte der `Eudora.ini`* und drei weiteren Tabellen (`<h2 id="6-die-abschnitte-der-eudoraini">` ist die letzte `h2`, gemessen an der Seite im Scratchpad).
- [A-5](../Intern/BEFUNDE.md#a-5) (*Hilfe-Menü*), `Intern/BEFUNDE.md:243`: *„`tools/hilfe-html.pl` (Abschnitte *Tastenkürzel auf einen Blick*, *Tools → Options*, *`Eudora.ini`-Schlüssel ohne Optionsseite*; `--selbsttest` 47 Fälle)“* — heute drei Teile auf der zweiten Seite und 50 Fälle (schon vor diesem Zweig 49, `456c95e1:tools/WERKZEUGE.md`). Ebenda *„(aus der Kennung gelesen, 197 Zeilen `[Settings]`)“* — heute 171 Zeilen `[Settings]` und 26 „`[Settings]` bzw. `[Persona-<Name>]`“ in Abschnitt 3 (gezählt). Und *„die Seite mit dieser Spalte lief noch nicht im Browser“* gilt jetzt auch für den neuen Teil, steht aber nur für die Spalte da.
- `CHANGELOG.md:118` *„zeigen die Tastenkürzel-Übersicht bzw. *Tools → Options* mit den `Eudora.ini`-Schlüsseln (mit Abschnitt) und die übrigen INI-Schlüssel als HTML-Seite“* — kein Wort zu den Abschnitten und den Kontoschlüsseln; einen eigenen Eintrag für `funktionen_ini_abschnitte` gibt es nicht (`grep -c 'Persona-<Name>\|Abschnitte der' CHANGELOG.md` → 0).
- `Intern/WEITERMACHEN.md:3` nennt den Zweig nicht (`grep -c funktionen_ini Intern/WEITERMACHEN.md` → 0); eingetragen ist er nur in `tools/ZWEIGE.md:216`.

**Vorschlag:** Testplan-Schritt 3 auf *„… am Ende die Abschnitte der `Eudora.ini` mit der Liste der Kontoschlüssel“*; in [A-5](../Intern/BEFUNDE.md#a-5) drei Teile, 50 Fälle, die neue Zählung; im CHANGELOG-Punkt [A-5](../Intern/BEFUNDE.md#a-5) einen Halbsatz zu `[Persona-<Name>]`.

### <a id="l-132.3"></a>L-132.3 — Die Zeilen zu `[ToolBar-…]` zeigen auf den Umwandlungsweg und verneinen Namen, die im Quelltext stehen

**Gewicht: mittel.** Wer der Fundstelle folgt, landet an einem Aufruf, der nur beim Umstieg von alten Leisten läuft; und die Behauptung „Namen stehen nicht im Quelltext“ ist widerlegt. (gemessen; ob die MFC-Abschnitte tatsächlich in der `Eudora.ini` landen, ist hier nicht verfolgt)

- `FUNKTIONEN.md:1023-1024` nennen `mainfrm.cpp:1054` (*„SaveBarState("ToolBar")“*). Dort steht `:1053-1054` *„if( pMgr->ConvertOldStuff() ) SaveBarState(_T("ToolBar"));“* — nur wenn alte Leistenangaben umzuwandeln sind. Der gewöhnliche Weg beim Beenden ist `mainfrm.cpp:5981` *„AUFRAEUMEN("SaveBarState(ToolBar)", SaveBarState(_T("ToolBar")));“* über `CMainFrame::SaveBarState` (`:2909`).
- `:1024` *„diese Abschnitte legt die MFC-Bibliothek selbst an, ihre Namen stehen nicht im Quelltext dieses Projekts“*. Im Projekt: `mainfrm.cpp:1877` *„szSection.Format( "%s-BarID%lu", "ToolBar", pToolBar->GetDlgCtrlID() );“* → `[ToolBar-BarID<n>]` mit `CustomButtonCount`; `mainfrm.cpp:1095` *„szMgrSection.Format(_T("%s-ToolBarManager"), _T("ToolBar"));“*. In der MFC-Quelle der installierten VS 2022 (`atlmfc/src/mfc/dockstat.cpp:21-22`): *„_afxBarSection[] = _T("%Ts-Bar%d")“*, *„_afxSummarySection[] = _T("%Ts-Summary")“* → `[ToolBar-Summary]`, `[ToolBar-Bar<n>]`.
- Am Rande: `CMainFrame::SaveBarState` schaltet zuerst auf die Registry um (`mainfrm.cpp:2917-2918` *„// Turn on writing to the registry … pApp->m_pszRegistryKey = RegRoot;“*) und liest die Abschnitte dann aus `Qualcomm\Eudora` zurück. Wie sie von dort in die `Eudora.ini` kommen, steht in keiner der 66 Dateien; dass sie dort landen, sagt [E-84](../Intern/BEFUNDE.md#e-84) (*FloatCx/FloatCy*) gemessen nur für `[ToolBar-ToolBarManager]`.

**Vorschlag:** Fundstelle `mainfrm.cpp:5981`/`:2909` statt `:1054`; die zweite Zeile als *„`[ToolBar-Summary]`, `[ToolBar-Bar<n>]` (MFC), `[ToolBar-BarID<n>]` (eigene Schaltflächen, `mainfrm.cpp:1877`)“*.

### <a id="l-132.4"></a>L-132.4 — Die alten Abschnitte werden nur übernommen, wenn es noch kein `[Settings]` gibt

**Gewicht: Kleinkram.** (gemessen)

- `FUNKTIONEN.md:1025` *„Abschnitte **alter** Eudora-Fassungen; findet Eudora sie beim Start, übernimmt es ihren Inhalt nach `[Settings]`“*.
- `rs.cpp:1415-1418` *„// If there's already a [Settings] section, then a conversion has already been done … if (::FileExistsMT(INIPath) && !GetPrivateProfileString(SettingsName, NULL, "", buf, sizeof(buf), INIPath))“* — steht schon ein `[Settings]` in der Datei, bleiben `[Configurations]`, `[Switches]`, `[Miscellaneous]` unbeachtet liegen. Für die `DEudora.ini` gilt dasselbe (`:1422-1427`).

**Vorschlag:** *„… übernimmt es ihren Inhalt beim Start nach `[Settings]`, aber nur, solange die Datei noch kein `[Settings]` hat; danach werden sie nicht mehr gelesen.“*

### <a id="l-132.5"></a>L-132.5 — `GetParams` liest nicht alle 40, `MarkAsDeleted` wird beim Lesen aus dem Gegenteil gebildet

**Gewicht: Kleinkram.** Wer `MarkAsDeleted` von Hand im Abschnitt eines Kontos ändert, sieht im Dialog keine Wirkung. (gemessen am Quelltext; die Wirkung im laufenden Programm ist nicht gemessen)

- `FUNKTIONEN.md:1038-1040` *„40 Schlüssel, geschrieben von `SavePersonaInfo` (`persona.cpp:931-1078`), gelesen von `GetParams` (`persona.cpp:278-490`)“*.
- Die Kennungen in `persona.cpp:278-490` gegen die in `:931-1078` (`comm -3`): `GetParams` fehlen `IDS_INI_IMAP_MARK_DELETED` und `IDS_INI_SAVE_PASSWORD_TEXT`. Statt `MarkAsDeleted` zu lesen, setzt `persona.cpp:431-432` *„// This is always the opposite of bIMAPXferToTrash. params.bIMAPMarkDeleted = !params.bIMAPXferToTrash;“*.

**Vorschlag:** *„gelesen von `GetParams` (38 davon; `MarkAsDeleted` ergibt sich dort aus `TransferToTrashOnDelete`, `SavePasswordText` liest es nicht)“*.

### <a id="l-132.6"></a>L-132.6 — „Ein Eintrag im falschen Abschnitt wirkt nicht“ steht direkt hinter seiner Ausnahme; EINSTELLUNGEN, auf die verwiesen wird, sagt es enger

**Gewicht: Kleinkram.** (gemessen)

- `FUNKTIONEN.md:999-1002` *„ein Schlüssel, der in `[Debug]` gehört, aber in `[Settings]` steht, wird über Stufe 1 gefunden und **scheint zu wirken** …“*, unmittelbar danach `:1003` *„Ein Eintrag im falschen Abschnitt wirkt nicht, und Eudora meldet nichts.“* Ebenso ohne Einschränkung `:481` und `:949`. Nach der eigenen Suchreihenfolge wirkt ein Eintrag im Abschnitt der **aktiven** Persönlichkeit immer (Stufe 1, `rs.cpp:451`) — auch einer, der „eigentlich“ nach `[Debug]` gehört; nicht gefunden wird er nur, wenn er weder im Abschnitt der aktiven noch in dem seiner Nummer steht.
- Der Beleg dafür ist `Intern/EINSTELLUNGEN.md` Regel 1.3 (`:69-70`) *„Solange es nur eine Persönlichkeit gibt, heißt deren Abschnitt wörtlich `[Settings]`“* — der Code macht das **immer** fürs Hauptkonto, unabhängig von der Zahl (`persona.cpp:904-907`, siehe Tabelle oben); FUNKTIONEN sagt es richtig (*„beim Hauptkonto (`<Dominant>`) ist das `[Settings]`“*), die verlinkte Regel enger.
- Regel 1.2 (`EINSTELLUNGEN.md:63-67`) endet mit *„Die vollständige Tabelle steht in [README.md](../README.md).“* — die README hat keine solche Tabelle (`grep -ci 'DEudora\|vier Stufen\|GetIniString' README.md` → 0). Die vollständige Beschreibung steht jetzt in FUNKTIONEN Abschnitt 6.

**Vorschlag:** `FUNKTIONEN.md:1003` als *„Sonst wirkt ein Eintrag im falschen Abschnitt nicht …“*; in EINSTELLUNGEN 1.3 *„Der Abschnitt des Hauptkontos heißt wörtlich `[Settings]`“*, in 1.2 den Verweis auf FUNKTIONEN Abschnitt 6.

### <a id="l-132.7"></a>L-132.7 — Die Anwenderseite empfiehlt ein Werkzeug, das nicht im Paket liegt

**Gewicht: Kleinkram.** Auf `Einstellungen.html` liest ein Anwender zweimal *„perl tools/pruefe-ini-abschnitte.pl --was &lt;Name&gt;“* (gemessen an der erzeugten Seite) — Perl und `tools\` hat er nicht. (gemessen; dass das Paket kein `tools\` enthält, ist belegt aus `tools/paket-bauen.ps1`, wo `pruefe-ini-abschnitte` nur im Kommentar `:685` vorkommt)

- Neu `FUNKTIONEN.md:1004` *„Wohin ein Schlüssel gehört, sagt `perl tools/pruefe-ini-abschnitte.pl --was <Name>`.“*; schon vorher `:951`.
- `hilfe-html.pl` macht Verweise auf `tools/` zu reinem Text (`WERKZEUGE.md:58`), Befehlszeilen im Fließtext sieht es nicht.

**Vorschlag:** Für die Seite reicht der Hinweis *„die Spalte *Abschnitt* in den Tabellen oben“*; der Werkzeugaufruf gehört nach `Intern/EINSTELLUNGEN.md`, wo er schon steht (`:59-60`).

### <a id="l-132.8"></a>L-132.8 — LDAP liest aus seiner Datei nur eine Vorlage

**Gewicht: Kleinkram.** (belegt am Quelltext; wohin `m_ConfigIO` schreibt, ist eine Vermutung)

- `FUNKTIONEN.md:1027-1030` *„Die Verzeichnisdienste (LDAP, Ph) lesen ihre Einstellungen aus einer eigenen Datei neben ihrem Modul, nicht aus der `Eudora.ini`“*.
- `DirectoryServices/LDAP/src/config_init.cpp:247` *„lstrcat( szFileName, "\\LDAPinit.ini" );“*, `:251` liest daraus nur `UpdateRegistry`, `:256-259` *„m_ConfigIO->GetDirDword( "LDAP--Servers", ".Version", … ); if ( … version == 0 \|\| bUpdateRegistry ) StorePreDefinedConfig( szFileName );“* — die Datei ist die Vorlage, die gelesenen Einstellungen kommen aus `m_ConfigIO`; der Schalter heißt *„update registry“*, also vermutlich aus der Registry. Für Ph (`configinit.cpp:82-95`) ist nur der Dateiname neben dem Modul belegt.
- Richtig bleibt: aus der `Eudora.ini` lesen beide nicht.

**Vorschlag:** *„… haben eine eigene Datei neben ihrem Modul (LDAP: `LDAPinit.ini`, nur Vorlage für die eigentliche Ablage) und lesen nicht aus der `Eudora.ini`.“*

## Bestand außerhalb des Schwerpunkts

[LEKTOR-128](LEKTOR-128.md#lektor-128) hat die 66 Dateien zuletzt voll gelesen, [LEKTOR-131](LEKTOR-131.md#lektor-131) den E-39-Zweig. Seit `456c95e1` hat dieser Zweig außer `Doku/FUNKTIONEN.md` nur Zeilen in `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md:58` und `tools/ZWEIGE.md:216` geändert; die drei sind gelesen und stimmen (Zeitordnung in `TESTLAEUFE.md` von 15:31:56 bis 16:12:53 durchgehend; `WERKZEUGE.md:58` nennt die drei Teile und 50 Fälle wie gemessen; `ZWEIGE.md:216` *„**Von Gregor bestätigt** (*„ja, funktionen_ini_abschnitte ist ok“*)“*). Die Stand-Köpfe von README, CHANGELOG, PAKETE, ZIEL und TESTPLAN nennen weiter `v7.2.1.131` als zuletzt veröffentlicht, `VERSION` ist `7.2.1.131`. Was auf `main` seit #206 noch „nicht gemergt“ sagt, steht oben unter [L-131.2](LEKTOR-131.md#l-131.2) und wird mit `e39_persona_loeschen` berichtigt.

Persönliche Angaben: im Diff `456c95e1..HEAD` und in beiden Commit-Nachrichten keine (gelesen; `grep -ci 'Users\\\|@….de\|Eudora72-'` über die hinzugefügten Zeilen → 0). Die erzeugte `Einstellungen.html` nennt keinen Namen (`grep -c Gregor` → 0).

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): 52 geprüfte Dateien, 176 Kennungen, *„Kein Widerspruch gefunden.“*; *Zur Kenntnis* wie in [LEKTOR-131](LEKTOR-131.md#lektor-131) (u. a. `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` höchste Fassung 7.2.1.128, `Doku/FAQ.md` 7.2.1.130). [L-132.1](#l-132.1) bis [L-132.8](#l-132.8) sieht es nicht — es prüft keine Zeilenangaben und keine Aussagen über den Quelltext.

`perl tools/offene-befunde.pl` (gemessen): *„52 offene Befunde, in beiden Listen gleich.“* — zwei weniger als [LEKTOR-131](LEKTOR-131.md#lektor-131) auf `e39_persona_loeschen`, weil [E-203](../Intern/BEFUNDE.md#e-203) und [E-204](../Intern/BEFUNDE.md#e-204) nur dort stehen; *„davon NIE gemessen 16“*.

`perl tools/pruefe-regressionstest.pl` (gemessen): *„mit Testfall im Pruefstand 62 von 70“*, *„OHNE jede Pruefung 6 <- Rueckstand: [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39)“* — hier steht [E-39](../Intern/BEFUNDE.md#e-39) noch darunter, weil der Zweig von `main` abgeht, wo [E-39](../Intern/BEFUNDE.md#e-39) noch *kritisch* und ohne Fall ist; *„Kein neues "behoben" ohne Regressionstest.“*

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* — trotz `ZIEL.md:122` ([L-131.2](LEKTOR-131.md#l-131.2) auf `main`); das Werkzeug liest die Kriterien, nicht diesen Absatz.

`perl tools/hilfe-html.pl --selbsttest` (gemessen, Zwischendateien im Scratchpad): *„50 ok, 0 FEHLER“*. Es prüft, dass der neue Teil samt Sprungziel auf der Seite ist, nicht, was er über den Quelltext sagt.

## Was nur Gregor entscheiden kann

1. **Sollen die Zweige auf GitHub gelöscht werden, die noch die Datei mit der persönlichen Angabe tragen** ([L-130.1](LEKTOR-130.md#l-130.1): eine Gedächtnisdatei mit einer Angabe, die nicht ins Repo soll)? `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; `main` und dieser Zweig sind frei davon. Unverändert seit [LEKTOR-131](LEKTOR-131.md#lektor-131).

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Gegengelesen: `git diff affd031c..origin/funktionen_ini_abschnitte` (Stand `90decc23`, *„Merge origin/main (#207, [E-39](../Intern/BEFUNDE.md#e-39)) nach [LEKTOR-132](#lektor-132); [LEKTOR-132](#lektor-132) eingearbeitet“*), Arbeitsbaum vorgespult mit `tools/arbeitsbaum-angleichen.sh`. Nichts gebaut, nichts gestartet.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-132.1](#l-132.1) Merge mit `e39_persona_loeschen`, `persona.cpp`-Angaben | **erledigt** | `main` (#207) ist hereingeholt; `Doku/FUNKTIONEN.md` nennt `persona.cpp:903-938` (`GetProfileInt` steht auf `:903`, `GetProfileString` endet `:938`), `:958-967` und `:958-1105` (`SavePersonaInfo` auf `:958`) — treffen |
| [L-132.2](#l-132.2) Testplan, [A-5](../Intern/BEFUNDE.md#a-5), CHANGELOG | **erledigt** | `Intern/TESTPLAN.md` Schritt 3 *„… und am Ende *6. Die Abschnitte der `Eudora.ini`* mit der Liste der Schlüssel, die ein zusätzliches Konto eigens haben kann“*; [A-5](../Intern/BEFUNDE.md#a-5) *„`--selbsttest` 50 Fälle“*, *„171 Zeilen `[Settings]` und 26 …“*; `CHANGELOG.md:124` nennt die Abschnitte und die 46 Schlüssel |
| [L-132.3](#l-132.3) `[ToolBar-…]` | **erledigt** | `FUNKTIONEN.md:1030-1032`: gewöhnlicher Weg `mainfrm.cpp:5981`/`:2909`, eigene Zeile `[ToolBar-BarID<n>]` (`:1877`), `[ToolBar-Summary]`, `[ToolBar-Bar<n>]` aus der MFC, Weg über die Registry als **unklar** gekennzeichnet |
| [L-132.4](#l-132.4) alte Abschnitte | **erledigt** | *„aber nur, solange die Datei noch kein `[Settings]` hat; danach werden sie nicht mehr gelesen“*, Bedingung `rs.cpp:1415-1418` |
| [L-132.5](#l-132.5) `GetParams` | **erledigt** | *„Gelesen werden davon 38 von `GetParams` … `MarkAsDeleted` bildet es dort aus dem Gegenteil von `TransferToTrashOnDelete` (`persona.cpp:431-432`)“* — `:431` *„This is always the opposite of bIMAPXferToTrash.“* trifft |
| [L-132.6](#l-132.6) „falscher Abschnitt wirkt nicht“ | **erledigt in FUNKTIONEN und EINSTELLUNGEN 1.2/1.3; ein Rest** | `FUNKTIONEN.md` an allen drei Stellen mit der Ausnahme des aktiven Kontos; `EINSTELLUNGEN.md` 1.3 *„Der Abschnitt des Hauptkontos heißt wörtlich `[Settings]` — immer, unabhängig von der Zahl der Persönlichkeiten“*, 1.2 verweist auf FUNKTIONEN Abschnitt 6. Rest: `Intern/EINSTELLUNGEN.md:50-51` (Regel 1.1) sagt weiter ohne Einschränkung *„**Ein Eintrag im falschen Abschnitt wirkt nicht — ohne jede Meldung.**“* — die Ausnahme steht zwei Regeln weiter in 1.3, Kleinkram |
| [L-132.7](#l-132.7) Perl-Aufruf auf der Anwenderseite | **erledigt** | in den Teilen der Hilfeseiten kein `perl ` mehr; einziger Treffer in `FUNKTIONEN.md` ist `:34` in der Einleitung, die nicht auf die Seiten kommt |
| [L-132.8](#l-132.8) LDAP | **erledigt** | *„Bei LDAP heißt sie `LDAPinit.ini` und ist nur die **Vorlage** …; vermutlich die Registry … — nicht nachgesehen“*, `config_init.cpp:247-259` |

**Merge-Teile aus `main` auf Verlust geprüft** (gemessen): 13 Dateien sind gleich mit `origin/main` (`88142c78`), darunter `persona.cpp`, `TestE39.cpp`, `messen-e39.ps1`, `pruefstand-faelle.txt`, `LEKTOR-131.md`, `PRUEFER-85.md`, `README.md`, `ZIEL.md`, `WEITERMACHEN.md`, `FAQ.md`. In den übrigen (`CHANGELOG.md`, `FUNKTIONEN.md`, `BEFUNDE.md`, `EINSTELLUNGEN.md`, `TESTPLAN.md`, `WERKZEUGE.md`, `hilfe-html.pl`) fehlt keine Zeile, die `main` gegenüber `456c95e1` neu hat (`comm` über sortierte Zeilen, je 0). Die Änderungen an diesem Bericht in `90decc23` sind nur Verweise auf [LEKTOR-131](LEKTOR-131.md#lektor-131) und die Kennungen, die jetzt im Baum liegen.

### <a id="l-132.9"></a>L-132.9 — Nach #207 heißt `e39_persona_loeschen` weiter „laufend“

**Gewicht: Kleinkram, dieselbe Klasse zum achten Mal** ([L-128.2](LEKTOR-128.md#l-128.2): nach dem Merge bleibt „läuft/Zweig“ stehen). (gemessen; beide Stellen stehen so auch auf `main`)

- `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `e39_persona_loeschen` ([E-39](../Intern/BEFUNDE.md#e-39) im Quellstand behoben …)“* — `88142c78` ist *„Merge pull request #207 from HansWurst81675/e39_persona_loeschen“*. Der laufende Zweig `funktionen_ini_abschnitte` steht dort nicht.
- `CHANGELOG.md:118` *„**Zweig `e39_persona_loeschen`, Quellstand weiter 7.2.1.131 — nur übersetzt …**“* — ohne „gemergt als #207“, während der Block darunter (`:122`) *„auf `main` seit #206“* sagt.

**Vorschlag:** *„auf `main` seit #207“* an beiden Stellen, im Stand-Kopf `funktionen_ini_abschnitte` nennen. Die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) fehlt weiter.

Werkzeuge nach dem Merge: `perl tools/offene-befunde.pl` *„54 offene Befunde, in beiden Listen gleich.“* (mit [E-203](../Intern/BEFUNDE.md#e-203) und [E-204](../Intern/BEFUNDE.md#e-204) aus #207).
