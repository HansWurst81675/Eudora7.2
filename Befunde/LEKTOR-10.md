# LEKTOR-10 — der Bestand nach 7.2.0.63 (15.09.2026)

Auftrag: alle MDs gegen den **Bestand** prüfen, nicht gegen den Diff
([review-sieht-nur-den-diff.md](../Arbeitsweise/review-sieht-nur-den-diff.md)).
Arbeitsbaum `Eudora7.2-wt-lektor`, Zweig **`lektor-doku-1063`** — der Name ist
**noch nicht mit Gregor abgestimmt** ([zweig-vorher-abstimmen](../Arbeitsweise/zweig-vorher-abstimmen.md)).
Geprüft am Stand **7.2.0.63 / Paket 1.0.63**.

> **Zum Auftrag:** Er nannte als ersten Schritt, `origin/weitermachen-nachziehen`
> hereinzuholen. Das war beim Anlauf schon erledigt — Gregor hat den Zweig als
> **PR #50** gemergt, `origin/main` steht auf `2482c27` und trägt 7.2.0.63.
> Der Zweig ist deshalb frisch aus `origin/main` gezogen, ohne Merge.

---

## Die Übersicht

| | |
|---|---|
| **Berichtigt** | `WEITERMACHEN.md`, `BEFUNDE.md`, `CHANGELOG.md`, `README.md`, `AUFGABEN.md`, `ZIEL.md`, `Releases/PAKETE.md`, `Befunde/SPURMARKEN.md` |
| **Schranken verschärft** | `tools/offene-befunde.pl`, `tools/pruefe-befundurteile.pl` |
| **Gefunden, nicht angefasst** | drei Punkte, siehe unten — zwei davon liegen in `Eudora71/` |
| **Commits** | `da19c70`, `02988a9`, `ca227c2`, `78bbc14`, `bae6875`, `bfb2e24`, `b1ff4a0` |

---

## 1. Eine Schranke war blind, und sie meldete Erfolg

`offene-befunde.pl` und `pruefe-befundurteile.pl` lesen das Urteil eines Befunds
als **erstes Fettgedrucktes der dritten Spalte** — und taten das bis heute nur
bis **60 Zeichen** Länge (`/\*\*([^*]{1,60})\*\*/`). Wer länger urteilt, wurde
nicht gezählt:

| Befund | Urteil | Länge |
|---|---|---:|
| **E-90** | *gemessene Grenze, kein Fehler dieser Fassung — zurückgestellt.* | 62 |
| **E-92** | *beobachtet, unsere Seite NICHT gemessen — Kosmetik, zurückgestellt.* | 67 |

Beide sind **zurückgestellt**, also nach der eigenen Wortliste der Werkzeuge
offen. Beide fehlten in der Liste — und das Werkzeug schrieb dazu *„Die Liste
deckt die offenen Befunde."* **Neun standen da, wo elf stehen.** Kein Fehlalarm,
sondern Schweigen; die teurere der beiden Sorten
([prüfstand-kann-blind-sein](../Arbeitsweise/pruefstand-kann-blind-sein.md)).

**Gegengetestet in beide Richtungen** ([schranke-gegentesten](../Arbeitsweise/schranke-gegentesten.md)):
ohne Grenze kommen **genau** E-90 und E-92 dazu und kein behobener Befund
rutscht durch — „behoben" schlägt weiterhin „offen", weil diese Prüfung vorher
steht. `perl -c` auf beide Werkzeuge: OK.

**Die verschärfte Prüfung hat sofort geliefert:** sie schlug an `WEITERMACHEN.md:13`
an, das E-92 als behoben führte. Genau das war der Zweck.

## 2. Der Bestand stand an neun Stellen auf einer älteren Fassung

Keine dieser Zeilen war in einem Diff — sie waren einmal richtig.

