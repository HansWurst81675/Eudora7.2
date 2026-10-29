---
name: gekuerzte-ausgabe-ist-kein-ergebnis
description: "Was ich mit head, tail, cut oder grep aus meiner eigenen Ausgabe herausschneide, kann ich nicht als 'nicht vorhanden' oder 'erfolgreich' melden - am 24./25.10.2026 wurde so aus einer aufgeschriebenen Entscheidung 'nichts vereinbart' und aus einer Commit-Abweisung ein Erfolg"
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-29T08:00:44.883Z
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

## Nachtrag 27.10.2026 (CHRONIST): eine weggeworfene Ausgabe, eine Kette mit Semikolon, ein fremder Stash

Zeiten MEZ, 26.10., gemessen am Transkript. Neun Dateien lagen ungesichert im Arbeitsbaum, Gregor hatte um 23:19:28 den Zweignamen bestätigt. Um 23:20:03 lief in **einem** Befehl:

`git stash push -u -m "ungesichert 26.10. abends" >/dev/null 2>&1; echo stash=$?; … git switch -q 0.123_ergebnisse && git branch -d 0.125_ergebnisse …; git switch -c 0.125_ergebnisse origin/main …; git stash pop …`

Ergebnis: `stash=1`. **Der Stash war gescheitert**, seine Meldung ging nach `/dev/null`. Die Kette lief mit `;` weiter, und `git stash pop` griff nach dem obersten vorhandenen Stash, *„On wt/pruefer-20261021: pruefer-44 vorgefundener Stand 21.10.“*, also einem fremden Stand vom 21.10. über elf geänderten Dateien. Git wendete ihn nicht an (*„The stash entry is kept in case you need it again“*), nichts ging verloren. Die Dateien wurden danach gegen die Patch-Kopie verglichen, identisch. Gregor um 23:20:40, ohne das gesehen zu haben: *„mach nichts kaputt auf die letzten schritte“*. Gemeldet habe ich es um 23:22:18 ungeschönt.

Am 27.10. um 12:09:26 dasselbe Muster bei `git commit`: Fehlerausgabe nach `$TEMP/../nul_unused`, nur der Rückgabewert wurde gezeigt ([[zwischendateien-ins-scratchpad]], Nachtrag 27.10.).

**How to apply, zusätzlich:**
- Die Ausgabe eines git-Befehls, der den Arbeitsbaum oder den Stash verändert (`stash`, `switch`, `checkout`, `reset`, `branch -d`), wird nie weggeworfen.
- Hängt ein Schritt vom vorigen ab, wird mit `&&` verkettet, nie mit `;`. Ein `stash pop` ohne Namen ist ausgeschlossen. Es heißt `git stash pop "stash@{N}"` mit der Nummer, die der eigene `stash push` gerade gemeldet hat ([[verwerfen-nur-mit-zaehler]]).

## Nachtrag 28.10.2026 (CHRONIST): drei Filter an einem Nachmittag, zweimal mit alter Ergebnisdatei dahinter

Zeiten MEZ, Transkript `72be6093…`, gemessen.

| Zeit | Befehl | Was der Filter verschluckte | bemerkt |
|---|---|---|---|
| 13:32:58 | `testlauf.ps1 … 2>&1 \| Select-String 'E166A\|Beendet\|Mangel\|FEHL'; Select-String -Path …\eudora.log …` | PowerShells Meldung, dass `tools\testlauf.ps1` nicht gefunden wurde. Sichtbar blieben Zeilen der `eudora.log` aus dem **vorigen** Lauf | 13:33:06 |
| 14:03:53 | `perl -i … 2>/dev/null` | die Warnung *„-i used with no filenames“* (Fall 30 in [[text-nicht-durch-schichten-schicken]]) | 14:04:00, an 111,5 KB Ausgabe |
| 14:10:11 | `testlauf.ps1 … 2>&1 \| Select-String 'Hauptfenster\|E166A (Pers\|Konto\|ERGEBNIS)\|Beendet'; Select-String -Path …\Eudora.ini …; …` und mit `;` gleich der **zweite** Start | *„TESTLAUF ABGEWIESEN: Versionen passen nicht zusammen“*. Defender hatte die `EudoraRes.dll` genommen (E-124). Zu sehen waren nur `Exit code 1` und eine INI-Zeile | 14:10:24 (*„`testlauf.ps1` hat nicht gestartet“*) |

