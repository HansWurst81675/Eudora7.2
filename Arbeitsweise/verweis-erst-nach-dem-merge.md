---
name: verweis-erst-nach-dem-merge
description: "Was nach aussen geht, wird gegen den SERVERSTAND gemessen, nicht gegen den Arbeitsbaum - am 21.10.2026 um 21:33 ging ein Beitrag an Issue 102 mit einem Verweis auf blob/main/MELDUNGEN-VON-AUSSEN.md hinaus, die Datei kam erst um 21:36:59 mit dem Merge an, und es war das zweite Mal"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-21T20:14:00.000Z
---

Schranke: `tools/pruefe-aussenverweise.pl` — hält jeden `blob/<ref>/<pfad>`- und `tree/`-Verweis auf das eigene Repository gegen `origin/<ref>` und meldet die toten. Im `pre-commit` als Schritt 1e, **meldend, nicht abweisend** (ein Entwurf darf einen Verweis tragen, dessen Ziel noch auf dem Zweig liegt). Gegenprobe beide Richtungen: `--selbsttest` 16 Fälle; `--stand 80b472aa` (der Stand von `main` um 21:33) weist `Releases/ISSUE-102-ABSCHLUSS.md` ab, derselbe Lauf gegen `origin/main` von heute nicht; Bestand 272 MDs, 8 eigene Verweise, alle vorhanden.

# Ein Verweis nach außen gilt erst nach dem Merge

**Regel.** Alles, was das Projekt verlässt — ein Issue-Kommentar, eine
Release-Notiz, eine Mail —, wird gegen das gemessen, was **draußen** steht:
`origin/main` und die veröffentlichten Tags. Der Arbeitsbaum und der eigene
Zweig sind für den Leser unsichtbar. Abgeschickt wird nach dem Merge, nicht
davor.

## Was passiert ist (21.10.2026, Issue #102)

| Zeit | Was |
|---|---|
| 21:16:19 | `f0d6ef73` legt `MELDUNGEN-VON-AUSSEN.md` an — **auf dem Zweig** |
| 21:25:00 | `4626fe24` committet die beiden Antwortentwürfe |
| ~21:33 | Beitrag abgeschickt, mit dem Verweis `.../blob/main/MELDUNGEN-VON-AUSSEN.md` |
| 21:36:59 | `e14bcb3f` merged PR 128 — **jetzt erst** liegt die Datei auf `main` |

Drei Minuten lang bekam jeder Leser des Issues 404. Gefunden hat es Gregor.

Gemessen: `git log --diff-filter=A -- MELDUNGEN-VON-AUSSEN.md` nennt genau
einen Commit, und `git log --first-parent main` datiert dessen Ankunft auf
`main` auf 21:36:59.

## Es war das zweite Mal — und die Lehre lag fertig im Repo

`Releases/ISSUE-102-ANTWORT.md`, Zeile 14–16, geschrieben am Tag davor:

> **Abgeschickt wird der Beitrag erst, wenn `v1.0.117` wirklich
> veröffentlicht ist** — gemessen am 21.10.2026 gibt es das Tag noch nicht,
> veröffentlicht ist `v1.0.113`. **Vorher zeigen alle vier Verweise ins
> Leere.**

Derselbe Satz, derselbe Fehler, dasselbe Issue, 24 Stunden später. Genau das
ist der Fall aus [[fehlerklassen-abstellen]]: beim zweiten Auftreten wird
gebaut, nicht ermahnt. Ein aufgeschriebener Vorsatz hat genau einen Leser,
und der hat ihn beim zweiten Mal nicht gelesen —
[[bestand-vor-neuer-suche]] in klein.

Der Maßstab musste dafür von außen kommen ([[einigkeit-ist-kein-beweis]]):
die Datei war auf der Platte, im Zweig, im Commit und in der Pull Request —
vier Dokumente, die sich einig waren, und alle vier zeigten nicht das, was
der Leser sah.

## How to apply

1. **Vor jedem Beitrag nach außen:**
   `perl tools/pruefe-aussenverweise.pl <datei>`. Der Entwurf liegt ohnehin
   unter `Releases/ISSUE-*.md` ([[wissen-gehoert-in-dateien]]).
2. **Reihenfolge einhalten:** erst mergen (oder das Release veröffentlichen),
   dann abschicken. Nicht umgekehrt, und nicht „gleichzeitig".
3. **Geht es nicht anders**, zeigt der Verweis auf den Zweig, auf dem die
   Datei wirklich schon liegt — ein `blob/<zweig>/`-Link ist ehrlich, ein
   `blob/main/`-Link auf einen Zweiginhalt ist eine Behauptung über den
   Serverstand.
