---
name: entscheidung-marke-v7-2-1
description: "Die GitHub-Marke fuer Releases heisst v7.2.1.<n> (z. B. v7.2.1.123), nicht v1.0.<n> - entschieden, nicht wieder fragen"
metadata:
  node_type: memory
  type: project
  originSessionId: fa3529ec-b364-4d3f-89ee-3444ba209862
  modified: 2026-10-25T17:11:40.156Z
---

Die Marke auf GitHub heißt **`v7.2.1.<n>`**, `<n>` ist die laufende Buildnummer — z. B. `v7.2.1.123`. Das Release selbst heißt `7.2.1.<n>`.

Gregor am 25.10.2026, auf meine erneute Frage: *„zu 7: v.7.2.1.<n>, also z.b. 7.2.1.123. haben wir schon mehrfach besprochen, mit beispielen."* Seit 23.10. stand in `Intern/WEITERMACHEN.md` trotzdem „Offen an Gregor: heißt die Marke `v7.2.1.<n>` oder weiter `v1.0.<n>`?" — und LEKTOR wie ich haben es von dort immer wieder als offene Frage übernommen.

**Why:** Eine Frage, die in einer Datei als „offen" steht, nachdem sie beantwortet wurde, wird von jedem Lauf neu gestellt; Gregor muss dieselbe Antwort mehrfach geben.

**How to apply:** Nicht wieder fragen. `tools/release-veroeffentlichen.ps1` vor dem ersten 7.2.1-Release auf `v7.2.1.<n>` umstellen. Verwandt: [[rueckfrage-ist-keine-messung]], [[nur-offene-entscheidungen-auf-gregors-liste]], [[entscheidung-e148-release-7-2-0-123]].

Schranke: keine - eine Entscheidung; eingetragen in Intern/WEITERMACHEN.md und ZIEL.md, damit kein Lauf sie mehr als offen liest.
