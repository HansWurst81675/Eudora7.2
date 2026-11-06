# <a id="lektor-136"></a>LEKTOR-136 — Bestand nach Gregors Ergebnis-ZIP zu 7.2.1.131, Zweig ergebnisse_1_131b nach d8375756; dazu e203_e204_persona_kennwort und e133_mailverzeichnis_fehlt vor dem PR (03.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-135](https://github.com/HansWurst81675/Eudora7.2/blob/e203_e204_persona_kennwort/Befunde/LEKTOR-135.md) — liegt nur auf `origin/e203_e204_persona_kennwort`, nicht auf `main` und nicht auf diesem Zweig (`git log --all -- Befunde/LEKTOR-135.md` → `9bcbac49`, `2de291c9`; gemessen).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261103`, abgezweigt von `origin/ergebnisse_1_131b`, Stand `d8375756`. Eigen gegen `origin/main` sind zwei Commits (gemessen, `git log --stat origin/main..HEAD`): `d91e5726` (*„[E-170](../Intern/BEFUNDE.md#e-170): Gregors Messung an 7.2.1.131 eingetragen; Testplan-Ueberschrift gekuerzt“* — `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/TESTPLAN.md`, `Intern/WEITERMACHEN.md`) und `d8375756` (`tools/ZWEIGE.md`). Die beiden anderen Zweige nur mit `git show`/`git diff`/`git merge-tree` gelesen, nicht ausgecheckt. Nichts gebaut, nichts gestartet, keine Prüfstände angefasst.

## Kurz

