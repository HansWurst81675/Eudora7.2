@echo off
rem ---------------------------------------------------------------------------
rem  bauen.bat - baut die beiden Testprogramme fuer die TLS-Schicht.
rem
rem  Es wird bewusst NICHT msbuild auf Eudora.sln oder QCSSL.vcxproj benutzt.
rem  Dieses Skript ruft nur cl.exe fuer die eigenen Quelldateien auf und
rem  fasst kein bestehendes Projekt an.
rem
rem  Ziel ist x86, weil OpenSSL3 als VC-WIN32 gebaut wurde und QCSSL.dll
rem  ebenfalls eine 32-Bit-DLL ist.
rem ---------------------------------------------------------------------------

setlocal

set TESTDIR=%~dp0
set REPO=%TESTDIR%..\..\..
set OPENSSL=%REPO%\Eudora71\OpenSSL3
set OUT=%TESTDIR%bin

if not exist "%OUT%" mkdir "%OUT%"

rem --- Entwicklungsumgebung x86 einrichten -----------------------------------
if "%VSCMD_ARG_TGT_ARCH%"=="x86" goto :haveenv

set VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -property installationPath`) do set VSPATH=%%i
if "%VSPATH%"=="" (
  echo FEHLER: Visual Studio nicht gefunden.
  exit /b 1
)
call "%VSPATH%\VC\Auxiliary\Build\vcvars32.bat" >nul
if errorlevel 1 (
  echo FEHLER: vcvars32.bat fehlgeschlagen.
  exit /b 1
)

:haveenv

rem --- Programm 1: tlstest.exe (Weg a, direkt gegen OpenSSL 3.5.8) -----------
echo.
echo === tlstest.exe wird gebaut ===
cl /nologo /W3 /EHsc /MD /O2 /DWIN32 /D_CRT_SECURE_NO_WARNINGS /DNDEBUG ^
   /I"%OPENSSL%\include" ^
   /Fo"%OUT%\\" /Fe"%OUT%\tlstest.exe" ^
   "%TESTDIR%src\tlstest.cpp" ^
   /link /SUBSYSTEM:CONSOLE ^
   "%OPENSSL%\lib\libssl.lib" "%OPENSSL%\lib\libcrypto.lib" ^
   ws2_32.lib crypt32.lib advapi32.lib user32.lib gdi32.lib bcrypt.lib
if errorlevel 1 (
  echo FEHLER: tlstest.exe konnte nicht gebaut werden.
  exit /b 1
)

rem --- Programm 2: qcsslprobe.exe (Weg b, gegen die echte QCSSL.dll) ---------
rem  MFC dynamisch, MBCS, /MD - genau wie QCSSL.vcxproj (UseOfMfc=Dynamic,
rem  RuntimeLibrary=MultiThreadedDLL, kein _UNICODE). Die DLL exportiert
rem  Funktionen, deren Parameter MFC-Klassen (CString, CPtrList) enthalten;
rem  ohne identische Einstellungen passt die Speicherdarstellung nicht.
echo.
echo === qcsslprobe.exe wird gebaut ===
cl /nologo /W3 /EHsc /MD /O2 /DWIN32 /D_AFXDLL /D_CRT_SECURE_NO_WARNINGS /DNDEBUG ^
   /I"%REPO%\Eudora71\QCSSL\public\inc" ^
   /Fo"%OUT%\\" /Fe"%OUT%\qcsslprobe.exe" ^
   "%TESTDIR%src\qcsslprobe.cpp" ^
   /link /SUBSYSTEM:CONSOLE ws2_32.lib
if errorlevel 1 (
  echo FEHLER: qcsslprobe.exe konnte nicht gebaut werden.
  exit /b 1
)

echo.
echo Fertig. Ergebnisse in %OUT%
endlocal
