---
name: eingebaute-messung-auslesen
description: "Eine Spurmarke, die niemand ausliest, ist keine Messung - der Moment des Auslesens gehoert an das naechste Paket"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-14T00:00:00.000Z
---

Schranke: tools/spuren-auswerten.pl (paket-bauen)

# Wer eine Messung einbaut, hat sie noch nicht gemacht

Befund E-70 — die Andockgroessen der Leisten ueberleben keinen Neustart —
stand vom 10.09.2026 an offen. Die Spurmarken dazu lagen seit Paket **1.0.37**
im Bau. Gelesen wurden sie zum ersten Mal an **1.0.40**.

Dazwischen sind 1.0.38, 1.0.39 und 1.0.40 gebaut und ausgeliefert worden,
jedes mit der Bitte an Gregor, etwas **anderes** zu pruefen. Drei Pakete lang
hat die Marke mitgeschrieben, und niemand hat hingesehen. Als das Protokoll
endlich ausgewertet wurde, brauchte es zwei Zeilen:

    E-70 gesichert:  40 Zeilen
    E-70 geladen:     0 Zeilen

Dazu `DockVertCx319=586` in Gregors `Eudora.ini`. Damit war alles entschieden:
der Wert wird richtig geschrieben und nie gelesen. Der Rest war eine halbe
Stunde Arbeit.

**Why:** Eine Spurmarke kostet einen Bau, ein Paket, eine Bitte an Gregor und
eine Rueckmeldung von ihm — der ganze Preis ist bezahlt, **bevor** der Nutzen
entsteht. Der Nutzen entsteht in einem einzigen Moment: wenn jemand das
Protokoll auf diese Marke hin liest. Fuer diesen Moment gibt es keinen
Anlass. Er faellt nicht auf, wenn er ausbleibt; das Protokoll wird ja
geschrieben, die Zeilen stehen da, alles sieht nach Messung aus.

Deshalb ist der Einbau die **gefaehrlichste** Stelle: er fuehlt sich an wie
Fortschritt und erzeugt das Gefuehl, die Frage sei jetzt in Arbeit. Sie ist
es nicht. Sie ist beantwortet und ungelesen. In diesen drei Paketen habe ich
die Ursache statt dessen **geraten** — die Antwort lag die ganze Zeit auf
Gregors Platte.

Das ist die Spiegelung von [[zwei-werte-in-eine-ausgabe]]: dort war die
Messung richtig gebaut und hat den Widerspruch in einer Zeile erledigt. Hier
war sie ebenso richtig gebaut — und lag drei Pakete lang ungeoeffnet daneben.
Eine gute Messung und eine gelesene Messung sind zwei verschiedene Dinge.

**How to apply:**

1. **Eine Marke bekommt beim Einbau einen Termin, nicht nur eine Stelle.**
   Der Termin ist immer derselbe: die **naechste Rueckmeldung von Gregor** zu
   der Fassung, in der die Marke zum ersten Mal mitfaehrt.
2. **Der Termin steht schriftlich**, in `Befunde/SPURMARKEN.md`: eine Zeile je
   Befund mit *eingebaut*, *ausgewertet* und einem Satz, **was sie gesagt
   hat**. „Nichts gefunden" ist ein Ergebnis und gehoert hin.
3. **Vor jedem Paket wird gegen diese Tabelle geprueft.**
   `tools/spuren-auswerten.pl` weist ab, wenn eine Marke aus einer frueheren
   Fassung noch nicht ausgewertet ist. Eine Marke, die mit dem gerade
   gebauten Paket zum ersten Mal hinausgeht, ist in Ordnung — sie soll ja
   erst noch mitlaufen.
4. **Wenn ein Protokoll kommt, wird es zuerst nach den eigenen Marken
   durchsucht**, vor jeder anderen Auswertung. Ein `grep` je offener Marke,
   und die Zahl der Treffer gehoert genannt — **auch die Null**. Genau die
   Null war hier die Antwort.
5. **Eine Marke, deren Befund behoben ist, wird ausgebaut oder ihre Zeile
   verschwindet.** Sonst wird die Tabelle zum Rauschen, und eine Schranke,
   die dauernd auf Altes zeigt, wird abgeschaltet
   ([[schranke-gegentesten]]).
6. **Soll eine Marke bewusst ohne Auswertung weiterlaufen**, steht das in der
   Spalte *ausgewertet* als `entfaellt: <Begruendung>`. Damit ist die Luecke
   sichtbar und zaehlbar statt vergessen — dieselbe Bauform wie das
   „Schranke: keine — <Begruendung>" in [[lehren-anwenden-nicht-nur-schreiben]].

**Was die Schranke beim ersten Lauf gefunden hat:** die Marken zu **E-66**
liegen seit **1.0.35** im Bau und sind seit dem Umbau auf den Weg ueber
`ZiehenAmRand` **nie wieder gelesen** worden — bei Fassung 1.0.41 also sechs
Pakete lang. Derselbe Fall wie E-70, am selben Tag, im selben Baum. Eine
Fehlerklasse, kein Einzelfall ([[fehlerklassen-abstellen]]).

