---
name: verwerfen-nur-mit-zaehler
description: "Ein verwerfender Befehl wirkt auf seinen ganzen Umfang, nicht auf das gemeinte Ziel - vier Selbstverschuldungen in einer Stunde, jede mit einem Wert vorher oder nachher zu fangen"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
---

Schranke: `perl tools/ungesichertes-melden.pl` vor jedem verwerfenden Befehl (Rueckgabe 1 = im Arbeitsbaum liegt etwas, das der Befehl mitnimmt). Gegengetestet am 14.09.2026 in beide Richtungen: schmutziger Baum -> Rueckgabe 1 mit Dateinamen, sauberer Baum -> Rueckgabe 0. Fuer Aenderungen **innerhalb** einer Datei ersetzt sie nichts: dort ist der Zaehler die Zeilenzahl vorher und nachher.

# Der Befehl wirkt auf seinen Umfang, nicht auf meine Absicht

**Gregor am 14.09.2026, 12:16:15 Uhr**, als Einwurf mitten in den laufenden
Zug:

> *„du hast deine tools immer noch nciht im griff, was?"*

Vorausgegangen waren vier Selbstverschuldungen **in einer Stunde**, dazu am
selben Tag eine fuenfte und eine falsche Zaehlung.

## Meine erste Erklaerung war zu eng — und das ist Teil des Befunds

Auf die Frage habe ich geantwortet:

> *„Der gemeinsame Nenner ist nicht Unachtsamkeit, sondern ein
> Konstruktionsfehler: `AGENTEN-LAUFEN.md` traegt laufenden Zustand und liegt
> im Repo — also reisst jede Git-Operation ihn mit."*

Das erklaert **einen von vier** Faellen. Es erklaert nicht, warum ein
Perl-Einzeiler eine Datei leert, nicht, warum ein Merge einen Befund
verschluckt, und nicht, warum ein Commit auf `main` landet. Es ist derselbe
Griff wie am Vormittag desselben Tages, als ich aus einer Messung am
Verfassen-Rahmen auf den ganzen Versandweg geschlossen habe
([[messung-muss-den-weg-treffen]], Fall 5): **eine Erklaerung, die den ersten
Fall deckt, wird fuer die Klasse ausgegeben.**

## Die Klasse, gemessen

Jeder dieser Befehle hat auf **mehr** gewirkt, als ich benannt hatte. Und
jedes Mal haette ein einziger Wert — vorher oder nachher — es sofort gezeigt:

| Befehl | was ich meinte | worauf er wirkte | der Wert, der es gezeigt haette |
|---|---|---|---|
| `perl -i -e '… my @z = <>; … print @aus;' PORTIERUNG.md` | die Konfliktbloecke entfernen | die **ganze Datei**: 1129 Zeilen auf **0** | Zeilenzahl vorher/nachher |
| Konflikt in `BEFUNDE.md` pauschal auf „ihre Seite" geloest | die drei Konfliktbloecke | auch **E-87**, eine Stunde vorher von mir selbst eingetragen | Zeilenzahl: **7824 -> 7823**, gemessen erst beim Zurueckholen aus `0f3ec92` |
| `git reset --hard origin/main` (um von `main` aus zu verzweigen) | den HEAD setzen | den **ganzen Arbeitsbaum**, darunter den Agenten-Austrag in `tools/AGENTEN-LAUFEN.md` | `perl tools/ungesichertes-melden.pl` -> Rueckgabe 1 |
| Loeschbefehl im Hintergrund | alte Zweige aufraeumen | **dieselben** Zweige, die der Vordergrund gerade nachzog | welcher Befehl laeuft gerade noch |
| `git commit` | auf dem Arbeitszweig | auf **`main`** | `git branch --show-current` |
| `grep -c '^\| \`tools/'` | alle Werkzeuge in `WERKZEUGE.md` zaehlen | nur Tabellenzeilen mit Backtick-Praefix: **72 statt 84** | die Zaehlung gegen `ls tools/` halten ([[pruefumfang-nicht-von-hand]]) |

Die letzte Zeile ist die Umkehrung derselben Sache: dort war der Umfang nicht
zu **weit**, sondern zu **eng** — und das Ergebnis war eine Falschaussage
gegen einen Agenten, der recht hatte. Beide Male gilt: **der Umfang war nie
genannt und nie gemessen, sondern dem Werkzeug ueberlassen.**

## Warum der Perl-Einzeiler die Datei geleert hat

Das ist kein Tippfehler, sondern eine Eigenschaft von `-i`, und sie ist
wiederverwendbares Wissen:

```perl
perl -i -e 'my @z = <>; … ; print @aus;' PORTIERUNG.md
```

`-i` leitet `STDOUT` in die Ersatzdatei um — **solange `ARGV` offen ist**.
`my @z = <>;` liest `ARGV` bis zum **Ende**; damit wird `ARGV` geschlossen und
`STDOUT` zeigt wieder auf das Terminal. Der `print @aus` danach ging also ins
Terminal (sichtbar als **65 KB** im Werkzeugergebnis), und die Ersatzdatei
blieb leer.

