# OT501-Ersatzschicht — Bestandsaufnahme

**Hinweis: diese Datei ist maschinell erzeugt und enthaelt Fehler.** Sie ist eine
Rohaufnahme, keine verbindliche Schnittstellenbeschreibung. Die geprueften
Korrekturen und die Bewertung stehen in **[PLAN.md](PLAN.md)**, Abschnitt "Fehler im
Inventar"; im Zweifel gilt PLAN.md.

Was an welcher Stelle nicht stimmt:

- **Abschnitt 1** war unvollstaendig, weil der Generator nur `class X : public SECY`
  mit `SEC` als *erster* Basisklasse erfasst hat. Sieben Zeilen sind von Hand
  nachgetragen; seither sind die 30 Zeilen nachgezaehlt und stimmen.
- **Abschnitt 2** enthaelt falsche Positive: mehrere Eintraege stammen allein aus
  Kommentaren (`SECDockBar::CalcFixedLayout`, `SECToolBarManager::EnableLargeBtns`,
  `SECToolBarManager::LoadState`, `SECMDIFrameWnd::LoadBarState`). Die Liste hat
  77 Zeilen; 77 Aufgaben sind es nicht.
- **Abschnitt 3** ist in beide Richtungen falsch. Er enthaelt Fehltreffer
  (`SEC_TEXT` ist ein SSPI-Makro aus `Sspi.h`, `SECCustonToolBar` ein Tippfehler in
  einem Kommentar) und ihm fehlt umgekehrt `SEC_AUX_DATA`, das an fuenf Stellen in
  echtem Code steht. **Die Zahl 52 taugt daher nicht als Kennzahl** und sollte
  nirgends zitiert werden.

Erzeugt aus `Eudora/*.cpp` und `Eudora/*.h`.

## 1. Klassen, von denen Eudora ableitet

30 Ableitungen von 22 verschiedenen Stingray-Basisklassen. Die sieben unten mit
(+) markierten Zeilen sind von Hand nachgetragen; der Generator hatte sie
uebersehen.

| Eudora-Klasse | Stingray-Basis | Fundstelle |
|---|---|---|
| CColorToolbarButton|SECTwoPartBtn | ColorToolbarButton.h:31 |
| CDontFloatDockContext (+)|SECDockContext | QCChildToolBar.cpp:43 |
| CMoodMailStatic|SECStdBtn | MoodMailStatic.h:13 |
| CSearchBar|SECCustomToolBar | SearchBar.h:112 |
| CStatusBarEx|SECStatusBar | statbar.h:13 |
| CTBarBitmapComboBtn (+)|SECWndBtn (nach CBitmapCombo) | TBarBmpCombo.h:14 |
| CTBarComboBtn|SECComboBtn | TBarCombo.h:8 |
| CTBarEditBtn (+)|SECWndBtn (nach CEdit) | TBarEdit.h:12 |
| CTBarMenuButton|SECStdBtn | TBarMenuButton.h:14 |
| CTBarStaticBtn (+)|SECWndBtn (nach CStatic) | TBarStatic.h:12 |
| CWazooBar|SECControlBar | WazooBar.h:60 |
| EmoticonToolbarButton|SECTwoPartBtn | EmoticonToolbarButton.h:33 |
| QC3DTabControl (+)|SEC3DTabControl | QC3DTabWnd.h:14 |
| QC3DTabWnd (+)|SEC3DTabWnd | QC3DTabWnd.h:74 |
| QCChildToolBar|SECCustomToolBar | QCChildToolBar.h:15 |
| QCControlBarWorksheet|SECControlBarWorksheet | workbook.h:86 |
| QCCustomToolBar|SECCustomToolBar | QCCustomToolBar.h:15 |
| QCCustomizeToolBar|SECCustomizeToolBar | QCCustomizeToolBar.h:14 |
| QCDockBar|SECDockBar | DockBar.h:16 |
| QCImage|SECDib | QCGraphics.h:51 |
| QCJpeg|SECJpeg | QCGraphics.h:36 |
| QCMiniDockFrameWnd|SECMiniDockFrameWnd | workbook.h:136 |
| QCPng|SECDib | QCGraphics.h:42 |
| QCTipOfDayDlg|SECTipOfDay | TipOfDayDlg.h:4 |
| QCToolBarCmdPage|SECToolBarCmdPage | QCToolbarCmdPage.h:13 |
| QCToolBarManagerWithBM|SECToolBarManager | QCToolBarManager.h:12 |
| QCWorkbook|SECWorkbook | workbook.h:174 |
| QCWorkbookClient (+)|SECWorkbookClient | mainfrm.cpp:333 |
| QCWorksheet|SECWorksheet | workbook.h:39 |
| TBarSendButton|SECStdBtn | TBarSendButton.h:11 |

