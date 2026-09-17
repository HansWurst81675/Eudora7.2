---
name: ausloeser-an-den-anfang
description: "Eine Schranke am Ende der Arbeit beantwortet eine Frage, die am Anfang gestellt werden musste - rollen-faellig.pl hing nur am Paketbau"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-13T19:44:49.292Z
---

Schranke: tools/rollen-faellig.pl - haengt seit dem 13.09.2026 zusaetzlich MELDEND im pre-commit (abweisend bleibt sie beim Paketbau), damit der Rollenstand beim ERSTEN Commit eines Arbeitsblocks sichtbar wird und nicht erst beim Paket

## Der Auslöser

**Gregor am 13.09.2026 um 18:57:24:**

> *„maschst du wieder alles allein? magst du die anderen nicht so?"*

und 98 Sekunden später, weil die erste Frage nicht beantwortet war:

> *„wer läuft, wer macht was?"*

## Die Messung

Aus dem Transkript dieser Sitzung, maschinell gezählt:

| Zeitpunkt | Was geschah |
|---|---|
| 18:14:20 | letzte Nachricht von Gregor vor dem Block |
| 18:14–18:57 | **43 Minuten, 84 Werkzeugaufrufe** — keine Rolle gestartet, die Rollenschranke kein einziges Mal gefahren |
| **18:57:24** | **Gregor fragt** |
| 18:59:01 | LEKTOR gestartet — 97 Sekunden **nach** der Frage |
| 18:59:32 | PRÜFER gestartet |
| 19:00:05 | CHRONIST gestartet |
| 19:05:06 | `rollen-faellig.pl` läuft zum **ersten Mal** — **acht Minuten nach der Frage** und nachdem die Agenten schon liefen |

Die Schranke, die genau diese Frage mechanisch beantwortet, ist also
**nach** der Beschwerde und **nach** der Abhilfe gelaufen. Sie hat an diesem
Abend nichts verhindert, sondern nur bestätigt, was Gregor schon gesagt
hatte.

## Why — es lag am Zeitpunkt, nicht am Werkzeug

`rollen-faellig.pl` arbeitet richtig. Es hing bis zum 13.09.2026 aber **nur
in `paket-bauen.ps1`** — am allerletzten Schritt der Arbeit. Dort kommt die
Antwort zu spät: wenn das Paket gebaut wird, ist die Arbeit getan, und eine
Rolle hätte sie **begleiten** sollen.

Das ist eine eigene Fehlerklasse, verschieden von „es gibt keine Schranke"
([[lehren-anwenden-nicht-nur-schreiben]]) und von „die Schranke ist stumm"
([[erfolgsmeldung-aus-dem-ergebnis]]): **die Schranke greift, aber zu einem
Zeitpunkt, an dem ihre Antwort nichts mehr ändert.**

Dieselbe Form steckte schon in
[[daueraufgaben-brauchen-einen-takt]]: *„wenn Gregor nach ihnen fragen muss,
ist die Rolle nicht eingerichtet"*. Die Lehre stand da — was fehlte, war der
**Moment**, an dem sie geprüft wird.

## How to apply

* **Bei jeder Schranke fragen: ändert ihre Antwort zu diesem Zeitpunkt noch
  etwas?** Wenn nein, hängt sie falsch. „Läuft am Ende" ist für eine
  Freigabeprüfung richtig und für eine Arbeitsaufteilung falsch.
* **Was die Arbeit aufteilt, gehört an ihren Anfang.** Der erste Commit
  eines Arbeitsblocks kommt früh und ist ein verlässlicher Auslöser — dort
  meldet die Rollenschranke jetzt.
* **Meldend, nicht abweisend, wenn sie früh hängt.** Eine fällige Rolle darf
  das Committen nicht blockieren: eine lästige Schranke wird umgangen und
  fängt dann gar nichts mehr ([[pruefstand-kann-blind-sein]]). Abweisend
  bleibt sie dort, wo eine Freigabe ansteht — beim Paketbau.
* **Wenn Gregor eine Frage stellt, die eine Schranke beantworten kann, ist
  das der Beleg, dass die Schranke zu spät hängt.** Nicht die Frage
  beantworten und weitermachen, sondern den Auslöser vorziehen.

## Was Gregor selbst vorgeschlagen hatte

Am selben Tag, 10:45:56 — acht Stunden **vor** der Beschwerde:

> *„this most likely confirms my proposal to let the rolls run first and then
> release afterward. korrekt"*

Er hatte die Reihenfolge also bereits benannt: **erst die Rollen, dann das
Release.** Am Abend lief es wieder andersherum. Ein Vorschlag von Gregor, dem
ich zustimme und den ich dann nicht einbaue, ist keine Zustimmung, sondern
eine unerledigte Absprache ([[anweisungen-abarbeiten]]).

