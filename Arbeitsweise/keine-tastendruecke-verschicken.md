---
name: keine-tastendruecke-verschicken
description: "SendKeys geht an das Fenster im Vordergrund, nicht an mein Zielfenster - am 08.09.2026 habe ich damit Gregors Explorer-Fenster geschlossen"
metadata:
  type: feedback
---

Schranke: tools/testlauf.ps1 (vor jedem Programmstart — beendet per WM_CLOSE an ein gemessenes Fensterhandle, nie per Tastendruck)

Am 08.09.2026 wollte ich beim Beenden-Test (E-33) prüfen, ob ein **echtes**
Alt+F4 Eudora schließt. `FindWindow('EudoraMainWindow', $null)` gab **0** zurück
— ich habe den Tastendruck trotzdem abgeschickt:

```powershell
[System.Windows.Forms.SendKeys]::SendWait('%{F4}')
```

`SendKeys` kennt kein Ziel. Es geht an das Fenster, das gerade den Fokus hat.
Das waren Gregors **Windows-Explorer-Fenster**, und Alt+F4 hat sie geschlossen.
Sein Wort: *„wäre nett, wenn du während deines tests nicht meine windows
explorer fenster schließt."*

**Warum:** Eine Fensterbotschaft (`PostMessage`/`SendMessage`) hat ein Handle
als Empfänger und kann nur dieses eine Fenster treffen. Ein Tastendruck hat
keinen Empfänger — er trifft, was zufällig vorne ist. In einem Projekt, in dem
ich auf **Gregors** Bildschirm arbeite, ist das kein Messwerkzeug, sondern ein
Risiko für seine Arbeit.

**Wie anwenden:**
- **Keine `SendKeys`, kein `SendInput`, kein `keybd_event`.** Statt dessen die
  Botschaft schicken, die die Taste erzeugt: Alt+F4 und das Kreuz werden von
  `DefWindowProc` in `WM_SYSCOMMAND` mit `SC_CLOSE` (`0xF060`) übersetzt, ein
  Menübefehl in `WM_COMMAND` mit seiner Kennung. Das ist derselbe Weg im
  Programm und trifft nur das gemessene Handle.
- Wenn ein Tastendruck wirklich unvermeidlich ist: **erst** das Zielfenster per
  Aufzählung holen (`EnumWindows` + Prozesskennung + Fensterklasse),
  `SetForegroundWindow` rufen, **danach `GetForegroundWindow()` vergleichen** —
  und bei Abweichung **abbrechen**. `SetForegroundWindow` scheitert aus einem
  Hintergrundprozess regelmäßig; Windows verbietet es.
- `FindWindow` liefert in diesem Projekt oft 0, auch wenn das Fenster existiert.
  Eine 0 ist ein **Abbruchgrund**, kein Hinweis, es einfach zu versuchen.
- Was der Anwender selbst prüfen muss, sage ich ihm — er hat den Fokus. Eine
  Messung, die ich nur mit Risiko für seine Fenster bekomme, ist seine Messung.

Siehe auch [[nichts-auf-gregors-bildschirm-starten]] und
[[messung-muss-den-weg-treffen]].
