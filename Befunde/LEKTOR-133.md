# <a id="lektor-133"></a>LEKTOR-133 — Bestand nach Speichern unter (E-194 bis E-207), Zweig e194_e196_speichern_unter nach 91a2856f (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-132](LEKTOR-132.md#lektor-132) (`Befunde/LEKTOR-132.md`, liegt auf `origin/main` seit #208, nicht in diesem Zweig — darum hier ohne Verweis).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102`, abgezweigt von `origin/e194_e196_speichern_unter`, Stand `91a2856f` (*„[E-207](../Intern/BEFUNDE.md#e-207): [PRUEFER-86](PRUEFER-86.md#pruefer-86) Nachtrag 2 eingearbeitet (N5 Test geschaerft, N4 vermerkt)“*).
Umfang: Bestand der MD-Dateien außerhalb von `Arbeitsweise/` und `Befunde/`. Schwerpunkt: der Zweig gegenüber `456c95e1` (Merge von #206) — 10 Commits, darunter `7869f5cb` (Behebung [E-194](../Intern/BEFUNDE.md#e-194)/[E-195](../Intern/BEFUNDE.md#e-195)/[E-196](../Intern/BEFUNDE.md#e-196)), `cecab886` (PRÜFER-86 eingearbeitet, [E-206](../Intern/BEFUNDE.md#e-206) neu), `e12e267d` (Behebung [E-205](../Intern/BEFUNDE.md#e-205)), `9e098eb9` (Behebung [E-207](../Intern/BEFUNDE.md#e-207)), `91a2856f` (`git log --stat 456c95e1..HEAD`, gemessen). Quelle der Funde: [PRÜFER-86](PRUEFER-86.md#pruefer-86) mit Nachtrag und Nachtrag 2. Nichts gebaut, nichts gestartet, keine Prüfstände angefasst; `pruefstand-buch.tsv` und Quelltext nur gelesen.

## Kurz

Die sechs Befundtexte stimmen in dem, was sie über den Quelltext sagen: Filterzuordnung ([E-195](../Intern/BEFUNDE.md#e-195): `compmsgd.cpp:3368` und `saveas.cpp:100` nehmen den neuen Filter ohne `.rtf`, `signatur.cpp:73` und `textfile.cpp:110` den alten), echtes RTF nur im Textdatei-Fenster (`TextFileView.cpp:122-123`), die auskommentierte `CPaigeEdtView::Serialize` ([E-207](../Intern/BEFUNDE.md#e-207), `PaigeEdtView.cpp:5595-5596`), die Zone in Minuten und das Speichern ohne Rückschreiben ([E-205](../Intern/BEFUNDE.md#e-205), `compmsgd.cpp:239-240`, `:3436`, `tocview.cpp:3144`) — alles gemessen am Quelltext. Die berichtigte RTF-Begründung (nur das Textdatei-Fenster schreibt RTF) steht in BEFUNDE, CHANGELOG, `saveas.cpp` und `TestE196.cpp` gleich; eine alte Fassung „Signaturfenster schreibt RTF“ gibt es in keiner MD mehr. **Nicht in Ordnung:** der Zweig steht noch auf #206 und gerät mit `main` (#207, #208) in sechs Konflikte; die Anwendertexte zu [E-207](../Intern/BEFUNDE.md#e-207) versprechen mehr, als behoben ist (das Fenster fragt beim Schließen weiterhin nicht); [E-195](../Intern/BEFUNDE.md#e-195) heißt überall „behoben“, im Signaturfenster besteht genau sein Fehlerbild fort; [E-206](../Intern/BEFUNDE.md#e-206) steht in den Listen als „nie gemessen“. Acht Funde, keiner am Programmcode.

## Funde aus LEKTOR-132 — heutiger Stand

[LEKTOR-132](LEKTOR-132.md#lektor-132) prüfte `funktionen_ini_abschnitte`; der Zweig ist als #208 auf `main` (`ee7b5400`, *„Merge pull request #208 from HansWurst81675/funktionen_ini_abschnitte“*). Dieser Zweig enthält weder #207 noch #208 (`git merge-base HEAD origin/main` → `456c95e1`, gemessen). Gemessen darum mit `git show origin/main:<datei>`.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-132.1](LEKTOR-132.md#l-132.1) Merge mit `e39_persona_loeschen`, `persona.cpp`-Angaben | **erledigt auf `main`**, hier nicht enthalten | `origin/main:Doku/FUNKTIONEN.md:998` *„(`persona.cpp:903-938`)“*, `:1052` *„(`persona.cpp:958-1105`)“*; `origin/main:Eudora71/Eudora/persona.cpp:903` *„UINT CPersonality::GetProfileInt“*, `:958` *„BOOL CPersonality::SavePersonaInfo(…)“* — treffen |
| [L-132.2](LEKTOR-132.md#l-132.2) Testplan, [A-5](../Intern/BEFUNDE.md#a-5), CHANGELOG zur Einstellungsseite | **erledigt auf `main`** | `origin/main:Intern/TESTPLAN.md:449` *„*6. Die Abschnitte der `Eudora.ini`* mit der Liste der Schlüssel …“* |
| [L-132.3](LEKTOR-132.md#l-132.3) `[ToolBar-…]` | **erledigt auf `main`** | `origin/main:Doku/FUNKTIONEN.md:1031` *„`[ToolBar-BarID<n>]` … `mainfrm.cpp:1877` (`"%s-BarID%lu"`)“*; `origin/main:…/mainfrm.cpp:1877` *„szSection.Format( "%s-BarID%lu", "ToolBar",“*, `:5981` *„AUFRAEUMEN("SaveBarState(ToolBar)", …“* |
| [L-132.4](LEKTOR-132.md#l-132.4) alte Abschnitte nur ohne `[Settings]` | **erledigt auf `main`** | `origin/main:Doku/FUNKTIONEN.md:1033` |
| [L-132.5](LEKTOR-132.md#l-132.5) `GetParams` liest 38 | **erledigt auf `main`** | `origin/main:Doku/FUNKTIONEN.md:1052` *„Gelesen werden davon 38 von `GetParams`“* |
| [L-132.6](LEKTOR-132.md#l-132.6) „falscher Abschnitt wirkt nicht“ | **erledigt auf `main`** | `origin/main:Intern/EINSTELLUNGEN.md:51` *„(Ausnahme: im Abschnitt des gerade …“*, `:71` *„**1.3 Der Abschnitt des Hauptkontos heißt wörtlich `[Settings]`** — immer,“* |
| [L-132.7](LEKTOR-132.md#l-132.7) Perl-Aufruf auf der Anwenderseite | **erledigt auf `main`** | wie im Nachtrag von [LEKTOR-132](LEKTOR-132.md#lektor-132); nicht erneut gemessen |
| [L-132.8](LEKTOR-132.md#l-132.8) LDAP-Datei nur Vorlage | **erledigt auf `main`** | `origin/main:Doku/FUNKTIONEN.md:1036` *„Bei LDAP heißt sie `LDAPinit.ini“* |
| [L-132.9](LEKTOR-132.md#l-132.9) `e39_persona_loeschen` „laufend“ nach #207 | **erledigt auf `main`** — aber dieselbe Klasse ist dort sofort wieder aufgetreten ([L-133.2](#l-133.2)) | `origin/main:CHANGELOG.md:118` *„Zweig `e39_persona_loeschen` (gemergt als #207)“*; `origin/main:Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `funktionen_ini_abschnitte`“* — obwohl #208 gemergt ist |
| [L-131.2](LEKTOR-131.md#l-131.2) `hilfe_menue` „nicht gemergt“ | **auf `main` erledigt, hier offen** | hier `CHANGELOG.md:131` *„**Für 7.2.2 — Zweig `hilfe_menue`** (noch nicht gemergt, …“*, `ZIEL.md:122` *„**Umgesetzt im Zweig `hilfe_menue`, am Prüfstand gemessen**“*, `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `hilfe_menue`“*; kommt mit dem Merge von `main` ([L-133.1](#l-133.1)) |
| [L-131.8](LEKTOR-131.md#l-131.8) Berichtszahl in der README | **offen, die Klasse ohne Werkzeug** | hier `README.md:98` *„(209 LEKTOR- und PRÜFER-Berichte)“* bei 212 im Verzeichnis (`ls Befunde \| grep -cE '^(LEKTOR\|PRUEFER)-[0-9]+\.md$'`), mit diesem 213; `origin/main:README.md:98` *„(213 …, gezählt am 02.11.2026)“* bei 214 auf `main` |
| [L-130.1](LEKTOR-130.md#l-130.1) persönliche Angabe in alten Zweigen | **unverändert** | `git branch -r --contains d9ae24c8` → `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; dieser Zweig ist frei davon |
| [L-129.1](LEKTOR-129.md#l-129.1) Schranke „zuletzt veröffentlicht“ | **offen** | `grep -c 'zuletzt ver' tools/pruefe-release-buchfuehrung.pl` → 0 |
| [L-128.2](LEKTOR-128.md#l-128.2) Schranke gegen „läuft“ nach dem Merge | **offen**, zum neunten Mal aufgetreten ([L-133.2](#l-133.2)) | `grep -l 'PR folgt\|Laufend' tools/*.pl` → kein Treffer |
| [L-128.3](LEKTOR-128.md#l-128.3) Entwurfskopf in der Notizdatei | **offen** | `tools/release-veroeffentlichen.ps1:128` *„if ($text -match 'noch nicht best')“* nur am CHANGELOG |
| [L-126.5](LEKTOR-126.md#l-126.5) Starts ohne Titelzeile | **teilweise** | vom 02.11. hier 96 Zeilen, 19 ohne `[Eudora` (`grep '^\| 2026-11-02' tools/TESTLAEUFE.md \| grep -vc '\[Eudora'`); von den 43 Zeilen dieses Zweigs 9 ohne, etwa *„\| 2026-11-02 16:02:24 \| `C:\Temp\E194-140` \| … \| Hauptfenster 1706024 - Eudora  Schliesszeit 1 s. \|“* |

## Die Befundtexte gegen Quelle und Messung

| Aussage | Stelle | Gegen (gemessen, wo nicht anders gesagt) |
|---|---|---|
| eigener Filter `IDS_MSG_SAVEAS_FILE_FILTER` 3130 ohne `.rtf`, `IDS_TXT_HTML_FILE_FILTER` mit `.rtf` für Textdatei- und Signaturfenster | `Intern/BEFUNDE.md:406` ([E-195](../Intern/BEFUNDE.md#e-195)) | `resource.h:1585` *„#define IDS_MSG_SAVEAS_FILE_FILTER      3130“*; `EudoraRes.rc:8548-8551` *„"Text Files (*.txt)\|*.txt\|HTML Files (*.htm)\|*.htm\|All Files (*.*)\|*.*\|\|"“*; Aufrufer `compmsgd.cpp:3368`, `saveas.cpp:100` neu, `signatur.cpp:73`, `textfile.cpp:110` alt — trifft |
| `CSaveAs` für Nachrichtenfenster, `Trnslate.cpp`, `DSPrintEdit.cpp` | ebenda | `Trnslate.cpp:1964`, `:2106`, `DSPrintEdit.cpp:102`, `ReadMessageDoc.cpp:607`; dazu `filtersd.cpp:2113` (nur `CreateFile`, kein Dialog) und `PgReadMsgView.cpp:620` (auskommentiert) — trifft für alle Wege mit Dialog |
| echtes RTF schreibt nur das Textdatei-Fenster | `BEFUNDE.md:406`, `CHANGELOG.md:122`, `saveas.cpp:95-98`, `TestE196.cpp:184-188` | `TextFileView.cpp:122-123` *„else if ( fileExt.CompareNoCase(CRString(IDS_RTF_EXTENSION)) == 0) format = PgDataTranslator::kFmtRtf;“* — trifft; die frühere Fassung (Signaturfenster schreibt RTF) steht in keiner MD außerhalb der Prüfberichte mehr (`grep -rn 'RTF\|\.rtf' --include=*.md`) |
| `CPaigeEdtView::Serialize` seit dem Original auskommentiert | `BEFUNDE.md:400` ([E-207](../Intern/BEFUNDE.md#e-207)) | `PaigeEdtView.cpp:5595` *„/*03-17-2000 Commented this function as this is moved to TextFileView.Cpp“*, `PaigeEdtView.h:361` *„//virtual void Serialize(CArchive& ar);“*; im Code von `signatur.cpp` nur noch im Kommentar `:103` — trifft |
| `E207SpeichernUnter` bei `m_SaveAs` | ebenda | `signatur.cpp:100` *„if (m_SaveAs)“*, `:113` *„pView->E207SpeichernUnter(ar);“*, `:173`, `signatur.h:82` — trifft |
| Zone in Minuten, `m_Seconds` wie vorher | `BEFUNDE.md:402` ([E-205](../Intern/BEFUNDE.md#e-205)) | `compmsgd.cpp:239-240` *„m_Sum->m_TimeZoneMinutes = -GetGMTOffset(); m_Sum->m_Seconds = time(NULL) - m_Sum->m_TimeZoneMinutes * 60;“* — trifft |
| beide Speicherwege ohne Rückschreiben, Senden unverändert | ebenda | `compmsgd.cpp:3436`, `tocview.cpp:3144` *„ComposeDate( szDateMaybe, pSummary->m_Seconds, pSummary->m_TimeZoneMinutes );“*; `sendmail.cpp:3329` *„ComposeDate(Date, SMTPmsg->m_Sum);“*; Rückschreiben `sendmail.cpp:661-666`; Leser `summary.cpp:1355`, `mapicmc.cpp:852`, `EuImap/src/ImapAppend.cpp:1284` — trifft |
| `GMTTime += TimeZoneMinutes * 60`; `FormatDateMT` hebt bei ±2400 auf | ebenda | `QCUtils/src/services.cpp:2094`, `:2067` *„if (num >= -2400 && num <= 2400)“* — trifft |
| Zone als `short` in der `.toc` | ebenda | `summary.cpp:2576` *„out->Put((short)m_TimeZoneMinutes)“*, `:2497-2498` — trifft |
| Zahlen 59 h / 119 h, „jedes weitere Speichern 60 h später“ | `BEFUNDE.md:402`, `CHANGELOG.md:125` | `E205 ERGEBNIS neu1=59h neu2=119h …` (`e12e267d`, Commit-Nachricht) — trifft |
| ohne Kopfzeilen `get_text`, mit Kopfzeilen Rohtext | `BEFUNDE.md:401` ([E-206](../Intern/BEFUNDE.md#e-206)) | `TridentReadMessageView.cpp:2910` `get_text`, `:2003-2025` `GetAllText` mit `GetFullMessage(RAW)` (`:2018`) — trifft; „Aufruf `:2946`“ siehe [L-133.5](#l-133.5) |
| Tests zu K7/N3, K8, N5 | `BEFUNDE.md:400`, `:405`, `:407` | `TestE196.cpp:240` `Test_E196_K7`, `:257-258` mit `<p class="x">` (N3); `TestE194.cpp:126-131` (K8); `91a2856f` *„Gegenprobe J3 … 382/383, rot genau [E-207](../Intern/BEFUNDE.md#e-207) (Quelltext)“* — trifft |
| Prüfstandsfälle | `BEFUNDE.md:400-407` | `tools/pruefstand-faelle.txt:366`, `:376`, `:377`, `:384`; zuletzt gelaufen `Intern/pruefstand-buch.tsv:50-53` (alle `ok`) — siehe [L-133.6](#l-133.6) |
| persönliche Angaben | Diff `456c95e1..HEAD`, Commit-Nachrichten | `grep -ci 'Users\\Gregor\|Eudora72-\|@gmx\|@web\.de\|@t-online'` über die hinzugefügten Zeilen und `git log --format=%B` → je 0 |

## Funde

### <a id="l-133.1"></a>L-133.1 — Der Zweig steht noch auf #206; mit `main` (#207, #208) gerät er in sechs Konflikte

**Gewicht: mittel.** Bevor der PR gestellt wird, muss `main` herein; die Doku dieses Zweigs beschreibt einen Stand ohne die Behebung, dass eine gelöschte Persönlichkeit einen leeren Rest in der `Eudora.ini` hinterließ ([E-39](../Intern/BEFUNDE.md#e-39)), und ohne den neuen Abschnitt 6 von `Doku/FUNKTIONEN.md`. (gemessen mit `git merge-tree`, nichts ausgecheckt)

- `git log --oneline HEAD..origin/main | wc -l` → 27; `git merge-base HEAD origin/main` → `456c95e1`.
- `git merge-tree --write-tree --name-only HEAD origin/main` → *„CONFLICT (content): Merge conflict in CHANGELOG.md“*, ebenso `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `Intern/pruefstand-buch.tsv`, `tools/TESTLAEUFE.md`, `tools/ZWEIGE.md`. Mit diesem Bericht kommt `Intern/LEKTORAT.md` dazu: hier endet die Datei mit [LEKTOR-130](LEKTOR-130.md#lektor-130), auf `main` mit [LEKTOR-131](LEKTOR-131.md#lektor-131) und [LEKTOR-132](LEKTOR-132.md#lektor-132); der neue Abschnitt hängt an derselben Stelle.
- Zahlen, die sich mit dem Merge ändern: `offene-befunde.pl` meldet hier 55, auf `main` stand nach #207 54 ([LEKTOR-132](LEKTOR-132.md#lektor-132), Nachtrag) — nach dem Merge 57 zu erwarten (Vermutung: 52 gemeinsame + [E-203](../Intern/BEFUNDE.md#e-203), [E-204](../Intern/BEFUNDE.md#e-204) + [E-205](../Intern/BEFUNDE.md#e-205), [E-206](../Intern/BEFUNDE.md#e-206), [E-207](../Intern/BEFUNDE.md#e-207)); die Testzahl 383 (hier) gegen die E-39-Tests von `main`.

**Vorschlag:** `origin/main` in den Zweig holen, Konflikte in Listen nach Zeit bzw. Kennung vereinigen (vgl. die Merge-Spuren in [L-131.1](LEKTOR-131.md#l-131.1)), danach Testsuite und die Fälle `E-194p`, `E-194k`, `E-205p`, `E-207p` am gemergten Stand und die Zählung neu.

### <a id="l-133.2"></a>L-133.2 — Stand-Köpfe: hier heißt `hilfe_menue` laufend, auf `main` `funktionen_ini_abschnitte` — und dieser Zweig steht nirgends

**Gewicht: Kleinkram, dieselbe Klasse zum neunten Mal** ([L-128.2](LEKTOR-128.md#l-128.2): nach dem Merge bleibt „läuft“ stehen). (gemessen)

- Hier `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `hilfe_menue` (Hilfe-Menü für 7.2.2, [A-5](../Intern/BEFUNDE.md#a-5), …)“* — #206 ist der Stand, auf dem dieser Zweig steht. `e194_e196_speichern_unter` kommt in Zeile 3 nicht vor (`sed -n 3p … \| grep -c e194` → 0); der Zweig hat nur Tabellenzeilen ergänzt.
- `origin/main:Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `funktionen_ini_abschnitte`“* — `ee7b5400` ist *„Merge pull request #208 from HansWurst81675/funktionen_ini_abschnitte“*; #208 steht dort nicht.
- `README.md:98` *„(209 LEKTOR- und PRÜFER-Berichte)“* ([L-131.8](LEKTOR-131.md#l-131.8)), siehe Tabelle oben.

**Vorschlag:** beim Merge aus [L-133.1](#l-133.1) im Stand-Kopf „gemergt als #208“ und „Laufend: Zweig `e194_e196_speichern_unter`“ ([E-194](../Intern/BEFUNDE.md#e-194) bis [E-207](../Intern/BEFUNDE.md#e-207)). Die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) fehlt weiter; neun Auftreten sprechen für ein Werkzeug, das `Laufend: Zweig <x>` gegen `git log origin/main --merges` hält.

### <a id="l-133.3"></a>L-133.3 — README und CHANGELOG zu E-207 lesen sich, als frage das Signaturfenster jetzt beim Schließen

**Gewicht: mittel.** Ein Anwender, der nach 7.2.2.132 eine Signatur ändert und *Save As* wählt, erwartet nach diesen Texten, dass Eudora beim Schließen nachfragt oder die Signatur sichert. Beides geschieht weiterhin nicht. (gemessen am Fall und an den Texten)

- `README.md:201` *„*File → Save As* aus dem **Signaturfenster** … schreibt eine **leere Datei**, und das Fenster schließt danach ohne die Frage nach dem Sichern … behoben im Quellstand (02.11.2026), kommt mit 7.2.2.132“* — „behoben“ steht hinter beiden Hälften.
- `CHANGELOG.md:127` *„Bisher entstand eine Datei mit 0 Byte, und das Fenster galt danach als gesichert — eine Änderung ging beim Schließen ohne Frage verloren.“* — „bisher“ für beides.
- Gemessen ist das Gegenteil: `pruefstand-buch.tsv:53` *„E207 ERGEBNIS fenster=1 geaendert=1 txt=passt htm=passt frage=0 sig=unveraendert lebt=1“* am Bau mit der Behebung; `BEFUNDE.md:400` sagt es richtig unter *„Nicht geändert, Gregor entscheidet ([PRÜFER-86](PRUEFER-86.md#pruefer-86) N4)“*. Neu ist nur: die Änderung steht jetzt in der Kopie statt nirgends.

**Vorschlag:** README: *„… schrieb eine leere Datei; seit dem Quellstand vom 02.11.2026 steht der Inhalt darin (kommt mit 7.2.2.132). Weiter gilt: nach *Save As* fragt das Fenster beim Schließen nicht, die Signatur selbst bleibt unverändert — wer sie ändern will, sichert mit *Save*.“* (die letzte Abhilfe ist nicht gemessen, nur am Quelltext belegt). CHANGELOG entsprechend. Die Richtung von N4 entscheidet Gregor (unten).

### <a id="l-133.4"></a>L-133.4 — E-195 heißt „behoben“, im Signaturfenster besteht das Fehlerbild fort

**Gewicht: Kleinkram.** Der Titel von [E-195](../Intern/BEFUNDE.md#e-195) beschreibt den Dialog allgemein; behoben ist er für die beiden Nachrichtenwege. (gemessen am Quelltext und an den Texten)

- `BEFUNDE.md:406` *„**Der Speicherdialog bietet `.rtf` an, liefert aber Klartext**“*; `README.md:200` *„**Alle drei im Quellstand behoben (02.11.2026), kommen mit 7.2.2.132**“*.
- `signatur.cpp:73` nimmt weiter `IDS_TXT_HTML_FILE_FILTER` mit *Rtf Files*, und `E207SpeichernUnter` schreibt bei allem außer `.htm`/`.html` Text — `BEFUNDE.md:400` selbst: *„Wählt man im Dialog *Rtf Files*, wird Text unter `.rtf` geschrieben, derselbe Fall wie [E-195](../Intern/BEFUNDE.md#e-195).“* `CHANGELOG.md:122` begründet das Belassen mit *„wie im Original (echtes RTF schreibt nur das Textdatei-Fenster …)“* — die Begründung trägt für das Textdatei-Fenster, für das Signaturfenster spricht sie dagegen.
- Vor `9e098eb9` war das gleichgültig, das Signaturfenster schrieb gar nichts (PRÜFER-86 N1: *„Ob das Signaturfenster ihn mit oder ohne `.rtf` bekommt, ist gleich, solange es nichts schreibt“*). Seit es schreibt, nicht mehr.

**Vorschlag:** `signatur.cpp:73` auf `IDS_MSG_SAVEAS_FILE_FILTER` und den Test `E-195 (Quelltext)` (`TestE196.cpp:221`) mitziehen — Gregors *„wobei ein speichern als RFT nicht notwendig ist“* deckt das nach dem Wortlaut; oder den Titel von [E-195](../Intern/BEFUNDE.md#e-195) und die README-Zeile auf „für Nachrichten“ einengen und den Rest unter [E-207](../Intern/BEFUNDE.md#e-207) führen.

### <a id="l-133.5"></a>L-133.5 — E-206 steht in den Listen als „nie gemessen“

**Gewicht: Kleinkram.** (gemessen)

- `BEFUNDE.md:401` *„**offen, am Prüfstand gemessen (02.11.2026 an 7.2.1.131), Code unverändert.**“* — ohne die Marke `**Zuletzt gemessen: … an …**`, an der `tools/offene-befunde.pl:210` den Messstand erkennt (*„if ($urteil =~ /\*\*Zuletzt gemessen:\s*(\d{2}\.\d{2}\.\d{4})\s+an\s+(7\.2\.[01]\.\d+)\*\*/)“*).
- Folge: `CHANGELOG.md:31` und `Intern/WEITERMACHEN.md:80` *„**nie gemessen**“*; `offene-befunde.pl` zählt [E-206](../Intern/BEFUNDE.md#e-206) unter *„davon NIE gemessen 14“*.
- Ebenda *„über `GetMessageBody` mit `IHTMLTxtRange::get_text` (`TridentReadMessageView.cpp:2910`, Aufruf `:2946`)“* — `:2946` ist der Kopf von `GetMessageAsText`, der Aufruf `return GetMessageBody( szMsg, FALSE );` steht `:2955`.

**Vorschlag:** *„**Zuletzt gemessen: 02.11.2026 an 7.2.1.131**“* einsetzen (gemessen an den Dateien des Prüfstands `E-194p`, Originalverhalten an `7.2.1.131+a2f29b69*`), Tabellen neu erzeugen; `:2946` → `:2955`.

### <a id="l-133.6"></a>L-133.6 — Die Messangaben hinken dem Stand nach: E-194 bis E-196 nennen den ersten Bau, WERKZEUGE die alte Ergebniszeile

**Gewicht: Kleinkram.** (gemessen)

- [E-194](../Intern/BEFUNDE.md#e-194), [E-195](../Intern/BEFUNDE.md#e-195), [E-196](../Intern/BEFUNDE.md#e-196) (`BEFUNDE.md:405-407`): *„Bau `7.2.1.131+a2f29b69*` ohne, `7.2.1.131+522b8bbb*` mit der Behebung“*; [E-194](../Intern/BEFUNDE.md#e-194) zitiert als „nachher“ *„E194 ERGEBNIS kopf=0 mbx=1 dateien=4 filter=4 liste-xflowed=0 liste-flowed=1 lesen-xflowed=0 htm-meta=2 rtf=0 lebt=1“*. Zuletzt gelaufen sind die Fälle am Bau `7.2.1.131+cecab886*` (`pruefstand-buch.tsv:50-51`, 17:04:02), mit der Zeile, die der Fall heute verlangt (`pruefstand-faelle.txt:366`): *„… liste-flowed=1 liste-umbruch=weich liste-euro=cp1252 liste-umlaute=10 lesen-xflowed=0 …“*. Die Behebungen K5–K7 (`cecab886`) liegen nach `522b8bbb`.
- `tools/WERKZEUGE.md:151` nennt *„Ergebniszeile `E194 ERGEBNIS kopf= mbx= dateien= filter= liste-xflowed= liste-flowed= lesen-xflowed= htm-meta= rtf= lebt=`“* — ohne die drei neuen Werte, die `tools/messen-e194.ps1:38` und `:364` ausgeben.
- Die vier Fälle des Zweigs liefen an drei Bauten: `E-194p`/`E-194k` und `E-205p` an `cecab886*` (vor dem Signatur-Teil), `E-207p` an `dde4db0d*` (`pruefstand-buch.tsv:50-53`); am Stand `9e098eb9`/`91a2856f` ist kein Fall vermerkt. `9e098eb9` sagt *„Pruefstand: E-207p und E-205p gruen“* — `E-205p` lief um 17:30:15 am Bau ohne die Signatur-Änderung. Dass die Signatur-Änderung `E-205p` nicht berührt, ist eine Vermutung (andere Datei, `signatur.cpp`), nicht gemessen.

**Vorschlag:** „Zuletzt gemessen“ und die zitierte Zeile auf den letzten Lauf; WERKZEUGE-Zeile um `liste-umbruch= liste-euro= liste-umlaute=`; nach dem Merge ([L-133.1](#l-133.1)) alle vier Fälle an einem Bau.

### <a id="l-133.7"></a>L-133.7 — Der CHANGELOG-Block spricht nach fünf Punkten von „allen drei Wegen“; ZWEIGE nennt nur E-194 bis E-196

**Gewicht: Kleinkram.** (gemessen)

- `CHANGELOG.md:129` *„Für Gregor nichts zu prüfen — der Prüfstand sieht alle drei Wege (Dateityp-Liste über `CB_GETLBTEXT`, Dateien byteweise). Gegenprobe am Bau `7.2.1.131+a2f29b69*`: alle drei Werte rot“* — steht unter den Punkten zu [E-205](../Intern/BEFUNDE.md#e-205) (`:125`) und [E-207](../Intern/BEFUNDE.md#e-207) (`:127`), gemeint sind nur die ersten drei (`:121-123`). Die Liste ist durch Leerzeilen (`:124`, `:126`) in drei Listen zerteilt.
- `tools/ZWEIGE.md:214` *„[[E-194](../Intern/BEFUNDE.md#e-194)] (…), [[E-195](../Intern/BEFUNDE.md#e-195)] (…), [[E-196](../Intern/BEFUNDE.md#e-196)] (…): nachstellen, beheben, am Prüfstand messen; kommt mit 7.2.2.132.“* — [E-205](../Intern/BEFUNDE.md#e-205) und [E-207](../Intern/BEFUNDE.md#e-207) sind im selben Zweig behoben, [E-206](../Intern/BEFUNDE.md#e-206) aufgenommen.

**Vorschlag:** den Satz `:129` direkt hinter `:123` und für [E-205](../Intern/BEFUNDE.md#e-205)/[E-207](../Intern/BEFUNDE.md#e-207) je ihren Fall nennen; Leerzeilen weg; ZWEIGE um die beiden Kennungen ergänzen.

### <a id="l-133.8"></a>L-133.8 — Die FAQ empfiehlt *Save As*, um eine Mail „unverändert“ weiterzugeben

**Gewicht: Kleinkram.** (belegt aus der Messung in [E-206](../Intern/BEFUNDE.md#e-206); die FAQ-Antwort selbst ist nicht nachgemessen)

- `Doku/FAQ.md:300-302` (Frage 15) *„Wer eine Mail unverändert weitergeben will, sichert sie als Datei (*File → Save As…*) und hängt diese Datei an eine neue Mail an.“*
- Aus dem Nachrichtenfenster ohne *Kopfzeilen einschließen* fehlen in der Datei die Zitatzeichen `>` und es kommen Leerzeilen dazu ([E-206](../Intern/BEFUNDE.md#e-206), `BEFUNDE.md:401`); die Kopfzeilen fehlen ohnehin, und das Kästchen dafür zeigt der Dialog unter Windows 10 nicht ([E-98](../Intern/BEFUNDE.md#e-98)). „Unverändert“ ist das nicht.

**Vorschlag:** *„… sichert sie aus der Postfachliste (Nachricht markieren, *File → Save As…*) …; aus dem geöffneten Fenster ohne Kopfzeilen gehen die Zitatzeichen verloren ([E-206](../Intern/BEFUNDE.md#e-206))“* — dass der Weg über die Postfachliste die Zitatzeichen behält, ist an `e194-liste.txt` zu messen, bevor es dort steht.

## Bestand außerhalb des Schwerpunkts

Seit `456c95e1` hat der Zweig außerhalb von `Arbeitsweise/` und `Befunde/` diese MDs geändert: `CHANGELOG.md`, `README.md`, `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`, `Testdaten/README.md`, `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` (gemessen, `git log --stat`). Alle gelesen. `Intern/TESTPLAN.md:231` *„Alle drei am 02.11.2026 im Quellstand behoben und **am Prüfstand erledigt** (Fälle `E-194p`/`E-194k`) — kein Testschritt für Gregor“* stimmt mit der Messung; zu [E-205](../Intern/BEFUNDE.md#e-205) und [E-207](../Intern/BEFUNDE.md#e-207) gibt es keinen Testschritt und keinen Satz, dass keiner nötig ist — der CHANGELOG sagt es (`:129`, siehe [L-133.7](#l-133.7)). `Testdaten/README.md` zu `e194-flowed-umlaute.eml`: *„20 CRLF, 0 nackte LF, 23 Bytes ≥ 0x80“* — nicht nachgemessen. `Doku/FUNKTIONEN.md:84` (*Save As…*: *„Endung immer `.txt` ([[E-128](../Intern/BEFUNDE.md#e-128)]…)“*) ist unverändert und widerspricht dem Zweig nicht. Die übrigen Dateien hat dieser Zweig nicht angefasst; was auf `main` dazu steht, ist in [LEKTOR-131](LEKTOR-131.md#lektor-131) und [LEKTOR-132](LEKTOR-132.md#lektor-132) geprüft und kommt mit dem Merge. Die Stand-Köpfe von README, CHANGELOG, PAKETE, ZIEL und TESTPLAN nennen weiter `v7.2.1.131` als zuletzt veröffentlicht; `VERSION` ist `7.2.1.131`.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„gepruefte Dateien 52“*, *„Kennungen im Verzeichnis 179“*, *„Kein Widerspruch gefunden.“*; *Zur Kenntnis* wie in [LEKTOR-132](LEKTOR-132.md#lektor-132) (u. a. `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` höchste Fassung 7.2.1.128, `Doku/FAQ.md` 7.2.1.130). [L-133.1](#l-133.1) bis [L-133.8](#l-133.8) sieht es nicht — es kennt weder Merge-Stände noch Aussagen über das Verhalten.

`perl tools/offene-befunde.pl` (gemessen): *„55 offene Befunde, in beiden Listen gleich.“*, *„davon NIE gemessen 14“* — darunter [E-206](../Intern/BEFUNDE.md#e-206) zu Unrecht ([L-133.5](#l-133.5)).

`perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 71“*, *„mit Testfall im Pruefstand 63 von 71“* (eins mehr als in [LEKTOR-132](LEKTOR-132.md#lektor-132): [E-207](../Intern/BEFUNDE.md#e-207) mit `E-207p`), *„OHNE jede Pruefung 6 <- Rueckstand: [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39)“* — [E-39](../Intern/BEFUNDE.md#e-39) nur, weil #207 hier fehlt ([L-133.1](#l-133.1)); *„Kein neues "behoben" ohne Regressionstest.“*

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* — trotz `ZIEL.md:122` ([L-131.2](LEKTOR-131.md#l-131.2) hier offen); das Werkzeug liest die Kriterien, nicht diesen Absatz.

## Was nur Gregor entscheiden kann

1. **Signaturfenster nach *Save As*** ([E-207](../Intern/BEFUNDE.md#e-207), Rest N4 aus [PRÜFER-86](PRUEFER-86.md#pruefer-86): nach *Save As* nennt der Titel die Kopie, das Fenster fragt beim Schließen nicht, die Signatur selbst bleibt alt, ein späteres *Save* schreibt in die Signatur). Soll *Save As* dort (a) eine Kopie sein — Titel bleibt, das Fenster fragt beim Schließen weiter nach der Signatur — oder (b) ein echtes *Speichern unter*, nach dem das Fenster die Kopie bearbeitet? Oder bleibt es wie im Original? Wird geändert, muss der Fall `E-207p` mit.
2. **Sollen die Zweige auf GitHub gelöscht werden, die noch die Datei mit der persönlichen Angabe tragen** ([L-130.1](LEKTOR-130.md#l-130.1): eine Gedächtnisdatei mit einer Angabe, die nicht ins Repo soll)? `origin/hilfe_menue`, `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; `main` und dieser Zweig sind frei davon. Unverändert seit [LEKTOR-131](LEKTOR-131.md#lektor-131).

## <a id="nachtrag-1-02-11-2026"></a>Nachtrag 1 (02.11.2026)

Gegengelesen: `git diff 95609a77..origin/e194_e196_speichern_unter -- '*.md'` (Stand `00b92b03`, *„[LEKTOR-133](#lektor-133) eingearbeitet ([L-133.2](#l-133.2) bis [L-133.8](#l-133.8)); vier Faelle am gemeinsamen Bau nach dem Merge von main“*), dazu die Merge-Auflösung `b637b0c8` (*„Merge origin/main (#207, #208) …“*). Arbeitsbaum vorgespult mit `tools/arbeitsbaum-angleichen.sh`. Nichts gebaut, nichts gestartet.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-133.1](#l-133.1) Zweig auf #206 | **erledigt** | `git merge-base --is-ancestor origin/main HEAD` → ja; Konfliktmarken 0; `Intern/BEFUNDE.md:162` *„\| zusammen \| 57 \| 166 \| 16 \| 239 \|“* — 57 offen wie vorhergesagt; `pruefstand-buch.tsv:50-53` alle vier Fälle *„Eudora 7.2.1.131+d7a3fa60 2026-11-02 18:01“* um 18:05:20, `ok`; Tests 385/385 laut `00b92b03` (nicht nachgemessen) |
| [L-133.2](#l-133.2) Stand-Köpfe, Berichtszahl | **erledigt** | `Intern/WEITERMACHEN.md:3` *„#208: Zweig `funktionen_ini_abschnitte` …“*, *„Laufend: Zweig `e194_e196_speichern_unter` ([E-194](../Intern/BEFUNDE.md#e-194) …“*; `README.md:98` *„(216 LEKTOR- und PRÜFER-Berichte, gezählt am 02.11.2026)“* bei 216 im Verzeichnis (gezählt, mit diesem Bericht); `CHANGELOG.md` und `ZIEL.md` zu `hilfe_menue` über den Merge wie auf `main`. Die Schranke aus [L-128.2](LEKTOR-128.md#l-128.2) fehlt weiter |
| [L-133.3](#l-133.3) README/CHANGELOG zu [E-207](../Intern/BEFUNDE.md#e-207) | **erledigt** | `README.md:201` *„**Weiter gilt auch danach:** nach *Save As* fragt das Fenster beim Schließen nicht, die Änderung steht nur in der Kopie, die Signatur selbst bleibt unverändert“*; `CHANGELOG.md:129` *„**Unverändert:** nach *Save As* gilt das Fenster weiter als gesichert und fragt beim Schließen nicht“* |
| [L-133.4](#l-133.4) [E-195](../Intern/BEFUNDE.md#e-195) im Signaturfenster | **erledigt als Einengung** (Weg 2 des Vorschlags), der Rest steht offen da | `Intern/BEFUNDE.md:408` *„**Der Speicherdialog für Nachrichten bietet `.rtf` an …“*; `CHANGELOG.md:124` *„Das Signaturfenster behält ihn ebenfalls, schreibt dort aber Text — das ist für das Signaturfenster nicht behoben (offener Rest …)“*; `README.md:201` *„und der Dialog bietet weiter *Rtf Files* an, schreibt dort aber Text“*. `signatur.cpp:73` unverändert |
| [L-133.5](#l-133.5) [E-206](../Intern/BEFUNDE.md#e-206) „nie gemessen“, `:2946` | **erledigt** | `BEFUNDE.md:401` *„Zuletzt gemessen: 02.11.2026 an 7.2.1.131** (Dateien des Prüfstands `E-194p` …)“*, *„Aufruf `:2955`“*; `CHANGELOG.md` und `WEITERMACHEN.md`, Zeile [E-206](../Intern/BEFUNDE.md#e-206): *„02.11.2026 an 7.2.1.131“* |
| [L-133.6](#l-133.6) Messangaben | **erledigt** | `BEFUNDE.md:409` *„nachher, am letzten Lauf (Bau `7.2.1.131+d7a3fa60`), `E194 ERGEBNIS … liste-umbruch=weich liste-euro=cp1252 liste-umlaute=10 …`“*; „Zuletzt gemessen“ bei [E-194](../Intern/BEFUNDE.md#e-194) bis [E-196](../Intern/BEFUNDE.md#e-196), [E-205](../Intern/BEFUNDE.md#e-205), [E-207](../Intern/BEFUNDE.md#e-207) mit *„zuletzt … `7.2.1.131+d7a3fa60`“*; `tools/WERKZEUGE.md` nennt *„liste-umbruch= liste-euro= liste-umlaute=“* (`grep -c` → 1) |
| [L-133.7](#l-133.7) CHANGELOG „alle drei Wege“, ZWEIGE | **erledigt; ein Rest** | `CHANGELOG.md:127` *„Für diese drei ist für Gregor nichts zu prüfen …“* hinter den drei Punkten, `:131` *„Alle vier Fälle (`E-194p`, `E-194k`, `E-205p`, `E-207p`) nach dem Merge von `main` an einem Bau, `7.2.1.131+d7a3fa60`: 4 von 4 bestanden.“*; `tools/ZWEIGE.md` nennt [E-205](../Intern/BEFUNDE.md#e-205), [E-206](../Intern/BEFUNDE.md#e-206), [E-207](../Intern/BEFUNDE.md#e-207). Rest siehe [L-133.9](#l-133.9) |
| [L-133.8](#l-133.8) FAQ 15 | **erledigt** | `Doku/FAQ.md:304-308` *„am besten aus der **Postfachliste** … dort bleiben die Zitatzeichen `>` stehen (am 02.11.2026 am Prüfstand gemessen, `e194-liste.txt`). Aus dem geöffneten Nachrichtenfenster ohne *Kopfzeilen einschließen* gehen sie verloren ([E-206](../Intern/BEFUNDE.md#e-206)).“* — die Messung an `e194-liste.txt` ist dem Commit entnommen, hier nicht nachgelesen |

**Merge-Auflösung auf Verlust geprüft** (gemessen): für `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `Intern/LEKTORAT.md`, `Intern/pruefstand-buch.tsv`, `tools/TESTLAEUFE.md`, `tools/ZWEIGE.md`, `README.md`, `Doku/FUNKTIONEN.md`, `Intern/TESTPLAN.md`, `tools/WERKZEUGE.md` jede Zeile, die `origin/main` gegenüber `456c95e1` neu hat, gegen den heutigen Stand gelegt (`comm` über sortierte Zeilen). Es fehlen nur Zeilen, die absichtlich neu geschrieben sind: die drei Zählzeilen der Stufentabelle in `BEFUNDE.md` (neu erzeugt, jetzt `:158-162`), der Stand-Kopf `WEITERMACHEN.md:3` und die Berichtszahl `README.md:98`; die drei E-39-Zeilen der `.tsv` stehen in `:54-56` (Unterschied nur im Zeilenende). Aus diesem Zweig fehlen nur die mit `00b92b03` berichtigten Zeilen. `Intern/LEKTORAT.md` hat [LEKTOR-131](LEKTOR-131.md#lektor-131), [LEKTOR-132](LEKTOR-132.md#lektor-132) und [LEKTOR-133](#lektor-133) in dieser Reihenfolge; `tools/TESTLAEUFE.md` beide Seiten. Die Änderungen an diesem Bericht in `b637b0c8`/`d7a3fa60` sind nur Verweise, die jetzt treffen — der Satz im Kopf *„darum hier ohne Verweis“* steht dadurch neben einem Verweis, Kleinkram ohne eigene Kennung.

### <a id="l-133.9"></a>L-133.9 — Die drei Nachbarfälle laufen nicht am gemergten Bau, der CHANGELOG sagt „am neuen Bau grün“

**Gewicht: Kleinkram.** (gemessen)

- `CHANGELOG.md:127` *„… `E-140p`, `E-177p`, `E-178p` am neuen Bau grün.“* — `pruefstand-buch.tsv:38`, `:45`, `:46`: alle drei zuletzt 17:04:02 an *„Eudora 7.2.1.131+cecab886*“*, also vor der Behebung von [E-207](../Intern/BEFUNDE.md#e-207) und vor dem Merge von `main`. Der Lauf am gemeinsamen Bau `d7a3fa60` umfasste nur die vier eigenen Fälle (`:131`).
- Dass der Merge (#207: `persona.cpp`, #208: nur Doku) und `signatur.cpp` die Speicherwege von [E-140](../Intern/BEFUNDE.md#e-140) (Zeichensatzangabe beim Speichern unter), [E-177](../Intern/BEFUNDE.md#e-177) (Notify Application) und [E-178](../Intern/BEFUNDE.md#e-178) nicht berühren, ist eine Vermutung aus den geänderten Dateien, nicht gemessen.
- Kosmetisch: `CHANGELOG.md:124` *„[LEKTOR-133](Befunde/LEKTOR-133.md#l-133.4) [L-133.4](Befunde/LEKTOR-133.md#l-133.4)“* — zwei Verweise auf dasselbe Ziel hintereinander.

**Vorschlag:** die drei Fälle beim nächsten Lauf am gemeinsamen Bau mitnehmen oder im CHANGELOG *„am Bau `cecab886*` grün“* schreiben.

Werkzeug nach dem Merge: `tools/startzeilen-sammeln.pl` (aus `origin/e203_e204_persona_kennwort`, im Scratchpad ausgeführt): *„4 Zeile(n) fehlen hier“*, angehängt (18:00:20 bis 18:10:33), keine entfernt.
