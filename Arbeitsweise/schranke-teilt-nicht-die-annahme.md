---
name: schranke-teilt-nicht-die-annahme
description: "Eine Schranke, die ihren Umfang aus derselben Annahme nimmt wie das Werkzeug, das sie pruefen soll, prueft nichts"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f193092b-2e64-587f-a070-7e656c44c557
  modified: 2026-10-29T20:37:25.854Z
---

Schranke: keine - sie waere selbst eine. Pruefbar ist nur das Muster: findet GREGOR den Fehler, den meine frische Schranke uebersehen hat, dann teilten beide eine Annahme.

# Die Schranke darf nicht dasselbe glauben wie das Werkzeug

Am 12.10.2026 habe ich `tools/befunde-verlinken.pl` gebaut: es verlinkt jede
Kennung, und **ohne Schalter ist es die Schranke dazu** — Rückgabewert 1,
sobald eine Nennung kein Link ist. Eingehängt in `pre-commit`, `pre-push` und
`paket-bauen.ps1`.

Die Schranke meldete:

> *„Jede Kennung ist ein Link, und jeder Link trifft eine Urteilszeile."*

Zur selben Zeit standen `E-85`, `E-98`, `L-17.1` und `B5.7` unverlinkt in den
Dokumenten. Gefunden hat das **Gregor**, in vier Nachrichten hintereinander.

## Warum sie es nicht finden konnte

Weil sie dieselbe Frage stellt wie das Werkzeug: *„was von dem, was **ich** für
eine Kennung halte, ist noch kein Link?"* Was das Werkzeug nicht als Kennung
erkannte, war für die Schranke auch keine:

| übersehen | weil das Werkzeug glaubte |
|---|---|
| `E-85` in *„Dazu waren **E-85** und E-86"* | nur die erste Nennung je Absatz zähle |
| `E-98` in `**E-98 bis E-101**` | eine Kennung trage den Fettdruck symmetrisch |
| `L-17.1`, `LEKTOR-20`, `P-42` | alle Kennungen stünden in `BEFUNDE.md` |
| `B5.7` | eine Kennung habe einen Bindestrich |

Vier Annahmen, vier blinde Flecken — und die Schranke hat **jede davon
geteilt**, weil sie aus demselben Quelltext kommt. Sie war kein zweites Paar
Augen, sondern dasselbe Auge zweimal.

## Was eine Schranke stattdessen braucht

**Eine Quelle, die das Werkzeug nicht kennt.** Für dieses Werkzeug wäre das:
jede Zeichenkette zählen, die *aussieht* wie eine Kennung — Großbuchstabe,
Ziffern, Bindestrich oder Punkt —, und melden, wie viele davon **weder Link
noch bekannt** sind. Dann hätte dort gestanden: *„603 Nennungen passen auf das
Muster, stehen aber in keinem Verzeichnis"*, und ich hätte nachgesehen.

Allgemein:

1. Der Umfang kommt aus einer **anderen Richtung** als die Umsetzung —
   aus der Datei statt aus dem Modell, aus `git ls-files` statt aus einer
   Liste ([pruefumfang-nicht-von-hand](pruefumfang-nicht-von-hand.md)).
2. Die Schranke meldet, was sie **nicht** einordnen konnte, statt es
   stillschweigend wegzulassen. Ein Rest von 0 ist eine Aussage, ein
   verschwiegener Rest ist keine.
