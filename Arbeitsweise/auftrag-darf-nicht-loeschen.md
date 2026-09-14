---
name: auftrag-darf-nicht-loeschen
description: "Ein Auftrag, der die Arbeit des Beauftragten verwirft, ist ein eigener Fehler - zwei von zwei Auftraegen trugen reset --hard"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-14T06:26:06.824Z
---

Schranke: tools/arbeitsbaum-angleichen.sh (erster Schritt jedes Agentenauftrags)

# Der erste Schritt eines Auftrags darf nichts wegwerfen

Am 13.09.2026 gingen abends zwei Agentenaufträge hinaus. Sie trugen beide
dieselbe erste Zeile:

| Uhrzeit | Auftrag | Arbeitsbaum | erste Zeile |
|---|---|---|---|
| **20:24:44** | *Spurmarke IMAP-Zeichensatz* | `wt/pruefer` | `fetch origin && reset --hard origin/fix-imap_utf8` |
| **20:25:12** | *E-83 hängende IMAP-Aufgabe* | `wt/chronist` | `fetch origin && reset --hard origin/fix-imap_utf8` |

**28 Sekunden auseinander. Zwei von zwei.** Das war keine Unachtsamkeit in
einem Einzelfall, sondern eine Vorlage: ich habe den ersten Auftrag getippt
und den zweiten daraus kopiert.

Auf `wt/pruefer` lagen zu diesem Zeitpunkt **vier eigene Commits**, darunter
die Behebung eines Schreibzugriffs hinter den Puffer. PRÜFER hat die Zeile
nicht ausgeführt, sondern cherry-gepickt und es in seinem Bericht vermerkt.
Der Fehler war meiner; gerettet hat ihn der Beauftragte.

## Der Nachfolger war auch falsch — gemessen am nächsten Morgen

Nach dem Vorfall habe ich die Zeile ersetzt durch

    ZUERST: git -C <Arbeitsbaum> fetch origin, dann
            git -C <Arbeitsbaum> merge --ff-only origin/fix-imap_utf8
            (NICHT reset --hard - auf deinem Zweig liegen eigene Commits)

Am **14.09.2026** bin ich als erster damit losgelaufen. Ergebnis:

    fatal: Not possible to fast-forward, aborting.

Und zwar **genau in der Lage, für die der Satz geschrieben war**: ein eigener
Commit auf dem Zweig, 19 Commits Rückstand. Danach musste ich von Hand
entscheiden — `rebase` wurde von der Genehmigung abgelehnt, `merge` erzeugte
Konflikte in `BEFUNDE.md` und `CHANGELOG.md`, und all das vor dem ersten
inhaltlichen Handgriff.

**Why:** Eine gefährliche Anweisung wird gern durch eine **vorsichtige**
Anweisung ersetzt. Vorsichtig heisst hier: sie tut in der Normallage
dasselbe und **bricht in der Ausnahmelage ab**. Damit ist der Schaden
vermieden und das Problem verschoben — der Beauftragte steht mit einem
abgebrochenen Befehl da, im ersten Arbeitsschritt, ohne Kontext, und muss
die Entscheidung treffen, die ich ihm abnehmen wollte. Zwei Auftraggeber-Fehler
hintereinander, derselbe Ursprung: **im Auftrag stand ein Git-Befehl statt
eines Werkzeugs.** Ein Befehl kennt nur einen Fall. Ein Werkzeug kennt alle.

Dazu die zweite Hälfte: **ein Auftrag ist die einzige Anweisung, die der
Beauftragte nicht überprüfen kann.** Er hat den Arbeitsbaum noch nie gesehen,
wenn er die erste Zeile ausführt. Deshalb ist ein zerstörender erster Schritt
ein Fehler eigener Art — er trifft ausgerechnet den Moment, in dem
Misstrauen am unwahrscheinlichsten ist.

**How to apply:**

1. **In einem Auftrag steht kein `git reset`, kein `git checkout -B`, kein
   `git clean`, kein `--force`.** Wenn im Auftrag ein Git-Befehl steht, der
   etwas verwerfen kann, ist der Auftrag falsch, nicht der Beauftragte.
2. **Der erste Schritt heisst:**

       bash tools/arbeitsbaum-angleichen.sh <arbeitsbaum> <zielzweig>

   Das Werkzeug holt, spult vor, wenn es vorspulbar ist, setzt sonst die
   eigenen Commits per `rebase --autostash` obendrauf, und **bricht bei
   Konflikt ab, ohne etwas zu ändern**. Es gibt keinen Weg hindurch, der
   einen Commit verwirft. Vorher nennt es die eigenen Commits beim Namen,
   damit sichtbar ist, was auf dem Spiel steht.
3. **Vor dem Absenden eines Auftrags wird der Zielbaum gemessen**, nicht
   angenommen: `git -C <baum> log --oneline origin/<ziel>..HEAD`. Steht dort
   irgendetwas, gehört es in den Auftragstext — der Beauftragte muss wissen,
   dass sein Baum nicht leer ist ([[agenten-koordinieren]]).
4. **Wenn ein Beauftragter eine Anweisung von mir umgeht und es begründet,
   ist das ein Befund über mich.** PRÜFERs Satz *„Er hat es bemerkt und
   stattdessen cherry-gepickt"* gehört in dieselbe Zeile wie sein Ergebnis
   und nicht ans Ende eines Berichts.
5. **Eine Ersetzung wird einmal selbst gefahren, bevor sie in Aufträge
   geht** — in der Lage, für die sie gedacht ist, nicht in der Normallage
   ([[erst-pruefen-dann-anweisen]], [[messung-muss-den-weg-treffen]]).

**Gegengetestet im Wegwerf-Repo**, `tools/arbeitsbaum-angleichen-tests.sh`,
**11 Proben**, alle grün — vier Lagen:

| Lage | geprüft wird |
|---|---|
| eigener Commit, Ziel weitergelaufen | der eigene Commit ist danach noch da, der Zielstand auch, Rückgabe 0 |
| kein eigener Commit, nur Rückstand | es wird vorgespult, Rückgabe 0 |
| schon auf dem Stand | *nichts zu tun*, Rückgabe 0 |
| **Konflikt** | eigener Commit ist da, **HEAD bitgenau unverändert**, Abbruch gemeldet, Rückgabe 1 |

Die vierte Zeile ist die eigentliche Probe: die Gegenprobe ist umgedreht —
nicht *„kommt das gewünschte Ergebnis heraus"*, sondern *„bleibt der Stand
unangetastet, wenn es schiefgeht"* ([[gegenprobe-umdrehen]]).

**Wo diese Schranke schwach ist, offen gesagt:** Sie greift nur, wenn der
Auftrag sie aufruft — dieselbe Lücke wie bei `ersetze-bereich.pl`
([[text-nicht-durch-schichten-schicken]]). Was sie besser macht als eine
Ermahnung: der Auftragstext enthält jetzt **einen Werkzeugaufruf statt eines
Git-Befehls**, und ein Werkzeugaufruf lässt sich kopieren, ohne dass beim
Kopieren ein Schaden mitwandert. Genau das ist am 13.09. passiert: kopiert
wurde nicht ein Tippfehler, sondern eine Vorlage.

Siehe [[mannschaft-fuehren]], [[agenten-trennen-worktrees]] und
[[agent-vor-dem-ende-nicht-starten]].
