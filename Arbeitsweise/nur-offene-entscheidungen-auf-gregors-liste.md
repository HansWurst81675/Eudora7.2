---
name: nur-offene-entscheidungen-auf-gregors-liste
description: "Auf Gregors Liste kommt ein Punkt nur, wenn ein Satz IHN nennt und die Entscheidung noch offen ist - sonst ist es meine Arbeit"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-22T20:23:14.467Z
---

Ein Befund kommt nur dann auf Gregors Liste, wenn ein Satz darin **ihn
namentlich nennt** *und* die Entscheidung **noch offen** ist. Steht dort, dass
er bereits entschieden hat, ist es Arbeit — meine.

**Why:** Am 22.10.2026 habe ich 21 Befunde durchsortiert und drei davon als
„wartet auf Gregor" gemeldet, die auf niemanden warteten:

* **E-125** — dort stand wörtlich *„Gregors Entscheidung **B** ist noch nicht
  gebaut"*. Die Entscheidung war längst gefallen; offen war die Arbeit, und die
  Stelle stand sogar daneben (`CTocDoc::Xfer`, `tocdoc.cpp:2950`).
* **E-128** — *„die Entscheidung über den **eigenen** Vorschlag"*: mein
  Vorschlag, nicht seiner. Eine HTML-Datei als `.txt` zu speichern ist falsch,
  da gibt es nichts abzuwägen.
* **E-124** — wartet nicht auf ihn: der Vorgang bei Microsoft ist seit dem 22.10.2026 **abgewiesen** (zu viele Dateien im Upload), der nächste Handgriff ist unserer.

Seine Frage darauf: *„willst du mich beschäftigen mit dingen, die bereits gefixt
oder entschieden sind? warum?"*

Die Ursache war beide Male dieselbe wie bei der Fehleinstufung von E-64/E-72 am
selben Tag: **nach einem Stichwort einsortiert statt den Satz zu lesen.**
Sortieren nach Wort geht schnell, Lesen dauert. Der Schaden ist hier aber
größer als eine falsche Zeile — ich schiebe ihm Arbeit zu, die meine ist, und
er muss sie zurückschieben.

**How to apply:** Bevor ein Punkt auf seine Liste geht, den Satz ganz lesen und
drei Fragen beantworten: Wer entscheidet? Ist die Entscheidung gefallen? Was
genau fehlt noch? Wenn die Antwort „er hat schon entschieden" lautet, gehört der
Punkt in meine Arbeitsliste, mit der Fundstelle aus dem Befund. Verwandt:
[[ausreisser-ist-der-befund]], [[kuerzel-im-chat-uebersetzen]].

Schranke: keine - der Fehler entsteht beim Sortieren im Gespraech, nicht in einer Datei. Es gibt kein Artefakt, gegen das sich mechanisch pruefen liesse, ob ich einen Punkt zu Recht auf Gregors Liste gesetzt habe. Geprueft wird er dort, wo er auffaellt: wenn Gregor zurueckfragt.

## Nachtrag 24./25.10.2026 (CHRONIST): beantwortete Fragen ein zweites Mal gestellt

Gemessen, Zeiten MESZ. Am 24.10. um 13:27–13:29 beantwortete Gregor die fünf Fragen aus LEKTOR-55 (*„1. ok"*, *„2. e-116 ok"*, *„3. e-113 ok"*, *„e-142: hinweis in readme + FAQ: erst prüfen, dann lsöchen."*). Ich habe jede Antwort sofort in `stand-23-10-2026-spaet.md` angehängt. Nach dem VM-Absturz, in der neuen Sitzung um 22:26, legte ich ihm *„Die Fragen aus LEKTOR-55 … fünf Fragen, die nur Sie entscheiden können"* noch einmal vor. Gregor um 22:30: *„zu 3: e-113 muß ich nachlesen, weiß ich gerade nicht … zu 5: muß nachlesen, was E-142 ist"*, um 22:35 *„was haben wir zu E-142 vereinbart? warum fragst du dann nach?"*, um 22:37 *„e-142 stimmt nicht, was du sagst"*.

**Why:** Die Antworten lagen in einer **Übergabenotiz**, die Fragen im **LEKTOR-Bericht**. Wer die Fragen las, sah sie dort offen. Der Ort der Antwort war nicht der Ort der Frage. Seit dem 25.10. entstehen dafür eigene Dateien `entscheidung-*.md` (E-148, Logzeile) — das ist die richtige Richtung.

**How to apply, zusätzlich:** Eine Antwort Gregors auf eine Frage aus einem Rollenbericht wird **neben die Frage** geschrieben (in den Bericht oder in die Befundzeile) und als `entscheidung-*.md` festgehalten; nicht nur an eine Übergabenotiz gehängt. Bevor ich eine Frageliste vorlege, suche ich jede Kennung in `memory/` **ohne** `head` ([[gekuerzte-ausgabe-ist-kein-ergebnis]]).

