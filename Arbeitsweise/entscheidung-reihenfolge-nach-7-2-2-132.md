---
name: entscheidung-reihenfolge-nach-7-2-2-132
description: "Gregor 03.11.2026 - erst 7.2.2.132 mit dem Fertigen; danach E-192, E-199, E-188 (erst messen), E-193 (erst nachstellen); E-129, E-198 nur dokumentiert"
metadata:
  node_type: memory
  type: project
  originSessionId: f3d03714-d2ce-4d84-96d0-5244b9e265ce
  modified: 2026-11-03T09:21:56.961Z
---

Gregor am 03.11.2026, zweimal:

1. Vormittags *„ja“* zu: erst 7.2.2.132 mit dem schnüren, was fertig ist (nach e128, e170, about_dialog_github), danach die bekannten Fehler in eigenen Paketen 7.2.2.133 ff.
2. Nach der Abwägung Häufigkeit / Schaden / Aufwand (auf seine Bitte: *„wie oft sowas überhaupt vorkommen kann, wie wahrscheinlich ist es, was kann dabei schief gehen und wie aufwändig ist es, das zu fixen“*) *„Ja, neue Reihenfolge (Recommended)“*:
   - **E-192** (mehrere IMAP-Mails in Papierkorb/Junk/Filter — häufig, günstig)
   - **E-199** (`t;` bei Festbreite — selten, sehr günstig)
   - **E-188** zuerst nur **messen**, ob auf dem Server etwas verloren gehen kann; wenn nicht, nach hinten
   - **E-193** (Suche Umlaute/€) erst nachstellen, dann entscheiden
   - **E-129** und **E-198** vorerst nur dokumentiert, nicht behoben

Schranke: keine - Entscheidung Gregors; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt.

**Why:** Reihenfolge nicht wieder fragen; Grundsatz siehe [[randfaelle-nach-haeufigkeit-abwaegen]].
**How to apply:** nach dem Paket 7.2.2.132 mit E-192 beginnen; Reihenfolge in Intern/WEITERMACHEN.md eintragen.

**Offen für den E-192-Zweig (LEKTOR-138 L-138.10):** die E-189-Logzeilen in `ImapToc.cpp` (~1819/1825, „Vorab-Kopie …“) schreiben noch `ziel="<Ordner>"` — beim E-192-Zweig mit herausnehmen und im E-189-Eintrag vermerken.

**Ebenfalls für den E-192-Zweig (LEKTOR-138 L-138.11/.12, Kleinkram zu E-216):** im E-216-Eintrag „Nicht gemessen: der Umbruch selbst“ auf *Mail folder from* einschränken (für *Log* gemessen: 26 px nötig bei 33 px Platz); CHANGELOG zu E-216 auch den Fall `E-216l` nennen; WERKZEUGE-Kopfsatz zu `messen-about` auf alle sechs Pfadzeilen.
**Auch für den E-192-Zweig (LEKTOR-139 L-139.1):** TESTPLAN-Überschrift zu E-170 „Erledigt am 03.11.2026“ → „Schritt 3/4 bestanden am 03.11.2026“ (der Befund selbst ist offen).
