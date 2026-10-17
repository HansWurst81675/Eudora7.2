# Wie messen-e123.ps1, aber beendet Eudora zuerst selbst (File > Exit, 57665)
# und kehrt dann zurueck - testlauf.ps1 schickt danach ein ZWEITES WM_CLOSE.
# PRUEFER-34 S1: ein zweites Schliessen waehrend des Wartens muss ignoriert
# werden; frueher fuehrte es in einen Haenger.
param([string] $Pfadfilter)
$t = $PSScriptRoot
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32772 -Sekunden 15 | Select-Object -Last 2
Start-Sleep -Seconds 4
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 57665 -Sekunden 5 | Select-Object -Last 1
Start-Sleep -Seconds 3
