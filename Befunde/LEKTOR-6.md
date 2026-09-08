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
