@echo off
rem ---------------------------------------------------------------------------
rem  Eudora 7.2 starten
rem ---------------------------------------------------------------------------
rem
rem  Doppelklick genuegt. Diese Datei liegt neben Eudora.exe.
rem
rem  WARUM ES DIESE DATEI GIBT
rem
rem  Beim ERSTEN Start muss Eudora wissen, wo seine Daten liegen. Ohne Angabe
rem  sucht es im Programmverzeichnis - dort liegt aber keine Eudora.ini, sie
rem  liegt bewusst darunter in "Mailverzeichnis", damit Programm und Daten
rem  getrennt bleiben. Eudora legt dann eine leere Einrichtung an.
rem
rem  Genau das ist am 31.08.2026 passiert: das Mailverzeichnis musste von Hand
rem  dazugelegt werden, obwohl es im Paket war (Befund E-6). Die Daten waren da,
rem  nur der Weg dorthin fehlte.
rem
rem  SO ARBEITET EUDORA (von Gregor am 05.09.2026 beschrieben):
rem
rem    1. Erster Aufruf:   Eudora.exe <Mailverzeichnis>
rem       Der Pfad wird in die Ini eingetragen.
rem
rem    2. Jeder weitere:   Eudora.exe
rem       Ohne Parameter - Eudora nimmt den Pfad aus der Ini.
rem
rem  Diese Datei uebergibt den Pfad deshalb IMMER. Das ist ab dem zweiten Mal
rem  nicht noetig, schadet aber nichts: es wird derselbe Pfad eingetragen, der
rem  schon drinsteht. Dafuer funktioniert der Start auch dann noch, wenn das
rem  Verzeichnis spaeter verschoben oder auf einen anderen Rechner kopiert wird -
rem  und beim Auspacken auf einem neuen Rechner ist immer der erste Fall.
rem
rem  %~dp0 ist das Verzeichnis DIESER Datei, mit abschliessendem Backslash.
rem  Damit ist der Start unabhaengig davon, wohin ausgepackt wurde und welches
rem  Arbeitsverzeichnis gerade gilt.
rem ---------------------------------------------------------------------------

setlocal

set "HIER=%~dp0"
set "DATEN=%HIER%Mailverzeichnis"

if not exist "%HIER%Eudora.exe" (
    echo.
    echo   Eudora.exe wurde nicht gefunden.
    echo.
    echo   Erwartet hier:  %HIER%Eudora.exe
    echo.
    echo   Diese Startdatei gehoert in dasselbe Verzeichnis wie Eudora.exe.
    echo.
    pause
    exit /b 1
)

if not exist "%DATEN%\Eudora.ini" (
    echo.
    echo   Das Mailverzeichnis wurde nicht gefunden.
    echo.
    echo   Erwartet hier:  %DATEN%\Eudora.ini
    echo.
    echo   Wenn das Paket vollstaendig ausgepackt wurde, liegt das Verzeichnis
    echo   "Mailverzeichnis" neben Eudora.exe. Bitte nachsehen, ob beim
    echo   Auspacken Unterverzeichnisse verlorengegangen sind.
    echo.
    pause
    exit /b 1
)

rem  Ohne abschliessenden Backslash uebergeben - Eudora haengt ihn selbst an,
rem  und ein doppelter wuerde den Pfad in der Ini verunstalten.
start "" "%HIER%Eudora.exe" "%DATEN%"

endlocal