## Nachtrag 17.09.2026: „erster Commit" ist das Ende der Arbeit, nicht ihr Anfang

Dieselbe Fehlerklasse noch einmal, diesmal an `tools/pruefe-branch.pl` — der
Schranke, die im `pre-commit` als **erste** laeuft.

### Was passiert ist

**Erster Fall, 17.09.2026 morgens.** Der Zweig `e97-speichern-absturz` wurde
am 15.09. um 15:17 (`ccb97ab`) und am 16.09. um 19:25 (`fa76f4b`) von Gregor
nach `main` zusammengefuehrt, waehrend ich nicht daran gearbeitet habe. Am
17.09. um **07:48** wollte ich die E-97-Behebung committen — und erst da
meldete die Schranke:

> *HEAD steht auf …; origin/main enthaelt diesen Stand schon und ist
> 3 Commit(s) weiter.*

Die drei Commits auf `main` waren inhaltlich leer (reine Merge-Commits), der
Ausweg war `git merge --ff-only origin/main`. Der Schaden war also klein.
Klein war er aber durch Glueck: die Aenderung war zu dem Zeitpunkt schon
geschrieben.

**Zweiter Fall, am selben Tag, waehrend diese Lehre entstand.** CHRONIST hat
eine neue Lehre geschrieben, die Uebersichtstabelle neu gesetzt und wollte
committen. Dieselbe Meldung — inzwischen war `36a5ef4` dazugekommen, ein
weiterer Merge desselben Zweigs. Gemessen: `git log origin/main..HEAD` war
**leer**, `git diff HEAD origin/main --stat` ebenfalls. Der Zweig war zum
zweiten Mal an diesem Tag erledigt, und gemerkt habe ich es zum zweiten Mal
erst beim Committen.

### Why — die Schranke steht richtig und trotzdem zu spaet

`pruefe-branch.pl` steht im Hook bewusst an erster Stelle, mit der
Begruendung: *„die Frage ‚landet dieser Commit ueberhaupt irgendwo' kommt vor
jeder Frage nach seinem Inhalt."* Das stimmt — **innerhalb des Commits**. Der
Commit ist aber der **letzte** Schritt eines Arbeitsblocks, nicht der erste.
Zwischen „ich nehme die Arbeit wieder auf" und „ich committe" liegt die ganze
Arbeit.

Das ist genau die Form dieser Lehre: die Schranke greift, aber zu einem
Zeitpunkt, an dem ihre Antwort nichts mehr aendert. Hier kommt ein zweiter
Punkt dazu, der beim Rollenstand noch nicht sichtbar war: **der Auslaeser
fehlt ganz.** „Ich kehre zur Arbeit zurueck" ist kein git-Ereignis und kein
Hook — es ist der Moment, in dem eine Sitzung anfaengt oder Gregor nach einer
Pause wieder etwas schickt. Es gibt dafuer keinen Haken, an dem etwas haengen
koennte; es gibt nur `CLAUDE.md`, und die sagt bisher nichts dazu.

Und der Zustand entsteht **ohne mein Zutun**: Gregor merged, wann er will —
das ist die Absprache ([[nie-direkt-auf-main]]). Der Zweig wird also
regelmaessig unter mir erledigt, waehrend ich nichts tue. Ein Zustand, der
sich von selbst aendert, muss **gelesen** werden, nicht erinnert.

### How to apply

* **Beim Wiederaufnehmen der Arbeit, vor der ersten Aenderung:**

  ```
  git fetch origin && git log --oneline origin/main..HEAD
  ```

  Ist die Ausgabe **leer**, ist der Zweig erledigt — dann wird geklaert,
  wohin die naechste Aenderung geht, **bevor** sie entsteht. Das kostet zwei
  Sekunden und ersetzt keine Schranke; es stellt die Frage nur dort, wo die
  Antwort noch etwas aendert.
* **Der Ausweg ist vorspulen, nie verwerfen.** `git merge --ff-only
  origin/main`, oder `bash tools/arbeitsbaum-angleichen.sh <baum> main` —
  beides laesst jeden eigenen Commit stehen. Kein `reset --hard`
  ([[auftrag-darf-nicht-loeschen]]), und kein neuer Zweig ohne Gregors Ja zum
  Namen ([[zweig-vorher-abstimmen]]).
* **Wenn dieselbe Schranke zweimal an einem Tag dasselbe meldet, ist nicht
  der Zweig das Problem, sondern der Zeitpunkt der Frage.** Zweimal derselbe
  Fund heisst: den Auslaeser vorziehen, nicht den Fund wegraeumen
  ([[fehlerklassen-abstellen]]).

**Die Frage beim naechsten Mal:** *Wann habe ich zuletzt `git fetch`
gefahren — vor dieser Aenderung oder danach?*
