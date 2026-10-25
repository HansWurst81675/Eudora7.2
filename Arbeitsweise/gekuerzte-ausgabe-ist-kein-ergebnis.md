---
name: gekuerzte-ausgabe-ist-kein-ergebnis
description: "Was ich mit head, tail, cut oder grep aus meiner eigenen Ausgabe herausschneide, kann ich nicht als 'nicht vorhanden' oder 'erfolgreich' melden - am 24./25.10.2026 wurde so aus einer aufgeschriebenen Entscheidung 'nichts vereinbart' und aus einer Commit-Abweisung ein Erfolg"
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T17:22:12.126Z
---

Schranke: keine - die Filter stehen in Wegwerfbefehlen, die kein Commit-Haken sieht. Machbar waere ein PreToolUse-Haken, der `git commit` und `git push` mit nachfolgendem `|` abweist (Vorschlag des CHRONIST vom 25.10.2026, nicht gebaut); fuer `head` hinter einer Suche gibt es keine mechanische Pruefung, nur die Regel unten.

# Gekürzte Ausgabe ist kein Ergebnis

**Regel.** Eine Aussage über Fehlen („es gibt keine Absprache", „nichts gefunden") oder über Erfolg („committet", „gebaut") darf ich nur aus einer Ausgabe ableiten, die ich **nicht** selbst gekürzt habe. `| head`, `| tail`, `| cut`, `| grep` und eine Kette mit `;` sind Werkzeuge zum Lesen, nicht zum Urteilen.

## Drei Fälle in zwei Tagen (gemessen)

| Zeit | Befehl | Was die Kürzung verschluckte | Was ich daraus machte |
|---|---|---|---|
| 24.10. 22:35 MESZ | `grep -rn -o ".{0,200}E-142.{0,200}" memory/*.md \| cut -c1-500 \| head -6` | Die Suche traf `stand-23-10-2026-spaet.md`. Gregors Entscheidung stand dort in **Zeile 34** (*„e-142: hinweis in readme + FAQ: erst prüfen, dann lsöchen."*, von mir selbst um 13:29 eingetragen). `head -6` brach nach Zeile 27 ab (20, 20, 21, 21, 22, 27 — lange Zeilen wurden mehrfach getroffen). Im Repo stand die Mittagsantwort nicht: Commit `2222420d` (22:34) hatte Gregors Abendantworten in `Intern/WEITERMACHEN.md` eingetragen und E-142 dort weiter unter *„Offen an Gregor"* geführt | 22:37: *„Was vereinbart ist: Nichts. Ich habe im Repo und in meinem Gedächtnis gesucht."* Gregor 22:37: *„e-142 stimmt nicht, was du sagst"*. Der falsche Satz steht bis heute in [[rueckfrage-ist-keine-messung]] (jetzt berichtigt) |
| 25.10. 16:49 MEZ | `git commit … 2>&1 \| grep -E "abgewiesen\|MANGEL\|…" \| head -3; git push … \| grep … \| head -3; git status -sb` | Der Commit-Haken wies ab (*„MANGEL - 2 Kennung(en) sind kein Link"*), der Push scheiterte. Die Kette endete mit `git status`, also meldete der Hintergrundlauf *„[exited with code 0]"*. Ich las um 16:50 nur `tail -3` der Ausgabe, und darin stand die MANGEL-Zeile nicht mehr | erst der fehlende Zweig auf dem Server verriet es: *„Der Commit ist nie entstanden … Meine Filterzeile hat die Abweisung verschluckt."* Danach richtig: Ausgabe in eine Datei, `rc=$?` ausgeben, dann suchen — so stand der Grund samt Abhilfe da |
| 25.10. 17:07 MEZ | `powershell -File tools\\bauen.ps1 > bau.txt 2>&1; echo "bau rc=$?"; tail -5 bau.txt` im Hintergrund | `bau rc=127` stand in der Ausgabe, der Lauf meldete trotzdem *„[exited with code 0]"* — der Rückgabewert von `tail` | gefunden, weil ich die Ausgabe gelesen habe (Fall 22 in [[text-nicht-durch-schichten-schicken]]) |

Ältere Fälle derselben Klasse: am 14.10.2026 hängte ich `grep -v` auf Perl-Warnungen und verlor so `C:Temp105`; am 23.10.2026 (Fall 19) stand „Rückgabe 0" über einer Fehlermeldung von PowerShell.

## Warum die vorhandenen Lehren nicht gereicht haben

- [[ausbleiben-ist-kein-befund]] verlangt die Positivprobe, wenn eine **Messung** stumm bleibt. Hier war die Messung nicht stumm — ich habe ihre Antwort selbst abgeschnitten. Der Kanal war offen, mein Filter war zu.
- [[erfolgsmeldung-aus-dem-ergebnis]] verlangt, nach dem Schreiben die Datei zu messen. Am 25.10. war das Ergebnis messbar (fehlender Zweig), aber erst eine Minute später und nur zufällig.
- [[bestand-vor-neuer-suche]] verlangt, erst den Bestand zu lesen. Das habe ich am 24.10. getan — mit einem Befehl, der den Bestand auf sechs Zeilen kürzte.

## How to apply

1. **Fehlen wird gezählt, nicht gesichtet.** Erst `grep -c` oder `grep -l` über alles, dann lesen. Erst wenn die Zählung 0 ist, darf „nichts" im Satz stehen. Bei Treffern: jede Datei ganz lesen, die getroffen wurde, nicht die ersten sechs Zeilen.
2. **`git commit` und `git push` nie in eine Pipe.** Ausgabe in eine Datei im Scratchpad, `echo "rc=$?"` direkt dahinter, dann die Datei durchsuchen.
3. **„[exited with code 0]" eines Hintergrundlaufs ist der Rückgabewert des letzten Befehls der Kette**, nicht des Bauskripts. Wer den echten will, gibt ihn selbst aus und liest ihn.
4. **Wer etwas Bestimmtes herausfiltert, sucht auch nach dem Gegenteil** — bei einem Commit nach der Commit-Kennung, bei einer Suche nach der Trefferzahl ([[gegenprobe-umdrehen]]).

## Nachtrag 25.10.2026 abends (CHRONIST): Fall 4, eine Stunde nach dieser Lehre

19:19:53 MEZ: `ls LICENSE*; head -5 LICENSE` im eigenen Repo. Die fünf Zeilen enthalten nur die Copyright-Vermerke (gemessen am Transkript). 19:20:15 im Chat: *„Lizenz: BSD-3-Clause … Das ist **dieselbe Lizenz wie unser Repo**."* Am selben Abend stand derselbe Satz in E-147. LEKTOR-64 (19:53): Unsere Lizenz schließt Patentrechte aus (`LICENSE:8`, `:20`), sie heißt im Repo selbst „BSD-3-Clause mit Patentausschluss" (`LICENSE:39`, `README.md:310`), und GitHub meldet `NOASSERTION`. Die Folgerung „Einbau erlaubt" hielt, die Begründung nicht. **Regel 1 dieser Lehre in neuer Form:** Wer zwei Dinge für „gleich" erklärt, liest beide ganz. Von der einen Seite den SPDX-Namen zu lesen und von der anderen den Kopf ist kein Vergleich.
