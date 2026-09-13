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
