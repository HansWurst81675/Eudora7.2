---
name: main-muss-immer-baubar-sein
description: "main trägt immer einen Stand, der fehlerfrei baut und aus dem sich jederzeit ein Release erstellen lässt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-05T17:20:39.006Z
---

Auf `main` steht **immer** ein Stand, der fehlerfrei baut und aus dem sich
**jederzeit** ein eigenes Release erstellen lässt.

Gregor am 05.09.2026: *„auf mein soll immer der stand sein, der fehlerfrei baut,
aus dem man jede zeit (!) ein eigenes release erstellen kann, klar?"*

Dazu, aus demselben Gespräch: *„ich möchte in der lage sein, nach dem repo clone
selbst eine version zu bauen. einfach sln in VS2022 laden und build starten. das
sollte ohne irgendweche tricks klappen!"* und *„und alle DLLs sollen so auch
baubar sein."*

**Why:** Der Maßstab ist der **frische Klon**, nicht der eigene Arbeitsbaum. Am
05.09.2026 kam heraus, dass das Repo aus einem frischen Klon **noch nie** baubar
war: `Eudora71/OT501` scheitert an `.\utility\crypt\Blackbox.cpp`, einer
Stingray-Quelle, die die CHM-Freigabe nicht enthält (Stingray war ein
kommerzielles Fremdprodukt). Das Verzeichnis `Src/utility/crypt` gibt es nicht,
`OTA50R.lib` hat nie existiert. Aufgefallen ist es erst, als ein `-t:Rebuild`
den Bau anstieß, der sonst nie angestoßen wurde.

Wer nur im eigenen Baum baut, merkt so etwas nie.

**Dazu eine zweite Lehre — über das eigene Urteil.** Ich habe zuerst behauptet,
mein `-t:Rebuild` habe eine vorgebaute `OTA50R.lib` gelöscht, und das Gregor so
gemeldet und ins README geschrieben. Es war falsch: die Dateien in `Src/OTA50R/`
trugen unverändert den 31.08., ein Clean hätte sie gelöscht. Ich hatte aus einer
Fehlermeldung eine Ursache konstruiert, statt die Zeitstempel anzusehen — und
mich dabei selbst beschuldigt, was genauso ungeprüft ist wie eine Ausrede. Erst
Gregors Frage *„woher kam OTA50R.lib?"* hat mich zum Messen gebracht.
Siehe [[pruefen-statt-vermuten]].

**How to apply:**

- Vor dem Zusammenführen nach `main`: in einem **frischen Klon** bauen, nicht im
  Arbeitsbaum. `git clone <repo> <scratch>` und dort Debug **und** Release.
- Bau-Artefakte gehören nicht in den Index — aber wenn ein Bau von einer Datei
  abhängt, die nicht im Repo ist, ist der Bau kaputt, nicht die Regel.
- `-t:Rebuild` und *Bereinigen* sind der Prüfstein, nicht der Feind: was ein
  Clean zerstört und der Bau nicht wiederherstellen kann, fehlt im Repo.
- Ein Projekt, das nie bauen kann, gehört aus dem Bau genommen — nicht durch
  ein danebengelegtes Artefakt am Leben gehalten.
- Rückgabewert 0 von MSBuild ist **kein** Nachweis. Zusätzlich prüfen: das
  Protokoll auf `error`, den Zeitstempel jedes Artefakts, und die
  Versionsressource gegen `EUDORA_BUILD_VERSION` in `Eudora71/Version.h`.

Siehe [[was-lauffaehig-heisst]], [[lauffaehiges-ergebnis-liefern]],
[[commit-auf-extra-branch-und-pushen]] und [[fehlerklassen-abstellen]].
