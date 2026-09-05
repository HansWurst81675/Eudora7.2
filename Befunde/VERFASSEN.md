# E-16 — Absturz beim Verfassen (Strg-N) und „Encountered an improper argument"

Agent VERFASSEN, 05.09.2026. Branch `wt/verfassen`.

Gregor, 05.09.2026, Debug-Bau 7.2.0.5:

> „wenn man eine neue mail schreiben möchte (ctrl-N) stürzt eudora ab!"

```
Debug Assertion Failed!
Program: C:\Users\Gregor\Eudora72-1.0.5-debug\mfc140d.dll
File: ...\ATLMFC\Include\afxcoll.inl
Line: 213
```

Dieselbe Sache im Release-Bau als Meldungsfenster „Encountered an improper
argument".

---

## 1. Was die Zeilennummer festlegt — und was sie ausschließt

`afxcoll.inl` ist nicht mehrdeutig. In der hier verwendeten Werkzeugkette
(`C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.38.33130\atlmfc\include\afxcoll.inl`)
steht:

| Zeile | Funktion |
|-------|----------|
| 202 | `CPtrArray::GetAt` |
| 207 | `CPtrArray::SetAt` |
| **213** | **`CPtrArray::ElementAt`** |
| 256 | `CObArray::ElementAt` |
| 304 | `CStringArray::ElementAt` |

**Zeile 213 ist die Zusicherung in `CPtrArray::ElementAt` — sonst nichts.**
Das grenzt die Suche hart ein:

* Es ist ein **`CPtrArray`**, kein `CObArray`, kein `CStringArray`.
* Es ist der **nicht-konstante** `operator[]` bzw. ein ausdrückliches
  `ElementAt`. In einer `const`-Methode landet `feld[i]` bei `GetAt`
  (Zeile 202), nicht bei 213.

Damit fallen alle Sammlungen weg, die nur über `GetAt` angefasst werden — unter
anderem die Übersetzer-/Plugin-Felder in `trnslate.h`
(`CTranslatorArray`, `CTransAPIArray`, `CAttachArray`, `CSpecialArray`,
`CMboxCMArray`): sie leiten zwar von `CPtrArray` ab, verdecken aber `GetAt`
und werden ausschließlich darüber benutzt.

Ebenso fallen weg:
`SECWorkbook::m_worksheets` (`CObArray`), `SECTabWndBase::m_pTabArray`
(`CObArray`), `SECDockBar::m_arrEdges`/`m_arrSplitters` (`CObArray`),
`CDockState::m_arrBarInfo` (nur in begrenzten Schleifen),
`SECToolBarManager::m_defaultBars`/`m_notifyWnds`/`m_btnGroups` (alle begrenzt),
`SECTabWndBase::m_arrEigeneFenster` (begrenzt),
`SECControlBar::m_pArrLayoutInfo` (wird nie angelegt).

**Übrig bleiben genau zwei `CPtrArray`-Felder:**

1. `CDockBar::m_arrBars` — die Andockleisten. Das war **E-4**.
2. `SECCustomToolBar::m_btns` (`class SECBtnArray : public CPtrArray`,
   `OTShim_Werkzeugleiste.h:878-906`) — die Knöpfe jeder Werkzeugleiste.

Zu 1: Alle Zugriffe von MFC auf `m_arrBars` sind durch `GetSize()` begrenzt;
die einzigen ungesicherten Stellen sind die aus E-4 bekannten
(`bardock.cpp:297, 321-322, 328-329`: `m_arrBars[nPos]` unmittelbar nach
`RemoveAt(nPos)`), und die sind seit `SECDockBar::NormalizeBarArray()`
abgesichert. Eudoras eigene Zugriffe in `DockBar.cpp` (`:127, :166, :242, :281`)
sind sämtlich durch `GetSize()` begrenzt. **Der Verfassen-Pfad läuft an
`NormalizeBarArray` vorbei** — ein MDI-Kindfenster bekommt über
`CFrameWnd::EnableDocking` einfache `CDockBar`-Objekte, keine `QCDockBar` —,
aber die dort durchlaufenen Wege (`CDockBar::DockControlBar` ohne Rechteck,
`CalcFixedLayout`) bauen `m_arrBars` selbst wohlgeformt auf
(`[NULL, Leiste1, NULL, Leiste2, NULL]`) und greifen nicht daneben.

