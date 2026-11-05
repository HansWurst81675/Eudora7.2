---
name: pr-zum-mergen-ganz-oben
description: Einen PR zum Mergen immer als erste eigene Zeile der Meldung nennen, nie im Fließtext
metadata:
  type: feedback
---
Schranke: keine - Form der Chatmeldung; kein Werkzeug sieht den Chat.

Am 05.11.2026 hat Gregor PR #227 übersehen: er stand am Ende eines längeren Absatzes („Weiterhin zum Mergen bereit: …“). Er: *„PR #227 habe ich nicht gesehen, ist jetzt merged“*.

**Why:** Gregor überfliegt lange Meldungen; ein Merge-Auftrag im Fließtext geht unter, und der Zweig wartet unnötig.
**How to apply:** Jede Meldung mit einem mergebereiten PR beginnt mit einer eigenen Zeile „**Zum Mergen: [PR #N](…)** – kurz worum“. Mehrere PRs: je eine Zeile, oben. Siehe [[chat-knapp-halten]].
