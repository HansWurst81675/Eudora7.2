# LEKTOR-4 — alle 47 MD gegen ZIEL.md gemessen

**Agent:** LEKTOR · **Kennung:** `L-8` · **Zweig:** `doku-und-strg-n` ·
**Datum:** 07.09.2026 · **Bezugscommit:** `4f27a38` ·
**Zustand des Arbeitsbaums gemessen um:** 10:36 Uhr

**Nicht gebaut, Eudora nicht gestartet, keine Zeile Quelltext geändert.** Diese
Datei ist die einzige Änderung. Jede Aussage unten ist am Baum gemessen; der
Messbefehl steht dabei. Was ich nicht messen konnte, steht im letzten Abschnitt
und ist dort als **Vermutung** oder **nicht geprüft** benannt.

## Der Maßstab

`ZIEL.md` im **Arbeitsbaum**, nicht die Fassung auf GitHub:

| | |
|---|---|
| Kriterien | **neun** (0 bis 8) |
| belegt | **fünf** — 0, 1, 3, 5, 6 |
| fast oder halb | **drei** — 2, 4, 8 |
| nicht erfüllt | **eines** — 7 (das Beenden) |
| Quellstand | **7.2.0.21** — `grep EUDORA_BUILD_VERSION Eudora71/Version.h` |
| Paketnummer | **1.0.21** — `cat VERSION` |

Dazu vier eigene Messungen als zweiter Maßstab:

```sh
grep -n EUDORA_BUILD Eudora71/Version.h   # 7,2,0,21 / "Version 7.2.0.21\0" / "7.2.0.21"
cat VERSION                                # 1.0.21
ls Releases/*.zip                          # nur 1.0.2-lauffaehig und 1.0.21-release
git ls-remote --tags origin                # v1.0.1 .2 .3 .10 .14 .15 .18 .21
```

**Geprüft:** 47 Dateien (`git ls-files '*.md'` ohne `Arbeitsweise/`), jede
geöffnet. **15 Dateien** tragen eine Fundstelle, **32** nicht.
**29 Befunde, 56 Fundstellen.**

> **Der Baum hat sich während des Durchgangs bewegt.** Zwischen 09:50 und 10:36
> Uhr sind `README.md`, `AUFGABEN.md`, `CHANGELOG.md`, `WEITERMACHEN.md`,
> `ZIEL.md`, `PORTIERUNG.md` und `Releases/PAKETE.md` von außen geändert
> worden, HEAD ist von `41ad5df` auf `4f27a38` gewandert. **Alle Zitate und
> Zeilennummern unten sind um 10:36 Uhr gegengelesen.** Vier Fundstellen, die
> ich um 09:55 noch gemessen hatte, sind in dieser Zeit behoben worden und
> stehen deshalb nur noch als **W-0** unten, nicht als offener Mangel. Wer die
> Vorschläge einsetzt, prüft jede Zeilennummer nach.

---

## Die Tabelle: alle 47 Dateien

„Adressat erkennbar" heißt: die ersten Zeilen sagen, **für wen** die Datei ist
und **was in ihr gilt** — Stand, Status, und ob sie ein Zeitdokument ist.

| Datei | Adressat erkennbar? | Widerspruch gefunden? | Schwere |
|---|---|---|---|
| `ABRUF-PRUEFEN.md` | ja | nein | — |
| `AGENTEN.md` | ja | nein | — |
| `AUFGABEN.md` | ja | ja — W-2, W-13, W-14, W-16 | **hoch** |
| `BEFUNDE-ALTBESTAND.md` | ja | nein | — |
| `BEFUNDE.md` | ja | ja — W-5, W-8, W-9, W-10, W-11, W-12, W-18, W-24, W-25, W-27 | **hoch** |
| `Befunde/ASSISTENT.md` | ja | nein | — |
| `Befunde/FENSTER.md` | teils — Agent und Datum, kein Status | ja — W-28 | gering |
| `Befunde/LEKTOR-2.md` | ja | nein | — |
| `Befunde/LEKTOR-3.md` | ja | nein | — |
| `Befunde/LEKTOR.md` | ja | nein | — |
| `Befunde/OEFFNEN.md` | ja | nein | — |
| `Befunde/PAIGE.md` | **nein** — kein Agent, kein Datum, kein Status | nein | gering |
| `Befunde/PAKET.md` | ja | nein — diese Datei ist der **Gegenbeleg** zu W-2 | — |
| `Befunde/PERSONA.md` | ja | nein | — |
| `Befunde/PORT.md` | ja | nein | — |
| `Befunde/POSTFACH.md` | ja | nein | — |
| `Befunde/PRUEFER-3.md` | ja | nein | — |
| `Befunde/SPUR.md` | ja | nein | — |
| `Befunde/SYMBOLE-VORARBEIT.md` | ja | nein | — |
| `Befunde/SYMBOLE.md` | teils — kein Status | nein | — |
| `Befunde/VERFASSEN.md` | teils — kein Status | nein | — |
| `Befunde/VERFASSER.md` | ja | ja — W-28 | gering |
| `CHANGELOG.md` | ja | ja — W-3, W-4, W-5, W-7, W-29 | **hoch** |
| `Eudora71/OTShim/BEFUND-ANSICHT.md` | ja | nein | — |
| `Eudora71/OTShim/BEFUND-MENUE.md` | ja | nein | — |
| `Eudora71/OTShim/INVENTAR.md` | ja — nennt sich selbst fehlerhaft | nein | — |
| `Eudora71/OTShim/PLAN.md` | ja | nein | — |
| `Eudora71/OpenSSL3/BAUEN.md` | ja | nein | — |
| `Eudora71/Tests/QCSSL/README.md` | ja | nein | — |
| `Eudora71/VC71Bruecke/BEFUND.md` | ja | nein | — |
| `LEKTORAT.md` | **nein** — der Kopf gilt nur für den ersten von sieben Durchgängen | ja — W-20, W-22 | mittel |
| `PORTIERUNG.md` | **nein** — sagt nicht, für wen sie ist | ja — W-2, W-18, W-31 | **hoch** |
| `PRUEFBERICHT.md` | ja | nein — Zeitdokument vom 30.08. | — |
| `PRUEFUNG-BAU.md` | teils — Auftrag ja, Stand nein | ja — W-17 | mittel |
| `PRUEFUNG-BRANCH.md` | ja | nein — Zeitdokument | — |
| `PRUEFUNG-CODE.md` | ja | nein — Zeitdokument | — |
| `Pruefung/PRUEFUNG-KETTE.md` | ja | nein | — |
| `Pruefung/PRUEFUNG-PAKET.md` | ja | nein — Zeitdokument | — |
| `Pruefung/PRUEFUNG-ZEIGER.md` | ja | nein | — |
| `README.md` | ja | ja — W-2, W-18, W-19, W-23 | **hoch** |
| `Releases/1.0/AUSLIEFERUNGEN.md` | ja | nein | — |
| `Releases/1.0/README.md` | ja | ja — W-26 | gering |
| `Releases/PAKETE.md` | ja | ja — W-2, W-6a bis W-6d | mittel |
| `STARTUMGEBUNG.md` | ja | ja — W-2 | mittel |
| `WEITERMACHEN.md` | ja | ja — W-5, W-15 | **hoch** |
| `ZIEL.md` | ja | ja — W-2 | **hoch** |
| `tools/patches/zertifikatspruefung-verschaerfen.md` | ja | nein | — |

---

## W-0 — vier Fundstellen sind während des Durchgangs behoben worden

Kein Mangel mehr; hier festgehalten, damit niemand sie noch einmal sucht, und
weil eine davon eine **Fehlerklasse** zeigt.

| Was um 09:55 falsch war | um 10:36 gemessen |
|---|---|
| **`README.md:26`, `WEITERMACHEN.md:11`, `Releases/PAKETE.md:22/136/149` behaupteten eine Marke `v1.0.21`, die es nicht gab.** Um 09:58 lieferten `git tag` und `git ls-remote --tags origin` als jüngste Marke `v1.0.18` auf `e881164` | Die Marke existiert jetzt: `v1.0.21` → `253f81a`, entpackt `6ff03e7`, **auch auf `origin`** (`git ls-remote --tags origin` nennt sie). Die Aussagen sind richtig geworden |
| `WEITERMACHEN.md:10` nannte die Paketnummer **1.0.18**, `:11` die Marke `v1.0.18`, `:12` Gregors 1.0.18-Urteil als sein Urteil zu 1.0.21, und die Kriterientabelle `:28-31` führte **4 bis 7 alle als „nicht erfüllt"** | Kopftabelle und Kriterientabelle stimmen mit `ZIEL.md` überein (`:9-14`, `:29-35`) |
| `PORTIERUNG.md:29` sagte *„drei von acht Kriterien belegt, eines fast, vier nicht"* | *„von **neun** Kriterien sind fünf belegt (0, 1, 3, 5, 6), drei fast oder halb (2, 4, 8), eines ist nicht erfüllt (7)"* |
| `Releases/PAKETE.md:9-11` behauptete, im Repo lägen neun ZIPs, und `:15` einen Quellstand von 7.2.0.18 | Kasten `:6-27` stimmt: nur 1.0.2 und 1.0.21 liegen im Repo, Quellstand 7.2.0.21. Dazu ein neuer Abschnitt **1.0.21** bei `:136` |

**Die Fehlerklasse dahinter:** eine Marke, ein Paket oder eine
Veröffentlichung wurde in der Doku angekündigt, **bevor** sie existierte. Das
lässt sich mechanisch abstellen — siehe W-21, Vorschlag 1.

---

## W-2 (hoch) — sechs Dateien nennen `paket-pruefen.ps1` unbrauchbar; PR-2.0 ist behoben

Der schwerste Befund dieses Durchgangs, weil er seit dem 06.09.2026
**schriftlich benannt** ist und niemand ihn angefasst hat.

**Was gilt** — `Befunde/PAKET.md:1`, die Überschrift des Befundes selbst:

> `## PR-2.0 — Der Paketprüfer prüfte die Maschine statt das Paket (behoben)`

