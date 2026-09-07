# messen.ps1 - vergleicht den Aufbau der Paige-Strukturen unter VS2022
# mit dem Aufbau der 2005 gebauten Paige32.dll (Befund E-31).
#
#   powershell -ExecutionPolicy Bypass -File tools\pruefstand\messen.ps1
#   powershell ... -Zusatz '/DPG_ALT_TIME_T'    (Zustand VOR der Behebung)
#
# Ablauf:
#   1. pdb-felder.cpp uebersetzen (liest Feldaufbau aus einer PDB)
#   2. paige-groessen.cpp mit den heutigen Kopfdateien uebersetzen (/Zi)
#   3. beide PDB auslesen und die sizeof-Werte gegenueberstellen
#
# Rueckgabe: 0 = kein Unterschied, 1 = Unterschied gefunden, 2 = Aufrufproblem.

param(
  [string]$Wurzel   = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),
  [string]$Pdb      = '',
  [string]$Kopfdateien = '',
  [string[]]$Zusatz = @(),
  [string]$Arbeit   = ''
)

$ErrorActionPreference = 'Stop'

if (-not $Pdb)    { $Pdb    = Join-Path $Wurzel 'Eudora71\Bin\Release\Paige32.pdb' }
if (-not $Kopfdateien) { $Kopfdateien = Join-Path $Wurzel 'Eudora71\PaigeDLL\PGHEADER' }
if (-not $Arbeit) { $Arbeit = Join-Path $env:TEMP ('paige-messen-' + [guid]::NewGuid().ToString('N').Substring(0,8)) }

function Finde-Cl {
  $vw = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
  if (-not (Test-Path $vw)) { return $null }
  $basis = & $vw -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
  if (-not $basis) { return $null }
  $mv = (Get-ChildItem "$basis\VC\Tools\MSVC" -Directory | Sort-Object Name -Descending | Select-Object -First 1).Name
  [pscustomobject]@{ Basis = $basis; Version = $mv }
}

$vc = Finde-Cl
if (-not $vc) { Write-Host 'cl.exe nicht gefunden.' -ForegroundColor Red; exit 2 }

$sdkBasis = 'C:\Program Files (x86)\Windows Kits\10'
$sdk = (Get-ChildItem "$sdkBasis\Include" -Directory | Sort-Object Name -Descending | Select-Object -First 1).Name

$mv = $vc.Version
$env:INCLUDE = @(
  "$($vc.Basis)\VC\Tools\MSVC\$mv\include"
  "$($vc.Basis)\DIA SDK\include"
  "$sdkBasis\Include\$sdk\ucrt"
  "$sdkBasis\Include\$sdk\um"
  "$sdkBasis\Include\$sdk\shared"
) -join ';'
$env:LIB = @(
  "$($vc.Basis)\VC\Tools\MSVC\$mv\lib\x86"
  "$($vc.Basis)\DIA SDK\lib"
  "$sdkBasis\Lib\$sdk\ucrt\x86"
  "$sdkBasis\Lib\$sdk\um\x86"
) -join ';'
$cl = "$($vc.Basis)\VC\Tools\MSVC\$mv\bin\Hostx64\x86\cl.exe"
if (-not (Test-Path $cl)) { $cl = "$($vc.Basis)\VC\Tools\MSVC\$mv\bin\Hostx86\x86\cl.exe" }

