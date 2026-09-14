---
name: unterschied-im-selben-bild
description: "Was im selben Bild richtig ist, schliesst jede gemeinsame Ursache aus - der Unterschied ist der Befund"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-14T05:58:46.460Z
---

Schranke: keine - ob zwei Teile DESSELBEN Bildes verschieden bewertet wurden, entscheidet sich beim Lesen eines Bildschirmfotos, nicht am Baum

# Der Befund steht im Bild, nicht im nächsten Werkzeugaufruf

**Gregor am 13.09.2026, 11:01:42 Uhr**, mit einem Bildschirmfoto von 7.2.0.50:

> *„prüf mal hier die umlaute, die sehen noch falsch aus. habe gerade mails
> per IMAP abgerufen"*

**Derselbe Gregor, 13.09.2026, 20:29:02 Uhr**, mit einer weitergeleiteten Mail:

> *„das ist auf jeden fall eine frische mail, ist aber falsch dargestellt!"*

## Was im ersten Bild stand — nachgemessen, nicht erinnert

Das Foto von 11:01:42 zeigt **ein** Eudora-Fenster mit **zwei** Aussagen
gleichzeitig:

| Stelle im Bild | Was dort steht | Urteil |
|---|---|---|
| Betreffspalte der Nachrichtenliste | *„Fwd: Gregor Czempik, winzige Hörgeräte"*, *„WG: Einführung in das Drohnenrecht"* | **richtig** |
| Anzeigebereich darunter | jeder Umlaut als zwei Zeichen, jedes typografische Anfuehrungszeichen als drei - die UTF-8-Bytes (`C3 BC` fuer `u`-Umlaut, `E2 80 9E` fuer das oeffnende Zitatzeichen) roh als CP1252 gelesen | **falsch** |

Beide Texte kommen aus **derselben** Nachricht, über **dieselbe**
IMAP-Verbindung, in **dieselbe** Mailboxdatei, auf **denselben** Bildschirm.
Alles, was beiden gemeinsam ist, scheidet damit als Ursache aus: die
Verbindung, der Server, die Schriftart, die Codepage der Anzeige, die
Mailboxdatei als Ganzes. Übrig bleibt genau die Stelle, an der sich die
beiden Wege trennen — und die ist bekannt: der Betreff läuft über
`Fix2047`/`Translate2047` in `lex822.cpp`, der Rumpf über
`ImapDownload.cpp`.

**Ich wusste das.** Am selben Tag um 19:15 Uhr steht in meinem eigenen
Erzeugerskript für die Testmail wörtlich:

> *„Er bleibt bewusst reines ASCII: ein Umlaut im Betreff nimmt einen ANDEREN
> Weg durch den Code (Fix2047 / Translate2047 in lex822.cpp) als der Rumpf."*

Das Wissen lag also vor, als Baustein für eine **konstruierte** Mail — und
wurde nicht auf das **echte** Bild angewandt, das seit acht Stunden offen im
Gespräch stand.

## Die Kosten, gezählt

| | |
|---|---|
| Kombination im Bild sichtbar ab | 13.09.2026, **11:01:42** |
| Kombination zum ersten Mal ausgesprochen | 13.09.2026, **20:29:19** |
| dazwischen | **9 Stunden 27 Minuten**, **318 Werkzeugaufrufe** im Hauptstrang |
| dazwischen: „behoben" gemeldet | **zweimal** — Commit `881d5c4` um 18:45, an Gregor um 19:00 |
| dazwischen: ausgeliefert | Paket **1.0.51**, das den Fehler nicht behob |
| zwischen Gregors Einwurf 20:29:02 und der Auswertung 20:29:19 | **0 Werkzeugaufrufe** |

Die letzte Zeile ist die, auf die es ankommt. Die Auswertung brauchte **kein
einziges Werkzeug**. Sie brauchte siebzehn Sekunden Hinsehen. Die 318 Aufrufe
davor haben in eine Richtung gesucht, die das Bild schon ausgeschlossen
hatte.

Was dann in einer Minute dastand: `ImapDownload.cpp` liest den Zeichensatz
aus `m_pHd->m_TLMime` — **T**op **L**evel. Bei `multipart/alternative`, und
das ist jeder HTML-Newsletter, steht im Top-Level-Header gar kein `charset`,
nur `boundary`. Der Zeichensatz des Teils stand die ganze Zeit in
`body->parameter` und wurde nie gelesen.