4. **Das gilt nicht nur für Links.** Eine genannte Fassungsnummer, eine
   Prüfsumme, ein Release-Titel: alles, was ein Fremder nachsehen kann, wird
   gegen das Draußen gemessen ([[ursache-nur-gemessen-behaupten]] — behaupte
   nur, was gemessen ist).
5. **Der Hinweis im `pre-commit` kommt früh genug.** Am 21.10. lief der
   Commit mit dem Entwurf acht Minuten vor dem Abschicken.

## Nachtrag 27.10.2026 (CHRONIST): „Zeilen 23 bis 25“ – auf welchem Stand?

Zeiten MEZ, 26.10., gemessen am Transkript. Gregor 14:30:14: *„die anweisungen zu T3, T4 und T5 finde ich wo?“* Antwort 14:30:16: *„in `Intern/TESTPLAN.md`, im Abschnitt … ganz oben in der Datei, die Zeilen 23 bis 25.“* Das stimmte für meinen Arbeitsbaum. Gregor liest aber GitHub, und dort `main`. Gregor 14:30:56: *„falsch: wenn ich im testplan https://github.com/…/blob/main/Intern/TESTPLAN.md nach T3 suche, finde ich nichts.“* Der Kurztest lag nur auf `0.123_ergebnisse`, der PR war noch nicht gestellt.

Dieselbe Verwechslung am Vormittag, andersherum: Gregor mergte um 09:52 *„damit ich einen aktuellen test plan habe“* und sprang mit dem Anker `#m1-e132` direkt zu M1. M1 verweist nicht auf Teil 0, der davor zu tun war. 09:54:39: *„was ist teil 0? steht nichts im testeplan!“*

Für Gregor ist eine Datei im Repo das, was er auf GitHub unter `main` sieht. Jede Ortsangabe ohne Zweig meint für ihn `main` ([[nur-testplan-zaehlt]], [[testschritt-nennt-den-ort]]).

**How to apply, zusätzlich:**
- Eine Ortsangabe an Gregor ist ein **Link mit Zweig**, nie „Datei, Zeile N“. Steht es noch nicht auf `main`, steht das im selben Satz: *„noch nur auf `0.123_ergebnisse`: <Link>“*.
- Ein Abschnitt, auf den ein Anker zielt, nennt seine Vorbedingung selbst („vorher Teil 0“), denn der Anker überspringt alles davor.

## Nachtrag 30.10.2026 (CHRONIST): beide Richtungen am Release-Abend

Zeiten MEZ, 29.10., gemessen am Transkript `052dc212…` und an den LEKTOR-Berichten.

1. **Vor der Veröffentlichung, richtig gefangen.** Die Release-Notizen sagten *„beantwortet 19 Fragen“*, verlinkt auf die FAQ unter `blob/main`. Auf `main` hatte die FAQ 18 Abschnitte, nur der Release-Zweig hatte 19 (LEKTOR-98, L-98.1, 22:10). Der Satz wäre erst nach dem Merge wahr geworden, und einer der 19 Abschnitte war keine Frage. Berichtigt um 22:10:34, also bevor etwas hinausging. So wirkt diese Lehre, wenn der Auftrag an den LEKTOR sie enthält (*„Links zeigen auf existierende Anker auf main-Pfaden“*).
2. **Nach der Veröffentlichung, umgekehrt.** `v7.2.1.128` ging um 22:17:31 hinaus. Von da an sagten README, ZIEL, CHANGELOG, PAKETE und weitere Dateien auf `main` *„noch nicht veröffentlicht, veröffentlicht ist `v1.0.120`“*, bis PR #188 um 22:30:17 gemergt war: 13 Minuten. Erkannt und gemeldet wurde das ungefragt in derselben Nachricht wie die Veröffentlichung (22:18:03). Der Zweig dafür brauchte aber erst noch Gregors Ja zum Namen, und dann einen LEKTOR-Lauf mit drei weiteren Funden.

**Was Punkt 2 lehrt:** Ein Satz über den Zustand draußen (*„noch nicht veröffentlicht“*) wird durch die Handlung falsch, die er ankündigt. Der Merge kann ihn nicht rechtzeitig berichtigen, weil die Handlung **nach** dem Merge kommt.

**How to apply, zusätzlich:**
- Der Release-PR schreibt den Stand so, dass er vor und nach der Veröffentlichung wahr ist (*„veröffentlicht als `v7.2.1.128`, sobald Gregor zustimmt; davor `v1.0.120`“*), oder der Folgezweig mit den Sätzen in der Vergangenheit liegt **vor** der Veröffentlichung fertig, mit abgestimmtem Namen.
- Den Namen des Folgezweigs zusammen mit der Bitte um das Ja zur Veröffentlichung erfragen, nicht danach.