Alle drei wurden in Sekunden bemerkt, weil die Ausgabe nicht zum erwarteten Ergebnis passte. Der erste und der dritte Fall hatten denselben Aufbau: ein gefilterter Startbefehl, dahinter das Lesen der Ergebnisdatei. Scheitert der Start, zeigt die zweite Hälfte den **alten** Zustand der Datei, und das sieht aus wie eine Messung. Im dritten Fall hing dahinter mit `;` noch der zweite Start (Lauf 10). Wäre nur der erste abgewiesen worden, hätte Lauf 10 auf einem Stand ohne Lauf 9 gemessen.

**How to apply, zusätzlich:** Ein Prüfstandsstart wird nicht mit `Select-String` gefiltert. Seine Ausgabe geht in eine Datei im Scratchpad, die danach gelesen wird. Die Ergebnisdatei wird nur gelesen, und ein zweiter Lauf nur gestartet, wenn der erste `Beendet: True` gemeldet hat: mit `&&` oder `if ($?)`, nie mit `;`.

## Nachtrag 29.10.2026 (CHRONIST): ein vierter Filter am 28.10. und ein Push hinter einem abgewiesenen Commit

Zeiten MEZ, Transkript `72be6093…`, gemessen.

**Lauf 6, 13:34:54.** Derselbe Aufbau wie die Fälle oben: `testlauf.ps1 … | Select-String 'E166A Seite|E166A   |ERGEBNIS|Beendet' | Select-Object -Skip 14 | Where-Object { … }`. In diesem Lauf stürzte Eudora um 13:35:16 ab (heute E-168). Sichtbar blieben drei gleiche Assistentenseiten und `Beendet: True`. Der CHRONIST vom 28.10. hat die drei Filter von 13:32, 14:03 und 14:10 gezählt, diesen vierten nicht. Was der Filter verschluckte, ist hier nicht entscheidend, denn `testlauf.ps1` meldet einen Absturz während der Messung gar nicht ([[ausreisser-ist-der-befund]], Nachtrag 29.10.). Entscheidend ist, dass der Filter auch den Platz wegnimmt, an dem eine solche Meldung künftig stünde.

**15:46:48.** `git commit -q -F - <<'EOF' >/dev/null 2>&1 … EOF; echo "commit rc=$?"; git push -q origin e166-junk_message_fix >/dev/null 2>&1; echo "push rc=$?"`. Ergebnis: `commit rc=1`, `push rc=0`. Der Haken hatte abgewiesen (`lehren-uebersicht.pl`), der Push schob den alten Stand ein zweites Mal. Drei Sekunden vorher stand im Chat *„Die Backslashes sind erhalten. Ich committe und pushe.“* Gregor suchte in dieser Zeit auf GitHub nach dem Absturz-Hinweis, fand um 15:48:02 eine alte Stelle von 1.0.98 und schrieb um 15:49:47 *„weitermachen.md ist vor 9 min.“*, er sah also `8ef3c3d`. Gemeldet habe ich die Abweisung um 15:47:22, der richtige Stand war um 15:49:34 oben. Regel 2 oben (*„`git commit` und `git push` nie in eine Pipe“*) und der Nachtrag vom 27.10. (*„mit `&&`, nie mit `;`“*) standen beide da.

**How to apply, zusätzlich:** Ein Push hängt mit `&&` am Commit. Wer Gregor gerade einen Stand auf GitHub zeigen will, meldet ihn erst, wenn `git log origin/<zweig> -1` die neue Kennung zeigt.
