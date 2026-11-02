---
name: vereinbartes-vor-neuem
description: Was mit Gregor als Voraussetzung vereinbart ist (z. B. Regressionstest-Rueckstand vor 7.2.1.0), kommt vor jedem neuen Thema - nicht erst, wenn er danach fragt
metadata:
  type: feedback
---

Schranke: keine - keine eigene; der Ausloeser ist jede Frage "was als Naechstes?": vorher in Intern/WEITERMACHEN.md und ZIEL.md nachsehen, welche vereinbarte Voraussetzung noch offen ist.

Gregor am 23.10.2026: *"warum fehlen noch regression tests? sollten doch schon längst durch sein! statt neue themen anzugehen."* und *"war anders vereinbart."* Seit dem 22.10.2026 stand in BEFUNDE.md, dass der Rueckstand (50 von 67 kritischen Befunden ohne Test) vor 7.2.1.0 abzuarbeiten ist. Ich habe stattdessen E-116 und einen Versionsvorschlag angefangen.

**Why:** Eine Vereinbarung, die nur als Satz in einem Dokument steht, wird von neuen, sichtbareren Themen verdraengt; Gregor muss dann nachfragen.

**How to apply:** Bevor ich ein neues Thema vorschlage oder einen Zweignamen dafuer erfrage, die offenen vereinbarten Voraussetzungen nennen und zuerst abarbeiten. Siehe [[funktionsbug-vor-buchfuehrung]], [[anweisungen-abarbeiten]].

## Nachtrag 01.11.2026 nachts (CHRONIST): die eigene Ankündigung stand auf Gregors Zettel

Transkript `6f848773…`, Zeiten MEZ, gemessen ([[CHRONIST-2026-11-01e]]).

| Zeit | Was |
|---|---|
| 12:21:24 | Zwischenzeile der Hauptsitzung, die Gregor sieht: *„… ich gehe sie priorisiert an, beginnend mit den Zeichensatzfehlern E-178, E-179 und E-177, gefolgt von weiteren nach Dringlichkeit, und starte jetzt mit E-178.“* Gregor schrieb das auf seinen Zettel. |
| 13:09:17 | E-178 und E-179 im Zweig `e178_bearbeiten_emoji` behoben gemeldet, danach im Testpaket 7.2.1.130 |
| 17:06:13 | Frage nach dem nächsten Zweig (`AskUserQuestion`), drei Optionen: `e184_imap_zusammenfassung (Empfohlen)`, `nach_7_2_1_130`, `filterbericht_out_k2`. **E-177 steht in keiner Option und in keinem Satz**, und die Frage sagt nicht, dass sie von der angekündigten Reihenfolge abweicht. Gregor wählt nach 12 s die Empfehlung. |
| 19:28:30–19:32:52 | Gregor: *„woher kommen die neuen befunde mit e-189 usw.?“*, sein Zettel (zweimal eingefügt), der Satz von 12:21 wörtlich, *„ist es aus dem changelog? wie kamen die dazu?“*, *„oder von hier? WEITERMACHEN.md“* - fünf Nachrichten in vier Minuten, alle als Einwurf |
| 19:32:50 | Antwort: Herkunft je Kennung (E-184 von PRÜFER-71, E-188/E-189 von PRÜFER-75), Abgleich mit dem Zettel, *„Nach dem Paket bin ich von deiner Reihenfolge abgewichen … Das war meine Wahl, nicht deine.“*, Vorschlag `e177_filter_programm`; 19:38:59 von Gregor bestätigt |

**Was zurückfiel:** genau die Regel oben (*„Bevor ich … einen Zweignamen dafür erfrage, die offenen vereinbarten Voraussetzungen nennen“*). Neu sind zwei Umstände:

1. **Die Vereinbarung war meine eigene Ankündigung**, nur in einer Zwischenzeile. In `Intern/WEITERMACHEN.md` stand E-177 am Stand `f3d2dcb9` (letzter `main` vor 17:06) nur als eine Zeile der erzeugten Tabelle, ohne Reihenfolge (gemessen). Der Auslöser dieser Lehre, *„vorher in WEITERMACHEN nachsehen“*, hätte sie nicht gefunden. Gregor hält sich an das, was ich ankündige, auch wenn ich es nirgends ablege.
2. **Eine Auswahl unter meinen Optionen ist kein Ja zur Abweichung.** Gregor konnte nur unter drei Zweigen wählen, die alle die angekündigte Fortsetzung wegließen. Das ist dieselbe Bewegung wie in [[einschraenkung-im-pr-ist-kein-ja]] (Aufschub nur mit seinem Ja zu genau diesem Punkt).

