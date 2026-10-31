---
name: stand-31-10-2026-abend
description: "Stand 31.10.2026 21:22 - #192 gemergt; Zweig e136_messweg (c5e8db39, kein PR) mit FAQ 16 und E-136-Messweg; MORGEN ZUERST: Paket 7.2.1.129 fuer Gregor (er testet damit den TESTPLAN), vorher LEKTOR; PRUEFER, CHRONIST faellig"
metadata:
  node_type: memory
  type: project
  originSessionId: 473878d1-638a-4825-8932-03b1fabf688f
  modified: 2026-10-31T20:03:05.720Z
---

Schranke: keine - Stand-Vermerk; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt.

Gregor am 31.10.2026: heutige Behebungen sind Schoenheitsfehler, kommen mit dem naechsten regulaeren Paket, kein Sonderbau.

**Gemergt: #192** (main `5869d718`) - E-140, E-139, E-171 behoben und am Programm gemessen (Faelle E-139p, E-140p, E-171p gruen); E-165 und E-136 Behebung im Quellstand, Befunde OFFEN; E-138 erledigt durch Doku ([[entscheidung-e138-erledigt-durch-doku]]); E-177 neu. LEKTOR-106/107/108 eingearbeitet. Zweig `e140-speichern-zeichensatz` ist in main - Loeschen ist Gregors Sache.

**Zweig `e136_messweg`** (Gregor: *„e136_messweg als branch name ok“*), gepusht bei `3d4df61a`, KEIN PR bisher. Inhalt: L-108.1/L-108.2 eingearbeitet; Messweg-Erkenntnis in BEFUNDE E-136.

**E-136 Messweg - Stand:** Strg-S schreibt nur bei IsModified() (CMessageDoc::OnUpdateFileSave; MFC fuehrt gesperrte Befehle auch per Botschaft nicht aus). Bearbeiten-Modus haengt am Knopf ID_EDIT_MESSAGE (32996) der Stingray-Leiste "Read Message" (SECToolBarManager, theReadMessageButtons, zur Laufzeit gekuerzt, Klasse `Afx:...`, 535x24, keine TB_-Abfragen). Kein Kindfenster 32996. NICHT auf Verdacht klicken (Fehltreffer = Delete moeglich). Naechster Schritt: Knopflage aus CReadMessageToolBar/SEC-Quelle bestimmen, dann WM_LBUTTONDOWN/UP, dann ID_EDIT_TEXT_ITALIC (32884, setzt SetModifiedFlag), dann ID_FILE_SAVE (57603). Skript: tools/messen-e136.ps1 (Pruefstaende C:\Temp\E136 neu, C:\Temp\E136-alt mit 7.2.1.128).

**Faellig:** PRUEFER (Code seit ae3efe3, viel neu: AutoCompleteSearcher, TridentView, spell, guiutils, msgutils...) und CHRONIST. Ungetrackt im Hauptbaum: `.claude/settings - Kopie.json` (nicht meine; bauen.ps1 deshalb mit -Ungesichert).

**Offene Frage an Gregor:** Suche in einer geoeffneten Mail (Blah Blah Blah + Find Text nach x-persona) am Pruefstand nachmessen? - beantwortet aus Menue/Ressource, nicht gemessen.

**Nachtrag 21:22 - Auftrag fuer die naechste Sitzung, ZUERST:** Gregor: *„bau mir dann ein 7.2.1.129“* und *„mit 7.2.1.129 kann ich die anderen fixes aus Intern/TESTPLAN.md testen“*; er merged, *„wenn alles fertig ist“*. Um 21:21 nicht mehr geschafft (Abschalten 22:00). Reihenfolge: (1) LEKTOR-Lauf auf `e136_messweg` (einzige Abweisung von `perl tools/paket-bereit.pl`), (2) Nummer 7.2.1.129 in `VERSION` und `Eudora71/Version.h` ([[nummer-erst-beim-schnueren]], [[version-eindeutig-machen]]), (3) `tools/bauen.ps1`, (4) `tools/paket-bauen.ps1`, (5) `tools/paket-pruefen.ps1`, (6) bereitstellen in neuem `C:\Users\Gregor\Eudora72-7.2.1.129-release` ([[fertige-fassung-bereitstellen]]), (7) PR, Gregor merged. FAQ 16 sagt zu E-171 "kommt mit dem naechsten Paket" - nach dem Schnueren auf 7.2.1.129 setzen. E-136 ist offener Datenverlust (kritisch), Behebung im Paket aber ungemessen - Gregor vor dem Test auf TESTPLAN e-136-naechstes hinweisen (Postfach sichern).

