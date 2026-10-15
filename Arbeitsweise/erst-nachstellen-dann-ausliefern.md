---
name: erst-nachstellen-dann-ausliefern
description: "Ein Paket, das Gregors Fehler beheben soll, braucht vorher am eigenen Prüfstand: alter Stand rot, neuer grün - E-121 brauchte sechs Pakete, das erste nachgestellte hielt beim ersten Anlauf"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-15T12:28:57.983Z
---

Schranke: tools/pruefe-nachgestellt.pl (pre-commit) - eine neue Tabellenzeile „Gemessen“ eines bereitgestellten Pakets in Releases/PAKETE.md muss einen roten alten Stand nennen, sonst „ohne Nachstellung“ mit Gregors wörtlichem Ja. Gegengetestet mit --selbsttest (13 Fälle) und an den sechs echten Commits 1.0.91 bis 1.0.96.

# Erst nachstellen, dann ausliefern

**Regel.** Ein Paket, das einen von Gregor gemeldeten Fehler beheben soll, geht
erst an ihn, wenn ich **seinen** Fehler am eigenen Prüfstand am alten Stand
gesehen habe und am neuen nicht mehr. Gelingt das Nachstellen nicht, ist der
Prüfstand das nächste Arbeitspaket — nicht das nächste Paket. Ob ein Paket
ungemessen zu ihm geht, entscheidet er, nicht ich.

## Was passiert ist (15.10.2026, E-121, Zeiten UTC)

Gregor an 1.0.90 am 14.10.: *„mails erscheinen nach dem verschieben 2x“*. Am
15.10. folgten sechs Pakete:

| Paket | aus dem Quelltext abgeleitete Ursache | eigener Prüfstand | bei Gregor |
|---|---|---|---|
| 1.0.91 (06:18) | Vorab-Kopie wird nicht ersetzt | neuer Stand `summen=1`; **die Gegenprobe an 7.2.0.90 zeigte den Fehler in fünf Läufen nicht** — 06:14: *„daher nutze ich deine Beobachtung an 1.0.90 als Nachweis“* | weiter doppelt (06:27) |
| 1.0.92 (07:43) | Kopie trägt lokale Kennung statt UID | Läufe hingen am Start-Abgleich: *„nicht im Doppelfall gemessen“* | *„ja, 3 mails, jede 2x drin“* (08:38) |
| 1.0.93 (09:01) | GMX meldet „vermutlich“ kein UIDPLUS | vier Läufe hingen; 08:58: *„dein GMX-Konto bleibt der eigentliche Prüfstein“* | *„FAILED“* (09:06); sein Protokoll widerlegt die Vermutung |
| 1.0.94 (10:29) | Abgleich übernimmt ohne UID-Prüfung | *„ich teste selbst nichts und starte nichts“* | Liste doppelt, Daten einfach (10:35) |
| 1.0.95 (10:47) | `SubtractSum` trifft die falsche Listenzeile | nicht gemessen | neuer Dialog *„Attempt to add the message … failed“* (10:57) |
| 1.0.96 (11:38) | Kennung 13 = UID 13 einer fremden Mail | **an 1.0.95 Gregors Dialog nachgestellt, an 1.0.96 grün** (11:22–11:28) | *„ja, jetzt klappt es, der fehler tritt nicht mehr auf“* (11:59), erster Anlauf |

Dazwischen Gregor um 11:13: *„warum brauchen wir so viele anläufe, um es zu
fixen? dürfte doch nicht so schwer sein?“* Die Frage blieb ohne Antwort. Die
Antwort ist diese Tabelle: **fünfmal war Gregor der Prüfstand.**

Das Nachstellen, das 1.0.96 von den anderen unterscheidet, kostete 13 Minuten:
Option `--fremde-uid` im IMAP-Prüfserver (11:15), Schalter `-ZielBehalten` in
`tools/e118-serie.ps1` (11:19), Lauf an 1.0.95 rot (11:22). Den Hinweis, was
an seinem Fall anders ist, hatte Gregor um 09:09 selbst gegeben: *„ich rufe
übrigens bisher immer die mails frisch ab, erstelle jeweils neue personas.“*

## Warum die vorhandenen Lehren nicht gegriffen haben

