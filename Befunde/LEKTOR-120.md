# <a id="lektor-120"></a>LEKTOR-120 — Bestand vor dem PR, Zweig e184_mehrere_mails nach 2fd14adc (01.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-119](LEKTOR-119.md#lektor-119).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261101j`, Stand `2fd14adc`.

## Kurz

Die acht Funde aus [LEKTOR-119](LEKTOR-119.md#lektor-119) sind erledigt; nur die README-Zahl der
Prüfberichte ist wieder veraltet ([L-120.6](#l-120.6)). Die neue Buchführung des Zweigs
stimmt in der Sache mit Code, Commit und Prüfstandsbuch: [E-184](../Intern/BEFUNDE.md#e-184) (beim Verschieben mehrerer Mails
im IMAP-Konto bekamen die Einträge im Ziel die Daten einer anderen Mail), Rest K3 behoben und
gemessen, der Befund bleibt bis zum Paket offen; [E-172](../Intern/BEFUNDE.md#e-172) (Base64-Block im Lesefenster) erledigt,
kein Programmfehler. **Im Eintrag [E-172](../Intern/BEFUNDE.md#e-172) stehen keine Namen, Mailadressen, Betreffzeilen oder
Anhangnamen aus Gregors Post** (gemessen, siehe unten). Alle vier Werkzeuge sind grün, 45 Befunde offen.

Acht Funde, keiner am Programm, **alle berichtigt im selben Commit**. Der wichtigste: Der
WEITERMACHEN-Kopf sagte im ersten Satz „Rest von [E-184](../Intern/BEFUNDE.md#e-184) berichtigt“ und weiter hinten noch
„mehrere Mails … bekommen die neuen Nummern weiter über Kreuz“ ([L-120.2](#l-120.2)). Dazu, auf
Auftrag: Gregors Bestätigung von [E-139](../Intern/BEFUNDE.md#e-139) (Rechtschreibhinweis lässt sich dauerhaft abschalten) an
7.2.1.130 in BEFUNDE, TESTPLAN und WEITERMACHEN ([L-120.1](#l-120.1)). Und der Kopf von
`messen-e184m.ps1` gab die Serverantwort in einer Form an, die der Prüfserver nicht sendet
([L-120.5](#l-120.5)).

## Funde aus LEKTOR-119

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-119.1](LEKTOR-119.md#l-119.1) Zeilen der zwei anderen Aufrufer bei [E-184](../Intern/BEFUNDE.md#e-184) | erledigt (Funktionsnamen mit Stand) | `Intern/BEFUNDE.md:401` *„`CTocDoc::ImapDoPostExpunge` und `CTocDoc::ImapChangeMsgsJunkStatus` … Stand `878f38e9` Zeilen `:2801`, `:3107`“*; heute `ImapToc.cpp:2828`, `:3134`. Durch den Stand gekennzeichnet, kein Fund |
| [L-119.2](LEKTOR-119.md#l-119.2) WEITERMACHEN-Kopf ohne [E-189](../Intern/BEFUNDE.md#e-189)/[E-188](../Intern/BEFUNDE.md#e-188) | erledigt, **jetzt widersprüchlich** | siehe [L-120.2](#l-120.2) |
| [L-119.3](LEKTOR-119.md#l-119.3) README-Zahl der Prüfberichte | **wieder veraltet** | siehe [L-120.6](#l-120.6) |
| [L-119.4](LEKTOR-119.md#l-119.4) Kopf `messen-e189.ps1` | erledigt | `tools/messen-e189.ps1:8` *„# GEMESSEN am 01.11.2026: rot an 7.2.1.130 …“* |
| [L-119.5](LEKTOR-119.md#l-119.5) WERKZEUGE, roter Wert am falschen Bau | erledigt | `tools/WERKZEUGE.md:140` |
| [L-119.6](LEKTOR-119.md#l-119.6) CHANGELOG-Werkzeugzeile | erledigt | `CHANGELOG.md:124` *„`tools/messen-e184.ps1` und die Hülle `tools/messen-e189.ps1`“* |
| [L-119.7](LEKTOR-119.md#l-119.7) toter Verweis `(#e-184)` | erledigt | `grep -c '](#e-'` → 0 in `CHANGELOG.md` und `Intern/WEITERMACHEN.md` |
| [L-119.8](LEKTOR-119.md#l-119.8) [E-189](../Intern/BEFUNDE.md#e-189) „Kurz“ ohne Kennzeichnung | erledigt | `Intern/BEFUNDE.md:399` *„räumt die Kopie vermutlich nicht weg (am Quelltext …)“* |

## Was seit 246be2e6 dazukam

Gelesen: `git log --stat 246be2e6..HEAD`, neun Commits, davon drei Merges (#197, PRÜFER-77,
CHRONIST). Inhaltlich: `21bc5272` (ZWEIGE), `8c620666` (`auftrag-rolle.pl`), `c4e883a9` (Haken
gegen direkte `Eudora.exe`-Aufrufe), `2fd14adc` (K3, [E-172](../Intern/BEFUNDE.md#e-172), Prüfserver). Alle geänderten Zeilen
außerhalb von `Eudora71/` und `Arbeitsweise/` gelesen; vom Quelltext nur die genannten Stellen.

| Angabe | Stelle | Ergebnis |
|---|---|---|
| K3: Quellmenge aus `COPYUID` bis `ImapTransferSummaryData` | `Intern/BEFUNDE.md:401` *„`StoreUIDPLUSResponses` … `Imapdll/src/UidMenge.h`“* | stimmt: `proto.cpp:37` *„#include "UidMenge.h"“*, `:2122` Signatur mit `dwaQuellUIDs`, `:2161-2162` zwei Aufrufe `E184UidMengeLesen`; `ImapToc.cpp:1573` *„pSumNew = NULL;“*, `:1617` *„bFoundNew = false;“* je Durchlauf (gemessen) |
| Regressionstest `TestE184.cpp`, 357/357 | Commit `2fd14adc`; `CHANGELOG.md:109` | `Tests.vcxproj:155`, `TestMain.cpp` ruft `RunE184Tests` (gemessen am Diff). Die Zahl 357 nicht nachgezählt (nichts bauen) |
| Prüfstand rot/grün | `Intern/BEFUNDE.md:401`, `tools/pruefstand-faelle.txt` (Block `E-184m`) | `Intern/pruefstand-buch.tsv`: *„E-184m ok 2026-11-01 19:32:26 … 7.2.1.130+c4e883a9* … richtig=3 falsch=0 eintraege=3“*, [`E-184`](../Intern/BEFUNDE.md#e-184) und [`E-189`](../Intern/BEFUNDE.md#e-189) grün am selben Bau; `tools/TESTLAEUFE.md` vier Starts mit `6e9a43ba*` (19:16–19:21), passt zu „rot ohne K3“ (gemessen) |
| Prüfserver `COPY` in UID-Folge | `tools/WERKZEUGE.md:182` | stimmt: `tools/imap-pruefserver.pl:520-532` sortiert nach UID, `:537` *„OK [COPYUID 1 %s %s]“* mit `join(',', …)` (gemessen); siehe [L-120.5](#l-120.5) |
| Haken `haken-eudora-start.pl`, 23 Fälle | `tools/WERKZEUGE.md:167` | `perl tools/haken-eudora-start.pl --selbsttest` → *„Ergebnis: 23 Faelle, 23 bestanden, 0 fehlgeschlagen“*; eingetragen in `.claude/settings.json:27` (gemessen) |
| [E-172](../Intern/BEFUNDE.md#e-172) erledigt, Stufentabelle | `Intern/BEFUNDE.md:158-162` | kritisch offen 10 → 9, unkritisch erledigt 32 → 33; `offene-befunde.pl` 46 → 45 (gemessen) |
| README ohne E-172-Zeile | `README.md` „Bekannte Fehler“ (`:149ff`) | stimmt; `README.en.md` hatte nie eine (`git show 246be2e6:README.en.md`, 0 Treffer) |
| [E-172](../Intern/BEFUNDE.md#e-172): keine Namen oder Adressen | `Intern/BEFUNDE.md:407`, `CHANGELOG.md:112`, Diff `246be2e6..HEAD` ohne `Eudora71/` | keine Mailadresse in einer hinzugefügten Zeile (`grep -E '…@…\.[a-z]{2,}'` → 0); [E-172](../Intern/BEFUNDE.md#e-172) nennt nur den Anbieter GMX, die Kopfzeilennamen, Daten und Fassungen, keinen Betreff, keinen Absender, keinen Anhang (gemessen). Die Adressen im übrigen Bestand sind Platzhalter (`*.invalid`, `example.*`) oder stammen aus dem Original von QUALCOMM und OpenSSL |

## Funde

### <a id="l-120.1"></a>L-120.1 — E-139: Bestätigung an 7.2.1.130 fehlte

**Gewicht: Kleinkram, Auftrag des Hauptagenten.** (belegt am Wortlaut, den der Hauptagent übergeben hat)

**Berichtigt im selben Commit:**
- `Intern/BEFUNDE.md:425` nach der Bestätigung vom 31.10.: *„**Am 01.11.2026 abends von Gregor an 7.2.1.130 erneut bestätigt:** „[E-139](../Intern/BEFUNDE.md#e-139) kommt in 1.130 nicht mehr vor.““*
- `Intern/TESTPLAN.md:151` neuer Absatz unter dem Ergebnis vom 31.10.: *„**Bestätigt am 01.11.2026 abends, Gregor an 7.2.1.130:** …“*
- `Intern/WEITERMACHEN.md:3`: *„Testpaket 7.2.1.130 bei Gregor im Test (…; [E-139](../Intern/BEFUNDE.md#e-139) dort von Gregor erneut bestätigt)“*.

### <a id="l-120.2"></a>L-120.2 — WEITERMACHEN-Kopf widerspricht sich bei E-184

**Gewicht: mittel.** Der Kopf ist der Einstieg nach einem Neustart. (gemessen)

`Intern/WEITERMACHEN.md:3` sagte vorn *„Zweig `e184_mehrere_mails`: Rest von [E-184](../Intern/BEFUNDE.md#e-184) (mehrere Mails)
im Quelltext berichtigt und gemessen“* und weiter hinten, aus [L-119.2](LEKTOR-119.md#l-119.2) stehen geblieben:
*„die Behebung von [E-184](../Intern/BEFUNDE.md#e-184) (nur teilweise — mehrere Mails in nicht aufsteigender Reihenfolge bekommen
die neuen Nummern weiter über Kreuz)“*.

**Berichtigt im selben Commit:** hinten jetzt *„(damals nur teilweise; der Rest für mehrere Mails steht
seit dem Zweig `e184_mehrere_mails` im Quelltext, siehe oben)“*.

Zur Kenntnis, nicht berichtigt: Der Kopf nennt 7.2.1.130 zweimal (vorn „bei Gregor im Test“, hinten
„geschnürt … darin …“). Das ist doppelt, aber nicht falsch.

### <a id="l-120.3"></a>L-120.3 — E-184: jüngster grüner Bau fehlte, K4 stand unter „Vorher stand hier“

**Gewicht: Kleinkram.** (gemessen)

`Intern/BEFUNDE.md:401` nannte als letzten Bau *„zuletzt Bau `8c904144*` mit der Behebung von
[E-189](../Intern/BEFUNDE.md#e-189)“*, obwohl [`E-184`](../Intern/BEFUNDE.md#e-184) und `E-184m` am Bau `c4e883a9*` grün im Prüfstandsbuch stehen
(19:29:15, 19:32:26). **Berichtigt:** *„…, zuletzt Bau `c4e883a9*` mit der Behebung von K3: Fälle
[`E-184`](../Intern/BEFUNDE.md#e-184) und `E-184m` grün, `Intern/pruefstand-buch.tsv`“*.

Der Satz zu K4 (Merkzeichen nur im Speicher, eine nachgeholte Warteschlange nach einem Neustart
legt eine zweite Zusammenfassung an) stand hinter **„Vorher stand hier:“**, sah also erledigt aus.
Laut „Was noch fehlt“ (*„K4 (Warteschlange nach Neustart, klein)“*) ist er offen. **Berichtigt:**
*„**Weiter offen (K4):** das Merkzeichen lebt nur im Speicher …“*.

### <a id="l-120.4"></a>L-120.4 — E-172: zwei Rückblicke auf Fassungen, die nie eingecheckt waren

**Gewicht: Kleinkram.** (gemessen)

`Intern/BEFUNDE.md:407` sagte *„Die Vermutung „`Autocrypt:`“ aus der ersten Fassung dieses Eintrags
war falsch“* und *„(Vorher stand hier: selbst am Prüfstand nachstellen; …)“*. Keine eingecheckte
Fassung von [E-172](../Intern/BEFUNDE.md#e-172) enthielt eines davon: `git log -S'Autocrypt' -- Intern/BEFUNDE.md` findet nur
`2fd14adc` selbst und den alten Commit `c28cde84` (Liste der `TabooHeaders`); vor `2fd14adc` stand
unter „Was noch fehlt“ *„erst nach dem Release 7.2.1 — Quelltext der Mail ansehen (View Source) …“*.

**Berichtigt im selben Commit:** *„Die Vermutung „`Autocrypt:`“ (vor diesem Eintrag geäußert, nie
eingetragen) war falsch“* und *„(Vorher stand hier: erst nach dem Release 7.2.1 den Quelltext der
Mail ansehen und die Dekodierstelle suchen; …)“*.

### <a id="l-120.5"></a>L-120.5 — Kopf von `messen-e184m.ps1`: falsche Form der Serverantwort, kein Messergebnis

**Gewicht: Kleinkram.** Dieselbe Art Fund wie [L-118.5](LEKTOR-118.md#l-118.5) und [L-119.4](LEKTOR-119.md#l-119.4). (gemessen)

`tools/messen-e184m.ps1:7` sagte *„"[COPYUID 1 1:3 1:3]"“*. Der Prüfserver schreibt Listen
(`imap-pruefserver.pl:537`, `join(',', @alt), join(',', @neu)`), und `tools/pruefstand-faelle.txt`
sagt richtig *„[COPYUID 1 1,2,3 1,2,3]“*. Der Unterschied ist nicht nebensächlich: Der Commit
begründet den neuen Mengenleser gerade damit, dass `UIDStringToUIDs` keine Listen verstand.

**Berichtigt im selben Commit** (reines ASCII, nachher `>127 0`, `nur-LF 26`, vorher 24):
`:7` *„"[COPYUID 1 1,2,3 1,2,3]"“*, `:11-12` *„# GEMESSEN am 01.11.2026: rot am Bau 6e9a43ba
([E-184](../Intern/BEFUNDE.md#e-184)/[E-189](../Intern/BEFUNDE.md#e-189) behoben, K3 nicht: richtig=2 falsch=1), gruen mit der Behebung (Bau c4e883a9*).“*

### <a id="l-120.6"></a>L-120.6 — README: Zahl der Prüfberichte zum vierten Mal veraltet

**Gewicht: Kleinkram.** (gemessen)

`README.md:98` *„191 LEKTOR- und PRÜFER-Berichte“*; am Stand `2fd14adc` sind es 118 + 75 = 193
(`git ls-files Befunde | grep -cE '/LEKTOR-[0-9]+\.md$'` bzw. `PRUEFER`), mit diesem Bericht 194.
**Berichtigt im selben Commit:** 194. Die 124 Lehren stimmen: seit `246be2e6` kam unter
`Arbeitsweise/` nur `CHRONIST-2026-11-01d.md` dazu, ein Laufbericht. **Vorschlag** (zum vierten
Mal, [L-117.5](LEKTOR-117.md#l-117.5)/[L-118.9](LEKTOR-118.md#l-118.9)/[L-119.3](LEKTOR-119.md#l-119.3)): die Zahl streichen oder erzeugen.

### <a id="l-120.7"></a>L-120.7 — CHANGELOG: E-172 zweimal verlinkt

**Gewicht: Kleinkram.** (gemessen)

`CHANGELOG.md:112` *„**[E-172](…) aufgeklärt, kein Programmfehler** ([E-172](…)): …“*. **Berichtigt im
selben Commit:** der zweite Verweis ist weg.

### <a id="l-120.8"></a>L-120.8 — ZWEIGE: Plan nennt E-188, der Zweig hat es nicht angefasst

**Gewicht: Kleinkram, vor dem PR.** (gemessen)

`tools/ZWEIGE.md:205` nennt als Inhalt *„[E-188](../Intern/BEFUNDE.md#e-188) nachstellen und beheben“* (zwischen zwei IMAP-Konten oder
nach lokal kann eine fremde Zusammenfassung überschrieben werden). Der Eintrag [E-188](../Intern/BEFUNDE.md#e-188) ist seit
`246be2e6` unverändert (Diff von `Intern/BEFUNDE.md` nur in den Zeilen 158–162, 401, 407).
**Berichtigt im selben Commit:** angehängt *„Stand `2fd14adc`: K3 behoben und gemessen, [E-172](../Intern/BEFUNDE.md#e-172)
aufgeklärt (kein Programmfehler); [E-188](../Intern/BEFUNDE.md#e-188) in diesem Zweig noch nicht angefasst.“* Wer den PR so
merged, sollte [E-188](../Intern/BEFUNDE.md#e-188) nicht für erledigt halten.

## Nachtrag: zweiter Commit, Auftrag des Hauptagenten

Der Hauptagent hat Gregors `eudora.log` vom 01.11.2026 ausgewertet (sein Rechner außerhalb der VM, Lauf gegen das Mailverzeichnis von 7.2.1.129) und mir die Messung übergeben; das Protokoll selbst habe ich nicht gelesen (belegt am übergebenen Wortlaut). Eingetragen:

- [E-171](../Intern/BEFUNDE.md#e-171) („Search Mailfolder“ ohne markierten Text brachte „internal error during the search“): `Intern/BEFUNDE.md:408` Urteil von *„Gregors Test steht aus“* auf *„an 7.2.1.130 bei Gregor bestätigt (01.11.2026, gemessen an seinem Protokoll)“*, mit der Messung: im Abschnitt *Version 7.2.1.130* dreimal `E-171 Suche: kein Suchtext, Fenster ohne Start`, jedes Mal gefolgt vom Öffnen von *Find Messages*, keine Fehlermeldung, sauberes Beenden. Das Urteilswort bleibt „behoben“ wie bei [E-139](../Intern/BEFUNDE.md#e-139) und [E-165](../Intern/BEFUNDE.md#e-165); `perl tools/pruefe-befundurteile.pl` → *„Kein Dokument erklaert einen offenen Befund fuer erledigt - und keinen behobenen fuer unerledigt.“*, `offene-befunde.pl` weiter 45 (gemessen).
- `Intern/TESTPLAN.md`, Abschnitt `e-171-naechstes`: Absatz *„Bestätigt am 01.11.2026 an 7.2.1.130, gemessen an Gregors Protokoll …“*.
- [E-139](../Intern/BEFUNDE.md#e-139): ergänzt, dass dasselbe Protokoll wieder `E-139 Rechtschreibhinweis: abgeschaltet (WarnSpellUnavailable=0)` zeigt.

Keine Namen, Adressen oder Pfade aus dem Protokoll übernommen. Zu [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143) und [E-178](../Intern/BEFUNDE.md#e-178) steht im Protokoll laut Hauptagent noch nichts; nichts eingetragen.

Beim ersten Versuch hat mein Einschub über `perl -CSD -i -pe` diesen Bericht doppelt kodiert (23 Stellen); `pruefe-bytes.pl` hat den Commit abgewiesen. Zurückgesetzt und mit `tools/ersetze-text.pl` wiederholt.

## Zur Kenntnis

- `Releases/PRUEFBERICHT.md:506` führt [E-172](../Intern/BEFUNDE.md#e-172) noch unter den kritischen Befunden ohne Test. Die
  Datei ist erzeugt (`pruefbericht.pl`) und wird beim nächsten Paket neu geschrieben.
- `Intern/WEITERMACHEN.md:149` (Entscheidung vom 29.10.: [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172) *„stehen in der README unter
  „Bekannte Fehler““*) ist eine abgeschlossene Entscheidung im Wortlaut; [E-172](../Intern/BEFUNDE.md#e-172) steht dort nicht mehr,
  das ergibt sich aus BEFUNDE.
- `Arbeitsweise/CHRONIST-2026-11-01d.md`: keine Mailadresse, kein Betreff (gemessen mit `grep`).
  Außerhalb meines Umfangs, nur genannt.
- `tools/messen-e184.ps1:13` (*„GEMESSEN … (fremd=0)“*) nennt nur den Einzelfall; der Schalter
  `-Mehrere` ist bei `:53-56` beschrieben. Kein Fund.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen, vor den Berichtigungen): *„gepruefte Dateien 50 … Kein
Widerspruch gefunden.“* „Zur Kenntnis“: dieselben 18 Dateien ohne 7.2.1.130 wie in [LEKTOR-119](LEKTOR-119.md#lektor-119).

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  45
      davon aktuell gemessen       4  (ab Nummer 125)
      davon veraltet gemessen     28
      davon NIE gemessen          13
    in Intern/WEITERMACHEN.md     45
  45 offene Befunde, in beiden Listen gleich.
```

46 → 45 durch [E-172](../Intern/BEFUNDE.md#e-172); „nie gemessen“ 14 → 13 aus demselben Grund. Nach den Berichtigungen mit
`-schreiben` neu erzeugt, danach `perl tools/befunde-verlinken.pl --anker --verlinken`: *„Jede
Kennung ist ein Link, und jeder Link trifft eine Urteilszeile.“*

`perl tools/pruefe-regressionstest.pl`: *„Kein neues "behoben" ohne Regressionstest.“*

`perl tools/ziel-stand.pl`: *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

## Was nur Gregor entscheiden kann

Nichts Neues.
