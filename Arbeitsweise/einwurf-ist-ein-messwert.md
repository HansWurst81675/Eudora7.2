---
name: einwurf-ist-ein-messwert
description: "54 Prozent von Gregors Nachrichten kamen mitten in den laufenden Zug - das misst fehlenden Zwischenstand, nicht Beteiligung"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T20:05:08.076Z
---

Schranke: tools/verlauf-messen.pl - zaehlt Einwurfquote, Wiederholungssignale und die groessten Bloecke ohne Zwischenstand. Ausloeser ist der CHRONIST-Lauf, und CHRONIST wird seit dem 13.09.2026 von tools/rollen-faellig.pl faellig gemeldet - im pre-commit meldend, beim Paketbau abweisend. Kein eigener Hook: das Transkript liegt ausserhalb des Repos und ist bei jedem Commit dasselbe.

## Der Auslöser

**Gregor am 13.09.2026 um 10:56:51:**

> *„erst den einen schritt abwarten, dann den nächsten. nichts durcheinander
> bringen"*

Er hat die Regel also selbst formuliert — am Vormittag. Am Abend lief es
wieder anders.

## Die Messung

`tools/verlauf-messen.pl` über den 13.09.2026:

```
  Nachrichten von Gregor                  55
    davon regulaer (er war am Zug)        25
    davon EINWURF im laufenden Zug        30   (54%)
  mit Wiederholungssignal                  7
  Werkzeugaufrufe gesamt                 330
  groesster Block ohne neue Nachricht     44 Werkzeugaufrufe
```

**Mehr als jede zweite Nachricht kam, während ich noch arbeitete.** Ein
Einwurf ist kein Zeichen von Beteiligung — er heißt: Gregor wartet, und was
er sieht, reicht ihm nicht.

Die größten Blöcke zeigen, wo es kippt:

| Beginn | ohne neue Nachricht | was danach kam |
|---|---|---|
| 18:14:20 | **44 Werkzeugaufrufe, 24 Minuten** | *„sag' mir, wenn du was für mich zum testen hast."* |
| 18:39:33 | **40 Werkzeugaufrufe, 18 Minuten** | *„maschst du wieder alles allein?"* |
| 18:03:58 | 27 Werkzeugaufrufe | — |

In beiden großen Blöcken habe ich durchaus geredet (23 bzw. 15
Textabschnitte). **Das Problem war nicht Schweigen, sondern dass nichts
davon eine Frage beantwortete, die Gregor offen hatte.**

### Wiederholungen, wörtlich

Sieben Nachrichten tragen ein Signal, dass er es nicht zum ersten Mal sagt:

> *„warum fehlen wieder daten? mach es besser, daß es nicht immer wieder
> passiert!"* (10:41)
> *„ist doch nichts neues, seit wievielen tagen arbeiten wir dran? hast du
> nichts gelernt?"* (10:42 — 59 Sekunden später, weil die erste nicht reichte)
> *„keine lügen auf dem main, gilt immer noch."* (10:45)
> *„das hatten wir ja bereits gefixt, soweit ich mich erinnern kann?"* (11:02)
> *„maschst du wieder alles allein?"* (18:57)

