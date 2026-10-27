# <a id="pruefer-62"></a>PRUEFER-62 — E-137 fünfter Anlauf, Prüfstandsfall E-137a–c und E-160-Nachtrag, nachgerechnet, 27.10.2026

**Auftrag.** Geprüft wurde, was `git log 120e09f5..HEAD -- Eudora71 tools`
auf `0.125_ergebnisse` zeigt. Im Kern sind das zwei Commits.
`5ab3e4ea` bringt den fünften Anlauf zu [E-137](../Intern/BEFUNDE.md#e-137)
(`eudora.cpp`, `mainfrm.cpp`, `WazooBarMgr.cpp`, `TestE137.cpp`) und
ergänzt [E-160](../Intern/BEFUNDE.md#e-160) für Outlook 2013 und neuer
(`OLImportClass.cpp`, `TestE160.cpp`). `651a3b97` bringt den neuen
Prüfstandsfall (`tools/messen-e137.ps1`, Fälle E-137a bis E-137c in
`tools/pruefstand-faelle.txt`). Die Fragen stellte der Auftraggeber. Mein
Vorgängerbericht ist [PRUEFER-61](PRUEFER-61.md#pruefer-61); dessen K1 ist
die Ursache, auf die dieser Anlauf antwortet.

Eudora wurde weder gebaut noch gestartet. Kein Prüfstand lief. Die
Testsuite lief nur in meinem Arbeitsbaum, einmal unverändert und einmal als
Gegenprobe. Die MFC-Stellen stammen aus der Quelle auf diesem Rechner
(`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Der neue Weg trifft Gregors Fall. Antwort: ja.** Ein echter Klick auf
  die Titelzeile oder den Rand des schwebenden Filterfensters läuft durch
  `CEudoraApp::PreTranslateMessage`, **bevor** MFC die Zieh-Schleife
  startet. Strg+W aus einer Mail kommt als `ID_FILE_CLOSE` in
  `CMainFrame::OnCommand` an. Beides ist an der MFC-Quelle belegt, am
  laufenden Programm aber erst mit Gregors V1 gemessen. Auch der angedockte
  Fall V3 ist abgedeckt.
* **Aber der neue Weg trifft auch Fälle, die er nicht treffen soll**
  ([K1](#k1)). Ein Beispiel: Gregor öffnet ein Postfach mit Doppelklick im
  Fenster *Mailboxes* und drückt dann Strg+W. Dann verschwindet
  vermutlich die *Mailboxes*-Leiste, und das Postfach bleibt offen. Erst ein
  zweites Strg+W schließt das Postfach. Der Grund: Die Marke „zuletzt in diese
  Leiste geklickt“ bleibt stehen, wenn der Fokus ohne weiteren Klick in ein
  neues Fenster wandert. Es geht nichts verloren. Aber ein alltäglicher
  Handgriff geht anders aus als vorher. Die Logik ist am Quelltext belegt,
  die Fokuslage nach dem Öffnen ist eine Vermutung. Keiner der Schritte V1
  bis V5 prüft diese Richtung.
* **Der Prüfstandsfall misst die Entscheidung, nicht den Tastaturweg**
  ([K2](#k2), [K3](#k3)). Er schickt `ID_FILE_CLOSE` direkt an das
  Hauptfenster. Ob die Taste W die Marke löscht, sieht er nicht.
  **Gemessen:** Ich habe die Ausnahme für W vorübergehend aus
  `E137EingabeMerken` entfernt. Echtes Strg+W hätte die Marke dann
  gelöscht, und die Mail wäre wieder zugegangen. Trotzdem blieben alle
  314 Tests grün. Auch der Prüfstand wäre grün geblieben, das ist am
  Quelltext belegt. Heute ist der Code richtig. Er ist aber nur durch
  Gregors V1 bewacht.
* **Der Nachtrag zu [E-160](../Intern/BEFUNDE.md#e-160) ist korrekt und vollständig** ([K5](#k5)). Die
  WOW64-Umleitung betrifft `HKCU\Software` nicht. **Gemessen:** Die 32- und
  die 64-Bit-Fassung von `reg.exe` sehen unter
  `HKCU\Software\Microsoft\Office` byte-gleich dasselbe. Unter `HKLM` sehen
  sie dagegen verschiedene Werte.
* **Macht ein Fund Gregors Kurztest an 1.0.126 wertlos? Nein.** V1 bis V3
  prüfen genau den Weg, den der Prüfstand nicht trifft: echter Klick,
  echte Taste, echte Mail. V4 und V5 sind nicht berührt. Es fehlt nur ein
  Gegenschritt für K1 (Vorschlag „V6“ unten).
* **Hält etwas das Paket auf?** Den laufenden Kurztest an 1.0.126 nicht.
  K1 sollte vor 7.2.1 behoben oder von Gregor ausdrücklich hingenommen
  werden.

## Messungen

**Testsuite in meinem Baum** (gemessen): `RunTests.cmd` ergab 314 Tests,
314 bestanden.

**Gegenprobe zur Ausnahme für W** (gemessen). In `mainfrm.cpp` habe ich
vorübergehend `&& pMsg->wParam != 'W'` aus `E137EingabeMerken` entfernt
(eine Ersetzung, per Perl byte-genau). Das Ergebnis waren 314 Tests, 314
bestanden. Alle vier E-137-Tests stehen auf `[ok]`. Danach habe ich die
Datei aus der Sicherung zurückgeschrieben. Sie ist laut `cmp`
byte-gleich, `git diff` ist leer.

**WOW64 und `HKCU`** (gemessen, 27.10.2026, dieser Rechner):

| Abfrage | `System32\reg.exe` (64 Bit) | `SysWOW64\reg.exe` (32 Bit, PE32 i386) |
|---|---|---|
| `HKLM\...\CurrentVersion` `ProgramFilesDir` (Positivprobe) | `C:\Program Files` | `C:\Program Files (x86)` |
| `HKCU\Software\Microsoft\Office /s` | 12 Zeilen | 12 Zeilen, laut `cmp` byte-gleich |
| `HKCU\...\Office\16.0\Outlook\Profiles` | fehlt | fehlt |

Die Positivprobe zeigt, dass der 32-Bit-Prozess wirklich umgeleitet wird.
Unter `HKCU\Software\Microsoft\Office` geschieht das nicht.

## Frage (a) — Kommt ein echter Klick auf Titelzeile oder Rand durch `PreTranslateMessage`, bevor die Zieh-Schleife startet?

**Ja** (am Quelltext belegt, ein Teil Windows-Verhalten):

* Mausnachrichten kommen über die Eingabewarteschlange des Threads. Für
  `WM_NCLBUTTONDOWN` gilt das auch. Windows-Doku, hier nicht gemessen.
* MFC holt sie in `AfxInternalPumpMessage` mit `GetMessage` und ruft
  **vor** `DispatchMessage` `AfxPreTranslateMessage`
  (`thrdcore.cpp:153`, `:178-182`). Das landet in der virtuellen
  `CEudoraApp::PreTranslateMessage`. Dort steht der neue Block als Erstes,
  vor jedem `return` (`eudora.cpp:1906-1915`).
* Erst `DispatchMessage` führt zu `CMiniDockFrameWnd::OnNcLButtonDown`
  (`bardock.cpp:876-918`). Dort folgt `ActivateTopParent` und dann
  `StartDrag` bzw. `StartResize`. Die Zieh-Schleife `CDockContext::Track`
  (`dockcont.cpp:577-637`) hat ein eigenes `GetMessage`. Für die Marke ist das
  belanglos, sie steht dann schon.
* Bei der Aktivierung durch die Maus kann Windows eine Nachricht
  verschlucken, nämlich bei `MA_ACTIVATEANDEAT` oder `MA_NOACTIVATEANDEAT`.
  Das trifft hier nicht zu. `CMiniDockFrameWnd::OnMouseActivate` liefert
  am Rand `MA_NOACTIVATE`, sonst das Ergebnis der Basisklasse
  (`bardock.cpp:791-796`). `CMiniFrameWnd` überschreibt das nicht.
* Wazoo-Leisten tragen `CBRS_SIZE_DYNAMIC` (`WazooBarMgr.cpp:136`, `:233`).
  Deshalb fehlt `MFS_MOVEFRAME` (`bardock.cpp` in `Create`). Ein echter
  Klick auf den Rand liefert also wirklich `HTLEFT` und Verwandte
  (`winmini.cpp:147-166`), nicht `HTCAPTION`.
* Der Rahmen ist ein Fenster der obersten Ebene. `GetAncestor(…, GA_ROOT)`
  liefert für ihn sich selbst, denn es folgt Eltern, nicht Besitzern.
  `GetWazooBarAt` findet ihn deshalb über `GetParentFrame()` der Leiste
  (`WazooBarMgr.cpp:1053-1078`).

## Frage (b) — Kommt Strg+W bei Fokus in einer Mail wirklich in `CMainFrame::OnCommand` an?

**Ja** (am Quelltext belegt):

* `CWinThread::PreTranslateMessage` geht von `pMsg->hwnd` über
  `::GetParent` bis zum Hauptfenster.
* `CTridentView::PreTranslateMessage` (`TridentView.cpp:2641-2783`)
  fängt nur Enter, Pfeiltasten, Umschalt+Leertaste und Alt+Pfeil ab. Strg+W
  reicht es an `CView` weiter. Die Gegenstücke für OLE
  (`CTridentView::TranslateAccelerator` `:783-787`,
  `CImpIDocHostUIHandler::TranslateAccelerator`
  `IDocHostUIHandler.cpp:194-199`) liefern `S_FALSE` und schicken nichts
  anderswohin.
* `CMDIChildWnd::PreTranslateMessage` übersetzt Kürzel ausdrücklich
  **im Kontext des MDI-Rahmens**: `::TranslateAccelerator(GetMDIFrame()->m_hWnd, …)`
  (`winmdi.cpp:460-465`). Dasselbe gilt für
  `CMDIFrameWnd::PreTranslateMessage` (`winmdi.cpp:206-213`). Das
  `WM_COMMAND` geht in beiden Fällen an das Hauptfenster.
* Die Tastentabelle kennt `"W", ID_FILE_CLOSE, VIRTKEY, CONTROL`
  (`EudoraRes.rc:364`). Andere Eudora-Behandler für `ID_FILE_CLOSE`
  (`doc.cpp:109`, `msgdoc.cpp:510`, `workbook.cpp:247`) erreicht der Befehl
  erst über die Befehlsweiterleitung **nach** `CMainFrame::OnCommand`.
* Liegt der Fokus nach einem Klick auf die Titelzeile auf dem schwebenden
  Rahmen selbst, gilt dasselbe. `::GetParent` liefert bei einem
  `WS_POPUP`-Fenster den Besitzer, also das Hauptfenster. Der Rahmen hat
  keine eigene Tastentabelle.
* Die Reihenfolge bei Strg+W stimmt. `WM_KEYDOWN VK_CONTROL` und
  `WM_KEYDOWN 'W'` laufen zuerst durch `E137EingabeMerken`. Beide sind
  ausgenommen (`mainfrm.cpp:3424`). Danach übersetzt dieselbe
  `PreTranslateMessage` den Druck auf W in den Befehl. Ohne die Ausnahme
  würde die Marke genau vor dem Befehl gelöscht. Das bewacht kein Test
  ([K2](#k2)).

## Frage (c) — Kann die Marke stehen bleiben und Strg+W später falsch treffen?

**Ja**, siehe [K1](#k1). Die einzelnen Wege (am Quelltext belegt, soweit
nicht anders gesagt):

| Weg | Wird die Marke gelöscht? |
|---|---|
| Fensterwechsel über das Menü per Maus | ja: der Klick auf die Menüleiste ist `WM_NCLBUTTONDOWN` an das Hauptfenster, `GetWazooBarAt` liefert `NULL` |
| Menü oder Wechsel per Tastatur (Alt, Strg+Tab, Strg+F6) | ja: Alt, Tab und F6 sind keine Ausnahmen |
| Dialoge mit MFC-Schleife (`RunModalLoop` → `AfxPumpMessage`) | ja, der erste Klick oder die erste Taste darin löscht sie |
| Kontextmenü (Rechtsklick in die Leiste) | **nein**: `WM_RBUTTONDOWN` **setzt** die Marke, die Menüschleife läuft an `PreTranslateMessage` vorbei, und der Menüpunkt kann ein Fenster öffnen |
| Klick in eine andere Leiste | ersetzt die Marke durch diese Leiste, wie gewollt |
| Klick in die Mail (Trident) | ja. Die IE-Kontrolle läuft im selben Thread, und `CEudoraApp` sieht den Klick **vor** `CTridentView::PreTranslateMessage`, die Rechtsklicks schluckt |
| **Doppelklick in einer Leiste, der ein MDI-Fenster öffnet** | **nein**: Der erste Klick setzt die Marke. Der Doppelklick (`WM_LBUTTONDBLCLK`) wird nicht ausgewertet. Danach wandert der Fokus ohne weiteren Klick ins neue Fenster |
| Wechsel in ein anderes Programm und zurück über die Taskleiste | **nein**, Eudora sieht dabei keine Taste und keinen Klick |
| Eudora öffnet selbst ein Fenster (neue Post) | **nein** |
| Mausrad, mittlere Taste | **nein**, werden nicht ausgewertet |

In allen Fällen mit „nein“ gilt dasselbe. Strg+W versteckt die gemerkte
Leiste, sofern sie noch sichtbar ist und keine **andere** Leiste den Fokus
hat. Danach ist die Marke verbraucht (`mainfrm.cpp:3481`). Erst das nächste
Strg+W schließt das Fenster. Daten gehen nicht verloren.

## Frage (d) — Fehlzuordnung in `GetWazooBarAt`?

**Nein**, für alle genannten Fälle (am Quelltext belegt):

* **Mehrere schwebende Leisten:** Jede hat ihren eigenen Rahmen. Die
  Wazoo-Leisten setzen kein `CBRS_FLOAT_MULTI`. Die einzigen Fundstellen
  im Eudora-Code sind ein `ASSERT` in `QCChildToolBar.cpp:101-102` und die
  Rahmen-Abfragen in `workbook.cpp`. Ohne diesen Stil lässt MFC keine zweite
  Leiste in einen schwebenden Rahmen.
* **`ID_SEC_MDIFLOAT`:** Diesen Fall gibt es in der Portierung nicht.
  `SECMDIFrameWnd::FloatControlBarInMDIChild` ist ein leerer Rumpf mit
  Spurzeile (`OTShim.cpp:372-377`), und `IsMDIChild` liefert immer `FALSE`
  (`OTShim.cpp:1910-1918`).
* **Versteckte Leisten:** Eine versteckte schwebende Leiste hat einen
  versteckten Rahmen und lässt sich nicht anklicken. Gemerkt wird das
  `HWND` der **Leiste**. `OnCommand` findet sie über den ersten Vergleich
  (`hWnd == Leiste`) wieder und prüft `IsWindowVisible`.
* **`HWND` wird nach dem Zerstören neu vergeben:** Die Marke wird über die
  lebende Liste aufgelöst. Leisten verschwinden aus ihr in einem Schritt
  zusammen mit dem Fenster (`WazooBarMgr.cpp:320-330`, `:339-353`). Ein
  wiederverwendetes `HWND` müsste genau eine Wazoo-Leiste oder deren Kind
  treffen. Vernachlässigbar.
* **Kosten:** Die Liste wird jetzt bei jedem Klick und jeder Taste
  durchlaufen statt nur bei Strg+W, das sind rund zehn Einträge. Kein
  zusätzlicher Zugriff auf freigegebene Objekte, denn
  `GetWazooBarWithFocus` durchläuft dieselbe Liste.

## Frage (e) — Deckt der neue Weg V3 (angedockt, Klick auf eine Beschriftung) ab?

**Ja** (am Quelltext belegt, ein Teil Windows-Verhalten). „Match“ ist ein
`GROUPBOX` (`EudoraRes.rc:590`). Ein Gruppenfeld antwortet auf
`WM_NCHITTEST` mit `HTTRANSPARENT` (Windows-Verhalten, nicht gemessen). Der
Klick geht deshalb an das Formular darunter. Das ist ein Kind der Leiste,
also greift der Zweig `::IsChild(Leiste, hWnd)`. Ein Klick genau auf das
Gruppenfeld würde ebenfalls über `IsChild` greifen. Der Fokus bleibt in der
Mail. `pGeklickt` übernimmt (`mainfrm.cpp:3499-3500`).

## <a id="k1"></a>K1 — Strg+W versteckt eine Leiste, aus der gerade ein Fenster geöffnet wurde

**Was passiert** (Logik am Quelltext belegt, Fokuslage Vermutung). Gregor
doppelklickt im Fenster *Mailboxes* auf ein Postfach. Das Postfach öffnet sich
und wird das aktive Fenster. Dann drückt er Strg+W. Erwartet ist, dass das
Postfach zugeht, so wie in 1.0.125 und im Original. In 1.0.126 verschwindet
stattdessen die ganze *Mailboxes*-Leiste, mit allen Registern, die sie trägt.
Das Postfach bleibt offen. Erst ein zweites Strg+W schließt es.

**Die Kette:**

1. Der erste Klick des Doppelklicks ist `WM_LBUTTONDOWN` im Baum, also ein
   Kind der Leiste. `E137EingabeMerken` setzt die Marke
   (`mainfrm.cpp:3409-3420`).
2. `WM_LBUTTONDBLCLK` wird nicht ausgewertet. `CMboxTreeCtrl::OnLButtonDblClk`
   ruft `Execute(CA_OPEN)` (`mboxtree.cpp:1371-1416`). **Vermutung:** Das
   neue MDI-Fenster wird aktiviert und bekommt den Fokus, wie bei MDI üblich.
3. Strg+W: Der Fokus liegt in keiner Leiste, also ist
   `pFokusLeiste == NULL`. Die Marke zeigt auf die sichtbare
   *Mailboxes*-Leiste. Dann gilt `pFokusLeiste = pGeklickt`, und die Leiste
   wird versteckt (`mainfrm.cpp:3499-3506`).

**Dieselbe Klasse** (Vermutung, nicht einzeln nachgerechnet): jede Leiste,
aus der heraus per Doppelklick oder Kontextmenü ein MDI-Fenster entsteht.
Das sind etwa eine neue Nachricht aus *Stationery* oder *Personalities* und
ein Postfach über Rechtsklick → *Open*. Dazu kommen die anderen Wege mit
„nein“ in der Tabelle zu (c).

**Vor dem fünften Anlauf** ging in diesen Fällen das Fenster zu. Die
Fokusprüfung allein (`GetWazooBarWithFocus`) sah keine Leiste. K1 ist also
eine **neue** Abweichung durch `5ab3e4ea`. Gregor erkennt sie im Protokoll
an `E-137 Strg-W angekommen: leiste-mit-fokus=nein zuletzt-angeklickte-leiste=ja`
und gleich danach `E-137 Strg-W: Wazoo-Leiste wird versteckt`.

**Vorschlag** (ungetestet). Beim Setzen der Marke auch `MDIGetActive()`
merken. In `OnCommand` die Marke nur nehmen, wenn das aktive MDI-Fenster
noch dasselbe ist. Ein Klick auf Titelzeile, Rand oder Beschriftung ändert
das aktive MDI-Fenster nicht, V1 bis V3 bleiben also gedeckt. Jedes Öffnen
oder Wechseln eines Fensters macht die Marke ungültig. Es bleibt ein Rest:
Ein Doppelklick auf ein Postfach, das schon aktiv ist. Zusätzlich die Marke
bei `WM_ACTIVATEAPP` (Verlust) löschen. Dann gilt sie nach einem Ausflug in
ein anderes Programm nicht mehr.

**Gegenschritt für Gregor** (Vorschlag „V6“, gehört in `Intern/TESTPLAN.md`,
nicht hierher): Lokal im Fenster *Mailboxes* ein Postfach doppelklicken,
dann Strg+W. Erwartet: Das Postfach geht zu, die *Mailboxes*-Leiste bleibt.

**Neue Kennung:** E-163 (vorgeschlagen, nicht in BEFUNDE eingetragen):
„Nach einem Klick in eine Wazoo-Leiste versteckt Strg+W diese Leiste, auch
wenn inzwischen ein anderes Fenster aktiv geworden ist, etwa ein per
Doppelklick geöffnetes Postfach.“

**Schwere: mittel.** Nichts geht verloren, aber ein alltäglicher Handgriff
geht anders aus. Die Leiste muss über das Menü *Tools* zurückgeholt werden.
**Hält das Paket auf:** den Kurztest an 1.0.126 nicht. Vor 7.2.1 beheben
oder von Gregor ausdrücklich hinnehmen lassen.

## <a id="k2"></a>K2 — Die Ausnahme für die Taste W ist durch keinen Test bewacht

**Was ist** (gemessen, siehe Messungen). `E137EingabeMerken` löscht die
Marke bei jeder Taste außer Strg, Umschalt und W (`mainfrm.cpp:3422-3426`).
Fehlte die Ausnahme für W, würde echtes Strg+W die Marke löschen, bevor die
Tastentabelle den Befehl erzeugt (siehe (b)). V1 bis V3 schlügen dann fehl.
Die Gegenprobe ohne diese Ausnahme ergab 314 von 314 grün. Der Unit-Test
endet seinen Abschnitt an `m_hE137Leiste = NULL; break; } }` und prüft die
Bedingung davor nicht. Der Prüfstand schickt nie eine Taste ([K3](#k3)).

**Vorschlag.** In `TestE137.cpp` die Zeile
`if (pMsg->wParam != VK_CONTROL && pMsg->wParam != VK_SHIFT && pMsg->wParam != 'W')`
als Ganzes verlangen. Am Prüfstand ist das nicht nachzustellen.
`TranslateAccelerator` liest den Zustand von Strg über `GetKeyState`,
und ein geposteter Tastendruck setzt ihn nicht. Echte Tastendrücke sind
ausgeschlossen (`Arbeitsweise/keine-tastendruecke-verschicken.md`). Den
Tastaturweg misst also nur Gregors V1.

**Schwere: niedrig** (Testlücke, der Code ist heute richtig).
**Hält das Paket auf: nein.**

## <a id="k3"></a>K3 — Was der Prüfstandsfall E-137a–c überspringt

Der Fall stellt Gregors Weg mit geposteten Botschaften nach
(`messen-e137.ps1:209-225`). Gegen den echten Weg fehlen (am Quelltext
belegt):

| Gregors Weg | Prüfstand | Was dadurch ungemessen bleibt |
|---|---|---|
| Klick in eine geöffnete **Mail** (Trident) | Klick in die **Liste des Postfachs In** (`ListBox`) | ob ein Klick in die IE-Kontrolle die Marke löscht. Für das Ergebnis von V1 belanglos, weil die Marke danach ohnehin neu gesetzt wird |
| echter Klick auf die Titelzeile: Treffertest, `WM_MOUSEACTIVATE`, Aktivierung des Rahmens, Fokuswechsel | `WM_NCLBUTTONDOWN` mit fest vorgegebenem `HTCAPTION` oder `HTLEFT`, ohne Aktivierung | wo der Fokus danach liegt. Liegt er in einer **anderen** Leiste, gewinnt diese (`mainfrm.cpp:3499`). Bei V1 ist das ausgeschlossen, weil zuerst in die Mail geklickt wird |
| echte Maustaste, `CDockContext::Track` endet beim echten Loslassen | gepostetes `WM_LBUTTONUP` beendet `Track` (`dockcont.cpp:599-604`) | nichts Wesentliches |
| Strg und W als `WM_KEYDOWN` durch `E137EingabeMerken` und die Tastentabelle | `WM_COMMAND ID_FILE_CLOSE` direkt ans Hauptfenster | die Ausnahme für W ([K2](#k2)) und die Weiterleitung der Kürzel über `WalkPreTranslateTree` (siehe (b)) |
| — | — | die Gegenrichtung: ob Strg+W ein Fenster **schließt**, wenn es soll ([K1](#k1)) |

**Was der Wechsel von Rot nach Grün beweist.** 1.0.125 hatte keinen
Merkmechanismus, deshalb war das Rot dort zwingend. Das Grün an 1.0.126
belegt Folgendes am laufenden Programm: Ein `WM_NCLBUTTONDOWN` an den
schwebenden Rahmen erreicht `CEudoraApp::PreTranslateMessage`.
`GetWazooBarAt` ordnet den Rahmen der Filterleiste zu. `OnCommand`
versteckt sie. Das ist der Kern, und er war bisher nirgends gemessen. Den
Tastaturweg und die Wirkung einer echten Aktivierung belegt es nicht.
Nach `Arbeitsweise/messung-muss-den-weg-treffen.md` trifft der Fall also
die Entscheidung, aber nicht den ganzen Weg. Er ersetzt V1 nicht.

**Kleinigkeit:** Fall E-137c prüft nur das Präfix der Spurzeile. Fehlte
später der Zusatz `fokus=…`, bliebe er grün. Ohne Belang für das Paket.

**Schwere: niedrig.** **Hält das Paket auf: nein.**

## <a id="k4"></a>K4 — Der Kommentar zur Fokuslage ist für die Titelzeile vermutlich falsch

`mainfrm.cpp:3397-3400` und `:3495-3498` behaupten Folgendes: Bei Titelzeile
und Rand mache `ActivateTopParent` das Hauptfenster aktiv und gebe den Fokus
an die Mail zurück. Für den **Rand** stimmt das. `OnMouseActivate` gibt
`MA_NOACTIVATE` zurück, der Rahmen ist nicht im Vordergrund, und
`ActivateTopParent` holt das Hauptfenster nach vorn (`wincore.cpp:2924-2933`).
Für die **Titelzeile** ist es vermutlich anders. Dort gilt die Aktivierung
der Basisklasse, der Rahmen wird **vor** `OnNcLButtonDown` aktiv, und
`ActivateTopParent` tut dann nichts, weil der Rahmen selbst das
Vordergrundfenster ist. Der Fokus liegt dann auf dem Rahmen, nicht in der
Mail.

Für die Wirkung ist das gleichgültig. In beiden Fällen ist
`pFokusLeiste == NULL`, und die Marke greift. Die Spalte `fokus=` in der
neuen Spurzeile zeigt bei Gregors V1, welche Lage zutrifft. Die Aktivierung
bei `MFS_SYNCACTIVE` (`winfrm.cpp:1053-1079`) habe ich nicht zu Ende
nachgerechnet. Die ganze Aussage bleibt deshalb Vermutung.

**Schwere: sehr niedrig** (Kommentar). **Hält das Paket auf: nein.**

## <a id="k5"></a>K5 — E-160 für Outlook 2013 und neuer: korrekt und vollständig

Am Quelltext belegt, WOW64 gemessen:

* **Richtig eingehängt.** Die neue Bedingung kommt nur dazu, wenn keiner der
  alten Schlüssel da ist (`OLImportClass.cpp:317-333`). `m_bProfileKey` und
  `m_bIdentityKey` bleiben unverändert. Ein Anwender mit Outlook 2013 oder
  neuer läuft also wieder in den Zweig `else AddProfiles(…, MBOX_ABOOK)`
  wie vor [E-160](../Intern/BEFUNDE.md#e-160) ([PRUEFER-61 K3](PRUEFER-61.md#k3)). Das `hNeu` wird
  geschlossen, anders als das `hKey` des Originals darüber.
* **Vollständig.** Outlook 2013 schreibt nach `15.0`. Outlook
  2016, 2019, 2021 und 365 schreiben alle nach `16.0`, auch als
  Klick-und-Los-Fassung, deren Profile in der echten `HKCU` liegen. Bis
  Outlook 2010 stehen die Profile unter `Windows Messaging Subsystem\Profiles`,
  und das prüft der alte erste Schlüssel. Microsoft-Doku, hier nicht
  gemessen. Eine Fassung `17.0` gibt es nicht. Das „neue Outlook“
  (`olk.exe`) hat kein MAPI und ist ohnehin nicht importierbar.
* **WOW64.** Eudora ist ein 32-Bit-Prozess. `HKCU\Software` ist laut
  Microsoft ein geteilter Schlüssel. **Gemessen:** Er wird nicht umgeleitet,
  siehe Messungen.
* **Rest** (Vermutung): Bei einem deinstallierten Outlook kann der Schlüssel
  `16.0\Outlook\Profiles` liegen bleiben. Dann wird MAPI wieder geladen,
  und Gregors Windows-Meldung kann bei diesen Anwendern wieder erscheinen. So
  war es auch vor [E-160](../Intern/BEFUNDE.md#e-160), es ist also keine Verschlechterung. Für Gregors
  Rechner gilt das nicht: Der Schlüssel fehlt dort, wenn sein Rechner diesem
  gleicht. Gemessen habe ich nur diesen.
* **Test:** `TestE160.cpp` verlangt beide Zeichenketten und die
  erweiterte Bedingung. Laut Commit-Nachricht ergab die Gegenprobe ohne
  `16.0` 313/314. Das habe ich nicht wiederholt.

**Schwere: keine** (Bestätigung). **Hält das Paket auf: nein.**

## Neue Kennungen

**E-163** (vorgeschlagen, nicht in BEFUNDE eingetragen): [K1](#k1). Ob es
ein eigener Befund wird oder ein Nachtrag zu
[E-137](../Intern/BEFUNDE.md#e-137), entscheidet, wer einträgt. **E-164** ist
nicht vergeben.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Nach einem Klick in eine Wazoo-Leiste trifft Strg+W diese Leiste, auch wenn danach ein anderes Fenster aktiv wurde. Beispiel: Postfach per Doppelklick in *Mailboxes* öffnen, Strg+W, dann verschwindet die *Mailboxes*-Leiste statt des Postfachs. Neu durch `5ab3e4ea`, nichts geht verloren. Logik belegt, Fokuslage vermutet. | mittel | den Kurztest nicht; vor 7.2.1 beheben oder hinnehmen; Gegenschritt „V6“ vorgeschlagen |
| [K2](#k2) | Die Ausnahme für die Taste W, ohne die V1 scheitern würde, bewacht kein Test. Ohne sie: 314/314 grün (gemessen), Prüfstand ebenfalls blind. | niedrig | nein |
| [K3](#k3) | Der Prüfstandsfall misst die Entscheidung in `OnCommand` und das Merken des Klicks, nicht den Tastaturweg, keine echte Aktivierung, keine echte Mail und nicht die Gegenrichtung. Er ersetzt V1 nicht. | niedrig | nein |
| [K4](#k4) | Der Kommentar „Fokus geht an die Mail zurück“ stimmt für den Rand, für die Titelzeile vermutlich nicht. Ohne Wirkung. | sehr niedrig | nein |
| [K5](#k5) | Der Nachtrag zu [E-160](../Intern/BEFUNDE.md#e-160) deckt Outlook 2013 bis 365 ab. `HKCU\Software` wird für den 32-Bit-Prozess nicht umgeleitet (gemessen). | keine | nein |
