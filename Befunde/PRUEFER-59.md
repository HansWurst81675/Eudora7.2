# <a id="pruefer-59"></a>PRUEFER-59 — Behebungen nach dem Testpaket 7.2.0.123 (E-137, E-119, E-158, E-142, E-156, E-157), nachgerechnet, 26.10.2026

**Auftrag.** Geprüft wurde, was `git log origin/main..HEAD -- Eudora71 tools`
auf dem Zweig `0.123_ergebnisse` (Stand `8bdab960`) zeigt: `318138d4`
([E-137](../Intern/BEFUNDE.md#e-137), zweiter Teil), `f464948d` ([E-119](../Intern/BEFUNDE.md#e-119), zweiter Teil), `ec177b26` ([E-156](../Intern/BEFUNDE.md#e-156),
Paketbau), `dd3855c7` ([E-142](../Intern/BEFUNDE.md#e-142), No vorgewählt), `b1138ce0` ([E-158](../Intern/BEFUNDE.md#e-158)),
`d6b9ff3b` ([E-157](../Intern/BEFUNDE.md#e-157), Prüfstand). Eudora wurde weder gebaut noch gestartet. Kein
Prüfstand und kein `pruefstand-lauf.ps1` liefen. An der Registry wurde nichts
geändert: gelesen mit `reg query`, die Bindung von `Remove-ItemProperty` und
`New-ItemProperty` nur mit `-WhatIf` geprobt. Das Windows-Ereignisprotokoll
wurde gelesen. Gregors `eudora.log` wurden nur durchsucht (E-87-Zeilen). Die
MFC-Stellen sind in der Quelle auf diesem Rechner nachgelesen
(`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Keiner der Funde hält das Testpaket 7.2.0.124 auf.** Alle sechs
  Behebungen tun nach dem Quelltext, was sie sollen. Keine verschlechtert
  gegenüber 7.2.0.123 etwas, das Gregor bisher benutzt hat.
* **Neben dem Auftrag gefunden, gemessen: Der Prüfstand `C:\Temp\E146` ist
  heute um 07:56:32 abgestürzt** ([K11](#k11)). Betroffen war Eudora 7.2.0.122,
  das Modul war `Eudora.exe` selbst, der Code `c0000409`. Das steht nirgends
  im Repo. Die Ursache ist unbekannt. Im Prüfstandslauf an 7.2.0.124
  (`1bd0fe96`, 12:24 bis 12:31) kam derselbe Fall ohne Absturz durch
  (gemessen: kein Ereignis 1000 nach 10:05). Das ist der einzige Fund, den
  Gregor vor dem Paket kennen sollte. Vorschlag: Nummer **E-159**.
* **Nachtrag nach `git fetch` (Stand `3a895491`):** Der Prüfstandsfall
  E-119e ist inzwischen gefahren und grün (`laenge=78519`). Damit ist der
  Rückfall aus [K4](#k4) am Programm abgedeckt, nur nicht in der Testsuite.
  Nach diesem Lauf zeigen `CommandLine\Current` auf Gregors 1.0.123 und
  `LaunchManager\PathCount` unverändert 0x219 (gemessen, nur gelesen). Das
  Zurücksetzen aus [E-157](../Intern/BEFUNDE.md#e-157) hat also gewirkt.
* **[E-137](../Intern/BEFUNDE.md#e-137) (Klick in eine Wazoo-Leiste):** Die Leiste sieht jeden Klick in
  sich, angedockt und schwebend (am MFC-Quelltext belegt). Schwebend gibt
  `CControlBar::OnMouseActivate` `MA_NOACTIVATE` zurück. Das stoppt die
  Kette erst **nach** der Leiste, die neue Zeile läuft also trotzdem.
  Drag & Drop aus der Postfachliste ist nicht berührt. Neu ist: Auch ein Klick
  auf einen Reiter oder auf den Griff zum Ziehen holt den Fokus in die Leiste
  ([K1](#k1)). Kein Wazoo-Fenster lehnt `SetFocus` ab.
* **[E-119](../Intern/BEFUNDE.md#e-119) (große data:-Bilder):** Die Längenmessung stimmt für doppelte und
  einfache Anführungszeichen, für Werte ohne Anführungszeichen, am Pufferende
  und bei `'\0'` (am Quelltext belegt, Aufbau des Puffers
  `PGHTMIMP.CPP:917-967`). Der Überlauf von `arg_size` richtet sonst keinen
  Schaden an, weil gleich danach auf 1023 Zeichen gekürzt wird. Der Speicher
  in `E119DataNachDatei` reicht. Zwei Reste: [K3](#k3) und [K4](#k4). K4 ist
  gemessen: Der neue Test bleibt grün, wenn der Fehler vollständig
  zurückkommt.
* **[E-158](../Intern/BEFUNDE.md#e-158) (`</x-html>` beim Weiterleiten):** `IsHTML()` trifft in Gregors
  Protokollen jede HTML-Ausgangsmail. Gemessen: 13 von 13 Antworten und
  Weiterleitungen mit HTML hatten `IsHTML=1`. Die Bedingung verlässt sich aber
  auf genau den Merker, den [E-87](../Intern/BEFUNDE.md#e-87) als unzuverlässig beschrieben hat
  ([K5](#k5)). Woher die zweite `<x-html>`-Hülle kommt, habe ich im Quelltext
  **nicht** gefunden. `QuoteText` setzt genau eine. Ob HTML-Weiterleitungen
  dieselbe doppelte Hülle tragen, ist deshalb offen ([K6](#k6)).
* **[E-142](../Intern/BEFUNDE.md#e-142) (No vorgewählt):** Das ist richtig gebaut. Alle anderen Aufrufer
  von `CYesNoDlg` behalten Yes als Standardknopf. `return FALSE` nach
  `GotoDlgCtrl` ist das vorgesehene Muster. `CHelpxDlg` hat kein eigenes
  `OnInitDialog`. Kein Fund.
* **[E-156](../Intern/BEFUNDE.md#e-156) (Debug-Fassungen im Paket):** Schritt 8 hält die Debug-Laufzeit
  heraus. Gemessen: Keine der 39 Programmdateien in `Bin\Release` enthält
  ein Debug-Merkmal, auch nicht mit einem schärferen Muster. Schritt 8
  überschreibt aber die frische Laufzeit aus Schritt 7 mit Handkopien vom
  28.08. Heute sind beide gleich (SHA-1 gemessen). Nach einem Update von
  Visual Studio wäre das nicht mehr so ([K7](#k7)). Dem Muster fehlen zwei
  Debug-Laufzeiten ([K8](#k8)).
* **[E-157](../Intern/BEFUNDE.md#e-157) (Registry, Abstürze):** Das Zurücksetzen der Registry macht heute
  nichts kaputt. Es bricht aber ab, sobald einer der Schlüssel einen Wert
  „(Standard)“ trägt (gemessen an der Parameterbindung, [K9](#k9)).
  `Properties[10]` ist auf diesem Windows der Pfad der Anwendung (gemessen:
  168 Ereignisse, alle 15 Felder). 57 Registry-Zweige früherer Prüfstände
  und 537 LaunchManager-Pfade bleiben liegen ([K10](#k10)).

**Testsuite** (gemessen, in meinem Baum): 311 Tests, 311 bestanden. Mit der
Rückfallprobe aus K4 waren es ebenfalls 311 von 311. Danach war
`PGHTMIMP.CPP` byte-gleich zurück (`cmp` gegen `HEAD`), dann `touch`.
`git status` war leer.

## Teil 1 — E-137, Klick in eine Wazoo-Leiste (`WazooBar.cpp:1961-1977`)

**Erreicht WM_MOUSEACTIVATE die Leiste?** (am Quelltext belegt) Der
Mechanismus ist `DefWindowProc`. Jedes Kind, das die Botschaft unbehandelt
lässt oder über `CWnd::OnMouseActivate` → `Default()` weitergibt, reicht sie
an den Elternteil weiter. Das gilt auch für `CView::OnMouseActivate`
(`viewcore.cpp:262`, ruft zuerst `CWnd::OnMouseActivate`). Die Kette läuft
vom angeklickten Fenster über `CWazooWnd` und den Reiter (`SEC3DTabWnd`) zur
`CWazooBar`. Kein Glied dazwischen fängt die Botschaft ab:

* `OnMouseActivate` überschreiben in `Eudora/` und `OTShim/` nur
  `CNicknamesWazooWnd` (ruft die Basis, `NicknamesWazooWnd.cpp:321-327`),
  `SECMDIChildWnd` (Rahmen, `OTShim.cpp:604`) und `SECCustomToolBar`
  (Werkzeugleiste, keine Wazoo-Leiste).
* `nickview.cpp:686` schickt `WM_MOUSEACTIVATE` von Hand. Die Stelle ist
  auskommentiert.

**Schwebend in einer Mini-Frame-Leiste** (am Quelltext belegt).
`SECControlBar` erbt `CControlBar::OnMouseActivate` (`barcore.cpp:626-635`).
Schwebend ruft das `ActivateTopParent()` und gibt `MA_NOACTIVATE` zurück.
`CWazooBar::OnMouseActivate` ruft die Basis zuerst und setzt **danach** den
Fokus. Die Zeile läuft also auch schwebend, und das war Gregors Fall
(„filter fenster (abgedockt)“). `SetFocus` auf ein Fenster im nicht aktiven
Mini-Frame aktiviert diesen. Das ist dasselbe, was bisher jeder Klick in ein
Eingabefeld der schwebenden Leiste tat. Der Klick auf die Titelleiste des
Mini-Frames geht an den Mini-Frame selbst, nicht an die Leiste. Wer ein
schwebendes Fenster an der Titelleiste verschiebt, behält den Fokus, wo er
war.

**Was SetFocus stören könnte:**

| Handgriff | Wirkung | Beleg |
|---|---|---|
| Drag & Drop aus der Postfachliste in die Leiste | keine: OLE-Ziehen läuft mit Mauserfassung, das Ziel bekommt kein `WM_MOUSEACTIVATE` | Vermutung (Windows-Verhalten) |
| Ziehen aus der Leiste (Baum, Liste) | wie bisher: das Element setzt den Fokus beim Drücken ohnehin | am Quelltext belegt |
| Rechtsklick | Fokus geht in die Leiste. Der Baum tut das beim Rechtsklick ohnehin | Vermutung (Verhalten der Baumansicht) |
| Klick auf einen Reiter | [K1](#k1) | am Quelltext belegt |
| Greifer oder Rand einer **angedockten** Leiste ziehen | [K1](#k1) | am Quelltext belegt |
| Klick in ein Eingabefeld | Der Fokus geht kurz an das zuletzt benutzte Feld, dann an das angeklickte | am Quelltext belegt |

**Lehnt ein Wazoo-Fenster SetFocus ab?** Nein (am Quelltext belegt).
`CWazooWnd::OnSetFocus` (`WazooWnd.cpp:421-454`) gibt den Fokus an
`m_hwndFocus` weiter. Ist das kein Fenster mehr, ruft es `Default()`. Dann
behält das Wazoo-Fenster selbst den Fokus. Das genügt für Strg+W, denn
`GetWazooBarWithFocus` fragt nur `IsChild` (`WazooBarMgr.cpp:1019-1037`). Ein
unsichtbares aktives Wazoo-Fenster liefert `GetActiveWazooWindow` als NULL
(`WazooBar.cpp:383-397`). Dann geschieht nichts.

## <a id="k1"></a>K1 — Klick auf Reiter und Griff holt den Fokus jetzt auch in die Leiste

(am Quelltext belegt; die Folge für den Fokus ist eine Vermutung)

**Reiter.** Die Reihenfolge ist:

1. `OnMouseActivate` der Leiste gibt den Fokus dem **bisher** aktiven
   Wazoo-Fenster.
2. Danach schaltet `SEC3DTabControl::OnLButtonDown` den Reiter um
   (`OTShim_Reiter.cpp:1272-1289`).
3. `ZeigeInhaltsfenster` versteckt das alte Fenster mit `SW_HIDE`
   (`OTShim_Reiter.cpp:1609-1612`).

Niemand setzt den Fokus danach in das neue Fenster.
`QC3DTabControl::ActivateTab` (`QC3DTabWnd.cpp:74-131`) ruft kein
`SetFocus`. Windows gibt den Fokus eines versteckten Fensters an dessen
Elternteil (Vermutung, Windows-Verhalten). Er landet dann im
Reiter-Container: Strg+W wirkt auf die Leiste, Tippen aber ins Leere.
Bisher geschah das nur, wenn der Fokus schon vor dem Reiterwechsel in der
Leiste lag. Jetzt geschieht es auch, wenn er vorher in einer Mail lag.

**Griff und Rand.** Wer eine **angedockte** Leiste am Griff zieht oder an
ihrem Rand die Größe ändert, gibt ihr damit den Fokus. Bisher blieb er in
der Mail.

**Nebenwirkung.** Klickt man in ein Feld, bekommt zuerst das zuletzt
benutzte Feld der Leiste den Fokus und verliert ihn sofort wieder. Im
Adressbuch prüft `nickview.cpp:664ff` beim Verlust des Fokus auf doppelte
Spitznamen. Das läuft also einmal mehr. Es wirkt aber nur auf Text, der
ohnehin schon geprüft ist (Vermutung).

**Schwere: niedrig.** Strg+W tut danach in allen drei Fällen das Richtige.
Prüfen lässt sich das nur am laufenden Programm: Mail anklicken, dann einen
anderen Reiter derselben Leiste, dann ein Zeichen tippen.

## <a id="k2"></a>K2 — Die aktive Ansicht des Hauptrahmens kann auf eine Leistenansicht zeigen

(Vermutung, vorbestehend, nur häufiger)

`CWazooWnd::OnSetFocus` setzt `GetParentFrame()->SetActiveView(...)`
(`WazooWnd.cpp:425-441`). Angedockt ist dieser Rahmen `CMainFrame`. Holt ein
Klick auf den Griff den Fokus in die Leiste (K1) und wird die Leiste danach
schwebend gezogen, gehört die Ansicht zu einem anderen Rahmen. Der
Hauptrahmen merkt sich trotzdem weiter einen Zeiger auf sie.
`CView::OnDestroy` räumt nur beim **eigenen** Rahmen auf
(`viewcore.cpp:109-115`). Gefährlich würde das erst, wenn eine solche Ansicht
vor dem Hauptrahmen zerstört wird. Einen solchen Weg habe ich nicht gefunden:
Strg+W und Hide verstecken nur. Den Zustand gab es schon, wenn der Fokus
beim Ziehen in der Leiste lag. **Schwere: niedrig.**

## Teil 2 — E-119, data:-Bilder über 64K Zeichen (`PGHTMIMP.CPP:3744-3755`)

**Länge in allen Fällen** (am Quelltext belegt). Der Attributpuffer wird in
`PGHTMIMP.CPP:917-967` gebaut:

* Vor und nach jedem `=` steht ein Leerzeichen.
* Ein Wert in Anführungszeichen wird mit dem öffnenden und dem schließenden
  Zeichen übernommen, danach folgt ein Leerzeichen.
* Am Ende steht `'\0'`.

Daraus folgt für `command[-1]`:

| Fall | `command[-1]` | Ende laut neuer Messung | Ende laut `GetNextToken` |
|---|---|---|---|
| `src="data:..."` | `"` | nächstes `"` | nächstes `"` |
| `src='data:...'` | `'` | nächstes `'` | nächstes `'` |
| `src=data:...` | Leerzeichen (eingefügt nach `=`) | nächstes Leerzeichen | nächstes Leerzeichen |
| Wert ohne schließendes Zeichen | `"`/`'` | `strchr` NULL → `strlen` bis `'\0'` | `'\0'` |
| `'\0'` mitten im Puffer | — | `strchr` hält an `'\0'` | hält an `'\0'` |

Die neue Messung und die alte Zählung enden also immer an derselben Stelle.
Falsch war nur die 16-Bit-Zahl. Ein nicht in Anführungszeichen stehender Wert
kann nicht direkt auf ein Anführungszeichen folgen, denn hinter jedem
schließenden Zeichen fügt der Puffer ein Leerzeichen ein. `attribute_index` ist
`long` (`PGTXRCPP.H:341`) und läuft nicht über.

**Weitere Überläufe von `arg_size`** (am Quelltext belegt). `arg_size` wird
danach nur noch auf `kMaxAttributeSize-1` = 1023 gekürzt (`PGTXR.H:312`) und
kopiert. Ein übergelaufener Wert ergibt einen kürzeren, nie einen längeren
Kopierauftrag. Es gibt also keinen Speicherschaden. Lange Werte, die nicht
data: sind (`href`, `style`), wurden immer schon gekürzt. `table_command` mit
übergelaufener Länge betrifft nur Attribut**namen**. Die sind nie länger als
64K.

**Speicher** (am Quelltext belegt). `E119DataNachDatei` legt `nDaten + 4`
Byte an (`DEBUG_NEW_NOTHROW`). Dekodiert werden höchstens drei Viertel
davon. Scheitert die Anlage, kommt `FALSE` zurück. Dann bleibt es beim alten
Kürzen, ohne Absturz.

## <a id="k3"></a>K3 — Zwei Reste beim data:-Bild, beide aus dem Bestand

(am Quelltext belegt)

* **Wert ohne Anführungszeichen mit `=` am Ende.** Base64 endet oft mit `=`
  oder `==`. Der Puffer macht daraus ` = = ` (`PGHTMIMP.CPP:934-939`).
  Messung und `GetNextToken` enden vor dem ersten `=`. Die letzten ein bis
  zwei Bytes des Bildes fehlen dann. Bei JPEG ist das die Endmarke.
  Vorbestehend und selten: HTML-Mails setzen data:-Werte praktisch immer in
  Anführungszeichen.
* **Halb geschriebene Datei bleibt für immer.** Die Datei unter `Embedded`
  wird nur geschrieben, wenn es sie noch nicht gibt (`PGHTMIMP.CPP:3679`).
  Bricht `fwrite` ab (Platte voll, Absturz), bleibt eine kurze Datei
  liegen. Jedes spätere Öffnen derselben Mail nimmt sie wieder. Heilen lässt
  sich das nur durch Löschen der Datei `data-<Prüfsumme>.<Endung>`.

**Schwere: niedrig.**

## <a id="k4"></a>K4 — Der neue E-119-Test bleibt grün, wenn der Fehler zurückkommt (gemessen)

Die Probe: unmittelbar vor `char szE119Datei[kMaxAttributeSize];` die Zeile
`nE119Laenge = (long)arg_size;` eingesetzt (Perl, ein Treffer). Damit
bekommt `E119DataNachDatei` wieder den übergelaufenen 16-Bit-Zähler, also
genau Gregors grüne Fläche. Ergebnis: **311 von 311 bestanden**, auch „[E-119](../Intern/BEFUNDE.md#e-119):
ein data:-Bild ueber 64 KB kommt mit seiner vollen Laenge an“. Der Test
prüft nur, dass die Zeile mit `strchr` und der Aufruf mit `nE119Laenge`
dastehen, nicht, dass dazwischen nichts den Wert überschreibt. Den Fehler
selbst misst erst der Prüfstandsfall E-119e. Er ist seit `1bd0fe96` an
7.2.0.124 gefahren und grün (`laenge=78519`). **Schwere: niedrig.** Abhilfe:
im Test den Abschnitt zwischen Messung und Aufruf auf eine weitere Zuweisung
an `nE119Laenge` prüfen. Sonst bemerkt den Rückfall erst der nächste volle
Prüfstandslauf.

## Teil 3 — E-158, `</x-html>` beim Weiterleiten (`summary.cpp:1518-1521`)

**IsHTML() in allen Antwortarten** (am Quelltext belegt). `CSummary::ComposeMessage`
bedient Antworten, Allen antworten, Weiterleiten und Umleiten
(`summary.cpp:933-948`). `IsHTML()` ist der Merker `MSFEX_HTML` des
Übersichtseintrags der **Ausgangsnachricht** (`summary.h:322-323`). Er gilt
für alle vier Arten gleich:

* Bei Mehrfachauswahl läuft die Funktion je Eintrag, also mit dem Merker der
  jeweiligen Mail.
* „Send Again“ geht nicht durch diesen Zweig.
* Beim Weiterleiten eines eigenen Entwurfs (`IsComp()`) setzt
  `PgMsgView::ExportMessage` den Merker beim Sichern (`PgMsgView.cpp:376-393`).
  Er ist dort also verlässlich.
* Beim Umleiten einer Textmail war [E-88](../Intern/BEFUNDE.md#e-88) schon vorher aus, weil
  `IsFancy(Body)` dort kein HTML findet.

**Wer setzt den Merker** (am Quelltext belegt):

* beim Empfang über POP: `pop.cpp:615` und `CSummary::Build`, das jede
  Rumpfzeile mit `IsFancy` prüft (`summary.cpp:2370-2378`). Ein `<x-html>` an
  einem Zeilenanfang setzt ihn, auch bei multipart/alternative.
* bei IMAP: `ImapDownload.cpp:958, 1073, 2708, 3884, 5132`
* beim Lesen: `PgReadMsgView.cpp:386`

## <a id="k5"></a>K5 — E-88 hängt jetzt an dem Merker, den E-87 für unzuverlässig erklärt hat

(am Quelltext belegt; an Gregors Protokollen gemessen, dass es ihn derzeit
nicht trifft)

`summary.cpp:1115-1135` begründet [E-87](../Intern/BEFUNDE.md#e-87) damit, dass die Merker des
Übersichtseintrags „bei Nachrichten, deren Uebersicht aelter ist als die
Kennzeichnung“ fehlen. Deshalb zählt dort `IsFancy(fullMes)` mehr als die
Merker. [E-158](../Intern/BEFUNDE.md#e-158) macht [E-88](../Intern/BEFUNDE.md#e-88) jetzt wieder von genau so einem Merker abhängig.
Für eine HTML-Mail ohne `MSFEX_HTML` geht beim Weiterleiten die Fassung aus
dem Editor hinaus: ohne Kästen, Hintergründe und CSS-Bildgrößen. Das ist der
Zustand vor [E-88](../Intern/BEFUNDE.md#e-88). Etwas kaputt geht dabei nicht.

**Gemessen** an den E-87-Zeilen in Gregors `eudora.log` (1.0.110 bis
1.0.122):

* 15 Antworten und Weiterleitungen.
* 13 davon waren HTML (`IsFancy=3`), alle 13 mit `IsHTML=1`.
* 2 waren `format=flowed` (`IsFancy=1 IsHTML=0`).
* Kein einziger Fall `IsFancy=3 IsHTML=0`.

**Schwere: niedrig.** Robuster und genauso wirksam gegen [E-158](../Intern/BEFUNDE.md#e-158) wäre
`IsRich == IS_HTML`. Dieser Wert ist in `summary.cpp:1112-1140` schon aus
`fullMes` gerechnet. Für eine Textmail ist er `IS_ASCII`.

## <a id="k6"></a>K6 — Woher die zweite `<x-html>`-Hülle kommt, ist nicht geklärt

(am Quelltext belegt, dass `QuoteText` nur eine setzt; die Folge für HTML ist
eine Vermutung)

Der Commit und BEFUNDE sagen: „QuoteText baut … eine doppelte Hülle“. Am
Quelltext stimmt das nicht.

* `QuoteText` setzt genau ein Paar `<x-html>`/`</x-html>`
  (`msgutils.cpp:172-219`, `bSingle`).
* `GetBodyAsHTML` entfernt die Hülle seiner Eingabe
  (`msgutils.cpp:2365ff`).
* `Text2Html` und `AddToBody` für Text setzen keine.
* Die übrigen Schreiber von `x-html` sind `etf2html.cpp:200/563` (nur
  Enriched), `TextReader.cpp:124/131/400` (nur Empfang) und
  `TocFrame.cpp:1401`. Keiner davon liegt auf dem Weg einer weitergeleiteten
  Textmail.

Die zweite Hülle muss also **nach** `QuoteText` dazukommen: beim Sichern, in
`Out.mbx` oder beim Senden. Dieser Weg unterscheidet aber nicht zwischen
Text- und HTML-Ausgangsmail. Wenn das stimmt, trägt auch jede HTML-Mail, die
mit „Fassung=ORIGINAL“ hinausgeht, die doppelte Hülle. In einer
HTML-Ansicht ist ein unbekanntes `<x-html>` unsichtbar. Sichtbar wäre es nur
im Textteil oder in einem Leser, der den Quelltext zeigt. [E-158](../Intern/BEFUNDE.md#e-158) schaltet nur
den Textfall ab. **Schwere: mittel (ungeklärt).** Messen: eine HTML-Mail
weiterleiten, sichern und in `Out.mbx` die Hüllen zählen. Der in BEFUNDE
genannte Prüfstandsfall prüft nur Text und deckt das nicht ab.

## Teil 4 — E-142, No vorgewählt (`guiutils.cpp:852-877`, `:1192-1211`)

(am Quelltext belegt)

* `CYesNoDlg` ist eine Klasse nur dieser Datei. Sie wird nur in `guiutils.cpp`
  angelegt. Der Konstruktor setzt `m_bNeinVorgewaehlt = FALSE`. Nur
  `YesNoDialogPlainNeinVorgewaehlt` setzt TRUE, und nur `tocdoc.cpp:2788`
  ruft diese Funktion.
* `CHelpxDlg` erbt `OnInitDialog` unverändert von `CDialog`
  (`helpxdlg.h:10`; eine eigene Fassung gibt es nicht).
* Die Folge `SetDefID(IDCANCEL)`, `BM_SETSTYLE` mit `BS_PUSHBUTTON` auf IDOK
  (entfernt den Rahmen, den `DEFPUSHBUTTON` aus `EudoraRes.rc:2466`
  mitbringt), `GotoDlgCtrl` und `return FALSE` ist das vorgesehene Muster.
* Enter und Esc ergeben beide `IDCANCEL` = No. Das Kästchen „Don't ask me
  anymore“ ist bei `m_WarnID == 0` versteckt. Es kann den Standardknopf also
  nicht zurückholen.

Kein Fund.

## Teil 5 — E-156, Paketbau (`paket-bauen.ps1:670-713`, `paket-pruefen.ps1:768-796`)

**Kann Schritt 8 eine falsche Datei einsetzen?**

* **Groß/Klein:** Das Dateisystem unterscheidet nicht. `-ieq` gilt für
  Paige32d.
* **Unterordner:** `$rel` behält den Unterordner. `Plugins\SMIME.dll` kommt
  aus `Bin\Release\Plugins\SMIME.dll`, also derselben Quelle wie in
  Schritt 4.
* **`Paige32d.dll`** wird bewusst auf `Paige32.dll` abgebildet. Die
  gleichnamige `Bin\Release\Paige32d.dll` vom 31.08. wird nicht genommen.
* **Was „aus dem Release-Bau“ wirklich heißt:** Gemessen an der Projektliste
  von `Eudora.sln` baut die Solution EuShlExt, EudoraNS, swEudora, x1lib,
  EuGraph, EUMAPI, EuMAPI32 und die drei Plugins **nicht**. Ihre
  Gegenstücke in `Bin\Release` sind eingecheckte Dateien
  (`git ls-files Eudora71/Bin/Release`). Für diese Dateien bedeutet
  Schritt 8: Release-Fassung aus dem Repo statt Debug-Fassung aus der
  Grundlage. Das ist richtig. „Frisch gebaut“ heißt es nicht.
* **Die Laufzeit:** [K7](#k7).

**Debug-Muster gegen alle Dateien** (gemessen). Ich habe die 39
Programmdateien in `Bin\Release` des Hauptbaums nur gelesen. Gesucht wurde
mit dem Muster aus dem Commit und zusätzlich nach `msvcrtd.dll`,
`mfco42d.dll` und `debug_heap.cpp`. Keine Datei hat einen Treffer. Es gibt
also keinen Fehlalarm bei den heutigen Release-Dateien. Dass die Prüfung
die sechs Debug-Fassungen im Paket 1.0.123 rot meldet, belegt der Commit.

**Plugins, die Gregor selbst ins Paket legt.** `paket-bauen.ps1` arbeitet nur
mit dem ausgepackten Grundlagen-ZIP. Gregors Verzeichnisse berührt es nicht.
`paket-pruefen.ps1` geht mit dem Paket hinaus. Läuft es in einem Verzeichnis,
in dem Gregor ein Debug-Plugin abgelegt hat, meldet es FEHLER, und das ist
richtig. Für ein Plugin aus Visual C++ 6 gilt das nicht ([K8](#k8)). Das
`Mailverzeichnis` ist ausgenommen, damit auch Anhänge darin. Die Ausnahme
greift sicher, weil `$Paket` aufgelöst wird (`paket-pruefen.ps1:82`).

## <a id="k7"></a>K7 — Schritt 8 überschreibt die Laufzeit aus Schritt 7 mit Handkopien

(am Quelltext belegt, gemessen)

Schritt 7 holt `mfc140.dll`, `msvcp140.dll` und `vcruntime140.dll` aus dem
Redist-Ordner der installierten Visual-Studio-Fassung (`paket-bauen.ps1:643-668`).
Schritt 8 findet sie als ausführbar und ersetzt sie durch
`Eudora71\Bin\Release\<Name>`. Diese drei Dateien sind **nicht** eingecheckt.
Im Hauptbaum liegen sie seit dem 28.08.2026 von Hand dort.

* **Heute gleich** (gemessen, SHA-1 gegen Redist 14.38.33130, alle drei
  identisch). Es wird also nichts ersetzt.
* **Nach einem Update von Visual Studio** baut der neue Compiler gegen eine
  neuere Laufzeit. Schritt 7 holt die neue. Schritt 8 legt kommentarlos die
  alte vom 28.08. darüber und meldet „aus dem Release-Bau ersetzt“. Eine
  ältere `vcruntime140.dll`, als der Compiler verlangt, kann beim Start
  scheitern (Vermutung).
* **In einem frischen Baum** fehlen die drei Dateien (gemessen: mein
  Arbeitsbaum hat in `Bin\Release` keine davon). Schritt 8 bricht dort mit
  „kein Gegenstueck“ ab. Schon vorher scheitert Schritt 4 an
  `Plugins\EudoraUnicodeFix.dll`, die auch nicht eingecheckt ist. Neu ist
  der Abbruch also nicht. Er hat jetzt aber zwei Ursachen.

**Schwere: niedrig.** Abhilfe: die drei Laufzeitdateien in Schritt 8
überspringen oder ihr Gegenstück aus dem Redist-Ordner nehmen.

## <a id="k8"></a>K8 — Dem Debug-Muster fehlen zwei Laufzeiten

(am Quelltext belegt)

* `msvc[rp]\d+d\.dll` verlangt Ziffern. Die Debug-Laufzeit von Visual C++ 6
  heißt `MSVCRTD.DLL` und fällt durch. `MFCO42D.DLL` fällt ebenfalls durch.
  `MFC42D.DLL` wird erkannt.
* Eine statisch eingebaute Debug-UCRT (ab VS2015, `/MTd`) hinterlässt
  `debug_heap.cpp`, nicht `dbgheap.c`. Ihre `_CrtDbgReport`-Texte stehen als
  UTF-16 in der Datei. Die ASCII-Suche findet sie nicht.

Heute trifft das keine Datei (siehe oben). Es betrifft alte Fremd-DLLs und
Plugins, die Gregor oder Dritte beilegen. **Schwere: niedrig.** Muster
ergänzen: `msvcrtd\.dll|mfco\d+u?d\.dll|debug_heap\.cpp`.

## Teil 6 — E-157, Prüfstand (`pruefstand-lauf.ps1:141-197`, `:208-393`)

**Properties[10]** (gemessen). Ich habe alle 168 Ereignisse 1000 des
Anwendungsprotokolls auf diesem Rechner gelesen. Alle stammen vom Anbieter
„Application Error“ und haben 15 Felder. `[0]` ist der Name der Anwendung,
`[3]` das Modul, `[6]` der Code, `[10]` der volle Pfad, zum Beispiel
`C:\Users\Gregor\Eudora72-1.0.123-release\Eudora.exe`. Das Schema gilt seit
Windows 7. Auf älteren Systemen hat das Ereignis weniger Felder. Dann greift
`$p.Count -gt 10`, und der Lauf bleibt still statt falsch. Der Filter fragt
nur `Id = 1000`, nicht den Anbieter. Ein fremdes Programm mit eigener
Ereignis-ID 1000 und Pfad im Prüfstand ist aber praktisch ausgeschlossen.

**Abstürze beim Beenden** (am Quelltext belegt). `testlauf.ps1:343-369`
wartet nach `WM_CLOSE`, bis der Prozess beendet ist. Ein Absturz beim
Beenden fällt in diese Wartezeit. Windows schreibt Ereignis 1000, bevor der
Prozess endet (Vermutung, WER hält den Prozess bis zum Bericht). Nach dem
Rücklauf wartet die Prüfung noch 2 s und liest dann. Abstürze **nach** dem
Lesen gibt es nur, wenn `testlauf` abgeschossen hat (`Kill()`). Dann gibt
es kein Ereignis 1000. Hänger (Ereignis 1002) werden nicht gelesen.
Startzeit ist `$beginn` je Gruppe (`:233`). Ein Absturz, dessen Ereignis
erst nach dem Start der nächsten Gruppe im **selben** Verzeichnis kommt,
würde dort angerechnet. Das ist eine theoretische Lücke.

## <a id="k9"></a>K9 — RegistryZurueck bricht an einem Wert „(Standard)“ ab und überschreibt Gregors gleichzeitige Änderungen

(gemessen, wo angegeben; sonst am Quelltext belegt)

* **„(Standard)“** (gemessen mit `-WhatIf`): `GetValueNames()` liefert den
  Standardwert als leeren Namen. Sowohl `Remove-ItemProperty -Name ''` als
  auch `New-ItemProperty -Name ''` scheitern mit
  `ParameterBindingValidationException` („leere Zeichenfolge“). Weil
  `$ErrorActionPreference = 'Stop'` gilt (`:51`), bricht `finally` dann ab.
  Wird `CommandLine` gerade zurückgesetzt, bleibt `LaunchManager`
  unberührt, und damit genau der gefährliche `DLLPath`. Heute trägt keiner
  der beiden Schlüssel einen Standardwert (gemessen). Eudora schreibt in
  `CommandLine` nur `Current` (`eudora.cpp:3720-3758`).
* **Gregors eigene Eudora während des Laufs:** Startet Gregor während eines
  Prüfstandslaufs sein Eudora, schreibt es `CommandLine\Current`.
  `RegistryZurueck` setzt den Wert auf den Stand vor dem Lauf zurück, oder
  löscht ihn, wenn er vorher fehlte. Seine Änderung ist dann weg. Bei
  `Current` ist das harmlos, beim nächsten Start steht er wieder da.
* **`REG_MULTI_SZ`:** Verglichen wird `"$jetzt" -ne "$($alt[0])"`. Zwei
  Listen, die mit Leerzeichen verbunden gleich aussehen (`"a b"` gegen
  `"a","b"`), gelten als gleich und werden nicht zurückgesetzt. Ein Wechsel
  der **Art** bei gleichem Text (`"1"` als REG_SZ gegen 1 als DWORD) bleibt
  ebenfalls stehen. `REG_BINARY` und `REG_EXPAND_SZ` (dank
  `DoNotExpandEnvironmentNames`) werden richtig zurückgeschrieben. Heute gibt
  es in beiden Schlüsseln nur `String` und `DWord` (gemessen).
* **Unterschlüssel** werden nicht festgehalten. Bisher gibt es keine
  (gemessen: `SubKeyCount` 0).
* **Abschuss:** `finally` läuft bei Strg+C, aber nicht, wenn der
  PowerShell-Prozess von außen beendet wird, zum Beispiel durch eine
  Zeitschranke eines Agenten. Dann bleibt die Registry, wie der Prüfstand
  sie hinterließ.

**Schwere: niedrig.** Abhilfe: Standardwert über
`$k.OpenSubKey(...,$true).SetValue('', ...)` behandeln oder überspringen.
Jeden Schlüssel in einem eigenen `try` zurücksetzen.

## <a id="k10"></a>K10 — Was E-157 nicht zurücksetzt

(gemessen, nur gelesen)

* `HKCU\Software\Qualcomm\Eudora\<Mailverzeichnis>` enthält je benutztem
  Mailverzeichnis die Leistenstellung. Es gibt 148 solcher Zweige, 57 davon
  unter `C:\Temp` (Prüfstände) und 91 unter `C:\Users`. Neue kommen bei
  jedem Prüfstand mit neuem Verzeichnis dazu. Gregors Eudora liest nur seinen
  eigenen Zweig. Es ist also nur Ballast.
* `LaunchManager\PathCount` = 0x219: 537 Pfade, überwiegend `Attach`,
  `Embedded` und `imap` früherer Prüfstände und Scratchpads. [E-157](../Intern/BEFUNDE.md#e-157) verhindert
  nur, dass es mehr werden. Die vorhandenen bleiben. Die Pfade bestimmen,
  bei welchen Ordnern die Startschutz-Erweiterung (EuShlExt) vor dem Öffnen
  warnt. Mehr Pfade heißt: mehr Warnungen, nicht weniger Schutz (Vermutung).
* `HKEY_CLASSES_ROOT` (`x-eudora-option`, `.mbx`, `.sta`, `mailto`) schreibt
  Eudora bei jedem Start (`eudora.cpp:3609-3613`, `:3656-3713`). Unter
  `HKCU\Software\Classes` gibt es keinen dieser Schlüssel (gemessen). Die
  Schreibzugriffe zielen also auf HKLM und scheitern ohne Administratorrechte.
  Auf diesem Rechner richten sie keinen Schaden an.

**Schwere: niedrig.** Aufräumen nur mit Gregors Ja.

## <a id="k11"></a>K11 — Unbekannter Absturz im Prüfstand E146 heute früh

(gemessen, Ereignisprotokoll; Ursache unbekannt)

```
26.10.2026 07:56:32  Application Error, Ereignis 1000
Anwendung  Eudora.exe 7.2.0.122   Pfad C:\Temp\E146\Eudora.exe
Modul      Eudora.exe 7.2.0.122   Code c0000409   Offset 0x001d0d79   PID 1778
```

`c0000409` ist `STATUS_STACK_BUFFER_OVERRUN`. So meldet Windows auch jedes
`__fastfail` und jeden Abbruch durch den Ungültiger-Parameter-Handler der
Release-CRT. Der Fehler liegt in **unserem** Code, nicht in einer
Fremd-DLL. Gefunden habe ich ihn weder in `Intern/BEFUNDE.md` noch in
`WEITERMACHEN.md`, `Befunde/*.md` oder `tools/TESTLAEUFE.md` (gesucht nach
Uhrzeit und Verzeichnis). [E-157](../Intern/BEFUNDE.md#e-157) hätte ihn ab jetzt rot gemacht. Am 26.10.
lief E146 noch ohne diese Prüfung. Die `Eudora.exe` in `C:\Temp\E146` ist
inzwischen ersetzt (12:24). Die Adresse lässt sich nur mit der Map- oder
PDB-Datei von 7.2.0.122 auflösen, falls es sie noch gibt. Im Prüfstandslauf
an 7.2.0.124 (12:24 bis 12:31, mit [E-157](../Intern/BEFUNDE.md#e-157)) lief E146 ohne Absturz durch. Seit
10:05 gibt es kein Ereignis 1000 (gemessen). Der Absturz ist also nicht
wiederholt, aber auch nicht erklärt.

**Schwere: mittel (ungeklärt).** Hält das Paket nicht von selbst auf. Gregor
sollte es aber wissen: Kommt der Absturz aus dem Umbenennen von IMAP-Ordnern
([E-146](../Intern/BEFUNDE.md#e-146)), steckt er auch in 7.2.0.124. Vorschlag: Befund **E-159**. Erster
Schritt: Offset `0x1d0d79` gegen `Eudora.map` oder `Eudora.pdb` von
7.2.0.122 auflösen, dann den Fall E146 einmal mit [E-157](../Intern/BEFUNDE.md#e-157) fahren.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Ein Klick auf einen Reiter oder auf den Griff einer Wazoo-Leiste holt jetzt auch den Tastaturfokus in die Leiste. Nach einem Reiterwechsel liegt er dann auf keinem Feld. Tippen geht ins Leere, Strg+W wirkt richtig. | niedrig | nein |
| [K2](#k2) | Der Hauptrahmen kann sich eine Ansicht aus einer inzwischen schwebenden Leiste als „aktiv“ merken. Gefährlich nur, wenn sie vor dem Hauptrahmen zerstört würde. Einen solchen Weg habe ich nicht gefunden. Vorbestehend. | niedrig (Vermutung) | nein |
| [K3](#k3) | Ein data:-Bild **ohne** Anführungszeichen verliert die letzten 1–2 Byte. Eine einmal halb geschriebene Bilddatei unter Embedded wird immer wieder benutzt. Beides aus dem Bestand. | niedrig | nein |
| [K4](#k4) | Der neue E-119-Test bleibt grün, wenn der 16-Bit-Fehler vollständig zurückkommt. Gemessen: 311/311 mit dem Rückfall. | niedrig | nein (E-119e ist seit `1bd0fe96` gefahren und grün) |
| [K5](#k5) | [E-88](../Intern/BEFUNDE.md#e-88) hängt jetzt an einem Merker, der laut [E-87](../Intern/BEFUNDE.md#e-87) bei alten Übersichten fehlen kann. Dann geht eine HTML-Weiterleitung ohne Kästen und CSS hinaus, wie vor [E-88](../Intern/BEFUNDE.md#e-88). Bei Gregor 13 von 13 Fällen richtig gemerkt. | niedrig | nein |
| [K6](#k6) | Woher die doppelte `<x-html>`-Hülle kommt, steht nicht im Quelltext von `QuoteText`. Vermutlich tragen auch HTML-Weiterleitungen sie, nur unsichtbar. [E-158](../Intern/BEFUNDE.md#e-158) behebt nur den Textfall. | mittel (ungeklärt) | nein, aber vor „behoben“ eine HTML-Weiterleitung in `Out.mbx` messen |
| [K7](#k7) | Paketbau Schritt 8 legt über die frische VC-Laufzeit aus Schritt 7 die Handkopie vom 28.08. Heute identisch. Nach einem Update von Visual Studio käme eine zu alte Laufzeit ins Paket. Im frischen Baum bricht der Bau ab. | niedrig | nein |
| [K8](#k8) | Das Debug-Muster erkennt `MSVCRTD.DLL` (VC6) und eine statisch eingebaute UCRT-Debug-Laufzeit nicht. Heute betrifft das keine Datei. | niedrig | nein |
| [K9](#k9) | Das Zurücksetzen der Registry bricht an einem Standardwert ab und lässt dann `LaunchManager` stehen. Gregors gleichzeitige Änderungen werden überschrieben. Bei Abschuss von außen geschieht gar nichts. Heute tritt keiner der Fälle ein. | niedrig | nein |
| [K10](#k10) | 148 Registry-Zweige früherer Mailverzeichnisse und 537 LaunchManager-Pfade bleiben liegen. [E-157](../Intern/BEFUNDE.md#e-157) verhindert nur neuen Zuwachs. | niedrig | nein |
| [K11](#k11) | Der Prüfstand E146 ist heute um 07:56 in `Eudora.exe` 7.2.0.122 abgestürzt (`c0000409`). Das ist nirgends vermerkt, die Ursache ist unbekannt. An 7.2.0.124 lief derselbe Fall ohne Absturz. Vorschlag E-159. | mittel (ungeklärt) | nein von selbst. Gregor sollte es vor dem Test wissen |
