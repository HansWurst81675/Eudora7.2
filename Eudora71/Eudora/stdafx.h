// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#ifndef __EUDORA_STDAFX_H_
#define __EUDORA_STDAFX_H_
///////////////////////////////////////////////////////////////////////////////
// Microsoft Foundation Class Library includes

#if _MSC_VER >= 1000
#pragma once
#endif

// Turn on leak checking with malloc (must be defined before stdlib.h is included)
#define _CRTDBG_MAP_ALLOC

#define VC_EXTRALEAN

// --- Claude fix: force minimum WINVER/_WIN32_WINNT for MFC v143 (VS2022) compatibility ---
#ifdef WINVER
#undef WINVER
#endif
#define WINVER 0x0501

#ifdef _WIN32_WINNT
#undef _WIN32_WINNT
#endif
#define _WIN32_WINNT 0x0501
// --- end Claude fix ---

#include <afxwin.h>					// MFC core and standard components
#include <afxext.h>					// MFC extensions (including VB)
#include <afxcview.h>
#include <afxdtctl.h>				// MFC support for Internet Explorer 4 Common Controls
#include <afxhtml.h>				// MFC support for HTML control
#include <afxcmn.h>					// MFC common controls
#include <afxole.h>					// MFC COleDropTarget, etc.
#ifndef WIN32
#error "This project is for WIN32 only"
#endif // WIN32


///////////////////////////////////////////////////////////////////////////////
// ActiveX Template Library includes

#include "CEudoraModule.h"  // template library is based off of our Eudora Module

///////////////////////////////////////////////////////////////////////////////
// Stingray Objective Toolkit includes

#include "OTShimAll.h"		// OT501-Ersatzschicht, zieht secall.h nach

#include "qcassert.h"		// ASSERT/VERIFY logging


///////////////////////////////////////////////////////////////////////////////
// Warning exclusions

#pragma warning(disable : 4706 4100)


#endif // __EUDORA_STDAFX_H_
