# Laeuft unter testlauf.ps1 (-MessenSkript): oeffnet das Filterfenster
# (ID_WINDOW_FILTERS = 32826) und laesst es einige Sekunden stehen.
#
# WARUM ES DAS GIBT: Befund E-67 - eine Regel "Junk Score is less than N"
# wurde durch blosses Ansehen im Filterfenster zu "matches regexp N" und
# gespeichert. Die Behebung (">" -> ">=" in filtersv.cpp) steht seit
# 09.09.2026 im Code, war aber nie am laufenden Programm gemessen. Gemessen
# wird von aussen: vorher steht in Filters.pce als erste Regel "verb less",
# nachher muss es dort noch stehen (Auswertung im Aufrufer).
#
# Aufruf ueber testlauf.ps1:
#   tools\testlauf.ps1 -Verzeichnis C:\Temp\E118 -Freigabe "Gregor am <Datum>: ..." `
#       -MessenSkript tools\messen-e67.ps1
#
# Seit 25.10.2026 Pruefstandsfall (tools\pruefstand-faelle.txt, Stand
# C:\Temp\E67): -Vorbereiten schreibt eine Filters.pce, deren ERSTE Regel
# "Junk Score is less than 50" ist - ohne diese Lage zeigt die Spurmarke
# nichts, was den Fehler unterscheidet. Erwartet im eudora.log:
#   E-67 Filteransicht laden: ... verb-gespeichert=14 verb-auswahl=0
# Mit dem alten ">" (Gegenprobe vom 17.10.2026): verb-auswahl=14.
param([string] $Pfadfilter, [switch] $Vorbereiten)

if ($Vorbereiten) {
    $voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E67 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    $md = Join-Path $voll 'Mailverzeichnis'
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E67 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    # Der Kopf heisst in Filters.pce <<Junk Score>> mit den CP1252-Zeichen
    # 0xAB und 0xBB (IDS_FIO_JUNK_SCORE, EudoraRes.rc) - als Bytes gesetzt,
    # damit dieses Skript reines ASCII bleibt.
    $lat = [Text.Encoding]::GetEncoding(28591)
    $junk = $lat.GetString([byte[]](0xAB)) + 'Junk Score' + $lat.GetString([byte[]](0xBB))
    $zeilen = @('3', 'rule E-67 Junk', 'incoming', "header $junk", 'verb less', 'value 50',
                'conjunction ignore', 'header ', 'verb contains', 'value ')
    [IO.File]::WriteAllText((Join-Path $md 'Filters.pce'), (($zeilen -join "`r`n") + "`r`n"), $lat)
    Write-Host "E67 vorbereitet: Filters.pce mit 'Junk Score is less than 50' als erster Regel"
    exit 0
}
$t = $PSScriptRoot
& powershell -NoProfile -ExecutionPolicy Bypass -File "$t\befehl-schicken.ps1" -Verzeichnis $Pfadfilter -Befehl 32826 -Sekunden 8 | Select-Object -Last 3
Start-Sleep -Seconds 6
