# <a id="lektor-84"></a>LEKTOR-84 — Bestand nach dem Fassungssprung auf 7.2.0.126 / Paket 1.0.126 (Zweig `0.125_ergebnisse`): E-137 vierter Anlauf, E-160, Kurztest V1–V5, 27.10.2026

**Auftrag.** (1) Die Funde aus [LEKTOR-83](LEKTOR-83.md) nachhalten.
(2) Den Bestand der `.md` (ohne `Arbeitsweise/` und `Befunde/`, 61 Dateien
aus `git ls-files '*.md'`) auf Standangaben prüfen, die nicht mehr stimmen;
geändert seit `903b0c6` sind die Commits `73f706a5`, `ef3642f4` und
`120e09f5`. (3) Schwerpunkt: ob Gregor den Kurztest V1–V5 an 7.2.0.126 ohne
Rückfrage fahren kann, ob überall derselbe Stand steht (U1 nein, U2–U4 nicht
getestet) und ob irgendwo [E-137](../Intern/BEFUNDE.md#e-137) (Strg+W schließt
nach einem Klick auf die schwebende Filterleiste die Mail statt der Leiste)
oder [E-160](../Intern/BEFUNDE.md#e-160) (Windows-Meldung „kein
E-Mail-Programm zugeordnet“ beim Anlegen einer Persönlichkeit) als behoben
oder bestätigt ausgegeben wird. Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `120e09f5`. `origin/0.125_ergebnisse` ist
seither nur um `d7534b03` (Eintrag in `tools/AGENTEN-LAUFEN.md`) weiter
(gemessen, `git log HEAD..origin/0.125_ergebnisse`).

