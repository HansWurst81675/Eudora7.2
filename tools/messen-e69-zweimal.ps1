# Zweimal derselbe Handgriff im SELBEN Eudora-Lauf: In oeffnen, alles
# auswaehlen, In.mbx sperren, Special > Filter Messages. Gegenprobe zu R1
# aus PRUEFER-38 - ohne den Ruecksetzer in LaufEnde() bliebe der ZWEITE
# Durchgang stumm.
param([string] $Pfadfilter)
$t = "C:\Users\Gregor\Documents\github\Eudora7.2\tools"
$mbx = Join-Path $Pfadfilter 'Mailverzeichnis\In.mbx'
foreach ($durchgang in 1, 2) {
    Write-Host "--- Durchgang $durchgang ---"
    & powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32792 -Sekunden 8 | Select-Object -Last 1
    Start-Sleep -Seconds 2
    & powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 57642 -Sekunden 5 | Select-Object -Last 1
    Start-Sleep -Seconds 1
    $sperre = $null
    try {
        $sperre = [IO.File]::Open($mbx, 'Open', 'Read', 'None')
        Write-Host "  In.mbx gesperrt"
        & powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32816 -Sekunden 5 | Select-Object -Last 1
        Start-Sleep -Seconds 15
    } catch {
        Write-Host ("  In.mbx nicht zu sperren: " + $_.Exception.Message)
    } finally {
        if ($sperre) { $sperre.Close(); Write-Host "  Sperre geloest" }
    }
    Start-Sleep -Seconds 2
}
