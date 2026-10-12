// DEBUG.H
//
// Routines for writing info to the debug file
//

#ifndef _EUDORA_DEBUG_H_
#define _EUDORA_DEBUG_H_


#include "afxmt.h"
typedef DWORD DebugMaskType;

// Logging bitmask values
const DebugMaskType DEBUG_MASK_SEND		= 0x01;	// Log sending of a message
const DebugMaskType DEBUG_MASK_RCVD		= 0x02;	// Log receipt of a message
const DebugMaskType DEBUG_MASK_NAV		= 0x04;	// Serial login navagation
const DebugMaskType DEBUG_MASK_DIALOG	= 0x08;	// Dialog message logging
const DebugMaskType DEBUG_MASK_PROG		= 0x10;	// Progress box logging
const DebugMaskType DEBUG_MASK_TRANS	= 0x20;	// All bytes Tx
const DebugMaskType DEBUG_MASK_RCV		= 0x40;	// All bytes Rx

const DebugMaskType DEBUG_MASK_TOC_CORRUPT = 0x80;	// Check a TOC bug

const DebugMaskType DEBUG_MASK_TRANS_BASIC	= 0x100;	// Basic Translator Stuff
const DebugMaskType DEBUG_MASK_TRANS_ADV	= 0x200;	// Advanced Translator Stuff

const DebugMaskType DEBUG_MASK_FILTERS		= 0x400;	// Filter actions

const DebugMaskType DEBUG_MASK_ASSERT		= 0x800;	// Log ASSERTs & VERIFYs
const DebugMaskType DEBUG_MASK_PLIST		= 0x1000;	// Playlist stuff

const DebugMaskType DEBUG_MASK_LMOS			= 0x2000;	// LMOS stuff

const DebugMaskType DEBUG_MASK_SEARCH		= 0x4000;	// Searching and search indexing

const DebugMaskType DEBUG_MASK_MISC			= 0x8000;	// Miscellaneous .. This can be used in cases, where the developer does not 
														// want/need to create new log levels. Baically if you need to log information once or so. 

//	Anhaenge: der Weg eines Dateinamens vom Kopf der Nachricht bis zur Datei
//	auf der Platte (Befund AN-1). Einschalten mit LogLevel += 65536 in der
//	[Debug]-Gruppe von eudora.ini - NICHT [Settings]: GetSectionID in
//	rs.cpp:89 ordnet die 10802 nach [Debug]. Aus der Voreinstellung 25759
//	wird so 91295; alles davon in eudora.log faengt mit "ANHANG" an.
const DebugMaskType DEBUG_MASK_ATTACH		= 0x10000;

class JJFileMT;

class AFX_EXT_CLASS QCLogFileMT
{

public:
	// Load debug values from EUDORA.INI
	static BOOL InitDebug(DWORD dwMask, DWORD dwSize, short nMode, LPCTSTR strEudoraDir, LPCTSTR strLogFileName);

	// Notify INI change
	static void NotifyIniChange(UINT nStringNum, long nValue);

	// Cleanup left over structures.
	static void CleanupDebug();

	static void PutLineHeader(DebugMaskType ID);
	static void PutLineTrailer(DebugMaskType ID);
	static void WriteDebugLog(DebugMaskType ID, LPCTSTR Buffer, int Length = -1);
	static void WriteAssertLog(LPCTSTR pExpr, LPCTSTR pFileName, int nLineNum);

	// TRUE indicates that at least one of the mask bits are set
	static BOOL DebugMaskSet(DebugMaskType Mask);
	
public:
	static bool			s_bOutputEudoraStatusInfoNow;
	static DebugMaskType	DebugMask;
	static short		s_Mode;
	static JJFileMT*	s_pLogFile;

private:
	static const time_t kInitialTime;
	static long			DebugLogSize;
	static time_t		MarkerTime;
	
	static CString g_strLogFileName;
	static CString g_strEudoraDir;
	static CString m_AssertFmtStr;

	static CCriticalSection m_Guard;

	static BOOL m_bIsNT;

};


#ifdef TRUE //_DEBUG

__declspec( dllexport )  void PutDebugLog(DebugMaskType ID, LPCTSTR Buffer, int Length = -1);

#else
// Place null terminated character data into the log file
inline __declspec( dllexport )  void PutDebugLog(DebugMaskType ID, LPCTSTR Buffer, int Length = -1)
{
	if ((QCLogFileMT::DebugMask & ID) == 0 || !QCLogFileMT::s_pLogFile)
		return;
	QCLogFileMT::WriteDebugLog(ID, Buffer, Length);
}

#endif


//	Schreibt eine Zeile in den Log und macht dabei Steuerzeichen SICHTBAR:
//	CR wird zu <CR>, LF zu <LF>, Tabulator zu <TAB>, alles andere unter 32
//	zu <XX> in hexadezimal. Genau darauf kommt es bei Befund AN-1 an - ohne
//	das saehe eine Faltung im Dateinamen im Log wie ein Zeilenumbruch aus.
//	lZahl wird angehaengt, wenn sie nicht -1 ist (zum Beispiel die Laenge).
__declspec( dllexport )  void PutDebugLogSichtbar(DebugMaskType ID, LPCTSTR pWo,
												  LPCTSTR pWas, long lZahl = -1);


#endif // _EUDORA_DEBUG_H_
