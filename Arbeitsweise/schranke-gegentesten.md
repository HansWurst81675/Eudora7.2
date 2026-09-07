---
name: schranke-gegentesten
description: Jede neue Schranke gegen den echten Fehler fahren und gegen den erlaubten Fall; eine stumme Pruefung und ein Fehlalarm sind derselbe Schaden
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:29:11.413Z
---

# Eine Schranke, die ich nicht gegen den echten Fehler gefahren habe, ist keine

Am 07.09.2026 habe ich `tools/doku-pruefen.pl` um vier Prüfungen erweitert.
Beim Gegentest — künstlich einen Fehler einbauen und sehen, ob es anschlägt —
**blieben zwei von drei Prüfungen stumm**, und eine schlug bei etwas an, was
richtig war.

| Fall | was passierte |
|---|---|
| veraltete Paketnummer | Prüfung arbeitete zeilenweise, der Satz „Die Paketnummer … lautet **1.0.21**" ging über zwei Zeilen — stumm |
| Testwert 1.0.19 | steht zu Recht in `PAKETE.md`; **mein Test** war falsch, nicht die Schranke |
| Verweise `PLAN.md`/`INVENTAR.md` | beide liegen in `Eudora71/OTShim/` und verweisen zu Recht relativ aufeinander; das Werkzeug löste gegen die **Repo-Wurzel** auf — Fehlalarm |
| Zeitdokumente | drei Dateien datieren sich im Kopf selbst und dürfen alte Zahlen nennen — als Mangel gemeldet |

Zwei stumme Prüfungen und zwei Fehlalarme in einem Werkzeug, das gerade als
Antwort auf einen wiederholten Fehler entstand.

**Warum:** Beide Ausgänge kosten dasselbe. Eine stumme Prüfung erzeugt
**falsche Sicherheit** — genau die Rolle, in der Gregor mir nicht traut
(*„geprüft, nichts gefunden"* ist schlimmer als eine offene Lücke). Ein
Fehlalarm zerstört die Schranke auf andere Weise: *eine Schranke, die zweimal
umsonst warnt, wird beim dritten Mal nicht mehr geglaubt* — und in dieser
Sitzung ist genau das passiert, dreimal an einem Tag (`bauen.ps1` mit
EuLang/msvcr71, `gesichert.pl` mit „36 Commits nirgends gepusht", die
Zeilennummern in `pruefe-fensterbau.pl`).

**Wie anwenden — für jede neue oder geänderte Prüfung, vor dem Commit:**

1. **Gegentest positiv:** den echten Fehler künstlich einbauen (in eine Kopie
   oder mit `git stash` danach), die Schranke laufen lassen, den **Text der
   Meldung** lesen. Kein Anschlag heißt: die Prüfung ist unfertig, nicht der
   Baum sauber.
2. **Gegentest negativ:** den erlaubten Fall vorlegen, der dem Fehler am
   nächsten kommt — den relativen Verweis, das datierte Zeitdokument, den
   Wert, der zu Recht alt ist. Schlägt es an, ist der Fehler in der Schranke.
3. **Bezugsrahmen prüfen.** Der häufigste Fehlalarm entsteht aus dem falschen
   Bezug: ein Verweis wird gegen das **Verzeichnis der Datei** aufgelöst, nicht
   gegen die Repo-Wurzel; eine Zahl gilt für **das Datum im Kopf der Datei**,
   nicht für heute; `pruefe-bytes.pl` liest den **Index**, nicht den
   Arbeitsbaum.
4. **Zeilenweise ist eine Annahme.** Ein Satz in einer MD-Datei umbricht. Was
   über Zeilengrenzen stehen kann, wird auf dem ganzen Text geprüft
   (`perl -0777`), nicht je Zeile.
5. **Ein falscher Test wird als solcher benannt.** Schlägt der Gegentest fehl,
   ist erst zu entscheiden, ob die Schranke oder der Test falsch war — und das
   Ergebnis gehört in die Commit-Nachricht, nicht nur in den Kopf.

Siehe [[fehlerklassen-abstellen]], [[lehren-anwenden-nicht-nur-schreiben]],
[[tests-vor-jedem-commit-laufen-lassen]] und [[pruefen-statt-vermuten]].