`Befunde/PAKET.md:193-209` listet unter *X-8.3 — Aussagen über den Prüfer sind
jetzt überholt* die Dateien auf, die die alte Aussage noch tragen:

> `Mehrere Dateien sagen, `paket-pruefen.ps1` tauge nicht als Freigabekriterium.`
> `Das galt für die alte Fassung und stimmt nicht mehr:`

Die dort genannten Zeilennummern sind verrutscht. **Heutige Fundstellen, jede
um 10:36 nachgesehen:**

| Datei | Zeile | Zitat |
|---|---|---|
| `README.md` | 415 | „**Taugt nicht als Freigabekriterium** — es prüft die Maschine statt das Paket und warnt bei einem Release-Paket viermal falsch (PR-2.0 bis PR-2.3)" |
| `ZIEL.md` | 91, 99 | „**`tools/paket-pruefen.ps1` ist NICHT dieser Nachweis.**" … „Bis das behoben ist (PR-2.0 bis PR-2.3), ist es kein Freigabekriterium." |
| `AUFGABEN.md` | 174 | „### C1 · `paket-pruefen.ps1` ist unbrauchbar als Freigabekriterium (**PR-2**)" |
| `PORTIERUNG.md` | 500-501 | „`tools/paket-pruefen.ps1` taugt dafür weiter nicht (PR-2.0 bis PR-2.3) und ist deshalb **kein** Freigabekriterium." |
| `STARTUMGEBUNG.md` | 169-170 | „**Kein Freigabekriterium** — es prüft die Maschine mit, nicht nur das Paket (PR-2.0 bis PR-2.3)." |
| `Releases/PAKETE.md` | 221 | „**taugt nicht als Freigabekriterium**, siehe PR-2.0" |

`PRUEFBERICHT.md:440`, `PRUEFUNG-BRANCH.md:25` und
`Pruefung/PRUEFUNG-PAKET.md:235-238` sagen dasselbe, sind aber datierte
Zeitdokumente vom 30.08. und 05.09. — **die bleiben stehen.**

**Woher ich weiß, dass es nicht mehr stimmt** — nicht aus dem Befund, sondern
aus dem Werkzeug selbst:

```sh
$ git log --oneline -3 -- tools/paket-pruefen.ps1
dfc8b40 Paketpruefer weist Kriterium 0 ohne zweiten Rechner nach (PR-2.0)
a6ccc12 Paketpruefer: Startkette von blossen Nachladefunden trennen; Paketbau-Werkzeug
68e7301 Paketpruefer gebaut, VC71Bruecke in die Solution eingehaengt

$ grep -n 'startkette\|FEHLT BEIM START\|zaehlt nicht\|Lizenzverstoss' tools/paket-pruefen.ps1
437: # DIE STARTKETTE - die transitive Huelle dessen, was der Lader anfassen MUSS,
542:   Write-Host ("   FEHLT BEIM START: {0,-22} gebraucht von {1}" -f $n, $wer)
546:   $zusatz = " (liegt zwar im $wo DIESER Maschine - das zaehlt nicht, …)"
547:   Write-Host ("                     liegt zwar in {0} dieser Maschine - zaehlt nicht." -f $wo)
577:   Write-Host '   Lizenzverstoss - tools\laufzeit-holen.ps1 ist hier NICHT die'
```

Die Fassung im Baum rechnet die Startkette aus den PE-Import- und
Verzögerungstabellen aus, wertet einen Treffer in `SysWOW64`/`System32`
ausdrücklich **nicht** als vorhanden und weist beim Debug-Paket den Weg über
`laufzeit-holen.ps1` selbst ab. Genau die drei Vorwürfe der sechs Dateien.
`Befunde/PAKET.md:106-127` belegt es mit **drei Gegenproben**.

**Dazu ein Widerspruch innerhalb einer Datei:** `CHANGELOG.md:634-636` sagt
schon das Richtige —

> `- `tools/paket-pruefen.ps1` — prüft ein Paket über die PE-Importtabellen gegen`
> `  Kriterium 0 und wertet einen Treffer in `SysWOW64` ausdrücklich **nicht** als`
> `  erfüllt`

— während `README.md:415` das Gegenteil behauptet.

**Vorschlag `README.md:415`:**

```
| `tools/paket-pruefen.ps1` | prüft ein ausgepacktes Paket gegen Kriterium 0: rechnet aus den PE-Import- und Verzögerungstabellen die **Startkette** aus und zählt einen Treffer in `SysWOW64`/`System32` ausdrücklich **nicht** als vorhanden (PR-2.0 behoben am 06.09.2026, drei Gegenproben in `Befunde/PAKET.md`). Es ersetzt keinen Startversuch auf einem fremden Rechner — es sagt, ob der Lader alles findet, was er vor dem ersten Befehl braucht |
```

**Vorschlag `ZIEL.md:91-99`** — der Kasten wird zum Nachtrag:

```
> **`tools/paket-pruefen.ps1` war einmal kein Nachweis, ist es heute aber.** Am
> 31.08.2026 war Kriterium 0 mit diesem Werkzeug als „gemessen erfüllt"
> gemeldet worden; die Gegenprobe hat es widerlegt — aus einer ausgepackten
> Kopie wurden `EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und
> der ganze `Plugins`-Ordner gelöscht, das Ergebnis blieb „keine Fehler,
> EXIT=0". Dazu erzeugte seine feste Debug-Laufzeitliste bei einem
> **Release**-Paket vier Falschwarnungen. **Beides ist seit dem 06.09.2026
> behoben** (PR-2.0, `Befunde/PAKET.md`, drei Gegenproben: echtes Paket grün,
> Paket mit gelöschter `mfc140.dll` rot, Debug-Paket rot). Maßgeblich bleibt
> trotzdem der Lauf am lebenden Objekt — erbracht am 06.09.2026 von Gregor.
```

**Vorschlag für die vier übrigen:** dieselbe Berichtigung einsetzen und in
`AUFGABEN.md` den Abschnitt C1 wie C2 auf **erledigt** umstellen — der Satz
`AUFGABEN.md:191-193` („Das hindert **Kriterium 0** nicht mehr") bleibt, der
Vorwurf davor entfällt.

**Und im Verzeichnis (W-24):** `BEFUNDE.md:135` und `:214` führen PR-2.0
weiter als **offen**.

---

## W-3 (hoch) — `CHANGELOG.md` behauptet, `VERSION` stehe auf 1.0.18

**`CHANGELOG.md:40-45`** — der **erste** Fassungsabschnitt der Datei:

> `## Nach 7.2.0.18 — 07.09.2026 · noch nicht gebaut, noch nicht gepackt`
>
> `Diese Änderungen liegen im Repo, aber in **keinem** Paket. Wer sie sehen will,`
> `muss bauen. `Eudora71/Version.h` und `VERSION` stehen weiter auf 7.2.0.18 /`
> `1.0.18 — wer daraus ein Paket schnürt, setzt beide Nummern vorher hoch, sonst`
> `tragen zwei verschiedene Bauten dieselbe Kennung.`

**Was stattdessen gilt.** `cat VERSION` → `1.0.21`,
`grep EUDORA_BUILD_VERSION Eudora71/Version.h` → `"7.2.0.21"`. Die Datei führt
33 Zeilen weiter den Abschnitt `## 7.2.0.21 / Paket 1.0.21` (`:73`), dazu
7.2.0.20 (`:220`) und 7.2.0.18 (`:297`). Wer die Datei von oben liest — und das
ist ihr Zweck, „Neueste Fassung zuerst" (`:3`) —, hält 1.0.18 für den Stand.

Die drei Punkte darunter (`:47-67`) stecken alle in 1.0.19 bis 1.0.21: E-32
(siehe W-5), `tools/doku-pruefen.pl` und der Doku-Durchgang L-7.

**Vorschlag:** Abschnitt `:40-69` **streichen**, einschließlich des Trenners.
Was daran trägt, steht in den Abschnitten 7.2.0.20 und 7.2.0.21. Falls wieder
ein solcher Abschnitt gebraucht wird, lautet der Kopf:

```
## Nach 7.2.0.21 — noch nicht gebaut, noch nicht gepackt

Diese Änderungen liegen im Repo, aber in **keinem** Paket. `Eudora71/Version.h`
und `VERSION` standen damals auf 7.2.0.21 / 1.0.21 (`cat VERSION`,
`grep EUDORA_BUILD_VERSION Eudora71/Version.h`) — wer daraus ein Paket schnürt,
setzt beide Nummern vorher hoch, sonst tragen zwei Bauten dieselbe Kennung.
```

---

## W-4 (hoch) — `CHANGELOG.md` sagt, Kriterium 5 und 6 seien nicht gemessen

**`CHANGELOG.md:565-574`:**

> `## Wo man weitermachen kann`
>
> `Die offenen Enden mit Fundstelle — für jemanden, der das Repo frisch klont.`
> `**Stand 07.09.2026.**`
>
> `### 1. Ob das Verfassen-Fenster für den Anwender sichtbar wird`
>
> `Daran hängen Kriterium 5 und 6, und es ist **nicht gemessen**. E-31 und E-32`
> `sind behoben, der Fensterbau läuft im Protokoll vollständig durch`
> `(`OnMessageNewMessage: fertig`) — gesehen hat das Fenster niemand.`

