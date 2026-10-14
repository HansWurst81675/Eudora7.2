# Laeuft unter testlauf.ps1: Abruf (32772), dann warten, bis der Filter
# die Nachricht ins IMAP-Postfach "Ablage" hochgeladen hat.
param([string] $Pfadfilter)
$t = 'C:\Users\Gregor\Documents\github\Eudora7.2\tools'
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32772 -Sekunden 15 | Select-Object -Last 3
$ablage = $env:E118_ABLAGE
for ($i = 0; $i -lt 60; $i++) {
    if ($ablage -and (Test-Path $ablage) -and @(Get-ChildItem $ablage -Filter 'append-*.eml').Count -gt 0) {
        Write-Host ("Ablage gefuellt nach " + ($i * 2) + " s")
        Start-Sleep -Seconds 3
        break
    }
    Start-Sleep -Seconds 2
}
Get-ChildItem $ablage -ErrorAction SilentlyContinue | ForEach-Object { Write-Host ("  " + $_.Name + " " + $_.Length + " B") }
