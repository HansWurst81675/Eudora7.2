---
name: teilweise-ersetzte-header
description: "Include-Wächter wirken pro Datei — wer nur einen Teil eines Headers ersetzt, darf den Wächter nicht setzen"
metadata: 
  node_type: memory
  type: project
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-30T13:22:58.634Z
---

Die OT501-Ersatzschicht ersetzt bei manchen Stingray-Headern **nicht den ganzen
Inhalt**. Ein Include-Wächter (`__SECBTNS_H__` und Geschwister) ist aber
**alles-oder-nichts**: er schaltet die Originaldatei komplett ab. Man kann dem
Übersetzer nicht sagen „diese drei Klassen aus meiner Datei, den Rest aus deiner".

**Daraus folgen zwei Fälle:**

*Header vollständig ersetzt* → Wächter setzen. So arbeiten `OTShim.h`
(`__SECWB_H__`, `__SBARCORE_H__`, `__SBARDOCK_H__`, `__SWINMDI_H__`),
`OTShim_Reiter.h` (`__TABCTRLB_H__`, `__TABWNDB_H__`, `__TABCTRL3_H__`,
`__TABWND3_H__`), `OTShim_Bild.h` und `OTShim_Palette.h`.

*Header nur teilweise ersetzt* → Wächter **nicht** setzen. Stattdessen dafür sorgen,
dass die eigenen Deklarationen mit den verbleibenden Originaldeklarationen
verträglich sind.

**Der belegte Fall:** `secbtns.h` enthält `SECLoadSysColorBitmap` **und**
`SECBitmapButton`. Stufe 3 ersetzt nur die Knopfklassen, nicht `SECBitmapButton`.
Wer `__SECBTNS_H__` setzt, bekommt gemessen **102 Fehler statt einem**. Der richtige
Weg war, in `OTShim.h` das **Standardargument** wegzulassen und es dem Original zu
überlassen (`secbtns.h:340` hat `bool bToolbar = false`) — C++ verbietet, denselben
Standardwert zweimal festzulegen, auch wenn beide Male derselbe Wert dasteht
(`C2572`).

**How to apply:** Bevor ein Wächter gesetzt wird, den Originalheader öffnen und
prüfen, ob **alles** darin ersetzt ist. Ist es das nicht, nach kollidierenden
Deklarationen suchen und die eigene Seite anpassen — typischerweise
Standardargumente, `inline`-Rümpfe und `extern`-Deklarationen. Der Fehler meldet
sich als `C2572` (Standardargument doppelt), `C2011`/`C2371` (Typ doppelt) oder
`C2084` (Funktion doppelt definiert).

Steht ausführlich in `Eudora71/OTShim/PLAN.md` und auskommentiert samt Begründung
in `Eudora71/OTShim/OTShimAll.h`. Siehe auch [[pruefen-statt-vermuten]] — der
naheliegende Griff war hier zweimal der falsche.
