# postfaecher-zusammenfuehren.ps1 - die verstreuten Postfaecher aus den alten
# Testverzeichnissen in einem Mailverzeichnis zusammenfuehren.
#
# WARUM ES DAS GIBT
#
# Am 10.09.2026 ist Gregors Post auf dem Server geloescht worden (BEFUND
# E-74). Lokal war sie noch da, aber ueber mehrere Testverzeichnisse
# verstreut: der alte Bestand in 1.0.28, der neue in 1.0.36, die gesendeten
# in 1.0.32. Verglichen wurde ueber die Betreffzeilen ALLER Postfaecher in
# ALLEN Testverzeichnissen; 1.0.25, 1.0.26, 1.0.27 und 1.0.38 enthalten
# nichts, was nicht in diesen dreien steht.
#
# WAS ES TUT
#
#   1. Nimmt das Mailverzeichnis von 1.0.36 als Grundlage - nur dort stehen
#      die Persoenlichkeit und die descmap.pce mit GMX und HW_Bxo. Ohne die
#      taucht GMX.mbx in der Postfachliste gar nicht auf.
#   2. Legt In.mbx (1.0.28) und Out.mbx (1.0.32) dazu.
#   3. Loescht die zugehoerigen .toc - Eudora baut sie beim Start neu auf -
#      und die eudora.log, damit die naechste Messung sauber ist.
#   4. Traegt DeleteFetchedJunk=0 in [Settings] der Eudora.ini ein.
#
# SCHRITT 4 IST DER WICHTIGE. DEudora.ini wirkt nur auf NEU angelegte
# Konten. Fuer ein bestehendes Konto gilt die eingebaute Vorgabe - und die
# heisst "als Junk eingestufte Post auf dem Server loeschen". Genau daran ist
# es am 10.09.2026 gescheitert.
#
# Aufruf (PowerShell):
#   powershell -ExecutionPolicy Bypass -File tools\postfaecher-zusammenfuehren.ps1
#   ... -Ziel "C:\Users\Gregor\Eudora72-1.0.40-release"      andere Fassung
#   ... -NurZeigen                                           nichts schreiben
#
# Kodierung: reines ASCII, kein BOM.

[CmdletBinding()]
param(
    [string] $Ziel      = 'C:\Users\Gregor\Eudora72-1.0.39-release',
    [string] $Basis     = 'C:\Users\Gregor\Eudora72-1.0.36-release',
    [string] $AltesIn   = 'C:\Users\Gregor\Eudora72-1.0.28-release',
    [string] $AltesOut  = 'C:\Users\Gregor\Eudora72-1.0.32-release',
    [switch] $NurZeigen
)

$ErrorActionPreference = 'Stop'

$mZiel  = Join-Path $Ziel     'Mailverzeichnis'
$mBasis = Join-Path $Basis    'Mailverzeichnis'
$fIn    = Join-Path (Join-Path $AltesIn  'Mailverzeichnis') 'In.mbx'
$fOut   = Join-Path (Join-Path $AltesOut 'Mailverzeichnis') 'Out.mbx'

# --- Erst pruefen, dann anfassen ------------------------------------------
$fehlt = @()
if (-not (Test-Path -LiteralPath $Ziel))   { $fehlt += "Zielfassung fehlt: $Ziel" }
if (-not (Test-Path -LiteralPath $mBasis)) { $fehlt += "Grundlage fehlt: $mBasis" }
if (-not (Test-Path -LiteralPath $fIn))    { $fehlt += "In.mbx fehlt: $fIn" }
if (-not (Test-Path -LiteralPath $fOut))   { $fehlt += "Out.mbx fehlt: $fOut" }

if ($fehlt.Count -gt 0) {
    Write-Host ''
    Write-Host '  ABBRUCH - es wurde nichts angefasst:'
    Write-Host ''
    foreach ($f in $fehlt) { Write-Host ("    " + $f) }
    Write-Host ''
    exit 1
}

Write-Host ''
Write-Host '  Zusammenfuehren'
Write-Host  ('  ' + ('-' * 68))
Write-Host  ('  Grundlage   ' + $mBasis)
Write-Host  ('  dazu        ' + $fIn)
Write-Host  ('  dazu        ' + $fOut)
Write-Host  ('  Ziel        ' + $mZiel)
Write-Host  ('  ' + ('-' * 68))

if ($NurZeigen) {
    Write-Host '  -NurZeigen: es wird nichts geschrieben.'
    Write-Host ''
    exit 0
}

# --- 1. Grundlage ----------------------------------------------------------
if (Test-Path -LiteralPath $mZiel) { Remove-Item -LiteralPath $mZiel -Recurse -Force }
Copy-Item -LiteralPath $mBasis -Destination $mZiel -Recurse

# --- 2. Die beiden fehlenden Postfaecher ----------------------------------
Copy-Item -LiteralPath $fIn  -Destination $mZiel -Force
Copy-Item -LiteralPath $fOut -Destination $mZiel -Force

# --- 3. Inhaltsverzeichnisse und altes Protokoll weg ----------------------
foreach ($n in @('In.toc', 'Out.toc', 'eudora.log')) {
    $p = Join-Path $mZiel $n
    if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force }
}

# --- 4. Die Loeschsperre fuer das BESTEHENDE Konto ------------------------
$ini = Join-Path $mZiel 'Eudora.ini'
if (Test-Path -LiteralPath $ini) {
    $t = Get-Content -Raw -LiteralPath $ini
    if ($t -notmatch 'DeleteFetchedJunk') {
        if ($t -match "(?m)^\[Settings\]") {
            $t = $t -replace "(?m)^\[Settings\]", "[Settings]`r`nDeleteFetchedJunk=0"
            Set-Content -LiteralPath $ini -Value $t -Encoding Ascii
            Write-Host '  DeleteFetchedJunk=0 in [Settings] eingetragen'
        } else {
            Write-Host '  ACHTUNG: kein [Settings] in der Eudora.ini gefunden -'
            Write-Host '  DeleteFetchedJunk=0 bitte von Hand eintragen.'
        }
    } else {
        Write-Host '  DeleteFetchedJunk steht schon in der Eudora.ini'
    }
} else {
    Write-Host '  ACHTUNG: keine Eudora.ini im Ziel'
}

# --- Nachmessen ------------------------------------------------------------
Write-Host ''
Write-Host '  Ergebnis:'
$summe = 0
Get-ChildItem -LiteralPath $mZiel -Filter *.mbx | Sort-Object Name | ForEach-Object {
    if ($_.Length -gt 0) {
        $n = ([regex]::Matches((Get-Content -Raw -LiteralPath $_.FullName), "(?m)^From ")).Count
        $summe += $n
        Write-Host ("    {0,-12} {1,10:N0} B   {2,3} Nachrichten" -f $_.Name, $_.Length, $n)
    }
}
Write-Host ("    {0,-12} {1,10}     {2,3} Nachrichten insgesamt" -f '', '', $summe)
Write-Host ''
exit 0
