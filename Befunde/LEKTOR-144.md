# <a id="lektor-144"></a>LEKTOR-144 (04.11.2026) — PR-Haken misst im Arbeitsbaum des eingereichten Zweigs, Zweig `pr_haken_zweig_messen` nach f4bdb2b2

**Umfang:** `git log --stat 535f22d5..HEAD` (ein Commit: `f4bdb2b2` — `tools/haken-pr-lektor.pl`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md`, `tools/TESTLAEUFE.md`, drei Dateien unter `Arbeitsweise/`). Gelesen: Kopfkommentar und Code des Hakens gegen WERKZEUGE, ZWEIGE, `CLAUDE.md`, `Intern/AGENTEN.md` und jede Lehre, die den Haken nennt (`grep -l haken-pr-lektor` über alle MDs: 21 Dateien, davon 9 Berichte unter `Befunde/` und 6 CHRONIST-Laufberichte ohne Aussage über den Messort). Dazu sieben Proben mit echter Hook-Eingabe gegen das Skript dieses Zweigs. Der Stand der Funde aus [LEKTOR-143](LEKTOR-143.md#lektor-143) ist im heutigen Stand nachgesehen.

**Urteil:** Die Berichtigung trägt, und die Doku beschreibt sie richtig. Kein Dokument sagt noch, der Haken messe im Hauptordner. Ausnahme ist eine Stand-Notiz, die im selben Commit wie die Berichtigung entstand und sie „offen“ nennt ([L-144.3](#l-144.3)). Die Zahl „13 Fälle“ steht im Kopfkommentar richtig für die Erkennung des Befehls und in WERKZEUGE als ältere Stufe vor der heutigen „20“. Eine Lücke hat das neue Verhalten: steht der Pfad nach `cd` in Anführungszeichen, wird er nicht erkannt, und der Haken misst still wieder im Hauptordner ([L-144.1](#l-144.1), gemessen). Das ist nicht schlechter als vorher, steht aber in keinem Dokument. Vier Funde, keiner hält den Merge auf.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„Kein Widerspruch gefunden.“*, 19 Hinweise *„… nennt weder den Quellstand 7.2.2.132 noch die Paketnummer“*. Das ist derselbe Altbestand wie in [LEKTOR-143](LEKTOR-143.md#lektor-143).
* `perl tools/offene-befunde.pl` (gemessen): *„54 offene Befunde, in beiden Listen gleich.“*, *„davon aktuell gemessen 19“*, *„davon nur am Quelltext 2“*, *„veraltet gemessen 24“*, *„NIE gemessen 11“*.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„mit Testfall im Pruefstand 66 von 72“*, *„OHNE jede Pruefung 4 <- Rueckstand“*, *„Kein neues "behoben" ohne Regressionstest.“*
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* Es sieht nicht, dass `ZIEL.md:115` gegen Entscheidung 26 steht ([L-144.4](#l-144.4)).
* `perl tools/haken-pr-lektor.pl --selbsttest` (gemessen): *„Selbsttest: 20 Faelle, 0 rot.“* Davon sind 13 Fälle `@f` (Erkennung des Befehls) und 7 Fälle `@z` (Erkennung des Zweigs), so wie es `tools/haken-pr-lektor.pl:34` sagt.

## Proben mit echter Hook-Eingabe (gemessen)

JSON `{tool_input:{command:…}, cwd:"C:\Users\Gregor\Documents\github\Eudora7.2"}` an `perl tools/haken-pr-lektor.pl` aus `.wt/lektor` (Skriptstand `f4bdb2b2`):

| Befehl | Rückgabe | gemessener Baum laut Meldung |
|---|---|---|
| `gh pr create --head e188_loeschschranke …` | 2 | `.wt/e188`, *„LEKTOR ist faellig: seit seinem Bericht (fe71b1a) haben sich 11 Datei(en) …“* — richtig |
| `cd C:/…/.wt/e188 && gh pr create …` | 2 | `.wt/e188` — richtig |
| `cd "C:/…/.wt/e188" && gh pr create …` | 2 | **`main`: `C:/Users/Gregor/Documents/github/Eudora7.2`** — falscher Baum ([L-144.1](#l-144.1)) |
| `Set-Location .wt\e188; gh pr create …` | 2 | **`main`** — falscher Baum |
| `git -C .wt/e188 push; gh pr create …` | 2 | `main` — richtig, `gh` reicht dann den Zweig des Hauptordners ein |
| `gh pr create --head HansWurst81675:e188_loeschschranke …` | 2 | *„liegt in keinem Arbeitsbaum“* — hält auf, sicher |
| `cd .wt/e188 && gh pr create …` | 2 | *„liegt in keinem Arbeitsbaum“* — Pfad gegen den Ordner des Perl-Prozesses aufgelöst (hier `.wt/lektor`), nicht gegen `cwd` |

## Funde aus LEKTOR-143 — heutiger Stand

| Fund | Stand | Stelle |
|---|---|---|
| [L-143.1](LEKTOR-143.md#l-143.1) Drei Befunde bleiben offen auf einen Rest, der sich nicht herbeiführen lässt; falscher Grund für [E-39](../Intern/BEFUNDE.md#e-39) (leerer Rest einer gelöschten Persönlichkeit) | **offen** | `CHANGELOG.md:122` weiter *„[[E-39](../Intern/BEFUNDE.md#e-39)], [[E-210](../Intern/BEFUNDE.md#e-210)] und [[E-211](../Intern/BEFUNDE.md#e-211)] (am Programm nicht gemessen)“* |
| [L-143.2](LEKTOR-143.md#l-143.2) CHANGELOG *Neu* und README *Bekannte Fehler* sagen nicht, dass ein Rest offen ist | **offen** | `CHANGELOG.md:121` *„[[E-133](../Intern/BEFUNDE.md#e-133)] — fehlt das gespeicherte Mailverzeichnis, fragt Eudora …“* ohne Rest; `README.md:203` *„**Alle drei behoben in 7.2.2.132 — …**“* |
| [L-143.3](LEKTOR-143.md#l-143.3) „K3, K4“ ohne Klartext bei [E-194](../Intern/BEFUNDE.md#e-194) (`<x-flowed>`-Zeilen in der Textdatei) | **offen** | `CHANGELOG.md:40`, `Intern/WEITERMACHEN.md:88` *„K3, K4 und eine Prüf…“* |
| [L-143.4](LEKTOR-143.md#l-143.4) Name des nächsten Pakets, das nur Fehler behebt | **erledigt** (Gregor: 7.2.2.133); ein Rest steht in ZIEL ([L-144.4](#l-144.4)) | `Intern/WEITERMACHEN.md:169` *„26. **Entschieden von Gregor am 04.11.2026:** **seit 7.2.2.132 heißt jede Fassung 7.2.2.N …**“*; `CHANGELOG.md:3-5`, `Releases/PAKETE.md:52`, `Doku/MITARBEITEN.md:66`, `ZIEL.md:40-43` |
| [L-143.5](LEKTOR-143.md#l-143.5) Kleinkram in ZIEL und BEFUNDE | **offen** | `ZIEL.md:124-125` *„(im Testpaket 7.2.2.132, [[A-5](../Intern/BEFUNDE.md#a-5)])“*; `ZIEL.md:135` *„wartet auf Gregors Entscheidung“* |
| [L-143.6](LEKTOR-143.md#l-143.6) Werkzeuge: kein Selbsttest mit 7.2.2; Konflikt in `offene-befunde.pl` mit dem Zweig, der den Mailverlust beim Verschieben behebt | **teilweise**: Die Codezeile ist auf beiden Zweigen gleich, nur noch eine Kommentarzeile unterscheidet sich. Den Selbsttest gibt es weiterhin nicht. | `git diff HEAD origin/e188_loeschschranke --stat -- tools/offene-befunde.pl` → *„1 insertion(+), 1 deletion(-)“*, nur Kommentar (gemessen) |
| [L-142.5](LEKTOR-142.md#l-142.5) [E-188](../Intern/BEFUNDE.md#e-188) (Mail geht beim Verschieben verloren): BEFUNDE „nie gemessen“ | **offen auf diesem Zweig**, auf `e188_loeschschranke` fortgeschrieben (`9188426e` *„im Quellstand behoben, Pruefstand 8/8“*) | `Intern/WEITERMACHEN.md:92` |
| [L-142.6](LEKTOR-142.md#l-142.6) `main` sagt „Testpaket … nicht veröffentlicht“ | **erledigt** mit #218 | `git show origin/main:README.md` Zeile 104 *„Stand **7.2.2.132** — die erste Fassung der Reihe 7.2.2 …“* (gemessen) |
| [L-142.7](LEKTOR-142.md#l-142.7) Release-Notizen ohne Satz zum Rückstand an Regressionstests | **offen**, die Frage an Gregor steht | `Releases/7.2.2.132/RELEASE-NOTIZEN.md` zuletzt `61e94e4f` |
| [L-141.3](LEKTOR-141.md#l-141.3) Kennungen `E-220`/[`E-221`](../Intern/BEFUNDE.md#e-221) nur in Backticks | **offen, Merkposten** | `grep -c 'id="e-22[01]"' Intern/BEFUNDE.md` → 0 |
| [L-138.9](LEKTOR-138.md#l-138.9) Zahl der Berichte in der README | **offen** | `README.md:98` *„219 LEKTOR- und PRÜFER-Berichte“*; gezählt 234, mit diesem 235 |
| [L-140.2](LEKTOR-140.md#l-140.2), [L-138.12](LEKTOR-138.md#l-138.12), [L-139.1](LEKTOR-139.md#l-139.1) | **unverändert** | `Intern/TESTPLAN.md:58-60`; `Intern/TESTPLAN.md:423` *„Erledigt am 03.11.2026: das Label bleibt …“* bei offenem [E-170](../Intern/BEFUNDE.md#e-170) (Label beim Verschieben im IMAP-Konto) |

## Funde

### <a id="l-144.1"></a>L-144.1 — Pfad in Anführungszeichen hinter `cd`: der Haken misst still im Hauptordner

**Gewicht: mittel, kein Merge-Halt.** Im schlimmsten Fall misst der Haken wie vor `f4bdb2b2` im Hauptordner. Das ist kein Rückschritt, aber eine Lücke, die nirgends steht.

- **Ursache (belegt):** `nur_befehle` löscht jede Zeichenkette in Anführungszeichen (`tools/haken-pr-lektor.pl:116` `$t =~ s/"(?:\\.|[^"\\])*"//g;`). Danach sucht `eingereichter_zweig` in demselben Text (`:126` `cd[ \t]+([^\s;&|]+)[ \t]*(?:&&|;)`). Aus `cd "C:/…/.wt/e188" && gh pr create` wird dadurch `cd  && gh pr create`, das Muster greift nicht, und es gilt `cwd`.
- **Folge (gemessen, Tabelle oben):** Gemeldet wird *„gemessen im Arbeitsbaum von 'main'“*, obwohl `gh` den Zweig aus `.wt/e188` einreichen würde. Heute weist der Haken trotzdem ab, weil auch `main` fällig ist. Ist `main` aktuell und der eingereichte Zweig fällig, lässt er durch (Vermutung, folgt aus dem Code). Bei `Set-Location` geschieht dasselbe. Ein relativer Pfad wird gegen den Ordner des Perl-Prozesses aufgelöst, nicht gegen `cwd` aus der Hook-Eingabe. In der Probe hielt der Haken deshalb auf. Ob Claude Code den Haken immer im Sitzungsordner startet, ist nicht gemessen (Vermutung).
- **Was die Doku sagt:** `tools/haken-pr-lektor.pl:29-30` *„sonst aus "cd <ordner> &&" vor dem Befehl“* und `tools/WERKZEUGE.md:189` *„(aus `--head`/`-H`, sonst aus `cd <ordner> &&` vor dem Befehl …)“*. Keine der beiden Stellen nennt die Einschränkung. Der Selbsttest hat keinen Fall mit Anführungszeichen (`:187-195`).
- Die Meldung nennt immer den gemessenen Baum (`:88`). Wer sie liest, sieht den Fehler also. Bei Rückgabe 0 gibt es aber keine Meldung.

