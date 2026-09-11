# PRUEFER-8 — Vier Schranken zu E-80, E-81 und der Zertifikatsprüfung, und was beim Nachmessen nicht stimmte

| | |
|---|---|
| Datum | 11.09.2026 |
| Arbeitsbaum | `C:\Users\Gregor\Documents\github\Eudora7.2-wt-pruefer` |
| Zweig | `wt/pruefer`, Stand von `origin/main` (`a1a4c31`) |
| Gemessen an | dem Quelltext selbst, den Commits `567a5d8`, `83c80fa`, `b3be298`, `f0952d2` und den sieben Postfächern in `C:\Users\Gregor\Eudora72-1.0.44-release\Mailverzeichnis` (134 Nachrichten) |
| Nicht getan | **nicht gebaut, kein Programm gestartet.** Geändert wurden nur `tools/` und diese Datei |

**Kurzfassung.** Vier Schranken gebaut, jede mit einer eigenen Gegenprobe;
zusammen **55 Gegenproben**, davon **53 grün auf Anhieb**, alle 55 grün nach
zwei Korrekturen an meinen eigenen Schranken. Vier der Gegenproben fahren den
**echten Fehler** aus dem Commit vor der jeweiligen Behebung, und jede dieser
vier hat ihn gefangen.

Beim Nachmessen sind **vier Angaben widerlegt** worden, die in `BEFUNDE.md`
und in `tools/taboo-rechnen.pl` stehen. Die wichtigste: `taboo-rechnen.pl`
rechnete mit der Kopfzeilenliste von **2006**, nicht mit der aus der
Ressource — also mit genau der Liste, deren Unzulänglichkeit der Befund E-80
festgestellt hat.

---

## 1. Die vier Schranken

| Schranke | bewacht | Gegenproben | fängt den echten Fehler |
|---|---|---|---|
| `tools/pruefe-taboo-liste.pl` | E-80, Teil 1 — die Liste `TabooHeaders` | **17** (12 melden, 5 still) | ja: „Originalliste allein — der Stand vor der Behebung" |
| `tools/pruefe-blahblah-knopf.pl` | E-80, Teil 2 — der Knopfzustand | **13** (8 melden, 5 still) | ja: die echten Dateien aus `567a5d8` |
| `tools/pruefe-kopfzeilen-stil.pl` | E-81 — Kopfzeilen auf dunklem Grund | **13** (8 melden, 5 still) | ja: die echte `EudoraRes.rc` aus `83c80fa` |
| `tools/pruefe-zertifikatspruefung.pl` | `iOK = 1` im Fehler-`switch` | **12** (7 melden, 5 still) | ja: der Stand in `main` |

Jede meldet bei Fehlschlag **was fehlt, warum es zählt und was zu tun ist**.
Jede holt ihren Umfang aus der Quelle, keine aus einer Liste von Hand.

**Zwei Eigenschaften sind es wert, einzeln genannt zu werden:**

*Die Knopf-Schranke zählt die Ansichten nicht ab.* Sie liest jede
Botschaftstabelle im Quelltext und prüft jede Klasse, die den Klick auf
`ID_BLAHBLAHBLAH` an sich bindet. Eine dritte Ansicht, die das Umschalten
vergisst, wird gefunden, ohne dass jemand die Schranke anfassen muss — der
Testfall „eine DRITTE Ansicht kommt dazu und vergisst das Umschalten" belegt
es.

*Beide Code lesenden Schranken werfen Kommentare weg.* Die Begründung der
Behebung zu E-80 nennt selbst `GetCheck(ID_BLAHBLAHBLAH)`, und zwar **vor**
dem Umschalten; die Begründung zur Zertifikatsprüfung zitiert `iOK = 1;`
wörtlich. Eine Schranke, die Kommentare mitliest, schwärzt ihre eigene
Begründung an. Je ein Testfall hält das fest.

### Die Zertifikats-Schranke meldet auf `main`, sie scheitert nicht

Die Behebung liegt nicht in `main`, sondern auf `zertifikate` (`b3be298`).
Eine Schranke, die vom ersten Tag an rot steht, wird binnen einer Woche mit
`--no-verify` umgangen. Deshalb: ohne `--streng` meldet sie und gibt 0
zurück, mit `--streng` gibt sie 1. **Sobald der Zweig gemergt ist, gehört sie
mit `--streng` in die Vorcommit-Liste.** Das steht im Kopf der Datei und in
`tools/WERKZEUGE.md`.

### Zwei Fehlalarme in meinen eigenen Schranken, beide gefunden

1. Die Stil-Schranke meldete die **heile** Fassung. Grund: in der `.rc`
   stehen Zeilenumbrüche als die *Zeichen* Backslash-r und Backslash-n; vor
   `SPAN.EUDORAHEADER` steht damit ein `n`, kein Leerraum. Jetzt löst sie die
   Escapes auf, wie der Ressourcenübersetzer es tut.
