---
name: rueckfrage-ist-keine-messung
description: "Gregor zu \"S-3b\": \"ist es die s-bahn?\" - und als ich IHN nach der Bedeutung der vier unklaren Nummernkreise fragte: \"wie kann ich dir sagen, ob wir es abhaken koennen, wenn nicht mal du mir sagen kannst, was es ist?\" Die Antwort stand in den einfuehrenden Commits"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-30T21:49:47.826Z
---

Schranke: keine - eine Rueckfrage laesst sich nicht maschinell abweisen; sie geht als Text in den Chat und an keinem Haken vorbei. Was gebaut wurde, ist die **Antwort**: die Legende aller 16 Nummernkreise in `Intern/BEFUNDE.md`, jede Zeile mit ihrer Fundstelle. Die Probe steht unten unter *How to apply* Punkt 2 und ist der Befehl, der sie erzeugt hat.

# Eine Rueckfrage ist keine Messung — sie ist eine an Gregor weitergereichte

**Regel.** Was im Repository steht, messe ich. Gregor wird gefragt, wenn
eine **Entscheidung** ansteht oder etwas nur er wissen kann — was er sehen
will, wie etwas aussehen soll, ob er eine Fassung freigibt. Eine Frage nach
einer Tatsache, die im Repository steht, ist keine Ruecksprache, sondern
abgewaelzte Arbeit.

## Was passiert ist (22.10.2026)

Gregor las eine Zeile mit der Kennung `S-3b`:

> *„ist es die s-bahn?"*

Gemessen: **16 Nummernkreise** im Bestand — `E-`, `A-`, `AN-`, `S-`, `B-`,
`M-`, `R-`, `V-`, `P-`, `PR-`, `W-`, `F-`, `X-`, `Z-`, `NP2-`, `NP3-` —
**nirgends erklaert.** `CLAUDE.md` nennt acht davon und sagt nur, dass es
sie gibt.

Mein naechster Schritt war falsch: ich habe **ihn** gefragt, was vier der
Kreise bedeuten sollen. Seine Antwort:

> *„wie kann ich dir sagen, ob wir es abhaken koennen, wenn nicht mal du mir
> sagen kannst, was es ist?"*

Er hat recht, und das Nachmessen hat es belegt: **jeder der vier Kreise war
in seinem einfuehrenden Commit benannt**, mit Datum und Wortlaut —

| Kreis | stand seit | woertlich |
|---|---|---|
| `B-` | `23ca822e`, 30.08.2026 | *„VC71Bruecke: eigene msvc…"* — die Ersatzbausteine fuer fehlende Fremdbibliotheken |
| `M-` | `3ad6768b`, 30.08.2026 | *„Befund M-1 …"* — die Menueleiste |
| `R-` | `8f1c51e1`, 31.08.2026 | die Fehlerklasse hinter E-11, gezaehlt von `tools/releasebuffer-pruefen.pl` |
| `P-` | `4e72c9f4`, 30.08.2026 | *„Tests: Registerkar…"* — Funde aus einem Testlauf gegen die Ersatzschicht |

Die Frage hat also nichts erfahren, was ich nicht in drei Minuten haette
messen koennen — und sie hat Gregor die Arbeit aufgeladen, in seinem
Gedaechtnis nach einem Kuerzel von vor acht Wochen zu suchen, das **ich**
vergeben hatte.

## Warum die benachbarten Lehren nicht gegriffen haben

- [[bestand-vor-neuer-suche]] trifft die Sache genau, hat aber einen eng
  gefassten Ausloeser: `offene-befunde.pl` und `befund-suchen.pl`, beide auf
  `Intern/BEFUNDE.md`. *„Was bedeutet dieses Praefix?"* ist keine Suche nach
  einem Befund, sondern nach seiner **Herkunft** — und die steht in der
  Commit-Geschichte, die kein Werkzeug durchsucht.
