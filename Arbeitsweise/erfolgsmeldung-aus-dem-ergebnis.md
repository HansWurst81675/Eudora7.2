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