**Nachtrag 22:01:** 7.2.1.129 GESCHNUERT und bereitgestellt (`C:\Users\Gregor\Eudora72-7.2.1.129-release`, nicht veroeffentlicht; ZIP gitignored). PRUEFBERICHT BESTANDEN (350/19/46). Gregor testet: E-139 PASSED, E-88-Antwortweg ok (Mail lag im Spamordner des Anbieters), E-165 mit 2/3 Treffern "sieht besser aus" (1 Treffer offen), FAQ-16-Suche ok. PRUEFER-68 eingearbeitet (E-178, E-179 neu; K1 Rest E-136 Speichern unter). Lehre des Abends: neue Tests ohne TT_EndTest zaehlten Fehlschlaege nicht - Gegenprobe immer gegen den Rueckgabewert, nicht gegen [FEHL]-Zeilen ([[pruefstand-kann-blind-sein]]). LEKTOR-110 laeuft (bis 22:20), danach PR mit scratchpad/pr-129.md, Gregor merged.

**Nachtrag 22:05 - NACH dem Merge von PR (e136_messweg) eintragen:** Gregor: *„ja, e-165 behoben. ja, erst nach dem merge“*. E-165 auf "behoben in 7.2.1.129, von Gregor am 31.10.2026 bestaetigt" setzen; Beleg: zwei/drei Treffer Box passend (*„sieht besser aus e-165“*), ein Treffer zeigt keine Box, sondern ergaenzt im Feld (*„bei einem treffer kommt kein fenster zur auswahl. der text wird einfach der text ergänzt“*, gleich der VM-Messung). README-Zeile E-165 aus "Bekannte Fehler" nehmen bzw. als behoben fuehren; TESTPLAN-Ergebnis nachtragen. Ebenso FAQ 16: Suche auch an 7.2.1.129 bestaetigt.

**Schluss 22:16:** #193 gemergt (main cf1ec232); Gregor hat die Server-Zweige geloescht, ich die gemergten lokalen. Zweig `e165_schliessen_e136_speichern_unter` (Gregor ok): E-165 geschlossen (Gregor bestaetigt), E-136 zweiter Weg (.htm) behoben im Quellstand + Test, WEITERMACHEN-Zeile "Schranke TT_EndTest", FAQ 16 an 7.2.1.129. Bau abgebrochen (Gregor faehrt herunter) - NAECHSTES MAL ZUERST: bauen (TridentReadMessageView.cpp geaendert, ungebaut!), dann Schranke TT_EndTest bauen, LEKTOR/PRUEFER, PR. CHRONIST faellig.

**Offene Frage fuer morgen (Gregor 22:16):** *„wir müssen dann überlegen, welchen stand wir als release auf github wieder veröffetnlichen wollen: was muß denn alles enthalten sein, welche behebungen sollen drin sein.“* Meine Vorlage: seit v7.2.1.128 bestaetigt E-139, E-165, E-88-Antwort; gemessen ohne Gregors Test E-140, E-171, E-144, E-145; berichtigt ungemessen E-141, E-176; NICHT fertig E-136 (kritisch, Datenverlust; nur .htm/Strg-S behoben, ungemessen), E-178, E-179. Frage an Gregor: Release erst nach E-136-Messung (+E-178/179) oder vorher mit E-136 unter "Bekannte Fehler"? (Entscheidung 23.10.: Kritische kein Release-Blocker - wegen Datenverlust trotzdem nachfragen.) Release nur ueber tools/release-veroeffentlichen.ps1 und nach Gregors Test und Ja.
Gregor dazu 22:17: *„ja, ich denke, wir machen wieder mehrere fehlerbehebungen, bis ich ein build zum testen nehme.“* -> morgen mehrere Behebungen sammeln ([[pakete-sammeln]]), erst dann ein Testpaket; Release-Entscheidung danach.
Gregor 22:19 zu E-136: zuerst *„ja, auf medium setzen“*, dann nach der Stufenliste (kritisch/wichtig/unkritisch/werkzeug, BEFUNDE.md:145) *„unkritisch“*. -> morgen in BEFUNDE E-136 "Stufe: kritisch" auf "Stufe: unkritisch" setzen, als GREGORS ENTSCHEIDUNG mit Wortlaut und Begruendung (sichtbar nur bei Entitaeten im HTML, nur nach Bearbeiten+Strg-S oder Speichern unter .htm); Hinweis, dass die Tabelle stillen Zeichenverlust sonst kritisch nennt. README/Listen nachziehen. Rueckfrage "Release erst nach E-136?" entfaellt.
