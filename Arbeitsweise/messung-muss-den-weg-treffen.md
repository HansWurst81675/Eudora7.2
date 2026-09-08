---
name: messung-muss-den-weg-treffen
description: "Ein Gegentest im falschen Betriebsmodus oder an einem Stand ohne die Aenderung beweist nichts; erst pruefen, ob der geprueste Weg ueberhaupt gelaufen ist"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T12:44:17.656Z
---

# Der Test muss den Weg treffen, den er prueft

Am 07.09.2026 zweimal in einer Stunde dasselbe: eine Messung lief, lieferte ein
Ergebnis — und konnte das, was sie beweisen sollte, gar nicht erreichen.

## Fall 1: der Gegentest im falschen Betriebsmodus

Ich hatte in `tools/bauen.ps1` die Funktion `Hole-NeuesteQuelleFuer`
berichtigt, weil sie **alle** `.cpp` im Projektverzeichnis las und
`EudoraRes.dll` deshalb wegen `mainfrm.cpp` als veraltet meldete (dritter
Fehlalarm aus demselben Werkzeug). Zum Gegentest habe ich `EudoraRes.rc`
angefasst und

    tools/bauen.ps1 -Bauart Release -NurPruefen

laufen lassen. Die Schranke blieb still. Mein Schluss: *„Der Gegentest schlaegt
fehl — die Schranke ist jetzt stumm."*

Falsch. `-NurPruefen` setzt den Status auf `vorhanden` und **ueberspringt die
Aktualitaetspruefung ganz** (`tools/bauen.ps1`, um Zeile 936:
`if ($NurPruefen) { $stand = 'vorhanden' }`). Der Zweig, den ich pruefen
wollte, lief in diesem Modus nie. Entschieden hat es erst der **direkte
Aufruf** der drei geaenderten Funktionen: aus `bauen.ps1` herausgezogen, in ein
eigenes Skript gelegt und einzeln gefahren. Danach war es sauber trennbar —
`EudoraRes.rc` bewegt nur `EudoraRes.dll` (14:18:49), `mainfrm.cpp` nur
`Eudora.exe` (14:18:50).

Verraten hat es das Werkzeug selbst: in der Ausgabe stand `vorhanden`, nicht
`VERALTET` und nicht `unveraendert`. Die Statusspalte war der Beweis, dass der
geprueste Weg nicht gelaufen war — ich habe sie gelesen und nicht gesehen.

## Fall 2: die Messung an einem Stand ohne die Aenderung

Fuer E-33 (das Beenden) lagen **14, spaeter 32 Spurmarken** im Arbeitsbaum des
Agenten. Gregor hat den Log von Paket 1.0.21 geschickt — und darin stand zum
Beenden nichts. Das war kein Befund ueber das Beenden, sondern einer ueber mich:
sein Paket kennt die Marken nicht, weil sie nicht gebaut und nicht gepackt
waren. Jede Sitzung endet im Log deshalb einfach, und das haette sie mit und
ohne Ursache getan.

**Warum:** Ein Test, der den Weg nicht trifft, liefert immer dasselbe Ergebnis —
und zwar das beruhigende. Er ist damit schlimmer als kein Test: er verbraucht
Zeit, erzeugt einen Eintrag „geprueft" und deckt die Luecke zu. Im zweiten Fall
kostet er zusaetzlich Gregors Zeit, weil **er** die Messung fahren musste, die
nichts messen konnte ([[erst-pruefen-dann-anweisen]]).

**Wie anwenden:**

- **Vor der Bewertung eines Gegentests: belegen, dass der geaenderte Zweig
  gelaufen ist.** Ein Zaehler, eine Statuszeile, eine Ausgabe aus genau diesem
  Zweig. Ohne diesen Beleg ist „nichts gemeldet" kein Ergebnis.
- **Schalter und Betriebsarten sind Teil des Tests.** `-NurPruefen`,
  `--dry-run`, `Debug` gegen `Release`, „nur lesen" — jeder dieser Modi laesst
  Code weg. Der Gegentest laeuft im **gleichen** Modus wie der scharfe Lauf,
  oder er ruft die geaenderte Funktion **direkt** auf.
- **Die geaenderte Funktion direkt fahren, wenn der Weg umstritten ist.** Aus
  dem Skript herausziehen (`sed -n 'A,Ep'`), in ein Testskript legen, mit den
  echten Eingaben aufrufen. Das hat hier in zwei Anlaeufen entschieden, was
  drei Skriptlaeufe nicht entschieden haben.
- **Kein Symptom-Befund aus einem Stand ohne die Aenderung.** Bevor ich einen
  Log, ein Paket oder ein Bildschirmfoto auswerte: nachsehen, ob die Marke, der
  Fix oder die Ausgabe in **diesem** Stand ueberhaupt enthalten ist. Erst
  bauen, packen, Nummer nennen — dann messen ([[version-eindeutig-machen]]).
- **Ein falscher Test wird als falscher Test benannt**, nicht als stumme
  Schranke, und das Ergebnis gehoert in die Commit-Nachricht
  ([[schranke-gegentesten]]).

Siehe [[schranke-gegentesten]], [[gegenprobe-umdrehen]],
[[pruefen-statt-vermuten]] und [[widerlegte-vermutungen-aufschreiben]].
