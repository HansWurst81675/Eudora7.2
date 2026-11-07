---
name: main-muss-immer-baubar-sein
description: "main trägt immer einen Stand, der fehlerfrei baut und aus dem sich jederzeit ein Release erstellen lässt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-05T17:20:39.006Z
---

Schranke: tools/bauen.ps1 (vor jedem Merge nach main)

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

## Nachtrag 07.11.2026 (CHRONIST): Bauen geht im frischen Baum, Schnüren nicht

Zeiten MEZ, Transkript `af1c188a`, gemessen. Der Paketstand 7.2.2.137 wurde zum ersten Mal in einem frischen Arbeitsbaum (`.wt/p137`) geschnürt. Gebaut hat er fehlerfrei (Vollbau 3 min 15 s). Das Schnüren brach dreimal ab: 14:39:55 *„Das Plug-in `EudoraUnicodeFix.dll` fehlt im Bauverzeichnis“* (liegt nur im Hauptordner, nicht im Repo), 14:41:33 Schritt 8 verlangt Gegenstücke im Bauverzeichnis, 14:41:46 *„Die Laufzeit-DLLs und Paige32d.dll fehlen in einem frischen Arbeitsbaum“*. Gregor 14:42:32 *„was treibst du denn da?“*, 14:42:39 *„hin und her? neubauen? abbrechen?“*, 14:43:34 *„nach dem frischen clone sollte es so sein, daß alles vorhanden ist. eine anleitung, wie man ein eigenes release.zip für github baut ist bereits vorhanden, erwarte ich.“* 14:45:36: eine solche Anleitung gibt es nicht. 14:48:20: *„die bau anleitung wird als nächstes sofort nachgeliefert! ich möchte lokal nach einem frischen git clone ein paket selbst bauen und testen können, um es auf github zu veröffentlichen!“*

`bauen.ps1` prüft „baut“, nicht „lässt sich ein Release erstellen“; die zweite Hälfte dieser Lehre hatte bis heute keine Schranke, und alle bisherigen Pakete kamen aus dem Hauptordner, in dem die fehlenden Dateien aus früheren Läufen herumliegen ([[pruefstand-nicht-bequemer-als-die-wirklichkeit]]). Die Klonprobe vom 06.11. (E-151) deckte den Prüfstand ab, nicht das Paket.

**Schranken-Vorschlag (nicht gebaut):** `paket-bauen.ps1 -Klonprobe` schnürt aus einem frischen `git clone` in einen Scratch-Ordner und vergleicht die Dateiliste mit dem letzten Release-ZIP. **Gegenprobe:** Stand `7e102069` → rot (`EudoraUnicodeFix.dll`, Laufzeit-DLLs); nach Nachtrag der Dateien oder der Anleitung → grün.

## Nachtrag 07.11.2026 nachmittags (CHRONIST): Klonprobe von Hand gefahren, Schranke weiter offen

Nach Gregors *„die bau anleitung wird als nächstes sofort nachgeliefert!“* (14:48:20) wurde die Probe von Hand gefahren. Zuerst ein Klon von `paket_7_2_2_137` (14:54:56), dieser Stand war aber ohne die Behebung in Schritt 8 ([[erfolgsmeldung-aus-dem-ergebnis]], Nachtrag 07.11.). Danach ein Nachzug auf `1051bfaf`: *„Aus dem frischen Klon steht ein Paket, mit der Grundlage aus dem Repo und ohne ein Release von GitHub“* (15:45:47), mit demselben Dateibestand wie das 137er-Paket (15:46:26). Zuletzt ein zweiter Klon ohne Projekt-Haken mit eigener Nummer 7.2.2.139 und dem neuen Schalter `-EigenerBau`: Paket in 0,7 min, `paket-pruefen` ohne Fehler (16:24:18). Unterwegs kamen drei Hürden zum Vorschein, die ein Fremder nicht nehmen kann: die Rollen-Schranke im Klon (15:44:47), die lückenlose Nummernfolge (16:17:34) und die Standzeilen der Doku (16:19:09). Genau dafür gibt es `-EigenerBau`. PRÜFER-108 K1 fand dazu, dass `-EigenerBau` ohne `-Bauart Release` still ein Debug-Paket geschnürt hätte. Das wird jetzt abgewiesen, gegengeprüft um 16:41:17.

Gregor fragte um 15:09:00, ob es genüge, `Bin\Release` zu zippen. Die Antwort stand in einer sichtbaren Zwischenmeldung (15:10:24: *„Nur `Bin\Release` zu zippen reicht nicht; dem Paket fehlen Laufzeit-DLLs und Hilfedateien …“*). Das genügt als Antwort, eine eigene Textantwort folgte nicht.

Der Schranken-Vorschlag `paket-bauen.ps1 -Klonprobe` von heute Vormittag ist weiter **nicht gebaut**. Die Probe hängt also wieder davon ab, dass jemand an sie denkt ([[schranke-gehoert-in-den-haken]]).