Gegengetestet in beide Richtungen: die Schranke weist ab bei einer offenen
Marke, bei einer Marke ohne Zeile in der Tabelle und bei einer Begruendung,
die zu kurz ist, um eine zu sein; sie laesst durch, wenn die Marke mit der
gerade gebauten Fassung frisch eingebaut ist, wenn sie ausgewertet ist und
wenn `entfaellt:` mit tragfaehiger Begruendung dasteht. Eine Zeile ohne Marke
im Quelltext wird gemeldet, weist aber nicht ab. Die Einbindung in
`tools/paket-bauen.ps1` ist einzeln gefahren worden, nicht nur gelesen
([[messung-muss-den-weg-treffen]]).

## Nachtrag 13./14.09.2026: die andere Richtung — gar nichts eingebaut

Alles oben beschreibt **eine** Richtung: die Marke war da und wurde nicht
gelesen. Am 13.09.2026 kam die Umkehrung, und sie ist teurer.

Bei **E-85** (Umlaute in per IMAP abgerufenen Nachrichten) habe ich zweimal
„behoben" gemeldet — Commit `881d5c4` um 18:45 Uhr, an Gregor um 19:00 Uhr —
und ein Paket 1.0.51 ausgeliefert, **ohne eine einzige Messung im Programm**,
die gesagt hätte, ob der geänderte Weg überhaupt genommen wird. Der erste Fix
reparierte den Suchbereich, der zweite die Quelle. Beide Male hiess es vorher
„behoben".

Um 20:22:48 Uhr, als Gregors Bild den Fehler weiter zeigte, stand da:

> *„Das Protokoll zeigt Abrufe (‚1 message(s) left to download'), aber **keine
> Spurmarke aus dem IMAP-Übersetzungsweg** — die habe ich nicht eingebaut."*

Was an ihre Stelle trat, war eine Ersatzmessung, die nichts entscheiden
konnte: Bytefolgen in der Mailboxdatei zählen. Ergebnis 322 UTF-8-Folgen
gegen 228 CP1252-Umlaute, **gemischt** — und dazu mein eigener Satz *„ich
kann nicht sagen, ob dieser Teil von 0.51 stammt oder von 0.50"*. Die Datei
enthält Nachrichten aus Tagen; eine Messung, die die Fassungen nicht trennen
kann, ist keine.

Drei Minuten später habe ich es selbst benannt:

> *„Ich habe keine Spurmarke in den Übersetzungsweg gebaut — derselbe Fehler,
> den `Arbeitsweise/eingebaute-messung-auslesen.md` beschreibt, nur diesmal
> von der anderen Seite: gar nichts eingebaut."*

Mit der Marke war es am nächsten Morgen in **einer Zeile** entschieden:

    E-85 imap: teil-charset=utf-8  tl-charset=(keiner)  idx=4  uebersetzt=ja

Der Top-Level-Header nennt keinen Zeichensatz, der MIME-Teil nennt `utf-8`.
Vorher stand dort `idx=0, uebersetzt=nein`. Dazu die Gegenprobe in der
Mailboxdatei: **null** unübersetzte UTF-8-Folgen im zuletzt geschriebenen
Teil, am Vortag 76.

**Warum die Schranke oben das nicht fängt:** `spuren-auswerten.pl` hält die
Marken **im Quelltext** gegen `Befunde/SPURMARKEN.md`. Eine Marke, die es
nicht gibt, steht in keiner der beiden Listen. Die fehlende Marke ist für
dieses Werkzeug **unsichtbar** — genau wie der stumme Prüfstand in
[[pruefstand-kann-blind-sein]]. Beides sind Lücken, die sich nicht von selbst
melden, weil nichts fehlschlägt.

**Die Ergänzung zur Regel:**

- **Die Spurmarke gehört in denselben Commit wie die Behebung**, nicht in den
  Commit danach und erst recht nicht in den nach dem zweiten Fehlversuch. Wer
  eine Zeile ändert, deren Wirkung Gregor melden soll, baut im selben Zug die
  Zeile ein, die sagt, ob sie durchlaufen wurde.
- **Eine Behebung ohne beobachtbaren Weg ist nicht lieferbar.** Nicht „nicht
  bestätigt" — **nicht lieferbar**. Das Paket kostet Gregor einen Testlauf,
  und der Testlauf kann nichts entscheiden.
- **Ersatzmessungen an Dateien, die über mehrere Fassungen gewachsen sind,
  zählen nicht.** Sie liefern eine Zahl, keine Zuordnung. Wer eine solche Zahl
  nennt, nennt im selben Satz, was sie **nicht** trennen kann.
- **Für diese Richtung greift eine andere Schranke:**
  `tools/pruefe-behoben-belegt.pl` (`pre-commit`) weist jedes neu geschriebene
  „behoben" ab, das keinen Beleg nennt — und eine Spurmarke mit ihrem
  Messwert ist einer der vier zulässigen Belege. Damit hat jetzt jede der
  beiden Richtungen ihre eigene: `spuren-auswerten.pl` gegen die ungelesene
  Marke, `pruefe-behoben-belegt.pl` gegen die fehlende.

Siehe [[unterschied-im-selben-bild]] — der zweite Teil desselben Vorfalls:
während die Marke fehlte, lag der Befund die ganze Zeit sichtbar in Gregors
Bildschirmfoto.

Siehe [[pruefen-statt-vermuten]] — der zweite Teil desselben Vorfalls: der
Grund stand als Kommentar fuenf Zeilen ueber dem Einbau. Ausserdem
[[daueraufgaben-brauchen-einen-takt]] und [[wissen-gehoert-in-dateien]].
