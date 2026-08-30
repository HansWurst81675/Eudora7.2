# Befund M-1 — die Menues lassen sich nicht oeffnen (Sperrbefund S-5)

Bearbeiter: MENUE. Stand: 2026-08-30.
Grundlage: **reine Quellcodeanalyse**, kein Programmstart, keine Laufzeitmessung.

Gregors Beobachtung: „in eudora kann ich keine menues oeffnen“, auf Nachfrage
„nichts, kleine reaktion“. Spaeterer Zusatz: die Menues haetten
**zwischendurch funktioniert**, welcher Bau das war, ist nicht mehr feststellbar.

---

## 1. Ursache — gefunden, behoben

### Die Fundstelle

`Eudora71/Eudora/mainfrm.cpp:8662-8671`

```
LRESULT CMainFrame::OnNcHitTest(CPoint point)
{
	ASSERT(m_pControlBarManager != NULL);
	ASSERT_KINDOF(SECToolBarManager, m_pControlBarManager);

	if(!((SECToolBarManager*)m_pControlBarManager)->IsMainFrameEnabled())
		return QCWorkbook::OnNcHitTest(point);
	else
		return (UINT)HTERROR;
}
```

`ON_WM_NCHITTEST()` steht in der Nachrichtentabelle von `CMainFrame`
(mainfrm.cpp:533), der Behandler laeuft also bei **jedem** `WM_NCHITTEST` auf
das Rahmenfenster.

Gegenstueck in der Ersatzschicht, vor der Aenderung:

`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:3480` und `:3506` (beide Konstruktoren)

```
	m_bMainFrameEnabled = TRUE;
```

`SECToolBarManager::IsMainFrameEnabled()` (OTShim_Werkzeugleiste.cpp:3750)
liefert diesen Wert unveraendert zurueck. Damit lieferte
`CMainFrame::OnNcHitTest` **immer** `HTERROR`.

### Warum das genau dieses Krankheitsbild erzeugt

`HTERROR` ist wie `HTNOWHERE`, nur dass `DefWindowProc` zusaetzlich piepst.
Windows schickt `WM_NCHITTEST` an das jeweils **tiefste** Fenster unter dem
Zeiger. Fuer Punkte ueber Werkzeugleisten, Wazoo-Fenstern und MDI-Kindern sind
das eigene Fensterklassen mit eigenem Hit-Test — die bleiben also heil. Das
Rahmenfenster selbst wird nur fuer seine **eigene** Nichtklientenflaeche
gefragt, und das ist genau:

* die **Menueleiste**,
* die Titelzeile mit Systemmenue und den Knoepfen Minimieren/Maximieren/Schliessen,
* die Rahmenkanten zum Groessenaendern.

Ein Klick auf „File“ erreicht damit nie `WM_NCLBUTTONDOWN` mit `HTMENU`, also
nie `WM_SYSCOMMAND`/`SC_MOUSEMENU`, also nie den Menuemodus. Das Menue klappt
nicht auf. Die von Gregor beschriebene „kleine Reaktion“ passt zum Piepser, den
`DefWindowProc` bei `HTERROR` ausloest (UNGEPRUEFT, ob es genau das war).

### Der Beweis, dass `TRUE` nicht der Normalzustand sein kann

Die Kopfdatei des Originals behauptet das Gegenteil:

`Eudora71/OT501/Include/tbarmgr.h:79-80`
> „Returns TRUE if the mainframe is currently enabled. FALSE if we are in
> customize-mode and we are pretending that it is disabled.“

`tbarmgr.h:213`
> `BOOL m_bMainFrameEnabled; // TRUE if EnableMainFrame called`

Genau dieser Prosatext hat den Autor der Ersatzschicht in die Irre gefuehrt.
**Eudora liest den Wert aber andersherum.** Alle fuenf Abfragestellen sind
untereinander stimmig, und zwei davon sagen es im Klartext:

| Stelle | Verhalten bei `TRUE` | Beleg |
| --- | --- | --- |
| mainfrm.cpp:2987-2992 | `WM_SYSCOMMAND`/`SC_CLOSE` wird geschluckt | Kommentar: „Stop the application closing **with a customize dialog still active**“ |
| mainfrm.cpp:8667-8670 | `WM_NCHITTEST` liefert `HTERROR` | — |
| mainfrm.cpp:8678 | `m_nFlags &= ~WF_STAYACTIVE` | — |
| mainfrm.cpp:8726 | `m_nFlags &= ~WF_STAYACTIVE` | — |
| mainfrm.cpp:8742-8752 | verzoegertes `RecalcLayout` bei `MSGF_DIALOGBOX` | Kommentar: „**We have a customize dialog up.** … we don't get these while a dialog is displayed“ |

