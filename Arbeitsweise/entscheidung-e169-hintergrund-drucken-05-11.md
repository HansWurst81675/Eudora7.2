---
name: entscheidung-e169-hintergrund-drucken-05-11
description: Gregor 05.11.2026: E-169 Hintergründe beim Drucken/Vorschau als INI-Einstellung, Vorgabe AUS; beschreiben in Intern/EINSTELLUNGEN.md, Help→Settings Reference, FAQ
metadata:
  type: project
---
Schranke: keine - Entscheidung; geprüft durch den Regressionsfall zu E-169 (an/aus) und doku-pruefen.

Ursache E-169 (MESSER 05.11.2026, gemessen): Druckvorschau/Druck über den IE (OLECMDID_PRINTPREVIEW) lässt alle Hintergründe weg (bgcolor, CSS background-color, background-image); normale Bilder werden gedruckt.

Gregor: *„B: schaltbar mit default = OFF + bescheribung bei den help -> settings reference und FAQ und wo auch immer das noch sinnvoll ist "was eudora alles kann" oder wie der abschnitt hieß“*

→ INI-Schlüssel (Vorgabe 0); nur während des Druckens in HKCU\…\Internet Explorer\PageSetup Print_Background setzen und danach zurückschreiben (Muster Kopf/Fußzeile in CTridentView::Print). Doku: **Intern/EINSTELLUNGEN.md** (Gregor präzisiert 05.11.: *„Intern/EINSTELLUNGEN.md das meinte ich“* – „was Eudora alles kann“ = diese Datei, Schalter ohne Menüpunkt, belegt), Help → Settings Reference, Doku/FAQ.md, Release-Notizen; FUNKTIONEN.md nur Verweis.

**Why:** Gregor will die Wahl, Farbe/Tinte nicht ungefragt verbrauchen.
**How to apply:** Nicht wieder fragen. Siehe [[entscheidung-pruefstand-fenster-05-11]].
