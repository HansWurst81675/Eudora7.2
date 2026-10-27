# <a id="pruefer-61"></a>PRUEFER-61 — E-137 vierter Anlauf und E-160, nachgerechnet, 27.10.2026

**Auftrag.** Geprüft wurde, was `git log d1b1024..HEAD -- Eudora71 tools Releases/1.0`
auf `0.125_ergebnisse` zeigt. Im Kern ist das `73f706a5`: der vierte Anlauf zu
[E-137](../Intern/BEFUNDE.md#e-137) (`workbook.cpp`, `workbook.h`, `TestE137.cpp`)
und die Behebung von [E-160](../Intern/BEFUNDE.md#e-160) (`OLImportClass.cpp`,
`TestE160.cpp`). Dazu kommen `469742da` ([E-137](../Intern/BEFUNDE.md#e-137) nach [PRUEFER-60](PRUEFER-60.md#pruefer-60)), `46707a76`
(fehlendes `#include`), `6ef9fa8d` (Fassungsnummer) und `1e819254`
(Prüfstandsprotokoll). Die drei letzten sind nur durchgesehen.

Eudora wurde weder gebaut noch gestartet. Kein Prüfstand lief. Die
Testsuite lief nur in meinem Arbeitsbaum. Für eine Messung an MFC habe ich ein
kleines Konsolenprogramm im Scratchpad übersetzt. Es öffnet kein Fenster. Die
MFC-Stellen stammen aus der Quelle auf diesem Rechner
(`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`). Gregors Verzeichnis
`Eudora72-1.0.125-release` enthält kein `eudora.log` mehr. Für „keine
E-137-Zeile“ stütze ich mich deshalb auf den Nachtrag in BEFUNDE und TESTPLAN.

**Ergebnis vorweg.**

* **Der vierte Anlauf hält nicht. Antwort: nein.** Der schwebende Rahmen um
  das Filterfenster ist **kein** `QCMiniDockFrameWnd`. Er ist der gewöhnliche
  MFC-Rahmen `CMiniDockFrameWnd`. Deshalb läuft weder `OnMouseActivate` noch
  das neue `OnNcLButtonDown`. Keine einzige Zeile von [E-137](../Intern/BEFUNDE.md#e-137) Teil 3 wird je
  ausgeführt. Auch die neue Spurzeile wird nie geschrieben ([K1](#k1)).
* **Warum das so ist, in einem Satz:** Eudora setzt die Rahmenklasse in
  `mainfrm.cpp:1791`. Fünfzehn Zeilen später ruft es `EnableDocking`
  (`mainfrm.cpp:1806`). Über unseren Shim landet das in MFCs
  `CFrameWnd::EnableDocking`, und diese Funktion überschreibt die Klasse
  ausnahmslos mit `RUNTIME_CLASS(CMiniDockFrameWnd)` (`winfrm2.cpp:51`).
  **Gemessen** ist das an MFC selbst (siehe Messungen). Die Kette in Eudora
  ist am Quelltext belegt.
* **Das erklärt Gregors Protokoll vollständig:** Nach dem Klick auf den Rahmen
  stand keine E-137-Zeile im Log. Es erklärt auch, warum die Mail zuging. Das
  gilt für 1.0.125 und genauso für den neuen Stand.
* **[PRUEFER-60](PRUEFER-60.md#pruefer-60) lag hier falsch.** Ich hatte die Rahmenklasse aus
  `mainfrm.cpp:1791` und dem Kommentar in `OTShim.h:993-994` übernommen. Den
  Aufruf danach habe ich nicht nachgerechnet. Die Vorhersage „wird
  erreicht“ war deshalb unbegründet.
* **Eine Behebung ist klein, aber nicht harmlos** ([K2](#k2)). Der Shim
  müsste in `SECMDIFrameWnd::EnableDocking` eine vorher gesetzte Klasse
  stehen lassen. Damit liefe aber zum ersten Mal in der Portierung der ganze
  Zweig `QCMiniDockFrameWnd`/`SECMiniDockFrameWnd` mit `SECDockBar` als
  schwebender Andockleiste. Der war bisher nie in Betrieb. Ein Weg mit
  weniger Risiko steht in K2: Strg+W in `CMainFrame::OnCommand` am
  schwebenden Rahmen erkennen, der den Fokus hält.
* **[E-160](../Intern/BEFUNDE.md#e-160) behebt Gregors Fall. Es schneidet aber vermutlich Anwender mit
  Outlook 2013 oder neuer vom Outlook-Import ab** ([K3](#k3)). Diese
  Outlook-Fassungen legen ihre Profile nicht mehr unter dem Schlüssel ab, den
  `FindMainOLKey` prüft. Am Quelltext ist das belegt, mit der Microsoft-Doku
  begründet, am Programm nicht gemessen.
* **Hält etwas das Paket 7.2.0.126 auf? Ja, K1.** Es hält das Paket auf,
  solange es [E-137](../Intern/BEFUNDE.md#e-137) als „zu testen“ führt. Gregor würde U1 ein drittes Mal
  ohne jede Aussicht testen. Entweder kommt K2 vorher hinein, oder [E-137](../Intern/BEFUNDE.md#e-137) wird
  im Paket ausdrücklich nicht zum Test angeboten. K3 hält ein Testpaket nicht
  auf, muss aber vor 7.2.1 entschieden werden.

## Messungen

**Testsuite in meinem Baum** (gemessen): `RunTests.cmd` ergab 313 Tests,
313 bestanden. Die drei E-137-Tests und der E-160-Test sind `[ok]`.

**MFC überschreibt die Rahmenklasse** (gemessen). Das Programm
`probe.cpp` liegt im Scratchpad und ist mit `cl /MD /D_AFXDLL` gegen dieselbe
MFC 14.38 übersetzt. Es leitet von `CMDIFrameWnd` ab und setzt
`m_pFloatingFrameClass` auf eine eigene, von `CMiniDockFrameWnd` abgeleitete
Klasse. Dann ruft es `CMDIFrameWnd::EnableDocking(0)`. Mit 0 entsteht keine
Andockleiste und kein Fenster. Das ändert nichts, denn die Zuweisung steht in
`winfrm2.cpp:51` vor der Schleife und gilt ohne Bedingung. Ausgabe:

```
vor EnableDocking:  CEigenerRahmen
nach EnableDocking: CMiniDockFrameWnd
```

**Die Kette in Eudora** (am Quelltext belegt):

| Schritt | Stelle |
|---|---|
| Rahmenklasse wird gesetzt | `mainfrm.cpp:1790-1791` `m_pFloatingFrameClass = RUNTIME_CLASS(QCMiniDockFrameWnd);` |
| danach im selben `OnCreate` | `mainfrm.cpp:1806` `EnableDocking(CBRS_ALIGN_ANY);` |
| `CMainFrame::EnableDocking` | `mainfrm.cpp:2354-2372`, legt `QCDockBar` an und ruft `QCWorkbook::EnableDocking` |
| `QCWorkbook` → `SECWorkbook` → `SECMDIFrameWnd` | keine eigene Fassung in `workbook.h:177` / `OTShim.h:1490`; `SECMDIFrameWnd::EnableDocking` in `OTShim.cpp:276-279` |
| Shim reicht durch | `CMDIFrameWnd::EnableDocking(dwDockStyle);` — `CMDIFrameWnd` hat keine eigene Fassung, es ist `CFrameWnd::EnableDocking` |
| MFC überschreibt | `winfrm2.cpp:51` `m_pFloatingFrameClass = RUNTIME_CLASS(CMiniDockFrameWnd);` |
| jede Schwebe-Erzeugung liest das Feld | `CreateFloatingFrame` `winfrm2.cpp:29-40`; Aufrufer: `FloatControlBar` `winfrm2.cpp:195` (Abdocken, Ziehen) und `SetDockState` `dockstat.cpp:468` (Wiederherstellen beim Start) |
| später wird es nie wieder gesetzt | einzige Zuweisung im Baum ist `mainfrm.cpp:1791` (Suche über `Eudora71/Eudora` und `OTShim`) |

`CreateFloatingFrame` ist in MFC 14.38 nicht virtuell (`afxwin.h:4240`), und
`CMainFrame` überschreibt sie nicht. Es gibt also keinen Umweg, auf dem die
Eudora-Klasse doch noch entstünde.

Das `ASSERT(NULL == m_pFloatingFrameClass)` in `mainfrm.cpp:1790` lässt
vermuten, dass das Original anders lief. Das echte OT 5.01 setzte die Klasse
in seinem `SECMDIFrameWnd::EnableDocking` vermutlich nur, wenn sie noch leer
war. **Vermutung:** Die Quelle `swinmdi.cpp` liegt nicht im Repo, nur der
Kopf `OT501/Include/swinmdi.h:80`.

## Frage (a) — Warum lief `OnMouseActivate` nicht oder schrieb nichts?

Es lief nicht, weil es das Objekt nicht gibt. Die Message-Map von
`QCMiniDockFrameWnd` ist richtig: `workbook.cpp:532-537`, mit
`ON_WM_MOUSEACTIVATE` und `ON_WM_NCLBUTTONDOWN`, dazu die Kette
`SECMiniDockFrameWnd` → `CMiniDockFrameWnd`. Die Fabrik ist auch richtig:
`IMPLEMENT_DYNCREATE` in `workbook.cpp:49`. Nur fragt die Fabrik niemand mehr,
nachdem `EnableDocking` die Klasse ersetzt hat. Der schwebende Rahmen ist ein
`CMiniDockFrameWnd`. Seine Message-Map (`bardock.cpp:784-789`) kennt weder die
E-137-Behandler noch irgendetwas aus `SECMiniDockFrameWnd`.

Abgefangen wird vorher nichts. Das musste ich nicht weiter verfolgen, weil die
Behandler nicht in der Klasse des Fensters stehen.

**Folge für den Test.** `TestE137.cpp` liest nur Quelltext. Er bleibt grün,
solange die Funktionen dastehen. Ob die Klasse je erzeugt wird, prüft er
nicht. Das ist dieselbe Lücke wie [PRUEFER-60 K1](PRUEFER-60.md#k1), nur eine
Ebene höher.

## Frage (b) — Erreicht `OnNcLButtonDown` den Klick, und kommt Strg+W dann zur Leiste?

**Heute nicht**, aus demselben Grund wie in (a).

**Wenn der Rahmen richtig erzeugt würde** (am Quelltext belegt, ein Teil
Vermutung):

* Bei Titelzeile und Rand kommt `WM_NCLBUTTONDOWN` an den Rahmen.
  `FokusInDieLeiste` läuft **vor** `SECMiniDockFrameWnd::OnNcLButtonDown`
  (`workbook.cpp:599-605`), also vor `ActivateTopParent` und vor der
  Zieh- oder Größenschleife (`OTShim.cpp:4856-4889`).
* Der Weg von Strg+W ist schon gemessen. Gregors Protokoll an 1.0.124 zeigte
  `E-137 Klick in Wazoo-Leiste` und gleich danach `E-137 Strg-W`
  ([PRUEFER-60](PRUEFER-60.md)). Liegt der Fokus in der Leiste, übersetzt die
  Zugriffstabelle des Hauptrahmens die Tasten zu `ID_FILE_CLOSE`.
  `CMainFrame::OnCommand` (`mainfrm.cpp:3431-3445`) findet die Leiste über
  `GetWazooBarWithFocus` und versteckt sie.

**Was heute nach dem Klick passiert** (Vermutung, gestützt auf MFC und
Windows-Doku). Ein Klick auf die Titelzeile aktiviert den
`CMiniDockFrameWnd`: sein `OnMouseActivate` gibt nur für die Ränder
`MA_NOACTIVATE` zurück (`bardock.cpp:791-796`). Beim Aktivieren setzt Windows
den Fokus auf den Rahmen selbst, weil er vorher außerhalb lag. Strg+W geht
dann vom Rahmen über seinen Besitzer an den Hauptrahmen. Dort ist
`GetWazooBarWithFocus` leer, denn der Rahmen ist nicht Kind der Leiste,
sondern ihr Elternfenster (`WazooBarMgr.cpp:1019-1038`). Also bekommt das
aktive MDI-Fenster den Befehl, und die Mail geht zu. Das ist genau Gregors
Bild.

## Frage (c) — Kann der Fokus sofort wieder weggenommen werden?

Heute ist die Frage gegenstandslos. Für die Behebung in [K2](#k2) zählt sie
aber (Vermutung, am Quelltext begründet):

* **Titelzeile:** Der Rahmen ist danach aktiv. `ActivateTopParent`
  (`wincore.cpp:2924-2934`) tut nichts, wenn der Rahmen das Vordergrundfenster
  ist. `CDockContext` arbeitet mit `SetCapture` und setzt keinen Fokus. Beim
  Loslassen ohne Bewegung verschiebt `FloatControlBar` den Rahmen nur, mit
  `SWP_NOACTIVATE` (`winfrm2.cpp:165-180`). Hier ist kein Fokusraub zu sehen.
* **Rand:** `MA_NOACTIVATE`. `SetFocus` auf ein Kind des inaktiven Rahmens
  aktiviert diesen Rahmen. Danach ist er das Vordergrundfenster, und
  `ActivateTopParent` tut wieder nichts. Ein Rest ist ungewiss: Die
  Synchronisation `MFS_SYNCACTIVE`/`WF_STAYACTIVE` (`winfrm.cpp:1053-1079`)
  könnte den Hauptrahmen reaktivieren, und dessen `WM_SETFOCUS` reicht den
  Fokus an die Mail weiter.
* **Empfehlung:** Eine zweite Spurzeile **nach** dem Basisaufruf, die
  `GetFocus()` nennt. Erst sie zeigt am Programm, ob der Fokus geblieben ist.

## Frage (d) — Schreibt die Spur vor jeder Entscheidung?

Fast. `FokusInDieLeiste` (`workbook.cpp:571-590`) steigt bei `HTCLIENT` und
`HTCLOSE` aus, **bevor** die Spur geschrieben wird. Alle anderen
Entscheidungen fallen erst nach `PutDebugLog`. Für U1 ist der stille Ausstieg
unschädlich. Ein Klick auf die Titelzeile ist `HTCAPTION`, einer auf den Rand
liegt zwischen `HTSIZEFIRST` und `HTSIZELAST`. Das Gegenstück zur Frage, ob
die Funktion überhaupt läuft, fehlt aber: eine Zeile **beim Erzeugen** des
Rahmens. Mit ihr hätte schon 1.0.125 im Protokoll gezeigt, dass kein
`QCMiniDockFrameWnd` entsteht (siehe [K1](#k1), Vorschlag 2).

## <a id="k1"></a>K1 — Der schwebende Rahmen ist nie ein `QCMiniDockFrameWnd`; E-137 Teil 3 läuft in keinem Paket

**Was passiert.** Gregor klickt auf Titelzeile oder Rand des schwebenden
Filterfensters und drückt Strg+W. Die Mail geht zu, das Filterfenster bleibt.
Im Protokoll steht nichts von [E-137](../Intern/BEFUNDE.md#e-137). Daran ändert der vierte Anlauf nichts.
Auch der dritte Anlauf (1.0.125) konnte nicht greifen.

**Belegt:** siehe Messungen. Gemessen ist das Überschreiben durch MFC, am
Quelltext belegt ist die Aufrufkette in Eudora.

**Mitbetroffen** (am Quelltext belegt): Jeder Eudora-Code, der für den
schwebenden Rahmen geschrieben wurde, läuft ebenfalls nie. Das ist
`QCMiniDockFrameWnd::RecalcLayout` in beiden Fassungen (`workbook.cpp:614-700`,
Fenstertitel über `CWazooBar::RefreshWindowTitle`) und der ganze
`SECMiniDockFrameWnd` im Shim (`OTShim.cpp:4700-4920`). Der Kommentar in
`OTShim.h:993-994` („setzt sie über `CFrameWnd::m_pFloatingFrameClass` ein“)
beschreibt eine Absicht, nicht den Zustand. **Vermutung:** Auch das Bild von
[E-76](../Intern/BEFUNDE.md#e-76) („lässt sich nur zur Seite vergrößern“)
kann damit zusammenhängen, weil der MFC-Rahmen eine `CDockBar` statt einer
`SECDockBar` trägt. Gemessen ist das nicht.

**Unsicherer Cast** (am Quelltext belegt, Folgen Vermutung): `QC3DTabWnd.cpp:286`
castet `pWazooBar->m_pDockBar` hart auf `SECDockBar*`. Davor steht nur
`ASSERT_KINDOF`, und das ist im Release nichts. Bei einer schwebenden Leiste
ist das heute eine `CDockBar`. Erreicht wird die Stelle nur, wenn man das
letzte Register per Drag-and-Drop aus einer schwebenden Leiste zieht. Der
Shim-Rumpf `SECDockBar::RemoveControlBar` (`OTShim.cpp:3113`) ruft
`NormalizeBarArray` und `FindBar`, die vermutlich nur `CDockBar`-Felder
anfassen. Ein Absturz ist nicht belegt.

**Vorschläge.**

1. Behebung: siehe [K2](#k2).
2. Spur beim Erzeugen. Direkt nach `EnableDocking` in `mainfrm.cpp` eine
   Protokollzeile mit `m_pFloatingFrameClass->m_lpszClassName`, oder eine
   Zeile in `QCMiniDockFrameWnd::Create`. Dann sagt jedes künftige Protokoll
   beim Start, welcher Rahmen entsteht.
3. Ein Test, der **läuft** statt liest. Die Testsuite linkt MFC
   (`TestE160.cpp` bindet `afx.h` ein). Das Muster aus `probe.cpp`, angewandt
   auf `SECMDIFrameWnd` aus dem Shim, prüft, dass die vorher gesetzte Klasse
   `EnableDocking` übersteht. Ob der Testbau `OTShim.cpp` einbinden kann, habe
   ich nicht geprüft.

**Schwere: hoch.** Es geht nichts verloren. Aber die Behebung, die zum dritten
Mal zum Test geht, kann nicht wirken, und Gregors Testzeit geht dafür drauf.
**Hält das Paket auf: ja**, solange 7.2.0.126 [E-137](../Intern/BEFUNDE.md#e-137) (U1) zum Test anbietet.

## <a id="k2"></a>K2 — Die naheliegende Behebung schaltet ungeprüften Shim-Code ein

**Die naheliegende Behebung** (am Quelltext belegt, ungetestet): in
`SECMDIFrameWnd::EnableDocking` (`OTShim.cpp:276-279`)

```cpp
CRuntimeClass* pVorher = m_pFloatingFrameClass;
CMDIFrameWnd::EnableDocking(dwDockStyle);
if (pVorher != NULL)
    m_pFloatingFrameClass = pVorher;
```

**Das Risiko** (Vermutung, nicht gemessen): Damit entsteht jede schwebende
Leiste neu als `QCMiniDockFrameWnd`, mit einer `SECDockBar(TRUE, FALSE)` statt
einer `CDockBar` (`OTShim.cpp:4715-4780`). Betroffen wären:

* Wiederherstellen schwebender Leisten aus der INI beim Start
  (`dockstat.cpp:468`);
* `SECDockBar::OnSize` mit dem Trennbalken aus [E-52](../Intern/BEFUNDE.md#e-52) in einem schwebenden
  Rahmen;
* Ziehen, Größe ändern und Andocken per Doppelklick über die Shim-Fassungen
  (`OTShim.cpp:4856-4910`);
* Schließen über ×, im Shim als `ShowAll(FALSE)`;
* das `ASSERT(pBar != NULL)` in `QCMiniDockFrameWnd::RecalcLayout`, im
  Release ohne Wirkung.

Nichts davon ist in dieser Portierung je gelaufen. Nach der Lehre „nie
benutzt ist nicht geprüft“ müsste Gregor dann den ganzen Bereich „schwebende
Fenster“ neu testen, nicht nur U1.

**Ein Weg mit weniger Risiko** (Vermutung, gestützt auf (b)): den Rahmen in
Ruhe lassen und Strg+W dort fangen, wo es schon ankommt. In
`CMainFrame::OnCommand` bei `ID_FILE_CLOSE` (`mainfrm.cpp:3431`) zusätzlich
prüfen: Ist `GetFocus()` ein `CMiniDockFrameWnd`
(`DYNAMIC_DOWNCAST(CMiniDockFrameWnd, CWnd::GetFocus())`, das trifft auch die
Eudora-Klasse), dann über `GetDlgItem(AFX_IDW_DOCKBAR_FLOAT)` die erste Leiste
holen, und ist sie eine sichtbare `CWazooBar`, mit `ID_SEC_HIDE` verstecken.
Das wirkt unabhängig von der Rahmenklasse und unabhängig davon, ob ein
Mausweg ankommt. Mit einer Spurzeile, die Fokusfenster und Klasse nennt,
misst Gregors nächster Test zugleich, ob die Annahme „Fokus liegt auf dem
Rahmen“ stimmt.

Die beiden Behandler aus `73f706a5` kann man stehen lassen (heute
wirkungslos) oder zurücknehmen. Entscheiden muss das, wer behebt.

**Schwere: mittel** (Risiko der Behebung, kein Fehler im Bestand).
**Hält das Paket auf: nein**, ist aber bei der Behebung von K1 zu
entscheiden.

## <a id="k3"></a>K3 — E-160 sperrt vermutlich Outlook 2013 und neuer vom Import aus

**Was passiert** (am Quelltext belegt, Folge nicht gemessen):
`FindMainOLKey` prüft drei Schlüssel unter `HKCU` (`OLImport.rc:124-131`):

* `Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles`
* `Software\Microsoft\Office\8.0\Outlook\OMI Account Manager`
* `Software\Microsoft\Office\Outlook\OMI Account Manager`

Seit Outlook 2013 liegen die Profile laut Microsoft-Doku unter
`Software\Microsoft\Office\15.0\Outlook\Profiles` bzw. `16.0`. Das ist
außerhalb des Repos belegt, hier nicht gemessen. Ein solcher Anwender hat
keinen der drei Schlüssel.

**Vorher** lief er trotzdem bis `MAPILogon` und `MAPIAdminProfiles`. Seine
Profile erschienen als Quelle mit Postfächern und Adressbuch
(`OLImportClass.cpp:343-366`, Zweig `else AddProfiles(..., MBOX_ABOOK)`). Der
Kommentar in Zeile 355 sieht genau diesen Fall vor: Profile ohne
Registry-Eintrag dürfen Post und Adressbuch, aber keine Persönlichkeit
importieren. **Jetzt** endet er in `OLImportClass.cpp:310-311`, und Outlook
erscheint im Import nicht mehr.

**Einschränkung** (Vermutung): Eudora ist ein 32-Bit-Programm. Seit Outlook
2019 wird Outlook meist als 64-Bit-Fassung installiert, und dessen MAPI kann
ein 32-Bit-Prozess nicht laden. Betroffen wären also vor allem Anwender mit
32-Bit-Outlook 2013 bis 365. Ob der Import dort vorher wirklich ging, ist
nicht gemessen. Auf diesem Rechner gibt es kein Outlook-Profil (gemessen: der
`16.0\Outlook\Profiles`-Schlüssel fehlt). Den Gegenfall kann ich hier nicht
fahren.

**Vorschlag.** Den Ausstieg auf die neuen Profilorte erweitern: zusätzlich
`Software\Microsoft\Office\15.0\Outlook\Profiles` und
`...\16.0\Outlook\Profiles` prüfen. Ist einer da, wird MAPI wie früher
geladen. Gregors Fall ohne Outlook bleibt dann behoben.

**Schwere: mittel** (eine Funktion fällt für eine Anwendergruppe still weg,
nichts geht verloren). **Hält das Paket auf: nein**, ist aber vor 7.2.1 von
Gregor zu entscheiden.

## <a id="k4"></a>K4 — E-160: der Rest des Ausstiegs ist vollständig; zwei Randbemerkungen

Am Quelltext belegt:

* **Aufrufer.** `FindMainOLKey` hat genau einen Aufrufer,
  `LoadOLProvider` (`OLImportClass.cpp:255`). Den ruft nur der Export
  `LoadProvider` (`OLImport.cpp:35-44`), den Eudora für jedes `.eif` über
  `MAPIImport.cpp:1129` holt. Der Rückgabewert wird nicht ausgewertet;
  `LoadProvider` fragt `GetNumProviderChildren()`. Ohne `AddProvider` liefert
  er `NULL`, wie vorher bei einem fehlgeschlagenen `MAPILogon`.
* **Aufräumen.** Der neue Ausstieg liegt vor `LoadLibrary` (`:694`). Es ist
  also nichts freizugeben. Das `hKey` aus `RegOpenKeyEx` wird nie
  geschlossen. Das ist Original und betrifft nur den Fall mit Treffer.
* **Weitere MAPI-Wege** bleiben unverändert: `LoadFolders` (`:601`) und
  `Convert` (`:2830`). Sie laufen nur, wenn der Anwender ausdrücklich
  importiert, etwa aus einer `.pst`-Datei. Dort kann Gregors Windows-Meldung
  ohne Outlook weiterhin kommen. Das ist vertretbar, denn ohne MAPI geht
  dieser Import ohnehin nicht. Für Persona → Neu sind sie nicht im Weg.
* **Nebenwirkung, die jetzt wegfällt:** `MAPILogon` schreibt
  `HKLM\Software\Clients\Mail` = „Microsoft Outlook“ (`:739`). Bisher
  versuchte das jeder Kontoassistent auch ohne Outlook. Ohne Adminrechte
  scheitert der Schreibversuch still. Mit dem Ausstieg geschieht er ohne
  Outlook nicht mehr. Das ist ein Gewinn.
* **Anwender mit einem der drei alten Schlüssel:** Für sie ist das Verhalten
  byte-gleich zu vorher, denn die Bedingung ist dann falsch.

**Schwere: keine** (Bestätigung). **Hält das Paket auf: nein.**

## <a id="k5"></a>K5 — Durchgesehene Nebencommits

* `46707a76`: `workbook.cpp` war von `0b0b50de` bis hierher nicht
  übersetzbar (C2027). [PRUEFER-60](PRUEFER-60.md#pruefer-60) hat das nicht bemerkt, weil ich nicht
  gebaut habe. Für Behebungen, die neue Typen benutzen, gehört ein Bau der
  einen Datei zur Prüfung.
* `6ef9fa8d`: nur `Version.h` 124 → 125, folgerichtig.
* `1e819254`: nur `tools/TESTLAEUFE.md`.
* `469742da`: in `73f706a5` aufgegangen, siehe oben.

**Schwere: sehr niedrig.** **Hält das Paket auf: nein.**

## Neue Kennung

**E-161** (vorgeschlagen, nicht in BEFUNDE eingetragen): „Schwebende Leisten
entstehen im MFC-Rahmen `CMiniDockFrameWnd` statt in `QCMiniDockFrameWnd`,
weil `CFrameWnd::EnableDocking` die Rahmenklasse überschreibt. Der ganze
Eudora- und Shim-Code für schwebende Rahmen läuft nie.“ Das ist [K1](#k1). Ob
es ein eigener Befund wird oder ein Nachtrag zu [E-137](../Intern/BEFUNDE.md#e-137), entscheidet, wer
einträgt. E-162 ist nicht vergeben.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Das schwebende Filterfenster ist ein MFC-Rahmen, nicht Eudoras eigener. Beide E-137-Behandler laufen nie, auch die neue Spur nicht. Strg+W schließt weiter die Mail. MFC-Verhalten gemessen, Kette am Quelltext belegt. | hoch | **ja**, solange 7.2.0.126 U1 zum Test anbietet |
| [K2](#k2) | Die naheliegende Behebung (Klasse im Shim bewahren) schaltet nie gelaufenen Shim-Code für alle schwebenden Fenster ein. Ein Weg mit weniger Risiko: Strg+W in `CMainFrame::OnCommand` am Rahmen mit Fokus erkennen. | mittel | nein, aber bei der Behebung von K1 zu entscheiden |
| [K3](#k3) | [E-160](../Intern/BEFUNDE.md#e-160) schließt vermutlich Anwender mit (32-Bit-)Outlook 2013 und neuer vom Outlook-Import aus, weil deren Profile unter einem Schlüssel liegen, den die Prüfung nicht kennt. | mittel | nein, vor 7.2.1 entscheiden |
| [K4](#k4) | [E-160](../Intern/BEFUNDE.md#e-160) ist sonst vollständig: ein Aufrufer, nichts aufzuräumen, mit altem Outlook-Schlüssel unverändert. | keine | nein |
| [K5](#k5) | Nebencommits durchgesehen. `workbook.cpp` war einen Commit lang nicht übersetzbar, von [PRUEFER-60](PRUEFER-60.md#pruefer-60) übersehen. | sehr niedrig | nein |
