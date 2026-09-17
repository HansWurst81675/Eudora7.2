---
name: widerlegte-vermutungen-aufschreiben
description: Jede widerlegte Vermutung mit ihrer Messung in die Befunddatei; das Ausschlussverfahren fuehrt zur Zeile
metadata: 
  node_type: memory
  type: erfolg
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T08:01:04.444Z
---

Schranke: keine - welche Vermutung ich unterwegs verworfen habe, weiß nur ich; ein Werkzeug sieht in BEFUNDE.md nur, was dort steht, nicht was fehlt

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
sorgfältiger zu sein, sind vier Werkzeuge entstanden oder repariert worden —
drei davon lösen von selbst aus, das vierte noch nicht:

| Werkzeug | Commit | was es jetzt von selbst tut |
|---|---|---|
| `tools/doku-pruefen.pl` | `060a4bf` (**neu**) | hält die MDs gegeneinander — noch **von Hand** aufzurufen, nicht im Hook |
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

## Nachtrag 08.09.2026: aufgeschrieben, aber nicht gelesen

PRUEFER hat am 07.09.2026 um 12:59 die ODR-Vermutung zu E-34 widerlegt — zwei
`SECCustomToolBar`-Definitionen (`tbarcust.h:73` gegen
`OTShim_Werkzeugleiste.h:693`) können nicht beide wirken, weil die Ersatzschicht
`__TBARCUST_H__` setzt. Ich habe die Widerlegung selbst nach
`Befunde/BEENDEN.md` geschrieben, sie steht dort in **Zeile 553**.

