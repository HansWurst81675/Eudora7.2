# <a id="lektor-38"></a>LEKTOR-38 — Doku nach 7.2.0.100 (1.0.100 bei Gregor, vor Release v1.0.100)

Lauf am 16.10.2026 auf `wt/lektor` (`a5604ddf`, gleich `origin/e-121-mehrere-gesendete`; der
Auftrag nannte `16c27e4e`, auf dem Zweig lag inzwischen Gregors README-Änderung *„Spalte ‚Was kann
verlorengehen‘ ausgeschrieben“*, vorgespult mit `merge --ff-only`). Anlass: seit
[LEKTOR-37](LEKTOR-37.md#lektor-37) (`34fc3363`) ist [PRÜFER-31](PRUEFER-31.md) gelaufen, PR #98
(`e-118_HTML_header` bis 7.2.0.99) am 16.10.2026 gemergt (`7364eb35`), 7.2.0.100 auf
`e-121-mehrere-gesendete` gebaut (PRÜFER-31 F1, F3, F4), Paket 1.0.100 liegt bei Gregor, und die
README hat den neuen Abschnitt *Auf einen Blick*. Ziel: Release `v1.0.100` nach Gregors Test.

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Arbeitsweise/` = 124 Dateien (125 mit
diesem Bericht). Außerhalb von `Befunde/` alle 41 auf Fassungsangaben und Stand gelesen, die
zehn seit `34fc3363` geänderten an den geänderten Stellen; aus `Befunde/` der neue Bericht
`PRUEFER-31.md` ganz, die übrigen über `befunde-verlinken.pl --anker`. **Maßstab:**
`Eudora71/Version.h` = 7.2.0.100, `VERSION` = 1.0.100, `git tag` = `v1.0.87`, Statusspalte in
`BEFUNDE.md` (Zeilen der 34 offenen Befunde), `Befunde/PRUEFER-31.md` (Urteil und Tabelle),
`git ls-remote --heads origin`, `Releases/1.0.100/TESTEN.txt`.

`perl tools/offene-befunde.pl`: 34/34, deckt. `perl tools/doku-pruefen.pl`: kein Widerspruch;
zur Kenntnis `Testdaten/README.md` (7.2.0.96), `tools/WERKZEUGE.md` (7.2.0.99, berichtigt in
[L-38.3](#l-38.3)), `tools/pruefdaten/LIESMICH.md` (7.2.0.83, Messfassung, nichts zu ändern).

## Berichtigt

### <a id="l-38.1"></a>L-38.1 — E-121: 7.2.0.100 fehlte in README, ZIEL und CHANGELOG *Noch offen*

| Stelle | stand | jetzt |
|---|---|---|
| `README.md`, *Was es nicht kann*, [E-121](../Intern/BEFUNDE.md#e-121) | Kette endet bei *„N2/N3 abgetrennt als [E-123](../Intern/BEFUNDE.md#e-123)“* | dazu 7.2.0.100 (PRÜFER-31 F1), am Prüfstand gemessen, 1.0.100 zum Test bei Gregor |
| `ZIEL.md:20`, Maßstabsfehler [E-121](../Intern/BEFUNDE.md#e-121) | ebenso | ebenso |
| `CHANGELOG.md:16`, *Noch offen*, [E-121](../Intern/BEFUNDE.md#e-121) | endet bei PRÜFER-30 F3–F9 | dazu 7.2.0.100 (F1, F3, F4) und: [PRÜFER-31](PRUEFER-31.md) F2 (hängendes Merkzeichen, Datenverlust in einer Kette, Vermutung) ist **nicht** behoben |

Beleg: `BEFUNDE.md:288` (*„Achter Teil, eingebaut in 7.2.0.100“*), `CHANGELOG.md` Abschnitt
7.2.0.100, `Befunde/PRUEFER-31.md:30` (F2). Urteil *offen* unverändert.

### <a id="l-38.2"></a>L-38.2 — PR #98 gemergt: ZWEIGE und WEITERMACHEN

* `tools/ZWEIGE.md:102`, `e-118_HTML_header`: kein Vermerk zum Merge. Jetzt *„Gemergt mit PR #98 am
  16.10.2026 (`7364eb35`); der Zweig steht noch lokal und auf `origin`“* –
  `git ls-remote --heads origin` nennt `refs/heads/e-118_HTML_header` auf `44085e12`. Muster:
  Zeile `e-105_doppelte_bilder` (*„Gemergt mit PR #97 am 14.10.2026, gelöscht“*); *gelöscht* ist
  er noch nicht, also nicht so geschrieben.
* `WEITERMACHEN.md:127`, Block *„hier weitermachen“*, Punkt (3): *„PR … → main, Release v1.0.99“*.
  [PRÜFER-31](PRUEFER-31.md) urteilt *„Release: erst nach F1“*; F1 steckt erst in 7.2.0.100.
  Nachtrag: PR gemergt, Release-Ziel **v1.0.100** nach Gregors Test und Zustimmung. Ein Release
  v1.0.99 hätte F1 ausgeliefert.

### <a id="l-38.3"></a>L-38.3 — WERKZEUGE-Kopf

`tools/WERKZEUGE.md:3` *„Quellstand inzwischen 7.2.0.99“* → 7.2.0.100. Geprüft mit
`git diff 34fc3363 HEAD -- tools/`: geändert haben sich nur `TESTLAEUFE.md` und `ZWEIGE.md`,
kein Werkzeug; keine Zeile fehlt.

## Offen — nur gemeldet

### <a id="l-38.4"></a>L-38.4 — *Auf einen Blick*: E-121 gilt in der README als erledigt, in BEFUNDE als offener Datenverlust

`README.md`, *Neu gegenüber `v1.0.87`*: *„eine verschobene Nachricht kann nicht mehr
verlorengehen“*; *Bekannte Fehler*, Vorsatz: *„In keinem dieser Fälle geht eine Nachricht in Ihrem
Postfach verloren“*. [E-121](../Intern/BEFUNDE.md#e-121) steht weder in der Tabelle noch sonst als offen.
`BEFUNDE.md:288` dagegen: **„DATENVERLUST. Offen“**, mit *„F3–F9 offen, siehe Bericht“*
([PRÜFER-30](PRUEFER-30.md), F6: Vorab-Kopie mit lokaler Kennung trifft im IMAP-Ordner eine fremde
Mail, Vermutung) und [PRÜFER-31](PRUEFER-31.md) F2 (b): ein hängendes Merkzeichen aus einem
gescheiterten Verschieben, dann wird der Namensvetter verschoben und vor dem Auftrag gelöscht –
**X wird entfernt, obwohl X nie auf dem Server ankam** (Mechanik belegt, Schaden Vermutung, nicht
behoben). Beides sind Vermutungen, keine beobachteten Fälle; der Satz *„kann nicht mehr
verlorengehen“* ist aber stärker als das Urteil. Zwei Wege, beide Gregors Entscheidung: das Urteil
in `BEFUNDE.md` auf behoben setzen und die Restfälle als eigenen Befund abtrennen (dann stimmt die
README), oder in die Tabelle eine Zeile *„Restfälle beim Verschieben nach IMAP (Vermutung am
Quelltext, nie beobachtet)“* mit *„die Nachricht“* in der zweiten Spalte und den Vorsatz
einschränken. Nicht geändert, weil das Urteil und Gregors frisch geänderte Tabelle betroffen sind.
Hängt mit [L-37.8](LEKTOR-37.md#l-37.8) und [L-37.9](LEKTOR-37.md#l-37.9) zusammen, die beide weiter offen sind.

### <a id="l-38.5"></a>L-38.5 — *Bekannte Fehler*: die übrigen Zeilen gegen BEFUNDE

Zeile für Zeile gegen die Statusspalte gelesen. **Stimmt:** [E-67](../Intern/BEFUNDE.md#e-67), [E-101](../Intern/BEFUNDE.md#e-101),
[E-39](../Intern/BEFUNDE.md#e-39), [E-123](../Intern/BEFUNDE.md#e-123) (*„Kein Verlust der Nachricht“*), [E-119](../Intern/BEFUNDE.md#e-119), [E-113](../Intern/BEFUNDE.md#e-113)/[E-116](../Intern/BEFUNDE.md#e-116), [E-122](../Intern/BEFUNDE.md#e-122), [E-77](../Intern/BEFUNDE.md#e-77), [E-90](../Intern/BEFUNDE.md#e-90),
[E-98](../Intern/BEFUNDE.md#e-98), [E-71](../Intern/BEFUNDE.md#e-71), [E-114](../Intern/BEFUNDE.md#e-114). Kein behobener Befund steht darin. Anmerkungen:

* **[E-47](../Intern/BEFUNDE.md#e-47) unvollständig:** `CHANGELOG.md`, *Noch offen*: *„Trifft auch die
  Junk-Bewertung: `SpamWatch` und `SpamHeaders` laden aus demselben Grund nicht, also bleibt jede
  Nachricht bei Punktzahl 0.“* Die Tabelle nennt nur Adressbuch, LDAP, Ph, S/MIME – und zwei Zeilen
  darüber steht ein Junk-Score-Filter ([E-67](../Intern/BEFUNDE.md#e-67)), der damit ohnehin nichts trifft.
* **[E-78](../Intern/BEFUNDE.md#e-78) fehlt** (offen, `BEFUNDE.md:246`): die Standardanordnung der Leisten
  überschreibt bei jedem Start Lage, Sichtbarkeit und Breite. Für Anwender sichtbar; steht in der
  README nirgends (`grep E-78 README.md`: 0).
* **[E-124](../Intern/BEFUNDE.md#e-124), zweite Spalte *nichts*:** stimmt mit *„Kein Datenverlust“* (CHANGELOG)
  überein. Defender beendet das Programm aber mitten in der Arbeit – genau die Lage, in der
  [E-123](../Intern/BEFUNDE.md#e-123) Bilder kosten kann (Neustart mitten im Verschieben). Gregors Fall an 1.0.98
  war ein Verschieben. Ein Querverweis wäre ehrlicher; Einordnung bei Gregor.
* **[E-69](../Intern/BEFUNDE.md#e-69):** *„nicht lesbare Nachricht“* ist die Anwenderfassung von drei
  `ASSERT(0)` (kein TOC, Dokument nicht ladbar, Rumpf leer) – vertretbar.
* **[E-39](../Intern/BEFUNDE.md#e-39):** steht als Tatsache, `BEFUNDE.md` sagt *„nicht am laufenden Programm
  bestätigt“*. Für eine Warnliste unschädlich.
* Nicht für Anwender: [E-111](../Intern/BEFUNDE.md#e-111) (ein Byte hinter dem Feld, nie ausgelöst), [E-92](../Intern/BEFUNDE.md#e-92)
  (unsere Seite ungemessen), [E-14](../Intern/BEFUNDE.md#e-14), [E-109](../Intern/BEFUNDE.md#e-109), die NP-/S-/A-/P-/R-Einträge.
  [AN-1](../Intern/BEFUNDE.md#an-1) [B5.7](../Intern/AUFGABEN.md#b5.7) (IMAP ohne `SetExtension`) ist offen; Gregor hat *„gekürzt mit
  endung reicht“* geurteilt – ob ein Rest für Anwender bleibt, sagt der Befund nicht.

### <a id="l-38.6"></a>L-38.6 — vor dem Release: PRÜFER hat 7.2.0.100 nicht gesehen, CHRONIST fällig

`perl tools/rollen-faellig.pl`: **CHRONIST fällig** seit `ad6f984` (5 Dateien, darunter
`ImapActionQueue.cpp`, `ImapToc.cpp`, `QCTaskManager.cpp`). PRÜFER-31 rechnete `45ed40c0..8e5936aa`;
die Behebung von F1/F3/F4 in 7.2.0.100 (`tocdoc.cpp`/`ImapToc.cpp`, `ImapActionQueue.cpp`,
`QCTaskManager.cpp`) hat **niemand nachgerechnet**, und F1 ist am Prüfstand *„nicht nachstellbar“*
(`CHANGELOG.md`, 7.2.0.100), bei Gregor tritt er nicht auf. Für die Behebung eines
Datenverlust-Wegs, der vor dem Release stehen soll, ist das die einzige unabhängige Prüfung.
Wie [L-37.7](LEKTOR-37.md#l-37.7): vor dem Release laufen lassen.

### <a id="l-38.7"></a>L-38.7 — was für Release v1.0.100 fehlt (nicht vorweggenommen)

Fortschreibung von [L-37.11](LEKTOR-37.md#l-37.11), jetzt für `v1.0.100`:

* **README:** *„Das neueste Release ist `v1.0.87`“* (`:130-138`, Datum, URL, Inhalt) → `v1.0.100`
  mit [E-105](../Intern/BEFUNDE.md#e-105), [E-118](../Intern/BEFUNDE.md#e-118) Teil 1 und 2, [E-121](../Intern/BEFUNDE.md#e-121) (Teile 1–8), [E-83](../Intern/BEFUNDE.md#e-83) zweite Ursache. Die vier
  Stellen *„im Download `v1.0.87` offen … noch nicht ausgeliefert“* ([E-105](../Intern/BEFUNDE.md#e-105) `:228`,
  [E-118](../Intern/BEFUNDE.md#e-118) `:237`, [E-121](../Intern/BEFUNDE.md#e-121) `:242-243`, [E-83](../Intern/BEFUNDE.md#e-83) `:255`). Der Defender-Abschnitt (`:477-478`) nennt
  *„das veröffentlichte `v1.0.87`“* und 1.0.99 als sauber, 1.0.100 nicht. *Auf einen Blick* sagt
  *„Stand Paket 1.0.100“* und *„Neu gegenüber v1.0.87“* – nach dem Release stimmt das weiter.
* **[E-105](../Intern/BEFUNDE.md#e-105) ginge ohne Gregors Urteil hinaus** (unverändert seit [L-37.11](LEKTOR-37.md#l-37.11)): *„von Gregor
  noch nicht bestätigt“*; die README sagt das in *Auf einen Blick* offen dazu – ob Gregors
  *„deine tests sollten reichen“* (zu 1.0.88) für das Release gilt, steht nirgends.
* **Releases/PAKETE.md:** Kopf `:6` und `:20` (*„zuletzt veröffentlicht 1.0.87“*); Abschnitt
  1.0.100 ohne Zeilen *Defender*, *Bei Gregor*, ZIP, SHA256, URL, *Freigabe* (Muster: 1.0.99 für
  Defender, 1.0.87 für das Release). **Ob 1.0.100 durch die Defender-Prüfung lief, steht nirgends**
  (CHANGELOG 7.2.0.100 und PAKETE schweigen; an 1.0.99 steht *„Defender sauber vor und nach den
  Läufen“*). Das Release-ZIP muss erneut durch `paket-pruefen.ps1`.
* **CHANGELOG:** Überschriften 7.2.0.88 bis 7.2.0.100 *„nicht veröffentlicht“* → *„enthalten in
  `v1.0.100`“* bzw. *„veröffentlicht als `v1.0.100`“*; *Noch offen*: [E-118](../Intern/BEFUNDE.md#e-118)
  *„noch nicht veröffentlicht“*, [E-121](../Intern/BEFUNDE.md#e-121) *„nicht veröffentlicht“*.
* **Übrige Standköpfe:** `WEITERMACHEN.md` *Quellstand*, *Paketnummer* und *Zuletzt gebaut und
  veröffentlicht* (`:38`); `ZIEL.md:47` und die Maßstabszeilen [E-118](../Intern/BEFUNDE.md#e-118)/[E-121](../Intern/BEFUNDE.md#e-121); `AUFGABEN.md:3`
  und `:124`; `PORTIERUNG.md:44`; `TESTPLAN.md:1` und `:195`; `tools/RELEASES.md` (neue Zeile
  mit Gregors Freigabe, Muster `v1.0.87`); `tools/ZWEIGE.md` (`e-121-mehrere-gesendete` nach dem
  Merge).
* **Nicht veröffentlichen:** 1.0.96 (F1 aus PRÜFER-30), 1.0.98 (Defender); 1.0.97 ungetestet;
  1.0.99 enthält PRÜFER-31 F1.

### <a id="l-38.8"></a>L-38.8 — was aus LEKTOR-37 geworden ist

| Punkt | Stand |
|---|---|
| [L-37.7](LEKTOR-37.md#l-37.7) PRÜFER/CHRONIST vor dem PR | PRÜFER erledigt ([PRÜFER-31](PRUEFER-31.md), fand F1); CHRONIST gelaufen (`ad6f984c`), jetzt wieder fällig; für 7.2.0.100 beide offen ([L-38.6](#l-38.6)) |
| [L-37.8](LEKTOR-37.md#l-37.8) erster Satz des E-121-Urteils | **offen**: `BEFUNDE.md:288` beginnt weiter *„… eingebaut in 7.2.0.90 …, von Gregor noch nicht bestätigt“*; der achte Teil wurde hinten angehängt |
| [L-37.9](LEKTOR-37.md#l-37.9) PRÜFER-30 F6 ohne Eintrag | **offen**, dazu jetzt PRÜFER-31 F2 ([L-38.4](#l-38.4)) |
| [L-37.10](LEKTOR-37.md#l-37.10) [E-122](../Intern/BEFUNDE.md#e-122)–[E-124](../Intern/BEFUNDE.md#e-124) in README und AUFGABEN | README erledigt (Tabelle *Bekannte Fehler*); `AUFGABEN.md` führt [E-122](../Intern/BEFUNDE.md#e-122) bis [E-124](../Intern/BEFUNDE.md#e-124) weiter nur im Kopf, ohne Aufgabenzeile – offen |
| [L-37.11](LEKTOR-37.md#l-37.11) Release v1.0.99 | ersetzt durch [L-38.7](#l-38.7) (v1.0.100) |
| [L-37.12](LEKTOR-37.md#l-37.12) TESTLAEUFE-Lauftexte | die sechs neuen Läufe an 7.2.0.100 (`n100a` bis `x100b`, 11:10–11:13) tragen einen eigenen, passenden Text; die alten Zeilen unverändert (Protokoll des Werkzeugs) |
| [L-37.13](LEKTOR-37.md#l-37.13) DLLs im Hauptbaum | **offen**: `git status` im Hauptbaum zeigt weiter ` M` an `DirServ.dll`, `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` – vor dem Paketbau des Release-ZIPs klären |
| [L-37.14](LEKTOR-37.md#l-37.14) TESTPLAN ohne Abschnitt ab 1.0.90 | **offen**: Teil C endet mit C5 (1.0.89); die Prüfschritte zu 1.0.100 stehen nur in `Releases/1.0.100/TESTEN.txt` |
| [L-37.15](LEKTOR-37.md#l-37.15) Hinweise `doku-pruefen.pl` | `Testdaten/README.md` unverändert (nicht belegbar), WERKZEUGE berichtigt ([L-38.3](#l-38.3)) |