**Vorschlag:** `eingereichter_zweig` vor dem Löschen der Zeichenketten auf den Rohbefehl anwenden, `cd "…"` und `Set-Location` mitlesen und einen relativen Pfad gegen `cwd` auflösen. Dazu je einen Selbsttest-Fall. Bis dahin in WERKZEUGE schreiben: *„verlässlich nur mit `--head <zweig>`“*. Das passt zur Lehre [hauptsitzung-bleibt-im-projektordner](../Arbeitsweise/hauptsitzung-bleibt-im-projektordner.md) (kein `cd` in `.wt/<name>`), nach der ohnehin `--head` die übliche Form ist.

### <a id="l-144.2"></a>L-144.2 — „Gemessen wird im Arbeitsbaum des Zweigs“, die Sperre für einen laufenden LEKTOR liest aber weiter den Hauptordner

**Gewicht: Kleinkram, nur Doku.**

- `tools/haken-pr-lektor.pl:23` *„Gemessen wird im Arbeitsbaum des Zweigs, der eingereicht wird - nicht im Hauptordner.“* Das gilt für `rollen-faellig.pl` (`:71` `cd "$baum" && perl tools/rollen-faellig.pl`). Die Sperre „LEKTOR läuft noch“ liest dagegen `$wurzel` (`:82` `lies_datei("$wurzel/tools/AGENTEN-LAUFEN.md")`). Im Betrieb ist `$wurzel` der Hauptordner, denn `.claude/settings.json:21` startet `"$CLAUDE_PROJECT_DIR/tools/haken-pr-lektor.pl"` (belegt).
- Das ist richtig so: `auftrag-rolle.pl` trägt die Läufe im Hauptordner ein, und die Zeilen in `AGENTEN-LAUFEN.md` nennen keinen Zweig (`| LEKTOR | 2026-11-04 09:11 | LEKTOR-144.md: … |`, gemessen). Die Folge steht aber nirgends: Solange irgendein LEKTOR eingetragen ist, sperrt der Haken **jeden** PR, auch den eines fremden Zweigs.

