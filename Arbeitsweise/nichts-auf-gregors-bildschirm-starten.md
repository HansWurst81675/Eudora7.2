---
name: nichts-auf-gregors-bildschirm-starten
description: "Kein Programm mit Fenstern auf Gregors Sitzung starten, ohne vorher zu fragen — auch nicht durch Agenten"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T07:58:38.293Z
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

**Nachtrag 08.09.2026 — Erlaubnis ist nicht Ankündigung.** Für den
Beenden-Test habe ich richtig gefragt und Gregors Ja bekommen (*„ich teste
selbst, du startest bitte kein Eudora, solange ich messe"*). Trotzdem kam kurz
darauf:

> *„was ist das jetzt? das sieht nicht mehr so gut aus."*

Auf seinem Bildschirm stand ein Eudora-Fenster mit zerfallener Aufteilung, und
er konnte nicht wissen, ob es seine Installation war. Es war mein Prüfstand
unter `C:\Temp\E33-pruefstand`. Also gehört zur Erlaubnis noch die Ansage:

- **vor dem Start sagen, welcher Fenstertitel erscheint, aus welchem
  Verzeichnis und wie lange** — dann ordnet er ein Fenster zu, statt zu fragen;
- **nach dem Messen melden, dass der Bildschirm wieder frei ist**, und die
  Prozesse nach Pfad beenden (siehe oben);
- **was er dabei sieht, ist ein Messwert.** Seine Beobachtung war richtig: die
  Fensteraufteilung war kaputt. Nachgemessen gegen das unveränderte Paket 1.0.21
  auf gleich frischem Profil zeigte sich derselbe Aufbau — also ein Altbefund,
  keine Regression meiner Änderung. Diese Gegenmessung gehört sofort dazu, nicht
  erst auf Nachfrage.

Siehe [[lauffaehiges-ergebnis-liefern]], [[keine-tastendruecke-verschicken]]
und [[agenten-benennen]].
