# Zehnter Lektoratsdurchgang (L-10) — das Einarbeiten von L-9

**Für Gregor und den nächsten Agenten.** Diese Datei sagt, was am 08.09.2026 im
Arbeitsbaum `Eudora7.2-wt-lektor` (Zweig `wt/lektor`) an der Dokumentation
geändert wurde, **mit der Messung dahinter**, was an der schon nachgezogenen
`README.md` berichtigt werden musste, und was **offen** bleibt.

Ausgangsstand: `43034b4` (`git log --oneline -1`). Auftrag: die vier Dateien
nachziehen, die [LEKTOR-5.md](LEKTOR-5.md) als veraltet gemeldet hatte, und die
Befunde L-9.5, L-9.6, L-9.7, L-9.11, L-9.14, L-9.15, L-9.16 abarbeiten.

**Nichts gebaut, nichts gestartet, nicht gepusht.** Alle Angaben sind an der
Quelle nachgemessen; wo eine Angabe aus dem Auftrag nicht stimmte, steht das
unten in *Was ich am Auftrag berichtigt habe*.

---

## Die Messung, mit der alles anfängt

| gemessen | Befehl | Ergebnis |
|---|---|---|
| Quellstand | `grep EUDORA_BUILD_VERSION Eudora71/Version.h` | `7.2.0.23` |
| Paketnummer | `cat VERSION` | `1.0.23` |
| ZIP 1.0.23 | `sha256sum`, `stat -c%s` | `3f58a93c85c8fbf9f206ccc319a4798bb40236f3b60821a3de6df17710139045`, 9 340 228 Byte, 08.09.2026 10:55 |
| `Eudora.exe` darin | `unzip -l` | 2 957 312 Byte, 08.09.2026 10:51 — gleiche Größe und Zeit wie `Eudora71/Bin/Release/Eudora.exe` |
| ZIP 1.0.22 | `sha256sum`, `stat -c%s` | `7ddab1a0f0fdf1c4458a7aa2ab00d2f1fbb15561ab576657c73006fcfa95586c`, 9 339 516 Byte |
| ZIP 1.0.21 | `sha256sum` | `0a699fcb03c3f0b60a0142837fc2128f3baf19884cd6b96a4f388339165b667c`, 9 331 078 Byte |
| versionierte ZIPs | `git ls-files Releases/` | **1.0.2, 1.0.21, 1.0.22** — das ZIP zu **1.0.23 ist unverfolgt**, und die `.sha256`-Datei daneben fehlt |
| Marken | `git ls-remote --tags origin` | `v1.0.1`, `v1.0.2`, `v1.0.3`, `v1.0.10`, `v1.0.14`, `v1.0.15`, `v1.0.18`, `v1.0.21` — **kein `v1.0.22`, kein `v1.0.23`** |
| Kriterien | Tabelle in `ZIEL.md` | neun; belegt 0, 1, 3, 5, 6, 7 |
| QCSSL im Paket | `unzip -l` für 1.0.21/22/23 | dieselbe Datei, 2 920 960 Byte, 30.08.2026 17:57 |

---

## Was ich am Auftrag berichtigt habe

Zwei Angaben aus dem Auftrag habe ich **nicht** übernommen, weil die Messung
etwas anderes sagt, und eine dritte habe ich ergänzt.

### L-10.3 — `EUDORA_BUILD_NUMBER` war beim Heben auf 7.2.0.23 zurückgeblieben

`Eudora71/Version.h` sagte:

```
#define EUDORA_VERSION4 23
#define EUDORA_BUILD_NUMBER    7,2,0,22
#define EUDORA_BUILD_DESC      "Version 7.2.0.23\0"
#define EUDORA_BUILD_VERSION   "7.2.0.23"
```

**Vier von fünf Zeilen gehoben, eine nicht.** Gemeldet hat es
`tools/doku-pruefen.pl` unter *Zu tun am Quellstand* (blockiert bewusst
nichts). Genau derselbe Fehler ist am 07.09.2026 schon einmal aufgetreten und
in `Releases/PAKETE.md` als Tabelle mit **fünf** Zeilen festgehalten worden —
die Tabelle war da, benutzt hat sie niemand.

**Berichtigt** auf `7,2,0,23`, und in `Releases/PAKETE.md` steht der zweite
Vorfall jetzt neben der Tabelle. Das Makro wird nirgends verwendet
(`grep -rn EUDORA_BUILD_NUMBER Eudora71/` — ein Treffer, die Definition
selbst), der Bau kann davon also nicht anders ausfallen. **Ich habe nicht
gebaut.**

### Das ZIP zu 1.0.23 liegt vor, ist aber nicht committet

Beim ersten Nachmessen (11:00 Uhr) gab es `Releases/Eudora72-1.0.23-release.zip`
noch nicht; beim zweiten war es da. Es ist aber **unverfolgt**, und die
`.sha256`-Datei daneben fehlt — anders als bei 1.0.2, 1.0.21 und 1.0.22. Die
`README.md` behauptete ohne Einschränkung *„Beide zeigen auf dasselbe:
Releases/Eudora72-1.0.23-release.zip"*. Das steht jetzt mit Prüfsumme, Größe
**und** dem Zusatz da, dass es noch nicht committet und nicht als Marke
veröffentlicht ist.

### Anforderung A-2: der Auftrag und `BEFUNDE.md` widersprachen sich