- [[pruefen-statt-vermuten]] verbietet die Vermutung. Eine Rueckfrage fuehlt
  sich wie das Gegenteil einer Vermutung an — sorgfaeltig, vorsichtig,
  ehrlich. Deshalb hat die Lehre nicht gefeuert: sie kennt nur zwei
  Zustaende, raten und messen, und sieht nicht, dass Fragen ein drittes ist.
- [[erst-pruefen-dann-anweisen]] deckt den umgekehrten Weg ab, die
  Handlungsanweisung an Gregor. Hier ging keine Anweisung hinaus, sondern
  eine Frage — und die kostet ihn genauso viel.

## How to apply

1. **Vor jeder Frage an Gregor: wo steht die Antwort, wenn sie im
   Repository steht?** Drei Orte, in dieser Reihenfolge: die Datei selbst,
   `git log -S` auf den gesuchten Ausdruck, `git log --diff-filter=A` auf
   die Datei, in der er zuerst auftauchte.
2. **Der Befehl, der die Legende erzeugt hat**, und damit die Probe fuer
   jedes kuenftige Kuerzel:

   ```bash
   git log --reverse --oneline -S'S-3' -- '*.md' | head -3
   ```

   Er nennt den Commit, der die Kennung eingefuehrt hat, samt
   Commit-Nachricht — und die Commit-Nachricht sagt in diesem Projekt fast
   immer, wofuer sie steht.
3. **Eine Frage, die ich stellen muss, ist zuerst ein Befund.** *„Was
   bedeutet `S-`?"* ist nicht die Frage, sondern die Meldung: *es gibt
   keine Legende.* Gebaut wurde deshalb die Legende, nicht die Antwort auf
   die eine Frage.
4. **Erlaubte Fragen an Gregor:** was er will, was er sieht, ob er freigibt,
   welche Reihenfolge gelten soll. **Nicht erlaubt:** was im Repo steht, was
   ich selbst geschrieben habe, was ein Werkzeug ausgibt.
5. **Wer ein Kuerzel vergibt, schreibt im selben Commit auf, wofuer es
   steht.** Sonst ist in acht Wochen niemand mehr da, der es weiss — auch
   nicht der, der es vergeben hat ([[wissen-gehoert-in-dateien]]).