| Datei | stand da | ist |
|---|---|---|
| `WEITERMACHEN.md` Kopf | Stand 14.09.2026 | 15.09.2026 |
| `WEITERMACHEN.md`:11 | E-89 wartet auf Gregor, gebaut in 7.2.0.63, 148/148 Tests | E-89 ist seit dem 14.09. an 1.0.58 **bestätigt**; 7.2.0.63 ist E-95/E-96 mit 153/153 |
| `WEITERMACHEN.md`:13 | 1.0.51 bis **1.0.56** nicht freigegeben; 1.0.63 sei Gregors Lauf vom 14.09., aus dem E-89 bis E-92 stammen | 1.0.51 bis **1.0.63**; Gregors Lauf war **1.0.58** |
| `WEITERMACHEN.md`:15 | *„DER NÄCHSTE SCHRITT: E-85 ist NICHT behoben"* samt Anleitung | zwei Zeilen tiefer in derselben Tabelle: behoben in 7.2.0.52, belegt |
| `WEITERMACHEN.md`:17 | *„Was als Nächstes zu messen ist: der hängende Resync"* | das ist **E-83**, seit 7.2.0.53 behoben und gemessen |
| `AUFGABEN.md` | *„Gepackt ist 1.0.52"*, zwei Behebungen warten | gepackt ist **1.0.63**, es warten **fünf** (E-85, E-83, E-93, E-95, E-96) |
| `ZIEL.md`:17 | gebaut ist inzwischen 7.2.0.57 | 7.2.0.63 |
| `Releases/PAKETE.md`:6 | seit 09.09. sind 1.0.30 bis **1.0.57** dazugekommen | bis **1.0.63** |
| `README.md`:158 | Titelzeilenbeispiel *„Eudora 7.2.0.29 / Paket 1.0.29"* | 34 Bauten alt, jetzt 7.2.0.63 / 1.0.63 |

Die beiden Zeilen aus `WEITERMACHEN.md` 15 und 17 standen als **Handlungs­anweisung**
da, nicht als Geschichte. Wer von oben liest, fängt an zu arbeiten, bevor er den
Widerspruch findet — die Klasse, gegen die
[bestand-vor-neuer-suche](../Arbeitsweise/bestand-vor-neuer-suche.md) geschrieben
ist. Ihr Text bleibt vollständig stehen, nur die Überschrift sagt jetzt
*„ERLEDIGT — Fassungsgeschichte"* und nennt Fassung und Beleg.

## 3. Eine Zahl im README war schlicht falsch

Zu **E-93** stand dort *„es gingen 17.889 statt **252.921** Byte hinaus"*.
`CHANGELOG.md` und `BEFUNDE.md` zitieren beide die Spurmarke selbst:
`OrigBytes=105125 EditorBytes=17889`. Und nur 105.125 ergibt die **83 Prozent**,
die im Befundtitel stehen:

```
1 - 17889/105125 = 0,830      1 - 17889/252921 = 0,929
```

`README.md` war der Ausreißer. **Bemerkenswert:** der Auftrag an mich nannte
ebenfalls 252921. So wandert eine falsche Zahl weiter, sobald sie einmal im
README steht.

## 4. E-95 las sich widersprüchlich (Auftrag Punkt 2)

Das Urteil sagte *„behoben in **7.2.0.61**, 153 Tests"*, der Nachtrag drei Sätze
tiefer, die Behebung von 7.2.0.61 sei mit 7.2.0.63 **wieder zurückgenommen**.
Wer nur die Urteilsspalte liest — und das tun Mensch wie Werkzeug —, bekam die
Fassung genannt, die gerade **nicht** mehr im Bau ist. Dazu stand die Testzahl
von 7.2.0.63 an 7.2.0.61.

Das Urteil nennt jetzt in der ersten Zeile beides: behoben, **aber nicht so, wie
7.2.0.61 es versuchte**; was trägt, ist E-96 aus 7.2.0.62. Der ausführliche
Nachtrag darunter erklärt den Weg und bleibt unangetastet.

