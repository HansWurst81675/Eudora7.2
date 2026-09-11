---
name: lehren-anwenden-nicht-nur-schreiben
description: "Eine aufgeschriebene Lehre ohne Ausloeser und Werkzeug wirkt nicht - jede Lehre braucht einen Moment, in dem sie geprueft wird"
metadata:
  type: feedback
---

Schranke: tools/lehren-schranken.pl (pre-commit)

# Aufgeschrieben ist nicht befolgt

**Gregor am 06.09.2026:** *„daher lessons learned, weil ich merke, dass du immer
wieder die gleichen fehler machst. das ist schlecht!"* — und unmittelbar danach:
*„aber wenn das nicht gesammelt und zusammengefasst wird und du es ignorierst,
dann ist es ja witzlos!"*

Das ist der Vorwurf, aus dem dieses ganze Verzeichnis entstanden ist. Er ist
belegt: **31 Nachrichten** in den beiden Mitschriften fordern, dass ich mir
etwas merke, aufschreibe oder eine schon aufgeschriebene Regel endlich befolge.

## Der Vorwurf ist aelter als die Sammlung

| Datum | Gregor |
|---|---|
| 28.08. 19:52 | *„muss ich dich an alles erinnern? kannst du dir nicht die paar aufgaben einfach merken? aufschreiben?"* |
| 28.08. 20:13 | *„die regel gab es schon frueher, die hast du wieder ignoriert!"* |
| 28.08. 20:38 | *„raten und vermuten ist verboten, das hast du dir sogar aufgeschrieben!"* |
| 29.08. 21:45 | *„schreib dir das auch fuer naechstes mal auf! ... ich moechte dich ja nicht dauernd daran erinnern. bin ja nicht dein kindermaedchen."* |
| 29.08. 22:11 | *„wozu macht man lessons learned, wenn du sie anschliessend wieder ignorierst?"* |
| 05.09. 19:50 | *„gemessen statt geglaubt - das sollte ja bereits gelten! schon seit langem. warum immer noch fehlerhaft?"* |
| 05.09. 20:43 | *„schreib es dir auf! und merke es dir. und befolge es bei der naechsten session! du musst immer dazu lernen."* |
| 06.09. 16:15 | *„wir koennten viel zeit und arbeit sparen, wenn du einfach das tust, was ich dir auftrage."* |

Die Sammlung `Arbeitsweise/` gab es am 05.09. bereits mit 23 Lehren. Die Fehler
kamen trotzdem wieder. **Das Aufschreiben ist also nicht die Loesung, sondern
erst die Voraussetzung.**

## Warum Lehren nicht wirken

Der Befund steht schon im Nachtrag von [[pruefen-statt-vermuten]] und ist hier
das ganze Thema:

> **Der Grundsatz feuert nicht. Ein Handgriff feuert.**

Wo dieses Projekt eine echte Schranke gebaut hat, ist die Fehlerklasse weg:

| Fehlerklasse | Schranke | Ergebnis |
|---|---|---|
| zerstoerte Zeilenenden | `tools/pruefe-bytes.pl` im pre-commit-Hook | tritt nicht mehr unbemerkt auf |
| Commit auf einen schon gemergten Zweig | `tools/pruefe-branch.pl` | wird abgefangen |
| ungesicherte Arbeit vor dem Abschalten | `tools/gesichert.pl`, `tools/ungesichertes-melden.pl` | existiert |
| doppelt kodierte Markdown-Datei | Regel 5 in `tools/pruefe-bytes.pl` (Befund X-7) | seit 05.09.2026 abgefangen |

Wo es beim Merksatz blieb — Versionsnummern, Fuehrung der Agenten, Aktualitaet
der Doku — kam der Fehler wieder. Und wo eine Schranke zwar existiert, aber
niemand sie zu einem festen Zeitpunkt aufruft (`gesichert.pl`), wirkt sie
genauso wenig wie gar keine.

## Die Regel

