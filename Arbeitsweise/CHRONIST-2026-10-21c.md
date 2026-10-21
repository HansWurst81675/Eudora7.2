---
name: chronist-2026-10-21c
description: "CHRONIST-Lauf 21.10.2026 abends (Issue 102, Release 1.0.120, Register fuer Meldungen von aussen): zwei neue Lehren mit Schranken - tor-gehoert-zum-schritt und verweis-erst-nach-dem-merge (pruefe-aussenverweise.pl); vier Nachtraege; zwei weitere Werkzeuge aus eigenen Funden: pruefe-haken-aktuell.pl und die Sackgasse in pruefe-branch.pl"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-21T20:40:00.000Z
---

Schranke: keine — dies ist der Bericht eines CHRONIST-Laufs, keine Lehre. Jede neue oder ergänzte Lehre trägt ihre eigene Schranke-Zeile.

# CHRONIST, dritter Lauf vom 21.10.2026 (Issue 102, Release 1.0.120)

## Quelle

Der Gesprächsverlauf stand wieder nicht zur Verfügung. Ausgewertet wurde:

| Quelle | Umfang |
|---|---|
| Auftrag des Aufrufers | drei benannte Vorgänge, jeder mit Zeitangabe und Zitat |
| `git log --first-parent main`, `git log --diff-filter=A` | die Minutenfolge des Abends |
| `Releases/ISSUE-102-ANTWORT.md`, `-ABSCHLUSS.md` | der abgeschickte Wortlaut, Zeile 14 und Zeile 88 |
| `tools/RELEASES.md` | Zeile 49: v1.0.120 um 21:07:37 veröffentlicht |
| `tools/paket-bereit.pl`, `release-veroeffentlichen.ps1`, `gesichert.pl`, `pruefe-branch.pl`, `hooks-einrichten.sh`, `commit-bereit.pl` | die Werkzeuge selbst, als Quelltext |
| `.git/hooks/pre-commit` im gemeinsamen git-Verzeichnis | 22313 Bytes, **vom 20.10.2026 12:55** |
| die drei anderen Arbeitsbäume | live nachgemessen, nicht aus der Erinnerung |

Die ergiebigste Quelle war diesmal der **laufende Zustand**: zwei der drei
Vorgänge ließen sich im Moment des Lesens noch einmal auslösen.

## Ergebnis

| Kandidat | am Bestand geprüft | Lehre | Schranke |
|---|---|---|---|
| **1. Falsches Tor** — `paket-bereit.pl` statt `release-veroeffentlichen.ps1` | **bestätigt.** `paket-bereit.pl` liest seine Liste aus `paket-bauen.ps1`, ist also die Schranke vor dem **Bauen**; `tools/WERKZEUGE.md` Zeile 123 nennt `release-veroeffentlichen.ps1` *„der einzige erlaubte Weg zu einem GitHub-Release"*. Keine der beiden Nachbarlehren deckt den Moment ab: `werkzeug-vor-eigenbau` fragt vor dem **Eigenbau** (hier wurde nichts gebaut), `bestand-vor-neuer-suche` hängt an `BEFUNDE.md`. Folgenlos blieb es nicht für die Zeit, wohl aber für das Ergebnis: v1.0.120 steht um 21:07:37 in `tools/RELEASES.md`, ist also am Ende durch das richtige Tor gegangen | **neu:** [tor-gehoert-zum-schritt](tor-gehoert-zum-schritt.md) | **gebaut:** `paket-bereit.pl` nennt seinen Umfang jetzt in **beiden** Ausgaben und nennt im roten Fall das Tor des Nachbarschritts. Gegenprobe: beide Ausgabewege gefahren |
| **2. Toter Verweis im öffentlichen Beitrag, zum zweiten Mal** | **bestätigt, auf die Minute.** `f0d6ef73` legt `MELDUNGEN-VON-AUSSEN.md` um 21:16:19 **auf dem Zweig** an; `e14bcb3f` merged PR 128 um **21:36:59**; der Beitrag ging um ~21:33 hinaus (`dbf99e78`, 21:33:59). Dazwischen 404. Die Falle stand in `Releases/ISSUE-102-ANTWORT.md` Zeile 14–16 wörtlich: *„Vorher zeigen alle vier Verweise ins Leere"* | **neu:** [verweis-erst-nach-dem-merge](verweis-erst-nach-dem-merge.md) | **gebaut:** `tools/pruefe-aussenverweise.pl`, `pre-commit` Schritt 1e (meldend). `--selbsttest` **16 Fälle**; `--stand 80b472aa` weist `ISSUE-102-ABSCHLUSS.md` ab, derselbe Lauf gegen `origin/main` von heute nicht; Bestand 272 MDs, 8 eigene Verweise, 0 tot |
| **3. Fehlalarm in `gesichert.pl`** | **bestätigt und live nachgestellt.** Im PRÜFER-Baum lagen beim Nachmessen 6 Dateien in `git status`; alle 6 hatten den **gleichen Blob-Hash** wie `origin/main`, der Zweig hing 21 Commits zurück. Der ursprünglich gemeldete Stand (11 Dateien, davon 7 DLLs mit 7–8 Byte Unterschied im PE-Zeitstempel) ist damit dieselbe Lage in größer | [schranke-gegentesten](schranke-gegentesten.md), **Nachtrag** | **gebaut:** `was_ist_wirklich_offen()` hält jede Datei gegen `origin/main` **und** das eigene Gegenstück. `--selbsttest` **9 Fälle** in einem Wegwerf-Repo, beide Richtungen |
| **4. (eigener Fund) Der installierte Haken ist vom Vortag** | **bestätigt, und schlimmer als gedacht.** 40 Schranken im Quelltext, 36 im installierten `pre-commit`: **vier** fehlen, nicht drei. Die vierte ist `pruefe-auspacken.pl` vom 20.10. Der Bericht vom Mittag suchte von Hand nach drei Namen und fand drei | [schranke-gehoert-in-den-haken](schranke-gehoert-in-den-haken.md) und [pruefumfang-nicht-von-hand](pruefumfang-nicht-von-hand.md), **Nachträge** | **gebaut:** `tools/pruefe-haken-aktuell.pl`, aufgerufen aus `commit-bereit.pl`. `--selbsttest` **9 Fälle** |
| **5. (eigener Fund) Eine Schranke wies ihren eigenen Rat ab** | **bestätigt, beim ersten Commit dieses Laufs.** `pruefe-branch.pl` wies den Commit ab mit dem Rat *„git push -u origin wt/…"*, und `pre-push` wies genau diesen Push mit derselben Meldung ab. Einziger Ausweg: `--no-verify` — und damit fallen alle anderen Schranken desselben Hakens mit aus | [arbeitsbaum-braucht-eigenes-gegenstueck](arbeitsbaum-braucht-eigenes-gegenstueck.md), **Nachtrag** | **gebaut:** `--streng` lässt den Push durch, der das fehlende `origin/wt/<name>` anlegt; existiert es schon, lautet der Rat `git branch --set-upstream-to`. Gegenprobe: Commit-Lauf Rückgabe 1, `--streng`-Lauf 0, Push danach **ohne** `--no-verify` |

