---
name: nichts-auf-gregors-bildschirm-starten
description: "Kein Programm mit Fenstern auf Gregors Sitzung starten, ohne vorher zu fragen — auch nicht durch Agenten"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-30T17:12:54.639Z
---

Gregor testet Eudora selbst auf derselben Windows-Sitzung, auf der ich arbeite.
Jedes Programm, das ich oder ein Agent startet, landet auf **seinem** Bildschirm
— mit Fenstern, Fehlerdialogen und Zusicherungsmeldungen, die seine eigenen
Fenster verdecken.

**Why:** Am 30.08.2026 hat der Agent BRÜCKE wiederholt Eudora-Instanzen aus dem
Zwischenverzeichnis gestartet, während Gregor sein Release testete. Zwei Folgen:

1. Er konnte nicht mehr testen — ständig sprangen fremde Fenster und
   SUPERASSERT-Dialoge auf.
2. Ein Zusicherungsdialog meiner Instanz stand vor seinem Passwortdialog. Er
   hielt es für **meinen** Build, der nach seinem echten Mailpasswort fragt.
   Das war es nicht, aber der Schreck war berechtigt.

Seine Worte: *„das solltest du mit mir absprechen. ich kann nicht testen, wenn
dauernd etwas startet und fehler dialoge auftauchen."*

**How to apply:**

- Bevor ich ein Programm mit Fenstern starte: **fragen**. Auch für einen
  einzelnen kurzen Startversuch.
- Agenten, die etwas starten sollen, bekommen diese Auflage ausdrücklich in den
  Auftrag — sonst gar keinen Startauftrag.
- Beim Aufräumen von Prozessen **immer nach Pfad filtern**. `Stop-Process` auf
  alle `Eudora.exe` würde seine laufende Sitzung mit abschießen:

      Get-CimInstance Win32_Process -Filter "Name='Eudora.exe'" |
        Where-Object { $_.ExecutablePath -like "*\Temp\claude\*" } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force }

- Nach jedem eigenen Startversuch den Prozess selbst beenden, nichts stehen
  lassen.
- Es kann systemweit nur **einen** OutputDebugString-Mithörer geben
  (`DBWIN_BUFFER`). Zwei gleichzeitig, und beide bekommen nichts.

Siehe [[lauffaehiges-ergebnis-liefern]] und [[agenten-benennen]].
