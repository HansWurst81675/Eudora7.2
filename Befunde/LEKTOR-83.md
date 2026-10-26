# <a id="lektor-83"></a>LEKTOR-83 — Kurzprüfung der Berichtigungen zu LEKTOR-82 vor dem PR des Zweigs `0.123_ergebnisse` nach `main`, 26.10.2026

**Auftrag.** Nur zweierlei: (1) ob [L-82.1](LEKTOR-82.md#l-82.1) bis
[L-82.3](LEKTOR-82.md#l-82.3) erledigt sind; (2) ob eine der drei
geänderten Stellen etwas Falsches oder Widersprüchliches sagt. Kein
Bestandsdurchgang. Lauf über `5a8e549..ce780458` (ein Commit, zwei `.md`,
3 Zeilen), gemessen im Arbeitsbaum `Eudora7.2-wt-lektor`.
`git log HEAD..origin/main` und `git log HEAD..origin/0.123_ergebnisse`
sind leer (gemessen).

**Ergebnis vorweg.** **0 Funde.** [L-82.1](LEKTOR-82.md#l-82.1) bis
[L-82.3](LEKTOR-82.md#l-82.3) sind erledigt. Keine der drei Stellen gibt
etwas als bestätigt aus, das nicht bestätigt ist, und keine widerspricht
`ZIEL.md`, `Intern/TESTPLAN.md` oder `Releases/DEFENDER-FEHLALARM.md`.

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-82

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-82.1](LEKTOR-82.md#l-82.1) | [E-124](../Intern/BEFUNDE.md#e-124): neues Datum *Zuletzt gemessen 26.10.* hing am Halbsatz *„aus der Vorgangsseite gelesen“* | **erledigt** | `Intern/BEFUNDE.md:370` *„**Zuletzt gemessen: 26.10.2026 an 7.2.0.124** (Gregors Bild aus dem Defender-Schutzverlauf, siehe den Nachtrag unten; die Vorgangsseite bei Microsoft hat seit dem 23.10.2026 niemand neu gelesen). Stand 23.10.2026: **aus der Vorgangsseite gelesen, …**“* (belegt). Das Datum 23.10. stimmt mit `Releases/DEFENDER-FEHLALARM.md:3` *„am 23.10.2026 aus Gregors gespeicherter Vorgangsseite gelesen“* und mit derselben Zeile *„Gregor hat sie am 22.10.2026 aus seinem Browser gespeichert“* (gespeichert 22., gelesen 23.) (belegt). [L-82.1](LEKTOR-82.md#l-82.1) hatte *„22.10.2026“* als Lesedatum vorgeschlagen; die Berichtigung ist genauer als der Vorschlag |
| [L-82.2](LEKTOR-82.md#l-82.2) | [E-142](../Intern/BEFUNDE.md#e-142): *No*-Vorwahl *„an 1.0.124 geprüft (T4, T6)“* | **erledigt** | `Intern/BEFUNDE.md:378` *„310 Tests, 310 bestanden). Die Vorwahl *No* hat am Programm noch niemand gesehen: in T4 an 1.0.124 kam die Rückfrage nicht, belegt ist sie nur durch den Unit-Test.“* (belegt). Passt zu `Intern/TESTPLAN.md:50` (T4 erwartet die Rückfrage mit *No*) und zum Urteilskopf derselben Zeile *„Kurztest T4 an 1.0.124: die Rückfrage kam nicht“*. Keine andere Stelle behauptet die Vorwahl als am Programm gesehen: `grep "vorgewählt\|Vorwahl"` über `*.md`, `Intern/`, `Doku/`, `Releases/` trifft sonst nur `Intern/WEITERMACHEN.md:128` (Entscheidung 9, *„Eingebaut“*) und die E-132-Zeilen `Intern/TESTPLAN.md:170,694` (gemessen) |
| [L-82.3](LEKTOR-82.md#l-82.3) | CHANGELOG *Erreicht*, Kriterien 5 und 6, ohne T3 | **erledigt** | `CHANGELOG.md:78` *„Kriterium 6 an 7.2.0.123 nicht bestanden und an 7.2.0.124 von Gregor bestätigt (Kurztest T3; [[E-158](../Intern/BEFUNDE.md#e-158)] …, Stand in ZIEL.md)“* — gleich `ZIEL.md:201` *„**erfüllt** — an 7.2.0.124 von Gregor bestätigt (Kurztest T3)“* (belegt). Die Doppelung der Kriterientabelle bleibt (siehe [L-81.1](LEKTOR-81.md#l-81.1)), stimmt aber jetzt Zeile für Zeile |

## Geprüft ohne Fund

* **Verweis in [E-124](../Intern/BEFUNDE.md#e-124):** *„siehe den Nachtrag unten“* zeigt auf den Abschnitt,
  der in derselben Zeile mit *„**Wieder aufgetreten am 26.10.2026 an Paket
  1.0.124**“* beginnt — das Wort *Nachtrag* steht dort nicht, der Abschnitt
  ist aber der einzige mit diesem Datum und dem Schutzverlauf (belegt,
  `Intern/BEFUNDE.md:370`). Kein Fund, nur schwächer als ein wörtlicher
  Verweis.
* **Erzeugte Listen:** `CHANGELOG.md:45` und `Intern/WEITERMACHEN.md:374`
  tragen für [E-124](../Intern/BEFUNDE.md#e-124) weiter *„26.10.2026 an 7.2.0.124“* (belegt); der
  geänderte Satz liegt hinter dem Kurztext, die Listen ändern sich nicht.

## Nach dem Merge auf `main`

Falsch oder schief wird nach dem Merge an diesen drei Stellen nichts.

## Nicht geprüft

* Alles außerhalb des Commits `ce780458`.
* Mechanische Prüfungen; der Commit ändert nur Text in drei Zeilen.

## Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)).
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)).
