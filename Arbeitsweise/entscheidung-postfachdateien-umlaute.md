---
name: entscheidung-postfachdateien-umlaute
description: Gregor 03.11.2026 - neue Postfachdateien behalten den bisherigen Dateinamen ohne Umlaute; StripIllegalMT bleibt
metadata:
  type: project
---

Gregor am 03.11.2026 zu E-220 (Namensgeber): Sollen neue Postfachdateien Umlaute im Dateinamen behalten (`StripIllegalMT` in `QCUtils/src/services.cpp` vorzeichenlos vergleichen)? Antwort: *„So lassen (Recommended)“*. Nur der Vorschlag bei *Speichern unter* behält Umlaute (eigene Funktion `E220DateinameAusBetreff`); `StripIllegalMT` und damit die Dateinamen neuer Postfächer bleiben wie bisher.

Schranke: keine - Entscheidung Gregors; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt.

**Why:** geringer Nutzen (Dateiname nur im Explorer sichtbar), Risiko für ältere Fassungen/Werkzeuge am selben Mailverzeichnis.
**How to apply:** nicht wieder vorschlagen; im E-220-Eintrag als entschieden vermerkt.

Gregor dazu: *„wenn es jemanden anderen auffällt, soll er es als issue reinschreiben oder selber fixen.“* — als bekannte Eigenheit dokumentieren, mit Hinweis „Issue oder PR willkommen“; nicht selbst angehen. Gilt sinngemäß für ähnliche Randfälle ohne Nutzen für Gregor.
