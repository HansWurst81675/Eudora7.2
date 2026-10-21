---
name: schranke-gehoert-in-den-haken
description: "Eine Schranke, die nur läuft wenn ich daran denke, ist keine Schranke; und eine, die zu oft umsonst warnt, wird entwaffnet"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-18T07:35:33.513Z
---

Schranke: tools/lehren-schranken.pl (pre-commit) haelt jede Lehre gegen ihre Aufrufstelle. Die Verdrahtung der Schranken selbst prueft seit dem 21.10.2026 **tools/pruefe-haken-aktuell.pl**: es liest die Schrankenliste aus tools/hooks-einrichten.sh und haelt sie gegen den INSTALLIERTEN .git/hooks/pre-commit und pre-push; tools/commit-bereit.pl meldet den Befund als Hinweis. Gegenprobe: --selbsttest 9 Faelle in beide Richtungen; am Bestand 4 fehlende Schranken gefunden, von denen eine Handsuche desselben Tages nur 3 kannte. Davor: gemessen am 18.09.2026 hingen 4 von 6 Doku-Schranken in keinem Haken, und release-pruefen.pl hing mit "|| true"

Eine Prüfung, die nicht in `.git/hooks/pre-commit` **oder** `pre-push` steht,
läuft nur, wenn ich daran denke — und genau dann, wenn es darauf ankommt, denke
ich nicht daran.

Gregor am 18.09.2026, nachdem er den Zweig zu `v1.0.72` gemergt hatte und ich
die fehlenden Dokumente **danach** auf einem nicht vereinbarten Zweig
nachschieben wollte:

> *„repareire deine schranken, so daß VOR dem commit und merge alles auf github
> vorhanden ist. […] keine lügen auf dem main."*

**Nachgemessen war die Ursache nicht Nachlässigkeit, sondern Verdrahtung.**
`pruefe-befund-verbreitung.pl`, `pruefe-stand-md.pl`, `pruefe-doku-takt.pl` und
`offene-befunde.pl` hingen in **keinem** Haken. Alle vier waren gebaut, getestet
und gut — und liefen zum Commit-Zeitpunkt nicht. Folge: fünf führende Dokumente
nannten nach dem Release weiterhin `v1.0.64`.

**Die zweite Hälfte ist die wichtigere.** `release-pruefen.pl` hing im Haken,
aber als `perl … || perl … || true` — es konnte nie abweisen. Der Grund stand
nicht im Haken, sondern im Werkzeug: es gab auch für einen bloßen **Hinweis**
den Wert 1 zurück und war deshalb dauernd rot. Jemand (ich) hat es daraufhin
entwaffnet, statt die Ursache zu beheben.

**Also, in dieser Reihenfolge:**

1. Neue Prüfung **sofort** in den Haken, mit `|| exit $?`. Sonst ist sie ein
   Aufsatz, kein Riegel.
2. Prüfung braucht **getrennte Rückgabewerte**: `0` in Ordnung, `1` abweisen,
   ein eigener Wert für „nur ein Hinweis". Eine Prüfung, die für Hinweise
   abweist, wird binnen Tagen umgangen.
3. Wird eine Schranke lästig, **an den Kosten ansetzen, nicht am Prüfumfang**.
   Der naheliegende Schnitt — „nur prüfen, was der Commit anfasst" — ist genau
   das `if`, das am 07.09.2026 entfernt wurde: eine veraltete Datei, die niemand
   anfasst, steht in keinem Diff (siehe [[review-sieht-nur-den-diff]]).

Gregor hat die Laufzeit danach ausdrücklich angenommen: *„pre commit mit 22sek
ist akzeptabel."* Die Entscheidung ist in `Befunde/PRUEFER-17.md` festgehalten,
damit sie niemand erneut aufmacht.

Verwandt: [[lehren-anwenden-nicht-nur-schreiben]], [[werkzeug-vor-eigenbau]],
[[fehlerklassen-abstellen]], [[schranke-gegentesten]], [[fertig-heisst-fertig]].

## Nachtrag 12.10.2026 — die Zeile im Erzeuger ist nicht der Haken

Zwei frische Schranken habe ich an einem Tag eingehängt, beide in
`tools/hooks-einrichten.sh`:

```sh
schranke pruefe-befundurteile.pl || exit $?
schranke befunde-verlinken.pl    || exit $?
```

