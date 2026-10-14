# <a id="lektor-34"></a>LEKTOR-34 — Doku nach Merge PR #97 und E-118 (7.2.0.89)

Lauf am 14.10.2026 auf `wt/lektor`, nach dem Merge von `origin/e-118_HTML_header`
(`65d066a8`, schnell vorgespult). Anlass: PR #97 ([E-105](../BEFUNDE.md#e-105), 7.2.0.88) ist
gemergt und `e-105_doppelte_bilder` gelöscht; [E-118](../BEFUNDE.md#e-118) ist in 7.2.0.89
eingebaut und am IMAP-Prüfserver gemessen; Gregor bekommt
`C:\Users\Gregor\Eudora72-1.0.89-release` (Verzeichnis vorhanden, `TESTEN.txt` gelesen).
1.0.88 wurde nie an Gregor ausgeliefert.

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Befunde/` und `Arbeitsweise/`
= 41 Dateien. **Maßstab:** `Eudora71/Version.h` = 7.2.0.89, `VERSION` = 1.0.89,
neueste Marke `v1.0.87`, `tools/RELEASES.md` letzte Zeile `v1.0.87`,
`tools/ZWEIGE.md` (führt `e-105_doppelte_bilder` als gemergt und gelöscht,
`e-118_HTML_header` als vereinbart — stimmt).

`perl tools/doku-pruefen.pl`: kein Widerspruch (27 Dateien geprüft, siehe [L-34.6](#l-34.6)).
`perl tools/commit-bereit.pl`: vor dem Lauf 1 von 29 rot (`befunde-verlinken.pl`, [L-34.1](#l-34.1)), danach grün.

## Berichtigt

### <a id="l-34.1"></a>L-34.1 — die eigene Startzeile hielt den Commit-Haken auf

`tools/agenten-laufen.pl --start` schreibt den Auftragstext wörtlich nach
`tools/AGENTEN-LAUFEN.md`; die nackte Kennung *„[E-118](../BEFUNDE.md#e-118)“* darin ließ
`befunde-verlinken.pl` abweisen. Mit `befunde-verlinken.pl --anker --verlinken`
verlinkt. Klasse: jeder Rollenauftrag mit Befundnummer erzeugt diesen Mangel,
siehe [L-34.7](#l-34.7).

### <a id="l-34.2"></a>L-34.2 — E-105: Zweig ohne Merge-Vermerk, Test an 1.0.88 erwartet

| Datei, Stelle | stand | jetzt |
|---|---|---|
| `BEFUNDE.md`, Urteil [E-105](../BEFUNDE.md#e-105) | *„eingebaut in 7.2.0.88 (Zweig `e-105_doppelte_bilder`)“* | dazu *„gemergt mit PR #97“* |
| `CHANGELOG.md`, offene Befunde, [E-105](../BEFUNDE.md#e-105) | dasselbe | dasselbe |
| `AUFGABEN.md`, nächste Schritte, [E-105](../BEFUNDE.md#e-105) | *„offen bis zu seinem Test an 1.0.88“* | *„an 1.0.89 (1.0.88 wurde nicht ausgeliefert)“*, Link auf TESTPLAN C5 |
| `WEITERMACHEN.md`, Nachtrag [LEKTOR-33](LEKTOR-33.md#lektor-33) | *„es fehlen das Paket 1.0.88 bei Gregor und sein Urteil“* | Nachtrag [LEKTOR-34](#lektor-34): 1.0.88 nicht ausgeliefert, 1.0.89 bereitgestellt, es fehlt Gregors Urteil zu [E-118](../BEFUNDE.md#e-118) und [E-105](../BEFUNDE.md#e-105) an 1.0.89; danach [E-113](../BEFUNDE.md#e-113), [E-77](../BEFUNDE.md#e-77) |

### <a id="l-34.3"></a>L-34.3 — E-118 in `README.md` noch im Stand vor dem Einbau

Liste der bekannten Fehler: *„([E-118](../BEFUNDE.md#e-118), offen, am Quelltext belegt)“* →
*„im Download `v1.0.87` offen; Behebung in 7.2.0.89 eingebaut, am IMAP-Prüfserver
gemessen, noch nicht ausgeliefert, von Gregor noch nicht bestätigt“* — gleichlautend
mit dem Eintrag zu [E-105](../BEFUNDE.md#e-105) direkt darüber und mit dem Urteil in `BEFUNDE.md`.

### <a id="l-34.4"></a>L-34.4 — Testverzeichnis 1.0.89 als „nicht vorhanden“ geführt

`WEITERMACHEN.md` (*„noch kein Testverzeichnis bei Gregor“*) und `Releases/PAKETE.md`
(*„wird bereitgestellt“*) — das Verzeichnis besteht. Beide nennen jetzt den Pfad,
„bereitgestellt am 14.10.2026“ und verweisen auf TESTPLAN C5.

### <a id="l-34.5"></a>L-34.5 — TESTPLAN hatte keinen Schritt für 1.0.89

Neuer Abschnitt **C5 · Paket 1.0.89 — [E-118](../BEFUNDE.md#e-118) und [E-105](../BEFUNDE.md#e-105)** (Anker `#c5`), Handgriffe
und Hinweise wörtlich nach `Releases/1.0.89/TESTEN.txt` (Mailverzeichnis aus 1.0.87
vorher kopieren; vor 1.0.89 verschobene Mails bleiben auf dem Server falsch;
[E-119](../BEFUNDE.md#e-119), [E-113](../BEFUNDE.md#e-113), [E-116](../BEFUNDE.md#e-116) bekannt). Kopfzeile nennt C5 als offen. Damit ist
[L-33.7](LEKTOR-33.md#l-33.7) (kein Schritt für 1.0.88) erledigt — durch 1.0.89.

## Offen — mit Ermessen, nicht berichtigt

### <a id="l-34.6"></a>L-34.6 — `befund-suchen.pl` sieht 101 von 171 Befunden nicht, darunter E-100 bis E-120

**Nachgestellt** (Werkzeug nicht geändert):

| Aufruf | Ergebnis |
|---|---|
| `befund-suchen.pl ImapAppend.cpp` | *„Kein bestehender Befund nennt diesen Ort. Ein neuer Eintrag ist berechtigt.“* |
| `befund-suchen.pl EuImap/src/ImapAppend.cpp` | dasselbe |
| `befund-suchen.pl IsHeaderToInclude` | dasselbe |
| `befund-suchen.pl E-118` | dasselbe |
| Gegenprobe `befund-suchen.pl ImapDownload.cpp` | 6 Treffer, darunter [NP3-8](../BEFUNDE.md#np3-8) — das Werkzeug läuft |

Die Urteilszeile von [E-118](../BEFUNDE.md#e-118) nennt `EuImap/src/ImapAppend.cpp:2020-2026`,
`IsHeaderToInclude`, `:692`, `:880`, `:1166-1169` wörtlich.

**Ursache, am Werkzeug gelesen** (`tools/befund-suchen.pl:84-100`): es zerlegt
`BEFUNDE.md` nur in Abschnitte, die mit `## <Nummer>` oder `### <Nummer>`
beginnen. Die Urteilstabellen fallen absichtlich heraus — Begründung im Kommentar:
*„sie tragen das Urteil, aber nicht die Fundstellen, und ein Treffer dort wäre nur
eine Wiederholung.“* **Diese Annahme gilt nicht mehr.** Gemessen an `BEFUNDE.md`:
171 Kennungen haben eine Urteilszeile (`<a id=…>` am Zeilenanfang einer Tabelle),
74 haben einen eigenen Abschnitt, **101 stehen nur in der Tabelle** — darunter
jede Kennung von [E-100](../BEFUNDE.md#e-100) bis [E-120](../BEFUNDE.md#e-120) (E-102 ist nicht vergeben). Bei ihnen trägt die Tabellenzeile die gesamte
Fundstelle ([E-105](../BEFUNDE.md#e-105) und [E-118](../BEFUNDE.md#e-118) je mehrere tausend Zeichen).

**Was daran schwer wiegt:** `CLAUDE.md` Abschnitt 2 macht genau dieses Werkzeug zur
Bedingung für jeden neuen Befund — *„Erst wenn das Werkzeug nichts meldet, ist ein
neuer Eintrag berechtigt.“* Für jeden Ort, der nur in einem neueren Befund steht,
meldet es nichts und gibt Rückgabe 0, also ausdrücklich die Erlaubnis. Das ist
genau der E-85-Fall, gegen den es gebaut wurde, nur mit falschem Grün statt
fehlendem Werkzeug (`Arbeitsweise/pruefstand-kann-blind-sein.md`,
`Arbeitsweise/schranke-teilt-nicht-die-annahme.md`).

**Vorschlag, nicht umgesetzt:** Tabellenzeilen mit `<a id="…"></a>` als eigenen
Abschnitt mitlesen (Nummer aus dem Anker, Titel aus der zweiten Zelle, Urteil aus
der dritten); Gegentest: `ImapAppend.cpp` muss [E-118](../BEFUNDE.md#e-118) finden, `ImapDownload.cpp`
weiter [NP3-8](../BEFUNDE.md#np3-8). Dazu eine Schranke, die für jede Kennung mit Urteilszeile prüft, ob
`befund-suchen.pl` sie über eine ihrer Dateinamen findet. Entscheidung, wer das baut
und auf welchem Zweig, bei Gregor.

### <a id="l-34.7"></a>L-34.7 — `agenten-laufen.pl --start` erzeugt einen Haken-Mangel

Siehe [L-34.1](#l-34.1). Der Rollenauftrag ist Freitext, `befunde-verlinken.pl` verlangt in
jeder `.md` verlinkte Kennungen. Entweder verlinkt `agenten-laufen.pl` beim
Eintragen selbst, oder `befunde-verlinken.pl` nimmt die Auftragsspalte von
`tools/AGENTEN-LAUFEN.md` aus. Ermessen; nicht geändert.

### <a id="l-34.8"></a>L-34.8 — PRÜFER hat E-118 nicht gesehen, das Paket liegt schon bei Gregor

`perl tools/rollen-faellig.pl`: **PRÜFER fällig** (9 Dateien seit `b23f46e`, darunter
`EuImap/src/ImapAppend.cpp`, `ImapAppend.h`, `Tests/TestE105.cpp`), **CHRONIST
fällig** (17 Dateien seit `d135f17`). Die E-118-Behebung ist von keinem PRÜFER-Lauf
nachgerechnet; 1.0.89 ist trotzdem bereitgestellt. Vor einem PR oder Release von
`e-118_HTML_header` den PRÜFER laufen lassen.

### <a id="l-34.9"></a>L-34.9 — `doku-pruefen.pl` prüft 27 von 41 Dateien

Der Umfang aus `git ls-files` (ohne `Befunde/`, `Arbeitsweise/`) ist 41, das Werkzeug
meldet *„gepruefte Dateien 27“*. Die 14 übrigen (u. a. `Eudora71/OTShim/*.md`,
`Pruefung/*.md`, `tools/patches/*.md`) sind in diesem Lauf mit `grep` auf
7.2.0.88/1.0.88/1.0.89 und die beiden Zweignamen durchgesehen — keine veraltete
Standangabe. Zur Kenntnis wie in [L-33.9](LEKTOR-33.md#l-33.9): `tools/WERKZEUGE.md`
(7.2.0.85), `tools/ZWEIGE.md` (7.2.0.84), `tools/pruefdaten/LIESMICH.md` (7.2.0.83)
nennen 7.2.0.89 nicht; keine gibt eine ältere Fassung als aktuell aus.
`WERKZEUGE.md` kennt `pruefe-rueckstrich.pl` und das neue `APPEND`/`--ablage` von
`imap-pruefserver.pl`. Kein Mangel.