Dazu die einzige Setzstelle in Eudora selbst:
`Eudora71/Eudora/QCToolbarCmdPage.cpp:117` ruft `EnableMainFrame()` in
`OnSetActive()` der **Anpassen-Seite**, mit dem Kommentar „Re-enable the main
frame - so toolbar buttons can be dragged“.

Zusammengesetzt heisst `TRUE` also: *„der Anpassen-Dialog steht offen und wir
haben den Rahmen darin wieder freigegeben, damit Knoepfe herausgezogen werden
koennen — dafuer machen wir seine Chromflaeche kuenstlich tot.“*

Der Schlussstein ist ein Widerspruchsbeweis: waere `TRUE` der Normalzustand,
haette schon **Eudora 7.1** eine tote Menueleiste, eine tote Titelzeile und
einen nicht mit der Maus verschiebbaren Hauptrahmen gehabt. Eudora 7.1 lief.
Also ist `FALSE` der Normalzustand, und der Ausgangswert der Ersatzschicht war
falsch.

`HTERROR` kommt im ganzen Baum genau einmal vor: mainfrm.cpp:8670.
(gemessen mit `grep -rn HTERROR Eudora71/`)

### Was geaendert wurde

Alles in `Eudora71/OTShim/OTShim_Werkzeugleiste.{h,cpp}`, byte-erhaltend
(CR-Anzahl gleich LF-Anzahl vor und nach der Aenderung nachgemessen):

1. **Beide Konstruktoren** (`:3480`, `:3506`): `m_bMainFrameEnabled = FALSE;`
   — das ist die eigentliche Behebung.
2. **Kommentar an `IsMainFrameEnabled()`** berichtigt; er behauptete bisher die
   Lesart der Stingray-Kopfdatei.
3. **Kommentar am Datenmember** in der Kopfdatei ergaenzt.
4. **`DisableMainFrame()`**: der Waechter `if (!m_bMainFrameEnabled || …)`
   haette den Rumpf mit dem richtigen Ausgangswert nie laufen lassen — beim
   Betreten des Anpassen-Dialogs ist der Schalter `FALSE`. Jetzt
   `if (m_pFrameWnd == NULL || m_enabledList.GetSize() > 0)`.
   Die Methode wird von Eudora nicht aufgerufen; die Aenderung ist heute
   wirkungslos und dient nur der Stimmigkeit.
5. **Neu: `SECToolBarManager::RestoreMainFrame()`** (nicht im Original) und ein
   Aufruf in `SECToolBarCmdPage::~SECToolBarCmdPage()`.
   Grund: `EnableMainFrame()` ist die **einzige** Stelle, die den Schalter auf
   `TRUE` setzt, und **nichts** setzt ihn wieder zurueck. Ohne Rueckweg waere
   die Menueleiste nach dem ersten Besuch von „Tools → Customize Toolbars“
   erneut tot, bis Eudora neu gestartet wird. Die Anpassen-Seiten liegen in
   `QCToolBarManager::OnCustomize` auf dem Stapel (QCToolBarManager.cpp:1042-1104),
   ihr Destruktor markiert also genau das Ende des Anpassen-Zustands.

### Bauzustand

`MSBuild Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug /p:Platform=Win32
/p:BuildProjectReferences=false` — **uebersetzt fehlerfrei**, nur Warnungen.
Das Binden bricht mit `LNK1104: imap.lib` ab; das ist eine Folge von
`BuildProjectReferences=false` und hat mit dieser Aenderung nichts zu tun
(Imapdll wurde nicht mitgebaut).

### Falsifizierbare Vorhersage fuer Gregor (kostet keinen Debugger)

Wenn M-1 die Ursache war, dann waren im kaputten Bau **ausser** den Menues auch
kaputt:

* Fenster am Titelbalken **verschieben** ging nicht,
* Groesse durch **Ziehen an den Rahmenkanten** ging nicht,
* die Knoepfe **Minimieren / Maximieren / Schliessen** oben rechts reagierten nicht,
* **Alt+F / Alt+E** (Menue ueber Tastatur) hat dagegen **funktioniert** — die
  laeuft ueber `WM_SYSCOMMAND`/`SC_KEYMENU` und nicht ueber den Hit-Test.

Trifft das zu, ist der Befund bestaetigt. Trifft es *nicht* zu — insbesondere
wenn der Titelbalken normal ging —, dann ist M-1 zwar trotzdem ein echter
Fehler, aber nicht (allein) die Ursache von S-5, und die Suche muss weiter.