Beide Commits meldeten *„eingehängt in `pre-commit`, `pre-push` und
`paket-bauen.ps1`"*. Gemessen am selben Abend:

```sh
$ grep -c 'befunde-verlinken' .git/hooks/pre-commit .git/hooks/pre-push
.git/hooks/pre-commit:0
.git/hooks/pre-push:0
```

**Null.** `tools/hooks-einrichten.sh` ist ein **Erzeuger**; `.git/hooks/*` sind
die Haken. Wer den Erzeuger ändert und ihn nicht laufen lässt, hat eine
Schranke, die nur in der Quelle steht. Aufgefallen ist es, weil
`befunde-verlinken.pl` von Hand aufgerufen `MANGEL` meldete und
Rückgabewert 1 gab — und der Commit **trotzdem durchging**.

Dasselbe Muster wie die Schranke, die in keinem Haken hing
([pruefe-befundurteile am 12.10.2026](../tools/WERKZEUGE.md)); nur ist der
Weg hier noch kürzer, weil ich die Zeile ja geschrieben hatte.

**Die Regel:** nach **jeder** Änderung an `tools/hooks-einrichten.sh` wird das
Skript ausgeführt **und** nachgezählt, dass der Name im erzeugten Haken steht:

```sh
bash tools/hooks-einrichten.sh
grep -c '<name>' .git/hooks/pre-commit .git/hooks/pre-push
```

Eine Zahl ungleich 0 auf beiden Seiten ist der Beleg. *„Eingehängt"* ohne
diese zwei Zahlen ist eine Behauptung, keine Messung
([pruefen-statt-vermuten](pruefen-statt-vermuten.md)).
## Nachtrag 21.10.2026 — zum dritten Mal, und die Handsuche fand zu wenig

Am 21.10.2026 abends gemessen, im Hauptbaum:

```
.git/hooks/pre-commit          20.10.2026 12:55, 22313 Bytes
im Quelltext                   40 Schranken
im installierten Haken         36 Schranken
```

**Vier** fehlten: `pruefe-auspacken.pl` (14f, vom 20.10.), und die drei, die an
diesem Tag entstanden sind — `pruefe-startwege.pl` (14g),
`pruefe-original-belegt.pl` (14h), `pruefe-messziel.pl` (14i). Drei
CHRONIST-Läufe desselben Tages hatten je eine Schranke gebaut, und keine
einzige lief.

**Das Entscheidende ist die Vier.** Der Bericht vom Mittag
([CHRONIST-2026-10-21b](CHRONIST-2026-10-21b.md)) hatte den Mangel bemerkt und
dafür den Dreizeiler aus dem Nachtrag vom 12.10. benutzt:

```sh
grep -c pruefe-startwege .git/hooks/pre-commit        # 0
grep -c pruefe-original-belegt .git/hooks/pre-commit  # 0
grep -c pruefe-messziel .git/hooks/pre-commit         # 0
```

Drei Namen gesucht, drei Lücken gefunden — und die vierte sah niemand, weil
niemand nach ihr gesucht hat. Eine Prüfliste von Hand prüft genau das nicht,
woran man nicht gedacht hat ([[pruefumfang-nicht-von-hand]]). Der Umfang muss
aus der Quelle kommen.

**Deshalb jetzt ein Werkzeug statt eines Befehls:**

```sh
perl tools/pruefe-haken-aktuell.pl
```

Es liest beide Blöcke aus `tools/hooks-einrichten.sh` — also dieselbe Quelle,
aus der auch `commit-bereit.pl` seine Liste nimmt — und vergleicht sie mit dem,
was wirklich unter `.git/hooks/` liegt. Ausgegeben werden Datum und Anzahl
beider Seiten und namentlich, was fehlt.

**Es sitzt bewusst nicht im Haken.** Ein veralteter Haken enthält die Prüfung,
die ihn veraltet nennt, ja gerade nicht — eine Schranke, die ihren Umfang aus
derselben Annahme nimmt wie das Geprüfte, prüft nichts
([[schranke-teilt-nicht-die-annahme]]). Ihr Platz ist `tools/commit-bereit.pl`,
das aus dem Arbeitsbaum läuft und seine Liste aus dem Quelltext liest; von dort
meldet sie seither bei jedem Lauf.
