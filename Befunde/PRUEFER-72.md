# <a id="pruefer-72"></a>PRUEFER-72 — Nachlauf: Einarbeitung von PRUEFER-71, 01.11.2026

**Auftrag.** Geprüft habe ich `git show 2fdb12a7 -- Eudora71`, die
Einarbeitung meiner Funde aus [PRÜFER-71](PRUEFER-71.md). Gefragt war nach
[K3](PRUEFER-71.md#k3) und [K4](PRUEFER-71.md#k4) zu [E-143](../Intern/BEFUNDE.md#e-143),
nach [K1](PRUEFER-71.md#k1) zu [E-170](../Intern/BEFUNDE.md#e-170) und nach den Tests
`TestE143.cpp`, `TestE170.cpp` und `TestE179.cpp`.

Eudora habe ich weder gebaut noch gestartet. Gefahren habe ich nur die
Testsuite im Arbeitsbaum `.wt/pruefer` (`perl tools/pruefe-tests-gruen.pl`).
Grundlauf: **355 Tests, 355 bestanden, Rückgabe 0** (gemessen). Für vier
Gegenproben habe ich je eine Quelldatei vorübergehend per Perl geändert
(`:raw`, je genau ein Treffer). Danach habe ich sie mit `git checkout -- <datei>`
wiederhergestellt; `git diff --quiet` war jedes Mal leer. Der Schlusslauf war
wieder 355/355 mit Rückgabe 0 (gemessen).

Jede Aussage trägt ihre Herkunft: **gemessen**, **am Quelltext belegt**
(Datei:Zeile) oder **Vermutung**. Zeilen beziehen sich auf `2fdb12a7`.

**Ergebnis vorweg.**

* **Das Filterfenster und Make Filter aus dem Postfachfenster sind jetzt
  abgedeckt.** Das prüft der Testschritt im TESTPLAN, und dort sollte Out nun
  grau sein (am Quelltext belegt; ob es wirklich grau erscheint, ist nicht
  gemessen).
* **Ein Weg fehlt:** [K1](#k1). Make Filter gibt es auch im **geöffneten
  Nachrichtenfenster**. Dort gibt `CMessageDoc::OnUpdateDynamicCommand` den
  Transfer-Eintrag frei, ohne zu fragen. Out ist dort also weiter wählbar. Die
  neue Sicherung in `SelectMailbox` verwirft die Wahl dann ohne jede Meldung,
  nur mit einer Zeile im Log. Es entsteht kein Dialog, und es geht nichts
  verloren. Die Abhilfe sind sechs Zeilen, gleich gebaut wie in `CTocFrame`.
* **Die Sicherung in `SelectMailbox` greift unabhängig davon, ob mit Maus oder
  Tastatur gewählt wurde.** Sie prüft das Ergebnis nach dem Menü. Das
  Hauptmenü *Transfer* bleibt unberührt (beides am Quelltext belegt).
* **K4 ist sicher.** Nach `pDestToc = NULL` nimmt der Code das Postfach der
  Nachricht, also *In*. Jeder spätere Zugriff ist durch `if (pDestToc)`
  geschützt. Folge: Bericht und „Postfach öffnen“ nennen jetzt *In* statt Out
  ([K2](#k2), niedrig).
* **Die K1-Schranke zu [E-170](../Intern/BEFUNDE.md#e-170) ist richtig herum.** Eine einzelne Mail
  (Gregors Fall) geht immer durch (am Quelltext belegt).
* **Die Tests sind für zwei Rückfälle blind** (gemessen, [K3](#k3)): eine
  umgedrehte Reihenfolgeschranke und eine wirkungslose Sicherung in
  `SelectMailbox`. Zwei weitere Gegenproben wurden wie erwartet rot.
* **Kein Fund hält das nächste Testpaket auf.** [K1](#k1) empfehle ich vor dem
  Schnüren zu beheben, weil die Abhilfe klein ist. Der TESTPLAN-Schritt prüft
  das Nachrichtenfenster nicht.

---

## <a id="haelt"></a>Was hält

### E-143: die drei Handler, die jetzt fragen

Das Menü öffnet `CMailboxButton::SelectMailbox` mit
`TrackPopupMenu(TPM_RETURNCMD, …, pMainFrame)` (`controls.cpp:326`). Die
Freigabe der Einträge läuft deshalb über `CMainFrame::OnCmdMsg`
(`mainfrm.cpp:3586-3633`). Der Befehl geht zuerst an ein Wazoo-Fenster mit
Fokus, sonst an das aktive MDI-Kind und erst danach an das Hauptfenster. Der
erste Handler, der nicht `ContinueRouting` ruft, entscheidet (MFC; am
Quelltext belegt).

* **Filterfenster:** Der Fokus liegt auf der Schaltfläche im Wazoo. Die
  Freigabe läuft über die Nachrichtentabelle von `CFiltersViewRight`
  (`filtersv.cpp:2169`) zu `CMailboxButton::OnUpdateDynamicCommand`. Diese
  fragt jetzt zuerst `E143OutGesperrt` (`controls.cpp:448-452`). Die Funktion
  wird dort mit einem fremden `this` gerufen, greift aber auf kein Mitglied zu
  (am Quelltext belegt). Dass der Fokus beim Aufklappen noch im Wazoo liegt,
  ist eine **Vermutung**.
* **Make Filter aus dem Postfachfenster:** Aktiv ist der `CTocFrame`. Weder
  `CTocView` noch die Vorschau noch `CTocDoc` haben einen Handler für den
  Bereich `QC_FIRST_COMMAND_ID…`. Die Vorschau hängt am `CTocDoc`
  (`TocFrame.cpp:304`). Nur `CPaigeEdtView` hat einen Handler, und der leitet
  alles außer Emoticons weiter (`PaigeEdtView.cpp:7508-7525`). Also entscheidet
  `CTocFrame::OnUpdateDynamicCommand`, und der fragt jetzt
  (`TocFrame.cpp:2529-2533`). Alles am Quelltext belegt.
* **Hauptfenster:** Die Bedingung ist nur in `E143OutGesperrt` ausgelagert
  (`mainfrm.cpp:7986-7989`, Aufruf `:8009`). Sie ist gleichwertig mit der
  alten Fassung (am Quelltext belegt).

### Die Sicherung in `SelectMailbox`, auch bei Wahl per Tastatur

Die Sicherung (`controls.cpp:335-339`) prüft den Befehl, den
`g_theCommandStack.GetSavedCommand` nach der Rückkehr von `TrackPopupMenu`
liefert. Auf welchem Weg der Eintrag gewählt wurde, spielt dafür keine Rolle
(am Quelltext belegt). Einen grauen Eintrag gibt Windows weder bei Mausklick
noch bei Enter als Ergebnis zurück (**Vermutung**, Windows-Verhalten, nicht
gemessen). Nach `pCommand = NULL` folgt kein `OnNewMailbox`, denn Out kommt
mit `CA_TRANSFER_TO`. `if (pCommand)` überspringt dann die Übernahme. Die
Schaltfläche behält ihr bisheriges Postfach, und `SelectMailbox` liefert
FALSE (am Quelltext belegt).

### Das Hauptmenü *Transfer* bleibt unberührt

`m_bE143OutSperren` wird nur um das Menü herum gesetzt und gleich danach
zurückgenommen (`controls.cpp:325` und `:327`). `E143OutGesperrt` verlangt
dieses Merkmal (`mainfrm.cpp:7988`). Öffnet man *Transfer* aus dem Hauptmenü,
ist es FALSE. Beide neuen Abfragen in `CTocFrame` und `CMailboxButton` liefern
dann nichts, und der alte Weg läuft unverändert (am Quelltext belegt).

### E-170: die Reihenfolgeschranke

`E170Aufsteigend_Ist` (`ImapActionQueue.cpp:1675-1683`) liefert FALSE, sobald
ein Nachbarpaar nicht streng aufsteigt (`>=`). Bei einer absteigenden oder
gemischten Liste wird also nicht zugeordnet. Das ist richtig herum. Die alte
Liste entsteht in der Reihenfolge der Auswahl (`ImapToc.cpp:538`, übergeben
`:587`). Sie wird vor der Prüfung nirgends sortiert, denn sortiert werden nur
die Kopien in `:1726-1729`. Eine einzelne Mail hat ein Element, die Schleife
läuft nicht, das Ergebnis ist TRUE: **Gregors Fall bleibt unberührt.** Alles am
Quelltext belegt. Dass auch die neuen UIDs vom Server aufsteigend kommen,
sobald die alten aufsteigen, ist eine **Vermutung**. RFC 4315 lässt die
Zuordnung über die Reihenfolge zu, und Server vergeben UIDs aufsteigend.

### Tests: zwei Gegenproben rot

* **Frage in `CTocFrame` entfernt** (`if (FALSE)` statt `E143OutGesperrt`):
  354/355, rot ist „[E-143](../Intern/BEFUNDE.md#e-143) (Quelltext)“ (gemessen).
* **Großes `X` in `E179ZeichenAusNummer` entfernt** (`html2text.cpp:1137`):
  354/355, rot ist „[E-179](../Intern/BEFUNDE.md#e-179) (Funktion)“ (gemessen). Damit ist auch gemessen, was
  PRÜFER-71 nur vermutete: Das Extrakt wird bei jedem Bau neu aus der Quelle
  geschnitten.

---

## <a id="k1"></a>K1 — E-143: Make Filter aus dem Nachrichtenfenster bietet Out weiter an

**Was passiert.** Make Filter gibt es auch im geöffneten Nachrichtenfenster
(`msgdoc.cpp:506`, `CMessageDoc::OnMakeFilter` `:1331-1339`). Klickt man dort
im Dialog auf die Postfach-Schaltfläche, ist das aktive MDI-Kind der
`CReadMessageFrame`. Die Freigabe läuft so (am Quelltext belegt):

1. `CReadMessageFrame::OnCmdMsg` gibt an `CMessageFrame::OnCmdMsg` weiter
   (`ReadMessageFrame.cpp:785-787`) und damit an die aktive Ansicht und deren
   Dokument.
2. `CReadMessageDoc::OnUpdateDynamicCommand` behandelt Transfer nicht und ruft
   die Basisklasse (`ReadMessageDoc.cpp:185`).
3. `CMessageDoc::OnUpdateDynamicCommand` ruft bei `CA_TRANSFER_TO`
   `pCmdUI->Enable( TRUE ); return;` (`msgdoc.cpp:1517-1521`), **ohne
   `E143OutGesperrt` zu fragen.**

Das Hauptfenster kommt also nicht dran, und **Out ist nicht grau**. Wählt der
Anwender Out, verwirft die Sicherung die Wahl (`controls.cpp:335-339`). Die
Schaltfläche ändert sich nicht, es erscheint keine Meldung, nur die Logzeile
`E-143 Postfachauswahl fuer einen Filter: Out verworfen`. Es entsteht kein
Filter mit Ziel Out, kein Dialog und kein Datenverlust. Ob Out im laufenden
Programm wirklich weiß erscheint, habe ich nicht gemessen (**Vermutung** aus
der Weiterleitung).

Gregors Entscheidung lautet „Out nicht anbieten“. Auf diesem Weg wird es
angeboten, und die Wahl verpufft still. Für den Anwender sieht das wie ein
Fehler aus.

**Weitere Fenster.** Andere Aufrufer von Make Filter gibt es nicht. Nur
`TocFrame.cpp:253` und `msgdoc.cpp:506` binden `ID_SPECIAL_MAKE_FILTER` (am
Quelltext belegt). Weil `CCompMessageDoc` von `CMessageDoc` erbt, gälte die
Abhilfe auch dort, falls Make Filter dort überhaupt erreichbar ist (nicht
geprüft).

**Vorschlag.** In `CMessageDoc::OnUpdateDynamicCommand` vor
`pCmdUI->Enable( TRUE )` dieselbe Abfrage wie in `TocFrame.cpp:2529-2533`
einfügen und in `TestE143.cpp` einen vierten `PruefeImAbschnitt` für
`msgdoc.cpp` ergänzen.

**Schwere:** mittel. **Hält das Paket auf:** nein. Der TESTPLAN-Schritt
(`Intern/TESTPLAN.md`, Abschnitt [E-143](../Intern/BEFUNDE.md#e-143)) prüft nur das Filterfenster. Ich
empfehle die Behebung trotzdem vor dem Schnüren, weil sie sechs Zeilen kostet.

---

## <a id="k2"></a>K2 — E-143/K4: Nach dem Übergehen nennen Bericht und „Postfach öffnen“ *In*

`pDestToc = NULL` (`filtersd.cpp:1555`) steht vor dem `break`. Nach der
Schleife setzt `if (Sum && !pDestToc) pDestToc = Sum->m_TheToc;`
(`:1665-1667`) das Postfach der Nachricht ein, im Abruf also *In*. Alle
späteren Zugriffe stehen unter `if (pDestToc)` (`:1675`). **Ein Absturz ist
damit ausgeschlossen** (am Quelltext belegt).

`bDidFiltAction` und `bDidMoveAction` bleiben aber gesetzt (`:1509-1510`).
Ist am Filter der eigene Bericht eingeschaltet, kommt *In* in den
Filterbericht (`:1677-1680`, zweiter Zweig der Bedingung, ohne Typprüfung).
Bei „Postfach öffnen“ wird *In* geöffnet (`:1700-1717`). Weil die Mail
tatsächlich in *In* liegt, ist das richtiger als vorher, als Out genannt
wurde. Ein Bericht „gefiltert nach In“ für einen übergangenen Filter ist
allerdings ungenau (am Quelltext belegt).

**Schwere:** niedrig. **Hält das Paket auf:** nein. Wer es genau will, setzt
im Out-Zweig zusätzlich `bDidMoveAction = false`.

---

## <a id="k3"></a>K3 — Tests: zwei Rückfälle bleiben grün

* **Sicherung wirkungslos:** In `controls.cpp:338` die Zeile
  `pCommand = NULL;` entfernt. Ergebnis: **355/355, Rückgabe 0** (gemessen).
  `TestE143.cpp` sucht nur die Bedingung
  `if (m_bE143OhneOut && CMainFrame::E143IstOut(pCommand))`, nicht ihre
  Wirkung.
* **Reihenfolgeschranke umgedreht:** In `ImapActionQueue.cpp:1679` stand
  danach `<` statt `>=`. Ergebnis: **355/355, Rückgabe 0** (gemessen). Die
  Schranke ließe dann genau die gefährlichen absteigenden Listen durch und
  sperrte die sicheren. `TestE170.cpp` prüft nur den Aufruf
  `else if (!E170Aufsteigend_Ist(m_dwaE170AlteUIDs))`, nicht den Rumpf.

**Vorschlag.** In `TestE170.cpp` den Rumpf wörtlich verlangen:
`if (a.GetAt(i - 1) >= a.GetAt(i)) return FALSE;`. In `TestE143.cpp` die
Prüfung auf
`if (m_bE143OhneOut && CMainFrame::E143IstOut(pCommand)) { PutDebugLog(…); pCommand = NULL; }`
ausweiten, also mit Folgeanweisung.

**Schwere:** niedrig (nur Tests). **Hält das Paket auf:** nein.

---

## Neue Kennungen

Keine. **E-186** und **E-187** bleiben frei. [K1](#k1) gehört zu
[E-143](../Intern/BEFUNDE.md#e-143) und ist dort fortzuschreiben.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | Filterfenster, Make Filter aus dem Postfachfenster und Hauptfenster fragen `E143OutGesperrt`. Die Sicherung greift unabhängig vom Eingabeweg, das Hauptmenü *Transfer* ist unberührt. Die [E-170](../Intern/BEFUNDE.md#e-170)-Schranke ist richtig herum, eine einzelne Mail geht durch. Zwei Gegenproben rot, 355/355 im Grund- und Schlusslauf (gemessen). | keine | nein |
| [K1](#k1) | Make Filter aus dem **Nachrichtenfenster**: `CMessageDoc::OnUpdateDynamicCommand` (`msgdoc.cpp:1517-1521`) gibt Out frei. Die Wahl verpufft still, nur eine Logzeile. | mittel | nein (TESTPLAN prüft den Weg nicht); Behebung vor dem Schnüren empfohlen, 6 Zeilen |
| [K2](#k2) | Nach dem Übergehen nennen Filterbericht und „Postfach öffnen“ *In*. Kein Absturz, alle Zugriffe geschützt. | niedrig | nein |
| [K3](#k3) | Tests blind (gemessen 355/355): umgedrehte Reihenfolgeschranke, fehlendes `pCommand = NULL`. | niedrig | nein |