2. Die Gegenprobe zur Knopf-Schranke **übersprang** ihren wichtigsten Fall.
   Grund: der `git show`-Befehl wurde im Backtick-Ausdruck zusammengesetzt,
   die Verkettung geschah also nach dem Aufruf — der Befehl endete auf `2>`.
   Aufgefallen ist es nur, weil die Gegenprobe das Überspringen **laut**
   meldet, statt es zu verschweigen.

---

## 2. Was beim Nachmessen nicht gestimmt hat

### 2.1 `taboo-rechnen.pl` rechnete mit der Liste von 2006 — der schwerste Punkt

Das Werkzeug trug die Liste mit **28** Einträgen fest eingebaut. `EudoraRes.rc`
führt **44**. Wer es ohne `TABOO=<datei>` aufrief, bekam die Antwort, die vor
der Behebung galt.

Gemessen an `In.mbx` (72 Nachrichten):

| Liste | „bleibt stehen" |
|---|---|
| eingebaut (2006, 28 Einträge) | **62** Namen |
| `EudoraRes.rc:9996` (44 Einträge) | **7** Namen |

55 Kopfzeilennamen wurden falsch einsortiert, darunter genau die, um die es
bei E-80 geht: `DKIM-Signature`, `Authentication-Results`, `Envelope-To`,
`Delivered-To`, sämtliche `X-*`, `User-Agent`, `UI-OutboundReport`.

**Abgestellt:** die Liste kommt jetzt aus `EudoraRes.rc`. Fehlt sie dort,
bricht das Werkzeug ab, statt still mit einer Kopie weiterzurechnen.

### 2.2 Fünf weitere Rechenfehler, vier davon abgestellt

Eine Gegenprobe mit **18 Fällen gegen den C-Code** (`tools/taboo-rechnen-tests.pl`)
hat sieben Abweichungen gefunden. Neben 2.1:

| Was | wie es Eudora macht | Stand |
|---|---|---|
| Kopfzeile **ohne Doppelpunkt** | beendet die **gesamte** Kopfzeilenverarbeitung (`TridentReadMessageView.cpp:2454-2458`, „no more headers") — das Werkzeug übersprang nur diese Zeile | abgestellt |
| Name vor dem Doppelpunkt | jedes Zeichen ist erlaubt — das Werkzeug ließ nur `[A-Za-z0-9_-]` zu, sah `X.Foo:` und `X-Spam Flag:` also gar nicht an | abgestellt |
| letzte Nachricht **ohne Leerzeile** nach dem Kopf | alles gilt als Kopfteil (`msgutils.cpp:333`, `MimeStorage.cpp:422`) — das Werkzeug ließ sie **stillschweigend** weg und meldete trotzdem die volle Nachrichtenzahl | abgestellt |
| Vorspann vor der ersten Trennerzeile | keine Nachricht — das Werkzeug zählte ihn mit, sobald irgendwo ein Doppelpunkt darin stand | abgestellt |
| Trennerzeichenkette **im Nachrichtenkörper** | Eudora findet Nachrichten über die `.toc`-Offsets, der Körper wird nie abgesucht | **bleibt**, siehe unten |

Der letzte Punkt ist von außen ohne die `.toc` nicht zu entscheiden. Er ist
als **bekannte Grenze** im Kopf des Werkzeugs begründet, und die Gegenprobe
nennt ihn bei jedem Lauf — sie meldet außerdem, wenn er eines Tages
**verschwindet**, damit die Begründung nicht veraltet stehen bleibt. An den
134 echten Nachrichten tritt er nicht auf (die Zeichenkette kommt 134-mal
vor und jedes Mal als echter Trenner).

Stand jetzt: **17 von 18 Fällen wie erwartet, 1 bekannte Grenze**, Rückgabe 0.

### 2.3 „175 Nachrichten" — im heutigen Bestand sind es 134

`BEFUNDE.md`, `CHANGELOG.md` und `README.md` sagen, die Rechnung sei an
**175 echten Nachrichten aus sechs Postfächern** gefahren worden.

Gemessen am 11.09.2026 in jedem Laufverzeichnis von 1.0.42 bis 1.0.48:

| Verzeichnis | Trennerzeilen |
|---|---|
| `Eudora72-1.0.42-release` | 87 |
| `Eudora72-1.0.43` bis `1.0.48-release` | **134** |

Sieben `.mbx`, davon sechs mit Inhalt (`Trash.mbx` ist leer) — „sechs
Postfächer" stimmt also. Die **175** ist nicht zu reproduzieren. Nimmt man
die Sicherungskopien `In.mbx.001` und `In.mbx.002` hinzu, kommt man auf 200,
nicht auf 175. Ich kann nicht sagen, woher die Zahl stammt; ich kann nur
sagen, dass sie im heutigen Bestand nicht herauskommt.

### 2.4 „genau acht Kopfzeilen bleiben" — es sind zehn

`BEFUNDE.md` nennt acht: `From`, `To`, `Cc`, `Bcc`, `Subject`, `Date`,
`Reply-To`, `Sender`. Nachgerechnet mit der berichtigten Fassung über alle
sieben Postfächer, 134 Nachrichten, mit der Liste aus `EudoraRes.rc`:

```
   134x To          43x Cc           3x Sender
   134x Subject     42x Bcc          3x Referer     <- fehlt in der Aufzählung
   134x From         9x Reply-To     2x CC          <- Schreibvariante von Cc
    92x Date
```

**Zehn Namen**, oder neun, wenn man `CC` und `Cc` zusammenzieht.

`Referer:` ist der inhaltlich neue Punkt: eine technische Kopfzeile, die der
Knopf **nicht** versteckt. Sie überlebt, weil der Listeneintrag `References`
zehn Zeichen lang ist und `Referer: ` nicht trifft — der Präfixvergleich
greift nur in der einen Richtung. In den drei betroffenen Nachrichten ist die
Zeile sogar leer (`Referer:` ohne Wert).

**Offen, für Gregor zu entscheiden:** `Referer` auf die Liste zu setzen wäre
ein Einzeiler in `EudoraRes.rc`. Ich habe es **nicht** getan — das ist eine
Änderung an einer Behebung, die er bereits bestätigt hat, und sie gehört
nicht in einen Prüfauftrag. Die Schranke `pruefe-taboo-liste.pl` lässt einen
solchen Eintrag ausdrücklich zu (Testfall „heutiger Stand plus ein harmloser
weiterer Eintrag").

### 2.5 Zwei Zeilennummern in der Doku stimmen nicht

Der Präfixvergleich steht nicht auf `TridentReadMessageView.cpp:2444` und
nicht auf `ReadMessageDoc.cpp:499`, sondern auf **2465** und **504**.

Über die Historie verfolgt:

* `TridentReadMessageView.cpp`: vor der Behebung zu E-80 Teil 2 (`567a5d8`)
  stand die Stelle auf **2445**, nicht 2444 — die Angabe war schon damals um
  eins daneben. Der Patch hat 21 Zeilen davor eingefügt, seither ist es 2465.
* `ReadMessageDoc.cpp`: die Stelle steht in **jedem** Commit des Repos auf
  504. Die 499 war **nie** richtig.

Alle übrigen Zeilenangaben zu E-80 und E-81 habe ich einzeln nachgemessen und
**bestätigt**: `ReadMessageFrame.cpp:179`, `:498`, `:688`, `:981`,
`TridentReadMessageView.cpp:161`, `PgReadMsgView.cpp:72`,
`summary.cpp:2518-2520`, `TridentView.cpp:1329-1332` und `:1425`.

`tools/taboo-rechnen.pl` und `tools/taboo-rechnen-tests.pl` nennen jetzt die
gemessenen Nummern. **In `BEFUNDE.md` und `CHANGELOG.md` stehen sie noch
falsch** — `CHANGELOG.md` ist am 11.09.2026 in der Hand von LEKTOR und war
für mich gesperrt.

---

## 3. Was noch offen ist

1. **`BEFUNDE.md` E-80** trägt drei widerlegte Angaben: 175 Nachrichten
   (gemessen 134), „genau acht" Kopfzeilen (gemessen zehn) und die
   Zeilennummern 2444/499 (gemessen 2465/504).
2. **`CHANGELOG.md`** nennt dieselben 175 Nachrichten. Nicht angefasst.
3. **`README.md:185`** nennt ebenfalls 175 Nachrichten.
4. **`Referer:`** bleibt sichtbar, siehe 2.4.
5. **`pruefe-zertifikatspruefung.pl --streng`** gehört in die Vorcommit-Liste,
   sobald `zertifikate` gemergt ist.
6. Im Arbeitsbaum liegt ein **Stash** (`stash@{0}`) mit einer älteren
   `Releases/PAKETE.md`-Zeile zu 1.0.42 aus einem früheren PRÜFER-Lauf.
   `doku-pruefen.pl` läuft ohne ihn auf 0; ich habe ihn liegen lassen, statt
   fremdes Material zu verwerfen.

---

## 4. Vorcommit-Prüfungen

| Prüfung | Rückgabe |
|---|---|
| `tools/doku-pruefen.pl` | 0 |
| `tools/pruefe-bytes.pl` | 0 |
| `tools/pruefe-befundurteile.pl` | 0 |
| `tools/pruefe-ini-abschnitte.pl` | 0 |
| `tools/spuren-auswerten.pl` | 0 |
| `tools/pruefe-taboo-liste-tests.pl` | 0 (17 von 17) |
| `tools/pruefe-blahblah-knopf-tests.pl` | 0 (13 von 13) |
| `tools/pruefe-kopfzeilen-stil-tests.pl` | 0 (13 von 13) |
| `tools/pruefe-zertifikatspruefung-tests.pl` | 0 (12 von 12) |
| `tools/taboo-rechnen-tests.pl` | 0 (17 von 18, 1 bekannte Grenze) |
