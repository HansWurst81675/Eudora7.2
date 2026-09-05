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

# Region A2: die beiden UTF-8-Helfer, die vor ISOTranslate stehen
$a2Start = Find-Line $u '^\s*BOOL\s+ISOIsUTF8Charset\s*\(' 0
$a2Line = Find-Line $u '^\s*LONG\s+ISOIncompleteUTF8Tail\s*\(' $a2Start
$a2End = Find-Line $u '^\}\s*$' $a2Line
Write-Region $u $a2Start $a2End (Join-Path $OutDir "utils_utf8tail.inc") $utilsPath

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

# ---------------------------------------------------------------- Decode.h
# Die Basisklasse Decoder. Base64Decoder leitet davon ab.
$decHPath = Join-Path $SrcDir "Decode.h"
$dh = Read-Lines $decHPath
$dStart = Find-Line $dh '^\s*class\s+Decoder\b' 0
$dEnd = Find-Line $dh '^\};\s*$' $dStart
Write-Region $dh $dStart $dEnd (Join-Path $OutDir "decode_klasse.inc") $decHPath

# ---------------------------------------------------------------- Base64.h
$b64HPath = Join-Path $SrcDir "Base64.h"
$bh = Read-Lines $b64HPath
$eStart = Find-Line $bh '^\s*class\s+Base64Decoder\b' 0
$eEnd = Find-Line $bh '^\};\s*$' $eStart
Write-Region $bh $eStart $eEnd (Join-Path $OutDir "base64_klasse.inc") $b64HPath

# ---------------------------------------------------------------- Base64.cpp
$b64Path = Join-Path $SrcDir "Base64.cpp"
$b = Read-Lines $b64Path

# Region D: Sonderwerte, die Dekodiertabelle g_Decode und die sechs Bitschieber.
# Die Schieber (Bot2 ... Top6) stehen hinter der Tabelle und werden von
# Base64Decoder::Decode gebraucht, deshalb reicht die Region bis zum letzten davon.
$dTabStart = Find-Line $b '^\s*const BYTE\s+SKIP\b' 0
$dTabLine = Find-Line $b '^\s*static const BYTE\s+g_Decode\b' $dTabStart
$dTabEnd = Find-Line $b '^\};\s*$' $dTabLine
$dTabEnd = Find-Line $b '^\s*/\*inline\*/\s*BYTE\s+Top6\b' $dTabEnd
Write-Region $b $dTabStart $dTabEnd (Join-Path $OutDir "base64_table.inc") $b64Path

# Region E: Base64Decoder::Init und Base64Decoder::Decode
$dFunStart = Find-Line $b '^int\s+Base64Decoder::Init\b' 0
$dFunLine = Find-Line $b '^int\s+Base64Decoder::Decode\b' $dFunStart
$dFunEnd = Find-Line $b '^\}\s*$' $dFunLine
Write-Region $b $dFunStart $dFunEnd (Join-Path $OutDir "base64_decoder.inc") $b64Path

# ---------------------------------------------------------------- mime.cpp
$mimePath = Join-Path $SrcDir "mime.cpp"
$m = Read-Lines $mimePath

# Region F: FindMIMECharset - bildet den Zeichensatznamen auf den Tabellenindex ab
$fStart = Find-Line $m '^int\s+FindMIMECharset\s*\(' 0
$fEnd = Find-Line $m '^\}\s*$' $fStart
Write-Region $m $fStart $fEnd (Join-Path $OutDir "mime_findcharset.inc") $mimePath

# Region G: HEX und HexToString - von PseudoQP gebraucht
$gStart = Find-Line $m '^inline char HEX\s*\(' 0
$gLine = Find-Line $m '^void HexToString\s*\(' $gStart
$gEnd = Find-Line $m '^\}\s*$' $gLine
Write-Region $m $gStart $gEnd (Join-Path $OutDir "mime_hextostring.inc") $mimePath

# ---------------------------------------------------------------- lex822.cpp
$lexPath = Join-Path $SrcDir "lex822.cpp"
$l = Read-Lines $lexPath

# Region H: PseudoQP, DecodeB64String, Translate2047 und Fix2047 am Stueck.
# Das ist der Kopfzeilenpfad: aus "=?utf-8?B?...?=" wird lesbarer Text.
$hStart = Find-Line $l '^void\s+PseudoQP\s*\(' 0
$hLine = Find-Line $l '^BOOL\s+Fix2047\s*\(' $hStart
$hEnd = Find-Line $l '^\}\s*$' $hLine
Write-Region $l $hStart $hEnd (Join-Path $OutDir "lex822_2047.inc") $lexPath

Write-Host "Extract.ps1: fertig."
