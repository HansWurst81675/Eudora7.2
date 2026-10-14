---
name: chat-knapp-halten
description: "Antworten im Chat kurz halten; Messdetails gehören in BEFUNDE.md, nicht in die Konsole"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-13T09:45:00.000Z
---

Gregor am 13.10.2026, mitten im Testlauf zu 1.0.84: *„schreib hier nicht so viele inhalte in die console, das macht das ganze unübersichtlicher"*.

**Why:** Er testet parallel und braucht im Chat nur Ergebnis und nächsten Handgriff. Lange Tabellen, Befehlsausgaben und Herleitungen verdecken das.

**How to apply:** Je Antwort: Urteil in einem Satz, was er jetzt tun soll, höchstens eine Frage. Herleitung, Zahlen und Fundstellen stehen in BEFUNDE.md — dort nur verweisen (Kennung, Commit). Auch Werkzeugaufrufe mit kurzer Ausgabe fahren (grep -c, tail -3 statt ganzer Logs). Verwandt: [[auftrag-vor-selbstbetrachtung]], [[erfolg-aus-anwendersicht]].

Schranke: keine - die Länge einer Chat-Antwort steht in keiner Datei, die ein Haken lesen könnte; Gregors Einwurf ist der Messwert ([[einwurf-ist-ein-messwert]]).

## Nachtrag 13.10.2026 (CHRONIST): woran man sieht, dass die Antwort zu lang war

Gregors Einwurf kam um 07:52 UTC. Davor stand an diesem Morgen schon eine
Reihe von Fragen, die alle dasselbe sagen — er hat den Faden verloren:

| Zeit (UTC) | Gregor |
|---|---|
| 06:04 | *„e-49: ist es filter fenster?"* |
| 06:12 | *„weißt nicht, welche E-nummer, aber: …"* |
| 06:19 | *„was ist E-56? verstehe ich nicht"* |
| 06:32 | meldet den Save-As-Test als **E-110**; gemeint war E-101 |
| 06:34 | *„neue übersicht vom testplan?"* |
| 06:44 | *„was ist für mich noch zu testen? von den 14 punkten von gestern?"* |
| 06:48 | *„was ist e-101?"* und schickt um 06:49 den Pfad zur Datei **ein zweites Mal** |
| 06:56 | *„was muß ich jetzt tun?"* |
| 08:07 | *„sind e-112 und e-113 gefixt?"* |
| 08:09 | *„wir haben jetzt nur die doku glatt gezogen, nichts im code gefixt, ja?"* |

Zwei davon zeigen den Mechanismus. Um 06:35 stand die Umdeutung seiner
Nummer (*„E-101 kam vorhin als „E-110" bei mir an, ich habe es
eingeordnet"*) im zweiten Satz einer langen Testplan-Übersicht; er hat sie
nicht gesehen und dreizehn Minuten später gefragt, was E-101 ist. Und der
Zweig hieß `e-112_e-113_fix`, während unter `Eudora71/` seit `v1.0.84`
keine Datei geändert war; das stand erst in der Antwort auf seine zweite
Nachfrage.

**How to apply, zusätzlich:**

- **Ein Testpunkt heißt nach dem, was Gregor tut und wo**, die Kennung steht
  dahinter: *„Postfachleiste links breiter ziehen (E-49)"*, nicht *„E-49"*.
- **Ändere ich seine Nummer oder seine Einordnung, ist das der erste Satz.**
- **Jede Antwort während seines Tests endet mit dem einen nächsten
  Handgriff** oder mit „nichts, ich melde mich".
- **Bei jeder Frage nach dem Mergen steht vorne, ob Code geändert ist**
  (`git diff --stat v<letztes Paket>..HEAD -- Eudora71`), erst recht, wenn
  der Zweigname eine Behebung verspricht.

## Nachtrag 13.10.2026, zweiter Lauf (CHRONIST): warum es fünfzig Minuten später nicht gewirkt hat

Um 08:45 UTC, nicht ganz eine Stunde nach dieser Lehre: *„ich sehe
inzwischen wieder nichts, was du mir schreibst, weil so viel schrott
angezeigt wird. hatten wir anders ausgemacht"*, um 08:49 *„viel bla, bla,
wenig fortschritt"*.

Gemessen am Verlauf (`tools/verlauf-messen.pl`, ab 08:13): 27 Nachrichten
von Gregor, davon **16 Einwürfe (59 %)**. Von 08:13 bis 08:45 standen
**31 Textblöcke und 55 Werkzeugaufrufe** in seinem Fenster; drei Antworten
über 1000 Zeichen (08:33 PR-Meldung 1366, 08:37 1039, 08:43 1053), obwohl
die Lehre „Urteil in einem Satz" verlangt.

Drei Gründe, warum die Lehre nicht gegriffen hat:

1. **Sie regelte nur die Antwort am Ende.** Gregor sieht aber **jede**
   Zwischenzeile (*„Ich lese zuerst …"*, *„Der Haken weist ab …"*) und jeden
   Werkzeugaufruf mit seiner Beschreibung. Nach meinem Versprechen um 08:45
   (*„Ab jetzt laufen meine Befehle mit möglichst wenig Ausgabe"*) kamen bis
   09:31 noch **51 Textblöcke und 129 Werkzeugaufrufe**. Die Ausgabe der
   Befehle war kürzer - die Menge der Einträge nicht.
2. **Der Inhalt war Buchführung**, kein Fortschritt am Programm
   ([[funktionsbug-vor-buchfuehrung]]). Neun abgewiesene Commits erzeugen
   neun Ketten aus „Grund lesen - berichtigen - neu versuchen"
   ([[commit-auf-einmal-pruefen]]).
3. **Interne Kennungen gingen unübersetzt durch.** Um 09:23: *„was ist F2
   und F3? die funktionstasten auf meiner tastatur?"* - das waren die
   Fundnummern aus dem Bericht des PRÜFERS, wörtlich weitergegeben.

**How to apply, zusätzlich:**

- **Zwischenzeilen nur, wenn sie etwas für Gregor ändern** (er soll warten,
  er kann testen, etwas ist schiefgegangen). Sonst Werkzeugaufrufe ohne
  Begleittext hintereinander.
- **Mechanische Ketten (Doku nachziehen, Commit-Schranken, Merges der
  Rollen) gehören in einen Hintergrundagenten** - dessen Aufrufe stehen
  nicht in Gregors Fenster.
- **Fundnummern aus Agentenberichten (F1, C2, M-4) werden beim Weitergeben
  übersetzt:** *„Fund 2: steht nur die Breite im HTML, bleibt das Bild
  groß"*, nicht *„F2"*. Das gilt wie für Agentennamen
  ([[agenten-benennen]]).
- **Ein Versprechen wie „ab jetzt weniger" ist keine Maßnahme.** Was sich
  ändert, muss im nächsten Zug zählbar sein - weniger Einträge, nicht nur
  kürzere.
