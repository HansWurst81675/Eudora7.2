# pruefstand-einrichten.ps1 - die Pruefverzeichnisse unter C:\Temp aus dem
# Repo anlegen, damit tools\pruefstand-lauf.ps1 aus jedem Klon laeuft (E-151).
#
# -------------------------------------------------------------------------
# WARUM ES DAS GIBT
# -------------------------------------------------------------------------
#
# Gregor am 05.11.2026: "ich moechte separat von hier (oder auch jemand, der
# die repo forkt oder clonet) die tests nach eigenen aenderungen durchfuehren.
# um zu sehen, dass die neue implementierung nichts kaputt gemacht hat."
# Bis dahin gab es die Pruefverzeichnisse nur auf der Entwicklermaschine.
#
# -------------------------------------------------------------------------
# WAS ES TUT
# -------------------------------------------------------------------------
#
# Fuer jedes Pruefverzeichnis der Fallliste (tools\pruefstand-faelle.txt):
#   1. Paket: die Grundlage auspacken - ein Release-ZIP dieses Projekts
#      (-Grundlage; ohne Angabe das neueste Releases\Eudora72-7.2.*-release.zip
#      im Repo, sonst das neueste Release von GitHub).
#   2. Eigener Bau darueber: die Dateien, die das Projekt selbst baut, aus
#      Eudora71\Bin\Release (dieselbe Liste wie tools\paket-bauen.ps1
#      -AusBauverzeichnis). Fehlt der Bau, wird das RELEASE geprueft, nicht die
#      eigene Aenderung - das sagt das Skript dann laut.
#   3. Grundstand: Testdaten\pruefstand\<Name>\Mailverzeichnis (Pruef-
#      Persoenlichkeit, Pruefserver 127.0.0.1, IMAP-Konto "pruefimap"; erfasst
#      mit tools\pruefstand-vorlage-erfassen.ps1).
#   4. Marke .eudora72-pruefstand - nur Verzeichnisse MIT dieser Marke
#      werden spaeter wieder angefasst (-Erneuern). Ein vorhandenes
#      Verzeichnis OHNE Marke (etwa die gewachsenen Pruefstaende der
#      Entwicklermaschine) bleibt unberuehrt.
#
# Was hier nicht einrichtbar ist, steht danach in
# C:\Temp\Eudora72-Pruefstand-nicht-einrichtbar.txt; pruefstand-lauf.ps1
# zaehlt diese Faelle als UEBERSPRUNGEN (Gregor 05.11.2026, S/MIME-Fall:
# "ja, ueberspringen"). Das sind heute E-222w (S/MIME) und E-166a/E-166b (die
# Junk-Frage kommt nur mit geladenem Junk-Plugin): sie brauchen MFC71.DLL und
# msvcp71.dll, die dieses Projekt nicht weitergeben darf (Befund S-3c). Wer
# sie hat, gibt den Ordner mit -ZusatzDlls an (gemessen an der Klonprobe
# vom 05.11.2026: ohne sie E-166a/b "Vorbereiten gescheitert").
#
# Wurzel ist C:\Temp: rund vierzig Messskripte pruefen vor jeder Wirkung, dass
# ihr Verzeichnis direkt unter C:\Temp liegt (Pfadschranke). Eine andere
# Wurzel waere ein eigener Schritt.
#
# Aufruf:
#   powershell -NoProfile -ExecutionPolicy Bypass -File tools\pruefstand-einrichten.ps1
#       [-Grundlage <zip>] [-ZusatzDlls <ordner>] [-Erneuern] [-Nur <Name>] [-NurZeigen]
#
# Kodierung: reines ASCII, nur LF.

