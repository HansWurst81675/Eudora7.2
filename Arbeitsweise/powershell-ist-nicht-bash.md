---
name: powershell-ist-nicht-bash
description: "Im PowerShell-Werkzeug gibt es kein perl, und ein Alias schlägt eine gleichnamige Funktion (Lp = Out-Printer); am 27.10.2026 dreimal, eine Gegenprobe lief dadurch auf unverändertem Quelltext"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 15164e13-ede5-43ce-aedf-d1c355c7656a
  modified: 2026-10-27T16:19:03.029Z
---

Schranke: keine - welche Shell einen Befehl ausführt, entscheide ich beim Aufruf, und kein Haken liest das; Vorschlag für bauen.ps1 unten, nicht gebaut.

# PowerShell ist nicht Bash

In dieser Umgebung gibt es zwei Shells. `perl` liegt nur im Pfad von **Git Bash**. Im PowerShell-Werkzeug ist es unbekannt, auch für Skripte, die aus PowerShell gestartet werden. Dazu kommen die eingebauten Aliase von PowerShell: Sie werden **vor** Funktionen aufgelöst. Eine eigene Funktion mit dem Namen eines Alias wird also nie aufgerufen.

**Why:** Am 27.10.2026 (Zeiten MEZ, gemessen am Transkript `15164e13…`) dreimal an einem Vormittag:

| Zeit | Was | Folge |
|---|---|---|
| 11:18:11 | `tools/bauen.ps1` aus dem PowerShell-Werkzeug gestartet; der Schritt am Ende ruft `& perl $pt` (`bauen.ps1:1262`) | `CommandNotFoundException`, `bauen.ps1` endet mit 1. Gemeldet wurde 11:21:56 *„Der Bau ist erfolgreich … Gescheitert ist nur der Testschritt am Ende“*. Die Unit-Tests waren vorher getrennt gelaufen, der Bau selbst war gut (belegt), die Formulierung „erfolgreich“ für rc=1 aber nicht |
| 11:30:58 | Gegenprobe zum fünften Anlauf von E-137: `& perl -0777 -i -pe …` in PowerShell, dann die Tests | `perl` nicht gefunden, die Tests liefen auf **unverändertem** Quelltext. Erkannt 11:31:16 (*„die Gegenprobe lief also auf unverändertem Quelltext und gilt nicht“*), mit Bash wiederholt, rot wie verlangt |
| 12:45:47 | neues Messskript `tools/messen-e137.ps1` mit einer Hilfsfunktion `Lp` (Mausposition als `LPARAM`) | `Lp` ist der Alias für `Out-Printer`. Das Skript versuchte zu **drucken** (*„Out-Printer : Es wurde kein Positionsparameter gefunden …“*), alle drei neuen Fälle waren rot. Erkannt 12:45:52, Funktion umbenannt |

Alle drei wurden in unter einer Minute erkannt, weil die Fehlermeldung laut war. Gefährlich ist der zweite Fall: Wäre die Meldung in einer gekürzten Ausgabe untergegangen, hätte die Gegenprobe „Test bleibt grün“ gemeldet. Das hätte nach einem schwachen Test ausgesehen, nicht nach einer Gegenprobe, die gar nicht lief ([[ausbleiben-ist-kein-befund]], [[gekuerzte-ausgabe-ist-kein-ergebnis]]).

**How to apply:**
- **Perl nur aus Bash.** Braucht ein PowerShell-Schritt Perl, wechselt der ganze Schritt nach Bash. Ein `& perl` im PowerShell-Werkzeug ist ausgeschlossen.
- **Eine Gegenprobe beginnt mit dem Beweis, dass die Quelle sich geändert hat** (`cmp` gegen die Sicherung meldet „verändert“), bevor die Tests laufen. So stand es in der Bash-Wiederholung um 11:31:18 (*„gleich … Treffer 1 verändert“*).
- **Funktionsnamen in `.ps1` in der Form Verb-Nomen** (`Get-Lparam`) oder vorher `Get-Command <Name>` fragen. Zwei Buchstaben sind fast immer schon ein Alias (`lp`, `gc`, `gi`, `sl`, `ni`, `rm`).
- Ein Werkzeug mit Rückgabewert ungleich 0 ist nicht „erfolgreich“, auch wenn nur der letzte Schritt scheiterte. Dann wird gesagt, welcher Schritt fehlt und wo er stattdessen lief ([[erfolgsmeldung-aus-dem-ergebnis]]).

