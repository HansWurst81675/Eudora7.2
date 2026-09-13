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