**Gut gelaufen:** Die Antwort um 19:32:50 nannte die Abweichung ohne Ausrede, und die PR-Meldung um 20:32:34 machte es richtig: *„Als Nächstes kommt der Zweig e177_filter_programm, wie auf deinem Zettel … E-193 halte ich für dringender … Sag mir, wenn ich E-193 vorziehen soll.“*

**How to apply, zusätzlich:**
- Was ich als Reihenfolge ankündige, auch in einer Zwischenzeile, gilt als vereinbart, bis Gregor es ändert. Ich trage es im selben Zug als Zeile `Reihenfolge (angekündigt <Datum>):` in `Intern/WEITERMACHEN.md` ein, damit der Auslöser dieser Lehre es findet.
- Eine Frage nach dem nächsten Zweig enthält die angekündigte Fortsetzung immer als Option. Weicht meine Empfehlung ab, steht das im Fragetext: *„Angekündigt war E-177; ich empfehle E-184, weil …“*.

**Schranken-Vorschlag (nicht gebaut):** PreToolUse-Haken auf `AskUserQuestion` mit `header` „Zweigname“: abweisen, wenn weder Frage noch Optionen die erste offene Kennung der Zeile `Reihenfolge` in `Intern/WEITERMACHEN.md` nennen. Gegenprobe: die Frage von 17:06:13 → abweisen (E-177 fehlt); dieselbe Frage mit der Option `e177_filter_programm` → durchlassen; ohne `Reihenfolge`-Zeile → durchlassen.

## Nachtrag 02.11.2026 (CHRONIST): am nächsten Morgen wieder, und die Zeile `Reihenfolge` fehlte

Transkript `25e03584-…jsonl`, Zeiten MEZ, gemessen ([[CHRONIST-2026-11-02]]).

Am Abend des 01.11. hatte Gregor gefragt, ob der Testplan zu E-178 eindeutig ist. Die Antwort war eine Ankündigung: *„Morgen ZUERST …: Abschnitt E-178 (e-178-naechstes) hat drei Unklarheiten“*, danach `e177_filter_programm`. Sie stand **nur in `memory/stand-01-11-2026.md`, Zeile 55**. Deren Indexzeile in `MEMORY.md` sagt *„Abschlussrunde PRUEFER-70/LEKTOR-112, dann PR; AN-1-Frage offen“*. In `Intern/WEITERMACHEN.md` am Stand `99e77aa1` gibt es keine Zeile `Reihenfolge`, und `sitzungsbeginn.pl` zeigt so etwas nicht an.

| Zeit | Was |
|---|---|
| 06:46–07:00 | Gregors Testdateien ausgewertet, drei neue Befunde (richtig: er hatte sie geschickt) |
| 07:00:38 | Frage nach dem Zweig **`e194_speichern_unter`**, also ein neues Thema |
| 07:08:07 | Gregor: *„warum machen wir jetzt e194 branch auf? ist der rest schon fertig?“* |
| 07:12:52 | Der Satz „Morgen ZUERST“ erscheint zum ersten Mal im Transkript, in der Ausgabe eines `git diff` auf den Stand-Vermerk |
| 07:17:37 | *„Unabhängig davon habe ich etwas übersehen: Gestern Abend war vereinbart …“* |
| 07:35:08 | Gregor: *„ok, mach weiter mit E-178 testplan.“* |

**Was zurückfiel:** der Nachtrag vom Vorabend selbst. Sein *„Ich trage es im selben Zug als Zeile `Reihenfolge (angekündigt <Datum>):` in `Intern/WEITERMACHEN.md` ein“* wurde am selben Abend nicht angewandt, keine fünf Stunden nach dem Schreiben ([[lehren-anwenden-nicht-nur-schreiben]]). Gut war: Die Abweichung kam von selbst auf den Tisch, zehn Minuten nach Gregors Frage und ohne Ausrede. Und die Zweigfrage um 07:08:36 benannte den Namen als schlecht gewählt.

**Schranken-Vorschlag (nicht gebaut), ersetzt den vom 01.11.:** `tools/sitzungsbeginn.pl` gibt die Zeilen `Reihenfolge` aus `Intern/WEITERMACHEN.md` aus und dazu jede Zeile mit `ZUERST` aus dem jüngsten `memory/stand-*.md`. Gegenprobe: am Stand vom Morgen des 02.11. → Zeile 55 erscheint; ein Stand-Vermerk ohne `ZUERST` → nichts. Der `AskUserQuestion`-Haken vom 01.11. hätte heute nicht gegriffen, denn die Zweigfrage war eine Textfrage.
