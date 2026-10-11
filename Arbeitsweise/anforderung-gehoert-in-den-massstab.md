---
name: anforderung-gehoert-in-den-massstab
description: "Eine Anforderung, die nur in der Umsetzung steht, ist keine; sie gehoert nach ZIEL.md und braucht eine Schranke, die beide Seiten gegeneinander haelt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T12:45:43.666Z
---

Schranke: tools/doku-pruefen.pl (pre-commit, pre-push — Abschnitt 11 hält ZIEL.md gegen das Gebaute)

# Eine Anforderung, die nur im Gebauten steht, ist keine

**Gregor am 07.09.2026:** *„wo ist das requirement aufgeschrieben, welche
default werte bei neuem konto gesetzt werden sollen?"*

Antwort: **nirgends.** Gemessen, nicht geschaetzt — die sechs Werte standen an
vier Stellen, und keine davon war ein Massstab:

| Stelle | was dort stand | was es ist |
|---|---|---|
| `tools/DEudora.ini` | die Werte selbst, als Kommentar | die **Umsetzung** |
| `README.md` | wie `DEudora.ini` funktioniert | eine **Beschreibung** |
| `tools/paket-pruefen.ps1` | eine Pruefung auf diese Werte | eine **Pruefung gegen die Umsetzung** |
| Commit-Nachricht | die Begruendung | Geschichte |
| `ZIEL.md` | **nichts** — `grep` auf `SSLSendUse`: 0 Treffer | der **Massstab** |

Das ist der Kreis, in dem jede Selbstpruefung gruen wird: die Pruefung fragt
die Datei, die ich geschrieben habe, ob sie das enthaelt, was ich
hineingeschrieben habe. Aendert sich Gregors Wunsch, aendert sich nichts.
Vergesse ich einen Wert, fehlt er in beiden.

Seitdem steht in `ZIEL.md` der Abschnitt *Anforderungen neben den Kriterien*
mit **A-1** (Vorgaben fuer ein neu angelegtes Konto), und
`tools/doku-pruefen.pl` haelt als Pruefung 11 `A-1` gegen `tools/DEudora.ini`:
abweichender Wert, fehlender Schluessel und geloeschte Zuordnungen werden rot,
in vier Gegentests belegt.

**Warum:** Eine Anforderung ist die einzige Aussage, gegen die ich mich nicht
selbst pruefen kann. Sie kommt von Gregor, sie steht in **seiner** Datei, und
nur sie kann meine Umsetzung widerlegen. Ohne sie ist jede „erledigt"-Meldung
eine Behauptung ueber mein eigenes Werk. Ausserdem: was nicht im Massstab
steht, ist beim naechsten Start nicht auffindbar — der Chat ueberlebt kein
Abschalten ([[wissen-gehoert-in-dateien]]).

**Wie anwenden:**

- **Jeder Wunsch, der ein Verhalten festlegt, wird beim Aufnehmen im Massstab
  eingetragen** — nicht nach der Umsetzung, sondern **vor** ihr. `ZIEL.md`
  fuehrt die Kriterien (`0..n`) und die Anforderungen (`A-n`). Umgesetzt wird
  gegen die Kennung.
- **Die Anforderung steht im Wortlaut Gregors** dabei, mit Datum. Sein Grund
  gehoert dazu — hier: *„sonst werden die mails abgerufen und geloescht, wenn
  ich nicht dran denke"*, und aus diesem Grund folgte eine **dritte**
  Einstellung, die er nicht genannt hatte (`LeaveMailOnServer`).
- **Kein Requirement ohne Schranke, die die zwei Seiten gegeneinander haelt.**
  Massstab gegen Umsetzung, mechanisch. Eine Pruefung, die nur die Umsetzung
  liest, prueft nichts ([[schranke-gegentesten]], [[fehlerklassen-abstellen]]).
- **Der Test „wo steht das?" vor jeder Fertig-Meldung.** Wenn ich die Frage
  *„wo ist das aufgeschrieben?"* nicht mit einer Datei und einer Kennung
  beantworten kann, ist die Sache nicht fertig, sondern nur gebaut
  ([[erfolg-aus-anwendersicht]]).
- **Ein Wert hat eine Quelle.** Alle anderen Stellen verweisen auf die Kennung,
  statt die Zahl zu wiederholen ([[doku-parallel-nicht-hinterher]],
  [[version-eindeutig-machen]]).

Siehe [[was-lauffaehig-heisst]] und [[anweisungen-abarbeiten]].
