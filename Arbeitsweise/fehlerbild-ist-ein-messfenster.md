---
name: fehlerbild-ist-ein-messfenster
description: "Solange Gregors Fehlermeldung offen steht, ist der Fehlerzustand messbar - erst messen (Log, Stapel des laufenden Prozesses), dann schließen lassen"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T15:00:00.000Z
---

Am 13.10.2026 stand bei Gregor die Meldung „Encountered an improper argument" nach Ctrl+F offen ([E-115](../BEFUNDE.md#e-115)). Er fragte: *„ok, soll ich meins jetzt schließen?"* Ich antwortete „nein, deins kannst du offen lassen" - gemeint als „es stört meinen Lauf nicht" - und startete Nachstellversuche in `C:\Temp`. Er schloss es trotzdem. Drei Nachstellläufe brachten nichts; der Fehler war **nur einmal, spontan** aufgetreten. Gregor danach: *„deshalb habe ich gefragt, ob ich es beenden soll, sonst hättest du ins log oder sonst wo reinschauen können, während der fehler sichtbar war"*.

**Why:** Ein seltener Fehler ist oft nur in diesem einen Moment messbar. Solange die Meldung steht, lebt der Prozess im Fehlerzustand: das Protokoll ist noch nicht überschrieben, und der Hauptthread steht im Fangblock - sein Stapel nennt die Nachricht und den Rahmen, der die Ausnahme fing. Nach dem Schließen bleibt nur Nachstellen, und das kann scheitern.

**How to apply:** Meldet Gregor eine sichtbare Fehlermeldung, ist die erste Antwort: **„bitte noch offen lassen"** - dann sofort lesen, was ohne Start geht: `eudora.log` (Ende, Zeitstempel), `Exception.log`, Fensterliste des Prozesses (nach Pfad gefiltert). Den Stapel des laufenden Prozesses nur mit seinem Ja (Anhängen eines Debuggers greift in seinen Prozess ein - [[nichts-auf-gregors-bildschirm-starten]], [[erlaubnis-nicht-hineinlesen]]). Erst danach schließen lassen. Fragt er „soll ich schließen?", ist das die Frage nach dem Messfenster, nicht nach meinem Lauf. Verwandt: [[eingebaute-messung-auslesen]], [[anzeige-ist-kein-zustand]].

Schranke: keine - der Moment, in dem eine Meldung offen steht, ist in keiner Datei sichtbar. Das Werkzeug für das Fenster gibt es seit dem 13.10.2026: `tools/stapel-lesen.ps1` (32-Bit-PowerShell, `-Pfadfilter` und `-Freigabe` Pflicht) liest den Stapel eines laufenden Eudora ohne Neustart

## Nachtrag 13.10.2026, Mittag: die Lehre hat gewirkt, zwei Lücken bleiben

Zwei Stunden nach dem ersten Fall stand die Meldung wieder offen, diesmal in Gregors frischem 1.0.85. Er schrieb von sich aus: *„jetzt habe ich wieder den fehler bei CTRF-F. schau es dir an. ich fasse solange nichts an."* (10:40:24 UTC) und eine Minute später *„ich lasse es solange stehen, bis deine untersuchung fertig ist"*.

| Zeit (UTC) | Schritt |
|---|---|
| 10:40:45 | Ende von `eudora.log` und Prozess (nach Pfad gefiltert) gelesen, 21 s nach der Meldung |
| 10:41:37 | Stapel des Meldungsthreads gelesen, ohne Debugger, mit einem eigens geschriebenen Skript: `CxxThrowException` ← `CMBoxTreeCtrlCheck::FindCheck` (`MBoxTreeCtrlCheck.cpp:938/942`) ← `CSearchView::HandleSelectMessage` |
| 10:42:06 | Ursache an der Quelle: `GetNextSiblingItem` hinter dem Ordner Recent liefert NULL, `GetItemData(NULL)` wirft |
| 10:43:37 | Behebung eingesetzt |
| 10:50:14 | Wurfstelle am Maschinencode bestätigt (`dumpbin /disasm` an Gregors EXE mit PDB) |
| 10:54:28 | gültiger Nachstelllauf: 7.2.0.84 zeigt die Meldung, 7.2.0.86 nicht |

[E-115](../BEFUNDE.md#e-115) war vorher mit drei Nachstellläufen nicht zu fassen. Am offenen Fenster dauerte es 73 Sekunden bis zur Wurfstelle.

**Lücke 1: das Werkzeug lag nur im Scratchpad.** `stapel-lesen.ps1` entstand in dieser Minute im Sitzungsverzeichnis und wäre mit der Sitzung verschwunden. Die Schranke-Zeile oben hatte genau dieses Werkzeug als fehlend genannt. Es liegt jetzt unter `tools/` ([[wissen-gehoert-in-dateien]]).

**Lücke 2: was das Werkzeug nicht zeigt, sieht aus wie „nicht da".** Der Stapel wird abgetastet, nicht abgewickelt. Gedruckt wurde nur, was einen Symbolnamen hatte, und für `mfc140.dll` gibt es keine Symbole. Der Rahmen, der wirklich warf (`CTreeCtrl::GetItemData`), fehlte deshalb in der Ausgabe. Sicher war die Wurfstelle erst am Maschinencode: Die Rücksprungadresse `FindCheck+68` = `0049A8D3` steht direkt hinter `call [__imp_?GetItemData@CTreeCtrl…]` bei `0049A8CD`. Seit diesem Lauf druckt das Werkzeug mfc-Worte ohne Symbol als „ohne Symbol 0x…“.

**Lücke 3: das Messfenster ausdrücklich freigeben.** Was gebraucht wurde, lag um 10:42 vor. Danach brauchte es nur noch EXE und PDB, nicht den Prozess. Gregor fragte um 10:48:34 *„hast du alles aus dem test lauf? soll ich die messagebox wegklicken?"* und um 10:49:24 noch einmal *„also noch weiter stehen lassen?"*. Die Antwort kam um 10:49:55. Er hat also sieben Minuten länger gewartet als nötig und zweimal gefragt.

**How to apply (Ergänzung):**

- Der Ablauf ist: Protokollende lesen, dann `tools/stapel-lesen.ps1` mit Gregors Satz als `-Freigabe` aufrufen. Ausgabe und EXE/PDB-Prüfsumme sichern, **dann sofort schreiben: „Ich habe, was ich brauche, du kannst sie wegklicken."** Das Ende des Messfensters melde ich, nicht Gregor.
- Eine Wurfstelle aus abgetastetem Stapel ist eine Kette von Kandidaten. Bestätigt ist sie erst, wenn die Rücksprungadresse im Maschinencode hinter dem Aufruf steht. Der Befehl dafür ist `dumpbin /nologo /disasm:nobytes /range:<von>,<bis> Eudora.exe`, **aus PowerShell**, nicht aus Git Bash. Dort wird `/nologo` zu `C:\Program Files\Git\nologo` umgeschrieben, und dumpbin bricht mit LNK1181 ab (so geschehen um 10:50:03).
