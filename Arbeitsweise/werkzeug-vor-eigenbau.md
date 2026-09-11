---
name: werkzeug-vor-eigenbau
description: "Vor dem eigenen Dreizeiler in tools/WERKZEUGE.md nachsehen; und ein fertiges Werkzeug, das niemand aufruft, wirkt so wenig wie eine Lehre, die nur Text ist"
metadata:
  type: feedback
---

Schranke: keine - kein Werkzeug sieht, dass ich ein vorhandenes nicht benutzt habe; der Eigenbau sieht im Verlauf aus wie Arbeit. Vorschlag fuer tools/werkzeuge-angeschlossen.pl am Ende dieser Datei.

# Erst nachsehen, was es gibt — und was da ist, anschließen

Am 11.09.2026 zweimal derselbe Fehler, in zwei Gestalten: ein fertiges Werkzeug
lag im Repo und wurde nicht benutzt.

## Fall 1: der eigene Dreizeiler statt `mailverzeichnis-uebernehmen.ps1`

`tools/mailverzeichnis-uebernehmen.ps1` gibt es genau dafür, Gregors
Mailverzeichnis in die nächste Fassung mitzunehmen. Es ergänzt statt zu
erschlagen, bricht ab, wenn eine `Eudora.exe` läuft, setzt `CtrlJMapping` — und
**zählt am Ende Quelle gegen Ziel nach** (`tools/WERKZEUGE.md`, Zeile 67). Diese
Nachmessung hatte am 10.09. schon einen echten Kopierfehler gefangen
([[schranke-gegentesten]], Nachtrag 10.09.).

Ich habe es nicht aufgerufen, sondern drei eigene Zeilen geschrieben, die nur die
**oberste Ebene** kopieren. Gregors Befund an der ausgelieferten Fassung:

> *„imap funktioniert gar nicht. keine passwort abfrage ... gar nichts."*

Der Zertifikats-Patch stand unter Verdacht; die Ursache war mein Kopierbefehl.
Nachgemessen am 11.09.2026 in `C:\Users\Gregor\Eudora72-1.0.48-release\Mailverzeichnis`:

| gezählt | Dateien |
|---|---|
| oberste Ebene (`-maxdepth 1`) | **31** |
| rekursiv | **153** |
| davon unter `Imap\` | **43** |

31 Dateien sehen aus wie ein vollständiges Mailverzeichnis. Die IMAP-Konten
liegen aber unter `Mailverzeichnis\Imap\<Konto>\<Postfach>\`, also drei Ebenen
tiefer — mit ihnen die Kontoeinstellungen, und ohne sie fragt Eudora nach nichts.
Zwölf weitere Unterverzeichnisse sind betroffen (`attach`, `Embedded`, `Sigs`,
`Nickname`, `Filters`, `Stationery`, …).

## Fall 2: `rollen-faellig.pl` gab es seit dem 08.09. und hing an nichts

`tools/rollen-faellig.pl` ist am **08.09.2026** entstanden (Commit `4524ea7`).
Es meldete alle drei Rollen korrekt als fällig und gab bei fälligen Rollen 1
zurück. Es war nur an **kein** Skript und keinen Hook angeschlossen. Drei Tage
lang. Angeschlossen wurde es erst am 11.09. (Commit `16e8840`), nachdem Release
v1.0.47 gebaut, gemergt und veröffentlicht war und Gregor nach dem Lektor fragen
musste. Der Vorgang steht in [[daueraufgaben-brauchen-einen-takt]]; hier zählt
nur die Gestalt: **fertig gebaut, nicht benutzt.**

**Warum beides dieselbe Klasse ist:** In beiden Fällen war die Arbeit schon
getan, und in beiden Fällen habe ich sie ein zweites Mal und schlechter gemacht —
einmal als Eigenbau ohne Nachmessung, einmal als Lehre, die niemand ausführt. Der
Eigenbau ist dabei der gefährlichere Fall, weil er im Verlauf **wie Arbeit
aussieht**: drei Zeilen, ein grüner Lauf, keine Meldung. Ein Werkzeug, das
niemand ruft, ist genauso wirkungslos wie eine Lehre, die nur Text ist
([[lehren-anwenden-nicht-nur-schreiben]]).

## Wie anwenden

1. **Auslöser: „das sind doch nur drei Zeilen".** Genau dann wird
   `tools/WERKZEUGE.md` durchsucht, bevor die erste Zeile getippt wird:

       grep -in "mailverzeichnis\|kopier\|paket\|version" tools/WERKZEUGE.md

   Der Suchbegriff ist die **Sache**, nicht der Werkzeugname — den kenne ich ja
   gerade nicht.
2. **Alles, was Gregors Daten anfasst, läuft über ein Werkzeug**, nie über einen
   Befehl in der Zeile. Kopieren, Verschieben, Löschen, Umbenennen im
   Mailverzeichnis, in `Eudora.ini` oder in einem Laufverzeichnis: dafür gibt es
   Werkzeuge, und sie messen nach ([[anwenderdatei-nicht-erschlagen]],
   [[kein-paket-mit-offenem-datenverlust]]).
3. **Wenn es kein Werkzeug gibt, wird der Eigenbau zum Werkzeug** — mit
   Nachmessung, unter `tools/`, mit einer Zeile in `WERKZEUGE.md`. Ein
   Einmal-Befehl, der Daten anfasst, ist die Bauart, die diesen Fehler erzeugt
   ([[fehlerklassen-abstellen]]).
4. **Ein neues Werkzeug ist erst fertig, wenn eine Aufrufstelle es nennt.** Im
   selben Commit: der Hook (`tools/hooks-einrichten.sh`), das Bauskript
   (`tools/paket-bauen.ps1`), eine Vorcommit-Liste oder eine ausdrückliche Zeile
   „wird von Hand aufgerufen, Auslöser: …". Ohne Aufrufstelle ist es kein
   Werkzeug, sondern eine Datei.
5. **Beim Zählen die Tiefe nennen.** Jede Nachmessung über ein Verzeichnis sagt,
   ob sie rekursiv war. „31 Dateien übernommen" ohne diese Angabe ist keine
   Nachmessung ([[pruefumfang-nicht-von-hand]]).

## Was eine Schranke hier könnte — Vorschlag an PRÜFER

`tools/werkzeuge-angeschlossen.pl`: für jedes Werkzeug unter `tools/` (Umfang aus
dem Verzeichnis, nicht aus einer Liste) suchen, ob **irgendeine** andere Datei es
aufruft — `hooks-einrichten.sh`, `paket-bauen.ps1`, ein anderes Skript, eine
Vorcommit-Liste in einer MD. Wer keinen Rufer hat, wird gemeldet, zusammen mit
der Zeile aus `WERKZEUGE.md`. Erlaubte Ausnahme wie bei
[[pruefumfang-nicht-von-hand]] am **Merkmal**, nicht am Namen: ein Werkzeug, das
im eigenen Kopf „Aufruf: von Hand, Auslöser: …" trägt, ist angeschlossen. Damit
wäre der Fall `rollen-faellig.pl` am 09.09. aufgefallen statt am 11.09. Bauen
soll das PRÜFER; ich nenne nur die Lücke.

Siehe [[daueraufgaben-brauchen-einen-takt]],
[[lehren-anwenden-nicht-nur-schreiben]], [[schranke-gegentesten]],
[[anwenderdatei-nicht-erschlagen]] und [[fehlerklassen-abstellen]].