New-Item -ItemType Directory -Force -Path $Arbeit | Out-Null
Push-Location $Arbeit
try {
  Write-Host (' cl        ' + $cl)
  Write-Host (' PGHEADER  ' + $Kopfdateien)
  Write-Host (' DLL-PDB   ' + $Pdb)
  Write-Host (' Arbeit    ' + $Arbeit)

  # --- 1. Leser bauen -------------------------------------------------------
  $q1 = Join-Path $Wurzel 'tools\pruefstand\pdb-felder.cpp'
  & $cl /nologo /EHsc /MD /W3 /D_CRT_SECURE_NO_WARNINGS $q1 /Fepdb-felder.exe `
        /link diaguids.lib ole32.lib oleaut32.lib | Out-Null
  if ($LASTEXITCODE -ne 0) { Write-Host 'pdb-felder.cpp liess sich nicht uebersetzen.' -ForegroundColor Red; exit 2 }

  # --- 2. heutige Kopfdateien in eine PDB ziehen ---------------------------
  $q2 = Join-Path $Wurzel 'tools\pruefstand\paige-groessen.cpp'
  $argumente = @('/nologo','/Zi','/MD','/W3','/DWIN32','/D_WINDOWS','/DWIN32_COMPILE',
                 '/DNDEBUG','/DOEMRESOURCE','/D_CRT_SECURE_NO_WARNINGS') +
               $Zusatz +
               @(('/I' + $Kopfdateien), $q2,
                 '/Feheute.exe','/Fdheute.pdb')
  & $cl @argumente 2>&1 | Where-Object { $_ -match 'error' } | ForEach-Object { Write-Host $_ -ForegroundColor Red }
  if (-not (Test-Path 'heute.pdb')) { Write-Host 'paige-groessen.cpp hat keine PDB erzeugt.' -ForegroundColor Red; exit 2 }

  # --- 3. beide Seiten auslesen und vergleichen ----------------------------
  function Lies-Groessen([string]$pdbPfad) {
    $t = @{}
    & '.\pdb-felder.exe' $pdbPfad 2>$null | ForEach-Object {
      if ($_ -match '^(\S+)\s+sizeof\s+(\d+)\s*$') { $t[$Matches[1]] = [int]$Matches[2] }
    }
    return $t
  }
  $dll   = Lies-Groessen $Pdb
  $heute = Lies-Groessen (Join-Path $Arbeit 'heute.pdb')
  Write-Host ''
  Write-Host (' Strukturen in der DLL-PDB     ' + $dll.Count)
  Write-Host (' Strukturen in der heutigen PDB ' + $heute.Count)

  $gemeinsam = @($heute.Keys | Where-Object { $dll.ContainsKey($_) } | Sort-Object)
  Write-Host (' gemeinsam                      ' + $gemeinsam.Count)
  Write-Host ''

  $abweichend = @()
  foreach ($n in $gemeinsam) {
    if ($dll[$n] -ne $heute[$n]) { $abweichend += [pscustomobject]@{ Struktur=$n; DLL=$dll[$n]; Heute=$heute[$n]; Delta=($heute[$n]-$dll[$n]) } }
  }
  if ($abweichend.Count -gt 0) {
    Write-Host (' sizeof UNTERSCHIEDLICH in ' + $abweichend.Count + ' von ' + $gemeinsam.Count + ' Strukturen:') -ForegroundColor Red
    foreach ($a in ($abweichend | Sort-Object Struktur)) {
      Write-Host ("   {0,-32} DLL {1,6}   heute {2,6}   Delta {3,5}" -f $a.Struktur, $a.DLL, $a.Heute, $a.Delta)
    }
  } else {
    Write-Host (' sizeof GLEICH in allen ' + $gemeinsam.Count + ' gemeinsamen Strukturen.') -ForegroundColor Green
  }

  # --- 4. Feldweise vergleichen --------------------------------------------
  # Gleiche Gesamtgroesse heisst noch nicht gleicher Aufbau: die Felder
  # koennten innen verschoben und die Luecke am Ende ausgeglichen sein.
  # Deshalb wird jedes Feld einzeln gegenuebergestellt.
  function Lies-Felder([string]$pdbPfad, [string[]]$namen) {
    $t = @{}; $aktuell = ''
    & '.\pdb-felder.exe' $pdbPfad @namen 2>$null | ForEach-Object {
      if ($_ -match '^=== (\S+)\s+sizeof') { $aktuell = $Matches[1]; return }
      if ($aktuell -and $_ -match '^\s+(\S+)\s+Offset\s+(\d+)\s+Groesse\s+(\d+)') {
        $t[$aktuell + '.' + $Matches[1] + '@' + $Matches[2]] = [int]$Matches[3]
        $t['ORT:' + $aktuell + '.' + $Matches[1]] = [int]$Matches[2]
      }
    }
    return $t
  }
  # nur die Strukturen, die auf BEIDEN Seiten eine Groesse > 0 haben
  $echt = @($gemeinsam | Where-Object { $dll[$_] -gt 0 -and $heute[$_] -gt 0 })
  $fDll   = Lies-Felder $Pdb $echt
  $fHeute = Lies-Felder (Join-Path $Arbeit 'heute.pdb') $echt

  $ortDll   = @{}; foreach ($k in $fDll.Keys)   { if ($k -like 'ORT:*') { $ortDll[$k]   = $fDll[$k] } }
  $ortHeute = @{}; foreach ($k in $fHeute.Keys) { if ($k -like 'ORT:*') { $ortHeute[$k] = $fHeute[$k] } }

  $feldFehler = @()
  foreach ($k in ($ortHeute.Keys | Sort-Object)) {
    if (-not $ortDll.ContainsKey($k)) { continue }
    if ($ortDll[$k] -ne $ortHeute[$k]) {
      $feldFehler += [pscustomobject]@{ Feld=$k.Substring(4); DLL=$ortDll[$k]; Heute=$ortHeute[$k] }
    }
  }
  $verglichen = @($ortHeute.Keys | Where-Object { $ortDll.ContainsKey($_) }).Count
  Write-Host ''
  if ($feldFehler.Count -eq 0) {
    Write-Host (' Feldoffsets GLEICH: ' + $verglichen + ' Felder in ' + $echt.Count + ' Strukturen geprueft.') -ForegroundColor Green
  } else {
    Write-Host (' Feldoffsets UNTERSCHIEDLICH: ' + $feldFehler.Count + ' von ' + $verglichen + ' Feldern:') -ForegroundColor Red
    foreach ($a in ($feldFehler | Sort-Object Feld)) {
      Write-Host ("   {0,-46} DLL {1,6}   heute {2,6}" -f $a.Feld, $a.DLL, $a.Heute)
    }
  }

  if ($abweichend.Count -eq 0 -and $feldFehler.Count -eq 0) { exit 0 }
  exit 1
}
finally { Pop-Location }