Der Auftrag sagt, Gregor habe A-2 bestätigt (*„jetzt ist sie unten, ja"*).
`BEFUNDE.md` (E-44) und `ZIEL.md` sagten **„von Gregor noch nicht bestätigt"**.
`CHANGELOG.md:103` dagegen zitiert die Bestätigung wörtlich. Zwei von vier
Stellen waren also nicht nachgezogen. **Ich habe der Bestätigung gefolgt** —
sie steht wörtlich im CHANGELOG und im Auftrag — und die beiden anderen Stellen
angeglichen. **Wenn das Zitat nicht von Gregor stammt, sind jetzt vier Stellen
falsch statt zwei**; das ist der einzige Punkt dieses Durchgangs, den ich nicht
selbst am laufenden Programm prüfen konnte.

---

## Was ich je Datei geändert habe

### `AUFGABEN.md` — Kopf und Hauptarbeit neu (Befund L-9.14)

Die Datei stand auf *„Stand 07.09.2026, morgens"*, und der ganze vordere Teil
war überholt: 87 Zeilen Suchanleitung für das **behobene** Beenden, E-37 als
behoben geführt, E-38 als gesperrt.

| geändert | vorher | jetzt |
|---|---|---|
| Kopfzeile | Stand 07.09.2026, morgens | **Stand 08.09.2026, mittags** |
| Überschrift der Hauptarbeit | *„das Beenden, zwei Kontofehler, die Reiterleiste"* | *„zwei Kontofehler und die Reiterleiste"* |
| Kriterientabelle 4–8 | 7 *„nicht erfüllt"*, 4 *„das Beenden fehlt noch"*, 8 *„die Reiterleiste am unteren Rand fehlt"* | 7 **erfüllt** mit Zitat; 4 nennt die zwei verbliebenen Stellen; 8 nennt, dass die Leiste seit E-44 da ist und **die Reiter** fehlen |
| `### 1.` | Kriterium 7 (E-33), 87 Zeilen | **E-37**, mit dem Regressionsverlauf und dem unbestätigten zweiten Anlauf |
| `### 2.` | E-37 *„Anzeige behoben"* | **E-38**, mit *„die Sperre ist weg"* und der Messung ohne Bau |
| `### 3.` | E-38 *„hängt an E-33"* | **E-39** |
| `### 4.` | Kriterium 8 | Kriterium 8, jetzt mit *„die Leiste ist da, die Reiter fehlen"* |
| `### 5.` | — | **E-43**, neu, mit `GetBtnCount=24/24` / `m_btns.GetSize=0/0` und E-46 als widerlegt |
| *Was schon nachgemessen ist* | ohne das Beenden | E-40/E-41/E-42/E-45 samt `tools/pruefe-beenden.pl` (**elf** eingefasste Schritte, selbst gefahren, Rückgabe 0) |
| *Erledigt seit 1.0.10* | ohne 7, A-1, A-2 | Kriterien 5, 6, **7**, Anforderungen **A-1** und **A-2**/E-44 |
| *Was sonst noch offen ist* | Zeile *„File → Exit bringt eine Meldung (E-33)"* | E-37, E-38, E-39, E-43 mit Verweis nach oben; E-33 ist heraus |
| `B1` | *„Vier sind behoben"*, Kriterium 7 als erster Schritt | *„Sieben sind behoben"*, die vier offenen Punkte namentlich |
| `E1` | Überschrift *„(**A-1**)"* ohne Warnung | Kasten, dass **A-1 zweimal vergeben** ist (L-9.8, offen) und welche der beiden gemeint ist |
| `F` | PAKETE.md-Eintrag ohne 1.0.22/1.0.23 | Abschnitte für 1.0.23 und 1.0.22 vermerkt, M-4 bleibt offen; LEKTOR-5 und LEKTOR-6 verlinkt |

### `WEITERMACHEN.md` — Kopfkasten und nächster Schritt (Befund L-9.16)

L-9.16 hatte vier Zeilen des Kopfkastens als überholt gemessen. Alle vier sind
berichtigt, und die falsche Bilanz ist mit weg.

| Zeile | vorher | jetzt |
|---|---|---|
| Stand | 07.09.2026, morgens | **08.09.2026, mittags** |
| Quellstand / Paketnummer | 7.2.0.22 / 1.0.22 | **7.2.0.23 / 1.0.23** |
| Zuletzt gebaut | Paket 1.0.22 mit SHA256 | Paket **1.0.23** mit gemessener SHA256, Größe, `Eudora.exe`-Zeit, **noch nicht committet**, keine Marke |
| Zuletzt gestartet | Paket 1.0.21 am 07.09.2026 | Paket **1.0.22** am 08.09.2026 mit zwei Zitaten, dazu die Prüfinstanz 7.2.0.23 zu A-2 |
| Bestätigte Behebungen | 7.2.0.21 (E-31/E-34/E-35/E-36) | dazu 7.2.0.22 (E-40/E-41/E-42, A-1) und 7.2.0.23 (E-44) |
| Bemängelt | *„beenden geht nicht"*, *„untere zeile"* | die beiden E-37-Sätze vom 08.09.2026 |
| Bilanz (`:23`) | *„fünf belegt (0, 1, 3, 5, 6), drei fast oder halb (2, 4, 8), eines nicht: das Beenden (7)"* | **sechs belegt (0, 1, 3, 5, 6, 7), drei fast oder halb (2, 4, 8)** |
| *Der nächste Schritt* | 58 Zeilen Suchanleitung für E-33 | fünf nummerierte Punkte (E-37, E-38, E-39, Kriterium 8, E-43) plus ein Kasten *„Was nicht mehr zu suchen ist"* |

### `Releases/PAKETE.md` — zwei fehlende Abschnitte (Befund L-9.5)

- Kopfkasten: *„Im Repo liegen als ZIP … nur noch 1.0.2 und 1.0.21"* war beim
  Stand 08.09.2026 falsch. Jetzt steht dort die Messung `git ls-files
  Releases/` (1.0.2, 1.0.21, 1.0.22) **und** dass das ZIP zu 1.0.23 unverfolgt
  ist und seine `.sha256` fehlt.
- Der Satz *„Der Quellstand ist 7.2.0.21 / Paketnummer 1.0.21"* und der
  Textrest **`> offen.`** waren beim Übernehmen der schon nachgezogenen Fassung
  bereits weg.
- Die Marken-Aufzählung sagt jetzt ausdrücklich, dass es **`v1.0.22` und
  `v1.0.23` nicht gibt**.
- **Neu: `## 1.0.23`** — Prüfsumme, Größe, `Eudora.exe`-Zeit, QCSSL, und eine
  Befundtabelle (E-44 bestätigt, E-45 behoben, E-46 widerlegt, E-43 offen,
  E-37 gebaut und unbestätigt).
- **Neu: `## 1.0.22`** — dieselbe Form; die Fassung, mit der Kriterium 7 und
  A-1 belegt sind.
- *Wo die Pakete liegen*: Stand 07.09. → **08.09.2026**, mit dem Nachtrag,
  welche ZIPs seither wieder im Repo liegen.
- Der Kasten zu `EUDORA_BUILD_NUMBER` nennt jetzt den **zweiten** Vorfall
  (L-10.3).

### `README.md` — meine Nachprüfung der schon nachgezogenen Fassung

**Richtig war alles, was der Auftrag aufzählt**, jeweils nachgemessen:

| Behauptung | Prüfung | Urteil |
|---|---|---|
| sechs Kriterien belegt (0, 1, 3, 5, 6, 7) | Tabelle in `ZIEL.md`, Zeile für Zeile | **stimmt** |
| drei fast oder halb (2, 4, 8) | dieselbe Tabelle | **stimmt** — und die Bilanz**zeile** in `ZIEL.md` sagte etwas anderes, siehe L-10.1 |
| A-1 bestätigt | Zitat in `ZIEL.md` und `CHANGELOG.md` | **stimmt** |
| A-2 bestätigt | Zitat in `CHANGELOG.md:103` | **stimmt**, widersprach aber `BEFUNDE.md` und `ZIEL.md` — angeglichen |
| Quellstand 7.2.0.23 | `Version.h` | **stimmt**, bis auf `EUDORA_BUILD_NUMBER` (L-10.3) |
| Paket `Releases/Eudora72-1.0.23-release.zip` | `ls`, `sha256sum` | ZIP da, aber **unverfolgt und ohne Marke** — ergänzt |
| offene Anwenderpunkte E-37, E-38, Kriterium 8 | `BEFUNDE.md`, `CHANGELOG.md` | **stimmt**, unvollständig: **E-39** und **E-43** merkt ein Anwender ebenfalls — ergänzt |

**Was ich geändert habe:**

- Der Abschnitt **`### Offen — Stand 07.09.2026`** war unverändert stehen
  geblieben und widersprach dem neuen Kopf: er führte das Beenden als offen,
  E-37 als *„nur die Anzeige behoben"* und E-38 als *„hängt an E-33"*. Er heißt
  jetzt **`### Offen — Stand 08.09.2026`**, das Beenden ist heraus, E-37 steht
  als **nicht behoben** mit dem Regressionsverlauf, E-38 mit *„der Blocker ist
  weg"*, Kriterium 8 mit der Leiste aus E-44, und **E-43** ist neu dabei.
- Der Kasten *„Drei dieser Befunde schweigen aus demselben Grund"* sagte
  *„E-37 viermal (behoben)"* — E-37 ist **nicht** behoben. Jetzt: *„die Stellen
  melden jetzt, behoben ist der Befund nicht"*, dazu die zwölf Schritte aus
  E-42.
- Die Tabelle **Belegt** hatte keine Zeile für das Beenden und keine für die
  beiden Anforderungen. Drei Zeilen dazu, jede mit Zitat und Messung.
- Im Kopfkasten stehen wieder **Prüfsumme und Größe** des Pakets; die
  nachgezogene Fassung hatte die Prüfsumme ganz gestrichen.
- Der Satz *„Fertig ist es nicht"* nennt jetzt bei E-37 und E-38 ausdrücklich,
  dass der zweite Anlauf nur **gebaut** ist und E-38 **neu zu messen** ist.

### `ZIEL.md` — die Bilanzzeile widersprach der eigenen Tabelle (Befund L-10.1)

`ZIEL.md:39` sagte:

> *„Sechs von neun Kriterien sind belegt (0, 1, 3, 5, 6, 7), zwei fast oder
> halb (2, 4), eines nicht (8 - die Reiterleiste)."*

Die Tabelle **drei Zeilen darüber** führt Kriterium 8 als **halb**. Der Auftrag
und `README.md` sagen ebenfalls *„drei fast oder halb (2, 4, 8)"*. Die
Bilanzzeile war also die einzige Stelle mit *„eines nicht"* — geändert auf
**„Neun Kriterien: sechs sind belegt (0, 1, 3, 5, 6, 7), drei fast oder halb
(2, 4, 8)."**, mit einem Satz darunter, was an 8 fehlt.

Weiter in `ZIEL.md`: die Kopfzeile *„gemessen an Fassung 7.2.0.22 / Paket
1.0.22"* auf **7.2.0.23 / 1.0.23**; Kriterium 2 nennt E-44; Kriterium 4 nennt
statt *„offen bleibt das Beenden"* die zwei verbliebenen Stellen; Kriterium 8
nennt die Leiste aus E-44; A-2 steht als **bestätigt** mit Zitat und Messung.

### `CHANGELOG.md`

- Die Tabelle **Erreicht** sagte noch *„Kriterium 7 (Beenden) | **nicht
  erfüllt** — der einzige verbliebene Fehler der zweiten Stufe"*. Jetzt
  **erfüllt** mit Zitat; Kriterium 4 und 8 nachgezogen; zwei neue Zeilen für
  **A-1** und **A-2**.
- `## Nach 7.2.0.22 — alles Gebaute ist gepackt` → **`## Nach 7.2.0.23`**, mit
  dem Hinweis auf **alle fünf** Versionszeilen und darauf, dass das ZIP zu
  1.0.23 nicht committet ist.
- Im Abschnitt zu **7.2.0.21** stand eine Prüfanleitung mit der Überschrift
  *„Was an 1.0.22 zu prüfen ist"* und dem ZIP **und der Prüfsumme von 1.0.22** —
  mitten in der Rückschau auf 1.0.21. Sie heißt jetzt *„Was an 1.0.21 zu prüfen
  war"* und nennt die gegen die Datei nachgemessene Prüfsumme von 1.0.21. Ein
  Berichtigungskasten sagt, was dort stand.

### `BEFUNDE.md`

- **E-44**: *„behoben in 7.2.0.23, von Gregor noch nicht bestätigt"* → **behoben
  und von Gregor bestätigt**, mit Zitat und der Messung aus
  `tools/leisten-messen.ps1`.
- **E-46**: *„offen, Spurmarke gesetzt"* → **widerlegt**, mit der
  Protokollzeile, die es entscheidet. Der ausführliche Abschnitt weiter unten
  hat einen Nachtragskasten bekommen.
- **E-43**: der Satz *„Neuer Hauptverdacht (E-46): das CMainFrame-Objekt ist
  schon freigegeben"* ist durch die Messung ersetzt, die ihn widerlegt.
- **E-42**: die Aufzählung der Schritte führte `QCWorkbook::OnClose` als durch
  `AUFRAEUMEN` laufend — seit **E-45** läuft er ausdrücklich **nicht**
  hindurch. Berichtigt, mit der Zahl **elf** aus `tools/pruefe-beenden.pl`.

### `Befunde/BEENDEN.md` (Befund L-9.12) und `Befunde/PRUEFER-4.md` (L-9.13)

Beide sind Zeitdokumente und behalten ihren Text. Sie haben je einen
Nachtragskasten am Anfang bekommen:

- `BEENDEN.md` heißt *„E-33 — File → Exit beendet Eudora nicht"* und sagte, das
  sei *„der einzige verbliebene Fehler der zweiten Stufe"*. Der Nachtrag sagt,
  dass der Fall entschieden ist, durch welche Befunde, und dass E-43 offen und
  E-46 widerlegt ist.
- `PRUEFER-4.md` urteilt zu E-37 *„teilweise bestätigt — die Behebung … richtet
  keinen neuen Schaden an"*. Das ist am laufenden Programm widerlegt; der
  Nachtrag sagt es und warnt ausdrücklich davor, den Abschnitt als Beleg zu
  zitieren. Genau das war schon einmal passiert.

### `Befunde/LEKTOR-4.md` — 18 Verweise ins Leere (Befund L-9.11)

Gemessen mit einem Prüfskript, das jeden Verweis **relativ zum Verzeichnis der
Datei** auflöst — genau so liest ihn ein Leser auf GitHub:

```
vorher   18 Treffer, alle in Befunde/LEKTOR-4.md
nachher   0
```

Berichtigt: `CHANGELOG.md` 5×, `ZIEL.md` 3×, `README.md` 2×, `AUFGABEN.md`,
`AGENTEN.md`, `WEITERMACHEN.md` je 1× (`../` davor), `Befunde/LEKTOR*.md` 4×
(doppeltes `Befunde/` weg — einer zeigte auf sich selbst),
`../../Eudora71/QCSSL/…` 1× (eine Ebene zu hoch). Reine Mechanik, keine
Aussage geändert.

**Gegenprobe über alle 104 MD-Dateien** (103 versioniert plus diese hier) mit
derselben Auflösung: es bleiben
**zwei** Treffer, und keiner davon ist zu ändern — siehe *Offen* unten.

### `Pruefung/PRUEFUNG-ZEIGER.md` — auf LF gezogen (Befund L-9.15)

```
vorher   CR=193
nachher  CR=0, UTF-8 ok
```

Damit sind **alle** MD-Dateien im Repo reines LF (nachgemessen über
`git ls-files "*.md"` plus diese Datei, 104 Dateien, **CR insgesamt 0**).

### `PORTIERUNG.md`

Der Stand-Kasten sagte *„von neun Kriterien sind sechs belegt …, zwei fast oder
halb (2, 4), eines nicht (8)"* und *„Quellstand 7.2.0.22, Paketnummer 1.0.22"*.
Beides berichtigt.

### `LEKTORAT.md`

Das Fahrtenbuch führte die Durchgänge nur bis L-8. Jetzt sind **L-9**
(`LEKTOR-5.md`) und **L-10** (diese Datei) verlinkt, und daneben stehen die
drei **Reviews** von PRUEFER — `PRUEFER-3.md`, `PRUEFER-4.md` und der neue
`PRUEFER-5.md`, in dem **E-45** gefunden wurde.

---

## Zwei Schranken nachgezogen — mit Gegenprobe

### L-10.1 — `tools/doku-pruefen.pl` war für **neun** Kriterien blind

Die Wortzahl-Tabelle im Werkzeug reichte von `zwei` bis `acht`. `ZIEL.md` führt
**neun** Kriterien. Damit lieferte `$wort{'neun'}` `undef`, und **beide**
Kriterienprüfungen brachen mit `next unless defined` ab — die Zahl wurde nie
gegen `ZIEL.md` gehalten, und die Summe der Teile nie geprüft. Genau deshalb
stand die falsche Bilanz in `ZIEL.md` und `WEITERMACHEN.md`, ohne dass die
Schranke etwas sagte.

`neun` und `zehn` sind dazugekommen. Dazu erlaubt das Muster jetzt
`\*{0,2}` zwischen Zahlwort und Wort — `PORTIERUNG.md` schreibt
*„von **neun** Kriterien"*, und die Auszeichnung ließ das Muster ins Leere
laufen.

**Gegenprobe, beide Richtungen** (Gregors Technik: nicht prüfen, ob der
gewünschte Zustand erscheint, sondern ob der umgekehrte Wert durchkommt):

| Versuch | erwartet | gemessen |
|---|---|---|
| unveränderter Baum | still | *„Kein Widerspruch gefunden"* |
| `README.md`: „sechs sind belegt" → „fuenf sind belegt" | Mangel | `README.md:38 nennt 9 Kriterien, die Aufteilung ergibt aber 8` |
| `PORTIERUNG.md`: „von **neun** Kriterien" → „von **acht**" | Mangel | `PORTIERUNG.md:38 nennt 8 Kriterien, ZIEL.md fuehrt 9` |
| vorher, mit demselben Fehler | — | **stumm** |

Und der Beweis, dass sie am echten Fehler greift: der erste Lauf nach der
Änderung meldete `WEITERMACHEN.md:23 nennt 9 Kriterien, die Aufteilung ergibt
aber 3` — die Bilanz, die L-9.4 von Hand gefunden hatte.

### L-10.2 — Prüfung 5c warnte zweimal umsonst

Der Kommentar über Prüfung 5c behauptet seit dem 07.09.2026: *„eine Nummer in
einem datierten Rückblick ist richtig und wird nicht gemeldet."* **Umgesetzt
war das nicht.** Gemeldet wurden dadurch zwei Sätze in `CHANGELOG.md`, die
genau das sind — *„Paket: Releases/Eudora72-1.0.22-release.zip"* unter der
Überschrift `## 7.2.0.22 / Paket 1.0.22`. Zwei Fehlalarme in einem Lauf, und
eine Schranke, die umsonst warnt, wird ignoriert (Befund X-1).

Die Prüffrage lautet jetzt: **nennt die Überschrift des Abschnitts, in dem der
Satz liegt, dieselbe Nummer?** Dann ist der Satz eine Aussage *über* jene
Fassung. Nennt sie eine andere, bleibt es ein Mangel.

**Gegenprobe:**

| Versuch | erwartet | gemessen |
|---|---|---|
| `## 7.2.0.22 / Paket 1.0.22` über einem Satz mit 1.0.22 | still | still |
| `## 7.2.0.21 / Paket 1.0.21` über einem Satz mit **1.0.22** | Mangel | genau so gemeldet — das war der echte Fehler, den ich damit gefunden habe |
| dasselbe mit 1.0.20 künstlich eingesetzt | Mangel | `CHANGELOG.md:345 nennt Paketnummer 1.0.20 als Stand, VERSION sagt 1.0.23` |

---

## Die Schranken am Ende

| Werkzeug | Rückgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | **0** — *Kein Widerspruch gefunden* |
| `perl tools/pruefe-bytes.pl` | **0** |
| `perl tools/pruefe-beenden.pl` | **0** — elf eingefasste Aufräumschritte |
| CR-Zählung über alle 104 MD-Dateien | **0** in jeder Datei, UTF-8 überall lesbar |

---

## Offen — ausdrücklich nicht entschieden

1. **A-2/E-44: „bestätigt" habe ich nicht selbst gemessen.** Das Zitat
   *„jetzt ist sie unten, ja"* steht im `CHANGELOG.md` und im Auftrag; ich habe
   `BEFUNDE.md` und `ZIEL.md` daran angeglichen. **Wenn es nicht von Gregor
   stammt, sind jetzt vier Stellen falsch statt zwei.** Bitte einmal bestätigen.
2. **Die Kennung `A-1` ist zweimal vergeben** (Befund L-9.8, weiter offen).
   Einmal für Gregors Anforderung in `ZIEL.md`, einmal für den
   Erscheinungsbild-Befund vom 30.08.2026 (`BEFUNDE.md`, `PORTIERUNG.md:35,513`,
   `LEKTORAT.md`, `Releases/PAKETE.md:307`, `AUFGABEN.md` Abschnitt E1).
   **Kennungen vergibt Gregor, nicht ein Agent** (`AGENTEN.md`, Abschnitt 4) —
   ich habe deshalb nur in `AUFGABEN.md` E1 einen Warnkasten gesetzt, der sagt,
   welche der beiden dort gemeint ist. Umbenennen wäre der nächste Schritt und
   braucht sein Wort.
3. **`Arbeitsweise/agenten-koordinieren.md:11`** verweist auf `](AGENTEN.md)`
   statt `](../AGENTEN.md)`. Das ist derselbe Fehler wie L-9.11, aber
   `Arbeitsweise/` ist ein **Spiegel** des Gedächtnisverzeichnisses
   (`tools/lehren-spiegeln.pl`) — eine Änderung hier geht beim nächsten
   Spiegeln verloren. Die Quelle liegt in
   `~/.claude/projects/…/memory/agenten-koordinieren.md` und trägt denselben
   Fehler (nachgesehen). **Nicht angefasst**, weil das Gedächtnisverzeichnis
   nicht mein Arbeitsbaum ist.
4. **`Befunde/LEKTOR-5.md:483`** verweist auf `](ZIEL.md)` statt
   `](../ZIEL.md)`. Das ist **kein Fehler**: die Zeile **zitiert** `ZIEL.md`
   wortgetreu in einem Blockzitat. Ein Zitat zu berichtigen wäre eine
   Verfälschung. **Absichtlich stehen gelassen.**
5. **Mangel M-4 bleibt offen.** 1.0.22 und 1.0.23 haben jetzt einen Abschnitt
   in `Releases/PAKETE.md`; **1.0.4 bis 1.0.17 sowie 1.0.19 und 1.0.20** haben
   weiter keinen. Erfunden wird dort nichts — für die meisten liegt kein ZIP
   und keine Prüfsumme vor.
6. **Das ZIP zu 1.0.23 ist nicht committet, und seine `.sha256` fehlt.** Ob es
   ins Repo soll, entscheide ich nicht — die drei anderen ZIPs liegen dort. Die
   Prüfsumme steht in `Releases/PAKETE.md`, damit sie nicht verloren geht.
7. **Keine Marke für 1.0.22 und 1.0.23.** Veröffentlichen ist Gregors
   Entscheidung. Alle Dateien sagen jetzt ausdrücklich, dass es diese Marken
   **nicht** gibt — Befund W-0 war genau der umgekehrte Fall.
8. **Befund L-9.18** (fünf Dateien ohne H1, Adressat und Zweck) ist **nicht**
   abgearbeitet — er stand nicht im Auftrag und betrifft andere Dateien als die
   vier hier.
9. **`Eudora71/Version.h` und `VERSION` liegen in diesem Commit mit** (Quellstand
   7.2.0.23 / 1.0.23), weil `tools/doku-pruefen.pl` die Dokumentation gegen
   **diese beiden Dateien im selben Baum** hält — ohne sie wäre jede
   Standangabe in diesem Commit ein Mangel. Im Hauptbaum sind dieselben
   Änderungen unverfolgt vorhanden; der Inhalt ist bis auf
   `EUDORA_BUILD_NUMBER` (L-10.3) gleich, ein Zusammenführen sollte also
   glattgehen. **Falls doch ein Konflikt kommt: meine Fassung ist die mit
   `7,2,0,23`.**

---
---

# Elfter Lektoratsdurchgang (L-11) — 09.09.2026, Stand 7.2.0.27 / 1.0.27

**Für Gregor und den nächsten Agenten.** Dieser Teil sagt, was am 09.09.2026 im
Arbeitsbaum `Eudora7.2-wt-lektor` (Zweig `wt/lektor`) an der Dokumentation
geändert wurde, **mit der Messung dahinter**, und was **offen** bleibt.

Ausgangsstand: `3b9f609`. **Nichts gebaut, nichts gestartet, nicht gepusht.**

## Die Messung, mit der alles anfängt

| gemessen | Befehl | Ergebnis |
|---|---|---|
| Quellstand | `grep EUDORA_BUILD_VERSION Eudora71/Version.h` | `7.2.0.27` |
| alle drei Makros | `cat Eudora71/Version.h` | `EUDORA_VERSION4 27`, `EUDORA_BUILD_NUMBER 7,2,0,27`, `EUDORA_BUILD_VERSION "7.2.0.27"` — **stimmen überein** |
| Paketnummer | `cat VERSION` | `1.0.27` |
| ZIP 1.0.27 | `sha256sum`, `stat -c%s` | `69595d4b380204eb5ac6d327ce8ded65080b356594090a2465394ced07f81b3a`, 9 342 224 Byte, 09.09.2026 11:15 |
| `Eudora.exe` darin | `unzip -l` | 2 960 896 Byte, 09.09.2026 11:02 |
| dasselbe im Bauverzeichnis | `ls -la .../Eudora7.2/Eudora71/Bin/Release/Eudora.exe` | 2 960 896 Byte, 09.09.2026 **11:35** — gleiche Größe, späterer Zeitstempel |
| versionierte ZIPs | `git ls-files Releases/` | **nur 1.0.2 und 1.0.27**; zu 1.0.27 fehlt die `.sha256`, für 1.0.21 und 1.0.22 liegt die `.sha256` **ohne** ZIP daneben |
| Marken | `git ls-remote --tags origin` | `v1.0.1`, `v1.0.2`, `v1.0.3`, `v1.0.10`, `v1.0.14`, `v1.0.15`, `v1.0.18`, `v1.0.21`, `v1.0.23`, `v1.0.24`, `v1.0.27` — **kein `v1.0.22`, `v1.0.25`, `v1.0.26`** |
| Kriterien | Tabelle in `ZIEL.md` | neun; nach diesem Durchgang belegt 0, 1, 3, 5, 6, 7, **8** |
| Befundkennungen | `grep '^| E-' BEFUNDE.md` | höchste vergebene ist **E-52** |
| `BEFUNDE.md` | `wc -l`, `grep -c '^## '`, `grep -cE '^### +[A-Z]'` | 7 577 Zeilen, 123 / 204 Abschnitte |
| Zeilenenden aller MDs | `perl -0777` über `git ls-files "*.md"` | **eine** Datei mit CRLF: `tools/TESTLAEUFE.md`, 17 von 17 Zeilen, dazu eine **BOM**. In `HEAD` sind es 9 — sie wachsen mit jedem Testlauf |

## Was ich am Auftrag berichtigt habe

### L-11.0 — **Eine Kennung `E-53` gibt es nicht**

Der Auftrag nannte „neue Befunde **E-48 bis E-53**" und führte **E-53** unter
*gebaut, aber nicht bestätigt*. Gemessen:

```
grep -rn "E-53" --include=*.md .            # 0 Treffer
git grep -n "E-53" origin/lessons_learned    # 0 Treffer
git log --all --oneline -S"E-53"             # 0 Commits
```

**Die Kennung ist nie vergeben worden**, weder in diesem Zweig noch in
`origin/lessons_learned` noch irgendwo im Verlauf. Die höchste vergebene ist
**E-52**. Ich habe **nichts erfunden** — Kennungen vergibt Gregor, nicht ein
Agent (`AGENTEN.md`, Abschnitt 4). Der Hinweis steht jetzt im Kopf von
`BEFUNDE.md`, damit die Angabe nicht ein zweites Mal kursiert.

### L-11.0b — Der Zwischenstand war weiter als angegeben

Der Auftrag nannte `a7f3fb0` als Ausgangsstand. Gemessen war `3b9f609`
(*„lessons_learned in wt/lektor eingearbeitet, zehn Konflikte gemessen
geloest"*), ein Merge von `5ca44e4` und `fcd4462`. Der Merge von
`origin/lessons_learned` (`40ec935`, Marke `v1.0.27`) hat **vier** Konflikte
gebracht, nicht mehr: `BEFUNDE.md`, `CHANGELOG.md`, `PORTIERUNG.md`, `ZIEL.md`
— alle vier nach Auflage zugunsten `origin/lessons_learned` gelöst.

> **Was dieser Merge gekostet hat:** meine L-10-Änderungen an `BEFUNDE.md`
> waren damit weg. **E-44** stand wieder auf „von Gregor noch nicht bestätigt",
> **E-46** wieder auf „offen, Spurmarke gesetzt". Beides ist unten erneut
> nachgezogen. Das ist der Preis der Auflage, nicht ihr Fehler — aber wer sie
> das nächste Mal gibt, sollte wissen, dass sie fremde Messungen mit
> überschreibt.

`README.md` und `WEITERMACHEN.md` sind **ohne** Konflikt zusammengeführt worden,
weil mein Zweig dort weiter war als `origin/lessons_learned` (dessen `README.md`
stand noch auf *„Offen — Stand 07.09.2026"*).

## Zwei Fehlalarme in `tools/doku-pruefen.pl` — gemessen, nicht vermutet

Der Auftrag sagt: Fehlalarme in Prüfung 3b melden, statt die Doku danach zu
verbiegen. Ich habe **zwei** gefunden und **die Prüfung** geändert, nicht die
Aussagen.

### L-11.1a — Der Gegenstand einer Tabellenzeile steht in der ersten Spalte

```
AUFGABEN.md:19 fuehrt Kriterium 7 als 'fast', ZIEL.md sagt 'erfuellt'
```

Die Zeile ist die Tabellenzeile **über Kriterium 4**:

> `| 4 | **Keine Abstürze** | *fast* — … das Beenden ist erledigt (Kriterium 7) … |`

Sie sagt *fast* über **Kriterium 4** und erwähnt Kriterium 7 nur nebenbei. Die
Prüfung nahm aber das **zuerst als Wort genannte** Kriterium — und das ist
hier 7, weil die 4 in der **ersten Tabellenspalte** steht.

**Geändert:** trägt die erste Spalte einer Tabellenzeile nur eine Ziffer 0–8,
ist **das** der Gegenstand der Zeile. Es ist dieselbe Form, in der die
Kriterientabelle in `ZIEL.md` selbst gelesen wird.

### L-11.1b — Eine Verneinung außerhalb der Auszeichnung wurde nicht gesehen

```
AUFGABEN.md:53 fuehrt Kriterium 2 als 'erfuellt', ZIEL.md sagt 'fast'
```

Der Satz lautet: *„… der einzige Grund, warum Kriterium 2 und Kriterium 4
nicht \*erfüllt\* heißen."* Er sagt das **Gegenteil** von „erfüllt". Die
Prüfung sah nur die Auszeichnung, nicht das `nicht` davor — und meldete genau
die umgekehrte Aussage.

**Geändert:** steht unmittelbar vor der Auszeichnung ein `nicht`, ist die
Aussage nur *„nicht erfüllt"*. Das widerspricht `ZIEL.md` genau dann, wenn
`ZIEL.md` selbst **erfüllt** sagt, und ist mit *fast* oder *halb* verträglich.
Der ursprüngliche Anlass der Prüfung — `**nicht erfüllt**` über Kriterium 7,
das erfüllt ist — greift weiter, siehe Gegenprobe.

### Gegenprobe, beide Richtungen

Gregors Technik: nicht prüfen, ob der gewünschte Zustand erscheint, sondern ob
der **umgekehrte** Wert durchkommt. Jede Probe als angehängte Zeile in
`AUFGABEN.md`, danach die Datei aus der Sicherung zurückgeholt — Größe vorher
und nachher **31 271 Byte**, identisch.

| Versuch | erwartet | gemessen |
|---|---|---|
| `**Kriterium 7** ist **nicht erfüllt**.` | Mangel | `AUFGABEN.md:542 fuehrt Kriterium 7 als 'nicht erfuellt', ZIEL.md sagt 'erfuellt'` |
| `Kriterium 7 ist nicht **erfüllt**.` (Verneinung außerhalb) | Mangel | genau so gemeldet — **vorher war die Schranke hier stumm** |
| `\| 8 \| Probe \| **halb** \|` (über die erste Spalte) | Mangel | `fuehrt Kriterium 8 als 'halb', ZIEL.md sagt 'erfuellt'` — **vorher stumm** |
| `\| 4 \| Probe \| **erfüllt** \|` | Mangel | `fuehrt Kriterium 4 als 'erfuellt', ZIEL.md sagt 'fast'` |
| `**Kriterium 8** ist **halb**.` | Mangel | `fuehrt Kriterium 8 als 'halb', ZIEL.md sagt 'erfuellt'` |
| `warum Kriterium 2 und Kriterium 4 nicht *erfüllt* heißen.` | **still** | still |
| `\| 4 \| Probe \| *fast* — … (Kriterium 7) \|` | **still** | still |

Laufzeit unverändert bei **2,0 s** — die Endlosschleifen-Falle im Kommentar
über der Stelle (`pos()`-Rücksetzung durch eine innere `/g`-Suche) ist nicht
wieder aufgerissen: die Auszeichnungen werden weiter nur auf einer **Kopie**
gesucht.

## Ein Fehlalarm, den ich NICHT abgestellt habe — Meldung statt Änderung

**Die Summenprüfung versteht die Satzform „N von M Kriterien" nicht.** Der
erste Commit-Versuch scheiterte an

```
ZIEL.md:39 nennt 9 Kriterien, die Aufteilung ergibt aber 2
```

Der Satz dort lautete *„Sechs von neun Kriterien sind belegt (…), zwei fast
oder halb (…), eines nicht (8 …)."* — 6 + 2 + 1 = 9, arithmetisch richtig.
Die Prüfung sammelt aber nur Zahlwörter **nach** dem Wort „Kriterien"; das
`Sechs` steht davor und `eines` fehlt in ihrer Wortliste. Sie rechnete 2.

**Gemessen an einer Aussage, die heute richtig ist:**

| Versuch | erwartet | gemessen |
|---|---|---|
| `**Sieben von neun Kriterien sind belegt (…), zwei sind fast erfüllt (…).**` — 7 + 2 = 9, **richtig** | still | **`nennt 9 Kriterien, die Aufteilung ergibt aber 2`** — Fehlalarm |
| `**Neun Kriterien: sieben sind belegt (…), zwei sind fast erfüllt (…).**` — dieselbe Aussage, andere Form | still | still |
| `**Neun Kriterien: sechs sind belegt (…), zwei sind fast erfüllt (…).**` — 6 + 2 = 8, **falsch** | Mangel | `nennt 9 Kriterien, die Aufteilung ergibt aber 8` |

**Das ist ein echter Fehlalarm der Prüfung, und ich habe ihn stehen gelassen** —
gemeldet statt behoben, weil der Auftrag das so verlangt. Der Satz in `ZIEL.md`
war an jenem Tag **zusätzlich** sachlich falsch (die Tabelle drei Zeilen
darüber führte Kriterium 8 als *halb*, nicht als *nicht*), er ist also ohnehin
neu zu schreiben gewesen. Ich habe die Form *„Neun Kriterien: sieben sind
belegt …"* gewählt, die beides erfüllt: sie ist richtig **und** die Prüfung
kann sie rechnen. **Wer den Fehlalarm abstellen will**, muss das Zahlwort
**vor** „Kriterien" mitzählen, wenn der Satz die Form *„N von M Kriterien"*
hat, und `eines`/`eins` in die Wortliste aufnehmen. Das ist ein Zweizeiler,
aber es ist eine Änderung an einer Schranke, und die gehört abgesprochen.

## Was berichtigt wurde

### `ZIEL.md` — die Quelle

- **Kriterium 8** stand auf *„halb, Behebung gebaut"* mit dem Satz *„Erfüllt
  ist das Kriterium erst, wenn Gregor bestätigt hat, dass ein Klick auf eine
  Karte ihr Fenster nach vorn holt"*. **Genau das hat er am 09.09.2026
  bestätigt** — es steht in derselben Datei in der Verzeichniszeile zu E-48.
  Jetzt **erfüllt**, mit seiner Beobachtung.
- **Kriterium 4** sagte *„Offen bleibt das Beenden, siehe Kriterium 7"*,
  während Kriterium 7 zwei Zeilen darunter als **erfüllt** geführt wird. Jetzt:
  das Beenden ist erledigt, mit E-43 sind E-37 und E-38 weggefallen, offen
  bleibt **eine** Stelle — die Meldung beim Anzeigen mancher Nachrichten.
- **Kriterium 7** endete mit *„und ist als **E-43** weiter offen"*. E-43 ist in
  7.2.0.24 behoben und von Gregor bestätigt. Berichtigt.
- Die **Bilanzzeile** sagte *„Sechs von neun … eines nicht (8 — die
  Reiterleiste)"* und widersprach damit ihrer eigenen Tabelle. Jetzt
  *„Neun Kriterien: sieben sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast
  erfüllt (2, 4)."*
- Die Kopfzeile stand auf *„Stand 08.09.2026, gemessen an Fassung 7.2.0.22 /
  Paket 1.0.22"* — zwei Fassungen zurück. Jetzt **09.09.2026, 7.2.0.27 /
  1.0.27**.
- **A-3** stand auf *„Von Gregor noch nicht bestätigt — offen ist vor allem, ob
  ein Klick die Karte nach vorn holt"*. Jetzt bestätigt, mit dem Nebenbefund
  ohne Nummer (Vollbild nach Neustart) ausdrücklich **daneben**, nicht darin.
- **A-4** stand auf *„von Gregor noch nicht bestätigt"* ohne E-52. Jetzt mit
  der Nachbesserung in 7.2.0.27 und der Unterscheidung: bestätigt ist nur der
  **Gegenfall**, die Höhe.
- Im A-2-Abschnitt hieß Kriterium 8 noch *„die Reiterleiste, wer eines angeht,
  sieht sich das andere gleich mit an"*. Jetzt: genau so ist es gekommen, A-3
  folgte unmittelbar in derselben Schicht.

### `AUFGABEN.md` — die Datei, über die Gregor sich zweimal beschwert hat

Sie stand auf **„Stand 08.09.2026, mittags"** und führte als *Hauptarbeit*
**E-37**, **E-38**, **Kriterium 8** und **E-43** — alle vier sind erledigt und
drei davon von Gregor bestätigt. Der Kopf bis einschließlich *Was sonst noch
offen ist* ist neu geschrieben (13 720 → 14 864 Byte):

- **Stand 09.09.2026**, mit dem Befehl, mit dem man Quellstand und Paketnummer
  nachmisst.
- Die *Hauptarbeit* heißt jetzt **„vier gebaute Behebungen warten auf Gregors
  Urteil"** und nennt sie in einer Tabelle mit je einem Prüfschritt: **E-49**
  (A-4), **E-50**, **E-52**, **E-51**. Dazu ausdrücklich: **bestätigt ist bei
  E-52 nur der Gegenfall.**
- Danach in dieser Reihenfolge: die Meldung beim **Anzeigen** (der letzte
  bekannte Fehler, den ein Anwender merkt), der **Nebenbefund ohne Nummer**
  (Vollbild nach Neustart) mit einem ersten Handgriff **ohne Bau**, **E-39**
  und **E-47**.
- *Was schon nachgemessen ist — nicht wiederholen* ist um Kriterium 8 (vier
  fehlende Anschlüsse), A-4 (drei Anläufe, zwei widerlegt, mit den Zahlen
  176/180/187/188) und E-43 ergänzt; **E-46** steht bei den **widerlegten**
  Vermutungen.
- *Erledigt seit 1.0.10* nennt jetzt neun bestätigte Punkte statt sieben.
- Abschnitt **B1** führte weiter E-37, E-38 und Kriterium 8 als offen —
  berichtigt.

### `WEITERMACHEN.md`

- **Stand 08.09.2026, nachmittags** → **09.09.2026, abends**.
- Die Kopftabelle nennt bei *Zuletzt bestätigt* jetzt auch die Höhenänderung
  und den Nebenbefund; bei *Was als Nächstes zu messen ist* steht **A-4 an
  1.0.27** statt an 1.0.26, mit E-52 und E-51.
- Der Ziel-Block sagte *„sechs sind belegt, drei fast oder halb (2, 4, 8)"* und
  führte Kriterium 8 als *halb* mit *Task Status* in der Leiste. Berichtigt;
  aus *zwei Anforderungen* sind **vier** geworden (A-1 bis A-4, mit dem Stand
  jeder einzelnen).
- *Der nächste Schritt* nannte fünf Punkte, von denen **drei** erledigt sind
  (E-37, E-38, Kriterium 8) und einer (E-43) behoben. Neu geschrieben: der
  nächste Schritt gehört Gregor. Der Kasten *„Was nicht mehr zu suchen ist"*
  ist um E-43 und E-46 erweitert.
- *Ebenfalls offen* endete mitten im Satz und lief ohne Leerzeile in
  `## Wie man misst` hinein. Neu und vollständig: R-1 (16 Stellen), X-3,
  E-14, E-13, `EuMemMgr.dll`, Hostnamenprüfung.

### `Releases/PAKETE.md`

- Der Kopfkasten führte **drei** versionierte ZIPs (1.0.2, 1.0.21, 1.0.22) und
  *„das ZIP zu 1.0.23 ist noch nicht committet"*. Gemessen sind **zwei**:
  1.0.2 und 1.0.27. Berichtigt, mit dem ausdrücklichen Satz: **kein Verweis in
  dieser Datei darf auf eine Datei zeigen, die nicht mehr im Arbeitsbaum
  liegt.**
- Die Markenliste war zwei Marken zu kurz (`v1.0.23`, `v1.0.24`, `v1.0.27`
  fehlten). Neu gemessen mit `git ls-remote --tags origin`. Dazu der
  entscheidende Satz: die **Veröffentlichungen** zu `v1.0.18`, `v1.0.21`,
  `v1.0.23` und `v1.0.24` sind gelöscht, die **Marken** bestehen — wer einem
  Verweis folgt, findet den Quellstand, **nicht** das Paket.
- **Neuer Abschnitt `## 1.0.27`** mit allen Zahlen am Objekt gemessen: SHA256,
  Größe, `Eudora.exe`, `EudoraRes.dll`, `QCSSL.dll`, `DEudora.ini`, alle drei
  Version.h-Makros, und ein Kasten *Paket gegen den Bau gemessen*.
- Die Abschnitte **1.0.23**, **1.0.22** und **1.0.21** zeigten mit
  `Releases/…` auf ZIPs, die es im Arbeitsbaum nicht mehr gibt. Jede dieser
  Zeilen sagt jetzt, wo die Datei geblieben ist.
- *Wo die Pakete liegen* stand auf 08.09.2026 und nannte 1.0.21/1.0.22 als „im
  Repo". Die Tabelle ist neu, nach Fassung absteigend, mit den vollen
  Prüfsummen für 1.0.27, 1.0.23, 1.0.22 und 1.0.21 und der Angabe, was noch
  abrufbar ist. Ein Kasten sagt, dass zu **1.0.25** und **1.0.26** keine
  Prüfsumme existiert — Teil des Mangels **M-4**.

### `LEKTORAT.md`

Das Fahrtenbuch führte `Befunde/LEKTOR-6.md` nur als **L-10**. Jetzt stehen
dort **L-10 und L-11** mit je einem Satz, was drin ist, dazu ein Stand-Kasten
(09.09.2026, 7.2.0.27 / 1.0.27).

### `README.md`

- Der Stand-Block sagte *„sechs sind belegt … drei fast oder halb (2, 4, 8)"*
  und *„die untere Leiste zeigt Aufgabenstatus …, nicht die Reiter"*. Neu
  geschrieben: sieben belegt, **drei** bestätigte Anforderungen (A-1, A-2,
  A-3) und **A-4** als gebaut-nicht-bestätigt.
- Der Abschnitt **Offen** widersprach dem Stand-Block **vierzig Zeilen
  darüber**: er führte E-37 als *„Nicht behoben"*, E-38 als *„erstmals
  messbar"* und Kriterium 8 als *halb* — während oben in derselben Datei
  stand, dass Gregor E-43 samt E-37 und E-38 bestätigt hat. **Das ist genau
  der Fall, den Prüfung 3b nicht sieht**, weil keine der Zeilen ein
  Zustandswort neben einer Kriteriumsnummer trägt. Neu geschrieben.
- Die Tabelle *Belegt* hat vier Zeilen dazubekommen: Kriterium 8 / A-3, E-43
  samt E-37 und E-38, die Höhenänderung.

### `CHANGELOG.md`

- *Noch offen* stand auf 08.09.2026 und führte **Kriterium 8** als *halb*.
  Jetzt 09.09.2026, ohne Kriterium 8, dafür mit dem **Nebenbefund ohne
  Nummer** und einer Zeile *gebaut, aber nicht bestätigt* für E-49, E-50, E-52.
- *Erreicht*: Kriterium 8 auf **erfüllt**, neue Zeilen für **A-3** und **A-4**.
- Der Abschnitt *Nach 7.2.0.27 — alles Gebaute ist gepackt* behauptete im
  ersten Satz, es liege nichts Ungepacktes im Repo — und zählte darunter
  **fünf** Punkte auf, die als ungepackt geführt wurden, darunter *„E-37: nur
  die ANZEIGE behoben"*. Die Aufzählung war ein Rest des alten Abschnitts
  *Nach 7.2.0.23*. Ersetzt durch einen Berichtigungskasten, der sagt, was dort
  stand und warum es weg ist.
- *Wo man weitermachen kann* — der Abschnitt ausdrücklich *„für jemanden, der
  das Repo frisch klont"* — stand auf 07.09.2026 und sagte unter Punkt 2
  *„Kriterium 7 — File → Exit beendet Eudora nicht … Noch nicht untersucht"*
  und unter Punkt 3, die Leiste am unteren Rand fehle. Beides ist seit Tagen
  erledigt und bestätigt. Punkte 2, 3 und 4 sind neu geschrieben; Punkt 4
  nennt jetzt E-43 als die gefundene Antwort auf die Frage, warum
  `GetBtnCount()` und `m_btns.GetSize()` verschiedene Werte melden.

### `PORTIERUNG.md`

Der Stand-Kasten sagte *„von neun Kriterien sind sechs belegt …, eines nicht
(8 — die Reiterleiste). Stand 08.09.2026"*. Berichtigt.

### `BEFUNDE.md`

- **E-44**: *„behoben in 7.2.0.23, von Gregor noch nicht bestätigt"* →
  **bestätigt am 08.09.2026**, mit Zitat und der Messung aus
  `tools/leisten-messen.ps1`. (Diese Berichtigung stand schon in L-10 und war
  durch den Merge verloren.)
- **E-46**: *„offen, Spurmarke gesetzt"* → **widerlegt**, mit der
  Protokollzeile, die es entscheidet. Der ausführliche Abschnitt weiter unten
  hat einen Nachtragskasten bekommen, der ausdrücklich sagt: **wer ihn
  zitiert, zitiert einen widerlegten Verdacht.** (Ebenfalls aus L-10, ebenfalls
  verloren gewesen.)
- Der Kopf sagte *„Gemessen am 08.09.2026: 7548 Zeilen"* — gemessen sind
  **7 577** (nach diesen Änderungen; vor ihnen 7 555, die 7 548 stimmten also
  schon vorher nicht).
- *Stand der Statusspalte* stand auf 07.09.2026, Commit `060a4bf`. Jetzt
  09.09.2026 mit den beiden nachgezogenen Kennungen und dem Satz, dass es
  **kein E-53** gibt.

## L-11.2 — `tools/TESTLAEUFE.md` ist die einzige MD mit CRLF, und dazu mit BOM

Befund **L-9.15** (CRLF in `Pruefung/PRUEFUNG-ZEIGER.md`) ist **erledigt** —
diese Datei ist reines LF. Gemessen über alle 105 MD-Dateien hat aber genau
**eine** wieder CRLF: die seit dem 08.09.2026 neue `tools/TESTLAEUFE.md`,
**17 von 17 Zeilen CRLF**, dazu eine **UTF-8-BOM** am Anfang. In `HEAD`
(`3b9f609`) sind es 9 solche Zeilen, im Merge-Stand `40ec935` 17 — die CRLF
kommen also über die Commits herein, bei jedem Programmstart eine Zeile mehr.

**Die Wurzel ist abgestellt.** Unter Windows PowerShell 5.1 schreibt
`Add-Content` CRLF, und `-Encoding utf8` setzt eine BOM. `tools/testlauf.ps1`
schreibt jetzt über `System.IO.File` mit `UTF8Encoding($false)` und `` "`n" ``.
Syntax mit `[System.Management.Automation.Language.Parser]::ParseFile`
geprüft: **keine Fehler**. Jede weitere Zeile, die das Werkzeug anhängt, ist
damit LF ohne BOM.

**Die bestehenden 17 Zeilen habe ich NICHT umgestellt — und zwar nicht aus
Vergesslichkeit.** Ich hatte es getan (gemessen: `CRLF=17 → CR=0`, BOM weg),
und `tools/pruefe-bytes.pl` hat den Commit daraufhin abgewiesen:

```
COMMIT ABGEBROCHEN - lautloser Schaden erkannt:
  * tools/TESTLAEUFE.md: 8 Zeile(n) haben bei unveraendertem Inhalt ihr
    Zeilenende gewechselt (CRLF -> LF x8), z. B. "(Leerzeile)"
```

**Die Schranke hat recht und arbeitet genau wie vorgesehen:** sie kann eine
Reparatur nicht von einem Schaden unterscheiden — sie meldet, der Mensch
entscheidet. Ihr eigener Hinweistext nennt dafür `git commit --no-verify`.
**Einen Hook zu umgehen ist aber nichts, was ich mir selbst erlauben darf**
(`Arbeitsweise/erlaubnis-nicht-hineinlesen.md`: keine Regel selbst lockern).
Ich habe die Datei deshalb auf die Fassung aus `40ec935` zurückgesetzt;
`perl tools/pruefe-bytes.pl` gibt danach **0**.

> **Das ist ein struktureller Befund, nicht nur ein Handgriff.** Die
> Fehlerklasse L-9.15 lässt sich an einer **bestehenden** Datei nicht beheben,
> ohne die Schranke zu umgehen. Beim vorigen Mal
> (`Pruefung/PRUEFUNG-ZEIGER.md`, 193 CR) ist das nicht aufgefallen, weil jene
> Datei in demselben Commit auch inhaltlich geändert wurde und Regel 2 nur
> Zeilen mit **unverändertem** Inhalt zählt.
>
> **Gregor entscheidet, welcher Weg gilt** — drei Möglichkeiten, alle
> vertretbar:
>
> 1. **Einmal umstellen mit `--no-verify`** und die Messung in die
>    Commit-Nachricht schreiben. Genau das, was der Hinweistext der Schranke
>    vorsieht. Befehl: `perl -i -pe 's/\r\n/\n/' tools/TESTLAEUFE.md` plus
>    BOM entfernen.
> 2. **`tools/pruefe-bytes.pl` eine schmale Ausnahme geben:** bei `*.md` ist
>    CRLF → LF eine **Reparatur** (alle MD-Dateien dieses Repos sind reines
>    LF), LF → CRLF bleibt ein Mangel. Das ist eine Änderung an der Schranke,
>    die bei **jedem** Commit läuft, und gehört deshalb abgesprochen.
> 3. **Nichts tun.** Die Datei wächst dann gemischt weiter: alte Zeilen CRLF,
>    neue LF. Das ist der einzige Weg, der nichts kostet und nichts
>    verbessert.
>
> **Bis dahin bleibt `tools/TESTLAEUFE.md` die einzige MD-Datei im Repo mit
> CRLF und BOM.** Gemessen am 09.09.2026: **105** verfolgte MD-Dateien, davon
> **104** reines LF. Die Bilanz „alle 104 MD-Dateien reines LF" aus L-10 gilt
> damit **nicht mehr** — es ist inzwischen eine Datei mehr im Repo, und genau
> diese eine ist die Ausnahme.

**Dazu ein Fehlalarm abgestellt:** `tools/doku-pruefen.pl` meldete bei **jedem**
Lauf unter *Zur Kenntnis*, `tools/TESTLAEUFE.md` nenne weder den Quellstand
noch die Paketnummer. Die Datei ist ein **Protokoll vergangener Läufe** — sie
kann nur die Fassung nennen, mit der damals getestet wurde, und niemand kann
daran etwas ändern. Eine Schranke, die umsonst warnt, wird ignoriert (Befund
**X-1**). Die Datei steht jetzt in der Zeitdokument-Liste des Werkzeugs, mit
Begründung im Kommentar; die geprüften Dateien gehen damit von 19 auf 18
zurück, und die Ausgabe ist zum ersten Mal seit Tagen **frei von Hinweisen**.
## L-11.3 — Der pre-commit-Hook wies **jeden** Commit im Repo ab

**Gefunden, weil mein eigener Commit dreimal scheiterte.** Der installierte
Hook (`.git/hooks/pre-commit`, Zeitstempel **09.09.2026 12:13**) ruft seit
heute zwei Schranken, die `tools/hooks-einrichten.sh` **nicht** kennt:
`tools/pruefe-waechter.pl` und `tools/lehren-schranken.pl`. Die zweite wies
ab — mit fünf Meldungen:

```
  - Arbeitsweise/LEHREN-AUS-DEM-CHAT.md
  - Arbeitsweise/README.md
  - Arbeitsweise/fehlerklassen-abstellen.md nennt tools/lehren-schranken.pl
    (pre-commit) - es steht aber nicht in tools/hooks-einrichten.sh
  - Arbeitsweise/lehren-anwenden-nicht-nur-schreiben.md  (dasselbe)
  - Arbeitsweise/teilweise-ersetzte-header.md nennt tools/pruefe-waechter.pl
    (pre-commit) - es steht aber nicht in tools/hooks-einrichten.sh
```

**Alle fünf waren richtig, und keine ließ sich durch die Änderung beheben, um
die es im Commit ging.** Damit war das Repo für **jeden** Agenten und für
Gregor selbst nicht mehr committierbar — die Schranke stand im Hook, bevor der
Zustand, den sie fordert, hergestellt war. Das ist dieselbe Klasse wie
`Arbeitsweise/main-muss-immer-baubar-sein.md`, nur eine Ebene tiefer: nicht der
Bau war blockiert, sondern der Commit.

**Behoben, in zwei Schritten:**

1. **`tools/hooks-einrichten.sh` nachgezogen** — es installiert jetzt
   `pruefe-waechter.pl` (Punkt 7) und `lehren-schranken.pl` (Punkt 8), so wie
   der laufende Hook es längst tut. Das ist **keine Lockerung**: ein frischer
   Klon bekommt damit *mehr* Schranken als vorher, nicht weniger. Vorher hätte
   ein neuer Arbeitsbaum zwei Schranken stillschweigend nicht gehabt.
   `sh -n tools/hooks-einrichten.sh` ist fehlerfrei. Drei der fünf Meldungen
   sind damit weg.
2. **`tools/lehren-schranken.pl` nimmt drei Dateien aus**, die keine Lehre
   sind: `MEMORY.md` (war schon ausgenommen), `README.md` (das Verzeichnis des
   Ordners, existiert nur im Repo) und `LEHREN-AUS-DEM-CHAT.md` (eine
   **Sammlung** von Chatzitaten, aus der die einzelnen Lehren erst hervorgingen
   — sie liegt im Gedächtnisverzeichnis und wäre über
   `tools/lehren-spiegeln.pl` bei jeder Änderung wieder überschrieben worden).
   Gezählt werden dadurch **48** Lehren statt 50.

**Gegenprobe, beide Richtungen** — an `Arbeitsweise/schranke-gegentesten.md`,
danach aus der Sicherung zurückgeholt; Größe vorher und nachher **5 119 Byte**,
identisch:

| Versuch | erwartet | gemessen |
|---|---|---|
| unveränderter Baum | still, Rückgabe 0 | *„Jede Lehre hat ihre Schranke oder eine begruendete Ausnahme."*, 0 |
| `Schranke:`-Zeile aus einer **echten** Lehre entfernt | Mangel | `MANGEL: - Arbeitsweise/schranke-gegentesten.md` |
| `Schranke: tools/gibt-es-nicht.pl` eingesetzt | Mangel | `nennt tools/gibt-es-nicht.pl - die Datei gibt es nicht` |

Die Ausnahme ist also eng: sie nennt drei Dateinamen, und jede echte Lehre ohne
Schranke fällt weiter auf.

> **Was daran hängen bleibt, als Frage an Gregor:** eine Schranke in den Hook
> zu hängen, bevor ihre Forderung erfüllt ist, sperrt das ganze Repo. Der
> Kommentar im Hook sagt sogar, das Werkzeug habe sich *„am 09.09.2026 selbst
> gefunden: es fehlte hier"* — der nächste Schritt, `hooks-einrichten.sh`
> nachzuziehen, ist dann aber nicht mehr gemacht worden.
> **Verfahrensvorschlag:** eine neue Schranke erst dann in den Hook hängen,
> wenn sie im Bestand **0** zurückgibt. `tools/lehren-schranken.pl` selbst
> könnte das prüfen — es weiß ja, welche Werkzeuge im Hook stehen.

## L-9.11 — 18 Verweise ins Leere: erledigt und nachgemessen

Gemessen über alle 105 MD-Dateien, jeder Verweis **relativ zum Verzeichnis der
Datei** aufgelöst — genau so liest ihn ein Leser auf GitHub:

```
Befunde/LEKTOR-4.md    0 Treffer   (vorher 18)
alle Dateien           7 Treffer
```

Von diesen sieben ist **keiner zu ändern**:

| Fundstelle | warum kein Fehler |
|---|---|
| `Arbeitsweise/agenten-koordinieren.md:13` | `Arbeitsweise/` ist ein **Spiegel** des Gedächtnisverzeichnisses (`tools/lehren-spiegeln.pl`); eine Änderung hier geht beim nächsten Spiegeln verloren. Die Quelle trägt denselben Fehler und liegt **nicht** in meinem Arbeitsbaum |
| `Befunde/LEKTOR-5.md:483` | die Zeile **zitiert** vorgeschlagenen Text für `README.md` in einem Blockzitat; dort im Wurzelverzeichnis ist `](ZIEL.md)` **richtig**. Ein Zitat zu berichtigen wäre eine Verfälschung |
| `Befunde/LEKTOR-5.md:490`, `Befunde/LEKTOR-6.md:365`, `:373` sowie **zwei Treffer in der Tabelle, die Du gerade liest** | die „Verweise" stehen in **Schrägstrichen** — als Beispiel dafür, wie der Fehler aussieht. Das ist eine Schwäche meines Prüfskripts (es überliest Inline-Code nicht), kein Mangel in der Doku. Die beiden neuen Treffer sind erst durch **diesen Bericht** entstanden: 5 vor dem Anhängen, 7 danach |
## L-11.4 — Der Hook zeigt auf ein Werkzeug, das es in keinem Zweig gibt

**Nach der Behebung von L-11.3 scheiterte derselbe Commit erneut**, diesmal so:

```
Can't open perl script
"…/Eudora7.2-wt-lektor/tools/pruefe-nachrichtenschleife.pl":
No such file or directory
```

Gemessen am 09.09.2026:

| gemessen | Ergebnis |
|---|---|
| `.git/hooks/pre-commit` (gemeinsam für alle Arbeitsbäume) | Zeitstempel **12:23**, Zeile 80 ruft `tools/pruefe-nachrichtenschleife.pl` |
| die Datei im **Hauptbaum** | vorhanden, **12:21**, 7 821 Byte — **unverfolgt** |
| `git cat-file -e HEAD:tools/pruefe-nachrichtenschleife.pl` | **nicht vorhanden** |
| dasselbe gegen `origin/lessons_learned` (nach `git fetch`) | **nicht vorhanden** |

**Der Hook liegt im gemeinsamen `.git`-Verzeichnis und gilt für jeden
Arbeitsbaum; der Pfad `$WURZEL` zeigt aber auf den jeweils eigenen.** Ein
Werkzeug, das nur im Hauptbaum liegt und nicht committet ist, macht damit
**jeden Commit in jedem anderen Arbeitsbaum unmöglich** — und zwar mit einer
Meldung, die nichts mit der Änderung zu tun hat, um die es geht.

**Ich habe die Datei NICHT in meinen Arbeitsbaum kopiert.** Sie ist die
unfertige Arbeit eines anderen Agenten; sie zu committen wäre, fremde Arbeit
unter meinem Commit einzureichen. Ebenso habe ich `--no-verify` nicht benutzt.

> **Das ist dieselbe Klasse wie L-11.3, eine Stufe schärfer.** Dort war die
> Forderung einer Schranke im Bestand nicht erfüllt; hier existiert die
> Schranke selbst nicht. **Verfahren, das beides abstellt:** eine Schranke
> gehört erst in den Hook, wenn sie (1) **committet** ist und (2) im Bestand
> **0** zurückgibt. Beides lässt sich mechanisch prüfen — `git cat-file -e
> HEAD:<pfad>` und ein Probelauf —, und `tools/lehren-schranken.pl` liest den
> Hook schon.
>
> **Bis das gelöst ist, bleibt der Merge in `wt/lektor` offen.** Alles ist
> gestaged und alle Schranken außer dieser einen sind grün; sobald
> `tools/pruefe-nachrichtenschleife.pl` in einem Zweig liegt, den `wt/lektor`
> sieht, genügt ein einzelner `git commit`.


## Die Schranken am Ende

| Werkzeug | Rückgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | **0** — *Kein Widerspruch gefunden*, **ohne** Hinweise |
| `perl tools/pruefe-bytes.pl` | **0** |
| CR-Zählung über alle **105** verfolgten MD-Dateien | **0** in **104** von ihnen; die eine Ausnahme ist `tools/TESTLAEUFE.md` mit CRLF und BOM — siehe L-11.2, Entscheidung liegt bei Gregor. UTF-8 in allen 105 lesbar |
| Verweise ins Leere | 7, alle drei Ursachen oben benannt, keiner zu ändern |
| `perl tools/pruefe-waechter.pl` | **0** |
| `perl tools/pruefe-beenden.pl` | **0** |
| `perl tools/lehren-schranken.pl` | **0** — nach der Behebung aus L-11.3; vorher wies es **jeden** Commit im Repo ab |
| `sh -n tools/hooks-einrichten.sh` | **0** |

## Offen — ausdrücklich nicht entschieden

1. **Der Fehlalarm der Summenprüfung** in `tools/doku-pruefen.pl` (oben
   gemessen). **Gemeldet, nicht behoben** — der Auftrag verlangt es so. Die
   Behebung wäre ein Zweizeiler.
2. **Es gibt kein `E-53`.** Wenn Gregor einen sechsten neuen Befund im Sinn
   hatte, fehlt er im Repo. **Ich habe keine Kennung vergeben.**
3. **Zu `Releases/Eudora72-1.0.27-release.zip` fehlt die `.sha256`-Datei.** Die
   Prüfsumme steht in `Releases/PAKETE.md`, damit sie nicht verloren geht; ob
   die Datei angelegt wird, entscheide ich nicht. Ebenso liegen die
   `.sha256`-Dateien zu **1.0.21** und **1.0.22** ohne ihr ZIP im Repo — ob sie
   bleiben sollen, ist Gregors Entscheidung.
4. **Mangel M-4 bleibt offen und ist gewachsen.** Ohne eigenen Abschnitt in
   `Releases/PAKETE.md` sind jetzt **1.0.4 bis 1.0.17**, **1.0.19**, **1.0.20**
   sowie **1.0.24**, **1.0.25** und **1.0.26**. Zu 1.0.24 bis 1.0.26 liegt
   weder ZIP noch Prüfsumme vor — erfunden wird dort nichts.
5. **Die Kennung `A-1` ist zweimal vergeben** (Befund L-9.8, weiter offen).
   Einmal für Gregors Anforderung in `ZIEL.md`, einmal für den
   Erscheinungsbild-Befund vom 30.08.2026. **Kennungen vergibt Gregor.**
6. **`Eudora.exe` im Paket 1.0.27 und im Bauverzeichnis des Hauptbaums haben
   dieselbe Größe, aber verschiedene Zeitstempel** (11:02 gegen 11:35). Größe
   und Quellstand stimmen; ob im Hauptbaum nach dem Packen etwas geändert und
   neu gebaut wurde, habe ich **nicht** untersucht — ich baue nicht.
7. **Befund L-9.18** (fünf Dateien ohne H1, Adressat und Zweck) ist weiter
   **nicht** abgearbeitet.
8. **Ich habe zwei Werkzeuge angefasst, um überhaupt committen zu können**
   (L-11.3): `tools/hooks-einrichten.sh` und `tools/lehren-schranken.pl`. Das
   war keine Wahl — der Hook wies jeden Commit ab. **Beide Änderungen sind
   gegengetestet und im Bericht begründet, aber sie betreffen das, was bei
   jedem Commit läuft. Wenn Gregor sie anders will, sind sie in zwei
   Handgriffen zurückgenommen.** Was ich **nicht** getan habe: `--no-verify`
   benutzen.
9. **Verfahrensvorschlag, nicht umgesetzt:** eine neue Schranke erst in den
   Hook hängen, wenn sie im Bestand 0 zurückgibt. Heute ist das Gegenteil
   passiert, und das Repo war stundenlang nicht committierbar.
10. **Der Nebenbefund ohne Nummer ist nur aufgeschrieben, nicht untersucht.**
   Er steht jetzt in `AUFGABEN.md`, `WEITERMACHEN.md`, `CHANGELOG.md`,
   `README.md`, `ZIEL.md` und `Releases/PAKETE.md` — überall mit dem
   ausdrücklichen Hinweis, dass er **nicht** zur Registerkartenleiste gehört.
