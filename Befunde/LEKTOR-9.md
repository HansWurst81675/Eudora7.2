# LEKTOR-9 — der MD-Bestand gegen den Bestand geprüft (14.09.2026)

Auftrag: alle MDs gegen den **Bestand** prüfen, nicht gegen den Diff
([review-sieht-nur-den-diff.md](../Arbeitsweise/review-sieht-nur-den-diff.md)).
Zweig `wt/lektor`, Arbeitsbaum `Eudora7.2-wt-lektor`. Begonnen am Stand
7.2.0.56, abgeschlossen am Stand **7.2.0.57 / Paket 1.0.57**.

---

## 1. Der größte Befund: 3217 doppelt umkodierte Stellen, tagelang unsichtbar

`BEFUNDE.md` trug in **1517 von 7826 Zeilen** doppelt umkodierten Text. Aus
`über` (`C3 BC`) wurde die Achtbytefolge `C3 83 C2 83 C3 82 C2 BC`, aus einem
Gedankenstrich zwölf Bytes statt drei. Die Datei war dabei durchgehend
**gültiges UTF-8** — der Schaden sieht für jede Prüfung normal aus, die nur auf
Kodierungsfehler oder Ersatzzeichen sieht.

| in `BEFUNDE.md` | vorher | nachher |
|---|---|---|
| Umlaute (`ä ö ü ß`) | 122 | 2191 |
| Gedankenstriche und Anführungszeichen | 47 | über 1100 |
| doppelt kodierte Stellen | 3267 | 12 |

Dazu je eine Stelle in `ABRUF-PRUEFEN.md`, `LEKTORAT.md`, `PORTIERUNG.md`.

### Warum die vorhandene Schranke geschwiegen hat

`pruefe-bytes.pl` hat seit Befund **X-7** eine **Regel 5 gegen genau diesen
Schaden**. Sie hat trotzdem nie angeschlagen, und der Grund steht in ihrer
eigenen Zeile:

```perl
push @fehler, "... doppelt kodiert ..." if $dk_b > $dk_a;
```

Gezählt wird der **Zuwachs**. Der Schaden kam einmal herein und wuchs danach
nicht mehr — ab dem nächsten Commit war er für immer unsichtbar. Das ist
`review-sieht-nur-den-diff.md`, angewandt auf die Schranke selbst. Die
Begründung im Quelltext ist nachvollziehbar (eine Schranke, die bei jedem
Commit über Altbestand meckert, wird abgeschaltet) — aber sie hat zur Folge,
dass **kein Werkzeug den Bestand je wieder ansieht**.

### Fünf Stellen blieben absichtlich stehen

In `BEFUNDE.md` zeigen sechs Zeilen kaputten Text als **Beleg** zu E-85 und
NP3-8. Eine steht wörtlich hinter dem Wort `falsch`, eine andere sagt, dort
stünden *„zwei Zeichen"*. Eine vollständige Reparatur hätte aus dem
Gegenbeispiel den richtigen Text gemacht und damit den Beweis gelöscht.

Beim Merge verschärfte sich das: dort trugen diese Zeilen die Doppelkodierung
**zusätzlich** zum gewollten Beleg. Der beabsichtigte Beleg ist die Vierbytefolge
`C3 83 C2 BC` — sie zeigt, wie ein Umlaut falsch ankommt. Daraus war die
Achtbytefolge `C3 83 C2 83 C3 82 C2 BC` geworden. Voll reparieren hätte den
Beleg zerstört, gar nichts tun die Doppelkodierung stehengelassen. Genommen
wurde die bereits berichtigte
Fassung dieser Zeilen, abgesichert durch eine Nachbarschaftsprobe.

Das steht als Warnung im Kopf von `tools/entmojibaken.pl`.

---

## 2. Was ich berichtigt habe