**Vorschlag für eine Schranke (nicht gebaut):** `bauen.ps1` sucht Perl wie `paket-bauen.ps1` (Zeilen 87–96: erst `PATH`, dann `C:\Program Files\Git\usr\bin\perl.exe` und zwei weitere feste Pfade) und bricht mit einer klaren Zeile ab, wenn es keins findet. Gegenprobe: `& .\tools\bauen.ps1` aus dem PowerShell-Werkzeug muss den Testschritt ausführen (heute rc=1 mit `CommandNotFoundException`). Dazu `pruefe-ps-alias.ps1` im pre-commit: jede `function <Name>` in `tools/*.ps1` gegen `Get-Alias` halten. Gegenprobe: `messen-e137.ps1` mit `function Lp` muss rot werden.

## Nachtrag 28.10.2026 (CHRONIST): die erste Zeile der Tabelle, 27 Stunden später, und ein relativer Pfad

Zeiten MEZ, Transkript `72be6093…`, gemessen.

| Zeit | Was | Folge |
|---|---|---|
| 13:32:58 | `powershell … -File tools\testlauf.ps1` im PowerShell-Werkzeug, relativer Pfad | *„Das Argument "tools\testlauf.ps1" für den -File-Parameter ist nicht vorhanden“*. Das Arbeitsverzeichnis des PowerShell-Werkzeugs bleibt zwischen Aufrufen stehen und lag nicht im Repo (warum, ist nicht gemessen). Der Filter verschluckte die Meldung, siehe [[messung-muss-den-weg-treffen]], Fall 12. Ab 13:33:11 absolute Pfade |
| 14:02:46 | `tools\bauen.ps1` aus dem PowerShell-Werkzeug | brach vorher ab (ungesicherte Quelldateien), bis zu Perl kam es nicht |
| 14:07:47 | `tools\bauen.ps1` aus dem PowerShell-Werkzeug, im Hintergrund | genau die erste Zeile der Tabelle oben: Der Bau lief, der Schritt *Regressionstests* scheiterte an *„Die Benennung "perl" wurde nicht als Name eines Cmdlet … erkannt“*, Rückgabe 1 (14:09:32). Um 14:09:38 selbst benannt (*„das steht auch in der Lehre `powershell-ist-nicht-bash`“*), um 14:09:39 aus der Bash wiederholt, grün |

Gekostet hat es knapp zwei Minuten und kein falsches Ergebnis. Diesmal wurde „fehlgeschlagen“ gemeldet, nicht „erfolgreich“. Die Lehre war aber 27 Stunden alt, und ihr erster Fall wiederholte sich wörtlich. Sie hat keinen Auslöser: Wer `bauen.ps1` aufruft, denkt nicht daran, dass darin Perl steckt.

**How to apply, zusätzlich:**
- `tools/*.ps1` starte ich immer aus dem **Bash**-Werkzeug: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/<name>.ps1`, mit Schrägstrich ([[text-nicht-durch-schichten-schicken]], Fall 19). Das PowerShell-Werkzeug nehme ich nur für reine Cmdlet-Abfragen (`Get-Process`, `Get-MpThreatDetection`).
- Im PowerShell-Werkzeug nie ein relativer Skriptpfad.

**Die Schranke ist dringlicher als am 27.10.** Der Vorschlag oben (`bauen.ps1` sucht Perl wie `paket-bauen.ps1`) ist weiter nicht gebaut. Gegenprobe wie dort: `bauen.ps1` aus dem PowerShell-Werkzeug muss den Testschritt ausführen. Am 28.10. war es dort Rückgabe 1.
