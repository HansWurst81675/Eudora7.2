---
name: schranke-liest-nur-code
description: "Eine Schranke, die Quelltext mit Regex prueft, muss Kommentare und Protokolltexte vorher wegwerfen und ihren Bereich am Rumpfende abschliessen - sonst liest sie ihre eigene Begruendung"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T07:55:51.680Z
---

Schranke: keine - dass eine Schranke ihre eigene Begründung liest, zeigt sich erst an ihrem Gegentest; es gibt keine Prüfung, die für jede Schranke das Wegwerfen von Kommentaren verlangt

# Eine Schranke, die Kommentare mitliest, prüft ihre eigene Begründung

Am 08.09.2026 habe ich `tools/pruefe-beenden.pl` geschrieben — die Schranke, die
das behobene Beenden (Kriterium 7, Befunde E-40 bis E-42) festhalten soll. Ihr
**erster Lauf** meldete sechs Mängel, und alle sechs waren Fehler in der
Schranke, nicht im Code:

    MANGEL:
      - Eudora71/Eudora/doc.cpp: der default-Zweig von SaveModified liefert
        wieder FALSE ... (E-40)
      - Eudora71/Eudora/msgdoc.cpp: der default-Zweig von SaveModified liefert
        wieder FALSE ... (E-40)

Beide Dateien waren richtig behoben. Angeschlagen hat der **Kommentar**, den ich
selbst bei der Behebung hineingeschrieben hatte und in dem `return FALSE`
wörtlich vorkommt, weil er erklärt, warum dort nicht mehr `FALSE` steht.

Dieselbe Falle steckte am 07.09.2026 in `tools/pruefe-fensterbau.pl`. Zweites
Auftreten heißt: Werkzeug bauen, nicht nachbessern ([[fehlerklassen-abstellen]]).

## Die vier Ursachen, einzeln

| Ursache | Wirkung |
|---|---|
| Kommentar enthält das gesuchte Muster (`return FALSE`) | Fehlalarm auf zwei richtig behobenen Dateien |
| `$text =~ /muster/` **ohne Klammergruppe** einer Variablen zugewiesen | liefert `1`, nicht den Treffer — die Prüfung arbeitet danach mit „1" |
| Suchmuster steht auch im **Protokolltext** des Programms (`WM_CLOSE` in einer `Format`-Zeichenkette) | Gegentest bleibt stumm: die Zeile ist entfernt, das Wort steht noch da |
| Bereichsende auf die **nächste** Klammer gesetzt (`default:` bis `}`) statt auf das Rumpfende | die halbe Funktion wird nicht geprüft, Gegentest bleibt stumm |

Die letzten beiden sind die gefährlichen: sie erzeugen keinen Fehlalarm,
sondern **Stille** — und Stille liest sich wie „geprüft, alles in Ordnung".

**Warum:** Quelltext enthält seine eigene Beschreibung. Kommentare, Protokoll-
zeichenketten und Befundkennungen nennen genau die Konstrukte, gegen die die
Schranke gerichtet ist — und je besser ich einen Fix kommentiere, desto
sicherer schlägt meine eigene Prüfung darauf an. Ein Fehlalarm zerstört die
Schranke langsam (sie wird nicht mehr geglaubt), eine stumme Prüfung sofort
(sie erzeugt falsche Sicherheit).

**Wie anwenden — für jede Schranke, die Quelltext liest:**

1. **Erst Kommentare entfernen, dann suchen.** Eine Hilfsfunktion
   `ohne_kommentare($inhalt)` — `//` bis Zeilenende und `/* */` — und **jede**
   Prüfung liest nur deren Ergebnis. Nicht einzelne Prüfungen ausnehmen.
2. **Zeichenketten sind kein Code.** Wenn das Muster auch in einer
   `_T("...")`-Zeichenkette vorkommen kann (Spurmarken nennen ihre Botschaft
   im Klartext), gehört das Muster an den Code-Kontext gebunden — `PostMessage(`
   davor, `;` danach — oder die Zeichenketten fliegen wie die Kommentare vorher
   heraus.
3. **Ein Bereich endet am Rumpfende, nicht an der nächsten Klammer.** Wer von
   `default:` oder `{` aus sucht, zählt Klammern auf und zu, statt `.*?\}` zu
   schreiben.
4. **Jede Zuweisung aus einem `=~` braucht eine Klammergruppe.** `my ($x) =`
   mit Klammern in Muster **und** Ziel; sonst steht `1` in der Variablen.
5. **Der erste Lauf gegen den unveränderten Baum muss grün sein**, und wenn er
   es nicht ist, wird jede Meldung einzeln zugeordnet: Code oder Schranke.
   Sechs Meldungen, sechs Zuordnungen — nicht „das sind wohl Fehlalarme".

Siehe [[schranke-gegentesten]], [[fehlerklassen-abstellen]],
[[text-nicht-durch-schichten-schicken]] und [[messung-muss-den-weg-treffen]].

## Nachtrag 15.10.2026 (CHRONIST): die Schranke las Gregors Wortlaut als mein Urteil

Am 15.10. um 12:00 UTC wies der pre-commit-Haken die Bestätigung von 1.0.96
ab. `tools/pruefe-befundurteile.pl` fand im CHANGELOG das Erledigt-Wort *„nicht
mehr auf“* neben [E-121](../BEFUNDE.md#e-121), das zu Recht offen steht (N1 bis
N3). Das Wort stand in **Gregors** Satz: *„ja, jetzt klappt es, der fehler
tritt nicht mehr auf“*. Die Schranke kann ein Zitat nicht von einer eigenen
Einstufung unterscheiden — dieselbe Klasse wie oben: sie liest Text, der nicht
Behauptung ist.

Behoben wurde es um 12:01 am **Text**, nicht an der Schranke: das wörtliche
Zitat wurde im CHANGELOG durch *„kein Fehlerdialog beim Verschieben“* ersetzt.
In BEFUNDE.md steht es noch. Das war hier vertretbar — der Absatz sagte
„Bestätigt“ über einen offenen Befund, und die Umschreibung ist genauer
(bestätigt ist der sechste Teil, nicht E-121) —, aber es ist die gefährliche
Richtung: **wenn eine Schranke einen wörtlichen Beleg abweist, wird zuerst
gefragt, ob die Schranke irrt.** Gregors Wortlaut ist die Messung; ihn
umzuformulieren, bis die Prüfung schweigt, löscht den Beleg, um den Alarm
loszuwerden.

Dazu: `tools/commit-bereit.pl` zeigt je Schranke nur die Kernzeilen (Filter
auf `MANGEL`, `fehlt`, …). Die Erklärung von `pruefe-befundurteile.pl` („Ein
Urteil steht an zwei Stellen …“) kam darin nicht vor; um 12:00:39 fand die
Suche danach nichts, erst ein zweiter `git commit` zeigte sie.

**Offen, Vorschlag für die Hauptsitzung (nicht gebaut):**
`pruefe-befundurteile.pl` lässt Erledigt-Wörter innerhalb eines Zitats in
deutschen Anführungszeichen („…“) aus, wenn im selben Absatz „Gregor“ steht;
Gegenprobe: die CHANGELOG-Zeile aus dem Stand vor `9840ee35` muss
durchgehen, *„E-121 ist behoben“* ohne Zitat muss weiter abweisen.
