# pruefstaende-auffrischen.ps1 - bringt jeden Pruefstand aus
# tools\pruefstand-faelle.txt auf den aktuellen Release-Bau.
#
#   powershell -ExecutionPolicy Bypass -File tools\pruefstaende-auffrischen.ps1
#   powershell -ExecutionPolicy Bypass -File tools\pruefstaende-auffrischen.ps1 -NurZeigen
#
# WARUM ES DAS GIBT. Gregor am 24.10.2026: "welcher test ist wann mit welchem
# build gelaufen." Gemessen am 25.10.2026: die sieben Pruefstaende trugen
# sieben verschiedene Bauten, alle mit derselben Fassung 7.2.0.122 - der
# Stand C:\Temp\E77 etwa einen von 12:55 am 24.10., VOR der Behebung des
# Umbenennens. Ein Bericht, der sie als "dieser Bau" zaehlt, ist die Luege vom
# 22.10.2026 (LEKTOR L-50.1), nur eine Stufe feiner. Ein voller Pruefstandslauf
# fuer den Pruefbericht beginnt deshalb hiermit.
#
# WAS ES TUT. Kopiert dieselben eigenen Dateien, die tools\paket-bauen.ps1 aus
# dem Bauverzeichnis uebernimmt (Eudora.exe, EudoraRes.dll, EuLang.dll,
# Imap.dll, QCSocket.dll, QCUtils.dll, plstclnt.dll, QCSSL.dll) und die
# Wurzelzertifikate aus Releases\1.0 (E-148) in jeden Pruefstand. Mailverzeichnis
# und Einstellungen bleibt unberuehrt. Nur unter C:\Temp, nie in Gregors
# Verzeichnisse (CLAUDE.md, Abschnitt 4). Laeuft dort eine Eudora, bricht es ab.
#
# Kodierung: reines ASCII, kein BOM.
[CmdletBinding()]
param([switch] $NurZeigen)
$ErrorActionPreference = 'Stop'
$wurzel = Split-Path -Parent $PSScriptRoot
$bin = Join-Path $wurzel 'Eudora71\Bin\Release'
$dateien = @('Eudora.exe', 'EudoraRes.dll', 'EuLang.dll', 'Imap.dll', 'QCSocket.dll', 'QCUtils.dll', 'plstclnt.dll', 'QCSSL.dll')

function Kennung([string] $exe) {
    if (-not (Test-Path -LiteralPath $exe)) { return '(keine Eudora.exe)' }
    $t = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($exe))
    $m = [regex]::Match($t, 'Eudora \d+\.\d+\.\d+\.\d+(?: / Paket [0-9.]+)?\+[0-9a-f]+\*? \d{4}-\d\d-\d\d \d\d:\d\d')
    if ($m.Success) { $m.Value } else { '(Baukennung nicht gefunden)' }
}

$neu = Kennung (Join-Path $bin 'Eudora.exe')
Write-Host "  Bau im Bauverzeichnis: $neu"
$verz = @()
foreach ($z in [IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'pruefstand-faelle.txt'))) {
    if ($z -match '^\s*(#|$)') { continue }
    $f = $z.Split('|')
    if ($f.Count -lt 8) { continue }
    $verz += $f[1].Trim()
}
$verz = $verz | Sort-Object -Unique
$fehler = 0
foreach ($v in $verz) {
    $voll = [IO.Path]::GetFullPath($v).TrimEnd('\')
    if ($voll -notmatch '^C:\\Temp\\[^\\]+$') { Write-Host "  ABGEWIESEN: $voll liegt nicht direkt unter C:\Temp"; $fehler++; continue }
    if (-not (Test-Path -LiteralPath $voll)) { Write-Host "  FEHLT: $voll"; $fehler++; continue }
    $laeuft = Get-Process Eudora -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', 'OrdinalIgnoreCase') }
    if ($laeuft) { Write-Host "  LAEUFT: in $voll ist Eudora offen (PID $($laeuft.Id)) - nicht angefasst"; $fehler++; continue }
    $alt = Kennung (Join-Path $voll 'Eudora.exe')
    if ($NurZeigen) { Write-Host ("  {0,-16} {1}" -f $voll, $alt); continue }
    foreach ($d in $dateien) {
        $q = Join-Path $bin $d
        if (Test-Path -LiteralPath $q) { Copy-Item -LiteralPath $q -Destination (Join-Path $voll $d) -Force }
    }
    Copy-Item -LiteralPath (Join-Path $wurzel 'Releases\1.0\rootcerts.p7b') -Destination (Join-Path $voll 'rootcerts.p7b') -Force
    $jetzt = Kennung (Join-Path $voll 'Eudora.exe')
    $ok = if ($jetzt -eq $neu) { 'ok' } else { 'ABWEICHUNG' }
    if ($ok -ne 'ok') { $fehler++ }
    Write-Host ("  {0,-16} {1}  (vorher {2})" -f $voll, $ok, $alt)
}
exit $(if ($fehler) { 1 } else { 0 })
