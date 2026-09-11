---
name: fertig-heisst-fertig
description: "Wenn ich 'fertig' sage, muss Gregor mergen, loeschen und ein Release haben koennen - ohne dass etwas nachkommt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-11T11:49:10.481Z
---

Schranke: tools/pruefe-doku-takt.pl, tools/pruefe-stand-md.pl und tools/rollen-faellig.pl (alle drei in paket-bauen.ps1) - zusammen lassen sie kein Paket zu, dessen Fassung niemand beschrieben hat, dessen Standangaben hinterherhinken oder dessen Rollen nicht gelaufen sind

Gregor am 11.09.2026, nach einem Tag, an dem nach jedem „das kannst Du mergen"
noch etwas nachkam — veraltete Standangaben, ein fehlender CHANGELOG-Abschnitt,
eine falsche Zahl in der README, eine falsche Reihenfolge:

> *„wenn du sagst, du bist fertig, dann ist es ein zeichen, ich kann mergen und
> löschen und es gibt ein neues release, changelog und readme usw. sind aktuell.
> alles durch, alles fertig, geprüft, reviewt. punkt. kommt nichts mehr nach."*

Davor am selben Tag:

> *„deine nacharbeiten dauern mir immer zu lange!"*
>
> *„für mich ist es wichtig, daß es am ende (vor dem mergen) alles stimmt.
> hinterher nachzuarbeiten ist blöd, mußt du selbst machen."*

**Why:** Ein „fertig", nach dem noch etwas kommt, ist für Gregor teurer als gar
keine Meldung. Er merged, löscht den Zweig, und dann folgt ein zweiter Zweig mit
Nacharbeit — jedes Mal ein neuer Merge, eine neue Runde, eine neue Frage von ihm.
Der Aufwand verlagert sich von mir zu ihm, und genau das soll die Meldung
verhindern.

**How to apply:** Das Wort „fertig" erst benutzen, wenn **alle** Punkte stehen:

* Zweig gemerged **und** gelöscht werden kann — konfliktfrei gemessen, auch
  gegen die anderen offenen Zweige
* Release gebaut und veröffentlicht, wenn die Fassung eine ist
* `CHANGELOG.md` hat einen Abschnitt für die Fassung, `Noch offen` ist auf dem
  Tag, die Reihenfolge stimmt
* `README.md` und die übrigen Standdateien behaupten keinen Stand, den sie nicht
  haben — `tools/pruefe-stand-md.pl` und `tools/pruefe-doku-takt.pl` sind grün
* LEKTOR, PRÜFER und CHRONIST sind gelaufen, nicht fällig —
  `tools/rollen-faellig.pl` gibt 0
* alle Schranken und Gegenproben grün

Solange einer davon offen ist, heißt es **nicht** „fertig", sondern: was steht,
was fehlt, und wann es steht. Das ist keine Schwäche der Meldung, sondern ihr
Zweck — [[lauffaehiges-ergebnis-liefern]], [[daueraufgaben-brauchen-einen-takt]],
[[release-erst-nach-gregors-test]].
