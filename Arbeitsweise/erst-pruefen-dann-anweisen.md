---
name: erst-pruefen-dann-anweisen
description: "Keine Handlungsanweisung an Gregor geben, ohne sie vorher selbst durchgeführt und gemessen zu haben"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-31T05:44:00.043Z
---

Schranke: keine - ob ich eine Anleitung vor der Weitergabe selbst gefahren habe, steht nur im Chat; im Repo sieht eine ungeprüfte Anleitung genauso aus wie eine geprüfte

Wenn ich Gregor sage „schau unter *Hilfe → Über*" oder „starte es aus diesem
Verzeichnis", muss ich vorher **geprüft haben, dass dieser Weg funktioniert**.

**Why:** Am 31.08.2026 zweimal hintereinander falsch:

1. Ich sagte, die Version 7.2.0.3 sei im Startbildschirm und unter *Help → About*
   zu sehen — ohne geprüft zu haben, ob die frisch gebaute EXE überhaupt startet.
2. Ich schlug vor, sie aus `Eudora71\Bin\Debug` zu starten. Dort liegen die
   **Debug**-Fassungen der vorgebauten Fremd-DLLs von 2006, die `MSVCR71D.dll`
   verlangen. Das ist Befund S-1 — der Fehler, an dem schon Paket 1.0.1
   gescheitert war und den ich selbst dokumentiert hatte.

Seine Worte: *„erst prüfen, dann antworten! wenn exe nicht lauffähig, dann
schlage nicht vor, ich soll unter hilfe -> about nachschauen"*

Der Schaden ist nicht die falsche Auskunft an sich, sondern dass Gregor seine
Zeit für einen Weg aufwendet, den ich in Sekunden hätte ausschließen können.

**How to apply:**

- Vor jeder Handlungsanweisung: den Weg selbst gehen, soweit es ohne Fenster
  geht. Abhängigkeiten mit `dumpbin -dependents` oder
  `tools/paket-pruefen.ps1` durchrechnen, statt sie anzunehmen.
- Ein Verzeichnis, aus dem gebaut wird, ist **nicht** ein Verzeichnis, aus dem
  gestartet werden kann. `Bin\Debug` enthält den Bauzustand, nicht das Paket.
  Zum Starten gehört ein mit `tools/paket-bauen.ps1` erstelltes Verzeichnis.
- Was ich nicht prüfen kann (alles mit Fenstern, siehe
  [[nichts-auf-gregors-bildschirm-starten]]), sage ich als **ungeprüft** an —
  nicht als Anweisung.

Siehe [[pruefen-statt-vermuten]] und [[was-lauffaehig-heisst]].

## Nachtrag 07.09.2026 — zwei Funktionen mit fast gleichem Namen

Ich habe Gregor gesagt, mit den Werten in `tools/DEudora.ini` sei die Sache
erledigt: *„Damit brauchst du keinen Neubau."* Er hat es gefahren und
geantwortet: **„greift nicht"**.

Der Grund war eine Anleitung auf halb gelesenem Weg. Es gibt **zwei** Funktionen
mit fast gleichem Namen, und nur eine liest die Datei:

| Funktion | liest `DEudora.ini`? | benutzt fuer |
|---|---|---|
| `GetDefaultIniSetting` (`Eudora71/Eudora/rs.cpp:357-385`) | **ja** | ein **neu angelegtes** Konto, ueber `CPersParams::GetDefaultParams` |
| `CPersonality::GetIniDefaultValue` (`Eudora71/Eudora/persona.cpp:606`) | **nein** — nur `QCLoadString`, also die Ressource | ein **bestehendes** Konto beim Anzeigen |

Ich hatte den ersten Weg vollstaendig belegt (`WizardPropSheet.cpp:137` →
`GetDefaultParams()` → `GetDefaultIniSetting`) und daraus geschlossen, die Datei
wirke. Fuer den Dialog, den Gregor offen hatte — ein **bestehendes** Konto —
lief der zweite Weg. Dazu zwei weitere Bedingungen, die ich nicht angesagt
hatte: die Datei muss neben **genau der laufenden** `Eudora.exe` liegen
(`ExecutableDir` aus `GetModuleFileName`, `fileutil.cpp:418-435`), und der
Wert eines bestehenden Kontos steht ausdruecklich in der `Eudora.ini` und
schlaegt jede Vorgabe.

**Zusaetzlich zur Regel oben:**

- **Bevor ich sage „damit wirkt X": alle Leser des Werts aufzaehlen**, nicht den
  ersten gefundenen. `grep -rn '<Schluessel>\|<Funktionsname>'` ueber `*.cpp`
  und `*.h`, und jeden Treffer einordnen. Ein zweiter, aehnlich benannter
  Aufrufweg ist in diesem Quelltext die Regel, nicht die Ausnahme.
- **Die Anleitung nennt den Geltungsbereich.** „Fuer **neue** Konten" ist eine
  andere Zusage als „fuer dein offenes Fenster". Gregors Antwort darauf war
  praezise: *„fuer neue konten. bestehendes kann ich selbst korrigieren."*
- **Die Bedingungen gehoeren in die Anleitung**, nicht in die Erklaerung
  danach: welcher Pfad, welcher Stand, welcher Weg im Programm.
- **Und wenn ich es nicht selbst fahren kann, wird die Probe umgedreht** statt
  bestaetigt — Gregors Test hat die Frage in einem Zug entschieden
  ([[gegenprobe-umdrehen]]).
