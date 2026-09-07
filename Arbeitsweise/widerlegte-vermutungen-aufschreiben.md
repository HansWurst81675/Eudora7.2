---
name: widerlegte-vermutungen-aufschreiben
description: Jede widerlegte Vermutung mit ihrer Messung in die Befunddatei; das Ausschlussverfahren fuehrt zur Zeile
metadata:
  type: erfolg
---

# Widerlegte Vermutungen aufschreiben — so wird aus einem Verdacht eine Zeile

Diese Lehre hält fest, **was am 06./07.09.2026 funktioniert hat**, damit es
wiederholbar ist. Der Anlass ist Gregors Frage vom 07.09.2026, 06:57 Uhr:

> *„viel wichtiger: wie ist der fortrschritt von ctrl-n? das interessiert mich
> am meisten"*

Auf diese Frage gab es eine Antwort — und zwar nur, weil jeder gescheiterte
Versuch vorher aufgeschrieben worden war.

## Was tatsächlich passiert ist

Der Strg-N-Absturz war am Morgen des 06.09. eine vage Vermutung über die
Fremdbibliothek `Paige32.dll`. Am Abend war er zwei benannte Ursachen an zwei
benannten Stellen.

**Erstens das Ausschlussverfahren.** `CHANGELOG.md` führt unter „Sieben
Vermutungen, alle durch Versuch widerlegt" eine Tabelle, in der neben jeder
Vermutung die **Messung** steht, nicht nur ein „war es nicht": umgestülptes
Client-Rechteck (`Rect=8,2,2,598`, Breite minus 6 — begradigt, stürzt weiter
ab), zu kleine Anfangsgröße (`CSize(400,600)` ergab gesundes `8,2,375,598` —
stürzt weiter ab), `parInfo` und `parMask` genullt, Reihenfolge der beiden
`CreateView` getauscht, `styleInfo.font_index` auf 0, frische `Eudora.ini`.

Die siebte wog am schwersten: **`pgNewNamedStyle` ganz übersprungen — stürzt
weiter ab.** Damit war nicht ein Aufruf entlastet, sondern eine ganze Klasse:
es liegt am Anlegen benannter Stile überhaupt. Dieselbe Tabelle steht in
`WEITERMACHEN.md` und `AUFGABEN.md`, also dort, wo der nächste Durchgang
anfängt.

Von dort führte die Spur zur Ursache: **`pg_time_t` war unter VS2022 acht Byte
breit statt vier** (`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`, Commit `ae0e165`,
Beleg in `Befunde/PAIGE.md`).

**Zweitens die Verengung auf eine Zeile.** Der Folgefehler E-32 endete in
`Eudora71/Eudora/headervw.cpp`: `OnKillFocusTo` dereferenzierte `pField`
ungeprüft, obwohl die Abfrage drei Zeilen darüber ausdrücklich mit NULL
rechnet. `GetDlgItem` liefert NULL, solange das Kopfzeilenfeld noch nicht
existiert — genau der Zustand während `LoadFrame`. Behebung: ein
Rückkehrzweig, wenn `pField` leer ist, Commit `060a4bf`. Weil der Zugriff
innerhalb einer Fensterprozedur passiert, meldete Windows nicht den üblichen
Zugriffsfehler, sondern `0xC000041D` — und das erklärt zugleich die modale
Meldung, wegen der Eudora sich nicht mehr beenden ließ.

**Drittens: eine Schranke schlägt zu, eine Mahnung nicht.** Statt der Zusage,
sorgfältiger zu sein, sind vier Werkzeuge entstanden oder repariert worden:

| Werkzeug | Commit | was es jetzt von selbst tut |
|---|---|---|
| `tools/doku-pruefen.pl` | `060a4bf` (**neu**) | hält die MDs gegeneinander, läuft im pre-commit-Hook |
| `tools/bauen.ps1` | `1bb1719` | bricht ab, wenn schon ein Bau läuft |
| `tools/gesichert.pl` | `c1ce069` | kein Fehlalarm mehr in Arbeitsbäumen — die Schranke wurde vorher überlesen |
| `tools/lehren-spiegeln.pl` | `47fdf37` | findet das Gedächtnis auch aus einem Arbeitsbaum, wo es blind war |

## Die Regel

1. **Jede widerlegte Vermutung geht mit ihrer Messung in die Befunddatei**, im
   Wortlaut „geändert auf X, gemessen Y, Fehler bleibt". Eine Widerlegung ist
   ein Ergebnis und spart dem Nächsten einen Bau.
2. **Vor einer neuen Vermutung die Liste der widerlegten lesen.** Was dort
   steht, wird nicht erneut probiert — auch nicht „nur zur Sicherheit".
3. **Den Versuch wählen, der eine Klasse erledigt**, nicht den, der einen
   Parameter verstellt. „Aufruf ganz übersprungen, stürzt weiter ab" bringt mehr
   als fünf Feinjustierungen.
4. **Eine gefundene Ursache wird auf Datei und Zeile geschrieben**, mit dem
   Kommentar im Quelltext, warum es dort schiefgeht — nicht nur in die
   Commit-Nachricht. Der nächste Leser sitzt in der Datei, nicht im Protokoll.
5. **Beim zweiten Auftreten eines Fehlers ein Werkzeug mit Auslösepunkt und
   Rückgabewert**, kein Merksatz. Ein Werkzeug, das nur mahnt, wird überlesen;
   eines im pre-commit-Hook nicht.

Siehe [pruefen-statt-vermuten](pruefen-statt-vermuten.md),
[fehlerklassen-abstellen](fehlerklassen-abstellen.md) und
[wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md).
