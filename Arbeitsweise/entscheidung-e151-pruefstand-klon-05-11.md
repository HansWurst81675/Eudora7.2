---
name: entscheidung-e151-pruefstand-klon-05-11
description: Gregor 05.11.2026: Prüfstand aus dem Klon (E-151) – Starter fragt fremde Nutzer selbst (j/n), S/MIME-Fall ohne DLLs überspringen, Prüfserver nach Absturz aufräumen
metadata:
  type: project
---
Schranke: keine - Entscheidung; geprüft durch die Gegenprobe aus einem frischen Klon (E-151, Schritt g) und den Selbsttest des Starters.

Gregor am 05.11.2026 zu E-151 (Zweig `e151_pruefstand_klon`, Ziel: jeder Klon/Fork kann nach eigenen Änderungen den Prüfstand fahren):
- *„zu 1: die abfrage ist ok. macht sinn.“* → `Pruefstand starten.cmd` fragt auf fremden Rechnern den Nutzer selbst (j/n, Hinweis Fenster ~1 h, Registry vorübergehend); das Ja gilt als Freigabe und steht im Protokoll. Auf Gregors Rechner bleibt seine Freigaberegel.
- *„zu 2: ja, überspringen.“* → S/MIME-Fall (E-222w) ohne MFC71/msvcp71 wird mit Hinweis übersprungen, nicht rot.
- *„ablauf mit test mail server hört sich gut an, da alles lokal läuft. beim absturz muß er aufgeräumt werden, so daß nicht bei 3x starten auch 3 mail server im hintergrund laufen sich sich gegenseitig stören.“* → Prüfserver (POP/SMTP/IMAP, Perl, 127.0.0.1) müssen nach Abbruch/Absturz beendet werden; vor jedem Start Reste aufräumen (nach Pfad/Port filtern, nie fremde Prozesse).

**Why:** Fremde und Gregor separat sollen ohne Handarbeit prüfen können; liegengebliebene Server verfälschen Ergebnisse.
**How to apply:** Nicht wieder fragen. Siehe [[nichts-auf-gregors-bildschirm-starten]].
