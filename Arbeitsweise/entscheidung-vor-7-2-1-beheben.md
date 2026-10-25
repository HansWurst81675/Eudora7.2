---
name: entscheidung-vor-7-2-1-beheben
description: Gregor 25.10.2026 - vor 7.2.1 beheben E-137, E-142 (Hinweis), E-146; in die README als bekannte Fehler E-144, E-143, E-139, E-136, AN-1 (IMAP-Endung)
metadata:
  type: project
---

Gregor am 25.10.2026 auf die Frage aus LEKTOR-61 (offene, fuer Anwender sichtbare Fehler vor 7.2.1 beheben oder in die README?): *„ja, so machen wir es, plus: e-146"*.

**Vor 7.2.1 beheben:**
- **E-137** - Strg+W auf der Wazoo-Leiste beendet ganz Eudora.
- **E-142** - der am 24.10. vereinbarte **Hinweis**, dass beim Ziehen eines Entwurfs aus einem IMAP-Ordner nach Out Inhalt verloren gehen kann (kein Umbau).
- **E-146** - umbenannter IMAP-Ordner heisst in Eudora anders als auf dem Server; dazu der Fall "Server lehnt Umbenennen ab" (PRUEFER-50 K9).

**In die README unter "Bekannte Fehler":** E-144, E-143, E-139, E-136, AN-1 (Dateiendung ueber IMAP, Teil B5.7).

**Why:** Gregors Definition 7.2.1.x (ZIEL.md, 25.10.): ohne Einschraenkung weitergebbar ausser den README-Punkten.

**How to apply:** Auf dem naechsten Zweig, je mit Regressionstest (erst rot, dann gruen). Entscheidung zuerst in Intern/WEITERMACHEN.md und ZIEL.md eintragen ([[nur-offene-entscheidungen-auf-gregors-liste]]). Verwandt: [[stand-25-10-2026-abend]].

Schranke: keine - eine Entscheidung zum Umfang von 7.2.1; erledigt, wenn die drei behoben und die fuenf in der README stehen.
