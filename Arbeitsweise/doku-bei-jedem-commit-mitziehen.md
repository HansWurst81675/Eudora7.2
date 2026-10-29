---
name: doku-bei-jedem-commit-mitziehen
description: "README.md und PORTIERUNG.md gehoeren in denselben Commit wie die Aenderung, nicht nachtraeglich auf Zuruf"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2dc0ce9e-d597-4bea-8a46-cb21a63838b0
  modified: 2026-10-29T20:37:54.108Z
---

Schranke: tools/doku-pruefen.pl (pre-commit, pre-push)

Wenn in diesem Repo ein Arbeitspaket fertig ist, gehoert die Dokumentation in
**denselben Commit** wie der Code. Konkret bei jedem Commit pruefen:

- **README.md** — Abschnitt "Stand" und die Tabelle "Offene Themen". Erledigte
  Zeilen auf `**erledigt**` umstellen, neu entstandene Themen als Zeile ergaenzen.
- **PORTIERUNG.md** — Abschnitte "Kurzfassung", "Was gebaut wird" und
  "Naechster Schritt". Ein abgearbeiteter "Naechster Schritt" muss weichen.
- **Commit-Nachricht**: Am Anfang eine konkrete Liste, WAS geaendert wurde -
  Datei fuer Datei, mit NEU/MOD und einer Zeile, was darin passiert ist. Erst
  danach die inhaltliche Begruendung. Gregor hat das am 28.08.2026 ausdruecklich
  verlangt: "schreib auch in die commit messages, was jeweils geaendert wurde."
- Neue Fremdbestandteile (z. B. `Eudora71/OpenSSL3`) unter "Ergaenzungen
  gegenueber der CHM-Freigabe" in der README eintragen.

**Die Doku-Arbeit selbst gehoert delegiert.** Gregors Vorgabe vom 28.08.2026:
"wieso du? pruefer und lektor sollen es erledigen!" Also nicht selbst am
Fliesstext feilen, sondern PRUEFER (prueft gegen den Repo-Zustand, aendert
nichts) und danach LEKTOR (korrigiert, misst jeden Wert neu nach) beauftragen.
Die Trennung ist der Punkt: wer prueft und korrigiert, winkt seine eigenen
Befunde durch. LEKTOR hat PRUEFER am selben Tag fuenfmal widerlegt.
Wenn ich selbst etwas an der Doku aendere - etwa weil es schnell gehen muss -
gilt dasselbe: danach PRUEFER darueber laufen lassen, nicht mich selbst
abnicken.

**Und: Verhaltensaendernde Aenderungen gehoeren geprueft, nicht nur gebaut.**
Dass etwas kompiliert, beweist nichts. Wo eine Aenderung Semantik beruehrt -
Casts, Signaturen, Rueckgabewerte, Puffergroessen, Zeitarithmetik - gehoert ein
eigener Pruefdurchgang dazu, moeglichst durch einen zweiten Agenten (REVISOR),
der die Aenderung nicht selbst gemacht hat. Gregor musste am 28.08.2026 fragen
"wer von denen macht ein review von den commits?" - da lagen bereits vierzehn
ungepruefte Commits vor, darunter 49 mechanisch erzeugte const_cast, die nie
jemand einzeln gelesen hatte.

**Why:** Gregor musste am 28.08.2026 nachfragen ("readme ist auch updated?",
"muss ich dich an alles erinnern?"), weil sechs Commits mit der kompletten
QCSSL/OpenSSL-3.5.8-Arbeit gelandet waren, waehrend README und PORTIERUNG.md
die Umstellung noch als "geplant" bzw. "naechster Schritt" fuehrten. Die Doku
ist hier kein Beiwerk: sie ist der Uebergabestand zwischen langen Sitzungen.

**How to apply:** Nicht auf Zuruf warten und nicht ans Sitzungsende schieben.
Zum Commit-Ablauf aus [[commit-auf-extra-branch-und-pushen]] gehoert der
Doku-Abgleich als fester Schritt dazu, bevor `git commit` laeuft.

## Nachtrag 29.10.2026 (CHRONIST): der CHANGELOG, zwei Monate nach „muss ich dich an alles erinnern?“

