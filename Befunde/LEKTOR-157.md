# <a id="lektor-157"></a>LEKTOR-157 (06.11.2026) — Zweig `e151_pruefstand_klon` nach be3d8b93: eigener Unterordner mit Marke, 49 Vorlagen, Klonprobe 103/106, Einarbeitung von LEKTOR-156

**Umfang:** `git log --stat 40c409a0..HEAD` (19 Commits, davon 24 Text- und Datendateien: `Doku/PRUEFSTAND.md`, `README.md`, `Intern/TESTPLAN.md`, `Intern/BEFUNDE.md`, `Intern/WEITERMACHEN.md`, `CHANGELOG.md`, `tools/WERKZEUGE.md`, `tools/TESTLAEUFE.md`, `tools/pruefstand-faelle.txt`, die drei neuen Vorlagen). Dazu der Bestand der MDs auf den Prüfstand hin und die Abnahme aus dem frischen Klon `C:\Temp\Klonprobe-0611`. Dort habe ich nur gelesen, nichts angelegt. Der Zweig `wt/lektor-20261106e` steht auf `be3d8b93`, gleich `origin/e151_pruefstand_klon` (gemessen nach `git fetch`). Gebaut und gestartet habe ich nichts.

**Urteil:** [LEKTOR-156](LEKTOR-156.md#lektor-156) ist in der Sache eingearbeitet. Zu jedem der 49 Fallverzeichnisse gibt es eine Vorlage, und eine Schranke wacht darüber. Der Einrichter nimmt `e169-schalter.txt` mit. Der Aufräumer kennt den Bildserver. Die Anleitung nennt jetzt Perl-Pfad, Platz, Leerzeichen und Gegenprobe. Die Zahlen im Testplan stimmen mit der Fallliste: 110 Fälle, davon 3 übersprungen, also 107 (gemessen). Die Klonprobe 103/106 ist im Startprotokoll belegt: 66 Starts von 15:08:01 bis 16:29:07 (gemessen). **Die Abnahme aus dem frischen Klon steht aber nirgends im Zweig.** Sie lief von 16:48 bis 17:02, also nach dem letzten Commit (16:44:59). Ihre zehn Startzeilen liegen nur ungesichert im Wegwerf-Klon. [E-151](../Intern/BEFUNDE.md#e-151) selbst ist inhaltlich hinter Entscheidung 39 zurück: Es nennt noch `C:\Temp` als Wurzel und steht in den Übersichten als „nie gemessen“. Sieben Funde. Keiner betrifft den Prüfstand selbst, [L-157.1](#l-157.1) und [L-157.2](#l-157.2) gehören aber in diesen PR.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„gepruefte Dateien 58“*, *„Kein Widerspruch gefunden.“*, 23 Hinweise „nennt weder … 7.2.2.136“ (Altbestand wie in [LEKTOR-156](LEKTOR-156.md#lektor-156)).
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 61“*, *„davon NIE gemessen 17“*, *„61 offene Befunde, in beiden Listen gleich.“* Das sind zwei mehr als bei [LEKTOR-156](LEKTOR-156.md#lektor-156): [E-243](../Intern/BEFUNDE.md#e-243) (Prüfstand-Werkzeuge konnten echte Eudora-Ordner unter `C:\Temp` treffen) und [E-244](../Intern/BEFUNDE.md#e-244) (Klon in einem Pfad mit Leerzeichen, Prüfserver starten nicht). Die Stufentabelle `Intern/BEFUNDE.md:158-162` sagt dasselbe: *„zusammen | 61 | 199 | 260“*.
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“*, weiter *„E-5->[E-6](../Intern/BEFUNDE.md#e-6)/[E-8](../Intern/BEFUNDE.md#e-8) E-6->[E-8](../Intern/BEFUNDE.md#e-8)“* ([L-153.7](LEKTOR-153.md#l-153.7)).
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen“*.
* Zusätzlich `perl tools/pruefe-feste-pfade.pl` (gemessen): *„75 Pruefstand-Skripte, kein fester Benutzerpfad, keine alte Pfadschranke; 49 Fallverzeichnisse, jedes mit Vorlage.“*

## Funde aus LEKTOR-156 — heutiger Stand

| Fund | Stand | Stelle (heute) |
|---|---|---|
| [L-156.1](LEKTOR-156.md#l-156.1) sechs Fälle ohne Vorlage | **erledigt** | `ls Testdaten/pruefstand \| wc -l` → 49; `tools/pruefe-feste-pfade.pl:109-127` verlangt zu jedem Verzeichnis `Mailverzeichnis/Eudora.ini`; `tools/pruefstand-einrichten.ps1:181-182` *„Schalterdateien neben dem Mailverzeichnis (E169B: e169-schalter.txt)“*; `Intern/TESTPLAN.md:54` *„107 Faelle, 107 bestanden … genau drei `[UEBR]`“*, 110 Zeilen in `pruefstand-faelle.txt` minus 3 = 107 (alles gemessen). Offen bleibt die Vermutung „Druckvorschau ohne Drucker“: [E-169](../Intern/BEFUNDE.md#e-169) lief nur auf der Entwicklermaschine grün. |
| [L-156.2](LEKTOR-156.md#l-156.2) Bildserver 18169 | **teilweise** | Code erledigt: `tools/pruefserver-aufraeumen.ps1:36` mit *„'e169-bildserver.pl'“*, `:41` mit *„18169“*. Die Doku nennt den Port (`Doku/PRUEFSTAND.md:39`, `:134-135`). `tools/WERKZEUGE.md:143` nennt weiter nur *„`anhang-pruefdaten.pl`, `imap-pruefserver.pl`, `smtp-pruefserver.pl`“* und *„Ports 11110/1143/1144/1025“* (gemessen). |
| [L-156.3](LEKTOR-156.md#l-156.3) Dauer je Fassung | **teilweise** | Erledigt: der Satz zur Dauer ist abgeschwächt (`Doku/PRUEFSTAND.md:69-72`), und 7.2.2.136 heißt „Release“ (`:85`). Offen: `:69` *„ältere Läufe ohne eindeutige Fassung fehlen“*; die Spanne *„60 bis 91“* steht an sieben Stellen (`:8`, `:17`, `:30`, `:56`, `:96`, `:140`, `README.md:112`); `Doku/MITARBEITEN.md:101` *„— rund eine Stunde.“* (gemessen) |
| [L-156.4](LEKTOR-156.md#l-156.4) Voraussetzungen für Fremde | **erledigt** | `Doku/PRUEFSTAND.md:36` *„Git für Windows, für alle Benutzer installiert“*, `:40` Platz, `:123-126` Perl-Pfad als Bedingung, `:237-240` Gegenprobe mit `-Bau`, `:102` *„den Druck auf Papier … – die Druckvorschau prüft er“* (gemessen) |
| [L-156.5](LEKTOR-156.md#l-156.5) Stand im Zweig | **offen** | `Intern/WEITERMACHEN.md:10-11` *„**Wartet auf Merge:** `paket_7_2_2_136`“*; `CHANGELOG.md:59` und `Intern/WEITERMACHEN.md:131` [E-151](../Intern/BEFUNDE.md#e-151) *„**nie gemessen**“*; `tools/pruefstand-einrichten.ps1:42-44` *„Wurzel ist C:\Temp … Eine andere Wurzel waere ein eigener Schritt.“*. Der Kommentar ist jetzt doppelt falsch, siehe [L-157.4](#l-157.4) (alles gemessen). |
| [L-156.6](LEKTOR-156.md#l-156.6) Merge ohne Verlust | — | kein Mangel |

Die vier Funde aus [LEKTOR-155](LEKTOR-155.md#lektor-155) sind unverändert offen. Sie gehören nach `main`, nicht in diesen PR: `Intern/BEFUNDE.md:408` K3 *„steht aus“*, `:409` *„Vorschlag, nicht umgesetzt“*, `Releases/PRUEFBERICHT.md:6` *„Arbeitsbaum nicht sauber“*. In `Intern/LEKTORAT.md` fehlen weiter die „Eingearbeitet“-Zeilen ab [LEKTOR-152](LEKTOR-152.md#lektor-152) (gemessen).

## Funde

### <a id="l-157.1"></a>L-157.1 — Die Abnahme aus dem frischen Klon steht nicht im Zweig, ihre Startzeilen liegen nur im Wegwerf-Klon

**Gewicht: mittel — gehört in diesen PR.** In `C:\Temp\Klonprobe-0611` (Klon auf `be3d8b93`, gemessen mit `git -C … log -1`) gibt es zwei Runden mit je fünf Eudora-Starts unter der Wurzel `C:\Temp\Klonprobe-0611-pruefstand`: `E133`, `EABOUT-lang-log`, `E169`, `E169B` und `E239`, von 16:48:57 bis 17:02:27. Sie stehen in `C:\Temp\Klonprobe-0611\tools\TESTLAEUFE.md`, und `git -C C:\Temp\Klonprobe-0611 diff --stat` zeigt *„tools/TESTLAEUFE.md | 10 ++++++++++“*, also ungesichert (gemessen). Im Zweig fehlen diese zehn Zeilen. `git grep Klonprobe-0611 origin/e151_pruefstand_klon` findet nichts (gemessen). Wird der Klon gelöscht, sind zehn Eudora-Starts aus dem Protokoll verschwunden ([jeder Start ins Protokoll](../Arbeitsweise/jeder-start-ins-protokoll.md)).

Belegen lässt sich aus den Dateien nur ein Teil der gemeldeten Zahlen: *„[E-133](../Intern/BEFUNDE.md#e-133) 3/3, E-216l 1/1, [E-169](../Intern/BEFUNDE.md#e-169) 5/5, E-239p 1/1“*. `C:\Temp\Klonprobe-0611-pruefstand\pruefstand-ergebnis.txt` hält nur den letzten Teillauf fest: *„faelle=1 bestanden=1 … fall=[ ok ] E-239p E239 URTEIL gruen“* (gemessen). Für die anderen drei Teilläufe zeigt das Protokoll die Starts, das Ergebnis aber nicht. Gemessen ist dabei, dass Einrichten aus dem Klon 49 Verzeichnisse anlegt (`ls -d …/*/ | wc -l` → 49) und dass nur `E-166a`, `E-166b` und `E-222w` als nicht einrichtbar gelten (`Eudora72-Pruefstand-nicht-einrichtbar.txt`). Damit ist [L-156.1](LEKTOR-156.md#l-156.1) auch im Klon bestätigt.

Im Zweig steht stattdessen `Intern/TESTPLAN.md:46-47` *„Ein voller Lauf nach der Berichtigung steht aus.“* Das stimmt für den vollen Lauf weiterhin. Dass die Pfadfälle und die drei neuen Vorlagen aus einem echten Klon grün sind, steht dagegen nirgends.

**Vorschlag:** die zehn Zeilen in `tools/TESTLAEUFE.md` des Zweigs übernehmen. In [E-151](../Intern/BEFUNDE.md#e-151) und im Testplan einen Satz ergänzen: Abnahme aus frischem Klon am 06.11.2026, Wurzel `C:\Temp\Klonprobe-0611-pruefstand`, die vier Teilläufe mit Ergebnis, zweimal gefahren. Die Teilergebnisse dabei aus der Ausgabe des Starters zitieren, die Datei hält sie nicht.

### <a id="l-157.2"></a>L-157.2 — E-151 ist hinter Entscheidung 39 zurück und steht als „nie gemessen“, ebenso E-243

**Gewicht: gering bis mittel — gehört in diesen PR.** Die Zeile [E-151](../Intern/BEFUNDE.md#e-151) (`Intern/BEFUNDE.md:452`) wurde in diesem Zweig seit 40c409a0 nicht angefasst (gemessen, `git diff` ohne Treffer in der Zeile). Sie sagt:

* *„deshalb nimmt der Starter `C:\Temp` als Wurzel“*. Seit Entscheidung 39 ist die Vorgabe `C:\Temp\Eudora72-Pruefstand` (`tools/pruefstand-starten.ps1:47`, gemessen).
* *„**Was noch fehlt:** ein voller Lauf über den Starter mit Wurzel `C:\Temp` auf einem zweiten Rechner oder Konto“*. Das widerspricht Entscheidung 39 (`Intern/WEITERMACHEN.md:213`) und dem Testplan (`Intern/TESTPLAN.md:37-42`, *„Zurückgestellt (Gregor 06.11.2026)“*).
* Von den Messungen des 06.11. steht nichts darin: weder die Klonprobe 103/106 noch die Abnahme ([L-157.1](#l-157.1)) noch die Zurückstellung. Nur [E-243](../Intern/BEFUNDE.md#e-243) trägt sie (`:404`).

Dazu wiederholt sich [L-156.5](LEKTOR-156.md#l-156.5): `CHANGELOG.md:59` und `Intern/WEITERMACHEN.md:131` führen [E-151](../Intern/BEFUNDE.md#e-151) als *„**nie gemessen**“* mit demselben überholten „was noch fehlt“. Neu kommt [E-243](../Intern/BEFUNDE.md#e-243) dazu, mit *„**nie gemessen**“* in `CHANGELOG.md:32` und `Intern/WEITERMACHEN.md:104`, obwohl die Zeile sagt *„am laufenden Programm gemessen am 06.11.2026“* (`Intern/BEFUNDE.md:404`). Ursache: Beiden Zeilen fehlt die Marke `**Zuletzt gemessen: …**`, die `offene-befunde.pl` liest (gemessen: `grep -c "Zuletzt gemessen"` über beide Zeilen → 0). Das Werkzeug schreibt die Übersicht richtig ab, die Quelle ist unvollständig.

**Vorschlag:** in [E-151](../Intern/BEFUNDE.md#e-151) „Was noch fehlt“ auf „voller Lauf auf einem zweiten Rechner oder Konto, Vorgabe-Wurzel `C:\Temp\Eudora72-Pruefstand` (zurückgestellt, Gregor 06.11.2026)“ setzen und die Messungen des 06.11. nachtragen. In [E-151](../Intern/BEFUNDE.md#e-151) und [E-243](../Intern/BEFUNDE.md#e-243) die Marke „Zuletzt gemessen: 06.11.2026 an 7.2.2.136“ setzen, dann `perl tools/offene-befunde.pl --schreiben`.

### <a id="l-157.3"></a>L-157.3 — „Klonprobe“ für einen Lauf aus dem Entwicklerbaum, und die Dauer dieser Zeile steht in keiner Datei

**Gewicht: gering.** `Doku/PRUEFSTAND.md:86`, [E-243](../Intern/BEFUNDE.md#e-243) (`:404`, *„Klonprobe mit dem Starter unter `C:\Temp\Eudora72-Pruefstand`“*) und `tools/WERKZEUGE.md:140` (*„Klonprobe dort 103/106“*) nennen den Lauf vom Nachmittag „Klonprobe“. Seine 66 Starts (15:08:01 bis 16:29:07) stehen aber im `tools/TESTLAEUFE.md` des Zweigs selbst (gemessen: 66 Zeilen mit `Eudora72-Pruefstand\` und *„per Pruefstand starten“*). Der Lauf ging also vom Arbeitsbaum der Entwicklermaschine aus, nicht von einem frischen Klon (belegt). `Intern/TESTPLAN.md:43` sagt es richtig: *„Gemessen an der Entwicklermaschine“*. Ein Leser von Doku und Befund hält ihn für das, was erst die Abnahme in [L-157.1](#l-157.1) war.

Die Dauer *„81 min 21 s“* in `Doku/PRUEFSTAND.md:86` steht in keiner Datei des Repos. Der Starter fährt den Lauf mit `-OhneBuch` (`tools/pruefstand-starten.ps1:138`), deshalb zeigt `Intern/pruefstand-dauer.txt` weiter den Lauf von 11:30:46 mit 5476 s (gemessen). Die Commit-Nachricht von `8d51e539` nennt *„83 min“*. Die Zahlen 106 Fälle und 66 Starts stimmen (gemessen). Der Kopf der Tabelle (`:66-68`) sagt aber, die Werte stammen aus `pruefstand-dauer.txt` in der Git-Geschichte. Für diese Zeile stimmt das nicht.

**Vorschlag:** „Lauf mit dem Starter aus dem Entwicklerbaum“ statt „Klonprobe“; die Quelle der Dauer in der Zeile nennen (Ausgabe des Starters) oder die 83 min aus der Commit-Nachricht nehmen.

### <a id="l-157.4"></a>L-157.4 — Kommentare und WERKZEUGE-Zeilen kennen die neue Wurzel und E-133r nicht

**Gewicht: gering.** Keine MD, aber wer den Prüfstand erweitert, liest es (alles gemessen):

* `tools/pruefstand-einrichten.ps1:1` *„die Pruefverzeichnisse unter C:\Temp“*, `:34` *„C:\Temp\Eudora72-Pruefstand-nicht-einrichtbar.txt“* (heute `<Wurzel>\…`, `:73`), `:42-44` *„Wurzel ist C:\Temp … Eine andere Wurzel waere ein eigener Schritt.“*, `:59` *„C:\Temp oder ein Ordner darunter“*. Der Code darunter: `:60` Vorgabe `C:\Temp\Eudora72-Pruefstand`, `:67` jeder Ordner außer einem Laufwerksstamm.
* `tools/pruefstand-starten.ps1:30` *„in C:\Temp; dieser Starter nimmt eine eigene Wurzel.“*, `:35` *„[-Wurzel C:\Temp]“*.
* `tools/pruefstand-sperre.ps1:33-34` *„Pfad unter <LW>:\Temp\“*. Seit `:153-154` gilt die Marke.
* `tools/WERKZEUGE.md:140` steht zuerst *„Vorgabe-Wurzel `C:\Temp` (nur dort stimmen die Pfade in den erwarteten Zeilen …)“* und erst danach *„Seit 06.11.2026 … Vorgabe-Wurzel `C:\Temp\Eudora72-Pruefstand`“*. Der erste Halbsatz ist seit `pruefstand-lauf.ps1:93-97` (Wurzel ersetzt `C:\Temp\` in den erwarteten Texten) falsch.
* `tools/WERKZEUGE.md:144` (`pruefe-feste-pfade.pl`) nennt die neue Regel „jedes Fallverzeichnis hat eine Vorlage“ nicht. `:143` siehe [L-156.2](LEKTOR-156.md#l-156.2).
* Neuer Fall `E-133r` (`tools/pruefstand-faelle.txt:601`, *„E133 REGISTRY zeigt-hierher=1“*): Er kommt in `Intern/BEFUNDE.md`, `Doku/PRUEFSTAND.md` und `tools/WERKZEUGE.md` 0-mal vor, nur in `Intern/TESTPLAN.md`. `E-133p` prüft seither nur noch das Präfix *„registry-danach=“* (`:595`). Der Befund [E-133](../Intern/BEFUNDE.md#e-133) (Registry-Eintrag des Mailverzeichnisses) beschreibt `E-133p`/`E-133q` weiter mit dem alten Inhalt und weiß nicht, dass die Prüfung des Pfads in `E-133r` gewandert ist.

**Vorschlag:** die Kommentare auf „Vorgabe `C:\Temp\Eudora72-Pruefstand`, jede Wurzel außer Laufwerksstamm, geschützt durch die Marke“ bringen. WERKZEUGE:140 den alten Halbsatz streichen, :143/:144 nachziehen. In [E-133](../Intern/BEFUNDE.md#e-133) einen Satz zu `E-133r` und zum geänderten `E-133p`.

### <a id="l-157.5"></a>L-157.5 — `-Wurzel D:\Pruefstand` ist beworben, aber außerhalb von `C:\Temp` nie gefahren

**Gewicht: gering.** `Doku/PRUEFSTAND.md:205` nennt als Beispiel *„`-Wurzel D:\Pruefstand` … jeder Ordner außer einem Laufwerksstamm. Die Marke schützt fremde Verzeichnisse auch dort.“* Gemessen ist nur unter `C:\Temp\…` (Startprotokoll: `C:\Temp\Eudora72-Pruefstand`, `C:\Temp\Klonprobe-0611-pruefstand`, `C:\Temp\E133`). Belegt am Quelltext sind dagegen zwei Stellen, die an `C:\Temp` hängen. Sperre und festgehaltener Registry-Stand liegen fest unter `C:\Temp\Eudora72-Pruefstand.lock` / `.reg.xml` (`tools/pruefstand-sperre.ps1:53-54`). Das Aufräumen der Registry liest unter `<Basis>\C:\Temp` (`:175-176`). Ob nach einem Lauf unter `D:\` Registry-Reste bleiben, ist eine Vermutung, gemessen ist es nicht. Dazu nimmt die Wurzel Leerzeichen an (`Intern/BEFUNDE.md:403`, [E-244](../Intern/BEFUNDE.md#e-244): *„Eine Wurzel mit Leerzeichen wird trotzdem angenommen“*). Die Schalterzeile warnt davor nicht, nur die Voraussetzung zum Klonpfad (`:37`, `:127-128`).

**Vorschlag:** das Beispiel auf `C:\Pruefstand` oder `C:\Temp\Anders` stellen, bis ein Lauf auf einem anderen Laufwerk gemessen ist, und „ohne Leerzeichen“ auch für `-Wurzel` sagen.

### <a id="l-157.6"></a>L-157.6 — Zahlen in der Anleitung: drei alte Werte, Platz gemessen

**Gewicht: gering.**

* `Doku/PRUEFSTAND.md:55` *„gut 1 min für 46 Verzeichnisse … Klonprobe … 05.11.2026“*. Heute sind es 49. Die Zeile ist als Messung vom 05.11. datiert, also nicht falsch, aber einen neuen Wert gibt es nicht.
* `:214` das Beispiel *„Ergebnis: 100 Faelle, 100 bestanden“*. Der Testplan erwartet 107 (`Intern/TESTPLAN.md:54`). Ein Fremder vergleicht beides.
* Platz, nachgemessen (gemessen, `du -sm`): `C:\Temp\Klonprobe-0611` belegt 796 MB, davon `.git` 214 MB (`size-pack: 212.51 MiB`). Im Klon liegt auch `Eudora71\Bin\Release`. Die Angabe *„gut 700 MB … 510 MB Dateien und 224 MB Git-Geschichte“* (`:137-139`) passt für einen Klon ohne Bau. `C:\Temp\Eudora72-Pruefstand` belegt 1578 MB, wie angegeben. Die Wurzel aus dem frischen Klon nach vier Teilläufen nur 989 MB. Die 1,6 GB sind also ein Wert nach einem vollen Lauf, keine Mindestgröße. Kein Mangel.
* Der Rest von [L-156.3](LEKTOR-156.md#l-156.3) (Spanne 60–91, MITARBEITEN „rund eine Stunde“) steht in der Tabelle oben.

**Vorschlag:** :214 auf 107 stellen, den Rest mit [L-156.3](LEKTOR-156.md#l-156.3).

### <a id="l-157.7"></a>L-157.7 — Neue Schranken und Haken: Einträge stimmen mit der Einbindung

**Gewicht: kein Mangel, zur Nachprüfbarkeit.** `tools/WERKZEUGE.md:103` (`pruefe-namen-gestaget.pl` im `pre-commit` und `pre-push --seit-main`) stimmt mit `tools/hooks-einrichten.sh:591` und `:678-679` überein. `:208` (`haken-backslash.pl`, PreToolUse) stimmt mit `.claude/settings.json:33`. Die sechs Zeilen mit Nachtrag vom 06.11. (`pruefstand-sperre.ps1`, `testlauf.ps1`, `pruefstaende-auffrischen.ps1`, `pruefstand-lauf.ps1`, Starter, Einrichter) widersprechen dem Code nicht, bis auf den alten Halbsatz in :140 ([L-157.4](#l-157.4)) (alles gemessen). In den neuen Zeilen der MDs und Vorlagen steht kein Name aus Gregors Mailverzeichnis (die Schranke lief bei jedem Commit). Selbst geprüft habe ich das nur stichprobenhaft.

## Hält etwas den PR `e151_pruefstand_klon` → `main` auf?

**In der Sache nein.** Der Prüfstand läuft aus einem frischen Klon, und die drei fehlenden Vorlagen sind da. Das ist im Wegwerf-Klon gemessen ([L-157.1](#l-157.1)). [L-157.1](#l-157.1) und [L-157.2](#l-157.2) sollten aber **vor** dem PR in den Zweig, beides ist Text ohne Code. Sonst gehen zehn Eudora-Starts aus dem Startprotokoll verloren, sobald der Klon gelöscht wird. Und `main` bekäme ein [E-151](../Intern/BEFUNDE.md#e-151), das gegen Entscheidung 39 die Wurzel `C:\Temp` verlangt und mit [E-243](../Intern/BEFUNDE.md#e-243) als „nie gemessen“ in den Übersichten steht. [L-157.3](#l-157.3) bis [L-157.6](#l-157.6) und die Reste von [LEKTOR-156](LEKTOR-156.md#lektor-156) können folgen.

## Was nur Gregor entscheiden kann

Nichts Neues.
