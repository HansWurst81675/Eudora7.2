// SAVEAS.CPP
//

#include "stdafx.h"
#include "eudora.h"
#include "QCUtils.h"

#include <dlgs.h>

#include "fileutil.h"
#include "rs.h"
#include "SaveAsDialog.h"
#include "utils.h"

extern CString EudoraDir;

#include "DebugNewHelpers.h"


                                              
CSaveAsDialog::CSaveAsDialog(const char* Filename, BOOL IsMessage, BOOL IsStationery,
							 const char* DefaultExtension, const char* FileFilter, CWnd* pParent)
	: CFileDialog(FALSE, DefaultExtension, Filename,
		OFN_HIDEREADONLY | OFN_NOREADONLYRETURN | OFN_OVERWRITEPROMPT, FileFilter,
		pParent? pParent : AfxGetMainWnd())
{
	m_ofn.Flags &= ~OFN_SHOWHELP; 

	m_IsMessage = IsMessage;
	m_ChangingDir = FALSE;

	// Use Is Stat for initilizing here
	//m_IsStat = IsStationery;
	//For Now, Need to delete this Stationery parameter
	m_IsStat = FALSE;

	if (IsVersion4())
	{
		LPCSTR DlgName;
		
		m_ofn.Flags |= OFN_ENABLETEMPLATE;
		DlgName = MAKEINTRESOURCE(IDD_SAVEAS_EXT);
		m_ofn.lpTemplateName = DlgName;
		m_ofn.hInstance = QCFindResourceHandle(MAKEINTRESOURCE(IDD_SAVEAS_EXT), RT_DIALOG);
	}
}
    

void CSaveAsDialog::DoDataExchange(CDataExchange* pDX)
{
	CFileDialog::DoDataExchange(pDX);
	if (GetDlgItem(IDC_HEADERS))
		DDX_Control(pDX, IDC_HEADERS, m_IncludeHeaders);
	if (GetDlgItem(IDC_GUESS_PARA))
		DDX_Control(pDX, IDC_GUESS_PARA, m_GuessParagraphs);
	if (GetDlgItem(IDC_STATIONERY))
		DDX_Control(pDX, IDC_STATIONERY, m_Stationery);
	//{{AFX_DATA_MAP(CSaveAsDialog)
	//}}AFX_DATA_MAP
}



	
BEGIN_MESSAGE_MAP(CSaveAsDialog, CFileDialog)
	//{{AFX_MSG_MAP(CSaveAsDialog)
	ON_BN_CLICKED(IDC_HEADERS, ToggleInc)
	ON_BN_CLICKED(IDC_GUESS_PARA, ToggleGuess)
	ON_BN_CLICKED(IDC_STATIONERY, ToggleStat)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