- [[messung-muss-den-weg-treffen]] sagt, ein Gegentest an einem Stand ohne die
  Änderung beweise nichts. Sie handelt vom **Auswerten**. Ausgewertet war hier
  richtig — „Gegenprobe zeigt den Fehler nicht“ stand im Protokoll —, und dann
  wurde trotzdem ausgeliefert. Für die Entscheidung „ausliefern“ gab es keine
  Regel.
- [[pruefstand-kann-blind-sein]] hat ihre Schranke am Bau der Testsuite. Ein
  Prüfstand, der den Fehler **nicht erzeugen kann**, ist dieselbe Blindheit
  eine Ebene höher: der Prüfserver meldete immer `APPENDUID` (BEFUNDE.md,
  E-121: *„deshalb zeigte der Prüfstand das Doppel nie“*), und er hing seit dem
  14.10. um 10:49 am Start-Abgleich. Repariert wurde er nicht; drei Pakete
  gingen mit dem Vermerk „hing“ hinaus.
- [[erst-pruefen-dann-anweisen]]: jede der fünf Testanleitungen war ungeprüft.
  Die Lehre trägt „Schranke: keine“, weil im Repo eine ungeprüfte Anleitung
  aussehe wie eine geprüfte. **Das stimmt nicht ganz: die Zeile „Gemessen“ in
  `Releases/PAKETE.md` sagt es.** Fünfmal stand dort „nicht gemessen“ oder ein
  Wert ohne roten alten Stand. Dort sitzt jetzt die Schranke.
- [[pruefen-statt-vermuten]]: 1.0.93 baute auf *„GMX vermutlich nicht“*. Die
  Vermutung war als Vermutung gekennzeichnet und wurde trotzdem gebaut und
  ausgeliefert. Kennzeichnen allein hält nichts auf.
- [[kein-paket-mit-offenem-datenverlust]] greift nicht: die Doppelanzeige
  verlor keine Daten.

## Wechselwirkung mit der Bildschirm-Regel

Nach Gregors *„testen wir wieder beide? ohne absprache?“* (08:47) habe ich ganz
aufgehört, selbst zu messen: 1.0.94 und 1.0.95 gingen mit *„ich teste selbst
nichts und starte nichts“* hinaus. Richtig wäre gewesen, **anzukündigen und zu
fragen** und dann zu messen. Gregor um 11:05: *„die tests, die du selbst machen
kannst, machst du auch selbst.“* Die Rücksicht auf seinen Bildschirm bestimmt,
**wann** und **mit welcher Ansage** ich messe — nicht, **ob**
([[nichts-auf-gregors-bildschirm-starten]], Nachtrag 15.10.2026).

## How to apply

1. Gregors Fehler kommt herein → **zuerst** am Prüfstand den alten Stand rot
   sehen, mit seinem Symptom. Die Behebung gilt erst, wenn derselbe Lauf am
   neuen Stand grün ist.
2. Lässt sich der Fehler nicht nachstellen: fragen, was an **seinem** Fall
   anders ist (Server, Ordner offen, alte UID, frische Persona), und den
   Prüfstand dahin erweitern (`--ohne-appenduid`, `--fremde-uid`,
   `-ZielBehalten`). Ein hängender Prüfstand ist das nächste Arbeitspaket.
3. Geht es wirklich nicht (nur bei GMX, nur mit seinem Postfach): Gregor
   fragen, ob er das Paket ungemessen will, und sein Ja wörtlich in die Zeile
   „Gemessen“ schreiben: `ohne Nachstellung; Gregor am …: „…“`.
4. In jede Zeile „Gemessen“ gehört der rote alte Stand, Muster 1.0.96: *„an
   1.0.95 Gregors Fehler nachgestellt, an 1.0.96 grün“*.

**Lücken der Schranke.** Sie prüft, was in `PAKETE.md` **steht**. Wer
„Gegenprobe“ schreibt, ohne dass sie rot war, kommt durch; dagegen hilft nur,
den roten Messwert mit in die Zeile zu schreiben. Und eine Zeile „Gemessen“,
die schon vor dem Bereitstellen dastand, wird beim Bereitstellen nicht mehr
geprüft (die Schranke liest nur den Zuwachs).