**E-94 fehlte in `CHANGELOG.md`, Abschnitt *Noch offen*.** Der Abschnitt nannte
E-90, E-91, E-92 und sieben ältere — aber nicht den einzigen Befund, den
`BEFUNDE.md` ausdrücklich mit dem Wort *offen* führt. Die **erzeugte** Liste in
`WEITERMACHEN.md` hatte ihn, die von Hand gepflegte nicht. `offene-befunde.pl`
deckt `CHANGELOG.md` nicht ab.

## 5. SPURMARKEN.md: vier Marken fehlten, und die Zahl war zweimal alt (Auftrag Punkt 5)

Die Datei sagte *„23 Befunde, 158 Stellen in 20 Dateien"*, gemessen am
13.09.2026 — und warnte **im selben Absatz** davor, dass die Zahl schon einmal
nicht nachgezogen worden war. Sie war es wieder.

| | Befunde | Stellen | Dateien |
|---|---:|---:|---:|
| behauptet (13.09.) | 23 | 158 | 20 |
| **gemessen (15.09.)** | **29** | **168** | **26** |

Der Messbefehl steht jetzt **dort**, dreizeilig und selbst gefahren — die Zahlen
im Text sind seine Ausgabe ([prüfumfang-nicht-von-hand](../Arbeitsweise/pruefumfang-nicht-von-hand.md)).

**Vier Marken fehlten** in *Alle Marken im Quelltext*: **E-83**
(`QCTaskManager.cpp:430`, acht Aufrufstellen), **E-86** (`TridentView.cpp:1619`,
`:2274`), **E-87** (`summary.cpp:1149`) und **E-95** (`PGHTMIMP.CPP:2186`, der
Auftragspunkt). Die Tabelle hat jetzt 29 Zeilen und deckt die 29 gemessenen
Befunde. **E-89** stand mit *„1 Stelle in `summary.cpp`"* falsch da — nach der
eigenen Zählregel der Datei sind es **2 Stellen in `msgutils.cpp`**;
`summary.cpp` nennt E-89 nur im Kommentar.

**E-95 steht jetzt auch in der oberen Tabelle** mit seiner Auswertung: eingebaut
1.0.61, ausgewertet 1.0.62, an einem selbst gestarteten Eudora mit drei Bildern
bekannter Größe. Sie hat E-96 entschieden und die `cid:`/`http:`-Unterscheidung
aus 7.2.0.61 widerlegt.

## 6. Die README-Zahlen (Auftrag Punkt 3): zwei stimmen, zwei sind nicht nachprüfbar

**Nachgemessen und unverändert:** `IHTMLDocument2` in `TridentView.cpp` = **13**,
`designMode`/`contentEditable` in ganz `Eudora71/Eudora` = **0**. Beide
Messbefehle stehen jetzt im README und sind gefahren.

**Nicht nachprüfbar:** *Paige-Anbindung 13.146 Zeilen / 36 Dateien / 188
Funktionen* und *MSHTML-Anbindung 8.637 Zeilen / 9 Dateien*. Der Messbefehl ist
nirgends aufgeschrieben — auch nicht im Commit `b27c10c`, der die Zahlen
einführte. Mit jeweils vertretbaren Definitionen von „Anbindung" kommt heraus:

```
Dateien mit Pg-Praefix in Eudora71/Eudora        46
.cpp, die 'paige' oder 'pg_ref' nennen           60  (104.606 Zeilen)
Dateien, die pg_ref/pgTypes/paige verwenden      38
```

Keine trifft 13.146/36 oder 8.637/9. **Ich habe die Zahlen nicht ersetzt** —
meine Definition wäre nicht ihre, und eine erfundene Reproduktion wäre schlimmer
als ein ehrlicher Vermerk. Der Abschnitt sagt jetzt, dass sie als Größenordnung
taugen und als Beleg nicht.

## 7. Auftrag Punkt 4: `tools/WERKZEUGE.md` ist vollständig

