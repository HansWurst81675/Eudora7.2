# <a id="lektor-107"></a>LEKTOR-107 — Bestätigung nach 21a629f6

**Datum:** 31.10.2026 · **Geprüft:** Commit `21a629f6` auf `wt/lektor-20261031b` (abgezweigt von `e140-speichern-zeichensatz`), im Arbeitsbaum `.wt/lektor`

**Auftrag.** Kurzer Bestätigungslauf, kein Vollbestand: die sechs Funde aus
[LEKTOR-106](LEKTOR-106.md#lektor-106) nachsehen, dann was seit `13405aac`
hinzukam gegen den Bestand lesen — [E-171](../Intern/BEFUNDE.md#e-171)
(*Search Mailfolder* ohne markierten Text brachte eine Fehlermeldung; jetzt
im Quellstand behoben), [E-138](../Intern/BEFUNDE.md#e-138) (`Eudora.exe`
startet nach dem Herunterladen nicht; von Gregor als „erledigt durch Doku“
entschieden), der neue [E-177](../Intern/BEFUNDE.md#e-177) (die
Filteraktion „an Programm übergeben“ schreibt ohne Zeichensatzangabe) und
[E-165](../Intern/BEFUNDE.md#e-165) (die Vervollständigungsbox im `To:`-Feld
sieht verbaut aus; im Quellstand behoben, offen bis Gregors Blick). **Alle
Zeilenangaben gelten für `21a629f6`.** Nichts gebaut, nichts gestartet.
**In diesem Bericht steht nichts aus Gregors Rechner oder Postfach.**

**Ergebnis vorweg.** Von den sechs Funden aus
[LEKTOR-106](LEKTOR-106.md#lektor-106) sind fünf erledigt und einer
teilweise (ein Absatz zu [E-139](../Intern/BEFUNDE.md#e-139) beschreibt den
alten Weg weiter im Präsens). [E-171](../Intern/BEFUNDE.md#e-171),
[E-138](../Intern/BEFUNDE.md#e-138) und [E-177](../Intern/BEFUNDE.md#e-177)
kommen in BEFUNDE, README, CHANGELOG, WEITERMACHEN, TESTPLAN und WERKZEUGE
einheitlich an. **Zwei neue Funde, beide klein.** Der wichtigere: Die aus
BEFUNDE erzeugte Liste führt [E-165](../Intern/BEFUNDE.md#e-165) als „nie
gemessen“, obwohl das Urteil eine Messung am laufenden Programm nennt — es
fehlt die maschinenlesbare Marke ([L-107.1](#l-107.1)). Zweitens hat das
Urteil zu [E-171](../Intern/BEFUNDE.md#e-171) einen stehengebliebenen Satz
„nicht nachgesehen“, und das CHANGELOG schreibt dem Prüfstandsfall
`E-171p` auch die Gegenmessung an 7.2.1.128 zu, die der Fall nicht fährt
([L-107.2](#l-107.2)).

## Funde aus LEKTOR-106

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-106.1](LEKTOR-106.md#l-106.1) | Prüfstandsfall `E-139p` (abschaltbarer Rechtschreibhinweis) nie gelaufen, CHANGELOG und TESTPLAN sagten „gefahren“ | **erledigt** | `Intern/pruefstand-buch.tsv:33` *„E-139p ok 2026-10-31 20:27:13 C:\Temp\E139“*; `CHANGELOG.md:109` *„(zwei Läufe mit `tools/messen-e139.ps1`; der Prüfstandsfall `E-139p` prüft Lauf 1 und lief am 31.10.2026 grün)“*; `Intern/TESTPLAN.md:143-147` *„(zwei Läufe mit `tools/messen-e139.ps1` …) … Der Prüfstandsfall `E-139p` prüft Lauf 1.“* (gemessen) |
| [L-106.2](LEKTOR-106.md#l-106.2) | CHANGELOG nannte [E-144](../Intern/BEFUNDE.md#e-144) (Antwortentwurf verliert den Gesprächsfaden) „gemessen (Prüfstandsfall `E-144p`)“ | **erledigt** | `CHANGELOG.md:117` *„**am Programm gemessen** (`tools/messen-e144.ps1`) … Der Prüfstandsfall `E-144p` ist bisher nur einmal aufgezeichnet, und zwar rot.“* — deckt sich mit `Intern/BEFUNDE.md:402`. `E-144p` hat weiter keine Zeile im Buch, `pruefstand-buch.tsv:26` führt weiter *„E-125c FEHL 2026-10-30 14:18:03“* (gemessen); das sagen jetzt beide Dokumente, kein Widerspruch mehr |
| [L-106.3](LEKTOR-106.md#l-106.3) | Zwei README-Zeilen gaben zu falschen Zeichen in gespeicherten Dateien entgegengesetzten Rat | **erledigt** | `README.md:161` ([E-101](../Intern/BEFUNDE.md#e-101)) jetzt *„aus der Postfachliste speichern (Nachricht markieren, *File → Save As*) — dieser Weg ergänzt seit 7.2.0.120 die Zeichensatzangabe; aus dem geöffneten Nachrichten- oder Verfassen-Fenster siehe [E-140](../Intern/BEFUNDE.md#e-140)“* (gemessen); derselbe Rat wie `:190` |
| [L-106.4](LEKTOR-106.md#l-106.4) | Rest aus [E-140](../Intern/BEFUNDE.md#e-140) (Filteraktion „an Programm übergeben“) stand in keiner Liste | **erledigt** | eigener Befund [E-177](../Intern/BEFUNDE.md#e-177): `Intern/BEFUNDE.md:383` *„**offen, am Quelltext belegt, nie gemessen.** Abgetrennt aus [E-140](../Intern/BEFUNDE.md#e-140) auf [LEKTOR-106](LEKTOR-106.md#lektor-106) [L-106.4](LEKTOR-106.md#l-106.4)“*; `Intern/WEITERMACHEN.md:77` und der erzeugte Block `CHANGELOG.md:30` führen ihn (gemessen) |
| [L-106.5](LEKTOR-106.md#l-106.5) | ZIEL.md ohne „im Quellstand behoben“ bei [E-139](../Intern/BEFUNDE.md#e-139) und [E-140](../Intern/BEFUNDE.md#e-140) | **erledigt** | `ZIEL.md:89` *„[E-139](../Intern/BEFUNDE.md#e-139) (seit 31.10.2026 im Quellstand behoben)“*, *„[E-140](../Intern/BEFUNDE.md#e-140) (seit 31.10.2026 im Quellstand behoben)“* (gemessen) |
| [L-106.6](LEKTOR-106.md#l-106.6) | Drei kleine Reste: Testzahl bei [E-144](../Intern/BEFUNDE.md#e-144), Kommentar im Präsens bei [E-139](../Intern/BEFUNDE.md#e-139), Verweis in Entscheidung 7 | **teilweise** | Testzahl: `Intern/BEFUNDE.md:402` *„341 Tests, 341 bestanden“*. Entscheidung 7: `Intern/WEITERMACHEN.md:136` *„[E-140](../Intern/BEFUNDE.md#e-140) (seit 31.10.2026 im Quellstand behoben) … [E-145](../Intern/BEFUNDE.md#e-145) (seit 30.10.2026 im Quellstand behoben)“*. Kommentar: `Intern/BEFUNDE.md:404` jetzt *„der Kommentar in `spell.cpp:65-66` nannte (Stand vor der Behebung)“* (alles gemessen). **Rest:** derselbe Absatz unter *„**Die Stelle — berichtigt am 23.10.2026**“* sagt weiter *„gezeigt mit `AfxMessageBox(..., MB_OK mit MB_ICONINFORMATION)` aus der Funktion `ZeigeHinweisEinmal()` (`:58`)“* — der Weg vor der Behebung, im Präsens. Als Vorgeschichte erkennbar, weil die Statusspalte vorn den neuen Weg nennt (*„`ZeigeHinweisEinmal` … zeigt die Meldung jetzt über `NoteDialog(…)`“*); kein neuer Fund |

## Neue Funde

### <a id="l-107.1"></a>L-107.1 — E-165 steht in der erzeugten Liste als „nie gemessen“, obwohl das Urteil eine Messung am laufenden Programm nennt

**Gewicht: Liste und Urteil sagen über eine Messung Verschiedenes.** `Intern/WEITERMACHEN.md:83` und `CHANGELOG.md:36` gegen `Intern/BEFUNDE.md:382`; Ursache `tools/offene-befunde.pl:220-237`, `:333-335`

Worum es geht: Für die Vervollständigungsbox im `To:`-Feld, die mit wenigen
Treffern verbaut aussieht, liegt die Behebung im Quellstand und ist am
Programm gemessen — nur nicht an Gregors Fall mit einem einzigen Treffer.
Die aus BEFUNDE erzeugte Aufgabenliste sagt trotzdem, es sei nie gemessen
worden.

> `Intern/BEFUNDE.md:382`: *„**offen — Behebung im Quellstand, am
> 31.10.2026 mit zwei Treffern am laufenden Programm gemessen; Gregors Fall
> (ein Treffer, seine Bildschirmskalierung) noch nicht nachgestellt; in
> keinem Paket.** **Messung vorher** (`tools/messen-e135.ps1` … Bau
> `7c13c368`, Code wie 7.2.1.128)“*
>
> `Intern/WEITERMACHEN.md:83` (ebenso `CHANGELOG.md:36`): *„[E-165](../Intern/BEFUNDE.md#e-165) | Die
> Vervollständigungsbox im To:-Feld … | **nie gemessen** | Gregors Blick am
> nächsten Paket …“*

**Gemessen:** Die Urteilszeile `:382` enthält keine Marke
*„**Zuletzt gemessen: <Datum> an <Fassung>**“* (`grep -o "Zuletzt"` auf
die Zeile ohne Treffer). `offene-befunde.pl` setzt in genau diesem Fall
*„**nie gemessen**“* (`:333-335`); die Warnung für kaputte Marken
(`:235-237`) greift nur, wenn der Markenanfang dasteht. Die Messung ist
also da, für das Werkzeug aber unsichtbar — das Muster, vor dem der
Kommentar in `:220-233` warnt. Der Befund ist **nicht** neu seit
`13405aac` (`git diff 13405aac..HEAD -- Intern/BEFUNDE.md` ändert `:382`
nicht), stand aber im Auftrag.

**Vorschlag:** In `:382` die Marke ergänzen, z. B. *„**Zuletzt gemessen:
31.10.2026 an 7.2.1.128**“* (gemessen wurde der Bau `efcd5945` auf
Quellstand 7.2.1.128 — welche Fassung dort hingehört, entscheidet der
Hauptagent nach dem Muster der übrigen Zeilen), dann die erzeugten Blöcke
neu schreiben lassen. *„NIE gemessen 12“* sinkt dann auf 11.

### <a id="l-107.2"></a>L-107.2 — E-171: ein stehengebliebenes „nicht nachgesehen“ im Urteil; das CHANGELOG schreibt dem Prüfstandsfall auch die Gegenmessung zu

**Gewicht: Kleinkram, je ein Satz.** `Intern/BEFUNDE.md:387`; `CHANGELOG.md:110`

Worum es geht: Die Suche aus dem Rechtsklickmenü ohne markierten Text ist
behoben und gemessen. Zwei Sätze drumherum passen nicht ganz zum Rest.

* **Im Urteil selbst.** Vorn: *„Damit sind alle Aufrufer zugleich
  abgedeckt (Trident- und Paige-Ansicht, alle drei Menüpunkte)“* und
  *„die anderen beiden Menüpunkte und die Paige-Ansicht laufen über
  dieselbe Funktion (belegt am Quelltext)“*. Weiter hinten, aus der Zeit
  vor der Behebung: *„und für Nur-Text-Mails (`PaigeEdtView.cpp:8710ff`,
  nicht nachgesehen)“* (`Intern/BEFUNDE.md:387`, gemessen). Am Quelltext
  stimmt die vordere Aussage: `PaigeEdtView.cpp:8746`
  *„OpenFindMessagesWindow(szMailboxName, szText, true, in_bSelectParent,
  in_bSelectAll, true);“*, und die Behebung steht in
  `OpenFindMessagesWindow` selbst (Diff von `e327d7ec` an `guiutils.cpp`:
  *„if ( bStartSearch && ( !szSearchPhrase || !*szSearchPhrase ) )“*)
  (**belegt**). Nur das „nicht nachgesehen“ ist überholt.
* **Im CHANGELOG.** `CHANGELOG.md:110`: *„**am Programm gemessen**
  (Prüfstandsfall `E-171p`): 7.2.1.128 mit Meldung, der neue Bau ohne.“*
  Der Fall fährt nur den neuen Bau: `tools/pruefstand-faelle.txt:292`
  *„E-171p | C:\Temp\E171 | 60 | messung | E171 ERGEBNIS fehlermeldung=0
  suchfenster=1 lebt=1“*, `Intern/pruefstand-buch.tsv:39` *„E-171p ok
  2026-10-31 20:27:59 C:\Temp\E171 Eudora 7.2.1.128+e327d7ec“*. Die Seite
  „7.2.1.128 mit Meldung“ stammt aus `messen-e171.ps1` in
  `C:\Temp\E171-alt` (`tools/TESTLAEUFE.md:623`, 20:23:46); das Urteil
  `:387` sagt es richtig: *„7.2.1.128 (`C:\Temp\E171-alt`)
  `fehlermeldung=1 suchfenster=1`“* (gemessen). Dieselbe Art Verkürzung
  wie in [L-106.1](LEKTOR-106.md#l-106.1), nur harmlos, weil beide Läufe
  aufgezeichnet sind.

**Vorschlag:** in `:387` „nicht nachgesehen“ durch „seit der Behebung über
`OpenFindMessagesWindow` mit abgedeckt, `:8746`“ ersetzen; in
`CHANGELOG.md:110` „(Prüfstandsfall `E-171p`)“ durch
„(`tools/messen-e171.ps1` an beiden Fassungen; Prüfstandsfall `E-171p`
für den neuen Bau grün)“.

## Bestand ohne Fund

* **[E-171](../Intern/BEFUNDE.md#e-171) kommt einheitlich an** (gemessen):
  `Intern/BEFUNDE.md:387` *„**behoben im Quellstand, am 31.10.2026 am
  laufenden Programm gemessen; in keinem Paket.**“*; `README.md:167`
  *„im Quelltext behoben, kommt mit dem nächsten Paket“*;
  `CHANGELOG.md:110` unter dem Quellstand, *„348 Tests, 348 bestanden“* —
  passt zum Testbau beim Push des Gerüsts (*„Alle 348 Tests bestanden.“*);
  `Intern/TESTPLAN.md:183-196` ([e-171-naechstes](../Intern/TESTPLAN.md#e-171-naechstes))
  *„Noch kein Paket — erst ausführen, wenn das nächste Paket da ist.
  Lokales Postfach *In* (nicht IMAP).“* und *„Am Prüfstand am 31.10.2026
  Schritt 1–3 so gefahren (Fall `E-171p`)“* — die Gegenprobe in Schritt 4
  (Wort markiert, Suche startet sofort) ist damit ehrlich als nicht
  gefahren ausgewiesen; `tools/WERKZEUGE.md:143` (`messen-e171.ps1`); aus
  der offenen Liste in `Intern/WEITERMACHEN.md` gestrichen (Diff
  `13405aac..HEAD`). `CHANGELOG.md:152` nennt ihn weiter unter *„Neu
  bekannt, behandelt nach dem Release“* — das ist der Abschnitt zu
  7.2.1.128 und dort richtig.
* **[E-138](../Intern/BEFUNDE.md#e-138) „erledigt durch Doku“** (gemessen):
  `Intern/BEFUNDE.md:405` *„**erledigt durch die Doku — Gregor am
  31.10.2026: *„ja, erledigt durch doku - reicht zu e-138“*.**“* und *„der
  Hinweis in `README.md` … bleibt stehen“*; `README.md:158` führt die Zeile
  unter „Bekannte Fehler“ weiter mit dem Rat *„ZIP vor dem Auspacken
  entsperren“* — passt; aus der offenen Liste in WEITERMACHEN gestrichen;
  Entscheidung 14 (`Intern/WEITERMACHEN.md:143`) *„gegen die
  Download-Sperre ([E-138](../Intern/BEFUNDE.md#e-138)) der Hinweis in der README“* — kein Widerspruch.
  `git grep` nach [E-138](../Intern/BEFUNDE.md#e-138) zusammen mit „offen“ oder „nie gemessen“ außerhalb
  von `Befunde/` und `Arbeitsweise/`: kein Treffer.
* **[E-177](../Intern/BEFUNDE.md#e-177)** steht in BEFUNDE (`:383`), in
  WEITERMACHEN (`:77`) und im erzeugten Block des CHANGELOG (`:30`) gleich
  als *„nie gemessen“* — hier richtig, es gibt keine Messung. In der README
  steht er nicht; das Urteil sagt *„Es geht nichts verloren … Gregor muss
  nichts tun.“* — kein Fund.
* **[E-165](../Intern/BEFUNDE.md#e-165)** bleibt überall offen:
  `Intern/BEFUNDE.md:382` *„**offen —**“*, `CHANGELOG.md:111` *„(noch offen
  bis zu Gregors Blick)“* und *„347 Tests, 347 bestanden“*,
  TESTPLAN-Abschnitt [e-165-naechstes](../Intern/TESTPLAN.md#e-165-naechstes)
  (`:167`). Nur die Einstufung „nie gemessen“ stimmt nicht
  ([L-107.1](#l-107.1)).
* **Standzeilen 31.10.2026:** `Intern/WEITERMACHEN.md:3` *„**Stand
  31.10.2026.**“*, `Intern/TESTPLAN.md:1` *„Stand 31.10.2026“*,
  `Intern/AUFGABEN.md` *„**Stand 31.10.2026: nur noch zum Nachschlagen.**“*
  (gemessen); `pruefe-stand-md` beim Push des Gerüsts: *„Kein Stand-Kopf
  hinkt hinterher.“*
* **Zahlen:** `offene-befunde.pl` 42 (vorher 43) — [E-171](../Intern/BEFUNDE.md#e-171)
  und [E-138](../Intern/BEFUNDE.md#e-138) heraus, [E-177](../Intern/BEFUNDE.md#e-177)
  hinzu; *„NIE gemessen 12“* unverändert, weil [E-138](../Intern/BEFUNDE.md#e-138)
  (vorher „nie gemessen“, Diff von `Intern/WEITERMACHEN.md`) heraus- und
  [E-177](../Intern/BEFUNDE.md#e-177) (nie gemessen) hineinging (gemessen;
  Rechnung belegt am Diff).

## Mechanisch (zitiert, gemessen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | *„Quellstand 7.2.1.128 … gepruefte Dateien 50 … Kennungen im Verzeichnis 164 … Kein Widerspruch gefunden.“*; 15 „Zur Kenntnis“-Zeilen, dieselben Archiv-, Hintergrund- und Testdatendateien wie in [LEKTOR-106](LEKTOR-106.md#lektor-106) |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 42 / davon aktuell gemessen 4 / davon nur am Quelltext 0 / davon veraltet gemessen 26 / davon NIE gemessen 12 / in Intern/WEITERMACHEN.md 42 — 42 offene Befunde, in beiden Listen gleich.“* [E-165](../Intern/BEFUNDE.md#e-165) ist einer der 12 ([L-107.1](#l-107.1)) |

## Nicht geprüft

* Kein Vollbestand. Gelesen: der Diff `13405aac..HEAD` (alle 22 Dateien
  nach `--stat`, inhaltlich BEFUNDE, WEITERMACHEN, AUFGABEN, `guiutils.cpp`),
  die Urteile zu [E-138](../Intern/BEFUNDE.md#e-138),
  [E-139](../Intern/BEFUNDE.md#e-139) (Ausschnitte),
  [E-144](../Intern/BEFUNDE.md#e-144) (Ausschnitt),
  [E-165](../Intern/BEFUNDE.md#e-165) (Statusspalte),
  [E-171](../Intern/BEFUNDE.md#e-171), [E-177](../Intern/BEFUNDE.md#e-177)
  (Anfang); `CHANGELOG.md:30-36`, `:109-117`, `:145-152`,
  `README.md:158-167`, `TESTPLAN.md:143-147`, `:167`, `:183-196`,
  `ZIEL.md:89`, `WERKZEUGE.md:143`, `WEITERMACHEN.md:3`, `:77`, `:83`,
  `:136`, `:143`.
* Ob `TestE171.cpp` prüft, was sein Name sagt: Sache des PRÜFERS.
* `Releases/DEFENDER-FEHLALARM.md`, `Releases/PAKETE.md`,
  `Befunde/PRUEFER-67.md` und die neue Gedächtnisdatei
  `Arbeitsweise/entscheidung-e138-erledigt-durch-doku.md` nur im
  `--stat` gesehen, nicht gelesen.
* Nichts am laufenden Programm, kein Prüfstand.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Soll der veröffentlichte Text von `v7.2.1.128` einen Satz zu den
  fehlenden Regressionstests bekommen?** Offen seit
  [LEKTOR-103](LEKTOR-103.md#lektor-103); unverändert.
* **Wann kommt das nächste Paket?** Im Quellstand warten jetzt zusätzlich
  die Suche ohne markierten Text ([E-171](../Intern/BEFUNDE.md#e-171)) und
  die Vervollständigungsbox ([E-165](../Intern/BEFUNDE.md#e-165)), deren
  Abschluss ausdrücklich an Gregors Blick auf seinem Bildschirm hängt.
  Unverändert gegenüber [LEKTOR-106](LEKTOR-106.md#gregor), nur länger.