**Eine Lehre ist erst fertig, wenn drei Fragen beantwortet sind:**

1. **Wann wird sie geprueft?** Ein Zeitpunkt im Arbeitsablauf, kein
   Dauerzustand — „vor jedem Commit", „vor jeder Agentenzuteilung", „bevor ich
   Gregor um einen Test bitte", „sobald das Wort abschalten faellt".
2. **Womit wird sie geprueft?** Ein Befehl, dessen Ausgabe man ansehen kann.
   Gibt es ihn nicht und ist der Fehler zum zweiten Mal aufgetreten, wird er
   gebaut — das ist [[fehlerklassen-abstellen]], und es gilt auch fuer Lehren
   ueber die eigene Arbeitsweise.
3. **Woran erkennt man den Verstoss?** Ein Merkmal, das man messen kann, nicht
   ein Gefuehl. „Die Titelzeile nennt nicht denselben Commit wie das Paket" ist
   pruefbar; „sorgfaeltiger arbeiten" ist es nicht.

**Zum Sitzungsbeginn, als erster Handgriff, vor der ersten inhaltlichen
Antwort:** `Arbeitsweise/MEMORY.md` und `Arbeitsweise/LEHREN-AUS-DEM-CHAT.md`
lesen und die drei haeufigsten Fehlerklassen in die eigene Aufgabenliste
aufnehmen. Nicht als Erinnerung, sondern als Punkte, die abgehakt werden.

**Und zum Sitzungsende:** die Lehren, gegen die in dieser Sitzung verstossen
wurde, um den neuen Beleg ergaenzen — mit Datum und Zitat. Eine Lehre ohne
Beleg wird beim naechsten Lesen nicht ernst genommen; eine mit vier Belegen aus
vier Sitzungen schon.

## Was ich nicht mehr tue

- **Nicht ueber die eigene Vergesslichkeit reden.** Gregor am 05.09.2026:
  *„waehrend wir hier jetzt diskutieren, warum Du dir irgendwelche Sachen nicht
  merken kannst. Sag mir lieber, wie der Zustand vom Bild ist. Kann ich jetzt
  was testen? Sind die Sachen gefixt?"* Die Entschuldigung kostet ihn genauso
  viel Zeit wie der Fehler.
- **Nicht messen statt beheben.** Am 05.09.2026 habe ich einen Schaden
  vermessen, statt ihn zu reparieren: *„behebe den fehler, statt zu messen."*
  Und am 06.09.: *„du sollst nicht ahnen, sondern untersuchen und fixen!"*
  Messen ist ein Mittel, kein Ergebnis.

Siehe auch [[fehlerklassen-abstellen]], [[anweisungen-abarbeiten]] und
[[wissen-gehoert-in-dateien]].

---

## Befund 06.09.2026 — die Spiegelung wirkt im Arbeitsbaum nicht

`tools/lehren-spiegeln.pl` haengt im pre-commit-Hook und soll das
Gedaechtnisverzeichnis des Assistenten nach `Arbeitsweise/` spiegeln, damit
Lehren im Repo landen. Es leitet den Pfad des Gedaechtnisverzeichnisses aus der
Repo-Wurzel ab. In einem Arbeitsbaum ist die Wurzel aber nicht
`…\Eudora7.2`, sondern `…\Eudora7.2-wt-<name>`. Gemessen aus `wt/chronist`:

```
lehren-spiegeln: kein Gedaechtnis gefunden, nichts gespiegelt.
  erwartet unter: C:\Users\Gregor/.claude/projects/
                  C--Users-Gregor-Documents-github-Eudora7-2-wt-chronist/memory
Rueckgabe=0
```

**Rueckgabe 0** — die Schranke meldet Erfolg, obwohl sie nichts getan hat. Da
Agenten fast immer in einem Arbeitsbaum sitzen und genau dort ihre Lehren
schreiben, ist die Spiegelung in der Praxis wirkungslos.

Zwei Folgen, beide unangenehm:

