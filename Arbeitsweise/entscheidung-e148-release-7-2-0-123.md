---
name: entscheidung-e148-release-7-2-0-123
description: "Gregor 25.10.2026 - E-148 (eMudhra-Wurzeln) wird mit dem Release 7.2.1.<n> veroeffentlicht, nach seinem lokalen Test; 7.2.0.123 ist nur Testpaket"
metadata:
  node_type: memory
  type: project
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T10:14:16.033Z
---

Gregor am 25.10.2026 auf die Frage aus LEKTOR-57 (warten bis 7.2.1 / 7.2.0.123 veröffentlichen / nur Hinweis): **„E-148: (b), nach meinem test veröffentlichen"**.

**Why:** Wer heute v1.0.120 lädt, bekommt vier kompromittierte eMudhra-Wurzeln mit; die Behebung ist fertig (117 Zertifikate), nur der Test mit Eudora selbst fehlt.

**How to apply:** Das Testpaket 7.2.0.123 schnüren (nur zu Gregors Test, kein Release) (Nummer erst beim Schnüren, [[nummer-erst-beim-schnueren]]), alle Prüfstände auf genau diesem Bau, dann als neues Verzeichnis neben Gregors letztem Eudora72-*-release bereitstellen ([[fertige-fassung-bereitstellen]]) mit Prüfanleitung — insbesondere Abruf bei GMX und freenet mit der neuen `rootcerts.p7b`. Veröffentlichen erst nach seinem Test und Ja ([[release-erst-nach-gregors-test]]). Die Tag-Frage ist entschieden: `v7.2.1.<n>` ([[entscheidung-marke-v7-2-1]]). Die Entscheidung gehört nach dem Merge auch ins Repo (`Intern/WEITERMACHEN.md`).

Schranke: keine - eine Entscheidung zum Ablauf, keine Arbeitsregel; sie gilt fuer genau ein Release und wird beim Veroeffentlichen von 7.2.1.<n> erledigt.

**Berichtigt 25.10.2026 abends (Gregor):** *„wir sprechen aber schon vom 7.2.1.x release, nicht die zwischenstände 7.2.0.123? nur daß wir uns verstehen."* — Veröffentlicht wird E-148 mit dem **Release 7.2.1.<n>** (Marke `v7.2.1.<n>`, [[entscheidung-marke-v7-2-1]]). **7.2.0.123 ist nur das nächste Testpaket** für Gregors lokalen Test (Absprache vom 24.10.: *„wir haben noch keine 7.2.1. version"*), kein Release. Ein eigenes Release 7.2.0.123 gibt es nicht.
