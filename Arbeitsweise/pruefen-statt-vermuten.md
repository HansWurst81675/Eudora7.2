---
name: pruefen-statt-vermuten
description: "Vorhandene Quellen oeffnen, bevor ich eine Ursache vermute - und Vermutungen nie als Tatsache aussprechen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:38.425Z
---

Bevor ich eine Ursache benenne, die vorhandene Quelle oeffnen. Wenn ich trotzdem
vermute, die Vermutung als solche kennzeichnen und dazusagen, worauf sie sich
stuetzt.

**Why:** Das ist meine haeufigste Fehlerklasse in diesem Projekt. Am 28.08.2026
dreimal derselbe Ablauf:

1. Ein `cmd /c`-Aufruf haengte. Ich vermutete ein langsames MSYS-Perl und lud
   unnoetig 300 MB Strawberry Perl. Ursache war eine interaktive Eingabe-
   aufforderung. (Siehe [[haengende-kommandos-abbrechen]].)
2. Die neue QCSSL.dll brachte keine sichtbare Verbesserung. Ich spekulierte ueber
   den Grund, statt das von Gregor geschickte `hermesSSL.zip` zu oeffnen. Darin
   stand die Antwort: HermesSSL 7.8 gamma mit OpenSSL 1.0.2p, also laengst TLS 1.2.
3. Commits im Repo kamen mir fremd vor. Ich behauptete als **Tatsache**, es laufe
   eine zweite Claude-Sitzung parallel. `git reflog` zeigte eine einzige
   durchgehende Kette in einem einzigen Arbeitsverzeichnis - es waren meine
   eigenen Commits aus einer zusammengefassten Sitzungshaelfte.

Gregor musste jedes Mal korrigieren. Beim dritten Mal zu Recht deutlich: die
Regel stand schon in der Ablage und ich habe sie ignoriert.

**Zahlen sind Vermutungen, bis sie gemessen sind.** Die Doku-Pruefung vom
29.08.2026 hat in README, PLAN.md und PORTIERUNG.md acht falsche Werte gefunden,
die ich alle als Tatsachen hingeschrieben hatte: "16 von 18 Projekten bauen" (es
sind 15), "19 Zertifikate von 1996-1998" (Zeitraum 1994-2000), "39 beruehrte
.cpp-Dateien" (42), "52 SEC-Bezeichner" (Zaehlweise unbrauchbar), `afxext.h:269`
(268), zwei `rootcerts.p7b` mit verschiedener SHA256 als eine beschrieben. Also:
keine Zahl ohne den Befehl, der sie erzeugt hat - und den Befehl daneben schreiben,
damit der naechste sie nachrechnen kann statt sie zu glauben.

**Auch ueber mich selbst nicht raten.** Am 28.08.2026 habe ich Gregors eigenen
Arbeitsstand als "deine patch2-Version" bezeichnet - der Patch war meiner. Und am
29.08.2026 habe ich mir einen Fehler eingeraeumt, den der Mitschnitt so nicht
hergibt (siehe [[wissen-gehoert-in-dateien]]). Urheberschaft und Selbstvorwurf
gehoeren genauso belegt wie eine technische Ursache.

**How to apply:** Angehaengte Pfade, Links und Archive sofort oeffnen, auch wenn
sie beilaeufig erwaehnt werden - Gregors Material schlaegt meine Hypothese. Bei
unklarer Repo-Historie `git reflog` und `git worktree list`, bei haengenden
Prozessen die tatsaechliche Ausgabe. Und beim Formulieren: "ich vermute, weil X"
statt "es ist so". Kostet eine Zeile und macht eine fehlende Quelle sofort
sichtbar.