BOOL CSaveAsDialog::OnInitDialog()
{
	CFileDialog::OnInitDialog();

	PutDebugLog(DEBUG_MASK_MISC, "E-97 OnInitDialog: 1 nach CFileDialog::OnInitDialog\r\n");

	//
	// BEFUND E-97: Eudora stuerzte ab, sobald eine Nachricht gespeichert
	// werden sollte. Gregor am 15.09.2026: "da kommt kurz eine meldung, dann
	// ist eudora weg!"
	//
	// GEMESSEN in jeder vorhandenen Fassung - 1.0.63, .62, .53, .50, .49.
	// Kein neuer Fehler, sondern einer, der nie auffiel, weil niemand eine
	// Nachricht gespeichert hat. Auch das Release v1.0.50 ist betroffen.
	//
	// Der Debugger fing die Ausnahme 0xC000041D
	// (STATUS_FATAL_USER_CALLBACK_EXCEPTION) mit COMDLG32.dll in den Rahmen
	// 1 bis 5: der Windows-Dateidialog ruft hier zurueck, und in diesem
	// Rueckruf entsteht der Fehler. Eine Ausnahme in einem Systemrueckruf
	// kommt nicht ueber die Kernel-Grenze zurueck - deshalb bricht das
	// Programm sofort ab, statt eine Meldung zu zeigen.
	//
	// DIE URSACHE steht drei Funktionen weiter oben: DoDataExchange bindet
	// die drei Schalter nur an, WENN es sie gibt -
	//
	//     if (GetDlgItem(IDC_HEADERS))
	//         DDX_Control(pDX, IDC_HEADERS, m_IncludeHeaders);
	//
	// - und das ist richtig so. Hier unten wurde dann aber ohne Pruefung
	// zugegriffen: m_IncludeHeaders.SetCheck() schickt eine Nachricht an
	// m_hWnd, und das ist null, wenn die Anbindung ausgefallen ist. MFC hat
	// davor ein ASSERT(::IsWindow(m_hWnd)) - und ASSERT IST IM RELEASE
	// WIRKUNGSLOS (Arbeitsweise/assert-ist-im-release-nichts.md, die
	// haeufigste Ursachenklasse dieses Projekts).
	//
	// Dasselbe galt fuer GetParent(): 1996 war der Dateidialog ein einzelnes
	// Fenster, heute ist er zusammengesetzt, und die Elternkette sieht anders
	// aus.
	//
	// Nichts davon aendert das Aussehen, solange die Schalter da sind. Fehlen
	// sie, arbeitet der Dialog weiter, statt das Programm mitzunehmen.
	//
	if (IsVersion4())
	{
		if (m_IsMessage)
		{
			CWnd*	pEltern = GetParent();

			if (pEltern != NULL)
			{
				CRect wRect, pRect;
				GetWindowRect(wRect);
				pEltern->GetWindowRect(pRect);
				wRect.top = pRect.bottom - wRect.Height(); 
				wRect.bottom = pRect.bottom; 
				MoveWindow(&wRect, TRUE);
			}

			m_Inc = m_Guess = FALSE;

			if (GetIniShort(IDS_INI_INCLUDE_HEADERS))
			{
				if (m_IncludeHeaders.GetSafeHwnd())
					m_IncludeHeaders.SetCheck(TRUE);
				m_Inc = TRUE;
			}
			
			if (GetIniShort(IDS_INI_GUESS_PARAGRAPHS))
			{
				if (m_GuessParagraphs.GetSafeHwnd())
					m_GuessParagraphs.SetCheck(TRUE);
				m_Guess = TRUE;
			}
			if (!m_IsStat && GetDlgItem(IDC_STATIONERY) && m_Stationery.GetSafeHwnd())
				m_Stationery.ShowWindow(SW_HIDE); 
			
			// Use to tell whether stationery is selected
			m_IsStat = FALSE;
			return TRUE;
		}
	}
	else
	{
		if (m_IsMessage)
		{

			CRect ClientRect, WindowRect, rect;
			CWnd* Combo = GetDlgItem(cmb1);
			const DWORD DBU = ::GetDialogBaseUnits();
			const int xDLU = LOWORD(DBU);
			const int yDLU = HIWORD(DBU);
	    		
			GetClientRect(&ClientRect);
			GetWindowRect(&WindowRect);
			
			if (Combo)
			{
				Combo->GetWindowRect(&rect);
				ScreenToClient(&rect);
			}
			else
				rect.left = xDLU;
			rect.top = ClientRect.bottom;
			rect.bottom = rect.top + yDLU;
			
			m_IncludeHeaders.Create(CRString(IDS_FILELIST_INC_HEADERS),
				WS_CHILD | WS_VISIBLE | WS_GROUP | WS_TABSTOP | BS_AUTOCHECKBOX, rect, this, IDC_HEADERS/*chx15*/);
			if (GetIniShort(IDS_INI_INCLUDE_HEADERS))
				m_IncludeHeaders.SetCheck(TRUE);
			
			rect.top += yDLU;
			rect.bottom = rect.top + yDLU;
			m_GuessParagraphs.Create(CRString(IDS_FILELIST_GUESS_PARA),
				WS_CHILD | WS_VISIBLE | WS_GROUP | WS_TABSTOP | BS_AUTOCHECKBOX, rect, this, IDC_GUESS_PARA/*chx16*/);
			if (GetIniShort(IDS_INI_GUESS_PARAGRAPHS))
				m_GuessParagraphs.SetCheck(TRUE); 
			if (m_IsStat)
			{
				rect.top -= yDLU;
				rect.bottom = rect.top + yDLU;
				rect.left =  xDLU*22;
				rect.right = rect.left + xDLU*22;
				m_Stationery.Create(CRString(IDS_STATIONERY_LABEL),WS_CHILD | WS_VISIBLE | WS_GROUP | WS_TABSTOP | BS_AUTOCHECKBOX, 
											rect, this, IDC_STATIONERY/*chx17*/);
			}

			CFont* Font = GetFont();
			m_IncludeHeaders.SetFont(Font, FALSE);
			m_GuessParagraphs.SetFont(Font, FALSE);
			if (m_IsStat)
				m_Stationery.SetFont(Font, FALSE);
			
			WindowRect.bottom += yDLU * 2 + yDLU / 2;
			MoveWindow(&WindowRect, FALSE);
		}
		
		CenterWindow();
	}
	
	// Use to tell whether stationery is selected
	m_IsStat = FALSE;

	return (TRUE);
}
      
     
void CSaveAsDialog::ToggleStat()
{
	CWnd *dlgPtr = NULL;

	if (IsVersion4())
		dlgPtr = GetParent();
	else
		dlgPtr = this;

	BOOL stat = GetDlgItem(IDC_STATIONERY) ? m_Stationery.GetCheck(): FALSE;
	
	// Use to tell whether stationery is selected
	m_IsStat = stat;
	
	m_IncludeHeaders.EnableWindow(!stat);
	m_GuessParagraphs.EnableWindow(!stat);
	
	int CurSel = 0;
	if (stat) CurSel = 1;

	// Change the 'type' selected
	CWnd *filtCombo = dlgPtr->GetDlgItem(cmb1);
	if (filtCombo)
	{ 
		((CComboBox *)filtCombo)->SetCurSel(CurSel);
		// Gotta send message so dlg box know what happened
		dlgPtr->SendMessage(WM_COMMAND, MAKEWPARAM(cmb1,CBN_SELENDOK), (LPARAM)filtCombo->m_hWnd);
	}
  
 	if (stat)
	{
		m_ofn.lpstrFilter = CRString(IDS_STATIONERY_FILE_FILTER32); 
		if (IsVersion4())
			SetDefExt(CRString(IDS_STATIONERY_EXTENSION));
		StatDir();
	}
	else
	{
		m_ofn.lpstrFilter = CRString(IDS_TEXT_FILE_FILTER);
		if (IsVersion4())
			SetDefExt(CRString(IDS_TEXT_EXTENSION));
	}
}

