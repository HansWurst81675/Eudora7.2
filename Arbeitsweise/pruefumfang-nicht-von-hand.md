---
name: pruefumfang-nicht-von-hand
description: "Prueflisten und Agentenauftraege holen ihren Umfang aus der Quelle; was von Hand aufgezaehlt wird, prueft genau das nicht, woran niemand gedacht hat"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:28:27.764Z
---

Schranke: tools/doku-pruefen.pl (pre-commit, pre-push — holt seine Dateiliste aus git ls-files, nicht aus einer gepflegten Aufzählung)

# Der Umfang einer Prüfung darf nicht von Hand aufgezählt werden

**Gregor am 07.09.2026, 08:15 Uhr**, nachdem er in drei Dateien hintereinander
veraltete Zahlen gefunden hatte:

> *„und ich möchte dir nicht jede einzelne MD datei nennen, es betrifft ALLE!
> klar?"*

Kurz davor, auf die Frage, ob der Lektor alle Dateien angesehen habe:

> *„der lektor sollte doch alle MDs regelmäßig prüfen."*
> *„hat lektor all dies angeschaut und geprüft und verglcihen? alle MDs?"*

## Was tatsächlich passiert ist

Gemessen am 07.09.2026: **47 MD-Dateien im Repo, 31 kommen in `LEKTORAT.md`
vor, 16 nie** — darunter `AGENTEN.md` und 14 Befund-Dateien. Und
`tools/doku-pruefen.pl`, die Schranke, die ich als Antwort auf genau diesen
Fehler gebaut hatte, prüfte **drei** Dateien: `ZIEL.md`, `CHANGELOG.md`,
`README.md`. `AUFGABEN.md` und `LEKTORAT.md` — die beiden, in denen Gregor
dann die veralteten Sätze fand — standen nie auf ihrer Liste.

Das ist kein Versagen des Lektors. Mein eigenes Eingeständnis im Protokoll
(07.09., 08:17): *„Den Auftrag habe ich zugeschnitten: der Lektor bekam von mir
jedes Mal eine Handvoll Dateien genannt, nie alle. Ein Prüfer, der drei Dateien
liest, kann in den anderen 44 nichts finden."*

**Der Kern:** Eine von Hand aufgezählte Liste enthält genau die Dateien, an die
ich gedacht habe. Der Fehler sitzt aber immer in denen, an die ich nicht
gedacht habe. Eine solche Liste prüft also systematisch am Fehler vorbei — und
sieht dabei wie Deckung aus.

**Warum:** Gregor darf nicht der Vollständigkeitsprüfer sein. Er hat es dreimal
in derselben Stunde sein müssen (`AUFGABEN.md`, `CHANGELOG.md`,
`PORTIERUNG.md`), und sein Schluss war schon am Vortag: *„ich traue dir nicht
ganz, jemand soll dich immer wieder überprüfen - das bin aber nicht ich!"*

**Wie anwenden:**

1. **Jede Schranke holt sich ihre Dateiliste selbst** — aus `git ls-files`,
   aus einem Glob, aus dem Verzeichnis. Kein hartkodierter Dateiname, außer als
   *Quelle* eines Wertes (`ZIEL.md` führt die Kriterien), nie als Umfang der
   Prüfung.
2. **Ausnahmen werden am Merkmal erkannt, nicht am Namen.** Ein Zeitdokument,
   das alte Zahlen nennen darf, sagt das in seinem eigenen Kopf (Datumszeile);
   die Schranke liest das Merkmal. Eine Namensliste von Ausnahmen veraltet
   genauso wie eine Namensliste von Prüflingen.
3. **Im Agentenauftrag steht der Umfang als Regel, nicht als Aufzählung:**
   „alle MD-Dateien aus `git ls-files '*.md'`", nicht „sieh dir README,
   CHANGELOG und ZIEL an". Wenn ich die Dateien aufzählen will, gehört in den
   Auftrag zusätzlich der Satz: *nenne, was du außerhalb dieser Liste
   gefunden hast.*
4. **Die Probe:** Zähle, was die Schranke gelesen hat, und vergleiche es mit
   dem Bestand. `perl tools/doku-pruefen.pl` muss sagen können, wie viele
   Dateien es geprüft hat — steht dort eine kleinere Zahl als im Repo, ist die
   Prüfung unvollständig, unabhängig vom Ergebnis.

