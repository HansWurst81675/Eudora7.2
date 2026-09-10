---
name: schranke-gegentesten
description: Jede neue Schranke gegen den echten Fehler fahren und gegen den erlaubten Fall; eine stumme Pruefung und ein Fehlalarm sind derselbe Schaden
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T07:57:11.327Z
---

Schranke: keine - keine Prüfung verlangt zu jeder Schranke einen Gegentest; gemessen am 08.09.2026 haben 3 von 10 Schranken eine Testsammlung unter tools/*-tests.pl

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

## Nachtrag 08.09.2026: „irgendeiner ist rot" ist nicht dasselbe wie „alle"

`tools/pruefe-beenden.pl` hatte vier Gegentests. Beim ersten Lauf schlugen
**GT1 und GT4** an, GT2 und GT3 blieben stumm. Hätte ich nur auf „der Gegentest
greift" geschaut, wäre die Schranke mit **zwei Löchern** in den Commit gegangen
— und sie ist die Schranke, die Gregors wichtigstes Kriterium hält.

Was danach richtig lief und Regel bleibt: erst habe ich geprüft, ob meine
**Testmanipulation überhaupt angekommen** ist ([[messung-muss-den-weg-treffen]]),
sie neu angesetzt — und dann waren beide Manipulationen im Baum und die
Schranke schwieg trotzdem. Erst damit war belegt: zwei echte Löcher, nicht zwei
kaputte Tests. Die Ursachen lagen beide in der Schranke
([[schranke-liest-nur-code]]): `WM_CLOSE` steht auch im Protokolltext, und der
`default:`-Bereich endete an der inneren Klammer.

**Damit gilt zusätzlich zu Punkt 1:**

- **Jeder Gegentest wird einzeln gefahren und muss einzeln rot werden.** Eine
  Sammelmeldung „Gegentests schlagen an" ist kein Ergebnis; es gehört eine
  Tabelle mit einer Zeile je Gegentest und dem **Text der Meldung** dazu.
- **Bleibt einer stumm, ist die Reihenfolge:** erst nachmessen, ob die
  Manipulation im Baum steht (`grep` auf die entfernte Zeile), dann entscheiden
  — kaputter Test oder Loch in der Schranke. Nie umgekehrt raten.
- **Eine Schranke ist erst fertig, wenn die Zahl der roten Gegentests gleich der
  Zahl ihrer Prüfungen ist.** Vier Prüfungen, vier Gegentests, vier rote Läufe.

## Nachtrag 10.09.2026: der Gegentest hat einen echten Fehler gefangen — und zwar nicht durch Nachdenken

`tools/mailverzeichnis-uebernehmen.ps1` sollte Gregors ganzes Mailverzeichnis
in die naechste Fassung mitnehmen. Darin stand:

    Copy-Item -LiteralPath (Join-Path $q '*') -Destination $z -Recurse

**Mit `-LiteralPath` nimmt Copy-Item das Sternchen woertlich.** Es gibt keine
Datei dieses Namens, also wurde **nichts** kopiert — kein Fehler, kein
Abbruch, ein sauberer Lauf. Ohne Gegentest waere Gregor mit einem leeren
Mailverzeichnis dagestanden, und das nach dem Vormittag, an dem er schon
einmal schrieb: *"meine inhalte (screenshots) sind in den mails weg."*

Gefunden hat es nicht die Ueberlegung und nicht das Lesen des Skripts,
sondern die **Nachmessung im Skript selbst**: es zaehlt am Ende Quelle gegen
Ziel und meldete *"4 Posten sind im Ziel kleiner"*. Nach der Berichtigung auf
`-Path`: Postfach, `attach` und `Embedded` uebernommen, die Paketvorlage im
Ziel blieb stehen, `CtrlJMapping` 1 -> 2, der Name mit Umlauten unveraendert.

**Damit gehoert zu dieser Lehre ein Punkt, der bisher fehlte, weil sie nur
von *pruefenden* Werkzeugen handelte:**

- **Ein Werkzeug, das etwas *tut*, misst am Ende sein eigenes Ergebnis nach**
  — und zwar an der Groesse, um die es geht (hier: Zahl und Groesse der
  Posten in Quelle und Ziel), nicht an seinem eigenen Rueckgabewert. Ein
  Kopierbefehl, der nichts kopiert, ist erfolgreich; nur der Vergleich
  danach weiss es besser.
- **Die Nachmessung ist billiger als der Gegentest und faengt anderes.** Der
  Gegentest laeuft einmal bei mir; die Nachmessung laeuft **jedes Mal**, auch
  bei Gregor, auch mit Eingaben, die ich nicht vorhergesehen habe. Beide
  gehoeren ins Skript, nicht eins statt des anderen.
- **Was eine Nachmessung taugt, entscheidet ihr Bezug.** Hier: Quelle gegen
  Ziel. Ein `if ($?) { "fertig" }` haette dasselbe Skript gruen gemeldet.

Der Gegentest selbst lief in beide Richtungen und in einem nachgebauten
Verzeichnis, nicht bei Gregor: von 158 Paketdateien wurden 155 entfernt,
waehrend eine geaenderte Datei, eine fremde Datei und eine fremde DLL
stehenblieben — und der Ordner deshalb auch.

Siehe [[fehlerklassen-abstellen]], [[lehren-anwenden-nicht-nur-schreiben]],
[[schranke-liest-nur-code]], [[tests-vor-jedem-commit-laufen-lassen]] und
[[pruefen-statt-vermuten]].
