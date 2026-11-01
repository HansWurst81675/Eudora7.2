# <a id="pruefer-79"></a>PRUEFER-79 - Kurzlauf vor dem PR: Einarbeitung von PRUEFER-78 (Commit c0f70c11)

## Ergebnis vorweg

Die Einarbeitung von [PRUEFER-78](PRUEFER-78.md#pruefer-78) ist in der Sache richtig. Der Mengenleser für die neuen Nummern beim Verschieben nimmt jetzt genau bis 4294967295 an und weist alles darüber ab, auch als Ende eines Bereichs; eine Gegenprobe ohne die neue Abfrage macht die Testsuite rot. Die Prüfstandsmessung für mehrere Mails ist jetzt trennscharf: Sie verlangt im Ergebnis, dass Eudora absteigend angefragt und der Server Bereiche gemeldet hat, und die gemeldete rote Messung (eine richtig, zwei falsch) ist genau das, was die alte Zuordnung nach Listenposition liefert. Neu ist ein Fehlalarm im Haken gegen Eudora-Starts: `tasklist | grep -c 'Eudora.exe'` und jedes `grep -c "Eudora.exe"` werden abgewiesen, weil der Haken alles hinter `-c` als Shell-Befehl liest (K1, gemessen). In der Buchführung nennt [E-192](../Intern/BEFUNDE.md#e-192) für den Papierkorb die falsche Funktion (K3). Kein Fund hält das Paket auf. Testsuite: 357/357 (gemessen). Die Kennungen E-194 und E-195 sind nicht verbraucht.

## Geprüft

Umfang nach Auftrag nur Commit c0f70c11 (`git log 1f15e74d..HEAD -- Eudora71 tools Releases/1.0` enthält daneben nur die Merges 443031f5/83908112 der Rollenzweige). Inhaltlich geprüft: `Eudora71/Imapdll/src/UidMenge.h`, `Eudora71/Tests/TestE184.cpp`, `tools/imap-pruefserver.pl`, `tools/messen-e184.ps1`, `tools/pruefstand-faelle.txt`, `tools/haken-eudora-start.pl`, `tools/auftrag-rolle.pl`, die Einträge [E-184](../Intern/BEFUNDE.md#e-184)/[E-192](../Intern/BEFUNDE.md#e-192)/[E-193](../Intern/BEFUNDE.md#e-193) in `Intern/BEFUNDE.md`. Nicht inhaltlich geprüft: CHANGELOG.md, WEITERMACHEN.md, pruefstand-buch.tsv/-ergebnis.txt, TESTLAEUFE.md, WERKZEUGE.md.

### 1. Überlaufprüfung im Mengenleser (PRUEFER-78 K3)

- **Grenze stimmt.** Die Abfrage `ulVon > 429496729UL || (ulVon == 429496729UL && Ziffer > '5')` läuft vor `ulVon * 10 + Ziffer` (UidMenge.h:42, für das Bereichsende :55). 429496729·10+5 = 4294967295 = 2^32-1; jede größere Zahl wird abgewiesen, bevor gerechnet wird. `unsigned long` ist unter MSVC 32 Bit. Am Quelltext belegt.
- **Bereiche.** Das Bereichsende hat dieselbe Abfrage. Die Aufzählschleife bricht bei `u == ulBis` ab, bevor `u++` läuft (UidMenge.h:63-67) - ein Bereich bis 4294967295 läuft also nicht über. Am Quelltext belegt.
- **Gegenprobe (gemessen).** Beide Abfragen vorübergehend entfernt, `touch`, Testsuite: 356/357, rot mit `"4294967297" muss abgewiesen werden` und `"1:4294967297" muss abgewiesen werden`. Danach byte-genau zurück (`cmp` gleich, `git status` leer) und `touch`. Die Tests treffen den Fehler.
- Der neue Fall `"4294967296"` ist ohne die Abfrage nicht rot: er läuft auf 0 über, und 0 wird schon vorher abgewiesen (UidMenge.h:47). Kein Beleg für die Abfrage (K4). Einen grünen Fall für einen Bereich an der Obergrenze (`"4294967294:4294967295"`) gibt es nicht; nach dem Quelltext würde er richtig gelesen (Vermutung).

### 2. Prüfserver mit Bereichen und Ergebnis der Messung (PRUEFER-78 K7)

- Der Prüfserver fasst aufeinanderfolgende UIDs zu Bereichen zusammen (imap-pruefserver.pl:537-550); für 1,2,3 kommt `[COPYUID 1 1:3 1:3]`. Am Skript belegt.
- `messen-e184.ps1` schreibt `anfrage=` (erste `UID COPY`-Zeile im Serverprotokoll) und `copyuid=` ins Ergebnis (messen-e184.ps1:399-407); der Prüfstandsfall verlangt `anfrage=3,2,1 copyuid=1:3/1:3` (pruefstand-faelle.txt:263), verglichen als Teilstring (pruefstand-lauf.ps1:363). Fragt Eudora aufsteigend an oder meldet der Server Listen, ist der Fall rot. Am Skript belegt.
- **Trennscharf - nachgerechnet.** Anfrage 3,2,1, Antwort 1:3 / 1:3. Die alte Zuordnung nach Listenposition gibt UID 3 die neue 1, UID 2 die 2, UID 1 die 3: eine richtig, zwei falsch - genau die gemeldete rote Messung am Bau 6e9a43ba. Die neue Zuordnung sucht jede alte UID in `1:3` und nimmt die neue an derselben Stelle: drei richtig. Rot und Grün unterscheiden sich gerade an der Zuordnung, nicht am Leser. Am Quelltext und Skript belegt; die Messungen selbst nicht nachgefahren (Prüfstand nach Auftrag nicht angefasst).

### 3. Haken gegen Eudora-Starts (PRUEFER-78 K5)

- Selbsttest: 39/39 (gemessen), die 14 Gegenproben aus [PRUEFER-78](PRUEFER-78.md#pruefer-78) sind darin.
- 14 neue Gegenproben über die Hakenschnittstelle (JSON auf stdin, Rückgabe 2 = abgewiesen), gemessen:

| Befehl | soll | ist |
|---|---|---|
| `grep -c "Eudora.exe" tools/TESTLAEUFE.md` | durch | **abgewiesen** |
| `tasklist \| grep -c 'Eudora.exe'` | durch | **abgewiesen** |
| `sed -i -c "Eudora.exe" x` | durch | **abgewiesen** |
| `Select-String … -c "Eudora.exe"` | durch | **abgewiesen** |
| `sleep 1 & /c/Temp/E184/Eudora.exe` | abweisen | **durch** |
| `env /c/Temp/E184/Eudora.exe` | abweisen | **durch** |
| `xargs -I{} /c/Temp/E184/Eudora.exe` | abweisen | **durch** |
| `wsl.exe -e /mnt/c/Temp/E184/Eudora.exe` | abweisen | **durch** |
| `/c/Temp/E184/Eudora` (ohne .exe) | abweisen | **durch** |
| `pwsh -EncodedCommand …` | abweisen | durch (nicht erkennbar, kein Fund) |
| `powershell -c "& '…\Eudora.exe'"` | abweisen | abgewiesen |
| `$e='…\Eudora.exe'; Start-Process $e` | abweisen | abgewiesen |
| `start C:\Temp\E184\Eudora.exe` | abweisen | abgewiesen |
| `cmd.exe /c start "" "…\Eudora.exe"` | abweisen | abgewiesen |

- Ursache des Fehlalarms (K1): die neue Schleife `(?:-c|-Command|eval)\s+'…'|"…"` (haken-eudora-start.pl:69) nimmt **jeden** Schalter `-c` vor einer Zeichenkette als `bash -c`, gleich welcher Befehl davor steht. Aus `grep -c "Eudora.exe"` wird der Innentext `Eudora.exe`, dessen erstes Wort auf Eudora.exe endet. Am Quelltext belegt, gemessen. `tasklist | grep -c 'Eudora.exe'` ist die naheliegende Frage „läuft Eudora noch?".
- Die Lücken (K2) sind Formen, die im Alltag kaum vorkommen; ein einzelnes `&` als Trenner in Bash ist die nächstliegende.

### 4. auftrag-rolle.pl (PRUEFER-78 K6)

Die Zweignamen werden jetzt beschnitten (auftrag-rolle.pl:73). Gemessen: über alle 27 Zweige `origin/wt/*` liefert `git grep -h -o -E "E-[0-9]+" <zweig> -- Befunde/` 27-mal ohne `fatal`. Die verbliebene Zeile `$z =~ s/^\s+//` (:75) ist jetzt überflüssig, schadet nicht. Behoben.

### 5. E-192 und E-193 in Intern/BEFUNDE.md

- **[E-192](../Intern/BEFUNDE.md#e-192)** gibt [PRUEFER-78](PRUEFER-78.md#pruefer-78) K1 richtig wieder: drei Aufrufer ohne Quellmenge, Original, auf dem Server geht nichts verloren, Stufe wichtig. Aber der Papierkorb-Aufrufer heißt nicht `CTocDoc::ImapDoPostExpunge`, sondern `CTocDoc::ImapMoveMsgsToTrash` (ImapToc.cpp:2730, Aufruf :2828); `ImapDoPostExpunge` ruft `ImapTransferSummaryData` nicht (grep). Junk (`ImapChangeMsgsJunkStatus`, ImapToc.cpp:3096/3134) und Filter (ImapFiltersd.cpp:1304) stimmen. Am Quelltext belegt (K3).
- **[E-193](../Intern/BEFUNDE.md#e-193)** ist sauber als Beobachtung gekennzeichnet („am Prüfstand nie gemessen", beide Ursachen als Vermutung). Die bestehenden Einträge zur Suche ([E-14](../Intern/BEFUNDE.md#e-14), [E-115](../Intern/BEFUNDE.md#e-115), [E-171](../Intern/BEFUNDE.md#e-171)) betreffen andere Fehler; ein Doppel ist es nicht. Nicht erwähnt ist [E-179](../Intern/BEFUNDE.md#e-179) (HTML-Zeichenangaben verlieren das obere Byte) als möglicher Grund, wenn „€" nur als `&#8364;` im HTML steht - Vermutung, als Hinweis für das Nachstellen.

## Funde

**K1 - Haken weist harmlose `grep -c "Eudora.exe"` ab.** Gemessen (Abschnitt 3). Folge: Fehlalarm bei der Prozessprüfung `tasklist | grep -c 'Eudora.exe'`. Vorschlag: `-c` nur hinter `bash`/`sh`/`wsl`/`powershell`/`pwsh` als Befehlswort auswerten, `-Command` nur hinter `powershell`/`pwsh`; die vier Fälle in den Selbsttest. Schwere: mittel (Werkzeug).

**K2 - Haken lässt seltene Startformen durch:** `a & Eudora.exe` (einzelnes `&` trennt in `abschnitte` nicht), `env`, `xargs`, `wsl -e`, Pfad ohne `.exe`. Gemessen. Schwere: klein.

**K3 - [E-192](../Intern/BEFUNDE.md#e-192) nennt für den Papierkorb die falsche Funktion** (`ImapDoPostExpunge` statt `ImapMoveMsgsToTrash`, ImapToc.cpp:2730/2828). Am Quelltext belegt. Schwere: klein (Buchführung).

**K4 - Testfall `"4294967296"` belegt die Überlaufprüfung nicht** (wird auch ohne sie über die 0 abgewiesen, Gegenprobe gemessen); ein grüner Bereich an der Obergrenze fehlt. Schwere: klein.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Haken weist `grep -c "Eudora.exe"` / `tasklist \| grep -c 'Eudora.exe'` ab | mittel (Werkzeug) | nein |
| K2 | Haken lässt `a & Eudora.exe`, `env`, `xargs`, `wsl -e`, Pfad ohne .exe durch | klein | nein |
| K3 | [E-192](../Intern/BEFUNDE.md#e-192) nennt `ImapDoPostExpunge` statt `ImapMoveMsgsToTrash` | klein | nein |
| K4 | Testfall 4294967296 ohne Beweiskraft, kein grüner Bereich an der Obergrenze | klein | nein |
