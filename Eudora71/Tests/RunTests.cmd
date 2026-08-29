@echo off
rem
rem RunTests.cmd - Testprojekt bauen und ausfuehren, ohne IDE.
rem
rem Es wird ausschliesslich Tests.vcxproj gebaut. Eudora.vcxproj und die Solution
rem werden nicht angefasst.
rem
setlocal
set MSBUILD=C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe

"%MSBUILD%" "%~dp0Tests.vcxproj" /p:Configuration=Debug /p:Platform=Win32 /v:minimal /nologo
if errorlevel 1 (
    echo.
    echo Build fehlgeschlagen.
    exit /b 1
)

echo.
"%~dp0Build\Debug\EudoraTests.exe"
set RC=%ERRORLEVEL%
echo.
echo Fehlgeschlagene Tests: %RC%
exit /b %RC%
