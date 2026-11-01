# <a id="lektor-121"></a>LEKTOR-121 — Kurzlauf vor dem PR, Zweig e184_mehrere_mails nach c0f70c11 (01.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-120](LEKTOR-120.md#lektor-120).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261101k`, Stand `c0f70c11`.

## Kurz

Die Buchführung von `c0f70c11` (PRÜFER-78 eingearbeitet) stimmt in der Sache mit Code,
Prüfstandsbuch und Testlaufprotokoll: [E-184](../Intern/BEFUNDE.md#e-184) (beim Verschieben mehrerer Mails im IMAP-Konto
bekamen die Einträge im Ziel die Daten einer anderen Mail) mit ehrlicher Gegenprobe, neu
[E-192](../Intern/BEFUNDE.md#e-192) (Papierkorb, Junk und Filter ordnen weiter nach Listenposition zu) und [E-193](../Intern/BEFUNDE.md#e-193)
(Suche mit Umlauten oder € liefert widersprüchliche Ergebnisse). Vier Funde, keiner am
Programm, **alle berichtigt im selben Commit**. Der wichtigste: Der Kopf von
`tools/messen-e184m.ps1` beschrieb noch die alte, von PRÜFER-78 K7 als blind erkannte
Gegenprobe ([L-121.1](#l-121.1)) — meine Berichtigung [L-120.5](LEKTOR-120.md#l-120.5) war damals richtig und ist durch
den geänderten Prüfserver überholt. 47 Befunde offen (45 + [E-192](../Intern/BEFUNDE.md#e-192) + [E-193](../Intern/BEFUNDE.md#e-193)).

## Funde aus LEKTOR-120

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-120.1](LEKTOR-120.md#l-120.1) [E-139](../Intern/BEFUNDE.md#e-139) an 7.2.1.130 | erledigt | BEFUNDE, TESTPLAN, WEITERMACHEN seit `ae7870cd` an diesen Stellen unverändert |
| [L-120.2](LEKTOR-120.md#l-120.2) WEITERMACHEN-Kopf | erledigt | `Intern/WEITERMACHEN.md:3` unverändert (Diff seit `ae7870cd` nur `:75ff`) |
| [L-120.3](LEKTOR-120.md#l-120.3) jüngster Bau bei [E-184](../Intern/BEFUNDE.md#e-184) | **wieder veraltet** | siehe [L-121.2](#l-121.2) |
| [L-120.4](LEKTOR-120.md#l-120.4) [E-172](../Intern/BEFUNDE.md#e-172) Rückblicke | erledigt | unverändert |
| [L-120.5](LEKTOR-120.md#l-120.5) Kopf `messen-e184m.ps1` | **überholt** | siehe [L-121.1](#l-121.1) |
| [L-120.6](LEKTOR-120.md#l-120.6) README-Zahl | **wieder veraltet** | siehe [L-121.4](#l-121.4) |
| [L-120.7](LEKTOR-120.md#l-120.7) [E-172](../Intern/BEFUNDE.md#e-172) doppelt verlinkt | erledigt | `CHANGELOG.md` *„**[E-172](…) aufgeklärt, kein Programmfehler**: …“* |
| [L-120.8](LEKTOR-120.md#l-120.8) ZWEIGE ohne [E-188](../Intern/BEFUNDE.md#e-188) | erledigt | `tools/ZWEIGE.md:205` |

## Was seit ae7870cd dazukam

Gelesen: `git log --stat ae7870cd..HEAD`, drei Commits, zwei davon Merges (PRÜFER-78, [LEKTOR-120](LEKTOR-120.md#lektor-120));
inhaltlich nur `c0f70c11`, 15 Dateien.

| Angabe | Stelle | Ergebnis |
|---|---|---|
| Gegenprobe E-184m berichtigt (K7) | `Intern/BEFUNDE.md:403` *„am Bau `6e9a43ba` (nur [E-184](../Intern/BEFUNDE.md#e-184)/[E-189](../Intern/BEFUNDE.md#e-189)) **`richtig=1 falsch=2`** … mit der Behebung (Bau `83908112*`) `richtig=3 falsch=0 anfrage=3,2,1 copyuid=1:3/1:3`“* | stimmt: `Intern/pruefstand-buch.tsv:42` *„E-184m ok 2026-11-01 20:14:57 … 7.2.1.130+83908112* … richtig=3 falsch=0 eintraege=3 anfrage=3,2,1 copyuid=1:3/1:3“*, `:41` [E-184](../Intern/BEFUNDE.md#e-184) grün am selben Bau; `tools/TESTLAEUFE.md` Start 20:09:47 mit `6e9a43ba*`, 20:11–20:16 mit `83908112*` (gemessen). Den roten Wert selbst führt das Buch nicht (nur der letzte Lauf je Fall) — belegt am Commit |
| Prüfserver meldet Bereiche | `tools/WERKZEUGE.md`, Zeile `imap-pruefserver.pl`: *„`COPYUID` mit Bereichen wie `1:3` (PRÜFER-78 K7)“* | stimmt: `tools/imap-pruefserver.pl:550` *„OK [COPYUID 1 %s %s]“* mit `$bereiche->(@alt), $bereiche->(@neu)` (gemessen) |
| K2/K4 klein offen | `Intern/BEFUNDE.md:403` *„(PRÜFER-78 K2) … (K4, sicher, nur ungenutzt)“* | in der Sache richtig, aber zwei verschiedene K4; siehe [L-121.3](#l-121.3) |
| [E-192](../Intern/BEFUNDE.md#e-192): drei Aufrufer ohne Quellmenge | `Intern/BEFUNDE.md:400` | stimmt: `ImapToc.cpp:2828` *„ImapTransferSummaryData(sUidlist, pTargetToc, &dwaNewUIDs);“*, `:3134`, `ImapFiltersd.cpp:1304` reichen keine Quellmenge; nur `ImapActionQueue.cpp:1612` (gemessen) |
| [E-193](../Intern/BEFUNDE.md#e-193) neu | `Intern/BEFUNDE.md:399` | als Beobachtung gekennzeichnet, „am Prüfstand nie gemessen“; keine Mailadresse, kein Absender, kein Betreff (gemessen mit `grep`) |
| Haken 39 Fälle | `tools/WERKZEUGE.md` *„**39 Fälle**“* | `perl tools/haken-eudora-start.pl --selbsttest` → *„Ergebnis: 39 Faelle, 39 bestanden, 0 fehlgeschlagen“* (gemessen) |
| `messen-e184m` in WERKZEUGE | *„Erwartet `E184M ERGEBNIS … anfrage=3,2,1 copyuid=1:3/1:3` … am Bau `6e9a43ba` (ohne K3) `richtig=1 falsch=2`“* | stimmt mit `tools/pruefstand-faelle.txt`, Block `E-184m` |
| CHANGELOG-Block | `CHANGELOG.md`, Zweig `e184_mehrere_mails` | stimmt; [E-192](../Intern/BEFUNDE.md#e-192) und [E-193](../Intern/BEFUNDE.md#e-193) genannt, Tabelle oben erzeugt |
| `UidMenge.h` Überlauf, Tests 357/357 | Commit `c0f70c11` | nicht nachgezählt (nichts bauen) |

## Funde

### <a id="l-121.1"></a>L-121.1 — Kopf von `messen-e184m.ps1` beschrieb die blinde Gegenprobe

**Gewicht: mittel.** Wer das Skript liest, erwartet die alte Serverantwort und den alten roten Wert. (gemessen)

`tools/messen-e184m.ps1:7` *„"[COPYUID 1 1,2,3 1,2,3]"“*, `:10` Erwartung ohne `anfrage`/`copyuid`,
`:11-12` *„rot am Bau 6e9a43ba (… richtig=2 falsch=1), gruen … (Bau c4e883a9*)“*. Seit `c0f70c11`
sendet der Prüfserver Bereiche (`imap-pruefserver.pl:550`), der Fall verlangt `anfrage=3,2,1`, der
rote Wert ist `richtig=1 falsch=2`, und `richtig=2 falsch=1` mass laut PRÜFER-78 K7 nur den alten Leser.

**Berichtigt im selben Commit** (reines ASCII, `>127 0`, nur-LF 26 → 28): Bereiche `1:3`, volle
Erwartungszeile, rot `richtig=1 falsch=2` am `6e9a43ba`, grün am `83908112*`, Hinweis auf K7.

### <a id="l-121.2"></a>L-121.2 — E-184: „zuletzt Bau c4e883a9*“ im selben Eintrag wie Bau 83908112*

**Gewicht: Kleinkram.** (gemessen)

`Intern/BEFUNDE.md:403` nannte unter *Zuletzt gemessen* noch *„zuletzt Bau `c4e883a9*` mit der
Behebung von K3“*, weiter hinten aber `83908112*`; das Prüfstandsbuch hat 20:14:57 an `83908112*`.
**Berichtigt im selben Commit:** *„Bau `c4e883a9*` mit der Behebung von K3, zuletzt Bau `83908112*`
mit dem Mengenleser für Bereiche: … `Intern/pruefstand-buch.tsv` 20:14:57“*.

### <a id="l-121.3"></a>L-121.3 — E-184: zwei verschiedene „K4“, „Was noch fehlt“ ohne K2 und mit erledigter Prüfung

**Gewicht: Kleinkram, aber verwirrend vor dem PR.** (gemessen)

Im selben Eintrag meint *„(K4, sicher, nur ungenutzt)“* PRÜFER-78 K4 (`E170LabelsNachtragen` nutzt
die Quellmenge nicht) und *„**Weiter offen (K4):** das Merkzeichen lebt nur im Speicher“* PRÜFER-75
K4 (Warteschlange nach Neustart legt eine zweite Zusammenfassung an). *„**Was noch fehlt:** K4 (…);
PRÜFER über die K3-Behebung“* — PRÜFER-78 ist diese Prüfung, und K2 (Server meldet nur einen Teil
als kopiert) fehlte dort.

**Berichtigt im selben Commit:** *„(PRÜFER-78 K4, …; nicht zu verwechseln mit K4 aus PRÜFER-75 weiter
unten)“* und *„**Was noch fehlt:** K4 aus PRÜFER-75 (…); PRÜFER-78 K2 (Teilkopie, klein); PRÜFER über
die K3-Behebung erledigt ([PRÜFER-78](PRUEFER-78.md))“*. Die gekürzte Spalte in CHANGELOG und
WEITERMACHEN neu erzeugt mit `offene-befunde.pl -schreiben`.

### <a id="l-121.4"></a>L-121.4 — README: Zahl der Prüfberichte zum fünften Mal veraltet

**Gewicht: Kleinkram.** (gemessen)

`README.md:98` *„194 LEKTOR- und PRÜFER-Berichte“*; am Stand `c0f70c11` 119 + 76 = 195
(`git ls-files Befunde | grep -cE '/LEKTOR-[0-9]+\.md$'` bzw. `PRUEFER`), mit diesem Bericht 196.
**Berichtigt im selben Commit:** 196. Vorschlag wie in [L-120.6](LEKTOR-120.md#l-120.6): erzeugen oder streichen.

## Zur Kenntnis

- `tools/ZWEIGE.md:205` nennt [E-192](../Intern/BEFUNDE.md#e-192) nicht; der Zweig behebt es nicht, ZWEIGE beschreibt den Plan. Kein Fund.
- `doku-pruefen.pl` „Zur Kenntnis“: dieselben Dateien ohne 7.2.1.130 wie in [LEKTOR-120](LEKTOR-120.md#lektor-120) (u. a. `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md`).

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): kein Widerspruch; „Zur Kenntnis“ wie oben.

`perl tools/offene-befunde.pl` (gemessen, vor den Berichtigungen):

```
      davon aktuell gemessen       4  (ab Nummer 125)
      davon veraltet gemessen     28
      davon NIE gemessen          15
    in Intern/WEITERMACHEN.md     47
  47 offene Befunde, in beiden Listen gleich.
```

45 → 47 durch [E-192](../Intern/BEFUNDE.md#e-192) und [E-193](../Intern/BEFUNDE.md#e-193); „nie gemessen“ 13 → 15 aus demselben Grund.

`perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne Regressionstest.“*

`perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Nachtrag: 7b41c8d7 gegengelesen

[E-192](../Intern/BEFUNDE.md#e-192) nennt für den Papierkorb jetzt richtig `CTocDoc::ImapMoveMsgsToTrash` (`ImapToc.cpp:2730`, Aufruf `:2828`), und WERKZEUGE nennt 47 Fälle für den Haken mit K1/K2 wie in [PRÜFER-79](PRUEFER-79.md) — `perl tools/haken-eudora-start.pl --selbsttest` → *„Ergebnis: 47 Faelle, 47 bestanden, 0 fehlgeschlagen“* (gemessen). Derselbe falsche Name `CTocDoc::ImapDoPostExpunge` stand noch in [E-184](../Intern/BEFUNDE.md#e-184) (`Intern/BEFUNDE.md:403`, die zwei weiteren Aufrufer); **berichtigt im selben Commit**.

## Was nur Gregor entscheiden kann

Nichts Neues.