void CSaveAsDialog::StatDir()
{
	CString	statDir = EudoraDir;
	CWnd *dlgPtr = NULL;

	if (::LongFileSupportMT(EudoraDir))
		statDir += CRString(IDS_STATIONERY_FOLDER);
	else
		statDir += CRString(IDS_STATIONERY_FOLDER16); 

	if (IsVersion4())
		dlgPtr = GetParent();
	else
		dlgPtr = this;
	
	CString oldName = GetPathName();

	// Get Suggested or typed in name 
	char tmp[256];
	int s = oldName.ReverseFind(SLASH);
	if (s > 0)
		oldName = oldName.Right(oldName.GetLength() - s - 1);

	// Navigate to the stationery directory
	CWnd *fileNameWnd = NULL;
	if (IsVersion4())
		SetControlText(edt1,statDir); 
	else
	{
		// enter the text for the new directory
		fileNameWnd = dlgPtr->GetDlgItem(edt1); 
		if (fileNameWnd && !statDir.IsEmpty())
		{          
			strcpy(tmp, (const char *)statDir);
			fileNameWnd->SendMessage(WM_SETTEXT, 0, (LPARAM)tmp);    
		}
	}

	// Grab the OK Button
	CWnd *OKBut = dlgPtr->GetDlgItem(IDOK);
	ASSERT(OKBut);
	if (OKBut)
	{
		m_ChangingDir = TRUE;
		if (IsVersion4())
		{
			// OK Button to do the 'cd'
			dlgPtr->SendMessage(WM_COMMAND, MAKEWPARAM(IDOK,BN_CLICKED), (LPARAM)OKBut->m_hWnd);
			// Reset to original Text
			SetControlText(edt1,oldName);
		}
		else
		{
			// OK Button to do the 'cd'
			dlgPtr->SendMessage(WM_COMMAND, MAKEWPARAM(IDOK, BN_CLICKED), (LPARAM)(OKBut->m_hWnd));
			// Reset to original Text
			if (fileNameWnd)
			{          
				fileNameWnd->SendMessage(WM_SETTEXT, 0, (LPARAM)(const char*)oldName);  
			} 
			
		}
		m_ChangingDir = FALSE;
	}
}