---

## 2. Was ausgeschlossen ist (mit Beleg)

**Die MDI-Menueverschmelzung ist in Ordnung.**
Die schon vorliegende Messung passt Punkt fuer Punkt auf eine normale, von
`user32` erweiterte MDI-Rahmenmenueleiste: Eintrag 0 ohne Beschriftung mit
**9** Untereintraegen ist das Systemmenue des maximierten Kindes
(Wiederherstellen, Verschieben, Groesse, Minimieren, Maximieren, Trenner,
Schliessen, Trenner, Naechstes); die Eintraege 11-13 ohne Beschriftung und ohne
Untermenue sind die drei Bitmapknoepfe, die `MDI_AugmentFrameMenu` anhaengt.
Waere die Verschmelzung kaputt, gaebe es diese vier Eintraege gar nicht.
`SECWorkbook::CreateClient` (OTShim.cpp:833-869) ruft zuerst
`CMDIFrameWnd::CreateClient` und prueft `m_hWndMDIClient` — das MDI-Klientfenster
entsteht also regulaer, samt `hWindowMenu`.

**Kein Fokusdieb und keine fremde Erfassung in der Ersatzschicht.**
`grep -rn "SetCapture|ReleaseCapture|SetFocus|SetActiveWindow|SetForegroundWindow|WM_CANCELMODE|OnCancelMode" Eudora71/OTShim/*.cpp`
findet ausschliesslich den Ziehen-und-Ablegen-Pfad der Werkzeugleiste
(OTShim_Werkzeugleiste.cpp:2843, 2852, 2885, 2912-2922). Kein Zeitgeber-, Leerlauf-,
`RecalcLayout`-, `OnSize`- oder `OnPaint`-Pfad ruft etwas davon.

**Keine Zeitgeberaufgabe, die den Menuemodus stoert.**
`CMainFrame::OnTimer` (mainfrm.cpp:1837-1891) hat zwei Faelle:
`AUTOACTIVATE_TIMER_EVENT_ID` wird nur beim Ziehen-und-Ablegen gesetzt
(mainfrm.cpp:8446) und ist ohne Registerkartenbetrieb ohnehin wirkungslos;
`GENERAL_BACKGROUND_TIMER_ID` (mainfrm.cpp:2030) tut nur etwas, wenn
`gbAutomationCommandQueued` gesetzt ist.

**Der MFC-Leerlauf laeuft waehrend des Menuemodus gar nicht.**
Die Menueschleife steckt in `user32`; `CWinThread::Run` und damit `OnIdle`
sind blockiert. Windows schickt statt dessen `WM_ENTERIDLE`.
`CMainFrame::OnEnterIdle` (mainfrm.cpp:8737-8755) tut nur bei
`nWhy == MSGF_DIALOGBOX` etwas — bei einem Menue ist `nWhy == MSGF_MENU`.
Damit sind alle Leerlaufthesen (auch die Werbe-These) fuer den Menuemodus
gegenstandslos.

**Kein `SetMenu` zur Laufzeit** — war schon gemessen, unveraendert gueltig.

**`SECDockState` verhaelt sich bei leerer INI korrekt.**
`SECDockState` (OTShim.cpp:3644-3690) reicht Konstruktor, `Serialize`,
`LoadState`, `SaveState` und `Clear` unveraendert an `CDockState` weiter.
Steht kein Abschnitt in der INI, liest `CDockState::LoadState` null Leisten;
`state.m_arrBarInfo` bleibt leer, die Schleife in
`CMainFrame::FinishInitAndShowWindow` (mainfrm.cpp:843-866) laeuft null Mal,
`bSearchBarConfigInINI` bleibt `false`, und die Suchleiste wird ohne
`DockControlBar` erzeugt. Das ist genau der vorgesehene Erstlauf-Weg.
**Kein** Weg dort erzeugt eine Leiste mit Groesse 0 oder ausserhalb des Rahmens.
Die eigentliche Andockrechnung (`CalcFixedLayout`, `NormalizeRow`) habe ich
absprachegemaess **nicht** angefasst — die gehoert ANSICHT.

---

## 3. Offen: der Widerspruch zur Zustandsabhaengigkeit

Gregors Hinweis, die Menues haetten zwischendurch funktioniert, passt **nicht**
zu M-1: `m_bMainFrameEnabled` wird im Konstruktor gesetzt und danach nur noch
von `EnableMainFrame()` beruehrt, das ausschliesslich aus dem Anpassen-Dialog
kommt. M-1 ist damit vom Umgebungszustand (INI, Leistenzustand) **unabhaengig**.

