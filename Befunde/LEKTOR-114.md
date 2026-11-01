# <a id="lektor-114"></a>LEKTOR-114 — Bestand nach 289cb512, Zweig e178_bearbeiten_emoji (01.11.2026)

Lauf im Arbeitsbaum `.wt/lektor` (Zweig `wt/lektor-20261101d`, Stand
`289cb512`, abgezweigt von `origin/e178_bearbeiten_emoji`). Geprüft: der
Fund aus [LEKTOR-113](LEKTOR-113.md), alle `.md`-Änderungen seit `f4500d97`
(Stand nach dem Merge von #194) und der übrige Bestand außerhalb von
`Arbeitsweise/` und `Befunde/`. Neu in dieser Sammlung:
[E-178](../Intern/BEFUNDE.md#e-178) (Emoji im Bearbeiten-Modus),
[E-179](../Intern/BEFUNDE.md#e-179) (HTML-zu-Text schneidet Zeichenangaben ab),
[E-170](../Intern/BEFUNDE.md#e-170) (Label beim Verschieben im IMAP-Konto),
[E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis aus Filtern) je im Quellstand,
[E-184](../Intern/BEFUNDE.md#e-184) neu (fremde Zusammenfassung überschrieben),
die Spur zu [E-173](../Intern/BEFUNDE.md#e-173) (Labels im Filterfenster grau),
Gregors Entscheidungen zu [E-170](../Intern/BEFUNDE.md#e-170) und [E-143](../Intern/BEFUNDE.md#e-143).

Nichts gebaut, nichts gestartet.

## Kurz

[L-113.1](LEKTOR-113.md#l-113.1) ist **erledigt**. Nirgends steht, eine der
vier Behebungen sei „behoben“ — BEFUNDE, die erzeugten Listen in CHANGELOG und
WEITERMACHEN und die drei TESTPLAN-Abschnitte sagen übereinstimmend „im
Quellstand, am Programm nicht gemessen“ (gemessen, `grep`). Die Zeilenangaben
zu [E-178](../Intern/BEFUNDE.md#e-178) und [E-179](../Intern/BEFUNDE.md#e-179) stimmen alle (16 von 16 gelesen). **Aber:** die
Behebungen fehlen im CHANGELOG-Abschnitt „Im Quellstand“ und in der
Standzeile von WEITERMACHEN, Gregors Entscheidungen vom 01.11.2026 fehlen
unter „Geltende Entscheidungen“, der Testschritt zu [E-143](../Intern/BEFUNDE.md#e-143) lässt genau die
beiden Wege aus, an denen die erste Fassung scheiterte, und die Logzeile zu
[E-170](../Intern/BEFUNDE.md#e-170) erscheint mit der Vorgabe-Einstellung gar nicht. Zehn Funde, keiner am
Programm.

## Fund aus LEKTOR-113

| Fund | Worum es ging | Heute | Beleg |
|---|---|---|---|
| [L-113.1](LEKTOR-113.md#l-113.1) | ZIEL.md nannte die Herabstufung von [AN-1](../Intern/BEFUNDE.md#an-1) (Anhänge) nicht | **erledigt** | `ZIEL.md:68` *„[[AN-1](../Intern/BEFUNDE.md#an-1)] später (*„aufschreiben, jetzt nicht"*; seit 01.11.2026 auf Gregors Entscheidung *unkritisch*)“* (gemessen) |

## Die neuen Einträge im Bestand

| Stelle | Aussage | Urteil |
|---|---|---|
| `Intern/BEFUNDE.md:401` ([E-178](../Intern/BEFUNDE.md#e-178)) | *„offen — Behebung im Quellstand (01.11.2026 …), am Programm noch nicht gemessen“* | stimmt; die acht Zeilen in `TridentReadMessageView.cpp` (2679, 3218, 3228, 3349, 3419, 3422, 3632, 4069) und `TridentView.cpp:3944` tragen je `E136HtmlAusBstr` (gemessen) |
| `Intern/BEFUNDE.md:400` ([E-179](../Intern/BEFUNDE.md#e-179)) | *„Behebung im Quellstand …; die Umwandlung selbst ist gemessen, der Weg am Programm noch nicht“* | stimmt; `sendmail.cpp:2002, 2674, 2710, 2727`, `TextReader.cpp:49`, `Trnslate.cpp:5017`, `X1EmailIndexItem.cpp:251, 257` rufen je `Html2Text` (gemessen). Kein TESTPLAN-Abschnitt — so angekündigt (*„den Klickweg erst selbst am Prüfstand durchgehen, dann in den TESTPLAN“*) |
| `Intern/BEFUNDE.md:407` ([E-170](../Intern/BEFUNDE.md#e-170)) | *„offen — Behebung im Quellstand …“*, Gregors Entscheidung *„Label mitnehmen“* | stimmt mit `Arbeitsweise/entscheidung-e170-e143-01-11.md`; Logzeile siehe [L-114.5](#l-114.5) |
| `Intern/BEFUNDE.md:395` ([E-143](../Intern/BEFUNDE.md#e-143)) | *„offen — Filterteil im Quellstand berichtigt …; das Suchfenster ist nicht entschieden“* | stimmt mit der Entscheidung; `msgdoc.cpp:1521` und `TocFrame.cpp:2529` fragen `E143OutGesperrt` (gemessen); Testschritt siehe [L-114.4](#l-114.4) |
| `Intern/BEFUNDE.md:399` ([E-184](../Intern/BEFUNDE.md#e-184)) | offen, am Quelltext belegt, *„Gregor muss nichts tun“* | stimmt; zwei Zeilenangaben falsch, siehe [L-114.6](#l-114.6) |
| `Intern/BEFUNDE.md:404` ([E-173](../Intern/BEFUNDE.md#e-173)) | Spur am Quelltext, *„Vermutung, nicht gemessen“* | als Vermutung richtig gekennzeichnet; Zeilen verrutscht, siehe [L-114.7](#l-114.7) |
| `Intern/BEFUNDE.md:158-163` | wichtig 20 offen / 68, zusammen 44 / 224 | stimmt mit `pruefe-regressionstest.pl` (*„wichtig 68“*) und `offene-befunde.pl` (44) (gemessen) |
| `CHANGELOG.md:30-43`, `Intern/WEITERMACHEN.md:79-92` | erzeugte Zeilen zu [E-184](../Intern/BEFUNDE.md#e-184), [E-179](../Intern/BEFUNDE.md#e-179), [E-178](../Intern/BEFUNDE.md#e-178), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143), je *„nie gemessen“* | stimmen mit BEFUNDE; zu [E-179](../Intern/BEFUNDE.md#e-179) siehe [L-114.10](#l-114.10) |
| `Intern/TESTPLAN.md:211`, `:233`, `:248` | drei Abschnitte *„Mit dem nächsten Testpaket auszuführen, nicht mit 7.2.1.129“* | stimmen; Inhalt siehe [L-114.4](#l-114.4), [L-114.5](#l-114.5) |
| `README.md`, `ZIEL.md`, `tools/WERKZEUGE.md` | nennen keine der vier Behebungen als erledigt | stimmt (gemessen, `grep`); README siehe [L-114.9](#l-114.9) |

**Stichproben Datei:Zeile:** 16 von 16 zu [E-178](../Intern/BEFUNDE.md#e-178)/[E-179](../Intern/BEFUNDE.md#e-179) stimmen; zu [E-143](../Intern/BEFUNDE.md#e-143)
`filtersv.cpp:2169` (`CMailboxButton::OnUpdateDynamicCommand`), `msgdoc.cpp:1521`,
`TocFrame.cpp:2529` stimmen; zu [E-184](../Intern/BEFUNDE.md#e-184) zwei von drei falsch, zu [E-173](../Intern/BEFUNDE.md#e-173) vier von
sechs verrutscht (alle gemessen, `sed -n`).

## Funde

### <a id="l-114.1"></a>L-114.1 — CHANGELOG „Im Quellstand“ kennt die vier Behebungen nicht

**Gewicht: wichtig.** `CHANGELOG.md:106-112` (gemessen)

Der Abschnitt *„Im Quellstand, noch in keinem Paket“* nennt *„**Zweig
`e165_schliessen_e136_speichern_unter`** (nach dem Merge von #193)“* und
darunter nur den zweiten Speicherweg von [E-136](../Intern/BEFUNDE.md#e-136)
und den Abschluss von [E-165](../Intern/BEFUNDE.md#e-165). Die Behebungen von
[E-178](../Intern/BEFUNDE.md#e-178), [E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170) und [E-143](../Intern/BEFUNDE.md#e-143) stehen dort nicht. `git diff -U0 f4500d97..HEAD
-- CHANGELOG.md` zeigt nur vier Hunks: drei in der erzeugten Tabelle
(`:30`, `:37`, `:43`), einer im Abschnitt 7.2.1.129 (`:117`). Kein Commit der
Sammlung hat den Abschnitt fortgeschrieben, obwohl sechs der Commits Code
ändern. Das ist dieselbe Klasse wie *„Schranke `pruefe-changelog-zuwachs.pl`
bauen“* (`Intern/WEITERMACHEN.md:44`): die erzeugte Tabelle wächst und
täuscht einen Zuwachs vor.

**Vorschlag:** Zweig auf `e178_bearbeiten_emoji` (nach dem Merge von #194)
setzen; je ein Punkt zu [E-178](../Intern/BEFUNDE.md#e-178), [E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143) mit „im Quellstand, am
Programm nicht gemessen“ und Verweis auf den TESTPLAN-Abschnitt; dazu [E-184](../Intern/BEFUNDE.md#e-184)
neu und die E-173-Spur.

### <a id="l-114.2"></a>L-114.2 — WEITERMACHEN-Standzeile nennt die Sammlung nicht

**Gewicht: wichtig.** `Intern/WEITERMACHEN.md:3` (gemessen)

*„Im Quellstand seit dem Schnüren: [[E-136](../Intern/BEFUNDE.md#e-136)] zweiter Speicherweg (`.htm`),
Schranken gegen blinde Tests (`TinyTest.cpp`) und gegen Kursiv im Urteilskopf
(`tools/fettstellen.pl`), erzeugte Stufentabelle.“* — [E-178](../Intern/BEFUNDE.md#e-178), [E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170) und
[E-143](../Intern/BEFUNDE.md#e-143) fehlen. Wer nach dem Abschalten hier anfängt, sieht nicht, dass vier
Behebungen auf das nächste Testpaket warten. Die Standnotiz weiß es
(`Arbeitsweise/stand-01-11-2026.md:32-35`), WEITERMACHEN nicht.

**Vorschlag:** die Aufzählung um die vier ergänzen, mit Verweis auf die drei
TESTPLAN-Abschnitte.

### <a id="l-114.3"></a>L-114.3 — Gregors Entscheidungen vom 01.11.2026 fehlen unter „Geltende Entscheidungen“

**Gewicht: wichtig.** `Intern/WEITERMACHEN.md:126-153` (gemessen)

Der Abschnitt sagt *„Gregors Entscheidungen vom 25. bis 29.10.2026,
nummeriert, damit sie nicht wieder gefragt werden“* (`:128`) und endet mit
Nummer 20 (30.10.2026, `:153`). Die Entscheidungen zu [E-170](../Intern/BEFUNDE.md#e-170) (*„Label
mitnehmen“*, nicht auf den Server) und [E-143](../Intern/BEFUNDE.md#e-143) (*„Out nicht anbieten“*, dazu
*„zusätzlich eine zeile im log“*, Suchfenster **nicht** entschieden) stehen in
`Arbeitsweise/entscheidung-e170-e143-01-11.md` und in BEFUNDE, hier nicht. Ebenso
die Herabstufungen von [E-136](../Intern/BEFUNDE.md#e-136) (31.10.) und
[AN-1](../Intern/BEFUNDE.md#an-1) (01.11.). Nummer 16 (`:149`) sagt weiter, [E-169](../Intern/BEFUNDE.md#e-169)
bis [E-172](../Intern/BEFUNDE.md#e-172) würden *„erst nach dem Release 7.2.1 behandelt“* — das ist eingelöst
(Release seit 29.10. draußen), steht aber ohne Vermerk.

**Vorschlag:** Nummern 21 bis 23 anfügen ([E-136](../Intern/BEFUNDE.md#e-136) unkritisch 31.10.; [AN-1](../Intern/BEFUNDE.md#an-1)
unkritisch 01.11.; [E-170](../Intern/BEFUNDE.md#e-170) und [E-143](../Intern/BEFUNDE.md#e-143) 01.11. mit dem offenen Suchfenster), den
Einleitungssatz auf „ab 25.10.2026“ ändern.

### <a id="l-114.4"></a>L-114.4 — Testschritt zu E-143 prüft nicht die Wege, an denen die erste Fassung scheiterte

**Gewicht: wichtig.** `Intern/TESTPLAN.md:248-262` (gemessen)

Der Abschnitt prüft nur *„Tools → Filters … auf die Postfach-Schaltfläche der
Aktion klicken“* (Schritt 1). *Make Filter* kommt nicht vor (`grep -i 'make
filter'` im Abschnitt: kein Treffer). BEFUNDE nennt aber ausdrücklich zwei
Wege: *„Filterfenster `filtersv.cpp`, *Make Filter* `MakeFilter.cpp`“* und
*„**allen vier** Freigabe-Handlern (Hauptfenster, `CMailboxButton`,
`CTocFrame`, `CMessageDoc` — der letzte für *Make Filter* aus dem geöffneten
Nachrichtenfenster)“* (`Intern/BEFUNDE.md:395`). Gerade `CTocFrame` (*Make
Filter* aus dem Postfachfenster, [PRÜFER-71](PRUEFER-71.md#k3) K3) und
`CMessageDoc` (aus dem Nachrichtenfenster, [PRÜFER-72](PRUEFER-72.md) K1)
waren die Stellen, an denen nichts grau wurde. [PRÜFER-73](PRUEFER-73.md)
vermerkt: *„ob Out in der laufenden Oberfläche grau erscheint — nicht
geprüft“*. Der Test am Programm ist also die erste und einzige Messung dieser
beiden Wege, und er geht sie nicht.

Nebenbei: Überschrift *„Out wird einem Filter nicht angeboten“*, Schritt 2
*„Out grau“*; die Entscheidung lautet *„Out im Transfer-Menue des
Filterfensters gar nicht anbieten“*. Grau statt entfernt ist eine Auslegung,
die in BEFUNDE nicht als solche steht (belegt). Gregor sieht es in Schritt 2
selbst; eine neue Frage ist das nicht.

**Vorschlag:** Schritte ergänzen: im Postfachfenster eine Nachricht markieren,
*Message → Make Filter*, Postfach-Schaltfläche: Out grau; dasselbe aus einer
geöffneten Nachricht. In BEFUNDE einen Halbsatz „ausgegraut statt entfernt
(Auslegung von „nicht anbieten“)“.

### <a id="l-114.5"></a>L-114.5 — Die Logzeile zu E-170 erscheint mit der Vorgabe nicht

**Gewicht: mittel.** `Intern/BEFUNDE.md:407`, `Intern/TESTPLAN.md:243-246` (gemessen am Quelltext)

`ImapActionQueue.cpp:1758` schreibt die Zeile mit
`::PutDebugLog(DEBUG_MASK_MISC, szSpur);`, `DEBUG_MASK_MISC = 0x8000`
(`QCUtils/public/inc/debug.h:36`). Die Vorgabe `LogLevel 25759` ist `0x649F`
(`Intern/BEFUNDE.md:7852`) — Bit `0x8000` fehlt. Gregors `58527` ist `0xE49F`,
dort steht es (so auch `Arbeitsweise/stand-01-11-2026.md:34`: *„Gregors
LogLevel 58527 hat MISC an, Vorgabe 25759 nicht“*). BEFUNDE sagt ohne
Einschränkung *„das sagt die Logzeile `[E-170](../Intern/BEFUNDE.md#e-170) Labels beim Verschieben im Konto:
… grund=keine-neuen-uids`“*, TESTPLAN Schritt 4 *„In der `eudora.log` steht
eine Zeile …“*. Bei [E-143](../Intern/BEFUNDE.md#e-143) steht die Bedingung dabei (*„`DEBUG_MASK_FILTERS`, in
der Vorgabe eingeschaltet“*, `0x400` ist in `0x649F` enthalten — gemessen).
Für Gregors Test trägt es; für jeden anderen Anwender und einen frischen
Prüfstand nicht — dort hieße „keine Zeile“ fälschlich „Weg nicht durchlaufen“.

**Vorschlag:** in BEFUNDE und TESTPLAN ergänzen: *„nur mit `LogLevel`, das
`0x8000` (MISC) enthält — bei Gregor 58527, nicht in der Vorgabe 25759“*.

### <a id="l-114.6"></a>L-114.6 — E-184 nennt die beiden anderen Aufrufer mit falschen Zeilen

**Gewicht: Kleinkram.** `Intern/BEFUNDE.md:399` (gemessen)

*„die Funktion hat zwei weitere Aufrufer (`ImapToc.cpp:2718`, `:3024`)“*. Die
Aufrufe von `ImapTransferSummaryData` stehen in `EuImap/src/ImapToc.cpp:2728`
und `:3034`, und zwar in jedem Stand seit `fff20261` (geprüft an `fff20261`,
`6cbbac35`, `2fdb12a7`, HEAD). `:2718` ist der Aufruf
`m_pImapMailbox->MoveMsgsToTrash(...)`, `:3024` die Deklaration
`CTocDoc *pTargetToc = NULL;`. [PRÜFER-71](PRUEFER-71.md#e-184) nennt keine
Zeilen; die Zahlen sind beim Übertragen entstanden.

**Vorschlag:** `:2728`, `:3034`.

### <a id="l-114.7"></a>L-114.7 — Zeilenangaben, die spätere Commits der Sammlung verschoben haben

**Gewicht: Kleinkram.** (gemessen)

| Stelle | steht | heute | Ursache |
|---|---|---|---|
| `Intern/BEFUNDE.md:404` ([E-173](../Intern/BEFUNDE.md#e-173)) | `filtersv.cpp:2258` (*„goddam“*) | `:2259` | [E-143](../Intern/BEFUNDE.md#e-143) in `49ff7a4f`/`2fdb12a7`; an `4d5780ed` stimmte es |
| ebenda | `filtersv.cpp:2269` (Aufklappen) | `:2270` (`TrackPopupMenu`) | dito |
| ebenda | `mainfrm.cpp:4665` (`OnUpdateMessageLabel`) | `:4667` | dito |
| ebenda | `mainfrm.cpp:8314` (Label-Menü) | `:8347` | dito |
| `tools/WERKZEUGE.md:156` | `TestMain.cpp:216`, `TT_Summary` | `:222` | drei neue `Run…Tests`-Zeilen ([E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143)); an `26dfa116` stimmte es |
| `Intern/BEFUNDE.md:407` ([E-170](../Intern/BEFUNDE.md#e-170), Altteil) | `summary.cpp:594` (Copy nimmt Label mit) | `:599` (`m_Label = NewInfo->m_Label;`) | schon vor der Sammlung falsch; `summary.cpp` hat sie nicht berührt |

Die Altteile von [E-143](../Intern/BEFUNDE.md#e-143) (`filtersd.cpp:1531`, `:1981`, `:1590-1594`,
`:2005-2009`) und [E-179](../Intern/BEFUNDE.md#e-179) (`html2text.cpp:1184`) stehen unter „Ursprünglicher
Befund“ und sind als Stand von damals lesbar; kein Fund.

**Vorschlag:** die sechs Zahlen nachziehen, bei [E-173](../Intern/BEFUNDE.md#e-173) mit „(Stand 01.11.2026,
nach [E-143](../Intern/BEFUNDE.md#e-143))“ wie bei [E-178](../Intern/BEFUNDE.md#e-178).

### <a id="l-114.8"></a>L-114.8 — PAKETE sagt im Kopf „seither nichts Neues“, darunter steht 7.2.1.129

**Gewicht: mittel.** `Releases/PAKETE.md:6` gegen `:182-184` (gemessen)

`:6`: *„Stand 31.10.2026 (Nummern bis 7.2.1.128 verzeichnet, geschnürt ist bis
7.2.1.128, seither nichts Neues …“*. `:182`: *„## 7.2.1.129 — Testpaket nach
dem Release 7.2.1“*, `:184`: *„Geschnürt am 31.10.2026 um 21:31“*. Die Zeile
`:6` wurde zuletzt in `21a629f6` (vor dem Schnüren) angefasst, nur das Datum.
Die Datei sagt selbst, warum das zählt: *„wer die nächste Fassungsnummer aus
dieser Liste ableitet, greift daneben“* — die Frage nach 7.2.1.130 steht an.

**Vorschlag:** *„Nummern bis 7.2.1.129 verzeichnet, geschnürt ist bis
7.2.1.129 (Testpaket, nicht veröffentlicht); zuletzt veröffentlicht
`v7.2.1.128` …“*.

### <a id="l-114.9"></a>L-114.9 — README und FAQ: Ursache zu E-170 halb, E-173 „nicht untersucht“

**Gewicht: Kleinkram.** (belegt)

* `README.md:165` und `Doku/FAQ.md:205-208`: *„Eudora speichert Labels nur bei
  sich, nicht auf dem Server“* als Grund. BEFUNDE hat die Ursache am
  01.11.2026 berichtigt: mit UIDPLUS nimmt der bisherige Weg das Label schon
  mit, verloren geht es ohne neue UIDs oder nach dem Löschen der alten
  Zusammenfassung (`Intern/BEFUNDE.md:407`, *„Ursache berichtigt … stimmt nur
  halb“*). `FAQ.md:208` sagt dazu *„eine Abhilfe kommt erst nach dem Release
  7.2.1“* — das Release ist seit 29.10. draußen, die Abhilfe liegt im
  Quellstand.
* `README.md:169` und `Doku/FAQ.md:202-203` zu [E-173](../Intern/BEFUNDE.md#e-173): *„Ursache noch nicht
  untersucht“*. Seit `4d5780ed` gibt es eine Spur am Quelltext (Vermutung).

Für das veröffentlichte Programm ist die Auskunft an Anwender richtig (Label
geht weg, Umgehung stimmt); falsch ist nur die Begründung bzw. die Zeitangabe.

**Vorschlag:** README/FAQ zu [E-170](../Intern/BEFUNDE.md#e-170): *„… geht beim Verschieben verloren, wenn
der Server keine neuen Nummern meldet; behoben im Quellstand, kommt mit dem
nächsten Paket“*. Zu [E-173](../Intern/BEFUNDE.md#e-173): *„Ursache noch nicht geklärt“*.

### <a id="l-114.10"></a>L-114.10 — ZWEIGE beschreibt den Zweig enger, als er ist; E-179 „nie gemessen“

**Gewicht: Kleinkram.** (gemessen)

* `tools/ZWEIGE.md:202`: Zweck von `e178_bearbeiten_emoji` *„[[E-178](../Intern/BEFUNDE.md#e-178)] …; dazu
  die Reste aus [[LEKTOR-113](LEKTOR-113.md#lektor-113)] [[L-113.1](LEKTOR-113.md#l-113.1)] und [PRÜFER-70] K1/K2, FAQ 16 in
  CHANGELOG/PAKETE“*. Der Zweig trägt inzwischen auch [E-179](../Intern/BEFUNDE.md#e-179), [E-170](../Intern/BEFUNDE.md#e-170), [E-143](../Intern/BEFUNDE.md#e-143),
  [E-184](../Intern/BEFUNDE.md#e-184) und die E-173-Spur (`git log --oneline f4500d97..HEAD`). Gregors Ja galt
  dem Namen; die Zweckzeile sollte den Inhalt nennen, den er beim Merge sieht.
* `CHANGELOG.md:31`, `Intern/WEITERMACHEN.md:80`: [E-179](../Intern/BEFUNDE.md#e-179) *„nie gemessen“*,
  während das Urteil sagt *„die Umwandlung selbst ist gemessen“*
  (`TestE179.cpp` an der echten Funktion, erst rot, dann grün). Gemeint ist „am
  Programm nie gemessen“; die erzeugte Spalte kennt nur eine Messmarke. Zur
  Kenntnis, wie [L-107.1](LEKTOR-107.md#l-107.1).

**Vorschlag:** Zweckzeile in ZWEIGE um die fünf Kennungen ergänzen.

## Bestand außerhalb von Arbeitsweise/ und Befunde/

64 Dateien (`git ls-files '*.md'` ohne die beiden Verzeichnisse). Gelesen auf
Standaussagen (Fassung, Zweig, offene Zahl, „behoben“, Testzahl) mit `grep`
und an den Fundstellen im Zusammenhang. Außer [L-114.1](#l-114.1) bis
[L-114.10](#l-114.10):

| Stelle | Aussage | Urteil |
|---|---|---|
| `README.md:103` | *„Stand **7.2.1.128** — erstes Release 7.2.1“* | stimmt: die README beschreibt das Veröffentlichte, 7.2.1.129 ist nicht veröffentlicht |
| `README.md:185` | Filter mit Ziel `Out` hält den Abruf *„vermutlich“* an | stimmt für 7.2.1.129 (Behebung nicht im Paket) |
| `Intern/PORTIERUNG.md:44` | *„Stand 29.10.2026, Zweig `release-7.2.1`“* | datiert, als Stand gekennzeichnet; kein Fund |
| `CHANGELOG.md:134` | *„341 Tests, 341 bestanden“* | im Abschnitt 7.2.1.129, Stand des Pakets; kein Fund |
| `ZIEL.md` | 27 von 27 erfüllt | stimmt mit `ziel-stand.pl` |
| Release-Notizen, ISSUE-102-Texte, `Testdaten/README.md`, `tools/pruefdaten/LIESMICH.md` | ältere Fassungen | datierte Texte; „Zur Kenntnis“ von `doku-pruefen.pl`, kein Fund |

Gesucht und nicht gefunden: „43 offen“ außerhalb datierter Abschnitte, eine
der vier Kennungen neben „behoben“ (gemessen, `grep -rn -i`).

## Werkzeuge

`perl tools/doku-pruefen.pl` (Exit 0, gemessen):

```
  Quellstand                   7.2.1.129
  Paketnummer                  7.2.1.129
  Kriterien in ZIEL.md         9
  gepruefte Dateien            50
  Kennungen im Verzeichnis     167
  Abschnitte in Intern/BEFUNDE.md 14

  Kein Widerspruch gefunden.
```

„Zur Kenntnis“: 19 Dateien ohne die Fassung 7.2.1.129 (alte
Release-Notizen, `tools/ZWEIGE.md`, `Doku/ANWENDER.md` u. a.) — wie in
[LEKTOR-113](LEKTOR-113.md#lektor-113). [L-114.8](#l-114.8) sieht das
Werkzeug nicht: `PAKETE.md` nennt 7.2.1.129, nur der Kopfsatz widerspricht.

`perl tools/offene-befunde.pl` (Exit 0, gemessen):

```
    offen laut Intern/BEFUNDE.md  44
      davon aktuell gemessen       4  (ab Nummer 124)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          14
    in Intern/WEITERMACHEN.md     44

  44 offene Befunde, in beiden Listen gleich.
```

`perl tools/pruefe-regressionstest.pl` (Exit 0, gemessen):

```
    kritisch    70   Verlust, Schaden, Absturz, Fremdschaden
    wichtig     68   Funktion unbrauchbar, nichts geht verloren
    unkritisch  41   Aussehen, Reste, Bequemlichkeit
    werkzeug    45   betrifft Bau und Werkzeuge, nicht das Programm
    OHNE Stufe   0
    mit Testfall im Pruefstand    60 von 70
    OHNE jede Pruefung             8   <- Rueckstand
      E-122 E-123 E-124 E-126 E-129 E-172 E-133 E-39

  Kein neues "behoben" ohne Regressionstest.
```

`perl tools/ziel-stand.pl` (Exit 0, gemessen):

```
  ziel-stand: 27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.
```

## Was nur Gregor entscheiden kann

Nichts Neues. Release-Vorgehen, [E-170](../Intern/BEFUNDE.md#e-170) und [E-143](../Intern/BEFUNDE.md#e-143) sind entschieden; ob jetzt
das Testpaket 7.2.1.130 kommt, ist ihm schon gestellt. [L-114.4](#l-114.4)
(grau statt entfernt) sieht er im Testschritt selbst; eine Frage wird daraus
erst, wenn er „entfernt“ verlangt. Das Suchfenster von [E-143](../Intern/BEFUNDE.md#e-143) bleibt eine
eigene Vorlage, wenn es drankommt — nicht aus diesem Bericht.