## Was aus den drei Vorgängen **keine** eigene Lehre wurde

**Der Fehlalarm (Nr. 3) ist ein Nachtrag, keine Lehre.** Die Regel steht in
[[schranke-gegentesten]] seit dem 07.09.2026 vollständig da — *„eine stumme
Prüfung und ein Fehlalarm sind derselbe Schaden"* —, und sie steht sogar
**zweimal im Quelltext von `gesichert.pl` selbst**, für die ungepushten
Commits (06.09.) und für den unausführbaren Rat (07.09.). Es fehlte nicht die
Einsicht, sondern ihre Anwendung auf den Zähler ganz oben. Eine zweite Lehre
mit demselben Inhalt hätte die erste verdünnt; was fehlte, war die Messung —
und die steht jetzt als `--selbsttest` im Werkzeug.

**Der stehengebliebene Haken (Nr. 4) ebenfalls nicht.** `schranke-gehoert-in-
den-haken` trägt seit dem 12.10. sogar schon den Befehl, der es gezeigt
hätte. Dass er zum dritten Mal nicht gelaufen ist, belegt nicht eine fehlende
Lehre, sondern ein fehlendes **Werkzeug**: ein `grep` nach einem Namen, den
man selbst nennen muss, prüft die eigene Erinnerung.

## Was dieser Lauf selbst falsch gemacht hat

**Der erste Commit scheiterte, und der Ausweg wäre `--no-verify` gewesen.**
Statt ihn zu nehmen, wurde die Schranke berichtigt und der Commit danach
regulär gefahren — das war richtig, kostete aber den ersten Anlauf. Der
Reflex, `--no-verify` zu nehmen, ist genau der, der am 18.09. aus
`release-pruefen.pl` ein `|| true` gemacht hat.

**Der Zweig dieses Laufs verfolgte `origin/main`.** Das war schon beim
Anlegen falsch ([[arbeitsbaum-braucht-eigenes-gegenstueck]]) und ist im
Auftrag so übergeben worden. Richtiggestellt mit `git push -u`.

## Offen, nicht Sache des CHRONIST

1. **`sh tools/hooks-einrichten.sh` im Hauptbaum** — jetzt mit fünf
   fehlenden Schranken (`pruefe-aussenverweise.pl` ist dazugekommen).
   Derselbe Punkt steht in den Berichten vom Vormittag und vom Mittag;
   **zum dritten Mal offen.** Messbar in einem Befehl:
   `perl tools/pruefe-haken-aktuell.pl`.
2. **Der LEKTOR-Arbeitsbaum hält 5 Dateien, die es nirgends auf dem Server
   gibt** (`PORTIERUNG.md`, `Releases/PAKETE.md`, `WEITERMACHEN.md`,
   `ZIEL.md`, `tools/RELEASES.md`) — gemessen um 20:05. Das ist echte,
   ungesicherte Arbeit und kein Fehlalarm; die neue Fassung von
   `gesichert.pl` nennt sie jetzt namentlich.
3. **`tools/WERKZEUGE.md` trägt im Kopf weiter den Stand *„zuletzt geprüft
   gegen 7.2.0.70 … der Quellstand ist inzwischen 7.2.0.110"*.** Der
   Quellstand ist 7.2.0.120. Dieselbe Zeile stand schon im Bericht vom
   Mittag offen; sie gehört dem LEKTOR, der parallel läuft, und wurde
   deshalb nicht angefasst.
4. **`rollen-faellig.pl` rechnet Dateien unter `Eudora71/Bin/Release/` zum
   Bereich des CHRONIST.** Im Lauf dieses Abends meldete es *„CHRONIST ist
   fällig: … `DirServ.dll`, `EudoraBk.dll`, `ISock.dll` und 8 weitere"*. Der
   Bereich des CHRONIST ist `Arbeitsweise/*.md`. Das ist ein Fehlalarm
   derselben Art wie Nr. 3 — gemeldet, nicht behoben, weil es den Umfang
   aller drei Rollen festlegt.
5. **Der `PreToolUse`-Haken** auf Befehle, die `Eudora.exe` starten, ohne
   `testlauf.ps1` zu nennen, bleibt offen (dritter Bericht in Folge). Er
   ändert Gregors `settings.json` und gehört ihm vorgelegt.
