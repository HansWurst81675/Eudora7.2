# <a id="lektor-85"></a>LEKTOR-85 — Bestand vor dem PR des Zweigs `0.125_ergebnisse` nach `main`: Berichtigungen zu LEKTOR-84, E-137 fünfter Anlauf, Prüfstandsfall E-137a–c, Paket 1.0.126, 27.10.2026

**Auftrag.** (1) Die Funde aus [LEKTOR-84](LEKTOR-84.md) nachhalten —
eingearbeitet laut `1cf3d242` sind [L-84.1](LEKTOR-84.md#l-84.1), .3, .4–.8, offen gelassen [L-84.2](LEKTOR-84.md#l-84.2)
und [L-84.9](LEKTOR-84.md#l-84.9). (2) Den Bestand der `.md` (ohne `Arbeitsweise/` und `Befunde/`,
61 Dateien aus `git ls-files '*.md'`) auf Standangaben prüfen, die nicht
mehr stimmen; geändert seit `8e78401c` sind `5ab3e4ea` (Quelltext),
`1cf3d242` (Doku), `b5a8e717` (Prüfstand 36/36), `651a3b97`
(`tools/messen-e137.ps1`, E-137a–c) und `5b8cf839` (Paket 1.0.126
geschnürt). (3) Schwerpunkt für den PR: ob Gregor den Kurztest V1–V5 an
`C:\Users\Gregor\Eudora72-1.0.126-release` ohne Rückfrage fahren kann; ob
Fassung, Zweig, Paket, Testzahlen (314 Unit, 19 Schranken, 39 Prüfstand)
und der Stand von [E-137](../Intern/BEFUNDE.md#e-137) (Strg+W nach einem
Klick auf die schwebende Filterleiste schließt die Mail statt der Leiste)
und [E-160](../Intern/BEFUNDE.md#e-160) (Windows-Meldung „kein
E-Mail-Programm zugeordnet“ beim Anlegen einer Persönlichkeit) überall
gleich stehen; ob [L-84.2](LEKTOR-84.md#l-84.2) und [L-84.9](LEKTOR-84.md#l-84.9) den PR hindern. Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `5b8cf839` = `origin/0.125_ergebnisse`
(gemessen, `git log`).

**Ergebnis vorweg.** **7 Funde: 1 falsch, 3 veraltet, 3 unklar**; dazu
[L-84.9](LEKTOR-84.md#l-84.9) weiter offen. [L-84.1](LEKTOR-84.md#l-84.1), .3, .5, .7, .8 sind
erledigt, [L-84.4](LEKTOR-84.md#l-84.4) und [L-84.6](LEKTOR-84.md#l-84.6) bis auf Reste ([L-85.6](#l-85.6)). **Nirgends
wird [E-137](../Intern/BEFUNDE.md#e-137) oder [E-160](../Intern/BEFUNDE.md#e-160) als behoben oder bestätigt ausgegeben** (gemessen,
[unten](#keine-falsche-bestaetigung)). Wichtigster Fund: **das Urteil von
[E-137](../Intern/BEFUNDE.md#e-137) sagt im Kopf *„am Programm noch nicht gemessen“* und *„Zuletzt
gemessen: 26.10.2026 an 7.2.0.125“*, derselbe Eintrag meldet weiter hinten
den Prüfstandslauf am Bau 1.0.126 vom 27.10.2026, grün** ([L-85.1](#l-85.1));
die erzeugten Listen in CHANGELOG und WEITERMACHEN tragen das alte Datum
weiter. Zweitens: in `ZIEL.md` — laut README *„dort und nur dort, mit der
Angabe, wer es prüft“* — steht für [E-160](../Intern/BEFUNDE.md#e-160) *„wer ?“* und *„Wie zu prüfen: —
nicht aufgeschrieben“*, obwohl TESTPLAN V4 genau das ist ([L-85.2](#l-85.2)),
und [E-137](../Intern/BEFUNDE.md#e-137) fehlt im Maßstab weiter ([L-85.4](#l-85.4) = [L-84.2](LEKTOR-84.md#l-84.2)). Drittens: der
fünfte Anlauf (neuer Haken in `CEudoraApp::PreTranslateMessage`, durch den
jede Maus- und Tastatureingabe läuft) ist von keinem PRÜFER gelesen; das
steht offen in `Releases/PAKETE.md:171`, `rollen-faellig.pl` meldet den
PRÜFER fällig ([L-85.5](#l-85.5)). **Der Kurztest V1–V5 ist ohne Rückfrage
ausführbar** ([unten](#kurztest)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-84

| Fund | was passierte | Stand heute | Beleg |
|---|---|---|---|
| [L-84.1](LEKTOR-84.md#l-84.1) | [E-160](../Intern/BEFUNDE.md#e-160) war für die Zählwerkzeuge unsichtbar, ZIEL meldete „alle erfüllt“ | **erledigt** (die Zeile; die Klasse nicht, siehe unten) | `Intern/BEFUNDE.md:381` Urteil schließt den Fettdruck vor *„Gregors Entscheidung“*; gemessen: `offene-befunde.pl` *„42 offene Befunde, in beiden Listen gleich“*, `ziel-stand.pl` *„25 von 26 erfüllt, 1 offen“*, `CHANGELOG.md:27` und `Intern/WEITERMACHEN.md:358` führen [E-160](../Intern/BEFUNDE.md#e-160) |
| [L-84.2](LEKTOR-84.md#l-84.2) | [E-137](../Intern/BEFUNDE.md#e-137), Voraussetzung für 7.2.1, hat keine Zeile im Maßstab | **offen** → [L-85.4](#l-85.4) | gemessen: `grep -n -i 'e-137' ZIEL.md` → nur `:200`, eine Logmarke als Beispiel im Text zu Kriterium 2a |
| [L-84.3](LEKTOR-84.md#l-84.3) | E-137-Urteil stand in Kopf, „Was noch fehlt“, Messdatum vor U1 | **erledigt** — aber durch `651a3b97` wieder überholt, siehe [L-85.1](#l-85.1) | `Intern/BEFUNDE.md:396` Kopf *„an Paket 1.0.125 nicht bestanden (Kurztest U1 …); fünfter Anlauf eingebaut … (TESTPLAN V1–V3)“*, *„Was noch fehlt: Gregors Prüfung an 1.0.126 … (V1, V2) … (V3)“*, *„Zuletzt gemessen: 26.10.2026 an 7.2.0.125“* |
| [L-84.4](LEKTOR-84.md#l-84.4) | Absatz „Stand 26.10.2026, 21:00 — hier weiter“ überholt | **erledigt**, Rest siehe [L-85.6](#l-85.6) | `Intern/WEITERMACHEN.md:135` neuer Block *„Stand 27.10.2026 — hier weiter“*; `:137` *„überholt durch den Block darüber“* |
| [L-84.5](LEKTOR-84.md#l-84.5) | Entscheidungsblock: alter Zweig, [E-137](../Intern/BEFUNDE.md#e-137) „im nächsten Paket zu prüfen“ | **erledigt** | `:118` *„der aktuelle Stand steht im Block „Stand 27.10.2026“ …; `origin/main` = PR #178“* (gemessen: `git log -1 origin/main` → `b3a2ab6e Merge pull request #178`); `:121` *„an 1.0.125 nicht bestanden (U1), fünfter Anlauf eingebaut, an 1.0.126 zu prüfen (V1–V3)“* |
| [L-84.6](LEKTOR-84.md#l-84.6) | „drei Testpakete davor am 26.10.“ | **erledigt**; Nebenpunkt `:10` **offen** → [L-85.6](#l-85.6) | `:12` *„die beiden Testpakete davor (1.0.124 und 1.0.123)“*; `:10` beginnt weiter mit *„7.2.0.123 (Paket 1.0.123 …)“* |
| [L-84.7](LEKTOR-84.md#l-84.7) | V4 nannte *Neu*, U4 fehlte, „V1 nein“ | **erledigt** | `Intern/TESTPLAN.md:25` *„Tools → Personalities öffnen (Register Persona), in die Liste rechtsklicken → New...“*, Wo *„lokal“*; `:12-13` *„U2 bis U4“*; `:28` *„etwa „V2 nein““* |
| [L-84.8](LEKTOR-84.md#l-84.8) | CHANGELOG sagte die E-160-Wirkung als Tatsache | **erledigt** | `CHANGELOG.md:120-125` *„soll die Windows-Meldung … nicht mehr kommen … am Programm noch nicht gemessen“*; gemessen: `grep 'Meldung mehr'` über README, ZIEL, CHANGELOG, `Intern/*.md` (ohne BEFUNDE), PAKETE → kein Treffer |
| [L-84.9](LEKTOR-84.md#l-84.9) | PAKETE vermerkt Gregors Test an 1.0.124 und 1.0.125 nicht | **offen** | `Releases/PAKETE.md:176-190` (1.0.125) und `:192-206` (1.0.124) ohne den Satz, den `:211` für 1.0.123 hat: *„Von Gregor am 26.10.2026 getestet, Ergebnis: [TESTPLAN.md](…#ergebnis-7-2-0-123).“* |

**Die Klasse hinter [L-84.1](LEKTOR-84.md#l-84.1) ist nicht abgestellt.** Gebaut wurde keine
Abweisung für ein Urteil, dessen erste Fettstelle weder Offen- noch
Erledigt-Wort trägt (Vorschlag aus [L-80.1](LEKTOR-80.md#l-80.1) und [L-84.1](LEKTOR-84.md#l-84.1));
berichtigt wurde nur die Zeile. Kein neuer Fund, weil schon zweimal gemeldet
— aber beim dritten Auftreten ist es dieselbe Ursache.

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | was sie **nicht** sieht |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Quellstand 7.2.0.126, Paketnummer 1.0.126 … gepruefte Dateien 47 … Kein Widerspruch gefunden.“* Zur Kenntnis 16 Dateien ohne die aktuelle Fassung, alle geschichtlich — kein Fund | ob README „vierter“ oder „fünfter“ Anlauf sagt ([L-85.3](#l-85.3)) |
| `perl tools/offene-befunde.pl` | *„42 offene Befunde, in beiden Listen gleich.“* rc=0 | dass das Messdatum von [E-137](../Intern/BEFUNDE.md#e-137) überholt ist ([L-85.1](#l-85.1)) |
| `perl tools/pruefe-regressionstest.pl` | *„behoben und OHNE Testfall 68 <- Rueckstand“*; kritisch ohne Prüfung 22; *„Kein neues "behoben" ohne Regressionstest.“* | — |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 25 von 26 erfüllt, 1 offen - ZIEL.md ist auf dem Stand.“* | [E-137](../Intern/BEFUNDE.md#e-137) (keine Zeile, [L-85.4](#l-85.4)); dass „wer ?“ bei [E-160](../Intern/BEFUNDE.md#e-160) falsch ist ([L-85.2](#l-85.2)) |
| `perl tools/pruefe-befundurteile.pl` | *„Kein Dokument erklaert einen offenen Befund fuer erledigt“* rc=0 | — |
| `perl tools/rollen-faellig.pl` | LEKTOR, **PRÜFER** (*„10 Datei(en) … WazooBarMgr.cpp, WazooBarMgr.h, eudora.cpp und 7 weitere“*) und CHRONIST fällig | — ([L-85.5](#l-85.5)) |

---

## <a id="l-85.1"></a>L-85.1 — falsch: das Urteil von E-137 sagt „am Programm noch nicht gemessen“, zuletzt gemessen an 7.2.0.125 — derselbe Eintrag meldet den Prüfstandslauf am Bau 1.0.126, grün

**Was passiert:** wer den Kopf oder die Listen „Noch offen“ liest, hält den
fünften Anlauf für ungeprüft und das letzte Ergebnis für U1 (nein); in
Wahrheit ist er seit dem Mittag des 27.10. am laufenden Programm nachgestellt
und grün — mit Grenzen, die nirgends zusammen stehen.

* **Belegt**, `Intern/BEFUNDE.md:396`: Kopf *„\*\*offen — … fünfter Anlauf
  eingebaut am 27.10.2026 für Paket 1.0.126 (TESTPLAN V1–V3), am Programm
  noch nicht gemessen.\*\*“*; weiter hinten *„\*\*Zuletzt gemessen:
  26.10.2026 an 7.2.0.125\*\*“*; am Ende (eingefügt mit `651a3b97`)
  *„\*\*Regressionstest am laufenden Programm (27.10.2026 …):\*\*
  `tools/messen-e137.ps1` … \*\*am Bau 1.0.126 grün\*\* (`mail-offen=1
  leiste-versteckt=1` …)“*.
* **Gemessen**, `Intern/pruefstand-buch.tsv`: `E-137a ok 2026-10-27
  12:49:20 C:\Temp\E137 Eudora 7.2.0.126 / Paket 1.0.126+5ab3e4ea`, ebenso
  `E-137b`, `E-137c`; `tools/TESTLAEUFE.md` zwei Läufe an 7.2.0.125 (12:48)
  und vier an 7.2.0.126.
* **Folge, gemessen:** `CHANGELOG.md:40` und `Intern/WEITERMACHEN.md:371`
  (erzeugt) *„26.10.2026 an 7.2.0.125“*. `offene-befunde.pl` zählt [E-137](../Intern/BEFUNDE.md#e-137)
  damit weiter unter dem Stand vor dem Prüfstand.
* **Grenzen des Prüfstandsfalls, belegt am Skript** — sie gehören in den
  Kopf, damit „gemessen“ nicht als „bestätigt“ gelesen wird:
  `tools/messen-e137.ps1:213-221` schickt `WM_LBUTTONDOWN` in die
  Postfachliste und `WM_NCLBUTTONDOWN` mit `HTCAPTION`/`HTLEFT` an den
  Rahmen als **Fensterbotschaft** (`PostMessageA`), `:225` danach
  `ID_FILE_CLOSE` als **Befehl** an das Hauptfenster. Nicht gefahren werden
  damit (Vermutung, nicht gemessen, ob es einen Unterschied macht): der
  echte Mausklick (Aktivierung, Ziehschleife von `CDockContext`), der
  Tastenweg — `CMainFrame::E137EingabeMerken` (`mainfrm.cpp:3409-3428`)
  löscht die Marke bei jeder Taste außer Strg, Umschalt und W, das sieht
  der Prüfstand nie —, und statt einer geöffneten **Mail** (V1) ist das
  Fenster dahinter das Postfach `In` (`mail-offen` heißt im Skript das
  Fenster hinter der Leiste). V3 (angedockt) hat keinen Fall; das steht
  schon richtig in `:396` *„Der angedockte Fall (V3 …) hat noch keinen
  Prüfstandsfall.“*
* Nebenbei: `CHANGELOG.md:108` sagt *„Strg+W gilt jetzt der Leiste …“* als
  Tatsache, [E-160](../Intern/BEFUNDE.md#e-160) im selben Abschnitt vorsichtig (*„soll … nicht mehr
  kommen“*); gedeckt durch den Prüfstand und *„Gregors Test steht noch aus“*
  (`:119`) — kein eigener Fund.

**Was zu tun wäre:** im Kopf von [E-137](../Intern/BEFUNDE.md#e-137) *„am Programm noch nicht
gemessen“* ersetzen durch etwa *„am Prüfstand nachgestellt und grün (Klick
als Fensterbotschaft auf Titelzeile und Rand, Befehl statt Tastendruck,
Postfach statt Mail; V3 ohne Fall), Gregors V1–V3 steht aus“* — ohne
kursives Zitat im Fettdruck (sonst [L-84.1](LEKTOR-84.md#l-84.1) zum dritten
Mal); *„Zuletzt gemessen: 27.10.2026 an 7.2.0.126 (Prüfstand)“*; dann
`perl tools/offene-befunde.pl -schreiben`. **Vor dem PR.**

## <a id="l-85.2"></a>L-85.2 — veraltet: E-160 „im nächsten Testpaket: *Persona* → Rechtsklick → *Neu*“, und `ZIEL.md` meldet „wer ?“ und „Wie zu prüfen: nicht aufgeschrieben“

**Was passiert:** die einzige offene Zeile im Maßstab für 7.2.1 sagt, es
sei nicht aufgeschrieben, wie und von wem geprüft wird — dabei steht der
Schritt fertig als V4 im TESTPLAN, mit dem richtigen Menüeintrag, und das
Paket ist geschnürt.

* **Belegt**, `ZIEL.md:52` (erzeugt): *„| \*\*[E-160](../Intern/BEFUNDE.md#e-160)\*\* | ? | Gregors
  Prüfung im nächsten Testpaket: \*Persona\* → Rechtsklick → \*Neu\* … | —
  \*\*nicht aufgeschrieben\*\* |“*. Quelle ist `Intern/BEFUNDE.md:381`:
  *„\*\*Was noch fehlt:\*\* Gregors Prüfung im nächsten Testpaket:
  \*Persona\* → Rechtsklick → \*Neu\*, …“*, ohne Marke
  `**Wie zu pruefen:**` — `tools/ziel-stand.pl:110-121` setzt dann *„?“*
  und *„nicht aufgeschrieben“* (belegt am Werkzeug).
* **Belegt**, `README.md:143-144`: *„Was zur Fassung 7.2.1 noch fehlt,
  steht erzeugt ganz oben in ZIEL.md — dort und nur dort, mit der Angabe,
  wer es prüft.“*
* **Belegt**, Gegenstück: `Intern/TESTPLAN.md:25` V4 *„Tools →
  Personalities … → New...“*; [L-84.7](LEKTOR-84.md#l-84.7) hat den Wortlaut
  dort berichtigt, in BEFUNDE nicht. Dasselbe alte Wort in `ZIEL.md:76`
  (*„\*Persona\* → \*Neu\*“*, *„kommt mit 7.2.0.126“*), `CHANGELOG.md:27`,
  `Intern/WEITERMACHEN.md:358`.

**Was zu tun wäre:** in `Intern/BEFUNDE.md:381` *„Was noch fehlt:
Gregors V4 an Paket 1.0.126 (TESTPLAN).“* und dahinter
`**Wie zu pruefen:** Gregor — TESTPLAN V4: *Tools → Personalities*,
Rechtsklick in die Liste → *New...*; die Windows-Meldung darf nicht
kommen.` (das Werkzeug erkennt *Gregor* am Wort, `ziel-stand.pl:120`); dann
`offene-befunde.pl -schreiben` und `ziel-stand.pl`. **Vor dem PR.**

## <a id="l-85.3"></a>L-85.3 — veraltet: README und AUFGABEN nennen den „vierten Teil“ von E-137

**Was passiert:** die Kopfzeile, die ein Leser von `main` zuerst sieht,
nennt den Anlauf, von dem PRÜFER-61 gezeigt hat, dass er nie lief.

* **Belegt**, `README.md:101`: *„Testpaket mit dem vierten Teil von
  [[E-137](../Intern/BEFUNDE.md#e-137)] (Strg+W nach einem Klick auf Titelzeile oder Rand der schwebenden
  Leiste) und [[E-160](../Intern/BEFUNDE.md#e-160)] …“*; `Intern/AUFGABEN.md:3` *„Testpaket mit dem
  vierten Teil von [[E-137](../Intern/BEFUNDE.md#e-137)] und [[E-160](../Intern/BEFUNDE.md#e-160)]“*.
* **Belegt**, Gegenstand: `Intern/WEITERMACHEN.md:9,12` *„Testpaket mit dem
  fünften Anlauf zu [[E-137](../Intern/BEFUNDE.md#e-137)]“*; `CHANGELOG.md:101` *„fünfter Anlauf“*;
  `Intern/BEFUNDE.md:396` *„\*\*Fünfter Anlauf (27.10.2026, PRÜFER-61 K1):\*\*
  auch der vierte hätte nicht gegriffen.“*
* `tools/ZWEIGE.md:175` (*„vierter Anlauf zu [E-137](../Intern/BEFUNDE.md#e-137)“*) beschreibt den Zweck
  des Zweigs bei seiner Vereinbarung am 26.10. — geschichtlich, kein Fund.

**Was zu tun wäre:** an beiden Stellen *„fünften Anlauf“*. **Vor dem PR.**

## <a id="l-85.4"></a>L-85.4 — unklar: E-137 steht weiter nicht im Maßstab (L-84.2)

**Was passiert:** wie in [L-84.2](LEKTOR-84.md#l-84.2): wer in `ZIEL.md`
nachsieht, was vor 7.2.1 fehlt, findet nur [E-160](../Intern/BEFUNDE.md#e-160) — nicht den Strg+W-Fehler,
den Gregor vor 7.2.1 behoben haben will (`Intern/WEITERMACHEN.md:121`,
Entscheidung 2) und dessen Prüfung V1–V3 gerade ansteht.

* **Gemessen:** `grep -n -i 'e-137' ZIEL.md` → nur `:200` (Logmarke als
  Beispiel). `ziel-stand.pl` → *„25 von 26 erfüllt, 1 offen“*.
* **Hindert es den PR?** Es macht keine falsche Aussage über [E-137](../Intern/BEFUNDE.md#e-137), und
  `main` (PR #178) hat dieselbe Lücke schon. Aber der Fund ist bekannt, und
  nach [Einschränkung im PR ist kein Ja](../Arbeitsweise/einschraenkung-im-pr-ist-kein-ja.md)
  geht ein bekannter Fund nur mit Gregors Ja zu genau diesem Fund mit; die
  Berichtigung ist eine Zeile. **Vor dem PR beheben**, nicht Gregor fragen.

**Was zu tun wäre:** eine Maßstabszeile für [E-137](../Intern/BEFUNDE.md#e-137) (Gruppe ist Sache des
Hauptagenten) mit Verweis auf Entscheidung 2; danach meldet `ziel-stand.pl`
zwei offene Zeilen.

## <a id="l-85.5"></a>L-85.5 — unklar: der fünfte Anlauf ist von keinem PRÜFER gelesen und geht mit dem PR nach `main`

**Was passiert:** der Code, der jetzt bei Gregor liegt und nach `main` soll,
hängt einen neuen Haken in die Nachrichtenschleife des ganzen Programms; ihn
hat außer dem Prüfstand niemand gegengelesen.

* **Belegt**, `Releases/PAKETE.md:171`: *„gebaut mit
  `-RollenSindGelaufen`: PRÜFER-61 und [LEKTOR-84](LEKTOR-84.md#lektor-84) waren gelaufen und
  eingearbeitet. Danach kam der fünfte Anlauf zu [E-137](../Intern/BEFUNDE.md#e-137) — \*\*von keinem
  PRÜFER gegengelesen\*\*, aber am Prüfstand rot (1.0.125) und grün (1.0.126)
  gemessen“* — offen gesagt, kein Fund an der Doku.
* **Gemessen:** `perl tools/rollen-faellig.pl` → *„PRUEFER ist faellig:
  seit seinem Bericht (00f08e1) haben sich 10 Datei(en) in seinem Bereich
  geaendert - Eudora71/Eudora/WazooBarMgr.cpp, … eudora.cpp und 7 weitere.“*
  `git show --stat 5ab3e4ea`: `eudora.cpp`, `mainfrm.cpp`, `WazooBarMgr.cpp`,
  `workbook.cpp`, `OLImportClass.cpp` u. a.
* **Belegt am Quelltext:** `Eudora71/Eudora/eudora.cpp:1907-1915` ruft bei
  **jedem** `WM_LBUTTONDOWN`, `WM_RBUTTONDOWN`, `WM_NC*BUTTONDOWN`,
  `WM_KEYDOWN`, `WM_SYSKEYDOWN` `CMainFrame::E137EingabeMerken` →
  `CWazooBarMgr::GetWazooBarAt`. Auch die Ergänzung zu [E-160](../Intern/BEFUNDE.md#e-160) für Outlook
  2013+ (`OLImportClass.cpp`, PRÜFER-61 K3) ist ungelesen.
* `tools/haken-pr-lektor.pl` sperrt den PR nur, solange der LEKTOR fällig
  ist (`CLAUDE.md`, Abschnitt 1) — ein fälliger PRÜFER hält ihn nicht auf.

**Was zu tun wäre:** vor dem PR einen PRÜFER über `5ab3e4ea` laufen
lassen, oder den PR ausdrücklich mit diesem Vermerk stellen. Welches von
beiden, entscheidet der Hauptagent (Reihenfolge der Rollen ist ihm
übertragen); dass der Vermerk allein reicht, ist eine Einschränkung im PR
im Sinne der Lehre oben.

## <a id="l-85.6"></a>L-85.6 — veraltet: `Intern/WEITERMACHEN.md` — „danach PR“, Kopfdatum, Zeile „Quellstand davor“

**Was passiert:** der Einstieg sagt, der PR komme nach Gregors Kurztest —
er wird jetzt davor gestellt; Kopf und Vorgängerzeile stehen einen Tag bzw.
zwei Fassungen zurück.

* **Belegt**, `:135`: *„\*\*Als Nächstes:\*\* Gregors Kurztest V1–V5; erst
  wenn V1–V3 bestehen, ist Entscheidung 2 für 7.2.1 eingelöst; danach PR und
  Release 7.2.1.N.“* Der Auftrag an diesen LEKTOR nennt den jetzigen Stand
  ausdrücklich *„den Stand für einen PR des Zweigs 0.125_ergebnisse nach
  main“*. Wird der PR vor dem Test gestellt, muss der Satz das sagen
  (*„PR des Zweigs nach `main` gestellt (#…), Gregors Kurztest V1–V5 an
  1.0.126 steht aus; danach Release …“*).
* **Belegt**, `:3`: *„\*\*Stand 26.10.2026.\*\*“* — der Rest der Datei
  steht auf dem 27.10.
* **Belegt**, `:10` *„Quellstand davor“* beginnt weiter mit *„7.2.0.123
  (Paket 1.0.123, …)“*; 7.2.0.125 (U1 nein) und 7.2.0.124 fehlen — Nebenpunkt
  aus [L-84.6](LEKTOR-84.md#l-84.6), nicht berichtigt. `:9` nennt sie, also
  kein Widerspruch, nur Lücke.

**Was zu tun wäre:** die drei Stellen nachziehen. **Vor dem PR** (`:135`),
die beiden anderen im selben Commit.

## <a id="l-85.7"></a>L-85.7 — unklar: `Releases/PRUEFBERICHT.md` — Dauer „36 Fälle“ neben 39 Prüfstandsfällen

**Was passiert:** wer die Tests selbst fährt, liest *„zusammen 6 min 29 s“*
für einen Lauf, der die drei neuen E-137-Fälle nicht enthält.

* **Belegt**, `:16`: *„| Pruefstand, 36 Faelle, 11 Eudora-Starts | 6 min
  08 s | voller Lauf, Ende 2026-10-27 12:37:32 |“*; `:25` *„| Pruefstand
  (Oberflaeche) | 39 | 39 | 0 |“*. Quelle ist `Intern/pruefstand-dauer.txt`
  (*„faelle 36“*, letzter **voller** Lauf, `tools/pruefbericht.pl:300`);
  E-137a–c liefen um 12:44–12:49 einzeln (`tools/TESTLAEUFE.md`).
* Die Zeile sagt *„voller Lauf“* und ist damit nicht falsch; die Summe ist
  es für 39 Fälle.

**Was zu tun wäre:** nichts von Hand — beim nächsten vollen Lauf stimmt es
von selbst. Hindert den PR nicht.

---

## <a id="kurztest"></a>Kann Gregor V1–V5 an 1.0.126 ohne Rückfrage fahren?

**Ja** (belegt), mit einer Anmerkung.

* Vorbereitung `Intern/TESTPLAN.md:15-18`: Ordner, Startdatei und
  Titelzeile stimmen mit `Releases/PAKETE.md:166` (*„Testverzeichnis
  `C:\Users\Gregor\Eudora72-1.0.126-release`, neben seinem 1.0.125“*) und
  `tools/paket-bauen.ps1:595` (`Eudora starten.cmd` wird ins Paket gelegt).
* V1–V3 sind wortgleich mit U1–U3, die Gregor kennt (`:22-24` gegen `:53-55`); Menüweg *Tools → Filters* und die Beschriftung *„Match“* hat
  [LEKTOR-84](LEKTOR-84.md#l-84.7) an `EudoraRes.rc` geprüft.
* V4 (`:25`) nennt den richtigen Weg und *New...*; V5 (`:26`) wie U4.
* Rückmeldung (`:28`): *„die Nummer und \*nein\*, etwa \*„V2 nein““*.
* **Kommt die Logzeile an?** `E-137 Strg-W angekommen` wird mit
  `DEBUG_MASK_MISC` geschrieben (`mainfrm.cpp:3493`), das ist `0x8000`
  (`QCUtils/public/inc/debug.h:36`); das Paket-`LogLevel=58527` ist `0xE49F`
  und enthält es (gemessen, `printf '%x' 58527`). Die Vorbereitung ersetzt
  die Paket-`Eudora.ini` durch Gregors aus 1.0.125; dass seine dieselbe
  Maske trägt, ist **Vermutung** (seine U1-Log hatte E-76-Zeilen,
  `Intern/BEFUNDE.md:396`). Kein Fund — beim Ausbleiben der Zeile
  zuerst danach sehen (Lehre
  [Ausbleiben ist kein Befund](../Arbeitsweise/ausbleiben-ist-kein-befund.md)).

## <a id="keine-falsche-bestaetigung"></a>Wird E-137 oder E-160 irgendwo als behoben oder bestätigt ausgegeben?

Nein (gemessen: `grep -n -E 'E-137|e-137|E-160|e-160'` über `README.md`,
`ZIEL.md`, `Intern/AUFGABEN.md`, `CHANGELOG.md`, `Releases/PAKETE.md`,
`tools/WERKZEUGE.md`, `Doku/*.md`, `README.en.md`, `Intern/WEITERMACHEN.md`,
`Intern/TESTPLAN.md`, jede Fundstelle gelesen; `pruefe-befundurteile.pl`
rc=0). Beide Urteile beginnen mit **offen**; `ZIEL.md:76` *„Behebung
eingebaut … am Programm noch nicht gemessen“*; `CHANGELOG.md:103`
*„Testpaket, noch nicht getestet“*, `:119` *„Gregors Test steht noch aus“*;
`Releases/PAKETE.md:161` *„nicht veröffentlicht“*; `tools/WERKZEUGE.md:141`
beschreibt den Fall als Regressionstest, nicht als Bestätigung. Zu
vorsichtig ist nur eine Stelle: [L-85.1](#l-85.1).

## Stand je Datei (Fassung, Zweig, Paket, Testzahlen, E-137/E-160)

| Datei | Fassung / Paket | Zweig | Testzahlen | [E-137](../Intern/BEFUNDE.md#e-137) / [E-160](../Intern/BEFUNDE.md#e-160) | Urteil |
|---|---|---|---|---|---|
| `README.md:101,138-144` | 7.2.0.126 / 1.0.126 | — | — | „vierter Teil“ | [L-85.3](#l-85.3) |
| `ZIEL.md:44-53,76,173` | 7.2.0.126 / 1.0.126 | — | — | [E-160](../Intern/BEFUNDE.md#e-160) offen; [E-137](../Intern/BEFUNDE.md#e-137) fehlt | [L-85.2](#l-85.2), [L-85.4](#l-85.4) |
| `Intern/WEITERMACHEN.md:3,9-12,118-137` | 7.2.0.126 / 1.0.126, geschnürt | `0.125_ergebnisse` | 39/39 (`:135`) | fünfter Anlauf, offen | [L-85.6](#l-85.6) |
| `Intern/AUFGABEN.md:3` | 7.2.0.126 / 1.0.126 | — | — | „vierter Teil“ | [L-85.3](#l-85.3) |
| `CHANGELOG.md:27,40,101-127` | 7.2.0.126 / 1.0.126 | — | 314, Gegenprobe 313 | fünfter Anlauf; [E-137](../Intern/BEFUNDE.md#e-137) Messdatum alt | [L-85.1](#l-85.1), [L-85.2](#l-85.2) |
| `Releases/PAKETE.md:159-174` | 1.0.126, 27.10. 12:55 | `0.125_ergebnisse` | 314 / 19 / 39 | — | stimmt; [L-84.9](LEKTOR-84.md#l-84.9) |
| `Releases/PRUEFBERICHT.md:5-25` | 7.2.0.126, Commit `651a3b97`, Bau `5ab3e4ea` | — | 314 / 19 / 39, BESTANDEN | — | stimmt; [L-85.7](#l-85.7) |
| `Intern/TESTPLAN.md:1-36` | 7.2.0.126 / 1.0.126 | — | — | V1–V5 offen | stimmt |
| `tools/WERKZEUGE.md:141` | — | — | — | E-137a–c, rot 1.0.125 / grün 1.0.126 | stimmt |
| `Intern/BEFUNDE.md:381,396` | — | — | 314 | beide offen | [L-85.1](#l-85.1), [L-85.2](#l-85.2) |

Gemessen: Testzahlen 314/19/39 stehen gleich in `PRUEFBERICHT.md:23-25`,
`PAKETE.md:169`, `WEITERMACHEN.md:135` (*„Prüfstand 39/39“*),
`CHANGELOG.md:127` (*„314 Unit-Tests, 314 bestanden“*); kein Dokument nennt
für 7.2.0.126 eine andere Zahl (`grep` über die 61 Dateien nach
`31[0-4]`, `36/36`, `39/39`, `36 von 36`).

## Nicht geprüft

* Der Quelltext des fünften Anlaufs über das hinaus, was für die
  Doku-Aussagen nötig war (Sache des PRÜFERS, [L-85.5](#l-85.5)).
* Die übrigen `.md` des Bestands nur auf Standangaben durchsucht
  (`vierte[nr] (Teil|Anlauf)`, *„liegt bei Gregor“*, *„noch nicht gebaut“*,
  *„nicht geschnürt“*); Treffer außerhalb der Tabelle oben sind geschichtlich.
* Größe und Prüfsumme des ZIP (`PAKETE.md:167`) — liegt im Hauptbaum, den
  dieser Auftrag nicht anfasst.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) — ob ein frischer Test aller neun
  Kriterien nötig ist oder die Kurztests T, U, V reichen. Unverändert offen
  (`Intern/WEITERMACHEN.md:135` nennt es nicht mehr; zuletzt `:137`).
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)) — ob
  der Start auf einem Rechner ohne Visual Studio vor 7.2.1 noch einmal
  geprüft werden soll; zuletzt am 06.09.2026 an Paket 1.0.10.