[CmdletBinding()]
param(
    [string] $Grundlage  = '',
    [string] $ZusatzDlls = '',
    [switch] $Erneuern,
    [string] $Nur        = '',
    [switch] $NurZeigen,
    # C:\Temp oder ein Ordner darunter (siehe tools\pruefstand-lauf.ps1 -Wurzel)
    [string] $Wurzel = $(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp\Eudora72-Pruefstand' }),
    # Bauverzeichnis mit Eudora.exe usw.; Vorgabe Eudora71\Bin\Release dieses Repos
    [string] $Bau = ''
)
$ErrorActionPreference = 'Stop'
$repo  = Split-Path -Parent $PSScriptRoot
$wurzelTemp = [IO.Path]::GetFullPath($Wurzel).TrimEnd('\')
if ($wurzelTemp -notmatch '^[A-Za-z]:\\[^\\]+') { Write-Host "  ABGEWIESEN: -Wurzel muss ein Ordner sein, kein Laufwerksstamm: $wurzelTemp"; exit 2 }
$env:EUDORA72_PRUEFSTAND = $wurzelTemp
if (-not (Test-Path -LiteralPath $wurzelTemp)) { New-Item -ItemType Directory -Force -Path $wurzelTemp | Out-Null }
$vorlagen = Join-Path $repo 'Testdaten\pruefstand'
$binRel = if ($Bau) { $Bau } else { Join-Path $repo 'Eudora71\Bin\Release' }
$marke  = '.eudora72-pruefstand'
$nichtEinrichtbar = Join-Path $wurzelTemp 'Eudora72-Pruefstand-nicht-einrichtbar.txt'
Add-Type -AssemblyName System.IO.Compression.FileSystem

# --- Faelle und Verzeichnisse ----------------------------------------------
$faelle = @()
foreach ($z in [IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'pruefstand-faelle.txt'))) {
    if ($z -match '^\s*(#|$)') { continue }
    $f = $z.Split('|'); if ($f.Count -lt 8) { continue }
    $vz = $f[1].Trim(); if ($vz -match '^C:\\Temp\\(.+)$') { $vz = Join-Path $wurzelTemp $Matches[1] }
    $faelle += [pscustomobject]@{ Kennung = $f[0].Trim(); Verzeichnis = $vz }
}
$verz = @($faelle.Verzeichnis | Sort-Object -Unique)
if ($Nur) { $verz = @($verz | Where-Object { (Split-Path -Leaf $_) -like $Nur }) }
Write-Host '  ------------------------------------------------------------'
Write-Host '  Pruefverzeichnisse einrichten (E-151)'
Write-Host '  ------------------------------------------------------------'
Write-Host ("    {0} Verzeichnisse unter {1}" -f $verz.Count, $wurzelTemp)

# --- Grundlage finden ------------------------------------------------------
if (-not $Grundlage) {
    $lokal = @(Get-ChildItem -LiteralPath (Join-Path $repo 'Releases') -Filter 'Eudora72-7.2.*-release.zip' -File -ErrorAction SilentlyContinue |
               Sort-Object { [version](($_.Name -replace '^Eudora72-', '') -replace '-release\.zip$', '') } -Descending)
    if ($lokal.Count -gt 0) { $Grundlage = $lokal[0].FullName }
}
if (-not $Grundlage -and -not $NurZeigen) {
    # Das neueste Release von GitHub - ein Fork prueft gegen dieselben
    # Fremddateien wie das Projekt selbst.
    $api = 'https://api.github.com/repos/HansWurst81675/Eudora7.2/releases/latest'
    Write-Host "    Keine Grundlage im Repo - lade das neueste Release von GitHub ..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $rel = Invoke-RestMethod -Uri $api -UseBasicParsing -Headers @{ 'User-Agent' = 'Eudora72-Pruefstand' }
    $asset = @($rel.assets | Where-Object { $_.name -like 'Eudora72-*-release.zip' }) | Select-Object -First 1
    if (-not $asset) { Write-Host "  ABBRUCH: im Release $($rel.tag_name) liegt kein Eudora72-*-release.zip"; exit 2 }
    $Grundlage = Join-Path $wurzelTemp $asset.name
    if (-not (Test-Path -LiteralPath $Grundlage)) {
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $Grundlage -UseBasicParsing -Headers @{ 'User-Agent' = 'Eudora72-Pruefstand' }
    }
}
if ($Grundlage -and -not (Test-Path -LiteralPath $Grundlage)) { Write-Host "  ABBRUCH: Grundlage fehlt: $Grundlage"; exit 2 }
Write-Host ("    Grundlage: {0}" -f $(if ($Grundlage) { $Grundlage } else { '(keine - nur anzeigen)' }))

# --- eigener Bau -----------------------------------------------------------
$eigene = @('Eudora.exe', 'EudoraRes.dll', 'EuLang.dll', 'Imap.dll', 'QCSocket.dll', 'QCUtils.dll', 'plstclnt.dll', 'QCSSL.dll', 'msvcr71.dll')
$mitBau = Test-Path -LiteralPath (Join-Path $binRel 'Eudora.exe')
if ($mitBau) {
    Write-Host ("    Eigener Bau: {0}" -f $binRel)
} else {
    Write-Host '    ACHTUNG: kein eigener Bau in Eudora71\Bin\Release - geprueft wird die'
    Write-Host '    Grundlage (das Release), NICHT eine eigene Aenderung. Erst bauen:'
    Write-Host '    powershell -File tools\bauen.ps1'
}

# --- Zusatz-DLLs fuer S/MIME ----------------------------------------------
$smime = @()
if ($ZusatzDlls) {
    foreach ($d in 'MFC71.DLL', 'msvcp71.dll') {
        $q = Join-Path $ZusatzDlls $d
        if (Test-Path -LiteralPath $q) { $smime += $q } else { Write-Host "    -ZusatzDlls: $d fehlt in $ZusatzDlls" }
    }
}
$smimeDa = ($smime.Count -eq 2)

# --- je Verzeichnis --------------------------------------------------------
$nichtListe = @()
$angelegt = 0; $uebergangen = 0
foreach ($v in $verz) {
    $name = Split-Path -Leaf $v
    $voll = [IO.Path]::GetFullPath($v).TrimEnd('\')
    if ($voll -notmatch ('^' + [regex]::Escape($(if ($env:EUDORA72_PRUEFSTAND) { $env:EUDORA72_PRUEFSTAND } else { 'C:\Temp\Eudora72-Pruefstand' })) + '\\[^\\]+$')) { Write-Host "    ABGEWIESEN: $voll liegt nicht direkt unter der Wurzel"; continue }
    $vorlage = Join-Path $vorlagen $name
    if (-not (Test-Path -LiteralPath (Join-Path $vorlage 'Mailverzeichnis\Eudora.ini'))) {
        foreach ($f in ($faelle | Where-Object { $_.Verzeichnis -eq $v })) { $nichtListe += ("{0}`tkeine Vorlage Testdaten\pruefstand\{1}" -f $f.Kennung, $name) }
        Write-Host ("    {0,-42} KEINE VORLAGE" -f $name); continue
    }
    if (Test-Path -LiteralPath $voll) {
        if (-not (Test-Path -LiteralPath (Join-Path $voll $marke))) {
            # Ein fremdes Verzeichnis gleichen Namens: unberuehrt lassen UND
            # seine Faelle nicht darin fahren (sie zaehlen als uebersprungen).
            foreach ($f in ($faelle | Where-Object { $_.Verzeichnis -eq $v })) { $nichtListe += ("{0}`t{1} gibt es schon und stammt nicht von diesem Skript - umbenennen oder -Wurzel waehlen" -f $f.Kennung, $voll) }
            Write-Host ("    {0,-42} vorhanden, nicht von diesem Skript - bleibt unberuehrt" -f $name); $uebergangen++; continue
        }
        if (-not $Erneuern) { Write-Host ("    {0,-42} schon eingerichtet (-Erneuern legt neu an)" -f $name); $uebergangen++; continue }
        $laeuft = Get-Process Eudora -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', 'OrdinalIgnoreCase') }
        if ($laeuft) { Write-Host ("    {0,-42} Eudora laeuft dort - nicht angefasst" -f $name); $uebergangen++; continue }
    }
    if ($NurZeigen) { Write-Host ("    {0,-42} wuerde angelegt" -f $name); continue }

    if (Test-Path -LiteralPath $voll) { Remove-Item -LiteralPath $voll -Recurse -Force }
    New-Item -ItemType Directory -Force -Path $voll | Out-Null
    [IO.Compression.ZipFile]::ExtractToDirectory($Grundlage, $voll)
    # Manche Release-ZIPs tragen einen Oberordner - dann eine Ebene hoeher holen.
    $kinder = @(Get-ChildItem -LiteralPath $voll)
    if ($kinder.Count -eq 1 -and $kinder[0].PSIsContainer -and (Test-Path -LiteralPath (Join-Path $kinder[0].FullName 'Eudora.exe'))) {
        foreach ($k in Get-ChildItem -LiteralPath $kinder[0].FullName -Force) { Move-Item -LiteralPath $k.FullName -Destination $voll }
        Remove-Item -LiteralPath $kinder[0].FullName -Recurse -Force
    }
    if ($mitBau) {
        foreach ($d in $eigene) {
            $q = Join-Path $binRel $d
            if (Test-Path -LiteralPath $q) { Copy-Item -LiteralPath $q -Destination (Join-Path $voll $d) -Force }
        }
        $rc = Join-Path $repo 'Releases\1.0\rootcerts.p7b'
        if (Test-Path -LiteralPath $rc) { Copy-Item -LiteralPath $rc -Destination (Join-Path $voll 'rootcerts.p7b') -Force }
    }
    # Grundstand: das Mailverzeichnis des Pakets ersetzen
    $md = Join-Path $voll 'Mailverzeichnis'
    if (Test-Path -LiteralPath $md) { Remove-Item -LiteralPath $md -Recurse -Force }
    Copy-Item -LiteralPath (Join-Path $vorlage 'Mailverzeichnis') -Destination $md -Recurse -Force
    if (($name -like 'E222*' -or $name -eq 'E166') -and $smimeDa) { foreach ($q in $smime) { Copy-Item -LiteralPath $q -Destination $voll -Force } }
    [IO.File]::WriteAllText((Join-Path $voll $marke), ("eingerichtet " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + " aus " + $Grundlage + "`n"))
    $angelegt++
    Write-Host ("    {0,-42} angelegt" -f $name)
}

# --- nicht einrichtbar -----------------------------------------------------
if (-not $smimeDa) {
    foreach ($f in ($faelle | Where-Object { $_.Kennung -in 'E-222w', 'E-166a', 'E-166b' })) {
        $nichtListe += ("{0}`tS/MIME- bzw. Junk-Plugin braucht MFC71.DLL und msvcp71.dll (nicht im Projekt, Befund S-3c); mit -ZusatzDlls <ordner> einrichtbar" -f $f.Kennung)
    }
}
if (-not $NurZeigen) {
    $kopf = @('# Erzeugt von tools/pruefstand-einrichten.ps1 - Faelle, die auf diesem Rechner nicht einrichtbar sind.',
              '# Kennung<TAB>Grund. tools/pruefstand-lauf.ps1 zaehlt sie als uebersprungen.')
    [IO.File]::WriteAllLines($nichtEinrichtbar, [string[]]($kopf + $nichtListe), (New-Object Text.UTF8Encoding $false))
}
Write-Host '  ------------------------------------------------------------'
Write-Host ("  Angelegt: {0}, unberuehrt: {1}, nicht einrichtbar: {2} Fall/Faelle" -f $angelegt, $uebergangen, $nichtListe.Count)
foreach ($n in $nichtListe) { Write-Host ("    [UEBR] {0}" -f ($n -replace "`t", '  ')) }
exit 0
