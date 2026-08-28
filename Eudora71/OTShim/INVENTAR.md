# OT501-Ersatzschicht — Bestandsaufnahme

Maschinell erzeugt aus `Eudora/*.cpp` und `Eudora/*.h`.
Definiert exakt die Oberflaeche, die die Ersatzschicht bereitstellen muss.

## 1. Klassen, von denen Eudora ableitet

| Eudora-Klasse | Stingray-Basis |
|---|---|
| CColorToolbarButton|SECTwoPartBtn |
| CMoodMailStatic|SECStdBtn |
| CSearchBar|SECCustomToolBar |
| CStatusBarEx|SECStatusBar |
| CTBarComboBtn|SECComboBtn |
| CTBarMenuButton|SECStdBtn |
| CWazooBar|SECControlBar |
| EmoticonToolbarButton|SECTwoPartBtn |
| QCChildToolBar|SECCustomToolBar |
| QCControlBarWorksheet|SECControlBarWorksheet |
| QCCustomToolBar|SECCustomToolBar |
| QCCustomizeToolBar|SECCustomizeToolBar |
| QCDockBar|SECDockBar |
| QCImage|SECDib |
| QCJpeg|SECJpeg |
| QCMiniDockFrameWnd|SECMiniDockFrameWnd |
| QCPng|SECDib |
| QCTipOfDayDlg|SECTipOfDay |
| QCToolBarCmdPage|SECToolBarCmdPage |
| QCToolBarManagerWithBM|SECToolBarManager |
| QCWorkbook|SECWorkbook |
| QCWorksheet|SECWorksheet |
| TBarSendButton|SECStdBtn |

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
