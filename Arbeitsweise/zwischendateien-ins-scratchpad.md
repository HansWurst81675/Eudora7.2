---
name: zwischendateien-ins-scratchpad
description: "Zwischendateien (Sicherungskopien, Ersatztexte, Messausgaben, Agentenauftraege) nie nach $TEMP, sondern ins Scratchpad der Sitzung"
metadata:
  node_type: memory
  type: feedback
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T10:04:56.477Z
---

Zwischendateien gehören ins Scratchpad-Verzeichnis der Sitzung (steht im Systemprompt), **nie** nach `$TEMP` (= `C:\Users\Gregor\AppData\Local\Temp`, Gregors allgemeiner Temp-Ordner).

**Why:** Am 25.10.2026 fragte Gregor: *„warum liegt dort ein lektor58.txt? wer hat es dort abgelegt?"* — ich hatte in der Git-Bash `$TEMP` benutzt und 19 Dateien in seinem Temp-Ordner liegen lassen (Sicherungskopien für Gegenproben, Ersatztexte für Perl, Testausgaben, LEKTOR-Aufträge). Er musste sie selbst entdecken; niemand konnte sehen, wem sie gehören.

**How to apply:** In Bash-Befehlen den Scratchpad-Pfad ausschreiben (`S=/c/Users/Gregor/AppData/Local/Temp/claude/.../scratchpad`), nicht `$TEMP`. Fällt doch etwas außerhalb an: am Ende des Arbeitsschritts selbst wegräumen und es sagen. Verwandt: [[text-nicht-durch-schichten-schicken]], [[nichts-auf-gregors-bildschirm-starten]].

Schranke: keine - wohin ich Zwischendateien lege, sieht kein Haken; gemessen wird es nur, wenn Gregor seinen Temp-Ordner ansieht. Ausweg ist die Gewohnheit, den Scratchpad-Pfad auszuschreiben.
