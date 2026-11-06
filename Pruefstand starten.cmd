@echo off
rem ---------------------------------------------------------------------------
rem  Eudora 7.2 - Pruefstand starten (Regressionstests ueber die Oberflaeche)
rem ---------------------------------------------------------------------------
rem
rem  Doppelklick genuegt. Vorher Eudora bauen (tools\bauen.ps1), sonst wird
rem  das letzte Release geprueft statt der eigenen Aenderung.
rem  Anleitung: Doku\PRUEFSTAND.md
rem
rem  Gregor am 05.11.2026: "ich moechte separat von hier (oder auch jemand,
rem  der die repo forkt oder clonet) die tests nach eigenen aenderungen
rem  durchfuehren." (Befund E-151)
rem
rem  Weitere Schalter werden durchgereicht, etwa:
rem    "Pruefstand starten.cmd" -Nur E-193
rem    "Pruefstand starten.cmd" -ZusatzDlls C:\meine-dlls
rem ---------------------------------------------------------------------------
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\pruefstand-starten.ps1" %*
set RC=%ERRORLEVEL%
echo.
pause
exit /b %RC%