## 2. Aufgerufene Methoden

```
SECBitmapButton::Al_Center
SECControlBar::CalcFixedLayout
SECControlBar::Create
SECControlBar::GetBarInfoEx
SECControlBar::OnBarFloat
SECControlBar::OnBarMDIFloat
SECControlBar::OnBarStyleChange
SECControlBar::OnCreate
SECControlBar::OnDestroy
SECControlBar::OnFloatAsMDIChild
SECControlBar::OnSize
SECControlBar::OnTimer
SECControlBar::OnToolHitTest
SECControlBar::OnUpdateCmdUI
SECControlBar::OnWindowPosChanging
SECControlBar::PreTranslateMessage
SECControlBar::SetBarInfoEx
SECControlBar::m_bOptimizedRedrawEnabled
SECControlBarManager::DynCreateControlBar
SECCustomToolBar::AcceptDrop
SECCustomToolBar::BarDesChange
SECCustomToolBar::CreateEx
SECCustomToolBar::CreateSeparator
SECCustomToolBar::DestroyWindow
SECCustomToolBar::DoPaint
SECCustomToolBar::OnIdleUpdateCmdUI
SECCustomToolBar::OnNotify
SECCustomToolBar::OnWindowPosChanged
SECCustomToolBar::RemoveButton
SECCustomToolBarInfoEx::BtnInfo
SECDockBar::CalcFixedLayout
SECDockBar::CalcTrackingLimits
SECDockBar::IsControlBarAtMaxWidthInRow
SECDockBar::IsOnlyControlBarInRow
SECDockBar::NormalizeRow
SECJpeg::DoSaveImage
SECMDIChildWnd::OnMDIActivate
SECMDIFrameWnd::LoadBarState
SECMDIFrameWnd::OnLButtonDown
SECStatusBar::Create
SECStatusBar::OnActivate
SECStatusBar::OnBarStyleChange
SECStatusBar::OnDestroy
SECStatusBar::OnEraseBkgnd
SECStatusBar::OnLButtonDblClk
SECStatusBar::OnLButtonDown
SECStatusBar::OnRButtonDown
SECStatusBar::OnSize
SECStatusBar::OnTimer
SECStatusBar::WindowProc
SECStdBtn::AdjustSize
SECStdBtn::BtnPressDown
SECStdBtn::BtnPressUp
SECStdBtn::DrawFace
SECTipOfDay::OnInitDialog
SECToolBarCmdPage::DoDataExchange
SECToolBarCmdPage::OnBarNotify
SECToolBarCmdPage::SetDescription
SECToolBarManager::EnableLargeBtns
SECToolBarManager::LoadState
SECToolBarManager::SaveState
SECTwoPartBtn::BtnPressDown
SECTwoPartBtn::DrawButton
SECTwoPartBtn::DrawFace
SECWorkbook::AddSheet
SECWorkbook::CreateClient
SECWorkbook::GetTabPts
SECWorkbook::OnActivate
SECWorkbook::OnLButtonDown
SECWorkbook::OnNotify
SECWorkbook::OnSetCursor
SECWorkbook::OnSize
SECWorkbook::RemoveSheet
SECWorkbook::WindowProc
SECWorksheet::OnClose
SECWorksheet::OnDestroy
SECWorksheet::RecalcLayout
```

## 3. Weitere referenzierte Bezeichner

```
SEC3DTab
SEC3DTabControl
SEC3DTabWnd
SECBitmapButton
SECBtnDrawData
SECBtnGroup
SECComboBtn
SECComboBtnEdit
SECControl
SECControlBar
SECControlBarInfo
SECControlBarManager
SECControlBarWorksheet
SECConvertDialogUnitsToPixels
SECCustomToolBar
SECCustomToolBarInfoEx
SECCustomToolBars
SECCustomizeToolBar
SECCustonToolBar
SECDateTimeCtrl
SECDib
SECDockBar
SECDockContext
SECDockState
SECFrameWnd
SECImage
SECJpeg
SECLoadSysColorBitmap
SECLoadToolBarResource
SECMDIChildWnd
SECMDIFrameWnd
SECMiniDockFrameWnd
SECStatusBar
SECStdBtn
SECTab
SECTipOfDay
SECToolBarCmdPage
SECToolBarManager
SECToolBarRectTracker
SECToolBarSheet
SECTwoPartBtn
SECWndBtn
SECWorkbook
SECWorkbookClient
SECWorksheet
SEC_DTS_CALENDAR
SEC_IDW_FIRST_USER_TOOLBAR
SEC_IDW_TABCTRL
SEC_TBBS_PRESSED2
SEC_TBBS_RAISED
SEC_TBBS_TRACKING2
SEC_TEXT
```
