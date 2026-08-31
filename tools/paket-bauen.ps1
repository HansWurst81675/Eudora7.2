# Stellt ein Auslieferungspaket zusammen - reproduzierbar, aus dem Quellbaum.
#
#   powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 `
#              -Ziel "C:\Pfad\zum\Paketverzeichnis" [-Zip "C:\...\Eudora72-1.0.3-vorabfassung.zip"]
#
#   -Grundlage <zip>   nimmt ein bestehendes Paket-ZIP als Ausgangspunkt
#                      (Standard: Releases\Eudora72-1.0.2-lauffaehig.zip)
#
# Das Werkzeug VEROEFFENTLICHT nichts. Es legt ein Verzeichnis an und, wenn
# -Zip angegeben ist, ein ZIP daneben. Ob das ausgeliefert wird, entscheidet
# ein Mensch.
#
# WAS ES GEGENUEBER 1.0.2 AENDERT - und warum
#
#   1. msvcr71.dll  <- Eudora71\Bin\Release\msvcr71.dll (VC71Bruecke)
#      Ersetzt die unsignierte Fremddatei von dll-files.com durch die selbst
#      gebaute Weiterleitungs-DLL. Sie haengt nur an KERNEL32 und leitet 1429
#      Exporte an C:\Windows\SysWOW64\msvcrt.dll weiter (Befund B-1).
#
#   2. Paige32d.dll <- Kopie von Eudora71\Bin\Release\Paige32.dll
#      Im Paket 1.0.2 lag die DEBUG-Fassung von Paige. Die braucht MSVCR71D.dll,
#      und deshalb lag auch die her. Beide Fassungen sind ABI-gleich - vier
#      Belege in Eudora71\VC71Bruecke\BEFUND.md, Abschnitt 3, entscheidend
#      _pgAllocateNewRef@20 in beiden. Eudora.exe importiert den DATEINAMEN
#      Paige32d.dll, deshalb wird kopiert und umbenannt statt ersetzt.
#
#   3. msvcr71d.dll und msvcp71d.dll FALLEN WEG.
#      Nach 2. braucht sie niemand mehr. Beide stammten von dll-files.com.
#
#   4. Plugins\*.dll <- Eudora71\Bin\Release\Plugins
#      Im Paket 1.0.2 lagen dort die DEBUG-Fassungen (gemessen: sie importieren
#      MFC71D.DLL und MSVCP71D.dll). Beide Fassungen sind gleichermassen nicht
#      ladbar, weil MFC71 fehlt - aber die Release-Fassungen passen wenigstens
#      zum Rest des Pakets und sparen 12 MB Symboldateien.
#
#   5. laufzeit-holen.ps1 und paket-pruefen.ps1 kommen MIT ins Paket.
#      Ohne die vier VS2022-Debug-Laufzeiten scheitert der Start mit
#      0xc000007b. Das ist am 31.08.2026 genau so passiert.

param(
  [Parameter(Mandatory=$true)][string]$Ziel,
  [string]$Zip,
  [string]$Grundlage
)

$ErrorActionPreference = 'Stop'

$wurzel = Split-Path -Parent $PSScriptRoot
$binRel = Join-Path $wurzel 'Eudora71\Bin\Release'
if (-not $Grundlage) { $Grundlage = Join-Path $wurzel 'Releases\Eudora72-1.0.2-lauffaehig.zip' }

if (-not (Test-Path -LiteralPath $Grundlage)) { throw "Grundlage nicht gefunden: $Grundlage" }

Add-Type -AssemblyName System.IO.Compression.FileSystem

if (Test-Path -LiteralPath $Ziel) { Remove-Item -Recurse -Force -LiteralPath $Ziel }
New-Item -ItemType Directory -Force -Path $Ziel | Out-Null
$Ziel = (Resolve-Path -LiteralPath $Ziel).Path

Write-Host "Grundlage auspacken: $Grundlage"
[System.IO.Compression.ZipFile]::ExtractToDirectory($Grundlage, $Ziel)

function Nimm([string]$quelle, [string]$zielname) {
  if (-not (Test-Path -LiteralPath $quelle)) { throw "fehlt: $quelle" }
  $z = Join-Path $Ziel $zielname
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $z) | Out-Null
  Copy-Item -LiteralPath $quelle -Destination $z -Force
  Write-Host ("  {0,-28} <- {1}" -f $zielname, $quelle)
}
function Weg([string]$name) {
  $z = Join-Path $Ziel $name
  if (Test-Path -LiteralPath $z) { Remove-Item -Force -LiteralPath $z; Write-Host ("  {0,-28} entfernt" -f $name) }
}

Write-Host ''
Write-Host '1. Laufzeitbruecke statt Fremddatei'
Nimm (Join-Path $binRel 'msvcr71.dll') 'msvcr71.dll'

Write-Host ''
Write-Host '2. Paige: Release-Fassung unter dem Debug-Dateinamen'
Nimm (Join-Path $binRel 'Paige32.dll') 'Paige32d.dll'

Write-Host ''
Write-Host '3. Fremddateien von dll-files.com entfernen'
Weg 'msvcr71d.dll'
Weg 'msvcp71d.dll'

Write-Host ''
Write-Host '4. Plugins: Release-Fassungen, ohne Symboldateien'
foreach ($p in @('SMIME.dll','SpamHeaders.dll','SpamWatch.dll')) {
  Nimm (Join-Path $binRel "Plugins\$p") "Plugins\$p"
}
Get-ChildItem -LiteralPath (Join-Path $Ziel 'Plugins') -Filter *.pdb -ErrorAction Ignore |
  ForEach-Object { Remove-Item -Force -LiteralPath $_.FullName; Write-Host ("  Plugins\{0,-19} entfernt" -f $_.Name) }

Write-Host ''
Write-Host '5. Werkzeuge ins Paket'
Nimm (Join-Path $PSScriptRoot 'laufzeit-holen.ps1') 'laufzeit-holen.ps1'
Nimm (Join-Path $PSScriptRoot 'paket-pruefen.ps1')  'paket-pruefen.ps1'

$liesmich = Join-Path $wurzel 'Releases\1.0.3\LIESMICH.txt'
if (Test-Path -LiteralPath $liesmich) {
  Write-Host ''
  Write-Host '6. LIESMICH.txt der Fassung 1.0.3'
  Nimm $liesmich 'LIESMICH.txt'
}

Write-Host ''
Write-Host "Paketverzeichnis steht: $Ziel"

if ($Zip) {
  if (Test-Path -LiteralPath $Zip) { Remove-Item -Force -LiteralPath $Zip }
  [System.IO.Compression.ZipFile]::CreateFromDirectory($Ziel, $Zip)
  $h = (Get-FileHash -LiteralPath $Zip -Algorithm SHA256).Hash.ToLowerInvariant()
  $len = (Get-Item -LiteralPath $Zip).Length
  Write-Host ''
  Write-Host ("ZIP:    {0}" -f $Zip)
  Write-Host ("Groesse {0} B" -f $len)
  Write-Host ("SHA256  {0}" -f $h)
}

Write-Host ''
Write-Host 'Jetzt pruefen:'
Write-Host ("  powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket ""{0}""" -f $Ziel)