Am 08.09.2026 um 06:34 habe ich dieselbe Vermutung neu aufgestellt („Zwei
Definitionen derselben Klasse — die Originalkopfdatei und unsere
Ersatzschicht") und vier Minuten damit verbracht, sie ein zweites Mal zu
widerlegen. Aufgeschrieben war sie; gelesen habe ich sie nicht.

**Also gehört zu Punkt 2 der Lesevorgang:**

- **Vor dem ersten Versuch an einem Befund wird sein Abschnitt in
  `Befunde/<NAME>.md` geöffnet** — nicht die Zusammenfassung im Chat, sondern
  die Datei. Der Chat überlebt kein Abschalten, und mein eigener Kontext
  vergisst schneller als die Datei ([[wissen-gehoert-in-dateien]]).
- **Widerlegungen gehören an den Anfang des Abschnitts**, nicht als Nachtrag ans
  Ende. Was unten steht, wird beim Überfliegen nicht gelesen — hier stand es in
  Zeile 553 von 557.
- **Eine Widerlegung, die von einem Agenten kommt, wird mit seinem Namen und
  seiner Messung notiert.** Sie ist dann zitierbar und muss nicht nachgemessen
  werden ([[mannschaft-fuehren]]).

Siehe [pruefen-statt-vermuten](pruefen-statt-vermuten.md),
[fehlerklassen-abstellen](fehlerklassen-abstellen.md),
[zwei-werte-in-eine-ausgabe](zwei-werte-in-eine-ausgabe.md) und
[wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md).

## Nachtrag 15.–17.09.2026: die Spurmarke, die **nicht** ankam, war die Messung

Zu **E-97** (*Eudora stuerzt beim Speichern einer Nachricht ab*) sind drei
Vermutungen widerlegt worden, bevor die symbolisierte Aufrufkette entschieden
hat, wo der Fehler liegt. Die Laeufe stehen mit Uhrzeit in
`tools/TESTLAEUFE.md`:

| Zeit | Vermutung | Messung | Ergebnis |
|---|---|---|---|
| 15.09. 14:02 | die CSS-Grenze | Dialog ohne die Vorlage von 1996 gefahren | stuerzt weiter ab |
| 15.09. 14:04 | die Dialogvorlage von 1996 (`IDD_SAVEAS_EXT`) | Vorlage abgeschaltet, mit Protokoll | stuerzt weiter ab |
| 15.09. 14:32 | ungepruefte Steuerelemente in `OnInitDialog` | Null-Pruefungen eingebaut | stuerzt weiter ab |
| 15.09. 14:35 | — | **Spurmarke: wird `OnInitDialog` ueberhaupt erreicht?** | **die Marke kam nie an** |
| 17.09. 07:40 | — | Null-Pruefung in `OnTypeChange`, Gegenprobe | *lebt noch* |

Die drei Widerlegungen sind richtig gelaufen und stehen in `BEFUNDE.md`. Das
ist nicht der Nachtrag. Der Nachtrag ist die vierte Zeile.

### Eine ausbleibende Spurmarke ist ein Messwert, kein Fehlschlag

Um 14:35 wurde eine Marke in `OnInitDialog` gelegt, und sie kam **nicht** im
Protokoll an. Das sieht aus wie eine misslungene Messung — Marke vergessen,
Bau nicht gepackt, falsches Verzeichnis
([[messung-muss-den-weg-treffen]] beschreibt genau diese Fehlerquellen, und
sie sind zuerst auszuschliessen). War alles in Ordnung. Dann sagt die
ausbleibende Marke etwas sehr Genaues:

> **Die Funktion, in der sie steht, laeuft nicht.**

Und daraus folgt unmittelbar, wo der Fehler sitzen muss: in einer Funktion,
die der Dialog **vor** `OnInitDialog` aufruft. Das ist
`CSaveAsDialog::OnTypeChange` (`SaveAsDialog.cpp:425`) — der Windows-Dateidialog
ruft sie waehrend seines Aufbaus zurueck, und deshalb hat das Fenster dort noch
kein Elternfenster, `GetParent()` liefert NULL. In `BEFUNDE.md` steht der Satz
inzwischen: *„Der Dateidialog ruft diese Funktion, waehrend er sich aufbaut —
also **vor** `OnInitDialog`; genau deshalb kam eine Spurmarke dort nie an."*

Die Information lag also am 15.09. um 14:35 vor. Genutzt wurde sie erst, als
der Debugger (`tools/stapel-untersuchen.ps1`) am 17.09. den Rahmen
symbolisiert hat.

**Why:** Die drei widerlegten Vermutungen haben je eine Moeglichkeit
gestrichen. Die ausbleibende Marke hat **den Ort genannt** — sie war die
wertvollste Messung des ganzen Befunds und wurde als Nullergebnis abgelegt.
Das ist dieselbe Form wie [[ausreisser-ist-der-befund]], nur umgekehrt: dort
passt ein Wert nicht ins Bild, hier fehlt einer, wo einer stehen muesste.

### Wie anwenden, zusaetzlich zu Punkt 1

- **Eine Spurmarke, die nicht ankommt, wird aufgeschrieben wie ein Wert** —
  in derselben Zeile wie die Frage: *„Marke in `OnInitDialog`, Lauf 14:35,
  **nicht angekommen** → die Funktion laeuft nicht."* Nicht als „Messung
  misslungen" und nicht gar nicht.
- **Vorher die drei banalen Ursachen ausschliessen**, sonst beweist das
  Ausbleiben nichts: ist die Marke im gebauten Stand, ist der gepackte Stand
  der gebaute, wurde das richtige Protokoll gelesen
  ([[messung-muss-den-weg-treffen]], [[paket-gegen-den-bau-messen]]).
- **„Wird X ueberhaupt erreicht?" gehoert vor „warum tut X das Falsche?"**
  Zwei der drei Vermutungen zu E-97 (Vorlage, `OnInitDialog`) setzten
  voraus, dass der Weg dort entlanglaeuft. Die Frage nach der Erreichbarkeit
  ist billiger als jede von ihnen und haette beide auf einmal erledigt — das
  ist Punkt 3 dieser Lehre (*den Versuch waehlen, der eine Klasse erledigt*),
  angewandt auf den **Ort** statt auf den Parameter.
- **Wenn ein Werkzeug die Zeile nennen kann, kommt es vor die Vermutung.**
  `tools/stapel-untersuchen.ps1` liefert den symbolisierten Rahmen mit Datei
  und Zeilennummer. Es hat E-97 in einem Lauf entschieden, nachdem drei
  Vermutungen ueber zwei Tage je einen Bau gekostet hatten
  ([[werkzeug-vor-eigenbau]]).

**Die Frage beim naechsten Mal:** *Habe ich eine Messung, die nichts gezeigt
hat — und was waere wahr, wenn dieses Nichts das Ergebnis ist?*
