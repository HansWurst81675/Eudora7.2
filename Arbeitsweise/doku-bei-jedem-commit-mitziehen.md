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