Gregor am 29.10.2026 um 08:31:57 MEZ, als Einwurf: *„alle bisherigen änderungen udnd fixes sollten auch im changelog drin stehen.“*

Gemessen an den 23 Commits des Zweigs `e166-junk_message_fix` (`git log aef8f880^1..aef8f880^2`, je Commit `git show -- CHANGELOG.md`):

- **Die Behebung von E-166** kam am 28.10. um 15:06 (`249e4f95`) in den Quelltext. Im Abschnitt *„Im Quellstand, noch in keinem Paket“* stand sie erst am 29.10. um 07:25 (`1e54773d`), nachdem LEKTOR-90 es angemahnt hatte (meine Meldung am 28.10. um 15:44: *„fehlt E-166 im CHANGELOG und in der README“*), also 16 Stunden später.
- **Sieben Commits berührten den CHANGELOG.** Vier davon änderten nur die Befundtabelle, die `offene-befunde.pl -schreiben` erzeugt. Die drei übrigen schrieben oder berichtigten nur die E-166-Zeile.
- **Nicht im CHANGELOG bis zum Merge:** die neue `Doku/FAQ.md` (`98fb9822`, `01f583db`), die Änderung an `tools/pruefe-startwege.pl` und `tools/pruefstand-lauf.ps1` (`1e54773d`), die berichtigten Release-Texte auf GitHub, E-168 als Eintrag (nur in der Tabelle).

Nachgetragen wurde alles um 08:51 auf dem nächsten Zweig (`f7ca0753`), 20 Minuten nach Gregors Satz. Warum es nicht in den PR kam: [[einschraenkung-im-pr-ist-kein-ja]], Nachtrag 29.10.

**Why, zusätzlich:** Die Schranke dieser Lehre (`doku-pruefen.pl`) prüft Querverweise und Versionsnummern, nicht, ob ein Commit, der eine Datei unter `Doku/`, `tools/` oder `Eudora71/` anlegt oder ändert, eine Zeile im CHANGELOG mitbringt. Die erzeugte Befundtabelle sieht aus wie Pflege und ist keine.

**How to apply, zusätzlich:**
- Ein Commit mit neuer Anwenderdatei (`Doku/*`), einer Behebung oder einer geänderten Schranke bringt seine Zeile unter *„Im Quellstand, noch in keinem Paket“* mit. Ein LEKTOR-Fund „fehlt im CHANGELOG“ ist ein Zeichen, dass das zu spät kam.
- Vorschlag für die Schranke (nicht gebaut): `pruefe-changelog-zuwachs.pl` im `pre-commit` weist ab, wenn der Commit unter `Eudora71/` eine Quelldatei oder unter `Doku/` eine Datei ändert und `CHANGELOG.md` im selben Commit außerhalb der erzeugten Tabelle keine Zeile gewinnt. Gegenprobe: `98fb9822` (FAQ neu, kein CHANGELOG) muss abgewiesen werden, `1e54773d` muss durchgehen.

## Nachtrag 29.10.2026 abends (CHRONIST): zwölf Stunden später, dieselbe Lücke

Gregor am 29.10.2026 um 21:01:50 MEZ, als Einwurf: *„wir haben auch eine kaputte tabelle gefixt!“*

Gemessen: `beb3fc98` (19:41) machte aus der Aufzählung in `Intern/EINSTELLUNGEN.md` zwei Tabellen und änderte nur diese Datei. `6dc43e4d` (19:34, E-166 bestanden) änderte nur den TESTPLAN. Den CHANGELOG zogen erst `26383220` (21:03) und `159d3955` (21:05) nach, nach Gregors Satz. Der Vorschlag `pruefe-changelog-zuwachs.pl` vom Morgen (oben) ist nicht gebaut. Das ist das zweite Auftreten an einem Tag, und nach [[fehlerklassen-abstellen]] heißt das: Werkzeug bauen, nicht noch einmal nachtragen. Die Gegenprobe oben bekommt einen Fall dazu: `beb3fc98` (Anwender-sichtbare Doku geändert, kein CHANGELOG) muss abgewiesen werden. Dazu gehört `Intern/EINSTELLUNGEN.md` in den Umfang, nicht nur `Doku/`.
