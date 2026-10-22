# <a id="lektor-27"></a>LEKTOR-27 — Die Dokumentation nach Gregors Test an 1.0.84

Lauf am 13.10.2026 auf `wt/lektor`, vor Gregors Merge von `e-112_e-113_fix`
nach `main`. Vorher `origin/e-112_e-113_fix` in `wt/lektor` gemergt (glatt,
vorgespult auf `25c0874`). Umfang: alle **103** `.md` aus `git ls-files '*.md'`
ohne `Arbeitsweise/`, gegen den **Bestand** gelesen, nicht gegen den Diff.
Die Berichte unter `Befunde/` sind Fahrtenbuch ihres Tages und bleiben, wie sie
sind.

Maßstab sind die Urteilszeilen in `BEFUNDE.md` von heute: Testplan Teil A
([E-49](../Intern/BEFUNDE.md#e-49), [E-50](../Intern/BEFUNDE.md#e-50), [E-52](../Intern/BEFUNDE.md#e-52) bis [E-63](../Intern/BEFUNDE.md#e-63)) von Gregor an 1.0.84 bestätigt;
[E-85](../Intern/BEFUNDE.md#e-85), [E-93](../Intern/BEFUNDE.md#e-93), [AN-2](../Intern/BEFUNDE.md#an-2) bestätigt; [E-83](../Intern/BEFUNDE.md#e-83) nachgemessen; [E-101](../Intern/BEFUNDE.md#e-101) wieder offen;
[E-112](../Intern/BEFUNDE.md#e-112) an 1.0.84 unverändert; [E-114](../Intern/BEFUNDE.md#e-114) und [E-115](../Intern/BEFUNDE.md#e-115) neu; die Annahme
*„frische INI startet in der Werbe-Betriebsart“* widerlegt.

Mechanisch zuerst: `doku-pruefen.pl` und `pruefe-stand-md.pl` **grün**,
`offene-befunde.pl` **rot** — und das zu Unrecht ([L-27.1](#l-27.1)). `pruefe-befundurteile.pl`
habe ich erst am Ende laufen lassen; es war **rot** ([L-27.14](#l-27.14)), und der
eingerichtete Haken ruft es gar nicht auf ([L-27.15](#l-27.15)). **Die übrigen Mängel hat
keine Schranke gefunden.**

## Mängel

### <a id="l-27.1"></a>L-27.1 — `tools/offene-befunde.pl` war seit heute früh blind für die eigene Tabelle

Ausgabe vor der Berichtigung:

```
    offen laut BEFUNDE.md      30
    in WEITERMACHEN.md          0
  FEHLEN (30): E-115, E-114, E-113, ...
```

Die Liste in `WEITERMACHEN.md` deckte inhaltlich genau dieselben 30. Seit
`eb5815d` steht sie nach `-schreiben` **und** `befunde-verlinken.pl --verlinken`
als `**[E-115](BEFUNDE.md#e-115)**` da; das Werkzeug suchte nur `**E-115**`.
Der `pre-commit` zeigt die Ausgabe bloß an, also fiel es niemandem auf — die
Schranke aus `CLAUDE.md` Schritt 1 meldete seit `eb5815d` bei jedem Aufruf
*„30 fehlen“*, und eine Meldung, die immer kommt, liest keiner. **Berichtigt** (`tools/offene-befunde.pl`,
eine Zeile): liest jetzt beide Formen. **Gegenprobe:** in einer Kopie
[E-115](../Intern/BEFUNDE.md#e-115) und [E-111](../Intern/BEFUNDE.md#e-111) entfernt und das erledigte [E-94](../Intern/BEFUNDE.md#e-94) eingesetzt → das Werkzeug meldet
genau diese beiden als fehlend und [E-94](../Intern/BEFUNDE.md#e-94) als zu viel. Danach am echten Baum:
30 gegen 30, *„Die Liste deckt die offenen Befunde.“* In `tools/WERKZEUGE.md`
nachgetragen.

### <a id="l-27.2"></a>L-27.2 — `CHANGELOG.md`: E-115 fehlte unter *Noch offen*, eine Bestätigung stand darunter

Dieselbe Klasse wie [L-18.4](LEKTOR-26.md#l-18.4), am Tag danach wieder: unter
*Noch offen (Stand 13.10.2026)* stand [E-114](../Intern/BEFUNDE.md#e-114), aber nicht [E-115](../Intern/BEFUNDE.md#e-115) — und als eigene
Zeile *„Testplan Teil A an 1.0.84 von Gregor bestätigt“*. Unter *Erreicht*
dagegen: *„**A-4** … **gebaut, nicht bestätigt** … Bestätigt ist nur die
Höhenänderung“*.

**Geändert (4 Stellen):** E-115-Zeile eingefügt; Bestätigungszeile aus *Noch
offen* entfernt und in die A-4-Zeile unter *Erreicht* übernommen (*erfüllt,
von Gregor an 1.0.84 bestätigt*); der Nachsatz zur Höhenänderung als Stand vor
dem 13.10. gekennzeichnet; die Zeile *„Encountered an improper argument beim
Anzeigen“* verweist auf [E-115](../Intern/BEFUNDE.md#e-115) als eigenen Befund mit derselben Meldung beim
Suchen. (Die beiden Stellen zu [AN-2](../Intern/BEFUNDE.md#an-2) im Abschnitt 7.2.0.80 stehen unter [L-27.4](#l-27.4).)

### <a id="l-27.3"></a>L-27.3 — `AUFGABEN.md`: die Hauptarbeit wartete noch, nachdem sie erledigt war

Wörtlich: *„## Die Hauptarbeit: vierzehn gebaute Behebungen warten auf Gregors
Urteil“*, *„### 1. Gebaut, nicht bestätigt — vierzehn Befunde“*, *„Dazu warten
sechs frische Behebungen auf sein Urteil: [E-85](../Intern/BEFUNDE.md#e-85) … [E-83](../Intern/BEFUNDE.md#e-83) … [E-93](../Intern/BEFUNDE.md#e-93)“*, und in *Was
sonst noch offen ist*: *„[E-49](../Intern/BEFUNDE.md#e-49) (A-4), [E-50](../Intern/BEFUNDE.md#e-50), [E-52](../Intern/BEFUNDE.md#e-52) — gebaut, nicht bestätigt“*.
Umgekehrt [E-101](../Intern/BEFUNDE.md#e-101) als erledigt (*„am laufenden Programm geprüft, 171 Tests“*).

**Und ein älterer Fehler, der damit auffiel:** *„[E-112](../Intern/BEFUNDE.md#e-112) … **Behoben in 7.2.0.76**,
noch nicht von Gregor bestätigt.“* — `BEFUNDE.md` führt [E-112](../Intern/BEFUNDE.md#e-112) seit dem
18.09.2026 als **WIEDER OFFEN** („Der Versuch in 7.2.0.76 wirkt nicht“), heute
an 1.0.84 erneut unverändert. Dieser Satz stand also fast vier Wochen falsch,
ausgerechnet zu dem Befund, nach dem der Zweig heißt.

**Geändert (7 Stellen):** Stand-Kopf ergänzt; beide Überschriften auf
*bestätigt* mit Stand-Kasten; *„warteten“* mit Stand des 13.10.; [E-101](../Intern/BEFUNDE.md#e-101) *wieder
offen*; [E-112](../Intern/BEFUNDE.md#e-112) *wirkt nicht, wieder offen*; in *Was sonst noch offen ist* die
bestätigte Zeile ersetzt durch [E-101](../Intern/BEFUNDE.md#e-101), [E-114](../Intern/BEFUNDE.md#e-114), [E-115](../Intern/BEFUNDE.md#e-115).

### <a id="l-27.4"></a>L-27.4 — die widerlegte Werbe-Betriebsart stand in neun Dateien weiter als Tatsache

`BEFUNDE.md` ([AN-2](../Intern/BEFUNDE.md#an-2)) hält seit heute fest: *„**WIDERLEGT** … `BUILD_BOX_OR_SITE_R_VERSION`
… **Er ist gesetzt** … `DEFAULT_SWM_MODE` = 2 … **Auch mit `Mode=0` nicht
auslösbar**“* und *„**Entscheidung Gregors** … die Werbe-Betriebsart wird nicht
weiter verfolgt“*. Nachgezogen hatte das nur zwei Zeilen (CHANGELOG 7.2.0.80
Punkt 1, AUFGABEN B6 *Was*). Stehen geblieben waren:

| Datei | Belegzitat | geändert |
|---|---|---|
| `BEFUNDE.md`, Urteilszeile [AN-2](../Intern/BEFUNDE.md#an-2) | *„Offen bleibt die eigentliche Frage: Eudora holt beim Start Werbung“* — in derselben Zelle wie die Messung, dass er es nicht tut | Vermerk *überholt* |
| `BEFUNDE.md`, Abschnitt [AN-2](../Intern/BEFUNDE.md#an-2) | *„Status: offen … am laufenden Programm nicht gemessen“*; Weg Punkt 1 *„Eine frische `Eudora.ini` bedeutet also: Werbung.“*; *Was dieser Befund nicht behebt* | Status neu, alter Wortlaut darunter; Widerlegungsvermerk; Kasten |
| `README.md`, *Was es nicht kann* | *„Eudora startet ohne Eintrag `[Settings] Mode` in der Werbe-Betriebsart … am laufenden Programm aber noch nicht gesehen“* | Absatz neu gefasst: behoben und bestätigt, Werbe-Erklärung widerlegt |
| `CHANGELOG.md`, 7.2.0.80 | Stand-Kasten *„nicht gemessen“*; *„Nicht behoben, und das ist die eigentliche Frage: Eudora holt beim Start weiterhin Werbung“* | Stand 13.10. ergänzt; Vermerk *überholt* |
| `AUFGABEN.md`, B6 | Überschrift *„am laufenden Programm nicht gemessen“*; *„Was offen bleibt — und zwar als Frage an Gregor“* | Überschrift; Zeile *Bestätigt*; Kasten *beantwortet* (Weg 3 ist schon der Zustand des Baus) |
| `TESTPLAN.md`, C2 | *„Eudora mit **frischer** `Eudora.ini` starten …, damit das Werbefenster wieder erscheint.“* | als widerlegt gekennzeichnet; `LogLevel=128159`-Zeilen als entfallen |
| `WEITERMACHEN.md`, *Der nächste Schritt* | *„Für [AN-2](../Intern/BEFUNDE.md#an-2) braucht die INI `Mode=0`“* — nach Gregors Entscheidung dagegen; Punkt 1 *„von [AN-2](../Intern/BEFUNDE.md#an-2) die Produktfrage“* | neu gefasst; *entschieden* |
| `ZIEL.md`, Stand-Kopf | *„[AN-2](../Intern/BEFUNDE.md#an-2) … am laufenden Programm **nicht** gemessen“* | *von Gregor an 1.0.84 bestätigt* |
| `PORTIERUNG.md`, Stand-Kasten | *„[AN-2](../Intern/BEFUNDE.md#an-2) … am laufenden Programm nicht gemessen“* | ebenso |
| `tools/ZWEIGE.md`, `fix_startup_page` | *„die Seite wird weiterhin abgerufen“* | Vermerk *überholt* |

### <a id="l-27.5"></a>L-27.5 — `TESTPLAN.md` widersprach seinen eigenen Haken

Die Kopfzeile nannte *„Teil A, C1, [E-83](../Intern/BEFUNDE.md#e-83) erledigt“* — C2, [E-85](../Intern/BEFUNDE.md#e-85) und [E-93](../Intern/BEFUNDE.md#e-93) trugen
darunter schon ✅. Teil A begann mit *„Alle vierzehn stehen in `BEFUNDE.md`
als „von Gregor noch nicht bestätigt"“* über vierzehn ✅. C3 hieß *„Die sechs,
die auf dein Urteil warten“* bei vier erledigten. **Geändert (3 Stellen):**
Kopfzeile, Satz zu Teil A, Überschrift C3 mit Stand (*offen: [E-95](../Intern/BEFUNDE.md#e-95), [E-96](../Intern/BEFUNDE.md#e-96)*).

### <a id="l-27.6"></a>L-27.6 — `WEITERMACHEN.md`: sechs Stellen hinter dem Stand

* Zeile *„VON GREGOR ZU PRÜFEN, 17.09.2026 — [E-101](../Intern/BEFUNDE.md#e-101) | die gespeicherte Datei
  ist jetzt für andere Programme brauchbar“* — an 1.0.84 durchgefallen. Jetzt
  *WIEDER OFFEN, 13.10.2026*, der alte Text als Stand vom 17.09. darunter.
* Zeile *„VON GREGOR ZU PRÜFEN, 17.09.2026 — [E-108](../Intern/BEFUNDE.md#e-108)“* — zwei Zeilen tiefer
  in derselben Tabelle: *„Zuletzt von Gregor bestätigt: 1.0.72 … [E-108](../Intern/BEFUNDE.md#e-108)“*. Ältere
  Schuld, gleiche Tabelle. Jetzt *BESTÄTIGT*.
* *„Zuletzt von Gregor bestätigt | **1.0.72 am 17.09.2026**“* — vorn 1.0.84
  (Teil A, [E-85](../Intern/BEFUNDE.md#e-85), [E-93](../Intern/BEFUNDE.md#e-93), [AN-2](../Intern/BEFUNDE.md#an-2)) und 1.0.84 am 12.10. ([E-94](../Intern/BEFUNDE.md#e-94)) ergänzt.
* *„A-4 … ist **gebaut und nicht bestätigt**“* → bestätigt.
* *„Der nächste Schritt gehört Gregor: vierzehn gebaute Behebungen warten auf
  sein Urteil“* samt Punkten 1–2 (A-4 und [E-50](../Intern/BEFUNDE.md#e-50) prüfen) → Kasten *überholt*.
* Der Stand-Satz vom 13.10. nannte [E-85](../Intern/BEFUNDE.md#e-85), [E-93](../Intern/BEFUNDE.md#e-93), [E-115](../Intern/BEFUNDE.md#e-115) nicht → ergänzt.

### <a id="l-27.7"></a>L-27.7 — `ZIEL.md`: A-4 und Kriterium 8 nannten den Stand vor dem Test

*„… von Gregor noch nicht bestätigt.** … Das seitliche Ziehen hat er noch nicht
beurteilt.“* (A-4) und in Kriterium 8 *„([E-50](../Intern/BEFUNDE.md#e-50)) und noch nicht nachgesehen“*.
Im Stand-Kopf: *„Noch nicht von ihm beurteilt sind [E-100](../Intern/BEFUNDE.md#e-100), **[E-101](../Intern/BEFUNDE.md#e-101)**, [E-103](../Intern/BEFUNDE.md#e-103) und
[E-104](../Intern/BEFUNDE.md#e-104)“*. **Geändert (4 Stellen).** Die **Urteile** der Kriterientabelle sind
unverändert — sie sind Gregors, nicht meine.

### <a id="l-27.8"></a>L-27.8 — `README.md`: E-101 nur als behoben, E-114 und E-115 nirgends

Die Liste *„Seit `v1.0.72` im Download enthalten“* führt *„die unbrauchbare
gespeicherte Datei (… [E-101](../Intern/BEFUNDE.md#e-101) …)“* als behoben, und *Was es nicht kann* kannte
weder das Wiederaufleben noch die zwei neuen Meldungen. Dazu im Absatz
`v1.0.83`: *„übersetzt, aber am Programm nicht gemessen, [AN-2](../Intern/BEFUNDE.md#an-2)“*. **Geändert
(5 Stellen):** Vermerk *wieder offen*; drei Absätze unter *Was es nicht kann*
([E-101](../Intern/BEFUNDE.md#e-101), [E-114](../Intern/BEFUNDE.md#e-114), [E-115](../Intern/BEFUNDE.md#e-115)) — Wortlaut aus den Urteilszeilen, nichts
dazuerfunden; `v1.0.83`-Absatz mit *seit 13.10. bestätigt*.

### <a id="l-27.9"></a>L-27.9 — `tools/WERKZEUGE.md` zählt Proben falsch

Zeile `arbeitsbaum-angleichen-tests.sh`: *„**11 Proben, vier Lagen**“*. Gezählt
an den `probe`-Aufrufen im Skript: **12** (Lage 1: 3, Lage 2: 2, Lage 3: 2,
Lage 4: 5). Berichtigt. **Nicht berichtigt, nur gemeldet:** vier Werkzeuge
stehen **zweimal** in der Tabelle, mit verschiedenem Text
(`arbeitsbaum-angleichen.sh`, `arbeitsbaum-angleichen-tests.sh`,
`pruefe-anzeigetext.pl`, `pruefe-behoben-belegt.pl`; Zeilen 26–29 und
115–118). Welche Fassung bleibt, ist eine Entscheidung über den Inhalt.

### <a id="l-27.10"></a>L-27.10 — `Releases/PAKETE.md`: 1.0.84 ohne Gregors Ergebnis

Der Abschnitt des Pakets, an dem heute getestet wurde, sagte dazu nichts.
Zeile *Gregors Test, 13.10.2026* eingefügt (bestätigt, durchgefallen, neu).
In den Abschnitten 1.0.29 und 1.0.27 standen [E-49](../Intern/BEFUNDE.md#e-49), [E-50](../Intern/BEFUNDE.md#e-50), [E-52](../Intern/BEFUNDE.md#e-52) als
*„nicht bestätigt“* / *„noch nicht beurteilt“* und [E-63](../Intern/BEFUNDE.md#e-63) als *„offen, von Gregor
zurückgestellt“* — als Stand des jeweiligen Pakets richtig, jetzt mit Nachsatz
*von Gregor an 1.0.84 bestätigt am 13.10.2026* (4 Stellen).

**Nicht berichtigt, nur gemeldet:** derselbe Abschnitt 1.0.29 führt
[E-54](../Intern/BEFUNDE.md#e-54) bis [E-58](../Intern/BEFUNDE.md#e-58) und [E-61](../Intern/BEFUNDE.md#e-61) als *„behoben, von Gregor bestätigt“*; `BEFUNDE.md`,
`AUFGABEN.md` und `TESTPLAN.md` sagten bis heute, **alle vierzehn** seien von
Gregor nicht bestätigt gewesen. Eine der beiden Darstellungen war falsch; aus
den Dokumenten allein ist nicht zu entscheiden, welche. Seit heute ist es
folgenlos, weil alle vierzehn bestätigt sind.

### <a id="l-27.11"></a>L-27.11 — `tools/ZWEIGE.md`: drei Zeilen byteidentisch doppelt

`e94-betreff-faltung`, `release-v1.0.84` und `fix_startup_page` (12.10.2026)
standen je zweimal da, mit `cmp` als gleich gemessen — Rest eines Merges.
Die zweite Folge entfernt. (`e94-betreff-faltung` vom **14.09.2026** ist ein
anderer, früherer Eintrag und bleibt.)

### <a id="l-27.12"></a>L-27.12 — `BEFUNDE.md` vermisst sich wieder

*„Gemessen am 12.10.2026: **8614 Zeilen**“* — gemessen vor diesem Lauf 8616,
nach ihm **8630** (`wc -l`), 128 und 233 Abschnitte unverändert. Berichtigt.

### <a id="l-27.13"></a>L-27.13 — der `pre-commit` spiegelt fremde Lehren in diesen Arbeitsbaum und weist dann ab

Mitten im Lauf schlug ein Commit fehl: `lehren-uebersicht … FEHLEN in der
Tabelle (1): CHRONIST-2026-10-13`. Ursache: `tools/lehren-spiegeln.pl` (Schritt
2 des `pre-commit`) kopiert das Gedächtnis des Assistenten nach `Arbeitsweise/`
**des Baums, in dem gerade committet wird**. Der CHRONIST hatte um 10:22 Uhr
seinen Lauf ins Gedächtnis geschrieben (Commit `0126640` auf `wt/chronist`);
mein nächster Commit spiegelte die zwölf Dateien hierher, und die
Übersichtsschranke sah eine Lehre ohne Tabellenzeile. Die gespiegelten Dateien
sind mit `0126640` byteidentisch (gemessen mit `cmp`).

**Gelöst ohne fremde Dateien zu committen:** `lehren-uebersicht.pl -schreiben`
setzt `Arbeitsweise/README.md` auf genau den Inhalt aus `0126640` (`cmp`:
gleich). Die zwölf Dateien liegen **ungestaget** in `wt/lektor` und kommen mit
dem Merge von `wt/chronist` regulär an. **Folge für jeden Arbeitsbaum:** nach
jedem CHRONIST-Lauf weist der erste Commit dort ab, bis die Übersicht
nachgezogen ist — und wer dann `git merge` macht, stößt auf ungestagte
Änderungen an denselben Dateien.

### <a id="l-27.14"></a>L-27.14 — `pruefe-befundurteile.pl` war rot, und kein Haken hat es gesagt

Erst am Ende dieses Laufs gestartet — das hätte am Anfang stehen müssen. Fünf
Beanstandungen: vier Nennungen von [E-101](../Intern/BEFUNDE.md#e-101) mit *„behoben“* im Umfeld (CHANGELOG
Nachtrag zu 1.0.70 und Abschnitt 7.2.0.69, WEITERMACHEN Zeilen *Was ich am
17.09.2026 falsch gemacht habe* und *BESTÄTIGT — [E-97](../Intern/BEFUNDE.md#e-97)*), seit `6d4022f` rot,
weil [E-101](../Intern/BEFUNDE.md#e-101) heute wieder offen ist; und **eine von mir**: mein Verweis auf
[E-115](../Intern/BEFUNDE.md#e-115) in der Zeile *„Encountered an improper argument“*, in der *„seit [E-43](../Intern/BEFUNDE.md#e-43)
behoben“* steht. Alle fünf mit *wieder offen* / *offener* an der Kennung
versehen; danach Rückgabe 0.

### <a id="l-27.15"></a>L-27.15 — der eingerichtete `pre-commit` ist vom 18.09.2026

`.git/hooks/pre-commit` (gemeinsam für alle Arbeitsbäume) trägt den Zeitstempel
**18.09.2026 08:33**; `tools/hooks-einrichten.sh` wurde zuletzt am
**12.10.2026** geändert (`4da8408`, Zweig `befundurteile-einhaengen`). Gemessen
durch Vergleich der aufgerufenen Werkzeuge: im Installer, **nicht** im
eingerichteten Haken stehen `pruefe-befundurteile.pl` und
`befunde-verlinken.pl`. Deshalb liefen alle Commits dieses Tages durch, obwohl
[L-27.14](#l-27.14) rot war. **Nicht behoben:** `hooks-einrichten.sh` schreibt in das
gemeinsame `.git/hooks` des Hauptbaums; das neu einzurichten ist Gregors
Entscheidung, nicht die eines Arbeitsbaums.

## Was nicht berichtigt ist

* Die **Fassungsabschnitte** in `CHANGELOG.md` (*„Von ihm noch nicht
  bestätigt“* unter 7.2.0.5x/6x) sind Stand ihres Tages; der lebende Teil
  (*Noch offen*, *Erreicht*) ist nachgezogen.
* **Ob [E-115](../Intern/BEFUNDE.md#e-115) dieselbe Stelle ist wie die Meldung „Encountered an improper
  argument“ beim Anzeigen**, an der Kriterium 2 und 4 hängen, ist nicht
  gemessen. Verwiesen ist, gleichgesetzt nicht.
* `WEITERMACHEN.md` enthält in der Zeile *Zuletzt von Gregor bestätigt* eine
  echte Mailadresse aus einem IMAP-Protokoll. `pruefe-testdaten-anonym.pl`
  prüft nur `Testdaten/`. Ob sie stehen bleiben soll, entscheidet Gregor.
* Die vier doppelten Werkzeugzeilen ([L-27.9](#l-27.9)) und der Widerspruch im Abschnitt
  1.0.29 ([L-27.10](#l-27.10)).
* `doku-pruefen.pl` *zur Kenntnis*: `Testdaten/README.md`, `tools/WERKZEUGE.md`
  und `tools/pruefdaten/LIESMICH.md` nennen den Quellstand 7.2.0.84 nicht —
  keine davon trägt einen Stand-Kopf, der es verlangte.
