---
name: extrakt-ist-nicht-das-programm
description: Ein ausgeschnittener Pruefstand misst die Regel, nicht ihre Verwendung - Lebenslauf, Aufrufstellen und Uebersetzbarkeit bleiben ungeprueft; am 19.10.2026 dreimal an einem Tag
metadata:
  type: feedback
---

Schranke: tools/bauen.ps1 (drei Messpunkte: Fehlermeldungen im Protokoll, Eudora.exe aelter als die Quellen, Versionsressource gegen Version.h) - sie haben den dritten Fall gefangen. Fuer Lebenslauf und Aufrufstellen fehlt tools/pruefe-extrakt.pl, Spezifikation in Befunde/CHRONIST-2026-10-19.md

Der Prüfstand schneidet mit `Extract.ps1` Regionen aus dem Produktivcode aus.
Das ist richtig — und genau das Heraustrennen macht einen Spalt auf: der
Extrakt hat einen **anderen Lebenslauf**, **andere Aufrufer** und eine
**andere Reihenfolge** als das Original. In den Worten von PRUEFER-38: *„die
Regel ist richtig geprüft, ihre Verwendung nicht."*

**Why:** Am 19.10.2026 dreimal im selben Code, jedes Mal bei 222/222 grün —
(1) E-69 wäre nach dem ersten Filterlauf **stumm** gewesen, weil jeder
Testblock ein frisches `CE69Sammlung` anlegt, Eudora aber eine globale
Variable hat (R1); (2) die Klammer fehlte an vier Schleifen, darunter am
**IMAP-Weg**, also am Anlassfall des Commits (R2); (3) **Eudora übersetzte
nicht** (C3861, C2065), weil `Extract.ps1` die Funktion ausschneidet und die
Reihenfolge im Original nicht kennt.

**How to apply:** Drei Fragen, jedes Mal, wenn `Extract.ps1` eine neue Region
bekommt. **Lebenslauf:** lebt das Geprüfte im Original länger als ein
Testblock (global, `static`, `__declspec(thread)`)? Dann muss mindestens ein
Test **über zwei Blöcke hinweg auf demselben Objekt** laufen. **Aufrufstellen:**
sind alle Aufrufer abgedeckt? Das findet kein Test von innen, nur eine
Schranke, die die Stellen im Baum zählt. **Übersetzbarkeit:** ein grüner
Prüfstand ist kein Beleg, dass das Programm baut — erst `bauen.ps1`, dessen
drei Messpunkte Fall 3 gefangen haben. Siehe [[pruefstand-kann-blind-sein]],
[[schranke-gegentesten]], [[nie-benutzt-ist-nicht-geprueft]].
