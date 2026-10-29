# <a id="lektor-98"></a>LEKTOR-98 — Nachlauf zu 1d51bdcf (Release-Text v7.2.1.128)

Geprüft am 29.10.2026, nur Commit `1d51bdcf`: die drei Korrekturen zu
[LEKTOR-97](LEKTOR-97.md) und `Releases/7.2.1.128/RELEASE-NOTIZEN.md`.

**Ergebnis:** Alle 14 Befundnummern im Release-Text stimmen mit ihrer
Befundzeile überein; „behoben“ steht nur bei behobenen Befunden, [E-142](../Intern/BEFUNDE.md#e-142) ist als
offen benannt. Keine Daten aus Gregors Postfach. Alle 14 Anker `#e-…` und
`Releases/DEFENDER-FEHLALARM.md` gibt es auf `origin/main` (gemessen). Drei Funde.

## <a id="l-98.1"></a>L-98.1 — „19 Fragen“ stimmt auf `main` noch nicht

`RELEASE-NOTIZEN.md:53` verlinkt `blob/main/Doku/FAQ.md` und sagt
„beantwortet 19 Fragen“. Auf `origin/main` hat die FAQ **18** nummerierte
Abschnitte (gemessen: `git show origin/main:Doku/FAQ.md | grep -c '^## [0-9]'`
→ 18), auf `release-7.2.1` 19 (`Doku/FAQ.md:356`). Wahr erst nach dem Merge
von `release-7.2.1`; das Release darf erst danach veröffentlicht werden.
Außerdem ist Abschnitt 18 („Steht schon woanders“, `Doku/FAQ.md:342`) keine
Frage — „19 Abschnitte“ oder „18 Fragen“ wäre genau.

## <a id="l-98.2"></a>L-98.2 — Link „Bekannte Fehler“ ohne Anker

`RELEASE-NOTIZEN.md:61` verspricht die „README unter ‚Bekannte Fehler‘“, der
Link zeigt aber auf `README.md` ohne Anker, also an den Anfang. Die
Überschrift steht in `README.md:148` (`### Bekannte Fehler`); GitHub erzeugt
dafür `#bekannte-fehler` (belegt an der Überschrift, nicht im Browser gemessen).

## <a id="l-98.3"></a>L-98.3 — L-97.2 nur halb: TESTPLAN-Kopf weiter im Präsens

`Intern/TESTPLAN.md:5-9` sagt nach der Korrektur weiter „Die Titelzeile
**muss** … zeigen“ und „sein Schritt steht direkt hierunter und **braucht** das
leere Mailverzeichnis“ — Anweisungen für einen Test, der laut Zeile 1 und 3
schon bestanden ist. [L-97.1](LEKTOR-97.md#l-97.1) (`Intern/BEFUNDE.md:389`) und [L-97.3](LEKTOR-97.md#l-97.3)
(`Intern/TESTPLAN.md:45-48`, „belegt am Quelltext, nicht … gemessen“) sind
richtig umgesetzt (gelesen).

## Am Rand, kein Fund

[E-142](../Intern/BEFUNDE.md#e-142) (`RELEASE-NOTIZEN.md:22-23`): „übertragen wird er auf diesem Weg noch
nicht“ ist wahr; dass bei *Yes* eine leere Nachricht in `Out` entsteht, sagt
der Text nicht — *No* ist seit 7.2.0.124 vorgewählt (`Intern/BEFUNDE.md:378`).
Ob das in den Text gehört, entscheidet Gregor.
