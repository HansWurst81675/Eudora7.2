# Hier weitermachen

**Stand 30.10.2026.** Zuletzt veröffentlicht: **`v7.2.1.128`** (29.10.2026,
nach Gregors Test: [E-166](BEFUNDE.md#e-166) auf Hauptrechner und Laptop
bestanden). `main` ist gesperrt und wird nur von Gregor per Merge bewegt;
jeder Agent arbeitet in seinem eigenen Arbeitsbaum und Zweig (siehe
[AGENTEN.md](AGENTEN.md)). Ziel und Kriterien: [ZIEL.md](../ZIEL.md).
Fassungsgeschichte: [CHANGELOG.md](../CHANGELOG.md).

**Was bisher geschah:** [WEITERMACHEN-bis-7.2.0.md](WEITERMACHEN-bis-7.2.0.md)
— alle Stand-Blöcke, die Paketgeschichte und die alten Pläne bis zum Release
7.2.1.128, zum Nachschlagen. Dort wird nichts mehr fortgeschrieben.

**Was zu tun ist, steht an genau einer Stelle:** in der Liste
[Nach dem Release 7.2.1](#nach-dem-release) darunter. [AUFGABEN.md](AUFGABEN.md)
ist seit dem 30.10.2026 nur noch zum Nachschlagen. Eine Aufgabe „nach dem
Release“ oder „nach 7.2.1“ an anderer Stelle dieser Datei oder in AUFGABEN.md
weist der Commit-Haken ab (`tools/pruefe-nach-dem-release.pl`).

## <a id="nach-dem-release"></a>Nach dem Release 7.2.1

Angelegt am 30.10.2026 nach Gregors Vorgabe vom 29.10.2026: *„wichtig ist,
daß es nicht wieder überall etwas verstreut ist“*. Je Zeile: was, warum, wo
die Einzelheiten stehen. Einzelheiten nur dort, hier nur der Verweis.

### Aufgaben ohne Befundnummer

Von Hand geführt. Erledigtes wird gestrichen, nicht abgehakt — die
Geschichte steht im Commit.

| Was | Warum | Wo die Einzelheiten stehen |
|---|---|---|
| **Zuerst, vor jedem neuen Thema:** den Rückstand an Regressionstests abarbeiten. Umfang aus `perl tools/pruefe-regressionstest.pl` (30.10.2026 vormittags: 11 kritische Befunde ohne jede Prüfung, alle noch offen, also erst mit ihrer Behebung testbar; E-120 auf Gregors Ja herabgestuft (kein Programmfehler); neu getestet E-60, E-64, E-72, E-82, S-1, S-8, E-156, E-3, E-23, E-32, V-1, nachmittags E-15, E-19, E-21, E-28, E-57, E-58, E-75, E-86, E-104, E-115, M-1 und über den Prüfstand E-13; E-2 über seine Ursache Z-2 gedeckt). Dazu die Schwächen dieser Tests aus [PRÜFER-66 K3/K4](../Befunde/PRUEFER-66.md#k3) und [PRÜFER-67 K4](../Befunde/PRUEFER-67.md#k4): `#if 0` und PowerShell-Blockkommentare `<# … #>` werden nicht weggeworfen, andere Schreibweisen (`ASSERT (`, `_ASSERTE(`, `UnwrapText(` ohne `::`) bleiben grün | Gregor 23.10.2026, festgehalten in [ZIEL.md](../ZIEL.md); die Reihenfolge von damals steht im Archiv | [Archiv, „Die Reihenfolge“](WEITERMACHEN-bis-7.2.0.md#regressionstests), [L-100.1](../Befunde/LEKTOR-100.md#l-100.1) |
| Restliche Zusicherungen wie bei E-15 und E-19 entfernen: `tocdoc.cpp:680, 700, 725, 751` (`ASSERT(0)` für Out, Trash, Junk und ein gleichnamiges normales Postfach) und `settings.cpp:1490` (`ASSERT(QCGetTaskStatusView())`) | feuern nur im Debug-Bau auf normalen Wegen; die Tests lesen nur den behobenen Zweig | [PRÜFER-67 K2/K3](../Befunde/PRUEFER-67.md#k2) |
| Übersicht „Was Eudora kann“: Menüs, *Tools → Options*, Filteraktionen und die relevanten `Eudora.ini`-Schlüssel (`IDS_INI_*` in `EudoraRes.rc`); nur am Programm Bestätigtes in die FAQ | Gregor 29.10.2026: *„ja, mach das nach dem release. zusätzich die tools -> options einstellungen. und auch aus relevantes der eudora.ini“* | [Doku/FAQ.md](../Doku/FAQ.md) |
| Formprüfung: eine angekündigte Tabelle, Liste oder Spalte muss am Ziel des Verweises auch so dastehen | LEKTOR-96 fand Ankündigungen ohne passende Form; das Werkzeug ist vorgeschlagen, nicht gebaut | [LEKTOR-96, Vorschlag](../Befunde/LEKTOR-96.md#werkzeug), [L-96.6](../Befunde/LEKTOR-96.md#l-96.6), [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), Vorschlag 3 |
| `pruefe-tabellenzeilen.pl` sieht einen senkrechten Strich in einer Codespanne nicht als Zellgrenze | GitHub trennt dort die Zelle und schneidet die Zeile ab; die Schranke ist dafür blind | [L-96.3](../Befunde/LEKTOR-96.md#l-96.3), [PRUEFER-65 K3](../Befunde/PRUEFER-65.md#k3) |
| Alte Nummernform in Meldungstexten und in `Releases/PAKETE.md` | Texte nennen noch das Schema vor dem 29.10.2026 | [PRUEFER-65 K4](../Befunde/PRUEFER-65.md#k4) |
| `Intern/FILTER.md` nennt verrutschte Zeilenangaben | die Verweise zeigen auf andere Stellen als beschrieben | [L-92.2](../Befunde/LEKTOR-92.md#l-92.2) |
| Schranke `pruefe-changelog-zuwachs.pl` bauen: ein Commit mit Code ohne CHANGELOG-Zuwachs wird abgewiesen | am 29.10.2026 zweimal an einem Tag ein Commit ohne CHANGELOG | [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), Vorschlag 1 |
| Schranke: ein Ergebnis im TESTPLAN gegen das Urteil in BEFUNDE.md | E-166 stand 87 Minuten nur im TESTPLAN als bestanden | [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), Vorschlag 2 |
| `PreToolUse`-Haken gegen das Schreiben von `.md`-Dateien über die Befehlszeile | braucht Gregors Ja; die Frage allein stellen | [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), Vorschlag 5 |
| Merge-Commit `80f340d5` mit der Nachricht `;rgb:…` klären; dazu der Hinweis `git pull` in `tools/pruefe-branch.pl:256` | Herkunft ungeklärt; nach einem Umschreiben der Geschichte ist `git pull` der falsche Rat | [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), „Für die Hauptsitzung“ |
| Gedächtnisindex `MEMORY.md` kürzen (22 KB am 30.10.2026) | er wird zu Beginn jeder Sitzung geladen | [Stand 29.10.2026](../Arbeitsweise/stand-29-10-2026.md), Nachtrag 21:55 |
| Gregors Frage vom 29.10.2026, 09:11, beantworten: *„wie kam es denn überhaupt dazu?“* | die Antwort war angekündigt und kam nicht | [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), [gedaechtnis-ist-oeffentlich](../Arbeitsweise/gedaechtnis-ist-oeffentlich.md) |
| Kriterium 0 (das Paket läuft ohne Nachinstallieren) auf einem Rechner ohne Visual Studio | nie auf einem solchen Rechner gemessen | [L-77.3](../Befunde/LEKTOR-77.md#l-77.3), [ZIEL.md](../ZIEL.md) |
| Neun Messskripte liegen nur unter `C:\Temp` (`messen-*.ps1`) | ein Aufräumen, und die Messungen sind unwiederholbar; am 30.10.2026 alle neun noch vorhanden | [Archiv, Punkt E](WEITERMACHEN-bis-7.2.0.md#offene-arbeiten) |
| Schranke gegen halbe Sätze in Texten nach außen | angefangen, nicht fertig | [Archiv, „Angefangen und nicht fertig“](WEITERMACHEN-bis-7.2.0.md#angefangen) |
| Alte Punkte ohne Nummer gegen den heutigen Stand prüfen und entweder einen Befund anlegen oder streichen: Regressionstests C, Spurmarke D, `Probe.mbx` G, Fenster nach Neustart nicht im Vollbild, `EuMemMgr.dll` ohne Projekt, neun Zeigerstellen aus X-3 | stammen aus der Zeit vor 7.2.1; ob sie noch zutreffen, ist am 30.10.2026 nicht nachgemessen | [Archiv](WEITERMACHEN-bis-7.2.0.md), [AUFGABEN.md](AUFGABEN.md) D3a |
| `tools/pruefbericht.pl:392` verweist auf eine „Ergebnistabelle im Kopf von TESTPLAN je Kriterium“, die es nicht gibt; die Buchführung in `Intern/TESTPLAN.md:584` endet am 23.10.2026 | der Satz kommt in jeden neuen Prüfbericht | [L-96.6](../Befunde/LEKTOR-96.md#l-96.6) |
| `PurgeIniSetting` schreibt am Zwischenspeicher vorbei: eine zurückgesetzte Einstellung kann wirkungslos bleiben, wenn sie in derselben Sitzung geändert wurde. Als Befund anlegen (die dort vorgeschlagene Nummer E-167 wurde nie vergeben) | am Quelltext belegt, nicht gemessen | [PRUEFER-64 K5](../Befunde/PRUEFER-64.md#k5) |
| Kleinigkeiten in den Messskripten und in `testlauf.ps1` | laut Prüfbericht offen | [PRUEFER-64 K6](../Befunde/PRUEFER-64.md#k6) |
| Die Spurzeile zu E-137 sagt nicht, ob eine Marke verworfen wurde | aus der Zeile allein lässt sich ein Strg+W ohne Leiste nicht von einem verworfenen Klick unterscheiden | [PRUEFER-63 K2](../Befunde/PRUEFER-63.md#k2) |
| `verlauf-messen.pl --offen`: jede Frage Gregors ohne Antwort auflisten | Einwurf ohne Antwort, am 29.10.2026 zum dritten Mal | [CHRONIST 30.10.](../Arbeitsweise/CHRONIST-2026-10-30.md), Vorschlag 1 |
| Vor „nichts läuft mehr“ auch die Hintergrundaufträge prüfen, nicht nur Git | am 29.10.2026 lief ein Auftrag unbemerkt weiter | [CHRONIST 30.10.](../Arbeitsweise/CHRONIST-2026-10-30.md), Vorschlag 2 |
| Teilstring-Ersetzer mit Selbsttest neben `tools/ersetze-bereich.pl` (erster Testfall: der neue Text enthält den alten) | ein Ersetzungshelfer lief am 29.10.2026 endlos | [CHRONIST 30.10.](../Arbeitsweise/CHRONIST-2026-10-30.md), Vorschlag 3 |
| `pruefe-release-buchfuehrung.pl` prüft nur Absätze mit vier festen Wendungen, nicht jeden Satz über den Gegenwartsstand | LEKTOR-99 fand drei veraltete Stellen hinter grüner Prüfung | [CHRONIST 30.10.](../Arbeitsweise/CHRONIST-2026-10-30.md), Vorschlag 4; [L-100.8](../Befunde/LEKTOR-100.md#l-100.8) |
| Prüfwerkzeuge, die still nichts sehen: `testlauf.ps1` erkennt keinen Absturz während der Messung, `pruefe-startwege.pl:163`, `pruefe-rueckstrich.pl` liest keine `stand-*.md`, `pruefe-nachgestellt.pl` seit 1.0.121 blind | ein grüner Prüfstand sagt dann nichts | [CHRONIST 29.10. abends](../Arbeitsweise/CHRONIST-2026-10-29b.md), Punkt 6; [E-157](BEFUNDE.md#e-157) |
| `tools/arbeitsbaum-frei.pl --belegen` bucht den ersten freien statt des aktuellen Arbeitsbaums | am 23.10.2026 zweimal falsch, einmal der Hauptbaum; das Werkzeug ist seither unverändert | [Archiv, „Kleinere Reste“](WEITERMACHEN-bis-7.2.0.md#kleinere-reste) |
| Die offenen Punkte in `Intern/AUFGABEN.md` prüfen und hierher übernehmen oder streichen: Tabelle „Was sonst noch offen ist“, C3, E1–E3, F | AUFGABEN.md ist seit dem 30.10.2026 nur noch zum Nachschlagen | [AUFGABEN.md](AUFGABEN.md), [L-100.2](../Befunde/LEKTOR-100.md#l-100.2) |

Von Gregor **zurückgestellt**, nicht von selbst aufgreifen: die
Hostnamenprüfung (siehe [AUFGABEN.md](AUFGABEN.md) am Ende).

### Offene Befunde

Diese Tabelle wird aus `BEFUNDE.md` **erzeugt** — `tools/offene-befunde.pl`
setzt sie und weist im pre-commit ab, wenn ein Befund fehlt oder einer
darinsteht, der längst behoben ist. Von Hand eintragen lohnt nicht; der
nächste Lauf überschreibt es. Was jeweils als Nächstes zu messen ist, steht in
der letzten Spalte und ausführlich in [BEFUNDE.md](BEFUNDE.md).

<!-- offene-befunde: Anfang -->

| Kennung | worum es geht | zuletzt gemessen | was noch fehlt |
|---|---|---|---|
| **[E-176](BEFUNDE.md#e-176)** | Die Behebung von E-28 liest beim Schließen einer verworfenen neuen Nachricht aus einer sc… | **nie gemessen** | ein Test, der `CSummary` und `CMessageFrame` echt anlegt (`TestE176.cpp` liest bisher nur den Quelltext), und die Messung am Programm, am besten unter… |
| **[E-173](BEFUNDE.md#e-173)** | Im Filterfenster sind die Labels der Aktion *Make Label* einmal ausgegraut und nicht wähl… | **nie gemessen** | erst **nach dem Release 7.2.1** — nachstellen (unter welcher Bedingung ist die Liste grau: neuer Filter, bestimmte vorherige Aktion, Persönlichkeit… |
| **[E-172](BEFUNDE.md#e-172)** | Eine Mail steht im Lesefenster als rohe Base64-Zeichenfolge statt als lesbarer Text | **nie gemessen** | erst **nach dem Release 7.2.1** (Gregor 29.10.2026) — Quelltext der Mail ansehen (*View Source*), Kopfzeilen `Content-Type`/`Content-Transfer-Encodi… |
| **[E-171](BEFUNDE.md#e-171)** | „Search Mailfolder“ im Rechtsklickmenü einer Mail bringt ohne markierten Text die Mel… | 29.10.2026 an 7.2.0.127 | erst **nach dem Release 7.2.1** (Gregor 29.10.2026) — ohne Auswahl das Suchfenster öffnen, aber nicht starten (oder den Menüpunkt sperren); vorher… |
| **[E-170](BEFUNDE.md#e-170)** | Das Label einer Mail geht verloren, wenn man sie innerhalb eines IMAP-Kontos in einen ande… | **nie gemessen** | erst **nach dem Release 7.2.1** (Gregor 29.10.2026: *„die findigs können wir erst nach dem release beheben. das muß nur erstmal nur als befund dri… |
| **[E-169](BEFUNDE.md#e-169)** | Die Druckvorschau einer HTML-Mail zeigt keine Bilder und keine farbigen Flächen — im Le… | **nie gemessen** | erst **nach dem Release 7.2.1** (Gregor 29.10.2026) die Ursache — welche Mails es trifft und warum die Zwischendatei `eud*.htm` ohne Bilder gedruckt… |
| **[E-165](BEFUNDE.md#e-165)** | Die Vervollständigungsbox im To:-Feld sieht mit einem einzigen Treffer verbaut aus — wi… | **nie gemessen** | am Prüfstand `C:\Temp\E135-box` mit **einem** passenden Kurznamen messen (Außen- und Innenmaß der Box und der Liste, Bildlaufleisten-Stil), danach … |
| **[E-159](BEFUNDE.md#e-159)** | Ein Prüfstandslauf an 7.2.0.122 endete mit einem Absturz in Eudora.exe selbst, den nieman… | 26.10.2026 an 7.2.0.122 — **veraltet** | den Versatz gegen die Symbole eines Baus 7.2.0.122 auflösen (die PDB dieses Zwischenstands ist überschrieben; ein Neubau von `62f6047c` mit denselbe… |
| **[E-157](BEFUNDE.md#e-157)** | Die Prüfstandsläufe verändern Gregors Windows-Registry und sehen keine Abstürze — je… | 26.10.2026 an 7.2.0.124 | nach jedem Testpaket dieselbe Zählung für Gregors Paketverzeichnis (für 7.2.0.124 muss sie null sein); ein Fall im Prüfstand, der einen echten Abs… |
| **[E-151](BEFUNDE.md#e-151)** | Die Prüfstandsfälle lassen sich aus einem frischen Klon nicht ausführen — die Verzeic… | **nie gemessen** | ein Werkzeug, das jeden Prüfstand aus dem Repo neu aufbaut (Testdaten plus INI-Vorlage je Stand); je Fall eine Zeile Klartext; der Abschnitt „Vorau… |
| **[E-147](BEFUNDE.md#e-147)** | Die Reparatur zerstörter Umlaute und Sonderzeichen aus dem Plug-in EudoraUnicodeFix soll … | **nie gemessen** | Rays Antwort im Issue #102, ob er die Veröffentlichung möchte; danach (nach 7.2.1) die Reparatur an der Stelle einbauen, an der eingehender Text ges… |
| **[E-143](BEFUNDE.md#e-143)** | Aus dem Suchfenster und aus Filtern kommt der Out-Hinweis je Nachricht — zwanzig Treffer… | **nie gemessen** | eine Entscheidung und dann der Einbau. Entweder den Hinweis unterdrücken, wenn der Aufruf nicht vom Anwender kommt — `SingleSum && !RedisplayTOCs` … |
| **[E-142](BEFUNDE.md#e-142)** | Ein Entwurf aus einem IMAP-Ordner nach Out gezogen ergibt in Out eine LEERE Nachricht — … | 26.10.2026 an 7.2.0.124 | vor 7.2.1 nichts — Gregors Entscheidung 13 (26.10.2026): *Send Again* aus IMAP ergibt eine leere Mail (T6), das kommt erst nach 7.2.1 dran; Entwürf… |
| **[E-141](BEFUNDE.md#e-141)** | Eine Übertragung aus einem IMAP-Ordner nach Out stößt die ganze IMAP-Nachbearbeitung an… | **nie gemessen** | die Messung am IMAP-Prüfserver — am alten Bau stößt eine Übertragung IMAP → `Out` die Nachbearbeitung an, am neuen nicht mehr. Die Berichtigun… |
| **[E-140](BEFUNDE.md#e-140)** | Zwei weitere Speicherwege gehen an der Zeichensatz-Ergaenzung vorbei — *File → Save As… | **nie gemessen** | jede Messung — niemand hat diese beiden Wege je gefahren. Zu messen: aus dem Nachrichtenfenster und aus dem Verfassen-Fenster je eine Nachricht mit … |
| **[E-139](BEFUNDE.md#e-139)** | Die Meldung „Rechtschreibprüfung nicht vorhanden" kommt nach jedem Programmstart einmal… | **nie gemessen** | der Einbau in `ZeigeHinweisEinmal()` (`spell.cpp:58`) — statt `AfxMessageBox` ein `NoteDialog(<neuer INI-Schlüssel>, <neue Zeichenkette>)`. Zwei Di… |
| **[E-138](BEFUNDE.md#e-138)** | Nach dem Herunterladen von GitHub lässt sich Eudora.exe nicht starten — nur der Umweg … | **nie gemessen** | an der Doku nichts mehr. Der Hinweis steht seit dem 23.10.2026 in **vier** Dateien, von [LEKTOR-52](../Befunde/LEKTOR-52.md) nachgezählt: `README.md`… |
| **[E-136](BEFUNDE.md#e-136)** | Ein Zeichen, das richtig auf dem Bildschirm steht, wird beim Speichern zerstört — aus … | 22.10.2026 an 7.2.0.120 — **veraltet** | die Stelle, an der beim Speichern nach windows-1252 umkodiert wird. Sie ist **nicht** gefunden — die einzige CP1252-Umwandlung mit dem E-90-Filter i… |
| **[E-133](BEFUNDE.md#e-133)** | Zeigt die Registry auf ein Mailverzeichnis, das es nicht mehr gibt, weigert sich Eudora zu… | **nie gemessen** | Gregor hat *„nur aufnehmen, nicht fixen"* entschieden — aufzugreifen wäre, bei fehlendem Verzeichnis zu fragen oder ein eigenes anzulegen statt d… |
| **[E-129](BEFUNDE.md#e-129)** | Nach einem Verschieben in einen IMAP-Ordner ohne Verbindung und sofortigem Beenden zeigt d… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | beide Mängel stehen noch — (1) warum beim Beenden ohne Serververbindung nur **ein** statt fünf Verzeichniseinträgen geschrieben wird, ist nicht u… |
| **[E-128](BEFUNDE.md#e-128)** | Eine gespeicherte Nachricht heißt .txt und enthält HTML — der Anwender erfährt es nic… | 23.10.2026 an 7.2.0.120 — **veraltet** | die Entscheidung über den eigenen Vorschlag und dann sein Einbau — die Vorgabeendung aus dem Inhalt ableiten (`.html`, `.eml`, `.txt`) und den Date… |
| **[E-126](BEFUNDE.md#e-126)** | Eine gesendete Mail, die genau während eines Abgleichs des Ziel-IMAP-Ordners dorthin vers… | 23.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | jede Messung — die Vermutung aus [PRÜFER-33](../Befunde/PRUEFER-33.md) Q1 ist nie beobachtet worden, weder bei Gregor noch am Prüfstand, und dort … |
| **[E-124](BEFUNDE.md#e-124)** | Microsoft Defender stuft eine Eudora-Fassung als Trojaner ein und beendet das laufende Pro… | 28.10.2026 an 7.2.0.127 | der Vorgang bei Microsoft ist **abgewiesen** (zu viele Dateien im Upload, siehe die Messung unten) — nachzuholen ist eine **neue** Einreichung mit *… |
| **[E-123](BEFUNDE.md#e-123)** | Nach einem Neustart mitten in einer Übertragung lokal → IMAP können eingebettete Bilde… | 22.10.2026 an 7.2.0.121 — **veraltet** | der Verlust eingebetteter Bilder nach **Absturz, Defender, Stromausfall oder erzwungenem Herunterfahren**. Abgearbeitet ist nur der ordentliche Beende… |
| **[E-122](BEFUNDE.md#e-122)** | Das Eingangsdatum einer in einen IMAP-Ordner hochgeladenen Nachricht ist um die Zeitzone v… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die Berichtigung selbst — `ImapMailbox.cpp:4281` übergibt `CSummary::m_Seconds` an `append_date`, das echtes UTC erwartet, während `m_Seconds` UTC… |
| **[E-109](BEFUNDE.md#e-109)** | Die Schranken waren da und haben nicht gehalten — *„es gibt viele schranken, die genau… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die drei Forderungen sind nicht umgesetzt — je Schranke ein Testfall für ihre **bekannte Grenze**, eine Unterscheidung zwischen *geprüft und frei*… |
| **[E-98](BEFUNDE.md#e-98)** | Die beiden Optionen im Speicherdialog fehlen — *Kopfzeilen einschließen* (Include Heade… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | zweierlei ist nicht gemessen — welche Vorgabe für *Kopfzeilen einschließen* und *Absätze raten* tatsächlich greift, solange die Kästchen fehlen… |
| **[E-92](BEFUNDE.md#e-92)** | der Weiterleitungskopf ist bei Thunderbird eine ausgerichtete kleine Tabelle — auf Grego… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | unsere eigene Seite — ein Vergleichsbild aus Eudora zur selben Nachricht liegt nicht vor, es ist also offen, ob unser Weiterleitungskopf überhaupt … |
| **[E-91](BEFUNDE.md#e-91)** | zitierte Bereiche stehen bündig im Text, ohne Randbalken und Einrückung — auf Gregors … | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die **Messung selbst** — ungeklärt ist, ob Gregors Bild den Lese- oder den Verfassenweg zeigte und ob die Nachricht überhaupt ein `blockquote` tru… |
| **[E-90](BEFUNDE.md#e-90)** | Emoji in Betreffzeilen fallen ersatzlos weg (bis 7.2.0.58: sie erschienen als ?) — Grego… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | nichts, was für sich zu beheben wäre — `?` ist die bessere von zwei Möglichkeiten, solange Eudora durchgehend ANSI/MBCS gebaut ist (Begründung i… |
| **[E-78](BEFUNDE.md#e-78)** | die Standardanordnung der Leisten wird bei jedem Start nachgezogen, obwohl der Zustand ges… | 22.10.2026 an 7.2.0.121 — **veraltet** | die Auswertung der vorhandenen Spurmarken und danach die Behebung — `E-78 nach SetDockState` und `E-78 vor/nach LoadWazooBarConfig` (`mainfrm.cpp`, … |
| **[E-71](BEFUNDE.md#e-71)** | der Filterbericht ist nach einem Filterlauf leer | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | nicht die Behebung, sondern Gregors Freigabe — er hat ihn ausdrücklich auf die nächste Fassung geschoben. Die Messung steht fertig da: in `CFilter… |
| **[E-47](BEFUNDE.md#e-47)** | beim Öffnen der Kurznamen-/Verzeichnisdienst-Leiste kommt der Fehlerdialog *„Directory … | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | eine Entscheidung, keine Behebung — `MFC71.DLL` und `MSVCP71.dll` hat Microsoft nicht zur Weitergabe freigegeben, `RegisterCOMObjects()` scheitert d… |
| **[E-39](BEFUNDE.md#e-39)** | wird die aktuell benutzte Persönlichkeit gelöscht, kann ihr INI-Abschnitt teilweise wied… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die Bestätigung am laufenden Programm — belegt ist nur der Quelltext (`persona.cpp:565-566` und `:179-198`, `rs.cpp:1237-1250`). Zu fahren wäre: d… |
| **[S-6](BEFUNDE.md#s-6)** | Bereiche überlagern sich | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | das Nachstellen — ob sich die Bereiche heute überhaupt noch überlagern, ist seit dem 30.08.2026 **nie geprüft** worden. Die beiden damals genannt… |
| **[NP2-3](BEFUNDE.md#np2-3)** | BitBltTransparent meldet Erfolg, ohne gezeichnet zu haben | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die Behebung selbst — `CPaletteDC::BitBltTransparent` (`OTShim_Werkzeugleiste.cpp:239`) meldet unverändert Erfolg, ohne gezeichnet zu haben. Seit d… |
| **[NP3-3](BEFUNDE.md#np3-3)** | Kommentar zu CreateFromBitmap zählt die Aufrufstellen falsch | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | eine Zeile Text — der Kommentar in `OTShim_Bild.h:326-330` sagt weiterhin *„an drei von fünf Stellen"* und zählt die Aufrufstellen damit falsch.… |
| **[S-3](BEFUNDE.md#s-3)** | erster Lauf durch Gregor: drei Beobachtungen | 28.10.2026 an 7.2.0.127 | allein S-3c (die beiden Laufzeitbibliotheken) — `MFC71.DLL` und `MSVCP71.dll` fehlen dauerhaft, damit fallen die Verzeichnisdienste aus (Protokoll `… |
| **[NP2-2](BEFUNDE.md#np2-2)** | SysColorChange() tut nicht, was daneben steht | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | nur die Berichtigung des irreführenden Kommentars an `OTShim_Werkzeugleiste.cpp:326-328` (**nicht** an den drei Stellen, die hier bis zum 22.10.2026 … |
| **[NP3-2](BEFUNDE.md#np3-2)** | OnToolHitTest als int statt INT_PTR — x64-Sperre | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die Umstellung auf `INT_PTR` — `OnToolHitTest` ist an elf Stellen noch `int`: `OTShim_Reiter.cpp:1032`/`.h:570`, `OTShim_Werkzeugleiste.cpp:595`, `P… |
| **[A-1](BEFUNDE.md#a-1)** | Erscheinungsbild: fünf Punkte umgesetzt | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | nur `SECDockBar::SetControlBarWidthsInRow` (`OTShim.cpp:2830`) ist ein leerer Rumpf — die prozentualen Zeilenbreiten. **Niemand ruft sie auf**, die … |
| **[AN-1](BEFUNDE.md#an-1)** | Anhänge: lange Dateinamen abgeschnitten, Endung fehlt — elf Ursachen (Teile B5.1 bis B5… | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | allein **B5.7** — der IMAP-Weg ruft `SetExtension` nicht auf. Zehn der elf Teile sind behoben; im Test fiel es nicht auf, weil alle drei Namen schon… |
| **[NP3-1](BEFUNDE.md#np3-1)** | ZeigeInhaltsfenster läuft, bevor Eudora das Fenster umhängt | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die Umstellung der Reihenfolge — `ZeigeInhaltsfenster` (`OTShim_Reiter.cpp:1500-1503`) läuft weiterhin, bevor Eudora das Fenster umhängt (`Create`… |
| **[P-1](BEFUNDE.md#p-1)** | der POP-Abrufpfad gegengelesen, elf Altlasten benannt | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die neun Altlasten **P-1.5b bis P-1.5j** — wortgleich wie in `567a5d8`, keine davon angefasst. Nach Aufwand-Nutzen zuerst die beiden Einzeiler: **P-… |
| **[R-1](BEFUNDE.md#r-1)** | die Fehlerklasse hinter E-11 ausgezählt | 22.10.2026 an 7.2.0.121 (Quelltext) — **veraltet** | die 21 Änderungen selbst — 137 Vorkommen, 116 richtig gepaart, **21** zu ändern (16 `falsch`, 4 `lockbuffer`, 1 `danach`), seit dem 07.09.2026 kei… |

<!-- offene-befunde: Ende -->

## <a id="entscheidungen"></a>Geltende Entscheidungen

Gregors Entscheidungen vom 25. bis 29.10.2026, nummeriert, damit sie nicht
wieder gefragt werden. Werkzeuge verweisen mit „Entscheidung N,
Intern/WEITERMACHEN.md“ hierher; die Nummern bleiben deshalb fest. Ältere
Entscheidungen stehen im [Archiv](WEITERMACHEN-bis-7.2.0.md) bei ihrem
Stand-Block.

1. **Was 7.2.1.x heißt** — ohne Einschränkung weitergebbar außer den README-Punkten, alles implementiert und getestet, Testergebnisse im Repo, Tests dürfen nachkommen (wörtlich in [ZIEL.md](../ZIEL.md)). **7.2.0.123 ist nur das Testpaket**, veröffentlicht wird **7.2.1.\<n\>** mit der Marke **`v7.2.1.<n>`** (seit dem Release heißen auch Testpakete 7.2.1.\<n\>, Entscheidung 20).
2. **Vor 7.2.1 beheben:** [E-137](BEFUNDE.md#e-137) — erster Teil von Gregor am 26.10.2026 an Paket 1.0.123 bestätigt, zweiter Teil an 1.0.124 bestätigt (T1, zweiter Durchgang), an 1.0.125 nicht bestanden (U1), fünfter Anlauf mit Korrektur eingebaut, von Gregor am 27.10.2026 an 1.0.127 bestätigt (V1–V3 aus seinem Protokoll, Gegenprobe V6) — **eingelöst** — *„sollte z.b. nur das filter fenster geschlossen werden. alternativ mit Ctrl-L (wie öffnen, so wieder schließen)"*: Strg+W versteckt nur die Wazoo-Leiste; [E-142](BEFUNDE.md#e-142) — der vereinbarte Hinweis (eingebaut am 26.10.2026, von Gregor an 1.0.123 gemessen, TESTPLAN N3); [E-146](BEFUNDE.md#e-146) (*„plus: e-146"*), dazu „Server lehnt Umbenennen ab" (**behoben am 26.10.2026**, am Prüfstand rot und grün). **In die README unter „Bekannte Fehler":** [E-144](BEFUNDE.md#e-144), [E-143](BEFUNDE.md#e-143), [E-139](BEFUNDE.md#e-139), [E-136](BEFUNDE.md#e-136), [AN-1](BEFUNDE.md#an-1) (Endung über IMAP).
3. **Logzeile** in `eudora.log`, aus welchem Verzeichnis `rootcerts.p7b` geladen wurde (*„zeile im log, ja"*). **Eingebaut am 26.10.2026** (`QCWorkerSocket.cpp`, Test `TestRootCertsLog.cpp`), am laufenden Programm gemessen an Gregors Paket 1.0.123 (TESTPLAN K3, Protokollzeile mit dem Programmverzeichnis).
4. **E-132:** Gregor testet nur Schritt 1–4 (*„schritt 5 geht nicht"* — Schritt 4 merkt sich die Antwort in der `DEudora.ini`); der ganze Weg wird ein Prüfstandsfall.
5. **Regressionstests:** die rote Probe ohne Behebung nur einmal beim Anlegen eines Tests, danach genügt grün.
6. **Message-ID — kein Befund:** die Message-ID (`msgdoc.cpp` `AssignMessageId`, z. B. `<7.2.0.122.2.20261025200323.06321090@127.0.0.1>`) entspricht RFC 5322; Randfälle (Rücksendeadresse ohne `@` ergibt `wheresmymailserver.com`) werden nicht aufgenommen — *„mir reicht, wenn wir generell hier nicht gegen die standards verstoßen"* (Gregor, 25.10.2026).
7. **Entschieden von Gregor am 26.10.2026:** die Nebenwirkung von E-77 auf ältere Nachrichten mit Ablage in einen Umlaut-Ordner (PRÜFER-49 K3) und die offenen Befunde [E-140](BEFUNDE.md#e-140), [E-141](BEFUNDE.md#e-141), [E-145](BEFUNDE.md#e-145) kommen **in die README** unter „Bekannte Fehler“, behoben wird nach 7.2.1. Wo es jetzt steht: [Nach dem Release 7.2.1](#nach-dem-release).
8. **Entschieden von Gregor am 26.10.2026, beim Test an 7.2.0.123:** [E-137](BEFUNDE.md#e-137) zweiter Teil (Strg+W nach einem Klick auf eine Beschriftung der Leiste schließt die Mail) ist zu beheben (Antwort „A“), mit neuem Testpaket 7.2.0.124 — *„erstmal teste ich weiter, dann aber A“*. Eingebaut auf dem Zweig `0.123_ergebnisse`.
9. **Entschieden von Gregor am 26.10.2026:** die E-142-Rückfrage wählt **No** vor — *„no wäre besser“*; bis dahin war *Yes* vorgewählt (ein unbedachtes Enter legte die leere Nachricht in `Out` an). Eingebaut auf dem Zweig `0.123_ergebnisse`.
10. **Entschieden von Gregor am 26.10.2026:** die Versionsnummer ist **einheitlich** — das Release heißt überall **7.2.1.N** (Fenstertitel, Dateiversion, `VERSION`, ZIP `Eudora72-7.2.1.N-release.zip`, Marke `v7.2.1.N`), **ohne RC und ohne die Zählung „Paket 1.0.x“** (*„die versionsnummer soll schon einheitlich sein“*, *„ja, ohne RC und ohne 1.0.x“*). Testpakete bleiben 7.2.0.N und nur lokal bei Gregor (**seit dem 30.10.2026 abgelöst durch Entscheidung 20:** nach dem Release heißen auch Testpakete 7.2.1.N). Die Werkzeuge, die `VERSION` als `1.0.x` lesen, werden beim Schnüren des Release in einem Zug umgestellt. **Bestätigt und genauer gefasst am 29.10.2026** (Gregor: *„1. ja, 2. ja, 3. ja“* auf drei Punkte): 1. die Titelzeile heißt `Eudora 7.2.1.N+<commit> <Zeit>`, ohne „/ Paket“; 2. `VERSION` trägt dieselbe ganze Nummer wie `Version.h`; 3. die **Endnummer zählt über alle Formen weiter**, das erste Release heißt also **7.2.1.128** (nicht 7.2.1.1). Dazu: *„ja, direkt 7.2.1.128 bauen, ich teste dann das erste release“* — kein Testpaket 7.2.0.128. **Umgestellt** in `a5febb70` (15 Werkzeuge) und nach [LEKTOR-95](../Befunde/LEKTOR-95.md#l-95.4) `ausliefern.pl`; beschrieben in [PAKETE](../Releases/PAKETE.md#drei-zählungen-und-wie-sie-zusammenhängen).
11. **Entschieden von Gregor am 26.10.2026:** **kein** Hinweis in der README für Anwender von `v1.0.120` zu den Debug-Fassungen im Paket ([E-156](BEFUNDE.md#e-156)) — *„eine solche meldung brauchen wir nicht.“* Die Frage aus [LEKTOR-73](../Befunde/LEKTOR-73.md) bis [LEKTOR-75](../Befunde/LEKTOR-75.md) ist damit beantwortet.
12. **Entschieden von Gregor am 26.10.2026 (zu TESTPLAN T4 an 1.0.124):** ein Entwurf, der aus einem IMAP-Ordner zurück nach `Out` gezogen wird, nachdem Eudora ihn vom Server neu geladen hat, wird **abgelehnt** (E-125-Hinweis), nicht wieder als Entwurf erkannt — *„ja, die ablehnung reicht, wenn man es über message -> send again verschicken kann.“* **Bedingung:** *Message → Send Again* muss aus dem IMAP-Ordner heraus eine sendbare Nachricht ergeben; Gregor hat es an 1.0.124 geprüft (T6): die Mail ist leer, die Bedingung ist **nicht** erfüllt — siehe Entscheidung 13 ([E-142](BEFUNDE.md#e-142)).
13. **Entschieden von Gregor am 26.10.2026, nach T6:** *Send Again* aus einem IMAP-Ordner ergibt eine leere Mail (T6 nein), damit lässt sich ein Entwurf, der einmal in einem IMAP-Ordner lag, in Eudora nicht mehr verschicken. Das kommt **erst nach 7.2.1** dran, Gregor: *„nur dokumentieren, evtl. mit nummer im befund, daß wir es später lösen wollen.“* Entwürfe bleiben im lokalen `Out` (*„einfach im out lassen?“* — *„dann reicht es ja.“*). Steht in der README unter „Bekannte Fehler“ ([E-142](BEFUNDE.md#e-142)). Wo es jetzt steht: [Nach dem Release 7.2.1](#nach-dem-release).
14. **Entschieden von Gregor am 26.10.2026:** **keine Code-Signatur** — *„ich verdiene mit dem projekt kein geld, werde daher keins für zertifikate ausgeben.“* Gegen den Defender-Fehlalarm ([E-124](BEFUNDE.md#e-124)) bleibt die neue Einreichung bei Microsoft (nur die `Eudora.exe`), *„nicht heute“*; gegen die Download-Sperre ([E-138](BEFUNDE.md#e-138)) der Hinweis in der README.
15. **Entschieden von Gregor am 29.10.2026:** die Behebung von [E-166](BEFUNDE.md#e-166) bleibt im Zweig und geht **mit dem Release 7.2.1** hinaus (*„können wir erst nach dem release machen. ist nicht dringend. reicht unter 'bekannte fehler'“*; auf die Rückfrage „zurücknehmen oder drin lassen“: *drin lassen*). **Kein Testpaket 7.2.0.128 dafür** — Gregor prüft es an der Release-Fassung: *„ich werde es mit der release version überprüfen.“* Der Prüfschritt steht in [TESTPLAN](TESTPLAN.md#e-166-am-release). In der README steht E-166 unter „Bekannte Fehler“.
16. **Entschieden von Gregor am 29.10.2026:** die neuen Befunde [E-169](BEFUNDE.md#e-169) bis [E-172](BEFUNDE.md#e-172) werden **erst nach dem Release 7.2.1** behandelt — *„die findigs können wir erst nach dem release beheben. das muß nur erstmal nur als befund drin stehen.“* Für das Release stehen sie in der README unter „Bekannte Fehler“. Wo sie jetzt stehen: [Nach dem Release 7.2.1](#nach-dem-release).
17. **Entschieden von Gregor am 29.10.2026:** die veröffentlichten Release-Texte `v1.0.113`, `v1.0.117`, `v1.0.120` werden berichtigt (*„ja, die release-texte auf github berichtigen“*) — erledigt am selben Tag, 2 + 2 + 3 Links von `blob/main/BEFUNDE.md` auf `blob/main/Intern/BEFUNDE.md`, mit `gh release view` nachgezählt.
18. **Entschieden von Gregor am 29.10.2026:** Firmennamen von **Werbe-Absendern** bleiben im Repo — *„werbe absender sind unkritisch“*. Alles andere aus seinem Postfach (Betreffzeilen, Personen- und Kontonamen, Adressen, Anhangnamen) kommt nicht ins öffentliche Repo — *„solche daten haben jetzt und in zukunft nicht im öffentlichen repo zu suchen!“*; die Git-Geschichte wird nicht umgeschrieben (Gregor lehnt das Aufheben der Sperre auf `main` ab).
19. **Entschieden von Gregor am 29.10.2026:** weitere Release-Texte berichtigt (*„ja, release texte bereinigen“*) — `v1.0.72`, `v1.0.84` (ein Wort aus einer Werbe-Betreffzeile), `v1.0.2`, `v1.0.3`, `v1.0.10`, `v1.0.43` (tote Links); erledigt am selben Tag, auf GitHub nachgezählt 0 Treffer. Die gemergten Zweige auf GitHub hat Gregor selbst gelöscht.
20. **Entschieden von Gregor am 30.10.2026:** **ab dem Release 7.2.1.128 heißt jede neue Fassung 7.2.1.N** — Testpaket wie Release; das nächste Paket ist **7.2.1.129** (*„7.2.1.129 ist richtig. ab dem release geht es dann mit 7.2.1 weiter“*). Das ändert Entscheidung 10, nach der Testpakete 7.2.0.N heißen sollten. Ein Release ist damit ein Testpaket, das Gregor getestet und freigegeben hat, unter derselben Nummer. Die Endnummer zählt weiter wie bisher.

## Wie man misst

Alles, was man dafür braucht, steht bereit — es muss niemand danebensitzen.

**Protokollierung einschalten.** In `Mailverzeichnis\Eudora.ini` unter
`[Settings]`:

```
LogLevel=32896
```

Ohne diese Zeile schreibt Eudora nichts: `PutDebugLog` prüft die Maske und kehrt
sonst sofort zurück (`QCUtils/src/debug.cpp:140`). 32896 = `DEBUG_MASK_MISC`
(0x8000) + `DEBUG_MASK_TOC_CORRUPT` (0x80). Danach stehen die Spurmarken mit
[`E-27`](BEFUNDE.md#e-27) in `Mailverzeichnis\eudora.log`.

**Absturzbericht auswerten:**

```bash
perl tools/absturz-auswerten.pl
```

Findet `Exception.log` und `Eudora.map` selbst und macht aus jeder Stapelzeile
einen Funktionsnamen. Bei Berichten vor 7.2.0.13 sagt es, dass es nicht geht,
statt zu raten.

**Unter dem Debugger laufen lassen** — muss die **32-Bit**-PowerShell sein:

```
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File tools\stapel-untersuchen.ps1 -Exe <Paket>\Eudora.exe -Argumente "<Mailverzeichnis>"
```

Er fängt die tödliche Ausnahme ab und **tastet den Stapel ab** — die EBP-Kette
taugt bei Paige nichts, die DLL ist ohne Rahmenzeiger übersetzt.

**Eudora ohne Maus bedienen.** Meldungsfenster der Klasse `#32770` mit
`SendMessage(h, WM_COMMAND=0x0111, IDOK=1, 0)` schließen, dann
`PostMessage(hauptfenster, 0x0111, 32797, 0)` an die Fensterklasse
`EudoraMainWindow` für *Neue Nachricht* (`ID_MESSAGE_FORWARD` ist 32799).
Fensterliste über `EnumWindows` + `GetWindowThreadProcessId`; bei
`GetClassName`/`GetWindowText` unbedingt `CharSet=CharSet.Unicode`.

## Bauen und packen

```powershell
powershell -ExecutionPolicy Bypass -File tools\bauen.ps1 -Konfiguration Release
```

Meldet Erfolg nur, wenn vier unabhängige Prüfungen zustimmen. **MSBuild kann 0
zurückgeben und trotzdem nichts gebaut haben.**

Paket schnüren und prüfen:

```powershell
powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel <Verzeichnis> -Zip Releases\Eudora72-<VERSION>-release.zip -AusBauverzeichnis -Bauart Release
powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket <Verzeichnis>
```

**Eine Nummer je Bau.** Vor dem Packen `Eudora71/Version.h` und `VERSION`
hochsetzen und committen — sonst trägt die Bau-Kennung ein Sternchen und der
Bau ist nicht reproduzierbar.

## Nach einem frischen Klon

```bash
sh tools/hooks-einrichten.sh
```

Das war es. Zeilenenden sind seit `.gitattributes` (`* -text`) kein Thema mehr —
nachgemessen: ein frischer Auscheck mit erzwungenem `core.autocrlf=true` meldet
null geänderte Dateien.

## Wie hier gearbeitet wird

- [AGENTEN.md](AGENTEN.md) — Koordination paralleler Arbeit, aus fünf gemessenen
  Kollisionen
- [Arbeitsweise/](../Arbeitsweise) — die Lehren aus diesem Projekt, eine Datei je
  Lehre. **Vor dem Anfangen lesen**, besonders
  [mannschaft-fuehren.md](../Arbeitsweise/mannschaft-fuehren.md): ein Auftrag ohne
  konkrete Beobachtung liefert nichts, und jeder Rücklauf wird selbst
  nachgemessen
- Die Quellen sind **Latin-1 mit gemischten Zeilenenden**. `tools/pruefe-bytes.pl`
  vor jedem Commit; das Edit-Werkzeug zerstört beides lautlos