Siehe [[review-sieht-nur-den-diff]], [[doku-parallel-nicht-hinterher]],
[[mannschaft-fuehren]] und [[fehlerklassen-abstellen]].

## Nachtrag 11.09.2026: der Umfang steckte diesmal im Werkzeug, im Zählbefehl und im Paket

Drei Fälle an einem Tag, alle derselben Bauart — der Umfang war von Hand
festgelegt, und geprüft wurde genau das nicht, was zu prüfen war.

### 1. `tools/taboo-rechnen.pl` trug die Liste von 2006 fest eingebaut

Das Werkzeug soll ausrechnen, welche Kopfzeilen der Knopf *Blah Blah Blah*
stehen lässt. Die Liste, gegen die es rechnete, stand **im Skript**: 28
Einträge, der Stand von 2006. `EudoraRes.rc` führt seit der Behebung zu E-80
**44**. Wer es ohne `TABOO=<datei>` aufrief, bekam die Antwort, die **vor** der
Behebung galt — von dem Werkzeug, mit dem die Behebung belegt werden sollte.

Gemessen an `In.mbx`, 72 Nachrichten (`Befunde/PRUEFER-8.md`, 2.1):

| Liste | „bleibt stehen" |
|---|---|
| eingebaut (2006, 28 Einträge) | **62** Namen |
| `EudoraRes.rc:9996` (44 Einträge) | **7** Namen |

55 Namen falsch einsortiert, darunter genau die, um die es bei E-80 geht:
`DKIM-Signature`, `Authentication-Results`, sämtliche `X-*`, `User-Agent`.
Gefunden hat es PRÜFER. Abgestellt: die Liste kommt jetzt aus der `.rc`, und
fehlt sie dort, bricht das Werkzeug ab, statt still mit der Kopie
weiterzurechnen.

**Das ist Punkt 1 dieser Lehre, eine Ebene tiefer.** Er sagte bisher: eine
Schranke holt sich die **Dateiliste** aus der Quelle. Er gilt genauso für die
**Daten**: eine eingebaute Kopie einer Liste, einer Tabelle, einer Vorgabe ist
ein Umfang von Hand. Sie veraltet in dem Moment, in dem die Quelle sich ändert —
und das ist regelmäßig genau der Moment, in dem gemessen wird.

### 2. Der Zählbefehl reichte eine Ebene tief

Beim Übernehmen von Gregors Mailverzeichnis habe ich nachgemessen und **31
Dateien** gezählt. Das sah vollständig aus. Nachgemessen am 11.09.2026 an
`C:\Users\Gregor\Eudora72-1.0.48-release\Mailverzeichnis`: oberste Ebene 31,
**rekursiv 153**, davon 43 unter `Imap\`. Die Nachmessung war nicht falsch, sie
war **flach** — und eine flache Zählung über ein Verzeichnis mit zwölf
Unterverzeichnissen meldet immer eine beruhigende Zahl
([[werkzeug-vor-eigenbau]], Fall 1).

**Also:** jede Zählung über ein Verzeichnis nennt ihre Tiefe. „31 Dateien" ohne
den Zusatz *oberste Ebene* oder *rekursiv* ist keine Zahl, sondern eine
Behauptung.

### 3. `paket-pruefen.ps1` prüfte die Dateien, die es kennt

Der Bau erzeugte am 11.09. eine frische `QCSSL.dll` (10:56, 2.921.472 B); im
fertigen Paket lag die alte aus der Grundlage (30.08., 2.920.960 B). Der
Zertifikats-Patch ändert genau diese eine DLL. `paket-pruefen.ps1` hat nichts
gemeldet — **es kennt die Datei nicht**, weil seine Prüfliste von Hand gepflegt
ist. Aufgefallen ist es nur, weil beim Bereitstellen zufällig der Zeitstempel
mit ausgegeben wurde ([[paket-gegen-den-bau-messen]]).

**Vorschlag an PRÜFER, nicht von mir gebaut:** `paket-pruefen.ps1` soll seinen
Umfang aus `Eudora71/Bin/<Bauart>/` holen — jede dort erzeugte Datei, die auch
im Paket liegt, wird nach Größe und Zeitstempel verglichen; was der Bau erzeugt
und im Paket **fehlt**, wird genannt. Dann fällt die nächste DLL auf, an die
niemand gedacht hat.
