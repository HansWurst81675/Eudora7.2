# <a id="lektor-131"></a>LEKTOR-131 — Bestand nach E-39 (gelöschte Persönlichkeit), Zweig e39_persona_loeschen nach 1721eee2 (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-130](LEKTOR-130.md#lektor-130).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102l`, abgezweigt von `origin/e39_persona_loeschen`, Stand `1721eee2` (*„Merge remote-tracking branch 'origin/main' into e39_persona_loeschen“*).
Umfang: Bestand aller 66 MD-Dateien außerhalb von `Arbeitsweise/` und `Befunde/` (`git ls-files '*.md'`, gezählt). Schwerpunkt: der Zweig gegenüber `456c95e1` (Merge von #206, Stand von `main`) — 9 Commits, 15 Dateien, 648 Zeilen hinzu, 8 weg (`git diff --stat`, gemessen), davon 7 MD-Dateien außerhalb des Ausschlusses: `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `README.md`, `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`. Dazu `tools/pruefstand-faelle.txt` und die beiden Merges `dcfe9570` (PRÜFER-85 hinein) und `1721eee2` (`main` hinein). Nichts gebaut, nichts gestartet.

## Kurz

Die Behebung selbst ist stimmig beschrieben: [E-39](../Intern/BEFUNDE.md#e-39) (das Löschen der in dem Moment „aktuellen“ Persönlichkeit hinterließ einen leeren Rest in der `Eudora.ini`) steht in BEFUNDE, README, CHANGELOG und WEITERMACHEN gleich — Stufe *unkritisch*, Weg über *Change Password* mit einem POP-Konto ohne „@“, Befehl ab Werk ausgeblendet, gewöhnliches Löschen nicht betroffen —, und der Quelltext in `persona.cpp` sowie die Stellen in `password.cpp`, `rs.cpp`, `GetMail.cpp` passen zu den Zeilenangaben (gemessen). Die neuen Befunde [E-203](../Intern/BEFUNDE.md#e-203) (*Change Password* schaltet bei einem Konto ohne „@“ nicht zurück) und [E-204](../Intern/BEFUNDE.md#e-204) (das Kennwort einer gelöschten, nicht aktuellen Persönlichkeit bleibt im Speicher) sind am Quelltext richtig belegt. **Nicht in Ordnung sind die Spuren des Merges von `main`:** eine doppelte Zeile in `ZWEIGE.md` bringt das alte *„Nicht auf GitHub“* zurück, im CHANGELOG klebt der 7.2.2-Kopf ohne Leerzeile am E-39-Punkt, und #206 hat in `mainfrm.cpp` und `EudoraRes.rc` Zeilen eingefügt, so dass die gestern geschriebenen Zeilenangaben in [E-39](../Intern/BEFUNDE.md#e-39), [E-203](../Intern/BEFUNDE.md#e-203) und `Doku/FUNKTIONEN.md` nicht mehr treffen. Dazu sagen CHANGELOG, WEITERMACHEN und ZIEL weiter, `hilfe_menue` sei nicht gemergt; die FAQ rät weiter zum Umweg, den die README jetzt für unnötig erklärt; nach dem Merge ist kein Bau und kein Testlauf vermerkt (der `pre-push`-Haken hat beim Sichern dieses Berichts 367 von 367 Tests grün gemessen; BEFUNDE nennt 364). Acht Funde, keiner am Programmcode.

## Funde aus LEKTOR-130 — heutiger Stand

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-130.1](LEKTOR-130.md#l-130.1) persönliche Angabe in der Geschichte von `hilfe_menue` | **für `main` erledigt; Zweige stehen noch** | `git log 253a8a40..456c95e1` → nur `be813455` und der Merge `456c95e1` (#206 aus `hilfe_menue_7_2_2`, ein Commit); `git merge-base --is-ancestor d9ae24c8 origin/main` → nein, ebenso für `HEAD` dieses Zweigs. `git branch -r --contains d9ae24c8` → weiter `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d` |
| [L-130.2](LEKTOR-130.md#l-130.2) „7.2.2.0“ | **erledigt** | `Intern/TESTPLAN.md:429` *„Mit 7.2.2.132: Help → …“*, `:444` *„Fassung 7.2.2.132“* |
| [L-130.3](LEKTOR-130.md#l-130.3) 7.2.2-Block im Release-Abschnitt | **erledigt, durch den Merge beschädigt** | `CHANGELOG.md:116` *„## Im Quellstand, noch in keinem Paket“*, das Release ab `:128`; aber `:120`/`:121` ohne Leerzeile, siehe [L-131.1](#l-131.1) |
| [L-130.4](LEKTOR-130.md#l-130.4) ZIEL.md „umgesetzt ist davon noch nichts“ | **erledigt, inzwischen überholt** | `ZIEL.md:122` *„Umgesetzt im Zweig `hilfe_menue`, am Prüfstand gemessen“* — seit #206 auf `main`, siehe [L-131.2](#l-131.2) |
| [L-130.5](LEKTOR-130.md#l-130.5) Logzeile erst nach dem Beenden | **erledigt** | `Intern/TESTPLAN.md:456` *„5. **Erst nach dem Beenden** von Eudora“* |
| [L-130.6](LEKTOR-130.md#l-130.6) „laufend“ nach dem Merge, „nicht auf GitHub“ | **Rückfall** | `tools/ZWEIGE.md:210` *„**Stand:** gemergt als #205“* richtig; aber `:212` ist wieder die alte Zeile `paket_7_2_1_131` mit *„Nicht auf GitHub, bis Gregor lokal getestet hat“*, neben der richtigen in `:214` ([L-131.1](#l-131.1)); `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `hilfe_menue`“* nach #206 ([L-131.2](#l-131.2)) |
| [L-130.7](LEKTOR-130.md#l-130.7) Marke „Vorlage“ | **erledigt** | `Doku/FUNKTIONEN.md:16` Legende *„am Prüfstand gemessen“*; `:264-265` tragen sie |
| [L-130.8](LEKTOR-130.md#l-130.8) Commit im Seitenkopf | **erledigt** | `tools/hilfe-html.pl:184` *„return "$datei_datum (nicht committet)" if $st =~ /\S/;“* |
| [L-130.9](LEKTOR-130.md#l-130.9) Verweise auf eine Marke, die es noch nicht gibt | **erledigt** | `tools/hilfe-html.pl:186` *„$GITHUB = $REPO . "$5/";“* — Verweise auf den Commit der Quelle |
| Hinweis aus [Nachtrag 2](LEKTOR-130.md#nachtrag-2-02-11-2026): Commit der Quelle nur auf `hilfe_menue` | **entkräftet** (belegt) | `git log -1 origin/main -- Doku/FUNKTIONEN.md` → `be813455`, ein Commit auf `main`. Ein Paket aus `main` verlinkt also auf einen Commit, der auf `main` liegt; `1aa731fc` betraf nur die Prüfstandsseiten unter `C:\Temp\EHILFE` |
| [L-129.1](LEKTOR-129.md#l-129.1) Schranke „zuletzt veröffentlicht“ | **offen** | `tools/pruefe-release-buchfuehrung.pl` zuletzt geändert in `cf6c3fee`; `grep -c 'zuletzt ver'` → 0 |
| [L-128.2](LEKTOR-128.md#l-128.2) Schranke gegen „läuft/PR folgt“ nach dem Merge | **offen, siebtes Auftreten** | `grep -l 'PR folgt\|Laufend' tools/*.pl` → kein Treffer; die Wiederholung steht als [L-131.2](#l-131.2) |
| [L-128.3](LEKTOR-128.md#l-128.3) Schranke gegen einen Entwurfskopf in der Notizdatei | **offen** | `tools/release-veroeffentlichen.ps1:128` *„if ($text -match 'noch nicht best')“* prüft nur den CHANGELOG-Abschnitt; `:261` reicht die Notizdatei ungeprüft an `--notes-file` |
| [L-128.8](LEKTOR-128.md#l-128.8) Berichtszahl in der README | **offen** | siehe [L-131.8](#l-131.8) |
| [L-126.1](LEKTOR-126.md#l-126.1) Schritt im Webmailer prüft vermutlich das falsche Datum | **teilweise** (unverändert) | `Intern/TESTPLAN.md:409` *„Im lokalen *In* eine Mail aussuchen, deren Uhrzeit du kennst“* |
| [L-126.5](LEKTOR-126.md#l-126.5) Starts ohne Titelzeile in `tools/TESTLAEUFE.md` | **teilweise** (unverändert) | vom 02.11. 64 Zeilen, davon 10 ohne `[Eudora` (`grep '^| 2026-11-02' … \| grep -vc '\[Eudora'`); alle neuen E-39-Zeilen tragen die Titelzeile, z. B. *„[Eudora 7.2.1.131+52013cac 2026-11-02 16:11 - E39]“* |

## E-39, E-203, E-204 gegen den Quelltext

| Aussage | Stelle | Gegen (gemessen) |
|---|---|---|
| `Remove` schaltet nur, wenn die gelöschte die aktuelle war, und vergisst ihr Kennwort erst nach dem Umschalten | `Intern/BEFUNDE.md:455` (*„erst nach dem Umschalten, weil `SavePassInfo` es beim Umschalten noch einmal ablegt“*) | `Eudora71/Eudora/persona.cpp:588-594`: *„bWarAktuell = ( m_Current.CompareNoCase( PersonaID ) == 0 )“*, dann `RemoveIniFromCache` zweimal, `SetCurrent( NULL )`, `m_Passwords.RemoveKey( PersonaID )` |
| Spurzeile *„[E-39](../Intern/BEFUNDE.md#e-39) Remove <Name>: war-aktuell=<0\|1> aktuell=<…>“* | `BEFUNDE.md:455`, `pruefstand-faelle.txt:363-364` | `persona.cpp:597-599`, `PutDebugLog( DEBUG_MASK_MISC, strSpur )` |
| `SavePassInfo` legt das Kennwort unter dem Namen der aktuellen ab; `RemoveKey` steht nur im `if` | `BEFUNDE.md:400` ([E-204](../Intern/BEFUNDE.md#e-204): `persona.cpp:1107-1113`, `:594`, `:1159`) | `persona.cpp:1107` *„void CPersonality::SavePassInfo( void )“*, `:1113` *„m_Passwords[m_Current] = POPPassword;“*, `:594` RemoveKey, `:1159` *„m_Passwords.Lookup(strPersona, POPPassword)“* — alle vier treffen |
| `Add` legt das Spool-Verzeichnis an | `BEFUNDE.md:455` (*„`persona.cpp:262`“*) | `persona.cpp:262` *„QCSpoolMgrMT::CreateSpoolMgr(Params.PersName);“* |
| *Change Password* schaltet um und kehrt bei Konto ohne „@“ ohne Zurückschalten zurück | `BEFUNDE.md:401` ([E-203](../Intern/BEFUNDE.md#e-203): `password.cpp:451-452`, `:457-467`, `:521-522`, `:531-532`) | `password.cpp:452` *„g_Personalities.SetCurrent( NewPersona );“*, `:458-459` `IDS_ERR_NO_POP_ACCT` / `return (FALSE)`, `:466-467` `IDS_ERR_BAD_POP_ACCT` / `return (FALSE)`, `:522` und `:532` *„g_Personalities.SetCurrent( OrgPersona );“* |
| `GetIniString` liest zuerst den Abschnitt der aktuellen; die Mailprüfung stellt am Ende zurück | `BEFUNDE.md:401` (`rs.cpp:441-451`, `GetMail.cpp:245`) | `rs.cpp:442` *„CString Personality = g_Personalities.GetCurrent();“*, `:451` `GetProfileString(Personality, …)`; `GetMail.cpp:245` *„g_Personalities.SetCurrent( homie );“* |
| `RemoveChangePassword` eingebaut `1`, nimmt den Menüeintrag heraus | `BEFUNDE.md:401`, `:455` (`mainfrm.cpp:8372-8373`, `EudoraRes.rc:11283`) | **trifft seit #206 nicht mehr** — heute `mainfrm.cpp:8487-8488`, `EudoraRes.rc:11290` ([L-131.4](#l-131.4)) |
| Fehlerfälle `compmsgd.cpp:2251`, `ImapDownload.cpp:1033` | `BEFUNDE.md:455` | `compmsgd.cpp:2251` *„return (NewCompDoc);	// error creating document“*; `Eudora71/EuImap/src/ImapDownload.cpp:1033` *„return E_FAIL;“* nach `OpenMbxFile (FALSE)` — beide treffen |
| Stufe *unkritisch* überall gleich | `BEFUNDE.md:455`, `CHANGELOG.md:71`, `:120`, `Intern/WEITERMACHEN.md:120` | gleich; `perl tools/pruefe-regressionstest.pl` führt [E-39](../Intern/BEFUNDE.md#e-39) nicht mehr unter den Kritischen (*„mit Testfall im Pruefstand 62 von 69“*) |
| Fälle `E-39p`/`E-39v`/`E-39w` grün am Bau `52013cac` | `BEFUNDE.md:455`, `CHANGELOG.md:120` | `Intern/pruefstand-buch.tsv`: *„E-39p ok 2026-11-02 16:12:33 … war-aktuell=1 aktuell-danach=<Dominant> lebt=1“*, `E-39v ok`, `E-39w ok`; `tools/pruefstand-faelle.txt:368-370` |
| `messen-e39.ps1` gibt `war-aktuell=` aus, `E-39v` zählt nur die Meldung mit „machine name“ | `pruefstand-faelle.txt:363-365` | `tools/messen-e39.ps1:347` (Ausgabezeile mit `' war-aktuell='`), `:237` *„if ($txt -like '*machine name*')“* — aber `tools/WERKZEUGE.md:155` nicht nachgezogen ([L-131.7](#l-131.7)) |

## Funde

### <a id="l-131.1"></a>L-131.1 — Der Merge von `main` hat drei Listen nicht sauber vereinigt

**Gewicht: mittel.** Eine der drei Spuren bringt eine schon berichtigte falsche Aussage zurück. (gemessen; die Darstellung im CHANGELOG belegt aus der CommonMark-Regel, nicht gerendert)

- `tools/ZWEIGE.md:212` und `:214` — zwei Zeilen `paket_7_2_1_131` (`grep -c` → 2; auf `main` → 1). `:212` ist die alte Fassung *„Nicht auf GitHub, bis Gregor lokal getestet hat.“*, `:214` die berichtigte *„**Stand:** von Gregor lokal getestet, das ZIP ist als `v7.2.1.131` … veröffentlicht“*. Die alte Zeile kam aus der Zweigseite (`7e38b87b` hatte `e39_persona_loeschen` neben ihr eingetragen); das ist der Rückfall von [L-130.6](LEKTOR-130.md#l-130.6).
- `CHANGELOG.md:120-121` — der E-39-Punkt (`* **Eine gelöschte Persönlichkeit kommt nicht mehr …**`) endet ohne Leerzeile, die nächste Zeile ist *„**Für 7.2.2 — Zweig `hilfe_menue`** (noch nicht gemergt …)“*. Ohne Leerzeile setzt Markdown diese Zeile als Fortsetzung des E-39-Punkts — der Kopf des 7.2.2-Blocks steht dann im Text des E-39-Eintrags.
- `tools/pruefstand-faelle.txt:370-371` — nach `E-39w` folgt direkt *„# [A-5](../Intern/BEFUNDE.md#a-5) - Hilfe-Menue …“*; die Leerzeile und die obere Trennlinie `# ----` des A-5-Blocks fehlen (sie stehen jetzt über dem E-39-Block, `:356`). Beide Seiten zusammen 386 Zeilen erwartet, im Stand 384.
- `tools/TESTLAEUFE.md` — die EHILFE-Starts von 14:39:59 bis 16:01:13 stehen hinter den E39-Starts von 15:44:41, vor 16:12:30; das Protokoll ist an dieser Stelle nicht mehr zeitlich geordnet.
- Sonst ist vereinigt, was zu vereinigen war: gegen beide Eltern (`dcfe9570`, `456c95e1`) fehlt in `CHANGELOG.md`, `Intern/BEFUNDE.md`, `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/pruefstand-faelle.txt` keine Zeile außer den ersetzten alten E-39-Zeilen und der erzeugten Stufentabelle (`sort | comm -23`, gemessen). Keine Konfliktmarken (`git grep '^<<<<<<<'` leer), keine doppelten Anker in `BEFUNDE.md`.

**Vorschlag:** `ZWEIGE.md:212` streichen, Leerzeile nach `CHANGELOG.md:120`, Trennlinie und Leerzeile vor `pruefstand-faelle.txt:371`; die TESTLAEUFE-Zeilen nach Zeit ordnen oder so lassen und einmal vermerken.

### <a id="l-131.2"></a>L-131.2 — `hilfe_menue` ist seit #206 auf `main`, drei Stand-Stellen sagen anderes

**Gewicht: mittel, und dieselbe Klasse zum siebten Mal** ([L-128.2](LEKTOR-128.md#l-128.2): nach dem Merge bleibt „läuft/nicht gemergt“ stehen). (gemessen) Die ersten drei Stellen stehen so auch auf `main` selbst — #206 hat sie nicht nachgezogen.

- `CHANGELOG.md:121` *„**Für 7.2.2 — Zweig `hilfe_menue`** (noch nicht gemergt, noch in keinem Paket …)“* — `456c95e1` ist *„Merge pull request #206 from HansWurst81675/hilfe_menue_7_2_2“*.
- `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `hilfe_menue` (Hilfe-Menü für 7.2.2, [A-5](../Intern/BEFUNDE.md#a-5), am Prüfstand gemessen, PRÜFER-84 und [LEKTOR-130](LEKTOR-130.md#lektor-130) eingearbeitet)“*; der laufende Zweig `e39_persona_loeschen` kommt im Stand-Kopf nicht vor (`grep -c e39_persona Intern/WEITERMACHEN.md` → 0).
- `ZIEL.md:122` *„**Umgesetzt im Zweig `hilfe_menue`, am Prüfstand gemessen**“*.
- `tools/ZWEIGE.md:216` `hilfe_menue_7_2_2` ohne *Stand* (die Zeile `release_7_2_1_131_doku`, `:210`, zeigt, wie er aussieht: *„**Stand:** gemergt als #205“*).

**Vorschlag:** *„auf `main` seit #206“* an allen vier Stellen; im Stand-Kopf `e39_persona_loeschen` nennen. Die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) sollte genau diese Sätze gegen `git branch -r --merged origin/main` halten.

### <a id="l-131.3"></a>L-131.3 — Die FAQ rät weiter zu dem Umweg, den die README jetzt für unnötig erklärt

**Gewicht: mittel.** Ein Anwender liest in der FAQ einen Ratschlag, den die README zwei Klicks weiter widerlegt. (gemessen)

- `Doku/FAQ.md:153-155` *„**Vorsicht beim Löschen:** vor dem Löschen der gerade benutzten Persönlichkeit auf eine andere wechseln (bekannter Fehler [E-39](../Intern/BEFUNDE.md#e-39) in der README).“*
- Dagegen `README.md:164` *„Das gewöhnliche Löschen über *Personalities → Delete* ist nicht betroffen (am Prüfstand gemessen)“*, Abhilfe *„nach einer solchen Fehlermeldung Eudora einmal beenden und neu starten, bevor Sie die Persönlichkeit löschen. **Im Quellstand behoben (02.11.2026), kommt mit dem nächsten Paket**“*. Die alte README-Zeile, auf die die FAQ sich stützte (*„vorher auf eine andere Persönlichkeit wechseln“*), hat `cf126b0d` ersetzt; die FAQ ist im Zweig nicht geändert.
- Dasselbe Missverständnis im Titel: `Intern/BEFUNDE.md:455` *„wird die **aktuell benutzte** Persönlichkeit gelöscht“*, daraus erzeugt `CHANGELOG.md:71` und `Intern/WEITERMACHEN.md:120`. „Aktuell benutzt“ liest ein Anwender als „die, mit der ich gerade arbeite“; gemeint ist Eudoras interne „aktuelle“, die man nur über *Change Password* dorthin bekommt (`BEFUNDE.md:455`, *Kurz*).
- Am Rande: `Intern/AUFGABEN.md:273-286` (Abschnitt *4. [E-39](../Intern/BEFUNDE.md#e-39)*) beschreibt den alten Stand (*„Offen, nicht am laufenden Programm bestätigt“*); die Datei erklärt sich in `:3` selbst zum Stand vom 29.10.2026 — kein eigener Fund.

**Vorschlag:** In der FAQ den Absatz auf den README-Wortlaut bringen oder streichen (ab dem nächsten Paket ist er gegenstandslos); den Titel von [E-39](../Intern/BEFUNDE.md#e-39) auf *„wird die Persönlichkeit gelöscht, die Eudora in dem Moment als ‚aktuelle‘ führt (nur nach *Change Password*)“*.

### <a id="l-131.4"></a>L-131.4 — #206 hat Zeilen eingefügt; die gestern geschriebenen Zeilenangaben in `mainfrm.cpp` und `EudoraRes.rc` treffen nicht mehr

**Gewicht: mittel.** Wer der Angabe folgt, landet in fremdem Code. (gemessen an Stichproben; der Gesamtumfang ist eine Vermutung)

- #206 fügt in `mainfrm.cpp` ab Zeile 6118 115 Zeilen ein und in `EudoraRes.rc` ab 5844 und 7356 zusammen 7 (`git diff 253a8a40 456c95e1 | grep '^@@'`).
- `Intern/BEFUNDE.md:401` ([E-203](../Intern/BEFUNDE.md#e-203)) und `Doku/FUNKTIONEN.md:215`, `:963` nennen `mainfrm.cpp:8372-8373` für `RemoveChangePassword` — heute `mainfrm.cpp:8487-8488` (*„if (GetIniShort(IDS_INI_REMOVE_CHANGE_PASSWORD))“*); in `8372` steht jetzt *„sFindMsgPrefix = sFindMsg.Left(pos);“*.
- `Intern/BEFUNDE.md:455` ([E-39](../Intern/BEFUNDE.md#e-39)) nennt `EudoraRes.rc:11283` (`RemoveChangePassword`), `:10718` (`IDS_PERSONA_PERMANENT_DELETE`), `:9151` (`IDS_ERR_BAD_POP_ACCT`) — heute `:11290`, `:10724`, `:9158`. Am Stand `52013cac` trafen sie (gemessen mit `git show 52013cac:…`).
- `Doku/FUNKTIONEN.md:135` *„`CDynamicSavedSearchMenu`, `mainfrm.cpp:8380`“* — heute `:8495`. Insgesamt nennen die 66 Dateien 48 Stellen `mainfrm.cpp:<n>` mit `n` > 6118 (12 davon in `Doku/FUNKTIONEN.md`, 14 in `Intern/BEFUNDE.md`) und 128 Stellen `EudoraRes.rc:<n>` mit `n` > 5844 (`git grep -o`, gezählt). Wie viele davon vor #206 trafen, ist nicht gemessen.
- Die Angaben in `persona.cpp`, `password.cpp`, `rs.cpp`, `GetMail.cpp`, `compmsgd.cpp`, `ImapDownload.cpp` treffen (Tabelle oben) — diese Dateien hat #206 nicht geändert.

**Vorschlag:** Die E-39-, E-203- und FUNKTIONEN-Stellen jetzt nachziehen. Für die Klasse fehlt ein Werkzeug: `tools/WERKZEUGE.md` kennt keines, das `datei:zeile` in den MD-Dateien gegen den Quelltext hält (`grep -i 'zeilenverweis\|Datei:Zeile'` → nur `fund-punkte.pl`, das zerlegt, aber nicht prüft). Angaben mit einem Textanker (Funktion oder Zitat) neben der Nummer überstehen so einen Merge.

### <a id="l-131.5"></a>L-131.5 — Nach dem Merge von `main` ist weder ein Bau noch ein Testlauf vermerkt

**Gewicht: mittel.** Der Zweig geht mit dem Code von #206 als PR nach `main`; die Zahlen in BEFUNDE und CHANGELOG stammen vom Stand davor. (gemessen; ob der Stand baut, ist nicht gemessen — hier wird nichts gebaut)

- `Intern/BEFUNDE.md:455` *„Tests: 364 Tests, 364 bestanden“*; `52013cac` *„Tests (pruefe-tests-gruen.pl, mit Bau): 364 Tests, 364 bestanden“*, `f611beb7` *„Bau: 0 Fehler, Tests 364/364“* — beide vor `1721eee2`.
- `1721eee2` holt `mainfrm.cpp` (+115), `EudoraRes.rc`, `resource.h`, `TestHilfeMenue.cpp` und `TestMain.cpp` herein; `Eudora71/Tests/TestMain.cpp:215` *„RunE39Tests(szEudoraDir);“* und `:230` *„RunHilfeMenueTests(szEudoraDir);“* stehen jetzt beide drin, `Tests.vcxproj:149`/`:164` ebenso. Die Commit-Nachricht von `1721eee2` nennt nur die Konfliktdateien, kein Testergebnis; ein späterer Commit fehlt.
- Die Fälle `E-39p`/`v`/`w` sind am Bau `52013cac` grün (`pruefstand-buch.tsv`), also ohne das Hilfe-Menü im Programm.
- **Nachtrag beim Sichern dieses Berichts** (gemessen): der `pre-push`-Haken hat beim `git push` die Testsammlung am Stand nach dem Merge gebaut und gefahren (`pruefe-testbau.pl`, danach die Grün-Schranke) und meldete *„Alle 367 Tests bestanden.“* Die Testsammlung baut also und ist grün; die Zahl in `BEFUNDE.md:455` (364) gilt für den Stand vor dem Merge. Das ganze Programm und die Prüfstandsfälle sind damit weiter nicht am gemergten Stand gemessen.

**Vorschlag:** In [E-39](../Intern/BEFUNDE.md#e-39) die Zahl nachziehen (367 am Stand nach dem Merge) oder sagen, an welchem Stand 364 gilt; vor dem PR das Programm selbst einmal am gemergten Stand bauen.

### <a id="l-131.6"></a>L-131.6 — PRÜFER-85 wird genannt, aber nirgends verlinkt

**Gewicht: Kleinkram.** (gemessen)

- `git grep -c 'PRÜFER-85\|PRUEFER-85' -- '*.md' ':!Befunde'` → `CHANGELOG.md:1`, `Intern/BEFUNDE.md:3`; `git grep -c 'PRUEFER-85.md'` → 0. Etwa `CHANGELOG.md:120` *„Herabgestuft auf *unkritisch* (PRÜFER-85 K4)“*, `BEFUNDE.md:455` *„**Erreichbarkeit** (PRÜFER-85 K6, am Quelltext belegt)“*, `:400` *„Gefunden von PRÜFER-85 K3“*.
- Zum Vergleich `CHANGELOG.md:124` *„**Nach [PRÜFER-84](Befunde/PRUEFER-84.md#pruefer-84) und [LEKTOR-130](…)**“*.

**Vorschlag:** Die erste Nennung je Eintrag als `[PRÜFER-85](Befunde/PRUEFER-85.md#pruefer-85)` (aus `Intern/` mit `../`). `tools/befunde-verlinken.pl` setzt nur Befundkennungen, keine Berichtsnamen.

### <a id="l-131.7"></a>L-131.7 — WERKZEUGE nennt die alte Ausgabe von `messen-e39.ps1`

**Gewicht: Kleinkram.** (gemessen)

- `tools/WERKZEUGE.md:155` *„Ausgabe `E39 Vorlauf: …`, `E39 PROBE ok|…` und `E39 ERGEBNIS abschnitt-wieder= schluessel= aktuell-danach= lebt=`“* — ohne `war-aktuell=`.
- `tools/messen-e39.ps1:347` schreibt `… schluessel= … war-aktuell= … aktuell-danach= … lebt=`, `:29` dokumentiert *„war-aktuell=<0|1|->“*; `E-39p` verlangt `war-aktuell=1` (`pruefstand-faelle.txt:368`). Auch dass `E-39v` nur die Meldung mit „machine name“ zählt (`messen-e39.ps1:237`), fehlt in der Zeile. `52013cac` (PRÜFER-85 K5) hat `WERKZEUGE.md` nicht angefasst.

**Vorschlag:** Die Ausgabezeile in `WERKZEUGE.md:155` aus `messen-e39.ps1:29` übernehmen.

### <a id="l-131.8"></a>L-131.8 — Die Berichtszahl in der README ist drei hinterher

**Gewicht: Kleinkram, Wiederholung von [L-128.8](LEKTOR-128.md#l-128.8).** (gemessen)

- `README.md:98` *„(209 LEKTOR- und PRÜFER-Berichte)“*; `ls Befunde | grep -cE '^(LEKTOR|PRUEFER)-[0-9]+\.md$'` → 212 (dazu [LEKTOR-130](LEKTOR-130.md#lektor-130), PRÜFER-84, PRÜFER-85), mit diesem Bericht 213.

**Vorschlag:** Die Zahl weglassen (*„die LEKTOR- und PRÜFER-Berichte“*) oder von `doku-pruefen.pl` gegen das Verzeichnis halten lassen — von Hand veraltet sie mit jedem Bericht.

## Bestand außerhalb des Schwerpunkts

[LEKTOR-128](LEKTOR-128.md#lektor-128) hat die 66 Dateien zuletzt voll gelesen, [LEKTOR-130](LEKTOR-130.md#lektor-130) den Hilfe-Menü-Zweig. Seit `456c95e1` hat dieser Zweig außer den genannten Stellen nichts an MD-Dateien geändert. Die Stand-Köpfe von README, CHANGELOG, PAKETE, ZIEL und TESTPLAN nennen weiter richtig `v7.2.1.131` als zuletzt veröffentlicht; `VERSION` ist `7.2.1.131`, der CHANGELOG-Satz *„Quellstand weiter 7.2.1.131 — nur übersetzt“* (`:118`) stimmt. `Releases/PAKETE.md:1411` *„**[E-39](../Intern/BEFUNDE.md#e-39)** ist offen“* steht in einem alten Paketabschnitt und ist dort richtig. `ZIEL.md:95` führt [E-39](../Intern/BEFUNDE.md#e-39) unter *„Ausdrücklich nicht Voraussetzung“* — passt zur Stufe *unkritisch*. [E-203](../Intern/BEFUNDE.md#e-203) und [E-204](../Intern/BEFUNDE.md#e-204) (Stufe *wichtig*) stehen nicht in der README unter *Bekannte Fehler*; beide sind nie gemessen, die Folgen sind Vermutung — kein Fund.

Persönliche Angaben: im Diff `456c95e1..HEAD` und in den neun Commit-Nachrichten keine (gelesen). Die Datei aus [L-130.1](LEKTOR-130.md#l-130.1) ist nicht in der Geschichte dieses Zweigs (`merge-base --is-ancestor` → nein).

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): 52 geprüfte Dateien, 178 Kennungen, *„Kein Widerspruch gefunden.“*; *Zur Kenntnis* wie in [LEKTOR-130](LEKTOR-130.md#lektor-130) (u. a. `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` höchste Fassung 7.2.1.128, `Doku/FAQ.md` 7.2.1.130). [L-131.1](#l-131.1) bis [L-131.8](#l-131.8) sieht es nicht.

`perl tools/offene-befunde.pl` (gemessen): *„54 offene Befunde, in beiden Listen gleich.“* — zwei mehr als in [LEKTOR-130](LEKTOR-130.md#lektor-130) ([E-203](../Intern/BEFUNDE.md#e-203), [E-204](../Intern/BEFUNDE.md#e-204)); [E-39](../Intern/BEFUNDE.md#e-39) bleibt offen bis zum Paket. Stufentabelle `Intern/BEFUNDE.md:158-162`: offen 7 kritisch, 26 wichtig, 13 unkritisch, 8 Werkzeug.

`perl tools/pruefe-regressionstest.pl` (gemessen): *„mit Testfall im Pruefstand 62 von 69“*, *„OHNE jede Pruefung 5 <- Rueckstand: [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133)“* — [E-39](../Intern/BEFUNDE.md#e-39) ist nicht mehr darunter, weil es *unkritisch* ist, nicht weil es einen Fall bekommen hätte (es hat ihn trotzdem: `E-39p`/`v`/`w`); *„Kein neues "behoben" ohne Regressionstest.“*

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* — trotz `ZIEL.md:122` ([L-131.2](#l-131.2)); das Werkzeug liest die Kriterien, nicht diesen Absatz.

## Was nur Gregor entscheiden kann

1. **Mit welchem Paket kommt die Behebung von [E-39](../Intern/BEFUNDE.md#e-39)** (eine gelöschte Persönlichkeit hinterlässt nach *Change Password* einen leeren Rest in der `Eudora.ini`)? Seit #206 trägt `main` das Hilfe-Menü; ein Paket aus `main` nach dem Merge dieses Zweigs ist also **7.2.2.132** mit Hilfe-Menü und [E-39](../Intern/BEFUNDE.md#e-39). `ZIEL.md:113` und `CHANGELOG.md:121` sagen *„7.2.1.x bleibt die Reihe für Fehlerbehebungen“* — ein 7.2.1-Paket nur mit [E-39](../Intern/BEFUNDE.md#e-39) ginge dann nicht mehr aus `main`. Vorschlag: [E-39](../Intern/BEFUNDE.md#e-39) kommt mit 7.2.2.132 (unkritisch, eigener Sonderbau lohnt nicht, [Pakete sammeln](../Arbeitsweise/pakete-sammeln.md)).
2. **Sollen die Zweige auf GitHub gelöscht werden, die noch die Datei mit der persönlichen Angabe tragen** ([L-130.1](LEKTOR-130.md#l-130.1))? `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; `main` ist frei davon.

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Gegengelesen: `git diff 9463ac3b..origin/e39_persona_loeschen` (2 Commits bis `117d7736`, 12 Dateien, 50 Zeilen hinzu, 44 weg; nach `tools/arbeitsbaum-angleichen.sh`, eigener Arbeitsbaum `.wt/lektor131`). Keine neue Runde, nichts gebaut, nichts gestartet. (gemessen)

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-131.1](#l-131.1) Merge unsauber vereinigt | **erledigt** | Zeilen `paket_7_2_1_131` in `tools/ZWEIGE.md`: 1 (die Zeile mit `v7.2.1.131`); `CHANGELOG.md` Leerzeile zwischen E-39-Punkt und *„**Für 7.2.2 — Zweig `hilfe_menue`**“*; `tools/pruefstand-faelle.txt:371-372` Leerzeile und Trennlinie vor *„# [A-5](../Intern/BEFUNDE.md#a-5) - Hilfe-Menue“*; `tools/TESTLAEUFE.md` die drei EHILFE-Starts 14:39:59–14:41:28 stehen jetzt vor den E39-Starts |
| [L-131.2](#l-131.2) `hilfe_menue` „nicht gemergt“ | **erledigt, Schranke offen** | `CHANGELOG.md` *„(auf `main` seit #206, noch in keinem Paket …)“*; `ZIEL.md:122` *„Umgesetzt, am Prüfstand gemessen, auf `main` seit #206“*; `Intern/WEITERMACHEN.md:3` *„Das Hilfe-Menü für 7.2.2 ([A-5](../Intern/BEFUNDE.md#a-5), Zweig `hilfe_menue_7_2_2`) ist als #206 auf `main`“*, laufend jetzt `e39_persona_loeschen`; `tools/ZWEIGE.md` `hilfe_menue_7_2_2` *„**Stand:** gemergt als #206 (02.11.2026)“*. Die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) fehlt weiter |
| [L-131.3](#l-131.3) FAQ und Titel von [E-39](../Intern/BEFUNDE.md#e-39) | **erledigt** | `Doku/FAQ.md` *„das gewöhnliche Löschen über *Personalities → Delete* ist unbedenklich (am Prüfstand gemessen). Nur wer vorher *Change Password* … aufgerufen … hat, sollte Eudora vor dem Löschen einmal beenden und neu starten“*; `Intern/BEFUNDE.md:455` Titel *„wird die Persönlichkeit gelöscht, die Eudora in dem Moment als „aktuelle“ führt (nur nach *Change Password*)“*, erzeugt in `CHANGELOG.md:71` und `Intern/WEITERMACHEN.md:120`; `grep 'aktuell benutzt\|gerade benutzt'` in FAQ und BEFUNDE → kein Treffer |
| [L-131.4](#l-131.4) Zeilenangaben nach #206 | **für die genannten Stellen erledigt; Klasse offen** | `git grep '8372-8373\|EudoraRes.rc:11283'` außerhalb `Befunde/`, `Arbeitsweise/` → kein Treffer. Stichproben am heutigen Quelltext: `Doku/FUNKTIONEN.md:170` `mainfrm.cpp:8425` *„CDynamicPluginMenu(CA_ATTACH_PLUGIN)“*, `:185` `:8482` *„CDynamicMailboxMenu(NULL, TRUE)“*, `:234` `:10618` *„OnUpdateStatistics“*, `:235` `:7465` *„OnResetTools();“*, `EudoraRes.rc:10725` der Text von `IDS_PERSONA_PERMANENT_DELETE` — alle treffen. Die übrigen Stellen außerhalb von [E-39](../Intern/BEFUNDE.md#e-39), [E-203](../Intern/BEFUNDE.md#e-203) und FUNKTIONEN (z. B. `Intern/FILTER.md`, `Eudora71/OTShim/*.md`) sind nicht nachgezogen, und das vorgeschlagene Werkzeug gegen `datei:zeile` fehlt |
| [L-131.5](#l-131.5) kein Bau nach dem Merge | **erledigt** | `Intern/BEFUNDE.md:455` *„367 Tests, 367 bestanden (am Stand nach dem Merge von #206; vorher … 364 …)“* und *„am Stand nach dem Merge von #206 erneut gefahren, Bau `7.2.1.131+f31dbff9`: Fälle `E-39p`/`E-39v`/`E-39w` 3 von 3 bestanden“*; `Intern/pruefstand-buch.tsv` *„E-39p ok 2026-11-02 16:40:17 … Eudora 7.2.1.131+f31dbff9 …“*; `tools/TESTLAEUFE.md` Start 16:40:15 mit Titelzeile *„[Eudora 7.2.1.131+f31dbff9 2026-11-02 16:38 - E39]“* |
| [L-131.6](#l-131.6) PRÜFER-85 unverlinkt | **erledigt** | `git grep -c 'PRUEFER-85.md' -- '*.md' ':!Befunde'` → `CHANGELOG.md:1`, `Intern/BEFUNDE.md:3`, `tools/WERKZEUGE.md:1` |
| [L-131.7](#l-131.7) WERKZEUGE ohne `war-aktuell=` | **erledigt** | `tools/WERKZEUGE.md:155` nennt `war-aktuell=` und *„`E-39v` zählt als Vorlauf nur die Meldung mit „machine name“ (`IDS_ERR_BAD_POP_ACCT`)“* |
| [L-131.8](#l-131.8) Berichtszahl | **erledigt, von Hand** | `README.md:98` *„(213 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“* = `ls Befunde \| grep -cE …` → 213. Mit dem nächsten Bericht wieder veraltet; die Datumsangabe macht das immerhin sichtbar |

`perl tools/doku-pruefen.pl`: *„Kein Widerspruch gefunden.“*

**Ein Hinweis zu Frage 1:** CHANGELOG, WEITERMACHEN und BEFUNDE nennen jetzt *„das Paket 7.2.2.132 (Gregor: nach dem Release 7.2.1.131 kommt 7.2.2)“* für [E-39](../Intern/BEFUNDE.md#e-39). Das ist Gregors Satz zur Reihenfolge der Fassungen ([entscheidung-7-2-2-umfang](../Arbeitsweise/entscheidung-7-2-2-umfang.md)), nicht ausdrücklich zu [E-39](../Intern/BEFUNDE.md#e-39) — und `CHANGELOG.md` sagt im selben Block weiter *„7.2.1.x bleibt die Reihe der Fehlerbehebungen“*. Inhaltlich folgt es zwingend aus #206 (belegt); ob Gregor dafür ein eigenes Ja geben will, bleibt Frage 1 oben. Frage 2 (Zweige löschen) ist keine offene Frage mehr: Gregor löscht die alten Zweige selbst.

Ergebnis: alle acht Funde eingearbeitet; offen bleiben nur die Klassen (Schranke gegen „nicht gemergt“ nach dem Merge, Werkzeug gegen veraltete Zeilenangaben, Berichtszahl von Hand). Persönliche Angaben im Diff und in den zwei Commit-Nachrichten: keine (gelesen).
