---
name: pruefen-statt-vermuten
description: "Vorhandene Quellen oeffnen, bevor ich eine Ursache vermute - und Vermutungen nie als Tatsache aussprechen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-05T17:51:39.000Z
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

---

## Nachtrag 05.09.2026 - warum die Regel trotzdem nicht griff

Gregor: *„gemessen statt geglaubt - das sollte ja bereits gelten! schon seit
langem. warum immer noch fehlerhaft?"*

Er hat recht, und die Antwort ist unangenehm einfach: ich habe die Regel auf
**fremde Behauptungen** angewendet und nicht auf **mein eigenes Handeln**. Die
Befunde dieser Sitzung sind sauber gemessen (D3a widerlegt, R-1 nachgerechnet,
801 CRLF-Dateien belegt). Meine eigenen Handgriffe nicht - fuenfmal:

| Handgriff | Was danebenlag und nicht angesehen wurde |
|---|---|
| „mein Rebuild hat `OTA50R.lib` zerstoert" | die Zeitstempel - unveraendert vom 31.08. Die Datei hat nie existiert. |
| Debug/Release mit `strings` erkannt | 10,2 MB gegen 2,9 MB, direkt in derselben Ausgabe |
| DLL-Namen aus Binaerdateien gegrept | `s.dll`, `ts.dll` im Ergebnis - sichtbare Bruchstuecke |
| zwei Agenten in einen Arbeitsbaum | `git worktree list`, ein Befehl |
| „schliess Eudora, dann tausche ich" | dass genau das Schliessen abstuerzt - eben gezeigt bekommen |

**Der Grundsatz feuert nicht. Ein Handgriff feuert.** Wo dieses Projekt eine
echte Schranke gebaut hat (`pruefe-bytes.pl` gegen Zeilenenden), ist die
Fehlerklasse weg; wo es beim Merksatz blieb, kommt sie wieder.

**Deshalb, an genau diesen vier Punkten, vor dem Handeln statt nach dem Reden:**

1. **Vor einem Befehl, der loeschen kann** (`Rebuild`, `Clean`, `reset --hard`,
   `checkout -B`, Ueberschreiben): erst auflisten, was er anfassen wird, und
   pruefen, ob davon etwas nicht wiederherstellbar ist. `git status` und
   Zeitstempel **vorher**, nicht hinterher zur Schadensdeutung.
2. **Nach jeder Textersetzung** (perl `s///`, besonders ueber Zeilengrenzen):
   das Ergebnis zurueckelesen und ansehen. Am 05.09. ist mir derselbe
   Zeichenketten-Literal zweimal zerbrochen; beide Male nur aufgefallen, weil
   ich zufaellig ausgegeben habe.
3. **Vor jeder Agentenzuteilung:** `git worktree list`. Siehe
   [[agenten-koordinieren]].
4. **Wenn eine Messung einem offensichtlichen Signal widerspricht** - eine
   4-MB-Datei neben einer 10-MB-Datei, beide angeblich gleich gebaut - ist die
   **Messmethode** verdaechtig, nicht das Signal. Dann die Methode wechseln,
   nicht das Ergebnis glauben.

Und fuer die Selbstbeschuldigung eigens: sie ist genauso eine Behauptung wie
jede andere. „Ich habe X kaputtgemacht" gehoert belegt, bevor ich es sage -
sonst steht am Ende eine falsche Ursache in der README, und der echte Mangel
bleibt unentdeckt.