Gezählt mit `git ls-files tools/`, nicht mit `ls tools/*.pl`: **108 versionierte
Dateien**. **Jede einzelne** wird in `WERKZEUGE.md` namentlich genannt, `stand.pl`
eingeschlossen (Zeile 86). 96 haben eine eigene Tabellenzeile, der Rest —
überwiegend die `*-tests.pl` — wird im Fließtext der zugehörigen Schranke
genannt. **Kein Mangel.**

---

## Gefunden, nicht berichtigt

**1. `spuren-auswerten.pl` meldet einen Fehlalarm zu E-95.** Das Werkzeug
erkennt eine Marke am Wort `SPURMARKE` in einer Kommentarzeile
(`tools/spuren-auswerten.pl:122`). Der Kommentar über der E-95-Marke heißt
`E-95-MESSUNG, 15.09.2026`. Die Marke steht sehr wohl im Bau. **Der Fix ist ein
Wort** in `PGHTMIMP.CPP:2157` — `Eudora71/` fasse ich laut Auftrag nicht an. Der
Grund steht jetzt in `SPURMARKEN.md`, damit ihn niemand ein zweites Mal sucht.

**2. Drei Testläufe vom 15.09.2026 mussten abgeschossen werden.**
`tools/TESTLAEUFE.md` protokolliert für `C:\Temp\E95-Test` dreimal
*„ABER: musste abgeschossen werden. Schliesszeit 30.2/30.3 s"*, dazwischen einen
sauberen Lauf mit 2,1 s. **Kriterium 7 (*File → Exit* beendet sauber) gilt als
erfüllt** — diese drei Läufe sprechen dagegen, sind aber nicht untersucht und
liefen mit einem Eudora, das währenddessen umgebaut wurde. **Kein Befund von
mir**, sondern ein Messwert, den jemand ansehen sollte, bevor 1.0.63 zu Gregor
geht ([eingebaute-messung-auslesen](../Arbeitsweise/eingebaute-messung-auslesen.md)).

**3. Drei `CHANGELOG`-Abschnitte fehlen weiterhin** — 7.2.0.36, .37, .38. Sie
stehen als benannte Altlast in `pruefe-doku-takt.pl` und sind dort keine stille
Ausnahme. Unverändert offen.

## Nicht geprüft

* **Der Inhalt von `PORTIERUNG.md`, `PRUEFUNG-CODE.md` und `EINSTELLUNGEN.md`**
  gegen den Quelltext. `doku-pruefen.pl` meldet zu `EINSTELLUNGEN.md` und
  `FILTER.md` nur, dass sie den aktuellen Stand **nicht nennen** — das ist keine
  Falschaussage, aber auch kein Beleg, dass ihr Inhalt stimmt.
* **Ob die 49 `CHANGELOG`-Abschnitte inhaltlich stimmen.** Geprüft ist nur
  Reihenfolge und Lückenlosigkeit (`pruefe-doku-takt.pl`).
* **Die Zahlen in `Arbeitsweise/`**. Die Lehren sind nicht gegen den Bestand
  gemessen worden.

## Was danach grün ist

```
offene-befunde.pl        11 offen laut BEFUNDE.md = 11 in WEITERMACHEN.md
pruefe-befundurteile.pl  11 offen / 64 behoben, kein Dokument dreht ein Urteil um
pruefe-stand-md.pl       kein Stand-Kopf hinkt hinterher   (vorher 2 Mangel)
pruefe-doku-takt.pl      49 Abschnitte, absteigend, keine Luecke ab 7.2.0.36
doku-pruefen.pl          kein Widerspruch
spuren-auswerten.pl      gruen, mit dem erklaerten Hinweis zu E-95
```

Bytes nach **jedem** Schreibzugriff gemessen: **CRLF 0** in allen acht
berührten MDs und beiden Werkzeugen, Zeilenzahl jeweils erwartungsgemäß.