**Und noch einmal am 25.10. um 18:10 MEZ**, während dieses CHRONIST-Laufs: *„zu 7: v.7.2.1.<n>, also z.b. 7.2.1.123. haben wir schon mehrfach besprochen, mit beispielen."* Gemessen, wo es schon stand: 23.10. 22:52 MESZ *„release wird dann heißen: 7.2.1.123 (bzw. die laufende build nummer …)"*; 24.10. 13:28 von mir in `stand-23-10-2026-spaet.md` notiert (*„Marke `v7.2.1.123`"*); 24.10. 22:30 *„zu 1: die hintere nummer ergibt sich aus dem aktuellen build"*. Trotzdem führte Commit `2222420d` (24.10. 22:34) die Marke in `WEITERMACHEN.md` unter *„Offen an Gregor"*, und von dort kam sie in die Zusammenfassung der Kompaktierung (*„Open decision for Gregor only: GitHub tag naming"*) und zurück auf seine Liste. Eine einmal falsch als offen eingetragene Frage überlebt jede Übergabe. Der Hauptagent hat daraufhin `entscheidung-marke-v7-2-1.md` angelegt.

## Nachtrag 28.10.2026 (CHRONIST): eine beantwortete Frage im Stand-Vermerk, eine entschiedene an der Befundzeile

Zeiten MEZ, gemessen an Transkript `72be6093…` und an Commits.

**1. E-166, die Frage zu „22:46“.** Gregor hat sie am 27.10. um 17:46:53 beantwortet (Hergang bei [[rueckfrage-ist-keine-messung]], Nachtrag 28.10.). Commit `0fa1d5e6` vom selben Abend berichtigte den Befund. Im Stand-Vermerk ließ er aber stehen: *„Offene Frage an Gregor zu E-166: zwischen 22:46 und 23:00 neu ausgepackt?“* (belegt: `git show 0fa1d5e6:Arbeitsweise/stand-27-10-2026.md`, Zeile 20). Am 28.10. wurde dieser Vermerk um 10:46:43 als Erstes gelesen. Gregor um 10:48:17: *„ich habe die frage bereits beantwortet.“* Worauf sich der Satz bezog, ist nicht gemessen. Von mir kam in den ersten zwei Minuten der Sitzung keine Frage. Die einzige offene Frage in dem, was gelesen wurde, war diese.

**2. E-139.** Gregor hatte am 25.10. entschieden: E-139 kommt in die README und wird nach 7.2.1 behoben ([[entscheidung-vor-7-2-1-beheben]]). In der Befundzeile E-139 stand davon nichts, sie hieß weiter *„offen, am 23.10.2026 … gefunden“* (belegt an `978a852a~1`). Gregor fragte um 10:53:08: *„wo steht es auf unserer toDo liste, daß die meldung beim mail schreiben nur 1x kommt, daß keine rechtschreibung verfügbar ist?“* Darauf kam keine Antwort, denn die Nachricht um 10:54:36 behandelte nur seinen zweiten Einwurf (den Start). Gregor fand es selbst (10:56:45, *„habe ich gefunden“*). Um 11:15:56 legte ich ihm die Entscheidung trotzdem noch einmal vor: *„Offen bleibt deine Entscheidung zu E-139 … weiter nur in der README, oder doch vor 7.2.1 beheben?“* Gregor um 11:20:42: *„nein, erst danach“*. Das ist der Mechanismus vom 24./25.10. oben: Die Antwort lag in einer `entscheidung-*.md`, die Frage stand an der Befundzeile, und dort fehlte die Antwort.

**How to apply, zusätzlich:**
- Wer eine Antwort Gregors einträgt, sucht im selben Commit **jede** Stelle, an der die Frage noch offen steht, auch die Stand-Vermerke: `grep -rn "<Kennung>" memory/ Arbeitsweise/ Intern/`, ohne `head` ([[doku-parallel-nicht-hinterher]]).
- Jeder Einwurf Gregors bekommt eine Antwort, auch wenn ein zweiter dringlicher ist. Zwei Fragen bekommen zwei Antworten, in einer Nachricht.
- Eine Entscheidung aus `entscheidung-*.md` steht auch in der Befundzeile, mit Datum und Gregors Wortlaut.

## Nachtrag 30.10.2026 (CHRONIST): „brauchst mich nicht dazu?“

Zeiten MEZ, Transkript `c21b8f54…`. Am 29.10. um 22:18:29 hatte Gregor beide Zweignamen bestätigt (*„ja, beide namen ok“*). Der Plan für `weitermachen-aufraeumen` stand seit 21:12 am 29.10. fest ([[eine-stelle-dann-verlinken]]) und um 22:28:56 noch einmal als *„Für morgen“*. Am 30.10. um 07:05:24 endete die Antwort auf *„was steht als nächstes auf dem programm?“* trotzdem mit *„Soll ich mit Punkt 1 anfangen? Den CHRONIST würde ich parallel … laufen lassen.“* Gregor 07:06:08: *„ich denke, du kannst jetzt deine ganzen hausaufgaben machen und brauchst mich nicht dazu?“*, 07:06:25: *„ja, mit 1 anfangen.“*

Am Vorabend gingen zwei Einwürfe ohne Antwort durch ([[einwurf-ist-ein-messwert]], Nachtrag 30.10.). Bei Gregor kommen also beide Fehler an: Fragen, die er nicht braucht, und keine Antwort auf seine eigenen.

**How to apply, zusätzlich:** Hat Gregor Name und Plan schon bestätigt, wird nicht gefragt, sondern gemeldet: *„Ich fange mit 1 an, Zweig wie gestern bestätigt.“* Gefragt wird nur, was in der Antwort neu ist.
