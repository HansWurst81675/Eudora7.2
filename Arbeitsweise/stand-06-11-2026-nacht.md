---
name: stand-06-11-2026-nacht
description: "Stand 06.11.2026 nachts — ranjit_bereinigt_teil2 gepusht (3d3586b7), LEKTOR fällig vor PR; danach 7.2.2.137 mit E-71, E-242, E-240"
metadata:
  node_type: memory
  type: project
  originSessionId: 8e921d9a-b658-4cfb-9fea-ce8200ddbb4c
  modified: 2026-11-06T21:53:39.088Z
---

Schranke: keine - Stand, kein Fehler.

- `ranjit_bereinigt_teil2` gepusht bis `3d3586b7` (Baum `.wt/bereinigt`): Pfade ins Benutzerverzeichnis aus 135 Dateien, Absender, Austauschordner, IP, Telefon-Trenner, E-246, E-240-Messung (38 s), E-147 (Rays BSD-3-Antwort), LEKTOR-158 und LEKTOR-159 hineingemergt. Kein PR. LEKTOR ist fällig (eigene Änderungen nach LEKTOR-159) — morgen zuerst LEKTOR über den Zweig, dann Gregor den Vergleichslink geben.
- Gregor 06.11.: Build-Pfade in Binärdateien und `.pdb` sind **unkritisch** (OpenSSL-Bibliotheken, alte QCSSL.dll bleiben unverändert); L-158.5 Commit-Verweise: nein ([[entscheidung-commit-verweise-bleiben-06-11]]).
- Gregor: E-71 (leerer Filterbericht) als Nächstes, in 7.2.2.137 mit E-242 und E-240; E-240 braucht zuerst eine Spurmarke am Anfang und Ende der Druckvorschau.
- Offen aus LEKTOR-159: L-159.1 E-151/E-243 noch „wartet auf Merge“, L-159.3 sechs Befunde „kommt mit 7.2.1.131“, L-159.4 PAKETE-Kopf, L-159.5 CHANGELOG-Einstieg, L-159.6 Testplan-Abschnitte; L-159.12 erledigt (Gregor: E-170 funktioniert, Text bleibt). E-147: nur Gregors Entscheidung, ohne Rays Antwort zu bauen.
- PRÜFER und CHRONIST fällig. Voller Prüfstandslauf nach Berichtigung der Pfadfälle (erwartet 107/107) steht aus, nur mit Gregors Freigabe.
- Nachtrag: #231 gemergt (1cb9087d). Gregor hat den Zweignamen `e71_filterbericht` freigegeben (06.11.2026: „ja, e71_filterbericht“) — morgen von origin/main anlegen, Eintrag in tools/ZWEIGE.md; LEKTOR morgen über main.
- Morgen zuerst: Log 7.2.2.136 (Gregors Austausch-ZIP vom 06.11., entpackt im Scratchpad e240-log-0611): beim Öffnen eines Test-Postfachs aus dem 26.10. „Failed size test“ (MBX größer als im TOC vermerkt) -> TOC neu aufgebaut, „10 of 20 saved, 2 new“. Prüfen, ob Mails fehlen (befund-suchen tocdoc.cpp, Log davor). Gregor soll LogLevel=58527 bis dahin lassen. Sonst unauffällig: 6 Starts, 6 saubere Enden, E-83-„liegengeblieben“ nur Zustand FERTIG, LMOS-Datei fehlt (OsError=2, normal ohne Leave-on-Server).
