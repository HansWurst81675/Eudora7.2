---
name: wissen-gehoert-in-dateien
description: "Befunde und Erkenntnisse gehören in Dateien im Repo, nicht nur in den Chat — sonst überleben sie kein Abschalten"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:57:27.061Z
---

Schranke: tools/lehren-spiegeln.pl (pre-commit)

Jeder Agent, der etwas herausfindet, schreibt sein Ergebnis in eine **Datei im Repo**
und committet sie. Ein Bericht, der nur im Chat steht, ist verloren, sobald der
Prozess endet oder mein Kontext zusammengefasst wird.

**Why:** Gregor hat am 28.08.2026 ausdrücklich gesagt "sichern und commiten, ich
schalte ab", und trotzdem fehlten danach Informationen. Zwei getrennte Ursachen:

1. Ich habe die Anweisung nicht ausgeführt. Am Mitschnitt nachgemessen ist der
   Ablauf genauer, als ich ihn damals eingeräumt habe: Gregors Nachricht "ich fahre
   die VM runter. du bleibst dran und sicherst den stand." ging um 14:36:40 in die
   Warteschlange, meine letzte Aktivität war 14:36:35 — die Nachricht wurde nie
   verarbeitet, ebensowenig zwei weitere um 14:37:21. "No response requested."
   antwortete ich nicht darauf, sondern um 16:23 auf die Wiederaufnahme-
   Aufforderung, also genau an der Stelle, an der die 1¾ Stunden Stillstand noch
   hätten aufgeholt werden können. (Meine damalige Selbstbezichtigung war ungeprüft
   und in diesem Punkt falsch — auch Schuldeingeständnisse gehören belegt, siehe
   [[pruefen-statt-vermuten]]. Zum Stillstand selbst: [[nie-stillstehen]].)
2. Wichtiger und weniger offensichtlich: **Committen sichert Dateien, nicht Wissen.**
   Die Befunde eines früheren Prüf-Agenten standen nur im Chat. Kein noch so
   gewissenhaftes Committen hätte sie gerettet, weil es nichts zu committen gab.
   Agenten sind Einwegarbeiter im Prozess; mit dem Abschalten der VM stirbt ihr
   gesamter Kontext.

**How to apply:** Beim Beauftragen eines Agenten immer mitgeben, in welche Datei sein
Ergebnis gehört — `BEFUNDE.md` für Prüfungen, `PLAN.md`/`INVENTAR.md` für Analysen,
`PORTIERUNG.md` für Portierungsentscheidungen. Auch "geprüft und in Ordnung" und
"nicht geprüft, weil …" gehören hinein; das erspart der nächsten Prüfung die Arbeit.
Vor einem angekündigten Abschalten alle laufenden Agenten committen lassen, nicht nur
den eigenen Arbeitsbaum.

**Das gilt für Absprachen genauso wie für Befunde.** Was Gregor festlegt,
zurückstellt oder zusagt, gehört sofort in eine Datei — nicht in meinen Kontext.
Er hat vier Mal nachfassen müssen ("war ja nicht so ausgemacht!", "habe ich gesagt,
les' nach!", "muß ich dich an alles erinnern?"). Siehe [[anweisungen-abarbeiten]].

Siehe auch [[commit-auf-extra-branch-und-pushen]] und [[agenten-benennen]].

## Nachtrag 20.10.2026: „steht es in weitermachen.md drin?" — nein, es stand im Chat

Um 19:54:25 UTC, 20 Sekunden nach *„schluß für jetzt!"*, fragte Gregor genau
das. Die ehrliche Antwort war **nein**: die vier nächsten Handgriffe — Paket
1.0.114 schnüren samt Prüfsumme, sein Starttest, dann erst das Release, dann
erst der Beitrag in Issue #102 — standen vollständig und in der richtigen
Reihenfolge **im Chat**. In `WEITERMACHEN.md` stand nur die Fassungszeile
*„noch nicht als Paket geschnürt"*. Nachgetragen wurde es am nächsten Morgen
um 06:51 Ortszeit (`ad9dee3f`), nach dem Abschalten.

**Der Unterschied zum Fall vom 13.10.** (Nachtrag in
[[abschalten-ist-ein-termin]]): damals war der Einstieg **veraltet**, hier
existierte er gar nicht. Beide Male fiel es nicht mir auf, sondern ihm, und
beide Male durch dieselbe Frage.

**How to apply, zusätzlich:**

- **Jede nummerierte Reihenfolge, die ich im Chat schreibe („erst 1., dann
  2."), gehört vorher in `WEITERMACHEN.md`.** Der Chat bekommt den Verweis,
  nicht die Liste. Wenn es sich nicht lohnt, es in die Datei zu schreiben,
  lohnt es sich auch nicht, es in den Chat zu schreiben.
- **Die Antwort auf „steht es in X?" wird gelesen, nicht erinnert** —
  `grep` auf die Datei, bevor ich „ja" sage.

**Nachtrag 25.10.2026 — Vereinbarung schlägt Ablaufregel.** Gregor sagte um 18:30 MEZ *„e-132: ich teste nur bis schritt 4. schritt 5 geht nicht."*; ich notierte es nur im Gedächtnis und schob die Berichtigung von TESTPLAN M1 „auf den nächsten Zweig", um den laufenden LEKTOR nicht wieder fällig zu machen. Gregor zweimal: *„immer noch nicht korrigiert"* und *„haben wir ja so vereinbart - warum ist es nicht drin?"*. **How to apply:** Eine Vereinbarung mit Gregor wird SOFORT in die Datei geschrieben, die sie betrifft — auch wenn danach ein LEKTOR-Lauf mehr nötig ist. Die Regel „Formfunde in den nächsten Zweig" gilt nur für Funde der Agenten, nie für Gregors Absprachen.

**Berichtigung und Ergänzung (CHRONIST, 25.10.2026 abends, Zeiten MEZ).** Gregors Satz fiel um 18:30:00, nicht „~18:40". Die Zeit oben ist berichtigt. Seine erste Beschwerde um 19:06:54 verlinkte TESTPLAN **M3** (E-125). Der M1-Link kam erst um 19:07:10. Ob auch M3 gemeint war, habe ich nicht zurückgefragt. Vermutung: Er hat den falschen Link erwischt. Den Aufschub hat **meine eigene Übergabenotiz festgeschrieben**: `stand-25-10-2026-abend.md` (18:30) führt TESTPLAN M1 unter „Als Naechstes (naechster Zweig)". Eine Notiz, die eine Vereinbarung auf später legt, hat sie nicht gesichert. Sie hat den Aufschub nur dauerhaft gemacht. Die Ablaufregel dahinter („Form-Funde in den nächsten Zweig") war nie mit Gregor vereinbart: [[einschraenkung-im-pr-ist-kein-ja]].