**Why:** Ein Bild, in dem **etwas funktioniert**, ist keine halbe schlechte
Nachricht — es ist eine **Differenzmessung**, und zwar eine, die Gregor
umsonst geliefert hat. Sie ist mehr wert als jede konstruierte Testmail, weil
sie aus dem echten Betrieb kommt und beide Seiten unter identischen
Bedingungen zeigt. Der Grund, warum sie trotzdem übersehen wird: das Auge
sucht den **Fehler**, und der Fehler ist die Hälfte, die nichts ausschließt.
Die aussagekräftige Hälfte ist die, die **in Ordnung** ist — und die sieht
aus wie Hintergrund.

Dazu kommt ein zweiter Grund, der schwerer wiegt: Ich habe das erste Bild
**weggeredet**, statt es zu messen — *„Beide Screenshots zeigen Mails vom
11./12./13.09., die vor 0.51 abgerufen wurden"*. Gregor hatte schon um
11:01 dazugeschrieben *„habe gerade mails per IMAP abgerufen"*. Die
Erklärung, warum ein Beleg nicht zählt, ist der teuerste Satz im Projekt:
danach hört das Messen auf.

**How to apply:**

1. **Jedes Symptombild wird zweimal gelesen: einmal auf das, was falsch ist,
   und einmal auf das, was daneben richtig ist.** Die zweite Lesung ist die
   eigentliche Messung. Sie kostet keine Werkzeugaufrufe.
2. **Was funktioniert, wird aufgeschrieben, bevor irgendetwas gesucht wird** —
   in den Befund, als eigener Satz: *„Im selben Bild richtig: …"*. Steht dort
   nichts, heisst es *„keine Gegenprobe im Bild"*, und das ist dann ein
   bekannter Mangel und keine Lücke ([[eingebaute-messung-auslesen]]).
3. **Aus dem Unterschied wird die Ursachenliste gebildet, nicht aus dem
   Fehler.** Die Frage lautet nie *„warum ist der Rumpf falsch"*, sondern
   *„wo trennen sich Betreff und Rumpf"*. Die erste Frage hat tausend
   Antworten, die zweite hat eine Fundstelle.
4. **Eine Erklärung, warum Gregors Beleg nicht zählt, muss gemessen sein.**
   *„Die Mail ist von vorgestern"* ist eine Vermutung über seine Mailbox.
   Wenn sie stimmt, sagt eine Spurmarke es in einer Zeile; wenn keine
   Spurmarke da ist, ist die Erklärung nicht verfügbar
   ([[pruefen-statt-vermuten]]).
5. **Ein neues „behoben" ohne Beleg wird abgewiesen.**
   `tools/pruefe-behoben-belegt.pl` prüft im `pre-commit` jede in diesem
   Commit **hinzugekommene** Befundzeile: sagt ihr Urteil „behoben", muss sie
   „von Gregor … bestätigt", „am laufenden Programm gemessen", eine
   Spurmarke mit Messwert oder „im Protokoll belegt" nennen. Eine verneinte
   Aussage — *„von Gregor ist nichts davon am laufenden Programm bestätigt"*,
   genau der Wortlaut von E-85 — zählt **nicht** als Beleg.

**Gegengetestet in beide Richtungen.** `--selbsttest` fährt 9 Fälle. Dazu am
echten Stand: die Zeilen, die `20f4820^` neu einbrachte (*„Alle drei Mängel
behoben in 7.2.0.51"*), werden **abgewiesen**, Rückgabe 1; die Zeilen aus
`26718ef` (*„behoben in 7.2.0.53, am laufenden Programm gemessen"*) laufen
**durch**, Rückgabe 0. Geprüft wird bewusst nur der Zuwachs: im Bestand
stehen 71 alte Zeilen ohne Beleg, und eine Schranke, die 71-mal meckert, wird
abgeschaltet ([[schranke-gegentesten]]).

**Was die Schranke nicht kann:** Sie hält niemanden davon ab, ein Bild
falsch zu lesen. Sie verhindert nur, dass aus dem falschen Lesen ein
schriftliches „behoben" wird, das jedem anderen den Anlass nimmt, noch
hinzusehen — der Schaden, den Gregor am 07.09.2026 benannt hat
([[erfolg-aus-anwendersicht]]).

Siehe [[gegenprobe-umdrehen]] — dieselbe Denkfigur von der anderen Seite:
dort wird der umgekehrte Wert durchgeschickt, hier wird der gelungene Teil
gelesen. Ausserdem [[ausreisser-ist-der-befund]], [[einwurf-ist-ein-messwert]]
und [[zwei-werte-in-eine-ausgabe]].
