---
name: schranke-liest-nur-code
description: "Eine Schranke, die Quelltext mit Regex prueft, muss Kommentare und Protokolltexte vorher wegwerfen und ihren Bereich am Rumpfende abschliessen - sonst liest sie ihre eigene Begruendung"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T07:55:51.680Z
---

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
