---
name: entscheidung-e151-unterordner-marke-06-11
description: "Gregor 06.11.2026: E-151 – Prüfstände in eigenem Unterordner mit Markendatei statt direkt unter C:\\Temp; Arbeitsverzeichnis wie beim Eudora-Start als Parameter übergebbar"
metadata:
  node_type: memory
  type: project
  originSessionId: 8e921d9a-b658-4cfb-9fea-ce8200ddbb4c
  modified: 2026-11-06T16:35:20.338Z
---

Schranke: keine - Entscheidung zur Bauweise; nach der Umsetzung prüft sie eine Schranke (Werkzeuge weisen Verzeichnisse ohne Marke ab), dann hier nachtragen.

Gregor am 06.11.2026 auf die Frage, ob die Vorgabe statt C:\Temp ein eigener Unterordner mit Erkennungsmarke werden soll: *„ja, eigener unterordner mit marke. man kann auch ähnlich wie bei start von eudora auch das arbeitsverzeichnis als parameter übergeben.“*

**Why:** Unter C:\Temp können fremde Eudora-Ordner mit echten Mails liegen ([[pruefstand-nur-mit-marke]]); die Prüfstand-Werkzeuge leeren Postfächer und schreiben Eudora.ini um.

**How to apply:** Auf `e151_pruefstand_klon`: Vorgabe-Wurzel ein eigener Unterordner (z. B. C:\Temp\Eudora72-Pruefstand), Einrichter legt eine Markendatei an, jedes Werkzeug, das dort anlegt/überschreibt/löscht, weist ein Verzeichnis ohne Marke ab; die Wurzel ist als Parameter übergebbar wie das Mailverzeichnis beim Eudora-Start (heute `-Wurzel`, bisher auf C:\Temp beschränkt). Die Fälle, die den Pfad selbst prüfen (E-133p/q, E-216l, A-5p), anpassen. In WEITERMACHEN als Entscheidung 39 eintragen. Einzelheiten aus PRÜFER-104 abwarten.
