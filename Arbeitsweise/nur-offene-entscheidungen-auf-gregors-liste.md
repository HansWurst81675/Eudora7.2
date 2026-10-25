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
