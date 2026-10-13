---
name: funktionsbug-vor-buchfuehrung
description: "Wartet Gregor auf eine Behebung, läuft sie im Vordergrund zuerst; Buchführung (Doku, Aufräumen, Merges der Rollen) geht in den Hintergrund oder danach"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T09:45:00.000Z
---

Gregor am 13.10.2026: *„wann können wir denn endlich mit den echten funktionsbugs anfangen?"* (08:48 UTC) und eine Minute später *„wir sind wieder in einem modus, der mir nicht gefällt: viel bla, bla, wenig fortschritt. hättest du ja schon im hintergrund beheben müssen."* Dazu um 08:46: *„wieviele branches brauchst du denn noch?"*

Gemessen am Verlauf: Um 08:07 fragte er *„sind e-112 und e-113 gefixt?"*. Der Zweig `e-112_e-113_fix` wurde um 08:40 gemergt - **ohne eine Zeile Code** unter `Eudora71/`. Bis 08:50 lief im Vordergrund nur Buchführung: Freigabe-Schranke, E-114/E-115 eintragen, CHRONIST und LEKTOR zusammenführen, PR #94, 38 Mailadressen in 12 Dateien ersetzen, Haken neu einrichten, E-103 berichtigen, neun abgewiesene Commits ([[commit-auf-einmal-pruefen]]), drei Zweigvorschläge in elf Minuten (`mailadressen-raus` 08:43, `nachtrag-testlauf-1084` 08:45, `e-112-skalierung` 08:51). Die E-112-Behebung selbst begann um 08:50 und war um 08:56 mit grünem Test committet, um 09:15 am laufenden Programm gemessen - **sechs Minuten Code nach 43 Minuten Warten**.

**Why:** Gregor misst Fortschritt an dem, was er in Eudora anders sieht. Buchführung ist nötig, aber für ihn unsichtbar und erzeugt genau die Anzeige, die er „schrott" nennt ([[chat-knapp-halten]]). Jeder neue Zweig für einen Nebenschritt kostet ihn eine Rückfrage und ein Merge.

**How to apply:**
- **Nennt Gregor einen Funktionsfehler als nächstes Ziel, ist er der nächste Vordergrundschritt.** Was sonst ansteht (Doku nachziehen, Rollen zusammenführen, Aufräumen wie die Mailadressen), bekommt einen Hintergrundagenten im eigenen Arbeitsbaum ([[agenten-trennen-worktrees]]) oder wartet, bis die Behebung committet ist.
- **Ein Zweigvorschlag umfasst das ganze nächste Arbeitspaket**, Behebung eingeschlossen - nicht „erst ein Zweig für die Doku, dann einer für den Code". Kleine Nachträge, die anfallen, gehen auf den Zweig, der ohnehin offen ist ([[zweig-vorher-abstimmen]], [[zweigname-heisst-vorheriger-fertig]]).
- **Zweig mit Behebungsnamen ohne Behebung nicht zum Merge anbieten**, sondern umbenennen lassen oder die Behebung zuerst bauen.

Schranke: keine - ob der Vordergrund einer Behebung oder der Buchführung gehört, steht in keiner Datei; Messwert ist `tools/verlauf-messen.pl` (13.10. ab 08:13: 59 % Einwürfe) und `git diff --stat <letztes Paket>..HEAD -- Eudora71` beim Zweigvorschlag.
