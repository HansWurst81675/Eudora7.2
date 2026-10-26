# <a id="pruefer-60"></a>PRUEFER-60 — E-137 dritter Teil (Klick auf Titelzeile oder Rand der schwebenden Leiste), nachgerechnet, 26.10.2026

**Auftrag.** Geprüft wurde, was `git log 31a9b11..HEAD -- Eudora71 tools Releases/1.0`
auf dem Zweig `0.123_ergebnisse` zeigt. Im Kern ist das `0b0b50de`
([E-137](../Intern/BEFUNDE.md#e-137), dritter Teil): `QCMiniDockFrameWnd::OnMouseActivate`
in `workbook.cpp:565-597`, die Deklaration in `workbook.h:164` und der dritte
Block in `TestE137.cpp:102-140`. Daneben liegt `c146e9c5` ([E-158](../Intern/BEFUNDE.md#e-158)). Den hat
[PRUEFER-59](PRUEFER-59.md) schon vor sich gehabt (K6), er ist hier nicht neu nachgerechnet.

Eudora wurde weder gebaut noch gestartet. Kein Prüfstand lief. Die
Testsuite lief nur in meinem Arbeitsbaum. Für die Gegenproben habe ich
`workbook.cpp` vorübergehend per Perl (`:raw`) geändert. Danach war die
Datei wieder byte-gleich mit `HEAD` (gemessen mit `cmp`). Gregors
`eudora.log` aus `Eudora72-1.0.124-release` habe ich nur gelesen. Die
MFC-Stellen stammen aus der Quelle auf diesem Rechner
(`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Antwort auf die Kernfrage: Ja, der neue Weg wird erreicht.** Gregor
  klickt mit offener Mail auf die Titelzeile oder den Rand des schwebenden
  Filterfensters. Dann bekommt der kleine Rahmen `QCMiniDockFrameWnd` die
  Nachricht `WM_MOUSEACTIVATE`. Sie kommt **vor** dem eigentlichen Klick
  (`WM_NCLBUTTONDOWN`). Das Abfangen in `SECMiniDockFrameWnd::OnNcLButtonDown`
  kommt also zu spät, um sie zu verschlucken. Der Rahmen ist in diesem Moment
  nicht das aktive Fenster: Die Mail hat den Fokus, aktiv ist das
  Hauptfenster. Weder `MFS_SYNCACTIVE` noch `WS_EX_TOOLWINDOW` verhindern die
  Aktivierung. Das ist am Quelltext belegt, Einzelheiten in Frage 1.
  Gemessen ist es nicht. Am laufenden Programm kann es nur Gregors Test
  bestätigen.
* **Die Suche findet die Leiste.** Im schwebenden Rahmen liegt die Leiste
  genau eine Ebene tief: Rahmen → Andockleiste → Wazoo-Leiste, also ein
  „Enkel“ (am Quelltext belegt). Die Suche über Kinder und Enkel trifft
  sie.
* **Ziehen, Andocken per Doppelklick und Größenänderung bleiben heil.** Der
  Fokus wird gesetzt, bevor das Ziehen beginnt. Das Ziehen selbst hängt
  nicht am Fokus. Eine schwebende Leiste ohne Wazoo-Fenster, etwa eine
  Werkzeugleiste, wird nicht angefasst.
* **Keiner der sechs Funde hält das nächste Testpaket auf.** Alle sind
  niedrig. Der wichtigste ist [K1](#k1): Der neue Test bleibt **grün**, wenn
  die Suche die Leiste gar nicht findet. Gemessen habe ich das mit zwei
  Gegenproben. Der Test sagt also nur, dass der Text da steht, nicht dass er
  wirkt. Das sagt die Commit-Nachricht auch ehrlich.
* **Gegen die Behauptung „am Prüfstand nicht messbar“** ([K2](#k2)): Den
  echten Mausklick kann der Prüfstand nicht erzeugen, das stimmt. Den
  Handler selbst kann er aber messen. Dazu schickt man `WM_MOUSEACTIVATE`
  direkt an das Handle des schwebenden Rahmens. Gemessen würde dann die
  Suche, das Setzen des Fokus und die Protokollzeile. Nur dass Windows die
  Nachricht wirklich schickt, bliebe Gregors Test überlassen.
* **Eine Lücke bleibt, als Vermutung** ([K6](#k6)): Ist der kleine Rahmen
  schon aktiv, liegt der Fokus aber nicht in der Leiste, schickt Windows
  kein `WM_MOUSEACTIVATE` mehr. Dann greift der neue Weg nicht. Einen
  gewöhnlichen Bedienweg in diesen Zustand habe ich nicht gefunden. Einen
  robusteren Weg, der vom Mausweg unabhängig ist, schlage ich in K6 vor.

## Messungen

**Testsuite in meinem Baum** (gemessen): `RunTests.cmd` ergab 312 Tests,
312 bestanden. Alle drei E-137-Tests sind `[ok]`.

**Gegenproben am neuen Test** (gemessen). Jedes Mal wurde `workbook.cpp`
vorübergehend geändert, dann `EudoraTests.exe` gefahren und die Datei
wiederhergestellt. Danach `git show HEAD:… | cmp -`: byte-gleich.

| Probe | Änderung | Erwartet | Ergebnis |
|---|---|---|---|
| G1 | Suche nur unter den Kindern: `FromHandlePermanent(pEnkel->…)` → `FromHandlePermanent(pKind->…)`. Die Leiste wird nie gefunden. | rot | **grün, 312/312** |
| G5 | Sichtbarkeit verneint: `pKandidat->IsWindowVisible()` → `!pKandidat->IsWindowVisible()`. Die Leiste wird nie genommen. | rot | **grün, 312/312** |
| G2 | `ON_WM_MOUSEACTIVATE()` aus der Message-Map von `QCMiniDockFrameWnd` entfernt | rot | rot, 311/312 |

G2 zeigt nebenbei, dass die Testdatei die Quelle aus **diesem** Baum liest.
G1 und G5 sind damit echte Messungen.

**Gregors `eudora.log` an 1.0.124** (gemessen, nur gelesen):

* Erster Durchgang: Der letzte Klick in die Leiste steht in Zeile 362
  (18.14). Danach folgen `E-76 … schwebt=1` (Zeilen 394-442), also Ziehen
  und Größenänderung am schwebenden Rahmen. Bis Zeile 442 steht keine
  `Strg-W`-Zeile mehr. Das passt zum Bild „mal oben, mal seitlich“.
* Zweiter Durchgang: Die Zeilen 1104, 1111 und 1118 sind
  `E-137 Strg-W: Wazoo-Leiste wird versteckt`. **Davor steht keine
  `Klick in Wazoo-Leiste`-Zeile**, nur bei 1111 und 1118 jeweils eine
  Größenänderung (1109f, 1115f). Der Fokus lag also schon in der Leiste,
  vermutlich weil das Öffnen über das Menü ihn dorthin setzt. Die
  Größenänderung hat ihn dort gelassen. Das passt zu
  `CMiniDockFrameWnd::OnMouseActivate`: Am Rand gibt es `MA_NOACTIVATE`
  zurück (`bardock.cpp:793-794`), der Fokus bleibt, wo er war. Das ist
  Vermutung, nur am Ablauf abgelesen.

## Frage 1 — Bekommt der Rahmen bei Klick auf Titelzeile oder Rand `WM_MOUSEACTIVATE`?

**Ja, solange er nicht schon das aktive Fenster ist.** Gregors Fall erfüllt
das.

1. **Wann Windows die Nachricht schickt** (Windows-Verhalten, dokumentiert
   für `WM_MOUSEACTIVATE`, „sent when the cursor is in an inactive window
   and the user presses a mouse button“; nicht gemessen). Bei einem
   Klick prüft das System, ob das getroffene Fenster das aktive ist. Ist es
   das nicht, schickt es zuerst `WM_MOUSEACTIVATE` mit der Trefferzone
   (`HTCAPTION`, `HTLEFT` …) an das getroffene Fenster. Danach kommt je nach
   Rückgabewert die Aktivierung. Erst dann wird `WM_NCLBUTTONDOWN`
   ausgeliefert, außer der Rückgabewert lautet `MA_*ANDEAT`. Bei einem Klick
   auf Titelzeile oder Rand ist das getroffene Fenster der kleine Rahmen
   selbst.
2. **Der Rahmen ist im Fall von Gregor nicht aktiv** (am Quelltext belegt):
   * Beim Abdocken wird er mit `SW_SHOWNA` gezeigt, also ohne Aktivierung
     (`winfrm2.cpp:216`). Positioniert wird er mit `SWP_NOACTIVATE`
     (`winfrm2.cpp:197-198`).
   * Ein Klick in die Leiste aktiviert ihn ausdrücklich nicht:
     `CControlBar::OnMouseActivate` holt schwebend das Hauptfenster nach
     vorn und gibt `MA_NOACTIVATE` zurück (`barcore.cpp:626-636`). Erst das
     `SetFocus` des zweiten Teils (`WazooBar.cpp:1972`) macht ihn
     mittelbar aktiv (Windows-Verhalten von `SetFocus`, Vermutung).
   * Strg+W gibt den Fokus danach an das aktive MDI-Fenster zurück
     (`mainfrm.cpp:3440-3442`). Ein Klick in die Mail tut dasselbe. Dann ist
     wieder das Hauptfenster aktiv.

   Mit offener, angeklickter Mail ist der Rahmen also inaktiv. Der nächste
   Klick auf seine Titelzeile oder seinen Rand löst `WM_MOUSEACTIVATE` aus.
3. **`MFS_SYNCACTIVE` verhindert das nicht** (am Quelltext belegt). Der
   Schalter sorgt nur dafür, dass Haupt- und Kleinrahmen gemeinsam aktiv
   **gezeichnet** werden. `CMiniFrameWnd::OnNcActivate` gibt `TRUE` zurück
   (`winmini.cpp:116-124`). `CFrameWnd::OnActivate` hält das Hauptfenster
   über `WF_STAYACTIVE` „aktiv“ (`winfrm.cpp:1063-1076`). Die wirkliche
   Aktivierung bleibt davon unberührt.
4. **`WS_EX_TOOLWINDOW` verhindert es auch nicht** (am Quelltext belegt,
   `winmini.cpp:93-95`, setzt den Stil bei `WS_CAPTION`). Ein Werkzeugfenster
   lässt sich aktivieren. Verhindern würde das nur `WS_EX_NOACTIVATE`, und
   das setzt niemand (`OTShim.cpp:4732-4734`, `winmini.cpp:87-101`).
5. **`OnNcLButtonDown` fängt nichts vorher ab.**
   `SECMiniDockFrameWnd::OnNcLButtonDown` (`OTShim.cpp:4856-4888`)
   behandelt `WM_NCLBUTTONDOWN`. Diese Nachricht kommt **nach**
   `WM_MOUSEACTIVATE` (Punkt 1). Das `ActivateTopParent()` dort
   (`OTShim.cpp:4860`, `4874`) läuft also erst, wenn der Fokus schon
   gesetzt ist. Es ändert dann nichts mehr: Das Vordergrundfenster ist jetzt
   der kleine Rahmen selbst (`wincore.cpp:2924-2934`).
6. **Die Basisklasse unterdrückt die Nachricht nicht, sie gibt nur einen
   Wert zurück** (am Quelltext belegt). `CMiniDockFrameWnd::OnMouseActivate`
   gibt am Rand `MA_NOACTIVATE` zurück, sonst den Wert von
   `CMiniFrameWnd`/`CWnd`, und zwar `MA_ACTIVATE` (`bardock.cpp:791-796`).
   Der neue Handler ruft sie zuerst und gibt ihren Wert unverändert zurück
   (`workbook.cpp:567`, `596`).
7. **Die Trefferzone ist nie `HTCLIENT`** (am Quelltext belegt). Für
   Titelzeile und Rand liefert `CMiniFrameWnd::OnNcHitTest`
   (`winmini.cpp:127-160`) `HTCAPTION`, `HTLEFT`…`HTBOTTOM` oder `HTCLOSE`.
   Bei gedrückter rechter Taste kommt wegen `MFS_BLOCKSYSMENU` `HTNOWHERE`
   (`winmini.cpp:139-145`). Alle diese Werte nehmen den neuen Zweig.

**Was mit dem Fokus danach geschieht** (am Quelltext belegt, die
Windows-Reihenfolge als Vermutung). Das `SetFocus` im Handler aktiviert den
kleinen Rahmen schon während `WM_MOUSEACTIVATE`.
`CFrameWnd::OnActivate` (`winfrm.cpp:1053-1095`) findet im Kleinrahmen
keine aktive Ansicht, zieht den Fokus also nicht weg. Danach kommt das
`MA_ACTIVATE` aus der Basisklasse auf einen Rahmen, der schon aktiv ist.
Windows setzt den Fokus dann nicht neu. Am Ende liegt er im Wazoo-Fenster.
Strg+W läuft von dort über `CFrameWnd::PreTranslateMessage` des
Kleinrahmens. Weil dessen Besitzer das Hauptfenster ist, geht der Weg weiter
zur Tastenkürzeltabelle des Hauptfensters (`thrdcore.cpp:233`,
`WalkPreTranslateTree`) und endet in `CMainFrame::OnCommand`. Dort greift
`GetWazooBarWithFocus` (`WazooBarMgr.cpp:1019-1038`). Genau diesen Zustand
(„Fokus in der schwebenden Leiste“) hat Gregors Protokoll schon gemessen,
siehe oben: Die `Strg-W`-Zeilen kommen.

**Wäre ein anderer Weg richtiger?** `WM_NCLBUTTONDOWN` im Rahmen sähe
den Klick zwar immer, auch wenn der Rahmen schon aktiv ist. Dafür müsste man
aber in `SECMiniDockFrameWnd::OnNcLButtonDown` vor `StartDrag` eingreifen,
das ist die engere Stelle. `WM_ACTIVATE` sähe dagegen keinen Klick auf den
Rand, denn dort gibt MFC absichtlich `MA_NOACTIVATE` zurück. Der gewählte
Weg ist für Gregors Fall richtig. Die verbleibende Lücke und eine
Ergänzung, die nicht an der Maus hängt, stehen in [K6](#k6).

## Frage 2 — Wo liegt die Leiste, findet die Suche sie?

Am Quelltext belegt:

* `SECMiniDockFrameWnd::Create` legt die Andockleiste `m_wndSECDockBar` an
  und hängt sie mit `SetParent(this)` unter den Rahmen (`OTShim.cpp:4769-4776`).
  Sie ist also ein **Kind** des Rahmens.
* `CFrameWnd::FloatControlBar` sucht sie über `AFX_IDW_DOCKBAR_FLOAT`
  (`winfrm2.cpp:202`) und ruft `DockControlBar` (`winfrm2.cpp:212`).
  `SECDockBar::DockControlBar` reicht das an `CDockBar::DockControlBar`
  weiter (`OTShim.cpp:3088-3092`). Dort steht `pBar->SetParent(this)`
  (`bardock.cpp:178`). Die Wazoo-Leiste ist also ein **Enkel** des Rahmens.
* `CWazooBar` hat Laufzeitinformation (`IMPLEMENT_DYNCREATE`,
  `WazooBar.cpp:40`). Sie ist ein dauerhaftes MFC-Objekt, deshalb liefert
  `FromHandlePermanent` sie. `DYNAMIC_DOWNCAST` trifft sie.

Die Suche findet sie also. Eudoras eigener Code im selben Rahmen holt die
Leiste übrigens direkt mit `m_wndSECDockBar.GetFirstControlBar()`
(`workbook.cpp:617-620`, `RecalcLayout`). Siehe [K5](#k5).

## Frage 3 — Folgewirkungen

Am Quelltext belegt, soweit nicht anders vermerkt:

* **Ziehen per Titelzeile:** `WM_MOUSEACTIVATE` kommt vor
  `WM_NCLBUTTONDOWN`. `SetFocus` ist also abgeschlossen, bevor `StartDrag`
  die Maus fängt (`OTShim.cpp:4867`). Die Ziehschleife hängt an der
  Mauserfassung, nicht am Fokus. Aktiviert wurde der Rahmen bei einem Klick
  auf die Titelzeile schon vorher (`MA_ACTIVATE`). Neu ist nur, **wo** der
  Fokus darin landet: im Wazoo-Fenster statt auf dem Rahmen selbst. Kein
  Fund.
* **Doppelklick zum Andocken:** Der erste Klick setzt den Fokus. Beim
  zweiten ist der Rahmen schon aktiv, es kommt also kein
  `WM_MOUSEACTIVATE`, und `OnNcLButtonDblClk` → `ToggleDocking` läuft wie
  vorher (`OTShim.cpp:4892-4910`). Wo der Fokus danach liegt, ist
  Vermutung: Entweder bleibt er in der jetzt angedockten Leiste, dann
  versteckt Strg+W sie wie im ersten Teil, oder er geht über
  `CFrameWnd::OnActivate` an die Mail zurück (`winfrm.cpp:1084-1094`). Beides
  ist harmlos.
* **Größenänderung am Rand:** Hier gibt MFC absichtlich `MA_NOACTIVATE`
  zurück (`bardock.cpp:793-794`). Das `SetFocus` im neuen Handler aktiviert
  den Rahmen trotzdem. Das will Gregor so („seitlich“). Es ändert aber das
  Verhalten: Siehe [K3](#k3).
* **Schwebende Leisten ohne Wazoo-Fenster:** Alle schwebenden Rahmen des
  Hauptfensters sind `QCMiniDockFrameWnd` (`mainfrm.cpp:1791`), auch die
  der Werkzeugleisten. Dort findet die Suche keine `CWazooBar`, und es
  geschieht nichts außer der Basisklasse. Gibt die Leiste kein aktives
  Wazoo-Fenster her (`GetActiveWazooWindow` liefert `NULL`, wenn der aktive
  Reiter unsichtbar ist, `WazooBar.cpp:383-397`), geschieht ebenfalls
  nichts. Kein Absturz möglich: Alle Zeiger werden geprüft.
* **Schließknopf und Rechtsklick → *Hide*:** Siehe [K4](#k4).

## Frage 4 — Deckt der Test, was er behauptet?

Nein. Er liest den Quelltext und prüft, ob fünf Textstücke in der richtigen
Reihenfolge stehen. Dass Windows die Nachricht schickt, kann er nicht
prüfen. Das sagt auch die Commit-Nachricht. Er prüft aber auch nicht, ob die
Suche die Leiste findet: Er bleibt grün, wenn sie es nicht tut (gemessen,
G1 und G5). Die Überschrift des Tests, „gibt ihr den Tastaturfokus“, sagt
mehr, als er prüft. Siehe [K1](#k1).

## <a id="k1"></a>K1 — Der neue Test bleibt grün, wenn die Suche die Leiste nie findet

**Gemessen.** Zwei Gegenproben, beide `workbook.cpp:576-578`:

* Suche nur unter den Kindern statt unter den Enkeln (G1): grün, 312/312.
* Sichtbarkeitsabfrage verneint (G5): grün, 312/312.

In beiden Fällen findet der Handler zur Laufzeit nie eine Leiste und tut
nichts. Gregor sähe wieder genau sein Fehlerbild. Der Test prüft nur, dass
`DYNAMIC_DOWNCAST(CWazooBar,` irgendwo nach der Abfrage der Trefferzone
steht (`TestE137.cpp:127`), nicht worauf es angewendet wird.

**Vorschlag:** Die Suche als eigene kleine Funktion herausziehen. Die
Testsuite kann sie dann an einem echten Fensterbaum fahren: Popup →
Kind → Enkel. Ersatzweise den Ausdruck vollständig prüfen
(`FromHandlePermanent(pEnkel->GetSafeHwnd())`) und dazu `pKandidat &&
pKandidat->IsWindowVisible()`. Am einfachsten wäre es, die Leiste wie in
`RecalcLayout` über `m_wndSECDockBar.GetFirstControlBar()` zu holen
([K5](#k5)). Dann bleibt keine Suche, die falsch gehen kann.

**Schwere:** niedrig. Die Suche ist heute richtig (Frage 2). Der Test
schützt sie nur nicht.

## <a id="k2"></a>K2 — Den Handler kann der Prüfstand doch messen

**Am Quelltext belegt, als Vorschlag.** Die Commit-Nachricht sagt: „Am
Prüfstand nicht messbar (echter Mausklick auf eine Titelzeile lässt sich
nicht per Fensterbotschaft erzeugen)“. Für die **Entscheidung von Windows**,
`WM_MOUSEACTIVATE` zu schicken, stimmt das. Der **Handler** ist aber ein
gewöhnlicher Nachrichtenempfänger. Ein `SendMessage(hRahmen,
WM_MOUSEACTIVATE, (WPARAM)hHauptfenster, MAKELPARAM(HTCAPTION,
WM_LBUTTONDOWN))` an das Handle des schwebenden Filterrahmens fährt genau
den Code in `workbook.cpp:565-597`. Gemessen würden die Suche, die
Fokusbedingung, `SetFocus` und die Protokollzeile
`E-137 Klick auf den Rahmen der schwebenden Leiste … (Trefferzone 2)`.
Danach zeigt ein `WM_COMMAND ID_FILE_CLOSE` an das Hauptfenster über die
Zeile `E-137 Strg-W`, ob der Fokus in der Leiste liegt. Das ist dieselbe
Technik wie bei den anderen Prüfstandsfällen: Fensterbotschaften an ein
gemessenes Handle, keine Tastendrücke.

Damit würde K1 am Programm abgedeckt. Für Gregors Test bliebe nur die
Frage, ob Windows die Nachricht schickt.

Vermutung, nicht gemessen: `SetFocus` aus einer fremden Nachricht
aktiviert den Rahmen nur im Eudora-Thread. Ein Vordergrundwechsel auf
Gregors Bildschirm entsteht nicht. Das wäre beim ersten Lauf zu beobachten.

**Schwere:** niedrig (Messlücke, kein Fehler).

## <a id="k3"></a>K3 — Größenänderung am Rand holt jetzt den Fokus aus der Mail

**Am Quelltext belegt.** MFC aktiviert den Kleinrahmen beim Ziehen am Rand
absichtlich nicht (`bardock.cpp:793-794`, `MA_NOACTIVATE`). Wer bisher das
schwebende Filterfenster breiter zog, tippte danach weiter in der Mail. Jetzt
liegt der Fokus nach dem Ziehen im Filterfenster
(`workbook.cpp:583-591`). Das `SetFocus` aktiviert den Rahmen trotz
`MA_NOACTIVATE`. Das ist Windows-Verhalten von `SetFocus`, also
Vermutung.

Gregor hat genau das verlangt: „mal seitlich“ geklickt, dann Strg+W, und
das Filterfenster soll gehen. Deshalb ist das kein Fehler, nur eine
Verhaltensänderung. Sie gehört in die Prüfanweisung zu T1: „Rand ziehen,
dann tippen: Die Eingabe geht ins Filterfenster, nicht in die Mail.“

**Schwere:** niedrig (gewollte Verhaltensänderung, nicht beschrieben).

## <a id="k4"></a>K4 — Schließknopf und Rechtsklick → *Hide* setzen den Fokus in eine Leiste, die gleich danach verschwindet

**Am Quelltext belegt bis zum Verstecken, danach Vermutung.** Der Klick auf
den Schließknopf (`HTCLOSE`) und der Rechtsklick auf die Titelzeile
(`HTNOWHERE`, `winmini.cpp:143-144`) laufen beide durch den neuen Zweig.
Der Fokus geht also zuerst in die Leiste. Gleich danach versteckt
`SECMiniDockFrameWnd::OnClose` (`OTShim.cpp:4842-4845`) bzw.
*Hide* die Leiste. Wo der Fokus dann liegt, ist der offene Zustand aus
[PRÜFER-55 K3](PRUEFER-55.md#k3): möglicherweise in einem unsichtbaren
Fenster. Ein zweites Strg+W täte dann nichts.

Vorher war es kaum anders. Dort aktivierte `MA_ACTIVATE` den Rahmen, und der
Fokus lag auf dem Rahmen, der ebenfalls verschwand. Verschlechtert hat sich
also vermutlich nichts. Wird der Kleinrahmen beim Verstecken mit
ausgeblendet, gibt Windows die Aktivierung an das Hauptfenster zurück, und
die Mail bekommt den Fokus wieder (`winfrm.cpp:1084-1094`). Das habe ich
nicht bis zum Ende nachgerechnet.

**Vorschlag:** `HTCLOSE` vom neuen Zweig ausnehmen. Wer schließt, will die
Leiste nicht bedienen.

**Schwere:** niedrig (Vermutung).

## <a id="k5"></a>K5 — Kommentar beschreibt einen Weg, den es nicht gibt; die Leiste lässt sich direkt holen

**Am Quelltext belegt.** Der Kopfkommentar in `workbook.cpp:561-563` sagt:
„Klicks IN die Leiste (HTCLIENT, von der Leiste an den Rahmen
weitergereicht) bleiben bei CWazooBar::OnMouseActivate.“ Weitergereicht wird
nichts. `CControlBar::OnMouseActivate` gibt schwebend `MA_NOACTIVATE`
zurück, **ohne** `Default()` zu rufen (`barcore.cpp:626-636`). Damit endet
die Kette an der Leiste. Der Rahmen sieht Klicks in die Leiste gar nicht.
Die Abfrage `nHitTest != HTCLIENT` ist deshalb nur eine Absicherung. Sie
schadet nicht.

Dazu kommt: Die Suche über Kinder und Enkel macht etwas nach, was der Rahmen
schon weiß. `m_wndSECDockBar.GetFirstControlBar()` liefert die Leiste
direkt. So macht es Eudoras eigener Code drei Funktionen weiter
(`workbook.cpp:617-620`).

**Schwere:** sehr niedrig (Kommentar und Stil).

## <a id="k6"></a>K6 — Ist der Rahmen schon aktiv, der Fokus aber nicht in der Leiste, greift der Weg nicht

**Vermutung, Ablauf am Quelltext belegt.** `WM_MOUSEACTIVATE` kommt nur,
wenn der kleine Rahmen **nicht** das aktive Fenster ist (Frage 1,
Punkt 1). Es gibt einen Zustand, in dem er aktiv ist und der Fokus trotzdem
auf dem Rahmen selbst liegt statt in der Leiste. Dann führt der nächste
Klick auf Titelzeile oder Rand am neuen Handler vorbei, und Strg+W schließt
wieder die Mail.

Erreichbar ist dieser Zustand, soweit ich sehe, nur so: Der neue Zweig hat
beim ersten Klick nichts getan, weil `GetActiveWazooWindow` `NULL`
lieferte. Dann hat `MA_ACTIVATE` den Rahmen aktiviert, und `DefWindowProc`
hat den Fokus auf den Rahmen gesetzt. Einen gewöhnlichen Bedienweg dorthin
habe ich nicht gefunden. In Gregors Protokoll gibt es keinen Hinweis
darauf.

**Vorschlag, falls T1 an 7.2.0.125 noch einmal nein ergibt:** zusätzlich in
`CMainFrame::OnCommand` (`mainfrm.cpp:3431-3443`) die Abfrage erweitern. Ist
das Fokusfenster ein `QCMiniDockFrameWnd` oder liegt es darin, wird die
`CWazooBar` dieses Rahmens versteckt. Dieser Weg hängt nicht an der Maus,
sondern nur an dem, was beim Tastendruck den Fokus hat. Er deckte auch alle
anderen Wege ab, auf denen der Rahmen den Fokus bekommt.

**Schwere:** niedrig (Vermutung, kein Bedienweg gefunden).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| Frage 1 | Klick auf Titelzeile oder Rand des schwebenden Filterfensters erreicht den neuen Handler. Gregors Fall ist abgedeckt (am Quelltext belegt, am Programm nur durch seinen Test zu bestätigen). | — | nein |
| [K1](#k1) | Der neue Test bleibt grün, wenn die Suche die Leiste nie findet (gemessen, zwei Gegenproben). Heute ist die Suche richtig. | niedrig | nein |
| [K2](#k2) | Der Handler ließe sich am Prüfstand mit einer Fensterbotschaft messen. „Nicht messbar“ gilt nur für den echten Mausklick. | niedrig | nein |
| [K3](#k3) | Wer das schwebende Filterfenster am Rand größer zieht, tippt danach ins Filterfenster, nicht mehr in die Mail. Gewollt, aber nirgends beschrieben. | niedrig | nein |
| [K4](#k4) | Schließknopf und Rechtsklick → *Hide* setzen den Fokus kurz in die Leiste, die gleich verschwindet. Vermutlich nicht schlechter als vorher. | niedrig | nein |
| [K5](#k5) | Ein Kommentar beschreibt eine Weitergabe, die es nicht gibt. Die Leiste ließe sich direkt holen statt suchen. | sehr niedrig | nein |
| [K6](#k6) | Ist der Rahmen schon aktiv, der Fokus aber nicht in der Leiste, greift der Weg nicht. Einen Bedienweg dorthin habe ich nicht gefunden. | niedrig | nein |
