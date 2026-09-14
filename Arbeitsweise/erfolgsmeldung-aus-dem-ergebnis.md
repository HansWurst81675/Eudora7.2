---
name: erfolgsmeldung-aus-dem-ergebnis
description: "Ein Skript darf Erfolg nur melden, wenn es das Ergebnis gemessen hat - mein Perl-Einzeiler schrieb 'eingefuegt', ohne etwas einzufuegen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T11:28:41.976Z
---

Schranke: keine - der Fehler steckt in Wegwerf-Einzeilern, die kein Skript vorher zu sehen bekommt. Die Pruefung ist der Handgriff danach: nach jedem Schreibzugriff den Marker in der Datei zaehlen, bevor irgendetwas gemeldet wird.

Am 13.09.2026, beim Festhalten der offenen Punkte in `WEITERMACHEN.md` vor
Gregors Herunterfahren: ein Perl-Einzeiler sollte eine Tabellenzeile über einen
Anker einsetzen. Die Ausgabe war

```
Can't open : No such file or directory at -e line 2.
  eingefuegt
  CR: 0  LF: 274
```

**Beides stand da — der Abbruch und die Erfolgsmeldung.** Der Pfad kam über
`$ENV{S}`, und `S` war in der Bash gesetzt, aber nicht exportiert. Eingefügt
wurde nichts: `grep -c` ergab **0 Treffer**, und die Zeilenzahl stand
unverändert bei 274.

**Why:** Der `print "eingefuegt"` hing am **Kontrollfluss**, nicht am Ergebnis.
Ohne die Nachmessung wäre der Satz „habe ich festgehalten" in die
Abschlussmeldung gegangen, und am nächsten Tag hätte weder E-85 noch der
QCSSL-Punkt irgendwo im Repo gestanden — genau die Klasse, die Gregor mit 45
Fundstellen auf Platz 1 seiner Fehlerliste geführt hat. Dass die Meldung neben
einem sichtbaren Fehler stand, macht es schlimmer, nicht besser: gemischte
Ausgaben liest man als „lief durch, kleine Warnung".

**How to apply:**

* **Nach jedem Schreibzugriff das Ergebnis messen, nicht den Rückgabewert des
  eigenen Skripts.** `grep -c <Marker>` auf die geschriebene Datei, und die
  Zeilenzahl gegen vorher. Erst dieses Ergebnis darf gemeldet werden.
* **Nie `$ENV{...}` für einen Pfad zwischen Bash und Perl.** Die Variable muss
  exportiert sein, und das sieht man dem Aufruf nicht an. Den Pfad direkt ins
  Skript schreiben — er ist ohnehin einmalig.
* Eine Erfolgsmeldung **unter** einer Fehlermeldung ist ein Alarmzeichen, kein
  Nebengeräusch. Dann zuerst nachmessen.

Verwandt: [[zeilenenden-nach-jedem-schreibzugriff-messen]] misst dieselbe Datei
auf eine andere Eigenschaft — dort lautlos falscher Inhalt, hier gar keiner.
Und [[gegenprobe-umdrehen]]: nicht fragen, ob mein Skript zufrieden ist,
sondern ob der gewünschte Zustand in der Datei steht.

---

## Zweiter Fall am selben Tag, 13.09.2026 — die Probe, die diese Lehren empfehlen

Ein PowerShell-Syntaxcheck meldete `Syntax ok` für eine Datei, die nicht parst.
Benutzt wurde genau die Probe, die
[[text-nicht-durch-schichten-schicken]] seit dem 06.09.2026 empfiehlt:

```
powershell -Command "[ScriptBlock]::Create((Get-Content -Raw 'DATEI'))"
```

**Nachgemessen am 13.09.2026** an einer Datei mit fehlender schließender
Klammer:

```
Ausnahme beim Aufrufen von "Create" mit 1 Argument(en): ...
    + FullyQualifiedErrorId : ParseException

Syntax ok
EXITCODE=0
```

Dieselbe Form wie beim Perl-Einzeiler oben: **die Erfolgsmeldung steht unter
der Fehlermeldung, und der Rückgabewert ist 0.** `[ScriptBlock]::Create`
wirft eine nicht-terminierende `MethodInvocationException`; `powershell
-Command` läuft weiter und beendet sich mit 0. Ein Hook, der daran hängt,
lässt die kaputte Datei durch. Gefunden wurde der Fehler erst mit:

```powershell
$t = $null; $e = $null
[void][System.Management.Automation.Language.Parser]::ParseFile($pfad, [ref]$t, [ref]$e)
if ($e -and $e.Count) { Write-Error ("Parserfehler: " + $e[0].Message); exit 1 }
```

