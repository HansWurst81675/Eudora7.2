# <a id="pruefer-71"></a>PRUEFER-71 — Nachrechnung von E-178, E-179, E-170 und E-143, 01.11.2026

**Auftrag.** Geprüft habe ich, was seit `a26fc36f` (Merge #194) unter
`Eudora71` dazukam (`git log -p a26fc36f..HEAD -- Eudora71`, Stand
`49ff7a4f`). Das sind vier Behebungen in vier Commits: `26dfa116` ([E-178](../Intern/BEFUNDE.md#e-178)),
`4d209c08` ([E-179](../Intern/BEFUNDE.md#e-179)), `fff20261` ([E-170](../Intern/BEFUNDE.md#e-170)) und `49ff7a4f` ([E-143](../Intern/BEFUNDE.md#e-143)), dazu ihre Tests.

Eudora habe ich weder gebaut noch gestartet. Gebaut und gefahren habe ich nur
die Testsuite im Arbeitsbaum `.wt/pruefer` (`perl tools/pruefe-tests-gruen.pl`).
Grundlauf: **355 Tests, 355 bestanden, Rückgabe 0** (gemessen). Für vier
Gegenproben habe ich je eine Quelldatei vorübergehend per Perl geändert
(`:raw`, je genau 1 Ersatz, Trefferzahl geprüft). Danach habe ich sie mit
`git checkout -- <datei>` wiederhergestellt, und `git diff --quiet` war jedes
Mal leer. Der Schlusslauf war wieder 355/355 mit Rückgabe 0 (gemessen).

Jede Aussage trägt ihre Herkunft: **gemessen**, **am Quelltext belegt**
(Datei:Zeile) oder **Vermutung**. Zeilen beziehen sich auf `49ff7a4f`.

**Ergebnis vorweg.**

* **[E-178](../Intern/BEFUNDE.md#e-178) hält.** Der Schnitt des Start-Tags in `ExpandTag` und `SplitTagOff`
  verrutscht nicht: Die Umwandlung arbeitet Zeichen für Zeichen, und die
  Schnittstellen liegen an `<` und `>` (ASCII). Alle neun Stellen sind HTML,
  keine wird als Text weiterbenutzt. Eine fehlende Stelle habe ich nicht
  gefunden (am Quelltext belegt).
* **[E-179](../Intern/BEFUNDE.md#e-179) hält.** Der Aufrufer `AddText` rechnet `ul`, `ulTotalLength` und das
  Semikolon richtig weiter. `&#` am Pufferende, `&#x;` und sehr lange Zahlen
  gehen ohne Überlauf und ohne Verlust durch (am Quelltext belegt).
* **[E-170](../Intern/BEFUNDE.md#e-170) hat zwei wichtige Funde.** [K1](#k1): Die neue Zuordnung ordnet alte
  und neue UIDs aufsteigend zu. Die vorhandene `ImapTransferSummaryData` ordnet
  in Listenreihenfolge zu, also in der Sortierung der Anzeige. Bei mehreren
  Mails in einer anders sortierten Ansicht landet das Label dann **zusätzlich
  auf einer falschen Mail**. Genau das wollte der Befund ausschließen.
  [K2](#k2): In Gregors gemeldetem Fall greift die Behebung vermutlich gar
  nicht. Der Fall „alte Zusammenfassung schon fort“ ist im Quelltext kaum
  erreichbar. Übrig bleibt der Server ohne UIDPLUS, und dort setzt
  `E170LabelsNachtragen` nichts. Dazu kommt ein alter Fehler aus dem Original:
  [E-184](#e-184).
* **[E-143](../Intern/BEFUNDE.md#e-143) hat einen wichtigen Fund.** [K3](#k3): Das Ausgrauen von Out greift
  vermutlich in keinem der beiden Fenster. Andere Handler beanspruchen den
  Befehl, bevor der Handler im Hauptfenster drankommt: der Handler des
  Filterfensters selbst bzw. das aktive Postfachfenster. Beide schalten Out
  ausdrücklich ein. Das Übergehen im Filter (mit Logzeile) wirkt trotzdem; der
  Abruf hält also nicht an.
* **Die Tests sind für vier Rückfälle blind** (gemessen, [K5](#k5)). Am
  schwersten wiegt: Fehlt das `break` hinter der E-143-Logzeile, kommt der
  modale Dialog im Abruf zurück, und alle 355 Tests bleiben grün.
* **Hält das nächste Testpaket auf:** [K3](#k3) ja, denn der Testschritt
  „Out ist grau“ würde fehlschlagen; die Abhilfe ist klein. Für [K1](#k1)
  empfehle ich eine Schranke von wenigen Zeilen vor dem Schnüren. [K2](#k2)
  hält nicht auf, ändert aber die Erwartung im TESTPLAN.

---

## <a id="haelt"></a>Was hält

### E-178: der Schnitt des Start-Tags

`ExpandTag` (`TridentReadMessageView.cpp:3238`) und `SplitTagOff` (`:3429`)
schneiden das Start-Tag als
`outer.Left( len(outer) - len(inner) - len(EndTag) )` heraus. Die Gegenvermutung
war, dass Entitäten die Längen ungleich verändern. Das tun sie nicht, aus zwei
Gründen (am Quelltext belegt):

1. `E136HtmlAusBstr` wandelt im langsamen Weg **je UTF-16-Einheit** (bei einem
   Ersatzpaar je Paar), `TridentView.cpp:4046-4091`. Für eine Zeichenkette
   `outer = start + inner + end` gilt also
   `E(outer) = E(start) + E(inner) + E(end)`, solange kein Ersatzpaar über eine
   Schnittstelle reicht. Die Schnittstellen liegen an `>` bzw. `<`, beides
   ASCII. Ein Paar kann dort nicht geteilt sein.
2. Der schnelle Weg (`:4036`) gibt für eine zustandslose Codepage dieselben
   Bytes wie der langsame. Ob `inner` den schnellen und `outer` den langsamen
   Weg nimmt, ändert die Längen also nicht. Für 65001 hat
   [PRÜFER-68](PRUEFER-68.md) gemessen, dass der Aufruf nicht scheitert. Meine
   Gegenvermutung „unter UTF-8 wird jedes `<` zur Entität“ stand dort schon und
   ist widerlegt.

`EndTag` ist ein fester ASCII-Text und wird nicht umgewandelt. Er stimmt mit
dem Ende von `E(outer)` überein (ASSERT in `:3234`).

**Keine Stelle wird als Text weiterbenutzt.** `:3349` und `:4069` suchen die
Platzhalter als `&lt;…&gt;` bzw. als `Text2Html`-Fassung. Das ist HTML, und
alle Ergebnisse gehen über `put_outerHTML` bzw. `pasteHTML` zurück (am
Quelltext belegt). In `OnEditInsertLink` (`:2679`) wird `szInnerHTML` gleich
danach überschrieben (`:2689`) oder gar nicht mehr gelesen. Die Änderung dort
ist wirkungslos, aber harmlos; das steht auch so im Befund.

**Fehlt eine Stelle?** Alle `get_htmlText`/`get_innerHTML`/`get_outerHTML`
im Baum habe ich abgesucht. Übrig ist nur `:3482`, und dort geht der BSTR
unverändert an `put_outerHTML`, ohne `CString` dazwischen (am Quelltext
belegt). Die Antwort auf markierten Text läuft über `GetSelectedHTML`
(`msgdoc.cpp:638`, `TocFrame.cpp:1945`) und ist damit abgedeckt. Die
Textwege (`get_text`, `get_innerText`, etwa `TridentView.cpp:3824` für
Übersetzer-Plug-ins) gehören nicht zu [E-178](../Intern/BEFUNDE.md#e-178). Text kann keine Entität tragen.

### E-179: der Aufrufer `AddText`

`AddText` übergibt `ul` als Ausgabe (`html2text.cpp:1283`). Danach folgen
gemeinsam für alle Entitäten `szText += ul; ulTotalLength -= ul;` und das
Überspringen eines `;` (`:1591-1598`). Die Funktion meldet als verbraucht die
Zeichen bis hinter die letzte Ziffer, **ohne** Semikolon. Im Rückfallweg hängt
sie das Semikolon selbst an (`:1203-1206`). Es steht danach also genau einmal
da (am Quelltext belegt; die Fälle mit und ohne Semikolon deckt
`Test_E179_Funktion` ab, gemessen grün).

| Eingabe | ul | Ausgabe | Rest für den Aufrufer |
|---|---|---|---|
| `&#` am Pufferende (Länge 2) | 2 | `&#` | 0 |
| `&#x;` | 3 | `&#x;` | `;` wird übersprungen |
| `&#00065;` | 7 | `A` | `;` wird übersprungen |
| `&#99999999999;` | 13 | wie Eingabe | `;` wird übersprungen |

Bei langen Zahlen gibt es keinen Überlauf: Gerechnet wird nur, solange
`ulWert <= 0x10FFFF` ist (`:1161`). Der größte Zwischenwert ist
`0x10FFFF·16+15 < 2³²` (am Quelltext belegt). Unverändert alt ist, dass
`:1594` `szText[0]` liest, bevor die Restlänge geprüft ist. Das stand so schon
vorher (Vermutung: harmlos, weil der Puffer mit einem Nullbyte endet).

### E-170: Faden und folgender Abgleich

* **Faden:** `CImapTransferMsgAction::DoPostProcessing` läuft im Hauptfaden.
  `QCTaskManager::DoPostProcessing` verlangt das (`QCTaskManager.cpp:669`) und
  wird aus der Leerlaufschleife gerufen (`eudora.cpp:2674`). Nur `DoWork` läuft
  im Nebenfaden (am Quelltext belegt). `SetLabel` aus dem Hauptfaden ist
  unbedenklich.
* **Folgender Abgleich:** `DoManualResync` → `ImapAppendSumList` sucht zuerst
  eine Zusammenfassung mit der UID (`ImapMailbox.cpp:4999`). Ist eine da, wird
  sie weiterbenutzt, und vom Server wird nichts darüber kopiert. Das gesetzte
  Label bleibt also stehen (am Quelltext belegt).
* **`Copy`:** Wird eine Übertragung offline zurückgestellt, entsteht über
  `Duplicate` eine Kopie (`ImapActionQueue.cpp:621`). Die Kopie nimmt die
  Listen mit. Der `static_cast` ist sicher, weil `Duplicate` immer dieselbe
  Klasse kopiert (am Quelltext belegt).

### E-143: Filterwege und Vergleich

* **`m_Type == MBT_OUT`** ist der richtige Vergleich für die TOC.
  `QCMailboxCommand::GetType() == MBT_OUT` passt im Menü. Es gibt nur ein Out.
* **Schalter bleibt nicht hängen:** Zwischen `SetE143OutSperren(m_bE143OhneOut)`
  und `SetE143OutSperren(FALSE)` steht nur `TrackPopupMenu`
  (`controls.cpp:325-327`). Dort gibt es kein `return`, und eine Ausnahme in
  einem Fensterhandler fängt MFC innerhalb der Menüschleife ab (Vermutung nach
  `AfxCallWndProc`). Selbst wenn der Schalter stehen bliebe, würde das nur
  wirken, solange `m_bTransferMenuBeingUsed` gesetzt ist (`mainfrm.cpp:7982`).
* **`break` in beiden Wegen:** Es verlässt die `while`-Schleife (POP,
  `filtersd.cpp:1555`) bzw. den Block (IMAP, `:2004`), genauso wie das
  vorhandene `if (!pDestToc) break;`. Die übrigen Aktionen desselben Filters
  laufen weiter. Vorher endete der Weg über `Xfer → NULL → Sum = NULL` mit
  `FA_SKIPREST` und `return` (`:1615-1619`). Jetzt bleibt die Nachricht in
  In, und die **folgenden Filter** prüfen sie noch (am Quelltext belegt).
  Das halte ich für richtig, es ist aber eine Verhaltensänderung, die im
  Befund nicht steht. Eine Folge davon steht in [K4](#k4).

---

## <a id="k1"></a>K1 — E-170 ordnet anders zu als `ImapTransferSummaryData`; das Label kann zusätzlich auf eine falsche Mail kommen

**Was passiert (am Quelltext belegt, nicht gemessen).** Die Kette:

1. Die UID-Liste der Übertragung entsteht in der Reihenfolge der übergebenen
   Zusammenfassungen (`ImapToc.cpp:519-555`). Die Liste folgt `m_Sums`, und
   `m_Sums` steht nach dem Sortieren in Anzeigereihenfolge: `CTocView::SortNow`
   schreibt die sortierte Folge mit `SumList.SetAt` zurück (`tocview.cpp:3943`).
2. `StoreUIDPLUSResponses` liest aus `COPYUID` **nur** die Zielmenge
   (`Imapdll/src/proto.cpp:2150`). Die Quellmenge wirft sie weg.
3. `ImapTransferSummaryData` ordnet die i-te UID **der Liste** der i-ten neuen
   UID zu (`ImapToc.cpp:1576`). Sie kopiert die alte Zusammenfassung samt
   Label hinein (`:1622`) und setzt `m_Hash = lNewUID` (`:1632`).
4. `E170LabelsNachtragen` ordnet dagegen **beide Seiten aufsteigend** zu
   (`ImapActionQueue.cpp:1710-1711`). Es setzt nur, wo das Ziel noch kein Label
   hat (`:1729`).

Ist die Liste nicht aufsteigend, etwa in einer Ansicht nach Datum absteigend,
weichen 3 und 4 voneinander ab. Ein Beispiel: A (UID 3, grün) und B (UID 5,
ohne Label), angezeigt als B, A. Der Server vergibt 100 und 101. Schritt 3
gibt der 100 die Daten von B und der 101 die von A samt Grün. Schritt 4 ordnet
3→100 zu, findet dort kein Label und setzt Grün. **Danach tragen beide Mails
Grün.** Vor [E-170](../Intern/BEFUNDE.md#e-170) trug eine der beiden Grün; ob es die richtige war, hing an
Schritt 3.

**Welche Seite stimmt (Vermutung).** Nach RFC 4315 entsprechen sich Quell- und
Zielmenge der Reihe nach. Übliche Server kopieren in der Reihenfolge des
Postfachs, also nach aufsteigender UID. Dann stimmt die Zuordnung von [E-170](../Intern/BEFUNDE.md#e-170),
und `ImapTransferSummaryData` liegt falsch. Das gehört zu [E-184](#e-184). Für
[E-170](../Intern/BEFUNDE.md#e-170) zählt nur: Die beiden Zuordnungen dürfen sich nicht widersprechen.

**Vorschlag.** In `E170LabelsNachtragen` nur setzen, wenn
`m_dwaE170AlteUIDs` schon aufsteigend ist. Dann stimmen beide Zuordnungen
überein. Sonst die Logzeile mit `grund=reihenfolge` schreiben und nichts
setzen. Das sind wenige Zeilen. Die eigentliche Behebung ist [E-184](#e-184).

**Schwere:** wichtig. Ein Label auf einer falschen Mail ist nach dem Befund
selbst „schlimmer als ein fehlendes“. Es tritt nur auf, wenn mehrere Mails
verschoben werden, der Server UIDPLUS kann, die Ansicht nicht nach UID-Folge
sortiert ist und nicht alle Mails dasselbe Label tragen.

---

## <a id="k2"></a>K2 — In Gregors Fall greift E-170 vermutlich nicht; die Ursachenaussage ist noch zu weit

Der Befund nennt zwei Fälle, in denen das Label verloren geht: kein UIDPLUS,
oder die alte Zusammenfassung ist bei der Nachbearbeitung schon fort.

**Der zweite Fall ist im Quelltext kaum erreichbar (am Quelltext belegt).**
`ImapXferOnSameAccount` ruft `ImapRemoveOrderedSubSums(…, TRUE, TRUE)` auf
(`ImapToc.cpp:597`). Der fünfte Parameter ist `bJustSetFlag`. Die
Zusammenfassungen werden damit nur als gelöscht markiert und nicht entfernt
(`ImapToc.cpp:2083-2090`). `DeleteMessagesFromServer` in `DoWork` entfernt
lokal nichts. Die Karte der entfernten UIDs ist eine lokale Variable und wird
nicht ausgewertet (`ImapMailbox.cpp:3731-3732`). Bis zur Nachbearbeitung steht
die alte Zusammenfassung also noch da. Sie fehlt nur, wenn dazwischen ein
Abgleich des Quellordners läuft (Vermutung: möglich, aber selten).

**Folgerung (Vermutung).** Mit UIDPLUS hat schon der Originalweg das Label
mitgenommen, für eine einzelne Mail ohne die Reihenfolgefrage aus [K1](#k1).
Bleibt Gregors Verlust einer einzelnen Mail, dann ist der Server ohne UIDPLUS
am wahrscheinlichsten. Genau dort setzt `E170LabelsNachtragen` nichts und
schreibt `grund=keine-neuen-uids`. Die Behebung würde Gregors Fall dann nicht
ändern.

**Vorschlag.** Vor dem Testschritt am Prüfstand die CAPABILITY von Gregors
Server feststellen. Den Schritt im TESTPLAN so fassen, dass die Logzeile
`E-170 … grund=` mitgelesen wird. Ohne UIDPLUS ist eine echte Behebung nur
über eine andere Zuordnung möglich, zum Beispiel über die Message-ID nach dem
Abgleich. Das wäre eine neue Entscheidung für Gregor.

**Schwere:** wichtig. Es geht um die Erwartung an die Behebung, nicht um
Schaden. Hält das Paket nicht auf.

---

## <a id="e-184"></a>E-184 — `ImapTransferSummaryData` ordnet nach Listenreihenfolge zu und sucht die alte UID im Zielordner (Original von QUALCOMM)

Vorschlag für einen neuen Befund. `befund-suchen.pl ImapTransferSummaryData`
fand nur [E-170](../Intern/BEFUNDE.md#e-170) (01.11.2026).

**Erstens: Zuordnung nach Listenreihenfolge.** Siehe [K1](#k1), Schritte 1-3.
Werden mehrere Mails mit UIDPLUS verschoben und ist die Ansicht nicht nach
UID-Folge sortiert, bekommt eine neue Zusammenfassung die Daten einer anderen
Mail (Betreff, Absender, Label, Junk-Wert). Beim folgenden Abgleich wird sie
weiterbenutzt und nicht vom Server erneuert (`ImapMailbox.cpp:4999`, am
Quelltext belegt). Das Ergebnis wäre ein Eintrag mit dem Kopf von Mail A, der
auf den Inhalt von Mail B zeigt (Vermutung, nicht gemessen).

**Zweitens: Suche nach der alten UID im Ziel.** Mit `bFindNew = true` (so ruft
`DoPostProcessing` auf, `ImapActionQueue.cpp:1610-1614`) sucht die Funktion
`pTargetToc->GetSummaryFromUID(lOldUID)` (`ImapToc.cpp:1580`), also die
**Quell**-UID im **Zielordner**. UIDs gelten aber je Postfach. Hat der
Zielordner zufällig eine fremde Mail X mit derselben Nummer, wird X
überschrieben (`:1622`), und ihre UID wird auf die neue gesetzt (`:1632`).
Beim Weg innerhalb eines Kontos legt niemand vorher eine Zusammenfassung mit
der alten UID im Ziel an, `pSumNew` bleibt dort `NULL` (`ImapToc.cpp:497`,
`:609`). Ein Treffer ist also immer eine fremde Mail (am Quelltext belegt).
Wie oft das vorkommt, hängt am Server: Bei kleinen Ordnern, deren UIDs bei 1
beginnen, ist es häufig (Vermutung). Für [E-170](../Intern/BEFUNDE.md#e-170) heißt das: Fehlt die alte
Zusammenfassung ([K2](#k2)), setzt `E170LabelsNachtragen` das Label auf X.

**Einordnung.** Der Fehler ist alt und keine Regression; er steht so im
Original. Er hält das Paket nicht auf. Am IMAP-Prüfserver lässt er sich
nachstellen: im Ziel eine Mail mit derselben UID-Nummer, dann verschieben,
danach Betreff und Inhalt vergleichen. **Stufe (Vorschlag): wichtig.** Eine
fremde Zusammenfassung wird still überschrieben; auf dem Server geht nichts
verloren.

---

## <a id="k3"></a>K3 — E-143: Out wird vermutlich in keinem der beiden Fenster ausgegraut

**Die Gegenvermutung „läuft `OnUpdateDynamicCommand` überhaupt?“ trifft zu**
(am Quelltext belegt an Eudora und am MFC-Quelltext von VS 2022; am Programm
nicht gemessen).

Beim Aufklappen schickt `TrackPopupMenu(…, pMainFrame)` die Nachricht
`WM_INITMENUPOPUP` an das Hauptfenster. `CFrameWnd::OnInitMenuPopup` ruft je
Eintrag `CCmdUI::DoUpdate(this, …)` auf (`atlmfc/src/mfc/winfrm.cpp:1519`).
Damit läuft die Anfrage durch `CMainFrame::OnCmdMsg`. Der **erste** Handler,
der nicht `ContinueRouting()` ruft, beendet die Weiterleitung
(`cmdtarg.cpp:151`). Der neue Code im eigenen Handler des Hauptfensters
(`mainfrm.cpp:7989-7995`) kommt erst ganz am Ende dran.

* **Filterfenster:** `CMainFrame::OnCmdMsg` gibt zuerst an das Wazoo-Fenster
  mit dem Fokus weiter (`mainfrm.cpp:3591-3597`). `CFiltersWazooWnd::OnCmdMsg`
  reicht an den aktiven Teil des Splitters weiter (`FiltersWazooWnd.cpp:95-102`).
  Nach dem Klick auf den Postfachknopf ist das `CFiltersViewRight`
  (`CView::OnMouseActivate` setzt die Ansicht aktiv;
  `CSplitterWnd::GetActivePane`, `winsplit.cpp:2320-2338`). Dessen
  Message-Map leitet den ganzen Bereich auf
  `CMailboxButton::OnUpdateDynamicCommand` (`filtersv.cpp:2169`). Dieser
  Handler macht für `CA_TRANSFER_TO` nur `Enable(TRUE); return;`
  (`controls.cpp:439-442`). Out ist damit **eingeschaltet**, und der Weg ist
  zu Ende.
* **Make Filter** (modaler Dialog): Hier hat kein Wazoo den Fokus. Weiter geht
  es an das aktive MDI-Fenster, meist das Postfach mit der markierten Mail.
  `CTocFrame::OnUpdateDynamicCommand` gibt für `CA_TRANSFER_TO`
  `Enable(GetSelCount() > 0)` zurück (`TocFrame.cpp:2523-2530`). Auch das
  schaltet Out ein. Ähnlich verhalten sich `ReadMessageFrame` und `msgdoc`.

Das Hauptfenster kommt nur dran, wenn keiner davor den Befehl beansprucht,
etwa ohne offenes Fenster. Der vorhandene Zweig
`if (m_bTransferMenuBeingUsed) return;` von QUALCOMM wirkt genau in diesem
Restfall (Vermutung zur Absicht).

**Folge.** Gregors Entscheidung „Out nicht anbieten“ ist vermutlich nicht
umgesetzt: Out bleibt wählbar. Der Schaden aus [E-143](../Intern/BEFUNDE.md#e-143) bleibt trotzdem aus.
Ein Filter mit Ziel Out wird übergangen und schreibt seine Logzeile; der Abruf
hält nicht. `TestE143.cpp` prüft nur, dass die Zeilen dastehen. Die
Weiterleitung kann es nicht sehen.

**Vorschlag.** Die Entscheidung nach der Auswahl absichern, unabhängig von
der Weiterleitung. In `CMailboxButton::SelectMailbox` nach `TrackPopupMenu`
prüfen: Ist `m_bE143OhneOut` gesetzt und hat der gewählte Befehl den Typ
`MBT_OUT`, wird die Wahl verworfen (wie Abbrechen, mit Hinweis). Zusätzlich
den Typ-Vergleich in `CMailboxButton::OnUpdateDynamicCommand` einbauen. Dann
ist Out wenigstens im Filterfenster grau, denn der Handler gehört der
Filteransicht.

**Schwere:** wichtig (Entscheidung nicht umgesetzt; kein Datenschaden).
**Hält das Paket auf: ja.** Der Testschritt „Out ist grau“ würde fehlschlagen,
und die Abhilfe ist klein.

---

## <a id="k4"></a>K4 — E-143, POP-Weg: Nach dem Übergehen bleibt `pDestToc` auf Out

Im POP-Weg ist `pDestToc = GetToc(mboxPath)` vor der Prüfung schon gesetzt
(`filtersd.cpp:1543`), und das `break` lässt es auf Out stehen. Danach gilt
`bDidFiltAction` (`:1508`), und `pDestToc` ist nicht NULL. Damit kommt Out in
`m_FilterOpenMBoxTocList`, wenn „Postfach öffnen“ eingestellt ist
(`:1701-1707`). Je nach `m_NotfyUserNR` kommt es auch in den Filterbericht
(`:1667-1671`; die Klammern dort lassen den zweiten Teil allein gelten). Im
IMAP-Weg steht `*ppDestToc = DestToc` hinter der Prüfung (`:2007-2010`), dort
passiert das nicht (alles am Quelltext belegt).

**Folge (Vermutung).** Nach dem Abruf öffnet sich das Fenster Out, oder Out
steht im Filterbericht, obwohl nichts übertragen wurde.

**Vorschlag.** Vor dem `break` im POP-Weg `pDestToc = NULL;` setzen. Dann
übernimmt `:1652-1655` den Ordner, in dem die Nachricht wirklich liegt, wie
im IMAP-Weg.

**Schwere:** niedrig. Hält das Paket nicht auf.

---

## <a id="k5"></a>K5 — Wofür die neuen Tests blind sind (vier Gegenproben, gemessen)

| Gegenprobe | Änderung (je 1 Ersatz) | Ergebnis | Folge im Programm |
|---|---|---|---|
| G1 ([E-178](../Intern/BEFUNDE.md#e-178)) | `TridentReadMessageView.cpp:4069` (WrapTag): hinter die Umwandlung `szText = CString( cbstr );` gesetzt | **355/355, Rückgabe 0** | Emoji werden beim Einschalten einer Formatierung wieder zu `??` (Vermutung nach dem Quelltext) |
| G2 ([E-179](../Intern/BEFUNDE.md#e-179)) | `html2text.cpp:1137`: nur noch `'x'`, kein `'X'` | **355/355, Rückgabe 0** | `&#XFC;` bleibt als Text stehen statt `ü` (am Quelltext belegt; kein Verlust) |
| G3 ([E-170](../Intern/BEFUNDE.md#e-170)) | `ImapActionQueue.cpp:1699`: `nNeu != nAlt` → `nNeu < nAlt` | **355/355, Rückgabe 0** | Bei mehr neuen als alten UIDs wird trotzdem zugeordnet, Label auf falscher Mail möglich |
| G4 ([E-143](../Intern/BEFUNDE.md#e-143)) | `filtersd.cpp:1555`: `break;` hinter der E-143-Logzeile entfernt | **355/355, Rückgabe 0** | Der Filter schreibt die Logzeile und ruft danach doch `Xfer` nach Out auf. Der modale Hinweis hält den Abruf wieder an |

Nach jeder Gegenprobe: `git checkout -- <datei>`, `git diff --quiet` leer
(gemessen).

**Warum.**

* G1: `Test_E178_Stelle` zählt `=cbstr;` und die Zahl der Aufrufe von
  `E136HtmlAusBstr`. Eine **zusätzliche** verlustbehaftete Zuweisung in anderer
  Schreibweise (`CString( cbstr )`, `(LPCTSTR)`) ändert keine der beiden
  Zahlen. Wird eine Umwandlung **ersetzt**, sinkt die Zahl der Aufrufe, und der
  Test wird rot. Das hält.
* G2: Die Fälle haben nur kleines `x`.
* G3: Geprüft wird nur, dass der Text `"anzahl-passt-nicht"` dasteht, nicht
  die Bedingung davor. Ebenso fehlt eine Prüfung für
  `m_dwaE170AlteUIDs.Copy` beim Einreihen (`ImapToc.cpp:587`). Fehlt sie,
  bleibt `nAlt = 0`, und es wird still nichts gesetzt.
* G4: `TestE143.cpp` sucht `->m_Type == MBT_OUT)` und die Logzeile vor
  `->Xfer(`, nicht das `break` dahinter. Im IMAP-Weg gibt es kein `->Xfer(`
  in derselben Form, also auch keine Reihenfolgeprüfung.

Dass `Test_E179_Funktion` die frisch geschnittene Funktion prüft, habe ich
hier nicht eigens gemessen. [PRÜFER-70](PRUEFER-70.md) hat den Neubau des
Extrakts gemessen (Vermutung: unverändert).

**Vorschlag.** G4 zuerst: In `TestE143.cpp` nach der Logzeile das nächste
`break;` verlangen, bevor eine andere Anweisung kommt. Für G3 die Zeile
`else if (nNeu != nAlt` wörtlich prüfen und die Übergabe der alten UIDs. Für
G1 je Funktion zusätzlich `CString(cbstr` und `(LPCTSTR)cbstr` zählen (ohne
Leerraum). Für G2 einen Fall `&#XFC;`.

**Schwere:** niedrig (nur Tests), G4 mittel. Hält das Paket nicht auf.

---

## <a id="k6"></a>K6 — E-179: Die neue Funktion steht mitten im Kopfkommentar von `AddText`

`E179ZeichenAusNummer` ist zwischen den Kopfkommentar von
`CHtml2Text::AddText` (`html2text.cpp:1090-1102`, „Outputs text to the rich
edit control …“) und `AddText` selbst eingefügt (`:1103-1208`). Wer liest,
hält den Kommentar von `AddText` für den der neuen Funktion. Schaden entsteht
nicht (am Quelltext belegt).

**Vorschlag.** Die Funktion samt ihrem Kommentar über den
`///`-Block von `AddText` verschieben. Das hat Zeit bis zur nächsten
Gelegenheit; **Schwere:** kosmetisch.

---

## Neue Kennungen

* **[E-184](#e-184)** — [oben](#e-184): `ImapTransferSummaryData` ordnet nach
  Listenreihenfolge zu und sucht die alte UID im Zielordner (Original).
* **E-185** bleibt frei.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | [E-178](../Intern/BEFUNDE.md#e-178): Schnitt des Start-Tags hält, alle neun Stellen sind HTML, keine fehlt. [E-179](../Intern/BEFUNDE.md#e-179): Aufrufer, `;`, Pufferende, lange Zahlen halten. [E-170](../Intern/BEFUNDE.md#e-170): Hauptfaden, Abgleich behält das Label. 355/355 im Grund- und Schlusslauf (gemessen). | keine | nein |
| [K1](#k1) | [E-170](../Intern/BEFUNDE.md#e-170) ordnet aufsteigend zu, `ImapTransferSummaryData` in Anzeigereihenfolge. Bei mehreren Mails in anders sortierter Ansicht bekommt eine falsche Mail das Label zusätzlich. | wichtig | empfohlen: Schranke „nur bei aufsteigender Liste“ vorher (wenige Zeilen) |
| [K2](#k2) | Der Fall „alte Zusammenfassung fort“ ist kaum erreichbar. Gregors Fall ist vermutlich „kein UIDPLUS“, und dort setzt [E-170](../Intern/BEFUNDE.md#e-170) nichts. | wichtig (Erwartung) | nein, aber TESTPLAN-Erwartung anpassen |
| [E-184](#e-184) | Original: Zuordnung nach Listenreihenfolge, Suche der Quell-UID im Zielordner überschreibt eine fremde Zusammenfassung. | wichtig (Vorschlag) | nein (alt) |
| [K3](#k3) | [E-143](../Intern/BEFUNDE.md#e-143): Das Ausgrauen von Out erreicht den Handler im Hauptfenster vermutlich nie. Filteransicht bzw. Postfachfenster schalten Out vorher ein. Das Übergehen im Filter wirkt. | wichtig | **ja** (Testschritt würde fehlschlagen; Abhilfe klein) |
| [K4](#k4) | [E-143](../Intern/BEFUNDE.md#e-143), POP-Weg: `pDestToc` bleibt auf Out, „Postfach öffnen“/Bericht nennen Out. | niedrig | nein |
| [K5](#k5) | Tests blind für vier Rückfälle (gemessen 355/355): zusätzliche Verlustzuweisung ([E-178](../Intern/BEFUNDE.md#e-178)), `&#X` ([E-179](../Intern/BEFUNDE.md#e-179)), Anzahlbedingung ([E-170](../Intern/BEFUNDE.md#e-170)), fehlendes `break` ([E-143](../Intern/BEFUNDE.md#e-143), der Dialog käme zurück). | niedrig, G4 mittel | nein |
| [K6](#k6) | E-179-Funktion steht im Kopfkommentar von `AddText`. | kosmetisch | nein |
