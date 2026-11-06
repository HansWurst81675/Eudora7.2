# <a id="lektor-158"></a>LEKTOR-158 (06.11.2026) — `main` nach dem Merge von #229 (037c361c): Datenschutz über das ganze Repo, Einarbeitung von LEKTOR-157

**Umfang:** In erster Linie Datenschutz. Gregor wollte am 06.11.2026, dass der Lektor *„speziell auf datenschutz-issues ausschau“* hält. Durchsucht habe ich jede versionierte Textdatei auf `origin/main` (`037c361c`), die Commit-Nachrichten seit dem 29.10.2026 und die Commits, auf die das Repo mit ihrer Kennung verweist. Dazu kommen die Commits seit [LEKTOR-157](LEKTOR-157.md#lektor-157) (`be3d8b93..037c361c`) und der Stand der Funde von [LEKTOR-157](LEKTOR-157.md#lektor-157). Gebaut und gestartet habe ich nichts. Die Suchskripte liegen nur im Scratchpad, nicht im Repo.

**Diese Datei nennt keinen Fundtext.** Sie nennt nur Datei:Zeile und die Art des Fundes. Das gilt auch für Commit-Kennungen: Kennungen von Commits mit privatem Inhalt stehen hier nicht. Wer einen Fund nachprüfen will, findet ihn mit den Zeilenangaben.

**Urteil:** Die Commits seit [LEKTOR-157](LEKTOR-157.md#lektor-157) sind sauber. In den neuen Zeilen steht nichts von der Namensliste, kein Pfad aus Gregors Rechner und kein Anbietername (gemessen). Die Kennung des umgeschriebenen Commits vom 05.11. steht weder in einer Datei, die seit dem 04.11. geändert wurde, noch in einer Commit-Nachricht auf `main` seit dem 04.11. (gemessen: jede Kennung in Backticks und jede Kennung mit 13 bis 40 Zeichen gegen `git cat-file` geprüft, die übrigen Fehltreffer sind SHA-256-Präfixe). **Im Bestand stehen aber weiter Angaben über Gregors Rechner, Ordner und Postfach.** Zwei davon sind nach den Regeln vom 03.11. entstanden, eine am 06.11. Dazu kommen rund 90 Stellen, deren Commit-Kennung zu privatem Inhalt in der Geschichte von `main` führt. Zehn Funde, davon sieben zum Datenschutz.

## Mechanisch (Ausgaben, kein Urteil)

* `perl tools/doku-pruefen.pl` (gemessen): Rückgabe 0, *„gepruefte Dateien 58“*, *„Kein Widerspruch gefunden.“*, 23 Hinweise „nennt weder … 7.2.2.136“ (Altbestand).
* `perl tools/offene-befunde.pl` (gemessen): *„offen laut Intern/BEFUNDE.md 63“*, *„davon NIE gemessen 17“*, *„63 offene Befunde, in beiden Listen gleich.“* Das sind zwei mehr als bei [LEKTOR-157](LEKTOR-157.md#lektor-157): [E-245](../Intern/BEFUNDE.md#e-245) und [E-246](../Intern/BEFUNDE.md#e-246) (der umgeschriebene Commit bleibt über seine Kennung abrufbar).
* `perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“*
* `perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen“*.
* `perl tools/pruefe-testdaten-anonym.pl` mit der lokalen Liste (gemessen): *„GRUEN: 50 Datei(en) geprueft, nichts beanstandet.“* Die Liste habe ich dafür vorübergehend in den Arbeitsbaum kopiert und danach wieder gelöscht. `git status` war danach leer.

## Funde aus LEKTOR-157 — heutiger Stand

| Fund | Stand | Stelle (heute, gemessen) |
|---|---|---|
| [L-157.1](LEKTOR-157.md#l-157.1) Abnahme aus dem Klon fehlt | **erledigt** | `tools/TESTLAEUFE.md`: 10 Zeilen mit `Klonprobe-0611`; [E-151](../Intern/BEFUNDE.md#e-151) (`Intern/BEFUNDE.md:454`) nennt die *„Abnahme aus einem frischen Klon“* |
| [L-157.2](LEKTOR-157.md#l-157.2) [E-151](../Intern/BEFUNDE.md#e-151)/[E-243](../Intern/BEFUNDE.md#e-243) „nie gemessen“ | **erledigt** | `:454` *„Zuletzt gemessen: 06.11.2026 an 7.2.2.136“*, „Was noch fehlt“ nennt den zweiten Rechner als *„zurückgestellt“*; kein „nie gemessen“ mehr zu [E-151](../Intern/BEFUNDE.md#e-151)/[E-243](../Intern/BEFUNDE.md#e-243) in CHANGELOG und WEITERMACHEN |
| [L-157.3](LEKTOR-157.md#l-157.3) „Klonprobe“ für den Entwicklerbaum | **erledigt** | `Doku/PRUEFSTAND.md:86` *„aus dem Entwicklerbaum, Dauer laut Ausgab…“*; `tools/WERKZEUGE.md` ohne *„Klonprobe dort“* |
| [L-157.4](LEKTOR-157.md#l-157.4) Kommentare, WERKZEUGE, E-133r | **offen** | `tools/pruefstand-einrichten.ps1:1` *„unter C:\Temp“*, `:42` *„Wurzel ist C:\Temp“*; `tools/pruefstand-starten.ps1:30`; `tools/pruefstand-sperre.ps1:33`; `tools/WERKZEUGE.md:140` weiter *„Vorgabe-Wurzel `C:\Temp` (nur …“*; `E-133r` 0-mal in WERKZEUGE und PRUEFSTAND, in der Zeile [E-133](../Intern/BEFUNDE.md#e-133) (`:467`, Registry-Eintrag des Mailverzeichnisses) nicht genannt |
| [L-157.5](LEKTOR-157.md#l-157.5) `-Wurzel D:\…` nie gefahren | **teilweise** | „ohne Leerzeichen“ jetzt bei `:37` und `:127`; das Beispiel `:205` *„`-Wurzel D:\Pruefstand`“* steht unverändert |
| [L-157.6](LEKTOR-157.md#l-157.6) Zahlen in der Anleitung | **teilweise** | `:214` jetzt *„107 Faelle, 107 bestanden“*; die Spanne *„60 bis 91“* steht weiter siebenmal, `Doku/MITARBEITEN.md:101` *„rund eine Stunde“*; `tools/WERKZEUGE.md:143` ohne Port 18169 ([L-156.2](LEKTOR-156.md#l-156.2)) |
| [L-157.7](LEKTOR-157.md#l-157.7) | — | kein Mangel |

## Datenschutz — wie gesucht wurde

Alles gemessen. Die Skripte geben nur Datei:Zeile und die Musternummer aus, nie den Treffer.

1. **Namensliste** (`tools/anonym-begriffe.lokal`, 9 Muster, Muster 1 „Vorname des Anwenders“ ausgenommen) über alle versionierten Dateien. Ergebnis: **0 Treffer in Projektdateien.** Muster 3 trifft dreimal in unveränderten Fremdquellen aus dem ersten Import (OpenSSL, zlib: Autorennamen), dazu fünfmal in den QUALCOMM-Originalen (`Documents/`, `InstallersForEudora/`). Beides nur gezählt.
2. **Mailadressen** in allen Zeilen, die das Projekt seit dem ersten Import (`567a5d87`) hinzugefügt hat: 546 Treffer. Alle Domänen sind Platzhalter, Herstelleradressen aus OpenSSL oder der Mailanbieter (siehe 5).
3. **IP-Adressen** außer 127.x und den Testnetzen in denselben Zeilen: Server des Mailanbieters (siehe 5) und eine Adresse aus einem Einwahlnetz ([L-158.6](#l-158.6)). **Windows-Benutzernamen** außer „Gregor“: nur Platzhalter und das Standardkonto der Windows-Sandbox. **Rechnernamen**: keine.
4. **Pfade** in Gregors Testverzeichnisse, zur VM-Freigabe und zum Austauschordner, im Baum und in 601 Commit-Nachrichten seit dem 29.10.
5. **Anbieter- und Absendernamen** aus Gregors Postfach, gezählt nach Datum. Für den Namen des Mailanbieters gilt Gregors Entscheidung vom 03.11.: *„Nein, nur ab jetzt“* (`Arbeitsweise/gedaechtnis-ist-oeffentlich.md:114`). Rund 270 alte Nennungen bleiben deshalb stehen. **Nach dem 03.11. ist keine neue Nennung dazugekommen** (gemessen gegen `e992d982`, die fünf Treffer in `Intern/BEFUNDE.md` sind umformulierte Zeilen mit gleicher Anzahl wie vorher).
6. **Commit-Kennungen**: Ich habe jede Kennung aus den Textdateien genommen und den Commit, auf den sie zeigt, gegen die Muster aus 1 und 4 geprüft (Nachricht und hinzugefügte Zeilen, ohne OpenSSL/Sandbox).

Diese Suche ist nur **nach diesen Mustern** sauber. Nach Lebensumständen (Abwesenheit, Gesundheit, Familie, Wohnort) habe ich zusätzlich mit 30 Stichwörtern gesucht. Dabei fand sich nur, was unter [L-158.4](#l-158.4) steht.

## Funde

### <a id="l-158.1"></a>L-158.1 — Der Freigabepfad der VM steht seit heute in einem Werkzeug

**Gewicht: hoch.** `tools/testplan-voraussetzungen.pl:33` (Kommentar, Beispielaufruf) nennt den vollständigen Pfad der VM-Freigabe auf Gregors Rechner. Der Pfad enthält den Namen der VM, den Namen des Austauschordners und ein ZIP seines Mailverzeichnisses. Die Zeile kam am 06.11.2026 dazu (gemessen mit `git blame`) und steht auf `main`. Das ist dieselbe Art Angabe, die die Nachträge vom 30.10. und 02.11. in `Arbeitsweise/gedaechtnis-ist-oeffentlich.md` beschreiben. `pruefe-namen-gestaget.pl` erkennt sie nicht, weil die Namensliste keine Pfade kennt.

**Vorschlag:** den Beispielaufruf auf einen Platzhalter stellen (`--ini <Ordner>\Mailverzeichnis.zip`). Die Schranke sollte auch Freigabepfade (`//<host>/…`, `\\<rechner>\`) abweisen. Die Lehre fordert das seit dem 30.10., ein Werkzeug fehlt.

### <a id="l-158.2"></a>L-158.2 — Austauschordner, Bildschirmfoto und Ausstattung von Gregors Rechnern, nach der Regel vom 03.11.

**Gewicht: mittel.** Der Name von Gregors Austauschordner steht an 13 Stellen. Alle sind nach Gregors Regel vom 03.11. entstanden (*„keine Pfade seiner Testverzeichnisse“*, `Arbeitsweise/gedaechtnis-ist-oeffentlich.md:113`):

* `CHANGELOG.md:128`, `:139`, `:146`
* `Intern/TESTPLAN.md:11`, `:61`, `:74`, `:86`, `:102`
* `Releases/PAKETE.md:197`, `:213`, `:229`
* `Arbeitsweise/stand-05-11-2026-nacht.md:11`
* `Intern/BEFUNDE.md:400` ([E-222](../Intern/BEFUNDE.md#e-222)). In dieser Zeile stehen außerdem der Dateiname eines Bildschirmfotos von Gregor, dass er einen zweiten PC hat, und eine Systemkomponente, die auf seinem Rechner installiert ist.

Dazu nennen drei Commit-Nachrichten vom 05.11. den Austauschordner. Mit dem Merge stehen sie auf `main`. Ändern ließen sie sich nur durch Umschreiben ([Was nur Gregor entscheiden kann](#gregor)).

**Vorschlag:** in den Dateien „im Austauschordner“ ohne Namen schreiben. In [E-222](../Intern/BEFUNDE.md#e-222) bleibt „Bildschirmfoto von Gregor vom 05.11.“ ohne Dateinamen, ohne zweiten PC und ohne die Komponente. Ob das Prüfergebnis ohne die Komponente verständlich bleibt, entscheidet die Hauptsitzung.

### <a id="l-158.3"></a>L-158.3 — „bei Gregor gegeben“: Aussagen über echte Eudora-Ordner auf seinem Rechner

**Gewicht: mittel.** Commit 44200507 sollte genau diese Art Satz entfernen (*„keine Saetze ueber seinen Rechner“*). Zwei Stellen sind geblieben:

* `Intern/BEFUNDE.md:406` ([E-243](../Intern/BEFUNDE.md#e-243), Prüfstand konnte echte Eudora-Ordner treffen), Spalte Stufe: Die Klammer sagt, dass die Voraussetzung für Datenverlust bei Gregor erfüllt ist. Die Zeile wurde am 06.11. in 3bc521c2 neu geschrieben (gemessen mit `git blame`).
* `Befunde/PRUEFER-104.md:88`: Der Satz geht davon aus, dass Gregor eine Eudora-Instanz unter `C:\Temp` hat.

**Vorschlag:** In beiden Fällen auf „bei Anwendern mit echten Instanzen unter `C:\Temp`“ verallgemeinern. Die Stufe bleibt gleich.

### <a id="l-158.4"></a>L-158.4 — Absender und Betreff aus Gregors Postfach

**Gewicht: mittel.** Seit dem 29.10. gilt: keine Absender und keine Betreffzeilen aus Gregors Postfach. Bei der Bereinigung sind drei Arten übrig geblieben:

* **Ein Absender, aus dem sich auf die Gesundheit schließen lässt** (Rundbrief eines Anbieters von Medizinprodukten): `CHANGELOG.md:3432`, `Eudora71/Eudora/msgutils.cpp:3132` (Kommentar). Der schwerste Fund in dieser Gruppe.
* **Eine Betreffzeile als Dateiname** einer gespeicherten Mail: `Intern/BEFUNDE.md:365` (Zeile vom 23.10.).
* **Ein Softwarehersteller als Absender seines Rundbriefs**, 21 Stellen: `Befunde/LEKTOR-35.md:8`, `:28`, `:39`, `:41`, `:123`; `Befunde/PRUEFER-7.md:228`; `CHANGELOG.md:1779`; `Eudora71/EuImap/src/ImapAppend.cpp:733`, `:1398`; `Eudora71/Tests/TestE118.cpp:112`, `:115`, `:120`, `:121`; `Intern/BEFUNDE.md:381`, `:384`; `Intern/TESTPLAN.md:1490`; `Intern/WEITERMACHEN-bis-7.2.0.md:40`; `Releases/1.0.90/TESTEN.txt:10`, `:11`; `Releases/PAKETE.md:864`, `:873`.

**Vorschlag:** jeweils „ein Rundbrief“ oder „eine HTML-Mail mit eingebetteten Bildern“ schreiben, den Dateinamen weglassen. Die beiden Quelltextkommentare und `TestE118.cpp` ändern sich nur im Kommentar und im Testnamen. Dabei gilt Byte-Treue, Latin-1.

### <a id="l-158.5"></a>L-158.5 — Commit-Kennungen, die zu privatem Inhalt in der Geschichte von `main` führen

**Gewicht: mittel.** Bisher wurde nur der Inhalt im Baum bereinigt, die Geschichte nicht. Die Commits mit dem alten Inhalt liegen weiter in `main` und sind öffentlich. Das Repo verweist auf sie mit ihrer Kennung (gemessen: `git merge-base --is-ancestor … origin/main` bei jedem davon wahr):

* **Familienname oder Absendername aus der Namensliste** (Muster 4 und 7), dazu Betreff und Anhangnamen aus Gregors Postfach (laut `gedaechtnis-ist-oeffentlich.md:27`) und der Name seiner Sicherung (`:54`): 11 Commits, **31 Stellen in 15 Dateien**. Darunter `Arbeitsweise/gedaechtnis-ist-oeffentlich.md:27`, `:54`, `Arbeitsweise/CHRONIST-2026-10-22.md:44`, `Arbeitsweise/CHRONIST-2026-10-29b.md:32`, `Arbeitsweise/gemergt-heisst-nicht-auf-main.md:29`, `Intern/LEKTORAT.md:1880`, `tools/TESTLAEUFE.md:33`, `:77`. Die übrigen stehen in Befunde/LEKTOR-6, -10, -11, -27, -46, -79 und [PRUEFER-6](PRUEFER-6.md#pruefer-6), -42.
* **Freigabepfad der VM** in Nachricht oder Diff: 8 Commits, **61 Stellen in 24 Dateien**. Darunter `Arbeitsweise/CHRONIST-2026-11-02.md:3`, `:25`, `:33`, `:37`, `:57`, `Arbeitsweise/README.md:73`, `Arbeitsweise/gedaechtnis-ist-oeffentlich.md:82`, `:92`, `Arbeitsweise/kein-squash-im-repo.md:13`, `:26`, `Arbeitsweise/nur-testplan-zaehlt.md:46`, `Intern/LEKTORAT.md:2407`, `:3025`, `:3029`, `:3035`, `:3041`, `:3046`.
* Nur Pfade in Gregors Testverzeichnisse: 75 weitere Kennungen. Gering, siehe [L-158.8](#l-158.8).

Dazu beschreibt `Arbeitsweise/gedaechtnis-ist-oeffentlich.md:22-23` selbst einen Pfad in Gregors Testverzeichnis mit Mailverzeichnis und sagt, was darin lag. Das widerspricht der eigenen Regel in `:113` und in `Arbeitsweise/pruefstand-nur-mit-marke.md:17`.

Der Satz in `gedaechtnis-ist-oeffentlich.md:126`, *„Über die Kennung liefert GitHub den alten Commit samt Namen“*, gilt hier noch stärker: Diese Commits liegen in `main` selbst, nicht nur hinter einer Kennung.

**Vorschlag:** In den Lehren und Berichten die Kennungen durch „Commit vom <Datum>“ ersetzen und `:22-23` auf „Gregors Testverzeichnis“ ohne Pfad und ohne Inhalt stellen. Das macht den Inhalt schwerer auffindbar, beseitigt ihn aber nicht. Beseitigen kann ihn nur ein Umschreiben der Geschichte von `main` ([Was nur Gregor entscheiden kann](#gregor)).

### <a id="l-158.6"></a>L-158.6 — Eine IP-Adresse aus einem Einwahlnetz im Selbsttest der Anonym-Schranke

**Gewicht: gering, Vermutung.** `tools/pruefe-testdaten-anonym.pl:171` nimmt als Beispiel für eine „echte IP-Adresse“ eine Adresse aus dem Bereich eines deutschen Einwahlanbieters. Sie ist seit dem 18.09. im Repo und kommt in keiner anderen Datei und keinem anderen Commit vor (gemessen mit `git log --all -S`). Ob sie aus einem echten Kopf von Gregor stammt, ist eine Vermutung. Gemessen ist das nicht.

**Vorschlag:** durch eine erkennbar erfundene öffentliche Adresse ersetzen. Der Test braucht nur eine Adresse außerhalb von RFC 5737.

### <a id="l-158.7"></a>L-158.7 — Testdaten verraten Gerät und Dienste

**Gewicht: gering.** Die drei weitergeleiteten Mails `Testdaten/e103-…eml`, `e106-…eml` und `e108-…eml` sind anonymisiert: Adressen auf `.invalid`, Kennungen genullt, Titel neutralisiert. Die Prüfschranke ist grün. Die Anbieter-Kopfzeilen tragen aber weiter den Namen von Gregors Mailanbieter (Zeilen 6, 12, 21/22, 34–40). `e108` zeigt dazu im Trenner `:34` das Mailprogramm seines Telefons und beim Absender einen Marktplatz. `Testdaten/README.md:34` wiederholt den Trenner. Der Anbieter fällt unter die Entscheidung „nur ab jetzt“, Gerät und Marktplatz nicht.

**Vorschlag:** den Trenner in `e108` und im README neutral setzen. Vorher prüfen, ob [E-108](../Intern/BEFUNDE.md#e-108) (Absturz und versteckter Vorschautext) am Trenner hängt.

### <a id="l-158.8"></a>L-158.8 — Pfade in Gregors Testverzeichnisse: rund 290 Zeilen, drei nach dem 03.11.

**Gewicht: gering.** `%USERPROFILE%\Eudora72-<Fassung>-…` und ähnliche Pfade stehen in etwa 290 Zeilen. Am meisten in `Releases/PAKETE.md` (rund 80), `Intern/TESTPLAN.md`, `Befunde/LEKTOR-*`, `Arbeitsweise/`, aber auch in `Eudora71/Tests/TestE132.cpp:33`, `:55`, `:65`, `:178`, `:181`, `Eudora71/Eudora/eudora.cpp:3931`, `Eudora71/Eudora/msgutils.cpp:3151` und in `tools/*.ps1`. Das Namensmuster selbst steht in `CLAUDE.md` §4. Nach der Regel vom 03.11. sind drei dazugekommen: `Arbeitsweise/stand-03-11-2026-abend.md:15`, `Befunde/PRUEFER-91.md:54`, `Releases/PAKETE.md:268`.

**Vorschlag:** Die drei neuen Stellen auf „neben Gregors letzter Fassung“ stellen. Für den Altbestand fehlt eine Entscheidung ([Was nur Gregor entscheiden kann](#gregor)).

### <a id="l-158.9"></a>L-158.9 — E-246 und die Entscheidungsnotiz widersprechen dem, was geschehen ist

**Gewicht: gering.** [E-246](../Intern/BEFUNDE.md#e-246) (`Intern/BEFUNDE.md:403`) sagt *„Die Kennung steht an fünf Stellen im Repo und in drei Commit-Nachrichten. **Was noch fehlt:** Gregors Entscheidung, ob er beim GitHub-Support die Entfernung beantragt …; dann die Kennung aus dem Repo nehmen.“* Die Entscheidung ist gefallen: `Arbeitsweise/entscheidung-e246-stehen-lassen-06-11.md:13` *„nein, so stehen lassen.“* Danach hat 3bc521c2 die Kennung trotzdem *„aus sechs Dateien entfernt (Gregor: …“* (Commit-Nachricht). Die Notiz sagt aber weiter in `:17` *„die Kennung in Werkzeugen/Lehren stehen lassen“*. Gemessen ist, dass im Baum keine Fundstelle mehr steht ([Urteil](#lektor-158)). Die drei Commit-Nachrichten gehören zum umgeschriebenen Zweig, auf `main` stehen sie nicht (gemessen).

**Vorschlag:** In [E-246](../Intern/BEFUNDE.md#e-246) „Was noch fehlt“ durch die Entscheidung ersetzen (keine Support-Anfrage, Kennung aus dem Repo entfernt am 06.11.). Die Stufe neu setzen. Den How-to-apply-Satz der Notiz an Gregors spätere Anweisung angleichen.

### <a id="l-158.10"></a>L-158.10 — WEITERMACHEN wartet auf einen Merge, der geschehen ist

**Gewicht: gering.** `Intern/WEITERMACHEN.md:11` *„**Wartet auf Merge:** `e151_pruefstand_klon`“*. #229 ist gemergt (`037c361c`, gemessen).

**Vorschlag:** mit dem nächsten Commit auf `main` nachziehen.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

1. **Geschichte von `main` umschreiben?** Familiennamen, Absender, Betreffzeilen, der Name einer Sicherung und der Freigabepfad der VM liegen weiter in Commits auf `main` ([L-158.5](#l-158.5)). Dazu kommen drei Commit-Nachrichten mit dem Austauschordner ([L-158.2](#l-158.2)). Das Entfernen von Kennungen macht die Daten nur schwerer auffindbar. Das Umschreiben ändert jede Kennung ab dem ältesten betroffenen Commit (Oktober), also auch alle Verweise in Berichten, Marken und Release-Tags. Und GitHub liefert alte Commits über ihre Kennung weiter aus, bis der Support sie entfernt ([E-246](../Intern/BEFUNDE.md#e-246)).
2. **Alte Pfade in Gregors Testverzeichnisse (rund 290 Zeilen, [L-158.8](#l-158.8)):** stehen lassen wie beim Mailanbieter (*„nur ab jetzt“*) oder bereinigen?
