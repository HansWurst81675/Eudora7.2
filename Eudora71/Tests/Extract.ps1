#
# Extract.ps1 - schneidet die zu pruefenden Code-Inseln aus dem Produktivcode heraus
#
# Warum ueberhaupt schneiden: utils.cpp und hexbin.cpp ziehen ueber stdafx.h die
# komplette Eudora-Welt herein (eudora.h, rs.h, guiutils.h, Ressourcen ...) und sind
# darum nicht einzeln uebersetzbar. Statt den Code abzutippen (Kopie veraltet sofort)
# wird er bei JEDEM Build frisch aus den Originaldateien geschnitten. Die Testdateien
# selbst enthalten keinen Produktivcode.
#
# Die Originaldateien werden nur GELESEN, niemals veraendert.
#
# Gelesen wird byteweise ueber Latin-1 (ISO-8859-1). Diese Kodierung bildet jedes Byte
# 0x00..0xFF auf genau einen Codepunkt ab, der Rueckweg beim Schreiben ist damit
# verlustfrei. Das ist wichtig, weil in der Tabelle CP1252-Zeichenliterale wie
# (UCHAR)'<80>' stehen, die kein gueltiges UTF-8 sind.
#

param(
    [Parameter(Mandatory=$true)][string]$SrcDir,
    [Parameter(Mandatory=$true)][string]$OutDir
)

$ErrorActionPreference = "Stop"
$latin1 = [System.Text.Encoding]::GetEncoding(28591)

function Read-Lines([string]$path) {
    if (-not (Test-Path $path)) { throw "Quelldatei nicht gefunden: $path" }
    $text = [System.IO.File]::ReadAllText($path, $latin1)
    return ($text -split "`r`n|`n")
}

# Sucht ab $from die erste Zeile, die auf $pattern passt. Liefert den Index.
function Find-Line($lines, [string]$pattern, [int]$from) {
    for ($i = $from; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match $pattern) { return $i }
    }
    throw "Muster nicht gefunden ab Zeile $($from + 1): $pattern"
}

function Write-Region($lines, [int]$first, [int]$last, [string]$outFile, [string]$srcName) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("// Automatisch erzeugt von Extract.ps1 - NICHT von Hand aendern.")
    [void]$sb.AppendLine("// Quelle: $srcName, Zeilen $($first + 1) bis $($last + 1)")
    [void]$sb.AppendLine("#line $($first + 1) `"$($srcName -replace '\\','/')`"")
    for ($i = $first; $i -le $last; $i++) {
        [void]$sb.AppendLine($lines[$i])
    }
    [System.IO.File]::WriteAllText($outFile, $sb.ToString(), $latin1)
    Write-Host ("Extract: {0,-28} <- {1} Zeilen {2}..{3}" -f (Split-Path $outFile -Leaf), (Split-Path $srcName -Leaf), ($first + 1), ($last + 1))
}

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

# ---------------------------------------------------------------- utils.cpp
$utilsPath = Join-Path $SrcDir "utils.cpp"
$u = Read-Lines $utilsPath

# Region A: Makros + Uebersetzungstabelle pcXlateTable
$aStart = Find-Line $u '^\s*#define\s+XLATE_CHARS\b' 0
$tabLine = Find-Line $u '^\s*unsigned char\s+pcXlateTable\b' $aStart
$aEnd = Find-Line $u '^\};\s*$' $tabLine
Write-Region $u $aStart $aEnd (Join-Path $OutDir "utils_table.inc") $utilsPath

# Region B: die Funktion ISOTranslate
$bStart = Find-Line $u '^\s*LONG\s+ISOTranslate\s*\(' 0
$bEnd = Find-Line $u '^\}\s*$' $bStart
Write-Region $u $bStart $bEnd (Join-Path $OutDir "utils_isotranslate.inc") $utilsPath

# ---------------------------------------------------------------- hexbin.cpp
$hexPath = Join-Path $SrcDir "hexbin.cpp"
$h = Read-Lines $hexPath

# Region C: Sonderwerte + BinHex-Dekodiertabelle
$cStart = Find-Line $h '^\s*const BYTE\s+RUNCHAR\b' 0
$hexTab = Find-Line $h '^\s*static const BYTE\s+HexBinTable\b' $cStart
$cEnd = Find-Line $h '^\};\s*$' $hexTab
Write-Region $h $cStart $cEnd (Join-Path $OutDir "hexbin_table.inc") $hexPath

Write-Host "Extract.ps1: fertig."