**Was stattdessen gilt.** `ZIEL.md:34-35`: Kriterium 5 und 6 sind **erfüllt**,
von Gregor am 07.09.2026 mit Bildschirmfoto bestätigt (*Out* 10:01 Uhr,
*In* 10:02 Uhr). Dieselbe Datei sagt es zweimal selbst — `:28` („**erfüllt** —
von Gregor am 07.09.2026 bestätigt, mit Bildschirmfoto") und `:88-98`
(„### Von Gregor bestätigt: Mail schreiben, senden, empfangen"). Der Abschnitt
trägt denselben Stand („Stand 07.09.2026") wie die Aussage, die er widerlegt.

Dieser Abschnitt ist zugleich der, auf den `CHANGELOG.md:9` und
`WEITERMACHEN.md:16-19` einen Neuankömmling ausdrücklich verweisen.

**Vorschlag `CHANGELOG.md:570-585`:**

```
### 1. Das Verfassen-Fenster ist da — erledigt

Kriterium 5 und 6 sind **erfüllt** (07.09.2026, von Gregor bestätigt, mit
Bildschirmfoto: *Out* 10:01 Uhr, *In* 10:02 Uhr). E-31, E-34, E-35 und E-36 sind
behoben; fünfmal Strg-N ohne Absturz, danach 20 s offen, kein `Exception.log`.
Wer es selbst nachmessen will, ohne danebenzusitzen:

    powershell -ExecutionPolicy Bypass -File tools\strg-n-pruefen.ps1 -Verzeichnis <Paket>

**Der Schlussstein wäre ein Neubau von `Paige32.dll` mit VS2022** — dann kann
keine Kopfdatei mehr von der Binärdatei abweichen, und genau diese Abweichung
war E-31. `Eudora71/PaigeDLL` enthält **doch** Quellen: `PGSOURCE` mit 37
`.C`-Dateien, dazu `PAIGE32/Paige32.vcproj` und die alten Makefiles. Bis zum
06.09.2026 stand hier das Gegenteil, und das hat die Suche nach E-31 unnötig
lange aufgehalten. Der Rekursionszyklus ist dort nachzulesen
(`PGDEFSTL.C:1640`).

**Noch nicht versucht:** Page Heap (`gflags /p /enable Eudora.exe /full`, als
Administrator).
```

---

## W-5 (hoch) — E-32 steht in vier Dateien als „behoben, nur ungeprüft"; die Ursachenbehauptung ist widerlegt

**Was gilt** — `CHANGELOG.md:268-278`, Abschnitt 7.2.0.20:

> `### E-32 — meine Ursachenbehauptung ist widerlegt`
>
> `Der Prüfer hat sie dreifach gemessen und **verworfen**:`
> ``CHeaderView::OnKillFocusRecipient` läuft bei Strg-N überhaupt nicht (eine`
> `Messspur darin liefert null Zeilen …); das Herausnehmen der Behebung bringt`
> `die Meldung nicht zurück; und im ausgelieferten Paket 1.0.18 tritt sie über`
> `denselben Testweg auch nicht auf.`

Gleichlautend `Befunde/PRUEFER-3.md:9`, `:15` und `:126`.
**Vier Stellen sagen etwas anderes:**

| Datei | Zeile | Zitat |
|---|---|---|
| `BEFUNDE.md` | 176 | „E-32 … **behoben, ungeprüft** (07.09.2026, `060a4bf`): `CHeaderView::OnKillFocusRecipient` dereferenzierte `pField` ungeprüft" |
| `WEITERMACHEN.md` | 57 | „**E-32 ist am 07.09.2026 behoben, aber von niemandem nachgemessen.** Das war die modale Meldung …" |
| `CHANGELOG.md` | 47-56 | „**E-32 behoben — die modale Meldung „An unhandled exception has occurred" beim Verfassen.** … **Von Gregor nicht nachgemessen**" |
| `AUFGABEN.md` | 74-75 | „Gemessen, aber von Gregor **noch nicht** nachgesehen: **E-31** und **E-32**." |

`AUFGABEN.md:58-60` sagt es 16 Zeilen darüber richtig — *„Meine
E-32-Ursachenbehauptung ist von PRUEFER widerlegt"* —, `:74-75` widerspricht
dem in derselben Datei. In `BEFUNDE.md` ist „ungeprüft" außerdem definiert
(`:55`): *„behoben, aber am laufenden Programm nicht nachgesehen"* — das sagt
über die Ursache gar nichts und liest sich wie „erledigt, nur nicht besichtigt".

Der Unterschied ist nicht kosmetisch. Wer „behoben, ungeprüft" liest, hält die
modale Meldung für weg. Gemessen ist nur der **Code-Mangel** an `pField` weg;
was die Meldung wirklich war, hat erst **E-34** aufgeklärt.

**Vorschlag `BEFUNDE.md:176`:**

```
| E-32 | die **modale** Meldung „An unhandled exception has occurred" beim Verfassen, nach der sich Eudora nicht mehr beenden ließ | **Ursachenbehauptung widerlegt** (P-3, `Befunde/PRUEFER-3.md`): `CHeaderView::OnKillFocusRecipient` läuft bei Strg-N gar nicht, das Herausnehmen der Behebung bringt die Meldung nicht zurück, und im Paket 1.0.18 tritt sie über denselben Weg nicht auf. Der **Code-Mangel** dort ist echt und behoben (`060a4bf`) — er war nur nie gegen das Symptom geprüft. Aufgeklärt hat die Meldung **E-34** |
```

**Vorschlag `WEITERMACHEN.md:57-66`:**

```
**E-32: der Code-Mangel ist behoben, die Ursachenbehauptung ist widerlegt.**
`CHeaderView::OnKillFocusRecipient` in `Eudora71/Eudora/headervw.cpp`
dereferenzierte `pField` ungeprüft, obwohl die Abfrage drei Zeilen darüber mit
NULL rechnet — das ist behoben (`060a4bf`). Dass **diese** Stelle die modale
Meldung „An unhandled exception has occurred" verursacht hätte, hat PRUEFER
dreifach gemessen und verworfen (`Befunde/PRUEFER-3.md`, Abschnitt 2): die
Funktion läuft bei Strg-N gar nicht, `EN_KILLFOCUS` kann nur ankommen, wenn das
Feld existiert. Aufgeklärt hat die Meldung erst **E-34** — eine MFC-Ausnahme in
`QCChildToolBar::GetButton`, die den ganzen Fensterbau abwickelte
(`CHANGELOG.md` unter 7.2.0.20).
```

**Vorschlag `AUFGABEN.md:74-75`:**

```
2005. **E-31 ist mittelbar bestätigt** — ohne Paige-Fenster gibt es kein
Verfassen-Fenster, und Gregor hat am 07.09.2026 mit 7.2.0.21 eine Mail
geschrieben und abgeschickt. Zu **E-32** siehe oben: Ursachenbehauptung
widerlegt. Einzelheiten in [CHANGELOG.md](CHANGELOG.md).
```

`CHANGELOG.md:47-56` entfällt mit W-3. Die zweite Stelle dort,
`CHANGELOG.md:351-359` („Nachtrag 07.09.2026: E-32 ist behoben … **Von Gregor
nicht nachgemessen.**"), steht im Abschnitt **7.2.0.18** und ist als Nachtrag
zu einem Zeitdokument vertretbar — sie sollte aber auf den Abschnitt 7.2.0.20
verweisen, sonst liest sie sich wie der letzte Stand.

---

## W-6 (mittel) — vier Reste in `Releases/PAKETE.md`

Der Kopfkasten und der Abschnitt 1.0.21 sind seit 10:20 Uhr richtig (W-0).
Vier Stellen sind es nicht.

### W-6a — der `EUDORA_BUILD_NUMBER`-Kasten ist überholt

**`Releases/PAKETE.md:60-69`:**

> `> **`EUDORA_BUILD_NUMBER` ist seit 7.2.0.13 nicht mitgezogen worden** und steht`
> `> am 07.09.2026 auf `7,2,0,12`, während die drei anderen Angaben auf `18``
> `> stehen.`

**Gemessen:**

```sh
$ grep -n 'EUDORA_BUILD' Eudora71/Version.h
12:#define EUDORA_BUILD_NUMBER    7,2,0,21
13:#define EUDORA_BUILD_DESC      "Version 7.2.0.21\0"
14:#define EUDORA_BUILD_VERSION   "7.2.0.21"
```

Alle drei stehen auf 21 — der Mangel ist behoben. Der Kasten sagt in seiner
letzten Zeile selbst, dass `tools/doku-pruefen.pl` den Fall seit dem 07.09.2026
meldet; der Lauf ist grün.

**Vorschlag:**

```
> **`EUDORA_BUILD_NUMBER` hinkte von 7.2.0.13 bis 7.2.0.18 hinterher** und stand
> am 07.09.2026 morgens auf `7,2,0,12`, während die drei anderen Angaben auf
> `18` standen. Kein Werkzeug hatte das gemeldet: `tools/ausliefern.pl --pruefen`
> und `tools/kennung-erzeugen.pl` vergleichen nur `EUDORA_BUILD_VERSION` gegen
> `VERSION`. Folgenlos war es nur, weil das Makro **nirgends benutzt** wird
> (`grep -rn EUDORA_BUILD_NUMBER Eudora71/` — ein Treffer, die Definition
> selbst); wer es je in eine `VERSIONINFO`-Ressource einsetzt, bekommt eine
> `Eudora.exe`, deren Dateiversion nicht zu ihrer Produktversion passt.
> **Seit 7.2.0.21 stimmen alle vier Angaben wieder überein**
> (`grep EUDORA_BUILD Eudora71/Version.h`), und `tools/doku-pruefen.pl` meldet
> den Fall, wenn er wiederkommt.
```

### W-6b — das Beispiel „Wie man die Version hebt" ist drei Nummern alt

**`Releases/PAKETE.md:47-58`:**

> `### Wie man die Version hebt — nachgemessen am 07.09.2026`
>
> `Für die nächste Nummer sind es **fünf Zeilen in zwei Dateien**. Beispiel: von`
> `**1.0.18 / 7.2.0.18** auf **1.0.19 / 7.2.0.19**.`

Das Verfahren stimmt, die Zahlen sind drei Runden alt — derselbe Fall, den
`Befunde/LEKTOR.md:96` schon einmal gemeldet hat (*„Das Verfahren stimmt, die
Zahlen sind sieben Runden alt"*). Er kommt wieder, weil das Beispiel feste
Zahlen nennt.

**Vorschlag:** das Beispiel entzahlen, dann veraltet es nicht mehr:

```
### Wie man die Version hebt — fünf Zeilen in zwei Dateien

Ausgangswert **nicht abschreiben, sondern messen** (`cat VERSION`,
`grep EUDORA_BUILD_VERSION Eudora71/Version.h`). `<alt>` ist die letzte Stelle
von heute, `<neu>` die nächste:

| Datei | Zeile | von | auf |
|---|---|---|---|
| `VERSION` | 1 | `1.0.<alt>` | `1.0.<neu>` |
| `Eudora71/Version.h` | `EUDORA_VERSION4` | `<alt>` | `<neu>` |
| `Eudora71/Version.h` | `EUDORA_BUILD_NUMBER` | `7,2,0,<alt>` | `7,2,0,<neu>` |
| `Eudora71/Version.h` | `EUDORA_BUILD_DESC` | `"Version 7.2.0.<alt>\0"` | `"Version 7.2.0.<neu>\0"` |
| `Eudora71/Version.h` | `EUDORA_BUILD_VERSION` | `"7.2.0.<alt>"` | `"7.2.0.<neu>"` |
```

### W-6c — die Tabelle „Wo die Pakete liegen" kennt 1.0.20 und 1.0.21 nicht

`Releases/PAKETE.md:383-395` führt elf Fassungen, darunter 1.0.4 und 1.0.19
(„nur im git-Verlauf"). **1.0.20 fehlt ganz, und 1.0.21 fehlt, obwohl es im Repo
liegt** — genau die Frage, die die Tabelle beantworten soll.

**Vorschlag:** zwei Zeilen ergänzen (Prüfsumme für 1.0.20 aus dem git-Verlauf
**nachmessen**, nicht schätzen — siehe *Was ich nicht prüfen konnte*, Punkt 2):

```
| `Eudora72-1.0.20-release.zip` | (aus dem git-Verlauf nachmessen) | nur im git-Verlauf, keine Marke |
| `Eudora72-1.0.21-release.zip` | `0a699fcb03c3f0b6…` | **liegt im Repo** · [GitHub v1.0.21](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.21) |
```

### W-6d — eine Restzeile aus der Bearbeitung

`Releases/PAKETE.md:28` ist eine Waise: nach dem Satz *„…, nicht diese Datei."*
steht eine Zeile

```
> offen.
```

Sie ist der Rest des alten Satzes *„… und weiterhin offen."*.
**Vorschlag:** Zeile 28 streichen.

---

## W-7 (hoch) — „Ob das Menü *Window* die Fenster auflistet, ist ungeprüft" — es ist geprüft

**`CHANGELOG.md:16`:**

> `| — | **Kriterium 8**: die offenen Fenster sichtbar und auswählbar | Die Ersatzschicht bildet die Registerkartenleiste nicht nach. Ob das Menü *Window* sie auflistet, ist ungeprüft |`

**`CHANGELOG.md:216-218`:**

> `Menü Window."* Die Ersatzschicht bildet diese Leiste nicht nach. Ob das Menü`
> `*Window* die Fenster wirklich auflistet, ist **ungeprüft** — das ist der erste`
> `Schritt.`

**Was stattdessen gilt.** `ZIEL.md:37`: *„das Menü Window listet sie auf, von
Gregor nachgesehen ("1 In", "2 Out")"*. Dieselbe Datei sagt es zweimal selbst:
`:29` („*halb* — das Menü *Window* listet sie auf") und `:100-101` („Ebenfalls
nachgesehen: das Menü *Window* listet die offenen Fenster auf („1 In",
„2 Out")"). `:100` und `:216` stehen im **selben** Abschnitt (7.2.0.21), 116
Zeilen auseinander.

**Vorschlag `CHANGELOG.md:16`:**

```
| — | **Kriterium 8**: die offenen Fenster sichtbar und auswählbar | *halb* — das Menü *Window* listet sie auf (von Gregor am 07.09.2026 nachgesehen: „1 In", „2 Out"). Was fehlt, ist die **Registerkartenleiste am unteren Fensterrand**: die Ersatzschicht `OTShim` bildet sie nicht nach. Gelesen wird sie in `WazooBar.cpp:572,578` aus `Eudora.ini`, Abschnitt `[WazooBars]` |
```

**Vorschlag `CHANGELOG.md:216-218`:**

```
Menü Window."* Die Ersatzschicht bildet diese Leiste nicht nach. Dass das Menü
*Window* die Fenster auflistet, hat Gregor am 07.09.2026 nachgesehen („1 In",
„2 Out") — damit ist Kriterium 8 zur Hälfte erfüllt, und der erste Schritt ist
die Leiste, nicht das Menü.
```

---

## W-8 (hoch) — E-34, E-35 und E-36 fehlen im Verzeichnis von `BEFUNDE.md`

**Gemessen:**

```sh
$ grep -c 'E-34\|E-35\|E-36' BEFUNDE.md
0
```

Kein einziges Vorkommen in 7373 Zeilen. Die drei Befunde tragen Kriterium 4 in
`ZIEL.md:33`:

> `| 4 | **Keine Abstürze** | **fast** — … Drei Fehler lagen hintereinander: **E-34**, **E-35**, **E-36**. …`

Sie stehen ausführlich in `CHANGELOG.md:142-187` und `:226-259`, in
`AUFGABEN.md:53-56`, in `WEITERMACHEN.md:13` und in `Releases/PAKETE.md:157-161`
— nur nicht dort, wo man einen Befund sucht. Die Datei verlangt es selbst
(`:28`):

> `> **Auflage: wer einen Befund fortschreibt, ändert die Statusspalte hier mit.**`
> `> Ein Verzeichnis, das falsche Stände behauptet, ist schlimmer als keines`

Dieselbe Lücke wurde am 07.09.2026 schon einmal geschlossen (`:36`: *„**E-31**,
**E-32** und **E-33** fehlten ganz und sind eingetragen"*) — drei Kennungen
später ist sie wieder da. Das ist eine **Fehlerklasse**, keine Nachlässigkeit:
Kennungen entstehen im `CHANGELOG`, und niemand trägt sie zurück. Die Schranke
dazu steht in W-21, Vorschlag 4.

**Vorschlag** — drei Zeilen nach `BEFUNDE.md:177`:

```
| E-34 | eine MFC-Ausnahme in `QCChildToolBar::GetButton` wickelte den ganzen Fensterbau ab — ohne Meldung, ohne Absturz, Gregors *„es passiert nichts"* | **behoben** (7.2.0.20): `GetButton` fängt die Ausnahme, protokolliert Index, Größe und Grund und gibt NULL zurück; alle sechs Aufrufstellen prüfen auf NULL. Die **Ursache dahinter ist offen**: `GetBtnCount()` meldet 27, `m_btns[24]` wirft trotzdem — MFC 14 prüft in den Sammlungen mit `ENSURE` statt `ASSERT`, und `ENSURE` wirft auch im Release-Bau. Abgesichert durch `tools/pruefe-fensterbau.pl`; Messwerte in `CHANGELOG.md` unter 7.2.0.20 |
| E-35 | der zweite Strg-N beendete Eudora — `CCompMessageFrame::OnUserUpdateImmediateSend` dereferenzierte das Ergebnis von `GetButton` zweimal blind | **behoben** (7.2.0.21). Folge von E-34: seither gibt `GetButton` auch bei gültigem Index NULL zurück, und `nIndex != -1` schützt nicht mehr. Gefunden von `tools/pruefe-fensterbau.pl` |
| E-36 | dasselbe zweimal in `PgCompMsgView` — ein Zeitgeber im offenen Verfassen-Fenster lief in einen Nullzeiger (`UpdateMoodMailButton`, `OnTimer`); für `ID_MOOD_MAIL` gibt es überdies keinen Befehlsbehandler | **behoben** (7.2.0.21), aufgelöst mit `tools/absturz-auswerten.pl` aus dem eigenen Absturzbericht. Die Lehre steckt in der Schranke: `pruefe-fensterbau.pl` hatte eine feste Dateiliste, `PgCompMsgView.cpp` fehlte darin — sie prüft jetzt alle `Eudora71/Eudora/*.cpp`, 10 Aufrufstellen statt 8 |
```

---

## W-9 (hoch) — E-27 steht im Verzeichnis mit einer widerlegten „besten offenen Spur"

**`BEFUNDE.md:171`:**

> `| E-27 | **Strg-N beendet Eudora lautlos** — ohne Dialog, ohne Protokoll | **Ursache des Schweigens belegt, der Absturz selbst nicht**: … Beste offene Spur: `Paige32.dll`/`EuMemMgr.dll` gegen `MSVCR71` — zwei getrennte Halden (`Befunde/VERFASSER.md`) |`

**Was stattdessen gilt.** Die Ursache ist gefunden und behoben: **E-31**,
`pg_time_t` acht Byte statt vier (`ZIEL.md:33`, `CHANGELOG.md:297-330`,
`WEITERMACHEN.md:39-50`). Strg-N stürzt nicht mehr ab, fünfmal an 7.2.0.21
nachgemessen. Die als „beste offene Spur" empfohlene Richtung ist genau die,
die E-31 abgelöst hat — wer dem Verzeichnis folgt, läuft in eine
Sackgasse, die schon durchsucht ist.

**Vorschlag `BEFUNDE.md:171`:**

```
| E-27 | **Strg-N beendet Eudora lautlos** — ohne Dialog, ohne Protokoll | **Ursache gefunden und behoben: E-31** (`pg_time_t` acht Byte statt vier). Der Absturz war `0xC00000FD` STATUS_STACK_OVERFLOW in `Paige32.dll` (`pgInstallFont`, 525 Windungen tief); ein voller Stapel lässt keinen Platz für den Absturzbehandler, daher kein `Exception.log`. Dieser Befund hat davon die **Ursache des Schweigens** belegt: der Behandler hing nur an `SetUnhandledExceptionFilter`, und Heap-Beschädigung, `/GS`-Wächter, ungültiges Argument an die C-Laufzeit und `std::terminate` gehen daran vorbei — drei davon sind seit 7.2.0.13 angemeldet, dazu 15 Spurmarken auf dem Weg. Die dort genannte „beste offene Spur" (`Paige32`/`EuMemMgr` gegen `MSVCR71`) ist durch E-31 **überholt** (`Befunde/VERFASSER.md`) |
```

---

## W-10 (mittel) — E-16 steht im Verzeichnis als „offen", in drei Dateien als „behoben"

**`BEFUNDE.md:164`:**

> `| E-16 | Absturz beim Verfassen (Strg-N) und „Encountered an improper argument", `afxcoll.inl:213` | **offen** — sechs Stellen in `Befunde/VERFASSEN.md` gehärtet, die Ursache ist damit **nicht** gefunden |`

Dagegen `README.md:81-82`, `CHANGELOG.md:614-615` und `WEITERMACHEN.md:83-84`,
je *„(E-16, behoben)"*. Die Ursache, die E-16 nicht fand, ist inzwischen
**E-34** — `CHANGELOG.md:244-248`:

> `Der Index liegt **innerhalb** der von `GetBtnCount()` gemeldeten Zahl — die`
> `Schranke aus E-16 greift also, und `m_btns[24]` wirft trotzdem.`

Diesen Widerspruch hat PRUEFER am 07.09.2026 schon gemeldet
(`Befunde/PRUEFER-3.md:265-268`: *„E-7, E-11, E-14 und E-16 stehen in
`BEFUNDE.md` gleichzeitig als behoben und als offen"*). Für E-16 steht er noch.

**Vorschlag `BEFUNDE.md:164`:**

```
| E-16 | Absturz beim Verfassen (Strg-N) und „Encountered an improper argument", `afxcoll.inl:213` | **behoben** — sechs Indexstellen gehärtet (`Befunde/VERFASSEN.md`). Die Ursache, die dieser Befund nicht fand, ist **E-34**: die Schranke aus E-16 greift, `m_btns[24]` wirft trotzdem, weil MFC 14 in den Sammlungen mit `ENSURE` statt `ASSERT` prüft. Offen bleibt nur, warum `GetBtnCount()` und das indizierte Feld auseinanderlaufen |
```

---

## W-11 (mittel) — E-22 „offen" und E-28 „behoben" beschreiben dasselbe Symptom

**`BEFUNDE.md:166`:**

> `| E-22 | Doppelklick öffnet keine Nachricht, Suchtreffer lassen sich nicht anklicken | **offen** — `Befunde/FENSTER.md`: Ursache **nicht** gefunden …`

**`BEFUNDE.md:172`:**

> `| E-28 | **Doppelklick öffnet keine Nachricht, Suchtreffer lassen sich nicht anklicken** | **behoben** (`222c0ba`): `CSummary::m_FrameWnd` blieb als Zeiger auf einen zerstörten Rahmen stehen …`

Wortgleiches Symptom, zwei Kennungen, entgegengesetzter Status, sechs Zeilen
auseinander. `ZIEL.md:31` und `AUFGABEN.md:144` führen es als erledigt und von
Gregor bestätigt.

**Vorschlag `BEFUNDE.md:166`:**

```
| E-22 | Doppelklick öffnet keine Nachricht, Suchtreffer lassen sich nicht anklicken | **überholt durch E-28** — dieser Befund fand die Ursache nicht, lieferte aber einen Messwert, der die damalige Suchrichtung widerlegte, und sechs belegte Schwachstellen auf dem Weg (`Befunde/FENSTER.md`). Die Ursache ist `CSummary::m_FrameWnd`, siehe E-28 |
```

---

## W-12 (mittel) — E-31 steht als „ungeprüft", ist aber zweifach bestätigt

**`BEFUNDE.md:175`:**

> `| E-31 | … | **behoben, ungeprüft** — der Abschnitt steht nicht hier, sondern in `CHANGELOG.md` unter 7.2.0.18 (mit allen Feldversätzen) …`

„ungeprüft" heißt in derselben Datei (`:55`) *„behoben, aber am laufenden
Programm nicht nachgesehen"*. Am laufenden Programm ist es nachgesehen: ohne
Paige-Fenster gibt es kein Verfassen-Fenster, und Gregor hat am 07.09.2026 mit
7.2.0.21 eine Mail geschrieben und abgeschickt (`ZIEL.md:34`). Dazu hat PRUEFER
den Feldaufbau gegen `Eudora71/Bin/Release/Paige32.pdb` gemessen —
**755 von 1922** verschobenen Feldern vorher, **0 von 1922** nachher
(`CHANGELOG.md:284-295`). Der Verweis auf „7.2.0.18" nennt diese stärkere
Messung nicht; sie steht unter 7.2.0.20.

**Vorschlag `BEFUNDE.md:175`:**

```
| E-31 | `pg_time_t` war unter VS2022 **acht** Byte breit statt vier — damit war jede Paige-Struktur verschoben, und in dieser Portierung entstand bis dahin nie ein Paige-Fenster | **behoben und bestätigt** — mittelbar durch Gregor (07.09.2026, Mail geschrieben und abgeschickt mit 7.2.0.21) und durch PRUEFER gegen `Eudora71/Bin/Release/Paige32.pdb`: **755 von 1922** verschobenen Feldern vorher, **0 von 1922** nachher, dazu zehn zu große Strukturen (`Befunde/PRUEFER-3.md`). Die Feldversätze stehen in `CHANGELOG.md` unter 7.2.0.18, die Gegenmessung unter 7.2.0.20; dazu ein Kommentar in `Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H` |
```

---

## W-13 (hoch) — `AUFGABEN.md` B1 führt Verfassen und Weiterleiten als offen

**`AUFGABEN.md:144-148`:**

> `Zwei sind behoben und bestätigt: Doppelklick und Suchtreffer öffnen die`
> `Nachricht (**E-28**), gesperrte Knöpfe zeigen ihr Symbol (**E-30**). Was bleibt,`
> `steht oben unter *Die Hauptarbeit* und in [ZIEL.md](ZIEL.md) als Kriterium 4`
> `bis 7 — Verfassen, Weiterleiten, *File → Exit* und die Meldung „Encountered an`
> `improper argument". Das ist der erste Schritt, nicht ein Punkt unter vielen.`

**Was stattdessen gilt.** Kriterium 5 (Verfassen und Abschicken) und 6
(Weiterleiten) sind **erfüllt** — dieselbe Datei sagt es 127 Zeilen darüber in
ihrer eigenen Tabelle (`:18-19`), `ZIEL.md:34-35` ebenso. Der Verweis
„Kriterium 4 bis 7" widerspricht außerdem der eigenen Überschrift `:8`
(*„## Die Hauptarbeit: Kriterium 7 und 8"*) und schweigt über Kriterium 8.

**Vorschlag `AUFGABEN.md:144-148`:**

```
Vier sind behoben und bestätigt: Doppelklick und Suchtreffer öffnen die
Nachricht (**E-28**), gesperrte Knöpfe zeigen ihr Symbol (**E-30**), eine Mail
lässt sich schreiben und abschicken (Kriterium 5) und weiterleiten
(Kriterium 6). Was bleibt, steht oben unter *Die Hauptarbeit*: **Kriterium 7**
(*File → Exit*, Befund E-33) und **Kriterium 8** (die untere Reiterleiste), dazu
die Meldung „Encountered an improper argument". Das ist der erste Schritt, nicht
ein Punkt unter vielen.
```

---

## W-14 (mittel) — `AUFGABEN.md:74-75` gegen `AUFGABEN.md:18-19` und `:58`

Siehe W-5, dritter Vorschlag.

---

## W-15 (hoch) — `WEITERMACHEN.md` „Der nächste Schritt" ist überholt

**`WEITERMACHEN.md:68-74`:**

> `## Der nächste Schritt`
>
> `**Bauen, packen, Gregor geben.** Solange niemand Strg-N auf seinem Rechner`
> `gedrückt hat, ist alles darüber Vermutung: ob das Verfassen-Fenster sichtbar`
> `wird, ob eine Mail zu schreiben ist, ob sich Eudora danach beenden lässt. Der`
> `Weg dafür steht unten unter *Bauen und packen*, das Paket gehört in`
> ``Releases/` und die Nummer in `Eudora71/Version.h` und `VERSION`.`

**Was stattdessen gilt.** Die eigene Kopftabelle sagt 57 Zeilen darüber
(`:12-14`): *„Zuletzt von Gregor gestartet | Paket 1.0.21 am 07.09.2026 — „mail
können jetzt abgeschickt werden." und „weiterleitung funktioniert übrigens.""*
Er hat Strg-N gedrückt, das Fenster ist sichtbar, die Mail ist geschrieben — und
dass sich Eudora **nicht** beenden lässt, ist gemessen, nicht offen
(Kriterium 7, `:34`). Das Paket 1.0.21 liegt in `Releases/` und ist als
`v1.0.21` veröffentlicht.

Diese Datei ist der Einstieg, auf den `AUFGABEN.md:3-4` und `BEFUNDE.md:59`
verweisen. Wer sie liest, bekommt als *nächsten Schritt* eine Aufgabe, die
erledigt ist.

**Vorschlag `WEITERMACHEN.md:68-74`:**

```
## Der nächste Schritt

**Kriterium 7 — das Beenden.** *File → Exit* beendet Eudora nicht (**E-33**),
von Gregor am 07.09.2026 an 7.2.0.21 bestätigt: *„beenden geht nicht."* Das ist
der einzige verbliebene **Fehler**; alles Weitere ist Ausstattung. Der Weg:
`CEudoraApp::OnAppExit` bzw. `CMainFrame::OnClose` in
`Eudora71/Eudora/eudora.cpp` und `MainFrm.cpp`, mit Spurmarken wie bei E-34, und
`eudora.log` bei `LogLevel=32896` gegenlesen. Neu zu messen ist es ohnehin: bis
zur Behebung von E-32 war jede Meldung von der modalen Meldung überdeckt.

**Danach Kriterium 8** — die untere Statuszeile mit Reitern
(`WazooBar.cpp:572,578`, Abschnitt `[WazooBars]` in `Eudora.ini`, Namen in
`EudoraRes.rc:10637-10640`); die Ersatzschicht `OTShim` bildet die Leiste nicht
nach. Dort liegt der Ansatz, nicht in Eudora selbst.
```

---

## W-16 (mittel) — `AUFGABEN.md:304-305` zählt die Lücke in `PAKETE.md` falsch

> `- **`Releases/PAKETE.md` hinkt hinterher** — geführt sind dort 1.0.1, 1.0.2,`
> `  1.0.3 und 1.0.18; **1.0.4 bis 1.0.17 fehlen** (Mangel **M-4**).`

**Gemessen** in `Releases/PAKETE.md`: ausführliche Abschnitte gibt es für
**1.0.21** (`:136`), 1.0.18 (`:170`), 1.0.3, 1.0.2 und 1.0.1 — 1.0.21 fehlt in
der Aufzählung hier. Umgekehrt fehlen **1.0.19 und 1.0.20**, und in der Tabelle
*Wo die Pakete liegen* stehen zusätzlich 1.0.4, 1.0.10, 1.0.14, 1.0.15 und
1.0.19 mit Prüfsumme.

**Vorschlag:**

```
- **`Releases/PAKETE.md` hinkt hinterher** — einen eigenen Abschnitt haben
  1.0.21, 1.0.18, 1.0.3, 1.0.2 und 1.0.1; **1.0.4 bis 1.0.17 sowie 1.0.19 und
  1.0.20 fehlen** (Mangel **M-4**). In der Tabelle *Wo die Pakete liegen* stehen
  1.0.4, 1.0.10, 1.0.14, 1.0.15 und 1.0.19 mit Prüfsumme; 1.0.20 und 1.0.21
  fehlen auch dort. Wer das nächste Paket schnürt, trägt seinen Abschnitt gleich
  mit ein.
```

---

## W-17 (mittel) — `PRUEFUNG-BAU.md:92-94` nennt einen alten Quellstand als heutigen

> `> **Nicht als heutigen Stand lesen.** Der Quellstand ist seit dem 06.09.2026`
> `> **7.2.0.12** (`grep EUDORA_BUILD_VERSION Eudora71/Version.h`). Die Zahlen in`
> `> dieser Tabelle sind der Beleg *jenes* Laufs, kein Sollwert.`

Der Kasten warnt richtig vor der Tabelle darüber (7.2.0.3, Lauf vom 05.09.2026)
— und nennt dann selbst einen überholten Wert als aktuell. Gemessen:
**7.2.0.21**. Der Kasten nennt sogar den Befehl, der ihn widerlegt.

**Vorschlag** — die Zahl durch den Befehl ersetzen, damit sie nicht wieder
veraltet:

```
> **Nicht als heutigen Stand lesen.** Der Quellstand von damals war `7.2.0.3`;
> den heutigen liest man ab, statt ihn hier abzuschreiben:
> `grep EUDORA_BUILD_VERSION Eudora71/Version.h` (am 07.09.2026: `7.2.0.21`).
> Die Zahlen in dieser Tabelle sind der Beleg *jenes* Laufs, kein Sollwert.
```

---

## W-18 (mittel) — die drei Prüfstandsmarken sind 36 Commits alt

Gemessen mit dem Werkzeug, das genau dafür gebaut wurde:

```
$ perl tools/pruefstand-melden.pl
Stand HEAD: 4f27a38
  BEFUNDE.md         abgeglichen bis 060a4bf, seither 36 Commit(s)  <== faellig
  README.md          abgeglichen bis 060a4bf, seither 36 Commit(s)  <== faellig
  PORTIERUNG.md      abgeglichen bis 060a4bf, seither 36 Commit(s)  <== faellig
```

`060a4bf` ist der Commit *„E-32 behoben"*; in den 36 Commits danach liegen
7.2.0.19, 7.2.0.20 und 7.2.0.21. Alle drei Dateien sind seither mehrfach
geändert worden, ohne die Marke mitzuziehen — obwohl der Kommentar direkt
darunter das verlangt (`README.md:4-6`, `BEFUNDE.md:4-6`, `PORTIERUNG.md:4-6`):
*„Wer die Datei nachzieht, zieht die Marke mit."*

**Vorschlag:** in allen drei Dateien auf `<!-- pruefstand: <HEAD> -->` setzen —
aber **erst**, wenn die Fundstellen dieses Berichts eingearbeitet sind. Sonst
behauptet die Marke einen Abgleich, den es nicht gab, und das ist schlimmer als
eine alte Marke.

---

## W-19 (mittel) — `README.md:54` ist eine Dublette von `:49`

```
49  Was offen ist, steht vollständig in [CHANGELOG.md](CHANGELOG.md); was als
50  Nächstes zu tun ist, in [AUFGABEN.md](AUFGABEN.md). **Die Prüfanleitung zum
51  jeweils aktuellen Paket** steht im CHANGELOG beim zugehörigen Eintrag, nicht
52  hier.
53
54  Was offen ist, steht vollständig in [CHANGELOG.md](CHANGELOG.md).
```

**Vorschlag:** Zeile 53 und 54 streichen.

---

## W-20 (mittel) — der Kopf von `LEKTORAT.md` gilt nur für den ersten von sieben Durchgängen

`LEKTORAT.md:1-8`:

> `Durchgang vom 30.08.2026 durch den Agenten LEKTOR, Branch`
> ``worktree-agent-a3a787cbbe74cbbe2`, gemessener Ausgangsstand `371c1e3`.`
> …
> `Der Durchgang wurde vorzeitig abgebrochen (VM wird`
> `abgeschaltet), ist also **unvollständig** — was noch aussteht, steht unten.`

**Gemessen:** die Datei enthält **sieben** Durchgänge
(`grep -n '^# ' LEKTORAT.md` → Zeilen 1, 121, 229, 368, 429, 493), der jüngste
vom 07.09.2026. Wer die ersten acht Zeilen liest, hält die ganze Datei für einen
abgebrochenen Bericht vom 30.08.

Dazu eine Lücke in der Zählung: nach *Vierter Durchgang* (`:368`) folgt
*Sechster Durchgang* (`:429`), ohne Hinweis. Der fünfte ist
`Befunde/LEKTOR.md` — dort `:103`: *„**Ein fünfter Durchgang fehlt** — dieser
hier"*.

**Vorschlag** — `LEKTORAT.md:1-8` ersetzen:

```
# Lektorat der Dokumentation

**Diese Datei ist ein Fahrtenbuch, kein Statusbericht.** Sie sammelt die
Durchgänge des Agenten LEKTOR in zeitlicher Folge — jeder Abschnitt gilt für
seinen Tag, nicht für heute. Was **jetzt** gilt, steht in [ZIEL.md](ZIEL.md),
[README.md](README.md) und [CHANGELOG.md](CHANGELOG.md).

Hier stehen der erste bis vierte, der sechste und der siebte Durchgang. Der
**fünfte** steht nicht hier, sondern in [Befunde/LEKTOR.md](Befunde/LEKTOR.md);
die späteren in [Befunde/LEKTOR-2.md](Befunde/LEKTOR-2.md) (L-6),
[Befunde/LEKTOR-3.md](Befunde/LEKTOR-3.md) (L-7) und
[Befunde/LEKTOR-4.md](Befunde/LEKTOR-4.md) (L-8).

## Erster Durchgang — 30.08.2026

Branch `worktree-agent-a3a787cbbe74cbbe2`, gemessener Ausgangsstand `371c1e3`.
Anlass: Gregors Frage „die ganzen MD sind up to date?". **Antwort: nein, mehrere
waren deutlich veraltet.** Der Durchgang wurde vorzeitig abgebrochen (VM wird
abgeschaltet), ist also **unvollständig** — was noch aussteht, steht unten.
```

---

## W-21 (mittel) — die Schranke deckt 18 von 47 MD ab und findet keinen dieser Widersprüche

```
$ perl tools/doku-pruefen.pl
  Quellstand                   7.2.0.21
  Paketnummer                  1.0.21
  Kriterien in ZIEL.md         9
  gepruefte Dateien            18
  Kennungen im Verzeichnis     32
  Abschnitte in BEFUNDE.md     13
  Kein Widerspruch gefunden.
```

Die Ausnahmeregel steht in `tools/doku-pruefen.pl:99`:

```perl
my $zeitdokument = qr{^(?:Befunde/|Pruefung/|Releases/1\.0/|BEFUNDE\.md$|LEKTORAT\.md$|PRUEFUNG-|ABRUF-PRUEFEN\.md$|Releases/PAKETE\.md$)};
```

Damit sind **29 von 47** Dateien ausgenommen — darunter `BEFUNDE.md` (W-5, W-8
bis W-12, W-24, W-25), `Releases/PAKETE.md` (W-6) und `PRUEFUNG-BAU.md` (W-17).
Die verbleibenden 18 werden auf Kriterienzahl, Befundstatus und Verweise
geprüft, nicht auf **Selbstwidersprüche** (W-3, W-4, W-7, W-13, W-15) und nicht
gegen die Wirklichkeit außerhalb der `.md` (W-0, W-2, W-6a).

Das ist kein Vorwurf an das Werkzeug — es hat die Fälle abgestellt, für die es
gebaut wurde. Es ist die Antwort auf die Frage, warum 29 Befunde in einem Baum
stehen, über den eine Schranke grün läuft.

**Vorschlag** — vier Prüfungen, jede mit einer Gegenprobe, die rot wird, **und**
einer, die grün bleibt (Auflage 10 in `AUFGABEN.md`):

1. **Marken prüfen.** Jede Adresse `releases/tag/vX.Y.Z` in einer `.md` gegen
   `git ls-remote --tags origin`, mit `git tag` als Rückfall ohne Netz. Fängt
   die Klasse aus W-0: eine Veröffentlichung ankündigen, bevor sie existiert.
2. **ZIP-Aussagen prüfen.** Jede Aufzählung, die mit ``ls Releases/*.zip``
   begründet ist, gegen das Verzeichnis. Fängt W-0 und W-6c.
3. **`Version.h` gegen jede Datei, die eine Nummer als *heutigen* Stand nennt** —
   auch in den Zeitdokumenten, aber nur dort, wo „Stand", „ist seit", „steht
   auf" oder „stehen weiter auf" davorsteht. Fängt W-3, W-6a und W-17.
4. **Kennungen quer, in beide Richtungen.** Jede `E-nn`/`PR-n`/`X-n`, die in
   irgendeiner `.md` als „behoben" auftaucht, muss im Verzeichnis von
   `BEFUNDE.md` stehen und darf dort nicht „offen" heißen — und jede Kennung mit
   einem eigenen Abschnitt im `CHANGELOG` muss im Verzeichnis vorkommen. Fängt
   W-8, W-10, W-11 und W-24. Das ist die Prüfung, die PRUEFER am 07.09.2026
   schon gefordert hat (`Befunde/PRUEFER-3.md:266-268`).

Für 3 und 4 muss die Zeitdokument-Ausnahme fallen — sonst bleibt `BEFUNDE.md`,
die Datei mit den meisten Fundstellen dieses Durchgangs, ungeprüft.

---

## W-22 (mittel) — 16 von 47 MD kommen in `LEKTORAT.md` nie vor

Gemessen (Basisname jeder Datei gegen `LEKTORAT.md` gesucht):

```
AGENTEN.md                Befunde/PERSONA.md          Befunde/SYMBOLE-VORARBEIT.md
Befunde/ASSISTENT.md      Befunde/PORT.md             Befunde/SYMBOLE.md
Befunde/FENSTER.md        Befunde/POSTFACH.md         Befunde/VERFASSEN.md
Befunde/OEFFNEN.md        Befunde/PRUEFER-3.md        Befunde/VERFASSER.md
Befunde/PAIGE.md          Befunde/SPUR.md             Pruefung/PRUEFUNG-PAKET.md
Befunde/PAKET.md
```

**In diesen 16 Dateien selbst habe ich fast keinen Widerspruch gefunden** — sie
sind sauber. Die Lücke ist im Verfahren, und sie erklärt drei der schwersten
Befunde oben: `Befunde/PAKET.md` (PR-2.0 behoben → W-2),
`Befunde/VERFASSER.md` (E-27 → W-9) und `Befunde/FENSTER.md` (E-22 → W-11) sind
in keinem Lektorat aufgeschlagen worden, und genau ihre Ergebnisse fehlen in den
Dateien, die sagen, was jetzt gilt. `Befunde/PAKET.md:193-209` hat die
Fundstellen sogar aufgeschrieben, damit sie niemand suchen muss.

**Vorschlag** — `AGENTEN.md`, Abschnitt *Die Reihenfolge einer Runde*, Punkt 7:

```
7. **LEKTOR allein** über die Dokumentation laufen lassen — und zwar über
   **jede** Datei aus `git ls-files '*.md'` ohne `Arbeitsweise/`, nicht nur über
   die, die im Auftrag stehen. Die Befunddateien der Runde sind Pflicht: was ein
   Agent als behoben meldet, muss in `BEFUNDE.md`, `ZIEL.md` und `README.md`
   ankommen, sonst arbeitet der nächste Agent gegen einen Stand, den es nicht
   mehr gibt. Am 07.09.2026 waren 16 von 47 MD in keinem Lektorat je erwähnt,
   und drei davon trugen Ergebnisse, die anderswo noch als offen standen —
   eines seit fünf Tagen, mit einer Liste der Fundstellen dabei (L-8, W-2).
```

---

## W-23 (gering) — die Werkzeugtabelle in `README.md` kennt sieben Werkzeuge nicht

Gemessen: von den Dateien in `tools/` fehlen in `README.md:388-419`

```
tools/arbeitsbaum-frei.pl     tools/pruefe-fensterbau.pl    tools/zeiger-nachpruefen.pl
tools/befehl-schicken.ps1     tools/strg-n-pruefen.ps1      tools/zeiger-nachpruefen-tests.pl
tools/befunde-einsammeln.pl
```

Die ersten vier sind nicht harmlos: `pruefe-fensterbau.pl` ist die Schranke, mit
der E-35 und E-36 gefunden wurden (`CHANGELOG.md:162`, `:189-205`);
`strg-n-pruefen.ps1` ist das Werkzeug, auf das `CHANGELOG.md:581` verweist, um
Kriterium 5 ohne Zuschauer zu messen; `arbeitsbaum-frei.pl` und
`befunde-einsammeln.pl` sind das Verfahren aus `AGENTEN.md:37`, `:97-98`, `:118`.

**Vorschlag** — vier Zeilen in `README.md:388-419`:

```
| `tools/pruefe-fensterbau.pl` | `pre-commit`-Schranke für den Fensterbau: keine modale Meldung in `Eudora71/OTShim/*.cpp` (E-33), `GetButton` hat Indexschranke **und** Ausnahmefang (E-34), jeder `GetButton`-Aufruf prüft sein Ergebnis auf NULL. Prüft alle `Eudora71/Eudora/*.cpp` — eine feste Dateiliste hatte genau die Lücke, in der E-36 lag. **Wer sie anfasst, lässt die drei Gegenproben laufen** |
| `tools/strg-n-pruefen.ps1` | startet Eudora, klickt Meldungen weg, schickt Strg-N und sagt, ob das Verfassen-Fenster aufgeht. **Öffnet ein Fenster** — nicht ohne Absprache laufen lassen (Auflage 1) |
| `tools/arbeitsbaum-frei.pl` | bucht einen Arbeitsbaum auf einen Agenten (`--neu`, `--freigeben`) und nennt namentlich, welche unverfolgten Dateien ein Branchwechsel vernichten würde. Verfahren in [AGENTEN.md](AGENTEN.md) |
| `tools/befunde-einsammeln.pl` | führt die Befunddateien aus `Befunde/` in `BEFUNDE.md` zusammen (`--anhaengen`) und nennt die nächste freie Kennung (`--naechste E`) |
```

Die drei übrigen (`befehl-schicken.ps1`, `zeiger-nachpruefen.pl` samt
Testsammlung) sind Hilfsmittel und können ungenannt bleiben — dann aber bewusst,
mit einem Satz am Ende der Tabelle, sonst fällt es beim nächsten Zählen wieder
auf.

---

## W-24 (gering) — `BEFUNDE.md:135` und `:214` führen PR-2.0 als offen

Siehe W-2. **Vorschlag `BEFUNDE.md:135`:**

```
| PR-2 | Nachprüfung des 31.08.: neun Punkte | **Bericht**; **PR-2.0** und PR-2.1 behoben (PR-2.0 am 06.09.2026, `Befunde/PAKET.md`, drei Gegenproben), PR-2.8 kein Handlungsbedarf, **PR-2.2 bis PR-2.7 offen** |
```

`:214` entsprechend: *„PR-2.0 und PR-2.1 **behoben**, PR-2.8 kein
Handlungsbedarf, Rest **offen**"*.

---

## W-25 (gering) — `BEFUNDE.md:145` sagt, keines der beiden 1.0.3-ZIPs sei gestartet worden

> `| V-1 | zwei verschiedene ZIPs unter derselben Versionsnummer `v1.0.3`; **keine der beiden ist gestartet worden** | **offen** — Regel festgehalten, das nächste Paket heißt 1.0.4 |`

`Releases/PAKETE.md:249-251` nennt genau diesen Satz *„längst überholt — seither
sind 1.0.4 bis 1.0.10 gebaut und benutzt worden"*, und `:241` hält fest, dass
Gregor die erste Fassung gestartet hat (Absturz im Kontoassistenten, E-6). Der
Zusatz „das nächste Paket heißt 1.0.4" ist siebzehn Nummern alt.

**Vorschlag:**

```
| V-1 | zwei verschiedene ZIPs unter derselben Versionsnummer `v1.0.3` | **offen** — die Regel steht („ein veröffentlichtes Paket wird nicht ersetzt, es bekommt die nächste Nummer"), die Prüfsummen unterscheiden die beiden (`Releases/PAKETE.md`). Der Zusatz „keine der beiden ist gestartet worden" ist überholt: Gregor hat die erste Fassung gestartet (E-6). Eine **Schranke** zu der Regel gibt es nicht |
```

---

## W-26 (gering) — fünf Verweise in `Releases/1.0/README.md` führen ins Leere

Die Ziele tragen eine Zeilennummer im Pfad und lösen deshalb nicht auf:

| Zeile | Verweisziel |
|---|---|
| 47 | `../../Eudora71/QCSSL/src/QCSSLContext.cpp:53` |
| 49 | `../../Eudora71/QCSSL/src/certstore.cpp:82` |
| 50 | `../../Eudora71/QCSSL/src/certstore.cpp:273` |
| 51 | `../../Eudora71/QCSSL/src/QCSSLContext.cpp:486` |
| 101 | `../../Eudora71/QCSSL/src/certstore.cpp:125` |

Die Dateien selbst sind da (`ls Eudora71/QCSSL/src/QCSSLContext.cpp
Eudora71/QCSSL/src/certstore.cpp`). **Vorschlag:** die Zeilennummer aus dem Ziel
in den Verweistext holen —
`[QCSSLContext.cpp:53](../../Eudora71/QCSSL/src/QCSSLContext.cpp)`.

---

## W-27 (gering) — zwei genannte Dateien gibt es nicht mehr

| Datei | genannt in |
|---|---|
| `tools/rekursion-suchen.pl` | `BEFUNDE.md:213`, `:2673`, `:3530`, `:3933`, `:4129` |
| `Releases/1.0.2/LIESMICH.txt` | `BEFUNDE.md:4843`; `LEKTORAT.md:34`, `:43`, `:92`, `:144`, `:216` |

Beide sind Zeitdokumente, die Nennung ist historisch richtig, und
`Releases/PAKETE.md:397` sagt ausdrücklich, dass `Releases/1.0.2/` entfernt
wurde. **Vorschlag:** nur bei `BEFUNDE.md:213`, wo das Werkzeug als Messbefehl
zum Nachvollziehen steht, den Halbsatz *„— liegt nicht mehr im Baum"* anfügen.

---

## W-28 (gering) — zwei Befunddateien haben keinen Nachtrag zur später gefundenen Ursache

`Befunde/VERFASSER.md:16`: *„**Nicht gefunden** — Die eine Zeile im
Verfassen-Weg, die den Speicher beschädigt. Ich habe sie nicht."*
`Befunde/FENSTER.md:12`: *„**Ursache gefunden: nein.**"*

Für ihren Tag ist beides richtig. Wer nur eine dieser Dateien öffnet — und
`BEFUNDE.md:171` bzw. `:166` verweisen genau dorthin —, erfährt nicht, dass die
Ursache inzwischen E-31 bzw. E-28 heißt.

**Vorschlag** — je ein Kasten unter die Kopfzeile, nach dem Muster, das
`Eudora71/OTShim/BEFUND-ANSICHT.md:6-10` schon benutzt. Für
`Befunde/VERFASSER.md`:

```
> **Nachtrag 07.09.2026: die Ursache ist gefunden.** Es war **E-31** —
> `pg_time_t` war unter VS2022 acht Byte breit statt vier, damit war jede
> Struktur verschoben, die Eudora an Paige reichte (`CHANGELOG.md` unter
> 7.2.0.18, Gegenmessung gegen `Paige32.pdb` unter 7.2.0.20). Was unten steht,
> bleibt richtig und wichtig: es erklärt, **warum** der Absturz lautlos war. Die
> dort als „beste offene Spur" genannte Richtung (`Paige32`/`EuMemMgr` gegen
> `MSVCR71`) ist damit überholt.
```

Für `Befunde/FENSTER.md` entsprechend mit **E-28** (`CSummary::m_FrameWnd`).

---

## W-29 (gering) — `CHANGELOG.md:35-36` zitiert Gregor gekürzt

> `> Sein Maßstab von 1.0.18 gilt weiter: *„es crasht nicht, aber es passiert auch`
> `> nichts. nichts statt crash ist auch keine verbesserung!"*`

`ZIEL.md:43-44` und `Releases/PAKETE.md:174-176` haben den vollen Satz: *„es
crasht nicht, aber es passiert auch nichts. **beenden kann ich es auch nicht.**
nichts statt crash ist auch keine verbesserung!"* Weggefallen ist ausgerechnet
der Halbsatz, aus dem Kriterium 7 entstanden ist.

**Vorschlag:** den fehlenden Satz einsetzen.

---

## W-31 (mittel) — `PORTIERUNG.md` sagt nicht, für wen sie ist

Gregors Frage dazu lautete wörtlich *„ist es intern für dich? oder für einen
agenten?"*.

**Gemessen:** `PORTIERUNG.md:1-16` nennt Stand, Zweig, welche Abschnitte
nachgemessen sind und die Auflage, Zahlen nachzumessen — aber keinen Adressaten
und keinen Zweck. Aus dem Inhalt (269 Compilerfehler, sieben wiederkehrende
Muster, Fundstellen mit Bezugscommit) ist die Antwort: für **jemanden, der am
Quelltext arbeitet**, Agent oder Mensch, und als **Begründungsarchiv**. Nur
steht es nirgends, und `README.md:437` verweist mit *„Ausführlich mit
Begründungen"* darauf, was sie wie eine Fortsetzung der README aussehen lässt —
also wie eine Datei, die sagt, was jetzt gilt. Genau das ist sie nicht: `:11-12`
sagt, ältere Messwerte nennen ihren eigenen Bezugscommit, „meist `a807b93` vom
31.08.2026".

Der einzige Adressatenhinweis, den sie hat, zeigt in die andere Richtung
(`:14-15`): *„An diesem Baum arbeiten mehrere Agenten gleichzeitig. Jede Zahl
hier nennt ihren Bezugscommit; wer sie weiterverwendet, misst nach."*

**Vorschlag** — zwei Sätze nach `PORTIERUNG.md:6`, vor der Stand-Zeile:

```
> **Für wen diese Datei ist.** Für jeden, der am **Quelltext** arbeitet — Agent
> oder Mensch —, und zwar als Begründungsarchiv: sie sagt, *warum* eine Änderung
> so aussieht, wie sie aussieht, mit Fundstelle und Bezugscommit. Sie ist **kein
> Statusbericht**. Was jetzt gilt, steht in [ZIEL.md](ZIEL.md) (der Maßstab),
> [README.md](README.md) (Bauen und Starten) und [CHANGELOG.md](CHANGELOG.md)
> (was in welchem Paket steckt); wo man weitermacht, in
> [WEITERMACHEN.md](WEITERMACHEN.md). Ältere Abschnitte hier gelten für ihren
> Bezugscommit, nicht für heute.
```

Dasselbe fehlt, schwächer, bei `Befunde/PAIGE.md` — die einzige Befunddatei
ohne Agent, Datum und Status im Kopf. **Vorschlag** dort, nach Zeile 4:

```
**Agent:** PAIGE · **Zweig:** `wt/paige` · **Datum:** 06.09.2026 ·
**Fassung:** 7.2.0.18 · **Status:** Ursache belegt und behoben, von PRUEFER
gegengemessen (`Befunde/PRUEFER-3.md`)
```

Datum und Zweig vor dem Einsetzen aus `git log --format='%ad %s' --date=short --
Befunde/PAIGE.md` nachmessen — ich habe sie nicht belegt.

---

## Was ich nicht prüfen konnte

1. **Ob hinter der Marke `v1.0.21` auch eine GitHub-*Veröffentlichung* mit
   angehängtem ZIP liegt.** Gemessen habe ich nur die Marke: `git ls-remote
   --tags origin` nennt `refs/tags/v1.0.21` → `253f81a`, entpackt `6ff03e7`. Ob
   dort ein Release-Eintrag mit Datei hängt, sieht man nur über die
   GitHub-Schnittstelle; ins Netz habe ich nicht gesehen. **Vermutung:** ja, weil
   die Marke frisch gesetzt wurde und `Releases/PAKETE.md:136` „veröffentlicht am
   07.09.2026" sagt. **Nicht belegt.**
2. **Die Prüfsumme von `Eudora72-1.0.20-release.zip`.** Für W-6c fehlt sie. Sie
   steckt im git-Verlauf; sie herauszuholen heißt, ein 9-MB-Blob aus einem alten
   Commit zu holen — das habe ich als Nur-Lesen-Auftrag nicht getan. **Bitte
   nachmessen, nicht schätzen.** Ebenso, ob es 1.0.20 überhaupt als ZIP gab oder
   nur als Bau.
3. **Die 121 Zertifizierungsstellen in `Releases/1.0/README.md:12`.** Die
   Größenangabe stimmt (`stat -c%s Releases/1.0/rootcerts.p7b` = 129 194 Byte,
   also 126 KiB); die Anzahl der Zertifikate in der Datei habe ich nicht
   ausgezählt, dafür müsste man das p7b aufmachen. **Nicht geprüft** — weder
   bestätigt noch widerlegt. Kein Widerspruch zu `README.md:379-381`, das sich
   absichtlich auf keine Zahl festlegt: dort ist das erzeugende Skript
   beschrieben, hier ein ausgelieferter Stand.
4. **`BEFUNDE.md` Abschnitt für Abschnitt.** 7373 Zeilen. Vollständig geprüft
   habe ich das **Verzeichnis** (`:120-214`) gegen `ZIEL.md`, `CHANGELOG.md` und
   die Befunddateien, dazu die Kopfzahlen und jede Fundstelle, die eine
   Versionsnummer, ein ZIP oder eine Marke nennt. Die Kopfzahlen stimmen alle
   drei: `wc -l` = **7373**, `grep -c '^## '` = **122**,
   `grep -cE '^### +[A-Z]'` = **200**. Die 122 Befundabschnitte selbst sind
   Zeitdokumente und habe ich nur überflogen.
5. **Ob die Zeilenangaben in den Quelltext stimmen**, die die MD nennen (etwa
   `WazooBar.cpp:572,578`, `debug.cpp:140`, `headervw.cpp:2590`,
   `CPUDEFS.H:695`). Das ist ein Durchgang gegen den Code, kein Doku-Abgleich —
   und `AUFGABEN.md` Auflage 5 sagt zu Recht, dass solche Angaben veralten.
   **Nicht geprüft.** Was ich am Code geprüft habe, ist genannt: `Version.h`,
   `tools/paket-pruefen.ps1`, `tools/doku-pruefen.pl:99`.
6. **Der Baum unter mir.** Sieben Dateien sind während des Durchgangs geändert
   worden (Zeitstempel 10:14 bis 10:33 Uhr), HEAD ist von `41ad5df` auf
   `4f27a38` gewandert, und die Marke `v1.0.21` ist um 10:34 entstanden. Meine
   Zitate sind um **10:36 Uhr** gegengelesen; vier Fundstellen sind in dieser
   Zeit behoben worden und stehen als **W-0**. Es kann weitere geben, die
   danach entstanden oder verschwunden sind. **Jede Zeilennummer vor dem
   Einsetzen nachprüfen.**
7. **Zeilenenden.** Der Auftrag sagte CRLF *„wie die anderen MDs"*. **Gemessen
   ist das nicht so:** von 47 MD haben **46 reines LF**, nur
   `Pruefung/PRUEFUNG-ZEIGER.md` hat CRLF (193 LF, 193 CR). Alle 16 Dateien in
   `Befunde/` haben LF. Diese Datei ist deshalb mit **LF** geschrieben, nicht mit
   CRLF — Messung unten. Wenn CRLF gewünscht ist, ist es eine Umstellung des
   ganzen Verzeichnisses, kein Sonderfall für diese Datei.
8. **`NUL` im Arbeitsbaum.** `git status` meldet eine unverfolgte Datei namens
   `NUL` im Wurzelverzeichnis. Sie gehört nicht zur Dokumentation, ich habe sie
   nicht angefasst und weiß nicht, woher sie kommt. **Hinweis, kein Befund.**

### Messung dieser Datei

```
Bytes          59821
LF gesamt      1188   (= Zeilenzahl)
CR gesamt      0
einsame CR     0
UTF-8          gueltig, kein BOM, keine Doppelkodierung
```

Gegenprobe: `perl tools/pruefe-bytes.pl` läuft ohne Meldung, und
`Befunde/LEKTOR-3.md` als Nachbardatei zeigt dasselbe Bild (356 LF, 0 CR).