**Why:** Es ist nicht nur dieselbe Klasse, es ist derselbe Mechanismus. Der
Perl-Einzeiler hing seinen `print` an den Kontrollfluss statt an das Ergebnis;
dieser Check hängt sein `Syntax ok` an den Kontrollfluss statt an den
ausgewerteten Fehlerbehälter. Beide Male ist die Ausnahme sichtbar in der
Ausgabe und wird trotzdem nicht zum Urteil.

**Das Schwerwiegende daran:** die falsche Probe stand in einer *Lehre*. Eine
Lehre, die eine stumme Prüfung empfiehlt, verbreitet die Fehlerklasse, statt
sie abzustellen. Deshalb ist die Stelle in
[[text-nicht-durch-schichten-schicken]] am 13.09.2026 berichtigt worden.

**How to apply — für jede Prüfung, die irgendwo hängt:**

* **Die Prüfung muss einen Rückgabewert ungleich 0 liefern, sonst ist sie
  keine Prüfung.** `echo "ok"` hinter einem Aufruf ist eine Behauptung, kein
  Ergebnis.
* **Jede Prüfung wird einmal gegen den echten Fehler gefahren, bevor sie in
  einen Hook kommt** ([[schranke-gegentesten]]). Genau dieser Gegentest hat
  hier zwei Minuten gekostet und die stumme Probe sofort entlarvt.
* **Bei PowerShell nie `[ScriptBlock]::Create` als Syntaxprobe**, sondern
  `Parser::ParseFile` mit ausgewertetem `[ref]$fehler` und explizitem `exit 1`.
* Bei Perl ist `perl -c DATEI` in Ordnung — dort ist der Rückgabewert
  tatsächlich ungleich 0. Das ist der Unterschied, und er ist nicht
  offensichtlich, also wird er gemessen und nicht vermutet.

---

## Dritter und vierter Fall, 13.09.2026 — beim Nachprüfen genau dieser Lehre

Beim Gegentest der drei Schranken, die an diesem Tag gegriffen haben, ist mir
derselbe Fehler zweimal hintereinander unterlaufen. Das ist kein Zufall,
sondern der Beleg, wie nah dieser Griff liegt.

**Dritter Fall — der Rückgabewert kam vom falschen Prozess.** Gemessen wurde

```
perl tools/pruefe-bytes.pl 2>&1 | tail -12; echo "EXIT=$?"
```

Das meldete `EXIT=0` — also „die Schranke lässt das Mojibake durch". Falsch:
`$?` trägt hinter einer Pipe den Rückgabewert des **letzten** Glieds, hier
`tail`, und `tail` gelingt immer. Ohne Pipe gemessen:

```
AUSGABE=$(perl tools/pruefe-bytes.pl 2>&1); RC=$?
```

**Vierter Fall — die Messung traf den Weg nicht.** Auch ohne Pipe blieb die
Schranke zunächst still, Rückgabe 0. Grund: `pruefe-bytes.pl` ist eine
pre-commit-Schranke und sieht nur **vorgemerkte** Dateien. Der Gegentest lief
ohne `git add`, also im falschen Betriebsmodus
([[messung-muss-den-weg-treffen]]). Mit `git add` dann sofort:

```
RUECKGABE_MIT_STAGING=1
COMMIT ABGEBROCHEN - lautloser Schaden erkannt:
  * CHANGELOG.md: doppelt kodiert - 1 Stellen, vorher 0
```

**Why:** Beide Male hätte ich um ein Haar eine **funktionierende Schranke für
kaputt erklärt** — das Gegenstück zum Fehler oben, aber derselbe Mechanismus:
ein Urteil, das an etwas anderem hängt als am gemessenen Ergebnis. Ein
Fehlurteil in dieser Richtung ist teurer, als es aussieht, denn es hätte zum
Umbau einer Schranke geführt, die richtig arbeitet.

**How to apply:**

* **Nie `$?` hinter einer Pipe.** Erst in eine Variable
  (`AUS=$(befehl 2>&1); RC=$?`), dann urteilen, dann anzeigen. Wer die Ausgabe
  gleich durch `tail` schickt, misst `tail`.
* **Vor dem Urteil über eine Schranke prüfen, ob sie überhaupt gelaufen ist.**
  Eine stille Schranke heißt „nichts gefunden" **oder** „hat nichts
  angesehen". Bei `pruefe-bytes.pl` ist der Unterschied ein `git add`.
* Eine Schranke, die im Gegentest nichts meldet, ist erst dann verdächtig,
  wenn der Gegentest selbst nachgewiesen hat, dass er den geprüften Weg trifft
  — nicht vorher.
