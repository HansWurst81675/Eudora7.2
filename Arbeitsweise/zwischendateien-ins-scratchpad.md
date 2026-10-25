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

## Nachtrag 25.10.2026 (CHRONIST): der Auslöser war die Kompaktierung

Gezählt im Transkript `fa3529ec-…jsonl` (Zeiten MEZ), gemessen:

| Abschnitt | Aufrufe mit Scratchpad-Pfad | Aufrufe mit `$TEMP` / `$ENV{TEMP}` |
|---|---|---|
| 24.10. 21:47 bis zur Kompaktierung 25.10. 10:31 | **63** | **0** |
| 10:31 bis zu Gregors Frage um 11:04 | **0** | **27** |
| nach der Lehre (11:04) bis 18:08 | — | **0** eigene; viermal nur im Satz *„nicht nach $TEMP"* in Agentenaufträgen |

Die Zusammenfassung, mit der die Sitzung um 10:31 weiterlief, enthält das Wort „scratchpad" **kein einziges Mal** (gezählt). Vorher hatte ich die Gewohnheit aus meinen eigenen vorigen Befehlen abgeschrieben (`S=…/scratchpad; E=$S/ersatz12`); nach der Kompaktierung fehlte diese Vorlage, und ich fiel auf `$TEMP` zurück. Der Hinweis im Systemprompt stand die ganze Zeit da. Das ist eine Vermutung über den Mechanismus; die Zahlen sind gemessen.

**How to apply, zusätzlich:** Nach *„This session is being continued from a previous conversation"* ist alles, was nur als Gewohnheit im Verlauf stand, weg. Der erste Befehl danach, der eine Zwischendatei schreibt, schreibt den Scratchpad-Pfad aus. Die Lehre selbst wirkt: nach 11:04 kein Rückfall.
