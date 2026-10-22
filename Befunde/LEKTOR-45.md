# <a id="lektor-45"></a>LEKTOR-45 — Nachlauf vor dem Paket 1.0.114: drei Sätze, die den Stand falsch behaupteten, und eine Liste, die nicht ein drittes Mal durchrutschen soll

Kurzer Nachlauf am 21.10.2026 im Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig
`wt/lektor`, Ausgang `6f707bc5`. Kein voller Durchgang. Anlass: **das Paket
1.0.114 wird gleich geschnürt und soll veröffentlicht werden.** Geprüft wurde
nur, was dabei nach außen geht oder den Stand behauptet.

## Umfang

**Zehn Dateien** gegen den Bestand gehalten:
`Releases/1.0.114/RELEASE-NOTIZEN.md`, `Releases/ISSUE-102-ANTWORT.md`,
`Releases/DEFENDER-FEHLALARM.md`, `Releases/PAKETE.md`, `README.md`,
`CHANGELOG.md`, `WEITERMACHEN.md`, `AUFGABEN.md`, `ZIEL.md`, `TESTPLAN.md`.
Dazu `tools/ZWEIGE.md` (die einzige Datei, die sich seit
[LEKTOR-44](LEKTOR-44.md#lektor-44) geändert hat) und `tools/RELEASES.md`.

**Maßstab von außen** ([Einigkeit ist kein
Beweis](../Arbeitsweise/einigkeit-ist-kein-beweis.md)) — nichts davon aus einem
Dokument des Projekts:

| Quelle | Wert |
|---|---|
| `git tag \| sort -V \| tail -1` | **`v1.0.113`** — **kein** `v1.0.114` |
| `gh release list` | `v1.0.113` ist **Latest** (20.10.2026, 13:01:36 UTC) |
| `ls Releases/*.zip` | nur 1.0.2 und 1.0.30 — **kein** `Eudora72-1.0.114-release.zip` |
| `ls C:\Users\Gregor\Eudora72-*` | 1.0.110, 1.0.111, 1.0.112, 1.0.113 — **kein 1.0.114** |
| `ls Releases/1.0.114/` | **ein** `RELEASE-NOTIZEN.md`, angelegt mit `5f721756` am 20.10.2026 um 21:39:33 |
| `gh pr view 119 / 120` | **beide gemergt** — #119 am 20.10.2026, 19:53:26 UTC; #120 am 21.10.2026, 04:55:35 UTC |
| `git branch -a` | `20261021_alles_was_claude_vergessen_hat` lokal **und** auf `origin`, in `main` enthalten |
| Uhr | 21.10.2026 |

**Werkzeuge vorher:** `doku-pruefen.pl` kein Widerspruch (5 Hinweise *zur
Kenntnis*, alle berechtigt — Rückblicke und Fremdverzeichnisse),
`befunde-verlinken.pl` *Anker vollständig*, `commit-bereit.pl` **32 Schranken,
keine weist ab**. **Nachher** dieselben Werte.

---

## Geprüft, kein Mangel

### <a id="l-45.1"></a>L-45.1 — die neue Zeile in `tools/ZWEIGE.md` hält jeder Gegenprobe stand

Gemessen, Punkt für Punkt:

| Behauptung der Zeile | gemessen |
|---|---|
| Der Zweig `20261021_alles_was_claude_vergessen_hat` existiert | `git branch -a`: lokal **und** `remotes/origin/…` |
| Er ist in `main` | `git branch --contains 34c43204` nennt `main`; PR **#120** gemergt am 21.10.2026, 04:55:35 UTC |
| Datum **21.10.2026** | Commit `34c43204` trägt 21.10.2026, 06:52:58 +0200; der Merge liegt davor am selben Tag |
| Zweck *„der Eintrag in `WEITERMACHEN.md` … und der letzte Commit von [LEKTOR-44](LEKTOR-44.md#lektor-44)"* | PR #120 trägt genau drei Commits und vier Dateien: `WEITERMACHEN.md`, `Befunde/LEKTOR-44.md`, `LEKTORAT.md`, `tools/ZWEIGE.md` |
| Verweis `[LEKTOR-44](LEKTOR-44.md)` | trifft, aus `tools/` heraus richtig aufgelöst |
| Verweis `[Issue #102](…/issues/102)` | vorhanden, 7 Beiträge |

**Zur Stelle in der Tabelle.** Die Zeile steht zwischen `19.10.2026` und
`20.10.2026`, und das sieht falsch aus — ist es aber nicht. Die Tabelle hat
**zwei** Sortierrichtungen: bis `befunde-verlinken` (12.10.) läuft sie
aufsteigend, ab `e-132-fremdes-mailverzeichnis` abwärts. Gemessen an den
letzten fünf Einfügungen (`d0ce86ae`, `cda80195`, `ae773266`, `34c43204`) wird
**jede neue Zeile oben auf diesen absteigenden Block gesetzt** — genau dort
steht sie. Die Zeile folgt also der Gewohnheit; **die Tabelle selbst** ist der
Mangel, und zwar ein alter. Nicht angefasst: eine Umsortierung von 50 Zeilen
gehört nicht in einen Nachlauf vor einem Release.

---

## Berichtigt

### <a id="l-45.2"></a>L-45.2 — `Releases/PAKETE.md` bewies, dass es ein Verzeichnis nicht gibt, das drei Minuten später angelegt wurde (mittel)

`Releases/PAKETE.md:161-165`, der Kasten über dem Abschnitt 1.0.114, den
[LEKTOR-44](LEKTOR-44.md#l-44.5) gestern geschrieben hat:

> **Gemessen am 20.10.2026:** … es gibt **kein Verzeichnis
> `Releases/1.0.114/`**, kein Tag `v1.0.114` …

**Gemessen:** der Kasten entstand mit `faa3720b` um **21:33:43**; die Datei
`Releases/1.0.114/RELEASE-NOTIZEN.md` entstand mit `5f721756` um **21:39:33**.
Der Beleg war **sechs Minuten** gültig. Seither behauptet die Buchführung über
ihr eigenes Verzeichnis, es existiere nicht — und sie tut das in der Form, die
am schwersten zu widerlegen ist: als **Messung mit Datum**.

**Die Lehre ist nicht der Tippfehler.** Ein Kasten, der eine Abwesenheit
beweist, verfällt in dem Moment, in dem jemand die Sache anlegt — anders als
eine Aussage über eine Anwesenheit, die bestehen bleibt. Das ist dieselbe Form
wie [L-44.5](LEKTOR-44.md#l-44.5), nur umgekehrt. Der Kasten nennt jetzt den
Stand vom **21.10.2026**, sagt ausdrücklich, dass das Verzeichnis **da ist**
und nur die Release-Notizen mit dem SHA-256-Platzhalter enthält, und zählt die
drei Dinge auf, die es wirklich nicht gibt: ZIP, Tag, Veröffentlichung.

### <a id="l-45.3"></a>L-45.3 — die Release-Notizen zu 1.0.114 zählten Defender anders als jedes andere Dokument, und zwar in einem Text, der nach außen geht (hoch)

`Releases/1.0.114/RELEASE-NOTIZEN.md:85`, *Hinweis zu Windows Defender*:

> … das Programm ohne Meldung beendet — am 20.10.2026 **zweimal an einem
> Tag**, **zuletzt** die Fassung 7.2.0.113 **beim Starten** …

**Gegen den Bestand gehalten — vier Quellen, dreimal dieselbe Zahl:**

| Quelle | Zählung für den 20.10.2026 |
|---|---|
| [E-124](../Intern/BEFUNDE.md#e-124) | **drei**: 13:17:28 (Bau zu 1.0.111), 20:33:12 (1.0.113, beim Ausführen), 20:45:19 (1.0.113, ausgelöst von `perl.exe`) |
| `Releases/PAKETE.md:174` | *„dritter betroffener Bau … nach **Erkennungen** gezählt der vierte Fall, und um 20:45:19 kam ein **fünfter** dazu"* |
| `WEITERMACHEN.md` | *„An einem Tag **dreimal** zugeschlagen"* |
| `Releases/1.0.114/RELEASE-NOTIZEN.md` | **zweimal** |

**Beide Hälften des Satzes waren falsch.** Die Zahl stimmt nicht, und
*„zuletzt … beim Starten"* trifft nicht zu: die **letzte** Erkennung des Tages
war die um 20:45:19, und ausgelöst hat sie **unsere eigene Schranke**
`pruefe-behoben-ausgeliefert.pl`, die die EXE zum Messen auspackte. Die
Erkennung *beim Starten* lag zwölf Minuten davor.

**Warum das zählt und nicht Haarspalterei ist.** Mit genau dieser Zählung
argumentieren wir gegenüber Microsoft: `Releases/DEFENDER-FEHLALARM.md:64`
schreibt *„three separate builds"*, und das ist **eingereicht**. Ein
veröffentlichter Text, der daneben eine kleinere Zahl nennt, entwertet den
eingereichten. Das ist derselbe Fall wie
[L-44.6](LEKTOR-44.md#l-44.6) — damals wusste der Befund nichts von der Zahl,
heute weiß die Veröffentlichung nichts vom Befund.

Berichtigt auf *„dreimal an einem Tag, **darunter** die Fassung 7.2.0.113 beim
Starten"*. Eine Zeile, eine Änderung; der Rest des Abschnitts (Vorgangsnummer
`a567fe2a-…`, *Incorrect detection*, der Weg über *Auf Gerät zulassen*) deckt
sich mit [E-124](../Intern/BEFUNDE.md#e-124).

### <a id="l-45.4"></a>L-45.4 — der Block *HIER WEITERMACHEN* meldete einen Pull Request als offen, der seit elf Stunden gemergt war (mittel)

`WEITERMACHEN.md:134`, erster Satz des Blocks, der ausdrücklich *„gilt vor
allen Blöcken darunter"*:

> … **PR #119 offen und konfliktfrei** (`MERGEABLE / CLEAN`), alles committet
> und gepusht, kein offener Arbeitsbaum.

**Gemessen:** `gh pr view 119` → **MERGED**, 20.10.2026 um **19:53:26 UTC**.
Der Block wurde mit `ad9dee3f` am **21.10.2026 um 06:51:36** geschrieben — die
Aussage war beim Schreiben schon elf Stunden alt und falsch. Sie trägt die
Überschrift *„Stand 20.10.2026 abends"*, und genau das hat sie gedeckt:
`pruefe-stand-md.pl` prüft das Datum, nicht die Aussage
([L-44.7](LEKTOR-44.md#l-44.7), derselbe Mechanismus).

**Warum ausgerechnet dieser Satz teuer ist:** er ist das Erste, was die
nächste Sitzung liest, und er fordert zu einer Handlung auf, die bereits
geschehen ist. Jetzt nennt er beide Pull Requests mit ihrem Merge-Zeitpunkt und
den Commit, auf dem `main` steht. *„Kein offener Arbeitsbaum"* ist
herausgenommen — es stimmt nicht, während drei Rollen in eigenen Arbeitsbäumen
laufen.

---

## Darf das Paket 1.0.114 so geschnürt werden?

**Ja** — nach diesen drei Berichtigungen behauptet kein geprüftes Dokument mehr
etwas über 1.0.114, das nicht stimmt. Gemessen:

* **Kein Dokument nennt 1.0.114 als geschnürt, getestet oder veröffentlicht.**
  Alle zehn sagen ausdrücklich das Gegenteil: `README.md:60-64` (*„noch nicht
  als Paket geschnürt und nicht veröffentlicht, für `v1.0.113` gilt der Hinweis
  oben unverändert"*), `WEITERMACHEN.md:9` und `:136`, `AUFGABEN.md:3`,
  `ZIEL.md:49`, `TESTPLAN.md:1/:18/:172/:398`, `Releases/PAKETE.md:159`,
  `Releases/ISSUE-102-ANTWORT.md:11`, der Kopf von `CHANGELOG.md` 7.2.0.114.
* **Die SHA-256 ist als Platzhalter kenntlich** (`:100`, *„wird beim Schnüren
  des Pakets eingetragen"*), und `WEITERMACHEN.md` Punkt 1 nennt sie als ersten
  Handgriff.
* **Die Zahlen decken sich** mit [E-132](../Intern/BEFUNDE.md#e-132) und
  [E-124](../Intern/BEFUNDE.md#e-124): 241 Tests / 241 bestanden (identisch in
  `CHANGELOG.md:144`, `TESTPLAN.md:166/:398`, `Releases/PAKETE.md:173`,
  [E-132](../Intern/BEFUNDE.md#e-132)), die drei Wege mit *Nein* als Vorgabe, die
  Gegenprobe `fremd=0`, die beiden Fehlfassungen (`E132AufrufZerlegen`, die
  gemerkte Spurmarke), Vorgang `a567fe2a-9f58-47e1-a675-a62733ec538f`,
  *Incorrect detection* — und nach [L-45.3](#l-45.3) auch die Defender-Zählung.
  Der **Erkennungsname** `Trojan:Win32/Bearfoos.A!ml` steht **nicht** in den
  Notizen; sie verweisen für den ganzen Fall auf die README, wo er steht. Das
  ist kein Widerspruch, aber es ist auch die einzige Angabe, mit der ein
  Anwender seine Defender-Meldung zuordnen kann.
* **Der Schaden aus [L-43.1](LEKTOR-43.md#l-43.1) / [PRÜFER-40](PRUEFER-40.md#k2)
  K2 ist diesmal nicht da.** Die Regel aus `WEITERMACHEN.md` (*ein Absatz mit
  ungerader Zahl von `**` ist kaputt*) über die Notizen zu 1.0.114 gefahren:
  **0 Absätze**; kein Absatz beginnt mit einem Kleinbuchstaben. Der Ordner
  1.0.114 ist also **nicht** aus dem unreparierten Vorgänger kopiert worden.

**Zwei Dinge, die beim Schnüren und Veröffentlichen von selbst wieder
eintreten, wenn niemand sie tut** — beide sind Werkzeugänderungen und damit
außerhalb meines Auftrags, aber beide schlagen **genau jetzt** zu:

1. `tools/release-veroeffentlichen.ps1` ruft `pruefe-release-buchfuehrung.pl`
   **null Mal** auf (`grep -c` = 0). Das ist
   [L-43.11](LEKTOR-43.md#l-43.11), seit zwei Tagen offen; beim Tag `v1.0.113`
   meldete die Schranke hinterher sechs Stellen. **Abhilfe ohne
   Werkzeugänderung:** `perl tools/pruefe-release-buchfuehrung.pl` von Hand
   **direkt nach** `gh release create` fahren.
2. Dieselbe Datei hängt die neue Zeile mit
   `[System.IO.File]::AppendAllText` ans **Dateiende** von `tools/RELEASES.md`
   (`:286`) — hinter den Zitatblock, wo sie als rohe Zeile voller senkrechter
   Striche rendert. Das war [L-43.8](LEKTOR-43.md#l-43.8) bei `v1.0.112` und
   [L-44.9](LEKTOR-44.md#l-44.9) bei `v1.0.113`; beide Male habe ich die Zeile
   von Hand in die Tabelle zurückgehoben. **Nach `v1.0.114` wird sie dort zum
   dritten Mal liegen.** (Gemessen: die Tabelle endet derzeit sauber mit
   `v1.0.113` in Zeile 35 — [L-44.9](LEKTOR-44.md#l-44.9) ist behoben.)

---

## <a id="l-45.5"></a>L-45.5 — die eine Liste: was seit LEKTOR-43 und LEKTOR-44 offen ist

Nachgemessen, nicht abgeschrieben. **Vier Dinge sind erledigt**, elf nicht.

**Erledigt seit [LEKTOR-44](LEKTOR-44.md#lektor-44):**

| Punkt | gemessen |
|---|---|
| [L-44.9](LEKTOR-44.md#l-44.9) `tools/RELEASES.md` Zeile außerhalb der Tabelle | `grep -n '^\|'` → Zeilen 30–35 lückenlos, `v1.0.113` steht **in** der Tabelle |
| [L-43.14](LEKTOR-43.md#l-43.14) Nummernkreise in den PRÜFER-Berichten | bleibt erledigt — `K1 … K15` mit Ankern |
| [L-43.17](LEKTOR-43.md#l-43.17) Defender-Beleg zu 1.0.113 | in [E-124](../Intern/BEFUNDE.md#e-124); für **1.0.112** weiterhin keiner |
| Die 16 „toten Verweise" aus [L-44.14](LEKTOR-44.md#l-44.14) | zurückgenommen, die acht Berichte stehen unverändert |

**Offen — Gregors Entscheidung (aus [LEKTOR-44](LEKTOR-44.md#lektor-44),
unverändert):**

| # | Was | Stand am 21.10.2026 |
|---|---|---|
| 1 | **Die veröffentlichte Beschreibung von `v1.0.113` berichtigen?** `gh release edit v1.0.113 --notes-file Releases/1.0.113/RELEASE-NOTIZEN.md` | **offen.** Nachgemessen mit `gh release view v1.0.113 --json body`: der veröffentlichte Text weicht weiter ab — zwei abgebrochene Sätze, der fehlende Punkt zur Meldungsflut, *„Ursache"* statt *„Unsere Spur"*, keine Warnung vor [E-132](../Intern/BEFUNDE.md#e-132). **Dieselbe Frage stand schon für `v1.0.112` in [LEKTOR-43](LEKTOR-43.md#lektor-43); sie ist damit zum dritten Mal offen** |
| 2 | **Die drei Punkte aus [L-44.8](LEKTOR-44.md#l-44.8) in den Issue-Beitrag?** Besonders *„back up your `Eudora.ini` first"* | **offen.** Der Wortlaut in `Releases/ISSUE-102-ANTWORT.md` ist unverändert, die drei Punkte stehen darüber. **Wird mit dem Release fällig** — Punkt 4 in `WEITERMACHEN.md` |
| 3 | **Die Schranke aus [L-44.11](LEKTOR-44.md#l-44.11) bauen?** Hält die führenden Dokumente gegen `gh release view` statt gegen sich selbst | **nicht gebaut.** Sie hätte [L-45.4](#l-45.4) gefangen |
| 4 | **[L-43.11](LEKTOR-43.md#l-43.11) und [L-43.12](LEKTOR-43.md#l-43.12)** | **beide offen**, siehe oben — beide treten bei `v1.0.114` wieder ein |

**Offen — gemeldet, nicht geändert (Werkzeuge und Texte nach außen):**

| Punkt | Stand am 21.10.2026, gemessen |
|---|---|
| [L-43.11](LEKTOR-43.md#l-43.11) `pruefe-release-buchfuehrung.pl` läuft nicht vor dem Tag | **offen.** `grep -c 'pruefe-release-buchfuehrung' tools/release-veroeffentlichen.ps1` = **0**. In der Datei steht **keine einzige** `pruefe-*`-Schranke |
| [L-43.12](LEKTOR-43.md#l-43.12) `tools/RELEASES.md` ans Dateiende | **offen.** `AppendAllText` in `tools/release-veroeffentlichen.ps1:286` |
| [L-43.13](LEKTOR-43.md#l-43.13) `ist_standaussage()` hört auf Wörter | **offen**, unverändert in `tools/pruefe-release-buchfuehrung.pl` |
| [L-43.15](LEKTOR-43.md#l-43.15) Release-Notizen nicht im Prüfumfang von `pruefe-befundurteile.pl` | **offen.** In der Datei kommt kein `RELEASE-NOTIZEN.md` vor |
| [L-44.11](LEKTOR-44.md#l-44.11) 32 Schranken grün, während Dokumente unwahr sind | **unverändert.** Heute wieder: 32 grün, drei falsche Sätze ([L-45.2](#l-45.2)–[L-45.4](#l-45.4)) |
| [L-44.12](LEKTOR-44.md#l-44.12) Notizen werden aus dem Vorgänger kopiert | **Werkzeug unverändert**, aber bei 1.0.114 **nicht** eingetreten (oben gemessen) |
| `tools/pruefe-halbe-saetze.pl` (angefangen in `WEITERMACHEN.md`) | **nicht gebaut.** Die Regel ist formuliert und in beide Richtungen geprüft; die Datei gibt es nicht |
| [L-42.14](LEKTOR-42.md#l-42.14) / [L-41.3](LEKTOR-41.md#l-41.3) `ZIEL.md` kennt [E-122](../Intern/BEFUNDE.md#e-122)–[E-130](../Intern/BEFUNDE.md#e-130) nicht | **offen** |
| [L-41.8](LEKTOR-41.md#l-41.8) zwei Messskripte ohne Eintrag in `tools/WERKZEUGE.md` | **offen** |
| [L-38.5](LEKTOR-38.md#l-38.5) [E-78](../Intern/BEFUNDE.md#e-78) in der README-Tabelle | **offen** |
| [L-37.10](LEKTOR-37.md#l-37.10) `AUFGABEN.md` ohne Zeilen für [E-122](../Intern/BEFUNDE.md#e-122) ff. | **offen**, jetzt bis [E-132](../Intern/BEFUNDE.md#e-132) |
| [E-130](../Intern/BEFUNDE.md#e-130) fünf DLLs im Hauptbaum | **unverändert** |
| `README.md:577` *„Seit 7.2.0.114 nennt der Über-Dialog…"* | **ohne den Vermerk, dass 7.2.0.114 nicht veröffentlicht ist** — anders als die E-132-Stelle 500 Zeilen darüber, die ihn trägt. **Nicht berichtigt:** mit dem Release von `v1.0.114` wird der Satz von selbst wahr. Bleibt das Release aus, gehört er nachgezogen |

---

## Geänderte Dateien

`Releases/1.0.114/RELEASE-NOTIZEN.md`, `Releases/PAKETE.md`,
`WEITERMACHEN.md`, `LEKTORAT.md` und dieser Bericht.

**Keine Datei unter `Eudora71/` angefasst, kein Werkzeug unter `tools/`
geändert.** `Releases/DEFENDER-FEHLALARM.md` (eingereicht) und der freigegebene
Wortlaut in `Releases/ISSUE-102-ANTWORT.md` bewusst unverändert; nichts in
Rückstrichen oder Blockzitaten angefasst
([L-44.14](LEKTOR-44.md#l-44.14)).

Nach jedem Schreibzugriff gemessen: **CRLF 0**, reine LF, UTF-8 ohne BOM.
`perl tools/commit-bereit.pl` vor jedem Commit: **32 Schranken, keine weist
ab.** `befunde-verlinken.pl` *Anker vollständig*, `doku-pruefen.pl` kein
Widerspruch.
