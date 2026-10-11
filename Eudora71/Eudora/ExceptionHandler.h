// ExceptionHandler.h
//

#ifndef __EXCEPTION_HANDLER_H__
#define __EXCEPTION_HANDLER_H__

#include <imagehlp.h>

class QCExceptionHandler
{
  public:
								QCExceptionHandler(bool bEnableCrashHandler = true);
								~QCExceptionHandler( );

	void						EnableCrashHandler();
	void						DisableCrashHandler();
	void						EnableBufferOverflowHandler();
	
	void						SetExceptionLogFileName(
										const char *			szLogFileName);

	void						SetMiniDumpFileName(
										const char *			szMiniDumpFileName);

	void						SaveCrashStateToINI() const;

  protected:
	// entry point where control comes on an unhandled exception
	static LONG __stdcall		QCCrashHandler(
										PEXCEPTION_POINTERS		pExceptionInfo);

	// where report info is extracted and generated	
	static void					GenerateExceptionReport(
										PEXCEPTION_POINTERS		pExceptionInfo);
	static void					SecurityErrorHandler();
	static void					GenerateBufferOverflowReport();

	// BEFUND E-27. Drei Fehlerklassen beenden den Prozess unter der
	// Laufzeitbibliothek von Visual Studio 2022 OHNE jede Meldung: das
	// unhandled-exception-Filter von EuMemMgr laeuft dabei nicht, es wird
	// keine Exception.log geschrieben, kein Fenster erscheint. Unter VC6 gab
	// es diese Klassen entweder nicht oder sie meldeten sich. Die drei Haken
	// hier machen sie sichtbar - sie schreiben eine Zeile in die Exception.log
	// und erheben daraus eine echte Ausnahme, damit der vorhandene
	// Absturzbehandler Registersatz, Modultabelle und Aufrufstapel dazuschreibt.
	static void __cdecl			QCInvalidParameterHandler(
										const wchar_t *			szExpression,
										const wchar_t *			szFunction,
										const wchar_t *			szFile,
										unsigned int			nLine,
										uintptr_t				nReserved);
	static void __cdecl			QCPureCallHandler();
	static void					QCTerminateHandler();

	// Gemeinsamer Rumpf der drei Haken.
	static void					ReportSilentFailure(
										unsigned long			dwCode,
										const char *			szWhat);

	// Schreibt die Ladeadresse jedes Moduls in den Bericht (Befund E-26).
	static void				WriteModuleTable();

	// Helper functions
	static int __cdecl			_tprintf(const TCHAR * format, ...);
		
	// Variables used by the class
	static TCHAR				m_szExceptionLogFileName[MAX_PATH];
	static TCHAR				m_szMiniDumpLogFileName[MAX_PATH];
	static HANDLE				m_hReportFile;
	static MINIDUMP_TYPE		m_eMiniDumpType;
	static bool					m_bEudoraCrashedDuringThisRun;
	static bool					m_bEudoraCrashedDuringLastRun;
	static bool					m_bBufferOverflowCheck;
	static bool					m_bBufferOverflowAskUserBeforeQuitting;
};

extern QCExceptionHandler g_QCExceptionHandler;	//  global instance of class



#endif