1. Eine Lehre, die ein Agent im Arbeitsbaum anlegt, kommt **nie** ins
   Gedaechtnisverzeichnis. Beim naechsten Sitzungsbeginn wird sie nicht
   geladen — sie steht nur im Repo und muss von Hand gelesen werden.
2. Umgekehrt gilt dasselbe: Aenderungen im Gedaechtnis landen nicht im Repo.

**Zu tun:** den Pfad in `tools/lehren-spiegeln.pl` ueber
`git rev-parse --path-format=absolute --git-common-dir` statt ueber
`--show-toplevel` bilden — so wie es `tools/hooks-einrichten.sh` fuer die Hooks
schon macht — und bei „kein Gedaechtnis gefunden" nicht mit 0 zurueckkehren,
sondern es sichtbar melden. Bis dahin gilt: **wer eine Lehre in einem
Arbeitsbaum anlegt, sagt es im Bericht ausdruecklich**, damit sie von Hand ins
Gedaechtnisverzeichnis uebernommen wird.

Genau das ist der Fehler, gegen den diese Lehre geschrieben ist: eine Schranke,
die schweigt statt zu greifen, ist so gut wie keine.


## Nachtrag 11.09.2026: die Bilanz eines Tages — vier Schranken haben gegriffen, und alles andere musste Gregor finden

Dieser Tag ist der bisher klarste Beleg für den Satz oben, weil er beide Seiten
in einer einzigen Schicht zeigt.

**Was eine Schranke gefangen hat — jedes Mal zu Recht, jedes Mal ohne dass
Gregor fragen musste:**

| Schranke | wie oft | was sie aufgehalten hat |
|---|---|---|
| `spuren-auswerten.pl` | **2×** | E-80 fehlte ganz in `SPURMARKEN.md`; danach Fließtext, wo eine Fassungsnummer oder „entfällt: …" hingehört |
| `doku-pruefen.pl` | 1 Lauf, **2 Befunde** | drei MDs nannten noch 1.0.44; `Version.h` nur zur Hälfte auf 7.2.0.47 umgestellt |
| `pruefe-doku-takt.pl` | **1×** | der CHANGELOG-Abschnitt zu 7.2.0.48 fehlte — der Paketbau brach ab, „zum ersten Mal hat der Takt funktioniert" |
| `rollen-faellig.pl` | **1×** | CHRONIST überfällig, 45 geänderte Dateien in seinem Bereich — dieser Bericht ist das Ergebnis |

**Was keine Schranke gefangen hat — und wer es stattdessen gefunden hat:**

| Mangel | gefunden von |
|---|---|
| „genau acht" Kopfzeilen, gemessen zehn ([[ausreisser-ist-der-befund]]) | PRÜFER |
| „175 echte Nachrichten", gemessen 134 ([[pruefen-statt-vermuten]]) | PRÜFER |
| `taboo-rechnen.pl` rechnete mit der Liste von 2006 ([[pruefumfang-nicht-von-hand]]) | PRÜFER |
| 43 IMAP-Dateien beim Übernehmen verloren ([[werkzeug-vor-eigenbau]]) | **Gregor**, am laufenden Programm |
| CHANGELOG: falsche Reihenfolge, 7.2.0.45 fehlte ([[review-sieht-nur-den-diff]]) | **Gregor** |
| `QCSSL.dll` fehlte im Paket ([[paket-gegen-den-bau-messen]]) | ein mitausgegebener Zeitstempel, also Zufall |

**Der Befund ist nicht, dass ich an diesem Tag mehr Fehler gemacht habe als
sonst.** Er ist, dass die Trennlinie exakt dort verläuft, wo eine Schranke
steht: **kein einziger Mangel, für den es eine Prüfung gab, hat es bis zu Gregor
geschafft** — und von den sechs, für die es keine gab, hat er zwei selbst finden
müssen und einer wurde nur zufällig bemerkt.

