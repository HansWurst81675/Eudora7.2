# messen-e188fm.ps1 - Huelle: tools\messen-e188.ps1 -Weg fetchmehr (Befund E-188).
# Beschreibung der Wege und der Ergebniszeile dort. Kodierung: reines ASCII.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$skript = Join-Path $PSScriptRoot 'messen-e188.ps1'
if ($Vorbereiten) { & $skript -Pfadfilter $Pfadfilter -Vorbereiten }
else { & $skript -Pfadfilter $Pfadfilter -Weg fetchmehr }
exit $LASTEXITCODE
