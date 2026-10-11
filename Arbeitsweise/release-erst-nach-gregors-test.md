---
name: release-erst-nach-gregors-test
description: "Ein GitHub-Release entsteht erst, nachdem Gregor die Fassung lokal geprüft und für gut befunden hat"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-09T11:45:00.000Z
---

Gregor am 09.09.2026:

> *„für die zukunft: erst teste ich hier lokal, wenn ich es für gut befunden
> habe, kannst du ein github release bauen. sonst haben wir eine situation wie
> jetzt: 0.27 released, aber bug drin"*

**Why:** Ein Release ist eine Aussage nach außen — „diese Fassung ist gut".
Wer sie trifft, bevor sie geprüft ist, macht sie auf Verdacht. Bei v1.0.27 war
es genau so: ich habe veröffentlicht, und **danach** kam Gregors Befund E-53
(beim Schließen bleibt ein Strich stehen). Die Fassung war released **und**
fehlerhaft, gleichzeitig.

Dazu kommt: ein Release lässt sich nicht sauber zurücknehmen. Löschen
zerstört den Anhang, wer es zwischenzeitlich geladen hat, hat die schlechte
Fassung. Bei v1.0.27 blieb nur, es als **Vorabfassung** zu kennzeichnen — mit
der Nebenwirkung, dass GitHub „Latest" automatisch auf ein Monate altes
Release zurückstellte.

**How to apply:** Die Reihenfolge ist nicht verhandelbar:

1. Bauen, Paket schnüren, `tools/paket-pruefen.ps1` laufen lassen.
2. Paket bei Gregor ablegen (`C:\Users\Gregor\Eudora72-<Fassung>-release`) und
   **sagen, was zu prüfen ist**.
3. **Warten.** Bis seine Rückmeldung da ist, entsteht **kein** Release, und
   keine Fassung wird auf „Latest" gehoben.
4. Erst nach seinem Ja: `tools/release-veroeffentlichen.ps1` mit seinem Satz
   als `-Freigabe`. Das Werkzeug prüft, dass im CHANGELOG-Abschnitt dieser
   Fassung eine Bestätigung steht, und weist sonst ab.

Commit und Push auf einen Arbeitszweig sind davon **nicht** betroffen — die
sind nach innen gerichtet und sollen weiter laufend passieren
([[commit-auf-extra-branch-und-pushen]]).

**Schranke:** tools/release-veroeffentlichen.ps1 (vor jedem Release)

Dieselbe Bauform wie [[nichts-auf-gregors-bildschirm-starten]] mit ihrer
Schranke `tools/testlauf.ps1`: eine Freigabe im Klartext, die im Protokoll
landet. Siehe auch [[erfolg-aus-anwendersicht]] — „gebaut" ist nicht
„bestätigt", und ein Release behauptet Letzteres.
