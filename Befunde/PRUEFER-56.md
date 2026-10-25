# <a id="pruefer-56"></a>PRUEFER-56 — Die Nachbesserung von E-137 nach PRUEFER-55, nachgerechnet gegen die Quelle, 25.10.2026

**Auftrag.** Kurzlauf. Geprüft wurde, was `git diff 39244831..39d348d8 -- Eudora71 tools`
zeigt: die Nachbesserung von [E-137](../Intern/BEFUNDE.md#e-137) in
`CMainFrame::OnCmdMsg` (`Eudora71/Eudora/mainfrm.cpp`) und der nachgeschärfte
Test `Eudora71/Tests/TestE137.cpp` (`424966f6`), nach den Funden
[PRUEFER-55 K1–K3](PRUEFER-55.md#pruefer-55). Die Änderungen in `tools/` sind nur
Protokollzeilen. Eudora wurde weder gebaut noch gestartet. Die Testsuite lief
nur in meinem Arbeitsbaum. Die MFC-Stellen sind in der Quelle nachgelesen, die
auf diesem Rechner liegt (`VC/Tools/MSVC/14.38.33130/atlmfc/src/mfc`).

**Ergebnis vorweg.**

* **Die Behebung von [E-137](../Intern/BEFUNDE.md#e-137) kommt beim Filter- und beim Adressbuch-Register
  vermutlich gar nicht zum Zug** ([K1](#k1), am Quelltext belegt, nicht
  gemessen). Strg-W läuft zuerst durch `CMainFrame::OnCommand`. Das gibt den
  Befehl an das Wazoo-Fenster weiter, **bevor** `OnCmdMsg` mit der Abfangung
  überhaupt drankommt. Das Filter-Register reicht ihn an sein Dokument weiter.
  Das Dokument schickt `WM_CLOSE` an das Rahmenfenster über seiner Ansicht.
  Bei der angedockten Leiste ist das das Hauptfenster, und Eudora geht zu. Bei
  der schwebenden Leiste ist es der kleine Schwebe-Rahmen, und nur die Leiste
  geht zu. Das ist genau das, was Gregor beobachtet hat. Damit ist auch die
  offene Frage aus [E-137](../Intern/BEFUNDE.md#e-137) beantwortet, wer Eudora beendet.
* **Bei den anderen Registern schließt Strg-W vermutlich das aktive
  Postfach** ([K1](#k1)), etwa `In`. Das Hauptfenster gibt den Befehl zuerst
  an das aktive MDI-Fenster. Die Abfangung wird erst erreicht, wenn kein
  MDI-Fenster offen ist.
* **Die Übergabe des Schwerpunkts ([PRUEFER-55](PRUEFER-55.md#pruefer-55) K3) ist für sich richtig, läuft
  aber fast nie** ([K3](#k3)). `SetFocus` kommt vor dem verzögerten
  Verstecken. Der MDI-Rahmen gibt den Schwerpunkt an seine Ansicht weiter.
  Erreicht wird die Zeile aber nur, wenn ein offenes MDI-Fenster den Befehl
  nicht selbst nimmt.
* **Der Test sieht weiterhin fünf von neun Rückfällen nicht** ([K2](#k2),
  gemessen). K1 kann er gar nicht sehen, denn er liest nur `OnCmdMsg`.
* **`IsWindowVisible()` verfehlt keine sichtbare Leiste.** Die Ersatzschicht
  kennt keine eingeklappte Leiste, und ein minimiertes Hauptfenster zählt als
  sichtbar. Das ist kein Fund.
* **Keiner der Funde hält das Release 7.2.1.x auf**, nach Gregors Vorgabe vom
  23.10. K1 ist kein Rückschritt, denn es bleibt beim alten Verhalten. Aber
  **[E-137](../Intern/BEFUNDE.md#e-137) darf nicht als behoben gelten**, weder in BEFUNDE.md noch in den
  Release-Hinweisen, bis Gregor es am laufenden Programm gesehen hat.

**Testsuite** (gemessen, in meinem Baum): 302 Tests, 302 bestanden, vor und
nach allen Rückfallproben. `mainfrm.cpp` war nach jeder Probe byte-gleich
zurück (SHA-1 verglichen), danach `touch`.

## <a id="k1"></a>K1 — Die Abfangung sitzt hinter zwei früheren Weitergaben

**Weg eines Strg-W** (am Quelltext belegt). Die Taste ist auf `ID_FILE_CLOSE`
gelegt (`EudoraRes.rc:364`). `TranslateAccelerator` schickt `WM_COMMAND` an
das Hauptfenster. MFC ruft dort zuerst `CMainFrame::OnCommand` auf, nicht
`OnCmdMsg`:

1. `CMainFrame::OnCommand` (`mainfrm.cpp:3395`) sucht das Wazoo-Fenster mit
   dem Schwerpunkt und gibt ihm den Befehl per `AfxCallWndProc`
   (`mainfrm.cpp:3408-3417`). Wird er dort erledigt, ist Schluss.
2. Sonst geht er weiter an `QCWorkbook::OnCommand` (`mainfrm.cpp:3446`), das
   über `SECMDIFrameWnd::OnCommand` (`OTShim.cpp:527-530`) bei
   `CMDIFrameWnd::OnCommand` ankommt. Das schickt ihn **zuerst an das aktive
   MDI-Fenster** (MFC `winmdi.cpp:41-45`, Kommentar dort: „send to MDI child
   first“).
3. Erst danach kommt `CFrameWnd::OnCommand` → `CWnd::OnCommand` →
   `CMainFrame::OnCmdMsg` mit der Abfangung (`mainfrm.cpp:3483-3505`).

**Schritt 1 beim Filter- und Adressbuch-Register:**
`CFiltersWazooWnd::OnCmdMsg` gibt jeden Befehl an die aktive Teilansicht weiter
(`FiltersWazooWnd.cpp:95-105`), `CNicknamesWazooWnd::OnCmdMsg` ebenso
(`NicknamesWazooWnd.cpp:93-102`). Die Ansichten sind `CFormView`
(`filtersv.h:199`, `:326`) und tragen sich in ihr Dokument ein
(`filtersv.cpp:196`, `:984`; `nickview.cpp:364`, `:1661`). `CView::OnCmdMsg`
reicht den Befehl an das Dokument weiter (MFC `viewcore.cpp:167-173`).
`CFiltersDoc` und `CNicknamesDoc` erben von `CDoc` (`filtersd.h:295`,
`nickdoc.h:270`), und `CDoc` behandelt `ID_FILE_CLOSE` (`doc.cpp:109`).
`CDoc::OnFileClose` schickt `WM_CLOSE` an `View->GetParentFrame()`
(`doc.cpp:144-149`). `GetParentFrame` steigt die Elternkette hoch bis zum
ersten Rahmenfenster (MFC `wincore.cpp:2842-2850`). Die Kette ist: Ansicht →
Teilerfenster → Wazoo-Fenster → `CWazooBar` (eine `SECControlBar`,
`WazooBar.h:60`) → `SECDockBar` (eine `CDockBar`, `OTShim.h:737`) →

* **angedockt:** `CMainFrame`. Das Hauptfenster bekommt `WM_CLOSE`, und
  Eudora beendet sich.
* **schwebend:** `SECMiniDockFrameWnd` (eine `CMiniDockFrameWnd`, also ein
  Rahmenfenster, `OTShim.h:1014`). Nur der Schwebe-Rahmen bekommt `WM_CLOSE`.

Das deckt sich mit Gregors Eingrenzung vom 25.10. (*„beim nicht angedockten
fenster wird es ganz regulär geschlossen, sonst nicht“*). Gemessen ist es
nicht. Die frühere Zählung in [E-137](../Intern/BEFUNDE.md#e-137) („keine Wazoo-Fensterklasse behandelt
ihn“) stimmt für die Nachrichtentabellen. Sie übersieht aber die Weitergabe
über `OnCmdMsg` an Ansicht und Dokument.

**Schritt 2 bei den übrigen Registern** (Postfächer, Filterbericht,
Linkverlauf und so weiter): Wird der Befehl in Schritt 1 nicht erledigt, geht
er an das aktive MDI-Fenster. Ist das ein Postfach (`CTocDoc` erbt von
`CDoc`, `tocdoc.h:106`), schließt Strg-W **das Postfach** und nicht die
Leiste. Die Abfangung in `OnCmdMsg` wird nur erreicht, wenn kein MDI-Fenster
offen ist oder das aktive den Befehl nicht nimmt.

**Was verloren gehen kann.** Dasselbe wie vor der Behebung: Eudora beendet
sich über den gewöhnlichen Weg `WM_CLOSE` an das Hauptfenster. Ob es dabei
nach ungesicherten Verfassen-Fenstern fragt, ist nicht gemessen.

**Möglicher Ausweg.** Die Abfangung an den Anfang von `CMainFrame::OnCommand`
setzen, vor `GetWazooWindowWithFocus` (`mainfrm.cpp:3408`). Oder
`ID_FILE_CLOSE` in den beiden Wazoo-`OnCmdMsg` nicht an die Ansicht
weitergeben. Der Regressionstest muss dann `OnCommand` lesen.

**Schwere:** wichtig (wie [E-137](../Intern/BEFUNDE.md#e-137) selbst). Der gemeldete Fehler besteht
vermutlich unverändert, und der Befund steht als „behoben“ im Testpaket.
**Release:** hält nicht auf. Es ist kein Rückschritt gegenüber 7.2.0.x. Gregor
hat am 23.10. entschieden, dass selbst kritische Funde 7.2.1.0 nicht aufhalten.

## <a id="k2"></a>K2 — Der nachgeschärfte Test sieht fünf von neun Rückfällen nicht

Gemessen. Ich habe `mainfrm.cpp` jeweils an einer Stelle vorübergehend
geändert (Perl, `:raw`, genau ein Treffer), die Suite laufen lassen und dann
die Originaldatei zurückkopiert (SHA-1 gleich, `touch`). Die Zahl der Tests
blieb bei jeder Probe 302.

| Probe | Änderung | Wirkung im Programm | Test |
|---|---|---|---|
| q1 | `pAktiv && pAktiv->IsWindowVisible()` → `pAktiv && !pAktiv->IsWindowVisible()` | der Schwerpunkt wird nie übergeben | **grün** |
| q2 | `pAktiv = MDIGetActive();` → `pAktiv = NULL;` | der Schwerpunkt wird nie übergeben | **grün** |
| q3 | `&& pFokusLeiste->IsWindowVisible()` → `&& !pFokusLeiste->IsWindowVisible()` | die Abfangung greift nur noch bei versteckter Leiste | **grün** |
| q4 | `nCode == CN_COMMAND \|\| ` entfernt | der Befehl wird nicht abgefangen | rot (301/302) |
| q5 | `pHandlerInfo == NULL` → `!= NULL` | die Leiste wird nie versteckt | rot |
| q6 | `GetWazooBarWithFocus()` → `NULL` | die Abfangung greift nie | rot |
| q7 | `&& pFokusLeiste->IsMDIChild()` an die Bedingung angehängt | die Abfangung greift nie | **grün** |
| q8 | `pAktiv->SetFocus();` → `pAktiv->GetSafeHwnd();` | der Schwerpunkt wird nie übergeben | rot |
| q9 | `if (0)` vor `PostMessage(WM_COMMAND, ID_SEC_HIDE, 0)` | die Leiste wird nie versteckt | **grün** |

Die drei Rückfälle aus [PRUEFER-55](PRUEFER-55.md#pruefer-55), die den alten Fehler zurückbrachten, fängt
der Test jetzt (q4 bis q6). Er sucht aber weiter nur Textstücke in
Reihenfolge, und `"pFokusLeiste->IsWindowVisible()"` steckt auch in der
Verneinung (q3). Ob die Bedingung greifen kann und ob der Aufruf auch
ausgeführt wird, prüft er nicht (q7, q9). Vor allem prüft er nicht, ob
`OnCmdMsg` für Strg-W überhaupt erreicht wird ([K1](#k1)). Sein Kopf
behauptet in Punkt 1, die Abfangung komme „BEVOR der Befehl an das
Wazoo-Fenster … weitergereicht wird“ (`TestE137.cpp:13-14`). Das gilt nur
innerhalb von `OnCmdMsg`.

**Schwere:** niedrig (Prüfwerkzeug).

## <a id="k3"></a>K3 — Die Übergabe des Schwerpunkts stimmt, wird aber kaum erreicht

**Reihenfolge** (am Quelltext belegt). `PostMessage(WM_COMMAND, ID_SEC_HIDE)`
(`mainfrm.cpp:3498`) stellt das Verstecken in die Warteschlange. `SetFocus`
(`:3501`) läuft sofort. Der Schwerpunkt ist also schon aus der Leiste heraus,
wenn `SECControlBar::OnHide` → `ShowControlBar` sie später mit
`SWP_HIDEWINDOW` versteckt (MFC `winfrm.cpp:1390-1392`). Dabei setzt niemand
den Schwerpunkt zurück, weder `OnHide` (`OTShim.cpp:2491-2498`) noch MFC.

**Kommt er in der Ansicht an?** Ja, am Quelltext belegt.
`CFrameWnd::OnSetFocus` gibt den Schwerpunkt an `m_pViewActive` weiter (MFC
`winfrm.cpp:1359-1365`). Kein Eudora-Rahmen überschreibt `OnSetFocus` (die
Treffer der Suche sind nur Ansichten und Bedienelemente). Bei der
**schwebenden** Leiste liegt `pAktiv` in einem anderen Hauptfenster als die
Leiste. Dass Windows dabei das Hauptfenster aktiviert, ist eine Vermutung und
nicht gemessen.

**Ohne MDI-Fenster** ist `pAktiv` NULL, und der Schwerpunkt bleibt in der
Leiste. Ob Windows ihn beim Verstecken an das Elternfenster gibt, ist nicht
gemessen. Bleibt er dort, scheitert das nächste Strg-W an
`IsWindowVisible()` und läuft den alten Weg. Bei den Registern, bei denen die
Abfangung überhaupt greift (siehe [K1](#k1)), führt das ins Leere: Kein
Wazoo-Fenster und kein MDI-Fenster nimmt den Befehl, und `0xE102` liegt nicht
im Bereich `0xF000`, den `CMDIFrameWnd::OnCommand` an `DefWindowProc` gibt
(MFC `winmdi.cpp:53`). Das ist harmlos.

**Warum die Zeile kaum läuft.** Ist ein MDI-Fenster offen, nimmt es Strg-W
schon in Schritt 2 von [K1](#k1), sofern sein Dokument von `CDoc` erbt. Das
tun alle zehn Dokumentklassen, die die Suche nach `public CDoc` findet.
`pAktiv->SetFocus()` läuft deshalb nur, wenn das aktive MDI-Fenster den
Befehl nicht nimmt (Vermutung: so ein Fenster gibt es kaum).

**Schwere:** niedrig, kein Datenverlust.

## Gegenvermutung: verfehlt `IsWindowVisible()` eine sichtbare Leiste?

Nein, soweit es am Quelltext geht. `IsWindowVisible` ist wahr, wenn die
Leiste und alle Vorfahren `WS_VISIBLE` tragen. Eine eingeklappte Leiste gibt es
in der Ersatzschicht nicht: Die Suche nach `collaps` in `OTShim.cpp` und
`OTShim.h` findet nichts. Ein minimiertes Hauptfenster behält `WS_VISIBLE`.
Eine Leiste, deren Anzeige nur verzögert ist (`DelayShow`), kann der Anwender
noch nicht angeklickt haben. Das ist kein Fund.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Release 7.2.1.x auf? |
|---|---|---|---|
| [K1](#k1) | Strg-W kommt bei der Abfangung von [E-137](../Intern/BEFUNDE.md#e-137) nicht an. Im angedockten Filter- oder Adressbuch-Register beendet es Eudora vermutlich weiterhin. Bei anderen Registern schließt es das aktive Postfach (am Quelltext belegt, nicht gemessen). | wichtig | nein (kein Rückschritt). [E-137](../Intern/BEFUNDE.md#e-137) darf aber nicht als behoben gelten. |
| [K2](#k2) | Der nachgeschärfte Test bleibt bei fünf von neun eingebauten Rückfällen grün, und K1 sieht er gar nicht (gemessen). | niedrig (Prüfwerkzeug) | nein |
| [K3](#k3) | Die Übergabe des Schwerpunkts ist richtig angeordnet, läuft wegen K1 aber fast nie. Ohne MDI-Fenster bleibt der Schwerpunkt vermutlich in der Leiste, was harmlos ist. | niedrig | nein |
