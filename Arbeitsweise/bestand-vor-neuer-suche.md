---
name: bestand-vor-neuer-suche
description: "Bevor etwas neu gesucht wird, wird der Bestand gelesen - die Antwort auf E-85 stand 14 Tage fertig in BEFUNDE.md, mit Zeilennummern und Handlungsanweisung"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
---

Schranke: `perl tools/offene-befunde.pl` (erster Handgriff jeder Sitzung, in CLAUDE.md als Punkt 1 verankert) und `perl tools/befund-suchen.pl <Datei oder Funktion>` (vor jedem neuen Befund - meldet es etwas, wird fortgeschrieben statt neu angelegt)

# Die Antwort lag fertig im Repo

**Gregor am 14.09.2026, 07:50 Uhr**, nachdem E-85 ueber zwei Tage, zwei
Fehlfassungen und eine ausgelieferte Zwischenfassung hinweg gesucht worden war:

> *„NP3-8 der IMAP-Empfang uebersetzt keinen Zeichensatz (Originalfehler) offen
> NP3-9 Rueckgabewert von ISOTranslate an zwei Stellen verworfen teilweise
> (POP behoben, IMAP offen) — dsa hat jemand auf dem schirm?"*

Und, als Einwurf mitten in den laufenden Zug:

> *„dann schreib dir auf, dass du am anfang immer die befunde.md durchgehst und
> liest und verstanden hast, was da noch offen ist! das nervt mich, wenn wir
> dinge aufschreiben und du sie vergisst und dann neu ausarbeitest, das ist sehr
> schlecht!"*

Dazu, eine Nachricht spaeter: *„du meinst, wir haben 53 releases und ein
grundsatz baustein fehlt?"*

## Was dort stand, und seit wann

| | |
|---|---|
| NP3-8 zum ersten Mal in `BEFUNDE.md` | **30.08.2026**, Commit `0c262d8` |
| Gregor meldet denselben Fehler als E-85 | **13.09.2026, 11:01 Uhr** |
| dazwischen | **14 Tage** |
| Urteil, das dort stand | *„Sicherheit: nachgewiesen. Originalfehler von QUALCOMM."* |
| behoben am Ende in | **7.2.0.52** — genau so, wie es dort stand |
| dazwischen ausgeliefert | Paket **1.0.51**, das den Fehler nicht behob |

Die Handlungsanweisung stand vollstaendig da, mit Zeilennummern:

> *„in `ImapDownload.cpp:4644` denselben Aufruf verwenden wie
> `mime.cpp:382-390`, am besten durch Aufruf von `FindMIMECharset` selbst, und
> die Abfrage in Zeile 4657 auf `> 2` ziehen."*

**Und ich habe E-85 als NEUEN Befund in dieselbe Datei eingetragen**, in der
NP3-8 stand. Nicht in eine andere Datei, nicht in ein anderes Verzeichnis — in
dieselbe.

## Warum der Bestand nicht gefunden wurde

`BEFUNDE.md` hat ueber 7800 Zeilen und mehrere Nummernkreise (`E-`, `NP-`,
`PR-`, `P-`, `X-`, `Z-`, `R-`, `V-`). Gesucht habe ich mit **meinen** Worten —
„Umlaute kommen falsch an". Der Eintrag heisst *„Der IMAP-Empfang uebersetzt
keinen einzigen Zeichensatz"*. Kein Wort davon kommt in der anderen
Formulierung vor.

**Der Ort ist in beiden Formulierungen derselbe.** Genau darauf sucht
`tools/befund-suchen.pl`, und es haette die Frage in einem Aufruf beantwortet.
Nachgemessen am 14.09.2026:

```
  befund-suchen: ImapDownload.cpp
  121 Abschnitt(e) in BEFUNDE.md durchsucht

  ES GIBT SCHON 5 BEFUND(E) ZU DIESEM ORT:

    NP3-8    Der IMAP-Empfang uebersetzt keinen einzigen Zeichensatz
             **Sicherheit: nachgewiesen. Originalfehler von QUALCOMM.**
```

NP3-8 steht an erster Stelle, mit dem Urteil in der zweiten Zeile.

**Why:** Ein Befund aufzuschreiben ist die Haelfte der Arbeit
([[wissen-gehoert-in-dateien]]). Die andere Haelfte ist der Moment, in dem er
wieder gelesen wird — und der war bis zum 14.09.2026 nirgends festgelegt.
Solange er fehlt, ist eine wachsende Befunddatei kein Gedaechtnis, sondern ein
Archiv: sie kostet Schreibzeit und spart keine Suchzeit. Der Schaden ist nicht
die doppelte Arbeit allein; es ist, dass die doppelte Arbeit **schlechter**
ausfaellt als der Bestand. NP3-8 trug „nachgewiesen" und eine Zeilennummer;
meine Neuausarbeitung brauchte drei Anlaeufe und hat unterwegs ein falsches
Paket ausgeliefert.

## Wie anwenden

1. **Zu Sitzungsbeginn, vor der ersten inhaltlichen Antwort:**
   `perl tools/offene-befunde.pl`. Das nennt jeden offenen Befund und gleicht
   ihn gegen `WEITERMACHEN.md` ab. Es steht als Punkt 1 in `CLAUDE.md`, damit
   es beim Laden gelesen wird und nicht erinnert werden muss.
2. **Vor jedem neuen Befund:** `perl tools/befund-suchen.pl <Datei oder
   Funktion>`. Gesucht wird der **Ort im Quelltext**, nie die Beschreibung des
   Symptoms. Wer mit seinen eigenen Worten sucht, findet seine eigenen Worte.
3. **Meldet das Werkzeug etwas, wird fortgeschrieben, nicht neu angelegt.**
   Erst wenn es nichts meldet, ist ein neuer Eintrag berechtigt.
4. **Ein Eintrag mit „Sicherheit: nachgewiesen" und einer Zeilennummer ist eine
   Handlungsanweisung, keine Hintergrundlektuere.** Er wird abgearbeitet oder
   begruendet zurueckgestellt ([[zurueckgestellte-befunde]]) — beides
   schriftlich.
5. **Wenn Gregor einen Befund aus dem eigenen Repo zitiert, ist das ein Befund
   ueber mich.** Seine Frage *„dsa hat jemand auf dem schirm?"* hat keine
   Sachauskunft verlangt, sondern eine Luecke benannt.

**Dieselbe Form, am selben Tag, ein zweites Mal:** die Schranke, die den
`reset --hard` vom 14.09.2026 aufgehalten haette, gab es ebenfalls schon —
`tools/ungesichertes-melden.pl`, gebaut, dokumentiert, und im entscheidenden
Moment nicht aufgerufen ([[verwerfen-nur-mit-zaehler]]). Ein Befund ohne
Lesezeitpunkt und ein Werkzeug ohne Aufrufstelle sind derselbe Fehler
([[werkzeug-vor-eigenbau]], [[lehren-anwenden-nicht-nur-schreiben]]).

Siehe ausserdem [[pruefen-statt-vermuten]] — dort wird die vorhandene **Quelle**
geoeffnet, hier der vorhandene **Befund**.