**Vorschlag:** ein Satz im Kopfkommentar unter *WELCHER BAUM* und in `tools/WERKZEUGE.md:189`: *„Die Sperre für einen eingetragenen LEKTOR (`AGENTEN-LAUFEN.md`) gilt weiter für alle Zweige.“*

### <a id="l-144.3"></a>L-144.3 — Kleinkram um den Haken

- `Arbeitsweise/stand-04-11-2026.md:21` (entstanden in `f4bdb2b2`, also im selben Commit wie die Berichtigung): *„weil `tools/haken-pr-lektor.pl` den LEKTOR im Hauptordner (main) misst … (Konstruktionsfehler, Berichtigung offen, eigener Zweig nötig)“* und *„PR (Gregor legt an, solange der Haken nicht berichtigt ist)“*. Das ist die einzige Stelle im Bestand, die den Messort im Hauptordner als heutigen Stand nennt (`grep` über alle MDs außer `Befunde/`, gemessen). Richtig wäre: *„berichtigt auf `pr_haken_zweig_messen`, wirksam nach dem Merge“*.
- `tools/WERKZEUGE.md:189` führt in einer Zelle nacheinander *„`--selbsttest`, **10 Fälle**“*, *„Selbsttest **13 Fälle**“* und *„Selbsttest **20 Fälle**“*. Als Verlauf stimmt das. Wer aber nur die erste Zahl liest, bekommt die älteste. Vorschlag: die beiden älteren Zahlen als *„damals“* kennzeichnen.
- `tools/WERKZEUGE.md:3`: Im Stand-Kopf fehlt der 04.11.2026 mit `haken-pr-lektor` (die Liste reicht bis *„lernten neun Werkzeuge die Reihe 7.2.2.N“*).
- `Arbeitsweise/daueraufgaben-brauchen-einen-takt.md:11` *„Schranke: tools/rollen-faellig.pl UND tools/pruefe-doku-takt.pl“*. Den Haken, der in seiner Meldung genau diese Lehre zitiert (`tools/haken-pr-lektor.pl:89`), nennt die Zeile nicht (belegt; vor `f4bdb2b2` war es genauso).
- **Merkposten zum PR dieses Zweigs (gemessen):** Der Haken wirkt aus dem Hauptordner (`.claude/settings.json:21`). Den PR für `pr_haken_zweig_messen` prüft also noch die alte Fassung, und die misst `main`. Die Probe im Hauptordner ergab *„LEKTOR faellig, aber beauftragt (9 Datei(en): CHANGELOG.md, Doku/MITARBEITEN.md, …“*. Auch nach `--fertig LEKTOR` bleibt `main` fällig, bis dieser Bericht dort liegt. Der Commit sagt das selbst (*„Wirksam erst nach dem Merge“*). Wie bei #218 wird Gregor den PR also selbst anlegen müssen.

### <a id="l-144.4"></a>L-144.4 — ZIEL sagt weiter „7.2.1.x bleibt die Reihe für Fehlerbehebungen“

**Gewicht: Kleinkram mit Außenwirkung (ZIEL ist öffentlich), Rest aus [L-143.4](LEKTOR-143.md#l-143.4).**

- `ZIEL.md:115-116` *„**7.2.1.x bleibt die Reihe für Fehlerbehebungen.** Neue Funktionen gehören nicht dazu“*. Das widerspricht Entscheidung 26 (`Intern/WEITERMACHEN.md:169`, *„seit 7.2.2.132 heißt jede Fassung 7.2.2.N, auch eine, die nur Fehler behebt“*) und `ZIEL.md:40-43` im selben Dokument (*„seit 7.2.2.132 mit der Marke `v7.2.2.<n>`, auch wenn er nur Fehler behebt“*). Der Absatz `:113-123` gibt die Entscheidung vom 02.11.2026 wieder, ohne die vom 04.11.2026 nachzutragen (belegt).

**Vorschlag:** hinter `:116` einfügen: *„Seit 04.11.2026 (Entscheidung 26) gilt das nur bis 7.2.1.131; danach trägt jede Fassung 7.2.2.N.“*

## Was nur Gregor entscheiden kann

Aus diesem Lauf keine neue Frage. Ob der Haken bei `cd "…"` nachgeschärft wird oder nur WERKZEUGE die Einschränkung nennt ([L-144.1](#l-144.1)), ist eine Frage der Werkzeuge und liegt beim Hauptagenten. Offen bleibt die Frage aus [LEKTOR-142](LEKTOR-142.md#l-142.7): Soll der Release-Text von v7.2.2.132 einen Satz bekommen, dass für vier Befunde noch jede Prüfung fehlt?
