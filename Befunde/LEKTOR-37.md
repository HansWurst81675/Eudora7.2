# <a id="lektor-37"></a>LEKTOR-37 — Doku nach 7.2.0.99 (1.0.99 bestätigt, vor PR und Release)

Lauf am 16.10.2026 auf `wt/lektor` (`8e5936aa`, gleich `e-118_HTML_header`). Anlass: seit
[LEKTOR-36](LEKTOR-36.md#lektor-36) (`0d2685d1`) sind 7.2.0.97 ([PRÜFER-30](PRUEFER-30.md) F1
gesendete Post, N1), 7.2.0.98 ([E-83](../BEFUNDE.md#e-83) zweite Ursache) und 7.2.0.99 (Neubau
wegen [E-124](../BEFUNDE.md#e-124), Defender) dazugekommen; 1.0.99 ist von Gregor am 16.10.2026
bestätigt. Gregor will den PR `e-118_HTML_header` → `main` mergen und ein Release machen.

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Arbeitsweise/` = 122 Dateien
(eine mehr mit diesem Bericht). Außerhalb von `Befunde/` alle 41 auf Fassungsangaben und
Stand gelesen, die zehn seit `0d2685d1` geänderten ganz an den betroffenen Stellen; aus
`Befunde/` der Bericht der Runde (`PRUEFER-30.md`, der einzige neue) und alle über
`befunde-verlinken.pl --anker`. Dazu eine eigene Suche nach toten Dateilinks über alle
122 (Codespannen ausgenommen): **keiner**. **Maßstab:** `Eudora71/Version.h` = 7.2.0.99,
`VERSION` = 1.0.99, `git tag` = `v1.0.87`, Urteile in `BEFUNDE.md` (Zeilen [E-83](../BEFUNDE.md#e-83),
[E-121](../BEFUNDE.md#e-121), [E-123](../BEFUNDE.md#e-123), [E-124](../BEFUNDE.md#e-124)), Commits `4c78dc9c` bis `8e5936aa`,
`Releases/1.0.99/TESTEN.txt`.

`perl tools/offene-befunde.pl`: 34/34, deckt. `perl tools/doku-pruefen.pl`: kein Widerspruch;
zur Kenntnis vier Dateien ohne 7.2.0.99 ([L-37.15](#l-37.15)).

## Berichtigt

### <a id="l-37.1"></a>L-37.1 — README: E-121 mit „Restfälle N1–N3 offen“, E-83 ohne Gregors Lauf

| Stelle | stand | jetzt | Beleg |
|---|---|---|---|
| `README.md:187` | *„…der letzte an 1.0.96 von Gregor bestätigt; Restfälle N1–N3 offen“* | dazu: in 7.2.0.97 gesendete Post und N1, an 1.0.99 bestätigt; N2/N3 abgetrennt als [E-123](../BEFUNDE.md#e-123) | `BEFUNDE.md:288` (*„N1 behoben“*, *„N2/N3 abgetrennt“*, *„Bestätigt an 1.0.99“*) |
| `README.md:193` | [E-83](../BEFUNDE.md#e-83) *„… 10 von 10 durch), noch nicht ausgeliefert“* | dazu: an 1.0.99 von Gregor sauber beendet, der Wettlauf trat in seinem Lauf nicht auf | `BEFUNDE.md:251` |

### <a id="l-37.2"></a>L-37.2 — CHANGELOG: E-121 bei N1–N3, E-123 und E-124 fehlten in *Noch offen*, 7.2.0.99 ohne Gregors Urteil

* `CHANGELOG.md:16`, *Noch offen*, [E-121](../BEFUNDE.md#e-121): *„Offen bleiben die Restfälle N1–N3“*. Jetzt:
  7.2.0.97 (F1, N1) an 1.0.99 bestätigt, N2/N3 nach [E-123](../BEFUNDE.md#e-123), Befund bleibt offen (Urteil
  unverändert aus `BEFUNDE.md`).
* [E-123](../BEFUNDE.md#e-123) und [E-124](../BEFUNDE.md#e-124) stehen in `BEFUNDE.md` offen, fehlten aber in *Noch offen*. Zwei Zeilen
  eingesetzt, Wortlaut aus `BEFUNDE.md:290-291`.
* Abschnitt 7.2.0.99 endete mit *„Testsuite 209/209“*; Gregors Bestätigung an 1.0.99
  (`8e5936aa`, `BEFUNDE.md:288`) fehlte, ebenso der Hinweis, dass 1.0.97/1.0.98 nicht zu testen
  sind. Angefügt. Die Abschnitte 7.2.0.97 und 7.2.0.98 sagen weiter *„Prüfung bei Gregor“* –
  das war ihr Stand am Tag; die Antwort steht jetzt im Abschnitt darüber.

### <a id="l-37.3"></a>L-37.3 — „N1–N3 offen“ bzw. „zum Test bei Gregor“ in ZIEL, TESTPLAN, AUFGABEN, ZWEIGE

| Stelle | stand | jetzt |
|---|---|---|
| `ZIEL.md:20` | *„Restfälle N1–N3 offen“* | 7.2.0.97 an 1.0.99 bestätigt, N2/N3 als [E-123](../BEFUNDE.md#e-123) |
| `TESTPLAN.md:1` | *„Paket 1.0.99 … zum Test bei Gregor“* | *„von Gregor am 16.10.2026 bestätigt; 1.0.97 und 1.0.98 nicht testen“* |
| `AUFGABEN.md:3` | Kette sprang von 7.2.0.99 auf *„Doppelanzeige behoben; davor 7.2.0.90“* | 7.2.0.98 und 7.2.0.97 eingefügt, mit Bestätigung an 1.0.99 |
| `tools/ZWEIGE.md:101` | Zweck endet bei 7.2.0.96 | dazu 7.2.0.97 bis 7.2.0.99 |

Die Zeile [E-121](../BEFUNDE.md#e-121) bleibt in `ZIEL.md` unter den Maßstabsfehlern: veröffentlicht ist nichts (`v1.0.87`).

### <a id="l-37.4"></a>L-37.4 — WEITERMACHEN: der Block „hier weitermachen“ führte 1.0.98 als zu testen und Release v1.0.97

`WEITERMACHEN.md:125` (*„Stand 16.10.2026 – hier weitermachen“*):

* *„Quellstand **7.2.0.97**“* – Nachtrag *„jetzt 7.2.0.99“*.
* *„(2) Gregor testet 1.0.98, vor allem eine gesendete Mail …“* – **1.0.98 darf nicht getestet werden**
  (Defender, [E-124](../BEFUNDE.md#e-124)); durchgestrichen, ersetzt durch *„1.0.99 von Gregor bestätigt“*.
* *„(3) PR … Release v1.0.97“* – **v1.0.97 wäre ein ungetestetes Paket**, dessen Läufe am
  Prüfstand alle hingen. Jetzt *„Release v1.0.99“*, mit dem Hinweis auf [L-37.7](#l-37.7).
* *„Nicht veröffentlichen: 1.0.96 (F1)“* – dazu 1.0.98 (Defender), *„Nicht testen: 1.0.97, 1.0.98“*.
* Kopftabelle: Zeilen für 1.0.98, 1.0.96 … 1.0.89, aber **keine für 1.0.97**. Eingesetzt:
  nicht testen (`f6d98141`), Verdacht gegen 7.2.0.97 widerlegt (Ursache [E-83](../BEFUNDE.md#e-83)).

### <a id="l-37.5"></a>L-37.5 — PAKETE: 1.0.97 „sein Test steht aus“, 1.0.98 ohne Gregors Lauf, 1.0.96 ohne Sperrvermerk

* 1.0.97: *„sein Test steht aus“* und *„Ob ohne Nachstellung getestet wird, entscheidet Gregor“*
  – entschieden ist es (`f6d98141`: *„Gregor testet 1.0.97 nicht“*). Berichtigt, Nachtrag mit dem
  widerlegten Rückfallverdacht (`3f343af9`, `BEFUNDE.md:251`).
* 1.0.98 hatte keine Zeile *„Bei Gregor“*: eingesetzt (Defender beendete das Programm, gesendete
  Mail schon hochgeladen, nicht testen, nicht ausliefern) – Wortlaut aus `BEFUNDE.md:291`.
* 1.0.96: *„nicht veröffentlichen“* stand nur in `WEITERMACHEN.md`. Zeile *„Freigabe“* eingesetzt.

### <a id="l-37.6"></a>L-37.6 — WERKZEUGE kannte die Defender-Prüfung nicht

`tools/paket-pruefen.ps1:678-720` (seit `a2ef4b47`) lässt `MpCmdRun -Scan -ScanType 3 -File …
-DisableRemediation` über jede `.exe`/`.dll`/`.ocx` des Pakets laufen, Fund = `Melde-Fehler`,
fehlendes `MpCmdRun.exe` = Warnung. `tools/WERKZEUGE.md:51` beschrieb nur die Startkette. Ergänzt,
mit Gegentest aus `BEFUNDE.md:291`. Kopf `:3` *„Quellstand inzwischen 7.2.0.96“* → 7.2.0.99.
Nebenbei zwei fehlende Satzpunkte in der Zeile `testlauf.ps1` (`:113`). Alle Werkzeuge unter
`tools/` haben eine Zeile (geprüft über die Dateinamen); `pruefe-nachgestellt.pl`,
`pruefe-kennung-suche.pl`, `-Freigabe` in `e118-serie.ps1`/`testlauf.ps1` sind schon beschrieben.

## Offen — nur gemeldet

### <a id="l-37.7"></a>L-37.7 — vor dem PR: PRÜFER hat 7.2.0.97 und 7.2.0.98 nicht gesehen, CHRONIST fällig

`perl tools/rollen-faellig.pl`: **PRÜFER fällig** seit `45ed40c` (PRÜFER-30, 7.2.0.94–96), 8 Dateien,
darunter `ImapActionQueue.cpp`, `ImapToc.cpp`, **`QCTaskManager.cpp`**. Nicht nachgerechnet sind damit
der siebte Teil von [E-121](../BEFUNDE.md#e-121) (Suche bei Kennung 0, `m_bE121Quelle` – derselbe Weg, auf dem
1.0.96 den Rückfall F1 brachte) und die [E-83](../BEFUNDE.md#e-83)-Änderung im Aufgabenverwalter
(`SetDisplayWindow`, `OnMsgDeleteInfo`), die in Gregors Lauf an 1.0.99 **nicht durchlaufen** wurde
(`BEFUNDE.md:251`). Gregors Bestätigung deckt also die neue E-83-Stelle nicht. **CHRONIST** fällig
seit `462de1a` (11 Dateien). Wie [L-36.8](LEKTOR-36.md#l-36.8): vor dem Merge laufen lassen.

### <a id="l-37.8"></a>L-37.8 — E-121: der erste Satz des Urteils ist zwei Fassungen alt

`BEFUNDE.md:288` beginnt weiter *„**DATENVERLUST. Offen, Behebung eingebaut in 7.2.0.90 …, von
Gregor noch nicht bestätigt.**“* – inzwischen bestätigt an 1.0.90, 1.0.96 und 1.0.99, N1 behoben,
N2/N3 abgetrennt. Was den Befund noch offen hält, sagt die Zelle nirgends ausdrücklich (in Frage
kommen [PRÜFER-30](PRUEFER-30.md) F3–F9, *„offen, siehe Bericht“*). Vorschlag aus [L-36.9](LEKTOR-36.md#l-36.9) fortgeschrieben:
*„**DATENVERLUST. Offen wegen PRÜFER-30 F3–F9 (F6: Vermutung Datenverlust). Kern, Doppelanzeige,
gesendete Post und N1 von Gregor an 1.0.99 bestätigt (16.10.2026), nicht veröffentlicht.**“* –
oder, falls Gregor F3–F9 abtrennt, das Urteil auf behoben setzen. Urteil, nicht selbst geändert.

### <a id="l-37.9"></a>L-37.9 — PRÜFER-30 F6: Datenverlust-Vermutung ohne eigenen Eintrag

[PRÜFER-30](PRUEFER-30.md) F6 (*„Vorab-Kopie mit lokaler Kennung gilt im IMAP-Ordner als
Server-UID — Datenverlust (fremde Mail), Vermutung, alt“*): wird die Vorab-Kopie vor dem Hochladen
im IMAP-Ordner gelöscht oder verschoben, geht der Befehl mit der lokalen Kennung als UID an den
Server und kann eine fremde Mail treffen. In `BEFUNDE.md` steht dazu nur *„F3–F9 offen, siehe
Bericht“*, im CHANGELOG nichts. Vor einem Release gehört das vor Gregor
(`Arbeitsweise/kein-paket-mit-offenem-datenverlust.md`): entweder als eigener Befund aufnehmen oder
ausdrücklich als hingenommen vermerken. Der Fall ist seit QUALCOMM so, steckt also auch in `v1.0.87`.

### <a id="l-37.10"></a>L-37.10 — E-122, E-123, E-124 fehlen in README und AUFGABEN

`README.md`, *Was es nicht kann*, führt [E-122](../BEFUNDE.md#e-122) (seit [L-36.13](LEKTOR-36.md#l-36.13)), [E-123](../BEFUNDE.md#e-123) und [E-124](../BEFUNDE.md#e-124) nicht; der
Defender-Fall hat einen eigenen Anwenderabschnitt, steht aber nicht in der Fehlerliste.
`Releases/1.0.99/TESTEN.txt` nennt [E-122](../BEFUNDE.md#e-122) und [E-123](../BEFUNDE.md#e-123) unter *„Bekannt und NICHT behoben“* – die README
für das Release nicht. `AUFGABEN.md` hat für [E-121](../BEFUNDE.md#e-121) bis [E-124](../BEFUNDE.md#e-124) keine Aufgabenzeile. `ZIEL.md`,
Maßstabsfehler: ob [E-123](../BEFUNDE.md#e-123) (Bildverlust nach Neustart) unter *„Post wird verfälscht“* gehört, ist
eine Einordnung.

### <a id="l-37.11"></a>L-37.11 — was für ein Release v1.0.99 fehlt (nicht vorweggenommen)

Veröffentlicht ist `v1.0.87`. Für `v1.0.99` sind nachzuziehen:

* **README:** *„Das neueste Release ist `v1.0.87`“* (`:72-79`, mit Datum, URL, Inhalt) → `v1.0.99`
  mit dem, was seit 1.0.87 dazukam ([E-105](../BEFUNDE.md#e-105), [E-118](../BEFUNDE.md#e-118) Teil 1 und 2, [E-121](../BEFUNDE.md#e-121), [E-83](../BEFUNDE.md#e-83) zweite Ursache);
  in *Was es nicht kann* fünf Stellen *„im Download `v1.0.87` offen“* / *„noch nicht ausgeliefert“*
  ([E-105](../BEFUNDE.md#e-105) `:170`, [E-118](../BEFUNDE.md#e-118) `:179`, `:182`, [E-121](../BEFUNDE.md#e-121) `:184`, [E-83](../BEFUNDE.md#e-83) `:194-195`); der Defender-Abschnitt
  `:415-417` nennt *„das veröffentlichte `v1.0.87`“*. Beispiel-Titelzeile `:336` (*7.2.0.72 / 1.0.72*)
  ist ein Beispiel, kein Stand. Der Downloadhinweis (`releases/latest`) braucht keine Änderung.
* **[E-105](../BEFUNDE.md#e-105) ginge ohne Gregors Urteil hinaus:** seit 7.2.0.88 eingebaut, *„von Gregor
  noch nicht bestätigt“* (`CHANGELOG.md:32`, `README.md:170`), C5 im TESTPLAN offen. Gregor hat
  auf 1.0.88 verzichtet (*„deine tests sollten reichen“*) – ob das für das Release gilt, steht nirgends.
* **Releases/PAKETE.md:** Kopf `:6` und `:20` (*„zuletzt veröffentlicht 1.0.87“*); Abschnitt 1.0.99
  *„nicht ausgeliefert“*, ohne Zeilen ZIP, SHA256, URL, Freigabe (Muster: Abschnitt 1.0.87).
  Das ZIP muss nach dem Bau erneut durch `paket-pruefen.ps1` (jetzt mit Defender) – geprüft ist
  bisher das Testverzeichnis, nicht das Release-ZIP.
* **CHANGELOG:** Überschriften 7.2.0.88 bis 7.2.0.99 *„nicht veröffentlicht“* → *„enthalten in
  `v1.0.99`“* bzw. *„veröffentlicht als `v1.0.99`“*; *Noch offen*: [E-118](../BEFUNDE.md#e-118) *„noch nicht veröffentlicht“*,
  [E-121](../BEFUNDE.md#e-121) *„nicht veröffentlicht“*.
* **Übrige Standköpfe:** `WEITERMACHEN.md:9-11` und *Zuletzt gebaut und veröffentlicht* (`:38`),
  `ZIEL.md:47` und die Maßstabszeilen [E-118](../BEFUNDE.md#e-118)/[E-121](../BEFUNDE.md#e-121) (`:20-21`), `AUFGABEN.md:3`,
  `PORTIERUNG.md:44`, `TESTPLAN.md:1`, `tools/RELEASES.md` (neue Zeile mit Gregors Freigabe).
* **Nicht veröffentlichen:** 1.0.96 (F1), 1.0.98 (Defender). 1.0.97 ist ungetestet.

### <a id="l-37.12"></a>L-37.12 — TESTLAEUFE: Lauftexte nennen den falschen Zweck und die falsche Fassung

`tools/TESTLAEUFE.md:217-238` (16.10.2026): alle Läufe tragen *„[E-121](../BEFUNDE.md#e-121) Vergleich 7.2.0.96 gegen
7.2.0.97“*, auch der Kollisionsfall an 7.2.0.98 (`k98a`/`k98b` haben einen eigenen Text, die
`a`-, `b`-, `c`-, `d`-Läufe nicht). Die drei Läufe `d1-98` bis `d3-98` um 10:24–10:25 liegen
**nach** der Defender-Erkennung (10:12) und vor dem Commit 7.2.0.99 (10:30); `Releases/PAKETE.md`
nennt *„an 7.2.0.99 drei Läufe hochgeladen“*. Wenn das diese drei sind, sagt ihre Kennung „98“
etwas Falsches. Nicht geändert (Protokoll des Werkzeugs).

### <a id="l-37.13"></a>L-37.13 — fünf DLLs im Hauptbaum weiter uncommittet

`git status` im Hauptbaum: ` M Eudora71/Bin/Release/DirServ.dll`, `EudoraBk.dll`, `ISock.dll`,
`Ldap.dll`, `Ph.dll` – seit [L-36.11](LEKTOR-36.md#l-36.11) unverändert. Ein Release-ZIP, das wie 1.0.87 die DLLs
aus `Bin/Release` nimmt, enthält diese ungeprüften Stände. Vor dem Paketbau klären, ob sie
hineingehören (Byte-Vergleich gegen Gregors getestetes `Eudora72-1.0.99-release`).

### <a id="l-37.14"></a>L-37.14 — TESTPLAN weiter ohne Abschnitt für 1.0.90 bis 1.0.99

[L-35.11](LEKTOR-35.md#l-35.11) und [L-36.12](LEKTOR-36.md#l-36.12) unverändert offen: Teil C endet mit C5 (1.0.89). Gregors
Ergebnisse zu 1.0.90, 1.0.96 und 1.0.99 stehen nur in `BEFUNDE.md`, `WEITERMACHEN.md`,
`Releases/PAKETE.md`; die Prüfschritte zu 1.0.99 nur in `Releases/1.0.99/TESTEN.txt`.

### <a id="l-37.15"></a>L-37.15 — die Hinweise von `doku-pruefen.pl`

* `Testdaten/README.md:6`: *„die zu [E-118](../BEFUNDE.md#e-118)/[E-121](../BEFUNDE.md#e-121) (`e118-*.eml`) am 15.10.2026 an 7.2.0.96“*. Am
  16.10.2026 liefen 22 Läufe am Prüfstand (`TESTLAEUFE.md:217-238`), welche Prüfnachricht
  (`-Eml`) sie nahmen, steht nicht im Protokoll. Nicht berichtigt, weil nicht belegbar.
* `tools/ZWEIGE.md`: nach [L-37.3](#l-37.3) nennt die Zeile 7.2.0.99.
* `tools/WERKZEUGE.md`: nach [L-37.6](#l-37.6) nennt der Kopf 7.2.0.99.
* `tools/pruefdaten/LIESMICH.md` (7.2.0.83): nur Messfassung der AN-Prüfdaten, nichts zu ändern.

### <a id="l-37.16"></a>L-37.16 — was aus LEKTOR-36 geworden ist

[L-36.8](LEKTOR-36.md#l-36.8) erledigt durch [PRÜFER-30](PRUEFER-30.md) (fand F1), für 7.2.0.97/98 wieder offen
([L-37.7](#l-37.7)); [L-36.10](LEKTOR-36.md#l-36.10) zur Hälfte erledigt (`-Freigabe` Pflicht, Datum geprüft; `$repo` steht weiter fest auf dem Hauptbaum, `tools/e118-serie.ps1:7`); [L-36.11](LEKTOR-36.md#l-36.11) die
Läufe sind committet, die DLLs nicht ([L-37.13](#l-37.13)). Offen: [L-36.9](LEKTOR-36.md#l-36.9) (siehe [L-37.8](#l-37.8)),
[L-36.12](LEKTOR-36.md#l-36.12) (siehe [L-37.14](#l-37.14)), [L-36.13](LEKTOR-36.md#l-36.13) (siehe [L-37.10](#l-37.10)).