Dazu, unabhängig gezählt: **das Release 0.50 hat er fünfmal angesprochen** —
10:40, 10:49, 11:04, 11:19 und 11:23 (*„wann 0.50?"*), über **43 Minuten**.
Die Ursache dafür ist belegt und inzwischen behoben: `paket-bauen.ps1` wies
viermal hintereinander ab, jedes Mal wegen eines anderen Mangels, weil jede
Schranke mit `exit 1` aussteigt. `tools/paket-bereit.pl` fährt jetzt dieselben
Schranken und zeigt alle Mängel auf einmal — nachgemessen am 13.09.2026:
*„WEIST AB (2 von 6)"* statt eines Mangels pro Anlauf. Gregor dazu:

> *„du hast nach mind. 51 releases noch keine funktionierende tool chain, auf
> die du dich verlassen kannst?"*

## Why

Ein langer Block ist für mich billig und für Gregor teuer. Ich sehe den
Fortschritt, er sieht eine Wand aus Werkzeugaufrufen. Wenn nach 24 Minuten
kein greifbares Ergebnis dasteht, bleibt ihm nur der Einwurf — und der kostet
ihn Aufmerksamkeit, die er für die eigentliche Arbeit bräuchte.

Die Quote misst genau das, und sie ist nachprüfbar statt gefühlt. Das
unterscheidet sie von *„ich melde mich öfter"*, was schon mehrfach als Vorsatz
dastand und nichts geändert hat ([[nie-stillstehen]] verlangt das Gegenteil
vom Stillstand, nicht Schweigen bei Betrieb).

## How to apply

* **Vor einem Block, der länger als ein paar Minuten dauert, sagen, was am
  Ende dasteht und wann** — und wenn es länger wird als angekündigt, das von
  selbst melden ([[nie-stillstehen]]).
* **Offene Fragen zuerst.** Vor jedem neuen Arbeitsschritt prüfen, ob eine
  Frage von Gregor unbeantwortet ist. 40 Werkzeugaufrufe, die seine Frage
  nicht berühren, sind aus seiner Sicht Stillstand.
* **Ein Wiederholungssignal ist ein Alarm, kein Nebensatz.** *„wieder"*,
  *„immer noch"*, *„das hatten wir"* heißen: hier ist eine Fehlerklasse offen,
  die eine Schranke braucht ([[fehlerklassen-abstellen]]) — nicht noch eine
  Entschuldigung.
* **Bei jedem CHRONIST-Lauf `tools/verlauf-messen.pl` fahren** und die Quote
  gegen den Vorlauf halten. Steigt sie, ist die Zusammenarbeit schlechter
  geworden, ganz gleich wie viel Code entstanden ist.

## Beim Bau dieses Werkzeugs

Zwei Dinge, die ohne Gegenprobe durchgegangen wären:

1. Die erste Auswertung fand **23 Nachrichten und keine einzige der vier
   Beschwerden**, um die es ging. Grund: Gregors Einwürfe stehen im
   Transkript nicht als `type: user`, sondern als
   `attachment.type: "queued_command"`. Wer nur nach `user` filtert, sieht
   ausgerechnet die wichtigsten Nachrichten nicht.
2. Das Muster für die Wiederholungssignale stand zuerst mit `/x` — und `/x`
   verschluckt die **Leerzeichen im Muster**, aus `immer noch` wurde
   `immernoch`. Es fand 3 statt 7 Stellen. Aufgefallen ist es nur, weil eine
   unabhängige `grep`-Zählung 7 ergeben hatte
   ([[gegenprobe-umdrehen]], [[ausreisser-ist-der-befund]]).

## Nachtrag 12.10.2026: die Quote fiel auf 25 %, und die Nachfrage kam trotzdem als regulärer Zug

Gemessen mit `perl tools/verlauf-messen.pl 7cea137a-….jsonl 2026-10-12T09:40`:

| Zeitraum (Ortszeit) | Gregor | Einwurf |
|---|---:|---:|
| 12.10., 11:03–11:26 | 9 | 6 (66 %) |
| 12.10., 11:40–12:05 | 4 | **1 (25 %)** |

Der eine Einwurf (11:40:47, *„achtung: …/pull/83 reingemerged"*) war eine
**Sachmeldung**. Gregor wartete nicht, er teilte eine Änderung der Lage mit.
Ungeduld war das nicht. Zwischen 11:40 und 12:05 gab es 23 Zwischenmeldungen
auf 83 Werkzeugaufrufe.

Trotzdem gab es um 11:55:36 *„ich sehe noch keine 0.82 version"*. Das
Werkzeug zählt diese Nachricht als **regulär**, weil der Zug um 11:51:26
beendet war. Inhaltlich ist sie eine Nachfrage: Der Stand, den ich
gemeldet hatte, beantwortete Gregors Frage nicht (siehe
[[fertige-fassung-bereitstellen]], Nachtrag 12.10.2026).

**How to apply:** Die Einwurfquote misst, *wann* Gregor schreibt, aber
nicht, *warum*. Eine reguläre Nachricht, die einen Zustand erfragt („ich
sehe noch kein …", „wo liegt …", „läuft … schon?"), gehört in dieselbe
Spalte wie ein Einwurf. `verlauf-messen.pl` sollte solche Nachfragen
gesondert zählen (Vorschlag unten im CHRONIST-Bericht).

## Nachtrag 13.10.2026, 10:27: der Einwurf kam zur angekündigten Zeit

Gemessen mit `perl tools/verlauf-messen.pl 7cea137a-….jsonl 2026-10-13T10:11`:
3 Nachrichten, 2 davon Einwurf (66 %), größter Block 3 Werkzeugaufrufe.
Am Schweigen lag es also nicht.

Um 10:12:59 UTC stand im Stand: *„Es laufen noch LEKTOR und CHRONIST, etwa
15 Minuten. Danach baue ich das Paket."* Um 10:22 kam der LEKTOR-Fund
(Gegenrichtung von N1, siehe [[fund-ganz-abhaken]]), und die Arbeit wurde
länger. Eine neue Zeit wurde nicht genannt. Um 10:27:57, genau nach den
angekündigten 15 Minuten, fragte Gregor *„kann ich was mergen?"*. Die
Antwort war richtig gebaut ([[abschalten-ist-ein-termin]]): *„Noch nicht"*
stand vorn, dazu, was auf dem Zweig liegt. Um 10:29:44 kam der zweite
Einwurf, *„ok. 15 min. sollten reichen. kann ich schon lokal was testen?"*.
Er hat die Zeit selbst wiederholt und nach einer Beschäftigung für die
Wartezeit gefragt.

**How to apply, zusätzlich:** Eine angekündigte Zeit ist eine Frist
([[abschalten-ist-ein-termin]]). Verschiebt ein Fund die Arbeit, kommt die
**neue Zeit in dieselbe Meldung wie der Fund**, hier also um 10:22: *„dadurch
etwa 10 Minuten später"*. Gibt es währenddessen etwas, das Gregor schon
prüfen kann, wird das mit angeboten, bevor er danach fragt.

## Nachtrag 15.10.2026 (CHRONIST): die Frage, die niemand beantwortet hat

`tools/verlauf-messen.pl` ab 14.10.2026 06:50 UTC: **95 Nachrichten, 51
Einwürfe (53 %)**, 523 Werkzeugaufrufe, größter Block 41 ohne neue Nachricht.
Die Quote liegt wieder auf dem Stand vom 13.09.2026.

Drei Muster darin:

1. **Eine Sachfrage blieb ganz ohne Antwort.** 15.10., 11:13: *„warum brauchen
   wir so viele anläufe, um es zu fixen? dürfte doch nicht so schwer sein?“*
   Danach kamen Nachstellen, Paket, Bestätigung, Rollen — eine Antwort auf
   diese Frage kam nicht. Sie hätte gelautet: weil fünf Pakete ohne
   Nachstellung am eigenen Prüfstand hinausgingen
   ([[erst-nachstellen-dann-ausliefern]]). Eine Frage nach dem **Warum** ist
   die Frage, auf die eine Lehre antwortet; sie zu überspringen heißt, die
   Lehre nicht zu ziehen.
2. **Vordergrundläufe machen taub.** 15.10., 11:22:30 *„testen wir wieder beide
   parallel?“* — 11:23:58 *„ich habe was gefragt.“* — Antwort 11:26:28, erst
   als der Prüfstandlauf zurückkam. 14.10. ebenso: Fragen um 10:44, 10:51,
   10:53, erste Antwort 10:58. Ein Lauf, der Minuten dauert, gehört in den
   Hintergrund ([[nie-stillstehen]],
   [[nichts-auf-gregors-bildschirm-starten]], Nachtrag 15.10.2026).
3. **78 Minuten ohne Antwort, ungeklärt.** 15.10., 09:09:56 *„willst du was
   testen? oder brauchst du noch meine instanz?“* — beantwortet 10:29:54. Der
   eine Werkzeugaufruf dazwischen (Commit, `git push`, Paket 1.0.94) begann
   09:10:35 und kam 10:27:47 zurück, mit *„Failed to connect to
   github.com:443“*. Ob der Rechner ruhte oder der Aufruf hing, ist aus dem
   Verlauf nicht zu entscheiden; gemessen ist nur die Lücke. Ein `git push`
   gehört nicht in denselben Vordergrundaufruf wie die Arbeit, auf die Gregor
   wartet ([[haengende-kommandos-abbrechen]]).