Der Eintrag zu Gregors Messung stimmt mit dem, was er geliefert hat: [E-170](../Intern/BEFUNDE.md#e-170) (Label geht beim Verschieben im IMAP-Konto verloren) zitiert seine Logzeile `mit-label=1 alte-uids=1 neue-uids=1 gesetzt=0 grund=ok`, nennt die alte Vermutung widerlegt und lässt den Befund zu Recht offen, weil der Verlust vom 29.10. an Paket 1.0.127 ungeklärt ist. **Nicht nachgezogen** ist dieselbe widerlegte Annahme an anderer Stelle: [E-189](../Intern/BEFUNDE.md#e-189) (ohne UIDPLUS steht die verschobene Mail unter der alten Nummer) nennt Gregors Server weiter „vermutlich ohne UIDPLUS“ und will die Behebung genau dort bestätigen — das geht nach seiner Messung nicht. Die neue Spur in [E-170](../Intern/BEFUNDE.md#e-170) nennt eine Klasse, die es im Quelltext nicht gibt. README und FAQ versprechen weiter, mit UIDPLUS bleibe das Label — genau an einem solchen Server ging es am 29.10. verloren. Die Funde aus [LEKTOR-135](LEKTOR-135.md#lektor-135) sind auf `e203_…` bis auf die Prüfstandssperre in WERKZEUGE erledigt; auf `e133_…` ist die Gegentest-Zeile aus [L-135.11](LEKTOR-135.md#l-135.11) inzwischen angekommen. Beide Zweige mergen einzeln sauber in `main`, miteinander aber mit neun Konflikten, darunter die Sperre selbst in zwei Fassungen. Neun Funde, keiner am Programmcode.

## Funde aus LEKTOR-135 — heutiger Stand

Gemessen am Zweig, für den sie galten (`origin/e203_e204_persona_kennwort`, Spitze `b4035e86` *„[LEKTOR-135](LEKTOR-135.md#lektor-135) eingearbeitet: FAQ zu [E-204](../Intern/BEFUNDE.md#e-204), [E-39](../Intern/BEFUNDE.md#e-39) ohne Pruefstandsfall, neu [E-212](../Intern/BEFUNDE.md#e-212)“*); auf diesem Zweig (`ergebnisse_1_131b`) gilt davon nichts, weil `e203_…` nicht gemergt ist.

| Fund | Stand | Stelle (gemessen, Zweig `e203_…`) |
|---|---|---|
| [L-135.1](LEKTOR-135.md#l-135.1) FAQ nennt Löschen einer Persönlichkeit „unbedenklich“ ([E-204](../Intern/BEFUNDE.md#e-204): Kennwort geht an das neue Konto) | **erledigt** | `Doku/FAQ.md:153-159` *„wer eine Persönlichkeit löscht und in derselben Sitzung eine neue **mit demselben Namen** anlegt, sollte dazwischen Eudora einmal beenden“*; „unbedenklich“ nur noch *„Für die `Eudora.ini`“* |
| [L-135.2](LEKTOR-135.md#l-135.2) [E-39](../Intern/BEFUNDE.md#e-39) (INI-Rest nach Löschen) „Prüfstand sieht den Weg vollständig“ | **erledigt** | `BEFUNDE.md:461` *„am Programm sieht den Weg seit der Behebung von [[E-203](../Intern/BEFUNDE.md#e-203)] kein Prüfstandsfall mehr — gesichert ist die Behebung durch `TestE39.cpp`“* |
| [L-135.3](LEKTOR-135.md#l-135.3) „durchgesehen ist nur *Change Password*“ | **erledigt** | `git grep 'durchgesehen ist nur'` → nur noch in `Befunde/LEKTOR-135.md` und `Intern/LEKTORAT.md` |
| [L-135.4](LEKTOR-135.md#l-135.4) WERKZEUGE kennt die Prüfstandssperre nicht | **teilweise** | `tools/WERKZEUGE.md:68` `strg-n-pruefen.ps1` jetzt *„Stillgelegt am 02.11.2026“* — erledigt; `grep -c sperre tools/WERKZEUGE.md` → 1 (nur diese Zeile): `pruefstand-sperre.ps1` hat keine eigene Zeile, `testlauf.ps1` (`:126`) nennt die Sperre nicht; `tools/pruefstand-sperre.ps1:6` *„Selbsttest ohne Eudora-Start: tools\pruefstand-sperre-test.ps1“* — die Datei fehlt im Zweig weiter ([L-136.6](#l-136.6)) |
| [L-135.5](LEKTOR-135.md#l-135.5) WEITERMACHEN nennt `messungen_vor_7_2_2_132` laufend | **erledigt** auf `e203_…` (`WEITERMACHEN.md:3` nennt `#210`; `CHANGELOG.md:131` *„(gemergt als #209)“*, `:147` *„(gemergt als #210)“*); **offen** auf diesem Zweig und auf `e133_…` ([L-136.5](#l-136.5)) | |
| [L-135.6](LEKTOR-135.md#l-135.6) Zeilenangaben [E-203](../Intern/BEFUNDE.md#e-203)/[E-210](../Intern/BEFUNDE.md#e-210)/[E-39](../Intern/BEFUNDE.md#e-39) | **erledigt** | `BEFUNDE.md:407` *„`password.cpp:461-466`“*, `:402` *„`password.cpp:469-480`“*; `EudoraRes.rc:9160` an allen drei Stellen (`:402`, `:407`, `:461`); Köpfe nennen *„zuletzt `7.2.1.131+2b3a529d*`“* |
| [L-135.7](LEKTOR-135.md#l-135.7) Debug-`.eif` nur als Vermerk | **erledigt** | neu [`E-212`](../Intern/BEFUNDE.md#e-212) (nur auf den Zweigen `e133_mailverzeichnis_fehlt` bzw. `e203_e204_persona_kennwort`) (`BEFUNDE.md:400` *„Prüfstände tragen noch Debug-Fassungen der Import-Erweiterungen“*) — die Kennung hat der Hauptagent vergeben |
| [L-135.8](LEKTOR-135.md#l-135.8) Stufe von [E-210](../Intern/BEFUNDE.md#e-210) (zu langes POP-Konto läuft über den Stapel) | **erledigt** | `BEFUNDE.md:402` *„**Stufe: kritisch** (nach der Legende: ein Stapelüberlauf kann das Programm abstürzen lassen; ab Werk kaum erreichbar …“* |
| [L-135.9](LEKTOR-135.md#l-135.9) ZWEIGE nennt nur [E-203](../Intern/BEFUNDE.md#e-203)/[E-204](../Intern/BEFUNDE.md#e-204) | **teilweise** | `tools/ZWEIGE.md:221` nennt jetzt [E-210](../Intern/BEFUNDE.md#e-210), [E-211](../Intern/BEFUNDE.md#e-211), `startzeilen` — die übernommene Prüfstandssperre (`21029ad6`) fehlt weiter |
| [L-135.10](LEKTOR-135.md#l-135.10) doppelte Startzeilen | **auf `e203_…` auf Stand `main`** (34, wie `origin/main`); **auf `e133_…` gewachsen** auf 65 ([L-136.7](#l-136.7)) | `git show <zweig>:tools/TESTLAEUFE.md \| grep '^\| 20' \| sort \| uniq -d \| wc -l` |
| [L-135.11](LEKTOR-135.md#l-135.11) Gegentest-Zeile `E204-GEGENTEST` im Startprotokoll | **erledigt** auf `e203_…` (0 Treffer); **auf `e133_…` angekommen** ([L-136.7](#l-136.7)) | `e133_…:tools/TESTLAEUFE.md:948` |
| [L-134.10](LEKTOR-134.md#l-134.10) bis [L-134.12](LEKTOR-134.md#l-134.12), [L-129.1](LEKTOR-129.md#l-129.1), [L-128.2](LEKTOR-128.md#l-128.2), [L-128.3](LEKTOR-128.md#l-128.3) | **unverändert offen** | `grep -c 'zuletzt ver' tools/pruefe-release-buchfuehrung.pl` → 0 ([L-129.1](LEKTOR-129.md#l-129.1): Schranke „zuletzt veröffentlicht“ fehlt); `grep -c -E 'Misc\|0x8000' Doku/FAQ.md` → 0 ([L-134.12](LEKTOR-134.md#l-134.12): FAQ-Logzeile ohne ihre Bedingung) |
| [L-130.1](LEKTOR-130.md#l-130.1) persönliche Angabe in alten Zweigen | **teilweise** | `git branch -r --contains d9ae24c8` → nur noch `origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d` (`origin/hilfe_menue` ist weg) |

## Der Eintrag zu Gregors Messung gegen Bestand und Quelle

| Aussage | Stelle | Gegen |
|---|---|---|
| Logzeile `mit-label=1 alte-uids=1 neue-uids=1 gesetzt=0 grund=ok` an `7.2.1.131+a2f29b69*` | `BEFUNDE.md:422`, `TESTPLAN.md:352` | belegt durch den Commit `d91e5726`; das ZIP selbst habe ich nicht gesehen (Gregors Verzeichnis, nicht abgesprochen). Die Deutung „gesetzt hat der alte Weg“ passt zur Prüfstandsmessung mit UIDPLUS im selben Eintrag (*„neu mit UIDPLUS `kopie-mit-label=1 log-grund=ok` (Logzeile `… gesetzt=0`)“*) — trifft |
| alte Vermutung widerlegt, Befund bleibt offen | `BEFUNDE.md:422` *„warum es am 29.10.2026 an Paket 1.0.127 verloren ging, ist nicht geklärt“* | trifft; die alte Fassung ist unter *„Bis 03.11.2026 stand hier“* erhalten |
| neue Spur `CImapTransferMsgAction::DoWork` | `BEFUNDE.md:422` | trifft nicht ([L-136.2](#l-136.2)) |
| TESTPLAN: Schritt 3 und 4 bestanden, nichts zu wiederholen | `TESTPLAN.md:352` | stimmt mit [E-170](../Intern/BEFUNDE.md#e-170) überein; Kopf und Abschnittstitel nicht nachgezogen ([L-136.4](#l-136.4)) |
| „Testplan-Überschrift gekürzt“ | `TESTPLAN.md:1-3` | trifft: aus *„# Testplan für Gregor — Quellstand …“* wurden Überschrift und eine Zeile *„**Stand:** Quellstand 7.2.1.131 …“* (`git diff origin/main HEAD -- Intern/TESTPLAN.md`, `@@ -1 +1,3 @@`) |
| erzeugte Listen | `CHANGELOG.md:49`, `WEITERMACHEN.md:98` | *„messen, warum das Label am 29.10.2026 an Paket 1.0.127 fehlte …“* — aus BEFUNDE erzeugt, gleich; `offene-befunde.pl` *„55 offene Befunde, in beiden Listen gleich.“* |
| ZWEIGE-Zeile | `tools/ZWEIGE.md:217` *„**Von Gregor bestätigt** (*„ja, branch name ok“*)“* | trifft den Inhalt der zwei Commits |
| persönliche Angaben | die zwei Commits | kein neuer Pfad aus Gregors Verzeichnissen; die Pfade in `TESTPLAN.md:3` standen schon vorher in der Überschrift und sind nur umgebrochen (gelesen) |

## Funde

### <a id="l-136.1"></a>L-136.1 — E-189 rechnet weiter mit einem Gregor-Server ohne UIDPLUS und will die Behebung dort bestätigen — nach seiner Messung meldet sein Server die Nummern

**Gewicht: mittel.** Die einzige noch offene Bestätigung von [E-189](../Intern/BEFUNDE.md#e-189) (ohne UIDPLUS steht die verschobene Mail im Ziel unter der alten Nummer neben einer fremden) ist auf einen Weg gestellt, den es nicht gibt; der Befund bliebe so dauerhaft offen. (gemessen an den Texten)

- `Intern/BEFUNDE.md:412` *„**Kurz: Ohne UIDPLUS (vermutlich Gregors Server) meldet der Server …“* und *„**Was noch fehlt:** die Löschvermutung messen; mit dem Testpaket 7.2.1.131 an Gregors Server (ohne UIDPLUS) bestätigen.“* — erzeugt übernommen in `CHANGELOG.md:42` und `Intern/WEITERMACHEN.md:91`.
- Dagegen derselbe Zweig, `BEFUNDE.md:422` ([E-170](../Intern/BEFUNDE.md#e-170)): *„Sein Server meldet die neuen Nummern (UIDPLUS) — die Vermutung, er tue es nicht, ist damit widerlegt.“* Schon `CHANGELOG.md:1677` ([E-121](../Intern/BEFUNDE.md#e-121), 15.10.) *„GMX meldet die UID“*.
- `d91e5726` hat [E-189](../Intern/BEFUNDE.md#e-189) nicht angefasst (`git diff origin/main HEAD -- Intern/BEFUNDE.md` → eine geänderte Zeile, `:422`).

**Vorschlag:** in [E-189](../Intern/BEFUNDE.md#e-189) „(vermutlich Gregors Server)“ streichen und *„Was noch fehlt“* auf einen Weg stellen, der den Fall trifft: am Prüfstand ([`E-189`](../Intern/BEFUNDE.md#e-189), Prüfserver ohne `COPYUID`) ist er schon grün; für ein echtes System bliebe nur ein Server ohne UIDPLUS oder `ImapIgnoreUIDPLUS` (`Doku/FUNKTIONEN.md:1075` *„nur gelesen: Fähigkeiten des Servers übergehen“*). Danach `offene-befunde.pl -schreiben`.

### <a id="l-136.2"></a>L-136.2 — Die neue Spur in E-170 nennt eine Klasse, die es nicht gibt

**Gewicht: Kleinkram mit Wirkung auf die nächste Messung.** (gemessen am Quelltext)

- `BEFUNDE.md:422` *„nächste Spur (Vermutung): die alte Zusammenfassung stand nach dem automatischen Löschen (`DeleteMessagesFromServer(..., m_bAutoExpunge)` in `CImapTransferMsgAction::DoWork`, `EuImap/src/ImapActionQueue.cpp`) nicht mehr im Quellordner“*.
- `grep -n '::DoWork' Eudora71/EuImap/src/ImapActionQueue.cpp`: es gibt `CImapSameServerTransferMsgAction::DoWork` (`:1912`), `CImapCrossServerTransferMsgAction::DoWork` (`:2086`), `CImapToLocalTransferMsgAction::DoWork` (`:2323`), keine `CImapTransferMsgAction`. Der Aufruf steht für den Fall *innerhalb eines Kontos* in `:1957` *„m_pImapMailbox->DeleteMessagesFromServer(m_szMessageIDs, m_bAutoExpunge, TRUE/\*bSilent\*/);“*, gleich lautend auch `:2144` und `:2377`.

**Vorschlag:** *„in `CImapSameServerTransferMsgAction::DoWork` (`ImapActionQueue.cpp:1957`)“*. Dass es die Stelle ist, bleibt Vermutung, so wie im Text gekennzeichnet.

### <a id="l-136.3"></a>L-136.3 — README und FAQ versprechen, mit UIDPLUS bleibe das Label — an Gregors Server mit UIDPLUS ging es am 29.10. verloren

**Gewicht: mittel.** Ein Anwender mit einem gewöhnlichen Server (GMX meldet die Nummern) liest „bleibt“ und rechnet nicht mit dem Verlust, den Gregor selbst erlebt hat. (gemessen an den Texten)

- `README.md:166` *„mitgenommen wird es nur, wenn der Server die neuen Nummern meldet (UIDPLUS) — das tat schon 7.2.1.128.“*; `Doku/FAQ.md:208-212` *„Meldet er sie, bleibt das Label; das war schon vor 7.2.1.130 so“*. Beide unverändert gegen `origin/main`.
- `BEFUNDE.md:422`: der Verlust am 29.10.2026 an Paket 1.0.127 ist ungeklärt, und Gregors Server meldet UIDPLUS. Also gibt es mindestens einen Weg mit UIDPLUS, auf dem das Label verloren ging (belegt aus zwei Einträgen, Ursache Vermutung).
- `Releases/7.2.1.131/RELEASE-NOTIZEN.md:41-45` *„bleibt das Label erhalten, wenn der Server die neuen Nummern meldet“* — ebenso; der Text auf GitHub nur mit Gregors Ja.

**Vorschlag:** README und FAQ: *„… meistens auch mit UIDPLUS — an einem solchen Server ging es einmal verloren (29.10.2026, Ursache offen, [[E-170](../Intern/BEFUNDE.md#e-170)])“*.

### <a id="l-136.4"></a>L-136.4 — TESTPLAN: Kopf und Abschnittstitel zu E-170 stehen auf dem Stand vor der Auswertung

**Gewicht: Kleinkram.** (gemessen)

- `Intern/TESTPLAN.md:3` *„… Stand 02.11.2026 (zuletzt getestet am 02.11.2026 7.2.1.131 …“* — die Auswertung vom 03.11. fehlt im Kopf.
- `:350` *„## In 7.2.1.130: das Label bleibt beim Verschieben im IMAP-Konto ([[E-170](../Intern/BEFUNDE.md#e-170)])“* und `:356` *„**Mit dem Paket 7.2.1.130 auszuführen, nicht mit 7.2.1.129.**“* — gemessen hat Gregor an 7.2.1.131; die Schritte 1-4 darunter lesen sich weiter als Auftrag, obwohl `:352` sagt *„Gregor muss den Abschnitt nicht wiederholen.“*

**Vorschlag:** Kopf *„Stand 03.11.2026 ([E-170](../Intern/BEFUNDE.md#e-170) aus Gregors Ergebnis-ZIP ausgewertet)“*; Titel *„Erledigt 03.11.2026: das Label bleibt …“*, damit der Abschnitt nicht als offener Test gelesen wird.

### <a id="l-136.5"></a>L-136.5 — WEITERMACHEN nennt auf diesem Zweig und auf `e133_…` weiter `messungen_vor_7_2_2_132` laufend

**Gewicht: Kleinkram, dieselbe Klasse zum zwölften Mal** ([L-128.2](LEKTOR-128.md#l-128.2): eine Schranke gegen „läuft“ nach dem Merge fehlt). (gemessen)

- `Intern/WEITERMACHEN.md:3` *„Laufend: Zweig `messungen_vor_7_2_2_132` ([[E-141](../Intern/BEFUNDE.md#e-141)] und [[E-179](../Intern/BEFUNDE.md#e-179)] am Prüfstand bestätigt, [[E-170](../Intern/BEFUNDE.md#e-170)] bleibt offen …“* — `#210` kommt in der Zeile nicht vor (`grep -c` → 0), `ergebnisse_1_131b` auch nicht; Kopf *„**Stand 02.11.2026 abends.**“*.
- `git show origin/e133_mailverzeichnis_fehlt:Intern/WEITERMACHEN.md`, Zeile 3: derselbe Satz, kein `#210`, und `e133_…` selbst nicht als laufend genannt.
- Auf `e203_…` erledigt (Tabelle oben) — wer als Zweiter merged, bekommt hier einen Konflikt ([L-136.8](#l-136.8)).

**Vorschlag:** Zeile 3 einmal nach dem letzten Merge schreiben: gemergt #209/#210, laufend die drei Zweige mit je einem Halbsatz.

### <a id="l-136.6"></a>L-136.6 — Die Prüfstandssperre liegt auf `e203_…` in einer älteren Fassung als auf `e133_…`, ohne WERKZEUGE-Zeile und ohne ihren Selbsttest

**Gewicht: mittel, vor dem zweiten Merge zu erledigen.** Wird `e203_…` zuerst gemergt, steht auf `main` eine Sperre ohne die Nachbesserungen aus [PRÜFER-87](PRUEFER-87.md) N2/N4/N5/N7; beim Merge von `e133_…` entscheidet dann eine Konfliktauflösung von Hand, welche gilt. (gemessen)

- `git log origin/main..origin/e203_e204_persona_kennwort`: `21029ad6` *„Pruefstandssperre uebernommen (unveraendert aus ff49d438)“*; auf `e133_…` danach `eb7e67cd` *„[PRUEFER-87](PRUEFER-87.md#pruefer-87) Nachtrag: N1 (Registrypuffer), N2/N4/N5/N7 (Sperre), N6 (Test)“*.
- `git diff --stat origin/e203_… origin/e133_… -- tools/pruefstand-sperre.ps1` → *„64 insertions(+), 21 deletions(-)“*; ebenso `tools/testlauf.ps1` (7/3) und `tools/pruefstand-lauf.ps1` (14/8). `git merge-tree` der beiden Zweige: *„CONFLICT (add/add): Merge conflict in tools/pruefstand-sperre.ps1“*.
- `tools/pruefstand-sperre-test.ps1` gibt es nur auf `e133_…` (`git ls-tree`); `e203_…:tools/pruefstand-sperre.ps1:6` verweist darauf. `e203_…:tools/WERKZEUGE.md` hat keine Zeile für `pruefstand-sperre.ps1`; `e133_…:tools/WERKZEUGE.md` hat drei Treffer.

**Vorschlag:** `e133_…` zuerst mergen; danach `e203_…` mit `main` angleichen und für die drei Skripte die Fassung von `main` nehmen. Umgekehrt: vor dem Merge von `e203_…` die drei Skripte und den Selbsttest aus `e133_…` übernehmen.

### <a id="l-136.7"></a>L-136.7 — Auf `e133_…` ist die Gegentest-Zeile angekommen, die doppelten Startzeilen sind auf 65 gewachsen, ZWEIGE ist unvollständig

**Gewicht: Kleinkram** (Fortschreibung von [L-135.10](LEKTOR-135.md#l-135.10), [L-135.11](LEKTOR-135.md#l-135.11), [L-135.9](LEKTOR-135.md#l-135.9)). (gemessen)

- `e133_…:tools/TESTLAEUFE.md:948` *„\| 2026-11-02 23:59:59 \| `C:\Temp\E204-GEGENTEST` \| zwischendurch angehaengt \| - \|“* — genau der Weg, den [L-135.11](LEKTOR-135.md#l-135.11) vorhergesagt hat (über `startzeilen-sammeln.pl` aus einem anderen Baum). Auf `e203_…` ist sie entfernt.
- Doppelte Datenzeilen (`sort | uniq -d`): `origin/main` 34, `e203_…` 34, `e133_…` 65, dieser Zweig 34.
- `e133_…:tools/ZWEIGE.md:220` nennt nur [E-133](../Intern/BEFUNDE.md#e-133); [`E-208`](../Intern/BEFUNDE.md#e-208) (nur auf den Zweigen `e133_mailverzeichnis_fehlt` bzw. `e203_e204_persona_kennwort`), [`E-209`](../Intern/BEFUNDE.md#e-209) (nur auf den Zweigen `e133_mailverzeichnis_fehlt` bzw. `e203_e204_persona_kennwort`) und die Sperre fehlen (`grep -o` → keine Treffer).

**Vorschlag:** die Zeile auf `e133_…` herausnehmen, die Dubletten nach dem zweiten Merge einmal auf `main` bereinigen; ZWEIGE-Zeile ergänzen.

### <a id="l-136.8"></a>L-136.8 — Die beiden Zweige mergen einzeln sauber, miteinander mit neun Konflikten

**Gewicht: Kleinkram, für die Reihenfolge der PRs.** (gemessen)

- `git merge-tree --write-tree --name-only origin/main origin/<zweig>`: für beide keine Konflikte; `git rev-list --count <zweig>..origin/main` → 0 für beide. Gegen diesen Zweig (`HEAD`) ebenfalls keine.
- `git merge-tree … origin/e203_… origin/e133_…` → *„CONFLICT“* in `CHANGELOG.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `Intern/pruefstand-ergebnis.txt`, `tools/TESTLAEUFE.md`, `tools/WERKZEUGE.md`, `tools/pruefstand-lauf.ps1`, `tools/pruefstand-sperre.ps1` (add/add), `tools/testlauf.ps1`.

**Vorschlag:** wer als Zweiter gemergt wird, gleicht vorher mit `main` an, erzeugt die Listen neu (`offene-befunde.pl -schreiben`) und fährt `startzeilen-sammeln.pl`; für die Skripte siehe [L-136.6](#l-136.6).

### <a id="l-136.9"></a>L-136.9 — Die Berichtszahl in der README stimmt auf diesem Zweig nach diesem Bericht nicht mehr

**Gewicht: Kleinkram** ([L-131.8](LEKTOR-131.md#l-131.8)). (gemessen)

- `README.md:98` *„(219 LEKTOR- und PRÜFER-Berichte …)“*; `ls Befunde/LEKTOR-*.md Befunde/PRUEFER-*.md | wc -l` → 219 vor diesem Bericht, mit ihm 220. [LEKTOR-135](LEKTOR-135.md#lektor-135) und PRÜFER-88 liegen auf `e203_…`; nach allen Merges ändert sich die Zahl erneut.

**Vorschlag:** die Zahl erst nach dem letzten Merge setzen, oder erzeugen lassen.

## Bestand außerhalb des Schwerpunkts

Seit `origin/main` geändert sind nur die fünf Dateien der zwei Commits; alle gelesen. Die übrigen MDs nach `UIDPLUS`, `Gregors Server`, `seinem Server` und [`E-170`](../Intern/BEFUNDE.md#e-170) durchsucht (`git grep` ohne `Befunde/`, `Arbeitsweise/`, `LEKTORAT.md`): außer [L-136.1](#l-136.1) und [L-136.3](#l-136.3) nur Geschichte (`CHANGELOG.md:1677-1681`, `Releases/PAKETE.md:688`, `:753`, `Intern/WEITERMACHEN-bis-7.2.0.md:36` — [E-121](../Intern/BEFUNDE.md#e-121) im Oktober, darf so stehen) und Werkzeugzeilen (`tools/WERKZEUGE.md:142`, `:156`), die den Prüfserver beschreiben und weiter stimmen. `Releases/PRUEFBERICHT.md:412` (*„[E-170](../Intern/BEFUNDE.md#e-170) (Quelltext): Label wird … gemerkt und im Ziel gesetzt — ok“*) ist ein Quelltexttest und bleibt richtig.

Zu `e133_…` in der Sache (gelesen, nicht gemessen): `README.md` *„**Ab 7.2.2.132** (im Quellstand, noch in keinem Paket) fragt Eudora stattdessen: *Yes* = anderen Ordner wählen, *No* = den Ordner neben dem Programm nehmen …“* stimmt mit [E-133](../Intern/BEFUNDE.md#e-133) (`BEFUNDE.md:446` auf dem Zweig) überein; die Folge von *No* bei einem nicht angeschlossenen Laufwerk (PRÜFER-87 K4) steht dort als offene Entscheidung und gehört in die Liste unten. Kein Pfad aus Gregors Verzeichnissen in den geänderten MDs des Zweigs (`git grep -c '%USERPROFILE%'` → 0 in ZWEIGE, BEFUNDE, README, CHANGELOG, WEITERMACHEN).

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„gepruefte Dateien 52“*, *„Kennungen im Verzeichnis 181“*, *„Kein Widerspruch gefunden.“*; *Zur Kenntnis* wie gehabt (z. B. *„Testdaten/README.md nennt weder den Quellstand 7.2.1.131 noch die Paketnummer 7.2.1.131 (hoechste genannte Fassung: 7.2.0.120)“*). [L-136.1](#l-136.1) bis [L-136.4](#l-136.4) sieht es nicht — es vergleicht Fassungsnummern, nicht Aussagen.

`perl tools/offene-befunde.pl` (gemessen): *„55 offene Befunde, in beiden Listen gleich.“*, *„davon aktuell gemessen 20“*, *„davon NIE gemessen 10“*. Dass [E-189](../Intern/BEFUNDE.md#e-189) und [E-170](../Intern/BEFUNDE.md#e-170) sich über Gregors Server widersprechen, erkennt es nicht.

`perl tools/pruefe-regressionstest.pl` (gemessen): *„kritisch 70“*, *„mit Testfall im Pruefstand 63 von 70“*, *„OHNE jede Pruefung 5 <- Rueckstand“*, *„Kein neues "behoben" ohne Regressionstest.“* — auf diesem Zweig ist nichts neu behoben.

`perl tools/ziel-stand.pl` (gemessen): *„ziel-stand: 27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

**Stand 03.11.2026 (Nachtrag 1):** Frage 1 und 3 sind entschieden, Frage 4 ist an Gregor gestellt; Einzelheiten jeweils am Ende des Punkts.

1. **[E-133](../Intern/BEFUNDE.md#e-133), Zweig `e133_mailverzeichnis_fehlt` — was soll *No* tun, wenn das Mailverzeichnis nur auf einem gerade nicht angeschlossenen Laufwerk liegt?** Im Quellstand nimmt Eudora dann den Ordner neben dem Programm und merkt ihn sich; steckt das Laufwerk beim nächsten Start wieder, fragt es nicht mehr und startet mit den (oft leeren) Postfächern neben dem Programm. Vorschlag aus PRÜFER-87 K4: bei *No* nichts merken, oder ein vierter Knopf *Retry*. Verloren geht nichts. (`e133_…:Intern/BEFUNDE.md:446` *„Zur Entscheidung Gregors“*.) **Entschieden 03.11.2026:** bleibt wie gebaut — Gregor: *„nein. man kann eudora.exe laufwerk:verzeichnis immer noch starten“*.
2. **[`E-208`](../Intern/BEFUNDE.md#e-208) (nur auf den Zweigen `e133_mailverzeichnis_fehlt` bzw. `e203_e204_persona_kennwort`) — fehlt der Registryeintrag `CommandLine\Current` ganz (frischer Rechner, Doppelklick), soll Eudora dann das Verzeichnis unter Application Data nehmen, statt mit „Cannot start Eudora the first time with attachments“ nicht zu starten?** Das Verhalten ist Original von QUALCOMM; bis zur Antwort bleibt es (`e133_…:Intern/BEFUNDE.md:401` *„Was noch fehlt: Gregors Entscheidung“*).
3. **Soll der veröffentlichte Release-Text zu 7.2.1.131 auf GitHub zu [E-170](../Intern/BEFUNDE.md#e-170) berichtigt werden?** Er sagt, mit Servern, die die neuen Nummern melden, bleibe das Label — an Gregors Server ging es am 29.10. trotzdem einmal verloren, Ursache offen ([L-136.3](#l-136.3)). **Entschieden 03.11.2026:** Ergänzung im nächsten PR — in `Releases/7.2.1.131/RELEASE-NOTIZEN.md:41-44` erledigt (`1a9e3ab0`); den Text auf GitHub selbst ändert erst Gregors Ja.
4. **Sollen die zwei Zweige auf GitHub gelöscht werden, die noch eine Gedächtnisdatei mit einer persönlichen Angabe tragen** (`origin/wt/lektor-20261102k`, `origin/wt/pruefer-20261102d`; [L-130.1](LEKTOR-130.md#l-130.1))? `main` und alle drei hier geprüften Zweige sind frei davon. **Stand 03.11.2026:** die Frage an Gregor läuft.
5. **Administratorrechte für die Messung von [E-176](../Intern/BEFUNDE.md#e-176)** (Lesen aus schon freigegebenem Speicher beim Schließen einer verworfenen neuen Nachricht) — unverändert offen, `Intern/WEITERMACHEN.md:96` *„eine Sitzung mit Administratorrechten (Gregors Ja)“*.

## <a id="nachtrag-1-03-11-2026"></a>Nachtrag 1 (03.11.2026) — eb83c995 und 1a9e3ab0 gegengelesen

`git merge origin/ergebnisse_1_131b` in `wt/lektor-20261103` (Spitze `cdc06b77`), ohne Konflikt (gemessen). Gelesen: `git diff eb83c995^ 1a9e3ab0` über CHANGELOG, FAQ, README, BEFUNDE, TESTPLAN, WEITERMACHEN und Release-Notizen.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-136.1](#l-136.1) [E-189](../Intern/BEFUNDE.md#e-189) rechnet mit Gregor-Server ohne UIDPLUS | **erledigt** | `BEFUNDE.md:412` *„(Gregors Server meldet sie, am 02.11.2026 an 7.2.1.131 gemessen, siehe [[E-170](../Intern/BEFUNDE.md#e-170)])“*; *„Was noch fehlt“* jetzt *„bestätigen am Prüfserver ohne `COPYUID` (Fall [`E-189`](../Intern/BEFUNDE.md#e-189)) oder an einem echten Server ohne UIDPLUS“*; erzeugt gleich in `CHANGELOG.md:42`, `WEITERMACHEN.md:91`; `grep -c 'vermutlich Gregors'` → 0 |
| [L-136.2](#l-136.2) Spur in [E-170](../Intern/BEFUNDE.md#e-170) | **erledigt**, aber mein Fund war falsch begründet ([L-136.10](#l-136.10)) | `BEFUNDE.md:422` *„`CImapSameServerTransferMsgAction::DoWork`, `EuImap/src/ImapActionQueue.cpp:1957`“* |
| [L-136.3](#l-136.3) README/FAQ „mit UIDPLUS bleibt das Label“ | **erledigt** | `README.md:166` *„mitgenommen wird es meistens, … an einem solchen Server ging es trotzdem einmal verloren (29.10.2026, Ursache offen).“*; `Doku/FAQ.md:212-213` *„bleibt das Label meistens; … an einem solchen Server ging es aber am 29.10.2026 einmal verloren, die Ursache ist offen“*; Release-Notizen siehe [L-136.11](#l-136.11) |
| [L-136.4](#l-136.4) TESTPLAN-Kopf und Abschnitt | **erledigt** | `TESTPLAN.md:3` *„Stand 03.11.2026 ([E-170](../Intern/BEFUNDE.md#e-170) aus Gregors Ergebnis-ZIP vom 02.11.2026 ausgewertet“*; `:350` *„Erledigt am 03.11.2026: das Label bleibt …“*; `:356` *„Die Schritte bleiben zum Nachlesen stehen; auszuführen sind sie nicht mehr.“* |
| [L-136.5](#l-136.5) WEITERMACHEN „Laufend: messungen_vor_…“ | **teilweise** ([L-136.12](#l-136.12)) | `WEITERMACHEN.md:3` *„Gemergt als #210: Zweig `messungen_vor_7_2_2_132`“* — erledigt; der Kopf sagt weiter *„**Stand 02.11.2026 abends.**“*, und kein laufender Zweig steht mehr in der Zeile |
| [L-136.6](#l-136.6) bis [L-136.9](#l-136.9) | unverändert (betreffen `e203_…`/`e133_…` bzw. die Zahl nach dem Merge) | — |

### <a id="l-136.10"></a>L-136.10 — Berichtigung zu L-136.2: die Klasse `CImapTransferMsgAction` gibt es, nur nicht mit eigenem `DoWork`

**Gewicht: Kleinkram, eigener Fehler.** (gemessen am Quelltext)

- `Eudora71/EuImap/src/ImapActionQueue.h:193` *„class CImapTransferMsgAction : public CImapAction“*, `:211` *„virtual HRESULT DoWork() = 0;“*, `:212` `DoPostProcessing`. Ich hatte nur `ImapActionQueue.cpp` nach `::DoWork` durchsucht und daraus „die Klasse gibt es nicht“ gemacht; richtig ist: sie ist die abstrakte Basisklasse, `DoWork` ist dort rein virtuell, der Aufruf mit `m_bAutoExpunge` steht in der abgeleiteten `CImapSameServerTransferMsgAction::DoWork` (`ImapActionQueue.cpp:1957`). Die Berichtigung in `eb83c995` trifft also; die übrigen Erwähnungen (`BEFUNDE.md:386`, `:412`, `:414`, `:422` *„CImapTransferMsgAction::DoPostProcessing“*) sind richtig und bleiben.

### <a id="l-136.11"></a>L-136.11 — In den Release-Notizen bezieht sich „das tat schon 7.2.1.128“ jetzt auf den falschen Satz

**Gewicht: Kleinkram.** (gemessen am Text)

- `Releases/7.2.1.131/RELEASE-NOTIZEN.md:41-46` *„bleibt das Label meistens erhalten, wenn der Server die neuen Nummern meldet — an einem solchen Server ging es am 29.10.2026 trotzdem einmal verloren, die Ursache ist offen (Nachtrag 03.11.2026; Nachtrag 02.11.2026, am Prüfstand gemessen: das tat schon 7.2.1.128; …)“* — durch den Einschub steht die Klammer hinter dem Verlust; „am Prüfstand gemessen: das tat schon 7.2.1.128“ liest sich nun, als sei der Verlust am Prüfstand gemessen. Gemeint ist das Mitnehmen.

**Vorschlag:** die Klammer vor den Gedankenstrich ziehen: *„… wenn der Server die neuen Nummern meldet (am Prüfstand am 02.11.2026 gemessen: das tat schon 7.2.1.128; …) — an einem solchen Server ging es am 29.10.2026 trotzdem einmal verloren, die Ursache ist offen (Nachtrag 03.11.2026)“*. Für den Text auf GitHub gilt Gregors Ja.

### <a id="l-136.12"></a>L-136.12 — WEITERMACHEN: Kopf „Stand 02.11.2026 abends“, laufende Zweige nicht genannt

**Gewicht: Kleinkram** (Rest von [L-136.5](#l-136.5)). (gemessen)

- `Intern/WEITERMACHEN.md:3` *„**Stand 02.11.2026 abends.**“*; `grep -o 'Laufend\|ergebnisse_1_131b\|e133_mailverzeichnis_fehlt\|e203_e204'` auf Zeile 3 → kein Treffer. Wer die Datei als Einstieg liest, erfährt nicht, dass drei Zweige auf den PR warten.

**Vorschlag:** Kopf auf 03.11.2026; *„Laufend: `ergebnisse_1_131b` (Gregors Ergebnis zu 7.2.1.131), `e133_mailverzeichnis_fehlt` ([[E-133](../Intern/BEFUNDE.md#e-133)], für 7.2.2.132), `e203_e204_persona_kennwort` ([[E-203](../Intern/BEFUNDE.md#e-203)]/[[E-204](../Intern/BEFUNDE.md#e-204)], für 7.2.2.132)“*.

Gregors Antworten von heute sind oben unter *„Was nur Gregor entscheiden kann“* eingetragen (Frage 1 und 3 entschieden, Frage 4 läuft).

## <a id="nachtrag-2-03-11-2026"></a>Nachtrag 2 (03.11.2026) — ce0cf32c gegengelesen

`git merge origin/ergebnisse_1_131b` ohne Konflikt (gemessen). `ce0cf32c` ändert zwei Dateien.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-136.11](#l-136.11) Klammer in den Release-Notizen | **erledigt**, mit kleinem Rest ([L-136.13](#l-136.13)) | `Releases/7.2.1.131/RELEASE-NOTIZEN.md:41-46` *„bleibt das Label meistens erhalten, wenn der Server die neuen Nummern meldet (Nachtrag 02.11.2026, am Prüfstand gemessen: das tat schon 7.2.1.128; …) — an einem solchen Server ging es am 29.10.2026 trotzdem einmal verloren, die Ursache ist offen (Nachtrag 03.11.2026)“* — das Mitnehmen steht jetzt bei der Prüfstandsmessung |
| [L-136.12](#l-136.12) WEITERMACHEN-Kopf | **erledigt** | `Intern/WEITERMACHEN.md:3` *„**Stand 03.11.2026:** Zweig `ergebnisse_1_131b` … Laufend: `e128_endung_aus_inhalt` ([[E-128](../Intern/BEFUNDE.md#e-128)]), `e170_label_ohne_uidplus`, `e133_mailverzeichnis_fehlt`, `e203_e204_persona_kennwort`. **Davor, Stand 02.11.2026 abends.**“*; alle vier Zweige gibt es auf `origin` (`git ls-remote --heads` → je 1). In `tools/ZWEIGE.md` dieses Zweigs steht keiner der vier — sie tragen sich auf ihren eigenen Zweigen ein (für `e133_…`/`e203_…` belegt, siehe [L-136.7](#l-136.7); `e128_…`/`e170_…` nicht gelesen) |

### <a id="l-136.13"></a>L-136.13 — „an einem solchen Server“ folgt jetzt auf „meldet der Server sie nicht“

**Gewicht: Kleinkram.** (gemessen am Text)

- Dieselbe Stelle: unmittelbar vor *„— an einem solchen Server ging es … verloren“* endet die Klammer mit *„meldet der Server sie nicht, geht das Label weiter verloren …“*. Gemeint ist ein Server **mit** Meldung (Gregors, [E-170](../Intern/BEFUNDE.md#e-170)); grammatisch liegt der Server ohne Meldung näher.

**Vorschlag:** *„— auch an einem Server, der sie meldet, ging es am 29.10.2026 einmal verloren …“*. Für den Text auf GitHub gilt Gregors Ja.
