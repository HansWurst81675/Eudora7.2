---
name: stand-25-10-2026-abend
description: "Uebergabe 25.10.2026 spaet - RC1_vorbereiten als PR gemeldet; morgen zuerst CHRONIST, dann E-142-Hinweis, E-146, Logzeile, E-132-Pruefstandsfall, LEKTOR-61-Funde, Testpaket 7.2.0.123"
metadata:
  node_type: memory
  type: project
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T19:48:30.601Z
---

Stand 25.10.2026, ca. 21:00. Zweig `RC1_vorbereiten` als PR gemeldet (Gregor merged, dann schaltet er ab). Alles gesichert und gepusht.

**Auf dem Zweig:** Berichtigungen "keine Luegen auf main" (TESTPLAN M1 Schritte 1-4, CHANGELOG-Kopf, Stand-Koepfe, README E-148 "ab dem Release 7.2.1"), E-100-INI nach dem Beenden gemessen, E-137 eingebaut am Anfang von `CMainFrame::OnCommand` (am Programm NICHT gemessen - Gregor prueft im Testpaket, angedockt und schwebend, mit offenem In), E-147 neu (Plug-in-Code, nach 7.2.1, Ray im Issue #102 gefragt). Pruefbericht 302/19/32 auf 78f2ad2a.

**Morgen, in dieser Reihenfolge:**
1. **CHRONIST** ueber den Verlauf seit 19:56 (Gregor: *„chronist kann morgen noch laufen."*).
2. Die 4 Server-Zweige `wt/lektor-20261025g..l` / `wt/pruefer-20261025d..g` stecken nach dem Merge in main - Gregor zum Loeschen geben (die Rechtepruefung liess mich nicht loeschen) bzw. Liste per `git merge-base --is-ancestor` messen.
3. Vor 7.2.1 noch: **E-142-Hinweis**, **E-146** (inkl. "Server lehnt Umbenennen ab"), **Logzeile rootcerts.p7b** ([[entscheidung-rootcerts-logzeile]]), README-Eintraege E-144/E-143/E-139/E-136/AN-1 ([[entscheidung-vor-7-2-1-beheben]]).
4. **E-132 als Pruefstandsfall** (Schritt 5 automatisch, gemerkte Antwort zuruecksetzen, Registry sichern/wiederherstellen).
5. LEKTOR-61-Funde (README "Bekannte Fehler", Ort fuer Gregors Testergebnisse, ZIEL "19 von 19" vs. "fast"), PRUEFER-57 K1/K3/K4 (niedrig).
6. Dann **Testpaket 7.2.0.123** schnueren - dabei die Fassungsnummer hochzaehlen, damit Bauten nicht mehr "Paket 1.0.122+..." heissen.

**Arbeitsregeln von heute (alle als Lehre da):** Ansage vor jedem Pruefstandslauf ([[nichts-auf-gregors-bildschirm-starten]]); Vereinbarungen sofort in die Datei ([[wissen-gehoert-in-dateien]]); keine bekannte Unwahrheit im PR ([[einschraenkung-im-pr-ist-kein-ja]]); rote Probe nur einmal beim Anlegen eines Tests ([[gegenprobe-einmal-beim-bau]]); Zwischendateien ins Scratchpad.

Schranke: keine - Uebergabenotiz fuer die naechste Sitzung; sie wird mit dem Abarbeiten erledigt.
