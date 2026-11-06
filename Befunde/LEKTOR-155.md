# <a id="lektor-155"></a>LEKTOR-155 (06.11.2026) — Zweig `paket_7_2_2_136` nach 9c6794cc: Schlussrunde über die Einarbeitung von LEKTOR-154 und den neuen Prüfbericht

**Umfang:** nur der Commit `9c6794cc` (`git show --stat`: `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `tools/WERKZEUGE.md`, `Releases/PRUEFBERICHT.md`, `Releases/pruefbericht-tests.tsv`). Der Zweig `wt/lektor-20261106c` steht auf `9c6794cc`, gleich `origin/paket_7_2_2_136` (gemessen). Kein Bestandslauf (Auftrag). Gebaut und gestartet habe ich nichts.

**Urteil:** Die Einarbeitung trifft die Stellen, die den PR betrafen. [E-239](../Intern/BEFUNDE.md#e-239) (Absturz beim Beenden bei offenem Hinweis, kritisch) verlangt nicht mehr „das nächste Paket und Gregors Test“, der CHANGELOG nennt es nicht mehr „Originalfehler“, und der Prüfbericht ist neu: BESTANDEN. **Nichts hält den PR `paket_7_2_2_136` → `main` auf.** `git diff --stat adf559dc 9c6794cc -- Eudora71` ist leer (gemessen), das Programm bleibt das getestete. Vier Funde, alle gering, für die nächste Runde.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„gepruefte Dateien 57“*, *„Kein Widerspruch gefunden.“*, 23 Hinweise „nennt weder … 7.2.2.136“ (Altbestand, wie in [LEKTOR-154](LEKTOR-154.md#lektor-154)).
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 59“*, *„aktuell gemessen 13“*, *„59 offene Befunde, in beiden Listen gleich.“* `git status` danach leer.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“*; weiter *„E-5->[E-6](../Intern/BEFUNDE.md#e-6)/[E-8](../Intern/BEFUNDE.md#e-8) E-6->[E-8](../Intern/BEFUNDE.md#e-8)“* ([L-153.7](LEKTOR-153.md#l-153.7)).
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen“*.

## Funde aus LEKTOR-154 — heutiger Stand

| Fund | Stand | Stelle (heute) |
|---|---|---|
| [L-154.1](LEKTOR-154.md#l-154.1) [E-239](../Intern/BEFUNDE.md#e-239) aus drei Ständen | **teilweise** | erledigt: `Intern/BEFUNDE.md:406` *„**Was noch fehlt:** die Windows-Abmeldung (`WM_QUERYENDSESSION`) ist nicht gemessen …; sonst nichts — Paket und Gregors Test sind erledigt (7.2.2.136, 06.11.2026), PRÜFER-102 K3 (`E-239p` am Paketbau) lief am 06.11.2026 grün.“* und *„**Datenverlust (Stand 05.11.2026, vor der Messung unten: nicht beobachtet, nicht ausgeschlossen):**“* (gemessen). Offen siehe [L-155.1](#l-155.1) |
| [L-154.2](LEKTOR-154.md#l-154.2) Marken „Zuletzt gemessen“ mit altem Bau | **offen** (laut Commit-Nachricht bewusst nicht eingearbeitet) | `:406` *„**Zuletzt gemessen: 06.11.2026 an 7.2.2.136** (Bau aus dem Zweig `e239_absturz_beenden`, Fassungsnummer noch 7.2.2.135)“* (gemessen) |
| [L-154.3](LEKTOR-154.md#l-154.3) E-239w in WERKZEUGE und Buch | **erledigt** (Text), Buchzeile ohne Wirkung | `tools/WERKZEUGE.md:165` *„Fall `E-239p` über `tools/messen-e239-exit-close.ps1` … der frühere Fall `E-239w` entfällt (06.11.2026)“*. `Intern/pruefstand-buch.tsv:109` führt weiter `E-239w ok … E239 PROBE ok`, der neue Prüfbericht zählt die Zeile nicht (`grep -c E-239w Releases/PRUEFBERICHT.md` → 0, gemessen); die Vermutung aus [L-154.3](LEKTOR-154.md#l-154.3) ist damit beantwortet |
| [L-154.4](LEKTOR-154.md#l-154.4) CHANGELOG, [E-242](../Intern/BEFUNDE.md#e-242), Prüfbericht | **teilweise** | erledigt: `CHANGELOG.md:128` *„… ob der Fehler schon im Original steckt, ist nicht gemessen)“*; `Releases/PRUEFBERICHT.md:9` *„**Gesamturteil** \| **BESTANDEN**“* (gemessen). Offen: `grep -c E-242 README.md` → 0 (gemessen) |
| [L-154.5](LEKTOR-154.md#l-154.5) Kleinkram, [E-236](../Intern/BEFUNDE.md#e-236) | **teilweise** | erledigt: E-236-Zeilen in `CHANGELOG.md:34` und `Intern/WEITERMACHEN.md:106` *„die Richtung ist entschieden (Entscheidung 38 …)“*. Offen: [L-155.2](#l-155.2); `Doku/FAQ.md:513` *„Der Druck auf Papier ist noch nicht gemessen. Seit 7.2.2.136.“*; `Intern/WEITERMACHEN.md:13` *„[E-241](BEFUNDE.md#e-241),“* ohne Halbsatz; `tools/testplan-voraussetzungen.pl:33` mit dem Pfad der VM-Freigabe; „Eingearbeitet“-Zeilen zu [LEKTOR-152](LEKTOR-152.md#lektor-152) bis [LEKTOR-154](LEKTOR-154.md#lektor-154) fehlen in `Intern/LEKTORAT.md` (alles gemessen) |

## Funde

### <a id="l-155.1"></a>L-155.1 — E-239: „K3 steht aus“ am Ende derselben Zelle

**Gewicht: gering.** Die neue Zeile „Was noch fehlt“ sagt *„K3 (`E-239p` am Paketbau) lief am 06.11.2026 grün“*, weiter hinten in derselben Zelle `Intern/BEFUNDE.md:406` steht unverändert *„[K3](../Befunde/PRUEFER-102.md#k3) — steht aus: neu bauen nach dem Commit und `E-239p` am Bau mit Commit-Kennung messen.“* (gemessen). Auch der Satz *„`E-239p` und die neue Positivprobe `E-239w` (`E239 PROBE ok`) beide rot“* hat den Halbsatz „seit 06.11.2026 im Urteil von `E-239p`“ nicht bekommen. **Vorschlag:** „steht aus …“ ersetzen durch *„erledigt 06.11.2026 12:50:03 am Paketbau `7.2.2.136+2a8fd4d7` (Teillauf)“*.

### <a id="l-155.2"></a>L-155.2 — E-236: „Vorschlag, nicht umgesetzt“ neben der Entscheidung

**Gewicht: gering.** `Intern/BEFUNDE.md:407` (Fenster „Update Eudora“ zeigt eine fremde Seite): Kopf *„offen, Richtung entschieden (Gregor 06.11.2026, Entscheidung 38 …)“*, im Rumpf weiter *„**Vorschlag, nicht umgesetzt:** den Update-Hinweis abschalten oder auf die GitHub-Release-Seite zeigen lassen“* (gemessen). Nach Entscheidung 38 ist „abschalten“ verworfen. **Vorschlag:** den Satz auf *„umzusetzen: auf die GitHub-Release-Seite zeigen“* kürzen.

### <a id="l-155.3"></a>L-155.3 — Prüfbericht: 109 Fälle, der Kopf nennt 110 und einen unsauberen Baum

**Gewicht: gering.** `Releases/PRUEFBERICHT.md:6` *„`adf559dc` — **Arbeitsbaum nicht sauber** (4 Dateien)“*, `:16` *„Pruefstand, 110 Faelle, 67 Eudora-Starts“*, `:23` *„Pruefstand (Oberflaeche) \| 109 \| 109 \| 0“*; `README.md:104` *„110/110 am Bau `2a8fd4d7`“* (gemessen). 110 minus den entfallenen Fall `E-239w` ergibt 109 (belegt). Die vier Dateien sind vermutlich die vier Textdateien desselben Commits (Vermutung; unter `Eudora71/` hat `9c6794cc` nichts geändert, gemessen). Sachlich stimmt der Bericht, wer ihn liest, sieht aber drei Zahlen ohne Erklärung. **Vorschlag:** beim nächsten Erzeugen auf sauberem Baum; in README:104 den Wegfall von `E-239w` in einem Halbsatz nennen.

### <a id="l-155.4"></a>L-155.4 — Bewusst nicht Eingearbeitetes aus LEKTOR-154

**Gewicht: gering.** [L-154.2](LEKTOR-154.md#l-154.2) (Klammern der Marken „Zuletzt gemessen“ nennen den alten Bau), [E-242](../Intern/BEFUNDE.md#e-242) (Windows-Anmeldename im Fuß jedes Ausdrucks) in der README, FAQ:513, WEITERMACHEN:13, `testplan-voraussetzungen.pl:33` und die fehlenden „Eingearbeitet“-Zeilen in LEKTORAT stehen wie in der Tabelle oben. Keiner davon war als PR-Bedingung genannt. **Vorschlag:** nach dem Merge in einem Zug.

## Hält etwas den PR `paket_7_2_2_136` → `main` auf?

**Nein.** Die zwei Punkte, die [LEKTOR-154](LEKTOR-154.md#lektor-154) im PR haben wollte ([E-239](../Intern/BEFUNDE.md#e-239) „Was noch fehlt“, `CHANGELOG.md:128`), sind erledigt (gemessen, Tabelle). Der Code ist seit `adf559dc` unverändert, der Prüfbericht sagt BESTANDEN (Unit-Tests 428/0 rot, Schranken 19/0, Prüfstand 109/0). [L-155.1](#l-155.1) bis [L-155.4](#l-155.4) sind Text und können folgen.

## Was nur Gregor entscheiden kann

Nichts Neues.
