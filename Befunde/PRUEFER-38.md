# PRÜFER-38 — 7.2.0.109: P1, P2 und P3 aus PRÜFER-36 nachgerechnet

Gegenstand: drei Commits auf `e-69-meldungsflut`, Quellstand **7.2.0.109**.

| Commit | Inhalt | Dateien |
|---|---|---|
| `6b2b5f09` | **P1** Notbremse entschärft, **P2** Zähler umgesetzt | `mainfrm.cpp`, `EuImap/src/ImapActionQueue.cpp` |
| `e15053ac` | **P3** Meldungsflut: A Sammeleintrag, B Schwallbremse | `filtersd.cpp`, `filtersd.h`, `TocFrame.cpp`, `TaskErrorView.cpp`, 9 Tests |
| `6aebed24` | Nachtrag: `E69LautErlaubt` vor ihre Verwendung gestellt | `TaskErrorView.cpp` |

**Wie geprüft.** Am Quelltext gelesen, nichts mit Oberfläche gestartet. Dazu
**eine eigene Messung am echten Code**: `Eudora71/Tests/generated/filtersd_e69.inc`
(von `Extract.ps1` aus `filtersd.cpp` geschnitten) in ein eigenes
Konsolenprogramm eingebunden und über die Folge gefahren, die im Betrieb
entsteht — ein geklammerter Lauf, danach ein **un**geklammerter Fall.
Quelle im Kratzverzeichnis:
`…\scratchpad\e69\probe.cpp`. Dazu `Eudora71\Tests\RunTests.cmd`: **222 Tests, 222 bestanden,
0 fehlgeschlagen** — selbst gefahren am 19.10.2026, mit R1 im Code. Der
Prüfstand sieht R1 nicht; warum, steht unter R6.

---

## Urteil