3. *„Nichts gefunden"* und *„nichts zu prüfen"* sind zwei verschiedene
   Meldungen (Befund E-109, Punkt 4: *„ein Freispruch über eine leere Menge"*).

## Die Probe

Wenn **Gregor** einen Fehler findet, den eine frisch gebaute Schranke hätte
fangen sollen, dann ist die erste Frage nicht *„welcher Fall fehlt?"*, sondern:
**welche Annahme teilen Werkzeug und Schranke?** Der fehlende Fall ist immer
nur ein Symptom davon.

## Nachtrag 29.10.2026 (CHRONIST): vier Funde Gregors an einem Tag, alle hinter grünen Prüfungen

Gregor am 29.10.2026 um 10:59:45 MEZ:

> *„warum hat es der lektor nicht gefunden? muß ich hier echt alles selbst machen? kann man sich euch deine truppe nicht mehr verlassen, daß irgendwas richtig funktioniert? überall, wo ich reinschaue, entdecke ich fehler. und ich prüfe es nur punktuell, nicht vollständig.“*

Gemessen an `2dc0ce9e-…jsonl`, `052dc212-…jsonl` und den Commits (MEZ). Jede Zeile ist die Probe oben, und jedes Mal teilte die Prüfung die Annahme:

| Zeit | Gregor fand | Die Prüfung, die grün war | Die geteilte Annahme |
|---|---|---|---|
| 09:39–10:42 | Daten aus seinem Postfach, in sechs Runden ([[gedaechtnis-ist-oeffentlich]]) | Suchläufe mit einer Begriffsliste | Die Liste kam aus demselben Kopf, der die Daten für unbedenklich gehalten hatte |
| 10:56:06 | *„ist hier die tabelle defekt?“* (`Intern/FILTER.md`, Strg+J-Tabelle) | `pruefe-tabellenzeilen.pl` | „Kaputt“ heißt abgebrochene Zeile. Dass Kopf und Daten verschieden viele Spalten haben, kam nicht vor |
| 10:54:59 | fragte nach den Abweichungen vom Original. Ergebnis 10:57:17: die Tabelle stand seit dem 14.09. nirgends, die Verweise darauf liefen im Kreis | LEKTOR-Läufe | Ein Verweis wird geprüft, wenn er ein Link ist. Textverweise („siehe README, Abschnitt X“) folgte niemand |
| 21:01:50, 21:04:25 | *„wir haben auch eine kaputte tabelle gefixt!“*, *„hätte dem lektor auffallen müssen, vielleicht spendierst du ihm bei gelegenheit eine neue brille?“* | LEKTOR-95 (13:28) | Der LEKTOR prüft, ob eine Aussage zum Bestand passt. Ob am Ziel steht, was der Text **ankündigt** (eine Tabelle), prüfte er nicht: Von 11:29 (`0a4d2390`) bis 19:41 (`beb3fc98`) stand dort eine Aufzählung. Der CHANGELOG sagte die ganze Zeit *„Die Tabelle … ist zurück“*, und ab 13:47 (`cf6c3fee`, LEKTOR-95 eingearbeitet) sieben Zeilen tiefer *„Abweichungsliste“* |

Die Hauptsitzung hat das um 10:59:58 selbst richtig benannt: *„Ich habe mich darauf verlassen, dass grüne Schranken und ein Lektor-Lauf ‚richtig‘ bedeuten. Sie bedeuten nur ‚nichts von dem gefunden, wonach sie suchen‘.“* Darauf folgten zwei neue Prüfungen mit Selbsttest und Gegenprobe am echten Fall (`pruefe-tabellenzeilen.pl` mit Spaltenzahl, `pruefe-abschnittsverweise.pl`, Commit `0a4d2390`). Die Spaltenprüfung fand im ersten Lauf einen Nachtrag zu E-87, der in einer Tabellenzelle verschwunden war. Beim Bau der Verweisprüfung lief sie einmal falsch grün, weil die Suchregel über die Befehlszeile beschädigt worden war ([[text-nicht-durch-schichten-schicken]], Fall 34). Der Selbsttest hat es gefunden.

**Was die vierte Zeile lehrt:** Eine neue Prüfung beantwortet die Frage des letzten Fundes. Die Spaltenprüfung aus demselben Commit `0a4d2390` konnte die Aufzählung nicht sehen, denn eine Aufzählung hat keine Spalten. Der Auftrag an LEKTOR-96 (21:07) prüft deshalb die Ankündigung gegen die Form am Ziel. Das ist die Richtung „aus der Datei statt aus dem Modell“ von oben.

**How to apply, zusätzlich:**
- Nach jedem Fund Gregors nicht nur den Fall in die Schranke nehmen, sondern einen Satz aufschreiben: *Welche Annahme hatte die grüne Prüfung?* Steht er nicht da, kommt derselbe Fund in anderer Form wieder.
- Eine Meldung „grün“ an Gregor nennt, wonach gesucht wurde. *„43 Schranken grün“* sagt ihm nichts darüber, was er beim nächsten Hinsehen findet.

## Nachtrag 30.10.2026 (CHRONIST): die Release-Buchführung prüfte fünf Absätze

29.10., 22:22 MEZ. Nach der Veröffentlichung von `v7.2.1.128` meldete `tools/pruefe-release-buchfuehrung.pl` vorher 3 Mängel, nach `321b3599` keinen mehr: *„Geprueft 5 Datei(en), 5 Standaussage(n). Jedes fuehrende Dokument kennt v7.2.1.128 …“* (wörtlich im Bericht LEKTOR-99). LEKTOR-99 fand trotzdem drei Sätze in der Gegenwart, die `v1.0.120` als aktuell ausgaben: `Doku/ANWENDER.md:274-275` (geht nach außen), `Intern/AUFGABEN.md:118`, `Intern/WEITERMACHEN.md:48`. Der LEKTOR schrieb selbst dazu: *„Das Werkzeug prüft nur diese fünf Absätze. Die drei Funde liegen außerhalb davon.“*

**Die Annahme der grünen Prüfung:** Der Stand eines Release steht in den Standaussagen der führenden Dokumente. Das Anwenderhandbuch ist kein führendes Dokument, sagt aber in der Gegenwart, was enthalten ist und was nicht. Am selben Abend fand PRUEFER-65 (K3), dass die neue Spaltenzählung von `pruefe-tabellenzeilen.pl` einen `|` in einer Codespanne anders zählt als GitHub. Dort ist die Annahme, wie GitHub zählt, aus dem Gedächtnis und nicht aus der Spezifikation.

**Vorschlag (nicht gebaut):** `pruefe-release-buchfuehrung.pl` sucht zusätzlich in **allen** `.md` außerhalb von Zitaten und Protokollzeilen nach einer älteren Fassung neben einem Gegenwartswort (*„ist“, „noch nicht“, „draußen“, „seit“*). Gegenprobe: `321b3599` wird wegen `Doku/ANWENDER.md:274` abgewiesen, `4fff285f` geht durch.
