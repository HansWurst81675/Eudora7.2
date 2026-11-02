# <a id="lektor-128"></a>LEKTOR-128 — Bestand vor dem Release 7.2.1.131, Zweig paket_7_2_1_131 nach eb6f01e1 (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-127](LEKTOR-127.md#lektor-127).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102g`, abgezweigt von `origin/paket_7_2_1_131`, Stand `eb6f01e1` (*„main (#203) uebernommen; Gregors Test an 7.2.1.131: alle sieben Schritte bestanden“*).
Umfang: alle `.md` aus `git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/` gegen den Bestand. Seit `0a15fc62` (Merge von #203) zehn Commits (`git log 0a15fc62..HEAD`, gemessen): Nummer 7.2.1.131, Release-Notizen als Entwurf, Prüfstandslauf und Prüfbericht, Schnüren, Übernahme von `main` mit Gregors Testergebnis. Schwerpunkt nach Auftrag: ob 7.2.1.131 so veröffentlicht werden kann — CHANGELOG, Release-Notizen, PRUEFBERICHT, PAKETE, README *Bekannte Fehler*, ZIEL.md 7.2.2, TESTPLAN `#test-7-2-1-131`; dazu persönliche Angaben seit `0a15fc62`. Nichts gebaut, nichts gestartet.

## Kurz

Das Programm ist geprüft: Prüfbericht BESTANDEN (362 Unit-Tests, 19 Schranken, 53 Prüfstandsfälle), Gregors Test an seinem System mit allen sieben Schritten bestanden und im TESTPLAN mit Belegen aus seiner `eudora.log` eingetragen (gemessen). **Die Doku ist es noch nicht.** Die Release-Notizen verweisen für [E-199](../Intern/BEFUNDE.md#e-199) (*Festbreite* schreibt Zeichenmüll in den Text) und [E-193](../Intern/BEFUNDE.md#e-193) (Suche mit Umlauten widersprüchlich) auf die README — dort stehen beide nicht, und mit ihnen fehlen sechs weitere offene Programmfehler; nach ZIEL.md Punkt 1 muss, was die README nicht nennt, gehen ([L-128.1](#l-128.1)). Beim Übernehmen von `main` hat der Merge `eb6f01e1` die Berichtigung der Stand-Köpfe aus #203 überschrieben: „`e122_imap_datum`, PR folgt“ steht wieder da, zum fünften Mal, und käme mit dem Merge des Pakets auch auf `main` zurück ([L-128.2](#l-128.2)). Der Kopf „Entwurf — nicht veröffentlicht“ der Release-Notizen ginge unverändert auf GitHub, weil `release-veroeffentlichen.ps1` die Datei 1:1 übergibt ([L-128.3](#l-128.3)). Persönliche Angaben stehen in keiner Datei des heutigen Stands mehr, aber in drei Commits dieses Zweigs, der schon auf GitHub liegt ([L-128.9](#l-128.9)). Neun Funde, keiner am Programm. Nach Auftrag ist nichts berichtigt.

## Funde aus LEKTOR-127

Nach dem [Nachtrag](LEKTOR-127.md#nachtrag-02-11-2026) waren sieben von acht erledigt. Heute, am Stand `eb6f01e1`, der `main` mit #203 enthält (gemessen):

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-127.1](LEKTOR-127.md#l-127.1) Klickweg Nr. 9 (Strg+J bei *Junk*) | erledigt | `Doku/FUNKTIONEN.md:986` *„*Use Ctrl-J for Junk* an- und wieder abhaken …“* mit *Message → Junk* |
| [L-127.2](LEKTOR-127.md#l-127.2) Tastaturlayout | erledigt | `Doku/FUNKTIONEN.md:422` *„**Tastaturlayout.** Die Tastentabelle nennt virtuelle Tastencodes …“* |
| [L-127.3](LEKTOR-127.md#l-127.3) Stand-Köpfe „PR folgt“ | **wieder offen** | auf diesem Zweig durch den Merge `eb6f01e1` zurückgefallen, siehe [L-128.2](#l-128.2); Schranke weiter keine (`grep -n 'PR folgt' tools/*.pl`: kein Treffer) |
| [L-127.4](LEKTOR-127.md#l-127.4) *Insert System Configuration* | erledigt | `Doku/FUNKTIONEN.md:265` *„**und hängt eine Kopie der `Eudora.ini` an**“* |
| [L-127.5](LEKTOR-127.md#l-127.5) Bezugsfassung | erledigt für 7.2.1.130, **wieder veraltet** | `Doku/FUNKTIONEN.md:18` *„**Stand:** Quellstand nach dem Testpaket 7.2.1.130 (02.11.2026)“*, `:194` *„bis 7.2.1.130 je Nachricht; im Quellstand …“* — siehe [L-128.6](#l-128.6) |
| [L-127.6](LEKTOR-127.md#l-127.6) drei „unklar“ | erledigt | `Doku/FUNKTIONEN.md:416` (Strg+Leertaste, `PaigeEdtView.cpp`), `:680` (`FixedDateFormat`-Platzhalter) |
| [L-127.7](LEKTOR-127.md#l-127.7) enge Belege, Anker | erledigt | `Doku/FUNKTIONEN.md:354` Strg+W, `:944` `LogLevel`; 5 Verweise auf `TESTPLAN.md#e-143-naechstes` (`grep -c`) |
| [L-127.8](LEKTOR-127.md#l-127.8) Kleinkram | erledigt bis auf README | `Intern/EINSTELLUNGEN.md:159` *„`EudoraRes.rc:8465`“*, `:166` *„`filtersd.cpp:1155`“*; `tools/funktionen-auslesen.pl:10` nennt `--kuerzel`; `README.md:98` weiter *„(206 LEKTOR- und PRÜFER-Berichte)“*, gezählt 208, mit diesem Bericht 209 — bewusst stehen gelassen |

Aus älteren Berichten, unverändert: [L-126.1](LEKTOR-126.md#l-126.1) (`Intern/TESTPLAN.md:409` *„deren Uhrzeit du kennst (Spalte“* — der Schritt ist jetzt freiwillig) und [L-126.5](LEKTOR-126.md#l-126.5) (`tools/TESTLAEUFE.md`: 47 Starts am 02.11., davon dieselben 10 ohne Titelzeile wie gestern; alle Starts des vollen Laufs 13:37–13:54 tragen sie).

## Funde

### <a id="l-128.1"></a>L-128.1 — README *Bekannte Fehler*: acht offene Programmfehler fehlen, darunter die zwei, für die die Release-Notizen ausdrücklich auf die README verweisen

**Gewicht: hoch.** ZIEL.md macht die README zum Maßstab des Releases: *„**Weitergabe ohne Einschränkung** — außer den Punkten, die die [README](README.md) ausdrücklich nennt. Was dort nicht steht, muss gehen.“* (`ZIEL.md:27-28`). Ein Anwender, der den Notizen folgt, findet die angekündigten Einträge nicht. `perl tools/ziel-stand.pl` meldet trotzdem *„27 von 27 erfüllt“* — es prüft das nicht. (gemessen)

- `Releases/7.2.1.131/RELEASE-NOTIZEN.md:74-79` *„Was noch nicht geht, steht in der [README unter „Bekannte Fehler“] …, darunter: *Festbreite* im Bearbeiten-Modus schreibt `t;` sichtbar in den Text ([[E-199](../Intern/BEFUNDE.md#e-199)] …), und die Suche mit Umlauten oder `€` liefert widersprüchliche Ergebnisse ([[E-193](../Intern/BEFUNDE.md#e-193)] …)“*.
- `grep -n 'E-199\|E-193\|E-198\|E-188\|E-192' README.md Doku/*.md`: **kein Treffer**.
- Abgleich der 52 Kennungen im erzeugten Block *Noch offen* (`CHANGELOG.md`, zwischen den Marken `offene-befunde: Anfang/Ende`) gegen die Tabelle `README.md:149-199`. Ohne Eintrag und am Programm spürbar (Status aus `Intern/BEFUNDE.md`, jeweils *„offen“*):
  - [E-199](../Intern/BEFUNDE.md#e-199) (*Festbreite* schreibt `t;` in den Text, *Strg-S* speichert ihn mit) — `BEFUNDE.md:399`;
  - [E-193](../Intern/BEFUNDE.md#e-193) (Suche mit Umlauten oder € widersprüchlich) — `:404`;
  - [E-192](../Intern/BEFUNDE.md#e-192) (Papierkorb, Junk und Filter ordnen beim Verschieben **mehrerer** IMAP-Mails die neuen Nummern nach Listenposition zu) — `:405`;
  - [E-188](../Intern/BEFUNDE.md#e-188) (dieselbe Verwechslung wie [E-184](../Intern/BEFUNDE.md#e-184) zwischen zwei IMAP-Konten und von IMAP nach lokal) — `:407`;
  - [E-198](../Intern/BEFUNDE.md#e-198) (gespeicherte oder übergebene mehrteilige Nachricht bekommt einen falschen Zeichensatz) — `:400`;
  - [E-194](../Intern/BEFUNDE.md#e-194), [E-195](../Intern/BEFUNDE.md#e-195), [E-196](../Intern/BEFUNDE.md#e-196) (`<x-flowed>` in der gespeicherten Datei; `.rtf` ist Klartext; `.htm` ohne Zeichensatz).
  - Ohne Eintrag, aber kein Anwenderthema: [E-176](../Intern/BEFUNDE.md#e-176) (im Quellstand berichtigt), [E-159](../Intern/BEFUNDE.md#e-159) (Absturz am Prüfstand, ungeklärt), [E-78](../Intern/BEFUNDE.md#e-78) (Leistenanordnung), Werkzeug- und Wunschbefunde ([E-91](../Intern/BEFUNDE.md#e-91), [E-92](../Intern/BEFUNDE.md#e-92), [E-147](../Intern/BEFUNDE.md#e-147), [E-109](../Intern/BEFUNDE.md#e-109), [E-151](../Intern/BEFUNDE.md#e-151), [E-157](../Intern/BEFUNDE.md#e-157)).
- Dazu ist die Zusage in den Notizen breiter als die Behebung: `RELEASE-NOTIZEN.md:39-46` *„Beim Verschieben innerhalb eines IMAP-Kontos … und Eudora überschreibt im Zielordner nicht mehr Betreff und Absender einer fremden Mail“*. Für **mehrere** Mails in den Papierkorb, nach Junk oder per Filter — ebenfalls innerhalb eines Kontos — gilt das nach [E-192](../Intern/BEFUNDE.md#e-192) nicht (am Quelltext belegt, [PRÜFER-78](PRUEFER-78.md) K1).

**Vorschlag:** [E-199](../Intern/BEFUNDE.md#e-199), [E-193](../Intern/BEFUNDE.md#e-193), [E-192](../Intern/BEFUNDE.md#e-192), [E-188](../Intern/BEFUNDE.md#e-188) und [E-198](../Intern/BEFUNDE.md#e-198) als Zeilen in *Bekannte Fehler* (mit *Was hilft*, etwa „*Festbreite* in empfangenen Nachrichten nicht benutzen“, „bei Umlauten im geöffneten Fenster mit Strg+Umschalt+F nachsuchen“, „mehrere IMAP-Mails einzeln in den Papierkorb legen“); [E-194](../Intern/BEFUNDE.md#e-194) bis [E-196](../Intern/BEFUNDE.md#e-196) in einer Sammelzeile *Speichern unter*. In den Notizen die E-184-Zusage auf „eine fremde Mail mit derselben Nummer im Zielordner“ beschränken und [E-192](../Intern/BEFUNDE.md#e-192) in *Bekannte Fehler* nennen. Als Schranke: `ziel-stand.pl` (oder eine eigene) gleicht die offenen Programmbefunde gegen die README-Tabelle ab, mit einer Ausnahmeliste für Werkzeug- und Wunschbefunde.

### <a id="l-128.2"></a>L-128.2 — Der Merge `eb6f01e1` hat die Stand-Köpfe aus #203 überschrieben: „`e122_imap_datum`, PR folgt“ zum fünften Mal

**Gewicht: mittel.** Wie [L-124.2](LEKTOR-124.md#l-124.2), [L-125.5](LEKTOR-125.md#l-125.5), [L-126.2](LEKTOR-126.md#l-126.2), [L-127.3](LEKTOR-127.md#l-127.3) — diesmal nicht vergessen, sondern beim Übernehmen von `main` verloren. Geht der Zweig so nach `main`, ersetzt er dort die richtigen Köpfe durch die alten. (gemessen)

- `git diff --stat eb6f01e1^1 eb6f01e1` nennt 8 Dateien — `Intern/WEITERMACHEN.md` und `Intern/AUFGABEN.md` nicht, obwohl #203 beide geändert hat (`git diff --stat d5ecca2f 0a15fc62`: *„Intern/AUFGABEN.md | 2 +-“*, *„Intern/WEITERMACHEN.md | 2 +-“*). Der Merge hat also die Fassung des Paketzweigs genommen.
- `0a15fc62:Intern/WEITERMACHEN.md:3` *„**Stand 02.11.2026 abends.** Laufend: Zweige `was_eudora_alles_kann` …, `paket_7_2_1_131` und `hilfe_menue`. #200 …, #201 … und #202 (`e122_imap_datum`) sind gemergt.“*
- Heute `Intern/WEITERMACHEN.md:3` *„… Zweig `e122_imap_datum`, PR folgt: [[E-122](../Intern/BEFUNDE.md#e-122)] behoben …“* und weiter hinten *„Zweig `e122_imap_datum` in Arbeit: [[E-122](../Intern/BEFUNDE.md#e-122)] …“*; `Intern/AUFGABEN.md:8` *„danach Zweig `e122_imap_datum` ([[E-122](../Intern/BEFUNDE.md#e-122)] behoben und gemessen, PR folgt) … Zweig `e122_imap_datum` in Arbeit“*.
- Verloren mit ihm: der Hinweis auf die laufenden Zweige `was_eudora_alles_kann` (inzwischen #203) und `hilfe_menue` (auf `origin`, 11 Commits vor `main`; eingetragen in `tools/ZWEIGE.md` nur auf dem eigenen Zweig, `origin/hilfe_menue:tools/ZWEIGE.md:211`).
- `WEITERMACHEN.md:3` sagt außerdem *„veröffentlicht erst nach Gregors lokalem Test … und seinem Ja“* — der Test ist bestanden ([L-128.5](#l-128.5)).

**Vorschlag:** Beide Köpfe aus `0a15fc62` übernehmen und um 7.2.1.131 (geschnürt, von Gregor bestanden, wartet auf sein Ja) ergänzen. Die Schranke aus [L-126.2](LEKTOR-126.md#l-126.2) fehlt weiter; beim fünften Auftreten nach [Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md) überfällig. Sie hätte auch diesen Fall gefangen: ein Zweigname mit „PR folgt“, der in `git log origin/main --merges` steht.

### <a id="l-128.3"></a>L-128.3 — Der Kopf „Entwurf … nicht veröffentlicht“ ginge mit auf GitHub

**Gewicht: mittel.** (gemessen am Werkzeug)

- `Releases/7.2.1.131/RELEASE-NOTIZEN.md:1-2` *„**Entwurf vom 02.11.2026 — nicht veröffentlicht.** Veröffentlicht wird erst nach Gregors lokalem Test an 7.2.1.131 und seinem Ja.“*
- `tools/release-veroeffentlichen.ps1:261` *„`if ($Notizen -ne '' -and (Test-Path $Notizen)) { $argumente += @('--notes-file', $Notizen) }`“* — die Datei geht unverändert an `gh release create`.
- Kein Werkzeug liest `RELEASE-NOTIZEN` (`grep -l -i 'RELEASE-NOTIZEN' tools/*.pl tools/*.ps1`: kein Treffer); `Releases/7.2.1.128/RELEASE-NOTIZEN.md:1` beginnt ohne solchen Kopf.

**Vorschlag:** Den Kopf vor dem Veröffentlichen entfernen, und `release-veroeffentlichen.ps1` weist eine Notizdatei ab, deren erste Zeilen „Entwurf“ oder „nicht veröffentlicht“ enthalten.

### <a id="l-128.4"></a>L-128.4 — Release-Notizen: zwei Behebungen fehlen, drei Zusagen ohne den Vorbehalt, den README und TESTPLAN machen

**Gewicht: mittel.** Die Notizen setzen den Vorbehalt *„am laufenden Programm noch nicht gemessen“* bei [E-179](../Intern/BEFUNDE.md#e-179) und [E-170](../Intern/BEFUNDE.md#e-170) (`RELEASE-NOTIZEN.md:24`, `:40-41`), bei drei gleich gelagerten nicht. (gemessen)

- **[E-72](../Intern/BEFUNDE.md#e-72)** (verneinte Filterbedingung traf jede Nachricht) — `RELEASE-NOTIZEN.md:26-28` *„trifft nur noch die richtigen Nachrichten“*. `Intern/TESTPLAN.md:107-108` *„Am Quelltext und im Regressionstest `TestE72.cpp` gesichert; am Programm habe ich es nicht gefahren.“*
- **[E-143](../Intern/BEFUNDE.md#e-143)**, alte Filter mit Ziel Out — `RELEASE-NOTIZEN.md:29-30` *„ein älterer Filter mit diesem Ziel hält den Abruf nicht mehr an“*. `Intern/TESTPLAN.md:384` *„das Übergehen ist am Programm noch nicht gemessen“*, ebenso `README.md:187`.
- **[E-136](../Intern/BEFUNDE.md#e-136)**, *Speichern unter* als `.htm` — `RELEASE-NOTIZEN.md:15-17` *„*Strg+S* und *Speichern unter* als `.htm` schreiben …“*. `README.md:184` *„*Speichern unter* als `.htm` am Programm noch nicht“*.
- **Fehlen ganz:** [E-141](../Intern/BEFUNDE.md#e-141) (IMAP nach Out stieß die Nachbearbeitung bis zum `EXPUNGE` an; `CHANGELOG.md:199`, in der README als bekannter Fehler `:194`) und [E-176](../Intern/BEFUNDE.md#e-176) (Lesen aus freigegebenem Speicher beim Schließen einer verworfenen Nachricht; `CHANGELOG.md:201`). Beide seit 7.2.1.129 im Quellstand, also in diesem Release (`grep -n 'E-141\|E-176' Releases/7.2.1.131/RELEASE-NOTIZEN.md`: kein Treffer).
- `Doku/FUNKTIONEN.md` (#203, „Was Eudora kann und wo man es findet“) kommt in den Notizen nicht vor (`grep -c FUNKTIONEN`: 0). Sie liegt nicht im ZIP (`tools/paket-bauen.ps1`: kein `Nimm` für `Doku\`), wäre aber über GitHub erreichbar.

**Vorschlag:** Bei [E-72](../Intern/BEFUNDE.md#e-72), [E-143](../Intern/BEFUNDE.md#e-143) (alte Filter) und [E-136](../Intern/BEFUNDE.md#e-136) (`.htm`) denselben Vorbehalt wie bei [E-179](../Intern/BEFUNDE.md#e-179); [E-141](../Intern/BEFUNDE.md#e-141) und [E-176](../Intern/BEFUNDE.md#e-176) unter *Kleinere*; ein Satz mit Verweis auf `Doku/FUNKTIONEN.md`.

### <a id="l-128.5"></a>L-128.5 — Gregors Ergebnis an 7.2.1.131 steht nur im TESTPLAN

**Gewicht: mittel.** ZIEL.md Punkt 3 verlangt *„die Ergebnisse von Gregors Test je Kriterium“* im Repo (`ZIEL.md:31-34`) — das ist erfüllt (`Intern/TESTPLAN.md:23-39`, Tabelle mit Beleg je Schritt). Alle anderen Stellen sagen noch, der Test stehe aus. (gemessen)

- `Intern/TESTPLAN.md:1` *„… (zuletzt getestet am 01. und 02.11.2026 das Testpaket 7.2.1.130: …)“*.
- `CHANGELOG.md:116` *„veröffentlicht wird erst nach Gregors lokalem Test und seinem Ja“*.
- `Releases/PAKETE.md:184` *„Gregor testet damit an seinem echten System den kurzen Durchgang …“*; `:6` führt 7.2.1.131 als *„Testpaket vom 02.11.2026, nicht veröffentlicht“* ohne Ergebnis.
- `ZIEL.md:89` *„… [[E-122](../Intern/BEFUNDE.md#e-122)] … (in 7.2.1.131 berichtigt, am Prüfstand gemessen, von Gregor noch nicht bestätigt)“* — für [E-122](../Intern/BEFUNDE.md#e-122) hat Gregor es mit Schritt 6 bestätigt (`TESTPLAN.md:34` *„zweimal `E-122 IMAP-Eingangsdatum aus Date:-Kopf: … uebernommen`“*).
- `Intern/BEFUNDE.md:384` [E-122](../Intern/BEFUNDE.md#e-122) *„**offen — … kommt mit dem Testpaket 7.2.1.131.**“* — der Bestanden-Maßstab des TESTPLAN-Schritts ist erfüllt; ob [E-122](../Intern/BEFUNDE.md#e-122) damit geschlossen wird, ist Buchführung des Hauptagenten. `perl tools/offene-befunde.pl` zählt [E-122](../Intern/BEFUNDE.md#e-122) weiter unter den 52 offenen.
- `WEITERMACHEN.md:3` siehe [L-128.2](#l-128.2).

**Vorschlag:** Überall „von Gregor am 02.11.2026 an seinem System getestet, alle sieben Schritte bestanden ([TESTPLAN](../Intern/TESTPLAN.md#test-7-2-1-131)); wartet auf sein Ja“; [E-122](../Intern/BEFUNDE.md#e-122) nach den Regeln in `BEFUNDE.md` fortschreiben.

### <a id="l-128.6"></a>L-128.6 — CHANGELOG 7.2.1.131 ohne #203; ZIEL.md 7.2.2 nennt `FUNKTIONEN.md` „noch nicht auf `main`“

**Gewicht: mittel.** Der Abschnitt 7.2.1.131 zählt die Zweige auf (`CHANGELOG.md:116` *„Darin die Zweige `e184_imap_zusammenfassung` (#197), … und `e122_imap_datum` (#202)“*); #203 ist seit `eb6f01e1` auch in diesem Zweig. (gemessen)

- `grep -n 'FUNKTIONEN\|#203\|was_eudora' CHANGELOG.md`: kein Treffer. Fehlen damit: `Doku/FUNKTIONEN.md` (993 Zeilen), `tools/funktionen-auslesen.pl`, die berichtigten Zeilenangaben in `Intern/EINSTELLUNGEN.md`; außerdem `44ca6e75` (*„paket-bauen: perl fuer pruefbericht.pl in den Suchpfad“*, `grep -n paket-bauen CHANGELOG.md` trifft nur eine alte Stelle).
- Überschrift `CHANGELOG.md:114` *„## 7.2.1.131 — Testpaket: …“* und `Releases/PAKETE.md:182` *„## 7.2.1.131 — Testpaket“*: nach `ZIEL.md:40` *„Testpakete sind für Gregors lokalen Test, keine Releases“*; 7.2.1.131 soll das Release werden. Beim Veröffentlichen mitzuziehen.
- `ZIEL.md:119-121` *„eine HTML-Seite, erzeugt aus der Funktionsübersicht `FUNKTIONEN.md` (in Arbeit im Zweig `was_eudora_alles_kann`, noch nicht auf `main`)“* — gemergt als #203 (`0a15fc62`); der Pfad heißt `Doku/FUNKTIONEN.md`, ohne Verweis.
- `Doku/FUNKTIONEN.md:18-19` *„Quellstand nach dem Testpaket 7.2.1.130“* und `:194` *„bis 7.2.1.130 je Nachricht; im Quellstand kommt er einmal …“*; `perl tools/doku-pruefen.pl` führt die Datei wieder unter „Zur Kenntnis“ (*„hoechste genannte Fassung: 7.2.1.130“*). Mit dem Release ist „im Quellstand“ dann „ab 7.2.1.131“.

**Vorschlag:** Im CHANGELOG ein Absatz *Zweig `was_eudora_alles_kann` (gemergt als #203)*, dazu `44ca6e75` unter Werkzeuge; die beiden Überschriften beim Veröffentlichen auf „Release“; ZIEL.md:121 auf „gemergt als #203“ mit Verweis; FUNKTIONEN.md auf 7.2.1.131.

### <a id="l-128.7"></a>L-128.7 — Zwei der drei Lücken eines frischen Arbeitsbaums beim Schnüren stehen nur in PAKETE

**Gewicht: Kleinkram.** (gemessen; ob das nächste Paket aus einem frischen Baum die Zusätze still weglässt: Vermutung, nicht nachgesehen)

- `Releases/PAKETE.md:194` *„`Plugins\EudoraUnicodeFix*` und die VC++-Laufzeit (`mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll`) liegen nur im `Bin/Release` des Hauptbaums — von dort bzw. aus dem VS-Redist byte-gleich kopiert; ein relatives `-Zip` landet im Hauptbaum“*. Behoben ist nur die erste Lücke (`44ca6e75`).
- `grep -n -i 'EudoraUnicodeFix\*\|relatives `-Zip`' Intern/WEITERMACHEN.md Intern/BEFUNDE.md tools/WERKZEUGE.md`: kein Treffer — keine Aufgabe, kein Befund. Verwandt: [E-151](../Intern/BEFUNDE.md#e-151) (Prüfstandsfälle aus einem frischen Klon nicht ausführbar).

**Vorschlag:** Eine Zeile in der Liste [Nach dem Release 7.2.1](../Intern/WEITERMACHEN.md#nach-dem-release) oder ein Nachtrag zu [E-151](../Intern/BEFUNDE.md#e-151).

### <a id="l-128.8"></a>L-128.8 — README: drei Zeilen und der Kopf hinken hinter den Paketen her

**Gewicht: Kleinkram.** (gemessen)

- `README.md:156` [E-72](../Intern/BEFUNDE.md#e-72) *„solche Filter bis zum nächsten Paket abschalten …; im Quelltext behoben“* — seit 7.2.1.129 in jedem Paket.
- `README.md:194` [E-141](../Intern/BEFUNDE.md#e-141) *„im Quelltext berichtigt, noch nicht gemessen“* — ebenso seit 7.2.1.129; die übrigen Zeilen nennen die Fassung (*„behoben in 7.2.1.129 (Testpaket)“*, `:191`).
- `README.md:104` *„Stand **7.2.1.128** — erstes Release 7.2.1 …“* — stimmt bis zur Veröffentlichung, ist dann mitzuziehen (mit dem Satz, was 7.2.1.129 bis 7.2.1.131 bringen).
- `README.md:98` „206“, siehe oben.

## <a id="l-128.9"></a>L-128.9 — Persönliche Angaben: im heutigen Stand keine, in drei Commits dieses Zweigs schon

**Gewicht: hoch** (Gregors ausdrücklicher Wunsch, `Arbeitsweise/entscheidung-7-2-2-umfang.md`). Geprüft nach Auftrag: Dateien und Commit-Nachrichten seit `0a15fc62`. Ohne Zitat. (gemessen)

- **Heutiger Stand:** `git grep -n -i` nach den einschlägigen Wörtern über alle `.md` an `HEAD`: kein Treffer. `Arbeitsweise/entscheidung-7-2-2-umfang.md` nennt nur, dass es einen Termin gibt, ohne Datum und Grund.
- **Persönliche Angabe in Commit `9f3feb8f`** — in der Nachricht und in einer dort angelegten Gedächtnisdatei unter `Arbeitsweise/` (schon der Dateiname trägt die Angabe), dazu in `Arbeitsweise/MEMORY.md` und `Arbeitsweise/README.md` dieses Commits; gelöscht in `cb18ca56`.
- **Persönliche Angabe in Commit `a2f29b69`** — in der Nachricht und in `CHANGELOG.md` und `Intern/WEITERMACHEN.md` dieses Commits; entfernt in `22ded470`.
- **Persönliche Angabe in Commit `cb18ca56`** — in der Nachricht und in `Intern/WEITERMACHEN.md` dieses Commits; entfernt in `22ded470`.
- Alle drei liegen schon auf GitHub: `git branch -r --contains` nennt `origin/paket_7_2_1_131` und `origin/wt/lektor-20261102g`; auf `origin/main` keiner. `22ded470` selbst und die übrigen Commits seit `0a15fc62` sind ohne solche Angaben.

**Vorschlag:** Siehe *Was nur Gregor entscheiden kann*. Ein normaler Merge des Paketzweigs trüge die drei Commits nach `main`.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): Quellstand und Paketnummer *„7.2.1.131“*, 52 Dateien, *„Kein Widerspruch gefunden.“* „Zur Kenntnis“: 20 Dateien ohne 7.2.1.131, darunter `Doku/FUNKTIONEN.md` (7.2.1.130, [L-128.6](#l-128.6)), `Doku/FAQ.md` (7.2.1.130), `Doku/ANWENDER.md` und `Intern/PORTIERUNG.md` (7.2.1.128); die übrigen sind Archive und alte Release-Notizen. [L-128.1](#l-128.1) bis [L-128.5](#l-128.5) sieht das Werkzeug nicht.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  52
      davon aktuell gemessen      10  (ab Nummer 126)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          16
    in Intern/WEITERMACHEN.md     52

  52 offene Befunde, in beiden Listen gleich.
```

`perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“* Kritisch *„OHNE jede Pruefung 6 … [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39)“* — die Notizen nennen richtig *„**6 von 70**“* (`RELEASE-NOTIZEN.md:69`). Insgesamt *„behoben und OHNE Testfall 50 <- Rueckstand“*; die Notizen sprechen nur von den kritischen, was nach `ZIEL.md:35-37` genügt.

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* — trotz [L-128.1](#l-128.1).

`perl tools/rollen-faellig.pl` (gemessen): fällig LEKTOR (dieser Lauf), PRÜFER (*„Eudora71/Tests/TestE122.cpp, Eudora71/Version.h“*) und CHRONIST (20 Dateien).

**PRUEFBERICHT** (gemessen): `Releases/PRUEFBERICHT.md:5-8` Quellstand und Paketnummer 7.2.1.131, Commit `f994ca6a` *„(Arbeitsbaum sauber)“*, **BESTANDEN**; `:19` Bau *„`Eudora 7.2.1.131+a2f29b69* 2026-11-02 13:23`“* = Titelzeile in Gregors Test (`TESTPLAN.md:30`) und Bau im Paket (`PAKETE.md:190`). Nach `a2f29b69` hat kein Commit Quelltext geändert (`git log --stat a2f29b69..HEAD`: nur `.md`, `.tsv`, `.txt`, `tools/`), das Sternchen erklärt `PAKETE.md:190`. Die Zahlen 362/19/53 stehen gleich in CHANGELOG, PAKETE, TESTPLAN und WEITERMACHEN.

## Was nur Gregor entscheiden kann

1. **Veröffentlichen von 7.2.1.131** — sein Ja nach dem bestandenen Test, sobald [L-128.1](#l-128.1) bis [L-128.6](#l-128.6) eingearbeitet sind (die Doku-Berichtigung selbst liegt beim Hauptagenten).
2. **Wie der Paketzweig nach `main` kommt** ([L-128.9](#l-128.9)): Mit „Squash and merge“ und anschließendem Löschen der Zweige `paket_7_2_1_131` und `wt/lektor-20261102g` auf GitHub kommen die drei Commits mit persönlichen Angaben nicht nach `main`; ein normaler Merge trägt sie dorthin. Ganz verschwinden sie aus GitHub nur, wenn die Zweige gelöscht werden (zwischengespeicherte Ansichten ausgenommen).

Nicht auf diese Liste gehören: welche Befunde in die README kommen und mit welchem Rat, die Form der Notizen und die Fortschreibung von [E-122](../Intern/BEFUNDE.md#e-122) — das hat Gregor dem Hauptagenten übertragen. Offen und schon in `ZIEL.md:128` als seine Entscheidung vermerkt: [E-128](../Intern/BEFUNDE.md#e-128) für 7.2.2.

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Gegengelesen: `git diff 7f7fc395..origin/paket_7_2_1_131` (10 Dateien, Stand `3d9f603b`, nach `tools/arbeitsbaum-angleichen.sh`). Keine neue Runde. (gemessen)

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-128.1](#l-128.1) README *Bekannte Fehler* | erledigt, **ein neuer Widerspruch** | Neue Zeilen für [E-192](../Intern/BEFUNDE.md#e-192), [E-188](../Intern/BEFUNDE.md#e-188), [E-199](../Intern/BEFUNDE.md#e-199), [E-198](../Intern/BEFUNDE.md#e-198), [E-194](../Intern/BEFUNDE.md#e-194)/[E-195](../Intern/BEFUNDE.md#e-195)/[E-196](../Intern/BEFUNDE.md#e-196) (Sammelzeile) und [E-193](../Intern/BEFUNDE.md#e-193), je mit *Was hilft*; die Notizen beschränken die E-184-Zusage auf *„einer fremden Mail mit derselben Nummer“* und nennen [E-192](../Intern/BEFUNDE.md#e-192). **Aber:** `RELEASE-NOTIZEN.md:104` sagt zu [E-192](../Intern/BEFUNDE.md#e-192) **und** [E-188](../Intern/BEFUNDE.md#e-188) *„auf dem Server geht dabei nichts verloren“*, die README-Zeile zu [E-188](../Intern/BEFUNDE.md#e-188) (`README.md:170`) *„ob auf dem Server etwas verloren gehen kann, ist nicht untersucht“*. Für [E-188](../Intern/BEFUNDE.md#e-188) sagen die Notizen mehr zu, als belegt ist. Eine Schranke, die offene Programmbefunde gegen die README abgleicht, gibt es weiter nicht |
| [L-128.2](#l-128.2) Stand-Köpfe | erledigt, Schranke offen | `Intern/WEITERMACHEN.md:3` *„#199 bis #203 sind gemergt … Laufend: Zweig `paket_7_2_1_131`, wird als `release_7_2_1_131` eingereicht“*; „PR folgt“ in WEITERMACHEN und AUFGABEN: 0 Treffer, „`e122_imap_datum` in Arbeit“: 0. `grep -n 'PR folgt' tools/*.pl`: weiter kein Treffer. `hilfe_menue` steht nicht mehr im Kopf (Zweig läuft weiter auf `origin`) |
| [L-128.3](#l-128.3) Entwurfskopf | erledigt, Schranke offen | Die beiden Kopfzeilen sind entfernt; `release-veroeffentlichen.ps1` prüft die Notizdatei weiter nicht |
| [L-128.4](#l-128.4) Notizen: Lücken und Vorbehalte | erledigt | Vorbehalt bei *Speichern unter* `.htm`, [E-72](../Intern/BEFUNDE.md#e-72) und alten Out-Filtern; [E-141](../Intern/BEFUNDE.md#e-141) und [E-176](../Intern/BEFUNDE.md#e-176) unter *Kleinere* mit Vorbehalt; Satz zu [Doku/FUNKTIONEN.md](../Doku/FUNKTIONEN.md) „im Repository, nicht im Paket“ |
| [L-128.5](#l-128.5) Gregors Ergebnis | erledigt | CHANGELOG, PAKETE (`:6`, `:184`), TESTPLAN-Kopf, WEITERMACHEN und ZIEL.md:89 nennen *„alle sieben Schritte bestanden“*; [E-122](../Intern/BEFUNDE.md#e-122) steht in `BEFUNDE.md` auf *„**behoben in 7.2.1.131, von Gregor am 02.11.2026 an 7.2.1.131 bestätigt.**“* mit Rest K1 (Sommerzeitstunde); Zählung offen 52 → 51 |
| [L-128.6](#l-128.6) CHANGELOG #203, ZIEL, FUNKTIONEN | teilweise | CHANGELOG mit Absatz *„Zweig `was_eudora_alles_kann` (gemergt als #203)“* und `44ca6e75`; ZIEL.md 7.2.2 *„[`Doku/FUNKTIONEN.md`](Doku/FUNKTIONEN.md) (gemergt als #203)“*. **Offen:** `Doku/FUNKTIONEN.md:18` weiter *„Quellstand nach dem Testpaket 7.2.1.130“*, `:194` *„bis 7.2.1.130 je Nachricht; im Quellstand …“*; die Überschriften `CHANGELOG.md:113` und `Releases/PAKETE.md:182` heißen weiter *„Testpaket“* — wie vorgeschlagen beim Veröffentlichen mitzuziehen |
| [L-128.7](#l-128.7) frischer Arbeitsbaum | erledigt | neue Zeile in der Liste *Nach dem Release* (`Intern/WEITERMACHEN.md`) mit Verweis auf PAKETE, [L-128.7](#l-128.7) und [E-151](../Intern/BEFUNDE.md#e-151) |
| [L-128.8](#l-128.8) README-Kleinkram | erledigt | `README.md:98` *„(208 …)“* (mit diesem Bericht 209 — Kleinkram), Kopf *„Stand **7.2.1.131** — zweites Release 7.2.1 … zur Veröffentlichung als `v7.2.1.131` nach seinem Ja“*; [E-72](../Intern/BEFUNDE.md#e-72) und [E-141](../Intern/BEFUNDE.md#e-141) *„behoben ab 7.2.1.129, enthalten im Release 7.2.1.131 … am laufenden Programm nicht gemessen“* |
| [L-128.9](#l-128.9) Geschichte | geregelt | nach Auskunft des Hauptagenten wird der Zweig nicht gemergt, sondern als `release_7_2_1_131` mit einem Commit auf `main` eingereicht (Gregor hat Name und Weg bestätigt). Im Diff `7f7fc395..3d9f603b`: keine persönliche Angabe (gemessen). Die drei Commits bleiben auf `origin/paket_7_2_1_131` und `origin/wt/lektor-20261102g`, bis diese Zweige gelöscht sind |

Nebenbei: `tools/TESTLAEUFE.md` bekommt in diesem Diff einen Start um 14:38:23 in `C:\Temp\EHILFE` am Bau *„Eudora 7.2.1.130+0a4b77a1“* — das ist der Bau des Zweigs `hilfe_menue`, nicht dieses Pakets, mit Gregors Freigabe und Titelzeile. Kein Fund; gehört inhaltlich zum anderen Zweig.

Ergebnis: Sieben der neun Funde sind erledigt, [L-128.6](#l-128.6) teilweise (FUNKTIONEN.md-Bezug und die beiden Überschriften beim Veröffentlichen), [L-128.9](#l-128.9) durch den neuen Weg geregelt. **Neu im Diff:** die Notizen sagen für [E-188](../Intern/BEFUNDE.md#e-188) *„auf dem Server geht dabei nichts verloren“*, die README *„nicht untersucht“* — vor dem Veröffentlichen den Halbsatz auf [E-192](../Intern/BEFUNDE.md#e-192) beschränken. Weiter ohne Schranke: „PR folgt“ nach dem Merge, Entwurfskopf der Notizen, offene Befunde gegen die README. Für Gregor ist nichts Neues zu entscheiden.

**Nachtrag 2 (02.11.2026):** `git diff 1525b290..origin/paket_7_2_1_131` (Stand `cbe9b328`, 2 Dateien) gegengelesen (gemessen). Der Widerspruch aus dem [Nachtrag](#nachtrag-02-11-2026) ist erledigt: die Release-Notizen sagen jetzt *„Beim Papierkorb, Junk und Filtern geht auf dem Server nichts verloren; ob beim Verschieben zwischen zwei Konten etwas verloren gehen kann, ist nicht untersucht“*, gleich wie `README.md:170` zu [E-188](../Intern/BEFUNDE.md#e-188). `tools/ZWEIGE.md` führt `release_7_2_1_131` mit Gregors Bestätigung. Keine persönliche Angabe im Diff, kein neuer Fehler. Offen bleibt nur, was beim Veröffentlichen nachgezogen wird ([L-128.6](#l-128.6): Überschriften „Testpaket“, `Doku/FUNKTIONEN.md` 7.2.1.130), und die drei fehlenden Schranken.