**Also: `m_btns`.** Und dort sind die ungesicherten Zugriffe nicht im Shim —
`SECCustomToolBar` prüft in `GetItemRect`, `InvalidateButton`, `GetButtonStyle`,
`SetButtonStyle`, `UpdateButton`, `RemoveButton`, `SetBarInfoEx` jedes Mal
`nIndex < 0 || nIndex >= GetBtnCount()` —, sondern **in Eudoras eigenem Code**.

---

## 2. Die gefundenen Stellen (behoben)

### 2.1 `QCChildToolBar::GetButton` — der Hauptverdacht

`Eudora71/Eudora/QCChildToolBar.cpp:114-118`, vorher:

```cpp
void* QCChildToolBar::GetButton(
INT iIndex )
{
	return ( void* )( m_btns[ iIndex ] );
}
```

Keine Schranke. Das ist der einzige nach außen gereichte Zugriff auf `m_btns`
ohne Prüfung — und **seine Aufrufer übergeben planmäßig `-1`**:

| Aufrufer | Index |
|---|---|
| `CompMessageFrame.cpp:669` | `CommandToIndex( ID_EDIT_INSERT )` |
| `CompMessageFrame.cpp:683` | `CommandToIndex( ID_EDIT_TEXT_SIZE )` |
| `ReadMessageFrame.cpp:503, :517` | dieselben |
| `PgDocumentFrame.cpp:267, :277` | dieselben |
| `CompMessageFrame.cpp:625` | **fest verdrahtete `13`** |

