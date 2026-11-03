# <a id="lektor-139"></a>LEKTOR-139 (03.11.2026) — Merge von origin/main (#215, E-170) in about_dialog_github, nach 3aaad408

**Umfang:** nur der Merge-Commit `3aaad408` (Eltern `a45b6418` = about_dialog_github, `b959201b` = main nach #215). Gelesen: `git log --oneline -3`, `git show --stat HEAD`, `git diff HEAD^1 HEAD` für CHANGELOG.md, Doku/FUNKTIONEN.md, Intern/BEFUNDE.md, Intern/WEITERMACHEN.md, Intern/TESTPLAN.md; dazu die Zeilen zu [E-170](../Intern/BEFUNDE.md#e-170) und [E-216](../Intern/BEFUNDE.md#e-216) in allen fünf.

**Urteil:** [E-170](../Intern/BEFUNDE.md#e-170) und [E-216](../Intern/BEFUNDE.md#e-216) stehen nach der Zusammenführung beide richtig, nichts doppelt, nichts verloren, kein Widerspruch. Ein Kleinkram-Fund, nicht durch den Merge entstanden. **Hält den Merge nicht auf.**

## Messungen

* `perl tools/offene-befunde.pl` (gemessen): *„61 offene Befunde, in beiden Listen gleich.“*
* `perl tools/doku-pruefen.pl` (gemessen): Rückgabewert 0; gemeldet nur, dass ältere Dateien (u. a. Doku/ANWENDER.md, Intern/PORTIERUNG.md, Releases/*) den Quellstand 7.2.1.131 nicht nennen — unabhängig vom Merge.
* `git show --stat HEAD` (gemessen): 12 Dateien gegenüber dem ersten Eltern, darunter von den fünf nur CHANGELOG.md, Doku/FUNKTIONEN.md, Intern/BEFUNDE.md je 1 Zeile; Intern/WEITERMACHEN.md und Intern/TESTPLAN.md unverändert gegenüber about_dialog_github.

## Stand je Datei

* **CHANGELOG.md** (gemessen): Merge übernimmt die Fassung von main für die E-170-Zeile im Abschnitt *Zweig `e170_label_ohne_uidplus`* (CHANGELOG.md:158). [E-216](../Intern/BEFUNDE.md#e-216) steht im Abschnitt „Im Quellstand, noch in keinem Paket“ (CHANGELOG.md:176) und in der Offen-Tabelle (CHANGELOG.md:30), [E-170](../Intern/BEFUNDE.md#e-170) in der Offen-Tabelle (CHANGELOG.md:55) — je einmal, kein Doppel.
* **Doku/FUNKTIONEN.md** (gemessen): [E-170](../Intern/BEFUNDE.md#e-170) in *Change ▸ Label* jetzt mit UIDPLUS-Einschränkung (FUNKTIONEN.md:176, aus main, [L-138.1](LEKTOR-138.md#l-138.1)); [E-216](../Intern/BEFUNDE.md#e-216) unter *About Eudora…* (FUNKTIONEN.md:269) unverändert erhalten.
* **Intern/BEFUNDE.md** (gemessen): [E-216](../Intern/BEFUNDE.md#e-216) (BEFUNDE.md:400) unberührt; [E-170](../Intern/BEFUNDE.md#e-170) (BEFUNDE.md:430) in der Fassung von main (ohne Ordnernamen, 9bad293a). Je ein Anker.
* **Intern/WEITERMACHEN.md** (gemessen): Kopf (WEITERMACHEN.md:3) nennt [E-216](../Intern/BEFUNDE.md#e-216); [E-170](../Intern/BEFUNDE.md#e-170) steht in der Offen-Tabelle (WEITERMACHEN.md:104) gleichlautend mit CHANGELOG.md:55.
* **Intern/TESTPLAN.md** (gemessen): Abschnitt [E-170](../Intern/BEFUNDE.md#e-170) (TESTPLAN.md:350) und [E-216](../Intern/BEFUNDE.md#e-216) (TESTPLAN.md:500) je einmal.

## Funde

### <a id="l-139.1"></a>L-139.1 — TESTPLAN-Überschrift „Erledigt“ bei offenem E-170

TESTPLAN.md:350 überschreibt den Abschnitt mit *„Erledigt am 03.11.2026: das Label bleibt …“*, während BEFUNDE.md:430, CHANGELOG.md:55 und WEITERMACHEN.md:104 [E-170](../Intern/BEFUNDE.md#e-170) als **offen** führen (Ursache für 1.0.127 ungeklärt). Belegt; erledigt ist der Testschritt, nicht der Befund. Vorschlag: „Schritt 3/4 bestanden am 03.11.2026“. Nicht durch den Merge entstanden (Datei im Merge unverändert). Kleinkram.

## Was nur Gregor entscheiden kann

Nichts.