* `perl -i -pe` und `perl -i -ne` sind sicher: dort laeuft der Druck **im**
  Schleifendurchlauf, solange `ARGV` offen ist.
* `perl -i -e` mit einem selbstgebauten `<>` ist es nicht. Nie.
* Fuer diesen Zweck gibt es `tools/ersetze-bereich.pl`
  ([[text-nicht-durch-schichten-schicken]], [[werkzeug-vor-eigenbau]]).

Zurueckgeholt hat die Datei `git checkout --merge -- PORTIERUNG.md`: waehrend
eines laufenden Merges stellt das die Datei **mit** den Konfliktmarken aus dem
Merge-Zustand wieder her — `git checkout --` allein tut das nicht.

## Gerettet hat jedes Mal etwas anderes als meine Aufmerksamkeit

| Fall | wer oder was es aufgehalten hat |
|---|---|
| `PORTIERUNG.md` geleert | die 65 KB Ausgabe im Werkzeugergebnis, also Zufall |
| E-87 verloren | ein spaeterer Blick in `0f3ec92` |
| Agenten-Austrag zurueckgesetzt | mir selbst aufgefallen, nachdem er zweimal fehlte |
| Commit auf `main` | die **GitHub-Sperre**, nicht eine Pruefung bei mir |
| Werkzeugzaehlung | LEKTOR hatte recht, ich habe ihm widersprochen und musste mich berichtigen |

**Why:** Ein verwerfender Befehl meldet nicht, was er verworfen hat. `git
reset --hard` sagt nur, wo `HEAD` jetzt steht; ein Merge sagt nur, dass er
geloest ist; `perl -i` sagt gar nichts. Der Erfolgsfall und der Schadensfall
sehen in der Ausgabe **identisch** aus. Deshalb ist hier — anders als sonst —
nicht das Urteil das Problem, sondern dass ueberhaupt kein Wert entsteht, an
dem ein Urteil haengen koennte ([[erfolgsmeldung-aus-dem-ergebnis]]). Und
genau deshalb wird der Fehler erst Stunden spaeter sichtbar, oder gar nicht.

## Wie anwenden

1. **Vor jedem Befehl, der verwerfen kann** — `git reset --hard`,
   `git checkout --`, `git merge -X ours/theirs`, pauschales Loesen eines
   Konflikts, `git branch -D`, `git clean`, `perl -i`, `> datei` — **wird der
   Umfang in einem Satz genannt, und der Satz nennt, was NICHT angefasst
   werden darf.** Laesst sich dieser Satz nicht bilden, ist der Befehl der
   falsche.
2. **`perl tools/ungesichertes-melden.pl`** davor. Rueckgabe 1 heisst: was
   dort liegt, nimmt der Befehl mit. Das Werkzeug gab es an diesem Tag
   bereits — es hatte nur keine Aufrufstelle.
3. **`git branch --show-current` vor jedem Commit.** `tools/pruefe-branch.pl`
   laesst `main` ausdruecklich durch (Zeile 165, *„main selbst ist nie das
   Problem"*); die Sperre liegt allein bei GitHub ([[nie-direkt-auf-main]]).
4. **Ein Konflikt wird nie pauschal nach Seite geloest.** Zeilenzahl vorher
   und nachher, und jeder entfernte Block wird benannt. Bei `BEFUNDE.md` war
   der Unterschied **eine** Zeile — und diese eine Zeile war ein ganzer
   Befund.
5. **Nach jedem Schreibzugriff wird die Datei gemessen**, nicht der
   Rueckgabewert des eigenen Einzeilers: Zeilenzahl, Trefferzahl des Markers,
   CR-Zahl ([[erfolgsmeldung-aus-dem-ergebnis]],
   [[zeilenenden-nach-jedem-schreibzugriff-messen]]).
6. **Kein verwerfender Befehl im Hintergrund**, solange der Vordergrund
   dieselben Objekte anfasst. Aufraeumen ist eine eigene Arbeitsphase, keine
   Nebenbeschaeftigung ([[nie-stillstehen]] meint Weiterarbeiten, nicht
   Gleichzeitigkeit auf demselben Gegenstand).

**Was diese Schranke nicht kann:** `ungesichertes-melden.pl` sieht nur den
Arbeitsbaum. Ueber das, was eine Konfliktloesung **innerhalb** einer Datei
wegwirft, sagt sie nichts — dort muss der Zaehler von mir kommen. Und sie
greift, wie jede Schranke hier, nur wenn sie aufgerufen wird
([[lehren-anwenden-nicht-nur-schreiben]]).

Siehe [[auftrag-darf-nicht-loeschen]] — dieselbe Klasse, aber in einem
**Auftrag** an einen Agenten; dort ist sie mit
`tools/arbeitsbaum-angleichen.sh` abgestellt, in der eigenen Hand war sie es
am 14.09.2026 noch nicht. Ausserdem [[bestand-vor-neuer-suche]] (an diesem Tag
zweimal dieselbe Form: das Richtige lag bereit und wurde nicht aufgerufen) und
[[einwurf-ist-ein-messwert]] — Gregors Satz kam mitten in den laufenden Zug.