////////////////////////////////////////////////////////////////////////
// OnOK [protected, virtual]
//
////////////////////////////////////////////////////////////////////////
void CSaveAsDialog::OnOK()
{
	if (m_IsMessage)
	{
		//
		// Hack alert!  The OnOK method doesn't get called under the 
		// 32-bit Version 4 shell, so users need to handle updates
		// to IDS_INI_INCLUDE_HEADERS and IDS_INI_GUESS_PARAGRAPHS
		// elsewhere!
		//
		SetIniInt(IDS_INI_INCLUDE_HEADERS, m_IncludeHeaders.GetCheck());
		SetIniInt(IDS_INI_GUESS_PARAGRAPHS, m_GuessParagraphs.GetCheck());
	}
	
	if (!m_ChangingDir)
	{
 		char realFileName[_MAX_PATH + 1];
		GetFileNameFromDialog(realFileName, _MAX_PATH);
	                               
		// Clean up the file name so it has .sta extenstion
		if (m_IsStat)
		{		
			// See if it ends is not (the default in NT3.51, 16 bit
			char *ext = strstr(realFileName, ".sta");
			if (!ext)
			{
				// gotta change .txt to .sat
				char *ext = strrchr(realFileName, '.'); 
				if (!::LongFileSupportMT(realFileName) && ext)
					strcpy(ext, ".sta");
				else
					strcat(realFileName, ".sta");
			
				SetFileNameInDialog(realFileName);
			} 
		} 
	}

	CFileDialog::OnOK();
}  

void CSaveAsDialog::GetFileNameFromDialog(char *buf, int bufLen)
{
	CWnd *dlgPtr = NULL;
	
	if (IsVersion4())
		dlgPtr = GetParent();
	else
		dlgPtr = this;
	
	// Navigate to the stationery directory
	CWnd *fileNameWnd = NULL;
	// enter the text for the new directory
	fileNameWnd = dlgPtr->GetDlgItem(edt1); 
	if (fileNameWnd)
		fileNameWnd->SendMessage(WM_GETTEXT, bufLen,(LPARAM) ((LPSTR) buf));    
}

void CSaveAsDialog::SetFileNameInDialog(const char *buf)
{
	CWnd *dlgPtr = NULL;
	
	if (IsVersion4())
		dlgPtr = GetParent();
	else
		dlgPtr = this;
	
	// Navigate to the stationery directory
	CWnd *fileNameWnd = NULL;
	if (IsVersion4())
		SetControlText(edt1,buf); 
	else
	{
		// enter the text for the new directory
		fileNameWnd = dlgPtr->GetDlgItem(edt1); 
		if (fileNameWnd)
			fileNameWnd->SendMessage(WM_SETTEXT, 0, (LPARAM)buf);    
	} 
}

void CSaveAsDialog::OnTypeChange()
{
	CWnd *dlgPtr = NULL;

	if (IsVersion4())
		dlgPtr = GetParent();
	else
		dlgPtr = this;


	CWnd *filtCombo = dlgPtr->GetDlgItem(cmb1);
	if (filtCombo)
	{
		int iCurSel = 	((CComboBox *)filtCombo)->GetCurSel();
		//Disable the Guess Paragraph check box if the current file type is HTML
		//This is currently in position 1 of the combobox so if that changes then this will have to change too:)
		if(iCurSel == 1)
			m_GuessParagraphs.EnableWindow(FALSE);
		else
			m_GuessParagraphs.EnableWindow(TRUE);
	}
	else
		m_GuessParagraphs.EnableWindow(TRUE);

}