`SECCustomToolBar::CommandToIndex` (`OTShim_Werkzeugleiste.cpp:2245-2254`)
liefert `-1`, wenn der Knopf nicht auf der Leiste liegt. `m_btns[-1]` ist
`CPtrArray::ElementAt(-1)` — **exakt `afxcoll.inl:213`** im Debug-Bau und
`AfxThrowInvalidArgException` („Encountered an improper argument") im
Release-Bau. Beide gemeldeten Symptome passen zu dieser einen Stelle — die
Einschraenkung dazu steht in Abschnitt 3b.

Behoben: Schranke, Rückgabe `NULL`. Alle Aufrufer prüfen den Rückgabewert
ohnehin (`VERIFY(...)` und anschließend `if (pMenu && pMenuButton)`); die zwei
Stellen in `PgDocumentFrame.cpp`, die das nicht taten, haben die Abfrage jetzt
bekommen.

**Warum das die Ursache sein kann, obwohl die Knopflisten die IDs enthalten:**
`CommandToIndex` liefert auch dann `-1`, wenn `SetButtons`
(`OTShim_Werkzeugleiste.cpp:2145-2176`) mitten in der Liste abgebrochen hat —
die Fassung gibt bei `pBtn == NULL` mit `return FALSE` auf und lässt die Leiste
halb gefüllt zurück. `ID_EDIT_INSERT` steht als **vorletzter** Eintrag von
`theFullFeatureFormatButtons` (`CompMessageFrame.cpp:82-109`), Platz 26 von 28.
Jeder Abbruch davor macht daraus `-1`. Genauso wirkt der Umbau der
Verfassen-Werkzeugleiste zur Laufzeit (`CompMessageFrame.cpp:486-501`:
`AddTranslatorButtons` und `RemoveButton` für `ID_TRANSLATORS_QUEUE` —
Gregor hat drei Plugins in `Plugins\`, `SMIME.dll`, `SpamHeaders.dll`,
`SpamWatch.dll`, `transCount` ist also nicht 0).

### 2.2 Fest verdrahteter Platz 13

`CompMessageFrame.cpp:625`:

```cpp
VERIFY( pMenuButton = ( CTBarMenuButton* ) ( m_pToolBar->GetButton(13)));	//change 13 when a new button is added before ID_TRANSLATORS_QUEUE
```

Der Kommentar sagt selbst, dass die Zahl eine Wette ist. Die Knopfliste wird
139 Zeilen weiter oben **zur Laufzeit** umgebaut. Jetzt wird der Platz gesucht:
`CommandToIndex( ID_TRANSLATORS_QUEUE )`.

### 2.3 Die Rechnung um `AddButton` herum

`SECCustomToolBar::AddButton` (`OTShim_Werkzeugleiste.cpp:2180-2205`) begrenzt
die Einfügestelle **still** auf `[0, GetBtnCount()]` und legt gar keinen Knopf
an, wenn `CreateButton` `NULL` liefert. Vier Stellen in Eudora rechneten
danach mit dem **unbegrenzten** Wert weiter:

| Datei | Zeile (vorher) | Wo der Index herkommt |
|---|---|---|
| `QCChildToolBar.cpp` | 196 | `AddTranslatorButtons`, `startPos` von außen |
| `QCCustomToolBar.cpp` | 303 | `DropButton`, aus der Zeilenrechnung |
| `QCCustomToolBar.cpp` | 696 | `LoadCustomInfo`, `atoi` aus der Ini **minus `nFailed`** — kann negativ werden |
| `QCCustomToolBar.cpp` | 780 | `LoadInYourFacePlugins` |
| `QCCustomToolBar.cpp` | 1206 | `ConvertOldStuff`, Ini |

In allen fünf Fällen wird die Einfügestelle jetzt vor dem Zugriff genauso
begrenzt, wie `AddButton` sie intern begrenzt, und der Zugriff selbst noch
einmal gegen `GetBtnCount()` geprüft.

`LoadCustomInfo` ist dabei die schlimmste: `iPosition` kommt aus
`[Toolbar-...]` in der Ini, wird nur gegen `< 0` geprüft und **danach** um
`nFailed` verkleinert. Bei Gregor ist die Stelle heute nicht scharf — seine
`Eudora.ini` hat gar keinen `[ToolBar-...]`-Abschnitt (geprüft in
`Eudora72-1.0.6-debug` und `-release`; er wird erst beim geordneten Beenden
geschrieben, und das kam bisher nicht zustande).

---

## 3. Was **nicht** die Ursache ist (geprüft und ausgeschlossen)

* **Stationery.** `NewCompDocument` (`compmsgd.cpp:2156-2320`) fasst keine
  Sammlung mit einem Index an; `g_theStationeryDirector.Find` ist eine Suche
  über eine Liste, kein Index. `IDS_INI_STATIONERY` ist bei Gregor leer.
* **Persönlichkeiten.** Anders als im Auftrag angenommen hat Gregors Ini sehr
  wohl einen `[Personalities]`-Abschnitt mit `Persona0=Persona-hans wurst`.
  `g_Personalities` wird über `IsA`/`SetCurrent`/`GetCurrent` benutzt, nicht
  über einen Index.
* **`CDockBar::m_arrBars` im Verfassen-Fenster.** Läuft zwar an
  `SECDockBar::NormalizeBarArray` vorbei (MDI-Kindfenster bekommen einfache
  `CDockBar`), baut den Aufbau aber selbst wohlgeformt auf.
* **`SECToolBarCmdUI`** (`OTShim_Werkzeugleiste.cpp:2711-2777`) — läuft im
  Leerlauf ständig, arbeitet aber ausschließlich über die geprüften
  `GetButtonStyle`/`SetButtonStyle`.
* **`RemoveBogusAdToolBars`** (`mainfrm.cpp:5862-5911`) — benutzt `GetItemID`,
  und das ist geprüft.

---

## 3a. Gegenprobe am Objektcode — die Liste ist vollstaendig

Weil `CPtrArray::ElementAt` im DLL-Bau von MFC **nicht** eingebettet wird,
sondern aus `mfc140d.dll` importiert wird, laesst sich am Objektcode ablesen,
welche Uebersetzungseinheiten diese Funktion ueberhaupt aufrufen koennen:

```bash
cd Eudora71/Eudora/Build/Release
for f in *.obj; do grep -q "ElementAt@CPtrArray" "$f" && echo "$f"; done
```

Ergebnis (Release-Bau vom 05.09.2026):

```
DockBar.obj              OTShim*.obj (10 Stueck)     QC3DTabWnd.obj
QCChildToolBar.obj       QCCustomToolBar.obj         QCToolBarManager.obj
QCCustomizeGeneralPage.obj  QCCustomizePluginsPage.obj
QCCustomizeToolBar.obj   QCMbxCustomizeToolbarPage.obj  QCToolbarCmdPage.obj
mainfrm.obj              secaux.obj                  stdafx.obj
```

Mehr gibt es nicht. Durchgesehen:

* `DockBar.obj` — alle vier Zugriffe durch `GetSize()` begrenzt.
* `OTShim*.obj` — der Shim prueft jeden Index; nachgesehen in
  `GetItemRect`, `InvalidateButton`, `GetButtonStyle`, `SetButtonStyle`,
  `UpdateButton`, `RemoveButton`, `SetBarInfoEx`, `OnLButtonDown`,
  `NormalizeBarArray`, `AssignRowExtents`, `DistributeRow`,
  `MoveControlBarToPosition`.
* `QC3DTabWnd.obj` — `:305-307`, durch `GetSize()` begrenzt.
* `mainfrm.obj` — `:844-846` (`state.m_arrBarInfo[i]`), durch `GetSize()`
  begrenzt.
* `QCToolBarManager.obj`, `secaux.obj`, `stdafx.obj` — nur Einbettung aus den
  Kopfdateien, kein eigener Aufruf mit gerechnetem Index.
* Die vier `QCCustomize*`/`QCToolbarCmdPage` gehoeren zum Anpassen-Dialog
  (Extras > Anpassen) und liegen nicht auf Gregors Weg.

Die Liste ist eine **obere Schranke**: `SECBtnArray::operator[]` steht als
inline-Funktion in `OTShim_Werkzeugleiste.h`, deshalb taucht eine
Uebersetzungseinheit auch dann auf, wenn der Uebersetzer die Funktion nur
abgelegt, aber nicht gerufen hat (`secaux.obj`, `stdafx.obj`,
`QCToolBarManager.obj`). Genau das ist fuer diesen Zweck richtig: was nicht in
der Liste steht, kann die Zusicherung nicht ausloesen.

**Ungeprueft blieb keiner. Die sechs behobenen Stellen in
`QCChildToolBar.cpp` und `QCCustomToolBar.cpp` waren die einzigen ohne
Schranke.**

---

## 3b. Was dagegen spricht, dass es damit schon erledigt ist

Ehrlichkeitshalber: Gregors `Eudora.ini` hat `Mode=2`. Die Aufzaehlung in
`QCSharewareManager.h:46-51` beginnt bei `SWM_MODE_ADWARE = 0`, also ist
`Mode=2` gleich **`SWM_MODE_PRO`**. Damit gilt
`UsingFullFeatureSet() == true` (`QCSharewareManager.h:79`), und die
Verfassen-Formatleiste bekommt `theFullFeatureFormatButtons` — dort **stehen**
`ID_EDIT_INSERT` und `ID_EDIT_TEXT_SIZE` drin. `CommandToIndex` sollte sie also
finden und nicht `-1` liefern.

`-1` kommt in dieser Aufstellung nur zustande, wenn `SetButtons`
(`OTShim_Werkzeugleiste.cpp:2145-2176`) die Liste nicht zu Ende gebaut hat: die
Fassung gibt bei `pBtn == NULL` mit `return FALSE` auf und laesst die Leiste
halb gefuellt zurueck. `ID_EDIT_INSERT` ist Platz 26 von 28. **Keiner der vier
Aufrufer wertet den Rueckgabewert aus** (`mainfrm.cpp:1737`,
`CompMessageFrame.cpp:481`, `ReadMessageFrame.cpp:374`,
`QCToolbarCmdPage.cpp:89`) — ein Abbruch bliebe also stumm.

Ich habe das **nicht** bewiesen. Was bewiesen ist: nach diesem Stand gibt es in
Eudoras eigenem Code keinen ungeprueften `CPtrArray::ElementAt` mehr, und die
beiden gemeldeten Symptome koennen aus keiner anderen Sammlung stammen.

---

## 4. Wenn es damit nicht weg ist: so wird es eingefangen


Ich konnte den Absturz nicht selbst auslösen — auf diesem Rechner darf kein
Fenster gestartet werden. Die Belegkette oben ist Quelltextanalyse, keine
Messung. Falls die Zusicherung nach diesem Stand weiter kommt:

1. Debug-Bau starten, Strg-N drücken.
2. Im Zusicherungsdialog **Wiederholen** drücken. Das macht daraus einen
   Haltepunkt statt eines Abbruchs.
3. In einer **32-Bit**-PowerShell:
   `tools\stapel-untersuchen.ps1`
   (braucht die `Eudora.pdb` neben der `Eudora.exe` — beide liegen im
   Testverzeichnis).
4. Gesucht ist der erste Rahmen **außerhalb** von `mfc140d.dll`. Er nennt Datei
   und Zeile.

Die drei wahrscheinlichsten Stellen, falls der Stapel gebraucht wird, in dieser
Reihenfolge:

1. `QCChildToolBar::GetButton` — `QCChildToolBar.cpp:114` (jetzt abgesichert;
   im Stapel steht dann der Aufrufer aus `CompMessageFrame.cpp:625/669/683`).
2. `SECCustomToolBar::SetButtons` — `OTShim_Werkzeugleiste.cpp:2145`. Bricht sie
   halb ab, ist jede folgende `CommandToIndex`-Abfrage `-1`. **Hier fehlt bis
   heute eine Meldung**: der Rückgabewert `FALSE` wird von keinem der vier
   Aufrufer ausgewertet (`mainfrm.cpp:1737`, `CompMessageFrame.cpp:481`,
   `ReadMessageFrame.cpp:374`, `QCToolbarCmdPage.cpp:89`).
3. `CDockBar::RemoveControlBar` / `RemovePlaceHolder` in einer **einfachen**
   `CDockBar` — also in einem MDI-Kindfenster, nicht im Hauptfenster. Dort
   greift `SECDockBar::NormalizeBarArray` nicht. Belegt ist das nicht; falls
   der Stapel dorthin zeigt, ist die saubere Behebung, den MDI-Kindfenstern
   dieselbe Andockleiste zu geben wie `CMainFrame::EnableDocking`
   (`mainfrm.cpp:2165-2182`) es tut.

---

## 5. Geänderte Dateien

| Datei | Was |
|---|---|
| `Eudora71/Eudora/QCChildToolBar.cpp` | `GetButton` mit Schranke; `AddTranslatorButtons` rechnet mit der begrenzten Einfügestelle |
| `Eudora71/Eudora/QCCustomToolBar.cpp` | vier Einfügestellen (`DropButton`, `LoadCustomInfo`, `LoadInYourFacePlugins`, `ConvertOldStuff`) begrenzt |
| `Eudora71/Eudora/CompMessageFrame.cpp` | feste `13` durch `CommandToIndex( ID_TRANSLATORS_QUEUE )` ersetzt |
| `Eudora71/Eudora/PgDocumentFrame.cpp` | die zwei fehlenden `pMenuButton`-Abfragen nachgetragen |

Kein Eingriff in `OTShim` — die Shim-Fassungen prüfen bereits alle Indizes.