**Ergebnis vorweg.** **9 Funde: 2 falsch, 4 veraltet, 3 unklar.**
Wichtigster Fund: **[E-160](../Intern/BEFUNDE.md#e-160) ist für alle drei
Zählwerkzeuge unsichtbar** — dieselbe Fehlerklasse wie
[L-80.1](LEKTOR-80.md#l-80.1) zwei Tage zuvor bei [E-137](../Intern/BEFUNDE.md#e-137): ein kursives Zitat
im fettgedruckten Urteil. Folge: `ZIEL.md` meldet *„26 von 26 erfüllt …
Alle Zeilen des Maßstabs sind erfüllt“*, obwohl die E-160-Zeile darin
ausdrücklich *„am Programm noch nicht gemessen“* sagt, und [E-160](../Intern/BEFUNDE.md#e-160) fehlt in
den Listen offener Befunde in `CHANGELOG.md` und `Intern/WEITERMACHEN.md`
([L-84.1](#l-84.1)). Dazu ist [E-137](../Intern/BEFUNDE.md#e-137), den
Gregor vor 7.2.1 behoben haben will und der an 1.0.125 durchgefallen ist,
gar keine Zeile des Maßstabs ([L-84.2](#l-84.2)). **Nirgends** wird [E-137](../Intern/BEFUNDE.md#e-137)
oder [E-160](../Intern/BEFUNDE.md#e-160) als behoben oder bestätigt ausgegeben (gemessen, siehe
[unten](#keine-falsche-bestaetigung)); der CHANGELOG formuliert die
E-160-Wirkung allerdings als Tatsache ([L-84.8](#l-84.8)). Der Kurztest
V1–V3 ist ohne Rückfrage ausführbar; V4 nennt einen Menüeintrag, den es so
nicht gibt ([L-84.7](#l-84.7)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**.

---

## Funde aus LEKTOR-83

[LEKTOR-83](LEKTOR-83.md) hatte **0 Funde**; nachzuhalten sind nur die zwei
Fragen an Gregor, die dort standen. Beide sind weiter offen (keine Antwort
in `Intern/WEITERMACHEN.md`, `ZIEL.md` oder `Intern/TESTPLAN.md`; belegt:
`Intern/WEITERMACHEN.md:135` *„Offen bei Gregor: Testumfang vor dem Release
7.2.1; Kriterium 0 ohne Visual Studio.“*). Sie stehen unten unter
[Was nur Gregor entscheiden kann](#gregor).

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | was sie **nicht** sieht |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„Quellstand 7.2.0.126, Paketnummer 1.0.126 … Kein Widerspruch gefunden.“* Zur Kenntnis 16 Dateien ohne die aktuelle Fassung (alle geschichtlich: `Doku/ANWENDER.md`, `Doku/HINTERGRUND.md`, Release-Notizen u. a.) — kein Fund | ob ein Befund offen ist |
| `perl tools/offene-befunde.pl` | *„41 offene Befunde, in beiden Listen gleich.“* rc=0 | **[E-160](../Intern/BEFUNDE.md#e-160)** — er ist offen und fehlt in beiden Listen ([L-84.1](#l-84.1)) |
| `perl tools/pruefe-regressionstest.pl` | *„behoben und OHNE Testfall 68 <- Rueckstand“*, kritisch ohne Prüfung 22; *„Kein neues "behoben" ohne Regressionstest.“* | — |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 26 von 26 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* | dass die E-160-Zeile offen ist ([L-84.1](#l-84.1)); [E-137](../Intern/BEFUNDE.md#e-137) hat keine Zeile ([L-84.2](#l-84.2)) |
| `perl tools/pruefe-befundurteile.pl` (Schranke in `tools/paket-bauen.ps1:297`) | *„Kein Dokument erklaert einen offenen Befund fuer erledigt“* rc=0 | dieselbe Lesart wie oben, also blind für [E-160](../Intern/BEFUNDE.md#e-160) |

---

## <a id="l-84.1"></a>L-84.1 — falsch: E-160 ist für `offene-befunde.pl`, `ziel-stand.pl` und `pruefe-befundurteile.pl` unsichtbar; `ZIEL.md` meldet „alle Zeilen erfüllt“

**Was passiert:** der Maßstab für 7.2.1 sagt, es fehle nichts mehr, und die
Liste „Noch offen“, die mit dem CHANGELOG nach `main` und in die
Release-Notizen geht, verschweigt einen Befund, dessen Behebung noch
niemand am Programm gesehen hat.

* **Belegt:** das Urteil `Intern/BEFUNDE.md:381` beginnt
  *„\*\*offen — Behebung eingebaut am 26.10.2026 (…), am Programm noch nicht
  gemessen; Gregors Entscheidung: \*„ja, outlook suche - beheben.“\*\*\*“* —
  das kursive Zitat steht **innerhalb** des Fettdrucks.
* **Gemessen** mit der Regel der Werkzeuge (`/\*\*([^*]+?)\*\*/`, erste
  Fettstelle der Urteilsspalte, `tools/ziel-stand.pl:65-66`, gleich in
  `tools/pruefe-befundurteile.pl:197`): erste erkannte Fettstelle von [E-160](../Intern/BEFUNDE.md#e-160)
  ist *„Eingebaut:“* — kein Offen-Wort, also gilt [E-160](../Intern/BEFUNDE.md#e-160) als nicht offen.
  Zum Vergleich [E-137](../Intern/BEFUNDE.md#e-137) (`:396`): erste Fettstelle *„offen — an Paket 1.0.124
  …“*, richtig erkannt.
* **Wirkung, gemessen:** `ZIEL.md:74` führt [E-160](../Intern/BEFUNDE.md#e-160) als Maßstabszeile mit
  *„(\*\*Behebung eingebaut\*\*, kommt mit 7.2.0.126; Unit-Test rot ohne und
  grün mit, am Programm noch nicht gemessen — TESTPLAN V4)“*, und derselbe
  erzeugte Block sagt `ZIEL.md:44` *„\*\*Stand: 26 von 26 erfüllt, 0
  offen.\*\*“* und `:50` *„\*\*Alle Zeilen des Maßstabs sind erfüllt.\*\*“*.
  `README.md:143` schickt den Leser genau dorthin: *„Was zur Fassung 7.2.1
  noch fehlt, steht erzeugt ganz oben in ZIEL.md — dort und nur dort“*.
  In den erzeugten Listen steht keine Zeile `| **[E-160]` (gemessen:
  `grep -n '\*\*\[E-160\]' CHANGELOG.md Intern/WEITERMACHEN.md` trifft nur
  `CHANGELOG.md:114`, den Fassungsabschnitt). Die richtige Zahl offener
  Befunde ist **42**, nicht 41.
* **Zum zweiten Mal dieselbe Klasse.** [L-80.1](LEKTOR-80.md#l-80.1)
  (26.10.2026) fand genau das bei [E-137](../Intern/BEFUNDE.md#e-137) und schlug vor, das Werkzeug solle
  ein Urteil melden, dessen erste Fettstelle weder Offen- noch Erledigt-Wort
  trägt; der Vorschlag ist nicht gebaut ([LEKTOR-81](LEKTOR-81.md), Tabellenzeile zu [L-80.1](LEKTOR-80.md#l-80.1): *„nicht gebaut (war nur
  Vorschlag)“*). Nach der Lehre
  [Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md) ist
  jetzt das Werkzeug dran, nicht nur die Zeile.

**Was zu tun wäre:** im Urteil von [E-160](../Intern/BEFUNDE.md#e-160) den Fettdruck vor *„Gregors
Entscheidung“* schließen; dann `perl tools/offene-befunde.pl -schreiben`
und `perl tools/ziel-stand.pl` neu setzen (ZIEL meldet dann eine offene
Zeile). Als Klasse: die drei Werkzeuge lesen die erste Fettstelle über
**eine** gemeinsame Funktion und weisen ab, wenn sie weder Offen- noch
Erledigt-Wort enthält. **Vor dem Paket** — `paket-bauen.ps1` verlässt sich
auf `pruefe-befundurteile.pl`, und der Prüfbericht des Pakets erbt den
ZIEL-Stand.

## <a id="l-84.2"></a>L-84.2 — unklar: E-137 ist eine Voraussetzung für 7.2.1, steht aber nicht im Maßstab

**Was passiert:** wer in `ZIEL.md` nachsieht, was vor dem Release fehlt,
findet den Strg+W-Fehler nicht, obwohl Gregor ihn vor 7.2.1 behoben haben
will und der letzte Anlauf an 1.0.125 durchgefallen ist.

* **Belegt:** `Intern/WEITERMACHEN.md:121`, Entscheidung 2 vom 25.10.2026:
  *„\*\*Vor 7.2.1 beheben:\*\* [[E-137](../Intern/BEFUNDE.md#e-137)] — …“*. `ZIEL.md` hat keine Zeile mit
  [E-137](../Intern/BEFUNDE.md#e-137) (gemessen: `grep -n 'e-137' ZIEL.md` → kein Treffer;
  `git log -S'e-137' -- ZIEL.md` → kein Commit, die Zeile hat es nie
  gegeben). `Intern/TESTPLAN.md:62`: U1 an 1.0.125 **nein**.
* Selbst nach der Berichtigung von [L-84.1](#l-84.1) bliebe ZIEL bei
  *„1 offen“* ([E-160](../Intern/BEFUNDE.md#e-160)) und nennte [E-137](../Intern/BEFUNDE.md#e-137) nicht. Die Lehre
  [Anforderung gehört in den Maßstab](../Arbeitsweise/anforderung-gehoert-in-den-massstab.md)
  sagt genau das: ein Requirement, das nur in der Umsetzung (hier:
  `WEITERMACHEN.md`) steht, ist keins.

**Was zu tun wäre:** eine Maßstabszeile für [E-137](../Intern/BEFUNDE.md#e-137) (Gruppe etwa
„Kriterium 4“ oder „Eingaben gehen verloren“ — Einstufung ist Sache des
Hauptagenten), mit Verweis auf Entscheidung 2. Dann rechnet `ziel-stand.pl`
[E-137](../Intern/BEFUNDE.md#e-137) mit. **Vor dem PR**, nicht vor dem Paket.

## <a id="l-84.3"></a>L-84.3 — veraltet: das Urteil von E-137 kennt das Ergebnis an 1.0.125 nur im Nachtrag; Kopf, „Was noch fehlt“ und „Zuletzt gemessen“ stehen auf dem Stand vor U1

**Was passiert:** die Listen „Noch offen“ in CHANGELOG und WEITERMACHEN
schicken den Leser zu einer Prüfung an Paket 1.0.125, die schon gelaufen
und gescheitert ist; das Messdatum nennt die Fassung davor.

* **Belegt**, `Intern/BEFUNDE.md:396`:
  * Kopf: *„der dritte Teil … ist eingebaut, nicht im Paket 1.0.124, aber im
    Paket 1.0.125 (TESTPLAN U1–U3) und am Programm noch nicht gemessen.“* —
    am Programm gemessen ist er seit U1 (nein).
  * *„\*\*Was noch fehlt:\*\* Gregors Prüfung an 1.0.125: Klick auf
    Titelzeile und Rand der \*\*schwebenden\*\* Leiste (U1, U2) und auf eine
    Beschriftung der \*\*angedockten\*\* Leiste (U3)“* — richtig wäre
    1.0.126, V1–V3.
  * *„\*\*Zuletzt gemessen: 26.10.2026 an 7.2.0.124\*\*“* — gemessen wurde
    am selben Tag an 7.2.0.125 (U1 und Gregors `eudora.log`, im Nachtrag
    derselben Zeile: *„\*\*Kurztest U1 an 1.0.125 (26.10.2026): nicht
    bestanden\*\*“*).
* **Gemessen, Folge:** `CHANGELOG.md:39` und `Intern/WEITERMACHEN.md:368`
  tragen beides weiter: *„26.10.2026 an 7.2.0.124 | Gregors Prüfung an
  1.0.125: Klick auf Titelzeile …“*.

**Was zu tun wäre:** Kopf *„… im Paket 1.0.125 an U1 nicht bestanden;
vierter Anlauf (`OnNcLButtonDown`) im Paket 1.0.126, TESTPLAN V1–V3, am
Programm noch nicht gemessen“* (Fettdruck dabei ohne kursives Zitat, sonst
wiederholt sich [L-84.1](#l-84.1)); *Was noch fehlt* auf 1.0.126 / V1–V3;
*Zuletzt gemessen: 26.10.2026 an 7.2.0.125*; dann `offene-befunde.pl
-schreiben`. Am besten im selben Commit wie [L-84.1](#l-84.1), **vor dem Paket**.

## <a id="l-84.4"></a>L-84.4 — veraltet: der Absatz „Stand 26.10.2026, 21:00 — hier weiter“ in `Intern/WEITERMACHEN.md`

**Was passiert:** der Einstieg für die nächste Sitzung sagt, 7.2.0.125
liege zum Test bei Gregor und als Nächstes kämen PR und Release.

* **Belegt**, `Intern/WEITERMACHEN.md:135`: *„Testpaket \*\*7.2.0.125\*\*
  liegt bei Gregor (…), Kurztest U1–U4 im [TESTPLAN]; Bau
  `1.0.125+46707a76`, 36 von 36 Prüfstandsfällen grün. … \*\*Als
  Nächstes:\*\* LEKTOR, PR stellen, Gregors Kurztest an 7.2.0.125, dann
  Release 7.2.1.N nach Entscheidung 10.“* Seit dem Abend des 26.10. gilt:
  U1 nein, U2–U4 nicht getestet (`Intern/TESTPLAN.md:62-65`), PR #178 ist
  gemergt (`b3a2ab6e`), der Zweig ist `0.125_ergebnisse`, Quellstand
  7.2.0.126, Paket 1.0.126 noch nicht gebaut (`Releases/PAKETE.md:161`),
  PRÜFER-61 läuft (`tools/AGENTEN-LAUFEN.md`).

**Was dort stehen müsste** (Vorschlag, Wortlaut Sache des Hauptagenten):

> **Stand 27.10.2026 — hier weiter:** Zweig `0.125_ergebnisse`, Quellstand
> **7.2.0.126** / `VERSION` **1.0.126** gesetzt, **Paket noch nicht
> gebaut**. Gregors Kurztest an 7.2.0.125 (26.10.2026): U1 **nein** (keine
> E-137-Zeile im Protokoll), U2–U4 nicht getestet — sie gehen in V2, V3 und
> V5 auf; nebenbei fand Gregor [[E-160](../Intern/BEFUNDE.md#e-160)]. Eingebaut für 7.2.0.126: [E-137](../Intern/BEFUNDE.md#e-137)
> vierter Anlauf (`QCMiniDockFrameWnd::OnNcLButtonDown`, Spurzeile vor jeder
> Entscheidung) und [E-160](../Intern/BEFUNDE.md#e-160) (kein MAPI ohne Outlook-Registry); Unit-Tests
> 313/313. PR #178 (bis 7.2.0.125) ist gemergt. **Als Nächstes:** PRÜFER-61
> und [LEKTOR-84](#lektor-84) einarbeiten, bauen, Prüfstand voll, Paket 1.0.126 schnüren
> und neben 1.0.125 ablegen, Gregors Kurztest V1–V5 ([TESTPLAN]); erst wenn
> V1–V3 bestehen, ist [E-137](../Intern/BEFUNDE.md#e-137) als Voraussetzung für 7.2.1 erfüllt
> (Entscheidung 2), danach Release 7.2.1.N nach Entscheidung 10. Offen bei
> Gregor: Testumfang vor dem Release 7.2.1; Kriterium 0 ohne Visual Studio.
> Später: Prüfstandsfall für [E-158](../Intern/BEFUNDE.md#e-158) und für den Rahmenklick aus [E-137](../Intern/BEFUNDE.md#e-137)
> ([PRÜFER-60] K2); CHRONIST ist fällig (`perl tools/rollen-faellig.pl`,
> gemessen 27.10.2026).

Der alte Absatz bleibt als *„überholt durch den Block darüber“* stehen, wie
es die Datei mit dem Block vom 24.10.2026 hält (`:137`). **Vor dem Paket
nicht nötig, vor dem PR ja.**

## <a id="l-84.5"></a>L-84.5 — veraltet: Kopfzeile und Entscheidung 2 des Entscheidungsblocks in `Intern/WEITERMACHEN.md`

**Was passiert:** der Block, der nach eigener Aussage *„vor dem Block
darunter“* gilt, nennt den alten Zweig und sagt über [E-137](../Intern/BEFUNDE.md#e-137), der dritte Teil
sei *„im nächsten Paket zu prüfen“* — er ist geprüft und gescheitert.

* **Belegt**, `:118`: *„\*\*Stand 26.10.2026 – HIER WEITERMACHEN, Zweig
  `0.123_ergebnisse`\*\* (…; `origin/main` = PR #175 …)“* — gemessen:
  `git log -1 origin/main` → `b3a2ab6e Merge pull request #178`.
* **Belegt**, `:121`: *„erster Teil … bestätigt, zweiter Teil an 1.0.124
  bestätigt (T1, zweiter Durchgang), dritter Teil (Titelzeile, Rand)
  eingebaut, im nächsten Paket zu prüfen“* — fehlt: *„an 1.0.125 U1 nicht
  bestanden; vierter Anlauf in 7.2.0.126 (V1–V3)“*.

**Was zu tun wäre:** beide Stellen nachziehen. Vor dem PR.

## <a id="l-84.6"></a>L-84.6 — falsch: „die drei Testpakete davor hat er am 26.10.2026 getestet“

**Was passiert:** ein Leser zählt ein Paket als am 26.10. getestet, das am
23.10. getestet wurde.

* **Belegt**, `Intern/WEITERMACHEN.md:12`: *„Am Testpaket davor hat Gregor
  am 26.10.2026 U1 geprüft (nein); die drei Testpakete davor hat er am
  26.10.2026 getestet. Das Paket davor wurde am 23.10.2026 geschnürt …“*.
  Vor 1.0.125 liegen 1.0.124 und 1.0.123, beide am 26.10.2026 getestet
  (`Intern/TESTPLAN.md` Ergebnistabellen 7.2.0.124 und 7.2.0.123); das
  dritte, 1.0.122, prüfte Gregor am 23.10.2026 (`Intern/TESTBERICHT-E125.md`,
  und derselbe Satz nennt es gleich danach als *„das Paket davor“*). Vor
  `120e09f5` stand dort richtig *„Die beiden Testpakete davor“* (gemessen,
  `git diff 903b0c6..HEAD -- Intern/WEITERMACHEN.md`).
* Nebenbei, **veraltet**: die Zeile *Quellstand davor* (`:10`) beginnt
  weiter mit *„7.2.0.123 (Paket 1.0.123 …)“* und nennt 7.2.0.125 und
  7.2.0.124 nicht.

**Was zu tun wäre:** *„die beiden Testpakete davor“*; `:10` mit 7.2.0.125
(U1 nein) und 7.2.0.124 beginnen lassen. Vor dem PR.

## <a id="l-84.7"></a>L-84.7 — unklar: TESTPLAN V4 nennt einen Menüeintrag, den es nicht gibt; dazu zwei kleine Unschärfen im Kurztest

**Was passiert:** an V4 muss Gregor raten, wo er klickt; der Rest von
V1–V5 ist ohne Rückfrage ausführbar.

* **Belegt**, `Intern/TESTPLAN.md:25`: *„V4 | [[E-160](../Intern/BEFUNDE.md#e-160)] | – | links die Leiste
  \*Persona\* öffnen, Rechtsklick → \*Neu\*“*. Im Programm heißt der
  Eintrag **New...** (`Eudora71/Eudora/EudoraRes.rc:6265` *„MENUITEM
  "Ne&w...", IDM_NEW_PERSONALITY“*); die Leiste öffnet *Tools →
  Personalities* (`:5814`), ihr Register heißt *Persona* (`:8008`
  `IDS_PERSONA_VIEW_NAME_LABEL "Persona"`). *„links“* hängt an Gregors
  Anordnung. In der Spalte *Wo* steht *„–“*; kein Postfach ist beteiligt,
  das wäre aber hinzuschreiben (Lehre
  [Testschritt nennt den Ort](../Arbeitsweise/testschritt-nennt-den-ort.md)).
  Dass *Neu* Gregors eigenes Wort ist (`Intern/BEFUNDE.md:381` *„ich habe bei
  persona rechtklick -> neu gewählt.“*), macht den Schritt nicht eindeutig.
* **Belegt**, `:12-13` *„dazu U2 und U3 aus 7.2.0.125, die noch offen
  waren“* gegen `:4-5` *„U2 bis U4 gehen in V2, V3 und V5 auf“* — U4 fehlt
  in der ersten Aufzählung.
* **Belegt**, `:28` *„Geht V1, V2 oder V3 schief, genügt mir \*„V1 nein“\*“*
  — gemeint ist vermutlich *„V\<n\> nein“*; so gelesen schreibt Gregor für
  einen Fehlschlag in V2 „V1 nein“.
* **Geprüft ohne Fund:** V1–V3 sind wortgleich mit U1–U3 (`:53-55`), die
  Gregor schon gefahren hat; Ort (*lokal, eine Mail aus `In` geöffnet*),
  Menüweg (*Tools → Filters*, `EudoraRes.rc:5807`) und die Beschriftung
  *„Match“* (`EudoraRes.rc:590`) stimmen; Vorbereitung und Titelzeile
  nennen 7.2.0.126 / 1.0.126 und den Ordner neben 1.0.125.

**Was zu tun wäre:** V4 *„Wo: kein Postfach“*; Schritt *„Tools →
Personalities (Register \*Persona\*), in der Liste Rechtsklick → \*New...\*“*;
`:12-13` *„U2 bis U4“*; `:28` *„„V2 nein“ (die Nummer des Schritts)“*.
**Vor dem Paket**, das heißt vor der Übergabe an Gregor.

## <a id="l-84.8"></a>L-84.8 — unklar: der CHANGELOG-Abschnitt 7.2.0.126 sagt die E-160-Wirkung als Tatsache

**Was passiert:** wer nur die Überschrift liest, hält die Windows-Meldung
für beseitigt; gemessen ist sie nur im Unit-Test.

* **Belegt**, `CHANGELOG.md:100`: *„… keine Windows-Meldung mehr beim
  Anlegen einer Persönlichkeit ([[E-160](../Intern/BEFUNDE.md#e-160)])“*; `:114-116` *„\*\*… kommt keine
  Windows-Meldung „kein E-Mail-Programm zugeordnet“ mehr.\*\*“*. Der
  Fassungskopf `:102` sagt richtig *„Testpaket, noch nicht getestet“*, und
  `ZIEL.md:74` und `Intern/BEFUNDE.md:381` sagen *„am Programm noch nicht
  gemessen“* (belegt). Für [E-137](../Intern/BEFUNDE.md#e-137) formuliert derselbe Abschnitt vorsichtig
  (*„hängt jetzt zusätzlich am Linksklick“*, `:107-110`).

**Was zu tun wäre:** Überschrift etwa *„Windows-Meldung beim Anlegen einer
Persönlichkeit ([[E-160](../Intern/BEFUNDE.md#e-160)]), Behebung eingebaut“*, im Punkt *„soll keine …
mehr kommen; am Programm noch nicht geprüft (TESTPLAN V4)“*. Vor dem PR.

## <a id="l-84.9"></a>L-84.9 — veraltet: `Releases/PAKETE.md` vermerkt Gregors Test an 1.0.124 und 1.0.125 nicht

**Was passiert:** die Paketliste sagt bei 1.0.123, ob und mit welchem
Ergebnis Gregor getestet hat, bei den beiden jüngeren Paketen nicht.

* **Belegt:** `Releases/PAKETE.md:200` (1.0.123) *„Von Gregor am 26.10.2026
  getestet, Ergebnis: [TESTPLAN.md](…#ergebnis-7-2-0-123).“*; die
  Abschnitte 1.0.125 (`:165-179`) und 1.0.124 (`:181-195`) haben keinen
  solchen Satz, obwohl `Intern/TESTPLAN.md` beide Ergebnisse führt
  (`#ergebnis-7-2-0-125`: U1 nein, U2–U4 nicht getestet;
  `#ergebnis-7-2-0-124`: T1–T6).

**Was zu tun wäre:** je ein Satz mit Verweis auf die Ergebnistabelle. Vor
dem PR, hält nichts auf.

---

## <a id="keine-falsche-bestaetigung"></a>Wird E-137 oder E-160 irgendwo als behoben oder bestätigt ausgegeben?

Nein (gemessen: `grep -n -E 'E-137|e-137|E-160|e-160'` über `README.md`,
`ZIEL.md`, `CHANGELOG.md`, `Intern/AUFGABEN.md`, `Intern/WEITERMACHEN.md`,
`Releases/PAKETE.md`, `Intern/TESTPLAN.md`, jede Fundstelle gelesen).
`README.md:101` nennt *„Testpaket mit dem vierten Teil von [[E-137](../Intern/BEFUNDE.md#e-137)] … und
[[E-160](../Intern/BEFUNDE.md#e-160)]“*, `:138-141` listet beide unter *„Neu in den Testpaketen … (noch
nicht veröffentlicht)“* ohne Wirkungsaussage; `Intern/AUFGABEN.md:3` und
`Intern/WEITERMACHEN.md:9,12` sagen *„Testpaket mit dem vierten Teil von
[E-137](../Intern/BEFUNDE.md#e-137) und [E-160](../Intern/BEFUNDE.md#e-160)“*; `ZIEL.md:74` *„Behebung eingebaut … am Programm noch
nicht gemessen“*. Einzige Tatsachenformulierung: [L-84.8](#l-84.8). Die
indirekte Aussage *„alle Zeilen erfüllt“* ist [L-84.1](#l-84.1).

## Stand je Datei (Fassung, Zweig, Ergebnis an 7.2.0.125)

| Datei | Fassung | Zweig | U1 nein / U2–U4 nicht getestet | Urteil |
|---|---|---|---|---|
| `README.md:101` | 7.2.0.126 / 1.0.126 | — | nicht genannt (nicht nötig) | stimmt |
| `ZIEL.md:173` | 7.2.0.126 / 1.0.126 | — | — | stimmt; Block `:44-50` siehe [L-84.1](#l-84.1) |
| `Intern/WEITERMACHEN.md:9,12` | 7.2.0.126 / 1.0.126 | `0.125_ergebnisse` | *„U1 geprüft (nein)“* | stimmt bis auf [L-84.6](#l-84.6); `:118`, `:121`, `:135` veraltet ([L-84.4](#l-84.4), [L-84.5](#l-84.5)) |
| `Intern/AUFGABEN.md:3` | 7.2.0.126 / 1.0.126 | — | nicht genannt | stimmt |
| `CHANGELOG.md:100-122` | 7.2.0.126 / 1.0.126 | — | *„U1 nicht bestanden“*; U2–U4 nicht erwähnt | stimmt; [L-84.8](#l-84.8) |
| `Releases/PAKETE.md:159-163` | 1.0.126 | `0.125_ergebnisse` | — | stimmt (Größe/Prüfsumme folgen, kein Fund); [L-84.9](#l-84.9) |
| `Intern/TESTPLAN.md:1-65` | 7.2.0.126 / 1.0.126 | — | `:62-65` U1 nein, U2–U4 *„nicht getestet“* | stimmt; [L-84.7](#l-84.7) |
| `Doku/MITARBEITEN.md:63` | Beispiel `1.0.126` | — | — | stimmt |
| `Releases/PRUEFBERICHT.md:5-8` | 7.2.0.126 | — | — | ehrlich vorläufig (*„NICHT VOLLSTAENDIG“*, Prüfstand *„an anderem Bau“*) — kein Fund |

## Nicht geprüft

* Die übrigen 52 `.md` des Bestands nur auf Standangaben durchsucht
  (`grep '7\.2\.0\.125\|1\.0\.125'`, *„liegt bei Gregor“*, *„Als Nächstes“*);
  Treffer außerhalb der Tabelle oben sind geschichtlich (`tools/TESTLAEUFE.md`,
  ältere Blöcke in `WEITERMACHEN.md`).
* Der Quelltext von [E-137](../Intern/BEFUNDE.md#e-137) und [E-160](../Intern/BEFUNDE.md#e-160) (Sache von PRÜFER-61).
* `README.en.md` (seit `903b0c6` unverändert, bewusst ohne Fassungsangaben).

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) — ob ein frischer Test aller neun
  Kriterien nötig ist oder die Kurztests T, U, V reichen.
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)) — ob
  der Start auf einem Rechner ohne Visual Studio vor 7.2.1 noch einmal
  geprüft werden soll; zuletzt am 06.09.2026 an Paket 1.0.10.
