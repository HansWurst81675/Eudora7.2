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

## Nachtrag 21.10.2026: „mal so, mal so" heißt drei Läufe je Fassung

Gregor zu [E-134](../BEFUNDE.md#e-134), am 21.10.2026:

> *„es war 1x nicht richtig, 1x richtig gespeichert, jetzt wieder falsch."*

Dieser Satz ist eine Messangabe. Er sagt: die Stelle ist **nicht
festgelegt**, und ein einzelner Lauf entscheidet gar nichts. Und so war es
auch — zwei Läufe derselben Fassung meldeten an derselben Codezeile einmal
*ausgewaehlt* und einmal *NICHT ausgewaehlt*, weil `SelectItem()` über
`TVN_SELCHANGED` → `OnSelChanged` → `SetFocus()` den Fokus verschiebt.

Deshalb wurde am Ende nicht einmal gemessen, sondern **dreimal gegen
dreimal**, jedes Mal mit frischem Prüfstand, Prüfgröße `NNdbase.txt`:

| Prüfstand | Fassung | Ergebnis |
|---|---|---|
| `C:\Temp\E134-G1` bis `-G3` | ausgeliefert 1.0.118 | 3 × `alias Untitled` |
| `C:\Temp\E134-F1` bis `-F3` | mit der Behebung | 3 × `alias hans` |

Ein einzelner grüner Lauf hätte auch den **Zwischenstand** bestätigt, der nur
eine der beiden Stellen behob; drei Läufe zeigten dort dreimal `alias h`
([[erfolg-aus-anwendersicht]], Nachtrag 21.10.2026).

**How to apply, als Ergänzung zu Punkt 1:**

- **Nennt Gregor das Fehlerbild in Häufigkeiten** — *„mal ja, mal nein",
  „1x so, 1x so", „manchmal", „meistens"* —, dann zählt die Behebung erst
  nach **drei** Läufen am neuen Stand und **drei** am alten. Ein roter alter
  Stand in einem Lauf ist bei einem nicht festgelegten Fehler kein roter
  alter Stand.
- **Die Läufe laufen auf getrennten, frischen Prüfständen** (`E134-F1`,
  `-F2`, `-F3`), nicht dreimal im selben. Ein zweiter Lauf im selben
  Verzeichnis sieht die Datei, die der erste geschrieben hat.
- **Die Zeile „Gemessen" nennt die Anzahl**, nicht nur das Ergebnis:
  *„je drei Läufe, 3 × `alias hans` gegen 3 × `alias Untitled` an 1.0.118"*.

**Noch nicht gebaut:** `tools/pruefe-nachgestellt.pl` prüft, dass ein roter
alter Stand dasteht, nicht, dass er mehrfach gemessen wurde. Die Erweiterung
wäre: nennt der Befund Gregors Häufigkeitswort, muss die Zeile „Gemessen"
eine Anzahl ≥ 3 tragen.

## Nachtrag 27.10.2026 (CHRONIST): E-137, fünf Anläufe, und die Schranke sah sieben Pakete lang nichts

Zeiten MEZ, gemessen am Transkript und an `Releases/PAKETE.md`. Dieselbe Tabelle wie am 15.10., nur mit Strg+W:

| Anlauf | Behebung | eigener Prüfstand | bei Gregor |
|---|---|---|---|
| 1 (25.10. 20:37, `ed0d53a2`) | in `OnCmdMsg`, nie erreicht | keiner | — (PRUEFER-56 fand es) |
| 2 (25.10. 21:23, `78f2ad2a`) | in `OnCommand` | keiner | angedockt *„e-137 PASSED“* (26.10. 10:42), eine Minute später *„jetzt wieder CTRL-W schließt nicht das filter fenster“* (10:43), T1 an 1.0.124 *„FAILED“* (13:50) |
| 3 (26.10. 14:04, `0b0b50de`) | Rahmen der schwebenden Leiste (`QCMiniDockFrameWnd`) | keiner; übersetzte bis 20:47 nicht einmal | U1 an 1.0.125: *„E-137, T1 FAILED“* (22:19) |
| 4 (26.10. abends, `73f706a5`) | dazu `OnNcLButtonDown` | keiner | nie ausgeliefert; PRUEFER-61 (27.10. 11:25): der Rahmen ist gar kein `QCMiniDockFrameWnd` |
| 5 (27.10. 11:29) | Hauptfenster merkt sich die zuletzt angeklickte Leiste | **erst nach Gregors Frage:** Fälle E-137a–c, rot an 1.0.125, grün an 1.0.126 (12:44–12:49) | *„V1–V3“* bestanden an 1.0.127 (17:15) |

Um 12:31:45 stand der Befehl zum Schnüren von 1.0.126 schon fest (*„Jetzt warte ich auf das Ergebnis des Prüfstands“*) – der Prüfstand hatte zu dem Zeitpunkt **keinen** Fall, der Gregors U1 nachstellt. Gregor um 12:38:27: *„gibt es jetzt auch einen neuen test, der den fehler von 0.125 abdeckt und prüft?“* Meine Antwort 12:40:12: *„Nein, einen Test, der den Fehler von 1.0.125 tatsächlich gefangen hätte, gibt es noch nicht.“* Der Fall war acht Minuten später fertig (`tools/messen-e137.ps1`, Fensterbotschaften an ein gemessenes Handle). **Zum dritten Mal war Gregor der Prüfstand**, und die Regel dieser Datei hätte es verhindert.

**Warum die Schranke schwieg (gemessen):** `tools/pruefe-nachgestellt.pl` prüft nur Zeilen `| Gemessen |` in Abschnitten, deren Zeile `Testverzeichnis` das Wort „bereitgestellt“ trägt (Zeilen 83–85, 96). Die Abschnitte für 1.0.121 bis 1.0.127 in `PAKETE.md` haben **keine einzige** solche Zeile, sie heißen jetzt `| Gegen den Bau gemessen |`, und das Testverzeichnis ist „abgelegt“. 1.0.111 bis 1.0.120 hatten sie noch (bis auf 116–118). Die Schranke ist seit sieben Paketen blind, ohne einen Ton zu sagen ([[pruefstand-kann-blind-sein]], [[schranke-teilt-nicht-die-annahme]]).

**How to apply, zusätzlich:**
- Meldet Gregor „FAILED“, ist der **nächste Handgriff der Prüfstandsfall**, nicht die nächste Behebung. Zwischen U1 (26.10. 22:19) und dem Fall (27.10. 12:49) lagen zwei Behebungen ohne Fall.
- Ein Paket, dessen Abschnitt keinen roten alten Stand nennt, ist nicht fertig, egal wie die Tabellenzeile heißt.

**Vorschlag für die Schranke (nicht gebaut):** `pruefe-nachgestellt.pl` erkennt den Paketabschnitt an der Überschrift `## 1.0.N`, nicht an „bereitgestellt“, und verlangt in **irgendeiner** Zeile des Abschnitts einen roten alten Stand (Muster wie bisher). Fehlt sie, meldet sie das. Gegenprobe: Abschnitt 1.0.125 (kein Fall) muss rot werden, 1.0.127 („rot an 1.0.125, grün an 1.0.126 und 1.0.127“ steht in BEFUNDE E-137, im Abschnitt nachzutragen) grün.

## Nachtrag 28.10.2026 (CHRONIST): E-166, diesmal in der richtigen Reihenfolge, und was „nachgestellt“ hier heißt

Zeiten MEZ, gemessen an Transkript `72be6093…`, `tools/TESTLAEUFE.md` und `Intern/pruefstand-buch.tsv` (Zweig `e166-junk_message_fix`).

| Schritt | Zeit | Ergebnis |
|---|---|---|
| Fehlerbild am Prüfstand rot (Paket 1.0.127, Gregors DLLs) | 13:39:58 / 13:40:13 | Lauf 9: nach Junk-*No* und *Konto → Eigenschaften* mit OK fehlt `AskedAboutJunk` in der INI. Lauf 10: die Frage kommt wieder |
| Bestand geprüft | 13:40:22 | `befund-suchen.pl persona.cpp` und `RemoveAllFromCache`: kein Befund zu dieser Stelle |
| Gregors Ja zu Zweig und Behebung | 14:02:15 | *„ja, e166-junk_message_fix, beheben“* |
| Bau, 314 Tests | 14:09:58 gemeldet | grün |
| Lauf 9 und 10 am neuen Bau | 14:14:51 / 14:15:24 | grün |
| Regressionsfall E-166a/b am neuen Bau | 14:17:32 | 2 von 2 |
| Gegenprobe an der `Eudora.exe` aus 1.0.127 | 14:19:01 | E-166a grün (der Weg lief), E-166b rot (`fehlt in ini: AskedAboutJunk=6`) |
| zurück auf den neuen Bau | 14:21:05 | 2 von 2, damit der letzte Eintrag im Ergebnisbuch stimmt |

Gregors Frage vom 27.10. (*„gibt es jetzt auch einen neuen test …?“*) musste diesmal niemand stellen. Ein Paket gab es noch nicht. Die Behebung wartet auf das nächste ([[pakete-sammeln]]).

**Was offen bleibt, und wie es im Chat stand.** Nachgestellt ist ein **Weg**, der Gregors Fehlerbild erzeugt. Ob Gregor ihn gegangen ist (*Konto → Eigenschaften* nach der web.de-Fehlermeldung), zeigt sein Protokoll nicht. `BEFUNDE.md` E-166 sagt das ausdrücklich: *„Vermutung, nicht gemessen“*. Auch die Chatnachrichten nennen den Vorbehalt, aber erst im Text. Ihre ersten Sätze sind stärker: 13:40:47 *„Ich habe die Ursache für E-166 gefunden“*, 14:23:04 *„Die Junk-Frage aus E-166 kommt nicht mehr wieder“*. Meine Rückfrage von 13:40:47 (*„Erinnerst du dich daran?“*) hat Gregor nicht beantwortet, er gab nur den Zweignamen. Bleibt sie offen, sagt „behoben“ etwas über **einen** Weg zum Fehlerbild. Ob es Gregors Weg war, misst erst sein Test im nächsten Paket.

**How to apply, zusätzlich:** Der erste Satz nennt, was gemessen ist: *„Ich habe einen Weg zu deinem Fehlerbild gefunden und behoben; ob es dein Weg war, zeigt dein Protokoll nicht.“* Eine Rückfrage, die nach dem Zweignamen unbeantwortet bleibt, kommt in den Befund unter *Was noch fehlt*.
