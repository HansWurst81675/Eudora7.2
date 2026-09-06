---
name: doku-bei-jedem-commit-mitziehen
description: "README.md und PORTIERUNG.md gehoeren in denselben Commit wie die Aenderung, nicht nachtraeglich auf Zuruf"
metadata:
  type: feedback
---

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

---

## Nachtrag 06.09.2026 — der Fehler ist nicht das Fehlen, sondern das Stehenbleiben

**32 Nachrichten** in den beiden Mitschriften betreffen die Doku. Fast keine
davon sagt „das fehlt". Fast alle sagen **„das ist alt"**:

| Datum | Gregor |
|---|---|
| 29.08. | *„der eine agent wollte noch readme.md pruefen, er hat gepennt, diese stimmt nicht - ist veraltet!"* |
| 31.08. | *„das ist doch eine alte readme, nicht wahr? warum? habe ich nicht gesagt, alles updaten bevor 9.00 uhr?"* |
| 05.09. | *„Gemessen am 31.08.2026 an dem Paket Eudora72-1.0.3-release.zip — dsa ist ja alt!"* |
| 05.09. | *„warum ist es noch keinem aufgefallen? sollte up to date sein. das interessiert ja keinen."* |
| 05.09. | *„ist es noch aktuell? braucht man jetzt noch diese infos?"* |
| 06.09. | *„readme ist auf dem letzten stand? alle alten inhalte geloescht?"* |

Der Unterschied ist der Arbeitsschritt. Ergaenzen ist leicht und passiert von
selbst; **loeschen** passiert nie von selbst. So entsteht eine README, in der
jeder Satz einmal gestimmt hat und der Gesamteindruck falsch ist.

### Die Regel, gescharft

1. **Jede Aussage traegt ihren Messstand.** Steht in einer Zeile „gemessen am
   31.08. an Paket 1.0.3" und wir sind bei 1.0.10, ist die Zeile **falsch**,
   nicht „aelter". Sie wird neu gemessen oder geloescht — nicht stehengelassen.
2. **Beim Doku-Abgleich zuerst suchen, was weg muss.** Vor dem Ergaenzen die
   Datei nach alten Versionsnummern, alten Daten und erledigten „naechsten
   Schritten" durchsuchen. Der Griff dazu:
   `grep -n "1\.0\.[0-9]\|7\.2\.0\.[0-9]\|2026-0[89]" *.md` — jede Fundstelle
   gegen den heutigen Stand halten.
3. **Ein Stand steht an genau einer Stelle.** Dieselbe Zahl in README, ZIEL.md
   und PORTIERUNG.md heisst drei Stellen, die auseinanderlaufen. Wo es geht,
   verweisen statt wiederholen.
4. **Findings gehoeren ins `CHANGELOG.md`,** nicht in die README. Gregor am
   06.09.2026: *„auch findings in readme bzw. besser: ins changelog schreiben!"*
   — mit der Begruendung: *„es geht auch darum, dass andere die repo clonen
   koennen und sehen, was der stand ist, wo sie evtl. weitermachen koennen."*
   Die README sagt, was **jetzt** gilt; das CHANGELOG sagt, was **war**.

### Die Kontrolle hat versagt, nicht nur das Schreiben

Am 05.09.2026 hat ein Commit die README an 239 Stellen doppelt kodiert
(`fb87843`, 22:10 Uhr). Gregor sah es eine Minute spaeter:
*„was sind das fuer steuerzeichen? reparaieren! sofort!"* und danach
*„sowas haette der lektor vor dem commit finden muessen und den commit
verhindern!"*, *„du hast gepfuscht!"*, *„ich will hier fertig werden, du machst
neue fehler. ist es absicht?"*

Diese Fehlerklasse ist inzwischen abgestellt — `tools/pruefe-bytes.pl` faengt sie
als Regel 5 ab (Befund X-7). Was bleibt, ist die Lehre darueber: **LEKTOR ist
kein Stilbeauftragter, sondern eine Schranke vor dem Commit.** Wenn er erst
danach liest, hat er seine Aufgabe verfehlt.
