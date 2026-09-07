---
name: pruefumfang-nicht-von-hand
description: "Prueflisten und Agentenauftraege holen ihren Umfang aus der Quelle; was von Hand aufgezaehlt wird, prueft genau das nicht, woran niemand gedacht hat"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:28:27.764Z
---

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