Drei Moeglichkeiten, alle UNGEPRUEFT:

1. Der Bau, in dem es ging, lag **vor** `91716bb` („OT501-Ersatzschicht Stufe 3:
   Werkzeugleisten und Knoepfe“) — das ist der Commit, der
   `m_bMainFrameEnabled = TRUE` eingefuehrt hat
   (`git log -S m_bMainFrameEnabled -- Eudora71/OTShim/OTShim_Werkzeugleiste.cpp`).
   Das laesst sich pruefen, sobald die EXE eine Kennung traegt.
2. Gregor hat damals die Tastatur benutzt (Alt+Buchstabe) — die geht bei M-1
   weiter, siehe die Vorhersage oben.
3. Es gibt **zusaetzlich** einen zweiten, zustandsabhaengigen Defekt. Dann
   bleibt M-1 trotzdem zu beheben, weil er sonst die Suche danach verdeckt.

---

## 4. Nebenbefund: der Zweig war veraltet

Mein Arbeitsbaum stand anfangs auf `origin/main` (`22a6d77`). Dort bricht der
Bau schon an `secbtns.h(340,83): error C2572` ab — der in README.md:29 und
WEITERMACHEN.md:46 beschriebene, laengst behobene Fehler. Der lebende Stand ist
`eudora-exe-linkt` (`31810e2`). Ich habe umgesetzt und die Aenderung dort neu
aufgebracht. **Wer einen Arbeitsbaum aufmacht, muss ihn auf `eudora-exe-linkt`
setzen, nicht auf `main`.**

---

## Stand und naechster Schritt

**Stand:** M-1 ist gefunden, belegt und behoben; die Uebersetzung ist
fehlerfrei durchgelaufen (Binden scheitert nur an nicht mitgebautem
`imap.lib`). Nicht geprueft ist die Wirkung im laufenden Programm — ich darf
Eudora nicht starten.

**Was als naechstes zu tun waere, in dieser Reihenfolge:**

1. **Gregor die vier Fragen aus Abschnitt 1 stellen** (Titelbalken verschieben,
   Rahmen ziehen, Fensterknoepfe, Alt+F). Sie entscheiden ohne Debugger, ob
   M-1 die Ursache von S-5 war. Das ist die billigste Messung, die es hier gibt.
2. Neu bauen und den Menueklick probieren.
3. Faellt M-1 als Ursache aus, ist die naechste Spur **`WM_SYSCOMMAND`**:
   `CMainFrame::OnSysCommand` (mainfrm.cpp:5226-5234) reicht alles ausser
   `ID_SYSTEM_MENU_CHECKMAIL` an `CFrameWnd::OnSysCommand` weiter — auffaellig
   ist, dass dort **`CFrameWnd`** und nicht `CMDIFrameWnd`/`QCWorkbook` steht.
   Ob `CMDIFrameWnd` `WM_SYSCOMMAND` ueberhaupt eigens behandelt, habe ich
   **nicht** geprueft. Prueforte: `CMainFrame::PreTranslateMessage`
   (mainfrm.cpp:2978 ff., schluckt `SC_CLOSE`) und
   `CPgFixedCompMsgView::WindowProc` (PgFixedCompMsgView.cpp:468-516), das
   `SC_KEYMENU` gezielt abfaengt.
4. Danach die owner-drawn Menueeintraege: `CMainFrame::OnMeasureItem`
   (mainfrm.cpp:3288-3330) und `OnDrawItem` (mainfrm.cpp:3334-3398). Beide
   reichen den Rest an `QCWorkbook::OnMeasureItem`/`OnDrawItem` weiter, also an
   `SECWorkbook` → `CWnd`. Liefert das fuer einen `MF_OWNERDRAW`-Eintrag die
   Groesse 0, klappt ein Menue mit solchen Eintraegen unsichtbar auf. Betroffen
   waeren aber nur „Message“ (Labels, Emoticons) und Plugin-Eintraege, **nicht**
   „File“ — deshalb steht das hinten.
5. `CMainFrame::InitMenus` (mainfrm.cpp:7303) benutzt
   `GetTopMenuByPosition(MAIN_MENU_EDIT)` usw. (mainfrm.cpp:9492). Wenn
   `InitMenus` erst laeuft, **nachdem** ein MDI-Kind maximiert wurde, sind alle
   Positionen um eins verschoben, weil `MDI_AugmentFrameMenu` das Systemmenue
   des Kindes an Position 0 einfuegt. Das ergaebe falsche, nicht tote Menues —
   deshalb ganz hinten, aber es ist einen Blick wert.