| Datei | was |
|---|---|
| `BEFUNDE.md` | 3211 Läufe entmojibakt |
| `ABRUF-PRUEFEN.md`, `LEKTORAT.md`, `PORTIERUNG.md` | je 1 Lauf |
| `CHANGELOG.md` | E-89 bis E-92 nachgetragen; E-89 nach seiner Behebung wieder aus *Noch offen* genommen |
| `ZIEL.md` | Messstand und Baustand getrennt, beide auf .57 |
| `WEITERMACHEN.md` | Selbstwiderspruch (Kopf sagte 1.0.56, *„zuletzt gebaut"* sagte 1.0.51); Liste der offenen Befunde zweimal neu gesetzt |
| `Releases/PAKETE.md` | Paketspanne `1.0.30 bis 1.0.50` → `1.0.57` |
| `tools/RELEASES.md` | BOM + 27 CR |
| `tools/TESTLAEUFE.md` | BOM + 17 CR |
| `Pruefung/PRUEFUNG-ZEIGER.md` | 193 CR — die Datei war durchgehend CRLF |
| `tools/WERKZEUGE.md` | drei fehlende Einträge |

**Keine einzige MD außerhalb `Eudora71/` trägt jetzt noch ein CR oder eine
BOM.** Vorher waren es drei Dateien.

### Die Ursache der BOM, nicht nur ihre Folge

`tools/release-veroeffentlichen.ps1` schrieb `RELEASES.md` mit
`Set-Content -Encoding utf8`. Unter Windows PowerShell 5.1 erzeugt das **CRLF
und eine BOM**. Genau diese Fehlerklasse war am 09.09.2026 als **L-11.2** in
`tools/testlauf.ps1` abgestellt worden — das Nachbarskript blieb stehen. Beim
nächsten Release wäre der Schaden zurückgekommen. Jetzt auch dort über .NET
`WriteAllText`/`AppendAllText` mit `UTF8Encoding($false)`.

Der Kommentar in `testlauf.ps1` nannte `TESTLAEUFE.md` *„die EINZIGE MD-Datei
im Repo mit CRLF"*. Das stimmte schon damals nicht.

---

## 3. Drei Schranken hatten dieselbe Blindstelle

Die Byte-Reparatur ließ sich zunächst **nicht committen** — sie löste
nacheinander drei Schranken aus, und jedes Mal zu Unrecht:

**`pruefe-behoben-belegt.pl` (46 Meldungen) und `pruefe-anzeigetext.pl` (3).**
Beide prüfen nur den Zuwachs eines Commits. Eine Zeile, die sich **nur in der
Kodierung** geändert hat, zählten sie als neu geschrieben — obwohl kein Urteil
und kein Zitat neu war. Es waren die alten Bestandszeilen, die der Kommentar
in beiden Dateien ausdrücklich in Ruhe lassen will. Beide holen sich den Filter
jetzt aus `entmojibaken.pl`; **zwei Fassungen wären auseinandergelaufen.**

**`pruefe-bytes.pl`, Regeln 1 und 2.** Sie werten *jeden* Wechsel der
Zeilenenden als Schaden — auch den **zum Sollzustand hin**. Die Datei nennt
dafür `--no-verify` als Weg. Eine Schranke aber, die man umgehen muss, um ihre
eigene Regel durchzusetzen, ist die falsche Schranke. Jetzt eine eng gefasste
Ausnahme: `.md` außerhalb `Eudora71/`, **ausschließlich** die Richtung zu
reinen LF, nachher kein einziges CR. Regel 2 braucht sie eigens, weil mit der
BOM auch der Inhalt abweicht und Regel 1 die Datei dann gar nicht sieht.

### Gegenproben, jede Richtung einzeln

| | | |
|---|---|---|
| L12a | MD `CRLF → LF` | durchlassen |
| L12b | MD `LF → CRLF` | anschlagen |
| L12c | MD nur teilweise auf LF, ein CR bleibt | anschlagen |
| L12d | `.cpp` unter `Eudora71/` | anschlagen |
| L12e | `.md` unter `Eudora71/` | anschlagen |
| L12f | MD verliert BOM **und** CRLF (der reale Fall) | durchlassen |
| L12g | MD bekommt BOM **und** CRLF | anschlagen |

**42 Fälle, 42 grün, 0 rot.** Dazu: `pruefe-behoben-belegt --selbsttest` 10/10,
`pruefe-anzeigetext --selbsttest` 7/7, `summe-gegentest.sh` 6/6, und der
Vergleich alte gegen neue Fassung über **40 Commits** an `BEFUNDE.md` —
**0 Unterschiede** bei beiden Schranken. Ein erfundenes *„E-999 behoben"* ohne
Beleg wird weiterhin gemeldet.

Die Testumgebung legt jetzt auch **Unterverzeichnisse** an — ohne das ließ sich
L12d überhaupt nicht stellen.

---

## 4. Zwei Messfehler, die mir selbst unterliefen

**Der Gegentest lief ins Leere.** Mein erster Regressionsvergleich meldete vier
Unterschiede bei `pruefe-anzeigetext.pl`. Sie waren keine: der Pfad zur
gesicherten alten Fassung stimmte nicht, das alte Skript lief gar nicht und
lieferte deshalb immer 0. Das ist
[messung-muss-den-weg-treffen.md](../Arbeitsweise/messung-muss-den-weg-treffen.md)
im Original.

**„Deren Fassung nehmen" hätte drei Befunde gelöscht.** Beim Merge von
`origin/wt/pruefer` löste ich den Konflikt in `BEFUNDE.md` zuerst so, wie ich
es beim Merge davor getan hatte: deren Fassung als Ganzes, dann die Reparatur
darauf. Beim Nachzählen der Kennungen fiel auf, dass **E-90, E-91 und E-92
verschwunden waren** — ihr Zweig ist älter als diese drei Einträge. Der Prüfer
hatte an der Datei genau **eine** Zeile geändert. Zurückgenommen, bevor etwas
committet wurde.

> Bei einer Datei, an der mehrere gleichzeitig schreiben, ist *„deren Fassung
> nehmen"* kein Auflösen, sondern ein Verwerfen. Was gerettet werden muss, ist
> vorher zu zählen — nicht hinterher zu vermissen.

---

## 5. Gefunden, aber **nicht** berichtigt

**Die vier Meldungen von `doku-pruefen.pl` sind größtenteils Fehlalarm.** Das
Werkzeug erwartet, dass jede MD den aktuellen Stand nennt. Für eine
**Zweigliste** (`tools/ZWEIGE.md`), eine **Werkzeugliste**
(`tools/WERKZEUGE.md`) und eine **Themendatei** (`FILTER.md`, deren jüngste
Messung an 1.0.42 stattfand und seither unverändert gilt) ist eine
Versionsnummer schlicht kein Bestandteil. Ich habe dort **keine Zahl
eingesetzt**: eine Nummer nur einzutragen, damit ein Werkzeug schweigt, macht
die Datei nicht richtiger, sondern die Prüfung wertlos.

`tools/RELEASES.md` habe ich dagegen als **Zeitdokument** eingetragen — genau
wie `TESTLAEUFE.md` seit L-11.2. Ein fortgeschriebenes Release-Protokoll nennt
zwangsläufig alte Fassungen; die Meldung war nicht abstellbar, ohne das
Protokoll zu fälschen. `tools/AGENTEN-LAUFEN.md` wird maschinell gepflegt und
regelt sich beim nächsten Lauf selbst.

**Möglicher Widerspruch in `ZIEL.md`, den ich nicht angefasst habe:** Kriterien
5 und 6 (*Mail schreiben, senden, weiterleiten*) stehen als **erfüllt**,
während E-89 das Verfassenfenster bis 7.2.0.57 als *unbrauchbar* führte. Eine
Urteilsänderung an den Kriterien ist keine Lektoratsfrage — sie braucht Gregors
Messung am laufenden Programm. **Hier nur benannt.**

**71 alte Urteilszeilen ohne Beleg** stehen weiter im Bestand von `BEFUNDE.md`
(`pruefe-behoben-belegt.pl` nennt sie). Sie stammen aus der Zeit vor der
Schranke. Das nachzuarbeiten ist ein eigener Auftrag, kein Nebenbei.

---

## 6. Eine Zählweise, die in die Irre führt

Der Auftrag nannte `ls tools/*.pl tools/*.ps1 tools/*.sh` als verlässliche
Zählung — ausdrücklich, weil eine Zählung der *Tabellenzeilen* schon einmal
falsch gerechnet hatte. Das Glob hat aber dieselbe Schwäche in anderer Form:
**es sieht nicht in Unterverzeichnisse.**

`tools/pruefstand/messen.ps1` lag genau dort und fehlte in `WERKZEUGE.md`. Nach
dem Glob waren „alle" Werkzeuge eingetragen; nach `git ls-files tools/` fehlten
zwei.

```
ls tools/*.pl tools/*.ps1 tools/*.sh   →  94   (0 fehlen)
git ls-files tools/ | grep -E '\.(pl|ps1|sh)$'  →  95   (2 fehlten)
```

Nachgetragen: `tools/pruefstand/messen.ps1` und
`tools/pruefe-stand-md-tests.pl`. **Jetzt sind alle 95 eingetragen.**

---

## 7. Was ich **nicht** geprüft habe

* **Quelltext unter `Eudora71/`** — nicht mein Bereich, nicht angefasst.
* **Inhaltliche Richtigkeit der Befunde.** Ich habe geprüft, ob dieselbe
  Kennung in `BEFUNDE.md`, `CHANGELOG.md`, `AUFGABEN.md` und `WEITERMACHEN.md`
  **denselben Zustand** trägt — nicht, ob der Zustand stimmt. Ob E-88 wirklich
  behoben ist, misst Gregor, nicht ich.
* **Die 72 Dateien unter `Arbeitsweise/`** — sie sind ein Spiegel des
  Gedächtnisses und werden beim nächsten Spiegeln überschrieben (NP3-4). Eine
  Änderung dort wäre verloren.
* **`Befunde/` und `Pruefung/`** nur auf Bytes, nicht auf Aktualität — es sind
  Zeitdokumente und dürfen alte Zahlen nennen.
* **Die fünf verbliebenen doppelt kodierten Stellen** sind geprüft und
  absichtlich stehengelassen (Abschnitt 1), nicht übersehen.

---

## 8. Neues Werkzeug

`tools/entmojibaken.pl` — macht doppelt umkodierten Text wieder lesbar, das
Gegenstück zu Regel 5 in `pruefe-bytes.pl`. Arbeitet je zusammenhängendem
Nicht-ASCII-Lauf und nimmt nur zurück, was **vollständig** aufgeht; ein
sauberer Lauf bleibt unangetastet — gegengeprüft an Zeile 113 (`überholt` mit
echtem Umlaut), die unverändert blieb. Bricht ab, wenn sich die CR-Anzahl
ändert. Ohne `-schreiben` nur Probelauf.

Zusätzlich als Modul nutzbar: beide Zuwachs-Schranken holen sich von dort den
Filter, der eine rein umkodierte Zeile nicht als neu zählt.

---

## Gegenproben am Schluss

```
doku-pruefen.pl        kein Widerspruch
offene-befunde.pl      die Liste deckt die offenen Befunde (8 von 8)
pruefe-bytes-tests.pl  42 Fälle, 42 grün, 0 rot
alle MDs               kein CR, keine BOM
tools/WERKZEUGE.md     95 von 95 Werkzeugen eingetragen
```