Dazu kommt der schärfste Einzelfall dieses Tages: `tools/rollen-faellig.pl`
**gab es seit dem 08.09.2026**, es meldete richtig, und es hing an nichts. Drei
Tage lang stand in [[daueraufgaben-brauchen-einen-takt]] geschrieben, es sei
„noch nicht verdrahtet" — von mir geschrieben, von mir nicht verdrahtet. Eine
fertige Schranke ohne Aufrufstelle wirkt so wenig wie eine Lehre, die nur Text
ist; hier gab es beides gleichzeitig ([[werkzeug-vor-eigenbau]]).

**Was daraus als Handgriff folgt:**

- **Zu jedem Mangel, den nicht eine Schranke gefunden hat, gehört die Frage:
  welche hätte ihn finden können?** Die Antwort ist entweder eine neue Prüfung
  oder ein Satz, warum es keine geben kann. Beides gehört in den Bericht, nicht
  in den Kopf.
- **Ein Mangel, den Gregor gefunden hat, zählt doppelt.** Er ist zugleich ein
  Befund über die Sache und einer über die fehlende Schranke
  ([[fehlerklassen-abstellen]]).
- **Eine neue Schranke wird am Tag ihrer Entstehung angeschlossen**, sonst ist
  sie nicht entstanden.

### Noch am selben Tag: die Spiegelung hat meine acht Arbeitskopien überschrieben

Der Abschnitt darüber sagt, `tools/lehren-spiegeln.pl` finde aus einem
Arbeitsbaum kein Gedächtnisverzeichnis und kehre still mit 0 zurück. **Das gilt
nicht mehr — es findet es.** Beim ersten Commit-Versuch dieses Berichts, aus
`Eudora7.2-wt-chronist`, hat der pre-commit-Hook gemeldet:

```
Arbeitsweise/ wurde aktualisiert (8 Datei(en)):
  doku-parallel-nicht-hinterher.md
  ...
Der Commit wurde abgebrochen.
```

„Aktualisiert" heißt hier: **meine acht frisch geschriebenen Nachträge waren im
Arbeitsbaum weg**, ersetzt durch die älteren Stände aus dem Gedächtnis.
Nachgemessen: `grep -c "Nachtrag 11.09.2026"` lieferte danach **0**. Die Arbeit
war nur deshalb nicht verloren, weil sie bereits im **Index** lag — ich hatte
vor dem Commit `git add Arbeitsweise/` gefahren, um `pruefe-bytes.pl` gegen den
Index laufen zu lassen. `git checkout -- Arbeitsweise/` hat sie zurückgeholt.

**Die Richtung ist Gedächtnis → Repo, und sie ist nicht verhandelbar.** Wer eine
Lehre nur im Repo ändert, schreibt in die Kopie; der nächste Hooklauf stellt den
Stand der Quelle wieder her. Der Ablauf, der funktioniert hat, in dieser
Reihenfolge:

1. im Arbeitsbaum schreiben,
2. **`git add Arbeitsweise/`** — der Index ist die einzige Sicherung gegen
   Schritt 5,
3. die geänderten Dateien ins Gedächtnisverzeichnis kopieren (der Hook nennt den
   Pfad selbst),
4. `perl tools/lehren-spiegeln.pl` von Hand fahren — es muss **stumm** sein;
   jede Zeile „wurde aktualisiert" heißt, dass Repo und Gedächtnis noch
   auseinanderlaufen,
5. dann committen.

**Was hier noch fehlt — Vorschlag an PRÜFER, nicht von mir gebaut:**
`lehren-spiegeln.pl` überschreibt eine Arbeitskopie, ohne zu prüfen, ob sie von
`HEAD` abweicht. Genau dann ist sie nämlich ungesicherte Arbeit. Es müsste in
diesem Fall **abbrechen und die Datei nennen**, statt sie zu ersetzen — und das
Wort „aktualisiert" durch „überschrieben" ersetzen, damit die Meldung sagt, was
geschieht ([[anwenderdatei-nicht-erschlagen]], [[werkzeug-vor-eigenbau]]).
