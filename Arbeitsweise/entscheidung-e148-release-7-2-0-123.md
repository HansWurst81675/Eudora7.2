---
name: entscheidung-e148-release-7-2-0-123
description: "Gregor 25.10.2026 - E-148 (eMudhra-Wurzeln) kommt mit Paket 7.2.0.123 als Release, nach seinem lokalen Test; nicht bis 7.2.1 warten"
metadata:
  node_type: memory
  type: project
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T10:14:16.033Z
---

Gregor am 25.10.2026 auf die Frage aus LEKTOR-57 (warten bis 7.2.1 / 7.2.0.123 veröffentlichen / nur Hinweis): **„E-148: (b), nach meinem test veröffentlichen"**.

**Why:** Wer heute v1.0.120 lädt, bekommt vier kompromittierte eMudhra-Wurzeln mit; die Behebung ist fertig (117 Zertifikate), nur der Test mit Eudora selbst fehlt.

**How to apply:** Nach dem Merge von `agenten-befunde-25-10` das Paket 7.2.0.123 schnüren (Nummer erst beim Schnüren, [[nummer-erst-beim-schnueren]]), alle Prüfstände auf genau diesem Bau, dann als neues Verzeichnis neben Gregors letztem Eudora72-*-release bereitstellen ([[fertige-fassung-bereitstellen]]) mit Prüfanleitung — insbesondere Abruf bei GMX und freenet mit der neuen `rootcerts.p7b`. Veröffentlichen erst nach seinem Test und Ja ([[release-erst-nach-gregors-test]]). Offen bleibt die Tag-Frage `v7.2.1.<n>` oder `v1.0.<n>` — vor dem Veröffentlichen fragen. Die Entscheidung gehört nach dem Merge auch ins Repo (`Intern/WEITERMACHEN.md`).

Schranke: keine - eine Entscheidung zum Ablauf, keine Arbeitsregel; sie gilt fuer genau ein Paket und wird beim Veroeffentlichen von 7.2.0.123 erledigt.
