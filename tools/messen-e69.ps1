# Laeuft unter testlauf.ps1 (-MessenSkript): oeffnet "In" (32792), waehlt alles
# aus (ID_EDIT_SELECT_ALL 0xE12A = 57642), SPERRT In.mbx von aussen (wie ein
# Virenscanner) und loest "Special > Filter Messages" (32816) aus. Danach wird
# die Sperre geloest.
#
# WARUM ES DAS GIBT: Befund E-69 - eine Nachricht, die der Filter nicht lesen
# kann, wurde lautlos uebersprungen. Seit 7.2.0.105 steht dafuer ein Eintrag
# in "Task Errors" und die Spurmarke "E-69 Filter uebersprungen" im Protokoll.
# Voraussetzung: in "In" liegt eine Nachricht, auf die eine Filterregel passt.
param([string] $Pfadfilter)
$t = $PSScriptRoot
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32792 -Sekunden 10 | Select-Object -Last 1
Start-Sleep -Seconds 3
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 57642 -Sekunden 5 | Select-Object -Last 1
Start-Sleep -Seconds 1
$mbx = Join-Path $Pfadfilter 'Mailverzeichnis\In.mbx'
$sperre = $null
try {
    $sperre = [IO.File]::Open($mbx, 'Open', 'Read', 'None')
    Write-Host "In.mbx gesperrt"
    & powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32816 -Sekunden 5 | Select-Object -Last 1
    Start-Sleep -Seconds 5
} catch {
    Write-Host ("In.mbx nicht zu sperren: " + $_.Exception.Message)
} finally {
    if ($sperre) { $sperre.Close(); Write-Host "Sperre geloest" }
}
Start-Sleep -Seconds 2
