---
name: kuerzel-im-chat-uebersetzen
description: "Fundkürzel der Prüfer (F1, N1, L-38.4 …) nie allein im Chat – immer was passiert, wann, mit welcher Folge"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7cea137a-b641-4fdd-8a0a-143e0faaaa8b
  modified: 2026-10-16T09:36:07.470Z
---

Schranke: keine - was im Chat steht, liest kein Haken; Gregors Einwurf ist der Messwert ([[einwurf-ist-ein-messwert]]).

Im Chat mit Gregor keine Kürzel aus PRÜFER-/LEKTOR-Berichten (F1, N1, N2, L-38.4, P3 …) ohne Klartext. Jeder Fund wird beschrieben als: was der Anwender tut, was dann passiert, was verloren gehen kann – das Kürzel höchstens in Klammern dahinter.

**Why:** Gregor am 16.10.2026 abends, nachdem ich ein Release mit „wegen N1/N2, F1 behoben“ abgelehnt hatte: *„ich weiß auch nicht, was N1, N2 und F1 sind. das sagt mir nichts“*. Die Kürzel gelten nur innerhalb eines Berichts (N1 hieß in E-121 schon etwas anderes als in PRÜFER-32), und er liest die Berichte nicht – er entscheidet auf Grund meiner Chatzeilen. Gleich danach: *„du kannst mir nicht solche fragen stellen, ob F1 oder N17 oder P32.“* – das gilt also ausdrücklich auch für **Fragen und Entscheidungsvorlagen** an ihn: jede Wahl wird in Anwendersprache gestellt (was passiert bei A, was bei B), nie über eine Kennung.

**How to apply:** vor jeder Antwort, die einen Prüferbericht weitergibt, die Kürzel durch Anwendersätze ersetzen. Verwandt: [[chat-knapp-halten]], [[erfolg-aus-anwendersicht]], [[mannschaft-fuehren]].

## Nachtrag 20.10.2026: „was ist C8? ich kenne nur C4, das ist ein auto"

Um 19:18:30 UTC, als **Wiederholung** („und nochmal:"), und das Werkzeug
`verlauf-messen.pl` zählt für den Abend genau **ein** Wiederholungssignal —
dieses. Eine Stunde später, um 19:50:56: *„verstehe nichts, was du
schreibst."*

**Neu an diesem Fall: das Kürzel stand nicht nur im Chat, sondern im
`TESTPLAN.md`** — in dem Dokument, nach dem er handeln soll. Der Schritt hieß
„C8"; er hat dieselbe Sache schon dreimal gerügt (*„mit E- nur N- und R-
nummern komme ich nicht weiter"*). Berichtigt in `4953e1f1`: der Schritt heißt
jetzt *„Der Starttest — nimmt sich Eudora ein fremdes Mailverzeichnis?"*, die
Urteilszeile *„Starttest an 1.0.114 in Ordnung"*; der Anker `c8` bleibt, damit
vorhandene Verweise nicht ins Leere zeigen.

**How to apply, zusätzlich:**

- **Ein Dokument, nach dem Gregor handelt** (TESTPLAN, Release-Notizen,
  TESTEN.txt, Issue-Antworten), trägt in Überschrift und Urteilszeile **keine
  Kennung aus meiner Nummerierung**. Die Kennung darf als Anker bestehen
  bleiben — ein Anker ist eine Adresse, kein Text.
- **Nicht „kurz erklären" sondern ersetzen.** *„C8 (der Starttest)"* ist immer
  noch C8. Der Satz muss ohne die Kennung vollständig sein.

## Nachtrag 27.10.2026 (CHRONIST): „E-119e“, „T0“ und ein Pfad mit „…“

Zeiten MEZ, 26.10., gemessen am Transkript.

- 11:27:34: *„Der Prüfbericht ist nicht vollständig, weil E-119e noch nie gelaufen ist.“* Gregor 11:28:35: *„was ist e-119e?“*, 11:28:42: *„steht ja nichts im befunde.md“*. Das ist ein **Prüfstandsfall** (der fünfte zu E-119, in `tools/pruefstand-faelle.txt`), kein Befund. Er sieht aber aus wie einer. Gregor fragte um 11:36:18 noch einmal: *„mit e-119e muß ich da was machen?“*
- 13:27:16 *„was ist t1 und t5?“*, 14:21:37 *„1. was war t0..t5?“*, 14:24:42 *„t0“*. Am 26.10. waren nebeneinander Teil 0–3, K0–K8, M1–M3, N1–N6, T1–T5 und abends U1–U4 in Gebrauch, am 27.10. kam V1–V6 dazu. Jedes Paket brachte neue Buchstaben.
- 11:19:50: *„pfad mit ... geht nicht“*. Ich hatte den Pfad zum Absturzbericht mit `…` gekürzt, und Gregor hat versucht, ihn zu benutzen. Um 11:38:06 kam derselbe Kniff noch einmal, in einer Tabelle mit *„`…` steht für …“*.

**How to apply, zusätzlich:**
- Ein Pfad, den Gregor kopieren oder eintippen soll, steht **vollständig** und in einem Stück da, nie mit `…`.
- Interne Namen (Prüfstandsfälle, Schrittkennungen eines anderen Pakets) gehen nur mit Klartext an Gregor: *„der Prüfstandsfall E-119e (großes Bild in einer Mail; kein Befund, für Sie nichts zu tun)“*.

## Nachtrag 30.10.2026 (CHRONIST): „Entscheidung 20“

Um 08:27:40 MEZ schrieb ich: *„Als Nächstes würde ich deine Entscheidung ‚ab dem Release geht es mit 7.2.1 weiter‘ als Entscheidung 20 eintragen.“* Gregor um 08:36:24: *„lassen, dann mach weiter mit entscheidung 20: was ist 20?“* Der Inhalt stand im selben Satz. Gregor kannte aber die nummerierte Liste nicht, in die die Nummer gehört (`Intern/WEITERMACHEN.md`, „Geltende Entscheidungen“, seit dem Umbau am 30.10. die Nummern 1–20). Die Antwort um 08:36:31 hat das erklärt.

**How to apply, zusätzlich:** Eine Entscheidungsnummer nenne ich Gregor nur zusammen mit dem Inhalt, dem Datum und dem Ort der Liste. Beispiel: *„deine Entscheidung vom 30.10. (Nr. 20 in der Liste in WEITERMACHEN): auch Testpakete heißen 7.2.1.N“*.
