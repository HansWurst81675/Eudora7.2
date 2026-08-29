---
name: agenten-benennen
description: Jedem Agenten einen kurzen deutschen Namen geben und den Stand als Tabelle zeigen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:52.682Z
---

Jeder Agent bekommt einen kurzen, sprechenden deutschen Namen in Grossbuchstaben,
der sagt, woran er arbeitet - nicht die technische Auftrags-ID.

**Why:** Gregor hat am 28.08.2026 darum gebeten: "gib deinen agenten irgendwelche
namen, damit ich weiss, wer woran arbeitet und auf den du warten musst." Bei
mehreren parallelen Agenten ist sonst nicht erkennbar, was gerade laeuft, was
fertig ist und wodurch der naechste Schritt blockiert wird.

**How to apply:** Beim Start eines Agenten den Namen nennen, den Auftrag in einem
Satz und was er blockiert. Danach eine Tabelle fuehren mit den Spalten Name,
Auftrag, Status - getrennt nach "laeuft gerade" und "heute fertig geworden". Auch
die eigene Arbeit als Zeile aufnehmen, damit sichtbar ist, was ich selbst mache.
Ausdruecklich sagen, auf welchen Agenten ich warten muss und warum (welche
Dateien er belegt).

**Die Mannschaftstabelle gehoert in eine Datei im Repo**, nicht nur in den Chat.
Am 29.08.2026 musste Gregor dreimal nachfragen, wo Agenten geblieben sind: "wir
hatten bis zu sieben agenten, klar?", "war da nicht noch ein schranke agent oder so
aehnlich? und wer macht immer das review?", "den review agenten gab es aber bereits!
wo ist er hin? warum gibt es ihn jetzt nicht mehr?" Nach einer Kontextzusammen-
fassung weiss ich nicht mehr, wen ich beauftragt hatte und was offen war - die
Datei weiss es. Sie fuehrt pro Agent: Name, Auftrag, Zieldatei fuer sein Ergebnis,
Status, Commit. Siehe [[wissen-gehoert-in-dateien]].

Namen aus der Sache nehmen, nicht durchnummerieren: MAPPE fuer die
Workbook-Familie, LEISTE fuer die Andockleisten, KNOPF fuer die Werkzeugleisten,
LEKTOR fuer Doku-Korrekturen, PLATZHALTER fuer Dummy-Implementierungen,
PRUEFER fuer eine Pruefung ohne Aenderungen.
