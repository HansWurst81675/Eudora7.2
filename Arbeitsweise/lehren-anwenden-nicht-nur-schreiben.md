---
name: lehren-anwenden-nicht-nur-schreiben
description: "Eine aufgeschriebene Lehre ohne Ausloeser und Werkzeug wirkt nicht - jede Lehre braucht einen Moment, in dem sie geprueft wird"
metadata:
  type: feedback
---

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