**Paket 1.0.109 zu Gregor: NEIN — nicht in diesem Stand. Ein Fund muss vorher
hinein, er ist eine Rückkehr genau des Fehlers, den [E-69](../Intern/BEFUNDE.md#e-69) behebt.**

**Punkt 1 und Punkt 4 aus dem Auftrag zuerst, weil beide „Eudora lässt sich
nicht mehr beenden" betreffen — beide sind entwarnt:**

> **Punkt 1: Nein, Eudora bleibt beendbar.** Nach dem Aufgeben steht
> `m_bE123Gewartet` weiter auf `TRUE`. Beim **zweiten** *File → Exit* findet
> `OnClose` deshalb `m_bE123WarteAktiv == FALSE` und `m_bE123Gewartet == TRUE`,
> überspringt den Warteblock vollständig und ruft `CloseDown()`. Es gibt keinen
> Zustand, in dem der Anwender nicht mehr herauskommt. Belegt am Quelltext
> (`mainfrm.cpp:5303-5325`).
>
> **Punkt 4: Nein, nicht doppelt gezählt.** Die beiden Wächter liegen
> **nacheinander** auf dem Stapel, nicht ineinander:
> `CImapFromLocalTransferMsgAction::DoPreThreadAction` (`:2321`) endet, bevor
> `DoPostProcessing` (`:2398`) beginnt — dazwischen liegt `DoWork` im
> Nebenfaden. Beide sind Stapelobjekte und zählen auf **jedem** Rückgabeweg
> wieder ab, auch bei `return false` und bei einer Ausnahme. Der Zähler kann
> nicht stehenbleiben.

**Was das Paket aufhält, ist P3:**

> **R1 — nach dem ersten geklammerten Lauf verschwinden Meldungen ganz.**
> `CE69Sammlung::LaufEnde()` setzt `bErstGemeldet` **nicht** zurück. Hat ein
> geklammerter Lauf (Special → Filter Messages, Junk-Durchlauf) einmal etwas
> übersprungen, liefert `Melden()` für **jeden** weiteren Fall außerhalb einer
> Klammer `false` — und `E69UebersprungenMelden` kehrt ohne Eintrag zurück.
> Es entsteht **kein Eintrag, kein Sammeleintrag, nichts**. Das ist genau das
> Symptom, gegen das [E-69](../Intern/BEFUNDE.md#e-69) angelegt wurde: *„lautlos: der Anwender wunderte
> sich, warum eine Mail nicht einsortiert wurde"* (`filtersd.cpp:2370`).
> **Gemessen**, siehe R1.

### Funde

| Fund | Schwere | Stand |
|---|---|---|
| **R1** Nach einem geklammerten Lauf wird jeder ungeklammerte Fall stumm verschluckt — [E-69](../Intern/BEFUNDE.md#e-69) ist für den Rest der Sitzung wieder da | **hoch.** Rückschritt hinter 7.2.0.106 | **gemessen** |
| **R2** Die Klammer fehlt am IMAP-Weg — also an genau dem Fall, mit dem der Commit begründet wird | **mittel.** P3 ist für den Anlassfall nicht behoben | belegt am Quelltext |
| **R3** `g_E69Sammlung` ist global ohne Sperre und wird auch aus einem IMAP-Nebenfaden angefasst | **mittel, selten.** Verlorene und falsch gezählte Einträge, kein Absturz | belegt am Quelltext |
| **R4** Zweites *File → Exit* nach dem Aufgeben ruft `CloseDown` verschachtelt im laufenden Hochladen | **mittel, selten.** Derselbe unsichtbare Hänger wie P1 — nur nicht mehr von selbst, sondern erst auf Zutun des Anwenders | belegt am Quelltext, Ablauf Vermutung |
| **R5** `bDialogOffen` ist auch wahr, wenn nur das Fortschrittsfenster läuft; die Meldung sagt dann „a dialog is still open. Close it" — es gibt keinen | gering, Text | belegt am Quelltext |
| **R6** Zwei Lücken im Prüfstand: die Sammlung wird nur auf frischen Objekten geprüft (deshalb blieb R1 grün), und `E69_SCHWALL_FENSTER_MS` wird nirgends gemessen | Prüflücke | belegt |
| **R7** Zwischen `DoPreThreadAction` und `DoPostProcessing` ist der Zähler wieder 0; dort gilt weiter die 90-s-Regel | gering, bekannt | belegt am Quelltext |
| **R8** `bNotfall ||` im `else if` ist seit P1 toter Zweig | kosmetisch | belegt |

**Was vor dem Paket hinein muss:** **R1**. Alles andere kann in den
Begleittext oder in den nächsten Durchgang.

---

## Punkt 1 — Bleibt Eudora beendbar? Nein, es bleibt beendbar.

`mainfrm.cpp:2005-2022`, der neue Zweig:

```cpp
if (bNotfall && (bLaeuft || bDialogOffen))
{
    KillTimer(E123_WARTE_TIMER_ID);
    m_bE123WarteAktiv = FALSE;
    SetMessageText(...);
    PutDebugLog(...);
}
```

Zurück bleibt: Zeitgeber aus, `m_bE123WarteAktiv == FALSE`,
`m_bE123Gewartet == TRUE` (gesetzt in `OnClose`, `:5316`, und danach **nirgends**
mehr zurückgesetzt — die einzigen zwei Stellen sind `OnQueryEndSession`
(`:5230`) und der Abbruch durch den Anwender in `CloseDown` (`:5334`)).

**Der zweite *File → Exit*:**

1. `OnClose` läuft an (`:5273`).
2. `if (m_bE123WarteAktiv)` → FALSE, es wird **nicht** ignoriert.
3. `if (!m_bE123Gewartet)` → FALSE, der ganze Warteblock wird **übersprungen**.
4. `CloseDown()` läuft, und Eudora endet.

**Der Anwender kommt also heraus.** Das war die wichtigste Frage, und die
Antwort ist gut.

### R4 — der Preis dafür

Genau dieser Weg ruft `CloseDown()`, **ohne** `bLaeuft` noch einmal
anzusehen. Läuft das Hochladen weiter (der Fall, der zum Aufgeben geführt hat),
dann wird `WM_CLOSE` aus der Nachrichtenschleife zugestellt, die das Hochladen
selbst dreht — `CloseDown` läuft **verschachtelt im Hochladen**. Das ist Lauf d
aus PRÜFER-34: Fenster weg, Prozess unsichtbar weiter.

**Belegt am Quelltext**, dass `OnClose` auf diesem Weg nichts mehr prüft.
**Vermutung** bleibt, dass der Ablauf danach hängt — abgeleitet aus der
Gegenprobe zu PRÜFER-34, nicht neu gemessen.

**Entschärfend, und das ist wichtig für die Schwere:** Während eines
Hochladens steht in aller Regel das Fortschrittsfenster, und das **sperrt das
Hauptfenster** (`progress.cpp:402-405`: `AfxGetMainWnd()->EnableWindow(FALSE)`).
Ein gesperrtes Hauptfenster nimmt weder den Menübefehl noch Alt-F4 an. Der
zweite Versuch ist dann gar nicht möglich. Er ist es nur, wenn das
Fortschrittsfenster aus ist (`ShowProgress=0`) oder zwischen zwei Schritten
schon geschlossen wurde.

**Vergleich zum alten Stand:** vorher geschah der verschachtelte Abbau nach
5 Minuten **von selbst**. Jetzt geschieht er nur noch, wenn der Anwender
danach ausdrücklich noch einmal beendet. Das ist eine echte Verbesserung —
aber der Weg ist nicht zu.

**Kleinster sicherer Gegenvorschlag.** Zwei Möglichkeiten, beide eine Zeile:

* **(a)** im Aufgeben-Zweig zusätzlich `m_bE123Gewartet = FALSE;`. Dann wartet
  der nächste Versuch wieder — und gibt im schlimmsten Fall wieder nach
  5 Minuten auf. Das Fenster bleibt dabei jedes Mal stehen und bedienbar.
  **Preis, ehrlich genannt:** solange eine Übertragung nie zurückkehrt, kommt
  der Anwender über *File → Exit* nicht mehr heraus. Das Herunterfahren von
  Windows geht weiter (`OnQueryEndSession` wartet nicht).
* **(b)** in `OnClose` vor `CloseDown()` prüfen, ob gerade ein Hochladen läuft,
  und dann denselben Statustext noch einmal setzen statt abzubauen. Wirkung
  wie (a), aber die Entscheidung steht an der Stelle, an der sie gilt.

Ich empfehle **(b)** und rate von „gar nichts tun" ab — nicht wegen der
Häufigkeit, sondern weil der unsichtbare Hänger der einzige Zustand ist, aus
dem Gregor nur über den Task-Manager herauskommt.

## Punkt 2 — Kann `bDialogOffen` dauerhaft wahr sein? (R5)

`!IsWindowEnabled()` ist nicht auf modale Dialoge beschränkt. Im Baum gibt es
vier Stellen, die das Hauptfenster sperren:

| Stelle | Anlass | Freigabe |
|---|---|---|
| `progress.cpp:403` | **Fortschrittsfenster** — jeder längere Vorgang, auch das Hochladen selbst | `CloseProgress`, `:471-475` |
| `tocview.cpp:3777` | Postfach sortieren | `:3996`, kein `return` dazwischen (geprüft) |
| `summary.cpp:3032` | Nachrichtenliste drucken | `:3042` und `:3062` |
| `guiutils.cpp:3422` | `SyncPlayMedia` mit `bDisableMainWindow` | `:3456` |

**Dauerhaft wahr ohne Dialog habe ich nicht gefunden** — alle vier Paare sind
symmetrisch, und in keinem liegt ein `return` zwischen Sperren und Freigeben.
Nur eine Ausnahme zwischen beiden Zeilen ließe das Fenster gesperrt zurück;
das ist in keinem der vier Fälle abgefangen, aber auch kein neuer Befund aus
diesem Commit.

**Was aber vorkommt:** `bDialogOffen` ist regelmäßig wahr, **ohne dass ein
Dialog offen ist** — nämlich immer dann, wenn das Fortschrittsfenster läuft.
Fällt in diesem Moment `bLaeuft` auf falsch (die Lücke aus R7), zeigt Eudora

> „Quit cancelled: a dialog is still open. Close it, then quit again."

und der Anwender sucht einen Dialog, den es nicht gibt. Das
Fortschrittsfenster kann er auch nicht schließen.

**Kleinster sicherer Gegenvorschlag:** den zweiten Text neutral fassen, etwa
*„Quit cancelled: Eudora is busy. Try again in a moment."* Oder `InProgress`
mit abfragen und dann den ersten Text zeigen.

## Punkt 3 — Faden von Spurmarke und `SetMessageText`

**In Ordnung.** `OnTimer` ist der Behandler von `WM_TIMER`; `SetTimer` wurde
ohne Rückruffunktion gesetzt (`mainfrm.cpp:5320`), die Botschaft geht also an
das Fenster und wird aus der Nachrichtenschleife des **Hauptfadens** zugestellt.
`SetMessageText` (MFC, Statusleiste) und `PutDebugLog` laufen damit im
richtigen Faden. Kein Fund.

### R8 — toter Zweig

`else if (bNotfall || (!bLaeuft && !bDialogOffen && ...))`: Wer den `else`-Zweig
erreicht und `bNotfall` trägt, hat `!bLaeuft && !bDialogOffen` — und dann ist
`dwVergangen > 300000` auch `> 90000`, die zweite Klammer also ohnehin wahr.
`bNotfall ||` ist seit P1 ohne Wirkung. Harmlos, aber es liest sich wie eine
Notbremse, die es nicht mehr gibt.

---

## Punkt 4 — Doppelt gezählt? Nein.

```
CImapFromLocalTransferMsgAction::DoPreThreadAction   :2321  CE123HochladenZaehler(true)   ← neu
   … FindAccount, GetToc, OpenMailbox (Anmeldung, SELECT), SetPostProcFn
   ← Rumpfende: Zähler ab
        ↓  (DoWork im Nebenfaden, Zähler 0)
CImapFromLocalTransferMsgAction::DoPostProcessing    :2398  CE123HochladenZaehler(true)   ← stand schon da
   … der eigentliche Transfer
   ← Rumpfende: Zähler ab
```

Beide sind **Stapelobjekte in verschiedenen Funktionen, die nacheinander
laufen**. `DoPostProcessing` wird in `DoPreThreadAction` nur **registriert**
(`m_pTaskInfo->SetPostProcFn(..., ::DoPostProcessing, this)`, `:2363`), nicht
gerufen — es läuft erst, nachdem `DoWork` im Nebenfaden fertig ist. Es gibt
keinen Weg, auf dem der eine im anderen steckt.

Schachtelt sich der Zähler trotzdem — weil `OpenMailbox` Botschaften zustellt
und dabei die Nachbearbeitung einer **anderen** Aufgabe anläuft —, dann ist das
unschädlich: jedes Objekt zählt sein eigenes `Interlocked` wieder ab, und ein
Stand > 1 bedeutet weiterhin genau „es wird hochgeladen".

**Der Zähler kann nicht stehenbleiben**, solange die Funktion zurückkehrt. Er
bleibt nur stehen, wenn `OpenMailbox` oder der Transfer selbst nie
zurückkehren — und genau für diesen Fall gibt es seit P1 das Aufgeben nach
5 Minuten.

## Punkt 5 — Deckt der neue Ort `OpenMailbox`, Anmeldung und `SELECT`? Ja.

Die Reihenfolge im Rumpf (`ImapActionQueue.cpp:2304-2365`):

1. `CE123HochladenZaehler e123Zaehler(true);` — **erste Anweisung**
   (`:2321`), noch vor `m_iState = kActionStateWorking`.
2. `FindAccount`, `ImapFindByImapName`, `GetToc` — Rückgabewege `return false`
   (`:2329`, `:2344`).
3. `if (!OpenMailbox(m_pDestTocDoc->m_pImapMailbox)) return false;` (`:2347`)
   — hier liegen Verbindung, Anmeldung und `SELECT`.
4. `SetTaskType`, `SetTitle`, `SetPostProcFn`, `return true`.

Der Zähler lebt bis zum Rumpfende und deckt Schritt 3 ab. **N4 aus PRÜFER-35
ist damit geschlossen** — und zwar an der Stelle, die PRÜFER-36 vorgeschlagen
hat.

### R7 — die verbleibende Lücke

Zwischen Rückkehr aus `DoPreThreadAction` und Beginn von `DoPostProcessing`
liegt `DoWork` im Nebenfaden. Dort ist der Zähler wieder 0, die Aufgabe steht
aber noch in `m_array`, also `nOffen > 0`. Fällt die 90-s-Grenze hinein, wird
beendet. Das ist **nicht neu** und nicht gefährlich im Sinne von P1: der
Hauptfaden steht in diesem Moment in seiner eigenen Schleife, `CloseDown` läuft
also nicht verschachtelt in einem Hochladen. Nur die Übertragung bricht ab und
steht danach in `actionqueue.dat` — ohne die Schutzvermerke aus [E-123](../Intern/BEFUNDE.md#e-123). Bekannt,
kein neuer Fund.

## Punkt 6 — Wird der Wächter auf jedem Rückgabeweg abgebaut? Ja.

`CE123HochladenZaehler` ist ein lokales Objekt mit Destruktor. C++ ruft ihn bei
**jedem** Verlassen des Blocks: `return true`, alle drei `return false`
(`:2329`, `:2344`, `:2349`) und auch beim Durchlaufen einer Ausnahme. Das
Zählen selbst ist `InterlockedIncrement`/`Decrement`, also auch über Fäden
hinweg richtig. Kein Fund.

---

## Punkt 7 — `g_E69Sammlung` ohne Sperre: welcher Faden? (R3)

**PRÜFER-36 hat diese Frage schon einmal beantwortet — und die Antwort war
unvollständig.** Die dortige Liste der `FilterOne`-Aufrufer
(„alle liegen im Hauptfaden") nennt `pop.cpp`, `ImapChecker.cpp`, `msgdoc.cpp`,
`TocFrame.cpp` und `sendmail.cpp`. **Nicht genannt ist
`EuImap/src/ImapFiltersd.cpp:425`** — die Filterschleife von
`CImapFilterActions::DoFiltering`, über die der ganze IMAP-Weg läuft.

Und dieser Weg läuft **nicht nur** im Hauptfaden. `CImapMailbox::DoFetchNewMessages`
ruft `DoFiltering` (`ImapMailbox.cpp:2491`) und prüft im selben Rumpf
zweimal ausdrücklich den Faden:

* `if ( ::IsMainThreadMT() )` vor dem Fortschrittsfenster (`:2380`);
* `else if (pTaskInfo && !IsMainThreadMT() && …)` nach dem Filtern (`:2571`).

QUALCOMMs eigener Code rechnet an dieser Stelle also mit beiden Fäden. Damit
wird `g_E69Sammlung` — drei Felder ohne jede Sperre — potentiell aus einem
Nebenfaden angefasst.

**Was schiefgehen kann:**

* `nUebersprungen++` ist nicht atomar: der Sammeleintrag nennt eine zu kleine
  Zahl.
* Setzt der Nebenfaden `bErstGemeldet = true`, während der Hauptfaden in einem
  geklammerten Lauf steht, verliert der Hauptfaden seinen **ersten** Eintrag —
  das ist R1 über Fäden hinweg.
* `nTiefe` kann bei gleichzeitigem `LaufBeginn`/`LaufEnde` falsch stehen; die
  Zusammenfassung bleibt dann aus oder kommt mitten im Lauf.

**Kein Absturz, keine Speicherverletzung** — es sind zwei `int` und ein `bool`,
und `Register` selbst ist nach PRÜFER-36 fadensicher.

**Belegt am Quelltext**, dass der Weg für zwei Fäden geschrieben ist.
**Nicht gemessen**, wie oft er tatsächlich im Nebenfaden läuft.

**Kleinster sicherer Gegenvorschlag:** `g_E69Sammlung` mit
`__declspec(thread)` je Faden halten (die Klammer liegt ohnehin immer im selben
Faden wie ihre Schleife) — eine Zeile, keine Sperre, keine Verklemmungsgefahr.
Alternativ `InterlockedIncrement` für den Zähler und eine `CCriticalSection`
um die drei Felder.

## Punkt 8 — Aufrufwege zu `FilterOne` ohne Klammer (R2)

Die Klammer `CE69Filterlauf` steht an **zwei** Stellen, beide in `TocFrame.cpp`.
Vollständige Liste aller `FilterOne`-Aufrufer im Baum:

| Aufrufstelle | Schleife? | Klammer? |
|---|---|---|
| `TocFrame.cpp:2420` `OnFilterMessages` — **nur der lokale Zweig** | ja | **ja** (`:2407`) |
| `TocFrame.cpp:1035` `OnRecheckMessagesForJunk` → `ReprocessOne` | ja | **ja** (`:1009`) |
| **`EuImap/src/ImapFiltersd.cpp:425`** `CImapFilterActions::DoFiltering` | **ja** | **nein** |
| **`pop.cpp:999`** `CPOP::GetMailFromSpool` | **ja** | **nein** |
| **`TocFrame.cpp:1190`** `OnJunkMessages`/`OnNotJunkMessages` → `DeclareJunk` | **ja** | **nein** |
| **`sendmail.cpp:187`** Warteschlange senden | **ja** | **nein** |
| `msgdoc.cpp:792` eine geöffnete Nachricht filtern | nein, genau eine | nein, richtig so |

**Die Antwort auf die Frage aus dem Auftrag:**

* **`msgdoc.cpp:792`** — stimmt, **eine** Nachricht (`m_Sum`). Keine Klammer
  nötig.
* **`JunkMail.cpp` `ReprocessOne` (:535) und `DeclareJunk` (:762)** — beide
  behandeln selbst genau eine Nachricht, **aber ihre Aufrufer sind Schleifen**.
  `ReprocessOne` ist über `TocFrame.cpp:1009` abgedeckt. **`DeclareJunk` nicht:**
  `TocFrame.cpp:1181-1197` läuft über die ganze Auswahl und ruft es je
  Nachricht mit `&filt`, also mit `FilterOne`. Dort fehlt die Klammer.
  (`SearchView.cpp:3721` ist ebenfalls eine Schleife über `DeclareJunk`, gibt
  aber `NULL` statt `&filt` mit — `JunkMail.cpp:760` prüft `if (pFilt)`, also
  kein `FilterOne`. Kein Fund.)

**Der schwerste Teil von R2 ist der IMAP-Weg — der Anlassfall des Commits
selbst.** `CTocFrame::OnFilterMessages` kehrt für IMAP-Postfächer **ganz oben
um**, 32 Zeilen **vor** der neuen Klammer (`TocFrame.cpp:2370-2378`):

```cpp
CTocDoc* Doc = GetTocDoc();
if (Doc && Doc->IsImapToc ())
{
    Doc->ImapFilterMessages();
    return;                       // <- die Klammer steht erst ab :2407
}
```

`ImapFilterMessages` (`ImapToc.cpp:3846`) → `DoManualFiltering`
(`ImapFiltersd.cpp:650`) → `DoFiltering` (`:359`) → Schleife (`:418-440`) →
`FilterOne` (`:425`). **Ohne Klammer.**

Die Commit-Nachricht begründet die Behebung mit genau diesem Fall:

> *„Filtert der Anwender ein IMAP-Postfach mit 500 nur angerissenen
> Nachrichten, waehrend der Server nicht erreichbar ist: 500 Eintraege, 500
> Pieptoene, 500 Fenstersprunge"*

Für diesen Fall greift **A nicht** — es bleiben 500 Einträge. Gedämpft wird
nur das Laute durch B (auf etwa 25 Pieptöne). Dasselbe gilt für das
automatische Abholen (`ImapChecker.cpp:1678` und `ImapMailbox.cpp:2491`) und
für POP (`pop.cpp:999`).

**Kleinster sicherer Gegenvorschlag:** je eine Zeile `CE69Filterlauf e69Lauf;`

* in `CImapFilterActions::DoFiltering`, vor der Schleife (deckt Handfilter,
  automatisches Abholen und `DoManualFiltering` in einem);
* in `CPOP::GetMailFromSpool`, vor `while (pos)` (`pop.cpp:994`);
* in `CTocFrame::OnJunkMessages`, vor der Auswahlschleife (`:1181`);
* in `sendmail.cpp` vor der Sendeschleife.

`filtersd.h` ist von allen vieren erreichbar; `ImapFiltersd.cpp` bindet
`filtersd.h` bereits ein.

**Wichtig: R2 darf nicht ohne R1 behoben werden.** Solange `LaufEnde` nicht
aufräumt, macht jede zusätzliche Klammer R1 **häufiger**, nicht seltener.

## R1 — nach dem ersten Lauf verschwinden Meldungen ganz (gemessen)

`filtersd.cpp:2434-2439`:

```cpp
int LaufEnde()
{
    if (nTiefe > 0 && --nTiefe == 0 && nUebersprungen > 1)
        return nUebersprungen - 1;
    return 0;
}
```

`nUebersprungen` und `bErstGemeldet` werden **nur** in `LaufBeginn()`
zurückgesetzt, und das auch nur beim Übergang von Tiefe 0 auf 1.
`LaufEnde()` lässt beide stehen.

Der Kommentar zwei Zeilen darüber behauptet das Gegenteil:

> *„Laeuft ausserhalb eines Laufs ueberhaupt etwas auf (nTiefe == 0, etwa weil
> ein Aufrufer die Klammer nicht setzt), wird jeder Fall einzeln gemeldet —
> das ist das alte Verhalten und damit kein Rueckschritt."*

**Das stimmt nur für die allererste Meldung der Sitzung.**

### Die Messung

`generated/filtersd_e69.inc` unverändert eingebunden, eine globale
`CE69Sammlung g = { 0, 0, false }` wie im Produktivcode, dann die Folge aus dem
Betrieb:

```
Lauf1 Fall1 Eintrag=1            <- geklammert: erster Fall bekommt einen Eintrag
Lauf1 Fall2 Eintrag=0
Lauf1 Ende Sammeleintrag ueber=1 <- richtig
ohne Klammer Fall1 Eintrag=0     <- FALSCH: kein Eintrag
ohne Klammer Fall2 Eintrag=0     <- FALSCH: kein Eintrag
ohne Klammer LaufEnde=0          <- auch kein Sammeleintrag
Stand: nTiefe=0 nUebersprungen=4 bErstGemeldet=1
```

Die beiden ungeklammerten Fälle erzeugen **nichts**: `Melden()` liefert
`false`, `E69UebersprungenMelden` kehrt vor `E69EintragAnlegen` zurück
(`filtersd.cpp:2502-2503`), und es gibt keine Klammer, die sie je nachträgt.

### Was der Anwender davon hat

Gregor filtert einmal von Hand ein lokales Postfach, in dem zwei Nachrichten
unlesbar sind (`Special → Filter Messages`). Er bekommt richtig einen Eintrag
und einen Sammeleintrag. **Ab diesem Moment, bis Eudora neu gestartet wird**,
verschwindet jede weitere übersprungene Nachricht spurlos aus „Task Errors" —
beim POP-Abholen, beim IMAP-Abholen, beim Filtern einer einzelnen geöffneten
Nachricht, beim Senden. Genau der Zustand von vor [E-69](../Intern/BEFUNDE.md#e-69): *„der Anwender
wunderte sich, warum eine Mail nicht einsortiert wurde."*

Die Protokollzeile bleibt (`filtersd.cpp:2494`, vor der Prüfung) — der Befund
ist also nachträglich noch im Log zu finden. In der Oberfläche steht nichts.

**Was verloren gehen kann:** keine Nachricht. Die Nachricht bleibt in ihrem
Postfach. Verloren geht der **Hinweis**, dass sie nicht gefiltert wurde.

### Kleinster sicherer Gegenvorschlag

```cpp
int LaufEnde()
{
    if (nTiefe > 0 && --nTiefe == 0)
    {
        int nWeitere = (nUebersprungen > 1) ? nUebersprungen - 1 : 0;
        nUebersprungen = 0;
        bErstGemeldet  = false;
        return nWeitere;
    }
    return 0;
}
```

Fünf Zeilen, keine neue Abhängigkeit, und `Extract.ps1` schneidet die Struktur
ohnehin schon aus. **Dazu ein Test** (siehe R6).

## Punkt 9 — Gehen Meldungen verloren?

**Zwei Antworten, und die erste ist die wichtige.**

**Durch R1: ja, ganze Meldungen, und das ist nicht vertretbar.** Siehe oben.

**Durch den Sammeleintrag selbst: ja, aber vertretbar.** Der Sammeltext

> „N further message(s) could not be read and were not filtered. They are still
> in their mailboxes; nothing was lost."

nennt weder Betreff noch Postfach noch Grund. Verloren geht gegenüber
7.2.0.106:

* **welche** Nachrichten es waren — der Anwender kann sie nicht gezielt
  aufsuchen;
* **ob der Grund derselbe war.** Die fünf Gründe (`no mailbox`,
  `no IMAP mailbox`, `headers could not be fetched from the server`,
  `message could not be loaded from the mailbox file`,
  `the message text could not be read`) werden alle in eine Zahl geworfen. Der
  Anwender sieht den Grund des **ersten** Falls und schließt daraus auf die
  übrigen — möglicherweise falsch.
* Der Sammeltext sagt pauschal *„could not be read"*. Für `no mailbox` und
  `no IMAP mailbox` stimmt das nicht.

**Warum ich das trotzdem für vertretbar halte:** Die Angaben stehen vollständig
im Protokoll (`filtersd.cpp:2479-2494`, je Fall mit Betreff, Postfach und
Grund), und zwar **vor** der Entscheidung über den Eintrag. Und die Alternative
— 500 Zeilen in einem Fenster, das sich dabei 500-mal nach vorn drängt — ist
für den Anwender nachweislich schlechter. Es ist Gregors Anordnung („A und B")
und die richtige Abwägung.

**Kleiner Vorschlag, eine Zeile:** im Sammeltext mitzählen, ob alle denselben
Grund hatten, oder den Text neutral fassen: *„N further message(s) were skipped
and not filtered."*

## Punkt 10 — Decken die neun Tests, was sie sollen? (R6)

**Was gut ist.** Beide Regeln stehen in eigenen Einheiten, und `Extract.ps1`
(Region O und P) schneidet sie bei jedem Bau frisch aus dem Produktivcode —
kein abgeschriebener Code im Prüfstand. Die Gegenprobe ist gefahren und in
Zahlen notiert (500 → 25 statt 500 → 500). Die beiden Ränder von B sind
richtig gewählt: 1999/2000 ms und der Überlauf von `GetTickCount`
(`0xFFFFFF00` → `0x00000100` = 512 ms). Test 9 prüft auch den Nullzeiger.

**Was fehlt — und warum R1 grün blieb:**

1. **Kein Test läuft auf einem benutzten Objekt.** Jeder Testblock beginnt mit
   `UTE69_Neu()`. In Eudora ist es **eine globale Variable**, die über die
   ganze Sitzung lebt. Test 6 („ohne Klammer bleibt es beim alten Verhalten")
   ist genau die Gegenprobe zu R1 — sie wird aber auf einem **frischen**
   Objekt gefahren und kann den Fund deshalb nicht sehen.
   **Fehlender Test:** nach `LaufBeginn / Melden / Melden / LaufEnde` muss ein
   `Melden()` ohne Klammer wieder `true` liefern.
2. **`E69_SCHWALL_FENSTER_MS` wird nirgends gemessen.** `Extract.ps1` schneidet
   nur die Funktion `E69LautErlaubt`, nicht das `#define` zwei Zeilen darüber
   (`TaskErrorView.cpp:217`). Alle Tests reichen die 2000 selbst herein. Stünde
   im Produktivcode `2000000`, bliebe der Prüfstand grün und Eudora stumm.
   **Fehlender Test:** die Region mitschneiden und
   `TT_CHECK(E69_SCHWALL_FENSTER_MS == 2000)`.
3. **Keine Schranke über die Aufrufstellen.** R2 ist kein Fehler *in* der
   Regel, sondern ein fehlender Aufruf. Kein Test der Welt findet das von
   innen. Eine Schranke in `tools/`, die jede Schleife mit `FilterOne` gegen
   das Vorhandensein von `CE69Filterlauf` im selben Rumpf hält, hätte alle
   vier Fundstellen aus R2 gemeldet — und würde es bei der nächsten neuen
   Schleife wieder tun ([Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md)).
4. **Der Faden wird nicht geprüft** (R3). Zwei Fäden gleichzeitig auf dieselbe
   Struktur zu setzen, ist im Prüfstand machbar und würde R3 sichtbar machen.
5. **`dwJetzt == 0`** (`E69LautErlaubt` legt dann `1` ab, damit `0` weiter
   „noch nie" heißt) ist nicht geprüft. Kleinigkeit, aber die Zeile steht
   ausdrücklich dafür da.

**Und die Warnung aus dem Auftrag gilt hier doppelt.** Dass die Sammlung in
einer eigenen `struct` steht, macht sie prüfbar — es macht aber auch den
Unterschied zwischen „die Struktur rechnet richtig" und „Eudora meldet
richtig" größer. Beide Lücken, die ich gefunden habe (R1 und R2), liegen genau
in diesem Spalt: **die Regel ist richtig geprüft, ihre Verwendung nicht.**
Das ist derselbe Spalt, durch den `6aebed24` gefallen ist (222 von 222 grün,
während Eudora nicht übersetzte).

---

## Zusammenfassung: was vor 1.0.109 hinein muss

1. **R1** — `LaufEnde()` setzt `nUebersprungen` und `bErstGemeldet` zurück.
   Fünf Zeilen. **Ohne das ist 1.0.109 in diesem Punkt schlechter als
   1.0.106.** Dazu der Test aus R6.1.
2. **R2** — die vier fehlenden Klammern, allen voran
   `CImapFilterActions::DoFiltering`. Ohne sie ist der Anlassfall des Commits
   nicht behoben. **Nur zusammen mit R1.**
3. **R4** — `OnClose` soll nicht verschachtelt abbauen. Eine Zeile.

Danach kann das Paket zu Gregor. **R3** (Faden), **R5** (Text), **R6.2/6.3**
(Prüfstand und Schranke) und **R8** gehören in den nächsten Durchgang,
**R7** bleibt wie besprochen offen.

## Gregors Test an 1.0.109 — wenn R1 und R2 drin sind

> **Nachtrag LEKTOR, 19.10.2026 ([LEKTOR-42](LEKTOR-42.md#lektor-42)):** **1.0.109 ist nie geschnürt worden** (`Releases/PAKETE.md`, Abschnitt 1.0.109). R1 bis R4 sind eingebaut, und das Ergebnis heißt **1.0.110**. Gregors Prüfschritte stehen dort: `TESTPLAN.md`, Abschnitt [C6](../Intern/TESTPLAN.md#c6).

**Test 1 ([E-69](../Intern/BEFUNDE.md#e-69)/A, der Anlassfall):** Ein IMAP-Postfach mit mehreren nur
angerissenen Nachrichten auswählen, Netz trennen, dann
*Special → Filter Messages*. Erwartet: **genau zwei** Einträge in „Task Errors"
— einer mit Betreff und Grund, einer mit „N further message(s)…". Nicht einer
je Nachricht.

**Test 2 (R1, die Gegenprobe):** **Direkt danach**, ohne Eudora neu zu starten,
eine einzelne Nachricht öffnen und *Special → Filter This Message*. Erwartet:
ein eigener Eintrag. Kommt **keiner**, ist R1 nicht behoben.

**Test 3 ([E-69](../Intern/BEFUNDE.md#e-69)/B):** Beim Lauf aus Test 1 darauf achten, dass es höchstens alle
zwei Sekunden piept und das Fenster „Task Errors" nicht dauernd nach vorn
springt.

**Test 4 ([E-123](../Intern/BEFUNDE.md#e-123), wie bisher):** Eine Mail aus einem lokalen Ordner in einen
IMAP-Ordner verschieben, sofort beenden und gleich noch einmal auf das Kreuz
klicken. Im Protokoll: „Beenden wartet auf 1 Uebertragung(en)", „weiteres
Schliessen waehrend des Wartens ignoriert", „Warten zu Ende nach … ms,
offen=0", `E-33 ExitInstance: erreicht`.

**Nicht testen:** fünf Minuten warten und danach ein zweites Mal beenden,
während das Hochladen noch läuft. Das ist R4, und es kann Eudora unsichtbar
hängen lassen.