**Nachtrag 24.10.2026 — Einstufungen sind meine Aufgabe.** Ich habe aus LEKTOR-55 die Frage „Ist E-142 kritisch?" an Gregor weitergegeben, wie schon LEKTOR-54 vorher. Gregor: *„was haben wir zu E-142 vereinbart? warum fragst du dann nach?"* Vereinbart war nichts — aber die Einstufung hat er mir am 22.10.2026 übertragen (*„markiere diejenigen, die du als kritisch betrachtest"*). Eine Frage aus einem Agentenbericht wird vor dem Weitergeben geprüft: Ist es wirklich seine Entscheidung (Produktverhalten, Release, Namen), oder eine, die er mir übertragen hat (Einstufung, Reihenfolge der Tests, Form der Doku)? Nur das Erste geht an ihn.

**Berichtigung 25.10.2026 (CHRONIST) zum Nachtrag 24.10.:** Der Satz *„Vereinbart war nichts"* ist falsch. Gregor hatte am 24.10. um 13:29 MESZ entschieden: *„e-142: hinweis in readme + FAQ: erst prüfen, dann lsöchen."*, und ich hatte es um 13:29 selbst in `stand-23-10-2026-spaet.md` (Zeile 34) eingetragen. Gregor um 22:37: *„e-142 stimmt nicht, was du sagst: wir haben ausgemacht, daß es als hinweis kommt …"*. Meine Suche um 22:35 traf die Datei, aber `| head -6` schnitt die Ausgabe vor Zeile 34 ab — gemessen. Die Lehre dazu: [[gekuerzte-ausgabe-ist-kein-ergebnis]]. Der Kern dieses Nachtrags (Einstufungen sind meine Aufgabe) bleibt richtig.

## Nachtrag 28.10.2026 (CHRONIST): eine Rückfrage aus einer Fehllesung des Protokolls

Zeiten MEZ, 27.10., Transkript `15164e13…` (die Uhr der VM sprang an dem Abend, Zeiten wie im Transkript plus eine Stunde).

In Gregors Protokoll `eudora_20261027.zip` steht in Zeile 54349 ein neuer Kopf, *„Tue Oct 27 22:46:24 2026 / Version 7.2.0.127“*. Ich las ihn als neue Sitzung, in der die Junk-Frage nicht kam. Um 17:38:04 ging an Gregor: *„Hast du zwischen 22:46 und 23:00 das Verzeichnis neu ausgepackt oder die `Eudora.ini` ersetzt?“* Gregor um 17:46:53: *„nein. nur das zip, was ich selbst hier erstellt habe, auf einem andern desktop ausgepackt und gestartet.“* Um 17:47:04 begann ich, die Sitzungsanfänge zu vergleichen, und um 17:47:24 kam: *„jetzt brauchst du nichts mehr zu vergleichen.“* Danach stand im Befund, dass der Abschnitt „22:46“ kein neuer Start ist, nur ein neuer Protokollkopf derselben Sitzung (Commit `0fa1d5e6`, *„Abschnitt 22:46 ist dieselbe Sitzung“*).

Die Antwort stand in der Datei, die schon offen war: Vor Zeile 54349 gibt es kein `Logging shutdown` (gemessen 17:31:43: das erste steht in Zeile 57806), und nach dem Kopf folgt kein Startablauf, keine Zeile `Search data file …`, kein `Building mailbox 'Out'` (gemessen 17:47:08). Gregor musste eine Frage beantworten, die das Protokoll beantwortete, und danach eine Messung abbrechen, die erst nach seiner Antwort begann.

**How to apply, zusätzlich:** Ein Protokollkopf ist erst dann eine neue Sitzung, wenn davor ein `Logging shutdown` oder ein Abbruch steht und danach der Startablauf (`Search data file …`, `Mode`, das erste `Building mailbox`). Das wird gezählt, bevor Gregor eine Frage zum Verlauf bekommt. Dass die beantwortete Frage danach noch einen Tag im Stand-Vermerk stand, steht bei [[nur-offene-entscheidungen-auf-gregors-liste]], Nachtrag 28.10.

## Nachtrag 30.10.2026 (CHRONIST): „Kannst du sie einfügen wie vorhin?“

Zeiten MEZ, Transkript `f6188ad4`, gemessen. Gregor um 22:36:30: *„eine weitere abfrage kam immer noch!“*. Die Antwort: *„Welche das war, sehe ich von hier aus nicht. Der LEKTOR meldet sich erst am Ende bei mir. Kannst du sie einfügen wie vorhin?“* Gregor um 22:37:27: *„ich schreibe mir ja nicht jeden mist auf, den du mir hier schreibst.“*

Der Befehl stand schon im Transkript des Agenten, `f6188ad4-…/subagents/agent-aeab87a7f2fc280c8.jsonl`, mit Zeit und Wortlaut, und er ist mit Grep ohne Abfrage lesbar. Diesen Ort hatte der CHRONIST-Bericht vom Vormittag genannt ([[CHRONIST-2026-10-30b]], Werkzeugmängel Punkt 2: *„Die Ausgabedateien unter `tasks/` sind für Grep blind“*, die sehende Quelle ist `subagents/agent-*.jsonl`). Gefunden habe ich dort alle acht Ablehnungen des ersten LEKTOR, jede mit Befehl.

**How to apply, zusätzlich:** Was ein laufender Agent getan hat, steht in `<sitzung>/subagents/agent-<id>.jsonl`. Gesucht wird dort mit Grep nach `"toolUseResult":"Error: Permission` oder nach `"name":"Bash"`, bevor Gregor gefragt wird, was er gesehen hat.
